report 7207374 "Segregate Comparative"
{
  
  
    ProcessingOnly=true;
    
  dataset
{

DataItem("ComparativeQuoteHeaderSource";"Comparative Quote Header")
{

               DataItemTableView=SORTING("No.");
DataItem("ComparativeQuoteLinesSource";"Comparative Quote Lines")
{

               DataItemTableView=SORTING("Quote No.","Line No.")
                                 WHERE("Qty to segregate"=FILTER(>0));
DataItemLink="Quote No."= FIELD("No.") ;
trigger OnPreDataItem();
    BEGIN 
                               Windows.OPEN(Text001 + Text002);

                               tLines := COUNT;  //JAV 05/08/19: - Se cambia COUNTAPROX pues est  obsoleto
                               nLines := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  nLines += 1;
                                  Windows.UPDATE(1,ROUND(nLines / tLines * 10000,1));

                                  //Creo la cabecera nueva
                                  IF (nLines = 1) THEN BEGIN 
                                    ComparativeQuoteHeader.INIT;
                                    ComparativeQuoteHeader.INSERT(TRUE);

                                    ComparativeQuoteHeader.VALIDATE("Job No.",ComparativeQuoteHeaderSource."Job No.");
                                    ComparativeQuoteHeader.VALIDATE(Description,ComparativeQuoteHeaderSource.Description);
                                    ComparativeQuoteHeader.VALIDATE("Shortcut Dimension 1 Code",ComparativeQuoteHeaderSource."Shortcut Dimension 1 Code");
                                    ComparativeQuoteHeader.VALIDATE("Shortcut Dimension 2 Code",ComparativeQuoteHeaderSource."Shortcut Dimension 2 Code");
                                    ComparativeQuoteHeader.VALIDATE("Comparative Type",ComparativeQuoteHeaderSource."Comparative Type");
                                    ComparativeQuoteHeader.VALIDATE("Comparative Date",ComparativeQuoteHeaderSource."Comparative Date");
                                    ComparativeQuoteHeader.VALIDATE("Location Code",ComparativeQuoteHeaderSource."Location Code");
                                    ComparativeQuoteHeader.VALIDATE("Activity Filter",ComparativeQuoteHeaderSource."Activity Filter");
                                    ComparativeQuoteHeader.MODIFY;
                                    CreateVendorConditions;
                                  END;

                                  //Copio la l¡nea
                                  ComparativeQuoteLines := ComparativeQuoteLinesSource;
                                  ComparativeQuoteLines."Quote No." := ComparativeQuoteHeader."No.";
                                  ComparativeQuoteLines.Quantity := ComparativeQuoteLinesSource."Qty to segregate";
                                  ComparativeQuoteLines."Qty to segregate" := 0;
                                  ComparativeQuoteLines.INSERT;

                                  //Quito la cantidad a segregar para que no se lance dos veces
                                  ComparativeQuoteLinesSource."Qty to segregate" := 0;
                                  ComparativeQuoteLinesSource.MODIFY;

                                  //Copio las condiciones particulares
                                  DataPricesVendor.SETRANGE("Quote Code",ComparativeQuoteLinesSource."Quote No.");
                                  DataPricesVendor.SETRANGE("Line No.",ComparativeQuoteLinesSource."Line No.");
                                  IF DataPricesVendor.FINDSET THEN
                                    REPEAT
                                      DataPricesVendorNew := DataPricesVendor;
                                      DataPricesVendorNew."Quote Code" := ComparativeQuoteHeader."No.";
                                      DataPricesVendorNew.INSERT;
                                    UNTIL DataPricesVendor.NEXT = 0;

                                  //Copio los tyextos adicionales
                                  QBText.CopyTo(QBText.Table::Comparativo, ComparativeQuoteLinesSource."Quote No.", FORMAT(ComparativeQuoteLinesSource."Line No."), '',
                                                QBText.Table::Comparativo, ComparativeQuoteLines."Quote No.", FORMAT(ComparativeQuoteLines."Line No."), '');

                                  //ComparativeQuoteLinesSource.DELETE(TRUE);
                                END;


}
}
}
  requestpage
  {

    layout
{
area(content)
{
group("group661")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';

}
}
  }
  }
  
  labels
{
}
  
    var
//       ComparativeQuoteHeader@7001103 :
      ComparativeQuoteHeader: Record 7207412;
//       ComparativeQuoteLines@7001116 :
      ComparativeQuoteLines: Record 7207413;
//       DataPricesVendor@7001117 :
      DataPricesVendor: Record 7207415;
//       DataPricesVendorNew@7001118 :
      DataPricesVendorNew: Record 7207415;
//       QBText@1100286000 :
      QBText: Record 7206918;
//       tLines@7001110 :
      tLines: Integer;
//       nLines@7001111 :
      nLines: Integer;
//       Windows@7001100 :
      Windows: Dialog;
//       Text001@7001109 :
      Text001: TextConst ENU='Generating comparative',ESP='"Generando comparativo "';
//       Text002@7001108 :
      Text002: TextConst ENU=' @1@@@@@@@@@@\',ESP=' @1@@@@@@@@@@\';
//       Text003@7001107 :
      Text003: TextConst ENU='Comparative Header        #2#####\',ESP='Nada que segregar';
//       Text004@7001102 :
      Text004: TextConst ENU='Comparative %1 has been generated',ESP='Se han generado el comparativo %1';

    

trigger OnPostReport();    begin
                   Windows.CLOSE;
                   if (nLines <> 0) then
                     MESSAGE(Text004,ComparativeQuoteHeader."No.")
                   else
                     MESSAGE(Text003);
                 end;



procedure CreateVendorConditions ()
    var
//       VendorConditionsData@7001100 :
      VendorConditionsData: Record 7207414;
//       OtherVendorConditions@7001101 :
      OtherVendorConditions: Record 7207416;
//       VendorConditionsDataNews@7001102 :
      VendorConditionsDataNews: Record 7207414;
//       OtherVendorConditionsNews@7001103 :
      OtherVendorConditionsNews: Record 7207416;
    begin
      VendorConditionsData.SETRANGE("Quote Code",ComparativeQuoteHeaderSource."No.");
      if VendorConditionsData.FINDSET then
        repeat
          VendorConditionsDataNews := VendorConditionsData;
          VendorConditionsDataNews."Quote Code" := ComparativeQuoteHeader."No.";
          VendorConditionsDataNews."Selected Vendor" := FALSE;
          VendorConditionsDataNews.INSERT;
        until VendorConditionsData.NEXT = 0;

      OtherVendorConditions.SETRANGE("Quote Code",ComparativeQuoteHeaderSource."No.");

      if OtherVendorConditions.FINDSET then
        repeat
          OtherVendorConditionsNews := OtherVendorConditions;
          OtherVendorConditionsNews."Quote Code" := ComparativeQuoteHeader."No.";
          OtherVendorConditionsNews.INSERT;
        until OtherVendorConditions.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 05/08/19: - Se cambia COUNTAPROX pues est  obsoleto
//    }
    end.
  */
  
}




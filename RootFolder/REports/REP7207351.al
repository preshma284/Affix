report 7207351 "Prod. Measurement Record Print"
{
  
  
    CaptionML=ENU='Prod. Measurement Record Print',ESP='Impresi¢n medici¢n prod. reg.';
  
  dataset
{

DataItem("Hist. Prod. Measure Header";"Hist. Prod. Measure Header")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               

               RequestFilterFields="No.";
Column(No_HistProdMeasureHeader;"Hist. Prod. Measure Header"."No.")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Header"."No.";
}Column(MeasureDate_HistProdMeasureHeader;"Hist. Prod. Measure Header"."Measure Date")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Header"."Measure Date";
}Column(MeasureNo_HistProdMeasureHeader;"Hist. Prod. Measure Header"."Measurement No.")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Header"."Measurement No.";
}Column(MeasureText_HistProdMeasureHeader;"Hist. Prod. Measure Header"."Measurement Text")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Header"."Measurement Text";
}Column(JobNo_HistProdMeasureHeader;"Hist. Prod. Measure Header"."Job No." + ' ' + "Hist. Prod. Measure Header".Description + ' ' + "Hist. Prod. Measure Header"."Description 2" + '          ')
{
//SourceExpr="Hist. Prod. Measure Header"."Job No." + ' ' + "Hist. Prod. Measure Header".Description + ' ' + "Hist. Prod. Measure Header"."Description 2" + '          ';
}Column(JobNo_HistProdMeasureHeader_Caption;"Hist. Prod. Measure Header".FIELDCAPTION("Job No."))
{
//SourceExpr="Hist. Prod. Measure Header".FIELDCAPTION("Job No.");
}Column(CustomerNo_HistProdMeasureHeader;"Hist. Prod. Measure Header"."Customer No.")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Header"."Customer No.";
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(Name_Customer;Customer.Name)
{
//SourceExpr=Customer.Name;
}DataItem("Hist. Prod. Measure Lines";"Hist. Prod. Measure Lines")
{

               DataItemTableView=SORTING("Document No.","Line No.")
                                 ORDER(Ascending);
DataItemLink="Document No."= FIELD("No.");
Column(PieceworkNo_HistProdMeasureLines;"Hist. Prod. Measure Lines"."Piecework No.")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Lines"."Piecework No.";
}Column(Description_HistProdMeasureLines;"Hist. Prod. Measure Lines".Description)
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Lines".Description;
}Column(Description_2_HistProdMeasureLines;"Hist. Prod. Measure Lines"."Description 2")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Lines"."Description 2";
}Column(MeasureAmount_HistProdMeasureLines;"Hist. Prod. Measure Lines"."Measure Term")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Lines"."Measure Term";
}Column(Amount_HistProdMeasureLines;"Hist. Prod. Measure Lines"."PROD Amount Term")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Lines"."PROD Amount Term";
}Column(SalesPrice_HistProdMeasureLines;"Hist. Prod. Measure Lines"."PROD Price")
{
IncludeCaption=true;
               //SourceExpr="Hist. Prod. Measure Lines"."PROD Price";
}Column(SignedAmount;SignedAmount)
{
//SourceExpr=SignedAmount;
}Column(NotSignedAmount;NotSignedAmount )
{
//SourceExpr=NotSignedAmount ;
}trigger OnPreDataItem();
    BEGIN 
                               SignedAmountTotal := 0;
                               NotSignedAmountTotal := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  SignedAmount := 0;
                                  NotSignedAmount := 0;
                                  DataPieceworkForProduction.GET("Hist. Prod. Measure Lines"."Job No.","Hist. Prod. Measure Lines"."Piecework No.");
                                  NotSignedAmount := "Hist. Prod. Measure Lines"."PROD Amount Term"*((100-DataPieceworkForProduction."% Processed Production")/100);  //JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado
                                  NotSignedAmountTotal += NotSignedAmount;
                                  SignedAmount := "Hist. Prod. Measure Lines"."PROD Amount Term"*(DataPieceworkForProduction."% Processed Production"/100);           //JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado
                                  SignedAmountTotal += SignedAmount;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("Hist. Prod. Measure Header"."No.");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF Customer.GET("Hist. Prod. Measure Header"."Customer No.") THEN;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
Page='Page/ P g./';
CustomerL='CUSTOMER/ CLIENTE/';
SignedAmountL='Signed Amount/ Importe Firmado/';
NotSignedAmountL='Not Signed Amount/ Importe No Firmado/';
MeasurementTotal='Measurement Total/ Total Medici¢n/';
}
  
    var
//       LastFieldNo@7001105 :
      LastFieldNo: Integer;
//       Customer@7001100 :
      Customer: Record 18;
//       SignedAmount@7001104 :
      SignedAmount: Decimal;
//       SignedAmountTotal@7001103 :
      SignedAmountTotal: Decimal;
//       NotSignedAmount@7001102 :
      NotSignedAmount: Decimal;
//       NotSignedAmountTotal@7001101 :
      NotSignedAmountTotal: Decimal;
//       DataPieceworkForProduction@7001106 :
      DataPieceworkForProduction: Record 7207386;

    /*begin
    {
      JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado
      JAV 24/06/22: - QB 1.10.52 Se cambia PEC por COST y se eliminan campos PEM que es mas apropiado
    }
    end.
  */
  
}




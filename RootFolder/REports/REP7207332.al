report 7207332 "Generate Worksheet"
{
  
  
    CaptionML=ENU='Generate Worksheet',ESP='Generar parte de trabajo Alqu.';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Usage Header Hist.";"Usage Header Hist.")
{

               DataItemTableView=SORTING("No.")
                                 WHERE("Contract Type"=CONST("Customer"));
               

               RequestFilterFields="No.";
DataItem("Usage Line Hist.";"Usage Line Hist.")
{

               DataItemTableView=SORTING("Document No.","Line No.");
DataItemLink="Document No."= FIELD("No.") ;
trigger OnAfterGetRecord();
    BEGIN 
                                  LineSheet("Usage Line Hist.");
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("No.");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Usage Header Hist."."Generated Worksheet" THEN
                                    CurrReport.SKIP;
                                  HeaderSheet("Usage Header Hist.");
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group528")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("Register";"Register")
    {
        
                  CaptionML=ENU='Automatically register sheets',ESP='Registrar partes autom ticamente';
    }

}

}
}
  }
  labels
{
}
  
    var
//       LastFieldNo@7001109 :
      LastFieldNo: Integer;
//       FooterPrinted@7001108 :
      FooterPrinted: Boolean;
//       WorksheetHeader@7001107 :
      WorksheetHeader: Record 7207290;
//       WorkSheetLines@7001106 :
      WorkSheetLines: Record 7207291;
//       FromSheet@7001105 :
      FromSheet: Code[20];
//       ToSheet@7001104 :
      ToSheet: Code[20];
//       Register@7001103 :
      Register: Boolean;
//       CUPostWorksheet@7001102 :
      CUPostWorksheet: Codeunit 7207270;
//       CounterOK@7001101 :
      CounterOK: Integer;
//       CounterTotal@7001100 :
      CounterTotal: Integer;
//       loctex7021500@7001111 :
      loctex7021500: TextConst ENU='Sheets %1 to %2 have been created',ESP='Se han creado los partes %1 a %2';
//       loctex7021501@7001110 :
      loctex7021501: TextConst ENU='%1 part/s of %2 have been registered',ESP='Se han registrado %1 parte/s de %2.';

    

trigger OnPostReport();    begin
                   if Register then begin
                     COMMIT;
                     WorksheetHeader.MARKEDONLY(TRUE);
                     if WorksheetHeader.FIND('-') then begin
                       repeat
                         CLEAR(CUPostWorksheet);
                         if CUPostWorksheet.RUN(WorksheetHeader) then begin
                           CounterOK := CounterOK + 1;
                           if WorksheetHeader.MARKEDONLY then
                             WorksheetHeader.MARK(FALSE);
                         end;
                       until WorksheetHeader.NEXT = 0;
                     end;
                   MESSAGE(loctex7021501,CounterOK,CounterTotal);
                   end else
                    MESSAGE(loctex7021500,FromSheet,ToSheet);
                 end;



// procedure HeaderSheet (LOUsageHeaderHist@1100251000 :
procedure HeaderSheet (LOUsageHeaderHist: Record 7207365)
    var
//       Loctexto@1100251001 :
      Loctexto: TextConst ENU='Usage Doc. %1 and contract %2',ESP='Doc Util.  %1 y contrato %2';
    begin
      WorksheetHeader.INIT;
      WorksheetHeader."No." := '';
      WorksheetHeader.INSERT(TRUE);
      WorksheetHeader."Sheet Type" := WorksheetHeader."Sheet Type"::"By Job";
      WorksheetHeader.VALIDATE("No. Resource /Job",LOUsageHeaderHist."Job No.");
      WorksheetHeader."Posting Date" := LOUsageHeaderHist."Posting Date";
      WorksheetHeader."Rental Machinery" := TRUE;
      WorksheetHeader.VALIDATE("Sheet Date",LOUsageHeaderHist."Usage Date");
      WorksheetHeader."Posting Description" := STRSUBSTNO(Loctexto,FORMAT(LOUsageHeaderHist."No."),FORMAT(LOUsageHeaderHist."Contract Code"));
      WorksheetHeader.MODIFY;
      WorksheetHeader.MARK(TRUE);
      CounterTotal := CounterTotal + 1;
      if FromSheet = '' then
        FromSheet := WorksheetHeader."No.";
      ToSheet := WorksheetHeader."No.";

      LOUsageHeaderHist."Generated Worksheet" := TRUE;
      LOUsageHeaderHist."Preassigned Sheet Draft No." := WorksheetHeader."No.";
      LOUsageHeaderHist.MODIFY;
    end;

//     procedure LineSheet (PaUsageLineHist@1100251000 :
    procedure LineSheet (PaUsageLineHist: Record 7207366)
    var
//       Line_@1100251001 :
      Line_: Integer;
//       LOWorkSheetLines@1100251002 :
      LOWorkSheetLines: Record 7207291;
//       LORentalElements@1100251003 :
      LORentalElements: Record 7207344;
//       LOResource@1100251004 :
      LOResource: Record 156;
//       LOElementContractLines@1100000 :
      LOElementContractLines: Record 7207354;
    begin
      WorkSheetLines.INIT;
      WorkSheetLines.SETRANGE(WorkSheetLines."Document No.",WorksheetHeader."No.");
      if WorkSheetLines.FIND('+') then
        Line_ := WorkSheetLines."Line No." + 10000
      else
        Line_ := 10000;
      WorkSheetLines."Document No." := WorksheetHeader."No.";
      WorkSheetLines."Line No." := Line_;
      WorkSheetLines.INSERT(TRUE);
      LORentalElements.GET(PaUsageLineHist."No.");
      LOResource.GET(LORentalElements."Invoicing Resource");
      WorkSheetLines.VALIDATE("Resource No.",LORentalElements."Invoicing Resource");
      WorkSheetLines.VALIDATE("Work Day Date",PaUsageLineHist."Application Date");
      WorkSheetLines.VALIDATE("Work Type Code",LORentalElements."Work Type");
      WorkSheetLines.VALIDATE(Quantity,PaUsageLineHist.Quantity * PaUsageLineHist."Usage Days");
      WorkSheetLines.VALIDATE("Sales Price",PaUsageLineHist."Unit Price");
      WorkSheetLines.VALIDATE("Piecework No.",PaUsageLineHist."Piecework Code");
      WorkSheetLines.VALIDATE("Direct Cost Price",PaUsageLineHist."Unit Price");
      WorkSheetLines.VALIDATE("Cost Price",PaUsageLineHist."Unit Price");
      LOElementContractLines.SETRANGE(LOElementContractLines."Document No.",PaUsageLineHist."Contract Code");
      LOElementContractLines.SETRANGE("No.",PaUsageLineHist."No.");
      LOElementContractLines.SETRANGE("Job No.",PaUsageLineHist."Job No.");
      LOElementContractLines.SETRANGE("Piecework Code",PaUsageLineHist."Piecework Code");
      LOElementContractLines.SETRANGE("Variant Code",PaUsageLineHist."Variant Code");
      if LOElementContractLines.FINDFIRST then
        WorkSheetLines.Description := LOElementContractLines.Description;

      WorkSheetLines.MODIFY;
    end;

    /*begin
    end.
  */
  
}




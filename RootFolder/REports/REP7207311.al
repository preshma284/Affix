report 7207311 "Hist. Expense Notes"
{
  
  
  ;
  dataset
{

DataItem("Hist. Expense Notes Header";"Hist. Expense Notes Header")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="Employee","Posting Date";
Column(Expense_notes_header_No;"No.")
{
//SourceExpr="No.";
}DataItem("Hist. Expense Notes Lines";"Hist. Expense Notes Lines")
{

               DataItemTableView=SORTING("Document No.","Line No");
DataItemLink="Document No."= FIELD("No.");
Column(CurrReport_PAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(Address;tableEmployee.Address)
{
//SourceExpr=tableEmployee.Address;
}Column(VAT_Registration_No;tableEmployee."VAT Registration No.")
{
//SourceExpr=tableEmployee."VAT Registration No.";
}Column(City;tableEmployee.City)
{
//SourceExpr=tableEmployee.City;
}Column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(Nombre;tableEmployee.Name)
{
//SourceExpr=tableEmployee.Name;
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(No__line__10000;"Line No")
{
//DecimalPlaces=0:0;
               //SourceExpr="Line No";
}Column(Hist_Lines_notes_expense__expense_concept_;"Expense Concept")
{
//SourceExpr="Expense Concept";
}Column(Hist_Lines_notes_expense__Total_Amount_;"Total Amount")
{
//SourceExpr="Total Amount";
}Column(Hist_Lines_notes_Expense__No__Job_;"Job No.")
{
//SourceExpr="Job No.";
}Column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
{
//SourceExpr=CurrReport_PAGENOCaptionLbl;
}Column(AddressCaption;AddressCaptionLbl)
{
//SourceExpr=AddressCaptionLbl;
}Column(VATRegistrationNoCaption;VATRegistrationNoCaptionLbl)
{
//SourceExpr=VATRegistrationNoCaptionLbl;
}Column(CityCaption;CityCaptionLbl)
{
//SourceExpr=CityCaptionLbl;
}Column(NameCaption;NameCaptionLbl)
{
//SourceExpr=NameCaptionLbl;
}Column(Lines_notes_expense__Total_Amount_Caption;FIELDCAPTION("Total Amount"))
{
//SourceExpr=FIELDCAPTION("Total Amount");
}Column(Lines_notes_expense__expense_concept_Caption;FIELDCAPTION("Expense Concept"))
{
//SourceExpr=FIELDCAPTION("Expense Concept");
}Column(N__justifiyingCaption;N__justifyingCaptionLbl)
{
//SourceExpr=N__justifyingCaptionLbl;
}Column(Travel_Expense_Notes_for_eventsLblCaption;Travel_Expense_Notes_for_eventsCaptionLbl)
{
//SourceExpr=Travel_Expense_Notes_for_eventsCaptionLbl;
}Column(Total_Expense_Note_Caption;Total_Expense_Note_CaptionLbl)
{
//SourceExpr=Total_Expense_Note_CaptionLbl;
}Column(Lines_notes_Expense_N__document;"Document No.")
{
//SourceExpr="Document No.";
}Column(Lines_notes_Expense_N__line;"Line No")
{
//SourceExpr="Line No";
}
}DataItem("Expense Concept";"Expense Concept")
{

               DataItemTableView=SORTING("Code");
               ;
Column(ExpenseConcept_Code;Code)
{
//SourceExpr=Code;
}Column(ExpenseConcept_Description;Description)
{
//SourceExpr=Description;
}Column(DecAmount;DecAmount)
{
//SourceExpr=DecAmount;
}Column(ExpenseConceptCodeCaption;FIELDCAPTION(Code))
{
//SourceExpr=FIELDCAPTION(Code);
}Column(ExpenseConceptDescriptionCaption;FIELDCAPTION(Description))
{
//SourceExpr=FIELDCAPTION(Description);
}Column(AmountCaption;AmountCaptionLbl )
{
//SourceExpr=AmountCaptionLbl ;
}trigger OnAfterGetRecord();
    BEGIN 
                                  DecAmount := 0;
                                  HistExpenseNotesLines.INIT;
                                  HistExpenseNotesLines.SETRANGE("Document No.","Hist. Expense Notes Header"."No.");
                                  HistExpenseNotesLines.SETRANGE("Expense Concept",Code);
                                  IF HistExpenseNotesLines.FINDSET(FALSE,FALSE) THEN BEGIN 
                                    REPEAT
                                      DecAmount += HistExpenseNotesLines."Total Amount";
                                    UNTIL HistExpenseNotesLines.NEXT = 0;
                                  END ELSE
                                    DecAmount := 0;
                                END;


}trigger OnAfterGetRecord();
    BEGIN 
                                  tableEmployee.GET(Employee);
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
}
  
    var
//       tableEmployee@7001103 :
      tableEmployee: Record 23;
//       ExpenseConcept@7001102 :
      ExpenseConcept: Record 7207325;
//       HistExpenseNotesLines@7001101 :
      HistExpenseNotesLines: Record 7207324;
//       DecAmount@7001100 :
      DecAmount: Decimal;
//       CurrReport_PAGENOCaptionLbl@7001112 :
      CurrReport_PAGENOCaptionLbl: TextConst ENU='Page',ESP='P g.';
//       AddressCaptionLbl@7001111 :
      AddressCaptionLbl: TextConst ENU='Address',ESP='Domicilio';
//       VATRegistrationNoCaptionLbl@7001110 :
      VATRegistrationNoCaptionLbl: TextConst ENU='VAT Registration No.',ESP='DNI';
//       CityCaptionLbl@7001109 :
      CityCaptionLbl: TextConst ENU='City',ESP='Poblaci¢n';
//       NameCaptionLbl@7001108 :
      NameCaptionLbl: TextConst ENU='Name',ESP='Nombre';
//       N__justifyingCaptionLbl@7001107 :
      N__justifyingCaptionLbl: TextConst ENU='No. Justifying',ESP='N§ justificante';
//       Travel_Expense_Notes_for_eventsCaptionLbl@7001106 :
      Travel_Expense_Notes_for_eventsCaptionLbl: TextConst ENU='Travel Expense Notes for Events',ESP='Nota de gastos de viajes para eventos';
//       Total_Expense_Note_CaptionLbl@7001105 :
      Total_Expense_Note_CaptionLbl: TextConst ENU='Total Expense Note:',ESP='Total nota de gastos:';
//       AmountCaptionLbl@7001104 :
      AmountCaptionLbl: TextConst ENU='Amount',ESP='Importe';

    /*begin
    end.
  */
  
}




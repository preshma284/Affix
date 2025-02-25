report 50005 "Resources by Piecework"
{
  
  
  ;
  dataset
{

DataItem("Data Cost By Piecework";"Data Cost By Piecework")
{

               DataItemTableView=SORTING("Job No.","Piecework Code","Cost Type","No.")
                                 WHERE("Cost Type"=FILTER("Resource"));
               ;
Column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(COMPANYNAME;COMPANYPROPERTY.DISPLAYNAME)
{
//SourceExpr=COMPANYPROPERTY.DISPLAYNAME;
}Column(CurrReport_PAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(NameReport;NameReport)
{
//SourceExpr=NameReport;
}Column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
{
//SourceExpr=CurrReport_PAGENOCaptionLbl;
}Column(JobNo_DataCost;"Job No.")
{
//SourceExpr="Job No.";
}Column(CodBudget_DataCost;"Cod. Budget")
{
//SourceExpr="Cod. Budget";
}Column(No_DataCost;"No.")
{
//SourceExpr="No.";
}Column(Description_DataCost;Description)
{
//SourceExpr=Description;
}Column(DirectCost_DataCost;"Direct Unitary Cost (JC)")
{
//SourceExpr="Direct Unitary Cost (JC)";
}Column(BudgetCost_DataCost;"Budget Cost")
{
//SourceExpr="Budget Cost";
}Column(ExpectedHours_DataCost;Performance)
{
//SourceExpr=Performance;
}Column(ExecutedHours_DataCost;"Conversion Factor")
{
//SourceExpr="Conversion Factor";
}Column(ExecutedParties_DataCost;Vendor)
{
//SourceExpr=Vendor;
}Column(Capt_CodBudget_DataCost;FIELDCAPTION("Cod. Budget"))
{
//SourceExpr=FIELDCAPTION("Cod. Budget");
}Column(Capt_No_DataCost;FIELDCAPTION("No."))
{
//SourceExpr=FIELDCAPTION("No.");
}Column(Capt_Description_DataCost;FIELDCAPTION(Description))
{
//SourceExpr=FIELDCAPTION(Description);
}Column(Capt_DirectCost_DataCost;FIELDCAPTION("Direct Unitary Cost (JC)"))
{
//SourceExpr=FIELDCAPTION("Direct Unitary Cost (JC)");
}Column(Capt_BudgetCost_DataCost;FIELDCAPTION("Budget Cost"))
{
//SourceExpr=FIELDCAPTION("Budget Cost");
}Column(Capt_ExpectedHours_DataCost;FIELDCAPTION(Performance))
{
//SourceExpr=FIELDCAPTION(Performance);
}Column(Capt_ExecutedHours_DataCost;FIELDCAPTION("Conversion Factor"))
{
//SourceExpr=FIELDCAPTION("Conversion Factor");
}Column(Capt_ExecutedParties_DataCost;FIELDCAPTION(Vendor))
{
//SourceExpr=FIELDCAPTION(Vendor);
}Column(ProbableWagesCaption;ProbableWagesCaptionLbl)
{
//SourceExpr=ProbableWagesCaptionLbl;
}Column(DefinitiveWagesCaption;DefinitiveWagesCaptionLbl )
{
//SourceExpr=DefinitiveWagesCaptionLbl ;
}trigger OnPreDataItem();
    BEGIN 
                               "Data Cost By Piecework".SETFILTER("Data Cost By Piecework"."Job No.",JobNo);
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
//       ProbableWagesCaptionLbl@1100286000 :
      ProbableWagesCaptionLbl: TextConst ENU='Probable wages',ESP='"Jornales probables "';
//       DefinitiveWagesCaptionLbl@1100286001 :
      DefinitiveWagesCaptionLbl: TextConst ENU='Definitive wages',ESP='Jornales definitivos';
//       NameReport@1100286002 :
      NameReport: TextConst ENU='Piecework Resources',ESP='Recursos en Descompuestos';
//       CurrReport_PAGENOCaptionLbl@1100286003 :
      CurrReport_PAGENOCaptionLbl: TextConst ENU='Page',ESP='P g.';
//       JobNo@1100286004 :
      JobNo: Code[20];

//     procedure PassParameters (PassJobNo@1100286000 :
    procedure PassParameters (PassJobNo: Code[20])
    begin
      JobNo := PassJobNo;
    end;

    /*begin
    end.
  */
  
}




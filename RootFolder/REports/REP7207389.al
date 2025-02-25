report 7207389 "Planned Indirectly Dis"
{
  
  
    CaptionML=ENU='Planned Indirectly Dis',ESP='Planificaci¢n indirectos desgl';
  
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               PrintOnlyIfDetail=true;
               

               RequestFilterFields="No.","Posting Date Filter";
Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(FORMATTODAY04;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(CurrReportPAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(IntMonth;IntMonth)
{
//SourceExpr=IntMonth;
}Column(IntAge;IntAge)
{
//SourceExpr=IntAge;
}Column(CompanyInformationPicture;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(CurrReportPAGENOCaptionLbl;CurrReport_PAGENOCaptionLbl)
{
//SourceExpr=CurrReport_PAGENOCaptionLbl;
}Column(REPORT_PLAN_FOR_INDIRECT_COSTS_OF_PROJECTED_LABORCaptionLbl;REPORT_PLAN_FOR_INDIRECT_COSTS_OF_PROJECTED_LABORCaptionLbl)
{
//SourceExpr=REPORT_PLAN_FOR_INDIRECT_COSTS_OF_PROJECTED_LABORCaptionLbl;
}Column(MONTH_CaptionLbl;MONTH_CaptionLbl)
{
//SourceExpr=MONTH_CaptionLbl;
}Column(AGE_CaptionLbl;AGE_CaptionLbl)
{
//SourceExpr=AGE_CaptionLbl;
}Column(JobNo;Job."No.")
{
//SourceExpr=Job."No.";
}Column(JobCurrentPieceworkBudget;Job."Current Piecework Budget")
{
//SourceExpr=Job."Current Piecework Budget";
}DataItem("Mayores";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Account Type"=CONST("Heading"),"Type"=CONST("Cost Unit"));
               PrintOnlyIfDetail=true;
DataItemLink="Job No."= FIELD("No."),
                            "Budget Filter"= FIELD("Current Piecework Budget");
Column(decPlannedOriginCost;decPlannedOriginCost)
{
//SourceExpr=decPlannedOriginCost;
}Column(TOTAL_OPERATIONCaptionLbl;TOTAL_OPERATIONCaptionLbl)
{
//SourceExpr=TOTAL_OPERATIONCaptionLbl;
}Column(MayoresJobNo;Mayores."Job No.")
{
//SourceExpr=Mayores."Job No.";
}Column(MayoresPieceworkCode;Mayores."Piecework Code")
{
//SourceExpr=Mayores."Piecework Code";
}Column(MayoresBudgetFilter;Mayores."Budget Filter")
{
//SourceExpr=Mayores."Budget Filter";
}DataItem("Mayores1";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Account Type"=CONST("Heading"),"Type"=CONST("Cost Unit"));
               PrintOnlyIfDetail=true;
DataItemLink="Job No."= FIELD("Job No.");
Column(JobNo_JobDescription;Job."No." + ' ' + Job.Description)
{
//SourceExpr=Job."No." + ' ' + Job.Description;
}Column(txtTitle;txtTitle)
{
//SourceExpr=txtTitle;
}Column(AMOUNTCaptionLbl;AMOUNTCaptionLbl)
{
//SourceExpr=AMOUNTCaptionLbl;
}Column(PRICECaptionLbl;PRICECaptionLbl)
{
//SourceExpr=PRICECaptionLbl;
}Column(QUANTITYCaptionLbl;QUANTITYCaptionLbl)
{
//SourceExpr=QUANTITYCaptionLbl;
}Column(CONCEPTCaptionLbl;CONCEPTCaptionLbl)
{
//SourceExpr=CONCEPTCaptionLbl;
}Column(DESCRIPTIONCaptionLbl;DESCRIPTIONCaptionLbl)
{
//SourceExpr=DESCRIPTIONCaptionLbl;
}Column(OPERATIONCaptionLbl;OPERATIONCaptionLbl)
{
//SourceExpr=OPERATIONCaptionLbl;
}Column(Mayores1JobNo;Mayores1."Job No.")
{
//SourceExpr=Mayores1."Job No.";
}Column(Mayores1PieceworkCode;Mayores1."Piecework Code")
{
//SourceExpr=Mayores1."Piecework Code";
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Type"=CONST("Cost Unit"),"Account Type"=CONST("Unit"));
               

               DataItemLinkReference="Job";
DataItemLink="Job No."= FIELD("No.");
Column(DataPieProdAmountCostBudget;"Data Piecework For Production"."Amount Cost Budget (JC)")
{
//SourceExpr="Data Piecework For Production"."Amount Cost Budget (JC)";
}Column(DataPieProdAverCostPricePendBudget;"Data Piecework For Production"."Aver. Cost Price Pend. Budget")
{
//SourceExpr="Data Piecework For Production"."Aver. Cost Price Pend. Budget";
}Column(DataPieProdBudgetMeasure;"Data Piecework For Production"."Budget Measure")
{
//SourceExpr="Data Piecework For Production"."Budget Measure";
}Column(DataPieceworkForProductionDescription;"Data Piecework For Production".Description)
{
//SourceExpr="Data Piecework For Production".Description;
}Column(Mayores1Description;Mayores1.Description)
{
//SourceExpr=Mayores1.Description;
}Column(Mayores_PieceworkCode;Mayores1."Piecework Code")
{
//SourceExpr=Mayores1."Piecework Code";
}Column(DataPieProdJobNo;"Data Piecework For Production"."Job No.")
{
//SourceExpr="Data Piecework For Production"."Job No.";
}Column(DataPieProdPieceworkCode;"Data Piecework For Production"."Piecework Code" )
{
//SourceExpr="Data Piecework For Production"."Piecework Code" ;
}trigger OnPreDataItem();
    BEGIN 
                               "Data Piecework For Production".SETFILTER("Piecework Code",Mayores1."Piecework Code"+'*');
                               "Data Piecework For Production".SETRANGE("Budget Filter",codeBudgetInCourse);
                               CurrReport.CREATETOTALS(decPlannedOriginCost);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  FunInitVar;
                                  "Data Piecework For Production".SETRANGE("Filter Date",0D,DateUntil);
                                  "Data Piecework For Production".CALCFIELDS("Budget Measure","Amount Cost Budget (JC)",
                                                                  "Aver. Cost Price Pend. Budget");
                                  decPlannedOriginCost := "Amount Cost Budget (JC)";
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               Mayores1.SETRANGE(Indentation,0,1);
                               Mayores1.SETFILTER("Piecework Code",Mayores."Piecework Code"+'*');
                               Mayores1.SETRANGE("Budget Filter",codeBudgetInCourse);

                               CurrReport.CREATETOTALS(decPlannedOriginCost);
                             END;


}trigger OnPreDataItem();
    BEGIN 
                               Mayores.SETRANGE(Indentation,0);
                               CurrReport.CREATETOTALS(decPlannedOriginCost);
                               Mayores.SETRANGE("Budget Filter",codeBudgetInCourse);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  txtTitle := Mayores.Description;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               IntAge:=DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"),3);
                               IntMonth:=DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"),2);

                               IF (IntAge = 0) OR (IntMonth = 0) THEN
                                 ERROR(Text50000);

                               DateSince := DMY2DATE(1,IntMonth,IntAge);
                               DateUntil := CALCDATE('PM',DateSince);

                               CompanyInformation.GET;
                               CompanyInformation.CALCFIELDS(Picture);


                               IF GETFILTER(Job."Budget Filter") <> '' THEN
                                 codeBudgetInCourse := GETFILTER(Job."Budget Filter")
                               ELSE BEGIN 
                                 IF Job."Current Piecework Budget" <> '' THEN
                                   codeBudgetInCourse := Job."Current Piecework Budget"
                                 ELSE
                                   codeBudgetInCourse := Job."Initial Budget Piecework";
                               END;

                               Job.SETRANGE("Budget Filter",codeBudgetInCourse);

                               Job.SETRANGE("Posting Date Filter",0D,DateUntil);

                               Job.CALCFIELDS("Actual Production Amount");
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
//       LastFieldNo@7001110 :
      LastFieldNo: Integer;
//       FooterPrinted@7001109 :
      FooterPrinted: Boolean;
//       IntAge@7001108 :
      IntAge: Integer;
//       IntMonth@7001107 :
      IntMonth: Integer;
//       DateSince@7001106 :
      DateSince: Date;
//       DateUntil@7001105 :
      DateUntil: Date;
//       decPlannedOriginCost@7001104 :
      decPlannedOriginCost: Decimal;
//       txtTitle@7001103 :
      txtTitle: Text[50];
//       kk@7001102 :
      kk: Decimal;
//       CompanyInformation@7001101 :
      CompanyInformation: Record 79;
//       codeBudgetInCourse@7001100 :
      codeBudgetInCourse: Code[20];
//       Text50000@7001122 :
      Text50000: TextConst ENU='You must indicate year and month of the Job report',ESP='Debe indicicar A¤o y mes del informe de obra';
//       CurrReport_PAGENOCaptionLbl@7001121 :
      CurrReport_PAGENOCaptionLbl: TextConst ENU='Page',ESP='P gina';
//       REPORT_PLAN_FOR_INDIRECT_COSTS_OF_PROJECTED_LABORCaptionLbl@7001120 :
      REPORT_PLAN_FOR_INDIRECT_COSTS_OF_PROJECTED_LABORCaptionLbl: TextConst ENU='REPORT PLAN FOR INDIRECT COSTS OF PROJECTED LABOR',ESP='INFORME PLANIFICACIàN DE COSTES INDIRECTOS DE OBRA DESGLOSADO';
//       MONTH_CaptionLbl@7001119 :
      MONTH_CaptionLbl: TextConst ENU='MONTH :',ESP='MES:';
//       AGE_CaptionLbl@7001118 :
      AGE_CaptionLbl: TextConst ENU='AGE:',ESP='A¥O:';
//       TOTAL_OPERATIONCaptionLbl@7001117 :
      TOTAL_OPERATIONCaptionLbl: TextConst ENU='TOTAL OPERATION',ESP='TOTAL OPERACIàN';
//       AMOUNTCaptionLbl@7001116 :
      AMOUNTCaptionLbl: TextConst ENU='AMOUNT',ESP='IMPORTE';
//       PRICECaptionLbl@7001115 :
      PRICECaptionLbl: TextConst ENU='PRICE',ESP='PRECIO';
//       QUANTITYCaptionLbl@7001114 :
      QUANTITYCaptionLbl: TextConst ENU='QUANTITY',ESP='CANTIDAD';
//       CONCEPTCaptionLbl@7001113 :
      CONCEPTCaptionLbl: TextConst ENU='CONCEPT',ESP='CONCEPTOS';
//       DESCRIPTIONCaptionLbl@7001112 :
      DESCRIPTIONCaptionLbl: TextConst ENU='DESCRIPTION',ESP='DESCRIPCIàN';
//       OPERATIONCaptionLbl@7001111 :
      OPERATIONCaptionLbl: TextConst ENU='OPERATION',ESP='OPERACIàN';
//       Spaces@7001123 :
      Spaces: Text[30];

    LOCAL procedure FunInitVar ()
    begin
      decPlannedOriginCost := 0;
    end;

    /*begin
    end.
  */
  
}




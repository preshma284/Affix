report 7207394 "Deferred Anticipated Expenses"
{
  
  
  ;
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
Column(Job_No;Job."No.")
{
//SourceExpr=Job."No.";
}Column(JobCurrentPieceworkBudget;Job."Current Piecework Budget")
{
//SourceExpr=Job."Current Piecework Budget";
}Column(captionprueba;LABELPRUEBA)
{
//SourceExpr=LABELPRUEBA;
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(JOB_REAL_COSTCaptionLbl;JOB_REAL_COSTCaptionLbl)
{
//SourceExpr=JOB_REAL_COSTCaptionLbl;
}Column(CurrReport_PAGENOCaptionLbl;CurrReport_PAGENOCaptionLbl)
{
//SourceExpr=CurrReport_PAGENOCaptionLbl;
}Column(INDIRECT_COSTCaptionLbl;INDIRECT_COSTCaptionLbl)
{
//SourceExpr=INDIRECT_COSTCaptionLbl;
}Column(Job__No___________Job_DescriptionCaptionLbl;Job__No___________Job_DescriptionCaptionLbl)
{
//SourceExpr=Job__No___________Job_DescriptionCaptionLbl;
}Column(AGE_CaptionLbl;AGE_CaptionLbl)
{
//SourceExpr=AGE_CaptionLbl;
}Column(MONTH_CaptionLbl;MONTH_CaptionLbl)
{
//SourceExpr=MONTH_CaptionLbl;
}Column(OPERACIONCaptionLbl;OPERACIONCaptionLbl)
{
//SourceExpr=OPERACIONCaptionLbl;
}Column(PREVISION_IN_MASTERCaptionLbl;PREVISION_IN_MASTERCaptionLbl)
{
//SourceExpr=PREVISION_IN_MASTERCaptionLbl;
}Column(AGECaptionLbl;AGECaptionLbl)
{
//SourceExpr=AGECaptionLbl;
}Column(DESCRIPTIONCaptionLbl;DESCRIPTIONCaptionLbl)
{
//SourceExpr=DESCRIPTIONCaptionLbl;
}Column(MONTHCaptionLbl;MONTHCaptionLbl)
{
//SourceExpr=MONTHCaptionLbl;
}Column(ORIGINCaptionLbl;ORIGINCaptionLbl)
{
//SourceExpr=ORIGINCaptionLbl;
}Column(REAL_COSTCaptionLbl;REAL_COSTCaptionLbl)
{
//SourceExpr=REAL_COSTCaptionLbl;
}Column(PENDINGCaptionLbl;PENDINGCaptionLbl)
{
//SourceExpr=PENDINGCaptionLbl;
}Column(AGECaption_Control1100251022Lbl;AGECaption_Control1100251022Lbl)
{
//SourceExpr=AGECaption_Control1100251022Lbl;
}Column(MONTHCaption_Control1100251007Lbl;MONTHCaption_Control1100251007Lbl)
{
//SourceExpr=MONTHCaption_Control1100251007Lbl;
}Column(AMORTIZECaptionLbl;AMORTIZECaptionLbl)
{
//SourceExpr=AMORTIZECaptionLbl;
}Column(ORIGINCaption_Control1100251097Lbl;ORIGINCaption_Control1100251097Lbl)
{
//SourceExpr=ORIGINCaption_Control1100251097Lbl;
}Column(O_E_CaptionLbl;O_E_CaptionLbl)
{
//SourceExpr=O_E_CaptionLbl;
}Column(PDG__AMORTIZE_S__BASECaptionLbl;PDG__AMORTIZE_S__BASECaptionLbl)
{
//SourceExpr=PDG__AMORTIZE_S__BASECaptionLbl;
}Column(O_E_Caption_Control1100251042Lbl;O_E_Caption_Control1100251042Lbl)
{
//SourceExpr=O_E_Caption_Control1100251042Lbl;
}Column(ESTIMATED_AMORTIZED_BASECaptionLbl;ESTIMATED_AMORTIZED_BASECaptionLbl)
{
//SourceExpr=ESTIMATED_AMORTIZED_BASECaptionLbl;
}Column(TOTALCaptionLbl;TOTALCaptionLbl)
{
//SourceExpr=TOTALCaptionLbl;
}Column(IntAge;IntAge)
{
//SourceExpr=IntAge;
}Column(IntMonth;IntMonth)
{
//SourceExpr=IntMonth;
}Column(CompanyInformationPicture;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(txtTitle;txtTitle)
{
//SourceExpr=txtTitle;
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Type"=CONST("Cost Unit"),"Type Unit Cost"=CONST("Internal"));
DataItemLink="Job No."= FIELD("No."),
                            "Budget Filter"= FIELD("Current Piecework Budget");
Column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(CurrReport_PAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(Job__No___________Job_Description;Job."No." + ' ' + Job.Description)
{
//SourceExpr=Job."No." + ' ' + Job.Description;
}Column(DPFP_Description;"Data Piecework For Production".Description)
{
//SourceExpr="Data Piecework For Production".Description;
}Column(CostPlannedOriginMAY;CostPlannedOriginMAY)
{
//SourceExpr=CostPlannedOriginMAY;
}Column(CostMonthMAY;CostMonthMAY)
{
//SourceExpr=CostMonthMAY;
}Column(CostAgeMAY;CostAgeMAY)
{
//SourceExpr=CostAgeMAY;
}Column(CostOriginMAY;CostOriginMAY)
{
//SourceExpr=CostOriginMAY;
}Column(PendingMAY;PendingMAY)
{
//SourceExpr=PendingMAY;
}Column(CostPlannedOriginMAY_Control1100251152;CostPlannedOriginMAY)
{
//SourceExpr=CostPlannedOriginMAY;
}Column(OverBudgetMAY;OverBudgetMAY)
{
//SourceExpr=OverBudgetMAY;
}Column(AmortMonthMAY;AmortMonthMAY)
{
//SourceExpr=AmortMonthMAY;
}Column(AmortAgeMAY;AmortAgeMAY)
{
//SourceExpr=AmortAgeMAY;
}Column(AmortOriginMAY;AmortOriginMAY)
{
//SourceExpr=AmortOriginMAY;
}Column(OverPendingMAY;OverPendingMAY)
{
//SourceExpr=OverPendingMAY;
}Column(PendingAmortizeMAY;PendingAmortizeMAY)
{
//SourceExpr=PendingAmortizeMAY;
}Column(DPFP_PieceworkCode__Control1100251011;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(DPFP_UnitOfMeasure;"Data Piecework For Production"."Unit Of Measure")
{
//SourceExpr="Data Piecework For Production"."Unit Of Measure";
}Column(DPFP_Description_Control1100251017;"Data Piecework For Production".Description)
{
//SourceExpr="Data Piecework For Production".Description;
}Column(CostPlannedOrigin;CostPlannedOrigin)
{
//SourceExpr=CostPlannedOrigin;
}Column(CostMonth;CostMonth)
{
//SourceExpr=CostMonth;
}Column(CostOrigin;CostOrigin)
{
//SourceExpr=CostOrigin;
}Column(CostAge;CostAge)
{
//SourceExpr=CostAge;
}Column(AmortMonth;AmortMonth)
{
//SourceExpr=AmortMonth;
}Column(AmortAge;AmortAge)
{
//SourceExpr=AmortAge;
}Column(AmortOrigin;AmortOrigin)
{
//SourceExpr=AmortOrigin;
}Column(Pending;Pending)
{
//SourceExpr=Pending;
}Column(OverBudget;OverBudget)
{
//SourceExpr=OverBudget;
}Column(CostPlannedOrigin_Control1100251047;CostPlannedOrigin)
{
//SourceExpr=CostPlannedOrigin;
}Column(OverPending;OverPending)
{
//SourceExpr=OverPending;
}Column(PendingAmortize;PendingAmortize)
{
//SourceExpr=PendingAmortize;
}Column(PendingAmortize_Control1100251044;PendingAmortize)
{
//SourceExpr=PendingAmortize;
}Column(OverPending_Control1100251062;OverPending)
{
//SourceExpr=OverPending;
}Column(AmortOrigin_Control1100251070;AmortOrigin)
{
//SourceExpr=AmortOrigin;
}Column(AmortAge_Control1100251082;AmortAge)
{
//SourceExpr=AmortAge;
}Column(AmortMonth_Control1100251087;AmortMonth)
{
//SourceExpr=AmortMonth;
}Column(OverBudget_Control1100251095;OverBudget)
{
//SourceExpr=OverBudget;
}Column(CostPlannedOrigin_Control1100251101;CostPlannedOrigin)
{
//SourceExpr=CostPlannedOrigin;
}Column(Pending_Control1100251106;Pending)
{
//SourceExpr=Pending;
}Column(CostOrigin_Control1100251111;CostOrigin)
{
//SourceExpr=CostOrigin;
}Column(CostAge_Control1100251114;CostAge)
{
//SourceExpr=CostAge;
}Column(CostMonth_Control1100251123;CostMonth)
{
//SourceExpr=CostMonth;
}Column(CostPlannedOrigin_Control1100251125;CostPlannedOrigin)
{
//SourceExpr=CostPlannedOrigin;
}Column(DPFP_JobNo;"Data Piecework For Production"."Job No.")
{
//SourceExpr="Data Piecework For Production"."Job No.";
}Column(DPFP_BudgetFilter;"Data Piecework For Production"."Budget Filter")
{
//SourceExpr="Data Piecework For Production"."Budget Filter";
}Column(DPFP_PieceworkCode;"Data Piecework For Production"."Piecework Code" )
{
//SourceExpr="Data Piecework For Production"."Piecework Code" ;
}trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("Job No.");

                               CurrReport.CREATETOTALS(CostMonth,CostOrigin,CostAge,CostPlannedMonth,CostPlannedOrigin,
                                                       AmortPlannedOrigin,
                                                       OverBudget,OverPending,AmortMonth,AmortAge);

                               CurrReport.CREATETOTALS(Pending,AmortOrigin);

                               txtTitle := 'ANTICIPATED AND DEFERRED';
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  "Data Piecework For Production".SETRANGE("Budget Filter",BudgetOfCourse);

                                  IF ("Data Piecework For Production"."Subtype Cost" <> "Data Piecework For Production"."Subtype Cost"::"Deprec. Anticipated") AND
                                     ("Data Piecework For Production"."Subtype Cost" <> "Data Piecework For Production"."Subtype Cost"::"Deprec. Deferred" )THEN
                                      CurrReport.SKIP;

                                  FunInitvar;

                                  IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN 
                                    SETRANGE("Data Piecework For Production"."Filter Date");
                                    CALCFIELDS("Amount Cost Budget (JC)","Data Piecework For Production"."Amount Production Budget","Data Piecework For Production"."Planned Expense");
                                    IF "Data Piecework For Production"."Planned Expense" <> 0 THEN
                                      CostPlannedOrigin := "Planned Expense"
                                    ELSE
                                      CostPlannedOrigin := "Amount Cost Budget (JC)";

                                    AmortPlannedOrigin := "Amount Cost Budget (JC)";
                                    IF TotalAmount <> 0 THEN
                                      OverBudget := ROUND(CostPlannedOrigin * 100/
                                                           TotalAmount,0.0001)
                                    ELSE
                                      OverBudget := 0;

                                    SETRANGE("Filter Date",DateSince,DateUntil);
                                    CALCFIELDS("Amount Cost Budget (JC)","Data Piecework For Production"."Amount Cost Performed (JC)","Data Piecework For Production"."Amount Cost Incurred W/C (LCY)");
                                    IF DateUntil < BudgetJob."Budget Date" THEN
                                      CostPlannedMonth := 0
                                    ELSE
                                      CostPlannedMonth := "Amount Cost Budget (JC)";
                                    CostMonth := "Amount Cost Incurred W/C (LCY)";

                                    SETRANGE("Data Piecework For Production"."Filter Date",DateInitAge,DateUntil);
                                    CALCFIELDS("Data Piecework For Production"."Amount Cost Performed (JC)","Amount Cost Incurred W/C (LCY)");
                                    CostAge := "Amount Cost Incurred W/C (LCY)";
                                  //  CostPlannedAge := "Amount Cost Budget";
                                    IF BudgetJob."Budget Date" <> 0D THEN
                                      SETRANGE("Data Piecework For Production"."Filter Date",DateInitAge,BudgetJob."Budget Date"-1)
                                    ELSE
                                      SETRANGE("Data Piecework For Production"."Filter Date",DateInitAge,0D);
                                    CostPlannedAge := "Amount Cost Performed (JC)";
                                    SETRANGE("Data Piecework For Production"."Filter Date",BudgetJob."Budget Date",DateUntil);
                                    CALCFIELDS("Amount Cost Budget (JC)");
                                    CostPlannedAge := CostPlannedAge + "Amount Cost Budget (JC)";

                                    SETRANGE("Data Piecework For Production"."Filter Date",0D,DateUntil);
                                    CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)","Amount Cost Incurred W/C (LCY)");
                                    CostOrigin := "Amount Cost Incurred W/C (LCY)";

                                    Pending := CostPlannedOrigin - CostOrigin;

                                    AmortMonth := ROUND(ProductionMonth * OverBudget / 100,0.01);
                                    AmortAge := ROUND(ProductionAge * OverBudget / 100,0.01);
                                    AmortOrigin := ROUND(ProductionOrigin * OverBudget / 100,0.01);

                                    PendingAmortize := AmortPlannedOrigin - AmortOrigin;

                                    IF JobExecutePending <> 0 THEN
                                      OverPending := ROUND(PendingAmortize * 100 /
                                                                     JobExecutePending,0.0001)
                                    ELSE
                                      OverPending := 0;
                                  END ELSE BEGIN 
                                    JobUnit.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
                                    JobUnit.SETFILTER("Piecework Code","Data Piecework For Production".Totaling);
                                    JobUnit.SETRANGE("Account Type",JobUnit."Account Type"::Unit);
                                    JobUnit.SETRANGE("Budget Filter",BudgetOfCourse);
                                    IF JobUnit.FINDSET THEN
                                      REPEAT
                                        JobUnit.SETRANGE("Filter Date");
                                        JobUnit.CALCFIELDS("Amount Cost Budget (JC)","Amount Production Budget","Planned Expense");

                                        IF JobUnit."Planned Expense" <> 0 THEN
                                          CostPlannedOriginMAY := CostPlannedOriginMAY + JobUnit."Planned Expense"
                                        ELSE
                                          CostPlannedOriginMAY := CostPlannedOriginMAY + JobUnit."Amount Cost Budget (JC)";
                                        AmortPlannedOriginMAY := AmortPlannedOriginMAY + JobUnit."Amount Cost Budget (JC)";

                                        JobUnit.SETRANGE("Filter Date",DateSince,DateUntil);
                                        JobUnit.CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)","Amount Cost Incurred W/C (LCY)");
                                        IF DateUntil < BudgetJob."Budget Date" THEN
                                          CostPlannedMonthMAY := CostPlannedMonthMAY + 0
                                        ELSE
                                          CostPlannedMonthMAY := CostPlannedMonthMAY + JobUnit."Amount Cost Budget (JC)";
                                        CostMonthMAY := CostMonthMAY + JobUnit."Amount Cost Incurred W/C (LCY)";

                                        JobUnit.SETRANGE("Filter Date",DateInitAge,DateUntil);
                                        JobUnit.CALCFIELDS("Amount Cost Performed (JC)","Amount Cost Incurred W/C (LCY)");
                                        CostAgeMAY := CostAgeMAY + JobUnit."Amount Cost Incurred W/C (LCY)";
                                        IF BudgetJob."Budget Date" <> 0D THEN
                                          JobUnit.SETRANGE("Filter Date",DateInitAge,BudgetJob."Budget Date"-1)
                                        ELSE
                                          JobUnit.SETRANGE("Filter Date",DateInitAge,0D);
                                        CostPlannedAgeMAY := CostPlannedAgeMAY + JobUnit."Amount Cost Performed (JC)";
                                        JobUnit.SETRANGE("Filter Date",BudgetJob."Budget Date",DateUntil);
                                        JobUnit.CALCFIELDS("Amount Cost Budget (JC)");
                                        CostPlannedAgeMAY := CostPlannedAgeMAY + JobUnit."Amount Cost Budget (JC)";

                                        JobUnit.SETRANGE("Filter Date",0D,DateUntil);
                                        JobUnit.CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)","Amount Cost Incurred W/C (LCY)");
                                        CostOriginMAY := CostOriginMAY + JobUnit."Amount Cost Incurred W/C (LCY)";
                                      UNTIL JobUnit.NEXT = 0;

                                    IF TotalAmount <> 0 THEN
                                      OverBudgetMAY := ROUND(CostPlannedOriginMAY * 100/TotalAmount,0.0001)
                                    ELSE
                                      OverBudgetMAY := 0;
                                    PendingMAY := CostPlannedOriginMAY - CostOriginMAY;
                                    AmortMonthMAY := ROUND(ProductionMonth * OverBudgetMAY / 100,0.01);
                                    AmortAge := ROUND(ProductionAge * OverBudgetMAY / 100,0.01);
                                    AmortOriginMAY := ROUND(ProductionOrigin * OverBudgetMAY / 100,0.01);
                                    PendingAmortizeMAY := AmortPlannedOriginMAY - AmortOriginMAY;
                                    IF JobExecutePending <> 0 THEN
                                      OverPendingMAY := ROUND(PendingAmortizeMAY * 100 /JobExecutePending,0.0001)
                                    ELSE
                                      OverPendingMAY := 0;
                                  END;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               IF (IntAge = 0) OR (IntMonth = 0) THEN
                                 ERROR(Text50000);


                               DateSince := DMY2DATE(1,IntMonth,IntAge);
                               DateUntil := CALCDATE('PM',DateSince);
                               DateInitAge :=  DMY2DATE(1,1,IntAge);

                               CurrReport.CREATETOTALS(CostMonth,CostOrigin,CostPlannedMonth,CostPlannedOrigin);

                               CLEAR(Currency);
                               Currency.InitRoundingPrecision;

                               CompanyInformation.GET;
                               CompanyInformation.CALCFIELDS(Picture);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF GETFILTER(Job."Budget Filter") <> '' THEN
                                    BudgetOfCourse := GETFILTER(Job."Budget Filter")
                                  ELSE BEGIN 
                                    IF Job."Current Piecework Budget" <> '' THEN
                                      BudgetOfCourse := Job."Current Piecework Budget"
                                    ELSE
                                      BudgetOfCourse := Job."Initial Budget Piecework";
                                  END;

                                  BudgetJob.GET("No.",BudgetOfCourse);

                                  Job.SETRANGE("Budget Filter",BudgetOfCourse);

                                  SETRANGE("Posting Date Filter");
                                  CALCFIELDS(Job."Production Budget Amount");
                                  TotalAmount := Job."Production Budget Amount";

                                  SETRANGE("Posting Date Filter",DateSince,DateUntil);
                                  CALCFIELDS(Job."Actual Production Amount");
                                  ProductionMonth := "Actual Production Amount" - Job.ProductionTheoricalProcess;

                                  SETRANGE("Posting Date Filter",DateInitAge,DateUntil);
                                  CALCFIELDS(Job."Actual Production Amount");
                                  ProductionAge := "Actual Production Amount"  - Job.ProductionTheoricalProcess;

                                  SETRANGE("Posting Date Filter",0D,DateUntil);
                                  CALCFIELDS(Job."Actual Production Amount");
                                  ProductionOrigin := (Job."Actual Production Amount" - Job.ProductionTheoricalProcess);

                                  SETRANGE("Posting Date Filter",0D,DateUntil);
                                  CALCFIELDS(Job."Actual Production Amount");
                                  JobExecutePending := TotalAmount - (Job."Actual Production Amount" - Job.ProductionTheoricalProcess);
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group723")
{
        

}
    field("A¤o Inicio";"IntAge")
    {
        
    }
    field("Mes Inicio";"IntMonth")
    {
        
    }

}
}
  }
  labels
{
}
  
    var
//       LastFieldNo@7001152 :
      LastFieldNo: Integer;
//       FooterPrinted@7001151 :
      FooterPrinted: Boolean;
//       IntAge@7001150 :
      IntAge: Integer;
//       IntMonth@7001149 :
      IntMonth: Integer;
//       DateSince@7001148 :
      DateSince: Date;
//       DateUntil@7001147 :
      DateUntil: Date;
//       DateInitAge@7001146 :
      DateInitAge: Date;
//       CostMonth@7001145 :
      CostMonth: Decimal;
//       CostAge@7001144 :
      CostAge: Decimal;
//       CostOrigin@7001143 :
      CostOrigin: Decimal;
//       CostPlannedMonth@7001142 :
      CostPlannedMonth: Decimal;
//       CostPlannedAge@7001141 :
      CostPlannedAge: Decimal;
//       CostPlannedOrigin@7001140 :
      CostPlannedOrigin: Decimal;
//       OverBudget@7001139 :
      OverBudget: Decimal;
//       DeviationOrigin@7001138 :
      DeviationOrigin: Decimal;
//       DeviationMonth@7001137 :
      DeviationMonth: Decimal;
//       DeviationAge@7001136 :
      DeviationAge: Decimal;
//       AmortMonth@7001135 :
      AmortMonth: Decimal;
//       AmortAge@7001134 :
      AmortAge: Decimal;
//       AmortOrigin@7001133 :
      AmortOrigin: Decimal;
//       Currency@7001132 :
      Currency: Record 4;
//       IntSinceMonth@7001131 :
      IntSinceMonth: Integer;
//       Pending@7001130 :
      Pending: Decimal;
//       CompanyInformation@7001129 :
      CompanyInformation: Record 79;
//       OverPending@7001128 :
      OverPending: Decimal;
//       TotalAmount@7001127 :
      TotalAmount: Decimal;
//       txtTitle@7001126 :
      txtTitle: Text[60];
//       PendingAmortize@7001125 :
      PendingAmortize: Decimal;
//       ProductionMonth@7001124 :
      ProductionMonth: Decimal;
//       ProductionAge@7001123 :
      ProductionAge: Decimal;
//       ProductionOrigin@7001122 :
      ProductionOrigin: Decimal;
//       CostMonthMAY@7001121 :
      CostMonthMAY: Decimal;
//       CostAgeMAY@7001120 :
      CostAgeMAY: Decimal;
//       CostOriginMAY@7001119 :
      CostOriginMAY: Decimal;
//       CostPlannedMonthMAY@7001118 :
      CostPlannedMonthMAY: Decimal;
//       CostPlannedAgeMAY@7001117 :
      CostPlannedAgeMAY: Decimal;
//       CostPlannedOriginMAY@7001116 :
      CostPlannedOriginMAY: Decimal;
//       OverBudgetMAY@7001115 :
      OverBudgetMAY: Decimal;
//       DeviationOriginMAY@7001114 :
      DeviationOriginMAY: Decimal;
//       DeviationMonthMAY@7001113 :
      DeviationMonthMAY: Decimal;
//       DeviationAgeMAY@7001112 :
      DeviationAgeMAY: Decimal;
//       AmortMonthMAY@7001111 :
      AmortMonthMAY: Decimal;
//       AmortAgeMAY@7001110 :
      AmortAgeMAY: Decimal;
//       AmortOriginMAY@7001109 :
      AmortOriginMAY: Decimal;
//       PendingMAY@7001108 :
      PendingMAY: Decimal;
//       OverPendingMAY@7001107 :
      OverPendingMAY: Decimal;
//       PendingAmortizeMAY@7001106 :
      PendingAmortizeMAY: Decimal;
//       JobUnit@7001105 :
      JobUnit: Record 7207386;
//       JobExecutePending@7001104 :
      JobExecutePending: Decimal;
//       AmortPlannedOrigin@7001103 :
      AmortPlannedOrigin: Decimal;
//       AmortPlannedOriginMAY@7001102 :
      AmortPlannedOriginMAY: Decimal;
//       BudgetOfCourse@7001101 :
      BudgetOfCourse: Code[20];
//       BudgetJob@7001100 :
      BudgetJob: Record 7207407;
//       Text50000@7001176 :
      Text50000: TextConst ENU='Must indicate year and month of the Job report',ESP='Debe indicicar A¤o y mes del informe de obra';
//       JOB_REAL_COSTCaptionLbl@7001175 :
      JOB_REAL_COSTCaptionLbl: TextConst ENU='JOB REAL COST',ESP='COSTE REAL DE OBRA';
//       CurrReport_PAGENOCaptionLbl@7001174 :
      CurrReport_PAGENOCaptionLbl: TextConst ENU='page',ESP='P gina';
//       INDIRECT_COSTCaptionLbl@7001173 :
      INDIRECT_COSTCaptionLbl: TextConst ENU='INDIRECT COST',ESP='COSTE INDIRECTO';
//       Job__No___________Job_DescriptionCaptionLbl@7001172 :
      Job__No___________Job_DescriptionCaptionLbl: TextConst ENU='JOB:',ESP='OBRA:';
//       AGE_CaptionLbl@7001171 :
      AGE_CaptionLbl: TextConst ENU='AGE:',ESP='A¥O:';
//       MONTH_CaptionLbl@7001170 :
      MONTH_CaptionLbl: TextConst ENU='MONTH:',ESP='MES:';
//       PREVISION_IN_MASTERCaptionLbl@7001169 :
      PREVISION_IN_MASTERCaptionLbl: TextConst ENU='PREVISION IN MASTER',ESP='PREVISTO EN MASTER';
//       AGECaptionLbl@7001168 :
      AGECaptionLbl: TextConst ENU='AGE',ESP='A¥O';
//       OPERACIONCaptionLbl@7001167 :
      OPERACIONCaptionLbl: TextConst ESP='OPERACION';
//       DESCRIPTIONCaptionLbl@7001166 :
      DESCRIPTIONCaptionLbl: TextConst ENU='DESCRIPTION',ESP='DESCRIPCION';
//       MONTHCaptionLbl@7001165 :
      MONTHCaptionLbl: TextConst ENU='MONTH',ESP='MES';
//       ORIGINCaptionLbl@7001164 :
      ORIGINCaptionLbl: TextConst ENU='ORIGIN',ESP='ORIGEN';
//       REAL_COSTCaptionLbl@7001163 :
      REAL_COSTCaptionLbl: TextConst ENU='REAL COST',ESP='GASTO REAL';
//       PENDINGCaptionLbl@7001162 :
      PENDINGCaptionLbl: TextConst ENU='PENDING',ESP='PENDIENTE';
//       AGECaption_Control1100251022Lbl@7001161 :
      AGECaption_Control1100251022Lbl: TextConst ENU='AGE',ESP='A¥O';
//       MONTHCaption_Control1100251007Lbl@7001160 :
      MONTHCaption_Control1100251007Lbl: TextConst ESP='MONTH';
//       AMORTIZECaptionLbl@7001159 :
      AMORTIZECaptionLbl: TextConst ENU='AMORTIZE',ESP='AMORTIZADO';
//       ORIGINCaption_Control1100251097Lbl@7001158 :
      ORIGINCaption_Control1100251097Lbl: TextConst ENU='ORIGIN',ESP='ORIGEN';
//       O_E_CaptionLbl@7001157 :
      O_E_CaptionLbl: TextConst ESP='%/O.E.';
//       PDG__AMORTIZE_S__BASECaptionLbl@7001156 :
      PDG__AMORTIZE_S__BASECaptionLbl: TextConst ENU='PENDING AMORTIZE S/BASE',ESP='PDTE. AMORTIZAR S/ BASE';
//       O_E_Caption_Control1100251042Lbl@7001155 :
      O_E_Caption_Control1100251042Lbl: TextConst ESP='%/O.E.';
//       ESTIMATED_AMORTIZED_BASECaptionLbl@7001154 :
      ESTIMATED_AMORTIZED_BASECaptionLbl: TextConst ENU='ESTIMATED AMORTIZED BASE',ESP='BASE AMORTIZACIàN PREVISTA';
//       TOTALCaptionLbl@7001153 :
      TOTALCaptionLbl: TextConst ESP='TOTAL';
//       LABELPRUEBA@7001177 :
      LABELPRUEBA: TextConst ESP='Prueba';

    procedure FunInitvar ()
    begin
      CostMonth := 0;
      CostAge := 0;
      CostOrigin := 0;
      CostPlannedMonth := 0;
      OverBudget := 0;
      OverPending := 0;
      CostPlannedOrigin := 0;
      DeviationOrigin := 0;
      DeviationMonth := 0;
      DeviationAge := 0;
      AmortMonth := 0;
      AmortAge := 0;
      AmortOrigin := 0;
      Pending := 0;
      OverPending := 0;
      PendingAmortize := 0;

      CostMonthMAY := 0;
      CostAgeMAY := 0;
      CostOriginMAY := 0;
      CostPlannedMonthMAY := 0;
      OverBudgetMAY := 0;
      OverPendingMAY := 0;
      CostPlannedOriginMAY := 0;
      DeviationOriginMAY := 0;
      DeviationMonthMAY := 0;
      DeviationAgeMAY := 0;
      DeviationAgeMAY := 0;
      AmortMonthMAY := 0;
      AmortAge := 0;
      AmortOriginMAY := 0;
      PendingMAY := 0;
      PendingAmortizeMAY := 0;
    end;

//     procedure FunNumInitJobMonth (var parintNumMonth@1100251000 : Integer;pardateUntil@1100251002 : Date;pardateInitDateProject@1100251003 :
    procedure FunNumInitJobMonth (var parintNumMonth: Integer;pardateUntil: Date;pardateInitDateProject: Date)
    var
//       locdate@1100251001 :
      locdate: Date;
    begin
      parintNumMonth := 0;

      locdate := DMY2DATE(1,DATE2DMY(pardateInitDateProject,2),DATE2DMY(pardateInitDateProject,3));
      if locdate >= DateUntil then
        parintNumMonth := 1
      else begin
        repeat
          parintNumMonth := parintNumMonth + 1;
          locdate := CALCDATE('PM',locdate) + 1;
        until locdate > pardateUntil
      end;
    end;

    /*begin
    end.
  */
  
}




report 7207391 "Control Indirect Costs Job"
{
  
  
    CaptionML=ENU='Control Indirect Costs Job',ESP='Control costes indirectos obra';
  
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.","Posting Date Filter";
Column(No_Job;Job."No.")
{
//SourceExpr=Job."No.";
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Type"=CONST("Cost Unit"));
DataItemLink="Job No."= FIELD("No.");
Column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(CurrReport_PAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(Job_No________Job_Description;Job."No."+' ' + Job.Description)
{
//SourceExpr=Job."No."+' ' + Job.Description;
}Column(Year;Year)
{
//SourceExpr=Year;
}Column(Month;Month)
{
//SourceExpr=Month;
}Column(CompanyInformation_Picture;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(COPYSTR_Spaces_1_Indentation2__DPFP_Description;COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description + "Data Piecework For Production"."Description 2")
{
//SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
}Column(COPYSTR_Spaces__Indentation2__PieceworkCode;COPYSTR(Spaces,1,Indentation*2) + "Piecework Code")
{
//SourceExpr=COPYSTR(Spaces,1,Indentation*2) + "Piecework Code";
}Column(Data_Piecework_For_Production_Piecework_Code_;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(CostPlannedMonthMay;CostPlannedMonthMay)
{
//SourceExpr=CostPlannedMonthMay;
}Column(CostPlannedOriginMay;CostPlannedOriginMay)
{
//SourceExpr=CostPlannedOriginMay;
}Column(OverBudgetMay;OverBudgetMay)
{
//SourceExpr=OverBudgetMay;
}Column(CostsMonthMay;CostMonthMay)
{
//SourceExpr=CostMonthMay;
}Column(CostYearMay;CostYearMay)
{
//SourceExpr=CostYearMay;
}Column(CostPlannedYear;CostPlannedYear)
{
//SourceExpr=CostPlannedYear;
}Column(PendingMay;PendingMay)
{
//SourceExpr=PendingMay;
}Column(CostOriginMay;CostOriginMay)
{
//SourceExpr=CostOriginMay;
}Column(ByOEgarsoOriginMay;ByOEgarsonOriginMay)
{
//SourceExpr=ByOEgarsonOriginMay;
}Column(AverageYearMay;AverageYearMay)
{
//SourceExpr=AverageYearMay;
}Column(AverageOriginMay;AverageOriginMay)
{
//SourceExpr=AverageOriginMay;
}Column(AveragePendingMay;AveragePendingMay)
{
//SourceExpr=AveragePendingMay;
}Column(OverPendingMay;OverPendingMay)
{
//SourceExpr=OverPendingMay;
}Column(AverageOriginMay_Contol7001123;AverageOriginMay)
{
//SourceExpr=AverageOriginMay;
}Column(AveragePendingMay_Control7001124;AveragePendingMay)
{
//SourceExpr=AveragePendingMay;
}Column(PendingMay_Control7001125;PendingMay)
{
//SourceExpr=PendingMay;
}Column(ByOEgarsoOriginMay_COntrol7001126;ByOEgarsonOriginMay)
{
//SourceExpr=ByOEgarsonOriginMay;
}Column(AverageYearMay_Control7001127;AverageYearMay)
{
//SourceExpr=AverageYearMay;
}Column(OverPendingMay_Control7001128;OverPendingMay)
{
//SourceExpr=OverPendingMay;
}Column(CostOriginMay_COntrol7001129;CostOriginMay)
{
//SourceExpr=CostOriginMay;
}Column(CostYearMay_Control7001130;CostYearMay)
{
//SourceExpr=CostYearMay;
}Column(CostPlannedOriginMay_Control7001131;CostPlannedOriginMay)
{
//SourceExpr=CostPlannedOriginMay;
}Column(OverBudgetMay_Control7001132;OverBudgetMay)
{
//SourceExpr=OverBudgetMay;
}Column(CostMonthMay_Control7001133;CostMonthMay)
{
//SourceExpr=CostMonthMay;
}Column(CostPlannedMonthMay_Control7001134;CostPlannedMonthMay)
{
//SourceExpr=CostPlannedMonthMay;
}Column(Data_Piecework_For_Production_Piecework_Code_Control7001136;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(Data_Piecework_For_Production_Piecework_Code_Control7001137;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(Data_Piecework_For_Production_Unit_Of_Meaure_;"Data Piecework For Production"."Unit Of Measure")
{
//SourceExpr="Data Piecework For Production"."Unit Of Measure";
}Column(Data_Piecework_For_Production_Description;"Data Piecework For Production".Description)
{
//SourceExpr="Data Piecework For Production".Description;
}Column(CostPlanningMonth;CostPlannedMonth)
{
//SourceExpr=CostPlannedMonth;
}Column(CostMonth;CostMonth)
{
//SourceExpr=CostMonth;
}Column(CostOrigin;CostOrigin)
{
//SourceExpr=CostOrigin;
}Column(CostPlannedOrigin;CostPlannedOrigin)
{
//SourceExpr=CostPlannedOrigin;
}Column(CostYear;CostYear)
{
//SourceExpr=CostYear;
}Column(AverageYear;AverageYear)
{
//SourceExpr=AverageYear;
}Column(AverageOrigin;AverageOrigin)
{
//SourceExpr=AverageOrigin;
}Column(AveragePending;AveragePending)
{
//SourceExpr=AveragePending;
}Column(OverBudget;OverBudget)
{
//SourceExpr=OverBudget;
}Column(Pending;Pending)
{
//SourceExpr=Pending;
}Column(ByOEgarsoOrigin;ByOEgarsoOrigin)
{
//SourceExpr=ByOEgarsoOrigin;
}Column(OverPending;OverPending)
{
//SourceExpr=OverPending;
}Column(AveragePending_Control7001152;AveragePending)
{
//SourceExpr=AveragePending;
}Column(AverageOrigin_Control7001153;AverageOrigin)
{
//SourceExpr=AverageOrigin;
}Column(AverageYear_Control7001154;AverageYear)
{
//SourceExpr=AverageYear;
}Column(Pending_Control7001155;Pending)
{
//SourceExpr=Pending;
}Column(CostOrigin_Control7001156;CostOrigin)
{
//SourceExpr=CostOrigin;
}Column(CostYear_Control7001157;CostYear)
{
//SourceExpr=CostYear;
}Column(CostMonth_Control7001158;CostMonth)
{
//SourceExpr=CostMonth;
}Column(CostPlannedOrigin_Control7001159;CostPlannedOrigin)
{
//SourceExpr=CostPlannedOrigin;
}Column(OverBudget_Control7001160;OverBudget)
{
//SourceExpr=OverBudget;
}Column(CostPlannedMonth_Control7001190;CostPlannedMonth)
{
//SourceExpr=CostPlannedMonth;
}Column(ByOEgarsonOrigin_Control7001162;ByOEgarsoOrigin)
{
DecimalPlaces=4:4;
               //SourceExpr=ByOEgarsoOrigin;
}Column(OverPending_Control7001163;OverPending)
{
//SourceExpr=OverPending;
}Column(COST_REAL_JOBCaption;COST_REAL_JOBCaptionLbl)
{
//SourceExpr=COST_REAL_JOBCaptionLbl;
}Column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
{
//SourceExpr=CurrReport_PAGENOCaptionLbl;
}Column(COST_INDIRECTCaption;COST_INDIRECTCaptionLbl)
{
//SourceExpr=COST_INDIRECTCaptionLbl;
}Column(Job_No____Job_DescriptionCaptionLbl;Job_No____Job_DescriptionCaptionLbl)
{
//SourceExpr=Job_No____Job_DescriptionCaptionLbl;
}Column(YEAR_Caption;YEARCaptionLbl)
{
//SourceExpr=YEARCaptionLbl;
}Column(MONTH_Caption;Month_CaptionLbl)
{
//SourceExpr=Month_CaptionLbl;
}Column(INCOME_CURRENT_AND_EXTERMALCaption;INCOME_CURRENT_AND_EXTERNALCaptionLbl)
{
//SourceExpr=INCOME_CURRENT_AND_EXTERNALCaptionLbl;
}Column(PENDINGCaption;PENDINGCaptionLbl)
{
//SourceExpr=PENDINGCaptionLbl;
}Column(AVERAGE_MONTHLY_INCOMECaption;AVERAGE_MONTHLY_INCOMECaptionLbl)
{
//SourceExpr=AVERAGE_MONTHLY_INCOMECaptionLbl;
}Column(YEARCaption;YEARCaptionLbl)
{
//SourceExpr=YEARCaptionLbl;
}Column(O_E_RCaption;O_E_RCaptionLbl)
{
//SourceExpr=O_E_RCaptionLbl;
}Column(INCOME_REALCaption;INCOME_REALCaptionLbl)
{
//SourceExpr=INCOME_REALCaptionLbl;
}Column(PLANNINGCaption;PLANNINGCaptionLbl)
{
//SourceExpr=PLANNINGCaptionLbl;
}Column(OPERATIONCaption;OPERATIONCaptionLbl)
{
//SourceExpr=OPERATIONCaptionLbl;
}Column(DESCRIPTIONCaption;DESCRIPTIONCaptionLbl)
{
//SourceExpr=DESCRIPTIONCaptionLbl;
}Column(ORIGINCaption;ORIGINCaptionLbl)
{
//SourceExpr=ORIGINCaptionLbl;
}Column(ORIGINCaption_Control7001180;ORIGINCaption_Control7001180Lbl)
{
//SourceExpr=ORIGINCaption_Control7001180Lbl;
}Column(MONTHCaption;MONTHCaptionLbl)
{
//SourceExpr=MONTHCaptionLbl;
}Column(ORIGINCaption_Control7001182;ORIGINCaption_Control7001182Lbl)
{
//SourceExpr=ORIGINCaption_Control7001182Lbl;
}Column(YEARCaption_Control7001183;YEARCAPTION_CONTROL7001183Lbl)
{
//SourceExpr=YEARCAPTION_CONTROL7001183Lbl;
}Column(PENDINGCaption_Control7001184;PENDINGCaption_Control7001184)
{
//SourceExpr=PENDINGCaption_Control7001184;
}Column(MONTHCaption_Control7001185;MONTHCaption_Control7001185)
{
//SourceExpr=MONTHCaption_Control7001185;
}Column(O_E_Caption;O_E_CaptionLbl)
{
//SourceExpr=O_E_CaptionLbl;
}Column(O_E_PCaption;O_E_PCaptionLbl)
{
//SourceExpr=O_E_PCaptionLbl;
}Column(TOTALCaption;TOTALCaptionLbl)
{
//SourceExpr=TOTALCaptionLbl;
}Column(Data_piecework_for_production_Job_No;"Data Piecework For Production"."Job No.")
{
//SourceExpr="Data Piecework For Production"."Job No.";
}Column(UnitofMeasureCaption;UnitofMeasureLbl)
{
//SourceExpr=UnitofMeasureLbl;
}Column(Identation;DataPieceworkForProductionSoon.Indentation )
{
//SourceExpr=DataPieceworkForProductionSoon.Indentation ;
}trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("Job No.");

                               CurrReport.CREATETOTALS(CostMonth,CostOrigin,CostYear,CostPlannedMonth,CostPlannedOrigin,
                                                       OverBudget,OverPending);

                               CurrReport.CREATETOTALS(Pending);
                               "Data Piecework For Production".SETRANGE("Budget Filter",BudgetinProgress);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Data Piecework For Production"."Type Unit Cost" = "Data Piecework For Production"."Type Unit Cost"::Internal
                                    THEN BEGIN 
                                    IF ("Data Piecework For Production"."Subtype Cost" <> "Data Piecework For Production"."Subtype Cost"::"Current Expenses") AND
                                       ("Data Piecework For Production"."Subtype Cost" <> "Data Piecework For Production"."Subtype Cost"::"Financial Charges")
                                  AND
                                       ("Data Piecework For Production"."Subtype Cost" <> "Data Piecework For Production"."Subtype Cost"::Others) THEN
                                      CurrReport.SKIP;
                                  END;

                                  StartVariables;

                                  IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN 
                                    SETRANGE("Filter Date",0D,UntilDate);
                                    CALCFIELDS("Amount Cost Budget (JC)","Amount Production Budget");
                                    CostPlannedOrigin := "Amount Cost Budget (JC)";

                                    IF RealizedTheoricalOrigin <> 0 THEN
                                      OverBudget := ROUND(CostPlannedOrigin * 100/
                                                           RealizedTheoricalOrigin,0.0001)
                                    ELSE
                                      OverBudget := 0;

                                    SETRANGE("Filter Date",SinceDate,UntilDate);
                                    CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)");
                                    CostMonth := "Amount Cost Performed (JC)";
                                    IF UntilDate < JobBudget."Budget Date" THEN
                                      CostPlannedMonth := 0
                                    ELSE
                                      CostPlannedMonth := "Amount Cost Budget (JC)";

                                    SETRANGE("Filter Date",StarYearDate,UntilDate);
                                    CALCFIELDS("Amount Cost Performed (JC)","Amount Cost Budget (JC)");
                                    CostYear := "Amount Cost Performed (JC)";

                                    SETRANGE("Filter Date",0D,UntilDate);
                                    CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)");
                                    CostOrigin := "Amount Cost Performed (JC)";

                                  // Se cambia la formula del pendiente
                                    SETRANGE("Filter Date");
                                    CALCFIELDS("Amount Cost Budget (JC)");
                                    Pending := "Amount Cost Budget (JC)" - CostOrigin;

                                    IF JobExecutedPending <> 0 THEN
                                      OverPending := ROUND(Pending * 100 / JobExecutedPending,0.0001)
                                    ELSE
                                      OverPending := 0;

                                    IF JobExecutedReal <> 0 THEN
                                      ByOEgarsoOrigin := ROUND(CostOrigin * 100 /
                                                                   JobExecutedReal,0.0001)
                                    ELSE
                                      ByOEgarsoOrigin := 0;


                                    DeviationMonth := CostPlannedMonth - CostMonth;
                                    DeviationOrigin := CostPlannedOrigin - CostOrigin;

                                    SETRANGE("Filter Date");
                                    CALCFIELDS("Amount Cost Budget (JC)");

                                    NumberMonthStartJob(NumberMonthSinceInitial,SinceDate,Job."Init Real Date Construction");
                                    IF NumberMonthSinceInitial = 0 THEN
                                      NumberMonthSinceInitial := 1;

                                    IF DATE2DMY(Job."Starting Date",3) < Year THEN
                                      AverageYear := ROUND(CostYear/Month,Currency."Amount Rounding Precision")
                                    ELSE BEGIN 
                                      AverageYear := ROUND(CostYear/NumberMonthSinceInitial,Currency."Amount Rounding Precision")
                                    END;

                                    AverageOrigin := ROUND(CostOrigin/NumberMonthSinceInitial,Currency."Amount Rounding Precision");
                                    NumberMonthStartJob(NumberMonthSinceInitial,Job."End Prov. Date Construction",UntilDate + 1);
                                    AveragePending := ROUND(Pending/NumberMonthSinceInitial,Currency."Amount Rounding Precision");
                                  END ELSE BEGIN 
                                    DataPieceworkForProductionSoon.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
                                    DataPieceworkForProductionSoon.SETFILTER("Piecework Code","Data Piecework For Production".Totaling);
                                    DataPieceworkForProductionSoon.SETRANGE("Account Type",DataPieceworkForProductionSoon."Account Type"::Unit);
                                    DataPieceworkForProductionSoon.SETRANGE("Budget Filter",BudgetinProgress);
                                    IF DataPieceworkForProductionSoon.FINDSET THEN
                                      REPEAT
                                        DataPieceworkForProductionSoon.SETRANGE("Filter Date",0D,UntilDate);
                                        DataPieceworkForProductionSoon.CALCFIELDS("Amount Cost Budget (JC)","Amount Production Budget");
                                        CostPlannedOriginMay := CostPlannedOriginMay + DataPieceworkForProductionSoon."Amount Cost Budget (JC)";

                                        DataPieceworkForProductionSoon.SETRANGE("Filter Date",SinceDate,UntilDate);
                                        DataPieceworkForProductionSoon.CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)");
                                        CostMonthMay := CostMonthMay + DataPieceworkForProductionSoon."Amount Cost Performed (JC)";

                                        IF UntilDate < JobBudget."Budget Date" THEN
                                          CostPlannedMonthMay := CostPlannedMonthMay + 0
                                        ELSE
                                          CostPlannedMonthMay := CostPlannedMonthMay + DataPieceworkForProductionSoon."Amount Cost Budget (JC)";

                                        DataPieceworkForProductionSoon.SETRANGE("Filter Date",StarYearDate,UntilDate);
                                        DataPieceworkForProductionSoon.CALCFIELDS("Amount Cost Performed (JC)","Amount Cost Budget (JC)");
                                        CostYearMay := CostYearMay + DataPieceworkForProductionSoon."Amount Cost Performed (JC)";

                                        DataPieceworkForProductionSoon.SETRANGE("Filter Date",0D,UntilDate);
                                        DataPieceworkForProductionSoon.CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)");
                                        CostOriginMay := CostOriginMay + DataPieceworkForProductionSoon."Amount Cost Performed (JC)";


                                        DataPieceworkForProductionSoon.SETRANGE("Filter Date");
                                        DataPieceworkForProductionSoon.CALCFIELDS("Amount Cost Budget (JC)","Amount Cost Performed (JC)");
                                        BudgetMay := BudgetMay + DataPieceworkForProductionSoon."Amount Cost Budget (JC)";
                                      UNTIL DataPieceworkForProductionSoon.NEXT = 0;

                                    IF RealizedTheoricalOrigin <> 0 THEN
                                      OverBudgetMay := ROUND(CostPlannedOriginMay * 100/
                                                           RealizedTheoricalOrigin,0.0001)
                                    ELSE
                                      OverBudgetMay := 0;

                                  // Se cambia el calculo del pendiente
                                     PendingMay := BudgetMay;

                                     IF JobExecutedPending <> 0 THEN
                                      OverPendingMay := ROUND(PendingMay * 100 /
                                                                     JobExecutedPending,0.0001)
                                    ELSE
                                      OverPendingMay := 0;


                                     IF JobExecutedReal <> 0 THEN
                                      ByOEgarsonOriginMay := ROUND(CostOriginMay * 100 /
                                                                     JobExecutedReal,0.0001)
                                    ELSE
                                      ByOEgarsonOriginMay := 0;

                                    DeviationMonthMay := CostPlannedMonthMay - CostMonthMay;
                                    DeviationOriginMay := CostPlannedOriginMay - CostOriginMay;

                                    NumberMonthStartJob(NumberMonthSinceInitial,SinceDate,Job."Init Real Date Construction");
                                    IF NumberMonthSinceInitial = 0 THEN
                                      NumberMonthSinceInitial := 1;

                                    IF DATE2DMY(Job."Starting Date",3) < Year THEN
                                      AverageYearMay := ROUND(CostYearMay/Month,Currency."Amount Rounding Precision")
                                    ELSE BEGIN 
                                      AverageYearMay := ROUND(CostYearMay/NumberMonthSinceInitial,Currency."Amount Rounding Precision")
                                    END;

                                    AverageOriginMay := ROUND(CostOriginMay/NumberMonthSinceInitial,Currency."Amount Rounding Precision");
                                    NumberMonthStartJob(NumberMonthSinceInitial,Job."End Prov. Date Construction",UntilDate+1);
                                    IF NumberMonthSinceInitial = 0 THEN
                                      NumberMonthSinceInitial := 1;
                                    AveragePendingMay := ROUND(PendingMay/NumberMonthSinceInitial,Currency."Amount Rounding Precision");
                                  END;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               Year:=DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"),3);
                               Month:=DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"),2);

                               IF (Year = 0) OR (Month = 0) THEN
                                 ERROR(Text50000);

                               SinceDate := DMY2DATE(1,Month,Year);
                               UntilDate := CALCDATE('PM',SinceDate);
                               StarYearDate :=  DMY2DATE(1,1,Year);

                               CurrReport.CREATETOTALS(CostMonth,CostOrigin,CostPlannedMonth,CostPlannedOrigin);

                               CLEAR(Currency);
                               Currency.InitRoundingPrecision;

                               CompanyInformation.GET;
                               CompanyInformation.CALCFIELDS(Picture);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF GETFILTER(Job."Budget Filter") <> '' THEN
                                    BudgetinProgress := GETFILTER(Job."Budget Filter")
                                  ELSE BEGIN 
                                    IF Job."Current Piecework Budget" <> '' THEN
                                      BudgetinProgress := Job."Current Piecework Budget"
                                    ELSE
                                      BudgetinProgress := Job."Initial Budget Piecework";
                                  END;

                                  JobBudget.GET("No.",BudgetinProgress);

                                  Job.SETRANGE("Budget Filter",BudgetinProgress);
                                  SETRANGE("Posting Date Filter");
                                  CALCFIELDS(Job."Production Budget Amount");
                                  AmountTotal := Job."Production Budget Amount";

                                  SETRANGE("Posting Date Filter",0D,UntilDate);
                                  CALCFIELDS(Job."Production Budget Amount",Job."Actual Production Amount");
                                  RealizedTheoricalOrigin := Job."Production Budget Amount";
                                  JobExecutedReal :=  Job."Actual Production Amount";
                                  JobExecutedPending := AmountTotal - Job."Actual Production Amount";
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
//       Year@7001100 :
      Year: Integer;
//       Month@7001101 :
      Month: Integer;
//       CompanyInformation@7001102 :
      CompanyInformation: Record 79;
//       Text50000@7001103 :
      Text50000: TextConst ENU='You must indicate year and month of the job report',ESP='Debe indicicar A¤o y mes del informe de obra';
//       SinceDate@7001104 :
      SinceDate: Date;
//       UntilDate@7001105 :
      UntilDate: Date;
//       StarYearDate@7001106 :
      StarYearDate: Date;
//       CostMonth@7001107 :
      CostMonth: Decimal;
//       CostOrigin@7001108 :
      CostOrigin: Decimal;
//       CostPlannedMonth@7001109 :
      CostPlannedMonth: Decimal;
//       CostPlannedYear@7001173 :
      CostPlannedYear: Decimal;
//       CostPlannedOrigin@7001110 :
      CostPlannedOrigin: Decimal;
//       Currency@7001111 :
      Currency: Record 4;
//       BudgetinProgress@7001112 :
      BudgetinProgress: Code[20];
//       JobBudget@7001113 :
      JobBudget: Record 7207407;
//       AmountTotal@7001114 :
      AmountTotal: Decimal;
//       RealizedTheoricalOrigin@7001115 :
      RealizedTheoricalOrigin: Decimal;
//       JobExecutedReal@7001116 :
      JobExecutedReal: Decimal;
//       JobExecutedPending@7001117 :
      JobExecutedPending: Decimal;
//       LastFieldNo@7001118 :
      LastFieldNo: Integer;
//       OverBudget@7001119 :
      OverBudget: Decimal;
//       OverPending@7001120 :
      OverPending: Decimal;
//       CostYear@7001121 :
      CostYear: Decimal;
//       Pending@7001122 :
      Pending: Decimal;
//       DeviationMonth@7001123 :
      DeviationMonth: Decimal;
//       DeviationOrigin@7001124 :
      DeviationOrigin: Decimal;
//       DeviationYear@7001125 :
      DeviationYear: Decimal;
//       CostMonthMay@7001126 :
      CostMonthMay: Decimal;
//       CostYearMay@7001127 :
      CostYearMay: Decimal;
//       CostOriginMay@7001128 :
      CostOriginMay: Decimal;
//       OverBudgetMay@7001129 :
      OverBudgetMay: Decimal;
//       OverPendingMay@7001130 :
      OverPendingMay: Decimal;
//       DeviationOriginMay@7001131 :
      DeviationOriginMay: Decimal;
//       DeviationMonthMay@7001132 :
      DeviationMonthMay: Decimal;
//       DeviationYearMay@7001133 :
      DeviationYearMay: Decimal;
//       ByOEgarsoOrigin@7001134 :
      ByOEgarsoOrigin: Decimal;
//       ByOEgarsonOriginMay@7001135 :
      ByOEgarsonOriginMay: Decimal;
//       BudgetMay@7001136 :
      BudgetMay: Decimal;
//       CostPlannedMonthMay@7001137 :
      CostPlannedMonthMay: Decimal;
//       CostPlannedOriginMay@7001138 :
      CostPlannedOriginMay: Decimal;
//       DataPieceworkForProduction@7001139 :
      DataPieceworkForProduction: Record 7207386;
//       NumberMonthSinceInitial@7001140 :
      NumberMonthSinceInitial: Integer;
//       AverageYear@7001141 :
      AverageYear: Decimal;
//       AverageOrigin@7001142 :
      AverageOrigin: Decimal;
//       AveragePending@7001143 :
      AveragePending: Decimal;
//       DataPieceworkForProductionSoon@7001144 :
      DataPieceworkForProductionSoon: Record 7207386;
//       PendingMay@7001145 :
      PendingMay: Decimal;
//       AverageYearMay@7001146 :
      AverageYearMay: Decimal;
//       AverageOriginMay@7001147 :
      AverageOriginMay: Decimal;
//       AveragePendingMay@7001148 :
      AveragePendingMay: Decimal;
//       COST_REAL_JOBCaptionLbl@7001149 :
      COST_REAL_JOBCaptionLbl: TextConst ENU='REAL COST JOB',ESP='COSTE REAL DE OBRA';
//       CurrReport_PAGENOCaptionLbl@7001150 :
      CurrReport_PAGENOCaptionLbl: TextConst ENU='Page',ESP='P gina';
//       COST_INDIRECTCaptionLbl@7001151 :
      COST_INDIRECTCaptionLbl: TextConst ENU='INDIRECT COST',ESP='COSTE INDIRECTO';
//       Job_No____Job_DescriptionCaptionLbl@7001152 :
      Job_No____Job_DescriptionCaptionLbl: TextConst ENU='JOB:',ESP='OBRA:';
//       YEARCaptionLbl@7001153 :
      YEARCaptionLbl: TextConst ENU='YEAR:',ESP='A¥O:';
//       Month_CaptionLbl@7001154 :
      Month_CaptionLbl: TextConst ENU='MONTH:',ESP='MES:';
//       INCOME_CURRENT_AND_EXTERNALCaptionLbl@7001155 :
      INCOME_CURRENT_AND_EXTERNALCaptionLbl: TextConst ENU='INCOME CURRENT and EXTERNAL',ESP='GASTOS CORRIENTES Y EXTERNOS';
//       PENDINGCaptionLbl@7001156 :
      PENDINGCaptionLbl: TextConst ENU='PENDING',ESP='PENDIENTE';
//       AVERAGE_MONTHLY_INCOMECaptionLbl@7001157 :
      AVERAGE_MONTHLY_INCOMECaptionLbl: TextConst ENU='MONTHLY AVERAGE INCOME',ESP='MEDIA MENSUAL DEL GASTO';
//       O_E_RCaptionLbl@7001158 :
      O_E_RCaptionLbl: TextConst ENU='%/O.E.R',ESP='%/O.E.R';
//       INCOME_REALCaptionLbl@7001159 :
      INCOME_REALCaptionLbl: TextConst ENU='REAL INCOME',ESP='COSTE REAL';
//       PLANNINGCaptionLbl@7001160 :
      PLANNINGCaptionLbl: TextConst ENU='PLANNING',ESP='PLANIFICANDO';
//       OPERATIONCaptionLbl@7001161 :
      OPERATIONCaptionLbl: TextConst ENU='OPERATION',ESP='OPERACIàN';
//       DESCRIPTIONCaptionLbl@7001162 :
      DESCRIPTIONCaptionLbl: TextConst ENU='DESCRIPTION',ESP='DESCRIPCION';
//       ORIGINCaptionLbl@7001163 :
      ORIGINCaptionLbl: TextConst ENU='ORIGIN',ESP='ORIGEN';
//       ORIGINCaption_Control7001180Lbl@7001164 :
      ORIGINCaption_Control7001180Lbl: TextConst ENU='ORIGIN',ESP='ORIGEN';
//       MONTHCaptionLbl@7001165 :
      MONTHCaptionLbl: TextConst ENU='MONTH',ESP='MES';
//       ORIGINCaption_Control7001182Lbl@7001166 :
      ORIGINCaption_Control7001182Lbl: TextConst ENU='ORIGIN',ESP='ORIGEN';
//       YEARCAPTION_CONTROL7001183Lbl@7001167 :
      YEARCAPTION_CONTROL7001183Lbl: TextConst ENU='YEAR',ESP='A¥O';
//       PENDINGCaption_Control7001184@7001168 :
      PENDINGCaption_Control7001184: TextConst ENU='PENDING',ESP='PENDIENTE';
//       MONTHCaption_Control7001185@7001169 :
      MONTHCaption_Control7001185: TextConst ENU='MONTH',ESP='MES';
//       O_E_CaptionLbl@7001170 :
      O_E_CaptionLbl: TextConst ENU='%/O.E.',ESP='%/O.E.';
//       O_E_PCaptionLbl@7001171 :
      O_E_PCaptionLbl: TextConst ENU='%/O.E.P',ESP='%/O.E.P';
//       TOTALCaptionLbl@7001172 :
      TOTALCaptionLbl: TextConst ENU='TOTAL',ESP='TOTAL';
//       Spaces@7001174 :
      Spaces: Text[30];
//       UnitofMeasureLbl@7001175 :
      UnitofMeasureLbl: TextConst ENU='UD',ESP='UD';

    procedure StartVariables ()
    begin
      CostMonth := 0;
      CostYear := 0;
      CostOrigin := 0;
      CostPlannedMonth := 0;
      OverBudget := 0;
      OverPending := 0;
      CostPlannedOrigin := 0;
      DeviationOrigin := 0;
      DeviationMonth := 0;
      DeviationYear := 0;

      CostMonthMay := 0;
      CostYearMay := 0;
      CostOriginMay := 0;
      CostPlannedMonthMay := 0;
      OverBudgetMay := 0;
      OverPendingMay := 0;
      CostPlannedOriginMay := 0;
      DeviationOriginMay := 0;
      DeviationMonthMay := 0;
      DeviationYearMay := 0;

      ByOEgarsoOrigin := 0;
      ByOEgarsonOriginMay := 0;
      BudgetMay := 0;
    end;

//     procedure NumberMonthStartJob (var PNumberMonth@1100251000 : Integer;PUntilDate@1100251002 : Date;PDateStartJob@1100251003 :
    procedure NumberMonthStartJob (var PNumberMonth: Integer;PUntilDate: Date;PDateStartJob: Date)
    var
//       LDate@1100251001 :
      LDate: Date;
    begin
      PNumberMonth := 0;

      LDate := DMY2DATE(1,DATE2DMY(PDateStartJob,2),DATE2DMY(PDateStartJob,3));
      if LDate >= PUntilDate then
        PNumberMonth := 1
      else begin
        repeat
          PNumberMonth := PNumberMonth + 1;
          LDate := CALCDATE('PM',LDate) + 1;
        until LDate > PUntilDate
      end;
    end;

    /*begin
    end.
  */
  
}




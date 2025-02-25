report 7207393 "Indirect Cost Planning"
{


    ;
    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Posting Date Filter";
            Column(JobNo; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Cost Unit"));
                DataItemLink = "Job No." = FIELD("No.");
                Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(Job__No___________Job_Description; Job."No." + ' ' + Job.Description)
                {
                    //SourceExpr=Job."No." + ' ' + Job.Description;
                }
                Column(IntAge; IntAge)
                {
                    //SourceExpr=IntAge;
                }
                Column(IntMonth; IntMonth)
                {
                    //SourceExpr=IntMonth;
                }
                Column(CompanyInformationPicture; CompanyInformation.Picture)
                {
                    //SourceExpr=CompanyInformation.Picture;
                }
                Column(DPFP_PieceworkCode; "Data Piecework For Production"."Piecework Code")
                {
                    //SourceExpr="Data Piecework For Production"."Piecework Code";
                }
                Column(DPFP_UnitOfMeasure; "Data Piecework For Production"."Unit Of Measure")
                {
                    //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                }
                Column(DPFP_Description; "Data Piecework For Production".Description)
                {
                    //SourceExpr="Data Piecework For Production".Description;
                }
                Column(CostPlannedMonth; CostPlannedMonth)
                {
                    //SourceExpr=CostPlannedMonth;
                }
                Column(CostMonth; CostMonth)
                {
                    //SourceExpr=CostMonth;
                }
                Column(CostPlannedOrigin; CostPlannedOrigin)
                {
                    //SourceExpr=CostPlannedOrigin;
                }
                Column(CostOrigin; CostOrigin)
                {
                    //SourceExpr=CostOrigin;
                }
                Column(decI1; decI1)
                {
                    //SourceExpr=decI1;
                }
                Column(decI2; decI2)
                {
                    //SourceExpr=decI2;
                }
                Column(decJ1; decJ1)
                {
                    //SourceExpr=decJ1;
                }
                Column(decJ2; decJ2)
                {
                    //SourceExpr=decJ2;
                }
                Column(CostPlannedAge; CostPlannedAge)
                {
                    //SourceExpr=CostPlannedAge;
                }
                Column(CostAge; CostAge)
                {
                    //SourceExpr=CostAge;
                }
                Column(CostPlannedMonth_Control1100251063; CostPlannedMonth)
                {
                    //SourceExpr=CostPlannedMonth;
                }
                Column(CostPlannedOrigin_Control1100251064; CostPlannedOrigin)
                {
                    //SourceExpr=CostPlannedOrigin;
                }
                Column(CostMonth_Control1100251065; CostMonth)
                {
                    //SourceExpr=CostMonth;
                }
                Column(CostOrigin_Control1100251066; CostOrigin)
                {
                    //SourceExpr=CostOrigin;
                }
                Column(decI1_Control1100251069; decI1)
                {
                    //SourceExpr=decI1;
                }
                Column(decJ1_Control1100251070; decJ1)
                {
                    //SourceExpr=decJ1;
                }
                Column(CostPlannedAge_Control1100251094; CostPlannedAge)
                {
                    //SourceExpr=CostPlannedAge;
                }
                Column(CostAge_Control1100251117; CostAge)
                {
                    //SourceExpr=CostAge;
                }
                Column(CostPlannedMonthTotal; CostPlannedMonthTotal)
                {
                    //SourceExpr=CostPlannedMonthTotal;
                }
                Column(CostPlannedOriginTotal; CostPlannedOriginTotal)
                {
                    //SourceExpr=CostPlannedOriginTotal;
                }
                Column(CostRealMonthTotal; CostRealMonthTotal)
                {
                    //SourceExpr=CostRealMonthTotal;
                }
                Column(CostRealAgeTotal; CostRealAgeTotal)
                {
                    //SourceExpr=CostRealAgeTotal;
                }
                Column(CostRealOrignTotal; CostRealOrignTotal)
                {
                    //SourceExpr=CostRealOrignTotal;
                }
                Column(CostSalesMonthTotal; CostSalesMonthTotal)
                {
                    //SourceExpr=CostSalesMonthTotal;
                }
                Column(totI1; totI1)
                {
                    //SourceExpr=totI1;
                }
                Column(totJ1; totJ1)
                {
                    //SourceExpr=totJ1;
                }
                Column(CostPlannedAgeTotal; CostPlannedAgeTotal)
                {
                    //SourceExpr=CostPlannedAgeTotal;
                }
                Column(CostSalesOriginTotal; CostSalesOriginTotal)
                {
                    //SourceExpr=CostSalesOriginTotal;
                }
                Column(decI2_Control1100251028; decI2)
                {
                    //SourceExpr=decI2;
                }
                Column(decJ2_Control1100251068; decJ2)
                {
                    //SourceExpr=decJ2;
                }
                Column(totI2; totI2)
                {
                    //SourceExpr=totI2;
                }
                Column(totJ2; totJ2)
                {
                    //SourceExpr=totJ2;
                }
                Column(COSTE_REAL_DE_OBRACaptionLbl; COSTE_REAL_DE_OBRACaptionLbl)
                {
                    //SourceExpr=COSTE_REAL_DE_OBRACaptionLbl;
                }
                Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(COSTE_INDIRECTOCaptionLbl; COSTE_INDIRECTOCaptionLbl)
                {
                    //SourceExpr=COSTE_INDIRECTOCaptionLbl;
                }
                Column(Job__No___________Job_DescriptionCaptionLbl; Job__No___________Job_DescriptionCaptionLbl)
                {
                    //SourceExpr=Job__No___________Job_DescriptionCaptionLbl;
                }
                Column(AYO_CaptionLbl; AYO_CaptionLbl)
                {
                    //SourceExpr=A¥O_CaptionLbl;
                }
                Column(MES_CaptionLbl; MES_CaptionLbl)
                {
                    //SourceExpr=MES_CaptionLbl;
                }
                Column(OPERACIONCaptionLbl; OPERACIONCaptionLbl)
                {
                    //SourceExpr=OPERACIONCaptionLbl;
                }
                Column(DESCRIPCIONCaptionLbl; DESCRIPCIONCaptionLbl)
                {
                    //SourceExpr=DESCRIPCIONCaptionLbl;
                }
                Column(MESCaptionLbl; MESCaptionLbl)
                {
                    //SourceExpr=MESCaptionLbl;
                }
                Column(ORIGENCaptionLbl; ORIGENCaptionLbl)
                {
                    //SourceExpr=ORIGENCaptionLbl;
                }
                Column(REALCaptionLbl; REALCaptionLbl)
                {
                    //SourceExpr=REALCaptionLbl;
                }
                Column(VENTACaptionLbl; VENTACaptionLbl)
                {
                    //SourceExpr=VENTACaptionLbl;
                }
                Column(MESCaption_Control1100251031Lbl; MESCaption_Control1100251031Lbl)
                {
                    //SourceExpr=MESCaption_Control1100251031Lbl;
                }
                Column(ORIGENCaption_Control1100251032Lbl; ORIGENCaption_Control1100251032Lbl)
                {
                    //SourceExpr=ORIGENCaption_Control1100251032Lbl;
                }
                Column(MESCaption_Control1100251033Lbl; MESCaption_Control1100251033Lbl)
                {
                    //SourceExpr=MESCaption_Control1100251033Lbl;
                }
                Column(AYOCaptionLbl; AYOCaptionLbl)
                {
                    //SourceExpr=A¥OCaptionLbl;
                }
                Column(DESVIACIONES_IMPORTE_____S_MA_CaptionLbl; DESVIACIONES_IMPORTE_____S_MA_CaptionLbl)
                {
                    //SourceExpr=DESVIACIONES_IMPORTE_____S_MA_CaptionLbl;
                }
                Column(COSTE_TOTAL_INDIRECTOCaptionLbl; COSTE_TOTAL_INDIRECTOCaptionLbl)
                {
                    //SourceExpr=COSTE_TOTAL_INDIRECTOCaptionLbl;
                }
                Column(AYOCaption_Control1100251022Lbl;
                AYOCaption_Control1100251022Lbl)
                {
                    //SourceExpr=A¥OCaption_Control1100251022Lbl;
                }
                Column(PLANIFICACIàNCaptionLbl; PLANIFICACIàNCaptionLbl)
                {
                    //SourceExpr=PLANIFICACIàNCaptionLbl;
                }
                Column(MESCaption_Control1100251100Lbl; MESCaption_Control1100251100Lbl)
                {
                    //SourceExpr=MESCaption_Control1100251100Lbl;
                }
                Column(AYOCaption_Control1100251114Lbl;
                AYOCaption_Control1100251114Lbl)
                {
                    //SourceExpr=A¥OCaption_Control1100251114Lbl;
                }
                Column(ORIGENCaption_Control1100251116Lbl; ORIGENCaption_Control1100251116Lbl)
                {
                    //SourceExpr=ORIGENCaption_Control1100251116Lbl;
                }
                Column(TOTAL_COSTES_INDIRECTOS_CaptionLbl; TOTAL_COSTES_INDIRECTOS_CaptionLbl)
                {
                    //SourceExpr=TOTAL_COSTES_INDIRECTOS_CaptionLbl;
                }
                Column(TOTAL_POR_OBRA_EJECUTADA_CaptionLbl; TOTAL_POR_OBRA_EJECUTADA_CaptionLbl)
                {
                    //SourceExpr=TOTAL_POR_OBRA_EJECUTADA_CaptionLbl;
                }
                Column(DPFP_JobNo; "Data Piecework For Production"."Job No.")
                {
                    //SourceExpr="Data Piecework For Production"."Job No." ;
                }
                trigger OnPreDataItem();
                BEGIN
                    LastFieldNo := FIELDNO("Job No.");

                    CurrReport.CREATETOTALS(CostMonth, CostOrigin, CostPlannedMonth, CostPlannedOrigin);
                    CurrReport.CREATETOTALS(CostPlannedAge, CostAge);

                    "Data Piecework For Production".SETRANGE("Budget Filter", CodBudgetOfCourse);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    FunInitVar;
                    SETRANGE("Data Piecework For Production"."Filter Date");
                    CALCFIELDS("Data Piecework For Production"."Planned Expense");
                    ExpensesPlanningTotal := "Data Piecework For Production"."Planned Expense";
                    //MES
                    SETRANGE("Data Piecework For Production"."Filter Date", DateSince, DateUntil);
                    CALCFIELDS("Data Piecework For Production"."Amount Cost Budget (JC)", "Data Piecework For Production"."Amount Cost Performed (JC)", "Data Piecework For Production"."Planned Expense");
                    CostMonth := "Data Piecework For Production"."Amount Cost Performed (JC)";
                    IF ExpensesPlanningTotal <> 0 THEN
                        CostPlannedMonth := "Data Piecework For Production"."Planned Expense"
                    ELSE BEGIN
                        IF DateUntil < BudgetJob."Budget Date" THEN
                            CostPlannedMonth := 0
                        ELSE
                            CostPlannedMonth := "Data Piecework For Production"."Amount Cost Budget (JC)";
                    END;

                    //a¤o
                    SETRANGE("Data Piecework For Production"."Filter Date", DateInit, DateUntil);
                    CALCFIELDS("Data Piecework For Production"."Amount Cost Budget (JC)", "Data Piecework For Production"."Amount Cost Performed (JC)", "Data Piecework For Production"."Planned Expense");
                    CostAge := "Data Piecework For Production"."Amount Cost Performed (JC)";
                    IF ExpensesPlanningTotal <> 0 THEN
                        CostPlannedAge := "Data Piecework For Production"."Planned Expense"
                    ELSE BEGIN
                        IF DateUntil < BudgetJob."Budget Date" THEN
                            CostPlannedAge := 0
                        ELSE
                            CostPlannedAge := "Data Piecework For Production"."Amount Cost Budget (JC)";
                    END;

                    //Origen
                    SETRANGE("Data Piecework For Production"."Filter Date", 0D, DateUntil);
                    CALCFIELDS("Data Piecework For Production"."Amount Cost Budget (JC)", "Data Piecework For Production"."Amount Cost Performed (JC)", "Data Piecework For Production"."Planned Expense");
                    CostOrigin := "Data Piecework For Production"."Amount Cost Performed (JC)";
                    IF ExpensesPlanningTotal <> 0 THEN
                        CostPlannedOrigin := "Data Piecework For Production"."Planned Expense"
                    ELSE
                        CostPlannedOrigin := "Data Piecework For Production"."Amount Cost Budget (JC)";

                    decI1 := CostMonth - CostPlannedMonth;

                    IF CostPlannedMonth = 0 THEN
                        decI2 := 100
                    ELSE
                        decI2 := (decI1 / CostPlannedMonth) * 100;

                    IF (CostPlannedMonth = 0) AND (CostMonth = 0) THEN
                        decI2 := 0;


                    decJ1 := CostAge - CostPlannedAge;

                    IF CostPlannedAge = 0 THEN
                        decJ2 := 100
                    ELSE
                        decJ2 := (decJ1 / CostPlannedAge) * 100;

                    IF (CostPlannedAge = 0) AND (CostAge = 0) THEN
                        decJ2 := 0;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IntAge := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 3);
                IntMonth := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 2);

                IF (IntAge = 0) OR (IntMonth = 0) THEN
                    ERROR(Text50000);

                DateSince := DMY2DATE(1, IntMonth, IntAge);
                DateUntil := CALCDATE('PM', DateSince);
                DateInit := DMY2DATE(1, 1, IntAge);

                CurrReport.CREATETOTALS(CostMonth, CostOrigin, CostPlannedMonth, CostPlannedOrigin);

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF GETFILTER(Job."Budget Filter") <> '' THEN
                    CodBudgetOfCourse := GETFILTER(Job."Budget Filter")
                ELSE BEGIN
                    IF Job."Current Piecework Budget" <> '' THEN
                        CodBudgetOfCourse := Job."Current Piecework Budget"
                    ELSE
                        CodBudgetOfCourse := Job."Initial Budget Piecework";
                END;

                BudgetJob.GET("No.", CodBudgetOfCourse);

                Job.SETRANGE("Budget Filter", CodBudgetOfCourse);

                SETRANGE("Posting Date Filter", DateSince, DateUntil);
                CALCFIELDS(Job."Budget Cost Amount", "Usage (Cost) (LCY)", Job."Production Budget Amount", Job."Measure Amount");

                CostRealMonthTotal := "Usage (Cost) (LCY)";
                CostPlannedMonthTotal := Job."Budget Cost Amount";
                CostSalesMonthTotal := Job."Measure Amount";

                SETRANGE("Posting Date Filter", DateInit, DateUntil);
                SETRANGE("Budget Filter", Job."Current Piecework Budget");
                CALCFIELDS(Job."Budget Cost Amount", "Usage (Cost) (LCY)", Job."Production Budget Amount", Job."Measure Amount");
                CostRealAgeTotal := "Usage (Cost) (LCY)";
                CostPlannedAgeTotal := Job."Budget Cost Amount";
                CostSalesAgeTotal := "Measure Amount";


                SETRANGE("Posting Date Filter", 0D, DateUntil);
                SETRANGE("Budget Filter", Job."Current Piecework Budget");
                CALCFIELDS(Job."Budget Cost Amount", "Usage (Cost) (LCY)", Job."Production Budget Amount", Job."Measure Amount");
                CostRealOrignTotal := "Usage (Cost) (LCY)";
                CostPlannedOriginTotal := Job."Budget Cost Amount";
                CostSalesOriginTotal := "Measure Amount";
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
        //       LastFieldNo@7001145 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001144 :
        FooterPrinted: Boolean;
        //       IntAge@7001143 :
        IntAge: Integer;
        //       IntMonth@7001142 :
        IntMonth: Integer;
        //       DateSince@7001141 :
        DateSince: Date;
        //       DateUntil@7001140 :
        DateUntil: Date;
        //       DateInit@7001139 :
        DateInit: Date;
        //       CostMonth@7001138 :
        CostMonth: Decimal;
        //       CostAge@7001173 :
        CostAge: Decimal;
        //       CostOrigin@7001137 :
        CostOrigin: Decimal;
        //       CostPlannedMonth@7001136 :
        CostPlannedMonth: Decimal;
        //       CostPlannedAge@7001135 :
        CostPlannedAge: Decimal;
        //       CostPlannedOrigin@7001172 :
        CostPlannedOrigin: Decimal;
        //       DeviationMonth@7001134 :
        DeviationMonth: Decimal;
        //       DeviationAge@7001133 :
        DeviationAge: Decimal;
        //       deviationOrigin@7001101 :
        deviationOrigin: Decimal;
        //       PercentageMeasure@7001132 :
        PercentageMeasure: Decimal;
        //       BudgetMeasure@7001131 :
        BudgetMeasure: Decimal;
        //       BudgetOriginMeasure@7001130 :
        BudgetOriginMeasure: Decimal;
        //       PercentageOriginMeasure@7001129 :
        PercentageOriginMeasure: Decimal;
        //       decE2@7001128 :
        decE2: Decimal;
        //       decD2@7001127 :
        decD2: Decimal;
        //       decF2@7001126 :
        decF2: Decimal;
        //       decG2@7001125 :
        decG2: Decimal;
        //       decI1@7001124 :
        decI1: Decimal;
        //       decI2@7001123 :
        decI2: Decimal;
        //       decJ1@7001122 :
        decJ1: Decimal;
        //       decJ2@7001121 :
        decJ2: Decimal;
        //       CostPlannedMonthTotal@7001120 :
        CostPlannedMonthTotal: Decimal;
        //       CostPlannedAgeTotal@7001119 :
        CostPlannedAgeTotal: Decimal;
        //       CostPlannedOriginTotal@7001118 :
        CostPlannedOriginTotal: Decimal;
        //       CostRealMonthTotal@7001117 :
        CostRealMonthTotal: Decimal;
        //       CostRealAgeTotal@7001116 :
        CostRealAgeTotal: Decimal;
        //       CostRealOrignTotal@7001115 :
        CostRealOrignTotal: Decimal;
        //       CostSalesMonthTotal@7001114 :
        CostSalesMonthTotal: Decimal;
        //       CostSalesAgeTotal@7001113 :
        CostSalesAgeTotal: Decimal;
        //       CostSalesOriginTotal@7001112 :
        CostSalesOriginTotal: Decimal;
        //       totI1@7001111 :
        totI1: Decimal;
        //       totI2@7001110 :
        totI2: Decimal;
        //       totJ1@7001109 :
        totJ1: Decimal;
        //       totJ2@7001108 :
        totJ2: Decimal;
        //       CompanyInformation@7001107 :
        CompanyInformation: Record 79;
        //       ExpensesPlanningTotal@7001106 :
        ExpensesPlanningTotal: Decimal;
        //       CodBudgetOfCourse@7001105 :
        CodBudgetOfCourse: Code[20];
        //       BudgetJob@7001104 :
        BudgetJob: Record 7207407;
        //       zz@7001103 :
        zz: Integer;
        //       Text50000@7001171 :
        Text50000: TextConst ENU = 'Your must indicate Year and Month of the Job Report', ESP = 'Debe indicicar A¤o y mes del informe de obra';
        //       COSTE_REAL_DE_OBRACaptionLbl@7001170 :
        COSTE_REAL_DE_OBRACaptionLbl: TextConst ENU = 'REAL COST JOB', ESP = 'COSTE REAL DE OBRA';
        //       CurrReport_PAGENOCaptionLbl@7001169 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       COSTE_INDIRECTOCaptionLbl@7001168 :
        COSTE_INDIRECTOCaptionLbl: TextConst ENU = 'INDIRECT COST', ESP = 'COSTE INDIRECTO';
        //       Job__No___________Job_DescriptionCaptionLbl@7001167 :
        Job__No___________Job_DescriptionCaptionLbl: TextConst ENU = 'JOB:', ESP = 'OBRA:';
        //       A¥O_CaptionLbl@7001166 :
        AYO_CaptionLbl: TextConst ENU = 'YEAR:', ESP = 'A¥O:';
        //       MES_CaptionLbl@7001165 :
        MES_CaptionLbl: TextConst ENU = 'MONTH:', ESP = 'MES:';
        //       OPERACIONCaptionLbl@7001164 :
        OPERACIONCaptionLbl: TextConst ENU = 'OPERATION', ESP = 'OPERACION';
        //       DESCRIPCIONCaptionLbl@7001163 :
        DESCRIPCIONCaptionLbl: TextConst ENU = 'DESCRIPTION', ESP = 'DESCRIPCION';
        //       MESCaptionLbl@7001162 :
        MESCaptionLbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       ORIGENCaptionLbl@7001161 :
        ORIGENCaptionLbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       REALCaptionLbl@7001160 :
        REALCaptionLbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       VENTACaptionLbl@7001159 :
        VENTACaptionLbl: TextConst ENU = 'SALES', ESP = 'VENTA';
        //       MESCaption_Control1100251031Lbl@7001158 :
        MESCaption_Control1100251031Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       ORIGENCaption_Control1100251032Lbl@7001157 :
        ORIGENCaption_Control1100251032Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       MESCaption_Control1100251033Lbl@7001156 :
        MESCaption_Control1100251033Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       A¥OCaptionLbl@7001155 :
        AYOCaptionLbl: TextConst ENU = 'YEAR', ESP = 'A¥O';
        //       DESVIACIONES_IMPORTE_____S_MA_CaptionLbl@7001154 :
        DESVIACIONES_IMPORTE_____S_MA_CaptionLbl: TextConst ENU = 'AMOUNT DESVIATION % S.MA.', ESP = 'DESVIACIONES IMPORTE - % S.MA.';
        //       COSTE_TOTAL_INDIRECTOCaptionLbl@7001153 :
        COSTE_TOTAL_INDIRECTOCaptionLbl: TextConst ENU = 'INDIRECT TOTAL COST', ESP = 'COSTE TOTAL INDIRECTO';
        //       A¥OCaption_Control1100251022Lbl@7001152 :
        AYOCaption_Control1100251022Lbl: TextConst ENU = 'YEAR', ESP = 'A¥O';
        //       PLANIFICACIàNCaptionLbl@7001151 :
        PLANIFICACIàNCaptionLbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICACIàN';
        //       MESCaption_Control1100251100Lbl@7001150 :
        MESCaption_Control1100251100Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       A¥OCaption_Control1100251114Lbl@7001149 :
        AYOCaption_Control1100251114Lbl: TextConst ENU = 'YEAR', ESP = 'A¥O';
        //       ORIGENCaption_Control1100251116Lbl@7001148 :
        ORIGENCaption_Control1100251116Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       TOTAL_COSTES_INDIRECTOS_CaptionLbl@7001147 :
        TOTAL_COSTES_INDIRECTOS_CaptionLbl: TextConst ENU = ' INDIRECT TOTAL COST:', ESP = 'TOTAL COSTES INDIRECTOS:';
        //       TOTAL_POR_OBRA_EJECUTADA_CaptionLbl@7001146 :
        TOTAL_POR_OBRA_EJECUTADA_CaptionLbl: TextConst ENU = 'TOTAL OF JOB EXECUTED:', ESP = 'TOTAL POR OBRA EJECUTADA:';

    procedure FunInitVar()
    begin
        CostMonth := 0;
        CostOrigin := 0;
        CostPlannedMonth := 0;
        CostPlannedOrigin := 0;
        DeviationMonth := 0;
        deviationOrigin := 0;
        PercentageMeasure := 0;
        BudgetOriginMeasure := 0;
        BudgetMeasure := 0;
        decJ2 := 0;
        decJ1 := 0;
        decI1 := 0;
        decI2 := 0;
        decE2 := 0;
        decF2 := 0;
        decG2 := 0;
        decD2 := 0;
        CostPlannedAge := 0;
        CostAge := 0;
        DeviationAge := 0;
    end;

    /*begin
    end.
  */

}




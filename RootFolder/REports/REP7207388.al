report 7207388 "Indirect Cost Plan Summary"
{


    CaptionML = ENU = 'Indirect Cost Plan Summary', ESP = 'Resumen plan costes indirectos';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Posting Date Filter";
            Column(Job_No; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            DataItem("Integer"; "Integer")
            {

                DataItemTableView = SORTING("Number");
                ;
                Column(IntAge; IntAge)
                {
                    //SourceExpr=IntAge;
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(JobNo__JobDescription; Job."No." + ' ' + Job.Description)
                {
                    //SourceExpr=Job."No." + ' ' + Job.Description;
                }
                Column(decOOriginExecuted1; decOOriginExecuted1)
                {
                    //SourceExpr=decOOriginExecuted1;
                }
                Column(IntMonth; IntMonth)
                {
                    //SourceExpr=IntMonth;
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(CurrReportPAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(CompanyInformationPicture; CompanyInformation.Picture)
                {
                    //SourceExpr=CompanyInformation.Picture;
                }
                Column(AMORTIZATION_OF_PREVIOUSLY; AMORTIZATION_OF_PREVIOUSLY)
                {
                    //SourceExpr=AMORTIZATION_OF_PREVIOUSLY;
                }
                Column(CURRENT_EXPENSES; CURRENT_EXPENSES)
                {
                    //SourceExpr=CURRENT_EXPENSES;
                }
                Column(AMORTIZATION_OF_FIXED_ASSETS; AMORTIZATION_OF_FIXED_ASSETS)
                {
                    //SourceExpr=AMORTIZATION_OF_FIXED_ASSETS;
                }
                Column(AMORTIZATION_DEFERRED; AMORTIZATION_DEFERRED)
                {
                    //SourceExpr=AMORTIZATION_DEFERRED;
                }
                Column(decSummary_2_; decSummary[2])
                {
                    //SourceExpr=decSummary[2];
                }
                Column(decDeviation_2_; decDeviation[2])
                {
                    //SourceExpr=decDeviation[2];
                }
                Column(deSummary_1_; decSummary[1])
                {
                    //SourceExpr=decSummary[1];
                }
                Column(decDesviacion_1_; decDeviation[1])
                {
                    //SourceExpr=decDeviation[1];
                }
                Column(decSummary_3_; decSummary[3])
                {
                    //SourceExpr=decSummary[3];
                }
                Column(decDesviacion_3_; decDeviation[3])
                {
                    //SourceExpr=decDeviation[3];
                }
                Column(decSummary_4_; decSummary[4])
                {
                    //SourceExpr=decSummary[4];
                }
                Column(decDesviacion_4_; decDeviation[4])
                {
                    //SourceExpr=decDeviation[4];
                }
                Column(decSummary_1____decSummary_2____decSummary_3____decSummary_4_; decSummary[1] + decSummary[2] + decSummary[3] + decSummary[4])
                {
                    //SourceExpr=decSummary[1] + decSummary[2] + decSummary[3] + decSummary[4];
                }
                Column(decDesviacion_5_; decDeviation[5])
                {
                    //SourceExpr=decDeviation[5];
                }
                Column(AGE_CaptionLbl; AGE_CaptionLbl)
                {
                    //SourceExpr=AGE_CaptionLbl;
                }
                Column(Job__No___________Job_DescriptionCaptionLbl; Job__No___________Job_DescriptionCaptionLbl)
                {
                    //SourceExpr=Job__No___________Job_DescriptionCaptionLbl;
                }
                Column(EXECUTEJOBCaptionLbl; "EXECUTE JOB_CaptionLbl")
                {
                    //SourceExpr="EXECUTE JOB_CaptionLbl";
                }
                Column(MONTH_CaptionLbl; MONTH_CaptionLbl)
                {
                    //SourceExpr=MONTH_CaptionLbl;
                }
                Column(REPORT_PLANIFICATION_OF_JOB_INDIRECT_COSTSCaptionLbl; "REPORT PLANIFICATION OF JOB INDIRECT COSTSCaptionLbl")
                {
                    //SourceExpr="REPORT PLANIFICATION OF JOB INDIRECT COSTSCaptionLbl";
                }
                Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(CONCEPTCaptionLbl; CONCEPTCaptionLbl)
                {
                    //SourceExpr=CONCEPTCaptionLbl;
                }
                Column(S__O_E_CaptionLbl; S__O_E_CaptionLbl)
                {
                    //SourceExpr=S__O_E_CaptionLbl;
                }
                Column(AMOUNTCaptionLbl; AMOUNTCaptionLbl)
                {
                    //SourceExpr=AMOUNTCaptionLbl;
                }
                Column(INDIRECT_TOTAL_COSTCaptionLbl; INDIRECT_TOTAL_COSTCaptionLbl)
                {
                    //SourceExpr=INDIRECT_TOTAL_COSTCaptionLbl;
                }
                Column(TOTALCaptionLbl; TOTALCaptionLbl)
                {
                    //SourceExpr=TOTALCaptionLbl;
                }
                Column(EmptyStringCaptionLbl; EmptyStringCaptionLbl)
                {
                    //SourceExpr=EmptyStringCaptionLbl;
                }
                Column(EmptyStringCaption_Control1100251069Lbl; EmptyStringCaption_Control1100251069Lbl)
                {
                    //SourceExpr=EmptyStringCaption_Control1100251069Lbl;
                }
                Column(EmptyStringCaption_Control1100251070Lbl; EmptyStringCaption_Control1100251070Lbl)
                {
                    //SourceExpr=EmptyStringCaption_Control1100251070Lbl;
                }
                Column(EmptyStringCaption_Control1100251071Lbl; EmptyStringCaption_Control1100251071Lbl)
                {
                    //SourceExpr=EmptyStringCaption_Control1100251071Lbl;
                }
                Column(EmptyStringCaption_Control1100251078Lbl; EmptyStringCaption_Control1100251078Lbl)
                {
                    //SourceExpr=EmptyStringCaption_Control1100251078Lbl;
                }
                Column(Integer_number; Number)
                {
                    //SourceExpr=Number;
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Cost Unit"));


                    DataItemLinkReference = "Job";
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(txtTitle; txtTitle)
                    {
                        //SourceExpr=txtTitle;
                    }
                    Column(DataPieceworkForProduction_PieceworkCode; "Data Piecework For Production"."Piecework Code")
                    {
                        //SourceExpr="Data Piecework For Production"."Piecework Code";
                    }
                    Column(DataPieceworkForProduction_Description; "Data Piecework For Production".Description)
                    {
                        //SourceExpr="Data Piecework For Production".Description;
                    }
                    Column(decCostPlannedOrigin; decCostPlannedOrigin)
                    {
                        //SourceExpr=decCostPlannedOrigin;
                    }
                    Column(decOriginDeviation; decOriginDeviation)
                    {
                        //SourceExpr=decOriginDeviation;
                    }
                    Column(decOriginDeviation_Control1100251015; decOriginDeviation)
                    {
                        //SourceExpr=decOriginDeviation;
                    }
                    Column(decCostPlannedOrigin_Control1100251016; decCostPlannedOrigin)
                    {
                        //SourceExpr=decCostPlannedOrigin;
                    }
                    Column(S__O_E_Caption_Control1100251032Lbl; S__O_E_Caption_Control1100251032Lbl)
                    {
                        //SourceExpr=S__O_E_Caption_Control1100251032Lbl;
                    }
                    Column(AMOUNTCaption_Control1100251031Lbl; AMOUNTCaption_Control1100251031Lbl)
                    {
                        //SourceExpr=AMOUNTCaption_Control1100251031Lbl;
                    }
                    Column(DESCRIPTIONCaptionLbl; DESCRIPTIONCaptionLbl)
                    {
                        //SourceExpr=DESCRIPTIONCaptionLbl;
                    }
                    Column(OPERATIONCaptionLbl; OPERATIONCaptionLbl)
                    {
                        //SourceExpr=OPERATIONCaptionLbl;
                    }
                    Column(EmptyStringCaption_Control1100251066Lbl; EmptyStringCaption_Control1100251066Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control1100251066Lbl;
                    }
                    Column(TOTALCaption_Control1100251013Lbl; TOTALCaption_Control1100251013Lbl)
                    {
                        //SourceExpr=TOTALCaption_Control1100251013Lbl;
                    }
                    Column(EmptyStringCaption_Control1100251067Lbl; EmptyStringCaption_Control1100251067Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control1100251067Lbl;
                    }
                    Column(DataPieceworkForProduction_JobNo; "Data Piecework For Production"."Job No.")
                    {
                        //SourceExpr="Data Piecework For Production"."Job No." ;
                    }
                    trigger OnPreDataItem();
                    BEGIN
                        "Data Piecework For Production".SETRANGE("Subtype Cost", Integer.Number);

                        IF (IntAge = 0) OR (IntMonth = 0) THEN
                            ERROR(Text50000);

                        DateSince := DMY2DATE(1, IntMonth, IntAge);
                        DateUntil := CALCDATE('PM', DateSince);

                        "Data Piecework For Production".SETRANGE("Budget Filter", codePptoCourse);
                        //To be refactored
                        //CurrReport.CREATETOTALS(decCostPlannedOrigin, decSummary);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        FunIniciavariables;

                        //SETRANGE("Data Filter",0D,dateSince);
                        //CALCFIELDS(Job."Budget Cost Amount");
                        decCostPlannedOrigin := Job."Budget Cost Amount";
                        decSummary[Integer.Number] := decCostPlannedOrigin;

                        IF decOOriginExecuted1 <> 0 THEN
                            decOriginDeviation := ROUND(decCostPlannedOrigin * 100 / decOOriginExecuted1, 0.01)
                        ELSE
                            decOriginDeviation := 0;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    Integer.SETRANGE(Number, 1, 4);
                    //To be refactored
                    //CurrReport.CREATETOTALS(decCostPlannedOrigin, decSummary);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    CASE Integer.Number OF
                        1:
                            txtTitle := 'AMORTIZATION OF PREVIOUSLY';
                        2:
                            txtTitle := 'CURRENT EXPENSES';
                        3:
                            txtTitle := 'AMORTIZATION OF FIXED ASSETS';
                        4:
                            txtTitle := 'AMORTIZATION DEFERRED';
                    END;
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

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF GETFILTER(Job."Budget Filter") <> '' THEN
                    codePptoCourse := GETFILTER(Job."Budget Filter")
                ELSE BEGIN
                    IF Job."Initial Budget Piecework" <> '' THEN
                        codePptoCourse := Job."Initial Budget Piecework"

                    ELSE
                        codePptoCourse := Job."Initial Budget Piecework";
                END;

                Job.SETRANGE("Budget Filter", codePptoCourse);

                Job.SETRANGE("Posting Date Filter", 0D, DateUntil);

                Job.CALCFIELDS("Actual Production Amount");
                //Job.SETRANGE("Posting Date Filter",dateUntil+1,31129999D);

                Job.CALCFIELDS("Production Budget Amount");
                decOOriginExecuted1 := Job."Production Budget Amount";
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
        //       LastFieldNo@7001113 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001112 :
        FooterPrinted: Boolean;
        //       IntAge@7001111 :
        IntAge: Integer;
        //       IntMonth@7001110 :
        IntMonth: Integer;
        //       DateSince@7001109 :
        DateSince: Date;
        //       DateUntil@7001108 :
        DateUntil: Date;
        //       decCostPlannedOrigin@7001107 :
        decCostPlannedOrigin: Decimal;
        //       decOOriginExecuted1@7001106 :
        decOOriginExecuted1: Decimal;
        //       decOriginDeviation@7001105 :
        decOriginDeviation: Decimal;
        //       txtTitle@7001104 :
        txtTitle: Text[50];
        //       decSummary@7001103 :
        decSummary: ARRAY[4] OF Decimal;
        //       decDeviation@7001102 :
        decDeviation: ARRAY[5] OF Decimal;
        //       CompanyInformation@7001101 :
        CompanyInformation: Record 79;
        //       codePptoCourse@7001100 :
        codePptoCourse: Code[20];
        //       Text50000@7001137 :
        Text50000: TextConst ENU = '<Debe indicar A¤o y mes del informe de obra>', ESP = 'Debe indicicar A¤o y mes del informe de obra';
        //       AGE_CaptionLbl@7001136 :
        AGE_CaptionLbl: TextConst ENU = 'AGE:', ESP = 'A¥O:';
        //       Job__No___________Job_DescriptionCaptionLbl@7001135 :
        Job__No___________Job_DescriptionCaptionLbl: TextConst ENU = '<JOB:>', ESP = 'OBRA:';
        //       "EXECUTE JOB_CaptionLbl"@7001134 :
        "EXECUTE JOB_CaptionLbl": TextConst ENU = '<EXECUTE JOB:>', ESP = 'OBRA EJECUTADA:';
        //       MONTH_CaptionLbl@7001133 :
        MONTH_CaptionLbl: TextConst ENU = 'MONTH:', ESP = 'MES:';
        //       "REPORT PLANIFICATION OF JOB INDIRECT COSTSCaptionLbl"@7001132 :
        "REPORT PLANIFICATION OF JOB INDIRECT COSTSCaptionLbl": TextConst ENU = 'REPORT PLANIFICATION OF JOB INDIRECT COSTS', ESP = 'INFORME PLANIFICACIàN DE COSTES INDIRECTOS DE OBRA';
        //       CurrReport_PAGENOCaptionLbl@7001131 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       CONCEPTCaptionLbl@7001130 :
        CONCEPTCaptionLbl: TextConst ENU = '<CONCEPT>', ESP = 'CONCEPTOS';
        //       S__O_E_CaptionLbl@7001129 :
        S__O_E_CaptionLbl: TextConst ESP = '% S/ O.E.';
        //       AMOUNTCaptionLbl@7001128 :
        AMOUNTCaptionLbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       INDIRECT_TOTAL_COSTCaptionLbl@7001127 :
        INDIRECT_TOTAL_COSTCaptionLbl: TextConst ENU = 'INDIRECT TOTAL COST', ESP = 'TOTAL COSTES INDIRECTOS';
        //       TOTALCaptionLbl@7001126 :
        TOTALCaptionLbl: TextConst ENU = '<TOTAL>', ESP = 'TOTALES';
        //       EmptyStringCaptionLbl@7001125 :
        EmptyStringCaptionLbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251069Lbl@7001124 :
        EmptyStringCaption_Control1100251069Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251070Lbl@7001123 :
        EmptyStringCaption_Control1100251070Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251071Lbl@7001122 :
        EmptyStringCaption_Control1100251071Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251078Lbl@7001121 :
        EmptyStringCaption_Control1100251078Lbl: TextConst ESP = '%';
        //       S__O_E_Caption_Control1100251032Lbl@7001120 :
        S__O_E_Caption_Control1100251032Lbl: TextConst ESP = '% S/ O.E.';
        //       AMOUNTCaption_Control1100251031Lbl@7001119 :
        AMOUNTCaption_Control1100251031Lbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       DESCRIPTIONCaptionLbl@7001118 :
        DESCRIPTIONCaptionLbl: TextConst ENU = '<DESCRIPTION>', ESP = 'DESCRIPCION';
        //       OPERATIONCaptionLbl@7001117 :
        OPERATIONCaptionLbl: TextConst ENU = '<OPERATION>', ESP = 'OPERACION';
        //       EmptyStringCaption_Control1100251066Lbl@7001116 :
        EmptyStringCaption_Control1100251066Lbl: TextConst ESP = '%';
        //       TOTALCaption_Control1100251013Lbl@7001115 :
        TOTALCaption_Control1100251013Lbl: TextConst ENU = '<TOTAL>', ESP = 'TOTALES';
        //       EmptyStringCaption_Control1100251067Lbl@7001114 :
        EmptyStringCaption_Control1100251067Lbl: TextConst ESP = '%';
        //       AMORTIZATION_OF_PREVIOUSLY@7001138 :
        AMORTIZATION_OF_PREVIOUSLY: TextConst ENU = 'AMORTIZATION OF PREVIOUSLY', ESP = 'AMORTIZACIàN DE ANTICIPADOS';
        //       CURRENT_EXPENSES@7001139 :
        CURRENT_EXPENSES: TextConst ENU = 'CURRENT EXPENSES', ESP = 'GASTOS CORRIENTES';
        //       AMORTIZATION_OF_FIXED_ASSETS@7001140 :
        AMORTIZATION_OF_FIXED_ASSETS: TextConst ENU = 'AMORTIZATION OF FIXED ASSETS', ESP = 'AMORTIZACIàN DE INMOVILIZADO';
        //       AMORTIZATION_DEFERRED@7001141 :
        AMORTIZATION_DEFERRED: TextConst ENU = 'AMORTIZATION DEFERRED', ESP = 'AMORTIZACIàN DIFERIDOS';

    LOCAL procedure FunIniciavariables()
    begin
        decCostPlannedOrigin := 0;
        decOriginDeviation := 0;
    end;

    /*begin
    end.
  */

}




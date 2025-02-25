report 7207365 "General Expenses Budget"
{


    CaptionML = ENU = 'General Expenses Budget', ESP = 'Presupuesto de gastos generales';

    dataset
    {

        DataItem("Selection"; "Job")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Job', ESP = 'Obra';


            RequestFilterFields = "No.", "Budget Filter";
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
                //SourceExpr=FORMAT(TODAY,0,4);
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(FORMAT__No____________Description; FORMAT("No.") + '  ' + Description + "Description 2")
            {
                //SourceExpr=FORMAT("No.") + '  ' +Description+"Description 2";
            }
            Column(JobText____; JobText + ':')
            {
                //SourceExpr=JobText+':';
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(BudgetText; BudgetText2 + ' ' + BudgetText)
            {
                //SourceExpr=BudgetText2+' '+BudgetText;
            }
            Column(TextBudget_; TextBudget)
            {
                //SourceExpr=TextBudget;
            }
            Column(General_Expenses_BudgetCaption; General_Expenses_BudgetCaptionLbl)
            {
                //SourceExpr=General_Expenses_BudgetCaptionLbl;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(PieceworkCaption; PieceworkCaptionLbl)
            {
                //SourceExpr=PieceworkCaptionLbl;
            }
            Column(Unit_Of_MeasureCaption; Unit_Of_MeasureCaptionLbl)
            {
                //SourceExpr=Unit_Of_MeasureCaptionLbl;
            }
            Column(DescriptionCaption; DescriptionCaptionLbl)
            {
                //SourceExpr=DescriptionCaptionLbl;
            }
            Column(TotalCaption; TotalCaptionLbl)
            {
                //SourceExpr=TotalCaptionLbl;
            }
            Column(RealCaption; RealCaptionLbl)
            {
                //SourceExpr=RealCaptionLbl;
            }
            Column(PendingCaption; PendingCaptionLbl)
            {
                //SourceExpr=PendingCaptionLbl;
            }
            Column(CostCaption; CostCaptionLbl)
            {
                //SourceExpr=CostCaptionLbl;
            }
            Column(E__J_Caption; E__J_CaptionLbl)
            {
                //SourceExpr=E__J_CaptionLbl;
            }
            Column(CostCaption_Control47; CostCaption_Control47Lbl)
            {
                //SourceExpr=CostCaption_Control47Lbl;
            }
            Column(E__J_Caption_Control48; E__J_Caption_Control48Lbl)
            {
                //SourceExpr=E__J_Caption_Control48Lbl;
            }
            Column(CostCaption_Control53; CostCaption_Control53Lbl)
            {
                //SourceExpr=CostCaption_Control53Lbl;
            }
            Column(E__J_Caption_Control55; E__J_Caption_Control55Lbl)
            {
                //SourceExpr=E__J_Caption_Control55Lbl;
            }
            Column(Production_In_ProcessCaption; Production_In_ProcessCaptionLbl)
            {
                //SourceExpr=Production_In_ProcessCaptionLbl;
            }
            Column(Selection_No_; "No.")
            {
                //SourceExpr="No.";
            }
            DataItem("Job"; "Job")
            {

                DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(Job_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(VarJobBudget; VarJobBudget)
                {
                    //SourceExpr=VarJobBudget;
                }
                Column(BudgetPerformedJob; BudgetPerformedJob)
                {
                    //SourceExpr=BudgetPerformedJob;
                }
                Column(PendingCostAmount; PendingCostAmount)
                {
                    //SourceExpr=PendingCostAmount;
                }
                Column(Pcttotal; Pcttotal)
                {
                    //SourceExpr=Pcttotal;
                }
                Column(PctReal; PctReal)
                {
                    //SourceExpr=PctReal;
                }
                Column(PctPending; PctPending)
                {
                    //SourceExpr=PctPending;
                }
                Column(Total_JobCaption; Total_jobCaptionLbl)
                {
                    //SourceExpr=Total_jobCaptionLbl;
                }
                Column(Job_No_; "No.")
                {
                    //SourceExpr="No.";
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Cost Unit"));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(COPYSTR_Spaces_1_Indentation_2___Data_Piecework_For_Production___Description; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(Data_Piecework_For_Production___Amount_Cost_Budget__; "Amount Cost Budget (JC)")
                    {
                        //SourceExpr="Amount Cost Budget (JC)";
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production____Amount_Cost_Realized_; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(AmountCostPending; AmountCostPending)
                    {
                        //SourceExpr=AmountCostPending;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2___Piecework_Code_; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Pcttotal_Control1100251016; Pcttotal)
                    {
                        //SourceExpr=Pcttotal;
                    }
                    Column(PctReal_Control1100251017; PctReal)
                    {
                        //SourceExpr=PctReal;
                    }
                    Column(PctPending_Control1100251018; PctPending)
                    {
                        //SourceExpr=PctPending;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2___Data_Piecework_For_Production___Description_Control1100251000; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(Data_Piecework_For_Production___Amount_Cost_Budget___Control1100251001; "Amount Cost Budget (JC)")
                    {
                        //SourceExpr="Amount Cost Budget (JC)";
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production____Amount_Cost_Performed__Control1100251002; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(AmountCostPending_Control1100251003; AmountCostPending)
                    {
                        //SourceExpr=AmountCostPending;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2___Piecework_Code__Control1100251004; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Pcttotal_Control1100251005; Pcttotal)
                    {
                        //SourceExpr=Pcttotal;
                    }
                    Column(PctReal_Control1100251006; PctReal)
                    {
                        //SourceExpr=PctReal;
                    }
                    Column(PctPending_Control1100251007; 250117)
                    {
                        //SourceExpr=250117;
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production____Unit_Of_Measure_; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2___Data_Piecework_For_Production___Description_Control11; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(Data_Piecework_For_Production___Amount_Cost_Budget___Control30; "Amount Cost Budget (JC)")
                    {
                        //SourceExpr="Amount Cost Budget (JC)";
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production____Amount_Cost_Performed__Control33; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(AmountCostPending_Control34; AmountCostPending)
                    {
                        //SourceExpr=AmountCostPending;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2___Piecework_Code__Control7; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Pcttotal_Control31; Pcttotal)
                    {
                        //SourceExpr=Pcttotal;
                    }
                    Column(PctReal_Control32; PctReal)
                    {
                        //SourceExpr=PctReal;
                    }
                    Column(PctPending_Control35; PctPending)
                    {
                        //SourceExpr=PctPending;
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production______Processed_Production_; "Data Piecework For Production"."% Processed Production")
                    {
                        //SourceExpr="Data Piecework For Production"."% Processed Production";
                    }
                    Column(Data_Piecework_For_Production__Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Data_Piecework_For_Production__Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code" ;
                    }
                    trigger OnPreDataItem();
                    BEGIN
                        IF Selection.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Selection."Current Piecework Budget");



                        CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                                "Data Piecework For Production"."Amount Cost Performed (JC)",
                                                 AmountCostPending,
                                                 // Dif,
                                                 VarJobBudget,
                                                 BudgetPerformedJob,
                                                 PendingCostAmount);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Filter Date");
                        SETFILTER("Filter Date", '%1..%2', 0D, PostingDate);

                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        Pcttotal := 0;
                        PctReal := 0;
                        PctPending := 0;

                        IF "% Expense Cost" <> 0 THEN
                            AmountCostPending := "% Expense Cost" * Dif / 100
                        ELSE
                            AmountCostPending := "Amount Cost Budget (JC)" - "Amount Cost Performed (JC)";


                        IF ImpPpto <> 0 THEN
                            Pcttotal := ("Amount Cost Budget (JC)" / ImpPpto) * 100;

                        IF ImpReg <> 0 THEN
                            PctReal := ("Amount Cost Performed (JC)" / ImpReg) * 100;

                        IF Dif <> 0 THEN
                            PctPending := ((AmountCostPending) / Dif) * 100;

                        IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                            VarJobBudget := VarJobBudget + "Data Piecework For Production"."Amount Cost Budget (JC)";
                            BudgetPerformedJob := BudgetPerformedJob + "Data Piecework For Production"."Amount Cost Performed (JC)";
                            PendingCostAmount := PendingCostAmount + (VarJobBudget - BudgetPerformedJob);
                        END;

                        //********************************
                        //Parece que el consolidado en Unidades de Coste no tiene sentido
                        //********************************
                        //{
                        //                                  IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unidad THEN
                        //                                    FunConsolidado("Data Piecework For Production");
                        //                                  }
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    IF Selection.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Selection."Current Piecework Budget");


                    CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                            "Data Piecework For Production"."Amount Cost Performed (JC)",
                                             AmountCostPending,
                                             //Dif,
                                             VarJobBudget,
                                             BudgetPerformedJob,
                                             PendingCostAmount);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Job.SETRANGE("Posting Date Filter");
                    Job.CALCFIELDS("Production Budget Amount");
                    Job.SETFILTER("Posting Date Filter", '%1..%2', 0D, PostingDate);
                    Job.CALCFIELDS("Actual Production Amount");

                    ImpPpto := 0;
                    ImpReg := 0;
                    Dif := 0;

                    ImpPpto := Job.ProductionBudgetWithoutProcess;
                    ImpReg := "Actual Production Amount" - Job.ProductionTheoricalProcess;
                    Dif := ImpPpto - ImpReg;

                    VarJobBudget := 0;
                    BudgetPerformedJob := 0;
                    PendingCostAmount := 0;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IF PostingDate = 0D THEN
                    ERROR(Text0002);

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);

                CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                        "Data Piecework For Production"."Amount Cost Performed (JC)",
                                         AmountCostPending,
                                         // Dif,
                                         VarJobBudget,
                                         BudgetPerformedJob,
                                         PendingCostAmount);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF "Matrix Job it Belongs" <> '' THEN
                    JobText := TextRecord
                ELSE
                    JobText := TextJob;

                IF JobText = TextJob THEN
                    TotalText := TextTotalJob
                ELSE
                    TotalText := TextTotalRecord;


                BudgetText := '';
                IF Selection.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Selection."No.", Selection.GETFILTER("Budget Filter")) THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        BudgetText2 := JobBudget."Cod. Budget";
                    END
                END
                ELSE BEGIN
                    IF JobBudget.GET(Selection."No.", Selection."Current Piecework Budget") THEN BEGIN
                        BudgetText := JobBudget."Budget Name"
                    END;
                END;


                TotImpCosTotConsol := 0;
                TotImpCosRealConsol := 0;
                TotImpCosPteConsol := 0;
                TotImpCosTotBruto := 0;
                TotImpCosRealBruto := 0;
                TotImpCosPteBruto := 0;
            END;


        }
    }
    requestpage
    {
        CaptionML = ENU = 'Date', ESP = 'Fecha';
        layout
        {
            area(content)
            {
                group("group650")
                {

                    field("PostingDate"; "PostingDate")
                    {

                        CaptionML = ENU = 'Date', ESP = 'Fecha';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Text0001@7001117 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Text0002@7001116 :
        Text0002: TextConst ENU = 'You must specify the Report Date', ESP = 'Debe indicar fecha de informe';
        //       TextJob@7001143 :
        TextJob: TextConst ENU = 'Job', ESP = 'Obra';
        //       TextBudget@7001148 :
        TextBudget: TextConst ENU = 'Budget', ESP = 'Presupuesto';
        //       TextTotalJob@7001145 :
        TextTotalJob: TextConst ENU = 'Total Job', ESP = 'Total obra';
        //       TextRecord@7001144 :
        TextRecord: TextConst ENU = 'Record', ESP = 'Expediente';
        //       TextTotalRecord@7001146 :
        TextTotalRecord: TextConst ENU = 'Total Record', ESP = 'Total expediente';
        //       General_Expenses_BudgetCaptionLbl@7001115 :
        General_Expenses_BudgetCaptionLbl: TextConst ENU = 'General Expenses Budget', ESP = 'Presupuesto de gastos generales';
        //       CurrReport_PAGENOCaptionLbl@7001114 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       PieceworkCaptionLbl@7001113 :
        PieceworkCaptionLbl: TextConst ENU = 'Piecework', ESP = 'Unidad obra';
        //       Unit_Of_MeasureCaptionLbl@7001112 :
        Unit_Of_MeasureCaptionLbl: TextConst ENU = 'Unit of Measure', ESP = 'U. med.';
        //       DescriptionCaptionLbl@7001111 :
        DescriptionCaptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       TotalCaptionLbl@7001110 :
        TotalCaptionLbl: TextConst ENU = 'Total', ESP = 'Total';
        //       RealCaptionLbl@7001109 :
        RealCaptionLbl: TextConst ENU = 'Real', ESP = 'Real';
        //       PendingCaptionLbl@7001108 :
        PendingCaptionLbl: TextConst ENU = 'Pending', ESP = 'Pendiente';
        //       CostCaptionLbl@7001107 :
        CostCaptionLbl: TextConst ENU = 'Cost', ESP = 'Coste';
        //       E__J_CaptionLbl@7001106 :
        E__J_CaptionLbl: TextConst ENU = '% E. J.', ESP = '% O. E.';
        //       CostCaption_Control47Lbl@7001105 :
        CostCaption_Control47Lbl: TextConst ENU = 'Cost', ESP = 'Coste';
        //       E__J_Caption_Control48Lbl@7001104 :
        E__J_Caption_Control48Lbl: TextConst ENU = '% E. J.', ESP = '% O. E.';
        //       CostCaption_Control53Lbl@7001103 :
        CostCaption_Control53Lbl: TextConst ENU = 'Cost', ESP = 'Coste';
        //       E__J_Caption_Control55Lbl@7001102 :
        E__J_Caption_Control55Lbl: TextConst ENU = '% O. E.', ESP = '% O. E.';
        //       Production_In_ProcessCaptionLbl@7001101 :
        Production_In_ProcessCaptionLbl: TextConst ENU = '% Production in process', ESP = '% Producci¢n en tr mite';
        //       Total_jobCaptionLbl@7001100 :
        Total_jobCaptionLbl: TextConst ENU = 'Total Job', ESP = 'Total obra';
        //       Niveldetalle@7001142 :
        Niveldetalle: Option "Titulo","Subtitulos","Detalle";
        //       JobText@7001141 :
        JobText: Text[30];
        //       PctPending@7001140 :
        PctPending: Decimal;
        //       ImpPpto@7001139 :
        ImpPpto: Decimal;
        //       ImpReg@7001138 :
        ImpReg: Decimal;
        //       Dif@7001137 :
        Dif: Decimal;
        //       TotalText@7001136 :
        TotalText: Text[30];
        //       CompanyInformation@7001135 :
        CompanyInformation: Record 79;
        //       TotImpCosTotConsol@7001134 :
        TotImpCosTotConsol: Decimal;
        //       TotImpCosRealConsol@7001133 :
        TotImpCosRealConsol: Decimal;
        //       TotImpCosPteConsol@7001132 :
        TotImpCosPteConsol: Decimal;
        //       TotImpCosTotBruto@7001131 :
        TotImpCosTotBruto: Decimal;
        //       TotImpCosRealBruto@7001130 :
        TotImpCosRealBruto: Decimal;
        //       TotImpCosPteBruto@7001129 :
        TotImpCosPteBruto: Decimal;
        //       PostingDate@7001128 :
        PostingDate: Date;
        //       AmountCostPending@7001127 :
        AmountCostPending: Decimal;
        //       Pcttotal@7001126 :
        Pcttotal: Decimal;
        //       PctReal@7001125 :
        PctReal: Decimal;
        //       PctPpto@7001124 :
        PctPpto: Decimal;
        //       VarJobBudget@7001123 :
        VarJobBudget: Decimal;
        //       BudgetPerformedJob@7001122 :
        BudgetPerformedJob: Decimal;
        //       Spaces@7001121 :
        Spaces: Text[30];
        //       PendingCostAmount@7001120 :
        PendingCostAmount: Decimal;
        //       JobBudget@7001118 :
        JobBudget: Record 7207407;
        //       BudgetText@7001119 :
        BudgetText: Text[50];
        //       BudgetText2@7001147 :
        BudgetText2: Text;

    //     procedure ReportDate (parReportDate@1100251000 :
    procedure ReportDate(parReportDate: Date)
    begin
        PostingDate := parReportDate;
    end;

    /*begin
    end.
  */

}




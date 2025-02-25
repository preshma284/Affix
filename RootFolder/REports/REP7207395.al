report 7207395 "Budg. and its Updates"
{


    CaptionML = ESP = 'Presupuestos y sus actualizaciones', ENG = 'Budg. and its Updates';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            Column(decAmountVta___decAmountVtaProv; decAmountVta + decAmountVtaProv)
            {
                //SourceExpr=decAmountVta + decAmountVtaProv;
            }
            Column(decAmountCostTotal___decAmountCostTotalProv; decAmountCostTotal + decAmountCostTotalProv)
            {
                //SourceExpr=decAmountCostTotal + decAmountCostTotalProv;
            }
            Column(decAmountCostDirect___decAmountCostDirectInd__decAmountCostDirectProv; decAmountCostDirect + decAmountCostDirectInd + decAmountCostDirectProv)
            {
                //SourceExpr=decAmountCostDirect + decAmountCostDirectInd+ decAmountCostDirectProv;
            }
            Column(decAmountCostDirect; decAmountCostDirect)
            {
                //SourceExpr=decAmountCostDirect;
            }
            Column(decAmountCostDirectProv; decAmountCostDirectProv)
            {
                //SourceExpr=decAmountCostDirectProv;
            }
            Column(decAmountCostTotal; decAmountCostTotal)
            {
                //SourceExpr=decAmountCostTotal;
            }
            Column(decAmountCostTotalProv; decAmountCostTotalProv)
            {
                //SourceExpr=decAmountCostTotalProv;
            }
            Column(decAmountVta; decAmountVta)
            {
                //SourceExpr=decAmountVta;
            }
            Column(decAmountVtaProv; decAmountVtaProv)
            {
                //SourceExpr=decAmountVtaProv;
            }
            Column(decAmountCostDirectInd; decAmountCostDirectInd)
            {
                //SourceExpr=decAmountCostDirectInd;
            }
            Column(decAmountVta___decAmountVtaProv_Control1100099; decAmountVta + decAmountVtaProv)
            {
                //SourceExpr=decAmountVta + decAmountVtaProv;
            }
            Column(decAmountCostTotal___decAmountCostTotalProv_Control1100100; decAmountCostTotal + decAmountCostTotalProv)
            {
                //SourceExpr=decAmountCostTotal + decAmountCostTotalProv;
            }
            Column(decAmountCostDirect___decAmountCostDirectInd__decAmountCostDirectProv_Control1100101; decAmountCostDirect + decAmountCostDirectInd + decAmountCostDirectProv)
            {
                //SourceExpr=decAmountCostDirect + decAmountCostDirectInd+ decAmountCostDirectProv;
            }
            Column(TOTAL_PROJECTCaption; TOTAL_PROJECTCaptionLbl)
            {
                //SourceExpr=TOTAL_PROJECTCaptionLbl;
            }
            Column(TOTAL_COSTS_DIRECT_PROVISIONSCaption; TOTAL_COSTS_DIRECT_PROVISIONSCaptionLbl)
            {
                //SourceExpr=TOTAL_COSTS_DIRECT_PROVISIONSCaptionLbl;
            }
            Column(TOTAL_COSTS_DIRECTCaption; TOTAL_COSTS_DIRECTCaptionLbl)
            {
                //SourceExpr=TOTAL_COSTS_DIRECTCaptionLbl;
            }
            Column(TOTAL_COSTS_INDIRECTCaption; TOTAL_COSTS_INDIRECTCaptionLbl)
            {
                //SourceExpr=TOTAL_COSTS_INDIRECTCaptionLbl;
            }
            Column(TOTAL_PROJECTCaption_Control1100102; TOTAL_PROJECTCaption_Control1100102Lbl)
            {
                //SourceExpr=TOTAL_PROJECTCaption_Control1100102Lbl;
            }
            Column(SUMMARYCaption; SUMMARYCaptionLbl)
            {
                //SourceExpr=SUMMARYCaptionLbl;
            }
            Column(Job_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(COSTS_INDIRECTCaption; COSTS_INDIRECTCaptionLbl)
            {
                //SourceExpr=COSTS_INDIRECTCaptionLbl;
            }
            Column(TOTAL_COSTS_INDIRECTCaption_Control1100064; TOTAL_COSTS_INDIRECTCaption_Control1100064Lbl)
            {
                //SourceExpr=TOTAL_COSTS_INDIRECTCaption_Control1100064Lbl;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));
                RequestFilterHeadingML = ENU = 'Direct Costs', ESP = 'Costes directos';


                RequestFilterFields = "Piecework Code";
                DataItemLink = "Job No." = FIELD("No.");
                Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(Job__No___________Job_Description; Job."No." + ' ' + Job.Description + ' ' + Job."Description 2")
                {
                    //SourceExpr=Job."No." + ' ' + Job.Description + ' ' + Job."Description 2";
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(codeReassessment; codeReassessment)
                {
                    //SourceExpr=codeReassessment;
                }
                Column(TypeList; TypeList)
                {
                    //SourceExpr=TypeList;
                }
                Column(dateReport; dateReport)
                {
                    //SourceExpr=dateReport;
                }
                Column(Dates_unit__job_produc__Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Dates_unit__job_produc__Piecework_Code; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(decAmountVtaGreader; decAmountVtaGreader)
                {
                    //SourceExpr=decAmountVtaGreader;
                }
                Column(decAmountCostTotalGreader; decAmountCostTotalGreader)
                {
                    //SourceExpr=decAmountCostTotalGreader;
                }
                Column(decAmountCostDirectGreader; decAmountCostDirectGreader)
                {
                    //SourceExpr=decAmountCostDirectGreader;
                }
                Column(Dates_unit__job_produc__Piecework_Code__Control1100004; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(Dates_unit__job_produc__Unit_of_Measure_; "Unit Of Measure")
                {
                    //SourceExpr="Unit Of Measure";
                }
                Column(Dates_unit__job_produc__Description_Control1100015; Description)
                {
                    //SourceExpr=Description;
                }
                Column(decVolume; decVolume)
                {
                    //SourceExpr=decVolume;
                }
                Column(Dates_unit__job_produc__Unit_Price_Sale_; "Unit Price Sale (base)")
                {
                    //SourceExpr="Unit Price Sale (base)";
                }
                Column(decCostDirect; decCostDirect)
                {
                    //SourceExpr=decCostDirect;
                }
                Column(decCostTotal; decCostTotal)
                {
                    //SourceExpr=decCostTotal;
                }
                Column(decAmountCostDirect_Control1100025; decAmountCostDirect)
                {
                    //SourceExpr=decAmountCostDirect;
                }
                Column(decAmountVta_Control1100027; decAmountVta)
                {
                    //SourceExpr=decAmountVta;
                }
                Column(decAmountCostTotal_Control1100029; decAmountCostTotal)
                {
                    //SourceExpr=decAmountCostTotal;
                }
                Column(decAmountVta_Control1100033; decAmountVta)
                {
                    //SourceExpr=decAmountVta;
                }
                Column(decAmountCostTotal_Control1100034; decAmountCostTotal)
                {
                    //SourceExpr=decAmountCostTotal;
                }
                Column(decAmountCostDirect_Control1100035; decAmountCostDirect)
                {
                    //SourceExpr=decAmountCostDirect;
                }
                Column(decAmountVtaProv_Control1100081; decAmountVtaProv)
                {
                    //SourceExpr=decAmountVtaProv;
                }
                Column(decAmountCostTotalProv_Control1100082; decAmountCostTotalProv)
                {
                    //SourceExpr=decAmountCostTotalProv;
                }
                Column(decAmountCostDirectProv_Control1100083; decAmountCostDirectProv)
                {
                    //SourceExpr=decAmountCostDirectProv;
                }
                Column(Dates_unit__job_produc__Piecework_Code_Caption; Piecework_Code_CaptionLbl)
                {
                    //SourceExpr=Piecework_Code_CaptionLbl;
                }
                Column(Dates_unit__job_produc__Unit_of_Measure_Caption; Unit_Of_Measure_CaptionLbl)
                {
                    //SourceExpr=Unit_Of_Measure_CaptionLbl;
                }
                Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(CONSTRUCTION_MANAGEMENTCaption; CONSTRUCTION_MANAGEMENTCaptionLbl)
                {
                    //SourceExpr=CONSTRUCTION_MANAGEMENTCaptionLbl;
                }
                Column(Job__No___________Job_DescriptionCaption; Job__No___________Job_DescriptionCaptionLbl)
                {
                    //SourceExpr=Job__No___________Job_DescriptionCaptionLbl;
                }
                Column(Period_Master_Caption; Period_Master_CaptionLbl)
                {
                    //SourceExpr=Period_Master_CaptionLbl;
                }
                Column(Date_period_Caption; Date_period_CaptionLbl)
                {
                    //SourceExpr=Date_period_CaptionLbl;
                }
                Column(Operations_ProductionCaption; Operations_ProductionCaptionLbl)
                {
                    //SourceExpr=Operations_ProductionCaptionLbl;
                }
                Column(VolumeCaption; VolumeCaptionLbl)
                {
                    //SourceExpr=VolumeCaptionLbl;
                }
                Column(SalesCaption; SalesCaptionLbl)
                {
                    //SourceExpr=SalesCaptionLbl;
                }
                Column(Cost_DirectCaption; Cost_DirectCaptionLbl)
                {
                    //SourceExpr=Cost_DirectCaptionLbl;
                }
                Column(decCostTotalCaption; decCostTotalCaptionLbl)
                {
                    //SourceExpr=decCostTotalCaptionLbl;
                }
                Column(Cost_DirectCaption_Control1100026; Cost_DirectCaption_Control1100026Lbl)
                {
                    //SourceExpr=Cost_DirectCaption_Control1100026Lbl;
                }
                Column(Sales_TotalCaption; Sales_TotalCaptionLbl)
                {
                    //SourceExpr=Sales_TotalCaptionLbl;
                }
                Column(decAmountCostTotal_Control1100029Caption; decAmountCostTotal_Control1100029CaptionLbl)
                {
                    //SourceExpr=decAmountCostTotal_Control1100029CaptionLbl;
                }
                Column(PRICECaption; PRICECaptionLbl)
                {
                    //SourceExpr=PRICECaptionLbl;
                }
                Column(AMOUNTCaption; AMOUNTCaptionLbl)
                {
                    //SourceExpr=AMOUNTCaptionLbl;
                }
                Column(COSTS_DIRECTCaption; COSTS_DIRECTCaptionLbl)
                {
                    //SourceExpr=COSTS_DIRECTCaptionLbl;
                }
                Column(TOTAL_COSTS_DIRECTCaption_Control1100036; TOTAL_COSTS_DIRECTCaption_Control1100036Lbl)
                {
                    //SourceExpr=TOTAL_COSTS_DIRECTCaption_Control1100036Lbl;
                }
                Column(TOTAL_COSTS_DIRECT_PROVISIONSCaption_Control1100084; TOTAL_COSTS_DIRECT_PROVISIONSCaption_Control1100084Lbl)
                {
                    //SourceExpr=TOTAL_COSTS_DIRECT_PROVISIONSCaption_Control1100084Lbl;
                }
                Column(Dates_unit__job_produc__Code__project; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    codeReassessment := Job."Current Piecework Budget";

                    CurrReport.CREATETOTALS(decAmountCostTotal, decAmountCostDirect, decAmountVta);
                    CurrReport.CREATETOTALS(decAmountCostTotalProv, decAmountCostDirectProv, decAmountVtaProv);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                        "Data Piecework For Production".SETRANGE("Filter Date");
                        "Data Piecework For Production".SETRANGE("Budget Filter", codeReassessment);
                        "Data Piecework For Production".SETRANGE("Budget Filter", codeReassessment);
                        "Data Piecework For Production".CALCFIELDS("Aver. Cost Price Pend. Budget");
                        "Data Piecework For Production".CALCFIELDS("Data Piecework For Production"."Budget Measure",
                                                                   "Data Piecework For Production"."Amount Cost Budget (JC)");

                        "Data Piecework For Production".SETRANGE("Filter Date", 0D, dateReport);
                        "Data Piecework For Production".CALCFIELDS("Data Piecework For Production"."Total Measurement Production",
                                                                   "Data Piecework For Production"."Amount Cost Performed (JC)");

                        CASE OptType OF
                            OptType::Pending:
                                BEGIN
                                    IF "Data Piecework For Production"."Record Type" =
                                       "Data Piecework For Production"."Record Type"::Contract THEN BEGIN
                                        decVolume := "Data Piecework For Production"."Budget Measure" -
                                                     "Data Piecework For Production"."Total Measurement Production";
                                        decCostDirect := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                                        decCostTotal := decCostDirect * (1 + decCoefficientStep);
                                        decAmountCostDirect := ROUND(decVolume * decCostDirect, 0.01);
                                        decAmountCostTotal := ROUND(decAmountCostDirect * (1 + decCoefficientStep), 0.01);
                                        decAmountVta := ROUND(decVolume * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                    END ELSE BEGIN
                                        decVolumeProv := "Data Piecework For Production"."Budget Measure" -
                                                         "Data Piecework For Production"."Total Measurement Production";
                                        decCostDirectProv := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                                        decCostTotalProv := decCostDirectProv * (1 + decCoefficientStep);
                                        decAmountCostDirectProv := ROUND(decVolumeProv * decCostDirectProv, 0.01);
                                        decAmountCostTotalProv := ROUND(decAmountCostDirectProv * (1 + decCoefficientStep), 0.01);
                                        decAmountVtaProv := ROUND(decVolumeProv * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                    END;
                                END;
                            OptType::Executed:
                                BEGIN
                                    IF "Data Piecework For Production"."Record Type" =
                                       "Data Piecework For Production"."Record Type"::Contract THEN BEGIN
                                        decVolume := "Data Piecework For Production"."Total Measurement Production";
                                        IF decVolume <> 0 THEN
                                            decCostDirect := "Data Piecework For Production"."Amount Cost Performed (JC)" / decVolume
                                        ELSE
                                            decCostDirect := "Data Piecework For Production"."Amount Cost Performed (JC)";
                                        decCostTotal := decCostDirect * (1 + decCoefficientStep);
                                        decAmountCostDirect := ROUND("Data Piecework For Production"."Amount Cost Performed (JC)", 0.01);
                                        decAmountCostTotal := ROUND("Data Piecework For Production"."Amount Cost Performed (JC)" *
                                                                      (1 + decCoefficientStep), 0.01);
                                        decAmountVta := ROUND(decVolume * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                    END ELSE BEGIN
                                        decVolumeProv := "Data Piecework For Production"."Total Measurement Production";
                                        IF decVolumeProv <> 0 THEN
                                            decCostDirectProv := "Data Piecework For Production"."Amount Cost Performed (JC)" / decVolumeProv
                                        ELSE
                                            decCostDirectProv := "Data Piecework For Production"."Amount Cost Performed (JC)";
                                        decCostTotalProv := decCostDirectProv * (1 + decCoefficientStep);
                                        decAmountCostDirectProv := ROUND("Data Piecework For Production"."Amount Cost Performed (JC)", 0.01);
                                        decAmountCostTotalProv := ROUND("Data Piecework For Production"."Amount Cost Performed (JC)" *
                                                                      (1 + decCoefficientStep), 0.01);
                                        decAmountVtaProv := ROUND(decVolumeProv * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                    END;
                                END;
                            OptType::Total:
                                BEGIN
                                    IF "Data Piecework For Production"."Record Type" =
                                       "Data Piecework For Production"."Record Type"::Contract THEN BEGIN
                                        decVolume := "Data Piecework For Production"."Budget Measure";
                                        IF decVolume <> 0 THEN
                                            decCostDirect := "Data Piecework For Production"."Amount Cost Budget (JC)" / decVolume
                                        ELSE
                                            decCostDirect := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                                        decCostTotal := decCostDirect * (1 + decCoefficientStep);
                                        decAmountCostDirect := "Data Piecework For Production"."Amount Cost Budget (JC)";
                                        decAmountCostTotal := ROUND(decAmountCostDirect * (1 + decCoefficientStep), 0.01);
                                        decAmountVta := ROUND(decVolume * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                    END ELSE BEGIN
                                        decVolumeProv := "Data Piecework For Production"."Budget Measure";
                                        IF decVolumeProv <> 0 THEN
                                            decCostDirectProv := "Data Piecework For Production"."Amount Cost Budget (JC)" / decVolumeProv
                                        ELSE
                                            decCostDirectProv := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                                        decCostTotalProv := decCostDirectProv * (1 + decCoefficientStep);
                                        decAmountCostDirectProv := "Data Piecework For Production"."Amount Cost Budget (JC)";
                                        decAmountCostTotalProv := ROUND(decAmountCostDirectProv * (1 + decCoefficientStep), 0.01);
                                        decAmountVtaProv := ROUND(decVolumeProv * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                    END;
                                END;
                        END;
                    END ELSE BEGIN
                        decAmountCostTotalGreader := 0;
                        decAmountCostDirectGreader := 0;
                        decAmountVtaGreader := 0;
                        "Data Piecework For Production".SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
                        "Data Piecework For Production".SETFILTER("Piecework Code", "Data Piecework For Production".Totaling);
                        "Data Piecework For Production".SETRANGE("Account Type", "Data Piecework For Production"."Account Type"::Unit);
                        IF "Data Piecework For Production".FINDSET THEN
                            REPEAT
                                "Data Piecework For Production".SETRANGE("Filter Date");
                                "Data Piecework For Production".SETRANGE("Budget Filter", codeReassessment);
                                "Data Piecework For Production".CALCFIELDS("Aver. Cost Price Pend. Budget");
                                "Data Piecework For Production".SETRANGE("Budget Filter", '', codeReassessment);
                                "Data Piecework For Production".CALCFIELDS("Data Piecework For Production"."Budget Measure",
                                                                           "Data Piecework For Production"."Amount Cost Budget (JC)");

                                "Data Piecework For Production".SETRANGE("Filter Date", 0D, dateReport);
                                "Data Piecework For Production".CALCFIELDS("Data Piecework For Production"."Total Measurement Production",
                                                                       "Data Piecework For Production"."Amount Cost Performed (JC)");

                                CASE OptType OF
                                    OptType::Pending:
                                        BEGIN
                                            IF "Data Piecework For Production"."Record Type" = "Data Piecework For Production"."Record Type"::Contract THEN BEGIN
                                                decVolumeGreader := "Data Piecework For Production"."Budget Measure" -
                                                              "Data Piecework For Production"."Total Measurement Production";
                                                decCostDirectGreader := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                                                decCostTotalGreader := decCostDirectGreader * (1 + decCoefficientStep);
                                                decAmountCostDirectGreader := decAmountCostDirectGreader + ROUND(decVolumeGreader * decCostDirectGreader, 0.01);
                                                decAmountCostTotalGreader := ROUND(decAmountCostDirectGreader * (1 + decCoefficientStep), 0.01);
                                                decAmountVtaGreader := decAmountVtaGreader + ROUND(decVolumeGreader * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                            END;
                                        END;
                                    OptType::Executed:
                                        BEGIN
                                            IF "Data Piecework For Production"."Record Type" = "Data Piecework For Production"."Record Type"::Contract THEN BEGIN
                                                decVolumeGreader := "Data Piecework For Production"."Total Measurement Production";
                                                IF decVolumeGreader <> 0 THEN
                                                    decCostDirectGreader := "Data Piecework For Production"."Amount Cost Performed (JC)" / decVolumeGreader
                                                ELSE
                                                    decCostDirectGreader := "Data Piecework For Production"."Amount Cost Performed (JC)";
                                                decCostTotalGreader := decCostDirectGreader * (1 + decCoefficientStep);
                                                decAmountCostDirectGreader := decAmountCostDirectGreader + ROUND("Data Piecework For Production"."Amount Cost Performed (JC)", 0.01)
                                    ;
                                                decAmountCostTotalGreader := decAmountCostTotalGreader + ROUND("Data Piecework For Production"."Amount Cost Performed (JC)" *
                                                                             (1 + decCoefficientStep), 0.01);
                                                decAmountVtaGreader := decAmountVtaGreader + ROUND(decVolumeGreader * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                            END;
                                        END;
                                    OptType::Total:
                                        BEGIN
                                            IF "Data Piecework For Production"."Record Type" = "Data Piecework For Production"."Record Type"::Contract THEN BEGIN

                                                decVolumeGreader := "Data Piecework For Production"."Budget Measure";
                                                IF decVolumeGreader <> 0 THEN
                                                    decCostDirectGreader := "Data Piecework For Production"."Amount Cost Budget (JC)" / decVolumeGreader
                                                ELSE
                                                    decCostDirectGreader := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                                                decCostTotalGreader := decCostDirectGreader * (1 + decCoefficientStep);
                                                decAmountCostDirectGreader := decAmountCostDirectGreader + "Data Piecework For Production"."Amount Cost Budget (JC)";
                                                decAmountCostTotalGreader := decAmountCostTotalGreader +
                                                                             ROUND("Data Piecework For Production"."Amount Cost Budget (JC)" * (1 + decCoefficientStep), 0.01);
                                                decAmountVtaGreader := decAmountVtaGreader + ROUND(decVolumeGreader * "Data Piecework For Production"."Unit Price Sale (base)", 0.01);
                                            END;
                                        END;
                                END;
                            UNTIL "Data Piecework For Production".NEXT = 0;
                    END;
                END;

            }
            DataItem("2000000026"; "2000000026")
            {

                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                ;
                //D2 Triggers
                trigger OnAfterGetRecord();
                BEGIN
                    CurrReport.NEWPAGE;
                END;

            }
            DataItem("CostsIndirect"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Cost Unit"));
                RequestFilterHeadingML = ENU = 'Direct Costs', ESP = 'Costes directos';


                RequestFilterFields = "Piecework Code";
                DataItemLink = "Job No." = FIELD("No.");
                Column(FORMAT_TODAY_0_4__Control1100068; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(CurrReport_PAGENO_Control1100069; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(TypeList_Control1100072; TypeList)
                {
                    //SourceExpr=TypeList;
                }
                Column(Job__No___________Job_Description_Control1100073; Job."No." + ' ' + Job.Description)
                {
                    //SourceExpr=Job."No." + ' ' + Job.Description;
                }
                Column(COMPANYNAME_Control1100074; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(USERID_Control1100076; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(dateReport_Control1100077; dateReport)
                {
                    //SourceExpr=dateReport;
                }
                Column(codeReassessment_Control1100079; codeReassessment)
                {
                    //SourceExpr=codeReassessment;
                }
                Column(CostsIndirects_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(CostsIndirects__Piecework_Code_; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(decAmountCostDirectIndGreader; decAmountCostDirectIndGreader)
                {
                    //SourceExpr=decAmountCostDirectIndGreader;
                }
                Column(decAmountCostDirectInd_Control1100056; decAmountCostDirectInd)
                {
                    //SourceExpr=decAmountCostDirectInd;
                }
                Column(decCostDirectInd; decCostDirectInd)
                {
                    //SourceExpr=decCostDirectInd;
                }
                Column(decVolumeInd; decVolumeInd)
                {
                    //SourceExpr=decVolumeInd;
                }
                Column(CostsIndirects_Description_Control1100061; Description)
                {
                    //SourceExpr=Description;
                }
                Column(CostsIndirects__Unit_of_Meauser_; "Unit Of Measure")
                {
                    //SourceExpr="Unit Of Measure";
                }
                Column(CostsIndirects__Piecework_Code__Control1100063; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(decAmountCostDirectInd_Control1100058; decAmountCostDirectInd)
                {
                    //SourceExpr=decAmountCostDirectInd;
                }
                Column(CurrReport_PAGENO_Control1100069Caption; CurrReport_PAGENO_Control1100069CaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENO_Control1100069CaptionLbl;
                }
                Column(CONSTRUCTION_MANAGEMENTCaption_Control1100071; CONSTRUCTION_MANAGEMENTCaption_Control1100071Lbl)
                {
                    //SourceExpr=CONSTRUCTION_MANAGEMENTCaption_Control1100071Lbl;
                }
                Column(Job__No___________Job_Description_Control1100073Caption; Job__No___________Job_Description_Control1100073CaptionLbl)
                {
                    //SourceExpr=Job__No___________Job_Description_Control1100073CaptionLbl;
                }
                Column(Date_period_Caption_Control1100078; Date_period_Caption_Control1100078Lbl)
                {
                    //SourceExpr=Date_period_Caption_Control1100078Lbl;
                }
                Column(Period_Master_Caption_Control1100080; Period_Master_Caption_Control1100080Lbl)
                {
                    //SourceExpr=Period_Master_Caption_Control1100080Lbl;
                }
                Column(AMOUNTCaption_Control1100039; AMOUNTCaption_Control1100039Lbl)
                {
                    //SourceExpr=AMOUNTCaption_Control1100039Lbl;
                }
                Column(PRICECaption_Control1100042; PRICECaption_Control1100042Lbl)
                {
                    //SourceExpr=PRICECaption_Control1100042Lbl;
                }
                Column(SalesCaption_Control1100043; SalesCaption_Control1100043Lbl)
                {
                    //SourceExpr=SalesCaption_Control1100043Lbl;
                }
                Column(Cost_DirectCaption_Control1100044; Cost_DirectCaption_Control1100044Lbl)
                {
                    //SourceExpr=Cost_DirectCaption_Control1100044Lbl;
                }
                Column(Cost_TotalCaption; Cost_TotalCaptionLbl)
                {
                    //SourceExpr=Cost_TotalCaptionLbl;
                }
                Column(Cost_DirectCaption_Control1100046; Cost_DirectCaption_Control1100046Lbl)
                {
                    //SourceExpr=Cost_DirectCaption_Control1100046Lbl;
                }
                Column(Sales_TotalCaption_Control1100047; Sales_TotalCaption_Control1100047Lbl)
                {
                    //SourceExpr=Sales_TotalCaption_Control1100047Lbl;
                }
                Column(Cost_TotalCaption_Control1100048; Cost_TotalCaption_Control1100048Lbl)
                {
                    //SourceExpr=Cost_TotalCaption_Control1100048Lbl;
                }
                Column(VolumeCaption_Control1100049; VolumeCaption_Control1100049Lbl)
                {
                    //SourceExpr=VolumeCaption_Control1100049Lbl;
                }
                Column(Operations_ProductionCaption_Control1100051; Operations_ProductionCaption_Control1100051Lbl)
                {
                    //SourceExpr=Operations_ProductionCaption_Control1100051Lbl;
                }
                Column(CostsIndirect_Code__project; "Job No.")
                {
                    //SourceExpr="Job No." ;
                }
                //D3 Triggers
                trigger OnPreDataItem();
                BEGIN
                    CostsIndirect.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                    codeReassessment := Job."Current Piecework Budget";

                    CurrReport.CREATETOTALS(decAmountCostDirectInd);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF CostsIndirect."Account Type" = CostsIndirect."Account Type"::Unit THEN BEGIN
                        CostsIndirect.SETRANGE("Filter Date");
                        CostsIndirect.SETRANGE("Budget Filter", codeReassessment);
                        CostsIndirect.CALCFIELDS("Aver. Cost Price Pend. Budget");
                        CostsIndirect.SETRANGE("Budget Filter", '', codeReassessment);
                        CostsIndirect.CALCFIELDS(CostsIndirect."Budget Measure",
                                                                   CostsIndirect."Amount Cost Budget (JC)");

                        CostsIndirect.SETRANGE("Filter Date", 0D, dateReport);
                        CostsIndirect.CALCFIELDS(CostsIndirect."Total Measurement Production",
                                                                   CostsIndirect."Amount Cost Performed (JC)");

                        CASE OptType OF
                            OptType::Pending:
                                BEGIN
                                    decVolumeInd := CostsIndirect."Budget Measure" - CostsIndirect."Total Measurement Production";
                                    decCostDirectInd := CostsIndirect."Aver. Cost Price Pend. Budget";
                                    decAmountCostDirectInd := ROUND(decVolumeInd * decCostDirectInd, 0.01);
                                END;
                            OptType::Executed:
                                BEGIN
                                    decVolumeInd := CostsIndirect."Total Measurement Production";
                                    IF decVolumeInd <> 0 THEN
                                        decCostDirectInd := CostsIndirect."Amount Cost Performed (JC)" / decVolumeInd
                                    ELSE
                                        decCostDirectInd := CostsIndirect."Amount Cost Performed (JC)";
                                    decAmountCostDirectInd := ROUND(CostsIndirect."Amount Cost Performed (JC)", 0.01);
                                END;
                            OptType::Total:
                                BEGIN
                                    decVolumeInd := CostsIndirect."Budget Measure";
                                    IF decVolumeInd <> 0 THEN
                                        decCostDirectInd := CostsIndirect."Amount Cost Budget (JC)" / decVolumeInd
                                    ELSE
                                        decCostDirectInd := CostsIndirect."Aver. Cost Price Pend. Budget";
                                    decAmountCostDirectInd := CostsIndirect."Amount Cost Budget (JC)";
                                END;
                        END;
                    END ELSE BEGIN
                        decAmountCostDirectIndGreader := 0;
                        decAmountVtaIndGreader := 0;
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", CostsIndirect."Job No.");
                        DataPieceworkForProduction.SETFILTER("Piecework Code", CostsIndirect.Totaling);
                        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                        IF DataPieceworkForProduction.FINDSET THEN
                            REPEAT
                                DataPieceworkForProduction.SETRANGE("Filter Date");
                                DataPieceworkForProduction.SETRANGE("Budget Filter", codeReassessment);
                                DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                                DataPieceworkForProduction.SETRANGE("Budget Filter", '', codeReassessment);
                                DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Budget Measure",
                                                                           DataPieceworkForProduction."Amount Cost Budget (JC)");
                                DataPieceworkForProduction.SETRANGE("Filter Date", 0D, dateReport);
                                DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Total Measurement Production",
                                                               DataPieceworkForProduction."Amount Cost Performed (JC)");
                                CASE OptType OF
                                    OptType::Pending:
                                        BEGIN
                                            decVolumeIndGreader := DataPieceworkForProduction."Budget Measure" - DataPieceworkForProduction."Total Measurement Production";
                                            decCostDirectIndGreader := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                                            decAmountCostDirectIndGreader := decAmountCostDirectIndGreader +
                                                                              ROUND(decVolumeIndGreader * decCostDirectIndGreader, 0.01);
                                        END;
                                    OptType::Executed:
                                        BEGIN
                                            decVolumeIndGreader := DataPieceworkForProduction."Total Measurement Production";
                                            IF decVolumeIndGreader <> 0 THEN
                                                decCostDirectIndGreader := DataPieceworkForProduction."Amount Cost Performed (JC)" / decVolumeIndGreader
                                            ELSE
                                                decCostDirectIndGreader := DataPieceworkForProduction."Amount Cost Performed (JC)";
                                            decAmountCostDirectIndGreader := decAmountCostDirectIndGreader +
                                                                              ROUND(DataPieceworkForProduction."Amount Cost Performed (JC)", 0.01);
                                        END;
                                    OptType::Total:
                                        BEGIN
                                            decVolumeIndGreader := DataPieceworkForProduction."Budget Measure";
                                            IF decVolumeIndGreader <> 0 THEN
                                                decCostDirectIndGreader := DataPieceworkForProduction."Amount Cost Budget (JC)" / decVolumeIndGreader
                                            ELSE
                                                decCostDirectIndGreader := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                                            decAmountCostDirectIndGreader := decAmountCostDirectIndGreader + DataPieceworkForProduction."Amount Cost Budget (JC)";
                                        END;
                                END;
                            UNTIL DataPieceworkForProduction.NEXT = 0;
                    END;
                END;


            }
            //Job1 Triggers
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);

                LastFieldNo := FIELDNO("No.");
                OptType := OptType::Pending;
                CASE OptType OF
                    OptType::Pending:
                        TypeList := Budgets_and_his_Updates_Pending;
                    OptType::Executed:
                        TypeList := Budgets_and_his_Updates_Executed;
                    OptType::Total:
                        TypeList := Budgets_and_his_Updates_Total;
                END;
            END;

            trigger OnAfterGetRecord();
            BEGIN

                codeReassessment := Job."Current Piecework Budget";
                Job.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                CASE OptType OF
                    OptType::Pending:
                        Job.SETRANGE("Performed Filter", FALSE);
                    OptType::Executed:
                        Job.SETRANGE("Performed Filter", TRUE);
                    OptType::Total:
                        Job.SETRANGE("Performed Filter");
                END;
                Job.CALCFIELDS(Job."Direct Cost Amount PieceWork", Job."Indirect Cost Amount Piecework");
                decPptoCostTotal := Job."Direct Cost Amount PieceWork";
                IF decPptoCostTotal <> 0 THEN
                    decCoefficientStep := Job."Indirect Cost Amount Piecework" / decPptoCostTotal;
            END;


        }
    }
    requestpage
    {
        CaptionML = ENU = 'Budgets and his Updates', ESP = 'Ppto y sus actualizaciones';
        layout
        {
        }
    }
    labels
    {
        Pagina = 'Page/ P gina/';
        Gestion_Obras = 'CONSTRUCTION MANAGEMENT/ GESTIàN DE OBRAS/';
        Ppto_and_Updates = 'BUDGEST AND ITS UPDATES (PENDING)/ PRESUPUESTO Y SUS ACTUALIZACIONES (PENDIENTES)/';
        Obra = 'JOB/ OBRA/';
    }

    var
        //       LastFieldNo@1100000 :
        LastFieldNo: Integer;
        //       FooterPrinted@1100001 :
        FooterPrinted: Boolean;
        //       decPptoCostTotal@1100005 :
        decPptoCostTotal: Decimal;
        //       decCostTotal@1100002 :
        decCostTotal: Decimal;
        //       decAmountCostTotal@1100003 :
        decAmountCostTotal: Decimal;
        //       codeReestimaci¢n@1100004 :
        codeReestimacion: Code[20];
        //       decCoefficientStep@1100006 :
        decCoefficientStep: Decimal;
        //       dateReport@1100007 :
        dateReport: Date;
        //       FunctionQB@1100008 :
        FunctionQB: Codeunit 7207272;
        //       DimensionValue@1100009 :
        DimensionValue: Record 349;
        //       OptType@1100010 :
        OptType: Option "Pending","Executed","Total";
        //       decVolume@1100011 :
        decVolume: Decimal;
        //       decCostDirect@1100012 :
        decCostDirect: Decimal;
        //       decAmountCostDirect@1100013 :
        decAmountCostDirect: Decimal;
        //       decAmountVta@1100014 :
        decAmountVta: Decimal;
        //       TypeList@1100015 :
        TypeList: Text[50];
        //       decCostDirectInd@1100020 :
        decCostDirectInd: Decimal;
        //       decAmountCostDirectInd@1100019 :
        decAmountCostDirectInd: Decimal;
        //       decAmountVtaInd@1100018 :
        decAmountVtaInd: Decimal;
        //       decVolumeInd@1100021 :
        decVolumeInd: Decimal;
        //       decCostTotalProv@1100017 :
        decCostTotalProv: Decimal;
        //       decAmountCostTotalProv@1100016 :
        decAmountCostTotalProv: Decimal;
        //       decVolumeProv@1100025 :
        decVolumeProv: Decimal;
        //       decCostDirectProv@1100024 :
        decCostDirectProv: Decimal;
        //       decAmountCostDirectProv@1100023 :
        decAmountCostDirectProv: Decimal;
        //       decAmountVtaProv@1100022 :
        decAmountVtaProv: Decimal;
        //       decCostTotalGreader@1100027 :
        decCostTotalGreader: Decimal;
        //       decAmountCostTotalGreader@1100026 :
        decAmountCostTotalGreader: Decimal;
        //       decVolumeGreader@1100031 :
        decVolumeGreader: Decimal;
        //       decCostDirectGreader@1100030 :
        decCostDirectGreader: Decimal;
        //       decAmountCostDirectGreader@1100029 :
        decAmountCostDirectGreader: Decimal;
        //       decAmountVtaGreader@1100028 :
        decAmountVtaGreader: Decimal;
        //       DataPieceworkForProduction@1100032 :
        DataPieceworkForProduction: Record 7207386;
        //       decCostDirectIndGreader@1100036 :
        decCostDirectIndGreader: Decimal;
        //       decAmountCostDirectIndGreader@1100035 :
        decAmountCostDirectIndGreader: Decimal;
        //       decAmountVtaIndGreader@1100034 :
        decAmountVtaIndGreader: Decimal;
        //       decVolumeIndGreader@1100033 :
        decVolumeIndGreader: Decimal;
        //       codeReassessment@1100037 :
        codeReassessment: Code[20];
        //       TOTAL_PROJECTCaptionLbl@1103911 :
        TOTAL_PROJECTCaptionLbl: TextConst ENU = '<TOTAL PROJECT>', ESP = 'TOTAL PROYECTO';
        //       TOTAL_COSTS_DIRECT_PROVISIONSCaptionLbl@1104569 :
        TOTAL_COSTS_DIRECT_PROVISIONSCaptionLbl: TextConst ENU = '<TOTAL DIRECT COST PROVISIONS>', ESP = 'TOTAL COSTES DIRECTOS PROVISIONES';
        //       TOTAL_COSTS_DIRECTCaptionLbl@1108382 :
        TOTAL_COSTS_DIRECTCaptionLbl: TextConst ENU = '<TOTAL DIRECT COST>', ESP = 'TOTAL COSTES DIRECTOS';
        //       TOTAL_COSTS_INDIRECTCaptionLbl@1106355 :
        TOTAL_COSTS_INDIRECTCaptionLbl: TextConst ENU = '<TOTAL INDIRECT COSTS>', ESP = 'TOTAL COSTES INDIRECTOS';
        //       TOTAL_PROJECTCaption_Control1100102Lbl@1104383 :
        TOTAL_PROJECTCaption_Control1100102Lbl: TextConst ENU = '<TOTAL PROJECT>', ESP = 'TOTAL PROYECTO';
        //       SUMMARYCaptionLbl@1102072 :
        SUMMARYCaptionLbl: TextConst ENU = '<SUMMARY>', ESP = 'RESUMEN';
        //       CurrReport_PAGENOCaptionLbl@1103005 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = '<Page>', ESP = 'P gina';
        //       CONSTRUCTION_MANAGEMENTCaptionLbl@1100659 :
        CONSTRUCTION_MANAGEMENTCaptionLbl: TextConst ENU = '<CONSTRUCTION MANAGEMENT>', ESP = 'GESTIàN DE OBRAS';
        //       Job__No___________Job_DescriptionCaptionLbl@1105534 :
        Job__No___________Job_DescriptionCaptionLbl: TextConst ENU = '<JOB:>', ESP = 'OBRA:';
        //       Period_Master_CaptionLbl@1109594 :
        Period_Master_CaptionLbl: TextConst ENU = '<Period Master:>', ESP = 'Periodo Master:';
        //       Date_period_CaptionLbl@1102695 :
        Date_period_CaptionLbl: TextConst ENU = '<Date period:>', ESP = 'Fecha periodo:';
        //       Operations_ProductionCaptionLbl@1105102 :
        Operations_ProductionCaptionLbl: TextConst ENU = '<Operations of production>', ESP = 'Operaciones de producci¢n';
        //       VolumeCaptionLbl@1103868 :
        VolumeCaptionLbl: TextConst ENU = '<Volume>', ESP = 'Volumen';
        //       SalesCaptionLbl@1101855 :
        SalesCaptionLbl: TextConst ENU = '<Sales>', ESP = 'Ventas';
        //       Cost_DirectCaptionLbl@1106777 :
        Cost_DirectCaptionLbl: TextConst ENU = '<Direct Cost>', ESP = 'Coste Directo';
        //       decCostTotalCaptionLbl@1107356 :
        decCostTotalCaptionLbl: TextConst ENU = '<Total Cost>', ESP = 'Total Coste';
        //       Cost_DirectCaption_Control1100026Lbl@1109002 :
        Cost_DirectCaption_Control1100026Lbl: TextConst ENU = '<Direct Cost>', ESP = 'Coste Directo';
        //       Sales_TotalCaptionLbl@1109958 :
        Sales_TotalCaptionLbl: TextConst ENU = '<Total Sales>', ESP = 'Total Ventas';
        //       decAmountCostTotal_Control1100029CaptionLbl@1101620 :
        decAmountCostTotal_Control1100029CaptionLbl: TextConst ENU = '<Total Cost>', ESP = 'Total Coste';
        //       PRICECaptionLbl@1102354 :
        PRICECaptionLbl: TextConst ENU = '<PRICE>', ESP = 'PRECIOS';
        //       AMOUNTCaptionLbl@1103008 :
        AMOUNTCaptionLbl: TextConst ENU = '<AMOUNTS>', ESP = 'IMPORTES';
        //       COSTS_DIRECTCaptionLbl@1106459 :
        COSTS_DIRECTCaptionLbl: TextConst ENU = '<DIRECT COSTS>', ESP = 'COSTES DIRECTOS';
        //       TOTAL_COSTS_DIRECTCaption_Control1100036Lbl@1106301 :
        TOTAL_COSTS_DIRECTCaption_Control1100036Lbl: TextConst ENU = '<TOTAL DIRECT COSTS>', ESP = 'TOTAL COSTES DIRECTOS';
        //       TOTAL_COSTS_DIRECT_PROVISIONSCaption_Control1100084Lbl@1101111 :
        TOTAL_COSTS_DIRECT_PROVISIONSCaption_Control1100084Lbl: TextConst ENU = '<TOTAL DIRECT COSTS PROVISIONS>', ESP = 'TOTAL COSTES DIRECTOS PROVISIONES';
        //       CurrReport_PAGENO_Control1100069CaptionLbl@1104190 :
        CurrReport_PAGENO_Control1100069CaptionLbl: TextConst ENU = '<Page>', ESP = 'P gina';
        //       CONSTRUCTION_MANAGEMENTCaption_Control1100071Lbl@1104777 :
        CONSTRUCTION_MANAGEMENTCaption_Control1100071Lbl: TextConst ENU = '<CONSTRUCTION MANAGEMENT>', ESP = 'GESTIàN DE OBRAS';
        //       Job__No___________Job_Description_Control1100073CaptionLbl@1107243 :
        Job__No___________Job_Description_Control1100073CaptionLbl: TextConst ENU = '<JOB:>', ESP = 'OBRA:';
        //       Date_period_Caption_Control1100078Lbl@1102632 :
        Date_period_Caption_Control1100078Lbl: TextConst ENU = '<Date period:>', ESP = 'Fecha periodo:';
        //       Period_Master_Caption_Control1100080Lbl@1105390 :
        Period_Master_Caption_Control1100080Lbl: TextConst ENU = '<Master Period:>', ESP = 'Periodo Master:';
        //       AMOUNTCaption_Control1100039Lbl@1105600 :
        AMOUNTCaption_Control1100039Lbl: TextConst ENU = '<AMOUNTS>', ESP = 'IMPORTES';
        //       PRICECaption_Control1100042Lbl@1107822 :
        PRICECaption_Control1100042Lbl: TextConst ENU = '<PRICE>', ESP = 'PRECIOS';
        //       SalesCaption_Control1100043Lbl@1105823 :
        SalesCaption_Control1100043Lbl: TextConst ENU = '<Sales>', ESP = 'Ventas';
        //       Cost_DirectCaption_Control1100044Lbl@1103047 :
        Cost_DirectCaption_Control1100044Lbl: TextConst ENU = '<Direct Cost>', ESP = 'Coste Directo';
        //       Cost_TotalCaptionLbl@1108660 :
        Cost_TotalCaptionLbl: TextConst ENU = '<Total Cost>', ESP = 'Total Coste';
        //       Cost_DirectCaption_Control1100046Lbl@1101529 :
        Cost_DirectCaption_Control1100046Lbl: TextConst ENU = '<Direct Cost>', ESP = 'Coste Directo';
        //       Sales_TotalCaption_Control1100047Lbl@1102817 :
        Sales_TotalCaption_Control1100047Lbl: TextConst ENU = '<Total Sales>', ESP = 'Total Ventas';
        //       Cost_TotalCaption_Control1100048Lbl@1104758 :
        Cost_TotalCaption_Control1100048Lbl: TextConst ENU = '<Total Cost>', ESP = 'Total Cost';
        //       VolumeCaption_Control1100049Lbl@1108045 :
        VolumeCaption_Control1100049Lbl: TextConst ENU = '<Volume>', ESP = 'Volujment';
        //       COSTS_INDIRECTCaptionLbl@1100443 :
        COSTS_INDIRECTCaptionLbl: TextConst ENU = '<INDIRECT COSTS>', ESP = 'COSTES INDIRECTOS';
        //       Operations_ProductionCaption_Control1100051Lbl@1100472 :
        Operations_ProductionCaption_Control1100051Lbl: TextConst ENU = '<Operations of production>', ESP = 'Operaciones de producci¢n';
        //       TOTAL_COSTS_INDIRECTCaption_Control1100064Lbl@1102768 :
        TOTAL_COSTS_INDIRECTCaption_Control1100064Lbl: TextConst ENU = '<TOTAL INDIRECT COSTS>', ESP = 'TOTAL COSTES INDIRECTOS';
        //       Budgets_and_his_Updates_Pending@7001100 :
        Budgets_and_his_Updates_Pending: TextConst ENU = 'Budgets and his Updates (Pending)', ESP = 'Ppto  y sus Actualizaciones (Pendientes)';
        //       Budgets_and_his_Updates_Executed@7001101 :
        Budgets_and_his_Updates_Executed: TextConst ENU = 'Budgets and his Updates (Executed)', ESP = 'Ppto y sus Actualizaciones (Ejecutado)';
        //       Budgets_and_his_Updates_Total@7001102 :
        Budgets_and_his_Updates_Total: TextConst ENU = 'Budgets and his Updates (Total)', ESP = 'Ppto y sus Actualizaciones (Total)';
        //       CompanyInformation@7001103 :
        CompanyInformation: Record 79;
        //       Piecework_Code_CaptionLbl@7001104 :
        Piecework_Code_CaptionLbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       Unit_Of_Measure_CaptionLbl@7001105 :
        Unit_Of_Measure_CaptionLbl: TextConst ENU = 'U. Mea.', ESP = 'U. Med.';

    /*begin
    end.
  */

}



// RequestFilterFields="Piecework Code";

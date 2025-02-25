report 7207387 "Monthly Job Summary"
{


    CaptionML = ENU = 'Monthly Job Summary', ESP = 'Resumen mensual de obra';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.")
                                 WHERE("Status" = FILTER("Open" | "Completed"));


            RequestFilterFields = "No.", "Posting Date Filter", "Budget Filter";
            Column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
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
            Column(PICTURE; CompanyInformation1.Picture)
            {
                //SourceExpr=CompanyInformation1.Picture;
            }
            Column(txtTypePlanned; txtTypePlanned)
            {
                //SourceExpr=txtTypePlanned;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(JOBNo; "No.")
            {
                //SourceExpr="No.";
            }
            Column(Description12; Description + "Description 2")
            {
                //SourceExpr=Description+"Description 2";
            }
            Column(IntAge; IntAge)
            {
                //SourceExpr=IntAge;
            }
            Column(IntMonth; IntMonth)
            {
                //SourceExpr=IntMonth;
            }
            Column(IntMonth_Control1100251335; IntMonth)
            {
                //SourceExpr=IntMonth;
            }
            Column(IntAge_Control1100251339; IntAge)
            {
                //SourceExpr=IntAge;
            }
            Column(decProductionNormalRealMonth; decProductionNormalRealMonth)
            {
                //SourceExpr=decProductionNormalRealMonth;
            }
            Column(decProductionNormalPlannedMonth; decProductionNormalPlannedMonth)
            {
                //SourceExpr=decProductionNormalPlannedMonth;
            }
            Column(decProductionNormalRealOrigin; decProductionNormalRealOrigin)
            {
                //SourceExpr=decProductionNormalRealOrigin;
            }
            Column(decProductioNormalPlannedOrigin; decProductioNormalPlannedOrigin)
            {
                //SourceExpr=decProductioNormalPlannedOrigin;
            }
            Column(decCDMonth; decCDMonth)
            {
                //SourceExpr=decCDMonth;
            }
            Column(decCDPlannedMonth; decCDPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth;
            }
            Column(decCDOrigin; decCDOrigin)
            {
                //SourceExpr=decCDOrigin;
            }
            Column(decCDPlannedOrigin; decCDPlannedOrigin)
            {
                //SourceExpr=decCDPlannedOrigin;
            }
            Column(decCDAGE; decCDAGE)
            {
                //SourceExpr=decCDAGE;
            }
            Column(decCDPlannedAGE; decCDPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE;
            }
            Column(decAAPlannedOrigin; decAAPlannedOrigin)
            {
                //SourceExpr=decAAPlannedOrigin;
            }
            Column(decAAMonth; decAAMonth)
            {
                //SourceExpr=decAAMonth;
            }
            Column(decAAPlannedMonth; decAAPlannedMonth)
            {
                //SourceExpr=decAAPlannedMonth;
            }
            Column(decAAOrigin; decAAOrigin)
            {
                //SourceExpr=decAAOrigin;
            }
            Column(decGCPlannedOrigin; decGCPlannedOrigin)
            {
                //SourceExpr=decGCPlannedOrigin;
            }
            Column(decGCMONTH; decGCMONTH)
            {
                //SourceExpr=decGCMONTH;
            }
            Column(decGCPlannedMONTH; decGCPlannedMONTH)
            {
                //SourceExpr=decGCPlannedMONTH;
            }
            Column(decGCOrigin; decGCOrigin)
            {
                //SourceExpr=decGCOrigin;
            }
            Column(decAIPlannedOrigin; decAIPlannedOrigin)
            {
                //SourceExpr=decAIPlannedOrigin;
            }
            Column(decAIMonth; decAIMonth)
            {
                //SourceExpr=decAIMonth;
            }
            Column(decAIPlannedMonth; decAIPlannedMonth)
            {
                //SourceExpr=decAIPlannedMonth;
            }
            Column(decAIOrigin; decAIOrigin)
            {
                //SourceExpr=decAIOrigin;
            }
            Column(decADPlannedOrigin; decADPlannedOrigin)
            {
                //SourceExpr=decADPlannedOrigin;
            }
            Column(decADMonth; decADMonth)
            {
                //SourceExpr=decADMonth;
            }
            Column(decADPlannedMonth; decADPlannedMonth)
            {
                //SourceExpr=decADPlannedMonth;
            }
            Column(decADOrigin; decADOrigin)
            {
                //SourceExpr=decADOrigin;
            }
            Column(decAAPlannedOrigin_decGCPlannedOrigin_decAIPlannedOrigin_decADPlannedOrigin; decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin)
            {
                //SourceExpr=decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin;
            }
            Column(decAAMonth_decGCMonth_decAIMonth_decADMonth; decAAMonth + decGCMONTH + decAIMonth + decADMonth)
            {
                //SourceExpr=decAAMonth + decGCMONTH + decAIMonth + decADMonth;
            }
            Column(decAAPlannedMonth_decGCPlannedMonth_decAIPlannedMonth_decADPlannedMonth; decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth)
            {
                //SourceExpr=decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth;
            }
            Column(decAAOrigin_decGCOrigin_decAIOrigin_decADOrigin; decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin)
            {
                //SourceExpr=decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin;
            }
            Column(decCFPlannedOrigin; decCFPlannedOrigin)
            {
                //SourceExpr=decCFPlannedOrigin;
            }
            Column(decCFMonth; decCFMonth)
            {
                //SourceExpr=decCFMonth;
            }
            Column(decCFPlannedMonth; decCFPlannedMonth)
            {
                //SourceExpr=decCFPlannedMonth;
            }
            Column(decCFOrigin; decCFOrigin)
            {
                //SourceExpr=decCFOrigin;
            }
            Column(decEXPlannedOrigin; decEXPlannedOrigin)
            {
                //SourceExpr=decEXPlannedOrigin;
            }
            Column(decEXMonth; decEXMonth)
            {
                //SourceExpr=decEXMonth;
            }
            Column(decEXPlannedMonth; decEXPlannedMonth)
            {
                //SourceExpr=decEXPlannedMonth;
            }
            Column(decEXOrigin; decEXOrigin)
            {
                //SourceExpr=decEXOrigin;
            }
            Column(decCDMonth_decAAMonth_decGCMonth_decAIMonth_decADMonth_decCFMonth; decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth)
            {
                //SourceExpr=decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth;
            }
            Column(decCDPlannedMonth_decAAPlannedMonth_decGCPlannedMonth_decAIPlannedMonth_decADPlannedMonth_decCFPlannedMonth; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth;
            }
            Column(decCDOrigin_decAAOrigin_decGCOrigin_decAIOrigin_decADOrigin_decCFOrigin; decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin + decCFOrigin)
            {
                //SourceExpr=decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin  + decCFOrigin;
            }
            Column(decCDPlannedOrigin_decAAPlannedOrigin_decGCPlannedOrigin_decAIPlannedOrigin_decADPlannedOrigin_decCFPlannedOrigin; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin)
            {
                //SourceExpr=decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin;
            }
            Column(decCDMonth_decAAMonth_decGCMonth_decAIMonth_decADMonth_decCFMonth_decEXMonth; decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth + decEXMonth)
            {
                //SourceExpr=decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth + decEXMonth;
            }
            //verify similar scenarios
            Column(decCDPlannedM_decAAPlannedM_decGCPlannedM_decAIPlannedM_decADPlannedM_decCFPlannedM_decEXPlannedM; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth  + decEXPlannedMonth;
            }
            Column(decCDOrigin_decAAOrigin_decGCOrigin_decAIOrigin_decADOrigin_decCFOrigin_decEXOrigin; decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin + decCFOrigin + decEXOrigin)
            {
                //SourceExpr=decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin  + decCFOrigin + decEXOrigin;
            }
            Column(decCDPlannedO_decAAPlannedO_decGCPlannedO_decAIPlannedO_decADPlannedO_decCFPlannedO_decEXPlannedO; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin)
            {
                //SourceExpr=decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin;
            }
            Column(decResultMonth; decResultMonth)
            {
                //SourceExpr=decResultMonth;
            }
            Column(decResultPlannedMonth; decResultPlannedMonth)
            {
                //SourceExpr=decResultPlannedMonth;
            }
            Column(decResultOrigin; decResultOrigin)
            {
                //SourceExpr=decResultOrigin;
            }
            Column(decResultPlannedOrigin; decResultPlannedOrigin)
            {
                //SourceExpr=decResultPlannedOrigin;
            }
            Column(decPRMonth; decPRMonth)
            {
                //SourceExpr=decPRMonth;
            }
            Column(decPRPlannedMonth; decPRPlannedMonth)
            {
                //SourceExpr=decPRPlannedMonth;
            }
            Column(decPROrigin; decPROrigin)
            {
                //SourceExpr=decPROrigin;
            }
            Column(decPRPlannedOrigin; decPRPlannedOrigin)
            {
                //SourceExpr=decPRPlannedOrigin;
            }
            Column(decTotalCertificatedMonth; decTotalCertificatedMonth)
            {
                //SourceExpr=decTotalCertificatedMonth;
            }
            Column(decTotalCertificatedAGE; decTotalCertificatedAGE)
            {
                //SourceExpr=decTotalCertificatedAGE;
            }
            Column(decTotalCertificated; decTotalCertificated)
            {
                //SourceExpr=decTotalCertificated;
            }
            Column(Boss_Name; Boss.Name)
            {
                //SourceExpr=Boss.Name;
            }
            Column(Delegate_Name; Delegate.Name)
            {
                //SourceExpr=Delegate.Name;
            }
            Column(decProvMargMONTH; decProvMargMONTH)
            {
                //SourceExpr=decProvMargMONTH;
            }
            Column(decProvExpMONTH; decProvExpMONTH)
            {
                //SourceExpr=decProvExpMONTH;
            }
            Column(decProvMargMONTH_decProvExpMONTH; decProvMargMONTH + decProvExpMONTH)
            {
                //SourceExpr=decProvMargMONTH + decProvExpMONTH;
            }
            Column(decOEProvExpMONTH; decOEProvExpMONTH)
            {
                //SourceExpr=decOEProvExpMONTH;
            }
            Column(decProvMargMONTH_decProvExpMONTH_decOEProvExpMONTH; decProvMargMONTH + decProvExpMONTH + decOEProvExpMONTH)
            {
                //SourceExpr=decProvMargMONTH + decProvExpMONTH + decOEProvExpMONTH;
            }
            Column(decProvMargPlannedMONTH; decProvMargPlannedMONTH)
            {
                //SourceExpr=decProvMargPlannedMONTH;
            }
            Column(decProvExpPlannedMONTH; decProvExpPlannedMONTH)
            {
                //SourceExpr=decProvExpPlannedMONTH;
            }
            Column(decProvMargPlannedMONTH_decProvExpPlannedMONTH; decProvMargPlannedMONTH + decProvExpPlannedMONTH)
            {
                //SourceExpr=decProvMargPlannedMONTH +  decProvExpPlannedMONTH;
            }
            Column(decOEProvExpPlannedMONTH; decOEProvExpPlannedMONTH)
            {
                //SourceExpr=decOEProvExpPlannedMONTH;
            }
            Column(decProvMargPlannedMONTH_decProvExpPlannedMONTH_decOEProvExpPlannedMONTH; decProvMargPlannedMONTH + decProvExpPlannedMONTH + decOEProvExpPlannedMONTH)
            {
                //SourceExpr=decProvMargPlannedMONTH + decProvExpPlannedMONTH + decOEProvExpPlannedMONTH;
            }
            Column(decProvMargORIGIN; decProvMargORIGIN)
            {
                //SourceExpr=decProvMargORIGIN;
            }
            Column(decProvExpORIGIN; decProvExpORIGIN)
            {
                //SourceExpr=decProvExpORIGIN;
            }
            Column(decProvMargORIGIN_decProvExpORIGIN; decProvMargORIGIN + decProvExpORIGIN)
            {
                //SourceExpr=decProvMargORIGIN + decProvExpORIGIN;
            }
            Column(decOEProvExpORIGIN; decOEProvExpORIGIN)
            {
                //SourceExpr=decOEProvExpORIGIN;
            }
            Column(decProvMargORIGIN_decProvExpORIGIN_decOEProvExpORIGIN; decProvMargORIGIN + decProvExpORIGIN + decOEProvExpORIGIN)
            {
                //SourceExpr=decProvMargORIGIN + decProvExpORIGIN + decOEProvExpORIGIN;
            }
            Column(decOEProvExpPlannedORIGIN; decOEProvExpPlannedORIGIN)
            {
                //SourceExpr=decOEProvExpPlannedORIGIN;
            }
            Column(decProvExpPlannedORIGIN; decProvExpPlannedORIGIN)
            {
                //SourceExpr=decProvExpPlannedORIGIN;
            }
            Column(decProvMargPlannedORIGIN; decProvMargPlannedORIGIN)
            {
                //SourceExpr=decProvMargPlannedORIGIN;
            }
            Column(decProvMargPlannedORIGIN_decProvExpPlannedORIGIN_decOEProvExpPlannedORIGIN; decProvMargPlannedORIGIN + decProvExpPlannedORIGIN + decOEProvExpPlannedORIGIN)
            {
                //SourceExpr=decProvMargPlannedORIGIN + decProvExpPlannedORIGIN + decOEProvExpPlannedORIGIN;
            }
            Column(decProvMargPlannedORIGIN_decProvExpPlannedORIGIN; decProvMargPlannedORIGIN + decProvExpPlannedORIGIN)
            {
                //SourceExpr=decProvMargPlannedORIGIN + decProvExpPlannedORIGIN;
            }
            Column(decProductionPlannedORIGIN_decProvMargPlannedORIGIN_decProvExpPlannedORIGIN_decOEProvExpPlannedORIGIN; decProductionPlannedORIGIN - (decProvMargPlannedORIGIN + decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN))
            {
                //SourceExpr=decProductionPlannedORIGIN - ( decProvMargPlannedORIGIN + decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN);
            }
            Column(decProductionORIGIN_decProvMargORIGIN_decProvExpORIGIN_decOEProvExpORIGIN; decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN))
            {
                //SourceExpr=decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN);
            }
            Column(decProductionPlannedMONTH_decProvMargPlannedMONTH_decProvExpPlannedMONTH_decOEProvExpPlannedMONTH; decProductionPlannedMONTH - (decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH))
            {
                //SourceExpr=decProductionPlannedMONTH - (decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH);
            }
            Column(decProductionMONTH_decProvMargMONTH_decProvExpMONTH_decOEProvExpMONTH; decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH))
            {
                //SourceExpr=decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH);
            }
            Column(decProductionNormalRealAGE; decProductionNormalRealAGE)
            {
                //SourceExpr=decProductionNormalRealAGE;
            }
            Column(decProductionNormalPlannedAGE; decProductionNormalPlannedAGE)
            {
                //SourceExpr=decProductionNormalPlannedAGE;
            }
            Column(decProvMargAGE; decProvMargAGE)
            {
                //SourceExpr=decProvMargAGE;
            }
            Column(decProvExpAGE; decProvExpAGE)
            {
                //SourceExpr=decProvExpAGE;
            }
            Column(decProvExpPlannedAGE; decProvExpPlannedAGE)
            {
                //SourceExpr=decProvExpPlannedAGE;
            }
            Column(decProvMargPlannedAGE; decProvMargPlannedAGE)
            {
                //SourceExpr=decProvMargPlannedAGE;
            }
            Column(decProvMargAGE_decProvExpAGE; decProvMargAGE + decProvExpAGE)
            {
                //SourceExpr=decProvMargAGE + decProvExpAGE;
            }
            Column(decProvExpPlannedAGE_decProvMargPlannedAGE; decProvExpPlannedAGE + decProvMargPlannedAGE)
            {
                //SourceExpr=decProvExpPlannedAGE + decProvMargPlannedAGE;
            }
            Column(decOEProvExpAGE; decOEProvExpAGE)
            {
                //SourceExpr=decOEProvExpAGE;
            }
            Column(decOEProvExpPlannedAGE; decOEProvExpPlannedAGE)
            {
                //SourceExpr=decOEProvExpPlannedAGE;
            }
            Column(decProvMargAGE_decProvExpAGE_decOEProvExpAGE; decProvMargAGE + decProvExpAGE - decOEProvExpAGE)
            {
                //SourceExpr=decProvMargAGE + decProvExpAGE - decOEProvExpAGE;
            }
            Column(decProductionAGE_decProvMargAGE_decProvExpAGE_decOEProvExpAGE; decProductionAGE - (decProvMargAGE + decProvExpAGE - decOEProvExpAGE))
            {
                //SourceExpr=decProductionAGE - (decProvMargAGE + decProvExpAGE - decOEProvExpAGE);
            }
            Column(decProductionPlannedAGE_decProvMargPlannedAGE_decProvExpPlannedAGE_decOEProvExpPlannedAGE; decProductionPlannedAGE - (decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE))
            {
                //SourceExpr=decProductionPlannedAGE - (decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE);
            }
            Column(decProvMargPlannedAGE_decProvExpPlannedAGE_decOEProvExpPlannedAGE; decProvMargPlannedAGE + decProvExpPlannedAGE + decOEProvExpPlannedAGE)
            {
                //SourceExpr=decProvMargPlannedAGE + decProvExpPlannedAGE + decOEProvExpPlannedAGE;
            }
            Column(decAAAGE; decAAAGE)
            {
                //SourceExpr=decAAAGE;
            }
            Column(decGCAGE; decGCAGE)
            {
                //SourceExpr=decGCAGE;
            }
            Column(decAIAGE; decAIAGE)
            {
                //SourceExpr=decAIAGE;
            }
            Column(decADAGE; decADAGE)
            {
                //SourceExpr=decADAGE;
            }
            Column(decAAAGE_decGCAGE_decAIAGE_decADAGE; decAAAGE + decGCAGE + decAIAGE + decADAGE)
            {
                //SourceExpr=decAAAGE + decGCAGE + decAIAGE + decADAGE;
            }
            Column(decAAPlannedAGE; decAAPlannedAGE)
            {
                //SourceExpr=decAAPlannedAGE;
            }
            Column(decGCPlannedAGE; decGCPlannedAGE)
            {
                //SourceExpr=decGCPlannedAGE;
            }
            Column(decAIPlannedAGE; decAIPlannedAGE)
            {
                //SourceExpr=decAIPlannedAGE;
            }
            Column(decADPlannedAGE; decADPlannedAGE)
            {
                //SourceExpr=decADPlannedAGE;
            }
            Column(decAAPlannedAGE_decGCPlannedAGE_decAIPlannedAGE_decADPlannedAGE; decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE)
            {
                //SourceExpr=decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE +  decADPlannedAGE;
            }
            Column(decCFPlannedAGE; decCFPlannedAGE)
            {
                //SourceExpr=decCFPlannedAGE;
            }
            Column(decCFAGE; decCFAGE)
            {
                //SourceExpr=decCFAGE;
            }
            Column(decCDAGE_decAAAGE_decGCAGE_decAIAGE_decADAGE_decCFAGE; decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE + decCFAGE)
            {
                //SourceExpr=decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE  + decCFAGE;
            }
            Column(decCDPlannedAGE_decAAPlannedAGE_decGCPlannedAGE_decAIPlannedAGE_decADPlannedAGE_decCFPlannedAGE; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE;
            }
            Column(decEXAGE; decEXAGE)
            {
                //SourceExpr=decEXAGE;
            }
            Column(decEXPlannedAGE; decEXPlannedAGE)
            {
                //SourceExpr=decEXPlannedAGE;
            }
            Column(decCDAGE_decAAAGE_decGCAGE_decAIAGE_decADAGE_decCFAGE_decEXAGE; decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE + decCFAGE + decEXAGE)
            {
                //SourceExpr=decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE  + decCFAGE + decEXAGE;
            }
            Column(decCDPlannedAGE_decAAPlannedAGE_decGCPlannedAGE_decAIPlannedAGE_decADPlannedAGE_decCFPlannedAGE_decEXPlannedAGE; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE;
            }
            Column(decResultAGE; decResultAGE)
            {
                //SourceExpr=decResultAGE;
            }
            Column(decPRAGE; decPRAGE)
            {
                //SourceExpr=decPRAGE;
            }
            Column(decResultPlannedAge; decResultPlannedAge)
            {
                //SourceExpr=decResultPlannedAge;
            }
            Column(decPRPlannedAGE; decPRPlannedAGE)
            {
                //SourceExpr=decPRPlannedAGE;
            }
            Column(decProductionNormalRealMONTH_Control1100020; decProductionNormalRealMonth)
            {
                //SourceExpr=decProductionNormalRealMonth;
            }
            Column(decProductionNormalPlannedMONTH_Control1100024; decProductionNormalPlannedMonth)
            {
                //SourceExpr=decProductionNormalPlannedMonth;
            }
            Column(decCDMonth_Control1100034; decCDMonth)
            {
                //SourceExpr=decCDMonth;
            }
            Column(decCDPlanned_month_Control1100035; decCDPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth;
            }
            Column(decAAMonth_Control1100036; decAAMonth)
            {
                //SourceExpr=decAAMonth;
            }
            Column(decAAPlanned_Month_Control1100037; decAAPlannedMonth)
            {
                //SourceExpr=decAAPlannedMonth;
            }
            Column(decGCMonth_Control1100038; decGCMONTH)
            {
                //SourceExpr=decGCMONTH;
            }
            Column(decGCPlanned_Month_Control1100039; decGCPlannedMONTH)
            {
                //SourceExpr=decGCPlannedMONTH;
            }
            Column(decAIMonth_Control1100040; decAIMonth)
            {
                //SourceExpr=decAIMonth;
            }
            Column(decAIPlannedMonth_Control1100041; decAIPlannedMonth)
            {
                //SourceExpr=decAIPlannedMonth;
            }
            Column(decADMonth_Control1100042; decADMonth)
            {
                //SourceExpr=decADMonth;
            }
            Column(decADPlannedMonth_Control1100043; decADPlannedMonth)
            {
                //SourceExpr=decADPlannedMonth;
            }
            Column(decAAMonth___decGCMonth___decAIMonth___decADMonth_Control1100044; decAAMonth + decGCMONTH + decAIMonth + decADMonth)
            {
                //SourceExpr=decAAMonth+ decGCMONTH + decAIMonth + decADMonth;
            }
            Column(decAAPlannedMonth___decGCPlannedMonth___decAIPlannedMonth___decADPlannedMonth_Control1100045; decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth)
            {
                //SourceExpr=decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth;
            }
            Column(decCFMonth_Control1100046; decCFMonth)
            {
                //SourceExpr=decCFMonth;
            }
            Column(decCFPlannedMonth_Control1100047; decCFPlannedMonth)
            {
                //SourceExpr=decCFPlannedMonth;
            }
            Column(decEXMonthControl1100048; decEXMonth)
            {
                //SourceExpr=decEXMonth;
            }
            Column(decEXPlannedMonth_Control1100049; decEXPlannedMonth)
            {
                //SourceExpr=decEXPlannedMonth;
            }
            Column(decCDMonth___decAAMonth___decGCMonth___decAIMonth___decADMonth___decCFMonth_Control1100050; decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth)
            {
                //SourceExpr=decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth+ decCFMonth;
            }
            Column(decCDPlannedM___decAAPlannedM___decGCPlannedM___decAIPlannedM___decADPlannedM___decCFPlannedM_Control1100051; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth;
            }
            Column(decProductionNormalRealOrigin_Control1100057; decProductionNormalRealOrigin)
            {
                //SourceExpr=decProductionNormalRealOrigin;
            }
            Column(decCDOrigin_Control1100064; decCDOrigin)
            {
                //SourceExpr=decCDOrigin;
            }
            Column(decAAOrigin_Control1100065; decAAOrigin)
            {
                //SourceExpr=decAAOrigin;
            }
            Column(decGCOrigin_Control1100066; decGCOrigin)
            {
                //SourceExpr=decGCOrigin;
            }
            Column(decAIOrigin_Control1100067; decAIOrigin)
            {
                //SourceExpr=decAIOrigin;
            }
            Column(decADOrigin_Control1100068; decADOrigin)
            {
                //SourceExpr=decADOrigin;
            }
            Column(decAAOrigin___decGCOrigin___decAIOrigin___decADOrigin_Control1100069; decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin)
            {
                //SourceExpr=decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin;
            }
            Column(decCFOrigien_Control1100070; decCFOrigin)
            {
                //SourceExpr=decCFOrigin;
            }
            Column(decEXOrigin_Control1100071; decEXOrigin)
            {
                //SourceExpr=decEXOrigin;
            }
            Column(decCDOrigin___decAAOrigin___decGCOrigin___decAIOrigin___decADOrigin____decCFOrigin_Control1100072; decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin + decCFOrigin)
            {
                //SourceExpr=decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin  + decCFOrigin;
            }
            Column(decCDMonth___decAAMonth___decGCMonth___decAIMonth___decADMonth___decCFMonth___decEXMonth_Control1100073; decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth + decEXMonth)
            {
                //SourceExpr=decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth + decEXMonth;
            }
            Column(decCDPlM___decAAPlM___decGCPlM___decAIPlM___decADPlM___decCFPlM____decEXPlM_Control1100074; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth  + decEXPlannedMonth;
            }
            Column(decCDOrigin___decAAOrigin___decGCOrigin___decAIOrigin___decADOrigin____decCFOrigin_____decEXOrigin_Control1100075; decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin + decCFOrigin + decEXOrigin)
            {
                //SourceExpr=decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin  + decCFOrigin   + decEXOrigin;
            }
            Column(decResultMonth_Control1100081; decResultMonth)
            {
                //SourceExpr=decResultMonth;
            }
            Column(decResultPlannedMonth_Control1100082; decResultPlannedMonth)
            {
                //SourceExpr=decResultPlannedMonth;
            }
            Column(decResultOrigin_Control1100083; decResultOrigin)
            {
                //SourceExpr=decResultOrigin;
            }
            Column(decPRMonth_Control1100088; decPRMonth)
            {
                //SourceExpr=decPRMonth;
            }
            Column(decPRPlannedMonth_Control1100089; decPRPlannedMonth)
            {
                //SourceExpr=decPRPlannedMonth;
            }
            Column(decPROrigin_Control1100090; decPROrigin)
            {
                //SourceExpr=decPROrigin;
            }
            Column(decTotalCertificatedMonth_Control1100100; decTotalCertificatedMonth)
            {
                //SourceExpr=decTotalCertificatedMonth;
            }
            Column(decTotalCertificatedAGE_Control1100102; decTotalCertificatedAGE)
            {
                //SourceExpr=decTotalCertificatedAGE;
            }
            Column(Boss_Name_Control1100112; Boss.Name)
            {
                //SourceExpr=Boss.Name;
            }
            Column(Delegate_Name_Control1100113; Delegate.Name)
            {
                //SourceExpr=Delegate.Name;
            }
            Column(decProductionNormalRealOrigin_Control1100117; decProductionNormalRealOrigin)
            {
                //SourceExpr=decProductionNormalRealOrigin;
            }
            Column(decCDPlannedOrigin_Control1100121; decCDPlannedOrigin)
            {
                //SourceExpr=decCDPlannedOrigin;
            }
            Column(decAAPlannedOrigin_Control1100122; decAAPlannedOrigin)
            {
                //SourceExpr=decAAPlannedOrigin;
            }
            Column(decGCPlannedOrigin_Control1100123; decGCPlannedOrigin)
            {
                //SourceExpr=decGCPlannedOrigin;
            }
            Column(decAIPlannedOrigin_Control1100124; decAIPlannedOrigin)
            {
                //SourceExpr=decAIPlannedOrigin;
            }
            Column(decADPlannedOrigin_Control1100125; decADPlannedOrigin)
            {
                //SourceExpr=decADPlannedOrigin;
            }
            Column(decAAPlannedOrigin___decGCPlannedOrigin___decAIPlannedOrigin___decADPlannedOrigin_Control1100126; decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin)
            {
                //SourceExpr=decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin;
            }
            Column(decCFPlannedOrigin_Control1100127; decCFPlannedOrigin)
            {
                //SourceExpr=decCFPlannedOrigin;
            }
            Column(decEXPlannedOrigin_Control1100128; decEXPlannedOrigin)
            {
                //SourceExpr=decEXPlannedOrigin;
            }
            Column(decCDPlannedO___decAAPlannedO___decGCPlannedO___decAIPlannedO___decADPlannedO___decCFPlannedO_Control1100129; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin)
            {
                //SourceExpr=decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin;
            }
            Column(decCDPlO___decAAPlO___decGCPlO___decAIPlO___decADPlO___decCFPlO____decEXPlO_Control1100130; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin)
            {
                //SourceExpr=decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin  + decEXPlannedOrigin;
            }
            Column(decResultPlannedOrigin_Control1100131; decResultPlannedOrigin)
            {
                //SourceExpr=decResultPlannedOrigin;
            }
            Column(decPRPlannedOrigin_Control1100132; decPRPlannedOrigin)
            {
                //SourceExpr=decPRPlannedOrigin;
            }
            Column(decTotalCertificated_Control1100136; decTotalCertificated)
            {
                //SourceExpr=decTotalCertificated;
            }
            Column(decProvMargMonth_Control1100180; decProvMargMONTH)
            {
                //SourceExpr=decProvMargMONTH;
            }
            Column(decProvExpMonth_Control1100181; decProvExpMONTH)
            {
                //SourceExpr=decProvExpMONTH;
            }
            Column(decProvMargMonth___decProvExpMonth_Control1100182; decProvMargMONTH + decProvExpMONTH)
            {
                //SourceExpr=decProvMargMONTH+ decProvExpMONTH;
            }
            Column(decOEProvExpMonth_Control1100183; decOEProvExpMONTH)
            {
                //SourceExpr=decOEProvExpMONTH;
            }
            Column(decProvMargMonth___decProvExpMonth___decOEProvExpMonth_Control1100184; decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH)
            {
                //SourceExpr=decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH;
            }
            Column(decProductionMonth____decProvMargMonth___decProvExpMonth___decOEProvExpMonth__Control1100186; decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH))
            {
                //SourceExpr=decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH);
            }
            Column(decProvMargPlannedMonth_Control1100187; decProvMargPlannedMONTH)
            {
                //SourceExpr=decProvMargPlannedMONTH;
            }
            Column(decProvExpPlannedMonth_Control1100188; decProvExpPlannedMONTH)
            {
                //SourceExpr=decProvExpPlannedMONTH;
            }
            Column(decProvMargPlannedMonth___decProvExpPlannedMonth_Control1100189; decProvMargPlannedMONTH + decProvExpPlannedMONTH)
            {
                //SourceExpr=decProvMargPlannedMONTH + decProvExpPlannedMONTH;
            }
            Column(decOEProvExpPlannedMonth_Control1100190; decOEProvExpPlannedMONTH)
            {
                //SourceExpr=decOEProvExpPlannedMONTH;
            }
            Column(decProvMargPlannedMonth___decProvExpPlannedMonth___decOEProvExpPlannedMonth_Control1100191; decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH)
            {
                //SourceExpr=decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH;
            }
            Column(decProductionPlannedMonth____decProvMargPlannedMonth___decProvPlannedMonth___decOEProvPlannedMonth__Control1100192; decProductionPlannedMONTH - (decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH))
            {
                //SourceExpr=decProductionPlannedMONTH - (decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH);
            }
            Column(decProvMargORIGIN_Control1100193; decProvMargORIGIN)
            {
                //SourceExpr=decProvMargORIGIN;
            }
            Column(decProvExpORIGIN_Control1100194; decProvExpORIGIN)
            {
                //SourceExpr=decProvExpORIGIN;
            }
            Column(decProvMargORIGIN___decProvExpORIGIN_Control1100195; decProvMargORIGIN + decProvExpORIGIN)
            {
                //SourceExpr=decProvMargORIGIN + decProvExpORIGIN;
            }
            Column(decOEProvExpORIGIN_Control1100196; decOEProvExpORIGIN)
            {
                //SourceExpr=decOEProvExpORIGIN;
            }
            Column(decProvMargORIGIN___decProvExpORIGIN___decOEProvExpORIGIN_Control1100197; decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN)
            {
                //SourceExpr=decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN;
            }
            Column(decProductionORIGIN____decProvMargORIGIN___decProvExpORIGIN___decOEProvExpORIGIN__Control1100198; decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN))
            {
                //SourceExpr=decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN);
            }
            Column(decOEProvExpPlannedORIGIN_Control1100199; decOEProvExpPlannedORIGIN)
            {
                //SourceExpr=decOEProvExpPlannedORIGIN;
            }
            Column(decProvExpPlanificadaORIGIN_Control1100200; decProvExpPlannedORIGIN)
            {
                //SourceExpr=decProvExpPlannedORIGIN;
            }
            Column(decProvMargPlannedORIGIN_Control1100201; decProvMargPlannedORIGIN)
            {
                //SourceExpr=decProvMargPlannedORIGIN;
            }
            Column(decProvMargPlannedORIGIN___decProvExpPlannedORIGIN___decOEProvExpPlannedORIGIN_Control1100202; decProvMargPlannedORIGIN + decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN)
            {
                //SourceExpr=decProvMargPlannedORIGIN + decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN;
            }
            Column(decProvMargPlannedORIGIN___decProvExpPlannedORIGIN_Control1100203; decProvMargPlannedORIGIN + decProvExpPlannedORIGIN)
            {
                //SourceExpr=decProvMargPlannedORIGIN + decProvExpPlannedORIGIN;
            }
            Column(decProductionPlannedO____decProvMargPlannedO___decProvExpPlannedO___decOEProvExpPlannedO__Control1100204; decProductionPlannedORIGIN - (decProvMargPlannedORIGIN + decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN))
            {
                //SourceExpr=decProductionPlannedORIGIN - (decProvMargPlannedORIGIN + decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN);
            }
            Column(decCDAGE_Control1100251148; decCDAGE)
            {
                //SourceExpr=decCDAGE;
            }
            Column(decAAAGE_Control1100251151; decAAAGE)
            {
                //SourceExpr=decAAAGE;
            }
            Column(decGCAGE_Control1100251153; decGCAGE)
            {
                //SourceExpr=decGCAGE;
            }
            Column(decAIAGE_Control1100251154; decAIAGE)
            {
                //SourceExpr=decAIAGE;
            }
            Column(decADAGE_Control1100251155; decADAGE)
            {
                //SourceExpr=decADAGE;
            }
            Column(decAAAGE___decGCAGE___decAIAGE___decADAGE_Control1100251156; decAAAGE + decGCAGE + decAIAGE + decADAGE)
            {
                //SourceExpr=decAAAGE + decGCAGE + decAIAGE + decADAGE;
            }
            Column(decCFAGE_Control1100251157; decCFAGE)
            {
                //SourceExpr=decCFAGE;
            }
            Column(decCDPlannedAGE_Control1100251158; decCDPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE;
            }
            Column(decAAPlannedAGE_Control1100251159; decAAPlannedAGE)
            {
                //SourceExpr=decAAPlannedAGE;
            }
            Column(decGCPlannedAGE_Control1100251160; decGCPlannedAGE)
            {
                //SourceExpr=decGCPlannedAGE;
            }
            Column(decAIPlannedAGE_Control1100251161; decAIPlannedAGE)
            {
                //SourceExpr=decAIPlannedAGE;
            }
            Column(decADPlannedAGE_Control1100251162; decADPlannedAGE)
            {
                //SourceExpr=decADPlannedAGE;
            }
            Column(decAAPlannedAGE___decGCPlannedAGE___decAIPlannedAGE___decADPlannedAGE_Control1100251163; decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE)
            {
                //SourceExpr=decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE;
            }
            Column(decCFPlannedAGE_Control1100251164; decCFPlannedAGE)
            {
                //SourceExpr=decCFPlannedAGE;
            }
            Column(decCDAGE___decAAAGE___decGCAGE___decAIAGE___decADAGE____decCFAGE_Control1100251165; decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE + decCFAGE)
            {
                //SourceExpr=decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE  + decCFAGE;
            }
            Column(decCDPlAGE___decAAPlAGE___decGCPlAGE___decAIPlAGE___decADPlAGE___decCFPlAGE_Control1100251166; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE;
            }
            Column(decEXAGE_Control1100251167; decEXAGE)
            {
                //SourceExpr=decEXAGE;
            }
            Column(decEXPlannedAGE_Control1100251168; decEXPlannedAGE)
            {
                //SourceExpr=decEXPlannedAGE;
            }
            Column(decCDAGE___decAAAGE___decGCAGE___decAIAGE__decADAGE____decCFAGE___decEXAGE_Control1100251171; decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE + decCFAGE + decEXAGE)
            {
                //SourceExpr=decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE  + decCFAGE   + decEXAGE;
            }
            Column(decCDPlAGE___decAAPlAGE___decGCPlAGE___decAIPlAGE___decADPlAGE___decCFPlAGE____decEXPlannedAGE_Control1100251172; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE+ decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE  + decEXPlannedAGE;
            }
            Column(decPRAGE_Control1100251179; decPRAGE)
            {
                //SourceExpr=decPRAGE;
            }
            Column(decResultAGE_Control1100251180; decResultAGE)
            {
                //SourceExpr=decResultAGE;
            }
            Column(decResultPlannedAGE_Control1100251182; decResultPlannedAge)
            {
                //SourceExpr=decResultPlannedAge;
            }
            Column(decPRPlannedAGE_Control1100251183; decPRPlannedAGE)
            {
                //SourceExpr=decPRPlannedAGE;
            }
            Column(decProductionNormalRealAGE_Control1100251185; decProductionNormalRealAGE)
            {
                //SourceExpr=decProductionNormalRealAGE;
            }
            Column(decProductionNormalPlannedAGE_Control1100251186; decProductionNormalPlannedAGE)
            {
                //SourceExpr=decProductionNormalPlannedAGE;
            }
            Column(decProvMargAGE_Control1100251187; decProvMargAGE)
            {
                //SourceExpr=decProvMargAGE;
            }
            Column(decProvExpAGE_Control1100251188; decProvExpAGE)
            {
                //SourceExpr=decProvExpAGE;
            }
            Column(decProvExpPlannedAGE_Control1100251189; decProvExpPlannedAGE)
            {
                //SourceExpr=decProvExpPlannedAGE;
            }
            Column(decProvMargPlannedAGE_Control1100251190; decProvMargPlannedAGE)
            {
                //SourceExpr=decProvMargPlannedAGE;
            }
            Column(decProvMargAGE___decProvExpAGE_Control1100251191; decProvMargAGE + decProvExpAGE)
            {
                //SourceExpr=decProvMargAGE + decProvExpAGE;
            }
            Column(decProvMargPlannedAGE___decProvExpPlannedAGE_Control1100251192; decProvMargPlannedAGE + decProvExpPlannedAGE)
            {
                //SourceExpr=decProvMargPlannedAGE + decProvExpPlannedAGE;
            }
            Column(decOEProvExpAGE_Control1100251193; decOEProvExpAGE)
            {
                //SourceExpr=decOEProvExpAGE;
            }
            Column(decOEProvExpPlannedAGE_Control1100251194; decOEProvExpPlannedAGE)
            {
                //SourceExpr=decOEProvExpPlannedAGE;
            }
            Column(decProductionAGE____decProvMargAGE___decProvExpAGE___decOEProvExpAGE__Control1100251195; decProductionAGE - (decProvMargAGE + decProvExpAGE - decOEProvExpAGE))
            {
                //SourceExpr=decProductionAGE - (decProvMargAGE + decProvExpAGE - decOEProvExpAGE);
            }
            Column(decProvMargAGE___decProvExpAGE___decOEProvExpAGE_Control1100251196; decProvMargAGE + decProvExpAGE - decOEProvExpAGE)
            {
                //SourceExpr=decProvMargAGE + decProvExpAGE - decOEProvExpAGE;
            }
            Column(decProvMargPlannedAGE___decProvExpPlannedAGE___decOEProvExpPlannedAGE_Control1100251197; decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE)
            {
                //SourceExpr=decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE;
            }
            Column(decProducionPlannedAGE____decProvMargPlannedAGE___decProvExpPlannedAGE___decOEProvExpPlannedAGE__Control1100251198; decProductionPlannedAGE - (decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE))
            {
                //SourceExpr=decProductionPlannedAGE - (decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE);
            }
            Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(PRODUCTIONCaptionLbl; PRODUCTIONCaptionLbl)
            {
                //SourceExpr=PRODUCTIONCaptionLbl;
            }
            Column(WORKCaptionLbl; WORKCaptionLbl)
            {
                //SourceExpr=WORKCaptionLbl;
            }
            Column(AGE_CaptionLbl; AGE_CaptionLbl)
            {
                //SourceExpr=AGE_CaptionLbl;
            }
            Column(MONTH_CaptionLbl; MONTH_CaptionLbl)
            {
                //SourceExpr=MONTH_CaptionLbl;
            }
            Column(DELEGATE_CaptionLbl; DELEGATE_CaptionLbl)
            {
                //SourceExpr=DELEGATE_CaptionLbl;
            }
            Column(ADDRESS_CaptionLbl; ADDRESS_CaptionLbl)
            {
                //SourceExpr=ADDRESS_CaptionLbl;
            }
            Column(MONTHCaptionLbl; MONTHCaptionLbl)
            {
                //SourceExpr=MONTHCaptionLbl;
            }
            Column(PLANNEDCaptionLbl; PLANNEDCaptionLbl)
            {
                //SourceExpr=PLANNEDCaptionLbl;
            }
            Column(AGECaptionLbl; AGECaptionLbl)
            {
                //SourceExpr=AGECaptionLbl;
            }
            Column(REALCaptionLbl; REALCaptionLbl)
            {
                //SourceExpr=REALCaptionLbl;
            }
            Column(PLANNEDCaption_Control1100251338Lbl; PLANNEDCaption_Control1100251338Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251338Lbl;
            }
            Column(REALCaption_Control1100251340Lbl; REALCaption_Control1100251340Lbl)
            {
                //SourceExpr=REALCaption_Control1100251340Lbl;
            }
            Column(ORIGINCaptionLbl; ORIGINCaptionLbl)
            {
                //SourceExpr=ORIGINCaptionLbl;
            }
            Column(PLANNEDCaption_Control1100251009Lbl; PLANNEDCaption_Control1100251009Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251009Lbl;
            }
            Column(REALCaption_Control1100251021Lbl; REALCaption_Control1100251021Lbl)
            {
                //SourceExpr=REALCaption_Control1100251021Lbl;
            }
            Column(PRODUCTIONCaption_Control1100251327Lbl; PRODUCTIONCaption_Control1100251327Lbl)
            {
                //SourceExpr=PRODUCTIONCaption_Control1100251327Lbl;
            }
            Column(ALLCOMPANYACaptionLbl; ALLCOMPANYACaptionLbl)
            {
                //SourceExpr=ALLCOMPANYACaptionLbl;
            }
            Column(MONTH_Caption_Control1100251336Lbl; MONTH_Caption_Control1100251336Lbl)
            {
                //SourceExpr=MONTH_Caption_Control1100251336Lbl;
            }
            Column(AGE_Caption_Control1100251341Lbl; AGE_Caption_Control1100251341Lbl)
            {
                //SourceExpr=AGE_Caption_Control1100251341Lbl;
            }
            Column(MONTHCaption_Control1100251354Lbl; MONTHCaption_Control1100251354Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100251354Lbl;
            }
            Column(REALCaption_Control1100251355Lbl; REALCaption_Control1100251355Lbl)
            {
                //SourceExpr=REALCaption_Control1100251355Lbl;
            }
            Column(PLANNEDCaption_Control1100251356Lbl; PLANNEDCaption_Control1100251356Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251356Lbl;
            }
            Column(ORIGiNCaption_Control1100251357Lbl; ORIGiNCaption_Control1100251357Lbl)
            {
                //SourceExpr=ORIGiNCaption_Control1100251357Lbl;
            }
            Column(REALCaption_Control1100251358Lbl; REALCaption_Control1100251358Lbl)
            {
                //SourceExpr=REALCaption_Control1100251358Lbl;
            }
            Column(PLANNEDDCaption_Control1100251359Lbl; PLANNEDDCaption_Control1100251359Lbl)
            {
                //SourceExpr=PLANNEDDCaption_Control1100251359Lbl;
            }
            Column(ORIGINCaption_Control1100251023Lbl; ORIGINCaption_Control1100251023Lbl)
            {
                //SourceExpr=ORIGINCaption_Control1100251023Lbl;
            }
            Column(PLANNEDDCaption_Control1100251027Lbl; PLANNEDDCaption_Control1100251027Lbl)
            {
                //SourceExpr=PLANNEDDCaption_Control1100251027Lbl;
            }
            Column(REALCaption_Control1100251028Lbl; REALCaption_Control1100251028Lbl)
            {
                //SourceExpr=REALCaption_Control1100251028Lbl;
            }
            Column(COSTCaptionLbl; COSTCaptionLbl)
            {
                //SourceExpr=COSTCaptionLbl;
            }
            Column(GROSS_EXECUTED_WORKCaptionLbl; GROSS_EXECUTED_WORKCaptionLbl)
            {
                //SourceExpr=GROSS_EXECUTED_WORKCaptionLbl;
            }
            Column(INDIRECT_COSTCaptionLbl; INDIRECT_COSTCaptionLbl)
            {
                //SourceExpr=INDIRECT_COSTCaptionLbl;
            }
            Column(anticipated_spendingssCaptionLbl; anticipated_spendingssCaptionLbl)
            {
                //SourceExpr=anticipated_spendingssCaptionLbl;
            }
            Column(Current_ExpensesCaptionLbl; Current_ExpensesCaptionLbl)
            {
                //SourceExpr=Current_ExpensesCaptionLbl;
            }
            Column(immobilized_AmortizationCaptionLbl; immobilized_AmortizationCaptionLbl)
            {
                //SourceExpr=immobilized_AmortizationCaptionLbl;
            }
            Column(deferred_expensesCaptionLbl; deferred_expensesCaptionLbl)
            {
                //SourceExpr=deferred_expensesCaptionLbl;
            }
            Column(INDIRECT_TOTAL_COSTCaptionLbl; INDIRECT_TOTAL_COSTCaptionLbl)
            {
                //SourceExpr=INDIRECT_TOTAL_COSTCaptionLbl;
            }
            Column(FINANCIAL_LOANSCaptionLbl; FINANCIAL_LOANSCaptionLbl)
            {
                //SourceExpr=FINANCIAL_LOANSCaptionLbl;
            }
            Column(INDIRECT_COTSCaptionLbl; INDIRECT_COTSCaptionLbl)
            {
                //SourceExpr=INDIRECT_COTSCaptionLbl;
            }
            Column(RESULTSCaptionLbl; RESULTSCaptionLbl)
            {
                //SourceExpr=RESULTSCaptionLbl;
            }
            Column(RESULTSCaption_Control1100251138Lbl; RESULTSCaption_Control1100251138Lbl)
            {
                //SourceExpr=RESULTSCaption_Control1100251138Lbl;
            }
            Column(OVER_O_E_CaptionLbl; OVER_O_E_CaptionLbl)
            {
                //SourceExpr=OVER_O_E_CaptionLbl;
            }
            Column(CERTIFICATE_AND_PAYMENTCaptionLbl; CERTIFICATE_AND_PAYMENTCaptionLbl)
            {
                //SourceExpr=CERTIFICATE_AND_PAYMENTCaptionLbl;
            }
            Column(TOTAL_CERTIFICATE__sin_iva_CaptionLbl; TOTAL_CERTIFICATE__sin_iva_CaptionLbl)
            {
                //SourceExpr=TOTAL_CERTIFICATE__sin_iva_CaptionLbl;
            }
            Column(MONTHCaption_Control1100251384Lbl; MONTHCaption_Control1100251384Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100251384Lbl;
            }
            Column(REALCaption_Control1100251385Lbl; REALCaption_Control1100251385Lbl)
            {
                //SourceExpr=REALCaption_Control1100251385Lbl;
            }
            Column(PLANNEDCaption_Control1100251386Lbl; PLANNEDCaption_Control1100251386Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251386Lbl;
            }
            Column(ORIGINCaption_Control1100251387Lbl; ORIGINCaption_Control1100251387Lbl)
            {
                //SourceExpr=ORIGINCaption_Control1100251387Lbl;
            }
            Column(REALCaption_Control1100251388Lbl; REALCaption_Control1100251388Lbl)
            {
                //SourceExpr=REALCaption_Control1100251388Lbl;
            }
            Column(PLANNEDDCaption_Control1100251389Lbl; PLANNEDDCaption_Control1100251389Lbl)
            {
                //SourceExpr=PLANNEDDCaption_Control1100251389Lbl;
            }
            Column(MONTHCaption_Control1100251394Lbl; MONTHCaption_Control1100251394Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100251394Lbl;
            }
            Column(PLANNEDCaption_Control1100251152Lbl; PLANNEDCaption_Control1100251152Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251152Lbl;
            }
            Column(REALCaption_Control1100251221Lbl; REALCaption_Control1100251221Lbl)
            {
                //SourceExpr=REALCaption_Control1100251221Lbl;
            }
            Column(PLANNEDCaption_Control1100251226Lbl; PLANNEDCaption_Control1100251226Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251226Lbl;
            }
            Column(REALCaption_Control1100251237Lbl; REALCaption_Control1100251237Lbl)
            {
                //SourceExpr=REALCaption_Control1100251237Lbl;
            }
            Column(MONTHCaption_Control1100251239Lbl; MONTHCaption_Control1100251239Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100251239Lbl;
            }
            Column(AGECaption_Control1100251251Lbl; AGECaption_Control1100251251Lbl)
            {
                //SourceExpr=AGECaption_Control1100251251Lbl;
            }
            Column(AGECaption_Control1100251076Lbl; AGECaption_Control1100251076Lbl)
            {
                //SourceExpr=AGECaption_Control1100251076Lbl;
            }
            Column(ORIGINCaption_Control1100251208Lbl; ORIGINCaption_Control1100251208Lbl)
            {
                //SourceExpr=ORIGINCaption_Control1100251208Lbl;
            }
            Column(FIRMSCaptionLbl; FIRMSCaptionLbl)
            {
                //SourceExpr=FIRMSCaptionLbl;
            }
            Column(Boss_of_workCaptionLbl; Boss_of_workCaptionLbl)
            {
                //SourceExpr=Boss_of_workCaptionLbl;
            }
            Column(DelegateCaptionLbl; DelegateCaptionLbl)
            {
                //SourceExpr=DelegateCaptionLbl;
            }
            Column(EmptyStringCaptionLbl; EmptyStringCaptionLbl)
            {
                //SourceExpr=EmptyStringCaptionLbl;
            }
            Column(EmptyStringCaption_Control1100251407Lbl; EmptyStringCaption_Control1100251407Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251407Lbl;
            }
            Column(EmptyStringCaption_Control1100251408Lbl; EmptyStringCaption_Control1100251408Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251408Lbl;
            }
            Column(EmptyStringCaption_Control1100251409Lbl; EmptyStringCaption_Control1100251409Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251409Lbl;
            }
            Column(ESTIMATED_BY_MARGINSSCaptionLbl; ESTIMATED_BY_MARGINSSCaptionLbl)
            {
                //SourceExpr=ESTIMATED_BY_MARGINSSCaptionLbl;
            }
            Column(ESTIMATES_FOR_RECORDSCaptionLbl; ESTIMATES_FOR_RECORDSCaptionLbl)
            {
                //SourceExpr=ESTIMATES_FOR_RECORDSCaptionLbl;
            }
            Column(TOTAL_ESTIMATESCaptionLbl; TOTAL_ESTIMATESCaptionLbl)
            {
                //SourceExpr=TOTAL_ESTIMATESCaptionLbl;
            }
            Column(TOTAL_OE_FROM_ESTIMATESCaptionLbl; TOTAL_OE_FROM_ESTIMATESCaptionLbl)
            {
                //SourceExpr=TOTAL_OE_FROM_ESTIMATESCaptionLbl;
            }
            Column(TOTAL_NET_ESTIMATESCaptionLbl; TOTAL_NET_ESTIMATESCaptionLbl)
            {
                //SourceExpr=TOTAL_NET_ESTIMATESCaptionLbl;
            }
            Column(TOTAL_NETWORK_EXECUTEDCaptionLbl; TOTAL_NETWORK_EXECUTEDCaptionLbl)
            {
                //SourceExpr=TOTAL_NETWORK_EXECUTEDCaptionLbl;
            }
            Column(ORIGINCaption_Control1100251029Lbl; ORIGINCaption_Control1100251029Lbl)
            {
                //SourceExpr=ORIGINCaption_Control1100251029Lbl;
            }
            Column(PLANNEDCaption_Control1100251031Lbl; PLANNEDCaption_Control1100251031Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251031Lbl;
            }
            Column(REALCaption_Control1100251033Lbl; REALCaption_Control1100251033Lbl)
            {
                //SourceExpr=REALCaption_Control1100251033Lbl;
            }
            Column(AGECaption_Control1100251079Lbl; AGECaption_Control1100251079Lbl)
            {
                //SourceExpr=AGECaption_Control1100251079Lbl;
            }
            Column(REALCaption_Control1100251129Lbl; REALCaption_Control1100251129Lbl)
            {
                //SourceExpr=REALCaption_Control1100251129Lbl;
            }
            Column(PLANNEDCaption_Control1100251130Lbl; PLANNEDCaption_Control1100251130Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251130Lbl;
            }
            Column(EmptyStringCaption_Control1100251144Lbl; EmptyStringCaption_Control1100251144Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251144Lbl;
            }
            Column(EmptyStringCaption_Control1100251147Lbl; EmptyStringCaption_Control1100251147Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251147Lbl;
            }
            Column(COSTCaption_Control1100019Lbl; COSTCaption_Control1100019Lbl)
            {
                //SourceExpr=COSTCaption_Control1100019Lbl;
            }
            Column(GROSS_EXECUTED_WORKCaption_Control1100001Lbl; GROSS_EXECUTED_WORKCaption_Control1100001Lbl)
            {
                //SourceExpr=GROSS_EXECUTED_WORKCaption_Control1100001Lbl;
            }
            Column(INDIRECT_COSTCaption_Control1100010Lbl; INDIRECT_COSTCaption_Control1100010Lbl)
            {
                //SourceExpr=INDIRECT_COSTCaption_Control1100010Lbl;
            }
            Column(anticipated_spendingsCaption_Control1100011Lbl; anticipated_spendingsCaption_Control1100011Lbl)
            {
                //SourceExpr=anticipated_spendingsCaption_Control1100011Lbl;
            }
            Column(current_expensesCaption_Control1100012Lbl; current_expensesCaption_Control1100012Lbl)
            {
                //SourceExpr=current_expensesCaption_Control1100012Lbl;
            }
            Column(immobilized_amortizationCaption_Control1100013Lbl; immobilized_amortizationCaption_Control1100013Lbl)
            {
                //SourceExpr=immobilized_amortizationCaption_Control1100013Lbl;
            }
            Column(deferred_expensesCaption_Control1100014Lbl; deferred_expensesCaption_Control1100014Lbl)
            {
                //SourceExpr=deferred_expensesCaption_Control1100014Lbl;
            }
            Column(INDIRECT_TOTAL_COSTOCaption_Control1100015Lbl; INDIRECT_TOTAL_COSTOCaption_Control1100015Lbl)
            {
                //SourceExpr=INDIRECT_TOTAL_COSTOCaption_Control1100015Lbl;
            }
            Column(FINANCIAL_LOANSCaption_Control1100016Lbl; FINANCIAL_LOANSCaption_Control1100016Lbl)
            {
                //SourceExpr=FINANCIAL_LOANSCaption_Control1100016Lbl;
            }
            Column(INDIRECT_COSTCaption_Control1100017Lbl; INDIRECT_COSTCaption_Control1100017Lbl)
            {
                //SourceExpr=INDIRECT_COSTCaption_Control1100017Lbl;
            }
            Column(TOTAL_INTERNAL_COSTCaption_Control1100032Lbl; TOTAL_INTERNAL_COSTCaption_Control1100032Lbl)
            {
                //SourceExpr=TOTAL_INTERNAL_COSTCaption_Control1100032Lbl;
            }
            Column(EXTERNAL_EXPENSESCaption_Control1100033Lbl; EXTERNAL_EXPENSESCaption_Control1100033Lbl)
            {
                //SourceExpr=EXTERNAL_EXPENSESCaption_Control1100033Lbl;
            }
            Column(PLANNEDCaption_Control1100054Lbl; PLANNEDCaption_Control1100054Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100054Lbl;
            }
            Column(REALCaption_Control1100055Lbl; REALCaption_Control1100055Lbl)
            {
                //SourceExpr=REALCaption_Control1100055Lbl;
            }
            Column(MONTHCaption_Control1100056Lbl; MONTHCaption_Control1100056Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100056Lbl;
            }
            Column(WORK_TOTAL_COSTCaption_Control1100063Lbl; WORK_TOTAL_COSTCaption_Control1100063Lbl)
            {
                //SourceExpr=WORK_TOTAL_COSTCaption_Control1100063Lbl;
            }
            Column(REALCaption_Control1100076Lbl; REALCaption_Control1100076Lbl)
            {
                //SourceExpr=REALCaption_Control1100076Lbl;
            }
            Column(ORIGINCaption_Control1100077Lbl; ORIGINCaption_Control1100077Lbl)
            {
                //SourceExpr=ORIGINCaption_Control1100077Lbl;
            }
            Column(RESULTCaption_Control1100079Lbl; RESULTCaption_Control1100079Lbl)
            {
                //SourceExpr=RESULTCaption_Control1100079Lbl;
            }
            Column(RESULTCaption_Control1100084Lbl; RESULTCaption_Control1100084Lbl)
            {
                //SourceExpr=RESULTCaption_Control1100084Lbl;
            }
            Column(OVER_O_E_Caption_Control1100085Lbl; OVER_O_E_Caption_Control1100085Lbl)
            {
                //SourceExpr=OVER_O_E_Caption_Control1100085Lbl;
            }
            Column(CERTIFICATE_AND_PAYMENTCaption_Control1100087Lbl; CERTIFICATE_AND_PAYMENTCaption_Control1100087Lbl)
            {
                //SourceExpr=CERTIFICATE_AND_PAYMENTCaption_Control1100087Lbl;
            }
            Column(MONTHCaption_Control1100091Lbl; MONTHCaption_Control1100091Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100091Lbl;
            }
            Column(REALCaption_Control1100092Lbl; REALCaption_Control1100092Lbl)
            {
                //SourceExpr=REALCaption_Control1100092Lbl;
            }
            Column(PLANNEDCaption_Control1100093Lbl; PLANNEDCaption_Control1100093Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100093Lbl;
            }
            Column(ORIGENCaption_Control1100094Lbl; ORIGENCaption_Control1100094Lbl)
            {
                //SourceExpr=ORIGENCaption_Control1100094Lbl;
            }
            Column(REALCaption_Control1100095Lbl; REALCaption_Control1100095Lbl)
            {
                //SourceExpr=REALCaption_Control1100095Lbl;
            }
            Column(EmptyStringCaption_Control1100096Lbl; EmptyStringCaption_Control1100096Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100096Lbl;
            }
            Column(EmptyStringCaption_Control1100097Lbl; EmptyStringCaption_Control1100097Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100097Lbl;
            }
            Column(TOTAL_CERTIFICATE_excluding_VATCaption_Control1100098Lbl; TOTAL_CERTIFICATE_excluding_VATCaption_Control1100098Lbl)
            {
                //SourceExpr=TOTAL_CERTIFICATE_excluding_VATCaption_Control1100098Lbl;
            }
            Column(MONTHCaption_Control1100099Lbl; MONTHCaption_Control1100099Lbl)
            {
                //SourceExpr=MONTHCaption_Control1100099Lbl;
            }
            Column(AGECaption_Control1100101Lbl; AGECaption_Control1100101Lbl)
            {
                //SourceExpr=AGECaption_Control1100101Lbl;
            }
            Column(FIRMSCaption_Control1100103Lbl; FIRMSCaption_Control1100103Lbl)
            {
                //SourceExpr=FIRMSCaption_Control1100103Lbl;
            }
            Column(BOSS_OF_WORKCaption_Control1100104Lbl; BOSS_OF_WORKCaption_Control1100104Lbl)
            {
                //SourceExpr=BOSS_OF_WORKCaption_Control1100104Lbl;
            }
            Column(DelegateCaption_Control1100105Lbl; DelegateCaption_Control1100105Lbl)
            {
                //SourceExpr=DelegateCaption_Control1100105Lbl;
            }
            Column(EmptyStringCaption_Control1100114Lbl; EmptyStringCaption_Control1100114Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100114Lbl;
            }
            Column(PLANIFICADOCaption_Control1100133Lbl; PLANIFICADOCaption_Control1100133Lbl)
            {
                //SourceExpr=PLANIFICADOCaption_Control1100133Lbl;
            }
            Column(PLANIFICADOCaption_Control1100134Lbl; PLANIFICADOCaption_Control1100134Lbl)
            {
                //SourceExpr=PLANIFICADOCaption_Control1100134Lbl;
            }
            Column(ORIGINCaption_Control1100135Lbl; ORIGINCaption_Control1100135Lbl)
            {
                //SourceExpr=ORIGINCaption_Control1100135Lbl;
            }
            Column(EmptyStringCaption_Control1100137Lbl; EmptyStringCaption_Control1100137Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100137Lbl;
            }
            Column(ESTIMATED_BY_MARGINSCaption_Control1100172Lbl; ESTIMATED_BY_MARGINSCaption_Control1100172Lbl)
            {
                //SourceExpr=ESTIMATED_BY_MARGINSCaption_Control1100172Lbl;
            }
            Column(TOTAL_ESTIMATESCaption_Control1100175Lbl; TOTAL_ESTIMATESCaption_Control1100175Lbl)
            {
                //SourceExpr=TOTAL_ESTIMATESCaption_Control1100175Lbl;
            }
            Column(TOTAL_OE_FROM_ESTIMATESCaption_Control1100177Lbl; TOTAL_OE_FROM_ESTIMATESCaption_Control1100177Lbl)
            {
                //SourceExpr=TOTAL_OE_FROM_ESTIMATESCaption_Control1100177Lbl;
            }
            Column(TOTAL_NET_ESTIMATESCaption_Control1100179Lbl; TOTAL_NET_ESTIMATESCaption_Control1100179Lbl)
            {
                //SourceExpr=TOTAL_NET_ESTIMATESCaption_Control1100179Lbl;
            }
            Column(TOTAL_NETWORK_EXECUTEDCaption_Control1100185Lbl; TOTAL_NETWORK_EXECUTEDCaption_Control1100185Lbl)
            {
                //SourceExpr=TOTAL_NETWORK_EXECUTEDCaption_Control1100185Lbl;
            }
            Column(AGECaption_Control1100251173Lbl; AGECaption_Control1100251173Lbl)
            {
                //SourceExpr=AGECaption_Control1100251173Lbl;
            }
            Column(PLANNEDCaption_Control1100251174Lbl; PLANNEDCaption_Control1100251174Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251174Lbl;
            }
            Column(REALCaption_Control1100251175Lbl; REALCaption_Control1100251175Lbl)
            {
                //SourceExpr=REALCaption_Control1100251175Lbl;
            }
            Column(AGECaption_Control1100251176Lbl; AGECaption_Control1100251176Lbl)
            {
                //SourceExpr=AGECaption_Control1100251176Lbl;
            }
            Column(PLANNEDCaption_Control1100251177Lbl; PLANNEDCaption_Control1100251177Lbl)
            {
                //SourceExpr=PLANNEDCaption_Control1100251177Lbl;
            }
            Column(REALCaption_Control1100251178Lbl; REALCaption_Control1100251178Lbl)
            {
                //SourceExpr=REALCaption_Control1100251178Lbl;
            }
            Column(EmptyStringCaption_Control1100251181Lbl; EmptyStringCaption_Control1100251181Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251181Lbl;
            }
            Column(EmptyStringCaption_Control1100251184Lbl; EmptyStringCaption_Control1100251184Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control1100251184Lbl;
            }
            Column(INTERNAL_TOTAL_COSTCaptionLbl; INTERNAL_TOTAL_COSTCaptionLbl)
            {
                //SourceExpr=INTERNAL_TOTAL_COSTCaptionLbl;
            }
            Column(EXTERNAL_EXPENSESCaptionLbl; EXTERNAL_EXPENSESCaptionLbl)
            {
                //SourceExpr=EXTERNAL_EXPENSESCaptionLbl;
            }
            Column(TOTAL_WORK_COSTCaptionLbl; TOTAL_WORK_COSTCaptionLbl)
            {
                //SourceExpr=TOTAL_WORK_COSTCaptionLbl;
            }
            Column(ESTIMATIONS_FOR_RECORDSCaption_control1100173; ESTIMATIONS_FOR_RECORDSCaption_control1100173)
            {
                //SourceExpr=ESTIMATIONS_FOR_RECORDSCaption_control1100173;
            }
            Column(DIRECT_COSTCaption_control1100017; DIRECT_COSTCaption_control1100017)
            {
                //SourceExpr=DIRECT_COSTCaption_control1100017;
            }
            Column(PLANNEDCaption_control1100251226; PLANNEDCaption_control1100251226)
            {
                //SourceExpr=PLANNEDCaption_control1100251226;
            }
            Column(DIRECT_COSTCaptionLbl; DIRECT_COSTCaptionLbl)
            {
                //SourceExpr=DIRECT_COSTCaptionLbl;
            }
            Column(decCIAGE; decCIAGE)
            {
                //SourceExpr=decCIAGE;
            }
            Column(decCIPlannedAGE; decCIPlannedMonth)
            {
                //SourceExpr=decCIPlannedMonth;
            }
            Column(decCIOrigin; decCIOrigin)
            {
                //SourceExpr=decCIOrigin;
            }
            Column(decCIPlannedOrigin; decCIPlannedOrigin)
            {
                //SourceExpr=decCIPlannedOrigin;
            }
            Column(decCIPlannedMonth; decCIPlannedMonth)
            {
                //SourceExpr=decCIPlannedMonth;
            }
            Column(decCIMonth; decCIMonth)
            {
                //SourceExpr=decCIMonth ;
            }
            trigger OnPreDataItem();
            BEGIN
                LastFieldNo := FIELDNO("No.");

                IntAge := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 3);
                IntMonth := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 2);


                IF (IntAge = 0) OR (IntMonth = 0) THEN
                    ERROR(Text50000);

                dateSincefecha := DMY2DATE(1, IntMonth, IntAge);
                dateUntilfecha := CALCDATE('PM', dateSincefecha);
                dateStartAge := DMY2DATE(1, 1, IntAge);

                txtTypePlanned := 'Planificado sobre ppto';

                CurrReport.CREATETOTALS(decProductionMONTH, decProductionPlannedMONTH, decProductionORIGIN, decProductionPlannedORIGIN,
                                        decProductionAGE, decProductionPlannedAGE);
                CurrReport.CREATETOTALS(decProvMargMONTH, decProvMargPlannedMONTH, decProvMargORIGIN, decProvMargPlannedORIGIN,
                                        decProvMargAGE, decProvMargPlannedAGE);
                CurrReport.CREATETOTALS(decProvExpMONTH, decProvExpPlannedMONTH, decProvExpORIGIN, decProvExpPlannedORIGIN,
                                        decProvExpAGE, decProvExpPlannedAGE);
                CurrReport.CREATETOTALS(decOEProvExpMONTH, decOEProvExpPlannedMONTH, decOEProvExpORIGIN, decOEProvExpPlannedORIGIN,
                                        decOEProvExpAGE, decOEProvExpPlannedAGE);
                CurrReport.CREATETOTALS(decCDMonth, decCDPlannedMonth, decCDOrigin, decCDPlannedOrigin,
                                        decCDAGE, decCDPlannedAGE);
                CurrReport.CREATETOTALS(decAAMonth, decAAPlannedMonth, decAAOrigin, decAAPlannedOrigin,
                                        decAAAGE, decAAPlannedAGE);
                CurrReport.CREATETOTALS(decGCMONTH, decGCPlannedMONTH, decGCOrigin, decGCPlannedOrigin,
                                        decGCAGE, decGCPlannedAGE);
                CurrReport.CREATETOTALS(decAIMonth, decAIPlannedMonth, decAIOrigin, decAIPlannedOrigin,
                                        decAIAGE, decAIPlannedAGE);
                CurrReport.CREATETOTALS(decADMonth, decADPlannedMonth, decADOrigin, decADPlannedOrigin,
                                        decADAGE, decADPlannedAGE);
                CurrReport.CREATETOTALS(decCFMonth, decCFPlannedMonth, decCFOrigin, decCFPlannedOrigin,
                                        decCFAGE, decCFPlannedAGE);
                CurrReport.CREATETOTALS(decEXMonth, decEXPlannedMonth, decEXOrigin, decEXPlannedOrigin,
                                        decEXAGE, decEXPlannedAGE);
                CurrReport.CREATETOTALS(decResultMonth, decResultPlannedMonth, decResultOrigin, decResultPlannedOrigin,
                                        decResultAGE, decResultPlannedAge);
                CurrReport.CREATETOTALS(decTotalCertificated, decTotalCertificatedPlanned);
                CurrReport.CREATETOTALS(decProductionNormalRealMonth, decProductionNormalPlannedMonth, decProductionNormalRealOrigin,
                                        decProductioNormalPlannedOrigin, decProductionNormalRealAGE, decProductionNormalPlannedAGE);
                CurrReport.CREATETOTALS(decTotalCertificatedAGE, decTotalCertificatedMonth);

                CompanyInformation1.GET;
                CompanyInformation1.CALCFIELDS(Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF GETFILTER(Job."Budget Filter") <> '' THEN
                    codePptoCourse := GETFILTER(Job."Budget Filter")
                ELSE BEGIN
                    IF Job."Current Piecework Budget" <> '' THEN
                        codePptoCourse := Job."Current Piecework Budget"
                    ELSE
                        codePptoCourse := Job."Budget Filter";
                END;

                Job.SETRANGE("Posting Date Filter");
                WorkBudget.GET(Job."No.", codePptoCourse);
                Job.SETRANGE("Budget Filter", codePptoCourse);
                Job.CALCFIELDS("Production Budget Amount");
                decImppptoproducciontotal := Job."Production Budget Amount";
                FunIniVar;

                CabFileAPM.SETRANGE("Job No.", Job."No.");
                CabFileAPM.SETRANGE(CabFileAPM."Budget Date", 0D, dateUntilfecha);
                IF CabFileAPM.FINDSET THEN BEGIN
                    REPEAT
                        IF (CabFileAPM."Budget Date" >= dateSincefecha) AND
                           (CabFileAPM."Budget Date" <= dateUntilfecha) THEN BEGIN
                            ////decProvMargMONTH := decProvMargMONTH + CabFileAPM."Margins Provision";
                            ////decProvMargPlannedMONTH  := decProvMargPlannedMONTH + CabFileAPM."Margins Provision";
                        END;
                        IF (CabFileAPM."Budget Date" >= dateStartAge) AND
                           (CabFileAPM."Budget Date" <= dateUntilfecha) THEN BEGIN
                            ////decProvMargAGE := decProvMargAGE + CabFileAPM."Margins Provision";
                            ////decProvMargPlannedAGE  := decProvMargPlannedAGE + CabFileAPM."Margins Provision";
                        END;
                    ////decProvMargORIGIN := decProvMargORIGIN + CabFileAPM."Margins Provision";
                    ////decProvMargPlannedORIGIN := decProvMargPlannedORIGIN + CabFileAPM."Margins Provision";
                    UNTIL CabFileAPM.NEXT = 0;
                END ELSE BEGIN
                    decProvMargMONTH := 0;
                    decProvMargPlannedMONTH := 0;
                    decProvMargAGE := 0;
                    decProvMargPlannedAGE := 0;
                    decProvMargORIGIN := 0;
                    decProvMargPlannedORIGIN := 0;
                END;
                //Producci¢n Real y Planificada.
                Job.SETRANGE("Posting Date Filter", dateSincefecha, dateUntilfecha);
                Job.CALCFIELDS("Production Budget Amount", Job."Actual Production Amount", "Certification Amount");
                decProductionMONTH := Job."Actual Production Amount";
                decTotalCertificatedMonth := Job."Certification Amount";
                IF dateUntilfecha < WorkBudget."Budget Date" THEN
                    decProductionPlannedMONTH := 0
                ELSE
                    decProductionPlannedMONTH := Job."Production Budget Amount";

                Job.SETRANGE("Posting Date Filter", dateStartAge, dateUntilfecha);
                Job.CALCFIELDS("Actual Production Amount", "Production Budget Amount", Job."Production Budget Amount", "Certification Amount");
                decTotalCertificatedAGE := Job."Certification Amount";
                decProductionAGE := Job."Actual Production Amount";

                //-Q19933
                //Job.SETRANGE("Posting Date Filter",dateStartAge,dateUntilfecha);
                Job.SETRANGE("Posting Date Filter", dateStartAge, dateSincefecha - 1);
                Job.CALCFIELDS("Actual Production Amount");
                decProductionPlannedAGE := Job."Actual Production Amount" + decProductionPlannedMONTH;
                //+Q19933
                //Job.SETRANGE("Posting Date Filter",WorkBudget."Budget Date",dateUntilfecha);
                //Job.CALCFIELDS("Production Budget Amount");
                //decProductionPlannedAGE := Job."Production Budget Amount" + Job."Production Budget Amount";
                Job.SETRANGE("Posting Date Filter", 0D, dateUntilfecha);
                Job.CALCFIELDS("Actual Production Amount", "Production Budget Amount", "Certification Amount");
                decProductionORIGIN := Job."Actual Production Amount";
                //-Q19933
                Job.SETRANGE("Posting Date Filter", 0D, dateSincefecha - 1);
                Job.CALCFIELDS(Job."Actual Production Amount");
                //decProductionPlannedORIGIN := Job."Production Budget Amount";
                decProductionPlannedORIGIN := Job."Actual Production Amount" + decProductionPlannedMONTH;
                //+Q19933
                decTotalCertificated := Job."Certification Amount";
                decTotalCertificatedPlanned := decProductionPlannedORIGIN;

                //Para la produccion normal
                decProductionNormalRealMonth := decProductionMONTH;
                decProductionNormalPlannedMonth := decProductionPlannedMONTH;
                decProductionNormalRealAGE := decProductionAGE;
                decProductionNormalPlannedAGE := decProductionPlannedAGE;
                decProductionNormalRealOrigin := decProductionORIGIN;
                decProductioNormalPlannedOrigin := decProductionPlannedORIGIN;

                //Calculamos provisiones por expedientes
                //AML Q19133 31/05/23 De momento se anula.
                //{
                //                                  Records.RESET;
                //                                  Records.SETRANGE("Job No.",Job."No.");
                //                                  Records.SETFILTER("Record Type",'<>%1',Records."Record Type"::Contract);
                //                                  IF Records.FINDSET THEN
                //                                    REPEAT
                //                                      recDataUO.RESET; b
                //                                      recDataUO.SETRANGE("Job No.",Job."No.");
                //                                      recDataUO.SETFILTER("No. Record",Records."No.");
                //                                      recDataUO.SETRANGE("Budget Filter",codePptoCourse);
                //                                      recDataUO.SETRANGE("Account Type",recDataUO."Account Type"::Unit);
                //                                      IF recDataUO.FINDSET(FALSE,FALSE) THEN
                //                                        REPEAT
                //                                          recDataUO.SETRANGE("Filter Date",dateSincefecha,dateUntilfecha);
                //                                          recDataUO.CALCFIELDS("Amount Production Budget","Amount Production Performed");
                //                                          IF Records."Record Status" <> Records."Record Status"::Approved THEN BEGIN 
                //                                            decProvExpMONTH :=decProvExpMONTH + recDataUO."Amount Production Performed";
                //                                            IF dateUntilfecha < WorkBudget."Budget Date" THEN
                //                                              decProvExpPlannedMONTH := decProvExpPlannedMONTH + 0
                //                                            ELSE
                //                                              decProvExpPlannedMONTH := decProvExpPlannedMONTH + recDataUO."Amount Production Budget";
                //
                //                                            decOEProvExpMONTH := decOEProvExpMONTH + recDataUO.AmountProductionAccepted;
                //                                            IF dateUntilfecha < WorkBudget."Budget Date" THEN
                //                                              decOEProvExpPlannedMONTH := decOEProvExpPlannedMONTH + 0
                //                                            ELSE
                //                                              decOEProvExpPlannedMONTH := decOEProvExpPlannedMONTH + ROUND((recDataUO."Amount Production Budget"*
                //                                                                            (recDataUO."% Processed Production"/100)),0.01);
                //
                //                                            recDataUO.SETRANGE("Filter Date",dateStartAge,dateUntilfecha);
                //                                            recDataUO.CALCFIELDS("Amount Production Budget","Amount Production Performed");
                //                                            decProvExpAGE := decProvExpORIGIN + recDataUO."Amount Production Performed";
                //                                            decOEProvExpAGE := decOEProvExpAGE + recDataUO.AmountProductionAccepted;
                //
                //                                            recDataUO.SETRANGE("Filter Date",dateStartAge,WorkBudget."Budget Date"-1);
                //                                            recDataUO.CALCFIELDS("Amount Production Performed");
                //                                            decProvExpPlannedAGE := decProvExpPlannedAGE + recDataUO."Amount Production Performed";
                //                                            decOEProvExpPlannedAGE := decOEProvExpPlannedAGE + ROUND((recDataUO."Amount Production Performed"*
                //                                                                             (recDataUO."% Processed Production"/100)),0.01);
                //                                            recDataUO.SETRANGE("Filter Date",WorkBudget."Budget Date",dateUntilfecha);
                //                                            recDataUO.CALCFIELDS("Amount Production Budget");
                //                                            decProvExpPlannedAGE := decProvExpPlannedAGE + recDataUO."Amount Production Budget";
                //                                            decOEProvExpPlannedAGE := decOEProvExpPlannedAGE + ROUND((recDataUO."Amount Production Budget"*
                //                                                                             (recDataUO."% Processed Production"/100)),0.01);
                //
                //                                            recDataUO.SETRANGE("Filter Date",0D,dateUntilfecha);
                //                                            recDataUO.CALCFIELDS("Amount Production Budget","Amount Production Performed");
                //                                            decProvExpORIGIN := decProvExpORIGIN + recDataUO."Amount Production Performed";
                //                                            decProvExpPlannedORIGIN := decProvExpPlannedORIGIN + recDataUO."Amount Production Budget";
                //
                //                                            decOEProvExpORIGIN := decOEProvExpORIGIN + recDataUO.AmountProductionAccepted;
                //                                            decOEProvExpPlannedORIGIN := decOEProvExpPlannedORIGIN + ROUND((recDataUO."Amount Production Budget"*
                //                                                                             (recDataUO."% Processed Production"/100)),0.01);
                //                                          END;
                //                                       UNTIL recDataUO.NEXT = 0;
                //                                    UNTIL Records.NEXT = 0;
                //                                  }

                //TypeCost 0: Costes Directos 1:Costes Indirectos
                //Subtype 0: Para Costes Directos 1:Anticipados 2:Gastos Corrientes 3:Amort.Inmovilizado 4:Gastos Diferidos 5: Cargas Financieras 6:Otros (Gastos Externos)no se usa.
                //Interno 0: Gastos internos (Directos siempre 0) 1: Gastos Externos
                //TypoCost,SubType,Desfecha,Hasfecha,Interno,Planificado,Importe
                //Costes Directos
                CalculoCoste(0, 7, dateSincefecha, dateUntilfecha, 3, FALSE, decCDMonth); //CD Real Mes
                CalculoCoste(0, 7, dateSincefecha, dateUntilfecha, 3, TRUE, decCDPlannedMonth); //CD Planificado Mes
                CalculoCoste(0, 7, dateStartAge, dateUntilfecha, 3, FALSE, decCDAGE); //CD Real A¤o
                CalculoCoste(0, 7, dateStartAge, dateUntilfecha, 3, TRUE, decCDPlannedAGE); //CD Planificado A¤o
                CalculoCoste(0, 7, 0D, dateUntilfecha, 3, FALSE, decCDOrigin); //CD Real Origen
                CalculoCoste(0, 7, 0D, dateUntilfecha, 3, TRUE, decCDPlannedOrigin); //CD Planificado Origen
                                                                                     //Costes Indirectos Se anula Y se esconde la fila en el layout
                                                                                     //CalculoCoste(1,0,dateSincefecha,dateUntilfecha,0,FALSE,decCIMonth); //Real Mes
                                                                                     //CalculoCoste(1,0,dateSincefecha,dateUntilfecha,0,TRUE,decCIPlannedMonth); //Planificado Mes
                                                                                     //CalculoCoste(1,0,dateStartAge,dateUntilfecha,0,FALSE,decCIAGE); //Real A¤o
                                                                                     //CalculoCoste(1,0,dateStartAge,dateUntilfecha,0,TRUE,decCIPlannedAGE); //Planificado A¤o
                                                                                     //CalculoCoste(1,0,0D,dateUntilfecha,0,FALSE,decCIOrigin); //Real Origen
                                                                                     //CalculoCoste(1,0,0D,dateUntilfecha,0,TRUE,decCIPlannedOrigin); //Planificado Origen
                                                                                     //LOS INDIRECTOS QUEDAN IGUAL QUE LOS REALES DE MOMENTO
                                                                                     //Gastos Anticipados
                CalculoCoste(1, 1, dateSincefecha, dateUntilfecha, 0, FALSE, decAAMonth); //Real Mes
                                                                                          //CalculoCoste(1,1,dateSincefecha,dateUntilfecha,0,TRUE,decAAPlannedMonth); //Planificado Mes
                CalculoCoste(1, 1, dateSincefecha, dateUntilfecha, 0, FALSE, decAAPlannedMonth); //Real Mes De momento gastos anticipados no se planifican
                CalculoCoste(1, 1, dateStartAge, dateUntilfecha, 0, FALSE, decAAAGE); //Real A¤o
                                                                                      //CalculoCoste(1,1,dateStartAge,dateUntilfecha,0,TRUE,decAAPlannedAGE); //Planificado A¤o
                CalculoCoste(1, 1, dateStartAge, dateUntilfecha, 0, FALSE, decAAPlannedAGE); //Real A¤o No se planifican
                CalculoCoste(1, 1, 0D, dateUntilfecha, 0, FALSE, decAAOrigin); //Real Origen
                                                                               //CalculoCoste(1,1,0D,dateUntilfecha,0,TRUE,decAAPlannedOrigin); //Planificado Origen
                CalculoCoste(1, 1, 0D, dateUntilfecha, 0, FALSE, decAAPlannedOrigin); //Real Origen
                                                                                      //Gasto Corriente
                CalculoCoste(1, 2, dateSincefecha, dateUntilfecha, 0, FALSE, decGCMONTH); //Real Mes
                CalculoCoste(1, 2, dateSincefecha, dateUntilfecha, 0, TRUE, decGCPlannedMONTH); //Planificado Mes
                CalculoCoste(1, 2, dateStartAge, dateUntilfecha, 0, FALSE, decGCAGE); //Real A¤o
                CalculoCoste(1, 2, dateStartAge, dateUntilfecha, 0, TRUE, decGCPlannedAGE); //Planificado A¤o
                CalculoCoste(1, 2, 0D, dateUntilfecha, 0, FALSE, decGCOrigin); //Real Origen
                CalculoCoste(1, 2, 0D, dateUntilfecha, 0, TRUE, decGCPlannedOrigin); //Planificado Origen
                                                                                     //Amortizacion Inmovilizado
                CalculoCoste(1, 3, dateSincefecha, dateUntilfecha, 0, FALSE, decAIMonth); //Real Mes
                                                                                          //CalculoCoste(1,3,dateSincefecha,dateUntilfecha,0,TRUE,decAIPlannedMonth); //Planificado Mes
                CalculoCoste(1, 3, dateSincefecha, dateUntilfecha, 0, FALSE, decAIPlannedMonth); //Real Mes
                CalculoCoste(1, 3, dateStartAge, dateUntilfecha, 0, FALSE, decAIAGE); //Real A¤o
                                                                                      //CalculoCoste(1,3,dateStartAge,dateUntilfecha,0,TRUE,decAIPlannedAGE); //Planificado A¤o
                CalculoCoste(1, 3, dateStartAge, dateUntilfecha, 0, FALSE, decAIPlannedAGE); //Real A¤o
                CalculoCoste(1, 3, 0D, dateUntilfecha, 0, FALSE, decAIOrigin); //Real Origen
                                                                               //CalculoCoste(1,3,0D,dateUntilfecha,0,TRUE,decAIPlannedOrigin); //Planificado Origen
                CalculoCoste(1, 3, 0D, dateUntilfecha, 0, FALSE, decAIPlannedOrigin); //Real Origen
                                                                                      //Gastos Diferidos
                CalculoCoste(1, 4, dateSincefecha, dateUntilfecha, 0, FALSE, decADMonth); //Real Mes
                                                                                          //CalculoCoste(1,4,dateSincefecha,dateUntilfecha,0,TRUE,decADPlannedMonth); //Planificado Mes
                CalculoCoste(1, 4, dateSincefecha, dateUntilfecha, 0, FALSE, decADPlannedMonth); //Real Mes
                CalculoCoste(1, 4, dateStartAge, dateUntilfecha, 0, FALSE, decADAGE); //Real A¤o
                                                                                      //CalculoCoste(1,4,dateStartAge,dateUntilfecha,0,TRUE,decADPlannedAGE); //Planificado A¤o
                CalculoCoste(1, 4, dateStartAge, dateUntilfecha, 0, FALSE, decADPlannedAGE); //Real A¤o
                CalculoCoste(1, 4, 0D, dateUntilfecha, 0, FALSE, decADOrigin); //Real Origen
                                                                               //CalculoCoste(1,4,0D,dateUntilfecha,0,TRUE,decADPlannedOrigin); //Planificado Origen
                CalculoCoste(1, 4, 0D, dateUntilfecha, 0, FALSE, decADPlannedOrigin); //Real Origen
                                                                                      //Cargas Financieras
                CalculoCoste(1, 5, dateSincefecha, dateUntilfecha, 0, FALSE, decCFMonth); //Real Mes
                                                                                          //CalculoCoste(1,5,dateSincefecha,dateUntilfecha,0,TRUE,decCFPlannedMonth); //Planificado Mes
                CalculoCoste(1, 5, dateSincefecha, dateUntilfecha, 0, FALSE, decCFPlannedMonth); //Real Mes
                CalculoCoste(1, 5, dateStartAge, dateUntilfecha, 0, FALSE, decCFAGE); //Real A¤o
                                                                                      //CalculoCoste(1,5,dateStartAge,dateUntilfecha,0,TRUE,decCFPlannedAGE); //Planificado A¤o
                CalculoCoste(1, 5, dateStartAge, dateUntilfecha, 0, FALSE, decCFPlannedAGE); //Real A¤o
                CalculoCoste(1, 5, 0D, dateUntilfecha, 0, FALSE, decCFOrigin); //Real Origen
                                                                               //CalculoCoste(1,5,0D,dateUntilfecha,0,TRUE,decCFPlannedOrigin); //Planificado Origen
                CalculoCoste(1, 5, 0D, dateUntilfecha, 0, FALSE, decCFPlannedOrigin); //Real Origen
                                                                                      //Gastos Externos Ponemos 7 para que no filtre
                CalculoCoste(1, 7, dateSincefecha, dateUntilfecha, 1, FALSE, decEXMonth); //Real Mes
                                                                                          //CalculoCoste(1,7,dateSincefecha,dateUntilfecha,1,TRUE,decCEXlannedMonth); //Planificado Mes
                CalculoCoste(1, 7, dateSincefecha, dateUntilfecha, 1, FALSE, decEXPlannedMonth); //Real Mes
                CalculoCoste(1, 7, dateStartAge, dateUntilfecha, 1, FALSE, decEXAGE); //Real A¤o
                                                                                      //CalculoCoste(1,7,dateStartAge,dateUntilfecha,1,TRUE,decEXPlannedAGE); //Planificado A¤o
                CalculoCoste(1, 7, dateStartAge, dateUntilfecha, 1, FALSE, decEXPlannedAGE); //Real A¤o
                CalculoCoste(1, 7, 0D, dateUntilfecha, 1, FALSE, decEXOrigin); //Real Origen
                                                                               //CalculoCoste(1,7,0D,dateUntilfecha,1,TRUE,decEXPlannedOrigin); //Planificado Origen
                CalculoCoste(1, 7, 0D, dateUntilfecha, 1, FALSE, decEXPlannedOrigin); //Real Origen

                decResultMonth := decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH)
                                   - (decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth + decEXMonth);

                decResultPlannedMonth := decProductionPlannedMONTH - (decProvMargPlannedMONTH + decProvExpPlannedMONTH -
                                               decOEProvExpPlannedMONTH) - (decCDPlannedMonth + decAAPlannedMonth +
                                               decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth +
                                               decCFPlannedMonth + decEXPlannedMonth);

                decResultAGE := decProductionNormalRealAGE - (decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE + decCFAGE + decEXAGE);

                decResultPlannedAge := decProductionNormalPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE +
                                               decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE +
                                               decCFPlannedAGE + decEXPlannedAGE);

                decResultOrigin := decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN)
                                   - (decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin + decCFOrigin + decEXOrigin);

                decResultPlannedOrigin := decProductionPlannedORIGIN - (decProvMargPlannedORIGIN + decProvExpPlannedORIGIN -
                                                  decOEProvExpPlannedORIGIN) - (decCDPlannedOrigin + decAAPlannedOrigin +
                                                  decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin +
                                                  decCFPlannedOrigin + decEXPlannedOrigin);


                IF (decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH)) <> 0 THEN
                    decPRMonth := ROUND(decResultMonth * 100 / (decProductionMONTH - (decProvMargMONTH + decProvExpMONTH - decOEProvExpMONTH)), 0.01)
                ELSE
                    decPRMonth := 0;

                IF decProductionPlannedMONTH - (decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH) <> 0 THEN
                    decPRPlannedMonth := ROUND(decResultPlannedMonth * 100 / (decProductionPlannedMONTH -
                           (decProvMargPlannedMONTH + decProvExpPlannedMONTH - decOEProvExpPlannedMONTH)),
                           0.01)
                ELSE
                    decPRPlannedMonth := 0;

                IF (decProductionAGE - (decProvMargAGE + decProvExpAGE - decOEProvExpAGE)) <> 0 THEN
                    decPRAGE := ROUND(decResultAGE * 100 / (decProductionAGE - (decProvMargAGE + decProvExpAGE - decOEProvExpAGE)), 0.01)
                ELSE
                    decPRAGE := 0;

                IF decProductionPlannedAGE - (decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE) <> 0 THEN
                    decPRPlannedAGE := ROUND(decResultPlannedAge * 100 / (decProductionPlannedAGE -
                           (decProvMargPlannedAGE + decProvExpPlannedAGE - decOEProvExpPlannedAGE)), 0.01)
                ELSE
                    decPRPlannedAGE := 0;

                IF (decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN)) <> 0 THEN
                    decPROrigin := ROUND(decResultOrigin * 100 /
                                        (decProductionORIGIN - (decProvMargORIGIN + decProvExpORIGIN - decOEProvExpORIGIN)), 0.01)
                ELSE
                    decPROrigin := 0;

                IF (decProductionPlannedORIGIN - (decProvMargPlannedORIGIN +
                   decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN)) <> 0 THEN
                    decPRPlannedOrigin := ROUND(decResultPlannedOrigin * 100 /
                                                     (decProductionPlannedORIGIN - (decProvMargPlannedORIGIN +
                                                     decProvExpPlannedORIGIN - decOEProvExpPlannedORIGIN)), 0.01)
                ELSE
                    decPRPlannedOrigin := 0;

                decTotalCertificated := decTotalCertificated;
                decTotalCertificatedMonth := decTotalCertificatedMonth;
                decTotalCertificatedAGE := decTotalCertificatedAGE;

                IF NOT Delegate.GET(Job."Person Responsible") THEN
                    CLEAR(Delegate);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {

            }

        }
    }

    labels
    {
    }

    var
        //       LastFieldNo@7001213 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001212 :
        FooterPrinted: Boolean;
        //       optTypeList@7001211 :
        optTypeList: Option "Proyecto","Empresa";
        //       CodeFilterDelegation@7001210 :
        CodeFilterDelegation: Code[20];
        //       codeFilterDirection@7001209 :
        codeFilterDirection: Code[20];
        //       IntAge@7001208 :
        IntAge: Integer;
        //       IntMonth@7001207 :
        IntMonth: Integer;
        //       dateSincefecha@7001206 :
        dateSincefecha: Date;
        //       dateUntilfecha@7001205 :
        dateUntilfecha: Date;
        //       dateStartAge@7001204 :
        dateStartAge: Date;
        //       decProductionMONTH@7001203 :
        decProductionMONTH: Decimal;
        //       decProductionPlannedMONTH@7001202 :
        decProductionPlannedMONTH: Decimal;
        //       decProductionAGE@7001201 :
        decProductionAGE: Decimal;
        //       decProductionPlannedAGE@7001200 :
        decProductionPlannedAGE: Decimal;
        //       decProductionORIGIN@7001199 :
        decProductionORIGIN: Decimal;
        //       decProductionPlannedORIGIN@7001198 :
        decProductionPlannedORIGIN: Decimal;
        //       decProvMargMONTH@7001197 :
        decProvMargMONTH: Decimal;
        //       decProvMargPlannedMONTH@7001196 :
        decProvMargPlannedMONTH: Decimal;
        //       decProvMargAGE@7001195 :
        decProvMargAGE: Decimal;
        //       decProvMargPlannedAGE@7001194 :
        decProvMargPlannedAGE: Decimal;
        //       decProvMargORIGIN@7001193 :
        decProvMargORIGIN: Decimal;
        //       decProvMargPlannedORIGIN@7001192 :
        decProvMargPlannedORIGIN: Decimal;
        //       decProvExpMONTH@7001191 :
        decProvExpMONTH: Decimal;
        //       decProvExpPlannedMONTH@7001190 :
        decProvExpPlannedMONTH: Decimal;
        //       decProvExpAGE@7001189 :
        decProvExpAGE: Decimal;
        //       decProvExpPlannedAGE@7001188 :
        decProvExpPlannedAGE: Decimal;
        //       decProvExpORIGIN@7001187 :
        decProvExpORIGIN: Decimal;
        //       decProvExpPlannedORIGIN@7001186 :
        decProvExpPlannedORIGIN: Decimal;
        //       decOEProvExpMONTH@7001185 :
        decOEProvExpMONTH: Decimal;
        //       decOEProvExpPlannedMONTH@7001184 :
        decOEProvExpPlannedMONTH: Decimal;
        //       decOEProvExpAGE@7001183 :
        decOEProvExpAGE: Decimal;
        //       decOEProvExpPlannedAGE@7001182 :
        decOEProvExpPlannedAGE: Decimal;
        //       decOEProvExpORIGIN@7001181 :
        decOEProvExpORIGIN: Decimal;
        //       decOEProvExpPlannedORIGIN@7001180 :
        decOEProvExpPlannedORIGIN: Decimal;
        //       recDataUO@7001179 :
        recDataUO: Record 7207386;
        //       decAAMonth@7001172 :
        decAAMonth: Decimal;
        //       decAAPlannedMonth@7001171 :
        decAAPlannedMonth: Decimal;
        //       decAAAGE@7001170 :
        decAAAGE: Decimal;
        //       decAAPlannedAGE@7001169 :
        decAAPlannedAGE: Decimal;
        //       decAAOrigin@7001168 :
        decAAOrigin: Decimal;
        //       decAAPlannedOrigin@7001167 :
        decAAPlannedOrigin: Decimal;
        //       decGCMONTH@7001166 :
        decGCMONTH: Decimal;
        //       decGCPlannedMONTH@7001165 :
        decGCPlannedMONTH: Decimal;
        //       decGCAGE@7001164 :
        decGCAGE: Decimal;
        //       decGCPlannedAGE@7001163 :
        decGCPlannedAGE: Decimal;
        //       decGCOrigin@7001162 :
        decGCOrigin: Decimal;
        //       decGCPlannedOrigin@7001161 :
        decGCPlannedOrigin: Decimal;
        //       decAIMonth@7001160 :
        decAIMonth: Decimal;
        //       decAIPlannedMonth@7001159 :
        decAIPlannedMonth: Decimal;
        //       decAIAGE@7001158 :
        decAIAGE: Decimal;
        //       decAIPlannedAGE@7001157 :
        decAIPlannedAGE: Decimal;
        //       decAIOrigin@7001156 :
        decAIOrigin: Decimal;
        //       decAIPlannedOrigin@7001155 :
        decAIPlannedOrigin: Decimal;
        //       decADMonth@7001154 :
        decADMonth: Decimal;
        //       decADPlannedMonth@7001153 :
        decADPlannedMonth: Decimal;
        //       decADAGE@7001152 :
        decADAGE: Decimal;
        //       decADPlannedAGE@7001151 :
        decADPlannedAGE: Decimal;
        //       decADOrigin@7001150 :
        decADOrigin: Decimal;
        //       decADPlannedOrigin@7001149 :
        decADPlannedOrigin: Decimal;
        //       decCFMonth@7001148 :
        decCFMonth: Decimal;
        //       decCFPlannedMonth@7001147 :
        decCFPlannedMonth: Decimal;
        //       decCFAGE@7001146 :
        decCFAGE: Decimal;
        //       decCFPlannedAGE@7001145 :
        decCFPlannedAGE: Decimal;
        //       decCFOrigin@7001144 :
        decCFOrigin: Decimal;
        //       decCFPlannedOrigin@7001143 :
        decCFPlannedOrigin: Decimal;
        //       decEXMonth@7001142 :
        decEXMonth: Decimal;
        //       decEXPlannedMonth@7001141 :
        decEXPlannedMonth: Decimal;
        //       decEXAGE@7001140 :
        decEXAGE: Decimal;
        //       decEXPlannedAGE@7001139 :
        decEXPlannedAGE: Decimal;
        //       decEXOrigin@7001138 :
        decEXOrigin: Decimal;
        //       decEXPlannedOrigin@7001137 :
        decEXPlannedOrigin: Decimal;
        //       decResultMonth@7001136 :
        decResultMonth: Decimal;
        //       decResultPlannedMonth@7001135 :
        decResultPlannedMonth: Decimal;
        //       decResultAGE@7001134 :
        decResultAGE: Decimal;
        //       decResultPlannedAge@7001133 :
        decResultPlannedAge: Decimal;
        //       decResultOrigin@7001132 :
        decResultOrigin: Decimal;
        //       decResultPlannedOrigin@7001131 :
        decResultPlannedOrigin: Decimal;
        //       decPRMonth@7001130 :
        decPRMonth: Decimal;
        //       decPRPlannedMonth@7001129 :
        decPRPlannedMonth: Decimal;
        //       decPRAGE@7001128 :
        decPRAGE: Decimal;
        //       decPRPlannedAGE@7001127 :
        decPRPlannedAGE: Decimal;
        //       decPROrigin@7001126 :
        decPROrigin: Decimal;
        //       decPRPlannedOrigin@7001125 :
        decPRPlannedOrigin: Decimal;
        //       decTotalCertificated@7001124 :
        decTotalCertificated: Decimal;
        //       decTotalCertificatedOE@7001123 :
        decTotalCertificatedOE: Decimal;
        //       decTotalCertificatedSuplidos@7001122 :
        decTotalCertificatedSuplidos: Decimal;
        //       decTotalCertificatedAcopios@7001121 :
        decTotalCertificatedAcopios: Decimal;
        //       decTotalCertificatedReview@7001120 :
        decTotalCertificatedReview: Decimal;
        //       decTotalCertificatedPlanned@7001119 :
        decTotalCertificatedPlanned: Decimal;
        //       decProductionNormalRealMonth@7001118 :
        decProductionNormalRealMonth: Decimal;
        //       decProductionNormalPlannedMonth@7001117 :
        decProductionNormalPlannedMonth: Decimal;
        //       decProductionNormalRealAGE@7001116 :
        decProductionNormalRealAGE: Decimal;
        //       decProductionNormalPlannedAGE@7001115 :
        decProductionNormalPlannedAGE: Decimal;
        //       decProductionNormalRealOrigin@7001114 :
        decProductionNormalRealOrigin: Decimal;
        //       decProductioNormalPlannedOrigin@7001113 :
        decProductioNormalPlannedOrigin: Decimal;
        //       decTotalCertificatedMonth@7001112 :
        decTotalCertificatedMonth: Decimal;
        //       decTotalCertificatedAGE@7001111 :
        decTotalCertificatedAGE: Decimal;
        //       Boss@7001110 :
        Boss: Record 156;
        //       Delegate@7001109 :
        Delegate: Record 156;
        //       Records@7001108 :
        Records: Record 7207393;
        //       CompanyInformation1@7001107 :
        CompanyInformation1: Record 79;
        //       decImppptoproducciontotal@7001106 :
        decImppptoproducciontotal: Decimal;
        //       CabFileAPM@7001105 :
        CabFileAPM: Record 7207403;
        //       decCostMonth@7001104 :
        decCostMonth: Decimal;
        //       codePptoCourse@7001101 :
        codePptoCourse: Code[20];
        //       WorkBudget@7001100 :
        WorkBudget: Record 7207407;
        //       Text50000@7001350 :
        Text50000: TextConst ENU = 'You must indicate year and month of the work summary', ESP = 'Debe indicicar A¤o y mes del resumen de obra';
        //       Text50001@7001349 :
        Text50001: TextConst ENU = 'Must indicate delegation to print', ESP = 'Debe indicar delegaci¢n a imprimir';
        //       Text50002@7001348 :
        Text50002: TextConst ENU = 'Must indicate address to be pinted', ESP = 'Debe indicar direcci¢n a imprimir';
        //       CurrReport_PAGENOCaptionLbl@7001347 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       PRODUCTIONCaptionLbl@7001346 :
        PRODUCTIONCaptionLbl: TextConst ENU = 'PRODUCTION', ESP = 'PRODUCCION';
        //       WORKCaptionLbl@7001345 :
        WORKCaptionLbl: TextConst ENU = 'WORK', ESP = 'OBRA';
        //       AGE_CaptionLbl@7001344 :
        AGE_CaptionLbl: TextConst ENU = 'AGE:', ESP = 'A¥O:';
        //       MONTH_CaptionLbl@7001343 :
        MONTH_CaptionLbl: TextConst ENU = 'MONTH:', ESP = 'MES:';
        //       DELEGATE_CaptionLbl@7001342 :
        DELEGATE_CaptionLbl: TextConst ENU = 'DELEGATE:', ESP = 'DELEGACIàN:';
        //       ADDRESS_CaptionLbl@7001341 :
        ADDRESS_CaptionLbl: TextConst ENU = 'ADDRESS:', ESP = 'DIRECCION:';
        //       MONTHCaptionLbl@7001340 :
        MONTHCaptionLbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       PLANNEDCaptionLbl@7001339 :
        PLANNEDCaptionLbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       AGECaptionLbl@7001338 :
        AGECaptionLbl: TextConst ENU = 'AGE', ESP = 'A¥O';
        //       REALCaptionLbl@7001337 :
        REALCaptionLbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDCaption_Control1100251338Lbl@7001336 :
        PLANNEDCaption_Control1100251338Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251340Lbl@7001335 :
        REALCaption_Control1100251340Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       ORIGINCaptionLbl@7001334 :
        ORIGINCaptionLbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       PLANNEDCaption_Control1100251009Lbl@7001333 :
        PLANNEDCaption_Control1100251009Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251021Lbl@7001332 :
        REALCaption_Control1100251021Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PRODUCTIONCaption_Control1100251327Lbl@7001331 :
        PRODUCTIONCaption_Control1100251327Lbl: TextConst ENU = 'PRODUCTION', ESP = 'PRODUCCION';
        //       ALLCOMPANYACaptionLbl@7001330 :
        ALLCOMPANYACaptionLbl: TextConst ENU = 'ALL COMPANY', ESP = 'TODA LA EMPRESA';
        //       MONTH_Caption_Control1100251336Lbl@7001329 :
        MONTH_Caption_Control1100251336Lbl: TextConst ENU = 'MONTH:', ESP = 'MES:';
        //       AGE_Caption_Control1100251341Lbl@7001328 :
        AGE_Caption_Control1100251341Lbl: TextConst ENU = 'AGE:', ESP = 'A¥O:';
        //       MONTHCaption_Control1100251354Lbl@7001327 :
        MONTHCaption_Control1100251354Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       REALCaption_Control1100251355Lbl@7001326 :
        REALCaption_Control1100251355Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDCaption_Control1100251356Lbl@7001325 :
        PLANNEDCaption_Control1100251356Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       ORIGiNCaption_Control1100251357Lbl@7001324 :
        ORIGiNCaption_Control1100251357Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       REALCaption_Control1100251358Lbl@7001323 :
        REALCaption_Control1100251358Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDDCaption_Control1100251359Lbl@7001322 :
        PLANNEDDCaption_Control1100251359Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       ORIGINCaption_Control1100251023Lbl@7001321 :
        ORIGINCaption_Control1100251023Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       PLANNEDDCaption_Control1100251027Lbl@7001320 :
        PLANNEDDCaption_Control1100251027Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251028Lbl@7001319 :
        REALCaption_Control1100251028Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       COSTCaptionLbl@7001318 :
        COSTCaptionLbl: TextConst ENU = 'COST', ESP = 'COSTE';
        //       GROSS_EXECUTED_WORKCaptionLbl@7001317 :
        GROSS_EXECUTED_WORKCaptionLbl: TextConst ENU = 'GROSS EXECUTED WORK', ESP = 'OBRA EJECUTADA BRUTA';
        //       INDIRECT_COSTCaptionLbl@7001316 :
        INDIRECT_COSTCaptionLbl: TextConst ENU = 'INDIRECT COST', ESP = 'COSTE INDIRECTO';
        //       anticipated_spendingssCaptionLbl@7001315 :
        anticipated_spendingssCaptionLbl: TextConst ENU = 'anticipated spendings', ESP = 'Gastos anticipados';
        //       Current_ExpensesCaptionLbl@7001314 :
        Current_ExpensesCaptionLbl: TextConst ENU = 'Current expenses', ESP = 'Gastos corrientes';
        //       immobilized_AmortizationCaptionLbl@7001313 :
        immobilized_AmortizationCaptionLbl: TextConst ENU = 'immobilized amortization', ESP = 'Amortizaci¢n inmovilizado';
        //       deferred_expensesCaptionLbl@7001312 :
        deferred_expensesCaptionLbl: TextConst ENU = 'deferred expenses', ESP = 'Gastos diferidos';
        //       INDIRECT_TOTAL_COSTCaptionLbl@7001311 :
        INDIRECT_TOTAL_COSTCaptionLbl: TextConst ENU = 'INDIRECT TOTAL COST', ESP = 'TOTAL COSTE INDIRECTO';
        //       FINANCIAL_LOANSCaptionLbl@7001310 :
        FINANCIAL_LOANSCaptionLbl: TextConst ENU = 'FINANCIAL LOANS', ESP = 'CARGAS FINANCIERAS';
        //       INDIRECT_COTSCaptionLbl@7001309 :
        INDIRECT_COTSCaptionLbl: TextConst ENU = 'INDIRECT COST', ESP = 'COSTE DIRECTO';
        //       RESULTSCaptionLbl@7001308 :
        RESULTSCaptionLbl: TextConst ENU = 'RESULTS', ESP = 'RESULTADO';
        //       RESULTSCaption_Control1100251138Lbl@7001307 :
        RESULTSCaption_Control1100251138Lbl: TextConst ENU = 'RESULTS', ESP = 'RESULTADO';
        //       OVER_O_E_CaptionLbl@7001306 :
        OVER_O_E_CaptionLbl: TextConst ENU = '% OVER O.E.', ESP = '% SOBRE O.E.';
        //       CERTIFICATE_AND_PAYMENTCaptionLbl@7001305 :
        CERTIFICATE_AND_PAYMENTCaptionLbl: TextConst ENU = 'CERTIFICATE and PAYMENT', ESP = 'CERTIFICACION Y COBRO';
        //       TOTAL_CERTIFICATE__sin_iva_CaptionLbl@7001304 :
        TOTAL_CERTIFICATE__sin_iva_CaptionLbl: TextConst ENU = '<TOTAL CERTIFICATE (WITHOUT VAT)>', ESP = 'TOTAL CERTIFICADO (sin iva)';
        //       MONTHCaption_Control1100251384Lbl@7001303 :
        MONTHCaption_Control1100251384Lbl: TextConst ENU = '<MONTH>', ESP = 'MES';
        //       REALCaption_Control1100251385Lbl@7001302 :
        REALCaption_Control1100251385Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDCaption_Control1100251386Lbl@7001301 :
        PLANNEDCaption_Control1100251386Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       ORIGINCaption_Control1100251387Lbl@7001300 :
        ORIGINCaption_Control1100251387Lbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       REALCaption_Control1100251388Lbl@7001299 :
        REALCaption_Control1100251388Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDDCaption_Control1100251389Lbl@7001298 :
        PLANNEDDCaption_Control1100251389Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       MONTHCaption_Control1100251394Lbl@7001297 :
        MONTHCaption_Control1100251394Lbl: TextConst ENU = '<MONTH>', ESP = 'MES';
        //       PLANNEDCaption_Control1100251152Lbl@7001296 :
        PLANNEDCaption_Control1100251152Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251221Lbl@7001295 :
        REALCaption_Control1100251221Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDCaption_Control1100251226Lbl@7001294 :
        PLANNEDCaption_Control1100251226Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251237Lbl@7001293 :
        REALCaption_Control1100251237Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       MONTHCaption_Control1100251239Lbl@7001292 :
        MONTHCaption_Control1100251239Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       AGECaption_Control1100251251Lbl@7001291 :
        AGECaption_Control1100251251Lbl: TextConst ENU = 'AGE', ESP = 'A¥O';
        //       AGECaption_Control1100251076Lbl@7001290 :
        AGECaption_Control1100251076Lbl: TextConst ENU = 'AGE', ESP = 'A¥O';
        //       ORIGINCaption_Control1100251208Lbl@7001289 :
        ORIGINCaption_Control1100251208Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       FIRMSCaptionLbl@7001288 :
        FIRMSCaptionLbl: TextConst ENU = '<FIRMS>', ESP = 'FIRMAS';
        //       Boss_of_workCaptionLbl@7001287 :
        Boss_of_workCaptionLbl: TextConst ENU = 'Boss Of Work', ESP = 'Jefe de obra';
        //       DelegateCaptionLbl@7001286 :
        DelegateCaptionLbl: TextConst ENU = '<Delegate>', ESP = 'Delegado';
        //       EmptyStringCaptionLbl@7001285 :
        EmptyStringCaptionLbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251407Lbl@7001284 :
        EmptyStringCaption_Control1100251407Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251408Lbl@7001283 :
        EmptyStringCaption_Control1100251408Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251409Lbl@7001282 :
        EmptyStringCaption_Control1100251409Lbl: TextConst ESP = '%';
        //       ESTIMATED_BY_MARGINSSCaptionLbl@7001281 :
        ESTIMATED_BY_MARGINSSCaptionLbl: TextConst ENU = 'ESTIMATED BY MARGINS', ESP = 'ESTIMACIONES POR MARGENES';
        //       ESTIMATES_FOR_RECORDSCaptionLbl@7001280 :
        ESTIMATES_FOR_RECORDSCaptionLbl: TextConst ENU = 'ESTIMATES FOR RECORDS', ESP = 'ESTIMACIONES POR EXPEDIENTES';
        //       TOTAL_ESTIMATESCaptionLbl@7001279 :
        TOTAL_ESTIMATESCaptionLbl: TextConst ENU = '<TOTAL ESTIMATES>', ESP = 'TOTAL ESTIMACIONES';
        //       TOTAL_OE_FROM_ESTIMATESCaptionLbl@7001278 :
        TOTAL_OE_FROM_ESTIMATESCaptionLbl: TextConst ENU = '<TOTAL OE FROM ESTIMATES>', ESP = 'TOTAL OE PROCEDENTE DE ESTIMACIONES';
        //       TOTAL_NET_ESTIMATESCaptionLbl@7001277 :
        TOTAL_NET_ESTIMATESCaptionLbl: TextConst ENU = '<TOTAL NET ESTIMATES>', ESP = 'TOTAL ESTIMACIONES NETAS';
        //       TOTAL_NETWORK_EXECUTEDCaptionLbl@7001276 :
        TOTAL_NETWORK_EXECUTEDCaptionLbl: TextConst ENU = '<TOTAL NETWORK EXECUTED>', ESP = 'TOTAL OBRA EJECUTADA NETA';
        //       ORIGINCaption_Control1100251029Lbl@7001275 :
        ORIGINCaption_Control1100251029Lbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       PLANNEDCaption_Control1100251031Lbl@7001274 :
        PLANNEDCaption_Control1100251031Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251033Lbl@7001273 :
        REALCaption_Control1100251033Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       AGECaption_Control1100251079Lbl@7001272 :
        AGECaption_Control1100251079Lbl: TextConst ENU = '<AGE>', ESP = 'A¥O';
        //       REALCaption_Control1100251129Lbl@7001271 :
        REALCaption_Control1100251129Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDCaption_Control1100251130Lbl@7001270 :
        PLANNEDCaption_Control1100251130Lbl: TextConst ENU = '<PLANNED>', ESP = 'PLANIFICADO';
        //       EmptyStringCaption_Control1100251144Lbl@7001269 :
        EmptyStringCaption_Control1100251144Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251147Lbl@7001268 :
        EmptyStringCaption_Control1100251147Lbl: TextConst ESP = '%';
        //       COSTCaption_Control1100019Lbl@7001267 :
        COSTCaption_Control1100019Lbl: TextConst ENU = 'COST', ESP = 'COSTE';
        //       GROSS_EXECUTED_WORKCaption_Control1100001Lbl@7001266 :
        GROSS_EXECUTED_WORKCaption_Control1100001Lbl: TextConst ENU = 'GROSS EXECUTED WORK', ESP = 'OBRA EJECUTADA BRUTA';
        //       INDIRECT_COSTCaption_Control1100010Lbl@7001265 :
        INDIRECT_COSTCaption_Control1100010Lbl: TextConst ENU = 'INDIRECT COST', ESP = 'COSTE INDIRECTO';
        //       anticipated_spendingsCaption_Control1100011Lbl@7001264 :
        anticipated_spendingsCaption_Control1100011Lbl: TextConst ENU = 'anticipated spendings', ESP = 'Gastos anticipados';
        //       current_expensesCaption_Control1100012Lbl@7001263 :
        current_expensesCaption_Control1100012Lbl: TextConst ENU = 'Current expenses', ESP = 'Gastos corrientes';
        //       immobilized_amortizationCaption_Control1100013Lbl@7001262 :
        immobilized_amortizationCaption_Control1100013Lbl: TextConst ENU = 'immobilized amortization', ESP = 'Amortizaci¢n inmovilizado';
        //       deferred_expensesCaption_Control1100014Lbl@7001261 :
        deferred_expensesCaption_Control1100014Lbl: TextConst ENU = 'deferred expenses', ESP = 'Gastos diferidos';
        //       INDIRECT_TOTAL_COSTOCaption_Control1100015Lbl@7001260 :
        INDIRECT_TOTAL_COSTOCaption_Control1100015Lbl: TextConst ENU = 'INDIRECT TOTAL COST', ESP = 'TOTAL COSTE INDIRECTO';
        //       FINANCIAL_LOANSCaption_Control1100016Lbl@7001259 :
        FINANCIAL_LOANSCaption_Control1100016Lbl: TextConst ENU = 'FINANCIAL LOANS', ESP = 'CARGAS FINANCIERAS';
        //       INDIRECT_COSTCaption_Control1100017Lbl@7001258 :
        INDIRECT_COSTCaption_Control1100017Lbl: TextConst ENU = 'INDIRECT COST', ESP = 'COSTE DIRECTO';
        //       TOTAL_INTERNAL_COSTCaption_Control1100032Lbl@7001257 :
        TOTAL_INTERNAL_COSTCaption_Control1100032Lbl: TextConst ENU = 'TOTAL INTERNAL COST', ESP = 'TOTAL COSTE INTERNO';
        //       EXTERNAL_EXPENSESCaption_Control1100033Lbl@7001256 :
        EXTERNAL_EXPENSESCaption_Control1100033Lbl: TextConst ENU = 'EXTERNAL EXPENSES', ESP = 'GASTOS EXTERNOS';
        //       PLANNEDCaption_Control1100054Lbl@7001255 :
        PLANNEDCaption_Control1100054Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100055Lbl@7001254 :
        REALCaption_Control1100055Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       MONTHCaption_Control1100056Lbl@7001253 :
        MONTHCaption_Control1100056Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       WORK_TOTAL_COSTCaption_Control1100063Lbl@7001252 :
        WORK_TOTAL_COSTCaption_Control1100063Lbl: TextConst ENU = 'WORK TOTAL COST', ESP = 'TOTAL COSTE OBRA';
        //       REALCaption_Control1100076Lbl@7001251 :
        REALCaption_Control1100076Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       ORIGINCaption_Control1100077Lbl@7001250 :
        ORIGINCaption_Control1100077Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       RESULTCaption_Control1100079Lbl@7001249 :
        RESULTCaption_Control1100079Lbl: TextConst ENU = 'RESULT', ESP = 'RESULTADO';
        //       RESULTCaption_Control1100084Lbl@7001248 :
        RESULTCaption_Control1100084Lbl: TextConst ENU = 'RESULT', ESP = 'RESULTADO';
        //       OVER_O_E_Caption_Control1100085Lbl@7001247 :
        OVER_O_E_Caption_Control1100085Lbl: TextConst ENU = '<% OVER O.E.>', ESP = '% SOBRE O.E.';
        //       CERTIFICATE_AND_PAYMENTCaption_Control1100087Lbl@7001246 :
        CERTIFICATE_AND_PAYMENTCaption_Control1100087Lbl: TextConst ENU = 'CERTIFICATE and PAYMENT', ESP = 'CERTIFICACION Y COBRO';
        //       MONTHCaption_Control1100091Lbl@7001245 :
        MONTHCaption_Control1100091Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       REALCaption_Control1100092Lbl@7001244 :
        REALCaption_Control1100092Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       PLANNEDCaption_Control1100093Lbl@7001243 :
        PLANNEDCaption_Control1100093Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       ORIGENCaption_Control1100094Lbl@7001242 :
        ORIGENCaption_Control1100094Lbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       REALCaption_Control1100095Lbl@7001241 :
        REALCaption_Control1100095Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       EmptyStringCaption_Control1100096Lbl@7001240 :
        EmptyStringCaption_Control1100096Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100097Lbl@7001239 :
        EmptyStringCaption_Control1100097Lbl: TextConst ESP = '%';
        //       TOTAL_CERTIFICATE_excluding_VATCaption_Control1100098Lbl@7001238 :
        TOTAL_CERTIFICATE_excluding_VATCaption_Control1100098Lbl: TextConst ENU = 'TOTAL CERTIFICATE (excluding VAT)', ESP = 'TOTAL CERTIFICADO (sin iva)';
        //       MONTHCaption_Control1100099Lbl@7001237 :
        MONTHCaption_Control1100099Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       AGECaption_Control1100101Lbl@7001236 :
        AGECaption_Control1100101Lbl: TextConst ENU = 'AGE', ESP = 'A¥O';
        //       FIRMSCaption_Control1100103Lbl@7001235 :
        FIRMSCaption_Control1100103Lbl: TextConst ENU = 'FIRMS', ESP = 'FIRMAS';
        //       BOSS_OF_WORKCaption_Control1100104Lbl@7001234 :
        BOSS_OF_WORKCaption_Control1100104Lbl: TextConst ENU = 'Boss Of Work', ESP = 'Jefe de obra';
        //       DelegateCaption_Control1100105Lbl@7001233 :
        DelegateCaption_Control1100105Lbl: TextConst ENU = 'delegate', ESP = 'Delegado';
        //       EmptyStringCaption_Control1100114Lbl@7001232 :
        EmptyStringCaption_Control1100114Lbl: TextConst ESP = '%';
        //       PLANIFICADOCaption_Control1100133Lbl@7001231 :
        PLANIFICADOCaption_Control1100133Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       PLANIFICADOCaption_Control1100134Lbl@7001230 :
        PLANIFICADOCaption_Control1100134Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       ORIGINCaption_Control1100135Lbl@7001229 :
        ORIGINCaption_Control1100135Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       EmptyStringCaption_Control1100137Lbl@7001228 :
        EmptyStringCaption_Control1100137Lbl: TextConst ESP = '%';
        //       ESTIMATED_BY_MARGINSCaption_Control1100172Lbl@7001227 :
        ESTIMATED_BY_MARGINSCaption_Control1100172Lbl: TextConst ENU = 'ESTIMATED BY MARGINS', ESP = 'ESTIMACIONES POR MARGENES';
        //       "ESTIMATE_ FOR_RECORDSCaption_Control1100173Lbl"@7001226 :
        "ESTIMATE_ FOR_RECORDSCaption_Control1100173Lbl": TextConst ENU = 'ESTIMATES FOR RECORDS', ESP = 'ESTIMACIONES POR EXPEDIENTES';
        //       TOTAL_ESTIMATESCaption_Control1100175Lbl@7001225 :
        TOTAL_ESTIMATESCaption_Control1100175Lbl: TextConst ENU = 'TOTAL ESTIMATES', ESP = 'TOTAL ESTIMACIONES';
        //       TOTAL_OE_FROM_ESTIMATESCaption_Control1100177Lbl@7001224 :
        TOTAL_OE_FROM_ESTIMATESCaption_Control1100177Lbl: TextConst ENU = '<TOTAL OE FROM ESTIMATES>', ESP = 'TOTAL OE PROCEDENTE DE ESTIMACIONES';
        //       TOTAL_NET_ESTIMATESCaption_Control1100179Lbl@7001223 :
        TOTAL_NET_ESTIMATESCaption_Control1100179Lbl: TextConst ENU = '<TOTAL NET ESTIMATES>', ESP = 'TOTAL ESTIMACIONES NETAS';
        //       TOTAL_NETWORK_EXECUTEDCaption_Control1100185Lbl@7001222 :
        TOTAL_NETWORK_EXECUTEDCaption_Control1100185Lbl: TextConst ENU = '<TOTAL NETWORK EXECUTED>', ESP = 'TOTAL OBRA EJECUTADA NETA';
        //       AGECaption_Control1100251173Lbl@7001221 :
        AGECaption_Control1100251173Lbl: TextConst ENU = 'AGE', ESP = 'A¥O';
        //       PLANNEDCaption_Control1100251174Lbl@7001220 :
        PLANNEDCaption_Control1100251174Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251175Lbl@7001219 :
        REALCaption_Control1100251175Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       AGECaption_Control1100251176Lbl@7001218 :
        AGECaption_Control1100251176Lbl: TextConst ENU = 'AGE', ESP = 'A¥O';
        //       PLANNEDCaption_Control1100251177Lbl@7001217 :
        PLANNEDCaption_Control1100251177Lbl: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       REALCaption_Control1100251178Lbl@7001216 :
        REALCaption_Control1100251178Lbl: TextConst ENU = 'REAL', ESP = 'REAL';
        //       EmptyStringCaption_Control1100251181Lbl@7001215 :
        EmptyStringCaption_Control1100251181Lbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control1100251184Lbl@7001214 :
        EmptyStringCaption_Control1100251184Lbl: TextConst ESP = '%';
        //       INTERNAL_TOTAL_COSTCaptionLbl@7001356 :
        INTERNAL_TOTAL_COSTCaptionLbl: TextConst ENU = 'INTERNAL TOTAL COST', ESP = 'TOTAL COSTE INTERNO';
        //       EXTERNAL_EXPENSESCaptionLbl@7001355 :
        EXTERNAL_EXPENSESCaptionLbl: TextConst ENU = 'EXTERNAL EXPENSES', ESP = 'GASTOS EXTERNOS';
        //       TOTAL_WORK_COSTCaptionLbl@7001354 :
        TOTAL_WORK_COSTCaptionLbl: TextConst ENU = ' TOTAL WORK COST', ESP = 'TOTAL COSTE OBRA';
        //       ESTIMATIONS_FOR_RECORDSCaption_control1100173@7001353 :
        ESTIMATIONS_FOR_RECORDSCaption_control1100173: TextConst ENU = 'ESTIMATIONS FOR RECORDS', ESP = 'ESTIMACIONES POR EXPEDIENTES';
        //       DIRECT_COSTCaption_control1100017@7001352 :
        DIRECT_COSTCaption_control1100017: TextConst ENU = 'DIRECT COST', ESP = 'COSTE DIRECTO';
        //       PLANNEDCaption_control1100251226@7001351 :
        PLANNEDCaption_control1100251226: TextConst ENU = 'PLANNED', ESP = 'PLANIFICADO';
        //       DIRECT_COSTCaptionLbl@7001357 :
        DIRECT_COSTCaptionLbl: TextConst ENU = 'DIRECTO COST', ESP = 'COSTE DIRECTO';
        //       decCIMonth@7001358 :
        decCIMonth: Decimal;
        //       decCIPlannedMonth@7001178 :
        decCIPlannedMonth: Decimal;
        //       decCIAGE@7001177 :
        decCIAGE: Decimal;
        //       decCIPlannedAGE@7001176 :
        decCIPlannedAGE: Decimal;
        //       decCIOrigin@7001175 :
        decCIOrigin: Decimal;
        //       decCIPlannedOrigin@7001174 :
        decCIPlannedOrigin: Decimal;
        //       decCDMonth@7001173 :
        decCDMonth: Decimal;
        //       decCDPlannedMonth@7001359 :
        decCDPlannedMonth: Decimal;
        //       decCDAGE@7001360 :
        decCDAGE: Decimal;
        //       decCDPlannedAGE@7001361 :
        decCDPlannedAGE: Decimal;
        //       decCDOrigin@7001362 :
        decCDOrigin: Decimal;
        //       decCDPlannedOrigin@7001363 :
        decCDPlannedOrigin: Decimal;
        //       txtTypePlanned@1000000000 :
        txtTypePlanned: Text;

    LOCAL procedure FunIniVar()
    begin
        decProductionMONTH := 0;
        decProductionPlannedMONTH := 0;
        decProductionAGE := 0;
        decProductionPlannedAGE := 0;
        decProductionORIGIN := 0;
        decProductionPlannedORIGIN := 0;

        decProductionNormalRealMonth := 0;
        decProductionNormalPlannedMonth := 0;
        decProductionNormalRealAGE := 0;
        decProductionNormalPlannedAGE := 0;
        decProductionNormalRealOrigin := 0;
        decProductioNormalPlannedOrigin := 0;

        decProvMargMONTH := 0;
        decProvMargPlannedMONTH := 0;
        decProvMargAGE := 0;
        decProvMargPlannedAGE := 0;
        decProvMargORIGIN := 0;
        decProvMargPlannedORIGIN := 0;

        decProvExpMONTH := 0;
        decProvExpPlannedMONTH := 0;
        decProvExpAGE := 0;
        decProvExpPlannedAGE := 0;
        decProvExpORIGIN := 0;
        decProvExpPlannedORIGIN := 0;

        decOEProvExpMONTH := 0;
        decOEProvExpPlannedMONTH := 0;
        decOEProvExpAGE := 0;
        decOEProvExpPlannedAGE := 0;
        decOEProvExpORIGIN := 0;
        decOEProvExpPlannedORIGIN := 0;

        decCDMonth := 0;
        decCDPlannedMonth := 0;
        decCDAGE := 0;
        decCDPlannedAGE := 0;
        decCDOrigin := 0;
        decCDPlannedOrigin := 0;

        decAAMonth := 0;
        decAAPlannedMonth := 0;
        decAAAGE := 0;
        decAAPlannedAGE := 0;
        decAAOrigin := 0;
        decAAPlannedOrigin := 0;

        decGCMONTH := 0;
        decGCPlannedMONTH := 0;
        decGCAGE := 0;
        decGCPlannedAGE := 0;
        decGCOrigin := 0;
        decGCPlannedOrigin := 0;

        decAIMonth := 0;
        decAIPlannedMonth := 0;
        decAIAGE := 0;
        decAIPlannedAGE := 0;
        decAIOrigin := 0;
        decAIPlannedOrigin := 0;

        decADMonth := 0;
        decADPlannedMonth := 0;
        decADAGE := 0;
        decADPlannedAGE := 0;
        decADOrigin := 0;
        decADPlannedOrigin := 0;

        decCFMonth := 0;
        decCFPlannedMonth := 0;
        decCFAGE := 0;
        decCFPlannedAGE := 0;
        decCFOrigin := 0;
        decCFPlannedOrigin := 0;

        decEXMonth := 0;
        decEXPlannedMonth := 0;
        decEXAGE := 0;
        decEXPlannedAGE := 0;
        decEXOrigin := 0;
        decEXPlannedOrigin := 0;

        decResultMonth := 0;
        decResultPlannedMonth := 0;
        decResultAGE := 0;
        decResultPlannedAge := 0;
        decResultOrigin := 0;
        decResultPlannedOrigin := 0;

        decPRMonth := 0;
        decPRPlannedMonth := 0;
        decPRAGE := 0;
        decPRPlannedAGE := 0;
        decPROrigin := 0;
        decPRPlannedOrigin := 0;

        decTotalCertificated := 0;
        decTotalCertificatedPlanned := 0;
        decTotalCertificatedMonth := 0;
        decTotalCertificatedAGE := 0;
    end;

    //     LOCAL procedure CalculoCosteBAK (TypeCost@1000000000 : Integer;Subtype@1000000001 : Integer;Desfecha@1000000002 : Date;Hasfecha@1000000003 : Date;Interno@1000000004 : Integer;Planificado@1000000006 : Boolean;var Importe@1000000005 :
    LOCAL procedure CalculoCosteBAK(TypeCost: Integer; Subtype: Integer; Desfecha: Date; Hasfecha: Date; Interno: Integer; Planificado: Boolean; var Importe: Decimal)
    begin
        //AML 31/05/23
        //TypoCost,SubType,Desfecha,Hasfecha,Interno,Planificado,Importe
        //TypeCost 0: Costes Directos 1:Costes Indirectos
        //Subtype 0: Para Costes Directos 1:Anticipados 2:Gastos Corrientes 3:Amort.Inmovilizado 4:Gastos Diferidos 5: Cargas Financieras 6:Otros (Gastos Externos)no se usa.
        //Interno 0: Gastos internos 1: Gastos Externos 3: Sin Filtro

        recDataUO.RESET;
        recDataUO.SETRANGE("Job No.", Job."No.");
        recDataUO.SETRANGE(Type, TypeCost);
        recDataUO.SETRANGE("Budget Filter", codePptoCourse);
        recDataUO.SETRANGE("Account Type", recDataUO."Account Type"::Unit);
        if Subtype < 7 then recDataUO.SETRANGE("Subtype Cost", Subtype);
        if Interno < 3 then recDataUO.SETRANGE("Type Unit Cost", Interno);
        if recDataUO.FINDSET(FALSE, FALSE) then
            repeat
                recDataUO.SETRANGE("Filter Date", Desfecha, Hasfecha);
                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (LCY)", recDataUO."Amount Cost Performed (LCY)");
                if Planificado then
                    Importe += recDataUO."Amount Cost Budget (LCY)"
                else
                    Importe += recDataUO."Amount Cost Performed (LCY)";

            until recDataUO.NEXT = 0;
    end;

    //     LOCAL procedure CalculoCoste (TypeCost@1000000000 : Integer;Subtype@1000000001 : Integer;Desfecha@1000000002 : Date;Hasfecha@1000000003 : Date;Interno@1000000004 : Integer;Planificado@1000000006 : Boolean;var Importe@1000000005 :
    LOCAL procedure CalculoCoste(TypeCost: Integer; Subtype: Integer; Desfecha: Date; Hasfecha: Date; Interno: Integer; Planificado: Boolean; var Importe: Decimal)
    begin
        //AML 31/05/23
        //TypoCost,SubType,Desfecha,Hasfecha,Interno,Planificado,Importe
        //TypeCost 0: Costes Directos 1:Costes Indirectos
        //Subtype 0: Para Costes Directos 1:Anticipados 2:Gastos Corrientes 3:Amort.Inmovilizado 4:Gastos Diferidos 5: Cargas Financieras 6:Otros (Gastos Externos)no se usa.
        //Interno 0: Gastos internos 1: Gastos Externos 3: Sin Filtro

        recDataUO.RESET;
        recDataUO.SETRANGE("Job No.", Job."No.");
        recDataUO.SETRANGE(Type, TypeCost);
        recDataUO.SETRANGE("Budget Filter", codePptoCourse);
        recDataUO.SETRANGE("Account Type", recDataUO."Account Type"::Unit);
        if Subtype < 7 then recDataUO.SETRANGE("Subtype Cost", Subtype);
        if Interno < 3 then recDataUO.SETRANGE("Type Unit Cost", Interno);
        //recDataUO.SETRANGE("Piecework Code",'CD.01.01');
        if recDataUO.FINDSET(FALSE, FALSE) then
            repeat
                //if recDataUO.Type = recDataUO.Type::Piecework then Importe += CalculoCosteRealCD(recDataUO,Desfecha,Hasfecha) else Importe += CalculoCosteRealCI(recDataUO,Desfecha,Hasfecha);
                if Planificado then begin
                    Importe += CalculoCostePlan(recDataUO, Desfecha, Hasfecha);
                    Importe += CalculoCosteRealCD(recDataUO, Desfecha, CALCDATE('PM', CALCDATE('-1M', Hasfecha)));
                end
                else
                    Importe += CalculoCosteRealCD(recDataUO, Desfecha, Hasfecha);

            until recDataUO.NEXT = 0;
    end;

    //     LOCAL procedure CalculoCostePlan (DataPieceworkForProduction@1100286000 : Record 7207386;Desfecha@1100286002 : Date;Hasfecha@1100286001 :
    LOCAL procedure CalculoCostePlan(DataPieceworkForProduction: Record 7207386; Desfecha: Date; Hasfecha: Date): Decimal;
    var
        //       ForecastDataAmountPiecework@1100286003 :
        ForecastDataAmountPiecework: Record 7207392;
        //       JobBudget@1100286004 :
        JobBudget: Record 7207407;
    begin
        JobBudget.SETCURRENTKEY("Job No.", "Budget Date");
        JobBudget.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        JobBudget.SETRANGE("Budget Date", 0D, Hasfecha);
        if not JobBudget.FINDLAST then exit;
        ForecastDataAmountPiecework.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        ForecastDataAmountPiecework.SETRANGE("Cod. Budget", JobBudget."Cod. Budget");
        ForecastDataAmountPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
        ForecastDataAmountPiecework.SETRANGE("Expected Date", Desfecha, Hasfecha);
        ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
        ForecastDataAmountPiecework.SETRANGE(Performed, FALSE);
        if ForecastDataAmountPiecework.FINDSET then
            repeat
                ForecastDataAmountPiecework."Entry No." := ForecastDataAmountPiecework."Entry No.";
            until ForecastDataAmountPiecework.NEXT = 0;
        ForecastDataAmountPiecework.CALCSUMS("Amount (LCY)");
        exit(ForecastDataAmountPiecework."Amount (LCY)");
    end;

    //     LOCAL procedure CalculoCosteRealCD (DataPieceworkForProduction@1100286002 : Record 7207386;Desfecha@1100286001 : Date;Hasfecha@1100286000 :
    LOCAL procedure CalculoCosteRealCD(DataPieceworkForProduction: Record 7207386; Desfecha: Date; Hasfecha: Date): Decimal;
    var
        //       JobLedgerEntry@1100286004 :
        JobLedgerEntry: Record 169;
    begin
        JobLedgerEntry.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        JobLedgerEntry.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
        JobLedgerEntry.SETRANGE("Posting Date", Desfecha, Hasfecha);
        JobLedgerEntry.CALCSUMS("Total Cost (LCY)");
        exit(JobLedgerEntry."Total Cost (LCY)");
    end;

    //     LOCAL procedure CalculoCosteRealCI (DataPieceworkForProduction@1100286004 : Record 7207386;Desfecha@1100286003 : Date;Hasfecha@1100286002 :
    LOCAL procedure CalculoCosteRealCI(DataPieceworkForProduction: Record 7207386; Desfecha: Date; Hasfecha: Date): Decimal;
    var
        //       ForecastDataAmountPiecework@1100286001 :
        ForecastDataAmountPiecework: Record 7207392;
        //       JobBudget@1100286000 :
        JobBudget: Record 7207407;
    begin
        JobBudget.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        JobBudget.SETRANGE("Budget Date", 0D, Hasfecha);
        if not JobBudget.FINDLAST then exit;
        ForecastDataAmountPiecework.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        ForecastDataAmountPiecework.SETRANGE("Cod. Budget", JobBudget."Cod. Budget");
        ForecastDataAmountPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
        ForecastDataAmountPiecework.SETRANGE("Expected Date", Desfecha, Hasfecha);
        ForecastDataAmountPiecework.SETRANGE(Performed, TRUE);
        ForecastDataAmountPiecework.CALCSUMS("Amount (LCY)");
        exit(ForecastDataAmountPiecework."Amount (LCY)");
    end;

    /*begin
    //{
//      Q19419 CSM 08/05/23.  Ya no existen los campos de Delegation y Direction en tabla Job.
//      Q19133 AML 30/05/23 Se ocultan las filas (poniendo la propiedad Visibilita Hide)
//            Estimaciones por Margen
//            Estimaciones por Expedientes
//            Total Estimaciones
//            Total OE Procedente de estimaciones
//            Total Estimaciones netas
//            Total Obra Ejecutada Neta
//            Se corrigen tambi‚n algunos datos que se calculan incorrectamente.
//    }
    end.
  */

}




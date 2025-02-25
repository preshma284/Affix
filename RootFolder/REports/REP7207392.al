report 7207392 "Monthy Jobs Summary"
{


    CaptionML = ESP = 'Resumen Mensual Obras';

    dataset
    {

        DataItem("Job"; "Job")
        {



            RequestFilterFields = "No.", "Posting Date Filter";
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
            Column(IntAge; IntAge)
            {
                //SourceExpr=IntAge;
            }
            Column(IntMonth; IntMonth)
            {
                //SourceExpr=IntMonth;
            }
            Column(recCompanyInformationPicture; recCompanyInformation.Picture)
            {
                //SourceExpr=recCompanyInformation.Picture;
            }
            Column(decTotalCertificatedMonth; decTotalCertificatedMonth)
            {
                //SourceExpr=decTotalCertificatedMonth;
            }
            Column(decTotalCertificatedAGE; decTotalCertificatedAGE)
            {
                //SourceExpr=decTotalCertificatedAGE;
            }
            Column(decProductionNormalPM_decCDPlannedM_decAAPlannedM_decGCPlannedM_decAIPlannedM_decADPlannedM_decCFPlannedM_decEXPlannedM; decProductionNormalPlannedMonth - (decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth))
            {
                //SourceExpr=decProductionNormalPlannedMonth - (decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth);
            }
            Column(decProductionNormalPlAGE_decCDPlAGE_decAAPlAGE_decGCPlAGE_decAIPlannedAGE_decADPlannedAGE_decCFPlAGE_decEXPlAGE; decProductionNormalPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE))
            {
                //SourceExpr=decProductionNormalPlannedAGE - ( decCDPlannedAGE + decAAPlannedAGE +  decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE);
            }
            Column(decResultMonth; decResultMonth)
            {
                //SourceExpr=decResultMonth;
            }
            Column(decResultAGE; decResultAGE)
            {
                //SourceExpr=decResultAGE;
            }
            Column(decCDPlannedM_decAAPlannedM_decGCPlannedM_decAIPlannedM_decADPlannedM_decCFPlannedMonth_decEXPlannedM; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth;
            }
            Column(decCDPlAGE_decAAPlAGE_decGCPlAGE_decAIPlAGE_decADPlAGE_decCFPlannedAGE_decEXPlAGE; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE + decAAPlannedAGE +  decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE;
            }
            Column(decMonthAmount; decMonthAmount)
            {
                //SourceExpr=decMonthAmount;
            }
            Column(decAnnualAmount; decAnnualAmount)
            {
                //SourceExpr=decAnnualAmount;
            }
            Column(decProductionNormalPlannedMonth; decProductionNormalPlannedMonth)
            {
                //SourceExpr=decProductionNormalPlannedMonth;
            }
            Column(decProductionNormalPlannedAGE; decProductionNormalPlannedAGE)
            {
                //SourceExpr=decProductionNormalPlannedAGE;
            }
            Column(decProductionNormalRealMonth; decProductionNormalRealMonth)
            {
                //SourceExpr=decProductionNormalRealMonth;
            }
            Column(decProductionNormalRealAGE; decProductionNormalRealAGE)
            {
                //SourceExpr=decProductionNormalRealAGE;
            }
            Column(decTotalCertificated; decTotalCertificated)
            {
                //SourceExpr=decTotalCertificated;
            }
            Column(decProductioNormalPlO_decCDPlO_decAAPlM_decGCPlO_decAIPlO_decADPlO_decCFPlO_decEXPlO; decProductioNormalPlannedOrigin - (decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin))
            {
                //SourceExpr=decProductioNormalPlannedOrigin - ( decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin +  decADPlannedOrigin +  decCFPlannedOrigin + decEXPlannedOrigin );
            }
            Column(decResultOrigin; decResultOrigin)
            {
                //SourceExpr=decResultOrigin;
            }
            Column(decCDPlO_decAAPlO_decGCPlannedOrigin_decAIPlannedOrigin_decADPlannedOrigin_decCFPlannedOrigin_decEXPlannedOrigin; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin)
            {
                //SourceExpr=[decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin +  decADPlannedOrigin +  decCFPlannedOrigin + decEXPlannedOrigin ];
            }
            Column(decOriginAmount; decOriginAmount)
            {
                //SourceExpr=decOriginAmount;
            }
            Column(decProductionNormalRealOrigin; decProductionNormalRealOrigin)
            {
                //SourceExpr=decProductionNormalRealOrigin;
            }
            Column(decProductioNormalPlannedOrigin; decProductioNormalPlannedOrigin)
            {
                //SourceExpr=decProductioNormalPlannedOrigin;
            }
            Column(decJobCourseOrigin; decJobCourseOrigin)
            {
                //SourceExpr=decJobCourseOrigin;
            }
            Column(JobDescription; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            Column(JobGlobalDimension1Code; Job."Global Dimension 1 Code")
            {
                //SourceExpr=Job."Global Dimension 1 Code";
            }
            Column(JobNo; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            Column(JobGlobalDimension1Code__Control1100251134; Job."Global Dimension 1 Code")
            {
                //SourceExpr=Job."Global Dimension 1 Code";
            }
            Column(decProductionNormalRealOrigin_Control1100251140; decProductionNormalRealOrigin)
            {
                //SourceExpr=decProductionNormalRealOrigin;
            }
            Column(decProductionNormalRealMonth_Control1100251142; decProductionNormalRealMonth)
            {
                //SourceExpr=decProductionNormalRealMonth;
            }
            Column(decProductionNormalRealAGE_Control1100251141; decProductionNormalRealAGE)
            {
                //SourceExpr=decProductionNormalRealAGE;
            }
            Column(decProductionPlannedORIGIN; decProductionPlannedORIGIN)
            {
                //SourceExpr=decProductionPlannedORIGIN;
            }
            Column(decProductionPlannedMONTH; decProductionPlannedMONTH)
            {
                //SourceExpr=decProductionPlannedMONTH;
            }
            Column(decProductionPlannedAGE; decProductionPlannedAGE)
            {
                //SourceExpr=decProductionPlannedAGE;
            }
            Column(decMonthAmount_Control1100251150; decMonthAmount)
            {
                //SourceExpr=decMonthAmount;
            }
            Column(decAnnualAmount_Control1100251149; decAnnualAmount)
            {
                //SourceExpr=decAnnualAmount;
            }
            Column(decOriginAmount_Control1100251148; decOriginAmount)
            {
                //SourceExpr=decOriginAmount;
            }
            Column(decCDPlO_decAAPlO_decGCPlO_decAIPlannedOrigin_decADPlannedOrigin_decCFPlannedOrigin_decEXPlannedOrigin_Control1100251151; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin)
            {
                //SourceExpr=[decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin +  decADPlannedOrigin +  decCFPlannedOrigin + decEXPlannedOrigin ];
            }
            Column(decCDPlAGE_decAAPlAGE_decGCPlannedAGE_decAIPlannedAGE_decADPlannedAGE_decCFPlannedAGE_decEXPlannedAGE_Control1100251153; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE + decAAPlannedAGE +  decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE;
            }
            Column(decCDPlMont_decAAPlM_decGCPlM_decAIPlM_decADPlM_decCFPlM_decEXPlannedMonth_Control1100251154; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth;
            }
            Column(decResultMonth_Control1100251158; decResultMonth)
            {
                //SourceExpr=decResultMonth;
            }
            Column(decResultAGE_Control1100251157; decResultAGE)
            {
                //SourceExpr=decResultAGE;
            }
            Column(decResultOrigin_Control1100251156; decResultOrigin)
            {
                //SourceExpr=decResultOrigin;
            }
            Column(decProductionPlOdecCDPlannedOdecAAPlannedOdecGCPlannedOdecAIPlannedOdecADPlannedOdecCFPlannedOrigindecEXPlannedOrigin; decProductionPlannedORIGIN - (decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin))
            {
                //SourceExpr=decProductionPlannedORIGIN - (decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin +  decEXPlannedOrigin);
            }
            Column(decProductionPlM_decCDPlM_decAAPlM_decGCPlM_decAIPlannedMonth_decADPlannedMonth_decCFPlannedMonth_decEXPlannedMonth; decProductionPlannedMONTH - (decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth))
            {
                //SourceExpr=decProductionPlannedMONTH - (decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth );
            }
            Column(decProductionPlAGEdecCDPlAGEdecAAPlAGEdecGCPlAGEdecAIPlAGEdecADPlAGEdecCFPlAGEdecEXPlAGE; decProductionPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE))
            {
                //SourceExpr=decProductionPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE +  decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE );
            }
            Column(decTotalCertificated_Control1100251164; decTotalCertificated)
            {
                //SourceExpr=decTotalCertificated;
            }
            Column(decTotalCertificatedMonth_Control1100251166; decTotalCertificatedMonth)
            {
                //SourceExpr=decTotalCertificatedMonth;
            }
            Column(decTotalCertificatedAGE_Control1100251165; decTotalCertificatedAGE)
            {
                //SourceExpr=decTotalCertificatedAGE;
            }
            Column(decJobCourseOrigin_Control1100251168; decJobCourseOrigin)
            {
                //SourceExpr=decJobCourseOrigin;
            }
            Column(decProductionNormalRealMonth_Control1100251095; decProductionNormalRealMonth)
            {
                //SourceExpr=decProductionNormalRealMonth;
            }
            Column(decProductionNormalRealAGE_Control1100251097; decProductionNormalRealAGE)
            {
                //SourceExpr=decProductionNormalRealAGE;
            }
            Column(decProductionNormalRealOrigin_Control1100251096; decProductionNormalRealOrigin)
            {
                //SourceExpr=decProductionNormalRealOrigin;
            }
            Column(decProductionPlannedORIGIN_Control1100251100; decProductionPlannedORIGIN)
            {
                //SourceExpr=decProductionPlannedORIGIN;
            }
            Column(decProductionPlannedMONTH_Control1100251101; decProductionPlannedMONTH)
            {
                //SourceExpr=decProductionPlannedMONTH;
            }
            Column(decProductionPlannedAGE_Control1100251102; decProductionPlannedAGE)
            {
                //SourceExpr=decProductionPlannedAGE;
            }
            Column(decMonthAmount_Control1100251105; decMonthAmount)
            {
                //SourceExpr=decMonthAmount;
            }
            Column(decAnnualAmount_Control1100251106; decAnnualAmount)
            {
                //SourceExpr=decAnnualAmount;
            }
            Column(decOriginAmount_Control1100251104; decOriginAmount)
            {
                //SourceExpr=decOriginAmount;
            }
            Column(decCDPlM_decAAPlM_decGCPlM_decAIPlM_decADPlM_decCFPlM_decEXPlannedMonth_Control1100251108; decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth)
            {
                //SourceExpr=decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth;
            }
            Column(decCDPlAGE_decAAPlAGE_decGCPlAGE_decAIPlAGE_decADPlAGE_decCFPlAGE_decEXPlannedAGE_Control1100251109; decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE)
            {
                //SourceExpr=decCDPlannedAGE + decAAPlannedAGE +  decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE;
            }
            Column(decCDPlOrigin_decAAPlOrigin_decGCPlOrigin_decAIPlOrigin_decADPlOrigin_decCFPlOrigin_decEXPlannedOrigin_Control1100251107; decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin)
            {
                //SourceExpr=[decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin +  decADPlannedOrigin +  decCFPlannedOrigin + decEXPlannedOrigin ];
            }
            Column(decResultMonth_Control1100251112; decResultMonth)
            {
                //SourceExpr=decResultMonth;
            }
            Column(decResultAGE_Control1100251114; decResultAGE)
            {
                //SourceExpr=decResultAGE;
            }
            Column(decResultOrigin_Control1100251113; decResultOrigin)
            {
                //SourceExpr=decResultOrigin;
            }
            Column(decProductionPlOdecCDPlOdecAAPlOdecGCPlOdecAIPlOdecADPlOdecCFPOdecEXPlO__Control1100251116; decProductionPlannedORIGIN - (decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin + decEXPlannedOrigin))
            {
                //SourceExpr=decProductionPlannedORIGIN - (decCDPlannedOrigin + decAAPlannedOrigin + decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin + decCFPlannedOrigin +  decEXPlannedOrigin);
            }
            Column(decProductionPlM_decCDPlM_decAAPlM_decGCPlMONTH_decAIPlM_decADPlM_decCFPlM_decEXPlM__Control1100251117; decProductionPlannedMONTH - (decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth))
            {
                //SourceExpr=decProductionPlannedMONTH - (decCDPlannedMonth + decAAPlannedMonth + decGCPlannedMONTH + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth );
            }
            Column(decProductionPlAGEdecCDPlAGEdecAAPlAGEdecGCPlAGEdecAIPlAGEdecADPlAGEdecCFPlannedAGEdecEXPlannedAGE__Control1100251118; decProductionPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE + decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE))
            {
                //SourceExpr=decProductionPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE +  decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE + decCFPlannedAGE + decEXPlannedAGE );
            }
            Column(decTotalCertificated_Control1100251121; decTotalCertificated)
            {
                //SourceExpr=decTotalCertificated;
            }
            Column(decTotalCertificatedMonthS_Control1100251122; decTotalCertificatedMonth)
            {
                //SourceExpr=decTotalCertificatedMonth;
            }
            Column(decTotalCertificatedAGE_Control1100251123; decTotalCertificatedAGE)
            {
                //SourceExpr=decTotalCertificatedAGE;
            }
            Column(decJobCourseOrigin_Control1100251125; decJobCourseOrigin)
            {
                //SourceExpr=decJobCourseOrigin;
            }
            Column(JobCaptionLbl; JobCaptionLbl)
            {
                //SourceExpr=JobCaptionLbl;
            }
            Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(CHARGESCaptionLbl; CHARGESCaptionLbl)
            {
                //SourceExpr=CHARGESCaptionLbl;
            }
            Column(CERTIFICATIONCaptionLbl; CERTIFICATIONCaptionLbl)
            {
                //SourceExpr=CERTIFICATIONCaptionLbl;
            }
            Column(TOTAL_COSTCaptionLbl; TOTAL_COSTCaptionLbl)
            {
                //SourceExpr=TOTAL_COSTCaptionLbl;
            }
            Column(JobCaption_Control1100251014; JobCaption_Control1100251014Lbl)
            {
                //SourceExpr=JobCaption_Control1100251014Lbl;
            }
            Column(JobCaption_Control1100251017; JobCaption_Control1100251017Lbl)
            {
                //SourceExpr=JobCaption_Control1100251017Lbl;
            }
            Column(JobCaption_Control1100251025; JobCaption_Control1100251025Lbl)
            {
                //SourceExpr=JobCaption_Control1100251025Lbl;
            }
            Column(JobCaption_Control1100251026; JobCaption_Control1100251026Lbl)
            {
                //SourceExpr=JobCaption_Control1100251026Lbl;
            }
            Column(JobCaption_Control1100251027; JobCaption_Control1100251027Lbl)
            {
                //SourceExpr=JobCaption_Control1100251027Lbl;
            }
            Column(JobCaption_Control1100251031; JobCaption_Control1100251031Lbl)
            {
                //SourceExpr=JobCaption_Control1100251031Lbl;
            }
            Column(JobCaption_Control1100251034; JobCaption_Control1100251034Lbl)
            {
                //SourceExpr=JobCaption_Control1100251034Lbl;
            }
            Column(JobCaption_Control1100251036; JobCaption_Control1100251036Lbl)
            {
                //SourceExpr=JobCaption_Control1100251036Lbl;
            }
            Column(JobCaption_Control1100251037; JobCaption_Control1100251037Lbl)
            {
                //SourceExpr=JobCaption_Control1100251037Lbl;
            }
            Column(JobCaption_Control1100251040; JobCaption_Control1100251040Lbl)
            {
                //SourceExpr=JobCaption_Control1100251040Lbl;
            }
            Column(JobCaption_Control1100251068; JobCaption_Control1100251068Lbl)
            {
                //SourceExpr=JobCaption_Control1100251068Lbl;
            }
            Column(JobCaption_Control1100251070; JobCaption_Control1100251070Lbl)
            {
                //SourceExpr=JobCaption_Control1100251070Lbl;
            }
            Column(JobCaption_Control1100251079; JobCaption_Control1100251079Lbl)
            {
                //SourceExpr=JobCaption_Control1100251079Lbl;
            }
            Column(JobCaption_Control1100251133; JobCaption_Control1100251133Lbl)
            {
                //SourceExpr=JobCaption_Control1100251133Lbl;
            }
            Column(JobCaption_Control1100251135; JobCaption_Control1100251135Lbl)
            {
                //SourceExpr=JobCaption_Control1100251135Lbl;
            }
            Column(JobCaption_Control1100251137; JobCaption_Control1100251137Lbl)
            {
                //SourceExpr=JobCaption_Control1100251137Lbl;
            }
            Column(JobCaption_Control1100251138; JobCaption_Control1100251138Lbl)
            {
                //SourceExpr=JobCaption_Control1100251138Lbl;
            }
            Column(JobCaption_Control1100251089; JobCaption_Control1100251089Lbl)
            {
                //SourceExpr=JobCaption_Control1100251089Lbl;
            }
            Column(JobCaption_Control1100251090; JobCaption_Control1100251090Lbl)
            {
                //SourceExpr=JobCaption_Control1100251090Lbl;
            }
            Column(JobCaption_Control1100251092; JobCaption_Control1100251092Lbl)
            {
                //SourceExpr=JobCaption_Control1100251092Lbl;
            }
            Column(JobCaption_Control1100251093; JobCaption_Control1100251093Lbl)
            {
                //SourceExpr=JobCaption_Control1100251093Lbl ;
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


                CurrReport.CREATETOTALS(decProductionNormalRealMonth,
                                        decProductionNormalRealAGE,
                                        decProductionNormalRealOrigin);
                CurrReport.CREATETOTALS(decProductionNormalPlannedMonth,
                                        decProductionNormalPlannedAGE,
                                        decProductioNormalPlannedOrigin);

                CurrReport.CREATETOTALS(decProductionMONTH, decProductionPlannedMONTH,
                                        decProductionAGE, decProductionPlannedAGE,
                                        decProductionORIGIN, decProductionPlannedORIGIN);
                CurrReport.CREATETOTALS(decProvExpMONTH, decProvExpPlannedMONTH,
                                        decProvExpAGE, decProvExpPlannedAGE,
                                        decProvExpORIGIN, decProvExpPlannedORIGIN);
                CurrReport.CREATETOTALS(decOEProvExpMONTH, decOEProvExpPlannedMONTH,
                                        decOEProvExpAGE, decOEProvExpPlannedAGE,
                                        decOEProvExpORIGIN, decOEProvExpPlannedORIGIN);
                CurrReport.CREATETOTALS(decResultMonth, decResultPlannedMonth,
                                        decResultAGE, decResultPlannedAge,
                                        decResultOrigin, decResultPlannedOrigin);
                CurrReport.CREATETOTALS(decTotalCertificated, decTotalCertificatedMonth, decTotalCertificatedAGE);
                CurrReport.CREATETOTALS(decCDMonth, decCDPlannedMonth,
                                        decCDAGE, decCDPlannedAGE,
                                        decCDOrigin, decCDPlannedOrigin);
                CurrReport.CREATETOTALS(decAAMonth, decAAPlannedMonth,
                                        decAAAGE, decAAPlannedAGE,
                                        decAAOrigin, decAAPlannedOrigin);
                CurrReport.CREATETOTALS(decGCMONTH, decGCPlannedMONTH,
                                        decGCAGE, decGCPlannedAGE,
                                        decGCOrigin, decGCPlannedOrigin);
                CurrReport.CREATETOTALS(decAIMonth, decAIPlannedMonth,
                                        decAIAGE, decAIPlannedAGE,
                                        decAIOrigin, decAIPlannedOrigin);
                CurrReport.CREATETOTALS(decADMonth, decADPlannedMonth,
                                        decADAGE, decADPlannedAGE,
                                        decADOrigin, decADPlannedOrigin);
                CurrReport.CREATETOTALS(decCFMonth, decCFPlannedMonth,
                                        decCFAGE, decCFPlannedAGE,
                                        decCFOrigin, decCFPlannedOrigin);
                CurrReport.CREATETOTALS(decEXMonth, decEXPlannedMonth,
                                        decEXAGE, decEXPlannedAGE,
                                        decEXOrigin, decEXPlannedOrigin);
                CurrReport.CREATETOTALS(decTotalcharged, decChargedPreviousMonth, decCobradoMes);
                CurrReport.CREATETOTALS(decChargedAGEPre, decChargedAGE);
                CurrReport.CREATETOTALS(decMonthAmount, decAnnualAmount, decOriginAmount);
                CurrReport.CREATETOTALS(decJobCourseOrigin);

                recCompanyInformation.GET;
                recCompanyInformation.CALCFIELDS(Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                FunInitVar;

                IF Job."Current Piecework Budget" <> '' THEN
                    codePptoCourse := Job."Current Piecework Budget"
                ELSE
                    codePptoCourse := Job."Initial Budget Piecework";

                IF codePptoCourse <> '' THEN
                    BudgetJob.GET(Job."No.", codePptoCourse)
                ELSE
                    CLEAR(BudgetJob);

                Job.SETRANGE("Budget Filter", codePptoCourse);

                IF Job."Job Type" = Job."Job Type"::Operative THEN BEGIN
                    Job.SETRANGE("Posting Date Filter", dateSincefecha, dateUntilfecha);
                    Job.CALCFIELDS("Production Budget Amount", Job."Actual Production Amount", "Certification Amount");
                    decProductionMONTH := Job."Actual Production Amount";
                    IF dateUntilfecha < BudgetJob."Budget Date" THEN
                        decProductionPlannedMONTH := 0
                    ELSE
                        decProductionPlannedMONTH := Job."Production Budget Amount";
                    decTotalCertificatedMonth := Job."Certification Amount";

                    Job.SETRANGE("Posting Date Filter", dateStartAge, dateUntilfecha);
                    Job.CALCFIELDS("Production Budget Amount", Job."Actual Production Amount", "Certification Amount");
                    decTotalCertificatedAGE := Job."Certification Amount";
                    decProductionAGE := Job."Actual Production Amount";
                    IF BudgetJob."Budget Date" <> 0D THEN
                        Job.SETRANGE("Posting Date Filter", dateStartAge, BudgetJob."Budget Date" - 1)
                    ELSE
                        Job.SETRANGE("Posting Date Filter", dateStartAge, 0D);

                    Job.CALCFIELDS(Job."Actual Production Amount");
                    decProductionPlannedAGE := Job."Actual Production Amount";
                    Job.SETRANGE("Posting Date Filter", BudgetJob."Budget Date", dateUntilfecha);
                    Job.CALCFIELDS("Production Budget Amount");
                    decProductionPlannedAGE := Job."Actual Production Amount" + Job."Production Budget Amount";

                    Job.SETRANGE("Posting Date Filter", 0D, dateUntilfecha);
                    Job.CALCFIELDS("Production Budget Amount", Job."Actual Production Amount", "Certification Amount");
                    decProductionORIGIN := Job."Actual Production Amount";
                    decProductionPlannedORIGIN := Job."Production Budget Amount";
                    decTotalCertificated := Job."Certification Amount";

                    //Para la produccion normal
                    decProductionNormalRealMonth := decProductionMONTH;
                    decProductionNormalPlannedMonth := decProductionPlannedMONTH;
                    decProductionNormalRealAGE := decProductionAGE;
                    decProductionNormalPlannedAGE := decProductionPlannedAGE;
                    decProductionNormalRealOrigin := decProductionORIGIN;
                    decProductioNormalPlannedOrigin := decProductionPlannedORIGIN;

                    recExpedientes.RESET;
                    recExpedientes.SETRANGE("Job No.", Job."No.");
                    recExpedientes.SETFILTER("Record Type", '<>%1', recExpedientes."Record Type"::Contract);
                    IF recExpedientes.FINDSET THEN
                        REPEAT
                            recDataUO.RESET;
                            recDataUO.SETRANGE("Job No.", Job."No.");
                            recDataUO.SETRANGE("No. Record", recExpedientes."No.");
                            recDataUO.SETRANGE("Budget Filter", Job.GETFILTER("Budget Filter"));
                            recDataUO.SETRANGE("Account Type", recDataUO."Account Type"::Unit);
                            IF recDataUO.FINDSET(FALSE, FALSE) THEN
                                REPEAT
                                    recDataUO.SETRANGE("Filter Date", dateSincefecha, dateUntilfecha);
                                    recDataUO.CALCFIELDS("Amount Production Budget", recDataUO."Amount Production Performed");
                                    decProvExpMONTH := decProvExpMONTH + recDataUO."Amount Production Performed";
                                    IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                        decProvExpPlannedMONTH := decProvExpPlannedMONTH + 0
                                    ELSE
                                        decProvExpPlannedMONTH := decProvExpPlannedMONTH + recDataUO."Amount Production Budget";

                                    decOEProvExpMONTH := decOEProvExpMONTH + recDataUO.AmountProductionAccepted;

                                    IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                        decOEProvExpPlannedMONTH := decOEProvExpPlannedMONTH + 0
                                    ELSE
                                        decOEProvExpPlannedMONTH := decOEProvExpPlannedMONTH + ROUND((recDataUO."Amount Production Budget" *
                                                                            (recDataUO.ProductionAdvancePercentage / 100)), 0.01);

                                    recDataUO.SETRANGE("Filter Date", dateStartAge, dateUntilfecha);
                                    recDataUO.CALCFIELDS("Amount Production Budget", "Amount Production Performed");
                                    decProvExpAGE := decProvExpAGE + recDataUO."Amount Production Performed";
                                    decOEProvExpAGE := decOEProvExpAGE + recDataUO.AmountProductionAccepted;

                                    IF BudgetJob."Budget Date" <> 0D THEN
                                        recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                    ELSE
                                        recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                    recDataUO.CALCFIELDS("Amount Production Performed");
                                    decProvExpPlannedAGE := decProvExpPlannedAGE + recDataUO."Amount Production Performed";
                                    decOEProvExpPlannedAGE := decOEProvExpPlannedAGE + ROUND((recDataUO."Amount Production Performed" *
                                                                  (recDataUO.ProductionAdvancePercentage / 100)), 0.01);
                                    recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                    recDataUO.CALCFIELDS("Amount Production Budget");
                                    decProvExpPlannedAGE := decProvExpPlannedAGE + recDataUO."Amount Production Budget";
                                    decOEProvExpPlannedAGE := decOEProvExpPlannedAGE + ROUND((recDataUO."Amount Production Budget" *
                                                                  (recDataUO.ProductionAdvancePercentage / 100)), 0.01);

                                    recDataUO.SETRANGE("Filter Date", 0D, dateUntilfecha);
                                    recDataUO.CALCFIELDS("Amount Production Budget", "Amount Production Performed");
                                    decProvExpORIGIN := decProvExpORIGIN + recDataUO."Amount Production Performed";
                                    decProvExpPlannedORIGIN := decProvExpPlannedORIGIN + recDataUO."Amount Production Budget";

                                    decOEProvExpORIGIN := decOEProvExpORIGIN + recDataUO.AmountProductionAccepted;
                                    decOEProvExpPlannedORIGIN := decOEProvExpPlannedORIGIN + ROUND((recDataUO."Amount Production Budget" *
                                                                        (recDataUO.ProductionAdvancePercentage / 100)), 0.01);
                                UNTIL recDataUO.NEXT = 0;
                        UNTIL recExpedientes.NEXT = 0;

                    recDataUO.RESET;
                    recDataUO.SETRANGE("Job No.", Job."No.");
                    recDataUO.SETRANGE(recDataUO.Type, recDataUO.Type::Piecework);
                    recDataUO.SETRANGE("Budget Filter", Job.GETFILTER("Budget Filter"));
                    recDataUO.SETRANGE("Account Type", recDataUO."Account Type"::Unit);
                    IF recDataUO.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            recDataUO.SETRANGE("Filter Date", dateSincefecha, dateUntilfecha);
                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                            decCDMonth := decCDMonth + recDataUO."Amount Cost Performed (JC)";
                            IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                decCDPlannedMonth := decCDPlannedMonth + 0
                            ELSE
                                decCDPlannedMonth := decCDPlannedMonth + recDataUO."Amount Cost Budget (JC)";

                            recDataUO.SETRANGE("Filter Date", dateStartAge, dateUntilfecha);
                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                            decCDAGE := decCDAGE + recDataUO."Amount Cost Performed (JC)";
                            IF BudgetJob."Budget Date" <> 0D THEN
                                recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                            ELSE
                                recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)");
                            decCDPlannedAGE := decCDPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                            recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                            decCDPlannedAGE := decCDPlannedAGE + recDataUO."Amount Cost Budget (JC)";

                            recDataUO.SETRANGE("Filter Date", 0D, dateUntilfecha);
                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                            decCDOrigin := decCDOrigin + recDataUO."Amount Cost Performed (JC)";
                            decCDPlannedOrigin := decCDPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                        UNTIL recDataUO.NEXT = 0;

                    recDataUO.RESET;
                    recDataUO.SETRANGE("Job No.", Job."No.");
                    recDataUO.SETRANGE(recDataUO.Type, recDataUO.Type::Piecework);
                    recDataUO.SETRANGE("Budget Filter", Job.GETFILTER("Budget Filter"));
                    recDataUO.SETRANGE("Account Type", recDataUO."Account Type"::Unit);
                    IF recDataUO.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            IF recDataUO."Type Unit Cost" = recDataUO."Type Unit Cost"::Internal THEN BEGIN
                                recDataUO.SETRANGE("Filter Date", dateSincefecha, dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                                CASE recDataUO."Subtype Cost" OF
                                    recDataUO."Subtype Cost"::"Deprec. Anticipated":
                                        BEGIN
                                            decAAMonth := decAAMonth + recDataUO."Amount Cost Performed (JC)";
                                            IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                                decAAPlannedMonth := decAAPlannedMonth + 0
                                            ELSE
                                                decAAPlannedMonth := decAAPlannedMonth + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Current Expenses":
                                        BEGIN
                                            decGCMONTH := decGCMONTH + recDataUO."Amount Cost Performed (JC)";
                                            IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                                decGCPlannedMONTH := decGCPlannedMONTH + 0
                                            ELSE
                                                decGCPlannedMONTH := decGCPlannedMONTH + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Deprec. Inmovilized":
                                        BEGIN
                                            decAIMonth := decAIMonth + recDataUO."Amount Cost Performed (JC)";
                                            IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                                decAIPlannedMonth := decAIPlannedMonth + 0
                                            ELSE
                                                decAIPlannedMonth := decAIPlannedMonth + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Deprec. Deferred":
                                        BEGIN
                                            decADMonth := decADMonth + recDataUO."Amount Cost Performed (JC)";
                                            IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                                decADPlannedMonth := decADPlannedMonth + 0
                                            ELSE
                                                decADPlannedMonth := decADPlannedMonth + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Financial Charges":
                                        BEGIN
                                            decCFMonth := decCFMonth + recDataUO."Amount Cost Performed (JC)";
                                            IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                                decCFPlannedMonth := decCFPlannedMonth + 0
                                            ELSE
                                                decCFPlannedMonth := decCFPlannedMonth + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                END;

                                recDataUO.SETRANGE("Filter Date", dateStartAge, dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                                CASE recDataUO."Subtype Cost" OF
                                    recDataUO."Subtype Cost"::"Deprec. Anticipated":
                                        BEGIN
                                            decAAAGE := decAAAGE + recDataUO."Amount Cost Performed (JC)";
                                            IF BudgetJob."Budget Date" <> 0D THEN
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                            ELSE
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)", recDataUO."Amount Cost Incurred W/C (LCY)");
                                            decAAPlannedAGE := decAAPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                                            recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                                            decAAPlannedAGE := decAAPlannedAGE + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Current Expenses":
                                        BEGIN
                                            decGCAGE := decGCAGE + recDataUO."Amount Cost Performed (JC)";
                                            IF BudgetJob."Budget Date" <> 0D THEN
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                            ELSE
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)", recDataUO."Amount Cost Incurred W/C (LCY)");
                                            decGCPlannedAGE := decGCPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                                            recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                                            decGCPlannedAGE := decGCPlannedAGE + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Deprec. Inmovilized":
                                        BEGIN
                                            decAIAGE := decAIAGE + recDataUO."Amount Cost Performed (JC)";
                                            IF BudgetJob."Budget Date" <> 0D THEN
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                            ELSE
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)", recDataUO."Amount Cost Incurred W/C (LCY)");
                                            decAIPlannedAGE := decAIPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                                            recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                                            decAIPlannedAGE := decAIPlannedAGE + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Deprec. Deferred":
                                        BEGIN
                                            decADAGE := decADAGE + recDataUO."Amount Cost Performed (JC)";
                                            IF BudgetJob."Budget Date" <> 0D THEN
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                            ELSE
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)", recDataUO."Amount Cost Incurred W/C (LCY)");
                                            decADPlannedAGE := decADPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                                            recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                                            decADPlannedAGE := decADPlannedAGE + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Financial Charges":
                                        BEGIN
                                            decCFAGE := decCFAGE + recDataUO."Amount Cost Performed (JC)";
                                            IF BudgetJob."Budget Date" <> 0D THEN
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                            ELSE
                                                recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)", recDataUO."Amount Cost Incurred W/C (LCY)");
                                            decCFPlannedAGE := decCFPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                                            recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                            recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                                            decCFPlannedAGE := decCFPlannedAGE + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                END;

                                recDataUO.SETRANGE("Filter Date", 0D, dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                                CASE recDataUO."Subtype Cost" OF
                                    recDataUO."Subtype Cost"::"Deprec. Anticipated":
                                        BEGIN
                                            decAAOrigin := decAAOrigin + recDataUO."Amount Cost Performed (JC)";
                                            decAAPlannedOrigin := decAAPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Current Expenses":
                                        BEGIN
                                            decGCOrigin := decGCOrigin + recDataUO."Amount Cost Performed (JC)";
                                            decGCPlannedOrigin := decGCPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Deprec. Inmovilized":
                                        BEGIN
                                            decAIOrigin := decAIOrigin + recDataUO."Amount Cost Performed (JC)";
                                            decAIPlannedOrigin := decAIPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Deprec. Deferred":
                                        BEGIN
                                            decADOrigin := decADOrigin + recDataUO."Amount Cost Performed (JC)";
                                            decADPlannedOrigin := decADPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                    recDataUO."Subtype Cost"::"Financial Charges":
                                        BEGIN
                                            decCFOrigin := decCFOrigin + recDataUO."Amount Cost Performed (JC)";
                                            decCFPlannedOrigin := decCFPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                                        END;
                                END;
                            END ELSE BEGIN
                                recDataUO.SETRANGE("Filter Date", dateSincefecha, dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                                decEXMonth := decEXMonth + recDataUO."Amount Cost Performed (JC)";
                                IF dateUntilfecha < BudgetJob."Budget Date" THEN
                                    decEXPlannedMonth := decEXPlannedMonth + 0
                                ELSE
                                    decEXPlannedMonth := decEXPlannedMonth + recDataUO."Amount Cost Budget (JC)";

                                recDataUO.SETRANGE("Filter Date", dateStartAge, dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                                decEXAGE := decEXAGE + recDataUO."Amount Cost Performed (JC)";

                                IF BudgetJob."Budget Date" <> 0D THEN
                                    recDataUO.SETRANGE("Filter Date", dateStartAge, BudgetJob."Budget Date" - 1)
                                ELSE
                                    recDataUO.SETRANGE("Filter Date", dateStartAge, 0D);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Performed (JC)", recDataUO."Amount Cost Incurred W/C (LCY)");
                                decEXPlannedAGE := decEXPlannedAGE + recDataUO."Amount Cost Performed (JC)";
                                recDataUO.SETRANGE("Filter Date", BudgetJob."Budget Date", dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)");
                                decEXPlannedAGE := decEXPlannedAGE + recDataUO."Amount Cost Budget (JC)";

                                recDataUO.SETRANGE("Filter Date", 0D, dateUntilfecha);
                                recDataUO.CALCFIELDS(recDataUO."Amount Cost Budget (JC)", recDataUO."Amount Cost Performed (JC)");
                                decEXOrigin := decEXOrigin + recDataUO."Amount Cost Performed (JC)";
                                decEXPlannedOrigin := decEXPlannedOrigin + recDataUO."Amount Cost Budget (JC)";
                            END;
                        UNTIL recDataUO.NEXT = 0;

                    decMonthAmount := decCDMonth + decAAMonth + decGCMONTH + decAIMonth + decADMonth + decCFMonth + decEXMonth;
                    decAnnualAmount := decCDAGE + decAAAGE + decGCAGE + decAIAGE + decADAGE + decCFAGE + decEXAGE;
                    decOriginAmount := decCDOrigin + decAAOrigin + decGCOrigin + decAIOrigin + decADOrigin + decCFOrigin + decEXOrigin;

                    decResultMonth := decProductionNormalRealMonth - decMonthAmount;

                    decResultPlannedMonth := decProductionNormalPlannedMonth - (decCDPlannedMonth + decAAPlannedMonth +
                  decGCPlannedMONTH
                                     + decAIPlannedMonth + decADPlannedMonth + decCFPlannedMonth + decEXPlannedMonth);

                    decResultAGE := decProductionNormalRealAGE - decAnnualAmount;

                    decResultPlannedAge := decProductionNormalPlannedAGE - (decCDPlannedAGE + decAAPlannedAGE +
                                                   decGCPlannedAGE + decAIPlannedAGE + decADPlannedAGE +
                                                   decCFPlannedAGE + decEXPlannedAGE);

                    decResultOrigin := decProductionNormalRealOrigin - decOriginAmount;

                    decResultPlannedOrigin := decProductioNormalPlannedOrigin - (decCDPlannedOrigin + decAAPlannedOrigin +
                                                      decGCPlannedOrigin + decAIPlannedOrigin + decADPlannedOrigin +
                                                      decCFPlannedOrigin + decEXPlannedOrigin);
                    decJobCourseOrigin := decProductionNormalRealOrigin - decTotalCertificated;

                END ELSE BEGIN //No son operativos
                    decProductionMONTH := 0;
                    decProductionAGE := 0;
                    decProductionORIGIN := 0;
                    decMonthAmount := 0;
                    decAnnualAmount := 0;
                    decOriginAmount := 0;

                    recMovPro2.SETCURRENTKEY("Job No.");
                    recMovPro2.SETRANGE("Job No.", Job."No.");
                    recMovPro2.SETRANGE(recMovPro2."Posting Date", dateSincefecha, dateUntilfecha);
                    IF recMovPro2.FINDFIRST THEN BEGIN
                        REPEAT
                            codeCA := '';
                            IF FunQB.GetPosDimensions(FunQB.ReturnDimCA) = 1 THEN
                                codeCA := recMovPro2."Global Dimension 1 Code";
                            IF FunQB.GetPosDimensions(FunQB.ReturnDimCA) = 2 THEN
                                codeCA := recMovPro2."Global Dimension 2 Code";
                            IF recDimensionValue.GET(FunQB.ReturnDimCA, codeCA) THEN BEGIN
                                IF recDimensionValue.Type = recDimensionValue.Type::Expenses THEN BEGIN
                                    decMonthAmount := decMonthAmount + recMovPro2."Total Cost";
                                    decTotalMonth := decTotalMonth + recMovPro2."Total Cost";
                                END ELSE BEGIN
                                    IF recMovPro2."Total Price" <> 0 THEN
                                        decProductionMONTH := decProductionMONTH - recMovPro2."Total Price"
                                    ELSE
                                        decProductionMONTH := decProductionMONTH - recMovPro2."Total Cost";
                                END;
                            END;
                        UNTIL recMovPro2.NEXT = 0;
                    END;

                    recMovPro2.SETRANGE("Job No.", Job."No.");
                    recMovPro2.SETRANGE(recMovPro2."Posting Date", dateStartAge, dateUntilfecha);
                    IF recMovPro2.FINDFIRST THEN BEGIN
                        REPEAT
                            codeCA := '';
                            IF FunQB.GetPosDimensions(FunQB.ReturnDimCA) = 1 THEN
                                codeCA := recMovPro2."Global Dimension 1 Code";
                            IF FunQB.GetPosDimensions(FunQB.ReturnDimCA) = 2 THEN
                                codeCA := recMovPro2."Global Dimension 2 Code";
                            IF recDimensionValue.GET(FunQB.ReturnDimCA, codeCA) THEN BEGIN
                                IF recDimensionValue.Type = recDimensionValue.Type::Expenses THEN BEGIN
                                    decAnnualAmount := decAnnualAmount + recMovPro2."Total Cost";
                                    decTotalAnnual := decTotalAnnual + recMovPro2."Total Cost";
                                END ELSE BEGIN
                                    IF recMovPro2."Total Price" <> 0 THEN
                                        decProductionAGE := decProductionAGE - recMovPro2."Total Price"
                                    ELSE
                                        decProductionAGE := decProductionAGE - recMovPro2."Total Cost"
                                END;
                            END;
                        UNTIL recMovPro2.NEXT = 0;
                    END;

                    recMovPro2.SETRANGE("Job No.", Job."No.");
                    recMovPro2.SETRANGE("Posting Date", 0D, dateUntilfecha);
                    IF recMovPro2.FINDFIRST THEN BEGIN
                        REPEAT
                            codeCA := '';
                            IF FunQB.GetPosDimensions(FunQB.ReturnDimCA) = 1 THEN
                                codeCA := recMovPro2."Global Dimension 1 Code";
                            IF FunQB.GetPosDimensions(FunQB.ReturnDimCA) = 2 THEN
                                codeCA := recMovPro2."Global Dimension 2 Code";
                            IF recDimensionValue.GET(FunQB.ReturnDimCA, codeCA) THEN BEGIN
                                IF recDimensionValue.Type = recDimensionValue.Type::Expenses THEN BEGIN
                                    decOriginAmount := decOriginAmount + recMovPro2."Total Cost";
                                    decTotalOrigin := decTotalOrigin + recMovPro2."Total Cost";
                                END ELSE BEGIN
                                    IF recMovPro2."Total Price" <> 0 THEN
                                        decProductionORIGIN := decProductionORIGIN - recMovPro2."Total Price"
                                    ELSE
                                        decProductionORIGIN := decProductionORIGIN - recMovPro2."Total Cost"
                                END;
                            END;
                        UNTIL recMovPro2.NEXT = 0;
                    END;

                    decProductionNormalRealOrigin := decProductionORIGIN;
                    decProductionNormalRealAGE := decProductionAGE;
                    decProductionNormalRealMonth := decProductionMONTH;

                    decResultMonth := decProductionMONTH - decMonthAmount;
                    decResultAGE := decProductionAGE - decAnnualAmount;
                    decResultOrigin := decProductionORIGIN - decOriginAmount;
                    decJobCourseOrigin := 0;
                END;
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
        //       dateSincefecha@7001106 :
        dateSincefecha: Date;
        //       dateUntilfecha@7001105 :
        dateUntilfecha: Date;
        //       decProductionMONTH@7001104 :
        decProductionMONTH: Decimal;
        //       decProductionPlannedMONTH@7001103 :
        decProductionPlannedMONTH: Decimal;
        //       decProductionORIGIN@7001102 :
        decProductionORIGIN: Decimal;
        //       decProductionPlannedORIGIN@7001101 :
        decProductionPlannedORIGIN: Decimal;
        //       recDataUO@7001100 :
        recDataUO: Record 7207386;
        //       decProductionNormalRealMonth@7001114 :
        decProductionNormalRealMonth: Decimal;
        //       decProductionNormalPlannedMonth@7001113 :
        decProductionNormalPlannedMonth: Decimal;
        //       decProductionNormalRealOrigin@7001112 :
        decProductionNormalRealOrigin: Decimal;
        //       decProductioNormalPlannedOrigin@7001111 :
        decProductioNormalPlannedOrigin: Decimal;
        //       IntAge@7001108 :
        IntAge: Integer;
        //       IntMonth@7001107 :
        IntMonth: Integer;
        //       dateStartAge@7001123 :
        dateStartAge: Date;
        //       decProvExpMONTH@7001122 :
        decProvExpMONTH: Decimal;
        //       decProvExpPlannedMONTH@7001121 :
        decProvExpPlannedMONTH: Decimal;
        //       decProvExpORIGIN@7001120 :
        decProvExpORIGIN: Decimal;
        //       decProvExpPlannedORIGIN@7001119 :
        decProvExpPlannedORIGIN: Decimal;
        //       decOEProvExpMONTH@7001118 :
        decOEProvExpMONTH: Decimal;
        //       decOEProvExpPlannedMONTH@7001117 :
        decOEProvExpPlannedMONTH: Decimal;
        //       decOEProvExpORIGIN@7001116 :
        decOEProvExpORIGIN: Decimal;
        //       decOEProvExpPlannedORIGIN@7001115 :
        decOEProvExpPlannedORIGIN: Decimal;
        //       decCDMonth@7001151 :
        decCDMonth: Decimal;
        //       decCDPlannedMonth@7001150 :
        decCDPlannedMonth: Decimal;
        //       decCDOrigin@7001149 :
        decCDOrigin: Decimal;
        //       decCDPlannedOrigin@7001148 :
        decCDPlannedOrigin: Decimal;
        //       decAAMonth@7001147 :
        decAAMonth: Decimal;
        //       decAAPlannedMonth@7001146 :
        decAAPlannedMonth: Decimal;
        //       decAAOrigin@7001145 :
        decAAOrigin: Decimal;
        //       decAAPlannedOrigin@7001144 :
        decAAPlannedOrigin: Decimal;
        //       decGCMONTH@7001143 :
        decGCMONTH: Decimal;
        //       decGCPlannedMONTH@7001142 :
        decGCPlannedMONTH: Decimal;
        //       decGCOrigin@7001141 :
        decGCOrigin: Decimal;
        //       decGCPlannedOrigin@7001140 :
        decGCPlannedOrigin: Decimal;
        //       decAIMonth@7001139 :
        decAIMonth: Decimal;
        //       decAIPlannedMonth@7001138 :
        decAIPlannedMonth: Decimal;
        //       decAIOrigin@7001137 :
        decAIOrigin: Decimal;
        //       decAIPlannedOrigin@7001136 :
        decAIPlannedOrigin: Decimal;
        //       decADMonth@7001135 :
        decADMonth: Decimal;
        //       decADPlannedMonth@7001134 :
        decADPlannedMonth: Decimal;
        //       decADOrigin@7001133 :
        decADOrigin: Decimal;
        //       decADPlannedOrigin@7001132 :
        decADPlannedOrigin: Decimal;
        //       decCFMonth@7001131 :
        decCFMonth: Decimal;
        //       decCFPlannedMonth@7001130 :
        decCFPlannedMonth: Decimal;
        //       decCFOrigin@7001129 :
        decCFOrigin: Decimal;
        //       decCFPlannedOrigin@7001128 :
        decCFPlannedOrigin: Decimal;
        //       decEXMonth@7001127 :
        decEXMonth: Decimal;
        //       decEXPlannedMonth@7001126 :
        decEXPlannedMonth: Decimal;
        //       decEXOrigin@7001125 :
        decEXOrigin: Decimal;
        //       decEXPlannedOrigin@7001124 :
        decEXPlannedOrigin: Decimal;
        //       decResultMonth@7001155 :
        decResultMonth: Decimal;
        //       decResultPlannedMonth@7001154 :
        decResultPlannedMonth: Decimal;
        //       decResultOrigin@7001153 :
        decResultOrigin: Decimal;
        //       decResultPlannedOrigin@7001152 :
        decResultPlannedOrigin: Decimal;
        //       decCertificatedRealMonth@7001169 :
        decCertificatedRealMonth: Decimal;
        //       decCertificatedPlannMonth@7001168 :
        decCertificatedPlannMonth: Decimal;
        //       decCertificatedRealOrigin@7001167 :
        decCertificatedRealOrigin: Decimal;
        //       decCertificatedPlannOrigin@7001166 :
        decCertificatedPlannOrigin: Decimal;
        //       dechargedRealMonth@7001165 :
        dechargedRealMonth: Decimal;
        //       decchargedPlannMonth@7001164 :
        decchargedPlannMonth: Decimal;
        //       decchargedRealOrigin@7001163 :
        decchargedRealOrigin: Decimal;
        //       decchargedPlannOrigin@7001162 :
        decchargedPlannOrigin: Decimal;
        //       decTotalCertificatedMonth@7001161 :
        decTotalCertificatedMonth: Decimal;
        //       decTotalcharged@7001159 :
        decTotalcharged: Decimal;
        //       decPendingPayment@7001158 :
        decPendingPayment: Decimal;
        //       decChargedPreviousMonth@7001157 :
        decChargedPreviousMonth: Decimal;
        //       decCobradoMes@7001156 :
        decCobradoMes: Decimal;
        //       recCompanyInformation@7001171 :
        recCompanyInformation: Record 79;
        //       recExpedientes@7001170 :
        recExpedientes: Record 7207393;
        //       codePptoCourse@7001172 :
        codePptoCourse: Code[20];
        //       decProductionAGE@7001174 :
        decProductionAGE: Decimal;
        //       decProductionPlannedAGE@7001173 :
        decProductionPlannedAGE: Decimal;
        //       decProductionPlannedSupAGE@7001176 :
        decProductionPlannedSupAGE: Decimal;
        //       decProductionSupAGE@7001175 :
        decProductionSupAGE: Decimal;
        //       decProductionNormalRealAGE@7001178 :
        decProductionNormalRealAGE: Decimal;
        //       decProductionNormalPlannedAGE@7001177 :
        decProductionNormalPlannedAGE: Decimal;
        //       decProvMargAGE@7001201 :
        decProvMargAGE: Decimal;
        //       decProvMargPlannedAGE@7001200 :
        decProvMargPlannedAGE: Decimal;
        //       decProvExpAGE@7001199 :
        decProvExpAGE: Decimal;
        //       decProvExpPlannedAGE@7001198 :
        decProvExpPlannedAGE: Decimal;
        //       decOEProvExpAGE@7001197 :
        decOEProvExpAGE: Decimal;
        //       decOEProvExpPlannedAGE@7001196 :
        decOEProvExpPlannedAGE: Decimal;
        //       decCDAGE@7001195 :
        decCDAGE: Decimal;
        //       decCDPlannedAGE@7001194 :
        decCDPlannedAGE: Decimal;
        //       decAAAGE@7001193 :
        decAAAGE: Decimal;
        //       decAAPlannedAGE@7001192 :
        decAAPlannedAGE: Decimal;
        //       decGCAGE@7001191 :
        decGCAGE: Decimal;
        //       decGCPlannedAGE@7001190 :
        decGCPlannedAGE: Decimal;
        //       decAIAGE@7001189 :
        decAIAGE: Decimal;
        //       decAIPlannedAGE@7001188 :
        decAIPlannedAGE: Decimal;
        //       decADAGE@7001187 :
        decADAGE: Decimal;
        //       decADPlannedAGE@7001186 :
        decADPlannedAGE: Decimal;
        //       decCFAGE@7001185 :
        decCFAGE: Decimal;
        //       decCFPlannedAGE@7001184 :
        decCFPlannedAGE: Decimal;
        //       decEXAGE@7001183 :
        decEXAGE: Decimal;
        //       decEXPlannedAGE@7001182 :
        decEXPlannedAGE: Decimal;
        //       decResultAGE@7001181 :
        decResultAGE: Decimal;
        //       decResultPlannedAge@7001180 :
        decResultPlannedAge: Decimal;
        //       decTotalCertificatedAGE@7001179 :
        decTotalCertificatedAGE: Decimal;
        //       decCertificatedRealAGE@7001207 :
        decCertificatedRealAGE: Decimal;
        //       decCertificatedPlannAGE@7001206 :
        decCertificatedPlannAGE: Decimal;
        //       decChargedRealAGE@7001205 :
        decChargedRealAGE: Decimal;
        //       decChargedPlannAGE@7001204 :
        decChargedPlannAGE: Decimal;
        //       decChargedAGEPre@7001203 :
        decChargedAGEPre: Decimal;
        //       decChargedAGE@7001202 :
        decChargedAGE: Decimal;
        //       decMonthAmount@7001219 :
        decMonthAmount: Decimal;
        //       decAnnualAmount@7001218 :
        decAnnualAmount: Decimal;
        //       decOriginAmount@7001217 :
        decOriginAmount: Decimal;
        //       BudgetJob@7001216 :
        BudgetJob: Record 7207407;
        //       FunQB@7001215 :
        FunQB: Codeunit 7207272;
        //       recMovPro2@7001214 :
        recMovPro2: Record 169;
        //       codeCA@7001213 :
        codeCA: Code[20];
        //       recDimensionValue@7001212 :
        recDimensionValue: Record 349;
        //       decTotalAnnual@7001210 :
        decTotalAnnual: Decimal;
        //       decTotalOrigin@7001209 :
        decTotalOrigin: Decimal;
        //       Text50000@7001245 :
        Text50000: TextConst ENU = 'You must indicate Year and month of the Job report', ESP = 'Debe indicicar A¤o y mes del informe de obra';
        //       JobCaptionLbl@7001244 :
        JobCaptionLbl: TextConst ENU = 'MONTHLY SUMMARY JOBs', ESP = '"RESUMEN MENSUAL OBRAS "';
        //       CurrReport_PAGENOCaptionLbl@7001243 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       CHARGESCaptionLbl@7001242 :
        CHARGESCaptionLbl: TextConst ENU = 'JOB OF COURSE', ESP = 'OBRA EN CURSO';
        //       JobCaption_Control1100251014Lbl@7001241 :
        JobCaption_Control1100251014Lbl: TextConst ENU = 'Job', ESP = 'Real';
        //       JobCaption_Control1100251017Lbl@7001240 :
        JobCaption_Control1100251017Lbl: TextConst ENU = 'Job', ESP = 'Real';
        //       CERTIFICATIONCaptionLbl@7001239 :
        CERTIFICATIONCaptionLbl: TextConst ENU = 'CERTIFICATION', ESP = 'CERTIFICACIàN';
        //       JobCaption_Control1100251025Lbl@7001238 :
        JobCaption_Control1100251025Lbl: TextConst ENU = 'RESULT', ESP = 'RESULTADO';
        //       JobCaption_Control1100251026Lbl@7001237 :
        JobCaption_Control1100251026Lbl: TextConst ENU = 'Planned', ESP = 'Planificado';
        //       JobCaption_Control1100251027Lbl@7001236 :
        JobCaption_Control1100251027Lbl: TextConst ENU = 'Job', ESP = 'Real';
        //       TOTAL_COSTCaptionLbl@7001235 :
        TOTAL_COSTCaptionLbl: TextConst ENU = 'TOTAL COST', ESP = 'COSTE TOTAL';
        //       JobCaption_Control1100251031Lbl@7001234 :
        JobCaption_Control1100251031Lbl: TextConst ENU = 'Planned', ESP = 'Planificado';
        //       JobCaption_Control1100251034Lbl@7001233 :
        JobCaption_Control1100251034Lbl: TextConst ENU = 'Job', ESP = 'Real';
        //       JobCaption_Control1100251036Lbl@7001232 :
        JobCaption_Control1100251036Lbl: TextConst ENU = 'TOTAL PRODUCTION', ESP = 'PRODUCCIàN TOTAL';
        //       JobCaption_Control1100251037Lbl@7001231 :
        JobCaption_Control1100251037Lbl: TextConst ENU = 'Planned', ESP = 'Planificado';
        //       JobCaption_Control1100251040Lbl@7001230 :
        JobCaption_Control1100251040Lbl: TextConst ENU = 'Job', ESP = 'Real';
        //       JobCaption_Control1100251068Lbl@7001229 :
        JobCaption_Control1100251068Lbl: TextConst ENU = 'Month', ESP = 'Mes';
        //       JobCaption_Control1100251070Lbl@7001228 :
        JobCaption_Control1100251070Lbl: TextConst ENU = 'Age', ESP = 'A¤o';
        //       JobCaption_Control1100251079Lbl@7001227 :
        JobCaption_Control1100251079Lbl: TextConst ENU = 'Origin', ESP = 'Origen';
        //       JobCaption_Control1100251133Lbl@7001226 :
        JobCaption_Control1100251133Lbl: TextConst ENU = 'TOTAL DELEGATION:', ESP = 'TOTAL DELEGACIàN:';
        //       JobCaption_Control1100251135Lbl@7001225 :
        JobCaption_Control1100251135Lbl: TextConst ENU = 'Origin', ESP = 'Origen';
        //       JobCaption_Control1100251137Lbl@7001224 :
        JobCaption_Control1100251137Lbl: TextConst ENU = 'Age', ESP = 'A¤o';
        //       JobCaption_Control1100251138Lbl@7001223 :
        JobCaption_Control1100251138Lbl: TextConst ENU = 'Month', ESP = 'Mes';
        //       JobCaption_Control1100251089Lbl@7001222 :
        JobCaption_Control1100251089Lbl: TextConst ENU = 'TOTAL:', ESP = 'TOTAL:';
        //       JobCaption_Control1100251090Lbl@7001221 :
        JobCaption_Control1100251090Lbl: TextConst ENU = 'Origin', ESP = 'Origen';
        //       JobCaption_Control1100251092Lbl@7001220 :
        JobCaption_Control1100251092Lbl: TextConst ENU = 'Month', ESP = 'Mes';
        //       JobCaption_Control1100251093Lbl@7001160 :
        JobCaption_Control1100251093Lbl: TextConst ENU = 'Age', ESP = 'A¤o';
        //       decTotalCertificated@7001246 :
        decTotalCertificated: Decimal;
        //       decJobCourseOrigin@7001208 :
        decJobCourseOrigin: Decimal;
        //       decTotalMonth@7001211 :
        decTotalMonth: Integer;

    LOCAL procedure FunInitVar()
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
        decGCMONTH := 0;
        decGCPlannedMONTH := 0;
        decAIMonth := 0;
        decAIPlannedMonth := 0;
        decADMonth := 0;
        decADPlannedMonth := 0;
        decCFMonth := 0;
        decCFPlannedMonth := 0;
        decAAAGE := 0;
        decAAPlannedAGE := 0;
        decGCAGE := 0;
        decGCPlannedAGE := 0;
        decAIAGE := 0;
        decAIPlannedAGE := 0;
        decADAGE := 0;
        decADPlannedAGE := 0;
        decCFAGE := 0;
        decCFPlannedAGE := 0;
        decAAOrigin := 0;
        decAAPlannedOrigin := 0;
        decGCOrigin := 0;
        decGCPlannedOrigin := 0;
        decAIOrigin := 0;
        decAIPlannedOrigin := 0;
        decADOrigin := 0;
        decADPlannedOrigin := 0;
        decCFOrigin := 0;
        decCFPlannedOrigin := 0;
        decEXMonth := 0;
        decEXPlannedMonth := 0;
        decEXOrigin := 0;
        decEXPlannedOrigin := 0;

        decResultMonth := 0;
        decResultPlannedMonth := 0;
        decResultAGE := 0;
        decResultPlannedAge := 0;
        decResultOrigin := 0;
        decResultPlannedOrigin := 0;

        decCertificatedRealMonth := 0;
        decCertificatedPlannMonth := 0;
        decCertificatedRealAGE := 0;
        decCertificatedPlannAGE := 0;
        decCertificatedRealOrigin := 0;
        decCertificatedPlannOrigin := 0;
        dechargedRealMonth := 0;
        decchargedPlannMonth := 0;
        decChargedRealAGE := 0;
        decChargedPlannAGE := 0;
        decchargedRealOrigin := 0;
        decchargedPlannOrigin := 0;

        decTotalCertificated := 0;

        decTotalcharged := 0;
    end;

    /*begin
    end.
  */

}




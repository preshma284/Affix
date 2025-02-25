report 7207358 "Report Hist. Records"
{


    CaptionML = ENU = 'Report Hist. Records', ESP = 'Informe Hist. Expedientes';

    dataset
    {

        DataItem("Records"; "Records")
        {

            DataItemTableView = SORTING("Job No.", "No.")
                                 ORDER(Ascending)
                                 WHERE("Finished" = CONST(false));


            RequestFilterFields = "Job No.", "No.", "Sale Type", "Record Type", "Record Status";
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
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
            Column(Job__Bill_to_Name_; Job."Bill-to Name")
            {
                //SourceExpr=Job."Bill-to Name";
            }
            Column(Job_Description; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            Column(Job__No__; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            Column(Job__Responsibility_Center_; Job."Responsibility Center")
            {
                //SourceExpr=Job."Responsibility Center";
            }
            Column(Control_Records__N__; "No.")
            {
                //SourceExpr="No.";
            }
            Column(Control_Records__Record_Type_; "Record Type")
            {
                //SourceExpr="Record Type";
            }
            Column(Control_Records__Shipment_To_Central_Date_; "Shipment To Central Date")
            {
                //SourceExpr="Shipment To Central Date";
            }
            Column(ContractAmount; ContractAmount)
            {
                //SourceExpr=ContractAmount;
            }
            Column(Control_Records__Entry_Record_Date_; "Entry Record Date")
            {
                //SourceExpr="Entry Record Date";
            }
            Column(Control_Records__Estimated_Amount_; "Estimated Amount")
            {
                //SourceExpr="Estimated Amount";
            }
            Column(Control_Records__Shipment_To_Central_Date__Control1100231033; "Shipment To Central Date")
            {
                //SourceExpr="Shipment To Central Date";
            }
            Column(Control_Records_CostAmount; Records.CostAmount(0))
            {
                //SourceExpr=Records.CostAmount(0);
            }
            Column(StartMonth; StartMonth)
            {
                //SourceExpr=StartMonth;
            }
            Column(StartYear; StartYear)
            {
                //SourceExpr=StartYear;
            }
            Column(Control_Records_ProcedureAmount; Records.ProcedureAmount(0))
            {
                //SourceExpr=Records.ProcedureAmount(0);
            }
            Column(Description1; Description1)
            {
                //SourceExpr=Description1;
            }
            Column(Description2; Description2)
            {
                //SourceExpr=Description2;
            }
            Column(Description3; Description3)
            {
                //SourceExpr=Description3;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(RECORD_TRACKINGCaption; RECORD_TRACKINGCaptionLbl)
            {
                //SourceExpr=RECORD_TRACKINGCaptionLbl;
            }
            Column(Customer_Caption; Customer_CaptionLbl)
            {
                //SourceExpr=Customer_CaptionLbl;
            }
            Column(Job_Title_Caption; Job_Title_CaptionLbl)
            {
                //SourceExpr=Job_Title_CaptionLbl;
            }
            Column(N__Job_Caption; N__Job_CaptionLbl)
            {
                //SourceExpr=N__Job_CaptionLbl;
            }
            Column(Delegation__Caption; Delegation__CaptionLbl)
            {
                //SourceExpr=Delegation__CaptionLbl;
            }
            Column(WITHOUT_PROCESSINGCaption; WITHOUT_PROCESSINGCaptionLbl)
            {
                //SourceExpr=WITHOUT_PROCESSINGCaptionLbl;
            }
            Column(N__RecordCaption; N__RecordCaptionLbl)
            {
                //SourceExpr=N__RecordCaptionLbl;
            }
            Column(Control_Records__Record_Type_Caption; FIELDCAPTION("Record Type"))
            {
                //SourceExpr=FIELDCAPTION("Record Type");
            }
            Column(Control_Records__Shipment_To_Central_Date_Caption; FIELDCAPTION("Shipment To Central Date"))
            {
                //SourceExpr=FIELDCAPTION("Shipment To Central Date");
            }
            Column(Contract_AmountCaption; Contract_AmountCaptionLbl)
            {
                //SourceExpr=Contract_AmountCaptionLbl;
            }
            Column(ESTIMATECaption; ESTIMATECaptionLbl)
            {
                //SourceExpr=ESTIMATECaptionLbl;
            }
            Column(POSIBLE_PROCEDURE_STARTCaption; POSIBLE_PROCEDURE_STARTCaptionLbl)
            {
                //SourceExpr=POSIBLE_PROCEDURE_STARTCaptionLbl;
            }
            Column(PRODUCTIONCaption; PRODUCTIONCaptionLbl)
            {
                //SourceExpr=PRODUCTIONCaptionLbl;
            }
            Column(AMOUNTCaption; AMOUNTCaptionLbl)
            {
                //SourceExpr=AMOUNTCaptionLbl;
            }
            Column(DATECaption; DATECaptionLbl)
            {
                //SourceExpr=DATECaptionLbl;
            }
            Column(AMOUNTCaption_Control1100231026; AMOUNTCaption_Control1100231026Lbl)
            {
                //SourceExpr=AMOUNTCaption_Control1100231026Lbl;
            }
            Column(DATECaption_Control1100231027; DATECaption_Control1100231027Lbl)
            {
                //SourceExpr=DATECaption_Control1100231027Lbl;
            }
            Column(YEARCaption; YEARCaptionLbl)
            {
                //SourceExpr=YEARCaptionLbl;
            }
            Column(MONTHCaption; MONTHCaptionLbl)
            {
                //SourceExpr=MONTHCaptionLbl;
            }
            Column(IN_PROCESSCaption; IN_PROCESSCaptionLbl)
            {
                //SourceExpr=IN_PROCESSCaptionLbl;
            }
            Column(SUBMITTED_AMOUNTCaption; SUBMITTED_AMOUNTCaptionLbl)
            {
                //SourceExpr=SUBMITTED_AMOUNTCaptionLbl;
            }
            Column(CONCEPTSCaption; CONCEPTSCaptionLbl)
            {
                //SourceExpr=CONCEPTSCaptionLbl;
            }
            Column(DATECaption_Control1100231060; DATECaption_Control1100231060Lbl)
            {
                //SourceExpr=DATECaption_Control1100231060Lbl;
            }
            Column(AMOUNTCaption_Control1100231061; AMOUNTCaption_Control1100231061Lbl)
            {
                //SourceExpr=AMOUNTCaption_Control1100231061Lbl;
            }
            Column(PROVINCIAL_SERV_ENTRYCaption; PROVINCIAL_SERV_ENTRYCaptionLbl)
            {
                //SourceExpr=PROVINCIAL_SERV_ENTRYCaptionLbl;
            }
            Column(PROVINCIAL_SERV_OUTPUTCaption; PROVINCIAL_SERV_OUTPUTCaptionLbl)
            {
                //SourceExpr=PROVINCIAL_SERV_OUTPUTCaptionLbl;
            }
            Column(CENTRAL_SERV_ENTRYCaption; CENTRAL_SERV_ENTRYCaptionLbl)
            {
                //SourceExpr=CENTRAL_SERV_ENTRYCaptionLbl;
            }
            Column(TECHNICAL_APPROVALCaption; TECHNICAL_APPROVALCaptionLbl)
            {
                //SourceExpr=TECHNICAL_APPROVALCaptionLbl;
            }
            Column(PROPOSAL_FINANCIAL_APPROVAL_Caption; PROPOSAL_FINANCIAL_APPROVAL_CaptionLbl)
            {
                //SourceExpr=PROPOSAL_FINANCIAL_APPROVAL_CaptionLbl;
            }
            Column(NOTECaption; NOTECaptionLbl)
            {
                //SourceExpr=NOTECaptionLbl;
            }
            Column(A_photocopy_of_the_corresponding_document_will_always_be_enclosed_Caption; A_photocopy_of_the_corresponding_document_will_always_be_enclosed_CaptionLbl)
            {
                //SourceExpr=A_photocopy_of_the_corresponding_document_will_always_be_enclosed_CaptionLbl;
            }
            Column(OBSERVATIONS_Caption; OBSERVATIONS_CaptionLbl)
            {
                //SourceExpr=OBSERVATIONS_CaptionLbl;
            }
            Column(Control_Records_Job_No_; "Job No.")
            {
                //SourceExpr="Job No.";
            }
            DataItem("FinishRecord"; "Records")
            {

                DataItemTableView = SORTING("Job No.", "No.")
                                 ORDER(Ascending);
                DataItemLink = "Job No." = FIELD("Job No.");
                Column(FinishRecord__N__; "No.")
                {
                    //SourceExpr="No.";
                }
                Column(FinishRecord__Start_Procedure_Date_; "Initial Procedure Date")
                {
                    //SourceExpr="Initial Procedure Date";
                }
                Column(FinishRecord_ProcedureAmount; FinishRecord.ProcedureAmount(0))
                {
                    //SourceExpr=FinishRecord.ProcedureAmount(0);
                }
                Column(ProcessAmount; ProcessAmount)
                {
                    //SourceExpr=ProcessAmount;
                }
                Column(FinishRecord__Finish_Record_Date_; "Finish Record Date")
                {
                    //SourceExpr="Finish Record Date";
                }
                Column(FinishRecord_AcceptedAmount; FinishRecord.AcceptedAmount(0))
                {
                    //SourceExpr=FinishRecord.AcceptedAmount(0);
                }
                Column(ApprovalAmount; ApprovalAmount)
                {
                    //SourceExpr=ApprovalAmount;
                }
                Column(ProcessAmount_ApprovalAmount; ProcessAmount - ApprovalAmount)
                {
                    //SourceExpr=ProcessAmount-ApprovalAmount;
                }
                Column(N__RECOCaption; N__RECOCaptionLbl)
                {
                    //SourceExpr=N__RECOCaptionLbl;
                }
                Column(HISTORIC_RECORDSCaption; HISTORIC_RECORDSCaptionLbl)
                {
                    //SourceExpr=HISTORIC_RECORDSCaptionLbl;
                }
                Column(APPROVEDCaption; APPROVEDCaptionLbl)
                {
                    //SourceExpr=APPROVEDCaptionLbl;
                }
                Column(TOTALSCaption; TOTALSCaptionLbl)
                {
                    //SourceExpr=TOTALSCaptionLbl;
                }
                Column(DATECaption_Control1100231088; DATECaption_Control1100231088Lbl)
                {
                    //SourceExpr=DATECaption_Control1100231088Lbl;
                }
                Column(DATECaption_Control1100231089; DATECaption_Control1100231089Lbl)
                {
                    //SourceExpr=DATECaption_Control1100231089Lbl;
                }
                Column(SUMCaption; SUMCaptionLbl)
                {
                    //SourceExpr=SUMCaptionLbl;
                }
                Column(SUMCaption_Control1100231091; SUMCaption_Control1100231091Lbl)
                {
                    //SourceExpr=SUMCaption_Control1100231091Lbl;
                }
                Column(AMOUNTCaption_Control1100231092; AMOUNTCaption_Control1100231092Lbl)
                {
                    //SourceExpr=AMOUNTCaption_Control1100231092Lbl;
                }
                Column(AMOUNTCaption_Control1100231093; AMOUNTCaption_Control1100231093Lbl)
                {
                    //SourceExpr=AMOUNTCaption_Control1100231093Lbl;
                }
                Column(RECORDS_BALANCECaption; RECORDS_BALANCECaptionLbl)
                {
                    //SourceExpr=RECORDS_BALANCECaptionLbl;
                }
                Column(FinishRecord_Job_No_; "Job No.")
                {
                    //SourceExpr="Job No." ;
                }
                trigger OnPreDataItem();
                BEGIN

                    ProcessAmount := 0;
                    ApprovalAmount := 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN

                    ProcessAmount += FinishRecord.ProcedureAmount(0);
                    ApprovalAmount += FinishRecord.AcceptedAmount(0);
                END;


            }
            trigger OnPreDataItem();
            BEGIN

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);

                IF Records.GETFILTER("Job No.") = '' THEN
                    ERROR(Text000);

                IF Records.GETRANGEMIN("Job No.") <> Records.GETRANGEMAX("Job No.") THEN
                    ERROR(Text001);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Job.GET("Job No.");
                Job.CALCFIELDS("Budget Cost Amount", "Production Budget Amount");

                ContractAmount := Job."Production Budget Amount";

                IF Records."Initial Procedure Date" <> 0D THEN BEGIN
                    StartYear := DATE2DMY(Records."Initial Procedure Date", 3);
                    StartMonth := DATE2DMY(Records."Initial Procedure Date", 2);
                END;

                Counter := 0;
                CommentLine.RESET;
                //verify
                     //CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"16");
                //CommentLine.SETRANGE("Table Name", 16);

                CommentLine.SETRANGE("No.", Records."No.");
            //     IF CommentLine.FINDSET THEN BEGIN
            //         REPEAT
            //             Counter += 1;
            //             IF Counter = 1 THEN
            //                 Description1 := CommentLine.Comment;
            //             IF Counter = 2 THEN
            //                 Description2 := CommentLine.Comment;
            //             IF Counter = 3 THEN
            //                 Description3 := CommentLine.Comment;
            //         UNTIL ((CommentLine.NEXT = 0) OR (Counter > 3))
            //     END;
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
        //       CompanyInformation@1100231004 :
        CompanyInformation: Record 79;
        //       Job@7000100 :
        Job: Record 167;
        //       CommentLine@7000101 :
        CommentLine: Record 97;
        //       Description1@7000104 :
        Description1: Text[80];
        //       Description2@7000103 :
        Description2: Text[80];
        //       Description3@7000102 :
        Description3: Text[80];
        //       ContractAmount@1100231007 :
        ContractAmount: Decimal;
        //       ProcessAmount@7000106 :
        ProcessAmount: Decimal;
        //       ApprovalAmount@7000105 :
        ApprovalAmount: Decimal;
        //       StartYear@1100231000 :
        StartYear: Integer;
        //       StartMonth@1100231001 :
        StartMonth: Integer;
        //       Text000@1100231002 :
        Text000: TextConst ENU = 'Must specify a Job', ESP = 'Debe especifciar una Obra';
        //       Text001@1100231003 :
        Text001: TextConst ENU = 'You can only specify one Job', ESP = 'Solo puede especificar una Obra';
        //       Counter@1100231013 :
        Counter: Integer;
        //       CurrReport_PAGENOCaptionLbl@8565 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       RECORD_TRACKINGCaptionLbl@1144 :
        RECORD_TRACKINGCaptionLbl: TextConst ESP = 'SEGUIMIENTO DE EXPEDIENTES';
        //       Customer_CaptionLbl@1187336729 :
        Customer_CaptionLbl: TextConst ENU = 'Customer:', ESP = 'Cliente:';
        //       Job_Title_CaptionLbl@1152901795 :
        Job_Title_CaptionLbl: TextConst ENU = 'Job Title:', ESP = 'T¡tulo de Obra:';
        //       N__Job_CaptionLbl@1124596139 :
        N__Job_CaptionLbl: TextConst ENU = 'Job No.:', ESP = 'N§ de Obra:';
        //       Delegation__CaptionLbl@1119734361 :
        Delegation__CaptionLbl: TextConst ENU = 'Delegations :', ESP = 'Delegaci¢n :';
        //       WITHOUT_PROCESSINGCaptionLbl@1192753615 :
        WITHOUT_PROCESSINGCaptionLbl: TextConst ENU = 'WITHOUT PROCESSING', ESP = 'SIN TRAMITAR';
        //       N__RecordCaptionLbl@1154130844 :
        N__RecordCaptionLbl: TextConst ENU = 'No. Record', ESP = 'N§ Expediente';
        //       Contract_AmountCaptionLbl@1150462416 :
        Contract_AmountCaptionLbl: TextConst ENU = 'Contracted amount', ESP = 'Importe contrato';
        //       ESTIMATECaptionLbl@1146139985 :
        ESTIMATECaptionLbl: TextConst ENU = 'ESTIMATE', ESP = 'ESTIMATACIàN';
        //       POSIBLE_PROCEDURE_STARTCaptionLbl@1156180802 :
        POSIBLE_PROCEDURE_STARTCaptionLbl: TextConst ENU = 'POSIBLE procedure START', ESP = 'POSIBLE INICIO TRµMITE';
        //       PRODUCTIONCaptionLbl@1166747933 :
        PRODUCTIONCaptionLbl: TextConst ENU = 'PRODUCTION', ESP = 'ELABORACIàN';
        //       AMOUNTCaptionLbl@1173153941 :
        AMOUNTCaptionLbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       DATECaptionLbl@1192606289 :
        DATECaptionLbl: TextConst ENU = 'DATE', ESP = 'FECHA';
        //       AMOUNTCaption_Control1100231026Lbl@1169899218 :
        AMOUNTCaption_Control1100231026Lbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       DATECaption_Control1100231027Lbl@1101611253 :
        DATECaption_Control1100231027Lbl: TextConst ENU = 'DATE', ESP = 'FECHA';
        //       YEARCaptionLbl@1177742144 :
        YEARCaptionLbl: TextConst ENU = 'YEAR', ESP = 'A¥O';
        //       MONTHCaptionLbl@1125381621 :
        MONTHCaptionLbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       IN_PROCESSCaptionLbl@1145390280 :
        IN_PROCESSCaptionLbl: TextConst ENU = 'IN PROCESS', ESP = 'EN TRAMITACION';
        //       SUBMITTED_AMOUNTCaptionLbl@1114411926 :
        SUBMITTED_AMOUNTCaptionLbl: TextConst ENU = 'SUBMITTED AMOUNT', ESP = 'IMPORTE PRESENTADO';
        //       CONCEPTSCaptionLbl@1106953915 :
        CONCEPTSCaptionLbl: TextConst ENU = 'CONCEPTS', ESP = 'CONCEPTOS';
        //       DATECaption_Control1100231060Lbl@1168789570 :
        DATECaption_Control1100231060Lbl: TextConst ENU = 'DATE', ESP = 'FECHA';
        //       AMOUNTCaption_Control1100231061Lbl@1170429933 :
        AMOUNTCaption_Control1100231061Lbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       PROVINCIAL_SERV_ENTRYCaptionLbl@1172232922 :
        PROVINCIAL_SERV_ENTRYCaptionLbl: TextConst ENU = 'PROVINCIAL SERV. ENTRY', ESP = 'ENTRADA SERV. PROVINCIALES';
        //       PROVINCIAL_SERV_OUTPUTCaptionLbl@1121389379 :
        PROVINCIAL_SERV_OUTPUTCaptionLbl: TextConst ENU = 'PROVINCIAL SERV. OUTPUT', ESP = 'SALIDA SERV. PROVINCIALES';
        //       CENTRAL_SERV_ENTRYCaptionLbl@1189078765 :
        CENTRAL_SERV_ENTRYCaptionLbl: TextConst ENU = 'CENTRAL SERV. ENTRY', ESP = 'ENTRADA SERV. CENTRALES';
        //       TECHNICAL_APPROVALCaptionLbl@1103156552 :
        TECHNICAL_APPROVALCaptionLbl: TextConst ENU = 'TECHNICAL APPROVAL', ESP = 'APROBACIàN TCNICA';
        //       PROPOSAL_FINANCIAL_APPROVAL_CaptionLbl@1141698331 :
        PROPOSAL_FINANCIAL_APPROVAL_CaptionLbl: TextConst ENU = 'PROPOSAL FINANCIAL APPROVAL', ESP = 'APROBACIàN ECONàMICA/PROP.';
        //       NOTECaptionLbl@1108607212 :
        NOTECaptionLbl: TextConst ENU = 'NOTE', ESP = 'NOTA';
        //       A_photocopy_of_the_corresponding_document_will_always_be_enclosed_CaptionLbl@1153868562 :
        A_photocopy_of_the_corresponding_document_will_always_be_enclosed_CaptionLbl: TextConst ENU = 'A photocopy of the corresponding document will always be enclosed', ESP = 'Se adjuntar  siempre, fotocopia del documento correspondiente.';
        //       OBSERVATIONS_CaptionLbl@1152467018 :
        OBSERVATIONS_CaptionLbl: TextConst ENU = 'OBSERVATIONS:', ESP = 'OBSERVACIONES:';
        //       N__RECOCaptionLbl@1169307611 :
        N__RECOCaptionLbl: TextConst ENU = 'NO. RECO', ESP = 'N§ EXPTE';
        //       HISTORIC_RECORDSCaptionLbl@1134081732 :
        HISTORIC_RECORDSCaptionLbl: TextConst ENU = 'HISTORIC RECORDS', ESP = 'HISTàRICO DE EXPEDIENTES';
        //       APPROVEDCaptionLbl@1174338145 :
        APPROVEDCaptionLbl: TextConst ENU = 'APPROVED', ESP = 'APROBADOS';
        //       TOTALSCaptionLbl@1102859539 :
        TOTALSCaptionLbl: TextConst ENU = 'TOTALS', ESP = 'TOTALES';
        //       DATECaption_Control1100231088Lbl@1117725826 :
        DATECaption_Control1100231088Lbl: TextConst ENU = 'DATE', ESP = 'FECHA';
        //       DATECaption_Control1100231089Lbl@1131885419 :
        DATECaption_Control1100231089Lbl: TextConst ENU = 'DATE', ESP = 'FECHA';
        //       SUMCaptionLbl@1133966248 :
        SUMCaptionLbl: TextConst ENU = 'SUM', ESP = 'SUMA';
        //       SUMCaption_Control1100231091Lbl@1113829503 :
        SUMCaption_Control1100231091Lbl: TextConst ENU = 'SUM', ESP = 'SUMA';
        //       AMOUNTCaption_Control1100231092Lbl@1185567016 :
        AMOUNTCaption_Control1100231092Lbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       AMOUNTCaption_Control1100231093Lbl@1199725348 :
        AMOUNTCaption_Control1100231093Lbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       RECORDS_BALANCECaptionLbl@1108839595 :
        RECORDS_BALANCECaptionLbl: TextConst ENU = 'RECORDS BALANCE', ESP = 'SALDO EXPEDIENTES';

    /*begin
    end.
  */

}




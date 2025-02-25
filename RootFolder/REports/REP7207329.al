report 7207329 "QB Change Dimension"
{


    Permissions = TableData 17 = rm,
                TableData 21 = rm,
                TableData 25 = rm,
                TableData 32 = rm,
                TableData 110 = rm,
                TableData 111 = rm,
                TableData 112 = rm,
                TableData 113 = rm,
                TableData 114 = rm,
                TableData 115 = rm,
                TableData 120 = rm,
                TableData 121 = rm,
                TableData 122 = rm,
                TableData 123 = rm,
                TableData 124 = rm,
                TableData 125 = rm,
                TableData 169 = rm,
                TableData 203 = rm,
                TableData 271 = rm,
                TableData 281 = rm,
                TableData 297 = rm,
                TableData 304 = rm,
                TableData 1004 = rm,
                TableData 1005 = rm,
                TableData 5222 = rm,
                TableData 5601 = rm,
                TableData 5625 = rm,
                TableData 5629 = rm,
                TableData 5744 = rm,
                TableData 5745 = rm,
                TableData 5746 = rm,
                TableData 5747 = rm,
                TableData 5802 = rm,
                TableData 5832 = rm,
                TableData 5907 = rm,
                TableData 5908 = rm,
                TableData 5989 = rm,
                TableData 5990 = rm,
                TableData 5991 = rm,
                TableData 5992 = rm,
                TableData 5993 = rm,
                TableData 5994 = rm,
                TableData 5995 = rm,
                TableData 6650 = rm,
                TableData 6651 = rm,
                TableData 6660 = rm,
                TableData 6661 = rm,
                TableData 7000002 = rm,
                TableData 7000003 = rm,
                TableData 7000004 = rm,
                TableData 7207292 = rm,
                TableData 7207310 = rm,
                TableData 7207311 = rm,
                TableData 7207317 = rm,
                TableData 7207318 = rm,
                TableData 7207323 = rm,
                TableData 7207324 = rm,
                TableData 7207338 = rm,
                TableData 7207339 = rm,
                TableData 7207341 = rm,
                TableData 7207342 = rm,
                TableData 7207365 = rm,
                TableData 7207366 = rm,
                TableData 7207401 = rm,
                TableData 7207402 = rm,
                TableData 7207435 = rm,
                TableData 7207436 = rm;
    CaptionML = ENU = 'Change Dimension', ESP = 'Cambiar Dimensiones';
    ProcessingOnly = true;

    dataset
    {

        DataItem("GLEntrySource"; "G/L Entry")
        {

            DataItemTableView = SORTING("Entry No.");

            ;
            trigger OnAfterGetRecord();
            VAR
                //                                   txt@1100286000 :
                txt: Text;
            BEGIN
                IF (DimensionCode = '') THEN
                    ERROR(Text000);

                IF (ActDimValue = NewDimValue) THEN
                    ERROR(Text006);

                IF (NewDimValue = '') THEN BEGIN
                    IF NOT CONFIRM(Text002, FALSE, DimensionCode) THEN
                        ERROR(Text003);
                END ELSE IF NOT CONFIRM(STRSUBSTNO(Text001, DimensionCode, ActDimValue, NewDimValue), FALSE) THEN
                        ERROR(Text003);

                DocNoFilter := GLEntrySource."Document No.";
                PostingDateFilter := FORMAT(GLEntrySource."Posting Date");
                DimSetIDFilter := GLEntrySource."Dimension Set ID";
                NewDimSetID := FindNewDimSetID(DimSetIDFilter);

                Window.OPEN(Text004);
                FindRecords;
                Window.CLOSE;
                MESSAGE(Text005, NChanged);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group523")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("DimCode"; "DimensionCode")
                    {

                        CaptionML = ENU = 'C¢d. Dimensi¢n';
                        TableRelation = Dimension;

                        ; trigger OnValidate()
                        BEGIN
                            GLEntryDim.RESET;
                            GLEntryDim.GET(GLEntrySource.GETFILTER(GLEntrySource."Entry No."));

                            DimensionSetEntry.RESET;
                            DimensionSetEntry.SETRANGE("Dimension Set ID", GLEntryDim."Dimension Set ID");
                            DimensionSetEntry.SETRANGE("Dimension Code", DimensionCode);
                            IF DimensionSetEntry.FINDFIRST THEN
                                ActDimValue := DimensionSetEntry."Dimension Value Code"
                            ELSE
                                ActDimValue := '';
                        END;


                    }
                    field("OldValue"; "ActDimValue")
                    {

                        CaptionML = ENU = 'Valor Dimensi¢n Actual';
                        Enabled = FALSE;
                        Editable = FALSE;
                    }
                    field("NewValue"; "NewDimValue")
                    {

                        CaptionML = ENU = 'Valor Dimensi¢n Nuevo';



                        ; trigger OnValidate()
                        BEGIN
                            IF (NOT DimensionValue.GET(DimensionCode, NewDimValue)) THEN
                                ERROR(Text007, NewDimValue, DimensionCode);
                        END;

                        trigger OnLookup(var Text: Text): Boolean
                        BEGIN
                            CLEAR(DimensionValues);

                            DimensionValue.RESET;
                            DimensionValue.SETRANGE(DimensionValue."Dimension Code", DimensionCode);
                            DimensionValues.SETTABLEVIEW(DimensionValue);
                            DimensionValues.LOOKUPMODE(TRUE);
                            IF DimensionValues.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                DimensionValues.GETRECORD(DimensionValue);
                                NewDimValue := DimensionValue.Code;
                            END;
                        END;


                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       GLEntryDim@1029 :
        GLEntryDim: Record 17;
        //       GLSetup@1020 :
        GLSetup: Record 98;
        //       DimensionSetEntry@1100286011 :
        DimensionSetEntry: Record 480;
        //       tmpDimensionSetEntry@1100286010 :
        tmpDimensionSetEntry: Record 480 TEMPORARY;
        //       DimensionValue@1100286008 :
        DimensionValue: Record 349;
        //       DimensionValues@1100286007 :
        DimensionValues: Page 537;
        //       DimMgt@1100286006 :
        DimMgt: Codeunit 408;
        //       DimensionCode@1100286009 :
        DimensionCode: Code[20];
        //       ActDimValue@1009 :
        ActDimValue: Code[20];
        //       NewDimValue@1015 :
        NewDimValue: Code[20];
        //       NewDimSetID@1021 :
        NewDimSetID: Integer;
        //       ChangeDim1@1014 :
        ChangeDim1: Boolean;
        //       ChangeDim2@1019 :
        ChangeDim2: Boolean;
        //       Text000@1100286001 :
        Text000: TextConst ESP = 'No ha indicado que dimensi¢n desea cambiar';
        //       Text001@1000 :
        Text001: TextConst ESP = 'Confirme que desea cambiar el valor de la dimensi¢n %1\Actual: %2\Nuevo: %3';
        //       Text002@1100286000 :
        Text002: TextConst ESP = '¨Realmente desea eliminar la dimensi¢n %1 del documento?';
        //       Text003@1001 :
        Text003: TextConst ESP = 'Proceso cancelado.';
        //       DocNoFilter@1011 :
        DocNoFilter: Code[20];
        //       PostingDateFilter@1012 :
        PostingDateFilter: Text;
        //       DimSetIDFilter@1013 :
        DimSetIDFilter: Integer;
        //       Window@1100286003 :
        Window: Dialog;
        //       NChanged@1100286004 :
        NChanged: Integer;
        //       "__TABLAS - STD__"@1024 :
        "__TABLAS - STD__": Integer;
        //       GLEntry@1010 :
        // GLEntry: Record 17 SECURITYFILTERING(Filtered);
        [SecurityFiltering(SecurityFilter::Filtered)]
        GLEntry: Record 17;

        //CustLedgEntry@1007 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntry: Record 21;
        //       VendLedgEntry@1005 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        VendLedgEntry: Record 25;
        //       BankAccLedgEntry@1003 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        BankAccLedgEntry: Record 271;
        //       FALedgEntry@1022 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        FALedgEntry: Record 5601;
        //       MaintenanceLedgEntry@1004 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        MaintenanceLedgEntry: Record 5625;
        //       InsuranceCovLedgEntry@1002 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        InsuranceCovLedgEntry: Record 5629;
        //       ItemLedgEntry@1023 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ItemLedgEntry: Record 32;
        //       PhysInvtLedgEntry@1008 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        PhysInvtLedgEntry: Record 281;
        //       ValueEntry@1006 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ValueEntry: Record 5802;
        //       ReminderEntry@1025 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ReminderEntry: Record 300;
        //       ResLedgEntry@1028 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ResLedgEntry: Record 203;
        //       ServLedgerEntry@1027 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServLedgerEntry: Record 5907;
        //       WarrantyLedgerEntry@1026 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        WarrantyLedgerEntry: Record 5908;
        //       CapacityLedgEntry@1030 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        CapacityLedgEntry: Record 5832;
        //       JobLedgEntry@1033 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        JobLedgEntry: Record 169;
        //       JobWIPEntry@1032 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        JobWIPEntry: Record 1004;
        //       JobWIPGLEntry@1031 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        JobWIPGLEntry: Record 1005;
        //       xSOSalesHeader@1059 :
        xSOSalesHeader: Record 36;
        //       xSISalesHeader@1058 :
        xSISalesHeader: Record 36;
        //       xSROSalesHeader@1057 :
        xSROSalesHeader: Record 36;
        //       xSCMSalesHeader@1056 :
        xSCMSalesHeader: Record 36;
        //       SalesShptHeader@1055 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesShptHeader: Record 110;
        //       SalesShptLine@1060 :
        SalesShptLine: Record 111;
        //       SalesInvHeader@1054 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesInvHeader: Record 112;
        //       SalesInvLine@1061 :
        SalesInvLine: Record 113;
        //       ReturnRcptHeader@1053 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ReturnRcptHeader: Record 6660;
        //       ReturnRcptLine@1063 :
        ReturnRcptLine: Record 6661;
        //       SalesCrMemoHeader@1052 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        SalesCrMemoHeader: Record 114;
        //       SalesCrMemoLine@1062 :
        SalesCrMemoLine: Record 115;
        //       xSOServHeader@1051 :
        xSOServHeader: Record 5900;
        //       xSIServHeader@1050 :
        xSIServHeader: Record 5900;
        //       xSCMServHeader@1049 :
        xSCMServHeader: Record 5900;
        //       ServShptHeader@1048 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServShptHeader: Record 5990;
        //       ServShptLine@1064 :
        ServShptLine: Record 5991;
        //       ServShptItemLine@1034 :
        ServShptItemLine: Record 5989;
        //       ServInvHeader@1047 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServInvHeader: Record 5992;
        //       ServInvLine@1065 :
        ServInvLine: Record 5993;
        //       ServCrMemoHeader@1046 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServCrMemoHeader: Record 5994;
        //       ServCrMemoLine@1066 :
        ServCrMemoLine: Record 5995;
        //       IssuedReminderHeader@1045 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        IssuedReminderHeader: Record 297;
        //       IssuedFinChrgMemoHeader@1044 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        IssuedFinChrgMemoHeader: Record 304;
        //       PurchRcptHeader@1043 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        PurchRcptHeader: Record 120;
        //       PurchRcptLine@1000000000 :
        PurchRcptLine: Record 121;
        //       PurchInvHeader@1042 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        PurchInvHeader: Record 122;
        //       PurchInvLine@1000000003 :
        PurchInvLine: Record 123;
        //       ReturnShptHeader@1041 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ReturnShptHeader: Record 6650;
        //       ReturnShptLine@1000000005 :
        ReturnShptLine: Record 6651;
        //       PurchCrMemoHeader@1040 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        PurchCrMemoHeader: Record 124;
        //       PurchCrMemoLine@1000000004 :
        PurchCrMemoLine: Record 125;
        //       xProductionOrderHeader@1039 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        xProductionOrderHeader: Record 5405;
        //       xTransShptHeader@1037 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        xTransShptHeader: Record 5744;
        //       xTransRcptHeader@1036 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        xTransRcptHeader: Record 5746;
        //       EmplLedgEntry@1000000002 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        EmplLedgEntry: Record 5222;
        //       TransShptHeader@1000000007 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        TransShptHeader: Record 5744;
        //       TransShptLine@1000000008 :
        TransShptLine: Record 5745;
        //       TransRcptHeader@1000000006 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        TransRcptHeader: Record 5746;
        //       TransRcptLine@1000000009 :
        TransRcptLine: Record 5747;
        //       "__TABLAS - ESP__"@1000000010 :
        "__TABLAS - ESP__": Integer;
        //       CarteraDoc@1000000056 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        CarteraDoc: Record 7000002;
        //       PostedCarteraDoc@1000000055 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        PostedCarteraDoc: Record 7000003;
        //       ClosedCarteraDoc@1000000054 :
        [SecurityFiltering(SecurityFilter::Filtered)]
        ClosedCarteraDoc: Record 7000004;
        //       "__TABLAS - QUOB__"@1000000036 :
        "__TABLAS - QUOB__": Integer;
        //       WorksheetHeaderHist@1000000035 :
        WorksheetHeaderHist: Record 7207292;
        //       HistMeasurements@1000000034 :
        HistMeasurements: Record 7207338;
        //       HistMeasurementsLine@1068 :
        HistMeasurementsLine: Record 7207339;
        //       PostCertifications@1000000033 :
        PostCertifications: Record 7207341;
        //       PostCertificationsLine@1069 :
        PostCertificationsLine: Record 7207342;
        //       HistProdMeasureHeader@1000000032 :
        HistProdMeasureHeader: Record 7207401;
        //       HistProdMeasureLine@1071 :
        HistProdMeasureLine: Record 7207402;
        //       PostedOutputShipmentHeader@1000000031 :
        PostedOutputShipmentHeader: Record 7207310;
        //       PostedOutputShipmentLine@1035 :
        PostedOutputShipmentLine: Record 7207311;
        //       PostedOutputShipmentHeader2@1000000030 :
        PostedOutputShipmentHeader2: Record 7207310;
        //       HistReestimationHeader@1000000029 :
        HistReestimationHeader: Record 7207317;
        //       HistReestimationLine@1038 :
        HistReestimationLine: Record 7207318;
        //       CostsheetHeaderHist@1000000028 :
        CostsheetHeaderHist: Record 7207435;
        //       CostsheetHeaderHistLine@1072 :
        CostsheetHeaderHistLine: Record 7207436;
        //       HistExpenseNotesHeader@1000000027 :
        HistExpenseNotesHeader: Record 7207323;
        //       HistExpenseNotesLine@1067 :
        HistExpenseNotesLine: Record 7207324;
        //       xPostedHeaTCostsInvoices@1000000026 :
        xPostedHeaTCostsInvoices: Record 7207288;
        //       xHistHeadDelivRetElement@1000000025 :
        xHistHeadDelivRetElement: Record 7207359;
        //       UsageHeaderHist@1000000024 :
        UsageHeaderHist: Record 7207365;
        //       UsageHeaderHistLine@1070 :
        UsageHeaderHistLine: Record 7207366;
        //       ActivationHeaderHist@1000000023 :
        ActivationHeaderHist: Record 7207370;
        //       RentalElementsEntries@1000000018 :
        RentalElementsEntries: Record 7207345;
        //       Text004@1100286005 :
        Text004: TextConst ESP = 'Cambiando #1###############################################';
        //       Text005@1100286002 :
        Text005: TextConst ESP = 'Proceso Finalizado correctamente, cambiados %1 registros';
        //       Text006@1100286012 :
        Text006: TextConst ESP = 'No ha cambiado el valor de la dimensi¢n, proceso cancelado.';
        //       Text007@1100286013 :
        Text007: TextConst ESP = 'El valor %1 no existe en la dimensi¢n %2';

    //     LOCAL procedure FindNewDimSetID (DimSetIDFind@1000000001 :
    LOCAL procedure FindNewDimSetID(DimSetIDFind: Integer) DimSetID: Integer;
    var
        //       GenJournalLine@1000000000 :
        GenJournalLine: Record 81;
        //       i@1100286000 :
        i: Integer;
    begin
        //Buscar el nuevo ID Grupo de Dimensiones a partir del ID actual y el nuevo valor de dimensi¢n

        DimMgt.GetDimensionSet(tmpDimensionSetEntry, DimSetIDFind);
        if (tmpDimensionSetEntry.GET(DimSetIDFind, DimensionCode)) then begin
            tmpDimensionSetEntry."Dimension Value Code" := NewDimValue;
            tmpDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            tmpDimensionSetEntry."Dimension Value Name" := DimensionValue.Name;
            tmpDimensionSetEntry.MODIFY;
        end else begin
            DimensionValue.GET(DimensionCode, NewDimValue);
            tmpDimensionSetEntry.INIT;
            tmpDimensionSetEntry."Dimension Set ID" := DimSetIDFind;
            tmpDimensionSetEntry."Dimension Code" := DimensionCode;
            tmpDimensionSetEntry."Dimension Name" := '';
            tmpDimensionSetEntry."Dimension Value Code" := NewDimValue;
            tmpDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            tmpDimensionSetEntry."Dimension Value Name" := DimensionValue.Name;
            tmpDimensionSetEntry.INSERT;
        end;
        i := DimMgt.GetDimensionSetID(tmpDimensionSetEntry);
        exit(i);

        // // GLSetup.GET;
        // //
        // // DimensionSetEntry.RESET;
        // // DimensionSetEntry.SETRANGE(DimensionSetEntry."Dimension Set ID",DimSetIDFind);
        // // DimensionSetEntry.SETRANGE(DimensionSetEntry."Dimension Code",DimensionCode);
        // // DimensionSetEntry.SETRANGE(DimensionSetEntry."Dimension Value Code",ActDimValue);
        // // if DimensionSetEntry.FINDSET(FALSE) then begin
        // //  GenJournalLine.INIT;
        // //  GenJournalLine."Journal Template Name" := '';
        // //  GenJournalLine."Journal Batch Name" := '';
        // //  GenJournalLine."Line No." := 10000;
        // //  GenJournalLine."Dimension Set ID" := DimSetIDFind;
        // //
        // //  CASE DimensionCode OF
        // //    GLSetup."Shortcut Dimension 1 Code": GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code",NewDimValue);
        // //    GLSetup."Shortcut Dimension 2 Code": GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code",NewDimValue);
        // //    GLSetup."Shortcut Dimension 3 Code": GenJournalLine.ValidateShortcutDimCode(3,NewDimValue);
        // //    GLSetup."Shortcut Dimension 4 Code": GenJournalLine.ValidateShortcutDimCode(4,NewDimValue);
        // //    GLSetup."Shortcut Dimension 5 Code": GenJournalLine.ValidateShortcutDimCode(5,NewDimValue);
        // //    GLSetup."Shortcut Dimension 6 Code": GenJournalLine.ValidateShortcutDimCode(6,NewDimValue);
        // //    GLSetup."Shortcut Dimension 7 Code": GenJournalLine.ValidateShortcutDimCode(7,NewDimValue);
        // //    GLSetup."Shortcut Dimension 8 Code": GenJournalLine.ValidateShortcutDimCode(8,NewDimValue);
        // //  end;
        // //
        // //  exit(GenJournalLine."Dimension Set ID");
        // // end else
        // //  exit(DimSetIDFind);
    end;

    //     LOCAL procedure SetChangeDim (DimSetIDFind@1000000001 :
    LOCAL procedure SetChangeDim(DimSetIDFind: Integer)
    begin
        //Indica si se debe cambiar la dimensi¢n 1 o la dimensi¢n 2
        GLSetup.GET;

        CLEAR(ChangeDim1);
        CLEAR(ChangeDim2);
        // // DimensionSetEntry.RESET;
        // // DimensionSetEntry.SETRANGE(DimensionSetEntry."Dimension Set ID",DimSetIDFind);
        // // DimensionSetEntry.SETRANGE(DimensionSetEntry."Dimension Code",DimensionCode);
        // // DimensionSetEntry.SETRANGE(DimensionSetEntry."Dimension Value Code",ActDimValue);
        // // if DimensionSetEntry.FINDSET(FALSE) then
        CASE DimensionCode OF
            GLSetup."Shortcut Dimension 1 Code":
                ChangeDim1 := TRUE;
            GLSetup."Shortcut Dimension 2 Code":
                ChangeDim2 := TRUE;
        end;
    end;

    LOCAL procedure FindRecords()
    var
        //       DocType2@1002 :
        DocType2: Text[100];
        //       DocNo2@1004 :
        DocNo2: Code[20];
        //       SourceType2@1003 :
        SourceType2: Integer;
        //       SourceNo2@1005 :
        SourceNo2: Code[20];
        //       PostingDate@1000 :
        PostingDate: Date;
        //       IsSourceUpdated@1001 :
        IsSourceUpdated: Boolean;
        //       HideDialog@1006 :
        HideDialog: Boolean;
    begin
        //Registros a cambiar
        Window.UPDATE(1, 'Documentos registrados');
        FindPostedDocuments;

        Window.UPDATE(1, 'Movimientos');
        FindLedgerEntries;

        Window.UPDATE(1, 'Propios de QuoBuilding');
        FindQuoBuildingDocuments;
    end;

    LOCAL procedure FindLedgerEntries()
    begin
        //Registros de movimientos
        FindGLEntries;
        FindVATEntries;
        FindCustEntries;
        FindReminderEntries;
        FindVendEntries;
        FindInvtEntries;
        FindResEntries;
        FindJobEntries;
        FindBankEntries;
        FindFAEntries;
        FindCapEntries;
        FindWhseEntries;
        FindServEntries;
        FindCostEntries;
    end;

    LOCAL procedure FindCustEntries()
    begin
        //Movimientos de clientes
        if CustLedgEntry.READPERMISSION then begin
            CustLedgEntry.RESET;
            CustLedgEntry.SETCURRENTKEY("Document No.");
            CustLedgEntry.SETFILTER("Document No.", DocNoFilter);
            CustLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if CustLedgEntry.FINDSET(TRUE) then begin
                FindCarteraDocs(CarteraDoc.Type::Receivable);
                repeat
                    SetChangeDim(CustLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        CustLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        CustLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if CustLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        CustLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        CustLedgEntry."Dimension Set ID" := FindNewDimSetID(CustLedgEntry."Dimension Set ID");

                    CustLedgEntry.MODIFY;
                    NChanged += 1;
                until CustLedgEntry.NEXT = 0;
            end;
        end;
    end;

    LOCAL procedure FindVendEntries()
    begin
        //Movimientos de proveedores
        if VendLedgEntry.READPERMISSION then begin
            VendLedgEntry.RESET;
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETFILTER("Document No.", DocNoFilter);
            VendLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if VendLedgEntry.FINDSET(TRUE) then begin
                FindCarteraDocs(CarteraDoc.Type::Payable);
                repeat
                    SetChangeDim(VendLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        VendLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        VendLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if VendLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        VendLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        VendLedgEntry."Dimension Set ID" := FindNewDimSetID(VendLedgEntry."Dimension Set ID");

                    VendLedgEntry.MODIFY;
                    NChanged += 1;
                until VendLedgEntry.NEXT = 0;
            end;
        end;
    end;

    LOCAL procedure FindBankEntries()
    begin
        //Movimientos de banco
        if BankAccLedgEntry.READPERMISSION then begin
            BankAccLedgEntry.RESET;
            BankAccLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            BankAccLedgEntry.SETFILTER("Document No.", DocNoFilter);
            BankAccLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if BankAccLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(BankAccLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        BankAccLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        BankAccLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if BankAccLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        BankAccLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        BankAccLedgEntry."Dimension Set ID" := FindNewDimSetID(BankAccLedgEntry."Dimension Set ID");

                    BankAccLedgEntry.MODIFY;
                    NChanged += 1;
                until BankAccLedgEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindGLEntries()
    begin
        //Movimientos contables
        if GLEntry.READPERMISSION then begin
            GLEntry.RESET;
            GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            GLEntry.SETFILTER("Document No.", DocNoFilter);
            GLEntry.SETFILTER("Posting Date", PostingDateFilter);
            if GLEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(GLEntry."Dimension Set ID");
                    if ChangeDim1 then
                        GLEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        GLEntry."Global Dimension 2 Code" := NewDimValue;

                    if GLEntry."Dimension Set ID" = DimSetIDFilter then
                        GLEntry."Dimension Set ID" := NewDimSetID
                    else
                        GLEntry."Dimension Set ID" := FindNewDimSetID(GLEntry."Dimension Set ID");

                    GLEntry.MODIFY;
                    NChanged += 1;
                until GLEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindVATEntries()
    begin
        //Movimientos de IVA
    end;

    LOCAL procedure FindFAEntries()
    begin
        //Movimientos de activos y relacionados
        if FALedgEntry.READPERMISSION then begin
            FALedgEntry.RESET;
            FALedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            FALedgEntry.SETFILTER("Document No.", DocNoFilter);
            FALedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if FALedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(FALedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        FALedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        FALedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if FALedgEntry."Dimension Set ID" = DimSetIDFilter then
                        FALedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        FALedgEntry."Dimension Set ID" := FindNewDimSetID(FALedgEntry."Dimension Set ID");

                    FALedgEntry.MODIFY;
                    NChanged += 1;
                until FALedgEntry.NEXT = 0;
        end;
        if MaintenanceLedgEntry.READPERMISSION then begin
            MaintenanceLedgEntry.RESET;
            MaintenanceLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            MaintenanceLedgEntry.SETFILTER("Document No.", DocNoFilter);
            MaintenanceLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if MaintenanceLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(MaintenanceLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        MaintenanceLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        MaintenanceLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if MaintenanceLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        MaintenanceLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        MaintenanceLedgEntry."Dimension Set ID" := FindNewDimSetID(MaintenanceLedgEntry."Dimension Set ID");

                    MaintenanceLedgEntry.MODIFY;
                    NChanged += 1;
                until MaintenanceLedgEntry.NEXT = 0;
        end;
        if InsuranceCovLedgEntry.READPERMISSION then begin
            InsuranceCovLedgEntry.RESET;
            InsuranceCovLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            InsuranceCovLedgEntry.SETFILTER("Document No.", DocNoFilter);
            InsuranceCovLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if InsuranceCovLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(InsuranceCovLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        InsuranceCovLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        InsuranceCovLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if InsuranceCovLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        InsuranceCovLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        InsuranceCovLedgEntry."Dimension Set ID" := FindNewDimSetID(InsuranceCovLedgEntry."Dimension Set ID");

                    InsuranceCovLedgEntry.MODIFY;
                    NChanged += 1;
                until InsuranceCovLedgEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindInvtEntries()
    begin
        //Movimientos de producto, valor e inventario
        if ItemLedgEntry.READPERMISSION then begin
            ItemLedgEntry.RESET;
            ItemLedgEntry.SETCURRENTKEY("Document No.");
            ItemLedgEntry.SETFILTER("Document No.", DocNoFilter);
            ItemLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if ItemLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ItemLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        ItemLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ItemLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if ItemLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        ItemLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        ItemLedgEntry."Dimension Set ID" := FindNewDimSetID(ItemLedgEntry."Dimension Set ID");

                    ItemLedgEntry.MODIFY;
                    NChanged += 1;
                until ItemLedgEntry.NEXT = 0;
        end;
        if ValueEntry.READPERMISSION then begin
            ValueEntry.RESET;
            ValueEntry.SETCURRENTKEY("Document No.");
            ValueEntry.SETFILTER("Document No.", DocNoFilter);
            ValueEntry.SETFILTER("Posting Date", PostingDateFilter);
            if ValueEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ValueEntry."Dimension Set ID");
                    if ChangeDim1 then
                        ValueEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ValueEntry."Global Dimension 2 Code" := NewDimValue;

                    if ValueEntry."Dimension Set ID" = DimSetIDFilter then
                        ValueEntry."Dimension Set ID" := NewDimSetID
                    else
                        ValueEntry."Dimension Set ID" := FindNewDimSetID(ValueEntry."Dimension Set ID");

                    ValueEntry.MODIFY;
                    NChanged += 1;
                until ValueEntry.NEXT = 0;
        end;
        if PhysInvtLedgEntry.READPERMISSION then begin
            PhysInvtLedgEntry.RESET;
            PhysInvtLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            PhysInvtLedgEntry.SETFILTER("Document No.", DocNoFilter);
            PhysInvtLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if PhysInvtLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PhysInvtLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        PhysInvtLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PhysInvtLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if PhysInvtLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        PhysInvtLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        PhysInvtLedgEntry."Dimension Set ID" := FindNewDimSetID(PhysInvtLedgEntry."Dimension Set ID");

                    PhysInvtLedgEntry.MODIFY;
                    NChanged += 1;
                until PhysInvtLedgEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindReminderEntries()
    begin
        //Movimientos de recordatorios
    end;

    LOCAL procedure FindResEntries()
    begin
        //Movimientos de recursos
        if ResLedgEntry.READPERMISSION then begin
            ResLedgEntry.RESET;
            ResLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            ResLedgEntry.SETFILTER("Document No.", DocNoFilter);
            ResLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if ResLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ResLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        ResLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ResLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if ResLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        ResLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        ResLedgEntry."Dimension Set ID" := FindNewDimSetID(ResLedgEntry."Dimension Set ID");

                    ResLedgEntry.MODIFY;
                    NChanged += 1;
                until ResLedgEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindServEntries()
    begin
        //Movimientos de pedidos de servicio
        if ServLedgerEntry.READPERMISSION then begin
            ServLedgerEntry.RESET;
            ServLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date");
            ServLedgerEntry.SETFILTER("Document No.", DocNoFilter);
            ServLedgerEntry.SETFILTER("Posting Date", PostingDateFilter);
            if ServLedgerEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ServLedgerEntry."Dimension Set ID");
                    if ChangeDim1 then
                        ServLedgerEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ServLedgerEntry."Global Dimension 2 Code" := NewDimValue;

                    if ServLedgerEntry."Dimension Set ID" = DimSetIDFilter then
                        ServLedgerEntry."Dimension Set ID" := NewDimSetID
                    else
                        ServLedgerEntry."Dimension Set ID" := FindNewDimSetID(ServLedgerEntry."Dimension Set ID");

                    ServLedgerEntry.MODIFY;
                    NChanged += 1;
                until ServLedgerEntry.NEXT = 0;
        end;
        if WarrantyLedgerEntry.READPERMISSION then begin
            WarrantyLedgerEntry.RESET;
            WarrantyLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date");
            WarrantyLedgerEntry.SETFILTER("Document No.", DocNoFilter);
            WarrantyLedgerEntry.SETFILTER("Posting Date", PostingDateFilter);
            if WarrantyLedgerEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(WarrantyLedgerEntry."Dimension Set ID");
                    if ChangeDim1 then
                        WarrantyLedgerEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        WarrantyLedgerEntry."Global Dimension 2 Code" := NewDimValue;

                    if WarrantyLedgerEntry."Dimension Set ID" = DimSetIDFilter then
                        WarrantyLedgerEntry."Dimension Set ID" := NewDimSetID
                    else
                        WarrantyLedgerEntry."Dimension Set ID" := FindNewDimSetID(WarrantyLedgerEntry."Dimension Set ID");

                    WarrantyLedgerEntry.MODIFY;
                    NChanged += 1;
                until WarrantyLedgerEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindCapEntries()
    begin
        //Movimientos de capacidad
        if CapacityLedgEntry.READPERMISSION then begin
            CapacityLedgEntry.RESET;
            CapacityLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            CapacityLedgEntry.SETFILTER("Document No.", DocNoFilter);
            CapacityLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if CapacityLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(CapacityLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        CapacityLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        CapacityLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if CapacityLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        CapacityLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        CapacityLedgEntry."Dimension Set ID" := FindNewDimSetID(CapacityLedgEntry."Dimension Set ID");

                    CapacityLedgEntry.MODIFY;
                    NChanged += 1;
                until CapacityLedgEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindCostEntries()
    begin
        //Movimientos de coste
    end;

    LOCAL procedure FindWhseEntries()
    begin
        //Movimientos de retenci¢n
    end;

    LOCAL procedure FindJobEntries()
    begin
        //Movimientos de proyecto
        if JobLedgEntry.READPERMISSION then begin
            JobLedgEntry.RESET;
            JobLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            JobLedgEntry.SETFILTER("Document No.", DocNoFilter);
            JobLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if JobLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(JobLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        JobLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        JobLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if JobLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        JobLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        JobLedgEntry."Dimension Set ID" := FindNewDimSetID(JobLedgEntry."Dimension Set ID");

                    JobLedgEntry.MODIFY;
                    NChanged += 1;
                until JobLedgEntry.NEXT = 0;
        end;
        if JobWIPEntry.READPERMISSION then begin
            JobWIPEntry.RESET;
            JobWIPEntry.SETFILTER("Document No.", DocNoFilter);
            JobWIPEntry.SETFILTER("WIP Posting Date", PostingDateFilter);
            if JobWIPEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(JobWIPEntry."Dimension Set ID");
                    if ChangeDim1 then
                        JobWIPEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        JobWIPEntry."Global Dimension 2 Code" := NewDimValue;

                    if JobWIPEntry."Dimension Set ID" = DimSetIDFilter then
                        JobWIPEntry."Dimension Set ID" := NewDimSetID
                    else
                        JobWIPEntry."Dimension Set ID" := FindNewDimSetID(JobWIPEntry."Dimension Set ID");

                    JobWIPEntry.MODIFY;
                    NChanged += 1;
                until JobWIPEntry.NEXT = 0;
        end;
        if JobWIPGLEntry.READPERMISSION then begin
            JobWIPGLEntry.RESET;
            JobWIPGLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            JobWIPGLEntry.SETFILTER("Document No.", DocNoFilter);
            JobWIPGLEntry.SETFILTER("Posting Date", PostingDateFilter);
            if JobWIPGLEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(JobWIPGLEntry."Dimension Set ID");
                    if ChangeDim1 then
                        JobWIPGLEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        JobWIPGLEntry."Global Dimension 2 Code" := NewDimValue;

                    if JobWIPGLEntry."Dimension Set ID" = DimSetIDFilter then
                        JobWIPGLEntry."Dimension Set ID" := NewDimSetID
                    else
                        JobWIPGLEntry."Dimension Set ID" := FindNewDimSetID(JobWIPGLEntry."Dimension Set ID");

                    JobWIPGLEntry.MODIFY;
                    NChanged += 1;
                until JobWIPGLEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindPostedDocuments()
    begin
        //Documentos registrados
        FindIncomingDocumentRecords;
        FindEmployeeRecords;
        FindSalesShipmentHeader;
        FindSalesInvoiceHeader;
        FindReturnRcptHeader;
        FindSalesCrMemoHeader;
        FindServShipmentHeader;
        FindServInvoiceHeader;
        FindServCrMemoHeader;
        FindIssuedReminderHeader;
        FindIssuedFinChrgMemoHeader;
        FindPurchRcptHeader;
        FindPurchInvoiceHeader;
        FindReturnShptHeader;
        FindPurchCrMemoHeader;
        FindProdOrderHeader;
        FindPostedAssemblyHeader;
        FindTransShptHeader;
        FindTransRcptHeader;
        FindPstdPhysInvtOrderHdr;
        FindPostedWhseShptLine;
        FindPostedWhseRcptLine;
    end;

    LOCAL procedure FindIncomingDocumentRecords()
    begin
    end;

    LOCAL procedure FindSalesShipmentHeader()
    begin
        if SalesShptHeader.READPERMISSION then begin
            SalesShptHeader.RESET;
            SalesShptHeader.SETFILTER("No.", DocNoFilter);
            SalesShptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if SalesShptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(SalesShptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        SalesShptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        SalesShptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if SalesShptHeader."Dimension Set ID" = DimSetIDFilter then
                        SalesShptHeader."Dimension Set ID" := NewDimSetID
                    else
                        SalesShptHeader."Dimension Set ID" := FindNewDimSetID(SalesShptHeader."Dimension Set ID");

                    SalesShptHeader.MODIFY;
                    NChanged += 1;

                    if SalesShptLine.READPERMISSION then begin
                        SalesShptLine.RESET;
                        SalesShptLine.SETRANGE("Document No.", SalesShptHeader."No.");
                        if SalesShptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(SalesShptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    SalesShptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    SalesShptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if SalesShptLine."Dimension Set ID" = DimSetIDFilter then
                                    SalesShptLine."Dimension Set ID" := NewDimSetID
                                else
                                    SalesShptLine."Dimension Set ID" := FindNewDimSetID(SalesShptLine."Dimension Set ID");

                                SalesShptLine.MODIFY;
                                NChanged += 1;
                            until SalesShptLine.NEXT = 0;
                    end;
                until SalesShptHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindSalesInvoiceHeader()
    begin
        if SalesInvHeader.READPERMISSION then begin
            SalesInvHeader.RESET;
            SalesInvHeader.SETFILTER("No.", DocNoFilter);
            SalesInvHeader.SETFILTER("Posting Date", PostingDateFilter);
            if SalesInvHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(SalesInvHeader."Dimension Set ID");
                    if ChangeDim1 then
                        SalesInvHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        SalesInvHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if SalesInvHeader."Dimension Set ID" = DimSetIDFilter then
                        SalesInvHeader."Dimension Set ID" := NewDimSetID
                    else
                        SalesInvHeader."Dimension Set ID" := FindNewDimSetID(SalesInvHeader."Dimension Set ID");

                    SalesInvHeader.MODIFY;
                    NChanged += 1;

                    if SalesInvLine.READPERMISSION then begin
                        SalesInvLine.RESET;
                        SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
                        if SalesInvLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(SalesInvLine."Dimension Set ID");
                                if ChangeDim1 then
                                    SalesInvLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    SalesInvLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if SalesInvLine."Dimension Set ID" = DimSetIDFilter then
                                    SalesInvLine."Dimension Set ID" := NewDimSetID
                                else
                                    SalesInvLine."Dimension Set ID" := FindNewDimSetID(SalesInvLine."Dimension Set ID");

                                SalesInvLine.MODIFY;
                                NChanged += 1;
                            until SalesInvLine.NEXT = 0;
                    end;
                until SalesInvHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindSalesCrMemoHeader()
    begin
        if SalesCrMemoHeader.READPERMISSION then begin
            SalesCrMemoHeader.RESET;
            SalesCrMemoHeader.SETFILTER("No.", DocNoFilter);
            SalesCrMemoHeader.SETFILTER("Posting Date", PostingDateFilter);
            if SalesCrMemoHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(SalesCrMemoHeader."Dimension Set ID");
                    if ChangeDim1 then
                        SalesCrMemoHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        SalesCrMemoHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if SalesCrMemoHeader."Dimension Set ID" = DimSetIDFilter then
                        SalesCrMemoHeader."Dimension Set ID" := NewDimSetID
                    else
                        SalesCrMemoHeader."Dimension Set ID" := FindNewDimSetID(SalesCrMemoHeader."Dimension Set ID");

                    SalesCrMemoHeader.MODIFY;
                    NChanged += 1;

                    if SalesCrMemoLine.READPERMISSION then begin
                        SalesCrMemoLine.RESET;
                        SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                        if SalesCrMemoLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(SalesCrMemoLine."Dimension Set ID");
                                if ChangeDim1 then
                                    SalesCrMemoLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    SalesCrMemoLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if SalesCrMemoLine."Dimension Set ID" = DimSetIDFilter then
                                    SalesCrMemoLine."Dimension Set ID" := NewDimSetID
                                else
                                    SalesCrMemoLine."Dimension Set ID" := FindNewDimSetID(SalesCrMemoLine."Dimension Set ID");

                                SalesCrMemoLine.MODIFY;
                                NChanged += 1;
                            until SalesCrMemoLine.NEXT = 0;
                    end;
                until SalesCrMemoHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindReturnRcptHeader()
    begin
        if ReturnRcptHeader.READPERMISSION then begin
            ReturnRcptHeader.RESET;
            ReturnRcptHeader.SETFILTER("No.", DocNoFilter);
            ReturnRcptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if ReturnRcptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ReturnRcptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        ReturnRcptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ReturnRcptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if ReturnRcptHeader."Dimension Set ID" = DimSetIDFilter then
                        ReturnRcptHeader."Dimension Set ID" := NewDimSetID
                    else
                        ReturnRcptHeader."Dimension Set ID" := FindNewDimSetID(ReturnRcptHeader."Dimension Set ID");

                    ReturnRcptHeader.MODIFY;
                    NChanged += 1;

                    if ReturnRcptLine.READPERMISSION then begin
                        ReturnRcptLine.RESET;
                        ReturnRcptLine.SETRANGE("Document No.", ReturnRcptHeader."No.");
                        if ReturnRcptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(ReturnRcptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    ReturnRcptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    ReturnRcptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if ReturnRcptLine."Dimension Set ID" = DimSetIDFilter then
                                    ReturnRcptLine."Dimension Set ID" := NewDimSetID
                                else
                                    ReturnRcptLine."Dimension Set ID" := FindNewDimSetID(ReturnRcptLine."Dimension Set ID");

                                ReturnRcptLine.MODIFY;
                                NChanged += 1;
                            until ReturnRcptLine.NEXT = 0;
                    end;
                until ReturnRcptHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindServShipmentHeader()
    begin
        if ServShptHeader.READPERMISSION then begin
            ServShptHeader.RESET;
            ServShptHeader.SETFILTER("No.", DocNoFilter);
            ServShptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if ServShptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ServShptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        ServShptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ServShptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if ServShptHeader."Dimension Set ID" = DimSetIDFilter then
                        ServShptHeader."Dimension Set ID" := NewDimSetID
                    else
                        ServShptHeader."Dimension Set ID" := FindNewDimSetID(ServShptHeader."Dimension Set ID");

                    ServShptHeader.MODIFY;
                    NChanged += 1;

                    if ServShptLine.READPERMISSION then begin
                        ServShptLine.RESET;
                        ServShptLine.SETRANGE("Document No.", ServShptHeader."No.");
                        if ServShptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(ServShptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    ServShptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    ServShptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if ServShptLine."Dimension Set ID" = DimSetIDFilter then
                                    ServShptLine."Dimension Set ID" := NewDimSetID
                                else
                                    ServShptLine."Dimension Set ID" := FindNewDimSetID(ServShptLine."Dimension Set ID");

                                ServShptLine.MODIFY;
                                NChanged += 1;
                            until ServShptLine.NEXT = 0;
                    end;

                    if ServShptItemLine.READPERMISSION then begin
                        ServShptItemLine.RESET;
                        ServShptItemLine.SETRANGE("No.", ServShptHeader."No.");
                        if ServShptItemLine.FINDSET(TRUE) then
                            repeat
                                if ServShptItemLine."Dimension Set ID" = DimSetIDFilter then
                                    ServShptItemLine."Dimension Set ID" := NewDimSetID
                                else
                                    ServShptItemLine."Dimension Set ID" := FindNewDimSetID(ServShptItemLine."Dimension Set ID");
                                ServShptItemLine.MODIFY;
                                NChanged += 1;
                            until ServShptItemLine.NEXT = 0;
                    end;
                until ServShptHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindServInvoiceHeader()
    begin
        if ServInvHeader.READPERMISSION then begin
            ServInvHeader.RESET;
            ServInvHeader.SETFILTER("No.", DocNoFilter);
            ServInvHeader.SETFILTER("Posting Date", PostingDateFilter);
            if ServInvHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ServInvHeader."Dimension Set ID");
                    if ChangeDim1 then
                        ServInvHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ServInvHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if ServInvHeader."Dimension Set ID" = DimSetIDFilter then
                        ServInvHeader."Dimension Set ID" := NewDimSetID
                    else
                        ServInvHeader."Dimension Set ID" := FindNewDimSetID(ServInvHeader."Dimension Set ID");

                    ServInvHeader.MODIFY;
                    NChanged += 1;

                    if ServInvLine.READPERMISSION then begin
                        ServInvLine.RESET;
                        ServInvLine.SETRANGE("Document No.", ServInvHeader."No.");
                        if ServInvLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(ServInvLine."Dimension Set ID");
                                if ChangeDim1 then
                                    ServInvLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    ServInvLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if ServInvLine."Dimension Set ID" = DimSetIDFilter then
                                    ServInvLine."Dimension Set ID" := NewDimSetID
                                else
                                    ServInvLine."Dimension Set ID" := FindNewDimSetID(ServInvLine."Dimension Set ID");

                                ServInvLine.MODIFY;
                                NChanged += 1;
                            until ServInvLine.NEXT = 0;
                    end;
                until ServInvHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindServCrMemoHeader()
    begin
        if ServCrMemoHeader.READPERMISSION then begin
            ServCrMemoHeader.RESET;
            ServCrMemoHeader.SETFILTER("No.", DocNoFilter);
            ServCrMemoHeader.SETFILTER("Posting Date", PostingDateFilter);
            if ServCrMemoHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ServCrMemoHeader."Dimension Set ID");
                    if ChangeDim1 then
                        ServCrMemoHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ServCrMemoHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if ServCrMemoHeader."Dimension Set ID" = DimSetIDFilter then
                        ServCrMemoHeader."Dimension Set ID" := NewDimSetID
                    else
                        ServCrMemoHeader."Dimension Set ID" := FindNewDimSetID(ServCrMemoHeader."Dimension Set ID");

                    ServCrMemoHeader.MODIFY;
                    NChanged += 1;

                    if ServCrMemoLine.READPERMISSION then begin
                        ServCrMemoLine.RESET;
                        ServCrMemoLine.SETRANGE("Document No.", ServCrMemoHeader."No.");
                        if ServCrMemoLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(ServCrMemoLine."Dimension Set ID");
                                if ChangeDim1 then
                                    ServCrMemoLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    ServCrMemoLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if ServCrMemoLine."Dimension Set ID" = DimSetIDFilter then
                                    ServCrMemoLine."Dimension Set ID" := NewDimSetID
                                else
                                    ServCrMemoLine."Dimension Set ID" := FindNewDimSetID(ServCrMemoLine."Dimension Set ID");

                                ServCrMemoLine.MODIFY;
                                NChanged += 1;
                            until ServCrMemoLine.NEXT = 0;
                    end;
                until ServCrMemoHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindEmployeeRecords()
    begin
        if EmplLedgEntry.READPERMISSION then begin
            EmplLedgEntry.RESET;
            EmplLedgEntry.SETCURRENTKEY("Document No.");
            EmplLedgEntry.SETFILTER("Document No.", DocNoFilter);
            EmplLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            if EmplLedgEntry.FINDSET(TRUE) then
                repeat
                    SetChangeDim(EmplLedgEntry."Dimension Set ID");
                    if ChangeDim1 then
                        EmplLedgEntry."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        EmplLedgEntry."Global Dimension 2 Code" := NewDimValue;

                    if EmplLedgEntry."Dimension Set ID" = DimSetIDFilter then
                        EmplLedgEntry."Dimension Set ID" := NewDimSetID
                    else
                        EmplLedgEntry."Dimension Set ID" := FindNewDimSetID(EmplLedgEntry."Dimension Set ID");

                    EmplLedgEntry.MODIFY;
                    NChanged += 1;
                until EmplLedgEntry.NEXT = 0;
        end;
    end;

    LOCAL procedure FindIssuedReminderHeader()
    begin
        if IssuedReminderHeader.READPERMISSION then begin
            IssuedReminderHeader.RESET;
            IssuedReminderHeader.SETFILTER("No.", DocNoFilter);
            IssuedReminderHeader.SETFILTER("Posting Date", PostingDateFilter);
            if IssuedReminderHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(IssuedReminderHeader."Dimension Set ID");
                    if ChangeDim1 then
                        IssuedReminderHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        IssuedReminderHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if IssuedReminderHeader."Dimension Set ID" = DimSetIDFilter then
                        IssuedReminderHeader."Dimension Set ID" := NewDimSetID
                    else
                        IssuedReminderHeader."Dimension Set ID" := FindNewDimSetID(IssuedReminderHeader."Dimension Set ID");

                    IssuedReminderHeader.MODIFY;
                    NChanged += 1;
                until IssuedReminderHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindIssuedFinChrgMemoHeader()
    begin
        if IssuedFinChrgMemoHeader.READPERMISSION then begin
            IssuedFinChrgMemoHeader.RESET;
            IssuedFinChrgMemoHeader.SETFILTER("No.", DocNoFilter);
            IssuedFinChrgMemoHeader.SETFILTER("Posting Date", PostingDateFilter);
            if IssuedFinChrgMemoHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(IssuedFinChrgMemoHeader."Dimension Set ID");
                    if ChangeDim1 then
                        IssuedFinChrgMemoHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        IssuedFinChrgMemoHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if IssuedFinChrgMemoHeader."Dimension Set ID" = DimSetIDFilter then
                        IssuedFinChrgMemoHeader."Dimension Set ID" := NewDimSetID
                    else
                        IssuedFinChrgMemoHeader."Dimension Set ID" := FindNewDimSetID(IssuedFinChrgMemoHeader."Dimension Set ID");

                    IssuedFinChrgMemoHeader.MODIFY;
                    NChanged += 1;
                until IssuedFinChrgMemoHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindPurchRcptHeader()
    begin
        if PurchRcptHeader.READPERMISSION then begin
            PurchRcptHeader.RESET;
            PurchRcptHeader.SETFILTER("No.", DocNoFilter);
            PurchRcptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if PurchRcptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PurchRcptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        PurchRcptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PurchRcptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if PurchRcptHeader."Dimension Set ID" = DimSetIDFilter then
                        PurchRcptHeader."Dimension Set ID" := NewDimSetID
                    else
                        PurchRcptHeader."Dimension Set ID" := FindNewDimSetID(PurchRcptHeader."Dimension Set ID");

                    PurchRcptHeader.MODIFY;
                    NChanged += 1;

                    if PurchRcptLine.READPERMISSION then begin
                        PurchRcptLine.RESET;
                        PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
                        if PurchRcptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(PurchRcptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    PurchRcptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    PurchRcptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if PurchRcptLine."Dimension Set ID" = DimSetIDFilter then
                                    PurchRcptLine."Dimension Set ID" := NewDimSetID
                                else
                                    PurchRcptLine."Dimension Set ID" := FindNewDimSetID(PurchRcptLine."Dimension Set ID");

                                PurchRcptLine.MODIFY;
                                NChanged += 1;
                            until PurchRcptLine.NEXT = 0;
                    end;
                until PurchRcptHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindPurchInvoiceHeader()
    begin
        if PurchInvHeader.READPERMISSION then begin
            PurchInvHeader.RESET;
            PurchInvHeader.SETFILTER("No.", DocNoFilter);
            PurchInvHeader.SETFILTER("Posting Date", PostingDateFilter);
            if PurchInvHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PurchInvHeader."Dimension Set ID");
                    if ChangeDim1 then
                        PurchInvHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PurchInvHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if PurchInvHeader."Dimension Set ID" = DimSetIDFilter then
                        PurchInvHeader."Dimension Set ID" := NewDimSetID
                    else
                        PurchInvHeader."Dimension Set ID" := FindNewDimSetID(PurchInvHeader."Dimension Set ID");

                    PurchInvHeader.MODIFY;
                    NChanged += 1;

                    if PurchInvLine.READPERMISSION then begin
                        PurchInvLine.RESET;
                        PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                        if PurchInvLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(PurchInvLine."Dimension Set ID");
                                if ChangeDim1 then
                                    PurchInvLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    PurchInvLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if PurchInvLine."Dimension Set ID" = DimSetIDFilter then
                                    PurchInvLine."Dimension Set ID" := NewDimSetID
                                else
                                    PurchInvLine."Dimension Set ID" := FindNewDimSetID(PurchInvLine."Dimension Set ID");

                                PurchInvLine.MODIFY;
                                NChanged += 1;
                            until PurchInvLine.NEXT = 0;
                    end;
                until PurchInvHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindPurchCrMemoHeader()
    begin
        if PurchCrMemoHeader.READPERMISSION then begin
            PurchCrMemoHeader.RESET;
            PurchCrMemoHeader.SETFILTER("No.", DocNoFilter);
            PurchCrMemoHeader.SETFILTER("Posting Date", PostingDateFilter);
            if PurchCrMemoHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PurchCrMemoHeader."Dimension Set ID");
                    if ChangeDim1 then
                        PurchCrMemoHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PurchCrMemoHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if PurchCrMemoHeader."Dimension Set ID" = DimSetIDFilter then
                        PurchCrMemoHeader."Dimension Set ID" := NewDimSetID
                    else
                        PurchCrMemoHeader."Dimension Set ID" := FindNewDimSetID(PurchCrMemoHeader."Dimension Set ID");

                    PurchCrMemoHeader.MODIFY;
                    NChanged += 1;

                    if PurchCrMemoLine.READPERMISSION then begin
                        PurchCrMemoLine.RESET;
                        PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
                        if PurchCrMemoLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(PurchCrMemoLine."Dimension Set ID");
                                if ChangeDim1 then
                                    PurchCrMemoLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    PurchCrMemoLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if PurchCrMemoLine."Dimension Set ID" = DimSetIDFilter then
                                    PurchCrMemoLine."Dimension Set ID" := NewDimSetID
                                else
                                    PurchCrMemoLine."Dimension Set ID" := FindNewDimSetID(PurchCrMemoLine."Dimension Set ID");

                                PurchCrMemoLine.MODIFY;
                                NChanged += 1;
                            until PurchCrMemoLine.NEXT = 0;
                    end;
                until PurchCrMemoHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindReturnShptHeader()
    begin
        if ReturnShptHeader.READPERMISSION then begin
            ReturnShptHeader.RESET;
            ReturnShptHeader.SETFILTER("No.", DocNoFilter);
            ReturnShptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if ReturnShptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ReturnShptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        ReturnShptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ReturnShptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if ReturnShptHeader."Dimension Set ID" = DimSetIDFilter then
                        ReturnShptHeader."Dimension Set ID" := NewDimSetID
                    else
                        ReturnShptHeader."Dimension Set ID" := FindNewDimSetID(ReturnShptHeader."Dimension Set ID");

                    ReturnShptHeader.MODIFY;
                    NChanged += 1;

                    if ReturnShptLine.READPERMISSION then begin
                        ReturnShptLine.RESET;
                        ReturnShptLine.SETRANGE("Document No.", ReturnShptHeader."No.");
                        if ReturnShptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(ReturnShptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    ReturnShptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    ReturnShptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if ReturnShptLine."Dimension Set ID" = DimSetIDFilter then
                                    ReturnShptLine."Dimension Set ID" := NewDimSetID
                                else
                                    ReturnShptLine."Dimension Set ID" := FindNewDimSetID(ReturnShptLine."Dimension Set ID");

                                ReturnShptLine.MODIFY;
                                NChanged += 1;
                            until ReturnShptLine.NEXT = 0;
                    end;
                until ReturnShptHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindProdOrderHeader()
    begin
    end;

    LOCAL procedure FindPostedAssemblyHeader()
    begin
    end;

    LOCAL procedure FindPostedWhseShptLine()
    begin
    end;

    LOCAL procedure FindPostedWhseRcptLine()
    begin
    end;

    LOCAL procedure FindPstdPhysInvtOrderHdr()
    begin
    end;

    LOCAL procedure FindTransShptHeader()
    begin
        if TransShptHeader.READPERMISSION then begin
            TransShptHeader.RESET;
            TransShptHeader.SETFILTER("No.", DocNoFilter);
            TransShptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if TransShptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(TransShptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        TransShptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        TransShptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if TransShptHeader."Dimension Set ID" = DimSetIDFilter then
                        TransShptHeader."Dimension Set ID" := NewDimSetID
                    else
                        TransShptHeader."Dimension Set ID" := FindNewDimSetID(TransShptHeader."Dimension Set ID");

                    TransShptHeader.MODIFY;
                    NChanged += 1;

                    if TransShptLine.READPERMISSION then begin
                        TransShptLine.RESET;
                        TransShptLine.SETRANGE("Document No.", TransShptHeader."No.");
                        if TransShptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(TransShptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    TransShptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    TransShptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if TransShptLine."Dimension Set ID" = DimSetIDFilter then
                                    TransShptLine."Dimension Set ID" := NewDimSetID
                                else
                                    TransShptLine."Dimension Set ID" := FindNewDimSetID(TransShptLine."Dimension Set ID");

                                TransShptLine.MODIFY;
                                NChanged += 1;
                            until TransShptLine.NEXT = 0;
                    end;
                until TransShptHeader.NEXT = 0;
        end;
    end;

    LOCAL procedure FindTransRcptHeader()
    begin
        if TransRcptHeader.READPERMISSION then begin
            TransRcptHeader.RESET;
            TransRcptHeader.SETFILTER("No.", DocNoFilter);
            TransRcptHeader.SETFILTER("Posting Date", PostingDateFilter);
            if TransRcptHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(TransRcptHeader."Dimension Set ID");
                    if ChangeDim1 then
                        TransRcptHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        TransRcptHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if TransRcptHeader."Dimension Set ID" = DimSetIDFilter then
                        TransRcptHeader."Dimension Set ID" := NewDimSetID
                    else
                        TransRcptHeader."Dimension Set ID" := FindNewDimSetID(TransRcptHeader."Dimension Set ID");

                    TransRcptHeader.MODIFY;
                    NChanged += 1;

                    if TransRcptLine.READPERMISSION then begin
                        TransRcptLine.RESET;
                        TransRcptLine.SETRANGE("Document No.", TransRcptHeader."No.");
                        if TransRcptLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(TransRcptLine."Dimension Set ID");
                                if ChangeDim1 then
                                    TransRcptLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    TransRcptLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if TransRcptLine."Dimension Set ID" = DimSetIDFilter then
                                    TransRcptLine."Dimension Set ID" := NewDimSetID
                                else
                                    TransRcptLine."Dimension Set ID" := FindNewDimSetID(TransRcptLine."Dimension Set ID");

                                TransRcptLine.MODIFY;
                                NChanged += 1;
                            until TransRcptLine.NEXT = 0;
                    end;
                until TransRcptHeader.NEXT = 0;
        end;
    end;


    //     procedure ChangeDimension (var TempDocumentEntry@1004 : TEMPORARY Record 265;DocTableID@1000 : Integer;DocType@1003 : Option;DocTableName@1001 : Text[1024];DocNoOfRecords@1002 :
    procedure ChangeDimension(var TempDocumentEntry: Record 265 TEMPORARY; DocTableID: Integer; DocType: Option; DocTableName: Text[1024]; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;

        WITH TempDocumentEntry DO begin
            INIT;
            "Entry No." := "Entry No." + 1;
            "Table ID" := DocTableID;
            "Document Type" := DocType;
            "Table Name" := COPYSTR(DocTableName, 1, MAXSTRLEN("Table Name"));
            "No. of Records" := DocNoOfRecords;
            INSERT;
        end;
    end;

    //     procedure FindCarteraDocs (AccountType@1100000 :
    procedure FindCarteraDocs(AccountType: Option "Customer","Vendor")
    begin
        if CarteraDoc.READPERMISSION then begin
            CarteraDoc.RESET;
            CarteraDoc.SETCURRENTKEY(Type, "Original Document No.");
            CarteraDoc.SETFILTER("Original Document No.", DocNoFilter);
            CarteraDoc.SETFILTER("Posting Date", PostingDateFilter);
            CarteraDoc.SETRANGE(Type, AccountType);
            if CarteraDoc.FINDSET(TRUE) then
                repeat
                    SetChangeDim(CarteraDoc."Dimension Set ID");
                    if ChangeDim1 then
                        CarteraDoc."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        CarteraDoc."Global Dimension 2 Code" := NewDimValue;

                    if CarteraDoc."Dimension Set ID" = DimSetIDFilter then
                        CarteraDoc."Dimension Set ID" := NewDimSetID
                    else
                        CarteraDoc."Dimension Set ID" := FindNewDimSetID(CarteraDoc."Dimension Set ID");

                    CarteraDoc.MODIFY;
                    NChanged += 1;
                until CarteraDoc.NEXT = 0;
        end;
        if PostedCarteraDoc.READPERMISSION then begin
            PostedCarteraDoc.RESET;
            PostedCarteraDoc.SETCURRENTKEY(Type, "Original Document No.");
            PostedCarteraDoc.SETFILTER("Original Document No.", DocNoFilter);
            PostedCarteraDoc.SETFILTER("Posting Date", PostingDateFilter);
            if PostedCarteraDoc.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PostedCarteraDoc."Dimension Set ID");
                    if ChangeDim1 then
                        PostedCarteraDoc."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PostedCarteraDoc."Global Dimension 2 Code" := NewDimValue;

                    if PostedCarteraDoc."Dimension Set ID" = DimSetIDFilter then
                        PostedCarteraDoc."Dimension Set ID" := NewDimSetID
                    else
                        PostedCarteraDoc."Dimension Set ID" := FindNewDimSetID(PostedCarteraDoc."Dimension Set ID");

                    PostedCarteraDoc.MODIFY;
                    NChanged += 1;
                until PostedCarteraDoc.NEXT = 0;
        end;
        if ClosedCarteraDoc.READPERMISSION then begin
            ClosedCarteraDoc.RESET;
            ClosedCarteraDoc.SETCURRENTKEY(Type, "Original Document No.");
            ClosedCarteraDoc.SETFILTER("Original Document No.", DocNoFilter);
            ClosedCarteraDoc.SETFILTER("Posting Date", PostingDateFilter);
            ClosedCarteraDoc.SETRANGE(Type, AccountType);
            if ClosedCarteraDoc.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ClosedCarteraDoc."Dimension Set ID");
                    if ChangeDim1 then
                        ClosedCarteraDoc."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ClosedCarteraDoc."Global Dimension 2 Code" := NewDimValue;

                    if ClosedCarteraDoc."Dimension Set ID" = DimSetIDFilter then
                        ClosedCarteraDoc."Dimension Set ID" := NewDimSetID
                    else
                        ClosedCarteraDoc."Dimension Set ID" := FindNewDimSetID(ClosedCarteraDoc."Dimension Set ID");

                    ClosedCarteraDoc.MODIFY;
                    NChanged += 1;
                until ClosedCarteraDoc.NEXT = 0;
        end;
    end;

    procedure FindQuoBuildingDocuments()
    var
        //       Navigate@7001115 :
        Navigate: Page 344;
    begin
        //Incluir los documentos propios de QuoBuilding en la Navegaci¢n de documentos
        if WorksheetHeaderHist.READPERMISSION then begin
            WorksheetHeaderHist.RESET;
            WorksheetHeaderHist.SETCURRENTKEY("No.");
            WorksheetHeaderHist.SETFILTER("No.", DocNoFilter);
            WorksheetHeaderHist.SETFILTER("Posting Date", PostingDateFilter);
            if WorksheetHeaderHist.FINDSET(TRUE) then
                repeat
                    SetChangeDim(WorksheetHeaderHist."Dimension Set ID");
                    if ChangeDim1 then
                        WorksheetHeaderHist."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        WorksheetHeaderHist."Shortcut Dimension 2 Code" := NewDimValue;

                    if WorksheetHeaderHist."Dimension Set ID" = DimSetIDFilter then
                        WorksheetHeaderHist."Dimension Set ID" := NewDimSetID
                    else
                        WorksheetHeaderHist."Dimension Set ID" := FindNewDimSetID(WorksheetHeaderHist."Dimension Set ID");

                    WorksheetHeaderHist.MODIFY;
                    NChanged += 1;
                until WorksheetHeaderHist.NEXT = 0;
        end;

        if HistMeasurements.READPERMISSION then begin
            HistMeasurements.RESET;
            HistMeasurements.SETCURRENTKEY("No.");
            HistMeasurements.SETFILTER("No.", DocNoFilter);
            HistMeasurements.SETFILTER("Posting Date", PostingDateFilter);
            if HistMeasurements.FINDSET(TRUE) then
                repeat
                    SetChangeDim(HistMeasurements."Dimension Set ID");
                    if ChangeDim1 then
                        HistMeasurements."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        HistMeasurements."Shortcut Dimension 2 Code" := NewDimValue;

                    if HistMeasurements."Dimension Set ID" = DimSetIDFilter then
                        HistMeasurements."Dimension Set ID" := NewDimSetID
                    else
                        HistMeasurements."Dimension Set ID" := FindNewDimSetID(HistMeasurements."Dimension Set ID");

                    HistMeasurements.MODIFY;
                    NChanged += 1;

                    if HistMeasurementsLine.READPERMISSION then begin
                        HistMeasurementsLine.RESET;
                        HistMeasurementsLine.SETRANGE("Document No.", HistMeasurements."No.");
                        if HistMeasurementsLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(HistMeasurementsLine."Dimension Set ID");
                                if ChangeDim1 then
                                    HistMeasurementsLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    HistMeasurementsLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if HistMeasurementsLine."Dimension Set ID" = DimSetIDFilter then
                                    HistMeasurementsLine."Dimension Set ID" := NewDimSetID
                                else
                                    HistMeasurementsLine."Dimension Set ID" := FindNewDimSetID(HistMeasurementsLine."Dimension Set ID");

                                HistMeasurementsLine.MODIFY;
                                NChanged += 1;
                            until HistMeasurementsLine.NEXT = 0;
                    end;
                until HistMeasurements.NEXT = 0;
        end;

        if PostCertifications.READPERMISSION then begin
            PostCertifications.RESET;
            PostCertifications.SETCURRENTKEY("No.");
            PostCertifications.SETFILTER("No.", DocNoFilter);
            PostCertifications.SETFILTER("Posting Date", PostingDateFilter);
            if PostCertifications.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PostCertifications."Dimension Set ID");
                    if ChangeDim1 then
                        PostCertifications."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PostCertifications."Shortcut Dimension 2 Code" := NewDimValue;

                    if PostCertifications."Dimension Set ID" = DimSetIDFilter then
                        PostCertifications."Dimension Set ID" := NewDimSetID
                    else
                        PostCertifications."Dimension Set ID" := FindNewDimSetID(PostCertifications."Dimension Set ID");

                    PostCertifications.MODIFY;
                    NChanged += 1;

                    if PostCertificationsLine.READPERMISSION then begin
                        PostCertificationsLine.RESET;
                        PostCertificationsLine.SETRANGE("Document No.", PostCertifications."No.");
                        if PostCertificationsLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(PostCertificationsLine."Dimension Set ID");
                                if ChangeDim1 then
                                    PostCertificationsLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    PostCertificationsLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if PostCertificationsLine."Dimension Set ID" = DimSetIDFilter then
                                    PostCertificationsLine."Dimension Set ID" := NewDimSetID
                                else
                                    PostCertificationsLine."Dimension Set ID" := FindNewDimSetID(PostCertificationsLine."Dimension Set ID");

                                PostCertificationsLine.MODIFY;
                                NChanged += 1;
                            until PostCertificationsLine.NEXT = 0;
                    end;
                until PostCertifications.NEXT = 0;
        end;

        if HistProdMeasureHeader.READPERMISSION then begin
            HistProdMeasureHeader.RESET;
            HistProdMeasureHeader.SETCURRENTKEY("No.");
            HistProdMeasureHeader.SETFILTER("No.", DocNoFilter);
            HistProdMeasureHeader.SETFILTER("Posting Date", PostingDateFilter);
            if HistProdMeasureHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(HistProdMeasureHeader."Dimension Set ID");
                    if ChangeDim1 then
                        HistProdMeasureHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        HistProdMeasureHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if HistProdMeasureHeader."Dimension Set ID" = DimSetIDFilter then
                        HistProdMeasureHeader."Dimension Set ID" := NewDimSetID
                    else
                        HistProdMeasureHeader."Dimension Set ID" := FindNewDimSetID(HistProdMeasureHeader."Dimension Set ID");

                    HistProdMeasureHeader.MODIFY;
                    NChanged += 1;

                    if HistProdMeasureLine.READPERMISSION then begin
                        HistProdMeasureLine.RESET;
                        HistProdMeasureLine.SETRANGE("Document No.", HistProdMeasureHeader."No.");
                        if HistProdMeasureLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(HistProdMeasureLine."Dimension Set ID");
                                if ChangeDim1 then
                                    HistProdMeasureLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    HistProdMeasureLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if HistProdMeasureLine."Dimension Set ID" = DimSetIDFilter then
                                    HistProdMeasureLine."Dimension Set ID" := NewDimSetID
                                else
                                    HistProdMeasureLine."Dimension Set ID" := FindNewDimSetID(HistProdMeasureLine."Dimension Set ID");

                                HistProdMeasureLine.MODIFY;
                                NChanged += 1;
                            until HistProdMeasureLine.NEXT = 0;
                    end;
                until HistProdMeasureHeader.NEXT = 0;
        end;

        if PostedOutputShipmentHeader.READPERMISSION then begin
            PostedOutputShipmentHeader.RESET;
            PostedOutputShipmentHeader.SETCURRENTKEY(PostedOutputShipmentHeader."No.");
            PostedOutputShipmentHeader.SETFILTER(PostedOutputShipmentHeader."No.", DocNoFilter);
            PostedOutputShipmentHeader.SETFILTER(PostedOutputShipmentHeader."Posting Date", PostingDateFilter);
            if PostedOutputShipmentHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PostedOutputShipmentHeader."Dimension Set ID");
                    if ChangeDim1 then
                        PostedOutputShipmentHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PostedOutputShipmentHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if PostedOutputShipmentHeader."Dimension Set ID" = DimSetIDFilter then
                        PostedOutputShipmentHeader."Dimension Set ID" := NewDimSetID
                    else
                        PostedOutputShipmentHeader."Dimension Set ID" := FindNewDimSetID(PostedOutputShipmentHeader."Dimension Set ID");

                    PostedOutputShipmentHeader.MODIFY;
                    NChanged += 1;

                    if PostedOutputShipmentLine.READPERMISSION then begin
                        PostedOutputShipmentLine.RESET;
                        PostedOutputShipmentLine.SETRANGE("Document No.", PostedOutputShipmentHeader."No.");
                        if PostedOutputShipmentLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(PostedOutputShipmentLine."Dimension Set ID");
                                if ChangeDim1 then
                                    PostedOutputShipmentLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    PostedOutputShipmentLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if PostedOutputShipmentLine."Dimension Set ID" = DimSetIDFilter then
                                    PostedOutputShipmentLine."Dimension Set ID" := NewDimSetID
                                else
                                    PostedOutputShipmentLine."Dimension Set ID" := FindNewDimSetID(PostedOutputShipmentLine."Dimension Set ID");

                                PostedOutputShipmentLine.MODIFY;
                                NChanged += 1;
                            until PostedOutputShipmentLine.NEXT = 0;
                    end;
                until PostedOutputShipmentHeader.NEXT = 0;
        end;

        //si tenemos albaranes de consumo que se han generado desde ventas los mostramos.
        if PostedOutputShipmentHeader2.READPERMISSION then begin
            PostedOutputShipmentHeader2.RESET;
            PostedOutputShipmentHeader2.SETCURRENTKEY("Sales Document No.", "Posting Date");
            PostedOutputShipmentHeader2.SETFILTER("Sales Document No.", DocNoFilter);
            PostedOutputShipmentHeader2.SETFILTER("Posting Date", PostingDateFilter);
            if PostedOutputShipmentHeader2.FINDSET(TRUE) then
                repeat
                    SetChangeDim(PostedOutputShipmentHeader2."Dimension Set ID");
                    if ChangeDim1 then
                        PostedOutputShipmentHeader2."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        PostedOutputShipmentHeader2."Shortcut Dimension 2 Code" := NewDimValue;

                    if PostedOutputShipmentHeader2."Dimension Set ID" = DimSetIDFilter then
                        PostedOutputShipmentHeader2."Dimension Set ID" := NewDimSetID
                    else
                        PostedOutputShipmentHeader2."Dimension Set ID" := FindNewDimSetID(PostedOutputShipmentHeader2."Dimension Set ID");

                    PostedOutputShipmentHeader2.MODIFY;
                    NChanged += 1;

                    if PostedOutputShipmentLine.READPERMISSION then begin
                        PostedOutputShipmentLine.RESET;
                        PostedOutputShipmentLine.SETRANGE("Document No.", PostedOutputShipmentHeader2."No.");
                        if PostedOutputShipmentLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(PostedOutputShipmentLine."Dimension Set ID");
                                if ChangeDim1 then
                                    PostedOutputShipmentLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    PostedOutputShipmentLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if PostedOutputShipmentLine."Dimension Set ID" = DimSetIDFilter then
                                    PostedOutputShipmentLine."Dimension Set ID" := NewDimSetID
                                else
                                    PostedOutputShipmentLine."Dimension Set ID" := FindNewDimSetID(PostedOutputShipmentLine."Dimension Set ID");

                                PostedOutputShipmentLine.MODIFY;
                                NChanged += 1;
                            until PostedOutputShipmentLine.NEXT = 0;
                    end;
                until PostedOutputShipmentHeader2.NEXT = 0;
        end;

        if HistReestimationHeader.READPERMISSION then begin
            HistReestimationHeader.RESET;
            HistReestimationHeader.SETCURRENTKEY(HistReestimationHeader."No.");
            HistReestimationHeader.SETFILTER(HistReestimationHeader."No.", DocNoFilter);
            HistReestimationHeader.SETFILTER(HistReestimationHeader."Posting Date", PostingDateFilter);
            if HistReestimationHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(HistReestimationHeader."Dimension Set ID");
                    if ChangeDim1 then
                        HistReestimationHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        HistReestimationHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if HistReestimationHeader."Dimension Set ID" = DimSetIDFilter then
                        HistReestimationHeader."Dimension Set ID" := NewDimSetID
                    else
                        HistReestimationHeader."Dimension Set ID" := FindNewDimSetID(HistReestimationHeader."Dimension Set ID");

                    HistReestimationHeader.MODIFY;
                    NChanged += 1;

                    if HistReestimationLine.READPERMISSION then begin
                        HistReestimationLine.RESET;
                        HistReestimationLine.SETRANGE("Document No.", HistReestimationHeader."No.");
                        if HistReestimationLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(HistReestimationLine."Dimension Set ID");
                                if ChangeDim1 then
                                    HistReestimationLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    HistReestimationLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if HistReestimationLine."Dimension Set ID" = DimSetIDFilter then
                                    HistReestimationLine."Dimension Set ID" := NewDimSetID
                                else
                                    HistReestimationLine."Dimension Set ID" := FindNewDimSetID(HistReestimationLine."Dimension Set ID");

                                HistReestimationLine.MODIFY;
                                NChanged += 1;
                            until HistReestimationLine.NEXT = 0;
                    end;
                until HistReestimationHeader.NEXT = 0;
        end;

        if CostsheetHeaderHist.READPERMISSION then begin
            CostsheetHeaderHist.RESET;
            CostsheetHeaderHist.SETCURRENTKEY(CostsheetHeaderHist."No.");
            CostsheetHeaderHist.SETFILTER(CostsheetHeaderHist."No.", DocNoFilter);
            CostsheetHeaderHist.SETFILTER(CostsheetHeaderHist."Posting Date", PostingDateFilter);
            if CostsheetHeaderHist.FINDSET(TRUE) then
                repeat
                    SetChangeDim(CostsheetHeaderHist."Dimension Set ID");
                    if ChangeDim1 then
                        CostsheetHeaderHist."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        CostsheetHeaderHist."Shortcut Dimension 2 Code" := NewDimValue;

                    if CostsheetHeaderHist."Dimension Set ID" = DimSetIDFilter then
                        CostsheetHeaderHist."Dimension Set ID" := NewDimSetID
                    else
                        CostsheetHeaderHist."Dimension Set ID" := FindNewDimSetID(CostsheetHeaderHist."Dimension Set ID");

                    CostsheetHeaderHist.MODIFY;
                    NChanged += 1;

                    if CostsheetHeaderHistLine.READPERMISSION then begin
                        CostsheetHeaderHistLine.RESET;
                        CostsheetHeaderHistLine.SETRANGE("Document No.", HistReestimationHeader."No.");
                        if CostsheetHeaderHistLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(CostsheetHeaderHistLine."Dimension Set ID");
                                if ChangeDim1 then
                                    CostsheetHeaderHistLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    CostsheetHeaderHistLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if CostsheetHeaderHistLine."Dimension Set ID" = DimSetIDFilter then
                                    CostsheetHeaderHistLine."Dimension Set ID" := NewDimSetID
                                else
                                    CostsheetHeaderHistLine."Dimension Set ID" := FindNewDimSetID(CostsheetHeaderHistLine."Dimension Set ID");

                                CostsheetHeaderHistLine.MODIFY;
                                NChanged += 1;
                            until CostsheetHeaderHistLine.NEXT = 0;
                    end;
                until CostsheetHeaderHist.NEXT = 0;
        end;

        if HistExpenseNotesHeader.READPERMISSION then begin
            HistExpenseNotesHeader.RESET;
            HistExpenseNotesHeader.SETCURRENTKEY(HistExpenseNotesHeader."No.");
            HistExpenseNotesHeader.SETFILTER(HistExpenseNotesHeader."No.", DocNoFilter);
            HistExpenseNotesHeader.SETFILTER(HistExpenseNotesHeader."Posting Date", PostingDateFilter);
            if HistExpenseNotesHeader.FINDSET(TRUE) then
                repeat
                    SetChangeDim(HistExpenseNotesHeader."Dimension Set ID");
                    if ChangeDim1 then
                        HistExpenseNotesHeader."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        HistExpenseNotesHeader."Shortcut Dimension 2 Code" := NewDimValue;

                    if HistExpenseNotesHeader."Dimension Set ID" = DimSetIDFilter then
                        HistExpenseNotesHeader."Dimension Set ID" := NewDimSetID
                    else
                        HistExpenseNotesHeader."Dimension Set ID" := FindNewDimSetID(HistExpenseNotesHeader."Dimension Set ID");

                    HistExpenseNotesHeader.MODIFY;
                    NChanged += 1;

                    if HistExpenseNotesLine.READPERMISSION then begin
                        HistExpenseNotesLine.RESET;
                        HistExpenseNotesLine.SETRANGE("Document No.", HistExpenseNotesHeader."No.");
                        if HistExpenseNotesLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(HistExpenseNotesLine."Dimension Set ID");
                                if ChangeDim1 then
                                    HistExpenseNotesLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    HistExpenseNotesLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if HistExpenseNotesLine."Dimension Set ID" = DimSetIDFilter then
                                    HistExpenseNotesLine."Dimension Set ID" := NewDimSetID
                                else
                                    HistExpenseNotesLine."Dimension Set ID" := FindNewDimSetID(HistExpenseNotesLine."Dimension Set ID");

                                HistExpenseNotesLine.MODIFY;
                                NChanged += 1;
                            until HistExpenseNotesLine.NEXT = 0;
                    end;
                until HistExpenseNotesHeader.NEXT = 0;
        end;

        if UsageHeaderHist.READPERMISSION then begin
            UsageHeaderHist.RESET;
            UsageHeaderHist.SETCURRENTKEY(UsageHeaderHist."No.");
            UsageHeaderHist.SETFILTER(UsageHeaderHist."No.", DocNoFilter);
            UsageHeaderHist.SETFILTER(UsageHeaderHist."Posting Date", PostingDateFilter);
            if UsageHeaderHist.FINDSET(TRUE) then
                repeat
                    SetChangeDim(UsageHeaderHist."Dimension Set ID");
                    if ChangeDim1 then
                        UsageHeaderHist."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        UsageHeaderHist."Shortcut Dimension 2 Code" := NewDimValue;

                    if UsageHeaderHist."Dimension Set ID" = DimSetIDFilter then
                        UsageHeaderHist."Dimension Set ID" := NewDimSetID
                    else
                        UsageHeaderHist."Dimension Set ID" := FindNewDimSetID(UsageHeaderHist."Dimension Set ID");

                    UsageHeaderHist.MODIFY;
                    NChanged += 1;

                    if UsageHeaderHistLine.READPERMISSION then begin
                        UsageHeaderHistLine.RESET;
                        UsageHeaderHistLine.SETRANGE("Document No.", UsageHeaderHist."No.");
                        if UsageHeaderHistLine.FINDSET(TRUE) then
                            repeat
                                SetChangeDim(UsageHeaderHistLine."Dimension Set ID");
                                if ChangeDim1 then
                                    UsageHeaderHistLine."Shortcut Dimension 1 Code" := NewDimValue;
                                if ChangeDim2 then
                                    UsageHeaderHistLine."Shortcut Dimension 2 Code" := NewDimValue;

                                if UsageHeaderHistLine."Dimension Set ID" = DimSetIDFilter then
                                    UsageHeaderHistLine."Dimension Set ID" := NewDimSetID
                                else
                                    UsageHeaderHistLine."Dimension Set ID" := FindNewDimSetID(UsageHeaderHistLine."Dimension Set ID");

                                UsageHeaderHistLine.MODIFY;
                                NChanged += 1;
                            until UsageHeaderHistLine.NEXT = 0;
                    end;
                until UsageHeaderHist.NEXT = 0;
        end;

        if ActivationHeaderHist.READPERMISSION then begin
            ActivationHeaderHist.RESET;
            ActivationHeaderHist.SETCURRENTKEY(ActivationHeaderHist."No.");
            ActivationHeaderHist.SETFILTER(ActivationHeaderHist."No.", DocNoFilter);
            ActivationHeaderHist.SETFILTER(ActivationHeaderHist."Posting Date", PostingDateFilter);
            if ActivationHeaderHist.FINDSET(TRUE) then
                repeat
                    SetChangeDim(ActivationHeaderHist."Dimension Set ID");
                    if ChangeDim1 then
                        ActivationHeaderHist."Shortcut Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        ActivationHeaderHist."Shortcut Dimension 2 Code" := NewDimValue;

                    if ActivationHeaderHist."Dimension Set ID" = DimSetIDFilter then
                        ActivationHeaderHist."Dimension Set ID" := NewDimSetID
                    else
                        ActivationHeaderHist."Dimension Set ID" := FindNewDimSetID(ActivationHeaderHist."Dimension Set ID");

                    ActivationHeaderHist.MODIFY;
                    NChanged += 1;
                until ActivationHeaderHist.NEXT = 0;
        end;

        if RentalElementsEntries.READPERMISSION then begin
            RentalElementsEntries.RESET;
            RentalElementsEntries.SETCURRENTKEY("Document No.", "Posting Date");
            RentalElementsEntries.SETFILTER("Document No.", DocNoFilter);
            RentalElementsEntries.SETFILTER("Posting Date", PostingDateFilter);
            if RentalElementsEntries.FINDSET(TRUE) then
                repeat
                    SetChangeDim(RentalElementsEntries."Dimension Set ID");
                    if ChangeDim1 then
                        RentalElementsEntries."Global Dimension 1 Code" := NewDimValue;
                    if ChangeDim2 then
                        RentalElementsEntries."Global Dimension 2 Code" := NewDimValue;

                    if RentalElementsEntries."Dimension Set ID" = DimSetIDFilter then
                        RentalElementsEntries."Dimension Set ID" := NewDimSetID
                    else
                        RentalElementsEntries."Dimension Set ID" := FindNewDimSetID(RentalElementsEntries."Dimension Set ID");

                    RentalElementsEntries.MODIFY;
                    NChanged += 1;
                until RentalElementsEntries.NEXT = 0;
        end;
    end;

    /*begin
    end.
  */

}




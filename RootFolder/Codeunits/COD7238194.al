Codeunit 7238194 "QRE - Codeunit - Subscriber"
{


    Permissions = TableData 112 = rimd,
                TableData 114 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        TempPurchLineGlobal: Record 39 TEMPORARY;
        DefaultDim: Record 352;
        DimSetEntry: Record 480;
        DimValuePostingErr: Text[250];
        ObjTransl: Record 377;
        DimErr: Text[250];
        TempSalesLineGlobal: Record 37 TEMPORARY;
        TempDimBuf1: Record 360 TEMPORARY;
        DimCombErr: Text[250];
        TempDimCombInitialized: Boolean;
        TempDimCombEmpty: Boolean;
        DimValComb: Record 351;
        Text000: TextConst ENU = 'Dimensions %1 and %2 can''t be used concurrently.', ESP = 'Dimensiones %1 y %2 no pueden usarse simult�neam.';
        Text001: TextConst ENU = 'Dimension combinations %1 - %2 and %3 - %4 can''t be used concurrently.', ESP = 'Combin. dimensi�n %1 - %2 y %3 - %4 no pueden usarse al mismo tiempo.';
        Text004: TextConst ENU = 'Select a %1 for the %2 %3.', ESP = 'Selecc. %1 para el %2 %3.';
        Text005: TextConst ENU = 'Select a %1 for the %2 %3 for %4 %5.', ESP = 'Selecc. %1 para el %2 %3 para %4 %5.';
        Text006: TextConst ENU = 'Select %1 %2 for the %3 %4.', ESP = 'Selecc. %1 %2 para el %3 %4.';
        Text007: TextConst ENU = 'Select %1 %2 for the %3 %4 for %5 %6.', ESP = 'Selecc. %1 %2 para el %3 %4 para %5 %6.';
        Text008: TextConst ENU = '%1 %2 must be blank.', ESP = '%1 %2 debe ser blanco.';
        Text009: TextConst ENU = '%1 %2 must be blank for %3 %4.', ESP = '%1 %2 debe ser blanco para %3 %4.';
        Text010: TextConst ENU = '%1 %2 must not be mentioned.', ESP = '%1 %2 no debe ser mencionado.';
        Text011: TextConst ENU = '%1 %2 must not be mentioned for %3 %4.', ESP = '%1 %2 no debe ser mencionado para %3 %4.';
        Text012: TextConst ENU = 'A dimension used in %1 %2, %3, %4 has caused an error. %5', ESP = 'La dimensi�n util. en %1 %2, %3, %4 ha causado error. %5';
        Text014: TextConst ENU = '%1 %2 is blocked.', ESP = '%1 %2 est� bloqueado.';
        Text015: TextConst ENU = '%1 %2 can''t be found.', ESP = '%1 %2 no puede encontrarse.';
        DimValueBlockedErr: TextConst ENU = '%1 %2 - %3 is blocked.', ESP = '%1 %2 - %3 est� bloq.';
        DimValueMissingErr: TextConst ENU = '%1 for %2 is missing.', ESP = '%1 para %2 se pierde.';
        DimValueMustNotBeErr: TextConst ENU = 'Dimension Value Type for %1 %2 - %3 must not be %4.', ESP = 'El tipo de valor de dimensi�n para %1 %2 - %3 no puede ser %4.';
        InvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2 are invalid (Error: %3).', ESP = 'Las dimensiones usadas en %1 %2 no son v lidas (error: %3).';
        LineInvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', ESP = 'Las dim. usadas en %1 %2, n§ l¡n. %3 no son v lidas (error: %4).';
        DimensionIsBlockedErr: TextConst ENU = 'The combination of dimensions used in %1 %2 is blocked (Error: %3).', ESP = 'La combinaci�n de dimensiones usada en %1 %2 est� bloqueada (error: %3).';
        LineDimensionBlockedErr: TextConst ENU = 'The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).', ESP = 'La combinaci�n de dimensiones usada en %1 %2, n� l�nea %3 est� bloqueada (error:) %4.';

    [EventSubscriber(ObjectType::Codeunit, 415, OnAfterManualReopenPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE "Cod_415_Release Purchase Document_OnAfterManualReopenPurchaseDoc"(VAR PurchaseHeader: Record 38; PreviewMode: Boolean);
    VAR
        cuArchiveManagement: Codeunit 5063;
        PurchasesPayablesSetup: Record 312;
    BEGIN
        //Q17704
        PurchasesPayablesSetup.GET;
        IF PurchasesPayablesSetup."QB Archive when reopen" THEN
            cuArchiveManagement.StorePurchDocument(PurchaseHeader, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7206912, OnAfterReopenDocument, '', true, true)]
    LOCAL PROCEDURE "Cod_7206912_Release Purchase Document_OnAfterReopenDocument"(VAR Rec: Record 38);
    VAR
        cuArchiveManagement: Codeunit 5063;
        PurchasesPayablesSetup: Record 312;
    BEGIN
        //Q17704
        PurchasesPayablesSetup.GET;
        IF PurchasesPayablesSetup."QB Archive when reopen" THEN
            cuArchiveManagement.StorePurchDocument(Rec, FALSE);
    END;

    LOCAL PROCEDURE "-------------18420 Dimensiones"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterCheckPurchDoc, '', true, true)]
    LOCAL PROCEDURE Cod_90_OnAfterCheckPurchDoc(VAR PurchHeader: Record 38; CommitIsSupressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean);
    BEGIN
        //18420
        FillTempPurchLines(PurchHeader, TempPurchLineGlobal);
        CheckPurchDim(PurchHeader, TempPurchLineGlobal);
    END;

    //[External]
    PROCEDURE CopyToTempPurchLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    VAR
        PurchLine: Record 39;
    BEGIN
        //18420
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        IF PurchLine.FINDSET THEN
            REPEAT
                TempPurchLine := PurchLine;
                TempPurchLine.INSERT;
            UNTIL PurchLine.NEXT = 0;
    END;

    //[External]
    PROCEDURE FillTempPurchLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    BEGIN
        //18420
        TempPurchLine.RESET;
        IF TempPurchLine.ISEMPTY THEN
            CopyToTempPurchLines(PurchHeader, TempPurchLine);
    END;

    PROCEDURE CheckPurchDim(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    VAR
        TempPurchLineLocal: Record 39 TEMPORARY;
    BEGIN
        //18420
        //CheckPurchDimCombHeader(PurchHeader);
        CheckPurchDimValuePostingHeader(PurchHeader);

        TempPurchLineLocal.COPY(TempPurchLine, TRUE);
        CheckPurchDimLines(PurchHeader, TempPurchLineLocal);
    END;

    LOCAL PROCEDURE CheckPurchDimLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    BEGIN
        //18420
        WITH TempPurchLine DO BEGIN
            RESET;
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    IF (PurchHeader.Receive AND ("Qty. to Receive" <> 0)) OR
                       (PurchHeader.Invoice AND ("Qty. to Invoice" <> 0)) OR
                       (PurchHeader.Ship AND ("Return Qty. to Ship" <> 0))
                    THEN BEGIN
                        //CheckPurchDimCombLine(TempPurchLine);
                        CheckPurchDimValuePostingLine(TempPurchLine);
                    END
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CheckPurchDimValuePostingHeader(PurchHeader: Record 38);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
        DataPieceworkForProduction: Record 7207386;
        InvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2 are invalid (Error: %3).', ESP = 'Las dimensiones usadas en %1 %2 no son v�lidas (error: %3).';
        LineInvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', ESP = 'Las dim. usadas en %1 %2, n.� l�n. %3 no son v�lidas (error: %4).';
    BEGIN
        //18420
        WITH PurchHeader DO BEGIN
            TableIDArr[1] := DATABASE::Vendor;
            NumberArr[1] := "Pay-to Vendor No.";
            TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
            NumberArr[2] := "Purchaser Code";
            TableIDArr[3] := DATABASE::Campaign;
            NumberArr[3] := "Campaign No.";
            TableIDArr[4] := DATABASE::"Responsibility Center";
            NumberArr[4] := "Responsibility Center";
            //-18420
            IF ("QB Job No." <> '') AND ("QB Budget item" <> '') THEN BEGIN
                TableIDArr[5] := DATABASE::"Data Piecework For Production";
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", "QB Job No.");
                DataPieceworkForProduction.SETRANGE("Piecework Code", "QB Budget item");
                IF DataPieceworkForProduction.FINDFIRST THEN
                    NumberArr[5] := DataPieceworkForProduction."Unique Code";
            END;
            //+18420
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(InvalidDimensionsErr, "Document Type", "No.", GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE CheckPurchDimValuePostingLine(PurchLine: Record 39);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
        DataPieceworkForProduction: Record 7207386;
        InvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2 are invalid (Error: %3).', ESP = 'Las dimensiones usadas en %1 %2 no son v�lidas (error: %3).';
        LineInvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', ESP = 'Las dim. usadas en %1 %2, n.� l�n. %3 no son v�lidas (error: %4).';
    BEGIN
        //18420
        WITH PurchLine DO BEGIN
            TableIDArr[1] := TypeToTableID3(ConvertDocumentTypeToOptionPurchaseLineType(Type));
            NumberArr[1] := "No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := "Job No.";
            TableIDArr[3] := DATABASE::"Work Center";
            NumberArr[3] := "Work Center No.";
            //-18420
            IF ("Job No." <> '') AND ("Piecework No." <> '') THEN BEGIN
                TableIDArr[4] := DATABASE::"Data Piecework For Production";
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                DataPieceworkForProduction.SETRANGE("Piecework Code", "Piecework No.");
                IF DataPieceworkForProduction.FINDFIRST THEN
                    NumberArr[4] := DataPieceworkForProduction."Unique Code";
            END;
            //+18420
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(LineInvalidDimensionsErr, "Document Type", "Document No.", "Line No.", GetDimValuePostingErr);
        END;
    END;

    //[External]
    PROCEDURE CheckDimValuePosting(TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]; DimSetID: Integer): Boolean;
    VAR
        i: Integer;
        j: Integer;
        NoFilter: ARRAY[2] OF Text[250];
        IsHandled: Boolean;
        IsChecked: Boolean;
    BEGIN
        //18420
        IsChecked := FALSE;
        IsHandled := FALSE;
        //OnBeforeCheckDimValuePosting(TableID,No,DimSetID,IsChecked,IsHandled);
        IF IsHandled THEN
            EXIT(IsChecked);

        IF NOT CheckBlockedDimAndValues(DimSetID) THEN
            EXIT(FALSE);

        DefaultDim.SETFILTER("Value Posting", '<>%1', DefaultDim."Value Posting"::" ");
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        NoFilter[2] := '';
        FOR i := 1 TO ARRAYLEN(TableID) DO BEGIN
            IF (TableID[i] <> 0) AND (No[i] <> '') THEN BEGIN
                DefaultDim.SETRANGE("Table ID", TableID[i]);
                NoFilter[1] := No[i];
                FOR j := 1 TO 2 DO BEGIN
                    DefaultDim.SETRANGE("No.", NoFilter[j]);
                    IF DefaultDim.FINDSET THEN
                        REPEAT
                            DimSetEntry.SETRANGE("Dimension Code", DefaultDim."Dimension Code");
                            CASE DefaultDim."Value Posting" OF
                                DefaultDim."Value Posting"::"Code Mandatory":
                                    BEGIN
                                        IF NOT DimSetEntry.FINDFIRST OR (DimSetEntry."Dimension Value Code" = '') THEN BEGIN
                                            IF DefaultDim."No." = '' THEN
                                                DimValuePostingErr :=
                                                  STRSUBSTNO(
                                                    Text004,
                                                    DefaultDim.FIELDCAPTION("Dimension Value Code"),
                                                    DefaultDim.FIELDCAPTION("Dimension Code"), DefaultDim."Dimension Code")
                                            ELSE
                                                DimValuePostingErr :=
                                                  STRSUBSTNO(
                                                    Text005,
                                                    DefaultDim.FIELDCAPTION("Dimension Value Code"),
                                                    DefaultDim.FIELDCAPTION("Dimension Code"),
                                                    DefaultDim."Dimension Code",
                                                    ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DefaultDim."Table ID"),
                                                    DefaultDim."No.");
                                            EXIT(FALSE);
                                        END;
                                    END;
                                DefaultDim."Value Posting"::"Same Code":
                                    BEGIN
                                        IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
                                            IF NOT DimSetEntry.FINDFIRST OR
                                               (DefaultDim."Dimension Value Code" <> DimSetEntry."Dimension Value Code")
                                            THEN BEGIN
                                                IF DefaultDim."No." = '' THEN
                                                    DimValuePostingErr :=
                                                      STRSUBSTNO(
                                                        Text006,
                                                        DefaultDim.FIELDCAPTION("Dimension Value Code"), DefaultDim."Dimension Value Code",
                                                        DefaultDim.FIELDCAPTION("Dimension Code"), DefaultDim."Dimension Code")
                                                ELSE
                                                    DimValuePostingErr :=
                                                      STRSUBSTNO(
                                                        Text007,
                                                        DefaultDim.FIELDCAPTION("Dimension Value Code"),
                                                        DefaultDim."Dimension Value Code",
                                                        DefaultDim.FIELDCAPTION("Dimension Code"),
                                                        DefaultDim."Dimension Code",
                                                        ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DefaultDim."Table ID"),
                                                        DefaultDim."No.");
                                                EXIT(FALSE);
                                            END;
                                        END ELSE BEGIN
                                            IF DimSetEntry.FINDFIRST THEN BEGIN
                                                IF DefaultDim."No." = '' THEN
                                                    DimValuePostingErr :=
                                                      STRSUBSTNO(
                                                        Text008,
                                                        DimSetEntry.FIELDCAPTION("Dimension Code"), DimSetEntry."Dimension Code")
                                                ELSE
                                                    DimValuePostingErr :=
                                                      STRSUBSTNO(
                                                        Text009,
                                                        DimSetEntry.FIELDCAPTION("Dimension Code"),
                                                        DimSetEntry."Dimension Code",
                                                        ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DefaultDim."Table ID"),
                                                        DefaultDim."No.");
                                                EXIT(FALSE);
                                            END;
                                        END;
                                    END;
                                DefaultDim."Value Posting"::"No Code":
                                    BEGIN
                                        IF DimSetEntry.FINDFIRST THEN BEGIN
                                            IF DefaultDim."No." = '' THEN
                                                DimValuePostingErr :=
                                                  STRSUBSTNO(
                                                    Text010,
                                                    DimSetEntry.FIELDCAPTION("Dimension Code"), DimSetEntry."Dimension Code")
                                            ELSE
                                                DimValuePostingErr :=
                                                  STRSUBSTNO(
                                                    Text011,
                                                    DimSetEntry.FIELDCAPTION("Dimension Code"),
                                                    DimSetEntry."Dimension Code",
                                                    ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DefaultDim."Table ID"),
                                                    DefaultDim."No.");
                                            EXIT(FALSE);
                                        END;
                                    END;
                            END;
                        UNTIL DefaultDim.NEXT = 0;
                END;
            END;
        END;
        DimSetEntry.RESET;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE GetDimValuePostingErr(): Text[250];
    BEGIN
        //18420
        EXIT(DimValuePostingErr);
    END;

    //[External]
    PROCEDURE TypeToTableID3(Type: Option " ","G/L Account","Item","Resource","Fixed Asset","Charge (Item)"): Integer;
    BEGIN
        //18420
        CASE Type OF
            Type::" ":
                EXIT(0);
            Type::"G/L Account":
                EXIT(DATABASE::"G/L Account");
            Type::Item:
                EXIT(DATABASE::Item);
            Type::Resource:
                EXIT(DATABASE::Resource);
            Type::"Fixed Asset":
                EXIT(DATABASE::"Fixed Asset");
            Type::"Charge (Item)":
                EXIT(DATABASE::"Item Charge");
        END;
    END;

    LOCAL PROCEDURE CheckBlockedDimAndValues(DimSetID: Integer): Boolean;
    VAR
        DimSetEntry: Record 480;
    BEGIN
        //18420
        IF DimSetID = 0 THEN
            EXIT(TRUE);
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        IF DimSetEntry.FINDSET THEN
            REPEAT
                IF NOT CheckDim(DimSetEntry."Dimension Code") OR
                   NOT CheckDimValue(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
                THEN BEGIN
                    DimValuePostingErr := DimErr;
                    EXIT(FALSE);
                END;
            UNTIL DimSetEntry.NEXT = 0;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE CheckDim(DimCode: Code[20]): Boolean;
    VAR
        Dim: Record 348;
    BEGIN
        //18420
        IF Dim.GET(DimCode) THEN BEGIN
            IF Dim.Blocked THEN BEGIN
                DimErr :=
                  STRSUBSTNO(Text014, Dim.TABLECAPTION, DimCode);
                EXIT(FALSE);
            END;
        END ELSE BEGIN
            DimErr :=
              STRSUBSTNO(Text015, Dim.TABLECAPTION, DimCode);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE CheckDimValue(DimCode: Code[20]; DimValCode: Code[20]): Boolean;
    VAR
        DimVal: Record 349;
    BEGIN
        //18420
        IF (DimCode <> '') AND (DimValCode <> '') THEN BEGIN
            IF DimVal.GET(DimCode, DimValCode) THEN BEGIN
                IF DimVal.Blocked THEN BEGIN
                    DimErr := STRSUBSTNO(DimValueBlockedErr, DimVal.TABLECAPTION, DimCode, DimValCode);
                    EXIT(FALSE);
                END;
                IF NOT CheckDimValueAllowed(DimVal) THEN
                    EXIT(FALSE);
            END ELSE BEGIN
                DimErr :=
                  STRSUBSTNO(DimValueMissingErr, DimVal.TABLECAPTION, DimCode);
                EXIT(FALSE);
            END;
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckDimValueAllowed(DimVal: Record 349): Boolean;
    VAR
        DimValueAllowed: Boolean;
    BEGIN
        //18420
        DimValueAllowed :=
          (DimVal."Dimension Value Type" IN [DimVal."Dimension Value Type"::Standard, DimVal."Dimension Value Type"::"Begin-Total"]);
        IF NOT DimValueAllowed THEN
            DimErr :=
              STRSUBSTNO(
                DimValueMustNotBeErr, DimVal.TABLECAPTION, DimVal."Dimension Code", DimVal.Code, FORMAT(DimVal."Dimension Value Type"))
        ELSE
            OnCheckDimValueAllowed(DimVal, DimValueAllowed, DimErr);

        EXIT(DimValueAllowed);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckDimValueAllowed(DimVal: Record 349; VAR DimValueAllowed: Boolean; VAR DimErr: Text[250]);
    BEGIN
        //18420
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterCheckSalesDoc, '', true, true)]
    LOCAL PROCEDURE Cod_80_OnAfterCheckSalesDoc(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean);
    BEGIN
        //18420
        FillTempSalesLines(SalesHeader, TempSalesLineGlobal);
        CheckSalesDim(SalesHeader, TempSalesLineGlobal);
    END;

    PROCEDURE CheckSalesDim(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    VAR
        TempSalesLineLocal: Record 37 TEMPORARY;
    BEGIN
        //18420
        //CheckSalesDimCombHeader(SalesHeader);
        CheckSalesDimValuePostingHeader(SalesHeader);

        TempSalesLineLocal.COPY(TempSalesLine, TRUE);
        CheckSalesDimLines(SalesHeader, TempSalesLineLocal);
    END;

    LOCAL PROCEDURE CheckSalesDimLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
        //18420
        WITH TempSalesLine DO BEGIN
            RESET;
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    IF (SalesHeader.Invoice AND ("Qty. to Invoice" <> 0)) OR
                       (SalesHeader.Ship AND ("Qty. to Ship" <> 0)) OR
                       (SalesHeader.Receive AND ("Return Qty. to Receive" <> 0))
                    THEN BEGIN
                        CheckSalesDimCombLine(TempSalesLine);
                        CheckSalesDimValuePostingLine(TempSalesLine);
                    END
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CheckSalesDimValuePostingHeader(SalesHeader: Record 36);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //18420
        WITH SalesHeader DO BEGIN
            TableIDArr[1] := DATABASE::Customer;
            NumberArr[1] := "Bill-to Customer No.";
            TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
            NumberArr[2] := "Salesperson Code";
            TableIDArr[3] := DATABASE::Campaign;
            NumberArr[3] := "Campaign No.";
            TableIDArr[4] := DATABASE::"Responsibility Center";
            NumberArr[4] := "Responsibility Center";
            //-18420
            IF ("QB Job No." <> '') AND ("QB Budget item" <> '') THEN BEGIN
                TableIDArr[5] := DATABASE::"Data Piecework For Production";
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", "QB Job No.");
                DataPieceworkForProduction.SETRANGE("Piecework Code", "QB Budget item");
                IF DataPieceworkForProduction.FINDFIRST THEN
                    NumberArr[5] := DataPieceworkForProduction."Unique Code";
            END;
            //+18420
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(InvalidDimensionsErr, "Document Type", "No.", GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE CheckSalesDimValuePostingLine(SalesLine: Record 37);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //18420
        WITH SalesLine DO BEGIN
            TableIDArr[1] := TypeToTableID3(ConvertDocumentTypeToOptionPurchaseLineType(Type));
            NumberArr[1] := "No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := "Job No.";
            //-18420
            IF ("Job No." <> '') AND ("QB_Piecework No." <> '') THEN BEGIN
                TableIDArr[3] := DATABASE::"Data Piecework For Production";
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                DataPieceworkForProduction.SETRANGE("Piecework Code", "QB_Piecework No.");
                IF DataPieceworkForProduction.FINDFIRST THEN
                    NumberArr[3] := DataPieceworkForProduction."Unique Code";
            END;
            //+18420
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(LineInvalidDimensionsErr, "Document Type", "Document No.", "Line No.", GetDimValuePostingErr);
        END;
    END;

    //[External]
    PROCEDURE CopyToTempSalesLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    VAR
        SalesLine: Record 37;
    BEGIN
        //18420
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                TempSalesLine := SalesLine;
                TempSalesLine.INSERT;
            UNTIL SalesLine.NEXT = 0;
    END;

    //[External]
    PROCEDURE FillTempSalesLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
        //18420
        TempSalesLine.RESET;
        IF TempSalesLine.ISEMPTY THEN
            CopyToTempSalesLines(SalesHeader, TempSalesLine);
    END;

    LOCAL PROCEDURE CheckSalesDimCombLine(SalesLine: Record 37);
    BEGIN
        //18420
        WITH SalesLine DO
            IF NOT CheckDimIDComb("Dimension Set ID") THEN
                ERROR(LineDimensionBlockedErr, "Document Type", "Document No.", "Line No.", GetDimCombErr);
    END;

    //[External]
    PROCEDURE CheckDimIDComb(DimSetID: Integer): Boolean;
    BEGIN
        //18420
        TempDimBuf1.RESET;
        TempDimBuf1.DELETEALL;
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        IF DimSetEntry.FINDSET THEN
            REPEAT
                TempDimBuf1.INIT;
                TempDimBuf1."Table ID" := DATABASE::"Dimension Buffer";
                TempDimBuf1."Entry No." := 0;
                TempDimBuf1."Dimension Code" := DimSetEntry."Dimension Code";
                TempDimBuf1."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                TempDimBuf1.INSERT;
            UNTIL DimSetEntry.NEXT = 0;

        DimSetEntry.RESET;
        EXIT(CheckDimComb);
    END;

    //[External]
    PROCEDURE GetDimCombErr(): Text[250];
    BEGIN
        //18420
        EXIT(DimCombErr);
    END;

    LOCAL PROCEDURE CheckDimComb(): Boolean;
    VAR
        DimComb: Record 350;
        CurrentDimCode: Code[20];
        CurrentDimValCode: Code[20];
        DimFilter: Text[1024];
        FilterTooLong: Boolean;
    BEGIN
        //18420
        IF NOT TempDimCombInitialized THEN BEGIN
            TempDimCombInitialized := TRUE;
            IF DimComb.ISEMPTY THEN
                TempDimCombEmpty := TRUE;
        END;

        IF TempDimCombEmpty THEN
            EXIT(TRUE);

        IF NOT TempDimBuf1.FINDSET THEN
            EXIT(TRUE);

        REPEAT
            IF STRLEN(DimFilter) + 1 + STRLEN(TempDimBuf1."Dimension Code") > MAXSTRLEN(DimFilter) THEN
                FilterTooLong := TRUE
            ELSE
                IF DimFilter = '' THEN
                    DimFilter := TempDimBuf1."Dimension Code"
                ELSE
                    DimFilter := DimFilter + '|' + TempDimBuf1."Dimension Code";
        UNTIL FilterTooLong OR (TempDimBuf1.NEXT = 0);

        IF NOT FilterTooLong THEN BEGIN
            DimComb.SETFILTER("Dimension 1 Code", DimFilter);
            DimComb.SETFILTER("Dimension 2 Code", DimFilter);
            IF DimComb.FINDSET THEN
                REPEAT
                    IF DimComb."Combination Restriction" = DimComb."Combination Restriction"::Blocked THEN BEGIN
                        DimCombErr := STRSUBSTNO(Text000, DimComb."Dimension 1 Code", DimComb."Dimension 2 Code");
                        EXIT(FALSE);
                    END ELSE BEGIN
                        TempDimBuf1.SETRANGE("Dimension Code", DimComb."Dimension 1 Code");
                        TempDimBuf1.FINDFIRST;
                        CurrentDimCode := TempDimBuf1."Dimension Code";
                        CurrentDimValCode := TempDimBuf1."Dimension Value Code";
                        TempDimBuf1.SETRANGE("Dimension Code", DimComb."Dimension 2 Code");
                        TempDimBuf1.FINDFIRST;
                        IF NOT
                           CheckDimValueComb(
                             TempDimBuf1."Dimension Code", TempDimBuf1."Dimension Value Code",
                             CurrentDimCode, CurrentDimValCode)
                        THEN
                            EXIT(FALSE);
                        IF NOT
                           CheckDimValueComb(
                             CurrentDimCode, CurrentDimValCode,
                             TempDimBuf1."Dimension Code", TempDimBuf1."Dimension Value Code")
                        THEN
                            EXIT(FALSE);
                    END;
                UNTIL DimComb.NEXT = 0;
            EXIT(TRUE);
        END;

        WHILE TempDimBuf1.FINDFIRST DO BEGIN
            CurrentDimCode := TempDimBuf1."Dimension Code";
            CurrentDimValCode := TempDimBuf1."Dimension Value Code";
            TempDimBuf1.DELETE;
            IF TempDimBuf1.FINDSET THEN
                REPEAT
                    IF CurrentDimCode > TempDimBuf1."Dimension Code" THEN BEGIN
                        IF DimComb.GET(TempDimBuf1."Dimension Code", CurrentDimCode) THEN BEGIN
                            IF DimComb."Combination Restriction" = DimComb."Combination Restriction"::Blocked THEN BEGIN
                                DimCombErr :=
                                  STRSUBSTNO(
                                    Text000,
                                    TempDimBuf1."Dimension Code", CurrentDimCode);
                                EXIT(FALSE);
                            END;
                            IF NOT
                               CheckDimValueComb(
                                 TempDimBuf1."Dimension Code", TempDimBuf1."Dimension Value Code",
                                 CurrentDimCode, CurrentDimValCode)
                            THEN
                                EXIT(FALSE);
                        END;
                    END ELSE BEGIN
                        IF DimComb.GET(CurrentDimCode, TempDimBuf1."Dimension Code") THEN BEGIN
                            IF DimComb."Combination Restriction" = DimComb."Combination Restriction"::Blocked THEN BEGIN
                                DimCombErr :=
                                  STRSUBSTNO(
                                    Text000,
                                    CurrentDimCode, TempDimBuf1."Dimension Code");
                                EXIT(FALSE);
                            END;
                            IF NOT
                               CheckDimValueComb(
                                 CurrentDimCode, CurrentDimValCode, TempDimBuf1."Dimension Code",
                                 TempDimBuf1."Dimension Value Code")
                            THEN
                                EXIT(FALSE);
                        END;
                    END;
                UNTIL TempDimBuf1.NEXT = 0;
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckDimValueComb(Dim1: Code[20]; Dim1Value: Code[20]; Dim2: Code[20]; Dim2Value: Code[20]): Boolean;
    BEGIN
        //18420
        IF DimValComb.GET(Dim1, Dim1Value, Dim2, Dim2Value) THEN BEGIN
            DimCombErr :=
              STRSUBSTNO(Text001,
                Dim1, Dim1Value, Dim2, Dim2Value);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, OnBeforeCheckDimensions, '', true, true)]
    LOCAL PROCEDURE Cod_11_OnBeforeCheckDimensions(VAR GenJnlLine: Record 81; VAR CheckDone: Boolean);
    BEGIN
        //18420
        CheckGenJnlLineDimensions(GenJnlLine);
    END;

    LOCAL PROCEDURE CheckGenJnlLineDimensions(GenJnlLine: Record 81);
    VAR
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        CheckDone: Boolean;
        DimMgt: Codeunit 408;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //18420

        WITH GenJnlLine DO BEGIN
            IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                ThrowGenJnlLineError(GenJnlLine, Text011, DimMgt.GetDimCombErr);

            TableID[1] := DimMgt.TypeToTableID1(ConvertDocumentTypeToOptionGenJournalAccountType("Account Type"));
            No[1] := "Account No.";
            TableID[2] := DimMgt.TypeToTableID1(ConvertDocumentTypeToOptionGenJournalAccountType("Bal. Account Type"));
            No[2] := "Bal. Account No.";
            TableID[3] := DATABASE::Job;
            No[3] := "Job No.";
            TableID[4] := DATABASE::"Salesperson/Purchaser";
            No[4] := "Salespers./Purch. Code";
            TableID[5] := DATABASE::Campaign;
            No[5] := "Campaign No.";
            //-18420
            IF ("Job No." <> '') AND ("Piecework Code" <> '') THEN BEGIN
                TableID[6] := DATABASE::"Data Piecework For Production";
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                DataPieceworkForProduction.SETRANGE("Piecework Code", "Piecework Code");
                IF DataPieceworkForProduction.FINDFIRST THEN
                    No[6] := DataPieceworkForProduction."Unique Code";
            END;
            //+18420
            IF NOT DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") THEN
                ThrowGenJnlLineError(GenJnlLine, Text012, DimMgt.GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE ThrowGenJnlLineError(GenJournalLine: Record 81; ErrorTemplate: Text; ErrorText: Text);
    BEGIN
        //18420
        WITH GenJournalLine DO
            IF "Line No." <> 0 THEN
                ERROR(
                  ErrorTemplate,
                  TABLECAPTION, "Journal Template Name", "Journal Batch Name", "Line No.",
                  ErrorText);
        ERROR(ErrorText);
    END;

    PROCEDURE ChangePieceWork_TPurchaseHeader(VAR Rec: Record 38);
    VAR
        Text001: TextConst ENU = 'You can not specify Job on orders against Location', ESP = 'No puede especificar proyecto en pedidos contra almac‚n';
        GeneralLedgerSetup: Record 98;
        TmpDimSetEntry: Record 480 TEMPORARY;
        DefaultDimension: Record 352;
        DimSetEntry: Record 480;
        DimMgt: Codeunit 408;
        newDimSetID: Integer;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //Al cambiar el proyecto en la cabecera, actualizar las dimensiones

        IF DataPieceworkForProduction.GET(Rec."QB Job No.", Rec."QB Budget item") THEN BEGIN

            //A¤ado las dimensiones del proyecto
            TmpDimSetEntry.DELETEALL;
            DefaultDimension.RESET;
            DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
            DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
            DefaultDimension.SETFILTER("Dimension Value Code", '<>%1', '');
            IF (DefaultDimension.FINDSET) THEN
                REPEAT
                    TmpDimSetEntry.INIT;
                    TmpDimSetEntry."Dimension Set ID" := 0;
                    TmpDimSetEntry."Dimension Code" := DefaultDimension."Dimension Code";
                    TmpDimSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                    TmpDimSetEntry.INSERT;
                UNTIL DefaultDimension.NEXT = 0;

            //Copio el resto de dimensiones del documento
            DimSetEntry.RESET;
            DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
            IF (DimSetEntry.FINDSET) THEN
                REPEAT
                    TmpDimSetEntry := DimSetEntry;
                    TmpDimSetEntry."Dimension Set ID" := 0;
                    IF NOT TmpDimSetEntry.INSERT THEN;
                UNTIL DimSetEntry.NEXT = 0;

            //Busco el ID y actualizo
            Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TmpDimSetEntry);
            DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
            Rec.MODIFY;
        END;
    END;

    PROCEDURE ChangePieceWork_TSalesHeader(VAR Rec: Record 36);
    VAR
        Text001: TextConst ENU = 'You can not specify Job on orders against Location', ESP = 'No puede especificar proyecto en pedidos contra almac‚n';
        GeneralLedgerSetup: Record 98;
        TmpDimSetEntry: Record 480 TEMPORARY;
        DefaultDimension: Record 352;
        DimSetEntry: Record 480;
        DimMgt: Codeunit 408;
        newDimSetID: Integer;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //Al cambiar el proyecto en la cabecera, actualizar las dimensiones

        IF DataPieceworkForProduction.GET(Rec."QB Job No.", Rec."QB Budget item") THEN BEGIN

            //A¤ado las dimensiones del proyecto
            TmpDimSetEntry.DELETEALL;
            DefaultDimension.RESET;
            DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
            DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
            DefaultDimension.SETFILTER("Dimension Value Code", '<>%1', '');
            IF (DefaultDimension.FINDSET) THEN
                REPEAT
                    TmpDimSetEntry.INIT;
                    TmpDimSetEntry."Dimension Set ID" := 0;
                    TmpDimSetEntry."Dimension Code" := DefaultDimension."Dimension Code";
                    TmpDimSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                    TmpDimSetEntry.INSERT;
                UNTIL DefaultDimension.NEXT = 0;

            //Copio el resto de dimensiones del documento
            DimSetEntry.RESET;
            DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
            IF (DimSetEntry.FINDSET) THEN
                REPEAT
                    TmpDimSetEntry := DimSetEntry;
                    TmpDimSetEntry."Dimension Set ID" := 0;
                    IF NOT TmpDimSetEntry.INSERT THEN;
                UNTIL DimSetEntry.NEXT = 0;

            //Busco el ID y actualizo
            Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TmpDimSetEntry);
            DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
            Rec.MODIFY;
        END;
    END;

    procedure ConvertDocumentTypeToOptionPurchaseLineType(DocumentType: Enum "Purchase Line Type"): Option;
    var
        optionValue: Option " ","G/L Account","Item","Resource","Fixed Asset","Charge (Item)","Allocation Account";
    begin
        case DocumentType of
            DocumentType::" ":
                optionValue := optionValue::" ";
            DocumentType::"G/L Account":
                optionValue := optionValue::"G/L Account";
            DocumentType::"Item":
                optionValue := optionValue::"Item";
            DocumentType::"Resource":
                optionValue := optionValue::"Resource";
            DocumentType::"Fixed Asset":
                optionValue := optionValue::"Fixed Asset";
            DocumentType::"Charge (Item)":
                optionValue := optionValue::"Charge (Item)";
            DocumentType::"Allocation Account":
                optionValue := optionValue::"Allocation Account";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionGenJournalAccountType(DocumentType: Enum "Gen. Journal Account Type"): Option;
    var
        optionValue: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee","Allocation Account";
    begin
        case DocumentType of
            DocumentType::"G/L Account":
                optionValue := optionValue::"G/L Account";
            DocumentType::"Customer":
                optionValue := optionValue::"Customer";
            DocumentType::"Vendor":
                optionValue := optionValue::"Vendor";
            DocumentType::"Bank Account":
                optionValue := optionValue::"Bank Account";
            DocumentType::"Fixed Asset":
                optionValue := optionValue::"Fixed Asset";
            DocumentType::"IC Partner":
                optionValue := optionValue::"IC Partner";
            DocumentType::"Employee":
                optionValue := optionValue::"Employee";
            DocumentType::"Allocation Account":
                optionValue := optionValue::"Allocation Account";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;
    /*BEGIN
/*{
      RE17704 DGG 15/07/22 - Modificacion para archivar al reabrir documento de compra.
      18420 AML 23/10/23 - Modificaci�n para la gesti�n de las dimensiones para que tenga en cuenta Partida en el proceso de registro. Copiado del 19855 de QRE
    }
END.*/
}








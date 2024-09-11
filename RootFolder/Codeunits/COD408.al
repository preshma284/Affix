Codeunit 50361 "DimensionManagement1"
{


    Permissions = TableData 80 = imd,
                TableData 232 = imd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Dimensions %1 and %2 can''t be used concurrently.', ESP = 'Dimensiones %1 y %2 no pueden usarse simult neam.';
        Text001: TextConst ENU = 'Dimension combinations %1 - %2 and %3 - %4 can''t be used concurrently.', ESP = 'Combin. dimensi¢n %1 - %2 y %3 - %4 no pueden usarse al mismo tiempo.';
        Text002: TextConst ENU = 'This Shortcut Dimension is not defined in the %1.', ESP = 'Este Shortcut de dimensi¢n no est  def. en el %1.';
        Text003: TextConst ENU = '%1 is not an available %2 for that dimension.', ESP = '%1 no est  disponible %2 para esa dimensi¢n.';
        Text004: TextConst ENU = 'Select a %1 for the %2 %3.', ESP = 'Selecc. %1 para el %2 %3.';
        Text005: TextConst ENU = 'Select a %1 for the %2 %3 for %4 %5.', ESP = 'Selecc. %1 para el %2 %3 para %4 %5.';
        Text006: TextConst ENU = 'Select %1 %2 for the %3 %4.', ESP = 'Selecc. %1 %2 para el %3 %4.';
        Text007: TextConst ENU = 'Select %1 %2 for the %3 %4 for %5 %6.', ESP = 'Selecc. %1 %2 para el %3 %4 para %5 %6.';
        Text008: TextConst ENU = '%1 %2 must be blank.', ESP = '%1 %2 debe ser blanco.';
        Text009: TextConst ENU = '%1 %2 must be blank for %3 %4.', ESP = '%1 %2 debe ser blanco para %3 %4.';
        Text010: TextConst ENU = '%1 %2 must not be mentioned.', ESP = '%1 %2 no debe ser mencionado.';
        Text011: TextConst ENU = '%1 %2 must not be mentioned for %3 %4.', ESP = '%1 %2 no debe ser mencionado para %3 %4.';
        Text012: TextConst ENU = 'A %1 used in %2 has not been used in %3.', ESP = 'Un %1 usado en %2 no ha sido usado en %3.';
        Text013: TextConst ENU = '%1 for %2 %3 is not the same in %4 and %5.', ESP = '%1 para %2 %3 no es lo mismo en %4 y %5.';
        Text014: TextConst ENU = '%1 %2 is blocked.', ESP = '%1 %2 est  bloqueado.';
        Text015: TextConst ENU = '%1 %2 can''t be found.', ESP = '%1 %2 no puede encontrarse.';
        DimValueBlockedErr: TextConst ENU = '%1 %2 - %3 is blocked.', ESP = '%1 %2 - %3 est  bloq.';
        DimValueMustNotBeErr: TextConst ENU = 'Dimension Value Type for %1 %2 - %3 must not be %4.', ESP = 'El tipo de valor de dimensi¢n para %1 %2 - %3 no puede ser %4.';
        DimValueMissingErr: TextConst ENU = '%1 for %2 is missing.', ESP = '%1 para %2 se pierde.';
        Text019: TextConst ENU = 'You have changed a dimension.\\Do you want to update the lines?', ESP = 'Ha cambiado una dimensi¢n.\\¨Desea actualizar las l¡neas?';
        TempDimBuf1: Record 360 TEMPORARY;
        TempDimBuf2: Record 360 TEMPORARY;
        ObjTransl: Record 377;
        DimValComb: Record 351;
        JobTaskDimTemp: Record 1002 TEMPORARY;
        DefaultDim: Record 352;
        DimSetEntry: Record 480;
        TempDimSetEntry2: Record 480 TEMPORARY;
        TempDimCombInitialized: Boolean;
        TempDimCombEmpty: Boolean;
        DimCombErr: Text[250];
        DimValuePostingErr: Text[250];
        DimErr: Text[250];
        DocDimConsistencyErr: Text[250];
        HasGotGLSetup: Boolean;
        GLSetupShortcutDimCode: ARRAY[8] OF Code[20];
        DimSetFilterCtr: Integer;
        DimensionIsBlockedErr: TextConst ENU = 'The combination of dimensions used in %1 %2 is blocked (Error: %3).', ESP = 'La combinaci¢n de dimensiones usada en %1 %2 est  bloqueada (error: %3).';
        LineDimensionBlockedErr: TextConst ENU = 'The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).', ESP = 'La combinaci¢n de dimensiones usada en %1 %2, n§ l¡nea %3 est  bloqueada (error:) %4.';
        InvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2 are invalid (Error: %3).', ESP = 'Las dimensiones usadas en %1 %2 no son v lidas (error: %3).';
        LineInvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', ESP = 'Las dim. usadas en %1 %2, n.§ l¡n. %3 no son v lidas (error: %4).';

    //[External]
    PROCEDURE GetDimensionSetID(VAR DimSetEntry2: Record 480): Integer;
    BEGIN
        EXIT(DimSetEntry.GetDimensionSetID(DimSetEntry2));
    END;

    //[External]
    PROCEDURE GetDimensionSet(VAR TempDimSetEntry: Record 480 TEMPORARY; DimSetID: Integer);
    VAR
        DimSetEntry2: Record 480;
    BEGIN
        TempDimSetEntry.DELETEALL;
        WITH DimSetEntry2 DO BEGIN
            SETRANGE("Dimension Set ID", DimSetID);
            IF FINDSET THEN
                REPEAT
                    TempDimSetEntry := DimSetEntry2;
                    TempDimSetEntry.INSERT;
                UNTIL NEXT = 0;
        END;
    END;

    //[External]
    PROCEDURE ShowDimensionSet(DimSetID: Integer; NewCaption: Text[250]);
    VAR
        DimSetEntries: Page 479;
    BEGIN
        DimSetEntry.RESET;
        DimSetEntry.FILTERGROUP(2);
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        DimSetEntry.FILTERGROUP(0);
        DimSetEntries.SETTABLEVIEW(DimSetEntry);
        DimSetEntries.SetFormCaption(NewCaption);
        DimSetEntry.RESET;
        DimSetEntries.RUNMODAL;
    END;

    //[External]
    PROCEDURE EditDimensionSet(DimSetID: Integer; NewCaption: Text[250]): Integer;
    VAR
        EditDimSetEntries: Page 480;
        NewDimSetID: Integer;
    BEGIN
        NewDimSetID := DimSetID;
        DimSetEntry.RESET;
        DimSetEntry.FILTERGROUP(2);
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        DimSetEntry.FILTERGROUP(0);
        EditDimSetEntries.SETTABLEVIEW(DimSetEntry);
        EditDimSetEntries.SetFormCaption(NewCaption);
        EditDimSetEntries.RUNMODAL;
        NewDimSetID := EditDimSetEntries.GetDimensionID;
        DimSetEntry.RESET;
        EXIT(NewDimSetID);
    END;

    //[External]
    PROCEDURE EditDimensionSet2(DimSetID: Integer; NewCaption: Text[250]; VAR GlobalDimVal1: Code[20]; VAR GlobalDimVal2: Code[20]): Integer;
    VAR
        EditDimSetEntries: Page 480;
        NewDimSetID: Integer;
    BEGIN
        NewDimSetID := DimSetID;
        DimSetEntry.RESET;
        DimSetEntry.FILTERGROUP(2);
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        DimSetEntry.FILTERGROUP(0);
        EditDimSetEntries.SETTABLEVIEW(DimSetEntry);
        EditDimSetEntries.SetFormCaption(NewCaption);
        EditDimSetEntries.RUNMODAL;
        NewDimSetID := EditDimSetEntries.GetDimensionID;
        UpdateGlobalDimFromDimSetID(NewDimSetID, GlobalDimVal1, GlobalDimVal2);
        DimSetEntry.RESET;
        EXIT(NewDimSetID);
    END;

    //[External]
    PROCEDURE EditReclasDimensionSet2(VAR DimSetID: Integer; VAR NewDimSetID: Integer; NewCaption: Text[250]; VAR GlobalDimVal1: Code[20]; VAR GlobalDimVal2: Code[20]; VAR NewGlobalDimVal1: Code[20]; VAR NewGlobalDimVal2: Code[20]);
    VAR
        EditReclasDimensions: Page 484;
    BEGIN
        EditReclasDimensions.SetDimensionIDs(DimSetID, NewDimSetID);
        EditReclasDimensions.SetFormCaption(NewCaption);
        EditReclasDimensions.RUNMODAL;
        EditReclasDimensions.GetDimensionIDs(DimSetID, NewDimSetID);
        UpdateGlobalDimFromDimSetID(DimSetID, GlobalDimVal1, GlobalDimVal2);
        UpdateGlobalDimFromDimSetID(NewDimSetID, NewGlobalDimVal1, NewGlobalDimVal2);
    END;

    //[External]
    PROCEDURE UpdateGlobalDimFromDimSetID(DimSetID: Integer; VAR GlobalDimVal1: Code[20]; VAR GlobalDimVal2: Code[20]);
    VAR
        ShortcutDimCode: ARRAY[8] OF Code[20];
    BEGIN
        GetShortcutDimensions(DimSetID, ShortcutDimCode);
        GlobalDimVal1 := ShortcutDimCode[1];
        GlobalDimVal2 := ShortcutDimCode[2];
    END;

    //[External]
    PROCEDURE GetCombinedDimensionSetID(DimensionSetIDArr: ARRAY[10] OF Integer; VAR GlobalDimVal1: Code[20]; VAR GlobalDimVal2: Code[20]): Integer;
    VAR
        TempDimSetEntry: Record 480 TEMPORARY;
        i: Integer;
    BEGIN
        GetGLSetup;
        GlobalDimVal1 := '';
        GlobalDimVal2 := '';
        DimSetEntry.RESET;
        FOR i := 1 TO 10 DO
            IF DimensionSetIDArr[i] <> 0 THEN BEGIN
                DimSetEntry.SETRANGE("Dimension Set ID", DimensionSetIDArr[i]);
                IF DimSetEntry.FINDSET THEN
                    REPEAT
                        IF TempDimSetEntry.GET(0, DimSetEntry."Dimension Code") THEN
                            TempDimSetEntry.DELETE;
                        TempDimSetEntry := DimSetEntry;
                        TempDimSetEntry."Dimension Set ID" := 0;
                        TempDimSetEntry.INSERT;
                        IF GLSetupShortcutDimCode[1] = TempDimSetEntry."Dimension Code" THEN
                            GlobalDimVal1 := TempDimSetEntry."Dimension Value Code";
                        IF GLSetupShortcutDimCode[2] = TempDimSetEntry."Dimension Code" THEN
                            GlobalDimVal2 := TempDimSetEntry."Dimension Value Code";
                    UNTIL DimSetEntry.NEXT = 0;
            END;
        EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    //[External]
    PROCEDURE GetDeltaDimSetID(DimSetID: Integer; NewParentDimSetID: Integer; OldParentDimSetID: Integer): Integer;
    VAR
        TempDimSetEntry: Record 480 TEMPORARY;
        TempDimSetEntryNew: Record 480 TEMPORARY;
        TempDimSetEntryDeleted: Record 480 TEMPORARY;
    BEGIN
        // Returns an updated DimSetID based on parent's old and new DimSetID
        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT(DimSetID);
        GetDimensionSet(TempDimSetEntry, DimSetID);
        GetDimensionSet(TempDimSetEntryNew, NewParentDimSetID);
        GetDimensionSet(TempDimSetEntryDeleted, OldParentDimSetID);
        IF TempDimSetEntryDeleted.FINDSET THEN
            REPEAT
                IF TempDimSetEntryNew.GET(NewParentDimSetID, TempDimSetEntryDeleted."Dimension Code") THEN BEGIN
                    IF TempDimSetEntryNew."Dimension Value Code" = TempDimSetEntryDeleted."Dimension Value Code" THEN
                        TempDimSetEntryNew.DELETE;
                    TempDimSetEntryDeleted.DELETE;
                END;
            UNTIL TempDimSetEntryDeleted.NEXT = 0;

        IF TempDimSetEntryDeleted.FINDSET THEN
            REPEAT
                IF TempDimSetEntry.GET(DimSetID, TempDimSetEntryDeleted."Dimension Code") THEN
                    TempDimSetEntry.DELETE;
            UNTIL TempDimSetEntryDeleted.NEXT = 0;

        IF TempDimSetEntryNew.FINDSET THEN
            REPEAT
                IF TempDimSetEntry.GET(DimSetID, TempDimSetEntryNew."Dimension Code") THEN BEGIN
                    IF TempDimSetEntry."Dimension Value Code" <> TempDimSetEntryNew."Dimension Value Code" THEN BEGIN
                        TempDimSetEntry."Dimension Value Code" := TempDimSetEntryNew."Dimension Value Code";
                        TempDimSetEntry."Dimension Value ID" := TempDimSetEntryNew."Dimension Value ID";
                        TempDimSetEntry.MODIFY;
                    END;
                END ELSE BEGIN
                    TempDimSetEntry := TempDimSetEntryNew;
                    TempDimSetEntry."Dimension Set ID" := DimSetID;
                    TempDimSetEntry.INSERT;
                END;
            UNTIL TempDimSetEntryNew.NEXT = 0;

        EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    LOCAL PROCEDURE GetGLSetup();
    VAR
        GLSetup: Record 98;
    BEGIN
        IF NOT HasGotGLSetup THEN BEGIN
            GLSetup.GET;
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            HasGotGLSetup := TRUE;
        END;
    END;

    //[External]
    PROCEDURE CheckDimIDComb(DimSetID: Integer): Boolean;
    BEGIN
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
    PROCEDURE CheckDimValuePosting(TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]; DimSetID: Integer): Boolean;
    VAR
        i: Integer;
        j: Integer;
        NoFilter: ARRAY[2] OF Text[250];
        IsHandled: Boolean;
        IsChecked: Boolean;
    BEGIN
        IsChecked := FALSE;
        IsHandled := FALSE;
        OnBeforeCheckDimValuePosting(TableID, No, DimSetID, IsChecked, IsHandled);
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
    PROCEDURE CheckDimBuffer(VAR DimBuffer: Record 360): Boolean;
    VAR
        i: Integer;
    BEGIN
        TempDimBuf1.RESET;
        TempDimBuf1.DELETEALL;
        IF DimBuffer.FINDSET THEN BEGIN
            i := 1;
            REPEAT
                TempDimBuf1.INIT;
                TempDimBuf1."Table ID" := DATABASE::"Dimension Buffer";
                TempDimBuf1."Entry No." := i;
                TempDimBuf1."Dimension Code" := DimBuffer."Dimension Code";
                TempDimBuf1."Dimension Value Code" := DimBuffer."Dimension Value Code";
                TempDimBuf1.INSERT;
                i := i + 1;
            UNTIL DimBuffer.NEXT = 0;
        END;
        EXIT(CheckDimComb);
    END;

    LOCAL PROCEDURE CheckDimComb(): Boolean;
    VAR
        DimComb: Record 350;
        CurrentDimCode: Code[20];
        CurrentDimValCode: Code[20];
        DimFilter: Text[1024];
        FilterTooLong: Boolean;
    BEGIN
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
        IF DimValComb.GET(Dim1, Dim1Value, Dim2, Dim2Value) THEN BEGIN
            DimCombErr :=
              STRSUBSTNO(Text001,
                Dim1, Dim1Value, Dim2, Dim2Value);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE GetDimCombErr(): Text[250];
    BEGIN
        EXIT(DimCombErr);
    END;

    //[External]
    PROCEDURE UpdateDefaultDim(TableID: Integer; No: Code[20]; VAR GlobalDim1Code: Code[20]; VAR GlobalDim2Code: Code[20]);
    VAR
        DefaultDim: Record 352;
    BEGIN
        GetGLSetup;
        IF DefaultDim.GET(TableID, No, GLSetupShortcutDimCode[1]) THEN
            GlobalDim1Code := DefaultDim."Dimension Value Code"
        ELSE
            GlobalDim1Code := '';
        IF DefaultDim.GET(TableID, No, GLSetupShortcutDimCode[2]) THEN
            GlobalDim2Code := DefaultDim."Dimension Value Code"
        ELSE
            GlobalDim2Code := '';
    END;

    //[External]
    PROCEDURE GetDefaultDimID(TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]; SourceCode: Code[20]; VAR GlobalDim1Code: Code[20]; VAR GlobalDim2Code: Code[20]; InheritFromDimSetID: Integer; InheritFromTableNo: Integer): Integer;
    VAR
        DimVal: Record 349;
        DefaultDimPriority1: Record 354;
        DefaultDimPriority2: Record 354;
        DefaultDim: Record 352;
        TempDimSetEntry: Record 480 TEMPORARY;
        TempDimSetEntry0: Record 480 TEMPORARY;
        i: Integer;
        j: Integer;
        NoFilter: ARRAY[2] OF Code[20];
        NewDimSetID: Integer;
        IsHandled: Boolean;
    BEGIN
        OnBeforeGetDefaultDimID(TableID, No, SourceCode, GlobalDim1Code, GlobalDim2Code, InheritFromDimSetID, InheritFromTableNo);

        GetGLSetup;
        IF InheritFromDimSetID > 0 THEN
            GetDimensionSet(TempDimSetEntry0, InheritFromDimSetID);
        TempDimBuf2.RESET;
        TempDimBuf2.DELETEALL;
        IF TempDimSetEntry0.FINDSET THEN
            REPEAT
                TempDimBuf2.INIT;
                TempDimBuf2."Table ID" := InheritFromTableNo;
                TempDimBuf2."Entry No." := 0;
                TempDimBuf2."Dimension Code" := TempDimSetEntry0."Dimension Code";
                TempDimBuf2."Dimension Value Code" := TempDimSetEntry0."Dimension Value Code";
                TempDimBuf2.INSERT;
            UNTIL TempDimSetEntry0.NEXT = 0;

        NoFilter[2] := '';
        FOR i := 1 TO ARRAYLEN(TableID) DO
            IF (TableID[i] <> 0) AND (No[i] <> '') THEN BEGIN
                IsHandled := FALSE;
                OnGetDefaultDimOnBeforeCreate(
                  TempDimBuf2, TableID[i], No[i], GLSetupShortcutDimCode, GlobalDim1Code, GlobalDim2Code, IsHandled);
                IF NOT IsHandled THEN BEGIN
                    DefaultDim.SETRANGE("Table ID", TableID[i]);
                    NoFilter[1] := No[i];
                    FOR j := 1 TO 2 DO BEGIN
                        DefaultDim.SETRANGE("No.", NoFilter[j]);
                        IF DefaultDim.FINDSET THEN
                            REPEAT
                                IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
                                    TempDimBuf2.SETRANGE("Dimension Code", DefaultDim."Dimension Code");
                                    IF NOT TempDimBuf2.FINDFIRST THEN BEGIN
                                        TempDimBuf2.INIT;
                                        TempDimBuf2."Table ID" := DefaultDim."Table ID";
                                        TempDimBuf2."Entry No." := 0;
                                        TempDimBuf2."Dimension Code" := DefaultDim."Dimension Code";
                                        TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                                        TempDimBuf2.INSERT;
                                    END ELSE
                                        IF DefaultDimPriority1.GET(SourceCode, DefaultDim."Table ID") THEN
                                            IF DefaultDimPriority2.GET(SourceCode, TempDimBuf2."Table ID") THEN BEGIN
                                                IF DefaultDimPriority1.Priority < DefaultDimPriority2.Priority THEN BEGIN
                                                    TempDimBuf2.DELETE;
                                                    TempDimBuf2."Table ID" := DefaultDim."Table ID";
                                                    TempDimBuf2."Entry No." := 0;
                                                    TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                                                    TempDimBuf2.INSERT;
                                                END;
                                            END ELSE BEGIN
                                                TempDimBuf2.DELETE;
                                                TempDimBuf2."Table ID" := DefaultDim."Table ID";
                                                TempDimBuf2."Entry No." := 0;
                                                TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                                                TempDimBuf2.INSERT;
                                            END;
                                    IF GLSetupShortcutDimCode[1] = TempDimBuf2."Dimension Code" THEN
                                        GlobalDim1Code := TempDimBuf2."Dimension Value Code";
                                    IF GLSetupShortcutDimCode[2] = TempDimBuf2."Dimension Code" THEN
                                        GlobalDim2Code := TempDimBuf2."Dimension Value Code";
                                END;
                            UNTIL DefaultDim.NEXT = 0;
                    END;
                END;
            END;

        TempDimBuf2.RESET;
        IF TempDimBuf2.FINDSET THEN BEGIN
            REPEAT
                DimVal.GET(TempDimBuf2."Dimension Code", TempDimBuf2."Dimension Value Code");
                TempDimSetEntry."Dimension Code" := TempDimBuf2."Dimension Code";
                TempDimSetEntry."Dimension Value Code" := TempDimBuf2."Dimension Value Code";
                TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                TempDimSetEntry.INSERT;
            UNTIL TempDimBuf2.NEXT = 0;
            NewDimSetID := GetDimensionSetID(TempDimSetEntry);
        END;
        EXIT(NewDimSetID);
    END;

    //[External]
    PROCEDURE GetRecDefaultDimID(RecVariant: Variant; CurrFieldNo: Integer; TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]; SourceCode: Code[20]; VAR GlobalDim1Code: Code[20]; VAR GlobalDim2Code: Code[20]; InheritFromDimSetID: Integer; InheritFromTableNo: Integer): Integer;
    BEGIN
        OnGetRecDefaultDimID(RecVariant, CurrFieldNo, TableID, No, SourceCode, InheritFromDimSetID, InheritFromTableNo);
        EXIT(GetDefaultDimID(TableID, No, SourceCode, GlobalDim1Code, GlobalDim2Code, InheritFromDimSetID, InheritFromTableNo));
    END;

    //[External]
    PROCEDURE TypeToTableID1(Type : Enum "Gen. Journal Account Type") : Integer;
    BEGIN
      CASE Type OF
        Type::"G/L Account":
          EXIT(DATABASE::"G/L Account");
        Type::Customer:
          EXIT(DATABASE::Customer);
        Type::Vendor:
          EXIT(DATABASE::Vendor);
        Type::Employee:
          EXIT(DATABASE::Employee);
        Type::"Bank Account":
          EXIT(DATABASE::"Bank Account");
        Type::"Fixed Asset":
          EXIT(DATABASE::"Fixed Asset");
        Type::"IC Partner":
          EXIT(DATABASE::"IC Partner");
      END;
    END;

    //[External]
    PROCEDURE TypeToTableID2(Type: Enum "Job Journal Line Type"): Integer;
    VAR
        TableID: Integer;
    BEGIN
        CASE Type OF
            Type::Resource:
                EXIT(DATABASE::Resource);
            Type::Item:
                EXIT(DATABASE::Item);
            Type::"G/L Account":
                EXIT(DATABASE::"G/L Account");
            ELSE BEGIN
                OnTypeToTableID2(TableID, Type.AsInteger());
                EXIT(TableID);
            END;
        END;
    END;

    //[External]
    PROCEDURE TypeToTableID3(Type: Enum "Sales Line Type"): Integer;
    BEGIN
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

    

    //[External]
    PROCEDURE DeleteDefaultDim(TableID: Integer; No: Code[20]);
    VAR
        DefaultDim: Record 352;
    BEGIN
        DefaultDim.SETRANGE("Table ID", TableID);
        DefaultDim.SETRANGE("No.", No);
        IF NOT DefaultDim.ISEMPTY THEN
            DefaultDim.DELETEALL;
    END;

   

    //[External]
    PROCEDURE LookupDimValueCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20]);
    VAR
        DimVal: Record 349;
        GLSetup: Record 98;
    BEGIN
        GetGLSetup;
        IF GLSetupShortcutDimCode[FieldNumber] = '' THEN
            ERROR(Text002, GLSetup.TABLECAPTION);
        DimVal.SETRANGE("Dimension Code", GLSetupShortcutDimCode[FieldNumber]);
        DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
        DimVal.Code := ShortcutDimCode;
        IF PAGE.RUNMODAL(0, DimVal) = ACTION::LookupOK THEN BEGIN
            CheckDim(DimVal."Dimension Code");
            CheckDimValue(DimVal."Dimension Code", DimVal.Code);
            ShortcutDimCode := DimVal.Code;
        END;
    END;

    //[External]
    PROCEDURE ValidateDimValueCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20]);
    VAR
        DimVal: Record 349;
        GLSetup: Record 98;
    BEGIN
        GetGLSetup;
        IF (GLSetupShortcutDimCode[FieldNumber] = '') AND (ShortcutDimCode <> '') THEN
            ERROR(Text002, GLSetup.TABLECAPTION);
        DimVal.SETRANGE("Dimension Code", GLSetupShortcutDimCode[FieldNumber]);
        IF ShortcutDimCode <> '' THEN BEGIN
            DimVal.SETRANGE(Code, ShortcutDimCode);
            IF NOT DimVal.FINDFIRST THEN BEGIN
                DimVal.SETFILTER(Code, STRSUBSTNO('%1*', ShortcutDimCode));
                IF DimVal.FINDFIRST THEN
                    ShortcutDimCode := DimVal.Code
                ELSE
                    ERROR(
                      Text003,
                      ShortcutDimCode, DimVal.FIELDCAPTION(Code));
            END;
        END;
    END;

    //[External]
    PROCEDURE ValidateShortcutDimValues(FieldNumber: Integer; VAR ShortcutDimCode: Code[20]; VAR DimSetID: Integer);
    VAR
        DimVal: Record 349;
        TempDimSetEntry: Record 480 TEMPORARY;
    BEGIN
        ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
        IF ShortcutDimCode <> '' THEN BEGIN
            DimVal.GET(DimVal."Dimension Code", ShortcutDimCode);
            IF NOT CheckDim(DimVal."Dimension Code") THEN
                ERROR(GetDimErr);
            IF NOT CheckDimValue(DimVal."Dimension Code", ShortcutDimCode) THEN
                ERROR(GetDimErr);
        END;
        GetDimensionSet(TempDimSetEntry, DimSetID);
        IF TempDimSetEntry.GET(TempDimSetEntry."Dimension Set ID", DimVal."Dimension Code") THEN
            IF TempDimSetEntry."Dimension Value Code" <> ShortcutDimCode THEN
                TempDimSetEntry.DELETE;
        IF ShortcutDimCode <> '' THEN BEGIN
            TempDimSetEntry."Dimension Code" := DimVal."Dimension Code";
            TempDimSetEntry."Dimension Value Code" := DimVal.Code;
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            IF TempDimSetEntry.INSERT THEN;
        END;
        DimSetID := GetDimensionSetID(TempDimSetEntry);
    END;

    //[External]
    PROCEDURE SaveDefaultDim(TableID: Integer; No: Code[20]; FieldNumber: Integer; ShortcutDimCode: Code[20]);
    VAR
        DefaultDim: Record 352;
    BEGIN
        GetGLSetup;
        IF ShortcutDimCode <> '' THEN BEGIN
            IF DefaultDim.GET(TableID, No, GLSetupShortcutDimCode[FieldNumber])
            THEN BEGIN
                DefaultDim.VALIDATE("Dimension Value Code", ShortcutDimCode);
                DefaultDim.MODIFY;
            END ELSE BEGIN
                DefaultDim.INIT;
                DefaultDim.VALIDATE("Table ID", TableID);
                DefaultDim.VALIDATE("No.", No);
                DefaultDim.VALIDATE("Dimension Code", GLSetupShortcutDimCode[FieldNumber]);
                DefaultDim.VALIDATE("Dimension Value Code", ShortcutDimCode);
                DefaultDim.INSERT;
            END;
        END ELSE
            IF DefaultDim.GET(TableID, No, GLSetupShortcutDimCode[FieldNumber]) THEN
                DefaultDim.DELETE;
    END;

    //[External]
    PROCEDURE GetShortcutDimensions(DimSetID: Integer; VAR ShortcutDimCode: ARRAY[8] OF Code[20]);
    VAR
        GetShortcutDimensionValues: Codeunit 480;
    BEGIN
        GetShortcutDimensionValues.GetShortcutDimensions(DimSetID, ShortcutDimCode);
    END;

    //[External]
    PROCEDURE CheckDimBufferValuePosting(VAR DimBuffer: Record 360; TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]): Boolean;
    VAR
        i: Integer;
    BEGIN
        TempDimBuf2.RESET;
        TempDimBuf2.DELETEALL;
        IF DimBuffer.FINDSET THEN BEGIN
            i := 1;
            REPEAT
                IF (NOT CheckDimValue(
                      DimBuffer."Dimension Code", DimBuffer."Dimension Value Code")) OR
                   (NOT CheckDim(DimBuffer."Dimension Code"))
                THEN BEGIN
                    DimValuePostingErr := DimErr;
                    EXIT(FALSE);
                END;
                TempDimBuf2.INIT;
                TempDimBuf2."Entry No." := i;
                TempDimBuf2."Dimension Code" := DimBuffer."Dimension Code";
                TempDimBuf2."Dimension Value Code" := DimBuffer."Dimension Value Code";
                TempDimBuf2.INSERT;
                i := i + 1;
            UNTIL DimBuffer.NEXT = 0;
        END;
        EXIT(CheckValuePosting(TableID, No));
    END;

    LOCAL PROCEDURE CheckValuePosting(TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]): Boolean;
    VAR
        DefaultDim: Record 352;
        i: Integer;
        j: Integer;
        NoFilter: ARRAY[2] OF Text[250];
    BEGIN
        DefaultDim.SETFILTER("Value Posting", '<>%1', DefaultDim."Value Posting"::" ");
        NoFilter[2] := '';
        FOR i := 1 TO ARRAYLEN(TableID) DO BEGIN
            IF (TableID[i] <> 0) AND (No[i] <> '') THEN BEGIN
                DefaultDim.SETRANGE("Table ID", TableID[i]);
                NoFilter[1] := No[i];
                FOR j := 1 TO 2 DO BEGIN
                    DefaultDim.SETRANGE("No.", NoFilter[j]);
                    IF DefaultDim.FINDSET THEN BEGIN
                        REPEAT
                            TempDimBuf2.SETRANGE("Dimension Code", DefaultDim."Dimension Code");
                            CASE DefaultDim."Value Posting" OF
                                DefaultDim."Value Posting"::"Code Mandatory":
                                    BEGIN
                                        IF (NOT TempDimBuf2.FINDFIRST) OR
                                           (TempDimBuf2."Dimension Value Code" = '')
                                        THEN BEGIN
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
                                            IF (NOT TempDimBuf2.FINDFIRST) OR
                                               (DefaultDim."Dimension Value Code" <> TempDimBuf2."Dimension Value Code")
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
                                            IF TempDimBuf2.FINDFIRST THEN BEGIN
                                                IF DefaultDim."No." = '' THEN
                                                    DimValuePostingErr :=
                                                      STRSUBSTNO(
                                                        Text008,
                                                        TempDimBuf2.FIELDCAPTION("Dimension Code"), TempDimBuf2."Dimension Code")
                                                ELSE
                                                    DimValuePostingErr :=
                                                      STRSUBSTNO(
                                                        Text009,
                                                        TempDimBuf2.FIELDCAPTION("Dimension Code"),
                                                        TempDimBuf2."Dimension Code",
                                                        ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DefaultDim."Table ID"),
                                                        DefaultDim."No.");
                                                EXIT(FALSE);
                                            END;
                                        END;
                                    END;
                                DefaultDim."Value Posting"::"No Code":
                                    BEGIN
                                        IF TempDimBuf2.FINDFIRST THEN BEGIN
                                            IF DefaultDim."No." = '' THEN
                                                DimValuePostingErr :=
                                                  STRSUBSTNO(
                                                    Text010,
                                                    TempDimBuf2.FIELDCAPTION("Dimension Code"), TempDimBuf2."Dimension Code")
                                            ELSE
                                                DimValuePostingErr :=
                                                  STRSUBSTNO(
                                                    Text011,
                                                    TempDimBuf2.FIELDCAPTION("Dimension Code"),
                                                    TempDimBuf2."Dimension Code",
                                                    ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DefaultDim."Table ID"),
                                                    DefaultDim."No.");
                                            EXIT(FALSE);
                                        END;
                                    END;
                            END;
                        UNTIL DefaultDim.NEXT = 0;
                        TempDimBuf2.RESET;
                    END;
                END;
            END;
        END;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE GetDimValuePostingErr(): Text[250];
    BEGIN
        EXIT(DimValuePostingErr);
    END;

   

    //[External]
    PROCEDURE DefaultDimObjectNoWithGlobalDimsList(VAR TempAllObjWithCaption: Record 2000000058 TEMPORARY);
    VAR
        TempDimField: Record 2000000041 TEMPORARY;
        TempDimSetIDField: Record 2000000041 TEMPORARY;
    BEGIN
        TempDimField.SETFILTER(
          TableNo, '<>%1&<>%2&<>%3',
          DATABASE::"General Ledger Setup", DATABASE::"Job Task", DATABASE::"Change Global Dim. Header");
        TempDimField.SETFILTER(ObsoleteState, '<>%1', TempDimField.ObsoleteState::Removed);
        TempDimField.SETFILTER(FieldName, '*Global Dimension*');
        TempDimField.SETRANGE(Type, TempDimField.Type::Code);
        TempDimField.SETRANGE(Len, 20);
        FillNormalFieldBuffer(TempDimField);
        TempDimSetIDField.SETRANGE(RelationTableNo, DATABASE::"Dimension Set Entry");
        FillNormalFieldBuffer(TempDimSetIDField);
        IF TempDimField.FINDSET THEN
            REPEAT
                TempDimSetIDField.SETRANGE(TableNo, TempDimField.TableNo);
                IF TempDimSetIDField.ISEMPTY THEN
                    DefaultDimInsertTempObject(TempAllObjWithCaption, TempDimField.TableNo);
            UNTIL TempDimField.NEXT = 0;
        OnAfterSetupObjectNoList(TempAllObjWithCaption);
    END;

    LOCAL PROCEDURE DefaultDimObjectNoWithoutGlobalDimsList(VAR TempAllObjWithCaption: Record 2000000058 TEMPORARY);
    BEGIN
        DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"IC Partner");
        DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Service Order Type");
        DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Service Item Group");
        DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Service Item");
        DefaultDimInsertTempObject(TempAllObjWithCaption, DATABASE::"Service Contract Template");
    END;

    LOCAL PROCEDURE DefaultDimInsertTempObject(VAR TempAllObjWithCaption: Record 2000000058 TEMPORARY; TableID: Integer);
    BEGIN
        IF KeyContainsOneCodeField(TableID) OR IsDefaultDimTable(TableID) THEN
            InsertObject(TempAllObjWithCaption, TableID);
    END;

    LOCAL PROCEDURE IsDefaultDimTable(TableID: Integer): Boolean;
    BEGIN
        // Local versions should add exceptions here
        EXIT(TableID = 0);
    END;

    LOCAL PROCEDURE KeyContainsOneCodeField(TableID: Integer) Result: Boolean;
    VAR
        FieldRef: FieldRef;
        KeyRef: KeyRef;
        RecRef: RecordRef;
    BEGIN
        RecRef.OPEN(TableID);
        KeyRef := RecRef.KEYINDEX(1);
        FieldRef := KeyRef.FIELDINDEX(1);
        Result := (KeyRef.FIELDCOUNT = 1) AND (FORMAT(FieldRef.TYPE) = 'Code');
        RecRef.CLOSE;
    END;

   

    //[External]
    PROCEDURE FindDimFieldInTable(TableNo: Integer; FieldNameFilter: Text; VAR Field: Record 2000000041): Boolean;
    BEGIN
        Field.SETRANGE(TableNo, TableNo);
        Field.SETFILTER(FieldName, '*' + FieldNameFilter + '*');
        Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        Field.SETRANGE(Class, Field.Class::Normal);
        Field.SETRANGE(Type, Field.Type::Code);
        Field.SETRANGE(Len, 20);
        IF Field.FINDFIRST THEN
            EXIT(TRUE);
    END;

    LOCAL PROCEDURE FillNormalFieldBuffer(VAR TempField: Record 2000000041);
    VAR
        Field: Record 2000000041;
    BEGIN
        Field.COPYFILTERS(TempField);
        Field.SETRANGE(Class, Field.Class::Normal);
        Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        IF Field.FINDSET THEN
            REPEAT
                TempField := Field;
                TempField.INSERT;
            UNTIL Field.NEXT = 0;
    END;

    //[External]
    PROCEDURE GetDocDimConsistencyErr(): Text[250];
    BEGIN
        EXIT(DocDimConsistencyErr);
    END;

    //[External]
    PROCEDURE CheckDim(DimCode: Code[20]): Boolean;
    VAR
        Dim: Record 348;
    BEGIN
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

    LOCAL PROCEDURE CheckBlockedDimAndValues(DimSetID: Integer): Boolean;
    VAR
        DimSetEntry: Record 480;
    BEGIN
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
    PROCEDURE GetDimErr(): Text[250];
    BEGIN
        EXIT(DimErr);
    END;

    //[External]
    PROCEDURE LookupDimValueCodeNoUpdate(FieldNumber: Integer);
    VAR
        DimVal: Record 349;
        GLSetup: Record 98;
    BEGIN
        GetGLSetup;
        IF GLSetupShortcutDimCode[FieldNumber] = '' THEN
            ERROR(Text002, GLSetup.TABLECAPTION);
        DimVal.SETRANGE("Dimension Code", GLSetupShortcutDimCode[FieldNumber]);
        IF PAGE.RUNMODAL(0, DimVal) = ACTION::LookupOK THEN;
    END;

   

    //[External]
    PROCEDURE DefaultDimOnInsert(DefaultDimension: Record 352);
    VAR
        CallingTrigger: Option "OnInsert","OnModify","OnDelete";
    BEGIN
        IF DefaultDimension."Table ID" = DATABASE::Job THEN
            UpdateJobTaskDim(DefaultDimension, FALSE);

        UpdateCostType(DefaultDimension, CallingTrigger::OnInsert);
    END;

    //[External]
    PROCEDURE DefaultDimOnModify(DefaultDimension: Record 352);
    VAR
        CallingTrigger: Option "OnInsert","OnModify","OnDelete";
    BEGIN
        IF DefaultDimension."Table ID" = DATABASE::Job THEN
            UpdateJobTaskDim(DefaultDimension, FALSE);

        UpdateCostType(DefaultDimension, CallingTrigger::OnModify);
    END;

    //[External]
    PROCEDURE DefaultDimOnDelete(DefaultDimension: Record 352);
    VAR
        CallingTrigger: Option "OnInsert","OnModify","OnDelete";
    BEGIN
        IF DefaultDimension."Table ID" = DATABASE::Job THEN
            UpdateJobTaskDim(DefaultDimension, TRUE);

        UpdateCostType(DefaultDimension, CallingTrigger::OnDelete);
    END;

   
    LOCAL PROCEDURE ConvertICDimtoDim(FromICDim: Code[20]) DimCode: Code[20];
    VAR
        ICDim: Record 411;
    BEGIN
        IF ICDim.GET(FromICDim) THEN
            DimCode := ICDim."Map-to Dimension Code";
    END;

    LOCAL PROCEDURE ConvertICDimValuetoDimValue(FromICDim: Code[20]; FromICDimValue: Code[20]) DimValueCode: Code[20];
    VAR
        ICDimValue: Record 412;
    BEGIN
        IF ICDimValue.GET(FromICDim, FromICDimValue) THEN
            DimValueCode := ICDimValue."Map-to Dimension Value Code";
    END;

    //[External]
    PROCEDURE ConvertDimtoICDim(FromDim: Code[20]) ICDimCode: Code[20];
    VAR
        Dim: Record 348;
    BEGIN
        IF Dim.GET(FromDim) THEN
            ICDimCode := Dim."Map-to IC Dimension Code";
    END;

    //[External]
    PROCEDURE ConvertDimValuetoICDimVal(FromDim: Code[20]; FromDimValue: Code[20]) ICDimValueCode: Code[20];
    VAR
        DimValue: Record 349;
    BEGIN
        IF DimValue.GET(FromDim, FromDimValue) THEN
            ICDimValueCode := DimValue."Map-to IC Dimension Value Code";
    END;

    //[External]
    PROCEDURE CheckICDimValue(ICDimCode: Code[20]; ICDimValCode: Code[20]): Boolean;
    VAR
        ICDimVal: Record 412;
    BEGIN
        IF (ICDimCode <> '') AND (ICDimValCode <> '') THEN BEGIN
            IF ICDimVal.GET(ICDimCode, ICDimValCode) THEN BEGIN
                IF ICDimVal.Blocked THEN BEGIN
                    DimErr := STRSUBSTNO(DimValueBlockedErr, ICDimVal.TABLECAPTION, ICDimCode, ICDimValCode);
                    EXIT(FALSE);
                END;
                IF NOT CheckICDimValueAllowed(ICDimVal) THEN BEGIN
                    DimErr :=
                      STRSUBSTNO(DimValueMustNotBeErr, ICDimVal.TABLECAPTION, ICDimCode, ICDimValCode, FORMAT(ICDimVal."Dimension Value Type"));
                    EXIT(FALSE);
                END;
            END ELSE BEGIN
                DimErr :=
                  STRSUBSTNO(DimValueMissingErr, ICDimVal.TABLECAPTION, ICDimCode);
                EXIT(FALSE);
            END;
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckICDimValueAllowed(ICDimVal: Record 412): Boolean;
    VAR
        DimValueAllowed: Boolean;
    BEGIN
        DimValueAllowed :=
          ICDimVal."Dimension Value Type" IN [ICDimVal."Dimension Value Type"::Standard, ICDimVal."Dimension Value Type"::"Begin-Total"];

        OnCheckICDimValueAllowed(ICDimVal, DimValueAllowed);

        EXIT(DimValueAllowed);
    END;

    //[External]
    PROCEDURE CheckICDim(ICDimCode: Code[20]): Boolean;
    VAR
        ICDim: Record 411;
    BEGIN
        IF ICDim.GET(ICDimCode) THEN BEGIN
            IF ICDim.Blocked THEN BEGIN
                DimErr :=
                  STRSUBSTNO(Text014, ICDim.TABLECAPTION, ICDimCode);
                EXIT(FALSE);
            END;
        END ELSE BEGIN
            DimErr :=
              STRSUBSTNO(Text015, ICDim.TABLECAPTION, ICDimCode);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    END;


    //[External]
    PROCEDURE InsertJobTaskDim(JobNo: Code[20]; JobTaskNo: Code[20]; VAR GlobalDim1Code: Code[20]; VAR GlobalDim2Code: Code[20]);
    VAR
        DefaultDim: Record 352;
        JobTaskDim: Record 1002;
    BEGIN
        GetGLSetup;
        DefaultDim.SETRANGE("Table ID", DATABASE::Job);
        DefaultDim.SETRANGE("No.", JobNo);
        IF DefaultDim.FINDSET(FALSE) THEN
            REPEAT
                IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
                    JobTaskDim.INIT;
                    JobTaskDim."Job No." := JobNo;
                    JobTaskDim."Job Task No." := JobTaskNo;
                    JobTaskDim."Dimension Code" := DefaultDim."Dimension Code";
                    JobTaskDim."Dimension Value Code" := DefaultDim."Dimension Value Code";
                    JobTaskDim.INSERT;
                    IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[1] THEN
                        GlobalDim1Code := JobTaskDim."Dimension Value Code";
                    IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[2] THEN
                        GlobalDim2Code := JobTaskDim."Dimension Value Code";
                END;
            UNTIL DefaultDim.NEXT = 0;

        JobTaskDimTemp.RESET;
        IF JobTaskDimTemp.FINDSET THEN
            REPEAT
                IF NOT JobTaskDim.GET(JobNo, JobTaskNo, JobTaskDimTemp."Dimension Code") THEN BEGIN
                    JobTaskDim.INIT;
                    JobTaskDim."Job No." := JobNo;
                    JobTaskDim."Job Task No." := JobTaskNo;
                    JobTaskDim."Dimension Code" := JobTaskDimTemp."Dimension Code";
                    JobTaskDim."Dimension Value Code" := JobTaskDimTemp."Dimension Value Code";
                    JobTaskDim.INSERT;
                    IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[1] THEN
                        GlobalDim1Code := JobTaskDim."Dimension Value Code";
                    IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[2] THEN
                        GlobalDim2Code := JobTaskDim."Dimension Value Code";
                END;
            UNTIL JobTaskDimTemp.NEXT = 0;
        JobTaskDimTemp.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateJobTaskDim(DefaultDimension: Record 352; FromOnDelete: Boolean);
    VAR
        JobTaskDimension: Record 1002;
        JobTask: Record 1001;
    BEGIN
        IF DefaultDimension."Table ID" <> DATABASE::Job THEN
            EXIT;

        JobTask.SETRANGE("Job No.", DefaultDimension."No.");
        IF JobTask.ISEMPTY THEN
            EXIT;

        IF NOT CONFIRM(Text019, TRUE) THEN
            EXIT;

        JobTaskDimension.SETRANGE("Job No.", DefaultDimension."No.");
        JobTaskDimension.SETRANGE("Dimension Code", DefaultDimension."Dimension Code");
        JobTaskDimension.DELETEALL(TRUE);

        IF FromOnDelete OR
           (DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"No Code") OR
           (DefaultDimension."Dimension Value Code" = '')
        THEN
            EXIT;

        IF JobTask.FINDSET THEN
            REPEAT
                CLEAR(JobTaskDimension);
                JobTaskDimension."Job No." := JobTask."Job No.";
                JobTaskDimension."Job Task No." := JobTask."Job Task No.";
                JobTaskDimension."Dimension Code" := DefaultDimension."Dimension Code";
                JobTaskDimension."Dimension Value Code" := DefaultDimension."Dimension Value Code";
                JobTaskDimension.INSERT(TRUE);
            UNTIL JobTask.NEXT = 0;
    END;

 

    //[External]
    PROCEDURE CopyJobTaskDimToJobTaskDim(JobNo: Code[20]; JobTaskNo: Code[20]; NewJobNo: Code[20]; NewJobTaskNo: Code[20]);
    VAR
        JobTaskDimension: Record 1002;
        JobTaskDimension2: Record 1002;
    BEGIN
        JobTaskDimension.RESET;
        JobTaskDimension.SETRANGE("Job No.", JobNo);
        JobTaskDimension.SETRANGE("Job Task No.", JobTaskNo);
        IF JobTaskDimension.FINDSET THEN
            REPEAT
                IF NOT JobTaskDimension2.GET(NewJobNo, NewJobTaskNo, JobTaskDimension."Dimension Code") THEN BEGIN
                    JobTaskDimension2.INIT;
                    JobTaskDimension2."Job No." := NewJobNo;
                    JobTaskDimension2."Job Task No." := NewJobTaskNo;
                    JobTaskDimension2."Dimension Code" := JobTaskDimension."Dimension Code";
                    JobTaskDimension2."Dimension Value Code" := JobTaskDimension."Dimension Value Code";
                    JobTaskDimension2.INSERT(TRUE);
                END ELSE BEGIN
                    JobTaskDimension2."Dimension Value Code" := JobTaskDimension."Dimension Value Code";
                    JobTaskDimension2.MODIFY(TRUE);
                END;
            UNTIL JobTaskDimension.NEXT = 0;

        JobTaskDimension2.RESET;
        JobTaskDimension2.SETRANGE("Job No.", NewJobNo);
        JobTaskDimension2.SETRANGE("Job Task No.", NewJobTaskNo);
        IF JobTaskDimension2.FINDSET THEN
            REPEAT
                IF NOT JobTaskDimension.GET(JobNo, JobTaskNo, JobTaskDimension2."Dimension Code") THEN
                    JobTaskDimension2.DELETE(TRUE);
            UNTIL JobTaskDimension2.NEXT = 0;
    END;

    //[External]
    PROCEDURE CheckDimIDConsistency(VAR DimSetEntry: Record 480; VAR PostedDimSetEntry: Record 480; DocTableID: Integer; PostedDocTableID: Integer): Boolean;
    BEGIN
        IF DimSetEntry.FINDSET THEN;
        IF PostedDimSetEntry.FINDSET THEN;
        REPEAT
            CASE TRUE OF
                DimSetEntry."Dimension Code" > PostedDimSetEntry."Dimension Code":
                    BEGIN
                        DocDimConsistencyErr :=
                          STRSUBSTNO(
                            Text012,
                            DimSetEntry.FIELDCAPTION("Dimension Code"),
                            ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DocTableID),
                            ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, PostedDocTableID));
                        EXIT(FALSE);
                    END;
                DimSetEntry."Dimension Code" < PostedDimSetEntry."Dimension Code":
                    BEGIN
                        DocDimConsistencyErr :=
                          STRSUBSTNO(
                            Text012,
                            PostedDimSetEntry.FIELDCAPTION("Dimension Code"),
                            ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, PostedDocTableID),
                            ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DocTableID));
                        EXIT(FALSE);
                    END;
                DimSetEntry."Dimension Code" = PostedDimSetEntry."Dimension Code":
                    BEGIN
                        IF DimSetEntry."Dimension Value Code" <> PostedDimSetEntry."Dimension Value Code" THEN BEGIN
                            DocDimConsistencyErr :=
                              STRSUBSTNO(
                                Text013,
                                DimSetEntry.FIELDCAPTION("Dimension Value Code"),
                                DimSetEntry.FIELDCAPTION("Dimension Code"),
                                DimSetEntry."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, DocTableID),
                                ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, PostedDocTableID));
                            EXIT(FALSE);
                        END;
                    END;
            END;
        UNTIL (DimSetEntry.NEXT = 0) AND (PostedDimSetEntry.NEXT = 0);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateDimSetEntryFromDimValue(DimValue: Record 349; VAR TempDimSetEntry: Record 480 TEMPORARY);
    BEGIN
        TempDimSetEntry."Dimension Code" := DimValue."Dimension Code";
        TempDimSetEntry."Dimension Value Code" := DimValue.Code;
        TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
        TempDimSetEntry.INSERT;
    END;

    //[External]
    PROCEDURE CreateDimSetIDFromICDocDim(VAR ICDocDim: Record 442): Integer;
    VAR
        DimValue: Record 349;
        TempDimSetEntry: Record 480 TEMPORARY;
    BEGIN
        IF ICDocDim.FIND('-') THEN
            REPEAT
                DimValue.GET(
                  ConvertICDimtoDim(ICDocDim."Dimension Code"),
                  ConvertICDimValuetoDimValue(ICDocDim."Dimension Code", ICDocDim."Dimension Value Code"));
                CreateDimSetEntryFromDimValue(DimValue, TempDimSetEntry);
            UNTIL ICDocDim.NEXT = 0;
        EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    //[External]
    PROCEDURE CreateDimSetIDFromICJnlLineDim(VAR ICInboxOutboxJnlLineDim: Record 423): Integer;
    VAR
        DimValue: Record 349;
        TempDimSetEntry: Record 480 TEMPORARY;
    BEGIN
        IF ICInboxOutboxJnlLineDim.FIND('-') THEN
            REPEAT
                DimValue.GET(
                  ConvertICDimtoDim(ICInboxOutboxJnlLineDim."Dimension Code"),
                  ConvertICDimValuetoDimValue(
                    ICInboxOutboxJnlLineDim."Dimension Code", ICInboxOutboxJnlLineDim."Dimension Value Code"));
                CreateDimSetEntryFromDimValue(DimValue, TempDimSetEntry);
            UNTIL ICInboxOutboxJnlLineDim.NEXT = 0;
        EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    //[External]
    PROCEDURE CopyDimBufToDimSetEntry(VAR FromDimBuf: Record 360; VAR DimSetEntry: Record 480);
    VAR
        DimValue: Record 349;
    BEGIN
        WITH FromDimBuf DO
            IF FINDSET THEN
                REPEAT
                    DimValue.GET("Dimension Code", "Dimension Value Code");
                    DimSetEntry."Dimension Code" := "Dimension Code";
                    DimSetEntry."Dimension Value Code" := "Dimension Value Code";
                    DimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
                    DimSetEntry.INSERT;
                UNTIL NEXT = 0;
    END;

    //[External]
    PROCEDURE CreateDimSetIDFromDimBuf(VAR DimBuf: Record 360): Integer;
    VAR
        DimValue: Record 349;
        TempDimSetEntry: Record 480 TEMPORARY;
    BEGIN
        IF DimBuf.FINDSET THEN
            REPEAT
                DimValue.GET(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                CreateDimSetEntryFromDimValue(DimValue, TempDimSetEntry);
            UNTIL DimBuf.NEXT = 0;
        EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    //[External]
    PROCEDURE CreateDimForPurchLineWithHigherPriorities(PurchaseLine: Record 39; CurrFieldNo: Integer; VAR DimensionSetID: Integer; VAR DimValue1: Code[20]; VAR DimValue2: Code[20]; SourceCode: Code[10]; PriorityTableID: Integer);
    VAR
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        HighPriorityTableID: ARRAY[10] OF Integer;
        HighPriorityNo: ARRAY[10] OF Code[20];
    BEGIN
        TableID[1] := DATABASE::Job;
        TableID[2] := TypeToTableID3(PurchaseLine.Type);
        No[1] := PurchaseLine."Job No.";
        No[2] := PurchaseLine."No.";

        IF GetTableIDsForHigherPriorities(
             TableID, No, HighPriorityTableID, HighPriorityNo, SourceCode, PriorityTableID)
        THEN
            DimensionSetID :=
              GetRecDefaultDimID(
                PurchaseLine, CurrFieldNo, HighPriorityTableID, HighPriorityNo, SourceCode, DimValue1, DimValue2, 0, 0);
    END;

    //[External]
    PROCEDURE CreateDimForSalesLineWithHigherPriorities(SalesLine: Record 37; CurrFieldNo: Integer; VAR DimensionSetID: Integer; VAR DimValue1: Code[20]; VAR DimValue2: Code[20]; SourceCode: Code[10]; PriorityTableID: Integer);
    VAR
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        HighPriorityTableID: ARRAY[10] OF Integer;
        HighPriorityNo: ARRAY[10] OF Code[20];
    BEGIN
        TableID[1] := DATABASE::Job;
        TableID[2] := TypeToTableID3(SalesLine.Type);
        No[1] := SalesLine."Job No.";
        No[2] := SalesLine."No.";

        IF GetTableIDsForHigherPriorities(
             TableID, No, HighPriorityTableID, HighPriorityNo, SourceCode, PriorityTableID)
        THEN
            DimensionSetID :=
              GetRecDefaultDimID(
                SalesLine, CurrFieldNo, HighPriorityTableID, HighPriorityNo, SourceCode, DimValue1, DimValue2, 0, 0);
    END;

    //[External]
    PROCEDURE CreateDimForJobJournalLineWithHigherPriorities(JobJournalLine: Record 210; CurrFieldNo: Integer; VAR DimensionSetID: Integer; VAR DimValue1: Code[20]; VAR DimValue2: Code[20]; SourceCode: Code[10]; PriorityTableID: Integer);
    VAR
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        HighPriorityTableID: ARRAY[10] OF Integer;
        HighPriorityNo: ARRAY[10] OF Code[20];
    BEGIN
        TableID[1] := DATABASE::Job;
        TableID[2] := TypeToTableID2(JobJournalLine.Type);
        TableID[3] := DATABASE::"Resource Group";
        No[1] := JobJournalLine."Job No.";
        No[2] := JobJournalLine."No.";
        No[3] := JobJournalLine."Resource Group No.";

        IF GetTableIDsForHigherPriorities(
             TableID, No, HighPriorityTableID, HighPriorityNo, SourceCode, PriorityTableID)
        THEN
            DimensionSetID :=
              GetRecDefaultDimID(
                JobJournalLine, CurrFieldNo, HighPriorityTableID, HighPriorityNo, SourceCode, DimValue1, DimValue2, 0, 0);
    END;

    LOCAL PROCEDURE GetTableIDsForHigherPriorities(TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]; VAR HighPriorityTableID: ARRAY[10] OF Integer; VAR HighPriorityNo: ARRAY[10] OF Code[20]; SourceCode: Code[10]; PriorityTableID: Integer) Result: Boolean;
    VAR
        DefaultDimensionPriority: Record 354;
        InitialPriority: Integer;
        i: Integer;
        j: Integer;
    BEGIN
        CLEAR(HighPriorityTableID);
        CLEAR(HighPriorityNo);
        IF DefaultDimensionPriority.GET(SourceCode, PriorityTableID) THEN
            InitialPriority := DefaultDimensionPriority.Priority;
        DefaultDimensionPriority.SETRANGE("Source Code", SourceCode);
        DefaultDimensionPriority.SETFILTER(Priority, '<=%1', InitialPriority);
        i := 1;
        FOR j := 1 TO ARRAYLEN(TableID) DO BEGIN
            IF TableID[j] = 0 THEN
                BREAK;
            DefaultDimensionPriority.Priority := 0;
            DefaultDimensionPriority.SETRANGE("Table ID", TableID[j]);
            IF ((InitialPriority = 0) OR DefaultDimensionPriority.FINDFIRST) AND
               ((DefaultDimensionPriority.Priority < InitialPriority) OR
                ((DefaultDimensionPriority.Priority = InitialPriority) AND (TableID[j] < PriorityTableID)))
            THEN BEGIN
                Result := TRUE;
                HighPriorityTableID[i] := TableID[j];
                HighPriorityNo[i] := No[j];
                i += 1;
            END;
        END;
        EXIT(Result);
    END;

  

    //[External]
    PROCEDURE GetDimSetFilter() DimSetFilter: Text;
    BEGIN
        TempDimSetEntry2.SETFILTER("Dimension Value ID", '%1', DimSetFilterCtr);
        IF TempDimSetEntry2.FINDSET THEN BEGIN
            DimSetFilter := FORMAT(TempDimSetEntry2."Dimension Set ID");
            IF TempDimSetEntry2.NEXT <> 0 THEN
                REPEAT
                    DimSetFilter += '|' + FORMAT(TempDimSetEntry2."Dimension Set ID");
                UNTIL TempDimSetEntry2.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateCostType(DefaultDimension: Record 352; CallingTrigger: Option "OnInsert","OnModify","OnDelete");
    VAR
        GLAcc: Record 15;
        CostAccSetup: Record 1108;
        CostAccMgt: Codeunit 1100;
    BEGIN
        IF CostAccSetup.GET AND (DefaultDimension."Table ID" = DATABASE::"G/L Account") THEN
            IF GLAcc.GET(DefaultDimension."No.") THEN
                CostAccMgt.UpdateCostTypeFromDefaultDimension(DefaultDimension, GLAcc, CallingTrigger);
    END;

    //[External]
    PROCEDURE CreateDimSetFromJobTaskDim(JobNo: Code[20]; JobTaskNo: Code[20]; VAR GlobalDimVal1: Code[20]; VAR GlobalDimVal2: Code[20]) NewDimSetID: Integer;
    VAR
        JobTaskDimension: Record 1002;
        DimValue: Record 349;
        TempDimSetEntry: Record 480 TEMPORARY;
    BEGIN
        WITH JobTaskDimension DO BEGIN
            SETRANGE("Job No.", JobNo);
            SETRANGE("Job Task No.", JobTaskNo);
            IF FINDSET THEN BEGIN
                REPEAT
                    DimValue.GET("Dimension Code", "Dimension Value Code");
                    TempDimSetEntry."Dimension Code" := "Dimension Code";
                    TempDimSetEntry."Dimension Value Code" := "Dimension Value Code";
                    TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
                    TempDimSetEntry.INSERT(TRUE);
                UNTIL NEXT = 0;
                NewDimSetID := GetDimensionSetID(TempDimSetEntry);
                UpdateGlobalDimFromDimSetID(NewDimSetID, GlobalDimVal1, GlobalDimVal2);
            END;
        END;
    END;

    //[External]
    PROCEDURE UpdateGenJnlLineDim(VAR GenJnlLine: Record 81; DimSetID: Integer);
    BEGIN
        GenJnlLine."Dimension Set ID" := DimSetID;
        UpdateGlobalDimFromDimSetID(
          GenJnlLine."Dimension Set ID",
          GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
    END;

 

    //[External]
    PROCEDURE GetDimSetEntryDefaultDim(VAR DimSetEntry2: Record 480);
    VAR
        DimValue: Record 349;
    BEGIN
        IF NOT DimSetEntry2.ISEMPTY THEN
            DimSetEntry2.DELETEALL;
        IF TempDimBuf2.FINDSET THEN
            REPEAT
                DimValue.GET(TempDimBuf2."Dimension Code", TempDimBuf2."Dimension Value Code");
                DimSetEntry2."Dimension Code" := TempDimBuf2."Dimension Code";
                DimSetEntry2."Dimension Value Code" := TempDimBuf2."Dimension Value Code";
                DimSetEntry2."Dimension Value ID" := DimValue."Dimension Value ID";
                DimSetEntry2.INSERT;
            UNTIL TempDimBuf2.NEXT = 0;
        TempDimBuf2.RESET;
        TempDimBuf2.DELETEALL;
    END;

    //[External]
    PROCEDURE InsertObject(VAR TempAllObjWithCaption: Record 2000000058 TEMPORARY; TableID: Integer);
    VAR
        AllObjWithCaption: Record 2000000058;
    BEGIN
        IF AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Table, TableID) AND NOT IsObsolete(TableID) THEN BEGIN
            TempAllObjWithCaption := AllObjWithCaption;
            IF TempAllObjWithCaption.INSERT THEN;
        END;
    END;

    LOCAL PROCEDURE IsObsolete(TableID: Integer): Boolean;
    VAR
        TableMetadata: Record 2000000136;
    BEGIN
        IF TableMetadata.GET(TableID) THEN
            EXIT(TableMetadata.ObsoleteState <> TableMetadata.ObsoleteState::No);
    END;

    LOCAL PROCEDURE ParseDimParam(DimValueFilter: Text; DimensionCode: Code[20]) ResultTxt: Text;
    VAR
        DimensionValue: Record 349;
        TempDimensionValue: Record 349 TEMPORARY;
        CheckStr: Text;
    BEGIN
        // Possible input values: blank filter, code or code with *
        IF DELCHR(DimValueFilter) = '' THEN
            EXIT(DimValueFilter);

        DimensionValue.SETRANGE("Dimension Code", DimensionCode);
        DimensionValue.SETFILTER(Code, DimValueFilter);
        DimensionValue.SETFILTER(Totaling, '<>%1', '');
        IF DimensionValue.ISEMPTY THEN
            EXIT(DimValueFilter);

        AddTempDimValueFromTotaling(TempDimensionValue, CheckStr, DimensionCode, DimValueFilter);

        IF TempDimensionValue.FINDSET THEN
            REPEAT
                ResultTxt += TempDimensionValue.Code + '|'
            UNTIL TempDimensionValue.NEXT = 0;
        IF ResultTxt <> '' THEN
            ResultTxt := '(' + COPYSTR(ResultTxt, 1, STRLEN(ResultTxt) - 1) + ')';
    END;

    LOCAL PROCEDURE AddTempDimValueFromTotaling(VAR TempDimensionValue: Record 349 TEMPORARY; VAR CheckStr: Text; DimensionCode: Code[20]; Totaling: Text);
    VAR
        DimensionValue: Record 349;
    BEGIN
        IF STRPOS(CheckStr, '(' + Totaling + ')') > 0 THEN
            EXIT;
        CheckStr += '(' + Totaling + ')';
        DimensionValue.SETRANGE("Dimension Code", DimensionCode);
        DimensionValue.SETFILTER(Code, Totaling);
        IF DimensionValue.FINDSET THEN
            REPEAT
                IF DimensionValue.Totaling <> '' THEN
                    AddTempDimValueFromTotaling(TempDimensionValue, CheckStr, DimensionCode, DimensionValue.Totaling)
                ELSE BEGIN
                    TempDimensionValue := DimensionValue;
                    IF TempDimensionValue.INSERT THEN;
                END;
            UNTIL DimensionValue.NEXT = 0;
    END;

    PROCEDURE CheckPurchDim(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    VAR
        TempPurchLineLocal: Record 39 TEMPORARY;
    BEGIN
        CheckPurchDimCombHeader(PurchHeader);
        CheckPurchDimValuePostingHeader(PurchHeader);

        TempPurchLineLocal.COPY(TempPurchLine, TRUE);
        CheckPurchDimLines(PurchHeader, TempPurchLineLocal);
    END;

    LOCAL PROCEDURE CheckPurchDimCombHeader(PurchHeader: Record 38);
    BEGIN
        WITH PurchHeader DO
            IF NOT CheckDimIDComb("Dimension Set ID") THEN
                ERROR(DimensionIsBlockedErr, "Document Type", "No.", GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckPurchDimCombLine(PurchLine: Record 39);
    BEGIN
        WITH PurchLine DO
            IF NOT CheckDimIDComb("Dimension Set ID") THEN
                ERROR(LineDimensionBlockedErr, "Document Type", "Document No.", "Line No.", GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckPurchDimLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    BEGIN
        WITH TempPurchLine DO BEGIN
            RESET;
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    IF (PurchHeader.Receive AND ("Qty. to Receive" <> 0)) OR
                       (PurchHeader.Invoice AND ("Qty. to Invoice" <> 0)) OR
                       (PurchHeader.Ship AND ("Return Qty. to Ship" <> 0))
                    THEN BEGIN
                        CheckPurchDimCombLine(TempPurchLine);
                        CheckPurchDimValuePostingLine(TempPurchLine);
                    END
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CheckPurchDimValuePostingHeader(PurchHeader: Record 38);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        WITH PurchHeader DO BEGIN
            TableIDArr[1] := DATABASE::Vendor;
            NumberArr[1] := "Pay-to Vendor No.";
            TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
            NumberArr[2] := "Purchaser Code";
            TableIDArr[3] := DATABASE::Campaign;
            NumberArr[3] := "Campaign No.";
            TableIDArr[4] := DATABASE::"Responsibility Center";
            NumberArr[4] := "Responsibility Center";
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(InvalidDimensionsErr, "Document Type", "No.", GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE CheckPurchDimValuePostingLine(PurchLine: Record 39);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        WITH PurchLine DO BEGIN
            TableIDArr[1] := TypeToTableID3(Type);
            NumberArr[1] := "No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := "Job No.";
            TableIDArr[3] := DATABASE::"Work Center";
            NumberArr[3] := "Work Center No.";
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(LineInvalidDimensionsErr, "Document Type", "Document No.", "Line No.", GetDimValuePostingErr);
        END;
    END;

    PROCEDURE CheckSalesDim(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    VAR
        TempSalesLineLocal: Record 37 TEMPORARY;
    BEGIN
        CheckSalesDimCombHeader(SalesHeader);
        CheckSalesDimValuePostingHeader(SalesHeader);

        TempSalesLineLocal.COPY(TempSalesLine, TRUE);
        CheckSalesDimLines(SalesHeader, TempSalesLineLocal);
    END;

    LOCAL PROCEDURE CheckSalesDimCombHeader(SalesHeader: Record 36);
    BEGIN
        WITH SalesHeader DO
            IF NOT CheckDimIDComb("Dimension Set ID") THEN
                ERROR(DimensionIsBlockedErr, "Document Type", "No.", GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckSalesDimCombLine(SalesLine: Record 37);
    BEGIN
        WITH SalesLine DO
            IF NOT CheckDimIDComb("Dimension Set ID") THEN
                ERROR(LineDimensionBlockedErr, "Document Type", "Document No.", "Line No.", GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckSalesDimLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
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
    BEGIN
        WITH SalesHeader DO BEGIN
            TableIDArr[1] := DATABASE::Customer;
            NumberArr[1] := "Bill-to Customer No.";
            TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
            NumberArr[2] := "Salesperson Code";
            TableIDArr[3] := DATABASE::Campaign;
            NumberArr[3] := "Campaign No.";
            TableIDArr[4] := DATABASE::"Responsibility Center";
            NumberArr[4] := "Responsibility Center";
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(InvalidDimensionsErr, "Document Type", "No.", GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE CheckSalesDimValuePostingLine(SalesLine: Record 37);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        WITH SalesLine DO BEGIN
            TableIDArr[1] := TypeToTableID3(Type);
            NumberArr[1] := "No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := "Job No.";
            IF NOT CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") THEN
                ERROR(LineInvalidDimensionsErr, "Document Type", "Document No.", "Line No.", GetDimValuePostingErr);
        END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetupObjectNoList(VAR TempAllObjWithCaption: Record 2000000058 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckDimValuePosting(TableID: ARRAY[10] OF Integer; No: ARRAY[10] OF Code[20]; DimSetID: Integer; VAR IsChecked: Boolean; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeGetDefaultDimID(VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]; SourceCode: Code[20]; VAR GlobalDim1Code: Code[20]; VAR GlobalDim2Code: Code[20]; InheritFromDimSetID: Integer; InheritFromTableNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetRecDefaultDimID(RecVariant: Variant; CurrFieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]; VAR SourceCode: Code[20]; VAR InheritFromDimSetID: Integer; VAR InheritFromTableNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnTypeToTableID2(VAR TableID: Integer; Type: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckDimValueAllowed(DimVal: Record 349; VAR DimValueAllowed: Boolean; VAR DimErr: Text[250]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckICDimValueAllowed(ICDimVal: Record 412; VAR DimValueAllowed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetDefaultDimOnBeforeCreate(VAR TempDimBuf: Record 360 TEMPORARY; TableID: Integer; No: Code[20]; GLSetupShortcutDimCode: ARRAY[8] OF Code[20]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; VAR IsHandled: Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}






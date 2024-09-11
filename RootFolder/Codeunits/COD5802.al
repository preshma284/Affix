Codeunit 50020 "Inventory Posting To G/L 1"
{


    TableNo = 5802;
    Permissions = TableData 15 = r,
                TableData 48 = rimd,
                TableData 5802 = rm,
                TableData 5823 = rimd;
    trigger OnRun()
    VAR
        GenJnlLine: Record 81;
    BEGIN
        IF GlobalPostPerPostGroup THEN
            PostInvtPostBuf(Rec, GenJnlLine."Document No.", '', '', TRUE)
        // ELSE
            // PostInvtPostBuf(
            //   Rec,
            //   GenJnlLine."Document No.",
            //   GenJnlLine."External Document No.",
            //   COPYSTR(
            //     STRSUBSTNO(Text000, "Entry Type", GenJnlLine."Source No.", GenJnlLine."Posting Date"),
            //     1, MAXSTRLEN(GenJnlLine.Description)),
            //   FALSE);
    END;

    VAR
        GLSetup: Record 98;
        InvtSetup: Record 313;
        Currency: Record 4;
        SourceCodeSetup: Record 242;
        GlobalInvtPostBuf: Record 48 TEMPORARY;
        TempInvtPostBuf: ARRAY[4] OF Record 48 TEMPORARY;
        TempInvtPostToGLTestBuf: Record 5822 TEMPORARY;
        TempGLItemLedgRelation: Record 5823 TEMPORARY;
        GenJnlPostLine: Codeunit 12;
        GenJnlCheckLine: Codeunit 11;
        DimMgt: Codeunit 408;
        COGSAmt: Decimal;
        InvtAdjmtAmt: Decimal;
        DirCostAmt: Decimal;
        OvhdCostAmt: Decimal;
        VarPurchCostAmt: Decimal;
        VarMfgDirCostAmt: Decimal;
        VarMfgOvhdCostAmt: Decimal;
        WIPInvtAmt: Decimal;
        InvtAmt: Decimal;
        TotalCOGSAmt: Decimal;
        TotalInvtAdjmtAmt: Decimal;
        TotalDirCostAmt: Decimal;
        TotalOvhdCostAmt: Decimal;
        TotalVarPurchCostAmt: Decimal;
        TotalVarMfgDirCostAmt: Decimal;
        TotalVarMfgOvhdCostAmt: Decimal;
        TotalWIPInvtAmt: Decimal;
        TotalInvtAmt: Decimal;
        GlobalInvtPostBufEntryNo: Integer;
        PostBufDimNo: Integer;
        GLSetupRead: Boolean;
        SourceCodeSetupRead: Boolean;
        InvtSetupRead: Boolean;
        Text000: TextConst ENU = '%1 %2 on %3', ESP = '%1 %2 en %3';
        Text001: TextConst ENU = '%1 - %2, %3,%4,%5,%6', ESP = '%1 - %2, %3,%4,%5,%6';
        Text002: TextConst ENU = '"The following combination %1 = %2, %3 = %4, and %5 = %6 is not allowed."', ESP = '"No est� permitida la siguiente combinaci�n %1 = %2, %3 = %4, y %5 = %6."';
        RunOnlyCheck: Boolean;
        RunOnlyCheckSaved: Boolean;
        CalledFromItemPosting: Boolean;
        CalledFromTestReport: Boolean;
        GlobalPostPerPostGroup: Boolean;
        Text003: TextConst ENU = '%1 %2', ESP = '%1 %2';
        "---------------------------------- QB": Integer;
        QBCodeunitPublisher: Codeunit 7207352;
        FunctionQB: Codeunit 7207272;
        CodeunitModificManagement: Codeunit 7207273;


    //[External]
    PROCEDURE BufferInvtPosting(VAR ValueEntry: Record 5802): Boolean;
    VAR
        CostToPost: Decimal;
        CostToPostACY: Decimal;
        ExpCostToPost: Decimal;
        ExpCostToPostACY: Decimal;
        PostToGL: Boolean;
    BEGIN
        WITH ValueEntry DO BEGIN
            GetGLSetup;
            GetInvtSetup;
            IF (NOT InvtSetup."Expected Cost Posting to G/L") AND
               ("Expected Cost Posted to G/L" = 0) AND
               "Expected Cost"
            THEN
                EXIT(FALSE);

            IF NOT ("Entry Type" IN ["Entry Type"::"Direct Cost", "Entry Type"::Revaluation]) AND
               NOT CalledFromTestReport
            THEN BEGIN
                TESTFIELD("Expected Cost", FALSE);
                TESTFIELD("Cost Amount (Expected)", 0);
                TESTFIELD("Cost Amount (Expected) (ACY)", 0);
            END;

            IF InvtSetup."Expected Cost Posting to G/L" THEN BEGIN
                CalcCostToPost(ExpCostToPost, "Cost Amount (Expected)", "Expected Cost Posted to G/L", PostToGL);
                CalcCostToPost(ExpCostToPostACY, "Cost Amount (Expected) (ACY)", "Exp. Cost Posted to G/L (ACY)", PostToGL);
            END;
            CalcCostToPost(CostToPost, "Cost Amount (Actual)", "Cost Posted to G/L", PostToGL);
            CalcCostToPost(CostToPostACY, "Cost Amount (Actual) (ACY)", "Cost Posted to G/L (ACY)", PostToGL);
            OnAfterCalcCostToPostFromBuffer(ValueEntry, CostToPost, CostToPostACY, ExpCostToPost, ExpCostToPostACY);
            PostBufDimNo := 0;

            RunOnlyCheckSaved := RunOnlyCheck;
            IF NOT PostToGL THEN
                EXIT(FALSE);

            CASE "Item Ledger Entry Type" OF
                "Item Ledger Entry Type"::Purchase:
                    BufferPurchPosting(ValueEntry, CostToPost, CostToPostACY, ExpCostToPost, ExpCostToPostACY);
                "Item Ledger Entry Type"::Sale:
                    BufferSalesPosting(ValueEntry, CostToPost, CostToPostACY, ExpCostToPost, ExpCostToPostACY);
                "Item Ledger Entry Type"::"Positive Adjmt.",
              "Item Ledger Entry Type"::"Negative Adjmt.",
              "Item Ledger Entry Type"::Transfer:
                    BufferAdjmtPosting(ValueEntry, CostToPost, CostToPostACY, ExpCostToPost, ExpCostToPostACY);
                "Item Ledger Entry Type"::Consumption:
                    BufferConsumpPosting(ValueEntry, CostToPost, CostToPostACY);
                "Item Ledger Entry Type"::Output:
                    BufferOutputPosting(ValueEntry, CostToPost, CostToPostACY, ExpCostToPost, ExpCostToPostACY);
                "Item Ledger Entry Type"::"Assembly Consumption":
                    BufferAsmConsumpPosting(ValueEntry, CostToPost, CostToPostACY);
                "Item Ledger Entry Type"::"Assembly Output":
                    BufferAsmOutputPosting(ValueEntry, CostToPost, CostToPostACY);
                "Item Ledger Entry Type"::" ":
                    BufferCapPosting(ValueEntry, CostToPost, CostToPostACY);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
        END;

        IF UpdateGlobalInvtPostBuf(ValueEntry."Entry No.") THEN
            EXIT(TRUE);
        EXIT(CalledFromTestReport);
    END;

    LOCAL PROCEDURE BufferPurchPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal; ExpCostToPost: Decimal; ExpCostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    BEGIN
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"Invt. Accrual (Interim)", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Direct Cost Applied", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::"Indirect Cost":
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Overhead Applied", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::Variance:
                    BEGIN
                        TESTFIELD("Variance Type", "Variance Type"::Purchase);
                        InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                          GlobalInvtPostBuf."Account Type"::"Purchase Variance", //enum to option
                          CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::Revaluation:
                    BEGIN
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"Invt. Accrual (Interim)", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
    END;

    LOCAL PROCEDURE BufferSalesPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal; ExpCostToPost: Decimal; ExpCostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    BEGIN
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"COGS (Interim)", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::COGS, //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::Revaluation:
                    BEGIN
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"COGS (Interim)", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;

        OnAfterBufferSalesPosting(TempInvtPostBuf, ValueEntry, PostBufDimNo);
    END;

    LOCAL PROCEDURE BufferOutputPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal; ExpCostToPost: Decimal; ExpCostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    BEGIN
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"WIP Inventory", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"WIP Inventory", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::"Indirect Cost":
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Overhead Applied", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::Variance:
                    CASE "Variance Type" OF
                        "Variance Type"::Material:
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Material Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::Capacity:
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Capacity Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::Subcontracted:
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Subcontracted Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::"Capacity Overhead":
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Cap. Overhead Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::"Manufacturing Overhead":
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Mfg. Overhead Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        ELSE
                            ErrorNonValidCombination(ValueEntry);
                    END;
                "Entry Type"::Revaluation:
                    BEGIN
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"WIP Inventory", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
    END;

    LOCAL PROCEDURE BufferConsumpPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"WIP Inventory", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::Revaluation,
              "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
    END;

    LOCAL PROCEDURE BufferCapPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            IF "Order Type" = "Order Type"::Assembly THEN
                CASE "Entry Type" OF
                    "Entry Type"::"Direct Cost":
                        InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                          GlobalInvtPostBuf."Account Type"::"Direct Cost Applied", //enum to option
                          CostToPost, CostToPostACY, FALSE);
                    "Entry Type"::"Indirect Cost":
                        InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                          GlobalInvtPostBuf."Account Type"::"Overhead Applied", //enum to option
                          CostToPost, CostToPostACY, FALSE);
                    ELSE
                        ErrorNonValidCombination(ValueEntry);
                END
            ELSE
                CASE "Entry Type" OF
                    "Entry Type"::"Direct Cost":
                        InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::"WIP Inventory", //enum to option
                          GlobalInvtPostBuf."Account Type"::"Direct Cost Applied", //enum to option
                          CostToPost, CostToPostACY, FALSE);
                    "Entry Type"::"Indirect Cost":
                        InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::"WIP Inventory", //enum to option
                          GlobalInvtPostBuf."Account Type"::"Overhead Applied", //enum to option
                          CostToPost, CostToPostACY, FALSE);
                    ELSE
                        ErrorNonValidCombination(ValueEntry);
                END;
    END;

    LOCAL PROCEDURE BufferAsmOutputPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::"Indirect Cost":
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Overhead Applied", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::Variance:
                    CASE "Variance Type" OF
                        "Variance Type"::Material:
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Material Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::Capacity:
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Capacity Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::Subcontracted:
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Subcontracted Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::"Capacity Overhead":
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Cap. Overhead Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        "Variance Type"::"Manufacturing Overhead":
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Mfg. Overhead Variance", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                        ELSE
                            ErrorNonValidCombination(ValueEntry);
                    END;
                "Entry Type"::Revaluation:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
    END;

    LOCAL PROCEDURE BufferAsmConsumpPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                "Entry Type"::Revaluation,
              "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
    END;

    LOCAL PROCEDURE BufferAdjmtPosting(ValueEntry: Record 5802; CostToPost: Decimal; CostToPostACY: Decimal; ExpCostToPost: Decimal; ExpCostToPostACY: Decimal);
    BEGIN
        WITH ValueEntry DO
            CASE "Entry Type" OF
                "Entry Type"::"Direct Cost":
                    BEGIN
                        // Posting adjustments to Interim accounts (Service)
                        IF (ExpCostToPost <> 0) OR (ExpCostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::"Inventory (Interim)", //enum to option
                              GlobalInvtPostBuf."Account Type"::"COGS (Interim)", //enum to option
                              ExpCostToPost, ExpCostToPostACY, TRUE);
                        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
                            InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                              GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                              CostToPost, CostToPostACY, FALSE);
                    END;
                "Entry Type"::Revaluation,
              "Entry Type"::Rounding:
                    InitInvtPostBuf(
                      ValueEntry,
                      GlobalInvtPostBuf."Account Type"::Inventory, //enum to option
                      GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.", //enum to option
                      CostToPost, CostToPostACY, FALSE);
                ELSE
                    ErrorNonValidCombination(ValueEntry);
            END;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            IF GLSetup."Additional Reporting Currency" <> '' THEN
                Currency.GET(GLSetup."Additional Reporting Currency");
        END;
        GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetInvtSetup();
    BEGIN
        IF NOT InvtSetupRead THEN
            InvtSetup.GET;
        InvtSetupRead := TRUE;
    END;

    LOCAL PROCEDURE CalcCostToPost(VAR CostToPost: Decimal; AdjdCost: Decimal; VAR PostedCost: Decimal; VAR PostToGL: Boolean);
    BEGIN
        CostToPost := AdjdCost - PostedCost;

        IF CostToPost <> 0 THEN BEGIN
            IF NOT RunOnlyCheck THEN
                PostedCost := AdjdCost;
            PostToGL := TRUE;
        END;
    END;

    LOCAL PROCEDURE InitInvtPostBuf(ValueEntry: Record 5802; AccType: Enum "Invt. Posting Buffer Account Type"; BalAccType: Enum "Invt. Posting Buffer Account Type"; CostToPost: Decimal; CostToPostACY: Decimal; InterimAccount: Boolean);
    BEGIN
        OnBeforeInitInvtPostBuf(ValueEntry);

        PostBufDimNo := PostBufDimNo + 1;
        SetAccNo(TempInvtPostBuf[PostBufDimNo], ValueEntry, AccType, BalAccType);
        SetPostBufAmounts(TempInvtPostBuf[PostBufDimNo], CostToPost, CostToPostACY, InterimAccount);
        TempInvtPostBuf[PostBufDimNo]."Dimension Set ID" := ValueEntry."Dimension Set ID";
        OnAfterInitTempInvtPostBuf(TempInvtPostBuf, ValueEntry);

        PostBufDimNo := PostBufDimNo + 1;
        SetAccNo(TempInvtPostBuf[PostBufDimNo], ValueEntry, BalAccType, AccType);
        SetPostBufAmounts(TempInvtPostBuf[PostBufDimNo], -CostToPost, -CostToPostACY, InterimAccount);
        TempInvtPostBuf[PostBufDimNo]."Dimension Set ID" := ValueEntry."Dimension Set ID";
        OnAfterInitTempInvtPostBuf(TempInvtPostBuf, ValueEntry);

        OnAfterInitInvtPostBuf(ValueEntry);
    END;

    LOCAL PROCEDURE SetAccNo(VAR InvtPostBuf: Record 48; ValueEntry: Record 5802; AccType: Enum "Invt. Posting Buffer Account Type"; BalAccType: Enum "Invt. Posting Buffer Account Type");
    VAR
        InvtPostSetup: Record 5813;
        GenPostingSetup: Record 252;
        GLAccount: Record 15;
    BEGIN
        WITH InvtPostBuf DO BEGIN
            "Account No." := '';
            "Account Type" := AccType;//option to enum
            "Bal. Account Type" := BalAccType;//option to enum
            // QB.begin
            IF FunctionQB.AccessToQuobuilding THEN
                "Location Code" := CodeunitModificManagement.ReturnLocationEntry(ValueEntry)
            ELSE
                // QB.end
                "Location Code" := ValueEntry."Location Code";
            "Inventory Posting Group" :=
            GetInvPostingGroupCode(ValueEntry, AccType = "Account Type"::"WIP Inventory", ValueEntry."Inventory Posting Group");
            "Gen. Bus. Posting Group" := ValueEntry."Gen. Bus. Posting Group";
            "Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
            "Posting Date" := ValueEntry."Posting Date";

            IF UseInvtPostSetup THEN BEGIN
                IF CalledFromItemPosting THEN
                    InvtPostSetup.GET("Location Code", "Inventory Posting Group")
                ELSE
                    IF NOT InvtPostSetup.GET("Location Code", "Inventory Posting Group") THEN
                        EXIT;
            END ELSE BEGIN
                IF CalledFromItemPosting THEN
                    GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
                ELSE
                    IF NOT GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN
                        EXIT;
            END;

            CASE "Account Type" OF
                "Account Type"::Inventory:
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetInventoryAccount
                    ELSE
                        "Account No." := InvtPostSetup."Inventory Account";
                "Account Type"::"Inventory (Interim)":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetInventoryAccountInterim
                    ELSE
                        "Account No." := InvtPostSetup."Inventory Account (Interim)";
                "Account Type"::"WIP Inventory":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetWIPAccount
                    ELSE
                        "Account No." := InvtPostSetup."WIP Account";
                "Account Type"::"Material Variance":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetMaterialVarianceAccount
                    ELSE
                        "Account No." := InvtPostSetup."Material Variance Account";
                "Account Type"::"Capacity Variance":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetCapacityVarianceAccount
                    ELSE
                        "Account No." := InvtPostSetup."Capacity Variance Account";
                "Account Type"::"Subcontracted Variance":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetSubcontractedVarianceAccount
                    ELSE
                        "Account No." := InvtPostSetup."Subcontracted Variance Account";
                "Account Type"::"Cap. Overhead Variance":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetCapOverheadVarianceAccount
                    ELSE
                        "Account No." := InvtPostSetup."Cap. Overhead Variance Account";
                "Account Type"::"Mfg. Overhead Variance":
                    IF CalledFromItemPosting THEN
                        "Account No." := InvtPostSetup.GetMfgOverheadVarianceAccount
                    ELSE
                        "Account No." := InvtPostSetup."Mfg. Overhead Variance Account";
                "Account Type"::"Inventory Adjmt.":
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetInventoryAdjmtAccount
                    ELSE
                        "Account No." := GenPostingSetup."Inventory Adjmt. Account";
                "Account Type"::"Direct Cost Applied":
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetDirectCostAppliedAccount
                    ELSE
                        "Account No." := GenPostingSetup."Direct Cost Applied Account";
                "Account Type"::"Overhead Applied":
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetOverheadAppliedAccount
                    ELSE
                        "Account No." := GenPostingSetup."Overhead Applied Account";
                "Account Type"::"Purchase Variance":
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetPurchaseVarianceAccount
                    ELSE
                        "Account No." := GenPostingSetup."Purchase Variance Account";
                "Account Type"::COGS:
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetCOGSAccount
                    ELSE
                        "Account No." := GenPostingSetup."COGS Account";
                "Account Type"::"COGS (Interim)":
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetCOGSInterimAccount
                    ELSE
                        "Account No." := GenPostingSetup."COGS Account (Interim)";
                "Account Type"::"Invt. Accrual (Interim)":
                    IF CalledFromItemPosting THEN
                        "Account No." := GenPostingSetup.GetInventoryAccrualAccount
                    ELSE
                        "Account No." := GenPostingSetup."Invt. Accrual Acc. (Interim)";
            END;
            IF "Account No." <> '' THEN BEGIN
                GLAccount.GET("Account No.");
                IF GLAccount.Blocked THEN BEGIN
                    IF CalledFromItemPosting THEN
                        GLAccount.TESTFIELD(Blocked, FALSE);
                    IF NOT CalledFromTestReport THEN
                        "Account No." := '';
                END;
            END;
            OnAfterSetAccNo(InvtPostBuf, ValueEntry, CalledFromItemPosting);
        END;
    END;

    LOCAL PROCEDURE SetPostBufAmounts(VAR InvtPostBuf: Record 48; CostToPost: Decimal; CostToPostACY: Decimal; InterimAccount: Boolean);
    BEGIN
        WITH InvtPostBuf DO BEGIN
            "Interim Account" := InterimAccount;
            Amount := CostToPost;
            "Amount (ACY)" := CostToPostACY;
        END;
    END;

    LOCAL PROCEDURE UpdateGlobalInvtPostBuf(ValueEntryNo: Integer): Boolean;
    VAR
        i: Integer;
    BEGIN
        WITH GlobalInvtPostBuf DO BEGIN
            IF NOT CalledFromTestReport THEN
                FOR i := 1 TO PostBufDimNo DO
                    IF TempInvtPostBuf[i]."Account No." = '' THEN BEGIN
                        CLEAR(TempInvtPostBuf);
                        EXIT(FALSE);
                    END;
            FOR i := 1 TO PostBufDimNo DO BEGIN
                GlobalInvtPostBuf := TempInvtPostBuf[i];
                "Dimension Set ID" := TempInvtPostBuf[i]."Dimension Set ID";
                Negative := (TempInvtPostBuf[i].Amount < 0) OR (TempInvtPostBuf[i]."Amount (ACY)" < 0);

                UpdateReportAmounts;
                IF FIND THEN BEGIN
                    Amount := Amount + TempInvtPostBuf[i].Amount;
                    "Amount (ACY)" := "Amount (ACY)" + TempInvtPostBuf[i]."Amount (ACY)";
                    MODIFY;
                END ELSE BEGIN
                    GlobalInvtPostBufEntryNo := GlobalInvtPostBufEntryNo + 1;
                    "Entry No." := GlobalInvtPostBufEntryNo;
                    INSERT;
                END;

                IF NOT (RunOnlyCheck OR CalledFromTestReport) THEN BEGIN
                    TempGLItemLedgRelation.INIT;
                    TempGLItemLedgRelation."G/L Entry No." := "Entry No.";
                    TempGLItemLedgRelation."Value Entry No." := ValueEntryNo;
                    TempGLItemLedgRelation.INSERT;
                END;
            END;
        END;
        CLEAR(TempInvtPostBuf);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateReportAmounts();
    BEGIN
        WITH GlobalInvtPostBuf DO
            CASE "Account Type" OF
                "Account Type"::Inventory, "Account Type"::"Inventory (Interim)":
                    InvtAmt += Amount;
                "Account Type"::"WIP Inventory":
                    WIPInvtAmt += Amount;
                "Account Type"::"Inventory Adjmt.":
                    InvtAdjmtAmt += Amount;
                "Account Type"::"Invt. Accrual (Interim)":
                    InvtAdjmtAmt += Amount;
                "Account Type"::"Direct Cost Applied":
                    DirCostAmt += Amount;
                "Account Type"::"Overhead Applied":
                    OvhdCostAmt += Amount;
                "Account Type"::"Purchase Variance":
                    VarPurchCostAmt += Amount;
                "Account Type"::COGS:
                    COGSAmt += Amount;
                "Account Type"::"COGS (Interim)":
                    COGSAmt += Amount;
                "Account Type"::"Material Variance", "Account Type"::"Capacity Variance",
              "Account Type"::"Subcontracted Variance", "Account Type"::"Cap. Overhead Variance":
                    VarMfgDirCostAmt += Amount;
                "Account Type"::"Mfg. Overhead Variance":
                    VarMfgOvhdCostAmt += Amount;
            END;
    END;

    LOCAL PROCEDURE ErrorNonValidCombination(ValueEntry: Record 5802);
    BEGIN
        WITH ValueEntry DO
            IF CalledFromTestReport THEN
                InsertTempInvtPostToGLTestBuf2(ValueEntry)
            ELSE
                ERROR(
                  Text002,
                  FIELDCAPTION("Item Ledger Entry Type"), "Item Ledger Entry Type",
                  FIELDCAPTION("Entry Type"), "Entry Type",
                  FIELDCAPTION("Expected Cost"), "Expected Cost")
    END;

    LOCAL PROCEDURE InsertTempInvtPostToGLTestBuf2(ValueEntry: Record 5802);
    BEGIN
        WITH ValueEntry DO BEGIN
            TempInvtPostToGLTestBuf."Line No." := GetNextLineNo;
            TempInvtPostToGLTestBuf."Posting Date" := "Posting Date";
            TempInvtPostToGLTestBuf.Description := STRSUBSTNO(Text003, TABLECAPTION, "Entry No.");
            TempInvtPostToGLTestBuf.Amount := "Cost Amount (Actual)";
            TempInvtPostToGLTestBuf."Value Entry No." := "Entry No.";
            TempInvtPostToGLTestBuf."Dimension Set ID" := "Dimension Set ID";
            TempInvtPostToGLTestBuf.INSERT;
        END;
    END;

    LOCAL PROCEDURE GetNextLineNo(): Integer;
    VAR
        InvtPostToGLTestBuffer: Record 5822;
        LastLineNo: Integer;
    BEGIN
        InvtPostToGLTestBuffer := TempInvtPostToGLTestBuf;
        IF TempInvtPostToGLTestBuf.FINDLAST THEN
            LastLineNo := TempInvtPostToGLTestBuf."Line No." + 10000
        ELSE
            LastLineNo := 10000;
        TempInvtPostToGLTestBuf := InvtPostToGLTestBuffer;
        EXIT(LastLineNo);
    END;

    //[External]
    PROCEDURE PostInvtPostBufPerEntry(VAR ValueEntry: Record 5802);
    VAR
        DummyGenJnlLine: Record 81;
    BEGIN
        WITH ValueEntry DO
            PostInvtPostBuf(
              ValueEntry,
              "Document No.",
              "External Document No.",
              COPYSTR(
                STRSUBSTNO(Text000, "Entry Type", "Source No.", "Posting Date"),
                1, MAXSTRLEN(DummyGenJnlLine.Description)),
              FALSE);
    END;

    LOCAL PROCEDURE PostInvtPostBuf(VAR ValueEntry: Record 5802; DocNo: Code[20]; ExternalDocNo: Code[35]; Desc: Text[50]; PostPerPostGrp: Boolean);
    VAR
        GenJnlLine: Record 81;
        InvtPostingBuffer: Record 48;
    BEGIN
        WITH GlobalInvtPostBuf DO BEGIN
            RESET;
            OnPostInvtPostBufferOnBeforeFind(GlobalInvtPostBuf);
            IF NOT FINDSET THEN
                EXIT;

            GenJnlLine.INIT;
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."External Document No." := ExternalDocNo;
            GenJnlLine.Description := Desc;
            GetSourceCodeSetup;
            GenJnlLine."Source Code" := SourceCodeSetup."Inventory Post Cost";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Job No." := ValueEntry."Job No.";
            GenJnlLine."Reason Code" := ValueEntry."Reason Code";
            REPEAT
                GenJnlLine.VALIDATE("Posting Date", "Posting Date");
                IF SetAmt(GenJnlLine, Amount, "Amount (ACY)") THEN BEGIN
                    IF PostPerPostGrp THEN
                        SetDesc(GenJnlLine, GlobalInvtPostBuf);
                    GenJnlLine."Account No." := "Account No.";
                    GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      "Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
                      GenJnlLine."Shortcut Dimension 2 Code");
                    IF NOT CalledFromTestReport THEN
                        IF NOT RunOnlyCheck THEN BEGIN
                            IF NOT CalledFromItemPosting THEN
                                GenJnlPostLine.SetOverDimErr;

                            QBCodeunitPublisher.PostInvtPostBufCUInventoryPostingToGL(GenJnlLine, InvtPostingBuffer);   // QB

                            GenJnlPostLine.RunWithCheck(GenJnlLine);
                            // QB.begin
                            IF (FunctionQB.AccessToQuobuilding) AND (NOT GlobalPostPerPostGroup) THEN BEGIN
                                IF ValueEntry.Adjustment THEN BEGIN
                                    CodeunitModificManagement.TransferAdjustsJobConsumption(GenJnlLine, InvtPostingBuffer, ValueEntry, GenJnlPostLine);
                                END;
                            END
                        END ELSE BEGIN
                            IF FunctionQB.AccessToQuobuilding THEN
                                CodeunitModificManagement.VariationStock(GenJnlLine, GlobalInvtPostBuf);
                            // QB.end
                            GenJnlCheckLine.RunCheck(GenJnlLine)
                        END // QB
                    ELSE
                        InsertTempInvtPostToGLTestBuf(GenJnlLine, ValueEntry);
                END;
                IF NOT CalledFromTestReport AND NOT RunOnlyCheck THEN
                    CreateGLItemLedgRelation(ValueEntry);
            UNTIL NEXT = 0;
            RunOnlyCheck := RunOnlyCheckSaved;
            DELETEALL;
        END;
    END;

    LOCAL PROCEDURE GetSourceCodeSetup();
    BEGIN
        IF NOT SourceCodeSetupRead THEN
            SourceCodeSetup.GET;
        SourceCodeSetupRead := TRUE;
    END;

    LOCAL PROCEDURE SetAmt(VAR GenJnlLine: Record 81; Amt: Decimal; AmtACY: Decimal): Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            "Additional-Currency Posting" := "Additional-Currency Posting"::None;
            VALIDATE(Amount, Amt);

            GetGLSetup;
            IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                "Source Currency Code" := GLSetup."Additional Reporting Currency";
                "Source Currency Amount" := AmtACY;
                IF (Amount = 0) AND ("Source Currency Amount" <> 0) THEN BEGIN
                    "Additional-Currency Posting" :=
                      "Additional-Currency Posting"::"Additional-Currency Amount Only";
                    VALIDATE(Amount, "Source Currency Amount");
                    "Source Currency Amount" := 0;
                END;
            END;
        END;

        EXIT((Amt <> 0) OR (AmtACY <> 0));
    END;

    //[External]
    PROCEDURE SetDesc(VAR GenJnlLine: Record 81; InvtPostBuf: Record 48);
    BEGIN
        WITH InvtPostBuf DO
            GenJnlLine.Description :=
              COPYSTR(
                STRSUBSTNO(
                  Text001,
                  "Account Type", "Bal. Account Type",
                  "Location Code", "Inventory Posting Group",
                  "Gen. Bus. Posting Group", "Gen. Prod. Posting Group"),
                1, MAXSTRLEN(GenJnlLine.Description));
    END;

    LOCAL PROCEDURE InsertTempInvtPostToGLTestBuf(GenJnlLine: Record 81; ValueEntry: Record 5802);
    BEGIN
        WITH GenJnlLine DO BEGIN
            TempInvtPostToGLTestBuf.INIT;
            TempInvtPostToGLTestBuf."Line No." := GetNextLineNo;
            TempInvtPostToGLTestBuf."Posting Date" := "Posting Date";
            TempInvtPostToGLTestBuf."Document No." := "Document No.";
            TempInvtPostToGLTestBuf.Description := Description;
            TempInvtPostToGLTestBuf."Account No." := "Account No.";
            TempInvtPostToGLTestBuf.Amount := Amount;
            TempInvtPostToGLTestBuf."Source Code" := "Source Code";
            TempInvtPostToGLTestBuf."System-Created Entry" := TRUE;
            TempInvtPostToGLTestBuf."Value Entry No." := ValueEntry."Entry No.";
            TempInvtPostToGLTestBuf."Additional-Currency Posting" := "Additional-Currency Posting";
            TempInvtPostToGLTestBuf."Source Currency Code" := "Source Currency Code";
            TempInvtPostToGLTestBuf."Source Currency Amount" := "Source Currency Amount";
            TempInvtPostToGLTestBuf."Inventory Account Type" := GlobalInvtPostBuf."Account Type";
            TempInvtPostToGLTestBuf."Dimension Set ID" := "Dimension Set ID";
            IF GlobalInvtPostBuf.UseInvtPostSetup THEN BEGIN
                TempInvtPostToGLTestBuf."Location Code" := GlobalInvtPostBuf."Location Code";
                TempInvtPostToGLTestBuf."Invt. Posting Group Code" :=
                  GetInvPostingGroupCode(
                    ValueEntry,
                    TempInvtPostToGLTestBuf."Inventory Account Type" = TempInvtPostToGLTestBuf."Inventory Account Type"::"WIP Inventory",
                    GlobalInvtPostBuf."Inventory Posting Group")
            END ELSE BEGIN
                TempInvtPostToGLTestBuf."Gen. Bus. Posting Group" := GlobalInvtPostBuf."Gen. Bus. Posting Group";
                TempInvtPostToGLTestBuf."Gen. Prod. Posting Group" := GlobalInvtPostBuf."Gen. Prod. Posting Group";
            END;
            TempInvtPostToGLTestBuf.INSERT;
        END;
    END;

    LOCAL PROCEDURE CreateGLItemLedgRelation(VAR ValueEntry: Record 5802);
    VAR
        GLReg: Record 45;
    BEGIN
        GenJnlPostLine.GetGLReg(GLReg);
        IF GlobalPostPerPostGroup THEN BEGIN
            TempGLItemLedgRelation.RESET;
            TempGLItemLedgRelation.SETRANGE("G/L Entry No.", GlobalInvtPostBuf."Entry No.");
            TempGLItemLedgRelation.FINDSET;
            REPEAT
                ValueEntry.GET(TempGLItemLedgRelation."Value Entry No.");
                UpdateValueEntry(ValueEntry);
                CreateGLItemLedgRelationEntry(GLReg);
            UNTIL TempGLItemLedgRelation.NEXT = 0;
        END ELSE BEGIN
            UpdateValueEntry(ValueEntry);
            CreateGLItemLedgRelationEntry(GLReg);
        END;
    END;

    LOCAL PROCEDURE CreateGLItemLedgRelationEntry(GLReg: Record 45);
    VAR
        GLItemLedgRelation: Record 5823;
    BEGIN
        GLItemLedgRelation.INIT;
        GLItemLedgRelation."G/L Entry No." := GLReg."To Entry No.";
        GLItemLedgRelation."Value Entry No." := TempGLItemLedgRelation."Value Entry No.";
        GLItemLedgRelation."G/L Register No." := GLReg."No.";
        GLItemLedgRelation.INSERT;
        TempGLItemLedgRelation."G/L Entry No." := GlobalInvtPostBuf."Entry No.";
        TempGLItemLedgRelation.DELETE;
    END;

    LOCAL PROCEDURE UpdateValueEntry(VAR ValueEntry: Record 5802);
    BEGIN
        WITH ValueEntry DO BEGIN
            IF GlobalInvtPostBuf."Interim Account" THEN BEGIN
                "Expected Cost Posted to G/L" := "Cost Amount (Expected)";
                "Exp. Cost Posted to G/L (ACY)" := "Cost Amount (Expected) (ACY)";
            END ELSE BEGIN
                "Cost Posted to G/L" := "Cost Amount (Actual)";
                "Cost Posted to G/L (ACY)" := "Cost Amount (Actual) (ACY)";
            END;
            IF NOT CalledFromItemPosting THEN
                MODIFY;
        END;
    END;

    LOCAL PROCEDURE GetInvPostingGroupCode(ValueEntry: Record 5802; WIPInventory: Boolean; InvPostingGroupCode: Code[20]): Code[20];
    VAR
        Item: Record 27;
    BEGIN
        IF WIPInventory THEN
            IF ValueEntry."Source No." <> ValueEntry."Item No." THEN
                IF Item.GET(ValueEntry."Source No.") THEN
                    EXIT(Item."Inventory Posting Group");

        EXIT(InvPostingGroupCode);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterBufferSalesPosting(VAR TempInvtPostingBuffer: ARRAY[4] OF Record 48 TEMPORARY; ValueEntry: Record 5802; PostBufDimNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcCostToPostFromBuffer(VAR ValueEntry: Record 5802; VAR CostToPost: Decimal; VAR CostToPostACY: Decimal; VAR ExpCostToPost: Decimal; VAR ExpCostToPostACY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitInvtPostBuf(VAR ValueEntry: Record 5802);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitTempInvtPostBuf(VAR TempInvtPostBuf: ARRAY[4] OF Record 48 TEMPORARY; ValueEntry: Record 5802);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetAccNo(VAR InvtPostingBuffer: Record 48; ValueEntry: Record 5802; CalledFromItemPosting: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInitInvtPostBuf(VAR ValueEntry: Record 5802);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostInvtPostBufferOnBeforeFind(VAR GlobalInvtPostBuf: Record 48);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}










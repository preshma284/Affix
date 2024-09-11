Codeunit 50101 "Gen. Jnl.-Post Line 1"
{


    TableNo = 81;
    Permissions = TableData 15 = r,
                TableData 17 = rimd,
                TableData 21 = imd,
                TableData 25 = imd,
                TableData 45 = imd,
                TableData 253 = rimd,
                TableData 254 = imd,
                TableData 271 = imd,
                TableData 272 = imd,
                TableData 379 = imd,
                TableData 380 = imd,
                TableData 1053 = rim,
                TableData 5222 = imd,
                TableData 5223 = imd,
                TableData 5601 = rimd,
                TableData 5617 = imd,
                TableData 5625 = rimd;
    trigger OnRun()
    BEGIN
        GetGLSetup;
        RunWithCheck(Rec);
    END;

    VAR
        NeedsRoundingErr: TextConst ENU = '%1 needs to be rounded', ESP = '%1 necesita redondearse';
        PurchaseAlreadyExistsErr: TextConst ENU = 'Purchase %1 %2 already exists for this vendor.', ESP = 'Ya existe la compra %1 %2 para este proveedor.';
        BankPaymentTypeMustNotBeFilledErr: TextConst ENU = 'Bank Payment Type must not be filled if Currency Code is different in Gen. Journal Line and Bank Account.', ESP = 'Tipo pago por banco no debe rellenarse si C�d. divisa es diferente en L�n. diario general y Banco.';
        DocNoMustBeEnteredErr: TextConst ENU = 'Document No. must be entered when Bank Payment Type is %1.', ESP = 'Si el Tipo pago por banco es %1, se debe especificar el campo N� documento.';
        CheckAlreadyExistsErr: TextConst ENU = 'Check %1 already exists for this Bank Account.', ESP = 'Ya existe el cheque %1 en este banco.';
        GLSetup: Record 98;
        GlobalGLEntry: Record 17;
        TempGLEntryBuf: Record 17 TEMPORARY;
        TempGLEntryVAT: Record 17 TEMPORARY;
        GLReg: Record 45;
        AddCurrency: Record 4;
        CurrExchRate: Record 330;
        VATEntry: Record 254;
        TaxDetail: Record 322;
        UnrealizedCustLedgEntry: Record 21;
        UnrealizedVendLedgEntry: Record 25;
        GLEntryVATEntryLink: Record 253;
        TempVATEntry: Record 254 TEMPORARY;
        TempRejCustLedgEntry: Record 21 TEMPORARY;
        CarteraSetup: Record 7000016;
        GenJnlCheckLine: Codeunit 50100;
        PaymentToleranceMgt: Codeunit 426;
        DeferralUtilities: Codeunit 1720;
        DeferralDocType: Option "Purchase","Sales","G/L";
        LastDocType: Enum "Gen. Journal Document Type";
        AddCurrencyCode: Code[10];
        GLSourceCode: Code[10];
        LastDocNo: Code[20];
        FiscalYearStartDate: Date;
        CurrencyDate: Date;
        LastDate: Date;
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        CurrentBalance: Decimal;
        TotalAddCurrAmount: Decimal;
        TotalAmount: Decimal;
        UnrealizedRemainingAmountCust: Decimal;
        UnrealizedRemainingAmountVend: Decimal;
        AmountRoundingPrecision: Decimal;
        AddCurrGLEntryVATAmt: Decimal;
        CurrencyFactor: Decimal;
        FirstEntryNo: Integer;
        NextEntryNo: Integer;
        NextVATEntryNo: Integer;
        FirstNewVATEntryNo: Integer;
        FirstTransactionNo: Integer;
        NextTransactionNo: Integer;
        NextConnectionNo: Integer;
        NextCheckEntryNo: Integer;
        InsertedTempGLEntryVAT: Integer;
        GLEntryNo: Integer;
        UseCurrFactorOnly: Boolean;
        NonAddCurrCodeOccured: Boolean;
        FADimAlreadyChecked: Boolean;
        ResidualRoundingErr: TextConst ENU = 'Residual caused by rounding of %1', ESP = 'Ajuste residual generado por el redondeo de %1';
        DimensionUsedErr: TextConst ENU = 'A dimension used in %1 %2, %3, %4 has caused an error. %5.', ESP = 'Una dimensi�n usada en %1 %2, %3 y %4 ha producido un error. %5.';
        OverrideDimErr: Boolean;
        JobLine: Boolean;
        CheckUnrealizedCust: Boolean;
        CheckUnrealizedVend: Boolean;
        GLSetupRead: Boolean;
        CustLedgEntry: Record 21;
        VendLedgEntry: Record 25;
        Doc: Record 7000002;
        LastTempTransNo: Integer;
        DocAmountLCY: Decimal;
        DiscDocAmountLCY: Decimal;
        CollDocAmountLCY: Decimal;
        RejDocAmountLCY: Decimal;
        DocLock: Boolean;
        AccNo: Code[20];
        DiscRiskFactAmountLCY: Decimal;
        DiscUnriskFactAmountLCY: Decimal;
        CollFactAmountLCY: Decimal;
        DeltaUnrealAmount: Decimal;
        FromClosedDoc: Boolean;
        FromBillSettlement: Boolean;
        DeltaAmountLCY: Decimal;
        IDBillSettlement: Boolean;
        BillFromJournal: Boolean;
        CustLedgEntryInserted2: Boolean;
        VendLedgEntryInserted2: Boolean;
        DocPost: Codeunit 7000006;
        NextEntryNo2: Integer;
        Text1100000: TextConst ENU = 'Unrealized VAT Type must be "Percentage" in VAT Posting Setup.', ESP = 'Tipo IVA no realizado debe ser porcentaje en configuraci�n grupo registro IVA.';
        Text1100001: TextConst ENU = 'Invoice No. %1 does not exist', ESP = 'N� factura %1 no existe';
        Text1100006: TextConst ENU = 'Invoice %1', ESP = 'Factura %1';
        Text1100007: TextConst ENU = '%1 cannot be applied, since it is included in a bill group.', ESP = '%1 no se puede liquidar, ya que est� incluido en una remesa.';
        Text1100008: TextConst ENU = 'Remove it from its bill group and try again.', ESP = 'B�rrelo de la remesa e int�ntelo de nuevo.';
        Text1100009: TextConst ENU = '%1 cannot be applied, since it is included in a payment order.', ESP = '%1 no se puede liquidar, ya que est� incluido en una orden pago.';
        Text1100010: TextConst ENU = 'Remove it from its payment order and try again.', ESP = 'B�rrelo de la orden de pago e int�ntelo de nuevo.';
        AppliedAmountLCY2: Decimal;
        AppliesToDocType: Integer;
        IsCreditMemo: Boolean;
        OriginalEntryExist: Boolean;
        TotalAmountForTax: Decimal;
        ForceDocBalance: Boolean;
        Text1100013: TextConst ENU = 'You do not have permissions to apply or unapply documents in the Cartera Module.', ESP = 'No tiene permisos para liquidar o desliquidar documentos en el M�dulo Cartera.';
        InvalidPostingDateErr: TextConst ENU = '%1 is not within the range of posting dates for your company.', ESP = '%1 no est� dentro del intervalo de fechas de registro de la empresa.';
        DescriptionMustNotBeBlankErr: TextConst ENU = 'When %1 is selected for %2, %3 must have a value.', ESP = 'Cuando se selecciona %1 para %2, %3 debe tener un valor.';
        NoDeferralScheduleErr: TextConst ENU = 'You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.', ESP = 'Si se selecciona una plantilla de fraccionamiento, debe crear una previsi�n de fraccionamiento. L�nea: %1, Plantilla de fraccionamiento: %2.';
        ZeroDeferralAmtErr: TextConst ENU = 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', ESP = 'Los importes de fraccionamiento no pueden ser 0. L�nea: %1, Plantilla de fraccionamiento: %2.';
        IsGLRegInserted: Boolean;
        "------------------------------- QB": Integer;
        boolReturnDim: Boolean;
        DimensionSetID: Integer;
        GenJnlLineQB: Record 81;
        SourceCodeSetup: Record 242;
        FunctionQB: Codeunit 7207272;
        QBCodeunitPublisher: Codeunit 7207352;
        QBTableSubscriber: Codeunit 7207347;
        QBJobNo: Code[20];

    //[External]
    PROCEDURE GetGLReg(VAR NewGLReg: Record 45);
    BEGIN
        NewGLReg := GLReg;
    END;

    //[External]
    PROCEDURE RunWithCheck(VAR GenJnlLine2: Record 81): Integer;
    VAR
        GenJnlLine: Record 81;
    BEGIN
        GenJnlLine.COPY(GenJnlLine2);
        Code(GenJnlLine, TRUE);
        OnAfterRunWithCheck(GenJnlLine);
        GenJnlLine2 := GenJnlLine;
        EXIT(GLEntryNo);
    END;

    //[External]
    PROCEDURE RunWithoutCheck(VAR GenJnlLine2: Record 81): Integer;
    VAR
        GenJnlLine: Record 81;
    BEGIN
        GenJnlLine.COPY(GenJnlLine2);
        Code(GenJnlLine, FALSE);
        OnAfterRunWithoutCheck(GenJnlLine);
        GenJnlLine2 := GenJnlLine;
        EXIT(GLEntryNo);
    END;

    LOCAL PROCEDURE Code(VAR GenJnlLine: Record 81; CheckLine: Boolean);
    VAR
        Balancing: Boolean;
        IsTransactionConsistent: Boolean;
        IsPosted: Boolean;
    BEGIN
        IsPosted := FALSE;
        OnBeforeCode(GenJnlLine, CheckLine, IsPosted, GLReg);
        IF IsPosted THEN
            EXIT;

        GetGLSourceCode;

        WITH GenJnlLine DO BEGIN
            IF EmptyLine THEN BEGIN
                InitLastDocDate(GenJnlLine);
                EXIT;
            END;
            /*{--------------------------------- JAV 27/06/21: - QB 1.09.03 Esta parte se comenta porque se hace ahora de otra manera
                    //QB ++
                    QBCodeunitPublisher.FunSaveDimensionGenJnlPostLine(boolReturnDim,DimensionSetID,GenJnlLine);
                    IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN BEGIN
                      QBJobNo := GenJnlLine."Job No.";
                      GenJnlLine."Job No." := '';
                    END;
                    //QB --
                    --------------------------------------------------------------------------------------------------------------------------}*/

            IF CheckLine THEN BEGIN
                IF OverrideDimErr THEN
                    GenJnlCheckLine.SetOverDimErr;
                GenJnlCheckLine.RunCheck(GenJnlLine);
            END;

            AmountRoundingPrecision := InitAmounts(GenJnlLine);

            IF "Bill-to/Pay-to No." = '' THEN
                CASE TRUE OF
                    "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]:
                        "Bill-to/Pay-to No." := "Account No.";
                    "Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]:
                        "Bill-to/Pay-to No." := "Bal. Account No.";
                END;
            IF "Document Date" = 0D THEN
                "Document Date" := "Posting Date";
            IF "Due Date" = 0D THEN
                "Due Date" := "Posting Date";

            JobLine := ("Job No." <> '');
            /*{--------------------------------- JAV 27/06/21: - QB 1.09.03 Esta parte se comenta porque se hace ahora de otra manera
                    //QB ++
                    QBCodeunitPublisher.FunSaveDimensionGenJnlPostLine(boolReturnDim,DimensionSetID,GenJnlLine);
                    IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN BEGIN
                      GenJnlLine."Job No." := QBJobNo;
                    END;
                    //QB --
                    --------------------------------------------------------------------------------------------------------------------------}*/

            OnBeforeStartOrContinuePosting(GenJnlLine, LastDocType, LastDocNo, LastDate, NextEntryNo);

            IF NextEntryNo = 0 THEN
                StartPosting(GenJnlLine)
            ELSE
                ContinuePosting(GenJnlLine);

            IF "Account No." <> '' THEN BEGIN
                IF ("Bal. Account No." <> '') AND
                   (NOT "System-Created Entry") AND
                   ("Account Type" IN
                    ["Account Type"::Customer,
                     "Account Type"::Vendor,
                     "Account Type"::"Fixed Asset"])
                THEN BEGIN
                    CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);
                    Balancing := TRUE;
                END;

                PostGenJnlLine(GenJnlLine, Balancing);
            END;

            IF "Bal. Account No." <> '' THEN BEGIN
                CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);
                PostGenJnlLine(GenJnlLine, NOT Balancing);
            END;

            CheckPostUnrealizedVAT(GenJnlLine, TRUE);

            GenJnlLineQB := GenJnlLine; //QB

            CreateDeferralScheduleFromGL(GenJnlLine, Balancing);

            IsTransactionConsistent := FinishPosting(GenJnlLine);
        END;

        OnAfterGLFinishPosting(
          GlobalGLEntry, GenJnlLine, IsTransactionConsistent, FirstTransactionNo, GLReg, TempGLEntryBuf, NextEntryNo, NextTransactionNo);
    END;

    LOCAL PROCEDURE PostGenJnlLine(VAR GenJnlLine: Record 81; Balancing: Boolean);
    BEGIN
        OnBeforePostGenJnlLine(GenJnlLine, Balancing);

        WITH GenJnlLine DO
            CASE "Account Type" OF
                "Account Type"::"G/L Account":
                    PostGLAcc(GenJnlLine, Balancing);
                "Account Type"::Customer:
                    PostCust(GenJnlLine, Balancing);
                "Account Type"::Vendor:
                    PostVend(GenJnlLine, Balancing);
                "Account Type"::Employee:
                    PostEmployee(GenJnlLine);
                "Account Type"::"Bank Account":
                    PostBankAcc(GenJnlLine, Balancing);
                "Account Type"::"Fixed Asset":
                    PostFixedAsset(GenJnlLine);
                "Account Type"::"IC Partner":
                    PostICPartner(GenJnlLine);
            END;
    END;

    LOCAL PROCEDURE InitAmounts(VAR GenJnlLine: Record 81): Decimal;
    VAR
        Currency: Record 4;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF "Currency Code" = '' THEN BEGIN
                Currency.InitRoundingPrecision;
                "Amount (LCY)" := Amount;
                "VAT Amount (LCY)" := "VAT Amount";
                "VAT Base Amount (LCY)" := "VAT Base Amount";
            END ELSE BEGIN
                Currency.GET("Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
                IF NOT "System-Created Entry" THEN BEGIN
                    "Source Currency Code" := "Currency Code";
                    "Source Currency Amount" := Amount;
                    "Source Curr. VAT Base Amount" := "VAT Base Amount";
                    "Source Curr. VAT Amount" := "VAT Amount";
                END;
            END;
            Amount := ROUND(Amount, Currency."Amount Rounding Precision");
            "Amount (LCY)" := ROUND("Amount (LCY)");
            IF "Additional-Currency Posting" = "Additional-Currency Posting"::None THEN BEGIN
                IF Amount <> ROUND(Amount, Currency."Amount Rounding Precision") THEN
                    FIELDERROR(
                      Amount,
                      STRSUBSTNO(NeedsRoundingErr, Amount));
                IF "Amount (LCY)" <> ROUND("Amount (LCY)") THEN
                    FIELDERROR(
                      "Amount (LCY)",
                      STRSUBSTNO(NeedsRoundingErr, "Amount (LCY)"));
            END;
            EXIT(Currency."Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE InitLastDocDate(GenJnlLine: Record 81);
    BEGIN
        WITH GenJnlLine DO BEGIN
            LastDocType := "Document Type";//enum to option
            LastDocNo := "Document No.";
            LastDate := "Posting Date";
        END;
    END;

    LOCAL PROCEDURE InitNextEntryNo();
    VAR
        GLEntry: Record 17;//SECURITYFILTERING(Ignored);
    BEGIN
        GLEntry.LOCKTABLE;
        IF GLEntry.FINDLAST THEN BEGIN
            NextEntryNo := GLEntry."Entry No." + 1;
            NextTransactionNo := GLEntry."Transaction No." + 1;
        END ELSE BEGIN
            NextEntryNo := 1;
            NextTransactionNo := 1;
        END;
    END;

    LOCAL PROCEDURE InitVAT(VAR GenJnlLine: Record 81; VAR GLEntry: Record 17; VAR VATPostingSetup: Record 325);
    VAR
        LCYCurrency: Record 4;
        SalesTaxCalculate: Codeunit 398;
    BEGIN
        OnBeforeInitVAT(GenJnlLine, GLEntry, VATPostingSetup);

        LCYCurrency.InitRoundingPrecision;
        WITH GenJnlLine DO
            IF "Gen. Posting Type".AsInteger() <> 0 THEN BEGIN // None
                VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                TESTFIELD("VAT Calculation Type", VATPostingSetup."VAT Calculation Type");
                CASE "VAT Posting" OF
                    "VAT Posting"::"Automatic VAT Entry":
                        BEGIN
                            GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                            CASE "VAT Calculation Type" OF
                                "VAT Calculation Type"::"Normal VAT":
                                    IF "VAT Difference" <> 0 THEN BEGIN
                                        GLEntry.Amount := "VAT Base Amount (LCY)";
                                        GLEntry."VAT Amount" := "Amount (LCY)" - GLEntry.Amount;
                                        GLEntry."Additional-Currency Amount" := "Source Curr. VAT Base Amount";
                                        IF "Source Currency Code" = AddCurrencyCode THEN
                                            AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                                        ELSE
                                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                    END ELSE BEGIN
                                        GLEntry."VAT Amount" :=
                                          ROUND(
                                            "Amount (LCY)" * VATPostingSetup."VAT+EC %" / (100 + VATPostingSetup."VAT+EC %"),
                                            LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection);
                                        GLEntry.Amount := "Amount (LCY)" - GLEntry."VAT Amount";
                                        IF "Source Currency Code" = AddCurrencyCode THEN
                                            AddCurrGLEntryVATAmt :=
                                              ROUND(
                                                "Source Currency Amount" * VATPostingSetup."VAT+EC %" / (100 + VATPostingSetup."VAT+EC %"),
                                                AddCurrency."Amount Rounding Precision", AddCurrency.VATRoundingDirection)
                                        ELSE
                                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                        GLEntry."Additional-Currency Amount" := "Source Currency Amount" - AddCurrGLEntryVATAmt;
                                    END;
                                "VAT Calculation Type"::"Reverse Charge VAT":
                                    CASE "Gen. Posting Type" OF
                                        "Gen. Posting Type"::Purchase:
                                            IF "VAT Difference" <> 0 THEN BEGIN
                                                GLEntry."VAT Amount" := "VAT Amount (LCY)";
                                                IF "Source Currency Code" = AddCurrencyCode THEN
                                                    AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                                                ELSE
                                                    AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                            END ELSE BEGIN
                                                GLEntry."VAT Amount" :=
                                                  ROUND(
                                                    GLEntry.Amount * VATPostingSetup."VAT+EC %" / 100,
                                                    LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection);
                                                IF "Source Currency Code" = AddCurrencyCode THEN
                                                    AddCurrGLEntryVATAmt :=
                                                      ROUND(
                                                        GLEntry."Additional-Currency Amount" * VATPostingSetup."VAT+EC %" / 100,
                                                        AddCurrency."Amount Rounding Precision", AddCurrency.VATRoundingDirection)
                                                ELSE
                                                    AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                            END;
                                        "Gen. Posting Type"::Sale:
                                            BEGIN
                                                GLEntry."VAT Amount" := 0;
                                                AddCurrGLEntryVATAmt := 0;
                                            END;
                                    END;
                                "VAT Calculation Type"::"Full VAT":
                                    BEGIN
                                        CASE "Gen. Posting Type" OF
                                            "Gen. Posting Type"::Sale:
                                                TESTFIELD("Account No.", VATPostingSetup.GetSalesAccount(FALSE));
                                            "Gen. Posting Type"::Purchase:
                                                TESTFIELD("Account No.", VATPostingSetup.GetPurchAccount(FALSE));
                                        END;
                                        GLEntry.Amount := 0;
                                        GLEntry."Additional-Currency Amount" := 0;
                                        GLEntry."VAT Amount" := "Amount (LCY)";
                                        IF "Source Currency Code" = AddCurrencyCode THEN
                                            AddCurrGLEntryVATAmt := "Source Currency Amount"
                                        ELSE
                                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr("Amount (LCY)");
                                    END;
                                "VAT Calculation Type"::"Sales Tax":
                                    BEGIN
                                        IF ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) AND
                                           "Use Tax"
                                        THEN BEGIN
                                            GLEntry."VAT Amount" :=
                                              ROUND(
                                                SalesTaxCalculate.CalculateTax(
                                                  "Tax Area Code", "Tax Group Code", "Tax Liable",
                                                  "Posting Date", "Amount (LCY)", Quantity, 0));
                                            GLEntry.Amount := "Amount (LCY)";
                                        END ELSE BEGIN
                                            GLEntry.Amount :=
                                              ROUND(
                                                SalesTaxCalculate.ReverseCalculateTax(
                                                  "Tax Area Code", "Tax Group Code", "Tax Liable",
                                                  "Posting Date", "Amount (LCY)", Quantity, 0));
                                            GLEntry."VAT Amount" := "Amount (LCY)" - GLEntry.Amount;
                                        END;
                                        GLEntry."Additional-Currency Amount" := "Source Currency Amount";
                                        IF "Source Currency Code" = AddCurrencyCode THEN
                                            AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                                        ELSE
                                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                    END;
                            END;
                        END;
                    "VAT Posting"::"Manual VAT Entry":
                        IF "Gen. Posting Type" <> "Gen. Posting Type"::Settlement THEN BEGIN
                            GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                            GLEntry."VAT Amount" := "VAT Amount (LCY)";
                            IF "Source Currency Code" = AddCurrencyCode THEN
                                AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                            ELSE
                                AddCurrGLEntryVATAmt := CalcLCYToAddCurr("VAT Amount (LCY)");
                        END;
                END;
            END;

        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(GLEntry.Amount, GLEntry."Additional-Currency Amount", GLEntry."Additional-Currency Amount", TRUE, GenJnlLine);

        OnAfterInitVAT(GenJnlLine, GLEntry, VATPostingSetup, AddCurrGLEntryVATAmt);
    END;

    LOCAL PROCEDURE PostVAT(GenJnlLine: Record 81; VAR GLEntry: Record 17; VATPostingSetup: Record 325);
    VAR
        TaxDetail2: Record 322;
        SalesTaxCalculate: Codeunit 398;
        VATAmount: Decimal;
        VATAmount2: Decimal;
        VATBase: Decimal;
        VATBase2: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        SrcCurrSalesTaxBaseAmount: Decimal;
        RemSrcCurrVATAmount: Decimal;
        SalesTaxBaseAmount: Decimal;
        TaxDetailFound: Boolean;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforePostVAT(GenJnlLine, GLEntry, VATPostingSetup, IsHandled);
        IF IsHandled THEN
            EXIT;

        WITH GenJnlLine DO
            // Post VAT
            // VAT for VAT entry
            CASE "VAT Calculation Type" OF
                "VAT Calculation Type"::"Normal VAT",
                "VAT Calculation Type"::"Reverse Charge VAT",
                "VAT Calculation Type"::"Full VAT":
                    BEGIN
                        IF "VAT Posting" = "VAT Posting"::"Automatic VAT Entry" THEN
                            "VAT Base Amount (LCY)" := GLEntry.Amount;
                        IF "Gen. Posting Type" = "Gen. Posting Type"::Settlement THEN
                            AddCurrGLEntryVATAmt := "Source Curr. VAT Amount";
                        InsertVAT(
                          GenJnlLine, VATPostingSetup,
                          GLEntry.Amount, GLEntry."VAT Amount", "VAT Base Amount (LCY)", "Source Currency Code",
                          GLEntry."Additional-Currency Amount", AddCurrGLEntryVATAmt, "Source Curr. VAT Base Amount");
                        NextConnectionNo := NextConnectionNo + 1;
                    END;
                "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                        CASE "VAT Posting" OF
                            "VAT Posting"::"Automatic VAT Entry":
                                SalesTaxBaseAmount := GLEntry.Amount;
                            "VAT Posting"::"Manual VAT Entry":
                                SalesTaxBaseAmount := "VAT Base Amount (LCY)";
                        END;
                        IF ("VAT Posting" = "VAT Posting"::"Manual VAT Entry") AND
                           ("Gen. Posting Type" = "Gen. Posting Type"::Settlement)
                        THEN
                            InsertVAT(
                              GenJnlLine, VATPostingSetup,
                              GLEntry.Amount, GLEntry."VAT Amount", "VAT Base Amount (LCY)", "Source Currency Code",
                              "Source Curr. VAT Base Amount", "Source Curr. VAT Amount", "Source Curr. VAT Base Amount")
                        ELSE BEGIN
                            CLEAR(SalesTaxCalculate);
                            // SalesTaxCalculate.SetAmount(ABS(TotalAmountForTax), ABS(SalesTaxBaseAmount + GLEntry."VAT Amount"));
                            SalesTaxCalculate.InitSalesTaxLines(
                              "Tax Area Code", "Tax Group Code", "Tax Liable",
                              SalesTaxBaseAmount, Quantity, "Posting Date", GLEntry."VAT Amount");
                            SrcCurrVATAmount := 0;
                            SrcCurrSalesTaxBaseAmount := CalcLCYToAddCurr(SalesTaxBaseAmount);
                            RemSrcCurrVATAmount := AddCurrGLEntryVATAmt;
                            TaxDetailFound := FALSE;
                            WHILE SalesTaxCalculate.GetSalesTaxLine(TaxDetail2, VATAmount, VATBase) DO BEGIN
                                RemSrcCurrVATAmount := RemSrcCurrVATAmount - SrcCurrVATAmount;
                                IF TaxDetailFound THEN
                                    InsertVAT(
                                      GenJnlLine, VATPostingSetup,
                                      SalesTaxBaseAmount, VATAmount2, VATBase2, "Source Currency Code",
                                      SrcCurrSalesTaxBaseAmount, SrcCurrVATAmount, SrcCurrVATBase);
                                TaxDetailFound := TRUE;
                                TaxDetail := TaxDetail2;
                                VATAmount2 := VATAmount;
                                VATBase2 := VATBase;
                                SrcCurrVATAmount := CalcLCYToAddCurr(VATAmount);
                                SrcCurrVATBase := CalcLCYToAddCurr(VATBase);
                            END;
                            IF TaxDetailFound THEN
                                InsertVAT(
                                  GenJnlLine, VATPostingSetup,
                                  SalesTaxBaseAmount, VATAmount2, VATBase2, "Source Currency Code",
                                  SrcCurrSalesTaxBaseAmount, RemSrcCurrVATAmount, SrcCurrVATBase);
                            InsertSummarizedVAT(GenJnlLine);
                        END;
                    END;
            END;

        OnAfterPostVAT(GenJnlLine, GLEntry, VATPostingSetup);
    END;

    LOCAL PROCEDURE InsertVAT(GenJnlLine: Record 81; VATPostingSetup: Record 325; GLEntryAmount: Decimal; GLEntryVATAmount: Decimal; GLEntryBaseAmount: Decimal; SrcCurrCode: Code[10]; SrcCurrGLEntryAmt: Decimal; SrcCurrGLEntryVATAmt: Decimal; SrcCurrGLEntryBaseAmt: Decimal);
    VAR
        TaxJurisdiction: Record 320;
        VATProductPostingGroup: Record 324;
        VATAmount: Decimal;
        VATBase: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        VATDifferenceLCY: Decimal;
        SrcCurrVATDifference: Decimal;
        UnrealizedVAT: Boolean;
    BEGIN
        OnBeforeInsertVAT(
          GenJnlLine, VATEntry, UnrealizedVAT, AddCurrencyCode, VATPostingSetup, GLEntryAmount, GLEntryVATAmount, GLEntryBaseAmount,
          SrcCurrCode, SrcCurrGLEntryAmt, SrcCurrGLEntryVATAmt, SrcCurrGLEntryBaseAmt);

        WITH GenJnlLine DO BEGIN
            // Post VAT
            // VAT for VAT entry
            VATEntry.INIT;
            VATEntry.CopyFromGenJnlLine(GenJnlLine);
            VATEntry.SetVATCashRegime(VATPostingSetup, "Gen. Posting Type".AsInteger());
            VATEntry."Entry No." := NextVATEntryNo;
            VATEntry."EU Service" := VATPostingSetup."EU Service";
            VATEntry."Transaction No." := NextTransactionNo;
            VATEntry."Sales Tax Connection No." := NextConnectionNo;

            IF "Gen. Posting Type" = "Gen. Posting Type"::Sale THEN
                IF VATProductPostingGroup.GET("VAT Prod. Posting Group") THEN
                    VATEntry."Delivery Operation Code" := VATProductPostingGroup."Delivery Operation Code";
            GetSellToBuyFrom(GenJnlLine, VATEntry);
            VATEntry."No Taxable Type" := VATPostingSetup."No Taxable Type";

            IF "VAT Difference" = 0 THEN
                VATDifferenceLCY := 0
            ELSE
                IF "Currency Code" = '' THEN
                    VATDifferenceLCY := "VAT Difference"
                ELSE
                    VATDifferenceLCY :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code", "VAT Difference",
                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")));

            IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                IF TaxDetail."Tax Jurisdiction Code" <> '' THEN
                    TaxJurisdiction.GET(TaxDetail."Tax Jurisdiction Code");
                IF "Gen. Posting Type" <> "Gen. Posting Type"::Settlement THEN BEGIN
                    VATEntry."Tax Group Used" := TaxDetail."Tax Group Code";
                    VATEntry."Tax Type" := TaxDetail."Tax Type";
                    VATEntry."Tax on Tax" := TaxDetail."Calculate Tax on Tax";
                END;
                VATEntry."Tax Jurisdiction Code" := TaxDetail."Tax Jurisdiction Code";
            END;

            IF AddCurrencyCode <> '' THEN
                IF AddCurrencyCode <> SrcCurrCode THEN BEGIN
                    SrcCurrGLEntryAmt := ExchangeAmtLCYToFCY2(GLEntryAmount);
                    SrcCurrGLEntryVATAmt := ExchangeAmtLCYToFCY2(GLEntryVATAmount);
                    SrcCurrGLEntryBaseAmt := ExchangeAmtLCYToFCY2(GLEntryBaseAmount);
                    SrcCurrVATDifference := ExchangeAmtLCYToFCY2(VATDifferenceLCY);
                END ELSE
                    SrcCurrVATDifference := "VAT Difference";

            UnrealizedVAT :=
              (((VATPostingSetup."Unrealized VAT Type" > 0) AND
                (VATPostingSetup."VAT Calculation Type" IN
                 [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                  VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT",
                  VATPostingSetup."VAT Calculation Type"::"Full VAT"])) OR
               ((TaxJurisdiction."Unrealized VAT Type" > 0) AND
                (VATPostingSetup."VAT Calculation Type" IN
                 [VATPostingSetup."VAT Calculation Type"::"Sales Tax"]))) AND
              (IsNotPayment("Document Type") OR ("Document Type" = "Document Type"::Bill));//enum to option
            IF GLSetup."Prepayment Unrealized VAT" AND NOT GLSetup."Unrealized VAT" AND
               (VATPostingSetup."Unrealized VAT Type" > 0)
            THEN
                UnrealizedVAT := Prepayment;

            // VAT for VAT entry
            IF "Gen. Posting Type".AsInteger() <> 0 THEN BEGIN
                CASE "VAT Posting" OF
                    "VAT Posting"::"Automatic VAT Entry":
                        BEGIN
                            VATAmount := GLEntryVATAmount;
                            VATBase := GLEntryBaseAmount;
                            SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                            SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                        END;
                    "VAT Posting"::"Manual VAT Entry":
                        BEGIN
                            IF "Gen. Posting Type" = "Gen. Posting Type"::Settlement THEN BEGIN
                                VATAmount := GLEntryAmount;
                                SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                                VATEntry.Closed := TRUE;
                            END ELSE BEGIN
                                VATAmount := GLEntryVATAmount;
                                SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                            END;
                            VATBase := GLEntryBaseAmount;
                            SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                        END;
                END;

                IF UnrealizedVAT THEN BEGIN
                    VATEntry.Amount := 0;
                    VATEntry.Base := 0;
                    VATEntry."Unrealized Amount" := VATAmount;
                    VATEntry."Unrealized Base" := VATBase;
                    VATEntry."Remaining Unrealized Amount" := VATEntry."Unrealized Amount";
                    VATEntry."Remaining Unrealized Base" := VATEntry."Unrealized Base";
                END ELSE BEGIN
                    VATEntry.Amount := VATAmount;
                    VATEntry.Base := VATBase;
                    VATEntry."Unrealized Amount" := 0;
                    VATEntry."Unrealized Base" := 0;
                    VATEntry."Remaining Unrealized Amount" := 0;
                    VATEntry."Remaining Unrealized Base" := 0;
                END;

                IF AddCurrencyCode = '' THEN BEGIN
                    VATEntry."Additional-Currency Base" := 0;
                    VATEntry."Additional-Currency Amount" := 0;
                    VATEntry."Add.-Currency Unrealized Amt." := 0;
                    VATEntry."Add.-Currency Unrealized Base" := 0;
                END ELSE
                    IF UnrealizedVAT THEN BEGIN
                        VATEntry."Additional-Currency Base" := 0;
                        VATEntry."Additional-Currency Amount" := 0;
                        VATEntry."Add.-Currency Unrealized Base" := SrcCurrVATBase;
                        VATEntry."Add.-Currency Unrealized Amt." := SrcCurrVATAmount;
                    END ELSE BEGIN
                        VATEntry."Additional-Currency Base" := SrcCurrVATBase;
                        VATEntry."Additional-Currency Amount" := SrcCurrVATAmount;
                        VATEntry."Add.-Currency Unrealized Base" := 0;
                        VATEntry."Add.-Currency Unrealized Amt." := 0;
                    END;
                VATEntry."Add.-Curr. Rem. Unreal. Amount" := VATEntry."Add.-Currency Unrealized Amt.";
                VATEntry."Add.-Curr. Rem. Unreal. Base" := VATEntry."Add.-Currency Unrealized Base";
                VATEntry."VAT Difference" := VATDifferenceLCY;
                VATEntry."Add.-Curr. VAT Difference" := SrcCurrVATDifference;
                IF "System-Created Entry" THEN
                    VATEntry."Base Before Pmt. Disc." := "VAT Base Before Pmt. Disc."
                ELSE
                    VATEntry."Base Before Pmt. Disc." := GLEntryAmount;

                VATEntry.UpdateRates(VATPostingSetup);
                OnBeforeInsertVATEntry(VATEntry, GenJnlLine);
                VATEntry.INSERT(TRUE);
                GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.", VATEntry."Entry No.");
                NextVATEntryNo := NextVATEntryNo + 1;
                OnAfterInsertVATEntry(GenJnlLine, VATEntry, TempGLEntryBuf."Entry No.", NextVATEntryNo);
            END;

            // VAT for G/L entry/entries
            IF (GLEntryVATAmount <> 0) OR
               ((SrcCurrGLEntryVATAmt <> 0) AND (SrcCurrCode = AddCurrencyCode))
            THEN
                CASE "Gen. Posting Type" OF
                    "Gen. Posting Type"::Purchase:
                        CASE VATPostingSetup."VAT Calculation Type" OF
                            VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                          VATPostingSetup."VAT Calculation Type"::"Full VAT":
                                CreateGLEntry(GenJnlLine, VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                                BEGIN
                                    CreateGLEntry(GenJnlLine, VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                                      GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                                    CreateGLEntry(GenJnlLine, VATPostingSetup.GetRevChargeAccount(UnrealizedVAT),
                                      -GLEntryVATAmount, -SrcCurrGLEntryVATAmt, TRUE);
                                END;
                            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                                IF "Use Tax" THEN BEGIN
                                    InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(UnrealizedVAT), '',
                                      GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                                    InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetRevChargeAccount(UnrealizedVAT), '',
                                      -GLEntryVATAmount, -SrcCurrGLEntryVATAmt, TRUE);
                                END ELSE
                                    InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(UnrealizedVAT), '',
                                      GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                        END;
                    "Gen. Posting Type"::Sale:
                        CASE VATPostingSetup."VAT Calculation Type" OF
                            VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                          VATPostingSetup."VAT Calculation Type"::"Full VAT":
                                CreateGLEntry(GenJnlLine, VATPostingSetup.GetSalesAccount(UnrealizedVAT),
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                                ;
                            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                                InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetSalesAccount(UnrealizedVAT), '',
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                        END;
                END;
        END;

        OnAfterInsertVAT(
          GenJnlLine, VATEntry, UnrealizedVAT, AddCurrencyCode, VATPostingSetup, GLEntryAmount, GLEntryVATAmount, GLEntryBaseAmount,
          SrcCurrCode, SrcCurrGLEntryAmt, SrcCurrGLEntryVATAmt, SrcCurrGLEntryBaseAmt, AddCurrGLEntryVATAmt,
          NextConnectionNo, NextVATEntryNo, NextTransactionNo, TempGLEntryBuf."Entry No.");
    END;

    LOCAL PROCEDURE SummarizeVAT(SummarizeGLEntries: Boolean; GLEntry: Record 17);
    VAR
        InsertedTempVAT: Boolean;
    BEGIN
        InsertedTempVAT := FALSE;
        IF SummarizeGLEntries THEN
            IF TempGLEntryVAT.FINDSET THEN
                REPEAT
                    IF (TempGLEntryVAT."G/L Account No." = GLEntry."G/L Account No.") AND
                       (TempGLEntryVAT."Bal. Account No." = GLEntry."Bal. Account No.")
                    THEN BEGIN
                        TempGLEntryVAT.Amount := TempGLEntryVAT.Amount + GLEntry.Amount;
                        TempGLEntryVAT."Additional-Currency Amount" :=
                          TempGLEntryVAT."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
                        TempGLEntryVAT.MODIFY;
                        InsertedTempVAT := TRUE;
                    END;
                UNTIL (TempGLEntryVAT.NEXT = 0) OR InsertedTempVAT;
        IF NOT InsertedTempVAT OR NOT SummarizeGLEntries THEN BEGIN
            TempGLEntryVAT := GLEntry;
            TempGLEntryVAT."Entry No." :=
              TempGLEntryVAT."Entry No." + InsertedTempGLEntryVAT;
            TempGLEntryVAT.INSERT;
            InsertedTempGLEntryVAT := InsertedTempGLEntryVAT + 1;
        END;
    END;

    LOCAL PROCEDURE InsertSummarizedVAT(GenJnlLine: Record 81);
    BEGIN
        IF TempGLEntryVAT.FINDSET THEN BEGIN
            REPEAT
                InsertGLEntry(GenJnlLine, TempGLEntryVAT, TRUE);
            UNTIL TempGLEntryVAT.NEXT = 0;
            TempGLEntryVAT.DELETEALL;
            InsertedTempGLEntryVAT := 0;
        END;
        NextConnectionNo := NextConnectionNo + 1;
    END;

    LOCAL PROCEDURE PostGLAcc(GenJnlLine: Record 81; Balancing: Boolean);
    VAR
        GLAcc: Record 15;
        GLEntry: Record 17;
        VATPostingSetup: Record 325;
        IsHandled: Boolean;
    BEGIN
        OnBeforePostGLAcc(GenJnlLine, GLEntry);

        WITH GenJnlLine DO BEGIN
            GLAcc.GET("Account No.");
            // G/L entry
            InitGLEntry(GenJnlLine, GLEntry,
              "Account No.", "Amount (LCY)",
              "Source Currency Amount", TRUE, "System-Created Entry");
            IF NOT "System-Created Entry" THEN
                IF "Posting Date" = NORMALDATE("Posting Date") THEN
                    GLAcc.TESTFIELD("Direct Posting", TRUE);
            IF GLAcc."Omit Default Descr. in Jnl." THEN
                IF DELCHR(Description, '=', ' ') = '' THEN
                    ERROR(
                      DescriptionMustNotBeBlankErr,
                      GLAcc.FIELDCAPTION("Omit Default Descr. in Jnl."),
                      GLAcc."No.",
                      FIELDCAPTION(Description));
            GLEntry."Gen. Posting Type" := "Gen. Posting Type";
            GLEntry."Bal. Account Type" := "Bal. Account Type";
            GLEntry."Bal. Account No." := "Bal. Account No.";
            GLEntry."No. Series" := "Posting No. Series";
            IF "Additional-Currency Posting" =
               "Additional-Currency Posting"::"Additional-Currency Amount Only"
            THEN BEGIN
                GLEntry."Additional-Currency Amount" := Amount;
                GLEntry.Amount := 0;
            END;
            // Store Entry No. to global variable for return:
            GLEntryNo := GLEntry."Entry No.";
            InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
            IsHandled := FALSE;
            OnPostGLAccOnBeforeInsertGLEntry(GenJnlLine, GLEntry, IsHandled);
            IF NOT IsHandled THEN
                InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            IF (NOT FunctionQB.AccessToQuobuilding) THEN //QB
                PostJob(GenJnlLine, GLEntry);
            PostVAT(GenJnlLine, GLEntry, VATPostingSetup);
            DeferralPosting("Deferral Code", "Source Code", "Account No.", GenJnlLine, Balancing);
            OnMoveGenJournalLine(GLEntry.RECORDID);
        END;

        OnAfterPostGLAcc(GenJnlLine, TempGLEntryBuf, NextEntryNo, NextTransactionNo, Balancing);
    END;

    LOCAL PROCEDURE PostCust(VAR GenJnlLine: Record 81; Balancing: Boolean);
    VAR
        LineFeeNoteOnReportHist: Record 1053;
        Cust: Record 18;
        CustPostingGr: Record 92;
        CustLedgEntry: Record 21;
        CVLedgEntryBuf: Record 382;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        DtldCustLedgEntry: Record 379;
        ReceivablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    BEGIN
        AppliesToDocType := 0;

        WITH GenJnlLine DO BEGIN
            DocAmountLCY := 0;
            DiscDocAmountLCY := 0;
            CollDocAmountLCY := 0;
            RejDocAmountLCY := 0;
            DiscRiskFactAmountLCY := 0;
            DiscUnriskFactAmountLCY := 0;
            CollFactAmountLCY := 0;
            TempRejCustLedgEntry.RESET;
            TempRejCustLedgEntry.DELETEALL;

            Cust.GET("Account No.");
            Cust.CheckBlockedCustOnJnls(Cust, "Document Type", TRUE);

            IF "Posting Group" = '' THEN BEGIN
                Cust.TESTFIELD("Customer Posting Group");
                "Posting Group" := Cust."Customer Posting Group";
            END;
            CustPostingGr.GET("Posting Group");
            IF "Document Type" = "Document Type"::Bill THEN
                ReceivablesAccount := CustPostingGr.GetBillsAccount(FALSE)
            ELSE
                ReceivablesAccount := CustPostingGr.GetReceivablesAccount;

            //JAV 13/01/22: - QB 1.10.09 Cambiar las cuentas para el confirming si es necesario
            QBTableSubscriber.T92_ChangeCustomerConfirmingAccount(GenJnlLine, ReceivablesAccount);
            //FIN QB 1.10.09

            DtldCustLedgEntry.LOCKTABLE;
            CustLedgEntry.LOCKTABLE;

            InitCustLedgEntry(GenJnlLine, CustLedgEntry);

            IF NOT Cust."Block Payment Tolerance" THEN
                CalcPmtTolerancePossible(
                  GenJnlLine, CustLedgEntry."Pmt. Discount Date", CustLedgEntry."Pmt. Disc. Tolerance Date",
                  CustLedgEntry."Max. Payment Tolerance");

            IF GLSetup."Payment Discount Type" =
               GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines"
            THEN
                CustLedgEntry."Pmt. Disc. Given (LCY)" := "Pmt. Discount Given/Rec. (LCY)"
            ELSE
                IF "Amount (LCY)" <> 0 THEN BEGIN
                    IF GLSetup."Pmt. Disc. Excl. VAT" THEN
                        CustLedgEntry."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
                    ELSE
                        CustLedgEntry."Original Pmt. Disc. Possible" := Amount;
                    CustLedgEntry."Original Pmt. Disc. Possible" :=
                      ROUND(
                        CustLedgEntry."Original Pmt. Disc. Possible" * "Payment Discount %" / 100, AmountRoundingPrecision);

                    CustLedgEntry."Remaining Pmt. Disc. Possible" := CustLedgEntry."Original Pmt. Disc. Possible";
                END;

            TempDtldCVLedgEntryBuf.DELETEALL;
            TempDtldCVLedgEntryBuf.INIT;
            TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
            TempDtldCVLedgEntryBuf."CV Ledger Entry No." := CustLedgEntry."Entry No.";
            CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
            TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
            CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
            CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;
            OnPostCustOnAfterCopyCVLedgEntryBuf(CVLedgEntryBuf, GenJnlLine);

            IF "Currency Code" <> '' THEN BEGIN
                TESTFIELD("Currency Factor");
                CVLedgEntryBuf."Original Currency Factor" := "Currency Factor"
            END ELSE
                CVLedgEntryBuf."Original Currency Factor" := 1;
            CVLedgEntryBuf."Adjusted Currency Factor" := CVLedgEntryBuf."Original Currency Factor";

            // Check the document no.
            IF "Recurring Method".AsInteger() = 0 THEN
                IF IsNotPayment("Document Type") THEN BEGIN //enum to option
                    GenJnlCheckLine.CheckSalesDocNoIsNotUsed("Document Type", "Document No.");
                    CheckSalesExtDocNo(GenJnlLine);
                END;
            OriginalEntryExist := IsOriginalEntryExist(GenJnlLine);

            // Post application
            ApplyCustLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Cust);

            IF ("Applies-to ID" = '') AND
               ("Applies-to Doc. Type" = "Applies-to Doc. Type"::" ")
            THEN
                "Applies-to Doc. Type" := Enum::"Gen. Journal Document Type".FromInteger(AppliesToDocType);

            IF NOT Prepayment THEN BEGIN
                IF "Document Type" = "Document Type"::Bill THEN BEGIN
                    DocPost.CreateReceivableDoc(GenJnlLine, CVLedgEntryBuf, BillFromJournal);
                    CustLedgEntry."Document Situation" := CustLedgEntry."Document Situation"::Cartera;
                    CustLedgEntry."Document Status" := CustLedgEntry."Document Status"::Open;
                END;
                SendDocToCartera(GenJnlLine, VendLedgEntry, CustLedgEntry, 0, CVLedgEntryBuf);
            END;

            // Post customer entry
            CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
            CustLedgEntry."Amount to Apply" := 0;
            CustLedgEntry."Applies-to Doc. No." := '';
            CustLedgEntry.INSERT(TRUE);

            // Post detailed customer entries
            DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, CustPostingGr, TRUE);

            // Post Reminder Terms - Note About Line Fee on Report
            LineFeeNoteOnReportHist.Save(CustLedgEntry);

            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);

            DeferralPosting("Deferral Code", "Source Code", ReceivablesAccount, GenJnlLine, Balancing);
            OnMoveGenJournalLine(CustLedgEntry.RECORDID);
        END;

        OnAfterPostCust(GenJnlLine, Balancing, TempGLEntryBuf, NextEntryNo, NextTransactionNo);
    END;

    LOCAL PROCEDURE PostVend(GenJnlLine: Record 81; Balancing: Boolean);
    VAR
        Vend: Record 23;
        VendPostingGr: Record 93;
        VendLedgEntry: Record 25;
        CVLedgEntryBuf: Record 382;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        DtldVendLedgEntry: Record 380;
        PayablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
        CheckExtDocNoHandled: Boolean;
    BEGIN
        AppliesToDocType := 0;

        WITH GenJnlLine DO BEGIN
            DocAmountLCY := 0;
            CollDocAmountLCY := 0;

            Vend.GET("Account No.");
            Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);

            IF "Posting Group" = '' THEN BEGIN
                Vend.TESTFIELD("Vendor Posting Group");
                "Posting Group" := Vend."Vendor Posting Group";
            END;
            VendPostingGr.GET("Posting Group");
            IF "Document Type" = "Document Type"::Bill THEN
                PayablesAccount := VendPostingGr.GetBillsAccount
            ELSE
                PayablesAccount := VendPostingGr.GetPayablesAccount;

            DtldVendLedgEntry.LOCKTABLE;
            VendLedgEntry.LOCKTABLE;

            InitVendLedgEntry(GenJnlLine, VendLedgEntry);

            IF NOT Vend."Block Payment Tolerance" THEN
                CalcPmtTolerancePossible(
                  GenJnlLine, VendLedgEntry."Pmt. Discount Date", VendLedgEntry."Pmt. Disc. Tolerance Date",
                  VendLedgEntry."Max. Payment Tolerance");

            IF GLSetup."Payment Discount Type" =
               GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines"
            THEN
                VendLedgEntry."Pmt. Disc. Rcd.(LCY)" := "Pmt. Discount Given/Rec. (LCY)"
            ELSE
                IF "Amount (LCY)" <> 0 THEN BEGIN
                    IF GLSetup."Pmt. Disc. Excl. VAT" THEN
                        VendLedgEntry."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
                    ELSE
                        VendLedgEntry."Original Pmt. Disc. Possible" := Amount;

                    VendLedgEntry."Original Pmt. Disc. Possible" :=
                      ROUND(
                        VendLedgEntry."Original Pmt. Disc. Possible" * "Payment Discount %" / 100, AmountRoundingPrecision);
                    VendLedgEntry."Remaining Pmt. Disc. Possible" := VendLedgEntry."Original Pmt. Disc. Possible";
                END;

            TempDtldCVLedgEntryBuf.DELETEALL;
            TempDtldCVLedgEntryBuf.INIT;
            TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
            TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";
            CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
            TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
            CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
            CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;
            OnPostVendOnAfterCopyCVLedgEntryBuf(CVLedgEntryBuf, GenJnlLine);

            IF "Currency Code" <> '' THEN BEGIN
                TESTFIELD("Currency Factor");
                CVLedgEntryBuf."Adjusted Currency Factor" := "Currency Factor"
            END ELSE
                CVLedgEntryBuf."Adjusted Currency Factor" := 1;
            CVLedgEntryBuf."Original Currency Factor" := CVLedgEntryBuf."Adjusted Currency Factor";

            // Check the document no.
            IF "Recurring Method".AsInteger() = 0 THEN
                IF IsNotPayment("Document Type") THEN BEGIN //enum to option
                    GenJnlCheckLine.CheckPurchDocNoIsNotUsed("Document Type", "Document No.");
                    OnBeforeCheckPurchExtDocNo(GenJnlLine, VendLedgEntry, CVLedgEntryBuf, CheckExtDocNoHandled);
                    IF NOT CheckExtDocNoHandled THEN
                        CheckPurchExtDocNo(GenJnlLine);
                END;

            OriginalEntryExist := IsOriginalEntryExist(GenJnlLine);
            // Post application
            ApplyVendLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Vend);

            IF ("Applies-to ID" = '') AND
               ("Applies-to Doc. Type" = "Applies-to Doc. Type"::" ")
            THEN
                "Applies-to Doc. Type" := Enum::"Gen. Journal Document Type".FromInteger(AppliesToDocType);

            IF NOT Prepayment THEN BEGIN
                IF "Document Type" = "Document Type"::Bill THEN BEGIN
                    DocPost.CreatePayableDoc(GenJnlLine, CVLedgEntryBuf, BillFromJournal);
                    VendLedgEntry."Document Situation" := VendLedgEntry."Document Situation"::Cartera;
                    VendLedgEntry."Document Status" := VendLedgEntry."Document Status"::Open;
                END;
                SendDocToCartera(GenJnlLine, VendLedgEntry, CustLedgEntry, 1, CVLedgEntryBuf);
            END;

            // Post vendor entry
            VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
            VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Applies-to Doc. No." := '';

            //QB ++  JAV 25/05/22: - QB 1.10.44 Se elimina la llamada a InheritFieldVendor, se usa en su lugar el evento OnAfterInitVendLedgEntry
            //QBCodeunitPublisher.InheritFieldVendor(GenJnlLine,VendLedgEntry);
            //QB --

            VendLedgEntry.INSERT(TRUE);

            // Post detailed vendor entries
            DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, VendPostingGr, TRUE);

            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
            DeferralPosting("Deferral Code", "Source Code", PayablesAccount, GenJnlLine, Balancing);
            OnMoveGenJournalLine(VendLedgEntry.RECORDID);
        END;

        OnAfterPostVend(GenJnlLine, Balancing, TempGLEntryBuf, NextEntryNo, NextTransactionNo);
    END;

    LOCAL PROCEDURE PostEmployee(GenJnlLine: Record 81);
    VAR
        Employee: Record 5200;
        EmployeePostingGr: Record 5221;
        EmployeeLedgerEntry: Record 5222;
        CVLedgEntryBuf: Record 382;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        DtldEmplLedgEntry: Record 5223;
        DtldLedgEntryInserted: Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            Employee.GET("Account No.");
            Employee.CheckBlockedEmployeeOnJnls(TRUE);

            IF "Posting Group" = '' THEN BEGIN
                Employee.TESTFIELD("Employee Posting Group");
                "Posting Group" := Employee."Employee Posting Group";
            END;
            EmployeePostingGr.GET("Posting Group");

            DtldEmplLedgEntry.LOCKTABLE;
            EmployeeLedgerEntry.LOCKTABLE;

            InitEmployeeLedgerEntry(GenJnlLine, EmployeeLedgerEntry);

            TempDtldCVLedgEntryBuf.DELETEALL;
            TempDtldCVLedgEntryBuf.INIT;
            TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
            TempDtldCVLedgEntryBuf."CV Ledger Entry No." := EmployeeLedgerEntry."Entry No.";
            CVLedgEntryBuf.CopyFromEmplLedgEntry(EmployeeLedgerEntry);
            TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
            CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
            CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

            // Post application
            ApplyEmplLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Employee);

            // Post vendor entry
            EmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
            EmployeeLedgerEntry."Amount to Apply" := 0;
            EmployeeLedgerEntry."Applies-to Doc. No." := '';
            EmployeeLedgerEntry.INSERT(TRUE);

            // Post detailed employee entries
            DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, EmployeePostingGr, TRUE);

            // Posting GL Entry
            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);

            OnMoveGenJournalLine(EmployeeLedgerEntry.RECORDID);
        END;
    END;

    LOCAL PROCEDURE PostBankAcc(GenJnlLine: Record 81; Balancing: Boolean);
    VAR
        BankAcc: Record 270;
        BankAccLedgEntry: Record 271;
        CheckLedgEntry: Record 272;
        CheckLedgEntry2: Record 272;
        BankAccPostingGr: Record 277;
    BEGIN
        WITH GenJnlLine DO BEGIN
            BankAcc.GET("Account No.");
            BankAcc.TESTFIELD(Blocked, FALSE);
            IF "Currency Code" = '' THEN
                BankAcc.TESTFIELD("Currency Code", '')
            ELSE
                IF BankAcc."Currency Code" <> '' THEN
                    TESTFIELD("Currency Code", BankAcc."Currency Code");

            BankAcc.TESTFIELD("Bank Acc. Posting Group");
            BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");

            BankAccLedgEntry.LOCKTABLE;

            OnPostBankAccOnBeforeInitBankAccLedgEntry(GenJnlLine, CurrencyFactor, NextEntryNo, NextTransactionNo);

            InitBankAccLedgEntry(GenJnlLine, BankAccLedgEntry);

            BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
            BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
            IF BankAcc."Currency Code" <> '' THEN
                BankAccLedgEntry.Amount := Amount
            ELSE
                BankAccLedgEntry.Amount := "Amount (LCY)";
            BankAccLedgEntry."Amount (LCY)" := "Amount (LCY)";
            BankAccLedgEntry.Open := Amount <> 0;
            BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
            BankAccLedgEntry.Positive := Amount > 0;
            BankAccLedgEntry.UpdateDebitCredit(Correction);
            OnPostBankAccOnBeforeBankAccLedgEntryInsert(BankAccLedgEntry, GenJnlLine, BankAcc);
            BankAccLedgEntry.INSERT(TRUE);
            OnPostBankAccOnAfterBankAccLedgEntryInsert(BankAccLedgEntry, GenJnlLine, BankAcc);

            IF ((Amount <= 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") AND "Check Printed") OR
               ((Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Manual Check"))
            THEN BEGIN
                IF BankAcc."Currency Code" <> "Currency Code" THEN
                    ERROR(BankPaymentTypeMustNotBeFilledErr);
                CASE "Bank Payment Type" OF
                    "Bank Payment Type"::"Computer Check":
                        BEGIN
                            TESTFIELD("Check Printed", TRUE);
                            CheckLedgEntry.LOCKTABLE;
                            CheckLedgEntry.RESET;
                            CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                            CheckLedgEntry.SETRANGE("Bank Account No.", "Account No.");
                            CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                            CheckLedgEntry.SETRANGE("Check No.", "Document No.");
                            IF CheckLedgEntry.FINDSET THEN
                                REPEAT
                                    CheckLedgEntry2 := CheckLedgEntry;
                                    CheckLedgEntry2."Entry Status" := CheckLedgEntry2."Entry Status"::Posted;
                                    CheckLedgEntry2."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                                    CheckLedgEntry2.MODIFY;
                                UNTIL CheckLedgEntry.NEXT = 0;
                        END;
                    "Bank Payment Type"::"Manual Check":
                        BEGIN
                            IF "Document No." = '' THEN
                                ERROR(DocNoMustBeEnteredErr, "Bank Payment Type");
                            CheckLedgEntry.RESET;
                            IF NextCheckEntryNo = 0 THEN BEGIN
                                CheckLedgEntry.LOCKTABLE;
                                IF CheckLedgEntry.FINDLAST THEN
                                    NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
                                ELSE
                                    NextCheckEntryNo := 1;
                            END;

                            CheckLedgEntry.SETRANGE("Bank Account No.", "Account No.");
                            CheckLedgEntry.SETFILTER(
                              "Entry Status", '%1|%2|%3',
                              CheckLedgEntry."Entry Status"::Printed,
                              CheckLedgEntry."Entry Status"::Posted,
                              CheckLedgEntry."Entry Status"::"Financially Voided");
                            CheckLedgEntry.SETRANGE("Check No.", "Document No.");
                            IF NOT CheckLedgEntry.ISEMPTY THEN
                                ERROR(CheckAlreadyExistsErr, "Document No.");

                            InitCheckLedgEntry(BankAccLedgEntry, CheckLedgEntry);
                            CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Manual Check";
                            IF BankAcc."Currency Code" <> '' THEN
                                CheckLedgEntry.Amount := -Amount
                            ELSE
                                CheckLedgEntry.Amount := -"Amount (LCY)";
                            OnPostBankAccOnBeforeCheckLedgEntryInsert(CheckLedgEntry, BankAccLedgEntry, GenJnlLine, BankAcc);
                            CheckLedgEntry.INSERT(TRUE);
                            OnPostBankAccOnAfterCheckLedgEntryInsert(CheckLedgEntry, BankAccLedgEntry, GenJnlLine, BankAcc);
                            NextCheckEntryNo := NextCheckEntryNo + 1;
                        END;
                END;
            END;

            BankAccPostingGr.TESTFIELD("G/L Account No.");
            CreateGLEntryBalAcc(
              GenJnlLine, BankAccPostingGr."G/L Account No.", "Amount (LCY)", "Source Currency Amount",
              "Bal. Account Type", "Bal. Account No.");//enum to option
            DeferralPosting("Deferral Code", "Source Code", BankAccPostingGr."G/L Account No.", GenJnlLine, Balancing);
            OnMoveGenJournalLine(BankAccLedgEntry.RECORDID);
        END;
    END;

    LOCAL PROCEDURE PostFixedAsset(GenJnlLine: Record 81);
    VAR
        GLEntry: Record 17;
        GLEntry2: Record 17;
        TempFAGLPostBuf: Record 5637 TEMPORARY;
        FAGLPostBuf: Record 5637;
        VATPostingSetup: Record 325;
        FAJnlPostLine: Codeunit 5632;
        FAAutomaticEntry: Codeunit 5607;
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20];
        Correction2: Boolean;
        NetDisposalNo: Integer;
        DimensionSetID: Integer;
        VATEntryGLEntryNo: Integer;
        IsHandled: Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            InitGLEntry(GenJnlLine, GLEntry, '', "Amount (LCY)", "Source Currency Amount", TRUE, "System-Created Entry");
            GLEntry."Gen. Posting Type" := "Gen. Posting Type";
            GLEntry."Bal. Account Type" := "Bal. Account Type";
            GLEntry."Bal. Account No." := "Bal. Account No.";
            InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
            GLEntry2 := GLEntry;
            FAJnlPostLine.GenJnlPostLine(
              GenJnlLine, GLEntry2.Amount, GLEntry2."VAT Amount", NextTransactionNo, NextEntryNo, GLReg."No.");
            ShortcutDim1Code := "Shortcut Dimension 1 Code";
            ShortcutDim2Code := "Shortcut Dimension 2 Code";
            DimensionSetID := "Dimension Set ID";
            Correction2 := Correction;
        END;
        WITH TempFAGLPostBuf DO
            IF FAJnlPostLine.FindFirstGLAcc(TempFAGLPostBuf) THEN
                REPEAT
                    GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                    GenJnlLine.Correction := Correction;
                    QBCodeunitPublisher.CreateActiveDimGenJnlPostLine(GenJnlLine, TempFAGLPostBuf);
                    FADimAlreadyChecked := "FA Posting Group" <> '';
                    CheckDimValueForDisposal(GenJnlLine, "Account No.");
                    IF "Original General Journal Line" THEN
                        InitGLEntry(GenJnlLine, GLEntry, "Account No.", Amount, GLEntry2."Additional-Currency Amount", TRUE, TRUE)
                    ELSE BEGIN
                        CheckNonAddCurrCodeOccurred('');
                        InitGLEntry(GenJnlLine, GLEntry, "Account No.", Amount, 0, FALSE, TRUE);
                    END;
                    FADimAlreadyChecked := FALSE;
                    GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
                    GLEntry."VAT Amount" := GLEntry2."VAT Amount";
                    GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
                    GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
                    GLEntry."FA Entry Type" := "FA Entry Type";
                    GLEntry."FA Entry No." := "FA Entry No.";
                    IF "Net Disposal" THEN
                        NetDisposalNo := NetDisposalNo + 1
                    ELSE
                        NetDisposalNo := 0;
                    IF "Automatic Entry" AND NOT "Net Disposal" THEN
                        FAAutomaticEntry.AdjustGLEntry(GLEntry);
                    IF NetDisposalNo > 1 THEN
                        GLEntry."VAT Amount" := 0;
                    IF "FA Posting Group" <> '' THEN BEGIN
                        FAGLPostBuf := TempFAGLPostBuf;
                        FAGLPostBuf."Entry No." := NextEntryNo;
                        FAGLPostBuf.INSERT;
                    END;
                    IsHandled := FALSE;
                    OnPostFixedAssetOnBeforeInsertGLEntry(GenJnlLine, GLEntry, IsHandled, TempFAGLPostBuf);
                    IF NOT IsHandled THEN
                        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
                    IF (VATEntryGLEntryNo = 0) AND (GLEntry."Gen. Posting Type" <> GLEntry."Gen. Posting Type"::" ") THEN
                        VATEntryGLEntryNo := GLEntry."Entry No.";
                UNTIL FAJnlPostLine.GetNextGLAcc(TempFAGLPostBuf) = 0;
        GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
        GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
        GenJnlLine."Dimension Set ID" := DimensionSetID;
        GenJnlLine.Correction := Correction2;
        GLEntry := GLEntry2;
        IF VATEntryGLEntryNo = 0 THEN
            VATEntryGLEntryNo := GLEntry."Entry No.";
        TempGLEntryBuf."Entry No." := VATEntryGLEntryNo; // Used later in InsertVAT(): GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.")
        PostVAT(GenJnlLine, GLEntry, VATPostingSetup);

        FAJnlPostLine.UpdateRegNo(GLReg."No.");
        GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);
    END;

    LOCAL PROCEDURE PostICPartner(GenJnlLine: Record 81);
    VAR
        ICPartner: Record 413;
        AccountNo: Code[20];
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF "Account No." <> ICPartner.Code THEN
                ICPartner.GET("Account No.");
            IF ("Document Type" = "Document Type"::"Credit Memo") XOR (Amount > 0) THEN BEGIN
                ICPartner.TESTFIELD("Receivables Account");
                AccountNo := ICPartner."Receivables Account";
            END ELSE BEGIN
                ICPartner.TESTFIELD("Payables Account");
                AccountNo := ICPartner."Payables Account";
            END;

            CreateGLEntryBalAcc(
              GenJnlLine, AccountNo, "Amount (LCY)", "Source Currency Amount",
              "Bal. Account Type", "Bal. Account No.");//enum to option
        END;
    END;

    LOCAL PROCEDURE PostJob(GenJnlLine: Record 81; GLEntry: Record 17);
    VAR
        JobPostLine: Codeunit 1001;
    BEGIN
        IF JobLine THEN BEGIN
            JobLine := FALSE;
            JobPostLine.PostGenJnlLine(GenJnlLine, GLEntry);
        END;
    END;

    //[External]
    PROCEDURE StartPosting(GenJnlLine: Record 81);
    VAR
        GenJnlTemplate: Record 80;
        AccountingPeriodMgt: Codeunit 360;
    BEGIN
        OnBeforeStartPosting(GenJnlLine);

        WITH GenJnlLine DO BEGIN
            InitNextEntryNo;
            FirstTransactionNo := NextTransactionNo;

            InitLastDocDate(GenJnlLine);
            CurrentBalance := 0;
            LastTempTransNo := "Transaction No.";

            FiscalYearStartDate := AccountingPeriodMgt.GetPeriodStartingDate;

            GetGLSetup;

            IF NOT GenJnlTemplate.GET("Journal Template Name") THEN
                GenJnlTemplate.INIT;

            ForceDocBalance := GenJnlTemplate."Force Doc. Balance";

            VATEntry.LOCKTABLE;
            IF VATEntry.FINDLAST THEN
                NextVATEntryNo := VATEntry."Entry No." + 1
            ELSE
                NextVATEntryNo := 1;
            NextConnectionNo := 1;
            FirstNewVATEntryNo := NextVATEntryNo;

            GLReg.LOCKTABLE;
            IF GLReg.FINDLAST THEN
                GLReg."No." := GLReg."No." + 1
            ELSE
                GLReg."No." := 1;
            GLReg.INIT;
            GLReg."From Entry No." := NextEntryNo;
            GLReg."From VAT Entry No." := NextVATEntryNo;
            GLReg."Creation Date" := TODAY;
            GLReg."Creation Time" := TIME;
            GLReg."Source Code" := "Source Code";
            GLReg."Journal Batch Name" := "Journal Batch Name";
            GLReg."User ID" := USERID;
            GLReg."Posting Date" := "Posting Date";
            IsGLRegInserted := FALSE;

            OnAfterInitGLRegister(GLReg, GenJnlLine);

            GetCurrencyExchRate(GenJnlLine);
            TempGLEntryBuf.DELETEALL;
            CalculateCurrentBalance(
              "Account No.", "Bal. Account No.", IncludeVATAmount, "Amount (LCY)", "VAT Amount");
        END;
    END;

    //[External]
    PROCEDURE ContinuePosting(GenJnlLine: Record 81);
    BEGIN
        OnBeforeContinuePosting(GenJnlLine, GLReg, NextEntryNo, NextTransactionNo);

        IF NextTransactionNoNeeded(GenJnlLine) THEN BEGIN
            CheckPostUnrealizedVAT(GenJnlLine, FALSE);
            NextTransactionNo := NextTransactionNo + 1;
            InitLastDocDate(GenJnlLine);
            FirstNewVATEntryNo := NextVATEntryNo;

            LastTempTransNo := GenJnlLine."Transaction No.";
            IF IsGLRegInserted THEN
                GLReg.MODIFY
            ELSE
                GLReg.INSERT;

            GLReg.INIT;
            GLReg."No." += 1;
            GLReg."From Entry No." := NextEntryNo;
            GLReg."From VAT Entry No." := NextVATEntryNo;
            GLReg."Creation Date" := TODAY;
            GLReg."Source Code" := GenJnlLine."Source Code";
            GLReg."Journal Batch Name" := GenJnlLine."Journal Batch Name";
            GLReg."User ID" := USERID;
            GLReg."Posting Date" := GenJnlLine."Posting Date";
            IsGLRegInserted := FALSE;
        END;

        OnContinuePostingOnBeforeCalculateCurrentBalance(GenJnlLine, NextTransactionNo);

        GetCurrencyExchRate(GenJnlLine);
        TempGLEntryBuf.DELETEALL;
        CalculateCurrentBalance(
          GenJnlLine."Account No.", GenJnlLine."Bal. Account No.", GenJnlLine.IncludeVATAmount,
          GenJnlLine."Amount (LCY)", GenJnlLine."VAT Amount");
    END;

    LOCAL PROCEDURE NextTransactionNoNeeded(GenJnlLine: Record 81): Boolean;
    VAR
        NewTransaction: Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            NewTransaction :=
              (LastDate <> "Posting Date") OR ForceDocBalance AND (LastDocNo <> "Document No.") OR
              (LastTempTransNo <> "Transaction No.") AND (NOT ForceDocBalance);
            IF NOT NewTransaction THEN
                OnNextTransactionNoNeeded(GenJnlLine, LastDocType, LastDocNo, LastDate, CurrentBalance, TotalAddCurrAmount, NewTransaction);
            EXIT(NewTransaction);
        END;
    END;

    //[External]
    PROCEDURE FinishPosting(GenJnlLine: Record 81) IsTransactionConsistent: Boolean;
    VAR
        CostAccSetup: Record 1108;
        TransferGlEntriesToCA: Codeunit 1105;
    BEGIN
        IsTransactionConsistent :=
          (BalanceCheckAmount = 0) AND (BalanceCheckAmount2 = 0) AND
          (BalanceCheckAddCurrAmount = 0) AND (BalanceCheckAddCurrAmount2 = 0);

        OnAfterSettingIsTransactionConsistent(GenJnlLine, IsTransactionConsistent);

        IF TempGLEntryBuf.FINDSET THEN BEGIN
            REPEAT
                GlobalGLEntry := TempGLEntryBuf;
                IF AddCurrencyCode = '' THEN BEGIN
                    GlobalGLEntry."Additional-Currency Amount" := 0;
                    GlobalGLEntry."Add.-Currency Debit Amount" := 0;
                    GlobalGLEntry."Add.-Currency Credit Amount" := 0;
                END;
                GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
                OnBeforeInsertGlobalGLEntry(GlobalGLEntry, GenJnlLine);
                GlobalGLEntry.INSERT(TRUE);

                QBCodeunitPublisher.ReturnDimensionesFinishPostingGenJnlPostLine(GenJnlLineQB, boolReturnDim, GlobalGLEntry, DimensionSetID);

                OnAfterInsertGlobalGLEntry(GlobalGLEntry);
            UNTIL TempGLEntryBuf.NEXT = 0;

            GLReg."To VAT Entry No." := NextVATEntryNo - 1;
            GLReg."To Entry No." := GlobalGLEntry."Entry No.";
            IF IsTransactionConsistent THEN
                IF IsGLRegInserted THEN
                    GLReg.MODIFY
                ELSE BEGIN
                    GLReg.INSERT;
                    IsGLRegInserted := TRUE;
                END;
        END;
        GlobalGLEntry.CONSISTENT(IsTransactionConsistent);

        IF CostAccSetup.GET THEN
            IF CostAccSetup."Auto Transfer from G/L" THEN
                TransferGlEntriesToCA.GetGLEntries;

        FirstEntryNo := 0;

        OnAfterFinishPosting(GlobalGLEntry, GLReg, IsTransactionConsistent);
    END;

    LOCAL PROCEDURE PostUnrealizedVAT(GenJnlLine: Record 81);
    BEGIN
        IF CheckUnrealizedCust THEN BEGIN
            CustUnrealizedVAT(GenJnlLine, UnrealizedCustLedgEntry, UnrealizedRemainingAmountCust);
            CheckUnrealizedCust := FALSE;
        END;
        IF CheckUnrealizedVend THEN BEGIN
            VendUnrealizedVAT(GenJnlLine, UnrealizedVendLedgEntry, UnrealizedRemainingAmountVend);
            CheckUnrealizedVend := FALSE;
        END;
    END;

    LOCAL PROCEDURE CheckPostUnrealizedVAT(GenJnlLine: Record 81; CheckCurrentBalance: Boolean);
    BEGIN
        IF CheckCurrentBalance AND (CurrentBalance = 0) OR NOT CheckCurrentBalance THEN
            PostUnrealizedVAT(GenJnlLine)
    END;

    LOCAL PROCEDURE InitGLEntry(GenJnlLine: Record 81; VAR GLEntry: Record 17; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean);
    VAR
        GLAcc: Record 15;
    BEGIN
        OnBeforeInitGLEntry(GenJnlLine);

        IF GLAccNo <> '' THEN BEGIN
            GLAcc.GET(GLAccNo);
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);

            // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
            IF (NOT
                ((GLAccNo = GenJnlLine."Account No.") AND
                 (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account")) OR
                ((GLAccNo = GenJnlLine."Bal. Account No.") AND
                 (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"G/L Account"))) AND
               NOT FADimAlreadyChecked
            THEN
                CheckGLAccDimError(GenJnlLine, GLAccNo);
        END;

        GLEntry.INIT;
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(Amount, AmountAddCurr, GLEntry."Additional-Currency Amount", UseAmountAddCurr, GenJnlLine);
        QBCodeunitPublisher.InheritFieldsGLEntryGenJnlPostLine(GLEntry, GenJnlLine, GLAccNo);

        OnAfterInitGLEntry(GLEntry, GenJnlLine);
    END;

    LOCAL PROCEDURE InitGLEntryVAT(GenJnlLine: Record 81; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmtAddCurr: Boolean);
    VAR
        GLEntry: Record 17;
    BEGIN
        OnBeforeInitGLEntryVAT(GenJnlLine, GLEntry);
        IF UseAmtAddCurr THEN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE)
        ELSE BEGIN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
            GLEntry."Bal. Account No." := BalAccNo;
        END;
        SummarizeVAT(GLSetup."Summarize G/L Entries", GLEntry);
        OnAfterInitGLEntryVAT(GenJnlLine, GLEntry);
    END;

    LOCAL PROCEDURE InitGLEntryVATCopy(GenJnlLine: Record 81; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATEntry: Record 254): Integer;
    VAR
        GLEntry: Record 17;
    BEGIN
        OnBeforeInitGLEntryVATCopy(GenJnlLine, GLEntry);
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."Bal. Account No." := BalAccNo;
        GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
        SummarizeVAT(GLSetup."Summarize G/L Entries", GLEntry);
        OnAfterInitGLEntryVATCopy(GenJnlLine, GLEntry);

        EXIT(GLEntry."Entry No.");
    END;

    //[External]
    PROCEDURE InsertGLEntry(GenJnlLine: Record 81; GLEntry: Record 17; CalcAddCurrResiduals: Boolean);
    BEGIN
        WITH GLEntry DO BEGIN
            TESTFIELD("G/L Account No.");

            IF Amount <> ROUND(Amount) THEN
                FIELDERROR(
                  Amount,
                  STRSUBSTNO(NeedsRoundingErr, Amount));

            UpdateCheckAmounts(
              "Posting Date", Amount, "Additional-Currency Amount",
              BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2);

            UpdateDebitCredit(GenJnlLine.Correction);
        END;

        TempGLEntryBuf := GLEntry;

        OnBeforeInsertGLEntryBuffer(TempGLEntryBuf, GenJnlLine,
          BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2, NextEntryNo);

        TempGLEntryBuf.INSERT;

        IF FirstEntryNo = 0 THEN
            FirstEntryNo := TempGLEntryBuf."Entry No.";
        NextEntryNo := NextEntryNo + 1;

        IF CalcAddCurrResiduals THEN
            HandleAddCurrResidualGLEntry(GenJnlLine, GLEntry);
    END;

    //[External]
    PROCEDURE CreateGLEntry(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean);
    VAR
        GLEntry: Record 17;
    BEGIN
        IF UseAmountAddCurr THEN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE)
        ELSE BEGIN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
        END;
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    END;

    LOCAL PROCEDURE CreateGLEntryBalAcc(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]);
    VAR
        GLEntry: Record 17;
    BEGIN
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE);
        GLEntry."Bal. Account Type" := BalAccType;
        GLEntry."Bal. Account No." := BalAccNo;
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);
    END;

    LOCAL PROCEDURE CreateGLEntryGainLoss(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; UseAmountAddCurr: Boolean);
    VAR
        GLEntry: Record 17;
    BEGIN
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, UseAmountAddCurr, TRUE);
        OnBeforeCreateGLEntryGainLossInsertGLEntry(GenJnlLine, GLEntry);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    END;

    LOCAL PROCEDURE CreateGLEntryVAT(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATAmount: Decimal; DtldCVLedgEntryBuf: Record 383);
    VAR
        GLEntry: Record 17;
    BEGIN
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf, DtldCVLedgEntryBuf."Gen. Posting Type".AsInteger());//enum to option
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        InsertVATEntriesFromTemp(DtldCVLedgEntryBuf, GLEntry);
    END;

    LOCAL PROCEDURE CreateGLEntryVATCollectAdj(GenJnlLine: Record 81; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATAmount: Decimal; DtldCVLedgEntryBuf: Record 383; VAR AdjAmount: ARRAY[4] OF Decimal);
    VAR
        GLEntry: Record 17;
    BEGIN
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf, DtldCVLedgEntryBuf."Gen. Posting Type".AsInteger());//enum to option
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        CollectAdjustment(AdjAmount, GLEntry.Amount, GLEntry."Additional-Currency Amount");
        InsertVATEntriesFromTemp(DtldCVLedgEntryBuf, GLEntry);
    END;

    LOCAL PROCEDURE CreateGLEntryFromVATEntry(GenJnlLine: Record 81; VATAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATEntry: Record 254): Integer;
    VAR
        GLEntry: Record 17;
    BEGIN
        InitGLEntry(GenJnlLine, GLEntry, VATAccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        EXIT(GLEntry."Entry No.");
    END;

    LOCAL PROCEDURE CreateDeferralScheduleFromGL(VAR GenJournalLine: Record 81; IsBalancing: Boolean);
    BEGIN
        WITH GenJournalLine DO
            IF ("Account No." <> '') AND ("Deferral Code" <> '') THEN
                IF (("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]) AND ("Source Code" = GLSourceCode)) OR
                   ("Account Type" IN ["Account Type"::"G/L Account", "Account Type"::"Bank Account"])
                THEN BEGIN
                    IF NOT IsBalancing THEN
                        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJournalLine);
                    DeferralUtilities.CreateScheduleFromGL(GenJournalLine, FirstEntryNo);
                END;
    END;

    LOCAL PROCEDURE UpdateCheckAmounts(PostingDate: Date; Amount: Decimal; AddCurrAmount: Decimal; VAR BalanceCheckAmount: Decimal; VAR BalanceCheckAmount2: Decimal; VAR BalanceCheckAddCurrAmount: Decimal; VAR BalanceCheckAddCurrAmount2: Decimal);
    BEGIN
        IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
            BalanceCheckAmount :=
              BalanceCheckAmount + Amount * ((PostingDate - 20000101D) MOD 99 + 1);
            BalanceCheckAmount2 :=
              BalanceCheckAmount2 + Amount * ((PostingDate - 20000101D) MOD 98 + 1);
        END ELSE BEGIN
            BalanceCheckAmount :=
              BalanceCheckAmount + Amount * ((NORMALDATE(PostingDate) - 20000101D + 50) MOD 99 + 1);
            BalanceCheckAmount2 :=
              BalanceCheckAmount2 + Amount * ((NORMALDATE(PostingDate) - 20000101D + 50) MOD 98 + 1);
        END;

        IF AddCurrencyCode <> '' THEN
            IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
                BalanceCheckAddCurrAmount :=
                  BalanceCheckAddCurrAmount + AddCurrAmount * ((PostingDate - 20000101D) MOD 99 + 1);
                BalanceCheckAddCurrAmount2 :=
                  BalanceCheckAddCurrAmount2 + AddCurrAmount * ((PostingDate - 20000101D) MOD 98 + 1);
            END ELSE BEGIN
                BalanceCheckAddCurrAmount :=
                  BalanceCheckAddCurrAmount +
                  AddCurrAmount * ((NORMALDATE(PostingDate) - 20000101D + 50) MOD 99 + 1);
                BalanceCheckAddCurrAmount2 :=
                  BalanceCheckAddCurrAmount2 +
                  AddCurrAmount * ((NORMALDATE(PostingDate) - 20000101D + 50) MOD 98 + 1);
            END
        ELSE BEGIN
            BalanceCheckAddCurrAmount := 0;
            BalanceCheckAddCurrAmount2 := 0;
        END;
    END;

    LOCAL PROCEDURE CalcPmtTolerancePossible(GenJnlLine: Record 81; PmtDiscountDate: Date; VAR PmtDiscToleranceDate: Date; VAR MaxPaymentTolerance: Decimal);
    BEGIN
        WITH GenJnlLine DO
            IF "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] THEN BEGIN
                IF PmtDiscountDate <> 0D THEN
                    PmtDiscToleranceDate :=
                      CALCDATE(GLSetup."Payment Discount Grace Period", PmtDiscountDate)
                ELSE
                    PmtDiscToleranceDate := PmtDiscountDate;

                CASE "Account Type" OF
                    "Account Type"::Customer:
                        PaymentToleranceMgt.CalcMaxPmtTolerance(
                          "Document Type", "Currency Code", Amount, "Amount (LCY)", 1, MaxPaymentTolerance);
                    "Account Type"::Vendor:
                        PaymentToleranceMgt.CalcMaxPmtTolerance(
                          "Document Type", "Currency Code", Amount, "Amount (LCY)", -1, MaxPaymentTolerance);
                END;
            END;
    END;

    LOCAL PROCEDURE CalcPmtTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; VAR PmtTolAmtToBeApplied: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer);
    VAR
        PmtTol: Decimal;
        PmtTolLCY: Decimal;
        PmtTolAddCurr: Decimal;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcPmtTolerance(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtTolAmtToBeApplied, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF OldCVLedgEntryBuf2."Accepted Payment Tolerance" = 0 THEN
            EXIT;

        PmtTol := -OldCVLedgEntryBuf2."Accepted Payment Tolerance";
        PmtTolAmtToBeApplied := PmtTolAmtToBeApplied + PmtTol;
        PmtTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OnCalcPmtToleranceOnAfterAssignPmtDisc(
          PmtTol, PmtTolLCY, PmtTolAmtToBeApplied, OldCVLedgEntryBuf, OldCVLedgEntryBuf2,
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, NextTransactionNo, FirstNewVATEntryNo);

        OldCVLedgEntryBuf."Accepted Payment Tolerance" := 0;
        OldCVLedgEntryBuf."Pmt. Tolerance (LCY)" := -PmtTolLCY;

        IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
            PmtTolAddCurr := PmtTol
        ELSE
            PmtTolAddCurr := CalcLCYToAddCurr(PmtTolLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtTolLCY <> 0) THEN
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtTolLCY, PmtTolAddCurr,
              NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)".AsInteger());

        // DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
        //   DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance", PmtTol, PmtTolLCY, PmtTolAddCurr, 0, 0, 0);
    END;

    LOCAL PROCEDURE CalcPmtDisc(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; PmtTolAmtToBeApplied: Decimal; ApplnRoundingPrecision: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer);
    VAR
        PmtDisc: Decimal;
        PmtDiscLCY: Decimal;
        PmtDiscAddCurr: Decimal;
        MinimalPossibleLiability: Decimal;
        PaymentExceedsLiability: Boolean;
        ToleratedPaymentExceedsLiability: Boolean;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcPmtDisc(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtTolAmtToBeApplied, IsHandled);
        IF IsHandled THEN
            EXIT;

        MinimalPossibleLiability := ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible");
        OnAfterCalcMinimalPossibleLiability(NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, MinimalPossibleLiability);

        PaymentExceedsLiability := ABS(OldCVLedgEntryBuf2."Amount to Apply") >= MinimalPossibleLiability;
        OnAfterCalcPaymentExceedsLiability(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, MinimalPossibleLiability, PaymentExceedsLiability);

        ToleratedPaymentExceedsLiability :=
          ABS(NewCVLedgEntryBuf."Remaining Amount" + PmtTolAmtToBeApplied) >= MinimalPossibleLiability;
        OnAfterCalcToleratedPaymentExceedsLiability(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, MinimalPossibleLiability,
          ToleratedPaymentExceedsLiability, PmtTolAmtToBeApplied);

        IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, TRUE, TRUE) AND
            ((OldCVLedgEntryBuf2."Amount to Apply" = 0) OR PaymentExceedsLiability) OR
            (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
             (OldCVLedgEntryBuf2."Amount to Apply" <> 0) AND PaymentExceedsLiability AND ToleratedPaymentExceedsLiability))
        THEN BEGIN
            PmtDisc := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
            PmtDiscLCY :=
              ROUND(
                (NewCVLedgEntryBuf."Original Amount" + PmtDisc) / NewCVLedgEntryBuf."Original Currency Factor") -
              NewCVLedgEntryBuf."Original Amt. (LCY)";

            OnCalcPmtDiscOnAfterAssignPmtDisc(PmtDisc, PmtDiscLCY, OldCVLedgEntryBuf, OldCVLedgEntryBuf2);

            OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscLCY;

            IF (NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode) AND (AddCurrencyCode <> '') THEN
                PmtDiscAddCurr := PmtDisc
            ELSE
                PmtDiscAddCurr := CalcLCYToAddCurr(PmtDiscLCY);

            OnAfterCalcPmtDiscount(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              PmtTolAmtToBeApplied, PmtDisc, PmtDiscLCY, PmtDiscAddCurr);

            IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND
               (PmtDiscLCY <> 0)
            THEN
                CalcPmtDiscIfAdjVAT(
                  NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtDiscLCY, PmtDiscAddCurr,
                  NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)".AsInteger());

            // DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            //   GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
            //   DtldCVLedgEntryBuf."Entry Type"::"Payment Discount", PmtDisc, PmtDiscLCY, PmtDiscAddCurr, 0, 0, 0);
        END;
    END;

    LOCAL PROCEDURE CalcPmtDiscIfAdjVAT(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; VAR PmtDiscLCY2: Decimal; VAR PmtDiscAddCurr2: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer; EntryType: Integer);
    VAR
        VATEntry2: Record 254;
        VATPostingSetup: Record 325;
        TaxJurisdiction: Record 320;
        DtldCVLedgEntryBuf2: Record 383;
        OriginalAmountAddCurr: Decimal;
        PmtDiscRounding: Decimal;
        PmtDiscRoundingAddCurr: Decimal;
        PmtDiscFactorLCY: Decimal;
        PmtDiscFactorAddCurr: Decimal;
        VATBase: Decimal;
        VATBaseAddCurr: Decimal;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        TotalVATAmount: Decimal;
        LastConnectionNo: Integer;
        VATEntryModifier: Integer;
    BEGIN
        IF OldCVLedgEntryBuf."Original Amt. (LCY)" = 0 THEN
            EXIT;

        IF (AddCurrencyCode = '') OR (AddCurrencyCode = OldCVLedgEntryBuf."Currency Code") THEN
            OriginalAmountAddCurr := OldCVLedgEntryBuf.Amount
        ELSE
            OriginalAmountAddCurr := CalcLCYToAddCurr(OldCVLedgEntryBuf."Original Amt. (LCY)");

        PmtDiscRounding := PmtDiscLCY2;
        PmtDiscFactorLCY := PmtDiscLCY2 / OldCVLedgEntryBuf."Original Amt. (LCY)";
        IF OriginalAmountAddCurr <> 0 THEN
            PmtDiscFactorAddCurr := PmtDiscAddCurr2 / OriginalAmountAddCurr
        ELSE
            PmtDiscFactorAddCurr := 0;
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", OldCVLedgEntryBuf."Transaction No.");
        IF OldCVLedgEntryBuf."Transaction No." = NextTransactionNo THEN
            VATEntry2.SETRANGE("Entry No.", 0, FirstNewVATEntryNo - 1);
        IF VATEntry2.FINDSET THEN BEGIN
            TotalVATAmount := 0;
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATEntry2."VAT Calculation Type" =
                   VATEntry2."VAT Calculation Type"::"Sales Tax"
                THEN BEGIN
                    TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                    VATPostingSetup."Adjust for Payment Discount" :=
                      TaxJurisdiction."Adjust for Payment Discount";
                END;
                IF VATPostingSetup."Adjust for Payment Discount" THEN BEGIN
                    IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                        IF LastConnectionNo <> 0 THEN BEGIN
                            DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                            DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, FALSE);
                            InsertSummarizedVAT(GenJnlLine);
                        END;

                        CalcPmtDiscVATBases(VATEntry2, VATBase, VATBaseAddCurr);

                        PmtDiscRounding := PmtDiscRounding + VATBase * PmtDiscFactorLCY;
                        VATBase := ROUND(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATBase;

                        PmtDiscRoundingAddCurr := PmtDiscRoundingAddCurr + VATBaseAddCurr * PmtDiscFactorAddCurr;
                        VATBaseAddCurr := ROUND(CalcLCYToAddCurr(VATBase), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATBaseAddCurr;

                        DtldCVLedgEntryBuf2.INIT;
                        DtldCVLedgEntryBuf2."Posting Date" := GenJnlLine."Posting Date";
                        DtldCVLedgEntryBuf2."Document Type" := GenJnlLine."Document Type";
                        DtldCVLedgEntryBuf2."Document No." := GenJnlLine."Document No.";
                        DtldCVLedgEntryBuf2.Amount := 0;
                        DtldCVLedgEntryBuf2."Amount (LCY)" := -VATBase;
                        DtldCVLedgEntryBuf2."Entry Type" := Enum::"Detailed CV Ledger Entry Type".FromInteger(EntryType);
                        CASE EntryType OF
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)".AsInteger():
                                VATEntryModifier := 1000000;
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)".AsInteger():
                                VATEntryModifier := 2000000;
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)".AsInteger():
                                VATEntryModifier := 3000000;
                        END;
                        DtldCVLedgEntryBuf2.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
                        // The total payment discount in currency is posted on the entry made in
                        // the function CalcPmtDisc.
                        DtldCVLedgEntryBuf2."User ID" := USERID;
                        DtldCVLedgEntryBuf2."Additional-Currency Amount" := -VATBaseAddCurr;
                        OnCalcPmtDiscIfAdjVATCopyFields(DtldCVLedgEntryBuf2, OldCVLedgEntryBuf, GenJnlLine);
                        DtldCVLedgEntryBuf2.CopyPostingGroupsFromVATEntry(VATEntry2);
                        TotalVATAmount := 0;
                        LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                    END;

                    CalcPmtDiscVATAmounts(
                      VATEntry2, VATBase, VATBaseAddCurr, VATAmount, VATAmountAddCurr,
                      PmtDiscRounding, PmtDiscFactorLCY, PmtDiscLCY2, PmtDiscAddCurr2);

                    TotalVATAmount := TotalVATAmount + VATAmount;

                    IF (PmtDiscAddCurr2 <> 0) AND (PmtDiscLCY2 = 0) THEN BEGIN
                        VATAmountAddCurr := VATAmountAddCurr - PmtDiscAddCurr2;
                        PmtDiscAddCurr2 := 0;
                    END;

                    // Post VAT
                    // VAT for VAT entry
                    IF VATEntry2.Type.AsInteger() <> 0 THEN
                        InsertPmtDiscVATForVATEntry(
                          GenJnlLine, TempVATEntry, VATEntry2, VATEntryModifier,
                          VATAmount, VATAmountAddCurr, VATBase, VATBaseAddCurr,
                          PmtDiscFactorLCY, PmtDiscFactorAddCurr);

                    // VAT for G/L entry/entries
                    InsertPmtDiscVATForGLEntry(
                      GenJnlLine, DtldCVLedgEntryBuf, NewCVLedgEntryBuf, VATEntry2,
                      VATPostingSetup, TaxJurisdiction, EntryType, VATAmount, VATAmountAddCurr);
                END;
            UNTIL VATEntry2.NEXT = 0;

            IF LastConnectionNo <> 0 THEN BEGIN
                DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                InsertSummarizedVAT(GenJnlLine);
            END;
        END;
    END;

    LOCAL PROCEDURE CalcPmtDiscTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer);
    VAR
        PmtDiscTol: Decimal;
        PmtDiscTolLCY: Decimal;
        PmtDiscTolAddCurr: Decimal;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcPmtDiscTolerance(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF NOT OldCVLedgEntryBuf2."Accepted Pmt. Disc. Tolerance" THEN
            EXIT;

        PmtDiscTol := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
        PmtDiscTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtDiscTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OnAfterCalcPmtDiscTolerance(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
          PmtDiscTol, PmtDiscTolLCY, PmtDiscTolAddCurr);

        OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscTolLCY;

        IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
            PmtDiscTolAddCurr := PmtDiscTol
        ELSE
            PmtDiscTolAddCurr := CalcLCYToAddCurr(PmtDiscTolLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtDiscTolLCY <> 0) THEN
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtDiscTolLCY, PmtDiscTolAddCurr,
              NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)".AsInteger());

        // DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
        //   DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance", PmtDiscTol, PmtDiscTolLCY, PmtDiscTolAddCurr, 0, 0, 0);
    END;

    LOCAL PROCEDURE CalcPmtDiscVATBases(VATEntry2: Record 254; VAR VATBase: Decimal; VAR VATBaseAddCurr: Decimal);
    VAR
        VATEntry: Record 254;
    BEGIN
        CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
            VATEntry2."VAT Calculation Type"::"Full VAT":
                BEGIN
                    VATBase :=
                      VATEntry2.Base + VATEntry2."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry2."Additional-Currency Base" +
                      VATEntry2."Add.-Currency Unrealized Base";
                END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                BEGIN
                    VATEntry.RESET;
                    VATEntry.SETCURRENTKEY("Transaction No.");
                    VATEntry.SETRANGE("Transaction No.", VATEntry2."Transaction No.");
                    VATEntry.SETRANGE("Sales Tax Connection No.", VATEntry2."Sales Tax Connection No.");
                    VATEntry := VATEntry2;
                    REPEAT
                        IF VATEntry.Base < 0 THEN
                            VATEntry.SETFILTER(Base, '>%1', VATEntry.Base)
                        ELSE
                            VATEntry.SETFILTER(Base, '<%1', VATEntry.Base);
                    UNTIL NOT VATEntry.FINDLAST;
                    VATEntry.RESET;
                    VATBase :=
                      VATEntry.Base + VATEntry."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry."Additional-Currency Base" +
                      VATEntry."Add.-Currency Unrealized Base";
                END;
        END;
    END;

    LOCAL PROCEDURE CalcPmtDiscVATAmounts(VATEntry2: Record 254; VATBase: Decimal; VATBaseAddCurr: Decimal; VAR VATAmount: Decimal; VAR VATAmountAddCurr: Decimal; VAR PmtDiscRounding: Decimal; PmtDiscFactorLCY: Decimal; VAR PmtDiscLCY2: Decimal; VAR PmtDiscAddCurr2: Decimal);
    BEGIN
        CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
          VATEntry2."VAT Calculation Type"::"Full VAT":
                IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
                   (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                THEN BEGIN
                    IF (VATBase = 0) AND
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    THEN
                        VATAmount := 0
                    ELSE BEGIN
                        PmtDiscRounding :=
                          PmtDiscRounding +
                          (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                        VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                    END;
                    IF (VATBaseAddCurr = 0) AND
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    THEN
                        VATAmountAddCurr := 0
                    ELSE BEGIN
                        VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                    END;
                END ELSE BEGIN
                    VATAmount := 0;
                    VATAmountAddCurr := 0;
                END;
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                    VATAmount :=
                      ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
                    VATAmount :=
                      ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                END ELSE
                    IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
                       (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                    THEN BEGIN
                        IF VATBase = 0 THEN
                            VATAmount := 0
                        ELSE BEGIN
                            PmtDiscRounding :=
                              PmtDiscRounding +
                              (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                            VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                            PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                        END;

                        IF VATBaseAddCurr = 0 THEN
                            VATAmountAddCurr := 0
                        ELSE BEGIN
                            VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                            PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                        END;
                    END ELSE BEGIN
                        VATAmount := 0;
                        VATAmountAddCurr := 0;
                    END;
        END;
    END;

    LOCAL PROCEDURE InsertPmtDiscVATForVATEntry(GenJnlLine: Record 81; VAR TempVATEntry: Record 254 TEMPORARY; VATEntry2: Record 254; VATEntryModifier: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal; VATBase: Decimal; VATBaseAddCurr: Decimal; PmtDiscFactorLCY: Decimal; PmtDiscFactorAddCurr: Decimal);
    VAR
        TempVATEntryNo: Integer;
    BEGIN
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Entry No.", VATEntryModifier, VATEntryModifier + 999999);
        IF TempVATEntry.FINDLAST THEN
            TempVATEntryNo := TempVATEntry."Entry No." + 1
        ELSE
            TempVATEntryNo := VATEntryModifier + 1;
        TempVATEntry := VATEntry2;
        TempVATEntry."Entry No." := TempVATEntryNo;
        TempVATEntry."Posting Date" := GenJnlLine."Posting Date";
        TempVATEntry."Document Date" := GenJnlLine."Document Date";
        TempVATEntry."Document No." := GenJnlLine."Document No.";
        TempVATEntry."External Document No." := GenJnlLine."External Document No.";
        TempVATEntry."Document Type" := GenJnlLine."Document Type";
        TempVATEntry."Source Code" := GenJnlLine."Source Code";
        TempVATEntry."Reason Code" := GenJnlLine."Reason Code";
        TempVATEntry."Transaction No." := NextTransactionNo;
        TempVATEntry."Sales Tax Connection No." := NextConnectionNo;
        TempVATEntry."Unrealized Amount" := 0;
        TempVATEntry."Unrealized Base" := 0;
        TempVATEntry."Remaining Unrealized Amount" := 0;
        TempVATEntry."Remaining Unrealized Base" := 0;
        TempVATEntry."User ID" := USERID;
        TempVATEntry."Closed by Entry No." := 0;
        TempVATEntry.Closed := FALSE;
        TempVATEntry."Internal Ref. No." := '';
        TempVATEntry.Amount := VATAmount;
        TempVATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        TempVATEntry."VAT Difference" := 0;
        TempVATEntry."Add.-Curr. VAT Difference" := 0;
        TempVATEntry."Add.-Currency Unrealized Amt." := 0;
        TempVATEntry."Add.-Currency Unrealized Base" := 0;
        IF VATEntry2."Tax on Tax" THEN BEGIN
            TempVATEntry.Base :=
              ROUND((VATEntry2.Base + VATEntry2."Unrealized Base") * PmtDiscFactorLCY);
            TempVATEntry."Additional-Currency Base" :=
              ROUND(
                (VATEntry2."Additional-Currency Base" +
                 VATEntry2."Add.-Currency Unrealized Base") * PmtDiscFactorAddCurr,
                AddCurrency."Amount Rounding Precision");
        END ELSE BEGIN
            TempVATEntry.Base := VATBase;
            TempVATEntry."Additional-Currency Base" := VATBaseAddCurr;
        END;
        TempVATEntry."Base Before Pmt. Disc." := VATEntry.Base;

        IF AddCurrencyCode = '' THEN BEGIN
            TempVATEntry."Additional-Currency Base" := 0;
            TempVATEntry."Additional-Currency Amount" := 0;
            TempVATEntry."Add.-Currency Unrealized Amt." := 0;
            TempVATEntry."Add.-Currency Unrealized Base" := 0;
        END;
        OnBeforeInsertTempVATEntry(TempVATEntry, GenJnlLine);
        TempVATEntry.INSERT;
    END;

    LOCAL PROCEDURE InsertPmtDiscVATForGLEntry(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR NewCVLedgEntryBuf: Record 382; VATEntry2: Record 254; VAR VATPostingSetup: Record 325; VAR TaxJurisdiction: Record 320; EntryType: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal);
    BEGIN
        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
        CASE EntryType OF
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)".AsInteger():
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)";
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)".AsInteger():
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)";
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)".AsInteger():
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)";
        END;
        DtldCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
        DtldCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
        DtldCVLedgEntryBuf."Document No." := GenJnlLine."Document No.";
        OnInsertPmtDiscVATForGLEntryOnAfterCopyFromGenJnlLine(DtldCVLedgEntryBuf, GenJnlLine);
        DtldCVLedgEntryBuf.Amount := 0;
        DtldCVLedgEntryBuf."VAT Bus. Posting Group" := VATEntry2."VAT Bus. Posting Group";
        DtldCVLedgEntryBuf."VAT Prod. Posting Group" := VATEntry2."VAT Prod. Posting Group";
        DtldCVLedgEntryBuf."Tax Jurisdiction Code" := VATEntry2."Tax Jurisdiction Code";
        // The total payment discount in currency is posted on the entry made in
        // the function CalcPmtDisc.
        DtldCVLedgEntryBuf."User ID" := USERID;
        DtldCVLedgEntryBuf."Use Additional-Currency Amount" := TRUE;

        CASE VATEntry2.Type OF
            VATEntry2.Type::Purchase:
                CASE VATEntry2."VAT Calculation Type" OF
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        BEGIN
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        BEGIN
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), '',
                              -VATAmount, -VATAmountAddCurr, FALSE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        IF VATEntry2."Use Tax" THEN BEGIN
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetRevChargeAccount(FALSE), '',
                              -VATAmount, -VATAmountAddCurr, FALSE);
                        END ELSE BEGIN
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                END;
            VATEntry2.Type::Sale:
                CASE VATEntry2."VAT Calculation Type" OF
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        BEGIN
                            InitGLEntryVAT(
                              GenJnlLine, VATPostingSetup.GetSalesAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        ;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            InitGLEntryVAT(
                              GenJnlLine, TaxJurisdiction.GetSalesAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                END;
        END;
    END;

    LOCAL PROCEDURE CalcCurrencyApplnRounding(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; ApplnRoundingPrecision: Decimal);
    VAR
        ApplnRounding: Decimal;
        ApplnRoundingLCY: Decimal;
    BEGIN
        IF ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Payment) AND
            (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)) OR
           (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code")
        THEN
            EXIT;

        ApplnRounding := -(NewCVLedgEntryBuf."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount");
        ApplnRoundingLCY := ROUND(ApplnRounding / NewCVLedgEntryBuf."Adjusted Currency Factor");

        IF (ApplnRounding = 0) OR (ABS(ApplnRounding) > ApplnRoundingPrecision) THEN
            EXIT;

        CASE TRUE OF
            (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."Document Type"::Bill): //AND
                                                                                           // (OldCVLedgEntryBuf."Bill No." <> '') AND
                                                                                           // (OldCVLedgEntryBuf."Document Status" = OldCVLedgEntryBuf."Document Status"::Redrawn):
                BEGIN
                    DtldCVLedgEntryBuf.InitFromGenJnlLine(GenJnlLine);
                    DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
                    DtldCVLedgEntryBuf."Entry Type" := DtldCVLedgEntryBuf."Entry Type"::Redrawal;
                    DtldCVLedgEntryBuf."Document Type" := DtldCVLedgEntryBuf."Document Type"::Bill;
                    DtldCVLedgEntryBuf.Amount := ApplnRounding;
                    DtldCVLedgEntryBuf."Amount (LCY)" := ApplnRoundingLCY;
                    DtldCVLedgEntryBuf."Additional-Currency Amount" := ApplnRounding;
                    DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, FALSE);
                END;
            ELSE
        // DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
        //   DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding", ApplnRounding, ApplnRoundingLCY, ApplnRounding, 0, 0, 0);
        END;
    END;

    LOCAL PROCEDURE FindAmtForAppln(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR AppliedAmount: Decimal; VAR AppliedAmountLCY: Decimal; VAR OldAppliedAmount: Decimal; ApplnRoundingPrecision: Decimal);
    VAR
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeFindAmtForAppln(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, AppliedAmount, AppliedAmountLCY, OldAppliedAmount, IsHandled,
          ApplnRoundingPrecision);
        IF IsHandled THEN
            EXIT;

        IF OldCVLedgEntryBuf2.GETFILTER(Positive) <> '' THEN BEGIN
            IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN BEGIN
                IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
                    (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
                     ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")))
                THEN
                    AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount"
                ELSE
                    AppliedAmount := -OldCVLedgEntryBuf2."Amount to Apply"
            END ELSE
                AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
        END ELSE BEGIN
            IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN
                IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
                    (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
                     ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")) AND
                    (ABS(NewCVLedgEntryBuf."Remaining Amount") >=
                     ABS(
                       ABSMin(
                         OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible",
                         OldCVLedgEntryBuf2."Amount to Apply")))) OR
                   OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance"
                THEN BEGIN
                    AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
                    OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance" := FALSE;
                END ELSE
                    AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf2."Amount to Apply")
            ELSE
                AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf2."Remaining Amount");
        END;

        IF (ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply") < ApplnRoundingPrecision) AND
           (ApplnRoundingPrecision <> 0) AND
           (OldCVLedgEntryBuf2."Amount to Apply" <> 0)
        THEN
            AppliedAmount := AppliedAmount - (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply");

        IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code" THEN BEGIN
            AppliedAmountLCY := ROUND(AppliedAmount / OldCVLedgEntryBuf."Original Currency Factor");
            OldAppliedAmount := AppliedAmount;
        END ELSE BEGIN
            // Management of posting in multiple currencies
            IF AppliedAmount = -OldCVLedgEntryBuf2."Remaining Amount" THEN
                OldAppliedAmount := -OldCVLedgEntryBuf."Remaining Amount"
            ELSE
                OldAppliedAmount :=
                  CurrExchRate.ExchangeAmount(
                    AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                    OldCVLedgEntryBuf2."Currency Code", NewCVLedgEntryBuf."Posting Date");

            IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
                // Post the realized gain or loss on the NewCVLedgEntryBuf
                AppliedAmountLCY := ROUND(OldAppliedAmount / OldCVLedgEntryBuf."Original Currency Factor")
            ELSE
                // Post the realized gain or loss on the OldCVLedgEntryBuf
                AppliedAmountLCY := ROUND(AppliedAmount / NewCVLedgEntryBuf."Original Currency Factor");
        END;
        AppliedAmountLCY2 := AppliedAmountLCY;

        OnAfterFindAmtForAppln(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, AppliedAmount, AppliedAmountLCY, OldAppliedAmount);
    END;

    LOCAL PROCEDURE CalcCurrencyUnrealizedGainLoss(VAR CVLedgEntryBuf: Record 382; VAR TempDtldCVLedgEntryBuf: Record 383 TEMPORARY; GenJnlLine: Record 81; AppliedAmount: Decimal; RemainingAmountBeforeAppln: Decimal);
    VAR
        DtldCustLedgEntry: Record 379;
        DtldVendLedgEntry: Record 380;
        UnRealizedGainLossLCY: Decimal;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcCurrencyUnrealizedGainLoss(
          CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, AppliedAmount, RemainingAmountBeforeAppln, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF (CVLedgEntryBuf."Currency Code" = '') OR (RemainingAmountBeforeAppln = 0) THEN
            EXIT;

        // Calculate Unrealized GainLoss
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
            UnRealizedGainLossLCY :=
              ROUND(
                DtldCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln))
        ELSE
            UnRealizedGainLossLCY :=
              ROUND(
                DtldVendLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln));

        // IF UnRealizedGainLossLCY <> 0 THEN
        // IF UnRealizedGainLossLCY < 0 THEN
        // TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
        //   TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0)
        // ELSE
        // TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
        //   TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0);
    END;

    LOCAL PROCEDURE CalcCurrencyRealizedGainLoss(VAR CVLedgEntryBuf: Record 382; VAR TempDtldCVLedgEntryBuf: Record 383 TEMPORARY; GenJnlLine: Record 81; AppliedAmount: Decimal; AppliedAmountLCY: Decimal);
    VAR
        RealizedGainLossLCY: Decimal;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcCurrencyRealizedGainLoss(
          CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, AppliedAmount, AppliedAmountLCY, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF CVLedgEntryBuf."Currency Code" = '' THEN
            EXIT;

        RealizedGainLossLCY := AppliedAmountLCY - ROUND(AppliedAmount / CVLedgEntryBuf."Original Currency Factor");
        OnAfterCalcCurrencyRealizedGainLoss(CVLedgEntryBuf, AppliedAmount, AppliedAmountLCY, RealizedGainLossLCY);

        // IF RealizedGainLossLCY <> 0 THEN
        //     IF RealizedGainLossLCY < 0 THEN
        //         TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //           GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
        //           TempDtldCVLedgEntryBuf."Entry Type"::"Realized Loss", 0, RealizedGainLossLCY, 0, 0, 0, 0)
        //     ELSE
        //         TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //           GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
        //           TempDtldCVLedgEntryBuf."Entry Type"::"Realized Gain", 0, RealizedGainLossLCY, 0, 0, 0, 0);
    END;

    LOCAL PROCEDURE CalcApplication(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; AppliedAmount: Decimal; AppliedAmountLCY: Decimal; OldAppliedAmount: Decimal; PrevNewCVLedgEntryBuf: Record 382; PrevOldCVLedgEntryBuf: Record 382; VAR AllApplied: Boolean);
    VAR
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcAplication(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine,
          AppliedAmount, AppliedAmountLCY, OldAppliedAmount, PrevNewCVLedgEntryBuf, PrevOldCVLedgEntryBuf, AllApplied, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF AppliedAmount = 0 THEN
            EXIT;

        // DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, OldCVLedgEntryBuf, DtldCVLedgEntryBuf,
        //   DtldCVLedgEntryBuf."Entry Type"::Application, OldAppliedAmount, AppliedAmountLCY, 0,
        //   NewCVLedgEntryBuf."Entry No.", PrevOldCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
        //   PrevOldCVLedgEntryBuf."Max. Payment Tolerance");

        OnAfterInitOldDtldCVLedgEntryBuf(
          DtldCVLedgEntryBuf, NewCVLedgEntryBuf, OldCVLedgEntryBuf, PrevNewCVLedgEntryBuf, PrevOldCVLedgEntryBuf, GenJnlLine);

        OldCVLedgEntryBuf.Open := OldCVLedgEntryBuf."Remaining Amount" <> 0;
        IF NOT OldCVLedgEntryBuf.Open THEN
            OldCVLedgEntryBuf.SetClosedFields(
              NewCVLedgEntryBuf."Entry No.", GenJnlLine."Posting Date",
              -OldAppliedAmount, -AppliedAmountLCY, NewCVLedgEntryBuf."Currency Code", -AppliedAmount)
        ELSE
            AllApplied := FALSE;

        // DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //   GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
        //   DtldCVLedgEntryBuf."Entry Type"::Application, -AppliedAmount, -AppliedAmountLCY, 0,
        //   NewCVLedgEntryBuf."Entry No.", PrevNewCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
        //   PrevNewCVLedgEntryBuf."Max. Payment Tolerance");

        OnAfterInitNewDtldCVLedgEntryBuf(
          DtldCVLedgEntryBuf, NewCVLedgEntryBuf, OldCVLedgEntryBuf, PrevNewCVLedgEntryBuf, PrevOldCVLedgEntryBuf, GenJnlLine);

        NewCVLedgEntryBuf.Open := NewCVLedgEntryBuf."Remaining Amount" <> 0;
        IF NOT NewCVLedgEntryBuf.Open AND NOT AllApplied THEN
            NewCVLedgEntryBuf.SetClosedFields(
              OldCVLedgEntryBuf."Entry No.", GenJnlLine."Posting Date",
              AppliedAmount, AppliedAmountLCY, OldCVLedgEntryBuf."Currency Code", OldAppliedAmount);
    END;

    LOCAL PROCEDURE CalcAmtLCYAdjustment(VAR CVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81);
    VAR
        AdjustedAmountLCY: Decimal;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCalcAmtLCYAdjustment(CVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF CVLedgEntryBuf."Currency Code" = '' THEN
            EXIT;

        AdjustedAmountLCY :=
          ROUND(CVLedgEntryBuf."Remaining Amount" / CVLedgEntryBuf."Adjusted Currency Factor");

        IF AdjustedAmountLCY <> CVLedgEntryBuf."Remaining Amt. (LCY)" THEN BEGIN
            DtldCVLedgEntryBuf.InitFromGenJnlLine(GenJnlLine);
            DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(CVLedgEntryBuf);
            DtldCVLedgEntryBuf."Entry Type" :=
              DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount";
            DtldCVLedgEntryBuf."Amount (LCY)" := AdjustedAmountLCY - CVLedgEntryBuf."Remaining Amt. (LCY)";
            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, CVLedgEntryBuf, FALSE);
        END;
    END;

    LOCAL PROCEDURE InitBankAccLedgEntry(GenJnlLine: Record 81; VAR BankAccLedgEntry: Record 271);
    BEGIN
        BankAccLedgEntry.INIT;
        BankAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        BankAccLedgEntry."Entry No." := NextEntryNo;
        BankAccLedgEntry."Transaction No." := NextTransactionNo;

        OnAfterInitBankAccLedgEntry(BankAccLedgEntry, GenJnlLine);
    END;

    LOCAL PROCEDURE InitCheckLedgEntry(BankAccLedgEntry: Record 271; VAR CheckLedgEntry: Record 272);
    BEGIN
        CheckLedgEntry.INIT;
        CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
        CheckLedgEntry."Entry No." := NextCheckEntryNo;

        OnAfterInitCheckLedgEntry(CheckLedgEntry, BankAccLedgEntry);
    END;

    LOCAL PROCEDURE InitCustLedgEntry(GenJnlLine: Record 81; VAR CustLedgEntry: Record 21);
    BEGIN
        CustLedgEntry.INIT;
        CustLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        CustLedgEntry."Entry No." := NextEntryNo;
        CustLedgEntry."Transaction No." := NextTransactionNo;

        OnAfterInitCustLedgEntry(CustLedgEntry, GenJnlLine);
    END;

    LOCAL PROCEDURE InitVendLedgEntry(GenJnlLine: Record 81; VAR VendLedgEntry: Record 25);
    BEGIN
        VendLedgEntry.INIT;
        VendLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        VendLedgEntry."Entry No." := NextEntryNo;
        VendLedgEntry."Transaction No." := NextTransactionNo;

        OnAfterInitVendLedgEntry(VendLedgEntry, GenJnlLine);
    END;

    LOCAL PROCEDURE InitEmployeeLedgerEntry(GenJnlLine: Record 81; VAR EmployeeLedgerEntry: Record 5222);
    BEGIN
        EmployeeLedgerEntry.INIT;
        EmployeeLedgerEntry.CopyFromGenJnlLine(GenJnlLine);
        EmployeeLedgerEntry."Entry No." := NextEntryNo;
        EmployeeLedgerEntry."Transaction No." := NextTransactionNo;

        OnAfterInitEmployeeLedgerEntry(EmployeeLedgerEntry, GenJnlLine);
    END;

    LOCAL PROCEDURE InsertDtldCustLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VAR DtldCustLedgEntry: Record 379; Offset: Integer);
    BEGIN
        WITH DtldCustLedgEntry DO BEGIN
            INIT;
            TRANSFERFIELDS(DtldCVLedgEntryBuf);
            "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "Source Code" := GenJnlLine."Source Code";
            "Transaction No." := NextTransactionNo;
            UpdateDebitCredit(GenJnlLine.Correction);
            OnBeforeInsertDtldCustLedgEntry(DtldCustLedgEntry, GenJnlLine, DtldCVLedgEntryBuf);
            INSERT(TRUE);
            OnAfterInsertDtldCustLedgEntry(DtldCustLedgEntry, GenJnlLine, DtldCVLedgEntryBuf, Offset);
        END;
    END;

    LOCAL PROCEDURE InsertDtldVendLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VAR DtldVendLedgEntry: Record 380; Offset: Integer);
    BEGIN
        WITH DtldVendLedgEntry DO BEGIN
            INIT;
            TRANSFERFIELDS(DtldCVLedgEntryBuf);
            "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "Source Code" := GenJnlLine."Source Code";
            "Transaction No." := NextTransactionNo;
            UpdateDebitCredit(GenJnlLine.Correction);
            OnBeforeInsertDtldVendLedgEntry(DtldVendLedgEntry, GenJnlLine, DtldCVLedgEntryBuf);
            INSERT(TRUE);
            OnAfterInsertDtldVendLedgEntry(DtldVendLedgEntry, GenJnlLine, DtldCVLedgEntryBuf, Offset);
        END;
    END;

    LOCAL PROCEDURE InsertDtldEmplLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VAR DtldEmplLedgEntry: Record 5223; Offset: Integer);
    BEGIN
        WITH DtldEmplLedgEntry DO BEGIN
            INIT;
            TRANSFERFIELDS(DtldCVLedgEntryBuf);
            "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "Source Code" := GenJnlLine."Source Code";
            "Transaction No." := NextTransactionNo;
            UpdateDebitCredit(GenJnlLine.Correction);
            OnBeforeInsertDtldEmplLedgEntry(DtldEmplLedgEntry, GenJnlLine, DtldCVLedgEntryBuf);
            INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE ApplyCustLedgEntry(VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; Cust: Record 18);
    VAR
        OldCustLedgEntry: Record 21;
        OldCVLedgEntryBuf: Record 382;
        NewCustLedgEntry: Record 21;
        NewCVLedgEntryBuf2: Record 382;
        TempOldCustLedgEntry: Record 21 TEMPORARY;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
        CarteraManagement: Codeunit 7000000;
        InvCustLedgEntry: Record 21;
    BEGIN
        OnBeforeApplyCustLedgEntry(NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, Cust);

        IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
            EXIT;

        AllApplied := TRUE;
        IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
           NOT
           ((Cust."Application Method" = Cust."Application Method"::"Apply to Oldest") AND
            GenJnlLine."Allow Application")
        THEN
            EXIT;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        IF NOT PrepareTempCustLedgEntry(GenJnlLine, NewCVLedgEntryBuf, TempOldCustLedgEntry, Cust, ApplyingDate) THEN
            EXIT;

        IF GenJnlLine."Applies-to ID" = '' THEN
            AppliesToDocType := TempOldCustLedgEntry."Document Type".AsInteger();

        IF OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::Bill THEN BEGIN
            InvCustLedgEntry.SETRANGE("Document Type", OldCustLedgEntry."Document Type"::Invoice);
            InvCustLedgEntry.SETRANGE("Document No.", OldCustLedgEntry."Document No.");
            InvCustLedgEntry.SETRANGE("Customer No.", OldCustLedgEntry."Customer No.");
            IF NOT InvCustLedgEntry.FINDFIRST THEN
                ERROR(Text1100001, OldCustLedgEntry."Document No.");
        END;

        GenJnlLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        REPEAT
            TempOldCustLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            TempOldCustLedgEntry.COPYFILTER(Positive, OldCVLedgEntryBuf.Positive);
            OldCVLedgEntryBuf.CopyFromCustLedgEntry(TempOldCustLedgEntry);

            IF Cust."Application Method" = Cust."Application Method"::"Apply to Oldest" THEN
                IF Doc.GET(Doc.Type::Receivable, OldCVLedgEntryBuf."Entry No.") THEN
                    IF Doc."Bill Gr./Pmt. Order No." <> '' THEN
                        ERROR(
                          Text1100007 +
                          Text1100008,
                          OldCVLedgEntryBuf.Description);

            PostApply(
              GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2,
              Cust."Block Payment Tolerance", AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            IF NOT OldCVLedgEntryBuf.Open THEN BEGIN
                UpdateCalcInterest(OldCVLedgEntryBuf);
                UpdateCalcInterest2(OldCVLedgEntryBuf, NewCVLedgEntryBuf);
            END;

            TempOldCustLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
            OldCustLedgEntry := TempOldCustLedgEntry;
            IF (OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::Bill) OR
               (OldCustLedgEntry."Document Situation".AsInteger() <> 0)
            THEN BEGIN
                IF (OldCustLedgEntry."Document Situation" IN [
                                                              OldCustLedgEntry."Document Situation"::"Closed Documents",
                                                              OldCustLedgEntry."Document Situation"::"Closed BG/PO"])
                THEN
                    FromClosedDoc := TRUE
                ELSE
                    FromClosedDoc := FALSE;
                IF (OldCustLedgEntry."Document Status" = OldCustLedgEntry."Document Status"::Rejected) OR
                   (OldCustLedgEntry."Document Status" = OldCustLedgEntry."Document Status"::Redrawn)
                THEN BEGIN
                    TempRejCustLedgEntry := OldCustLedgEntry;
                    TempRejCustLedgEntry."Remaining Amount (LCY) stats." := AppliedAmountLCY2 + DeltaUnrealAmount + DeltaAmountLCY;
                    TempRejCustLedgEntry.INSERT;
                END;
                DocPost.UpdateReceivableDoc(
                  OldCustLedgEntry, GenJnlLine, AppliedAmountLCY2 + DeltaUnrealAmount + DeltaAmountLCY,
                  DocAmountLCY, RejDocAmountLCY, DiscDocAmountLCY, CollDocAmountLCY,
                  DiscRiskFactAmountLCY, DiscUnriskFactAmountLCY, CollFactAmountLCY);
            END;
            OldCustLedgEntry."Applies-to ID" := '';
            OldCustLedgEntry."Amount to Apply" := 0;
            OldCustLedgEntry.MODIFY;

            OnAfterOldCustLedgEntryModify(OldCustLedgEntry);

            IF GLSetup."Unrealized VAT" OR
               (GLSetup."Prepayment Unrealized VAT" AND TempOldCustLedgEntry.Prepayment)
            THEN
                IF ((IsNotPayment(TempOldCustLedgEntry."Document Type") OR //enum to option
                     (TempOldCustLedgEntry."Document Type" = TempOldCustLedgEntry."Document Type"::Bill)) AND
                    (NewCVLedgEntryBuf."Document Type".AsInteger() <> 0) AND
                    (NOT CarteraManagement.CheckFromRedrawnDoc(TempOldCustLedgEntry."Bill No.")) AND
                    (NOT FromClosedDoc))
                THEN BEGIN
                    TempOldCustLedgEntry.RecalculateAmounts(
                      NewCVLedgEntryBuf."Currency Code", TempOldCustLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    CustUnrealizedVAT(
                      GenJnlLine,
                      TempOldCustLedgEntry,
                      CurrExchRate.ExchangeAmount(
                        AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                        TempOldCustLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date"));
                END;

            TempOldCustLedgEntry.DELETE;

            // Find the next old entry for application of the new entry
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN
                Completed := TRUE
            ELSE
                IF TempOldCustLedgEntry.GETFILTER(Positive) <> '' THEN
                    IF TempOldCustLedgEntry.NEXT = 1 THEN
                        Completed := FALSE
                    ELSE BEGIN
                        TempOldCustLedgEntry.SETRANGE(Positive);
                        TempOldCustLedgEntry.FIND('-');
                        TempOldCustLedgEntry.CALCFIELDS("Remaining Amount");
                        Completed := TempOldCustLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
                    END
                ELSE
                    IF NewCVLedgEntryBuf.Open THEN
                        Completed := TempOldCustLedgEntry.NEXT = 0
                    ELSE
                        Completed := TRUE;
        UNTIL Completed;

        DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.", "Entry Type");
        DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.", NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SETRANGE(
          "Entry Type",
          DtldCVLedgEntryBuf."Entry Type"::Application);
        DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)", Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, DtldCVLedgEntryBuf.Amount, NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;

        IF NOT NewCVLedgEntryBuf.Open THEN
            UpdateCalcInterest(NewCVLedgEntryBuf);

        IF (NewCustLedgEntry."Document Type" = NewCustLedgEntry."Document Type"::Bill) OR
           (NewCustLedgEntry."Document Situation".AsInteger() <> 0)
        THEN BEGIN
            IF (NewCustLedgEntry."Document Situation" IN [
                                                          NewCustLedgEntry."Document Situation"::"Closed Documents",
                                                          NewCustLedgEntry."Document Situation"::"Closed BG/PO"])
            THEN
                FromClosedDoc := TRUE
            ELSE
                FromClosedDoc := FALSE;
            DocPost.UpdateReceivableDoc(
              NewCustLedgEntry, GenJnlLine, AppliedAmountLCY2 + DeltaUnrealAmount + DeltaAmountLCY,
              DocAmountLCY, RejDocAmountLCY, DiscDocAmountLCY, CollDocAmountLCY,
              DiscRiskFactAmountLCY, DiscUnriskFactAmountLCY, CollFactAmountLCY);
        END;

        //Esto sobra, hay que eliminarlo
        //++IF GenJnlLine."Withholding Group" <> '' THEN //QB
        //++  EXIT;                                      //QB

        IF GLSetup."Unrealized VAT" OR
           (GLSetup."Prepayment Unrealized VAT" AND NewCVLedgEntryBuf.Prepayment)
        THEN
            IF (IsNotPayment(NewCVLedgEntryBuf."Document Type"))// OR //enum to option
            //     (NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."Document Type"::Bill)) AND
            //    (NOT CarteraManagement.CheckFromRedrawnDoc(NewCVLedgEntryBuf."Bill No.")) AND
            //    (NOT FromClosedDoc) AND
            //    (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
            THEN BEGIN
                NewCustLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
                CheckUnrealizedCust := TRUE;
                UnrealizedCustLedgEntry := NewCustLedgEntry;
                UnrealizedCustLedgEntry.CALCFIELDS("Amount (LCY)", "Original Amt. (LCY)");
                UnrealizedRemainingAmountCust := NewCustLedgEntry."Remaining Amount" - NewRemainingAmtBeforeAppln;
            END;
    END;

    //[External]
    PROCEDURE CustPostApplyCustLedgEntry(VAR GenJnlLinePostApply: Record 81; VAR CustLedgEntryPostApply: Record 21);
    VAR
        Cust: Record 18;
        CustPostingGr: Record 92;
        CustLedgEntry: Record 21;
        DtldCustLedgEntry: Record 379;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        CVLedgEntryBuf: Record 382;
        GenJnlLine: Record 81;
        DtldLedgEntryInserted: Boolean;
    BEGIN
        GenJnlLine := GenJnlLinePostApply;
        CustLedgEntry.TRANSFERFIELDS(CustLedgEntryPostApply);
        WITH GenJnlLine DO BEGIN
            "Source Currency Code" := CustLedgEntryPostApply."Currency Code";
            "Applies-to ID" := CustLedgEntryPostApply."Applies-to ID";

            GenJnlCheckLine.RunCheck(GenJnlLine);

            IF NextEntryNo = 0 THEN
                StartPosting(GenJnlLine)
            ELSE
                ContinuePosting(GenJnlLine);

            Cust.GET(CustLedgEntry."Customer No.");
            Cust.CheckBlockedCustOnJnls(Cust, "Document Type", TRUE);

            OnCustPostApplyCustLedgEntryOnBeforeCheckPostingGroup(GenJnlLine, Cust);

            IF "Posting Group" = '' THEN BEGIN
                Cust.TESTFIELD("Customer Posting Group");
                "Posting Group" := Cust."Customer Posting Group";
            END;
            CustPostingGr.GET("Posting Group");
            CustPostingGr.GetReceivablesAccount;

            DtldCustLedgEntry.LOCKTABLE;
            CustLedgEntry.LOCKTABLE;

            // Post the application
            CustLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
            ApplyCustLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Cust);
            CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
            CustLedgEntry.MODIFY;

            // Post the Dtld customer entry
            DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, CustPostingGr, FALSE);

            CheckPostUnrealizedVAT(GenJnlLine, TRUE);

            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);

            GenJnlLineQB := GenJnlLine;//QB

            FinishPosting(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE PrepareTempCustLedgEntry(VAR GenJnlLine: Record 81; VAR NewCVLedgEntryBuf: Record 382; VAR TempOldCustLedgEntry: Record 21 TEMPORARY; Cust: Record 18; VAR ApplyingDate: Date): Boolean;
    VAR
        OldCustLedgEntry: Record 21;
        SalesSetup: Record 311;
        GenJnlApply: Codeunit 225;
        RemainingAmount: Decimal;
    BEGIN
        OnBeforePrepareTempCustledgEntry(GenJnlLine, NewCVLedgEntryBuf);

        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find the entry to be applied to
            OldCustLedgEntry.RESET;
            OldCustLedgEntry.SETCURRENTKEY("Document No.");
            OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            // OldCustLedgEntry.SETRANGE("Bill No.", NewCVLedgEntryBuf."Applies-to Bill No.");
            OldCustLedgEntry.SETRANGE("Customer No.", NewCVLedgEntryBuf."CV No.");
            OldCustLedgEntry.SETRANGE(Open, TRUE);

            OldCustLedgEntry.FINDFIRST;
            CheckCarteraAccessPermissions(OldCustLedgEntry."Document Situation");
            OldCustLedgEntry.TESTFIELD(Positive, NOT NewCVLedgEntryBuf.Positive);
            DocPost.CheckAppliedReceivableDoc(OldCustLedgEntry, GenJnlLine."System-Created Entry");
            IF OldCustLedgEntry."Posting Date" > ApplyingDate THEN
                ApplyingDate := OldCustLedgEntry."Posting Date";
            GenJnlApply.CheckAgainstApplnCurrency(
              NewCVLedgEntryBuf."Currency Code", OldCustLedgEntry."Currency Code", GenJnlLine."Account Type"::Customer, TRUE);
            TempOldCustLedgEntry := OldCustLedgEntry;
            OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(TempOldCustLedgEntry, GenJnlLine);
            TempOldCustLedgEntry.INSERT;
        END ELSE BEGIN
            // Find the first old entry (Invoice) which the new entry (Payment) should apply to
            OldCustLedgEntry.RESET;
            OldCustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
            TempOldCustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
            OldCustLedgEntry.SETRANGE("Customer No.", NewCVLedgEntryBuf."CV No.");
            OldCustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            OldCustLedgEntry.SETRANGE(Open, TRUE);
            OldCustLedgEntry.SETFILTER("Document Situation", '<>%1', OldCustLedgEntry."Document Situation"::"Posted BG/PO");
            OldCustLedgEntry.SETFILTER("Entry No.", '<>%1', NewCVLedgEntryBuf."Entry No.");
            IF NOT (Cust."Application Method" = Cust."Application Method"::"Apply to Oldest") THEN
                OldCustLedgEntry.SETFILTER("Amount to Apply", '<>%1', 0);

            IF Cust."Application Method" = Cust."Application Method"::"Apply to Oldest" THEN
                OldCustLedgEntry.SETFILTER("Posting Date", '..%1', GenJnlLine."Posting Date");

            // Check Cust Ledger Entry and add to Temp.
            SalesSetup.GET;
            IF SalesSetup."Appln. between Currencies" = SalesSetup."Appln. between Currencies"::None THEN
                OldCustLedgEntry.SETRANGE("Currency Code", NewCVLedgEntryBuf."Currency Code");
            IF OldCustLedgEntry.FINDSET(FALSE) THEN
                REPEAT
                    CheckCarteraAccessPermissions(OldCustLedgEntry."Document Situation");
                    IF GenJnlApply.CheckAgainstApplnCurrency(
                         NewCVLedgEntryBuf."Currency Code", OldCustLedgEntry."Currency Code", GenJnlLine."Account Type"::Customer, FALSE)
                    THEN BEGIN
                        IF (OldCustLedgEntry."Posting Date" > ApplyingDate) AND (OldCustLedgEntry."Applies-to ID" <> '') THEN
                            ApplyingDate := OldCustLedgEntry."Posting Date";
                        TempOldCustLedgEntry := OldCustLedgEntry;
                        OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(TempOldCustLedgEntry, GenJnlLine);
                        TempOldCustLedgEntry.INSERT;
                    END;
                UNTIL OldCustLedgEntry.NEXT = 0;

            TempOldCustLedgEntry.SETRANGE(Positive, NewCVLedgEntryBuf."Remaining Amount" > 0);

            IF TempOldCustLedgEntry.FIND('-') THEN BEGIN
                RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
                TempOldCustLedgEntry.SETRANGE(Positive);
                TempOldCustLedgEntry.FIND('-');
                REPEAT
                    TempOldCustLedgEntry.CALCFIELDS("Remaining Amount");
                    TempOldCustLedgEntry.RecalculateAmounts(
                      TempOldCustLedgEntry."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    IF PaymentToleranceMgt.CheckCalcPmtDiscCVCust(NewCVLedgEntryBuf, TempOldCustLedgEntry, 0, FALSE, FALSE) THEN
                        TempOldCustLedgEntry."Remaining Amount" -= TempOldCustLedgEntry."Remaining Pmt. Disc. Possible";
                    RemainingAmount += TempOldCustLedgEntry."Remaining Amount";
                UNTIL TempOldCustLedgEntry.NEXT = 0;
                TempOldCustLedgEntry.SETRANGE(Positive, RemainingAmount < 0);
            END ELSE
                TempOldCustLedgEntry.SETRANGE(Positive);

            OnPrepareTempCustLedgEntryOnBeforeExit(GenJnlLine, NewCVLedgEntryBuf, TempOldCustLedgEntry);
            EXIT(TempOldCustLedgEntry.FIND('-'));
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostDtldCustLedgEntries(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; CustPostingGr: Record 92; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean;
    VAR
        TempInvPostBuf: Record 49 TEMPORARY;
        DtldCustLedgEntry: Record 379;
        Currency: Record 4;
        GLEntry: Record 17;
        DtldCustLedgEntry2: Record 379;
        AdjAmount: ARRAY[4] OF Decimal;
        DtldCustLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
        ReceivableAccAmtLCY: Decimal;
        ReceivableAccAmtAddCurr: Decimal;
        ExistDtldCVLedgEntryBuf: Boolean;
        FindBill: Boolean;
    BEGIN
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Customer THEN
            EXIT;

        IF DtldCustLedgEntry.FINDLAST THEN
            DtldCustLedgEntryNoOffset := DtldCustLedgEntry."Entry No."
        ELSE
            DtldCustLedgEntryNoOffset := 0;
        DtldCVLedgEntryBuf.RESET;
        DtldCVLedgEntryBuf.SETRANGE("Initial Document Type", DtldCVLedgEntryBuf."Initial Document Type"::Bill);
        IF DtldCVLedgEntryBuf.FINDFIRST THEN
            FindBill := TRUE;
        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted OR FindBill THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
                NextEntryNo2 := NextEntryNo;
            END;
            REPEAT
                InsertDtldCustLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldCustLedgEntry, DtldCustLedgEntryNoOffset);
                UpdateCustLedgEntryStats(DtldCustLedgEntry."Cust. Ledger Entry No.");
                UpdateTotalAmounts(TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf);
                IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
                    (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
                   ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
                THEN
                    CASE DtldCVLedgEntryBuf."Entry Type" OF
                        DtldCVLedgEntryBuf."Entry Type"::"Initial Entry":
                            IF CheckCarteraPostDtldCustLE(
                                 GenJnlLine, DtldCustLedgEntry, ReceivableAccAmtLCY, ReceivableAccAmtAddCurr, FALSE)
                            THEN
                                DocAmountLCY := DtldCVLedgEntryBuf."Amount (LCY)";
                        DtldCVLedgEntryBuf."Entry Type"::Application:
                            IF CheckCarteraPostDtldCustLE(
                                 GenJnlLine, DtldCustLedgEntry, ReceivableAccAmtLCY, ReceivableAccAmtAddCurr, FALSE)
                            THEN BEGIN
                                GetCurrency(Currency, DtldCVLedgEntryBuf."Currency Code");
                                CheckNonAddCurrCodeOccurred(Currency.Code);
                                CreateGLEntry(
                                  GenJnlLine, CustPostingGr.GetReceivablesAccount, -DtldCVLedgEntryBuf."Amount (LCY)", 0,
                                  DtldCVLedgEntryBuf."Currency Code" = AddCurrencyCode);
                            END;
                        DtldCVLedgEntryBuf."Entry Type"::Redrawal:
                            ;
                        DtldCVLedgEntryBuf."Entry Type"::Rejection:
                            ;
                        ELSE
                            PostDtldCustLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, AdjAmount);
                    END;
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;

            ExistDtldCVLedgEntryBuf := NOT DtldCVLedgEntryBuf.ISEMPTY;
            DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
            DtldCVLedgEntryBuf.DELETEALL;

            IF UseGLBillsAccount(GenJnlLine) THEN
                AccNo := CustPostingGr.GetBillsAccount(FALSE)
            ELSE
                AccNo := CustPostingGr.GetReceivablesAccount;

            //JAV 13/01/22: - QB 1.10.09 Cambiar las cuentas para el confirming si es necesario
            IF UseGLBillsAccount(GenJnlLine) THEN
                QBTableSubscriber.T92_ChangeCustomerConfirmingAccount(GenJnlLine, AccNo);
            //FIN QB 1.10.09

            CalcInvPostBufferTotals(TempInvPostBuf);
            ReceivableAccAmtLCY :=
              TempInvPostBuf.Amount -
              (DocAmountLCY + DiscDocAmountLCY +
               CollDocAmountLCY + RejDocAmountLCY + DiscRiskFactAmountLCY +
               DiscUnriskFactAmountLCY + CollFactAmountLCY);
            ReceivableAccAmtAddCurr :=
              TempInvPostBuf."Amount (ACY)" -
              (DocAmtCalcAddCurrency(GenJnlLine, DocAmountLCY) + DocAmtCalcAddCurrency(GenJnlLine, DiscDocAmountLCY) +
               DocAmtCalcAddCurrency(GenJnlLine, CollDocAmountLCY) + DocAmtCalcAddCurrency(GenJnlLine, RejDocAmountLCY) +
               DocAmtCalcAddCurrency(GenJnlLine, DiscRiskFactAmountLCY) + DocAmtCalcAddCurrency(GenJnlLine, DiscUnriskFactAmountLCY) +
               DocAmtCalcAddCurrency(GenJnlLine, CollFactAmountLCY));

            CustLedgEntryInserted2 := LedgEntryInserted;
            IF IsCreditMemo THEN
                SetFromSettlement(FALSE);
            IF CheckCarteraPostDtldCustLE(GenJnlLine, DtldCustLedgEntry2, ReceivableAccAmtLCY, ReceivableAccAmtAddCurr, FALSE) THEN
                IF (TempInvPostBuf.Amount <> 0) OR ((TempInvPostBuf."Amount (ACY)" <> 0) AND (AddCurrencyCode <> '')) OR
                   (GenJnlLine."Applies-to ID" <> '')
                THEN
                    IF (ReceivableAccAmtLCY <> 0) OR
                       ((ReceivableAccAmtAddCurr <> 0) AND (AddCurrencyCode <> ''))
                    THEN BEGIN
                        InitGLEntry(GenJnlLine, GLEntry,
                          AccNo, ReceivableAccAmtLCY, ReceivableAccAmtAddCurr, TRUE, TRUE);
                        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
                        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
                        UpdateGLEntryNo(GLEntry."Entry No.", SaveEntryNo);
                        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
                    END;
        END;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine, TempInvPostBuf, AdjAmount, SaveEntryNo, CustPostingGr.GetReceivablesAccount);

        PostReceivableDocs(GenJnlLine, CustPostingGr);

        DtldCVLedgEntryBuf.DELETEALL;
    END;

    LOCAL PROCEDURE PostDtldCustLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; CustPostingGr: Record 92; VAR AdjAmount: ARRAY[4] OF Decimal);
    VAR
        AccNo: Code[20];
    BEGIN
        AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, 0, FALSE);
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, FALSE);
    END;

    LOCAL PROCEDURE PostDtldCustLedgEntryUnapply(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; CustPostingGr: Record 92; OriginalTransactionNo: Integer);
    VAR
        AdjAmount: ARRAY[4] OF Decimal;
        AccNo: Code[20];
    BEGIN
        IF (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
           (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
           ((AddCurrencyCode = '') OR (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
        THEN
            EXIT;

        AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, OriginalTransactionNo, TRUE);
        DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."Gen. Posting Type"::Sale;
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, TRUE);
    END;

    LOCAL PROCEDURE GetDtldCustLedgEntryAccNo(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; CustPostingGr: Record 92; OriginalTransactionNo: Integer; Unapply: Boolean): Code[20];
    VAR
        GenPostingSetup: Record 252;
        Currency: Record 4;
        AmountCondition: Boolean;
    BEGIN
        WITH DtldCVLedgEntryBuf DO BEGIN
            AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf, Unapply);
            CASE "Entry Type" OF
                "Entry Type"::"Initial Entry":
                    ;
                "Entry Type"::Application:
                    ;
                "Entry Type"::"Unrealized Loss",
                "Entry Type"::"Unrealized Gain",
                "Entry Type"::"Realized Loss",
                "Entry Type"::"Realized Gain":
                    BEGIN
                        GetCurrency(Currency, "Currency Code");
                        CheckNonAddCurrCodeOccurred(Currency.Code);
                        EXIT(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
                    END;
                "Entry Type"::"Payment Discount":
                    EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                "Entry Type"::"Payment Discount (VAT Excl.)":
                    BEGIN
                        TESTFIELD("Gen. Prod. Posting Group");
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                    END;
                "Entry Type"::"Appln. Rounding":
                    EXIT(CustPostingGr.GetApplRoundingAccount(AmountCondition));
                "Entry Type"::"Correction of Remaining Amount":
                    EXIT(CustPostingGr.GetRoundingAccount(AmountCondition));
                "Entry Type"::"Payment Discount Tolerance":
                    CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                    END;
                "Entry Type"::"Payment Tolerance":
                    CASE GLSetup."Payment Tolerance Posting" OF
                        GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                        GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                    END;
                "Entry Type"::"Payment Tolerance (VAT Excl.)":
                    BEGIN
                        TESTFIELD("Gen. Prod. Posting Group");
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        CASE GLSetup."Payment Tolerance Posting" OF
                            GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                                EXIT(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                            GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                                EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                        END;
                    END;
                "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                    BEGIN
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                            GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                                EXIT(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                            GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                                EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                        END;
                    END;
                "Entry Type"::"Payment Discount (VAT Adjustment)",
              "Entry Type"::"Payment Tolerance (VAT Adjustment)",
              "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                    IF Unapply THEN
                        PostDtldCustVATAdjustment(GenJnlLine, DtldCVLedgEntryBuf, OriginalTransactionNo);
                ELSE
                    FIELDERROR("Entry Type");
            END;
        END;
    END;

    LOCAL PROCEDURE CustUnrealizedVAT(GenJnlLine: Record 81; VAR CustLedgEntry2: Record 21; SettledAmount: Decimal);
    VAR
        VATEntry2: Record 254;
        TaxJurisdiction: Record 320;
        VATPostingSetup: Record 325;
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        SalesVATAccount: Code[20];
        SalesVATUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        Doc: Record 7000002;
        ClosedDoc: Record 7000004;
        PostedDoc: Record 7000003;
        FromDocInPostedBillGr: Boolean;
        FromDoc: Boolean;
        CustLedgEntry3: Record 21;
        CustLedgEntry4: Record 21;
        FromJnl: Boolean;
        GLEntryNo: Integer;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCustUnrealizedVAT(GenJnlLine, CustLedgEntry2, SettledAmount, IsHandled);
        IF IsHandled THEN
            EXIT;

        CustLedgEntry4.COPY(CustLedgEntry2);

        FromDoc := FALSE;
        FromDocInPostedBillGr := FALSE;

        Doc.SETCURRENTKEY(Type, "Document No.");
        Doc.SETRANGE(Type, Doc.Type::Receivable);
        Doc.SETRANGE("Document No.", CustLedgEntry4."Document No.");
        ClosedDoc.SETCURRENTKEY(Type, "Document No.");
        ClosedDoc.SETRANGE(Type, ClosedDoc.Type::Receivable);
        ClosedDoc.SETRANGE("Document No.", CustLedgEntry4."Document No.");
        ClosedDoc.SETRANGE("No.", CustLedgEntry4."Bill No.");
        PostedDoc.SETCURRENTKEY(Type, "Document No.");
        PostedDoc.SETRANGE(Type, PostedDoc.Type::Receivable);
        PostedDoc.SETRANGE("Document No.", CustLedgEntry4."Document No.");
        PostedDoc.SETRANGE("No.", CustLedgEntry4."Bill No.");
        FromDoc := (Doc.FINDFIRST AND (NOT ClosedDoc.FINDFIRST));
        FromDocInPostedBillGr := PostedDoc.FINDFIRST;

        PaidAmount := CustLedgEntry2."Amount (LCY)" - CustLedgEntry2."Remaining Amt. (LCY)";
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", CustLedgEntry2."Transaction No.");
        IF CustLedgEntry4."Document Type" = CustLedgEntry4."Document Type"::Bill THEN BEGIN
            FromJnl := FALSE;
            IF Doc."From Journal" OR PostedDoc."From Journal" OR ClosedDoc."From Journal" THEN
                FromJnl := TRUE;
            CustFindVATSetup(VATPostingSetup, CustLedgEntry4, FromJnl);
            IF (VATPostingSetup."Unrealized VAT Type" > VATPostingSetup."Unrealized VAT Type"::Percentage) AND
               (NOT FromDocInPostedBillGr)
            THEN
                ERROR(Text1100000);
            CustLedgEntry3.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            CustLedgEntry3.SETRANGE("Document Type", CustLedgEntry3."Document Type"::Invoice);
            CustLedgEntry3.SETRANGE("Document No.", CustLedgEntry4."Document No.");
            FromDoc := FALSE;
            IF CustLedgEntry3.FINDFIRST THEN BEGIN
                CustLedgEntry3.CALCFIELDS("Original Amt. (LCY)");
                CustLedgEntry2.Open := TRUE;
                VATEntry2.SETRANGE("Transaction No.", CustLedgEntry3."Transaction No.");
                VATEntry2.SETRANGE("Document No.", CustLedgEntry3."Document No.");
            END ELSE
                ERROR(Text1100001, CustLedgEntry3."Document No.");
        END ELSE BEGIN
            VATEntry2.SETRANGE("Transaction No.", CustLedgEntry4."Transaction No.");
            VATEntry2.SETRANGE("Document No.", CustLedgEntry4."Document No.");
        END;
        IF VATEntry2.FINDSET THEN
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::Last, VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::First, VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
            UNTIL VATEntry2.NEXT = 0;
        IF VATEntry2.FINDSET AND (NOT FromDocInPostedBillGr) THEN BEGIN
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                    InsertSummarizedVAT(GenJnlLine);
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                END;
                VATEntry2.SetBillDoc(IsCustBillDoc(CustLedgEntry4));

                VATPart :=
                  VATEntry2.GetUnrealizedVATPart(
                    GetCustSettledAmount(SettledAmount, CustLedgEntry4, CustLedgEntry3, CustLedgEntry2),
                    PaidAmount,
                    GetCustOriginalAmtLCY(CustLedgEntry4, CustLedgEntry3, CustLedgEntry2),
                    TotalUnrealVATAmountFirst,
                    TotalUnrealVATAmountLast);


                QBCodeunitPublisher.CheckRemainingUnrealizedVATGenJnlPostLine(VATPostingSetup, VATEntry2, VATPart, CustLedgEntry2."Document No.");

                OnCustUnrealizedVATOnAfterVATPartCalculation(
                  GenJnlLine, CustLedgEntry2, PaidAmount, TotalUnrealVATAmountFirst, TotalUnrealVATAmountLast, SettledAmount, VATEntry2);

                IF VATPart > 0 THEN BEGIN
                    CASE VATEntry2."VAT Calculation Type" OF
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
                        VATEntry2."VAT Calculation Type"::"Full VAT":
                            BEGIN
                                SalesVATAccount := VATPostingSetup.GetSalesAccount(FALSE);
                                SalesVATUnrealAccount := VATPostingSetup.GetSalesAccount(TRUE);
                            END;
                        VATEntry2."VAT Calculation Type"::"Sales Tax":
                            BEGIN
                                TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                                SalesVATAccount := TaxJurisdiction.GetSalesAccount(FALSE);
                                SalesVATUnrealAccount := TaxJurisdiction.GetSalesAccount(TRUE);
                            END;
                    END;

                    IF VATPart = 1 THEN BEGIN
                        VATAmount := VATEntry2."Remaining Unrealized Amount";
                        VATBase := VATEntry2."Remaining Unrealized Base";
                        VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                        VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                    END ELSE BEGIN
                        VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart, GLSetup."Amount Rounding Precision");
                        VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart, GLSetup."Amount Rounding Precision");
                        VATAmountAddCurr :=
                          ROUND(
                            VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                        VATBaseAddCurr :=
                          ROUND(
                            VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                    END;

                    OnCustUnrealizedVATOnBeforeInitGLEntryVAT(GenJnlLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr);

                    InitGLEntryVAT(
                      GenJnlLine, SalesVATUnrealAccount, SalesVATAccount, -VATAmount, -VATAmountAddCurr, FALSE);
                    GLEntryNo :=
                      InitGLEntryVATCopy(GenJnlLine, SalesVATAccount, SalesVATUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);

                    PostUnrealVATEntry(GenJnlLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr, GLEntryNo);
                END;
            UNTIL VATEntry2.NEXT = 0;

            InsertSummarizedVAT(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE ApplyVendLedgEntry(VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; Vend: Record 23);
    VAR
        OldVendLedgEntry: Record 25;
        OldCVLedgEntryBuf: Record 382;
        NewVendLedgEntry: Record 25;
        NewCVLedgEntryBuf2: Record 382;
        TempOldVendLedgEntry: Record 25 TEMPORARY;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
        InvVendLedgEntry: Record 25;
    BEGIN
        OnBeforeApplyVendLedgEntry(NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, Vend);

        IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
            EXIT;

        AllApplied := TRUE;
        IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
           NOT
           ((Vend."Application Method" = Vend."Application Method"::"Apply to Oldest") AND
            GenJnlLine."Allow Application")
        THEN
            EXIT;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        IF NOT PrepareTempVendLedgEntry(GenJnlLine, NewCVLedgEntryBuf, TempOldVendLedgEntry, Vend, ApplyingDate) THEN
            EXIT;

        IF GenJnlLine."Applies-to ID" = '' THEN
            AppliesToDocType := TempOldVendLedgEntry."Document Type".AsInteger();

        IF OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::Bill THEN BEGIN
            InvVendLedgEntry.SETRANGE("Document Type", OldVendLedgEntry."Document Type"::Invoice);
            InvVendLedgEntry.SETRANGE("Document No.", OldVendLedgEntry."Document No.");
            InvVendLedgEntry.SETRANGE("Vendor No.", OldVendLedgEntry."Vendor No.");
            IF NOT InvVendLedgEntry.FINDFIRST THEN
                ERROR(Text1100001, OldVendLedgEntry."Document No.");
        END;
        GenJnlLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        REPEAT
            TempOldVendLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            OldCVLedgEntryBuf.CopyFromVendLedgEntry(TempOldVendLedgEntry);
            TempOldVendLedgEntry.COPYFILTER(Positive, OldCVLedgEntryBuf.Positive);

            IF Vend."Application Method" = Vend."Application Method"::"Apply to Oldest" THEN
                IF Doc.GET(Doc.Type::Payable, OldCVLedgEntryBuf."Entry No.") THEN
                    IF Doc."Bill Gr./Pmt. Order No." <> '' THEN
                        ERROR(
                          Text1100009 +
                          Text1100010,
                          OldCVLedgEntryBuf.Description);

            PostApply(
              GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2,
              Vend."Block Payment Tolerance", AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            // Update the Old Entry
            TempOldVendLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
            OldVendLedgEntry := TempOldVendLedgEntry;

            IF (OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::Bill) OR
               (OldVendLedgEntry."Document Situation".AsInteger() <> 0)
            THEN BEGIN
                IF (OldVendLedgEntry."Document Situation" IN [
                                                              OldVendLedgEntry."Document Situation"::"Closed Documents",
                                                              OldVendLedgEntry."Document Situation"::"Closed BG/PO"])
                THEN
                    FromClosedDoc := TRUE
                ELSE
                    FromClosedDoc := FALSE;

                DocPost.UpdatePayableDoc(
                  OldVendLedgEntry, GenJnlLine, DocAmountLCY, AppliedAmountLCY2 + DeltaUnrealAmount + DeltaAmountLCY,
                  DocLock, CollDocAmountLCY);
            END;

            OldVendLedgEntry."Applies-to ID" := '';
            OldVendLedgEntry."Amount to Apply" := 0;
            OldVendLedgEntry.MODIFY;

            OnAfterOldVendLedgEntryModify(OldVendLedgEntry);

            IF GLSetup."Unrealized VAT" OR
               (GLSetup."Prepayment Unrealized VAT" AND TempOldVendLedgEntry.Prepayment)
            THEN
                IF (IsNotPayment(TempOldVendLedgEntry."Document Type") OR //enum to option
                    (TempOldVendLedgEntry."Document Type" = TempOldVendLedgEntry."Document Type"::Bill)) AND
                   (NewCVLedgEntryBuf."Document Type".AsInteger() <> 0) AND
                   (NOT (TempOldVendLedgEntry."Document Status" = TempOldVendLedgEntry."Document Status"::Redrawn)) AND
                   (NOT FromClosedDoc)
                THEN BEGIN
                    TempOldVendLedgEntry.RecalculateAmounts(
                      NewCVLedgEntryBuf."Currency Code", TempOldVendLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    VendUnrealizedVAT(
                      GenJnlLine,
                      TempOldVendLedgEntry,
                      CurrExchRate.ExchangeAmount(
                        AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                        TempOldVendLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date"));
                END;

            TempOldVendLedgEntry.DELETE;

            // Find the next old entry to apply to the new entry
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN
                Completed := TRUE
            ELSE
                IF TempOldVendLedgEntry.GETFILTER(Positive) <> '' THEN
                    IF TempOldVendLedgEntry.NEXT = 1 THEN
                        Completed := FALSE
                    ELSE BEGIN
                        TempOldVendLedgEntry.SETRANGE(Positive);
                        TempOldVendLedgEntry.FIND('-');
                        TempOldVendLedgEntry.CALCFIELDS("Remaining Amount");
                        Completed := TempOldVendLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
                    END
                ELSE
                    IF NewCVLedgEntryBuf.Open THEN
                        Completed := TempOldVendLedgEntry.NEXT = 0
                    ELSE
                        Completed := TRUE;
        UNTIL Completed;

        DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.", "Entry Type");
        DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.", NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SETRANGE(
          "Entry Type",
          DtldCVLedgEntryBuf."Entry Type"::Application);
        DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)", Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, DtldCVLedgEntryBuf.Amount, NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;

        IF (NewVendLedgEntry."Document Type" = NewVendLedgEntry."Document Type"::Bill) OR
           (NewVendLedgEntry."Document Situation".AsInteger() <> 0)
        THEN BEGIN
            FromClosedDoc :=
              NewVendLedgEntry."Document Situation" IN [NewVendLedgEntry."Document Situation"::"Closed Documents",
                                                        NewVendLedgEntry."Document Situation"::"Closed BG/PO"];
            DocPost.UpdatePayableDoc(
              NewVendLedgEntry, GenJnlLine, DocAmountLCY, AppliedAmountLCY2 + DeltaUnrealAmount + DeltaAmountLCY,
              DocLock, CollDocAmountLCY);
        END;

        //Esto sobra, hay que eliminarlo
        //++IF GenJnlLine."Withholding Group" = '' THEN  //QB
        //++  EXIT;                                      //QB

        IF GLSetup."Unrealized VAT" OR
           (GLSetup."Prepayment Unrealized VAT" AND NewCVLedgEntryBuf.Prepayment)
        THEN
            IF (IsNotPayment(NewCVLedgEntryBuf."Document Type") OR //enum to option
                (NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."Document Type"::Bill)) AND
               (NOT (NewVendLedgEntry."Document Status" = NewVendLedgEntry."Document Status"::Redrawn)) AND
               (NOT FromClosedDoc) AND
               (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
            THEN BEGIN
                NewVendLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
                CheckUnrealizedVend := TRUE;
                UnrealizedVendLedgEntry := NewVendLedgEntry;
                UnrealizedVendLedgEntry.CALCFIELDS("Amount (LCY)", "Original Amt. (LCY)");
                UnrealizedRemainingAmountVend := -(NewRemainingAmtBeforeAppln - NewVendLedgEntry."Remaining Amount");
            END;
    END;

    LOCAL PROCEDURE ApplyEmplLedgEntry(VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; GenJnlLine: Record 81; Employee: Record 5200);
    VAR
        OldEmplLedgEntry: Record 5222;
        OldCVLedgEntryBuf: Record 382;
        NewCVLedgEntryBuf2: Record 382;
        TempOldEmplLedgEntry: Record 5222 TEMPORARY;
        Completed: Boolean;
        AppliedAmount: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
    BEGIN
        IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
            EXIT;

        AllApplied := TRUE;
        IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
           NOT
           ((Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") AND
            GenJnlLine."Allow Application")
        THEN
            EXIT;

        PmtTolAmtToBeApplied := 0;
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        IF NOT PrepareTempEmplLedgEntry(GenJnlLine, NewCVLedgEntryBuf, TempOldEmplLedgEntry, Employee, ApplyingDate) THEN
            EXIT;

        GenJnlLine."Posting Date" := ApplyingDate;

        // Apply the new entry (Payment) to the old entries one at a time
        REPEAT
            TempOldEmplLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            OldCVLedgEntryBuf.CopyFromEmplLedgEntry(TempOldEmplLedgEntry);
            TempOldEmplLedgEntry.COPYFILTER(Positive, OldCVLedgEntryBuf.Positive);

            PostApply(
              GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2,
              TRUE, AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            // Update the Old Entry
            TempOldEmplLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
            OldEmplLedgEntry := TempOldEmplLedgEntry;
            OldEmplLedgEntry."Applies-to ID" := '';
            OldEmplLedgEntry."Amount to Apply" := 0;
            OldEmplLedgEntry.MODIFY;

            TempOldEmplLedgEntry.DELETE;

            // Find the next old entry to apply to the new entry
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN
                Completed := TRUE
            ELSE
                IF TempOldEmplLedgEntry.GETFILTER(Positive) <> '' THEN
                    IF TempOldEmplLedgEntry.NEXT = 1 THEN
                        Completed := FALSE
                    ELSE BEGIN
                        TempOldEmplLedgEntry.SETRANGE(Positive);
                        TempOldEmplLedgEntry.FIND('-');
                        TempOldEmplLedgEntry.CALCFIELDS("Remaining Amount");
                        Completed := TempOldEmplLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
                    END
                ELSE
                    IF NewCVLedgEntryBuf.Open THEN
                        Completed := TempOldEmplLedgEntry.NEXT = 0
                    ELSE
                        Completed := TRUE;
        UNTIL Completed;

        DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.", "Entry Type");
        DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.", NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SETRANGE(
          "Entry Type",
          DtldCVLedgEntryBuf."Entry Type"::Application);
        DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)", Amount);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;
    END;

    //[External]
    PROCEDURE VendPostApplyVendLedgEntry(VAR GenJnlLinePostApply: Record 81; VAR VendLedgEntryPostApply: Record 25);
    VAR
        Vend: Record 23;
        VendPostingGr: Record 93;
        VendLedgEntry: Record 25;
        DtldVendLedgEntry: Record 380;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        CVLedgEntryBuf: Record 382;
        GenJnlLine: Record 81;
        DtldLedgEntryInserted: Boolean;
    BEGIN
        GenJnlLine := GenJnlLinePostApply;
        VendLedgEntry.TRANSFERFIELDS(VendLedgEntryPostApply);
        WITH GenJnlLine DO BEGIN
            "Source Currency Code" := VendLedgEntryPostApply."Currency Code";
            "Applies-to ID" := VendLedgEntryPostApply."Applies-to ID";

            GenJnlCheckLine.RunCheck(GenJnlLine);

            IF NextEntryNo = 0 THEN
                StartPosting(GenJnlLine)
            ELSE
                ContinuePosting(GenJnlLine);

            Vend.GET(VendLedgEntry."Vendor No.");
            Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);

            OnVendPostApplyVendLedgEntryOnBeforeCheckPostingGroup(GenJnlLine, Vend);
            IF "Posting Group" = '' THEN BEGIN
                Vend.TESTFIELD("Vendor Posting Group");
                "Posting Group" := Vend."Vendor Posting Group";
            END;
            VendPostingGr.GET("Posting Group");
            VendPostingGr.GetPayablesAccount;

            DtldVendLedgEntry.LOCKTABLE;
            VendLedgEntry.LOCKTABLE;

            // Post the application
            VendLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
            ApplyVendLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Vend);
            VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
            VendLedgEntry.MODIFY(TRUE);

            // Post Dtld vendor entry
            DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, VendPostingGr, FALSE);

            CheckPostUnrealizedVAT(GenJnlLine, TRUE);

            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
            GenJnlLineQB := GenJnlLine;//QB

            FinishPosting(GenJnlLine);
        END;
    END;

    //[External]
    PROCEDURE EmplPostApplyEmplLedgEntry(VAR GenJnlLinePostApply: Record 81; VAR EmplLedgEntryPostApply: Record 5222);
    VAR
        Empl: Record 5200;
        EmplPostingGr: Record 5221;
        EmplLedgEntry: Record 5222;
        DtldEmplLedgEntry: Record 5223;
        TempDtldCVLedgEntryBuf: Record 383 TEMPORARY;
        CVLedgEntryBuf: Record 382;
        GenJnlLine: Record 81;
        DtldLedgEntryInserted: Boolean;
    BEGIN
        GenJnlLine := GenJnlLinePostApply;
        EmplLedgEntry.TRANSFERFIELDS(EmplLedgEntryPostApply);
        WITH GenJnlLine DO BEGIN
            "Source Currency Code" := EmplLedgEntryPostApply."Currency Code";
            "Applies-to ID" := EmplLedgEntryPostApply."Applies-to ID";

            GenJnlCheckLine.RunCheck(GenJnlLine);

            IF NextEntryNo = 0 THEN
                StartPosting(GenJnlLine)
            ELSE
                ContinuePosting(GenJnlLine);

            Empl.GET(EmplLedgEntry."Employee No.");

            IF "Posting Group" = '' THEN BEGIN
                Empl.TESTFIELD("Employee Posting Group");
                "Posting Group" := Empl."Employee Posting Group";
            END;
            EmplPostingGr.GET("Posting Group");
            EmplPostingGr.GetPayablesAccount;

            DtldEmplLedgEntry.LOCKTABLE;
            EmplLedgEntry.LOCKTABLE;

            // Post the application
            EmplLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            CVLedgEntryBuf.CopyFromEmplLedgEntry(EmplLedgEntry);
            ApplyEmplLedgEntry(
              CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Empl);
            EmplLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
            EmplLedgEntry.MODIFY(TRUE);

            // Post Dtld vendor entry
            DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, EmplPostingGr, FALSE);

            CheckPostUnrealizedVAT(GenJnlLine, TRUE);

            IF DtldLedgEntryInserted THEN
                IF IsTempGLEntryBufEmpty THEN
                    DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);

            FinishPosting(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE PrepareTempVendLedgEntry(VAR GenJnlLine: Record 81; VAR NewCVLedgEntryBuf: Record 382; VAR TempOldVendLedgEntry: Record 25 TEMPORARY; Vend: Record 23; VAR ApplyingDate: Date): Boolean;
    VAR
        OldVendLedgEntry: Record 25;
        PurchSetup: Record 312;
        GenJnlApply: Codeunit 225;
        RemainingAmount: Decimal;
    BEGIN
        OnBeforePrepareTempVendLedgEntry(GenJnlLine, NewCVLedgEntryBuf);

        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find the entry to be applied to
            OldVendLedgEntry.RESET;
            OldVendLedgEntry.SETCURRENTKEY("Document No.");
            OldVendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            // OldVendLedgEntry.SETRANGE("Bill No.", NewCVLedgEntryBuf."Applies-to Bill No.");
            OldVendLedgEntry.SETRANGE("Vendor No.", NewCVLedgEntryBuf."CV No.");
            OldVendLedgEntry.SETRANGE(Open, TRUE);
            OldVendLedgEntry.FINDFIRST;
            CheckCarteraAccessPermissions(OldVendLedgEntry."Document Situation");
            OldVendLedgEntry.TESTFIELD(Positive, NOT NewCVLedgEntryBuf.Positive);
            DocPost.CheckAppliedPayableDoc(OldVendLedgEntry, GenJnlLine."System-Created Entry");
            IF OldVendLedgEntry."Posting Date" > ApplyingDate THEN
                ApplyingDate := OldVendLedgEntry."Posting Date";
            GenJnlApply.CheckAgainstApplnCurrency(
              NewCVLedgEntryBuf."Currency Code", OldVendLedgEntry."Currency Code", GenJnlLine."Account Type"::Vendor, TRUE);
            TempOldVendLedgEntry := OldVendLedgEntry;
            OnPrepareTempVendLedgEntryOnBeforeTempOldVendLedgEntryInsert(TempOldVendLedgEntry, GenJnlLine);
            TempOldVendLedgEntry.INSERT;
        END ELSE BEGIN
            // Find the first old entry (Invoice) which the new entry (Payment) should apply to
            OldVendLedgEntry.RESET;
            OldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
            TempOldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
            OldVendLedgEntry.SETRANGE("Vendor No.", NewCVLedgEntryBuf."CV No.");
            OldVendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            OldVendLedgEntry.SETRANGE(Open, TRUE);
            OldVendLedgEntry.SETFILTER("Document Situation", '<>%1', OldVendLedgEntry."Document Situation"::"Posted BG/PO");
            OldVendLedgEntry.SETFILTER("Entry No.", '<>%1', NewCVLedgEntryBuf."Entry No.");
            IF NOT (Vend."Application Method" = Vend."Application Method"::"Apply to Oldest") THEN
                OldVendLedgEntry.SETFILTER("Amount to Apply", '<>%1', 0);

            IF Vend."Application Method" = Vend."Application Method"::"Apply to Oldest" THEN
                OldVendLedgEntry.SETFILTER("Posting Date", '..%1', GenJnlLine."Posting Date");

            // Check and Move Ledger Entries to Temp
            PurchSetup.GET;
            IF PurchSetup."Appln. between Currencies" = PurchSetup."Appln. between Currencies"::None THEN
                OldVendLedgEntry.SETRANGE("Currency Code", NewCVLedgEntryBuf."Currency Code");
            IF OldVendLedgEntry.FINDSET(FALSE) THEN
                REPEAT
                    CheckCarteraAccessPermissions(OldVendLedgEntry."Document Situation");
                    IF GenJnlApply.CheckAgainstApplnCurrency(
                         NewCVLedgEntryBuf."Currency Code", OldVendLedgEntry."Currency Code", GenJnlLine."Account Type"::Vendor, FALSE)
                    THEN BEGIN
                        IF (OldVendLedgEntry."Posting Date" > ApplyingDate) AND (OldVendLedgEntry."Applies-to ID" <> '') THEN
                            ApplyingDate := OldVendLedgEntry."Posting Date";
                        TempOldVendLedgEntry := OldVendLedgEntry;
                        OnPrepareTempVendLedgEntryOnBeforeTempOldVendLedgEntryInsert(TempOldVendLedgEntry, GenJnlLine);
                        TempOldVendLedgEntry.INSERT;
                    END;
                UNTIL OldVendLedgEntry.NEXT = 0;

            TempOldVendLedgEntry.SETRANGE(Positive, NewCVLedgEntryBuf."Remaining Amount" > 0);

            IF TempOldVendLedgEntry.FIND('-') THEN BEGIN
                RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
                TempOldVendLedgEntry.SETRANGE(Positive);
                TempOldVendLedgEntry.FIND('-');
                REPEAT
                    TempOldVendLedgEntry.CALCFIELDS("Remaining Amount");
                    TempOldVendLedgEntry.RecalculateAmounts(
                      TempOldVendLedgEntry."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    IF PaymentToleranceMgt.CheckCalcPmtDiscCVVend(NewCVLedgEntryBuf, TempOldVendLedgEntry, 0, FALSE, FALSE) THEN
                        TempOldVendLedgEntry."Remaining Amount" -= TempOldVendLedgEntry."Remaining Pmt. Disc. Possible";
                    RemainingAmount += TempOldVendLedgEntry."Remaining Amount";
                UNTIL TempOldVendLedgEntry.NEXT = 0;
                TempOldVendLedgEntry.SETRANGE(Positive, RemainingAmount < 0);
            END ELSE
                TempOldVendLedgEntry.SETRANGE(Positive);

            OnPrepareTempVendLedgEntryOnBeforeExit(GenJnlLine, NewCVLedgEntryBuf, TempOldVendLedgEntry);
            EXIT(TempOldVendLedgEntry.FIND('-'));
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE PrepareTempEmplLedgEntry(GenJnlLine: Record 81; VAR NewCVLedgEntryBuf: Record 382; VAR TempOldEmplLedgEntry: Record 5222 TEMPORARY; Employee: Record 5200; VAR ApplyingDate: Date): Boolean;
    VAR
        OldEmplLedgEntry: Record 5222;
        RemainingAmount: Decimal;
    BEGIN
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find the entry to be applied to
            OldEmplLedgEntry.RESET;
            OldEmplLedgEntry.SETCURRENTKEY("Document No.");
            OldEmplLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            OldEmplLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            OldEmplLedgEntry.SETRANGE("Employee No.", NewCVLedgEntryBuf."CV No.");
            OldEmplLedgEntry.SETRANGE(Open, TRUE);
            OldEmplLedgEntry.FINDFIRST;
            OldEmplLedgEntry.TESTFIELD(Positive, NOT NewCVLedgEntryBuf.Positive);
            IF OldEmplLedgEntry."Posting Date" > ApplyingDate THEN
                ApplyingDate := OldEmplLedgEntry."Posting Date";
            TempOldEmplLedgEntry := OldEmplLedgEntry;
            TempOldEmplLedgEntry.INSERT;
        END ELSE BEGIN
            // Find the first old entry which the new entry (Payment) should apply to
            OldEmplLedgEntry.RESET;
            OldEmplLedgEntry.SETCURRENTKEY("Employee No.", "Applies-to ID", Open, Positive);
            TempOldEmplLedgEntry.SETCURRENTKEY("Employee No.", "Applies-to ID", Open, Positive);
            OldEmplLedgEntry.SETRANGE("Employee No.", NewCVLedgEntryBuf."CV No.");
            OldEmplLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            OldEmplLedgEntry.SETRANGE(Open, TRUE);
            OldEmplLedgEntry.SETFILTER("Entry No.", '<>%1', NewCVLedgEntryBuf."Entry No.");
            IF NOT (Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") THEN
                OldEmplLedgEntry.SETFILTER("Amount to Apply", '<>%1', 0);

            IF Employee."Application Method" = Employee."Application Method"::"Apply to Oldest" THEN
                OldEmplLedgEntry.SETFILTER("Posting Date", '..%1', GenJnlLine."Posting Date");

            OldEmplLedgEntry.SETRANGE("Currency Code", NewCVLedgEntryBuf."Currency Code");
            IF OldEmplLedgEntry.FINDSET(FALSE) THEN
                REPEAT
                    IF (OldEmplLedgEntry."Posting Date" > ApplyingDate) AND (OldEmplLedgEntry."Applies-to ID" <> '') THEN
                        ApplyingDate := OldEmplLedgEntry."Posting Date";
                    TempOldEmplLedgEntry := OldEmplLedgEntry;
                    TempOldEmplLedgEntry.INSERT;
                UNTIL OldEmplLedgEntry.NEXT = 0;

            TempOldEmplLedgEntry.SETRANGE(Positive, NewCVLedgEntryBuf."Remaining Amount" > 0);

            IF TempOldEmplLedgEntry.FIND('-') THEN BEGIN
                RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
                TempOldEmplLedgEntry.SETRANGE(Positive);
                TempOldEmplLedgEntry.FIND('-');
                REPEAT
                    TempOldEmplLedgEntry.CALCFIELDS("Remaining Amount");
                    RemainingAmount += TempOldEmplLedgEntry."Remaining Amount";
                UNTIL TempOldEmplLedgEntry.NEXT = 0;
                TempOldEmplLedgEntry.SETRANGE(Positive, RemainingAmount < 0);
            END ELSE
                TempOldEmplLedgEntry.SETRANGE(Positive);
            EXIT(TempOldEmplLedgEntry.FIND('-'));
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntries(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VendPostingGr: Record 93; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean;
    VAR
        TempInvPostBuf: Record 49 TEMPORARY;
        DtldVendLedgEntry: Record 380;
        Currency: Record 4;
        GLEntry: Record 17;
        DtldVendLedgEntry2: Record 380;
        AdjAmount: ARRAY[4] OF Decimal;
        DtldVendLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
        PayableAccAmtLCY: Decimal;
        PayableAccAmtAddCurr: Decimal;
        ExistDtldCVLedgEntryBuf: Boolean;
        FindBill: Boolean;
    BEGIN
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor THEN
            EXIT;

        IF DtldVendLedgEntry.FINDLAST THEN
            DtldVendLedgEntryNoOffset := DtldVendLedgEntry."Entry No."
        ELSE
            DtldVendLedgEntryNoOffset := 0;
        DtldCVLedgEntryBuf.RESET;
        DtldCVLedgEntryBuf.SETRANGE("Initial Document Type", DtldCVLedgEntryBuf."Initial Document Type"::Bill);
        IF DtldCVLedgEntryBuf.FINDFIRST THEN
            FindBill := TRUE;

        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted OR FindBill THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
                NextEntryNo2 := NextEntryNo;
            END;
            REPEAT
                InsertDtldVendLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldVendLedgEntry, DtldVendLedgEntryNoOffset);
                UpdateVendLedgEntryStats(DtldVendLedgEntry."Vendor Ledger Entry No.");
                UpdateTotalAmounts(TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf);
                IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
                    (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
                   ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
                THEN
                    CASE DtldCVLedgEntryBuf."Entry Type" OF
                        DtldCVLedgEntryBuf."Entry Type"::Application:
                            IF CheckCarteraPostDtldVendLE(
                                 GenJnlLine, DtldVendLedgEntry, PayableAccAmtLCY, PayableAccAmtAddCurr, FALSE)
                            THEN BEGIN
                                GetCurrency(Currency, DtldCVLedgEntryBuf."Currency Code");
                                CheckNonAddCurrCodeOccurred(Currency.Code);
                                CreateGLEntry(GenJnlLine,
                                  VendPostingGr.GetPayablesAccount, -DtldCVLedgEntryBuf."Amount (LCY)", 0,
                                  DtldCVLedgEntryBuf."Currency Code" = AddCurrencyCode);
                            END;
                        ELSE
                            PostDtldVendLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, AdjAmount);
                    END;
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;

            ExistDtldCVLedgEntryBuf := NOT DtldCVLedgEntryBuf.ISEMPTY;
            DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
            DtldCVLedgEntryBuf.DELETEALL;

            IF UseGLBillsAccount(GenJnlLine) THEN BEGIN
                VendPostingGr.TESTFIELD("Bills Account");
                AccNo := VendPostingGr."Bills Account";
            END ELSE BEGIN
                VendPostingGr.TESTFIELD("Payables Account");
                AccNo := VendPostingGr."Payables Account";
            END;
            IF CollDocAmountLCY <> 0 THEN
                CASE GenJnlLine."Applies-to Doc. Type" OF
                    GenJnlLine."Applies-to Doc. Type"::Bill:
                        AccNo := VendPostingGr.GetBillsInPmtOrderAccount;
                    GenJnlLine."Applies-to Doc. Type"::Invoice:
                        AccNo := VendPostingGr.GetInvoicesInPmtOrderAccount;
                END;

            //JAV 04/04/22: - QB 1.10.31 Cambiar cuenta del confirming para la recirculaci�n de efectos
            //EPV 07/04/22: Se utiliza la cuenta de confirming si se recircula una factura o si se trata de un pago.
            //              Una factura que no se lleve a una Orden de pago (Confirming) no deber�a tener forma de pago con tipo "Confirming Proveedor".
            IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice) AND (GenJnlLine."QB Redrawing")) OR
               (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) THEN
                //EPV 07/04/22 --> Fin.
                QBTableSubscriber.T93_ChangeVendorConfirmingAccount(GenJnlLine."Payment Method Code", VendPostingGr.Code, AccNo);
            //fin QB 1.10.31

            CalcInvPostBufferTotals(TempInvPostBuf);
            PayableAccAmtLCY := TempInvPostBuf.Amount - (DocAmountLCY + CollDocAmountLCY);
            PayableAccAmtAddCurr :=
              TempInvPostBuf."Amount (ACY)" -
              (DocAmtCalcAddCurrency(GenJnlLine, DocAmountLCY) + DocAmtCalcAddCurrency(GenJnlLine, CollDocAmountLCY));
            VendLedgEntryInserted2 := LedgEntryInserted;
            IF CheckCarteraPostDtldVendLE(GenJnlLine, DtldVendLedgEntry2, PayableAccAmtLCY, PayableAccAmtAddCurr, FALSE) THEN
                IF (TempInvPostBuf.Amount <> 0) OR ((TempInvPostBuf."Amount (ACY)" <> 0) AND (AddCurrencyCode <> '')) OR
                   (GenJnlLine."Applies-to ID" <> '')
                THEN
                    IF (PayableAccAmtLCY <> 0) OR
                       ((PayableAccAmtAddCurr <> 0) AND (AddCurrencyCode <> ''))
                    THEN BEGIN
                        InitGLEntry(GenJnlLine, GLEntry,
                          AccNo, PayableAccAmtLCY, PayableAccAmtAddCurr,
                          TRUE, TRUE);
                        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
                        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
                        UpdateGLEntryNo(GLEntry."Entry No.", SaveEntryNo);
                        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
                    END;
        END;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine, TempInvPostBuf, AdjAmount, SaveEntryNo, VendPostingGr.GetPayablesAccount);

        PostPayableDocs(GenJnlLine, VendPostingGr);

        DtldCVLedgEntryBuf.DELETEALL;
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VendPostingGr: Record 93; VAR AdjAmount: ARRAY[4] OF Decimal);
    VAR
        AccNo: Code[20];
    BEGIN
        AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, 0, FALSE);
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, FALSE);
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntryUnapply(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VendPostingGr: Record 93; OriginalTransactionNo: Integer);
    VAR
        AccNo: Code[20];
        AdjAmount: ARRAY[4] OF Decimal;
    BEGIN
        IF (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
           (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
           ((AddCurrencyCode = '') OR (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
        THEN
            EXIT;

        AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, OriginalTransactionNo, TRUE);
        DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."Gen. Posting Type"::Purchase;
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, TRUE);
    END;

    LOCAL PROCEDURE GetDtldVendLedgEntryAccNo(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; VendPostingGr: Record 93; OriginalTransactionNo: Integer; Unapply: Boolean): Code[20];
    VAR
        Currency: Record 4;
        GenPostingSetup: Record 252;
        AmountCondition: Boolean;
    BEGIN
        WITH DtldCVLedgEntryBuf DO BEGIN
            AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf, Unapply);
            CASE "Entry Type" OF
                "Entry Type"::"Initial Entry":
                    ;
                "Entry Type"::Application:
                    ;
                "Entry Type"::"Unrealized Loss",
                "Entry Type"::"Unrealized Gain",
                "Entry Type"::"Realized Loss",
                "Entry Type"::"Realized Gain":
                    BEGIN
                        GetCurrency(Currency, "Currency Code");
                        CheckNonAddCurrCodeOccurred(Currency.Code);
                        EXIT(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
                    END;
                "Entry Type"::"Payment Discount":
                    EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
                "Entry Type"::"Payment Discount (VAT Excl.)":
                    BEGIN
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                    END;
                "Entry Type"::"Appln. Rounding":
                    EXIT(VendPostingGr.GetApplRoundingAccount(AmountCondition));
                "Entry Type"::"Correction of Remaining Amount":
                    EXIT(VendPostingGr.GetRoundingAccount(AmountCondition));
                "Entry Type"::"Payment Discount Tolerance":
                    CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
                    END;
                "Entry Type"::"Payment Tolerance":
                    CASE GLSetup."Payment Tolerance Posting" OF
                        GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
                        GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
                    END;
                "Entry Type"::"Payment Tolerance (VAT Excl.)":
                    BEGIN
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        CASE GLSetup."Payment Tolerance Posting" OF
                            GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                                EXIT(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                            GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                                EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                        END;
                    END;
                "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                    BEGIN
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                            GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                                EXIT(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                            GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                                EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                        END;
                    END;
                "Entry Type"::"Payment Discount (VAT Adjustment)",
              "Entry Type"::"Payment Tolerance (VAT Adjustment)",
              "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                    IF Unapply THEN
                        PostDtldVendVATAdjustment(GenJnlLine, DtldCVLedgEntryBuf, OriginalTransactionNo);
                ELSE
                    FIELDERROR("Entry Type");
            END;
        END;
    END;

    LOCAL PROCEDURE PostDtldEmplLedgEntries(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; EmplPostingGr: Record 5221; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean;
    VAR
        TempInvPostBuf: Record 49 TEMPORARY;
        DtldEmplLedgEntry: Record 5223;
        GLEntry: Record 17;
        DummyAdjAmount: ARRAY[4] OF Decimal;
        DtldEmplLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
        PayableAccAmtLCY: Decimal;
        PayableAccAmtAddCurr: Decimal;
    BEGIN
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Employee THEN
            EXIT;

        IF DtldEmplLedgEntry.FINDLAST THEN
            DtldEmplLedgEntryNoOffset := DtldEmplLedgEntry."Entry No."
        ELSE
            DtldEmplLedgEntryNoOffset := 0;

        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            END;
            REPEAT
                InsertDtldEmplLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldEmplLedgEntry, DtldEmplLedgEntryNoOffset);
                UpdateEmplLedgEntryStats(DtldEmplLedgEntry."Employee Ledger Entry No.");
                UpdateTotalAmounts(TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf);
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;
        END;

        DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
        DtldCVLedgEntryBuf.DELETEALL;

        EmplPostingGr.TESTFIELD("Payables Account");
        AccNo := EmplPostingGr."Payables Account";

        CalcInvPostBufferTotals(TempInvPostBuf);
        PayableAccAmtLCY := TempInvPostBuf.Amount - (DocAmountLCY + CollDocAmountLCY);
        PayableAccAmtAddCurr :=
          TempInvPostBuf."Amount (ACY)" -
          (DocAmtCalcAddCurrency(GenJnlLine, DocAmountLCY) + DocAmtCalcAddCurrency(GenJnlLine, CollDocAmountLCY));
        IF (TempInvPostBuf.Amount <> 0) OR ((TempInvPostBuf."Amount (ACY)" <> 0) AND (AddCurrencyCode <> '')) OR
           (GenJnlLine."Applies-to ID" <> '')
        THEN
            IF (PayableAccAmtLCY <> 0) OR
               ((PayableAccAmtAddCurr <> 0) AND (AddCurrencyCode <> ''))
            THEN BEGIN
                InitGLEntry(GenJnlLine, GLEntry,
                  AccNo, PayableAccAmtLCY, PayableAccAmtAddCurr,
                  TRUE, TRUE);
                GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
                GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
                UpdateGLEntryNo(GLEntry."Entry No.", SaveEntryNo);
                InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            END;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine, TempInvPostBuf, DummyAdjAmount, SaveEntryNo, EmplPostingGr.GetPayablesAccount);

        DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
        DtldCVLedgEntryBuf.DELETEALL;
    END;

    LOCAL PROCEDURE PostDtldCVLedgEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; AccNo: Code[20]; VAR AdjAmount: ARRAY[4] OF Decimal; Unapply: Boolean);
    BEGIN
        WITH DtldCVLedgEntryBuf DO
            CASE "Entry Type" OF
                "Entry Type"::"Initial Entry":
                    ;
                "Entry Type"::Application:
                    PostDtldCVApplicationEntry(GenJnlLine, DtldCVLedgEntryBuf);
                "Entry Type"::"Unrealized Loss",
                "Entry Type"::"Unrealized Gain",
                "Entry Type"::"Realized Loss",
                "Entry Type"::"Realized Gain":
                    BEGIN
                        OnPostDtldCVLedgEntryOnBeforeCreateGLEntryGainLoss(GenJnlLine, DtldCVLedgEntryBuf, Unapply);
                        CreateGLEntryGainLoss(GenJnlLine, AccNo, -"Amount (LCY)", "Currency Code" = AddCurrencyCode);
                        IF NOT Unapply THEN
                            CollectAdjustment(AdjAmount, -"Amount (LCY)", 0);
                    END;
                "Entry Type"::"Payment Discount",
                "Entry Type"::"Payment Tolerance",
                "Entry Type"::"Payment Discount Tolerance":
                    BEGIN
                        CreateGLEntry(GenJnlLine, AccNo, -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                        IF NOT Unapply THEN
                            CollectAdjustment(AdjAmount, -"Amount (LCY)", -"Additional-Currency Amount");
                    END;
                "Entry Type"::"Payment Discount (VAT Excl.)",
                "Entry Type"::"Payment Tolerance (VAT Excl.)",
                "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                    BEGIN
                        IF NOT Unapply THEN
                            CreateGLEntryVATCollectAdj(
                              GenJnlLine, AccNo, -"Amount (LCY)", -"Additional-Currency Amount", -"VAT Amount (LCY)", DtldCVLedgEntryBuf,
                              AdjAmount)
                        ELSE
                            CreateGLEntryVAT(
                              GenJnlLine, AccNo, -"Amount (LCY)", -"Additional-Currency Amount", -"VAT Amount (LCY)", DtldCVLedgEntryBuf);
                    END;
                "Entry Type"::"Appln. Rounding":
                    IF "Amount (LCY)" <> 0 THEN BEGIN
                        CreateGLEntry(GenJnlLine, AccNo, -"Amount (LCY)", -"Additional-Currency Amount", TRUE);
                        IF NOT Unapply THEN
                            CollectAdjustment(AdjAmount, -"Amount (LCY)", -"Additional-Currency Amount");
                    END;
                "Entry Type"::"Correction of Remaining Amount":
                    IF "Amount (LCY)" <> 0 THEN BEGIN
                        CreateGLEntry(GenJnlLine, AccNo, -"Amount (LCY)", 0, FALSE);
                        IF NOT Unapply THEN
                            CollectAdjustment(AdjAmount, -"Amount (LCY)", 0);
                    END;
                "Entry Type"::"Payment Discount (VAT Adjustment)",
              "Entry Type"::"Payment Tolerance (VAT Adjustment)",
              "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                    ;
                ELSE
                    FIELDERROR("Entry Type");
            END;
    END;

    LOCAL PROCEDURE PostDtldCustVATAdjustment(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; OriginalTransactionNo: Integer);
    VAR
        VATPostingSetup: Record 325;
        TaxJurisdiction: Record 320;
    BEGIN
        WITH DtldCVLedgEntryBuf DO BEGIN
            FindVATEntry(VATEntry, OriginalTransactionNo);

            CASE VATPostingSetup."VAT Calculation Type" OF
                VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                VATPostingSetup."VAT Calculation Type"::"Full VAT":
                    BEGIN
                        VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                        VATPostingSetup.TESTFIELD("VAT Calculation Type", VATEntry."VAT Calculation Type");
                        CreateGLEntry(
                          GenJnlLine, VATPostingSetup.GetSalesAccount(FALSE), -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                    END;
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    ;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    BEGIN
                        TESTFIELD("Tax Jurisdiction Code");
                        TaxJurisdiction.GET("Tax Jurisdiction Code");
                        CreateGLEntry(
                          GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE PostDtldVendVATAdjustment(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383; OriginalTransactionNo: Integer);
    VAR
        VATPostingSetup: Record 325;
        TaxJurisdiction: Record 320;
    BEGIN
        WITH DtldCVLedgEntryBuf DO BEGIN
            FindVATEntry(VATEntry, OriginalTransactionNo);

            CASE VATPostingSetup."VAT Calculation Type" OF
                VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                VATPostingSetup."VAT Calculation Type"::"Full VAT":
                    BEGIN
                        VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                        VATPostingSetup.TESTFIELD("VAT Calculation Type", VATEntry."VAT Calculation Type");
                        CreateGLEntry(
                          GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                    END;
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                        VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                        VATPostingSetup.TESTFIELD("VAT Calculation Type", VATEntry."VAT Calculation Type");
                        CreateGLEntry(
                          GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                        CreateGLEntry(
                          GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), "Amount (LCY)", "Additional-Currency Amount", FALSE);
                    END;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    BEGIN
                        TaxJurisdiction.GET("Tax Jurisdiction Code");
                        IF "Use Tax" THEN BEGIN
                            CreateGLEntry(
                              GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                            CreateGLEntry(
                              GenJnlLine, TaxJurisdiction.GetRevChargeAccount(FALSE), "Amount (LCY)", "Additional-Currency Amount", FALSE);
                        END ELSE
                            CreateGLEntry(
                              GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), -"Amount (LCY)", -"Additional-Currency Amount", FALSE);
                    END;
            END;
        END;
    END;

    LOCAL PROCEDURE VendUnrealizedVAT(GenJnlLine: Record 81; VAR VendLedgEntry2: Record 25; SettledAmount: Decimal);
    VAR
        VATEntry2: Record 254;
        TaxJurisdiction: Record 320;
        VATPostingSetup: Record 325;
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        PurchVATAccount: Code[20];
        PurchVATUnrealAccount: Code[20];
        PurchReverseAccount: Code[20];
        PurchReverseUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        Doc: Record 7000002;
        ClosedDoc: Record 7000004;
        PostedDoc: Record 7000003;
        FromDocInPostedPmtOrd: Boolean;
        FromDoc: Boolean;
        VendLedgEntry3: Record 25;
        VendLedgEntry4: Record 25;
        FromJnl: Boolean;
        GLEntryNo: Integer;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeVendUnrealizedVAT(GenJnlLine, VendLedgEntry2, SettledAmount, IsHandled);
        IF IsHandled THEN
            EXIT;

        VendLedgEntry4.COPY(VendLedgEntry2);

        FromDoc := FALSE;
        FromDocInPostedPmtOrd := FALSE;

        Doc.SETCURRENTKEY(Type, "Document No.");
        Doc.SETRANGE(Type, Doc.Type::Payable);
        Doc.SETRANGE("Document No.", VendLedgEntry4."Document No.");
        ClosedDoc.SETCURRENTKEY(Type, "Document No.");
        ClosedDoc.SETRANGE(Type, ClosedDoc.Type::Payable);
        ClosedDoc.SETRANGE("Document No.", VendLedgEntry4."Document No.");
        ClosedDoc.SETRANGE("No.", VendLedgEntry4."Bill No.");
        PostedDoc.SETCURRENTKEY(Type, "Document No.");
        PostedDoc.SETRANGE(Type, PostedDoc.Type::Payable);
        PostedDoc.SETRANGE("Document No.", VendLedgEntry4."Document No.");
        PostedDoc.SETRANGE("No.", VendLedgEntry4."Bill No.");
        FromDoc := (Doc.FINDFIRST AND (NOT ClosedDoc.FINDFIRST));
        FromDocInPostedPmtOrd := PostedDoc.FINDFIRST;

        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        IF VendLedgEntry4."Document Type" = VendLedgEntry4."Document Type"::Bill THEN BEGIN
            FromJnl := FALSE;
            IF Doc."From Journal" OR PostedDoc."From Journal" OR ClosedDoc."From Journal" THEN
                FromJnl := TRUE;
            VendFindVATSetup(VATPostingSetup, VendLedgEntry4, FromJnl);
            IF (VATPostingSetup."Unrealized VAT Type" > VATPostingSetup."Unrealized VAT Type"::Percentage) AND
               (NOT FromDocInPostedPmtOrd)
            THEN
                ERROR(Text1100000);
            VendLedgEntry3.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
            VendLedgEntry3.SETRANGE("Document Type", VendLedgEntry3."Document Type"::Invoice);
            VendLedgEntry3.SETRANGE("Document No.", VendLedgEntry4."Document No.");
            IF VendLedgEntry3.FINDFIRST THEN BEGIN
                VendLedgEntry3.CALCFIELDS("Original Amt. (LCY)");
                VendLedgEntry2.Open := TRUE;
                VATEntry2.SETRANGE("Transaction No.", VendLedgEntry3."Transaction No.");
                VATEntry2.SETRANGE("Document No.", VendLedgEntry3."Document No.");
            END ELSE
                ERROR(Text1100001, VendLedgEntry3."Document No.");
        END ELSE BEGIN
            VATEntry2.SETRANGE("Transaction No.", VendLedgEntry4."Transaction No.");
            VATEntry2.SETRANGE("Document No.", VendLedgEntry4."Document No.");
        END;
        VATEntry2.SETRANGE("Unrealized VAT Entry No.", 0);//QB
        PaidAmount := -VendLedgEntry2."Amount (LCY)" + VendLedgEntry2."Remaining Amt. (LCY)";
        IF VATEntry2.FINDSET THEN
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::Last, VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::First, VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
            UNTIL VATEntry2.NEXT = 0;
        IF VATEntry2.FINDSET AND (NOT FromDocInPostedPmtOrd) THEN BEGIN
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                    InsertSummarizedVAT(GenJnlLine);
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                END;

                VATEntry2.SetBillDoc(IsVendBillDoc(VendLedgEntry4));
                VATPart :=
                  VATEntry2.GetUnrealizedVATPart(
                    GetVendSettledAmount(SettledAmount, VendLedgEntry4, VendLedgEntry3, VendLedgEntry2),
                    PaidAmount,
                    GetVendOriginalAmtLCY(VendLedgEntry4, VendLedgEntry3, VendLedgEntry2),
                    TotalUnrealVATAmountFirst,
                    TotalUnrealVATAmountLast);


                QBCodeunitPublisher.CheckRemainingUnrealizedVATVendorLedgerGenJnlPostLine(VATPostingSetup,
                                    VATEntry2, VATPart, VendLedgEntry2."Document No.");

                OnVendUnrealizedVATOnAfterVATPartCalculation(
                  GenJnlLine, VendLedgEntry2, PaidAmount, TotalUnrealVATAmountFirst, TotalUnrealVATAmountLast, SettledAmount, VATEntry2);

                IF VATPart > 0 THEN BEGIN
                    CASE VATEntry2."VAT Calculation Type" OF
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                        VATEntry2."VAT Calculation Type"::"Full VAT":
                            BEGIN
                                PurchVATAccount := VATPostingSetup.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(TRUE);
                            END;
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                            BEGIN
                                PurchVATAccount := VATPostingSetup.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(TRUE);
                                PurchReverseAccount := VATPostingSetup.GetRevChargeAccount(FALSE);
                                PurchReverseUnrealAccount := VATPostingSetup.GetRevChargeAccount(TRUE);
                            END;
                        VATEntry2."VAT Calculation Type"::"Sales Tax":
                            IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
                                TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                                PurchVATAccount := TaxJurisdiction.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(TRUE);
                                PurchReverseAccount := TaxJurisdiction.GetRevChargeAccount(FALSE);
                                PurchReverseUnrealAccount := TaxJurisdiction.GetRevChargeAccount(TRUE);
                            END ELSE BEGIN
                                TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                                PurchVATAccount := TaxJurisdiction.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(TRUE);
                            END;
                    END;

                    IF VATPart = 1 THEN BEGIN
                        VATAmount := VATEntry2."Remaining Unrealized Amount";
                        VATBase := VATEntry2."Remaining Unrealized Base";
                        VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                        VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                    END ELSE
                        CalcVendRealizedVATAmt(
                          VATBase, VATAmount, VATBaseAddCurr, VATAmountAddCurr, VATEntry2, VendLedgEntry4, VATPart);

                    OnVendUnrealizedVATOnBeforeInitGLEntryVAT(GenJnlLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr);

                    InitGLEntryVAT(
                      GenJnlLine, PurchVATUnrealAccount, PurchVATAccount, -VATAmount, -VATAmountAddCurr, FALSE);
                    GLEntryNo :=
                      InitGLEntryVATCopy(GenJnlLine, PurchVATAccount, PurchVATUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);

                    IF (VATEntry2."VAT Calculation Type" =
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT") OR
                       ((VATEntry2."VAT Calculation Type" =
                         VATEntry2."VAT Calculation Type"::"Sales Tax") AND
                        (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax")
                    THEN BEGIN
                        InitGLEntryVAT(
                          GenJnlLine, PurchReverseUnrealAccount, PurchReverseAccount, VATAmount, VATAmountAddCurr, FALSE);
                        GLEntryNo :=
                          InitGLEntryVATCopy(GenJnlLine, PurchReverseAccount, PurchReverseUnrealAccount, -VATAmount, -VATAmountAddCurr, VATEntry2);
                    END;

                    PostUnrealVATEntry(GenJnlLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr, GLEntryNo);
                END;
            UNTIL VATEntry2.NEXT = 0;

            InsertSummarizedVAT(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE PostUnrealVATEntry(GenJnlLine: Record 81; VAR VATEntry2: Record 254; VATAmount: Decimal; VATBase: Decimal; VATAmountAddCurr: Decimal; VATBaseAddCurr: Decimal; GLEntryNo: Integer);
    BEGIN
        OnBeforePostUnrealVATEntry(GenJnlLine, VATEntry);
        VATEntry.LOCKTABLE;
        VATEntry := VATEntry2;
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."Posting Date" := GenJnlLine."Posting Date";
        IF (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::"Credit Memo") AND//QB
           (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Invoice) THEN BEGIN
            VATEntry."Document No." := GenJnlLine."Document No.";
            VATEntry."Document Type" := GenJnlLine."Document Type";
        END;//QB
        VATEntry."External Document No." := GenJnlLine."External Document No.";
        VATEntry.Amount := VATAmount;
        VATEntry.Base := VATBase;
        VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        VATEntry."Additional-Currency Base" := VATBaseAddCurr;
        VATEntry.SetUnrealAmountsToZero;
        VATEntry."User ID" := USERID;
        VATEntry."Source Code" := GenJnlLine."Source Code";
        VATEntry."Reason Code" := GenJnlLine."Reason Code";
        VATEntry."Closed by Entry No." := 0;
        VATEntry.Closed := FALSE;
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;
        VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
        VATEntry."Base Before Pmt. Disc." := VATEntry.Base;
        OnBeforeInsertPostUnrealVATEntry(VATEntry, GenJnlLine);
        VATEntry.INSERT(TRUE);
        GLEntryVATEntryLink.InsertLink(GLEntryNo + 1, NextVATEntryNo);
        NextVATEntryNo := NextVATEntryNo + 1;

        VATEntry2."Remaining Unrealized Amount" :=
          VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
        VATEntry2."Remaining Unrealized Base" :=
          VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
        VATEntry2.MODIFY;
        OnAfterPostUnrealVATEntry(GenJnlLine, VATEntry2);
    END;

    LOCAL PROCEDURE PostApply(VAR GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR OldCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf2: Record 382; BlockPaymentTolerance: Boolean; AllApplied: Boolean; VAR AppliedAmount: Decimal; VAR PmtTolAmtToBeApplied: Decimal);
    VAR
        OldCVLedgEntryBuf2: Record 382;
        OldCVLedgEntryBuf3: Record 382;
        OldRemainingAmtBeforeAppln: Decimal;
        ApplnRoundingPrecision: Decimal;
        AppliedAmountLCY: Decimal;
        OldAppliedAmount: Decimal;
        IsHandled: Boolean;
    BEGIN
        OnBeforePostApply(GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2);

        OldRemainingAmtBeforeAppln := OldCVLedgEntryBuf."Remaining Amount";
        OldCVLedgEntryBuf3 := OldCVLedgEntryBuf;

        // Management of posting in multiple currencies
        OldCVLedgEntryBuf2 := OldCVLedgEntryBuf;
        OldCVLedgEntryBuf.COPYFILTER(Positive, OldCVLedgEntryBuf2.Positive);
        ApplnRoundingPrecision := GetApplnRoundPrecision(NewCVLedgEntryBuf, OldCVLedgEntryBuf);

        OldCVLedgEntryBuf2.RecalculateAmounts(
          OldCVLedgEntryBuf2."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");

        IF NOT BlockPaymentTolerance THEN
            CalcPmtTolerance(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              PmtTolAmtToBeApplied, NextTransactionNo, FirstNewVATEntryNo);

        CalcPmtDisc(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
          PmtTolAmtToBeApplied, ApplnRoundingPrecision, NextTransactionNo, FirstNewVATEntryNo);

        IF NOT BlockPaymentTolerance THEN
            CalcPmtDiscTolerance(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              NextTransactionNo, FirstNewVATEntryNo);

        IsHandled := FALSE;
        OnBeforeCalcCurrencyApplnRounding(
          GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, OldCVLedgEntryBuf3,
          NewCVLedgEntryBuf, NewCVLedgEntryBuf2, IsHandled);
        IF NOT IsHandled THEN
            CalcCurrencyApplnRounding(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, ApplnRoundingPrecision);

        FindAmtForAppln(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2,
          AppliedAmount, AppliedAmountLCY, OldAppliedAmount, ApplnRoundingPrecision);

        CalcCurrencyUnrealizedGainLoss(
          OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, -OldAppliedAmount, OldRemainingAmtBeforeAppln);

        CalcCurrencyRealizedGainLoss(
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, AppliedAmount, AppliedAmountLCY);

        CalcCurrencyRealizedGainLoss(
          OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, -OldAppliedAmount, -AppliedAmountLCY);

        CalcApplication(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, DtldCVLedgEntryBuf,
          GenJnlLine, AppliedAmount, AppliedAmountLCY, OldAppliedAmount,
          NewCVLedgEntryBuf2, OldCVLedgEntryBuf3, AllApplied);

        PaymentToleranceMgt.CalcRemainingPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, GLSetup);

        CalcAmtLCYAdjustment(OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);

        OnAfterPostApply(GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2);
    END;

    //[External]
    PROCEDURE UnapplyCustLedgEntry(GenJnlLine2: Record 81; DtldCustLedgEntry: Record 379);
    VAR
        Cust: Record 18;
        CustPostingGr: Record 92;
        GenJnlLine: Record 81;
        DtldCustLedgEntry2: Record 379;
        NewDtldCustLedgEntry: Record 379;
        CustLedgEntry: Record 21;
        DtldCVLedgEntryBuf: Record 383;
        VATEntry: Record 254;
        TempVATEntry2: Record 254 TEMPORARY;
        CurrencyLCY: Record 4;
        GLEntry: Record 17;
        TempInvPostBuf: Record 49 TEMPORARY;
        AdjAmount: ARRAY[4] OF Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
        PmtDiscTolExists: Boolean;
        PositiveLCYAppAmt: Decimal;
        NegativeLCYAppAmt: Decimal;
        PositiveACYAppAmt: Decimal;
        NegativeACYAppAmt: Decimal;
        GLAccountNo: Code[20];
    BEGIN
        GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
        IF GenJnlLine."Document Date" = 0D THEN
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Cust.GET(DtldCustLedgEntry."Customer No.");
        Cust.CheckBlockedCustOnJnls(Cust, GenJnlLine2."Document Type"::Payment, TRUE);

        OnUnapplyCustLedgEntryOnBeforeCheckPostingGroup(GenJnlLine, Cust);
        CustPostingGr.GET(GenJnlLine."Posting Group");
        CustPostingGr.GetReceivablesAccount;

        VATEntry.LOCKTABLE;
        DtldCustLedgEntry.LOCKTABLE;
        CustLedgEntry.LOCKTABLE;

        DtldCustLedgEntry.TESTFIELD("Entry Type", DtldCustLedgEntry."Entry Type"::Application);

        DtldCustLedgEntry2.RESET;
        DtldCustLedgEntry2.FINDLAST;
        NextDtldLedgEntryNo := DtldCustLedgEntry2."Entry No." + 1;
        IF DtldCustLedgEntry."Transaction No." = 0 THEN BEGIN
            DtldCustLedgEntry2.SETCURRENTKEY("Application No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry2.SETRANGE("Application No.", DtldCustLedgEntry."Application No.");
        END ELSE BEGIN
            DtldCustLedgEntry2.SETCURRENTKEY("Transaction No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry2.SETRANGE("Transaction No.", DtldCustLedgEntry."Transaction No.");
        END;
        DtldCustLedgEntry2.SETRANGE("Customer No.", DtldCustLedgEntry."Customer No.");
        DtldCustLedgEntry2.SETFILTER("Entry Type", '>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        IF DtldCustLedgEntry."Transaction No." <> 0 THEN BEGIN
            UnapplyVATEntries := FALSE;
            DtldCustLedgEntry2.FINDSET;
            REPEAT
                CheckCarteraAccessPermissions(DtldCustLedgEntry2."Document Situation");
                DtldCustLedgEntry2.TESTFIELD(Unapplied, FALSE);
                IF IsVATAdjustment(DtldCustLedgEntry2."Entry Type") THEN //enum to option
                    UnapplyVATEntries := TRUE;
                IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." THEN
                    IF IsVATExcluded(DtldCustLedgEntry2."Entry Type") THEN //enum to option
                        UnapplyVATEntries := TRUE;
                IF DtldCustLedgEntry2."Entry Type" = DtldCustLedgEntry2."Entry Type"::"Payment Discount Tolerance (VAT Excl.)" THEN
                    PmtDiscTolExists := TRUE;
            UNTIL DtldCustLedgEntry2.NEXT = 0;

            PostUnapply(
              GenJnlLine, VATEntry, VATEntry.Type::Sale, //enum to option
              DtldCustLedgEntry."Customer No.", DtldCustLedgEntry."Transaction No.", UnapplyVATEntries, TempVATEntry);

            IF PmtDiscTolExists THEN
                ProcessTempVATEntryCust(DtldCustLedgEntry2, TempVATEntry)
            ELSE BEGIN
                DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::"Payment Tolerance (VAT Excl.)");
                ProcessTempVATEntryCust(DtldCustLedgEntry2, TempVATEntry);
                DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::"Payment Discount (VAT Excl.)");
                ProcessTempVATEntryCust(DtldCustLedgEntry2, TempVATEntry);
                DtldCustLedgEntry2.SETFILTER("Entry Type", '>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
            END;
        END;

        // Look one more time
        DtldCustLedgEntry2.FINDSET;
        TempInvPostBuf.DELETEALL;
        REPEAT
            DtldCustLedgEntry2.TESTFIELD(Unapplied, FALSE);
            InsertDtldCustLedgEntryUnapply(GenJnlLine, NewDtldCustLedgEntry, DtldCustLedgEntry2, NextDtldLedgEntryNo);

            DtldCVLedgEntryBuf.INIT;
            DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldCustLedgEntry);
            SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
            CurrencyLCY.InitRoundingPrecision;

            IF (DtldCustLedgEntry2."Transaction No." <> 0) AND IsVATExcluded(DtldCustLedgEntry2."Entry Type") THEN BEGIN //enum to option
                UnapplyExcludedVAT(
                  TempVATEntry2, DtldCustLedgEntry2."Transaction No.", DtldCustLedgEntry2."VAT Bus. Posting Group",
                  DtldCustLedgEntry2."VAT Prod. Posting Group", DtldCustLedgEntry2."Gen. Prod. Posting Group");
                DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
                  CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)", TempVATEntry2, CurrencyLCY);
            END;
            UpdateTotalAmounts(TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf);

            IF DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application THEN
                IF DtldCVLedgEntryBuf."Amount (LCY)" >= 0 THEN BEGIN
                    PositiveLCYAppAmt := PositiveLCYAppAmt + DtldCVLedgEntryBuf."Amount (LCY)";
                    PositiveACYAppAmt :=
                      PositiveACYAppAmt + DtldCVLedgEntryBuf."Additional-Currency Amount";
                END ELSE BEGIN
                    NegativeLCYAppAmt := NegativeLCYAppAmt + DtldCVLedgEntryBuf."Amount (LCY)";
                    NegativeACYAppAmt :=
                      NegativeACYAppAmt + DtldCVLedgEntryBuf."Additional-Currency Amount";
                END;

            IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [
                                                        DtldCVLedgEntryBuf."Entry Type"::"Initial Entry",
                                                        DtldCVLedgEntryBuf."Entry Type"::Application])
            THEN
                CollectAdjustment(AdjAmount,
                  -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount");

            PostDtldCustLedgEntryUnapply(
              GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, DtldCustLedgEntry2."Transaction No.");

            DtldCustLedgEntry2.Unapplied := TRUE;
            DtldCustLedgEntry2."Unapplied by Entry No." := NewDtldCustLedgEntry."Entry No.";
            DtldCustLedgEntry2.MODIFY;

            UpdateCustLedgEntry(DtldCustLedgEntry2, GenJnlLine);
        UNTIL DtldCustLedgEntry2.NEXT = 0;

        OnBeforeCreateGLEntriesForTotalAmountsUnapply(DtldCustLedgEntry, CustPostingGr);
        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine, TempInvPostBuf, CustPostingGr.GetReceivablesAccount);

        OnUnapplyCustLedgEntryOnAfterCreateGLEntriesForTotalAmounts(GenJnlLine2, DtldCustLedgEntry);

        IF IsTempGLEntryBufEmpty THEN BEGIN
            IF GenJnlLine."Financial Void" THEN
                GLAccountNo := CustPostingGr.GetReceivablesAccount
            ELSE
                IF CheckDtldCustLegderEntryCreateBills(DtldCustLedgEntry) THEN
                    GLAccountNo := CustPostingGr.GetBillsAccount(FALSE)
                ELSE
                    GLAccountNo := CustPostingGr.GetReceivablesAccount;
            InitGLEntry(
              GenJnlLine, GLEntry, GLAccountNo, PositiveLCYAppAmt,
              PositiveACYAppAmt, FALSE, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, FALSE);
            InitGLEntry(
              GenJnlLine, GLEntry, CustPostingGr."Receivables Account", NegativeLCYAppAmt,
              NegativeACYAppAmt, FALSE, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, FALSE);
        END;

        CheckPostUnrealizedVAT(GenJnlLine, TRUE);
        GenJnlLineQB := GenJnlLine;//QB

        FinishPosting(GenJnlLine);
    END;

    //[External]
    PROCEDURE UnapplyVendLedgEntry(GenJnlLine2: Record 81; DtldVendLedgEntry: Record 380);
    VAR
        Vend: Record 23;
        VendPostingGr: Record 93;
        GenJnlLine: Record 81;
        DtldVendLedgEntry2: Record 380;
        NewDtldVendLedgEntry: Record 380;
        VendLedgEntry: Record 25;
        DtldCVLedgEntryBuf: Record 383;
        VATEntry: Record 254;
        TempVATEntry2: Record 254 TEMPORARY;
        CurrencyLCY: Record 4;
        GLEntry: Record 17;
        TempInvPostBuf: Record 49 TEMPORARY;
        AdjAmount: ARRAY[4] OF Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
        PmtDiscTolExists: Boolean;
        PositiveLCYAppAmt: Decimal;
        NegativeLCYAppAmt: Decimal;
        PositiveACYAppAmt: Decimal;
        NegativeACYAppAmt: Decimal;
        GLAccountNo: Code[20];
    BEGIN
        GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
        IF GenJnlLine."Document Date" = 0D THEN
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Vend.GET(DtldVendLedgEntry."Vendor No.");
        Vend.CheckBlockedVendOnJnls(Vend, GenJnlLine2."Document Type"::Payment, TRUE);

        OnUnapplyVendLedgEntryOnBeforeCheckPostingGroup(GenJnlLine, Vend);
        VendPostingGr.GET(GenJnlLine."Posting Group");
        VendPostingGr.GetPayablesAccount;

        VATEntry.LOCKTABLE;
        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;

        DtldVendLedgEntry.TESTFIELD("Entry Type", DtldVendLedgEntry."Entry Type"::Application);

        DtldVendLedgEntry2.RESET;
        DtldVendLedgEntry2.FINDLAST;
        NextDtldLedgEntryNo := DtldVendLedgEntry2."Entry No." + 1;
        IF DtldVendLedgEntry."Transaction No." = 0 THEN BEGIN
            DtldVendLedgEntry2.SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry2.SETRANGE("Application No.", DtldVendLedgEntry."Application No.");
        END ELSE BEGIN
            DtldVendLedgEntry2.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry2.SETRANGE("Transaction No.", DtldVendLedgEntry."Transaction No.");
        END;
        DtldVendLedgEntry2.SETRANGE("Vendor No.", DtldVendLedgEntry."Vendor No.");
        DtldVendLedgEntry2.SETFILTER("Entry Type", '>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
            UnapplyVATEntries := FALSE;
            DtldVendLedgEntry2.FINDSET;
            REPEAT
                CheckCarteraAccessPermissions(DtldVendLedgEntry2."Document Situation");
                DtldVendLedgEntry2.TESTFIELD(Unapplied, FALSE);
                IF IsVATAdjustment(DtldVendLedgEntry2."Entry Type") THEN //enum to option
                    UnapplyVATEntries := TRUE;
                IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." THEN
                    IF IsVATExcluded(DtldVendLedgEntry2."Entry Type") THEN //enum to option
                        UnapplyVATEntries := TRUE;
                IF DtldVendLedgEntry2."Entry Type" = DtldVendLedgEntry2."Entry Type"::"Payment Discount Tolerance (VAT Excl.)" THEN
                    PmtDiscTolExists := TRUE;
            UNTIL DtldVendLedgEntry2.NEXT = 0;

            PostUnapply(
              GenJnlLine, VATEntry, VATEntry.Type::Purchase, //enum to option
              DtldVendLedgEntry."Vendor No.", DtldVendLedgEntry."Transaction No.", UnapplyVATEntries, TempVATEntry);

            IF PmtDiscTolExists THEN
                ProcessTempVATEntryVend(DtldVendLedgEntry2, TempVATEntry)
            ELSE BEGIN
                DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::"Payment Tolerance (VAT Excl.)");
                ProcessTempVATEntryVend(DtldVendLedgEntry2, TempVATEntry);
                DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::"Payment Discount (VAT Excl.)");
                ProcessTempVATEntryVend(DtldVendLedgEntry2, TempVATEntry);
                DtldVendLedgEntry2.SETFILTER("Entry Type", '>%1', DtldVendLedgEntry2."Entry Type"::"Initial Entry");
            END;
        END;

        // Look one more time
        DtldVendLedgEntry2.FINDSET;
        TempInvPostBuf.DELETEALL;
        REPEAT
            DtldVendLedgEntry2.TESTFIELD(Unapplied, FALSE);
            InsertDtldVendLedgEntryUnapply(GenJnlLine, NewDtldVendLedgEntry, DtldVendLedgEntry2, NextDtldLedgEntryNo);

            DtldCVLedgEntryBuf.INIT;
            DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldVendLedgEntry);
            SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
            CurrencyLCY.InitRoundingPrecision;

            IF (DtldVendLedgEntry2."Transaction No." <> 0) AND IsVATExcluded(DtldVendLedgEntry2."Entry Type") THEN BEGIN //enum to option
                UnapplyExcludedVAT(
                  TempVATEntry2, DtldVendLedgEntry2."Transaction No.", DtldVendLedgEntry2."VAT Bus. Posting Group",
                  DtldVendLedgEntry2."VAT Prod. Posting Group", DtldVendLedgEntry2."Gen. Prod. Posting Group");
                DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
                  CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)", TempVATEntry2, CurrencyLCY);
            END;
            UpdateTotalAmounts(TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf);

            IF DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application THEN
                IF DtldCVLedgEntryBuf."Amount (LCY)" >= 0 THEN BEGIN
                    PositiveLCYAppAmt := PositiveLCYAppAmt + DtldCVLedgEntryBuf."Amount (LCY)";
                    PositiveACYAppAmt :=
                      PositiveACYAppAmt + DtldCVLedgEntryBuf."Additional-Currency Amount";
                END ELSE BEGIN
                    NegativeLCYAppAmt := NegativeLCYAppAmt + DtldCVLedgEntryBuf."Amount (LCY)";
                    NegativeACYAppAmt :=
                      NegativeACYAppAmt + DtldCVLedgEntryBuf."Additional-Currency Amount";
                END;

            IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [
                                                        DtldCVLedgEntryBuf."Entry Type"::"Initial Entry",
                                                        DtldCVLedgEntryBuf."Entry Type"::Application])
            THEN
                CollectAdjustment(AdjAmount,
                  -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount");

            PostDtldVendLedgEntryUnapply(
              GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, DtldVendLedgEntry2."Transaction No.");

            DtldVendLedgEntry2.Unapplied := TRUE;
            DtldVendLedgEntry2."Unapplied by Entry No." := NewDtldVendLedgEntry."Entry No.";
            DtldVendLedgEntry2.MODIFY;

            UpdateVendLedgEntry(DtldVendLedgEntry2, GenJnlLine);
        UNTIL DtldVendLedgEntry2.NEXT = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine, TempInvPostBuf, VendPostingGr.GetPayablesAccount);

        OnUnapplyVendLedgEntryOnAfterCreateGLEntriesForTotalAmounts(GenJnlLine2, DtldVendLedgEntry);

        IF IsTempGLEntryBufEmpty THEN BEGIN
            IF FinancialVoidWithMethodCreateBills(GenJnlLine) THEN
                GLAccountNo := VendPostingGr.GetBillsAccount
            ELSE
                IF GenJnlLine."Financial Void" THEN
                    GLAccountNo := VendPostingGr.GetPayablesAccount
                ELSE
                    IF CheckDtldVendLegderEntryCreateBills(DtldVendLedgEntry) THEN
                        GLAccountNo := VendPostingGr.GetBillsAccount
                    ELSE
                        GLAccountNo := VendPostingGr.GetPayablesAccount;
            InitGLEntry(
              GenJnlLine, GLEntry, VendPostingGr.GetPayablesAccount,
              PositiveLCYAppAmt, PositiveACYAppAmt, FALSE, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, FALSE);
            InitGLEntry(
              GenJnlLine, GLEntry, GLAccountNo,
              NegativeLCYAppAmt, NegativeACYAppAmt, FALSE, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, FALSE);
        END;

        CheckPostUnrealizedVAT(GenJnlLine, TRUE);
        GenJnlLineQB := GenJnlLine;//QB

        FinishPosting(GenJnlLine);
    END;

    //[External]
    PROCEDURE UnapplyEmplLedgEntry(GenJnlLine2: Record 81; DtldEmplLedgEntry: Record 5223);
    VAR
        Employee: Record 5200;
        EmployeePostingGroup: Record 5221;
        GenJnlLine: Record 81;
        DtldEmplLedgEntry2: Record 5223;
        NewDtldEmplLedgEntry: Record 5223;
        EmplLedgEntry: Record 5222;
        DtldCVLedgEntryBuf: Record 383;
        CurrencyLCY: Record 4;
        TempInvPostBuf: Record 49 TEMPORARY;
        NextDtldLedgEntryNo: Integer;
    BEGIN
        GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
        IF GenJnlLine."Document Date" = 0D THEN
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Employee.GET(DtldEmplLedgEntry."Employee No.");
        Employee.CheckBlockedEmployeeOnJnls(TRUE);
        EmployeePostingGroup.GET(GenJnlLine."Posting Group");
        EmployeePostingGroup.GetPayablesAccount;

        DtldEmplLedgEntry.LOCKTABLE;
        EmplLedgEntry.LOCKTABLE;

        DtldEmplLedgEntry.TESTFIELD("Entry Type", DtldEmplLedgEntry."Entry Type"::Application);

        DtldEmplLedgEntry2.RESET;
        DtldEmplLedgEntry2.FINDLAST;
        NextDtldLedgEntryNo := DtldEmplLedgEntry2."Entry No." + 1;
        IF DtldEmplLedgEntry."Transaction No." = 0 THEN BEGIN
            DtldEmplLedgEntry2.SETCURRENTKEY("Application No.", "Employee No.", "Entry Type");
            DtldEmplLedgEntry2.SETRANGE("Application No.", DtldEmplLedgEntry."Application No.");
        END ELSE BEGIN
            DtldEmplLedgEntry2.SETCURRENTKEY("Transaction No.", "Employee No.", "Entry Type");
            DtldEmplLedgEntry2.SETRANGE("Transaction No.", DtldEmplLedgEntry."Transaction No.");
        END;
        DtldEmplLedgEntry2.SETRANGE("Employee No.", DtldEmplLedgEntry."Employee No.");
        DtldEmplLedgEntry2.SETFILTER("Entry Type", '>%1', DtldEmplLedgEntry."Entry Type"::"Initial Entry");

        // Look one more time
        DtldEmplLedgEntry2.FINDSET;
        TempInvPostBuf.DELETEALL;
        REPEAT
            DtldEmplLedgEntry2.TESTFIELD(Unapplied, FALSE);
            InsertDtldEmplLedgEntryUnapply(GenJnlLine, NewDtldEmplLedgEntry, DtldEmplLedgEntry2, NextDtldLedgEntryNo);

            DtldCVLedgEntryBuf.INIT;
            DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldEmplLedgEntry);
            SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
            CurrencyLCY.InitRoundingPrecision;
            UpdateTotalAmounts(TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf);
            DtldEmplLedgEntry2.Unapplied := TRUE;
            DtldEmplLedgEntry2."Unapplied by Entry No." := NewDtldEmplLedgEntry."Entry No.";
            DtldEmplLedgEntry2.MODIFY;

            UpdateEmplLedgEntry(DtldEmplLedgEntry2);
        UNTIL DtldEmplLedgEntry2.NEXT = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine, TempInvPostBuf, EmployeePostingGroup.GetPayablesAccount);

        IF IsTempGLEntryBufEmpty THEN
            DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);

        FinishPosting(GenJnlLine);
    END;

    LOCAL PROCEDURE UnapplyExcludedVAT(VAR TempVATEntry: Record 254 TEMPORARY; TransactionNo: Integer; VATBusPostingGroup: Code[20]; VATProdPostingGroup: Code[20]; GenProdPostingGroup: Code[20]);
    BEGIN
        TempVATEntry.SETRANGE("VAT Bus. Posting Group", VATBusPostingGroup);
        TempVATEntry.SETRANGE("VAT Prod. Posting Group", VATProdPostingGroup);
        TempVATEntry.SETRANGE("Gen. Prod. Posting Group", GenProdPostingGroup);
        IF NOT TempVATEntry.FINDFIRST THEN BEGIN
            TempVATEntry.RESET;
            IF TempVATEntry.FINDLAST THEN
                TempVATEntry."Entry No." := TempVATEntry."Entry No." + 1
            ELSE
                TempVATEntry."Entry No." := 1;
            TempVATEntry.INIT;
            TempVATEntry."VAT Bus. Posting Group" := VATBusPostingGroup;
            TempVATEntry."VAT Prod. Posting Group" := VATProdPostingGroup;
            TempVATEntry."Gen. Prod. Posting Group" := GenProdPostingGroup;
            VATEntry.SETCURRENTKEY("Transaction No.");
            VATEntry.SETRANGE("Transaction No.", TransactionNo);
            VATEntry.SETRANGE("VAT Bus. Posting Group", VATBusPostingGroup);
            VATEntry.SETRANGE("VAT Prod. Posting Group", VATProdPostingGroup);
            VATEntry.SETRANGE("Gen. Prod. Posting Group", GenProdPostingGroup);
            IF VATEntry.FINDSET THEN
                REPEAT
                    IF VATEntry."Unrealized VAT Entry No." = 0 THEN BEGIN
                        TempVATEntry.Base := TempVATEntry.Base + VATEntry.Base;
                        TempVATEntry.Amount := TempVATEntry.Amount + VATEntry.Amount;
                    END;
                UNTIL VATEntry.NEXT = 0;
            CLEAR(VATEntry);
            TempVATEntry.INSERT;
        END;
    END;

    LOCAL PROCEDURE PostUnrealVATByUnapply(GenJnlLine: Record 81; VATPostingSetup: Record 325; VATEntry: Record 254; NewVATEntry: Record 254): Integer;
    VAR
        VATEntry2: Record 254;
        AmountAddCurr: Decimal;
        GLEntryNoFromVAT: Integer;
    BEGIN
        AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date", VATEntry.Amount);
        CreateGLEntry(
          GenJnlLine, GetPostingAccountNo(VATPostingSetup, VATEntry, TRUE), VATEntry.Amount, AmountAddCurr, FALSE);
        GLEntryNoFromVAT :=
          CreateGLEntryFromVATEntry(
            GenJnlLine, GetPostingAccountNo(VATPostingSetup, VATEntry, FALSE), -VATEntry.Amount, -AmountAddCurr, VATEntry);

        WITH VATEntry2 DO BEGIN
            GET(VATEntry."Unrealized VAT Entry No.");
            "Remaining Unrealized Amount" := "Remaining Unrealized Amount" - NewVATEntry.Amount;
            "Remaining Unrealized Base" := "Remaining Unrealized Base" - NewVATEntry.Base;
            "Add.-Curr. Rem. Unreal. Amount" :=
              "Add.-Curr. Rem. Unreal. Amount" - NewVATEntry."Additional-Currency Amount";
            "Add.-Curr. Rem. Unreal. Base" :=
              "Add.-Curr. Rem. Unreal. Base" - NewVATEntry."Additional-Currency Base";
            MODIFY;
        END;

        EXIT(GLEntryNoFromVAT);
    END;

    LOCAL PROCEDURE PostPmtDiscountVATByUnapply(GenJnlLine: Record 81; ReverseChargeVATAccNo: Code[20]; VATAccNo: Code[20]; VATEntry: Record 254);
    VAR
        AmountAddCurr: Decimal;
    BEGIN
        AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date", VATEntry.Amount);
        CreateGLEntry(GenJnlLine, ReverseChargeVATAccNo, VATEntry.Amount, AmountAddCurr, FALSE);
        CreateGLEntry(GenJnlLine, VATAccNo, -VATEntry.Amount, -AmountAddCurr, FALSE);
    END;

    LOCAL PROCEDURE PostUnapply(GenJnlLine: Record 81; VAR VATEntry: Record 254; VATEntryType: Enum "General Posting Type"; BilltoPaytoNo: Code[20]; TransactionNo: Integer; UnapplyVATEntries: Boolean; VAR TempVATEntry: Record 254 TEMPORARY);
    VAR
        VATPostingSetup: Record 325;
        VATEntry2: Record 254;
        GLEntryVATEntryLink: Record 253;
        AccNo: Code[20];
        TempVATEntryNo: Integer;
        GLEntryNoFromVAT: Integer;
    BEGIN
        TempVATEntryNo := 1;
        VATEntry.SETCURRENTKEY(Type, "Bill-to/Pay-to No.", "Transaction No.");
        VATEntry.SETRANGE(Type, VATEntryType);
        VATEntry.SETRANGE("Bill-to/Pay-to No.", BilltoPaytoNo);
        VATEntry.SETRANGE("Transaction No.", TransactionNo);
        IF VATEntry.FINDSET THEN
            REPEAT
                VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                IF UnapplyVATEntries OR (VATEntry."Unrealized VAT Entry No." <> 0) THEN BEGIN
                    InsertTempVATEntry(GenJnlLine, VATEntry, TempVATEntryNo, TempVATEntry);
                    IF VATEntry."Unrealized VAT Entry No." <> 0 THEN BEGIN
                        VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                        IF VATPostingSetup."VAT Calculation Type" IN
                           [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                            VATPostingSetup."VAT Calculation Type"::"Full VAT"]
                        THEN
                            GLEntryNoFromVAT := PostUnrealVATByUnapply(GenJnlLine, VATPostingSetup, VATEntry, TempVATEntry)
                        ELSE
                            IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                GLEntryNoFromVAT := PostUnrealVATByUnapply(GenJnlLine, VATPostingSetup, VATEntry, TempVATEntry);
                                CreateGLEntry(
                                  GenJnlLine, VATPostingSetup.GetRevChargeAccount(TRUE),
                                  -VATEntry.Amount, CalcAddCurrForUnapplication(VATEntry."Posting Date", -VATEntry.Amount), FALSE);
                                CreateGLEntry(
                                  GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE),
                                  VATEntry.Amount, CalcAddCurrForUnapplication(VATEntry."Posting Date", VATEntry.Amount), FALSE);
                            END ELSE
                                GLEntryNoFromVAT := PostUnrealVATByUnapply(GenJnlLine, VATPostingSetup, VATEntry, TempVATEntry);
                        VATEntry2 := TempVATEntry;
                        VATEntry2."Entry No." := NextVATEntryNo;
                        OnPostUnapplyOnBeforeVATEntryInsert(VATEntry2, GenJnlLine, VATEntry);
                        VATEntry2.INSERT;
                        IF GLEntryNoFromVAT <> 0 THEN
                            GLEntryVATEntryLink.InsertLink(GLEntryNoFromVAT, VATEntry2."Entry No.");
                        GLEntryNoFromVAT := 0;
                        TempVATEntry.DELETE;
                        IncrNextVATEntryNo;
                    END;

                    IF VATPostingSetup."Adjust for Payment Discount" AND NOT IsNotPayment(VATEntry."Document Type") AND //enum to option
                       (VATPostingSetup."VAT Calculation Type" =
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") AND
                       (VATEntry."Unrealized VAT Entry No." = 0) AND UnapplyVATEntries AND (VATEntry.Amount <> 0)
                    THEN BEGIN
                        CASE VATEntryType OF
                            VATEntry.Type::Sale: //enum to option
                                AccNo := VATPostingSetup.GetSalesAccount(FALSE);
                            VATEntry.Type::Purchase: //enum to option
                                AccNo := VATPostingSetup.GetPurchAccount(FALSE);
                        END;
                        PostPmtDiscountVATByUnapply(GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), AccNo, VATEntry);
                    END;
                END;
            UNTIL VATEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcAddCurrForUnapplication(Date: Date; Amt: Decimal): Decimal;
    VAR
        AddCurrency: Record 4;
        CurrExchRate: Record 330;
    BEGIN
        IF AddCurrencyCode = '' THEN
            EXIT;

        AddCurrency.GET(AddCurrencyCode);
        AddCurrency.TESTFIELD("Amount Rounding Precision");

        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              Date, AddCurrencyCode, Amt, CurrExchRate.ExchangeRate(Date, AddCurrencyCode)),
            AddCurrency."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE CalcVATAmountFromVATEntry(AmountLCY: Decimal; VAR VATEntry: Record 254; CurrencyLCY: Record 4) VATAmountLCY: Decimal;
    BEGIN
        WITH VATEntry DO
            IF (AmountLCY = Base) OR (Base = 0) THEN BEGIN
                VATAmountLCY := Amount;
                DELETE;
            END ELSE BEGIN
                VATAmountLCY :=
                  ROUND(
                    Amount * AmountLCY / Base,
                    CurrencyLCY."Amount Rounding Precision",
                    CurrencyLCY.VATRoundingDirection);
                Base := Base - AmountLCY;
                Amount := Amount - VATAmountLCY;
                MODIFY;
            END;
    END;

    LOCAL PROCEDURE InsertDtldCustLedgEntryUnapply(GenJnlLine: Record 81; VAR NewDtldCustLedgEntry: Record 379; OldDtldCustLedgEntry: Record 379; VAR NextDtldLedgEntryNo: Integer);
    BEGIN
        NewDtldCustLedgEntry := OldDtldCustLedgEntry;
        WITH NewDtldCustLedgEntry DO BEGIN
            "Entry No." := NextDtldLedgEntryNo;
            "Posting Date" := GenJnlLine."Posting Date";
            "Transaction No." := NextTransactionNo;
            "Application No." := 0;
            Amount := -OldDtldCustLedgEntry.Amount;
            "Amount (LCY)" := -OldDtldCustLedgEntry."Amount (LCY)";
            "Debit Amount" := -OldDtldCustLedgEntry."Debit Amount";
            "Credit Amount" := -OldDtldCustLedgEntry."Credit Amount";
            "Debit Amount (LCY)" := -OldDtldCustLedgEntry."Debit Amount (LCY)";
            "Credit Amount (LCY)" := -OldDtldCustLedgEntry."Credit Amount (LCY)";
            Unapplied := TRUE;
            "Unapplied by Entry No." := OldDtldCustLedgEntry."Entry No.";
            "Document No." := GenJnlLine."Document No.";
            "Source Code" := GenJnlLine."Source Code";
            "User ID" := USERID;
            OnBeforeInsertDtldCustLedgEntryUnapply(NewDtldCustLedgEntry, GenJnlLine, OldDtldCustLedgEntry);
            INSERT(TRUE);
        END;
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    END;

    LOCAL PROCEDURE InsertDtldVendLedgEntryUnapply(GenJnlLine: Record 81; VAR NewDtldVendLedgEntry: Record 380; OldDtldVendLedgEntry: Record 380; VAR NextDtldLedgEntryNo: Integer);
    BEGIN
        NewDtldVendLedgEntry := OldDtldVendLedgEntry;
        WITH NewDtldVendLedgEntry DO BEGIN
            "Entry No." := NextDtldLedgEntryNo;
            "Posting Date" := GenJnlLine."Posting Date";
            "Transaction No." := NextTransactionNo;
            "Application No." := 0;
            Amount := -OldDtldVendLedgEntry.Amount;
            "Amount (LCY)" := -OldDtldVendLedgEntry."Amount (LCY)";
            "Debit Amount" := -OldDtldVendLedgEntry."Debit Amount";
            "Credit Amount" := -OldDtldVendLedgEntry."Credit Amount";
            "Debit Amount (LCY)" := -OldDtldVendLedgEntry."Debit Amount (LCY)";
            "Credit Amount (LCY)" := -OldDtldVendLedgEntry."Credit Amount (LCY)";
            Unapplied := TRUE;
            "Unapplied by Entry No." := OldDtldVendLedgEntry."Entry No.";
            "Document No." := GenJnlLine."Document No.";
            "Source Code" := GenJnlLine."Source Code";
            "User ID" := USERID;
            OnBeforeInsertDtldVendLedgEntryUnapply(NewDtldVendLedgEntry, GenJnlLine, OldDtldVendLedgEntry);
            INSERT(TRUE);
        END;
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    END;

    LOCAL PROCEDURE InsertDtldEmplLedgEntryUnapply(GenJnlLine: Record 81; VAR NewDtldEmplLedgEntry: Record 5223; OldDtldEmplLedgEntry: Record 5223; VAR NextDtldLedgEntryNo: Integer);
    BEGIN
        NewDtldEmplLedgEntry := OldDtldEmplLedgEntry;
        WITH NewDtldEmplLedgEntry DO BEGIN
            "Entry No." := NextDtldLedgEntryNo;
            "Posting Date" := GenJnlLine."Posting Date";
            "Transaction No." := NextTransactionNo;
            "Application No." := 0;
            Amount := -OldDtldEmplLedgEntry.Amount;
            "Amount (LCY)" := -OldDtldEmplLedgEntry."Amount (LCY)";
            "Debit Amount" := -OldDtldEmplLedgEntry."Debit Amount";
            "Credit Amount" := -OldDtldEmplLedgEntry."Credit Amount";
            "Debit Amount (LCY)" := -OldDtldEmplLedgEntry."Debit Amount (LCY)";
            "Credit Amount (LCY)" := -OldDtldEmplLedgEntry."Credit Amount (LCY)";
            Unapplied := TRUE;
            "Unapplied by Entry No." := OldDtldEmplLedgEntry."Entry No.";
            "Document No." := GenJnlLine."Document No.";
            "Source Code" := GenJnlLine."Source Code";
            "User ID" := USERID;
            OnBeforeInsertDtldEmplLedgEntryUnapply(NewDtldEmplLedgEntry, GenJnlLine, OldDtldEmplLedgEntry);
            INSERT(TRUE);
        END;
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    END;

    LOCAL PROCEDURE InsertTempVATEntry(GenJnlLine: Record 81; VATEntry: Record 254; VAR TempVATEntryNo: Integer; VAR TempVATEntry: Record 254 TEMPORARY);
    BEGIN
        TempVATEntry := VATEntry;
        WITH TempVATEntry DO BEGIN
            "Entry No." := TempVATEntryNo;
            TempVATEntryNo := TempVATEntryNo + 1;
            "Closed by Entry No." := 0;
            Closed := FALSE;
            CopyAmountsFromVATEntry(VATEntry, TRUE);
            "Posting Date" := GenJnlLine."Posting Date";
            "Document No." := GenJnlLine."Document No.";
            "User ID" := USERID;
            "Transaction No." := NextTransactionNo;
            OnInsertTempVATEntryOnBeforeInsert(TempVATEntry, GenJnlLine);
            INSERT;
        END;
    END;

    LOCAL PROCEDURE ProcessTempVATEntry(DtldCVLedgEntryBuf: Record 383; VAR TempVATEntry: Record 254 TEMPORARY);
    VAR
        VATEntrySaved: Record 254;
        VATBaseSum: ARRAY[3] OF Decimal;
        DeductedVATBase: Decimal;
        EntryNoBegin: ARRAY[3] OF Integer;
        i: Integer;
        SummarizedVAT: Boolean;
    BEGIN
        IF NOT (DtldCVLedgEntryBuf."Entry Type" IN
                [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)",
                 DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
                 DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"])
        THEN
            EXIT;

        DeductedVATBase := 0;
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Entry No.", 0, 999999);
        TempVATEntry.SETRANGE("Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Bus. Posting Group");
        TempVATEntry.SETRANGE("Gen. Prod. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
        TempVATEntry.SETRANGE("VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Bus. Posting Group");
        TempVATEntry.SETRANGE("VAT Prod. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
        IF TempVATEntry.FINDSET THEN
            REPEAT
                CASE TRUE OF
                    SummarizedVAT AND (VATBaseSum[3] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase):
                        i := 4;
                    SummarizedVAT AND (VATBaseSum[2] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase):
                        i := 3;
                    SummarizedVAT AND (VATBaseSum[1] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase):
                        i := 2;
                    TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                        i := 1;
                    ELSE
                        i := 0;
                END;
                IF i > 0 THEN BEGIN
                    TempVATEntry.RESET;
                    IF i > 1 THEN BEGIN
                        IF EntryNoBegin[i - 1] < TempVATEntry."Entry No." THEN
                            TempVATEntry.SETRANGE("Entry No.", EntryNoBegin[i - 1], TempVATEntry."Entry No.")
                        ELSE
                            TempVATEntry.SETRANGE("Entry No.", TempVATEntry."Entry No.", EntryNoBegin[i - 1]);
                    END ELSE
                        TempVATEntry.SETRANGE("Entry No.", TempVATEntry."Entry No.");
                    TempVATEntry.FINDSET;
                    REPEAT
                        VATEntrySaved := TempVATEntry;
                        CASE DtldCVLedgEntryBuf."Entry Type" OF
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                                TempVATEntry.RENAME(TempVATEntry."Entry No." + 3000000);
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                                TempVATEntry.RENAME(TempVATEntry."Entry No." + 2000000);
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                                TempVATEntry.RENAME(TempVATEntry."Entry No." + 1000000);
                        END;
                        TempVATEntry := VATEntrySaved;
                        DeductedVATBase += TempVATEntry.Base;
                    UNTIL TempVATEntry.NEXT = 0;
                    FOR i := 1 TO 3 DO BEGIN
                        VATBaseSum[i] := 0;
                        EntryNoBegin[i] := 0;
                        SummarizedVAT := FALSE;
                    END;
                    TempVATEntry.SETRANGE("Entry No.", 0, 999999);
                END ELSE BEGIN
                    VATBaseSum[3] += TempVATEntry.Base;
                    VATBaseSum[2] := VATBaseSum[1] + TempVATEntry.Base;
                    VATBaseSum[1] := TempVATEntry.Base;
                    IF EntryNoBegin[3] > 0 THEN
                        EntryNoBegin[3] := TempVATEntry."Entry No.";
                    EntryNoBegin[2] := EntryNoBegin[1];
                    EntryNoBegin[1] := TempVATEntry."Entry No.";
                    SummarizedVAT := TRUE;
                END;
            UNTIL TempVATEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessTempVATEntryCust(VAR DetailedCustLedgEntry: Record 379; VAR TempVATEntry: Record 254 TEMPORARY);
    VAR
        DetailedCVLedgEntryBuffer: Record 383;
    BEGIN
        IF NOT DetailedCustLedgEntry.FINDSET THEN
            EXIT;
        REPEAT
            DetailedCVLedgEntryBuffer.INIT;
            DetailedCVLedgEntryBuffer.TRANSFERFIELDS(DetailedCustLedgEntry);
            ProcessTempVATEntry(DetailedCVLedgEntryBuffer, TempVATEntry);
        UNTIL DetailedCustLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessTempVATEntryVend(VAR DetailedVendorLedgEntry: Record 380; VAR TempVATEntry: Record 254 TEMPORARY);
    VAR
        DetailedCVLedgEntryBuffer: Record 383;
    BEGIN
        IF NOT DetailedVendorLedgEntry.FINDSET THEN
            EXIT;
        REPEAT
            DetailedCVLedgEntryBuffer.INIT;
            DetailedCVLedgEntryBuffer.TRANSFERFIELDS(DetailedVendorLedgEntry);
            ProcessTempVATEntry(DetailedCVLedgEntryBuffer, TempVATEntry);
        UNTIL DetailedVendorLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateCustLedgEntry(DtldCustLedgEntry: Record 379; GenJnlLine: Record 81);
    VAR
        CustLedgEntry: Record 21;
    BEGIN
        IF DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::Application THEN
            EXIT;

        CustLedgEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.");
        CustLedgEntry."Remaining Pmt. Disc. Possible" := DtldCustLedgEntry."Remaining Pmt. Disc. Possible";
        CustLedgEntry."Max. Payment Tolerance" := DtldCustLedgEntry."Max. Payment Tolerance";
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        IF NOT CustLedgEntry.Open THEN BEGIN
            CustLedgEntry.Open := TRUE;
            CustLedgEntry."Closed by Entry No." := 0;
            CustLedgEntry."Closed at Date" := 0D;
            CustLedgEntry."Closed by Amount" := 0;
            CustLedgEntry."Closed by Amount (LCY)" := 0;
            CustLedgEntry."Closed by Currency Code" := '';
            CustLedgEntry."Closed by Currency Amount" := 0;
            CustLedgEntry."Pmt. Disc. Given (LCY)" := 0;
            CustLedgEntry."Pmt. Tolerance (LCY)" := 0;
            CustLedgEntry."Calculate Interest" := FALSE;
        END;

        OnBeforeCustLedgEntryModify(CustLedgEntry, DtldCustLedgEntry);
        CustLedgEntry.MODIFY;

        IF CarteraSetup.READPERMISSION THEN
            DocPost.UpdateUnAppliedReceivableDoc(CustLedgEntry, GenJnlLine);
    END;

    LOCAL PROCEDURE UpdateVendLedgEntry(DtldVendLedgEntry: Record 380; GenJnlLine: Record 81);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        IF DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."Entry Type"::Application THEN
            EXIT;

        VendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");
        VendLedgEntry."Remaining Pmt. Disc. Possible" := DtldVendLedgEntry."Remaining Pmt. Disc. Possible";
        VendLedgEntry."Max. Payment Tolerance" := DtldVendLedgEntry."Max. Payment Tolerance";
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        IF NOT VendLedgEntry.Open THEN BEGIN
            VendLedgEntry.Open := TRUE;
            VendLedgEntry."Closed by Entry No." := 0;
            VendLedgEntry."Closed at Date" := 0D;
            VendLedgEntry."Closed by Amount" := 0;
            VendLedgEntry."Closed by Amount (LCY)" := 0;
            VendLedgEntry."Closed by Currency Code" := '';
            VendLedgEntry."Closed by Currency Amount" := 0;
            VendLedgEntry."Pmt. Disc. Rcd.(LCY)" := 0;
            VendLedgEntry."Pmt. Tolerance (LCY)" := 0;
        END;

        OnBeforeVendLedgEntryModify(VendLedgEntry, DtldVendLedgEntry);
        VendLedgEntry.MODIFY;

        IF CarteraSetup.READPERMISSION THEN
            DocPost.UpdateUnAppliedPayableDoc(VendLedgEntry, GenJnlLine, DocLock);
    END;

    LOCAL PROCEDURE UpdateEmplLedgEntry(DtldEmplLedgEntry: Record 5223);
    VAR
        EmplLedgEntry: Record 5222;
    BEGIN
        IF DtldEmplLedgEntry."Entry Type" <> DtldEmplLedgEntry."Entry Type"::Application THEN
            EXIT;

        EmplLedgEntry.GET(DtldEmplLedgEntry."Employee Ledger Entry No.");
        IF NOT EmplLedgEntry.Open THEN BEGIN
            EmplLedgEntry.Open := TRUE;
            EmplLedgEntry."Closed by Entry No." := 0;
            EmplLedgEntry."Closed at Date" := 0D;
            EmplLedgEntry."Closed by Amount" := 0;
            EmplLedgEntry."Closed by Amount (LCY)" := 0;
        END;

        OnBeforeEmplLedgEntryModify(EmplLedgEntry, DtldEmplLedgEntry);
        EmplLedgEntry.MODIFY;
    END;

    LOCAL PROCEDURE UpdateCalcInterest(VAR CVLedgEntryBuf: Record 382);
    VAR
        CustLedgEntry: Record 21;
        CVLedgEntryBuf2: Record 382;
    BEGIN
        WITH CVLedgEntryBuf DO BEGIN
            IF CustLedgEntry.GET("Closed by Entry No.") THEN BEGIN
                CVLedgEntryBuf2.TRANSFERFIELDS(CustLedgEntry);
                UpdateCalcInterest2(CVLedgEntryBuf, CVLedgEntryBuf2);
            END;
            CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
            CustLedgEntry.SETRANGE("Closed by Entry No.", "Entry No.");
            IF CustLedgEntry.FINDSET THEN
                REPEAT
                    CVLedgEntryBuf2.TRANSFERFIELDS(CustLedgEntry);
                    UpdateCalcInterest2(CVLedgEntryBuf, CVLedgEntryBuf2);
                UNTIL CustLedgEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateCalcInterest2(VAR CVLedgEntryBuf: Record 382; VAR CVLedgEntryBuf2: Record 382);
    BEGIN
        WITH CVLedgEntryBuf DO
            IF "Due Date" < CVLedgEntryBuf2."Document Date" THEN
                "Calculate Interest" := TRUE;
    END;

    LOCAL PROCEDURE GLCalcAddCurrency(Amount: Decimal; AddCurrAmount: Decimal; OldAddCurrAmount: Decimal; UseAddCurrAmount: Boolean; GenJnlLine: Record 81): Decimal;
    BEGIN
        IF (AddCurrencyCode <> '') AND
           (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None)
        THEN BEGIN
            IF (GenJnlLine."Source Currency Code" = AddCurrencyCode) AND UseAddCurrAmount THEN
                EXIT(AddCurrAmount);

            EXIT(ExchangeAmtLCYToFCY2(Amount));
        END;
        EXIT(OldAddCurrAmount);
    END;

    LOCAL PROCEDURE HandleAddCurrResidualGLEntry(GenJnlLine: Record 81; GLEntry2: Record 17);
    VAR
        GLAcc: Record 15;
        GLEntry: Record 17;
    BEGIN
        IF AddCurrencyCode = '' THEN
            EXIT;

        TotalAddCurrAmount := TotalAddCurrAmount + GLEntry2."Additional-Currency Amount";
        TotalAmount := TotalAmount + GLEntry2.Amount;

        IF (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None) AND
           (TotalAmount = 0) AND (TotalAddCurrAmount <> 0) AND
           CheckNonAddCurrCodeOccurred(GenJnlLine."Source Currency Code")
        THEN BEGIN
            GLEntry.INIT;
            GLEntry.CopyFromGenJnlLine(GenJnlLine);
            GLEntry."External Document No." := '';
            GLEntry.Description :=
              COPYSTR(
                STRSUBSTNO(
                  ResidualRoundingErr,
                  GLEntry.FIELDCAPTION("Additional-Currency Amount")),
                1, MAXSTRLEN(GLEntry.Description));
            GLEntry."Source Type" := Enum::"Gen. Journal Source Type".FromInteger(0);
            GLEntry."Source No." := '';
            GLEntry."Job No." := '';
            GLEntry.Quantity := 0;
            GLEntry."Entry No." := NextEntryNo;
            GLEntry."Transaction No." := NextTransactionNo;
            IF TotalAddCurrAmount < 0 THEN
                GLEntry."G/L Account No." := AddCurrency."Residual Losses Account"
            ELSE
                GLEntry."G/L Account No." := AddCurrency."Residual Gains Account";
            GLEntry.Amount := 0;
            GLEntry."System-Created Entry" := TRUE;
            GLEntry."Additional-Currency Amount" := -TotalAddCurrAmount;
            GLAcc.GET(GLEntry."G/L Account No.");
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);
            InsertGLEntry(GenJnlLine, GLEntry, FALSE);

            CheckGLAccDimError(GenJnlLine, GLEntry."G/L Account No.");

            TotalAddCurrAmount := 0;
        END;

        OnAfterHandleAddCurrResidualGLEntry(GenJnlLine, GLEntry2);
    END;

    LOCAL PROCEDURE CalcLCYToAddCurr(AmountLCY: Decimal): Decimal;
    BEGIN
        IF AddCurrencyCode = '' THEN
            EXIT;

        EXIT(ExchangeAmtLCYToFCY2(AmountLCY));
    END;

    LOCAL PROCEDURE GetCurrencyExchRate(GenJnlLine: Record 81);
    VAR
        NewCurrencyDate: Date;
    BEGIN
        IF AddCurrencyCode = '' THEN
            EXIT;

        AddCurrency.GET(AddCurrencyCode);
        AddCurrency.TESTFIELD("Amount Rounding Precision");
        AddCurrency.TESTFIELD("Residual Gains Account");
        AddCurrency.TESTFIELD("Residual Losses Account");

        NewCurrencyDate := GenJnlLine."Posting Date";
        IF GenJnlLine."Reversing Entry" THEN
            NewCurrencyDate := NewCurrencyDate - 1;
        IF (NewCurrencyDate <> CurrencyDate) OR
           UseCurrFactorOnly
        THEN BEGIN
            UseCurrFactorOnly := FALSE;
            CurrencyDate := NewCurrencyDate;
            CurrencyFactor :=
              CurrExchRate.ExchangeRate(CurrencyDate, AddCurrencyCode);
        END;
        IF (GenJnlLine."FA Add.-Currency Factor" <> 0) AND
           (GenJnlLine."FA Add.-Currency Factor" <> CurrencyFactor)
        THEN BEGIN
            UseCurrFactorOnly := TRUE;
            CurrencyDate := 0D;
            CurrencyFactor := GenJnlLine."FA Add.-Currency Factor";
        END;
    END;

    LOCAL PROCEDURE ExchangeAmtLCYToFCY2(Amount: Decimal): Decimal;
    BEGIN
        IF UseCurrFactorOnly THEN
            EXIT(
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCYOnlyFactor(Amount, CurrencyFactor),
                AddCurrency."Amount Rounding Precision"));
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              CurrencyDate, AddCurrencyCode, Amount, CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE CheckNonAddCurrCodeOccurred(CurrencyCode: Code[10]): Boolean;
    BEGIN
        NonAddCurrCodeOccured :=
          NonAddCurrCodeOccured OR (AddCurrencyCode <> CurrencyCode);
        EXIT(NonAddCurrCodeOccured);
    END;

    //[External]
    PROCEDURE SetGLRegReverse(VAR ReverseGLReg: Record 45);
    BEGIN
        GLReg.Reversed := TRUE;
        ReverseGLReg := GLReg;
    END;

    LOCAL PROCEDURE InsertVATEntriesFromTemp(VAR DtldCVLedgEntryBuf: Record 383; GLEntry: Record 17);
    VAR
        Complete: Boolean;
        LinkedAmount: Decimal;
        FirstEntryNo: Integer;
        LastEntryNo: Integer;
    BEGIN
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Gen. Bus. Posting Group", GLEntry."Gen. Bus. Posting Group");
        TempVATEntry.SETRANGE("Gen. Prod. Posting Group", GLEntry."Gen. Prod. Posting Group");
        TempVATEntry.SETRANGE("VAT Bus. Posting Group", GLEntry."VAT Bus. Posting Group");
        TempVATEntry.SETRANGE("VAT Prod. Posting Group", GLEntry."VAT Prod. Posting Group");
        CASE DtldCVLedgEntryBuf."Entry Type" OF
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                BEGIN
                    FirstEntryNo := 1000000;
                    LastEntryNo := 1999999;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                BEGIN
                    FirstEntryNo := 2000000;
                    LastEntryNo := 2999999;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                BEGIN
                    FirstEntryNo := 3000000;
                    LastEntryNo := 3999999;
                END;
        END;
        TempVATEntry.SETRANGE("Entry No.", FirstEntryNo, LastEntryNo);
        IF TempVATEntry.FINDSET THEN
            REPEAT
                VATEntry := TempVATEntry;
                VATEntry."Entry No." := NextVATEntryNo;
                VATEntry.INSERT(TRUE);
                NextVATEntryNo := NextVATEntryNo + 1;
                IF VATEntry."Unrealized VAT Entry No." = 0 THEN
                    GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.", VATEntry."Entry No.");
                LinkedAmount += VATEntry.Amount + VATEntry.Base;
                Complete := LinkedAmount = -(DtldCVLedgEntryBuf."Amount (LCY)" + DtldCVLedgEntryBuf."VAT Amount (LCY)");
                LastEntryNo := TempVATEntry."Entry No.";
            UNTIL Complete OR (TempVATEntry.NEXT = 0);

        TempVATEntry.SETRANGE("Entry No.", FirstEntryNo, LastEntryNo);
        TempVATEntry.DELETEALL;
    END;

    //[External]
    PROCEDURE ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal;
    BEGIN
        IF ABS(Decimal1) < ABS(Decimal2) THEN
            EXIT(Decimal1);
        EXIT(Decimal2);
    END;

    LOCAL PROCEDURE GetApplnRoundPrecision(NewCVLedgEntryBuf: Record 382; OldCVLedgEntryBuf: Record 382): Decimal;
    VAR
        ApplnCurrency: Record 4;
        CurrencyCode: Code[10];
    BEGIN
        IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
            CurrencyCode := NewCVLedgEntryBuf."Currency Code"
        ELSE
            CurrencyCode := OldCVLedgEntryBuf."Currency Code";
        IF CurrencyCode = '' THEN
            EXIT(0);
        ApplnCurrency.GET(CurrencyCode);
        IF ApplnCurrency."Appln. Rounding Precision" <> 0 THEN
            EXIT(ApplnCurrency."Appln. Rounding Precision");
        EXIT(GLSetup."Appln. Rounding Precision");
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF GLSetupRead THEN
            EXIT;

        GLSetup.GET;
        GLSetupRead := TRUE;

        AddCurrencyCode := GLSetup."Additional Reporting Currency";
    END;

    LOCAL PROCEDURE ReadGLSetup(VAR NewGLSetup: Record 98);
    BEGIN
        NewGLSetup := GLSetup;
    END;

    LOCAL PROCEDURE CheckSalesExtDocNo(GenJnlLine: Record 81);
    VAR
        SalesSetup: Record 311;
    BEGIN
        SalesSetup.GET;
        IF NOT SalesSetup."Ext. Doc. No. Mandatory" THEN
            EXIT;

        IF GenJnlLine."Document Type" IN
           [GenJnlLine."Document Type"::Invoice,
            GenJnlLine."Document Type"::"Credit Memo",
            GenJnlLine."Document Type"::Payment,
            GenJnlLine."Document Type"::Refund,
            GenJnlLine."Document Type"::" "]
        THEN
            GenJnlLine.TESTFIELD("External Document No.");
    END;

    LOCAL PROCEDURE CheckPurchExtDocNo(GenJnlLine: Record 81);
    VAR
        PurchSetup: Record 312;
        OldVendLedgEntry: Record 25;
        VendorMgt: Codeunit 1312;
    BEGIN
        PurchSetup.GET;
        IF NOT (PurchSetup."Ext. Doc. No. Mandatory" OR (GenJnlLine."External Document No." <> '')) THEN
            EXIT;

        GenJnlLine.TESTFIELD("External Document No.");
        OldVendLedgEntry.RESET;
        VendorMgt.SetFilterForExternalDocNo(
          OldVendLedgEntry, GenJnlLine."Document Type", GenJnlLine."External Document No.",
          GenJnlLine."Account No.", GenJnlLine."Document Date");
        IF NOT OldVendLedgEntry.ISEMPTY THEN
            ERROR(
              PurchaseAlreadyExistsErr,
              GenJnlLine."Document Type", GenJnlLine."External Document No.");
    END;

    LOCAL PROCEDURE CheckDimValueForDisposal(GenJnlLine: Record 81; AccountNo: Code[20]);
    VAR
        DimMgt: Codeunit 408;
        DimMgt1: Codeunit 50361;
        TableID: ARRAY[10] OF Integer;
        AccNo: ARRAY[10] OF Code[20];
    BEGIN
        IF ((GenJnlLine.Amount = 0) OR (GenJnlLine."Amount (LCY)" = 0)) AND
           (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal)
        THEN BEGIN
            TableID[1] := DimMgt1.TypeToTableID1(GenJnlLine."Account Type"::"G/L Account"); //enum to option
            AccNo[1] := AccountNo;
            IF NOT DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
                ERROR(DimMgt.GetDimValuePostingErr);
        END;
    END;

    //[External]
    PROCEDURE SetOverDimErr();
    BEGIN
        OverrideDimErr := TRUE;
    END;

    LOCAL PROCEDURE CheckGLAccDimError(GenJnlLine: Record 81; GLAccNo: Code[20]);
    VAR
        DimMgt: Codeunit 408;
        TableID: ARRAY[10] OF Integer;
        AccNo: ARRAY[10] OF Code[20];
    BEGIN
        OnBeforeCheckGLAccDimError(GenJnlLine, GLAccNo);

        IF (GenJnlLine.Amount = 0) AND (GenJnlLine."Amount (LCY)" = 0) THEN
            EXIT;

        TableID[1] := DATABASE::"G/L Account";
        AccNo[1] := GLAccNo;
        IF DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
            EXIT;

        IF GenJnlLine."Line No." <> 0 THEN
            ERROR(
              DimensionUsedErr,
              GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
              GenJnlLine."Journal Batch Name", GenJnlLine."Line No.",
              DimMgt.GetDimValuePostingErr);

        ERROR(DimMgt.GetDimValuePostingErr);
    END;

    LOCAL PROCEDURE CalculateCurrentBalance(AccountNo: Code[20]; BalAccountNo: Code[20]; InclVATAmount: Boolean; AmountLCY: Decimal; VATAmount: Decimal);
    BEGIN
        IF (AccountNo <> '') AND (BalAccountNo <> '') THEN
            EXIT;

        IF AccountNo = BalAccountNo THEN
            EXIT;

        IF NOT InclVATAmount THEN
            VATAmount := 0;

        IF BalAccountNo <> '' THEN
            CurrentBalance -= AmountLCY + VATAmount
        ELSE
            CurrentBalance += AmountLCY + VATAmount;
    END;

    LOCAL PROCEDURE GetCurrency(VAR Currency: Record 4; CurrencyCode: Code[10]);
    BEGIN
        IF Currency.Code <> CurrencyCode THEN BEGIN
            IF CurrencyCode = '' THEN
                CLEAR(Currency)
            ELSE
                Currency.GET(CurrencyCode);
        END;
    END;

    LOCAL PROCEDURE CollectAdjustment(VAR AdjAmount: ARRAY[4] OF Decimal; Amount: Decimal; AmountAddCurr: Decimal);
    VAR
        Offset: Integer;
    BEGIN
        Offset := GetAdjAmountOffset(Amount, AmountAddCurr);
        AdjAmount[Offset] += Amount;
        AdjAmount[Offset + 1] += AmountAddCurr;
    END;

    LOCAL PROCEDURE HandleDtldAdjustment(GenJnlLine: Record 81; VAR GLEntry: Record 17; AdjAmount: ARRAY[4] OF Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAccNo: Code[20]);
    BEGIN
        IF NOT PostDtldAdjustment(
             GenJnlLine, GLEntry, AdjAmount,
             TotalAmountLCY, TotalAmountAddCurr, GLAccNo,
             GetAdjAmountOffset(TotalAmountLCY, TotalAmountAddCurr))
        THEN
            InitGLEntry(GenJnlLine, GLEntry, GLAccNo, TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
    END;

    LOCAL PROCEDURE PostDtldAdjustment(GenJnlLine: Record 81; VAR GLEntry: Record 17; AdjAmount: ARRAY[4] OF Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAcc: Code[20]; ArrayIndex: Integer): Boolean;
    BEGIN
        IF (GenJnlLine."Bal. Account No." <> '') AND
           ((AdjAmount[ArrayIndex] <> 0) OR (AdjAmount[ArrayIndex + 1] <> 0)) AND
           ((TotalAmountLCY + AdjAmount[ArrayIndex] <> 0) OR (TotalAmountAddCurr + AdjAmount[ArrayIndex + 1] <> 0))
        THEN BEGIN
            CreateGLEntryBalAcc(
              GenJnlLine, GLAcc, -AdjAmount[ArrayIndex], -AdjAmount[ArrayIndex + 1],
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No."); //enum to option
            InitGLEntry(GenJnlLine, GLEntry,
              GLAcc, TotalAmountLCY + AdjAmount[ArrayIndex],
              TotalAmountAddCurr + AdjAmount[ArrayIndex + 1], TRUE, TRUE);
            AdjAmount[ArrayIndex] := 0;
            AdjAmount[ArrayIndex + 1] := 0;
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetAdjAmountOffset(Amount: Decimal; AmountACY: Decimal): Integer;
    BEGIN
        IF (Amount > 0) OR (Amount = 0) AND (AmountACY > 0) THEN
            EXIT(1);
        EXIT(3);
    END;

    //[External]
    PROCEDURE GetNextEntryNo(): Integer;
    BEGIN
        EXIT(NextEntryNo);
    END;

    //[External]
    PROCEDURE GetNextTransactionNo(): Integer;
    BEGIN
        EXIT(NextTransactionNo);
    END;

    //[External]
    PROCEDURE GetNextVATEntryNo(): Integer;
    BEGIN
        EXIT(NextVATEntryNo);
    END;

    //[External]
    PROCEDURE IncrNextVATEntryNo();
    BEGIN
        NextVATEntryNo := NextVATEntryNo + 1;
    END;

    LOCAL PROCEDURE IsNotPayment(DocumentType: Enum "Gen. Journal Document Type"): Boolean;
    BEGIN
        EXIT(DocumentType IN [DocumentType::Invoice,
                              DocumentType::"Credit Memo",
                              DocumentType::"Finance Charge Memo",
                              DocumentType::Reminder]);
    END;

    LOCAL PROCEDURE IsTempGLEntryBufEmpty(): Boolean;
    BEGIN
        EXIT(TempGLEntryBuf.ISEMPTY);
    END;

    LOCAL PROCEDURE IsVATAdjustment(EntryType: Enum "Detailed CV Ledger Entry Type"): Boolean;
    VAR
        DtldCVLedgEntryBuf: Record 383;
    BEGIN
        EXIT(EntryType IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)", //enum to option
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)", //enum to option
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]); //enum to option
    END;

    LOCAL PROCEDURE IsVATExcluded(EntryType: Enum "Detailed CV Ledger Entry Type"): Boolean;
    VAR
        DtldCVLedgEntryBuf: Record 383;
    BEGIN
        EXIT(EntryType IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)", //enum to option
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)", //enum to option
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"]); //enum to option
    END;

    PROCEDURE GetSellToBuyFrom(GenJnlLine: Record 81; VAR VATEntry: Record 254);
    VAR
        GenJnlLine2: Record 81;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF "Bill-to/Pay-to No." <> '' THEN BEGIN
                VATEntry."Bill-to/Pay-to No." := "Bill-to/Pay-to No.";
                EXIT;
            END;

            IF "Bal. Account Type" IN ["Bal. Account Type"::"IC Partner", "Bal. Account Type"::Employee] THEN
                EXIT;

            // Find in the current transaction the customer/vendor this VAT entry is linked to
            GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Transaction No.");
            GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
            GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
            GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
            GenJnlLine2.SETRANGE("Transaction No.", "Transaction No.");
            GenJnlLine2.SETFILTER(
              "Document Type",
              '%1|%2|%3',
              GenJnlLine2."Document Type"::Invoice,
              GenJnlLine2."Document Type"::"Credit Memo",
              GenJnlLine2."Document Type"::"Finance Charge Memo");
            GenJnlLine2.SETRANGE("Document No.", "Document No.");
            CASE VATEntry.Type OF
                VATEntry.Type::Sale:
                    GenJnlLine2.SETRANGE("Account Type", GenJnlLine2."Account Type"::Customer);
                VATEntry.Type::Purchase:
                    GenJnlLine2.SETRANGE("Account Type", GenJnlLine2."Account Type"::Vendor);
                ELSE
                    EXIT;
            END;
            IF NOT GenJnlLine2.FIND('-') OR (GenJnlLine2.NEXT <> 0) THEN
                EXIT;

            IF GenJnlLine2."Bill-to/Pay-to No." <> '' THEN
                VATEntry."Bill-to/Pay-to No." := GenJnlLine2."Bill-to/Pay-to No."
            ELSE
                VATEntry."Bill-to/Pay-to No." := GenJnlLine2."Account No.";
        END;
    END;

    LOCAL PROCEDURE PostPayableDocs(GenJnlLine: Record 81; VendPostingGr: Record 93);
    VAR
        GLAccNo: Code[20];
    BEGIN
        IF (DocAmountLCY <> 0) OR (CollDocAmountLCY <> 0) THEN
            IF NextEntryNo2 = NextEntryNo THEN
                NextEntryNo := NextEntryNo - 1;
        IF DocAmountLCY <> 0 THEN BEGIN
            GLAccNo := GetGLAccountForPayablesDocs(GenJnlLine, VendPostingGr, DocAmountLCY, CollDocAmountLCY);

            //JAV 13/01/22: - QB 1.10.09 Cambiar cuenta del confirming    JAV 18/01/22: - QB 1.10.11 Se cambia de lugar por estar mal ubicado
            //QBTableSubscriber.T93_ChangeVendorConfirmingAccount(GenJnlLine."Payment Method Code", VendPostingGr.Code, GLAccNo);
            //fin QB 1.10.09

            CreateGLEntryBalAcc(GenJnlLine,
              GLAccNo, DocAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, DocAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No."); //enum to option
        END;
        IF CollDocAmountLCY <> 0 THEN BEGIN
            GLAccNo := GetGLAccountForPayablesDocs(GenJnlLine, VendPostingGr, 0, CollDocAmountLCY);

            //JAV 18/01/22: - QB 1.10.11 Cambiar cuenta del confirming. Se cambia de lugar por estar mal ubicado
            //EPV 07/04/22: Se utiliza la cuenta de confirming si se recircula una factura o si se trata de un pago.
            //              Una factura que no se lleve a una Orden de pago (Confirming) no deber�a tener forma de pago con tipo "Confirming Proveedor".
            IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice) AND (GenJnlLine."QB Redrawing")) OR
               (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) THEN
                //EPV 07/04/22 --> Fin.
                QBTableSubscriber.T93_ChangeVendorConfirmingAccount(GenJnlLine."Payment Method Code", VendPostingGr.Code, GLAccNo);
            //fin QB 1.10.09

            CreateGLEntryBalAcc(GenJnlLine,
              GLAccNo, CollDocAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, CollDocAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");//enum to option
        END;
        EXIT;
    END;

    LOCAL PROCEDURE PostReceivableDocs(GenJnlLine: Record 81; CustPostingGr: Record 92);
    VAR
        DocAmountAddCurr: Decimal;
        GLAccNo: Code[20];
    BEGIN
        IF (DocAmountLCY <> 0) OR (DiscDocAmountLCY <> 0) OR (CollDocAmountLCY <> 0) OR (RejDocAmountLCY <> 0) OR
           (DiscRiskFactAmountLCY <> 0) OR (DiscUnriskFactAmountLCY <> 0) OR (CollFactAmountLCY <> 0)
        THEN
            IF NextEntryNo2 = NextEntryNo THEN
                NextEntryNo := NextEntryNo - 1;
        IF DocAmountLCY <> 0 THEN BEGIN
            IF GenJnlLine."Currency Code" = AddCurrency.Code THEN
                DocAmountAddCurr := GenJnlLine.Amount
            ELSE
                DocAmountAddCurr := DocAmtCalcAddCurrency(GenJnlLine, DocAmountLCY);
            GLAccNo := GetGLAccountForReceivableDocs(GenJnlLine, CustPostingGr, DocAmountLCY, CollDocAmountLCY);
            CreateGLEntryBalAcc(
              GenJnlLine, GLAccNo, DocAmountLCY, DocAmountAddCurr,
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");//enum to option
        END;
        IF DiscDocAmountLCY <> 0 THEN BEGIN
            CustPostingGr.TESTFIELD("Discted. Bills Acc.");

            //JAV 13/01/22: - QB 1.10.09 Cambiar las cuentas para el confirming si es necesario
            QBTableSubscriber.T92_ChangeCustomerConfirmingAccount(GenJnlLine, CustPostingGr."Discted. Bills Acc.");
            //FIN QB 1.10.09

            CreateGLEntryBalAcc(GenJnlLine,
              CustPostingGr."Discted. Bills Acc.", DiscDocAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, DiscDocAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
        END;
        IF CollDocAmountLCY <> 0 THEN BEGIN
            GLAccNo := GetGLAccountForReceivableDocs(GenJnlLine, CustPostingGr, 0, CollDocAmountLCY);
            CreateGLEntryBalAcc(GenJnlLine,
              GLAccNo, CollDocAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, CollDocAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");//enum to option
        END;
        IF RejDocAmountLCY <> 0 THEN BEGIN
            TempRejCustLedgEntry.RESET;
            TempRejCustLedgEntry.SETCURRENTKEY("Customer No.", "Document Type", "Document Situation", "Document Status");
            TempRejCustLedgEntry.SETRANGE("Document Type", TempRejCustLedgEntry."Document Type"::Bill);
            TempRejCustLedgEntry.CALCSUMS("Remaining Amount (LCY) stats.");
            IF TempRejCustLedgEntry."Remaining Amount (LCY) stats." <> 0 THEN BEGIN
                CustPostingGr.TESTFIELD("Rejected Bills Acc.");
                CreateGLEntryBalAcc(GenJnlLine,
                  CustPostingGr."Rejected Bills Acc.",
                  TempRejCustLedgEntry."Remaining Amount (LCY) stats.",
                  DocAmtCalcAddCurrency(GenJnlLine, TempRejCustLedgEntry."Remaining Amount (LCY) stats."),
                  GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
            END;
            TempRejCustLedgEntry.SETRANGE("Document Type", TempRejCustLedgEntry."Document Type"::Invoice);
            TempRejCustLedgEntry.CALCSUMS(TempRejCustLedgEntry."Remaining Amount (LCY) stats.");
            IF TempRejCustLedgEntry."Remaining Amount (LCY) stats." <> 0 THEN BEGIN
                CustPostingGr.TESTFIELD("Rejected Factoring Acc.");
                CreateGLEntryBalAcc(GenJnlLine,
                  CustPostingGr."Rejected Factoring Acc.",
                  TempRejCustLedgEntry."Remaining Amount (LCY) stats.",
                  DocAmtCalcAddCurrency(GenJnlLine, TempRejCustLedgEntry."Remaining Amount (LCY) stats."),
                  GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
            END;
        END;
        IF DiscRiskFactAmountLCY <> 0 THEN BEGIN
            CustPostingGr.TESTFIELD("Factoring for Discount Acc.");
            CreateGLEntryBalAcc(GenJnlLine,
              CustPostingGr."Factoring for Discount Acc.",
              DiscRiskFactAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, DiscRiskFactAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
        END;
        IF DiscUnriskFactAmountLCY <> 0 THEN BEGIN
            CustPostingGr.TESTFIELD("Factoring for Discount Acc.");
            CreateGLEntryBalAcc(GenJnlLine,
              CustPostingGr."Factoring for Discount Acc.",
              DiscUnriskFactAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, DiscUnriskFactAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
        END;
        IF CollFactAmountLCY <> 0 THEN BEGIN
            CustPostingGr.TESTFIELD("Factoring for Collection Acc.");
            CreateGLEntryBalAcc(GenJnlLine,
              CustPostingGr."Factoring for Collection Acc.",
              CollFactAmountLCY, DocAmtCalcAddCurrency(GenJnlLine, CollFactAmountLCY),
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
        END;
    END;

    PROCEDURE DocAmtCalcAddCurrency(GenJnlLine: Record 81; Amount: Decimal): Decimal;
    BEGIN
        IF (AddCurrencyCode <> '') AND
           (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None)
        THEN
            EXIT(ROUND(ExchangeAmtLCYToFCY2(Amount), AddCurrency."Amount Rounding Precision"));

        EXIT(Amount);
    END;

    PROCEDURE SendDocToCartera(GenJnlLine3: Record 81; VAR VendLedgEntry4: Record 25; VAR CustLedgEntry4: Record 21; DocType: Option "Sale","Purchase"; VAR CVLedgEntryBuf4: Record 382);
    VAR
        PaymentMethod: Record 289;
    BEGIN
        WITH GenJnlLine3 DO BEGIN
            IF (NOT PaymentMethod.GET("Payment Method Code")) OR
               (NOT PaymentMethod."Invoices to Cartera") OR
               (Amount = 0) OR (CVLedgEntryBuf4."Remaining Amount" = 0)
            THEN
                EXIT;
            CASE "Document Type" OF
                "Document Type"::Invoice:
                    BEGIN
                        Description :=
                          COPYSTR(
                            STRSUBSTNO(Text1100006, "Document No."),
                            1,
                            MAXSTRLEN(Description));
                        "Bill No." := '1';
                        CASE DocType OF
                            DocType::Purchase:
                                BEGIN
                                    DocPost.CreatePayableDoc(GenJnlLine3, CVLedgEntryBuf4, BillFromJournal);
                                    VendLedgEntry4."Document Situation" := VendLedgEntry4."Document Situation"::Cartera;
                                    VendLedgEntry4."Document Status" := VendLedgEntry4."Document Status"::Open;
                                END;
                            DocType::Sale:
                                BEGIN
                                    DocPost.CreateReceivableDoc(GenJnlLine3, CVLedgEntryBuf4, BillFromJournal);
                                    CustLedgEntry4."Document Situation" := CustLedgEntry4."Document Situation"::Cartera;
                                    CustLedgEntry4."Document Status" := CustLedgEntry4."Document Status"::Open;
                                END;
                        END;
                    END;
            END;
        END;
    END;

    //[External]
    PROCEDURE VendFindVATSetup(VAR VATSetup: Record 325; VendLedgEntry4: Record 25; IsFromJournal: Boolean): Boolean;
    VAR
        Vendor: Record 23;
        ProdPostingGroup: Code[20];
        PurchLine2: Record 123;
        Text1100003: TextConst ENU = 'Unrealized VAT Type must be "Percentage" in VAT Posting Setup.', ESP = 'Tipo IVA no realizado debe ser porcentaje en configuraci¢n grupo registro IVA.';
        ErrorMessage: Boolean;
        ExistsVATNoReal: Boolean;
        GLEntry: Record 17;
        BusPostingGroup: Code[20];
    BEGIN
        ErrorMessage := FALSE;
        ExistsVATNoReal := FALSE;
        Vendor.GET(VendLedgEntry4."Vendor No.");

        VATSetup.SETCURRENTKEY("VAT Bus. Posting Group", "VAT Prod. Posting Group");
        IF IsFromJournal THEN BEGIN
            GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            GLEntry.SETRANGE("Document No.", VendLedgEntry4."Document No.");
            IF GLEntry.FINDFIRST THEN BEGIN
                BusPostingGroup := GLEntry."VAT Bus. Posting Group";
                ProdPostingGroup := GLEntry."VAT Prod. Posting Group";
                VATSetup.SETRANGE("VAT Bus. Posting Group", BusPostingGroup);
                VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                    IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                        ErrorMessage := TRUE
                    ELSE
                        ExistsVATNoReal := TRUE;
            END;
        END ELSE BEGIN
            PurchLine2.SETRANGE("Document No.", VendLedgEntry4."Document No.");
            PurchLine2.SETFILTER(Type, '<>%1', 0);

            //JAV 18/10/20: - QB 1.06.21 Si no existe la factura no puede tener IVA no realizado
            IF PurchLine2.ISEMPTY THEN
                EXIT(FALSE);
            //JAV fin

            PurchLine2.FIND('-');
            BusPostingGroup := PurchLine2."VAT Bus. Posting Group";
            VATSetup.SETRANGE("VAT Bus. Posting Group", BusPostingGroup);

            REPEAT
                CASE PurchLine2.Type OF
                    //QB 16/07/20 JAV - Tiene que mirar tambi�n las de recurso y activo para liberar el IVA no realizado
                    PurchLine2.Type::Resource, PurchLine2.Type::"Fixed Asset",
                    //QB
                    PurchLine2.Type::Item:
                        BEGIN
                            ProdPostingGroup := PurchLine2."VAT Prod. Posting Group";
                            VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                            IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                                IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                                    ErrorMessage := TRUE
                                ELSE
                                    ExistsVATNoReal := TRUE;
                        END;
                    PurchLine2.Type::"G/L Account":
                        BEGIN
                            ProdPostingGroup := PurchLine2."VAT Prod. Posting Group";
                            VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                            IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                                IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                                    ErrorMessage := TRUE
                                ELSE
                                    ExistsVATNoReal := TRUE;
                        END;
                END;
            UNTIL PurchLine2.NEXT = 0;
        END;

        IF ErrorMessage THEN
            ERROR(Text1100003);
        EXIT(ExistsVATNoReal);
    END;

    //[External]
    PROCEDURE CustFindVATSetup(VAR VATSetup: Record 325; CustLedgEntry4: Record 21; IsFromJournal: Boolean): Boolean;
    VAR
        Customer: Record 18;
        ProdPostingGroup: Code[20];
        SalesLine2: Record 113;
        ErrorMessage: Boolean;
        ExistsVATNoReal: Boolean;
        Text1100003: TextConst ENU = 'Unrealized VAT Type must be "Percentage" in VAT Posting Setup.', ESP = 'Tipo IVA no realizado debe ser porcentaje en configuraci¢n grupo registro IVA.';
        GLEntry: Record 17;
        BusPostingGroup: Code[20];
    BEGIN
        ErrorMessage := FALSE;
        ExistsVATNoReal := FALSE;
        Customer.GET(CustLedgEntry4."Customer No.");

        VATSetup.SETCURRENTKEY("VAT Bus. Posting Group", "VAT Prod. Posting Group");
        IF IsFromJournal THEN BEGIN
            GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            GLEntry.SETRANGE("Document No.", CustLedgEntry4."Document No.");
            IF GLEntry.FINDFIRST THEN BEGIN
                BusPostingGroup := GLEntry."VAT Bus. Posting Group";
                ProdPostingGroup := GLEntry."VAT Prod. Posting Group";
                VATSetup.SETRANGE("VAT Bus. Posting Group", BusPostingGroup);
                VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                    IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                        ErrorMessage := TRUE
                    ELSE
                        ExistsVATNoReal := TRUE;
            END;
        END ELSE BEGIN
            SalesLine2.SETRANGE("Document No.", CustLedgEntry4."Document No.");
            SalesLine2.SETFILTER(Type, '<>%1', 0);
            IF SalesLine2.FIND('-') THEN;
            BusPostingGroup := SalesLine2."VAT Bus. Posting Group";
            VATSetup.SETRANGE("VAT Bus. Posting Group", BusPostingGroup);
            REPEAT
                CASE SalesLine2.Type OF
                    SalesLine2.Type::Item:
                        BEGIN
                            ProdPostingGroup := SalesLine2."VAT Prod. Posting Group";
                            VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                            IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                                IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                                    ErrorMessage := TRUE
                                ELSE
                                    ExistsVATNoReal := TRUE;
                        END;
                    SalesLine2.Type::Resource:
                        BEGIN
                            ProdPostingGroup := SalesLine2."VAT Prod. Posting Group";
                            VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                            IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                                IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                                    ErrorMessage := TRUE
                                ELSE
                                    ExistsVATNoReal := TRUE;
                        END;
                    SalesLine2.Type::"G/L Account":
                        BEGIN
                            ProdPostingGroup := SalesLine2."VAT Prod. Posting Group";
                            VATSetup.SETRANGE("VAT Prod. Posting Group", ProdPostingGroup);
                            IF VATSetup.FIND('-') AND (VATSetup."Unrealized VAT Type" >= VATSetup."Unrealized VAT Type"::Percentage) THEN
                                IF VATSetup."Unrealized VAT Type" > VATSetup."Unrealized VAT Type"::Percentage THEN
                                    ErrorMessage := TRUE
                                ELSE
                                    ExistsVATNoReal := TRUE;
                        END;
                END;
            UNTIL SalesLine2.NEXT = 0;
        END;

        IF ErrorMessage THEN
            ERROR(Text1100003);
        EXIT(ExistsVATNoReal);
    END;

    PROCEDURE SetFromSettlement(FromBillSettlement2: Boolean);
    BEGIN
        FromBillSettlement := FromBillSettlement2;
    END;

    PROCEDURE SetIDBillSettlement(IDBillSettlement2: Boolean);
    BEGIN
        IDBillSettlement := IDBillSettlement2;
    END;

    PROCEDURE SetBillFromJournal(BillFromJournal2: Boolean);
    BEGIN
        BillFromJournal := BillFromJournal2;
    END;

    PROCEDURE UpdateCustLedgEntryStats(CustLedgEntryNo: Integer);
    VAR
        CustLedgEntry: Record 21;
    BEGIN
        IF CustLedgEntry.GET(CustLedgEntryNo) THEN;
        CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)", "Amount (LCY)");

        CustLedgEntry."Remaining Amount (LCY) stats." := CustLedgEntry."Remaining Amt. (LCY)";
        CustLedgEntry."Amount (LCY) stats." := CustLedgEntry."Amount (LCY)";
        CustLedgEntry.MODIFY;
    END;

    PROCEDURE UpdateVendLedgEntryStats(VendLedgEntryNo: Integer);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        IF VendLedgEntry.GET(VendLedgEntryNo) THEN;
        VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)", "Amount (LCY)");

        VendLedgEntry."Remaining Amount (LCY) stats." := VendLedgEntry."Remaining Amt. (LCY)";
        VendLedgEntry."Amount (LCY) stats." := VendLedgEntry."Amount (LCY)";
        VendLedgEntry.MODIFY;
    END;

    PROCEDURE UpdateEmplLedgEntryStats(EmplLedgEntryNo: Integer);
    VAR
        EmplLedgEntry: Record 5222;
    BEGIN
        IF EmplLedgEntry.GET(EmplLedgEntryNo) THEN;
        EmplLedgEntry.CALCFIELDS("Remaining Amt. (LCY)", "Amount (LCY)");
        // Employees don't have the stats.
    END;

    LOCAL PROCEDURE CheckCarteraPostDtldCustLE(GenJnlLine2: Record 81; DtldCustLedgEntry3: Record 379; ReceivableAccAmtLCY: Decimal; ReceivableAccAmtAddCurr: Decimal; CreateBills: Boolean): Boolean;
    VAR
        IsOK: Boolean;
    BEGIN
        IsOK := FALSE;
        IF ((GenJnlLine2."Applies-to Doc. Type" = GenJnlLine2."Applies-to Doc. Type"::Bill) OR
            ((GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Payment) AND
             (DtldCustLedgEntry3."Initial Document Type" = DtldCustLedgEntry3."Initial Document Type"::Bill) AND
             (GenJnlLine2."Applies-to ID" <> ''))) AND (NOT IDBillSettlement)
        THEN
            SetFromSettlement(TRUE);

        WITH DtldCustLedgEntry3 DO
            CASE "Entry Type" OF
                "Entry Type"::"Initial Entry":
                    IF "Initial Document Type" = "Initial Document Type"::Bill THEN
                        IF "Document Type" = "Document Type"::Bill THEN
                            IF BillFromJournal THEN
                                IsOK := TRUE;
                "Entry Type"::Application:
                    IF (NOT FromBillSettlement) AND (NOT IDBillSettlement) THEN
                        IF (("Document Type" <> "Document Type"::"Credit Memo") AND (GenJnlLine2."Applies-to ID" <> '')) OR
                           CreateBills
                        THEN BEGIN
                            IF "Initial Document Type" = "Initial Document Type"::Bill THEN
                                IsOK := TRUE;
                            IF "Initial Document Type" = "Initial Document Type"::Invoice THEN
                                IF "Document Situation" = "Document Situation"::"Closed BG/PO" THEN
                                    IF "Document Status" = "Document Status"::Rejected THEN
                                        IsOK := TRUE;
                        END;
                ELSE BEGIN
                    IF CustLedgEntryInserted2 OR (ReceivableAccAmtLCY <> 0) OR (ReceivableAccAmtAddCurr <> 0)
                       AND (AddCurrencyCode <> '')
                    THEN
                        IF (NOT FromBillSettlement) OR (ReceivableAccAmtLCY < 0) OR (ReceivableAccAmtAddCurr < 0) THEN
                            IF NOT BillFromJournal THEN
                                IsOK := TRUE;
                END;
            END;

        CLEAR(CustLedgEntryInserted2);
        CLEAR(DtldCustLedgEntry3);
        CLEAR(GenJnlLine2);

        EXIT(IsOK);
    END;

    LOCAL PROCEDURE CheckCarteraPostDtldVendLE(GenJnlLine2: Record 81; DtldVendLedgEntry3: Record 380; PayableAccAmtLCY: Decimal; PayableAccAmtAddCurr: Decimal; CreateBills: Boolean): Boolean;
    VAR
        IsOK: Boolean;
    BEGIN
        IsOK := FALSE;
        IF ((GenJnlLine2."Applies-to Doc. Type" = GenJnlLine2."Applies-to Doc. Type"::Bill) OR
            ((GenJnlLine2."Document Type" = GenJnlLine2."Document Type"::Payment) AND
             (DtldVendLedgEntry3."Initial Document Type" = DtldVendLedgEntry3."Initial Document Type"::Bill) AND
             (GenJnlLine2."Applies-to ID" <> ''))) AND (NOT IDBillSettlement)
        THEN
            SetFromSettlement(TRUE);

        WITH DtldVendLedgEntry3 DO
            CASE "Entry Type" OF
                "Entry Type"::Application:
                    IF (NOT FromBillSettlement) AND (NOT IDBillSettlement) THEN
                        IF (("Document Type" <> "Document Type"::"Credit Memo") AND (GenJnlLine2."Applies-to ID" <> '')) OR
                           CreateBills
                        THEN BEGIN
                            IF "Initial Document Type" = "Initial Document Type"::Bill THEN
                                IsOK := TRUE;
                        END;
                ELSE BEGIN
                    IF VendLedgEntryInserted2 OR (PayableAccAmtLCY <> 0) OR (PayableAccAmtAddCurr <> 0)
                       AND (AddCurrencyCode <> '')
                    THEN
                        IF (NOT FromBillSettlement) OR (PayableAccAmtLCY <> 0) OR (PayableAccAmtAddCurr <> 0) THEN
                            IsOK := TRUE;
                END;
            END;

        CLEAR(VendLedgEntryInserted2);
        CLEAR(DtldVendLedgEntry3);
        CLEAR(GenJnlLine2);

        EXIT(IsOK);
    END;

    PROCEDURE IsOriginalEntryExist(GenJnlLine: Record 81): Boolean;
    VAR
        CustLedgerEntry1: Record 21;
        VendLedgerEntry1: Record 25;
    BEGIN
        IF (GenJnlLine."Applies-to Doc. Type" = GenJnlLine."Applies-to Doc. Type"::Bill) AND
           (GenJnlLine."Applies-to Doc. No." <> '')
        THEN
            EXIT(TRUE);

        IF GenJnlLine."Applies-to ID" <> '' THEN BEGIN
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
                CustLedgerEntry1.RESET;
                CustLedgerEntry1.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                CustLedgerEntry1.SETRANGE("Document Type", CustLedgerEntry1."Document Type"::"Credit Memo");
                IF CustLedgerEntry1.FINDFIRST THEN
                    IsCreditMemo := TRUE;
                CustLedgerEntry1.RESET;
                CustLedgerEntry1.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                CustLedgerEntry1.SETRANGE("Document Type", CustLedgerEntry1."Document Type"::Bill);
                IF CustLedgerEntry1.FINDFIRST THEN
                    EXIT(TRUE);
                CustLedgerEntry1.RESET;
                CustLedgerEntry1.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                CustLedgerEntry1.SETRANGE("Document Type", CustLedgerEntry1."Document Type"::Invoice);
                CustLedgerEntry1.SETRANGE("Document Situation", CustLedgerEntry1."Document Situation"::"Closed BG/PO");
                CustLedgerEntry1.SETRANGE("Document Status", CustLedgerEntry1."Document Status"::Rejected);
                IF CustLedgerEntry1.FINDFIRST THEN
                    EXIT(TRUE);
            END;

            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                VendLedgerEntry1.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                VendLedgerEntry1.SETRANGE("Document Type", VendLedgerEntry1."Document Type"::Bill);
                IF VendLedgerEntry1.FINDFIRST THEN
                    EXIT(TRUE);
            END;
        END;
    END;

    PROCEDURE SetTotalAmountForTax(TotalAmountForTax2: Decimal);
    BEGIN
        TotalAmountForTax := TotalAmountForTax2;
    END;

    LOCAL PROCEDURE GetVendOriginalAmtLCY(UnrealVendLedgEntry: Record 25; BillVendLedgEntry: Record 25; InvVendLedgEntry: Record 25): Decimal;
    BEGIN
        IF IsVendBillDoc(UnrealVendLedgEntry) THEN
            EXIT(BillVendLedgEntry."Original Amt. (LCY)");
        EXIT(InvVendLedgEntry."Amount (LCY)");
    END;

    LOCAL PROCEDURE GetCustOriginalAmtLCY(UnrealCustLedgEntry: Record 21; BillCustLedgEntry: Record 21; InvCustLedgEntry: Record 21): Decimal;
    BEGIN
        IF IsCustBillDoc(UnrealCustLedgEntry) THEN
            EXIT(BillCustLedgEntry."Original Amt. (LCY)");
        EXIT(InvCustLedgEntry."Amount (LCY)");
    END;

    LOCAL PROCEDURE GetVendSettledAmount(SettledAmt: Decimal; UnrealVendLedgEntry: Record 25; BillVendLedgEntry: Record 25; InvVendLedgEntry: Record 25): Decimal;
    BEGIN
        IF IsVendBillDoc(UnrealVendLedgEntry) THEN
            EXIT(ROUND(SettledAmt / BillVendLedgEntry.GetOriginalCurrencyFactor));
        EXIT(ROUND(SettledAmt / InvVendLedgEntry.GetAdjustedCurrencyFactor));
    END;

    LOCAL PROCEDURE GetCustSettledAmount(SettledAmt: Decimal; UnrealCustLedgEntry: Record 21; BillCustLedgEntry: Record 21; InvCustLedgEntry: Record 21): Decimal;
    BEGIN
        IF IsCustBillDoc(UnrealCustLedgEntry) THEN
            EXIT(ROUND(SettledAmt / BillCustLedgEntry.GetOriginalCurrencyFactor));
        EXIT(ROUND(SettledAmt / InvCustLedgEntry.GetAdjustedCurrencyFactor));
    END;

    LOCAL PROCEDURE GetGLAccountForPayablesDocs(GenJnlLine: Record 81; VendPostingGr: Record 93; DocAmountLCY: Decimal; CollDocAmountLCY: Decimal): Code[20];
    BEGIN
        IF GenJnlLine."Applies-to Doc. Type" = GenJnlLine."Applies-to Doc. Type"::Invoice THEN BEGIN
            IF DocAmountLCY <> 0 THEN
                EXIT(VendPostingGr.GetPayablesAccount);
            EXIT(VendPostingGr.GetInvoicesInPmtOrderAccount);
        END;
        IF (DocAmountLCY = 0) OR ((DocAmountLCY <> 0) AND (CollDocAmountLCY <> 0)) THEN
            EXIT(VendPostingGr.GetBillsInPmtOrderAccount);
        EXIT(VendPostingGr.GetBillsAccount);
    END;

    LOCAL PROCEDURE GetGLAccountForReceivableDocs(GenJnlLine: Record 81; CustPostingGr: Record 92; DocAmountLCY: Decimal; CollDocAmountLCY: Decimal): Code[20];
    BEGIN
        IF GenJnlLine."Applies-to Doc. Type" = GenJnlLine."Applies-to Doc. Type"::Invoice THEN
            EXIT(CustPostingGr.GetReceivablesAccount);

        //JAV 13/01/22: - QB 1.10.09 Cambiar las cuentas para el confirming si es necesario
        QBTableSubscriber.T92_ChangeCustomerConfirmingAccount(GenJnlLine, AccNo);
        //-Q20318
        //IF (AccNo <> '') THEN
        IF (AccNo <> '') AND (GenJnlLine."QB Confirming") THEN
            //-Q20318
            EXIT(AccNo);
        //FIN QB 1.10.09

        IF (DocAmountLCY = 0) OR ((DocAmountLCY <> 0) AND (CollDocAmountLCY <> 0)) THEN
            EXIT(CustPostingGr.GetBillsOnCollAccount);
        EXIT(CustPostingGr.GetBillsAccount(FALSE));
    END;

    LOCAL PROCEDURE IsVendBillDoc(UnrealVendLedgEntry: Record 25): Boolean;
    BEGIN
        EXIT(UnrealVendLedgEntry."Document Type" = UnrealVendLedgEntry."Document Type"::Bill);
    END;

    LOCAL PROCEDURE IsCustBillDoc(UnrealCustLedgEntry: Record 21): Boolean;
    BEGIN
        EXIT(UnrealCustLedgEntry."Document Type" = UnrealCustLedgEntry."Document Type"::Bill);
    END;

    LOCAL PROCEDURE CalcVendRealizedVATAmt(VAR VATBase: Decimal; VAR VATAmount: Decimal; VAR VATBaseAddCurr: Decimal; VAR VATAmountAddCurr: Decimal; VATEntry2: Record 254; UnrealVendLedgEntry: Record 25; VATPart: Decimal);
    BEGIN
        CalcRealizedVATAmt(
          VATBase, VATAmount,
          VATBaseAddCurr, VATAmountAddCurr,
          VATEntry2,
          IsVendBillDoc(UnrealVendLedgEntry),
          VATPart);
    END;

    LOCAL PROCEDURE CalcRealizedVATAmt(VAR VATBase: Decimal; VAR VATAmount: Decimal; VAR VATBaseAddCurr: Decimal; VAR VATAmountAddCurr: Decimal; VATEntry2: Record 254; UseUnrealAmt: Boolean; VATPart: Decimal);
    VAR
        UnrealAmt: Decimal;
        UnrealBase: Decimal;
        UnrealAmtACY: Decimal;
        UnrealBaseACY: Decimal;
    BEGIN
        WITH VATEntry2 DO
            IF UseUnrealAmt THEN BEGIN
                UnrealAmt := "Unrealized Amount";
                UnrealBase := "Unrealized Base";
                UnrealAmtACY := "Add.-Currency Unrealized Amt.";
                UnrealBaseACY := "Add.-Currency Unrealized Base";
            END ELSE BEGIN
                UnrealAmt := "Remaining Unrealized Amount";
                UnrealBase := "Remaining Unrealized Base";
                UnrealAmtACY := "Add.-Curr. Rem. Unreal. Amount";
                UnrealBaseACY := "Add.-Curr. Rem. Unreal. Base";
            END;
        VATAmount := ROUND(UnrealAmt * VATPart, GLSetup."Amount Rounding Precision");
        VATBase := ROUND(UnrealBase * VATPart, GLSetup."Amount Rounding Precision");
        VATAmountAddCurr := ROUND(UnrealAmtACY * VATPart, AddCurrency."Amount Rounding Precision");
        VATBaseAddCurr := ROUND(UnrealBaseACY * VATPart, AddCurrency."Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CalcInvPostBufferTotals(VAR TempInvPostBuf: Record 49);
    VAR
        TotalAmount: Decimal;
        TotalAmountACY: Decimal;
    BEGIN
        TotalAmount := 0;
        TotalAmountACY := 0;

        WITH TempInvPostBuf DO BEGIN
            RESET;
            IF FINDSET THEN
                REPEAT
                    TotalAmount += Amount;
                    TotalAmountACY += "Amount (ACY)";
                UNTIL NEXT = 0;
            Amount := TotalAmount;
            "Amount (ACY)" := TotalAmountACY;
        END;
    END;

    LOCAL PROCEDURE CheckCarteraDocStatus(DocNo: Code[20]; BillNo: Code[20]): Boolean;
    VAR
        CustLedgEntry: Record 21;
    BEGIN
        WITH CustLedgEntry DO BEGIN
            SETCURRENTKEY("Document No.", "Bill No.");
            SETRANGE("Document No.", DocNo);
            SETRANGE("Bill No.", BillNo);
            IF FINDFIRST THEN
                IF ("Document Status" = "Document Status"::Rejected) OR
                   ("Document Status" = "Document Status"::Redrawn)
                THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE UpdateGLEntryNo(VAR GLEntryNo: Integer; VAR SavedEntryNo: Integer);
    BEGIN
        IF SavedEntryNo <> 0 THEN BEGIN
            GLEntryNo := SavedEntryNo;
            NextEntryNo := NextEntryNo - 1;
            NextEntryNo2 := NextEntryNo;
            SavedEntryNo := 0;
        END;
    END;

    LOCAL PROCEDURE UpdateTotalAmounts(VAR TempInvPostBuf: Record 49 TEMPORARY; DimSetID: Integer; DtldCVLedgEntryBuf: Record 383);
    VAR
        IsHandled: Boolean;
    BEGIN
        OnBeforeUpdateTotalAmounts(
          TempInvPostBuf, DimSetID, DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount", IsHandled,
          DtldCVLedgEntryBuf);
        IF IsHandled THEN
            EXIT;

        WITH TempInvPostBuf DO BEGIN
            SETRANGE("Dimension Set ID", DimSetID);
            IF FINDFIRST THEN BEGIN
                Amount += DtldCVLedgEntryBuf."Amount (LCY)";
                "Amount (ACY)" += DtldCVLedgEntryBuf."Additional-Currency Amount";
                MODIFY;
            END ELSE BEGIN
                INIT;
                "Dimension Set ID" := DimSetID;
                Amount := DtldCVLedgEntryBuf."Amount (LCY)";
                "Amount (ACY)" := DtldCVLedgEntryBuf."Additional-Currency Amount";
                INSERT;
            END;
        END;
    END;

    LOCAL PROCEDURE CreateGLEntriesForTotalAmountsUnapply(GenJnlLine: Record 81; VAR TempInvPostBuf: Record 49 TEMPORARY; Account: Code[20]);
    VAR
        DimMgt: Codeunit 408;
    BEGIN
        WITH TempInvPostBuf DO BEGIN
            SETRANGE("Dimension Set ID");
            IF FINDSET THEN
                REPEAT
                    IF (Amount <> 0) OR
                       ("Amount (ACY)" <> 0) AND (GLSetup."Additional Reporting Currency" <> '')
                    THEN BEGIN
                        DimMgt.UpdateGenJnlLineDim(GenJnlLine, "Dimension Set ID");
                        CreateGLEntry(GenJnlLine, Account, Amount, "Amount (ACY)", TRUE);
                    END;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CreateGLEntriesForTotalAmounts(GenJnlLine: Record 81; VAR InvPostBuf: Record 49; AdjAmountBuf: ARRAY[4] OF Decimal; SavedEntryNo: Integer; GLAccNo: Code[20]);
    VAR
        DimMgt: Codeunit 408;
    BEGIN
        OnBeforeCreateGLEntriesForTotalAmounts(InvPostBuf, GenJnlLine, GLAccNo);

        WITH InvPostBuf DO
            IF (Amount = 0) AND ("Amount (ACY)" = 0) AND (GenJnlLine."Applies-to ID" = '') THEN BEGIN
                DimMgt.UpdateGenJnlLineDim(GenJnlLine, "Dimension Set ID");
                CreateGLEntryForTotalAmounts(GenJnlLine, Amount, "Amount (ACY)", AdjAmountBuf, SavedEntryNo, GLAccNo);
            END;
    END;

    LOCAL PROCEDURE CreateGLEntryForTotalAmounts(GenJnlLine: Record 81; Amount: Decimal; AmountACY: Decimal; AdjAmountBuf: ARRAY[4] OF Decimal; VAR SavedEntryNo: Integer; GLAccNo: Code[20]);
    VAR
        GLEntry: Record 17;
    BEGIN
        HandleDtldAdjustment(GenJnlLine, GLEntry, AdjAmountBuf, Amount, AmountACY, GLAccNo);
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        UpdateGLEntryNo(GLEntry."Entry No.", SavedEntryNo);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    END;

    LOCAL PROCEDURE CheckCarteraAccessPermissions(DocumentSituation: Enum "ES Document Situation");
    BEGIN
        IF (DocumentSituation <> DocumentSituation::" ") AND (NOT CarteraSetup.READPERMISSION) THEN
            ERROR(Text1100013);
    END;

    LOCAL PROCEDURE FinancialVoidWithMethodCreateBills(GenJnlLine: Record 81): Boolean;
    VAR
        Vendor: Record 23;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF NOT ("Financial Void" AND ("Account Type" = "Account Type"::Vendor)) THEN
                EXIT(FALSE);
            Vendor.GET("Account No.");
        END;

        EXIT(GetPaymentMethodCreateBills(Vendor."Payment Method Code"));
    END;

    LOCAL PROCEDURE SetAddCurrForUnapplication(VAR DtldCVLedgEntryBuf: Record 383);
    BEGIN
        WITH DtldCVLedgEntryBuf DO
            IF NOT ("Entry Type" IN ["Entry Type"::Application, "Entry Type"::"Unrealized Loss",
                                     "Entry Type"::"Unrealized Gain", "Entry Type"::"Realized Loss",
                                     "Entry Type"::"Realized Gain", "Entry Type"::"Correction of Remaining Amount"])
            THEN
                IF ("Entry Type" = "Entry Type"::"Appln. Rounding") OR
                   ((AddCurrencyCode <> '') AND (AddCurrencyCode = "Currency Code"))
                THEN
                    "Additional-Currency Amount" := Amount
                ELSE
                    "Additional-Currency Amount" := CalcAddCurrForUnapplication("Posting Date", "Amount (LCY)");
    END;

    LOCAL PROCEDURE PostDeferral(VAR GenJournalLine: Record 81; AccountNo: Code[20]);
    VAR
        DeferralTemplate: Record 1700;
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        GLEntry: Record 17;
        CurrExchRate: Record 330;
        DeferralUtilities: Codeunit 1720;
        PerPostDate: Date;
        PeriodicCount: Integer;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        EmptyDeferralLine: Boolean;
    BEGIN
        OnBeforePostDeferral(GenJournalLine, AccountNo);

        WITH GenJournalLine DO BEGIN
            IF "Source Type" IN ["Source Type"::Vendor, "Source Type"::Customer] THEN
                // Purchasing and Sales, respectively
                // We can create these types directly from the GL window, need to make sure we don't already have a deferral schedule
                // created for this GL Trx before handing it off to sales/purchasing subsystem
                IF "Source Code" <> GLSourceCode THEN BEGIN
                    PostDeferralPostBuffer(GenJournalLine);
                    EXIT;
                END;

            IF DeferralHeader.GET(DeferralDocType::"G/L", "Journal Template Name", "Journal Batch Name", 0, '', "Line No.") THEN BEGIN
                EmptyDeferralLine := FALSE;
                // Get the range of detail records for this schedule
                DeferralUtilities.FilterDeferralLines(
                  DeferralLine, DeferralDocType::"G/L", "Journal Template Name", "Journal Batch Name", 0, '', "Line No.");
                IF DeferralLine.FINDSET THEN
                    REPEAT
                        IF DeferralLine.Amount = 0.0 THEN
                            EmptyDeferralLine := TRUE;
                    UNTIL (DeferralLine.NEXT = 0) OR EmptyDeferralLine;
                IF EmptyDeferralLine THEN
                    ERROR(ZeroDeferralAmtErr, "Line No.", "Deferral Code");
                DeferralHeader."Amount to Defer (LCY)" :=
                  ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code",
                      DeferralHeader."Amount to Defer", "Currency Factor"));
                DeferralHeader.MODIFY;
            END;

            DeferralUtilities.RoundDeferralAmount(
              DeferralHeader,
              "Currency Code", "Currency Factor", "Posting Date", AmtToDefer, AmtToDeferACY);

            DeferralTemplate.GET("Deferral Code");
            DeferralTemplate.TESTFIELD("Deferral Account");
            DeferralTemplate.TESTFIELD("Deferral %");

            // Get the Deferral Header table so we know the amount to defer...
            // Assume straight GL posting
            IF DeferralHeader.GET(DeferralDocType::"G/L", "Journal Template Name", "Journal Batch Name", 0, '', "Line No.") THEN
                // Get the range of detail records for this schedule
                DeferralUtilities.FilterDeferralLines(
            DeferralLine, DeferralDocType::"G/L", "Journal Template Name", "Journal Batch Name", 0, '', "Line No.")
            ELSE
                ERROR(NoDeferralScheduleErr, "Line No.", "Deferral Code");

            InitGLEntry(
              GenJournalLine, GLEntry, AccountNo,
              -DeferralHeader."Amount to Defer (LCY)", -DeferralHeader."Amount to Defer", TRUE, TRUE);
            GLEntry.Description := Description;
            InsertGLEntry(GenJournalLine, GLEntry, TRUE);

            InitGLEntry(
              GenJournalLine, GLEntry, DeferralTemplate."Deferral Account",
              DeferralHeader."Amount to Defer (LCY)", DeferralHeader."Amount to Defer", TRUE, TRUE);
            GLEntry.Description := Description;
            InsertGLEntry(GenJournalLine, GLEntry, TRUE);

            // Here we want to get the Deferral Details table range and loop through them...
            IF DeferralLine.FINDSET THEN BEGIN
                PeriodicCount := 1;
                REPEAT
                    PerPostDate := DeferralLine."Posting Date";
                    IF GenJnlCheckLine.DateNotAllowed(PerPostDate) THEN
                        ERROR(InvalidPostingDateErr, PerPostDate);

                    InitGLEntry(
                      GenJournalLine, GLEntry, AccountNo,
                      DeferralLine."Amount (LCY)", DeferralLine.Amount, TRUE, TRUE);
                    GLEntry."Posting Date" := PerPostDate;
                    GLEntry.Description := DeferralLine.Description;
                    InsertGLEntry(GenJournalLine, GLEntry, TRUE);

                    InitGLEntry(
                      GenJournalLine, GLEntry, DeferralTemplate."Deferral Account",
                      -DeferralLine."Amount (LCY)", -DeferralLine.Amount, TRUE, TRUE);
                    GLEntry."Posting Date" := PerPostDate;
                    GLEntry.Description := DeferralLine.Description;
                    InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                    PeriodicCount := PeriodicCount + 1;
                UNTIL DeferralLine.NEXT = 0;
            END ELSE
                ERROR(NoDeferralScheduleErr, "Line No.", "Deferral Code");
        END;

        OnAfterPostDeferral(GenJournalLine, TempGLEntryBuf, AccountNo);
    END;

    LOCAL PROCEDURE PostDeferralPostBuffer(GenJournalLine: Record 81);
    VAR
        DeferralPostBuffer: Record 1706;
        GLEntry: Record 17;
        PostDate: Date;
    BEGIN
        WITH GenJournalLine DO BEGIN
            IF "Source Type" = "Source Type"::Customer THEN
                DeferralDocType := DeferralDocType::Sales
            ELSE
                DeferralDocType := DeferralDocType::Purchase;

            DeferralPostBuffer.SETRANGE("Deferral Doc. Type", DeferralDocType);
            DeferralPostBuffer.SETRANGE("Document No.", "Document No.");
            DeferralPostBuffer.SETRANGE("Deferral Line No.", "Deferral Line No.");

            IF DeferralPostBuffer.FINDSET THEN BEGIN
                REPEAT
                    PostDate := DeferralPostBuffer."Posting Date";
                    IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                        ERROR(InvalidPostingDateErr, PostDate);

                    // When no sales/purch amount is entered, the offset was already posted
                    IF (DeferralPostBuffer."Sales/Purch Amount" <> 0) OR (DeferralPostBuffer."Sales/Purch Amount (LCY)" <> 0) THEN BEGIN
                        InitGLEntry(GenJournalLine, GLEntry, DeferralPostBuffer."G/L Account",
                          DeferralPostBuffer."Sales/Purch Amount (LCY)",
                          DeferralPostBuffer."Sales/Purch Amount",
                          TRUE, TRUE);
                        GLEntry."Posting Date" := PostDate;
                        GLEntry.Description := DeferralPostBuffer.Description;
                        GLEntry.CopyFromDeferralPostBuffer(DeferralPostBuffer);
                        InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                    END;

                    IF DeferralPostBuffer.Amount <> 0 THEN BEGIN
                        InitGLEntry(GenJournalLine, GLEntry,
                          DeferralPostBuffer."Deferral Account",
                          -DeferralPostBuffer."Amount (LCY)",
                          -DeferralPostBuffer.Amount,
                          TRUE, TRUE);
                        GLEntry."Posting Date" := PostDate;
                        GLEntry.Description := DeferralPostBuffer.Description;
                        InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                    END;
                UNTIL DeferralPostBuffer.NEXT = 0;
                DeferralPostBuffer.DELETEALL;
            END;
        END;
    END;

    //[External]
    PROCEDURE RemoveDeferralSchedule(GenJournalLine: Record 81);
    VAR
        DeferralUtilities: Codeunit 1720;
        DeferralDocType: Option "Purchase","Sales","G/L";
    BEGIN
        // Removing deferral schedule after all deferrals for this line have been posted successfully
        WITH GenJournalLine DO
            DeferralUtilities.DeferralCodeOnDelete(
              DeferralDocType::"G/L",
              "Journal Template Name",
              "Journal Batch Name", 0, '', "Line No.");
    END;

    LOCAL PROCEDURE GetGLSourceCode();
    VAR
        SourceCodeSetup: Record 242;
    BEGIN
        SourceCodeSetup.GET;
        GLSourceCode := SourceCodeSetup."General Journal";
    END;

    LOCAL PROCEDURE DeferralPosting(DeferralCode: Code[10]; SourceCode: Code[10]; AccountNo: Code[20]; VAR GenJournalLine: Record 81; Balancing: Boolean);
    BEGIN
        IF DeferralCode <> '' THEN
            // Sales and purchasing could have negative amounts, so check for them first...
            IF (SourceCode <> GLSourceCode) AND
           (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor])
        THEN
                PostDeferralPostBuffer(GenJournalLine)
            ELSE
                // Pure GL trx, only post deferrals if it is not a balancing entry
                IF NOT Balancing THEN
                    PostDeferral(GenJournalLine, AccountNo);
    END;

    LOCAL PROCEDURE CheckDtldCustLegderEntryCreateBills(InitDtldCustLedgEntry: Record 379): Boolean;
    VAR
        DtldCustLedgEntry: Record 379;
    BEGIN
        IF InitDtldCustLedgEntry."Document Type" IN
           [InitDtldCustLedgEntry."Document Type"::Invoice, InitDtldCustLedgEntry."Document Type"::Bill]
        THEN
            EXIT(CheckCustLegderEntryCreateBills(InitDtldCustLedgEntry."Cust. Ledger Entry No."));

        WITH DtldCustLedgEntry DO BEGIN
            IF InitDtldCustLedgEntry."Application No." <> 0 THEN BEGIN
                GET(InitDtldCustLedgEntry."Application No.");
                IF NOT ("Initial Document Type" IN ["Initial Document Type"::Invoice, "Initial Document Type"::Bill]) THEN
                    EXIT(FALSE);
            END ELSE BEGIN
                SETRANGE("Transaction No.", InitDtldCustLedgEntry."Transaction No.");
                SETRANGE("Entry Type", "Entry Type"::Application);
                SETRANGE("Initial Document Type", "Initial Document Type"::Bill);
                IF NOT FINDFIRST THEN
                    SETRANGE("Initial Document Type", "Initial Document Type"::Invoice);
                IF NOT FINDFIRST THEN
                    EXIT(FALSE);
            END;
            EXIT(CheckCustLegderEntryCreateBills("Cust. Ledger Entry No."));
        END;
    END;

    LOCAL PROCEDURE CheckCustLegderEntryCreateBills(EntryNo: Integer): Boolean;
    VAR
        CustLedgerEntry: Record 21;
    BEGIN
        IF CustLedgerEntry.GET(EntryNo) THEN
            EXIT(GetPaymentMethodCreateBills(CustLedgerEntry."Payment Method Code"));
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckDtldVendLegderEntryCreateBills(InitDtldVendorLedgEntry: Record 380): Boolean;
    VAR
        DtldVendorLedgEntry: Record 380;
    BEGIN
        IF InitDtldVendorLedgEntry."Document Type" IN
           [InitDtldVendorLedgEntry."Document Type"::Invoice, InitDtldVendorLedgEntry."Document Type"::Bill]
        THEN
            EXIT(CheckVendLegderEntryCreateBills(InitDtldVendorLedgEntry."Vendor Ledger Entry No."));

        WITH DtldVendorLedgEntry DO BEGIN
            IF InitDtldVendorLedgEntry."Application No." <> 0 THEN BEGIN
                GET(InitDtldVendorLedgEntry."Application No.");
                IF NOT ("Initial Document Type" IN ["Initial Document Type"::Invoice, "Initial Document Type"::Bill]) THEN
                    EXIT(FALSE);
            END ELSE BEGIN
                SETRANGE("Transaction No.", InitDtldVendorLedgEntry."Transaction No.");
                SETRANGE("Entry Type", "Entry Type"::Application);
                SETRANGE("Initial Document Type", "Initial Document Type"::Bill);
                IF NOT FINDFIRST THEN
                    SETRANGE("Initial Document Type", "Initial Document Type"::Invoice);
                IF NOT FINDFIRST THEN
                    EXIT(FALSE);
            END;
            EXIT(CheckVendLegderEntryCreateBills("Vendor Ledger Entry No."));
        END;
    END;

    LOCAL PROCEDURE CheckVendLegderEntryCreateBills(EntryNo: Integer): Boolean;
    VAR
        VendorLedgerEntry: Record 25;
    BEGIN
        IF VendorLedgerEntry.GET(EntryNo) THEN
            EXIT(GetPaymentMethodCreateBills(VendorLedgerEntry."Payment Method Code"));
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetPaymentMethodCreateBills(PaymentMethodCode: Code[10]): Boolean;
    VAR
        PaymentMethod: Record 289;
    BEGIN
        EXIT(PaymentMethod.GET(PaymentMethodCode) AND PaymentMethod."Create Bills");
    END;

    LOCAL PROCEDURE UseGLBillsAccount(GenJnlLine: Record 81): Boolean;
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF ("Document Type" = "Document Type"::Bill) OR FinancialVoidWithMethodCreateBills(GenJnlLine) THEN
                EXIT(TRUE);

            IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Bill) AND ("Applies-to Doc. No." <> '') THEN
                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    EXIT(("Applies-to Bill No." = '') AND "System-Created Entry")
                ELSE
                    EXIT("Applies-to Bill No." <> '')
            ELSE
                EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE PostDtldCVApplicationEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383);
    BEGIN
        CASE GenJnlLine."Account Type" OF
            GenJnlLine."Account Type"::Customer:
                PostDtldCustApplicationEntry(GenJnlLine, DtldCVLedgEntryBuf);
            GenJnlLine."Account Type"::Vendor:
                PostDtldVendApplicationEntry(GenJnlLine, DtldCVLedgEntryBuf);
        END;
    END;

    LOCAL PROCEDURE PostDtldCustApplicationEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383);
    VAR
        Currency: Record 4;
        GLEntry: Record 17;
        DtldCustLedgEntry: Record 379;
        CustomerPostingGroup: Record 92;
        CreateBills: Boolean;
        IsRejected: Boolean;
        AccNo: Code[20];
    BEGIN
        DtldCustLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);

        CreateBills := CheckCustLegderEntryCreateBills(DtldCVLedgEntryBuf."CV Ledger Entry No.");

        CustLedgEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.");
        IsRejected := CheckCarteraDocStatus(CustLedgEntry."Document No.", CustLedgEntry."Bill No.");

        IF CheckCarteraPostDtldCustLE(GenJnlLine, DtldCustLedgEntry, 0, 0, CreateBills) THEN BEGIN
            GetCurrency(Currency, DtldCVLedgEntryBuf."Currency Code");
            CheckNonAddCurrCodeOccurred(Currency.Code);
            CustomerPostingGroup.GET(GenJnlLine."Posting Group");
            AccNo := CustomerPostingGroup.GetReceivablesAccount;

            InitGLEntry(
              GenJnlLine, GLEntry, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", 0,
              DtldCVLedgEntryBuf."Currency Code" = AddCurrencyCode, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, TRUE);

            IF CheckDtldCustLegderEntryCreateBills(DtldCustLedgEntry) THEN BEGIN
                CustomerPostingGroup.TESTFIELD("Bills Account");
                AccNo := CustomerPostingGroup."Bills Account";
            END;

            IF IsRejected THEN BEGIN
                CustomerPostingGroup.TESTFIELD("Rejected Bills Acc.");
                AccNo := CustomerPostingGroup."Rejected Bills Acc.";
            END;

            InitGLEntry(
              GenJnlLine, GLEntry, AccNo, DtldCVLedgEntryBuf."Amount (LCY)",
              0, DtldCVLedgEntryBuf."Currency Code" = AddCurrencyCode, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        END;
    END;

    LOCAL PROCEDURE PostDtldVendApplicationEntry(GenJnlLine: Record 81; DtldCVLedgEntryBuf: Record 383);
    VAR
        Currency: Record 4;
        GLEntry: Record 17;
        DtldVendLedgEntry: Record 380;
        VendorPostingGroup: Record 93;
        CreateBills: Boolean;
        AccNo: Code[20];
    BEGIN
        DtldVendLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);

        CreateBills := CheckVendLegderEntryCreateBills(DtldCVLedgEntryBuf."CV Ledger Entry No.");

        VendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");

        IF CheckCarteraPostDtldVendLE(GenJnlLine, DtldVendLedgEntry, 0, 0, CreateBills) THEN BEGIN
            GetCurrency(Currency, DtldCVLedgEntryBuf."Currency Code");
            CheckNonAddCurrCodeOccurred(Currency.Code);
            VendorPostingGroup.GET(GenJnlLine."Posting Group");
            AccNo := VendorPostingGroup.GetPayablesAccount;

            InitGLEntry(
              GenJnlLine, GLEntry, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", 0,
              DtldCVLedgEntryBuf."Currency Code" = GLSetup."Additional Reporting Currency", TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, TRUE);

            IF CheckDtldVendLegderEntryCreateBills(DtldVendLedgEntry) THEN BEGIN
                VendorPostingGroup.TESTFIELD("Bills Account");
                AccNo := VendorPostingGroup."Bills Account";
            END;

            InitGLEntry(
              GenJnlLine, GLEntry, AccNo, DtldCVLedgEntryBuf."Amount (LCY)",
              0, DtldCVLedgEntryBuf."Currency Code" = AddCurrencyCode, TRUE);
            InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        END;
    END;

    LOCAL PROCEDURE GetPostingAccountNo(VATPostingSetup: Record 325; VATEntry: Record 254; UnrealizedVAT: Boolean): Code[20];
    VAR
        TaxJurisdiction: Record 320;
    BEGIN
        IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" THEN BEGIN
            VATEntry.TESTFIELD("Tax Jurisdiction Code");
            TaxJurisdiction.GET(VATEntry."Tax Jurisdiction Code");
            CASE VATEntry.Type OF
                VATEntry.Type::Sale:
                    EXIT(TaxJurisdiction.GetSalesAccount(UnrealizedVAT));
                VATEntry.Type::Purchase:
                    EXIT(TaxJurisdiction.GetPurchAccount(UnrealizedVAT));
            END;
        END;

        CASE VATEntry.Type OF
            VATEntry.Type::Sale:
                EXIT(VATPostingSetup.GetSalesAccount(UnrealizedVAT));
            VATEntry.Type::Purchase:
                EXIT(VATPostingSetup.GetPurchAccount(UnrealizedVAT));
        END;
    END;

    LOCAL PROCEDURE IsDebitAmount(DtldCVLedgEntryBuf: Record 383; Unapply: Boolean): Boolean;
    VAR
        VATPostingSetup: Record 325;
        VATAmountCondition: Boolean;
        EntryAmount: Decimal;
    BEGIN
        WITH DtldCVLedgEntryBuf DO BEGIN
            VATAmountCondition :=
              "Entry Type" IN ["Entry Type"::"Payment Discount (VAT Excl.)", "Entry Type"::"Payment Tolerance (VAT Excl.)",
                               "Entry Type"::"Payment Discount Tolerance (VAT Excl.)"];
            IF VATAmountCondition THEN BEGIN
                VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                VATAmountCondition := VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Full VAT";
            END;
            IF VATAmountCondition THEN
                EntryAmount := "VAT Amount (LCY)"
            ELSE
                EntryAmount := "Amount (LCY)";
            IF Unapply THEN
                EXIT(EntryAmount > 0);
            EXIT(EntryAmount <= 0);
        END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCode(VAR GenJnlLine: Record 81; CheckLine: Boolean; VAR IsPosted: Boolean; VAR GLReg: Record 45);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckGLAccDimError(VAR GenJournalLine: Record 81; GLAccNo: Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckPurchExtDocNo(GenJournalLine: Record 81; VendorLedgerEntry: Record 25; CVLedgerEntryBuffer: Record 382; VAR Handled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeStartPosting(VAR GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeStartOrContinuePosting(VAR GenJnlLine: Record 81; LastDocType: Enum "Gen. Journal Document Type"; LastDocNo: Code[20]; LastDate: Date; VAR NextEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeContinuePosting(VAR GenJournalLine: Record 81; VAR GLRegister: Record 45; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCustUnrealizedVAT(VAR GenJnlLine: Record 81; VAR CustLedgEntry: Record 21; SettledAmount: Decimal; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostGenJnlLine(VAR GenJournalLine: Record 81; Balancing: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostGLAcc(GenJournalLine: Record 81; VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostVAT(GenJnlLine: Record 81; VAR GLEntry: Record 17; VATPostingSetup: Record 325; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindAmtForAppln(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR AppliedAmount: Decimal; VAR AppliedAmountLCY: Decimal; VAR OldAppliedAmount: Decimal; VAR Handled: Boolean; VAR ApplnRoundingPrecision: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeVendUnrealizedVAT(VAR GenJnlLine: Record 81; VAR VendorLedgerEntry: Record 25; SettledAmount: Decimal; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindAmtForAppln(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR AppliedAmount: Decimal; VAR AppliedAmountLCY: Decimal; VAR OldAppliedAmount: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitGLEntry(VAR GLEntry: Record 17; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitGLRegister(VAR GLRegister: Record 45; VAR GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitBankAccLedgEntry(VAR BankAccountLedgerEntry: Record 271; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitCheckLedgEntry(VAR CheckLedgerEntry: Record 272; BankAccountLedgerEntry: Record 271);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record 21; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitVendLedgEntry(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitEmployeeLedgerEntry(VAR EmployeeLedgerEntry: Record 5222; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertDtldCustLedgEntry(VAR DtldCustLedgEntry: Record 379; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383; Offset: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertDtldVendLedgEntry(VAR DtldVendLedgEntry: Record 380; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383; Offset: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertGlobalGLEntry(VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitVAT(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR VATPostingSetup: Record 325; VAR AddCurrGLEntryVATAmt: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertVAT(VAR GenJournalLine: Record 81; VAR VATEntry: Record 254; VAR UnrealizedVAT: Boolean; VAR AddCurrencyCode: Code[10]; VAR VATPostingSetup: Record 325; VAR GLEntryAmount: Decimal; VAR GLEntryVATAmount: Decimal; VAR GLEntryBaseAmount: Decimal; VAR SrcCurrCode: Code[10]; VAR SrcCurrGLEntryAmt: Decimal; VAR SrcCurrGLEntryVATAmt: Decimal; VAR SrcCurrGLEntryBaseAmt: Decimal; AddCurrGLEntryVATAmt: Decimal; VAR NextConnectionNo: Integer; VAR NextVATEntryNo: Integer; VAR NextTransactionNo: Integer; TempGLEntryBufEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertVATEntry(GenJnlLine: Record 81; VATEntry: Record 254; GLEntryNo: Integer; VAR NextEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRunWithCheck(VAR GenJnlLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRunWithoutCheck(VAR GenJnlLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterOldCustLedgEntryModify(VAR CustLedgEntry: Record 21);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeApplyCustLedgEntry(VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; Cust: Record 18);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterOldVendLedgEntryModify(VAR VendLedgEntry: Record 25);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeApplyVendLedgEntry(VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; Vend: Record 23);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertDtldCustLedgEntry(VAR DtldCustLedgEntry: Record 379; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertDtldCustLedgEntryUnapply(VAR NewDtldCustLedgEntry: Record 379; GenJournalLine: Record 81; OldDtldCustLedgEntry: Record 379);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertDtldEmplLedgEntry(VAR DtldEmplLedgEntry: Record 5223; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertDtldEmplLedgEntryUnapply(VAR NewDtldEmplLedgEntry: Record 5223; GenJournalLine: Record 81; OldDtldEmplLedgEntry: Record 5223);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertDtldVendLedgEntry(VAR DtldVendLedgEntry: Record 380; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertDtldVendLedgEntryUnapply(VAR NewDtldVendLedgEntry: Record 380; GenJournalLine: Record 81; OldDtldVendLedgEntry: Record 380);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertGLEntryBuffer(VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR GenJournalLine: Record 81; VAR BalanceCheckAmount: Decimal; VAR BalanceCheckAmount2: Decimal; VAR BalanceCheckAddCurrAmount: Decimal; VAR BalanceCheckAddCurrAmount2: Decimal; VAR NextEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertGlobalGLEntry(VAR GlobalGLEntry: Record 17; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertTempVATEntry(VAR TempVATEntry: Record 254 TEMPORARY; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInitGLEntry(VAR GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInitVAT(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR VATPostingSetup: Record 325);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertVAT(VAR GenJournalLine: Record 81; VAR VATEntry: Record 254; VAR UnrealizedVAT: Boolean; VAR AddCurrencyCode: Code[10]; VAR VATPostingSetup: Record 325; VAR GLEntryAmount: Decimal; VAR GLEntryVATAmount: Decimal; VAR GLEntryBaseAmount: Decimal; VAR SrcCurrCode: Code[10]; VAR SrcCurrGLEntryAmt: Decimal; VAR SrcCurrGLEntryVATAmt: Decimal; VAR SrcCurrGLEntryBaseAmt: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertVATEntry(VAR VATEntry: Record 254; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertPostUnrealVATEntry(VAR VATEntry: Record 254; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFinishPosting(VAR GlobalGLEntry: Record 17; VAR GLRegister: Record 45; VAR IsTransactionConsistent: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterGLFinishPosting(GLEntry: Record 17; VAR GenJnlLine: Record 81; IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; VAR GLRegister: Record 45; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnNextTransactionNoNeeded(GenJnlLine: Record 81; LastDocType: Enum "Gen. Journal Document Type"; LastDocNo: Code[20]; LastDate: Date; CurrentBalance: Decimal; CurrentBalanceACY: Decimal; VAR NewTransaction: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostGLAcc(VAR GenJnlLine: Record 81; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer; Balancing: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcPmtDiscOnAfterAssignPmtDisc(VAR PmtDisc: Decimal; VAR PmtDiscLCY: Decimal; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcPmtToleranceOnAfterAssignPmtDisc(VAR PmtTol: Decimal; VAR PmtTolLCY: Decimal; VAR PmtTolAmtToBeApplied: Decimal; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR NewCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR NextTransactionNo: Integer; VAR FirstNewVATEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcPmtDiscIfAdjVATCopyFields(VAR DetailedCVLedgEntryBuffer: Record 383; CVLedgerEntryBuffer: Record 382; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostDeferral(VAR GenJournalLine: Record 81; VAR TempGLEntryBuf: Record 17 TEMPORARY; AccountNo: Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostDeferral(VAR GenJournalLine: Record 81; VAR AccountNo: Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateGLEntriesForTotalAmounts(VAR InvoicePostBuffer: Record 49; GenJournalLine: Record 81; GLAccNo: Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostCust(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostVend(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostVAT(GenJnlLine: Record 81; VAR GLEntry: Record 17; VATPostingSetup: Record 325);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcAmtLCYAdjustment(VAR CVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcAplication(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR AppliedAmount: Decimal; VAR AppliedAmountLCY: Decimal; VAR OldAppliedAmount: Decimal; VAR PrevNewCVLedgEntryBuf: Record 382; VAR PrevOldCVLedgEntryBuf: Record 382; VAR AllApplied: Boolean; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcPmtTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR PmtTolAmtToBeApplied: Decimal; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcPmtDisc(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR PmtTolAmtToBeApplied: Decimal; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcPmtDiscTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcMinimalPossibleLiability(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR MinimalPossibleLiability: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcPaymentExceedsLiability(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR MinimalPossibleLiability: Decimal; VAR PaymentExceedsLiability: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcToleratedPaymentExceedsLiability(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR MinimalPossibleLiability: Decimal; VAR ToleratedPaymentExceedsLiability: Boolean; VAR PmtTolAmtToBeApplied: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcPmtDiscount(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR PmtTolAmtToBeApplied: Decimal; VAR PmtDisc: Decimal; VAR PmtDiscLCY: Decimal; VAR PmtDiscAddCurr: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcPmtDiscTolerance(VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR DtldCVLedgEntryBuf: Record 383; VAR GenJnlLine: Record 81; VAR PmtDiscTol: Decimal; VAR PmtDiscTolLCY: Decimal; VAR PmtDiscTolAddCurr: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitOldDtldCVLedgEntryBuf(VAR DtldCVLedgEntryBuf: Record 383; VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR PrevNewCVLedgEntryBuf: Record 382; VAR PrevOldCVLedgEntryBuf: Record 382; VAR GenJnlLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitNewDtldCVLedgEntryBuf(VAR DtldCVLedgEntryBuf: Record 383; VAR NewCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf: Record 382; VAR PrevNewCVLedgEntryBuf: Record 382; VAR PrevOldCVLedgEntryBuf: Record 382; VAR GenJnlLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSettingIsTransactionConsistent(GenJournalLine: Record 81; VAR IsTransactionConsistent: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcCurrencyApplnRounding(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR OldCVLedgEntryBuf: Record 382; VAR OldCVLedgEntryBuf2: Record 382; VAR OldCVLedgEntryBuf3: Record 382; VAR NewCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf2: Record 382; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcCurrencyRealizedGainLoss(VAR CVLedgEntryBuf: Record 382; VAR TempDtldCVLedgEntryBuf: Record 383 TEMPORARY; VAR GenJnlLine: Record 81; VAR AppliedAmount: Decimal; VAR AppliedAmountLCY: Decimal; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcCurrencyUnrealizedGainLoss(VAR CVLedgEntryBuf: Record 382; VAR TempDtldCVLedgEntryBuf: Record 383 TEMPORARY; VAR GenJnlLine: Record 81; VAR AppliedAmount: Decimal; VAR RemainingAmountBeforeAppln: Decimal; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostApply(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR OldCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf2: Record 382);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostApply(GenJnlLine: Record 81; VAR DtldCVLedgEntryBuf: Record 383; VAR OldCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf: Record 382; VAR NewCVLedgEntryBuf2: Record 382);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdateTotalAmounts(VAR TempInvPostBuf: Record 49 TEMPORARY; VAR DimSetID: Integer; VAR AmountToCollect: Decimal; VAR AmountACYToCollect: Decimal; VAR IsHandled: Boolean; VAR DtldCVLedgEntryBuf: Record 383);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateGLEntryGainLossInsertGLEntry(VAR GenJnlLine: Record 81; VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateGLEntriesForTotalAmountsUnapply(DetailedCustLedgEntry: Record 379; VAR CustomerPostingGroup: Record 92);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInitGLEntryVAT(GenJnlLine: Record 81; VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitGLEntryVAT(GenJnlLine: Record 81; VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInitGLEntryVATCopy(GenJnlLine: Record 81; VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitGLEntryVATCopy(GenJnlLine: Record 81; VAR GLEntry: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostUnrealVATEntry(GenJnlLine: Record 81; VAR VATEntry: Record 254);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostUnrealVATEntry(GenJnlLine: Record 81; VAR VATEntry2: Record 254);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterHandleAddCurrResidualGLEntry(GenJournalLine: Record 81; GLEntry2: Record 17);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcCurrencyRealizedGainLoss(VAR CVLedgEntryBuf: Record 382; AppliedAmount: Decimal; AppliedAmountLCY: Decimal; VAR RealizedGainLossLCY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCustLedgEntryModify(VAR CustLedgerEntry: Record 21; DetailedCustLedgEntry: Record 379);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeVendLedgEntryModify(VAR VendorLedgerEntry: Record 25; DetailedVendorLedgEntry: Record 380);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeEmplLedgEntryModify(VAR EmployeeLedgerEntry: Record 5222; DetailedEmployeeLedgerEntry: Record 5223);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePrepareTempCustledgEntry(VAR GenJnlLine: Record 81; VAR CVLedgerEntryBuffer: Record 382);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePrepareTempVendLedgEntry(VAR GenJnlLine: Record 81; VAR CVLedgerEntryBuffer: Record 382);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnContinuePostingOnBeforeCalculateCurrentBalance(VAR GenJournalLine: Record 81; VAR NextTransactionNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCustPostApplyCustLedgEntryOnBeforeCheckPostingGroup(VAR GenJournalLine: Record 81; VAR Customer: Record 18);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInsertPmtDiscVATForGLEntryOnAfterCopyFromGenJnlLine(VAR DetailedCVLedgEntryBuffer: Record 383; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInsertTempVATEntryOnBeforeInsert(VAR VATEntry: Record 254; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostBankAccOnAfterBankAccLedgEntryInsert(VAR BankAccountLedgerEntry: Record 271; VAR GenJournalLine: Record 81; BankAccount: Record 270);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostBankAccOnBeforeBankAccLedgEntryInsert(VAR BankAccountLedgerEntry: Record 271; VAR GenJournalLine: Record 81; BankAccount: Record 270);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostBankAccOnAfterCheckLedgEntryInsert(VAR CheckLedgerEntry: Record 272; VAR BankAccountLedgerEntry: Record 271; VAR GenJournalLine: Record 81; BankAccount: Record 270);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostBankAccOnBeforeCheckLedgEntryInsert(VAR CheckLedgerEntry: Record 272; VAR BankAccountLedgerEntry: Record 271; VAR GenJournalLine: Record 81; BankAccount: Record 270);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostBankAccOnBeforeInitBankAccLedgEntry(VAR GenJournalLine: Record 81; CurrencyFactor: Decimal; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostCustOnAfterCopyCVLedgEntryBuf(VAR CVLedgerEntryBuffer: Record 382; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostVendOnAfterCopyCVLedgEntryBuf(VAR CVLedgerEntryBuffer: Record 382; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostDtldCVLedgEntryOnBeforeCreateGLEntryGainLoss(VAR GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383; VAR Unapply: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostGLAccOnBeforeInsertGLEntry(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostFixedAssetOnBeforeInsertGLEntry(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR IsHandled: Boolean; VAR TempFAGLPostBuf: Record 5637 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostUnapplyOnBeforeVATEntryInsert(VAR VATEntry: Record 254; GenJournalLine: Record 81; OrigVATEntry: Record 254);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPrepareTempCustLedgEntryOnBeforeExit(VAR GenJournalLine: Record 81; VAR CVLedgerEntryBuffer: Record 382; VAR TempOldCustLedgEntry: Record 21 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(VAR CustLedgerEntry: Record 21; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPrepareTempVendLedgEntryOnBeforeExit(VAR GenJournalLine: Record 81; VAR CVLedgerEntryBuffer: Record 382; VAR TempOldVendLedgEntry: Record 25 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPrepareTempVendLedgEntryOnBeforeTempOldVendLedgEntryInsert(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUnapplyCustLedgEntryOnAfterCreateGLEntriesForTotalAmounts(VAR GenJournalLine: Record 81; DetailedCustLedgEntry: Record 379);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUnapplyCustLedgEntryOnBeforeCheckPostingGroup(VAR GenJournalLine: Record 81; Customer: Record 18);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUnapplyVendLedgEntryOnAfterCreateGLEntriesForTotalAmounts(VAR GenJournalLine: Record 81; DetailedVendorLedgEntry: Record 380);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUnapplyVendLedgEntryOnBeforeCheckPostingGroup(VAR GenJournalLine: Record 81; Vendor: Record 23);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCustUnrealizedVATOnAfterVATPartCalculation(GenJournalLine: Record 81; VAR CustLedgerEntry: Record 21; PaidAmount: Decimal; TotalUnrealVATAmountFirst: Decimal; TotalUnrealVATAmountLast: Decimal; SettledAmount: Decimal; VATEntry2: Record 254);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCustUnrealizedVATOnBeforeInitGLEntryVAT(VAR GenJournalLine: Record 81; VAR VATEntry: Record 254; VAR VATAmount: Decimal; VAR VATBase: Decimal; VAR VATAmountAddCurr: Decimal; VAR VATBaseAddCurr: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnVendPostApplyVendLedgEntryOnBeforeCheckPostingGroup(VAR GenJournalLine: Record 81; Vendor: Record 23);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnVendUnrealizedVATOnAfterVATPartCalculation(GenJournalLine: Record 81; VAR VendorLedgerEntry: Record 25; PaidAmount: Decimal; TotalUnrealVATAmountFirst: Decimal; TotalUnrealVATAmountLast: Decimal; SettledAmount: Decimal; VATEntry2: Record 254);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnVendUnrealizedVATOnBeforeInitGLEntryVAT(VAR GenJournalLine: Record 81; VAR VATEntry: Record 254; VAR VATAmount: Decimal; VAR VATBase: Decimal; VAR VATAmountAddCurr: Decimal; VAR VATBaseAddCurr: Decimal);
    BEGIN
    END;

    PROCEDURE ResetLedgEntry();
    VAR
        QBCodPublisher: Codeunit 7207352;
    BEGIN
        QBCodPublisher.ResetLedgerEntryGenJnlPostLine(NextEntryNo);
    END;


    /*BEGIN
/*{
      PEL 20/07/18: - QB_180720 Se pone una condici¢n para que no salte error.
      QB3257
      RSH 04/07/19: - Para PERTEO, Modificar funcion ApplyVendLEdgentry para que no de error si se esta procesando un movimiento de tipo efecto con fecha registro anterior al 01/06/2019 (importados).
      JAV 21/10/19: - Se pasan los eventos de retenciones a la CU de retenciones
      JAV 24/10/19: - Se elimina QB_180720 pues ya no tiene sentido con las nuevas retenciones
      JAV 16/07/20: - Tiene que mirar tambi�n las de recurso para liberar el IVA no realizado
      JAV 18/10/20: - QB 1.06.21 Si no existe la factura no puede tener IVA no realizado
      JAV 13/01/22: - QB 1.10.09 En 4 lugares cambiar las cuentas para el confirming si es necesario
      JAV 18/01/22: - QB 1.10.11 Cambiar cuenta del confirming. Se cambia de lugar una l�nea mal ubicada
      JAV 04/04/22: - QB 1.10.31 Cambiar cuenta del confirming para la recirculaci�n de efectos
      EPV 07/04/22: - Correcci�n de error en la elecci�n de la cuenta de confirming
      JAV 25/05/22: - QB 1.10.44 Se elimina la llamada a InheritFieldVendor, se usa en su lugar el evento OnAfterInitVendLedgEntry
      AML 19/10/23: - Q20318 Correccion para liquidacion de efectos.
    }
END.*/
}









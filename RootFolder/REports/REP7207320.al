report 7207320 "Trial Balance Departament"
{


    CaptionML = ENU = 'Trial Balance Departament', ESP = 'Balance Sumas y Saldos dpto.';

    dataset
    {

        DataItem("G/L Account"; "G/L Account")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Works', ESP = 'Obras';


            RequestFilterFields = "Global Dimension 1 Filter", "Date Filter";
            Column(Header; Header)
            {
                //SourceExpr=Header;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(FORMAT_WORKDATE_0_4_; FORMAT(WORKDATE, 0, 4))
            {
                //SourceExpr=FORMAT(WORKDATE,0,4);
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(Period______NamePeriod; 'Period: ' + NamePeriod)
            {
                //SourceExpr='Period: ' + NamePeriod;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(DEPARTAMENT____NoDepartament_____Job_Description; 'DEPARTAMENTO: ' + NoDepartament + ' ' + Job.Description)
            {
                //SourceExpr='DEPARTAMENTO: '+NoDepartament+' '+Job.Description;
            }
            Column(IncludeMovs; IncludeMovs)
            {
                //SourceExpr=IncludeMovs;
            }
            Column(G_L_Account__TABLENAME__________TextFilterHeaderExp; "G/L Account".TABLENAME + ': ' + TextFilterHeaderExp)
            {
                //SourceExpr="G/L Account".TABLENAME + ': ' + TextFilterHeaderExp;
            }
            Column(EmptyString; '')
            {
                //SourceExpr='';
            }
            Column(EmptyString_Control12; '')
            {
                //SourceExpr='';
            }
            Column(EmptyString_Control43; '')
            {
                //SourceExpr='';
            }
            Column(EmptyString_Control61; '')
            {
                //SourceExpr='';
            }
            Column(TotEndBalance; TotEndBalance)
            {
                //SourceExpr=TotEndBalance;
            }
            Column(TotDebitAmountDate; TotDebitAmountDate)
            {
                //SourceExpr=TotDebitAmountDate;
            }
            Column(TotCreditAmountDate; TotCreditAmountDate)
            {
                //SourceExpr=TotCreditAmountDate;
            }
            Column(TotDebitAmountPeriod; TotDebitAmountPeriod)
            {
                //SourceExpr=TotDebitAmountPeriod;
            }
            Column(TotCreditAmountPeriod; TotCreditAmountPeriod)
            {
                //SourceExpr=TotCreditAmountPeriod;
            }
            Column(Capital_provided_; 'Capital provided')
            {
                //SourceExpr='Capital provided';
            }
            Column(TBalance; TBalance)
            {
                //SourceExpr=TBalance;
            }
            Column(TotDebitAmountDate_Control54; TotDebitAmountDate)
            {
                //SourceExpr=TotDebitAmountDate;
            }
            Column(TotCreditAmountDate_Control55; TotCreditAmountDate)
            {
                //SourceExpr=TotCreditAmountDate;
            }
            Column(TotEndBalance_TotEndBalance; TotEndBalance - TotEndBalance)
            {
                //SourceExpr=TotEndBalance-TotEndBalance;
            }
            Column(TotDebitAmountPeriod_TotCreditAmountPeriod; TotDebitAmountPeriod + TotCreditAmountPeriod)
            {
                //SourceExpr=TotDebitAmountPeriod+TotCreditAmountPeriod;
            }
            Column(TotCreditAmountPeriod_TotDebitAmountPeriod; TotCreditAmountPeriod + TotDebitAmountPeriod)
            {
                //SourceExpr=TotCreditAmountPeriod+TotDebitAmountPeriod;
            }
            Column(TBalance2; TBalance2)
            {
                //SourceExpr=TBalance2;
            }
            Column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
                //SourceExpr=Trial_BalanceCaptionLbl;
            }
            Column(Page_Caption; Page_CaptionLbl)
            {
                //SourceExpr=Page_CaptionLbl;
            }
            Column(Accum__periodCaption; Accum__periodCaptionLbl)
            {
                //SourceExpr=Accum__periodCaptionLbl;
            }
            Column(Accum__period_dateCaption; Accum__period_dateCaptionLbl)
            {
                //SourceExpr=Accum__period_dateCaptionLbl;
            }
            Column(AccountCaption; AccountCaptionLbl)
            {
                //SourceExpr=AccountCaptionLbl;
            }
            Column(NameCaption; NameCaptionLbl)
            {
                //SourceExpr=NameCaptionLbl;
            }
            Column(DebitCaption; DebitCaptionLbl)
            {
                //SourceExpr=DebitCaptionLbl;
            }
            Column(CreditCaption; CreditCaptionLbl)
            {
                //SourceExpr=CreditCaptionLbl;
            }
            Column(DebitCaption_Control17; DebitCaption_Control17Lbl)
            {
                //SourceExpr=DebitCaption_Control17Lbl;
            }
            Column(CreditCaption_Control18; CreditCaption_Control18Lbl)
            {
                //SourceExpr=CreditCaption_Control18Lbl;
            }
            Column(Balance_dateCaption; Balance_dateCaptionLbl)
            {
                //SourceExpr=Balance_dateCaptionLbl;
            }
            Column(BalanceCaption; BalanceCaptionLbl)
            {
                //SourceExpr=BalanceCaptionLbl;
            }
            Column(AccountCaption_Control30; AccountCaption_Control30Lbl)
            {
                //SourceExpr=AccountCaption_Control30Lbl;
            }
            Column(NameCaption_Control41; NameCaption_Control41Lbl)
            {
                //SourceExpr=NameCaption_Control41Lbl;
            }
            Column(Accum__periodCaption_Control42; Accum__periodCaption_Control42Lbl)
            {
                //SourceExpr=Accum__periodCaption_Control42Lbl;
            }
            Column(DebitCaption_Control44; DebitCaption_Control44Lbl)
            {
                //SourceExpr=DebitCaption_Control44Lbl;
            }
            Column(CreidtCaption_Control59; CreditCaption_Control59Lbl)
            {
                //SourceExpr=CreditCaption_Control59Lbl;
            }
            Column(Accum__period_dateCaption_Control60; Accum__period_dateCaption_Control60Lbl)
            {
                //SourceExpr=Accum__period_dateCaption_Control60Lbl;
            }
            Column(DebitCaption_Control62; DebitCaption_Control62Lbl)
            {
                //SourceExpr=DebitCaption_Control62Lbl;
            }
            Column(CreditCaption_Control63; CreditCaption_Control63Lbl)
            {
                //SourceExpr=CreditCaption_Control63Lbl;
            }
            Column(Balance_accum__dateCaption; Balance_accum__dateCaptionLbl)
            {
                //SourceExpr=Balance_accum__dateCaptionLbl;
            }
            Column(BalanceCaption_Control70; BalanceCaption_Control70Lbl)
            {
                //SourceExpr=BalanceCaption_Control70Lbl;
            }
            Column(G_L_Account_No_; "No.")
            {
                //SourceExpr="No.";
            }
            DataItem("[ N§ lines white]"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
            }
            DataItem("2000000026"; "2000000026")
            {

                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                Column(G_L_Account___No__; "G/L Account"."No.")
                {
                    //SourceExpr="G/L Account"."No.";
                }
                Column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                    //SourceExpr=PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name;
                }
                Column(G_L_Account___Debit_Amount____AmountOpenDebit___AmountCloseDebit; "G/L Account"."Debit Amount" + AmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr="G/L Account"."Debit Amount" + AmountOpenDebit + AmountCloseDebit;
                }
                Column(G_L_Account___Credit_Amount____AmountOpenCredit___AmountCloseCredit; "G/L Account"."Credit Amount" + AmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr="G/L Account"."Credit Amount" + AmountOpenCredit + AmountCloseCredit;
                }
                Column(Cta2__Debit_Amount____EndAmountOpenDebit___AmountCloseDebit; GLAccount2."Debit Amount" + EndAmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr=GLAccount2."Debit Amount" + EndAmountOpenDebit + AmountCloseDebit;
                }
                Column(Cta2__Credit_Amount____EndAmountOpenCredit___AmountCloseCredit; GLAccount2."Credit Amount" + EndAmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr=GLAccount2."Credit Amount" + EndAmountOpenCredit + AmountCloseCredit;
                }
                Column(BalanceType; BalanceType)
                {
                    //SourceExpr=BalanceType;
                }
                Column(VarBalance; VarBalance)
                {
                    //SourceExpr=VarBalance;
                }
                Column(BalanceType_Control34; BalanceType)
                {
                    //SourceExpr=BalanceType;
                }
                Column(Cta2__Add__Currency_Credit_Amount____EndAmountOpenCredit___AmountCloseCredit; GLAccount2."Add.-Currency Credit Amount" + EndAmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr=GLAccount2."Add.-Currency Credit Amount" + EndAmountOpenCredit + AmountCloseCredit;
                }
                Column(Cta2__Add__Currency_Debit_Amount____EndAmountOpenDebit___AmountCloseDebit; GLAccount2."Add.-Currency Debit Amount" + EndAmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr=GLAccount2."Add.-Currency Debit Amount" + EndAmountOpenDebit + AmountCloseDebit;
                }
                Column(G_L_Account___Add__Currency_Credit_Amount____AmountOpenCredit___AmountCloseCredit; "G/L Account"."Add.-Currency Credit Amount" + AmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr="G/L Account"."Add.-Currency Credit Amount" + AmountOpenCredit + AmountCloseCredit;
                }
                Column(G_L_Account___Add__Currency_Debit_Amount____AmountOpenDebit___AmountCloseDebit; "G/L Account"."Add.-Currency Debit Amount" + AmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr="G/L Account"."Add.-Currency Debit Amount" + AmountOpenDebit + AmountCloseDebit;
                }
                Column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control45; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                    //SourceExpr=PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name;
                }
                Column(G_L_Account___No___Control46; "G/L Account"."No.")
                {
                    //SourceExpr="G/L Account"."No.";
                }
                Column(VarBalance_Control79; VarBalance)
                {
                    //SourceExpr=VarBalance;
                }
                Column(G_L_Account___No___Control25; "G/L Account"."No.")
                {
                    //SourceExpr="G/L Account"."No.";
                }
                Column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control26; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                    //SourceExpr=PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name;
                }
                Column(G_L_Account___Debit_Amount____AmountOpenDebit___AmountCloseDebit_Control27; "G/L Account"."Debit Amount" + AmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr="G/L Account"."Debit Amount" + AmountOpenDebit + AmountCloseDebit;
                }
                Column(G_L_Account___Credit_Amount____AmountOpenCredit___AmountCloseCredit_Control28; "G/L Account"."Credit Amount" + AmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr="G/L Account"."Credit Amount" + AmountOpenCredit + AmountCloseCredit;
                }
                Column(Cta2__Debit_Amount____EndAmountOpenDebit___AmountCloseDebit_Control32; GLAccount2."Debit Amount" + EndAmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr=GLAccount2."Debit Amount" + EndAmountOpenDebit + AmountCloseDebit;
                }
                Column(Cta2__Credit_Amount____EndAmountOpenDebit___AmountCloseCredit_Control39; GLAccount2."Credit Amount" + EndAmountOpenDebit + AmountCloseCredit)
                {
                    //SourceExpr=GLAccount2."Credit Amount" + EndAmountOpenDebit + AmountCloseCredit;
                }
                Column(BalanceType_Control40; BalanceType)
                {
                    //SourceExpr=BalanceType;
                }
                Column(VarBalance_Control80; VarBalance)
                {
                    //SourceExpr=VarBalance;
                }
                Column(BalanceType_Control47; BalanceType)
                {
                    //SourceExpr=BalanceType;
                }
                Column(Cta2__Add__Currency_Credit_Amount____EndAmountOpenCredit___AmountCloseCredit_Control48; GLAccount2."Add.-Currency Credit Amount" + EndAmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr=GLAccount2."Add.-Currency Credit Amount" + EndAmountOpenCredit + AmountCloseCredit;
                }
                Column(Cta2__Add__Currency_Debit_Amount____EndAmountOpenDebit___AmountCloseDebit_Control49; GLAccount2."Add.-Currency Debit Amount" + EndAmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr=GLAccount2."Add.-Currency Debit Amount" + EndAmountOpenDebit + AmountCloseDebit;
                }
                Column(G_L_Account___Add__Currency_Credit_Amount_____AmountOpenCredit___AmountCloseCredit_Control50; "G/L Account"."Add.-Currency Credit Amount" + AmountOpenCredit + AmountCloseCredit)
                {
                    //SourceExpr="G/L Account"."Add.-Currency Credit Amount" + AmountOpenCredit + AmountCloseCredit;
                }
                Column(G_L_Account___Add__Currency_Debit_Amount_____AmountOpenDebit___AmountCloseDebit; "G/L Account"."Add.-Currency Debit Amount" + AmountOpenDebit + AmountCloseDebit)
                {
                    //SourceExpr="G/L Account"."Add.-Currency Debit Amount"  + AmountOpenDebit + AmountCloseDebit;
                }
                Column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name_Control52; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                    //SourceExpr=PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name;
                }
                Column(G_L_Account___No___Control53; "G/L Account"."No.")
                {
                    //SourceExpr="G/L Account"."No.";
                }
                Column(VarBalance_Control81; VarBalance)
                {
                    //SourceExpr=VarBalance;
                }
                Column(Integer_Number; Number)
                {
                    //SourceExpr=Number ;
                }
                trigger OnPreDataItem();
                BEGIN
                    SETRANGE(Number, 1, "G/L Account"."No. of Blank Lines");
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);

                FirstDate := 0D;
                IF GETFILTER("Date Filter") = '' THEN
                    LastDate := 99991231D
                ELSE BEGIN
                    FirstDate := GETRANGEMIN("Date Filter");
                    LastDate := GETRANGEMAX("Date Filter");
                END;
                CurrReport.CREATETOTALS(DebitAmountPer, CreditAmountPer, DebitAmountAccumulated, CreditAmountAccumulated, EndBalance);
                FilterHeaderExp := "G/L Account".GETFILTER("G/L Account"."Account Type");
                "G/L Account".SETRANGE("G/L Account"."Account Type");
                IF FilterHeaderExp = Posting THEN BEGIN
                    OptionFilterHeaderExp := OptionFilterHeaderExp::Posting;
                    SETRANGE("Account Type", OptionFilterHeaderExp);
                END;
                IF FilterHeaderExp = Heading THEN BEGIN
                    OptionFilterHeaderExp := OptionFilterHeaderExp::Heading;
                    SETRANGE("Account Type", OptionFilterHeaderExp);
                END;
                IF MovsClose THEN
                    IF LastDate <> NORMALDATE(LastDate) THEN
                        CloseDate(LastDate)
                    ELSE
                        ERROR('La Date %1 no es una Date de cierre', LastDate);
                IF MovsOpen THEN
                    DateOpening := OpenDate(FirstDate);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                CALCFIELDS("Debit Amount", "Credit Amount", "Balance at Date", "Add.-Currency Debit Amount",
                           "Add.-Currency Credit Amount", "Add.-Currency Balance at Date");
                GLAccount2 := "G/L Account";

                GLAccount2.SETRANGE("Global Dimension 1 Filter", GETFILTER("Global Dimension 1 Filter"));

                GLAccount2.SETRANGE("Date Filter", BeginPeriod(FirstDate), LastDate);
                GLAccount2.CALCFIELDS("Additional-Currency Net Change", "Net Change", "Debit Amount", "Credit Amount",
                                  "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "Balance at Date");
                IF PrintAmountsAddCurrency THEN BEGIN
                    PreviousBalance := GLAccount2."Additional-Currency Net Change";
                    BalanceType := GLAccount2."Additional-Currency Net Change";
                    IF AccumulatedBalance THEN
                        BalanceType := GLAccount2."Add.-Currency Balance at Date";
                END ELSE BEGIN
                    PreviousBalance := GLAccount2."Net Change";
                    BalanceType := GLAccount2."Net Change";
                    IF AccumulatedBalance THEN
                        BalanceType := GLAccount2."Balance at Date";
                END;
                AmountOpenCredit := 0;
                AmountOpenDebit := 0;
                EndAmountOpenCredit := 0;
                EndAmountOpenDebit := 0;
                IF MovsOpen THEN BEGIN
                    IF "Account Type" = "Account Type"::Heading THEN
                        CalcMovsOpenGreader
                    ELSE
                        CalcMovsOpen;
                    IF NOT AccumulatedBalance THEN
                        BalanceType := BalanceType + EndAmountOpenDebit - EndAmountOpenCredit;
                END;
                AmountCloseDebit := 0;
                AmountCloseCredit := 0;
                IF MovsClose THEN BEGIN
                    IF "Account Type" = "Account Type"::Heading THEN
                        CalcMovsCloseGreader
                    ELSE
                        CalcMovsClose;
                    IF NOT AccumulatedBalance THEN
                        BalanceType := BalanceType + AmountCloseDebit - AmountCloseCredit;
                END;
                DebitPrev := 0;
                CreditPrev := 0;
                IF PreviousBalance > 0 THEN
                    DebitPrev := PreviousBalance
                ELSE
                    CreditPrev := ABS(PreviousBalance);
                GLAccount.SETRANGE("Date Filter", FirstDate, LastDate);
                GLAccount.SETRANGE("Global Dimension 1 Filter", GETFILTER("Global Dimension 1 Filter"));
                GLAccount.CALCFIELDS("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");
                IF NOT PrintAmountsAddCurrency THEN BEGIN
                    DebitAmountPer := GLAccount."Debit Amount";
                    CreditAmountPer := GLAccount."Credit Amount";
                    EndBalance := EndBalance + PreviousBalance;
                    DebitAmountAccumulated := GLAccount2."Debit Amount";
                    CreditAmountAccumulated := GLAccount2."Credit Amount";
                    IF (STRLEN("No.") = 1) OR (FilterHeaderExp = Posting) THEN BEGIN
                        TotDebitAmountPeriod := TotDebitAmountPeriod + "Debit Amount" + AmountCloseDebit;
                        TotCreditAmountPeriod := TotCreditAmountPeriod + "Credit Amount" + AmountCloseCredit;
                        IF DateOpening THEN BEGIN
                            TotDebitAmountPeriod := TotDebitAmountPeriod + AmountOpenDebit;
                            TotCreditAmountPeriod := TotCreditAmountPeriod + AmountOpenCredit;
                        END;
                        TotDebitAmountDate := TotDebitAmountDate + DebitAmountAccumulated + EndAmountOpenDebit + AmountCloseDebit;
                        TotCreditAmountDate := TotCreditAmountDate + CreditAmountAccumulated + EndAmountOpenCredit + AmountCloseCredit;
                        IF AccumulatedBalance THEN
                            TotEndBalance := TotEndBalance + BalanceType
                        ELSE
                            TotEndBalance := TotEndBalance + EndBalance;
                    END;
                END ELSE BEGIN
                    DebitAmountPer := GLAccount."Add.-Currency Debit Amount";
                    CreditAmountPer := GLAccount."Add.-Currency Credit Amount";
                    EndBalance := EndBalance + PreviousBalance;
                    DebitAmountAccumulated := GLAccount2."Add.-Currency Debit Amount";
                    CreditAmountAccumulated := GLAccount2."Add.-Currency Credit Amount";
                    IF (STRLEN("No.") = 1) OR (FilterHeaderExp = Posting) THEN BEGIN
                        TotDebitAmountPeriod := TotDebitAmountPeriod + "Add.-Currency Debit Amount" + AmountCloseDebit;
                        TotCreditAmountPeriod := TotCreditAmountPeriod + "Add.-Currency Credit Amount" + AmountCloseCredit;
                        IF DateOpening THEN BEGIN
                            TotDebitAmountPeriod := TotDebitAmountPeriod + AmountOpenDebit;
                            TotCreditAmountPeriod := TotCreditAmountPeriod + AmountOpenCredit;
                        END;
                        TotDebitAmountDate := TotDebitAmountDate + DebitAmountAccumulated + EndAmountOpenDebit + AmountCloseDebit;
                        TotCreditAmountDate := TotCreditAmountDate + CreditAmountAccumulated + EndAmountOpenCredit + AmountCloseCredit;
                        IF AccumulatedBalance THEN
                            TotEndBalance := TotEndBalance + BalanceType
                        ELSE
                            TotEndBalance := TotEndBalance + EndBalance;
                    END;
                END;
                IF PrintWithBalance AND ("Balance at Date" = 0) AND ("Debit Amount" = 0) AND ("Credit Amount" = 0) THEN
                    CurrReport.SKIP;
            END;


        }
    }
    requestpage
    {
        CaptionML = ENU = 'Trial Balance departament', ESP = 'Balance sumas y saldos dpto.';
        layout
        {
            area(content)
            {
                field("Only accounts with balance at date"; "OnlyAccountsWithbalanceDate")
                {

                    CaptionML = ENU = 'Only accounts with balance at date', ESP = 'S¢lo cuentas con saldo a fecha';
                    MultiLine = true;
                }
                field("Show Amounts in Add. Reporting Currency"; "ShowAmountsAddReportingCurrency")
                {

                    CaptionML = ENU = 'Show Amounts in Add. Reporting Currency', ESP = 'Muestra importes en divisa adicional';
                }
                field("Show Acum. Balance at Date"; "ShowAcumBalanceDate")
                {

                    CaptionML = ENU = 'Show Acum. Balance at Date', ESP = 'Muestra saldo acum. a fecha';
                }
                field("Include Opening Entries"; "IncludeOpeningEntries")
                {

                    CaptionML = ENU = 'Include Opening Entries', ESP = 'Incluye movs. apertura';
                }
                field("Include Closing Entries"; "IncludeClosingEntries")
                {

                    CaptionML = ENU = 'Include Closing Entries', ESP = 'Incluye movs. cierre';
                }

            }
        }
    }
    labels
    {
        line = '.........................................................................................................../ <......................................................................................>/';
    }

    var
        //       GeneralLedgerSetup@1100231000 :
        GeneralLedgerSetup: Record 98;
        //       GLAccount@1100231001 :
        GLAccount: Record 15;
        //       GLAccount2@1100231002 :
        GLAccount2: Record 15;
        //       Header@1100231003 :
        Header: Text[30];
        //       TextFilterHeaderExp@1100231004 :
        TextFilterHeaderExp: Text[250];
        //       NamePeriod@1100231005 :
        NamePeriod: Text[30];
        //       FirstDate@1100231006 :
        FirstDate: Date;
        //       LastDate@1100231007 :
        LastDate: Date;
        //       PrintWithBalance@1100231008 :
        PrintWithBalance: Boolean;
        //       IncludeMovs@1100231009 :
        IncludeMovs: Text[40];
        //       FilterHeaderExp@1100231010 :
        FilterHeaderExp: Text[30];
        //       OptionFilterHeaderExp@1100231011 :
        OptionFilterHeaderExp: Option "Posting","Heading";
        //       PreviousBalance@1100231012 :
        PreviousBalance: Decimal;
        //       DebitPrev@1100231013 :
        DebitPrev: Decimal;
        //       CreditPrev@1100231014 :
        CreditPrev: Decimal;
        //       DateOpening@1100231015 :
        DateOpening: Boolean;
        //       PrintAmountsAddCurrency@1100231016 :
        PrintAmountsAddCurrency: Boolean;
        //       DebitAmountPer@1100231017 :
        DebitAmountPer: Decimal;
        //       CreditAmountPer@1100231018 :
        CreditAmountPer: Decimal;
        //       EndBalance@1100231019 :
        EndBalance: Decimal;
        //       DebitAmountAccumulated@1100231020 :
        DebitAmountAccumulated: Decimal;
        //       CreditAmountAccumulated@1100231021 :
        CreditAmountAccumulated: Decimal;
        //       TotDebitAmountPeriod@1100231022 :
        TotDebitAmountPeriod: Decimal;
        //       TotCreditAmountPeriod@1100231023 :
        TotCreditAmountPeriod: Decimal;
        //       TotEndBalance@1100231024 :
        TotEndBalance: Decimal;
        //       TotDebitAmountDate@1100231025 :
        TotDebitAmountDate: Decimal;
        //       TotCreditAmountDate@1100231026 :
        TotCreditAmountDate: Decimal;
        //       BalanceType@1100231027 :
        BalanceType: Decimal;
        //       AccumulatedBalance@1100231028 :
        AccumulatedBalance: Boolean;
        //       MovsClose@1100231029 :
        MovsClose: Boolean;
        //       MovsOpen@1100231030 :
        MovsOpen: Boolean;
        //       AmountOpenCredit@1100231031 :
        AmountOpenCredit: Decimal;
        //       AmountOpenDebit@1100231032 :
        AmountOpenDebit: Decimal;
        //       AmountCloseCredit@1100231033 :
        AmountCloseCredit: Decimal;
        //       AmountCloseDebit@1100231034 :
        AmountCloseDebit: Decimal;
        //       EndAmountOpenCredit@1100231035 :
        EndAmountOpenCredit: Decimal;
        //       EndAmountOpenDebit@1100231036 :
        EndAmountOpenDebit: Decimal;
        //       CompanyInformation@1100231037 :
        CompanyInformation: Record 79;
        //       Proj@1100231038 :
        Proj: Text[30];
        //       Total@1100231039 :
        Total: Text[30];
        //       Balance@1100231040 :
        Balance: Text[30];
        //       VarDebit@1100231041 :
        VarDebit: Decimal;
        //       VarCredit@1100231042 :
        VarCredit: Decimal;
        //       VarBalance@1100231043 :
        VarBalance: Decimal;
        //       TBalance@1100231044 :
        TBalance: Decimal;
        //       TBalance2@1100231045 :
        TBalance2: Decimal;
        //       NoDepartament@1100231046 :
        NoDepartament: Text[30];
        //       Job@1100231047 :
        Job: Record 167;
        //       Text0001@1100251000 :
        Text0001: TextConst ENU = '<You must specify a range of dates a value Date Filter>', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Trial_BalanceCaptionLbl@7001121 :
        Trial_BalanceCaptionLbl: TextConst ENU = '<Trial Balance>', ESP = 'Balance sumas y saldos';
        //       Page_CaptionLbl@7001120 :
        Page_CaptionLbl: TextConst ENU = '<Page>', ESP = 'P g.';
        //       Accum__periodCaptionLbl@7001119 :
        Accum__periodCaptionLbl: TextConst ENU = '<Accum. period>', ESP = 'Acum. periodo';
        //       Accum__period_dateCaptionLbl@7001118 :
        Accum__period_dateCaptionLbl: TextConst ENU = '<Accum. period date>', ESP = 'Acum. periodo a fecha';
        //       AccountCaptionLbl@7001117 :
        AccountCaptionLbl: TextConst ENU = '<Account>', ESP = 'Cuenta';
        //       NameCaptionLbl@7001116 :
        NameCaptionLbl: TextConst ENU = '<Name>', ESP = 'Nombre';
        //       DebitCaptionLbl@7001115 :
        DebitCaptionLbl: TextConst ENU = '<Debit>', ESP = 'Debe';
        //       CreditCaptionLbl@7001114 :
        CreditCaptionLbl: TextConst ENU = '<Credit>', ESP = 'Haber';
        //       DebitCaption_Control17Lbl@7001113 :
        DebitCaption_Control17Lbl: TextConst ENU = '<Debit>', ESP = 'Debe';
        //       CreditCaption_Control18Lbl@7001112 :
        CreditCaption_Control18Lbl: TextConst ENU = '<Credit>', ESP = 'Haber';
        //       Balance_dateCaptionLbl@7001111 :
        Balance_dateCaptionLbl: TextConst ENU = '<Balance Date>', ESP = 'Saldo a la fecha';
        //       BalanceCaptionLbl@7001110 :
        BalanceCaptionLbl: TextConst ENU = '<Balance>', ESP = 'Saldo';
        //       AccountCaption_Control30Lbl@7001109 :
        AccountCaption_Control30Lbl: TextConst ENU = '<Account>', ESP = 'Cuenta';
        //       NameCaption_Control41Lbl@7001108 :
        NameCaption_Control41Lbl: TextConst ENU = '<Name>', ESP = 'Nombre';
        //       Accum__periodCaption_Control42Lbl@7001107 :
        Accum__periodCaption_Control42Lbl: TextConst ENU = '<Accum. period>', ESP = 'Acum. periodo';
        //       DebitCaption_Control44Lbl@7001106 :
        DebitCaption_Control44Lbl: TextConst ENU = '<Debit>', ESP = 'Debe';
        //       CreditCaption_Control59Lbl@7001105 :
        CreditCaption_Control59Lbl: TextConst ENU = '<Credit>', ESP = 'Haber';
        //       Accum__period_dateCaption_Control60Lbl@7001104 :
        Accum__period_dateCaption_Control60Lbl: TextConst ENU = '<Accum. period date>', ESP = 'Acum. periodo a fecha';
        //       DebitCaption_Control62Lbl@7001103 :
        DebitCaption_Control62Lbl: TextConst ENU = '<Debit>', ESP = 'Debe';
        //       CreditCaption_Control63Lbl@7001102 :
        CreditCaption_Control63Lbl: TextConst ENU = '<Credit>', ESP = 'Haber';
        //       Balance_accum__dateCaptionLbl@7001101 :
        Balance_accum__dateCaptionLbl: TextConst ENU = '<Balance accum. date>', ESP = 'Saldo acum. a fecha';
        //       BalanceCaption_Control70Lbl@7001100 :
        BalanceCaption_Control70Lbl: TextConst ENU = '<Balance>', ESP = 'Saldo';
        //       OnlyAccountsWithbalanceDate@7001122 :
        OnlyAccountsWithbalanceDate: Boolean;
        //       ShowAmountsAddReportingCurrency@7001123 :
        ShowAmountsAddReportingCurrency: Boolean;
        //       ShowAcumBalanceDate@7001124 :
        ShowAcumBalanceDate: Boolean;
        //       IncludeOpeningEntries@7001125 :
        IncludeOpeningEntries: Boolean;
        //       IncludeClosingEntries@7001126 :
        IncludeClosingEntries: Boolean;
        //       Posting@7001127 :
        Posting: TextConst ENU = '<Posting>', ESP = 'Auxiliar';
        //       Heading@7001128 :
        Heading: TextConst ENU = '<Heading>', ESP = 'Mayor';



    trigger OnPreReport();
    begin
        //Seop
        //oti
        //Proyecto.COPYFILTER("Filtro Date",Cuenta."Filtro Date");

        //TextoFiltCG := Proyecto.GETFILTERS;
        //NomPeriodo := Proyecto.GETFILTER("Filtro Date");
        NamePeriod := "G/L Account".GETFILTER("Date Filter");
        NoDepartament := "G/L Account".GETFILTER("Global Dimension 1 Filter");
        if not Job.GET(NoDepartament) then begin end;
        // end oti
        //TextoFiltCG := Cuenta.GETFILTERS;
        //NomPeriodo := Cuenta.GETFILTER("Filtro Date");
        //end Seop
    end;



    // procedure BeginPeriod (Date@1100231000 :
    procedure BeginPeriod(Date: Date): Date;
    var
        //       AccountingPeriod@1100231001 :
        AccountingPeriod: Record 50;
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETFILTER("Starting Date", '<= %1', Date);
        if AccountingPeriod.FINDLAST then
            exit(AccountingPeriod."Starting Date")
        else
            ERROR('El a¤o fiscal no existe.');
    end;

    //     procedure OpenDate (Date@1100231000 :
    procedure OpenDate(Date: Date): Boolean;
    var
        //       AccountingPeriod@1100231001 :
        AccountingPeriod: Record 50;
    begin
        AccountingPeriod.SETRANGE(AccountingPeriod."New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE(AccountingPeriod."Starting Date", Date);
        if AccountingPeriod.FINDFIRST then
            exit(TRUE)
        else
            exit(FALSE);
    end;

    //     procedure CloseDate (LastDate@1100231000 :
    procedure CloseDate(LastDate: Date)
    var
        //       AccountingPeriod@1100231001 :
        AccountingPeriod: Record 50;
    begin
        AccountingPeriod.SETRANGE(AccountingPeriod."New Fiscal Year", TRUE);
        if AccountingPeriod.GET(NORMALDATE(LastDate) + 1) then
            exit
        else
            ERROR('The Date %1 no es una Date de cierre', LastDate);
    end;

    procedure CalcMovsOpen()
    var
        //       GLAccount@1100231000 :
        GLAccount: Record 15;
        //       AccountingPeriod@1100231001 :
        AccountingPeriod: Record 50;
    begin
        AccountingPeriod.SETRANGE(AccountingPeriod."New Fiscal Year", TRUE);
        AccountingPeriod.SETFILTER(AccountingPeriod."Starting Date", '<= %1', LastDate);
        if AccountingPeriod.FINDLAST then begin
            "G/L Account".GET("G/L Account"."No.");
            "G/L Account".SETRANGE("G/L Account"."Date Filter", 0D, CLOSINGDATE((AccountingPeriod."Starting Date" - 1)));
            "G/L Account".SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("Global Dimension 1 Filter"));
            "G/L Account".CALCFIELDS("Additional-Currency Net Change", "Net Change");
            if PrintAmountsAddCurrency then begin
                if "G/L Account"."Additional-Currency Net Change" > 0 then
                    EndAmountOpenDebit := "G/L Account"."Additional-Currency Net Change"
                else
                    EndAmountOpenCredit := ABS("G/L Account"."Additional-Currency Net Change");
            end else begin
                if "G/L Account"."Net Change" > 0 then
                    EndAmountOpenDebit := "G/L Account"."Net Change"
                else
                    EndAmountOpenCredit := ABS("G/L Account"."Net Change");
            end;
            if DateOpening then begin
                AmountOpenDebit := EndAmountOpenDebit;
                AmountOpenCredit := EndAmountOpenCredit;
            end;
        end;
    end;

    procedure CalcMovsClose()
    var
        //       GLAccount@1100231000 :
        GLAccount: Record 15;
        //       AccountingPeriod@1100231001 :
        AccountingPeriod: Record 50;
    begin
        AccountingPeriod.SETRANGE(AccountingPeriod."New Fiscal Year", TRUE);
        AccountingPeriod.GET((NORMALDATE(LastDate) + 1));
        "G/L Account".GET("G/L Account"."No.");
        "G/L Account".SETRANGE("G/L Account"."Date Filter", 0D, LastDate);
        "G/L Account".SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("Global Dimension 1 Filter"));
        "G/L Account".CALCFIELDS("Additional-Currency Net Change", "Net Change");
        if PrintAmountsAddCurrency then begin
            if "G/L Account"."Additional-Currency Net Change" > 0 then
                AmountCloseCredit := ABS("G/L Account"."Additional-Currency Net Change")
            else
                AmountCloseDebit := ABS("G/L Account"."Additional-Currency Net Change");
        end else begin
            if "G/L Account"."Net Change" > 0 then
                AmountCloseCredit := ABS("G/L Account"."Net Change")
            else
                AmountCloseDebit := ABS("G/L Account"."Net Change");
        end;
    end;

    procedure CalcMovsCloseGreader()
    var
        //       GLAccount@1100231000 :
        GLAccount: Record 15;
        //       Length@1100231001 :
        Length: Integer;
    begin
        GLAccount.SETRANGE("Date Filter", 0D, LastDate);
        GLAccount.SETFILTER("No.", "G/L Account".Totaling);
        GLAccount.SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("Global Dimension 1 Filter"));
        GLAccount.SETRANGE("Account Type", GLAccount."Account Type"::Posting);
        if GLAccount.FINDSET then begin
            repeat
                GLAccount.CALCFIELDS("Additional-Currency Net Change", "Net Change");
                if PrintAmountsAddCurrency then begin
                    if GLAccount."Additional-Currency Net Change" > 0 then
                        AmountCloseCredit := AmountCloseCredit + ABS(GLAccount."Additional-Currency Net Change")
                    else
                        AmountCloseDebit := AmountCloseDebit + ABS(GLAccount."Additional-Currency Net Change");
                end else begin
                    if GLAccount."Net Change" > 0 then
                        AmountCloseCredit := AmountCloseCredit + ABS(GLAccount."Net Change")
                    else
                        AmountCloseDebit := AmountCloseDebit + ABS(GLAccount."Net Change");
                end;
            until GLAccount.NEXT = 0;
        end;
    end;

    procedure CalcMovsOpenGreader()
    var
        //       GLAccount@1100231000 :
        GLAccount: Record 15;
        //       Length@1100231001 :
        Length: Integer;
        //       AccountingPeriod@1100231002 :
        AccountingPeriod: Record 50;
    begin
        AccountingPeriod.SETRANGE(AccountingPeriod."New Fiscal Year", TRUE);
        AccountingPeriod.SETFILTER(AccountingPeriod."Starting Date", '<= %1', FirstDate);
        if AccountingPeriod.FINDLAST then begin
            GLAccount.SETRANGE("Date Filter", 0D, CLOSINGDATE((AccountingPeriod."Starting Date" - 1)));
            GLAccount.SETFILTER("No.", "G/L Account".Totaling);
            GLAccount.SETRANGE("Account Type", GLAccount."Account Type"::Posting);
            GLAccount.SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("Global Dimension 1 Filter"));
            if GLAccount.FINDSET then;
            repeat
                GLAccount.CALCFIELDS("Additional-Currency Net Change", "Net Change");
                if PrintAmountsAddCurrency then begin
                    if GLAccount."Additional-Currency Net Change" > 0 then
                        EndAmountOpenDebit := EndAmountOpenDebit + ABS(GLAccount."Additional-Currency Net Change")
                    else
                        EndAmountOpenCredit := EndAmountOpenCredit + ABS(GLAccount."Additional-Currency Net Change");
                end else begin
                    if GLAccount."Net Change" > 0 then
                        EndAmountOpenDebit := EndAmountOpenDebit + ABS(GLAccount."Net Change")
                    else
                        EndAmountOpenCredit := EndAmountOpenCredit + ABS(GLAccount."Net Change");
                end;
            until GLAccount.NEXT = 0;
            if DateOpening then begin
                AmountOpenDebit := EndAmountOpenDebit;
                AmountOpenCredit := EndAmountOpenCredit;
            end;
        end;
    end;

    /*begin
    //{
//      A¤adimos un footer enn cuenta que pone el balance a 0
//    }
    end.
  */

}




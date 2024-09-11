page 7206968 "QB Liquidate Movs"
{
    CaptionML = ENU = 'Open Invoices - Transactions', ESP = 'Liquidar movimientos Cliente/Proveedor';
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("Currency"; Currency)
            {

                CaptionML = ESP = 'Divisa';

                ; trigger OnValidate()
                BEGIN
                    SetPages;
                END;


            }
            group("group65")
            {

                part("PGCustomer"; 7206969)
                {
                    SubPageLink = "Open" = CONST(true), "Document Situation" = CONST(" ");
                    UpdatePropagation = Both;
                }
                part("PGVendor"; 7206970)
                {
                    SubPageLink = "Open" = CONST(true), "Document Situation" = CONST(" ");
                    UpdatePropagation = Both;
                }

            }
            field("TotalToLiquidate"; TotalAmount)
            {

                CaptionML = ENU = 'Amount to Liquidate', ESP = 'Neto a liquidar';
            }

        }
    }
    actions
    {
        area(Navigation)
        {
            //Name=General;
            group("group")
            {
                action("LiquidateMovs")
                {
                    CaptionML = ENU = 'Liquidate Invoices',
                                 ESP = 'Liquidar Movimientos';
                    Image = Invoice;
                    trigger OnAction()
                    BEGIN
                        IF CONFIRM(Confirm001) THEN
                            Liquidate;
                    END;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(LiquidateMovs_Promoted; LiquidateMovs)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        CalculateTotalAmount;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalculateTotalAmount;
    END;



    var
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        GenJournalLine: Record 81;
        GeneralLedgerSetup: Record 98;
        GeneralJournal: Page 39;
        TotalAmountCust: Decimal;
        TotalAmountVend: Decimal;
        LineNo: Integer;
        Third: Code[20];
        Currency: Code[20];
        TotalAmount: Decimal;
        Confirm001: TextConst ENU = 'The luquidation will be made through a journal, Do you want to continue?', ESP = 'Se va a realizar la liquidaci�n a trav�s de un diario, �Deseas continuar?';

    procedure SetData(pThird: Code[20]; pCurrency: Code[20]);
    begin
        Third := pThird;
        Currency := pCurrency;
        SetPages;
    end;

    LOCAL procedure SetPages();
    begin
        CurrPage.PGCustomer.PAGE.SetThird(Third, Currency);
        CurrPage.PGVendor.PAGE.SetThird(Third, Currency);
    end;

    procedure CalculateTotalAmount();
    var
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        TotalAmountCust: Decimal;
        TotalAmountVend: Decimal;
    begin
        TotalAmountCust := CurrPage.PGCustomer.PAGE.GetAmount;
        TotalAmountVend := CurrPage.PGVendor.PAGE.GetAmount;
        TotalAmount := ABS(TotalAmountCust - TotalAmountVend);
    end;

    LOCAL procedure Liquidate();
    begin
        TotalAmountCust := 0;
        TotalAmountVend := 0;
        LineNo := 0;

        CustLedgerEntry.RESET;
        //++CustLedgerEntry.SETRANGE("Customer No.",CustomerNo);
        //CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
        //CustLedgerEntry.SETRANGE("Document Status",CustLedgerEntry."Document Status"::Open);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Document Situation", CustLedgerEntry."Document Situation"::" ");
        CustLedgerEntry.SETRANGE("QB To Liquidate", TRUE);
        if CustLedgerEntry.FINDSET then
            repeat
                CustLedgerEntry.CALCFIELDS(Amount);
                TotalAmountCust += CustLedgerEntry.Amount;
            until CustLedgerEntry.NEXT = 0;

        VendorLedgerEntry.RESET;
        //++VendorLedgerEntry.SETRANGE("Vendor No.",VendorNo);
        //VendorLedgerEntry.SETRANGE("Document Type",VendorLedgerEntry."Document Type"::Invoice);
        //VendorLedgerEntry.SETRANGE("Document Status",VendorLedgerEntry."Document Status"::Open);
        VendorLedgerEntry.SETRANGE(Open, TRUE);
        VendorLedgerEntry.SETRANGE("Document Situation", VendorLedgerEntry."Document Situation"::" ");
        VendorLedgerEntry.SETRANGE("QB To Liquidate", TRUE);
        if VendorLedgerEntry.FINDSET then
            repeat
                VendorLedgerEntry.CALCFIELDS(Amount);
                TotalAmountVend += VendorLedgerEntry.Amount;
            until VendorLedgerEntry.NEXT = 0;

        // GenJournalLine.RESET;
        // GenJournalLine.SETRANGE("Journal Template Name",GeneralLedgerSetup."Journal Template Name");
        // GenJournalLine.SETRANGE("Journal Batch Name",GeneralLedgerSetup."Journal Batch Name");
        // if GenJournalLine.FINDSET then
        //  repeat
        //    GenJournalLine.DELETE;
        //  until GenJournalLine.NEXT = 0;

        CustLedgerEntry.RESET;
        //++CustLedgerEntry.SETRANGE("Customer No.",CustomerNo);
        //CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
        //CustLedgerEntry.SETRANGE("Document Status",CustLedgerEntry."Document Status"::Open);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Document Situation", CustLedgerEntry."Document Situation"::" ");
        CustLedgerEntry.SETRANGE("QB To Liquidate", TRUE);
        if CustLedgerEntry.FINDSET then
            repeat
                CustLedgerEntry.CALCFIELDS(Amount);
                LineNo += 1;
                GenJournalLine.INIT;
                //GenJournalLine.VALIDATE("Journal Template Name",GeneralLedgerSetup."Journal Template Name");
                //GenJournalLine.VALIDATE("Journal Batch Name",GeneralLedgerSetup."Journal Batch Name");
                GenJournalLine.VALIDATE("Line No.", LineNo);
                GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
                GenJournalLine.VALIDATE("Account No.", CustLedgerEntry."Customer No.");
                GenJournalLine.VALIDATE("Posting Date", WORKDATE);
                GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice);
                GenJournalLine.VALIDATE("Document No.", CustLedgerEntry."Document No.");
                GenJournalLine.VALIDATE(Amount, CustLedgerEntry.Amount);
                GenJournalLine.INSERT;
            until CustLedgerEntry.NEXT = 0;

        VendorLedgerEntry.RESET;
        //++VendorLedgerEntry.SETRANGE("Vendor No.",VendorNo);
        //VendorLedgerEntry.SETRANGE("Document Type",VendorLedgerEntry."Document Type"::Invoice);
        //VendorLedgerEntry.SETRANGE("Document Status",VendorLedgerEntry."Document Status"::Open);
        VendorLedgerEntry.SETRANGE(Open, TRUE);
        VendorLedgerEntry.SETRANGE("Document Situation", VendorLedgerEntry."Document Situation"::" ");
        VendorLedgerEntry.SETRANGE("QB To Liquidate", TRUE);
        if VendorLedgerEntry.FINDSET then
            repeat
                VendorLedgerEntry.CALCFIELDS(Amount);
                LineNo += 1;
                GenJournalLine.INIT;
                //GenJournalLine.VALIDATE("Journal Template Name",GeneralLedgerSetup."Journal Template Name");
                //GenJournalLine.VALIDATE("Journal Batch Name",GeneralLedgerSetup."Journal Batch Name");
                GenJournalLine.VALIDATE("Line No.", LineNo);
                GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
                GenJournalLine.VALIDATE("Account No.", VendorLedgerEntry."Vendor No.");
                GenJournalLine.VALIDATE("Posting Date", WORKDATE);
                GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice);
                GenJournalLine.VALIDATE("Document No.", VendorLedgerEntry."Document No.");
                GenJournalLine.VALIDATE(Amount, VendorLedgerEntry.Amount);
                GenJournalLine.INSERT;
            until VendorLedgerEntry.NEXT = 0;

        if ABS(TotalAmountCust) > ABS(TotalAmountVend) then begin
            LineNo += 1;
            GenJournalLine.INIT;
            //GenJournalLine.VALIDATE("Journal Template Name",GeneralLedgerSetup."Journal Template Name");
            //GenJournalLine.VALIDATE("Journal Batch Name",GeneralLedgerSetup."Journal Batch Name");
            GenJournalLine.VALIDATE("Line No.", LineNo);
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
            //++GenJournalLine.VALIDATE("Account No.",VendorNo);
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice);
            GenJournalLine.VALIDATE("Document No.", CustLedgerEntry."Document No.");
            GenJournalLine.VALIDATE("Posting Date", WORKDATE);
            GenJournalLine.VALIDATE(Amount, TotalAmountVend - TotalAmountCust);
            GenJournalLine.INSERT;
        end;

        if ABS(TotalAmountCust) < ABS(TotalAmountVend) then begin
            LineNo += 1;
            GenJournalLine.INIT;
            //GenJournalLine.VALIDATE("Journal Template Name",GeneralLedgerSetup."Journal Template Name");
            //GenJournalLine.VALIDATE("Journal Batch Name",GeneralLedgerSetup."Journal Batch Name");
            GenJournalLine.VALIDATE("Line No.", LineNo);
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
            //++GenJournalLine.VALIDATE("Account No.",CustomerNo);
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice);
            GenJournalLine.VALIDATE("Document No.", VendorLedgerEntry."Document No.");
            GenJournalLine.VALIDATE("Posting Date", WORKDATE);
            GenJournalLine.VALIDATE(Amount, TotalAmountCust - TotalAmountVend);
            GenJournalLine.INSERT;
        end;

        COMMIT;
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Line", GenJournalLine);
    end;

    // begin//end
}









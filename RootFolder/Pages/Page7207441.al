page 7207441 "Element Journal Line"
{
    CaptionML = ENU = 'Element Journal Line', ESP = 'Lin. diario elemento';
    SaveValues = true;
    SourceTable = 7207350;
    DelayedInsert = true;
    DataCaptionFields = "Journal Batch Name";
    PageType = Worksheet;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            field("CurrentJnlBatchName"; CurrentJnlBatchName)
            {

                Lookup = true;
                CaptionML = ENU = 'Batch Name', ESP = 'Nombre secci�n';

                ; trigger OnValidate()
                BEGIN
                    ElementJournalManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                END;

                trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    CurrPage.SAVERECORD;
                    ElementJournalManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                END;


            }
            repeater("table")
            {

                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document No."; rec."Document No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Element No."; rec."Element No.")
                {

                }
                field("Entry Type"; rec."Entry Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Contract No."; rec."Contract No.")
                {

                }
                field("Rent Effective Date"; rec."Rent Effective Date")
                {

                }
                field("Document Date"; rec."Document Date")
                {

                    Visible = False;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Applied Entry No."; rec."Applied Entry No.")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Variante Code"; rec."Variante Code")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Business Unit Code"; rec."Business Unit Code")
                {

                    Visible = False;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                    Visible = False;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    Visible = False;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    Visible = False;
                }
                field("ShortcutDimCode[3]_"; ShortcutDimCode[3])
                {

                    CaptionClass = '1,2,3';
                    Visible = False;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    END;


                }
                field("ShortcutDimCode[4]_"; ShortcutDimCode[4])
                {

                    CaptionClass = '1,2,4';
                    Visible = False;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    END;


                }
                field("ShortcutDimCode[5]_"; ShortcutDimCode[5])
                {

                    CaptionClass = '1,2,5';
                    Visible = False;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    END;


                }
                field("ShortcutDimCode[6]_"; ShortcutDimCode[6])
                {

                    CaptionClass = '1,2,6';
                    Visible = False;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    END;


                }
                field("ShortcutDimCode[7]_"; ShortcutDimCode[7])
                {

                    CaptionClass = '1,2,7';
                    Visible = False;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    END;


                }
                field("ShortcutDimCode[8]_"; ShortcutDimCode[8])
                {

                    CaptionClass = '1,2,8';
                    Visible = False;

                    ; trigger OnValidate()
                    BEGIN
                        rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    END;


                }
                field("Reason code"; rec."Reason code")
                {

                    Visible = False;
                }
                field("Transaction No."; rec."Transaction No.")
                {

                }

            }
            group("group41")
            {

                group("group42")
                {

                    group("group43")
                    {

                        CaptionML = ENU = 'Account Name', ESP = 'Nombre cuenta';
                        field("AccName"; AccName)
                        {

                            Editable = False;
                            Style = Strong;
                            StyleExpr = TRUE;
                        }

                    }
                    group("group45")
                    {

                        CaptionML = ENU = 'BAlance', ESP = 'Saldo';
                        field("Balance"; Balance + rec.Quantity - xRec.Quantity)
                        {

                            CaptionML = ENU = 'Balnace', ESP = 'Saldo';
                            AutoFormatType = 1;
                            Visible = BalanceVisible;
                            Editable = False;
                            Style = Strong;
                            StyleExpr = TRUE;
                        }

                    }
                    group("group47")
                    {

                        CaptionML = ENU = 'Total Balance', ESP = 'Saldo total';
                        field("TotalBalance"; TotalBalance + rec.Quantity - xRec.Quantity)
                        {

                            CaptionML = ENU = 'Total Balance', ESP = 'Saldo total';
                            AutoFormatType = 1;
                            Visible = TotalBalanceVisible;
                            Editable = False;
                            Style = Standard;
                            StyleExpr = TRUE

  ;
                        }

                    }

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                        CurrPage.SAVERECORD;
                    END;


                }

            }
            group("group4")
            {
                CaptionML = ENU = '&Elemento', ESP = '&Elemento';
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207448;
                    RunPageLink = "No." = FIELD("Element No.");
                    Image = EditLines;
                }
                action("action3")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Master E&ntries', ESP = 'Movs. de elemento';
                    RunObject = Codeunit 7207321;
                    Image = JobLedger;
                }

            }

        }
        area(Processing)
        {

            group("group8")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registrar';
                action("action4")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = '&Registrar';
                    Image = Post;

                    trigger OnAction()
                    BEGIN
                        CODEUNIT.RUN(CODEUNIT::"Journal (Element)-Register", Rec);
                        CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action5")
                {
                    ShortCutKey = 'Shift+F9';
                    CaptionML = ENU = 'Post and &Print', ESP = 'Registrar e &imprimir';
                    Image = PostPrint;


                    trigger OnAction()
                    BEGIN
                        CODEUNIT.RUN(CODEUNIT::"Journal. (Elem)-Register+Print", Rec);
                        CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }

    trigger OnInit()
    BEGIN
        TotalBalanceVisible := TRUE;
        BalanceVisible := TRUE;
    END;

    trigger OnOpenPage()
    BEGIN
        ElementJournalManagement.TemplateSelection(PAGE::"Element Journal Line", FALSE, Rec, JnlSelected);
        IF NOT JnlSelected THEN
            ERROR('');
        ElementJournalManagement.OpenJnl(CurrentJnlBatchName, Rec);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
        OnAfterGetCurrRecord_;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        UpdateBalance;
        rec.SetUpNewLine(xRec, Balance, BelowxRec);
        CLEAR(ShortcutDimCode);
        OnAfterGetCurrRecord_;
    END;



    var
        ElementJournalManagement: Codeunit 7207318;
        BalanceVisible: Boolean;
        TotalBalanceVisible: Boolean;
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        CurrentJnlBatchName: Code[10];
        AccName: Text[30];
        JnlSelected: Boolean;
        ShortcutDimCode: ARRAY[8] OF Code[10];

    LOCAL procedure UpdateBalance();
    begin
        ElementJournalManagement.CalcBalance(Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    LOCAL procedure CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD;
        ElementJournalManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure OnAfterGetCurrRecord_();
    begin
        xRec := Rec;
        ElementJournalManagement.GetAccounts(Rec, AccName);
        UpdateBalance;
    end;

    // begin//end
}








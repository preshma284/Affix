page 7207325 "Production Daily Line"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Production Daily Line', ESP = 'Lin. diario producci�n';
    SaveValues = true;
    SourceTable = 7207327;
    DelayedInsert = true;
    DataCaptionFields = "Daily Book Name";
    PageType = Worksheet;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            group("group10")
            {

                field("CurrentJnlName"; CurrentJnlName)
                {

                    Lookup = true;
                    CaptionML = ENU = 'Batch Name', ESP = 'Diario';
                    ToolTipML = ENU = 'Specifies the name of the journal batch.', ESP = 'Especifica el nombre de la secci�n del diario de producci�n';

                    ; trigger OnValidate()
                    BEGIN
                        ProductionDayManage.CheckName(Rec);
                        CurrentJnlBatchNameOnAfterValidate;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CurrPage.SAVERECORD;
                        ProductionDayManage.LookName(Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }
            repeater("Group")
            {

                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Job No."; rec."Job No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        GetJob;
                    END;


                }
                field("Job.Description"; Job.Description)
                {

                    CaptionML = ESP = 'Descripci�n';
                    Editable = FALSE;
                }
                field("Job.Production Calculate Mode"; Job."Production Calculate Mode")
                {

                    CaptionML = ESP = 'Modo de calculo de la producci�n';
                    Editable = FALSE;
                }
                field("Customer.No."; Customer."No.")
                {

                    CaptionML = ESP = 'Cliente';
                }
                field("Customer.Name"; Customer.Name)
                {

                    CaptionML = ESP = 'Nombre';
                }
                field("G/L Account"; rec."G/L Account")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                    Visible = false;
                }
                field("Previous WIP"; rec."Previous WIP")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        JobLedgerEntry.RESET;
                        JobLedgerEntry.SETRANGE("Job No.", rec."Job No.");
                        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Sale);
                        JobLedgerEntry.SETRANGE("Job in progress", TRUE);
                        PAGE.RUN(0, JobLedgerEntry);
                    END;


                }
                field("Production Origin"; rec."Production Origin")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        HistProdMeasureLines.RESET;
                        HistProdMeasureLines.SETRANGE("Job No.", rec."Job No.");

                        PAGE.RUN(0, HistProdMeasureLines);
                    END;


                }
                field("Invoiced"; rec."Invoiced")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        JobLedgerEntry.RESET;
                        JobLedgerEntry.SETRANGE("Job No.", rec."Job No.");
                        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Sale);
                        JobLedgerEntry.SETRANGE("Posting Date", 0D, rec."Posting Date");
                        JobLedgerEntry.SETRANGE("Job in progress", FALSE);

                        PAGE.RUN(0, JobLedgerEntry);
                    END;


                }
                field("Job in Progress"; rec."Job in Progress")
                {

                }
                field("Previous WIP (LCY)"; rec."Previous WIP (LCY)")
                {

                }
                field("Production Origin (LCY)"; rec."Production Origin (LCY)")
                {

                }
                field("Invoiced (LCY)"; rec."Invoiced (LCY)")
                {

                }
                field("Job in Progress (LCY)"; rec."Job in Progress (LCY)")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = 'Acti&ons', ESP = 'Acci&ones';
                action("action1")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'Post', ESP = '&Registrar';
                    Image = Post;

                    trigger OnAction()
                    VAR
                        ProductionDailyRegister: Codeunit 7207285;
                    BEGIN
                        CLEAR(ProductionDailyRegister);
                        ProductionDailyRegister."Run(Y/N)"(Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }
            group("group4")
            {
                CaptionML = ENU = '&L�nea', ESP = '&L�nea';
                action("action2")
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
            group("group6")
            {
                CaptionML = ENU = 'Production', ESP = 'Proyecto';
                // ActionContainerType =NewDocumentItems ;
                action("action3")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207478;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = Job;
                }
                action("action4")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    RunObject = Page 92;
                    RunPageLink = "Job No." = FIELD("Job No.");
                    Image = JobLedger;
                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        CurrentJnlName := ProductionDayManage.SelectBook(Rec);
        IF (CurrentJnlName = '') THEN
            ERROR('');

        //ProductionDayManage.OpenBook(CurrentJnlName,Rec);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
        GetJob;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.SetUpNewLine(CurrentJnlName);
        CLEAR(ShortcutDimCode);
        CLEAR(Customer);
        CLEAR(Job);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        xRec := Rec;
        ProductionDayManage.CatchName(Rec, JobDescription, ModeCalculate);
    END;



    var
        Job: Record 167;
        Customer: Record 18;
        DailyBookProduction: Record 7207326;
        HistProdMeasureLines: Record 7207402;
        JobLedgerEntry: Record 169;
        ProductionDayManage: Codeunit 7207280;
        CurrentJnlName: Code[10];
        JobDescription: Text[60];
        txtModeCalculation: Text[250];
        OpenedFromBatch: Boolean;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        ModeCalculate: Text[250];

    LOCAL procedure CurrentJnlBatchNameOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
        ProductionDayManage.EstablishName(CurrentJnlName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure GetJob();
    begin
        if not Job.GET(rec."Job No.") then
            Job.INIT;
        if not Customer.GET(Job."Bill-to Customer No.") then
            Customer.INIT;
    end;

    // begin//end
}









page 7207404 "Activation Header"
{
    CaptionML = ENU = 'Activation Header', ESP = 'Cabecera activaci�n';
    SourceTable = 7207367;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Element Code"; rec."Element Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }

            }
            part("LinDoc"; 7207406)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("Registro")
            {

                CaptionML = ENU = 'Record', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension1CodeOnAfterV;
                    END;


                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension2CodeOnAfterV;
                    END;


                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207465)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {
                ;
            }
            systempart(Links; Links)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Document', ESP = '&Documento';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Statistic Document Activat", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207448;
                    RunPageLink = "No." = FIELD("Element Code");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207407;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group8")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action5")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207308;
                    Image = Post;
                }
                action("action6")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por &lotes';
                    Image = PostBatch;


                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Rec. by Activation Batch", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;



    var
        PurchasesPayablesSetup: Record 312;
        MoveNegativePurchaseLines: Report 6698;
        CopyPurchaseDocument: Report 492;
        TestReportPrint: Codeunit 228;
        UserSetupManagement: Codeunit 5700;

    LOCAL procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    // begin//end
}








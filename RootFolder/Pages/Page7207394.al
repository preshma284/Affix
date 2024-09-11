page 7207394 "Hist. Expense Notes"
{
    Editable = false;
    CaptionML = ENU = 'Hist. Expense Notes', ESP = 'Hist. Notas de gasto';
    InsertAllowed = false;
    SourceTable = 7207323;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {

                }
                field("Employee"; rec."Employee")
                {

                }
                field("Expense Description"; rec."Expense Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Expense Note Date"; rec."Expense Note Date")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {

                }
                field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
                {

                }
                field("Remaining Advance Amount DL"; rec."Remaining Advance Amount DL")
                {

                }

            }
            part("part1"; 7207395)
            {

                CaptionML = ENU = 'Hist. Exp. Notes Lines Subform', ESP = 'Subform. Hist. Lineas notas de gasto';
                SubPageLink = "Document No." = FIELD("No.");
            }

        }
        area(FactBoxes)
        {
            part("IncomingDocAttachFactBox"; 193)
            {

                ApplicationArea = Basic, Suite;
                Visible = NOT IsOfficeAddin;
                ShowFilter = false;
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
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
                CaptionML = ENU = '&Document', ESP = '&Notas';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207358;
                    RunPageLink = "Document Type" = CONST("Expense Notes Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("<Action4>")
                {

                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }

        }
        area(Processing)
        {

            action("Imprimir")
            {

                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = '&Imprimir';
                Image = Print;

                trigger OnAction()
                VAR
                    HistExpenseNotesHeader: Record 7207323;
                BEGIN
                    HistExpenseNotesHeader.RESET;
                    HistExpenseNotesHeader.SETRANGE("No.", rec."No.");
                    // REPORT.RUNMODAL(REPORT::"Hist. Expense Notes", TRUE, FALSE, HistExpenseNotesHeader);
                END;


            }
            action("Navegar")
            {

                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;


                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Imprimir_Promoted; Imprimir)
                {
                }
                actionref(Navegar_Promoted; Navegar)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsability(Rec);

        //JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
        IsOfficeAddin := OfficeMgt.IsAvailable;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    END;



    var
        "------------------------------ FactBox Documentos": Integer;
        IsOfficeAddin: Boolean;
        OfficeMgt: Codeunit 1630;/*

    begin
    {
      JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
    }
    end.*/


}








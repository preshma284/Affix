page 7207396 "Hist. Expense Notes List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = '"Hist. Expense Notes" List', ESP = 'Lista Hist. notas gasto';
    SourceTable = 7207323;
    PageType = List;
    CardPageID = "Hist. Expense Notes";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
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
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }

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

            }

        }
        area(Processing)
        {

            action("<Action22>")
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
            action("<Action27>")
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
                actionref("<Action22>_Promoted"; "<Action22>")
                {
                }
                actionref("<Action27>_Promoted"; "<Action27>")
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
      JAV 30/05/19: - Se a�ade la columna del proyecto
      JAV 04/08/19: - Se a�ade la columna de texto de registro
      JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
    }
    end.*/


}









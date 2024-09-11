page 7207392 "Expense Notes List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Expense Note List', ESP = 'Lista notas de gasto';
    SourceTable = 7207320;
    PageType = List;
    CardPageID = "Expense Notes";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                }
                field("Expense Description"; rec."Expense Description")
                {

                }
                field("Posting Date"; rec."Posting Date")
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
        area(FactBoxes)
        {
            part("part1"; 7207491)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            part("IncomingDocAttachFactBox"; 193)
            {

                ApplicationArea = Basic, Suite;
                Visible = NOT IsOfficeAddin;
                ShowFilter = false;
            }
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);

        //JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
        IsOfficeAddin := OfficeMgt.IsAvailable;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

        //JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
        IsOfficeAddin := OfficeMgt.IsAvailable;
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









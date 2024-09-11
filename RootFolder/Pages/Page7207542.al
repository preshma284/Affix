page 7207542 "Costsheet Hist. List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = '"Costsheet Hist." List', ESP = 'Lista hist. partes coste';
    SourceTable = 7207435;
    PageType = List;
    CardPageID = "Costsheet Hist.";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
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
                field("Amount"; rec."Amount")
                {

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
                CaptionML = ENU = 'Partes', ESP = '&Partes';
                action("action1")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Sheet Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action2")
            {
                CaptionML = ENU = 'Navigate', ESP = 'Navegar';
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
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    VAR
        FunctionsQB: Codeunit 7207272;
    BEGIN
        rec.ResponsabilityFilters(Rec);

        //CPA 03-02-22. Q16275 - Permisos.Begin
        FunctionsQB.SetUserJobPostedCostsheetHeaderFilter(Rec);
        //CPA 03-02-22. Q16275 - Permisos.End
    END;


    /*

        begin
        {
          CPA 03/02/22: - Q16275 - Permisos por proyecto. Modificaciones en OnOpenPage
          JAV 01/06/22: - QB 1.10.46 Se a�ade el campo Amount con la suma de las l�neas
        }
        end.*/


}









page 7207540 "Costsheet Hist."
{
    Editable = false;
    CaptionML = ENU = 'Costsheet Hist.', ESP = 'Hist. Partes coste';
    InsertAllowed = false;
    SourceTable = 7207435;
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
                field("Amount"; rec."Amount")
                {

                }

            }
            part("HistLinDoc"; 7207541)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Parts', ESP = 'Partes';
                action("action1")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("<Dimensions>")
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

            action("Navegar")
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
                actionref(Navegar_Promoted; Navegar)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.ResponsabilityFilters(Rec);
    END;


    /*

        begin
        {
          JAV 01/06/22: - QB 1.10.46 Se a�ade el campo Amount con la suma de las l�neas
        }
        end.*/


}








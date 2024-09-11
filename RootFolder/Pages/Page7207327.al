page 7207327 "Production Daily Book"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Production Daily Book', ESP = 'Libros diarios producci�n';
    SourceTable = 7207326;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Name"; rec."Name")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Serie No."; rec."Serie No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Posting Serie No."; rec."Posting Serie No.")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Source Code"; rec."Source Code")
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
                CaptionML = ENU = 'Te&mplate', ESP = '&Libro';
                action("action1")
                {
                    CaptionML = ENU = 'Batches', ESP = 'Secciones';
                    RunObject = Page 7207326;
                    // to be refactored
                    // RunPageLink = "Entry No." = FIELD("Name");
                    Image = SelectLineToApply;
                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }

    var
        ObjectTranslation: Record 377;
        FrmLanguage: Integer;
        FunctionQB: Codeunit 7207272;

    /*begin
    end.
  
*/
}









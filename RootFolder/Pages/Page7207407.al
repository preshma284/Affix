page 7207407 "Activation Comments Line"
{
    CaptionML = ENU = 'Activation Comments Line', ESP = 'Lista comentarios activaci�n';
    MultipleNewLines = true;
    SourceTable = 7207369;
    DelayedInsert = true;
    PageType = List;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Date"; rec."Date")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Comment"; rec."Comment")
                {

                }
                field("Code"; rec."Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE

  ;
                }

            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.SetUpNewLine;
    END;




    /*begin
    end.
  
*/
}








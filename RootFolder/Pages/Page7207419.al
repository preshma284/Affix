page 7207419 "Usage Comment List"
{
    CaptionML = ENU = 'Usage Comment List', ESP = 'Lista comentarios utilizaci�n';
    MultipleNewLines = true;
    SourceTable = 7207364;
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








page 7207432 "Commen Deliv/Ret Element List"
{
    CaptionML = ENU = 'Commen Deliv/Ret Element List', ESP = 'Lista comen entrega/devl elem';
    MultipleNewLines = true;
    SourceTable = 7207358;
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

                    Style = Strong;
                    StyleExpr = TRUE;
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








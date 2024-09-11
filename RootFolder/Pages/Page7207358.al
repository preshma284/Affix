page 7207358 "Exp. Notes Comment Sheet"
{
    CaptionML = ENU = 'Exp. Notes Comment Sheet', ESP = 'Hoja comentarios NG';
    MultipleNewLines = true;
    SourceTable = 7207322;
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

                }
                field("Comment"; rec."Comment")
                {

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








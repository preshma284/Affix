page 7207439 "Element Contract Comment List"
{
    CaptionML = ENU = 'Element Contract Comment List', ESP = 'Lista comen. contrato elemento';
    MultipleNewLines = true;
    SourceTable = 7207355;
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

                }

            }

        }
    }
    trigger OnNextRecord(Steps: Integer): Integer
    BEGIN
        rec.SetUpNewLine;
    END;




    /*begin
    end.
  
*/
}








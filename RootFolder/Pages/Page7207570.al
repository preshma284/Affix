page 7207570 "Description Long Line"
{
    CaptionML = ENU = 'Aditional Text', ESP = 'Texto Adicional U.O.';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206918;
    PageType = CardPart;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            field("Text1"; "Text1")
            {

                MultiLine = true;
                Style = StandardAccent;
                StyleExpr = TRUE;



                ; trigger OnValidate()
                BEGIN
                    IF NOT Rec.MODIFY THEN Rec.INSERT;
                    rec.SetCostText(Text1);
                END;


            }

        }
    }
    trigger OnAfterGetCurrRecord()
    BEGIN
        Text1 := rec.GetCostText;
    END;



    var
        Text1: Text;



    /*begin
        end.

    */
}








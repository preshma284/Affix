page 7207580 "Bill Of Items Uses"
{
    Editable = true;
    CaptionML = ENU = 'Bill Of Items Uses', ESP = 'Usos de descompuesto';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207387;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Job No."; rec."Job No.")
                {

                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Editable = FALSE;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("UnitDescription"; rec."UnitDescription")
                {

                    CaptionML = ENU = 'Unit Description', ESP = 'Descripcion Unidad';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Cod. Budget"; rec."Cod. Budget")
                {

                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("Performance By Piecework"; rec."Performance By Piecework")
                {

                }
                field("Direct Unitary Cost (JC)"; rec."Direct Unitary Cost (JC)")
                {

                }
                field("Budget Cost"; rec."Budget Cost")
                {

                }

            }

        }
    }


    /*begin
    end.
  
*/
}








page 7207526 "Piecew x Job Bill of Item List"
{
    CaptionML = ENU = 'JU x Job Bill of Item List', ESP = 'Listado descompuesto UO x proy';
    SourceTable = 7207387;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Cost Type"; rec."Cost Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Activity Code"; rec."Activity Code")
                {

                }
                field("Analytical Concept Direct Cost"; rec."Analytical Concept Direct Cost")
                {

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
    trigger OnOpenPage()
    BEGIN
        IF Job.GET(rec."Job No.") THEN BEGIN
            IF Job."Current Piecework Budget" <> '' THEN
                Rec.SETRANGE("Cod. Budget", Job."Current Piecework Budget")
            ELSE
                Rec.SETRANGE("Cod. Budget", Job."Initial Budget Piecework")
        END;
    END;



    var
        Job: Record 167;

    /*begin
    end.
  
*/
}








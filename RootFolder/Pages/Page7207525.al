page 7207525 "Piecework Cost List"
{
    CaptionML = ENU = 'Piecework Cost List', ESP = 'Lista coste UO';
    SourceTable = 7207387;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Cod. Budget"; rec."Cod. Budget")
                {

                    Visible = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Cost Type"; rec."Cost Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                }
                field("Analytical Concept Direct Cost"; rec."Analytical Concept Direct Cost")
                {

                }
                field("Performance By Piecework"; rec."Performance By Piecework")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                    Visible = verDivisas;
                }
                field("Currency Date"; rec."Currency Date")
                {

                    Visible = verDivisas;
                }
                field("Currency Factor"; rec."Currency Factor")
                {

                    Visible = verDivisas;
                }
                field("Direc Unit Cost"; rec."Direc Unit Cost")
                {

                }
                field("Direct Unitary Cost (JC)"; rec."Direct Unitary Cost (JC)")
                {

                    Visible = verDivisas;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Cost"; rec."Budget Cost")
                {

                    DecimalPlaces = 0 : 9;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 25/07/19: - Se hacen visibles los campos de divisas seg�n configuraci�n de Quobuilding
        QuoBuildingSetup.GET();
        verDivisas := QuoBuildingSetup."Use Currency in Jobs";
    END;



    var
        QuoBuildingSetup: Record 7207278;
        verDivisas: Boolean;/*

    begin
    {
      JAV 25/07/19: - Se hacen visibles los campos de divisas seg�n configuraci�n de Quobuilding
    }
    end.*/


}








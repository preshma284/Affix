page 7207572 "Job Records List"
{
    Editable = false;
    CaptionML = ENU = 'Job Records List', ESP = 'Lista expediente obra';
    SourceTable = 7207393;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Record Type"; rec."Record Type")
                {

                }
                field("Record Status"; rec."Record Status")
                {

                }
                field("Estimated Amount"; rec."Estimated Amount")
                {

                }
                field("SaleAmount(0)"; rec.SaleAmount(0))
                {

                    CaptionML = ENU = 'Production Amount', ESP = 'Importe producci�n';
                }
                field("CostAmount(0)"; rec.CostAmount(0))
                {

                    CaptionML = ENU = 'Cost Amount', ESP = 'Importe coste';
                }
                field("Entry Record Date"; rec."Entry Record Date")
                {

                }
                field("Shipment To Central Date"; rec."Shipment To Central Date")
                {

                }
                field("Initial Procedure Date"; rec."Initial Procedure Date")
                {

                }
                field("Piecework No."; rec."Piecework No.")
                {

                }

            }

        }
    }


    /*begin
    end.
  
*/
}








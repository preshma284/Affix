page 7207227 "QB BI Item Ledger Entries"
{
    SourceTable = 32;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Entry No."; rec."Entry No.")
                {

                }
                field("Entry Type"; rec."Entry Type")
                {

                }
                field("Item No."; rec."Item No.")
                {

                }
                field("Item Reference No."; rec."Item Reference No.")
                {

                }
                field("Lot No."; rec."Lot No.")
                {

                }
                field("Item Category Code"; rec."Item Category Code")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Expiration Date"; rec."Expiration Date")
                {

                }
                field("Warranty Date"; rec."Warranty Date")
                {

                }
                field("Document Date"; rec."Document Date")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Open"; rec."Open")
                {

                }
                field("Document Type"; rec."Document Type")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Job Task No."; rec."Job Task No.")
                {

                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {

                }
                field("Qty. per Unit of Measure"; rec."Qty. per Unit of Measure")
                {

                }
                field("Remaining Quantity"; rec."Remaining Quantity")
                {

                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                }
                field("Cost Amount (Expected)"; rec."Cost Amount (Expected)")
                {

                }
                field("Cost Amount (Actual)"; rec."Cost Amount (Actual)")
                {

                }
                field("Cost Amount (Non-Invtbl.)"; rec."Cost Amount (Non-Invtbl.)")
                {

                }
                field("Purchase Amount (Expected)"; rec."Purchase Amount (Expected)")
                {

                }
                field("Purchase Amount (Actual)"; rec."Purchase Amount (Actual)")
                {

                }
                field("Sales Amount (Expected)"; rec."Sales Amount (Expected)")
                {

                }
                field("Sales Amount (Actual)"; rec."Sales Amount (Actual)")
                {

                }
                field("Dimension Set ID"; rec."Dimension Set ID")
                {

                }
                field("Item_Description"; Item.Description)
                {

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF rec."Item No." <> Item."No." THEN
            IF NOT Item.GET(rec."Item No.") THEN CLEAR(Item);
    END;



    var
        Item: Record 27;

    /*begin
    end.
  
*/
}








page 7207228 "QB BI Value Entries"
{
    SourceTable = 5802;
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
                field("Item No."; rec."Item No.")
                {

                }
                field("Item Ledger Entry No."; rec."Item Ledger Entry No.")
                {

                }
                field("Item Ledger Entry Type"; rec."Item Ledger Entry Type")
                {

                }
                field("Item Ledger Entry Quantity"; rec."Item Ledger Entry Quantity")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Document Date"; rec."Document Date")
                {

                }
                field("Document Type"; rec."Document Type")
                {

                }
                field("Valuation Date"; rec."Valuation Date")
                {

                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {

                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {

                }
                field("Source No."; rec."Source No.")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Job Task No."; rec."Job Task No.")
                {

                }
                field("Job Ledger Entry No."; rec."Job Ledger Entry No.")
                {

                }
                field("Valued Quantity"; rec."Valued Quantity")
                {

                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                }
                field("Cost per Unit"; rec."Cost per Unit")
                {

                }
                field("Cost Posted to G/L"; rec."Cost Posted to G/L")
                {

                }
                field("Expected Cost"; rec."Expected Cost")
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








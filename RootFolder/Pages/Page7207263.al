page 7207263 "QB BI Pagos"
{
    SourceTable = 25;
    SourceTableView = WHERE("Document Type" = FILTER("Payment"));
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
                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document Type"; rec."Document Type")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Remaining Amount"; rec."Remaining Amount")
                {

                }
                field("Original Amt. (LCY)"; rec."Original Amt. (LCY)")
                {

                }
                field("Remaining Amt. (LCY)"; rec."Remaining Amt. (LCY)")
                {

                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {

                }
                field("Purchase (LCY)"; rec."Purchase (LCY)")
                {

                }
                field("Inv. Discount (LCY)"; rec."Inv. Discount (LCY)")
                {

                }
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {

                }
                field("Vendor Posting Group"; rec."Vendor Posting Group")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                }
                field("Purchaser Code"; rec."Purchaser Code")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("On Hold"; rec."On Hold")
                {

                }
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {

                }
                field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
                {

                }
                field("Open"; rec."Open")
                {

                }
                field("Due Date"; rec."Due Date")
                {

                }
                field("Pmt. Discount Date"; rec."Pmt. Discount Date")
                {

                }
                field("Original Pmt. Disc. Possible"; rec."Original Pmt. Disc. Possible")
                {

                }
                field("Positive"; rec."Positive")
                {

                }
                field("Closed by Entry No."; rec."Closed by Entry No.")
                {

                }
                field("Closed at Date"; rec."Closed at Date")
                {

                }
                field("Closed by Amount"; rec."Closed by Amount")
                {

                }
                field("Applies-to ID"; rec."Applies-to ID")
                {

                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Bal. Account Type"; rec."Bal. Account Type")
                {

                }
                field("Bal. Account No."; rec."Bal. Account No.")
                {

                }
                field("Transaction No."; rec."Transaction No.")
                {

                }
                field("Closed by Amount (LCY)"; rec."Closed by Amount (LCY)")
                {

                }
                field("Debit Amount"; rec."Debit Amount")
                {

                }
                field("Credit Amount"; rec."Credit Amount")
                {

                }
                field("Debit Amount (LCY)"; rec."Debit Amount (LCY)")
                {

                }
                field("Credit Amount (LCY)"; rec."Credit Amount (LCY)")
                {

                }
                field("Document Date"; rec."Document Date")
                {

                }
                field("External Document No."; rec."External Document No.")
                {

                }
                field("Closed by Currency Code"; rec."Closed by Currency Code")
                {

                }
                field("Closed by Currency Amount"; rec."Closed by Currency Amount")
                {

                }
                field("Adjusted Currency Factor"; rec."Adjusted Currency Factor")
                {

                }
                field("Original Currency Factor"; rec."Original Currency Factor")
                {

                }
                field("Original Amount"; rec."Original Amount")
                {

                }
                field("Remaining Pmt. Disc. Possible"; rec."Remaining Pmt. Disc. Possible")
                {

                }
                field("Pmt. Disc. Tolerance Date"; rec."Pmt. Disc. Tolerance Date")
                {

                }
                field("Max. Payment Tolerance"; rec."Max. Payment Tolerance")
                {

                }
                field("Amount to Apply"; rec."Amount to Apply")
                {

                }
                field("Applying Entry"; rec."Applying Entry")
                {

                }
                field("Reversed"; rec."Reversed")
                {

                }
                field("Reversed by Entry No."; rec."Reversed by Entry No.")
                {

                }
                field("Reversed Entry No."; rec."Reversed Entry No.")
                {

                }
                field("Prepayment"; rec."Prepayment")
                {

                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                }
                field("Applies-to Ext. Doc. No."; rec."Applies-to Ext. Doc. No.")
                {

                }
                field("Dimension Set ID"; rec."Dimension Set ID")
                {

                }
                field("Invoice Type"; rec."Invoice Type")
                {

                }
                field("Cr. Memo Type"; rec."Cr. Memo Type")
                {

                }
                field("Special Scheme Code"; rec."Special Scheme Code")
                {

                }
                field("Correction Type"; rec."Correction Type")
                {

                }
                field("Corrected Invoice No."; rec."Corrected Invoice No.")
                {

                }
                field("Succeeded Company Name"; rec."Succeeded Company Name")
                {

                }
                field("Succeeded VAT Registration No."; rec."Succeeded VAT Registration No.")
                {

                }
                field("Bill No."; rec."Bill No.")
                {

                }
                field("Document Situation"; rec."Document Situation")
                {

                }
                field("Applies-to Bill No."; rec."Applies-to Bill No.")
                {

                }
                field("Document Status"; rec."Document Status")
                {

                }
                field("Remaining Amount (LCY) stats."; rec."Remaining Amount (LCY) stats.")
                {

                }
                field("Amount (LCY) stats."; rec."Amount (LCY) stats.")
                {

                }
                field("QB Job No."; QB_JobNo)
                {

                    CaptionML = ESP = 'QB Job No.';
                }
                field("QW Withholding Entry"; rec."QW Withholding Entry")
                {

                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        getJobNo(QB_JobNo);
    END;



    var
        QB_JobNo: Code[20];
        DetailedVendLedgEntry: Record 380;

    LOCAL procedure getJobNo(var outQB_JobNo: Code[20]);
    begin
        CLEAR(outQB_JobNo);

        DetailedVendLedgEntry.RESET;
        DetailedVendLedgEntry.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");

        DetailedVendLedgEntry.SETRANGE("Applied Vend. Ledger Entry No.", rec."Entry No.");
        DetailedVendLedgEntry.SETRANGE("Entry Type", DetailedVendLedgEntry."Entry Type"::Application);
        DetailedVendLedgEntry.SETFILTER("Initial Document Type", '%1|%2|%3', DetailedVendLedgEntry."Initial Document Type"::Bill,
                                                                             DetailedVendLedgEntry."Initial Document Type"::"Credit Memo",
                                                                             DetailedVendLedgEntry."Initial Document Type"::Invoice);

        if DetailedVendLedgEntry.FINDFIRST then begin
            DetailedVendLedgEntry.CALCFIELDS("QB Job No.");
            outQB_JobNo := DetailedVendLedgEntry."QB Job No.";
        end;
    end;

    // begin//end
}








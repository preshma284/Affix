query 50137 "QB BI Aprobaciones"
{


    elements
    {

        DataItem("Approval_Entry"; "Approval Entry")
        {

            Column("TableID"; "Table ID")
            {

            }
            Column("DocumentType"; "Document Type")
            {

            }
            Column("DocumentNo"; "Document No.")
            {

            }
            Column("SequenceNo"; "Sequence No.")
            {

            }
            Column("ApprovalCode"; "Approval Code")
            {

            }
            Column("SenderID"; "Sender ID")
            {

            }
            Column("SalespersPurchCode"; "Salespers./Purch. Code")
            {

            }
            Column("ApproverID"; "Approver ID")
            {

            }
            Column("Status"; "Status")
            {

            }
            Column("DateTimeSentforApproval"; "Date-Time Sent for Approval")
            {

            }
            Column("LastDateTimeModified"; "Last Date-Time Modified")
            {

            }
            Column("LastModifiedByUserID"; "Last Modified By User ID")
            {

            }
            Column("Comment"; "Comment")
            {

            }
            Column("DueDate"; "Due Date")
            {

            }
            Column("Amount"; "Amount")
            {

            }
            Column("AmountLCY"; "Amount (LCY)")
            {

            }
            Column("CurrencyCode"; "Currency Code")
            {

            }
            Column("ApprovalType"; "Approval Type")
            {

            }
            Column("LimitType"; "Limit Type")
            {

            }
            Column("AvailableCreditLimitLCY"; "Available Credit Limit (LCY)")
            {

            }
            Column("PendingApprovals"; "Pending Approvals")
            {

            }
            Column("RecordIDtoApprove"; "Record ID to Approve")
            {

            }
            Column("DelegationDateFormula"; "Delegation Date Formula")
            {

            }
            Column("NumberofApprovedRequests"; "Number of Approved Requests")
            {

            }
            Column("NumberofRejectedRequests"; "Number of Rejected Requests")
            {

            }
            Column("EntryNo"; "Entry No.")
            {

            }
            Column("WorkflowStepInstanceID"; "Workflow Step Instance ID")
            {

            }
            Column("RelatedtoChange"; "Related to Change")
            {

            }
            Column("PostedSheet"; "Posted Sheet")
            {

            }
            Column("JobNo"; "Job No.")
            {

            }
            Column("PaymentTermsCode"; "Payment Terms Code")
            {

            }
            Column("PaymentMethodCode"; "Payment Method Code")
            {

            }
            Column("Type"; "Type")
            {

            }
            Column("Withholding"; "Withholding")
            {

            }
            Column("QBDocumentType"; "QB Document Type")
            {

            }
            Column("QBSubstituted"; "QB Substituted")
            {

            }
            Column("QBOriginalApprover"; "QB Original Approver")
            {

            }
            DataItem("Purchase_Header"; "Purchase Header")
            {

                DataItemLink = "No." = "Approval_Entry"."Document No.";
                Column("BuyfromVendorNo"; "Buy-from Vendor No.")
                {

                }
                Column("BuyfromVendorName"; "Buy-from Vendor Name")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}









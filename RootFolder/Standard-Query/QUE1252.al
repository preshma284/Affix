query 50213 "Bank Rec. Match Candidates 1"
{


    CaptionML = ENU = 'Bank Rec. Match Candidates', ESP = 'Candidatos para conciliaci�n bancaria';

    elements
    {

        DataItem("Bank_Acc_Reconciliation_Line"; "Bank Acc. Reconciliation Line")
        {

            DataItemTableFilter = "Difference" = FILTER(<> 0),
                                   "Type" = FILTER(= "Bank Account Ledger Entry");
            Column(Rec_Line_Bank_Account_No; "Bank Account No.")
            {

            }
            Column(Rec_Line_Statement_No; "Statement No.")
            {

            }
            Column(Rec_Line_Statement_Line_No; "Statement Line No.")
            {

            }
            Column(Rec_Line_Transaction_Date; "Transaction Date")
            {

            }
            Column(Rec_Line_Description; "Description")
            {

            }
            Column(Rec_Line_RltdPty_Name; "Related-Party Name")
            {

            }
            Column(Rec_Line_Transaction_Info; "Additional Transaction Info")
            {

            }
            Column(Rec_Line_Statement_Amount; "Statement Amount")
            {

            }
            Column(Rec_Line_Applied_Amount; "Applied Amount")
            {

            }
            Column(Rec_Line_Difference; "Difference")
            {

            }
            Column(Rec_Line_Type; "Type")
            {

            }
            Column(Rec_Line_Applied_Entries; "Applied Entries")
            {

            }
            DataItem("Bank_Account_Ledger_Entry"; "Bank Account Ledger Entry")
            {

                DataItemTableFilter = "Remaining Amount" = FILTER(<> 0),
                                   "Open" = CONST(true),
                                   "Statement Status" = FILTER("Open"),
                                   "Reversed" = CONST(false);
                DataItemLink = "Bank Account No." = "Bank_Acc_Reconciliation_Line"."Bank Account No.";
                Column("Entry_No"; "Entry No.")
                {

                }
                Column(Bank_Account_No; "Bank Account No.")
                {

                }
                Column("Posting_Date"; "Posting Date")
                {

                }
                Column("Document_No"; "Document No.")
                {

                }
                Column("Description"; "Description")
                {

                }
                Column("Remaining_Amount"; "Remaining Amount")
                {

                }
                Column(Bank_Ledger_Entry_Open; "Open")
                {

                }
                Column("Statement_Status"; "Statement Status")
                {

                }
                Column("External_Document_No"; "External Document No.")
                {

                }
            }
        }
    }


    /*begin
    end.
  */
}





query 50193 "G/L Entries 1"
{


    CaptionML = ENU = 'G/L Entries', ESP = 'Movimientos de contabilidad';

    elements
    {

        DataItem("G_L_Entry"; "G/L Entry")
        {

            Column("Entry_No"; "Entry No.")
            {

            }
            Column("Transaction_No"; "Transaction No.")
            {

            }
            Column("G_L_Account_No"; "G/L Account No.")
            {

            }
            Column("Posting_Date"; "Posting Date")
            {

            }
            Column("Document_Date"; "Document Date")
            {

            }
            Column("Document_Type"; "Document Type")
            {

            }
            Column("Document_No"; "Document No.")
            {

            }
            Column("Source_Code"; "Source Code")
            {

            }
            Column("Job_No"; "Job No.")
            {

            }
            Column("Business_Unit_Code"; "Business Unit Code")
            {

            }
            Column("Reason_Code"; "Reason Code")
            {

            }
            Column("Gen_Posting_Type"; "Gen. Posting Type")
            {

            }
            Column("Gen_Bus_Posting_Group"; "Gen. Bus. Posting Group")
            {

            }
            Column("Gen_Prod_Posting_Group"; "Gen. Prod. Posting Group")
            {

            }
            Column("Tax_Area_Code"; "Tax Area Code")
            {

            }
            Column("Tax_Liable"; "Tax Liable")
            {

            }
            Column("Tax_Group_Code"; "Tax Group Code")
            {

            }
            Column("Use_Tax"; "Use Tax")
            {

            }
            Column("VAT_Bus_Posting_Group"; "VAT Bus. Posting Group")
            {

            }
            Column("VAT_Prod_Posting_Group"; "VAT Prod. Posting Group")
            {

            }
            Column("IC_Partner_Code"; "IC Partner Code")
            {

            }
            Column("Amount"; "Amount")
            {

            }
            Column("Debit_Amount"; "Debit Amount")
            {

            }
            Column("Credit_Amount"; "Credit Amount")
            {

            }
            Column("VAT_Amount"; "VAT Amount")
            {

            }
            Column("Additional_Currency_Amount"; "Additional-Currency Amount")
            {

            }
            Column("Add_Currency_Debit_Amount"; "Add.-Currency Debit Amount")
            {

            }
            Column("Add_Currency_Credit_Amount"; "Add.-Currency Credit Amount")
            {

            }
            Column("Dimension_Set_ID"; "Dimension Set ID")
            {

            }
            DataItem("G_L_Account"; "G/L Account")
            {

                DataItemLink = "No." = "G_L_Entry"."G/L Account No.";
                Column(G_L_Account_Name; "Name")
                {

                }
            }
            //Directly mentioned in base
            // column(G_L_Account_Name; "G/L Account Name")
            //             {
            //             }
        }
    }


    /*begin
    end.
  */
}





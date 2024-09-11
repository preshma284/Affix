page 7207223 "QB BI G/L Entries"
{
    SourceTable = 17;
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
                field("Transaction No."; rec."Transaction No.")
                {

                }
                field("G/L Account No."; rec."G/L Account No.")
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
                field("Document Date"; rec."Document Date")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Business Unit Code"; rec."Business Unit Code")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Gen. Posting Type"; rec."Gen. Posting Type")
                {

                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {

                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {

                }
                field("Tax Area Code"; rec."Tax Area Code")
                {

                }
                field("Tax Liable"; rec."Tax Liable")
                {

                }
                field("Tax Group Code"; rec."Tax Group Code")
                {

                }
                field("Use Tax"; rec."Use Tax")
                {

                }
                field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                {

                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {

                }
                field("IC Partner Code"; rec."IC Partner Code")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Debit Amount"; rec."Debit Amount")
                {

                }
                field("Credit Amount"; rec."Credit Amount")
                {

                }
                field("VAT Amount"; rec."VAT Amount")
                {

                }
                field("Additional-Currency Amount"; rec."Additional-Currency Amount")
                {

                }
                field("Add.-Currency Debit Amount"; rec."Add.-Currency Debit Amount")
                {

                }
                field("Add.-Currency Credit Amount"; rec."Add.-Currency Credit Amount")
                {

                }
                field("Dimension Set ID"; rec."Dimension Set ID")
                {

                }
                field("G_L_Account_Name"; GLAccount.Name)
                {

                }

            }

        }
    }



    trigger OnAfterGetRecord()
    BEGIN
        IF rec."G/L Account No." <> GLAccount."No." THEN
            IF NOT GLAccount.GET(rec."G/L Account No.") THEN CLEAR(GLAccount);
    END;



    var
        GLAccount: Record 15;

    /*begin
    end.
  
*/
}








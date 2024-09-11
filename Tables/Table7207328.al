table 7207328 "QBU Detailed Job Ledger Entry"
{


    CaptionML = ENU = 'Detailed Job Ledger Entry', ESP = 'Mov. Detallado de Proyecto';
    LookupPageID = "QB Detailed Job Entry";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'N� mov.';


        }
        field(2; "Job Ledger Entry No."; Integer)
        {
            TableRelation = "Job Ledger Entry";
            CaptionML = ENU = 'Job Ledger Entry No.', ESP = 'N� mov. Proyecto';


        }
        field(3; "Entry Type"; Option)
        {
            OptionMembers = "Initial Entry","Application","Unrealized Loss","Unrealized Gain","Realized Loss","Realized Gain";
            CaptionML = ENU = 'Entry Type', ESP = 'Tipo movimiento';
            OptionCaptionML = ENU = ',Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain', ESP = ',Mov. inicial,Liquidaci�n,Dif. neg. no realizadas,Dif. pos. no realizadas,Dif. neg. realizadas,Dif. pos. realizadas';



        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(6; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(7; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(8; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe (DL)';
            AutoFormatType = 1;


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(10; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(11; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            //TestTableRelation=false;
            DataClassification = EndUserIdentifiableInformation;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               UserMgt@1000 :
                UserMgt: Codeunit "User Management 1";
            BEGIN
                UserMgt.LookupUserID("User ID");
            END;


        }
        field(12; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(15; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(36; "Applied Job Ledger Entry No."; Integer)
        {
            CaptionML = ENU = 'Applied Job Ledger Entry No.', ESP = 'N� mov. Proyecto liquidado';
            ;


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    /*begin
    end.
  */
}








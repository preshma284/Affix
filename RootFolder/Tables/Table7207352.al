table 7207352 "Element Posting Entries"
{


    CaptionML = ENU = 'Element Posting Entries', ESP = 'Registro movs. elemento';
    LookupPageID = "Element Entry Registry";
    DrillDownPageID = "Element Entry Registry";

    fields
    {
        field(1; "Transaction No."; Integer)
        {
            CaptionML = ENU = 'Transaction No.', ESP = 'No. asiento';


        }
        field(2; "From Entry No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            //TestTableRelation=false;
            CaptionML = ENU = 'From Entry No.', ESP = 'Desde n� mov.';


        }
        field(3; "To Entry No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            //TestTableRelation=false;
            CaptionML = ENU = 'To Entry No.', ESP = 'Hasta n� mov.';


        }
        field(4; "Creation Date"; Date)
        {
            CaptionML = ENU = 'Creation Date', ESP = 'Fecha creaci�n';


        }
        field(5; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'Cod. origen';


        }
        field(6; "User ID"; Code[20])
        {
            TableRelation = "User";


            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            BEGIN
                UserManagement.LookupUserID("User ID");
            END;


        }
        field(7; "Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name', ESP = 'Nombre secci�n diario';


        }
        field(8; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';
            ClosingDates = true;


        }
        field(9; "Period Trans. No."; Integer)
        {
            CaptionML = ENU = 'Period Trans. No.', ESP = 'No. aqsiento periodo';
            BlankZero = true;


        }
    }
    keys
    {
        key(key1; "Transaction No.")
        {
            Clustered = true;
        }
        key(key2; "Creation Date")
        {
            ;
        }
        key(key3; "Source Code", "Journal Batch Name", "Creation Date")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       UserManagement@7001100 :
        UserManagement: Codeunit "User Management 1";

    /*begin
    end.
  */
}








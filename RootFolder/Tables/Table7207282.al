table 7207282 "Purchase Journal Batch"
{

    DataCaptionFields = "Section Code", "Section Description";
    CaptionML = ENU = 'Journal Batch Purchase', ESP = 'Secci�n diario neces. compra';
    LookupPageID = "Purchase Journal Batches";

    fields
    {
        field(1; "Section Code"; Code[20])
        {
            CaptionML = ENU = 'Name', ESP = 'Secci�n';
            NotBlank = true;


        }
        field(2; "Section Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            ;


        }
    }
    keys
    {
        key(key1; "Section Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       PurchaseJournalLine@7001101 :
        PurchaseJournalLine: Record 7207281;
        //       Text000@7001102 :
        Text000: TextConst ENU = 'Only the %1 field can be filled in on recurring journals.', ESP = 'S�lo se debe completar el campo %1 en los diarios peri�dicos.';
        //       Text001@7001103 :
        Text001: TextConst ENU = 'must not be %1', ESP = 'No puede ser %1.';



    trigger OnDelete();
    begin
        PurchaseJournalLine.SETRANGE("Journal Batch Name", "Section Code");
        PurchaseJournalLine.DELETEALL(TRUE);
    end;

    trigger OnRename();
    begin
        PurchaseJournalLine.SETRANGE("Journal Batch Name", xRec."Section Code");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if PurchaseJournalLine.FINDSET(TRUE, TRUE) then
        if PurchaseJournalLine.FINDSET(TRUE) then
            repeat
                PurchaseJournalLine.RENAME(PurchaseJournalLine."Job No.", "Section Code", PurchaseJournalLine."Line No.");
            until PurchaseJournalLine.NEXT = 0;
    end;



    /*begin
        end.
      */
}








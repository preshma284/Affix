table 7207351 "Element Journal Section"
{

    DataCaptionFields = "Name", "Description";
    CaptionML = ENU = 'Element Journal Section', ESP = 'Secci�n diario elemento';
    LookupPageID = "Element Journal Sections";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Journal Template Element";
            CaptionML = ENU = 'Journal Template Name', ESP = 'Nombre libro diario';
            NotBlank = true;


        }
        field(2; "Name"; Code[10])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            NotBlank = true;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";


            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';

            trigger OnValidate();
            BEGIN
                IF "Reason Code" <> xRec."Reason Code" THEN BEGIN
                    ModifyLines(FIELDNO("Reason Code"));
                    MODIFY;
                END;
            END;


        }
        field(5; "Series No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Series No.', ESP = 'No. series';

            trigger OnValidate();
            BEGIN
                IF "Series No." <> '' THEN BEGIN
                    GenJournalTemplate.GET("Journal Template Name");
                    IF GenJournalTemplate.Recurring THEN
                        ERROR(
                          Text000,
                          FIELDCAPTION("Posting No. Series"));
                    IF "Series No." = "Posting No. Series" THEN
                        VALIDATE("Posting No. Series", '');
                END;
            END;


        }
        field(6; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'No. series registro';
            ;

            trigger OnValidate();
            BEGIN
                IF ("Posting No. Series" = "Series No.") AND ("Posting No. Series" <> '') THEN
                    FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
                ModifyLines(FIELDNO("Posting No. Series"));
                MODIFY;
            END;


        }
    }
    keys
    {
        key(key1; "Journal Template Name", "Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       JournalTemplateElement@7001100 :
        JournalTemplateElement: Record 7207349;
        //       ElementJournalLine@7001101 :
        ElementJournalLine: Record 7207350;
        //       GenJournalTemplate@7001102 :
        GenJournalTemplate: Record 80;
        //       Text000@7001104 :
        Text000: TextConst ENU = 'Only the %1 field can be filled in on recurring journals.', ESP = 'S�lo se debe completar el campo %1 en los diarios peri�dicos.';
        //       Text001@7001103 :
        Text001: TextConst ENU = 'Must not be %1', ESP = 'No puede ser %1.';



    trigger OnInsert();
    begin
        LOCKTABLE;
        JournalTemplateElement.GET("Journal Template Name");
    end;

    trigger OnDelete();
    begin
        ElementJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ElementJournalLine.SETRANGE("Journal Batch Name", Name);
        ElementJournalLine.DELETEALL(TRUE);
    end;

    trigger OnRename();
    begin
        ElementJournalLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        ElementJournalLine.SETRANGE("Journal Batch Name", xRec.Name);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ElementJournalLine.FINDSET(TRUE,TRUE) then
        if ElementJournalLine.FINDSET(TRUE) then
            repeat
                ElementJournalLine.RENAME("Journal Template Name", Name, ElementJournalLine."Line No.");
            until ElementJournalLine.NEXT = 0;
    end;



    // procedure ModifyLines (i@1000 :
    procedure ModifyLines(i: Integer)
    begin
        ElementJournalLine.LOCKTABLE;
        ElementJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ElementJournalLine.SETRANGE("Journal Batch Name", Name);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ElementJournalLine.FINDSET(TRUE, FALSE) then
        if ElementJournalLine.FINDSET(TRUE) then
            repeat
                CASE i OF
                    FIELDNO("Reason Code"):
                        ElementJournalLine.VALIDATE("Reason code", "Reason Code");
                    FIELDNO("Posting No. Series"):
                        ElementJournalLine.VALIDATE("Posting No. Series", "Posting No. Series");
                end;
                ElementJournalLine.MODIFY(TRUE);
            until ElementJournalLine.NEXT = 0;
    end;

    procedure SetupNewBatch()
    begin
        JournalTemplateElement.GET("Journal Template Name");
        "Series No." := JournalTemplateElement."Series No.";
        "Posting No. Series" := JournalTemplateElement."Posting No. series";
        "Reason Code" := JournalTemplateElement."Reason Code";
    end;

    /*begin
    end.
  */
}








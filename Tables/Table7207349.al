table 7207349 "QBU Journal Template Element"
{


    CaptionML = ENU = 'Journal Template Element', ESP = 'Libro del diario elemento';
    LookupPageID = "Journal Template (Element)";
    DrillDownPageID = "Journal Template (Element)";

    fields
    {
        field(1; "Name"; Code[10])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            NotBlank = true;


        }
        field(2; "Description"; Text[80])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(3; "Test Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));
            CaptionML = ENU = 'Test Report ID', ESP = 'Id. informe prueba';


        }
        field(4; "Page ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Page"));


            CaptionML = ENU = 'Page ID', ESP = 'Id. p�gina';

            trigger OnValidate();
            BEGIN
                IF "Page ID" = 0 THEN BEGIN
                    "Source Code" := SourceCodeSetup."Rent Journal";
                    "Page ID" := PAGE::"Element Journal Line";

                    IF Recurring THEN
                        "Page ID" := PAGE::"Element Journal Line";
                END;
            END;


        }
        field(5; "Posting Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));
            CaptionML = ENU = 'Posting Report ID', ESP = 'No informe para registro';


        }
        field(6; "Force Posting Report"; Boolean)
        {
            CaptionML = ENU = 'Force Posting Report', ESP = 'Forzar informe para registro';


        }
        field(7; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";


            CaptionML = ENU = 'Source Code', ESP = 'Cod. origen';

            trigger OnValidate();
            BEGIN
                ElementJournalLine.SETRANGE("Journal Template Name", Name);
                ElementJournalLine.MODIFYALL("Source Code", "Source Code");
                MODIFY;
            END;


        }
        field(8; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(9; "Recurring"; Boolean)
        {


            CaptionML = ENU = 'Recurring', ESP = 'Peri�dico';

            trigger OnValidate();
            BEGIN
                IF Recurring THEN BEGIN
                    "Page ID" := PAGE::"Element Journal Line";
                    TESTFIELD("Series No.", '');
                END;
            END;


        }
        field(10; "Test Report Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST("Report"),
                                                                                         "Object ID" = FIELD("Test Report ID")));
            CaptionML = ENU = 'Test Report Name', ESP = 'Nombre informe test';
            Editable = false;


        }
        field(11; "Page Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST("Page"),
                                                                                         "Object ID" = FIELD("Page ID")));
            CaptionML = ENU = 'Page Name', ESP = 'Nombre p�gina';
            Editable = false;


        }
        field(12; "Posting Report Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST("Report"),
                                                                                         "Object ID" = FIELD("Test Report ID")));
            CaptionML = ENU = 'Posting Report Name', ESP = 'Nombre informe para registro';
            Editable = false;


        }
        field(13; "Series No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Series No.', ESP = 'No. series';

            trigger OnValidate();
            BEGIN
                IF "Series No." <> '' THEN BEGIN
                    IF Recurring THEN
                        ERROR(
                          Text000,
                          FIELDCAPTION("Posting No. series"));
                    IF "Series No." = "Posting No. series" THEN
                        "Posting No. series" := '';
                END;
            END;


        }
        field(14; "Posting No. series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. series', ESP = 'No. series registro';

            trigger OnValidate();
            BEGIN
                IF ("Posting No. series" = "Series No.") AND ("Posting No. series" <> '') THEN
                    FIELDERROR("Posting No. series", STRSUBSTNO(Text001, "Posting No. series"));
            END;


        }
        field(15; "Force Doc. Balance"; Boolean)
        {
            CaptionML = ENU = 'Force Doc. Balance',
                                                              ESP = 'Forzar saldo por n§ documento';
        }
    }
    keys
    {
        key(key1; "Name")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       ElementJournalLine@7001100 :
        ElementJournalLine: Record 7207350;
        //       ElementJournalSection@7001101 :
        ElementJournalSection: Record 7207351;
        //       SourceCodeSetup@7001102 :
        SourceCodeSetup: Record 242;
        //       Text000@7001104 :
        Text000: TextConst ENU = 'Only the %1 field can be filled in on recurring journals.', ESP = 'S�lo se debe completar el campo %1 en los diarios peri�dicos.';
        //       Text001@7001103 :
        Text001: TextConst ENU = 'must not be %1', ESP = 'No puede ser %1.';



    trigger OnInsert();
    begin
        VALIDATE("Page ID");
    end;

    trigger OnDelete();
    begin
        ElementJournalLine.SETRANGE("Journal Template Name", Name);
        ElementJournalLine.DELETEALL(TRUE);
        ElementJournalSection.SETRANGE("Journal Template Name", Name);
        ElementJournalSection.DELETEALL;
    end;



    /*begin
        end.
      */
}








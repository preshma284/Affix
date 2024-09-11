table 51288 "Outlook Synch. Setup Detail 1"
{


    CaptionML = ENU = 'Outlook Synch. Setup Detail', ESP = 'Detalles config. sinc. Outlook';
    LookupPageID = "Outlook Synch. Setup Details";
    DrillDownPageID = "Outlook Synch. Setup Details";

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "Outlook Synch. User Setup 1"."User ID";
            DataClassification = EndUserIdentifiableInformation;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';
            NotBlank = true;
            Editable = false;


        }
        field(2; "Synch. Entity Code"; Code[10])
        {
            TableRelation = "Outlook Synch. Entity Element1"."Synch. Entity Code";
            CaptionML = ENU = 'Synch. Entity Code', ESP = 'C�digo entidad sinc.';
            Editable = false;


        }
        field(3; "Element No."; Integer)
        {
            TableRelation = "Outlook Synch. Entity Element1"."Element No.";


            CaptionML = ENU = 'Element No.', ESP = 'N� elemento';
            Editable = false;

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Outlook Collection");
            END;


        }
        field(4; "Outlook Collection"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Outlook Synch. Entity Element1"."Outlook Collection" WHERE("Synch. Entity Code" = FIELD("Synch. Entity Code"),
                                                                                                                                  "Element No." = FIELD("Element No.")));


            CaptionML = ENU = 'Outlook Collection', ESP = 'Colecci�n Outlook';
            Editable = false;

            trigger OnLookup();
            VAR
                //                                                               ElementNo@1000 :
                ElementNo: Integer;
            BEGIN
                ElementNo := OSynchSetupMgt.ShowOEntityCollections("User ID", "Synch. Entity Code");

                IF (ElementNo <> 0) AND ("Element No." <> ElementNo) THEN
                    VALIDATE("Element No.", ElementNo);
            END;


        }
        field(5; "Table No."; Integer)
        {
            CaptionML = ENU = 'Table No.', ESP = 'N� tabla';
            ;


        }
    }
    keys
    {
        key(key1; "User ID", "Synch. Entity Code", "Element No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       OSynchSetupMgt@1000 :
        OSynchSetupMgt: Codeunit 50849;
        //       Text001@1001 :
        Text001: TextConst ENU = 'This collection cannot be synchronized because the relation between this collection and the dependent entity %1 was not defined.', ESP = 'Esta colecci�n no se puede sincronizar porque la relaci�n entre esta colecci�n y el objeto dependiente %1 no estaba definida.';




    trigger OnInsert();
    begin
        CheckOSynchEntity;
        SetTableNo;
    end;

    trigger OnModify();
    begin
        CheckOSynchEntity;
        SetTableNo;
    end;



    procedure CheckOSynchEntity()
    var
        //       OSynchEntityElement@1000 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
        //       OSynchDependency@1001 :
        OSynchDependency: Record "Outlook Synch. Dependency 1";
    begin
        OSynchEntityElement.GET("Synch. Entity Code", "Element No.");
        OSynchEntityElement.TESTFIELD("Table No.");
        OSynchEntityElement.TESTFIELD("Outlook Collection");
        OSynchEntityElement.TESTFIELD("Table Relation");

        OSynchEntityElement.CALCFIELDS("No. of Dependencies");
        if OSynchEntityElement."No. of Dependencies" = 0 then
            exit;

        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code", OSynchEntityElement."Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.", OSynchEntityElement."Element No.");
        if OSynchDependency.FIND('-') then
            repeat
                if OSynchDependency."Table Relation" = '' then
                    ERROR(Text001, OSynchDependency."Depend. Synch. Entity Code");
            until OSynchDependency.NEXT = 0;
    end;


    procedure SetTableNo()
    var
        //       OSynchEntityElement@1000 :
        OSynchEntityElement: Record "Outlook Synch. Entity Element1";
    begin
        OSynchEntityElement.GET("Synch. Entity Code", "Element No.");
        "Table No." := OSynchEntityElement."Table No.";
    end;

    /*begin
    end.
  */
}




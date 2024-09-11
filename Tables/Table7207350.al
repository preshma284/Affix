table 7207350 "QBU Element Journal Line"
{


    CaptionML = ENU = 'Element Journal Line', ESP = 'Lin. diario elemento';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Journal Template Element";
            CaptionML = ENU = 'Journal Template Name', ESP = 'Nombre libro diario';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. L�nea';


        }
        field(3; "Element No."; Code[20])
        {
            TableRelation = "Rental Elements";


            CaptionML = ENU = 'Element No.', ESP = 'No. elemento';

            trigger OnValidate();
            BEGIN
                IF "Entry Type" = "Entry Type"::Delivery THEN
                    "Applied Entry No." := 0;

                IF "Entry Type" = "Entry Type"::Return THEN BEGIN
                    IF "Applied Entry No." <> 0 THEN
                        ValidatingEntry("Applied Entry No.");
                END;


                RentalElements.GET("Element No.");
                Description := RentalElements.Description;
            END;


        }
        field(4; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';
            ClosingDates = true;

            trigger OnValidate();
            BEGIN
                VALIDATE("Document Date", "Posting Date");
            END;


        }
        field(5; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(6; "Entry Type"; Option)
        {
            OptionMembers = "Delivery","Return";
            CaptionML = ENU = 'Entry Type', ESP = 'Tipo movimiento';
            OptionCaptionML = ENU = 'Delivery,Return', ESP = 'Entrega,Devoluci�n';



        }
        field(7; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure', ESP = 'Unidad de medida';


        }
        field(8; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            CaptionML = ENU = 'Location Code', ESP = 'Cod. almac�n';


        }
        field(9; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(10; "Variante Code"; Code[10])
        {
            TableRelation = "Rental Variant" WHERE("Rental Variant" = CONST(true));
            CaptionML = ENU = 'Variante Code', ESP = 'Cod. variante';


        }
        field(11; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', ESP = 'Precio unitario';
            AutoFormatType = 2;


        }
        field(12; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'Cod. origen';
            Editable = false;


        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 1 Code");
            END;


        }
        field(15; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            BEGIN
                VALIDATE("Unit Price");
            END;


        }
        field(16; "Business Unit Code"; Code[20])
        {
            TableRelation = "Business Unit";
            CaptionML = ENU = 'Business Unit Code', ESP = 'Cod. empresa';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(17; "Recurring Method"; Option)
        {
            OptionMembers = " ","F  Fixed","V  Variable","B  Balance","RF Reversing Fixed","RV Reversing Variable","RB Reversing Balance";
            CaptionML = ENU = 'Recurring Method', ESP = 'Periodicidad';
            OptionCaptionML = ENU = '" ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance"', ESP = '" ,F  Fijo,V  Variable,S Saldo,CF Contraasiento fijo,CV Contraasiento variable,CS Contraasiento saldo"';

            BlankZero = true;


        }
        field(18; "Recurring Frequency"; DateFormula)
        {
            CaptionML = ENU = 'Recurring Frequency', ESP = 'Frecuencia repetici�n';


        }
        field(19; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Element Journal Section"."Name" WHERE("Journal Template Name" = FIELD("Journal Template Name"));
            CaptionML = ENU = 'Journal Batch Name', ESP = 'Nombre secci�n diario';


        }
        field(20; "Reason code"; Code[10])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason code', ESP = 'Cod. auditor�a';


        }
        field(21; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha documento';
            ClosingDates = true;


        }
        field(22; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'No. documento externo';


        }
        field(23; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Posting No. Series', ESP = 'No. serie registro';


        }
        field(24; "Dimensions Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimensions Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(25; "Transaction No."; Integer)
        {
            CaptionML = ENU = 'Transaction No.', ESP = 'No.';
            BlankZero = true;


        }
        field(26; "Contract No."; Code[20])
        {
            TableRelation = "Element Contract Header" WHERE("Customer/Vendor No." = FIELD("Customer No."),
                                                                                                  "Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Contract No.', ESP = 'No. contrato';

            trigger OnValidate();
            BEGIN
                GetContract("Contract No.");
                "Customer No." := ElementContractHeader."Customer/Vendor No.";
                "Job No." := ElementContractHeader."Job No.";
            END;


        }
        field(27; "Customer No."; Code[20])
        {
            TableRelation = "Customer";


            CaptionML = ENU = 'Customer No.', ESP = 'No. cliente';

            trigger OnValidate();
            BEGIN
                "Job No." := '';
                "Contract No." := '';
            END;


        }
        field(28; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Bill-to Customer No." = FIELD("Customer No."));
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(29; "Rent Effective Date"; Date)
        {
            CaptionML = ENU = 'Rent Effective Date', ESP = 'Fecha efectiva alquiler';


        }
        field(30; "Applied Entry No."; Integer)
        {
            TableRelation = "Rental Elements Entries"."Entry No." WHERE("Contract No." = FIELD("Contract No."),
                                                                                                              "Entry Type" = CONST("Delivery"));


            CaptionML = ENU = 'Applied Entry No.', ESP = 'No. mov. liquidado';

            trigger OnValidate();
            BEGIN
                IF "Entry Type" = "Entry Type"::Return THEN
                    ValidatingEntry("Applied Entry No.")
                ELSE
                    "Applied Entry No." := 0;
            END;


        }
        field(31; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'Cod. unidad de obra';


        }
        field(32; "Entry Pending First Applied"; Boolean)
        {
            CaptionML = ENU = 'Entry Pending First Applied', ESP = 'Mov. pdte primera liquidaci�n';


        }
        field(33; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';
            NotBlank = true;


        }
    }
    keys
    {
        key(key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
        key(key2; "Journal Template Name", "Journal Batch Name", "Posting Date", "Transaction No.")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       RentalElements@7001100 :
        RentalElements: Record 7207344;
        //       DimensionManagement@7001101 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       ElementContractHeader@7001102 :
        ElementContractHeader: Record 7207353;
        //       JournalTemplateElement@7001103 :
        JournalTemplateElement: Record 7207349;
        //       ElementJournalSection@7001104 :
        ElementJournalSection: Record 7207351;
        //       ElementJournalLine@7001105 :
        ElementJournalLine: Record 7207350;
        //       NoSeriesManagement@7001106 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";

    //     procedure ValidatingEntry (ValidatingEntry@1100251000 :
    procedure ValidatingEntry(ValidatingEntry: Integer)
    var
        //       RentalElementsEntries@1100251001 :
        RentalElementsEntries: Record 7207345;
    begin
        RentalElementsEntries.GET(ValidatingEntry);
        "Element No." := RentalElementsEntries."Element No.";
        RentalElements.GET("Element No.");
        Description := RentalElements.Description;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimensions Set ID");
    end;

    //     LOCAL procedure GetContract (MasterNo@1000 :
    LOCAL procedure GetContract(MasterNo: Code[20])
    begin
        ElementContractHeader.GET(MasterNo);
    end;

    procedure EmptyLine(): Boolean;
    begin
        //Esta funci�n nos dice si una l�nea de diario esta en blanco.
        exit((Quantity = 0));
    end;

    //     procedure SetUpNewLine (PElementJournalLine@1000 : Record 7207350;Balance@1100251001 : Decimal;BottomLine@1100251000 :
    procedure SetUpNewLine(PElementJournalLine: Record 7207350; Balance: Decimal; BottomLine: Boolean)
    begin
        JournalTemplateElement.GET("Journal Template Name");
        ElementJournalSection.GET("Journal Template Name", "Journal Batch Name");
        ElementJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ElementJournalLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        if ElementJournalLine.FINDFIRST then begin
            "Posting Date" := PElementJournalLine."Posting Date";
            "Document Date" := PElementJournalLine."Posting Date";
            "Document No." := PElementJournalLine."Document No.";
            "Transaction No." := PElementJournalLine."Transaction No.";
        end else begin
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;
            if ElementJournalSection."Series No." <> '' then begin
                CLEAR(NoSeriesManagement);
                "Document No." := NoSeriesManagement.TryGetNextNo(ElementJournalSection."Series No.", "Posting Date");
            end;
        end;
        "Source Code" := JournalTemplateElement."Source Code";
        "Reason code" := ElementJournalSection."Reason Code";
        "Posting No. Series" := ElementJournalSection."Posting No. Series";
        "Recurring Method" := PElementJournalLine."Recurring Method";
        Description := '';
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimensions Set ID");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimensionManagement.GetShortcutDimensions("Dimensions Set ID", ShortcutDimCode);
    end;

    procedure ShowDimensions()
    begin
        "Dimensions Set ID" :=
          DimensionManagement1.EditDimensionSet2(
            "Dimensions Set ID", STRSUBSTNO('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    /*begin
    end.
  */
}








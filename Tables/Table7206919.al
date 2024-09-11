table 7206919 "QBU Debit Relations Header"
{


    CaptionML = ENU = 'Debit Relations Header', ESP = 'Cabecera Relaci�n Cobros';

    fields
    {
        field(1; "Relacion No."; Code[20])
        {
            CaptionML = ENU = 'Relation No.', ESP = 'N� Relaci�n';


        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(9; "Type"; Option)
        {
            OptionMembers = "Linear","Certification";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo';
            OptionCaptionML = ENU = 'Linear, By Certification', ESP = 'Lineal,Por Certificaci�n';



        }
        field(10; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';

            trigger OnValidate();
            BEGIN
                Jobs.GET("Job No.");
                VALIDATE("Job Desription", Jobs.Description);
                VALIDATE("Customer No.", Jobs."Bill-to Customer No.");
                CreateDim();
            END;


        }
        field(11; "Job Desription"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripción del proyecto';
            Editable = false;


        }
        field(12; "Customer No."; Code[20])
        {
            TableRelation = "Customer";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cliente';

            trigger OnValidate();
            BEGIN
                Customer.GET("Customer No.");
                CALCFIELDS("Customer Name");
                CreateDim();
            END;

            trigger OnLookup();
            BEGIN
                IF QBTableSubscriber.ValidateCustomerFromJob("Job No.", "Customer No.") THEN
                    VALIDATE("Customer No.");
            END;


        }
        field(13; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."Name" WHERE("No." = FIELD("Customer No.")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(20; "Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha';


        }
        field(21; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Debit Relations Lines"."Amount" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                            "Type" = CONST("Amount")));
            CaptionML = ESP = 'Importe';
            Editable = false;


        }
        field(31; "Amount Invoiced"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Debit Relations Lines"."Amount" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                            "Type" = CONST("Invoice")));
            CaptionML = ESP = 'Importe Facturado';
            Editable = false;


        }
        field(32; "Amount Received"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Debit Relations Lines"."Amount" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                            "Type" = CONST("Payment")));
            CaptionML = ESP = 'Importe Recibido';
            Editable = false;


        }
        field(41; "Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cerrada';


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnValidate();
            BEGIN
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            END;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(481; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1),
                                                                                               "Blocked" = CONST(false));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(482; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2),
                                                                                               "Blocked" = CONST(false));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
    }
    keys
    {
        key(key1; "Relacion No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBRelationshipSetup@7001100 :
        QBRelationshipSetup: Record 7207335;
        //       Jobs@1100286002 :
        Jobs: Record 167;
        //       Customer@1100286001 :
        Customer: Record 18;
        //       Lineas@7001101 :
        Lineas: Record 7206920;
        //       Txt001@7001102 :
        Txt001: TextConst ESP = 'No puede cambiar el tipo, ya hay pagar�s generados';
        //       DimMgt@1100286000 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       NoSeriesMgt@7001103 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       QBTableSubscriber@1100286003 :
        QBTableSubscriber: Codeunit 7207347;




    trigger OnInsert();
    begin
        if "Relacion No." = '' then begin
            QBRelationshipSetup.GET;
            QBRelationshipSetup.TESTFIELD("RC Serie Relaciones Cobros");
            NoSeriesMgt.InitSeries(QBRelationshipSetup."RC Serie Relaciones Cobros", xRec."No. Series", 0D, "Relacion No.", "No. Series");
        end;

        if (Date = 0D) then
            Date := TODAY;
    end;

    trigger OnDelete();
    var
        //                txtQB000@1100286000 :
        txtQB000: TextConst ESP = 'Ha cerrado la relaci�n, no se puede eliminar';
    begin
        if Closed then
            ERROR(txtQB000);

        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", "Relacion No.");
        Lineas.DELETEALL(FALSE);
    end;



    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1', "Relacion No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure CreateDim()
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        //       OldDimSetID@1008 :
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := DATABASE::Customer;
        No[1] := "Customer No.";
        TableID[2] := DATABASE::Job;
        No[2] := "Job No.";

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;


    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        //       OldDimSetID@1005 :
        OldDimSetID: Integer;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "Relacion No." <> '' then
            MODIFY;
    end;

    /*begin
    end.
  */
}








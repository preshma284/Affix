table 7207324 "Hist. Expense Notes Lines"
{


    CaptionML = ENU = 'Hist.Expense Notes Lines', ESP = 'Hist. Lineas notas de gasto';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No', ESP = 'N� Documento';


        }
        field(2; "Line No"; Integer)
        {
            CaptionML = ENU = 'Line No', ESP = 'N� Linea';


        }
        field(3; "No. Job Unit"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'No. Job Unit', ESP = 'N� Unidad de Obra';


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(8; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No', ESP = 'N� proyecto';


        }
        field(10; "Expense Date"; Date)
        {
            CaptionML = ENU = 'Expense Date', ESP = 'Fecha de Gasto';


        }
        field(11; "Expense Concept"; Code[20])
        {
            TableRelation = "Expense Concept";
            CaptionML = ENU = 'Expense Concept', ESP = 'Concepto de Gasto';


        }
        field(12; "Expense Account"; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENU = 'Expense Account', ESP = 'Cuenta de Gasto';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(13; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';


        }
        field(14; "Price Cost"; Decimal)
        {
            CaptionML = ENU = 'Price Cost', ESP = 'Precio Coste';


        }
        field(15; "Total Amount"; Decimal)
        {
            CaptionML = ENU = 'Total Amount', ESP = 'Importe Total';


        }
        field(16; "Total Amount (DL)"; Decimal)
        {
            CaptionML = ENU = 'Total Amount', ESP = 'Importe Total (DL)';
            Editable = false;


        }
        field(17; "Justifying"; Boolean)
        {
            CaptionML = ENU = 'Justifying', ESP = 'Justificante';


        }
        field(18; "Payment Charge Enterprise"; Boolean)
        {
            CaptionML = ENU = 'Payment Charge Enterprise', ESP = 'Pago a cargo de Empresa';


        }
        field(19; "Bal. Account Payment"; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("Account")) "G/L Account" ELSE IF ("Bal. Account Type" = CONST("Bank")) "Bank Account";
            CaptionML = ENU = 'Bal. Account Payment', ESP = 'Contrapartida pago';


        }
        field(20; "Withholding Amount (DL)"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount', ESP = 'Importe Retencion';
            Editable = false;


        }
        field(21; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Vendor No', ESP = 'N� Proveedor';


        }
        field(22; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre Proveedor';
            Editable = false;


        }
        field(23; "No Document Vendor"; Code[20])
        {
            CaptionML = ENU = 'No. Document Vendor', ESP = 'N� Documento Proveedor';


        }
        field(24; "VAT Product Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";
            CaptionML = ENU = 'VAT Product Posting Group', ESP = 'Grupo reg. IVA product';


        }
        field(25; "Percentage VAT"; Decimal)
        {
            CaptionML = ENU = 'Percentage VAT', ESP = 'Porcentaje IVA';
            Editable = false;


        }
        field(26; "VAT Amount"; Decimal)
        {
            CaptionML = ENU = 'VAT Amount', ESP = 'Importe de IVA';
            Editable = false;


        }
        field(27; "VAT Amount (DL)"; Decimal)
        {
            CaptionML = ENU = 'VAT Amount (DL)', ESP = 'Importe IVA (DL)';
            Editable = false;


        }
        field(28; "Billable"; Boolean)
        {
            CaptionML = ENU = 'Billable', ESP = 'Facturable';


        }
        field(29; "Sales Amount"; Decimal)
        {
            CaptionML = ENU = 'Sales Amount', ESP = 'Importe Ventas';


        }
        field(30; "PIT Percentage"; Decimal)
        {
            CaptionML = ENU = 'PIT Percentage', ESP = 'Porcentaje IRPF';


        }
        field(31; "Bal. Account Type"; Option)
        {
            OptionMembers = "Account","Bank";
            CaptionML = ENU = 'Bal.Account Type', ESP = 'Tipo Contrapartida';
            OptionCaptionML = ENU = 'Account,Bank', ESP = 'Cuenta,Banco';



        }
        field(32; "VAT Business Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            CaptionML = ENU = 'VAT Business Posting Group', ESP = 'Grupo Registro IVA neg.';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(33; "Withholding Amount"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount', ESP = 'Importe retencion';
            Editable = false;


        }
        field(34; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'N� Tarea';


        }
        field(35; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. Grupo Dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(37; "Analytic Concept"; Code[20])
        {
            CaptionML = ENU = 'Analytic Concept', ESP = 'Concepto analitico';
            ;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";

    procedure GetCurrencyCode(): Code[10];
    var
        //       PurchInvHeader@1000 :
        PurchInvHeader: Record 122;
    begin
        if ("Document No." = PurchInvHeader."No.") then
            exit(PurchInvHeader."Currency Code")
        else
            if PurchInvHeader.GET("Document No.") then
                exit(PurchInvHeader."Currency Code")
            else
                exit('');
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Hist. Expense Notes Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No"));
    end;

    /*begin
    end.
  */
}








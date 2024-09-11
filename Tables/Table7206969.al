table 7206969 "QBU Posted Service Order Lines"
{


    CaptionML = ENU = 'Posted Service Order Lines', ESP = 'L�neas Pedido Servicio Registrado';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(3; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Customer Certification Unit" = CONST(true));
            CaptionML = ENU = 'Piecework No.', ESP = 'N� unidad de obra';


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(11; "Sale Price"; Decimal)
        {
            CaptionML = ENU = 'Sale Price', ESP = 'Precio venta';


        }
        field(13; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(17; "Contract Price"; Decimal)
        {
            CaptionML = ENU = 'Contract Price', ESP = 'Precio Contrato';
            Editable = false;


        }
        field(18; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(29; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Medicion periodo', ESP = 'Cantidad';


        }
        field(30; "Quantity Invoiced"; Decimal)
        {
            CaptionML = ENU = 'Amount Measure Not Certified', ESP = 'Cantidad facturada';


        }
        field(32; "Service Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Fecha certificacion', ESP = 'Fecha del Servicio';


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';


        }
        field(50000; "Expenses/Investment"; Option)
        {
            OptionMembers = "Expenses","Investment";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expenses/Investment', ESP = 'Gastos/Inversi�n';
            OptionCaptionML = ENU = 'Expenses,Investment', ESP = 'Gastos,Inversi�n';

            Description = 'Q5609';


        }
        field(50002; "Cost Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Execution Price', ESP = 'Importe coste';
            Description = 'Q5767';
            Editable = false;
            CaptionClass = '7206910,7206969,50002';


        }
        field(50003; "Sale Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Adjudication Price', ESP = 'Importe venta';
            Description = 'Q5767';
            Editable = false;
            CaptionClass = '7206910,7206969,50003';


        }
        field(50004; "Profit"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amt. Adjudication Coeficient', ESP = 'Resultado';
            Description = 'Q5767';
            Editable = false;
            CaptionClass = '7206910,7206969,50004';


        }
        field(50009; "Price review percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review %', ESP = '% Revisi�n Precios';
            MinValue = 0;
            MaxValue = 100;
            Editable = false;


        }
        field(50011; "Sale Price With Price review"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Adjudication Price', ESP = 'Precio venta con Revisi�n Precios';
            Editable = false;


        }
        field(50012; "Sale Amount With Price review"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Adjudication Price', ESP = 'Importe venta con Revisi�n Precios';
            Editable = false;


        }
        field(50051; "Service Order Type"; Code[10])
        {
            TableRelation = "Service Order Type";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Service Order Type', ESP = 'Tipo pedido servicio';
            Description = 'Q5767';


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            MaintainSIFTIndex = false;
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       HistMeasurements@7001100 :
        HistMeasurements: Record 7206968;
        //       DimensionManagement@7207771 :
        DimensionManagement: Codeunit "DimensionManagement";

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

    procedure ShowDimensions()
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Line No.", "Piecework No."));
    end;

    procedure GetMeasureNo(): Code[10];
    begin
        //{SE COMENTA.
        //      GetMasterHeader;
        //      exit(HistMeasurements."No. Measure");
        //      }
    end;

    LOCAL procedure GetMasterHeader()
    begin
        //Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");

        if "Document No." <> HistMeasurements."No." then begin
            HistMeasurements.GET("Document No.");
        end;
    end;

    /*begin
    end.
  */
}








table 7207339 "Hist. Measure Lines"
{


    CaptionML = ENU = 'Hist. Measurements Lines', ESP = 'Hist. l�neas mediciones';

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
        field(6; "Med. Term PEC Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe Periodo PEC';
            Description = 'Importe PEC Periodo';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


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
        field(11; "Contract Price"; Decimal)
        {
            CaptionML = ENU = 'Sale Price', ESP = 'Precio E.C.';
            Description = 'Precio PEC';


        }
        field(12; "Certificated Quantity"; Decimal)
        {
            CaptionML = ENU = 'Certified Amount', ESP = 'Cantidad certificada';
            DecimalPlaces = 2 : 4;


        }
        field(13; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(14; "OLD_Measure Date"; Date)
        {
            CaptionML = ENU = 'Measure Date', ESP = 'Fecha medici�n';
            Description = '### ELIMINAR ### no se usa';


        }
        field(15; "Quantity Measure Not Cert"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount Measure Not Certified', ESP = 'Cantidad medida no certif';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(16; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N� Cliente';


        }
        field(17; "Sale Price"; Decimal)
        {
            CaptionML = ENU = 'Contract Price', ESP = 'Precio E.M.';
            Description = 'Precio PEM';
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
        field(19; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Hist. Measurements"."Posting Date" WHERE("No." = FIELD("Document No.")));
            CaptionML = ESP = 'Fecha Registro';
            Description = 'QB 1.08.42 - JAV 18/05/21 Obtiene la fecha de la cabecera';


        }
        field(20; "Adjustment Redeterm. Prices"; Decimal)
        {
            CaptionML = ENU = 'Adjustment Redeterm. Prices', ESP = 'Ajuste Redeterminacion Precios';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrencyCode;


        }
        field(21; "OLD_Certification Amount (base"; Decimal)
        {
            CaptionML = ENU = 'Certification Amount (base)', ESP = 'Importe Periodo PEC';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(22; "Measurement Adjustment"; Decimal)
        {
            CaptionML = ENU = 'Measurement Adjustment', ESP = 'Medici�n Ajuste';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(23; "Previous Redetermined Price"; Decimal)
        {
            CaptionML = ENU = 'Previous Redetermined Price', ESP = 'Precio redeterminado anterior';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(24; "Last Price Redetermined"; Decimal)
        {
            CaptionML = ENU = 'Last Price Redetermined', ESP = '�ltimo precio redeterminado';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(28; "Med. Source Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;
            Description = 'Med. Origen';


        }
        field(29; "Med. Term Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Medicion periodo', ESP = 'Medici�n per�odo';
            DecimalPlaces = 2 : 4;
            Description = 'Cantidad Periodo';


        }
        field(35; "Med. Measured Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cantidad medida', ESP = 'Cantidad medida';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(36; "Med. Pending Measurement"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Medicion pendiente', ESP = 'Medici�n pendiente';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(39; "Med. % Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de medicion', ESP = '% de medici�n';
            DecimalPlaces = 2 : 6;


        }
        field(46; "From Measure"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Viene de la medici�n';
            Description = 'JAV 01/06/21: - QB 1.08.47 indica que los datos se han establecido desde la medici�n detallada';


        }
        field(47; "No. Measurement"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measure Lines Bill of Item" WHERE("Document No." = FIELD("Document No."),
                                                                                                         "Line No." = FIELD("Line No.")));
            CaptionML = ESP = 'N� l�neas medici�n';
            Description = 'JAV 01/06/21: - QB 1.08.48 indica que los datos se han establecido desde la medici�n detallada';
            Editable = false;


        }
        field(48; "Term PEC Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio del Periodo a PEC';
            Description = 'JAV 15/09/21: - QB 1.09.18 Precio del periodo a PEC, se calcula para absorver las diferencias de precio anteriores con la actual';
            Editable = false;


        }
        field(49; "Term PEM Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio del Periodo a PEM';
            Description = 'JAV 15/09/21: - QB 1.09.18 Precio del periodo a PEM, se calcula para absorver las diferencias de precio anteriores con la actual';
            Editable = false;


        }
        field(50; "Is Cancel Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Es l�nea de cancelaci�n';
            Description = 'QB 1.09.20 JAV 28/09/21 Si esta l�nea es de una cancelaci�n';


        }
        field(106; "Record"; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Expediente';
            Description = 'QB 1.10.14 JAV 25/01/22 Nro del expediente relacionado con la l�nea';
            Editable = false;


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';


        }
        field(108; "OLD_Calculated Prod. Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Calculated Production Measure', ESP = 'Medici�n Producci�n Calculada';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa';


        }
        field(109; "Med. Term Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Periodo PEM';
            Description = 'Importe PEM del periodo                               JAV 04/04/19: - Se incluyen los campos para realizar el c�lculo del importe correcto';
            Editable = false;


        }
        field(111; "Med. Source Amount PEM"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification Amount (base)', ESP = 'Imp. Origen a PEM';
            Description = 'Importe PEM a origen de Mediciones';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(112; "Med. Source Amount PEC"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', ESP = 'Imp. Origen a PEC';
            Description = 'Importe PEC a origen de Mediciones';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(113; "Med. Anterior PEM amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Piecework No." = FIELD("Piecework No.")));
            CaptionML = ESP = 'Imp.Anterior a PEM';
            Description = 'QB 1.08.28 - JAV 25/03/21 Suma anterior a PEM';


        }
        field(114; "Med. Anterior PEC amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Piecework No." = FIELD("Piecework No.")));
            CaptionML = ESP = 'Imp.Anterior a PEC';
            Description = 'QB 1.08.28 - JAV 25/03/21 Suma anterior a PEC';


        }
    }
    keys
    {
        key(key1; "Document No.","Line No.")
        {
            SumIndexFields="Med. Term PEC Amount";
            MaintainSIFTIndex=false;
            Clustered=true;
        }
        key(key2; "Job No.", "Piecework No.")
        {
            SumIndexFields = "Med. Term PEC Amount", "Med. Term Measure";
        }

    }
    fieldgroups
    {
    }

    var
        //       HistMeasurements@7001100 :
        HistMeasurements: Record 7207338;
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

    procedure GetMeasureNo(): Code[20];
    begin
        GetMasterHeader;
        exit(HistMeasurements."No. Measure");
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
    //{
//      JAV 14/06/21: - QB 1.08.48 Se elimina el campo "Fecha medici�n" y su uso en una key
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de la funci�n GetMeasureNo de 10 a 20
//
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Modificaci�n Clave (Job No.,Piecework No.): A�adido SumIndexfield
//    }
    end.
  */
}








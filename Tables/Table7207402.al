table 7207402 "QBU Hist. Prod. Measure Lines"
{


    CaptionML = ENU = 'Hist. Prod. Measure Lines', ESP = 'Hist. Lineas Relaci�n Valorada';
    LookupPageID = "Post. Prod. Meas. Line Subform";
    DrillDownPageID = "Post. Prod. Meas. Line Subform";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';


        }
        field(3; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Piecework Code" = FIELD("Piecework No."));
            CaptionML = ENU = 'Piecework No.', ESP = 'No. unidad de obra';


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "OLD_Amount"; Decimal)
        {

            CaptionML = ENU = 'Amount', ESP = '_PEM Importe del Periodo';
            Description = '### ELIMINAR ### se reemplaza por el 112';
            AutoFormatExpression = GetCurrencyCode;


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(10; "OLD_Measure Amount"; Decimal)
        {
            CaptionML = ENU = 'Measure Amount', ESP = 'Cantidad medida';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### se reemplaza por el 93';


        }
        field(11; "OLD_Sales Price"; Decimal)
        {

            CaptionML = ENU = 'Sales Price', ESP = '_Precio venta';
            Description = '### ELIMINAR ### se reemplaza por el 120';


        }
        field(12; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(13; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Measure Date', ESP = 'Fecha Registro';
            Description = 'QB 1.08.48  JAV 14/06/21 Se cambia la fecha de la medici�n por la de registro que es la adecuada';


        }
        field(14; "OLD_Pending Measure"; Decimal)
        {
            CaptionML = ENU = 'Pending Measure', ESP = 'Medici�n pendiente';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### se reemplaza por el 94';


        }
        field(15; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(17; "OLD_Realized Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Medicion realizada', ESP = 'Medici�n realizada Anterior';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### se reemplaza por el 91';
            Editable = false;


        }
        field(18; "% Progress To Source"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de avance a origen', ESP = '% de avance a origen';
            DecimalPlaces = 2 : 6;
            Description = 'JAV 25/07/19: - Se incluyen los campos de la relaci�n sin registrar para que se pueda cancelar bien';


        }
        field(19; "OLD_Prod. Amount To Source"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Importe Produccion a Origen', ESP = '_Importe a Origen Anterior';
            Description = '### ELIMINAR ### se reemplaza por el 113';
            Editable = false;


        }
        field(20; "OLD_New Amount To Source"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Importe Nuevo a Origen', ESP = '_Importe a Origen Actual';
            Description = '### ELIMINAR ### no se usa, cambiado por el 123';
            Editable = false;


        }
        field(22; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Description = 'JAV 25/07/19: - Se incluyen los campos de la relaci�n sin registrar para que se pueda cancelar bien';
            Editable = false;


        }
        field(23; "OLD_Source Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Term', ESP = 'Medici�n a Origen';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### se reemplaza por el 92';


        }
        field(42; "From Measure"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Viene de la medici�n';
            Description = 'JAV 01/06/21: - QB 1.08.47 indica que los datos se han establecido desde la medici�n detallada';


        }
        field(43; "No. Measurement"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measure Lines Bill of Item" WHERE("Document No." = FIELD("Document No."),
                                                                                                         "Line No." = FIELD("Line No.")));
            CaptionML = ESP = 'N� l�neas medici�n';
            Description = 'JAV 01/06/21: - QB 1.08.48 indica que los datos se han establecido desde la medici�n detallada';
            Editable = false;


        }
        field(90; "Measure Initial"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n Inicial';
            Description = 'JAV 19/11/20: - QB 1.07.06 Guarda la medici�n antes de aumentarla';
            Editable = false;


        }
        field(91; "Measure Realized"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Medicion realizada', ESP = 'Medici�n realizada Anterior';
            DecimalPlaces = 2 : 4;
            Description = 'JAV 25/07/19: - Se incluyen los campos de la relaci�n sin registrar para que se pueda cancelar bien';
            Editable = false;


        }
        field(92; "Measure Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Term', ESP = 'Medici�n per�odo';
            DecimalPlaces = 2 : 4;


        }
        field(93; "Measure Source"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;

            trigger OnValidate();
            VAR
                //                                                                 RelCertificationProduct@1100286004 :
                RelCertificationProduct: Record 7207397;
                //                                                                 ProcessOk@1100286000 :
                ProcessOk: Boolean;
                //                                                                 txtAux@1100286001 :
                txtAux: Text;
                //                                                                 incCost@1100286002 :
                incCost: Decimal;
                //                                                                 incSale@1100286003 :
                incSale: Decimal;
            BEGIN
            END;


        }
        field(94; "Measure Pending"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Pending Measure', ESP = 'Medici�n pendiente';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(106; "Additional Text Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Additional Text Code', ESP = 'C�digo adicional';
            Description = 'QB 1.06.20 JAV 21/07/20: - Se a�ade el campo del c�digo adicional';


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';


        }
        field(108; "OLD_Contract Price"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Precio contrato';
            Description = '### ELIMINAR ### se reemplaza por el 110';


        }
        field(109; "OLD_Contract Amount"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Importe Contrato a Origen';
            Description = '### ELIMINAR ### se reemplaza por el 113';


        }
        field(110; "OLD_Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_PEM';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(111; "OLD_Amount Realiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Importe Produccion a Origen', ESP = '_Importe PEM Anterior';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(112; "OLD_Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', ESP = '_Importe PEM del periodo';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;
            AutoFormatExpression = "Currency Code";


        }
        field(113; "OLD_Amount To Source"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Importe PEM a Origen';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(119; "PROD Price Old"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sales Price', ESP = 'Precio anterior';
            DecimalPlaces = 2 : 4;
            Description = 'Precio anterior';
            Editable = false;


        }
        field(120; "PROD Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sales Price', ESP = 'Precio';
            DecimalPlaces = 2 : 4;
            Description = 'Precio';
            Editable = false;


        }
        field(121; "PROD Amount Realiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Importe Produccion a Origen', ESP = 'Importe Anterior';
            Description = 'Importe Anterior - JAV 06/02/21';
            Editable = false;


        }
        field(122; "PROD Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', ESP = 'Importe del periodo';
            Description = 'Importe Periodo - JAV 06/02/21';
            Editable = false;
            AutoFormatExpression = "Currency Code";


        }
        field(123; "PROD Amount to Source"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Importe Nuevo a Origen', ESP = 'Importe a Origen';
            Description = 'Importe  Origen - QB 1.06.08 - JAV 26/07/19: - Se cambia el caption';
            Editable = false;


        }
        field(130; "PEM Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'PEM';
            Description = 'QB 1.10.52 - JAV 24/06/22: [TT] Campo informativo.  Precio de Ejecuci�n Material asociado a la Unidad de Obra';
            Editable = false;


        }
        field(131; "PEM Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Periodo a PEM';
            Description = 'QB 1.10.52 - JAV 24/06/22: [TT] Campo informativo.  Importe del periodo valorado al Precio de Ejecuci�n Material asociado a la Unidad de Obra';
            Editable = false;


        }
        field(132; "PEM Amount Source"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a PEM';
            Description = 'QB 1.10.52 - JAV 24/06/22: [TT] Campo informativo.  Importe a Origen valorado al Precio de Ejecuci�n Material asociado a la Unidad de Obra';
            Editable = false;


        }
        field(133; "PEC Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'PEC';
            Description = 'QB 1.10.52 - JAV 24/06/22: [TT] Campo informativo.  Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
            Editable = false;


        }
        field(134; "PEC Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Periodo a PEC';
            Description = 'QB 1.10.52 - JAV 24/06/22: [TT] Campo informativo.  Importe del periodo valorado al Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
            Editable = false;


        }
        field(135; "PEC Amount Source"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a PEC';
            Description = 'QB 1.10.52 - JAV 24/06/22: [TT] Campo informativo.  Importe a Origen valorado al Precio de Ejecuci�n por Contrato asociado a la Unidad de Obra';
            Editable = false;


        }
        field(200; "Cancel Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JAV 21/09/20: - QB 1.06.15 Si esta l�nea es de cancelaci�n';


        }
        field(50000; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe (DL)';
            Description = 'Q7635';
            Editable = false;


        }
        field(50001; "Sales Price (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sales Price (LCY)', ESP = 'Precio venta (DL)';
            Description = 'Q7635';
            Editable = false;


        }
        field(50005; "Amount (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (RC)', ESP = 'Importe (DR)';
            Description = 'Q7635';
            Editable = false;


        }
        field(50006; "Sales Price (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sales Price (RC)', ESP = 'Precio venta (DR)';
            Description = 'Q7635';
            Editable = false;


        }
        field(50007; "Output Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Salidas Procesadas';
            Description = 'JAV 24/04/20: - Si se ha incluido en una salida de materiales del almac�n';


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(key2; "Job No.", "Piecework No.", "Posting Date")
        {
            SumIndexFields = "PROD Amount Term", "Measure Source", "Measure Term";
        }
        key(key3; "Piecework No.", "Job No.")
        {
            SumIndexFields = "Measure Source";
        }
    }
    fieldgroups
    {
    }


    procedure GetCurrencyCode(): Code[10];
    var
        //       PurchInvHeader@1000 :
        PurchInvHeader: Record 122;
        //       HistProdMeasureLines@7001100 :
        HistProdMeasureLines: Record 7207402;
    begin
        if (HistProdMeasureLines."Document No." = PurchInvHeader."No.") then
            exit(PurchInvHeader."Currency Code")
        else
            if PurchInvHeader.GET(HistProdMeasureLines."Document No.") then
                exit(PurchInvHeader."Currency Code")
            else
                exit('');
    end;

    procedure ShowDimensions()
    var
        //       HistProdMeasureLines@7001100 :
        HistProdMeasureLines: Record 7207402;
        //       DimensionManagement@7001101 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        HistProdMeasureLines.TESTFIELD("Piecework No.");
        HistProdMeasureLines.TESTFIELD("Line No.");
        DimensionManagement.ShowDimensionSet(HistProdMeasureLines."Dimension Set ID", STRSUBSTNO('%1 %2 %3', HistProdMeasureLines.TABLECAPTION, HistProdMeasureLines."Document No.", HistProdMeasureLines."Line No."));
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Hist. Measure Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    /*begin
    //{
//      JAV 25/07/19: - Se incluyen los campos 17 a 23 de la relaci�n sin registrar para que se pueda cancelar bien
//      JAV 09/10/20: - QB 1.06.20 Se a�ade la columna del c�digo adicional
//
//      CPA 29/03/22: Q16867 - Mejora de rendimiento. Modificadas la propiedad SumIndexfield de las claves
//                                    Document No.,Line No.OLD_Amount,PEM Amount Term
//                                    Job No.,Piecework No.,Posting DateOLD_Amount,OLD_Measure Amount,PEC Amount Term,PEM Amount Term,Measure Source
//                                    Piecework No.,Job No.OLD_Measure Amount,Measure Source
//      JAV 24/06/22: - QB 1.10.53 Se cambian los campos "PEC xxx" por "COST xxx" que es mas apropiado y se eliminan los campos "PEM xxx" que no se utilizan pasandolos a "OLD_xxx"
//                                 Se a�aden campos para ver el precio real a PEC, junto a los importes
//      JAV 30/06/22: - QB 1.10.57 Estaban intercambiados PEM y PEC
//    }
    end.
  */
}








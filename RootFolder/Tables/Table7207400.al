table 7207400 "Prod. Measure Lines"
{


    LinkedObject = false;
    CaptionML = ENU = 'Prod. Measure Lines', ESP = 'L�neas Relaci�n Valorada';
    PasteIsValid = false;
    LookupPageID = "Prod. Measure Lines Subform.";
    DrillDownPageID = "Prod. Measure Lines Subform.";

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


            CaptionML = ENU = 'Piecework No.', ESP = 'No. unidad de obra';

            trigger OnValidate();
            BEGIN
                ProdMeasureLines.SETRANGE("Document No.", "Document No.");
                ProdMeasureLines.SETRANGE("Piecework No.", "Piecework No.");
                ProdMeasureLines.SETFILTER("Line No.", '<>%1', "Line No.");
                IF ProdMeasureLines.FINDFIRST THEN
                    ERROR(Text005, "Piecework No.", "Document No.");

                tempProdMeasureLines := Rec;
                INIT;
                "Piecework No." := tempProdMeasureLines."Piecework No.";
                "Cancel Line" := tempProdMeasureLines."Cancel Line";
                IF "Piecework No." = '' THEN
                    EXIT;

                GetPiecework;

                IF DataPieceworkForProduction."Job No." <> ProdMeasureHeader."Job No." THEN
                    ERROR(Text004);
                IF NOT DataPieceworkForProduction."Production Unit" THEN
                    ERROR(Text002);

                VALIDATE("Currency Code", ProdMeasureHeader."Currency Code");
                Description := DataPieceworkForProduction.Description;
                "Description 2" := DataPieceworkForProduction."Description 2";
                "Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";
                "Additional Text Code" := DataPieceworkForProduction."Additional Text Code";

                SetDataFromPiecework;

                //JAV 19/11/20: - QB 1.07.06 Guardar la medici�n inicial por si la cambian
                IF ("Measure Initial" = 0) THEN
                    "Measure Initial" := "Measure Realized" + "Measure Pending";

                CreateDim();
            END;

            trigger OnLookup();
            BEGIN
                GetMasterHeader;

                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", ProdMeasureHeader."Job No.");
                DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
                IF PAGE.RUNMODAL(PAGE::"Data Piecework List", DataPieceworkForProduction) = ACTION::LookupOK THEN BEGIN
                    "Job No." := ProdMeasureHeader."Job No.";
                    VALIDATE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                END;
            END;


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "OLD_Term Amount"; Decimal)
        {

            CaptionML = ENU = 'Amount', ESP = '_Importe PEM del periodo';
            Description = '### ELIMINAR ### no se usa, cambiado por el 112';
            Editable = false;
            AutoFormatExpression = "Currency Code";


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(10; "OLD_Source Measure"; Decimal)
        {


            CaptionML = ENU = 'Origin Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa, cambiado por el 93';

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
        field(11; "OLD_Sales Price"; Decimal)
        {

            CaptionML = ENU = 'Sales Price', ESP = '_PEC';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa, cambiado por el 120';
            Editable = false;


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
            Description = '### ELIMINAR ### no se usa, cambiado por el 94';
            Editable = false;


        }
        field(15; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnValidate();
            BEGIN
                ShowDimensions;
            END;


        }
        field(17; "OLD_Realized Measure"; Decimal)
        {
            CaptionML = ENU = 'Medicion realizada', ESP = 'Medici�n realizada Anterior';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa, cambiado por el 91';
            Editable = false;


        }
        field(18; "% Progress To Source"; Decimal)
        {


            CaptionML = ENU = '% de avance a origen', ESP = '% de avance a origen';
            DecimalPlaces = 2 : 6;

            trigger OnValidate();
            BEGIN
                GetPiecework;
                VALIDATE("Measure Source", DataPieceworkForProduction."Budget Measure" * "% Progress To Source" / 100);
                //-Q17698
                IF Rec.FIELDACTIVE("% Progress To Source") THEN PercentageLines;
                //+Q17698
            END;


        }
        field(19; "OLD_Prod. Amount To Source"; Decimal)
        {

            CaptionML = ENU = 'Importe Produccion a Origen', ESP = '_Importe PEM Anterior';
            Description = '### ELIMINAR ### no se usa, cambiado por el 111';
            Editable = false;


        }
        field(20; "OLD_New Amount To Source"; Decimal)
        {

            CaptionML = ENU = 'Importe Nuevo a Origen', ESP = '_Importe PEC Origen';
            Description = '### ELIMINAR ### no se usa, cambiado por el 123';
            Editable = false;


        }
        field(22; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(23; "OLD_Measure Term"; Decimal)
        {
            CaptionML = ENU = 'Measure Term', ESP = 'Medici�n per�odo';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa, cambiado por el 92';


        }
        field(24; "OLD_Initial Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n Inicial';
            Description = '### ELIMINAR ### no se usa, cambiado por el 90';
            Editable = false;


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
            Editable = false;


        }
        field(92; "Measure Term"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Term', ESP = 'Medici�n per�odo';
            DecimalPlaces = 2 : 4;

            trigger OnValidate();
            BEGIN
                //JAV 02/04/19: - Mejoras en mediciones, se puede introducir importes a origen o del periodo indiferentemente
                GetPiecework;
                VALIDATE("Measure Source", "Measure Term" + DataPieceworkForProduction."Total Measurement Production");
            END;


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
                //JAV 02/04/19: - Mejoras en mediciones, se puede introducir importes a origen o del periodo indiferentemente
                //JAV 08/08/20: - Si se pasan del 100%, se avisa y se amplia si es necesario la medici�n para que nunca sea superior al 100%
                //JAV 20/09/20: - QB 1.06.14 En presupuestos de medici�n abierta, verificar tambi�n si sobrepasamos la de venta

                recJob.GET("Job No.");
                GetPiecework;

                //Miro si debo aumentar coste o venta
                IF (oldMeasure = 0) THEN
                    oldMeasure := "Measure Source";

                incCost := "Measure Source" - DataPieceworkForProduction."Budget Measure";
                IF (incCost < 0) THEN
                    incCost := 0;

                incSale := 0;
                IF (recJob."Sales Medition Type" = recJob."Sales Medition Type"::open) THEN BEGIN
                    incSale := "Measure Source" - DataPieceworkForProduction."Sale Quantity (base)";
                    //IF (incSale < 0) THEN //JMMA lo pongo despu�s
                    //  incSale := 0;
                    IF (incSale <> 0) AND (recJob."Separation Job Unit/Cert. Unit") THEN BEGIN
                        RelCertificationProduct.RESET;
                        RelCertificationProduct.SETRANGE("Job No.", recJob."No.");
                        RelCertificationProduct.SETRANGE("Production Unit Code", "Piecework No.");
                        IF (NOT RelCertificationProduct.ISEMPTY) THEN
                            incSale := -incSale;
                    END;
                    IF (incSale < 0) THEN //JMMA SE A�ADE AQU�.
                        incSale := 0;
                END;

                //Si hay que incrementar coste o venta
                IF (NOT "Cancel Line") AND ((incCost <> 0) OR (incSale <> 0)) THEN BEGIN //JAV 21/09/20: - QB 1.06.15 No para l�neas de cancelaci�n
                                                                                         //Pedir confirmaci�n si no es autom�tica
                    IF (bIncrementAuto) THEN
                        bIncrementAuto := FALSE
                    ELSE BEGIN
                        CASE recJob."Sales Medition Type" OF
                            recJob."Sales Medition Type"::closed:
                                txtAux := STRSUBSTNO(Text003a, incCost);          //Medici�n cerrada, solo aumentaremos coste
                            recJob."Sales Medition Type"::open:
                                IF (incSale >= 0) THEN
                                    txtAux := STRSUBSTNO(Text003b, incCost, incSale)       //Medici�n abierta, aumentamos coste y venta autom�ticamente
                                ELSE
                                    ERROR(STRSUBSTNO(Text003c, incCost, ABS(incSale)));  //Medici�n abierta, aumentamos coste autom�ticamente, pero venta manual
                        END;
                        IF NOT CONFIRM(txtAux, FALSE) THEN
                            ERROR('');
                    END;

                    //Incremento los datos
                    IncreaseCostSale("Job No.", "Piecework No.", "Measure Source", (incCost > 0), (incSale > 0), FALSE);

                    //Leo otra vez los datos recalculados
                    GetPiecework;
                    SetDataFromPiecework;

                    //Recupero la medici�n de la l�nea que he guardado
                    "Measure Source" := oldMeasure;
                    oldMeasure := 0;
                END;

                CalcMeasureAmount(TRUE);

                "From Measure" := FALSE; //Si la han cambiado ya no puede estar relacionada con las mediciones detalladas
            END;


        }
        field(94; "Measure Pending"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Pending Measure', ESP = 'Medici�n pendiente';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(100; "Pending Production Price"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Prod. Pte.';


        }
        field(106; "Additional Text Code"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Additional Text Code', ESP = 'C�digo adicional';
            Description = 'QB 1.06.20 JAV 21/07/20: - Se a�ade el campo del c�digo adicional';

            trigger OnValidate();
            BEGIN
                //JAV 09/10/20: - QB 1.06.20 Buscar el c�digo adicional en el proyecto, si existe se usar la U.O.
                IF ("Additional Text Code" <> '') AND ("Additional Text Code" <> xRec."Additional Text Code") THEN BEGIN
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                    DataPieceworkForProduction.SETRANGE("Additional Text Code", "Additional Text Code");
                    IF (DataPieceworkForProduction.FINDFIRST) THEN
                        VALIDATE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                END;
            END;


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';

            trigger OnValidate();
            BEGIN
                //JAV 09/10/20: - QB 1.06.20 Buscar el c�digo de PRESTO en el proyecto, si existe se usar la U.O.
                IF ("Code Piecework PRESTO" <> '') AND ("Code Piecework PRESTO" <> xRec."Code Piecework PRESTO") THEN BEGIN
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                    DataPieceworkForProduction.SETRANGE("Code Piecework PRESTO", "Code Piecework PRESTO");
                    IF (DataPieceworkForProduction.FINDFIRST) THEN
                        VALIDATE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                END;
            END;


        }
        field(108; "OLD_Contract Price"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ESP = '_PEM';
            Description = '### ELIMINAR ### no se usa, cambiado por el 110';
            Editable = false;


        }
        field(109; "OLD_Contract Amount"; Decimal)
        {

            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Importe PEM a Origen';
            Description = '### ELIMINAR ### no se usa, cambiado por el 113';
            Editable = false;


        }
        field(110; "OLD_Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_PEM';
            DecimalPlaces = 2 : 6;
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
            DecimalPlaces = 2 : 6;
            Description = 'Precio anterior';
            Editable = false;


        }
        field(120; "PROD Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sales Price', ESP = 'Precio';
            DecimalPlaces = 2 : 6;
            Description = 'Precio';
            Editable = false;


        }
        field(121; "PROD Amount Realiced"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Importe Produccion a Origen', ESP = 'Importe Anterior';
            Description = 'Importe Anterior - JAV 06/02/21';
            Editable = false;

            trigger OnLookup();
            BEGIN
                HistProdMeasureLines.RESET;
                HistProdMeasureLines.SETRANGE("Job No.", "Job No.");
                HistProdMeasureLines.SETRANGE("Piecework No.", "Piecework No.");
                HistProdMeasureLines.SETFILTER("Posting Date", '..%1', "Posting Date");

                CLEAR(PostProdMeasLineSubform);
                PostProdMeasLineSubform.SETTABLEVIEW(HistProdMeasureLines);
                PostProdMeasLineSubform.RUNMODAL;
            END;


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
            CaptionML = ENU = 'Importe Nuevo a Origen', ESP = 'Importe Origen';
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
        field(300; "% Progress Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de avance seg�n coste', ESP = '% de avance seg�n coste';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                //JMMA
                IF (DataPieceworkForProduction."Amount Cost Budget (LCY)" <> 0) THEN
                    "% Progress Cost" := ROUND((DataPieceworkForProduction."Amount Cost Performed (LCY)" / DataPieceworkForProduction."Amount Cost Budget (LCY)" * 100), 0.01)
                ELSE
                    "% Progress Cost" := 0;
            END;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       ProdMeasureHeader@7001100 :
        ProdMeasureHeader: Record 7207399;
        //       Currency@7001101 :
        Currency: Record 4;
        //       MeasureLinesBillofItem@7001102 :
        MeasureLinesBillofItem: Record 7207395;
        //       Text000@7001103 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       ProdMeasureLines@7001104 :
        ProdMeasureLines: Record 7207400;
        //       Text001@1100286000 :
        Text001: TextConst ENU = 'Measure Type does not correspond', ESP = 'El tipo de medici�n no se corresponde.';
        //       Text002@1100286002 :
        Text002: TextConst ESP = 'No es posible incluir mas que unidades de producci�n';
        //       Text003a@1100286005 :
        Text003a: TextConst ESP = 'Ha sobrepasado la medici�n planificada, si continua\     - Se ampliar� en %1 la medici�n de coste\ �Confirma que desea cambiar la medici�n?';
        //       Text003b@1100286008 :
        Text003b: TextConst ESP = 'Ha sobrepasado la medici�n planificada, si continua\     - Se ampliar� en %1 la medici�n de coste\     - Se ampliar� en %2 la medici�n de venta\�Confirma que desea cambiar la medici�n?';
        //       Text003c@1100286003 :
        Text003c: TextConst ESP = 'Ha sobrepasado la medici�n planificada. Deber� ampliar manualmente %2 unidads de venta.';
        //       tempProdMeasureLines@7001106 :
        tempProdMeasureLines: Record 7207400;
        //       DataPieceworkForProduction@7001108 :
        DataPieceworkForProduction: Record 7207386;
        //       Text004@7001109 :
        Text004: TextConst ENU = 'Specified Job in header is different than associated Job to piecework', ESP = 'El proyecto especificado en la cabecera es distinto del asociado a la unidad de obra';
        //       Text005@1100286009 :
        Text005: TextConst ENU = 'Piecework %1 already exists for document %2', ESP = 'Ya existe la unidad de obra %1 para el documento %2.';
        //       Text006@7001112 :
        Text006: TextConst ENU = 'You can not take either chapters or subcapitules, you can only take matches.', ESP = 'No se puede coger ni capitulos ni subcapitulos, solo se puede coger partidas.';
        //       recJob@1000000001 :
        recJob: Record 167;
        //       recDataPiecework@1000000000 :
        recDataPiecework: Record 7207386;
        //       QuoBuildingSetup@1100286006 :
        QuoBuildingSetup: Record 7207278;
        //       HistProdMeasureLines@1100286013 :
        HistProdMeasureLines: Record 7207402;
        //       Text007@1100286007 :
        Text007: TextConst ESP = 'Recuerde recalcular el presupuesto anal�tico de la obra';
        //       Text008@1100286010 :
        Text008: TextConst ESP = 'No ha definido el presupuesto actual en la obra %1';
        //       Text009@1100286011 :
        Text009: TextConst ESP = 'No existe la unidad de obra %1 en el proyecto %2';
        //       Text010@1100286012 :
        Text010: TextConst ESP = 'No ha marcado el presupuesto actual en el proyecto.';
        //       PostProdMeasLineSubform@1100286014 :
        PostProdMeasLineSubform: Page 7207521;
        //       DimMgt@1100286015 :
        DimMgt: Codeunit "DimensionManagement";
        //       ManagementLineofMeasure@1100286004 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       bIncrementAuto@1100286001 :
        bIncrementAuto: Boolean;
        //       oldMeasure@1100286016 :
        oldMeasure: Decimal;
        //       SourceOrigin@1000000002 :
        SourceOrigin: Decimal;



    trigger OnInsert();
    begin
        AddMeasureLines;  //A�adir mediciones detalladas
    end;

    trigger OnModify();
    begin
        if ("Piecework No." <> xRec."Piecework No.") then
            AddMeasureLines;
    end;

    trigger OnDelete();
    begin
        MeasureLinesBillofItem.SETRANGE("Document Type", MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
        MeasureLinesBillofItem.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    procedure GetBudget(): Code[20];
    var
        //       Job@1100286000 :
        Job: Record 167;
    begin
        Job.GET("Job No.");
        if (Job."Current Piecework Budget" = '') then
            ERROR(Text008, "Job No.");

        exit(Job."Current Piecework Budget");
    end;

    LOCAL procedure GetMasterHeader()
    begin
        //Leer el registro de la cabecera
        TESTFIELD("Document No.");

        ProdMeasureHeader.GET("Document No.");
        if ProdMeasureHeader."Currency Code" <> '' then begin
            ProdMeasureHeader.TESTFIELD("Currency Factor");
            Currency.GET(ProdMeasureHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        end;

        ProdMeasureHeader.TESTFIELD(ProdMeasureHeader."Job No.");
        "Document No." := ProdMeasureHeader."No.";
        "Job No." := ProdMeasureHeader."Job No.";
        "Posting Date" := ProdMeasureHeader."Posting Date";
    end;

    LOCAL procedure GetPiecework()
    begin
        //JAV 07/08/20: - Se cambia un poco la funci�n que busca la unidad de obra
        GetMasterHeader;
        if ("Piecework No." = '') then
            exit;

        if (not DataPieceworkForProduction.GET("Job No.", "Piecework No.")) then
            ERROR(Text009, "Piecework No.", "Job No.");

        if DataPieceworkForProduction."Account Type" <> DataPieceworkForProduction."Account Type"::Unit then
            ERROR(Text006);

        DataPieceworkForProduction.SETRANGE("Budget Filter", GetBudget);

        DataPieceworkForProduction.SETRANGE("Filter Date", 0D, ProdMeasureHeader."Posting Date");
        DataPieceworkForProduction.CALCFIELDS("Amount Production Performed", "Total Measurement Production");

        DataPieceworkForProduction.SETRANGE("Filter Date");
        DataPieceworkForProduction.CALCFIELDS("Budget Measure", "Amount Production Budget", "Amount Cost Budget (LCY)", "Amount Cost Performed (LCY)");
        DataPieceworkForProduction.CALCFIELDS("Amount Production Budget", "Measure Budg. Piecework Sol");
    end;

    LOCAL procedure SetDataFromPiecework()
    begin
        CLEAR(Currency);
        Currency.InitRoundingPrecision;

        GetPiecework;
        "Measure Pending" := DataPieceworkForProduction."Budget Measure" - DataPieceworkForProduction."Total Measurement Production";
        if "Measure Pending" < 0 then
            "Measure Pending" := 0;
        VALIDATE("Measure Realized", DataPieceworkForProduction."Total Measurement Production");

        ///////"Pending Production Price" := DataPieceworkForProduction.PendingProductionPrice;  //JAV 28/07/21

        if (DataPieceworkForProduction."Amount Production Budget" <> DataPieceworkForProduction."Amount Production Performed") and
           (DataPieceworkForProduction."Measure Budg. Piecework Sol" <> DataPieceworkForProduction."Total Measurement Production") then  //JAV 28/07/21: - QB 1.09.14 Para no dar divisi�n por cero
            "Pending Production Price" := (DataPieceworkForProduction."Amount Production Budget" - DataPieceworkForProduction."Amount Production Performed") /
                                          (DataPieceworkForProduction."Measure Budg. Piecework Sol" - DataPieceworkForProduction."Total Measurement Production")
        else if (DataPieceworkForProduction."Measure Budg. Piecework Sol" <> 0) then   //Si estamos al 100% lo calculo sobre la producci�n total, pero sin divisi�n por cero si no hay producci�n
            "Pending Production Price" := DataPieceworkForProduction."Amount Production Budget" / DataPieceworkForProduction."Measure Budg. Piecework Sol"
        else  //Si no hay cantidad presupuestada no puedo calcular nada
            "Pending Production Price" := 0;

        "Pending Production Price" := ROUND("Pending Production Price", Currency."Unit-Amount Rounding Precision");  //PSM 03/06/21

        //JAV 04/06/21 Calculo los precios por defecto
        "PROD Price" := "Pending Production Price";  //PSM 03/06/21
                                                     //JAV 24/06/22: - QB 1.10.53 Eliminados los campos PEM que no se utilizan
                                                     //OLD_Price := "COST Price";

        //JAV 04/06/21 Calculo el importe de la producci�n anterior y su precio
        VALIDATE("PROD Amount Realiced", DataPieceworkForProduction."Amount Production Performed");

        //JAV 24/06/22: - QB 1.10.53 Eliminados los campos PEM que no se utilizan
        // HistProdMeasureLines.RESET;
        // HistProdMeasureLines.SETRANGE("Job No.", "Job No.");
        // HistProdMeasureLines.SETRANGE("Piecework No.", "Piecework No.");
        // HistProdMeasureLines.SETFILTER("Posting Date", '..%1', "Posting Date");
        // HistProdMeasureLines.CALCSUMS("OLD_Amount Term");
        // VALIDATE("OLD_Amount Realiced", HistProdMeasureLines."OLD_Amount Term");

        //JMMA
        VALIDATE("% Progress Cost");

        CalcMeasureAmount(FALSE);
        if (not "Cancel Line") then
            VALIDATE("Measure Source", "Measure Realized");

        //Calcular anterior precio Coste
        if ("PROD Amount Term" = 0) or ("Measure Realized" = 0) then         //Si el importe del periodo es cero o no hay anterior, no hay diferencias de precios
            "PROD Price Old" := "PROD Price"
        else                                                                //Si no calculo el precio como producido anterior entre cantidad producida anterior
            "PROD Price Old" := ROUND("PROD Amount Realiced" / "Measure Realized", Currency."Unit-Amount Rounding Precision");
    end;

    procedure LinesBillOfItemMeasuring()
    begin
        GetMasterHeader;
        MeasureLinesBillofItem.SETRANGE("Document Type", MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
        MeasureLinesBillofItem.DELETEALL;
        ManagementLineofMeasure.GetLineDescMeasureOrder(ProdMeasureHeader."Job No.", "Piecework No.",
                                                        MeasureLinesBillofItem."Document Type"::"Valued Relationship",
                                                        "Document No.", "Line No.", GetBudget);
    end;

    procedure CreateDim()
    var
        //       SourceCodeSetup@1008 :
        SourceCodeSetup: Record 242;
        //       TableID@1009 :
        TableID: ARRAY[10] OF Integer;
        //       No@1010 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        GetMasterHeader;

        TableID[1] := DATABASE::Job;
        No[1] := ProdMeasureHeader."Job No.";
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        "Dimension Set ID" := DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Prod. Measuring", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                                                     ProdMeasureHeader."Dimension Set ID", DATABASE::Job);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure UpdateMeasureOrigin()
    begin
        GetPiecework;
        VALIDATE("Measure Source", "Measure Term" + DataPieceworkForProduction."Total Measurement Production");

        if ("Measure Term" < 0) then
            if (DataPieceworkForProduction."Total Measurement Production" <> 0) then begin
                Currency.InitRoundingPrecision;
                VALIDATE("PROD Price", ROUND(DataPieceworkForProduction."Amount Production Performed" / DataPieceworkForProduction."Total Measurement Production", Currency."Unit-Amount Rounding Precision"));
            end;
    end;

    procedure UpdateMeasureTerm()
    begin
        GetPiecework;
        "Measure Term" := "Measure Source" - DataPieceworkForProduction."Total Measurement Production"; //No hago validate por evitar la referencia circular

        if "Measure Term" < 0 then
            if DataPieceworkForProduction."Total Measurement Production" <> 0 then begin
                Currency.InitRoundingPrecision;
                VALIDATE("PROD Price", ROUND(DataPieceworkForProduction."Amount Production Performed" / DataPieceworkForProduction."Total Measurement Production", Currency."Unit-Amount Rounding Precision"));
            end;
    end;

    //     procedure CalcMeasureAmount (UpdateMeditions@1100286000 :
    procedure CalcMeasureAmount(UpdateMeditions: Boolean)
    begin
        CLEAR(Currency);
        Currency.InitRoundingPrecision;

        GetPiecework;

        //JAV 07/08/20: - Mejoras en mediciones, se calcula siempre la medici�n del periodo y el % de avance a origen al calcular el importe de la l�nea
        "Measure Term" := "Measure Source" - DataPieceworkForProduction."Total Measurement Production"; //No hago validate por evitar la referencia circular

        //JAV 19/11/20: - QB 1.07.06 Cambio la forma de calcular los importes y el lugar desde donde se calculan
        //"COST Amount to Source" := ROUND("COST Price" * "Measure Source", Currency."Unit-Amount Rounding Precision");
        //"COST Amount Term"      := "COST Amount to Source" - "COST Amount Realiced";

        //"OLD_Amount To Source" := ROUND("OLD_Price" * "Measure Source", Currency."Unit-Amount Rounding Precision");
        //"OLD_Amount Term"  := "OLD_Amount To Source" - "OLD_Amount Realiced";

        //PSM-JMMA PRUEBAS CORRECCI�N 210826+
        SourceOrigin := 0;
        if DataPieceworkForProduction."Measure Budg. Piecework Sol" <> 0 then
            SourceOrigin := ROUND(DataPieceworkForProduction."Amount Production Budget" / DataPieceworkForProduction."Measure Budg. Piecework Sol", Currency."Unit-Amount Rounding Precision");
        "PROD Amount to Source" := ROUND(SourceOrigin * "Measure Source", Currency."Unit-Amount Rounding Precision");
        "PROD Amount Term" := "PROD Amount to Source" - "PROD Amount Realiced";

        //JAV 24/06/22: - QB 1.10.53 Eliminados los campos PEM que no se utilizan
        //"OLD_Amount To Source" := ROUND(SourceOrigin * "Measure Source", Currency."Unit-Amount Rounding Precision");
        //"OLD_Amount Term"      := "OLD_Amount To Source" - "OLD_Amount Realiced";
        //PSM-JMMA PRUEBAS CORRECCI�N 210826-

        if (DataPieceworkForProduction."Budget Measure" <> 0) then
            "% Progress To Source" := ROUND(("Measure Source" * 100) / DataPieceworkForProduction."Budget Measure", 0.000001)
        else
            "% Progress To Source" := 100;

        //JAV 22/07/20: - Actualiza las l�neas de medici�n con el porcentaje
        if (UpdateMeditions) then
            AddMeasureLines;

        //JAV 24/06/22: - QB 1.10.53 Se a�aden campos informativos para ver el precio a PEC, junto a los importes
        Rec."PEM Price" := DataPieceworkForProduction."Contract Price";
        Rec."PEM Amount Term" := ROUND("PEM Price" * "Measure Term", Currency."Unit-Amount Rounding Precision");
        Rec."PEM Amount Source" := ROUND("PEM Price" * "Measure Source", Currency."Unit-Amount Rounding Precision");
        Rec."PEC Price" := DataPieceworkForProduction."Unit Price Sale (base)";
        Rec."PEC Amount Term" := ROUND("PEC Price" * "Measure Term", Currency."Unit-Amount Rounding Precision");
        Rec."PEC Amount Source" := ROUND("PEC Price" * "Measure Source", Currency."Unit-Amount Rounding Precision");
    end;

    procedure ShowDimensions()
    begin

        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure SetAutoIncrement()
    begin
        bIncrementAuto := TRUE;
    end;

    //     procedure IncreaseCostSale (JobNo@1100286004 : Code[20];PieceworkNo@1100286005 : Code[20];NewMeasure@1100286000 : Decimal;bCost@1100286002 : Boolean;bSale@1100286001 : Boolean;bNotSeeDialog@1100286008 :
    procedure IncreaseCostSale(JobNo: Code[20]; PieceworkNo: Code[20]; NewMeasure: Decimal; bCost: Boolean; bSale: Boolean; bNotSeeDialog: Boolean)
    var
        //       DataPieceworkForProduction2@1100286006 :
        DataPieceworkForProduction2: Record 7207386;
        //       RateBudgetsbyPiecework@1100286007 :
        RateBudgetsbyPiecework: Codeunit 7207329;
        //       JobBudget@1100286003 :
        JobBudget: Record 7207407;
        //       MeasurementLinPiecewProd@1100286009 :
        MeasurementLinPiecewProd: Record 7207390;
        //       MeasureLinePieceworkCertif@1100286010 :
        MeasureLinePieceworkCertif: Record 7207343;
    begin
        //JAV 21/09/20: - QB 1.06.15 Incrementar medici�n de coste y/o de venta

        //Leo proyecto y unidad de obra
        if not recJob.GET(JobNo) then
            exit;
        if not DataPieceworkForProduction2.GET(JobNo, PieceworkNo) then
            exit;

        //Para coste: Guardo la cantidad en la medici�n de coste inicial, modifico la medici�n de coste de la u.o y ajusta las mediciones detalladas
        if (bCost) then begin
            DataPieceworkForProduction2.VALIDATE("Initial Measure");
            DataPieceworkForProduction2.SETFILTER("Budget Filter", recJob."Current Piecework Budget");
            DataPieceworkForProduction2.VALIDATE("Measure Budg. Piecework Sol", NewMeasure);
            DataPieceworkForProduction2.MODIFY;
            //-Q17698
            MeasurementLinPiecewProd.ParamRV(Rec, TRUE);
            //+Q17698

            MeasurementLinPiecewProd.AdjustTo("Job No.", "Piecework No.", recJob."Current Piecework Budget", NewMeasure);
        end;

        //Para venta: Guardo la cantidad en la medici�n de venta inicial, modifico la medici�n de venta de la u.o. y ajusta las mediciones detalladas
        if (bSale) then begin
            if (DataPieceworkForProduction2."Initial Sale Measurement" = 0) then  //Guardo la inicial si est� a cero
                DataPieceworkForProduction2."Initial Sale Measurement" := DataPieceworkForProduction2."Sale Quantity (base)";
            DataPieceworkForProduction2.VALIDATE("Budget Measure", NewMeasure);
            DataPieceworkForProduction2.VALIDATE("Sale Quantity (base)", NewMeasure);
            DataPieceworkForProduction2.MODIFY;
            //-Q17698
            MeasurementLinPiecewProd.ParamRV(Rec, TRUE); //Pasar la RV
                                                         //+Q17698

            MeasureLinePieceworkCertif.AdjustTo("Job No.", "Piecework No.", recJob."Current Piecework Budget", NewMeasure);
        end;

        //JAV 04/08/20: - Pongo el precio de venta en las unidades de coste cuando hay separaci�n coste-venta
        // if (DataPieceworkForProduction2."Production Unit") and (not DataPieceworkForProduction2."Customer Certification Unit") then begin
        //  DataPieceworkForProduction2.VALIDATE("Contract Price", DataPieceworkForProduction2.ProductionPrice);
        //  DataPieceworkForProduction2.MODIFY;
        // end;

        //Recalcular el presupuesto de esta u.o.
        if (bCost) or (bSale) then begin
            if (not JobBudget.GET(recJob."No.", recJob."Current Piecework Budget")) then
                ERROR(Text010);

            CLEAR(RateBudgetsbyPiecework);
            RateBudgetsbyPiecework.SetDataPiecework(DataPieceworkForProduction."Piecework Code", bNotSeeDialog, TRUE);
            RateBudgetsbyPiecework.ValueInitialization(recJob, JobBudget);
        end;
    end;

    LOCAL procedure AddMeasureLines()
    var
        //       DecSuma@1100286000 :
        DecSuma: Decimal;
    begin
        if ("Line No." = 0) or ("From Measure") then
            exit;

        //Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV. -
        //salimos porque ya se crean por c�digo en cd.7207274
        if ("Cancel Line") then
            exit;
        //Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV. +

        //Creamos las l�neas si no existen
        MeasureLinesBillofItem.SETRANGE("Document Type", MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
        if (MeasureLinesBillofItem.ISEMPTY) then
            LinesBillOfItemMeasuring;  //A�adir mediciones detalladas


        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
        //{
        //      //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
        //
        //      //Actualizamos el % de avance
        //      MeasureLinesBillofItem.RESET;
        //      MeasureLinesBillofItem.SETRANGE("Document Type",MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        //      MeasureLinesBillofItem.SETRANGE("Document No.","Document No.");
        //      MeasureLinesBillofItem.SETRANGE("Line No.","Line No.");
        //      if (MeasureLinesBillofItem.FINDSET(TRUE)) then
        //        repeat
        //          MeasureLinesBillofItem.VALIDATE("Measured % Progress","% Progress To Source");
        //          MeasureLinesBillofItem.MODIFY;
        //        until MeasureLinesBillofItem.NEXT = 0;
        //
        //      //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
        //      }
        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +


        //-Q17698 AML Cuando hay l�neas de medici�n


        //{
        //      MeasureLinesBillofItem.RESET;
        //      MeasureLinesBillofItem.SETRANGE("Document Type",MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        //      MeasureLinesBillofItem.SETRANGE("Document No.","Document No.");
        //      MeasureLinesBillofItem.SETRANGE("Line No.","Line No.");
        //      if (MeasureLinesBillofItem.FINDSET(TRUE)) then
        //        repeat
        //          MeasureLinesBillofItem.VALIDATE("Measured % Progress","% Progress To Source");
        //          MeasureLinesBillofItem.MODIFY;
        //        until MeasureLinesBillofItem.NEXT = 0;
        //        }
    end;

    procedure PercentageLines()
    begin
        //-Q17698 AML Mejoras en la actualizacion de lineas de medici�n en RV
        MeasureLinesBillofItem.RESET;
        MeasureLinesBillofItem.SETRANGE("Document Type", MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
        if (MeasureLinesBillofItem.FINDSET(TRUE)) then
            repeat
                MeasureLinesBillofItem.VALIDATE("Measured % Progress", "% Progress To Source");
                MeasureLinesBillofItem.MODIFY;
            until MeasureLinesBillofItem.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 26/03/19: - Se cambian los caption de los campos "Prod. Amount To Source" y "Realized Measure"
//                    - Se hace la medicion pendiente no editable
//      JAV 02/04/19: - Mejoras en mediciones: Se puede introducir importes a origen o del periodo indiferentemente. Se calcula el % de avance a origen al calcular el importe de la l�nea
//      JAV 04/04/19: - Se a�aden los campos de Precio Contrato e Importe contrato, y su c�lculo
//      JAV 05/04/19: - Si el precio de venta queda a cero, calcularlo sobre lo producido o usar el de contrato
//      JAV 26/07/19: - Se cambia el caption de algunos campos para que informe de forma mas apropiada
//      JAV 09/10/20: - QB 1.06.20 Se a�ade la columna del c�digo adicional y se buscan datos en el validate de los c�digos de Presto y el adicional
//      PSM 03/06/21: - QB 1.08.48 Redondear Sales Price seg�n Currency."Unit-Amount Rounding Precision"y no Currency."Amount Rounding Precision"
//      PSM-JMMA 26/08/21: - QB 1.09.17 Modificar c�lculo de precio a aplicar a la medici�n a origen
//      JAV 15/09/21: - QB 1.09.17 Se ponen 2:6 decimales en "PEM Price", "PEM Price Old", "PEC Price",
//      JAV 24/06/22: - QB 1.10.53 Se cambian los campos "PEC xxx" por "COST xxx" que es mas apropiado y se eliminan los campos "PEM xxx" que no se utilizan pasandolos a "OLD_xxx"
//                                 Se a�aden campos para ver el precio real a PEC, junto a los importes
//      JAV 30/06/22: - QB 1.10.57 Estaban intercambiados PEM y PEC
//      CPA 30/08/22 Q17919. Optimizaci�n
//            Cambio en la Calcf�rmula del campo "No. Measurement" para a�adir filtro por Document Type
//      Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.
//      Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV.
//      AML 06/06/23  - Q17698 Correcci�n de la manipulaci�n del avance por l�neas de medici�n.
//    }
    end.
  */
}








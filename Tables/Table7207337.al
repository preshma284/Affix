table 7207337 "QBU Measurement Lines"
{


    CaptionML = ENU = 'Measurement Lines', ESP = 'L�neas medici�n';
    PasteIsValid = false;
    LookupPageID = "Measurement Lines Subform.";
    DrillDownPageID = "Measurement Lines Subform.";

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
                                                                                                                         "Account Type" = CONST("Unit"),
                                                                                                                         "Customer Certification Unit" = CONST(true));


            CaptionML = ENU = 'Piecework No.', ESP = 'N� unidad de obra';

            trigger OnValidate();
            BEGIN
                GetMasterHeader;

                DataPieceworkForProduction.GET(MeasurementHeader."Job No.", "Piecework No.");
                IF (DataPieceworkForProduction."Account Type" <> DataPieceworkForProduction."Account Type"::Unit) THEN
                    ERROR(Text006);
                "Piecework No." := DataPieceworkForProduction."Piecework Code";
                "Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";

                IF (MeasurementHeader."Document Type" = MeasurementHeader."Document Type"::Measuring) THEN BEGIN
                    MeasurementLines.SETRANGE("Document No.", "Document No.");
                    MeasurementLines.SETRANGE("Piecework No.", "Piecework No.");
                    MeasurementLines.SETFILTER("Line No.", '<>%1', "Line No.");
                    IF (NOT MeasurementLines.ISEMPTY) THEN
                        ERROR(Text009, "Piecework No.", "Document No.");
                END;

                tempMeasurementLines := Rec;
                INIT;
                "Document No." := MeasurementHeader."No.";
                "Document type" := MeasurementHeader."Document Type";
                "Piecework No." := tempMeasurementLines."Piecework No.";
                IF "Piecework No." = '' THEN
                    EXIT;

                "Currency Code" := MeasurementHeader."Currency Code";
                "Shortcut Dimension 1 Code" := MeasurementHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := MeasurementHeader."Shortcut Dimension 2 Code";


                DataPieceworkForProduction.GET(MeasurementHeader."Job No.", "Piecework No.");
                DataPieceworkForProduction.TESTFIELD(Blocked, FALSE);

                VALIDATE(Description, DataPieceworkForProduction.Description);
                "Contract Price" := DataPieceworkForProduction."Unit Price Sale (base)";
                "Sales Price" := DataPieceworkForProduction."Contract Price";
                "Last Price Redetermined" := DataPieceworkForProduction."Last Unit Price Redetermined";

                CreateDim(DATABASE::"Data Cost By Piecework Cert.", DataPieceworkForProduction."Unique Code");

                HistMeasureLines.SETRANGE("Job No.", "Job No.");
                HistMeasureLines.SETRANGE("Piecework No.", "Piecework No.");
                DecSumHistMeas := 0;
                IF HistMeasureLines.FINDSET THEN
                    REPEAT
                        DecSumHistMeas += HistMeasureLines."Med. Term Measure";
                    UNTIL HistMeasureLines.NEXT = 0;

                "Med. Pending Measurement" := DataPieceworkForProduction."Sale Quantity (base)" - DecSumHistMeas;

                //JMMA 18/04/20: C�digo para traer mediciones de cert. en proyectos con separaci�n
                Job.GET(Rec."Job No.");
                IF Job."Separation Job Unit/Cert. Unit" THEN BEGIN
                    VALIDATE("Med. Source Measure", DecSumHistMeas);
                    RelCertProd.RESET;
                    RelCertProd.SETRANGE("Job No.", Rec."Job No.");
                    RelCertProd.SETRANGE("Certification Unit Code", Rec."Piecework No.");
                    IF RelCertProd.FINDFIRST THEN
                        REPEAT
                            TotalMeasure := 0;
                            Advance := 0;
                            performedMeasure := 0;
                            CertMeasure := 0;
                            GetMasterHeader;
                            datapieceworkProd.RESET;
                            datapieceworkProd.SETRANGE("Job No.", Rec."Job No.");
                            datapieceworkProd.SETRANGE("Piecework Code", RelCertProd."Production Unit Code");
                            datapieceworkProd.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                            IF datapieceworkProd.FINDFIRST THEN;
                            datapieceworkProd.CALCFIELDS("Measure Budg. Piecework Sol");
                            TotalMeasure := datapieceworkProd."Measure Budg. Piecework Sol";
                            datapieceworkProd.SETFILTER("Filter Date", '..%1', MeasurementHeader."Posting Date");
                            IF datapieceworkProd.FINDFIRST THEN;
                            datapieceworkProd.CALCFIELDS("Total Measurement Production");
                            performedMeasure := datapieceworkProd."Total Measurement Production";
                            IF TotalMeasure <> 0 THEN
                                Advance := (performedMeasure / TotalMeasure);
                            datapieceworkCert.RESET;
                            IF datapieceworkCert.GET("Job No.", RelCertProd."Certification Unit Code") THEN;
                            CertMeasure := datapieceworkCert."Sale Quantity (base)" * Advance * (RelCertProd."Percentage Of Assignment") / 100;
                        //Rec.VALIDATE("Source Measure",Rec."Source Measure"+CertMeasure;

                        UNTIL RelCertProd.NEXT = 0;
                END ELSE BEGIN
                    TotalMeasure := 0;
                    Advance := 0;
                    performedMeasure := 0;
                    CertMeasure := 0;
                    GetMasterHeader;
                    datapieceworkProd.RESET;
                    datapieceworkProd.SETRANGE("Job No.", Rec."Job No.");
                    datapieceworkProd.SETRANGE("Piecework Code", Rec."Piecework No.");
                    datapieceworkProd.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                    IF datapieceworkProd.FINDFIRST THEN;
                    datapieceworkProd.CALCFIELDS("Measure Budg. Piecework Sol");
                    TotalMeasure := datapieceworkProd."Measure Budg. Piecework Sol";
                    datapieceworkProd.SETFILTER("Filter Date", '..%1', MeasurementHeader."Posting Date");
                    IF datapieceworkProd.FINDFIRST THEN;
                    datapieceworkProd.CALCFIELDS("Total Measurement Production");
                    performedMeasure := datapieceworkProd."Total Measurement Production";
                    IF TotalMeasure <> 0 THEN
                        Advance := (performedMeasure / TotalMeasure);
                    datapieceworkCert.RESET;
                    IF datapieceworkCert.GET("Job No.", Rec."Piecework No.") THEN;
                    CertMeasure := datapieceworkCert."Sale Quantity (base)" * Advance;
                END;
                //JMMA 18/04/20 --

                AddMeasurementLines;

                //Pongo el importe a origen
                DataPieceworkForProduction.GET("Job No.", "Piecework No.");
                DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements");
                VALIDATE("Med. Source Measure", DataPieceworkForProduction."Quantity in Measurements");

                //JAV 25/01/22: - QB 1.10.14 Guardar el expediente asociado a la l�nea
                Rec.Record := DataPieceworkForProduction."No. Record";
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

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


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
            DecimalPlaces = 2 : 4;
            Description = 'Precio PEC';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //CalculateAmounts;  //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. se comenta l�nea.
                CalculateAmounts(FALSE); //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.
            END;


        }
        field(12; "OLD_Certificated Quantity"; Decimal)
        {
            CaptionML = ENU = 'Certificated Amount', ESP = 'Cantidad certificada';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa';


        }
        field(13; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                CreateDim(DATABASE::Job, "Job No.");

                IF Job.GET("Job No.") THEN BEGIN
                    IF JobPostingGroup.GET(Job."Job Posting Group") THEN BEGIN
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN
                            ValidateShortcutDimCode(1, JobPostingGroup."Sales Analytic Concept");
                            VALIDATE("Shortcut Dimension 1 Code", JobPostingGroup."Sales Analytic Concept");
                        END;
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN BEGIN
                            ValidateShortcutDimCode(2, JobPostingGroup."Sales Analytic Concept");
                            VALIDATE("Shortcut Dimension 2 Code", JobPostingGroup."Sales Analytic Concept");
                        END;
                    END;
                END;
            END;


        }
        field(15; "OLD_Quantity Measure Not Cert"; Decimal)
        {
            CaptionML = ENU = 'Amount Measure Not Certified', ESP = 'Cantidad medida no certif';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(17; "Sales Price"; Decimal)
        {


            CaptionML = ENU = 'Precio Contrato', ESP = 'Precio E.M.';
            DecimalPlaces = 2 : 4;
            Description = 'Precio PEM';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 29/03/21: - QB 1.08.20 El precio ser� editable si es una medici�n de ajuste de precios
                GetMasterHeader;
                IF (MeasurementHeader."Document Type" = MeasurementHeader."Document Type"::Measuring) AND (MeasurementHeader."Certification Type" = MeasurementHeader."Certification Type"::"Price adjustment") THEN BEGIN
                    Job.GET("Job No.");
                    Currency.InitRoundingPrecision;
                    "Contract Price" := "Sales Price" * (1 + (Job."General Expenses / Other" / 100) + (Job."Industrial Benefit" / 100)) * (1 - (Job."Low Coefficient" / 100));
                    "Contract Price" := ROUND("Contract Price", Currency."Unit-Amount Rounding Precision");
                    //CalculateAmounts;  //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.  se comenta l�nea.
                    CalculateAmounts(FALSE);  //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.
                END ELSE
                    ERROR(Text005);
            END;


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
            CalcFormula = Lookup("Measurement Header"."Posting Date" WHERE("No." = FIELD("Document No.")));
            CaptionML = ESP = 'Fecha Registro';
            Description = 'QB 1.08.42 - JAV 18/05/21 Obtiene la fecha de la cabecera';


        }
        field(20; "Adjustment Redeterm. Prices"; Decimal)
        {
            CaptionML = ENU = 'Adjustment Redeterm. Prices', ESP = 'Ajuste Redeterminacion Precios';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(21; "OLD_Certification Amount(base)"; Decimal)
        {
            CaptionML = ENU = 'Certification Amount (base)', ESP = 'Importe Periodo PEC redeterminado';
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
        field(25; "OLD_Certification Type"; Option)
        {
            OptionMembers = "Normal","Price adjustment";
            FieldClass = FlowField;
            CalcFormula = Lookup("Hist. Measurements"."Certification Type" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Certification Type', ESP = 'Tipo de certificaci�n';
            OptionCaptionML = ENU = 'Normal,Price adjustment', ESP = 'Normal,Ajuste precios';

            Description = '### ELIMINAR ###no se usa';
            Editable = false;


        }
        field(26; "Document type"; Enum "Sales Line Type")
        {
            //OptionMembers = "Measuring","Certification";
            CaptionML = ENU = 'Document type', ESP = 'Tipo documento';
            //OptionCaptionML = ENU = 'Measuring,Certification', ESP = 'Medici�n,Certificaci�n';

            Editable = false;


        }
        field(28; "Med. Source Measure"; Decimal)
        {


            CaptionML = ENU = 'Source Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;
            Description = 'Cantidad Origen';

            trigger OnValidate();
            BEGIN
                IF ("Med. Source Measure" < 0) THEN
                    ERROR('La medici�n a origen no puede ser negativa');

                DataPieceworkForProduction.GET("Job No.", "Piecework No.");
                DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements");
                SetPrecision;
                "Med. Source Measure" := ROUND("Med. Source Measure", Precision);
                "Med. Term Measure" := ROUND("Med. Source Measure" - DataPieceworkForProduction."Quantity in Measurements", Precision);
                //JAV 13/04/21 - Intento divisi�n por cero
                IF (DataPieceworkForProduction."Sale Quantity (base)" <> 0) THEN
                    "Med. % Measure" := ("Med. Source Measure" * 100 / DataPieceworkForProduction."Sale Quantity (base)")
                ELSE
                    "Med. % Measure" := 0;

                IF "Document type" = "Document type"::Measuring THEN
                    CalcRealizedMeasurement;

                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.  -
                //{
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
                //                                                                CalculateAmounts;
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //                                                                }

                IF (CurrFieldNo = FIELDNO("Med. Source Measure")) OR (CurrFieldNo = FIELDNO("Med. Term Measure")) OR (CurrFieldNo = FIELDNO("Med. % Measure")) THEN
                    CalculateAmounts(TRUE)
                ELSE
                    CalculateAmounts(FALSE);
                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +

                VALIDATE("From Measure", FALSE);  //Si se ha tocado la medici�n ya no proviene de la detallada
            END;


        }
        field(29; "Med. Term Measure"; Decimal)
        {


            CaptionML = ENU = 'Medicion periodo', ESP = 'Medici�n per�odo';
            DecimalPlaces = 2 : 4;
            Description = 'Cantidad Periodo';

            trigger OnValidate();
            BEGIN
                DataPieceworkForProduction.GET("Job No.", "Piecework No.");
                DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements");
                VALIDATE("Med. Source Measure", DataPieceworkForProduction."Quantity in Measurements" + "Med. Term Measure");
            END;


        }
        field(31; "OLD_Quantity to Certificate"; Decimal)
        {
            CaptionML = ENU = 'Cantidad a certificar', ESP = 'Cantidad a certificar';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### Pasa a los campos 202-203';


        }
        field(34; "OLD_Measurement No."; Code[20])
        {
            CaptionML = ENU = 'No. medicion', ESP = 'N� medici�n';
            Description = '### ELIMINAR ### Pasa a los campos 202-203';
            Editable = false;


        }
        field(35; "Med. Measured Quantity"; Decimal)
        {
            CaptionML = ENU = 'Cantidad medida', ESP = 'Cantidad medida';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(36; "Med. Pending Measurement"; Decimal)
        {
            CaptionML = ENU = 'Medicion pendiente', ESP = 'Medici�n pendiente';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(37; "OLD_Item Type"; Option)
        {
            OptionMembers = " ","General","Low";
            CaptionML = ENU = 'Item Type', ESP = 'Tipo de partida';
            OptionCaptionML = ENU = '" ,General,Low"', ESP = '" ,General,Baja"';

            Description = '### ELIMINAR ### No se usa';


        }
        field(39; "Med. % Measure"; Decimal)
        {


            CaptionML = ENU = '% de medicion', ESP = '% de medici�n';
            DecimalPlaces = 2 : 6;

            trigger OnValidate();
            BEGIN
                DataPieceworkForProduction.GET("Job No.", "Piecework No.");
                VALIDATE("Med. Source Measure", DataPieceworkForProduction."Sale Quantity (base)" * "Med. % Measure" / 100);
            END;


        }
        field(40; "OLD_% On Executing"; Decimal)
        {
            CaptionML = ENU = '% Over Execution', ESP = '% sobre ejecuci�n';
            DecimalPlaces = 2 : 6;
            Description = '### ELIMINAR ### No se usa';


        }
        field(41; "OLD_% Quantity to Certificate"; Decimal)
        {
            CaptionML = ENU = '% de avance a origen', ESP = '% medido a certificar';
            DecimalPlaces = 2 : 6;
            Description = '### ELIMINAR ### Pasa al campo 204';


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
            CalcFormula = Count("Measure Lines Bill of Item" WHERE("Document Type" = FILTER("Measuring"),
                                                                                                         "Document No." = FIELD("Document No."),
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
        field(80; "Document Filter"; Code[20])
        {
            FieldClass = FlowFilter;


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
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';


        }
        field(108; "OLD_Calculated Prod. Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Calculated Production Measure', ESP = 'Medici�n Producci�n Calculada';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### No se usa';


        }
        field(109; "Med. Term PEM Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Periodo PEM';
            Description = 'Importe PEM del periodo                               JAV 04/04/19: - Se incluyen los campos para realizar el c�lculo del importe correcto';
            Editable = false;


        }
        field(111; "Med. Source PEM Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification Amount (base)', ESP = 'Imp. Origen a PEM';
            Description = 'Importe PEM a origen de Mediciones';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(112; "Med. Source PEC Amount"; Decimal)
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
        field(200; "Cert Medition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Medici�n Certificada';
            Editable = false;


        }
        field(201; "Cert Medition Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea Medici�n Certificada';
            Editable = false;


        }
        field(202; "Cert Pend. Medition Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n Pte. del periodo';
            Editable = false;


        }
        field(203; "Cert Pend. Medition Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n a origen';
            Description = 'JAV 22/03/21 Se cambia el caption';
            Editable = false;


        }
        field(204; "Cert % to Certificate"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de medicion', ESP = '% a certificar';
            DecimalPlaces = 2 : 6;
            MinValue = -100;
            MaxValue = 100;

            trigger OnValidate();
            BEGIN
                SetPrecision;
                "Cert Quantity to Term" := ROUND("Cert Pend. Medition Term" * "Cert % to Certificate" / 100, Precision);
                "Cert Quantity to Origin" := ROUND("Cert Pend. Medition Origin" * "Cert % to Certificate" / 100, Precision);

                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //{
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
                //                                                                CalculateAmounts;
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //                                                                }

                IF CurrFieldNo = FIELDNO("Cert % to Certificate") THEN
                    CalculateAmounts(TRUE)
                ELSE
                    CalculateAmounts(FALSE);
                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
            END;


        }
        field(205; "Cert Quantity to Term"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cantidad a certificar', ESP = 'Cantidad a certificar periodo';
            DecimalPlaces = 2 : 4;

            trigger OnValidate();
            BEGIN
                IF (("Cert Quantity to Term" > 0) AND ("Cert Quantity to Term" > "Cert Pend. Medition Term")) OR
                   (("Cert Quantity to Term" < 0) AND ("Cert Quantity to Term" < "Cert Pend. Medition Term")) THEN
                    ERROR('No puede certificar mas de lo medido en el periodo (%1) ni menos de cero', "Cert Pend. Medition Term");

                SetPrecision;
                "Cert Quantity to Term" := ROUND("Cert Quantity to Term", Precision);
                "Cert Quantity to Origin" := ROUND("Cert Pend. Medition Origin" - "Cert Pend. Medition Term" + "Cert Quantity to Term", Precision);

                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //{
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
                //                                                                CalculateAmounts;
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //                                                                }

                IF CurrFieldNo = FIELDNO("Cert Quantity to Term") THEN
                    CalculateAmounts(TRUE)
                ELSE
                    CalculateAmounts(FALSE);
                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
            END;


        }
        field(206; "Cert Quantity to Origin"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cantidad a certificar', ESP = 'Cantidad a certificar Origen';
            DecimalPlaces = 2 : 4;

            trigger OnValidate();
            BEGIN
                SetPrecision;
                "Cert Quantity to Origin" := ROUND("Cert Quantity to Origin", Precision);
                "Cert Quantity to Term" := "Cert Pend. Medition Term" - "Cert Pend. Medition Origin" + "Cert Quantity to Origin";

                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //{
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
                //                                                                CalculateAmounts;
                //                                                                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
                //                                                                }

                IF CurrFieldNo = FIELDNO("Cert Quantity to Origin") THEN
                    CalculateAmounts(TRUE)
                ELSE
                    CalculateAmounts(FALSE);
                //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
            END;


        }
        field(207; "Cert Term PEM amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe periodo a PEM';
            Editable = false;


        }
        field(208; "Cert Term PEC amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe periodo a PEC';
            Editable = false;


        }
        field(209; "Cert Term RED amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe periodo a P.Redeterminaci�n';
            Editable = false;


        }
        field(210; "Cert Source PEM amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a PEM';
            Editable = false;


        }
        field(211; "Cert Source PEC amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a PEC';
            Editable = false;


        }
        field(212; "Cert Source RED amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a P.Redeterminaci�n';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Med. Term PEC Amount", "Med. Term PEM Amount";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       MeasurementHeader@7001100 :
        MeasurementHeader: Record 7207336;
        //       MeasurementLines@1100286006 :
        MeasurementLines: Record 7207337;
        //       tempMeasurementLines@1100286008 :
        tempMeasurementLines: Record 7207337;
        //       Currency@7001101 :
        Currency: Record 4;
        //       MeasureLinesBillofItem@7001104 :
        MeasureLinesBillofItem: Record 7207395;
        //       Text000@7001105 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text001@1100286003 :
        Text001: TextConst ENU = 'Price adjust Certification Lines cannot be deleted', ESP = 'No se pueden borrar lineas de una certificaci�n de ajuste de precios';
        //       Text002@1100286004 :
        Text002: TextConst ESP = 'El proyecto es de medici�n abierta y ha sobrepasado la medici�n de certificaci�n, �desea ampliarla?';
        //       Text003@1100286005 :
        Text003: TextConst ESP = 'El proyecto es de medici�n abierta y ha sobrepasado la medici�n de certificaci�n, �desea ampliar todas las mediciones?';
        //       Text005@1100286013 :
        Text005: TextConst ESP = 'No pude modificar el precio en este formulario, c�mbielo desde la unidad de obra.';
        //       Text009@7001107 :
        Text009: TextConst ENU = 'Piecework %1 already exists for document %2', ESP = 'Ya existe la unidad de obra %1 para el documento %2';
        //       HistMeasureLines@7001112 :
        HistMeasureLines: Record 7207339;
        //       Job@1100286011 :
        Job: Record 167;
        //       JobPostingGroup@1100286010 :
        JobPostingGroup: Record 208;
        //       DataPieceworkForProduction@1100286009 :
        DataPieceworkForProduction: Record 7207386;
        //       DimMgt@7001113 :
        DimMgt: Codeunit "DimensionManagement";
        //       Text010@7001114 :
        Text010: TextConst ENU = 'Entered Measurement is lower than realized measurement', ESP = 'La medici�n introducida es inferior a la medici�n realizada';
        //       Text004@7001115 :
        Text004: TextConst ENU = 'Measurement defined for Piecework %1 has been exceeded', ESP = 'Se ha excedido de la medici�n definida para la Unidad de obra:  %1';
        //       Text008@7001116 :
        Text008: TextConst ENU = 'Amount to Certificate for Piecework %1 has been exceeded', ESP = 'Se ha excedido  en la cantidad a certificar para la Unidad de obra:  %1';
        //       FunctionQB@7001119 :
        FunctionQB: Codeunit 7207272;
        //       Text006@7001121 :
        Text006: TextConst ENU = 'You can not take either chapters or subcapitules, you can only take matches.', ESP = 'No se puede coger ni capitulos ni subcapitulos, solo se puede coger partidas.';
        //       DecSumHistMeas@1100286012 :
        DecSumHistMeas: Decimal;
        //       LineNo@1100286007 :
        LineNo: Integer;
        //       Precision@1100286014 :
        Precision: Decimal;
        //       "-------------- para proyectos con separaci�n"@1000000000 :
        "-------------- para proyectos con separación": Integer;
        //       RelCertProd@1000000007 :
        RelCertProd: Record 7207397;
        //       datapieceworkProd@1000000006 :
        datapieceworkProd: Record 7207386;
        //       datapieceworkCert@1000000005 :
        datapieceworkCert: Record 7207386;
        //       TotalMeasure@1000000004 :
        TotalMeasure: Decimal;
        //       performedMeasure@1000000003 :
        performedMeasure: Decimal;
        //       Advance@1000000002 :
        Advance: Decimal;
        //       CertMeasure@1000000001 :
        CertMeasure: Decimal;
        //       SaltarMessages@1100286000 :
        SaltarMessages: Boolean;
        //       SaltarTodosMensajes@1100286001 :
        SaltarTodosMensajes: Boolean;
        //       NoPreguntar@1100286002 :
        NoPreguntar: Boolean;



    trigger OnInsert();
    begin
        LOCKTABLE;
        MeasurementHeader.GET("Document No.");
        "Job No." := MeasurementHeader."Job No.";

        AddMeasurementLines;
    end;

    trigger OnModify();
    begin
        if xRec."Piecework No." <> "Piecework No." then
            AddMeasurementLines;
    end;

    trigger OnDelete();
    begin
        GetMasterHeader;
        if (MeasurementHeader."Document Type" = MeasurementHeader."Document Type"::Certification) and
           (MeasurementHeader."Certification Type" = MeasurementHeader."Certification Type"::"Price adjustment") then
            ERROR(Text001);

        MeasureLinesBillofItem.SETRANGE("Document Type", "Document type");
        MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
        MeasureLinesBillofItem.DELETEALL
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure AddMeasurementLines()
    var
        //       locrecManagementLineofMeasure@1100229000 :
        locrecManagementLineofMeasure: Codeunit 7207292;
        //       Qty@1100000 :
        Qty: Decimal;
    begin
        //A�ade las l�neas de medicion a la U.O.
        if "Document type" <> "Document type"::Measuring then
            exit;

        Job.GET(Rec."Job No.");

        GetMasterHeader;
        MeasureLinesBillofItem.SETRANGE("Document Type", "Document type");
        MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
        MeasureLinesBillofItem.DELETEALL;

        locrecManagementLineofMeasure.GetLineDescMeasureOrder(MeasurementHeader."Job No.", "Piecework No.", "Document type",
                                                              "Document No.", "Line No.", Job."Current Piecework Budget");
    end;

    LOCAL procedure GetMasterHeader()
    begin

        TESTFIELD("Document No.");

        if "Document No." <> MeasurementHeader."No." then begin
            MeasurementHeader.GET("Document No.");
            if MeasurementHeader."Currency Code" = '' then begin

            end else begin
                MeasurementHeader.TESTFIELD("Currency Factor");
                Currency.GET(MeasurementHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;

        MeasurementHeader.TESTFIELD("Job No.");
        "Document No." := MeasurementHeader."No.";
        "Job No." := MeasurementHeader."Job No.";
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure CalculateAmounts (UpdateMeditions@1100286000 :
    procedure CalculateAmounts(UpdateMeditions: Boolean)
    begin
        //se incluye nuevo par�metro UpdateMeditions.   //Q19159 CSM 04/05/23.

        GetMasterHeader;
        Currency.InitRoundingPrecision;
        CASE "Document type" OF
            "Document type"::Measuring:
                begin
                    //JAV 21/02/21: - C�lculo del importe a PEM
                    "Med. Term PEM Amount" := ROUND("Med. Term Measure" * "Sales Price", Currency."Amount Rounding Precision");

                    //JMMA modificado para cuadrar con produccci�n Amount := "Term Measure" * "Last Price Redetermined";
                    "Med. Term PEC Amount" := ROUND("Med. Term Measure" * "Contract Price", Currency."Amount Rounding Precision");
                    "Adjustment Redeterm. Prices" := 0;

                    //JAV 25/03/21: - C�lculo de los importes a PEM/PEC modificado  para que tome a origen sumando anterior + periodo, as� absorve las diferencias de precios.
                    //CALCFIELDS("Med. Anterior PEM amount", "Med. Anterior PEC amount");
                    //"Med. Source PEM Amount" := ROUND("Med. Term PEM Amount" + "Med. Anterior PEM amount", Currency."Amount Rounding Precision");
                    //"Med. Source PEC Amount" := ROUND("Med. Term PEC Amount" + "Med. Anterior PEC amount", Currency."Amount Rounding Precision");


                    //JAV 15/09/21: - QB 1.09.20 Nueva forma de hacer los c�lculos          222
                    // Importes a Origen: medici�n a origen por precio.
                    "Med. Source PEM Amount" := ROUND("Med. Source Measure" * "Sales Price", Currency."Amount Rounding Precision");
                    "Med. Source PEC Amount" := ROUND("Med. Source Measure" * "Contract Price", Currency."Amount Rounding Precision");
                    //Importes del periodo: Origen - Anterior.
                    CALCFIELDS("Med. Anterior PEM amount", "Med. Anterior PEC amount");
                    "Med. Term PEM Amount" := ROUND("Med. Source PEM Amount" - "Med. Anterior PEM amount", Currency."Amount Rounding Precision");
                    "Med. Term PEC Amount" := ROUND("Med. Source PEC Amount" - "Med. Anterior PEC amount", Currency."Amount Rounding Precision");
                    //Precios del periodo: Importe / Cantidad
                    if ("Med. Term Measure" <> 0) then begin
                        "Term PEM Price" := ROUND("Med. Term PEM Amount" / "Med. Term Measure", 0.000001);
                        "Term PEC Price" := ROUND("Med. Term PEC Amount" / "Med. Term Measure", 0.000001);
                    end else begin
                        "Term PEM Price" := 0;
                        "Term PEC Price" := 0;
                    end;
                end;
            "Document type"::Certification:
                begin
                    //JAV 28/09/21: - QB 1.09.20 Nueva forma de hacer los c�lculos          222
                    //Calculo el nuevo porcentaje
                    if ("Cert Quantity to Term" = "Cert Quantity to Origin") and ("Cert Quantity to Term" <> 0) then
                        "Cert % to Certificate" := ROUND("Cert Quantity to Term" * 100 / "Cert Pend. Medition Term", 0.000001)
                    else if ("Cert Quantity to Origin" <> 0) then
                        "Cert % to Certificate" := ROUND("Cert Quantity to Origin" * 100 / "Cert Pend. Medition Origin", 0.000001)
                    else
                        "Cert % to Certificate" := 0;

                    if ("Cert Pend. Medition Term" = 0) and ("Med. Term PEM Amount" <> 0) then begin
                        //Q19632 AML No se debe informar si no hay pendiente.
                        //"Cert Term PEM amount" := ROUND("Med. Term PEM Amount" * "Cert % to Certificate" / 100, Currency."Amount Rounding Precision");
                        //"Cert Term PEC amount" := ROUND("Med. Term PEC Amount" * "Cert % to Certificate" / 100, Currency."Amount Rounding Precision");
                        "Cert Term PEM amount" := 0;
                        "Cert Term PEC amount" := 0;
                        //Q19632
                        "Cert Term RED amount" := 0;
                    end else begin
                        "Cert Term PEM amount" := ROUND("Cert Quantity to Term" * "Term PEM Price", Currency."Amount Rounding Precision");
                        "Cert Term PEC amount" := ROUND("Cert Quantity to Term" * "Term PEC Price", Currency."Amount Rounding Precision");
                        "Cert Term RED amount" := ROUND("Cert Quantity to Term" * "Last Price Redetermined", Currency."Amount Rounding Precision");
                    end;

                    if ("Cert Pend. Medition Origin" = 0) and ("Med. Source PEM Amount" <> 0) then begin
                        "Cert Source PEM amount" := ROUND("Med. Source PEM Amount" * "Cert % to Certificate" / 100, Currency."Amount Rounding Precision");
                        "Cert Source PEC amount" := ROUND("Med. Source PEC Amount" * "Cert % to Certificate" / 100, Currency."Amount Rounding Precision");
                        "Cert Source RED amount" := 0;
                    end else begin
                        "Cert Source PEM amount" := ROUND("Cert Quantity to Origin" * "Sales Price", Currency."Amount Rounding Precision");
                        "Cert Source PEC amount" := ROUND("Cert Quantity to Origin" * "Contract Price", Currency."Amount Rounding Precision");
                        "Cert Source RED amount" := ROUND("Cert Quantity to Origin" * "Last Price Redetermined", Currency."Amount Rounding Precision");
                    end;

                    if MeasurementHeader."Certification Type" = MeasurementHeader."Certification Type"::Normal then
                        "Adjustment Redeterm. Prices" := "Cert Term RED amount" - "Cert Term PEC amount"
                    else
                        "Adjustment Redeterm. Prices" := "Last Price Redetermined" - "Previous Redetermined Price";
                end;
        end;

        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
        if (UpdateMeditions) then begin
            //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +

            //JAV 22/07/20: - Actualiza las l�neas de medici�n con el porcentaje
            if ("Document type" = "Document type"::Measuring) and (not "From Measure") then begin
                MeasureLinesBillofItem.RESET;
                MeasureLinesBillofItem.SETRANGE("Document Type", "Document type");
                MeasureLinesBillofItem.SETRANGE("Document No.", "Document No.");
                MeasureLinesBillofItem.SETRANGE("Line No.", "Line No.");
                if (MeasureLinesBillofItem.FINDSET(TRUE)) then
                    repeat
                        MeasureLinesBillofItem.VALIDATE("Measured % Progress", "Med. % Measure");
                        MeasureLinesBillofItem.MODIFY;
                    until MeasureLinesBillofItem.NEXT = 0;
            end;

            //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
        end;
        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
    end;

    procedure CalcRealizedMeasurement()
    begin
        GetMasterHeader;
        if DataPieceworkForProduction.GET(MeasurementHeader."Job No.", "Piecework No.") then begin
            DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements", "Budget Measure");
            //if recUOMeasureCert."Number Of Measurements" <> 0 then
            if DataPieceworkForProduction."Sale Quantity (base)" <> 0 then
                "Med. % Measure" := ROUND("Med. Source Measure" * 100 / DataPieceworkForProduction."Sale Quantity (base)", 0.01)
            else
                "Med. % Measure" := 100;
            if (not SaltarMessages) and ("Med. Source Measure" < DataPieceworkForProduction."Quantity in Measurements") then
                MESSAGE(Text010);

            SaltarMessages := FALSE;

            //JAV 27/01/19: - Se unifica en una funci�n el verificar si estamos sobrepasados y es posible hacerlo.
            ValidateMaxQuantity;
        end;
    end;

    procedure CalcRealizedMeasurementFromPercMeasure()
    begin
        GetMasterHeader;
        if DataPieceworkForProduction.GET(MeasurementHeader."Job No.", "Piecework No.") then begin
            DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements", "Budget Measure");
            if (not SaltarMessages) and ("Med. Source Measure" < DataPieceworkForProduction."Quantity in Measurements") then
                MESSAGE(Text010);

            SaltarMessages := FALSE;

            //JAV 27/01/19: - Se unifica en una funci�n el v erificar si estamos sobrepasados y es posible hacerlo.
            ValidateMaxQuantity;
            "Med. Term Measure" := "Med. Source Measure" - DataPieceworkForProduction."Quantity in Measurements";
        end;
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
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
        GetMasterHeader;

        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        GetMasterHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Measurements and Certif.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            MeasurementHeader."Dimension Set ID", DATABASE::Vendor);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ShowDimensions()
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Document type", "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    LOCAL procedure ValidateMaxQuantity()
    var
        //       bOK@1100286000 :
        bOK: Boolean;
    begin
        //JAV 27/01/20: - Si el proyecto es de medici�n abierta, preguntamos si ajustamos la medici�n
        GetMasterHeader;
        if (not DataPieceworkForProduction.GET(MeasurementHeader."Job No.", "Piecework No.")) then
            exit;

        if (ABS("Med. Source Measure") > ABS(DataPieceworkForProduction."Sale Quantity (base)")) then begin
            if Job.GET("Job No.") then begin
                if (Job."Sales Medition Type" = Job."Sales Medition Type"::open) then begin
                    //JAV 17/11/20: - QB 1.07.06 Seg�n est� marcado saltarse todos los mensajes sin preguntar, hacer una u otra pregunta
                    if (not SaltarTodosMensajes) then
                        bOK := CONFIRM(Text002, TRUE)
                    else if (not NoPreguntar) then begin
                        NoPreguntar := CONFIRM(Text003, FALSE);
                        if (not NoPreguntar) then
                            ERROR('');
                    end;
                    if (NoPreguntar) or (bOK) then begin
                        if (DataPieceworkForProduction."Initial Sale Measurement" = 0) then
                            DataPieceworkForProduction."Initial Sale Measurement" := DataPieceworkForProduction."Sale Quantity (base)";
                        DataPieceworkForProduction."Sale Quantity (base)" := "Med. Source Measure";
                        DataPieceworkForProduction.MODIFY;
                        "Med. % Measure" := 100;
                    end;
                end;
            end;
        end;

        //JMMA: Si el proyecto es llave en mano, solo permitir exceso de medici�n en certificaci�n si se indica que se desea hacerlo as� en la U.O.
        if ABS("Med. Source Measure") > ABS(DataPieceworkForProduction."Sale Quantity (base)") then begin
            if not DataPieceworkForProduction."Allow Over Measure" then
                ERROR(Text004, "Piecework No.")
        end;
    end;

    //     procedure SetSkipMessages (pMessages@1100286000 :
    procedure SetSkipMessages(pMessages: Boolean)
    begin
        SaltarMessages := pMessages;
    end;

    //     procedure SetSkipAllMessages (pMessages@1100286000 :
    procedure SetSkipAllMessages(pMessages: Boolean)
    begin
        //JAV 17/11/20: - QB 1.07.06 Si hay que saltarse todos los mensajes sin preguntar
        SaltarTodosMensajes := pMessages;
        NoPreguntar := FALSE;
    end;

    LOCAL procedure SetPrecision()
    begin
        Precision := 0.0001;
    end;

    procedure HavePriceChanged(): Boolean;
    var
        //       PriceChanged@1100286000 :
        PriceChanged: Boolean;
    begin
        exit(("Term PEM Price" <> "Sales Price") or ("Term PEC Price" <> "Contract Price") or (("Term PEM Price" = 0) and ("Med. Term PEM Amount" <> 0)));
    end;

    /*begin
    //{
//      JAV 15/10/19: - Se eliminan los campos 14 "Measure Date" y 32 "Certification Date" de las l�neas de medici�n que no se usan
//      JAV 27/01/20: - Si el proyecto es de medici�n abierta, preguntamos si ajustamos la medici�n
//      CPA 30/08/22 Q17919. Optimizaci�n
//            Cambio en la Calcf�rmula del campo "No. Measurement" para a�adir filtro por Document Type
//      Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.
//      Q19632 AML 09/06/23 Correccion de certificaciones parciales.
//    }
    end.
  */
}








table 7206967 "QBU Service Order Lines"
{


    CaptionML = ENU = 'Service Order Lines', ESP = 'L�neas Pedido Servicio';
    PasteIsValid = false;
    LookupPageID = "QB Service Order Subform";
    DrillDownPageID = "QB Service Order Subform";

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

            trigger OnValidate();
            BEGIN
                GetMasterHeader;
                "Currency Code" := QBServiceOrderHeader."Currency Code";
                VALIDATE("Shortcut Dimension 1 Code", QBServiceOrderHeader."Shortcut Dimension 1 Code");
                VALIDATE("Shortcut Dimension 2 Code", QBServiceOrderHeader."Shortcut Dimension 2 Code");
                "Document No." := QBServiceOrderHeader."No.";
                recUOMeasureCert.GET(QBServiceOrderHeader."Job No.", "Piecework No.");

                IF NOT recDataPieceworkForProduction.GET(QBServiceOrderHeader."Job No.", "Piecework No.") THEN
                    recDataPieceworkForProduction.INIT
                ELSE BEGIN
                    recDataPieceworkForProduction.TESTFIELD(Blocked, FALSE);
                    VALIDATE(Description, recDataPieceworkForProduction.Description);
                    //SE COMENTA PREGUNTAR
                    //"Item Type":=recDataPieceworkForProduction."Item Type";
                    //"% On Executing":=recDataPieceworkForProduction."% On Executing";
                    recUOMeasureCert.RESET;
                    recUOMeasureCert.SETRANGE("Job No.", "Job No.");
                    recUOMeasureCert.SETRANGE("Piecework Code", "Piecework No.");
                    IF recUOMeasureCert.FINDFIRST THEN
                        "Sale Price (base)" := recUOMeasureCert."Unit Price Sale (base)";
                    "Contract Price" := recUOMeasureCert."Contract Price";
                END;

                recUOMeasureCert.GET(QBServiceOrderHeader."Job No.", "Piecework No.");
                //SE COMENTA. PREGUNTAR
                //CreateDim(DATABASE::"Data Piecework Meas. And Cert.",recUOMeasureCert."Unique Code");

                DataPieceworkForProduction.GET("Job No.", "Piecework No.");
                IF DataPieceworkForProduction."Account Type" <> DataPieceworkForProduction."Account Type"::Unit THEN
                    ERROR(Text006);
                "Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";
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
        field(11; "Sale Price (base)"; Decimal)
        {


            CaptionML = ENU = 'Sale Price', ESP = 'Precio venta';
            CaptionClass = '7206910,7206967,11';

            trigger OnValidate();
            BEGIN
                CalcAmounts;
            END;


        }
        field(13; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                CreateDim(DATABASE::Job, "Job No.");

                IF recJob.GET("Job No.") THEN BEGIN
                    IF recJobPostingGroup.GET(recJob."Job Posting Group") THEN BEGIN
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN
                            ValidateShortcutDimCode(1, recJobPostingGroup."Sales Analytic Concept");
                            VALIDATE("Shortcut Dimension 1 Code", recJobPostingGroup."Sales Analytic Concept");
                        END;
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN BEGIN
                            ValidateShortcutDimCode(2, recJobPostingGroup."Sales Analytic Concept");
                            VALIDATE("Shortcut Dimension 2 Code", recJobPostingGroup."Sales Analytic Concept");
                        END;
                    END;
                END;
            END;


        }
        field(17; "Contract Price"; Decimal)
        {
            CaptionML = ENU = 'Precio Contrato', ESP = 'Precio Contrato';
            Editable = false;
            CaptionClass = '7206910,7206967,17';


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


            CaptionML = ENU = 'Medicion periodo', ESP = 'Cantidad';

            trigger OnValidate();
            BEGIN
                CalcAmounts;
            END;


        }
        field(32; "Service Date"; Date)
        {
            CaptionML = ENU = 'Fecha certificacion', ESP = 'Fecha del Servicio';


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {


            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';

            trigger OnValidate();
            BEGIN
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", Rec."Job No.");
                DataPieceworkForProduction.SETRANGE("Code Piecework PRESTO", "Code Piecework PRESTO");
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    IF DataPieceworkForProduction."Account Type" <> DataPieceworkForProduction."Account Type"::Unit THEN
                        ERROR(Text006);

                    IF "Job No." = '' THEN BEGIN
                        GetMasterHeader;
                        "Job No." := QBServiceOrderHeader."Job No.";
                    END;

                    VALIDATE("Piecework No.", DataPieceworkForProduction."Piecework Code");

                END;
            END;

            trigger OnLookup();
            BEGIN
                GetMasterHeader;
                recUOMeasureCert.FILTERGROUP := 2;
                recUOMeasureCert.RESET;
                recUOMeasureCert.SETRANGE("Job No.", QBServiceOrderHeader."Job No.");
                recUOMeasureCert.SETRANGE("Customer Certification Unit", TRUE);
                recUOMeasureCert.FILTERGROUP := 0;
                IF PAGE.RUNMODAL(0, recUOMeasureCert) = ACTION::LookupOK THEN BEGIN
                    "Job No." := QBServiceOrderHeader."Job No.";
                    VALIDATE("Piecework No.", recUOMeasureCert."Piecework Code");
                END;
            END;


        }
        field(50002; "Cost Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Execution Price', ESP = 'Importe coste';
            Description = 'Q5767';
            Editable = false;
            CaptionClass = '7206910,7206967,50002';


        }
        field(50003; "Sale Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Adjudication Price', ESP = 'Importe venta';
            Description = 'Q5767';
            Editable = false;
            CaptionClass = '7206910,7206967,50003';


        }
        field(50004; "Profit"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amt. Adjudication Coeficient', ESP = 'Resultado';
            Description = 'Q5767';
            Editable = false;
            CaptionClass = '7206910,7206967,50004';


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
        //       Text50000@7001103 :
        Text50000: TextConst ENU = 'Price adjust Certification Lines cannot be deleted', ESP = 'No se pueden borrar lineas de una certificaci�n de ajuste de precios';
        //       Text000@7001105 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text009@7001107 :
        Text009: TextConst ENU = 'Piecework %1 already exists for document %2', ESP = 'Ya existe la unidad de obra %1 para el documento %2', ESN = 'Ya existe la unidad de obra %1 para el documento %2';
        //       Text010@7001114 :
        Text010: TextConst ENU = 'Entered Measurement is lower than realized measurement', ESP = 'La medici�n introducida es inferior a la medici�n realizada', ESN = 'La medici�n introducida es inferior a la medici�n realizada';
        //       Text004@7001115 :
        Text004: TextConst ENU = 'Measurement defined for Piecework %1 has been exceeded', ESP = 'Se ha excedido de la medici�n definida para la Unidad de obra:  %1';
        //       Text008@7001116 :
        Text008: TextConst ENU = 'Amount to Certificate for Piecework %1 has been exceeded', ESN = 'Se ha excedido  en la cantidad a certificar para la Unidad de obra:  %1';
        //       Text006@7001121 :
        Text006: TextConst ENU = 'You can not take either chapters or subcapitules, you can only take matches.', ESP = 'No se puede coger ni capitulos ni subcapitulos, solo se puede coger partidas.';
        //       QBServiceOrderHeader@1100286008 :
        QBServiceOrderHeader: Record 7206966;
        //       Currency@1100286007 :
        Currency: Record 4;
        //       recUOMeasureCert@1100286006 :
        recUOMeasureCert: Record 7207386;
        //       recDataPieceworkForProduction@1100286005 :
        recDataPieceworkForProduction: Record 7207386;
        //       recJob@1100286003 :
        recJob: Record 167;
        //       recJobPostingGroup@1100286002 :
        recJobPostingGroup: Record 208;
        //       DataPieceworkForProduction@1100286001 :
        DataPieceworkForProduction: Record 7207386;
        //       DimMgt@1100286010 :
        DimMgt: Codeunit "DimensionManagement";
        //       FunctionQB@1100286009 :
        FunctionQB: Codeunit 7207272;
        //       DecSumHistMeas@1100286011 :
        DecSumHistMeas: Decimal;



    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetMasterHeader()
    begin

        TESTFIELD("Document No.");

        if "Document No." <> QBServiceOrderHeader."No." then begin
            QBServiceOrderHeader.GET("Document No.");
            if QBServiceOrderHeader."Currency Code" = '' then begin
                Currency.InitRoundingPrecision;
            end else begin
                QBServiceOrderHeader.TESTFIELD("Currency Factor");
                Currency.GET(QBServiceOrderHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;

        QBServiceOrderHeader.TESTFIELD("Job No.");
        "Document No." := QBServiceOrderHeader."No.";
        "Job No." := QBServiceOrderHeader."Job No.";
        "Service Date" := QBServiceOrderHeader."Service Date";
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
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
            QBServiceOrderHeader."Dimension Set ID", DATABASE::Vendor);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ShowDimensions()
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure CalcAmounts()
    begin
        GetMasterHeader;
        "Price review percentage" := QBServiceOrderHeader."Price review percentage";

        "Cost Amount" := ROUND(Quantity * "Contract Price", 0.01);
        "Sale Amount" := ROUND(Quantity * "Sale Price (base)", 0.01);
        Profit := "Sale Amount" - "Cost Amount";

        "Sale Price With Price review" := ROUND("Sale Price (base)" + ("Sale Price (base)" * "Price review percentage" / 100), 0.01);
        "Sale Amount With Price review" := ROUND(Quantity * "Sale Price With Price review", 0.01);
    end;

    /*begin
    end.
  */
}








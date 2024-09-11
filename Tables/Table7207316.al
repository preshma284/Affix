table 7207316 "QBU Reestimation Lines"
{


    LookupPageID = "Reestimation Lines Subform.";
    DrillDownPageID = "Reestimation Lines Subform.";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Editable = false;

            trigger OnValidate();
            BEGIN
                CreateDim(DATABASE::Job, "Job No.");
            END;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;
            AutoFormatExpression = "G/L Account";


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
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';
            Editable = false;


        }
        field(10; "G/L Account"; Text[20])
        {
            TableRelation = "G/L Account";


            CaptionML = ENU = 'G/L Account', ESP = 'N� cuenta';

            trigger OnLookup();
            VAR
                //                                                               DimensionValue@7001100 :
                DimensionValue: Record 349;
                //                                                               GLAccount@7001101 :
                GLAccount: Record 15;
            BEGIN
                DimensionValue.GET('CA', "Analytical concept");
                IF DimensionValue.Type = DimensionValue.Type::Expenses
                  THEN BEGIN
                    GLAccount.FILTERGROUP(0);
                    GLAccount.SETFILTER("No.", '%1..%2', '6', '69999999');
                    GLAccount.FILTERGROUP(2);
                    IF PAGE.RUNMODAL(0, GLAccount) = ACTION::LookupOK THEN
                        VALIDATE("G/L Account", GLAccount."No.");
                END;

                DimensionValue.GET('CA', "Analytical concept");
                IF DimensionValue.Type = DimensionValue.Type::Income
                  THEN BEGIN
                    GLAccount.FILTERGROUP(0);
                    GLAccount.SETFILTER("No.", '%1..%2', '7', '79999999');
                    GLAccount.FILTERGROUP(2);
                    IF PAGE.RUNMODAL(0, DimensionValue) = ACTION::LookupOK THEN
                        VALIDATE("G/L Account", GLAccount."No.");
                END;
            END;


        }
        field(11; "Budget amount"; Decimal)
        {
            CaptionML = ENU = 'Budget amount', ESP = 'Importe presupuesto';
            Editable = false;


        }
        field(12; "Realized Amount"; Decimal)
        {
            CaptionML = ENU = 'Realized Amount', ESP = 'Importe realizado';
            Editable = false;


        }
        field(13; "Realized Excess"; Decimal)
        {
            CaptionML = ENU = 'Realized Excess', ESP = 'Exceso de realizado';
            Editable = false;


        }
        field(14; "Estimated outstanding amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Mov. Budget Forecast"."Outstanding Temporary Forecast" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                  "Document No." = FIELD("Document No."),
                                                                                                                                  "Line No." = FIELD("Line No."),
                                                                                                                                  "Anality Concept Code" = FIELD("Analytical concept"),
                                                                                                                                  "Reestimation code" = FIELD("Reestimation code"),
                                                                                                                                  "Forecast Date" = FIELD("Date filter")));
            CaptionML = ENU = 'Estimated outstanding amount', ESP = 'Importe pendiente estimado';


        }
        field(15; "Total amount to estimated orig"; Decimal)
        {
            CaptionML = ENU = 'Total amount to estimated origin', ESP = 'Importe total a origen estim.';
            Editable = false;


        }
        field(16; "Analytical concept"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Analytical concept', ESP = 'Concepto anal�tico';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 FunctionQB@7001100 :
                FunctionQB: Codeunit 7207272;
                //                                                                 DimensionManagement@7001101 :
                DimensionManagement: Codeunit "DimensionManagement";
            BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, "Analytical concept", "Dimension Set ID");
                DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 2 Code", "Currency Code");
            END;

            trigger OnLookup();
            VAR
                //                                                               FunctionQB@7001100 :
                FunctionQB: Codeunit 7207272;
            BEGIN
                IF FunctionQB.LookUpCA("Analytical concept", FALSE) THEN
                    VALIDATE("Analytical concept");
            END;


        }
        field(17; "Date filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date filter', ESP = 'Filtro fecha';


        }
        field(18; "Type"; Option)
        {
            OptionMembers = "Expenses","Income";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Expenses,Income', ESP = 'Gastos,Ingresos';

            Editable = false;


        }
        field(19; "Reestimation Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Reestimation Code', ESP = 'C�d. reestimaci�n';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 DimensionManagement@7001101 :
                DimensionManagement: Codeunit "DimensionManagement";
            BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimReest, "Reestimation Code", "Dimension Set ID");
                DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 2 Code", "Currency Code");
            END;

            trigger OnLookup();
            VAR
                //                                                               FunctionQB@7001100 :
                FunctionQB: Codeunit 7207272;
                //                                                               DimensionValue@7001101 :
                DimensionValue: Record 349;
            BEGIN
                IF FunctionQB.LookUpReest(DimensionValue."Dimension Code", FALSE) THEN
                    VALIDATE("Reestimation Code", DimensionValue."Dimension Code");
            END;


        }
        field(20; "Assigned %"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Mov. Budget Forecast"."Assigned %" WHERE("Job No." = FIELD("Job No."),
                                                                                                              "Document No." = FIELD("Document No."),
                                                                                                              "Line No." = FIELD("Line No."),
                                                                                                              "Anality Concept Code" = FIELD("Analytical concept"),
                                                                                                              "Reestimation code" = FIELD("Reestimation code"),
                                                                                                              "Forecast Date" = FIELD("Date filter")));
            CaptionML = ENU = 'Assigned %', ESP = '% asignado';
            MinValue = 0;
            MaxValue = 100;


        }
        field(21; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount";
            Clustered = true;
        }
        key(key2; "Document No.", "Type")
        {
            SumIndexFields = "Total amount to estimated orig";
        }
    }
    fieldgroups
    {
    }

    var
        //       Text000@7001100 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       ReestimationHeader@7001101 :
        ReestimationHeader: Record 7207315;
        //       FunctionQB@7001102 :
        FunctionQB: Codeunit 7207272;



    trigger OnInsert();
    begin
        LOCKTABLE;
        ReestimationHeader."No." := '';
    end;

    trigger OnDelete();
    var
        //                MovBudgetForecast@7001100 :
        MovBudgetForecast: Record 7207319;
    begin
        MovBudgetForecast.RESET;
        MovBudgetForecast.SETRANGE("Document No.", "Document No.");
        MovBudgetForecast.SETRANGE("Line No.", "Line No.");
        MovBudgetForecast.DELETEALL(TRUE);
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetMaestraHeader()
    begin
        //Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");
        if "Document No." <> ReestimationHeader."No." then
            ReestimationHeader.GET("Document No.");

        //VALIDATE("Job No.",ReestimationHeader."Job No.");
        VALIDATE("Reestimation Code", ReestimationHeader."Reestimation Code");
    end;

    procedure ShowDimensions()
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       ReestimationHeader@7001101 :
        ReestimationHeader: Record 7207315;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        GetMaestraHeader;

        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup.Reestimation, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            ReestimationHeader."Dimension Set ID", DATABASE::Job);
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        //Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        //Busca el valor de las dimensiones por defecto
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        //Funci�n para el capti�n de la tabla, es lo que mostrar� el formulario
        Field.GET(DATABASE::"Reestimation Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    LOCAL procedure GetGLSetup()
    var
        //       GLSetupRead@7001100 :
        GLSetupRead: Boolean;
        //       GeneralLedgerSetup@7001101 :
        GeneralLedgerSetup: Record 98;
    begin
        if not GLSetupRead then
            GeneralLedgerSetup.GET;
        GLSetupRead := TRUE;
    end;

    procedure CalcTotalAmount(): Decimal;
    begin
        "Total amount to estimated orig" := "Realized Amount" + "Estimated outstanding amount";
        exit("Total amount to estimated orig");
    end;

    /*begin
    end.
  */
}








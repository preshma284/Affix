table 7207321 "Expense Notes Lines"
{


    LinkedObject = false;
    CaptionML = ENU = 'Expense Notes Lines', ESP = 'Lineas notas gastos';
    PasteIsValid = false;
    LookupPageID = "Expense Notes Lines Subform";
    DrillDownPageID = "Expense Notes Lines Subform";

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
        field(3; "No. Job Unit"; Text[30])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));


            CaptionML = ENU = 'No. Job Unit', ESP = 'N� Unidad de Obra';

            trigger OnValidate();
            BEGIN
                tempExpenseNotesLines := Rec;
                "No. Job Unit" := tempExpenseNotesLines."No. Job Unit";

                IF "No. Job Unit" = '' THEN
                    EXIT;

                DataPieceworkForProduction.GET("Job No.", "No. Job Unit");
                IF DataPieceworkForProduction."Account Type" <> DataPieceworkForProduction."Account Type"::Unit THEN
                    ERROR(Text006);
            END;


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

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(8; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';

            trigger OnValidate();
            BEGIN
                VALIDATE(Quantity);
            END;


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                GetMaestraHeader;

                "Document No." := ExpenseNotesHeader."No.";
                //"Expense Date" := ExpenseNotesHeader."Expense Note Date";
                "Currency Code" := ExpenseNotesHeader."Currency Code";
                "Bal. Account Payment" := ExpenseNotesHeader."Bal. Account Code";
                "Bal. Account Type" := ExpenseNotesHeader."Bal. Account Type";
                CreateDim(DATABASE::Job, "Job No.");
                ProposeConcept;
            END;


        }
        field(10; "Expense Date"; Date)
        {
            CaptionML = ENU = 'Expense Date', ESP = 'Fecha de Gasto';


        }
        field(11; "Expense Concept"; Code[20])
        {
            TableRelation = "Expense Concept";


            CaptionML = ENU = 'Expense Concept', ESP = 'Concepto de Gasto';

            trigger OnValidate();
            BEGIN
                ProposeConcept;
            END;


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

            trigger OnValidate();
            BEGIN
                VALIDATE("Total Amount", (Quantity * "Price Cost"));
                VALIDATE("VAT Product Posting Group");
                GetMaestraHeader;

                IF WithholdingGroups.GET(WithholdingGroups."Withholding Type"::PIT, ExpenseNotesHeader."PIT Withholding Group") THEN
                    "PIT Percentage" := WithholdingGroups."Percentage Withholding";

                CalculateIRPF("PIT Percentage");
            END;


        }
        field(14; "Price Cost"; Decimal)
        {


            CaptionML = ENU = 'Price Cost', ESP = 'Precio Coste';

            trigger OnValidate();
            BEGIN
                VALIDATE("Total Amount", (Quantity * "Price Cost"));
                VALIDATE("VAT Product Posting Group");
                IF WithholdingGroups.GET(WithholdingGroups."Withholding Type"::PIT, ExpenseNotesHeader."PIT Withholding Group") THEN
                    "PIT Percentage" := WithholdingGroups."Percentage Withholding";

                CalculateIRPF("PIT Percentage");
            END;


        }
        field(15; "Total Amount"; Decimal)
        {


            CaptionML = ENU = 'Total Amount', ESP = 'Importe Total';

            trigger OnValidate();
            BEGIN
                Currency.InitRoundingPrecision;
                IF "Currency Code" <> '' THEN
                    "Total Amount (DL)" := ROUND(CurrencyExchangeRate.ExchangeAmtFCYToLCY("Expense Date", "Currency Code", "Total Amount", CurrencyExchangeRate.ExchangeRate("Expense Date", "Currency Code")), Currency."Amount Rounding Precision")
                ELSE
                    "Total Amount (DL)" := ROUND("Total Amount", Currency."Amount Rounding Precision");

                "Sales Amount" := "Total Amount (DL)";
            END;


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

            trigger OnValidate();
            BEGIN
                IF GLAcc.GET("Bal. Account Payment") THEN
                    VALIDATE("VAT Product Posting Group", GLAcc."VAT Prod. Posting Group");
            END;


        }
        field(20; "Withholding Amount (DL)"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount(LCY)', ESP = 'Importe Retencion(DL)';
            Editable = false;


        }
        field(21; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Vendor No', ESP = 'N� Proveedor';

            trigger OnValidate();
            BEGIN
                IF Vendor.GET("Vendor No.") THEN
                    VALIDATE("VAT Business Posting Group", Vendor."VAT Bus. Posting Group");
            END;


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

            trigger OnValidate();
            BEGIN
                IF VATPostingSetup.GET("VAT Business Posting Group", "VAT Product Posting Group") THEN
                    "Percentage VAT" := VATPostingSetup."VAT %";

                CalculateIVA("Percentage VAT");
                IF "VAT Product Posting Group" = '' THEN BEGIN
                    "Percentage VAT" := 0;
                    "VAT Amount" := 0;
                    "VAT Amount (DL)" := 0;
                END;
            END;


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

            trigger OnValidate();
            BEGIN
                Currency.RESET;
                CurrencyExchangeRate.RESET;
                Currency.InitRoundingPrecision;
                IF "Currency Code" <> '' THEN
                    "VAT Amount (DL)" :=
                      ROUND(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY("Expense Date", "Currency Code", "VAT Amount",
                         CurrencyExchangeRate.ExchangeRate("Expense Date", "Currency Code")), Currency."Amount Rounding Precision")
                ELSE
                    "VAT Amount (DL)" := ROUND("VAT Amount", Currency."Amount Rounding Precision");
            END;


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

            trigger OnValidate();
            BEGIN
                CalculateIRPF("PIT Percentage");
            END;


        }
        field(31; "Bal. Account Type"; Option)
        {
            OptionMembers = " ","Account","Bank";
            CaptionML = ENU = 'Bal.Account Type', ESP = 'Tipo Contrapartida';
            OptionCaptionML = ENU = '" ,Account,Bank"', ESP = '" ,Cuenta,Banco"';



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

            trigger OnValidate();
            BEGIN
                Currency.RESET;
                CurrencyExchangeRate.RESET;
                Currency.InitRoundingPrecision;
                IF "Currency Code" <> '' THEN
                    "Withholding Amount (DL)" :=
                      ROUND(
                        CurrencyExchangeRate.ExchangeAmtFCYToLCY("Expense Date", "Currency Code", "Withholding Amount",
                         CurrencyExchangeRate.ExchangeRate("Expense Date", "Currency Code")), Currency."Amount Rounding Precision")
                ELSE
                    "Withholding Amount (DL)" := ROUND("Withholding Amount", Currency."Amount Rounding Precision");
            END;


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
        //       ExpenseNotesHeader@1100286015 :
        ExpenseNotesHeader: Record 7207320;
        //       ExpenseNotesLines@1100286014 :
        ExpenseNotesLines: Record 7207321;
        //       Currency@1100286013 :
        Currency: Record 4;
        //       StdTxt@1100286012 :
        StdTxt: Record 7;
        //       GLSetup@1100286011 :
        GLSetup: Record 98;
        //       DimMgt@1100286010 :
        DimMgt: Codeunit "DimensionManagement";
        //       GLSetupRead@1100286009 :
        GLSetupRead: Boolean;
        //       JobDataUnitforProduction@1100286008 :
        JobDataUnitforProduction: Record 7207386;
        //       ExpenseConcept@1100286007 :
        ExpenseConcept: Record 7207325;
        //       cduFunVar@1100286006 :
        cduFunVar: Codeunit 7207272;
        //       WithholdingGroups@1100286005 :
        WithholdingGroups: Record 7207330;
        //       Vendor@1100286004 :
        Vendor: Record 23;
        //       VATPostingSetup@1100286003 :
        VATPostingSetup: Record 325;
        //       CurrencyExchangeRate@1100286002 :
        CurrencyExchangeRate: Record 330;
        //       GLAcc@1100286001 :
        GLAcc: Record 15;
        //       tempExpenseNotesLines@1100286000 :
        tempExpenseNotesLines: Record 7207321;
        //       text001@1100286018 :
        text001: TextConst ENU = 'You can''t change a validated document', ESP = 'No se puede modificar un parte validado';
        //       text002@1100286017 :
        text002: TextConst ENU = 'You can''t remove a validated document', ESP = 'No se puede eliminar un parte validado';
        //       Text000@1100286016 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text006@7001100 :
        Text006: TextConst ENU = 'You can not take either chapters or subcapitules, you can only take matches.', ESP = 'No se puede coger ni capitulos ni subcapitulos, solo se puede coger partidas.';
        //       DataPieceworkForProduction@7001101 :
        DataPieceworkForProduction: Record 7207386;



    trigger OnInsert();
    begin
        LOCKTABLE;
        ExpenseNotesHeader."No." := '';

        GetMaestraHeader;
        if ExpenseNotesHeader."Job No." <> '' then
            VALIDATE("Job No.", ExpenseNotesHeader."Job No.");
    end;

    trigger OnModify();
    begin
        GetMaestraHeader;
        if ExpenseNotesHeader."Validated Note" = TRUE then
            ERROR(text001);
    end;

    trigger OnDelete();
    begin
        GetMaestraHeader;
        if ExpenseNotesHeader."Validated Note" = TRUE then
            ERROR(text002);
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    procedure GetMaestraHeader()
    begin
        //Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");

        if "Document No." <> ExpenseNotesHeader."No." then begin
            ExpenseNotesHeader.GET("Document No.");

            if ExpenseNotesHeader."Currency Code" = '' then begin
                //Acciones a realizar si no hay doble divisa
            end else begin
                Currency.GET(ExpenseNotesHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    end;

    procedure ShowDimensions()
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No");
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No"));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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
        GetMaestraHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Expense Notes", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            ExpenseNotesHeader."Dimension Set ID", DATABASE::Job);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Busca el valor de las dimensiones por defecto
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ProposeConcept()
    begin
        if ExpenseConcept.GET("Expense Concept") then begin
            VALIDATE("Expense Account", ExpenseConcept."Expense Account");
            //VALIDATE("Currency Code",ExpenseConcept."Currency Code");
            VALIDATE("Price Cost", ExpenseConcept."Total Unit Price");
            VALIDATE(Description, ExpenseConcept.Description);
            if cduFunVar.GetPosDimensions(cduFunVar.ReturnDimCA) = 1 then
                VALIDATE("Shortcut Dimension 1 Code", ExpenseConcept."Analytical Concept")
            else
                VALIDATE("Shortcut Dimension 2 Code", ExpenseConcept."Analytical Concept");
        end;
    end;

    //     procedure CalculateIVA (PercentageIVA@1000000000 :
    procedure CalculateIVA(PercentageIVA: Decimal)
    begin
        if PercentageIVA <> 0 then
            VALIDATE("VAT Amount", (("Total Amount" * (1 + "Percentage VAT" / 100) - "Total Amount")))
        else
            VALIDATE("VAT Amount", 0);
    end;

    //     procedure CalculateIRPF (CodeIRPF@1000000000 :
    procedure CalculateIRPF(CodeIRPF: Decimal)
    begin
        if ExpenseConcept.GET("Expense Concept") then begin
            if CodeIRPF <> 0 then
                VALIDATE("Withholding Amount", ((Quantity * ExpenseConcept."Price Subject Withholding") * (CodeIRPF / 100)))
            else
                VALIDATE("Withholding Amount", 0);
        end else
            VALIDATE("Withholding Amount", 0);
    end;

    //     procedure CalcTotalAmounts (ExpenseNotesHeader@7001102 :
    procedure CalcTotalAmounts(ExpenseNotesHeader: Record 7207320): Decimal;
    var
        //       ExpenseNotesLines@7001104 :
        ExpenseNotesLines: Record 7207321;
        //       DataPricesVendor@7001100 :
        DataPricesVendor: Record 7207415;
        //       TotalAmounts@7001103 :
        TotalAmounts: Decimal;
    begin
        /*To be Tested*/
        // WITH ExpenseNotesLines DO begin
        ExpenseNotesLines.SETRANGE("Document No.", ExpenseNotesHeader."No.");
        if FINDSET then
            repeat
                TotalAmounts += "Total Amount";
            until NEXT = 0;
        // end;
        exit(TotalAmounts);
    end;

    /*begin
    end.
  */
}








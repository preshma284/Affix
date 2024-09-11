table 7207327 "Production Daily Line"
{


    CaptionML = ENU = 'Production Daily Line', ESP = 'Lin. diario producci�n';

    fields
    {
        field(1; "Daily Book Name"; Code[20])
        {
            TableRelation = "Daily Book Production";
            CaptionML = ENU = 'Daily Book Name', ESP = 'Nombre libro diario';
            Description = 'Key 1';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';
            Description = 'Key 2';


        }
        field(3; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Job Type" = FILTER(<> "Deviations"),
                                                                            "Blocked" = CONST(" "));


            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';

            trigger OnValidate();
            BEGIN
                IF "Job No." = '' THEN
                    EXIT;

                CreateDim(DATABASE::Job, "Job No.", DATABASE::"G/L Account", "G/L Account");

                Job.GET("Job No.");
                Job.TESTFIELD("Job Posting Group");
                JobPostingGroup.GET(Job."Job Posting Group");
                JobPostingGroup.TESTFIELD("Income Account Job in Progress");
                JobPostingGroup.TESTFIELD("CA Income Job in Progress");
                VALIDATE("G/L Account", JobPostingGroup."Income Account Job in Progress");
                VALIDATE("Currency Code", Job."Currency Code");

                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, JobPostingGroup."CA Income Job in Progress", "Dimension Set ID");
                DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

                VALIDATE("Document No.");
                CalculateProduction;
                Recalculate;
            END;


        }
        field(4; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                VALIDATE("Document No.");
                Recalculate;
            END;


        }
        field(5; "Document No."; Code[20])
        {


            CaptionML = ENU = 'Document No.', ESP = 'No. documento';

            trigger OnValidate();
            BEGIN
                IF ("Document No." = '') THEN BEGIN
                    IF DailyBookProduction.GET("Daily Book Name") THEN BEGIN
                        CLEAR(NoSeriesManagement);
                        "Document No." := NoSeriesManagement.TryGetNextNo(DailyBookProduction."Serie No.", "Posting Date");
                        //"Document No." := NoSeriesManagement.GetNextNo(DailyBookProduction."Serie No.","Posting Date",TRUE);
                    END;
                END;
            END;


        }
        field(6; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";


            CaptionML = ENU = 'G/L Account', ESP = 'No. cuenta';

            trigger OnValidate();
            BEGIN
                GLAccount.GET("G/L Account");

                "Gen. Bus. Posting Group" := GLAccount."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                Description := GLAccount.Name;

                CreateDim(DATABASE::Job, "Job No.", DATABASE::"G/L Account", "G/L Account");
            END;


        }
        field(7; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(10; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'Cod. origen';
            Editable = false;


        }
        field(12; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(13; "Gen. Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
            CaptionML = ENU = 'Gen. Bus. Posting Group', ESP = 'Grupo contable negocio';
            Description = 'JAV 24/01/22: - Se amplia de 10 a 20 para evitar error de longitud';


        }
        field(14; "Gen. Prod. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            CaptionML = ENU = 'Gen. Prod. Posting Group', ESP = 'Grupo contable producto';
            Description = 'JAV 24/01/22: - Se amplia de 10 a 20 para evitar error de longitud';


        }
        field(15; "Serie No."; Code[20])
        {
            CaptionML = ENU = 'Serie No.', ESP = 'No. serie';


        }
        field(16; "Posting Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Posting Serie No.', ESP = 'No. serie registro';


        }
        field(21; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';
            NotBlank = true;


        }
        field(22; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(30; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            CaptionML = ENU = 'Daily Section Name', ESP = 'Divisa';
            Editable = false;

            trigger OnValidate();
            BEGIN
                Recalculate;
            END;


        }
        field(31; "Currency Factor"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;

            trigger OnValidate();
            BEGIN
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE("Job in Progress");
            END;


        }
        field(32; "Previous WIP"; Decimal)
        {
            CaptionML = ENU = 'Production Accounting at Origi', ESP = 'WIP Anterior';
            Editable = false;


        }
        field(33; "Production Origin"; Decimal)
        {


            CaptionML = ENU = 'New Production at Origin', ESP = 'Producci�n a origen';

            trigger OnValidate();
            BEGIN
                //QBU17071 CSM 12/05/22 � C�lculo Obra en Curso. -
                //VALIDATE("Job in Progress", ROUND("Production Origin" - Invoiced - "Previous WIP" , Currency."Amount Rounding Precision"));

                //JAV 16/05/22: - QB 1.10.41 Al cambiar un dato calcular el contrario y en divisas
                "Job in Progress" := ROUND("Production Origin" - Invoiced - "Previous WIP", Currency."Amount Rounding Precision");
                Recalculate;
            END;


        }
        field(34; "Job in Progress"; Decimal)
        {


            CaptionML = ENU = 'Job in Progress', ESP = 'Obra en curso';

            trigger OnValidate();
            BEGIN
                //JAV 16/05/22: - QB 1.10.41 Al cambiar un dato calcular el contrario y en divisas
                "Production Origin" := ROUND("Job in Progress" + Invoiced + "Previous WIP", Currency."Amount Rounding Precision");
                Recalculate;
            END;


        }
        field(35; "Invoiced"; Decimal)
        {
            CaptionML = ENU = 'Invoiced', ESP = 'Facturado a Origen';
            Editable = false;


        }
        field(42; "Previous WIP (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Production Accounting at Origi', ESP = 'WIP Anterior (DL)';
            Editable = false;


        }
        field(43; "Production Origin (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'New Production at Origin', ESP = 'Producci�n a origen (DL)';
            Editable = false;


        }
        field(44; "Job in Progress (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job in Progress', ESP = 'Obra en curso (DL)';
            Editable = false;


        }
        field(45; "Invoiced (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Invoiced', ESP = 'Facturado a Origen (DL)';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Daily Book Name", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       DailyBookProduction@7001100 :
        DailyBookProduction: Record 7207326;
        //       DimensionManagement@7001102 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       Job@7001103 :
        Job: Record 167;
        //       JobPostingGroup@7001104 :
        JobPostingGroup: Record 208;
        //       Currency@1100286000 :
        Currency: Record 4;
        //       CurrExchRate@1100286001 :
        CurrExchRate: Record 330;
        //       FunctionQB@7001105 :
        FunctionQB: Codeunit 7207272;
        //       Text001@7001106 :
        Text001: TextConst ENU = 'You can not define the production for a job that its model of production calculation is ""Production= Invoiced"".', ESP = 'No puede definir la producci�n para un proyecto que su modelo de calculo de la producci�n es ""Producci�n=Facturaci�n"".';
        //       Text002@7001107 :
        Text002: TextConst ENU = 'You can not define the production for a job that its model of production calculation is "Without production".', ESP = 'No puede definir la producci�n para un proyecto que su modelo de calculo de la producci�n es "Sin producci�n".';
        //       GLAccount@7001108 :
        GLAccount: Record 15;
        //       NoSeriesManagement@7001109 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       TableID@1006 :
        TableID: ARRAY[10] OF Integer;
        //       No@1007 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(
            DefaultDimSource, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimensionManagement1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Daily Book Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     procedure SetUpNewLine (Book@1000 :
    procedure SetUpNewLine(Book: Code[20])
    var
        //       LastProductionDailyLine@1100286000 :
        LastProductionDailyLine: Record 7207327;
        //       LineNo@1100286001 :
        LineNo: Integer;
    begin
        DailyBookProduction.GET(Book);

        LastProductionDailyLine.RESET;
        LastProductionDailyLine.SETRANGE("Daily Book Name", Book);
        if (LastProductionDailyLine.FINDLAST) then
            LineNo := LastProductionDailyLine."Line No." + 10000
        else
            LineNo := 10000;

        INIT;
        "Line No." := LineNo;
        "Daily Book Name" := Book;
        "Source Code" := DailyBookProduction."Source Code";
        "Reason Code" := DailyBookProduction."Reason Code";
        "Posting Serie No." := DailyBookProduction."Posting Serie No.";

        if (not LastProductionDailyLine.ISEMPTY) then begin
            "Posting Date" := LastProductionDailyLine."Posting Date";
            "Document No." := LastProductionDailyLine."Document No.";
        end else begin
            "Posting Date" := WORKDATE;
            VALIDATE("Document No.");
        end;
    end;

    //     LOCAL procedure SetCurrencyCode (AccType2@1000 : 'G/L Account,Customer,Vendor,Bank Account';AccNo2@1001 :
    LOCAL procedure SetCurrencyCode(AccType2: Option "G/L Account","Customer","Vendor","Bank Account"; AccNo2: Code[20]): Boolean;
    var
        //       BankAcc@1002 :
        BankAcc: Record 270;
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
            if AccType2 = AccType2::"Bank Account" then
                if BankAcc.GET(AccNo2) then
                    "Currency Code" := BankAcc."Currency Code";
        exit("Currency Code" <> '');
    end;


    //     procedure SetCurrencyFactor (CurrencyCode@1000 : Code[10];CurrencyFactor@1001 :
    procedure SetCurrencyFactor(CurrencyCode: Code[10]; CurrencyFactor: Decimal)
    begin
        "Currency Code" := CurrencyCode;
        if "Currency Code" = '' then
            "Currency Factor" := 1
        else
            "Currency Factor" := CurrencyFactor;
    end;

    LOCAL procedure GetCurrency()
    begin
        if "Currency Code" = '' then begin
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        end else
            if "Currency Code" <> Currency.Code then begin
                Currency.GET("Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
    end;

    LOCAL procedure Recalculate()
    begin
        if ("Currency Code" <> '') then begin
            GetCurrency;
            "Currency Factor" := CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
        end else
            "Currency Factor" := 0;

        "Previous WIP" := ROUND("Previous WIP", Currency."Amount Rounding Precision");
        "Production Origin" := ROUND("Production Origin", Currency."Amount Rounding Precision");
        Invoiced := ROUND(Invoiced, Currency."Amount Rounding Precision");
        "Job in Progress" := ROUND("Job in Progress", Currency."Amount Rounding Precision");

        if "Currency Code" = '' then begin
            "Previous WIP (LCY)" := "Previous WIP";
            "Production Origin (LCY)" := "Production Origin";
            "Job in Progress (LCY)" := "Job in Progress";
            "Invoiced (LCY)" := Invoiced;
        end else begin
            "Previous WIP (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Previous WIP", "Currency Factor"));
            "Production Origin (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Production Origin", "Currency Factor"));
            "Job in Progress (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "Job in Progress", "Currency Factor"));
            "Invoiced (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", Invoiced, "Currency Factor"));
        end;
    end;

    LOCAL procedure "----------------------------"()
    begin
    end;

    procedure CalculateProduction()
    var
        //       LDataPieceworkForProduction@1100251000 :
        LDataPieceworkForProduction: Record 7207386;
        //       LProductionHadle@1100251001 :
        LProductionHadle: Decimal;
        //       AmBudgetCost@1100286000 :
        AmBudgetCost: Decimal;
        //       AmBudgetSale@1100286001 :
        AmBudgetSale: Decimal;
    begin
        Job.GET("Job No.");
        //JMMA 220221 No debe tener -1 debe calcular todo a fecha de registro
        //Job.SETRANGE("Posting Date Filter",0D,"Posting Date"-1);
        Job.SETRANGE("Posting Date Filter", 0D, "Posting Date");

        Job.SETRANGE("Job Sales Doc Type Filter", Job."Job Sales Doc Type Filter"::Standar);
        Job.CALCFIELDS("Invoiced (JC)", "Job in Progress (JC)", "Usage (Cost) (JC)", "Usage (Price) (LCY)");

        //JMMA
        Job.SETRANGE("Budget Filter", Job."Current Piecework Budget");
        Job.CALCFIELDS("Direct Cost Amount PW (JC)", "Indirect Cost Amount PW (JC)", "Amou Piecework Meas./Certifi.");

        Invoiced := Job."Invoiced (JC)";
        "Previous WIP" := Job."Job in Progress (JC)";

        CASE Job."Production Calculate Mode" OF
            Job."Production Calculate Mode"::"Lump Sums":                 //TANTO ALZADO coste+margen fin de proyecto.
                begin
                    AmBudgetCost := Job."Direct Cost Amount PieceWork" + Job."Indirect Cost Amount Piecework";
                    AmBudgetSale := Job."Amou Piecework Meas./Certifi.";
                    if AmBudgetCost <> 0 then begin
                        "Production Origin" := ROUND((Job."Usage (Cost) (JC)" / AmBudgetCost) * (AmBudgetSale));
                    end else begin
                        if (AmBudgetSale <> 0) and ((Job.Status = Job.Status::Completed) or (Job.Blocked <> Job.Blocked::" ")) then
                            "Production Origin" := AmBudgetSale
                        else
                            "Production Origin" := 0;
                    end;
                    VALIDATE("Production Origin");
                end;
            Job."Production Calculate Mode"::"Production by Piecework":   //Producci�n por Unidad de Obra
                begin
                    LProductionHadle := 0;
                    LDataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
                    LDataPieceworkForProduction.SETRANGE("Filter Date", 0D, "Posting Date");
                    LDataPieceworkForProduction.SETRANGE("Account Type", LDataPieceworkForProduction."Account Type"::Unit);
                    if LDataPieceworkForProduction.FINDSET then
                        repeat
                            LDataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                            LProductionHadle += ROUND(LDataPieceworkForProduction."Amount Production Performed" * LDataPieceworkForProduction."% Processed Production" / 100, 0.01);
                        until LDataPieceworkForProduction.NEXT = 0;
                    VALIDATE("Production Origin", LProductionHadle);
                end;
            Job."Production Calculate Mode"::Administration:              //Producci�n por administraci�n
                begin
                    VALIDATE("Production Origin", Job."Usage (Price) (LCY)");
                end;
            Job."Production Calculate Mode"::"Production=Invoicing":      //Producci�n = Facturaci�n
                begin
                    ERROR(Text001);
                end;
            Job."Production Calculate Mode"::Free:                        //Libre
                begin
                    VALIDATE("Production Origin", Job."Invoiced (JC)" + Job."Job in Progress (JC)");
                end;
            Job."Production Calculate Mode"::"Without Production":        //Sin Producci�n
                begin
                    ERROR(Text002);
                end;
        end;

        "Job in Progress" := ROUND("Production Origin" - Invoiced - "Previous WIP", Currency."Amount Rounding Precision");
    end;

    /*begin
    //{
//      CSM 12/05/22: - QB 1.10.41 (QBU17071) C�lculo Obra en Curso.
//      JAV 16/05/22: - QB 1.10.41  Al cambiar un dato calcular el contrario y en divisas
//    }
    end.
  */
}








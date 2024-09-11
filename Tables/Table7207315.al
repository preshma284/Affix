table 7207315 "QBU Reestimation Header"
{


    LookupPageID = "Reestimation List";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Job Type" = FILTER("Operative"),
                                                                            "Status" = FILTER(<> "Planning"));


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                GetMaestra("Job No.");

                IF Job.Status = Job.Status::Completed THEN
                    ERROR(Text004);

                IF Job."Management By Production Unit" THEN
                    ERROR(Text005);

                IF "Reestimation Code" <> '' THEN BEGIN
                    IF ("Job No." <> xRec."Job No.") AND ("Job No." <> '') THEN BEGIN
                        IF ThereAreLines THEN BEGIN
                            ChangeFieldName := FIELDNAME("Job No.");
                            UpdateLines;
                        END;
                        ChargeCA;
                    END;
                END;

                Description := Job.Description;
                "Description 2" := Job."Description 2";

                Job.ControlJob(Job);

                CreateDim(DATABASE::Job, "Job No.");
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnLookup();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesManagement.TestManual(GetNoSeriesCode);
                    "Series No." := '';
                END;
            END;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(5; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(6; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 1 Code");
                MODIFY;
            END;


        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(10; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(11; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Reestimation"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(12; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Reestimation Lines"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "Series No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Series No.', ESP = 'N� serie';
            Editable = false;


        }
        field(15; "Posting Series No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting Series No.', ESP = 'N� serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting Series No." <> '' THEN BEGIN
                    QuoBuildingSetup.GET;
                    TestNoSeries;
                    NoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting Series No.");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH ReestimationHeader DO BEGIN
                ReestimationHeader := Rec;
                QuoBuildingSetup.GET;
                TestNoSeries;
                IF NoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting Series No.") THEN
                    VALIDATE("Posting Series No.");

                Rec := ReestimationHeader;
                // END;
            END;


        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(17; "Reestimation Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Reestimation Code', ESP = 'C�d. reestimaci�n';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateReest("Reestimation Code");

                IF "Job No." <> '' THEN BEGIN
                    IF ("Reestimation Code" <> xRec."Reestimation Code") AND ("Reestimation Code" <> '') THEN BEGIN
                        ValidateCorrectReest;
                        IF ThereAreLines THEN BEGIN
                            ChangeFieldName := FIELDNAME("Reestimation Code");
                            UpdateLines;
                        END;
                        IF DimensionValue.GET(FunctionQB.ReturnDimReest, "Reestimation Code") THEN BEGIN
                            DimensionValue.TESTFIELD("Reestimation Date");
                            VALIDATE("Posting Date", DimensionValue."Reestimation Date");
                            VALIDATE("Reestimation Date", DimensionValue."Reestimation Date");
                            MODIFY;
                            ChargeCA;
                        END;
                    END;
                END;

                CreateDim(DATABASE::Job, "Job No.");
            END;

            trigger OnLookup();
            VAR
                //                                                               codereestimation@7001100 :
                codereestimation: Code[20];
            BEGIN

                IF FunctionQB.LookUpReest(codereestimation, FALSE) THEN
                    VALIDATE("Reestimation Code", codereestimation);
            END;


        }
        field(18; "Reestimation Date"; Date)
        {
            CaptionML = ENU = 'Reestimation Date', ESP = 'Fecha reestimaci�n';


        }
        field(19; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 ResponsibilityCenter@7001100 :
                ResponsibilityCenter: Record 5714;
            BEGIN
                IF NOT UserSetupManagement.CheckRespCenter(3, "Responsibility Center") THEN BEGIN
                    FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, UserRespCenter);
                END;
            END;


        }
        field(20; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@7001100 :
        QuoBuildingSetup: Record 7207278;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Text003@7001102 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Job@7001103 :
        Job: Record 167;
        //       Text004@7001104 :
        Text004: TextConst ENU = 'You can''t select a project in the finished state', ESP = 'No se puede seleccionar un proyecto en estado terminado.';
        //       Text005@7001105 :
        Text005: TextConst ENU = 'You can�t select a project with the fill Management By Production Unit active.', ESP = 'No se puede seleccionar un proyecto con el campo Gesti�n por unidades de producci�n activo.';
        //       ChangeFieldName@7001106 :
        ChangeFieldName: Text[30];
        //       FunctionQB@7001107 :
        FunctionQB: Codeunit 7207272;
        //       DimensionValue@7001108 :
        DimensionValue: Record 349;
        //       OldDimSetID@7001109 :
        OldDimSetID: Integer;
        //       DimensionManagement@7001110 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       ReestimationHeader@7001111 :
        ReestimationHeader: Record 7207315;
        //       Text006@7001119 :
        Text006: TextConst ENU = 'if you change %1, the existing sales lines will be deleted and new ', ESP = 'Si cambia %1, se eliminar�n las l�neas de reestimaci�n existentes y se crear�n nuevas ';
        //       Text007@7001118 :
        Text007: TextConst ENU = 'sales lines based on the new information on the header will be created.\\', ESP = 'l�neas reestimaci�n basadas en la nueva informaci�n de cabecera.\\';
        //       Text008@7001117 :
        Text008: TextConst ENU = 'Do you want to change %1?', ESP = '�Confirma que desea cambiar %1?';
        //       Text009@7001112 :
        Text009: TextConst ENU = 'Can not be reestimated to a date prior to the last one indicated in the project', ESP = 'No se puede reestimar a una fecha anterior a la ultima indicada en el proyecto';
        //       UserSetupManagement@7001113 :
        UserSetupManagement: Codeunit 5700;
        //       Text027@7001114 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       HasGotSalesUserSetup@7001115 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001116 :
        UserRespCenter: Code[10];
        //       Text051@7001120 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n.\\�Quiere actualizar la linea?';



    trigger OnInsert();
    begin
        QuoBuildingSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."Series No.", "Posting Date", "No.", "Series No.");
        end;

        InitRecord;
        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                VALIDATE("Job No.", GETRANGEMIN("Job No."));
        //Si entro en la tabla desde proyecto, heredo de forma autom�tica el proyecto desde el que vengo.
        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Job No.") <> '')) then
            VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);
    end;

    trigger OnDelete();
    var
        //                ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
        //                MovBudgetForecast@7001101 :
        MovBudgetForecast: Record 7207319;
        //                ReestimationHeader@7001102 :
        ReestimationHeader: Record 7207315;
        //                QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
    begin
        ReestimationLines.LOCKTABLE;

        ReestimationLines.SETRANGE("Document No.", "No.");
        ReestimationLines.DELETEALL;

        ReestimationLines.RESET;
        MovBudgetForecast.SETCURRENTKEY("Job No.", "Document No.", "Line No.", "Anality Concept Code", "Reestimation code");
        MovBudgetForecast.SETRANGE("Document No.", ReestimationHeader."No.");
        MovBudgetForecast.SETRANGE("Job No.", ReestimationHeader."Job No.");
        MovBudgetForecast.SETRANGE("Reestimation code", ReestimationHeader."Reestimation Code");
        if MovBudgetForecast.FINDFIRST then
            MovBudgetForecast.DELETEALL;

        QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::Reestimation);
        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin

        QuoBuildingSetup.TESTFIELD("Serie for Reestimate");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin

        exit(QuoBuildingSetup."Serie for Reestimate");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin

        exit(QuoBuildingSetup."Serie for Reestimate");
    end;

    procedure InitRecord()
    begin

        NoSeriesManagement.SetDefaultSeries("Posting Series No.", QuoBuildingSetup."Serie for Reestimate");

        "Posting Date" := TODAY;
        "Reestimation Date" := TODAY;
        "Posting Description" := "No.";
    end;

    //     LOCAL procedure GetMaestra (ProyNo@1000 :
    LOCAL procedure GetMaestra(ProyNo: Code[20])
    begin
        if ProyNo <> Job."No." then
            Job.GET(ProyNo);
    end;

    procedure ThereAreLines(): Boolean;
    var
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin

        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        exit(not ReestimationLines.ISEMPTY);
    end;

    procedure UpdateLines()
    var
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        if not CONFIRM(
                  Text006 +
                  Text007 +
                  Text008, FALSE, ChangeFieldName)
         then
            ERROR('');

        ReestimationLines.SETRANGE("Document No.", "No.");
        ReestimationLines.DELETEALL(TRUE);
    end;

    procedure ChargeCA()
    var
        //       NoLinea@7001100 :
        NoLinea: Integer;
        //       DimCA@7001101 :
        DimCA: Code[20];
        //       ReestimationLines2@7001102 :
        ReestimationLines2: Record 7207316;
        //       varImpPdte@7001103 :
        varImpPdte: Decimal;
    begin
        TESTFIELD("Job No.");
        TESTFIELD("Reestimation Code");
        TESTFIELD("Reestimation Date");

        Job.GET("Job No.");
        NoLinea := 10000;
        DimCA := FunctionQB.ReturnDimCA;
        DimensionValue.RESET;
        DimensionValue.SETFILTER("Dimension Code", DimCA);
        DimensionValue.SETFILTER("Dimension Value Type", '%1|%2|%3', DimensionValue."Dimension Value Type"::Standard,
                                DimensionValue."Dimension Value Type"::"end-Total", DimensionValue."Dimension Value Type"::"begin-Total");

        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if DimensionValue.FINDSET(FALSE,FALSE) then
        if DimensionValue.FINDSET(FALSE) then
            repeat
                ReestimationLines2.INIT;
                ReestimationLines2."Document No." := "No.";
                ReestimationLines2."Line No." := NoLinea;
                ReestimationLines2.VALIDATE("Job No.", "Job No.");
                ReestimationLines2."Analytical concept" := DimensionValue.Code;
                ReestimationLines2.Type := DimensionValue.Type;
                DimensionValue.TESTFIELD("Account Budget E Reestimations");
                ReestimationLines2."G/L Account" := DimensionValue."Account Budget E Reestimations";
                ReestimationLines2.Description := DimensionValue.Name;
                ReestimationLines2.VALIDATE("Reestimation Code", "Reestimation Code");
                CalcBudgetAmount;
                CalcRealizedAmount;
                if ReestimationLines2.Type = ReestimationLines2.Type::Expenses then begin
                    if ReestimationLines2."Budget amount" - ReestimationLines2."Realized Amount" > 0 then
                        CalcOutstandingAmount;
                end else begin
                    if ReestimationLines2."Budget amount" - ReestimationLines2."Realized Amount" < 0 then
                        CalcOutstandingAmount;
                end;
                ReestimationLines2."Total amount to estimated orig" := ReestimationLines2."Realized Amount" + varImpPdte;
                ReestimationLines2.INSERT(TRUE);
                NoLinea := NoLinea + 10000;
            until DimensionValue.NEXT = 0;
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ThereAreLines then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
        //       DimensionManagement@7001101 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        ReestimationLines.LOCKTABLE;
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ReestimationLines.FINDSET(TRUE,FALSE) then
        if ReestimationLines.FINDSET(TRUE) then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(ReestimationLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ReestimationLines."Dimension Set ID" <> NewDimSetID then begin
                    ReestimationLines."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      ReestimationLines."Dimension Set ID", ReestimationLines."Shortcut Dimension 1 Code", ReestimationLines."Shortcut Dimension 2 Code");
                    ReestimationLines.MODIFY;
                end;
            until ReestimationLines.NEXT = 0;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ThereAreLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ValidateCorrectReest()
    var
        //       lorrecDimeUltReestimacion@1100229000 :
        lorrecDimeUltReestimacion: Record 349;
    begin
        if "Job No." = '' then
            exit;
        if DimensionValue.GET(FunctionQB.ReturnDimReest, "Reestimation Code") then begin
            Job.GET("Job No.");
            if lorrecDimeUltReestimacion.GET(FunctionQB.ReturnDimReest, Job."Latest Reestimation Code") then begin
                if DimensionValue."Reestimation Date" < lorrecDimeUltReestimacion."Reestimation Date" then
                    ERROR(Text009)
            end;
        end;
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimensionManagement1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ThereAreLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure AssistEdit (ReestimationHeader@1000 :
    procedure AssistEdit(ReestimationHeader: Record 7207315): Boolean;
    begin
        QuoBuildingSetup.GET;
        TestNoSeries;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, ReestimationHeader."Series No.", "Series No.") then begin
            QuoBuildingSetup.GET;
            TestNoSeries;
            NoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure ExistLines(): Boolean;
    var
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        exit(not ReestimationLines.ISEMPTY);
    end;

    procedure CalcBudgetAmount()
    var
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        Job.GET("Job No.");

        if Job."Latest Reestimation Code" <> '' then
            Job.SETRANGE("Reestimation Filter", Job."Latest Reestimation Code")
        else
            Job.SETRANGE("Reestimation Filter", Job."Initial Reestimation Code");
        Job.SETFILTER("Analytic Concept Filter", DimensionValue.Code);
        Job.SETRANGE("Posting Date Filter");
        Job.CALCFIELDS("Budgeted Amount");
        ReestimationLines."Budget amount" := Job."Budgeted Amount";
    end;

    procedure CalcRealizedAmount()
    var
        //       Job@7001100 :
        Job: Record 167;
        //       DimensionValue@7001101 :
        DimensionValue: Record 349;
        //       ReestimationLines@7001102 :
        ReestimationLines: Record 7207316;
    begin
        Job.GET("Job No.");
        Job.SETFILTER("Analytic Concept Filter", DimensionValue.Code);
        Job.SETFILTER("Posting Date Filter", '..%1', "Reestimation Date");
        Job.CALCFIELDS("Realized Amount");

        ReestimationLines."Realized Amount" := Job."Realized Amount";
        ReestimationLines."Realized Excess" := ReestimationLines."Realized Amount" - ReestimationLines."Budget amount";
        if ReestimationLines.Type = ReestimationLines.Type::Expenses then begin
            if ReestimationLines."Realized Excess" < 0 then
                ReestimationLines."Realized Excess" := 0;
        end else begin
            if ReestimationLines."Realized Excess" > 0 then
                ReestimationLines."Realized Excess" := 0;
        end;
    end;

    procedure CalcOutstandingAmount()
    var
        //       Recmovpptoconta@1100251000 :
        Recmovpptoconta: Record 96;
        //       VarTotPendiente@1100251001 :
        VarTotPendiente: Decimal;
        //       VarImportePlan@1100251002 :
        VarImportePlan: Decimal;
        //       Job@7001100 :
        Job: Record 167;
        //       MovBudgetForecast@7001101 :
        MovBudgetForecast: Record 7207319;
        //       NoMov@7001102 :
        NoMov: Integer;
        //       ReestimationLines@7001103 :
        ReestimationLines: Record 7207316;
        //       VarImpPdte@7001104 :
        VarImpPdte: Decimal;
        //       FunctionQB@7001105 :
        FunctionQB: Codeunit 7207272;
    begin
        //Calculo de los campos calculados
        TESTFIELD("Job No.");
        Job.GET("Job No.");
        MovBudgetForecast.RESET;
        if MovBudgetForecast.FINDLAST then
            NoMov := MovBudgetForecast."Entry No." + 1
        else
            NoMov := 1;
        VarTotPendiente := ReestimationLines."Budget amount" - ReestimationLines."Realized Amount";
        VarImpPdte := VarTotPendiente;
        VarImportePlan := 0;
        if ReestimationLines.Type = ReestimationLines.Type::Expenses then begin
            Recmovpptoconta.SETCURRENTKEY("Budget Name", Date, "Budget Dimension 1 Code");
            Recmovpptoconta.SETRANGE("Budget Name", FunctionQB.ReturnBudgetJobs);
            Recmovpptoconta.SETRANGE("Budget Dimension 1 Code", "Job No.");
            Recmovpptoconta.SETRANGE("Global Dimension 2 Code", ReestimationLines."Analytical concept");
            Recmovpptoconta.SETFILTER(Date, '%1..', CALCDATE('+1D', "Reestimation Date"));
            if Job."Latest Reestimation Code" <> '' then
                Recmovpptoconta.SETRANGE("Budget Dimension 2 Code", Job."Latest Reestimation Code");
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            //if Recmovpptoconta.FINDSET(FALSE,FALSE) then
            if Recmovpptoconta.FINDSET(FALSE) then
                repeat
                    if Recmovpptoconta.Amount < (VarTotPendiente - VarImportePlan) then begin
                        MovBudgetForecast.INIT;
                        MovBudgetForecast."Entry No." := NoMov;
                        MovBudgetForecast."Document No." := "No.";
                        MovBudgetForecast."Line No." := ReestimationLines."Line No.";
                        MovBudgetForecast."Anality Concept Code" := ReestimationLines."Analytical concept";
                        MovBudgetForecast."Forecast Date" := Recmovpptoconta.Date;
                        MovBudgetForecast."Outstanding Temporary Forecast" := Recmovpptoconta.Amount;
                        MovBudgetForecast."User ID" := USERID;
                        MovBudgetForecast."Job No." := "Job No.";
                        MovBudgetForecast."Reestimation code" := "Reestimation Code";
                        MovBudgetForecast.Description := Recmovpptoconta.Description;
                        MovBudgetForecast.INSERT;
                        NoMov += 1;
                        VarImportePlan := VarImportePlan + Recmovpptoconta.Amount;
                    end
                    else begin
                        MovBudgetForecast.INIT;
                        MovBudgetForecast."Entry No." := NoMov;
                        MovBudgetForecast."Document No." := "No.";
                        MovBudgetForecast."Line No." := ReestimationLines."Line No.";
                        MovBudgetForecast."Anality Concept Code" := ReestimationLines."Analytical concept";
                        MovBudgetForecast."Forecast Date" := Recmovpptoconta.Date;
                        MovBudgetForecast."Outstanding Temporary Forecast" := VarTotPendiente - VarImportePlan;
                        MovBudgetForecast."User ID" := USERID;
                        MovBudgetForecast."Job No." := "Job No.";
                        MovBudgetForecast."Reestimation code" := "Reestimation Code";
                        MovBudgetForecast.Description := Recmovpptoconta.Description;
                        MovBudgetForecast.INSERT;
                        NoMov += 1;
                        VarImportePlan := VarTotPendiente;
                    end
                until ((Recmovpptoconta.NEXT) = 0) or (VarTotPendiente = VarImportePlan);
        end;
        if VarTotPendiente <> VarImportePlan then begin
            MovBudgetForecast.INIT;
            MovBudgetForecast."Entry No." := NoMov;
            MovBudgetForecast."Document No." := "No.";
            MovBudgetForecast."Line No." := ReestimationLines."Line No.";
            MovBudgetForecast."Anality Concept Code" := ReestimationLines."Analytical concept";
            MovBudgetForecast."Forecast Date" := CALCDATE('+1D', "Reestimation Date");
            MovBudgetForecast."Outstanding Temporary Forecast" := VarTotPendiente - VarImportePlan;
            MovBudgetForecast."User ID" := USERID;
            MovBudgetForecast."Job No." := "Job No.";
            MovBudgetForecast."Reestimation code" := "Reestimation Code";
            //si se planifica algo me quedo con la descripci�n del �ltimo mov. contable
            if VarImportePlan <> 0 then
                MovBudgetForecast.Description := Recmovpptoconta.Description
            else begin
                Recmovpptoconta.RESET;
                Recmovpptoconta.SETCURRENTKEY("Budget Name", Date, "Budget Dimension 1 Code");
                Recmovpptoconta.SETRANGE("Budget Name", FunctionQB.ReturnBudgetJobs);
                Recmovpptoconta.SETRANGE("Budget Dimension 1 Code", "Job No.");
                Recmovpptoconta.SETRANGE("Global Dimension 2 Code", ReestimationLines."Analytical concept");
                Recmovpptoconta.SETFILTER(Date, '..%1', CALCDATE('-1D', "Reestimation Date"));
                if Job."Latest Reestimation Code" <> '' then
                    Recmovpptoconta.SETRANGE("Budget Dimension 2 Code", Job."Latest Reestimation Code");
                if Recmovpptoconta.FINDFIRST then
                    MovBudgetForecast.Description := Recmovpptoconta.Description
            end;
            MovBudgetForecast.INSERT;

        end;
    end;

    //     procedure ResponsibilityFilters (var DocAFiltrar@1000000000 :
    procedure ResponsibilityFilters(var DocAFiltrar: Record 7207315)
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        if UserRespCenter <> '' then begin
            DocAFiltrar.FILTERGROUP(2);
            DocAFiltrar.SETRANGE("Responsibility Center", UserRespCenter);
            DocAFiltrar.FILTERGROUP(0);
        end;
    end;

    procedure CalcEstOutstExpAmount(): Decimal;
    var
        //       ImpGasPdteEst@1000000001 :
        ImpGasPdteEst: Decimal;
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        ImpGasPdteEst := 0;
        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ReestimationLines.FINDSET(FALSE, FALSE) then
        if ReestimationLines.FINDSET(FALSE) then
            repeat
                ReestimationLines.CALCFIELDS("Estimated outstanding amount");
                if ReestimationLines.Type = ReestimationLines.Type::Expenses
                  then
                    ImpGasPdteEst := ImpGasPdteEst + ReestimationLines."Estimated outstanding amount";
            until ReestimationLines.NEXT = 0;
        exit(ImpGasPdteEst);
    end;

    procedure CalcEstOutstIncAmount(): Decimal;
    var
        //       ImpIngPdteEst@1000000002 :
        ImpIngPdteEst: Decimal;
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        ImpIngPdteEst := 0;
        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ReestimationLines.FINDSET(FALSE,FALSE) then
        if ReestimationLines.FINDSET(FALSE) then
            repeat
                ReestimationLines.CALCFIELDS("Estimated outstanding amount");
                if ReestimationLines.Type = ReestimationLines.Type::Income then
                    ImpIngPdteEst := ImpIngPdteEst + ReestimationLines."Estimated outstanding amount";
            until ReestimationLines.NEXT = 0;
        exit(ImpIngPdteEst);
    end;

    procedure CalcEstOrigExpAmount(): Decimal;
    var
        //       ImpGasOrigenEst@1000000001 :
        ImpGasOrigenEst: Decimal;
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        ImpGasOrigenEst := 0;
        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ReestimationLines.FINDSET(FALSE, FALSE) then
        if ReestimationLines.FINDSET(FALSE) then
            repeat
                if ReestimationLines.Type = ReestimationLines.Type::Expenses then
                    ImpGasOrigenEst := ImpGasOrigenEst + ReestimationLines.CalcTotalAmount;
            until ReestimationLines.NEXT = 0;
        exit(ImpGasOrigenEst);
    end;

    procedure CalcEstOrigIncAmount(): Decimal;
    var
        //       ImpIngOrigenEst@1000000001 :
        ImpIngOrigenEst: Decimal;
        //       ReestimationLines@7001100 :
        ReestimationLines: Record 7207316;
    begin
        ImpIngOrigenEst := 0;
        ReestimationLines.RESET;
        ReestimationLines.SETRANGE("Document No.", "No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //ReestimationLines.FINDSET(FALSE, FALSE) then
        if ReestimationLines.FINDSET(FALSE) then
            repeat
                if ReestimationLines.Type = ReestimationLines.Type::Income
                 then
                    ImpIngOrigenEst := ImpIngOrigenEst + ReestimationLines.CalcTotalAmount;
            until ReestimationLines.NEXT = 0;
        exit(ImpIngOrigenEst);
    end;

    procedure CalcEstOrigMargin(): Decimal;
    begin
        exit(CalcEstOrigIncAmount - CalcEstOrigExpAmount);
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}








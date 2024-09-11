table 7207399 "Prod. Measure Header"
{


    CaptionML = ENU = 'Prob. Measure Header', ESP = 'Cab. Relaci�n Valorada';

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(3; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(4; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                HistProdMeasureHeader.RESET;
                HistProdMeasureHeader.SETRANGE("Job No.", "Job No.");                        //Que sea del proyecto
                HistProdMeasureHeader.SETFILTER("Posting Date", '>%1', "Posting Date");       //De fecha posterior a la indicada
                HistProdMeasureHeader.SETFILTER("Cancel By", '=%1', '');                       //Que no est� cancelada
                HistProdMeasureHeader.SETFILTER("Cancel No.", '=%1', '');                      //Que no cancele otra
                IF (HistProdMeasureHeader.FINDLAST) THEN BEGIN
                    "Posting Date" := CALCDATE('+1d', HistProdMeasureHeader."Posting Date");
                    MESSAGE('Tiene valoradas con fecha %1, no puede usar una fecha anterior, se cambia a %2', HistProdMeasureHeader."Posting Date", "Posting Date");
                END;

                ProdMeasureLines.RESET;
                ProdMeasureLines.SETRANGE("Document No.", "No.");
                IF ProdMeasureLines.FINDFIRST THEN
                    ProdMeasureLines.MODIFYALL("Posting Date", "Posting Date");
            END;


        }
        field(5; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
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
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            END;


        }
        field(8; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(9; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(10; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Measure"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(15; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH ProdMeasureHeader DO BEGIN
                ProdMeasureHeader := Rec;
                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := ProdMeasureHeader;
                // END;
            END;


        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(17; "Measure Date"; Date)
        {
            CaptionML = ENU = 'Date Measured', ESP = 'Fecha medici�n';


        }
        field(18; "Measurement No."; Code[10])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Number of Measurements', ESP = 'N�mero de medici�n';
            Description = 'JAV 22/09/19: - Se unifica Name y Caption con el hist�rico';

            trigger OnValidate();
            BEGIN
                //JAV 22/09/19: - Se establece el texto de medici�n a partir del n� de medici�n
                "Measurement Text" := STRSUBSTNO(Text009, "Measurement No.");
            END;


        }
        field(19; "Last Measurement"; Boolean)
        {
            CaptionML = ENU = 'Last Measurement', ESP = 'Ultima medici�n';


        }
        field(20; "Measurement Text"; Text[30])
        {
            CaptionML = ENU = 'Measurement Text', ESP = 'Texto medici�n';


        }
        field(21; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Management By Production Unit" = CONST(true),
                                                                            "Card Type" = CONST("Proyecto operativo"));


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                ControlJob("Job No.");
                CreateDim(DATABASE::Job, "Job No.");
                funInsCAGrContJob;
                SetNumber; //Numeramos la relaci�n

                //JAV 28/07/21: - QB 1.09.14 A�adir las l�neas anteriores a la valorada actual
                IF MODIFY THEN
                    AddLines;
            END;


        }
        field(22; "Customer No."; Code[20])
        {
            TableRelation = "Customer";


            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';

            trigger OnValidate();
            BEGIN
                IF ("Customer No." <> '') AND ("Customer No." <> xRec."Customer No.") THEN
                    IF NOT QBTableSubscriber.ValidateCustomerFromJob("Job No.", "Customer No.") THEN
                        ERROR(Text002);

                GetCustomerData;
            END;

            trigger OnLookup();
            VAR
                //                                                               cust@1100286000 :
                cust: Code[20];
            BEGIN
                //Solo saca los clientes del proyecto
                IF QBTableSubscriber.LookupCustomerFromJob("Job No.", "Customer No.", cust) THEN
                    VALIDATE("Customer No.", cust);
            END;


        }
        field(24; "Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';


        }
        field(25; "Address"; Text[50])
        {
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';


        }
        field(26; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';


        }
        field(27; "City"; Text[50])
        {
            CaptionML = ENU = 'City', ESP = 'Poblaci�n';


        }
        field(28; "Contact"; Text[50])
        {
            CaptionML = ENU = 'Contact', ESP = 'Contacto';


        }
        field(29; "County"; Text[50])
        {
            CaptionML = ENU = 'County', ESP = 'Provincia';


        }
        field(30; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            CaptionML = ENU = 'Post Code', ESP = 'C.P.';


        }
        field(31; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Country/Region Code', ESP = 'C�d. Pa�s';


        }
        field(32; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 ResponsibilityCenter@7001102 :
                ResponsibilityCenter: Record 5714;
                //                                                                 FunctionQB@7001100 :
                FunctionQB: Codeunit 7207272;
                //                                                                 Text027@7001101 :
                Text027: TextConst ENU = 'Your identification is set up to process from %1 to %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 a %2.';
                //                                                                 UserRespCenter@7001104 :
                UserRespCenter: Code[10];
                //                                                                 HasGotServUserSetup@7001103 :
                HasGotServUserSetup: Boolean;
            BEGIN
                IF NOT UserMgt.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(Text027, Respcenter.TABLECAPTION, FunctionQB.GetUserJobResponsibilityCenter());
            END;


        }
        field(33; "Validated Measurement"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Validated Measurement', ESP = 'Medici�n validada';
            Description = 'JAV 31/07/19: - se igualan las tablas registro e hist�rica';


        }
        field(34; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'User ID', ESP = 'Id. Usuario';
            Description = 'JAV 31/07/19: - se igualan las tablas registro e hist�rica';

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@1000 :
                LoginMgt: Codeunit "User Management 1";
            BEGIN
                LoginMgt.LookupUserID("User ID");
            END;


        }
        field(35; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';
            Description = 'JAV 31/07/19: - se igualan las tablas registro e hist�rica';


        }
        field(52; "DOC Import Previous"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Prod. Measure Lines"."PROD Amount Realiced" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount of Relationship Valued', ESP = 'Importe Anterior';
            Description = 'JAV 02/06/21 : - Importe anterior de esta relaci�n valorada';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(53; "DOC Import Term"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Prod. Measure Lines"."PROD Amount Term" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount of Relationship Valued', ESP = 'Importe Periodo';
            Description = 'JAV 02/06/21 : - Importe periodo de esta relaci�n valorada';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(54; "DOC Import to Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Prod. Measure Lines"."PROD Amount to Source" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Import to Source', ESP = 'Importe a origen';
            Description = 'JAV 02/06/21 : - Importe origen de esta relaci�n valorada';
            Editable = false;


        }
        field(70; "Cancel No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancela la medici�n';
            Description = 'JAV 31/07/19: - Indica la que se ha cancelado con esta medici�n';
            Editable = false;


        }
        field(71; "Cancel By"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancelada por';
            Description = 'JAV 31/07/19: - Indica la medici�n que cancela la actual';
            Editable = false;


        }
        field(480; "Dimension Set ID"; Integer)
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
        //       NoSeriesMgt@7001101 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       ProdMeasureHeader@1100286013 :
        ProdMeasureHeader: Record 7207399;
        //       ProdMeasureLines@1100286011 :
        ProdMeasureLines: Record 7207400;
        //       QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
        //       recDescompuesLinMedicionPed@7001102 :
        recDescompuesLinMedicionPed: Record 7207395;
        //       Text001@1100286002 :
        Text001: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Ha cambiado una dimension.\\�Quiere actualizar las lineas?';
        //       Text002@1100286004 :
        Text002: TextConst ESP = 'El cliente no est� entre los informados en el proyecto';
        //       Text003@7001105 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       DimMgt@7001107 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       OldDimSetID@7001106 :
        OldDimSetID: Integer;
        //       FunctionQB@7001110 :
        FunctionQB: Codeunit 7207272;
        //       recJob@7001111 :
        recJob: Record 167;
        //       Text006@7001113 :
        Text006: TextConst ENU = 'Job must have Management by Unit Production active', ESP = 'El proyecto debe tener activa la gesti�n por unidades de producci�n';
        //       Text007@7001112 :
        Text007: TextConst ENU = 'Proyect must be Operative', ESP = 'El proyecto debe ser Operativo';
        //       Text008@7001114 :
        Text008: TextConst ENU = 'You cannot change measure type because lines exist for measure %1', ESP = 'No puede cambiar el tipo de medici�n porque existen l�neas para la medici�n %1';
        //       Respcenter@7001115 :
        Respcenter: Record 5714;
        //       UserMgt@7001117 :
        UserMgt: Codeunit 5700;
        //       Text009@7001118 :
        Text009: TextConst ENU = 'Measure No: ', ESP = 'N� Medici�n: %1';
        //       HistProdMeasureHeader@1100286012 :
        HistProdMeasureHeader: Record 7207401;
        //       HistProdMeasureLines@1100286000 :
        HistProdMeasureLines: Record 7207402;
        //       i@1100286001 :
        i: Integer;
        //       QBTableSubscriber@1100286003 :
        QBTableSubscriber: Codeunit 7207347;
        //       Text010@1100286005 :
        Text010: TextConst ESP = 'Solo puede igualar proyectos de medici�n abierta';
        //       Text011@1100286006 :
        Text011: TextConst ESP = 'Revisando #1########################\Ajustando #2########################';
        //       Text012@1100286007 :
        Text012: TextConst ESP = 'Ajustando coste y venta';
        //       Text013@1100286008 :
        Text013: TextConst ESP = 'Ajustando coste';
        //       Text014@1100286009 :
        Text014: TextConst ESP = 'Ajustando venta';
        //       Text015@1100286010 :
        Text015: TextConst ESP = 'Finalizado, se han igualado %1 U.O.';



    trigger OnInsert();
    begin

        if "No." = '' then
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");

        InitRecord;

        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                VALIDATE("Job No.", GETRANGEMIN("Job No."));


        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Job No.") <> '')) then
            VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);

        SetNumber; //Numeramos la relaci�n
    end;

    trigger OnModify();
    begin
        SetNumber; //Numeramos la relaci�n
    end;

    trigger OnDelete();
    begin
        ProdMeasureLines.LOCKTABLE;

        //Se borran las l�neas asociadas al documento
        ProdMeasureLines.SETRANGE("Document No.", "No.");
        ProdMeasureLines.DELETEALL;

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;

        recDescompuesLinMedicionPed.SETRANGE("Document Type", recDescompuesLinMedicionPed."Document Type"::"Valued Relationship");
        recDescompuesLinMedicionPed.SETRANGE("Document No.", "No.");
        recDescompuesLinMedicionPed.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET();
        QuoBuildingSetup.TESTFIELD("Serie for Measurement");
        exit(QuoBuildingSetup."Serie for Measurement");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET();
        QuoBuildingSetup.TESTFIELD("Serie for Measurement Post");
        exit(QuoBuildingSetup."Serie for Measurement Post");
    end;

    procedure InitRecord()
    begin
        QuoBuildingSetup.GET();
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", QuoBuildingSetup."Serie for Measurement Post");
        VALIDATE("Posting Date", WORKDATE);
        "Measure Date" := "Posting Date";
        "Posting Description" := "No.";
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ExistLines(): Boolean;
    begin
        ProdMeasureLines.RESET;
        ProdMeasureLines.SETRANGE("Document No.", "No.");
        exit(not ProdMeasureLines.ISEMPTY);
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text001) then
            exit;

        ProdMeasureLines.RESET;
        ProdMeasureLines.SETRANGE("Document No.", "No.");
        ProdMeasureLines.LOCKTABLE;
        if ProdMeasureLines.FIND('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ProdMeasureLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ProdMeasureLines."Dimension Set ID" <> NewDimSetID then begin
                    ProdMeasureLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ProdMeasureLines."Dimension Set ID", ProdMeasureLines."Shortcut Dimension 1 Code", ProdMeasureLines."Shortcut Dimension 2 Code");
                    ProdMeasureLines.MODIFY;
                end;
            until ProdMeasureLines.NEXT = 0;
    end;

    //     procedure ControlJob (CodProyecto@1000 :
    procedure ControlJob(CodProyecto: Code[20])
    begin
        if recJob.GET(CodProyecto) then begin
            if recJob."Management By Production Unit" = FALSE then
                ERROR(Text006);
            if recJob."Job Type" <> recJob."Job Type"::Operative then
                ERROR(Text007);
            VALIDATE("Customer No.", recJob."Bill-to Customer No.");
            Description := recJob.Description;
            "Description 2" := recJob."Description 2";
        end;
    end;

    procedure funInsCAGrContJob()
    var
        //       RecProy@1000000000 :
        RecProy: Record 167;
        //       RecGCProy@1000000001 :
        RecGCProy: Record 208;
    begin

        if recJob.GET("Job No.") then begin
            ;
            recJob.TESTFIELD(recJob."Job Posting Group");
            RecGCProy.GET(recJob."Job Posting Group");
            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then begin
                "Shortcut Dimension 1 Code" := RecGCProy."Sales Analytic Concept";
            end;
            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 then begin
                "Shortcut Dimension 2 Code" := RecGCProy."Sales Analytic Concept";
            end;
        end;
    end;

    procedure GetCustomerData()
    var
        //       recCustomer@1000 :
        recCustomer: Record 18;
    begin
        if not recCustomer.GET("Customer No.") then begin
            CLEAR(recCustomer);
        end;

        Name := recCustomer.Name;
        Address := recCustomer.Address;
        "Address 2" := recCustomer."Address 2";
        City := recCustomer.City;
        Contact := recCustomer.Contact;
        County := recCustomer.County;
        "Post Code" := recCustomer."Post Code";
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure FunFilterResponsibility (var MeasProdToFilter@1000000000 :
    procedure FunFilterResponsibility(var MeasProdToFilter: Record 7207399)
    begin
        if FunctionQB.GetUserJobResponsibilityCenter <> '' then begin
            MeasProdToFilter.FILTERGROUP(2);
            MeasProdToFilter.SETRANGE("Responsibility Center", FunctionQB.GetUserJobResponsibilityCenter);
            MeasProdToFilter.FILTERGROUP(0);
        end;
    end;

    //     procedure AssistEdit (recOldcabDoc@1000 :
    procedure AssistEdit(recOldcabDoc: Record 7207399): Boolean;
    begin
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, recOldcabDoc."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
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
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Prod. Measuring", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistLines then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure MatchCostSale()
    var
        //       DataPieceworkForProduction@1100286000 :
        DataPieceworkForProduction: Record 7207386;
        //       NewMeasure@1100286004 :
        NewMeasure: Decimal;
        //       bCost@1100286001 :
        bCost: Boolean;
        //       bSale@1100286002 :
        bSale: Boolean;
        //       ChangedNo@1100286005 :
        ChangedNo: Integer;
        //       n1@1100286003 :
        n1: Integer;
        //       n2@1100286006 :
        n2: Integer;
        //       Windows@1100286007 :
        Windows: Dialog;
    begin
        recJob.GET("Job No.");
        if (recJob."Sales Medition Type" <> recJob."Sales Medition Type"::open) then
            ERROR(Text010)
        else begin
            ChangedNo := 0;
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            n1 := COUNT;
            n2 := 0;
            Windows.OPEN(Text011);
            if (DataPieceworkForProduction.FINDSET(FALSE)) then
                repeat
                    n2 += 1;
                    Windows.UPDATE(1, STRSUBSTNO('%1 (%2 de %3)', DataPieceworkForProduction."Piecework Code", n2, n1));

                    DataPieceworkForProduction.SETRANGE("Budget Filter", recJob."Current Piecework Budget");
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");

                    NewMeasure := DataPieceworkForProduction."Budget Measure";
                    if (DataPieceworkForProduction."Sale Quantity (base)" > NewMeasure) then
                        NewMeasure := DataPieceworkForProduction."Sale Quantity (base)";

                    //Calculo si debo aumentar coste o venta para igualarlos
                    bCost := (NewMeasure > DataPieceworkForProduction."Budget Measure");
                    bSale := (NewMeasure > DataPieceworkForProduction."Sale Quantity (base)");

                    //Si hay que incrementar coste o venta
                    if (bCost) or (bSale) then begin
                        CASE TRUE OF
                            bCost and bSale:
                                Windows.UPDATE(2, Text012);
                            bCost and (not bSale):
                                Windows.UPDATE(2, Text013);
                            (not bCost) and bSale:
                                Windows.UPDATE(2, Text014);
                        end;
                        ProdMeasureLines.IncreaseCostSale("Job No.", DataPieceworkForProduction."Piecework Code", NewMeasure, bCost, bSale, TRUE);
                        ChangedNo += 1;
                    end else
                        Windows.UPDATE(2, 'Ajustada');

                until (DataPieceworkForProduction.NEXT = 0);
            Windows.CLOSE;
            MESSAGE(Text015, ChangedNo);
        end;
    end;

    LOCAL procedure SetNumber()
    begin
        //JAV 26/03/10: - Buscamos la �ltima referencia de medicion y le asignamos la siguiente
        //JAV 22/09/19: - No consideramos ni las canceladas ni las que cancelan en la b�squeda del n�mero de la medici�n
        if ("Measurement No." = '') and ("Job No." <> '') then begin
            "Measurement No." := '0';

            ProdMeasureHeader.RESET;
            ProdMeasureHeader.SETRANGE("Job No.", "Job No.");
            ProdMeasureHeader.SETFILTER("Cancel No.", '=%1', '');
            ProdMeasureHeader.SETFILTER("Cancel By", '=%1', '');
            if (ProdMeasureHeader.FINDSET(FALSE)) then
                repeat
                    if ("Measurement No." < ProdMeasureHeader."Measurement No.") then
                        "Measurement No." := ProdMeasureHeader."Measurement No.";
                until ProdMeasureHeader.NEXT = 0;

            HistProdMeasureHeader.RESET;
            HistProdMeasureHeader.SETRANGE("Job No.", "Job No.");
            HistProdMeasureHeader.SETFILTER("Cancel No.", '=%1', '');
            HistProdMeasureHeader.SETFILTER("Cancel By", '=%1', '');
            if (HistProdMeasureHeader.FINDSET(FALSE)) then
                repeat
                    if ("Measurement No." < HistProdMeasureHeader."Measurement No.") then
                        "Measurement No." := HistProdMeasureHeader."Measurement No.";
                until HistProdMeasureHeader.NEXT = 0;

            VALIDATE("Measurement No.", INCSTR("Measurement No."));
        end;
    end;

    procedure AddLines()
    var
        //       LineNo@1100286001 :
        LineNo: Integer;
    begin
        if (not ProdMeasureHeader.GET("No.")) then //Si todav�a no existe la cabecera salgo
            exit;
        if ("Job No." = '') then    //Si no tiene proyecto salgo
            exit;

        ProdMeasureLines.RESET;
        ProdMeasureLines.SETRANGE("Document No.", "No.");
        if (ProdMeasureLines.FINDLAST) then
            LineNo := ProdMeasureLines."Line No."
        else
            LineNo := 0;

        HistProdMeasureLines.RESET;
        HistProdMeasureLines.SETRANGE("Job No.", "Job No.");
        if HistProdMeasureLines.FINDSET then
            repeat
                ProdMeasureLines.RESET;
                ProdMeasureLines.SETRANGE("Document No.", "No.");
                ProdMeasureLines.SETRANGE("Piecework No.", HistProdMeasureLines."Piecework No.");
                if (ProdMeasureLines.ISEMPTY) then begin
                    ProdMeasureLines.TRANSFERFIELDS(HistProdMeasureLines);

                    LineNo += 10000;
                    ProdMeasureLines."Document No." := "No.";
                    ProdMeasureLines."Line No." := LineNo;
                    ProdMeasureLines.VALIDATE("Piecework No.");   //Por si hay diferencias
                    ProdMeasureLines.VALIDATE("Measure Term", 0); //No hay medici�n del periodo todav�a, es a origen
                    ProdMeasureLines.INSERT;
                end;
            until HistProdMeasureLines.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 26/03/19: - Se cambian los FlowField de los campos "Import to Source" y "Amount of Relationship Valued"
//                    - Buscamos la �ltima referencia de medicion y le asignamos la siguiente
//      JAV 02/04/19: - Mejora en mediciones, se permite cambiar el tipo en cualquier momento
//      JAV 31/07/19: - Se igualan los campos de las tablas registro e hist�rica
//                    - Se a�aden los campos 37"Cancel No." que indica la que se ha cancelado con esta medici�n y 38 "Cancel By" que indica la medici�n que cancela la actual
//      JAV 22/09/19: - No consideramos ni las canceladas ni las que cancelan en la b�squeda del n�mero de la medici�n
//                    - Se establece el texto de medici�n a partir del n� de medici�n
//                    - Se unifica Name y Caption con el hist�rico del campo 18 quedando como "Measurement No."
//      JAV 28/07/21: - QB 1.09.14 Nueva funci�n para a�adir las l�neas anteriores a la valorada actual, y se usa al establecer el proyecto
//      JAV 24/06/22: - QB 1.10.53 Se cambian los campos "xxx PEC xxx" por "xxx xxx" que es mas apropiado
//    }
    end.
  */
}








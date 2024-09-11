table 7207290 "Worksheet Header qb"
{


    CaptionML = ENU = 'Job Share Header', ESP = 'Cab. Parte de Trabajo';
    LookupPageID = "QB Worksheet List";
    DrillDownPageID = "QB Worksheet List";

    fields
    {
        field(1; "No. Resource /Job"; Code[20])
        {
            TableRelation = IF ("Sheet Type" = FILTER("By Resource")) Resource WHERE("Type" = FILTER('Person' | 'Machine')) ELSE IF ("Sheet Type" = CONST("By Job")) Job;


            CaptionML = ENU = 'No. Resource /Job', ESP = 'N� recurso / proyecto';

            trigger OnValidate();
            BEGIN
                IF ("No. Resource /Job" <> xRec."No. Resource /Job") THEN BEGIN
                    recWorkSheetLines.RESET;
                    recWorkSheetLines.SETRANGE("Document No.", "No.");
                    IF "Sheet Type" = "Sheet Type"::"By Resource" THEN
                        recWorkSheetLines.MODIFYALL("Resource No.", "No. Resource /Job");
                    IF "Sheet Type" = "Sheet Type"::"By Job" THEN
                        recWorkSheetLines.MODIFYALL("Job No.", "No. Resource /Job");

                END;

                IF "Sheet Type" = "Sheet Type"::"By Resource" THEN BEGIN
                    GetMaster("No. Resource /Job", '');
                    IF recResource.Blocked = TRUE THEN
                        ERROR(Text005);
                    Description := recResource.Name;
                    "Description 2" := recResource."Name 2";
                    CreateDim(DATABASE::Resource, "No. Resource /Job");
                END ELSE BEGIN
                    GetMaster('', "No. Resource /Job");
                    recJob.ControlJob(recJob);
                    IF recJob.Blocked <> recJob.Blocked::" " THEN
                        ERROR(Text006);
                    IF recJob."Job Type" = recJob."Job Type"::Deviations THEN
                        ERROR(Text007);
                    IF recJob.Status <> recJob.Status::Open THEN
                        ERROR(Text008);
                    Description := recJob.Description;
                    "Description 2" := recJob."Description 2";
                    CreateDim(DATABASE::Job, "No. Resource /Job");
                END;
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
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
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            END;


        }
        field(9; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Sheet"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(10; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("WorkSheet Lines qb"."Total Cost" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;


        }
        field(11; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(13; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    QuoBuildingSetup.GET;
                    TestNoSeries;
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                //WITH WorkSheetHeader DO BEGIN
                WorkSheetHeader := Rec;
                QuoBuildingSetup.GET;
                TestNoSeries;
                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := WorkSheetHeader;
                //END;
            END;


        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(15; "Sheet Type"; Option)
        {
            OptionMembers = "By Resource","By Job","Mix";

            CaptionML = ENU = 'Sheet Type', ESP = 'Tipo parte';
            OptionCaptionML = ENU = 'By Resource, By Job,Mix', ESP = 'Por recurso,Por Proyecto,Mixto';


            trigger OnValidate();
            VAR
                //                                                                 AntCodigo@1100286000 :
                AntCodigo: Code[20];
            BEGIN
                IF ("Sheet Type" <> xRec."Sheet Type") AND ("Sheet Type" <> "Sheet Type"::Mix) THEN BEGIN
                    CALCFIELDS("No. Lines");
                    IF ("No. Lines" <> 0) THEN
                        MESSAGE(Text000, "No. Lines");
                END;
            END;


        }
        field(16; "Sheet Date"; Date)
        {


            CaptionML = ENU = 'Sheet Date', ESP = 'Fecha de parte';

            trigger OnValidate();
            BEGIN
                AssignTerm;
                "Posting Description" := Text028 + "No." + Text029 + "Allocation Term";
                ControlSheetExist;
            END;


        }
        field(17; "Allocation Term"; Code[10])
        {
            TableRelation = "Allocation Term";
            CaptionML = ENU = 'Allocation Term', ESP = 'Per�odo de imputaci�n';
            Editable = false;


        }
        field(18; "No. Hours"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("WorkSheet Lines qb"."Quantity" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'No. Hours', ESP = 'N� de horas';
            Editable = false;


        }
        field(19; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            BEGIN
                IF NOT UsrMgt.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(Text027, Respcenter.TABLECAPTION, UsrMgt.GetServiceFilter);
            END;


        }
        field(20; "No. Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("WorkSheet Lines qb" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'N� L�neas';
            Editable = false;
            AutoFormatType = 1;


        }
        field(22; "Rental Machinery"; Boolean)
        {
            CaptionML = ENU = 'Rental Machinery', ESP = 'Alquiler Maquinaria';


        }
        field(23; "Shop Depreciate Sheet"; Boolean)
        {
            CaptionML = ENU = 'Shop Depreciate Share', ESP = 'Parte de amortizaci�n planta';


        }
        field(24; "Shop Cost Unit Code"; Code[20])
        {
            CaptionML = ENU = 'Shop Cost Unit Code', ESP = 'C�d. unidad coste planta';
            Editable = false;


        }
        field(26; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(30; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                CreateDim(DATABASE::Job, "Job No.");
            END;


        }
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00- JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(121; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(122; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(123; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '###ELIMINAR### no se usa';


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("WorkSheet"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(7238177; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QPR';


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
        //       recWorkSheetLines@7001103 :
        recWorkSheetLines: Record 7207291;
        //       recLinesComment@7001102 :
        recLinesComment: Record 7207270;
        //       Text000@1100286000 :
        Text000: TextConst ESP = 'Tiene %1 l�neas, reviselas para asegurarse de que siguen siendo correctas.';
        //       Text001@1100286001 :
        Text001: TextConst ESP = 'No ha indicado el contador a usar en la configuraci�n de recursos.';
        //       Text003@7001104 :
        Text003: TextConst ENU = 'You cannot rename to %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       recResource@7001105 :
        recResource: Record 156;
        //       recJob@7001106 :
        recJob: Record 167;
        //       Text005@7001107 :
        Text005: TextConst ENU = 'Resource is Blocked and it cannot be used', ESP = 'El recurso est� bloqueado y no puede ser usado.';
        //       OldDimSetID@7001108 :
        OldDimSetID: Integer;
        //       DimMgt@7001109 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       Text006@7001112 :
        Text006: TextConst ENU = 'Job is Blocked', ESP = 'El Proyecto est� bloqueado';
        //       Text007@7001111 :
        Text007: TextConst ENU = 'Job Type must be "Operative" or "Structure"', ESP = 'El tipo de proyecto debe ser de tipo operativo o estructura';
        //       Text008@7001110 :
        Text008: TextConst ENU = 'Job Status must be Order', ESP = 'El Estado del proyecto debe ser Pedido';
        //       WorkSheetHeader@7001113 :
        WorkSheetHeader: Record 7207290;
        //       Text028@7001115 :
        Text028: TextConst ENU = 'Share ', ESP = 'Parte ';
        //       Text029@7001114 :
        Text029: TextConst ENU = ' Term ', ESP = ' Periodo ';
        //       FunctionQB@7001116 :
        FunctionQB: Codeunit 7207272;
        //       UsrMgt@7001117 :
        UsrMgt: Codeunit 5700;
        //       Text027@7001118 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Respcenter@7001119 :
        Respcenter: Record 5714;
        //       WorksheetHeaderHist@7001120 :
        WorksheetHeaderHist: Record 7207292;
        //       Text009@7001121 :
        Text009: TextConst ESP = 'Ya existe un parte para el recurso %1 y el periodo %2';



    trigger OnInsert();
    begin
        QuoBuildingSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;
        if GETFILTER("No. Resource /Job") <> '' then
            if GETRANGEMIN("No. Resource /Job") = GETRANGEMAX("No. Resource /Job") then
                VALIDATE("No. Resource /Job", GETRANGEMIN("No. Resource /Job"));
    end;

    trigger OnDelete();
    begin
        recWorkSheetLines.RESET;
        recWorkSheetLines.SETRANGE("Document No.", "No.");
        recWorkSheetLines.DELETEALL(TRUE);

        recLinesComment.RESET;
        recLinesComment.SETRANGE("Document Type", recLinesComment."Document Type"::Sheet);
        recLinesComment.SETRANGE("No.", "No.");
        recLinesComment.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        QuoBuildingSetup.TESTFIELD("Serie for Work Sheet");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        if (QuoBuildingSetup."Serie for Work Sheet" = '') then
            ERROR(Text001);

        exit(QuoBuildingSetup."Serie for Work Sheet");
    end;

    procedure InitRecord()
    begin
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", QuoBuildingSetup."Serie for Work Sheet Post");
        "Posting Date" := WORKDATE;
        "Posting Description" := Text028 + "No." + Text029 + "Allocation Term";
    end;

    //     LOCAL procedure GetMaster (ResourceNo@1000 : Code[20];JobNo@1000000000 :
    LOCAL procedure GetMaster(ResourceNo: Code[20]; JobNo: Code[20])
    begin
        if ResourceNo <> recResource."No." then
            recResource.GET(ResourceNo);

        if JobNo <> recJob."No." then
            recJob.GET(JobNo);
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
          DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup.WorkSheet, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistSheetLines then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ExistSheetLines(): Boolean;
    begin
        recWorkSheetLines.RESET;
        recWorkSheetLines.SETRANGE("Document No.", "No.");
        exit(not recWorkSheetLines.ISEMPTY);
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
        //       Text051@7001100 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Ha cambiado una dimension.\\�Desea actualizar las l�neas?';
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        recWorkSheetLines.RESET;
        recWorkSheetLines.SETRANGE("Document No.", "No.");
        recWorkSheetLines.LOCKTABLE;
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if recWorkSheetLines.FINDSET(TRUE,FALSE) then
        if recWorkSheetLines.FINDSET(TRUE) then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(recWorkSheetLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if recWorkSheetLines."Dimension Set ID" <> NewDimSetID then begin
                    recWorkSheetLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      recWorkSheetLines."Dimension Set ID", recWorkSheetLines."Shortcut Dimension 1 Code", recWorkSheetLines."Shortcut Dimension 2 Code");
                    recWorkSheetLines.MODIFY;
                end;
            until recWorkSheetLines.NEXT = 0;
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
            if ExistSheetLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        exit(QuoBuildingSetup."Serie for Work Sheet Post");
    end;

    procedure AssignTerm()
    var
        //       AllocationTermDays@7001100 :
        AllocationTermDays: Record 7207295;
        //       text010@7001101 :
        text010: TextConst ENU = 'There is not term that include this date', ESP = 'No hay ning�n per�odo que incluya esta fecha';
    begin
        AllocationTermDays.RESET;
        AllocationTermDays.SETRANGE(Day, "Sheet Date");
        if AllocationTermDays.FINDFIRST then
            "Allocation Term" := AllocationTermDays."Allocation Term"
        else
            ERROR(text010);
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistSheetLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        exit(TRUE);
    end;

    //     procedure AssistEdit (recOldWorkSheetHeader@1000 :
    procedure AssistEdit(recOldWorkSheetHeader: Record 7207290): Boolean;
    begin
        QuoBuildingSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, recOldWorkSheetHeader."No. Series", "No. Series") then begin
            QuoBuildingSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    //     procedure FunFilterResponsibility (var SheetToFilter@1000000000 :
    procedure FunFilterResponsibility(var SheetToFilter: Record 7207290)
    begin
        FunctionQB.SetUserJobWorksheetFilter(SheetToFilter);
    end;

    procedure ControlSheetExist()
    begin
        WorksheetHeaderHist.RESET;
        WorksheetHeaderHist.SETRANGE("No. Resource /Job", "No. Resource /Job");
        WorksheetHeaderHist.SETRANGE("Allocation Term", "Allocation Term");
        if WorksheetHeaderHist.FINDFIRST then
            MESSAGE(Text009, "No. Resource /Job", "Allocation Term");
    end;

    /*begin
    end.
  */
}








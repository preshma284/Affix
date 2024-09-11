table 7206933 "QB External Worksheet Header"
{


    CaptionML = ENU = 'Externals Worksheet', ESP = 'Parte de Trabajo de Externos';
    LookupPageID = "QB Worksheet List";
    DrillDownPageID = "QB Worksheet List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'Key 1';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Vendor No.', ESP = 'Proveedor subcontrata';

            trigger OnValidate();
            BEGIN
                Vendor.GET("Vendor No.");
                IF (Vendor.Blocked <> Vendor.Blocked::" ") THEN
                    ERROR(Text009);

                //Cambiarlo en las l�neas
                IF ("Vendor No." <> xRec."Vendor No.") THEN BEGIN
                    ExternalsWorksheetLines.RESET;
                    ExternalsWorksheetLines.SETRANGE("Document No.", "No.");
                    IF (ExternalsWorksheetLines.FINDSET(TRUE)) THEN
                        REPEAT
                            ExternalsWorksheetLines.VALIDATE("Vendor No.", "Vendor No.");
                            ExternalsWorksheetLines.MODIFY;
                        UNTIL (ExternalsWorksheetLines.NEXT = 0);
                END;

                CALCFIELDS("Vendor Name");
                CreateDim;
            END;


        }
        field(3; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Description', ESP = 'Nombre';
            Editable = false;


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
            CaptionML = ENU = 'Comment', ESP = 'Comentarios';
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
                    TestNoSeries;
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                //WITH WorkSheetHeader DO BEGIN
                WorkSheetHeader := Rec;
                TestNoSeries;
                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := WorkSheetHeader;
                //END;
            END;


        }
        field(16; "Sheet Date"; Date)
        {


            CaptionML = ENU = 'Sheet Date', ESP = 'Fecha de parte';

            trigger OnValidate();
            BEGIN
                AssignTerm;
                "Posting Description" := Text028 + "No." + Text029 + "Allocation Term";
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
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00 - JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(121; "Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = 'QB 1.00 - JAV 14/10/19: - Situaci�n de la aprobaci�n';
            Editable = false;


        }
        field(122; "Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = 'QB 1.00 - JAV 14/10/19: - �ltimo comentario de la aprobaci�n';
            Editable = false;


        }
        field(123; "Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = 'QB 1.03 - JAV 14/10/19: - Feha de la aprobaci�n, retenci�n o rechazo';


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
        //       WorkSheetHeader@1100286001 :
        WorkSheetHeader: Record 7206933;
        //       WorksheetHeaderHist@1100286000 :
        WorksheetHeaderHist: Record 7206935;
        //       ExternalsWorksheetLines@1100286002 :
        ExternalsWorksheetLines: Record 7206934;
        //       QuoBuildingSetup@7001100 :
        QuoBuildingSetup: Record 7207278;
        //       recLinesComment@7001102 :
        recLinesComment: Record 7207270;
        //       Text001@1100286011 :
        Text001: TextConst ENU = 'Type Job must be Operative', ESP = 'El tipo de proyecto debe ser operativo';
        //       Text002@1100286010 :
        Text002: TextConst ENU = 'Job Status must be Order', ESP = 'El Estado del proyecto debe ser Pedido';
        //       Text003@1100286009 :
        Text003: TextConst ENU = 'Job is Blocked', ESP = 'El proyecto est� bloqueado';
        //       Text004@7001104 :
        Text004: TextConst ENU = 'You cannot rename to %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       recResource@7001105 :
        recResource: Record 156;
        //       Job@7001106 :
        Job: Record 167;
        //       Text005@7001107 :
        Text005: TextConst ENU = 'Resource is Blocked and it cannot be used', ESP = 'El recurso est� bloqueado y no puede ser usado.';
        //       Text006@7001112 :
        Text006: TextConst ENU = 'Job is Blocked', ESP = 'El proyecto est� bloqueado';
        //       Text007@7001111 :
        Text007: TextConst ENU = 'Job Type must be "Operative" or "Structure"', ESP = 'El tipo de proyecto debe ser de tipo operativo o estructura';
        //       Text008@7001110 :
        Text008: TextConst ENU = 'Job Status must be Order', ESP = 'El Estado del proyecto debe ser Pedido';
        //       Text009@1100286012 :
        Text009: TextConst ESP = 'El proveedor est� bloqueado.';
        //       Text028@7001115 :
        Text028: TextConst ENU = 'Share ', ESP = 'Parte ';
        //       Text029@7001114 :
        Text029: TextConst ENU = ' Term ', ESP = ' Periodo ';
        //       Text027@7001118 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Vendor@1100286008 :
        Vendor: Record 23;
        //       Respcenter@7001119 :
        Respcenter: Record 5714;
        //       DimMgt@1100286006 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       FunctionQB@1100286005 :
        FunctionQB: Codeunit 7207272;
        //       UsrMgt@1100286004 :
        UsrMgt: Codeunit 5700;
        //       NoSeriesMgt@1100286007 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       OldDimSetID@1100286003 :
        OldDimSetID: Integer;



    trigger OnInsert();
    begin
        if ("No." = '') then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;
    end;

    trigger OnDelete();
    begin
        ExternalsWorksheetLines.RESET;
        ExternalsWorksheetLines.SETRANGE("Document No.", "No.");
        ExternalsWorksheetLines.DELETEALL(TRUE);

        recLinesComment.RESET;
        recLinesComment.SETRANGE("Document Type", recLinesComment."Document Type"::ExternalSheet);
        recLinesComment.SETRANGE("No.", "No.");
        recLinesComment.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text004, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Serie for Work Sheet");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET;
        exit(QuoBuildingSetup."Serie for Work Sheet");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET;
        exit(QuoBuildingSetup."Serie for Work Sheet Post");
    end;

    procedure InitRecord()
    begin
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", GetPostingNoSeriesCode);
        "Posting Date" := WORKDATE;
        "Posting Description" := Text028 + "No." + Text029 + "Allocation Term";
    end;

    procedure CreateDim()
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //Adding argument to handle GetDefaultDimID function
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        TableID[1] := DATABASE::Vendor;
        No[1] := "Vendor No.";

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup.WorkSheet, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistSheetLines then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ExistSheetLines(): Boolean;
    begin
        ExternalsWorksheetLines.LOCKTABLE;
        ExternalsWorksheetLines.RESET;
        ExternalsWorksheetLines.SETRANGE("Document No.", "No.");
        exit(not ExternalsWorksheetLines.ISEMPTY);
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

        ExternalsWorksheetLines.RESET;
        ExternalsWorksheetLines.SETRANGE("Document No.", "No.");
        ExternalsWorksheetLines.LOCKTABLE;
        //if ExternalsWorksheetLines.FINDSET(TRUE, FALSE) then
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        if ExternalsWorksheetLines.FINDSET(TRUE) then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ExternalsWorksheetLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ExternalsWorksheetLines."Dimension Set ID" <> NewDimSetID then begin
                    ExternalsWorksheetLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ExternalsWorksheetLines."Dimension Set ID", ExternalsWorksheetLines."Shortcut Dimension 1 Code", ExternalsWorksheetLines."Shortcut Dimension 2 Code");
                    ExternalsWorksheetLines.MODIFY;
                end;
            until ExternalsWorksheetLines.NEXT = 0;
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

    //     procedure FunFilterResponsibility (var SheetToFilter@1000000000 :
    procedure FunFilterResponsibility(var SheetToFilter: Record 7206933)
    begin
        ////FunctionQB.SetUserJobWorksheetFilter(SheetToFilter);
    end;

    /*begin
    end.
  */
}








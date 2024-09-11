table 7207362 "QBU Usage Header"
{


    CaptionML = ENU = 'Usage Header', ESP = 'Cabecera utilizaci�n';
    LookupPageID = "Usage List";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header" WHERE("Customer/Vendor No." = FIELD("Customer/Vendor No."),
                                                                                                  "Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Contract Code', ESP = 'C�d. Contrato';
            Description = 'Maestra a la que apunta el documento';

            trigger OnValidate();
            BEGIN
                //Traemos todos los datos que queramos de la Maestra Primaria
                GetContractHeader("Contract Code");

                Description := ElementContractHeader.Description;
                "Description 2" := ElementContractHeader."Description 2";
                IF ElementContractHeader."No." <> '' THEN BEGIN
                    VALIDATE("Customer/Vendor No.", ElementContractHeader."Customer/Vendor No.");
                    VALIDATE("Job No.", ElementContractHeader."Job No.");
                END;

                DimensionContractCopy("Contract Code", Rec."No.");
                "Vendor Contract Code" := ElementContractHeader."Vendor Contract Code";
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    RentalElementsSetup.GET;
                    CUNoSeriesManagement.TestManual(GetNoSeriesCode);
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
        field(5; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";


            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'N� Cliente/Proveedor';

            trigger OnValidate();
            BEGIN
                IF "Contract Type" = "Contract Type"::Customer THEN
                    CreateDim(DATABASE::Customer, "Customer/Vendor No.",
                               DATABASE::Job, "Job No.")
                ELSE
                    CreateDim(DATABASE::Vendor, "Customer/Vendor No.",
                               DATABASE::Job, "Job No.");
            END;


        }
        field(6; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Vendor")) "Job" ELSE IF ("Contract Type" = CONST("Customer")) "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';

            trigger OnValidate();
            BEGIN
                IF "Contract Type" = "Contract Type"::Customer THEN
                    CreateDim(DATABASE::Customer, "Customer/Vendor No.",
                               DATABASE::Job, "Job No.")
                ELSE
                    CreateDim(DATABASE::Vendor, "Customer/Vendor No.",
                               DATABASE::Job, "Job No.");
            END;


        }
        field(7; "Usage Date"; Date)
        {


            CaptionML = ENU = 'Usage Date', ESP = 'Fecha utilizaci�n';

            trigger OnValidate();
            BEGIN
                LinesExist(Rec);
            END;


        }
        field(8; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo Contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(9; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(10; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';
            Description = 'Texto opcional asignable al registrar movimientos en el diario de la maestra asociada al documento';


        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
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
        field(12; "Shortcut Dimension 2 Code"; Code[20])
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
        field(13; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(14; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(15; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Usage Comment Line" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(16; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Usage Line"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(17; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(18; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(19; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';
            Description = 'Opcional. Permite numerar determinados grupos de apuntes con otra numeraci�n';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    RentalElementsSetup.GET;
                    TestNoSeries;
                    CUNoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH UsageHeader DO BEGIN
                UsageHeader := Rec;
                RentalElementsSetup.GET;
                TestNoSeries;
                IF CUNoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := UsageHeader;
                // END;
            END;


        }
        field(20; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(21; "Vendor Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Vendor Contract Code', ESP = 'C�d. contrato proveedor';
            Editable = false;


        }
        field(22; "Preassigned Sheet Draft No."; Code[20])
        {
            CaptionML = ENU = 'Preassigned Sheet Draft No.', ESP = 'N� borrador parte preasignado';
            Editable = false;


        }
        field(23; "Next Historic No."; Code[20])
        {
            CaptionML = ENU = 'Next Historic No.', ESP = 'N� siguiente hist�rico';


        }
        field(24; "Generated Purchase"; Boolean)
        {
            CaptionML = ENU = 'Generated Purchase', ESP = 'Compra generada';


        }
        field(25; "Dimension Set ID"; Integer)
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
        //       RentalElementsSetup@7001110 :
        RentalElementsSetup: Record 7207346;
        //       UsageLine@7001109 :
        UsageLine: Record 7207363;
        //       ElementContractHeader@7001108 :
        ElementContractHeader: Record 7207353;
        //       UsageHeader@7001107 :
        UsageHeader: Record 7207362;
        //       UsageCommentLine@7001106 :
        UsageCommentLine: Record 7207364;
        //       CUNoSeriesManagement@7001105 :
        CUNoSeriesManagement: Codeunit "NoSeriesManagement";
        //       CUDimensionManagement@7001104 :
        CUDimensionManagement: Codeunit "DimensionManagement";
        CUDimensionManagement1: Codeunit "DimensionManagement1";
        //       Job@7001103 :
        Job: Record 167;
        //       HeaderDeliveryReturnElement@7001102 :
        HeaderDeliveryReturnElement: Record 7207356;
        //       OldDimSetID@7001101 :
        OldDimSetID: Integer;
        //       CUFunctionQB@7001100 :
        CUFunctionQB: Codeunit 7207272;
        //       Text003@7001112 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text051@7001111 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \\ �Desea actualizar las l�neas?';



    trigger OnInsert();
    begin
        //Aqui vamos a tomar cual es el contador desde el que vamos a generar n�meros de series.
        RentalElementsSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            CUNoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;
        if GETFILTER("Contract Code") <> '' then
            if GETRANGEMIN("Contract Code") = GETRANGEMAX("Contract Code") then
                VALIDATE("Contract Code", GETRANGEMIN("Contract Code"));

        if GETFILTER("Customer/Vendor No.") <> '' then
            if GETRANGEMIN("Customer/Vendor No.") = GETRANGEMAX("Customer/Vendor No.") then
                VALIDATE("Customer/Vendor No.", GETRANGEMIN("Customer/Vendor No."));

        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then begin
                Job.GET(GETRANGEMIN("Job No."));
                VALIDATE("Customer/Vendor No.", Job."Bill-to Customer No.");
                VALIDATE("Job No.", GETRANGEMIN("Job No."));
            end;
    end;

    trigger OnDelete();
    begin
        UsageLine.LOCKTABLE;

        //Se borran las l�neas asociadas al documento
        UsageLine.SETRANGE("Document No.", "No.");
        UsageLine.DELETEALL;

        UsageCommentLine.SETRANGE("No.", "No.");
        UsageCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    procedure InitRecord()
    begin

        CUNoSeriesManagement.SetDefaultSeries("Posting No. Series", RentalElementsSetup."No. Serie Post. Usage");

        "Posting Date" := WORKDATE;

        "Posting Description" := "No.";
    end;

    //     procedure AssistEdit (LOCUsageHeader@1000 :
    procedure AssistEdit(LOCUsageHeader: Record 7207362): Boolean;
    begin
        RentalElementsSetup.GET;
        TestNoSeries;

        if CUNoSeriesManagement.SelectSeries(GetNoSeriesCode, UsageHeader."No. Series", "No. Series") then begin
            RentalElementsSetup.GET;
            TestNoSeries;
            CUNoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    LOCAL procedure TestNoSeries(): Boolean;
    begin

        RentalElementsSetup.TESTFIELD(RentalElementsSetup."No. Serie Usage");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin

        exit(RentalElementsSetup."No. Serie Usage");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin

        exit(RentalElementsSetup."No. Serie Post. Usage");
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        //Aqui estableceremos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba

        exit(TRUE);
    end;

    //     LOCAL procedure GetContractHeader (MasterNo@1000 :
    LOCAL procedure GetContractHeader(MasterNo: Code[20])
    begin
        if MasterNo <> ElementContractHeader."No." then
            ElementContractHeader.GET(MasterNo);
    end;

    procedure LinesExistDoc(): Boolean;
    begin
        UsageLine.RESET;
        UsageLine.SETRANGE("Document No.", "No.");
        exit(UsageLine.FIND('-'));
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1100251001 : Integer;No2@1100251000 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       LOSourceCodeSetup@1010 :
        LOSourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        LOSourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        CUDimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        CUDimensionManagement.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          CUDimensionManagement.GetDefaultDimID(DefaultDimSource, LOSourceCodeSetup."Usage Document", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and LinesExistDoc then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

        DimensionContractCopy("Contract Code", Rec."No.");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        CUDimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if LinesExistDoc then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure LinesExist (LOCUsageHeader2@1100251000 :
    procedure LinesExist(LOCUsageHeader2: Record 7207362)
    var
        //       LOCUsageLine@1100251001 :
        LOCUsageLine: Record 7207363;
        //       lotext7021500@1100251002 :
        lotext7021500: TextConst ENU = 'Usage Date can not be modified in document% 1 because it already has associated lines', ESP = 'No puede modificarse la fecha de utilizaci�n en el documento %1 porque ya tiene l�neas asociadas';
    begin
        LOCUsageLine.SETRANGE(LOCUsageLine."Document No.", LOCUsageHeader2."No.");
        if LOCUsageLine.FINDFIRST then
            ERROR(lotext7021500, LOCUsageHeader2."No.");
    end;

    //     procedure DimensionContractCopy (LOcodcontrato@1100251000 : Code[20];LOcodentrega@1100251004 :
    procedure DimensionContractCopy(LOcodcontrato: Code[20]; LOcodentrega: Code[20])
    var
        //       DimensionManagement@1100251003 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       tmpDimensionSetEntry@1000 :
        tmpDimensionSetEntry: Record 480 TEMPORARY;
    begin
        tmpDimensionSetEntry.DELETEALL;
        DimensionManagement.GetDimensionSet(tmpDimensionSetEntry, "Dimension Set ID");
        if tmpDimensionSetEntry.FINDSET then
            repeat
                CUFunctionQB.UpdateDimSet(tmpDimensionSetEntry."Dimension Code", tmpDimensionSetEntry."Dimension Value Code", "Dimension Set ID");
                CUDimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            until tmpDimensionSetEntry.NEXT = 0;
    end;

    procedure ShowDocDim()
    var
        //       LOCOldDimSetID@1000 :
        LOCOldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          CUDimensionManagement1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if LinesExistDoc then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        UsageLine.RESET;
        UsageLine.SETRANGE("Document No.", "No.");
        UsageLine.LOCKTABLE;
        if UsageLine.FIND('-') then
            repeat
                NewDimSetID := CUDimensionManagement.GetDeltaDimSetID(UsageLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if UsageLine."Dimension Set ID" <> NewDimSetID then begin
                    UsageLine."Dimension Set ID" := NewDimSetID;
                    CUDimensionManagement.UpdateGlobalDimFromDimSetID(
                      UsageLine."Dimension Set ID", UsageLine."Shortcut Dimension 1 Code", UsageLine."Shortcut Dimension 2 Code");
                    UsageLine.MODIFY;
                end;
            until UsageLine.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}








table 7206934 "QB External Worksheet Lines"
{


    CaptionML = ENU = 'Externals Worksheet Lines', ESP = 'Lineas parte de trabajo de Externos';
    LookupPageID = "QB WorkSheet Lines  P. Subform";
    DrillDownPageID = "QB WorkSheet Lines  P. Subform";

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
        field(10; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor No.', ESP = 'Proveedor';

            trigger OnValidate();
            BEGIN
                CreateDim;
            END;


        }
        field(11; "Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Status" = FILTER("Open"),
                                                                                "Card Type" = CONST("Proyecto operativo"),
                                                                                "Job Type" = FILTER("Operative"));


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                CreateDim;
            END;


        }
        field(12; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));
            CaptionML = ENU = 'Piecework No.', ESP = 'N� unidad de obra';


        }
        field(13; "Resource No."; Code[20])
        {
            TableRelation = Resource WHERE("Type" = CONST("ExternalWorker"));


            CaptionML = ENU = 'Resource No.', ESP = 'N� recurso';

            trigger OnValidate();
            BEGIN
                Resource.GET("Resource No.");
                IF Resource.Blocked = TRUE THEN
                    ERROR(Text004);

                Description := Resource.Name;

                // Traer los costes
                FindResUnitCost("Resource No.", "Work Type Code");
                FindResPrice("Job No.");
                FindPriceTransfer;

                CreateDim;
            END;


        }
        field(14; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(15; "Work Type Code"; Code[10])
        {
            TableRelation = "Work Type";


            CaptionML = ENU = 'Work Type Code', ESP = 'C�d. tipo de trabajo';
            NotBlank = true;

            trigger OnValidate();
            VAR
                //                                                                 recWorkType@1000000000 :
                recWorkType: Record 200;
            BEGIN
                recWorkType.GET("Work Type Code");

                FindResUnitCost("Resource No.", "Work Type Code");
                FindResPrice("Job No.");
                FindPriceTransfer;

                CreateDim;
            END;


        }
        field(20; "Work Day Date"; Date)
        {


            CaptionML = ENU = 'Work Day Date', ESP = 'Fecha d�a de trabajo';

            trigger OnValidate();
            BEGIN
                QBExternalWorksheetHeader.GET("Document No.");
                AllocationTerm.GET(QBExternalWorksheetHeader."Allocation Term");
                IF ("Work Day Date" < AllocationTerm."Initial Date") OR ("Work Day Date" > AllocationTerm."Final Date") THEN
                    ERROR(Text005);
            END;


        }
        field(21; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';

            trigger OnValidate();
            BEGIN
                VALIDATE("Total Cost");
            END;


        }
        field(22; "Cost Price"; Decimal)
        {


            CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                VALIDATE("Total Cost");
            END;


        }
        field(23; "Total Cost"; Decimal)
        {


            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                "Total Cost" := ROUND(Quantity * "Cost Price", Currency."Amount Rounding Precision");
            END;


        }
        field(31; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(32; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(480; "Dimension Set ID"; Integer)
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
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBExternalWorksheetHeader@7001100 :
        QBExternalWorksheetHeader: Record 7206933;
        //       Text000@7001103 :
        Text000: TextConst ENU = 'You cannot rename to %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Job@7001105 :
        Job: Record 167;
        //       Resource@7001109 :
        Resource: Record 156;
        //       ResourceCost@7001110 :
        ResourceCost: Record 202;
        //       ResourcePrice@7001113 :
        ResourcePrice: Record 201;
        //       Text004@7001115 :
        Text004: TextConst ENU = 'The Resource is Blocked', ESP = 'El recurso est� bloqueado';
        //       WorkType@1100286004 :
        WorkType: Record 200;
        //       AllocationTerm@7001116 :
        AllocationTerm: Record 7207297;
        //       Text005@7001117 :
        Text005: TextConst ENU = 'Entered date is not in allocation term', ESP = '"La fecha introducida no est� dentro del periodo de imputaci�n "';
        //       Currency@7001118 :
        Currency: Record 4;
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;
        //       DimMgt@1100286003 :
        DimMgt: Codeunit "DimensionManagement";
        //       ResFindUnitCost@1100286002 :
        ResFindUnitCost: Codeunit 220;
        //       ResFindUnitPrice@1100286000 :
        ResFindUnitPrice: Codeunit 221;



    trigger OnInsert();
    begin
        GetHeader;
    end;

    trigger OnModify();
    begin
        GetHeader;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    // procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    LOCAL procedure GetHeader()
    begin
        if QBExternalWorksheetHeader.GET("Document No.") then
            "Vendor No." := QBExternalWorksheetHeader."Vendor No.";
    end;

    //     LOCAL procedure FindResUnitCost (CodeResource@1000000000 : Code[20];CodeType@1100286000 :
    LOCAL procedure FindResUnitCost(CodeResource: Code[20]; CodeType: Code[20])
    begin
        if (CodeResource <> '') then begin
            ResourceCost.INIT;
            ResourceCost.Code := CodeResource;
            ResourceCost."Work Type Code" := CodeType;
            ResFindUnitCost.RUN(ResourceCost);

            VALIDATE("Cost Price", ResourceCost."Direct Unit Cost");
        end;
    end;

    //     LOCAL procedure FindResPrice (var CodeJob@1000000000 :
    LOCAL procedure FindResPrice(var CodeJob: Code[20])
    begin
        if (CodeJob <> '') then begin
            ResourcePrice.INIT;
            ResourcePrice."Job No." := CodeJob;
            ResourcePrice.Code := "Resource No.";
            ResourcePrice."Work Type Code" := "Work Type Code";
            ResFindUnitPrice.RUN(ResourcePrice);
        end;
    end;

    procedure FindPriceTransfer()
    var
        //       locResource@1000000000 :
        locResource: Record 156;
        //       locJob@1000000001 :
        locJob: Record 167;
        //       locResourceGroup@1000000004 :
        locResourceGroup: Record 152;
        //       FunctionQB@1000000002 :
        FunctionQB: Codeunit 7207272;
        //       locPriceCostTransfer@1000000003 :
        locPriceCostTransfer: Record 7207299;
        //       Procesar@1100286000 :
        Procesar: Boolean;
    begin
        if not locJob.GET("Job No.") then
            exit;
        if not locResource.GET("Resource No.") then
            exit;

        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 then begin
            if locResource."Global Dimension 1 Code" <> locJob."Global Dimension 1 Code" then begin
                locPriceCostTransfer.RESET;
                locPriceCostTransfer.SETFILTER(locPriceCostTransfer.Type, '%1', locPriceCostTransfer.Type::Resource);
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer.Code, locResource."No.");
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer."Cod. Dept.", '<>%1', locResource."Global Dimension 1 Code");
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer."Cod. Dept.", locJob."Global Dimension 1 Code");
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer."Work Type Code", "Work Type Code");
                if locPriceCostTransfer.FINDFIRST then
                    VALIDATE("Cost Price", locPriceCostTransfer."Unit Cost");
            end;
        end;

        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 then begin
            if locResource."Global Dimension 2 Code" <> locJob."Global Dimension 2 Code" then begin
                locPriceCostTransfer.RESET;
                locPriceCostTransfer.SETFILTER(locPriceCostTransfer.Type, '%1', locPriceCostTransfer.Type::Resource);
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer.Code, locResource."No.");
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer."Cod. Dept.", '<>%1', locResource."Global Dimension 2 Code");
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer."Cod. Dept.", locJob."Global Dimension 2 Code");
                locPriceCostTransfer.SETRANGE(locPriceCostTransfer."Work Type Code", "Work Type Code");
                if locPriceCostTransfer.FINDFIRST then
                    VALIDATE("Cost Price", locPriceCostTransfer."Unit Cost");
            end;
        end;
    end;

    procedure CreateDim()
    var
        //       SourceCodeSetup@1008 :
        SourceCodeSetup: Record 242;
        //       TableID@1009 :
        TableID: ARRAY[10] OF Integer;
        //       No@1010 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        TableID[1] := DATABASE::Vendor;
        No[1] := "Vendor No.";
        TableID[2] := DATABASE::Job;
        No[2] := "Job No.";
        TableID[3] := DATABASE::Resource;
        No[3] := "Resource No.";


        SourceCodeSetup.GET;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[3], No[3]);

        "Dimension Set ID" := DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup.WorkSheet, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if Resource.GET("Resource No.") then begin
            if not ResourceCost.GET(ResourceCost.Type::Resource, "Resource No.", "Work Type Code") then
                if not ResourceCost.GET(ResourceCost.Type::"Group(Resource)", Resource."Resource Group No.", "Work Type Code") then
                    exit;

            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then
                VALIDATE("Shortcut Dimension 1 Code", ResourceCost."C.A. Direct Cost Allocation")
            else if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 then
                VALIDATE("Shortcut Dimension 2 Code", ResourceCost."C.A. Direct Cost Allocation");
        end;
    end;

    procedure ShowDimensions()
    begin
        if ("Document No." <> '') and ("Line No." <> 0) then begin
            "Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        end;
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    /*begin
    //{
//      GAP014 QMD 20/09/19 - VSTS 7594 GAP014. Descompuestos - Unidades de medida - Informe importaci�n Excel
//    }
    end.
  */
}








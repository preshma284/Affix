table 7207291 "WorkSheet Lines qb"
{


    CaptionML = ESP = 'Lineas parte de trabajo';
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
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(7; "Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Status" = FILTER("Open"));


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                recTempWorkSheetLines := Rec;

                GetHeader;
                IF (WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Job") THEN
                    WorkSheetHeader.TESTFIELD("No. Resource /Job");

                ControlStatusBlockedType;
                GetDescription;
                RecJob.ControlJob(RecJob);

                CreateDim;

                FindResUnitCost("Resource No.");
                FindResPrice("Job No.");
                FindPriceTransfer;

                AssignJobDept;
            END;


        }
        field(8; "Resource No."; Code[20])
        {
            TableRelation = Resource WHERE("Type" = FILTER('Person' | 'Machine'));


            CaptionML = ENU = 'Resource No.', ESP = 'N� recurso';
            Description = 'PER 20.03.19 Distinto subcontratado -> QB 1.06.10 JAV 20/08/20: - Que sea persona o m�quina expresamente';

            trigger OnValidate();
            BEGIN
                recTempWorkSheetLines := Rec;

                GetHeader;
                IF (WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Resource") THEN
                    WorkSheetHeader.TESTFIELD("No. Resource /Job");

                CreateDim;

                RecResource.GET("Resource No.");
                IF RecResource.Blocked = TRUE THEN
                    ERROR(Text004);
                GetDescription;

                // Traer los costes
                FindResUnitCost("Resource No.");
                FindResPrice("Job No.");
                FindPriceTransfer;
            END;


        }
        field(9; "Work Day Date"; Date)
        {


            CaptionML = ENU = 'Work Day Date', ESP = 'Fecha d�a de trabajo';

            trigger OnValidate();
            BEGIN
                WorkSheetHeader.GET("Document No.");
                IF WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Resource" THEN BEGIN
                    AllocationTerm.GET(WorkSheetHeader."Allocation Term");
                    IF ("Work Day Date" < AllocationTerm."Initial Date") OR
                       ("Work Day Date" > AllocationTerm."Final Date") THEN
                        ERROR(Text005);
                END;
            END;


        }
        field(10; "Work Type Code"; Code[10])
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
                "Compute In Hours" := recWorkType."Compute Hours";

                FindResUnitCost("Resource No.");
                FindResPrice("Job No.");
                FindPriceTransfer;
            END;


        }
        field(11; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';

            trigger OnValidate();
            BEGIN
                CostAndSaleTotal;
            END;


        }
        field(12; "Direct Cost Price"; Decimal)
        {
            CaptionML = ENU = 'Direct Cost Price', ESP = 'Precio coste directo';
            AutoFormatType = 2;


        }
        field(13; "Cost Price"; Decimal)
        {


            CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CostAndSaleTotal;
            END;


        }
        field(14; "Total Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            AutoFormatType = 2;


        }
        field(15; "Sales Price"; Decimal)
        {


            CaptionML = ENU = 'Sales Price', ESP = 'Precio venta';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CostAndSaleTotal;
            END;

            trigger OnLookup();
            BEGIN
                CostAndSaleTotal;
            END;


        }
        field(16; "Sale Amount"; Decimal)
        {
            CaptionML = ENU = 'Sale Amount', ESP = 'Importe venta';
            AutoFormatType = 1;


        }
        field(17; "Invoiced"; Boolean)
        {
            CaptionML = ENU = 'Invoiced', ESP = 'Facturable';


        }
        field(18; "Principal"; Boolean)
        {
            CaptionML = ENU = 'Principal', ESP = 'Principal';


        }
        field(19; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));
            CaptionML = ENU = 'Piecework No.', ESP = 'N� unidad de obra';


        }
        field(20; "Compute In Hours"; Boolean)
        {
            CaptionML = ENU = 'Compute In Hours', ESP = 'Computa en horas';
            Editable = false;


        }
        field(21; "Lines Group"; Integer)
        {
            CaptionML = ENU = 'Lines Group', ESP = 'Grupo de l�neas';


        }
        field(100; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Job Task No.', ESP = 'N� tarea proyecto';
            NotBlank = true;

            trigger OnValidate();
            VAR
                //                                                                 Job@1000 :
                Job: Record 167;
                //                                                                 Cust@1001 :
                Cust: Record 18;
            BEGIN
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
        key(key2; "Compute In Hours", "Document No.")
        {
            ;
        }
        key(key3; "Document No.", "Job No.", "Work Day Date")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@1100286005 :
        QuoBuildingSetup: Record 7207278;
        //       WorkSheetHeader@7001100 :
        WorkSheetHeader: Record 7207290;
        //       recWorkSheetLines2@7001102 :
        recWorkSheetLines2: Record 7207291;
        //       recTempWorkSheetLines@7001101 :
        recTempWorkSheetLines: Record 7207291;
        //       Text000@7001103 :
        Text000: TextConst ENU = 'You cannot rename to %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       RecJob@7001105 :
        RecJob: Record 167;
        //       Text001@7001108 :
        Text001: TextConst ENU = 'Type Job must be Operative', ESP = 'El tipo de proyecto debe ser operativo';
        //       Text002@7001107 :
        Text002: TextConst ENU = 'Job Status must be Order', ESP = 'El Estado del proyecto debe ser Pedido';
        //       Text003@7001106 :
        Text003: TextConst ENU = 'Job is Blocked', ESP = 'El proyecto est� bloqueado';
        //       RecResource@7001109 :
        RecResource: Record 156;
        //       ResCost@7001110 :
        ResCost: Record 202;
        //       ResPrice@7001113 :
        ResPrice: Record 201;
        //       Text004@7001115 :
        Text004: TextConst ENU = 'The Resource is Blocked', ESP = 'El recurso est� bloqueado';
        //       AllocationTerm@7001116 :
        AllocationTerm: Record 7207297;
        //       Text005@7001117 :
        Text005: TextConst ENU = 'Entered date is not in allocation term', ESP = '"La fecha introducida no est� dentro del periodo de imputaci�n "';
        //       Currency@7001118 :
        Currency: Record 4;
        //       DimMgt@1100286004 :
        DimMgt: Codeunit "DimensionManagement";
        //       ResFindUnitCost@1100286003 :
        ResFindUnitCost: Codeunit 220;
        //       FunctionQB@1100286002 :
        FunctionQB: Codeunit 7207272;
        //       ResFindUnitPrice@1100286001 :
        ResFindUnitPrice: Codeunit 221;
        //       Modi@1100286000 :
        Modi: Boolean;



    trigger OnInsert();
    begin
        LOCKTABLE;
        WorkSheetHeader."No." := '';
        FunSortMatrixsheet(FALSE);

        VALIDATE(Invoiced, TRUE);
    end;

    trigger OnDelete();
    begin
        FunSortMatrixsheet(TRUE);
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    // procedure FunSortMatrixsheet (parbooldelete@1000000003 :
    procedure FunSortMatrixsheet(parbooldelete: Boolean)
    var
        //       dateAux@1000000000 :
        dateAux: Date;
        //       intAux@1000000001 :
        intAux: Integer;
        //       ActualDate@1000000002 :
        ActualDate: Date;
    begin
        // Esta funcion tiene como fin el reordenar todas las lineas para ver cual debe salir o no en un parte matricial
        recWorkSheetLines2.RESET();
        if WorkSheetHeader.GET("Document No.") then begin
            if WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Job" then
                recWorkSheetLines2.SETCURRENTKEY(recWorkSheetLines2."Document No.", recWorkSheetLines2."Resource No.", recWorkSheetLines2."Work Day Date")
            else
                recWorkSheetLines2.SETCURRENTKEY(recWorkSheetLines2."Document No.", recWorkSheetLines2."Job No.", recWorkSheetLines2."Work Day Date");
        end;

        dateAux := DMY2DATE(1, 1, 1980);
        intAux := -1;

        recWorkSheetLines2.SETRANGE("Document No.", "Document No.");
        if WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Job" then
            recWorkSheetLines2.SETRANGE("Resource No.", "Resource No.")
        else
            recWorkSheetLines2.SETRANGE("Job No.", "Job No.");

        if parbooldelete then
            recWorkSheetLines2.SETFILTER("Line No.", '<>%1', "Line No.");

        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if recWorkSheetLines2.FINDSET(TRUE,TRUE) then
        if recWorkSheetLines2.FINDSET(TRUE) then
            repeat
                ActualDate := recWorkSheetLines2."Work Day Date";
                recWorkSheetLines2.Principal := FALSE;
                if dateAux <> ActualDate then begin
                    dateAux := ActualDate;
                    intAux := recWorkSheetLines2."Line No.";
                    recWorkSheetLines2.Principal := TRUE;
                end;
                recWorkSheetLines2."Lines Group" := intAux;
                recWorkSheetLines2.MODIFY();
            until recWorkSheetLines2.NEXT() = 0;

        if WorkSheetHeader.GET("Document No.") then
            if WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Resource" then
                exit;

        recWorkSheetLines2.RESET;
        recWorkSheetLines2.SETRANGE("Document No.", "Document No.");
        recWorkSheetLines2.SETRANGE("Resource No.", "Resource No.");
        recWorkSheetLines2.SETRANGE("Work Day Date", "Work Day Date");
        recWorkSheetLines2.SETRANGE(Principal, TRUE);
        if recWorkSheetLines2.FINDFIRST then begin
            if recWorkSheetLines2.COUNT = 1 then begin
                Principal := TRUE;
                "Lines Group" := "Line No.";
            end else begin
                Principal := FALSE;
                "Lines Group" := recWorkSheetLines2."Line No.";
            end;
        end else begin
            Principal := TRUE;
            "Lines Group" := "Line No.";
        end;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    LOCAL procedure GetHeader()
    begin
        TESTFIELD("Document No.");
        if "Document No." <> WorkSheetHeader."No." then
            WorkSheetHeader.GET("Document No.");

        CASE WorkSheetHeader."Sheet Type" OF
            WorkSheetHeader."Sheet Type"::"By Resource":
                "Resource No." := WorkSheetHeader."No. Resource /Job";
            WorkSheetHeader."Sheet Type"::"By Job":
                "Job No." := WorkSheetHeader."No. Resource /Job";
        end;
    end;

    procedure ControlStatusBlockedType()
    begin
        RecJob.GET("Job No.");
        if RecJob."Job Type" = RecJob."Job Type"::Deviations then
            ERROR(Text001);
        if RecJob.Status <> RecJob.Status::Open then
            ERROR(Text002);
        if RecJob.Blocked <> RecJob.Blocked::" " then
            ERROR(Text003);
    end;

    procedure GetDescription()
    begin
        WorkSheetHeader.GET("Document No.");
        if WorkSheetHeader."Sheet Type" = WorkSheetHeader."Sheet Type"::"By Resource" then begin
            RecJob.RESET;
            if RecJob.GET("Job No.") then
                Description := RecJob.Description;
        end else begin
            RecResource.RESET;
            if RecResource.GET("Resource No.") then
                Description := RecResource.Name;
        end;
    end;

    //     LOCAL procedure FindResUnitCost (var CodeResource@1000000000 :
    LOCAL procedure FindResUnitCost(var CodeResource: Code[20])
    begin
        if (CodeResource <> '') then begin
            ResCost.INIT;
            ResCost.Code := CodeResource;
            ResCost."Work Type Code" := "Work Type Code";
            ResFindUnitCost.RUN(ResCost);
            "Cost Price" := ResCost."Unit Cost";
            "Direct Cost Price" := ResCost."Direct Unit Cost";

            if not QuoBuildingSetup.GET() then
                QuoBuildingSetup.INIT;

            //JAV 26/04/22: - QB 1.10.37 En INESCO se usa por defecto la CA de indirectos. Esta soluci�n no es buena, porque despu�s lo puede cambiar a la hora de registrar
            if FunctionQB.IsClient('INE') then
                FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, ResCost."C.A. Indirect Cost Allocation", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID")
            else
                FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, ResCost."C.A. Direct Cost Allocation", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID");

            VALIDATE("Cost Price");
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
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;

        TableID[1] := DATABASE::Job;
        No[1] := "Job No.";
        TableID[2] := DATABASE::Resource;
        No[2] := "Resource No.";

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        "Dimension Set ID" := DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup.WorkSheet, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     LOCAL procedure FindResPrice (var CodeJob@1000000000 :
    LOCAL procedure FindResPrice(var CodeJob: Code[20])
    begin
        if (CodeJob <> '') then begin
            ResPrice.INIT;
            ResPrice."Job No." := CodeJob;
            ResPrice.Code := "Resource No.";
            ResPrice."Work Type Code" := "Work Type Code";
            ResFindUnitPrice.RUN(ResPrice);
            "Sales Price" := ResPrice."Unit Price";
            VALIDATE("Sales Price");
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
                if locPriceCostTransfer.FINDFIRST then begin
                    VALIDATE("Cost Price", locPriceCostTransfer."Unit Cost");
                    VALIDATE("Direct Cost Price", locPriceCostTransfer."Unit Cost");

                end;
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
                if locPriceCostTransfer.FINDFIRST then begin
                    VALIDATE("Cost Price", locPriceCostTransfer."Unit Cost");
                    VALIDATE("Direct Cost Price", locPriceCostTransfer."Unit Cost");
                end;
            end;
        end;
    end;

    procedure AssignJobDept()
    var
        //       locJob@1000000000 :
        locJob: Record 167;
    begin
        //Se asigna a la l�nea el Dpto del proyecto
        if locJob.GET("Job No.") then begin
            ;
            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 then
                VALIDATE("Shortcut Dimension 1 Code", locJob."Global Dimension 1 Code");

            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 then
                VALIDATE("Shortcut Dimension 2 Code", locJob."Global Dimension 2 Code");
        end;
    end;

    procedure CostAndSaleTotal()
    begin

        CLEAR(Currency);
        Currency.InitRoundingPrecision;

        "Total Cost" := ROUND(Quantity * "Cost Price", Currency."Amount Rounding Precision");
        "Sale Amount" := ROUND(Quantity * "Sales Price", Currency."Amount Rounding Precision");

        if Quantity <> xRec.Quantity then
            "Total Cost" := ROUND(Quantity * "Cost Price", Currency."Amount Rounding Precision");
        if Quantity <> xRec.Quantity then
            "Sale Amount" := ROUND(Quantity * "Sales Price", Currency."Amount Rounding Precision");

        if "Cost Price" <> xRec."Cost Price" then
            "Total Cost" := ROUND(Quantity * "Cost Price", Currency."Amount Rounding Precision");
        if "Sale Amount" <> xRec."Sale Amount" then
            "Sale Amount" := ROUND(Quantity * "Sales Price", Currency."Amount Rounding Precision");
    end;

    procedure ShowDimensions()
    begin

        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     procedure CalcTotalAmounts (WorksheetHeader@7001104 :
    procedure CalcTotalAmounts(WorksheetHeader: Record 7207290): Decimal;
    var
        //       WorkSheetLines@7001101 :
        WorkSheetLines: Record 7207291;
        //       DataPricesVendor@7001100 :
        DataPricesVendor: Record 7207415;
        //       TotalAmounts@7001103 :
        TotalAmounts: Decimal;
    begin
        /*To be Tested*/
        //WITH WorkSheetLines DO begin
        WorkSheetLines.SETRANGE("Document No.", WorksheetHeader."No.");
        if FINDSET then
            repeat
                TotalAmounts += "Sale Amount";
            until NEXT = 0;
        // end;
        exit(TotalAmounts);
    end;

    /*begin
    //{
//      QMD 20/09/19: - VSTS 7594 GAP014. Descompuestos - Unidades de medida - Informe importaci�n Excel
//      JAV 26/04/22: - QB 1.10.37 En INESCO se usa por defecto la CA de indirectos. ESTA SOLUCION NO ES BUENA, porque despu�s lo puede cambiar a la hora de registrar
//    }
    end.
  */
}








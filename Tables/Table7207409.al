table 7207409 "QBU Line Regularization Stock"
{


    CaptionML = ENU = 'Line Regularization Stock', ESP = 'L�neas regularizaci�n stock';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Blocked" = CONST(" "),
                                                                            "Management By Production Unit" = CONST(true));


            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            Editable = true;

            trigger OnValidate();
            BEGIN
                IF Job.GET("Job No.") THEN;
                IF Job.Blocked <> Job.Blocked::" " THEN
                    ERROR(Text002);

                // Se controla que el almacen sea el mismo que el de la cabecera
                HeaderRegularizationStock.GET("Document No.");
                IF "Job No." <> '' THEN
                    IF Job."Job Location" <> HeaderRegularizationStock."Location Code" THEN
                        ERROR(Text004);

                IF "Job No." <> xRec."Job No." THEN
                    "Piecework No." := '';

                CreateDim(DATABASE::Item, "Item No.", DATABASE::Job, "Job No.");
            END;

            trigger OnLookup();
            BEGIN
                HeaderRegularizationStock.GET("Document No.");
                Job.SETRANGE("Management By Production Unit", TRUE);
                Job.SETRANGE("Job Location", HeaderRegularizationStock."Location Code");
                IF PAGE.RUNMODAL(PAGE::"Job List", Job) = ACTION::LookupOK THEN
                    "Job No." := Job."No."
                ELSE
                    "Job No." := xRec."Job No.";

                IF "Job No." <> '' THEN
                    VALIDATE("Job No.");
            END;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';


        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item WHERE("Blocked" = FILTER(false));


            CaptionML = ENU = 'Item No.', ESP = 'No. producto';

            trigger OnValidate();
            BEGIN
                LineRegularizationStock := Rec;
                INIT;
                "Item No." := LineRegularizationStock."Item No.";
                IF "Item No." = '' THEN
                    EXIT;

                GetMasterHeader;
                HeaderRegularizationStock.TESTFIELD("Location Code");
                "Job No." := HeaderRegularizationStock."Location Code";

                Item.GET("Item No.");
                Description := Item.Description;
                "Unit of Measure Cod." := Item."Base Unit of Measure";
                IF Item.Blocked THEN
                    ERROR(Text001);

                CreateDim(DATABASE::Item, "Item No.", DATABASE::Job, "Job No.");
                "Cancel Mov." := 0;

                GetExistYCteProd("Item No.");
            END;


        }
        field(5; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(8; "Calculated Stocks"; Decimal)
        {
            CaptionML = ENU = 'Calculated Stocks', ESP = 'Existencias calculadas';
            DecimalPlaces = 0 : 5;
            Description = 'Q13606';
            Editable = false;


        }
        field(9; "Current Stocks"; Decimal)
        {


            CaptionML = ENU = 'Current Stocks', ESP = 'Existencias actuales';
            DecimalPlaces = 0 : 5;
            Description = 'Q13606';

            trigger OnValidate();
            BEGIN
                CalcAdjusted;
                //-AML 24/03/22 QB_ST01
                CalcUnitCost;
                //+AML 24/03/22 QB_ST01
                CalcCostTotal;
            END;


        }
        field(10; "Adjusted"; Decimal)
        {


            CaptionML = ENU = 'Adjusted', ESP = 'Ajuste';
            DecimalPlaces = 0 : 5;
            Description = 'Q13606';

            trigger OnValidate();
            BEGIN
                CalcExisCurrent;
                //-AML 24/03/22 QB_ST01
                CalcUnitCost;
                //+AML 24/03/22 QB_ST01
                CalcCostTotal;
            END;


        }
        field(11; "Unit Cost"; Decimal)
        {


            CaptionML = ENU = 'Unit Cost', ESP = 'Precio coste';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CalcCostTotal;
            END;


        }
        field(12; "Piecework No."; Text[20])
        {


            CaptionML = ENU = 'Piecework No.', ESP = 'No. unidad de obra';

            trigger OnValidate();
            BEGIN
                ControlPiecework;
            END;

            trigger OnLookup();
            BEGIN
                DataPieceworkForProduction.RESET;
                GetMasterHeader;
                DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                IF PAGE.RUNMODAL(PAGE::"Data Piecework List", DataPieceworkForProduction) = ACTION::LookupOK THEN
                    VALIDATE("Piecework No.", DataPieceworkForProduction."Piecework Code");
            END;


        }
        field(13; "Total Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            AutoFormatType = 2;


        }
        field(14; "Unit of Measure Cod."; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure Cod.', ESP = 'Cod. unidad de medida';


        }
        field(15; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';


        }
        field(16; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(100; "Cancel Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB_ST01 Solo para uso en anulaciones';


        }
        field(101; "Cancel Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB_ST01 Solo para uso en anulaciones';


        }
        field(102; "Cancel Mov."; Integer)
        {
            TableRelation = "Item Ledger Entry"."Entry No." WHERE("Item No." = FIELD("Item No."),
                                                                                                        "Job No." = FIELD("Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cancel Mov.', ESP = 'Mov. Cancelado';
            Description = 'QB_ST01 Solo para uso en anulaciones';

            trigger OnValidate();
            VAR
                //                                                                 ItemLdgEntry@1100286000 :
                ItemLdgEntry: Record 32;
                //                                                                 GeneralLedgerSetup@1100286001 :
                GeneralLedgerSetup: Record 98;
            BEGIN
                GeneralLedgerSetup.GET;
                IF "Cancel Mov." <> 0 THEN BEGIN
                    IF ItemLdgEntry.GET("Cancel Mov.") THEN BEGIN
                        ItemLdgEntry.CALCFIELDS("Cost Amount (Expected)", ItemLdgEntry."Cost Amount (Actual)");
                        IF Adjusted > ItemLdgEntry."Remaining Quantity" THEN VALIDATE(Adjusted, ItemLdgEntry."Remaining Quantity");
                        VALIDATE("Unit Cost", ROUND((ItemLdgEntry."Cost Amount (Expected)" + ItemLdgEntry."Cost Amount (Actual)") / ItemLdgEntry.Quantity, GeneralLedgerSetup."Unit-Amount Rounding Precision"));
                        IF ItemLdgEntry.Positive THEN VALIDATE("Calculated Stocks", ItemLdgEntry."Remaining Quantity") ELSE VALIDATE("Calculated Stocks", ItemLdgEntry.Quantity);
                    END;
                END
                ELSE
                    AdjustQuantitiesAndUnitCost;
            END;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(key2; "Document No.", "Job No.")
        {
            SumIndexFields = "Total Cost";
        }
    }
    fieldgroups
    {
    }

    var
        //       HeaderRegularizationStock@7001100 :
        HeaderRegularizationStock: Record 7207408;
        //       Text000@7001101 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Job@7001102 :
        Job: Record 167;
        //       Text002@7001103 :
        Text002: TextConst ENU = 'The job is locked', ESP = 'El proyecto est� bloqueado';
        //       Text004@7001104 :
        Text004: TextConst ENU = 'The job has no associated the same store as the header', ESP = 'El proyecto no tiene asociado el mismo almacen que la cabecera';
        //       DimensionManagement@7001105 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       LineRegularizationStock@7001106 :
        LineRegularizationStock: Record 7207409;
        //       Item@7001107 :
        Item: Record 27;
        //       Text001@7001108 :
        Text001: TextConst ENU = 'The item is locked', ESP = 'El producto est� bloqueado';
        //       StockkeepingUnit@7001109 :
        StockkeepingUnit: Record 5700;
        //       DataPieceworkForProduction@7001110 :
        DataPieceworkForProduction: Record 7207386;
        //       text003@7001111 :
        text003: TextConst ENU = 'The selected work unit does not belong to the job', ESP = 'La unidad de obra seleccionada no pertenece al proyecto';
        //       Text005@1100286000 :
        Text005: TextConst ENU = 'You cannot report the "Cost Unit" for Stockpiles', ESP = 'No puede informar la "Unidad de coste" para Acopios';



    trigger OnInsert();
    begin
        LOCKTABLE;
        HeaderRegularizationStock."No." := '';
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    // procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1003 : Integer;No2@1002 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
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
        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        GetMasterHeader;
        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Stock Regularization", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            HeaderRegularizationStock."Dimension Set ID", DATABASE::Job);
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    LOCAL procedure GetMasterHeader()
    begin
        // Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");
        HeaderRegularizationStock.GET("Document No.")
    end;

    //     procedure GetExistYCteProd (CProd@1000 :
    procedure GetExistYCteProd(CProd: Code[20])
    var
        //       LItem@1001 :
        LItem: Record 27;
    begin
        LItem.RESET;
        LItem.GET(CProd);

        // Se filtra por el almacen de la cabecera
        HeaderRegularizationStock.GET("Document No.");
        LItem.SETRANGE("Location Filter", HeaderRegularizationStock."Location Code");

        LItem.CALCFIELDS(Inventory);
        "Calculated Stocks" := ROUND(LItem.Inventory, 0.00001);  //JAV 10/06/21: - QB 1.08.48 Ajustamos decimales al m�ximo del campo para evitar errores de redondeos


        // El c�d. de Variante siempre es Blanco (Si existe el precio en Ud. de almacenamiento se trata este si no el de la ficha del prod.)
        if StockkeepingUnit.GET(HeaderRegularizationStock."Location Code", CProd, '') then
            "Unit Cost" := StockkeepingUnit."Unit Cost"
        else
            "Unit Cost" := LItem."Unit Cost";

        CalcAdjusted;
        CalcCostTotal;

        //Q16439 CPA 22-02-22.begin
        AdjustQuantitiesAndUnitCost;
        //Q16439 CPA 22-02-22.end
    end;

    procedure CalcAdjusted()
    begin
        Adjusted := "Current Stocks" - "Calculated Stocks";
    end;

    procedure CalcCostTotal()
    begin

        "Total Cost" := "Unit Cost" * Adjusted;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure CalcExisCurrent()
    begin
        "Current Stocks" := Adjusted + "Calculated Stocks";
    end;

    procedure ControlPiecework()
    begin
        DataPieceworkForProduction.RESET;
        if "Piecework No." <> '' then begin
            if not DataPieceworkForProduction.GET("Job No.", "Piecework No.") then
                ERROR(text003);

            //QBU17146 11/05/22 CSM � La unidad no pued ser la de almac�n
            Job.GET("Job No.");
            if "Piecework No." = Job."Warehouse Cost Unit" then
                ERROR(Text005);
        end;
    end;

    procedure ShowDimensions()
    begin
        // Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        // Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    LOCAL procedure AdjustQuantitiesAndUnitCost()
    var
        //       ItemLedgerEntry@1100286000 :
        ItemLedgerEntry: Record 32;
        //       Cantidad@1100286003 :
        Cantidad: Decimal;
        //       CantidadPendiente@1100286002 :
        CantidadPendiente: Decimal;
        //       ImportePendiente@1100286001 :
        ImportePendiente: Decimal;
        //       CosteUnitarioPonderado@1100286007 :
        CosteUnitarioPonderado: Decimal;
        //       CantePendienteTotal@1100286004 :
        CantePendienteTotal: Decimal;
        //       CantPte@1100286005 :
        CantPte: Decimal;
        //       CantMov@1100286006 :
        CantMov: Decimal;
        //       CosteMov@1100286008 :
        CosteMov: Decimal;
        //       GLSetup@1100286009 :
        GLSetup: Record 98;
        //       ItemLdgEntry@1100286010 :
        ItemLdgEntry: Record 32;
        //       GeneralLedgerSetup@1100286011 :
        GeneralLedgerSetup: Record 98;
    begin
        //Q16439 CPA 22-02-22.begin
        GeneralLedgerSetup.GET;
        if "Cancel Mov." <> 0 then begin
            if ItemLdgEntry.GET("Cancel Mov.") then begin
                ItemLdgEntry.CALCFIELDS("Cost Amount (Expected)", ItemLdgEntry."Cost Amount (Actual)");
                if Adjusted > ItemLdgEntry."Remaining Quantity" then VALIDATE(Adjusted, ItemLdgEntry."Remaining Quantity");
                VALIDATE("Unit Cost", ROUND((ItemLdgEntry."Cost Amount (Expected)" + ItemLdgEntry."Cost Amount (Actual)") / ItemLdgEntry.Quantity, GeneralLedgerSetup."Unit-Amount Rounding Precision"));
                if ItemLdgEntry.Positive then VALIDATE("Calculated Stocks", ItemLdgEntry."Remaining Quantity") else VALIDATE("Calculated Stocks", ItemLdgEntry.Quantity);
                //CalcItemData;
                exit;
            end;

        end;
        HeaderRegularizationStock.GET("Document No.");

        //CPA 14/02/22. Q16245.begin
        CLEAR(Cantidad);
        CLEAR(CantidadPendiente);
        CLEAR(ImportePendiente);
        //CPA 14/02/22. Q16245.end

        //PSM 080621+
        CantidadPendiente := 0;
        ImportePendiente := 0;
        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgerEntry.SETRANGE("Location Code", HeaderRegularizationStock."Location Code");
        ItemLedgerEntry.SETFILTER("Posting Date", '..%1', HeaderRegularizationStock."Regularization Date");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.CALCSUMS("Remaining Quantity", Quantity);
        CantePendienteTotal := ItemLedgerEntry."Remaining Quantity";
        Cantidad := ItemLedgerEntry.Quantity;

        if CantePendienteTotal <> 0 then begin
            //Si no hay movs. pendientes de liquidar para el c�lculo del coste unitario usamos los liquidados
            if ItemLedgerEntry.ISEMPTY then
                ItemLedgerEntry.SETRANGE(Open);

            CosteUnitarioPonderado := 0;
            if ItemLedgerEntry.FINDFIRST then begin
                repeat
                    ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
                    CosteMov := ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                    //Importe += CosteMov;

                    CantMov := ItemLedgerEntry.Quantity;
                    if (CantMov <> 0) then begin
                        CantPte := ItemLedgerEntry."Remaining Quantity";
                        CosteUnitarioPonderado += (CosteMov / CantMov) * (CantPte / CantePendienteTotal);
                        Cantidad += CantMov;
                    end;
                until ItemLedgerEntry.NEXT = 0
            end;

            //PSM 270122+
            VALIDATE("Calculated Stocks", CantePendienteTotal);
            VALIDATE("Current Stocks", 0);
            //PSM 270122-

            //VALIDATE("Unit Cost", ROUND(Importe / Cantidad, GLSetup."Unit-Amount Rounding Precision"))
            GLSetup.GET;
            VALIDATE("Unit Cost", ROUND(CosteUnitarioPonderado, GLSetup."Unit-Amount Rounding Precision"));

        end else begin
            VALIDATE("Unit Cost", 0);
            VALIDATE("Current Stocks", Cantidad);
            VALIDATE("Calculated Stocks", Cantidad);
        end;
        //Q16439 CPA 22-02-22.end
    end;

    LOCAL procedure CalcUnitCost()
    var
        //       LItem@1100286000 :
        LItem: Record 27;
    begin
        //AML 24/03/22 QB_ST01
        LItem.GET("Item No.");
        if LItem."Costing Method" = LItem."Costing Method"::FIFO then FIFOPrice else AvgPrice;
    end;

    LOCAL procedure AvgPrice()
    var
        //       GeneralLedgerSetup@1100286000 :
        GeneralLedgerSetup: Record 98;
        //       Item@1100286001 :
        Item: Record 27;
        //       ItemLedgerEntry@1100286002 :
        ItemLedgerEntry: Record 32;
        //       SumCost@1100286004 :
        SumCost: Decimal;
        //       SumQt@1100286003 :
        SumQt: Decimal;
        //       ItemLdgEntry@1100286005 :
        ItemLdgEntry: Record 32;
    begin
        GeneralLedgerSetup.GET;
        if Job.GET("Job No.") then;  //AML 25/04/22: - QB 1.10.37 Se lee el proyecto

        if "Cancel Mov." <> 0 then begin
            if ItemLdgEntry.GET("Cancel Mov.") then begin
                ItemLdgEntry.CALCFIELDS("Cost Amount (Expected)", ItemLdgEntry."Cost Amount (Actual)");
                if Adjusted > ItemLdgEntry."Remaining Quantity" then VALIDATE(Adjusted, ItemLdgEntry."Remaining Quantity");
                VALIDATE("Unit Cost", ROUND((ItemLdgEntry."Cost Amount (Expected)" + ItemLdgEntry."Cost Amount (Actual)") / ItemLdgEntry.Quantity, GeneralLedgerSetup."Unit-Amount Rounding Precision"));
                if ItemLdgEntry.Positive then VALIDATE("Calculated Stocks", ItemLdgEntry."Remaining Quantity") else VALIDATE("Calculated Stocks", ItemLdgEntry.Quantity);
                exit;
            end;
        end;

        //AML 08/04/22: - QB 1.10.33 Hay que leer el registro de regularizaci�n antes del proceso
        HeaderRegularizationStock.GET("Document No.");

        //AML 24/3/22 QB_ST01 Codeunit para obtener el precio medio
        Item.RESET;
        Item.GET("Item No.");
        Item.SETFILTER("Location Filter", Job."Job Location");
        Item.SETRANGE("Date Filter", 0D, HeaderRegularizationStock."Regularization Date");
        Item.CALCFIELDS("Net Change");
        if Item."Net Change" <= 0 then begin
            VALIDATE("Unit Cost", 0);
            exit;
        end;

        //AML 08/04/22: - QB 1.10.33 Modificaciones en el c�lculo del precio
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
        //ItemLedgerEntry.SETRANGE(Positive,TRUE);
        //ItemLedgerEntry.SETRANGE(Open,TRUE);
        ItemLedgerEntry.SETRANGE("Posting Date", 0D, HeaderRegularizationStock."Regularization Date");
        if ItemLedgerEntry.FINDSET then
            repeat
                ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                //SumCost += ItemLedgerEntry."Remaining Quantity" * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
                //SumQt := SumQt + ItemLedgerEntry."Remaining Quantity";
                SumCost += (ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)");
                SumQt := SumQt + ItemLedgerEntry.Quantity;
            until (ItemLedgerEntry.NEXT = 0);

        if SumQt <> 0 then
            VALIDATE("Unit Cost", ABS(ROUND(SumCost / SumQt, GeneralLedgerSetup."Unit-Amount Rounding Precision")))  //AML 25/04/22: - QB 1.10.37 Se toma el valor absoluto de las cantidades
        else
            VALIDATE("Unit Cost", 0);
    end;

    LOCAL procedure FIFOPrice()
    var
        //       ItemLedgerEntry@1100286003 :
        ItemLedgerEntry: Record 32;
        //       SumCost@1100286002 :
        SumCost: Decimal;
        //       SumQt@1100286001 :
        SumQt: Decimal;
        //       GeneralLedgerSetup@1100286000 :
        GeneralLedgerSetup: Record 98;
        //       Item@1100286004 :
        Item: Record 27;
        //       ItemLdgEntry@1100286005 :
        ItemLdgEntry: Record 32;
    begin
        //AML 24/3/22 QB_ST01 Codeunit para obtener el precio FIFO en funcion de las unidades
        GeneralLedgerSetup.GET;

        //AML 08/04/22: - QB 1.10.33 Hay que leer el registro de regularizaci�n antes del proceso
        HeaderRegularizationStock.GET("Document No.");

        if "Cancel Mov." <> 0 then begin
            if ItemLdgEntry.GET("Cancel Mov.") then begin
                ItemLdgEntry.CALCFIELDS("Cost Amount (Expected)", ItemLdgEntry."Cost Amount (Actual)");
                //if Adjusted > ItemLdgEntry."Remaining Quantity" then VALIDATE(Adjusted , ItemLdgEntry."Remaining Quantity");
                VALIDATE("Unit Cost", ROUND((ItemLdgEntry."Cost Amount (Expected)" + ItemLdgEntry."Cost Amount (Actual)") / ItemLdgEntry.Quantity, GeneralLedgerSetup."Unit-Amount Rounding Precision"));
                if ItemLdgEntry.Positive then VALIDATE("Calculated Stocks", ItemLdgEntry."Remaining Quantity") else VALIDATE("Calculated Stocks", ItemLdgEntry.Quantity);
                exit;
            end;
        end;

        if Adjusted = 0 then begin
            AvgPrice;
            exit;
        end;
        if Adjusted > 0 then begin
            AvgPrice;
            exit;
        end;
        Job.GET(HeaderRegularizationStock."Location Code");

        Item.RESET;
        Item.GET("Item No.");
        Item.SETFILTER("Location Filter", Job."Job Location");
        Item.SETRANGE("Date Filter", 0D, HeaderRegularizationStock."Regularization Date");
        Item.CALCFIELDS("Net Change");
        if -Adjusted > Item."Net Change" then begin
            AvgPrice;
            exit;
        end;

        SumCost := 0;
        SumQt := -Adjusted;
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
        ItemLedgerEntry.SETRANGE(Positive, TRUE);
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.SETRANGE("Posting Date", 0D, HeaderRegularizationStock."Regularization Date");
        if ItemLedgerEntry.FINDSET then
            repeat
                ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                if SumQt > ItemLedgerEntry."Remaining Quantity" then begin
                    SumCost += ItemLedgerEntry."Remaining Quantity" * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
                    SumQt := SumQt - ItemLedgerEntry."Remaining Quantity";
                end
                else begin
                    if SumQt = ItemLedgerEntry."Remaining Quantity" then begin
                        SumCost += ItemLedgerEntry."Remaining Quantity" * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
                    end
                    else begin
                        SumCost += SumQt * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
                    end;
                    SumQt := 0;
                end;
            until (ItemLedgerEntry.NEXT = 0) or (SumQt = 0);

        VALIDATE("Unit Cost", ABS(ROUND(SumCost / Adjusted, GeneralLedgerSetup."Unit-Amount Rounding Precision")));  //AML 25/04/22: - QB 1.10.37 Se toma el valor absoluto de las cantidades
    end;

    //begin
    //{
    //      Q13606 QMD 08/06/21 Ampliado decimales
    //
    //      Q16439 CPA 22-02-22.begin
    //          Modificaciones:
    //              GetExistYCteProd
    //          Nueva funci�n
    //              AdjustQuantitiesAndUnitCost
    //      AML 24/03/22: - QB 1.10.30 QB_ST01 A�adidas funciones CalcUnitCost, AvgPrice y FIFOPrice para el calculo de costes de salida. A�adidos Campos de cancelacion
    //      AML 08/04/22: - QB 1.10.33 Hay que leer el registro de regularizaci�n antes del proceso. C�mbio en el c�lculo del precio
    //      AML 25/04/22: - QB 1.10.37 Se toma le valor absoluto de las cantidades y se lee el proyecto
    //      CSM 11/05/22: - QB 1.10.42 (QBU17146) Cargar en blanco N� ud. Obra en la regularizaci�n.
    //    }
    //end.

}








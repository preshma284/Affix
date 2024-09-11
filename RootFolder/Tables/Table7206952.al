table 7206952 "QB Aux. Loc. Out. Ship. Lines"
{


    CaptionML = ENU = 'Aux. Location Output Shipment Lines', ESP = 'Lineas albar�n salida almac�n auxiliar';
    LookupPageID = "Subfor. Aux. Loc. Shipment Lin";
    DrillDownPageID = "Subfor. Aux. Loc. Shipment Lin";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';
        }
        field(3; "No."; Code[20])
        {
            TableRelation = "Item";


            CaptionML = ENU = 'No.', ESP = 'No.';
            Description = 'No. by type ((Uniquely identifies the line)';

            trigger OnValidate();
            BEGIN
                QBAuxLocOutShipLines := Rec;
                INIT;
                "No." := QBAuxLocOutShipLines."No.";
                "Document Source" := QBAuxLocOutShipLines."Document Source";
                IF "No." = '' THEN
                    EXIT;

                GetMasterHeader;

                Item.GET("No.");
                Item.TESTFIELD(Blocked, FALSE);
                Description := Item.Description;
                "Description 2" := Item."Description 2";

                CreateDim(0, '', DATABASE::Item, "No.");

                QuoBuildingSetup.GET;
                "Outbound Warehouse" := QuoBuildingSetup."Auxiliary Location Code";
                Billable := TRUE;
                VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                "Unit Cost" := Item."Unit Cost";
                FindCost;
                CheckAvailability(FIELDNO("No."));
                "Sales Price" := Item."Unit Price";

                InventoryPostingSetup.GET("Outbound Warehouse", Item."Inventory Posting Group");

                // Hay que llevar los siguientes dimensiones a las l�neas: Departamento:el del proyecto, CA: el de Conf Existencias del campo Almac�n
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN
                    VALIDATE("Shortcut Dimension 1 Code", InventoryPostingSetup."Analytic Concept");
                    VALIDATE("Shortcut Dimension 2 Code", QBAuxLocOutShipHeader."Shortcut Dimension 2 Code");
                END;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN BEGIN
                    VALIDATE("Shortcut Dimension 2 Code", InventoryPostingSetup."Analytic Concept");
                    VALIDATE("Shortcut Dimension 1 Code", QBAuxLocOutShipHeader."Shortcut Dimension 1 Code");
                END;

                //JAV 29/06/19: - Calculo del stock y del precio medio de coste del almac�n
                CalcItemData;
            END;

            trigger OnLookup();
            VAR
                //                                                               Job@1100286001 :
                Job: Record 167;
                //                                                               Item@1100286004 :
                Item: Record 27;
                //                                                               ItemLedgerEntry@1100286003 :
                ItemLedgerEntry: Record 32;
                //                                                               ItemList@1100286002 :
                ItemList: Page "Item List";
            BEGIN
                GetMasterHeader;
                QuoBuildingSetup.GET;
                Item.RESET;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Location Code", QuoBuildingSetup."Auxiliary Location Code");
                IF (ItemLedgerEntry.FINDSET(FALSE)) THEN
                    REPEAT
                        Item.GET(ItemLedgerEntry."Item No.");
                        Item.MARK(TRUE);
                    UNTIL ItemLedgerEntry.NEXT = 0;

                //Siempre a�ado el producto de la l�nea
                IF Item.GET("No.") THEN
                    Item.MARK(TRUE);

                Item.MARKEDONLY(TRUE);

                CLEAR(ItemList);
                ItemList.SETTABLEVIEW(Item);
                ItemList.LOOKUPMODE(TRUE);
                IF (ItemList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                    ItemList.GETRECORD(Item);
                    VALIDATE("No.", Item."No.");
                END;
            END;


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. cim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(9; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad de Salida';

            trigger OnValidate();
            BEGIN
                IF ("Document Source" = "Document Source"::Purchase) THEN BEGIN
                    //JAV 29/06/19: - Control para no dejar sacar mas del stock que el que existe en la obra
                    ControlNegativos;

                    //JAV 04/02/20: - Aviso si se deja el almac�n negativo
                    IF (Quantity > Stock) THEN
                        IF (NOT CONFIRM(Text004, FALSE)) THEN
                            ERROR('');
                END;

                Amount := "Sales Price" * Quantity;
                "Total Cost" := "Unit Cost" * Quantity;

                "Quantity (Base)" := CalculateBaseQuantity(Quantity);
                CheckAvailability(FIELDNO(Quantity));

                //JAV 04/02/20: - Al cambiar la cantidad, modificar el stock restante
                CalcItemData;
                "Final Stock" := Stock - Quantity;
            END;


        }
        field(10; "Unit Cost"; Decimal)
        {


            CaptionML = ENU = 'Unit Cost', ESP = 'Precio coste';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                Amount := "Sales Price" * Quantity;
                "Total Cost" := "Unit Cost" * Quantity;
            END;


        }
        field(11; "Outbound Warehouse"; Code[10])
        {
            TableRelation = "Location";


            CaptionML = ENU = 'Outbound Warehouse', ESP = 'Almac�n de salida';

            trigger OnValidate();
            BEGIN
                FindCost;
                VALIDATE("Unit Cost");
                CheckAvailability(FIELDNO("Outbound Warehouse"));
            END;


        }
        field(12; "Total Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            AutoFormatType = 1;


        }
        field(13; "Sales Price"; Decimal)
        {


            CaptionML = ENU = 'Sales Price', ESP = 'Precio venta';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                Amount := "Sales Price" * Quantity;
                "Total Cost" := "Unit Cost" * Quantity;
            END;


        }
        field(14; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Unit of Measure";


            CaptionML = ENU = 'Unit of Measure Code', ESP = 'Cod. unidad de medida';

            trigger OnValidate();
            BEGIN
                GetItem;

                FindCost;

                "Unit of Mensure Quantity" := UnitofMeasureManagement.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");

                ReadGlSetup;
                "Unit Cost" := ROUND("Unit Cost" * "Unit of Mensure Quantity", GeneralLedgerSetup."Unit-Amount Rounding Precision");
                "Sales Price" := ROUND("Sales Price" * "Unit of Mensure Quantity", GeneralLedgerSetup."Unit-Amount Rounding Precision");

                VALIDATE(Quantity);
                CheckAvailability(FIELDNO("Unit of Measure Code"));
            END;


        }
        field(15; "Billable"; Boolean)
        {
            CaptionML = ENU = 'Billable', ESP = 'Facturable';


        }
        field(16; "Unit of Mensure Quantity"; Decimal)
        {
            CaptionML = ENU = 'Unit of Mensure Quantity', ESP = 'Cantidad por Unid.Medida';


        }
        field(17; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)', ESP = 'Cantidad (Base)';


        }
        field(18; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant"."Code" WHERE("Item No." = FIELD("No."));


            CaptionML = ENU = 'Variant Code', ESP = 'Cod. variante';

            trigger OnValidate();
            BEGIN
                IF "Variant Code" = '' THEN BEGIN
                    Item.GET("No.");
                    Description := Item.Description;
                    "Description 2" := Item."Description 2";
                END ELSE BEGIN
                    ItemVariant.GET("No.", "Variant Code");
                    Description := ItemVariant.Description;
                    "Description 2" := ItemVariant."Description 2";
                END;
            END;


        }
        field(19; "No. Serie for Tracking"; Code[20])
        {


            CaptionML = ENU = 'No. Serie for Tracking', ESP = 'No. Serie para seguimiento';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Quantity, 1);
                TESTFIELD("Quantity (Base)", 1);
            END;

            trigger OnLookup();
            VAR
                //                                                               ItemTrackingDataCollection@7001100 :
                ItemTrackingDataCollection: Codeunit 6501;
                //                                                               TrackingSpecification@7001101 :
                TrackingSpecification: Record 336;
            BEGIN
                CLEAR(TrackingSpecification);
                TrackingSpecification."Item No." := "No.";
                TrackingSpecification."Location Code" := "Outbound Warehouse";
                TrackingSpecification."Quantity (Base)" := "Quantity (Base)";
                TrackingSpecification."Source Type" := DATABASE::"Sales Line";
                TrackingSpecification."Source Subtype" := 1;
                TrackingSpecification."Source ID" := "Document No.";
                TrackingSpecification."Source Ref. No." := "Line No.";
                // ItemTrackingDataCollection.AssistEditTrackingNo(TrackingSpecification,
                //                                                 -1 * TrackingSpecification."Quantity (Base)" < 0,-1,0,TrackingSpecification."Quantity (Base)");
                ItemTrackingDataCollection.AssistEditTrackingNo(TrackingSpecification,
                  -1 * TrackingSpecification."Quantity (Base)" < 0, -1, "Item Tracking Type".FromInteger(0), TrackingSpecification."Quantity (Base)");
                VALIDATE("No. Serie for Tracking", TrackingSpecification."Serial No.");
            END;


        }
        field(20; "No. Lot for Tracking"; Code[20])
        {


            CaptionML = ENU = 'No. Lot for Tracking', ESP = 'No. Lote para seguimiento';

            trigger OnLookup();
            VAR
                //                                                               ItemTrackingDataCollection@7001100 :
                ItemTrackingDataCollection: Codeunit 6501;
                //                                                               TrackingSpecification@7001101 :
                TrackingSpecification: Record 336;
            BEGIN
                CLEAR(TrackingSpecification);
                TrackingSpecification."Item No." := "No.";
                TrackingSpecification."Location Code" := "Outbound Warehouse";
                TrackingSpecification."Quantity (Base)" := "Quantity (Base)";
                TrackingSpecification."Source Type" := DATABASE::"Sales Line";
                TrackingSpecification."Source Subtype" := 1;
                TrackingSpecification."Source ID" := "Document No.";
                TrackingSpecification."Source Ref. No." := "Line No.";
                ItemTrackingDataCollection.AssistEditTrackingNo(TrackingSpecification,
                  -1 * TrackingSpecification."Quantity (Base)" < 0, -1, "Item Tracking Type".FromInteger(0), TrackingSpecification."Quantity (Base)");
                "No. Lot for Tracking" := TrackingSpecification."Lot No.";
            END;


        }
        field(21; "Source Document Type"; Option)
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanke Order","Return Order";
            CaptionML = ENU = 'Source Document Type', ESP = 'Tipo documento origen';
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanke Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';



        }
        field(22; "No. Source Document"; Code[20])
        {
            CaptionML = ENU = 'No. Source Document', ESP = 'No. documento origen';


        }
        field(23; "No. Source Document Line"; Integer)
        {
            CaptionML = ENU = 'No. Source Document Line', ESP = 'No. L�nea documento origen';


        }
        field(24; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(25; "Document Source"; Option)
        {
            OptionMembers = "Purchase","Sale";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = 'Purchase,Sale', ESP = 'Compra,Venta';



        }
        field(26; "Stock"; Decimal)
        {
            Editable = false;


        }
        field(27; "Final Stock"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Final stock', ESP = 'Stock final';
            Description = 'GAP10';

            trigger OnValidate();
            BEGIN
                VALIDATE(Quantity, Stock - "Final Stock");
            END;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount", "Total Cost", "Quantity";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBAuxLocOutShipHeader@1100286003 :
        QBAuxLocOutShipHeader: Record 7206951;
        //       Text000@7001101 :
        Text000: TextConst ENU = 'Tou cann�t rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       QBAuxLocOutShipLines@1100286005 :
        QBAuxLocOutShipLines: Record 7206952;
        //       Item@7001103 :
        Item: Record 27;
        //       InventoryPostingSetup@7001105 :
        InventoryPostingSetup: Record 5813;
        //       FunctionQB@7001106 :
        FunctionQB: Codeunit 7207272;
        //       DataPieceworkForProduction@7001107 :
        DataPieceworkForProduction: Record 7207386;
        //       Text001@7001108 :
        Text001: TextConst ENU = 'You can not select a blocked building unit.', ESP = 'No se puede seleccionar una unidad de obra bloqueada.';
        //       UnitofMeasureManagement@7001109 :
        UnitofMeasureManagement: Codeunit 5402;
        //       ItemVariant@7001111 :
        ItemVariant: Record 5401;
        //       TrackingSpecification@7001112 :
        TrackingSpecification: Record 336;
        //       DimensionManagement@7001113 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       GLSetupRead@7001114 :
        GLSetupRead: Boolean;
        //       GeneralLedgerSetup@7001115 :
        GeneralLedgerSetup: Record 98;
        //       InventorySetup@7001116 :
        InventorySetup: Record 313;
        //       LastDirectCost@7001117 :
        LastDirectCost: Decimal;
        //       StockkeepingUnit@7001118 :
        StockkeepingUnit: Record 5700;
        //       ItemCostManagement@7001119 :
        ItemCostManagement: Codeunit 5804;
        //       PriceCostDA@7001120 :
        PriceCostDA: Decimal;
        //       ItemCheckAvail@7001110 :
        ItemCheckAvail: Codeunit 311;
        //       QuoBuildingSetup@1100286000 :
        QuoBuildingSetup: Record 7207278;
        //       Text002@1100286001 :
        Text002: TextConst ESP = '''No puede sacar del almac�n mas cantidad de la disponible del producto %1''';
        //       Text003@1100286002 :
        Text003: TextConst ESP = '''No puede sacar del almac�n en varias l�neas mas cantidad de la disponible del producto %1''';
        //       Text004@1100286004 :
        Text004: TextConst ESP = 'El stock indicado es menor que el actual, dejar� el almac�n en negativo �realmente desea continuar?';
        //       QBCodeunitPublisher@100000000 :
        QBCodeunitPublisher: Codeunit 7207352;



    trigger OnInsert();
    begin
        LOCKTABLE;
        QBAuxLocOutShipHeader.Description := '';
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetMasterHeader()
    begin
        // Traer los valores de la cabecera del documento.
        if ("Document No." <> '') then
            QBAuxLocOutShipHeader.GET("Document No.")
        else
            QBAuxLocOutShipHeader.INIT;
    end;

    //     procedure CreateDim (Type1@7001100 : Integer;No1@7001101 : Code[20];Type2@7001102 : Integer;No2@7001103 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       SourceCodeSetup@7001104 :
        SourceCodeSetup: Record 242;
        //       TableID@7001105 :
        TableID: ARRAY[10] OF Integer;
        //       No@7001106 :
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
            DefaultDimSource, SourceCodeSetup."Output Shipment to Job", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            QBAuxLocOutShipHeader."Dimension Set ID", DATABASE::Job);
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure FindCost()
    begin
        ReadGlSetup;
        GetItem;
        GetMasterHeader;

        InventorySetup.GET;
        if GetSku then begin
            LastDirectCost := StockkeepingUnit."Last Direct Cost";
            "Unit Cost" := StockkeepingUnit."Unit Cost";
        end else begin
            LastDirectCost := Item."Last Direct Cost";
            "Unit Cost" := Item."Unit Cost";
        end;
        if Item."Costing Method" <> Item."Costing Method"::Standard then
            "Unit Cost" := ROUND("Unit Cost", GeneralLedgerSetup."Unit-Amount Rounding Precision");

        if (Item."Costing Method" = Item."Costing Method"::Average) or
           (Item."Costing Method" = Item."Costing Method"::FIFO) then begin
            Item.SETFILTER("Date Filter", '..%1', QBAuxLocOutShipHeader."Posting Date");
            if InventorySetup."Average Cost Calc. Type" = InventorySetup."Average Cost Calc. Type"::" " then
                Item.SETRANGE("Location Filter")
            else
                Item.SETRANGE("Location Filter", "Outbound Warehouse");
            ItemCostManagement.CalculateAverageCost(Item, "Unit Cost", PriceCostDA);
        end;

        if "Unit Cost" = 0 then
            VALIDATE("Unit Cost", Item."Unit Cost")
        else
            VALIDATE("Unit Cost", "Unit Cost");

        "Sales Price" := Item."Unit Price";
    end;

    //     procedure CheckAvailability (CalledByFieldNo@7001100 :
    procedure CheckAvailability(CalledByFieldNo: Integer)
    begin
        //{
        //      if (CurrFieldNo = 0) or (CurrFieldNo <> CalledByFieldNo) then // Prevent two checks on quantity
        //        exit;
        //      if (CurrFieldNo <> 0) and ("No." <> '') and (Quantity <> 0) then
        //        QBCodeunitPublisher.ItemOutputCheckLine(Rec,ItemCheckAvail);
        //      }
    end;

    //     procedure ValidateShortcutDimCode (FielNumber@7001100 : Integer;var ShortcutDimeCode@7001101 :
    procedure ValidateShortcutDimCode(FielNumber: Integer; var ShortcutDimeCode: Code[20])
    begin
        // Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimensionManagement.ValidateShortcutDimValues(FielNumber, ShortcutDimeCode, "Dimension Set ID");
    end;

    //     procedure CalculateBaseQuantity (QuantityLine@7001100 :
    procedure CalculateBaseQuantity(QuantityLine: Decimal): Decimal;
    begin
        TESTFIELD("Unit of Mensure Quantity");
        exit(ROUND(QuantityLine * "Unit of Mensure Quantity", 0.000001));
    end;

    procedure GetItem()
    begin
        if Item."No." <> "No." then
            Item.GET("No.");
    end;

    procedure ReadGlSetup()
    begin
        if not GLSetupRead then begin
            GeneralLedgerSetup.GET;
            GLSetupRead := TRUE;
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

    //     procedure LookupShortcutDimCode (FieldNumber@7001100 : Integer;var ShortcutDimCode@7001101 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // Busca el valor de las dimensiones por defecto
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (ShortcutDimCode@7001100 :
    procedure ShowShortcutDimCode(ShortcutDimCode: ARRAY[8] OF Code[10])
    begin
        // Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@7001100 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text;
    var
        //       Field@7001101 :
        Field: Record 2000000041;
    begin
        // Funci�n para el capti�n de la tabla, es lo que mostrara el formulario
        Field.GET(DATABASE::"Output Shipment Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    LOCAL procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GeneralLedgerSetup.GET;
        GLSetupRead := TRUE;
    end;

    procedure GetSku(): Boolean;
    begin
        if (StockkeepingUnit."Location Code" = "Outbound Warehouse") and
           (StockkeepingUnit."Item No." = "No.") and (StockkeepingUnit."Variant Code" = "Variant Code")
        then
            exit(TRUE);

        if StockkeepingUnit.GET("Outbound Warehouse", "No.", "Variant Code") then
            exit(TRUE)
        else
            exit(FALSE);
    end;

    procedure CalcItemData()
    var
        //       ItemLedgerEntry@1100286000 :
        ItemLedgerEntry: Record 32;
        //       SumCost@1100286001 :
        SumCost: Decimal;
        //       SumQt@1100286002 :
        SumQt: Decimal;
    begin
        //JAV 29/06/19: - Calculo del stock y del precio medio de coste del almac�n
        "Final Stock" := 0;
        "Unit Cost" := 0;
        GetMasterHeader;
        QuoBuildingSetup.GET;

        if (Item.GET("No.")) then begin
            Item.SETFILTER("Location Filter", QuoBuildingSetup."Auxiliary Location Code");
            Item.SETRANGE("Date Filter");
            Item.CALCFIELDS(Inventory);
            Stock := Item.Inventory;
            "Final Stock" := Stock - Quantity;

            //Valoraci�n a precio medio de coste, sumamos solo entradas a su precio de coste y dividimos entre stock entrado
            Item.CALCFIELDS("QB Location Sum Cost Amount", "QB Location Sum Cost Qty");
            if (Item."QB Location Sum Cost Qty" <> 0) then
                "Unit Cost" := ROUND(Item."QB Location Sum Cost Amount" / Item."QB Location Sum Cost Qty", 0.00001)
            else
                "Unit Cost" := 0;
        end;
    end;

    LOCAL procedure ControlNegativos()
    var
        //       InventorySetup@1100286002 :
        InventorySetup: Record 313;
        //       OutputShipmentLines@1100286000 :
        OutputShipmentLines: Record 7207309;
        //       Cantidad@1100286001 :
        Cantidad: Decimal;
    begin
        //JAV 29/06/19: - Control para no dejar sacar mas del stock que el que existe en la obra
        if (Quantity = 0) then
            exit;

        //JAV 10/04/22: - QB 1.10.34 Cambio el campo propio de controlar almac�n negativo por el est�ndar
        InventorySetup.GET;
        if (not InventorySetup."Prevent Negative Inventory") then
            exit;

        //Miro la l�nea actual
        if (Quantity > Stock) then
            ERROR(Text002, "No.");

        //Ahora miro el total de l�neas del mismo producto
        Cantidad := Quantity;

        QBAuxLocOutShipLines.RESET;
        QBAuxLocOutShipLines.SETRANGE("Document No.", "Document No.");
        QBAuxLocOutShipLines.SETRANGE("No.", "No.");
        QBAuxLocOutShipLines.SETFILTER("Line No.", '<>%1', "Line No.");
        if (QBAuxLocOutShipLines.FINDSET(FALSE)) then
            repeat
                Cantidad += QBAuxLocOutShipLines.Quantity;
            until QBAuxLocOutShipLines.NEXT = 0;

        if (Cantidad > Stock) then
            ERROR(Text003, "No.");
    end;

    /*begin
    //{
//      JAV 29/06/19: - Calculo del stock y del precio medio de coste del almac�n
//                    - Control para no dejar sacar mas del stock que el que existe en la obra
//      QMD 26/12/19: - Q8465 GAP10. Nuevo campo para calcular la cantidad
//      JAV 04/02/20: - Al cambiar la cantidad, modificar el stock restante
//                    - Aviso si se deja el almac�n negativo
//      JAV 10/04/22: - QB 1.10.34 Cambio el campo propio de controlar almac�n negativo por el est�ndar
//    }
    end.
  */
}








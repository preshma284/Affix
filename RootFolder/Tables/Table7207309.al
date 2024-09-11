table 7207309 "Output Shipment Lines"
{


    Permissions = TableData 32 = rimd,
                TableData 120 = rimd,
                TableData 121 = rimd;
    CaptionML = ENU = 'Warehouse Shipment Lines', ESP = 'Lineas Salida Almac�n Obra';
    PasteIsValid = false;
    LookupPageID = "Subfor. Output Shipment Lin";
    DrillDownPageID = "Subfor. Output Shipment Lin";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';


        }
        field(4; "No."; Code[20])
        {
            TableRelation = "Item";


            CaptionML = ENU = 'No.', ESP = 'No.';
            Description = 'No. by type ((Uniquely identifies the line)';

            trigger OnValidate();
            BEGIN
                OutboundWarehouseLines := Rec;
                INIT;
                "No." := OutboundWarehouseLines."No.";
                "Document Source" := OutboundWarehouseLines."Document Source";
                //-AML QB_ST01 Para las anulaciones de albaranes
                "Cancel Qty" := OutboundWarehouseLines."Cancel Qty";
                "Cancel Cost" := OutboundWarehouseLines."Cancel Cost";
                Cancellation := OutboundWarehouseLines.Cancellation;
                //+AML QB_ST01
                IF "No." = '' THEN
                    EXIT;

                GetMasterHeader;
                OutboundWarehouseHeading.TESTFIELD("Job No.");
                "Job No." := OutboundWarehouseHeading."Job No.";

                Item.GET("No.");
                Item.TESTFIELD(Blocked, FALSE);
                Description := Item.Description;
                "Description 2" := Item."Description 2";

                CreateDim(DATABASE::Job, "Job No.", DATABASE::Item, "No.");

                // Al insertar una l�nea hay que llevarse el almac�n del proyecto, poner a true: el campo Facturable y las unidades del producto
                Job.GET(OutboundWarehouseHeading."Job No.");
                "Outbound Warehouse" := Job."Job Location";
                Billable := TRUE;
                VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                "Unit Cost" := Item."Unit Cost";
                FindCost;
                CheckAvailability(FIELDNO("No."));
                "Sales Price" := Item."Unit Price";

                InventoryPostingSetup.GET("Outbound Warehouse", Item."Inventory Posting Group");

                // Hay que llevar los siguientes dimensiones a las l�neas: Departamento:el del proyecto, CA: el de Conf Existencias del campo Almac�n
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN
                    //QBU17147 CSM 11/05/22 � Mostrar columna de Concepto Anal�tico en la regularizaci�n de stock. -
                    //VALIDATE("Shortcut Dimension 1 Code",InventoryPostingSetup."Analytic Concept");
                    VALIDATE("Shortcut Dimension 1 Code", OutboundWarehouseHeading."Shortcut Dimension 1 Code");
                END;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN BEGIN
                    //QBU17147 CSM 11/05/22 � Mostrar columna de Concepto Anal�tico en la regularizaci�n de stock. -
                    //VALIDATE("Shortcut Dimension 2 Code",InventoryPostingSetup."Analytic Concept");
                    VALIDATE("Shortcut Dimension 2 Code", OutboundWarehouseHeading."Shortcut Dimension 2 Code");
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
                IF (Job.GET(OutboundWarehouseHeading."Job No.")) THEN BEGIN
                    Item.RESET;
                    //Item.SETFILTER("Location Filter",Job."Job Location");
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
                    IF (ItemLedgerEntry.FINDSET(FALSE)) THEN
                        REPEAT
                            Item.GET(ItemLedgerEntry."Item No.");
                            Item.MARK(TRUE);
                        UNTIL ItemLedgerEntry.NEXT = 0;

                    //Siempre a�ado el producto de la l�nea
                    IF Item.GET("No.") THEN
                        Item.MARK(TRUE);

                    Item.MARKEDONLY(TRUE);
                END;

                CLEAR(ItemList);
                ItemList.SETTABLEVIEW(Item);
                ItemList.LOOKUPMODE(TRUE);
                IF (ItemList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                    ItemList.GETRECORD(Item);
                    VALIDATE("No.", Item."No.");
                END;
                //AML QB_ST01.1
                Devolucion := FALSE;
                "Precio Devolucion" := 0;
            END;


        }
        field(5; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(6; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(7; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;


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


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. cim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");

                GetMasterHeader;
                IF (OutboundWarehouseHeading."Shortcut Dimension 2 Code" = '') THEN BEGIN
                    DimensionManagement.ValidateShortcutDimValues(2, "Shortcut Dimension 2 Code", OutboundWarehouseHeading."Dimension Set ID");
                    OutboundWarehouseHeading.MODIFY;
                END;
            END;


        }
        field(10; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad de Salida';

            trigger OnValidate();
            VAR
                //                                                                 ItemLdgEntry@1100286000 :
                ItemLdgEntry: Record 32;
                //                                                                 OutputShipmentHeader@1100286001 :
                OutputShipmentHeader: Record 7207308;
            BEGIN
                IF ("Document Source" = "Document Source"::Purchase) THEN BEGIN
                    //JAV 29/06/19: - Control para no dejar sacar mas del stock que el que existe en la obra
                    CalcItemData;
                    ControlNegativos;

                    //AML 25/07/22: - Cambiar el aviso si se deja el almac�n negativo
                    OutputShipmentHeader.GET("Document No.");
                    IF NOT OutputShipmentHeader."Automatic Shipment" THEN BEGIN
                        //JAV 04/02/20: - Aviso si se deja el almac�n negativo
                        IF (Quantity > Stock) THEN
                            IF (NOT CONFIRM(Text004, FALSE)) THEN
                                ERROR('');
                    END;
                END;
                //-AML QB_ST01 Si hay movimiento de cancelaci�n
                IF "Cancel Mov." <> 0 THEN BEGIN
                    IF ItemLdgEntry.GET("Cancel Mov.") THEN BEGIN
                        IF Quantity > ItemLdgEntry."Remaining Quantity" THEN ERROR('La cantidad m�xima a liquidar son %1', ItemLdgEntry."Remaining Quantity");
                    END;
                END;
                IF Devolucion AND (Quantity > 0) THEN ERROR('La cantidad debe ser negativa en una devoluci�n');

                //+AML


                CalcAmounts;

                "Quantity (Base)" := CalculateBaseQuantity(Quantity);
                CheckAvailability(FIELDNO(Quantity));

                //JAV 04/02/20: - Al cambiar la cantidad, modificar el stock restante
                CalcItemData;
                "Final Stock" := Stock - Quantity;
                CancelMov;
            END;


        }
        field(11; "Unit Cost"; Decimal)
        {


            CaptionML = ENU = 'Unit Cost', ESP = 'Precio coste';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CalcAmounts;
            END;


        }
        field(12; "Outbound Warehouse"; Code[10])
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
        field(13; "Produccion Unit"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true),
                                                                                                                         "Account Type" = CONST("Unit"));


            CaptionML = ENU = 'Produccion Unit', ESP = 'Unidad de produccion';

            trigger OnValidate();
            BEGIN
                // Si la unidad de obra seleccionada esta bloqueada daremos un error
                IF DataPieceworkForProduction.GET("Job No.", "Produccion Unit") THEN;
                IF DataPieceworkForProduction.Blocked THEN
                    ERROR(Text001);
            END;


        }
        field(14; "Total Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            AutoFormatType = 1;


        }
        field(15; "Sales Price"; Decimal)
        {


            CaptionML = ENU = 'Sales Price', ESP = 'Precio venta';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CalcAmounts;
            END;


        }
        field(16; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Unit of Measure";


            CaptionML = ENU = 'Unit of Measure Code', ESP = 'Cod. unidad de medida';

            trigger OnValidate();
            BEGIN
                GetItem;

                FindCost;

                ReadGlSetup;
                "Unit of Mensure Quantity" := UnitofMeasureManagement.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                "Unit Cost" := ROUND("Unit Cost" * "Unit of Mensure Quantity", GeneralLedgerSetup."Unit-Amount Rounding Precision");
                "Sales Price" := ROUND("Sales Price" * "Unit of Mensure Quantity", GeneralLedgerSetup."Unit-Amount Rounding Precision");

                VALIDATE(Quantity);
                CheckAvailability(FIELDNO("Unit of Measure Code"));
            END;


        }
        field(17; "Billable"; Boolean)
        {
            CaptionML = ENU = 'Billable', ESP = 'Facturable';


        }
        field(18; "Unit of Mensure Quantity"; Decimal)
        {
            CaptionML = ENU = 'Unit of Mensure Quantity', ESP = 'Cantidad por Unid.Medida';


        }
        field(19; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)', ESP = 'Cantidad (Base)';


        }
        field(20; "Variant Code"; Code[10])
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
        field(21; "No. Serie for Tracking"; Code[20])
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
                ItemTrackingDataCollection.AssistEditTrackingNo(TrackingSpecification,
                  -1 * TrackingSpecification."Quantity (Base)" < 0, -1, "Item Tracking Type".FromInteger(0), TrackingSpecification."Quantity (Base)");
                VALIDATE("No. Serie for Tracking", TrackingSpecification."Serial No.");
            END;


        }
        field(22; "No. Lot for Tracking"; Code[20])
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
        field(23; "Source Document Type"; Option)
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanke Order","Return Order";
            CaptionML = ENU = 'Source Document Type', ESP = 'Tipo documento origen';
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanke Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';



        }
        field(24; "No. Source Document"; Code[20])
        {
            CaptionML = ENU = 'No. Source Document', ESP = 'No. documento origen';


        }
        field(25; "No. Source Document Line"; Integer)
        {
            CaptionML = ENU = 'No. Source Document Line', ESP = 'No. L�nea documento origen';


        }
        field(26; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';
            NotBlank = true;


        }
        field(27; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(28; "Job Line Type"; Option)
        {
            OptionMembers = " ","Budget","Billable","Both Budget and Billable";
            AccessByPermission = TableData 167 = R;
            CaptionML = ENU = 'Job Line Type', ESP = 'Tipo l�nea proyecto';
            OptionCaptionML = ENU = '" ,Budget,Billable,Both Budget and Billable"', ESP = '" ,Presupuesto,Facturable,Presupuesto y Facturable"';



        }
        field(30; "Document Source"; Option)
        {
            OptionMembers = "Purchase","Sale";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = 'Purchase,Sale', ESP = 'Compra,Venta';



        }
        field(31; "Stock"; Decimal)
        {
            Editable = false;


        }
        field(32; "Final Stock"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Final stock', ESP = 'Stock final';
            Description = 'GAP10';

            trigger OnValidate();
            BEGIN
                VALIDATE(Quantity, Stock - "Final Stock");
            END;


        }
        field(51; "Item Rcpt. Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras';


        }
        field(52; "Cancellation"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cancellation', ESP = 'Cancelaci�n';
            Description = 'CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras';


        }
        field(53; "Invoiced Quantity (Base)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Invoiced Quantity (Base)', ESP = 'Cantidad facturada (Base)';
            Description = 'CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras';


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
            TableRelation = "Item Ledger Entry"."Entry No." WHERE("Item No." = FIELD("No."),
                                                                                                        "Job No." = FIELD("Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cancel Mov.', ESP = 'Mov. Cancelado';
            Description = 'QB_ST01 Solo para uso en anulaciones';

            trigger OnValidate();
            VAR
                //                                                                 ItemLdgEntry@1100286000 :
                ItemLdgEntry: Record 32;
            BEGIN
                IF "Cancel Mov." <> 0 THEN BEGIN
                    IF ItemLdgEntry.GET("Cancel Mov.") THEN BEGIN
                        IF Quantity > ItemLdgEntry."Remaining Quantity" THEN VALIDATE(Quantity, ItemLdgEntry."Remaining Quantity");
                        CalcItemData;
                    END;
                END;
            END;


        }
        field(103; "Devolucion"; Boolean)
        {


            DataClassification = ToBeClassified;
            Description = 'QB 1.10.56 28/06/22 : AML';

            trigger OnValidate();
            BEGIN
                IF Devolucion THEN BEGIN
                    IF Quantity > 0 THEN Quantity := 0;
                    "Cancel Mov." := 0;
                END
                ELSE BEGIN
                    VALIDATE(Quantity, 0);
                    "Precio Devolucion" := 0;
                    FindCost;
                END;
            END;


        }
        field(104; "Precio Devolucion"; Decimal)
        {


            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.10.56 28/06/22 : AML';

            trigger OnValidate();
            BEGIN
                IF NOT Devolucion THEN ERROR('No puede informar este precio sin informar informar el flag de Devolucion');
                IF "Precio Devolucion" < 0 THEN ERROR('No puede informar un precio negativo');
                IF Quantity > 0 THEN Quantity := 0;
                VALIDATE("Unit Cost", "Precio Devolucion");
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
        //       OutboundWarehouseHeading@7001100 :
        OutboundWarehouseHeading: Record 7207308;
        //       Text000@7001101 :
        Text000: TextConst ENU = 'Tou cann�t rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       OutboundWarehouseLines@7001102 :
        OutboundWarehouseLines: Record 7207309;
        //       Item@7001103 :
        Item: Record 27;
        //       Job@7001104 :
        Job: Record 167;
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
        OutboundWarehouseHeading.Description := '';
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetMasterHeader()
    begin
        // Traer los valores de la cabecera del documento.
        if ("Document No." <> '') then
            OutboundWarehouseHeading.GET("Document No.")
        else
            OutboundWarehouseHeading.INIT;
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
            OutboundWarehouseHeading."Dimension Set ID", DATABASE::Job);
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
            Item.SETFILTER("Date Filter", '..%1', OutboundWarehouseHeading."Posting Date");
            if InventorySetup."Average Cost Calc. Type" = InventorySetup."Average Cost Calc. Type"::" " then
                Item.SETRANGE("Location Filter")
            else
                Item.SETRANGE("Location Filter", "Outbound Warehouse");
            ItemCostManagement.CalculateAverageCost(Item, "Unit Cost", PriceCostDA);
        end;

        //jmma VALIDATE("Unit Cost",Item."Unit Cost");
        if "Unit Cost" = 0 then
            VALIDATE("Unit Cost", Item."Unit Cost")
        else
            VALIDATE("Unit Cost", "Unit Cost");

        "Sales Price" := Item."Unit Price";
    end;

    //     procedure CheckAvailability (CalledByFieldNo@7001100 :
    procedure CheckAvailability(CalledByFieldNo: Integer)
    begin
        if (CurrFieldNo = 0) or (CurrFieldNo <> CalledByFieldNo) then // Prevent two checks on quantity
            exit;
        if (CurrFieldNo <> 0) and ("No." <> '') and (Quantity <> 0) then
            QBCodeunitPublisher.ItemOutputCheckLine(Rec, ItemCheckAvail);
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
        //       GeneralLedgerSetup@1100286004 :
        GeneralLedgerSetup: Record 98;
    begin
        //JAV 29/06/19: - Calculo del stock y del precio medio de coste del almac�n
        if Devolucion then exit;
        GeneralLedgerSetup.GET;
        "Final Stock" := 0;
        "Unit Cost" := 0;
        GetMasterHeader;

        //JMMA Se a�ade job.GET porque calculaba mal el stock por no estar posicionado en el proyecto
        if Job.GET(OutboundWarehouseHeading."Job No.") then begin
            Item.RESET;
            if (Item.GET("No.")) then begin
                //MOdificado para QB_ST01
                //AML QB_ST01 Separamos las devoluciones del resto, porque en las devoluciones ya se ha hecho el movimiento y desvirtua el stock y el valor.
                if OutboundWarehouseHeading.Cancellation then begin
                    Stock := "Cancel Qty";
                    "Unit Cost" := "Cancel Cost";
                    AdjustUnitCost;
                    exit;
                end;
                if (OutboundWarehouseHeading."Documnet Type" <> OutboundWarehouseHeading."Documnet Type"::"Receipt.Return") then begin
                    //AML QB_ST01 Precio Medio o FIFO
                    if Item."Costing Method" = Item."Costing Method"::FIFO then FIFOPrice else AvgPrice;
                end
                else begin
                    //AML QB_ST01 Para que funcionen correctamente las devoluciones.
                    //SE ha debido hacer as� ya que en las devoluciones llega aqui cuando ya se ha registrado el movimiento.
                    //Por eso lo buscamos directamente y ponemos el coste registrado.
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE("Item No.", "No.");
                    ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
                    ItemLedgerEntry.SETRANGE("Document No.", OutboundWarehouseHeading."Purchase Rcpt. No.");
                    ItemLedgerEntry.SETRANGE("QB Stocks Document Type", ItemLedgerEntry."QB Stocks Document Type"::"Return Receipt");
                    //ItemLedgerEntry.SETRANGE("Document No Stocks",OutboundWarehouseHeading."Purchase Rcpt. No.");
                    ItemLedgerEntry.SETRANGE("QB Stocks Output Shipment Line", "Line No.");
                    if ItemLedgerEntry.FINDSET then
                        repeat
                            ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                            SumCost -= ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)";
                            SumQt -= ItemLedgerEntry.Quantity;
                        until ItemLedgerEntry.NEXT = 0;
                    //SumQt := 3;
                    //SumCost := 48.9;
                    if SumQt <> 0 then "Unit Cost" := ROUND(SumCost / SumQt, GeneralLedgerSetup."Unit-Amount Rounding Precision");
                    SumQt := 0;
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE("Item No.", "No.");
                    ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
                    ItemLedgerEntry.SETFILTER("Document No.", '<>%1', OutboundWarehouseHeading."Purchase Rcpt. No.");
                    if ItemLedgerEntry.FINDSET then
                        repeat
                            SumQt += ItemLedgerEntry.Quantity;
                        until ItemLedgerEntry.NEXT = 0;
                    Stock := SumQt;
                    ///////Stock := 3;
                end;
                //+AML QB_ST01
            end;
        end;

        //Q16439 CPA 22/02/22.end
        AdjustUnitCost
        //Q16439 CPA 22/02/22.end
    end;

    LOCAL procedure ControlNegativos()
    var
        //       OutputShipmentLines@1100286000 :
        OutputShipmentLines: Record 7207309;
        //       Cantidad@1100286001 :
        Cantidad: Decimal;
        //       OutputShipmentHeader@1100286002 :
        OutputShipmentHeader: Record 7207308;
    begin
        //JAV 29/06/19: - Control para no dejar sacar mas del stock que el que existe en la obra
        if (Quantity = 0) then
            exit;

        //AML 25/07/22: - Cambiar el aviso si se deja el almac�n negativo
        OutputShipmentHeader.GET("Document No.");
        if OutputShipmentHeader."Automatic Shipment" then exit;

        QuoBuildingSetup.GET;
        if (QuoBuildingSetup."OLD_Location negative") then
            exit;

        //Miro la l�nea actual
        if (Quantity > Stock) then
            ERROR(Text002, "No.");

        //Ahora miro el total de l�neas del mismo producto
        Cantidad := Quantity;

        OutputShipmentLines.RESET;
        OutputShipmentLines.SETRANGE("Document No.", "Document No.");
        OutputShipmentLines.SETRANGE("No.", "No.");
        OutputShipmentLines.SETFILTER("Line No.", '<>%1', "Line No.");
        if (OutputShipmentLines.FINDSET(FALSE)) then
            repeat
                Cantidad += OutputShipmentLines.Quantity;
            until OutputShipmentLines.NEXT = 0;

        if (Cantidad > Stock) then
            ERROR(Text003, "No.");
    end;

    LOCAL procedure CalcAmounts()
    begin
        "Total Cost" := "Unit Cost" * Quantity;
        Amount := "Sales Price" * Quantity;
    end;

    LOCAL procedure AdjustUnitCost()
    var
        //       ItemLedgerEntry@1100286000 :
        ItemLedgerEntry: Record 32;
        //       Cantidad@1100286003 :
        Cantidad: Decimal;
        //       Importe@1100286001 :
        Importe: Decimal;
        //       GLSetup@1100286004 :
        GLSetup: Record 98;
        //       CantePendienteTotal@1100286002 :
        CantePendienteTotal: Decimal;
        //       CosteUnitarioPonderado@1100286005 :
        CosteUnitarioPonderado: Decimal;
        //       CosteMov@1100286006 :
        CosteMov: Decimal;
        //       CantPte@1100286007 :
        CantPte: Decimal;
        //       CantMov@1100286008 :
        CantMov: Decimal;
    begin
        //Q16439 CPA 22-02-22.begin
        exit; //AML QB_ST01 Ya no es necesario
        GLSetup.GET;

        if not Job.GET(OutboundWarehouseHeading."Job No.") then exit;

        CLEAR(Cantidad);
        CLEAR(Importe);

        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "No.");
        ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
        ItemLedgerEntry.SETFILTER("Posting Date", '..%1', OutboundWarehouseHeading."Posting Date");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.CALCSUMS("Remaining Quantity");
        CantePendienteTotal := ItemLedgerEntry."Remaining Quantity";

        if CantePendienteTotal <> 0 then begin
            //Si no hay movs. pendientes de liquidar para el c�lculo del coste unitario usamos los liquidados
            if ItemLedgerEntry.ISEMPTY then
                ItemLedgerEntry.SETRANGE(Open);

            CosteUnitarioPonderado := 0;
            if ItemLedgerEntry.FINDFIRST then begin
                repeat
                    ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
                    CosteMov := ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)";
                    Importe += CosteMov;

                    CantMov := ItemLedgerEntry.Quantity;
                    if (CantMov <> 0) then begin
                        CantPte := ItemLedgerEntry."Remaining Quantity";
                        CosteUnitarioPonderado += (CosteMov / CantMov) * (CantPte / CantePendienteTotal);
                        Cantidad += CantMov;
                    end;
                until ItemLedgerEntry.NEXT = 0
            end;

            //VALIDATE("Unit Cost", ROUND(Importe / Cantidad, GLSetup."Unit-Amount Rounding Precision"))
            VALIDATE("Unit Cost", ROUND(CosteUnitarioPonderado, GLSetup."Unit-Amount Rounding Precision"));
        end else
            VALIDATE("Unit Cost", 0);
        //Q16439 CPA 22-02-22.end
    end;

    LOCAL procedure AvgPrice()
    var
        //       SumCost@1100286001 :
        SumCost: Decimal;
        //       SumQt@1100286000 :
        SumQt: Decimal;
        //       ItemLedgerEntry@1100286002 :
        ItemLedgerEntry: Record 32;
    begin
        GeneralLedgerSetup.GET;
        //AML 24/3/22 QB_ST01 Codeunit para obtener el precio medio
        Item.GET("No.");
        Item.SETFILTER("Location Filter", Job."Job Location");
        Item.SETRANGE("Date Filter", 0D, OutboundWarehouseHeading."Request Date");
        Item.CALCFIELDS("Net Change");
        Stock := Item."Net Change";
        "Final Stock" := Stock - Quantity;
        if Item."Net Change" <= 0 then begin
            VALIDATE("Unit Cost", 0);
            exit;
        end;


        //AML 08/04/22: - QB 1.10.33 C�mbio en el c�lculo del precio
        Job.GET("Job No.");
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "No.");
        ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
        //ItemLedgerEntry.SETRANGE(Positive,TRUE);
        //ItemLedgerEntry.SETRANGE(Open,TRUE);
        ItemLedgerEntry.SETRANGE("Posting Date", 0D, OutboundWarehouseHeading."Request Date");
        if ItemLedgerEntry.FINDSET then
            repeat
                ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                //SumCost += ItemLedgerEntry."Remaining Quantity" * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
                //SumQt := SumQt + ItemLedgerEntry."Remaining Quantity";
                SumCost += (ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)");
                SumQt := SumQt + ItemLedgerEntry.Quantity;
            until (ItemLedgerEntry.NEXT = 0);
        //AML fin


        if SumQt <> 0 then
            VALIDATE("Unit Cost", ROUND(SumCost / SumQt, GeneralLedgerSetup."Unit-Amount Rounding Precision"))
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
        //       Anteriores@1100286004 :
        Anteriores: Decimal;
        //       rOutboundWarehouseLines@1100286006 :
        rOutboundWarehouseLines: Record 7207309;
        //       AntPend@1100286005 :
        AntPend: Decimal;
    begin
        //AML 24/3/22 QB_ST01 Codeunit para obtener el precio FIFO en funcion de las unidades
        GeneralLedgerSetup.GET;
        if Quantity = 0 then begin
            AvgPrice;
            exit;
        end;
        Item.GET("No.");
        Item.SETFILTER("Location Filter", Job."Job Location");
        Item.SETRANGE("Date Filter", 0D, OutboundWarehouseHeading."Request Date");
        Item.CALCFIELDS("Net Change");
        if Quantity > Item."Net Change" then begin
            AvgPrice;
            exit;
        end;
        Stock := Item."Net Change";
        "Final Stock" := Stock - Quantity;
        if "Cancel Mov." <> 0 then begin
            if ItemLedgerEntry.GET("Cancel Mov.") then begin
                ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                VALIDATE("Unit Cost", ROUND(((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity), GeneralLedgerSetup."Unit-Amount Rounding Precision"));
                exit;
            end;
        end;

        //-Q20085
        Anteriores := 0;

        rOutboundWarehouseLines.SETRANGE("Document No.", Rec."Document No.");
        rOutboundWarehouseLines.SETRANGE("Job No.", Rec."Job No.");
        rOutboundWarehouseLines.SETFILTER("Line No.", '< %1', Rec."Line No.");
        rOutboundWarehouseLines.SETRANGE("No.", Rec."No.");
        if rOutboundWarehouseLines.FINDSET then
            repeat
                Anteriores += rOutboundWarehouseLines.Quantity;
            until rOutboundWarehouseLines.NEXT = 0;

        AntPend := Anteriores;

        if (Stock - Quantity - Anteriores) < 0 then "Quantity (Base)" := Stock - Anteriores;

        SumCost := 0;
        SumQt := Quantity;
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "No.");
        ItemLedgerEntry.SETRANGE("Location Code", Job."Job Location");
        ItemLedgerEntry.SETRANGE(Positive, TRUE);
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.SETRANGE("Posting Date", 0D, OutboundWarehouseHeading."Request Date");
        if ItemLedgerEntry.FINDSET then
            repeat
                ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                if AntPend >= ItemLedgerEntry."Remaining Quantity" then begin
                    AntPend := AntPend - ItemLedgerEntry."Remaining Quantity";
                end
                else begin
                    ItemLedgerEntry."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity" - AntPend;
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
                    AntPend := 0;
                end;
            until (ItemLedgerEntry.NEXT = 0) or (SumQt = 0);

        //ItemLedgerEntry.RESET;
        //ItemLedgerEntry.SETRANGE("Item No.","No.");
        //ItemLedgerEntry.SETRANGE("Location Code",Job."Job Location");
        //ItemLedgerEntry.SETRANGE(Positive,TRUE);
        //ItemLedgerEntry.SETRANGE(Open,TRUE);
        //ItemLedgerEntry.SETRANGE("Posting Date",0D,OutboundWarehouseHeading."Request Date");
        //if ItemLedgerEntry.FINDSET then
        //repeat
        //   ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
        //     ItemLedgerEntry."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity" - AntPend;
        //     if SumQt > ItemLedgerEntry."Remaining Quantity" then begin
        //       SumCost += ItemLedgerEntry."Remaining Quantity" * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
        //       SumQt := SumQt - ItemLedgerEntry."Remaining Quantity";
        //     end
        //     else begin
        //       if SumQt = ItemLedgerEntry."Remaining Quantity" then begin
        //         SumCost += ItemLedgerEntry."Remaining Quantity" * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)")/ ItemLedgerEntry.Quantity);
        //       end
        //       else begin
        //         SumCost += SumQt * ((ItemLedgerEntry."Cost Amount (Expected)" + ItemLedgerEntry."Cost Amount (Actual)") / ItemLedgerEntry.Quantity);
        //       end;
        //       SumQt := 0;
        //     end;
        //until (ItemLedgerEntry.NEXT = 0) or (SumQt = 0);

        //+Q20085


        VALIDATE("Unit Cost", ROUND(SumCost / Quantity, GeneralLedgerSetup."Unit-Amount Rounding Precision"));
    end;

    LOCAL procedure CancelMov()
    var
        //       ItemLdgEntry@1100286000 :
        ItemLdgEntry: Record 32;
    begin
        if "Cancel Mov." = 0 then exit;
        if not ItemLdgEntry.GET("Cancel Mov.") then exit;
        if Quantity > ItemLdgEntry."Remaining Quantity" then ERROR('La cantidad m�xima a liquidar son %1', ItemLdgEntry."Remaining Quantity");
    end;

    /*begin
    //{
//      JAV 29/06/19: - Calculo del stock y del precio medio de coste del almac�n
//                    - Control para no dejar sacar mas del stock que el que existe en la obra
//      QMD 26/12/19: - Q8465 GAP10. Nuevo campo para calcular la cantidad
//      JAV 04/02/20: - Al cambiar la cantidad, modificar el stock restante
//                    - Aviso si se deja el almac�n negativo
//
//      CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras
//                    - Nuevos campos:
//                          "Item Rcpt. Entry No."
//                          "Cancellation"
//                          "Invoiced Quantity (Base)"
//
//      Q16439 CPA 22/02/22
//            Nuevas funciones
//                AdjustUnitCost
//            Modificaciones
//                CalcItemData
//      AML 23/03/22: - QB 1.10.30 QB_ST01 Modificada funci�n CalcItemData. y a�adidas funciones AvgPrice y FIFOPrice Anulada funcion AdjustUnitCost
//      AML 25/03/22: - QB 1.10.30 QB_ST01 Creados campos 100 y 101 para cancelacion de albaranes.
//      AML 08/04/22: - QB 1.10.33 C�mbio en el c�lculo del precio
//      CSM 11/05/22: - QB 1.10.42 (QBU17147) Mostrar columna de Concepto Anal�tico en la regularizaci�n de stock.
//      AML 25/07/22: - QB 1.11.01 Cambiar el aviso si se deja el almac�n negativo
//      PAT Q19156 11/04/23: - QB Salidas Almacen: Cambio a 5 decimales el campo Precio devolucion
//      AML 28/09/23: - Q20085 Cambios en el calculo de FIFO.
//    }
    end.
  */
}








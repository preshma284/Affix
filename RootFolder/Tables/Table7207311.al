table 7207311 "Posted Output Shipment Lines"
{


    CaptionML = ENU = 'Posted Warehouse Job Output Lines', ESP = 'Lineas Salida Almac�n Obra';
    LookupPageID = "Posted Subfor. Output Shpt Lin";
    DrillDownPageID = "Posted Subfor. Output Shpt Lin";

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


        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. cim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(10; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';


        }
        field(11; "Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost', ESP = 'Precio coste';
            AutoFormatType = 2;


        }
        field(12; "Outbound Warehouse"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Outbound Warehouse', ESP = 'Almac�n de salida';


        }
        field(13; "Produccion Unit"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));
            CaptionML = ENU = 'Produccion Unit', ESP = 'Unidad de produccion';


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


        }
        field(16; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure Code', ESP = 'Cod. unidad de medida';


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


        }
        field(21; "No. Serie for Tracking"; Code[20])
        {


            CaptionML = ENU = 'No. Serie for Tracking', ESP = 'No. Serie para seguimiento';

            trigger OnLookup();
            VAR
                //                                                               ItemTrackingDataCollection@7001100 :
                ItemTrackingDataCollection: Codeunit 6501;
                //                                                               TrackingSpecification@7001101 :
                TrackingSpecification: Record 336;
            BEGIN
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
        field(54; "Coste Ajustado"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(55; "Coste Anterior"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(103; "Devolucion"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.10.56 28/06/22 : AML';


        }
        field(104; "Precio Devolucion"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.10.56 28/06/22 : AML';


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount", "Total Cost", "Quantity";
            Clustered = true;
        }
        key(key2; "Job No.", "No.")
        {
            ;
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

    procedure GetCurrencyCode(): Code[10];
    var
        //       PurchInvHeader@1000 :
        PurchInvHeader: Record 122;
    begin
        if ("Document No." = PurchInvHeader."No.") then
            exit(PurchInvHeader."Currency Code")
        else
            if PurchInvHeader.GET("Document No.") then
                exit(PurchInvHeader."Currency Code")
            else
                exit('');
    end;

    procedure ShowDimensions()
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@7001100 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text;
    var
        //       Field@7001101 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Output Shipment Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    /*begin
    //{
//      CPA 03/12/21: QB 1.10.23 (Q15921) Errores detectados en almacenes de obras. Nuevos campos:
//                                           "Item Rcpt. Entry No."
//                                           "Cancellation"
//                                           "Invoiced Quantity (Base)"
//      JAV 02/06/22: - QB 1.10.46 Se a�aden las keys "Job No.,No." y "Document No.,No." para mejorar la velocidad
//      AML Creados campos QB_ST01
//      PAT Q19156 11/04/23: - QB Salidas Almacen: Cambio a 5 decimales el campo Precio devolucion
//    }
    end.
  */
}








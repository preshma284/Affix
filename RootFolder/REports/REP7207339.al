report 7207339 "Consumption Proposed"
{


    CaptionML = ENU = 'Consumption Proposed', ESP = 'Propuesta consumo';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Hist. Prod. Measure Lines"; "Hist. Prod. Measure Lines")
        {


            ;
            trigger OnPreDataItem();
            BEGIN
                OutboundWarehouseLines.LOCKTABLE;
                IF (Incluir = Incluir::Pendientes) THEN
                    SETRANGE("Output Processed", FALSE);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                // Por cada unidad de obra de las l¡neas localizadas hay que ir a su descompuesto y llevar los de tipo producto a las Lin. Alb. Salida
                DataPieceworkForProduction.SETRANGE("Job No.", "Hist. Prod. Measure Lines"."Job No.");
                DataPieceworkForProduction.SETRANGE("Piecework Code", "Hist. Prod. Measure Lines"."Piecework No.");
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataCostByPiecework.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                    DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                    DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Item);
                    DataCostByPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                    IF DataCostByPiecework.FINDFIRST THEN
                        REPEAT
                            CreateLinShipmentOutput(DataCostByPiecework);
                        UNTIL DataCostByPiecework.NEXT = 0;
                END;

                "Output Processed" := TRUE;
                MODIFY;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group538")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("DesdeFecha"; "DesdeFecha")
                    {

                        CaptionML = ENU = 'Bring products without inventory', ESP = 'Desde Fecha Producci¢n';
                    }
                    field("HastaFecha"; "HastaFecha")
                    {

                        CaptionML = ESP = 'Hasta Fecha Producci¢n';
                    }
                    field("Incluir"; "Incluir")
                    {

                        CaptionML = ESP = 'Incluir';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Item@100000012 :
        Item: Record 27;
        //       InventoryPostingSetup@100000009 :
        InventoryPostingSetup: Record 5813;
        //       OutputShipmentHeader@100000005 :
        OutputShipmentHeader: Record 7207308;
        //       OutboundWarehouseLines@7001100 :
        OutboundWarehouseLines: Record 7207309;
        //       DataPieceworkForProduction@7001101 :
        DataPieceworkForProduction: Record 7207386;
        //       DataCostByPiecework@7001102 :
        DataCostByPiecework: Record 7207387;
        //       Job@7001104 :
        Job: Record 167;
        //       FunctionQB@100000008 :
        FunctionQB: Codeunit 7207272;
        //       DimensionManagement@100000007 :
        DimensionManagement: Codeunit 408;
        //       DateMeasure@7001105 :
        DateMeasure: Text[250];
        //       Text001@100000004 :
        Text001: TextConst ESP = 'Existen l¡neas en el documento, se eliminar n antes de importar, ¨conforme?';
        //       Text002@7001106 :
        Text002: TextConst ENU = 'It is mandatory to fill in a date filter.', ESP = 'Es obligatorio rellenar un filtro de fechas.';
        //       HeaderDocumentNo@7001107 :
        HeaderDocumentNo: Code[20];
        //       LineNo@100000006 :
        LineNo: Integer;
        //       cnt@100000010 :
        cnt: Decimal;
        //       "---------------------- Opciones"@100000000 :
        "---------------------- Opciones": Integer;
        //       DesdeFecha@100000003 :
        DesdeFecha: Date;
        //       HastaFecha@100000001 :
        HastaFecha: Date;
        //       Incluir@100000002 :
        Incluir: Option "Pendientes","Todos";



    trigger OnInitReport();
    begin
        HastaFecha := WORKDATE;
    end;

    trigger OnPreReport();
    begin
        DateMeasure := STRSUBSTNO('%1..%2', DesdeFecha, HastaFecha);
        if DateMeasure = '..' then
            ERROR(Text002);

        OutboundWarehouseLines.RESET;
        OutboundWarehouseLines.SETRANGE("Document No.", HeaderDocumentNo);
        if (not OutboundWarehouseLines.ISEMPTY) then
            if not CONFIRM(Text001, FALSE) then
                ERROR('');
        OutboundWarehouseLines.DELETEALL;
        LineNo := 0;
    end;



    // procedure CreateLinShipmentOutput (P_DataCostByPiecework@7001100 :
    procedure CreateLinShipmentOutput(P_DataCostByPiecework: Record 7207387)
    begin
        OutboundWarehouseLines.RESET;
        OutboundWarehouseLines.SETRANGE("Document No.", HeaderDocumentNo);
        //-Q20086
        //OutboundWarehouseLines.SETRANGE("No.",P_DataCostByPiecework."No.");
        //if OutboundWarehouseLines.FINDFIRST then begin
        if OutboundWarehouseLines.FINDLAST then LineNo := OutboundWarehouseLines."Line No." else LineNo := 0;
        //+Q20086
        //{ -Q20086 Separamos por UO. Aunque sea el mismo art¡culo el gasto se debe separar.
        //        OutboundWarehouseLines.CalcItemData;
        //        cnt := OutboundWarehouseLines.Quantity + (DataCostByPiecework."Performance By Piecework" * "Hist. Prod. Measure Lines"."Measure Term");
        //        if (cnt > OutboundWarehouseLines.Stock) then
        //          cnt := OutboundWarehouseLines.Stock;
        //        OutboundWarehouseLines.VALIDATE(Quantity, cnt);
        //        OutboundWarehouseLines.MODIFY(TRUE);
        //      end else begin
        //      +Q20086}
        //JAV 10/11/21: - QB 1.09.27 No considerar mas que productos que sean de almac‚n
        Item.GET(P_DataCostByPiecework."No.");
        if (Item.Type = Item.Type::Inventory) then begin
            LineNo += 10000;
            OutboundWarehouseLines."Document No." := HeaderDocumentNo;
            OutboundWarehouseLines."Line No." := LineNo;
            OutboundWarehouseLines.INSERT(TRUE);

            OutboundWarehouseLines.VALIDATE("Job No.", Job."No.");
            OutboundWarehouseLines.VALIDATE("No.", P_DataCostByPiecework."No.");
            OutboundWarehouseLines.Description := Item.Description;
            OutboundWarehouseLines."Description 2" := Item."Description 2";
            // Buscamos el valor de la dim del CA y dependiendo de cual sea insertamos el valor desde P_DataCostByPiecework.
            InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."Analytic Concept", OutboundWarehouseLines."Dimension Set ID");
            DimensionManagement.UpdateGlobalDimFromDimSetID(OutboundWarehouseLines."Dimension Set ID", OutboundWarehouseLines."Shortcut Dimension 1 Code", OutboundWarehouseLines."Shortcut Dimension 2 Code");

            OutboundWarehouseLines.CalcItemData;
            cnt := DataCostByPiecework."Performance By Piecework" * "Hist. Prod. Measure Lines"."Measure Term";
            if (cnt > OutboundWarehouseLines.Stock) then
                cnt := OutboundWarehouseLines.Stock;
            OutboundWarehouseLines.VALIDATE(Quantity, cnt);

            OutboundWarehouseLines.VALIDATE(Amount);
            OutboundWarehouseLines."Outbound Warehouse" := Job."Job Location";
            OutboundWarehouseLines."Produccion Unit" := P_DataCostByPiecework."Piecework Code";
            OutboundWarehouseLines."Unit of Measure Code" := Item."Base Unit of Measure";
            OutboundWarehouseLines.Billable := TRUE;
            OutboundWarehouseLines.MODIFY(TRUE);
        end;
        //-Q20086
        //end;
        //+Q20086
    end;

    //     procedure SetLineShipmentOutput (var pOutboundWarehouseLines@7001100 :
    procedure SetLineShipmentOutput(var pOutboundWarehouseLines: Record 7207309)
    begin
        HeaderDocumentNo := pOutboundWarehouseLines."Document No.";
        OutputShipmentHeader.GET(HeaderDocumentNo);
        Job.GET(OutputShipmentHeader."Job No.");
    end;

    //     procedure CreateLinShipmentOutputBAK (P_DataCostByPiecework@7001100 :
    procedure CreateLinShipmentOutputBAK(P_DataCostByPiecework: Record 7207387)
    begin
        OutboundWarehouseLines.RESET;
        OutboundWarehouseLines.SETRANGE("Document No.", HeaderDocumentNo);
        OutboundWarehouseLines.SETRANGE("No.", P_DataCostByPiecework."No.");
        if OutboundWarehouseLines.FINDFIRST then begin
            OutboundWarehouseLines.CalcItemData;
            cnt := OutboundWarehouseLines.Quantity + (DataCostByPiecework."Performance By Piecework" * "Hist. Prod. Measure Lines"."Measure Term");
            if (cnt > OutboundWarehouseLines.Stock) then
                cnt := OutboundWarehouseLines.Stock;
            OutboundWarehouseLines.VALIDATE(Quantity, cnt);
            OutboundWarehouseLines.MODIFY(TRUE);
        end else begin
            //JAV 10/11/21: - QB 1.09.27 No considerar mas que productos que sean de almac‚n
            Item.GET(P_DataCostByPiecework."No.");
            if (Item.Type = Item.Type::Inventory) then begin
                LineNo += 10000;
                OutboundWarehouseLines."Document No." := HeaderDocumentNo;
                OutboundWarehouseLines."Line No." := LineNo;
                OutboundWarehouseLines.INSERT(TRUE);

                OutboundWarehouseLines.VALIDATE("Job No.", Job."No.");
                OutboundWarehouseLines.VALIDATE("No.", P_DataCostByPiecework."No.");
                OutboundWarehouseLines.Description := Item.Description;
                OutboundWarehouseLines."Description 2" := Item."Description 2";
                // Buscamos el valor de la dim del CA y dependiendo de cual sea insertamos el valor desde P_DataCostByPiecework.
                InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group");
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."Analytic Concept", OutboundWarehouseLines."Dimension Set ID");
                DimensionManagement.UpdateGlobalDimFromDimSetID(OutboundWarehouseLines."Dimension Set ID", OutboundWarehouseLines."Shortcut Dimension 1 Code", OutboundWarehouseLines."Shortcut Dimension 2 Code");

                OutboundWarehouseLines.CalcItemData;
                cnt := DataCostByPiecework."Performance By Piecework" * "Hist. Prod. Measure Lines"."Measure Term";
                if (cnt > OutboundWarehouseLines.Stock) then
                    cnt := OutboundWarehouseLines.Stock;
                OutboundWarehouseLines.VALIDATE(Quantity, cnt);

                OutboundWarehouseLines.VALIDATE(Amount);
                OutboundWarehouseLines."Outbound Warehouse" := Job."Job Location";
                OutboundWarehouseLines."Produccion Unit" := P_DataCostByPiecework."Piecework Code";
                OutboundWarehouseLines."Unit of Measure Code" := Item."Base Unit of Measure";
                OutboundWarehouseLines.Billable := TRUE;
                OutboundWarehouseLines.MODIFY(TRUE);
            end;
        end;
    end;

    /*begin
    //{
//      TO-DO: Cuando genera el diario, que elimine las l¡neas a cero que no hacen falta para nada.
//      AML Q20086 Cambio en la propuesta de consumo, para que no agrupe productos.
//    }
    end.
  */

}




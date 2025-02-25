report 7207341 "Bring Item for Adjustment"
{


    CaptionML = ENU = 'Bring Item for Adjustment', ESP = 'Traer productos para ajustes';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Line Regularization Stock"; "Line Regularization Stock")
        {

            DataItemTableView = SORTING("Document No.", "Line No.");
            ;
            DataItem("Item"; "Item")
            {

                DataItemTableView = SORTING("No.");


                RequestFilterFields = "No.", "Inventory Posting Group", "Gen. Prod. Posting Group";
                CalcFields = Inventory, "Net Change";
                trigger OnPreDataItem();
                BEGIN
                    FilterItem1 := Item.GETFILTER("Inventory Posting Group");
                    FilterItem2 := Item.GETFILTER("Gen. Prod. Posting Group");
                    Window.OPEN(Text000 +
                                Text001 +
                                Text002);

                    Total := Item.COUNT;

                    Item.SETRANGE("Location Filter", CLocation);
                    Item.SETRANGE("Date Filter", 0D, HeaderRegularizationStock."Regularization Date");
                    Total := Item.COUNT;
                    HeaderRegularizationStock.SETRANGE("No.", Filter);
                    IF HeaderRegularizationStock.FINDFIRST THEN
                        Job.SETRANGE("Job Location", HeaderRegularizationStock."Location Code");
                    IF Job.FINDFIRST THEN;
                END;

                trigger OnAfterGetRecord();
                VAR
                    //                                   JobVL@1100286001 :
                    JobVL: Record 167;
                    //                                   ItemVL@1100286000 :
                    ItemVL: Record 27;
                    //                                   InventoryPostingSetup@1100286003 :
                    InventoryPostingSetup: Record 5813;
                    //                                   FunctionQB@1100286002 :
                    FunctionQB: Codeunit 7207272;
                BEGIN
                    Read := Read + 1;

                    Window.UPDATE(1, ROUND(Read / Total * 10000, 1));
                    Window.UPDATE(2, Text003);
                    Window.UPDATE(3, Read);
                    Window.UPDATE(4, Total);


                    ItemLedgerEntry3.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                    ItemLedgerEntry3.RESET;
                    ItemLedgerEntry3.SETRANGE("Item No.", "No.");
                    ItemLedgerEntry3.SETRANGE("Location Code", CLocation);
                    ItemLedgerEntry3.SETFILTER("Posting Date", '..%1', HeaderRegularizationStock."Regularization Date");
                    IF ItemLedgerEntry3.ISEMPTY THEN CurrReport.SKIP;

                    IF NOT opcZeroInvItem AND (Item."Net Change" = 0) THEN CurrReport.SKIP;

                    LineRegularizationStock.INIT;
                    LineRegularizationStock.VALIDATE("Document No.", Filter);
                    LineRegularizationStock.VALIDATE("Line No.", NoLine);
                    LineRegularizationStock.INSERT;
                    LineRegularizationStock.VALIDATE("Item No.", "No.");
                    LineRegularizationStock.VALIDATE("Job No.", Job."No.");                 //JMMA 17/03/21 Se cambia := por validate

                    //QBU17146 11/05/22 CSM Í Cargar en blanco N§ ud. Obra en la regularizaci¢n. -
                    // {
                    // //QBU17146 11/05/22 CSM Í Cargar en blanco N§ ud. Obra en la regularizaci¢n. +
                    // LineRegularizationStock."Piecework No." := Job."Warehouse Cost Unit";  //JAV 30/03/21: - QB 1.08.31 se cambia el campo que era err¢neo
                    // //QBU17146 11/05/22 CSM Í Cargar en blanco N§ ud. Obra en la regularizaci¢n. -
                    // }

                    LineRegularizationStock."Piecework No." := '';
                    //QBU17146 11/05/22 CSM Í Cargar en blanco N§ ud. Obra en la regularizaci¢n. +

                    //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. -
                    //LineRegularizationStock.VALIDATE("Shortcut Dimension 2 Code", '');
                    JobVL.GET(LineRegularizationStock."Job No.");
                    ItemVL.GET(LineRegularizationStock."Item No.");
                    ConfQB.GET;

                    InventoryPostingSetup.GET(JobVL."Job Location", ItemVL."Inventory Posting Group");
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                        IF ConfQB."CA in Stock Regularization" THEN
                            LineRegularizationStock."Shortcut Dimension 1 Code" := InventoryPostingSetup."Analytic Concept"
                        ELSE
                            LineRegularizationStock.VALIDATE("Shortcut Dimension 1 Code", '');
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                        IF ConfQB."CA in Stock Regularization" THEN
                            LineRegularizationStock."Shortcut Dimension 2 Code" := InventoryPostingSetup."Analytic Concept"
                        ELSE
                            LineRegularizationStock.VALIDATE("Shortcut Dimension 2 Code", '');
                    //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. +

                    //CPA 14/02/22. Q16245.Begin 
                    CLEAR(Cantidad);
                    CLEAR(CostePendiente);
                    //CPA 14/02/22. Q16245.End

                    //PSM 080621+
                    ItemLedgerEntry2.RESET;
                    ItemLedgerEntry2.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                    ItemLedgerEntry2.SETRANGE("Item No.", "No.");
                    ItemLedgerEntry2.SETRANGE("Location Code", CLocation);
                    IF (opcRegDate) THEN  //JAV 02/02/22: - QB 1.01.15 Opci¢n para no usar la fecha de regularizaci¢n sino el stock total
                        ItemLedgerEntry2.SETFILTER("Posting Date", '..%1', HeaderRegularizationStock."Regularization Date");
                    //CPA 14/02/22. Q16245.Begin 
                    IF ItemLedgerEntry2.ISEMPTY THEN
                        ItemLedgerEntry2.SETRANGE(Open);
                    //CPA 14/02/22. Q16245.End
                    IF ItemLedgerEntry2.FINDFIRST THEN
                        REPEAT
                            ItemLedgerEntry2.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
                            CosteMov := ItemLedgerEntry2."Cost Amount (Expected)" + ItemLedgerEntry2."Cost Amount (Actual)";
                            CantidadMov := ItemLedgerEntry2.Quantity;
                            Cantidad += CantidadMov;
                            CostePendiente += CosteMov;
                        UNTIL ItemLedgerEntry2.NEXT = 0;
                    IF Cantidad <> 0 THEN CosteUnitarioPonderado := CostePendiente / Cantidad; //AML

                    IF Cantidad <> 0 THEN BEGIN
                        //PSM 270122+
                        LineRegularizationStock.VALIDATE("Calculated Stocks", Cantidad);
                        LineRegularizationStock.VALIDATE("Current Stocks", 0);
                        //PSM 270122-

                        //CPA 14/02/22. Q16245.Begin 
                        LineRegularizationStock.VALIDATE("Unit Cost", CosteUnitarioPonderado); //AML
                        LineRegularizationStock."Total Cost" := -CostePendiente; //AML
                                                                                 //CPA 14/02/22. Q16245.End
                    END ELSE BEGIN
                        LineRegularizationStock.VALIDATE("Unit Cost", 0);
                        LineRegularizationStock.VALIDATE("Current Stocks", Cantidad);
                        LineRegularizationStock.VALIDATE("Calculated Stocks", Cantidad);
                    END;
                    //PSM 080621-
                    LineRegularizationStock.MODIFY;
                    NoLine += 10000;
                    //UNTIL NEXT =0;
                END;

                trigger OnPostDataItem();
                BEGIN
                    //Window.CLOSE;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                HeaderRegularizationStock.GET(Filter);
                CLocation := HeaderRegularizationStock."Location Code";

                "Line Regularization Stock".SETRANGE("Document No.", Filter);
                IF "Line Regularization Stock".FINDLAST THEN
                    NoLine := "Line Regularization Stock"."Line No." + 10000
                ELSE
                    NoLine := 10000;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group543")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcZeroInvItem"; "opcZeroInvItem")
                    {

                        CaptionML = ENU = 'Bring products without inventory', ESP = 'Traerse productos sin inventario';
                    }
                    field("opcRegDate"; "opcRegDate")
                    {

                        CaptionML = ENU = 'Bring stock to the regularization date', ESP = 'Traer stock a la fecha de regularizaci¢n';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Filter@7001100 :
        Filter: Code[20];
        //       HeaderRegularizationStock@7001101 :
        HeaderRegularizationStock: Record 7207408;
        //       CLocation@7001102 :
        CLocation: Code[20];
        //       NoLine@7001103 :
        NoLine: Integer;
        //       Window@7001104 :
        Window: Dialog;
        //       Text000@7001105 :
        Text000: TextConst ENU = 'Creating lines with item\', ESP = 'Creando l¡neas con productos\';
        //       Text001@7001106 :
        Text001: TextConst ENU = '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\', ESP = '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        //       Text002@7001107 :
        Text002: TextConst ENU = '#2##########  #3###### #4#########';
        //       CodLocation@7001108 :
        CodLocation: Code[20];
        //       Total@7001109 :
        Total: Integer;
        //       Job@7001110 :
        Job: Record 167;
        //       Read@7001111 :
        Read: Integer;
        //       Text003@7001112 :
        Text003: TextConst ENU = 'Item No.', ESP = 'N§ Producto';
        //       LineRegularizationStock@7001113 :
        LineRegularizationStock: Record 7207409;
        //       ItemLedgerEntry@7001114 :
        ItemLedgerEntry: Record 32;
        //       FilterItem1@7001115 :
        FilterItem1: Text[100];
        //       FilterItem2@7001116 :
        FilterItem2: Text[100];
        //       ItemLedgerEntry2@1100286000 :
        ItemLedgerEntry2: Record 32;
        //       Cantidad@1100286003 :
        Cantidad: Decimal;
        //       CosteUnitarioPonderado@1100286005 :
        CosteUnitarioPonderado: Decimal;
        //       CosteMov@1100286006 :
        CosteMov: Decimal;
        //       CantidadMov@1100286007 :
        CantidadMov: Decimal;
        //       CostePendiente@1100286009 :
        CostePendiente: Decimal;
        //       InvoicePostBuffer@1100286010 :
        InvoicePostBuffer: Record 49 TEMPORARY;
        //       ItemLedgerEntry3@1100286011 :
        ItemLedgerEntry3: Record 32;
        //       InvtAdjmt@1100286001 :
        InvtAdjmt: Codeunit 5895;
        //       RecItem@1100286002 :
        RecItem: Record 27;
        //       "------------------------------ Opciones"@1100286012 :
        "------------------------------ Opciones": Integer;
        //       opcZeroInvItem@1100286008 :
        opcZeroInvItem: Boolean;
        //       opcRegDate@1100286004 :
        opcRegDate: Boolean;
        //       ConfQB@1100286013 :
        ConfQB: Record 7207278;



    trigger OnInitReport();
    begin
        //JMMA opcZeroInvItem := TRUE;
        opcZeroInvItem := FALSE;
        opcRegDate := TRUE;
    end;

    trigger OnPreReport();
    begin
        Filter := "Line Regularization Stock".GETFILTER("Document No.");
        InvtAdjmt.SetProperties(FALSE, FALSE);
        InvtAdjmt.SetFilterItem(RecItem);
        InvtAdjmt.MakeMultiLevelAdjmt;
    end;



    // LOCAL procedure CalcularUnidades (CodItem@1100286000 : Code[20];FilterDate@1100286001 :
    LOCAL procedure CalcularUnidades(CodItem: Code[20]; FilterDate: Date)
    var
        //       RecItem@1100286002 :
        RecItem: Record 27;
    begin
        RecItem.GET(CodItem);
        RecItem.SETRANGE("Date Filter", 0D, HeaderRegularizationStock."Regularization Date");
        RecItem.SETRANGE("Location Filter", HeaderRegularizationStock."Location Code");
    end;

    LOCAL procedure CalcularCoste()
    begin
    end;

    /*begin
    //{
//      PSM 27/01/22: - Guardar cantidad pendiente en la l¡nea del diario
//      JAV 02/02/22: - Opci¢n para usar o no la fecha de regularizaci¢n
//      CPA 14/02/22: - QB 1.10.23 (Q16245) - Registro de regularizaci¢n de Stock. Cambiado Item - OnAfterGetRecord() y ItemsInLedgerEntry - OnAfterGetRecord()
//      AML 22/03/22: - QB 1.10.30 (QB_ST01) Modificado el funcionamiento y se deja en un solo Item.
//      QBU17146 CSM 11/05/22 Í Cargar en blanco N§ ud. Obra en la regularizaci¢n.
//      QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock, y cargarla en blanco.
//    }
    end.
  */

}




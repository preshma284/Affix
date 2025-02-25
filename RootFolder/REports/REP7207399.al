report 7207399 "Cancellation of outs.shipments"
{


    Permissions = TableData 120 = rimd,
                TableData 121 = rimd;
    CaptionML = ENU = 'Cancellation of outs.shipments', ESP = 'Anulaci¢n albaranes pendientes de recibir';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {

            DataItemTableView = SORTING("No.");

            ;
            trigger OnAfterGetRecord();
            BEGIN
                //IF (GETRANGEMIN("No.") <> GETRANGEMAX("No.")) THEN
                //  ERROR(Text001);

                IF Cancelled THEN
                    ERROR(Text002);

                IF (opcPostingDate = 0D) THEN
                    ERROR(Text003);

                IF (opcPostingDate < "Posting Date") THEN
                    ERROR(Text007, "Posting Date");

                IF NOT Vendor.GET("Buy-from Vendor No.") THEN BEGIN
                    ERROR(Text50000, "Buy-from Vendor No.");
                END ELSE BEGIN
                    IF Vendor.Blocked <> Vendor.Blocked::" " THEN
                        ERROR(Text50001, "Buy-from Vendor No.");
                END;

                //JAV 28/04/22: - QB 1.10.38 Guardo usuario y fecha en que se cancel¢
                "Purch. Rcpt. Header"."QB Canceled By" := USERID;
                "Purch. Rcpt. Header"."QB Canceled in Date" := TODAY;
                "Purch. Rcpt. Header"."QB Canceled With Date" := opcPostingDate;
                "Purch. Rcpt. Header".MODIFY;

                //Guardo la fecha y la cambio por la de anulaci¢n, asi las funciones del est ndar funcionan correctamente. JAV 28/04/22: - QB 1.10.38 Cambio para que anule con la fecha correctamente en las l¡neas
                TmpPostingDate := "Posting Date";   //Me guardo la fecha original para recuperarla luego  JAV 11/07/22: - QB 1.11.00 Cambio de lugar la l¡nea para que se guarde siempre
                IF ("Purch. Rcpt. Header"."Posting Date" <> opcPostingDate) THEN BEGIN
                    "Purch. Rcpt. Header"."Posting Date" := opcPostingDate;
                    "Purch. Rcpt. Header".MODIFY;

                    PurchRcptLine1.RESET;
                    PurchRcptLine1.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                    PurchRcptLine1.MODIFYALL("Posting Date", opcPostingDate);

                    LastVE := 0;
                    ValueEntry.RESET;
                    ValueEntry.SETCURRENTKEY("Document No.");
                    ValueEntry.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                    IF (ValueEntry.FINDSET(TRUE)) THEN
                        REPEAT
                            ValueEntry."Posting Date" := opcPostingDate;
                            ValueEntry.MODIFY(FALSE);
                            IF (ValueEntry."Entry No." > LastVE) THEN
                                LastVE := ValueEntry."Entry No.";
                        UNTIL (ValueEntry.NEXT = 0);
                END;

                //Cancelamos las l¡neas del albar n
                OutCreated := FALSE;
                nLineas := 0;
                PurchRcptLine1.RESET;
                PurchRcptLine1.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                PurchRcptLine1.SETRANGE(Correction, FALSE);
                //>> PSM 24/10/22
                PurchRcptLine1.SETFILTER("No.", '<>%1', '');
                //<< PSM 24/10/22
                IF (PurchRcptLine1.FINDSET(FALSE)) THEN
                    REPEAT
                        //JAV 06/07/22: - QB 1.10.59 Saltarse l¡neas sin c¢digo de producto/recurso/cuenta
                        IF (PurchRcptLine1."No." <> '') THEN BEGIN
                            PurchRcptLine3.RESET;
                            PurchRcptLine3.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                            PurchRcptLine3.SETRANGE(Correction, TRUE);
                            PurchRcptLine3.SETFILTER("Line No.", '>%1', PurchRcptLine1."Line No.");
                            IF (PurchRcptLine3.FINDSET(FALSE)) THEN;
                            Job.GET(PurchRcptLine1."Job No.");
                            Cantidad := PurchRcptLine1.Quantity - PurchRcptLine1."Quantity Invoiced";
                            IF (Cantidad <> 0) THEN BEGIN
                                nLineas += 1;
                                CancelLine(PurchRcptLine1, FALSE);
                            END;
                        END;
                    UNTIL PurchRcptLine1.NEXT = 0;

                IF (OutCreated) THEN
                    PostPurchaseRcptOutput.RUN(OutputShipmentHeader);

                //Recupero la fecha y marco cancelado. JAV 28/04/22: - QB 1.10.38 Cambio para que anule con la fecha correctamente en las l¡neas, recupero la original
                IF ("Posting Date" <> TmpPostingDate) THEN BEGIN
                    "Purch. Rcpt. Header"."Posting Date" := TmpPostingDate;

                    PurchRcptLine1.RESET;
                    PurchRcptLine1.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                    PurchRcptLine1.SETRANGE(Cancelled, TRUE); //JAV 08/07/22: - QB 1.11.00 Solo cambiar l¡neas canceladas, las de cancelaci¢n se quedan con la fecha en que se cancelaron
                    PurchRcptLine1.MODIFYALL("Posting Date", TmpPostingDate);  //JAV 08/07/22: - QB 1.11.00 Estaba poniendo la fecha nueva en lugar de la original

                    IF (LastVE <> 0) THEN BEGIN
                        ValueEntry.RESET;
                        ValueEntry.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                        ValueEntry.SETRANGE("Entry No.", 0, LastVE);
                        ValueEntry.MODIFYALL("Posting Date", TmpPostingDate);  //JAV 08/07/22: - QB 1.11.00 Estaba poniendo la fecha nueva en lugar de la original
                    END;
                END;

                "Purch. Rcpt. Header".Cancelled := TRUE;
                "Purch. Rcpt. Header".MODIFY;

                //-Q20392
                ControlContratos("Purch. Rcpt. Header");
                //+Q20392
                //Mensaje final
                IF (nLineas = 0) THEN
                    ERROR('Nada que cancelar')
                ELSE
                    MESSAGE('Se han cancelado %1 lineas', nLineas);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group733")
                {

                    field("opcPostingDate"; "opcPostingDate")
                    {

                        CaptionML = ESP = 'PostingDate';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       opcPostingDate@1100286000 :
        opcPostingDate: Date;
        //       "--------------------------------------"@1100286004 :
        "--------------------------------------": Integer;
        //       Text000@7001116 :
        Text000: TextConst ENU = 'The shipment number %1 has been canceled', ESP = 'Se ha anulado el albar n N§ %1';
        //       Text001@7001115 :
        Text001: TextConst ENU = 'This process is only valid for a single shipment each time', ESP = 'Este proceso es £nicamente v lido para un £nico albar n cada vez';
        //       Text002@7001114 :
        Text002: TextConst ENU = 'This shipment already been canceled', ESP = 'Este albar n ya ha sido anulado';
        //       Text003@7001113 :
        Text003: TextConst ENU = 'Enter a posting date', ESP = 'Introduzca una fecha de registro';
        //       Text004@7001112 :
        Text004: TextConst ESP = 'El albar n N§ %1 no se puede anular porque ya est  facturado';
        //       Text005@1100286005 :
        Text005: TextConst ENU = 'The shipment number %1 has been canceled', ESP = 'Anulaci¢n del albar n N§ %1';
        //       Text006@1100286027 :
        Text006: TextConst ESP = 'No hay espacio para la l¡nea de anulaci¢n';
        //       Text007@1100286030 :
        Text007: TextConst ENU = 'Enter a posting date', ESP = 'No pude anular en una anterior a la del albar n (%1)';
        //       Text50000@7001111 :
        Text50000: TextConst ENU = 'There is no shipment %1', ESP = 'No exite el proveedor %1';
        //       Text50001@7001110 :
        Text50001: TextConst ENU = 'The vendor %1 is blocked.', ESP = 'El proveedor %1 esta bloqueado.';
        //       PurchaseHeader@1100286034 :
        PurchaseHeader: Record 38;
        //       tmpPurchaseHeader@1100286026 :
        tmpPurchaseHeader: Record 38 TEMPORARY;
        //       PurchRcptHeader@1100286033 :
        PurchRcptHeader: Record 120;
        //       PurchRcptLine1@1100286020 :
        PurchRcptLine1: Record 121;
        //       PurchRcptLine2@1100286003 :
        PurchRcptLine2: Record 121;
        //       tmpPurchRcptLine@1100286014 :
        tmpPurchRcptLine: Record 121 TEMPORARY;
        //       Vendor@1100286021 :
        Vendor: Record 23;
        //       Job@1100286022 :
        Job: Record 167;
        //       Item@1100286001 :
        Item: Record 27;
        //       TempWhseJnlLine@1100286019 :
        TempWhseJnlLine: Record 7311 TEMPORARY;
        //       TempGlobalItemLedgEntry@1100286018 :
        TempGlobalItemLedgEntry: Record 32 TEMPORARY;
        //       TempGlobalItemEntryRelation@1100286017 :
        TempGlobalItemEntryRelation: Record 6507 TEMPORARY;
        //       OutputShipmentHeader@1100286012 :
        OutputShipmentHeader: Record 7207308;
        //       OutputShipmentLines@1100286009 :
        OutputShipmentLines: Record 7207309;
        //       ItemJnlLine@1100286029 :
        ItemJnlLine: Record 83;
        //       PurchLine@1100286028 :
        PurchLine: Record 39;
        //       SourceCodeSetup@1100286025 :
        SourceCodeSetup: Record 242;
        //       TempApplyToEntryList@1100286024 :
        TempApplyToEntryList: Record 32 TEMPORARY;
        //       ItemApplicationEntry@1100286023 :
        ItemApplicationEntry: Record 339;
        //       PurchRcptLine3@1100286035 :
        PurchRcptLine3: Record 121;
        //       ValueEntry@1100286036 :
        ValueEntry: Record 5802;
        //       UndoPostingMgt@1100286016 :
        UndoPostingMgt: Codeunit 5817;
        //       WhseUndoQty@1100286015 :
        WhseUndoQty: Codeunit 7320;
        //       PurchaseRcptPendingInvoice@1100286013 :
        PurchaseRcptPendingInvoice: Codeunit 7207295;
        //       PostPurchaseRcptOutput@1100286002 :
        PostPurchaseRcptOutput: Codeunit 7207276;
        //       UndoPurchaseReceiptLine@1100286032 :
        UndoPurchaseReceiptLine: Codeunit 5813;
        //       ItemJnlPostLine@1011 :
        ItemJnlPostLine: Codeunit 22;
        //       Cantidad@1100286011 :
        Cantidad: Decimal;
        //       nLineas@1100286010 :
        nLineas: Integer;
        //       OutLine@1100286008 :
        OutLine: Integer;
        //       OutCreated@1100286007 :
        OutCreated: Boolean;
        //       NextLineNo@1100286006 :
        NextLineNo: Integer;
        //       LineSpacing@1006 :
        LineSpacing: Integer;
        //       TmpPostingDate@1100286031 :
        TmpPostingDate: Date;
        //       LastVE@1100286037 :
        LastVE: Integer;
        //       "//Q20392"@1100286038 :
        "//Q20392": Integer;
        //       ImpAnulaci¢n@1100286039 :
        ImpAnulacion: Decimal;



    trigger OnInitReport();
    begin
        opcPostingDate := WORKDATE;
    end;



    // procedure CancelLine (PurchRcptLine@1100286000 : Record 121;pRegJobShip@1100286001 :
    procedure CancelLine(PurchRcptLine: Record 121; pRegJobShip: Boolean)
    var
        //       OrderLine@1100286002 :
        OrderLine: Record 39;
        //       PurchRcptLineCanceled@1100286003 :
        PurchRcptLineCanceled: Record 121;
        //       OutShipmentItemLedgerEntry@1100286004 :
        OutShipmentItemLedgerEntry: Record 32;
        //       JobAux@1100286006 :
        JobAux: Record 167;
        //       Save_Job@1100286005 :
        Save_Job: Code[20];
    begin
        //Guardo la l¡nea y ajusto las cantidades para el proceso
        tmpPurchRcptLine := PurchRcptLine;

        PurchRcptLine.Quantity := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
        PurchRcptLine."Quantity (Base)" := PurchRcptLine.Quantity;
        PurchRcptLine."Qty. Rcd. not Invoiced" := PurchRcptLine.Quantity;
        PurchRcptLine."Quantity Invoiced" := 0;
        PurchRcptLine."Qty. Invoiced (Base)" := 0;
        PurchRcptLine."Location Code" := Job."Job Location";
        PurchRcptLine.MODIFY;

        //Filtramos que solo sea la l¡nea enviada
        PurchRcptLine.RESET;
        PurchRcptLine.SETRANGE("Document No.", tmpPurchRcptLine."Document No.");
        PurchRcptLine.SETRANGE("Line No.", tmpPurchRcptLine."Line No.");

        //Si es un movimiento de producto hay que deshacerlo
        if (PurchRcptLine.Type = PurchRcptLine.Type::Item) then begin
            //JAV 17/12/21: - QB 1.10.09 Guardamos el registro de cabecera del pedido y cambiamos datos para que luego no afecten
            if PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchRcptLine."Order No.") then begin
                tmpPurchaseHeader := PurchaseHeader;
                PurchaseHeader."QB % Proformar" := 0;  //No podemos poner cantidad a proformar en el pedido en este punto
                PurchaseHeader.MODIFY;
            end;

            CLEAR(UndoPurchaseReceiptLine);
            UndoPurchaseReceiptLine.SetHideDialog(TRUE);

            //CPA 28/01/22. Q16247 - Deshacer l¡neas de recepci¢n de compras de productos da error.begin
            //Ponemos la l¡nea como cancelada antes de ejecutar la CU est ndar para que no entre en bucle infinito.
            //AML QB_ST01 se solucionan los problemas.
            /////////////////////////////PurchRcptLine.Cancelled := TRUE; //Quitado por AML QB_ST01 23/03/22
            //CPA 28/01/22. Q16247 - Deshacer l¡neas de recepci¢n de compras de productos da error.end
            //AML Problemas solucionados.
            //-AML QB_ST01 Para que no ejecute la funcionalidad de anulaci¢n de la compra.
            if PurchaseHeader."QB Stocks New Functionality" then begin
                Save_Job := PurchRcptLine."Job No.";
                //JAV 11/07/22: - QB 1.11.00 Solo si va al almac‚n del proyecto hay que hacer esto
                if (not JobAux.GET(PurchRcptLine."Job No.")) then
                    JobAux.INIT;
                if (PurchRcptLine."Piecework NÂº" <> '') and (PurchRcptLine."Piecework NÂº" = JobAux."Warehouse Cost Unit") then begin
                    PurchRcptLine."Job No." := '';
                    PurchRcptLine.MODIFY;
                end;
            end;
            //+AML QB_ST01

            UndoPurchaseReceiptLine.RUN(PurchRcptLine);

            //-AML QB_ST01 Y volvemos a dejar el Job como estaba
            if PurchaseHeader."QB Stocks New Functionality" then begin
                PurchRcptLine."Job No." := Save_Job;
                PurchRcptLine.MODIFY;
            end;
            //+AML QB_ST01

            //JAV 04/04/21: - QB 1.08.32 Cancelar el movimiento del almac‚n del proyecto
            if (PurchRcptLine."Piecework NÂº" = Job."Warehouse Cost Unit") then
            //Q20061-
            begin
                //Q20061+
                //CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras.begin
                OutShipmentItemLedgerEntry.RESET;
                OutShipmentItemLedgerEntry.SETRANGE("Document Type", OutShipmentItemLedgerEntry."Document Type"::"Purchase Receipt");
                OutShipmentItemLedgerEntry.SETRANGE("Document No.", PurchRcptLine."Document No.");
                OutShipmentItemLedgerEntry.SETRANGE("Source No.", FORMAT(PurchRcptLine."Line No."));
                OutShipmentItemLedgerEntry.SETRANGE("QB Automatic Shipment", TRUE);
                if OutShipmentItemLedgerEntry.FINDFIRST then begin
                    tmpPurchRcptLine."Item Rcpt. Entry No." := OutShipmentItemLedgerEntry."Entry No.";
                end;
                //CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras.end
                CreateOutputShipmentLine(tmpPurchRcptLine);
                //Q20061-
            end;
            //Q20061+

            //JAV 17/12/21: - QB 1.10.09 Recupero datos del registro de cabecera del pedido con los datos que he guardado antes
            if PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchRcptLine."Order No.") then begin
                PurchaseHeader."QB % Proformar" := tmpPurchaseHeader."QB % Proformar";
                PurchaseHeader.MODIFY;
            end;
        end;

        //JAV 14/04/21: - QB 1.08.39 Retornar la cantidad recibida
        if (PurchRcptLine.Type IN [PurchRcptLine.Type::Resource, PurchRcptLine.Type::"G/L Account"]) then begin
            if (OrderLine.GET(OrderLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.")) then begin
                OrderLine."Quantity Received" -= PurchRcptLine.Quantity;
                OrderLine."Qty. Received (Base)" := OrderLine."Qty. Received (Base)" - PurchRcptLine."Quantity (Base)";
                OrderLine.InitOutstanding;    //Esto calcula la cantidad pendiente
                OrderLine.InitQtyToReceive;   //JAV 30/06/22: - QB 1.10.57 al cancelar la l¡nea del albar n, volver a poner cantidad a recibir y cantidad a facturar
                OrderLine.MODIFY;
            end;
        end;

        //JAV 04/04/21: - QB 1.08.32 Cancelar movimiento de recurso y de cuenta, crea l¡nea negativa
        if (PurchRcptLine.Type IN [PurchRcptLine.Type::Resource, PurchRcptLine.Type::"G/L Account"]) then
            AddCancelLine(PurchRcptLine, PurchRcptLineCanceled);

        //Cancelar el movimiento contable y el de proyecto asociado a la l¡nea
        PurchaseRcptPendingInvoice.DeactivatePurchaseRcpt(opcPostingDate, PurchRcptLine);

        //{ //JAV 15/12/21: - QB 1.10.07 Se cambia esto de lugar y se ubica dentro de AddCancelLine que es su lugar adecuado
        //      //JAV 22/10/21: - QB 1.09.22 Ajusto la l¡nea de cancelaci¢n, no debe tener provisionado en fras ptes recibir
        //      PurchRcptLineCanceled."QB Qty Provisioned" := 0;
        //      PurchRcptLineCanceled."QB Amount Provisioned" := 0;
        //      PurchRcptLineCanceled.MODIFY;
        //      }

        //Restauro valores guardados
        PurchRcptLine.GET(tmpPurchRcptLine."Document No.", tmpPurchRcptLine."Line No.");
        PurchRcptLine.Quantity := tmpPurchRcptLine.Quantity;
        PurchRcptLine."Qty. Rcd. not Invoiced" := tmpPurchRcptLine."Qty. Rcd. not Invoiced";
        PurchRcptLine."Quantity Invoiced" := tmpPurchRcptLine."Quantity Invoiced";
        PurchRcptLine."Quantity (Base)" := tmpPurchRcptLine."Quantity (Base)";
        PurchRcptLine."Qty. Invoiced (Base)" := tmpPurchRcptLine."Qty. Invoiced (Base)";
        PurchRcptLine.Correction := TRUE;
        PurchRcptLine.Cancelled := TRUE;

        //JAV 15/12/21: - QB 1.10.07 Se a¤aden la cancelaci¢n de las provisiones y quito el almac‚n por si acaso
        //-Q20392
        ImpAnulacion += PurchRcptLine."QB Amount Provisioned";
        //+Q20392
        PurchRcptLine."QB Qty Provisioned" := 0;
        PurchRcptLine."QB Amount Provisioned" := 0;
        PurchRcptLine."Location Code" := '';

        PurchRcptLine.MODIFY;

        if (OutCreated) and (pRegJobShip) then begin
            OutCreated := FALSE;
            PostPurchaseRcptOutput.RUN(OutputShipmentHeader);
        end;

        //Si no quedan l¡neas que tengan cantidades sin anular, marcamos el albar n como cancelado
        PurchRcptLine2.RESET;
        PurchRcptLine2.SETRANGE("Document No.", PurchRcptLine."Document No.");
        PurchRcptLine2.SETFILTER(Quantity, '<>0');
        PurchRcptLine2.SETRANGE(Correction, FALSE);
        if (PurchRcptLine2.ISEMPTY) then begin
            PurchRcptHeader.GET(PurchRcptLine."Document No.");
            PurchRcptHeader.Cancelled := TRUE;
            PurchRcptHeader.MODIFY;
        end;
    end;

    //     LOCAL procedure PostItemJnlLine (PurchRcptLine@1000 : Record 121;var DocLineNo@1005 :
    LOCAL procedure PostItemJnlLine(PurchRcptLine: Record 121; var DocLineNo: Integer): Integer;
    begin
        //Crear y registrar diario de producto
        WITH PurchRcptLine DO begin
            PurchRcptLine2.SETRANGE("Document No.", "Document No.");
            PurchRcptLine2."Document No." := "Document No.";
            PurchRcptLine2."Line No." := "Line No.";
            PurchRcptLine2.FIND('=');

            if PurchRcptLine2.FIND('>') then begin
                LineSpacing := (PurchRcptLine2."Line No." - "Line No.") DIV 2;
                if LineSpacing = 0 then
                    ERROR(Text002);
            end else
                LineSpacing := 10000;
            DocLineNo := "Line No." + LineSpacing;

            if (PurchRcptLine.Type <> PurchRcptLine.Type::Item) then
                exit(0);

            SourceCodeSetup.GET;
            PurchRcptHeader.GET("Document No.");
            ItemJnlLine.INIT;
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Purchase;
            ItemJnlLine."Item No." := "No.";
            ItemJnlLine."Posting Date" := PurchRcptHeader."Posting Date";
            ItemJnlLine."Document No." := "Document No.";
            ItemJnlLine."Document Line No." := PurchRcptLine."Line No.";//DocLineNo;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Purchase Receipt";
            ItemJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ItemJnlLine."Location Code" := "Location Code";
            ItemJnlLine."Source Code" := SourceCodeSetup.Purchases;
            ItemJnlLine."Variant Code" := "Variant Code";
            ItemJnlLine."Bin Code" := "Bin Code";
            ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            ItemJnlLine."Document Date" := PurchRcptHeader."Document Date";
            ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            ItemJnlLine."Dimension Set ID" := "Dimension Set ID";

            if "Job No." = '' then begin
                ItemJnlLine.Correction := TRUE;
                ItemJnlLine."Applies-to Entry" := "Item Rcpt. Entry No.";
            end else begin
                ItemJnlLine."Job No." := "Job No.";
                ItemJnlLine."Job Task No." := "Job Task No.";
                ItemJnlLine."Job Purchase" := TRUE;
                ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
            end;
            ItemJnlLine.Quantity := -Quantity;
            ItemJnlLine."Quantity (Base)" := -"Quantity (Base)";


            WhseUndoQty.InsertTempWhseJnlLine(ItemJnlLine,
              DATABASE::"Purchase Line",
              PurchLine."Document Type"::Order,
              "Order No.",
              "Line No.",
              TempWhseJnlLine."Reference Document"::"Posted Rcpt.",
              TempWhseJnlLine,
              NextLineNo);

            if "Item Rcpt. Entry No." <> 0 then begin
                if "Job No." <> '' then
                    UndoPostingMgt.TransferSourceValues(ItemJnlLine, "Item Rcpt. Entry No.");
                UndoPostingMgt.PostItemJnlLine(ItemJnlLine);
                if "Job No." <> '' then begin
                    if ("Piecework NÂº" <> Job."Warehouse Cost Unit") then begin // JAV 03/04/21 si no est  en el almac‚n se cancel¢ la salida
                        Item.GET("No.");
                        if (Item.Type = Item.Type::Inventory) then begin
                            UndoPostingMgt.FindItemReceiptApplication(ItemApplicationEntry, "Item Rcpt. Entry No.");
                            ItemJnlPostLine.UndoValuePostingWithJob("Item Rcpt. Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
                            UndoPostingMgt.FindItemShipmentApplication(ItemApplicationEntry, ItemJnlLine."Item Shpt. Entry No.");
                            ItemJnlPostLine.UndoValuePostingWithJob(ItemApplicationEntry."Inbound Item Entry No.", ItemJnlLine."Item Shpt. Entry No.");
                            CLEAR(UndoPostingMgt);
                            UndoPostingMgt.ReapplyJobConsumption("Item Rcpt. Entry No.");
                        end;
                    end;
                end;

                exit(ItemJnlLine."Item Shpt. Entry No.");
            end;

            UndoPostingMgt.CollectItemLedgEntries(
              TempApplyToEntryList, DATABASE::"Purch. Rcpt. Line", "Document No.", "Line No.", "Quantity (Base)", "Item Rcpt. Entry No.");

            if "Job No." <> '' then
                if TempApplyToEntryList.FINDSET then
                    repeat
                        UndoPostingMgt.ReapplyJobConsumption(TempApplyToEntryList."Entry No.");
                    until TempApplyToEntryList.NEXT = 0;

            UndoPostingMgt.PostItemJnlLineAppliedToList(ItemJnlLine, TempApplyToEntryList,
              Quantity, "Quantity (Base)", TempGlobalItemLedgEntry, TempGlobalItemEntryRelation);

            exit(0); // "Item Shpt. Entry No."
        end;
    end;

    //     LOCAL procedure CreateOutputShipmentHeader (PurchRcptHeader@1100286000 :
    LOCAL procedure CreateOutputShipmentHeader(PurchRcptHeader: Record 120)
    begin
        //JAV 03/04/21: - Crear un albar n de salida de almac‚n de obra para el albar n que se cancela
        OutputShipmentHeader.VALIDATE("Job No.", PurchRcptHeader."Job No.");
        OutputShipmentHeader."No." := '';
        OutputShipmentHeader.INSERT(TRUE);
        OutputShipmentHeader.VALIDATE("Job No.", PurchRcptHeader."Job No.");
        OutputShipmentHeader.VALIDATE("Posting Date", opcPostingDate);
        OutputShipmentHeader."Posting Description" := STRSUBSTNO(Text005, PurchRcptHeader."No.");
        OutputShipmentHeader."Automatic Shipment" := TRUE;
        OutputShipmentHeader."Dimension Set ID" := PurchRcptHeader."Dimension Set ID";
        OutputShipmentHeader."Automatic Shipment" := TRUE;   //JAV 03/04/21: - QB 1.08.32 Marcamos que se ha generado desde un albar n de compra
        OutputShipmentHeader."Purchase Rcpt. No." := PurchRcptHeader."No.";
        //-AML 24/03/22 QB_ST01 Para poder identificar las devoluciones
        OutputShipmentHeader.Cancellation := TRUE;
        //-AML QB_ST01
        OutputShipmentHeader.MODIFY;

        OutLine := 0;
        OutCreated := TRUE;
    end;

    //     LOCAL procedure CreateOutputShipmentLine (PurchRcptLine@1100286000 :
    LOCAL procedure CreateOutputShipmentLine(PurchRcptLine: Record 121)
    begin
        //JAV 03/04/21: - Crear un albar n de salida de almac‚n de obra para el albar n que se cancela

        //JAV 12/09/22: - QB 1.11.02 No procesar las l¡neas de productos sin stock
        if (PurchRcptLine.Type = PurchRcptLine.Type::Item) then begin
            Item.GET(PurchRcptLine."No.");
            if (Item.Type <> Item.Type::Inventory) then
                exit;
        end;
        //JAV fin

        if (not OutCreated) then
            CreateOutputShipmentHeader("Purch. Rcpt. Header");

        if PurchRcptLine."Piecework NÂº" = Job."Warehouse Cost Unit" then begin
            OutLine += 10000;

            OutputShipmentLines.INIT;
            OutputShipmentLines.VALIDATE("Document No.", OutputShipmentHeader."No.");
            OutputShipmentLines."Line No." := PurchRcptLine."Line No."; //AML Lo igualamos con el contador del albaran //JAV 30/07/21: - QB 1.09.17 Pon¡a 10000 fijo, debe ser el contador
            OutputShipmentLines.VALIDATE("Job No.", PurchRcptLine."Job No.");
            //AML 24/03/22 QB_ST01 Para identificar la devolucion en la tabla
            OutputShipmentLines.Cancellation := TRUE;
            OutputShipmentLines."Cancel Qty" := PurchRcptLine.Quantity;
            OutputShipmentLines."Cancel Cost" := PurchRcptLine."Unit Cost (LCY)";
            //AML QB_ST01
            OutputShipmentLines.VALIDATE("No.", PurchRcptLine."No.");
            OutputShipmentLines.VALIDATE("Unit of Measure Code", PurchRcptLine."Unit of Measure Code");
            OutputShipmentLines."Unit of Mensure Quantity" := PurchRcptLine."Qty. per Unit of Measure";
            OutputShipmentLines.VALIDATE(Quantity, PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced");
            OutputShipmentLines.VALIDATE("Outbound Warehouse", Job."Job Location");
            OutputShipmentLines.VALIDATE("Produccion Unit", PurchRcptLine."Piecework NÂº");
            OutputShipmentLines.VALIDATE("Unit Cost", PurchRcptLine."Unit Cost (LCY)");
            OutputShipmentLines."Job Task No." := PurchRcptLine."Job Task No.";
            //28/03/23 CPA Q19234. + No informaba las dimensiones en las l¡neas del alb. de salida
            OutputShipmentLines."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
            OutputShipmentLines."Shortcut Dimension 1 Code" := PurchRcptLine1."Shortcut Dimension 1 Code";
            OutputShipmentLines."Shortcut Dimension 2 Code" := PurchRcptLine1."Shortcut Dimension 2 Code";
            //28/03/23 CPA Q19234. - No informaba las dimensiones en las l¡neas del alb. de salida

            //CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras.begin
            OutputShipmentLines.Cancellation := TRUE;
            //OutputShipmentLines."Purchase Rcpt. No." := PurchRcptLine."Document No.";
            //OutputShipmentLines."Purchase Rcpt. Line No." := PurchRcptLine."Line No.";
            OutputShipmentLines."Item Rcpt. Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
            //CPA 03/12/2021 - Q15921. Errores detectados en almacenes de obras.end

            OutputShipmentLines.INSERT;
        end;
    end;

    //     LOCAL procedure AddCancelLine (PurchRcptLine@1100286001 : Record 121;var PurchRcptLineCanceled@1100286000 :
    LOCAL procedure AddCancelLine(PurchRcptLine: Record 121; var PurchRcptLineCanceled: Record 121)
    begin
        PurchRcptLine2.RESET;
        PurchRcptLine2.SETRANGE("Document No.", PurchRcptLine."Document No.");
        PurchRcptLine2.SETFILTER("Line No.", '>%1', PurchRcptLine."Line No.");
        if (PurchRcptLine2.FINDFIRST) then begin
            LineSpacing := (PurchRcptLine2."Line No." - PurchRcptLine."Line No.") DIV 2;
            if LineSpacing = 0 then
                ERROR(Text006);
        end else
            LineSpacing := 10000;

        //JAV 22/10/21: - QB 1.09.22 Creo y devuelvo la l¡nea de cancelaci¢n
        PurchRcptLineCanceled.INIT;
        PurchRcptLineCanceled.COPY(PurchRcptLine);
        PurchRcptLineCanceled."Line No." := PurchRcptLine."Line No." + LineSpacing;
        PurchRcptLineCanceled."Appl.-to Item Entry" := 0;
        PurchRcptLineCanceled."Item Rcpt. Entry No." := 0;
        PurchRcptLineCanceled.Quantity := -PurchRcptLine.Quantity;
        PurchRcptLineCanceled."Quantity (Base)" := -PurchRcptLine."Quantity (Base)";
        PurchRcptLineCanceled."Quantity Invoiced" := 0;
        PurchRcptLineCanceled."Qty. Invoiced (Base)" := 0;
        PurchRcptLineCanceled."Qty. Rcd. not Invoiced" := 0;
        PurchRcptLineCanceled.Correction := TRUE;
        PurchRcptLineCanceled."Dimension Set ID" := PurchRcptLine."Dimension Set ID";

        //JAV 22/10/21: - QB 1.09.22 Ajusto la l¡nea de cancelaci¢n, no debe tener provisionado en fras ptes recibir
        //JAV 15/12/21: - QB 1.10.07 se cambian de lugar estas l¡neas y se a¤ade el almac‚n por si acaso
        PurchRcptLineCanceled."QB Qty Provisioned" := 0;
        PurchRcptLineCanceled."QB Amount Provisioned" := 0;
        PurchRcptLine."Location Code" := '';

        PurchRcptLineCanceled.INSERT;
    end;

    //     LOCAL procedure ControlContratos (PurchRcptHeader@1100286001 :
    LOCAL procedure ControlContratos(PurchRcptHeader: Record 120)
    var
        //       ControlContratos@1100286000 :
        ControlContratos: Record 7206912;
        //       ControlContratos2@1100286002 :
        ControlContratos2: Record 7206912;
        //       PurchRcptLine@1100286003 :
        PurchRcptLine: Record 121;
    begin
        //Q20392
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, PurchRcptHeader."Job No.");
        ControlContratos.SETRANGE(Contrato, PurchRcptHeader."Order No.");
        ControlContratos.SETRANGE("Tipo Documento", ControlContratos."Tipo Documento"::Albaran);
        ControlContratos.SETRANGE("No. Documento", PurchRcptHeader."No.");
        if ControlContratos.FINDFIRST then begin
            ControlContratos2 := ControlContratos;
            ControlContratos2.VALIDATE(Linea, 0);
            ControlContratos2."Tipo Documento" := ControlContratos2."Tipo Documento"::"Anulación albarán";
            ControlContratos2."Importe Albaran" := -ImpAnulacion;
            ControlContratos2.INSERT;
        end;
    end;

    // begin
    //{
    //      JAV 15/12/21: - QB 1.10.07 Se cambia de lugar l¡neas y se a¤aden la cancelaci¢n de las provisiones y quito el almac‚n por si acaso
    //      JAV 17/12/21: - QB 1.10.09 Guardamos el registro de cabecera del pedido y cambiamos datos para que luego no afecten
    //
    //      CPA 03/12/21: - Qb 1.10.23 (Q15921) Errores detectados en almacenes de obras. Modificaciones:
    //                                           - CancelLine
    //                                           - CreateOutputShipmentLine
    //      CPA 28/01/22: - QB 1.10.23 (Q16247) - Deshacer l¡neas de recepci¢n de compras de productos da error. Modificaciones:
    //                                           - CancelLine
    //      AML 23/03/22: - QB 1.10.34 (QB_ST01) Modificaci¢n de cancelaci¢n en funcion CancelLine
    //      JAV 28/04/22: - QB 1.10.38 Cambio para que anule con la fecha correctamente en las l¡neas. Se a¤aden datos de usuario y fechas
    //      JAV 30/06/22: - QB 1.10.57 (17544) Al cancelar la l¡nea del albar n, volver a poner cantidad a recibir y cantidad a facturar
    //      JAV 06/07/22: - QB 1.10.59 Saltarse l¡neas sin c¢digo de producto/recurso/cuenta
    //      JAV 08/07/22: - QB 1.11.00 Solo cambiar de fecha l¡neas canceladas. Estaba poniendo la fecha nueva en lugar de la original
    //      JAV 12/09/22: - QB 1.11.02 No procesar las l¡neas de productos sin stock
    //      PSM 24/10/22: - Filtro las l¡neas de albar n con "No." distinto de '', para quitar las l¡neas de descripci¢n
    //      CPA 28/03/23: - Q19234. No informaba las dimensiones en las l¡neas del alb. de salida
    //                    - CreateOutputShipmentLine
    //      PSM 01/09/23: - Q20061 Agregar begin faltante en funci¢n
    //      AML 02/11/23: - Q20392 Anulaci¢n de al¤baran en contratos
    //    }
    // end.


}




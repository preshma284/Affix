Codeunit 50004 "Sales-Post 1"
{


    TableNo = 36;
    Permissions = TableData 37 = imd,
                TableData 38 = m,
                TableData 39 = m,
                TableData 49 = imd,
                TableData 110 = imd,
                TableData 111 = imd,
                TableData 112 = imd,
                TableData 113 = imd,
                TableData 114 = imd,
                TableData 115 = imd,
                TableData 120 = imd,
                TableData 121 = imd,
                TableData 223 = imd,
                TableData 252 = imd,
                TableData 914 = i,
                TableData 6507 = ri,
                TableData 6508 = rid,
                TableData 6660 = imd,
                TableData 6661 = imd;
    trigger OnRun()
    VAR
        SalesHeader: Record 36;
        TempInvoicePostBuffer: Record 55 TEMPORARY;
        TempItemLedgEntryNotInvoiced: Record 32 TEMPORARY;
        CustLedgEntry: Record 21;
        TempServiceItem2: Record 5940 TEMPORARY;
        TempServiceItemComp2: Record 5941 TEMPORARY;
        TempVATAmountLine: Record 290 TEMPORARY;
        TempVATAmountLineRemainder: Record 290 TEMPORARY;
        TempDropShptPostBuffer: Record 223 TEMPORARY;
        CarteraSetup: Record 7000016;
        UpdateAnalysisView: Codeunit 410;
        UpdateItemAnalysisView: Codeunit 7150;
        HasATOShippedNotInvoiced: Boolean;
        EverythingInvoiced: Boolean;
        SavedPreviewMode: Boolean;
        SavedSuppressCommit: Boolean;
        BiggestLineNo: Integer;
        ICGenJnlLineNo: Integer;
        LineCount: Integer;
    BEGIN
        OnBeforePostSalesDoc(Rec, SuppressCommit, PreviewMode);

        ValidatePostingAndDocumentDate(Rec);

        QBCodeunitSubscriber.EmptyJobEntry_CU80(ModificManagement);

        SavedPreviewMode := PreviewMode;
        SavedSuppressCommit := SuppressCommit;
        ClearAllVariables;
        SuppressCommit := SavedSuppressCommit;
        PreviewMode := SavedPreviewMode;

        GetGLSetup;
        GetCurrency(rec."Currency Code");

        SalesSetup.GET;
        SalesHeader := Rec;
        FillTempLines(SalesHeader, TempSalesLineGlobal);
        TempServiceItem2.DELETEALL;
        TempServiceItemComp2.DELETEALL;

        // Check that the invoice amount is zero or greater
        IF SalesHeader.Invoice THEN
            IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] THEN BEGIN
                TempSalesLineGlobal.CalcVATAmountLines(1, SalesHeader, TempSalesLineGlobal, TempVATAmountLine);
                IF TempVATAmountLine.GetTotalLineAmount(FALSE, '') < 0 THEN
                    ERROR(TotalInvoiceAmountNegativeErr);
            END;

        // Header
        CheckAndUpdate(SalesHeader);

        TempDeferralHeader.DELETEALL;
        TempDeferralLine.DELETEALL;
        TempInvoicePostBuffer.DELETEALL;
        TempDropShptPostBuffer.DELETEALL;
        EverythingInvoiced := TRUE;

        // Lines
        OnBeforePostLines(TempSalesLineGlobal, SalesHeader, SuppressCommit, PreviewMode);

        LineCount := 0;
        RoundingLineInserted := FALSE;
        AdjustFinalInvWith100PctPrepmt(TempSalesLineGlobal);

        TempVATAmountLineRemainder.DELETEALL;
        TempSalesLineGlobal.CalcVATAmountLines(1, SalesHeader, TempSalesLineGlobal, TempVATAmountLine);

        SalesLinesProcessed := FALSE;
        IF TempSalesLineGlobal.FINDSET THEN
            REPEAT
                ItemJnlRollRndg := FALSE;
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);

                PostSalesLine(
                  SalesHeader, TempSalesLineGlobal, EverythingInvoiced, TempInvoicePostBuffer, TempVATAmountLine, TempVATAmountLineRemainder,
                  TempItemLedgEntryNotInvoiced, HasATOShippedNotInvoiced, TempDropShptPostBuffer, ICGenJnlLineNo,
                  TempServiceItem2, TempServiceItemComp2);

                IF RoundingLineInserted THEN
                    LastLineRetrieved := TRUE
                ELSE BEGIN
                    BiggestLineNo := MAX(BiggestLineNo, TempSalesLineGlobal."Line No.");
                    LastLineRetrieved := TempSalesLineGlobal.NEXT = 0;
                    IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                        InvoiceRounding(SalesHeader, TempSalesLineGlobal, FALSE, BiggestLineNo);
                END;
            UNTIL LastLineRetrieved;

        OnAfterPostSalesLines(
          SalesHeader, SalesShptHeader, SalesInvHeader, SalesCrMemoHeader, ReturnRcptHeader, WhseShip, WhseReceive, SalesLinesProcessed,
          SuppressCommit);

        IF NOT SalesHeader.IsCreditDocType THEN BEGIN
            ReverseAmount(TotalSalesLine);
            ReverseAmount(TotalSalesLineLCY);
            TotalSalesLineLCY."Unit Cost (LCY)" := -TotalSalesLineLCY."Unit Cost (LCY)";
        END;

        PostDropOrderShipment(SalesHeader, TempDropShptPostBuffer);
        IF SalesHeader.Invoice THEN
            PostGLAndCustomer(SalesHeader, TempInvoicePostBuffer, CustLedgEntry);

        IF ICGenJnlLineNo > 0 THEN
            PostICGenJnl;

        MakeInventoryAdjustment;

        // Create Bills
        IF PaymentMethod.GET(SalesHeader."Payment Method Code") THEN
            IF (PaymentMethod."Create Bills" OR PaymentMethod."Invoices to Cartera") AND
               (NOT CarteraSetup.READPERMISSION) AND SalesHeader.Invoice
            THEN
                ERROR(CannotCreateCarteraDocErr);

        IF SalesHeader.Invoice AND (SalesHeader."Bal. Account No." = '') AND
           (NOT SalesHeader.IsCreditDocType) AND CarteraSetup.READPERMISSION
        THEN BEGIN
            OnBeforeCreateCarteraBills(SalesHeader, CustLedgEntry, TotalSalesLine);
            SplitPayment.SplitSalesInv(
              SalesHeader, CustLedgEntry, Window, SrcCode, GenJnlLineExtDocNo, GenJnlLineDocNo,
              -(TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount));
        END;

        CLEAR(GenJnlPostLine);

        UpdateLastPostingNos(SalesHeader);

        OnRunOnBeforeFinalizePosting(
          SalesHeader, SalesShptHeader, SalesInvHeader, SalesCrMemoHeader, ReturnRcptHeader, GenJnlPostLine, SuppressCommit);

        FinalizePosting(SalesHeader, EverythingInvoiced, TempDropShptPostBuffer);

        Rec := SalesHeader;
        SynchBOMSerialNo(TempServiceItem2, TempServiceItemComp2);
        IF NOT (InvtPickPutaway OR SuppressCommit) THEN BEGIN
            COMMIT;
            UpdateAnalysisView.UpdateAll(0, TRUE);
            UpdateItemAnalysisView.UpdateAll(0, TRUE);
        END;

        OnAfterPostSalesDoc(
          Rec, GenJnlPostLine, SalesShptHeader."No.", ReturnRcptHeader."No.", SalesInvHeader."No.", SalesCrMemoHeader."No.", SuppressCommit);
        OnAfterPostSalesDocDropShipment(PurchRcptHeader."No.", SuppressCommit);
    END;

    VAR
        NothingToPostErr: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        PostingLinesMsg: TextConst ENU = 'Posting lines              #2######\', ESP = 'Registrando l¡neas         #2######\';
        PostingSalesAndVATMsg: TextConst ENU = 'Posting sales and VAT      #3######\', ESP = 'Registrando venta e IVA    #3######\';
        PostingCustomersMsg: TextConst ENU = 'Posting to customers       #4######\', ESP = 'Registrando cliente        #4######\';
        PostingLines2Msg: TextConst ENU = 'Posting lines              #2######', ESP = 'Registrando l¡neas         #2######';
        InvoiceNoMsg: TextConst ENU = '%1 %2 -> Invoice %3', ESP = '%1 %2 -> Factura %3';
        CreditMemoNoMsg: TextConst ENU = '%1 %2 -> Credit Memo %3', ESP = '%1 %2 -> Abono %3';
        DropShipmentErr: TextConst ENU = 'You cannot ship sales order line %1. The line is marked as a drop shipment and is not yet associated with a purchase order.', ESP = 'No se puede enviar la l¡nea %1 del pedido de venta. La l¡nea est  marcada como env¡o directo y todav¡a no est  asociada a un pedido de compra.';
        ShipmentSameSignErr: TextConst ENU = 'must have the same sign as the shipment', ESP = 'debe tener el mismo signo que el env¡o.';
        ShipmentLinesDeletedErr: TextConst ENU = 'The shipment lines have been deleted.', ESP = 'Se han borrado las l¡neas del albar n de venta.';
        InvoiceMoreThanShippedErr: TextConst ENU = 'You cannot invoice more than you have shipped for order %1.', ESP = 'No se puede facturar m s de lo enviado en el pedido %1.';
        VATAmountTxt: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
        VATRateTxt: TextConst ENU = '%1% VAT', ESP = '%1% IVA';
        BlanketOrderQuantityGreaterThanErr: TextConst ENU = 'in the associated blanket order must not be greater than %1', ESP = 'en el pedido abierto asociado no debe ser superior a %1';
        BlanketOrderQuantityReducedErr: TextConst ENU = 'in the associated blanket order must not be reduced', ESP = 'en el pedido abierto asociado no se debe reducir';
        ShipInvoiceReceiveErr: TextConst ENU = 'Please enter "Yes" in Ship and/or Invoice and/or Receive.', ESP = 'Especifique "S¡" en Env¡o y/o Factura y/o Recepci¢n.';
        WarehouseRequiredErr: TextConst ENU = '"Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6."', ESP = '"Manipulaci¢n almac‚n requerido para %1 = %2, %3 = %4, %5 = %6."';
        ReturnReceiptSameSignErr: TextConst ENU = 'must have the same sign as the return receipt', ESP = 'debe tener el mismo nombre que la recep. dev.';
        ReturnReceiptInvoicedErr: TextConst ENU = 'Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.', ESP = 'L¡n. %1 de la recep. dev %2, que esta intentando facturar, ya se ha facturado.';
        ShipmentInvoiceErr: TextConst ENU = 'Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.', ESP = 'L¡nea %1 del env¡o %2, que est  intentando facturar, ha sido ya facturado.';
        QuantityToInvoiceGreaterErr: TextConst ENU = 'The quantity you are attempting to invoice is greater than the quantity in shipment %1.', ESP = 'La cant. que est  intentando facturar es mayor que la cant. en albar n de venta %1.';
        CannotAssignMoreErr: TextConst ENU = '"You cannot assign more than %1 units in %2 = %3, %4 = %5,%6 = %7."', ESP = '"No puede asignar m s de %1 unidades en %2 = %3, %4 = %5,%6 = %7."';
        MustAssignErr: TextConst ENU = 'You must assign all item charges, if you invoice everything.', ESP = 'Si factura todo, debe asignar todos los cargos prod.';
        Item: Record 27;
        SalesSetup: Record 311;
        GLSetup: Record 98;
        GLEntry: Record 17;
        TempSalesLineGlobal: Record 37 TEMPORARY;
        xSalesLine: Record 37;
        SalesLineACY: Record 37;
        TotalSalesLine: Record 37;
        TotalSalesLineLCY: Record 37;
        SalesShptHeader: Record 110;
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        ReturnRcptHeader: Record 6660;
        PurchRcptHeader: Record 120;
        ItemChargeAssgntSales: Record 5809;
        TempItemChargeAssgntSales: Record 5809 TEMPORARY;
        SourceCodeSetup: Record 242;
        Currency: Record 4;
        WhseRcptHeader: Record 7316;
        TempWhseRcptHeader: Record 7316 TEMPORARY;
        WhseShptHeader: Record 7320;
        TempWhseShptHeader: Record 7320 TEMPORARY;
        PostedWhseRcptHeader: Record 7318;
        PostedWhseRcptLine: Record 7319;
        PostedWhseShptHeader: Record 7322;
        PostedWhseShptLine: Record 7323;
        Location: Record 14;
        TempHandlingSpecification: Record 336 TEMPORARY;
        TempATOTrackingSpecification: Record 336 TEMPORARY;
        TempTrackingSpecification: Record 336 TEMPORARY;
        TempTrackingSpecificationInv: Record 336 TEMPORARY;
        TempWhseSplitSpecification: Record 336 TEMPORARY;
        TempValueEntryRelation: Record 6508 TEMPORARY;
        JobTaskSalesLine: Record 37;
        TempICGenJnlLine: Record 81 TEMPORARY;
        TempPrepmtDeductLCYSalesLine: Record 37 TEMPORARY;
        PaymentTerms: Record 3;
        TempSKU: Record 5700 TEMPORARY;
        DeferralPostBuffer: Record 1706;
        TempDeferralHeader: Record 1701 TEMPORARY;
        TempDeferralLine: Record 1702 TEMPORARY;
        GenJnlPostLine: Codeunit 12;
        ResJnlPostLine: Codeunit 212;
        ItemJnlPostLine: Codeunit 22;
        ReserveSalesLine: Codeunit 99000832;
        IdentityManagement: Codeunit 9801;
        IdentityManagement1: Codeunit 51289;
        ApprovalsMgmt: Codeunit 50015;
        ItemTrackingMgt: Codeunit 6500;
        ItemTrackingMgt1: Codeunit 51151;
        WhseJnlPostLine: Codeunit 7301;
        WhsePostRcpt: Codeunit 5760;
        WhsePostShpt: Codeunit 5763;
        PurchPost: Codeunit 90;
        CostCalcMgt: Codeunit 5836;
        JobPostLine: Codeunit 50009;
        ServItemMgt: Codeunit 5920;
        AsmPost: Codeunit 900;
        DeferralUtilities: Codeunit 1720;
        DeferralUtilities1: Codeunit 50721;
        Window: Dialog;
        UseDate: Date;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        GenJnlLineDocType: Integer;
        ItemLedgShptEntryNo: Integer;
        FALineNo: Integer;
        RoundingLineNo: Integer;
        DeferralLineNo: Integer;
        InvDefLineNo: Integer;
        RemQtyToBeInvoiced: Decimal;
        RemQtyToBeInvoicedBase: Decimal;
        RemAmt: Decimal;
        RemDiscAmt: Decimal;
        TotalChargeAmt: Decimal;
        TotalChargeAmtLCY: Decimal;
        LastLineRetrieved: Boolean;
        RoundingLineInserted: Boolean;
        DropShipOrder: Boolean;
        CannotAssignInvoicedErr: TextConst ENU = '"You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced."', ESP = '"No puede asignar cargos de prod. al %1 %2 = %3,%4 = %5, %6 = %7,porque ya se ha facturado."';
        InvoiceMoreThanReceivedErr: TextConst ENU = 'You cannot invoice more than you have received for return order %1.', ESP = 'No puede facturar m s de lo que ha recibido para la devoluci¢n %1.';
        ReturnReceiptLinesDeletedErr: TextConst ENU = 'The return receipt lines have been deleted.', ESP = 'Las l¡ns. de recep. devol. han sido borradas.';
        InvoiceGreaterThanReturnReceiptErr: TextConst ENU = 'The quantity you are attempting to invoice is greater than the quantity in return receipt %1.', ESP = 'La cant. que est  intentando facturar es mayor que la cantidad en la recep. devol. %1.';
        ItemJnlRollRndg: Boolean;
        RelatedItemLedgEntriesNotFoundErr: TextConst ENU = 'Related item ledger entries cannot be found.', ESP = 'No se encuentran los movs. pdto. relacionados.';
        ItemTrackingWrongSignErr: TextConst ENU = 'Item Tracking is signed wrongly.', ESP = 'Seguim. pdto. no est  bien definido.';
        ItemTrackingMismatchErr: TextConst ENU = 'Item Tracking does not match.', ESP = 'Seguimiento prod. no coincide.';
        WhseShip: Boolean;
        WhseReceive: Boolean;
        InvtPickPutaway: Boolean;
        PostingDateNotAllowedErr: TextConst ENU = 'is not within your range of allowed posting dates', ESP = 'no est  dentro del periodo de fechas de registro permitidas';
        ItemTrackQuantityMismatchErr: TextConst ENU = 'The %1 does not match the quantity defined in item tracking.', ESP = '%1 no coincide con la cantidad definida en el seguimiento de productos.';
        CannotBeGreaterThanErr: TextConst ENU = 'cannot be more than %1.', ESP = 'no puede ser superior a %1.';
        CannotBeSmallerThanErr: TextConst ENU = 'must be at least %1.', ESP = 'debe ser al menos %1.';
        JobContractLine: Boolean;
        GLSetupRead: Boolean;
        ItemTrkgAlreadyOverruled: Boolean;
        PrepAmountToDeductToBigErr: TextConst ENU = 'The total %1 cannot be more than %2.', ESP = 'El total %1 no puede ser m s de %2.';
        PrepAmountToDeductToSmallErr: TextConst ENU = 'The total %1 must be at least %2.', ESP = 'El total %1 debe ser al menos %2.';
        MustAssignItemChargeErr: TextConst ENU = 'You must assign item charge %1 if you want to invoice it.', ESP = 'Debe asignar un cargo prod. de %1 si quiere facturarlo.';
        CannotInvoiceItemChargeErr: TextConst ENU = 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.', ESP = 'No puede facturar un cargo prod. de %1 porque no existe mov. producto al que asignarlo.';
        SalesLinesProcessed: Boolean;
        AssemblyCheckProgressMsg: TextConst ENU = '#1#################################\\Checking Assembly #2###########', ESP = '#1#################################\\Comprobando ensamblado #2###########';
        AssemblyPostProgressMsg: TextConst ENU = '#1#################################\\Posting Assembly #2###########', ESP = '#1#################################\\Registrando ensamblado #2###########';
        AssemblyFinalizeProgressMsg: TextConst ENU = '#1#################################\\Finalizing Assembly #2###########', ESP = '#1#################################\\Finalizando ensamblado #2###########';
        ReassignItemChargeErr: TextConst ENU = 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.', ESP = 'La l¡nea del pedido a la que se asign¢ originalmente el cargo de producto se ha registrado completamente. Debe reasignar el cargo de producto a la recepci¢n o al env¡o registrado.';
        ReservationDisruptedQst: TextConst ENU = '"One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?"', ESP = '"Existen uno o m s movimientos de reserva para el producto con %1 = %2, %3 = %4, %5 = %6 que pueden alterarse si registra este ajuste negativo. ¨Desea continuar?"';
        NotSupportedDocumentTypeErr: TextConst ENU = 'Document type %1 is not supported.', ESP = 'El tipo de documento %1 no es compatible.';
        PreviewMode: Boolean;
        TotalInvoiceAmountNegativeErr: TextConst ENU = 'The total amount for the invoice must be 0 or greater.', ESP = 'El importe total de la factura debe ser 0 o superior a 0.';
        NoDeferralScheduleErr: TextConst ENU = 'You must create a deferral schedule because you have specified the deferral code %2 in line %1.', ESP = 'Debe crear una previsi¢n de fraccionamiento porque ha especificado el c¢digo de fraccionamiento %2 en la l¡nea %1.';
        ZeroDeferralAmtErr: TextConst ENU = 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', ESP = 'Los importes de fraccionamiento no pueden ser 0. L¡nea: %1, Plantilla de fraccionamiento: %2.';
        PaymentMethod: Record 289;
        SplitPayment: Codeunit 7000005;
        Text1100000: TextConst ENU = 'The Credit Memo doesn''t have a Corrected Invoice No. Do you want to continue?', ESP = 'El abono no tiene un n§ de factura corregido. ¨Confirma que desea continuar?';
        Text1100011: TextConst ENU = 'The posting process has been cancelled by the user.', ESP = 'El proceso de registro ha sido cancelado por el usuario.';
        CannotCreateCarteraDocErr: TextConst ENU = 'You do not have permissions to create Documents in Cartera.\Please, change the Payment Method.', ESP = 'No tiene permisos para crear Documentos en Cartera.\Cambie la forma de pago.';
        Text1100102: TextConst ENU = 'Posting to bal. account    #5######\', ESP = 'Registrando contrapartida  #5######\';
        Text1100103: TextConst ENU = 'Creating documents         #6######', ESP = 'Creando documentos         #6######';
        Text1100104: TextConst ENU = 'Corrective Invoice', ESP = 'Factura rectificativa';
        DownloadShipmentAlsoQst: TextConst ENU = 'You can also download the Sales - Shipment document now. Alternatively, you can access it from the Posted Sales Shipments window later.\\Do you want to download the Sales - Shipment document now?', ESP = 'Tambi‚n puede descargar el documento Venta - Alb. venta. Como alternativa, puede obtener acceso a dicho documento m s tarde desde la ventana Hist¢rico albaranes de venta.\\¨Quiere descargar el documento Venta - Alb. venta?';
        SuppressCommit: Boolean;
        PostingPreviewNoTok: TextConst ENU = '***', ESP = '***';
        InvPickExistsErr: TextConst ENU = 'One or more related inventory picks must be registered before you can post the shipment.', ESP = 'Debe registrarse uno o varios picking de inventario relacionados antes de registrar el env¡o.';
        InvPutAwayExistsErr: TextConst ENU = 'One or more related inventory put-aways must be registered before you can post the receipt.', ESP = 'Debe registrarse una o varias ubicaciones de inventario relacionadas antes de registrar la recepci¢n.';
        "----------------------------------- QB": Integer;
        DimensionIsBlockedErr: TextConst ENU = 'The combination of dimensions used in %1 %2 is blocked (Error: %3).', ESP = 'La combinaci¢n de dimensiones usada en %1 %2 est  bloqueada (error: %3).';
        LineDimensionBlockedErr: TextConst ENU = 'The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).', ESP = 'La combinaci¢n de dimensiones usada en %1 %2, n§ l¡nea %3 est  bloqueada (error:) %4.';
        InvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2 are invalid (Error: %3).', ESP = 'Las dimensiones usadas en %1 %2 no son v lidas (error: %3).';
        LineInvalidDimensionsErr: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).', ESP = 'Las dim. usadas en %1 %2, n§ l¡n. %3 no son v lidas (error: %4).';
        QBCodeunitSubscriber: Codeunit 7207353;
        ModificManagement: Codeunit 7207273;
        leave: Boolean;

    //[External]
    PROCEDURE CopyToTempLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    VAR
        SalesLine: Record 37;
    BEGIN
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                TempSalesLine := SalesLine;
                TempSalesLine.INSERT;
            UNTIL SalesLine.NEXT = 0;
    END;

    //[External]
    PROCEDURE FillTempLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
        TempSalesLine.RESET;
        IF TempSalesLine.ISEMPTY THEN
            CopyToTempLines(SalesHeader, TempSalesLine);
    END;

    LOCAL PROCEDURE ModifyTempLine(VAR TempSalesLineLocal: Record 37 TEMPORARY);
    VAR
        SalesLine: Record 37;
    BEGIN
        TempSalesLineLocal.MODIFY;
        SalesLine := TempSalesLineLocal;
        SalesLine.MODIFY;
    END;

    //[External]
    PROCEDURE RefreshTempLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
        TempSalesLine.RESET;
        TempSalesLine.SETRANGE("Prepayment Line", FALSE);
        TempSalesLine.DELETEALL;
        TempSalesLine.RESET;
        CopyToTempLines(SalesHeader, TempSalesLine);
    END;

    LOCAL PROCEDURE ResetTempLines(VAR TempSalesLineLocal: Record 37 TEMPORARY);
    BEGIN
        TempSalesLineLocal.RESET;
        TempSalesLineLocal.COPY(TempSalesLineGlobal, TRUE);
        OnAfterResetTempLines(TempSalesLineLocal);
    END;

    LOCAL PROCEDURE CalcInvoice(SalesHeader: Record 36) NewInvoice: Boolean;
    VAR
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        WITH SalesHeader DO BEGIN
            ResetTempLines(TempSalesLine);
            TempSalesLine.SETFILTER(Quantity, '<>0');
            IF "Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"] THEN
                TempSalesLine.SETFILTER("Qty. to Invoice", '<>0');
            NewInvoice := NOT TempSalesLine.ISEMPTY;
            IF NewInvoice THEN
                CASE "Document Type" OF
                    "Document Type"::Order:
                        IF NOT Ship THEN BEGIN
                            TempSalesLine.SETFILTER("Qty. Shipped Not Invoiced", '<>0');
                            NewInvoice := NOT TempSalesLine.ISEMPTY;
                        END;
                    "Document Type"::"Return Order":
                        IF NOT Receive THEN BEGIN
                            TempSalesLine.SETFILTER("Return Qty. Rcd. Not Invd.", '<>0');
                            NewInvoice := NOT TempSalesLine.ISEMPTY;
                        END;
                END;
            EXIT(NewInvoice);
        END;
    END;

    LOCAL PROCEDURE CalcInvDiscount(VAR SalesHeader: Record 36);
    VAR
        SalesHeaderCopy: Record 36;
        SalesLine: Record 37;
    BEGIN
        WITH SalesHeader DO BEGIN
            IF NOT (SalesSetup."Calc. Inv. Discount" AND (Status <> Status::Open)) THEN
                EXIT;

            SalesHeaderCopy := SalesHeader;
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", "Document Type");
            SalesLine.SETRANGE("Document No.", "No.");
            OnCalcInvDiscountSetFilter(SalesLine, SalesHeader);
            SalesLine.FINDFIRST;
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", SalesLine);
            RefreshTempLines(SalesHeader, TempSalesLineGlobal);
            GET("Document Type", "No.");
            RestoreSalesHeader(SalesHeader, SalesHeaderCopy);
            IF NOT (PreviewMode OR SuppressCommit) THEN
                COMMIT;
        END;
    END;

    LOCAL PROCEDURE RestoreSalesHeader(VAR SalesHeader: Record 36; SalesHeaderCopy: Record 36);
    BEGIN
        WITH SalesHeader DO BEGIN
            Invoice := SalesHeaderCopy.Invoice;
            Receive := SalesHeaderCopy.Receive;
            Ship := SalesHeaderCopy.Ship;
            "Posting No." := SalesHeaderCopy."Posting No.";
            "Shipping No." := SalesHeaderCopy."Shipping No.";
            "Return Receipt No." := SalesHeaderCopy."Return Receipt No.";
        END;
    END;

    LOCAL PROCEDURE CheckAndUpdate(VAR SalesHeader: Record 36);
    VAR
        TransportMethod: Record 259;
        GenJnlCheckLine: Codeunit 11;
        DimMgt: Codeunit 408;
        DimMgt2: codeunit 50361;
        ModifyHeader: Boolean;
        RefreshTempLinesNeeded: Boolean;
    BEGIN
        WITH SalesHeader DO BEGIN
            // Check
            CheckMandatoryHeaderFields(SalesHeader);
            IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
                FIELDERROR("Posting Date", PostingDateNotAllowedErr);

            // IF TransportMethod.GET("Transport Method") AND TransportMethod."Port/Airport" THEN
            //     TESTFIELD("Exit Point");

            PaymentTerms.GET("Payment Terms Code");

            SetPostingFlags(SalesHeader);
            InitProgressWindow(SalesHeader);

            InvtPickPutaway := "Posting from Whse. Ref." <> 0;
            "Posting from Whse. Ref." := 0;

            DimMgt2.CheckSalesDim(SalesHeader, TempSalesLineGlobal);

            CheckPostRestrictions(SalesHeader);

            IF ("Document Type" = "Document Type"::"Credit Memo") OR
               (("Document Type" = "Document Type"::"Return Order") AND Invoice)
            THEN BEGIN
                // IF SalesSetup."Correct. Doc. No. Mandatory" THEN
                //     TESTFIELD("Corrected Invoice No.")
                // ELSE BEGIN
                //     IF "Corrected Invoice No." = '' THEN
                //         IF NOT CONFIRM(Text1100000, FALSE) THEN
                //             ERROR(Text1100011);
                // END;
                IF "Corrected Invoice No." <> '' THEN
                    "Posting Description" := FORMAT(Text1100104) + ' ' + "No."
            END;

            IF (Ship OR Invoice) AND NOT IsCreditDocType THEN BEGIN
                TESTFIELD("Payment Method Code");
                TESTFIELD("Payment Terms Code");
            END;

            IF Invoice THEN
                Invoice := CalcInvoice(SalesHeader);

            IF Invoice THEN
                CopyAndCheckItemCharge(SalesHeader);

            IF Invoice AND NOT IsCreditDocType THEN BEGIN
                TESTFIELD("Due Date");
                PaymentTerms.VerifyMaxNoDaysTillDueDate("Due Date", "Document Date", FIELDCAPTION("Due Date"));
            END;

            IF Ship THEN BEGIN
                InitPostATOs(SalesHeader);
                Ship := CheckTrackingAndWarehouseForShip(SalesHeader);
                IF NOT InvtPickPutaway THEN
                    IF CheckIfInvPickExists(SalesHeader) THEN
                        ERROR(InvPickExistsErr);
            END;

            IF Receive THEN BEGIN
                Receive := CheckTrackingAndWarehouseForReceive(SalesHeader);
                IF NOT InvtPickPutaway THEN
                    IF CheckIfInvPutawayExists THEN
                        ERROR(InvPutAwayExistsErr);
            END;

            IF NOT (Ship OR Invoice OR Receive) THEN
                ERROR(NothingToPostErr);

            IF ("Shipping Advice" = "Shipping Advice"::Complete) AND Ship THEN
                CheckShippingAdvice;

            CheckAssosOrderLines(SalesHeader);

            OnAfterCheckSalesDoc(SalesHeader, SuppressCommit, WhseShip, WhseReceive);

            // Update
            IF Invoice THEN
                CreatePrepaymentLines(SalesHeader, TRUE);

            ModifyHeader := UpdatePostingNos(SalesHeader);

            DropShipOrder := UpdateAssosOrderPostingNos(SalesHeader);

            OnBeforePostCommitSalesDoc(SalesHeader, GenJnlPostLine, PreviewMode, ModifyHeader, SuppressCommit, TempSalesLineGlobal);
            IF NOT PreviewMode AND ModifyHeader THEN BEGIN
                MODIFY;
                IF NOT SuppressCommit THEN
                    COMMIT;
            END;

            RefreshTempLinesNeeded := FALSE;
            OnCheckAndUpdateOnBeforeCalcInvDiscount(
              SalesHeader, TempWhseRcptHeader, TempWhseShptHeader, WhseReceive, WhseShip, RefreshTempLinesNeeded);
            IF RefreshTempLinesNeeded THEN
                RefreshTempLines(SalesHeader, TempSalesLineGlobal);

            CalcInvDiscount(SalesHeader);
            ReleaseSalesDocument(SalesHeader);

            IF Ship OR Receive THEN
                ArchiveUnpostedOrder(SalesHeader);

            CheckICPartnerBlocked(SalesHeader);
            SendICDocument(SalesHeader, ModifyHeader);
            UpdateHandledICInboxTransaction(SalesHeader);

            LockTables(SalesHeader);

            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Sales;

            InsertPostedHeaders(SalesHeader);

            UpdateIncomingDocument("Incoming Document Entry No.", "Posting Date", GenJnlLineDocNo);
        END;

        OnAfterCheckAndUpdate(SalesHeader, SuppressCommit, PreviewMode);
    END;

    LOCAL PROCEDURE PostSalesLine(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; VAR EverythingInvoiced: Boolean; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY; VAR TempItemLedgEntryNotInvoiced: Record 32 TEMPORARY; HasATOShippedNotInvoiced: Boolean; VAR TempDropShptPostBuffer: Record 223 TEMPORARY; VAR ICGenJnlLineNo: Integer; VAR TempServiceItem2: Record 5940 TEMPORARY; VAR TempServiceItemComp2: Record 5941 TEMPORARY);
    VAR
        SalesShptLine: Record 111;
        SalesInvLine: Record 113;
        SalesCrMemoLine: Record 115;
        TempPostedATOLink: Record 914 TEMPORARY;
        InvoicePostBuffer: Record 49;
        CostBaseAmount: Decimal;
        IsHandled: Boolean;
    BEGIN
        WITH SalesLine DO BEGIN
            IF Type = Type::Item THEN
                CostBaseAmount := "Line Amount";
            IF "Qty. per Unit of Measure" = 0 THEN
                "Qty. per Unit of Measure" := 1;

            TestSalesLine(SalesHeader, SalesLine);

            TempPostedATOLink.RESET;
            TempPostedATOLink.DELETEALL;
            IF SalesHeader.Ship THEN
                PostATO(SalesHeader, SalesLine, TempPostedATOLink);

            UpdateSalesLineBeforePost(SalesHeader, SalesLine);

            TestUpdatedSalesLine(SalesLine);
            OnPostSalesLineOnAfterTestUpdatedSalesLine(SalesLine, EverythingInvoiced);

            IF "Qty. to Invoice" + "Quantity Invoiced" <> Quantity THEN
                EverythingInvoiced := FALSE;

            IF Quantity <> 0 THEN
                DivideAmount(SalesHeader, SalesLine, 1, "Qty. to Invoice", TempVATAmountLine, TempVATAmountLineRemainder);

            CheckItemReservDisruption(SalesLine);
            RoundAmount(SalesHeader, SalesLine, "Qty. to Invoice");

            IF NOT IsCreditDocType THEN BEGIN
                ReverseAmount(SalesLine);
                ReverseAmount(SalesLineACY);
            END;

            RemQtyToBeInvoiced := "Qty. to Invoice";
            RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";

            PostItemTrackingLine(SalesHeader, SalesLine, TempItemLedgEntryNotInvoiced, HasATOShippedNotInvoiced);

            CASE Type OF
                Type::"G/L Account":
                    PostGLAccICLine(SalesHeader, SalesLine, ICGenJnlLineNo);
                Type::Item:
                    PostItemLine(SalesHeader, SalesLine, TempDropShptPostBuffer, TempPostedATOLink);
                Type::Resource:
                    PostResJnlLine(SalesHeader, SalesLine, JobTaskSalesLine);
                Type::"Charge (Item)":
                    PostItemChargeLine(SalesHeader, SalesLine);
            END;

            IF (Type.AsInteger() >= Type::"G/L Account".AsInteger()) AND ("Qty. to Invoice" <> 0) THEN BEGIN
                AdjustPrepmtAmountLCY(SalesHeader, SalesLine);
                FillInvoicePostingBuffer(SalesHeader, SalesLine, SalesLineACY, TempInvoicePostBuffer, InvoicePostBuffer);
                InsertPrepmtAdjInvPostingBuf(SalesHeader, SalesLine, TempInvoicePostBuffer, InvoicePostBuffer);
            END;

            IsHandled := FALSE;
            OnPostSalesLineOnBeforeTestJobNo(SalesLine, IsHandled);
            IF NOT IsHandled THEN
                IF NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) THEN
                    TESTFIELD("Job No.", '');

            IsHandled := FALSE;
            OnPostSalesLineOnBeforeInsertShipmentLine(SalesHeader, SalesLine, IsHandled);
            IF NOT IsHandled THEN
                IF (SalesShptHeader."No." <> '') AND ("Shipment No." = '') AND
                   NOT RoundingLineInserted AND NOT "Prepayment Line"
                THEN
                    InsertShipmentLine(SalesHeader, SalesShptHeader, SalesLine, CostBaseAmount, TempServiceItem2, TempServiceItemComp2);

            IsHandled := FALSE;
            OnPostSalesLineOnBeforeInsertReturnReceiptLine(SalesHeader, SalesLine, IsHandled);
            IF (ReturnRcptHeader."No." <> '') AND ("Return Receipt No." = '') AND
               NOT RoundingLineInserted
            THEN
                InsertReturnReceiptLine(ReturnRcptHeader, SalesLine, CostBaseAmount);

            IsHandled := FALSE;
            IF SalesHeader.Invoice THEN
                IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN BEGIN
                    OnPostSalesLineOnBeforeInsertInvoiceLine(SalesHeader, SalesLine, IsHandled);
                    IF NOT IsHandled THEN BEGIN
                        SalesInvLine.InitFromSalesLine(SalesInvHeader, xSalesLine);
                        ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation, SalesInvLine.RowID1);
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            SalesInvLine."Order No." := "Document No.";
                            SalesInvLine."Order Line No." := "Line No.";
                        END ELSE
                            IF SalesShptLine.GET("Shipment No.", "Shipment Line No.") THEN BEGIN
                                SalesInvLine."Order No." := SalesShptLine."Order No.";
                                SalesInvLine."Order Line No." := SalesShptLine."Order Line No.";
                            END;
                        OnBeforeSalesInvLineInsert(SalesInvLine, SalesInvHeader, xSalesLine, SuppressCommit);
                        SalesInvLine.INSERT(TRUE);
                        OnAfterSalesInvLineInsert(
                          SalesInvLine, SalesInvHeader, xSalesLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit, SalesHeader);
                        CreatePostedDeferralScheduleFromSalesDoc(xSalesLine, SalesInvLine.GetDocumentType,
                          SalesInvHeader."No.", SalesInvLine."Line No.", SalesInvHeader."Posting Date");
                    END;
                END ELSE BEGIN
                    OnPostSalesLineOnBeforeInsertCrMemoLine(SalesHeader, SalesLine, IsHandled);
                    IF NOT IsHandled THEN BEGIN
                        SalesCrMemoLine.InitFromSalesLine(SalesCrMemoHeader, xSalesLine);
                        ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation, SalesCrMemoLine.RowID1);
                        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                            SalesCrMemoLine."Order No." := "Document No.";
                            SalesCrMemoLine."Order Line No." := "Line No.";
                        END;
                        OnBeforeSalesCrMemoLineInsert(SalesCrMemoLine, SalesCrMemoHeader, xSalesLine, SuppressCommit);
                        SalesCrMemoLine.INSERT(TRUE);
                        OnAfterSalesCrMemoLineInsert(
                          SalesCrMemoLine, SalesCrMemoHeader, SalesHeader, xSalesLine, TempItemChargeAssgntSales, SuppressCommit);
                        CreatePostedDeferralScheduleFromSalesDoc(xSalesLine, SalesCrMemoLine.GetDocumentType,
                          SalesCrMemoHeader."No.", SalesCrMemoLine."Line No.", SalesCrMemoHeader."Posting Date");
                    END;
                END;
        END;

        OnAfterPostSalesLine(SalesHeader, SalesLine, SuppressCommit);
    END;

    LOCAL PROCEDURE PostGLAndCustomer(VAR SalesHeader: Record 36; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR CustLedgEntry: Record 21);
    BEGIN
        OnBeforePostGLAndCustomer(SalesHeader, TempInvoicePostBuffer, CustLedgEntry, SuppressCommit, PreviewMode);

        WITH SalesHeader DO BEGIN
            // Post sales and VAT to G/L entries from posting buffer
            PostInvoicePostBuffer(SalesHeader, TempInvoicePostBuffer);

            // Post customer entry
            IF GUIALLOWED THEN
                Window.UPDATE(4, 1);
            PostCustomerEntry(
              SalesHeader, TotalSalesLine, TotalSalesLineLCY, GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode);

            UpdateSalesHeader(CustLedgEntry);

            // Balancing account
            IF "Bal. Account No." <> '' THEN BEGIN
                IF GUIALLOWED THEN
                    Window.UPDATE(5, 1);
                PostBalancingEntry(
                  SalesHeader, TotalSalesLine, TotalSalesLineLCY, GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode);
            END;
        END;

        OnAfterPostGLAndCustomer(SalesHeader, GenJnlPostLine, TotalSalesLine, TotalSalesLineLCY, SuppressCommit);
    END;

    LOCAL PROCEDURE PostGLAccICLine(SalesHeader: Record 36; SalesLine: Record 37; VAR ICGenJnlLineNo: Integer);
    VAR
        GLAcc: Record 15;
    BEGIN
        IF (SalesLine."No." <> '') AND NOT SalesLine."System-Created Entry" THEN BEGIN
            GLAcc.GET(SalesLine."No.");
            GLAcc.TESTFIELD("Direct Posting", TRUE);
            IF (SalesLine."IC Partner Code" <> '') AND SalesHeader.Invoice THEN
                InsertICGenJnlLine(SalesHeader, xSalesLine, ICGenJnlLineNo);
        END;
    END;

    LOCAL PROCEDURE PostItemLine(SalesHeader: Record 36; VAR SalesLine: Record 37; VAR TempDropShptPostBuffer: Record 223 TEMPORARY; VAR TempPostedATOLink: Record 914 TEMPORARY);
    VAR
        DummyTrackingSpecification: Record 336;
        SalesLineToShip: Record 37;
        QtyToInvoice: Decimal;
        QtyToInvoiceBase: Decimal;
    BEGIN
        ItemLedgShptEntryNo := 0;
        QtyToInvoice := RemQtyToBeInvoiced;
        QtyToInvoiceBase := RemQtyToBeInvoicedBase;

        WITH SalesHeader DO BEGIN
            IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
                TempDropShptPostBuffer."Order No." := SalesLine."Purchase Order No.";
                TempDropShptPostBuffer."Order Line No." := SalesLine."Purch. Order Line No.";
                TempDropShptPostBuffer.Quantity := -SalesLine."Qty. to Ship";
                TempDropShptPostBuffer."Quantity (Base)" := -SalesLine."Qty. to Ship (Base)";
                TempDropShptPostBuffer."Item Shpt. Entry No." :=
                  PostAssocItemJnlLine(SalesHeader, SalesLine, TempDropShptPostBuffer.Quantity, TempDropShptPostBuffer."Quantity (Base)");
                TempDropShptPostBuffer.INSERT;
                SalesLine."Appl.-to Item Entry" := TempDropShptPostBuffer."Item Shpt. Entry No.";
            END;

            CLEAR(TempPostedATOLink);
            TempPostedATOLink.SETRANGE("Order No.", SalesLine."Document No.");
            TempPostedATOLink.SETRANGE("Order Line No.", SalesLine."Line No.");
            IF TempPostedATOLink.FINDFIRST THEN
                PostATOAssocItemJnlLine(SalesHeader, SalesLine, TempPostedATOLink, QtyToInvoice, QtyToInvoiceBase);

            IF QtyToInvoice <> 0 THEN
                ItemLedgShptEntryNo :=
                  PostItemJnlLine(
                    SalesHeader, SalesLine,
                    QtyToInvoice, QtyToInvoiceBase,
                    QtyToInvoice, QtyToInvoiceBase,
                    0, '', DummyTrackingSpecification, FALSE);

            // Invoice discount amount is also included in expected sales amount posted for shipment or return receipt.
            MakeSalesLineToShip(SalesLineToShip, SalesLine);

            IF SalesLineToShip.IsCreditDocType THEN BEGIN
                IF ABS(SalesLineToShip."Return Qty. to Receive") > ABS(QtyToInvoice) THEN
                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        SalesHeader, SalesLineToShip,
                        SalesLineToShip."Return Qty. to Receive" - QtyToInvoice,
                        SalesLineToShip."Return Qty. to Receive (Base)" - QtyToInvoiceBase,
                        0, 0, 0, '', DummyTrackingSpecification, FALSE);
            END ELSE BEGIN
                IF ABS(SalesLineToShip."Qty. to Ship") > ABS(QtyToInvoice) + ABS(TempPostedATOLink."Assembled Quantity") THEN
                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        SalesHeader, SalesLineToShip,
                        SalesLineToShip."Qty. to Ship" - TempPostedATOLink."Assembled Quantity" - QtyToInvoice,
                        SalesLineToShip."Qty. to Ship (Base)" - TempPostedATOLink."Assembled Quantity (Base)" - QtyToInvoiceBase,
                        0, 0, 0, '', DummyTrackingSpecification, FALSE);
            END;
        END;
    END;

    LOCAL PROCEDURE PostItemChargeLine(SalesHeader: Record 36; SalesLine: Record 37);
    VAR
        SalesLineBackup: Record 37;
    BEGIN
        IF NOT (SalesHeader.Invoice AND (SalesLine."Qty. to Invoice" <> 0)) THEN
            EXIT;

        ItemJnlRollRndg := TRUE;
        SalesLineBackup.COPY(SalesLine);
        IF FindTempItemChargeAssgntSales(SalesLineBackup."Line No.") THEN
            REPEAT
                CASE TempItemChargeAssgntSales."Applies-to Doc. Type" OF
                    TempItemChargeAssgntSales."Applies-to Doc. Type"::Shipment:
                        BEGIN
                            PostItemChargePerShpt(SalesHeader, SalesLineBackup);
                            TempItemChargeAssgntSales.MARK(TRUE);
                        END;
                    TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt":
                        BEGIN
                            PostItemChargePerRetRcpt(SalesHeader, SalesLineBackup);
                            TempItemChargeAssgntSales.MARK(TRUE);
                        END;
                    TempItemChargeAssgntSales."Applies-to Doc. Type"::Order,
                  TempItemChargeAssgntSales."Applies-to Doc. Type"::Invoice,
                  TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Order",
                  TempItemChargeAssgntSales."Applies-to Doc. Type"::"Credit Memo":
                        CheckItemCharge(TempItemChargeAssgntSales);
                END;
            UNTIL TempItemChargeAssgntSales.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemTrackingLine(SalesHeader: Record 36; SalesLine: Record 37; VAR TempItemLedgEntryNotInvoiced: Record 32 TEMPORARY; HasATOShippedNotInvoiced: Boolean);
    VAR
        TempTrackingSpecification: Record 336 TEMPORARY;
        TrackingSpecificationExists: Boolean;
    BEGIN
        IF SalesLine."Prepayment Line" THEN
            EXIT;

        IF SalesHeader.Invoice THEN
            IF SalesLine."Qty. to Invoice" = 0 THEN
                TrackingSpecificationExists := FALSE
            ELSE
                TrackingSpecificationExists :=
                  ReserveSalesLine.RetrieveInvoiceSpecification(SalesLine, TempTrackingSpecification);

        PostItemTracking(
          SalesHeader, SalesLine, TrackingSpecificationExists, TempTrackingSpecification,
          TempItemLedgEntryNotInvoiced, HasATOShippedNotInvoiced);

        IF TrackingSpecificationExists THEN
            SaveInvoiceSpecification(TempTrackingSpecification);
    END;

    LOCAL PROCEDURE PostItemJnlLine(SalesHeader: Record 36; SalesLine: Record 37; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; ItemLedgShptEntryNo: Integer; ItemChargeNo: Code[20]; TrackingSpecification: Record 336; IsATO: Boolean): Integer;
    VAR
        ItemJnlLine: Record 83;
        TempWhseJnlLine: Record 7311 TEMPORARY;
        TempWhseTrackingSpecification: Record 336 TEMPORARY;
        OriginalItemJnlLine: Record 83;
        CurrExchRate: Record 330;
        PostWhseJnlLine: Boolean;
        InvDiscAmountPerShippedQty: Decimal;
    BEGIN
        //QB
        QBCodeunitSubscriber.ExitIfJobExist_CU80(SalesLine, leave);
        IF leave THEN
            EXIT(0);
        //QB

        IF NOT ItemJnlRollRndg THEN BEGIN
            RemAmt := 0;
            RemDiscAmt := 0;
        END;

        OnBeforePostItemJnlLine(
          SalesHeader, SalesLine, QtyToBeShipped, QtyToBeShippedBase, QtyToBeInvoiced, QtyToBeInvoicedBase,
          ItemLedgShptEntryNo, ItemChargeNo, TrackingSpecification, IsATO, SuppressCommit);

        WITH ItemJnlLine DO BEGIN
            INIT;
            CopyFromSalesHeader(SalesHeader);
            CopyFromSalesLine(SalesLine);
            "Country/Region Code" := GetCountryCode(SalesLine, SalesHeader);

            CopyTrackingFromSpec(TrackingSpecification);
            "Item Shpt. Entry No." := ItemLedgShptEntryNo;

            Quantity := -QtyToBeShipped;
            "Quantity (Base)" := -QtyToBeShippedBase;
            "Invoiced Quantity" := -QtyToBeInvoiced;
            "Invoiced Qty. (Base)" := -QtyToBeInvoicedBase;

            IF QtyToBeShipped = 0 THEN
                IF SalesLine.IsCreditDocType THEN
                    CopyDocumentFields(
                      "Document Type"::"Sales Credit Memo", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series")
                ELSE
                    CopyDocumentFields(
                      "Document Type"::"Sales Invoice", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series")
            ELSE BEGIN
                IF SalesLine.IsCreditDocType THEN
                    CopyDocumentFields(
                      "Document Type"::"Sales Return Receipt",
                      ReturnRcptHeader."No.", ReturnRcptHeader."External Document No.", SrcCode, ReturnRcptHeader."No. Series")
                ELSE
                    CopyDocumentFields(
                      "Document Type"::"Sales Shipment", SalesShptHeader."No.", SalesShptHeader."External Document No.", SrcCode,
                      SalesShptHeader."No. Series");
                IF QtyToBeInvoiced <> 0 THEN BEGIN
                    IF "Document No." = '' THEN
                        IF SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" THEN
                            CopyDocumentFields(
                              "Document Type"::"Sales Credit Memo", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series")
                        ELSE
                            CopyDocumentFields(
                              "Document Type"::"Sales Invoice", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series");
                    "Posting No. Series" := SalesHeader."Posting No. Series";
                END;
            END;

            IF QtyToBeInvoiced <> 0 THEN
                "Invoice No." := GenJnlLineDocNo;

            "Assemble to Order" := IsATO;
            IF "Assemble to Order" THEN
                "Applies-to Entry" := SalesLine.FindOpenATOEntry('', '')
            ELSE
                "Applies-to Entry" := SalesLine."Appl.-to Item Entry";

            IF ItemChargeNo <> '' THEN BEGIN
                "Item Charge No." := ItemChargeNo;
                SalesLine."Qty. to Invoice" := QtyToBeInvoiced;
            END ELSE
                "Applies-from Entry" := SalesLine."Appl.-from Item Entry";

            IF QtyToBeInvoiced <> 0 THEN BEGIN
                Amount := -(SalesLine.Amount * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemAmt);
                IF SalesHeader."Prices Including VAT" THEN
                    "Discount Amount" :=
                      -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") /
                        (1 + SalesLine."VAT %" / 100) * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt)
                ELSE
                    "Discount Amount" :=
                      -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") *
                        (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt);
                RemAmt := Amount - ROUND(Amount);
                RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
                Amount := ROUND(Amount);
                "Discount Amount" := ROUND("Discount Amount");
            END ELSE BEGIN
                InvDiscAmountPerShippedQty := ABS(SalesLine."Inv. Discount Amount") * QtyToBeShipped / SalesLine.Quantity;
                Amount := QtyToBeShipped * SalesLine."Unit Price";
                IF SalesHeader."Prices Including VAT" THEN
                    Amount :=
                      -((Amount * (1 - SalesLine."Line Discount %" / 100) - InvDiscAmountPerShippedQty) /
                        (1 + SalesLine."VAT %" / 100) - RemAmt)
                ELSE
                    Amount :=
                      -(Amount * (1 - SalesLine."Line Discount %" / 100) - InvDiscAmountPerShippedQty - RemAmt);
                RemAmt := Amount - ROUND(Amount);
                IF SalesHeader."Currency Code" <> '' THEN
                    Amount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          SalesHeader."Posting Date", SalesHeader."Currency Code",
                          Amount, SalesHeader."Currency Factor"))
                ELSE
                    Amount := ROUND(Amount);
            END;

            IF NOT JobContractLine THEN BEGIN
                PostItemJnlLineBeforePost(ItemJnlLine, SalesLine, TempWhseJnlLine, PostWhseJnlLine, QtyToBeShippedBase);

                OriginalItemJnlLine := ItemJnlLine;
                IF NOT IsItemJnlPostLineHandled(ItemJnlLine, SalesLine, SalesHeader) THEN
                    ItemJnlPostLine.RunWithCheck(ItemJnlLine);

                IF IsATO THEN
                    PostItemJnlLineTracking(
                      SalesLine, TempWhseTrackingSpecification, PostWhseJnlLine, QtyToBeInvoiced, TempATOTrackingSpecification)
                ELSE
                    PostItemJnlLineTracking(SalesLine, TempWhseTrackingSpecification, PostWhseJnlLine, QtyToBeInvoiced, TempHandlingSpecification);

                PostItemJnlLineWhseLine(TempWhseJnlLine, TempWhseTrackingSpecification);

                OnAfterPostItemJnlLineWhseLine(SalesLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit);

                IF (SalesLine.Type = SalesLine.Type::Item) AND SalesHeader.Invoice THEN
                    PostItemJnlLineItemCharges(SalesHeader, SalesLine, OriginalItemJnlLine, "Item Shpt. Entry No.");
            END;
            EXIT("Item Shpt. Entry No.");
        END;
    END;

    LOCAL PROCEDURE PostItemJnlLineItemCharges(SalesHeader: Record 36; SalesLine: Record 37; VAR OriginalItemJnlLine: Record 83; ItemShptEntryNo: Integer);
    VAR
        ItemChargeSalesLine: Record 37;
    BEGIN
        WITH SalesLine DO BEGIN
            ClearItemChargeAssgntFilter;
            TempItemChargeAssgntSales.SETCURRENTKEY(
              "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
            TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type", "Document Type");
            TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.", "Document No.");
            TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.", "Line No.");
            IF TempItemChargeAssgntSales.FINDSET THEN
                REPEAT
                    TESTFIELD("Allow Item Charge Assignment");
                    GetItemChargeLine(SalesHeader, ItemChargeSalesLine);
                    ItemChargeSalesLine.CALCFIELDS("Qty. Assigned");
                    IF (ItemChargeSalesLine."Qty. to Invoice" <> 0) OR
                       (ABS(ItemChargeSalesLine."Qty. Assigned") < ABS(ItemChargeSalesLine."Quantity Invoiced"))
                    THEN BEGIN
                        OriginalItemJnlLine."Item Shpt. Entry No." := ItemShptEntryNo;
                        PostItemChargePerOrder(SalesHeader, SalesLine, OriginalItemJnlLine, ItemChargeSalesLine);
                        TempItemChargeAssgntSales.MARK(TRUE);
                    END;
                UNTIL TempItemChargeAssgntSales.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostItemJnlLineTracking(SalesLine: Record 37; VAR TempWhseTrackingSpecification: Record 336 TEMPORARY; PostWhseJnlLine: Boolean; QtyToBeInvoiced: Decimal; VAR TempTrackingSpec: Record 336 TEMPORARY);
    BEGIN
        IF ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpec) THEN
            IF TempTrackingSpec.FINDSET THEN
                REPEAT
                    TempTrackingSpecification := TempTrackingSpec;
                    TempTrackingSpecification.SetSourceFromSalesLine(SalesLine);
                    IF TempTrackingSpecification.INSERT THEN;
                    IF QtyToBeInvoiced <> 0 THEN BEGIN
                        TempTrackingSpecificationInv := TempTrackingSpecification;
                        IF TempTrackingSpecificationInv.INSERT THEN;
                    END;
                    IF PostWhseJnlLine THEN BEGIN
                        TempWhseTrackingSpecification := TempTrackingSpecification;
                        IF TempWhseTrackingSpecification.INSERT THEN;
                    END;
                UNTIL TempTrackingSpec.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemJnlLineWhseLine(VAR TempWhseJnlLine: Record 7311 TEMPORARY; VAR TempWhseTrackingSpecification: Record 336 TEMPORARY);
    VAR
        TempWhseJnlLine2: Record 7311 TEMPORARY;
    BEGIN
        ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2, TempWhseTrackingSpecification, FALSE);
        IF TempWhseJnlLine2.FINDSET THEN
            REPEAT
                WhseJnlPostLine.RUN(TempWhseJnlLine2);
            UNTIL TempWhseJnlLine2.NEXT = 0;
        TempWhseTrackingSpecification.DELETEALL;
    END;

    LOCAL PROCEDURE PostItemJnlLineBeforePost(VAR ItemJnlLine: Record 83; SalesLine: Record 37; VAR TempWhseJnlLine: Record 7311 TEMPORARY; VAR PostWhseJnlLine: Boolean; QtyToBeShippedBase: Decimal);
    VAR
        CheckApplFromItemEntry: Boolean;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF SalesSetup."Exact Cost Reversing Mandatory" AND (SalesLine.Type = SalesLine.Type::Item) THEN
                IF SalesLine.IsCreditDocType THEN
                    CheckApplFromItemEntry := SalesLine.Quantity > 0
                ELSE
                    CheckApplFromItemEntry := SalesLine.Quantity < 0;

            IF (SalesLine."Location Code" <> '') AND (SalesLine.Type = SalesLine.Type::Item) AND (Quantity <> 0) THEN
                IF ShouldPostWhseJnlLine(SalesLine) THEN BEGIN
                    CreateWhseJnlLine(ItemJnlLine, SalesLine, TempWhseJnlLine);
                    PostWhseJnlLine := TRUE;
                END;

            OnPostItemJnlLineOnBeforeTransferReservToItemJnlLine(SalesLine, ItemJnlLine);

            IF QtyToBeShippedBase <> 0 THEN BEGIN
                IF SalesLine.IsCreditDocType THEN
                    ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, FALSE)
                ELSE
                    TransferReservToItemJnlLine(
                      SalesLine, ItemJnlLine, -QtyToBeShippedBase, TempTrackingSpecification, CheckApplFromItemEntry);

                IF CheckApplFromItemEntry AND SalesLine.IsInventoriableItem THEN
                    SalesLine.TESTFIELD("Appl.-from Item Entry");
            END;
        END;
    END;

    LOCAL PROCEDURE ShouldPostWhseJnlLine(SalesLine: Record 37): Boolean;
    BEGIN
        WITH SalesLine DO BEGIN
            GetLocation("Location Code");
            IF (("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) AND
                Location."Directed Put-away and Pick") OR
               (Location."Bin Mandatory" AND NOT (WhseShip OR WhseReceive OR InvtPickPutaway OR "Drop Shipment"))
            THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE PostItemChargePerOrder(SalesHeader: Record 36; SalesLine: Record 37; ItemJnlLine2: Record 83; ItemChargeSalesLine: Record 37);
    VAR
        NonDistrItemJnlLine: Record 83;
        CurrExchRate: Record 330;
        QtyToInvoice: Decimal;
        Factor: Decimal;
        OriginalAmt: Decimal;
        OriginalDiscountAmt: Decimal;
        OriginalQty: Decimal;
        SignFactor: Integer;
        TotalChargeAmt2: Decimal;
        TotalChargeAmtLCY2: Decimal;
    BEGIN
        OnBeforePostItemChargePerOrder(SalesHeader, SalesLine, ItemJnlLine2, ItemChargeSalesLine, SuppressCommit);

        WITH TempItemChargeAssgntSales DO BEGIN
            SalesLine.TESTFIELD("Job No.", '');
            SalesLine.TESTFIELD("Allow Item Charge Assignment", TRUE);
            ItemJnlLine2."Document No." := GenJnlLineDocNo;
            ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
            ItemJnlLine2."Item Charge No." := "Item Charge No.";
            ItemJnlLine2.Description := ItemChargeSalesLine.Description;
            ItemJnlLine2."Unit of Measure Code" := '';
            ItemJnlLine2."Qty. per Unit of Measure" := 1;
            ItemJnlLine2."Applies-from Entry" := 0;
            IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                QtyToInvoice :=
                  CalcQtyToInvoice(SalesLine."Return Qty. to Receive (Base)", SalesLine."Qty. to Invoice (Base)")
            ELSE
                QtyToInvoice :=
                  CalcQtyToInvoice(SalesLine."Qty. to Ship (Base)", SalesLine."Qty. to Invoice (Base)");
            IF ItemJnlLine2."Invoiced Quantity" = 0 THEN BEGIN
                ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
                ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
            END;
            ItemJnlLine2."Document Line No." := ItemChargeSalesLine."Line No.";

            ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
            IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
            ItemJnlLine2."Unit Cost (ACY)" :=
              ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                Currency."Unit-Amount Rounding Precision");

            TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
            IF SalesHeader."Currency Code" <> '' THEN
                ItemJnlLine2.Amount :=
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    UseDate, SalesHeader."Currency Code", TotalChargeAmt2 + TotalSalesLine.Amount, SalesHeader."Currency Factor") -
                  TotalChargeAmtLCY2 - TotalSalesLineLCY.Amount
            ELSE
                ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

            TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
            ItemJnlLine2."Unit Cost" := ROUND(
                ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)", GLSetup."Unit-Amount Rounding Precision");
            ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";

            IF SalesHeader."Currency Code" <> '' THEN
                ItemJnlLine2."Discount Amount" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      (ItemChargeSalesLine."Line Discount Amount" +
                       ItemChargeSalesLine."Inv. Discount Amount" + ItemChargeSalesLine."Pmt. Discount Amount") *
                      ItemJnlLine2."Invoiced Qty. (Base)" /
                      ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                      SalesHeader."Currency Factor"),
                    GLSetup."Amount Rounding Precision")
            ELSE
                ItemJnlLine2."Discount Amount" := ROUND(
                    (ItemChargeSalesLine."Line Discount Amount" +
                     ItemChargeSalesLine."Inv. Discount Amount" + ItemChargeSalesLine."Pmt. Discount Amount") *
                    ItemJnlLine2."Invoiced Qty. (Base)" /
                    ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                    GLSetup."Amount Rounding Precision");

            ItemJnlLine2."Pmt. Discount Amount" :=
              ItemChargeSalesLine."Pmt. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" / ItemChargeSalesLine."Quantity (Base)" *
              "Qty. to Assign" / QtyToInvoice;
            IF SalesLine.IsCreditDocType THEN BEGIN
                ItemJnlLine2."Discount Amount" := -ItemJnlLine2."Discount Amount";
                ItemJnlLine2."Pmt. Discount Amount" := -ItemJnlLine2."Pmt. Discount Amount";
            END;
            ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargeSalesLine."Shortcut Dimension 1 Code";
            ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargeSalesLine."Shortcut Dimension 2 Code";
            ItemJnlLine2."Dimension Set ID" := ItemChargeSalesLine."Dimension Set ID";
            ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargeSalesLine."Gen. Prod. Posting Group";

            OnPostItemChargePerOrderOnAfterCopyToItemJnlLine(
              ItemJnlLine2, ItemChargeSalesLine, GLSetup, QtyToInvoice, TempItemChargeAssgntSales);
        END;

        WITH TempTrackingSpecificationInv DO BEGIN
            RESET;
            SETRANGE("Source Type", DATABASE::"Sales Line");
            SETRANGE("Source ID", TempItemChargeAssgntSales."Applies-to Doc. No.");
            SETRANGE("Source Ref. No.", TempItemChargeAssgntSales."Applies-to Doc. Line No.");
            IF ISEMPTY THEN
                ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
            ELSE BEGIN
                FINDSET;
                NonDistrItemJnlLine := ItemJnlLine2;
                OriginalAmt := NonDistrItemJnlLine.Amount;
                OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
                OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
                IF ("Quantity (Base)" / OriginalQty) > 0 THEN
                    SignFactor := 1
                ELSE
                    SignFactor := -1;
                REPEAT
                    Factor := "Quantity (Base)" / OriginalQty * SignFactor;
                    IF ABS("Quantity (Base)") < ABS(NonDistrItemJnlLine."Quantity (Base)") THEN BEGIN
                        ItemJnlLine2."Quantity (Base)" := -"Quantity (Base)";
                        ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
                        ItemJnlLine2.Amount :=
                          ROUND(OriginalAmt * Factor, GLSetup."Amount Rounding Precision");
                        ItemJnlLine2."Discount Amount" :=
                          ROUND(OriginalDiscountAmt * Factor, GLSetup."Amount Rounding Precision");
                        ItemJnlLine2."Unit Cost" :=
                          ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                            GLSetup."Unit-Amount Rounding Precision") * SignFactor;
                        ItemJnlLine2."Item Shpt. Entry No." := "Item Ledger Entry No.";
                        ItemJnlLine2."Applies-to Entry" := "Item Ledger Entry No.";
                        ItemJnlLine2.CopyTrackingFromSpec(TempTrackingSpecificationInv);
                        ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
                        ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
                        NonDistrItemJnlLine."Quantity (Base)" -= ItemJnlLine2."Quantity (Base)";
                        NonDistrItemJnlLine.Amount -= ItemJnlLine2.Amount;
                        NonDistrItemJnlLine."Discount Amount" -= ItemJnlLine2."Discount Amount";
                    END ELSE BEGIN // the last time
                        NonDistrItemJnlLine."Quantity (Base)" := -"Quantity (Base)";
                        NonDistrItemJnlLine."Invoiced Qty. (Base)" := -"Quantity (Base)";
                        NonDistrItemJnlLine."Unit Cost" :=
                          ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                            GLSetup."Unit-Amount Rounding Precision");
                        NonDistrItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No.";
                        NonDistrItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
                        NonDistrItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecificationInv);
                        ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
                        NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
                    END;
                UNTIL NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE PostItemChargePerShpt(SalesHeader: Record 36; VAR SalesLine: Record 37);
    VAR
        SalesShptLine: Record 111;
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
        DistributeCharge: Boolean;
    BEGIN
        IF NOT SalesShptLine.GET(
             TempItemChargeAssgntSales."Applies-to Doc. No.", TempItemChargeAssgntSales."Applies-to Doc. Line No.")
        THEN
            ERROR(ShipmentLinesDeletedErr);
        SalesShptLine.TESTFIELD("Job No.", '');

        IF SalesShptLine."Item Shpt. Entry No." <> 0 THEN
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, -SalesShptLine."Quantity (Base)", SalesShptLine."Item Shpt. Entry No.")
        ELSE BEGIN
            DistributeCharge := TRUE;
            IF NOT ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
                 DATABASE::"Sales Shipment Line", 0, SalesShptLine."Document No.",
                 '', 0, SalesShptLine."Line No.", -SalesShptLine."Quantity (Base)")
            THEN
                ERROR(RelatedItemLedgEntriesNotFoundErr);
        END;

        IF DistributeCharge THEN
            PostDistributeItemCharge(
              SalesHeader, SalesLine, TempItemLedgEntry, SalesShptLine."Quantity (Base)",
              TempItemChargeAssgntSales."Qty. to Assign", TempItemChargeAssgntSales."Amount to Assign")
        ELSE
            PostItemCharge(SalesHeader, SalesLine,
              SalesShptLine."Item Shpt. Entry No.", SalesShptLine."Quantity (Base)",
              TempItemChargeAssgntSales."Amount to Assign",
              TempItemChargeAssgntSales."Qty. to Assign");
    END;

    LOCAL PROCEDURE PostItemChargePerRetRcpt(SalesHeader: Record 36; VAR SalesLine: Record 37);
    VAR
        ReturnRcptLine: Record 6661;
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
        DistributeCharge: Boolean;
    BEGIN
        IF NOT ReturnRcptLine.GET(
             TempItemChargeAssgntSales."Applies-to Doc. No.", TempItemChargeAssgntSales."Applies-to Doc. Line No.")
        THEN
            ERROR(ShipmentLinesDeletedErr);
        ReturnRcptLine.TESTFIELD("Job No.", '');

        IF ReturnRcptLine."Item Rcpt. Entry No." <> 0 THEN
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, ReturnRcptLine."Quantity (Base)", ReturnRcptLine."Item Rcpt. Entry No.")
        ELSE BEGIN
            DistributeCharge := TRUE;
            IF NOT ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
                 DATABASE::"Return Receipt Line", 0, ReturnRcptLine."Document No.",
                 '', 0, ReturnRcptLine."Line No.", ReturnRcptLine."Quantity (Base)")
            THEN
                ERROR(RelatedItemLedgEntriesNotFoundErr);
        END;

        IF DistributeCharge THEN
            PostDistributeItemCharge(
              SalesHeader, SalesLine, TempItemLedgEntry, ReturnRcptLine."Quantity (Base)",
              TempItemChargeAssgntSales."Qty. to Assign", TempItemChargeAssgntSales."Amount to Assign")
        ELSE
            PostItemCharge(SalesHeader, SalesLine,
              ReturnRcptLine."Item Rcpt. Entry No.", ReturnRcptLine."Quantity (Base)",
              TempItemChargeAssgntSales."Amount to Assign",
              TempItemChargeAssgntSales."Qty. to Assign")
    END;

    LOCAL PROCEDURE PostDistributeItemCharge(SalesHeader: Record 36; SalesLine: Record 37; VAR TempItemLedgEntry: Record 32 TEMPORARY; NonDistrQuantity: Decimal; NonDistrQtyToAssign: Decimal; NonDistrAmountToAssign: Decimal);
    VAR
        Factor: Decimal;
        QtyToAssign: Decimal;
        AmountToAssign: Decimal;
    BEGIN
        IF TempItemLedgEntry.FINDSET THEN
            REPEAT
                Factor := ABS(TempItemLedgEntry.Quantity / NonDistrQuantity);
                QtyToAssign := NonDistrQtyToAssign * Factor;
                AmountToAssign := ROUND(NonDistrAmountToAssign * Factor, GLSetup."Amount Rounding Precision");
                IF Factor < 1 THEN BEGIN
                    PostItemCharge(SalesHeader, SalesLine,
                      TempItemLedgEntry."Entry No.", -TempItemLedgEntry.Quantity,
                      AmountToAssign, QtyToAssign);
                    NonDistrQuantity := NonDistrQuantity + TempItemLedgEntry.Quantity;
                    NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
                    NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
                END ELSE // the last time
                    PostItemCharge(SalesHeader, SalesLine,
                      TempItemLedgEntry."Entry No.", -TempItemLedgEntry.Quantity,
                      NonDistrAmountToAssign, NonDistrQtyToAssign);
            UNTIL TempItemLedgEntry.NEXT = 0
        ELSE
            ERROR(RelatedItemLedgEntriesNotFoundErr);
    END;

    LOCAL PROCEDURE PostAssocItemJnlLine(SalesHeader: Record 36; SalesLine: Record 37; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal): Integer;
    VAR
        ItemJnlLine: Record 83;
        TempHandlingSpecification2: Record 336 TEMPORARY;
        ItemEntryRelation: Record 6507;
        PurchOrderHeader: Record 38;
        PurchOrderLine: Record 39;
    BEGIN
        PurchOrderHeader.GET(
          PurchOrderHeader."Document Type"::Order, SalesLine."Purchase Order No.");
        PurchOrderLine.GET(
          PurchOrderLine."Document Type"::Order, SalesLine."Purchase Order No.", SalesLine."Purch. Order Line No.");

        InitAssocItemJnlLine(ItemJnlLine, PurchOrderHeader, PurchOrderLine, SalesHeader, QtyToBeShipped, QtyToBeShippedBase);

        IF PurchOrderLine."Job No." = '' THEN BEGIN
            TransferReservFromPurchLine(PurchOrderLine, ItemJnlLine, SalesLine, QtyToBeShippedBase);
            OnBeforePostAssocItemJnlLine(ItemJnlLine, PurchOrderLine, SuppressCommit);
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            // Handle Item Tracking
            IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
                IF TempHandlingSpecification2.FINDSET THEN
                    REPEAT
                        TempTrackingSpecification := TempHandlingSpecification2;
                        TempTrackingSpecification.SetSourceFromPurchLine(PurchOrderLine);
                        IF TempTrackingSpecification.INSERT THEN;
                        ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification2);
                        ItemEntryRelation.SetSource(DATABASE::"Purch. Rcpt. Line", 0, PurchOrderHeader."Receiving No.", PurchOrderLine."Line No.");
                        ItemEntryRelation.SetOrderInfo(PurchOrderLine."Document No.", PurchOrderLine."Line No.");
                        ItemEntryRelation.INSERT;
                    UNTIL TempHandlingSpecification2.NEXT = 0;
                EXIT(0);
            END;
        END;

        EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE InitAssocItemJnlLine(VAR ItemJnlLine: Record 83; PurchOrderHeader: Record 38; PurchOrderLine: Record 39; SalesHeader: Record 36; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal);
    BEGIN
        WITH ItemJnlLine DO BEGIN
            INIT;
            "Entry Type" := "Entry Type"::Purchase;
            CopyDocumentFields(
              "Document Type"::"Purchase Receipt", PurchOrderHeader."Receiving No.", PurchOrderHeader."No.", SrcCode,
              PurchOrderHeader."Posting No. Series");

            CopyFromPurchHeader(PurchOrderHeader);
            "Posting Date" := SalesHeader."Posting Date";
            "Document Date" := SalesHeader."Document Date";
            CopyFromPurchLine(PurchOrderLine);

            Quantity := QtyToBeShipped;
            "Quantity (Base)" := QtyToBeShippedBase;
            "Invoiced Quantity" := 0;
            "Invoiced Qty. (Base)" := 0;
            "Source Currency Code" := SalesHeader."Currency Code";
            Amount := ROUND(PurchOrderLine.Amount * QtyToBeShipped / PurchOrderLine.Quantity);
            "Discount Amount" := PurchOrderLine."Line Discount Amount";

            "Applies-to Entry" := 0;
        END;

        OnAfterInitAssocItemJnlLine(ItemJnlLine, PurchOrderHeader, PurchOrderLine, SalesHeader);
    END;

    LOCAL PROCEDURE ReleaseSalesDocument(VAR SalesHeader: Record 36);
    VAR
        SalesHeaderCopy: Record 36;
        TempAsmHeader: Record 900 TEMPORARY;
        ReleaseSalesDocument: Codeunit 414;
        LinesWereModified: Boolean;
        SavedStatus: Enum "Sales Document Status";
    BEGIN
        WITH SalesHeader DO BEGIN
            IF NOT (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN
                EXIT;

            SalesHeaderCopy := SalesHeader;
            SavedStatus := Status;//enum to option
            GetOpenLinkedATOs(TempAsmHeader);
            OnBeforeReleaseSalesDoc(SalesHeader);
            LinesWereModified := ReleaseSalesDocument.ReleaseSalesHeader(SalesHeader, PreviewMode);
            IF LinesWereModified THEN
                RefreshTempLines(SalesHeader, TempSalesLineGlobal);
            TESTFIELD(Status, Status::Released);
            Status := SavedStatus; //option to enum
            RestoreSalesHeader(SalesHeader, SalesHeaderCopy);
            ReopenAsmOrders(TempAsmHeader);
            OnAfterReleaseSalesDoc(SalesHeader);
            IF NOT (PreviewMode OR SuppressCommit) THEN BEGIN
                MODIFY;
                COMMIT;
            END;
            Status := Status::Released;
        END;
    END;

    LOCAL PROCEDURE TestSalesLine(SalesHeader: Record 36; SalesLine: Record 37);
    VAR
        FA: Record 5600;
        DeprBook: Record 5611;
        DummyTrackingSpecification: Record 336;
    BEGIN
        OnBeforeTestSalesLine(SalesHeader, SalesLine, SuppressCommit);

        WITH SalesHeader DO BEGIN
            IF SalesLine.Type = SalesLine.Type::Item THEN
                DummyTrackingSpecification.CheckItemTrackingQuantity(
                  DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.",//enum to option
                  SalesLine."Qty. to Ship (Base)", SalesLine."Qty. to Invoice (Base)", Ship, Invoice);

            CASE "Document Type" OF
                "Document Type"::Order:
                    SalesLine.TESTFIELD("Return Qty. to Receive", 0);
                "Document Type"::Invoice:
                    BEGIN
                        IF SalesLine."Shipment No." = '' THEN
                            SalesLine.TESTFIELD("Qty. to Ship", SalesLine.Quantity);
                        SalesLine.TESTFIELD("Return Qty. to Receive", 0);
                        SalesLine.TESTFIELD("Qty. to Invoice", SalesLine.Quantity);

                        QBCodeunitSubscriber.UpdateInvoicedCertAndMilestone_CU80(SalesLine, SalesInvHeader."No.", SalesInvHeader."Posting Date");
                    END;
                "Document Type"::"Return Order":
                    SalesLine.TESTFIELD("Qty. to Ship", 0);
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF SalesLine."Return Receipt No." = '' THEN
                            SalesLine.TESTFIELD("Return Qty. to Receive", SalesLine.Quantity);
                        SalesLine.TESTFIELD("Qty. to Ship", 0);
                        SalesLine.TESTFIELD("Qty. to Invoice", SalesLine.Quantity);

                        QBCodeunitSubscriber.UpdateInvoicedCert_CU80(SalesLine, SalesCrMemoHeader."No.", SalesCrMemoHeader."Posting Date");
                    END;
            END;
            IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN BEGIN
                SalesLine.TESTFIELD(Amount);
                SalesLine.TESTFIELD("Job No.", '');
                SalesLine.TESTFIELD("Job Contract Entry No.", 0);
            END;
            IF SalesLine.Type = SalesLine.Type::"Fixed Asset" THEN BEGIN
                SalesLine.TESTFIELD("Job No.", '');
                SalesLine.TESTFIELD("Depreciation Book Code");
                DeprBook.GET(SalesLine."Depreciation Book Code");
                DeprBook.TESTFIELD("G/L Integration - Disposal", TRUE);
                FA.GET(SalesLine."No.");
                FA.TESTFIELD("Budgeted Asset", FALSE);
            END ELSE BEGIN
                SalesLine.TESTFIELD("Depreciation Book Code", '');
                SalesLine.TESTFIELD("Depr. until FA Posting Date", FALSE);
                SalesLine.TESTFIELD("FA Posting Date", 0D);
                SalesLine.TESTFIELD("Duplicate in Depreciation Book", '');
                SalesLine.TESTFIELD("Use Duplication List", FALSE);
            END;
            IF NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) THEN
                SalesLine.TESTFIELD("Job No.", '');

            OnAfterTestSalesLine(SalesHeader, SalesLine, WhseShip, WhseReceive, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE TestUpdatedSalesLine(SalesLine: Record 37);
    BEGIN
        WITH SalesLine DO BEGIN
            IF "Drop Shipment" THEN BEGIN
                IF Type <> Type::Item THEN
                    TESTFIELD("Drop Shipment", FALSE);
                IF ("Qty. to Ship" <> 0) AND ("Purch. Order Line No." = 0) THEN
                    ERROR(DropShipmentErr, "Line No.");
            END;

            IF Quantity = 0 THEN
                TESTFIELD(Amount, 0)
            ELSE BEGIN
                TESTFIELD("No.");
                TESTFIELD(Type);
                TESTFIELD("Gen. Bus. Posting Group");
                TESTFIELD("Gen. Prod. Posting Group");
            END;
        END;
    END;

    LOCAL PROCEDURE UpdatePostingNos(VAR SalesHeader: Record 36) ModifyHeader: Boolean;
    VAR
        NoSeriesMgt: Codeunit 396;
    BEGIN
        WITH SalesHeader DO BEGIN
            IF Ship AND ("Shipping No." = '') THEN
                IF ("Document Type" = "Document Type"::Order) OR
                   (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
                THEN
                    IF NOT PreviewMode THEN BEGIN
                        TESTFIELD("Shipping No. Series");
                        "Shipping No." := NoSeriesMgt.GetNextNo("Shipping No. Series", "Posting Date", TRUE);
                        ModifyHeader := TRUE;
                    END ELSE
                        "Shipping No." := PostingPreviewNoTok;

            IF Receive AND ("Return Receipt No." = '') THEN
                IF ("Document Type" = "Document Type"::"Return Order") OR
                   (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
                THEN
                    IF NOT PreviewMode THEN BEGIN
                        TESTFIELD("Return Receipt No. Series");
                        "Return Receipt No." := NoSeriesMgt.GetNextNo("Return Receipt No. Series", "Posting Date", TRUE);
                        ModifyHeader := TRUE;
                    END ELSE
                        "Return Receipt No." := PostingPreviewNoTok;

            IF Invoice AND ("Posting No." = '') THEN BEGIN
                IF ("No. Series" <> '') OR
                   ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"])
                THEN
                    TESTFIELD("Posting No. Series");
                IF ("No. Series" <> "Posting No. Series") OR
                   ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"])
                THEN BEGIN
                    IF NOT PreviewMode THEN BEGIN
                        "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", TRUE);
                        ModifyHeader := TRUE;
                    END ELSE
                        "Posting No." := PostingPreviewNoTok;
                END;
            END;
        END;

        OnAfterUpdatePostingNos(SalesHeader, NoSeriesMgt, SuppressCommit);
    END;

    LOCAL PROCEDURE UpdateAssocOrder(VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        PurchOrderHeader: Record 38;
        PurchOrderLine: Record 39;
        ReservePurchLine: Codeunit 99000834;
    BEGIN
        TempDropShptPostBuffer.RESET;
        IF TempDropShptPostBuffer.ISEMPTY THEN
            EXIT;
        CLEAR(PurchOrderHeader);
        TempDropShptPostBuffer.FINDSET;
        REPEAT
            IF PurchOrderHeader."No." <> TempDropShptPostBuffer."Order No." THEN BEGIN
                PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order, TempDropShptPostBuffer."Order No.");
                PurchOrderHeader."Last Receiving No." := PurchOrderHeader."Receiving No.";
                PurchOrderHeader."Receiving No." := '';
                PurchOrderHeader.MODIFY;
                ReservePurchLine.UpdateItemTrackingAfterPosting(PurchOrderHeader);
            END;
            PurchOrderLine.GET(
              PurchOrderLine."Document Type"::Order,
              TempDropShptPostBuffer."Order No.", TempDropShptPostBuffer."Order Line No.");
            PurchOrderLine."Quantity Received" := PurchOrderLine."Quantity Received" + TempDropShptPostBuffer.Quantity;
            PurchOrderLine."Qty. Received (Base)" := PurchOrderLine."Qty. Received (Base)" + TempDropShptPostBuffer."Quantity (Base)";
            PurchOrderLine.InitOutstanding;
            PurchOrderLine.ClearQtyIfBlank;
            PurchOrderLine.InitQtyToReceive;
            PurchOrderLine.MODIFY;
        UNTIL TempDropShptPostBuffer.NEXT = 0;
        TempDropShptPostBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateAssocLines(VAR SalesOrderLine: Record 37);
    VAR
        PurchOrderLine: Record 39;
    BEGIN
        PurchOrderLine.GET(
          PurchOrderLine."Document Type"::Order,
          SalesOrderLine."Purchase Order No.", SalesOrderLine."Purch. Order Line No.");
        PurchOrderLine."Sales Order No." := '';
        PurchOrderLine."Sales Order Line No." := 0;
        PurchOrderLine.MODIFY;
        SalesOrderLine."Purchase Order No." := '';
        SalesOrderLine."Purch. Order Line No." := 0;
    END;

    LOCAL PROCEDURE UpdateAssosOrderPostingNos(SalesHeader: Record 36) DropShipment: Boolean;
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        PurchOrderHeader: Record 38;
        NoSeriesMgt: Codeunit 396;
        ReleasePurchaseDocument: Codeunit 415;
    BEGIN
        WITH SalesHeader DO BEGIN
            ResetTempLines(TempSalesLine);
            TempSalesLine.SETFILTER("Purch. Order Line No.", '<>0');
            DropShipment := NOT TempSalesLine.ISEMPTY;

            TempSalesLine.SETFILTER("Qty. to Ship", '<>0');
            IF DropShipment AND Ship THEN
                IF TempSalesLine.FINDSET THEN
                    REPEAT
                        IF PurchOrderHeader."No." <> TempSalesLine."Purchase Order No." THEN BEGIN
                            PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order, TempSalesLine."Purchase Order No.");
                            PurchOrderHeader.TESTFIELD("Pay-to Vendor No.");
                            PurchOrderHeader.Receive := TRUE;
                            ReleasePurchaseDocument.ReleasePurchaseHeader(PurchOrderHeader, PreviewMode);
                            IF PurchOrderHeader."Receiving No." = '' THEN BEGIN
                                PurchOrderHeader.TESTFIELD("Receiving No. Series");
                                PurchOrderHeader."Receiving No." :=
                                  NoSeriesMgt.GetNextNo(PurchOrderHeader."Receiving No. Series", "Posting Date", TRUE);
                                PurchOrderHeader.MODIFY;
                            END;
                        END;
                    UNTIL TempSalesLine.NEXT = 0;

            EXIT(DropShipment);
        END;
    END;

    LOCAL PROCEDURE UpdateAfterPosting(SalesHeader: Record 36);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            SETFILTER("Qty. to Assemble to Order", '<>0');
            IF FINDSET THEN
                REPEAT
                    FinalizePostATO(TempSalesLine);
                UNTIL NEXT = 0;

            ResetTempLines(TempSalesLine);
            SETFILTER("Blanket Order Line No.", '<>0');
            IF FINDSET THEN
                REPEAT
                    UpdateBlanketOrderLine(TempSalesLine, SalesHeader.Ship, SalesHeader.Receive, SalesHeader.Invoice);
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateLastPostingNos(VAR SalesHeader: Record 36);
    BEGIN
        WITH SalesHeader DO BEGIN
            IF Ship THEN BEGIN
                "Last Shipping No." := "Shipping No.";
                "Shipping No." := '';
            END;
            IF Invoice THEN BEGIN
                "Last Posting No." := "Posting No.";
                "Posting No." := '';
            END;
            IF Receive THEN BEGIN
                "Last Return Receipt No." := "Return Receipt No.";
                "Return Receipt No." := '';
            END;
        END;
    END;

    LOCAL PROCEDURE UpdateSalesLineBeforePost(SalesHeader: Record 36; VAR SalesLine: Record 37);
    var
        SalesPost: codeunit 50004;
    BEGIN
        WITH SalesLine DO BEGIN
            IF NOT (SalesHeader.Ship OR RoundingLineInserted) THEN BEGIN
                "Qty. to Ship" := 0;
                "Qty. to Ship (Base)" := 0;
            END;
            IF NOT (SalesHeader.Receive OR RoundingLineInserted) THEN BEGIN
                "Return Qty. to Receive" := 0;
                "Return Qty. to Receive (Base)" := 0;
            END;

            JobContractLine := FALSE;
            IF (Type = Type::Item) OR (Type = Type::"G/L Account") OR (Type = Type::" ") THEN
                IF "Job Contract Entry No." > 0 THEN
                    PostJobContractLine(SalesHeader, SalesLine);

            //QB
            IF (Type = Type::Item) OR (Type = Type::"G/L Account") OR (Type = Type::" ") THEN
                IF "Job Contract Entry No." = 0 THEN
                    QBCodeunitSubscriber.PostJobManual_CU80(SalesLine, SalesHeader, SalesInvHeader."No.", SalesCrMemoHeader."No.", ModificManagement);
            //QB

            IF Type = Type::Resource THEN
                JobTaskSalesLine := SalesLine;

            IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) AND ("Shipment No." <> '') THEN BEGIN
                "Quantity Shipped" := Quantity;
                "Qty. Shipped (Base)" := "Quantity (Base)";
                "Qty. to Ship" := 0;
                "Qty. to Ship (Base)" := 0;
            END;

            IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND ("Return Receipt No." <> '') THEN BEGIN
                "Return Qty. Received" := Quantity;
                "Return Qty. Received (Base)" := "Quantity (Base)";
                "Return Qty. to Receive" := 0;
                "Return Qty. to Receive (Base)" := 0;
            END;

            IF SalesHeader.Invoice THEN BEGIN
                IF ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice) THEN
                    InitQtyToInvoice;
            END ELSE BEGIN
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            END;

            IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                SalesPost.GetItem(SalesLine);
                IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN
                    GetUnitCost;
            END;
        END;
    END;

    LOCAL PROCEDURE UpdateWhseDocuments();
    BEGIN
        IF WhseReceive THEN BEGIN
            WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
            TempWhseRcptHeader.DELETE;
        END;
        IF WhseShip THEN BEGIN
            WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
            TempWhseShptHeader.DELETE;
        END;
    END;

    LOCAL PROCEDURE DeleteAfterPosting(VAR SalesHeader: Record 36);
    VAR
        SalesCommentLine: Record 44;
        SalesLine: Record 37;
        TempSalesLine: Record 37 TEMPORARY;
        WarehouseRequest: Record 5765;
        CustInvoiceDisc: Record 19;
        SkipDelete: Boolean;
    BEGIN
        OnBeforeDeleteAfterPosting(SalesHeader, SalesInvHeader, SalesCrMemoHeader, SkipDelete, SuppressCommit);
        IF SkipDelete THEN
            EXIT;

        WITH SalesHeader DO BEGIN
            IF HASLINKS THEN
                DELETELINKS;
            DELETE;
            ReserveSalesLine.DeleteInvoiceSpecFromHeader(SalesHeader);
            DeleteATOLinks(SalesHeader);
            ResetTempLines(TempSalesLine);
            IF TempSalesLine.FINDFIRST THEN
                REPEAT
                    IF TempSalesLine."Deferral Code" <> '' THEN
                        DeferralUtilities.RemoveOrSetDeferralSchedule(
                          '', DeferralUtilities1.GetSalesDeferralDocType, '', '', TempSalesLine."Document Type".AsInteger(),
                          TempSalesLine."Document No.", TempSalesLine."Line No.", 0, 0D, TempSalesLine.Description, '', TRUE);
                    IF TempSalesLine.HASLINKS THEN
                        TempSalesLine.DELETELINKS;
                UNTIL TempSalesLine.NEXT = 0;

            SalesLine.SETRANGE("Document Type", "Document Type");
            SalesLine.SETRANGE("Document No.", "No.");
            OnBeforeSalesLineDeleteAll(SalesLine, SuppressCommit);
            SalesLine.DELETEALL;
            IF IdentityManagement1.IsInvAppId AND CustInvoiceDisc.GET("Invoice Disc. Code") THEN
                CustInvoiceDisc.DELETE; // Cleanup of autogenerated cust. invoice discounts

            DeleteItemChargeAssgnt(SalesHeader);
            SalesCommentLine.DeleteComments("Document Type".AsInteger(), "No.");//enum to option
            WarehouseRequest.DeleteRequest(DATABASE::"Sales Line", "Document Type".AsInteger(), "No.");
        END;

        OnAfterDeleteAfterPosting(SalesHeader, SalesInvHeader, SalesCrMemoHeader, SuppressCommit);
    END;

    LOCAL PROCEDURE FinalizePosting(VAR SalesHeader: Record 36; EverythingInvoiced: Boolean; VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        GenJnlPostPreview: Codeunit 19;
        ICInboxOutboxMgt: Codeunit 427;
        WhseSalesRelease: Codeunit 5771;
        ArchiveManagement: Codeunit 5063;
    BEGIN
        OnBeforeFinalizePosting(SalesHeader, TempSalesLineGlobal, EverythingInvoiced, SuppressCommit);

        WITH SalesHeader DO BEGIN
            IF ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"]) AND
               (NOT EverythingInvoiced)
            THEN BEGIN
                MODIFY;
                InsertTrackingSpecification(SalesHeader);
                QBCodeunitSubscriber.GenerateConsumptionOfJob_CU80(SalesHeader, Ship, Receive, ModificManagement);
                PostUpdateOrderLine(SalesHeader);
                UpdateAssocOrder(TempDropShptPostBuffer);
                UpdateWhseDocuments;
                WhseSalesRelease.Release(SalesHeader);
                UpdateItemChargeAssgnt;
            END ELSE BEGIN
                CASE "Document Type" OF
                    "Document Type"::Invoice:
                        BEGIN
                            PostUpdateInvoiceLine;
                            InsertTrackingSpecification(SalesHeader);
                        END;
                    "Document Type"::"Credit Memo":
                        BEGIN
                            PostUpdateReturnReceiptLine;
                            InsertTrackingSpecification(SalesHeader);
                        END;
                    ELSE BEGIN
                        UpdateAssocOrder(TempDropShptPostBuffer);
                        IF DropShipOrder THEN
                            InsertTrackingSpecification(SalesHeader);

                        ResetTempLines(TempSalesLine);
                        TempSalesLine.SETFILTER("Purch. Order Line No.", '<>0');
                        IF TempSalesLine.FINDSET THEN
                            REPEAT
                                UpdateAssocLines(TempSalesLine);
                                TempSalesLine.MODIFY;
                            UNTIL TempSalesLine.NEXT = 0;

                        ResetTempLines(TempSalesLine);
                        TempSalesLine.SETFILTER("Prepayment %", '<>0');
                        IF TempSalesLine.FINDSET THEN
                            REPEAT
                                DecrementPrepmtAmtInvLCY(
                                  TempSalesLine, TempSalesLine."Prepmt. Amount Inv. (LCY)", TempSalesLine."Prepmt. VAT Amount Inv. (LCY)");
                                TempSalesLine.MODIFY;
                            UNTIL TempSalesLine.NEXT = 0;
                    END;
                END;
                UpdateAfterPosting(SalesHeader);
                UpdateEmailParameters(SalesHeader);
                UpdateWhseDocuments;
                ArchiveManagement.AutoArchiveSalesDocument(SalesHeader);
                ApprovalsMgmt.DeleteApprovalEntries(RECORDID);
                // +QB
                QBCodeunitSubscriber.GenerateConsumptionOfJob_CU80(SalesHeader, Ship, Receive, ModificManagement);
                // -QB

                IF NOT PreviewMode THEN
                    DeleteAfterPosting(SalesHeader);
            END;

            InsertValueEntryRelation;

            OnAfterFinalizePostingOnBeforeCommit(
              SalesHeader, SalesShptHeader, SalesInvHeader, SalesCrMemoHeader, ReturnRcptHeader, GenJnlPostLine, SuppressCommit, PreviewMode);

            IF PreviewMode THEN BEGIN
                Window.CLOSE;
                GenJnlPostPreview.ThrowError;
            END;
            IF NOT (InvtPickPutaway OR SuppressCommit) THEN
                COMMIT;

            Window.CLOSE;
            IF Invoice AND ("Bill-to IC Partner Code" <> '') THEN
                IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN
                    ICInboxOutboxMgt.CreateOutboxSalesInvTrans(SalesInvHeader)
                ELSE
                    ICInboxOutboxMgt.CreateOutboxSalesCrMemoTrans(SalesCrMemoHeader);

            OnAfterFinalizePosting(
              SalesHeader, SalesShptHeader, SalesInvHeader, SalesCrMemoHeader, ReturnRcptHeader,
              GenJnlPostLine, SuppressCommit, PreviewMode);

            ClearPostBuffers;
        END;
    END;

    LOCAL PROCEDURE FillInvoicePostingBuffer(SalesHeader: Record 36; SalesLine: Record 37; SalesLineACY: Record 37; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR InvoicePostBuffer: Record 49);
    VAR
        GenPostingSetup: Record 252;
        TotalVAT: Decimal;
        TotalVATACY: Decimal;
        TotalAmount: Decimal;
        TotalAmountACY: Decimal;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        TotalVATBase: Decimal;
        TotalVATBaseACY: Decimal;
        DeferralAccount: Code[20];
        SalesAccount: Code[20];
    BEGIN
        GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");

        InvoicePostBuffer.PrepareSales(SalesLine);

        TotalVAT := SalesLine."Amount Including VAT" - SalesLine.Amount;
        TotalVATACY := SalesLineACY."Amount Including VAT" - SalesLineACY.Amount;
        TotalAmount := SalesLine.Amount;
        TotalAmountACY := SalesLineACY.Amount;
        TotalVATBase := SalesLine."VAT Base Amount";
        TotalVATBaseACY := SalesLineACY."VAT Base Amount";

        OnAfterInvoicePostingBufferAssignAmounts(SalesLine, TotalAmount, TotalAmountACY);

        IF SalesLine."Deferral Code" <> '' THEN
            GetAmountsForDeferral(SalesLine, AmtToDefer, AmtToDeferACY, DeferralAccount)
        ELSE BEGIN
            AmtToDefer := 0;
            AmtToDeferACY := 0;
            DeferralAccount := '';
        END;

        // IF SalesSetup."Post Invoice Discount" THEN BEGIN
        //     CalcInvoiceDiscountPosting(SalesHeader, SalesLine, SalesLineACY, InvoicePostBuffer);
        //     IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
        //         InvoicePostBuffer.SetAccount(
        //           GenPostingSetup.GetSalesInvDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        //         InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
        //         UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer, TRUE);
        //     END;
        // END;

        // IF SalesSetup."Post Line Discount" THEN BEGIN
        //     CalcLineDiscountPosting(SalesHeader, SalesLine, SalesLineACY, InvoicePostBuffer);
        //     IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
        //         InvoicePostBuffer.SetAccount(
        //           GenPostingSetup.GetSalesLineDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        //         InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
        //         UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer, TRUE);
        //     END;
        // END;

        // IF SalesSetup."Post Payment Discount" THEN BEGIN
        IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
            InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Pmt. Discount Amount", -SalesLineACY."Pmt. Discount Amount")
        ELSE
            InvoicePostBuffer.CalcDiscount(
              SalesHeader."Prices Including VAT", -SalesLine."Pmt. Discount Amount", -SalesLineACY."Pmt. Discount Amount");
        IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
            GenPostingSetup.TESTFIELD("Sales Pmt. Disc. Debit Acc.");
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Sales Pmt. Disc. Debit Acc.", TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
            InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
            UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer, TRUE);
        END;
        // END;

        OnFillInvoicePostingBufferOnBeforeDeferrals(SalesLine, TotalAmount, TotalAmountACY, UseDate);
        DeferralUtilities.AdjustTotalAmountForDeferralsNoBase(
          SalesLine."Deferral Code", AmtToDefer, AmtToDeferACY, TotalAmount, TotalAmountACY);

        InvoicePostBuffer.SetAmounts(
          TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, SalesLine."VAT Difference", TotalVATBase, TotalVATBaseACY);

        OnAfterInvoicePostingBufferSetAmounts(InvoicePostBuffer, SalesLine);

        IF (SalesLine.Type = SalesLine.Type::"G/L Account") OR (SalesLine.Type = SalesLine.Type::"Fixed Asset") THEN
            SalesAccount := SalesLine."No."
        ELSE
            IF SalesLine.IsCreditDocType THEN
                SalesAccount := GenPostingSetup.GetSalesCrMemoAccount
            ELSE
                SalesAccount := GenPostingSetup.GetSalesAccount;
        InvoicePostBuffer.SetAccount(SalesAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
        InvoicePostBuffer."Deferral Code" := SalesLine."Deferral Code";
        OnAfterFillInvoicePostBuffer(InvoicePostBuffer, SalesLine, TempInvoicePostBuffer, SuppressCommit);
        UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer, FALSE);
        IF SalesLine."Deferral Code" <> '' THEN BEGIN
            OnBeforeFillDeferralPostingBuffer(
              SalesLine, InvoicePostBuffer, TempInvoicePostBuffer, UseDate, InvDefLineNo, DeferralLineNo, SuppressCommit);
            FillDeferralPostingBuffer(SalesHeader, SalesLine, InvoicePostBuffer, AmtToDefer, AmtToDeferACY, DeferralAccount, SalesAccount);
        END;
    END;

    LOCAL PROCEDURE UpdateInvoicePostBuffer(VAR TempInvoicePostBuffer: Record 55 TEMPORARY; InvoicePostBuffer: Record 49; ForceGLAccountType: Boolean);
    VAR
        RestoreFAType: Boolean;
    BEGIN
        IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
            FALineNo := FALineNo + 1;
            InvoicePostBuffer."Fixed Asset Line No." := FALineNo;
            IF ForceGLAccountType THEN BEGIN
                RestoreFAType := TRUE;
                InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
            END;
        END;

        // TempInvoicePostBuffer.Update(InvoicePostBuffer, InvDefLineNo, DeferralLineNo);

        IF RestoreFAType THEN
            TempInvoicePostBuffer.Type := TempInvoicePostBuffer.Type::"Fixed Asset";
    END;

    LOCAL PROCEDURE InsertPrepmtAdjInvPostingBuf(SalesHeader: Record 36; PrepmtSalesLine: Record 37; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; InvoicePostBuffer: Record 49);
    VAR
        SalesPostPrepayments: Codeunit 442;
        AdjAmount: Decimal;
    BEGIN
        // WITH PrepmtSalesLine DO
        //     IF "Prepayment Line" THEN
        //         IF "Prepmt. Amount Inv. (LCY)" <> 0 THEN BEGIN
        //             AdjAmount := -"Prepmt. Amount Inv. (LCY)";
        // InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer, InvoicePostBuffer,
        //   "No.", AdjAmount, SalesHeader."Currency Code" = '');
        // InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer, InvoicePostBuffer,
        //   SalesPostPrepayments.GetCorrBalAccNo(SalesHeader, AdjAmount > 0),
        //   -AdjAmount, SalesHeader."Currency Code" = '');
        // END ELSE
        // IF ("Prepayment %" = 100) AND ("Prepmt. VAT Amount Inv. (LCY)" <> 0) THEN
        // InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer, InvoicePostBuffer,
        //   SalesPostPrepayments.GetInvRoundingAccNo(SalesHeader."Customer Posting Group"),
        //   "Prepmt. VAT Amount Inv. (LCY)", SalesHeader."Currency Code" = '');
    END;

    LOCAL PROCEDURE GetCurrency(CurrencyCode: Code[10]);
    BEGIN
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE DivideAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping"; SalesLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    VAR
        OriginalDeferralAmount: Decimal;
    BEGIN
        IF RoundingLineInserted AND (RoundingLineNo = SalesLine."Line No.") THEN
            EXIT;

        OnBeforeDivideAmount(SalesHeader, SalesLine, QtyType, SalesLineQty, TempVATAmountLine, TempVATAmountLineRemainder);

        WITH SalesLine DO
            IF (SalesLineQty = 0) OR ("Unit Price" = 0) THEN BEGIN
                "Line Amount" := 0;
                "Line Discount Amount" := 0;
                "Pmt. Discount Amount" := 0;
                "Inv. Discount Amount" := 0;
                "VAT Base Amount" := 0;
                Amount := 0;
                "Amount Including VAT" := 0;
            END ELSE BEGIN
                OriginalDeferralAmount := GetDeferralAmount;
                TempVATAmountLine.GET("VAT Identifier", "VAT Calculation Type", "Tax Group Code", FALSE, "Line Amount" >= 0);
                IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                    "VAT %" := TempVATAmountLine."VAT %";
                    "EC %" := TempVATAmountLine."EC %";
                END;
                TempVATAmountLineRemainder := TempVATAmountLine;
                IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
                    TempVATAmountLineRemainder.INIT;
                    TempVATAmountLineRemainder.INSERT;
                END;
                "Line Amount" := GetLineAmountToHandleInclPrepmt(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
                IF SalesLineQty <> Quantity THEN BEGIN
                    "Line Discount Amount" :=
                      ROUND("Line Discount Amount" * SalesLineQty / Quantity, Currency."Amount Rounding Precision");
                    "Pmt. Discount Amount" :=
                      ROUND("Pmt. Discount Amount" * SalesLineQty / Quantity, Currency."Amount Rounding Precision");
                END;

                IF "Allow Invoice Disc." AND (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) THEN
                    IF QtyType = QtyType::Invoicing THEN
                        "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
                    ELSE BEGIN
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" +
                          TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
                          TempVATAmountLine."Inv. Disc. Base Amount";
                        "Inv. Discount Amount" :=
                          ROUND(
                            TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" - "Inv. Discount Amount";
                    END;

                IF SalesHeader."Prices Including VAT" THEN BEGIN
                    IF (TempVATAmountLine.CalcLineAmount = 0) OR ("Line Amount" = 0) THEN BEGIN
                        TempVATAmountLineRemainder."VAT Amount" := 0;
                        TempVATAmountLineRemainder."EC Amount" := 0;
                        TempVATAmountLineRemainder."Amount Including VAT" := 0;
                    END ELSE BEGIN
                        TempVATAmountLineRemainder."VAT Amount" +=
                          TempVATAmountLine."VAT Amount" *
                          (CalcLineAmount - "Pmt. Discount Amount") /
                          (TempVATAmountLine.CalcLineAmount - TempVATAmountLine."Pmt. Discount Amount");
                        TempVATAmountLineRemainder."EC Amount" +=
                          TempVATAmountLine."EC Amount" *
                          (CalcLineAmount - "Pmt. Discount Amount") /
                          (TempVATAmountLine.CalcLineAmount - TempVATAmountLine."Pmt. Discount Amount");
                        TempVATAmountLineRemainder."Amount Including VAT" +=
                          TempVATAmountLine."Amount Including VAT" *
                          (CalcLineAmount - "Pmt. Discount Amount") /
                          (TempVATAmountLine.CalcLineAmount - TempVATAmountLine."Pmt. Discount Amount");
                    END;
                    IF "Line Discount %" <> 100 THEN
                        "Amount Including VAT" :=
                          ROUND(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision")
                    ELSE
                        "Amount Including VAT" := 0;
                    Amount :=
                      ROUND("Amount Including VAT", Currency."Amount Rounding Precision") -
                      ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision") -
                      ROUND(TempVATAmountLineRemainder."EC Amount", Currency."Amount Rounding Precision");
                    "VAT Base Amount" :=
                      ROUND(
                        Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
                END ELSE
                    IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                        IF "Line Discount %" <> 100 THEN
                            "Amount Including VAT" := CalcLineAmount
                        ELSE
                            "Amount Including VAT" := 0;
                        Amount := 0;
                        "VAT Base Amount" := 0;
                    END ELSE BEGIN
                        Amount := CalcLineAmount - "Pmt. Discount Amount";
                        "VAT Base Amount" :=
                          ROUND(
                            Amount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        IF TempVATAmountLine."VAT Base" = 0 THEN
                            TempVATAmountLineRemainder."VAT Amount" := 0
                        ELSE
                            IF TempVATAmountLine."Line Amount" <> 0 THEN BEGIN
                                TempVATAmountLineRemainder."VAT Amount" +=
                                  TempVATAmountLine."VAT Amount" *
                                  (CalcLineAmount - "Pmt. Discount Amount") /
                                  (TempVATAmountLine.CalcLineAmount - TempVATAmountLine."Pmt. Discount Amount");
                                TempVATAmountLineRemainder."EC Amount" +=
                                  TempVATAmountLine."EC Amount" *
                                  (CalcLineAmount - "Pmt. Discount Amount") /
                                  (TempVATAmountLine.CalcLineAmount - TempVATAmountLine."Pmt. Discount Amount");
                            END;
                        IF "Line Discount %" <> 100 THEN
                            "Amount Including VAT" :=
                              Amount + ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision") +
                              ROUND(TempVATAmountLineRemainder."EC Amount", Currency."Amount Rounding Precision")
                        ELSE
                            "Amount Including VAT" := 0;
                        TempVATAmountLineRemainder."VAT Amount" :=
                          TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
                    END;

                TempVATAmountLineRemainder.MODIFY;
                IF "Deferral Code" <> '' THEN
                    CalcDeferralAmounts(SalesHeader, SalesLine, OriginalDeferralAmount);
            END;

        OnAfterDivideAmount(SalesHeader, SalesLine, QtyType, SalesLineQty, TempVATAmountLine, TempVATAmountLineRemainder);
    END;

    LOCAL PROCEDURE RoundAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; SalesLineQty: Decimal);
    VAR
        CurrExchRate: Record 330;
        NoVAT: Boolean;
    BEGIN
        OnBeforeRoundAmount(SalesHeader, SalesLine, SalesLineQty);

        WITH SalesLine DO BEGIN
            IncrAmount(SalesHeader, SalesLine, TotalSalesLine);
            Increment(TotalSalesLine."Net Weight", ROUND(SalesLineQty * "Net Weight", 0.00001));
            Increment(TotalSalesLine."Gross Weight", ROUND(SalesLineQty * "Gross Weight", 0.00001));
            Increment(TotalSalesLine."Unit Volume", ROUND(SalesLineQty * "Unit Volume", 0.00001));
            Increment(TotalSalesLine.Quantity, SalesLineQty);
            IF "Units per Parcel" > 0 THEN
                Increment(
                  TotalSalesLine."Units per Parcel",
                  ROUND(SalesLineQty / "Units per Parcel", 1, '>'));

            xSalesLine := SalesLine;
            SalesLineACY := SalesLine;

            IF SalesHeader."Currency Code" <> '' THEN BEGIN
                IF SalesHeader."Posting Date" = 0D THEN
                    UseDate := WORKDATE
                ELSE
                    UseDate := SalesHeader."Posting Date";

                NoVAT := Amount = "Amount Including VAT";
                "Amount Including VAT" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Amount Including VAT", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."Amount Including VAT";
                IF NoVAT THEN
                    Amount := "Amount Including VAT"
                ELSE
                    Amount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          UseDate, SalesHeader."Currency Code",
                          TotalSalesLine.Amount, SalesHeader."Currency Factor")) -
                      TotalSalesLineLCY.Amount;
                "Line Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Line Amount", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."Line Amount";
                "Line Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Line Discount Amount", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."Line Discount Amount";
                "Inv. Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Inv. Discount Amount", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."Inv. Discount Amount";
                "Pmt. Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Pmt. Discount Amount", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."Pmt. Discount Amount";
                "VAT Difference" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."VAT Difference", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."VAT Difference";
                "VAT Base Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."VAT Base Amount", SalesHeader."Currency Factor")) -
                  TotalSalesLineLCY."VAT Base Amount";
            END;

            OnRoundAmountOnBeforeIncrAmount(SalesHeader, SalesLine, SalesLineQty, TotalSalesLine, TotalSalesLineLCY);

            IncrAmount(SalesHeader, SalesLine, TotalSalesLineLCY);
            Increment(TotalSalesLineLCY."Unit Cost (LCY)", ROUND(SalesLineQty * "Unit Cost (LCY)"));
        END;

        OnAfterRoundAmount(SalesHeader, SalesLine, SalesLineQty);
    END;

    LOCAL PROCEDURE ReverseAmount(VAR SalesLine: Record 37);
    BEGIN
        WITH SalesLine DO BEGIN
            "Qty. to Ship" := -"Qty. to Ship";
            "Qty. to Ship (Base)" := -"Qty. to Ship (Base)";
            "Return Qty. to Receive" := -"Return Qty. to Receive";
            "Return Qty. to Receive (Base)" := -"Return Qty. to Receive (Base)";
            "Qty. to Invoice" := -"Qty. to Invoice";
            "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
            "Line Amount" := -"Line Amount";
            Amount := -Amount;
            "VAT Base Amount" := -"VAT Base Amount";
            "VAT Difference" := -"VAT Difference";
            "Amount Including VAT" := -"Amount Including VAT";
            "Line Discount Amount" := -"Line Discount Amount";
            "Inv. Discount Amount" := -"Inv. Discount Amount";
            "Pmt. Discount Amount" := -"Pmt. Discount Amount";
            OnAfterReverseAmount(SalesLine);
        END;
    END;

    LOCAL PROCEDURE InvoiceRounding(SalesHeader: Record 36; VAR SalesLine: Record 37; UseTempData: Boolean; BiggestLineNo: Integer);
    VAR
        CustPostingGr: Record 92;
        InvoiceRoundingAmount: Decimal;
    BEGIN
        Currency.TESTFIELD("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalSalesLine."Amount Including VAT" -
            ROUND(
              TotalSalesLine."Amount Including VAT", Currency."Invoice Rounding Precision", Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");

        OnBeforeInvoiceRoundingAmount(
          SalesHeader, TotalSalesLine."Amount Including VAT", UseTempData, InvoiceRoundingAmount, SuppressCommit);
        IF InvoiceRoundingAmount <> 0 THEN BEGIN
            CustPostingGr.GET(SalesHeader."Customer Posting Group");
            WITH SalesLine DO BEGIN
                INIT;
                BiggestLineNo := BiggestLineNo + 10000;
                "System-Created Entry" := TRUE;
                IF UseTempData THEN BEGIN
                    "Line No." := 0;
                    Type := Type::"G/L Account";
                    SetHideValidationDialog(TRUE);
                END ELSE BEGIN
                    "Line No." := BiggestLineNo;
                    VALIDATE(Type, Type::"G/L Account");
                END;
                VALIDATE("No.", CustPostingGr.GetInvRoundingAccount);
                VALIDATE(Quantity, 1);
                IF IsCreditDocType THEN
                    VALIDATE("Return Qty. to Receive", Quantity)
                ELSE
                    VALIDATE("Qty. to Ship", Quantity);
                IF SalesHeader."Prices Including VAT" THEN
                    VALIDATE("Unit Price", InvoiceRoundingAmount)
                ELSE
                    VALIDATE(
                      "Unit Price",
                      ROUND(
                        InvoiceRoundingAmount /
                        (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                        Currency."Amount Rounding Precision"));
                VALIDATE("Amount Including VAT", InvoiceRoundingAmount);
                "Line No." := BiggestLineNo;
                LastLineRetrieved := FALSE;
                RoundingLineInserted := TRUE;
                RoundingLineNo := "Line No.";
            END;
        END;

        OnAfterInvoiceRoundingAmount(SalesHeader, SalesLine, TotalSalesLine, UseTempData, InvoiceRoundingAmount, SuppressCommit);
    END;

    LOCAL PROCEDURE IncrAmount(SalesHeader: Record 36; SalesLine: Record 37; VAR TotalSalesLine: Record 37);
    BEGIN
        WITH SalesLine DO BEGIN
            IF SalesHeader."Prices Including VAT" OR
               ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
            THEN
                Increment(TotalSalesLine."Line Amount", "Line Amount");
            Increment(TotalSalesLine.Amount, Amount);
            Increment(TotalSalesLine."VAT Base Amount", "VAT Base Amount");
            Increment(TotalSalesLine."VAT Difference", "VAT Difference");
            Increment(TotalSalesLine."Amount Including VAT", "Amount Including VAT");
            Increment(TotalSalesLine."Line Discount Amount", "Line Discount Amount");
            Increment(TotalSalesLine."Inv. Discount Amount", "Inv. Discount Amount");
            Increment(TotalSalesLine."Inv. Disc. Amount to Invoice", "Inv. Disc. Amount to Invoice");
            Increment(TotalSalesLine."Prepmt. Line Amount", "Prepmt. Line Amount");
            Increment(TotalSalesLine."Prepmt. Amt. Inv.", "Prepmt. Amt. Inv.");
            Increment(TotalSalesLine."Prepmt Amt to Deduct", "Prepmt Amt to Deduct");
            Increment(TotalSalesLine."Prepmt Amt Deducted", "Prepmt Amt Deducted");
            Increment(TotalSalesLine."Prepayment VAT Difference", "Prepayment VAT Difference");
            Increment(TotalSalesLine."Prepmt VAT Diff. to Deduct", "Prepmt VAT Diff. to Deduct");
            Increment(TotalSalesLine."Prepmt VAT Diff. Deducted", "Prepmt VAT Diff. Deducted");
            Increment(TotalSalesLine."Pmt. Discount Amount", "Pmt. Discount Amount");
            OnAfterIncrAmount(TotalSalesLine, SalesLine, SalesHeader);
        END;
    END;

    LOCAL PROCEDURE Increment(VAR Number: Decimal; Number2: Decimal);
    BEGIN
        Number := Number + Number2;
    END;

    //[External]
    PROCEDURE GetSalesLines(VAR SalesHeader: Record 36; VAR NewSalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping");
    VAR
        TotalAdjCostLCY: Decimal;
    BEGIN
        FillTempLines(SalesHeader, TempSalesLineGlobal);
        IF QtyType = QtyType::Invoicing THEN
            CreatePrepaymentLines(SalesHeader, FALSE);
        SumSalesLines2(SalesHeader, NewSalesLine, TempSalesLineGlobal, QtyType, TRUE, FALSE, TotalAdjCostLCY);
    END;

    //[External]
    PROCEDURE GetSalesLinesTemp(VAR SalesHeader: Record 36; VAR NewSalesLine: Record 37; VAR OldSalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping");
    VAR
        TotalAdjCostLCY: Decimal;
    BEGIN
        OldSalesLine.SetSalesHeader(SalesHeader);
        SumSalesLines2(SalesHeader, NewSalesLine, OldSalesLine, QtyType, TRUE, FALSE, TotalAdjCostLCY);
    END;

    //[External]
    PROCEDURE SumSalesLinesTemp(VAR SalesHeader: Record 36; VAR OldSalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping"; VAR NewTotalSalesLine: Record 37; VAR NewTotalSalesLineLCY: Record 37; VAR VATAmount: Decimal; VAR VATAmountText: Text[30]; VAR ProfitLCY: Decimal; VAR ProfitPct: Decimal; VAR TotalAdjCostLCY: Decimal);
    VAR
        SalesLine: Record 37;
    BEGIN
        WITH SalesHeader DO BEGIN
            SumSalesLines2(SalesHeader, SalesLine, OldSalesLine, QtyType, FALSE, TRUE, TotalAdjCostLCY);
            ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
            IF TotalSalesLineLCY.Amount = 0 THEN
                ProfitPct := 0
            ELSE
                ProfitPct := ROUND(ProfitLCY / TotalSalesLineLCY.Amount * 100, 0.1);
            VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
            IF (TotalSalesLine."VAT %" = 0) AND (TotalSalesLine."EC %" = 0) THEN
                VATAmountText := VATAmountTxt
            ELSE
                VATAmountText := STRSUBSTNO(VATRateTxt, (TotalSalesLine."VAT %" + TotalSalesLine."EC %"));
            NewTotalSalesLine := TotalSalesLine;
            NewTotalSalesLineLCY := TotalSalesLineLCY;
        END;
    END;

    LOCAL PROCEDURE SumSalesLines2(SalesHeader: Record 36; VAR NewSalesLine: Record 37; VAR OldSalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping"; InsertSalesLine: Boolean; CalcAdCostLCY: Boolean; VAR TotalAdjCostLCY: Decimal);
    VAR
        SalesLine: Record 37;
        TempVATAmountLine: Record 290 TEMPORARY;
        TempVATAmountLineRemainder: Record 290 TEMPORARY;
        SalesLineQty: Decimal;
        AdjCostLCY: Decimal;
        BiggestLineNo: Integer;
    BEGIN
        TotalAdjCostLCY := 0;
        TempVATAmountLineRemainder.DELETEALL;
        OldSalesLine.CalcVATAmountLines(QtyType, SalesHeader, OldSalesLine, TempVATAmountLine);
        WITH SalesHeader DO BEGIN
            GetGLSetup;
            SalesSetup.GET;
            GetCurrency("Currency Code");
            OldSalesLine.SETRANGE("Document Type", "Document Type");
            OldSalesLine.SETRANGE("Document No.", "No.");
            OnSumSalesLines2SetFilter(OldSalesLine, SalesHeader);
            RoundingLineInserted := FALSE;
            IF OldSalesLine.FINDSET THEN
                REPEAT
                    IF NOT RoundingLineInserted THEN
                        SalesLine := OldSalesLine;
                    CASE QtyType OF
                        QtyType::General:
                            SalesLineQty := SalesLine.Quantity;
                        QtyType::Invoicing:
                            SalesLineQty := SalesLine."Qty. to Invoice";
                        QtyType::Shipping:
                            BEGIN
                                IF IsCreditDocType THEN
                                    SalesLineQty := SalesLine."Return Qty. to Receive"
                                ELSE
                                    SalesLineQty := SalesLine."Qty. to Ship";
                            END;
                    END;
                    DivideAmount(SalesHeader, SalesLine, QtyType, SalesLineQty, TempVATAmountLine, TempVATAmountLineRemainder);
                    SalesLine.Quantity := SalesLineQty;
                    IF SalesLineQty <> 0 THEN BEGIN
                        IF (SalesLine.Amount <> 0) AND NOT RoundingLineInserted THEN
                            IF TotalSalesLine.Amount = 0 THEN BEGIN
                                TotalSalesLine."VAT %" := SalesLine."VAT %";
                                TotalSalesLine."EC %" := SalesLine."EC %";
                            END
                            ELSE
                                IF TotalSalesLine."VAT %" <> SalesLine."VAT %" THEN
                                    TotalSalesLine."VAT %" := 0;
                        RoundAmount(SalesHeader, SalesLine, SalesLineQty);

                        IF (QtyType IN [QtyType::General, QtyType::Invoicing]) AND
                           NOT InsertSalesLine AND CalcAdCostLCY
                        THEN BEGIN
                            AdjCostLCY := CostCalcMgt.CalcSalesLineCostLCY(SalesLine, QtyType);
                            TotalAdjCostLCY := TotalAdjCostLCY + GetSalesLineAdjCostLCY(SalesLine, QtyType, AdjCostLCY);
                        END;

                        SalesLine := xSalesLine;
                    END;
                    IF InsertSalesLine THEN BEGIN
                        NewSalesLine := SalesLine;
                        NewSalesLine.INSERT;
                    END;
                    IF RoundingLineInserted THEN
                        LastLineRetrieved := TRUE
                    ELSE BEGIN
                        BiggestLineNo := MAX(BiggestLineNo, OldSalesLine."Line No.");
                        LastLineRetrieved := OldSalesLine.NEXT = 0;
                        IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                            InvoiceRounding(SalesHeader, SalesLine, TRUE, BiggestLineNo);
                    END;
                UNTIL LastLineRetrieved;
        END;
    END;

    LOCAL PROCEDURE GetSalesLineAdjCostLCY(SalesLine2: Record 37; QtyType: Option "General","Invoicing","Shipping"; AdjCostLCY: Decimal): Decimal;
    BEGIN
        WITH SalesLine2 DO BEGIN
            IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN
                AdjCostLCY := -AdjCostLCY;

            CASE TRUE OF
                "Shipment No." <> '', "Return Receipt No." <> '':
                    EXIT(AdjCostLCY);
                QtyType = QtyType::General:
                    EXIT(ROUND("Outstanding Quantity" * "Unit Cost (LCY)") + AdjCostLCY);
                "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]:
                    BEGIN
                        IF "Qty. to Invoice" > "Qty. to Ship" THEN
                            EXIT(ROUND("Qty. to Ship" * "Unit Cost (LCY)") + AdjCostLCY);
                        EXIT(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
                    END;
                IsCreditDocType:
                    BEGIN
                        IF "Qty. to Invoice" > "Return Qty. to Receive" THEN
                            EXIT(ROUND("Return Qty. to Receive" * "Unit Cost (LCY)") + AdjCostLCY);
                        EXIT(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
                    END;
            END;
        END;
    END;

    //[External]
    PROCEDURE UpdateBlanketOrderLine(SalesLine: Record 37; Ship: Boolean; Receive: Boolean; Invoice: Boolean);
    VAR
        BlanketOrderSalesLine: Record 37;
        xBlanketOrderSalesLine: Record 37;
        ModifyLine: Boolean;
        Sign: Decimal;
    BEGIN
        IF (SalesLine."Blanket Order No." <> '') AND (SalesLine."Blanket Order Line No." <> 0) AND
           ((Ship AND (SalesLine."Qty. to Ship" <> 0)) OR
            (Receive AND (SalesLine."Return Qty. to Receive" <> 0)) OR
            (Invoice AND (SalesLine."Qty. to Invoice" <> 0)))
        THEN
            IF BlanketOrderSalesLine.GET(
                 BlanketOrderSalesLine."Document Type"::"Blanket Order", SalesLine."Blanket Order No.",
                 SalesLine."Blanket Order Line No.")
            THEN BEGIN
                BlanketOrderSalesLine.TESTFIELD(Type, SalesLine.Type);
                BlanketOrderSalesLine.TESTFIELD("No.", SalesLine."No.");
                BlanketOrderSalesLine.TESTFIELD("Sell-to Customer No.", SalesLine."Sell-to Customer No.");

                ModifyLine := FALSE;
                CASE SalesLine."Document Type" OF
                    SalesLine."Document Type"::Order,
                  SalesLine."Document Type"::Invoice:
                        Sign := 1;
                    SalesLine."Document Type"::"Return Order",
                  SalesLine."Document Type"::"Credit Memo":
                        Sign := -1;
                END;
                IF Ship AND (SalesLine."Shipment No." = '') THEN BEGIN
                    xBlanketOrderSalesLine := BlanketOrderSalesLine;

                    IF BlanketOrderSalesLine."Qty. per Unit of Measure" = SalesLine."Qty. per Unit of Measure" THEN
                        BlanketOrderSalesLine."Quantity Shipped" += Sign * SalesLine."Qty. to Ship"
                    ELSE
                        BlanketOrderSalesLine."Quantity Shipped" +=
                          Sign *
                          ROUND(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") *
                            SalesLine."Qty. to Ship", 0.00001);
                    BlanketOrderSalesLine."Qty. Shipped (Base)" += Sign * SalesLine."Qty. to Ship (Base)";
                    ModifyLine := TRUE;

                    AsmPost.UpdateBlanketATO(xBlanketOrderSalesLine, BlanketOrderSalesLine);
                END;
                IF Receive AND (SalesLine."Return Receipt No." = '') THEN BEGIN
                    IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    THEN
                        BlanketOrderSalesLine."Quantity Shipped" += Sign * SalesLine."Return Qty. to Receive"
                    ELSE
                        BlanketOrderSalesLine."Quantity Shipped" +=
                          Sign *
                          ROUND(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") *
                            SalesLine."Return Qty. to Receive", 0.00001);
                    BlanketOrderSalesLine."Qty. Shipped (Base)" += Sign * SalesLine."Return Qty. to Receive (Base)";
                    ModifyLine := TRUE;
                END;
                IF Invoice THEN BEGIN
                    IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    THEN
                        BlanketOrderSalesLine."Quantity Invoiced" += Sign * SalesLine."Qty. to Invoice"
                    ELSE
                        BlanketOrderSalesLine."Quantity Invoiced" +=
                          Sign *
                          ROUND(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") *
                            SalesLine."Qty. to Invoice", 0.00001);
                    BlanketOrderSalesLine."Qty. Invoiced (Base)" += Sign * SalesLine."Qty. to Invoice (Base)";
                    ModifyLine := TRUE;
                END;

                IF ModifyLine THEN BEGIN
                    OnUpdateBlanketOrderLineOnBeforeInitOutstanding(BlanketOrderSalesLine, SalesLine);
                    BlanketOrderSalesLine.InitOutstanding;
                    IF (BlanketOrderSalesLine.Quantity * BlanketOrderSalesLine."Quantity Shipped" < 0) OR
                       (ABS(BlanketOrderSalesLine.Quantity) < ABS(BlanketOrderSalesLine."Quantity Shipped"))
                    THEN
                        BlanketOrderSalesLine.FIELDERROR(
                          "Quantity Shipped", STRSUBSTNO(
                            BlanketOrderQuantityGreaterThanErr,
                            BlanketOrderSalesLine.FIELDCAPTION(Quantity)));

                    IF (BlanketOrderSalesLine."Quantity (Base)" * BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) OR
                       (ABS(BlanketOrderSalesLine."Quantity (Base)") < ABS(BlanketOrderSalesLine."Qty. Shipped (Base)"))
                    THEN
                        BlanketOrderSalesLine.FIELDERROR(
                          "Qty. Shipped (Base)",
                          STRSUBSTNO(
                            BlanketOrderQuantityGreaterThanErr,
                            BlanketOrderSalesLine.FIELDCAPTION("Quantity (Base)")));

                    BlanketOrderSalesLine.CALCFIELDS("Reserved Qty. (Base)");
                    IF ABS(BlanketOrderSalesLine."Outstanding Qty. (Base)") < ABS(BlanketOrderSalesLine."Reserved Qty. (Base)") THEN
                        BlanketOrderSalesLine.FIELDERROR(
                          "Reserved Qty. (Base)", BlanketOrderQuantityReducedErr);

                    BlanketOrderSalesLine."Qty. to Invoice" :=
                      BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
                    BlanketOrderSalesLine."Qty. to Ship" :=
                      BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
                    BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
                      BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
                    BlanketOrderSalesLine."Qty. to Ship (Base)" :=
                      BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

                    BlanketOrderSalesLine.MODIFY;
                END;
                OnAfterUpdateBlanketOrderLine(BlanketOrderSalesLine, SalesLine, Ship, Receive, Invoice);
            END;
    END;

    LOCAL PROCEDURE RunGenJnlPostLine(VAR GenJnlLine: Record 81): Integer;
    BEGIN
        EXIT(GenJnlPostLine.RunWithCheck(GenJnlLine));
    END;

    LOCAL PROCEDURE DeleteItemChargeAssgnt(SalesHeader: Record 36);
    VAR
        ItemChargeAssgntSales: Record 5809;
    BEGIN
        ItemChargeAssgntSales.SETRANGE("Document Type", SalesHeader."Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.", SalesHeader."No.");
        IF NOT ItemChargeAssgntSales.ISEMPTY THEN
            ItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateItemChargeAssgnt();
    VAR
        ItemChargeAssgntSales: Record 5809;
    BEGIN
        WITH TempItemChargeAssgntSales DO BEGIN
            ClearItemChargeAssgntFilter;
            MARKEDONLY(TRUE);
            IF FINDSET THEN
                REPEAT
                    ItemChargeAssgntSales.GET("Document Type", "Document No.", "Document Line No.", "Line No.");
                    ItemChargeAssgntSales."Qty. Assigned" :=
                      ItemChargeAssgntSales."Qty. Assigned" + "Qty. to Assign";
                    ItemChargeAssgntSales."Qty. to Assign" := 0;
                    ItemChargeAssgntSales."Amount to Assign" := 0;
                    ItemChargeAssgntSales.MODIFY;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateSalesOrderChargeAssgnt(SalesOrderInvLine: Record 37; SalesOrderLine: Record 37);
    VAR
        SalesOrderLine2: Record 37;
        SalesOrderInvLine2: Record 37;
        SalesShptLine: Record 111;
        ReturnRcptLine: Record 6661;
    BEGIN
        WITH SalesOrderInvLine DO BEGIN
            ClearItemChargeAssgntFilter;
            TempItemChargeAssgntSales.SETRANGE("Document Type", "Document Type");
            TempItemChargeAssgntSales.SETRANGE("Document No.", "Document No.");
            TempItemChargeAssgntSales.SETRANGE("Document Line No.", "Line No.");
            TempItemChargeAssgntSales.MARKEDONLY(TRUE);
            IF TempItemChargeAssgntSales.FINDSET THEN
                REPEAT
                    IF TempItemChargeAssgntSales."Applies-to Doc. Type" = "Document Type" THEN BEGIN
                        SalesOrderInvLine2.GET(
                          TempItemChargeAssgntSales."Applies-to Doc. Type",
                          TempItemChargeAssgntSales."Applies-to Doc. No.",
                          TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                        IF SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order THEN BEGIN
                            IF NOT
                               SalesShptLine.GET(SalesOrderInvLine2."Shipment No.", SalesOrderInvLine2."Shipment Line No.")
                            THEN
                                ERROR(ShipmentLinesDeletedErr);
                            SalesOrderLine2.GET(
                              SalesOrderLine2."Document Type"::Order,
                              SalesShptLine."Order No.", SalesShptLine."Order Line No.");
                        END ELSE BEGIN
                            IF NOT
                               ReturnRcptLine.GET(SalesOrderInvLine2."Return Receipt No.", SalesOrderInvLine2."Return Receipt Line No.")
                            THEN
                                ERROR(ReturnReceiptLinesDeletedErr);
                            SalesOrderLine2.GET(
                              SalesOrderLine2."Document Type"::"Return Order",
                              ReturnRcptLine."Return Order No.", ReturnRcptLine."Return Order Line No.");
                        END;
                        UpdateSalesChargeAssgntLines(
                          SalesOrderLine,
                          SalesOrderLine2."Document Type",//enum to option
                          SalesOrderLine2."Document No.",
                          SalesOrderLine2."Line No.",
                          TempItemChargeAssgntSales."Qty. to Assign");
                    END ELSE
                        UpdateSalesChargeAssgntLines(
                          SalesOrderLine,
                          TempItemChargeAssgntSales."Applies-to Doc. Type",//enum to option
                          TempItemChargeAssgntSales."Applies-to Doc. No.",
                          TempItemChargeAssgntSales."Applies-to Doc. Line No.",
                          TempItemChargeAssgntSales."Qty. to Assign");
                UNTIL TempItemChargeAssgntSales.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateSalesChargeAssgntLines(SalesOrderLine: Record 37; ApplToDocType: Enum "Sales Document Type"; ApplToDocNo: Code[20]; ApplToDocLineNo: Integer; QtyToAssign: Decimal);
    VAR
        ItemChargeAssgntSales: Record 5809;
        TempItemChargeAssgntSales2: Record 5809;
        LastLineNo: Integer;
        TotalToAssign: Decimal;
    BEGIN
        ItemChargeAssgntSales.SETRANGE("Document Type", SalesOrderLine."Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.", SalesOrderLine."Document No.");
        ItemChargeAssgntSales.SETRANGE("Document Line No.", SalesOrderLine."Line No.");
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type", ApplToDocType);
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.", ApplToDocNo);
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.", ApplToDocLineNo);
        IF ItemChargeAssgntSales.FINDFIRST THEN BEGIN
            ItemChargeAssgntSales."Qty. Assigned" := ItemChargeAssgntSales."Qty. Assigned" + QtyToAssign;
            ItemChargeAssgntSales."Qty. to Assign" := 0;
            ItemChargeAssgntSales."Amount to Assign" := 0;
            ItemChargeAssgntSales.MODIFY;
        END ELSE BEGIN
            ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
            ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
            ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
            ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");

            // calculate total qty. to assign of the invoice charge line
            TempItemChargeAssgntSales2.SETRANGE("Document Type", TempItemChargeAssgntSales."Document Type");
            TempItemChargeAssgntSales2.SETRANGE("Document No.", TempItemChargeAssgntSales."Document No.");
            TempItemChargeAssgntSales2.SETRANGE("Document Line No.", TempItemChargeAssgntSales."Document Line No.");
            TempItemChargeAssgntSales2.CALCSUMS("Qty. to Assign");

            TotalToAssign := ItemChargeAssgntSales."Qty. to Assign" +
              TempItemChargeAssgntSales2."Qty. to Assign";

            IF ItemChargeAssgntSales.FINDLAST THEN
                LastLineNo := ItemChargeAssgntSales."Line No.";

            IF SalesOrderLine.Quantity < TotalToAssign THEN
                REPEAT
                    TotalToAssign := TotalToAssign - ItemChargeAssgntSales."Qty. to Assign";
                    ItemChargeAssgntSales."Qty. to Assign" := 0;
                    ItemChargeAssgntSales."Amount to Assign" := 0;
                    ItemChargeAssgntSales.MODIFY;
                UNTIL (ItemChargeAssgntSales.NEXT(-1) = 0) OR
                      (TotalToAssign = SalesOrderLine.Quantity);

            InsertAssocOrderCharge(
              SalesOrderLine,
              ApplToDocType,
              ApplToDocNo,
              ApplToDocLineNo,
              LastLineNo,
              TempItemChargeAssgntSales."Applies-to Doc. Line Amount");
        END;
    END;

    LOCAL PROCEDURE InsertAssocOrderCharge(SalesOrderLine: Record 37; ApplToDocType: Enum "Sales Document Type"; ApplToDocNo: Code[20]; ApplToDocLineNo: Integer; LastLineNo: Integer; ApplToDocLineAmt: Decimal);
    VAR
        NewItemChargeAssgntSales: Record 5809;
    BEGIN
        WITH NewItemChargeAssgntSales DO BEGIN
            INIT;
            "Document Type" := SalesOrderLine."Document Type";
            "Document No." := SalesOrderLine."Document No.";
            "Document Line No." := SalesOrderLine."Line No.";
            "Line No." := LastLineNo + 10000;
            "Item Charge No." := TempItemChargeAssgntSales."Item Charge No.";
            "Item No." := TempItemChargeAssgntSales."Item No.";
            "Qty. Assigned" := TempItemChargeAssgntSales."Qty. to Assign";
            "Qty. to Assign" := 0;
            "Amount to Assign" := 0;
            Description := TempItemChargeAssgntSales.Description;
            "Unit Cost" := TempItemChargeAssgntSales."Unit Cost";
            "Applies-to Doc. Type" := ApplToDocType;//option to enum
            "Applies-to Doc. No." := ApplToDocNo;
            "Applies-to Doc. Line No." := ApplToDocLineNo;
            "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE CopyAndCheckItemCharge(SalesHeader: Record 36);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        SalesLine: Record 37;
        InvoiceEverything: Boolean;
        AssignError: Boolean;
        QtyNeeded: Decimal;
    BEGIN
        TempItemChargeAssgntSales.RESET;
        TempItemChargeAssgntSales.DELETEALL;

        // Check for max qty posting
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            SETRANGE(Type, Type::"Charge (Item)");
            IF ISEMPTY THEN
                EXIT;

            ItemChargeAssgntSales.RESET;
            ItemChargeAssgntSales.SETRANGE("Document Type", "Document Type");
            ItemChargeAssgntSales.SETRANGE("Document No.", "Document No.");
            ItemChargeAssgntSales.SETFILTER("Qty. to Assign", '<>0');
            IF ItemChargeAssgntSales.FINDSET THEN
                REPEAT
                    TempItemChargeAssgntSales.INIT;
                    TempItemChargeAssgntSales := ItemChargeAssgntSales;
                    TempItemChargeAssgntSales.INSERT;
                UNTIL ItemChargeAssgntSales.NEXT = 0;

            SETFILTER("Qty. to Invoice", '<>0');
            IF FINDSET THEN
                REPEAT
                    TESTFIELD("Job No.", '');
                    TESTFIELD("Job Contract Entry No.", 0);
                    IF ("Qty. to Ship" + "Return Qty. to Receive" <> 0) AND
                       ((SalesHeader.Ship OR SalesHeader.Receive) OR
                        (ABS("Qty. to Invoice") >
                         ABS("Qty. Shipped Not Invoiced" + "Qty. to Ship") +
                         ABS("Ret. Qty. Rcd. Not Invd.(Base)" + "Return Qty. to Receive")))
                    THEN
                        TESTFIELD("Line Amount");

                    IF NOT SalesHeader.Ship THEN
                        "Qty. to Ship" := 0;
                    IF NOT SalesHeader.Receive THEN
                        "Return Qty. to Receive" := 0;
                    IF ABS("Qty. to Invoice") >
                       ABS("Quantity Shipped" + "Qty. to Ship" + "Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced")
                    THEN
                        "Qty. to Invoice" :=
                          "Quantity Shipped" + "Qty. to Ship" + "Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced";

                    CALCFIELDS("Qty. to Assign", "Qty. Assigned");
                    IF ABS("Qty. to Assign" + "Qty. Assigned") > ABS("Qty. to Invoice" + "Quantity Invoiced") THEN
                        ERROR(CannotAssignMoreErr,
                          "Qty. to Invoice" + "Quantity Invoiced" - "Qty. Assigned",
                          FIELDCAPTION("Document Type"), "Document Type",
                          FIELDCAPTION("Document No."), "Document No.",
                          FIELDCAPTION("Line No."), "Line No.");
                    IF Quantity = "Qty. to Invoice" + "Quantity Invoiced" THEN BEGIN
                        IF "Qty. to Assign" <> 0 THEN
                            IF Quantity = "Quantity Invoiced" THEN BEGIN
                                TempItemChargeAssgntSales.SETRANGE("Document Line No.", "Line No.");
                                TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type", "Document Type");
                                IF TempItemChargeAssgntSales.FINDSET THEN
                                    REPEAT
                                        SalesLine.GET(
                                          TempItemChargeAssgntSales."Applies-to Doc. Type",
                                          TempItemChargeAssgntSales."Applies-to Doc. No.",
                                          TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                                        IF SalesLine.Quantity = SalesLine."Quantity Invoiced" THEN
                                            ERROR(CannotAssignInvoicedErr, SalesLine.TABLECAPTION,
                                              SalesLine.FIELDCAPTION("Document Type"), SalesLine."Document Type",
                                              SalesLine.FIELDCAPTION("Document No."), SalesLine."Document No.",
                                              SalesLine.FIELDCAPTION("Line No."), SalesLine."Line No.");
                                    UNTIL TempItemChargeAssgntSales.NEXT = 0;
                            END;
                        IF Quantity <> "Qty. to Assign" + "Qty. Assigned" THEN
                            AssignError := TRUE;
                    END;

                    IF ("Qty. to Assign" + "Qty. Assigned") < ("Qty. to Invoice" + "Quantity Invoiced") THEN
                        ERROR(MustAssignItemChargeErr, "No.");

                    // check if all ILEs exist
                    QtyNeeded := "Qty. to Assign";
                    TempItemChargeAssgntSales.SETRANGE("Document Line No.", "Line No.");
                    IF TempItemChargeAssgntSales.FINDSET THEN
                        REPEAT
                            IF (TempItemChargeAssgntSales."Applies-to Doc. Type" <> "Document Type") OR
                               (TempItemChargeAssgntSales."Applies-to Doc. No." <> "Document No.")
                            THEN
                                QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign"
                            ELSE BEGIN
                                SalesLine.GET(
                                  TempItemChargeAssgntSales."Applies-to Doc. Type",
                                  TempItemChargeAssgntSales."Applies-to Doc. No.",
                                  TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                                IF ItemLedgerEntryExist(SalesLine, SalesHeader.Ship OR SalesHeader.Receive) THEN
                                    QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign";
                            END;
                        UNTIL TempItemChargeAssgntSales.NEXT = 0;

                    IF QtyNeeded <> 0 THEN
                        ERROR(CannotInvoiceItemChargeErr, "No.");
                UNTIL NEXT = 0;

            // Check saleslines
            IF AssignError THEN
                IF SalesHeader."Document Type" IN
                   [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]
                THEN
                    InvoiceEverything := TRUE
                ELSE BEGIN
                    RESET;
                    SETFILTER(Type, '%1|%2', Type::Item, Type::"Charge (Item)");
                    IF FINDSET THEN
                        REPEAT
                            IF SalesHeader.Ship OR SalesHeader.Receive THEN
                                InvoiceEverything :=
                                  Quantity = "Qty. to Invoice" + "Quantity Invoiced"
                            ELSE
                                InvoiceEverything :=
                                  (Quantity = "Qty. to Invoice" + "Quantity Invoiced") AND
                                  ("Qty. to Invoice" =
                                   "Qty. Shipped Not Invoiced" + "Ret. Qty. Rcd. Not Invd.(Base)");
                        UNTIL (NEXT = 0) OR (NOT InvoiceEverything);
                END;

            IF InvoiceEverything AND AssignError THEN
                ERROR(MustAssignErr);
        END;
    END;

    LOCAL PROCEDURE ClearItemChargeAssgntFilter();
    BEGIN
        TempItemChargeAssgntSales.SETRANGE("Document Line No.");
        TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
        TempItemChargeAssgntSales.MARKEDONLY(FALSE);
    END;

    LOCAL PROCEDURE GetItemChargeLine(SalesHeader: Record 36; VAR ItemChargeSalesLine: Record 37);
    VAR
        SalesShptLine: Record 111;
        ReturnReceiptLine: Record 6661;
        QtyShippedNotInvd: Decimal;
        QtyReceivedNotInvd: Decimal;
    BEGIN
        WITH TempItemChargeAssgntSales DO
            IF (ItemChargeSalesLine."Document Type" <> "Document Type") OR
               (ItemChargeSalesLine."Document No." <> "Document No.") OR
               (ItemChargeSalesLine."Line No." <> "Document Line No.")
            THEN BEGIN
                ItemChargeSalesLine.GET("Document Type", "Document No.", "Document Line No.");
                IF NOT SalesHeader.Ship THEN
                    ItemChargeSalesLine."Qty. to Ship" := 0;
                IF NOT SalesHeader.Receive THEN
                    ItemChargeSalesLine."Return Qty. to Receive" := 0;
                IF ItemChargeSalesLine."Shipment No." <> '' THEN BEGIN
                    SalesShptLine.GET(ItemChargeSalesLine."Shipment No.", ItemChargeSalesLine."Shipment Line No.");
                    QtyShippedNotInvd := "Qty. to Assign" - "Qty. Assigned";
                END ELSE
                    QtyShippedNotInvd := ItemChargeSalesLine."Quantity Shipped";
                IF ItemChargeSalesLine."Return Receipt No." <> '' THEN BEGIN
                    ReturnReceiptLine.GET(ItemChargeSalesLine."Return Receipt No.", ItemChargeSalesLine."Return Receipt Line No.");
                    QtyReceivedNotInvd := "Qty. to Assign" - "Qty. Assigned";
                END ELSE
                    QtyReceivedNotInvd := ItemChargeSalesLine."Return Qty. Received";
                IF ABS(ItemChargeSalesLine."Qty. to Invoice") >
                   ABS(QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
                     QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
                     ItemChargeSalesLine."Quantity Invoiced")
                THEN
                    ItemChargeSalesLine."Qty. to Invoice" :=
                      QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
                      QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
                      ItemChargeSalesLine."Quantity Invoiced";
            END;
    END;

    LOCAL PROCEDURE CalcQtyToInvoice(QtyToHandle: Decimal; QtyToInvoice: Decimal): Decimal;
    BEGIN
        IF ABS(QtyToHandle) > ABS(QtyToInvoice) THEN
            EXIT(-QtyToHandle);

        EXIT(-QtyToInvoice);
    END;

    PROCEDURE CheckWarehouse(VAR TempItemSalesLine: Record 37 TEMPORARY);
    VAR
        WhseValidateSourceLine: Codeunit 5777;
        ShowError: Boolean;
    BEGIN
        WITH TempItemSalesLine DO BEGIN
            SETRANGE(Type, Type::Item);
            SETRANGE("Drop Shipment", FALSE);
            IF FINDSET THEN
                REPEAT
                    GetLocation("Location Code");
                    CASE "Document Type" OF
                        "Document Type"::Order:
                            IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity < 0)) OR
                               ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity >= 0))
                            THEN BEGIN
                                IF Location."Directed Put-away and Pick" THEN
                                    ShowError := TRUE
                                ELSE
                                    IF WhseValidateSourceLine.WhseLinesExist(
                                         DATABASE::"Sales Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, Quantity)//enum to option
                                    THEN
                                        ShowError := TRUE;
                            END;
                        "Document Type"::"Return Order":
                            IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity >= 0)) OR
                               ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity < 0))
                            THEN BEGIN
                                IF Location."Directed Put-away and Pick" THEN
                                    ShowError := TRUE
                                ELSE
                                    IF WhseValidateSourceLine.WhseLinesExist(
                                         DATABASE::"Sales Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, Quantity)//enum to option
                                    THEN
                                        ShowError := TRUE;
                            END;
                        "Document Type"::Invoice, "Document Type"::"Credit Memo":
                            IF Location."Directed Put-away and Pick" THEN
                                Location.TESTFIELD("Adjustment Bin Code");
                    END;
                    IF ShowError THEN
                        ERROR(
                          WarehouseRequiredErr,
                          FIELDCAPTION("Document Type"), "Document Type",
                          FIELDCAPTION("Document No."), "Document No.",
                          FIELDCAPTION("Line No."), "Line No.");
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CreateWhseJnlLine(ItemJnlLine: Record 83; SalesLine: Record 37; VAR TempWhseJnlLine: Record 7311 TEMPORARY);
    VAR
        WhseMgt: Codeunit 5775;
        WMSMgt: Codeunit 7302;
    BEGIN
        WITH SalesLine DO BEGIN
            WMSMgt.CheckAdjmtBin(Location, ItemJnlLine.Quantity, TRUE);
            WMSMgt.CreateWhseJnlLine(ItemJnlLine, 0, TempWhseJnlLine, FALSE);
            TempWhseJnlLine."Source Type" := DATABASE::"Sales Line";
            TempWhseJnlLine."Source Subtype" := "Document Type".AsInteger();//enum to option
            TempWhseJnlLine."Source Code" := SrcCode;
            TempWhseJnlLine."Source Document" := Enum::"Warehouse Journal Source Document".FromInteger(WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type", TempWhseJnlLine."Source Subtype"));
            TempWhseJnlLine."Source No." := "Document No.";
            TempWhseJnlLine."Source Line No." := "Line No.";
            CASE "Document Type" OF
                "Document Type"::Order:
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted Shipment";
                "Document Type"::Invoice:
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted S. Inv.";
                "Document Type"::"Credit Memo":
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted S. Cr. Memo";
                "Document Type"::"Return Order":
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted Rtrn. Shipment";
            END;
            TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
        END;
    END;

    LOCAL PROCEDURE WhseHandlingRequired(SalesLine: Record 37): Boolean;
    VAR
        WhseSetup: Record 5769;
    BEGIN
        IF (SalesLine.Type = SalesLine.Type::Item) AND (NOT SalesLine."Drop Shipment") THEN BEGIN
            IF SalesLine."Location Code" = '' THEN BEGIN
                WhseSetup.GET;
                IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
                    EXIT(WhseSetup."Require Receive");

                EXIT(WhseSetup."Require Shipment");
            END;

            GetLocation(SalesLine."Location Code");
            IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
                EXIT(Location."Require Receive");

            EXIT(Location."Require Shipment");
        END;
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetLocation(LocationCode: Code[10]);
    BEGIN
        IF LocationCode = '' THEN
            Location.GetLocationSetup(LocationCode, Location)
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE InsertShptEntryRelation(VAR SalesShptLine: Record 111): Integer;
    VAR
        ItemEntryRelation: Record 6507;
    BEGIN
        TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
        TempHandlingSpecification.CopySpecification(TempATOTrackingSpecification);
        TempHandlingSpecification.RESET;
        IF TempHandlingSpecification.FINDSET THEN BEGIN
            REPEAT
                ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
                ItemEntryRelation.TransferFieldsSalesShptLine(SalesShptLine);
                ItemEntryRelation.INSERT;
            UNTIL TempHandlingSpecification.NEXT = 0;
            TempHandlingSpecification.DELETEALL;
            EXIT(0);
        END;
        EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE InsertReturnEntryRelation(VAR ReturnRcptLine: Record 6661): Integer;
    VAR
        ItemEntryRelation: Record 6507;
    BEGIN
        TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
        TempHandlingSpecification.CopySpecification(TempATOTrackingSpecification);
        TempHandlingSpecification.RESET;
        IF TempHandlingSpecification.FINDSET THEN BEGIN
            REPEAT
                ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
                ItemEntryRelation.TransferFieldsReturnRcptLine(ReturnRcptLine);
                ItemEntryRelation.INSERT;
            UNTIL TempHandlingSpecification.NEXT = 0;
            TempHandlingSpecification.DELETEALL;
            EXIT(0);
        END;
        EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE CheckTrackingSpecification(SalesHeader: Record 36; VAR TempItemSalesLine: Record 37 TEMPORARY);
    VAR
        ReservationEntry: Record 337;
        ItemTrackingCode: Record 6502;
        ItemJnlLine: Record 83;
        CreateReservEntry: Codeunit 99000830;
        ItemTrackingManagement: Codeunit 6500;
        ItemTrackingManagement1: Codeunit 51151;
        ErrorFieldCaption: Text[250];
        SignFactor: Integer;
        SalesLineQtyToHandle: Decimal;
        TrackingQtyToHandle: Decimal;
        Inbound: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        SNInfoRequired: Boolean;
        LotInfoRequired: Boolean;
        CheckSalesLine: Boolean;
        SalesPost: codeunit 50004;
    BEGIN
        // if a SalesLine is posted with ItemTracking then tracked quantity must be equal to posted quantity
        IF NOT (SalesHeader."Document Type" IN
                [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"])
        THEN
            EXIT;

        TrackingQtyToHandle := 0;

        WITH TempItemSalesLine DO BEGIN
            SETRANGE(Type, Type::Item);
            IF SalesHeader.Ship THEN BEGIN
                SETFILTER("Quantity Shipped", '<>%1', 0);
                ErrorFieldCaption := FIELDCAPTION("Qty. to Ship");
            END ELSE BEGIN
                SETFILTER("Return Qty. Received", '<>%1', 0);
                ErrorFieldCaption := FIELDCAPTION("Return Qty. to Receive");
            END;

            IF FINDSET THEN BEGIN
                ReservationEntry."Source Type" := DATABASE::"Sales Line";
                ReservationEntry."Source Subtype" := SalesHeader."Document Type".AsInteger();//enum to option
                SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
                REPEAT
                    // Only Item where no SerialNo or LotNo is required
                    SalesPost.GetItem(TempItemSalesLine);
                    IF Item."Item Tracking Code" <> '' THEN BEGIN
                        Inbound := (Quantity * SignFactor) > 0;
                        ItemTrackingCode.Code := Item."Item Tracking Code";
                        ItemTrackingManagement1.GetItemTrackingSettings(ItemTrackingCode,
                          ItemJnlLine."Entry Type"::Sale, Inbound,
                          SNRequired, LotRequired, SNInfoRequired, LotInfoRequired);
                        CheckSalesLine := NOT SNRequired AND NOT LotRequired;
                        IF CheckSalesLine THEN
                            CheckSalesLine := CheckTrackingExists(TempItemSalesLine);
                    END ELSE
                        CheckSalesLine := FALSE;

                    TrackingQtyToHandle := 0;

                    IF CheckSalesLine THEN BEGIN
                        TrackingQtyToHandle := GetTrackingQuantities(TempItemSalesLine) * SignFactor;
                        IF SalesHeader.Ship THEN
                            SalesLineQtyToHandle := "Qty. to Ship (Base)"
                        ELSE
                            SalesLineQtyToHandle := "Return Qty. to Receive (Base)";
                        IF TrackingQtyToHandle <> SalesLineQtyToHandle THEN
                            ERROR(ItemTrackQuantityMismatchErr, ErrorFieldCaption);
                    END;
                UNTIL NEXT = 0;
            END;
            IF SalesHeader.Ship THEN
                SETRANGE("Quantity Shipped")
            ELSE
                SETRANGE("Return Qty. Received");
        END;
    END;

    LOCAL PROCEDURE CheckTrackingExists(SalesLine: Record 37): Boolean;
    BEGIN
        EXIT(
          ItemTrackingMgt1.ItemTrackingExistsOnDocumentLine(
            DATABASE::"Sales Line", SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No."));//enum to option
    END;

    LOCAL PROCEDURE GetTrackingQuantities(SalesLine: Record 37): Decimal;
    BEGIN
        EXIT(
          ItemTrackingMgt1.CalcQtyToHandleForTrackedQtyOnDocumentLine(
            DATABASE::"Sales Line", SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No."));//enum to option
    END;

    LOCAL PROCEDURE SaveInvoiceSpecification(VAR TempInvoicingSpecification: Record 336 TEMPORARY);
    BEGIN
        TempInvoicingSpecification.RESET;
        IF TempInvoicingSpecification.FINDSET THEN BEGIN
            REPEAT
                TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Quantity actual Handled (Base)";
                TempInvoicingSpecification."Quantity actual Handled (Base)" := 0;
                TempTrackingSpecification := TempInvoicingSpecification;
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
                IF NOT TempTrackingSpecification.INSERT THEN BEGIN
                    TempTrackingSpecification.GET(TempInvoicingSpecification."Entry No.");
                    TempTrackingSpecification."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                    TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                    TempTrackingSpecification."Qty. to Invoice" += TempInvoicingSpecification."Qty. to Invoice";
                    TempTrackingSpecification.MODIFY;
                END;
            UNTIL TempInvoicingSpecification.NEXT = 0;
            TempInvoicingSpecification.DELETEALL;
        END;
    END;

    LOCAL PROCEDURE InsertTrackingSpecification(SalesHeader: Record 36);
    BEGIN
        TempTrackingSpecification.RESET;
        IF NOT TempTrackingSpecification.ISEMPTY THEN BEGIN
            TempTrackingSpecification.InsertSpecification;
            ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesHeader);
        END;
    END;

    LOCAL PROCEDURE InsertValueEntryRelation();
    VAR
        ValueEntryRelation: Record 6508;
    BEGIN
        TempValueEntryRelation.RESET;
        IF TempValueEntryRelation.FINDSET THEN BEGIN
            REPEAT
                ValueEntryRelation := TempValueEntryRelation;
                ValueEntryRelation.INSERT;
            UNTIL TempValueEntryRelation.NEXT = 0;
            TempValueEntryRelation.DELETEALL;
        END;
    END;

    LOCAL PROCEDURE SetPaymentInstructions(SalesHeader: Record 36);
    VAR
        O365PaymentInstructions: Record 2155;
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    BEGIN
        // IF NOT O365PaymentInstructions.GET(SalesHeader."Payment Instructions Id") THEN
        //     EXIT;

        // O365PaymentInstructions.CopyInstructionsInCurrentLanguageToBlob(TempBlob);
        //SalesInvHeader."Payment Instructions" := TempBlob.Blob;
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        // Instr.Read(SalesInvHeader."Payment Instructions");
        // SalesInvHeader."Payment Instructions Name" := O365PaymentInstructions.GetNameInCurrentLanguage;
    END;

    LOCAL PROCEDURE PostItemCharge(SalesHeader: Record 36; VAR SalesLine: Record 37; ItemEntryNo: Integer; QuantityBase: Decimal; AmountToAssign: Decimal; QtyToAssign: Decimal);
    VAR
        DummyTrackingSpecification: Record 336;
        SalesLineToPost: Record 37;
        CurrExchRate: Record 330;
    BEGIN
        WITH TempItemChargeAssgntSales DO BEGIN
            SalesLineToPost := SalesLine;
            SalesLineToPost."No." := "Item No.";
            SalesLineToPost."Appl.-to Item Entry" := ItemEntryNo;
            IF NOT ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) THEN
                SalesLineToPost.Amount := -AmountToAssign
            ELSE
                SalesLineToPost.Amount := AmountToAssign;

            IF SalesLineToPost."Currency Code" <> '' THEN
                SalesLineToPost."Unit Cost" := ROUND(
                    SalesLineToPost.Amount / QuantityBase, Currency."Unit-Amount Rounding Precision")
            ELSE
                SalesLineToPost."Unit Cost" := ROUND(
                    SalesLineToPost.Amount / QuantityBase, GLSetup."Unit-Amount Rounding Precision");
            TotalChargeAmt := TotalChargeAmt + SalesLineToPost.Amount;

            IF SalesHeader."Currency Code" <> '' THEN
                SalesLineToPost.Amount :=
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    UseDate, SalesHeader."Currency Code", TotalChargeAmt, SalesHeader."Currency Factor");
            SalesLineToPost."Inv. Discount Amount" := ROUND(
                SalesLine."Inv. Discount Amount" / SalesLine.Quantity * QtyToAssign,
                GLSetup."Amount Rounding Precision");
            SalesLineToPost."Line Discount Amount" := ROUND(
                SalesLine."Line Discount Amount" / SalesLine.Quantity * QtyToAssign,
                GLSetup."Amount Rounding Precision");
            SalesLineToPost."Line Amount" := ROUND(
                SalesLine."Line Amount" / SalesLine.Quantity * QtyToAssign,
                GLSetup."Amount Rounding Precision");
            SalesLine."Inv. Discount Amount" := SalesLine."Inv. Discount Amount" - SalesLineToPost."Inv. Discount Amount";
            SalesLine."Line Discount Amount" := SalesLine."Line Discount Amount" - SalesLineToPost."Line Discount Amount";
            SalesLine."Line Amount" := SalesLine."Line Amount" - SalesLineToPost."Line Amount";
            SalesLine.Quantity := SalesLine.Quantity - QtyToAssign;
            SalesLineToPost.Amount := ROUND(SalesLineToPost.Amount, GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
            IF SalesHeader."Currency Code" <> '' THEN
                TotalChargeAmtLCY := TotalChargeAmtLCY + SalesLineToPost.Amount;
            SalesLineToPost."Unit Cost (LCY)" := ROUND(
                SalesLineToPost.Amount / QuantityBase, GLSetup."Unit-Amount Rounding Precision");
            UpdateSalesLineDimSetIDFromAppliedEntry(SalesLineToPost, SalesLine);
            SalesLineToPost."Line No." := "Document Line No.";
            PostItemJnlLine(
              SalesHeader, SalesLineToPost,
              0, 0, -QuantityBase, -QuantityBase,
              SalesLineToPost."Appl.-to Item Entry",
              "Item Charge No.", DummyTrackingSpecification, FALSE);
        END;
    END;

    LOCAL PROCEDURE SaveTempWhseSplitSpec(VAR SalesLine3: Record 37; VAR TempSrcTrackingSpec: Record 336 TEMPORARY);
    BEGIN
        TempWhseSplitSpecification.RESET;
        TempWhseSplitSpecification.DELETEALL;
        IF TempSrcTrackingSpec.FINDSET THEN
            REPEAT
                TempWhseSplitSpecification := TempSrcTrackingSpec;
                TempWhseSplitSpecification.SetSource(
                  DATABASE::"Sales Line", SalesLine3."Document Type".AsInteger(), SalesLine3."Document No.", SalesLine3."Line No.", '', 0);
                TempWhseSplitSpecification.INSERT;
            UNTIL TempSrcTrackingSpec.NEXT = 0;
    END;

    LOCAL PROCEDURE TransferReservToItemJnlLine(VAR SalesOrderLine: Record 37; VAR ItemJnlLine: Record 83; QtyToBeShippedBase: Decimal; VAR TempTrackingSpecification2: Record 336 TEMPORARY; VAR CheckApplFromItemEntry: Boolean);
    VAR
        RemainingQuantity: Decimal;
    BEGIN
        // Handle Item Tracking and reservations, also on drop shipment
        IF QtyToBeShippedBase = 0 THEN
            EXIT;

        CLEAR(ReserveSalesLine);
        IF NOT SalesOrderLine."Drop Shipment" THEN
            IF NOT HasSpecificTracking(SalesOrderLine."No.") AND HasInvtPickLine(SalesOrderLine) THEN
                ReserveSalesLine.TransferSalesLineToItemJnlLine(
                  SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, TRUE)
            ELSE
                ReserveSalesLine.TransferSalesLineToItemJnlLine(
                  SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, FALSE)
        ELSE BEGIN
            ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
            TempTrackingSpecification2.RESET;
            TempTrackingSpecification2.SetSourceFilter(
              DATABASE::"Purchase Line", 1, SalesOrderLine."Purchase Order No.", SalesOrderLine."Purch. Order Line No.", FALSE);
            // TempTrackingSpecification2.SetSourceFilter2('', 0);
            IF TempTrackingSpecification2.ISEMPTY THEN
                ReserveSalesLine.TransferSalesLineToItemJnlLine(
                  SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, FALSE)
            ELSE BEGIN
                ReserveSalesLine.SetOverruleItemTracking(TRUE);
                ReserveSalesLine.SetItemTrkgAlreadyOverruled(ItemTrkgAlreadyOverruled);
                TempTrackingSpecification2.FINDSET;
                IF TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
                    ERROR(ItemTrackingWrongSignErr);
                REPEAT
                    ItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecification2);
                    ItemJnlLine."Applies-to Entry" := TempTrackingSpecification2."Item Ledger Entry No.";
                    RemainingQuantity :=
                      ReserveSalesLine.TransferSalesLineToItemJnlLine(
                        SalesOrderLine, ItemJnlLine, TempTrackingSpecification2."Quantity (Base)", CheckApplFromItemEntry, FALSE);
                    IF RemainingQuantity <> 0 THEN
                        ERROR(ItemTrackingMismatchErr);
                UNTIL TempTrackingSpecification2.NEXT = 0;
                ItemJnlLine.ClearTracking;
                ItemJnlLine."Applies-to Entry" := 0;
            END;
        END;
    END;

    LOCAL PROCEDURE TransferReservFromPurchLine(VAR PurchOrderLine: Record 39; VAR ItemJnlLine: Record 83; SalesLine: Record 37; QtyToBeShippedBase: Decimal);
    VAR
        ReservEntry: Record 337;
        TempTrackingSpecification2: Record 336 TEMPORARY;
        ReservePurchLine: Codeunit 99000834;
        RemainingQuantity: Decimal;
        CheckApplToItemEntry: Boolean;
    BEGIN
        // Handle Item Tracking on Drop Shipment
        ItemTrkgAlreadyOverruled := FALSE;
        IF QtyToBeShippedBase = 0 THEN
            EXIT;

        ReservEntry.SetSourceFilter(
          DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", TRUE);
        // ReservEntry.SetSourceFilter2('', 0);
        ReservEntry.SETFILTER("Qty. to Handle (Base)", '<>0');
        IF NOT ReservEntry.ISEMPTY THEN
            ItemTrackingMgt.SumUpItemTracking(ReservEntry, TempTrackingSpecification2, FALSE, TRUE);
        TempTrackingSpecification2.SETFILTER("Qty. to Handle (Base)", '<>0');
        IF TempTrackingSpecification2.ISEMPTY THEN BEGIN
            ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
            ReservePurchLine.TransferPurchLineToItemJnlLine(
              PurchOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplToItemEntry)
        END ELSE BEGIN
            ReservePurchLine.SetOverruleItemTracking(TRUE);
            ItemTrkgAlreadyOverruled := TRUE;
            TempTrackingSpecification2.FINDSET;
            IF -TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
                ERROR(ItemTrackingWrongSignErr);
            IF ReservePurchLine.ReservEntryExist(PurchOrderLine) THEN
                REPEAT
                    ItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecification2);
                    RemainingQuantity :=
                      ReservePurchLine.TransferPurchLineToItemJnlLine(
                        PurchOrderLine, ItemJnlLine,
                        -TempTrackingSpecification2."Qty. to Handle (Base)", CheckApplToItemEntry);
                    IF RemainingQuantity <> 0 THEN
                        ERROR(ItemTrackingMismatchErr);
                UNTIL TempTrackingSpecification2.NEXT = 0;
            ItemJnlLine.ClearTracking;
            ItemJnlLine."Applies-to Entry" := 0;
        END;
    END;


    PROCEDURE GetItem(SalesLine: Record 37);
    BEGIN
        WITH SalesLine DO BEGIN
            TESTFIELD(Type, Type::Item);
            TESTFIELD("No.");
            IF "No." <> Item."No." THEN
                Item.GET("No.");
        END;
    END;

    LOCAL PROCEDURE CreatePrepaymentLines(SalesHeader: Record 36; CompleteFunctionality: Boolean);
    VAR
        GLAcc: Record 15;
        TempSalesLine: Record 37 TEMPORARY;
        TempExtTextLine: Record 280 TEMPORARY;
        GenPostingSetup: Record 252;
        TempPrepmtSalesLine: Record 37 TEMPORARY;
        TransferExtText: Codeunit 378;
        NextLineNo: Integer;
        Fraction: Decimal;
        VATDifference: Decimal;
        TempLineFound: Boolean;
        PrepmtAmtToDeduct: Decimal;
    BEGIN
        GetGLSetup;
        WITH TempSalesLine DO BEGIN
            FillTempLines(SalesHeader, TempSalesLineGlobal);
            ResetTempLines(TempSalesLine);
            IF NOT FINDLAST THEN
                EXIT;
            NextLineNo := "Line No." + 10000;
            SETFILTER(Quantity, '>0');
            SETFILTER("Qty. to Invoice", '>0');
            TempPrepmtSalesLine.SetHasBeenShown;
            IF FINDSET THEN BEGIN
                IF CompleteFunctionality AND ("Document Type" = "Document Type"::Invoice) THEN
                    TestGetShipmentPPmtAmtToDeduct;
                REPEAT
                    IF CompleteFunctionality THEN
                        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN BEGIN
                            IF NOT SalesHeader.Ship AND ("Qty. to Invoice" = Quantity - "Quantity Invoiced") THEN
                                IF "Qty. Shipped Not Invoiced" < "Qty. to Invoice" THEN
                                    VALIDATE("Qty. to Invoice", "Qty. Shipped Not Invoiced");
                            Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

                            IF "Prepayment %" <> 100 THEN
                                CASE TRUE OF
                                    ("Prepmt Amt to Deduct" <> 0) AND
                                  ("Prepmt Amt to Deduct" > ROUND(Fraction * "Line Amount", Currency."Amount Rounding Precision")):
                                        FIELDERROR(
                                          "Prepmt Amt to Deduct",
                                          STRSUBSTNO(CannotBeGreaterThanErr,
                                            ROUND(Fraction * "Line Amount", Currency."Amount Rounding Precision")));
                                    ("Prepmt. Amt. Inv." <> 0) AND
                                  (ROUND((1 - Fraction) * "Line Amount", Currency."Amount Rounding Precision") <
                                   ROUND(
                                     ROUND(
                                       ROUND("Unit Price" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
                                         Currency."Amount Rounding Precision") *
                                       (1 - ("Line Discount %" / 100)), Currency."Amount Rounding Precision") *
                                     "Prepayment %" / 100, Currency."Amount Rounding Precision")):
                                        FIELDERROR(
                                          "Prepmt Amt to Deduct",
                                          STRSUBSTNO(CannotBeSmallerThanErr,
                                            ROUND(
                                              "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
                                              Currency."Amount Rounding Precision")));
                                END;
                        END;
                    IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
                        IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                           ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                        THEN
                            GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        GLAcc.GET(GenPostingSetup.GetSalesPrepmtAccount);
                        TempLineFound := FALSE;
                        IF SalesHeader."Compress Prepayment" THEN BEGIN
                            TempPrepmtSalesLine.SETRANGE("No.", GLAcc."No.");
                            TempPrepmtSalesLine.SETRANGE("Dimension Set ID", "Dimension Set ID");
                            TempLineFound := TempPrepmtSalesLine.FINDFIRST;
                        END;
                        IF TempLineFound THEN BEGIN
                            PrepmtAmtToDeduct :=
                              TempPrepmtSalesLine."Prepmt Amt to Deduct" +
                              InsertedPrepmtVATBaseToDeduct(
                                SalesHeader, TempSalesLine, TempPrepmtSalesLine."Line No.", TempPrepmtSalesLine."Unit Price");
                            VATDifference := TempPrepmtSalesLine."VAT Difference";
                            TempPrepmtSalesLine.VALIDATE(
                              "Unit Price", TempPrepmtSalesLine."Unit Price" + "Prepmt Amt to Deduct");
                            TempPrepmtSalesLine.VALIDATE("VAT Difference", VATDifference - "Prepmt VAT Diff. to Deduct");
                            TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                            IF "Prepayment %" < TempPrepmtSalesLine."Prepayment %" THEN
                                TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
                            OnBeforeTempPrepmtSalesLineModify(TempPrepmtSalesLine, TempSalesLine, SalesHeader, CompleteFunctionality);
                            TempPrepmtSalesLine.MODIFY;
                        END ELSE BEGIN
                            TempPrepmtSalesLine.INIT;
                            TempPrepmtSalesLine."Document Type" := SalesHeader."Document Type";
                            TempPrepmtSalesLine."Document No." := SalesHeader."No.";
                            TempPrepmtSalesLine."Line No." := 0;
                            TempPrepmtSalesLine."System-Created Entry" := TRUE;
                            IF CompleteFunctionality THEN
                                TempPrepmtSalesLine.VALIDATE(Type, TempPrepmtSalesLine.Type::"G/L Account")
                            ELSE
                                TempPrepmtSalesLine.Type := TempPrepmtSalesLine.Type::"G/L Account";
                            TempPrepmtSalesLine.VALIDATE("No.", GenPostingSetup."Sales Prepayments Account");
                            TempPrepmtSalesLine.VALIDATE(Quantity, -1);
                            TempPrepmtSalesLine."Qty. to Ship" := TempPrepmtSalesLine.Quantity;
                            TempPrepmtSalesLine."Qty. to Invoice" := TempPrepmtSalesLine.Quantity;
                            PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(SalesHeader, TempSalesLine, NextLineNo, 0);
                            TempPrepmtSalesLine.VALIDATE("Unit Price", "Prepmt Amt to Deduct");
                            TempPrepmtSalesLine.VALIDATE("VAT Difference", -"Prepmt VAT Diff. to Deduct");
                            TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                            TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
                            TempPrepmtSalesLine."Prepayment Line" := TRUE;
                            TempPrepmtSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            TempPrepmtSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            TempPrepmtSalesLine."Dimension Set ID" := "Dimension Set ID";
                            TempPrepmtSalesLine."Line No." := NextLineNo;
                            NextLineNo := NextLineNo + 10000;
                            OnBeforeTempPrepmtSalesLineInsert(TempPrepmtSalesLine, TempSalesLine, SalesHeader, CompleteFunctionality);
                            TempPrepmtSalesLine.INSERT;

                            TransferExtText.PrepmtGetAnyExtText(
                              TempPrepmtSalesLine."No.", DATABASE::"Sales Invoice Line",
                              SalesHeader."Document Date", SalesHeader."Language Code", TempExtTextLine);
                            IF TempExtTextLine.FIND('-') THEN
                                REPEAT
                                    TempPrepmtSalesLine.INIT;
                                    TempPrepmtSalesLine.Description := TempExtTextLine.Text;
                                    TempPrepmtSalesLine."System-Created Entry" := TRUE;
                                    TempPrepmtSalesLine."Prepayment Line" := TRUE;
                                    TempPrepmtSalesLine."Line No." := NextLineNo;
                                    NextLineNo := NextLineNo + 10000;
                                    TempPrepmtSalesLine.INSERT;
                                UNTIL TempExtTextLine.NEXT = 0;
                        END;
                    END;
                UNTIL NEXT = 0
            END;
        END;
        DividePrepmtAmountLCY(TempPrepmtSalesLine, SalesHeader);
        IF TempPrepmtSalesLine.FINDSET THEN
            REPEAT
                TempSalesLineGlobal := TempPrepmtSalesLine;
                TempSalesLineGlobal.INSERT;
            UNTIL TempPrepmtSalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertedPrepmtVATBaseToDeduct(SalesHeader: Record 36; SalesLine: Record 37; PrepmtLineNo: Integer; TotalPrepmtAmtToDeduct: Decimal): Decimal;
    VAR
        PrepmtVATBaseToDeduct: Decimal;
    BEGIN
        WITH SalesLine DO BEGIN
            IF SalesHeader."Prices Including VAT" THEN
                PrepmtVATBaseToDeduct :=
                  ROUND(
                    (TotalPrepmtAmtToDeduct + "Prepmt Amt to Deduct") / (1 + ("Prepayment VAT %" + "Prepayment EC %") / 100),
                    Currency."Amount Rounding Precision") -
                  ROUND(
                    TotalPrepmtAmtToDeduct / (1 + ("Prepayment VAT %" + "Prepayment EC %") / 100),
                    Currency."Amount Rounding Precision")
            ELSE
                PrepmtVATBaseToDeduct := "Prepmt Amt to Deduct";
        END;
        WITH TempPrepmtDeductLCYSalesLine DO BEGIN
            TempPrepmtDeductLCYSalesLine := SalesLine;
            IF "Document Type" = "Document Type"::Order THEN
                "Qty. to Invoice" := GetQtyToInvoice(SalesLine, SalesHeader.Ship)
            ELSE
                GetLineDataFromOrder(TempPrepmtDeductLCYSalesLine);
            IF ("Prepmt Amt to Deduct" = 0) OR ("Document Type" = "Document Type"::Invoice) THEN
                CalcPrepaymentToDeduct;
            "Line Amount" := GetLineAmountToHandleInclPrepmt("Qty. to Invoice");
            "Attached to Line No." := PrepmtLineNo;
            "VAT Base Amount" := PrepmtVATBaseToDeduct;
            INSERT;
        END;

        OnAfterInsertedPrepmtVATBaseToDeduct(
          SalesHeader, SalesLine, PrepmtLineNo, TotalPrepmtAmtToDeduct, TempPrepmtDeductLCYSalesLine, PrepmtVATBaseToDeduct);

        EXIT(PrepmtVATBaseToDeduct);
    END;

    LOCAL PROCEDURE DividePrepmtAmountLCY(VAR PrepmtSalesLine: Record 37; SalesHeader: Record 36);
    VAR
        CurrExchRate: Record 330;
        ActualCurrencyFactor: Decimal;
    BEGIN
        WITH PrepmtSalesLine DO BEGIN
            RESET;
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    IF SalesHeader."Currency Code" <> '' THEN
                        ActualCurrencyFactor :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              SalesHeader."Posting Date",
                              SalesHeader."Currency Code",
                              "Prepmt Amt to Deduct",
                              SalesHeader."Currency Factor")) /
                          "Prepmt Amt to Deduct"
                    ELSE
                        ActualCurrencyFactor := 1;

                    UpdatePrepmtAmountInvBuf("Line No.", ActualCurrencyFactor);
                UNTIL NEXT = 0;
            RESET;
        END;
    END;

    LOCAL PROCEDURE UpdatePrepmtAmountInvBuf(PrepmtSalesLineNo: Integer; CurrencyFactor: Decimal);
    VAR
        PrepmtAmtRemainder: Decimal;
    BEGIN
        WITH TempPrepmtDeductLCYSalesLine DO BEGIN
            RESET;
            SETRANGE("Attached to Line No.", PrepmtSalesLineNo);
            IF FINDSET(TRUE) THEN
                REPEAT
                    "Prepmt. Amount Inv. (LCY)" :=
                      CalcRoundedAmount(CurrencyFactor * "VAT Base Amount", PrepmtAmtRemainder);
                    MODIFY;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE AdjustPrepmtAmountLCY(SalesHeader: Record 36; VAR PrepmtSalesLine: Record 37);
    VAR
        SalesLine: Record 37;
        SalesInvoiceLine: Record 37;
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: ARRAY[2] OF Decimal;
        TotalPrepmtAmount: ARRAY[2] OF Decimal;
        FinalInvoice: Boolean;
        PricesInclVATRoundingAmount: ARRAY[2] OF Decimal;
    BEGIN
        IF PrepmtSalesLine."Prepayment Line" THEN BEGIN
            PrepmtVATPart :=
              (PrepmtSalesLine."Amount Including VAT" - PrepmtSalesLine.Amount) / PrepmtSalesLine."Unit Price";

            WITH TempPrepmtDeductLCYSalesLine DO BEGIN
                RESET;
                SETRANGE("Attached to Line No.", PrepmtSalesLine."Line No.");
                IF FINDSET(TRUE) THEN BEGIN
                    FinalInvoice := IsFinalInvoice;
                    REPEAT
                        SalesLine := TempPrepmtDeductLCYSalesLine;
                        SalesLine.FIND;
                        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                            SalesInvoiceLine := SalesLine;
                            GetSalesOrderLine(SalesLine, SalesInvoiceLine);
                            SalesLine."Qty. to Invoice" := SalesInvoiceLine."Qty. to Invoice";
                        END;
                        IF SalesLine."Qty. to Invoice" <> "Qty. to Invoice" THEN
                            SalesLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(SalesLine, SalesHeader.Ship);
                        DeductionFactor :=
                          SalesLine."Prepmt Amt to Deduct" /
                          (SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");

                        "Prepmt. VAT Amount Inv. (LCY)" :=
                          CalcRoundedAmount(SalesLine."Prepmt Amt to Deduct" * PrepmtVATPart, PrepmtVATAmtRemainder);
                        IF ("Prepayment %" <> 100) OR IsFinalInvoice OR ("Currency Code" <> '') THEN
                            CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYSalesLine, SalesLine, DeductionFactor, TotalRoundingAmount);
                        MODIFY;

                        IF SalesHeader."Prices Including VAT" THEN
                            IF (("Prepayment %" <> 100) OR IsFinalInvoice) AND (DeductionFactor = 1) THEN BEGIN
                                PricesInclVATRoundingAmount[1] := TotalRoundingAmount[1];
                                PricesInclVATRoundingAmount[2] := TotalRoundingAmount[2];
                            END;

                        IF "VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT" THEN
                            TotalPrepmtAmount[1] += "Prepmt. Amount Inv. (LCY)";
                        TotalPrepmtAmount[2] += "Prepmt. VAT Amount Inv. (LCY)";
                        FinalInvoice := FinalInvoice AND IsFinalInvoice;
                    UNTIL NEXT = 0;
                END;
            END;

            UpdatePrepmtSalesLineWithRounding(
              PrepmtSalesLine, TotalRoundingAmount, TotalPrepmtAmount,
              FinalInvoice, PricesInclVATRoundingAmount);
        END;
    END;

    LOCAL PROCEDURE CalcPrepmtAmtToDeduct(SalesLine: Record 37; Ship: Boolean): Decimal;
    BEGIN
        WITH SalesLine DO BEGIN
            "Qty. to Invoice" := GetQtyToInvoice(SalesLine, Ship);
            CalcPrepaymentToDeduct;
            EXIT("Prepmt Amt to Deduct");
        END;
    END;

    LOCAL PROCEDURE GetQtyToInvoice(SalesLine: Record 37; Ship: Boolean): Decimal;
    VAR
        AllowedQtyToInvoice: Decimal;
    BEGIN
        WITH SalesLine DO BEGIN
            AllowedQtyToInvoice := "Qty. Shipped Not Invoiced";
            IF Ship THEN
                AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Ship";
            IF "Qty. to Invoice" > AllowedQtyToInvoice THEN
                EXIT(AllowedQtyToInvoice);
            EXIT("Qty. to Invoice");
        END;
    END;

    LOCAL PROCEDURE GetLineDataFromOrder(VAR SalesLine: Record 37);
    VAR
        SalesShptLine: Record 111;
        SalesOrderLine: Record 37;
    BEGIN
        WITH SalesLine DO BEGIN
            SalesShptLine.GET("Shipment No.", "Shipment Line No.");
            SalesOrderLine.GET("Document Type"::Order, SalesShptLine."Order No.", SalesShptLine."Order Line No.");

            Quantity := SalesOrderLine.Quantity;
            "Qty. Shipped Not Invoiced" := SalesOrderLine."Qty. Shipped Not Invoiced";
            "Quantity Invoiced" := SalesOrderLine."Quantity Invoiced";
            "Prepmt Amt Deducted" := SalesOrderLine."Prepmt Amt Deducted";
            "Prepmt. Amt. Inv." := SalesOrderLine."Prepmt. Amt. Inv.";
            "Line Discount Amount" := SalesOrderLine."Line Discount Amount";
        END;
    END;

    LOCAL PROCEDURE CalcPrepmtRoundingAmounts(VAR PrepmtSalesLineBuf: Record 37; SalesLine: Record 37; DeductionFactor: Decimal; VAR TotalRoundingAmount: ARRAY[2] OF Decimal);
    VAR
        RoundingAmount: ARRAY[2] OF Decimal;
    BEGIN
        WITH PrepmtSalesLineBuf DO BEGIN
            IF "VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT" THEN BEGIN
                RoundingAmount[1] :=
                  "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. Amount Inv. (LCY)");
                "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
                TotalRoundingAmount[1] += RoundingAmount[1];
            END;
            RoundingAmount[2] :=
              "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. VAT Amount Inv. (LCY)");
            "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
            TotalRoundingAmount[2] += RoundingAmount[2];
        END;
    END;

    LOCAL PROCEDURE UpdatePrepmtSalesLineWithRounding(VAR PrepmtSalesLine: Record 37; TotalRoundingAmount: ARRAY[2] OF Decimal; TotalPrepmtAmount: ARRAY[2] OF Decimal; FinalInvoice: Boolean; PricesInclVATRoundingAmount: ARRAY[2] OF Decimal);
    VAR
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
        AmountRoundingPrecision: Decimal;
    BEGIN
        OnBeforeUpdatePrepmtSalesLineWithRounding(
          PrepmtSalesLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice, PricesInclVATRoundingAmount,
          TotalSalesLine, TotalSalesLineLCY);

        WITH PrepmtSalesLine DO BEGIN
            NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
            IF "Prepayment %" = 100 THEN
                TotalRoundingAmount[1] += "Amount Including VAT" - NewAmountIncludingVAT;
            AmountRoundingPrecision :=
              GetAmountRoundingPrecisionInLCY("Document Type", "Document No.", "Currency Code");//enum to option

            IF (ABS(TotalRoundingAmount[1]) <= AmountRoundingPrecision) AND
               (ABS(TotalRoundingAmount[2]) <= AmountRoundingPrecision)
            THEN BEGIN
                IF "Prepayment %" = 100 THEN
                    Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
                TotalRoundingAmount[1] := 0;
            END;
            "Prepmt. Amount Inv. (LCY)" := TotalRoundingAmount[1];
            Amount := TotalPrepmtAmount[1] + TotalRoundingAmount[1];

            IF (PricesInclVATRoundingAmount[1] <> 0) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
                IF ("Prepayment %" = 100) AND FinalInvoice AND
                   (Amount + TotalPrepmtAmount[2] = "Amount Including VAT")
                THEN
                    Prepmt100PctVATRoundingAmt := 0;
                PricesInclVATRoundingAmount[1] := 0;
            END;

            IF ((TotalRoundingAmount[2] <> 0) OR FinalInvoice) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
                IF ("Prepayment %" = 100) AND ("Prepmt. Amount Inv. (LCY)" = 0) THEN
                    Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
                IF ("Prepayment %" = 100) OR FinalInvoice THEN
                    TotalRoundingAmount[2] := 0;
            END;

            IF (PricesInclVATRoundingAmount[2] <> 0) AND (TotalRoundingAmount[2] = 0) THEN BEGIN
                IF ABS(Prepmt100PctVATRoundingAmt) <= AmountRoundingPrecision THEN
                    Prepmt100PctVATRoundingAmt := 0;
                PricesInclVATRoundingAmount[2] := 0;
            END;

            "Prepmt. VAT Amount Inv. (LCY)" := TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt;
            NewAmountIncludingVAT := Amount + TotalPrepmtAmount[2] + TotalRoundingAmount[2];
            IF (PricesInclVATRoundingAmount[1] = 0) AND (PricesInclVATRoundingAmount[2] = 0) OR
               ("Currency Code" <> '') AND FinalInvoice
            THEN
                Increment(
                  TotalSalesLineLCY."Amount Including VAT",
                  "Amount Including VAT" - NewAmountIncludingVAT - Prepmt100PctVATRoundingAmt);
            IF "Currency Code" = '' THEN
                TotalSalesLine."Amount Including VAT" := TotalSalesLineLCY."Amount Including VAT";
            "Amount Including VAT" := NewAmountIncludingVAT;

            IF FinalInvoice AND (TotalSalesLine.Amount = 0) AND (TotalSalesLine."Amount Including VAT" <> 0) AND
               (ABS(TotalSalesLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
            THEN BEGIN
                "Amount Including VAT" += TotalSalesLineLCY."Amount Including VAT";
                TotalSalesLine."Amount Including VAT" := 0;
                TotalSalesLineLCY."Amount Including VAT" := 0;
            END;
        END;

        OnAfterUpdatePrepmtSalesLineWithRounding(
          PrepmtSalesLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice, PricesInclVATRoundingAmount,
          TotalSalesLine, TotalSalesLineLCY);
    END;

    LOCAL PROCEDURE CalcRoundedAmount(Amount: Decimal; VAR Remainder: Decimal): Decimal;
    VAR
        AmountRnded: Decimal;
    BEGIN
        Amount := Amount + Remainder;
        AmountRnded := ROUND(Amount, GLSetup."Amount Rounding Precision");
        Remainder := Amount - AmountRnded;
        EXIT(AmountRnded);
    END;

    LOCAL PROCEDURE GetSalesOrderLine(VAR SalesOrderLine: Record 37; SalesLine: Record 37);
    VAR
        SalesShptLine: Record 111;
    BEGIN
        SalesShptLine.GET(SalesLine."Shipment No.", SalesLine."Shipment Line No.");
        SalesOrderLine.GET(
          SalesOrderLine."Document Type"::Order,
          SalesShptLine."Order No.", SalesShptLine."Order Line No.");
        SalesOrderLine."Prepmt Amt to Deduct" := SalesLine."Prepmt Amt to Deduct";
    END;

    LOCAL PROCEDURE DecrementPrepmtAmtInvLCY(SalesLine: Record 37; VAR PrepmtAmountInvLCY: Decimal; VAR PrepmtVATAmountInvLCY: Decimal);
    BEGIN
        TempPrepmtDeductLCYSalesLine.RESET;
        TempPrepmtDeductLCYSalesLine := SalesLine;
        IF TempPrepmtDeductLCYSalesLine.FIND THEN BEGIN
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
            PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
        END;
    END;

    LOCAL PROCEDURE AdjustFinalInvWith100PctPrepmt(VAR CombinedSalesLine: Record 37);
    VAR
        DiffToLineDiscAmt: Decimal;
    BEGIN
        WITH TempPrepmtDeductLCYSalesLine DO BEGIN
            RESET;
            SETRANGE("Prepayment %", 100);
            IF FINDSET(TRUE) THEN
                REPEAT
                    IF IsFinalInvoice THEN BEGIN
                        DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
                        IF "Document Type" = "Document Type"::Order THEN
                            DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
                        IF DiffToLineDiscAmt <> 0 THEN BEGIN
                            CombinedSalesLine.GET("Document Type", "Document No.", "Line No.");
                            "Line Discount Amount" := CombinedSalesLine."Line Discount Amount" - DiffToLineDiscAmt;
                            MODIFY;
                        END;
                    END;
                UNTIL NEXT = 0;
            RESET;
        END;
    END;

    LOCAL PROCEDURE GetPrepmtDiffToLineAmount(SalesLine: Record 37): Decimal;
    BEGIN
        WITH TempPrepmtDeductLCYSalesLine DO
            IF SalesLine."Prepayment %" = 100 THEN
                IF GET(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") THEN
                    EXIT("Prepmt Amt to Deduct" + "Inv. Discount Amount" - "Line Amount");
        EXIT(0);
    END;

    LOCAL PROCEDURE PostJobContractLine(SalesHeader: Record 36; SalesLine: Record 37);
    BEGIN
        IF SalesLine."Job Contract Entry No." = 0 THEN
            EXIT;
        IF (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) AND
           (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo")
        THEN
            SalesLine.TESTFIELD("Job Contract Entry No.", 0);

        SalesLine.TESTFIELD("Job No.");
        SalesLine.TESTFIELD("Job Task No.");

        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
            SalesLine."Document No." := SalesInvHeader."No.";
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
            SalesLine."Document No." := SalesCrMemoHeader."No.";
        JobContractLine := TRUE;
        JobPostLine.PostInvoiceContractLine(SalesHeader, SalesLine);
    END;

    LOCAL PROCEDURE InsertICGenJnlLine(SalesHeader: Record 36; SalesLine: Record 37; VAR ICGenJnlLineNo: Integer);
    VAR
        ICGLAccount: Record 410;
        Vend: Record 23;
        ICPartner: Record 413;
        CurrExchRate: Record 330;
        GenJnlLine: Record 81;
    BEGIN
        SalesHeader.TESTFIELD("Sell-to IC Partner Code", '');
        SalesHeader.TESTFIELD("Bill-to IC Partner Code", '');
        SalesLine.TESTFIELD("IC Partner Ref. Type", SalesLine."IC Partner Ref. Type"::"G/L Account");
        ICGLAccount.GET(SalesLine."IC Partner Reference");
        ICGenJnlLineNo := ICGenJnlLineNo + 1;

        WITH TempICGenJnlLine DO BEGIN
            InitNewLine(
              SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
              SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code", SalesLine."Dimension Set ID",
              SalesHeader."Reason Code");
            "Line No." := ICGenJnlLineNo;

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType), GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series");

            VALIDATE("Account Type", "Account Type"::"IC Partner");
            VALIDATE("Account No.", SalesLine."IC Partner Code");
            "Source Currency Code" := SalesHeader."Currency Code";
            "Source Currency Amount" := Amount;
            Correction := SalesHeader.Correction;
            "Country/Region Code" := SalesHeader."VAT Country/Region Code";
            "Source Type" := GenJnlLine."Source Type"::Customer;
            "Source No." := SalesHeader."Bill-to Customer No.";
            "Source Line No." := SalesLine."Line No.";
            VALIDATE("Bal. Account Type", "Bal. Account Type"::"G/L Account");
            VALIDATE("Bal. Account No.", SalesLine."No.");
            "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := SalesLine."Dimension Set ID";

            Vend.SETRANGE("IC Partner Code", SalesLine."IC Partner Code");
            IF Vend.FINDFIRST THEN BEGIN
                VALIDATE("Bal. Gen. Bus. Posting Group", Vend."Gen. Bus. Posting Group");
                VALIDATE("Bal. VAT Bus. Posting Group", Vend."VAT Bus. Posting Group");
            END;
            VALIDATE("Bal. VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
            "IC Partner Code" := SalesLine."IC Partner Code";
            "IC Partner G/L Acc. No." := SalesLine."IC Partner Reference";
            "IC Direction" := "IC Direction"::Outgoing;
            ICPartner.GET(SalesLine."IC Partner Code");
            IF ICPartner."Cost Distribution in LCY" AND (SalesLine."Currency Code" <> '') THEN BEGIN
                "Currency Code" := '';
                "Currency Factor" := 0;
                Currency.GET(SalesLine."Currency Code");
                IF SalesHeader.IsCreditDocType THEN
                    Amount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          SalesHeader."Posting Date", SalesLine."Currency Code",
                          SalesLine.Amount, SalesHeader."Currency Factor"))
                ELSE
                    Amount :=
                      -ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          SalesHeader."Posting Date", SalesLine."Currency Code",
                          SalesLine.Amount, SalesHeader."Currency Factor"));
            END ELSE BEGIN
                Currency.InitRoundingPrecision;
                "Currency Code" := SalesHeader."Currency Code";
                "Currency Factor" := SalesHeader."Currency Factor";
                IF SalesHeader.IsCreditDocType THEN
                    Amount := SalesLine.Amount
                ELSE
                    Amount := -SalesLine.Amount;
            END;
            IF "Bal. VAT %" <> 0 THEN
                Amount := ROUND(Amount * (1 + "Bal. VAT %" / 100), Currency."Amount Rounding Precision");
            VALIDATE(Amount);
            OnBeforeInsertICGenJnlLine(TempICGenJnlLine, SalesHeader, SalesLine, SuppressCommit);
            INSERT;
        END;
    END;

    LOCAL PROCEDURE PostICGenJnl();
    VAR
        ICInOutBoxMgt: Codeunit 427;
        ICOutboxExport: Codeunit 431;
        ICTransactionNo: Integer;
    BEGIN
        TempICGenJnlLine.RESET;
        TempICGenJnlLine.SETFILTER(Amount, '<>%1', 0);
        IF TempICGenJnlLine.FIND('-') THEN
            REPEAT
                ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine, FALSE);
                ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo, 1, TempICGenJnlLine);
                ICOutboxExport.ProcessAutoSendOutboxTransactionNo(ICTransactionNo);
                GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
            UNTIL TempICGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TestGetShipmentPPmtAmtToDeduct();
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        TempShippedSalesLine: Record 37 TEMPORARY;
        TempTotalSalesLine: Record 37 TEMPORARY;
        TempSalesShptLine: Record 111 TEMPORARY;
        SalesShptLine: Record 111;
        SalesOrderLine: Record 37;
        MaxAmtToDeduct: Decimal;
    BEGIN
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            SETFILTER(Quantity, '>0');
            SETFILTER("Qty. to Invoice", '>0');
            SETFILTER("Shipment No.", '<>%1', '');
            SETFILTER("Prepmt Amt to Deduct", '<>0');
            IF ISEMPTY THEN
                EXIT;

            SETRANGE("Prepmt Amt to Deduct");
            IF FINDSET THEN
                REPEAT
                    IF SalesShptLine.GET("Shipment No.", "Shipment Line No.") THEN BEGIN
                        TempShippedSalesLine := TempSalesLine;
                        TempShippedSalesLine.INSERT;
                        TempSalesShptLine := SalesShptLine;
                        IF TempSalesShptLine.INSERT THEN;

                        IF NOT TempTotalSalesLine.GET("Document Type"::Order, SalesShptLine."Order No.", SalesShptLine."Order Line No.") THEN BEGIN
                            TempTotalSalesLine.INIT;
                            TempTotalSalesLine."Document Type" := "Document Type"::Order;
                            TempTotalSalesLine."Document No." := SalesShptLine."Order No.";
                            TempTotalSalesLine."Line No." := SalesShptLine."Order Line No.";
                            TempTotalSalesLine.INSERT;
                        END;
                        TempTotalSalesLine."Qty. to Invoice" := TempTotalSalesLine."Qty. to Invoice" + "Qty. to Invoice";
                        TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + "Prepmt Amt to Deduct";
                        AdjustInvLineWith100PctPrepmt(TempSalesLine, TempTotalSalesLine);
                        TempTotalSalesLine.MODIFY;
                    END;
                UNTIL NEXT = 0;

            IF TempShippedSalesLine.FINDSET THEN
                REPEAT
                    IF TempSalesShptLine.GET(TempShippedSalesLine."Shipment No.", TempShippedSalesLine."Shipment Line No.") THEN
                        IF SalesOrderLine.GET(
                             TempShippedSalesLine."Document Type"::Order, TempSalesShptLine."Order No.", TempSalesShptLine."Order Line No.")
                        THEN
                            IF TempTotalSalesLine.GET(
                                 TempShippedSalesLine."Document Type"::Order, TempSalesShptLine."Order No.", TempSalesShptLine."Order Line No.")
                            THEN BEGIN
                                MaxAmtToDeduct := SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted";

                                IF TempTotalSalesLine."Prepmt Amt to Deduct" > MaxAmtToDeduct THEN
                                    ERROR(PrepAmountToDeductToBigErr, FIELDCAPTION("Prepmt Amt to Deduct"), MaxAmtToDeduct);

                                IF (TempTotalSalesLine."Qty. to Invoice" = SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced") AND
                                   (TempTotalSalesLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                                THEN
                                    ERROR(PrepAmountToDeductToSmallErr, FIELDCAPTION("Prepmt Amt to Deduct"), MaxAmtToDeduct);
                            END;
                UNTIL TempShippedSalesLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE AdjustInvLineWith100PctPrepmt(VAR SalesInvoiceLine: Record 37; VAR TempTotalSalesLine: Record 37 TEMPORARY);
    VAR
        SalesOrderLine: Record 37;
        DiffAmtToDeduct: Decimal;
    BEGIN
        IF SalesInvoiceLine."Prepayment %" = 100 THEN BEGIN
            SalesOrderLine := TempTotalSalesLine;
            SalesOrderLine.FIND;
            IF TempTotalSalesLine."Qty. to Invoice" = SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced" THEN BEGIN
                DiffAmtToDeduct :=
                  SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted" - TempTotalSalesLine."Prepmt Amt to Deduct";
                IF DiffAmtToDeduct <> 0 THEN BEGIN
                    SalesInvoiceLine."Prepmt Amt to Deduct" := SalesInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
                    SalesInvoiceLine."Line Amount" := SalesInvoiceLine."Prepmt Amt to Deduct";
                    SalesInvoiceLine."Line Discount Amount" := SalesInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
                    ModifyTempLine(SalesInvoiceLine);
                    TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
                END;
            END;
        END;
    END;

    //[External]
    PROCEDURE ArchiveUnpostedOrder(SalesHeader: Record 36);
    VAR
        SalesLine: Record 37;
        ArchiveManagement: Codeunit 5063;
    BEGIN
        SalesSetup.GET;
        IF NOT (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) THEN
            EXIT;

        SalesSetup.GET;
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND NOT SalesSetup."Archive Orders" THEN
            EXIT;
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") AND NOT SalesSetup."Archive Return Orders" THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER(Quantity, '<>0');
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
            SalesLine.SETFILTER("Qty. to Ship", '<>0')
        ELSE
            SalesLine.SETFILTER("Return Qty. to Receive", '<>0');
        IF NOT SalesLine.ISEMPTY AND NOT PreviewMode THEN BEGIN
            RoundDeferralsForArchive(SalesHeader, SalesLine);
            ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
        END;
    END;

    LOCAL PROCEDURE SynchBOMSerialNo(VAR ServItemTmp3: Record 5940 TEMPORARY; VAR ServItemTmpCmp3: Record 5941 TEMPORARY);
    VAR
        ItemLedgEntry: Record 32;
        ItemLedgEntry2: Record 32;
        TempSalesShipMntLine: Record 111 TEMPORARY;
        ServItemTmpCmp4: Record 5941 TEMPORARY;
        ServItemCompLocal: Record 5941;
        TempItemLedgEntry2: Record 32 TEMPORARY;
        ChildCount: Integer;
        EndLoop: Boolean;
    BEGIN
        IF NOT ServItemTmpCmp3.FIND('-') THEN
            EXIT;

        IF NOT ServItemTmp3.FIND('-') THEN
            EXIT;

        TempSalesShipMntLine.DELETEALL;
        REPEAT
            CLEAR(TempSalesShipMntLine);
            TempSalesShipMntLine."Document No." := ServItemTmp3."Sales/Serv. Shpt. Document No.";
            TempSalesShipMntLine."Line No." := ServItemTmp3."Sales/Serv. Shpt. Line No.";
            IF TempSalesShipMntLine.INSERT THEN;
        UNTIL ServItemTmp3.NEXT = 0;

        IF NOT TempSalesShipMntLine.FIND('-') THEN
            EXIT;

        ServItemTmp3.SETCURRENTKEY("Sales/Serv. Shpt. Document No.", "Sales/Serv. Shpt. Line No.");
        CLEAR(ItemLedgEntry);
        ItemLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");

        REPEAT
            ChildCount := 0;
            ServItemTmpCmp4.DELETEALL;
            ServItemTmp3.SETRANGE("Sales/Serv. Shpt. Document No.", TempSalesShipMntLine."Document No.");
            ServItemTmp3.SETRANGE("Sales/Serv. Shpt. Line No.", TempSalesShipMntLine."Line No.");
            IF ServItemTmp3.FIND('-') THEN
                REPEAT
                    ServItemTmpCmp3.SETRANGE(Active, TRUE);
                    ServItemTmpCmp3.SETRANGE("Parent Service Item No.", ServItemTmp3."No.");
                    IF ServItemTmpCmp3.FIND('-') THEN
                        REPEAT
                            ChildCount += 1;
                            ServItemTmpCmp4 := ServItemTmpCmp3;
                            ServItemTmpCmp4.INSERT;
                        UNTIL ServItemTmpCmp3.NEXT = 0;
                UNTIL ServItemTmp3.NEXT = 0;
            ItemLedgEntry.SETRANGE("Document No.", TempSalesShipMntLine."Document No.");
            ItemLedgEntry.SETRANGE("Document Type", ItemLedgEntry."Document Type"::"Sales Shipment");
            ItemLedgEntry.SETRANGE("Document Line No.", TempSalesShipMntLine."Line No.");
            IF ItemLedgEntry.FINDFIRST AND ServItemTmpCmp4.FIND('-') THEN BEGIN
                CLEAR(ItemLedgEntry2);
                ItemLedgEntry2.GET(ItemLedgEntry."Entry No.");
                EndLoop := FALSE;
                REPEAT
                    IF ItemLedgEntry2."Item No." = ServItemTmpCmp4."No." THEN
                        EndLoop := TRUE
                    ELSE
                        IF ItemLedgEntry2.NEXT = 0 THEN
                            EndLoop := TRUE;
                UNTIL EndLoop;
                ItemLedgEntry2.SETRANGE("Entry No.", ItemLedgEntry2."Entry No.", ItemLedgEntry2."Entry No." + ChildCount - 1);
                IF ItemLedgEntry2.FINDSET THEN
                    REPEAT
                        TempItemLedgEntry2 := ItemLedgEntry2;
                        TempItemLedgEntry2.INSERT;
                    UNTIL ItemLedgEntry2.NEXT = 0;
                REPEAT
                    IF ServItemCompLocal.GET(
                         ServItemTmpCmp4.Active,
                         ServItemTmpCmp4."Parent Service Item No.",
                         ServItemTmpCmp4."Line No.")
                    THEN BEGIN
                        TempItemLedgEntry2.SETRANGE("Item No.", ServItemCompLocal."No.");
                        IF TempItemLedgEntry2.FINDFIRST THEN BEGIN
                            ServItemCompLocal."Serial No." := TempItemLedgEntry2."Serial No.";
                            ServItemCompLocal.MODIFY;
                            TempItemLedgEntry2.DELETE;
                        END;
                    END;
                UNTIL ServItemTmpCmp4.NEXT = 0;
            END;
        UNTIL TempSalesShipMntLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE LockTables(VAR SalesHeader: Record 36);
    VAR
        SalesLine: Record 37;
        PurchOrderHeader: Record 38;
        PurchOrderLine: Record 39;
    BEGIN
        OnBeforeLockTables(SalesHeader, PreviewMode, SuppressCommit);

        SalesLine.LOCKTABLE;
        ItemChargeAssgntSales.LOCKTABLE;
        PurchOrderLine.LOCKTABLE;
        PurchOrderHeader.LOCKTABLE;
        GetGLSetup;
        IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
            GLEntry.LOCKTABLE;
            IF GLEntry.FINDLAST THEN;
        END;
    END;

    LOCAL PROCEDURE PostCustomerEntry(VAR SalesHeader: Record 36; TotalSalesLine2: Record 37; TotalSalesLineLCY2: Record 37; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]);
    VAR
        GenJnlLine: Record 81;
    BEGIN
        WITH GenJnlLine DO BEGIN
            InitNewLine(
              SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
              SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
              SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(DocType), DocNo, ExtDocNo, SourceCode, '');//option to enum
            "Account Type" := "Account Type"::Customer;
            "Account No." := SalesHeader."Bill-to Customer No.";
            CopyFromSalesHeader(SalesHeader);
            SetCurrencyFactor(SalesHeader."Currency Code", SalesHeader."Currency Factor");

            "System-Created Entry" := TRUE;

            CopyFromSalesHeaderApplyTo(SalesHeader);
            "Applies-to Bill No." := SalesHeader."Applies-to Bill No.";
            CopyFromSalesHeaderPayment(SalesHeader);

            Amount := -TotalSalesLine2."Amount Including VAT";
            "Source Currency Amount" := -TotalSalesLine2."Amount Including VAT";
            "Amount (LCY)" := -TotalSalesLineLCY2."Amount Including VAT";
            "Sales/Purch. (LCY)" := -TotalSalesLineLCY2.Amount;
            "Profit (LCY)" := -(TotalSalesLineLCY2.Amount - TotalSalesLineLCY2."Unit Cost (LCY)");
            "Inv. Discount (LCY)" := -TotalSalesLineLCY2."Inv. Discount Amount";
            "Pmt. Discount Given/Rec. (LCY)" := -TotalSalesLineLCY2."Pmt. Discount Amount";
            "Recipient Bank Account" := SalesHeader."Cust. Bank Acc. Code";
            "Sales Invoice Type" := SalesHeader."Invoice Type";
            "Sales Cr. Memo Type" := SalesHeader."Cr. Memo Type";
            "Sales Special Scheme Code" := SalesHeader."Special Scheme Code";
            "Correction Type" := SalesHeader."Correction Type";
            "Corrected Invoice No." := SalesHeader."Corrected Invoice No.";
            "Succeeded Company Name" := SalesHeader."Succeeded Company Name";
            "Succeeded VAT Registration No." := SalesHeader."Succeeded VAT Registration No.";
            "ID Type" := SalesHeader."ID Type";

            OnBeforePostCustomerEntry(GenJnlLine, SalesHeader, TotalSalesLine2, TotalSalesLineLCY2, SuppressCommit, PreviewMode);
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            OnAfterPostCustomerEntry(GenJnlLine, SalesHeader, TotalSalesLine2, TotalSalesLineLCY2, SuppressCommit, GenJnlPostLine);
        END;
    END;

    LOCAL PROCEDURE UpdateSalesHeader(VAR CustLedgerEntry: Record 21);
    VAR
        GenJnlLine: Record 81;
    BEGIN
        CASE GenJnlLineDocType OF
            GenJnlLine."Document Type"::Invoice.AsInteger():
                BEGIN
                    FindCustLedgEntry(GenJnlLineDocType, GenJnlLineDocNo, CustLedgerEntry);
                    SalesInvHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
                    SalesInvHeader.MODIFY;
                END;
            GenJnlLine."Document Type"::"Credit Memo".AsInteger():
                BEGIN
                    FindCustLedgEntry(GenJnlLineDocType, GenJnlLineDocNo, CustLedgerEntry);
                    SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
                    SalesCrMemoHeader.MODIFY;
                END;
        END;
    END;

    LOCAL PROCEDURE MakeSalesLineToShip(VAR SalesLineToShip: Record 37; SalesLineInvoiced: Record 37);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        ResetTempLines(TempSalesLine);
        TempSalesLine := SalesLineInvoiced;
        TempSalesLine.FIND;

        SalesLineToShip := SalesLineInvoiced;
        SalesLineToShip."Inv. Discount Amount" := TempSalesLine."Inv. Discount Amount";
    END;

    LOCAL PROCEDURE MAX(number1: Integer; number2: Integer): Integer;
    BEGIN
        IF number1 > number2 THEN
            EXIT(number1);
        EXIT(number2);
    END;

    LOCAL PROCEDURE PostBalancingEntry(SalesHeader: Record 36; TotalSalesLine2: Record 37; TotalSalesLineLCY2: Record 37; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]);
    VAR
        CustLedgEntry: Record 21;
        GenJnlLine: Record 81;
    BEGIN
        FindCustLedgEntry(DocType, DocNo, CustLedgEntry);

        WITH GenJnlLine DO BEGIN
            InitNewLine(
              SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
              SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
              SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(0), DocNo, ExtDocNo, SourceCode, '');
            "Account Type" := "Account Type"::Customer;
            "Account No." := SalesHeader."Bill-to Customer No.";
            CopyFromSalesHeader(SalesHeader);
            SetCurrencyFactor(SalesHeader."Currency Code", SalesHeader."Currency Factor");

            IF SalesHeader.IsCreditDocType THEN
                "Document Type" := "Document Type"::Refund
            ELSE
                "Document Type" := "Document Type"::Payment;

            SetApplyToDocNo(SalesHeader, GenJnlLine, DocType, DocNo);

            Amount := TotalSalesLine2."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";

            "Source Currency Amount" := Amount;
            CustLedgEntry.CALCFIELDS(Amount);
            IF CustLedgEntry.Amount = 0 THEN
                "Amount (LCY)" := TotalSalesLineLCY2."Amount Including VAT"
            ELSE
                "Amount (LCY)" :=
                  TotalSalesLineLCY2."Amount Including VAT" +
                  ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");
            "Allow Zero-Amount Posting" := TRUE;

            OnBeforePostBalancingEntry(GenJnlLine, SalesHeader, TotalSalesLine2, TotalSalesLineLCY2, SuppressCommit, PreviewMode);
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            OnAfterPostBalancingEntry(GenJnlLine, SalesHeader, TotalSalesLine2, TotalSalesLineLCY2, SuppressCommit, GenJnlPostLine);
        END;
    END;

    LOCAL PROCEDURE SetApplyToDocNo(SalesHeader: Record 36; VAR GenJnlLine: Record 81; DocType: Option; DocNo: Code[20]);
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF SalesHeader."Bal. Account Type" = SalesHeader."Bal. Account Type"::"Bank Account" THEN
                "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
            "Bal. Account No." := SalesHeader."Bal. Account No.";
            "Applies-to Doc. Type" := Enum::"Gen. Journal Document Type".FromInteger(DocType);//option to enum
            "Applies-to Doc. No." := DocNo;
        END;

        OnAfterSetApplyToDocNo(GenJnlLine, SalesHeader);
    END;

    LOCAL PROCEDURE FindCustLedgEntry(DocType: Option; DocNo: Code[20]; VAR CustLedgEntry: Record 21);
    BEGIN
        CustLedgEntry.SETRANGE("Document Type", DocType);
        CustLedgEntry.SETRANGE("Document No.", DocNo);
        CustLedgEntry.FINDLAST;
    END;

    LOCAL PROCEDURE ItemLedgerEntryExist(SalesLine2: Record 37; ShipOrReceive: Boolean): Boolean;
    VAR
        HasItemLedgerEntry: Boolean;
    BEGIN
        IF ShipOrReceive THEN
            // item ledger entry will be created during posting in this transaction
            HasItemLedgerEntry :=
          ((SalesLine2."Qty. to Ship" + SalesLine2."Quantity Shipped") <> 0) OR
          ((SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") <> 0) OR
          ((SalesLine2."Return Qty. to Receive" + SalesLine2."Return Qty. Received") <> 0)
        ELSE
            // item ledger entry must already exist
            HasItemLedgerEntry :=
          (SalesLine2."Quantity Shipped" <> 0) OR
          (SalesLine2."Return Qty. Received" <> 0);

        EXIT(HasItemLedgerEntry);
    END;

    LOCAL PROCEDURE CheckPostRestrictions(SalesHeader: Record 36);
    VAR
        Contact: Record 5050;
    BEGIN
        WITH SalesHeader DO BEGIN
            IF NOT PreviewMode THEN
                OnCheckSalesPostRestrictions;

            CheckCustBlockage(SalesHeader, "Sell-to Customer No.", TRUE);
            ValidateSalesPersonOnSalesHeader(SalesHeader, TRUE, TRUE);

            IF "Bill-to Customer No." <> "Sell-to Customer No." THEN
                CheckCustBlockage(SalesHeader, "Bill-to Customer No.", FALSE);

            IF "Sell-to Contact No." <> '' THEN
                IF Contact.GET("Sell-to Contact No.") THEN
                    Contact.CheckIfPrivacyBlocked(TRUE);
            IF "Bill-to Contact No." <> '' THEN
                IF Contact.GET("Bill-to Contact No.") THEN
                    Contact.CheckIfPrivacyBlocked(TRUE);
        END;
    END;

    LOCAL PROCEDURE CheckCustBlockage(SalesHeader: Record 36; CustCode: Code[20]; ExecuteDocCheck: Boolean);
    VAR
        Cust: Record 18;
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        WITH SalesHeader DO BEGIN
            Cust.GET(CustCode);
            IF Receive THEN
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", FALSE, TRUE)
            ELSE BEGIN
                IF Ship AND CheckDocumentType(SalesHeader, ExecuteDocCheck) THEN BEGIN
                    ResetTempLines(TempSalesLine);
                    TempSalesLine.SETFILTER("Qty. to Ship", '<>0');
                    TempSalesLine.SETRANGE("Shipment No.", '');
                    IF NOT TempSalesLine.ISEMPTY THEN
                        Cust.CheckBlockedCustOnDocs(Cust, "Document Type", TRUE, TRUE);
                END ELSE
                    Cust.CheckBlockedCustOnDocs(Cust, "Document Type", FALSE, TRUE);
            END;
        END;
    END;

    LOCAL PROCEDURE CheckDocumentType(SalesHeader: Record 36; ExecuteDocCheck: Boolean): Boolean;
    BEGIN
        WITH SalesHeader DO
            IF ExecuteDocCheck THEN
                EXIT(
                  ("Document Type" = "Document Type"::Order) OR
                  (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice"));
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateWonOpportunities(VAR SalesHeader: Record 36);
    VAR
        Opp: Record 5092;
        OpportunityEntry: Record 5093;
    BEGIN
        WITH SalesHeader DO
            IF "Document Type" = "Document Type"::Order THEN BEGIN
                Opp.RESET;
                Opp.SETCURRENTKEY("Sales Document Type", "Sales Document No.");
                Opp.SETRANGE("Sales Document Type", Opp."Sales Document Type"::Order);
                Opp.SETRANGE("Sales Document No.", "No.");
                Opp.SETRANGE(Status, Opp.Status::Won);
                IF Opp.FINDFIRST THEN BEGIN
                    Opp."Sales Document Type" := Opp."Sales Document Type"::"Posted Invoice";
                    Opp."Sales Document No." := SalesInvHeader."No.";
                    Opp.MODIFY;
                    OpportunityEntry.RESET;
                    OpportunityEntry.SETCURRENTKEY(Active, "Opportunity No.");
                    OpportunityEntry.SETRANGE(Active, TRUE);
                    OpportunityEntry.SETRANGE("Opportunity No.", Opp."No.");
                    IF OpportunityEntry.FINDFIRST THEN BEGIN
                        OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesHeader);
                        OpportunityEntry.MODIFY;
                    END;
                END;
            END;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForShipment(VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; TrackingSpecificationExists: Boolean; HasATOShippedNotInvoiced: Boolean; SalesLine: Record 37; SalesShptLine: Record 111; InvoicingTrackingSpecification: Record 336; ItemLedgEntryNotInvoiced: Record 32);
    BEGIN
        IF TrackingSpecificationExists THEN BEGIN
            QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        END ELSE
            IF HasATOShippedNotInvoiced THEN BEGIN
                QtyToBeInvoicedBase := ItemLedgEntryNotInvoiced.Quantity - ItemLedgEntryNotInvoiced."Invoiced Quantity";
                IF ABS(QtyToBeInvoicedBase) > ABS(RemQtyToBeInvoicedBase) THEN
                    QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
                QtyToBeInvoiced := ROUND(QtyToBeInvoicedBase / SalesShptLine."Qty. per Unit of Measure", 0.00001);
            END ELSE BEGIN
                QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Qty. to Ship";
                QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
            END;

        IF ABS(QtyToBeInvoiced) > ABS(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced") THEN BEGIN
            QtyToBeInvoiced := -(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced");
            QtyToBeInvoicedBase := -(SalesShptLine."Quantity (Base)" - SalesShptLine."Qty. Invoiced (Base)");
        END;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForReturnReceipt(VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; TrackingSpecificationExists: Boolean; SalesLine: Record 37; ReturnReceiptLine: Record 6661; InvoicingTrackingSpecification: Record 336);
    BEGIN
        IF TrackingSpecificationExists THEN BEGIN
            QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        END ELSE BEGIN
            QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Return Qty. to Receive (Base)";
        END;
        IF ABS(QtyToBeInvoiced) >
           ABS(ReturnReceiptLine.Quantity - ReturnReceiptLine."Quantity Invoiced")
        THEN BEGIN
            QtyToBeInvoiced := ReturnReceiptLine.Quantity - ReturnReceiptLine."Quantity Invoiced";
            QtyToBeInvoicedBase := ReturnReceiptLine."Quantity (Base)" - ReturnReceiptLine."Qty. Invoiced (Base)";
        END;
    END;

    LOCAL PROCEDURE UpdateRemainingQtyToBeInvoiced(SalesShptLine: Record 111; VAR RemQtyToInvoiceCurrLine: Decimal; VAR RemQtyToInvoiceCurrLineBase: Decimal);
    BEGIN
        RemQtyToInvoiceCurrLine := -SalesShptLine.Quantity + SalesShptLine."Quantity Invoiced";
        RemQtyToInvoiceCurrLineBase := -SalesShptLine."Quantity (Base)" + SalesShptLine."Qty. Invoiced (Base)";
        IF RemQtyToInvoiceCurrLine < RemQtyToBeInvoiced THEN BEGIN
            RemQtyToInvoiceCurrLine := RemQtyToBeInvoiced;
            RemQtyToInvoiceCurrLineBase := RemQtyToBeInvoicedBase;
        END;
    END;

    LOCAL PROCEDURE IsEndLoopForShippedNotInvoiced(RemQtyToBeInvoiced: Decimal; TrackingSpecificationExists: Boolean; VAR HasATOShippedNotInvoiced: Boolean; VAR SalesShptLine: Record 111; VAR InvoicingTrackingSpecification: Record 336; VAR ItemLedgEntryNotInvoiced: Record 32; SalesLine: Record 37): Boolean;
    BEGIN
        IF TrackingSpecificationExists THEN
            EXIT((InvoicingTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0));

        IF HasATOShippedNotInvoiced THEN BEGIN
            HasATOShippedNotInvoiced := ItemLedgEntryNotInvoiced.NEXT <> 0;
            IF NOT HasATOShippedNotInvoiced THEN
                EXIT(NOT SalesShptLine.FINDSET OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship")));
            EXIT(ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship"));
        END;

        EXIT((SalesShptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship")));
    END;

    //[External]
    PROCEDURE SetItemEntryRelation(VAR ItemEntryRelation: Record 6507; VAR SalesShptLine: Record 111; VAR InvoicingTrackingSpecification: Record 336; VAR ItemLedgEntryNotInvoiced: Record 32; TrackingSpecificationExists: Boolean; HasATOShippedNotInvoiced: Boolean);
    BEGIN
        IF TrackingSpecificationExists THEN BEGIN
            ItemEntryRelation.GET(InvoicingTrackingSpecification."Item Ledger Entry No.");
            SalesShptLine.GET(ItemEntryRelation."Source ID", ItemEntryRelation."Source Ref. No.");
        END ELSE
            IF HasATOShippedNotInvoiced THEN BEGIN
                ItemEntryRelation."Item Entry No." := ItemLedgEntryNotInvoiced."Entry No.";
                SalesShptLine.GET(ItemLedgEntryNotInvoiced."Document No.", ItemLedgEntryNotInvoiced."Document Line No.");
            END ELSE
                ItemEntryRelation."Item Entry No." := SalesShptLine."Item Shpt. Entry No.";
    END;

    LOCAL PROCEDURE PostATOAssocItemJnlLine(SalesHeader: Record 36; SalesLine: Record 37; VAR PostedATOLink: Record 914; VAR RemQtyToBeInvoiced: Decimal; VAR RemQtyToBeInvoicedBase: Decimal);
    VAR
        DummyTrackingSpecification: Record 336;
    BEGIN
        WITH PostedATOLink DO BEGIN
            DummyTrackingSpecification.INIT;
            IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN
                "Assembled Quantity" := -"Assembled Quantity";
                "Assembled Quantity (Base)" := -"Assembled Quantity (Base)";
                IF ABS(RemQtyToBeInvoiced) >= ABS("Assembled Quantity") THEN BEGIN
                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        SalesHeader, SalesLine,
                        "Assembled Quantity", "Assembled Quantity (Base)",
                        "Assembled Quantity", "Assembled Quantity (Base)",
                        0, '', DummyTrackingSpecification, TRUE);
                    RemQtyToBeInvoiced -= "Assembled Quantity";
                    RemQtyToBeInvoicedBase -= "Assembled Quantity (Base)";
                END ELSE BEGIN
                    IF RemQtyToBeInvoiced <> 0 THEN
                        ItemLedgShptEntryNo :=
                          PostItemJnlLine(
                            SalesHeader, SalesLine,
                            RemQtyToBeInvoiced,
                            RemQtyToBeInvoicedBase,
                            RemQtyToBeInvoiced,
                            RemQtyToBeInvoicedBase,
                            0, '', DummyTrackingSpecification, TRUE);

                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        SalesHeader, SalesLine,
                        "Assembled Quantity" - RemQtyToBeInvoiced,
                        "Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
                        0, 0,
                        0, '', DummyTrackingSpecification, TRUE);

                    RemQtyToBeInvoiced := 0;
                    RemQtyToBeInvoicedBase := 0;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE GetOpenLinkedATOs(VAR TempAsmHeader: Record 900 TEMPORARY);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        AsmHeader: Record 900;
    BEGIN
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            IF FINDSET THEN
                REPEAT
                    IF AsmToOrderExists(AsmHeader) THEN
                        IF AsmHeader.Status = AsmHeader.Status::Open THEN BEGIN
                            TempAsmHeader.TRANSFERFIELDS(AsmHeader);
                            TempAsmHeader.INSERT;
                        END;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ReopenAsmOrders(VAR TempAsmHeader: Record 900 TEMPORARY);
    VAR
        AsmHeader: Record 900;
    BEGIN
        IF TempAsmHeader.FIND('-') THEN
            REPEAT
                AsmHeader.GET(TempAsmHeader."Document Type", TempAsmHeader."No.");
                AsmHeader.Status := AsmHeader.Status::Open;
                AsmHeader.MODIFY;
            UNTIL TempAsmHeader.NEXT = 0;
    END;

    LOCAL PROCEDURE InitPostATO(SalesHeader: Record 36; VAR SalesLine: Record 37);
    VAR
        AsmHeader: Record 900;
        Window: Dialog;
    BEGIN
        IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
            Window.OPEN(AssemblyCheckProgressMsg);
            Window.UPDATE(1,
              STRSUBSTNO('%1 %2 %3 %4',
                SalesLine."Document Type", SalesLine."Document No.", SalesLine.FIELDCAPTION("Line No."), SalesLine."Line No."));
            Window.UPDATE(2, STRSUBSTNO('%1 %2', AsmHeader."Document Type", AsmHeader."No."));

            SalesLine.CheckAsmToOrder(AsmHeader);
            IF NOT HasQtyToAsm(SalesLine, AsmHeader) THEN
                EXIT;

            AsmPost.SetPostingDate(TRUE, SalesHeader."Posting Date");
            AsmPost.InitPostATO(AsmHeader);

            Window.CLOSE;
        END;
    END;

    LOCAL PROCEDURE InitPostATOs(SalesHeader: Record 36);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        WITH TempSalesLine DO BEGIN
            FindNotShippedLines(SalesHeader, TempSalesLine);
            SETFILTER("Qty. to Assemble to Order", '<>0');
            IF FINDSET THEN
                REPEAT
                    InitPostATO(SalesHeader, TempSalesLine);
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostATO(SalesHeader: Record 36; VAR SalesLine: Record 37; VAR TempPostedATOLink: Record 914 TEMPORARY);
    VAR
        AsmHeader: Record 900;
        PostedATOLink: Record 914;
        Window: Dialog;
    BEGIN
        IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
            Window.OPEN(AssemblyPostProgressMsg);
            Window.UPDATE(1,
              STRSUBSTNO('%1 %2 %3 %4',
                SalesLine."Document Type", SalesLine."Document No.", SalesLine.FIELDCAPTION("Line No."), SalesLine."Line No."));
            Window.UPDATE(2, STRSUBSTNO('%1 %2', AsmHeader."Document Type", AsmHeader."No."));

            SalesLine.CheckAsmToOrder(AsmHeader);
            IF NOT HasQtyToAsm(SalesLine, AsmHeader) THEN
                EXIT;
            IF AsmHeader."Remaining Quantity (Base)" = 0 THEN
                EXIT;

            PostedATOLink.INIT;
            PostedATOLink."Assembly Document Type" := PostedATOLink."Assembly Document Type"::Assembly;
            PostedATOLink."Assembly Document No." := AsmHeader."Posting No.";
            PostedATOLink."Document Type" := PostedATOLink."Document Type"::"Sales Shipment";
            PostedATOLink."Document No." := SalesHeader."Shipping No.";
            PostedATOLink."Document Line No." := SalesLine."Line No.";

            PostedATOLink."Assembly Order No." := AsmHeader."No.";
            PostedATOLink."Order No." := SalesLine."Document No.";
            PostedATOLink."Order Line No." := SalesLine."Line No.";

            PostedATOLink."Assembled Quantity" := AsmHeader."Quantity to Assemble";
            PostedATOLink."Assembled Quantity (Base)" := AsmHeader."Quantity to Assemble (Base)";
            PostedATOLink.INSERT;

            TempPostedATOLink := PostedATOLink;
            TempPostedATOLink.INSERT;

            AsmPost.PostATO(AsmHeader, ItemJnlPostLine, ResJnlPostLine, WhseJnlPostLine);

            Window.CLOSE;
        END;
    END;

    LOCAL PROCEDURE FinalizePostATO(VAR SalesLine: Record 37);
    VAR
        ATOLink: Record 904;
        AsmHeader: Record 900;
        Window: Dialog;
    BEGIN
        IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
            Window.OPEN(AssemblyFinalizeProgressMsg);
            Window.UPDATE(1,
              STRSUBSTNO('%1 %2 %3 %4',
                SalesLine."Document Type", SalesLine."Document No.", SalesLine.FIELDCAPTION("Line No."), SalesLine."Line No."));
            Window.UPDATE(2, STRSUBSTNO('%1 %2', AsmHeader."Document Type", AsmHeader."No."));

            SalesLine.CheckAsmToOrder(AsmHeader);
            AsmHeader.TESTFIELD("Remaining Quantity (Base)", 0);
            AsmPost.FinalizePostATO(AsmHeader);
            ATOLink.GET(AsmHeader."Document Type", AsmHeader."No.");
            ATOLink.DELETE;

            Window.CLOSE;
        END;
    END;

    LOCAL PROCEDURE CheckATOLink(SalesLine: Record 37);
    VAR
        AsmHeader: Record 900;
    BEGIN
        IF SalesLine."Qty. to Asm. to Order (Base)" = 0 THEN
            EXIT;
        IF SalesLine.AsmToOrderExists(AsmHeader) THEN
            SalesLine.CheckAsmToOrder(AsmHeader);
    END;

    LOCAL PROCEDURE DeleteATOLinks(SalesHeader: Record 36);
    VAR
        ATOLink: Record 904;
    BEGIN
        WITH ATOLink DO BEGIN
            SETCURRENTKEY(Type, "Document Type", "Document No.");
            SETRANGE(Type, Type::Sale);
            SETRANGE("Document Type", SalesHeader."Document Type");
            SETRANGE("Document No.", SalesHeader."No.");
            IF NOT ISEMPTY THEN
                DELETEALL;
        END;
    END;

    LOCAL PROCEDURE HasQtyToAsm(SalesLine: Record 37; AsmHeader: Record 900): Boolean;
    BEGIN
        IF SalesLine."Qty. to Asm. to Order (Base)" = 0 THEN
            EXIT(FALSE);
        IF SalesLine."Qty. to Ship (Base)" = 0 THEN
            EXIT(FALSE);
        IF AsmHeader."Quantity to Assemble (Base)" = 0 THEN
            EXIT(FALSE);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetATOItemLedgEntriesNotInvoiced(SalesLine: Record 37; VAR ItemLedgEntryNotInvoiced: Record 32): Boolean;
    VAR
        PostedATOLink: Record 914;
        ItemLedgEntry: Record 32;
    BEGIN
        ItemLedgEntryNotInvoiced.RESET;
        ItemLedgEntryNotInvoiced.DELETEALL;
        IF PostedATOLink.FindLinksFromSalesLine(SalesLine) THEN
            REPEAT
                ItemLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
                ItemLedgEntry.SETRANGE("Document Type", ItemLedgEntry."Document Type"::"Sales Shipment");
                ItemLedgEntry.SETRANGE("Document No.", PostedATOLink."Document No.");
                ItemLedgEntry.SETRANGE("Document Line No.", PostedATOLink."Document Line No.");
                ItemLedgEntry.SETRANGE("Assemble to Order", TRUE);
                ItemLedgEntry.SETRANGE("Completely Invoiced", FALSE);
                IF ItemLedgEntry.FINDSET THEN
                    REPEAT
                        IF ItemLedgEntry.Quantity <> ItemLedgEntry."Invoiced Quantity" THEN BEGIN
                            ItemLedgEntryNotInvoiced := ItemLedgEntry;
                            ItemLedgEntryNotInvoiced.INSERT;
                        END;
                    UNTIL ItemLedgEntry.NEXT = 0;
            UNTIL PostedATOLink.NEXT = 0;

        EXIT(ItemLedgEntryNotInvoiced.FINDSET);
    END;


    LOCAL PROCEDURE PostWhseShptLines(VAR WhseShptLine2: Record 7321; SalesShptLine2: Record 111; VAR SalesLine2: Record 37);
    VAR
        ATOWhseShptLine: Record 7321;
        NonATOWhseShptLine: Record 7321;
        ATOLineFound: Boolean;
        NonATOLineFound: Boolean;
        TotalSalesShptLineQty: Decimal;
    BEGIN
        WhseShptLine2.GetATOAndNonATOLines(ATOWhseShptLine, NonATOWhseShptLine, ATOLineFound, NonATOLineFound);
        IF ATOLineFound THEN
            TotalSalesShptLineQty += ATOWhseShptLine."Qty. to Ship";
        IF NonATOLineFound THEN
            TotalSalesShptLineQty += NonATOWhseShptLine."Qty. to Ship";
        SalesShptLine2.TESTFIELD(Quantity, TotalSalesShptLineQty);

        SaveTempWhseSplitSpec(SalesLine2, TempATOTrackingSpecification);
        WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
        IF ATOLineFound AND (ATOWhseShptLine."Qty. to Ship (Base)" > 0) THEN
            WhsePostShpt.CreatePostedShptLine(
              ATOWhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);

        SaveTempWhseSplitSpec(SalesLine2, TempHandlingSpecification);
        IF NonATOLineFound AND (NonATOWhseShptLine."Qty. to Ship (Base)" > 0) THEN
            WhsePostShpt.CreatePostedShptLine(
              NonATOWhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);
    END;

    LOCAL PROCEDURE GetCountryCode(SalesLine: Record 37; SalesHeader: Record 36): Code[10];
    VAR
        SalesShipmentHeader: Record 110;
        CountryRegionCode: Code[10];
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeGetCountryCode(SalesHeader, SalesLine, CountryRegionCode, IsHandled);
        IF IsHandled THEN
            EXIT(CountryRegionCode);

        IF SalesLine."Shipment No." <> '' THEN BEGIN
            SalesShipmentHeader.GET(SalesLine."Shipment No.");
            EXIT(
              GetCountryRegionCode(
                SalesLine."Sell-to Customer No.",
                SalesShipmentHeader."Ship-to Code",
                SalesShipmentHeader."Sell-to Country/Region Code"));
        END;
        EXIT(
          GetCountryRegionCode(
            SalesLine."Sell-to Customer No.",
            SalesHeader."Ship-to Code",
            SalesHeader."Sell-to Country/Region Code"));
    END;

    LOCAL PROCEDURE GetCountryRegionCode(CustNo: Code[20]; ShipToCode: Code[10]; SellToCountryRegionCode: Code[10]): Code[10];
    VAR
        ShipToAddress: Record 222;
    BEGIN
        IF ShipToCode <> '' THEN BEGIN
            ShipToAddress.GET(CustNo, ShipToCode);
            EXIT(ShipToAddress."Country/Region Code");
        END;
        EXIT(SellToCountryRegionCode);
    END;

    LOCAL PROCEDURE UpdateIncomingDocument(IncomingDocNo: Integer; PostingDate: Date; GenJnlLineDocNo: Code[20]);
    VAR
        IncomingDocument: Record 130;
    BEGIN
        IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo, PostingDate, GenJnlLineDocNo);
    END;

    LOCAL PROCEDURE CheckItemCharge(ItemChargeAssgntSales: Record 5809);
    VAR
        SalesLineForCharge: Record 37;
    BEGIN
        WITH ItemChargeAssgntSales DO
            CASE "Applies-to Doc. Type" OF
                "Applies-to Doc. Type"::Order,
              "Applies-to Doc. Type"::Invoice:
                    IF SalesLineForCharge.GET(
                         "Applies-to Doc. Type",
                         "Applies-to Doc. No.",
                         "Applies-to Doc. Line No.")
                    THEN
                        IF (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Qty. Shipped (Base)") AND
                           (SalesLineForCharge."Qty. Shipped Not Invd. (Base)" = 0)
                        THEN
                            ERROR(ReassignItemChargeErr);
                "Applies-to Doc. Type"::"Return Order",
              "Applies-to Doc. Type"::"Credit Memo":
                    IF SalesLineForCharge.GET(
                         "Applies-to Doc. Type",
                         "Applies-to Doc. No.",
                         "Applies-to Doc. Line No.")
                    THEN
                        IF (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Return Qty. Received (Base)") AND
                           (SalesLineForCharge."Ret. Qty. Rcd. Not Invd.(Base)" = 0)
                        THEN
                            ERROR(ReassignItemChargeErr);
            END;
    END;

    LOCAL PROCEDURE CheckItemReservDisruption(SalesLine: Record 37);
    VAR
        ConfirmManagement: Codeunit 50206;
        AvailableQty: Decimal;
    BEGIN
        WITH SalesLine DO BEGIN
            IF NOT ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) OR
               (Type <> Type::Item) OR NOT ("Qty. to Ship (Base)" > 0)
            THEN
                EXIT;
            IF ("Job Contract Entry No." <> 0) OR
               Nonstock OR "Special Order" OR "Drop Shipment" OR
               IsNonInventoriableItem OR FullQtyIsForAsmToOrder OR
               TempSKU.GET("Location Code", "No.", "Variant Code") // Warn against item
            THEN
                EXIT;

            Item.SETFILTER("Location Filter", "Location Code");
            Item.SETFILTER("Variant Filter", "Variant Code");
            Item.CALCFIELDS("Reserved Qty. on Inventory", "Net Change");
            CALCFIELDS("Reserved Qty. (Base)");
            AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");

            IF (Item."Reserved Qty. on Inventory" > 0) AND
               (AvailableQty < "Qty. to Ship (Base)") AND
               (Item."Reserved Qty. on Inventory" > "Reserved Qty. (Base)")
            THEN BEGIN
                InsertTempSKU("Location Code", "No.", "Variant Code");
                IF NOT ConfirmManagement.ConfirmProcess(
                     STRSUBSTNO(
                       ReservationDisruptedQst, FIELDCAPTION("No."), Item."No.", FIELDCAPTION("Location Code"),
                       "Location Code", FIELDCAPTION("Variant Code"), "Variant Code"), TRUE)
                THEN
                    ERROR('');
            END;
        END;
    END;

    LOCAL PROCEDURE InsertTempSKU(LocationCode: Code[10]; ItemNo: Code[20]; VariantCode: Code[10]);
    BEGIN
        WITH TempSKU DO BEGIN
            INIT;
            "Location Code" := LocationCode;
            "Item No." := ItemNo;
            "Variant Code" := VariantCode;
            INSERT;
        END;
    END;

    //[External]
    PROCEDURE InitProgressWindow(SalesHeader: Record 36);
    BEGIN
        IF SalesHeader.Invoice THEN
            Window.OPEN(
              '#1#################################\\' +
              PostingLinesMsg +
              PostingSalesAndVATMsg +
              PostingCustomersMsg +
              Text1100102 +
              Text1100103)
        ELSE
            Window.OPEN(
              '#1#################################\\' +
              PostingLines2Msg);

        Window.UPDATE(1, STRSUBSTNO('%1 %2', SalesHeader."Document Type", SalesHeader."No."));
    END;

    LOCAL PROCEDURE CheckCertificateOfSupplyStatus(SalesShptHeader: Record 110; SalesShptLine: Record 111);
    VAR
        CertificateOfSupply: Record 780;
        VATPostingSetup: Record 325;
    BEGIN
        IF SalesShptLine.Quantity <> 0 THEN
            IF VATPostingSetup.GET(SalesShptHeader."VAT Bus. Posting Group", SalesShptLine."VAT Prod. Posting Group") AND
               VATPostingSetup."Certificate of Supply Required"
            THEN BEGIN
                CertificateOfSupply.InitFromSales(SalesShptHeader);
                CertificateOfSupply.SetRequired(SalesShptHeader."No.");
            END;
    END;

    LOCAL PROCEDURE HasSpecificTracking(ItemNo: Code[20]): Boolean;
    VAR
        Item: Record 27;
        ItemTrackingCode: Record 6502;
    BEGIN
        Item.GET(ItemNo);
        IF Item."Item Tracking Code" <> '' THEN BEGIN
            ItemTrackingCode.GET(Item."Item Tracking Code");
            EXIT(ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking");
        END;
    END;

    LOCAL PROCEDURE HasInvtPickLine(SalesLine: Record 37): Boolean;
    VAR
        WhseActivityLine: Record 5767;
    BEGIN
        WITH WhseActivityLine DO BEGIN
            SETRANGE("Activity Type", "Activity Type"::"Invt. Pick");
            SETRANGE("Source Type", DATABASE::"Sales Line");
            SETRANGE("Source Subtype", SalesLine."Document Type");
            SETRANGE("Source No.", SalesLine."Document No.");
            SETRANGE("Source Line No.", SalesLine."Line No.");
            EXIT(NOT ISEMPTY);
        END;
    END;

    LOCAL PROCEDURE InsertPostedHeaders(SalesHeader: Record 36);
    VAR
        SalesShptLine: Record 111;
        PurchRcptLine: Record 121;
        GenJnlLine: Record 81;
    BEGIN
        WITH SalesHeader DO BEGIN
            // Insert shipment header
            IF Ship THEN BEGIN
                IF ("Document Type" = "Document Type"::Order) OR
                   (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
                THEN BEGIN
                    IF DropShipOrder THEN BEGIN
                        PurchRcptHeader.LOCKTABLE;
                        PurchRcptLine.LOCKTABLE;
                        SalesShptHeader.LOCKTABLE;
                        SalesShptLine.LOCKTABLE;
                    END;
                    InsertShipmentHeader(SalesHeader, SalesShptHeader);
                END;

                ServItemMgt.CopyReservationEntry(SalesHeader);
                IF ("Document Type" = "Document Type"::Invoice) AND
                   (NOT SalesSetup."Shipment on Invoice")
                THEN
                    ServItemMgt.CreateServItemOnSalesInvoice(SalesHeader);
            END;

            ServItemMgt.DeleteServItemOnSaleCreditMemo(SalesHeader);

            // Insert return receipt header
            IF Receive THEN
                IF ("Document Type" = "Document Type"::"Return Order") OR
                   (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
                THEN
                    InsertReturnReceiptHeader(SalesHeader, ReturnRcptHeader);

            // Insert invoice header or credit memo header
            IF Invoice THEN
                IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                    InsertInvoiceHeader(SalesHeader, SalesInvHeader);
                    GenJnlLineDocType := GenJnlLine."Document Type"::Invoice.AsInteger();
                    GenJnlLineDocNo := SalesInvHeader."No.";
                    GenJnlLineExtDocNo := SalesInvHeader."External Document No.";
                END ELSE BEGIN // Credit Memo
                    InsertCrMemoHeader(SalesHeader, SalesCrMemoHeader);
                    GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo".AsInteger();
                    GenJnlLineDocNo := SalesCrMemoHeader."No.";
                    GenJnlLineExtDocNo := SalesCrMemoHeader."External Document No.";
                END;
        END;
    END;

    LOCAL PROCEDURE InsertShipmentHeader(SalesHeader: Record 36; VAR SalesShptHeader: Record 110);
    VAR
        SalesCommentLine: Record 44;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        WITH SalesHeader DO BEGIN
            SalesShptHeader.INIT;
            CALCFIELDS("Work Description");
            SalesShptHeader.TRANSFERFIELDS(SalesHeader);

            SalesShptHeader."No." := "Shipping No.";
            IF "Document Type" = "Document Type"::Order THEN BEGIN
                SalesShptHeader."Order No. Series" := "No. Series";
                SalesShptHeader."Order No." := "No.";
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                    TESTFIELD("External Document No.");
            END;
            SalesShptHeader."Source Code" := SrcCode;
            SalesShptHeader."User ID" := USERID;
            SalesShptHeader."No. Printed" := 0;
            OnBeforeSalesShptHeaderInsert(SalesShptHeader, SalesHeader, SuppressCommit);
            SalesShptHeader.INSERT(TRUE);
            OnAfterSalesShptHeaderInsert(SalesShptHeader, SalesHeader, SuppressCommit);

            ApprovalsMgmt.PostApprovalEntries(RECORDID, SalesShptHeader.RECORDID, SalesShptHeader."No.");

            IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
                SalesCommentLine.CopyComments(
                  "Document Type".AsInteger(), SalesCommentLine."Document Type"::Shipment.AsInteger(), "No.", SalesShptHeader."No.");
                RecordLinkManagement.CopyLinks(SalesHeader, SalesShptHeader);
            END;
            IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(
                  PostedWhseShptHeader, WhseShptHeader, "Shipping No.", "Posting Date");
            END;
            IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(
                  PostedWhseRcptHeader, WhseRcptHeader, "Shipping No.", "Posting Date");
            END;
        END;
    END;

    LOCAL PROCEDURE InsertReturnReceiptHeader(SalesHeader: Record 36; VAR ReturnRcptHeader: Record 6660);
    VAR
        SalesCommentLine: Record 44;
        RecordLinkManagement: Codeunit 447;
        IsHandled: Boolean;
    BEGIN
        OnBeforeInsertReturnReceiptHeader(SalesHeader, ReturnRcptHeader, IsHandled, SuppressCommit);

        WITH SalesHeader DO BEGIN
            IF NOT IsHandled THEN BEGIN
                ReturnRcptHeader.INIT;
                ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
                ReturnRcptHeader."No." := "Return Receipt No.";
                IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                    ReturnRcptHeader."Return Order No. Series" := "No. Series";
                    ReturnRcptHeader."Return Order No." := "No.";
                    IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                        TESTFIELD("External Document No.");
                END;
                ReturnRcptHeader."No. Series" := "Return Receipt No. Series";
                ReturnRcptHeader."Source Code" := SrcCode;
                ReturnRcptHeader."User ID" := USERID;
                ReturnRcptHeader."No. Printed" := 0;
                OnBeforeReturnRcptHeaderInsert(ReturnRcptHeader, SalesHeader, SuppressCommit);
                ReturnRcptHeader.INSERT(TRUE);
                OnAfterReturnRcptHeaderInsert(ReturnRcptHeader, SalesHeader, SuppressCommit);

                ApprovalsMgmt.PostApprovalEntries(RECORDID, ReturnRcptHeader.RECORDID, ReturnRcptHeader."No.");

                IF SalesSetup."Copy Cmts Ret.Ord. to Ret.Rcpt" THEN BEGIN
                    SalesCommentLine.CopyComments(
                      "Document Type".AsInteger(), SalesCommentLine."Document Type"::"Posted Return Receipt".AsInteger(), "No.", ReturnRcptHeader."No.");
                    RecordLinkManagement.CopyLinks(SalesHeader, ReturnRcptHeader);
                END;
            END;

            IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader, WhseRcptHeader, "Return Receipt No.", "Posting Date");
            END;
            IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader, WhseShptHeader, "Return Receipt No.", "Posting Date");
            END;
        END;
    END;

    LOCAL PROCEDURE InsertInvoiceHeader(SalesHeader: Record 36; VAR SalesInvHeader: Record 112);
    VAR
        SalesCommentLine: Record 44;
        RecordLinkManagement: Codeunit 447;
        SegManagement: Codeunit 5051;
    BEGIN
        WITH SalesHeader DO BEGIN
            SalesInvHeader.INIT;
            CALCFIELDS("Work Description");
            SalesInvHeader.TRANSFERFIELDS(SalesHeader);

            SalesInvHeader."No." := "Posting No.";
            IF "Document Type" = "Document Type"::Order THEN BEGIN
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                    TESTFIELD("External Document No.");
                SalesInvHeader."Pre-Assigned No. Series" := '';
                SalesInvHeader."Order No. Series" := "No. Series";
                SalesInvHeader."Order No." := "No.";
            END ELSE BEGIN
                IF "Posting No." = '' THEN
                    SalesInvHeader."No." := "No.";
                SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
                SalesInvHeader."Pre-Assigned No." := "No.";
            END;
            IF GUIALLOWED THEN
                Window.UPDATE(1, STRSUBSTNO(InvoiceNoMsg, "Document Type", "No.", SalesInvHeader."No."));
            SalesInvHeader."Source Code" := SrcCode;
            SalesInvHeader."User ID" := USERID;
            SalesInvHeader."No. Printed" := 0;
            SetPaymentInstructions(SalesHeader);
            OnBeforeSalesInvHeaderInsert(SalesInvHeader, SalesHeader, SuppressCommit);
            SalesInvHeader.INSERT(TRUE);
            OnAfterSalesInvHeaderInsert(SalesInvHeader, SalesHeader, SuppressCommit);

            UpdateWonOpportunities(SalesHeader);
            SegManagement.CreateCampaignEntryOnSalesInvoicePosting(SalesInvHeader);

            ApprovalsMgmt.PostApprovalEntries(RECORDID, SalesInvHeader.RECORDID, SalesInvHeader."No.");

            IF SalesSetup."Copy Comments Order to Invoice" THEN BEGIN
                SalesCommentLine.CopyComments(
                  "Document Type".AsInteger(), SalesCommentLine."Document Type"::"Posted Invoice".AsInteger(), "No.", SalesInvHeader."No.");
                RecordLinkManagement.CopyLinks(SalesHeader, SalesInvHeader);
            END;
        END;
    END;

    LOCAL PROCEDURE InsertCrMemoHeader(SalesHeader: Record 36; VAR SalesCrMemoHeader: Record 114);
    VAR
        SalesCommentLine: Record 44;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        WITH SalesHeader DO BEGIN
            SalesCrMemoHeader.INIT;
            CALCFIELDS("Work Description");
            SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
            IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                SalesCrMemoHeader."No." := "Posting No.";
                IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                    TESTFIELD("External Document No.");
                SalesCrMemoHeader."Pre-Assigned No. Series" := '';
                SalesCrMemoHeader."Return Order No. Series" := "No. Series";
                SalesCrMemoHeader."Return Order No." := "No.";
                Window.UPDATE(1, STRSUBSTNO(CreditMemoNoMsg, "Document Type", "No.", SalesCrMemoHeader."No."));
            END ELSE BEGIN
                SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
                SalesCrMemoHeader."Pre-Assigned No." := "No.";
                IF "Posting No." <> '' THEN BEGIN
                    SalesCrMemoHeader."No." := "Posting No.";
                    Window.UPDATE(1, STRSUBSTNO(CreditMemoNoMsg, "Document Type", "No.", SalesCrMemoHeader."No."));
                END;
            END;
            SalesCrMemoHeader."Source Code" := SrcCode;
            SalesCrMemoHeader."User ID" := USERID;
            SalesCrMemoHeader."No. Printed" := 0;
            OnBeforeSalesCrMemoHeaderInsert(SalesCrMemoHeader, SalesHeader, SuppressCommit);
            SalesCrMemoHeader.INSERT(TRUE);
            OnAfterSalesCrMemoHeaderInsert(SalesCrMemoHeader, SalesHeader, SuppressCommit);

            ApprovalsMgmt.PostApprovalEntries(RECORDID, SalesCrMemoHeader.RECORDID, SalesCrMemoHeader."No.");

            IF SalesSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
                SalesCommentLine.CopyComments(
                  "Document Type".AsInteger(), SalesCommentLine."Document Type"::"Posted Credit Memo".AsInteger(), "No.", SalesCrMemoHeader."No.");
                RecordLinkManagement.CopyLinks(SalesHeader, SalesCrMemoHeader);
            END;
        END;
    END;

    LOCAL PROCEDURE InsertPurchRcptHeader(PurchaseHeader: Record 38; SalesHeader: Record 36; VAR PurchRcptHeader: Record 120);
    BEGIN
        WITH PurchRcptHeader DO BEGIN
            INIT;
            TRANSFERFIELDS(PurchaseHeader);
            "No." := PurchaseHeader."Receiving No.";
            "Order No." := PurchaseHeader."No.";
            "Posting Date" := SalesHeader."Posting Date";
            "Document Date" := SalesHeader."Document Date";
            "No. Printed" := 0;
            OnBeforePurchRcptHeaderInsert(PurchRcptHeader, PurchaseHeader, SalesHeader, SuppressCommit);
            INSERT;
            OnAfterPurchRcptHeaderInsert(PurchRcptHeader, PurchaseHeader, SalesHeader, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE InsertPurchRcptLine(PurchRcptHeader: Record 120; PurchOrderLine: Record 39; DropShptPostBuffer: Record 223);
    VAR
        PurchRcptLine: Record 121;
    BEGIN
        WITH PurchRcptLine DO BEGIN
            INIT;
            TRANSFERFIELDS(PurchOrderLine);
            "Posting Date" := PurchRcptHeader."Posting Date";
            "Document No." := PurchRcptHeader."No.";
            Quantity := DropShptPostBuffer.Quantity;
            "Quantity (Base)" := DropShptPostBuffer."Quantity (Base)";
            "Quantity Invoiced" := 0;
            "Qty. Invoiced (Base)" := 0;
            "Order No." := PurchOrderLine."Document No.";
            "Order Line No." := PurchOrderLine."Line No.";
            "Qty. Rcd. Not Invoiced" := Quantity - "Quantity Invoiced";
            IF Quantity <> 0 THEN BEGIN
                "Item Rcpt. Entry No." := DropShptPostBuffer."Item Shpt. Entry No.";
                "Item Charge Base Amount" := PurchOrderLine."Line Amount"
            END;
            OnBeforePurchRcptLineInsert(PurchRcptLine, PurchRcptHeader, PurchOrderLine, DropShptPostBuffer, SuppressCommit);
            INSERT;
            OnAfterPurchRcptLineInsert(PurchRcptLine, PurchRcptHeader, PurchOrderLine, DropShptPostBuffer, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE InsertShipmentLine(SalesHeader: Record 36; SalesShptHeader: Record 110; SalesLine: Record 37; CostBaseAmount: Decimal; VAR TempServiceItem2: Record 5940 TEMPORARY; VAR TempServiceItemComp2: Record 5941 TEMPORARY);
    VAR
        SalesShptLine: Record 111;
        WhseShptLine: Record 7321;
        WhseRcptLine: Record 7317;
        TempServiceItem1: Record 5940 TEMPORARY;
        TempServiceItemComp1: Record 5941 TEMPORARY;
    BEGIN
        SalesShptLine.InitFromSalesLine(SalesShptHeader, xSalesLine);
        SalesShptLine."Quantity Invoiced" := -RemQtyToBeInvoiced;
        SalesShptLine."Qty. Invoiced (Base)" := -RemQtyToBeInvoicedBase;
        SalesShptLine."Qty. Shipped Not Invoiced" := SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";

        IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."Qty. to Ship" <> 0) THEN BEGIN
            IF WhseShip THEN BEGIN
                WhseShptLine.GetWhseShptLine(
                  WhseShptHeader."No.", DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.");//enum to option
                PostWhseShptLines(WhseShptLine, SalesShptLine, SalesLine);
            END;
            IF WhseReceive THEN BEGIN
                WhseRcptLine.GetWhseRcptLine(
                  WhseRcptHeader."No.", DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.");//enum to option
                WhseRcptLine.TESTFIELD("Qty. to Receive", -SalesShptLine.Quantity);
                SaveTempWhseSplitSpec(SalesLine, TempHandlingSpecification);
                WhsePostRcpt.CreatePostedRcptLine(
                  WhseRcptLine, PostedWhseRcptHeader, PostedWhseRcptLine, TempWhseSplitSpecification);
            END;

            SalesShptLine."Item Shpt. Entry No." :=
              InsertShptEntryRelation(SalesShptLine); // ItemLedgShptEntryNo
            SalesShptLine."Item Charge Base Amount" :=
              ROUND(CostBaseAmount / SalesLine.Quantity * SalesShptLine.Quantity);
        END;
        OnBeforeSalesShptLineInsert(SalesShptLine, SalesShptHeader, SalesLine, SuppressCommit);
        SalesShptLine.INSERT(TRUE);
        OnAfterSalesShptLineInsert(SalesShptLine, SalesLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit, SalesInvHeader);

        CheckCertificateOfSupplyStatus(SalesShptHeader, SalesShptLine);

        OnInvoiceSalesShptLine(SalesShptLine, SalesInvHeader."No.", xSalesLine."Line No.", xSalesLine."Qty. to Invoice", SuppressCommit);

        ServItemMgt.CreateServItemOnSalesLineShpt(SalesHeader, xSalesLine, SalesShptLine);
        IF SalesLine."BOM Item No." <> '' THEN BEGIN
            ServItemMgt.ReturnServItemComp(TempServiceItem1, TempServiceItemComp1);
            IF TempServiceItem1.FINDSET THEN
                REPEAT
                    TempServiceItem2 := TempServiceItem1;
                    IF TempServiceItem2.INSERT THEN;
                UNTIL TempServiceItem1.NEXT = 0;
            IF TempServiceItemComp1.FINDSET THEN
                REPEAT
                    TempServiceItemComp2 := TempServiceItemComp1;
                    IF TempServiceItemComp2.INSERT THEN;
                UNTIL TempServiceItemComp1.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE InsertReturnReceiptLine(ReturnRcptHeader: Record 6660; SalesLine: Record 37; CostBaseAmount: Decimal);
    VAR
        ReturnRcptLine: Record 6661;
        WhseShptLine: Record 7321;
        WhseRcptLine: Record 7317;
    BEGIN
        ReturnRcptLine.InitFromSalesLine(ReturnRcptHeader, xSalesLine);
        ReturnRcptLine."Quantity Invoiced" := RemQtyToBeInvoiced;
        ReturnRcptLine."Qty. Invoiced (Base)" := RemQtyToBeInvoicedBase;
        ReturnRcptLine."Return Qty. Rcd. Not Invd." := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";

        IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."Return Qty. to Receive" <> 0) THEN BEGIN
            IF WhseReceive THEN BEGIN
                WhseRcptLine.GetWhseRcptLine(
                  WhseRcptHeader."No.", DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.");//enum to option
                WhseRcptLine.TESTFIELD("Qty. to Receive", ReturnRcptLine.Quantity);
                SaveTempWhseSplitSpec(SalesLine, TempHandlingSpecification);
                WhsePostRcpt.CreatePostedRcptLine(
                  WhseRcptLine, PostedWhseRcptHeader, PostedWhseRcptLine, TempWhseSplitSpecification);
            END;
            IF WhseShip THEN BEGIN
                WhseShptLine.GetWhseShptLine(
                  WhseShptHeader."No.", DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.");//enum to option
                WhseShptLine.TESTFIELD("Qty. to Ship", -ReturnRcptLine.Quantity);
                SaveTempWhseSplitSpec(SalesLine, TempHandlingSpecification);
                WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
                WhsePostShpt.CreatePostedShptLine(
                  WhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);
            END;

            ReturnRcptLine."Item Rcpt. Entry No." :=
              InsertReturnEntryRelation(ReturnRcptLine); // ItemLedgShptEntryNo;
            ReturnRcptLine."Item Charge Base Amount" :=
              ROUND(CostBaseAmount / SalesLine.Quantity * ReturnRcptLine.Quantity);
        END;
        OnBeforeReturnRcptLineInsert(ReturnRcptLine, ReturnRcptHeader, SalesLine, SuppressCommit);
        ReturnRcptLine.INSERT(TRUE);
        OnAfterReturnRcptLineInsert(
          ReturnRcptLine, ReturnRcptHeader, SalesLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit, SalesCrMemoHeader);
    END;

    LOCAL PROCEDURE CheckICPartnerBlocked(SalesHeader: Record 36);
    VAR
        ICPartner: Record 413;
    BEGIN
        WITH SalesHeader DO BEGIN
            IF "Sell-to IC Partner Code" <> '' THEN
                IF ICPartner.GET("Sell-to IC Partner Code") THEN
                    ICPartner.TESTFIELD(Blocked, FALSE);
            IF "Bill-to IC Partner Code" <> '' THEN
                IF ICPartner.GET("Bill-to IC Partner Code") THEN
                    ICPartner.TESTFIELD(Blocked, FALSE);
        END;
    END;

    LOCAL PROCEDURE SendICDocument(VAR SalesHeader: Record 36; VAR ModifyHeader: Boolean);
    VAR
        ICInboxOutboxMgt: Codeunit 427;
    BEGIN
        WITH SalesHeader DO
            IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
               ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"])
            THEN BEGIN
                ICInboxOutboxMgt.SendSalesDoc(SalesHeader, TRUE);
                "IC Status" := "IC Status"::Pending;
                ModifyHeader := TRUE;
            END;
    END;

    LOCAL PROCEDURE UpdateHandledICInboxTransaction(SalesHeader: Record 36);
    VAR
        HandledICInboxTrans: Record 420;
        Customer: Record 18;
    BEGIN
        WITH SalesHeader DO
            IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
                HandledICInboxTrans.SETRANGE("Document No.", "External Document No.");
                Customer.GET("Sell-to Customer No.");
                HandledICInboxTrans.SETRANGE("IC Partner Code", Customer."IC Partner Code");
                HandledICInboxTrans.LOCKTABLE;
                IF HandledICInboxTrans.FINDFIRST THEN BEGIN
                    HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
                    HandledICInboxTrans.MODIFY;
                END;
            END;
    END;

    //[External]
    PROCEDURE GetPostedDocumentRecord(SalesHeader: Record 36; VAR PostedSalesDocumentVariant: Variant);
    VAR
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
    BEGIN
        WITH SalesHeader DO
            CASE "Document Type" OF
                "Document Type"::Order:
                    IF Invoice THEN BEGIN
                        SalesInvHeader.GET("Last Posting No.");
                        SalesInvHeader.SETRECFILTER;
                        PostedSalesDocumentVariant := SalesInvHeader;
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        IF "Last Posting No." = '' THEN
                            SalesInvHeader.GET("No.")
                        ELSE
                            SalesInvHeader.GET("Last Posting No.");

                        SalesInvHeader.SETRECFILTER;
                        PostedSalesDocumentVariant := SalesInvHeader;
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF "Last Posting No." = '' THEN
                            SalesCrMemoHeader.GET("No.")
                        ELSE
                            SalesCrMemoHeader.GET("Last Posting No.");
                        SalesCrMemoHeader.SETRECFILTER;
                        PostedSalesDocumentVariant := SalesCrMemoHeader;
                    END;
                "Document Type"::"Return Order":
                    IF Invoice THEN BEGIN
                        IF "Last Posting No." = '' THEN
                            SalesCrMemoHeader.GET("No.")
                        ELSE
                            SalesCrMemoHeader.GET("Last Posting No.");
                        SalesCrMemoHeader.SETRECFILTER;
                        PostedSalesDocumentVariant := SalesCrMemoHeader;
                    END;
                ELSE
                    ERROR(NotSupportedDocumentTypeErr, "Document Type");
            END;
    END;

    //[Internal]
    PROCEDURE SendPostedDocumentRecord(SalesHeader: Record 36; VAR DocumentSendingProfile: Record 60);
    VAR
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        SalesShipmentHeader: Record 110;
        OfficeManagement: Codeunit 1630;
        ConfirmManagement: Codeunit 50206;
    BEGIN
        WITH SalesHeader DO
            CASE "Document Type" OF
                "Document Type"::Order:
                    BEGIN
                        OnSendSalesDocument(Invoice AND Ship, SuppressCommit);
                        IF Invoice THEN BEGIN
                            SalesInvHeader.GET("Last Posting No.");
                            SalesInvHeader.SETRECFILTER;
                            SalesInvHeader.SendProfile(DocumentSendingProfile);
                        END;
                        IF Ship AND Invoice AND NOT OfficeManagement.IsAvailable THEN
                            IF NOT ConfirmManagement.ConfirmProcess(DownloadShipmentAlsoQst, TRUE) THEN
                                EXIT;
                        IF Ship THEN BEGIN
                            SalesShipmentHeader.GET("Last Shipping No.");
                            SalesShipmentHeader.SETRECFILTER;
                            SalesShipmentHeader.SendProfile(DocumentSendingProfile);
                        END;
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        IF "Last Posting No." = '' THEN
                            SalesInvHeader.GET("No.")
                        ELSE
                            SalesInvHeader.GET("Last Posting No.");

                        SalesInvHeader.SETRECFILTER;
                        SalesInvHeader.SendProfile(DocumentSendingProfile);
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF "Last Posting No." = '' THEN
                            SalesCrMemoHeader.GET("No.")
                        ELSE
                            SalesCrMemoHeader.GET("Last Posting No.");
                        SalesCrMemoHeader.SETRECFILTER;
                        SalesCrMemoHeader.SendProfile(DocumentSendingProfile);
                    END;
                "Document Type"::"Return Order":
                    IF Invoice THEN BEGIN
                        IF "Last Posting No." = '' THEN
                            SalesCrMemoHeader.GET("No.")
                        ELSE
                            SalesCrMemoHeader.GET("Last Posting No.");
                        SalesCrMemoHeader.SETRECFILTER;
                        SalesCrMemoHeader.SendProfile(DocumentSendingProfile);
                    END;
                ELSE
                    ERROR(NotSupportedDocumentTypeErr, "Document Type");
            END;
    END;

    LOCAL PROCEDURE MakeInventoryAdjustment();
    VAR
        InvtSetup: Record 313;
        InvtAdjmt: Codeunit 5895;
    BEGIN
        InvtSetup.GET;
        IF InvtSetup."Automatic Cost Adjustment" <>
           InvtSetup."Automatic Cost Adjustment"::Never
        THEN BEGIN
            InvtAdjmt.SetProperties(TRUE, InvtSetup."Automatic Cost Posting");
            InvtAdjmt.SetJobUpdateProperties(TRUE);
            InvtAdjmt.MakeMultiLevelAdjmt;
        END;
    END;

    LOCAL PROCEDURE FindNotShippedLines(SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            SETFILTER(Quantity, '<>0');
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                SETFILTER("Qty. to Ship", '<>0');
            SETRANGE("Shipment No.", '');
        END;
    END;

    PROCEDURE TestSalesEfects(SalesHeader: Record 36; Cust: Record 18);
    VAR
        CustLedgEntry: Record 21;
        Text1100000: TextConst ENU = 'At least one document of %1 No. %2 is closed or in a Bill Group.', ESP = 'Al menos un documento de %1 No. %2 est  cerrado o en una remesa.';
        Text1100001: TextConst ENU = 'This will avoid the document to be settled.\', ESP = 'Esto evita que el documento sea liquidado.\';
        Text1100002: TextConst ENU = 'The posting process of %3 No. %4 will not settle any document.\', ESP = 'El registro de %3 n§ %4 no liquidar  ning£n documento.\';
        ShowError: Boolean;
        Text1100003: TextConst ENU = 'Please remove the lines for the Bill Group before posting.', ESP = 'Elimine las l¡neas para la Remesa antes del registro.';
    BEGIN
        ShowError := FALSE;
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            CustLedgEntry.SETFILTER("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice,
              CustLedgEntry."Document Type"::Bill);
            CustLedgEntry.SETFILTER("Document Situation", '<>%1', CustLedgEntry."Document Situation"::" ");
            CustLedgEntry.SETRANGE("Customer No.", SalesHeader."Bill-to Customer No.");
            CustLedgEntry.SETRANGE(Open, TRUE);

            IF CustLedgEntry.FIND('-') THEN
                REPEAT
                    IF CustLedgEntry."Document Situation" <> CustLedgEntry."Document Situation"::Cartera THEN
                        IF NOT ((CustLedgEntry."Document Situation" IN
                                 [CustLedgEntry."Document Situation"::"Closed Documents",
                                  CustLedgEntry."Document Situation"::"Closed BG/PO"]) AND
                                (CustLedgEntry."Document Status" = CustLedgEntry."Document Status"::Rejected))
                        THEN
                            ShowError := TRUE;
                UNTIL CustLedgEntry.NEXT = 0;

            IF ShowError THEN
                ERROR(Text1100000 +
                  Text1100001 +
                  Text1100002 +
                  Text1100003,
                  FORMAT(CustLedgEntry."Document Type"),
                  FORMAT(CustLedgEntry."Document No."),
                  FORMAT(SalesHeader."Document Type"),
                  FORMAT(SalesHeader."No."));
        END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForShip(SalesHeader: Record 36) Ship: Boolean;
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        SalesPost: codeunit 50004;
    BEGIN
        WITH TempSalesLine DO BEGIN
            FindNotShippedLines(SalesHeader, TempSalesLine);
            Ship := FINDFIRST;
            WhseShip := TempWhseShptHeader.FINDFIRST;
            WhseReceive := TempWhseRcptHeader.FINDFIRST;
            OnCheckTrackingAndWarehouseForShipOnBeforeCheck(SalesHeader, TempWhseShptHeader, TempWhseRcptHeader, Ship, TempSalesLine);
            IF Ship THEN BEGIN
                CheckTrackingSpecification(SalesHeader, TempSalesLine);
                IF NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
                    SalesPost.CheckWarehouse(TempSalesLine);
            END;
            OnAfterCheckTrackingAndWarehouseForShip(SalesHeader, Ship, SuppressCommit, TempWhseShptHeader, TempWhseRcptHeader, TempSalesLine);
            EXIT(Ship);
        END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForReceive(SalesHeader: Record 36) Receive: Boolean;
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        SalesPost: codeunit 50004;
    BEGIN
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            SETFILTER(Quantity, '<>0');
            SETFILTER("Return Qty. to Receive", '<>0');
            SETRANGE("Return Receipt No.", '');
            Receive := FINDFIRST;
            WhseShip := TempWhseShptHeader.FINDFIRST;
            WhseReceive := TempWhseRcptHeader.FINDFIRST;
            OnCheckTrackingAndWarehouseForReceiveOnBeforeCheck(SalesHeader, TempWhseShptHeader, TempWhseRcptHeader, Receive);
            IF Receive THEN BEGIN
                CheckTrackingSpecification(SalesHeader, TempSalesLine);
                IF NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
                    SalesPost.CheckWarehouse(TempSalesLine);
            END;
            OnAfterCheckTrackingAndWarehouseForReceive(SalesHeader, Receive, SuppressCommit, TempWhseShptHeader, TempWhseRcptHeader);
            EXIT(Receive);
        END;
    END;

    LOCAL PROCEDURE CheckIfInvPickExists(SalesHeader: Record 36): Boolean;
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        WarehouseActivityLine: Record 5767;
    BEGIN
        WITH TempSalesLine DO BEGIN
            FindNotShippedLines(SalesHeader, TempSalesLine);
            IF ISEMPTY THEN
                EXIT(FALSE);
            FINDSET;
            REPEAT
                IF WarehouseActivityLine.ActivityExists(
                     DATABASE::"Sales Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0,//enum to option
                     WarehouseActivityLine."Activity Type"::"Invt. Pick".AsInteger())//enum to option
                THEN
                    EXIT(TRUE);
            UNTIL NEXT = 0;
            EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE CheckIfInvPutawayExists(): Boolean;
    VAR
        TempSalesLine: Record 37 TEMPORARY;
        WarehouseActivityLine: Record 5767;
    BEGIN
        WITH TempSalesLine DO BEGIN
            ResetTempLines(TempSalesLine);
            SETFILTER(Quantity, '<>0');
            SETFILTER("Return Qty. to Receive", '<>0');
            SETRANGE("Return Receipt No.", '');
            IF ISEMPTY THEN
                EXIT(FALSE);
            FINDSET;
            REPEAT
                IF WarehouseActivityLine.ActivityExists(
                     DATABASE::"Sales Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0,//enum to option
                     WarehouseActivityLine."Activity Type"::"Invt. Put-away".AsInteger())//enum to option
                THEN
                    EXIT(TRUE);
            UNTIL NEXT = 0;
            EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE CalcInvoiceDiscountPosting(SalesHeader: Record 36; SalesLine: Record 37; SalesLineACY: Record 37; VAR InvoicePostBuffer: Record 55);
    BEGIN
        IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
            InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Inv. Discount Amount", -SalesLineACY."Inv. Discount Amount")
        ELSE
            InvoicePostBuffer.CalcDiscount(
              SalesHeader."Prices Including VAT", -SalesLine."Inv. Discount Amount", -SalesLineACY."Inv. Discount Amount");
    END;

    LOCAL PROCEDURE CalcLineDiscountPosting(SalesHeader: Record 36; SalesLine: Record 37; SalesLineACY: Record 37; VAR InvoicePostBuffer: Record 55);
    BEGIN
        IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
            InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Line Discount Amount", -SalesLineACY."Line Discount Amount")
        ELSE
            InvoicePostBuffer.CalcDiscount(
              SalesHeader."Prices Including VAT", -SalesLine."Line Discount Amount", -SalesLineACY."Line Discount Amount");
    END;

    LOCAL PROCEDURE FindTempItemChargeAssgntSales(SalesLineNo: Integer): Boolean;
    BEGIN
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.SETCURRENTKEY("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SETRANGE("Document Line No.", SalesLineNo);
        EXIT(TempItemChargeAssgntSales.FINDSET);
    END;

    LOCAL PROCEDURE UpdateInvoicedQtyOnShipmentLine(VAR SalesShptLine: Record 111; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
        WITH SalesShptLine DO BEGIN
            "Quantity Invoiced" := "Quantity Invoiced" - QtyToBeInvoiced;
            "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
            "Qty. Shipped Not Invoiced" := Quantity - "Quantity Invoiced";
            MODIFY;
        END;
    END;

    //[External]
    // PROCEDURE SetPreviewMode(NewPreviewMode: Boolean);
    // BEGIN
    //     PreviewMode := NewPreviewMode;
    // END;

    LOCAL PROCEDURE PostDropOrderShipment(VAR SalesHeader: Record 36; VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        PurchSetup: Record 312;
        PurchCommentLine: Record 43;
        PurchOrderHeader: Record 38;
        PurchOrderLine: Record 39;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        ArchivePurchaseOrders(TempDropShptPostBuffer);
        WITH SalesHeader DO
            IF TempDropShptPostBuffer.FINDSET THEN BEGIN
                PurchSetup.GET;
                REPEAT
                    PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order, TempDropShptPostBuffer."Order No.");
                    InsertPurchRcptHeader(PurchOrderHeader, SalesHeader, PurchRcptHeader);
                    ApprovalsMgmt.PostApprovalEntries(RECORDID, PurchRcptHeader.RECORDID, PurchRcptHeader."No.");
                    IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
                        PurchCommentLine.CopyComments(
                          PurchOrderHeader."Document Type".AsInteger(), PurchCommentLine."Document Type"::Receipt.AsInteger(),
                          PurchOrderHeader."No.", PurchRcptHeader."No.");
                        RecordLinkManagement.CopyLinks(PurchOrderHeader, PurchRcptHeader);
                    END;
                    TempDropShptPostBuffer.SETRANGE("Order No.", TempDropShptPostBuffer."Order No.");
                    REPEAT
                        PurchOrderLine.GET(
                          PurchOrderLine."Document Type"::Order,
                          TempDropShptPostBuffer."Order No.", TempDropShptPostBuffer."Order Line No.");
                        InsertPurchRcptLine(PurchRcptHeader, PurchOrderLine, TempDropShptPostBuffer);
                        PurchPost.UpdateBlanketOrderLine(PurchOrderLine, TRUE, FALSE, FALSE);
                    UNTIL TempDropShptPostBuffer.NEXT = 0;
                    TempDropShptPostBuffer.SETRANGE("Order No.");
                    OnAfterInsertDropOrderPurchRcptHeader(PurchRcptHeader);
                UNTIL TempDropShptPostBuffer.NEXT = 0;
            END;
    END;

    LOCAL PROCEDURE PostInvoicePostBuffer(SalesHeader: Record 36; VAR TempInvoicePostBuffer: Record 55 TEMPORARY);
    VAR
        LineCount: Integer;
        GLEntryNo: Integer;
    BEGIN
        LineCount := 0;
        IF TempInvoicePostBuffer.FIND('+') THEN
            REPEAT
                LineCount := LineCount + 1;
                IF GUIALLOWED THEN
                    Window.UPDATE(3, LineCount);

                GLEntryNo := PostInvoicePostBufferLine(SalesHeader, TempInvoicePostBuffer);

                IF (TempInvoicePostBuffer."Job No." <> '') AND
                   (TempInvoicePostBuffer.Type = TempInvoicePostBuffer.Type::"G/L Account")
                THEN
                    JobPostLine.PostSalesGLAccounts(TempInvoicePostBuffer, GLEntryNo);

            UNTIL TempInvoicePostBuffer.NEXT(-1) = 0;

        TempInvoicePostBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE PostInvoicePostBufferLine(SalesHeader: Record 36; InvoicePostBuffer: Record 55) GLEntryNo: Integer;
    VAR
        GenJnlLine: Record 81;
    BEGIN
        WITH GenJnlLine DO BEGIN
            InitNewLine(
              SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
              InvoicePostBuffer."Global Dimension 1 Code", InvoicePostBuffer."Global Dimension 2 Code",
              InvoicePostBuffer."Dimension Set ID", SalesHeader."Reason Code");

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType), GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, '');

            CopyFromSalesHeader(SalesHeader);

            CopyFromInvoicePostBuffer(InvoicePostBuffer);
            IF InvoicePostBuffer.Type <> InvoicePostBuffer.Type::"Prepmt. Exch. Rate Difference" THEN
                "Gen. Posting Type" := "Gen. Posting Type"::Sale;
            IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
                "FA Posting Type" := "FA Posting Type"::Disposal;
                CopyFromInvoicePostBufferFA(InvoicePostBuffer);
            END;

            // +QB
            QBCodeunitSubscriber.ModifyGenJnlLine_CU80(GenJnlLine, SalesHeader, InvoicePostBuffer."Job No.");
            // -QB

            OnBeforePostInvPostBuffer(GenJnlLine, InvoicePostBuffer, SalesHeader, SuppressCommit, GenJnlPostLine, PreviewMode);
            GLEntryNo := RunGenJnlPostLine(GenJnlLine);
            OnAfterPostInvPostBuffer(GenJnlLine, InvoicePostBuffer, SalesHeader, GLEntryNo, SuppressCommit, GenJnlPostLine);
        END;
    END;

    LOCAL PROCEDURE PostItemTracking(SalesHeader: Record 36; SalesLine: Record 37; TrackingSpecificationExists: Boolean; VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR TempItemLedgEntryNotInvoiced: Record 32 TEMPORARY; HasATOShippedNotInvoiced: Boolean);
    VAR
        QtyToInvoiceBaseInTrackingSpec: Decimal;
    BEGIN
        WITH SalesHeader DO BEGIN
            IF TrackingSpecificationExists THEN BEGIN
                TempTrackingSpecification.CALCSUMS("Qty. to Invoice (Base)");
                QtyToInvoiceBaseInTrackingSpec := TempTrackingSpecification."Qty. to Invoice (Base)";
                IF NOT TempTrackingSpecification.FINDFIRST THEN
                    TempTrackingSpecification.INIT;
            END;

            IF SalesLine.IsCreditDocType THEN BEGIN
                IF (ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive")) OR
                   (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
                THEN
                    PostItemTrackingForReceipt(
                      SalesHeader, SalesLine, TrackingSpecificationExists, TempTrackingSpecification);

                IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive") THEN BEGIN
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                        ERROR(InvoiceGreaterThanReturnReceiptErr, SalesLine."Return Receipt No.");
                    ERROR(ReturnReceiptLinesDeletedErr);
                END;
            END ELSE BEGIN
                IF (ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship")) OR
                   (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
                THEN
                    PostItemTrackingForShipment(
                      SalesHeader, SalesLine, TrackingSpecificationExists, TempTrackingSpecification,
                      TempItemLedgEntryNotInvoiced, HasATOShippedNotInvoiced);

                IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship") THEN BEGIN
                    IF "Document Type" = "Document Type"::Invoice THEN
                        ERROR(QuantityToInvoiceGreaterErr, SalesLine."Shipment No.");
                    ERROR(ShipmentLinesDeletedErr);
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE PostItemTrackingForReceipt(SalesHeader: Record 36; SalesLine: Record 37; TrackingSpecificationExists: Boolean; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    VAR
        ItemEntryRelation: Record 6507;
        ReturnRcptLine: Record 6661;
        SalesShptLine: Record 111;
        EndLoop: Boolean;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
    BEGIN
        WITH SalesHeader DO BEGIN
            EndLoop := FALSE;
            ReturnRcptLine.RESET;
            CASE "Document Type" OF
                "Document Type"::"Return Order":
                    BEGIN
                        ReturnRcptLine.SETCURRENTKEY("Return Order No.", "Return Order Line No.");
                        ReturnRcptLine.SETRANGE("Return Order No.", SalesLine."Document No.");
                        ReturnRcptLine.SETRANGE("Return Order Line No.", SalesLine."Line No.");
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        ReturnRcptLine.SETRANGE("Document No.", SalesLine."Return Receipt No.");
                        ReturnRcptLine.SETRANGE("Line No.", SalesLine."Return Receipt Line No.");
                    END;
            END;
            ReturnRcptLine.SETFILTER("Return Qty. Rcd. Not Invd.", '<>0');
            IF ReturnRcptLine.FIND('-') THEN BEGIN
                ItemJnlRollRndg := TRUE;
                REPEAT
                    IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
                        ItemEntryRelation.GET(TempTrackingSpecification."Item Ledger Entry No.");
                        ReturnRcptLine.GET(ItemEntryRelation."Source ID", ItemEntryRelation."Source Ref. No.");
                    END ELSE
                        ItemEntryRelation."Item Entry No." := ReturnRcptLine."Item Rcpt. Entry No.";
                    ReturnRcptLine.TESTFIELD("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                    ReturnRcptLine.TESTFIELD(Type, SalesLine.Type);
                    ReturnRcptLine.TESTFIELD("No.", SalesLine."No.");
                    ReturnRcptLine.TESTFIELD("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
                    ReturnRcptLine.TESTFIELD("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
                    ReturnRcptLine.TESTFIELD("Job No.", SalesLine."Job No.");
                    ReturnRcptLine.TESTFIELD("Unit of Measure Code", SalesLine."Unit of Measure Code");
                    ReturnRcptLine.TESTFIELD("Variant Code", SalesLine."Variant Code");
                    IF SalesLine."Qty. to Invoice" * ReturnRcptLine.Quantity < 0 THEN
                        SalesLine.FIELDERROR("Qty. to Invoice", ReturnReceiptSameSignErr);
                    UpdateQtyToBeInvoicedForReturnReceipt(
                      QtyToBeInvoiced, QtyToBeInvoicedBase,
                      TrackingSpecificationExists, SalesLine, ReturnRcptLine, TempTrackingSpecification);

                    IF TrackingSpecificationExists THEN BEGIN
                        TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                        TempTrackingSpecification.MODIFY;
                    END;

                    IF TrackingSpecificationExists THEN
                        ItemTrackingMgt.AdjustQuantityRounding(
                          RemQtyToBeInvoiced, QtyToBeInvoiced,
                          RemQtyToBeInvoicedBase, QtyToBeInvoicedBase);

                    RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                    RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                    ReturnRcptLine."Quantity Invoiced" :=
                      ReturnRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
                    ReturnRcptLine."Qty. Invoiced (Base)" :=
                      ReturnRcptLine."Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
                    ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
                      ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                    ReturnRcptLine.MODIFY;
                    IF SalesLine.Type = SalesLine.Type::Item THEN
                        PostItemJnlLine(
                          SalesHeader, SalesLine,
                          0, 0,
                          QtyToBeInvoiced,
                          QtyToBeInvoicedBase,
                          // ReturnRcptLine."Item Rcpt. Entry No."
                          ItemEntryRelation."Item Entry No.", '', TempTrackingSpecification, FALSE);
                    OnAfterPostItemTrackingReturnRcpt(
                      SalesInvHeader, SalesShptLine, TempTrackingSpecification, TrackingSpecificationExists,
                      SalesCrMemoHeader, ReturnRcptLine, SalesLine, QtyToBeInvoiced, QtyToBeInvoicedBase);
                    IF TrackingSpecificationExists THEN
                        EndLoop := (TempTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0)
                    ELSE
                        EndLoop :=
                          (ReturnRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Return Qty. to Receive"));
                UNTIL EndLoop;
            END ELSE
                ERROR(
                  ReturnReceiptInvoicedErr,
                  SalesLine."Return Receipt Line No.", SalesLine."Return Receipt No.");
        END;
    END;

    LOCAL PROCEDURE PostItemTrackingForShipment(SalesHeader: Record 36; SalesLine: Record 37; TrackingSpecificationExists: Boolean; VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR TempItemLedgEntryNotInvoiced: Record 32 TEMPORARY; HasATOShippedNotInvoiced: Boolean);
    VAR
        ItemEntryRelation: Record 6507;
        SalesShptLine: Record 111;
        RemQtyToInvoiceCurrLine: Decimal;
        RemQtyToInvoiceCurrLineBase: Decimal;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
    BEGIN
        WITH SalesHeader DO BEGIN
            SalesShptLine.RESET;
            CASE "Document Type" OF
                "Document Type"::Order:
                    BEGIN
                        SalesShptLine.SETCURRENTKEY("Order No.", "Order Line No.");
                        SalesShptLine.SETRANGE("Order No.", SalesLine."Document No.");
                        SalesShptLine.SETRANGE("Order Line No.", SalesLine."Line No.");
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        SalesShptLine.SETRANGE("Document No.", SalesLine."Shipment No.");
                        SalesShptLine.SETRANGE("Line No.", SalesLine."Shipment Line No.");
                    END;
            END;

            IF NOT TrackingSpecificationExists THEN
                HasATOShippedNotInvoiced := GetATOItemLedgEntriesNotInvoiced(SalesLine, TempItemLedgEntryNotInvoiced);

            SalesShptLine.SETFILTER("Qty. Shipped Not Invoiced", '<>0');
            IF SalesShptLine.FINDFIRST THEN BEGIN
                ItemJnlRollRndg := TRUE;
                REPEAT
                    SetItemEntryRelation(
                      ItemEntryRelation, SalesShptLine,
                      TempTrackingSpecification, TempItemLedgEntryNotInvoiced,
                      TrackingSpecificationExists, HasATOShippedNotInvoiced);

                    UpdateRemainingQtyToBeInvoiced(SalesShptLine, RemQtyToInvoiceCurrLine, RemQtyToInvoiceCurrLineBase);

                    SalesShptLine.TESTFIELD("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                    SalesShptLine.TESTFIELD(Type, SalesLine.Type);
                    SalesShptLine.TESTFIELD("No.", SalesLine."No.");
                    SalesShptLine.TESTFIELD("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
                    SalesShptLine.TESTFIELD("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
                    SalesShptLine.TESTFIELD("Job No.", SalesLine."Job No.");
                    SalesShptLine.TESTFIELD("Unit of Measure Code", SalesLine."Unit of Measure Code");
                    SalesShptLine.TESTFIELD("Variant Code", SalesLine."Variant Code");
                    IF -SalesLine."Qty. to Invoice" * SalesShptLine.Quantity < 0 THEN
                        SalesLine.FIELDERROR("Qty. to Invoice", ShipmentSameSignErr);

                    UpdateQtyToBeInvoicedForShipment(
                      QtyToBeInvoiced, QtyToBeInvoicedBase,
                      TrackingSpecificationExists, HasATOShippedNotInvoiced,
                      SalesLine, SalesShptLine,
                      TempTrackingSpecification, TempItemLedgEntryNotInvoiced);

                    IF TrackingSpecificationExists THEN BEGIN
                        TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                        TempTrackingSpecification.MODIFY;
                    END;

                    IF TrackingSpecificationExists OR HasATOShippedNotInvoiced THEN
                        ItemTrackingMgt.AdjustQuantityRounding(
                          RemQtyToInvoiceCurrLine, QtyToBeInvoiced,
                          RemQtyToInvoiceCurrLineBase, QtyToBeInvoicedBase);

                    RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                    RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                    OnBeforeUpdateInvoicedQtyOnShipmentLine(SalesShptLine, SalesLine, SalesHeader, SalesInvHeader, SuppressCommit);
                    UpdateInvoicedQtyOnShipmentLine(SalesShptLine, QtyToBeInvoiced, QtyToBeInvoicedBase);
                    OnInvoiceSalesShptLine(SalesShptLine, SalesInvHeader."No.", SalesLine."Line No.", -QtyToBeInvoiced, SuppressCommit);
                    IF SalesLine.Type = SalesLine.Type::Item THEN
                        PostItemJnlLine(
                          SalesHeader, SalesLine,
                          0, 0,
                          QtyToBeInvoiced,
                          QtyToBeInvoicedBase,
                          // SalesShptLine."Item Shpt. Entry No."
                          ItemEntryRelation."Item Entry No.", '', TempTrackingSpecification, FALSE);

                    OnAfterPostItemTrackingForShipment(
                      SalesInvHeader, SalesShptLine, TempTrackingSpecification, TrackingSpecificationExists, SalesLine,
                      QtyToBeInvoiced, QtyToBeInvoicedBase);
                UNTIL IsEndLoopForShippedNotInvoiced(
                        RemQtyToBeInvoiced, TrackingSpecificationExists, HasATOShippedNotInvoiced,
                        SalesShptLine, TempTrackingSpecification, TempItemLedgEntryNotInvoiced, SalesLine);
            END ELSE
                ERROR(
                  ShipmentInvoiceErr, SalesLine."Shipment Line No.", SalesLine."Shipment No.");
        END;
    END;

    LOCAL PROCEDURE PostUpdateOrderLine(SalesHeader: Record 36);
    VAR
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        OnBeforePostUpdateOrderLine(SalesHeader, TempSalesLineGlobal, SuppressCommit);

        ResetTempLines(TempSalesLine);
        WITH TempSalesLine DO BEGIN
            SETRANGE("Prepayment Line", FALSE);
            SETFILTER(Quantity, '<>0');
            IF FINDSET THEN
                REPEAT
                    OnPostUpdateOrderLineOnBeforeInitTempSalesLineQuantities(SalesHeader, TempSalesLine);
                    IF SalesHeader.Ship THEN BEGIN
                        "Quantity Shipped" += "Qty. to Ship";
                        "Qty. Shipped (Base)" += "Qty. to Ship (Base)";
                    END;
                    IF SalesHeader.Receive THEN BEGIN
                        "Return Qty. Received" += "Return Qty. to Receive";
                        "Return Qty. Received (Base)" += "Return Qty. to Receive (Base)";
                    END;
                    IF SalesHeader.Invoice THEN BEGIN
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Quantity Shipped") THEN BEGIN
                                VALIDATE("Qty. to Invoice", "Quantity Shipped" - "Quantity Invoiced");
                                "Qty. to Invoice (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
                            END
                        END ELSE
                            IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Return Qty. Received") THEN BEGIN
                                VALIDATE("Qty. to Invoice", "Return Qty. Received" - "Quantity Invoiced");
                                "Qty. to Invoice (Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
                            END;

                        "Quantity Invoiced" += "Qty. to Invoice";
                        "Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
                        IF "Qty. to Invoice" <> 0 THEN BEGIN
                            "Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                            "Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                            DecrementPrepmtAmtInvLCY(
                              TempSalesLine, "Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
                            "Prepmt Amt to Deduct" := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
                            "Prepmt VAT Diff. to Deduct" := 0;
                        END;
                    END;

                    UpdateBlanketOrderLine(TempSalesLine, SalesHeader.Ship, SalesHeader.Receive, SalesHeader.Invoice);
                    InitOutstanding;
                    CheckATOLink(TempSalesLine);
                    IF WhseHandlingRequired(TempSalesLine) OR
                       (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank)
                    THEN BEGIN
                        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                            "Return Qty. to Receive" := 0;
                            "Return Qty. to Receive (Base)" := 0;
                        END ELSE BEGIN
                            "Qty. to Ship" := 0;
                            "Qty. to Ship (Base)" := 0;
                        END;
                        InitQtyToInvoice;
                    END ELSE BEGIN
                        IF "Document Type" = "Document Type"::"Return Order" THEN
                            InitQtyToReceive
                        ELSE
                            InitQtyToShip2;
                    END;

                    IF ("Purch. Order Line No." <> 0) AND (Quantity = "Quantity Invoiced") THEN
                        UpdateAssocLines(TempSalesLine);
                    SetDefaultQuantity;
                    ModifyTempLine(TempSalesLine);

                    OnAfterPostUpdateOrderLineModifyTempLine(TempSalesLine, WhseShip, WhseReceive, SuppressCommit);
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostUpdateInvoiceLine();
    VAR
        SalesOrderLine: Record 37;
        SalesShptLine: Record 111;
        TempSalesLine: Record 37 TEMPORARY;
        TempSalesOrderHeader: Record 36 TEMPORARY;
        CRMSalesDocumentPostingMgt: Codeunit 5346;
    BEGIN
        ResetTempLines(TempSalesLine);
        WITH TempSalesLine DO BEGIN
            SETFILTER("Shipment No.", '<>%1', '');
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    SalesShptLine.GET("Shipment No.", "Shipment Line No.");
                    SalesOrderLine.GET(
                      SalesOrderLine."Document Type"::Order,
                      SalesShptLine."Order No.", SalesShptLine."Order Line No.");
                    IF Type = Type::"Charge (Item)" THEN
                        UpdateSalesOrderChargeAssgnt(TempSalesLine, SalesOrderLine);
                    SalesOrderLine."Quantity Invoiced" += "Qty. to Invoice";
                    SalesOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
                    IF ABS(SalesOrderLine."Quantity Invoiced") > ABS(SalesOrderLine."Quantity Shipped") THEN
                        ERROR(InvoiceMoreThanShippedErr, SalesOrderLine."Document No.");
                    SalesOrderLine.InitQtyToInvoice;
                    IF SalesOrderLine."Prepayment %" <> 0 THEN BEGIN
                        SalesOrderLine."Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                        SalesOrderLine."Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                        DecrementPrepmtAmtInvLCY(
                          TempSalesLine, SalesOrderLine."Prepmt. Amount Inv. (LCY)", SalesOrderLine."Prepmt. VAT Amount Inv. (LCY)");
                        SalesOrderLine."Prepmt Amt to Deduct" :=
                          SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted";
                        SalesOrderLine."Prepmt VAT Diff. to Deduct" := 0;
                    END;
                    SalesOrderLine.InitOutstanding;
                    SalesOrderLine.MODIFY;
                    IF NOT TempSalesOrderHeader.GET(SalesOrderLine."Document Type", SalesOrderLine."Document No.") THEN BEGIN
                        TempSalesOrderHeader."Document Type" := SalesOrderLine."Document Type";
                        TempSalesOrderHeader."No." := SalesOrderLine."Document No.";
                        TempSalesOrderHeader.INSERT;
                    END;
                UNTIL NEXT = 0;
            CRMSalesDocumentPostingMgt.CheckShippedOrders(TempSalesOrderHeader);
        END;
    END;

    LOCAL PROCEDURE PostUpdateReturnReceiptLine();
    VAR
        SalesOrderLine: Record 37;
        ReturnRcptLine: Record 6661;
        TempSalesLine: Record 37 TEMPORARY;
    BEGIN
        ResetTempLines(TempSalesLine);
        WITH TempSalesLine DO BEGIN
            SETFILTER("Return Receipt No.", '<>%1', '');
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    ReturnRcptLine.GET("Return Receipt No.", "Return Receipt Line No.");
                    SalesOrderLine.GET(
                      SalesOrderLine."Document Type"::"Return Order",
                      ReturnRcptLine."Return Order No.", ReturnRcptLine."Return Order Line No.");
                    IF Type = Type::"Charge (Item)" THEN
                        UpdateSalesOrderChargeAssgnt(TempSalesLine, SalesOrderLine);
                    SalesOrderLine."Quantity Invoiced" += "Qty. to Invoice";
                    SalesOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
                    IF ABS(SalesOrderLine."Quantity Invoiced") > ABS(SalesOrderLine."Return Qty. Received") THEN
                        ERROR(InvoiceMoreThanReceivedErr, SalesOrderLine."Document No.");
                    SalesOrderLine.InitQtyToInvoice;
                    SalesOrderLine.InitOutstanding;
                    SalesOrderLine.MODIFY;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE FillDeferralPostingBuffer(SalesHeader: Record 36; SalesLine: Record 37; InvoicePostBuffer: Record 49; RemainAmtToDefer: Decimal; RemainAmtToDeferACY: Decimal; DeferralAccount: Code[20]; SalesAccount: Code[20]);
    VAR
        DeferralTemplate: Record 1700;
    BEGIN
        DeferralTemplate.GET(SalesLine."Deferral Code");

        IF TempDeferralHeader.GET(DeferralUtilities1.GetSalesDeferralDocType, '', '',
             SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
        THEN BEGIN
            IF TempDeferralHeader."Amount to Defer" <> 0 THEN BEGIN
                DeferralUtilities.FilterDeferralLines(
                  TempDeferralLine, DeferralUtilities1.GetSalesDeferralDocType, '', '',
                  SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.");

                // Remainder\Initial deferral pair
                DeferralPostBuffer.PrepareSales(SalesLine, GenJnlLineDocNo);
                DeferralPostBuffer."Posting Date" := SalesHeader."Posting Date";
                DeferralPostBuffer.Description := SalesHeader."Posting Description";
                DeferralPostBuffer."Period Description" := DeferralTemplate."Period Description";
                DeferralPostBuffer."Deferral Line No." := InvDefLineNo;
                DeferralPostBuffer.PrepareInitialPair(
                  InvoicePostBuffer, RemainAmtToDefer, RemainAmtToDeferACY, SalesAccount, DeferralAccount);
                DeferralPostBuffer.Update(DeferralPostBuffer, InvoicePostBuffer);
                IF (RemainAmtToDefer <> 0) OR (RemainAmtToDeferACY <> 0) THEN BEGIN
                    DeferralPostBuffer.PrepareRemainderSales(
                      SalesLine, RemainAmtToDefer, RemainAmtToDeferACY, SalesAccount, DeferralAccount, InvDefLineNo);
                    DeferralPostBuffer.Update(DeferralPostBuffer, InvoicePostBuffer);
                END;

                // Add the deferral lines for each period to the deferral posting buffer merging when they are the same
                IF TempDeferralLine.FINDSET THEN
                    REPEAT
                        IF (TempDeferralLine."Amount (LCY)" <> 0) OR (TempDeferralLine.Amount <> 0) THEN BEGIN
                            DeferralPostBuffer.PrepareSales(SalesLine, GenJnlLineDocNo);
                            DeferralPostBuffer.InitFromDeferralLine(TempDeferralLine);
                            IF NOT SalesLine.IsCreditDocType THEN
                                DeferralPostBuffer.ReverseAmounts;
                            DeferralPostBuffer."G/L Account" := SalesAccount;
                            DeferralPostBuffer."Deferral Account" := DeferralAccount;
                            DeferralPostBuffer."Period Description" := DeferralTemplate."Period Description";
                            DeferralPostBuffer."Deferral Line No." := InvDefLineNo;
                            DeferralPostBuffer.Update(DeferralPostBuffer, InvoicePostBuffer);
                        END ELSE
                            ERROR(ZeroDeferralAmtErr, SalesLine."No.", SalesLine."Deferral Code");

                    UNTIL TempDeferralLine.NEXT = 0

                ELSE
                    ERROR(NoDeferralScheduleErr, SalesLine."No.", SalesLine."Deferral Code");
            END ELSE
                ERROR(NoDeferralScheduleErr, SalesLine."No.", SalesLine."Deferral Code")
        END ELSE
            ERROR(NoDeferralScheduleErr, SalesLine."No.", SalesLine."Deferral Code");
    END;

    LOCAL PROCEDURE RoundDeferralsForArchive(SalesHeader: Record 36; VAR SalesLine: Record 37);
    VAR
        ArchiveManagement: Codeunit 5063;
    BEGIN
        ArchiveManagement.RoundSalesDeferralsForArchive(SalesHeader, SalesLine);
    END;

    LOCAL PROCEDURE GetAmountsForDeferral(SalesLine: Record 37; VAR AmtToDefer: Decimal; VAR AmtToDeferACY: Decimal; VAR DeferralAccount: Code[20]);
    VAR
        DeferralTemplate: Record 1700;
    BEGIN
        DeferralTemplate.GET(SalesLine."Deferral Code");
        DeferralTemplate.TESTFIELD("Deferral Account");
        DeferralAccount := DeferralTemplate."Deferral Account";

        IF TempDeferralHeader.GET(DeferralUtilities1.GetSalesDeferralDocType, '', '',
             SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
        THEN BEGIN
            AmtToDeferACY := TempDeferralHeader."Amount to Defer";
            AmtToDefer := TempDeferralHeader."Amount to Defer (LCY)";
        END;

        IF NOT SalesLine.IsCreditDocType THEN BEGIN
            AmtToDefer := -AmtToDefer;
            AmtToDeferACY := -AmtToDeferACY;
        END;
    END;

    LOCAL PROCEDURE CheckMandatoryHeaderFields(VAR SalesHeader: Record 36);
    BEGIN
        SalesHeader.TESTFIELD("Document Type");
        SalesHeader.TESTFIELD("Sell-to Customer No.");
        SalesHeader.TESTFIELD("Bill-to Customer No.");
        SalesHeader.TESTFIELD("Posting Date");
        SalesHeader.TESTFIELD("Document Date");

        OnAfterCheckMandatoryFields(SalesHeader, SuppressCommit);
    END;

    LOCAL PROCEDURE ClearPostBuffers();
    BEGIN
        CLEAR(WhsePostRcpt);
        CLEAR(WhsePostShpt);
        CLEAR(GenJnlPostLine);
        CLEAR(ResJnlPostLine);
        CLEAR(JobPostLine);
        CLEAR(ItemJnlPostLine);
        CLEAR(WhseJnlPostLine);
    END;

    LOCAL PROCEDURE SetPostingFlags(VAR SalesHeader: Record 36);
    BEGIN
        WITH SalesHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    Receive := FALSE;
                "Document Type"::Invoice:
                    BEGIN
                        Ship := TRUE;
                        Invoice := TRUE;
                        Receive := FALSE;
                    END;
                "Document Type"::"Return Order":
                    Ship := FALSE;
                "Document Type"::"Credit Memo":
                    BEGIN
                        Ship := FALSE;
                        Invoice := TRUE;
                        Receive := TRUE;
                    END;
            END;
            IF NOT (Ship OR Invoice OR Receive) THEN
                ERROR(ShipInvoiceReceiveErr);
        END;
    END;

    //[External]
    // PROCEDURE SetSuppressCommit(NewSuppressCommit: Boolean);
    // BEGIN
    //     SuppressCommit := NewSuppressCommit;
    // END;

    LOCAL PROCEDURE ClearAllVariables();
    BEGIN
        CLEARALL;
        TempSalesLineGlobal.DELETEALL;
        TempItemChargeAssgntSales.DELETEALL;
        TempHandlingSpecification.DELETEALL;
        TempATOTrackingSpecification.DELETEALL;
        TempTrackingSpecification.DELETEALL;
        TempTrackingSpecificationInv.DELETEALL;
        TempWhseSplitSpecification.DELETEALL;
        TempValueEntryRelation.DELETEALL;
        TempICGenJnlLine.DELETEALL;
        TempPrepmtDeductLCYSalesLine.DELETEALL;
        TempSKU.DELETEALL;
        TempDeferralHeader.DELETEALL;
        TempDeferralLine.DELETEALL;
    END;

    LOCAL PROCEDURE CheckAssosOrderLines(SalesHeader: Record 36);
    VAR
        SalesLine: Record 37;
        PurchaseOrderLine: Record 39;
        PurchaseHeader: Record 38;
        TempPurchaseHeader: Record 38 TEMPORARY;
        TempPurchaseLine: Record 39 TEMPORARY;
        DimMgt: Codeunit 408;
        DimMgt2: codeunit 50361;
    BEGIN
        WITH SalesHeader DO BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", "Document Type");
            SalesLine.SETRANGE("Document No.", "No.");
            SalesLine.SETFILTER("Purch. Order Line No.", '<>0');
            IF SalesLine.FINDSET THEN
                REPEAT
                    PurchaseOrderLine.GET(
                      PurchaseOrderLine."Document Type"::Order, SalesLine."Purchase Order No.", SalesLine."Purch. Order Line No.");
                    TempPurchaseLine := PurchaseOrderLine;
                    TempPurchaseLine.INSERT;

                    TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Order;
                    TempPurchaseHeader."No." := SalesLine."Purchase Order No.";
                    IF TempPurchaseHeader.INSERT THEN;
                UNTIL SalesLine.NEXT = 0;
        END;

        IF TempPurchaseHeader.FINDSET THEN
            REPEAT
                PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, TempPurchaseHeader."No.");
                TempPurchaseLine.SETRANGE("Document No.", TempPurchaseHeader."No.");
                DimMgt2.CheckPurchDim(PurchaseHeader, TempPurchaseLine);
            UNTIL TempPurchaseHeader.NEXT = 0;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostLines(VAR SalesLine: Record 37; SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostSalesDoc(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostCommitSalesDoc(VAR SalesHeader: Record 36; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; ModifyHeader: Boolean; CommitIsSuppressed: Boolean; VAR TempSalesLineGlobal: Record 37 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckSalesDoc(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckAndUpdate(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckTrackingAndWarehouseForReceive(VAR SalesHeader: Record 36; VAR Receive: Boolean; CommitIsSuppressed: Boolean; VAR TempWhseShptHeader: Record 7320 TEMPORARY; VAR TempWhseRcptHeader: Record 7316 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckTrackingAndWarehouseForShip(VAR SalesHeader: Record 36; VAR Ship: Boolean; CommitIsSuppressed: Boolean; VAR TempWhseShptHeader: Record 7320 TEMPORARY; VAR TempWhseRcptHeader: Record 7316 TEMPORARY; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreatePostedDeferralScheduleFromSalesDoc(VAR SalesLine: Record 37; VAR PostedDeferralHeader: Record 1704);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterDeleteAfterPosting(SalesHeader: Record 36; SalesInvoiceHeader: Record 112; SalesCrMemoHeader: Record 114; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFillInvoicePostBuffer(VAR InvoicePostBuffer: Record 49; SalesLine: Record 37; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInvoicePostingBufferAssignAmounts(SalesLine: Record 37; VAR TotalAmount: Decimal; VAR TotalAmountLCY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInvoicePostingBufferSetAmounts(VAR InvoicePostBuffer: Record 49; SalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterIncrAmount(VAR TotalSalesLine: Record 37; SalesLine: Record 37; SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitAssocItemJnlLine(VAR ItemJournalLine: Record 83; PurchaseHeader: Record 38; PurchaseLine: Record 39; SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInvoiceRoundingAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; VAR TotalSalesLine: Record 37; UseTempData: Boolean; InvoiceRoundingAmount: Decimal; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertDropOrderPurchRcptHeader(VAR PurchRcptHeader: Record 120);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertedPrepmtVATBaseToDeduct(SalesHeader: Record 36; SalesLine: Record 37; PrepmtLineNo: Integer; TotalPrepmtAmtToDeduct: Decimal; VAR TempPrepmtDeductLCYSalesLine: Record 37 TEMPORARY; VAR PrepmtVATBaseToDeduct: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostSalesDoc(VAR SalesHeader: Record 36; VAR GenJnlPostLine: Codeunit 12; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostSalesDocDropShipment(PurchRcptNo: Code[20]; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostCustomerEntry(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostBalancingEntry(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 55; VAR SalesHeader: Record 36; GLEntryNo: Integer; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostSalesLines(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; WhseShip: Boolean; WhseReceive: Boolean; VAR SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostSalesLine(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePostingNos(VAR SalesHeader: Record 36; VAR NoSeriesMgt: Codeunit 396; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckMandatoryFields(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesInvHeaderInsert(VAR SalesInvHeader: Record 112; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesInvLineInsert(VAR SalesInvLine: Record 113; SalesInvHeader: Record 112; SalesLine: Record 37; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; VAR SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesCrMemoHeaderInsert(VAR SalesCrMemoHeader: Record 114; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesCrMemoLineInsert(VAR SalesCrMemoLine: Record 115; SalesCrMemoHeader: Record 114; VAR SalesHeader: Record 36; SalesLine: Record 37; VAR TempItemChargeAssgntSales: Record 5809 TEMPORARY; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesShptHeaderInsert(VAR SalesShipmentHeader: Record 110; SalesHeader: Record 36; SuppressCommit: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesShptLineInsert(VAR SalesShipmentLine: Record 111; SalesLine: Record 37; ItemShptLedEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; SalesInvoiceHeader: Record 112);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchRcptHeaderInsert(VAR PurchRcptHeader: Record 120; PurchaseHeader: Record 38; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchRcptLineInsert(VAR PurchRcptLine: Record 121; PurchRcptHeader: Record 120; PurchOrderLine: Record 39; DropShptPostBuffer: Record 223; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReturnRcptHeaderInsert(VAR ReturnReceiptHeader: Record 6660; SalesHeader: Record 36; SuppressCommit: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReturnRcptLineInsert(VAR ReturnRcptLine: Record 6661; ReturnRcptHeader: Record 6660; SalesLine: Record 37; ItemShptLedEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; SalesCrMemoHeader: Record 114);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFinalizePosting(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; VAR GenJnlPostLine: Codeunit 12; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFinalizePostingOnBeforeCommit(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; VAR GenJnlPostLine: Codeunit 12; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterResetTempLines(VAR TempSalesLineLocal: Record 37 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFinalizePosting(VAR SalesHeader: Record 36; VAR TempSalesLineGlobal: Record 37 TEMPORARY; VAR EverythingInvoiced: Boolean; SuppressCommit: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertICGenJnlLine(VAR ICGenJournalLine: Record 81; SalesHeader: Record 36; SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertReturnReceiptHeader(SalesHeader: Record 36; VAR ReturnReceiptHeader: Record 6660; VAR Handled: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInvoiceRoundingAmount(SalesHeader: Record 36; TotalAmountIncludingVAT: Decimal; UseTempData: Boolean; VAR InvoiceRoundingAmount: Decimal; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeItemJnlPostLine(VAR ItemJournalLine: Record 83; SalesLine: Record 37; SalesHeader: Record 36; CommitIsSuppressed: Boolean; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeLockTables(VAR SalesHeader: Record 36; PreviewMode: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesLineDeleteAll(VAR SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesShptHeaderInsert(VAR SalesShptHeader: Record 110; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesShptLineInsert(VAR SalesShptLine: Record 111; SalesShptHeader: Record 110; SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesInvHeaderInsert(VAR SalesInvHeader: Record 112; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesInvLineInsert(VAR SalesInvLine: Record 113; SalesInvHeader: Record 112; SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesCrMemoHeaderInsert(VAR SalesCrMemoHeader: Record 114; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesCrMemoLineInsert(VAR SalesCrMemoLine: Record 115; SalesCrMemoHeader: Record 114; SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchRcptHeaderInsert(VAR PurchRcptHeader: Record 120; PurchaseHeader: Record 38; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchRcptLineInsert(VAR PurchRcptLine: Record 121; PurchRcptHeader: Record 120; PurchOrderLine: Record 39; DropShptPostBuffer: Record 223; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeReturnRcptHeaderInsert(VAR ReturnRcptHeader: Record 6660; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeReturnRcptLineInsert(VAR ReturnRcptLine: Record 6661; ReturnRcptHeader: Record 6660; SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostCustomerEntry(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 55; SalesHeader: Record 36; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateCarteraBills(SalesHeader: Record 36; CustLedgerEntry: Record 21; VAR TotalSalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostAssocItemJnlLine(VAR ItemJournalLine: Record 83; PurchaseLine: Record 39; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostItemJnlLine(SalesHeader: Record 36; VAR SalesLine: Record 37; VAR QtyToBeShipped: Decimal; VAR QtyToBeShippedBase: Decimal; VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; VAR ItemLedgShptEntryNo: Integer; VAR ItemChargeNo: Code[20]; VAR TrackingSpecification: Record 336; VAR IsATO: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostItemChargePerOrder(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; VAR ItemJnlLine2: Record 83; VAR ItemChargeSalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostItemJnlLineWhseLine(SalesLine: Record 37; ItemLedgEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostItemTrackingReturnRcpt(VAR SalesInvoiceHeader: Record 112; VAR SalesShipmentLine: Record 111; VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR TrackingSpecificationExists: Boolean; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptLine: Record 6661; SalesLine: Record 37; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostItemTrackingForShipment(VAR SalesInvoiceHeader: Record 112; VAR SalesShipmentLine: Record 111; VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR TrackingSpecificationExists: Boolean; SalesLine: Record 37; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTestSalesLine(SalesHeader: Record 36; SalesLine: Record 37; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostUpdateOrderLineModifyTempLine(SalesLine: Record 37; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostGLAndCustomer(VAR SalesHeader: Record 36; VAR GenJnlPostLine: Codeunit 12; TotalSalesLine: Record 37; TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReverseAmount(VAR SalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetApplyToDocNo(VAR GenJournalLine: Record 81; SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterDivideAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping"; SalesLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRoundAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; SalesLineQty: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdateBlanketOrderLine(VAR BlanketOrderSalesLine: Record 37; SalesLine: Record 37; Ship: Boolean; Receive: Boolean; Invoice: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePrepmtSalesLineWithRounding(VAR PrepmtSalesLine: Record 37; TotalRoundingAmount: ARRAY[2] OF Decimal; TotalPrepmtAmount: ARRAY[2] OF Decimal; FinalInvoice: Boolean; PricesInclVATRoundingAmount: ARRAY[2] OF Decimal; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReleaseSalesDoc(VAR SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeDivideAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; QtyType: Option "General","Invoicing","Shipping"; SalesLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRoundAmount(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; SalesLineQty: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostGLAndCustomer(VAR SalesHeader: Record 36; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR CustLedgerEntry: Record 21; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostUpdateOrderLine(SalesHeader: Record 36; VAR TempSalesLineGlobal: Record 37 TEMPORARY; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeValidatePostingAndDocumentDate(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdateInvoicedQtyOnShipmentLine(VAR SalesShipmentLine: Record 111; SalesLine: Record 37; SalesHeader: Record 36; SalesInvoiceHeader: Record 112; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTestSalesLine(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempPrepmtSalesLineInsert(VAR TempPrepmtSalesLine: Record 37 TEMPORARY; VAR TempSalesLine: Record 37 TEMPORARY; SalesHeader: Record 36; CompleteFunctionality: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempPrepmtSalesLineModify(VAR TempPrepmtSalesLine: Record 37 TEMPORARY; VAR TempSalesLine: Record 37 TEMPORARY; SalesHeader: Record 36; CompleteFunctionality: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeReleaseSalesDoc(VAR SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdatePrepmtSalesLineWithRounding(VAR PrepmtSalesLine: Record 37; TotalRoundingAmount: ARRAY[2] OF Decimal; TotalPrepmtAmount: ARRAY[2] OF Decimal; FinalInvoice: Boolean; PricesInclVATRoundingAmount: ARRAY[2] OF Decimal; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInvoiceSalesShptLine(SalesShipmentLine: Record 111; InvoiceNo: Code[20]; InvoiceLineNo: Integer; QtyToInvoice: Decimal; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE PostResJnlLine(VAR SalesHeader: Record 36; VAR SalesLine: Record 37; VAR JobTaskSalesLine: Record 37);
    VAR
        ResJnlLine: Record 207;
    BEGIN
        IF SalesLine."Qty. to Invoice" = 0 THEN
            EXIT;

        WITH ResJnlLine DO BEGIN
            INIT;
            "Posting Date" := SalesHeader."Posting Date";
            "Document Date" := SalesHeader."Document Date";
            "Reason Code" := SalesHeader."Reason Code";

            CopyDocumentFields(GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, SalesHeader."Posting No. Series");

            CopyFromSalesLine(SalesLine);

            ResJnlPostLine.RunWithCheck(ResJnlLine);
            IF JobTaskSalesLine."Job Contract Entry No." > 0 THEN
                PostJobContractLine(SalesHeader, JobTaskSalesLine);

            //QB
            IF JobTaskSalesLine."Job Contract Entry No." = 0 THEN
                QBCodeunitSubscriber.PostJobManual_CU80(SalesLine, SalesHeader, SalesInvHeader."No.", SalesCrMemoHeader."No.", ModificManagement);
            //QB
        END;
    END;

    LOCAL PROCEDURE ValidatePostingAndDocumentDate(VAR SalesHeader: Record 36);
    VAR
        BatchProcessingMgt: Codeunit 1380;
        BatchProcessingMgt1: Codeunit 50623;
        BatchPostParameterTypes: Codeunit 1370;
        PostingDate: Date;
        ModifyHeader: Boolean;
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
    BEGIN
        OnBeforeValidatePostingAndDocumentDate(SalesHeader, SuppressCommit);

        PostingDateExists :=
          BatchProcessingMgt1.GetParameterBoolean(SalesHeader.RECORDID, BatchPostParameterTypes.ReplacePostingDate, ReplacePostingDate) AND
          BatchProcessingMgt1.GetParameterBoolean(
            SalesHeader.RECORDID, BatchPostParameterTypes.ReplaceDocumentDate, ReplaceDocumentDate) AND
          BatchProcessingMgt1.GetParameterDate(SalesHeader.RECORDID, BatchPostParameterTypes.PostingDate, PostingDate);

        IF PostingDateExists AND (ReplacePostingDate OR (SalesHeader."Posting Date" = 0D)) THEN BEGIN
            SalesHeader."Posting Date" := PostingDate;
            SalesHeader.SynchronizeAsmHeader;
            SalesHeader.VALIDATE("Currency Code");
            ModifyHeader := TRUE;
        END;

        IF PostingDateExists AND (ReplaceDocumentDate OR (SalesHeader."Document Date" = 0D)) THEN BEGIN
            SalesHeader.VALIDATE("Document Date", PostingDate);
            SalesHeader.ValidatePaymentTerms;
            ModifyHeader := TRUE;
        END;

        IF ModifyHeader THEN
            SalesHeader.MODIFY;
    END;

    LOCAL PROCEDURE UpdateSalesLineDimSetIDFromAppliedEntry(VAR SalesLineToPost: Record 37; SalesLine: Record 37);
    VAR
        ItemLedgEntry: Record 32;
        DimensionMgt: Codeunit 408;
        DimSetID: ARRAY[10] OF Integer;
    BEGIN
        DimSetID[1] := SalesLine."Dimension Set ID";
        WITH SalesLineToPost DO BEGIN
            IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                ItemLedgEntry.GET("Appl.-to Item Entry");
                DimSetID[2] := ItemLedgEntry."Dimension Set ID";
            END;
            "Dimension Set ID" :=
              DimensionMgt.GetCombinedDimensionSetID(DimSetID, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        END;
    END;

    LOCAL PROCEDURE CalcDeferralAmounts(SalesHeader: Record 36; SalesLine: Record 37; OriginalDeferralAmount: Decimal);
    VAR
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        CurrExchRate: Record 330;
        TotalAmountLCY: Decimal;
        TotalAmount: Decimal;
        TotalDeferralCount: Integer;
        DeferralCount: Integer;
        UseDate: Date;
    BEGIN
        // Populate temp and calculate the LCY amounts for posting
        IF SalesHeader."Posting Date" = 0D THEN
            UseDate := WORKDATE
        ELSE
            UseDate := SalesHeader."Posting Date";

        IF DeferralHeader.GET(
             DeferralUtilities1.GetSalesDeferralDocType, '', '', SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
        THEN BEGIN
            TempDeferralHeader := DeferralHeader;
            IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
                TempDeferralHeader."Amount to Defer" :=
                  ROUND(TempDeferralHeader."Amount to Defer" *
                    SalesLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");
            TempDeferralHeader."Amount to Defer (LCY)" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, SalesHeader."Currency Code",
                  TempDeferralHeader."Amount to Defer", SalesHeader."Currency Factor"));
            TempDeferralHeader.INSERT;

            WITH DeferralLine DO BEGIN
                DeferralUtilities1.FilterDeferralLines(
                  DeferralLine, DeferralHeader."Deferral Doc. Type",//enum to option
                  DeferralHeader."Gen. Jnl. Template Name", DeferralHeader."Gen. Jnl. Batch Name",
                  DeferralHeader."Document Type", DeferralHeader."Document No.", DeferralHeader."Line No.");
                IF FINDSET THEN BEGIN
                    TotalDeferralCount := COUNT;
                    REPEAT
                        DeferralCount := DeferralCount + 1;
                        TempDeferralLine.INIT;
                        TempDeferralLine := DeferralLine;

                        IF DeferralCount = TotalDeferralCount THEN BEGIN
                            TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                            TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
                        END ELSE BEGIN
                            IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
                                TempDeferralLine.Amount :=
                                  ROUND(TempDeferralLine.Amount *
                                    SalesLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");

                            TempDeferralLine."Amount (LCY)" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  UseDate, SalesHeader."Currency Code",
                                  TempDeferralLine.Amount, SalesHeader."Currency Factor"));
                            TotalAmount := TotalAmount + TempDeferralLine.Amount;
                            TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
                        END;
                        TempDeferralLine.INSERT;
                    UNTIL NEXT = 0;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE CreatePostedDeferralScheduleFromSalesDoc(SalesLine: Record 37; NewDocumentType: Integer; NewDocumentNo: Code[20]; NewLineNo: Integer; PostingDate: Date);
    VAR
        PostedDeferralHeader: Record 1704;
        PostedDeferralLine: Record 1705;
        DeferralTemplate: Record 1700;
        DeferralAccount: Code[20];
    BEGIN
        IF SalesLine."Deferral Code" = '' THEN
            EXIT;

        IF DeferralTemplate.GET(SalesLine."Deferral Code") THEN
            DeferralAccount := DeferralTemplate."Deferral Account";

        IF TempDeferralHeader.GET(
             DeferralUtilities1.GetSalesDeferralDocType, '', '', SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.")
        THEN BEGIN
            PostedDeferralHeader.InitFromDeferralHeader(TempDeferralHeader, '', '',
              NewDocumentType, NewDocumentNo, NewLineNo, DeferralAccount, SalesLine."Sell-to Customer No.", PostingDate);
            DeferralUtilities.FilterDeferralLines(
              TempDeferralLine, DeferralUtilities1.GetSalesDeferralDocType, '', '',
              SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.");
            IF TempDeferralLine.FINDSET THEN
                REPEAT
                    PostedDeferralLine.InitFromDeferralLine(
                      TempDeferralLine, '', '', NewDocumentType, NewDocumentNo, NewLineNo, DeferralAccount);
                UNTIL TempDeferralLine.NEXT = 0;
        END;

        OnAfterCreatePostedDeferralScheduleFromSalesDoc(SalesLine, PostedDeferralHeader);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnSendSalesDocument(ShipAndInvoice: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE GetAmountRoundingPrecisionInLCY(DocType: Enum "Sales Document Type"; DocNo: Code[20]; CurrencyCode: Code[10]) AmountRoundingPrecision: Decimal;
    VAR
        SalesHeader: Record 36;
    BEGIN
        IF CurrencyCode = '' THEN
            EXIT(GLSetup."Amount Rounding Precision");
        SalesHeader.GET(DocType, DocNo);
        AmountRoundingPrecision := Currency."Amount Rounding Precision" / SalesHeader."Currency Factor";
        IF AmountRoundingPrecision < GLSetup."Amount Rounding Precision" THEN
            EXIT(GLSetup."Amount Rounding Precision");
        EXIT(AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateEmailParameters(SalesHeader: Record 36);
    VAR
        FindEmailParameter: Record 9510;
        RenameEmailParameter: Record 9510;
    BEGIN
        IF SalesHeader."Last Posting No." = '' THEN
            EXIT;
        FindEmailParameter.SETRANGE("Document No", SalesHeader."No.");
        FindEmailParameter.SETRANGE("Document Type", SalesHeader."Document Type");
        IF FindEmailParameter.FINDSET THEN
            REPEAT
                RenameEmailParameter.COPY(FindEmailParameter);
                RenameEmailParameter.RENAME(
                  SalesHeader."Last Posting No.", FindEmailParameter."Document Type", FindEmailParameter."Parameter Type");
            UNTIL FindEmailParameter.NEXT = 0;
    END;

    LOCAL PROCEDURE ArchivePurchaseOrders(VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        PurchOrderHeader: Record 38;
        PurchOrderLine: Record 39;
    BEGIN
        IF TempDropShptPostBuffer.FINDSET THEN BEGIN
            REPEAT
                PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order, TempDropShptPostBuffer."Order No.");
                TempDropShptPostBuffer.SETRANGE("Order No.", TempDropShptPostBuffer."Order No.");
                REPEAT
                    PurchOrderLine.GET(
                      PurchOrderLine."Document Type"::Order,
                      TempDropShptPostBuffer."Order No.", TempDropShptPostBuffer."Order Line No.");
                    PurchOrderLine."Qty. to Receive" := TempDropShptPostBuffer.Quantity;
                    PurchOrderLine."Qty. to Receive (Base)" := TempDropShptPostBuffer."Quantity (Base)";
                    PurchOrderLine.MODIFY;
                UNTIL TempDropShptPostBuffer.NEXT = 0;
                PurchPost.ArchiveUnpostedOrder(PurchOrderHeader);
                TempDropShptPostBuffer.SETRANGE("Order No.");
            UNTIL TempDropShptPostBuffer.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE IsItemJnlPostLineHandled(VAR ItemJnlLine: Record 83; VAR SalesLine: Record 37; VAR SalesHeader: Record 36) IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeItemJnlPostLine(ItemJnlLine, SalesLine, SalesHeader, SuppressCommit, IsHandled);
        EXIT(IsHandled);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeDeleteAfterPosting(VAR SalesHeader: Record 36; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR SkipDelete: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnFillInvoicePostingBufferOnBeforeDeferrals(VAR SalesLine: Record 37; VAR TotalAmount: Decimal; VAR TotalAmountACY: Decimal; UseDate: Date);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFillDeferralPostingBuffer(VAR SalesLine: Record 37; VAR TempInvoicePostBuffer: Record 49 TEMPORARY; VAR InvoicePostBuffer: Record 55; UseDate: Date; InvDefLineNo: Integer; DeferralLineNo: Integer; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeGetCountryCode(SalesHeader: Record 36; SalesLine: Record 37; VAR CountryRegionCode: Code[10]; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcInvDiscountSetFilter(VAR SalesLine: Record 37; SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnSumSalesLines2SetFilter(VAR SalesLine: Record 37; SalesHeader: Record 36);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesLineOnAfterTestUpdatedSalesLine(VAR SalesLine: Record 37; VAR EverythingInvoiced: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostUpdateOrderLineOnBeforeInitTempSalesLineQuantities(VAR SalesHeader: Record 36; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckAndUpdateOnBeforeCalcInvDiscount(VAR SalesHeader: Record 36; WarehouseReceiptHeader: Record 7316; WarehouseShipmentHeader: Record 7320; WhseReceive: Boolean; WhseShip: Boolean; VAR RefreshNeeded: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckTrackingAndWarehouseForShipOnBeforeCheck(VAR SalesHeader: Record 36; VAR TempWhseShipmentHeader: Record 7320 TEMPORARY; VAR TempWhseReceiptHeader: Record 7316 TEMPORARY; VAR Ship: Boolean; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckTrackingAndWarehouseForReceiveOnBeforeCheck(VAR SalesHeader: Record 36; VAR TempWhseShipmentHeader: Record 7320 TEMPORARY; VAR TempWhseReceiptHeader: Record 7316 TEMPORARY; VAR Receive: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostItemJnlLineOnBeforeTransferReservToItemJnlLine(SalesLine: Record 37; ItemJnlLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostItemChargePerOrderOnAfterCopyToItemJnlLine(VAR ItemJournalLine: Record 83; VAR SalesLine: Record 37; GeneralLedgerSetup: Record 98; QtyToInvoice: Decimal; VAR TempItemChargeAssignmentSales: Record 5809 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesLineOnBeforeInsertCrMemoLine(SalesHeader: Record 36; SalesLine: Record 37; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesLineOnBeforeInsertInvoiceLine(SalesHeader: Record 36; SalesLine: Record 37; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesLineOnBeforeInsertReturnReceiptLine(SalesHeader: Record 36; SalesLine: Record 37; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesLineOnBeforeInsertShipmentLine(SalesHeader: Record 36; SalesLine: Record 37; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostSalesLineOnBeforeTestJobNo(SalesLine: Record 37; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRoundAmountOnBeforeIncrAmount(SalesHeader: Record 36; VAR SalesLine: Record 37; SalesLineQty: Decimal; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRunOnBeforeFinalizePosting(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; VAR GenJnlPostLine: Codeunit 12; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateBlanketOrderLineOnBeforeInitOutstanding(VAR BlanketOrderSalesLine: Record 37; SalesLine: Record 37);
    BEGIN
    END;



    /*BEGIN
/*{
      MCM 29/11/18: - QB_180720 Modificaci¢n para Sales Statistics
      JAV 18/09/19: - Se elimina el c¢digo asociado a QB_180720 pues ya no se usaba
      JAV 21/10/19: - Se pasan los eventos de retenciones a la CU de retenciones
    }
END.*/
}











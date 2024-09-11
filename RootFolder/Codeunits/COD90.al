Codeunit 50105 "Purch.-Post 1"
{


    TableNo = 38;
    Permissions = TableData 36 = m,
                TableData 37 = m,
                TableData 39 = imd,
                TableData 49 = imd,
                TableData 93 = imd,
                TableData 94 = imd,
                TableData 110 = imd,
                TableData 111 = imd,
                TableData 120 = imd,
                TableData 121 = imd,
                TableData 122 = imd,
                TableData 123 = imd,
                TableData 124 = imd,
                TableData 125 = imd,
                TableData 223 = imd,
                TableData 6507 = ri,
                TableData 6508 = rid,
                TableData 6650 = imd,
                TableData 6651 = imd;
    trigger OnRun()
    VAR
        PurchHeader: Record 38;
        TempInvoicePostBuffer: Record 55 TEMPORARY;
        TempVATAmountLine: Record 290 TEMPORARY;
        TempVATAmountLineRemainder: Record 290 TEMPORARY;
        TempDropShptPostBuffer: Record 223 TEMPORARY;
        PaymentMethod: Record 289;
        CarteraSetup: Record 7000016;
        UpdateAnalysisView: Codeunit 410;
        UpdateItemAnalysisView: Codeunit 7150;
        EverythingInvoiced: Boolean;
        SavedPreviewMode: Boolean;
        SavedSuppressCommit: Boolean;
        BiggestLineNo: Integer;
        ICGenJnlLineNo: Integer;
        LineCount: Integer;
    BEGIN
        OnBeforePostPurchaseDoc(Rec, PreviewMode, SuppressCommit);

        ValidatePostingAndDocumentDate(Rec);

        SavedPreviewMode := PreviewMode;
        SavedSuppressCommit := SuppressCommit;
        ClearAllVariables;
        PreviewMode := SavedPreviewMode;
        SuppressCommit := SavedSuppressCommit;

        GetGLSetup;
        GetCurrency(PurchHeader."Currency Code");

        PurchSetup.GET;
        PurchHeader := Rec;
        FillTempLines(PurchHeader, TempPurchLineGlobal);

        // Header
        CheckAndUpdate(PurchHeader);

        TempDeferralHeader.DELETEALL;
        TempDeferralLine.DELETEALL;
        TempInvoicePostBuffer.DELETEALL;
        TempDropShptPostBuffer.DELETEALL;
        EverythingInvoiced := TRUE;

        // Lines
        OnBeforePostLines(TempPurchLineGlobal, PurchHeader, PreviewMode, SuppressCommit);

        LineCount := 0;
        RoundingLineInserted := FALSE;
        AdjustFinalInvWith100PctPrepmt(TempPurchLineGlobal);

        TempVATAmountLineRemainder.DELETEALL;
        TempPurchLineGlobal.CalcVATAmountLines(1, PurchHeader, TempPurchLineGlobal, TempVATAmountLine);

        PurchaseLinesProcessed := FALSE;
        IF TempPurchLineGlobal.FINDSET THEN
            REPEAT
                ItemJnlRollRndg := FALSE;
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);

                PostPurchLine(
                  PurchHeader, TempPurchLineGlobal, TempInvoicePostBuffer, TempVATAmountLine, TempVATAmountLineRemainder,
                  TempDropShptPostBuffer, EverythingInvoiced, ICGenJnlLineNo);

                IF RoundingLineInserted THEN
                    LastLineRetrieved := TRUE
                ELSE BEGIN
                    BiggestLineNo := MAX(BiggestLineNo, TempPurchLineGlobal."Line No.");
                    LastLineRetrieved := TempPurchLineGlobal.NEXT = 0;
                    IF LastLineRetrieved AND PurchSetup."Invoice Rounding" THEN
                        InvoiceRounding(PurchHeader, TempPurchLineGlobal, FALSE, BiggestLineNo);
                END;
            UNTIL LastLineRetrieved;

        //CPA 25/01/22: - Q15921. Errores detectados en almacenes de obras.Begin
        IF PurchHeader.Receive OR
          (PurchHeader.Invoice AND (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Blanket Order"])) THEN
            //CPA 25/01/22: - Q15921. Errores detectados en almacenes de obras.End
            QBCodeunitPublisher.OnRunPurchPostPurchaseRcpt(Rec, PurchRcptHeader, TempPurchRcptLine);

        //CPA 25/01/22: - Q15921. Errores detectados en almacenes de obras.Begin
        IF PurchHeader.Ship OR
          (PurchHeader.Invoice AND (PurchHeader."Document Type" IN [PurchHeader."Document Type"::"Credit Memo", PurchHeader."Document Type"::"Return Order"])) THEN
            QBCodeunitPublisher.OnRunPurchPostReturnShipment(PurchHeader, ReturnShptHeader, TempReturnShptLine, PurchCrMemoHeader);
        //CPA 25/01/22: - Q15921. Errores detectados en almacenes de obras.End

        OnAfterPostPurchLines(
          PurchHeader, PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader, ReturnShptHeader, WhseShip, WhseReceive, PurchaseLinesProcessed,
          SuppressCommit);

        IF PurchHeader.IsCreditDocType THEN BEGIN
            ReverseAmount(TotalPurchLine);
            ReverseAmount(TotalPurchLineLCY);
        END;

        // Post combine shipment of sales order
        PostCombineSalesOrderShipment(PurchHeader, TempDropShptPostBuffer);

        IF PurchHeader.Invoice THEN
            PostGLAndVendor(PurchHeader, TempInvoicePostBuffer);

        IF ICGenJnlLineNo > 0 THEN
            PostICGenJnl;

        MakeInventoryAdjustment;

        // Create Bills
        IF PaymentMethod.GET(PurchHeader."Payment Method Code") THEN
            IF (PaymentMethod."Create Bills" OR PaymentMethod."Invoices to Cartera") AND
               (NOT CarteraSetup.READPERMISSION) AND PurchHeader.Invoice
            THEN
                ERROR(CannotCreateCarteraDocErr);

        IF PurchHeader.Invoice AND (PurchHeader."Bal. Account No." = '') AND
           NOT PurchHeader.IsCreditDocType AND CarteraSetup.READPERMISSION
        THEN BEGIN
            OnBeforeCreateCarteraBills(PurchHeader, VendLedgEntry, TotalPurchLine, SuppressCommit);
            SplitPayment.SplitPurchInv(
              PurchHeader, VendLedgEntry, Window, SrcCode, GenJnlLineExtDocNo, GenJnlLineDocNo,
              -(TotalPurchLine."Amount Including VAT" - TotalPurchLine.Amount));
        END;

        CLEAR(GenJnlPostLine);

        UpdateLastPostingNos(PurchHeader);
        FinalizePosting(PurchHeader, TempDropShptPostBuffer, EverythingInvoiced);

        Rec := PurchHeader;

        IF NOT (InvtPickPutaway OR SuppressCommit) THEN BEGIN
            COMMIT;
            UpdateAnalysisView.UpdateAll(0, TRUE);
            UpdateItemAnalysisView.UpdateAll(0, TRUE);
        END;

        OnAfterPostPurchaseDoc(
          Rec, GenJnlPostLine, PurchRcptHeader."No.", ReturnShptHeader."No.", PurchInvHeader."No.", PurchCrMemoHeader."No.",
          SuppressCommit);
        OnAfterPostPurchaseDocDropShipment(SalesShptHeader."No.", SuppressCommit);
    END;

    VAR
        NothingToPostErr: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        DropShipmentErr: TextConst ENU = 'A drop shipment from a purchase order cannot be received and invoiced at the same time.', ESP = 'Un env¡o directo desde un pedido de compras no se puede recibir y facturar a la vez.';
        PostingLinesMsg: TextConst ENU = 'Posting lines              #2######\', ESP = 'Registrando l¡neas         #2######\';
        PostingPurchasesAndVATMsg: TextConst ENU = 'Posting purchases and VAT  #3######\', ESP = 'Registrando compra e IVA   #3######\';
        PostingVendorsMsg: TextConst ENU = 'Posting to vendors         #4######\', ESP = 'Registrando proveedor      #4######\';
        PostingLines2Msg: TextConst ENU = 'Posting lines         #2######', ESP = 'Registrando l¡neas         #2######';
        InvoiceNoMsg: TextConst ENU = '%1 %2 -> Invoice %3', ESP = '%1 %2 -> Factura %3';
        CreditMemoNoMsg: TextConst ENU = '%1 %2 -> Credit Memo %3', ESP = '%1 %2 -> Abono %3';
        CannotInvoiceBeforeAssosSalesOrderErr: TextConst ENU = 'You cannot invoice this purchase order before the associated sales orders have been invoiced. Please invoice sales order %1 before invoicing this purchase order.', ESP = 'Antes de facturar este pedido de compra hay que registrar los pedidos de venta asociados. Facture el pedido de venta %1 antes de facturar este pedido de compra.';
        ReceiptSameSignErr: TextConst ENU = 'must have the same sign as the receipt', ESP = 'debe tener el mismo signo que el albar n de compra';
        ReceiptLinesDeletedErr: TextConst ENU = 'Receipt lines have been deleted.', ESP = 'Se han borrado las l¡neas del albar n de compra.';
        CannotPurchaseResourcesErr: TextConst ENU = 'You cannot purchase resources.', ESP = 'No se pueden comprar recursos.';
        PurchaseAlreadyExistsErr: TextConst ENU = 'Purchase %1 %2 already exists for this vendor.', ESP = 'Ya existe la compra %1 %2 para este proveedor.';
        InvoiceMoreThanReceivedErr: TextConst ENU = 'You cannot invoice order %1 for more than you have received.', ESP = 'En el pedido %1 no se puede facturar m s de lo recibido.';
        CannotPostBeforeAssosSalesOrderErr: TextConst ENU = 'You cannot post this purchase order before the associated sales orders have been invoiced. Post sales order %1 before posting this purchase order.', ESP = 'Antes de registrar este pedido de compra hay que registrar los pedidos de venta asociados. Registre ped. venta %1 antes de reg. este pedido compra.';
        ExtDocNoNeededErr: TextConst ENU = 'You need to enter the document number of the document from the vendor in the %1 field, so that this document stays linked to the original.', ESP = 'Debe especificar el n£mero de documento del documento del proveedor en el campo %1, de modo que este documento permanezca vinculado al original.';
        VATAmountTxt: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
        VATRateTxt: TextConst ENU = '%1% VAT', ESP = '%1% IVA';
        BlanketOrderQuantityGreaterThanErr: TextConst ENU = 'in the associated blanket order must not be greater than %1', ESP = 'en el pedido abierto asociado no debe ser superior a %1';
        BlanketOrderQuantityReducedErr: TextConst ENU = 'in the associated blanket order must be reduced', ESP = 'en el pedido abierto asociado se debe reducir';
        ReceiveInvoiceShipErr: TextConst ENU = 'Please enter "Yes" in Receive and/or Invoice and/or Ship.', ESP = 'Especifique "S¡" en Recepci¢n y/o Factura y/o Env¡o.';
        WarehouseRequiredErr: TextConst ENU = '"Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6."', ESP = '"Manipulaci¢n almac‚n requerido para %1 = %2, %3 = %4, %5 = %6."';
        ReturnShipmentSamesSignErr: TextConst ENU = 'must have the same sign as the return shipment', ESP = 'debe tener el mismo signo que el env¡o devoluci¢n';
        ReturnShipmentInvoicedErr: TextConst ENU = 'Line %1 of the return shipment %2, which you are attempting to invoice, has already been invoiced.', ESP = 'L¡nea %1 del env¡o dev. %2, que esta intentando facturar, ya se ha facturado.';
        ReceiptInvoicedErr: TextConst ENU = 'Line %1 of the receipt %2, which you are attempting to invoice, has already been invoiced.', ESP = 'L¡nea %1 del recibo %2,que est  intentando facturar,ha sido ya facturado.';
        QuantityToInvoiceGreaterErr: TextConst ENU = 'The quantity you are attempting to invoice is greater than the quantity in receipt %1.', ESP = 'La cantidad que est  intentando facturar es m s grande que la del albar n %1.';
        CannotAssignMoreErr: TextConst ENU = '"You cannot assign more than %1 units in %2 = %3,%4 = %5,%6 = %7."', ESP = '"No puede asignar m s que %1 unidades en %2 = %3,%4 = %5,%6 = %7."';
        MustAssignErr: TextConst ENU = 'You must assign all item charges, if you invoice everything.', ESP = 'Si factura todo, debe asignar todos los cargos prod.';
        CannotAssignInvoicedErr: TextConst ENU = '"You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced."', ESP = '"No puede asignar cargos de prod. al %1 %2 = %3,%4 = %5, %6 = %7,porque ya se ha facturado."';
        PurchSetup: Record 312;
        GLSetup: Record 98;
        GLEntry: Record 17;
        TempPurchLineGlobal: Record 39 TEMPORARY;
        JobPurchLine: Record 39;
        TotalPurchLine: Record 39;
        TotalPurchLineLCY: Record 39;
        xPurchLine: Record 39;
        PurchLineACY: Record 39;
        PurchRcptHeader: Record 120;
        PurchInvHeader: Record 122;
        PurchCrMemoHeader: Record 124;
        ReturnShptHeader: Record 6650;
        SalesShptHeader: Record 110;
        TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
        SourceCodeSetup: Record 242;
        Currency: Record 4;
        VendLedgEntry: Record 25;
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
        TempTrackingSpecification: Record 336 TEMPORARY;
        TempTrackingSpecificationInv: Record 336 TEMPORARY;
        TempWhseSplitSpecification: Record 336 TEMPORARY;
        TempValueEntryRelation: Record 6508 TEMPORARY;
        Job: Record 167;
        TempICGenJnlLine: Record 81 TEMPORARY;
        TempPrepmtDeductLCYPurchLine: Record 39 TEMPORARY;
        PaymentTerms: Record 3;
        TempSKU: Record 5700 TEMPORARY;
        DeferralPostBuffer: Record 1706;
        TempDeferralHeader: Record 1701 TEMPORARY;
        TempDeferralLine: Record 1702 TEMPORARY;
        GenJnlPostLine: Codeunit 12;
        ItemJnlPostLine: Codeunit 22;
        SalesTaxCalculate: Codeunit 398;
        ReservePurchLine: Codeunit 99000834;
        ApprovalsMgmt: Codeunit 50015;
        WhsePurchRelease: Codeunit 5772;
        SalesPost: Codeunit 80;
        ItemTrackingMgt: Codeunit 6500;
        ItemTrackingMgt1: Codeunit 51151;
        WhseJnlPostLine: Codeunit 7301;
        WhsePostRcpt: Codeunit 5760;
        WhsePostShpt: Codeunit 5763;
        CostCalcMgt: Codeunit 5836;
        JobPostLine: Codeunit 50009;
        ServItemMgt: Codeunit 5920;
        DeferralUtilities: Codeunit 1720;
        DeferralUtilities1: Codeunit 50721;
        SplitPayment: Codeunit 7000005;
        Window: Dialog;
        Usedate: Date;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        ItemLedgShptEntryNo: Integer;
        GenJnlLineDocType: Integer;
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
        GLSetupRead: Boolean;
        InvoiceGreaterThanReturnShipmentErr: TextConst ENU = 'The quantity you are attempting to invoice is greater than the quantity in return shipment %1.', ESP = 'La cant. que est  intentando facturar es mayor que la cant. en env¡o dev. %1.';
        ReturnShipmentLinesDeletedErr: TextConst ENU = 'Return shipment lines have been deleted.', ESP = 'Se han borrado las l¡ns. env¡o devoluci¢n';
        InvoiceMoreThanShippedErr: TextConst ENU = 'You cannot invoice return order %1 for more than you have shipped.', ESP = 'No puede facturar la devoluci¢n %1 por m s de lo que ha enviado.';
        RelatedItemLedgEntriesNotFoundErr: TextConst ENU = 'Related item ledger entries cannot be found.', ESP = 'No se encuentran los movs. pdto. relacionados.';
        ItemTrackingWrongSignErr: TextConst ENU = 'Item Tracking is signed wrongly.', ESP = 'Seguim. pdto. no est  bien definido.';
        ItemTrackingMismatchErr: TextConst ENU = 'Item Tracking does not match.', ESP = 'Seguimiento prod. no coincide.';
        PostingDateNotAllowedErr: TextConst ENU = 'is not within your range of allowed posting dates', ESP = 'no est  dentro del periodo de fechas de registro permitidas';
        ItemTrackQuantityMismatchErr: TextConst ENU = 'The %1 does not match the quantity defined in item tracking.', ESP = '%1 no coincide con la cantidad definida en el seguimiento de productos.';
        CannotBeGreaterThanErr: TextConst ENU = 'cannot be more than %1.', ESP = 'no puede ser superior a %1.';
        CannotBeSmallerThanErr: TextConst ENU = 'must be at least %1.', ESP = 'debe ser al menos %1.';
        ItemJnlRollRndg: Boolean;
        WhseReceive: Boolean;
        WhseShip: Boolean;
        InvtPickPutaway: Boolean;
        PositiveWhseEntrycreated: Boolean;
        PrepAmountToDeductToBigErr: TextConst ENU = 'The total %1 cannot be more than %2.', ESP = 'El total %1 no puede ser m s de %2.';
        PrepAmountToDeductToSmallErr: TextConst ENU = 'The total %1 must be at least %2.', ESP = 'El total %1 debe ser al menos %2.';
        UnpostedInvoiceDuplicateQst: TextConst ENU = 'An unposted invoice for order %1 exists. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post order %1?', ESP = 'Existe una factura sin registrar para el pedido %1. Para evitar registros duplicados, elimine el pedido %1 o la factura %2.\¨A£n desea registrar el pedido %1?';
        InvoiceDuplicateInboxQst: TextConst ENU = 'An invoice for order %1 exists in the IC inbox. To avoid duplicate postings, cancel invoice %2 in the IC inbox.\Do you still want to post order %1?', ESP = 'Existe una factura para el pedido %1 en la bandeja de entrada IC. Para evitar registros duplicados, cancele la factura %2 en la bandeja de entrada IC.\¨A£n desea registrar el pedido %1?';
        PostedInvoiceDuplicateQst: TextConst ENU = 'Posted invoice %1 already exists for order %2. To avoid duplicate postings, do not post order %2.\Do you still want to post order %2?', ESP = 'La factura registrada %1 ya existe para el pedido %2. Para evitar registros duplicados, no registre el pedido %2.\¨A£n desea registrar el pedido %2?';
        OrderFromSameTransactionQst: TextConst ENU = 'Order %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post invoice %2?', ESP = 'El pedido %1 se origina desde la misma transacci¢n IC que la factura %2. Para evitar registros duplicados, elimine el pedido %1 o la factura %2.\¨A£n desea registrar la factura %2?';
        DocumentFromSameTransactionQst: TextConst ENU = 'A document originating from the same IC transaction as document %1 exists in the IC inbox. To avoid duplicate postings, cancel document %2 in the IC inbox.\Do you still want to post document %1?', ESP = 'Un documento que se origina en la misma transacci¢n IC que el documento %1 ya existe en la bandeja de entrada IC. Para evitar registros duplicados, cancele el documento %2 en la bandeja de entrada IC.\¨A£n desea registrar el documento %1?';
        PostedInvoiceFromSameTransactionQst: TextConst ENU = 'Posted invoice %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, do not post invoice %2.\Do you still want to post invoice %2?', ESP = 'La factura registrada %1 se origina en la misma transacci¢n IC que la factura %2. Para evitar registros duplicados, no registre la factura %2.\¨A£n desea registrar la factura %2?';
        MustAssignItemChargeErr: TextConst ENU = 'You must assign item charge %1 if you want to invoice it.', ESP = 'Debe asignar un cargo prod. de %1 si quiere facturarlo.';
        CannotInvoiceItemChargeErr: TextConst ENU = 'You can not invoice item charge %1 because there is no item ledger entry to assign it to.', ESP = 'No puede facturar un cargo prod. de %1 porque no existe mov. producto al que asignarlo.';
        PurchaseLinesProcessed: Boolean;
        AutoDocNo: Code[20];
        Text1100000: TextConst ENU = 'The Credit Memo doesn''t have a Corrected Invoice No. Do you want to continue?', ESP = 'El abono no tiene un n§ de factura corregido. ¨Confirma que desea continuar?';
        Text1100011: TextConst ENU = 'The posting process has been cancelled by the user.', ESP = 'El proceso de registro ha sido cancelado por el usuario.';
        CannotCreateCarteraDocErr: TextConst ENU = 'You do not have permissions to create Documents in Cartera.\Please, change the Payment Method.', ESP = 'No tiene permisos para crear Documentos en Cartera.\Cambie la forma de pago.';
        Text1100102: TextConst ENU = 'Posting to bal. account    #5######\', ESP = 'Registrando contrapartida  #5######\';
        Text1100103: TextConst ENU = 'Creating documents         #6######', ESP = 'Creando documentos         #6######';
        Text1100104: TextConst ENU = 'Corrective Invoice', ESP = 'Factura rectificativa';
        ReservationDisruptedQst: TextConst ENU = '"One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?"', ESP = '"Existen uno o m s movimientos de reserva para el producto con %1 = %2, %3 = %4, %5 = %6 que pueden alterarse si registra este ajuste negativo. ¨Desea continuar?"';
        ReassignItemChargeErr: TextConst ENU = 'The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.', ESP = 'La l¡nea del pedido a la que se asign¢ originalmente el cargo de producto se ha registrado completamente. Debe reasignar el cargo de producto a la recepci¢n o al env¡o registrado.';
        PreviewMode: Boolean;
        NoDeferralScheduleErr: TextConst ENU = 'You must create a deferral schedule because you have specified the deferral code %2 in line %1.', ESP = 'Debe crear una previsi¢n de fraccionamiento porque ha especificado el c¢digo de fraccionamiento %2 en la l¡nea %1.';
        ZeroDeferralAmtErr: TextConst ENU = 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', ESP = 'Los importes de fraccionamiento no pueden ser 0. L¡nea: %1, Plantilla de fraccionamiento: %2.';
        MixedDerpFAUntilPostingDateErr: TextConst ENU = 'The value in the Depr. Until FA Posting Date field must be the same on lines for the same fixed asset %1.', ESP = 'El valor del campo A/F Amort. hasta fecha reg. debe ser igual en las l¡neas del mismo activo fijo %1.';
        CannotPostSameMultipleFAWhenDeprBookValueZeroErr: TextConst ENU = 'You cannot select the Depr. Until FA Posting Date check box because there is no previous acquisition entry for fixed asset %1.\\If you want to depreciate new acquisitions, you can select the Depr. Acquisition Cost check box instead.', ESP = 'No se puede activar la casilla A/F Amort. hasta fecha reg. porque no hay ning£n movimiento de adquisici¢n anterior para el activo fijo %1.\\Si desea amortizar nuevas adquisiciones, puede activar la casilla Amort. hasta coste.';
        PostingPreviewNoTok: TextConst ENU = '***', ESP = '***';
        InvPickExistsErr: TextConst ENU = 'One or more related inventory picks must be registered before you can post the shipment.', ESP = 'Debe registrarse uno o varios picking de inventario relacionados antes de registrar el env¡o.';
        InvPutAwayExistsErr: TextConst ENU = 'One or more related inventory put-aways must be registered before you can post the receipt.', ESP = 'Debe registrarse una o varias ubicaciones de inventario relacionadas antes de registrar la recepci¢n.';
        SuppressCommit: Boolean;
        "------------------------------ QB": Integer;
        QBCodeunitPublisher: Codeunit 7207352;
        TempPurchRcptLine: Record 121 TEMPORARY;
        TempReturnShptLine: Record 6651 TEMPORARY;
        GenJnlLine: Record 81;

    //[External]
    PROCEDURE CopyToTempLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    VAR
        PurchLine: Record 39;
    BEGIN
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        IF PurchLine.FINDSET THEN
            REPEAT
                TempPurchLine := PurchLine;
                TempPurchLine.INSERT;
            UNTIL PurchLine.NEXT = 0;
    END;

    //[External]
    PROCEDURE FillTempLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    BEGIN
        TempPurchLine.RESET;
        IF TempPurchLine.ISEMPTY THEN
            CopyToTempLines(PurchHeader, TempPurchLine);
    END;

    LOCAL PROCEDURE ModifyTempLine(VAR TempPurchLineLocal: Record 39 TEMPORARY);
    VAR
        PurchLine: Record 39;
    BEGIN
        TempPurchLineLocal.MODIFY;
        PurchLine := TempPurchLineLocal;
        PurchLine.MODIFY;
    END;

    //[External]
    PROCEDURE RefreshTempLines(PurchHeader: Record 38; VAR TempPurchLine: Record 39 TEMPORARY);
    BEGIN
        TempPurchLine.RESET;
        TempPurchLine.SETRANGE("Prepayment Line", FALSE);
        TempPurchLine.DELETEALL;
        TempPurchLine.RESET;
        CopyToTempLines(PurchHeader, TempPurchLine);
    END;

    LOCAL PROCEDURE ResetTempLines(VAR TempPurchLineLocal: Record 39 TEMPORARY);
    BEGIN
        TempPurchLineLocal.RESET;
        TempPurchLineLocal.COPY(TempPurchLineGlobal, TRUE);

        OnAfterResetTempLines(TempPurchLineGlobal);
    END;

    LOCAL PROCEDURE CalcInvoice(VAR PurchHeader: Record 38) NewInvoice: Boolean;
    VAR
        TempPurchLine: Record 39 TEMPORARY;
    BEGIN
        WITH PurchHeader DO BEGIN
            ResetTempLines(TempPurchLine);
            TempPurchLine.SETFILTER(Quantity, '<>0');
            IF "Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"] THEN
                TempPurchLine.SETFILTER("Qty. to Invoice", '<>0');
            NewInvoice := NOT TempPurchLine.ISEMPTY;
            IF NewInvoice THEN
                CASE "Document Type" OF
                    "Document Type"::Order:
                        IF NOT Receive THEN BEGIN
                            TempPurchLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>0');
                            NewInvoice := NOT TempPurchLine.ISEMPTY;
                        END;
                    "Document Type"::"Return Order":
                        IF NOT Ship THEN BEGIN
                            TempPurchLine.SETFILTER("Return Qty. Shipped Not Invd.", '<>0');
                            NewInvoice := NOT TempPurchLine.ISEMPTY;
                        END;
                END;
        END;
        EXIT(NewInvoice);
    END;

    LOCAL PROCEDURE CalcInvDiscount(VAR PurchHeader: Record 38);
    VAR
        PurchaseHeaderCopy: Record 38;
        PurchLine: Record 39;
    BEGIN
        WITH PurchHeader DO BEGIN
            IF NOT (PurchSetup."Calc. Inv. Discount" AND (Status <> Status::Open)) THEN
                EXIT;

            PurchaseHeaderCopy := PurchHeader;
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", "Document Type");
            PurchLine.SETRANGE("Document No.", "No.");
            PurchLine.FINDFIRST;
            CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount", PurchLine);
            RefreshTempLines(PurchHeader, TempPurchLineGlobal);
            GET("Document Type", "No.");
            RestorePurchaseHeader(PurchHeader, PurchaseHeaderCopy);
            IF NOT PreviewMode THEN
                COMMIT;
        END;
        EXIT;
    END;

    LOCAL PROCEDURE RestorePurchaseHeader(VAR PurchaseHeader: Record 38; PurchaseHeaderCopy: Record 38);
    BEGIN
        WITH PurchaseHeader DO BEGIN
            Invoice := PurchaseHeaderCopy.Invoice;
            Receive := PurchaseHeaderCopy.Receive;
            Ship := PurchaseHeaderCopy.Ship;
            "Posting No." := PurchaseHeaderCopy."Posting No.";
            "Receiving No." := PurchaseHeaderCopy."Receiving No.";
            "Return Shipment No." := PurchaseHeaderCopy."Return Shipment No.";
        END;
    END;

    LOCAL PROCEDURE CheckAndUpdate(VAR PurchHeader: Record 38);
    VAR
        TransportMethod: Record 259;
        DimMgt: Codeunit 408;
        DimMgt2:codeunit 50361;
        GenJnlCheckLine: Codeunit 11;
        ModifyHeader: Boolean;
        RefreshTempLinesNeeded: Boolean;
    BEGIN
        WITH PurchHeader DO BEGIN
            // Check
            CheckMandatoryHeaderFields(PurchHeader);
            IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
                FIELDERROR("Posting Date", PostingDateNotAllowedErr);

            // IF TransportMethod.GET("Transport Method") AND TransportMethod."Port/Airport" THEN
            //     TESTFIELD("Entry Point");

            PaymentTerms.GET("Payment Terms Code");
            SetPostingFlags(PurchHeader);
            InitProgressWindow(PurchHeader);

            InvtPickPutaway := "Posting from Whse. Ref." <> 0;
            "Posting from Whse. Ref." := 0;

            DimMgt2.CheckPurchDim(PurchHeader, TempPurchLineGlobal);

            IF Invoice THEN
                CheckFAPostingPossibility(PurchHeader);

            CheckPostRestrictions(PurchHeader);

            CheckICDocumentDuplicatePosting(PurchHeader);

            IF IsCreditDocType AND Invoice THEN BEGIN
                IF PurchSetup."Correct. Doc. No. Mandatory" THEN
                    TESTFIELD("Corrected Invoice No.")
                ELSE BEGIN
                    IF "Corrected Invoice No." = '' THEN
                        IF NOT CONFIRM(Text1100000, FALSE) THEN
                            ERROR(Text1100011);
                END;
                IF "Corrected Invoice No." <> '' THEN
                    "Posting Description" := FORMAT(Text1100104) + ' ' + "No."
            END;

            IF (Receive OR Invoice) AND (NOT IsCreditDocType) THEN BEGIN
                TESTFIELD("Payment Method Code");
                TESTFIELD("Payment Terms Code");
            END;

            IF Invoice THEN
                Invoice := CalcInvoice(PurchHeader);

            IF Invoice THEN
                CopyAndCheckItemCharge(PurchHeader);

            IF Invoice AND NOT IsCreditDocType THEN BEGIN
                TESTFIELD("Due Date");
                PaymentTerms.VerifyMaxNoDaysTillDueDate("Due Date", "Document Date", FIELDCAPTION("Due Date"));
            END;

            IF Receive THEN BEGIN
                Receive := CheckTrackingAndWarehouseForReceive(PurchHeader);
                IF NOT InvtPickPutaway THEN
                    IF CheckIfInvPutawayExists(PurchHeader) THEN
                        ERROR(InvPutAwayExistsErr);
            END;

            IF Ship THEN BEGIN
                Ship := CheckTrackingAndWarehouseForShip(PurchHeader);
                IF NOT InvtPickPutaway THEN
                    IF CheckIfInvPickExists THEN
                        ERROR(InvPickExistsErr);
            END;

            IF NOT (Receive OR Invoice OR Ship) THEN
                ERROR(NothingToPostErr);

            CheckAssosOrderLines(PurchHeader);

            IF Invoice AND PurchSetup."Ext. Doc. No. Mandatory" THEN
                CheckExtDocNo(PurchHeader);

            OnAfterCheckPurchDoc(PurchHeader, SuppressCommit, WhseShip, WhseReceive);

            // Update
            IF Invoice THEN
                CreatePrepmtLines(PurchHeader, TRUE);

            ModifyHeader := UpdatePostingNos(PurchHeader);

            DropShipOrder := UpdateAssosOrderPostingNos(PurchHeader);

            OnBeforePostCommitPurchaseDoc(PurchHeader, GenJnlPostLine, PreviewMode, ModifyHeader, SuppressCommit);
            IF NOT PreviewMode AND ModifyHeader THEN BEGIN
                MODIFY;
                COMMIT;
            END;

            OnCheckAndUpdateOnBeforeCalcInvDiscount(
              PurchHeader, TempWhseRcptHeader, TempWhseShptHeader, WhseReceive, WhseShip, RefreshTempLinesNeeded);
            IF RefreshTempLinesNeeded THEN
                RefreshTempLines(PurchHeader, TempPurchLineGlobal);
            CalcInvDiscount(PurchHeader);
            ReleasePurchDocument(PurchHeader);

            IF Receive OR Ship THEN
                ArchiveUnpostedOrder(PurchHeader);

            CheckICPartnerBlocked(PurchHeader);
            SendICDocument(PurchHeader, ModifyHeader);
            UpdateHandledICInboxTransaction(PurchHeader);

            LockTables(PurchHeader);

            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Purchases;

            InsertPostedHeaders(PurchHeader);

            UpdateIncomingDocument("Incoming Document Entry No.", "Posting Date", GenJnlLineDocNo);
        END;

        OnAfterCheckAndUpdate(PurchHeader, SuppressCommit, PreviewMode);
    END;

    LOCAL PROCEDURE CheckExtDocNo(PurchaseHeader: Record 38);
    BEGIN
        WITH PurchaseHeader DO
            CASE "Document Type" OF
                "Document Type"::Order,
              "Document Type"::Invoice:
                    IF "Vendor Invoice No." = '' THEN
                        ERROR(ExtDocNoNeededErr, FIELDCAPTION("Vendor Invoice No."));
                ELSE
                    IF "Vendor Cr. Memo No." = '' THEN
                        ERROR(ExtDocNoNeededErr, FIELDCAPTION("Vendor Cr. Memo No."));
            END;
    END;

    LOCAL PROCEDURE PostPurchLine(VAR PurchHeader: Record 38; VAR PurchLine: Record 39; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY; VAR TempDropShptPostBuffer: Record 223 TEMPORARY; VAR EverythingInvoiced: Boolean; VAR ICGenJnlLineNo: Integer);
    VAR
        PurchRcptLine: Record 121;
        PurchInvLine: Record 123;
        PurchCrMemoLine: Record 125;
        InvoicePostBuffer: Record 55;
        CostBaseAmount: Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            IF Type = Type::Item THEN
                CostBaseAmount := "Line Amount";
            UpdateQtyPerUnitOfMeasure(PurchLine);

            TestPurchLine(PurchHeader, PurchLine);
            UpdatePurchLineBeforePost(PurchHeader, PurchLine);

            IF "Qty. to Invoice" + "Quantity Invoiced" <> Quantity THEN
                EverythingInvoiced := FALSE;

            IF Quantity <> 0 THEN BEGIN
                TESTFIELD("No.");
                TESTFIELD(Type);
                TESTFIELD("Gen. Bus. Posting Group");
                TESTFIELD("Gen. Prod. Posting Group");
                DivideAmount(PurchHeader, PurchLine, 1, "Qty. to Invoice", TempVATAmountLine, TempVATAmountLineRemainder);
            END ELSE
                TESTFIELD(Amount, 0);

            CheckItemReservDisruption(PurchLine);
            RoundAmount(PurchHeader, PurchLine, "Qty. to Invoice");

            IF IsCreditDocType THEN BEGIN
                ReverseAmount(PurchLine);
                ReverseAmount(PurchLineACY);
            END;

            RemQtyToBeInvoiced := "Qty. to Invoice";
            RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";

            // Job Credit Memo Item Qty Check
            IF IsCreditDocType THEN
                IF ("Job No." <> '') AND (Type = Type::Item) AND ("Qty. to Invoice" <> 0) THEN
                    JobPostLine.CheckItemQuantityPurchCredit(PurchHeader, PurchLine);

            PostItemTrackingLine(PurchHeader, PurchLine);

            CASE Type OF
                Type::"G/L Account":
                    PostGLAccICLine(PurchHeader, PurchLine, ICGenJnlLineNo);
                Type::Item:
                    PostItemLine(PurchHeader, PurchLine, TempDropShptPostBuffer);
                Enum::"Purchase Line Type".FromInteger(3):
                    ERROR(CannotPurchaseResourcesErr);
                Type::"Charge (Item)":
                    PostItemChargeLine(PurchHeader, PurchLine);
                Type::Resource:  //QB
                    QBCodeunitPublisher.OnPostItemResourceLine(PurchHeader, PurchInvHeader, PurchCrMemoHeader, PurchLine, SrcCode);
            END;

            IF (Type.AsInteger() >= Type::"G/L Account".AsInteger()) AND ("Qty. to Invoice" <> 0) THEN BEGIN
                AdjustPrepmtAmountLCY(PurchHeader, PurchLine);
                FillInvoicePostBuffer(PurchHeader, PurchLine, PurchLineACY, TempInvoicePostBuffer, InvoicePostBuffer);
                InsertPrepmtAdjInvPostingBuf(PurchHeader, PurchLine, TempInvoicePostBuffer, InvoicePostBuffer);
            END;

            IF (PurchRcptHeader."No." <> '') AND ("Receipt No." = '') AND
               NOT RoundingLineInserted AND NOT "Prepayment Line"
            THEN
                InsertReceiptLine(PurchRcptHeader, PurchLine, CostBaseAmount);

            IF (ReturnShptHeader."No." <> '') AND ("Return Shipment No." = '') AND
               NOT RoundingLineInserted
            THEN
                InsertReturnShipmentLine(ReturnShptHeader, PurchLine, CostBaseAmount);

            IF PurchHeader.Invoice THEN
                IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                    PurchInvLine.InitFromPurchLine(PurchInvHeader, xPurchLine);
                    ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation, COPYSTR(PurchInvLine.RowID1, 1, 100));
                    IF "Document Type" = "Document Type"::Order THEN BEGIN
                        PurchInvLine."Order No." := "Document No.";
                        PurchInvLine."Order Line No." := "Line No.";
                    END ELSE
                        IF PurchRcptLine.GET("Receipt No.", "Receipt Line No.") THEN BEGIN
                            PurchInvLine."Order No." := PurchRcptLine."Order No.";
                            PurchInvLine."Order Line No." := PurchRcptLine."Order Line No.";
                        END;
                    OnBeforePurchInvLineInsert(PurchInvLine, PurchInvHeader, PurchLine, SuppressCommit);
                    PurchInvLine.INSERT(TRUE);
                    OnAfterPurchInvLineInsert(
                      PurchInvLine, PurchInvHeader, PurchLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit);
                    CreatePostedDeferralScheduleFromPurchDoc(xPurchLine, PurchInvLine.GetDocumentType,
                      PurchInvHeader."No.", PurchInvLine."Line No.", PurchInvHeader."Posting Date");
                END ELSE BEGIN // Credit Memo
                    PurchCrMemoLine.InitFromPurchLine(PurchCrMemoHeader, xPurchLine);
                    ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation, COPYSTR(PurchCrMemoLine.RowID1, 1, 100));
                    IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                        PurchCrMemoLine."Order No." := "Document No.";
                        PurchCrMemoLine."Order Line No." := "Line No.";
                    END;
                    OnBeforePurchCrMemoLineInsert(PurchCrMemoLine, PurchCrMemoHeader, PurchLine, SuppressCommit);
                    PurchCrMemoLine.INSERT(TRUE);
                    OnAfterPurchCrMemoLineInsert(PurchCrMemoLine, PurchCrMemoHeader, PurchLine, SuppressCommit);
                    CreatePostedDeferralScheduleFromPurchDoc(xPurchLine, PurchCrMemoLine.GetDocumentType,
                      PurchCrMemoHeader."No.", PurchCrMemoLine."Line No.", PurchCrMemoHeader."Posting Date");
                END;

            //JAV 02/04/21: - QB 1.08.32 No hace nada, se elimina la llamada
            //QBCodeunitPublisher.trackingFRISReceiptNoAndReceiptLineNo(PurchCrMemoLine,xPurchLine);
        END;

        OnAfterPostPurchLine(PurchHeader, PurchLine, SuppressCommit);
    END;

    LOCAL PROCEDURE PostGLAndVendor(VAR PurchHeader: Record 38; VAR TempInvoicePostBuffer: Record 55 TEMPORARY);
    BEGIN
        OnBeforePostGLAndVendor(PurchHeader, TempInvoicePostBuffer, PreviewMode, SuppressCommit);

        WITH PurchHeader DO BEGIN
            // Post purchase and VAT to G/L entries from buffer
            PostInvoicePostingBuffer(PurchHeader, TempInvoicePostBuffer);

            // Check External Document number
            IF PurchSetup."Ext. Doc. No. Mandatory" OR (GenJnlLineExtDocNo <> '') THEN
                CheckExternalDocumentNumber(VendLedgEntry, PurchHeader);

            // Post vendor entries
            IF GUIALLOWED THEN
                Window.UPDATE(4, 1);

            PostVendorEntry(
              PurchHeader, TotalPurchLine, TotalPurchLineLCY, GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode);

            UpdatePurchaseHeader(VendLedgEntry);

            // Balancing account
            IF "Bal. Account No." <> '' THEN BEGIN
                IF GUIALLOWED THEN
                    Window.UPDATE(5, 1);
                PostBalancingEntry(
                  PurchHeader, TotalPurchLine, TotalPurchLineLCY, GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode);
            END;
        END;

        OnAfterPostGLAndVendor(PurchHeader, GenJnlPostLine, TotalPurchLine, TotalPurchLineLCY, SuppressCommit);
    END;

    LOCAL PROCEDURE PostGLAccICLine(PurchHeader: Record 38; PurchLine: Record 39; VAR ICGenJnlLineNo: Integer);
    VAR
        GLAcc: Record 15;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforePostGLAccICLine(PurchHeader, PurchLine, ICGenJnlLineNo, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF (PurchLine."No." <> '') AND NOT PurchLine."System-Created Entry" THEN BEGIN
            GLAcc.GET(PurchLine."No.");
            GLAcc.TESTFIELD("Direct Posting");
            IF (PurchLine."Job No." <> '') AND (PurchLine."Qty. to Invoice" <> 0) THEN BEGIN
                CreateJobPurchLine(JobPurchLine, PurchLine, PurchHeader."Prices Including VAT");
                JobPostLine.PostJobOnPurchaseLine(PurchHeader, PurchInvHeader, PurchCrMemoHeader, JobPurchLine, SrcCode);
            END;
            IF (PurchLine."IC Partner Code" <> '') AND PurchHeader.Invoice THEN
                InsertICGenJnlLine(PurchHeader, xPurchLine, ICGenJnlLineNo);

            OnAfterPostAccICLine(PurchLine, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE PostItemLine(PurchHeader: Record 38; VAR PurchLine: Record 39; VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        DummyTrackingSpecification: Record 336;
    BEGIN
        ItemLedgShptEntryNo := 0;
        WITH PurchHeader DO BEGIN
            IF RemQtyToBeInvoiced <> 0 THEN
                ItemLedgShptEntryNo :=
                  PostItemJnlLine(
                    PurchHeader, PurchLine,
                    RemQtyToBeInvoiced, RemQtyToBeInvoicedBase,
                    RemQtyToBeInvoiced, RemQtyToBeInvoicedBase,
                    0, '', DummyTrackingSpecification);
            IF IsCreditDocType THEN BEGIN
                IF ABS(PurchLine."Return Qty. to Ship") > ABS(RemQtyToBeInvoiced) THEN
                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        PurchHeader, PurchLine,
                        PurchLine."Return Qty. to Ship" - RemQtyToBeInvoiced,
                        PurchLine."Return Qty. to Ship (Base)" - RemQtyToBeInvoicedBase,
                        0, 0, 0, '', DummyTrackingSpecification);
            END ELSE BEGIN
                IF ABS(PurchLine."Qty. to Receive") > ABS(RemQtyToBeInvoiced) THEN
                    ItemLedgShptEntryNo :=
                      PostItemJnlLine(
                        PurchHeader, PurchLine,
                        PurchLine."Qty. to Receive" - RemQtyToBeInvoiced,
                        PurchLine."Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
                        0, 0, 0, '', DummyTrackingSpecification);
                IF (PurchLine."Qty. to Receive" <> 0) AND (PurchLine."Sales Order Line No." <> 0) THEN BEGIN
                    TempDropShptPostBuffer."Order No." := PurchLine."Sales Order No.";
                    TempDropShptPostBuffer."Order Line No." := PurchLine."Sales Order Line No.";
                    TempDropShptPostBuffer.Quantity := PurchLine."Qty. to Receive";
                    TempDropShptPostBuffer."Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
                    TempDropShptPostBuffer."Item Shpt. Entry No." :=
                      PostAssocItemJnlLine(PurchHeader, PurchLine, TempDropShptPostBuffer.Quantity, TempDropShptPostBuffer."Quantity (Base)");
                    TempDropShptPostBuffer.INSERT;
                END;
            END;

            OnAfterPostItemLine(PurchLine, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE PostItemChargeLine(PurchHeader: Record 38; PurchLine: Record 39);
    VAR
        PurchaseLineBackup: Record 39;
    BEGIN
        IF NOT (PurchHeader.Invoice AND (PurchLine."Qty. to Invoice" <> 0)) THEN
            EXIT;

        ItemJnlRollRndg := TRUE;
        PurchaseLineBackup.COPY(PurchLine);
        IF FindTempItemChargeAssgntPurch(PurchaseLineBackup."Line No.") THEN
            REPEAT
                CASE TempItemChargeAssgntPurch."Applies-to Doc. Type" OF
                    TempItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
                        BEGIN
                            PostItemChargePerRcpt(PurchHeader, PurchaseLineBackup);
                            TempItemChargeAssgntPurch.MARK(TRUE);
                        END;
                    TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt":
                        BEGIN
                            PostItemChargePerTransfer(PurchHeader, PurchaseLineBackup);
                            TempItemChargeAssgntPurch.MARK(TRUE);
                        END;
                    TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment":
                        BEGIN
                            PostItemChargePerRetShpt(PurchHeader, PurchaseLineBackup);
                            TempItemChargeAssgntPurch.MARK(TRUE);
                        END;
                    TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
                        BEGIN
                            PostItemChargePerSalesShpt(PurchHeader, PurchaseLineBackup);
                            TempItemChargeAssgntPurch.MARK(TRUE);
                        END;
                    TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Receipt":
                        BEGIN
                            PostItemChargePerRetRcpt(PurchHeader, PurchaseLineBackup);
                            TempItemChargeAssgntPurch.MARK(TRUE);
                        END;
                    TempItemChargeAssgntPurch."Applies-to Doc. Type"::Order,
                  TempItemChargeAssgntPurch."Applies-to Doc. Type"::Invoice,
                  TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Order",
                  TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Credit Memo":
                        CheckItemCharge(TempItemChargeAssgntPurch);
                END;
            UNTIL TempItemChargeAssgntPurch.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemTrackingLine(PurchHeader: Record 38; PurchLine: Record 39);
    VAR
        TempTrackingSpecification: Record 336 TEMPORARY;
        TrackingSpecificationExists: Boolean;
    BEGIN
        IF PurchLine."Prepayment Line" THEN
            EXIT;

        IF PurchHeader.Invoice THEN
            IF PurchLine."Qty. to Invoice" = 0 THEN
                TrackingSpecificationExists := FALSE
            ELSE
                TrackingSpecificationExists :=
                  ReservePurchLine.RetrieveInvoiceSpecification(PurchLine, TempTrackingSpecification);

        PostItemTracking(PurchHeader, PurchLine, TempTrackingSpecification, TrackingSpecificationExists);

        IF TrackingSpecificationExists THEN
            SaveInvoiceSpecification(TempTrackingSpecification);
    END;

    LOCAL PROCEDURE PostItemJnlLine(PurchHeader: Record 38; PurchLine: Record 39; QtyToBeReceived: Decimal; QtyToBeReceivedBase: Decimal; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; ItemLedgShptEntryNo: Integer; ItemChargeNo: Code[20]; TrackingSpecification: Record 336): Integer;
    VAR
        ItemJnlLine: Record 83;
        OriginalItemJnlLine: Record 83;
        TempWhseJnlLine: Record 7311 TEMPORARY;
        TempWhseTrackingSpecification: Record 336 TEMPORARY;
        TempTrackingSpecificationChargeAssmt: Record 336 TEMPORARY;
        CurrExchRate: Record 330;
        TempReservationEntry: Record 337 TEMPORARY;
        Factor: Decimal;
        PostWhseJnlLine: Boolean;
        CheckApplToItemEntry: Boolean;
        PostJobConsumptionBeforePurch: Boolean;
    BEGIN
        IF NOT ItemJnlRollRndg THEN BEGIN
            RemAmt := 0;
            RemDiscAmt := 0;
        END;

        OnBeforePostItemJnlLine(
          PurchHeader, PurchLine, QtyToBeReceived, QtyToBeReceivedBase, QtyToBeInvoiced, QtyToBeInvoicedBase,
          ItemLedgShptEntryNo, ItemChargeNo, TrackingSpecification, SuppressCommit);

        WITH ItemJnlLine DO BEGIN
            INIT;
            CopyFromPurchHeader(PurchHeader);
            CopyFromPurchLine(PurchLine);

            IF QtyToBeReceived = 0 THEN
                IF PurchLine.IsCreditDocType THEN
                    CopyDocumentFields(
                      "Document Type"::"Purchase Credit Memo", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PurchHeader."Posting No. Series")
                ELSE
                    CopyDocumentFields(
                      "Document Type"::"Purchase Invoice", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PurchHeader."Posting No. Series")
            ELSE BEGIN
                IF PurchLine.IsCreditDocType THEN
                    CopyDocumentFields(
                      "Document Type"::"Purchase Return Shipment",
                      ReturnShptHeader."No.", ReturnShptHeader."Vendor Authorization No.", SrcCode, ReturnShptHeader."No. Series")
                ELSE
                    CopyDocumentFields(
                      "Document Type"::"Purchase Receipt",
                      PurchRcptHeader."No.", PurchRcptHeader."Vendor Shipment No.", SrcCode, PurchRcptHeader."No. Series");
                IF QtyToBeInvoiced <> 0 THEN BEGIN
                    IF "Document No." = '' THEN
                        IF PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo" THEN
                            CopyDocumentFields(
                              "Document Type"::"Purchase Credit Memo", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PurchHeader."Posting No. Series")
                        ELSE
                            CopyDocumentFields(
                              "Document Type"::"Purchase Invoice", GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PurchHeader."Posting No. Series");
                END;
            END;

            IF QtyToBeInvoiced <> 0 THEN
                "Invoice No." := GenJnlLineDocNo;

            CopyTrackingFromSpec(TrackingSpecification);
            "Item Shpt. Entry No." := ItemLedgShptEntryNo;

            Quantity := QtyToBeReceived;
            "Quantity (Base)" := QtyToBeReceivedBase;
            "Invoiced Quantity" := QtyToBeInvoiced;
            "Invoiced Qty. (Base)" := QtyToBeInvoicedBase;

            IF ItemChargeNo <> '' THEN BEGIN
                "Item Charge No." := ItemChargeNo;
                PurchLine."Qty. to Invoice" := QtyToBeInvoiced;
            END;

            IF QtyToBeInvoiced <> 0 THEN BEGIN
                IF (QtyToBeInvoicedBase <> 0) AND (PurchLine.Type = PurchLine.Type::Item) THEN
                    Factor := QtyToBeInvoicedBase / PurchLine."Qty. to Invoice (Base)"
                ELSE
                    Factor := QtyToBeInvoiced / PurchLine."Qty. to Invoice";
                OnPostItemJnlLineOnAfterSetFactor(PurchLine, Factor);
                Amount := PurchLine.Amount * Factor + RemAmt;
                IF PurchHeader."Prices Including VAT" THEN
                    "Discount Amount" :=
                      (PurchLine."Line Discount Amount" + PurchLine."Inv. Discount Amount" + PurchLine."Pmt. Discount Amount") /
                      (1 + PurchLine."VAT %" / 100) * Factor + RemDiscAmt
                ELSE
                    "Discount Amount" :=
                      (PurchLine."Line Discount Amount" + PurchLine."Inv. Discount Amount" + PurchLine."Pmt. Discount Amount") *
                      Factor + RemDiscAmt;
                RemAmt := Amount - ROUND(Amount);
                RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
                Amount := ROUND(Amount);
                "Discount Amount" := ROUND("Discount Amount");
                "Pmt. Discount Amount" := PurchLine."Pmt. Discount Amount";
            END ELSE BEGIN
                IF PurchHeader."Prices Including VAT" THEN
                    Amount :=
                      (QtyToBeReceived * PurchLine."Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100) /
                       (1 + PurchLine."VAT %" / 100)) + RemAmt
                ELSE
                    Amount :=
                      (QtyToBeReceived * PurchLine."Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100)) + RemAmt;
                RemAmt := Amount - ROUND(Amount);
                IF PurchHeader."Currency Code" <> '' THEN
                    Amount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          PurchHeader."Posting Date", PurchHeader."Currency Code",
                          Amount, PurchHeader."Currency Factor"))
                ELSE
                    Amount := ROUND(Amount);
            END;

            IF PurchLine."Prod. Order No." <> '' THEN
                PostItemJnlLineCopyProdOrder(PurchLine, ItemJnlLine, QtyToBeReceived, QtyToBeInvoiced);

            CheckApplToItemEntry := SetCheckApplToItemEntry(PurchLine);

            PostWhseJnlLine := ShouldPostWhseJnlLine(PurchLine, ItemJnlLine, TempWhseJnlLine);

            QBCodeunitPublisher.OnPostItemJnlLinePurchPost(PurchLine, ItemJnlLine, QtyToBeReceivedBase);

            IF QtyToBeReceivedBase <> 0 THEN BEGIN
                IF PurchLine.IsCreditDocType THEN
                    ReservePurchLine.TransferPurchLineToItemJnlLine(
                      PurchLine, ItemJnlLine, -QtyToBeReceivedBase, CheckApplToItemEntry)
                ELSE
                    ReservePurchLine.TransferPurchLineToItemJnlLine(
                      PurchLine, ItemJnlLine, QtyToBeReceivedBase, CheckApplToItemEntry);

                IF CheckApplToItemEntry AND PurchLine.IsInventoriableItem THEN
                    PurchLine.TESTFIELD("Appl.-to Item Entry");
            END;

            CollectPurchaseLineReservEntries(TempReservationEntry, ItemJnlLine);
            OriginalItemJnlLine := ItemJnlLine;

            OnBeforeItemJnlPostLine(ItemJnlLine, PurchLine, PurchHeader, SuppressCommit);

            TempHandlingSpecification.RESET;
            TempHandlingSpecification.DELETEALL;
            IF PurchLine."Job No." <> '' THEN BEGIN
                PostJobConsumptionBeforePurch := IsPurchaseReturn;
                IF PostJobConsumptionBeforePurch THEN
                    PostItemJnlLineJobConsumption(
                      PurchHeader, PurchLine, OriginalItemJnlLine, TempReservationEntry, QtyToBeInvoiced, QtyToBeReceived,
                      TempHandlingSpecification, 0);
            END;

            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            IF NOT Subcontracting THEN
                PostItemJnlLineTracking(
                  PurchLine, TempWhseTrackingSpecification, TempTrackingSpecificationChargeAssmt, PostWhseJnlLine, QtyToBeInvoiced);

            OnBeforePostItemJnlLineJobConsumption(
              ItemJnlLine, PurchLine, PurchInvHeader, PurchCrMemoHeader, QtyToBeInvoiced, QtyToBeInvoicedBase, SrcCode);

            IF PurchLine."Job No." <> '' THEN
                IF NOT PostJobConsumptionBeforePurch THEN
                    PostItemJnlLineJobConsumption(
                      PurchHeader, PurchLine, OriginalItemJnlLine, TempReservationEntry, QtyToBeInvoiced, QtyToBeReceived,
                      TempHandlingSpecification, "Item Shpt. Entry No.");

            IF PostWhseJnlLine THEN BEGIN
                PostItemJnlLineWhseLine(TempWhseJnlLine, TempWhseTrackingSpecification, PurchLine, PostJobConsumptionBeforePurch);
                OnAfterPostWhseJnlLine(PurchLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit);
            END;
            IF (PurchLine.Type = PurchLine.Type::Item) AND PurchHeader.Invoice THEN
                PostItemJnlLineItemCharges(
                  PurchHeader, PurchLine, OriginalItemJnlLine, "Item Shpt. Entry No.", TempTrackingSpecificationChargeAssmt);
        END;

        EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE PostItemJnlLineCopyProdOrder(PurchLine: Record 39; VAR ItemJnlLine: Record 83; QtyToBeReceived: Decimal; QtyToBeInvoiced: Decimal);
    BEGIN
        WITH PurchLine DO BEGIN
            ItemJnlLine.Subcontracting := TRUE;
            ItemJnlLine."Quantity (Base)" := CalcBaseQty("No.", "Unit of Measure Code", QtyToBeReceived);
            ItemJnlLine."Invoiced Qty. (Base)" := CalcBaseQty("No.", "Unit of Measure Code", QtyToBeInvoiced);
            ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
            ItemJnlLine."Unit Cost (ACY)" := "Unit Cost";
            ItemJnlLine."Output Quantity (Base)" := ItemJnlLine."Quantity (Base)";
            ItemJnlLine."Output Quantity" := QtyToBeReceived;
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Output;
            ItemJnlLine.Type := ItemJnlLine.Type::"Work Center";
            ItemJnlLine."No." := "Work Center No.";
            ItemJnlLine."Routing No." := "Routing No.";
            ItemJnlLine."Routing Reference No." := "Routing Reference No.";
            ItemJnlLine."Operation No." := "Operation No.";
            ItemJnlLine."Work Center No." := "Work Center No.";
            ItemJnlLine."Unit Cost Calculation" := ItemJnlLine."Unit Cost Calculation"::Units;
            IF Finished THEN
                ItemJnlLine.Finished := Finished;
        END;
        OnAfterPostItemJnlLineCopyProdOrder(ItemJnlLine, PurchLine, PurchRcptHeader, QtyToBeReceived, SuppressCommit);
    END;

    LOCAL PROCEDURE PostItemJnlLineItemCharges(PurchHeader: Record 38; PurchLine: Record 39; VAR OriginalItemJnlLine: Record 83; ItemShptEntryNo: Integer; VAR TempTrackingSpecificationChargeAssmt: Record 336 TEMPORARY);
    VAR
        ItemChargePurchLine: Record 39;
    BEGIN
        WITH PurchLine DO BEGIN
            ClearItemChargeAssgntFilter;
            TempItemChargeAssgntPurch.SETCURRENTKEY(
              "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
            TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type", "Document Type");
            TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.", "Document No.");
            TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.", "Line No.");
            IF TempItemChargeAssgntPurch.FIND('-') THEN
                REPEAT
                    TESTFIELD("Allow Item Charge Assignment");
                    GetItemChargeLine(PurchHeader, ItemChargePurchLine);
                    ItemChargePurchLine.CALCFIELDS("Qty. Assigned");
                    IF (ItemChargePurchLine."Qty. to Invoice" <> 0) OR
                       (ABS(ItemChargePurchLine."Qty. Assigned") < ABS(ItemChargePurchLine."Quantity Invoiced"))
                    THEN BEGIN
                        OriginalItemJnlLine."Item Shpt. Entry No." := ItemShptEntryNo;
                        PostItemChargePerOrder(
                          PurchHeader, PurchLine, OriginalItemJnlLine, ItemChargePurchLine, TempTrackingSpecificationChargeAssmt);
                        TempItemChargeAssgntPurch.MARK(TRUE);
                    END;
                UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostItemJnlLineTracking(PurchLine: Record 39; VAR TempWhseTrackingSpecification: Record 336 TEMPORARY; VAR TempTrackingSpecificationChargeAssmt: Record 336 TEMPORARY; PostWhseJnlLine: Boolean; QtyToBeInvoiced: Decimal);
    BEGIN
        IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN
            IF TempHandlingSpecification.FIND('-') THEN
                REPEAT
                    TempTrackingSpecification := TempHandlingSpecification;
                    TempTrackingSpecification.SetSourceFromPurchLine(PurchLine);
                    IF TempTrackingSpecification.INSERT THEN;
                    IF QtyToBeInvoiced <> 0 THEN BEGIN
                        TempTrackingSpecificationInv := TempTrackingSpecification;
                        IF TempTrackingSpecificationInv.INSERT THEN;
                    END;
                    IF PostWhseJnlLine THEN BEGIN
                        TempWhseTrackingSpecification := TempTrackingSpecification;
                        IF TempWhseTrackingSpecification.INSERT THEN;
                    END;
                    TempTrackingSpecificationChargeAssmt := TempTrackingSpecification;
                    TempTrackingSpecificationChargeAssmt.INSERT;
                UNTIL TempHandlingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemJnlLineWhseLine(VAR TempWhseJnlLine: Record 7311 TEMPORARY; VAR TempWhseTrackingSpecification: Record 336 TEMPORARY; PurchLine: Record 39; PostBefore: Boolean);
    VAR
        TempWhseJnlLine2: Record 7311 TEMPORARY;
    BEGIN
        ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2, TempWhseTrackingSpecification, FALSE);
        IF TempWhseJnlLine2.FIND('-') THEN
            REPEAT
                IF PurchLine.IsCreditDocType AND (PurchLine.Quantity > 0) OR
                   PurchLine.IsInvoiceDocType AND (PurchLine.Quantity < 0)
                THEN
                    CreatePositiveEntry(TempWhseJnlLine2, PurchLine."Job No.", PostBefore);
                WhseJnlPostLine.RUN(TempWhseJnlLine2);
                IF RevertWarehouseEntry(TempWhseJnlLine2, PurchLine."Job No.", PostBefore) THEN
                    WhseJnlPostLine.RUN(TempWhseJnlLine2);
            UNTIL TempWhseJnlLine2.NEXT = 0;
        TempWhseTrackingSpecification.DELETEALL;
    END;

    LOCAL PROCEDURE ShouldPostWhseJnlLine(PurchLine: Record 39; VAR ItemJnlLine: Record 83; VAR TempWhseJnlLine: Record 7311 TEMPORARY): Boolean;
    BEGIN
        WITH PurchLine DO
            IF ("Location Code" <> '') AND (Type = Type::Item) AND (ItemJnlLine.Quantity <> 0) AND
               NOT ItemJnlLine.Subcontracting
            THEN BEGIN
                GetLocation("Location Code");
                IF (("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) AND
                    Location."Directed Put-away and Pick") OR
                   (Location."Bin Mandatory" AND NOT (WhseReceive OR WhseShip OR InvtPickPutaway OR "Drop Shipment"))
                THEN BEGIN
                    CreateWhseJnlLine(ItemJnlLine, PurchLine, TempWhseJnlLine);
                    EXIT(TRUE);
                END;
            END;
    END;

    LOCAL PROCEDURE PostItemChargePerOrder(PurchHeader: Record 38; PurchLine: Record 39; ItemJnlLine2: Record 83; ItemChargePurchLine: Record 39; VAR TempTrackingSpecificationChargeAssmt: Record 336 TEMPORARY);
    VAR
        NonDistrItemJnlLine: Record 83;
        CurrExchRate: Record 330;
        OriginalAmt: Decimal;
        OriginalAmtACY: Decimal;
        OriginalDiscountAmt: Decimal;
        OriginalQty: Decimal;
        QtyToInvoice: Decimal;
        Factor: Decimal;
        TotalChargeAmt2: Decimal;
        TotalChargeAmtLCY2: Decimal;
        SignFactor: Integer;
    BEGIN
        OnBeforePostItemChargePerOrder(
          PurchHeader, PurchLine, ItemJnlLine2, ItemChargePurchLine, TempTrackingSpecificationChargeAssmt, SuppressCommit,
          TempItemChargeAssgntPurch);

        WITH TempItemChargeAssgntPurch DO BEGIN
            PurchLine.TESTFIELD("Allow Item Charge Assignment", TRUE);
            ItemJnlLine2."Document No." := GenJnlLineDocNo;
            ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
            ItemJnlLine2."Item Charge No." := "Item Charge No.";
            ItemJnlLine2.Description := ItemChargePurchLine.Description;
            ItemJnlLine2."Document Line No." := ItemChargePurchLine."Line No.";
            ItemJnlLine2."Unit of Measure Code" := '';
            ItemJnlLine2."Qty. per Unit of Measure" := 1;
            IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                QtyToInvoice :=
                  CalcQtyToInvoice(PurchLine."Return Qty. to Ship (Base)", PurchLine."Qty. to Invoice (Base)")
            ELSE
                QtyToInvoice :=
                  CalcQtyToInvoice(PurchLine."Qty. to Receive (Base)", PurchLine."Qty. to Invoice (Base)");
            IF ItemJnlLine2."Invoiced Quantity" = 0 THEN BEGIN
                ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
                ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
            END;
            ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
            IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
            ItemJnlLine2."Unit Cost (ACY)" :=
              ROUND(
                ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                Currency."Unit-Amount Rounding Precision");

            TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
            IF PurchHeader."Currency Code" <> '' THEN
                ItemJnlLine2.Amount :=
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    Usedate, PurchHeader."Currency Code", TotalChargeAmt2 + TotalPurchLine.Amount, PurchHeader."Currency Factor") -
                  TotalChargeAmtLCY2 - TotalPurchLineLCY.Amount
            ELSE
                ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

            TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
            ItemJnlLine2."Unit Cost" := ROUND(
                ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)", GLSetup."Unit-Amount Rounding Precision");
            ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";
            ItemJnlLine2."Overhead Rate" := 0;

            IF PurchHeader."Currency Code" <> '' THEN
                ItemJnlLine2."Discount Amount" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code", (ItemChargePurchLine."Inv. Discount Amount" +
                                                           ItemChargePurchLine."Pmt. Discount Amount" +
                                                           ItemChargePurchLine."Line Discount Amount") *
                      ItemJnlLine2."Invoiced Qty. (Base)" /
                      ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                      PurchHeader."Currency Factor"), GLSetup."Amount Rounding Precision")
            ELSE
                ItemJnlLine2."Discount Amount" := ROUND(
                    (ItemChargePurchLine."Line Discount Amount" + ItemChargePurchLine."Inv. Discount Amount" +
                     ItemChargePurchLine."Pmt. Discount Amount") *
                    ItemJnlLine2."Invoiced Qty. (Base)" /
                    ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                    GLSetup."Amount Rounding Precision");

            ItemJnlLine2."Pmt. Discount Amount" :=
              ItemChargePurchLine."Pmt. Discount Amount" *
              ItemJnlLine2."Invoiced Qty. (Base)" / ItemChargePurchLine."Quantity (Base)" *
              "Qty. to Assign" / QtyToInvoice;
            IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN BEGIN
                ItemJnlLine2."Discount Amount" := -ItemJnlLine2."Discount Amount";
                ItemJnlLine2."Pmt. Discount Amount" := -ItemJnlLine2."Pmt. Discount Amount";
            END;

            ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargePurchLine."Shortcut Dimension 1 Code";
            ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargePurchLine."Shortcut Dimension 2 Code";
            ItemJnlLine2."Dimension Set ID" := ItemChargePurchLine."Dimension Set ID";
            ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargePurchLine."Gen. Prod. Posting Group";

            OnPostItemChargePerOrderOnAfterCopyToItemJnlLine(ItemJnlLine2, ItemChargePurchLine, GLSetup, QtyToInvoice);
        END;

        WITH TempTrackingSpecificationChargeAssmt DO BEGIN
            RESET;
            SETRANGE("Source Type", DATABASE::"Purchase Line");
            SETRANGE("Source ID", TempItemChargeAssgntPurch."Applies-to Doc. No.");
            SETRANGE("Source Ref. No.", TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
            IF ISEMPTY THEN
                ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
            ELSE BEGIN
                FINDSET;
                NonDistrItemJnlLine := ItemJnlLine2;
                OriginalAmt := NonDistrItemJnlLine.Amount;
                OriginalAmtACY := NonDistrItemJnlLine."Amount (ACY)";
                OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
                OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
                IF ("Quantity (Base)" / OriginalQty) > 0 THEN
                    SignFactor := 1
                ELSE
                    SignFactor := -1;
                REPEAT
                    Factor := "Quantity (Base)" / OriginalQty * SignFactor;
                    IF ABS("Quantity (Base)") < ABS(NonDistrItemJnlLine."Quantity (Base)") THEN BEGIN
                        ItemJnlLine2."Quantity (Base)" := "Quantity (Base)";
                        ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
                        ItemJnlLine2."Amount (ACY)" :=
                          ROUND(OriginalAmtACY * Factor, GLSetup."Amount Rounding Precision");
                        ItemJnlLine2.Amount :=
                          ROUND(OriginalAmt * Factor, GLSetup."Amount Rounding Precision");
                        ItemJnlLine2."Unit Cost (ACY)" :=
                          ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                            Currency."Unit-Amount Rounding Precision") * SignFactor;
                        ItemJnlLine2."Unit Cost" :=
                          ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                            GLSetup."Unit-Amount Rounding Precision") * SignFactor;
                        ItemJnlLine2."Discount Amount" :=
                          ROUND(OriginalDiscountAmt * Factor, GLSetup."Amount Rounding Precision");
                        ItemJnlLine2."Item Shpt. Entry No." := "Item Ledger Entry No.";
                        ItemJnlLine2."Applies-to Entry" := "Item Ledger Entry No.";
                        ItemJnlLine2.CopyTrackingFromSpec(TempTrackingSpecificationChargeAssmt);
                        ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
                        ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
                        NonDistrItemJnlLine."Quantity (Base)" -= "Quantity (Base)";
                        NonDistrItemJnlLine.Amount -= (ItemJnlLine2.Amount * SignFactor);
                        NonDistrItemJnlLine."Amount (ACY)" -= (ItemJnlLine2."Amount (ACY)" * SignFactor);
                        NonDistrItemJnlLine."Discount Amount" -= (ItemJnlLine2."Discount Amount" * SignFactor);
                    END ELSE BEGIN
                        NonDistrItemJnlLine."Quantity (Base)" := "Quantity (Base)";
                        NonDistrItemJnlLine."Invoiced Qty. (Base)" := "Quantity (Base)";
                        NonDistrItemJnlLine."Unit Cost" :=
                          ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                            GLSetup."Unit-Amount Rounding Precision") * SignFactor;
                        NonDistrItemJnlLine."Unit Cost (ACY)" :=
                          ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                            Currency."Unit-Amount Rounding Precision") * SignFactor;
                        NonDistrItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No.";
                        NonDistrItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
                        NonDistrItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecificationChargeAssmt);
                        ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
                        NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
                    END;
                UNTIL NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE PostItemChargePerRcpt(PurchHeader: Record 38; VAR PurchLine: Record 39);
    VAR
        PurchRcptLine: Record 121;
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
        Sign: Decimal;
        DistributeCharge: Boolean;
    BEGIN
        IF NOT PurchRcptLine.GET(
             TempItemChargeAssgntPurch."Applies-to Doc. No.", TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
        THEN
            ERROR(ReceiptLinesDeletedErr);

        Sign := 1;

        IF PurchRcptLine."Item Rcpt. Entry No." <> 0 THEN
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, PurchRcptLine."Quantity (Base)", PurchRcptLine."Item Rcpt. Entry No.")
        ELSE BEGIN
            DistributeCharge := TRUE;
            ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
              DATABASE::"Purch. Rcpt. Line", 0, PurchRcptLine."Document No.",
              '', 0, PurchRcptLine."Line No.", PurchRcptLine."Quantity (Base)");
        END;

        IF DistributeCharge THEN
            PostDistributeItemCharge(
              PurchHeader, PurchLine, TempItemLedgEntry, PurchRcptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Qty. to Assign", TempItemChargeAssgntPurch."Amount to Assign",
              Sign, PurchRcptLine."Indirect Cost %")
        ELSE
            PostItemCharge(PurchHeader, PurchLine,
              PurchRcptLine."Item Rcpt. Entry No.", PurchRcptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Amount to Assign" * Sign,
              TempItemChargeAssgntPurch."Qty. to Assign",
              PurchRcptLine."Indirect Cost %");
    END;

    LOCAL PROCEDURE PostItemChargePerRetShpt(PurchHeader: Record 38; VAR PurchLine: Record 39);
    VAR
        ReturnShptLine: Record 6651;
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
        Sign: Decimal;
        DistributeCharge: Boolean;
    BEGIN
        ReturnShptLine.GET(
          TempItemChargeAssgntPurch."Applies-to Doc. No.", TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
        ReturnShptLine.TESTFIELD("Job No.", '');

        Sign := GetSign(PurchLine."Line Amount");
        IF PurchLine.IsCreditDocType THEN
            Sign := -Sign;

        IF ReturnShptLine."Item Shpt. Entry No." <> 0 THEN
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, -ReturnShptLine."Quantity (Base)", ReturnShptLine."Item Shpt. Entry No.")
        ELSE BEGIN
            DistributeCharge := TRUE;
            ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
              DATABASE::"Return Shipment Line", 0, ReturnShptLine."Document No.",
              '', 0, ReturnShptLine."Line No.", ReturnShptLine."Quantity (Base)");
        END;

        IF DistributeCharge THEN
            PostDistributeItemCharge(
              PurchHeader, PurchLine, TempItemLedgEntry, -ReturnShptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Qty. to Assign", ABS(TempItemChargeAssgntPurch."Amount to Assign"),
              Sign, ReturnShptLine."Indirect Cost %")
        ELSE
            PostItemCharge(PurchHeader, PurchLine,
              ReturnShptLine."Item Shpt. Entry No.", -ReturnShptLine."Quantity (Base)",
              ABS(TempItemChargeAssgntPurch."Amount to Assign") * Sign,
              TempItemChargeAssgntPurch."Qty. to Assign",
              ReturnShptLine."Indirect Cost %");
    END;

    LOCAL PROCEDURE PostItemChargePerTransfer(PurchHeader: Record 38; VAR PurchLine: Record 39);
    VAR
        TransRcptLine: Record 5747;
        ItemApplnEntry: Record 339;
        DummyTrackingSpecification: Record 336;
        PurchLine2: Record 39;
        CurrExchRate: Record 330;
        TotalAmountToPostFCY: Decimal;
        TotalAmountToPostLCY: Decimal;
        TotalDiscAmountToPost: Decimal;
        AmountToPostFCY: Decimal;
        AmountToPostLCY: Decimal;
        DiscAmountToPost: Decimal;
        RemAmountToPostFCY: Decimal;
        RemAmountToPostLCY: Decimal;
        RemDiscAmountToPost: Decimal;
        CalcAmountToPostFCY: Decimal;
        CalcAmountToPostLCY: Decimal;
        CalcDiscAmountToPost: Decimal;
    BEGIN
        WITH TempItemChargeAssgntPurch DO BEGIN
            TransRcptLine.GET("Applies-to Doc. No.", "Applies-to Doc. Line No.");
            PurchLine2 := PurchLine;
            PurchLine2."No." := "Item No.";
            PurchLine2."Variant Code" := TransRcptLine."Variant Code";
            PurchLine2."Location Code" := TransRcptLine."Transfer-to Code";
            PurchLine2."Bin Code" := '';
            PurchLine2."Line No." := "Document Line No.";

            IF TransRcptLine."Item Rcpt. Entry No." = 0 THEN
                PostItemChargePerITTransfer(PurchHeader, PurchLine, TransRcptLine)
            ELSE BEGIN
                TotalAmountToPostFCY := "Amount to Assign";
                IF PurchHeader."Currency Code" <> '' THEN
                    TotalAmountToPostLCY :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        Usedate, PurchHeader."Currency Code",
                        TotalAmountToPostFCY, PurchHeader."Currency Factor")
                ELSE
                    TotalAmountToPostLCY := TotalAmountToPostFCY;

                TotalDiscAmountToPost :=
                  ROUND(
                    PurchLine2."Inv. Discount Amount" / PurchLine2.Quantity * "Qty. to Assign",
                    GLSetup."Amount Rounding Precision");
                TotalDiscAmountToPost :=
                  TotalDiscAmountToPost +
                  ROUND(
                    PurchLine2."Line Discount Amount" * ("Qty. to Assign" / PurchLine2."Qty. to Invoice"),
                    GLSetup."Amount Rounding Precision");

                TotalAmountToPostLCY := ROUND(TotalAmountToPostLCY, GLSetup."Amount Rounding Precision");

                ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                ItemApplnEntry.SETRANGE("Outbound Item Entry No.", TransRcptLine."Item Rcpt. Entry No.");
                ItemApplnEntry.SETFILTER("Item Ledger Entry No.", '<>%1', TransRcptLine."Item Rcpt. Entry No.");
                ItemApplnEntry.SETRANGE("Cost Application", TRUE);
                IF ItemApplnEntry.FINDSET THEN
                    REPEAT
                        PurchLine2."Appl.-to Item Entry" := ItemApplnEntry."Item Ledger Entry No.";
                        CalcAmountToPostFCY :=
                          ((TotalAmountToPostFCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                          RemAmountToPostFCY;
                        AmountToPostFCY := ROUND(CalcAmountToPostFCY);
                        RemAmountToPostFCY := CalcAmountToPostFCY - AmountToPostFCY;
                        CalcAmountToPostLCY :=
                          ((TotalAmountToPostLCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                          RemAmountToPostLCY;
                        AmountToPostLCY := ROUND(CalcAmountToPostLCY);
                        RemAmountToPostLCY := CalcAmountToPostLCY - AmountToPostLCY;
                        CalcDiscAmountToPost :=
                          ((TotalDiscAmountToPost / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                          RemDiscAmountToPost;
                        DiscAmountToPost := ROUND(CalcDiscAmountToPost);
                        RemDiscAmountToPost := CalcDiscAmountToPost - DiscAmountToPost;
                        PurchLine2.Amount := AmountToPostLCY;
                        PurchLine2."Inv. Discount Amount" := DiscAmountToPost;
                        PurchLine2."Line Discount Amount" := 0;
                        PurchLine2."Unit Cost" :=
                          ROUND(AmountToPostFCY / ItemApplnEntry.Quantity, GLSetup."Unit-Amount Rounding Precision");
                        PurchLine2."Unit Cost (LCY)" :=
                          ROUND(AmountToPostLCY / ItemApplnEntry.Quantity, GLSetup."Unit-Amount Rounding Precision");
                        IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                            PurchLine2.Amount := -PurchLine2.Amount;
                        PostItemJnlLine(
                          PurchHeader, PurchLine2,
                          0, 0,
                          ItemApplnEntry.Quantity, ItemApplnEntry.Quantity,
                          PurchLine2."Appl.-to Item Entry", "Item Charge No.", DummyTrackingSpecification);
                    UNTIL ItemApplnEntry.NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE PostItemChargePerITTransfer(PurchHeader: Record 38; VAR PurchLine: Record 39; TransRcptLine: Record 5747);
    VAR
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
    BEGIN
        WITH TempItemChargeAssgntPurch DO BEGIN
            ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
              DATABASE::"Transfer Receipt Line", 0, TransRcptLine."Document No.",
              '', 0, TransRcptLine."Line No.", TransRcptLine."Quantity (Base)");
            PostDistributeItemCharge(
              PurchHeader, PurchLine, TempItemLedgEntry, TransRcptLine."Quantity (Base)",
              "Qty. to Assign", "Amount to Assign", 1, 0);
        END;
    END;

    LOCAL PROCEDURE PostItemChargePerSalesShpt(PurchHeader: Record 38; VAR PurchLine: Record 39);
    VAR
        SalesShptLine: Record 111;
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
        Sign: Decimal;
        DistributeCharge: Boolean;
    BEGIN
        IF NOT SalesShptLine.GET(
             TempItemChargeAssgntPurch."Applies-to Doc. No.", TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
        THEN
            ERROR(RelatedItemLedgEntriesNotFoundErr);
        SalesShptLine.TESTFIELD("Job No.", '');

        Sign := -GetSign(SalesShptLine."Quantity (Base)");

        IF SalesShptLine."Item Shpt. Entry No." <> 0 THEN
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, -SalesShptLine."Quantity (Base)", SalesShptLine."Item Shpt. Entry No.")
        ELSE BEGIN
            DistributeCharge := TRUE;
            ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
              DATABASE::"Sales Shipment Line", 0, SalesShptLine."Document No.",
              '', 0, SalesShptLine."Line No.", SalesShptLine."Quantity (Base)");
        END;

        IF DistributeCharge THEN
            PostDistributeItemCharge(
              PurchHeader, PurchLine, TempItemLedgEntry, -SalesShptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Qty. to Assign", TempItemChargeAssgntPurch."Amount to Assign", Sign, 0)
        ELSE
            PostItemCharge(PurchHeader, PurchLine,
              SalesShptLine."Item Shpt. Entry No.", -SalesShptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Amount to Assign" * Sign,
              TempItemChargeAssgntPurch."Qty. to Assign", 0)
    END;

    LOCAL PROCEDURE PostItemChargePerRetRcpt(PurchHeader: Record 38; VAR PurchLine: Record 39);
    VAR
        ReturnRcptLine: Record 6661;
        TempItemLedgEntry: Record 32 TEMPORARY;
        ItemTrackingMgt: Codeunit 6500;
        Sign: Decimal;
        DistributeCharge: Boolean;
    BEGIN
        IF NOT ReturnRcptLine.GET(
             TempItemChargeAssgntPurch."Applies-to Doc. No.", TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
        THEN
            ERROR(RelatedItemLedgEntriesNotFoundErr);
        ReturnRcptLine.TESTFIELD("Job No.", '');
        Sign := GetSign(ReturnRcptLine."Quantity (Base)");

        IF ReturnRcptLine."Item Rcpt. Entry No." <> 0 THEN
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, ReturnRcptLine."Quantity (Base)", ReturnRcptLine."Item Rcpt. Entry No.")
        ELSE BEGIN
            DistributeCharge := TRUE;
            ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
              DATABASE::"Return Receipt Line", 0, ReturnRcptLine."Document No.",
              '', 0, ReturnRcptLine."Line No.", ReturnRcptLine."Quantity (Base)");
        END;

        IF DistributeCharge THEN
            PostDistributeItemCharge(
              PurchHeader, PurchLine, TempItemLedgEntry, ReturnRcptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Qty. to Assign", TempItemChargeAssgntPurch."Amount to Assign", Sign, 0)
        ELSE
            PostItemCharge(PurchHeader, PurchLine,
              ReturnRcptLine."Item Rcpt. Entry No.", ReturnRcptLine."Quantity (Base)",
              TempItemChargeAssgntPurch."Amount to Assign" * Sign,
              TempItemChargeAssgntPurch."Qty. to Assign", 0)
    END;

    LOCAL PROCEDURE PostDistributeItemCharge(PurchHeader: Record 38; PurchLine: Record 39; VAR TempItemLedgEntry: Record 32 TEMPORARY; NonDistrQuantity: Decimal; NonDistrQtyToAssign: Decimal; NonDistrAmountToAssign: Decimal; Sign: Decimal; IndirectCostPct: Decimal);
    VAR
        Factor: Decimal;
        QtyToAssign: Decimal;
        AmountToAssign: Decimal;
    BEGIN
        IF TempItemLedgEntry.FINDSET THEN BEGIN
            REPEAT
                Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
                QtyToAssign := NonDistrQtyToAssign * Factor;
                AmountToAssign := ROUND(NonDistrAmountToAssign * Factor, GLSetup."Amount Rounding Precision");
                IF Factor < 1 THEN BEGIN
                    PostItemCharge(PurchHeader, PurchLine,
                      TempItemLedgEntry."Entry No.", TempItemLedgEntry.Quantity,
                      AmountToAssign * Sign, QtyToAssign, IndirectCostPct);
                    NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
                    NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
                    NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
                END ELSE // the last time
                    PostItemCharge(PurchHeader, PurchLine,
                      TempItemLedgEntry."Entry No.", TempItemLedgEntry.Quantity,
                      NonDistrAmountToAssign * Sign, NonDistrQtyToAssign, IndirectCostPct);
            UNTIL TempItemLedgEntry.NEXT = 0;
        END ELSE
            ERROR(RelatedItemLedgEntriesNotFoundErr)
    END;

    LOCAL PROCEDURE PostAssocItemJnlLine(PurchHeader: Record 38; PurchLine: Record 39; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal): Integer;
    VAR
        ItemJnlLine: Record 83;
        TempHandlingSpecification2: Record 336 TEMPORARY;
        ItemEntryRelation: Record 6507;
        SalesOrderHeader: Record 36;
        SalesOrderLine: Record 37;
    BEGIN
        SalesOrderHeader.GET(
          SalesOrderHeader."Document Type"::Order, PurchLine."Sales Order No.");
        SalesOrderLine.GET(
          SalesOrderLine."Document Type"::Order, PurchLine."Sales Order No.", PurchLine."Sales Order Line No.");

        InitAssocItemJnlLine(ItemJnlLine, SalesOrderHeader, SalesOrderLine, PurchHeader, QtyToBeShipped, QtyToBeShippedBase);

        IF SalesOrderLine."Job Contract Entry No." = 0 THEN BEGIN
            TransferReservToItemJnlLine(SalesOrderLine, ItemJnlLine, PurchLine, QtyToBeShippedBase, TRUE);
            OnBeforePostAssocItemJnlLine(ItemJnlLine, SalesOrderLine, SuppressCommit);
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);
            // Handle Item Tracking
            IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
                IF TempHandlingSpecification2.FINDSET THEN
                    REPEAT
                        TempTrackingSpecification := TempHandlingSpecification2;
                        TempTrackingSpecification.SetSourceFromSalesLine(SalesOrderLine);
                        IF TempTrackingSpecification.INSERT THEN;
                        ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification2);
                        ItemEntryRelation.SetSource(DATABASE::"Sales Shipment Line", 0, SalesOrderHeader."Shipping No.", SalesOrderLine."Line No.");
                        ItemEntryRelation.SetOrderInfo(SalesOrderLine."Document No.", SalesOrderLine."Line No.");
                        ItemEntryRelation.INSERT;
                    UNTIL TempHandlingSpecification2.NEXT = 0;
                EXIT(0);
            END;
        END;

        EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE InitAssocItemJnlLine(VAR ItemJnlLine: Record 83; SalesOrderHeader: Record 36; SalesOrderLine: Record 37; PurchHeader: Record 38; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal);
    VAR
        CurrExchRate: Record 330;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            INIT;
            CopyDocumentFields(
              "Document Type"::"Sales Shipment", SalesOrderHeader."Shipping No.", '', SrcCode, SalesOrderHeader."Posting No. Series");

            CopyFromSalesHeader(SalesOrderHeader);
            "Country/Region Code" := GetCountryCode(SalesOrderLine, SalesOrderHeader);
            "Posting Date" := PurchHeader."Posting Date";
            "Document Date" := PurchHeader."Document Date";

            CopyFromSalesLine(SalesOrderLine);
            "Derived from Blanket Order" := SalesOrderLine."Blanket Order No." <> '';
            "Applies-to Entry" := ItemLedgShptEntryNo;

            Quantity := QtyToBeShipped;
            "Quantity (Base)" := QtyToBeShippedBase;
            "Invoiced Quantity" := 0;
            "Invoiced Qty. (Base)" := 0;
            "Source Currency Code" := PurchHeader."Currency Code";

            Amount := SalesOrderLine.Amount * QtyToBeShipped / SalesOrderLine.Quantity;
            IF SalesOrderHeader."Currency Code" <> '' THEN BEGIN
                Amount :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesOrderHeader."Posting Date", SalesOrderHeader."Currency Code",
                      Amount, SalesOrderHeader."Currency Factor"));
                "Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesOrderHeader."Posting Date", SalesOrderHeader."Currency Code",
                      SalesOrderLine."Line Discount Amount", SalesOrderHeader."Currency Factor"));
            END ELSE BEGIN
                Amount := ROUND(Amount);
                "Discount Amount" := SalesOrderLine."Line Discount Amount";
            END;
        END;
    END;

    LOCAL PROCEDURE ReleasePurchDocument(VAR PurchHeader: Record 38);
    VAR
        PurchaseHeaderCopy: Record 38;
        ReleasePurchaseDocument: Codeunit 415;
        LinesWereModified: Boolean;
        PrevStatus: Enum "Purchase Document Status";
    BEGIN
        WITH PurchHeader DO BEGIN
            IF NOT (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN
                EXIT;

            PurchaseHeaderCopy := PurchHeader;
            PrevStatus := Status;//enum to option
            LinesWereModified := ReleasePurchaseDocument.ReleasePurchaseHeader(PurchHeader, PreviewMode);
            IF LinesWereModified THEN
                RefreshTempLines(PurchHeader, TempPurchLineGlobal);
            TESTFIELD(Status, Status::Released);
            Status :=PrevStatus;//option to enum
            RestorePurchaseHeader(PurchHeader, PurchaseHeaderCopy);
            IF NOT PreviewMode THEN BEGIN
                MODIFY;
                COMMIT;
            END;
            Status := Status::Released;
        END;
    END;

    LOCAL PROCEDURE TestPurchLine(PurchHeader: Record 38; PurchLine: Record 39);
    VAR
        FA: Record 5600;
        FASetup: Record 5603;
        DeprBook: Record 5611;
        DummyTrackingSpecification: Record 336;
    BEGIN
        OnBeforeTestPurchLine(PurchLine, PurchHeader, SuppressCommit);

        WITH PurchLine DO BEGIN
            IF Type = Type::Item THEN
                DummyTrackingSpecification.CheckItemTrackingQuantity(
                  DATABASE::"Purchase Line", "Document Type".AsInteger(), "Document No.", "Line No.", //enum to option
                  "Qty. to Receive (Base)", "Qty. to Invoice (Base)", PurchHeader.Receive, PurchHeader.Invoice);

            IF Type = Type::"Charge (Item)" THEN BEGIN
                TESTFIELD(Amount);
                TESTFIELD("Job No.", '');
            END;
            IF "Job No." <> '' THEN
                //QB
                //TESTFIELD("Job Task No.");
                QBCodeunitPublisher.OnTestPurchLinePurchPost(PurchLine);
            //QB
            IF Type = Type::"Fixed Asset" THEN BEGIN
                TESTFIELD("Job No.", '');
                TESTFIELD("Depreciation Book Code");
                TESTFIELD("FA Posting Type");
                FA.GET("No.");
                FA.TESTFIELD("Budgeted Asset", FALSE);
                DeprBook.GET("Depreciation Book Code");
                IF "Budgeted FA No." <> '' THEN BEGIN
                    FA.GET("Budgeted FA No.");
                    FA.TESTFIELD("Budgeted Asset", TRUE);
                END;
                IF "FA Posting Type" = "FA Posting Type"::Maintenance THEN BEGIN
                    TESTFIELD("Insurance No.", '');
                    TESTFIELD("Depr. until FA Posting Date", FALSE);
                    TESTFIELD("Depr. Acquisition Cost", FALSE);
                    DeprBook.TESTFIELD("G/L Integration - Maintenance", TRUE);
                END;
                IF "FA Posting Type" = "FA Posting Type"::"Acquisition Cost" THEN BEGIN
                    TESTFIELD("Maintenance Code", '');
                    DeprBook.TESTFIELD("G/L Integration - Acq. Cost", TRUE);
                END;
                IF "Insurance No." <> '' THEN BEGIN
                    FASetup.GET;
                    FASetup.TESTFIELD("Insurance Depr. Book", "Depreciation Book Code");
                END;
            END ELSE BEGIN
                TESTFIELD("Depreciation Book Code", '');
                TESTFIELD("FA Posting Type", 0);
                TESTFIELD("Maintenance Code", '');
                TESTFIELD("Insurance No.", '');
                TESTFIELD("Depr. until FA Posting Date", FALSE);
                TESTFIELD("Depr. Acquisition Cost", FALSE);
                TESTFIELD("Budgeted FA No.", '');
                TESTFIELD("FA Posting Date", 0D);
                TESTFIELD("Salvage Value", 0);
                TESTFIELD("Duplicate in Depreciation Book", '');
                TESTFIELD("Use Duplication List", FALSE);
            END;
            CASE "Document Type" OF
                "Document Type"::Order:
                    TESTFIELD("Return Qty. to Ship", 0);
                "Document Type"::Invoice:
                    BEGIN
                        IF "Receipt No." = '' THEN
                            TESTFIELD("Qty. to Receive", Quantity);
                        TESTFIELD("Return Qty. to Ship", 0);
                        TESTFIELD("Qty. to Invoice", Quantity);
                    END;
                "Document Type"::"Return Order":
                    TESTFIELD("Qty. to Receive", 0);
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF "Return Shipment No." = '' THEN
                            TESTFIELD("Return Qty. to Ship", Quantity);
                        TESTFIELD("Qty. to Receive", 0);
                        TESTFIELD("Qty. to Invoice", Quantity);
                    END;
            END;
        END;

        OnAfterTestPurchLine(PurchHeader, PurchLine, WhseReceive, WhseShip);
    END;

    LOCAL PROCEDURE UpdateAssocOrder(VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        SalesSetup: Record 311;
        SalesOrderHeader: Record 36;
        SalesOrderLine: Record 37;
        ReserveSalesLine: Codeunit 99000832;
    BEGIN
        TempDropShptPostBuffer.RESET;
        IF TempDropShptPostBuffer.ISEMPTY THEN
            EXIT;
        SalesSetup.GET;
        IF TempDropShptPostBuffer.FINDSET THEN BEGIN
            REPEAT
                SalesOrderHeader.GET(
                  SalesOrderHeader."Document Type"::Order,
                  TempDropShptPostBuffer."Order No.");
                SalesOrderHeader."Last Shipping No." := SalesOrderHeader."Shipping No.";
                SalesOrderHeader."Shipping No." := '';
                SalesOrderHeader.MODIFY;
                ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesOrderHeader);
                TempDropShptPostBuffer.SETRANGE("Order No.", TempDropShptPostBuffer."Order No.");
                REPEAT
                    SalesOrderLine.GET(
                      SalesOrderLine."Document Type"::Order,
                      TempDropShptPostBuffer."Order No.", TempDropShptPostBuffer."Order Line No.");
                    SalesOrderLine."Quantity Shipped" := SalesOrderLine."Quantity Shipped" + TempDropShptPostBuffer.Quantity;
                    SalesOrderLine."Qty. Shipped (Base)" := SalesOrderLine."Qty. Shipped (Base)" + TempDropShptPostBuffer."Quantity (Base)";
                    SalesOrderLine.InitOutstanding;
                    IF SalesSetup."Default Quantity to Ship" <> SalesSetup."Default Quantity to Ship"::Blank THEN
                        SalesOrderLine.InitQtyToShip
                    ELSE BEGIN
                        SalesOrderLine."Qty. to Ship" := 0;
                        SalesOrderLine."Qty. to Ship (Base)" := 0;
                    END;
                    SalesOrderLine.MODIFY;
                    OnUpdateAssocOrderOnAfterSalesOrderLineModify(SalesOrderLine, TempDropShptPostBuffer);
                UNTIL TempDropShptPostBuffer.NEXT = 0;
                TempDropShptPostBuffer.SETRANGE("Order No.");
            UNTIL TempDropShptPostBuffer.NEXT = 0;
            TempDropShptPostBuffer.DELETEALL;
        END;
    END;

    LOCAL PROCEDURE UpdateAssosOrderPostingNos(PurchHeader: Record 38) DropShipment: Boolean;
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        SalesOrderHeader: Record 36;
        NoSeriesMgt: Codeunit 396;
        ReleaseSalesDocument: Codeunit 414;
    BEGIN
        WITH PurchHeader DO BEGIN
            ResetTempLines(TempPurchLine);
            TempPurchLine.SETFILTER("Sales Order Line No.", '<>0');
            DropShipment := NOT TempPurchLine.ISEMPTY;

            TempPurchLine.SETFILTER("Qty. to Receive", '<>0');
            IF DropShipment AND Receive THEN
                IF TempPurchLine.FINDSET THEN
                    REPEAT
                        IF SalesOrderHeader."No." <> TempPurchLine."Sales Order No." THEN BEGIN
                            SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order, TempPurchLine."Sales Order No.");
                            SalesOrderHeader.TESTFIELD("Bill-to Customer No.");
                            SalesOrderHeader.Ship := TRUE;
                            ReleaseSalesDocument.ReleaseSalesHeader(SalesOrderHeader, PreviewMode);
                            IF SalesOrderHeader."Shipping No." = '' THEN BEGIN
                                SalesOrderHeader.TESTFIELD("Shipping No. Series");
                                SalesOrderHeader."Shipping No." :=
                                  NoSeriesMgt.GetNextNo(SalesOrderHeader."Shipping No. Series", "Posting Date", TRUE);
                                SalesOrderHeader.MODIFY;
                            END;
                        END;
                    UNTIL TempPurchLine.NEXT = 0;

            EXIT(DropShipment);
        END;
    END;

    LOCAL PROCEDURE UpdateAfterPosting(PurchHeader: Record 38);
    VAR
        TempPurchLine: Record 39 TEMPORARY;
    BEGIN
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETFILTER("Blanket Order Line No.", '<>0');
            IF FINDSET THEN
                REPEAT
                    UpdateBlanketOrderLine(TempPurchLine, PurchHeader.Receive, PurchHeader.Ship, PurchHeader.Invoice);
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateLastPostingNos(VAR PurchHeader: Record 38);
    BEGIN
        WITH PurchHeader DO BEGIN
            IF Receive THEN BEGIN
                "Last Receiving No." := "Receiving No.";
                "Receiving No." := '';
            END;
            IF Invoice THEN BEGIN
                "Last Posting No." := "Posting No.";
                "Posting No." := '';
            END;
            IF Ship THEN BEGIN
                "Last Return Shipment No." := "Return Shipment No.";
                "Return Shipment No." := '';
            END;
        END;
    END;

    LOCAL PROCEDURE UpdatePostingNos(VAR PurchHeader: Record 38) ModifyHeader: Boolean;
    VAR
        NoSeriesMgt: Codeunit 396;
    BEGIN
        WITH PurchHeader DO BEGIN
            IF Receive AND ("Receiving No." = '') THEN
                IF ("Document Type" = "Document Type"::Order) OR
                   (("Document Type" = "Document Type"::Invoice) AND PurchSetup."Receipt on Invoice")
                THEN
                    IF NOT PreviewMode THEN BEGIN
                        TESTFIELD("Receiving No. Series");
                        "Receiving No." := NoSeriesMgt.GetNextNo("Receiving No. Series", "Posting Date", TRUE);
                        ModifyHeader := TRUE;
                    END ELSE
                        "Receiving No." := PostingPreviewNoTok;

            IF Ship AND ("Return Shipment No." = '') THEN
                IF ("Document Type" = "Document Type"::"Return Order") OR
                   (("Document Type" = "Document Type"::"Credit Memo") AND PurchSetup."Return Shipment on Credit Memo")
                THEN
                    IF NOT PreviewMode THEN BEGIN
                        TESTFIELD("Return Shipment No. Series");
                        "Return Shipment No." := NoSeriesMgt.GetNextNo("Return Shipment No. Series", "Posting Date", TRUE);
                        ModifyHeader := TRUE;
                    END ELSE
                        "Return Shipment No." := PostingPreviewNoTok;

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

        OnAfterUpdatePostingNos(PurchHeader, NoSeriesMgt, SuppressCommit);
    END;

    LOCAL PROCEDURE UpdatePurchLineBeforePost(PurchHeader: Record 38; VAR PurchLine: Record 39);
    BEGIN
        WITH PurchLine DO BEGIN
            OnBeforeUpdatePurchLineBeforePost(PurchLine, PurchHeader, WhseShip, WhseReceive, RoundingLineInserted, SuppressCommit);

            IF NOT (PurchHeader.Receive OR RoundingLineInserted) THEN BEGIN
                "Qty. to Receive" := 0;
                "Qty. to Receive (Base)" := 0;
            END;

            IF NOT (PurchHeader.Ship OR RoundingLineInserted) THEN BEGIN
                "Return Qty. to Ship" := 0;
                "Return Qty. to Ship (Base)" := 0;
            END;

            IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) AND ("Receipt No." <> '') THEN BEGIN
                "Quantity Received" := Quantity;
                "Qty. Received (Base)" := "Quantity (Base)";
                "Qty. to Receive" := 0;
                "Qty. to Receive (Base)" := 0;
            END;

            IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") AND ("Return Shipment No." <> '')
            THEN BEGIN
                "Return Qty. Shipped" := Quantity;
                "Return Qty. Shipped (Base)" := "Quantity (Base)";
                "Return Qty. to Ship" := 0;
                "Return Qty. to Ship (Base)" := 0;
            END;

            IF PurchHeader.Invoice THEN BEGIN
                IF ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice) THEN
                    InitQtyToInvoice;
            END ELSE BEGIN
                "Qty. to Invoice" := 0;
                "Qty. to Invoice (Base)" := 0;
            END;
        END;
        OnAfterUpdatePurchLineBeforePost(PurchLine, WhseShip, WhseReceive);
    END;

    LOCAL PROCEDURE UpdateWhseDocuments();
    BEGIN
        IF WhseReceive THEN BEGIN
            WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
            TempWhseRcptHeader.DELETE;
            OnUpdateWhseDocumentsOnAfterUpdateWhseRcpt(WhseRcptHeader);
        END;
        IF WhseShip THEN BEGIN
            WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
            TempWhseShptHeader.DELETE;
            OnUpdateWhseDocumentsOnAfterUpdateWhseShpt(WhseShptHeader);
        END;
    END;

    LOCAL PROCEDURE DeleteAfterPosting(VAR PurchHeader: Record 38);
    VAR
        PurchCommentLine: Record 43;
        PurchLine: Record 39;
        TempPurchLine: Record 39 TEMPORARY;
        WarehouseRequest: Record 5765;
        SkipDelete: Boolean;
    BEGIN
        OnBeforeDeleteAfterPosting(PurchHeader, PurchInvHeader, PurchCrMemoHeader, SkipDelete, SuppressCommit);
        IF SkipDelete THEN
            EXIT;

        WITH PurchHeader DO BEGIN
            IF HASLINKS THEN
                DELETELINKS;
            DELETE;

            ReservePurchLine.DeleteInvoiceSpecFromHeader(PurchHeader);
            ResetTempLines(TempPurchLine);
            IF TempPurchLine.FINDFIRST THEN
                REPEAT
                    IF TempPurchLine."Deferral Code" <> '' THEN
                        DeferralUtilities.RemoveOrSetDeferralSchedule(
                          '', DeferralUtilities1.GetPurchDeferralDocType, '', '',
                          TempPurchLine."Document Type".AsInteger(),
                          TempPurchLine."Document No.",
                          TempPurchLine."Line No.", 0, 0D,
                          TempPurchLine.Description,
                          '',
                          TRUE);
                    IF TempPurchLine.HASLINKS THEN
                        TempPurchLine.DELETELINKS;
                UNTIL TempPurchLine.NEXT = 0;

            PurchLine.SETRANGE("Document Type", "Document Type");
            PurchLine.SETRANGE("Document No.", "No.");
            OnBeforePurchLineDeleteAll(PurchLine, SuppressCommit);
            PurchLine.DELETEALL;

            DeleteItemChargeAssgnt(PurchHeader);
            PurchCommentLine.DeleteComments("Document Type".AsInteger(), "No.");
            WarehouseRequest.DeleteRequest(DATABASE::"Purchase Line", "Document Type".AsInteger(), "No.");
        END;

        OnAfterDeleteAfterPosting(PurchHeader, PurchInvHeader, PurchCrMemoHeader, SuppressCommit);
    END;

    LOCAL PROCEDURE FinalizePosting(VAR PurchHeader: Record 38; VAR TempDropShptPostBuffer: Record 223 TEMPORARY; EverythingInvoiced: Boolean);
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        GenJnlPostPreview: Codeunit 19;
        ArchiveManagement: Codeunit 5063;
    BEGIN
        OnBeforeFinalizePosting(PurchHeader, TempPurchLineGlobal, EverythingInvoiced, SuppressCommit);

        WITH PurchHeader DO BEGIN
            IF ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"]) AND
               (NOT EverythingInvoiced)
            THEN BEGIN
                MODIFY;
                InsertTrackingSpecification(PurchHeader);
                PostUpdateOrderLine(PurchHeader);
                UpdateAssocOrder(TempDropShptPostBuffer);
                UpdateWhseDocuments;
                WhsePurchRelease.Release(PurchHeader);
                UpdateItemChargeAssgnt;
            END ELSE BEGIN
                CASE "Document Type" OF
                    "Document Type"::Invoice:
                        BEGIN
                            PostUpdateInvoiceLine;
                            InsertTrackingSpecification(PurchHeader);
                        END;
                    "Document Type"::"Credit Memo":
                        BEGIN
                            PostUpdateCreditMemoLine;
                            InsertTrackingSpecification(PurchHeader);
                        END;
                    ELSE BEGIN
                        ResetTempLines(TempPurchLine);
                        TempPurchLine.SETFILTER("Prepayment %", '<>0');
                        IF TempPurchLine.FINDSET THEN
                            REPEAT
                                DecrementPrepmtAmtInvLCY(
                                  TempPurchLine, TempPurchLine."Prepmt. Amount Inv. (LCY)", TempPurchLine."Prepmt. VAT Amount Inv. (LCY)");
                            UNTIL TempPurchLine.NEXT = 0;
                    END;
                END;
                UpdateAfterPosting(PurchHeader);
                UpdateWhseDocuments;
                ArchiveManagement.AutoArchivePurchDocument(PurchHeader);
                ApprovalsMgmt.DeleteApprovalEntries(RECORDID);
                IF NOT PreviewMode THEN
                    DeleteAfterPosting(PurchHeader);
            END;

            InsertValueEntryRelation;
        END;

        OnAfterFinalizePostingOnBeforeCommit(
          PurchHeader, PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader, ReturnShptHeader, GenJnlPostLine, PreviewMode, SuppressCommit);

        IF PreviewMode THEN BEGIN
            Window.CLOSE;
            GenJnlPostPreview.ThrowError;
        END;
        IF NOT InvtPickPutaway THEN
            COMMIT;

        IF GUIALLOWED THEN
            Window.CLOSE;

        OnAfterFinalizePosting(
          PurchHeader, PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader, ReturnShptHeader, GenJnlPostLine, PreviewMode, SuppressCommit);

        ClearPostBuffers;
    END;

    LOCAL PROCEDURE FillInvoicePostBuffer(PurchHeader: Record 38; PurchLine: Record 39; PurchLineACY: Record 39; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR InvoicePostBuffer: Record 55);
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
        PurchAccount: Code[20];
    BEGIN
        GenPostingSetup.GET(PurchLine."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group");
        InvoicePostBuffer.PreparePurchase(PurchLine);
        InitAmounts(PurchLine, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, AmtToDefer, AmtToDeferACY, DeferralAccount);
        InitVATBase(PurchLine, TotalVATBase, TotalVATBaseACY);

        OnFillInvoicePostBufferOnAfterInitAmounts(
          PurchHeader, PurchLine, PurchLineACY, TempInvoicePostBuffer, InvoicePostBuffer, TotalAmount, TotalAmountACY);

        IF PurchSetup."Post Invoice Discount" THEN BEGIN
            CalcInvoiceDiscountPosting(PurchHeader, PurchLine, PurchLineACY, InvoicePostBuffer);

            IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
                InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

            IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
                GenPostingSetup.TESTFIELD("Purch. Inv. Disc. Account");
                IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
                    FillInvoicePostBufferFADiscount(
                      TempInvoicePostBuffer, InvoicePostBuffer, GenPostingSetup, PurchLine."No.",
                      TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, TotalVATBase, TotalVATBaseACY);
                    InvoicePostBuffer.SetAccount(
                      GenPostingSetup.GetPurchInvDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                    InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                    InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
                    UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
                    InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
                END ELSE BEGIN
                    InvoicePostBuffer.SetAccount(
                      GenPostingSetup.GetPurchInvDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                    InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                    UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
                END;
            END;
        END;

        IF PurchSetup."Post Line Discount" THEN BEGIN
            CalcLineDiscountPosting(PurchHeader, PurchLine, PurchLineACY, InvoicePostBuffer);

            IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
                InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

            IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
                GenPostingSetup.TESTFIELD("Purch. Line Disc. Account");
                IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
                    FillInvoicePostBufferFADiscount(
                      TempInvoicePostBuffer, InvoicePostBuffer, GenPostingSetup, PurchLine."No.",
                      TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, TotalVATBase, TotalVATBaseACY);
                    InvoicePostBuffer.SetAccount(
                      GenPostingSetup.GetPurchLineDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                    InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                    InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
                    UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
                    InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
                END ELSE BEGIN
                    InvoicePostBuffer.SetAccount(
                      GenPostingSetup.GetPurchLineDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                    InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                    UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
                END;
            END;
        END;

        IF PurchSetup."Post Payment Discount" THEN BEGIN
            CalcPaymentDiscountPosting(PurchHeader, PurchLine, PurchLineACY, InvoicePostBuffer);

            IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
                InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

            IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
                GenPostingSetup.TESTFIELD("Purch. Pmt. Disc. Credit Acc.");
                IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
                    FillInvoicePostBufferFADiscount(
                      TempInvoicePostBuffer, InvoicePostBuffer, GenPostingSetup, PurchLine."No.",
                      TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, TotalVATBase, TotalVATBaseACY);
                    InvoicePostBuffer.SetAccount(
                      GenPostingSetup."Purch. Pmt. Disc. Credit Acc.", TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                    InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                    InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
                    UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
                    InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
                END ELSE BEGIN
                    InvoicePostBuffer.SetAccount(
                      GenPostingSetup."Purch. Pmt. Disc. Credit Acc.", TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                    InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                    UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
                END;
            END;
        END;

        DeferralUtilities.AdjustTotalAmountForDeferralsNoBase(
          PurchLine."Deferral Code", AmtToDefer, AmtToDeferACY, TotalAmount, TotalAmountACY);

        IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
            IF PurchLine."Deferral Code" <> '' THEN
                InvoicePostBuffer.SetAmounts(
                  TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, PurchLine."VAT Difference", TotalVATBase, TotalVATBaseACY)
            ELSE
                InvoicePostBuffer.SetAmountsNoVAT(TotalAmount, TotalAmountACY, PurchLine."VAT Difference")
        END ELSE
            IF (NOT PurchLine."Use Tax") OR (PurchLine."VAT Calculation Type" <> PurchLine."VAT Calculation Type"::"Sales Tax") THEN
                InvoicePostBuffer.SetAmounts(
                  TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, PurchLine."VAT Difference", TotalVATBase, TotalVATBaseACY)
            ELSE
                InvoicePostBuffer.SetAmountsNoVAT(TotalAmount, TotalAmountACY, PurchLine."VAT Difference");

        IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
            InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

        IF (PurchLine.Type = PurchLine.Type::"G/L Account") OR (PurchLine.Type = PurchLine.Type::"Fixed Asset") THEN
            PurchAccount := PurchLine."No."
        ELSE
            IF PurchLine.IsCreditDocType THEN
                PurchAccount := GenPostingSetup.GetPurchCrMemoAccount
            ELSE
                PurchAccount := GenPostingSetup.GetPurchAccount;
        InvoicePostBuffer.SetAccount(PurchAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
        InvoicePostBuffer."Deferral Code" := PurchLine."Deferral Code";
        OnAfterFillInvoicePostBuffer(InvoicePostBuffer, PurchLine, TempInvoicePostBuffer, SuppressCommit);
        UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
        IF PurchLine."Deferral Code" <> '' THEN BEGIN
            OnBeforeFillDeferralPostingBuffer(
              PurchLine, InvoicePostBuffer, TempInvoicePostBuffer, Usedate, InvDefLineNo, DeferralLineNo, SuppressCommit);
            // FillDeferralPostingBuffer(PurchHeader, PurchLine, InvoicePostBuffer, AmtToDefer, AmtToDeferACY, DeferralAccount, PurchAccount);
        END;
    END;

    LOCAL PROCEDURE FillInvoicePostBufferFADiscount(VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR InvoicePostBuffer: Record 55; GenPostingSetup: Record 252; AccountNo: Code[20]; TotalVAT: Decimal; TotalVATACY: Decimal; TotalAmount: Decimal; TotalAmountACY: Decimal; TotalVATBase: Decimal; TotalVATBaseACY: Decimal);
    VAR
        DeprBook: Record 5611;
    BEGIN
        DeprBook.GET(InvoicePostBuffer."Depreciation Book Code");
        IF DeprBook."Subtract Disc. in Purch. Inv." THEN BEGIN
            InvoicePostBuffer.SetAccount(AccountNo, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
            InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
            UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
            InvoicePostBuffer.ReverseAmounts;
            InvoicePostBuffer.SetAccount(
              GenPostingSetup.GetPurchFADiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
            InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
            InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
            UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);
            InvoicePostBuffer.ReverseAmounts;
        END;
    END;

    LOCAL PROCEDURE UpdateInvoicePostBuffer(VAR TempInvoicePostBuffer: Record 55 TEMPORARY; InvoicePostBuffer: Record 55);
    BEGIN
        IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
            FALineNo := FALineNo + 1;
            InvoicePostBuffer."Fixed Asset Line No." := FALineNo;
        END;

        TempInvoicePostBuffer.Update(InvoicePostBuffer, InvDefLineNo, DeferralLineNo);
    END;

    LOCAL PROCEDURE InsertPrepmtAdjInvPostingBuf(PurchHeader: Record 38; PrepmtPurchLine: Record 39; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; InvoicePostBuffer: Record 55);
    VAR
        PurchPostPrepayments: Codeunit 444;
        AdjAmount: Decimal;
    BEGIN
        // WITH PrepmtPurchLine DO
        //     IF "Prepayment Line" THEN
        //         IF "Prepmt. Amount Inv. (LCY)" <> 0 THEN BEGIN
        //             AdjAmount := -"Prepmt. Amount Inv. (LCY)";
                    // TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer, InvoicePostBuffer,
                    //   "No.", AdjAmount, PurchHeader."Currency Code" = '');
                    // TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer, InvoicePostBuffer,
                    //   PurchPostPrepayments.GetCorrBalAccNo(PurchHeader, AdjAmount > 0),
                    //   -AdjAmount,
                    //   PurchHeader."Currency Code" = '');
                // END ELSE
                    // IF ("Prepayment %" = 100) AND ("Prepmt. VAT Amount Inv. (LCY)" <> 0) THEN
                        // TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer, InvoicePostBuffer,
                        //   PurchPostPrepayments.GetInvRoundingAccNo(PurchHeader."Vendor Posting Group"),
                        //   "Prepmt. VAT Amount Inv. (LCY)", PurchHeader."Currency Code" = '');
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

    LOCAL PROCEDURE DivideAmount(PurchHeader: Record 38; VAR PurchLine: Record 39; QtyType: Option "General","Invoicing","Shipping"; PurchLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    VAR
        OriginalDeferralAmount: Decimal;
    BEGIN
        IF RoundingLineInserted AND (RoundingLineNo = PurchLine."Line No.") THEN
            EXIT;

        OnBeforeDivideAmount(PurchHeader, PurchLine, QtyType, PurchLineQty, TempVATAmountLine, TempVATAmountLineRemainder);

        WITH PurchLine DO
            IF (PurchLineQty = 0) OR ("Direct Unit Cost" = 0) THEN BEGIN
                "Line Amount" := 0;
                "Line Discount Amount" := 0;
                "Inv. Discount Amount" := 0;
                "VAT Base Amount" := 0;
                Amount := 0;
                "Amount Including VAT" := 0;
            END ELSE BEGIN
                OriginalDeferralAmount := GetDeferralAmount;
                TempVATAmountLine.GET(
                  "VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", "Line Amount" >= 0);
                IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                    "VAT %" := TempVATAmountLine."VAT %";
                    "EC %" := TempVATAmountLine."EC %";
                END;
                TempVATAmountLineRemainder := TempVATAmountLine;
                IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
                    TempVATAmountLineRemainder.INIT;
                    TempVATAmountLineRemainder.INSERT;
                END;
                "Line Amount" := GetLineAmountToHandleInclPrepmt(PurchLineQty) + GetPrepmtDiffToLineAmount(PurchLine);
                IF PurchLineQty <> Quantity THEN BEGIN
                    "Line Discount Amount" :=
                      ROUND("Line Discount Amount" * PurchLineQty / Quantity, Currency."Amount Rounding Precision");
                    "Pmt. Discount Amount" := ROUND("Pmt. Discount Amount" * PurchLineQty / Quantity, Currency."Amount Rounding Precision");
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

                IF PurchHeader."Prices Including VAT" THEN BEGIN
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
                        Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
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
                            Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
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
                    CalcDeferralAmounts(PurchHeader, PurchLine, OriginalDeferralAmount);
            END;

        OnAfterDivideAmount(PurchHeader, PurchLine, QtyType, PurchLineQty, TempVATAmountLine, TempVATAmountLineRemainder);
    END;

    LOCAL PROCEDURE RoundAmount(PurchHeader: Record 38; VAR PurchLine: Record 39; PurchLineQty: Decimal);
    VAR
        CurrExchRate: Record 330;
        NoVAT: Boolean;
    BEGIN
        OnBeforeRoundAmount(PurchHeader, PurchLine, PurchLineQty);

        WITH PurchLine DO BEGIN
            IncrAmount(PurchHeader, PurchLine, TotalPurchLine);
            Increment(TotalPurchLine."Net Weight", ROUND(PurchLineQty * "Net Weight", 0.00001));
            Increment(TotalPurchLine."Gross Weight", ROUND(PurchLineQty * "Gross Weight", 0.00001));
            Increment(TotalPurchLine."Unit Volume", ROUND(PurchLineQty * "Unit Volume", 0.00001));
            Increment(TotalPurchLine.Quantity, PurchLineQty);
            IF "Units per Parcel" > 0 THEN
                Increment(TotalPurchLine."Units per Parcel", ROUND(PurchLineQty / "Units per Parcel", 1, '>'));

            xPurchLine := PurchLine;
            PurchLineACY := PurchLine;
            IF PurchHeader."Currency Code" <> '' THEN BEGIN
                IF PurchHeader."Posting Date" = 0D THEN
                    Usedate := WORKDATE
                ELSE
                    Usedate := PurchHeader."Posting Date";

                NoVAT := Amount = "Amount Including VAT";
                "Amount Including VAT" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."Amount Including VAT", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."Amount Including VAT";
                IF NoVAT THEN
                    Amount := "Amount Including VAT"
                ELSE
                    Amount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          Usedate, PurchHeader."Currency Code",
                          TotalPurchLine.Amount, PurchHeader."Currency Factor")) -
                      TotalPurchLineLCY.Amount;
                "Line Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."Line Amount", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."Line Amount";
                "Line Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."Line Discount Amount", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."Line Discount Amount";
                "Inv. Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."Inv. Discount Amount", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."Inv. Discount Amount";
                "VAT Difference" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."VAT Difference", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."VAT Difference";
                "VAT Base Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."VAT Base Amount", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."VAT Base Amount";
                "Pmt. Discount Amount" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      Usedate, PurchHeader."Currency Code",
                      TotalPurchLine."Pmt. Discount Amount", PurchHeader."Currency Factor")) -
                  TotalPurchLineLCY."Pmt. Discount Amount";
            END;

            OnRoundAmountOnBeforeIncrAmount(PurchHeader, PurchLine, PurchLineQty, TotalPurchLine, TotalPurchLineLCY);

            IncrAmount(PurchHeader, PurchLine, TotalPurchLineLCY);
            Increment(TotalPurchLineLCY."Unit Cost (LCY)", ROUND(PurchLineQty * "Unit Cost (LCY)"));
        END;

        OnAfterRoundAmount(PurchHeader, PurchLine, PurchLineQty);
    END;

    LOCAL PROCEDURE ReverseAmount(VAR PurchLine: Record 39);
    BEGIN
        WITH PurchLine DO BEGIN
            "Qty. to Receive" := -"Qty. to Receive";
            "Qty. to Receive (Base)" := -"Qty. to Receive (Base)";
            "Return Qty. to Ship" := -"Return Qty. to Ship";
            "Return Qty. to Ship (Base)" := -"Return Qty. to Ship (Base)";
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
            "Salvage Value" := -"Salvage Value";
            OnAfterReverseAmount(PurchLine);
        END;
    END;

    LOCAL PROCEDURE InvoiceRounding(PurchHeader: Record 38; VAR PurchLine: Record 39; UseTempData: Boolean; BiggestLineNo: Integer);
    VAR
        VendPostingGr: Record 93;
        InvoiceRoundingAmount: Decimal;
    BEGIN
        Currency.TESTFIELD("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalPurchLine."Amount Including VAT" -
            ROUND(
              TotalPurchLine."Amount Including VAT", Currency."Invoice Rounding Precision", Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");

        OnBeforeInvoiceRoundingAmount(
          PurchHeader, TotalPurchLine."Amount Including VAT", UseTempData, InvoiceRoundingAmount, SuppressCommit);
        IF InvoiceRoundingAmount <> 0 THEN BEGIN
            VendPostingGr.GET(PurchHeader."Vendor Posting Group");
            VendPostingGr.TESTFIELD("Invoice Rounding Account");
            WITH PurchLine DO BEGIN
                INIT;
                BiggestLineNo := BiggestLineNo + 10000;
                "System-Created Entry" := TRUE;
                IF UseTempData THEN BEGIN
                    "Line No." := 0;
                    Type := Type::"G/L Account";
                END ELSE BEGIN
                    "Line No." := BiggestLineNo;
                    VALIDATE(Type, Type::"G/L Account");
                END;
                VALIDATE("No.", VendPostingGr."Invoice Rounding Account");
                VALIDATE(Quantity, 1);
                IF IsCreditDocType THEN
                    VALIDATE("Return Qty. to Ship", Quantity)
                ELSE
                    VALIDATE("Qty. to Receive", Quantity);
                IF PurchHeader."Prices Including VAT" THEN
                    VALIDATE("Direct Unit Cost", InvoiceRoundingAmount)
                ELSE
                    VALIDATE(
                      "Direct Unit Cost",
                      ROUND(
                        InvoiceRoundingAmount /
                        (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                        Currency."Amount Rounding Precision"));
                VALIDATE("Amount Including VAT", InvoiceRoundingAmount);
                "Line No." := BiggestLineNo;
                LastLineRetrieved := FALSE;
                RoundingLineInserted := TRUE;
                RoundingLineNo := "Line No.";
            END;
        END;

        OnAfterInvoiceRoundingAmount(
          PurchHeader, PurchLine, TotalPurchLine, UseTempData, InvoiceRoundingAmount, SuppressCommit);
    END;

    LOCAL PROCEDURE IncrAmount(PurchHeader: Record 38; PurchLine: Record 39; VAR TotalPurchLine: Record 39);
    BEGIN
        WITH PurchLine DO BEGIN
            IF PurchHeader."Prices Including VAT" OR
               ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
            THEN
                Increment(TotalPurchLine."Line Amount", "Line Amount");
            Increment(TotalPurchLine.Amount, Amount);
            Increment(TotalPurchLine."VAT Base Amount", "VAT Base Amount");
            Increment(TotalPurchLine."VAT Difference", "VAT Difference");
            Increment(TotalPurchLine."Amount Including VAT", "Amount Including VAT");
            Increment(TotalPurchLine."Line Discount Amount", "Line Discount Amount");
            Increment(TotalPurchLine."Inv. Discount Amount", "Inv. Discount Amount");
            Increment(TotalPurchLine."Inv. Disc. Amount to Invoice", "Inv. Disc. Amount to Invoice");
            Increment(TotalPurchLine."Prepmt. Line Amount", "Prepmt. Line Amount");
            Increment(TotalPurchLine."Prepmt. Amt. Inv.", "Prepmt. Amt. Inv.");
            Increment(TotalPurchLine."Prepmt Amt to Deduct", "Prepmt Amt to Deduct");
            Increment(TotalPurchLine."Prepmt Amt Deducted", "Prepmt Amt Deducted");
            Increment(TotalPurchLine."Prepayment VAT Difference", "Prepayment VAT Difference");
            Increment(TotalPurchLine."Prepmt VAT Diff. to Deduct", "Prepmt VAT Diff. to Deduct");
            Increment(TotalPurchLine."Prepmt VAT Diff. Deducted", "Prepmt VAT Diff. Deducted");
            Increment(TotalPurchLine."Pmt. Discount Amount", "Pmt. Discount Amount");
            OnAfterIncrAmount(TotalPurchLine, PurchLine);
        END;
    END;

    LOCAL PROCEDURE Increment(VAR Number: Decimal; Number2: Decimal);
    BEGIN
        Number := Number + Number2;
    END;

    //[External]
    PROCEDURE GetPurchLines(VAR PurchHeader: Record 38; VAR PurchLine: Record 39; QtyType: Option "General","Invoicing","Shipping");
    BEGIN
        FillTempLines(PurchHeader, TempPurchLineGlobal);
        IF QtyType = QtyType::Invoicing THEN
            CreatePrepmtLines(PurchHeader, FALSE);
        SumPurchLines2(PurchHeader, PurchLine, TempPurchLineGlobal, QtyType, TRUE);
    END;



    //[External]
    PROCEDURE SumPurchLinesTemp(VAR PurchHeader: Record 38; VAR OldPurchLine: Record 39; QtyType: Option "General","Invoicing","Shipping"; VAR NewTotalPurchLine: Record 39; VAR NewTotalPurchLineLCY: Record 39; VAR VATAmount: Decimal; VAR VATAmountText: Text[30]);
    VAR
        PurchLine: Record 39;
    BEGIN
        WITH PurchHeader DO BEGIN
            SumPurchLines2(PurchHeader, PurchLine, OldPurchLine, QtyType, FALSE);
            VATAmount := TotalPurchLine."Amount Including VAT" - TotalPurchLine.Amount;
            IF (TotalPurchLine."VAT %" = 0) AND (TotalPurchLine."EC %" = 0) THEN
                VATAmountText := VATAmountTxt
            ELSE
                VATAmountText := STRSUBSTNO(VATRateTxt, (TotalPurchLine."VAT %" + TotalPurchLine."EC %"));
            NewTotalPurchLine := TotalPurchLine;
            NewTotalPurchLineLCY := TotalPurchLineLCY;
        END;
    END;

    LOCAL PROCEDURE SumPurchLines2(PurchHeader: Record 38; VAR NewPurchLine: Record 39; VAR OldPurchLine: Record 39; QtyType: Option "General","Invoicing","Shipping"; InsertPurchLine: Boolean);
    VAR
        PurchLine: Record 39;
        TempVATAmountLine: Record 290 TEMPORARY;
        TempVATAmountLineRemainder: Record 290 TEMPORARY;
        PurchLineQty: Decimal;
        BiggestLineNo: Integer;
    BEGIN
        TempVATAmountLineRemainder.DELETEALL;
        OldPurchLine.CalcVATAmountLines(QtyType, PurchHeader, OldPurchLine, TempVATAmountLine);
        WITH PurchHeader DO BEGIN
            GetGLSetup;
            PurchSetup.GET;
            GetCurrency("Currency Code");
            OldPurchLine.SETRANGE("Document Type", "Document Type");
            OldPurchLine.SETRANGE("Document No.", "No.");
            RoundingLineInserted := FALSE;
            IF OldPurchLine.FINDSET THEN
                REPEAT
                    IF NOT RoundingLineInserted THEN
                        PurchLine := OldPurchLine;
                    CASE QtyType OF
                        QtyType::General:
                            PurchLineQty := PurchLine.Quantity;
                        QtyType::Invoicing:
                            PurchLineQty := PurchLine."Qty. to Invoice";
                        QtyType::Shipping:
                            BEGIN
                                IF IsCreditDocType THEN
                                    PurchLineQty := PurchLine."Return Qty. to Ship"
                                ELSE
                                    PurchLineQty := PurchLine."Qty. to Receive"
                            END;
                    END;
                    DivideAmount(PurchHeader, PurchLine, QtyType, PurchLineQty, TempVATAmountLine, TempVATAmountLineRemainder);
                    PurchLine.Quantity := PurchLineQty;
                    IF PurchLineQty <> 0 THEN BEGIN
                        IF (PurchLine.Amount <> 0) AND NOT RoundingLineInserted THEN
                            IF TotalPurchLine.Amount = 0 THEN BEGIN
                                TotalPurchLine."VAT %" := PurchLine."VAT %";
                                TotalPurchLine."EC %" := PurchLine."EC %";
                            END
                            ELSE
                                IF TotalPurchLine."VAT %" <> PurchLine."VAT %" THEN
                                    TotalPurchLine."VAT %" := 0;
                        RoundAmount(PurchHeader, PurchLine, PurchLineQty);
                        PurchLine := xPurchLine;
                    END;
                    IF InsertPurchLine THEN BEGIN
                        NewPurchLine := PurchLine;
                        NewPurchLine.INSERT;
                    END;
                    IF RoundingLineInserted THEN
                        LastLineRetrieved := TRUE
                    ELSE BEGIN
                        BiggestLineNo := MAX(BiggestLineNo, OldPurchLine."Line No.");
                        LastLineRetrieved := OldPurchLine.NEXT = 0;
                        IF LastLineRetrieved AND PurchSetup."Invoice Rounding" THEN
                            InvoiceRounding(PurchHeader, PurchLine, TRUE, BiggestLineNo);
                    END;
                UNTIL LastLineRetrieved;
        END;
    END;

    //[External]
    PROCEDURE UpdateBlanketOrderLine(PurchLine: Record 39; Receive: Boolean; Ship: Boolean; Invoice: Boolean);
    VAR
        BlanketOrderPurchLine: Record 39;
        ModifyLine: Boolean;
        Sign: Decimal;
    BEGIN
        IF (PurchLine."Blanket Order No." <> '') AND (PurchLine."Blanket Order Line No." <> 0) AND
           ((Receive AND (PurchLine."Qty. to Receive" <> 0)) OR
            (Ship AND (PurchLine."Return Qty. to Ship" <> 0)) OR
            (Invoice AND (PurchLine."Qty. to Invoice" <> 0)))
        THEN
            IF BlanketOrderPurchLine.GET(
                 BlanketOrderPurchLine."Document Type"::"Blanket Order", PurchLine."Blanket Order No.",
                 PurchLine."Blanket Order Line No.")
            THEN BEGIN
                BlanketOrderPurchLine.TESTFIELD(Type, PurchLine.Type);
                BlanketOrderPurchLine.TESTFIELD("No.", PurchLine."No.");
                BlanketOrderPurchLine.TESTFIELD("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");

                ModifyLine := FALSE;
                CASE PurchLine."Document Type" OF
                    PurchLine."Document Type"::Order,
                  PurchLine."Document Type"::Invoice:
                        Sign := 1;
                    PurchLine."Document Type"::"Return Order",
                  PurchLine."Document Type"::"Credit Memo":
                        Sign := -1;
                END;
                IF Receive AND (PurchLine."Receipt No." = '') THEN BEGIN
                    IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
                       PurchLine."Qty. per Unit of Measure"
                    THEN
                        BlanketOrderPurchLine."Quantity Received" :=
                          BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Qty. to Receive"
                    ELSE
                        BlanketOrderPurchLine."Quantity Received" :=
                          BlanketOrderPurchLine."Quantity Received" +
                          Sign *
                          ROUND(
                            (PurchLine."Qty. per Unit of Measure" /
                             BlanketOrderPurchLine."Qty. per Unit of Measure") *
                            PurchLine."Qty. to Receive", 0.00001);
                    BlanketOrderPurchLine."Qty. Received (Base)" :=
                      BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Qty. to Receive (Base)";
                    ModifyLine := TRUE;
                END;
                IF Ship AND (PurchLine."Return Shipment No." = '') THEN BEGIN
                    IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
                       PurchLine."Qty. per Unit of Measure"
                    THEN
                        BlanketOrderPurchLine."Quantity Received" :=
                          BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Return Qty. to Ship"
                    ELSE
                        BlanketOrderPurchLine."Quantity Received" :=
                          BlanketOrderPurchLine."Quantity Received" +
                          Sign *
                          ROUND(
                            (PurchLine."Qty. per Unit of Measure" /
                             BlanketOrderPurchLine."Qty. per Unit of Measure") *
                            PurchLine."Return Qty. to Ship", 0.00001);
                    BlanketOrderPurchLine."Qty. Received (Base)" :=
                      BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Return Qty. to Ship (Base)";
                    ModifyLine := TRUE;
                END;

                IF Invoice THEN BEGIN
                    IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
                       PurchLine."Qty. per Unit of Measure"
                    THEN
                        BlanketOrderPurchLine."Quantity Invoiced" :=
                          BlanketOrderPurchLine."Quantity Invoiced" + Sign * PurchLine."Qty. to Invoice"
                    ELSE
                        BlanketOrderPurchLine."Quantity Invoiced" :=
                          BlanketOrderPurchLine."Quantity Invoiced" +
                          Sign *
                          ROUND(
                            (PurchLine."Qty. per Unit of Measure" /
                             BlanketOrderPurchLine."Qty. per Unit of Measure") *
                            PurchLine."Qty. to Invoice", 0.00001);
                    BlanketOrderPurchLine."Qty. Invoiced (Base)" :=
                      BlanketOrderPurchLine."Qty. Invoiced (Base)" + Sign * PurchLine."Qty. to Invoice (Base)";
                    ModifyLine := TRUE;
                END;

                IF ModifyLine THEN BEGIN
                    OnUpdateBlanketOrderLineOnBeforeInitOutstanding(BlanketOrderPurchLine, PurchLine);
                    BlanketOrderPurchLine.InitOutstanding;

                    IF (BlanketOrderPurchLine.Quantity * BlanketOrderPurchLine."Quantity Received" < 0) OR
                       (ABS(BlanketOrderPurchLine.Quantity) < ABS(BlanketOrderPurchLine."Quantity Received"))
                    THEN
                        BlanketOrderPurchLine.FIELDERROR(
                          "Quantity Received",
                          STRSUBSTNO(
                            BlanketOrderQuantityGreaterThanErr,
                            BlanketOrderPurchLine.FIELDCAPTION(Quantity)));

                    IF (BlanketOrderPurchLine."Quantity (Base)" *
                        BlanketOrderPurchLine."Qty. Received (Base)" < 0) OR
                       (ABS(BlanketOrderPurchLine."Quantity (Base)") <
                        ABS(BlanketOrderPurchLine."Qty. Received (Base)"))
                    THEN
                        BlanketOrderPurchLine.FIELDERROR(
                          "Qty. Received (Base)",
                          STRSUBSTNO(
                            BlanketOrderQuantityGreaterThanErr,
                            BlanketOrderPurchLine.FIELDCAPTION("Quantity Received")));

                    BlanketOrderPurchLine.CALCFIELDS("Reserved Qty. (Base)");
                    IF ABS(BlanketOrderPurchLine."Outstanding Qty. (Base)") <
                       ABS(BlanketOrderPurchLine."Reserved Qty. (Base)")
                    THEN
                        BlanketOrderPurchLine.FIELDERROR(
                          "Reserved Qty. (Base)", BlanketOrderQuantityReducedErr);

                    BlanketOrderPurchLine."Qty. to Invoice" :=
                      BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Invoiced";
                    BlanketOrderPurchLine."Qty. to Receive" :=
                      BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Received";
                    BlanketOrderPurchLine."Qty. to Invoice (Base)" :=
                      BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Invoiced (Base)";
                    BlanketOrderPurchLine."Qty. to Receive (Base)" :=
                      BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Received (Base)";

                    OnBeforeBlanketOrderPurchLineModify(BlanketOrderPurchLine, PurchLine);
                    BlanketOrderPurchLine.MODIFY;
                END;
            END;
    END;

    LOCAL PROCEDURE UpdatePurchaseHeader(VendorLedgerEntry: Record 25);
    VAR
        GenJnlLine: Record 81;
    BEGIN
        CASE GenJnlLineDocType OF
            GenJnlLine."Document Type"::Invoice.AsInteger():
                BEGIN
                    FindVendorLedgerEntry(GenJnlLineDocType, GenJnlLineDocNo, VendorLedgerEntry);
                    PurchInvHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
                    PurchInvHeader.MODIFY;
                END;
            GenJnlLine."Document Type"::"Credit Memo".AsInteger():
                BEGIN
                    FindVendorLedgerEntry(GenJnlLineDocType, GenJnlLineDocNo, VendorLedgerEntry);
                    PurchCrMemoHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
                    PurchCrMemoHeader.MODIFY;
                END;
        END;

        OnAfterUpdatePurchaseHeader(VendorLedgerEntry, PurchInvHeader, PurchCrMemoHeader, GenJnlLineDocType);
    END;

    LOCAL PROCEDURE PostVendorEntry(VAR PurchHeader: Record 38; TotalPurchLine2: Record 39; TotalPurchLineLCY2: Record 39; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]);
    VAR
        GenJnlLine: Record 81;
    BEGIN
        WITH GenJnlLine DO BEGIN
            InitNewLine(
              PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
              PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code",
              PurchHeader."Dimension Set ID", PurchHeader."Reason Code");

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(DocType), DocNo, ExtDocNo, SourceCode, '');//option to enum
            "Account Type" := "Account Type"::Vendor;
            "Account No." := PurchHeader."Pay-to Vendor No.";
            CopyFromPurchHeader(PurchHeader);
            SetCurrencyFactor(PurchHeader."Currency Code", PurchHeader."Currency Factor");
            "System-Created Entry" := TRUE;

            CopyFromPurchHeaderApplyTo(PurchHeader);
            "Applies-to Bill No." := PurchHeader."Applies-to Bill No.";
            CopyFromPurchHeaderPayment(PurchHeader);

            Amount := -TotalPurchLine2."Amount Including VAT";
            "Source Currency Amount" := -TotalPurchLine2."Amount Including VAT";
            "Amount (LCY)" := -TotalPurchLineLCY2."Amount Including VAT";
            "Sales/Purch. (LCY)" := -TotalPurchLineLCY2.Amount;
            "Inv. Discount (LCY)" := -TotalPurchLineLCY2."Inv. Discount Amount";
            "Pmt. Address Code" := PurchHeader."Pay-at Code";
            "Recipient Bank Account" := PurchHeader."Vendor Bank Acc. Code";
            "Generate AutoInvoices" := PurchHeader."Generate Autoinvoices" OR PurchHeader."Generate Autocredit Memo";
            "AutoDoc. No." := AutoDocNo;
            "Purch. Invoice Type" := PurchHeader."Invoice Type";
            "Purch. Cr. Memo Type" := PurchHeader."Cr. Memo Type";
            "Purch. Special Scheme Code" := PurchHeader."Special Scheme Code";
            "Correction Type" := PurchHeader."Correction Type";
            "Corrected Invoice No." := PurchHeader."Corrected Invoice No.";
            "Succeeded Company Name" := PurchHeader."Succeeded Company Name";
            "Succeeded VAT Registration No." := PurchHeader."Succeeded VAT Registration No.";
            "ID Type" := PurchHeader."ID Type";

            OnBeforePostVendorEntry(GenJnlLine, PurchHeader, TotalPurchLine2, TotalPurchLineLCY2, PreviewMode, SuppressCommit);
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            OnAfterPostVendorEntry(GenJnlLine, PurchHeader, TotalPurchLine2, TotalPurchLineLCY2, SuppressCommit, GenJnlPostLine);
        END;
    END;

    LOCAL PROCEDURE PostBalancingEntry(PurchHeader: Record 38; TotalPurchLine2: Record 39; TotalPurchLineLCY2: Record 39; DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]);
    VAR
        GenJnlLine: Record 81;
        VendLedgEntry: Record 25;
    BEGIN
        FindVendorLedgerEntry(DocType, DocNo, VendLedgEntry);

        WITH GenJnlLine DO BEGIN
            InitNewLine(
              PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
              PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code",
              PurchHeader."Dimension Set ID", PurchHeader."Reason Code");

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(0), DocNo, ExtDocNo, SourceCode, '');
            "Account Type" := "Account Type"::Vendor;
            "Account No." := PurchHeader."Pay-to Vendor No.";
            CopyFromPurchHeader(PurchHeader);
            SetCurrencyFactor(PurchHeader."Currency Code", PurchHeader."Currency Factor");

            IF PurchHeader.IsCreditDocType THEN
                "Document Type" := "Document Type"::Refund
            ELSE
                "Document Type" := "Document Type"::Payment;

            SetApplyToDocNo(PurchHeader, GenJnlLine, DocType, DocNo);

            Amount := TotalPurchLine2."Amount Including VAT";
            "Source Currency Amount" := Amount;
            VendLedgEntry.CALCFIELDS(Amount);
            IF VendLedgEntry.Amount = 0 THEN
                "Amount (LCY)" := TotalPurchLineLCY2."Amount Including VAT"
            ELSE
                "Amount (LCY)" :=
                  TotalPurchLineLCY2."Amount Including VAT" +
                  ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible" / VendLedgEntry."Adjusted Currency Factor");
            "Allow Zero-Amount Posting" := TRUE;

            OnBeforePostBalancingEntry(GenJnlLine, PurchHeader, TotalPurchLine2, TotalPurchLineLCY2, PreviewMode, SuppressCommit);
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            OnAfterPostBalancingEntry(GenJnlLine, PurchHeader, TotalPurchLine2, TotalPurchLineLCY2, SuppressCommit, GenJnlPostLine);
        END;
    END;

    LOCAL PROCEDURE SetApplyToDocNo(PurchHeader: Record 38; VAR GenJnlLine: Record 81; DocType: Option; DocNo: Code[20]);
    BEGIN
        WITH GenJnlLine DO BEGIN
            IF PurchHeader."Bal. Account Type" = PurchHeader."Bal. Account Type"::"Bank Account" THEN
                "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
            "Bal. Account No." := PurchHeader."Bal. Account No.";
            "Applies-to Doc. Type" := Enum::"Gen. Journal Document Type".FromInteger(DocType);//option to enum
            "Applies-to Doc. No." := DocNo;
        END;

        OnAfterSetApplyToDocNo(GenJnlLine, PurchHeader);
    END;

    LOCAL PROCEDURE FindVendorLedgerEntry(DocType: Option; DocNo: Code[20]; VAR VendorLedgerEntry: Record 25);
    BEGIN
        VendorLedgerEntry.SETRANGE("Document Type", DocType);
        VendorLedgerEntry.SETRANGE("Document No.", DocNo);
        VendorLedgerEntry.FINDLAST;
    END;

    LOCAL PROCEDURE RunGenJnlPostLine(VAR GenJnlLine: Record 81): Integer;
    BEGIN
        EXIT(GenJnlPostLine.RunWithCheck(GenJnlLine));
    END;

    LOCAL PROCEDURE CheckPostRestrictions(PurchaseHeader: Record 38);
    VAR
        Vendor: Record 23;
        Contact: Record 5050;
    BEGIN
        IF NOT PreviewMode THEN
            PurchaseHeader.OnCheckPurchasePostRestrictions;

        Vendor.GET(PurchaseHeader."Buy-from Vendor No.");
        Vendor.CheckBlockedVendOnDocs(Vendor, TRUE);
        PurchaseHeader.ValidatePurchaserOnPurchHeader(PurchaseHeader, TRUE, TRUE);

        IF PurchaseHeader."Pay-to Vendor No." <> PurchaseHeader."Buy-from Vendor No." THEN BEGIN
            Vendor.GET(PurchaseHeader."Pay-to Vendor No.");
            Vendor.CheckBlockedVendOnDocs(Vendor, TRUE);
        END;

        IF PurchaseHeader."Buy-from Contact No." <> '' THEN
            IF Contact.GET(PurchaseHeader."Buy-from Contact No.") THEN
                Contact.CheckIfPrivacyBlocked(TRUE);
        IF PurchaseHeader."Pay-to Contact No." <> '' THEN
            IF Contact.GET(PurchaseHeader."Pay-to Contact No.") THEN
                Contact.CheckIfPrivacyBlocked(TRUE);
    END;

    LOCAL PROCEDURE CheckFAPostingPossibility(PurchaseHeader: Record 38);
    VAR
        PurchaseLine: Record 39;
        PurchaseLineToFind: Record 39;
        FADepreciationBook: Record 5612;
        HasBookValue: Boolean;
    BEGIN
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::"Fixed Asset");
        PurchaseLine.SETFILTER("No.", '<>%1', '');
        IF PurchaseLine.FINDSET THEN
            REPEAT
                PurchaseLineToFind.COPYFILTERS(PurchaseLine);
                PurchaseLineToFind.SETRANGE("No.", PurchaseLine."No.");
                PurchaseLineToFind.SETRANGE("Depr. until FA Posting Date", NOT PurchaseLine."Depr. until FA Posting Date");
                IF NOT PurchaseLineToFind.ISEMPTY THEN
                    ERROR(MixedDerpFAUntilPostingDateErr, PurchaseLine."No.");

                IF PurchaseLine."Depr. until FA Posting Date" THEN BEGIN
                    PurchaseLineToFind.SETRANGE("Depr. until FA Posting Date", TRUE);
                    PurchaseLineToFind.SETFILTER("Line No.", '<>%1', PurchaseLine."Line No.");
                    IF NOT PurchaseLineToFind.ISEMPTY THEN BEGIN
                        HasBookValue := FALSE;
                        FADepreciationBook.SETRANGE("FA No.", PurchaseLine."No.");
                        FADepreciationBook.FINDSET;
                        REPEAT
                            FADepreciationBook.CALCFIELDS("Book Value");
                            HasBookValue := HasBookValue OR (FADepreciationBook."Book Value" <> 0);
                        UNTIL (FADepreciationBook.NEXT = 0) OR HasBookValue;
                        IF NOT HasBookValue THEN
                            ERROR(CannotPostSameMultipleFAWhenDeprBookValueZeroErr, PurchaseLine."No.");
                    END;
                END;
            UNTIL PurchaseLine.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteItemChargeAssgnt(PurchHeader: Record 38);
    VAR
        ItemChargeAssgntPurch: Record 5805;
    BEGIN
        ItemChargeAssgntPurch.SETRANGE("Document Type", PurchHeader."Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.", PurchHeader."No.");
        IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
            ItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateItemChargeAssgnt();
    VAR
        ItemChargeAssgntPurch: Record 5805;
    BEGIN
        WITH TempItemChargeAssgntPurch DO BEGIN
            ClearItemChargeAssgntFilter;
            MARKEDONLY(TRUE);
            IF FINDSET THEN
                REPEAT
                    ItemChargeAssgntPurch.GET("Document Type", "Document No.", "Document Line No.", "Line No.");
                    ItemChargeAssgntPurch."Qty. Assigned" :=
                      ItemChargeAssgntPurch."Qty. Assigned" + "Qty. to Assign";
                    ItemChargeAssgntPurch."Qty. to Assign" := 0;
                    ItemChargeAssgntPurch."Amount to Assign" := 0;
                    ItemChargeAssgntPurch.MODIFY;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdatePurchOrderChargeAssgnt(PurchOrderInvLine: Record 39; PurchOrderLine: Record 39);
    VAR
        PurchOrderLine2: Record 39;
        PurchOrderInvLine2: Record 39;
        PurchRcptLine: Record 121;
        ReturnShptLine: Record 6651;
        DocumentNo: Code[20];
    BEGIN
        WITH PurchOrderInvLine DO BEGIN
            ClearItemChargeAssgntFilter;
            TempItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
            TempItemChargeAssgntPurch.SETRANGE("Document No.", "Document No.");
            TempItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
            TempItemChargeAssgntPurch.MARKEDONLY(TRUE);
            IF TempItemChargeAssgntPurch.FINDSET THEN
                REPEAT
                    IF TempItemChargeAssgntPurch."Applies-to Doc. Type" = "Document Type" THEN BEGIN
                        PurchOrderInvLine2.GET(
                          TempItemChargeAssgntPurch."Applies-to Doc. Type",
                          TempItemChargeAssgntPurch."Applies-to Doc. No.",
                          TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                        IF PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::Order THEN BEGIN
                            IF NOT
                               PurchRcptLine.GET(PurchOrderInvLine2."Receipt No.", PurchOrderInvLine2."Receipt Line No.")
                            THEN
                                ERROR(ReceiptLinesDeletedErr);
                            PurchOrderLine2.GET(
                              PurchOrderLine2."Document Type"::Order,
                              PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                            DocumentNo := PurchRcptLine."Order No.";
                        END ELSE BEGIN
                            IF NOT
                               ReturnShptLine.GET(PurchOrderInvLine2."Return Shipment No.", PurchOrderInvLine2."Return Shipment Line No.")
                            THEN
                                ERROR(ReturnShipmentLinesDeletedErr);
                            PurchOrderLine2.GET(
                              PurchOrderLine2."Document Type"::"Return Order",
                              ReturnShptLine."Return Order No.", ReturnShptLine."Return Order Line No.");
                            DocumentNo := ReturnShptLine."Return Order No.";
                        END;
                        IF PurchOrderLine2."Document No." = DocumentNo THEN
                            UpdatePurchChargeAssgntLines(
                              PurchOrderLine,
                              PurchOrderLine2."Document Type", //enum to option
                              PurchOrderLine2."Document No.",
                              PurchOrderLine2."Line No.",
                              TempItemChargeAssgntPurch."Qty. to Assign");
                    END ELSE
                        UpdatePurchChargeAssgntLines(
                          PurchOrderLine,
                          TempItemChargeAssgntPurch."Applies-to Doc. Type", //enum to option
                          TempItemChargeAssgntPurch."Applies-to Doc. No.",
                          TempItemChargeAssgntPurch."Applies-to Doc. Line No.",
                          TempItemChargeAssgntPurch."Qty. to Assign");
                UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdatePurchChargeAssgntLines(PurchOrderLine: Record 39; ApplToDocType: Enum "Purchase Document Type"; ApplToDocNo: Code[20]; ApplToDocLineNo: Integer; QtytoAssign: Decimal);
    VAR
        ItemChargeAssgntPurch: Record 5805;
        TempItemChargeAssgntPurch2: Record 5805;
        LastLineNo: Integer;
        TotalToAssign: Decimal;
    BEGIN
        ItemChargeAssgntPurch.SETRANGE("Document Type", PurchOrderLine."Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.", PurchOrderLine."Document No.");
        ItemChargeAssgntPurch.SETRANGE("Document Line No.", PurchOrderLine."Line No.");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type", ApplToDocType);
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.", ApplToDocNo);
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.", ApplToDocLineNo);
        IF ItemChargeAssgntPurch.FINDFIRST THEN BEGIN
            GetCurrency(PurchOrderLine."Currency Code");
            ItemChargeAssgntPurch."Qty. Assigned" += QtytoAssign;
            ItemChargeAssgntPurch."Qty. to Assign" -= QtytoAssign;
            IF ItemChargeAssgntPurch."Qty. to Assign" < 0 THEN
                ItemChargeAssgntPurch."Qty. to Assign" := 0;
            ItemChargeAssgntPurch."Amount to Assign" :=
              ROUND(ItemChargeAssgntPurch."Qty. to Assign" * ItemChargeAssgntPurch."Unit Cost", Currency."Amount Rounding Precision");
            ItemChargeAssgntPurch.MODIFY;
        END ELSE BEGIN
            ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
            ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
            ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
            ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign");

            TempItemChargeAssgntPurch2.SETRANGE("Document Type", TempItemChargeAssgntPurch."Document Type");
            TempItemChargeAssgntPurch2.SETRANGE("Document No.", TempItemChargeAssgntPurch."Document No.");
            TempItemChargeAssgntPurch2.SETRANGE("Document Line No.", TempItemChargeAssgntPurch."Document Line No.");
            TempItemChargeAssgntPurch2.CALCSUMS("Qty. to Assign");

            TotalToAssign := ItemChargeAssgntPurch."Qty. to Assign" +
              TempItemChargeAssgntPurch2."Qty. to Assign";

            IF ItemChargeAssgntPurch.FINDLAST THEN
                LastLineNo := ItemChargeAssgntPurch."Line No.";

            IF PurchOrderLine.Quantity < TotalToAssign THEN
                REPEAT
                    TotalToAssign := TotalToAssign - ItemChargeAssgntPurch."Qty. to Assign";
                    ItemChargeAssgntPurch."Qty. to Assign" := 0;
                    ItemChargeAssgntPurch."Amount to Assign" := 0;
                    ItemChargeAssgntPurch.MODIFY;
                UNTIL (ItemChargeAssgntPurch.NEXT(-1) = 0) OR
                      (TotalToAssign = PurchOrderLine.Quantity);

            InsertAssocOrderCharge(
              PurchOrderLine,
              ApplToDocType,
              ApplToDocNo,
              ApplToDocLineNo,
              LastLineNo,
              TempItemChargeAssgntPurch."Applies-to Doc. Line Amount");
        END;
    END;

    LOCAL PROCEDURE InsertAssocOrderCharge(PurchOrderLine: Record 39; ApplToDocType: Enum "Purchase Document Type"; ApplToDocNo: Code[20]; ApplToDocLineNo: Integer; LastLineNo: Integer; ApplToDocLineAmt: Decimal);
    VAR
        NewItemChargeAssgntPurch: Record 5805;
    BEGIN
        WITH NewItemChargeAssgntPurch DO BEGIN
            INIT;
            "Document Type" := PurchOrderLine."Document Type";
            "Document No." := PurchOrderLine."Document No.";
            "Document Line No." := PurchOrderLine."Line No.";
            "Line No." := LastLineNo + 10000;
            "Item Charge No." := TempItemChargeAssgntPurch."Item Charge No.";
            "Item No." := TempItemChargeAssgntPurch."Item No.";
            "Qty. Assigned" := TempItemChargeAssgntPurch."Qty. to Assign";
            "Qty. to Assign" := 0;
            "Amount to Assign" := 0;
            Description := TempItemChargeAssgntPurch.Description;
            "Unit Cost" := TempItemChargeAssgntPurch."Unit Cost";
            "Applies-to Doc. Type" := ApplToDocType;//option to enum
            "Applies-to Doc. No." := ApplToDocNo;
            "Applies-to Doc. Line No." := ApplToDocLineNo;
            "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE CopyAndCheckItemCharge(PurchHeader: Record 38);
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        PurchLine: Record 39;
        InvoiceEverything: Boolean;
        AssignError: Boolean;
        QtyNeeded: Decimal;
    BEGIN
        TempItemChargeAssgntPurch.RESET;
        TempItemChargeAssgntPurch.DELETEALL;

        // Check for max qty posting
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETRANGE(Type, Type::"Charge (Item)");
            IF ISEMPTY THEN
                EXIT;

            CopyItemChargeForPurchLine(TempItemChargeAssgntPurch, TempPurchLine);

            SETFILTER("Qty. to Invoice", '<>0');
            IF FINDSET THEN
                REPEAT
                    OnCopyAndCheckItemChargeOnBeforeLoop(TempPurchLine, PurchHeader);
                    TESTFIELD("Job No.", '');
                    IF PurchHeader.Invoice AND
                       ("Qty. to Receive" + "Return Qty. to Ship" <> 0) AND
                       ((PurchHeader.Ship OR PurchHeader.Receive) OR
                        (ABS("Qty. to Invoice") >
                         ABS("Qty. Rcd. Not Invoiced" + "Qty. to Receive") +
                         ABS("Ret. Qty. Shpd Not Invd.(Base)" + "Return Qty. to Ship")))
                    THEN
                        TESTFIELD("Line Amount");

                    IF NOT PurchHeader.Receive THEN
                        "Qty. to Receive" := 0;
                    IF NOT PurchHeader.Ship THEN
                        "Return Qty. to Ship" := 0;
                    IF ABS("Qty. to Invoice") >
                       ABS("Quantity Received" + "Qty. to Receive" +
                         "Return Qty. Shipped" + "Return Qty. to Ship" -
                         "Quantity Invoiced")
                    THEN
                        "Qty. to Invoice" :=
                          "Quantity Received" + "Qty. to Receive" +
                          "Return Qty. Shipped (Base)" + "Return Qty. to Ship (Base)" -
                          "Quantity Invoiced";

                    CALCFIELDS("Qty. to Assign", "Qty. Assigned");
                    IF ABS("Qty. to Assign" + "Qty. Assigned") >
                       ABS("Qty. to Invoice" + "Quantity Invoiced")
                    THEN BEGIN
                        AdjustQtyToAssignForPurchLine(TempPurchLine);

                        CALCFIELDS("Qty. to Assign", "Qty. Assigned");
                        IF ABS("Qty. to Assign" + "Qty. Assigned") >
                           ABS("Qty. to Invoice" + "Quantity Invoiced")
                        THEN
                            ERROR(CannotAssignMoreErr,
                              "Qty. to Invoice" + "Quantity Invoiced" - "Qty. Assigned",
                              FIELDCAPTION("Document Type"), "Document Type",
                              FIELDCAPTION("Document No."), "Document No.",
                              FIELDCAPTION("Line No."), "Line No.");

                        CopyItemChargeForPurchLine(TempItemChargeAssgntPurch, TempPurchLine);
                    END;
                    IF Quantity = "Qty. to Invoice" + "Quantity Invoiced" THEN BEGIN
                        IF "Qty. to Assign" <> 0 THEN
                            IF Quantity = "Quantity Invoiced" THEN BEGIN
                                TempItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
                                TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type", "Document Type");
                                IF TempItemChargeAssgntPurch.FINDSET THEN
                                    REPEAT
                                        PurchLine.GET(
                                          TempItemChargeAssgntPurch."Applies-to Doc. Type",
                                          TempItemChargeAssgntPurch."Applies-to Doc. No.",
                                          TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                                        IF PurchLine.Quantity = PurchLine."Quantity Invoiced" THEN
                                            ERROR(CannotAssignInvoicedErr, PurchLine.TABLECAPTION,
                                              PurchLine.FIELDCAPTION("Document Type"), PurchLine."Document Type",
                                              PurchLine.FIELDCAPTION("Document No."), PurchLine."Document No.",
                                              PurchLine.FIELDCAPTION("Line No."), PurchLine."Line No.");
                                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                            END;
                        IF Quantity <> "Qty. to Assign" + "Qty. Assigned" THEN
                            AssignError := TRUE;
                    END;

                    IF ("Qty. to Assign" + "Qty. Assigned") < ("Qty. to Invoice" + "Quantity Invoiced") THEN
                        ERROR(MustAssignItemChargeErr, "No.");

                    // check if all ILEs exist
                    QtyNeeded := "Qty. to Assign";
                    TempItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
                    IF TempItemChargeAssgntPurch.FINDSET THEN
                        REPEAT
                            IF (TempItemChargeAssgntPurch."Applies-to Doc. Type" <> "Document Type") OR
                               (TempItemChargeAssgntPurch."Applies-to Doc. No." <> "Document No.")
                            THEN
                                QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign"
                            ELSE BEGIN
                                PurchLine.GET(
                                  TempItemChargeAssgntPurch."Applies-to Doc. Type",
                                  TempItemChargeAssgntPurch."Applies-to Doc. No.",
                                  TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                                IF ItemLedgerEntryExist(PurchLine, PurchHeader.Receive OR PurchHeader.Ship) THEN
                                    QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign";
                            END;
                        UNTIL TempItemChargeAssgntPurch.NEXT = 0;

                    IF QtyNeeded <> 0 THEN
                        ERROR(CannotInvoiceItemChargeErr, "No.");
                UNTIL NEXT = 0;

            // Check purchlines
            IF AssignError THEN
                IF PurchHeader."Document Type" IN
                   [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"]
                THEN
                    InvoiceEverything := TRUE
                ELSE BEGIN
                    RESET;
                    SETFILTER(Type, '%1|%2', Type::Item, Type::"Charge (Item)");
                    IF FINDSET THEN
                        REPEAT
                            IF PurchHeader.Ship OR PurchHeader.Receive THEN
                                InvoiceEverything :=
                                  Quantity = "Qty. to Invoice" + "Quantity Invoiced"
                            ELSE
                                InvoiceEverything :=
                                  (Quantity = "Qty. to Invoice" + "Quantity Invoiced") AND
                                  ("Qty. to Invoice" =
                                   "Qty. Rcd. Not Invoiced" + "Return Qty. Shipped Not Invd.");
                        UNTIL (NEXT = 0) OR (NOT InvoiceEverything);
                END;

            IF InvoiceEverything AND AssignError THEN
                ERROR(MustAssignErr);
        END;
    END;

    LOCAL PROCEDURE CopyItemChargeForPurchLine(VAR TempItemChargeAssignmentPurch: Record 5805 TEMPORARY; PurchaseLine: Record 39);
    VAR
        ItemChargeAssgntPurch: Record 5805;
    BEGIN
        TempItemChargeAssignmentPurch.RESET;
        TempItemChargeAssignmentPurch.SETRANGE("Document Type", PurchaseLine."Document Type");
        TempItemChargeAssignmentPurch.SETRANGE("Document No.", PurchaseLine."Document No.");
        IF NOT TempItemChargeAssignmentPurch.ISEMPTY THEN
            TempItemChargeAssignmentPurch.DELETEALL;

        ItemChargeAssgntPurch.RESET;
        ItemChargeAssgntPurch.SETRANGE("Document Type", PurchaseLine."Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.", PurchaseLine."Document No.");
        ItemChargeAssgntPurch.SETFILTER("Qty. to Assign", '<>0');
        IF ItemChargeAssgntPurch.FINDSET THEN
            REPEAT
                TempItemChargeAssignmentPurch.INIT;
                TempItemChargeAssignmentPurch := ItemChargeAssgntPurch;
                TempItemChargeAssignmentPurch.INSERT;
            UNTIL ItemChargeAssgntPurch.NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustQtyToAssignForPurchLine(VAR TempPurchaseLine: Record 39 TEMPORARY);
    VAR
        ItemChargeAssgntPurch: Record 5805;
    BEGIN
        WITH TempPurchaseLine DO BEGIN
            CALCFIELDS("Qty. to Assign");

            ItemChargeAssgntPurch.RESET;
            ItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
            ItemChargeAssgntPurch.SETRANGE("Document No.", "Document No.");
            ItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
            ItemChargeAssgntPurch.SETFILTER("Qty. to Assign", '<>0');
            IF ItemChargeAssgntPurch.FINDSET THEN
                REPEAT
                    ItemChargeAssgntPurch.VALIDATE("Qty. to Assign",
                      "Qty. to Invoice" * ROUND(ItemChargeAssgntPurch."Qty. to Assign" / "Qty. to Assign", 0.00001));
                    ItemChargeAssgntPurch.MODIFY;
                UNTIL ItemChargeAssgntPurch.NEXT = 0;

            CALCFIELDS("Qty. to Assign");
            IF "Qty. to Assign" < "Qty. to Invoice" THEN BEGIN
                ItemChargeAssgntPurch.VALIDATE("Qty. to Assign",
                  ItemChargeAssgntPurch."Qty. to Assign" + ABS("Qty. to Invoice" - "Qty. to Assign"));
                ItemChargeAssgntPurch.MODIFY;
            END;

            IF "Qty. to Assign" > "Qty. to Invoice" THEN BEGIN
                ItemChargeAssgntPurch.VALIDATE("Qty. to Assign",
                  ItemChargeAssgntPurch."Qty. to Assign" - ABS("Qty. to Invoice" - "Qty. to Assign"));
                ItemChargeAssgntPurch.MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE ClearItemChargeAssgntFilter();
    BEGIN
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
        TempItemChargeAssgntPurch.MARKEDONLY(FALSE);
    END;

    LOCAL PROCEDURE GetItemChargeLine(PurchHeader: Record 38; VAR ItemChargePurchLine: Record 39);
    VAR
        QtyReceived: Decimal;
        QtyReturnShipped: Decimal;
    BEGIN
        WITH TempItemChargeAssgntPurch DO
            IF (ItemChargePurchLine."Document Type" <> "Document Type") OR
               (ItemChargePurchLine."Document No." <> "Document No.") OR
               (ItemChargePurchLine."Line No." <> "Document Line No.")
            THEN BEGIN
                ItemChargePurchLine.GET("Document Type", "Document No.", "Document Line No.");
                OnGetItemChargeLineOnAfterGet(ItemChargePurchLine, PurchHeader);
                IF NOT PurchHeader.Receive THEN
                    ItemChargePurchLine."Qty. to Receive" := 0;
                IF NOT PurchHeader.Ship THEN
                    ItemChargePurchLine."Return Qty. to Ship" := 0;

                IF ItemChargePurchLine."Receipt No." = '' THEN
                    QtyReceived := ItemChargePurchLine."Quantity Received"
                ELSE
                    QtyReceived := "Qty. to Assign";
                IF ItemChargePurchLine."Return Shipment No." = '' THEN
                    QtyReturnShipped := ItemChargePurchLine."Return Qty. Shipped"
                ELSE
                    QtyReturnShipped := "Qty. to Assign";

                IF ABS(ItemChargePurchLine."Qty. to Invoice") >
                   ABS(QtyReceived + ItemChargePurchLine."Qty. to Receive" +
                     QtyReturnShipped + ItemChargePurchLine."Return Qty. to Ship" -
                     ItemChargePurchLine."Quantity Invoiced")
                THEN
                    ItemChargePurchLine."Qty. to Invoice" :=
                      QtyReceived + ItemChargePurchLine."Qty. to Receive" +
                      QtyReturnShipped + ItemChargePurchLine."Return Qty. to Ship" -
                      ItemChargePurchLine."Quantity Invoiced";
            END;
    END;

    LOCAL PROCEDURE CalcQtyToInvoice(QtyToHandle: Decimal; QtyToInvoice: Decimal): Decimal;
    BEGIN
        IF ABS(QtyToHandle) > ABS(QtyToInvoice) THEN
            EXIT(QtyToHandle);

        EXIT(QtyToInvoice);
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    END;

    PROCEDURE CheckWarehouse(VAR TempItemPurchLine: Record 39 TEMPORARY);
    VAR
        WhseValidateSourceLine: Codeunit 5777;
        ShowError: Boolean;
    BEGIN
        WITH TempItemPurchLine DO BEGIN
            IF "Prod. Order No." <> '' THEN
                EXIT;
            SETRANGE(Type, Type::Item);
            SETRANGE("Drop Shipment", FALSE);
            IF FINDSET THEN
                REPEAT
                    GetLocation("Location Code");
                    CASE "Document Type" OF
                        "Document Type"::Order:
                            IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity >= 0)) OR
                               ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity < 0))
                            THEN BEGIN
                                IF Location."Directed Put-away and Pick" THEN
                                    ShowError := TRUE
                                ELSE
                                    IF WhseValidateSourceLine.WhseLinesExist(
                                         DATABASE::"Purchase Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, Quantity) //enum to option
                                    THEN
                                        ShowError := TRUE;
                            END;
                        "Document Type"::"Return Order":
                            IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity < 0)) OR
                               ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity >= 0))
                            THEN BEGIN
                                IF Location."Directed Put-away and Pick" THEN
                                    ShowError := TRUE
                                ELSE
                                    IF WhseValidateSourceLine.WhseLinesExist(
                                         DATABASE::"Purchase Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, Quantity)//enum to option
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

    LOCAL PROCEDURE CreateWhseJnlLine(ItemJnlLine: Record 83; PurchLine: Record 39; VAR TempWhseJnlLine: Record 7311 TEMPORARY);
    VAR
        WhseMgt: Codeunit 5775;
        WMSMgt: Codeunit 7302;
    BEGIN
        WITH PurchLine DO BEGIN
            WMSMgt.CheckAdjmtBin(Location, ItemJnlLine.Quantity, TRUE);
            WMSMgt.CreateWhseJnlLine(ItemJnlLine, 0, TempWhseJnlLine, FALSE);
            TempWhseJnlLine."Source Type" := DATABASE::"Purchase Line";
            TempWhseJnlLine."Source Subtype" := "Document Type".AsInteger();//enum to option
            TempWhseJnlLine."Source Document" := Enum::"Warehouse Journal Source Document".FromInteger(WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type", TempWhseJnlLine."Source Subtype"));
            TempWhseJnlLine."Source No." := "Document No.";
            TempWhseJnlLine."Source Line No." := "Line No.";
            TempWhseJnlLine."Source Code" := SrcCode;
            CASE "Document Type" OF
                "Document Type"::Order:
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted Rcpt.";
                "Document Type"::Invoice:
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted P. Inv.";
                "Document Type"::"Credit Memo":
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted P. Cr. Memo";
                "Document Type"::"Return Order":
                    TempWhseJnlLine."Reference Document" :=
                      TempWhseJnlLine."Reference Document"::"Posted Rtrn. Rcpt.";
            END;
            TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
        END;
    END;

    LOCAL PROCEDURE WhseHandlingRequired(PurchLine: Record 39): Boolean;
    VAR
        WhseSetup: Record 5769;
    BEGIN
        IF (PurchLine.Type = PurchLine.Type::Item) AND (NOT PurchLine."Drop Shipment") THEN BEGIN
            IF PurchLine."Location Code" = '' THEN BEGIN
                WhseSetup.GET;
                IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
                    EXIT(WhseSetup."Require Pick");

                EXIT(WhseSetup."Require Receive");
            END;

            GetLocation(PurchLine."Location Code");
            IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
                EXIT(Location."Require Pick");

            EXIT(Location."Require Receive");
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

    LOCAL PROCEDURE InsertRcptEntryRelation(VAR PurchRcptLine: Record 121): Integer;
    VAR
        ItemEntryRelation: Record 6507;
    BEGIN
        TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
        TempHandlingSpecification.RESET;
        IF TempHandlingSpecification.FINDSET THEN BEGIN
            REPEAT
                ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
                ItemEntryRelation.TransferFieldsPurchRcptLine(PurchRcptLine);
                ItemEntryRelation.INSERT;
            UNTIL TempHandlingSpecification.NEXT = 0;
            TempHandlingSpecification.DELETEALL;
            EXIT(0);
        END;
        EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE InsertReturnEntryRelation(VAR ReturnShptLine: Record 6651): Integer;
    VAR
        ItemEntryRelation: Record 6507;
    BEGIN
        TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
        TempHandlingSpecification.RESET;
        IF TempHandlingSpecification.FINDSET THEN BEGIN
            REPEAT
                ItemEntryRelation.INIT;
                ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
                ItemEntryRelation.TransferFieldsReturnShptLine(ReturnShptLine);
                ItemEntryRelation.INSERT;
            UNTIL TempHandlingSpecification.NEXT = 0;
            TempHandlingSpecification.DELETEALL;
            EXIT(0);
        END;
        EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE CheckTrackingSpecification(PurchHeader: Record 38; VAR TempItemPurchLine: Record 39 TEMPORARY);
    VAR
        ReservationEntry: Record 337;
        Item: Record 27;
        ItemTrackingCode: Record 6502;
        ItemJnlLine: Record 83;
        CreateReservEntry: Codeunit 99000830;
        ItemTrackingManagement: Codeunit 6500;
        ItemTrackingManagement1: Codeunit 51151;
        ErrorFieldCaption: Text[250];
        SignFactor: Integer;
        PurchLineQtyToHandle: Decimal;
        TrackingQtyToHandle: Decimal;
        Inbound: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        SNInfoRequired: Boolean;
        LotInfoRequired: Boolean;
        CheckPurchLine: Boolean;
    BEGIN
        // if a PurchaseLine is posted with ItemTracking then tracked quantity must be equal to posted quantity
        IF NOT (PurchHeader."Document Type" IN
                [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"])
        THEN
            EXIT;

        TrackingQtyToHandle := 0;

        WITH TempItemPurchLine DO BEGIN
            SETRANGE(Type, Type::Item);
            IF PurchHeader.Receive THEN BEGIN
                SETFILTER("Quantity Received", '<>%1', 0);
                ErrorFieldCaption := FIELDCAPTION("Qty. to Receive");
            END ELSE BEGIN
                SETFILTER("Return Qty. Shipped", '<>%1', 0);
                ErrorFieldCaption := FIELDCAPTION("Return Qty. to Ship");
            END;

            IF FINDSET THEN BEGIN
                ReservationEntry."Source Type" := DATABASE::"Purchase Line";
                ReservationEntry."Source Subtype" := PurchHeader."Document Type".AsInteger();//enum to option
                SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
                REPEAT
                    // Only Item where no SerialNo or LotNo is required
                    Item.GET("No.");
                    IF Item."Item Tracking Code" <> '' THEN BEGIN
                        Inbound := (Quantity * SignFactor) > 0;
                        ItemTrackingCode.Code := Item."Item Tracking Code";
                        ItemTrackingManagement1.GetItemTrackingSettings(ItemTrackingCode,
                          ItemJnlLine."Entry Type"::Purchase, Inbound,
                          SNRequired, LotRequired, SNInfoRequired, LotInfoRequired);
                        CheckPurchLine := NOT SNRequired AND NOT LotRequired;
                        IF CheckPurchLine THEN
                            CheckPurchLine := CheckTrackingExists(TempItemPurchLine);
                    END ELSE
                        CheckPurchLine := FALSE;

                    TrackingQtyToHandle := 0;

                    IF CheckPurchLine THEN BEGIN
                        TrackingQtyToHandle := GetTrackingQuantities(TempItemPurchLine) * SignFactor;
                        IF PurchHeader.Receive THEN
                            PurchLineQtyToHandle := "Qty. to Receive (Base)"
                        ELSE
                            PurchLineQtyToHandle := "Return Qty. to Ship (Base)";
                        IF TrackingQtyToHandle <> PurchLineQtyToHandle THEN
                            ERROR(ItemTrackQuantityMismatchErr, ErrorFieldCaption);
                    END;
                UNTIL NEXT = 0;
            END;
            IF PurchHeader.Receive THEN
                SETRANGE("Quantity Received")
            ELSE
                SETRANGE("Return Qty. Shipped");
        END;
    END;

    LOCAL PROCEDURE CheckTrackingExists(PurchLine: Record 39): Boolean;
    BEGIN
        EXIT(
          ItemTrackingMgt1.ItemTrackingExistsOnDocumentLine(
            DATABASE::"Purchase Line", PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No."));//enum to option
    END;

    LOCAL PROCEDURE GetTrackingQuantities(PurchLine: Record 39): Decimal;
    BEGIN
        EXIT(
          ItemTrackingMgt1.CalcQtyToHandleForTrackedQtyOnDocumentLine(
            DATABASE::"Purchase Line", PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No."));//enum to option
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

    LOCAL PROCEDURE InsertTrackingSpecification(PurchHeader: Record 38);
    BEGIN
        TempTrackingSpecification.RESET;
        IF NOT TempTrackingSpecification.ISEMPTY THEN BEGIN
            TempTrackingSpecification.InsertSpecification;
            ReservePurchLine.UpdateItemTrackingAfterPosting(PurchHeader);
        END;
    END;

    LOCAL PROCEDURE CalcBaseQty(ItemNo: Code[20]; UOMCode: Code[10]; Qty: Decimal): Decimal;
    VAR
        Item: Record 27;
        UOMMgt: Codeunit 5402;
    BEGIN
        Item.GET(ItemNo);
        EXIT(ROUND(Qty * UOMMgt.GetQtyPerUnitOfMeasure(Item, UOMCode), 0.00001));
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

    LOCAL PROCEDURE PostItemCharge(PurchHeader: Record 38; VAR PurchLine: Record 39; ItemEntryNo: Integer; QuantityBase: Decimal; AmountToAssign: Decimal; QtyToAssign: Decimal; IndirectCostPct: Decimal);
    VAR
        DummyTrackingSpecification: Record 336;
        PurchLineToPost: Record 39;
        CurrExchRate: Record 330;
    BEGIN
        WITH TempItemChargeAssgntPurch DO BEGIN
            PurchLineToPost := PurchLine;
            PurchLineToPost."No." := "Item No.";
            PurchLineToPost."Line No." := "Document Line No.";
            PurchLineToPost."Appl.-to Item Entry" := ItemEntryNo;
            PurchLineToPost."Indirect Cost %" := IndirectCostPct;

            PurchLineToPost.Amount := AmountToAssign;

            IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                PurchLineToPost.Amount := -PurchLineToPost.Amount;

            IF PurchLineToPost."Currency Code" <> '' THEN
                PurchLineToPost."Unit Cost" := ROUND(
                    PurchLineToPost.Amount / QuantityBase, Currency."Unit-Amount Rounding Precision")
            ELSE
                PurchLineToPost."Unit Cost" := ROUND(
                    PurchLineToPost.Amount / QuantityBase, GLSetup."Unit-Amount Rounding Precision");

            TotalChargeAmt := TotalChargeAmt + PurchLineToPost.Amount;
            IF PurchHeader."Currency Code" <> '' THEN
                PurchLineToPost.Amount :=
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    Usedate, PurchHeader."Currency Code", TotalChargeAmt, PurchHeader."Currency Factor");

            PurchLineToPost.Amount := ROUND(PurchLineToPost.Amount, GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
            IF PurchHeader."Currency Code" <> '' THEN
                TotalChargeAmtLCY := TotalChargeAmtLCY + PurchLineToPost.Amount;
            PurchLineToPost."Unit Cost (LCY)" :=
              ROUND(
                PurchLineToPost.Amount / QuantityBase, GLSetup."Unit-Amount Rounding Precision");

            PurchLineToPost."Inv. Discount Amount" := ROUND(
                PurchLine."Inv. Discount Amount" / PurchLine.Quantity * QtyToAssign,
                GLSetup."Amount Rounding Precision");

            PurchLineToPost."Line Discount Amount" := ROUND(
                PurchLine."Line Discount Amount" / PurchLine.Quantity * QtyToAssign,
                GLSetup."Amount Rounding Precision");
            PurchLineToPost."Line Amount" := ROUND(
                PurchLine."Line Amount" / PurchLine.Quantity * QtyToAssign,
                GLSetup."Amount Rounding Precision");
            UpdatePurchLineDimSetIDFromAppliedEntry(PurchLineToPost, PurchLine);
            PurchLine."Inv. Discount Amount" := PurchLine."Inv. Discount Amount" - PurchLineToPost."Inv. Discount Amount";
            PurchLine."Line Discount Amount" := PurchLine."Line Discount Amount" - PurchLineToPost."Line Discount Amount";
            PurchLine."Line Amount" := PurchLine."Line Amount" - PurchLineToPost."Line Amount";
            PurchLine.Quantity := PurchLine.Quantity - QtyToAssign;
            PostItemJnlLine(
              PurchHeader, PurchLineToPost,
              0, 0,
              QuantityBase, QuantityBase,
              PurchLineToPost."Appl.-to Item Entry", "Item Charge No.", DummyTrackingSpecification);
        END;
    END;

    LOCAL PROCEDURE SaveTempWhseSplitSpec(PurchLine3: Record 39);
    BEGIN
        TempWhseSplitSpecification.RESET;
        TempWhseSplitSpecification.DELETEALL;
        IF TempHandlingSpecification.FINDSET THEN
            REPEAT
                TempWhseSplitSpecification := TempHandlingSpecification;
                TempWhseSplitSpecification."Source Type" := DATABASE::"Purchase Line";
                TempWhseSplitSpecification."Source Subtype" := PurchLine3."Document Type".AsInteger();//enum to option
                TempWhseSplitSpecification."Source ID" := PurchLine3."Document No.";
                TempWhseSplitSpecification."Source Ref. No." := PurchLine3."Line No.";
                TempWhseSplitSpecification.INSERT;
            UNTIL TempHandlingSpecification.NEXT = 0;

        OnAfterSaveTempWhseSplitSpec(PurchLine3, TempWhseSplitSpecification);
    END;

    LOCAL PROCEDURE TransferReservToItemJnlLine(VAR SalesOrderLine: Record 37; VAR ItemJnlLine: Record 83; PurchLine: Record 39; QtyToBeShippedBase: Decimal; ApplySpecificItemTracking: Boolean);
    VAR
        ReserveSalesLine: Codeunit 99000832;
        RemainingQuantity: Decimal;
        CheckApplFromItemEntry: Boolean;
    BEGIN
        // Handle Item Tracking and reservations, also on drop shipment
        IF QtyToBeShippedBase = 0 THEN
            EXIT;

        IF NOT ApplySpecificItemTracking THEN
            ReserveSalesLine.TransferSalesLineToItemJnlLine(
              SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, FALSE)
        ELSE BEGIN
            ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
            TempTrackingSpecification.RESET;
            TempTrackingSpecification.SetSourceFilter(
              DATABASE::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.", FALSE);
            // TempTrackingSpecification.SetSourceFilter2('', 0);
            IF TempTrackingSpecification.ISEMPTY THEN
                ReserveSalesLine.TransferSalesLineToItemJnlLine(
                  SalesOrderLine, ItemJnlLine, QtyToBeShippedBase, CheckApplFromItemEntry, FALSE)
            ELSE BEGIN
                ReserveSalesLine.SetOverruleItemTracking(TRUE);
                TempTrackingSpecification.FINDSET;
                IF TempTrackingSpecification."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
                    ERROR(ItemTrackingWrongSignErr);
                REPEAT
                    ItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecification);
                    ItemJnlLine."Applies-to Entry" := TempTrackingSpecification."Item Ledger Entry No.";
                    RemainingQuantity :=
                      ReserveSalesLine.TransferSalesLineToItemJnlLine(
                        SalesOrderLine, ItemJnlLine, TempTrackingSpecification."Quantity (Base)", CheckApplFromItemEntry, FALSE);
                    IF RemainingQuantity <> 0 THEN
                        ERROR(ItemTrackingMismatchErr);
                UNTIL TempTrackingSpecification.NEXT = 0;
                ItemJnlLine.ClearTracking;
                ItemJnlLine."Applies-to Entry" := 0;
            END;
        END;
    END;


    LOCAL PROCEDURE CreatePrepmtLines(PurchHeader: Record 38; CompleteFunctionality: Boolean);
    VAR
        GLAcc: Record 15;
        TempPurchLine: Record 39 TEMPORARY;
        TempExtTextLine: Record 280 TEMPORARY;
        GenPostingSetup: Record 252;
        TempPrepmtPurchLine: Record 39 TEMPORARY;
        TransferExtText: Codeunit 378;
        NextLineNo: Integer;
        Fraction: Decimal;
        VATDifference: Decimal;
        TempLineFound: Boolean;
        PrepmtAmtToDeduct: Decimal;
    BEGIN
        GetGLSetup;
        WITH TempPurchLine DO BEGIN
            FillTempLines(PurchHeader, TempPurchLineGlobal);
            ResetTempLines(TempPurchLine);
            IF NOT FINDLAST THEN
                EXIT;
            NextLineNo := "Line No." + 10000;
            SETFILTER(Quantity, '>0');
            SETFILTER("Qty. to Invoice", '>0');
            IF FINDSET THEN BEGIN
                IF CompleteFunctionality AND ("Document Type" = "Document Type"::Invoice) THEN
                    TestGetRcptPPmtAmtToDeduct;
                REPEAT
                    IF CompleteFunctionality THEN
                        IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
                            IF NOT PurchHeader.Receive AND ("Qty. to Invoice" = Quantity - "Quantity Invoiced") THEN
                                IF "Qty. Rcd. Not Invoiced" < "Qty. to Invoice" THEN
                                    VALIDATE("Qty. to Invoice", "Qty. Rcd. Not Invoiced");
                            Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

                            IF "Prepayment %" <> 100 THEN
                                CASE TRUE OF
                                    ("Prepmt Amt to Deduct" <> 0) AND
                                  (ROUND(Fraction * "Line Amount", Currency."Amount Rounding Precision") < "Prepmt Amt to Deduct"):
                                        FIELDERROR(
                                          "Prepmt Amt to Deduct",
                                          STRSUBSTNO(
                                            CannotBeGreaterThanErr,
                                            ROUND(Fraction * "Line Amount", Currency."Amount Rounding Precision")));
                                    ("Prepmt. Amt. Inv." <> 0) AND
                                  (ROUND((1 - Fraction) * "Line Amount", Currency."Amount Rounding Precision") <
                                   ROUND(
                                     ROUND(
                                       ROUND("Direct Unit Cost" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
                                         Currency."Amount Rounding Precision") *
                                       (1 - "Line Discount %" / 100), Currency."Amount Rounding Precision") *
                                     "Prepayment %" / 100, Currency."Amount Rounding Precision")):
                                        FIELDERROR(
                                          "Prepmt Amt to Deduct",
                                          STRSUBSTNO(
                                            CannotBeSmallerThanErr,
                                            ROUND(
                                              "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
                                              (1 - Fraction) * "Line Amount", Currency."Amount Rounding Precision")));
                                END;
                        END;
                    IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
                        IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                           ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                        THEN
                            GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        GLAcc.GET(GenPostingSetup.GetPurchPrepmtAccount);
                        TempLineFound := FALSE;
                        IF PurchHeader."Compress Prepayment" THEN BEGIN
                            TempPrepmtPurchLine.SETRANGE("No.", GLAcc."No.");
                            TempPrepmtPurchLine.SETRANGE("Job No.", "Job No.");
                            TempPrepmtPurchLine.SETRANGE("Dimension Set ID", "Dimension Set ID");
                            TempLineFound := TempPrepmtPurchLine.FINDFIRST;
                        END;
                        IF TempLineFound THEN BEGIN
                            PrepmtAmtToDeduct :=
                              TempPrepmtPurchLine."Prepmt Amt to Deduct" +
                              InsertedPrepmtVATBaseToDeduct(
                                PurchHeader, TempPurchLine, TempPrepmtPurchLine."Line No.", TempPrepmtPurchLine."Direct Unit Cost");
                            VATDifference := TempPrepmtPurchLine."VAT Difference";
                            TempPrepmtPurchLine.VALIDATE(
                              "Direct Unit Cost", TempPrepmtPurchLine."Direct Unit Cost" + "Prepmt Amt to Deduct");
                            TempPrepmtPurchLine.VALIDATE("VAT Difference", VATDifference - "Prepmt VAT Diff. to Deduct");
                            TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                            IF "Prepayment %" < TempPrepmtPurchLine."Prepayment %" THEN
                                TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
                            OnBeforeTempPrepmtPurchLineModify(TempPrepmtPurchLine, TempPurchLine, PurchHeader, CompleteFunctionality);
                            TempPrepmtPurchLine.MODIFY;
                        END ELSE BEGIN
                            TempPrepmtPurchLine.INIT;
                            TempPrepmtPurchLine."Document Type" := PurchHeader."Document Type";
                            TempPrepmtPurchLine."Document No." := PurchHeader."No.";
                            TempPrepmtPurchLine."Line No." := 0;
                            TempPrepmtPurchLine."System-Created Entry" := TRUE;
                            IF CompleteFunctionality THEN
                                TempPrepmtPurchLine.VALIDATE(Type, TempPrepmtPurchLine.Type::"G/L Account")
                            ELSE
                                TempPrepmtPurchLine.Type := TempPrepmtPurchLine.Type::"G/L Account";
                            TempPrepmtPurchLine.VALIDATE("No.", GenPostingSetup."Purch. Prepayments Account");
                            TempPrepmtPurchLine.VALIDATE(Quantity, -1);
                            TempPrepmtPurchLine."Qty. to Receive" := TempPrepmtPurchLine.Quantity;
                            TempPrepmtPurchLine."Qty. to Invoice" := TempPrepmtPurchLine.Quantity;
                            PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(PurchHeader, TempPurchLine, NextLineNo, 0);
                            TempPrepmtPurchLine.VALIDATE("Direct Unit Cost", "Prepmt Amt to Deduct");
                            TempPrepmtPurchLine.VALIDATE("VAT Difference", -"Prepmt VAT Diff. to Deduct");
                            TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                            TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
                            TempPrepmtPurchLine."Prepayment Line" := TRUE;
                            TempPrepmtPurchLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            TempPrepmtPurchLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            TempPrepmtPurchLine."Dimension Set ID" := "Dimension Set ID";
                            TempPrepmtPurchLine."Job No." := "Job No.";
                            TempPrepmtPurchLine."Job Task No." := "Job Task No.";
                            TempPrepmtPurchLine."Job Line Type" := "Job Line Type";
                            TempPrepmtPurchLine."Line No." := NextLineNo;
                            NextLineNo := NextLineNo + 10000;
                            OnBeforeTempPrepmtPurchLineInsert(TempPrepmtPurchLine, TempPurchLine, PurchHeader, CompleteFunctionality);
                            TempPrepmtPurchLine.INSERT;

                            TransferExtText.PrepmtGetAnyExtText(
                              TempPrepmtPurchLine."No.", DATABASE::"Purch. Inv. Line",
                              PurchHeader."Document Date", PurchHeader."Language Code", TempExtTextLine);
                            IF TempExtTextLine.FIND('-') THEN
                                REPEAT
                                    TempPrepmtPurchLine.INIT;
                                    TempPrepmtPurchLine.Description := TempExtTextLine.Text;
                                    TempPrepmtPurchLine."System-Created Entry" := TRUE;
                                    TempPrepmtPurchLine."Prepayment Line" := TRUE;
                                    TempPrepmtPurchLine."Line No." := NextLineNo;
                                    NextLineNo := NextLineNo + 10000;
                                    TempPrepmtPurchLine.INSERT;
                                UNTIL TempExtTextLine.NEXT = 0;
                        END;
                    END;
                UNTIL NEXT = 0
            END;
        END;
        DividePrepmtAmountLCY(TempPrepmtPurchLine, PurchHeader);
        IF TempPrepmtPurchLine.FINDSET THEN
            REPEAT
                TempPurchLineGlobal := TempPrepmtPurchLine;
                TempPurchLineGlobal.INSERT;
            UNTIL TempPrepmtPurchLine.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertedPrepmtVATBaseToDeduct(PurchHeader: Record 38; PurchLine: Record 39; PrepmtLineNo: Integer; TotalPrepmtAmtToDeduct: Decimal): Decimal;
    VAR
        PrepmtVATBaseToDeduct: Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            IF PurchHeader."Prices Including VAT" THEN
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
        WITH TempPrepmtDeductLCYPurchLine DO BEGIN
            TempPrepmtDeductLCYPurchLine := PurchLine;
            IF "Document Type" = "Document Type"::Order THEN
                "Qty. to Invoice" := GetQtyToInvoice(PurchLine, PurchHeader.Receive)
            ELSE
                GetLineDataFromOrder(TempPrepmtDeductLCYPurchLine);
            IF ("Prepmt Amt to Deduct" = 0) OR ("Document Type" = "Document Type"::Invoice) THEN
                CalcPrepaymentToDeduct;
            "Line Amount" := GetLineAmountToHandleInclPrepmt("Qty. to Invoice");
            "Attached to Line No." := PrepmtLineNo;
            "VAT Base Amount" := PrepmtVATBaseToDeduct;
            INSERT;
        END;

        OnAfterInsertedPrepmtVATBaseToDeduct(
          PurchHeader, PurchLine, PrepmtLineNo, TotalPrepmtAmtToDeduct, TempPrepmtDeductLCYPurchLine, PrepmtVATBaseToDeduct);

        EXIT(PrepmtVATBaseToDeduct);
    END;

    LOCAL PROCEDURE DividePrepmtAmountLCY(VAR PrepmtPurchLine: Record 39; PurchHeader: Record 38);
    VAR
        CurrExchRate: Record 330;
        ActualCurrencyFactor: Decimal;
    BEGIN
        WITH PrepmtPurchLine DO BEGIN
            RESET;
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    IF PurchHeader."Currency Code" <> '' THEN
                        ActualCurrencyFactor :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              PurchHeader."Posting Date",
                              PurchHeader."Currency Code",
                              "Prepmt Amt to Deduct",
                              PurchHeader."Currency Factor")) /
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
        WITH TempPrepmtDeductLCYPurchLine DO BEGIN
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

    LOCAL PROCEDURE AdjustPrepmtAmountLCY(PurchHeader: Record 38; VAR PrepmtPurchLine: Record 39);
    VAR
        PurchLine: Record 39;
        PurchInvoiceLine: Record 39;
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: ARRAY[2] OF Decimal;
        TotalPrepmtAmount: ARRAY[2] OF Decimal;
        FinalInvoice: Boolean;
        PricesInclVATRoundingAmount: ARRAY[2] OF Decimal;
    BEGIN
        IF PrepmtPurchLine."Prepayment Line" THEN BEGIN
            PrepmtVATPart :=
              (PrepmtPurchLine."Amount Including VAT" - PrepmtPurchLine.Amount) / PrepmtPurchLine."Direct Unit Cost";

            WITH TempPrepmtDeductLCYPurchLine DO BEGIN
                RESET;
                SETRANGE("Attached to Line No.", PrepmtPurchLine."Line No.");
                IF FINDSET(TRUE) THEN BEGIN
                    FinalInvoice := IsFinalInvoice;
                    REPEAT
                        PurchLine := TempPrepmtDeductLCYPurchLine;
                        PurchLine.FIND;
                        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                            PurchInvoiceLine := PurchLine;
                            GetPurchOrderLine(PurchLine, PurchInvoiceLine);
                            PurchLine."Qty. to Invoice" := PurchInvoiceLine."Qty. to Invoice";
                        END;
                        IF PurchLine."Qty. to Invoice" <> "Qty. to Invoice" THEN
                            PurchLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(PurchLine, PurchHeader.Receive);
                        DeductionFactor :=
                          PurchLine."Prepmt Amt to Deduct" /
                          (PurchLine."Prepmt. Amt. Inv." - PurchLine."Prepmt Amt Deducted");

                        "Prepmt. VAT Amount Inv. (LCY)" :=
                          -CalcRoundedAmount(PurchLine."Prepmt Amt to Deduct" * PrepmtVATPart, PrepmtVATAmtRemainder);
                        IF ("Prepayment %" <> 100) OR IsFinalInvoice OR ("Currency Code" <> '') THEN
                            CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYPurchLine, PurchLine, DeductionFactor, TotalRoundingAmount);
                        MODIFY;

                        IF PurchHeader."Prices Including VAT" THEN
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

            UpdatePrepmtPurchLineWithRounding(
              PrepmtPurchLine, TotalRoundingAmount, TotalPrepmtAmount,
              FinalInvoice, PricesInclVATRoundingAmount);
        END;
    END;

    LOCAL PROCEDURE CalcPrepmtAmtToDeduct(PurchLine: Record 39; Receive: Boolean): Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            "Qty. to Invoice" := GetQtyToInvoice(PurchLine, Receive);
            CalcPrepaymentToDeduct;
            EXIT("Prepmt Amt to Deduct");
        END;
    END;

    LOCAL PROCEDURE GetQtyToInvoice(PurchLine: Record 39; Receive: Boolean): Decimal;
    VAR
        AllowedQtyToInvoice: Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            AllowedQtyToInvoice := "Qty. Rcd. Not Invoiced";
            IF Receive THEN
                AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Receive";
            IF "Qty. to Invoice" > AllowedQtyToInvoice THEN
                EXIT(AllowedQtyToInvoice);
            EXIT("Qty. to Invoice");
        END;
    END;

    LOCAL PROCEDURE GetLineDataFromOrder(VAR PurchLine: Record 39);
    VAR
        PurchRcptLine: Record 121;
        PurchOrderLine: Record 39;
    BEGIN
        WITH PurchLine DO BEGIN
            PurchRcptLine.GET("Receipt No.", "Receipt Line No.");
            PurchOrderLine.GET("Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");

            Quantity := PurchOrderLine.Quantity;
            "Qty. Rcd. Not Invoiced" := PurchOrderLine."Qty. Rcd. Not Invoiced";
            "Quantity Invoiced" := PurchOrderLine."Quantity Invoiced";
            "Prepmt Amt Deducted" := PurchOrderLine."Prepmt Amt Deducted";
            "Prepmt. Amt. Inv." := PurchOrderLine."Prepmt. Amt. Inv.";
            "Line Discount Amount" := PurchOrderLine."Line Discount Amount";
        END;
    END;

    LOCAL PROCEDURE CalcPrepmtRoundingAmounts(VAR PrepmtPurchLineBuf: Record 39; PurchLine: Record 39; DeductionFactor: Decimal; VAR TotalRoundingAmount: ARRAY[2] OF Decimal);
    VAR
        RoundingAmount: ARRAY[2] OF Decimal;
    BEGIN
        WITH PrepmtPurchLineBuf DO BEGIN
            IF "VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT" THEN BEGIN
                RoundingAmount[1] :=
                  "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. Amount Inv. (LCY)");
                "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
                TotalRoundingAmount[1] += RoundingAmount[1];
            END;
            RoundingAmount[2] :=
              "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. VAT Amount Inv. (LCY)");
            "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
            TotalRoundingAmount[2] += RoundingAmount[2];
        END;
    END;

    LOCAL PROCEDURE UpdatePrepmtPurchLineWithRounding(VAR PrepmtPurchLine: Record 39; TotalRoundingAmount: ARRAY[2] OF Decimal; TotalPrepmtAmount: ARRAY[2] OF Decimal; FinalInvoice: Boolean; PricesInclVATRoundingAmount: ARRAY[2] OF Decimal);
    VAR
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
        AmountRoundingPrecision: Decimal;
    BEGIN
        OnBeforeUpdatePrepmtPurchLineWithRounding(
          PrepmtPurchLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice, PricesInclVATRoundingAmount,
          TotalPurchLine, TotalPurchLineLCY);

        WITH PrepmtPurchLine DO BEGIN
            NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
            IF "Prepayment %" = 100 THEN
                TotalRoundingAmount[1] -= "Amount Including VAT" + NewAmountIncludingVAT;
            AmountRoundingPrecision :=
              GetAmountRoundingPrecisionInLCY("Document Type", "Document No.", "Currency Code");//enum to option

            IF (ABS(TotalRoundingAmount[1]) <= AmountRoundingPrecision) AND
               (ABS(TotalRoundingAmount[2]) <= AmountRoundingPrecision)
            THEN BEGIN
                IF "Prepayment %" = 100 THEN
                    Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
                TotalRoundingAmount[1] := 0;
            END;
            "Prepmt. Amount Inv. (LCY)" := -TotalRoundingAmount[1];
            Amount := -(TotalPrepmtAmount[1] + TotalRoundingAmount[1]);

            IF (PricesInclVATRoundingAmount[1] <> 0) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
                IF ("Prepayment %" = 100) AND FinalInvoice AND
                   (Amount - TotalPrepmtAmount[2] = "Amount Including VAT")
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

            "Prepmt. VAT Amount Inv. (LCY)" := -(TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt);
            NewAmountIncludingVAT := Amount - (TotalPrepmtAmount[2] + TotalRoundingAmount[2]);
            IF (PricesInclVATRoundingAmount[1] = 0) AND (PricesInclVATRoundingAmount[2] = 0) OR
               ("Currency Code" <> '') AND FinalInvoice
            THEN
                Increment(
                  TotalPurchLineLCY."Amount Including VAT",
                  -("Amount Including VAT" - NewAmountIncludingVAT + Prepmt100PctVATRoundingAmt));
            IF "Currency Code" = '' THEN
                TotalPurchLine."Amount Including VAT" := TotalPurchLineLCY."Amount Including VAT";
            "Amount Including VAT" := NewAmountIncludingVAT;

            IF FinalInvoice AND (TotalPurchLine.Amount = 0) AND (TotalPurchLine."Amount Including VAT" <> 0) AND
               (ABS(TotalPurchLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
            THEN BEGIN
                "Amount Including VAT" -= TotalPurchLineLCY."Amount Including VAT";
                TotalPurchLine."Amount Including VAT" := 0;
                TotalPurchLineLCY."Amount Including VAT" := 0;
            END;
        END;

        OnAfterUpdatePrepmtPurchLineWithRounding(
          PrepmtPurchLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice, PricesInclVATRoundingAmount,
          TotalPurchLine, TotalPurchLineLCY);
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

    LOCAL PROCEDURE GetPurchOrderLine(VAR PurchOrderLine: Record 39; PurchLine: Record 39);
    VAR
        PurchRcptLine: Record 121;
    BEGIN
        PurchRcptLine.GET(PurchLine."Receipt No.", PurchLine."Receipt Line No.");
        PurchOrderLine.GET(
          PurchOrderLine."Document Type"::Order,
          PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
        PurchOrderLine."Prepmt Amt to Deduct" := PurchLine."Prepmt Amt to Deduct";
    END;

    LOCAL PROCEDURE DecrementPrepmtAmtInvLCY(PurchLine: Record 39; VAR PrepmtAmountInvLCY: Decimal; VAR PrepmtVATAmountInvLCY: Decimal);
    BEGIN
        TempPrepmtDeductLCYPurchLine.RESET;
        TempPrepmtDeductLCYPurchLine := PurchLine;
        IF TempPrepmtDeductLCYPurchLine.FIND THEN BEGIN
            PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. Amount Inv. (LCY)";
            PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. VAT Amount Inv. (LCY)";
        END;
    END;

    LOCAL PROCEDURE AdjustFinalInvWith100PctPrepmt(VAR CombinedPurchLine: Record 39);
    VAR
        DiffToLineDiscAmt: Decimal;
    BEGIN
        WITH TempPrepmtDeductLCYPurchLine DO BEGIN
            RESET;
            SETRANGE("Prepayment %", 100);
            IF FINDSET(TRUE) THEN
                REPEAT
                    IF IsFinalInvoice THEN BEGIN
                        DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
                        IF "Document Type" = "Document Type"::Order THEN
                            DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
                        IF DiffToLineDiscAmt <> 0 THEN BEGIN
                            CombinedPurchLine.GET("Document Type", "Document No.", "Line No.");
                            "Line Discount Amount" := CombinedPurchLine."Line Discount Amount" - DiffToLineDiscAmt;
                            MODIFY;
                        END;
                    END;
                UNTIL NEXT = 0;
            RESET;
        END;
    END;

    LOCAL PROCEDURE GetPrepmtDiffToLineAmount(PurchLine: Record 39): Decimal;
    BEGIN
        WITH TempPrepmtDeductLCYPurchLine DO
            IF PurchLine."Prepayment %" = 100 THEN
                IF GET(PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.") THEN
                    EXIT("Prepmt Amt to Deduct" + "Inv. Discount Amount" - "Line Amount");
        EXIT(0);
    END;

    LOCAL PROCEDURE InsertICGenJnlLine(PurchHeader: Record 38; PurchLine: Record 39; VAR ICGenJnlLineNo: Integer);
    VAR
        ICGLAccount: Record 410;
        Cust: Record 18;
        Currency: Record 4;
        ICPartner: Record 413;
        CurrExchRate: Record 330;
        GenJnlLine: Record 81;
    BEGIN
        PurchHeader.TESTFIELD("Buy-from IC Partner Code", '');
        PurchHeader.TESTFIELD("Pay-to IC Partner Code", '');
        PurchLine.TESTFIELD("IC Partner Ref. Type", PurchLine."IC Partner Ref. Type"::"G/L Account");
        ICGLAccount.GET(PurchLine."IC Partner Reference");
        ICGenJnlLineNo := ICGenJnlLineNo + 1;

        WITH TempICGenJnlLine DO BEGIN
            InitNewLine(PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
              PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID",
              PurchHeader."Reason Code");
            "Line No." := ICGenJnlLineNo;

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType), GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PurchHeader."Posting No. Series");

            VALIDATE("Account Type", "Account Type"::"IC Partner");
            VALIDATE("Account No.", PurchLine."IC Partner Code");
            "Source Currency Code" := PurchHeader."Currency Code";
            "Source Currency Amount" := Amount;
            Correction := PurchHeader.Correction;
            "Country/Region Code" := PurchHeader."VAT Country/Region Code";
            "Source Type" := GenJnlLine."Source Type"::Vendor;
            "Source No." := PurchHeader."Pay-to Vendor No.";
            "Source Line No." := PurchLine."Line No.";
            VALIDATE("Bal. Account Type", "Bal. Account Type"::"G/L Account");
            VALIDATE("Bal. Account No.", PurchLine."No.");
            "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := PurchLine."Dimension Set ID";

            Cust.SETRANGE("IC Partner Code", PurchLine."IC Partner Code");
            IF Cust.FINDFIRST THEN BEGIN
                VALIDATE("Bal. Gen. Bus. Posting Group", Cust."Gen. Bus. Posting Group");
                VALIDATE("Bal. VAT Bus. Posting Group", Cust."VAT Bus. Posting Group");
            END;
            VALIDATE("Bal. VAT Prod. Posting Group", PurchLine."VAT Prod. Posting Group");
            "IC Partner Code" := PurchLine."IC Partner Code";
            "IC Partner G/L Acc. No." := PurchLine."IC Partner Reference";
            "IC Direction" := "IC Direction"::Outgoing;
            ICPartner.GET(PurchLine."IC Partner Code");
            IF ICPartner."Cost Distribution in LCY" AND (PurchLine."Currency Code" <> '') THEN BEGIN
                "Currency Code" := '';
                "Currency Factor" := 0;
                Currency.GET(PurchLine."Currency Code");
                IF PurchHeader.IsCreditDocType THEN
                    Amount :=
                      -ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          PurchHeader."Posting Date", PurchLine."Currency Code",
                          PurchLine.Amount, PurchHeader."Currency Factor"))
                ELSE
                    Amount :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          PurchHeader."Posting Date", PurchLine."Currency Code",
                          PurchLine.Amount, PurchHeader."Currency Factor"));
            END ELSE BEGIN
                Currency.InitRoundingPrecision;
                "Currency Code" := PurchHeader."Currency Code";
                "Currency Factor" := PurchHeader."Currency Factor";
                IF PurchHeader.IsCreditDocType THEN
                    Amount := -PurchLine.Amount
                ELSE
                    Amount := PurchLine.Amount;
            END;
            IF "Bal. VAT %" <> 0 THEN
                Amount := ROUND(Amount * (1 + "Bal. VAT %" / 100), Currency."Amount Rounding Precision");
            VALIDATE(Amount);
            INSERT;
        END;
    END;

    LOCAL PROCEDURE PostICGenJnl();
    VAR
        ICInboxOutboxMgt: Codeunit 427;
        ICOutboxExport: Codeunit 431;
        ICTransactionNo: Integer;
    BEGIN
        TempICGenJnlLine.RESET;
        IF TempICGenJnlLine.FIND('-') THEN
            REPEAT
                ICTransactionNo := ICInboxOutboxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine, FALSE);
                ICInboxOutboxMgt.CreateOutboxJnlLine(ICTransactionNo, 1, TempICGenJnlLine);
                ICOutboxExport.ProcessAutoSendOutboxTransactionNo(ICTransactionNo);
                IF TempICGenJnlLine.Amount <> 0 THEN
                    GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
            UNTIL TempICGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TestGetRcptPPmtAmtToDeduct();
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        TempRcvdPurchLine: Record 39 TEMPORARY;
        TempTotalPurchLine: Record 39 TEMPORARY;
        TempPurchRcptLine: Record 121 TEMPORARY;
        PurchRcptLine: Record 121;
        PurchaseOrderLine: Record 39;
        MaxAmtToDeduct: Decimal;
    BEGIN
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETFILTER(Quantity, '>0');
            SETFILTER("Qty. to Invoice", '>0');
            SETFILTER("Receipt No.", '<>%1', '');
            SETFILTER("Prepmt Amt to Deduct", '<>0');
            IF ISEMPTY THEN
                EXIT;

            SETRANGE("Prepmt Amt to Deduct");
            IF FINDSET THEN
                REPEAT
                    IF PurchRcptLine.GET("Receipt No.", "Receipt Line No.") THEN BEGIN
                        TempRcvdPurchLine := TempPurchLine;
                        TempRcvdPurchLine.INSERT;
                        TempPurchRcptLine := PurchRcptLine;
                        IF TempPurchRcptLine.INSERT THEN;

                        IF NOT TempTotalPurchLine.GET("Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.")
                        THEN BEGIN
                            TempTotalPurchLine.INIT;
                            TempTotalPurchLine."Document Type" := "Document Type"::Order;
                            TempTotalPurchLine."Document No." := PurchRcptLine."Order No.";
                            TempTotalPurchLine."Line No." := PurchRcptLine."Order Line No.";
                            TempTotalPurchLine.INSERT;
                        END;
                        TempTotalPurchLine."Qty. to Invoice" := TempTotalPurchLine."Qty. to Invoice" + "Qty. to Invoice";
                        TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + "Prepmt Amt to Deduct";
                        AdjustInvLineWith100PctPrepmt(TempPurchLine, TempTotalPurchLine);
                        TempTotalPurchLine.MODIFY;
                    END;
                UNTIL NEXT = 0;

            IF TempRcvdPurchLine.FINDSET THEN
                REPEAT
                    IF TempPurchRcptLine.GET(TempRcvdPurchLine."Receipt No.", TempRcvdPurchLine."Receipt Line No.") THEN
                        IF PurchaseOrderLine.GET(
                             TempRcvdPurchLine."Document Type"::Order, TempPurchRcptLine."Order No.", TempPurchRcptLine."Order Line No.")
                        THEN
                            IF TempTotalPurchLine.GET(
                                 TempRcvdPurchLine."Document Type"::Order, TempPurchRcptLine."Order No.", TempPurchRcptLine."Order Line No.")
                            THEN BEGIN
                                MaxAmtToDeduct := PurchaseOrderLine."Prepmt. Amt. Inv." - PurchaseOrderLine."Prepmt Amt Deducted";

                                IF TempTotalPurchLine."Prepmt Amt to Deduct" > MaxAmtToDeduct THEN
                                    ERROR(PrepAmountToDeductToBigErr, FIELDCAPTION("Prepmt Amt to Deduct"), MaxAmtToDeduct);

                                IF (TempTotalPurchLine."Qty. to Invoice" = PurchaseOrderLine.Quantity - PurchaseOrderLine."Quantity Invoiced") AND
                                   (TempTotalPurchLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                                THEN
                                    ERROR(PrepAmountToDeductToSmallErr, FIELDCAPTION("Prepmt Amt to Deduct"), MaxAmtToDeduct);
                            END;
                UNTIL TempRcvdPurchLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE AdjustInvLineWith100PctPrepmt(VAR PurchInvoiceLine: Record 39; VAR TempTotalPurchLine: Record 39 TEMPORARY);
    VAR
        PurchOrderLine: Record 39;
        DiffAmtToDeduct: Decimal;
    BEGIN
        IF PurchInvoiceLine."Prepayment %" = 100 THEN BEGIN
            PurchOrderLine := TempTotalPurchLine;
            PurchOrderLine.FIND;
            IF TempTotalPurchLine."Qty. to Invoice" = PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced" THEN BEGIN
                DiffAmtToDeduct :=
                  PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted" - TempTotalPurchLine."Prepmt Amt to Deduct";
                IF DiffAmtToDeduct <> 0 THEN BEGIN
                    PurchInvoiceLine."Prepmt Amt to Deduct" := PurchInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
                    PurchInvoiceLine."Line Amount" := PurchInvoiceLine."Prepmt Amt to Deduct";
                    PurchInvoiceLine."Line Discount Amount" := PurchInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
                    ModifyTempLine(PurchInvoiceLine);
                    TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
                END;
            END;
        END;
    END;

    //[External]
    PROCEDURE ArchiveUnpostedOrder(PurchHeader: Record 38);
    VAR
        PurchLine: Record 39;
        ArchiveManagement: Codeunit 5063;
    BEGIN
        IF NOT (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"]) THEN
            EXIT;

        PurchSetup.GET;
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) AND NOT PurchSetup."Archive Orders" THEN
            EXIT;
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order") AND NOT PurchSetup."Archive Return Orders" THEN
            EXIT;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        PurchLine.SETFILTER(Quantity, '<>0');
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN
            PurchLine.SETFILTER("Qty. to Receive", '<>0')
        ELSE
            PurchLine.SETFILTER("Return Qty. to Ship", '<>0');
        IF NOT PurchLine.ISEMPTY AND NOT PreviewMode THEN BEGIN
            RoundDeferralsForArchive(PurchHeader, PurchLine);
            ArchiveManagement.ArchPurchDocumentNoConfirm(PurchHeader);
        END;
    END;

    LOCAL PROCEDURE PostItemJnlLineJobConsumption(PurchHeader: Record 38; VAR PurchLine: Record 39; ItemJournalLine: Record 83; VAR TempPurchReservEntry: Record 337 TEMPORARY; QtyToBeInvoiced: Decimal; QtyToBeReceived: Decimal; VAR TempTrackingSpecification: Record 336 TEMPORARY; PurchItemLedgEntryNo: Integer);
    VAR
        ItemLedgEntry: Record 32;
        TempReservationEntry: Record 337 TEMPORARY;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnPostItemJnlLineJobConsumption(
          PurchHeader, PurchLine, ItemJournalLine, TempPurchReservEntry, QtyToBeInvoiced, QtyToBeReceived,
          TempTrackingSpecification, PurchItemLedgEntryNo, IsHandled);
        IF IsHandled THEN
            EXIT;

        WITH PurchLine DO
            IF "Job No." <> '' THEN BEGIN
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";

                //JAV 03/04/21: - QB 1.08.32 Esto no tiene sentido hacerlo ahora, se elimina
                //QBCodeunitPublisher.OnPostItemJnlLineJobConsumption(ItemJournalLine);

                Job.GET("Job No.");
                ItemJournalLine."Source No." := Job."Bill-to Customer No.";
                IF PurchHeader.Invoice THEN BEGIN
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETRANGE("Document Type", ItemLedgEntry."Document Type"::"Purchase Return Shipment");
                    ItemLedgEntry.SETRANGE("Document No.", PurchHeader."Last Return Shipment No.");
                    ItemLedgEntry.SETRANGE("Item No.", "No.");
                    ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::"Negative Adjmt.");
                    ItemLedgEntry.SETRANGE("Completely Invoiced", FALSE);
                    IF ItemLedgEntry.FINDFIRST THEN
                        ItemJournalLine."Item Shpt. Entry No." := ItemLedgEntry."Entry No.";
                END;
                ItemJournalLine."Source Type" := ItemJournalLine."Source Type"::Customer;
                ItemJournalLine."Discount Amount" := 0;

                GetAppliedItemLedgEntryNo(ItemJournalLine, "Quantity Received");

                IF QtyToBeReceived <> 0 THEN
                    CopyJobConsumptionReservation(
                      TempReservationEntry, TempPurchReservEntry, ItemJournalLine, TempTrackingSpecification,
                      PurchItemLedgEntryNo, IsNonInventoriableItem);

                ItemJnlPostLine.RunPostWithReservation(ItemJournalLine, TempReservationEntry);

                IF QtyToBeInvoiced <> 0 THEN BEGIN
                    "Qty. to Invoice" := QtyToBeInvoiced;
                    JobPostLine.PostJobOnPurchaseLine(PurchHeader, PurchInvHeader, PurchCrMemoHeader, PurchLine, SrcCode);
                END;
            END;
    END;

    LOCAL PROCEDURE CopyJobConsumptionReservation(VAR TempReservEntryJobCons: Record 337 TEMPORARY; VAR TempReservEntryPurchase: Record 337 TEMPORARY; VAR ItemJournalLine: Record 83; VAR TempTrackingSpecification: Record 336 TEMPORARY; PurchItemLedgEntryNo: Integer; IsNonInventoriableItem: Boolean);
    VAR
        NextReservationEntryNo: Integer;
    BEGIN
        // Item tracking for consumption
        NextReservationEntryNo := 1;
        IF TempReservEntryPurchase.FINDSET THEN
            REPEAT
                TempReservEntryJobCons := TempReservEntryPurchase;

                WITH TempReservEntryJobCons DO BEGIN
                    "Entry No." := NextReservationEntryNo;
                    Positive := NOT Positive;
                    "Quantity (Base)" := -"Quantity (Base)";
                    "Shipment Date" := "Expected Receipt Date";
                    "Expected Receipt Date" := 0D;
                    Quantity := -Quantity;
                    "Qty. to Handle (Base)" := -"Qty. to Handle (Base)";
                    "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
                    "Source Subtype" := ItemJournalLine."Entry Type".AsInteger();//enum to option
                    "Source Ref. No." := ItemJournalLine."Line No.";

                    IF NOT (ItemJournalLine.IsPurchaseReturn OR IsNonInventoriableItem) THEN BEGIN
                        TempTrackingSpecification.SETRANGE("Serial No.", "Serial No.");
                        TempTrackingSpecification.SETRANGE("Lot No.", "Lot No.");
                        IF TempTrackingSpecification.FINDFIRST THEN
                            "Appl.-to Item Entry" := TempTrackingSpecification."Item Ledger Entry No.";
                    END;

                    INSERT;
                END;

                NextReservationEntryNo := NextReservationEntryNo + 1;
            UNTIL TempReservEntryPurchase.NEXT = 0
        ELSE
            IF NOT (ItemJournalLine.IsPurchaseReturn OR IsNonInventoriableItem) THEN
                ItemJournalLine."Applies-to Entry" := PurchItemLedgEntryNo;
    END;

    LOCAL PROCEDURE GetAppliedItemLedgEntryNo(VAR ItemJournalLine: Record 83; QtyReceived: Decimal);
    VAR
        Item: Record 27;
        ItemLedgerEntry: Record 32;
    BEGIN
        Item.GET(ItemJournalLine."Item No.");
        IF Item.Type = Item.Type::Inventory THEN BEGIN
            IF QtyReceived > 0 THEN
                GetAppliedOutboundItemLedgEntryNo(ItemJournalLine)
            ELSE
                IF QtyReceived < 0 THEN
                    GetAppliedInboundItemLedgEntryNo(ItemJournalLine);
        END ELSE
            IF ItemJournalLine."Item Shpt. Entry No." > 0 THEN BEGIN
                ItemLedgerEntry.GET(ItemJournalLine."Item Shpt. Entry No.");
                ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type");
                ItemLedgerEntry.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                ItemLedgerEntry.SETRANGE("Document Line No.", ItemLedgerEntry."Document Line No.");
                ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
                ItemLedgerEntry.SETRANGE("Item No.", ItemLedgerEntry."Item No.");
                ItemLedgerEntry.SETRANGE("Invoiced Quantity", 0);
                IF ItemLedgerEntry.FINDFIRST THEN
                    ItemJournalLine."Item Shpt. Entry No." := ItemLedgerEntry."Entry No."
            END;
    END;

    LOCAL PROCEDURE GetAppliedOutboundItemLedgEntryNo(VAR ItemJnlLine: Record 83);
    VAR
        ItemApplicationEntry: Record 339;
    BEGIN
        WITH ItemApplicationEntry DO BEGIN
            SETRANGE("Inbound Item Entry No.", ItemJnlLine."Item Shpt. Entry No.");
            IF FINDLAST THEN
                ItemJnlLine."Item Shpt. Entry No." := "Outbound Item Entry No.";
        END
    END;

    LOCAL PROCEDURE GetAppliedInboundItemLedgEntryNo(VAR ItemJnlLine: Record 83);
    VAR
        ItemApplicationEntry: Record 339;
    BEGIN
        WITH ItemApplicationEntry DO BEGIN
            SETRANGE("Outbound Item Entry No.", ItemJnlLine."Item Shpt. Entry No.");
            IF FINDLAST THEN
                ItemJnlLine."Item Shpt. Entry No." := "Inbound Item Entry No.";
        END
    END;

    LOCAL PROCEDURE ItemLedgerEntryExist(PurchLine2: Record 39; ReceiveOrShip: Boolean): Boolean;
    VAR
        HasItemLedgerEntry: Boolean;
    BEGIN
        IF ReceiveOrShip THEN
            // item ledger entry will be created during posting in this transaction
            HasItemLedgerEntry :=
          ((PurchLine2."Qty. to Receive" + PurchLine2."Quantity Received") <> 0) OR
          ((PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced") <> 0) OR
          ((PurchLine2."Return Qty. to Ship" + PurchLine2."Return Qty. Shipped") <> 0)
        ELSE
            // item ledger entry must already exist
            HasItemLedgerEntry :=
          (PurchLine2."Quantity Received" <> 0) OR
          (PurchLine2."Return Qty. Shipped" <> 0);

        EXIT(HasItemLedgerEntry);
    END;

    LOCAL PROCEDURE LockTables(VAR PurchHeader: Record 38);
    VAR
        PurchLine: Record 39;
        SalesLine: Record 37;
    BEGIN
        OnBeforeLockTables(PurchHeader, PreviewMode, SuppressCommit);

        PurchLine.LOCKTABLE;
        SalesLine.LOCKTABLE;
        GetGLSetup;
        IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
            GLEntry.LOCKTABLE;
            IF GLEntry.FINDLAST THEN;
        END;
    END;

    LOCAL PROCEDURE MAX(number1: Integer; number2: Integer): Integer;
    BEGIN
        IF number1 > number2 THEN
            EXIT(number1);
        EXIT(number2);
    END;

    //[External]
    PROCEDURE CreateJobPurchLine(VAR JobPurchLine2: Record 39; PurchLine2: Record 39; PricesIncludingVAT: Boolean);
    BEGIN
        JobPurchLine2 := PurchLine2;
        IF PricesIncludingVAT THEN
            IF JobPurchLine2."VAT Calculation Type" = JobPurchLine2."VAT Calculation Type"::"Full VAT" THEN
                JobPurchLine2."Direct Unit Cost" := 0
            ELSE
                JobPurchLine2."Direct Unit Cost" := JobPurchLine2."Direct Unit Cost" / (1 + JobPurchLine2."VAT %" / 100);
    END;

    LOCAL PROCEDURE RevertWarehouseEntry(VAR TempWhseJnlLine: Record 7311 TEMPORARY; JobNo: Code[20]; PostJobConsumptionBeforePurch: Boolean): Boolean;
    BEGIN
        IF PostJobConsumptionBeforePurch OR (JobNo = '') OR PositiveWhseEntrycreated THEN
            EXIT(FALSE);
        WITH TempWhseJnlLine DO BEGIN
            "Entry Type" := "Entry Type"::"Negative Adjmt.";
            Quantity := -Quantity;
            "Qty. (Base)" := -"Qty. (Base)";
            "From Bin Code" := "To Bin Code";
            "To Bin Code" := '';
        END;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreatePositiveEntry(WhseJnlLine: Record 7311; JobNo: Code[20]; PostJobConsumptionBeforePurch: Boolean);
    BEGIN
        IF PostJobConsumptionBeforePurch OR (JobNo <> '') THEN BEGIN
            WITH WhseJnlLine DO BEGIN
                Quantity := -Quantity;
                "Qty. (Base)" := -"Qty. (Base)";
                "Qty. (Absolute)" := -"Qty. (Absolute)";
                "To Bin Code" := "From Bin Code";
                "From Bin Code" := '';
            END;
            WhseJnlPostLine.RUN(WhseJnlLine);
            PositiveWhseEntrycreated := TRUE;
        END;
    END;

    PROCEDURE TestPurchEfects(PurchHeader: Record 38; Vend: Record 23);
    VAR
        VendLedgEntry: Record 25;
        Text1100000: TextConst ENU = 'At least one document of %1 No. %2 is closed or in a Payment Order.', ESP = 'Al menos un documento de %1 n§ %2 est  cerrado o en una Orden de pago.';
        Text1100001: TextConst ENU = 'This will avoid the document to be settled.\', ESP = 'Esto evita que el documento sea liquidado.\';
        Text1100002: TextConst ENU = 'The posting process of %3 No. %4 will not settle any document.\', ESP = 'El registro de %3 n§ %4 no liquidar  ning£n documento.\';
        ShowError: Boolean;
        Text1100003: TextConst ENU = 'Please remove the lines for the Payment Order before posting.', ESP = 'Elimine las l¡neas para la Orden de pago antes del registro.';
    BEGIN
        ShowError := FALSE;
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
            VendLedgEntry.SETFILTER("Document Type", '%1|%2', VendLedgEntry."Document Type"::Invoice,
              VendLedgEntry."Document Type"::Bill);
            VendLedgEntry.SETFILTER("Document Situation", '<>%1', VendLedgEntry."Document Situation"::" ");
            VendLedgEntry.SETRANGE("Vendor No.", PurchHeader."Pay-to Vendor No.");
            VendLedgEntry.SETRANGE(Open, TRUE);

            IF VendLedgEntry.FIND('-') THEN
                REPEAT
                    IF VendLedgEntry."Document Situation" <> VendLedgEntry."Document Situation"::Cartera THEN
                        IF NOT ((VendLedgEntry."Document Situation" IN
                                 [VendLedgEntry."Document Situation"::"Closed Documents",
                                  VendLedgEntry."Document Situation"::"Closed BG/PO"]) AND
                                (VendLedgEntry."Document Status" = VendLedgEntry."Document Status"::Rejected))
                        THEN
                            ShowError := TRUE;
                UNTIL VendLedgEntry.NEXT = 0;

            IF ShowError THEN
                ERROR(Text1100000 +
                  Text1100001 +
                  Text1100002 +
                  Text1100003,
                  FORMAT(VendLedgEntry."Document Type"),
                  FORMAT(VendLedgEntry."Document No."),
                  FORMAT(PurchHeader."Document Type"),
                  FORMAT(PurchHeader."No."));
        END;
    END;

    LOCAL PROCEDURE UpdateIncomingDocument(IncomingDocNo: Integer; PostingDate: Date; GenJnlLineDocNo: Code[20]);
    VAR
        IncomingDocument: Record 130;
    BEGIN
        IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo, PostingDate, GenJnlLineDocNo);
    END;

    LOCAL PROCEDURE CheckItemCharge(ItemChargeAssignmentPurch: Record 5805);
    VAR
        PurchLineForCharge: Record 39;
    BEGIN
        WITH ItemChargeAssignmentPurch DO
            CASE "Applies-to Doc. Type" OF
                "Applies-to Doc. Type"::Order,
              "Applies-to Doc. Type"::Invoice:
                    IF PurchLineForCharge.GET("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.") THEN
                        IF (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Qty. Received (Base)") AND
                           (PurchLineForCharge."Qty. Rcd. Not Invoiced (Base)" = 0)
                        THEN
                            ERROR(ReassignItemChargeErr);
                "Applies-to Doc. Type"::"Return Order",
              "Applies-to Doc. Type"::"Credit Memo":
                    IF PurchLineForCharge.GET("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.") THEN
                        IF (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Return Qty. Shipped (Base)") AND
                           (PurchLineForCharge."Ret. Qty. Shpd Not Invd.(Base)" = 0)
                        THEN
                            ERROR(ReassignItemChargeErr);
            END;
    END;

    //[External]
    PROCEDURE InitProgressWindow(PurchHeader: Record 38);
    BEGIN
        IF PurchHeader.Invoice THEN
            Window.OPEN(
              '#1#################################\\' +
              PostingLinesMsg +
              PostingPurchasesAndVATMsg +
              PostingVendorsMsg +
              Text1100102 +
              Text1100103)
        ELSE
            Window.OPEN(
              '#1############################\\' +
              PostingLines2Msg);

        Window.UPDATE(1, STRSUBSTNO('%1 %2', PurchHeader."Document Type", PurchHeader."No."));
    END;


    LOCAL PROCEDURE UpdateInvoicedQtyOnPurchRcptLine(VAR PurchRcptLine: Record 121; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
        OnBeforeUpdateInvoicedQtyOnPurchRcptLine(PurchRcptLine, QtyToBeInvoiced, QtyToBeInvoicedBase, SuppressCommit);
        WITH PurchRcptLine DO BEGIN
            "Quantity Invoiced" := "Quantity Invoiced" + QtyToBeInvoiced;
            "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
            "Qty. Rcd. Not Invoiced" := Quantity - "Quantity Invoiced";
            MODIFY;
        END;
    END;

    LOCAL PROCEDURE UpdateInvoicedQtyOnReturnShptLine(VAR ReturnShptLine: Record 6651; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
        WITH ReturnShptLine DO BEGIN
            "Quantity Invoiced" := "Quantity Invoiced" - QtyToBeInvoiced;
            "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
            "Return Qty. Shipped Not Invd." := Quantity - "Quantity Invoiced";
            MODIFY;
        END;
    END;

    LOCAL PROCEDURE UpdateQtyPerUnitOfMeasure(VAR PurchLine: Record 39);
    VAR
        ItemUnitOfMeasure: Record 5404;
    BEGIN
        IF PurchLine."Qty. per Unit of Measure" = 0 THEN
            IF (PurchLine.Type = PurchLine.Type::Item) AND
               (PurchLine."Unit of Measure Code" <> '') AND
               ItemUnitOfMeasure.GET(PurchLine."No.", PurchLine."Unit of Measure Code")
            THEN
                PurchLine."Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure"
            ELSE
                PurchLine."Qty. per Unit of Measure" := 1;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForReceipt(VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; TrackingSpecificationExists: Boolean; PurchLine: Record 39; PurchRcptLine: Record 121; InvoicingTrackingSpecification: Record 336);
    BEGIN
        IF PurchLine."Qty. to Invoice" * PurchRcptLine.Quantity < 0 THEN
            PurchLine.FIELDERROR("Qty. to Invoice", ReceiptSameSignErr);
        IF TrackingSpecificationExists THEN BEGIN
            QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        END ELSE BEGIN
            QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Qty. to Receive";
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Qty. to Receive (Base)";
        END;
        IF ABS(QtyToBeInvoiced) > ABS(PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced") THEN BEGIN
            QtyToBeInvoiced := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
            QtyToBeInvoicedBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
        END;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForReturnShipment(VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; TrackingSpecificationExists: Boolean; PurchLine: Record 39; ReturnShipmentLine: Record 6651; InvoicingTrackingSpecification: Record 336);
    BEGIN
        IF PurchLine."Qty. to Invoice" * ReturnShipmentLine.Quantity > 0 THEN
            PurchLine.FIELDERROR("Qty. to Invoice", ReturnShipmentSamesSignErr);
        IF TrackingSpecificationExists THEN BEGIN
            QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
            QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
        END ELSE BEGIN
            QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Return Qty. to Ship";
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Return Qty. to Ship (Base)";
        END;
        IF ABS(QtyToBeInvoiced) > ABS(ReturnShipmentLine.Quantity - ReturnShipmentLine."Quantity Invoiced") THEN BEGIN
            QtyToBeInvoiced := ReturnShipmentLine."Quantity Invoiced" - ReturnShipmentLine.Quantity;
            QtyToBeInvoicedBase := ReturnShipmentLine."Qty. Invoiced (Base)" - ReturnShipmentLine."Quantity (Base)";
        END;
    END;

    LOCAL PROCEDURE UpdateRemainingQtyToBeInvoiced(VAR RemQtyToInvoiceCurrLine: Decimal; VAR RemQtyToInvoiceCurrLineBase: Decimal; PurchRcptLine: Record 121);
    BEGIN
        RemQtyToInvoiceCurrLine := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
        RemQtyToInvoiceCurrLineBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
        IF RemQtyToInvoiceCurrLine > RemQtyToBeInvoiced THEN BEGIN
            RemQtyToInvoiceCurrLine := RemQtyToBeInvoiced;
            RemQtyToInvoiceCurrLineBase := RemQtyToBeInvoicedBase;
        END;
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

    LOCAL PROCEDURE CheckItemReservDisruption(PurchLine: Record 39);
    VAR
        Item: Record 27;
        ConfirmManagement: Codeunit 50206;
        AvailableQty: Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            IF NOT IsCreditDocType OR (Type <> Type::Item) OR NOT ("Return Qty. to Ship (Base)" > 0) THEN
                EXIT;

            IF Nonstock OR "Special Order" OR "Drop Shipment" OR IsNonInventoriableItem OR
               TempSKU.GET("Location Code", "No.", "Variant Code") // Warn against item
            THEN
                EXIT;

            Item.GET("No.");
            Item.SETFILTER("Location Filter", "Location Code");
            Item.SETFILTER("Variant Filter", "Variant Code");
            Item.CALCFIELDS("Reserved Qty. on Inventory", "Net Change");
            CALCFIELDS("Reserved Qty. (Base)");
            AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - ABS("Reserved Qty. (Base)"));

            IF (Item."Reserved Qty. on Inventory" > 0) AND
               (AvailableQty < "Return Qty. to Ship (Base)") AND
               (Item."Reserved Qty. on Inventory" > ABS("Reserved Qty. (Base)"))
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

    LOCAL PROCEDURE UpdatePurchLineDimSetIDFromAppliedEntry(VAR PurchLineToPost: Record 39; PurchLine: Record 39);
    VAR
        ItemLedgEntry: Record 32;
        DimensionMgt: Codeunit 408;
        DimSetID: ARRAY[10] OF Integer;
    BEGIN
        DimSetID[1] := PurchLine."Dimension Set ID";
        WITH PurchLineToPost DO BEGIN
            IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                ItemLedgEntry.GET("Appl.-to Item Entry");
                DimSetID[2] := ItemLedgEntry."Dimension Set ID";
            END;
            "Dimension Set ID" :=
              DimensionMgt.GetCombinedDimensionSetID(DimSetID, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        END;
    END;

    LOCAL PROCEDURE CheckCertificateOfSupplyStatus(ReturnShptHeader: Record 6650; ReturnShptLine: Record 6651);
    VAR
        CertificateOfSupply: Record 780;
        VATPostingSetup: Record 325;
    BEGIN
        IF ReturnShptLine.Quantity <> 0 THEN
            IF VATPostingSetup.GET(ReturnShptHeader."VAT Bus. Posting Group", ReturnShptLine."VAT Prod. Posting Group") AND
               VATPostingSetup."Certificate of Supply Required"
            THEN BEGIN
                CertificateOfSupply.InitFromPurchase(ReturnShptHeader);
                CertificateOfSupply.SetRequired(ReturnShptHeader."No.")
            END;
    END;

    LOCAL PROCEDURE CheckSalesCertificateOfSupplyStatus(SalesShptHeader: Record 110; SalesShptLine: Record 111);
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

    LOCAL PROCEDURE InsertPostedHeaders(VAR PurchHeader: Record 38);
    VAR
        SalesShptLine: Record 111;
        PurchRcptLine: Record 121;
        GenJnlLine: Record 81;
    BEGIN
        WITH PurchHeader DO BEGIN
            // Insert receipt header
            IF Receive THEN
                IF ("Document Type" = "Document Type"::Order) OR
                   (("Document Type" = "Document Type"::Invoice) AND PurchSetup."Receipt on Invoice")
                THEN BEGIN
                    IF DropShipOrder THEN BEGIN
                        PurchRcptHeader.LOCKTABLE;
                        PurchRcptLine.LOCKTABLE;
                        SalesShptHeader.LOCKTABLE;
                        SalesShptLine.LOCKTABLE;
                    END;
                    InsertReceiptHeader(PurchHeader, PurchRcptHeader);
                    ServItemMgt.CopyReservation(PurchHeader);
                END;

            // Insert return shipment header
            IF Ship THEN
                IF ("Document Type" = "Document Type"::"Return Order") OR
                   (("Document Type" = "Document Type"::"Credit Memo") AND PurchSetup."Return Shipment on Credit Memo")
                THEN
                    InsertReturnShipmentHeader(PurchHeader, ReturnShptHeader);

            // Insert invoice header or credit memo header
            IF Invoice THEN
                IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
                    InsertInvoiceHeader(PurchHeader, PurchInvHeader);
                    GenJnlLineDocType := GenJnlLine."Document Type"::Invoice.AsInteger();
                    GenJnlLineDocNo := PurchInvHeader."No.";
                    GenJnlLineExtDocNo := "Vendor Invoice No.";
                END ELSE BEGIN // Credit Memo
                    InsertCrMemoHeader(PurchHeader, PurchCrMemoHeader);
                    GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo".AsInteger();
                    GenJnlLineDocNo := PurchCrMemoHeader."No.";
                    GenJnlLineExtDocNo := "Vendor Cr. Memo No.";
                END;
        END;

        OnAfterInsertPostedHeaders(PurchHeader, PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader, ReturnShptHeader);
    END;

    LOCAL PROCEDURE InsertReceiptHeader(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120);
    VAR
        PurchCommentLine: Record 43;
        RecordLinkManagement: Codeunit 447;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeInsertReceiptHeader(PurchHeader, PurchRcptHeader, IsHandled, SuppressCommit);

        WITH PurchHeader DO BEGIN
            IF NOT IsHandled THEN BEGIN
                PurchRcptHeader.INIT;
                PurchRcptHeader.TRANSFERFIELDS(PurchHeader);
                PurchRcptHeader."No." := "Receiving No.";
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    PurchRcptHeader."Order No. Series" := "No. Series";
                    PurchRcptHeader."Order No." := "No.";
                END;
                PurchRcptHeader."No. Printed" := 0;
                PurchRcptHeader."Source Code" := SrcCode;
                PurchRcptHeader."User ID" := USERID;
                OnBeforePurchRcptHeaderInsert(PurchRcptHeader, PurchHeader, SuppressCommit);
                PurchRcptHeader.INSERT(TRUE);
                OnAfterPurchRcptHeaderInsert(PurchRcptHeader, PurchHeader, SuppressCommit);

                ApprovalsMgmt.PostApprovalEntries(RECORDID, PurchRcptHeader.RECORDID, PurchRcptHeader."No.");

                IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
                    PurchCommentLine.CopyComments(
                      "Document Type".AsInteger(), PurchCommentLine."Document Type"::Receipt.AsInteger(), "No.", PurchRcptHeader."No.");
                    RecordLinkManagement.CopyLinks(PurchHeader, PurchRcptHeader);
                END;
            END;

            IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader, WhseRcptHeader, "Receiving No.", "Posting Date");
            END;
            IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader, WhseShptHeader, "Receiving No.", "Posting Date");
            END;
        END;
    END;

    LOCAL PROCEDURE InsertReceiptLine(PurchRcptHeader: Record 120; PurchLine: Record 39; CostBaseAmount: Decimal);
    VAR
        PurchRcptLine: Record 121;
        WhseRcptLine: Record 7317;
        WhseShptLine: Record 7321;
    BEGIN
        PurchRcptLine.InitFromPurchLine(PurchRcptHeader, xPurchLine);
        PurchRcptLine."Quantity Invoiced" := RemQtyToBeInvoiced;
        PurchRcptLine."Qty. Invoiced (Base)" := RemQtyToBeInvoicedBase;
        PurchRcptLine."Qty. Rcd. Not Invoiced" := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";

        IF (PurchLine.Type = PurchLine.Type::Item) AND (PurchLine."Qty. to Receive" <> 0) THEN BEGIN
            IF WhseReceive THEN BEGIN
                WhseRcptLine.GetWhseRcptLine(
                  WhseRcptHeader."No.", DATABASE::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");//enum to option
                WhseRcptLine.TESTFIELD("Qty. to Receive", PurchRcptLine.Quantity);
                SaveTempWhseSplitSpec(PurchLine);
                WhsePostRcpt.CreatePostedRcptLine(
                  WhseRcptLine, PostedWhseRcptHeader, PostedWhseRcptLine, TempWhseSplitSpecification);
            END;
            IF WhseShip THEN BEGIN
                WhseShptLine.GetWhseShptLine(
                  WhseShptHeader."No.", DATABASE::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");//enum to option
                WhseShptLine.TESTFIELD("Qty. to Ship", -PurchRcptLine.Quantity);
                SaveTempWhseSplitSpec(PurchLine);
                WhsePostShpt.CreatePostedShptLine(
                  WhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);
            END;
            PurchRcptLine."Item Rcpt. Entry No." := InsertRcptEntryRelation(PurchRcptLine);
            PurchRcptLine."Item Charge Base Amount" := ROUND(CostBaseAmount / PurchLine.Quantity * PurchRcptLine.Quantity);
        END;
        OnBeforePurchRcptLineInsert(PurchRcptLine, PurchRcptHeader, PurchLine, SuppressCommit);
        PurchRcptLine.INSERT(TRUE);
        OnAfterPurchRcptLineInsert(
          PurchLine, PurchRcptLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit, PurchInvHeader);
    END;

    LOCAL PROCEDURE InsertReturnShipmentHeader(VAR PurchHeader: Record 38; VAR ReturnShptHeader: Record 6650);
    VAR
        PurchCommentLine: Record 43;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        WITH PurchHeader DO BEGIN
            ReturnShptHeader.INIT;
            ReturnShptHeader.TRANSFERFIELDS(PurchHeader);
            ReturnShptHeader."No." := "Return Shipment No.";
            IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                ReturnShptHeader."Return Order No. Series" := "No. Series";
                ReturnShptHeader."Return Order No." := "No.";
            END;
            ReturnShptHeader."No. Series" := "Return Shipment No. Series";
            ReturnShptHeader."No. Printed" := 0;
            ReturnShptHeader."Source Code" := SrcCode;
            ReturnShptHeader."User ID" := USERID;
            OnBeforeReturnShptHeaderInsert(ReturnShptHeader, PurchHeader, SuppressCommit);
            ReturnShptHeader.INSERT(TRUE);
            OnAfterReturnShptHeaderInsert(ReturnShptHeader, PurchHeader, SuppressCommit);

            ApprovalsMgmt.PostApprovalEntries(RECORDID, ReturnShptHeader.RECORDID, ReturnShptHeader."No.");

            IF PurchSetup."Copy Cmts Ret.Ord. to Ret.Shpt" THEN BEGIN
                PurchCommentLine.CopyComments(
                  "Document Type".AsInteger(), PurchCommentLine."Document Type"::"Posted Return Shipment".AsInteger(), "No.", ReturnShptHeader."No.");
                RecordLinkManagement.CopyLinks(PurchHeader, ReturnShptHeader);
            END;
            IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader, WhseShptHeader, "Return Shipment No.", "Posting Date");
            END;
            IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader, WhseRcptHeader, "Return Shipment No.", "Posting Date");
            END;
        END;
    END;

    LOCAL PROCEDURE InsertReturnShipmentLine(ReturnShptHeader: Record 6650; PurchLine: Record 39; CostBaseAmount: Decimal);
    VAR
        ReturnShptLine: Record 6651;
        WhseRcptLine: Record 7317;
        WhseShptLine: Record 7321;
    BEGIN
        ReturnShptLine.InitFromPurchLine(ReturnShptHeader, xPurchLine);
        ReturnShptLine."Quantity Invoiced" := -RemQtyToBeInvoiced;
        ReturnShptLine."Qty. Invoiced (Base)" := -RemQtyToBeInvoicedBase;
        ReturnShptLine."Return Qty. Shipped Not Invd." := ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";

        IF (PurchLine.Type = PurchLine.Type::Item) AND (PurchLine."Return Qty. to Ship" <> 0) THEN BEGIN
            IF WhseShip THEN BEGIN
                WhseShptLine.GetWhseShptLine(
                  WhseShptHeader."No.", DATABASE::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");//enum to option
                WhseShptLine.TESTFIELD("Qty. to Ship", ReturnShptLine.Quantity);
                SaveTempWhseSplitSpec(PurchLine);
                WhsePostShpt.CreatePostedShptLine(
                  WhseShptLine, PostedWhseShptHeader, PostedWhseShptLine, TempWhseSplitSpecification);
            END;
            IF WhseReceive THEN BEGIN
                WhseRcptLine.GetWhseRcptLine(
                  WhseRcptHeader."No.", DATABASE::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");//enum to option
                WhseRcptLine.TESTFIELD("Qty. to Receive", -ReturnShptLine.Quantity);
                SaveTempWhseSplitSpec(PurchLine);
                WhsePostRcpt.CreatePostedRcptLine(
                  WhseRcptLine, PostedWhseRcptHeader, PostedWhseRcptLine, TempWhseSplitSpecification);
            END;

            ReturnShptLine."Item Shpt. Entry No." := InsertReturnEntryRelation(ReturnShptLine);
            ReturnShptLine."Item Charge Base Amount" := ROUND(CostBaseAmount / PurchLine.Quantity * ReturnShptLine.Quantity);
        END;
        OnBeforeReturnShptLineInsert(ReturnShptLine, ReturnShptHeader, PurchLine, SuppressCommit);
        ReturnShptLine.INSERT(TRUE);
        OnAfterReturnShptLineInsert(
          ReturnShptLine, ReturnShptHeader, PurchLine, ItemLedgShptEntryNo, WhseShip, WhseReceive, SuppressCommit,
          TempWhseShptHeader, PurchCrMemoHeader);

        CheckCertificateOfSupplyStatus(ReturnShptHeader, ReturnShptLine);
    END;

    LOCAL PROCEDURE InsertInvoiceHeader(VAR PurchHeader: Record 38; VAR PurchInvHeader: Record 122);
    VAR
        PurchCommentLine: Record 43;
        PurchLine4: Record 39;
        NoSeriesMgt: Codeunit 396;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        WITH PurchHeader DO BEGIN
            PurchInvHeader.INIT;
            PurchInvHeader.TRANSFERFIELDS(PurchHeader);

            PurchInvHeader."No." := "Posting No.";
            IF "Document Type" = "Document Type"::Order THEN BEGIN
                PurchInvHeader."Pre-Assigned No. Series" := '';
                PurchInvHeader."Order No. Series" := "No. Series";
                PurchInvHeader."Order No." := "No.";
            END ELSE BEGIN
                IF "Posting No." = '' THEN
                    PurchInvHeader."No." := "No.";
                PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
                PurchInvHeader."Pre-Assigned No." := "No.";
            END;
            IF GUIALLOWED THEN
                Window.UPDATE(1, STRSUBSTNO(InvoiceNoMsg, "Document Type", "No.", PurchInvHeader."No."));
            PurchInvHeader."Creditor No." := "Creditor No.";
            PurchInvHeader."Payment Reference" := "Payment Reference";
            PurchInvHeader."Payment Method Code" := "Payment Method Code";
            PurchInvHeader."Source Code" := SrcCode;
            PurchInvHeader."User ID" := USERID;
            PurchInvHeader."No. Printed" := 0;

            PurchLine4.RESET;
            PurchLine4.SETRANGE("Document Type", "Document Type");
            PurchLine4.SETRANGE("Document No.", "No.");
            PurchLine4.SETRANGE("Sales Order Line No.");
            PurchLine4.SETRANGE("VAT Calculation Type", PurchLine4."VAT Calculation Type"::"Reverse Charge VAT");
            IF "Generate Autoinvoices" OR PurchLine4.FINDFIRST THEN BEGIN
                "Generate Autoinvoices" := TRUE;
                AutoDocNo := '';
                GLSetup.TESTFIELD("Autoinvoice Nos.");
                AutoDocNo := NoSeriesMgt.GetNextNo(GLSetup."Autoinvoice Nos.", "Posting Date", TRUE);
                PurchInvHeader."Autoinvoice No." := AutoDocNo;
                MODIFY;
            END;
            PurchLine4.SETRANGE("VAT Calculation Type");

            OnBeforePurchInvHeaderInsert(PurchInvHeader, PurchHeader, SuppressCommit);
            PurchInvHeader.INSERT(TRUE);
            OnAfterPurchInvHeaderInsert(PurchInvHeader, PurchHeader);

            ApprovalsMgmt.PostApprovalEntries(RECORDID, PurchInvHeader.RECORDID, PurchInvHeader."No.");
            IF PurchSetup."Copy Comments Order to Invoice" THEN BEGIN
                PurchCommentLine.CopyComments(
                  "Document Type".AsInteger(), PurchCommentLine."Document Type"::"Posted Invoice".AsInteger(), "No.", PurchInvHeader."No.");
                RecordLinkManagement.CopyLinks(PurchHeader, PurchInvHeader);
            END;
        END;
    END;

    LOCAL PROCEDURE InsertCrMemoHeader(VAR PurchHeader: Record 38; VAR PurchCrMemoHdr: Record 124);
    VAR
        PurchCommentLine: Record 43;
        PurchLine3: Record 39;
        NoSeriesMgt: Codeunit 396;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        WITH PurchHeader DO BEGIN
            PurchCrMemoHdr.INIT;
            PurchCrMemoHdr.TRANSFERFIELDS(PurchHeader);
            IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                PurchCrMemoHdr."No." := "Posting No.";
                PurchCrMemoHdr."Pre-Assigned No. Series" := '';
                PurchCrMemoHdr."Return Order No. Series" := "No. Series";
                PurchCrMemoHdr."Return Order No." := "No.";
                IF GUIALLOWED THEN
                    Window.UPDATE(1, STRSUBSTNO(CreditMemoNoMsg, "Document Type", "No.", PurchCrMemoHdr."No."));
            END ELSE BEGIN
                PurchCrMemoHdr."Pre-Assigned No. Series" := "No. Series";
                PurchCrMemoHdr."Pre-Assigned No." := "No.";
                IF "Posting No." <> '' THEN BEGIN
                    PurchCrMemoHdr."No." := "Posting No.";
                    IF GUIALLOWED THEN
                        Window.UPDATE(1, STRSUBSTNO(CreditMemoNoMsg, "Document Type", "No.", PurchCrMemoHdr."No."));
                END;
            END;
            PurchCrMemoHdr."Source Code" := SrcCode;
            PurchCrMemoHdr."User ID" := USERID;
            PurchCrMemoHdr."No. Printed" := 0;

            PurchLine3.RESET;
            PurchLine3.SETRANGE("Document Type", "Document Type");
            PurchLine3.SETRANGE("Document No.", "No.");
            PurchLine3.SETRANGE("Sales Order Line No.");
            PurchLine3.SETRANGE("VAT Calculation Type", PurchLine3."VAT Calculation Type"::"Reverse Charge VAT");
            IF "Generate Autocredit Memo" OR PurchLine3.FINDFIRST THEN BEGIN
                "Generate Autocredit Memo" := TRUE;
                AutoDocNo := '';
                GLSetup.TESTFIELD("Autocredit Memo Nos.");
                AutoDocNo := NoSeriesMgt.GetNextNo(GLSetup."Autocredit Memo Nos.", "Posting Date", TRUE);
                PurchCrMemoHdr."Autocredit Memo No." := AutoDocNo;
                MODIFY;
            END;
            PurchLine3.SETRANGE("VAT Calculation Type");

            OnBeforePurchCrMemoHeaderInsert(PurchCrMemoHdr, PurchHeader, SuppressCommit);
            PurchCrMemoHdr.INSERT(TRUE);
            OnAfterPurchCrMemoHeaderInsert(PurchCrMemoHdr, PurchHeader, SuppressCommit);

            ApprovalsMgmt.PostApprovalEntries(RECORDID, PurchCrMemoHdr.RECORDID, PurchCrMemoHdr."No.");

            IF PurchSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
                PurchCommentLine.CopyComments(
                  "Document Type".AsInteger(), PurchCommentLine."Document Type"::"Posted Credit Memo".AsInteger(), "No.", PurchCrMemoHdr."No.");
                RecordLinkManagement.CopyLinks(PurchHeader, PurchCrMemoHdr);
            END;
        END;
    END;

    LOCAL PROCEDURE InsertSalesShptHeader(SalesOrderHeader: Record 36; PurchHeader: Record 38; VAR SalesShptHeader: Record 110);
    BEGIN
        WITH SalesShptHeader DO BEGIN
            INIT;
            TRANSFERFIELDS(SalesOrderHeader);
            "No." := SalesOrderHeader."Shipping No.";
            "Order No." := SalesOrderHeader."No.";
            "Posting Date" := PurchHeader."Posting Date";
            "Document Date" := PurchHeader."Document Date";
            "No. Printed" := 0;
            OnBeforeSalesShptHeaderInsert(SalesShptHeader, SalesOrderHeader, SuppressCommit);
            INSERT(TRUE);
            OnAfterSalesShptHeaderInsert(SalesShptHeader, SalesOrderHeader, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE InsertSalesShptLine(SalesShptHeader: Record 110; SalesOrderLine: Record 37; DropShptPostBuffer: Record 223; VAR SalesShptLine: Record 111);
    BEGIN
        WITH SalesShptLine DO BEGIN
            INIT;
            TRANSFERFIELDS(SalesOrderLine);
            "Posting Date" := SalesShptHeader."Posting Date";
            "Document No." := SalesShptHeader."No.";
            Quantity := DropShptPostBuffer.Quantity;
            "Quantity (Base)" := DropShptPostBuffer."Quantity (Base)";
            "Quantity Invoiced" := 0;
            "Qty. Invoiced (Base)" := 0;
            "Order No." := SalesOrderLine."Document No.";
            "Order Line No." := SalesOrderLine."Line No.";
            "Qty. Shipped Not Invoiced" :=
              Quantity - "Quantity Invoiced";
            IF Quantity <> 0 THEN BEGIN
                "Item Shpt. Entry No." := DropShptPostBuffer."Item Shpt. Entry No.";
                "Item Charge Base Amount" := SalesOrderLine."Line Amount";
            END;
            OnBeforeSalesShptLineInsert(SalesShptLine, SalesShptHeader, SalesOrderLine, SuppressCommit);
            INSERT;
            OnAfterSalesShptLineInsert(SalesShptLine, SalesShptHeader, SalesOrderLine, SuppressCommit);
        END;
    END;

    LOCAL PROCEDURE GetSign(Value: Decimal): Integer;
    BEGIN
        IF Value > 0 THEN
            EXIT(1);

        EXIT(-1);
    END;

    LOCAL PROCEDURE CheckICDocumentDuplicatePosting(PurchHeader: Record 38);
    VAR
        PurchHeader2: Record 38;
        ICInboxPurchHeader: Record 436;
        PurchInvHeader: Record 122;
        ConfirmManagement: Codeunit 50206;
    BEGIN
        WITH PurchHeader DO BEGIN
            IF NOT Invoice THEN
                EXIT;
            IF "IC Direction" = "IC Direction"::Outgoing THEN BEGIN
                PurchInvHeader.SETRANGE("Your Reference", "No.");
                PurchInvHeader.SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
                PurchInvHeader.SETRANGE("Pay-to Vendor No.", "Pay-to Vendor No.");
                IF PurchInvHeader.FINDFIRST THEN
                    IF NOT ConfirmManagement.ConfirmProcess(
                         STRSUBSTNO(PostedInvoiceDuplicateQst, PurchInvHeader."No.", "No."), TRUE)
                    THEN
                        ERROR('');
            END;
            IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    PurchHeader2.SETRANGE("Document Type", "Document Type"::Invoice);
                    PurchHeader2.SETRANGE("Vendor Order No.", "Vendor Order No.");
                    IF PurchHeader2.FINDFIRST THEN
                        IF NOT ConfirmManagement.ConfirmProcess(
                             STRSUBSTNO(UnpostedInvoiceDuplicateQst, "No.", PurchHeader2."No."), TRUE)
                        THEN
                            ERROR('');
                    ICInboxPurchHeader.SETRANGE("Document Type", "Document Type"::Invoice);
                    ICInboxPurchHeader.SETRANGE("Vendor Order No.", "Vendor Order No.");
                    IF ICInboxPurchHeader.FINDFIRST THEN
                        IF NOT ConfirmManagement.ConfirmProcess(
                             STRSUBSTNO(InvoiceDuplicateInboxQst, "No.", ICInboxPurchHeader."No."), TRUE)
                        THEN
                            ERROR('');
                    PurchInvHeader.SETRANGE("Vendor Order No.", "Vendor Order No.");
                    IF PurchInvHeader.FINDFIRST THEN
                        IF NOT ConfirmManagement.ConfirmProcess(
                             STRSUBSTNO(PostedInvoiceDuplicateQst, PurchInvHeader."No.", "No."), TRUE)
                        THEN
                            ERROR('');
                END;
                IF ("Document Type" = "Document Type"::Invoice) AND ("Vendor Order No." <> '') THEN BEGIN
                    PurchHeader2.SETRANGE("Document Type", "Document Type"::Order);
                    PurchHeader2.SETRANGE("Vendor Order No.", "Vendor Order No.");
                    IF PurchHeader2.FINDFIRST THEN
                        IF NOT ConfirmManagement.ConfirmProcess(
                             STRSUBSTNO(OrderFromSameTransactionQst, PurchHeader2."No.", "No."), TRUE)
                        THEN
                            ERROR('');
                    ICInboxPurchHeader.SETRANGE("Document Type", "Document Type"::Order);
                    ICInboxPurchHeader.SETRANGE("Vendor Order No.", "Vendor Order No.");
                    IF ICInboxPurchHeader.FINDFIRST THEN
                        IF NOT ConfirmManagement.ConfirmProcess(
                             STRSUBSTNO(DocumentFromSameTransactionQst, "No.", ICInboxPurchHeader."No."), TRUE)
                        THEN
                            ERROR('');
                    PurchInvHeader.SETRANGE("Vendor Order No.", "Vendor Order No.");
                    IF PurchInvHeader.FINDFIRST THEN
                        IF NOT ConfirmManagement.ConfirmProcess(
                             STRSUBSTNO(PostedInvoiceFromSameTransactionQst, PurchInvHeader."No.", "No."), TRUE)
                        THEN
                            ERROR('');
                    IF "Your Reference" <> '' THEN BEGIN
                        PurchInvHeader.RESET;
                        PurchInvHeader.SETRANGE("Order No.", "Your Reference");
                        PurchInvHeader.SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
                        PurchInvHeader.SETRANGE("Pay-to Vendor No.", "Pay-to Vendor No.");
                        IF PurchInvHeader.FINDFIRST THEN
                            IF NOT ConfirmManagement.ConfirmProcess(
                                 STRSUBSTNO(PostedInvoiceFromSameTransactionQst, PurchInvHeader."No.", "No."), TRUE)
                            THEN
                                ERROR('');
                    END;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckICPartnerBlocked(PurchHeader: Record 38);
    VAR
        ICPartner: Record 413;
    BEGIN
        WITH PurchHeader DO BEGIN
            IF "Buy-from IC Partner Code" <> '' THEN
                IF ICPartner.GET("Buy-from IC Partner Code") THEN
                    ICPartner.TESTFIELD(Blocked, FALSE);
            IF "Pay-to IC Partner Code" <> '' THEN
                IF ICPartner.GET("Pay-to IC Partner Code") THEN
                    ICPartner.TESTFIELD(Blocked, FALSE);
        END;
    END;

    LOCAL PROCEDURE SendICDocument(VAR PurchHeader: Record 38; VAR ModifyHeader: Boolean);
    VAR
        ICInboxOutboxMgt: Codeunit 427;
    BEGIN
        WITH PurchHeader DO
            IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
               ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"])
            THEN BEGIN
                ICInboxOutboxMgt.SendPurchDoc(PurchHeader, TRUE);
                "IC Status" := "IC Status"::Pending;
                ModifyHeader := TRUE;
            END;
    END;

    LOCAL PROCEDURE UpdateHandledICInboxTransaction(PurchHeader: Record 38);
    VAR
        HandledICInboxTrans: Record 420;
        Vendor: Record 23;
    BEGIN
        WITH PurchHeader DO
            IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
                CASE "Document Type" OF
                    "Document Type"::Invoice:
                        HandledICInboxTrans.SETRANGE("Document No.", "Vendor Invoice No.");
                    "Document Type"::Order:
                        HandledICInboxTrans.SETRANGE("Document No.", "Vendor Order No.");
                    "Document Type"::"Credit Memo":
                        HandledICInboxTrans.SETRANGE("Document No.", "Vendor Cr. Memo No.");
                    "Document Type"::"Return Order":
                        HandledICInboxTrans.SETRANGE("Document No.", "Vendor Order No.");
                END;
                Vendor.GET("Buy-from Vendor No.");
                HandledICInboxTrans.SETRANGE("IC Partner Code", Vendor."IC Partner Code");
                HandledICInboxTrans.LOCKTABLE;
                IF HandledICInboxTrans.FINDFIRST THEN BEGIN
                    HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
                    HandledICInboxTrans.MODIFY;
                END;
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
            InvtAdjmt.SetJobUpdateProperties(FALSE);
            InvtAdjmt.MakeMultiLevelAdjmt;
        END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForReceive(PurchHeader: Record 38) Receive: Boolean;
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        PurchPost: codeunit 50105;
    BEGIN
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETFILTER(Quantity, '<>0');
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN
                SETFILTER("Qty. to Receive", '<>0');
            SETRANGE("Receipt No.", '');
            Receive := FINDFIRST;
            WhseReceive := TempWhseRcptHeader.FINDFIRST;
            WhseShip := TempWhseShptHeader.FINDFIRST;
            IF Receive THEN BEGIN
                CheckTrackingSpecification(PurchHeader, TempPurchLine);
                IF NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
                    PurchPost.CheckWarehouse(TempPurchLine);
            END;
            OnAfterCheckTrackingAndWarehouseForReceive(PurchHeader, Receive, SuppressCommit);
            EXIT(Receive);
        END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForShip(PurchHeader: Record 38) Ship: Boolean;
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        PurchPost: codeunit 50105;
    BEGIN
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETFILTER(Quantity, '<>0');
            SETFILTER("Return Qty. to Ship", '<>0');
            SETRANGE("Return Shipment No.", '');
            Ship := FINDFIRST;
            WhseReceive := TempWhseRcptHeader.FINDFIRST;
            WhseShip := TempWhseShptHeader.FINDFIRST;
            IF Ship THEN BEGIN
                CheckTrackingSpecification(PurchHeader, TempPurchLine);
                IF NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
                    PurchPost.CheckWarehouse(TempPurchLine);
            END;
            OnAfterCheckTrackingAndWarehouseForShip(PurchHeader, Ship, SuppressCommit);
            EXIT(Ship);
        END;
    END;

    LOCAL PROCEDURE CheckIfInvPutawayExists(PurchaseHeader: Record 38): Boolean;
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        WarehouseActivityLine: Record 5767;
    BEGIN
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETFILTER(Quantity, '<>0');
            IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN
                SETFILTER("Qty. to Receive", '<>0');
            SETRANGE("Receipt No.", '');
            IF ISEMPTY THEN
                EXIT(FALSE);
            FINDSET;
            REPEAT
                IF WarehouseActivityLine.ActivityExists(
                     DATABASE::"Purchase Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, //enum to option
                     WarehouseActivityLine."Activity Type"::"Invt. Put-away".AsInteger()) //enum to option
                THEN
                    EXIT(TRUE);
            UNTIL NEXT = 0;
            EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE CheckIfInvPickExists(): Boolean;
    VAR
        TempPurchLine: Record 39 TEMPORARY;
        WarehouseActivityLine: Record 5767;
    BEGIN
        WITH TempPurchLine DO BEGIN
            ResetTempLines(TempPurchLine);
            SETFILTER(Quantity, '<>0');
            SETFILTER("Return Qty. to Ship", '<>0');
            SETRANGE("Return Shipment No.", '');
            IF ISEMPTY THEN
                EXIT(FALSE);
            FINDSET;
            REPEAT
                IF WarehouseActivityLine.ActivityExists(
                     DATABASE::"Purchase Line", "Document Type".AsInteger(), "Document No.", "Line No.", 0, //enum to option
                     WarehouseActivityLine."Activity Type"::"Invt. Pick".AsInteger())//enum to option
                THEN
                    EXIT(TRUE);
            UNTIL NEXT = 0;
            EXIT(FALSE);
        END;
    END;

    LOCAL PROCEDURE CheckAssosOrderLines(PurchHeader: Record 38);
    VAR
        PurchLine: Record 39;
        SalesHeader: Record 36;
        SalesOrderLine: Record 37;
        TempSalesHeader: Record 36 TEMPORARY;
        TempSalesLine: Record 37 TEMPORARY;
        DimMgt: Codeunit 408;
        DimMgt2:codeunit 50361;
    BEGIN
        WITH PurchHeader DO BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", "Document Type");
            PurchLine.SETRANGE("Document No.", "No.");
            PurchLine.SETFILTER("Sales Order Line No.", '<>0');
            IF PurchLine.FINDSET THEN
                REPEAT
                    SalesOrderLine.GET(
                      SalesOrderLine."Document Type"::Order, PurchLine."Sales Order No.", PurchLine."Sales Order Line No.");
                    TempSalesLine := SalesOrderLine;
                    TempSalesLine.INSERT;
                    IF Invoice THEN BEGIN
                        IF Receive AND (PurchLine."Qty. to Invoice" <> 0) AND (PurchLine."Qty. to Receive" <> 0) THEN
                            ERROR(DropShipmentErr);
                        IF ABS(PurchLine."Quantity Received" - PurchLine."Quantity Invoiced") < ABS(PurchLine."Qty. to Invoice")
                        THEN BEGIN
                            PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                            PurchLine."Qty. to Invoice (Base)" := PurchLine."Qty. Received (Base)" - PurchLine."Qty. Invoiced (Base)";
                        END;
                        IF ABS(PurchLine.Quantity - (PurchLine."Qty. to Invoice" + PurchLine."Quantity Invoiced")) <
                           ABS(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
                        THEN
                            ERROR(CannotInvoiceBeforeAssosSalesOrderErr, PurchLine."Sales Order No.");
                    END;

                    TempSalesHeader."Document Type" := TempSalesHeader."Document Type"::Order;
                    TempSalesHeader."No." := PurchLine."Sales Order No.";
                    IF TempSalesHeader.INSERT THEN;
                UNTIL PurchLine.NEXT = 0;
        END;

        IF TempSalesHeader.FINDSET THEN
            REPEAT
                SalesHeader.GET(TempSalesHeader."Document Type"::Order, TempSalesHeader."No.");
                TempSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                DimMgt2.CheckSalesDim(SalesHeader, TempSalesLine);
            UNTIL TempSalesHeader.NEXT = 0;
    END;

    LOCAL PROCEDURE PostCombineSalesOrderShipment(VAR PurchHeader: Record 38; VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        SalesSetup: Record 311;
        SalesCommentLine: Record 44;
        SalesOrderHeader: Record 36;
        SalesOrderLine: Record 37;
        SalesShptLine: Record 111;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        ArchiveSalesOrders(TempDropShptPostBuffer);
        WITH PurchHeader DO
            IF TempDropShptPostBuffer.FINDSET THEN BEGIN
                SalesSetup.GET;
                REPEAT
                    SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order, TempDropShptPostBuffer."Order No.");
                    InsertSalesShptHeader(SalesOrderHeader, PurchHeader, SalesShptHeader);
                    ApprovalsMgmt.PostApprovalEntries(RECORDID, SalesShptHeader.RECORDID, SalesShptHeader."No.");
                    IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
                        SalesCommentLine.CopyComments(
                          SalesOrderHeader."Document Type".AsInteger(), SalesCommentLine."Document Type"::Shipment.AsInteger(),
                          SalesOrderHeader."No.", SalesShptHeader."No.");
                        RecordLinkManagement.CopyLinks(SalesOrderHeader, SalesShptHeader);
                    END;
                    TempDropShptPostBuffer.SETRANGE("Order No.", TempDropShptPostBuffer."Order No.");
                    REPEAT
                        SalesOrderLine.GET(
                          SalesOrderLine."Document Type"::Order,
                          TempDropShptPostBuffer."Order No.", TempDropShptPostBuffer."Order Line No.");
                        InsertSalesShptLine(SalesShptHeader, SalesOrderLine, TempDropShptPostBuffer, SalesShptLine);
                        CheckSalesCertificateOfSupplyStatus(SalesShptHeader, SalesShptLine);

                        SalesOrderLine."Qty. to Ship" := SalesShptLine.Quantity;
                        SalesOrderLine."Qty. to Ship (Base)" := SalesShptLine."Quantity (Base)";
                        ServItemMgt.CreateServItemOnSalesLineShpt(SalesOrderHeader, SalesOrderLine, SalesShptLine);
                        SalesPost.UpdateBlanketOrderLine(SalesOrderLine, TRUE, FALSE, FALSE);

                        SalesOrderLine.SETRANGE("Document Type", SalesOrderLine."Document Type"::Order);
                        SalesOrderLine.SETRANGE("Document No.", TempDropShptPostBuffer."Order No.");
                        SalesOrderLine.SETRANGE("Attached to Line No.", TempDropShptPostBuffer."Order Line No.");
                        SalesOrderLine.SETRANGE(Type, SalesOrderLine.Type::" ");
                        IF SalesOrderLine.FINDSET THEN
                            REPEAT
                                SalesShptLine.INIT;
                                SalesShptLine.TRANSFERFIELDS(SalesOrderLine);
                                SalesShptLine."Document No." := SalesShptHeader."No.";
                                SalesShptLine."Order No." := SalesOrderLine."Document No.";
                                SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
                                OnBeforeSalesShptLineInsert(SalesShptLine, SalesShptHeader, SalesOrderLine, SuppressCommit);
                                SalesShptLine.INSERT;
                                OnAfterSalesShptLineInsert(SalesShptLine, SalesShptHeader, SalesOrderLine, SuppressCommit);
                            UNTIL SalesOrderLine.NEXT = 0;

                    UNTIL TempDropShptPostBuffer.NEXT = 0;
                    TempDropShptPostBuffer.SETRANGE("Order No.");
                UNTIL TempDropShptPostBuffer.NEXT = 0;
            END;
    END;

    LOCAL PROCEDURE PostInvoicePostBufferLine(VAR PurchHeader: Record 38; InvoicePostBuffer: Record 55) GLEntryNo: Integer;
    VAR
        GenJnlLine: Record 81;
    BEGIN
        WITH GenJnlLine DO BEGIN
            InitNewLine(
              PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Description",
              InvoicePostBuffer."Global Dimension 1 Code", InvoicePostBuffer."Global Dimension 2 Code",
              InvoicePostBuffer."Dimension Set ID", PurchHeader."Reason Code");

            CopyDocumentFields(Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType), GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, '');
            CopyFromPurchHeader(PurchHeader);
            "Payment Terms Code" := PurchHeader."Payment Terms Code";
            "Payment Method Code" := PurchHeader."Payment Method Code";
            CopyFromInvoicePostBuffer(InvoicePostBuffer);

            IF (PurchHeader."Generate Autoinvoices" OR PurchHeader."Generate Autocredit Memo") AND
               (InvoicePostBuffer."VAT Calculation Type" = InvoicePostBuffer."VAT Calculation Type"::"Reverse Charge VAT")
            THEN BEGIN
                "Generate AutoInvoices" := TRUE;
                "AutoDoc. No." := AutoDocNo;
            END ELSE
                "Generate AutoInvoices" := FALSE;

            IF InvoicePostBuffer.Type <> InvoicePostBuffer.Type::"Prepmt. Exch. Rate Difference" THEN
                "Gen. Posting Type" := "Gen. Posting Type"::Purchase;
            IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
                CASE InvoicePostBuffer."FA Posting Type" OF
                    InvoicePostBuffer."FA Posting Type"::"Acquisition Cost":
                        "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
                    InvoicePostBuffer."FA Posting Type"::Maintenance:
                        "FA Posting Type" := "FA Posting Type"::Maintenance;
                    InvoicePostBuffer."FA Posting Type"::Appreciation:
                        "FA Posting Type" := "FA Posting Type"::Appreciation;
                END;
                CopyFromInvoicePostBufferFA(InvoicePostBuffer);
            END;

            OnBeforePostInvPostBuffer(GenJnlLine, InvoicePostBuffer, PurchHeader, GenJnlPostLine, PreviewMode, SuppressCommit);

            //JAV 16/06/22: - QB 1.10.50 Se cambia llamar la la funci�n OnRunGenJnlPostLinePurchPost de la CU 7207352 por el evento OnBeforePostInvPostBuffer que es mas apropiado
            //QBCodeunitPublisher.OnRunGenJnlPostLinePurchPost(GenJnlLine,InvoicePostBuffer);

            GLEntryNo := RunGenJnlPostLine(GenJnlLine);
            OnAfterPostInvPostBuffer(GenJnlLine, InvoicePostBuffer, PurchHeader, GLEntryNo, SuppressCommit, GenJnlPostLine);
        END;
    END;

    LOCAL PROCEDURE FindTempItemChargeAssgntPurch(PurchLineNo: Integer): Boolean;
    BEGIN
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntPurch.SETCURRENTKEY("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.", PurchLineNo);
        EXIT(TempItemChargeAssgntPurch.FINDSET);
    END;

    LOCAL PROCEDURE FillDeferralPostingBuffer(PurchHeader: Record 38; PurchLine: Record 39; InvoicePostBuffer: Record 49; RemainAmtToDefer: Decimal; RemainAmtToDeferACY: Decimal; DeferralAccount: Code[20]; PurchAccount: Code[20]);
    VAR
        DeferralTemplate: Record 1700;
    BEGIN
        IF PurchLine."Deferral Code" <> '' THEN BEGIN
            DeferralTemplate.GET(PurchLine."Deferral Code");

            IF TempDeferralHeader.GET(DeferralUtilities1.GetPurchDeferralDocType, '', '',
                 PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.")
            THEN BEGIN
                IF TempDeferralHeader."Amount to Defer" <> 0 THEN BEGIN
                    DeferralUtilities.FilterDeferralLines(
                      TempDeferralLine, DeferralUtilities1.GetPurchDeferralDocType, '', '',
                      PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");
                    // Remainder\Initial deferral pair
                    DeferralPostBuffer.PreparePurch(PurchLine, GenJnlLineDocNo);
                    DeferralPostBuffer."Posting Date" := PurchHeader."Posting Date";
                    DeferralPostBuffer.Description := PurchHeader."Posting Description";
                    DeferralPostBuffer."Period Description" := DeferralTemplate."Period Description";
                    DeferralPostBuffer."Deferral Line No." := InvDefLineNo;
                    DeferralPostBuffer.PrepareInitialPair(
                      InvoicePostBuffer, RemainAmtToDefer, RemainAmtToDeferACY, PurchAccount, DeferralAccount);
                    DeferralPostBuffer.Update(DeferralPostBuffer, InvoicePostBuffer);
                    IF (RemainAmtToDefer <> 0) OR (RemainAmtToDeferACY <> 0) THEN BEGIN
                        DeferralPostBuffer.PrepareRemainderPurchase(
                          PurchLine, RemainAmtToDefer, RemainAmtToDeferACY, PurchAccount, DeferralAccount, InvDefLineNo);
                        DeferralPostBuffer.Update(DeferralPostBuffer, InvoicePostBuffer);
                    END;

                    // Add the deferral lines for each period to the deferral posting buffer merging when they are the same
                    IF TempDeferralLine.FINDSET THEN
                        REPEAT
                            IF (TempDeferralLine."Amount (LCY)" <> 0) OR (TempDeferralLine.Amount <> 0) THEN BEGIN
                                DeferralPostBuffer.PreparePurch(PurchLine, GenJnlLineDocNo);
                                DeferralPostBuffer.InitFromDeferralLine(TempDeferralLine);
                                IF PurchLine.IsCreditDocType THEN
                                    DeferralPostBuffer.ReverseAmounts;
                                DeferralPostBuffer."G/L Account" := PurchAccount;
                                DeferralPostBuffer."Deferral Account" := DeferralAccount;
                                DeferralPostBuffer."Period Description" := DeferralTemplate."Period Description";
                                DeferralPostBuffer."Deferral Line No." := InvDefLineNo;
                                DeferralPostBuffer.Update(DeferralPostBuffer, InvoicePostBuffer);
                            END ELSE
                                ERROR(ZeroDeferralAmtErr, PurchLine."No.", PurchLine."Deferral Code");

                        UNTIL TempDeferralLine.NEXT = 0

                    ELSE
                        ERROR(NoDeferralScheduleErr, PurchLine."No.", PurchLine."Deferral Code");
                END ELSE
                    ERROR(NoDeferralScheduleErr, PurchLine."No.", PurchLine."Deferral Code")
            END ELSE
                ERROR(NoDeferralScheduleErr, PurchLine."No.", PurchLine."Deferral Code")
        END;
    END;

    LOCAL PROCEDURE RoundDeferralsForArchive(PurchHeader: Record 38; VAR PurchLine: Record 39);
    VAR
        ArchiveManagement: Codeunit 5063;
    BEGIN
        ArchiveManagement.RoundPurchaseDeferralsForArchive(PurchHeader, PurchLine);
    END;

    LOCAL PROCEDURE GetAmountsForDeferral(PurchLine: Record 39; VAR AmtToDefer: Decimal; VAR AmtToDeferACY: Decimal; VAR DeferralAccount: Code[20]);
    VAR
        DeferralTemplate: Record 1700;
    BEGIN
        IF PurchLine."Deferral Code" <> '' THEN BEGIN
            DeferralTemplate.GET(PurchLine."Deferral Code");
            DeferralTemplate.TESTFIELD("Deferral Account");
            DeferralAccount := DeferralTemplate."Deferral Account";

            IF TempDeferralHeader.GET(DeferralUtilities1.GetPurchDeferralDocType, '', '',
                 PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.")
            THEN BEGIN
                AmtToDeferACY := TempDeferralHeader."Amount to Defer";
                AmtToDefer := TempDeferralHeader."Amount to Defer (LCY)";
            END;

            IF PurchLine.IsCreditDocType THEN BEGIN
                AmtToDefer := -AmtToDefer;
                AmtToDeferACY := -AmtToDeferACY;
            END
        END ELSE BEGIN
            AmtToDefer := 0;
            AmtToDeferACY := 0;
            DeferralAccount := '';
        END;
    END;

    LOCAL PROCEDURE CheckMandatoryHeaderFields(VAR PurchHeader: Record 38);
    BEGIN
        PurchHeader.TESTFIELD("Document Type");
        PurchHeader.TESTFIELD("Buy-from Vendor No.");
        PurchHeader.TESTFIELD("Pay-to Vendor No.");
        PurchHeader.TESTFIELD("Posting Date");
        PurchHeader.TESTFIELD("Document Date");

        OnAfterCheckMandatoryFields(PurchHeader, SuppressCommit);
    END;

    LOCAL PROCEDURE InitVATAmounts(PurchLine: Record 39; VAR TotalVAT: Decimal; VAR TotalVATACY: Decimal; VAR TotalAmount: Decimal; VAR TotalAmountACY: Decimal);
    BEGIN
        TotalVAT := PurchLine."Amount Including VAT" - PurchLine.Amount;
        TotalVATACY := PurchLineACY."Amount Including VAT" - PurchLineACY.Amount;
        TotalAmount := PurchLine.Amount;
        TotalAmountACY := PurchLineACY.Amount;
    END;

    LOCAL PROCEDURE InitVATBase(PurchLine: Record 39; VAR TotalVATBase: Decimal; VAR TotalVATBaseACY: Decimal);
    BEGIN
        TotalVATBase := PurchLine."VAT Base Amount";
        TotalVATBaseACY := PurchLineACY."VAT Base Amount";
    END;

    LOCAL PROCEDURE InitAmounts(PurchLine: Record 39; VAR TotalVAT: Decimal; VAR TotalVATACY: Decimal; VAR TotalAmount: Decimal; VAR TotalAmountACY: Decimal; VAR AmtToDefer: Decimal; VAR AmtToDeferACY: Decimal; VAR DeferralAccount: Code[20]);
    BEGIN
        InitVATAmounts(PurchLine, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        GetAmountsForDeferral(PurchLine, AmtToDefer, AmtToDeferACY, DeferralAccount);
    END;

    LOCAL PROCEDURE CalcInvoiceDiscountPosting(PurchHeader: Record 38; PurchLine: Record 39; PurchLineACY: Record 39; VAR InvoicePostBuffer: Record 55);
    BEGIN
        CASE PurchLine."VAT Calculation Type" OF
            PurchLine."VAT Calculation Type"::"Normal VAT", PurchLine."VAT Calculation Type"::"Full VAT",
          PurchLine."VAT Calculation Type"::"No Taxable VAT":
                InvoicePostBuffer.CalcDiscount(
                  PurchHeader."Prices Including VAT", -PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount");
            PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
                InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount");
            PurchLine."VAT Calculation Type"::"Sales Tax":
                IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
                    InvoicePostBuffer.CalcDiscount(
                      PurchHeader."Prices Including VAT", -PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount")
                ELSE
                    InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount");
        END;
    END;

    LOCAL PROCEDURE CalcLineDiscountPosting(PurchHeader: Record 38; PurchLine: Record 39; PurchLineACY: Record 39; VAR InvoicePostBuffer: Record 55);
    BEGIN
        CASE PurchLine."VAT Calculation Type" OF
            PurchLine."VAT Calculation Type"::"Normal VAT", PurchLine."VAT Calculation Type"::"Full VAT",
          PurchLine."VAT Calculation Type"::"No Taxable VAT":
                InvoicePostBuffer.CalcDiscount(
                  PurchHeader."Prices Including VAT", -PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
            PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
                InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
            PurchLine."VAT Calculation Type"::"Sales Tax":
                IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
                    InvoicePostBuffer.CalcDiscount(
                      PurchHeader."Prices Including VAT", -PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount")
                ELSE
                    InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
        END;
    END;

    LOCAL PROCEDURE CalcPaymentDiscountPosting(PurchHeader: Record 38; PurchLine: Record 39; PurchLineACY: Record 39; VAR InvoicePostBuffer: Record 55);
    BEGIN
        CASE PurchLine."VAT Calculation Type" OF
            PurchLine."VAT Calculation Type"::"Normal VAT", PurchLine."VAT Calculation Type"::"Full VAT",
          PurchLine."VAT Calculation Type"::"No Taxable VAT":
                InvoicePostBuffer.CalcDiscount(
                  PurchHeader."Prices Including VAT", -PurchLine."Pmt. Discount Amount", -PurchLineACY."Pmt. Discount Amount");
            PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
                InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Pmt. Discount Amount", -PurchLineACY."Pmt. Discount Amount");
            PurchLine."VAT Calculation Type"::"Sales Tax":
                IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
                    InvoicePostBuffer.CalcDiscount(
                      PurchHeader."Prices Including VAT", -PurchLine."Pmt. Discount Amount", -PurchLineACY."Pmt. Discount Amount")
                ELSE
                    InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
        END;
    END;

    LOCAL PROCEDURE ClearPostBuffers();
    BEGIN
        CLEAR(WhsePostRcpt);
        CLEAR(WhsePostShpt);
        CLEAR(GenJnlPostLine);
        CLEAR(JobPostLine);
        CLEAR(ItemJnlPostLine);
        CLEAR(WhseJnlPostLine);
    END;

    LOCAL PROCEDURE ValidatePostingAndDocumentDate(VAR PurchaseHeader: Record 38);
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
        OnBeforeValidatePostingAndDocumentDate(PurchaseHeader, SuppressCommit);

        PostingDateExists :=
          BatchProcessingMgt1.GetParameterBoolean(
            PurchaseHeader.RECORDID, BatchPostParameterTypes.ReplacePostingDate, ReplacePostingDate) AND
          BatchProcessingMgt1.GetParameterBoolean(
            PurchaseHeader.RECORDID, BatchPostParameterTypes.ReplaceDocumentDate, ReplaceDocumentDate) AND
          BatchProcessingMgt1.GetParameterDate(
            PurchaseHeader.RECORDID, BatchPostParameterTypes.PostingDate, PostingDate);

        IF PostingDateExists AND (ReplacePostingDate OR (PurchaseHeader."Posting Date" = 0D)) THEN BEGIN
            PurchaseHeader."Posting Date" := PostingDate;
            PurchaseHeader.VALIDATE("Currency Code");
            ModifyHeader := TRUE;
        END;

        IF PostingDateExists AND (ReplaceDocumentDate OR (PurchaseHeader."Document Date" = 0D)) THEN BEGIN
            PurchaseHeader.VALIDATE("Document Date", PostingDate);
            ModifyHeader := TRUE;
        END;

        IF ModifyHeader THEN
            PurchaseHeader.MODIFY;
    END;

    LOCAL PROCEDURE CheckExternalDocumentNumber(VAR VendLedgEntry: Record 25; VAR PurchaseHeader: Record 38);
    VAR
        VendorMgt: Codeunit 1312;
        Handled: Boolean;
    BEGIN
        OnBeforeCheckExternalDocumentNumber(VendLedgEntry, PurchaseHeader, Handled);
        IF Handled THEN
            EXIT;

        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("External Document No.");
        VendorMgt.SetFilterForExternalDocNo(
          VendLedgEntry, Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType), GenJnlLineExtDocNo, PurchaseHeader."Pay-to Vendor No.", PurchaseHeader."Document Date");
        IF VendLedgEntry.FINDFIRST THEN
            ERROR(
              PurchaseAlreadyExistsErr, VendLedgEntry."Document Type", GenJnlLineExtDocNo);
    END;

    LOCAL PROCEDURE PostInvoicePostingBuffer(PurchHeader: Record 38; VAR TempInvoicePostBuffer: Record 55 TEMPORARY);
    VAR
        VATPostingSetup: Record 325;
        CurrExchRate: Record 330;
        LineCount: Integer;
        GLEntryNo: Integer;
    BEGIN
        LineCount := 0;
        IF TempInvoicePostBuffer.FIND('+') THEN
            REPEAT
                LineCount := LineCount + 1;
                IF GUIALLOWED THEN
                    Window.UPDATE(3, LineCount);

                CASE TempInvoicePostBuffer."VAT Calculation Type" OF
                    TempInvoicePostBuffer."VAT Calculation Type"::"Reverse Charge VAT":
                        BEGIN
                            VATPostingSetup.GET(
                              TempInvoicePostBuffer."VAT Bus. Posting Group", TempInvoicePostBuffer."VAT Prod. Posting Group");
                            TempInvoicePostBuffer."VAT Amount" :=
                              ROUND(
                                TempInvoicePostBuffer."VAT Base Amount" *
                                (1 - PurchHeader."VAT Base Discount %" / 100) * VATPostingSetup."VAT+EC %" / 100);
                            TempInvoicePostBuffer."VAT Amount (ACY)" :=
                              ROUND(
                                TempInvoicePostBuffer."VAT Base Amount (ACY)" * (1 - PurchHeader."VAT Base Discount %" / 100) *
                                VATPostingSetup."VAT+EC %" / 100, Currency."Amount Rounding Precision");
                        END;
                    TempInvoicePostBuffer."VAT Calculation Type"::"Sales Tax":
                        IF TempInvoicePostBuffer."Use Tax" THEN BEGIN
                            TempInvoicePostBuffer."VAT Amount" :=
                              ROUND(
                                SalesTaxCalculate.CalculateTax(
                                  TempInvoicePostBuffer."Tax Area Code", TempInvoicePostBuffer."Tax Group Code",
                                  TempInvoicePostBuffer."Tax Liable", PurchHeader."Posting Date",
                                  TempInvoicePostBuffer.Amount, TempInvoicePostBuffer.Quantity, 0));
                            IF GLSetup."Additional Reporting Currency" <> '' THEN
                                TempInvoicePostBuffer."VAT Amount (ACY)" :=
                                  CurrExchRate.ExchangeAmtLCYToFCY(
                                    PurchHeader."Posting Date", GLSetup."Additional Reporting Currency",
                                    TempInvoicePostBuffer."VAT Amount", 0);
                        END;
                END;
                QBCodeunitPublisher.OnGetFieldsTempInvoicePostBuffer(GenJnlLine, TempInvoicePostBuffer);

                GLEntryNo := PostInvoicePostBufferLine(PurchHeader, TempInvoicePostBuffer);

                IF (TempInvoicePostBuffer."Job No." <> '') AND
                   (TempInvoicePostBuffer.Type = TempInvoicePostBuffer.Type::"G/L Account")
                THEN
                    JobPostLine.PostPurchaseGLAccounts(TempInvoicePostBuffer, GLEntryNo);

            UNTIL TempInvoicePostBuffer.NEXT(-1) = 0;

        TempInvoicePostBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE PostItemTracking(PurchHeader: Record 38; PurchLine: Record 39; VAR TempTrackingSpecification: Record 336 TEMPORARY; TrackingSpecificationExists: Boolean);
    VAR
        QtyToInvoiceBaseInTrackingSpec: Decimal;
    BEGIN
        WITH PurchHeader DO BEGIN
            IF TrackingSpecificationExists THEN BEGIN
                TempTrackingSpecification.CALCSUMS("Qty. to Invoice (Base)");
                QtyToInvoiceBaseInTrackingSpec := TempTrackingSpecification."Qty. to Invoice (Base)";
                IF NOT TempTrackingSpecification.FINDFIRST THEN
                    TempTrackingSpecification.INIT;
            END;

            IF IsCreditDocType THEN BEGIN
                IF (ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Return Qty. to Ship")) OR
                   (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
                THEN
                    PostItemTrackingForShipment(PurchHeader, PurchLine, TrackingSpecificationExists, TempTrackingSpecification);

                IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Return Qty. to Ship") THEN BEGIN
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                        ERROR(InvoiceGreaterThanReturnShipmentErr, ReturnShptHeader."No.");
                    ERROR(ReturnShipmentLinesDeletedErr);
                END;
            END ELSE BEGIN
                IF (ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Qty. to Receive")) OR
                   (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
                THEN
                    PostItemTrackingForReceipt(PurchHeader, PurchLine, TrackingSpecificationExists, TempTrackingSpecification);

                IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Qty. to Receive") THEN BEGIN
                    IF "Document Type" = "Document Type"::Invoice THEN
                        ERROR(QuantityToInvoiceGreaterErr, PurchRcptHeader."No.");
                    ERROR(ReceiptLinesDeletedErr);
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE PostItemTrackingForReceipt(PurchHeader: Record 38; PurchLine: Record 39; TrackingSpecificationExists: Boolean; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    VAR
        PurchRcptLine: Record 121;
        ItemEntryRelation: Record 6507;
        EndLoop: Boolean;
        RemQtyToInvoiceCurrLine: Decimal;
        RemQtyToInvoiceCurrLineBase: Decimal;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
    BEGIN
        WITH PurchHeader DO BEGIN
            EndLoop := FALSE;
            PurchRcptLine.RESET;
            CASE "Document Type" OF
                "Document Type"::Order:
                    BEGIN
                        PurchRcptLine.SETCURRENTKEY("Order No.", "Order Line No.");
                        PurchRcptLine.SETRANGE("Order No.", PurchLine."Document No.");
                        PurchRcptLine.SETRANGE("Order Line No.", PurchLine."Line No.");
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        PurchRcptLine.SETRANGE("Document No.", PurchLine."Receipt No.");
                        PurchRcptLine.SETRANGE("Line No.", PurchLine."Receipt Line No.");
                    END;
            END;

            PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>0');
            IF PurchRcptLine.FINDSET(TRUE) THEN BEGIN
                ItemJnlRollRndg := TRUE;
                REPEAT
                    IF TrackingSpecificationExists THEN BEGIN
                        ItemEntryRelation.GET(TempTrackingSpecification."Item Ledger Entry No.");
                        PurchRcptLine.GET(ItemEntryRelation."Source ID", ItemEntryRelation."Source Ref. No.");
                    END ELSE
                        ItemEntryRelation."Item Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                    UpdateRemainingQtyToBeInvoiced(RemQtyToInvoiceCurrLine, RemQtyToInvoiceCurrLineBase, PurchRcptLine);
                    PurchRcptLine.TESTFIELD("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
                    PurchRcptLine.TESTFIELD(Type, PurchLine.Type);
                    PurchRcptLine.TESTFIELD("No.", PurchLine."No.");
                    PurchRcptLine.TESTFIELD("Gen. Bus. Posting Group", PurchLine."Gen. Bus. Posting Group");
                    PurchRcptLine.TESTFIELD("Gen. Prod. Posting Group", PurchLine."Gen. Prod. Posting Group");
                    PurchRcptLine.TESTFIELD("Job No.", PurchLine."Job No.");
                    PurchRcptLine.TESTFIELD("Unit of Measure Code", PurchLine."Unit of Measure Code");
                    PurchRcptLine.TESTFIELD("Variant Code", PurchLine."Variant Code");
                    PurchRcptLine.TESTFIELD("Prod. Order No.", PurchLine."Prod. Order No.");

                    UpdateQtyToBeInvoicedForReceipt(
                      QtyToBeInvoiced, QtyToBeInvoicedBase,
                      TrackingSpecificationExists, PurchLine, PurchRcptLine, TempTrackingSpecification);

                    IF TrackingSpecificationExists THEN BEGIN
                        TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                        TempTrackingSpecification.MODIFY;
                    END;

                    IF TrackingSpecificationExists THEN
                        ItemTrackingMgt.AdjustQuantityRounding(
                          RemQtyToInvoiceCurrLine, QtyToBeInvoiced, RemQtyToInvoiceCurrLineBase, QtyToBeInvoicedBase);

                    RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                    RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                    UpdateInvoicedQtyOnPurchRcptLine(PurchRcptLine, QtyToBeInvoiced, QtyToBeInvoicedBase);

                    OnAfterUpdateInvoicedQtyOnPurchRcptLine(
                      PurchInvHeader, PurchRcptLine, PurchLine, TempTrackingSpecification, TrackingSpecificationExists,
                      QtyToBeInvoiced, QtyToBeInvoicedBase);

                    IF PurchLine.Type = PurchLine.Type::Item THEN
                        PostItemJnlLine(
                          PurchHeader, PurchLine,
                          0, 0,
                          QtyToBeInvoiced, QtyToBeInvoicedBase,
                          ItemEntryRelation."Item Entry No.", '', TempTrackingSpecification);

                    //-QB2130
                    QBCodeunitPublisher.OnPostItemTrackingPurchPost(PurchRcptLine, QtyToBeInvoiced, QtyToBeInvoicedBase, TempPurchRcptLine);
                    //+QB2130

                    IF TrackingSpecificationExists THEN
                        EndLoop := (TempTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0)
                    ELSE
                        EndLoop :=
                          (PurchRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(PurchLine."Qty. to Receive"));
                UNTIL EndLoop;
            END ELSE
                ERROR(ReceiptInvoicedErr, PurchLine."Receipt Line No.", PurchLine."Receipt No.");
        END;
    END;

    LOCAL PROCEDURE PostItemTrackingForShipment(PurchHeader: Record 38; PurchLine: Record 39; TrackingSpecificationExists: Boolean; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    VAR
        ReturnShptLine: Record 6651;
        ItemEntryRelation: Record 6507;
        EndLoop: Boolean;
        QtyToBeInvoiced: Decimal;
        QtyToBeInvoicedBase: Decimal;
    BEGIN
        WITH PurchHeader DO BEGIN
            EndLoop := FALSE;
            ReturnShptLine.RESET;
            CASE "Document Type" OF
                "Document Type"::"Return Order":
                    BEGIN
                        ReturnShptLine.SETCURRENTKEY("Return Order No.", "Return Order Line No.");
                        ReturnShptLine.SETRANGE("Return Order No.", PurchLine."Document No.");
                        ReturnShptLine.SETRANGE("Return Order Line No.", PurchLine."Line No.");
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        ReturnShptLine.SETRANGE("Document No.", PurchLine."Return Shipment No.");
                        ReturnShptLine.SETRANGE("Line No.", PurchLine."Return Shipment Line No.");
                    END;
            END;
            ReturnShptLine.SETFILTER("Return Qty. Shipped Not Invd.", '<>0');
            IF ReturnShptLine.FINDSET(TRUE) THEN BEGIN
                ItemJnlRollRndg := TRUE;
                REPEAT
                    IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
                        ItemEntryRelation.GET(TempTrackingSpecification."Item Ledger Entry No.");
                        ReturnShptLine.GET(ItemEntryRelation."Source ID", ItemEntryRelation."Source Ref. No.");
                    END ELSE
                        ItemEntryRelation."Item Entry No." := ReturnShptLine."Item Shpt. Entry No.";
                    ReturnShptLine.TESTFIELD("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
                    ReturnShptLine.TESTFIELD(Type, PurchLine.Type);
                    ReturnShptLine.TESTFIELD("No.", PurchLine."No.");
                    ReturnShptLine.TESTFIELD("Gen. Bus. Posting Group", PurchLine."Gen. Bus. Posting Group");
                    ReturnShptLine.TESTFIELD("Gen. Prod. Posting Group", PurchLine."Gen. Prod. Posting Group");
                    ReturnShptLine.TESTFIELD("Job No.", PurchLine."Job No.");
                    ReturnShptLine.TESTFIELD("Unit of Measure Code", PurchLine."Unit of Measure Code");
                    ReturnShptLine.TESTFIELD("Variant Code", PurchLine."Variant Code");
                    ReturnShptLine.TESTFIELD("Prod. Order No.", PurchLine."Prod. Order No.");
                    UpdateQtyToBeInvoicedForReturnShipment(
                      QtyToBeInvoiced, QtyToBeInvoicedBase,
                      TrackingSpecificationExists, PurchLine, ReturnShptLine, TempTrackingSpecification);

                    IF TrackingSpecificationExists THEN BEGIN
                        TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                        TempTrackingSpecification.MODIFY;
                    END;

                    IF TrackingSpecificationExists THEN
                        ItemTrackingMgt.AdjustQuantityRounding(
                          RemQtyToBeInvoiced, QtyToBeInvoiced, RemQtyToBeInvoicedBase, QtyToBeInvoicedBase);

                    RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                    RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                    UpdateInvoicedQtyOnReturnShptLine(ReturnShptLine, QtyToBeInvoiced, QtyToBeInvoicedBase);

                    OnAfterUpdateInvoicedQtyOnReturnShptLine(
                      PurchCrMemoHeader, ReturnShptLine, PurchLine, TempTrackingSpecification, TrackingSpecificationExists,
                      QtyToBeInvoiced, QtyToBeInvoicedBase);

                    IF PurchLine.Type = PurchLine.Type::Item THEN
                        PostItemJnlLine(
                          PurchHeader, PurchLine,
                          0, 0,
                          QtyToBeInvoiced, QtyToBeInvoicedBase,
                          ItemEntryRelation."Item Entry No.", '', TempTrackingSpecification);

                    //-QB2130
                    QBCodeunitPublisher.OnPostItemTrackingPurchShipment(ReturnShptLine, QtyToBeInvoiced, QtyToBeInvoicedBase, TempReturnShptLine);
                    //+QB2130

                    IF TrackingSpecificationExists THEN
                        EndLoop := (TempTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0)
                    ELSE
                        EndLoop :=
                          (ReturnShptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(PurchLine."Return Qty. to Ship"));
                UNTIL EndLoop;
            END ELSE
                ERROR(
                  ReturnShipmentInvoicedErr,
                  PurchLine."Return Shipment Line No.", PurchLine."Return Shipment No.");
        END;
    END;

    LOCAL PROCEDURE PostUpdateOrderLine(PurchHeader: Record 38);
    VAR
        TempPurchLine: Record 39 TEMPORARY;
    BEGIN
        OnBeforePostUpdateOrderLine(PurchHeader, TempPurchLineGlobal);

        ResetTempLines(TempPurchLine);
        WITH TempPurchLine DO BEGIN
            SETRANGE("Prepayment Line", FALSE);
            SETFILTER(Quantity, '<>0');
            IF FINDSET THEN
                REPEAT
                    IF PurchHeader.Receive THEN BEGIN
                        "Quantity Received" += "Qty. to Receive";
                        "Qty. Received (Base)" += "Qty. to Receive (Base)";
                    END;
                    IF PurchHeader.Ship THEN BEGIN
                        "Return Qty. Shipped" += "Return Qty. to Ship";
                        "Return Qty. Shipped (Base)" += "Return Qty. to Ship (Base)";
                    END;
                    IF PurchHeader.Invoice THEN BEGIN
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Quantity Received") THEN BEGIN
                                VALIDATE("Qty. to Invoice", "Quantity Received" - "Quantity Invoiced");
                                "Qty. to Invoice (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)";
                            END
                        END ELSE
                            IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Return Qty. Shipped") THEN BEGIN
                                VALIDATE("Qty. to Invoice", "Return Qty. Shipped" - "Quantity Invoiced");
                                "Qty. to Invoice (Base)" := "Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
                            END;

                        "Quantity Invoiced" := "Quantity Invoiced" + "Qty. to Invoice";
                        "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
                        IF "Qty. to Invoice" <> 0 THEN BEGIN
                            "Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                            "Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                            DecrementPrepmtAmtInvLCY(
                              TempPurchLine, "Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
                            "Prepmt Amt to Deduct" := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
                            "Prepmt VAT Diff. to Deduct" := 0;
                        END;
                    END;

                    UpdateBlanketOrderLine(TempPurchLine, PurchHeader.Receive, PurchHeader.Ship, PurchHeader.Invoice);
                    InitOutstanding;

                    IF WhseHandlingRequired(TempPurchLine) OR
                       (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank)
                    THEN BEGIN
                        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                            "Return Qty. to Ship" := 0;
                            "Return Qty. to Ship (Base)" := 0;
                        END ELSE BEGIN
                            "Qty. to Receive" := 0;
                            "Qty. to Receive (Base)" := 0;
                        END;
                        InitQtyToInvoice;
                    END ELSE BEGIN
                        IF "Document Type" = "Document Type"::"Return Order" THEN
                            InitQtyToShip
                        ELSE
                            InitQtyToReceive2;
                    END;
                    SetDefaultQuantity;
                    ModifyTempLine(TempPurchLine);
                    OnAfterPostUpdateOrderLine(TempPurchLine, WhseShip, WhseReceive, SuppressCommit);
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostUpdateInvoiceLine();
    VAR
        PurchOrderLine: Record 39;
        PurchRcptLine: Record 121;
        SalesOrderLine: Record 37;
        TempPurchLine: Record 39 TEMPORARY;
    BEGIN
        ResetTempLines(TempPurchLine);
        WITH TempPurchLine DO BEGIN
            SETFILTER("Receipt No.", '<>%1', '');
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    PurchRcptLine.GET("Receipt No.", "Receipt Line No.");
                    PurchOrderLine.GET(
                      PurchOrderLine."Document Type"::Order,
                      PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                    IF Type = Type::"Charge (Item)" THEN
                        UpdatePurchOrderChargeAssgnt(TempPurchLine, PurchOrderLine);
                    PurchOrderLine."Quantity Invoiced" += "Qty. to Invoice";
                    PurchOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
                    IF ABS(PurchOrderLine."Quantity Invoiced") > ABS(PurchOrderLine."Quantity Received") THEN
                        ERROR(InvoiceMoreThanReceivedErr, PurchOrderLine."Document No.");
                    IF PurchOrderLine."Sales Order Line No." <> 0 THEN BEGIN // Drop Shipment
                        SalesOrderLine.GET(
                          SalesOrderLine."Document Type"::Order,
                          PurchOrderLine."Sales Order No.", PurchOrderLine."Sales Order Line No.");
                        IF ABS(PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") <
                           ABS(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
                        THEN
                            ERROR(CannotPostBeforeAssosSalesOrderErr, PurchOrderLine."Sales Order No.");
                    END;
                    PurchOrderLine.InitQtyToInvoice;
                    IF PurchOrderLine."Prepayment %" <> 0 THEN BEGIN
                        PurchOrderLine."Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                        PurchOrderLine."Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                        DecrementPrepmtAmtInvLCY(
                          TempPurchLine, PurchOrderLine."Prepmt. Amount Inv. (LCY)", PurchOrderLine."Prepmt. VAT Amount Inv. (LCY)");
                        PurchOrderLine."Prepmt Amt to Deduct" :=
                          PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted";
                        PurchOrderLine."Prepmt VAT Diff. to Deduct" := 0;
                    END;
                    PurchOrderLine.InitOutstanding;
                    PurchOrderLine.MODIFY;
                    OnPostUpdateInvoiceLineOnAfterPurchOrderLineModify(PurchOrderLine, TempPurchLine);
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostUpdateCreditMemoLine();
    VAR
        PurchOrderLine: Record 39;
        ReturnShptLine: Record 6651;
        TempPurchLine: Record 39 TEMPORARY;
    BEGIN
        ResetTempLines(TempPurchLine);
        WITH TempPurchLine DO BEGIN
            SETFILTER("Return Shipment No.", '<>%1', '');
            SETFILTER(Type, '<>%1', Type::" ");
            IF FINDSET THEN
                REPEAT
                    ReturnShptLine.GET("Return Shipment No.", "Return Shipment Line No.");
                    PurchOrderLine.GET(
                      PurchOrderLine."Document Type"::"Return Order",
                      ReturnShptLine."Return Order No.", ReturnShptLine."Return Order Line No.");
                    IF Type = Type::"Charge (Item)" THEN
                        UpdatePurchOrderChargeAssgnt(TempPurchLine, PurchOrderLine);
                    PurchOrderLine."Quantity Invoiced" :=
                      PurchOrderLine."Quantity Invoiced" + "Qty. to Invoice";
                    PurchOrderLine."Qty. Invoiced (Base)" :=
                      PurchOrderLine."Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
                    IF ABS(PurchOrderLine."Quantity Invoiced") > ABS(PurchOrderLine."Return Qty. Shipped") THEN
                        ERROR(InvoiceMoreThanShippedErr, PurchOrderLine."Document No.");
                    PurchOrderLine.InitQtyToInvoice;
                    PurchOrderLine.InitOutstanding;
                    PurchOrderLine.MODIFY;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE SetPostingFlags(VAR PurchHeader: Record 38);
    BEGIN
        WITH PurchHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    Ship := FALSE;
                "Document Type"::Invoice:
                    BEGIN
                        Receive := TRUE;
                        Invoice := TRUE;
                        Ship := FALSE;
                    END;
                "Document Type"::"Return Order":
                    Receive := FALSE;
                "Document Type"::"Credit Memo":
                    BEGIN
                        Receive := FALSE;
                        Invoice := TRUE;
                        Ship := TRUE;
                    END;
            END;
            IF NOT (Receive OR Invoice OR Ship) THEN
                ERROR(ReceiveInvoiceShipErr);
        END;
    END;

    LOCAL PROCEDURE SetCheckApplToItemEntry(PurchLine: Record 39): Boolean;
    BEGIN
        WITH PurchLine DO
            EXIT(
              PurchSetup."Exact Cost Reversing Mandatory" AND (Type = Type::Item) AND
              (((Quantity < 0) AND ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice])) OR
               ((Quantity > 0) AND IsCreditDocType)) AND
              ("Job No." = ''));
    END;

    LOCAL PROCEDURE CreatePostedDeferralScheduleFromPurchDoc(PurchLine: Record 39; NewDocumentType: Integer; NewDocumentNo: Code[20]; NewLineNo: Integer; PostingDate: Date);
    VAR
        PostedDeferralHeader: Record 1704;
        PostedDeferralLine: Record 1705;
        DeferralTemplate: Record 1700;
        DeferralAccount: Code[20];
    BEGIN
        IF PurchLine."Deferral Code" = '' THEN
            EXIT;

        IF DeferralTemplate.GET(PurchLine."Deferral Code") THEN
            DeferralAccount := DeferralTemplate."Deferral Account";

        IF TempDeferralHeader.GET(
             DeferralUtilities1.GetPurchDeferralDocType, '', '', PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.")
        THEN BEGIN
            PostedDeferralHeader.InitFromDeferralHeader(TempDeferralHeader, '', '', NewDocumentType,
              NewDocumentNo, NewLineNo, DeferralAccount, PurchLine."Buy-from Vendor No.", PostingDate);
            DeferralUtilities.FilterDeferralLines(
              TempDeferralLine, DeferralUtilities1.GetPurchDeferralDocType, '', '',
              PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");
            IF TempDeferralLine.FINDSET THEN
                REPEAT
                    PostedDeferralLine.InitFromDeferralLine(
                      TempDeferralLine, '', '', NewDocumentType, NewDocumentNo, NewLineNo, DeferralAccount);
                UNTIL TempDeferralLine.NEXT = 0;
        END;

        OnAfterCreatePostedDeferralScheduleFromPurchDoc(PurchLine, PostedDeferralHeader);
    END;

    LOCAL PROCEDURE CalcDeferralAmounts(PurchHeader: Record 38; PurchLine: Record 39; OriginalDeferralAmount: Decimal);
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
        IF PurchHeader."Posting Date" = 0D THEN
            UseDate := WORKDATE
        ELSE
            UseDate := PurchHeader."Posting Date";

        IF DeferralHeader.GET(
             DeferralUtilities1.GetPurchDeferralDocType, '', '', PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.")
        THEN BEGIN
            TempDeferralHeader := DeferralHeader;
            IF PurchLine.Quantity <> PurchLine."Qty. to Invoice" THEN
                TempDeferralHeader."Amount to Defer" :=
                  ROUND(TempDeferralHeader."Amount to Defer" *
                    PurchLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");
            TempDeferralHeader."Amount to Defer (LCY)" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, PurchHeader."Currency Code",
                  TempDeferralHeader."Amount to Defer", PurchHeader."Currency Factor"));
            TempDeferralHeader.INSERT;

            WITH DeferralLine DO BEGIN
                DeferralUtilities.FilterDeferralLines(
                  DeferralLine, DeferralHeader."Deferral Doc. Type".AsInteger(),
                  DeferralHeader."Gen. Jnl. Template Name", DeferralHeader."Gen. Jnl. Batch Name",
                  PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.");
                IF FINDSET THEN BEGIN
                    TotalDeferralCount := COUNT;
                    REPEAT
                        TempDeferralLine.INIT;
                        TempDeferralLine := DeferralLine;
                        DeferralCount := DeferralCount + 1;

                        IF DeferralCount = TotalDeferralCount THEN BEGIN
                            TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                            TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
                        END ELSE BEGIN
                            IF PurchLine.Quantity <> PurchLine."Qty. to Invoice" THEN
                                TempDeferralLine.Amount :=
                                  ROUND(TempDeferralLine.Amount *
                                    PurchLine.GetDeferralAmount / OriginalDeferralAmount, Currency."Amount Rounding Precision");

                            TempDeferralLine."Amount (LCY)" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  UseDate, PurchHeader."Currency Code",
                                  TempDeferralLine.Amount, PurchHeader."Currency Factor"));
                            TotalAmount := TotalAmount + TempDeferralLine.Amount;
                            TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
                        END;
                        TempDeferralLine.INSERT;
                    UNTIL NEXT = 0;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE GetAmountRoundingPrecisionInLCY(DocType: Enum "Purchase Document Type"; DocNo: Code[20]; CurrencyCode: Code[10]) AmountRoundingPrecision: Decimal;
    VAR
        PurchHeader: Record 38;
    BEGIN
        IF CurrencyCode = '' THEN
            EXIT(GLSetup."Amount Rounding Precision");
        PurchHeader.GET(DocType, DocNo);
        AmountRoundingPrecision := Currency."Amount Rounding Precision" / PurchHeader."Currency Factor";
        IF AmountRoundingPrecision < GLSetup."Amount Rounding Precision" THEN
            EXIT(GLSetup."Amount Rounding Precision");
        EXIT(AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE CollectPurchaseLineReservEntries(VAR JobReservEntry: Record 337; ItemJournalLine: Record 83);
    VAR
        ReservationEntry: Record 337;
        ItemJnlLineReserve: Codeunit 99000835;
    BEGIN
        IF ItemJournalLine."Job No." <> '' THEN BEGIN
            JobReservEntry.DELETEALL;
            ItemJnlLineReserve.FindReservEntry(ItemJournalLine, ReservationEntry);
            ReservationEntry.ClearTrackingFilter;
            IF ReservationEntry.FINDSET THEN
                REPEAT
                    JobReservEntry := ReservationEntry;
                    JobReservEntry.INSERT;
                UNTIL ReservationEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ArchiveSalesOrders(VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    VAR
        SalesOrderHeader: Record 36;
        SalesOrderLine: Record 37;
    BEGIN
        IF TempDropShptPostBuffer.FINDSET THEN BEGIN
            REPEAT
                SalesOrderHeader.GET(
                  SalesOrderHeader."Document Type"::Order,
                  TempDropShptPostBuffer."Order No.");
                TempDropShptPostBuffer.SETRANGE("Order No.", TempDropShptPostBuffer."Order No.");
                REPEAT
                    SalesOrderLine.GET(
                      SalesOrderLine."Document Type"::Order,
                      TempDropShptPostBuffer."Order No.", TempDropShptPostBuffer."Order Line No.");
                    SalesOrderLine."Qty. to Ship" := TempDropShptPostBuffer.Quantity;
                    SalesOrderLine."Qty. to Ship (Base)" := TempDropShptPostBuffer."Quantity (Base)";
                    SalesOrderLine.MODIFY;
                UNTIL TempDropShptPostBuffer.NEXT = 0;
                SalesPost.ArchiveUnpostedOrder(SalesOrderHeader);
                TempDropShptPostBuffer.SETRANGE("Order No.");
            UNTIL TempDropShptPostBuffer.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ClearAllVariables();
    BEGIN
        CLEARALL;
        TempPurchLineGlobal.DELETEALL;
        TempItemChargeAssgntPurch.DELETEALL;
        TempHandlingSpecification.DELETEALL;
        TempTrackingSpecification.DELETEALL;
        TempTrackingSpecificationInv.DELETEALL;
        TempWhseSplitSpecification.DELETEALL;
        TempValueEntryRelation.DELETEALL;
        TempICGenJnlLine.DELETEALL;
        TempPrepmtDeductLCYPurchLine.DELETEALL;
        TempSKU.DELETEALL;
        TempDeferralHeader.DELETEALL;
        TempDeferralLine.DELETEALL;
    END;


    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckPurchDoc(VAR PurchHeader: Record 38; CommitIsSupressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckAndUpdate(VAR PurchaseHeader: Record 38; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckTrackingAndWarehouseForReceive(VAR PurchaseHeader: Record 38; VAR Receive: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckTrackingAndWarehouseForShip(VAR PurchaseHeader: Record 38; VAR Ship: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreatePostedDeferralScheduleFromPurchDoc(VAR PurchaseLine: Record 39; VAR PostedDeferralHeader: Record 1704);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterDeleteAfterPosting(PurchHeader: Record 38; PurchInvHeader: Record 122; PurchCrMemoHdr: Record 124; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterDivideAmount(PurchHeader: Record 38; VAR PurchLine: Record 39; QtyType: Option "General","Invoicing","Shipping"; PurchLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    PROCEDURE OnAfterPostPurchaseDoc(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostPurchaseDocDropShipment(SalesShptNo: Code[20]; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePostingNos(VAR PurchaseHeader: Record 38; VAR NoSeriesMgt: Codeunit 396; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckMandatoryFields(VAR PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFillInvoicePostBuffer(VAR InvoicePostBuffer: Record 55; PurchLine: Record 39; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFinalizePosting(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShptHeader: Record 6650; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFinalizePostingOnBeforeCommit(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShptHeader: Record 6650; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterIncrAmount(VAR TotalPurchLine: Record 39; PurchLine: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertPostedHeaders(VAR PurchaseHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShptHeader: Record 6650);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInvoiceRoundingAmount(PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; VAR TotalPurchaseLine: Record 39; UseTempData: Boolean; InvoiceRoundingAmount: Decimal; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertedPrepmtVATBaseToDeduct(PurchHeader: Record 38; PurchLine: Record 39; PrepmtLineNo: Integer; TotalPrepmtAmtToDeduct: Decimal; VAR TempPrepmtDeductLCYPurchLine: Record 39 TEMPORARY; VAR PrepmtVATBaseToDeduct: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostItemJnlLineCopyProdOrder(VAR ItemJnlLine: Record 83; PurchLine: Record 39; PurchRcptHeader: Record 120; QtyToBeReceived: Decimal; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchRcptHeaderInsert(VAR PurchRcptHeader: Record 120; VAR PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchRcptLineInsert(PurchaseLine: Record 39; VAR PurchRcptLine: Record 121; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record 122);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchInvHeaderInsert(VAR PurchInvHeader: Record 122; VAR PurchHeader: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchInvLineInsert(VAR PurchInvLine: Record 123; PurchInvHeader: Record 122; PurchLine: Record 39; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchCrMemoHeaderInsert(VAR PurchCrMemoHdr: Record 124; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPurchCrMemoLineInsert(VAR PurchCrMemoLine: Record 125; VAR PurchCrMemoHdr: Record 124; VAR PurchLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReturnShptHeaderInsert(VAR ReturnShptHeader: Record 6650; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReturnShptLineInsert(VAR ReturnShptLine: Record 6651; ReturnShptHeader: Record 6650; PurchLine: Record 39; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; VAR TempWhseShptHeader: Record 7320 TEMPORARY; PurchCrMemoHdr: Record 124);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesShptHeaderInsert(VAR SalesShipmentHeader: Record 110; SalesOrderHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesShptLineInsert(VAR SalesShptLine: Record 111; SalesShptHeader: Record 110; SalesOrderLine: Record 37; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostAccICLine(PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostItemLine(PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostVendorEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; CommitIsSupressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostBalancingEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; CommitIsSupressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 55; PurchHeader: Record 38; GLEntryNo: Integer; CommitIsSupressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostWhseJnlLine(VAR PurchaseLine: Record 39; ItemLedgEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostUpdateOrderLine(VAR PurchaseLine: Record 39; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostGLAndVendor(VAR PurchHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; TotalPurchLine: Record 39; TotalPurchLineLCY: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostPurchLine(VAR PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    [IntegrationEvent(false,false)]
    LOCAL PROCEDURE OnAfterPostPurchLines(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShipmentHeader: Record 6650; WhseShip: Boolean; WhseReceive: Boolean; VAR PurchLinesProcessed: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterResetTempLines(VAR TempPurchLineGlobal: Record 39 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReverseAmount(VAR PurchLine: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRoundAmount(PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; PurchLineQty: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSaveTempWhseSplitSpec(PurchaseLine: Record 39; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetApplyToDocNo(VAR GenJournalLine: Record 81; PurchaseHeader: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTestPurchLine(PurchHeader: Record 38; PurchLine: Record 39; WhseReceive: Boolean; WhseShip: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdateInvoicedQtyOnPurchRcptLine(PurchInvHeader: Record 122; PurchRcptLine: Record 121; PurchaseLine: Record 39; TempTrackingSpecification: Record 336 TEMPORARY; TrackingSpecificationExists: Boolean; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdateInvoicedQtyOnReturnShptLine(PurchCrMemoHdr: Record 124; ReturnShipmentLine: Record 6651; PurchaseLine: Record 39; TempTrackingSpecification: Record 336 TEMPORARY; TrackingSpecificationExists: Boolean; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePurchLineBeforePost(VAR PurchaseLine: Record 39; WhseShip: Boolean; WhseReceive: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePrepmtPurchLineWithRounding(VAR PrepmtPurchLine: Record 39; TotalRoundingAmount: ARRAY[2] OF Decimal; TotalPrepmtAmount: ARRAY[2] OF Decimal; FinalInvoice: Boolean; PricesInclVATRoundingAmount: ARRAY[2] OF Decimal; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePurchaseHeader(VAR VendorLedgerEntry: Record 25; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; GenJnlLineDocType: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeBlanketOrderPurchLineModify(VAR BlanketOrderPurchLine: Record 39; PurchLine: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckExternalDocumentNumber(VendorLedgerEntry: Record 25; PurchaseHeader: Record 38; VAR Handled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeDeleteAfterPosting(VAR PurchaseHeader: Record 38; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR SkipDelete: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeDivideAmount(PurchHeader: Record 38; VAR PurchLine: Record 39; QtyType: Option "General","Invoicing","Shipping"; PurchLineQty: Decimal; VAR TempVATAmountLine: Record 290 TEMPORARY; VAR TempVATAmountLineRemainder: Record 290 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFinalizePosting(VAR PurchaseHeader: Record 38; VAR TempPurchLineGlobal: Record 39 TEMPORARY; VAR EverythingInvoiced: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInvoiceRoundingAmount(PurchHeader: Record 38; TotalAmountIncludingVAT: Decimal; UseTempData: Boolean; VAR InvoiceRoundingAmount: Decimal; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertReceiptHeader(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR IsHandled: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeItemJnlPostLine(VAR ItemJournalLine: Record 83; PurchaseLine: Record 39; PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeLockTables(VAR PurchHeader: Record 38; PreviewMode: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostLines(VAR PurchLine: Record 39; PurchHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostGLAndVendor(VAR PurchHeader: Record 38; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostGLAccICLine(VAR PurchHeader: Record 38; VAR PurchLine: Record 39; VAR ICGenJnlLineNo: Integer; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostPurchaseDoc(VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostCommitPurchaseDoc(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; ModifyHeader: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchLineDeleteAll(VAR PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchRcptHeaderInsert(VAR PurchRcptHeader: Record 120; VAR PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchRcptLineInsert(VAR PurchRcptLine: Record 121; VAR PurchRcptHeader: Record 120; VAR PurchLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchInvHeaderInsert(VAR PurchInvHeader: Record 122; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchInvLineInsert(VAR PurchInvLine: Record 123; VAR PurchInvHeader: Record 122; VAR PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchCrMemoHeaderInsert(VAR PurchCrMemoHdr: Record 124; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePurchCrMemoLineInsert(VAR PurchCrMemoLine: Record 125; VAR PurchCrMemoHdr: Record 124; VAR PurchLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeReturnShptHeaderInsert(VAR ReturnShptHeader: Record 6650; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeReturnShptLineInsert(VAR ReturnShptLine: Record 6651; VAR ReturnShptHeader: Record 6650; VAR PurchLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRoundAmount(VAR PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; PurchLineQty: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesShptHeaderInsert(VAR SalesShptHeader: Record 110; SalesOrderHeader: Record 36; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesShptLineInsert(VAR SalesShptLine: Record 111; SalesShptHeader: Record 110; SalesLine: Record 37; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostVendorEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 55; VAR PurchHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostItemJnlLine(PurchHeader: Record 38; VAR PurchLine: Record 39; VAR QtyToBeReceived: Decimal; VAR QtyToBeReceivedBase: Decimal; VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; VAR ItemLedgShptEntryNo: Integer; VAR ItemChargeNo: Code[20]; VAR TrackingSpecification: Record 336; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostAssocItemJnlLine(VAR ItemJournalLine: Record 83; VAR SalesLine: Record 37; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostItemChargePerOrder(VAR PurchHeader: Record 38; VAR PurchLine: Record 39; VAR ItemJnlLine2: Record 83; VAR ItemChargePurchLine: Record 39; VAR TempTrackingSpecificationChargeAssmt: Record 336 TEMPORARY; CommitIsSupressed: Boolean; VAR TempItemChargeAssgntPurch: Record 5805 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostItemJnlLineJobConsumption(VAR ItemJournalLine: Record 83; PurchaseLine: Record 39; PurchInvHeader: Record 122; PurchCrMemoHdr: Record 124; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; SourceCode: Code[10]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostUpdateOrderLine(PurchHeader: Record 38; VAR TempPurchLineGlobal: Record 39 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempPrepmtPurchLineInsert(VAR TempPrepmtPurchLine: Record 39 TEMPORARY; VAR TempPurchLine: Record 39 TEMPORARY; PurchaseHeader: Record 38; CompleteFunctionality: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempPrepmtPurchLineModify(VAR TempPrepmtPurchLine: Record 39 TEMPORARY; VAR TempPurchLine: Record 39 TEMPORARY; PurchaseHeader: Record 38; CompleteFunctionality: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdatePurchLineBeforePost(VAR PurchaseLine: Record 39; VAR PurchaseHeader: Record 38; WhseShip: Boolean; WhseReceive: Boolean; RoundingLineInserted: Boolean; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateCarteraBills(PurchHeader: Record 38; VendLedgEntry: Record 25; VAR TotalPurchLine: Record 39; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdateInvoicedQtyOnPurchRcptLine(VAR PurchRcptLine: Record 121; VAR QtyToBeInvoiced: Decimal; VAR QtyToBeInvoicedBase: Decimal; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdatePrepmtPurchLineWithRounding(VAR PrepmtPurchLine: Record 39; TotalRoundingAmount: ARRAY[2] OF Decimal; TotalPrepmtAmount: ARRAY[2] OF Decimal; FinalInvoice: Boolean; PricesInclVATRoundingAmount: ARRAY[2] OF Decimal; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTestPurchLine(VAR PurchaseLine: Record 39; VAR PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeValidatePostingAndDocumentDate(VAR PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFillDeferralPostingBuffer(VAR PurchLine: Record 39; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR InvoicePostBuffer: Record 55; UseDate: Date; InvDefLineNo: Integer; DeferralLineNo: Integer; CommitIsSupressed: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeGetCountryCode(SalesHeader: Record 36; SalesLine: Record 37; VAR CountryRegionCode: Code[10]; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckAndUpdateOnBeforeCalcInvDiscount(VAR PurchaseHeader: Record 38; WarehouseReceiptHeader: Record 7316; WarehouseShipmentHeader: Record 7320; WhseReceive: Boolean; WhseShip: Boolean; VAR RefreshNeeded: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCopyAndCheckItemChargeOnBeforeLoop(VAR TempPurchLine: Record 39 TEMPORARY; PurchHeader: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnFillInvoicePostBufferOnAfterInitAmounts(PurchHeader: Record 38; VAR PurchLine: Record 39; VAR PurchLineACY: Record 39; VAR TempInvoicePostBuffer: Record 55 TEMPORARY; VAR InvoicePostBuffer: Record 55; VAR TotalAmount: Decimal; VAR TotalAmountACY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetItemChargeLineOnAfterGet(VAR ItemChargePurchLine: Record 39; PurchHeader: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostItemChargePerOrderOnAfterCopyToItemJnlLine(VAR ItemJournalLine: Record 83; VAR PurchaseLine: Record 39; GeneralLedgerSetup: Record 98; QtyToInvoice: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostItemJnlLineJobConsumption(PurchHeader: Record 38; VAR PurchLine: Record 39; ItemJournalLine: Record 83; VAR TempPurchReservEntry: Record 337 TEMPORARY; QtyToBeInvoiced: Decimal; QtyToBeReceived: Decimal; VAR TempTrackingSpecification: Record 336 TEMPORARY; PurchItemLedgEntryNo: Integer; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostItemJnlLineOnAfterSetFactor(VAR PurchaseLine: Record 39; VAR Factor: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostUpdateInvoiceLineOnAfterPurchOrderLineModify(VAR PurchaseLine: Record 39; VAR TempPurchaseLine: Record 39 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRoundAmountOnBeforeIncrAmount(PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; PurchLineQty: Decimal; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateAssocOrderOnAfterSalesOrderLineModify(VAR SalesOrderLine: Record 37; VAR TempDropShptPostBuffer: Record 223 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateBlanketOrderLineOnBeforeInitOutstanding(VAR BlanketOrderPurchaseLine: Record 39; PurchaseLine: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateWhseDocumentsOnAfterUpdateWhseRcpt(VAR WarehouseReceiptHeader: Record 7316);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateWhseDocumentsOnAfterUpdateWhseShpt(VAR WarehouseShipmentHeader: Record 7320);
    BEGIN
    END;


    /*BEGIN
/*{
      QB2130
      JAV 21/10/19: - Se pasan los eventos de retenciones a la CU de retenciones
      CPA 25/01/22: - QB 1.10.23 (Q15921). Errores detectados en almacenes de obras. Cambio en OnRun
      JAV 16/06/22: - QB 1.10.50 Se cambia llamar la la funci�n OnRunGenJnlPostLinePurchPost de la CU 7207352 por el evento OnBeforePostInvPostBuffer que es mas apropiado
    }
END.*/
}











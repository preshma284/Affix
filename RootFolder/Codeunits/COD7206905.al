Codeunit 7206905 "QB Cartera"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Window: Dialog;
        WindowsOpen: Boolean;
        Txt000: TextConst ESP = 'Esta opci�n no est� operativa.';
        Txt001: TextConst ESP = 'Banco:';
        Txt002: TextConst ESP = 'Cliente:';
        Txt003: TextConst ESP = 'Ha sobrepasado el l�mite de la l�nea de confirming, disponible %1, en esta relaci�n %2';
        Txt004: TextConst ESP = 'Ha sobrepasado el l�mite de la l�nea de factoring del banco %1, disponible %1, en esta relaci�n %2';
        Txt005: TextConst ESP = 'Ha sobrepasado el l�mite de la l�nea de factoring del cliente %3, disponible %1, en esta relaci�n %2';
        Txt006: TextConst ESP = 'Calculando importes de confirming\'' + ''Linea: #1################################\'' + ''Empresa #2################################\'' + ''Banco: #3################################';
        Txt007: TextConst ESP = '''Calculando importes de Factoring\'' + ''Linea: #1################################\'' + ''Empresa: #2################################\'' + ''#3#########################################';
        Txt010: TextConst ESP = 'Confirme que desea recircular %1 documentos';
        NewDes: TextConst ENU = 'Redraw Invoice %1/%2', ESP = 'Recircular Factura %1';
        PMError: TextConst ESP = 'No existe esa forma de pago';
        Text1100004: TextConst ENU = 'No documents have been found that can be redrawn. \', ESP = 'No hay documentos que se puedan recircular. \';
        Text1100005: TextConst ENU = 'Please check that at least one rejected or honored document was selected.', ESP = 'Compruebe que ha seleccionado documentos pagados y no recirculados';
        Text1100006: TextConst ENU = 'Only bills can be redrawn.', ESP = 'S�lo se pueden recircular efectos o facturas';
        Text1100007: TextConst ESP = 'No puede recircular efectos ya recirculados';

    PROCEDURE IsConfirmingActive(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (QuoBuildingSetup.GET) THEN
            EXIT(QuoBuildingSetup."Use Confirming Lines");

        EXIT(FALSE);
    END;

    PROCEDURE IsConfirmingActiveError();
    BEGIN
        IF (NOT IsConfirmingActive) THEN
            ERROR(Txt000);
    END;

    PROCEDURE IsFactoringActive(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        IF (QuoBuildingSetup.GET) THEN
            EXIT(QuoBuildingSetup."Use Factoring Lines");

        EXIT(FALSE);
    END;

    PROCEDURE IsFactoringActiveError();
    BEGIN
        IF (NOT IsFactoringActive) THEN
            ERROR(Txt000);
    END;

    LOCAL PROCEDURE "Cambiar datos de orden de pago registrada"();
    BEGIN
    END;

    PROCEDURE ChangePostedDocDueDate(VAR PostedCarteraDoc: Record 7000003);
    VAR
        VendorLedgerEntry: Record 25;
        DetailedVendorLedgEntry: Record 380;
        QBCarteraChanges: Page 7206972;
        newDate: Date;
    BEGIN
        //JAV 23/09/20: - Cambia el vencimiento en un documento de cartera registrado
        CLEAR(QBCarteraChanges);
        QBCarteraChanges.SetDueDate(PostedCarteraDoc."Due Date");
        QBCarteraChanges.LOOKUPMODE(TRUE);
        IF QBCarteraChanges.RUNMODAL = ACTION::LookupOK THEN BEGIN
            newDate := QBCarteraChanges.GetDueDate;
            IF (newDate > PostedCarteraDoc."Due Date") THEN BEGIN
                //Cambiar el movimiento de proveedor
                VendorLedgerEntry.GET(PostedCarteraDoc."Entry No.");
                IF (VendorLedgerEntry."QB Original Due Date" = 0D) THEN
                    VendorLedgerEntry."QB Original Due Date" := VendorLedgerEntry."Due Date";
                VendorLedgerEntry."Due Date" := newDate;
                VendorLedgerEntry.MODIFY;

                //Cambiar el movimiento de proveedor detallado
                DetailedVendorLedgEntry.RESET;
                DetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", PostedCarteraDoc."Entry No.");
                DetailedVendorLedgEntry.SETRANGE("Entry Type", DetailedVendorLedgEntry."Entry Type"::"Initial Entry");
                DetailedVendorLedgEntry.FINDFIRST;
                IF (DetailedVendorLedgEntry."QB Original Due Date" = 0D) THEN
                    DetailedVendorLedgEntry."QB Original Due Date" := DetailedVendorLedgEntry."Initial Entry Due Date";
                DetailedVendorLedgEntry."Initial Entry Due Date" := newDate;
                DetailedVendorLedgEntry.MODIFY;

                //Cambiar el documento de cartera registrado
                IF (PostedCarteraDoc."Original Due Date" = 0D) THEN
                    PostedCarteraDoc."Original Due Date" := PostedCarteraDoc."Due Date";
                PostedCarteraDoc."Due Date" := newDate;
                PostedCarteraDoc.MODIFY;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7000020, OnAfterValidateEvent, "Bank Account No.", true, true)]
    LOCAL PROCEDURE "OnAfterValidateEvent_Bank Account No._TBPaymentOrder"(VAR Rec: Record 7000020; VAR xRec: Record 7000020; CurrFieldNo: Integer);
    VAR
        BankAccount: Record 270;
    BEGIN
        //JAV 23/09/20: - Al informar del banco en una orden de pago, establecer su l�nea de confirming en la pantalla
        IF (IsConfirmingActive) THEN BEGIN
            IF (Rec."Bank Account No." <> xRec."Bank Account No.") THEN BEGIN
                IF (BankAccount.GET(Rec."Bank Account No.")) THEN
                    Rec."Confirming Line" := BankAccount."Confirming Line";
            END;
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------------- Confirming"();
    BEGIN
    END;

    PROCEDURE AddToPayment(VAR PostedCarteraDoc: Record 7000003; VAR PaymentOrder: Record 7000020);
    VAR
        PostedPaymentOrder: Record 7000021;
    BEGIN
        //JAV 23/09/20: - A�adir informaci�n de la l�nea de confirming al documento en la orden de pago registrada
        IF (IsConfirmingActive) AND (PaymentOrder.Confirming) THEN
            PostedCarteraDoc."Confirming Line" := PaymentOrder."Confirming Line"
        ELSE
            PaymentOrder."Confirming Line" := '';
    END;

    PROCEDURE CalculateConfirmingLine(VAR QBConfirmingLines: Record 7206946; CloseDialog: Boolean): Boolean;
    VAR
        QBConfirmingBankAccounts: Record 7206947;
        TotalUsed: Decimal;
    BEGIN
        //JAV 23/09/20: - Calcular los importes de una l�nea de confirming
        IF (NOT IsConfirmingActive) THEN
            EXIT;

        IF (NOT WindowsOpen) THEN
            Window.OPEN(Txt006);
        WindowsOpen := TRUE;

        TotalUsed := 0;
        QBConfirmingBankAccounts.RESET;
        QBConfirmingBankAccounts.SETRANGE("Confirming Line", QBConfirmingLines.Code);
        IF (QBConfirmingBankAccounts.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(1, QBConfirmingBankAccounts."Confirming Line");
                Window.UPDATE(2, QBConfirmingBankAccounts.Company);
                Window.UPDATE(3, QBConfirmingBankAccounts."Bank Account");
                QBConfirmingBankAccounts.SetAmountUsed;
                TotalUsed += QBConfirmingBankAccounts."Amount Disposed";
            UNTIL (QBConfirmingBankAccounts.NEXT = 0);

        QBConfirmingLines."Amount Disposed" := TotalUsed;
        QBConfirmingLines.MODIFY;

        IF (CloseDialog) THEN BEGIN
            Window.CLOSE;
            WindowsOpen := FALSE;
        END;
    END;

    PROCEDURE CalculateConfirmingAmounts(): Boolean;
    VAR
        QBConfirmingLines: Record 7206946;
        Txt001: TextConst ESP = 'Ha sobrepasado el l�mite de la l�nea de confirming, disponible %1, en esta relaci�n %2';
        n1: Integer;
        n2: Integer;
    BEGIN
        //JAV 23/09/20: - Recalcular por completo la l�nea de confirming
        IF (NOT IsConfirmingActive) THEN
            EXIT;

        WindowsOpen := FALSE;

        QBConfirmingLines.RESET;
        n1 := QBConfirmingLines.COUNT;
        n2 := 0;
        IF (QBConfirmingLines.FINDSET(TRUE)) THEN
            REPEAT
                n2 += 1;
                CalculateConfirmingLine(QBConfirmingLines, (n1 = n2));
            UNTIL (QBConfirmingLines.NEXT = 0);
    END;

    PROCEDURE VerifyConfirmingLimit(pPaymentOrder: Code[20]; pError: Boolean): Boolean;
    VAR
        PaymentOrder: Record 7000020;
        QBConfirmingLines: Record 7206946;
        QBConfirmingBankAccounts: Record 7206947;
        TotalUsed: Decimal;
        txt: Text;
    BEGIN
        //JAV 23/09/20: - Verificar si se ha sobrepasado la l�nea de confirming
        IF (NOT IsConfirmingActive) THEN
            EXIT;
        IF NOT PaymentOrder.GET(pPaymentOrder) THEN
            EXIT;
        IF (NOT QBConfirmingLines.GET(PaymentOrder."Confirming Line")) THEN
            EXIT;

        WindowsOpen := FALSE;
        CalculateConfirmingLine(QBConfirmingLines, TRUE);

        PaymentOrder.CALCFIELDS(Amount);
        IF (QBConfirmingLines."Amount Limit" < QBConfirmingLines."Amount Disposed" + PaymentOrder.Amount) THEN BEGIN
            txt := STRSUBSTNO(Txt005, QBConfirmingLines."Amount Limit" - QBConfirmingLines."Amount Disposed", PaymentOrder.Amount);
            IF pError THEN
                ERROR(txt)
            ELSE
                MESSAGE(txt);
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------------- Factoring"();
    BEGIN
    END;

    PROCEDURE AddToBillGroup(VAR PostedCarteraDoc: Record 7000003; VAR BillGroup: Record 7000005);
    VAR
        PostedPaymentOrder: Record 7000021;
    BEGIN
        //JAV 23/09/20: - A�adir informaci�n de la l�nea de confirming al documento en la orden de pago registrada
        IF (IsFactoringActive) AND (BillGroup.Factoring <> BillGroup.Factoring::" ") THEN
            BillGroup."Factoring Line" := BillGroup."Factoring Line"
        ELSE
            BillGroup."Factoring Line" := '';
    END;

    PROCEDURE CalculateFactoringLine(VAR QBFactoringLines: Record 7206948; CloseDialog: Boolean): Boolean;
    VAR
        QBFactoringBankAccount: Record 7206949;
        QBFactoringCustomer: Record 7206950;
        TotalUsed: Decimal;
        Txt001: TextConst ESP = 'Ha sobrepasado el l�mite de la l�nea de confirming, disponible %1, en esta relaci�n %2';
    BEGIN
        //JAV 23/09/20: - Calcular los importes de una l�nea de factoring
        IF (NOT IsFactoringActive) THEN
            EXIT;

        IF (NOT WindowsOpen) THEN
            Window.OPEN(Txt007);
        WindowsOpen := TRUE;

        Window.UPDATE(1, QBFactoringBankAccount."Factoring Line");

        //Calculo por bancos
        TotalUsed := 0;
        QBFactoringBankAccount.RESET;
        QBFactoringBankAccount.SETRANGE("Factoring Line", QBFactoringLines.Code);
        IF (QBFactoringBankAccount.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(2, QBFactoringBankAccount.Company);
                Window.UPDATE(3, Txt001 + ' ' + QBFactoringBankAccount."Bank Account");
                QBFactoringBankAccount.SetAmountUsed;
                TotalUsed += QBFactoringBankAccount."Amount Disposed";
            UNTIL (QBFactoringBankAccount.NEXT = 0);

        QBFactoringLines."Amount Disposed" := TotalUsed;
        QBFactoringLines.MODIFY;

        //Calculo por clientes
        TotalUsed := 0;
        QBFactoringCustomer.RESET;
        QBFactoringCustomer.SETRANGE("Factoring Line", QBFactoringLines.Code);
        IF (QBFactoringCustomer.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(2, QBFactoringCustomer."VAT Registration No.");
                Window.UPDATE(3, Txt002 + ' ' + QBFactoringCustomer.Company);
                QBFactoringCustomer.SetAmountUsed;
                TotalUsed += QBFactoringCustomer."Amount Disposed";
            UNTIL (QBFactoringCustomer.NEXT = 0);


        IF (CloseDialog) THEN BEGIN
            Window.CLOSE;
            WindowsOpen := FALSE;
        END;
    END;

    PROCEDURE CalculateFactoringAmounts(): Boolean;
    VAR
        QBFactoringLines: Record 7206948;
        Txt001: TextConst ESP = 'Ha sobrepasado el l�mite de la l�nea de confirming, disponible %1, en esta relaci�n %2';
        n1: Integer;
        n2: Integer;
    BEGIN
        //JAV 23/09/20: - Recalcular por completo la l�nea de Factoring
        IF (NOT IsFactoringActive) THEN
            EXIT;

        WindowsOpen := FALSE;

        QBFactoringLines.RESET;
        n1 := QBFactoringLines.COUNT;
        n2 := 0;
        IF (QBFactoringLines.FINDSET(TRUE)) THEN
            REPEAT
                n2 += 1;
                CalculateFactoringLine(QBFactoringLines, (n1 = n2));
            UNTIL (QBFactoringLines.NEXT = 0);
    END;

    PROCEDURE VerifyFactoringLimit(pBillGroup: Code[20]; pError: Boolean): Boolean;
    VAR
        BillGroup: Record 7000005;
        CarteraDoc: Record 7000002;
        tmpCarteraDoc: Record 7000002 TEMPORARY;
        QBFactoringLines: Record 7206948;
        QBFactoringBankAccount: Record 7206949;
        QBFactoringCustomer: Record 7206950;
        Customer: Record 18;
        TotalUsed: Decimal;
        txt: Text;
    BEGIN
        //JAV 23/09/20: - Verificar si se ha sobrepasado la l�nea de Factoring
        IF (NOT IsFactoringActive) THEN
            EXIT;
        IF NOT BillGroup.GET(pBillGroup) THEN
            EXIT;
        IF (NOT QBFactoringLines.GET(BillGroup."Factoring Line")) THEN
            EXIT;

        WindowsOpen := FALSE;
        CalculateFactoringLine(QBFactoringLines, TRUE);

        //Verificar por total del banco
        BillGroup.CALCFIELDS(Amount);
        IF (QBFactoringLines."Amount Limit" < QBFactoringLines."Amount Disposed" + BillGroup.Amount) THEN BEGIN
            txt := STRSUBSTNO(Txt003, QBFactoringLines."Amount Limit" - QBFactoringLines."Amount Disposed", BillGroup.Amount, BillGroup."Bank Account No.");
            IF pError THEN
                ERROR(txt)
            ELSE
                MESSAGE(txt);
        END;

        //Verificar por total del cliente
        tmpCarteraDoc.RESET;
        tmpCarteraDoc.DELETEALL;

        CarteraDoc.RESET;
        CarteraDoc.SETCURRENTKEY(Type, "Bill Gr./Pmt. Order No.", "Transfer Type", "Account No.");
        CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", BillGroup."No.");
        IF (CarteraDoc.FINDSET(TRUE)) THEN
            REPEAT
                IF (tmpCarteraDoc.GET(CarteraDoc.Type, CarteraDoc."Entry No.")) THEN BEGIN
                    tmpCarteraDoc."Remaining Amount" += CarteraDoc."Remaining Amount";
                    tmpCarteraDoc.MODIFY;
                END ELSE BEGIN
                    tmpCarteraDoc := CarteraDoc;
                    CLEAR(tmpCarteraDoc."Transfer Type"); //No me sirve para nada este campo, pero est� en la clave del est�ndar y no quiero crear otra
                    tmpCarteraDoc.INSERT;
                END;
                //Poner el importe no cubierto por el riesgo
                Customer.GET(tmpCarteraDoc."Account No.");
                IF (QBFactoringCustomer.GET(BillGroup."Factoring Line", Customer."VAT Registration No.", '', '')) THEN BEGIN

                END;
            UNTIL (CarteraDoc.NEXT = 0);

        tmpCarteraDoc.RESET;
        tmpCarteraDoc.SETCURRENTKEY(Type, "Bill Gr./Pmt. Order No.", "Transfer Type", "Account No.");
        IF (tmpCarteraDoc.FINDSET) THEN
            REPEAT
                Customer.GET(tmpCarteraDoc."Account No.");
                IF (QBFactoringCustomer.GET(BillGroup."Factoring Line", Customer."VAT Registration No.", '', '')) THEN BEGIN
                    IF (QBFactoringCustomer."Amount Limit" < QBFactoringCustomer."Amount Disposed" + tmpCarteraDoc."Remaining Amount") THEN BEGIN
                        txt := STRSUBSTNO(Txt004, QBFactoringCustomer."Amount Limit" - QBFactoringCustomer."Amount Disposed", tmpCarteraDoc."Remaining Amount", CarteraDoc."Account No.");
                        IF pError THEN
                            ERROR(txt)
                        ELSE
                            MESSAGE(txt);
                    END;
                END;
            UNTIL (tmpCarteraDoc.NEXT = 0);
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------------------ Recircular documentos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, OnBeforeCheckSalesDocNoIsNotUsed, '', true, true)]
    LOCAL PROCEDURE CU11_OnBeforeCheckSalesDocNoIsNotUsed(DocType: Option; DocNo: Code[20]; VAR IsHandled: Boolean);
    VAR
        GenJournalLine: Record 81;
        CustLedgerEntry: Record 21;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Si estamos recirculando omitir verificaci�n del nro de documento repetido en ventas
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 04/04/22: - QB 1.10.31 Como el asiento es una tabla temporal buscamos la factura registrada para ver su �ltimo estado, si est� en cartera registrada o cerrada estamos repitiendo el n�mero
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Document No.", DocNo);
        IF (CustLedgerEntry.FINDLAST) THEN
            IsHandled := (CustLedgerEntry."Document Situation" IN [CustLedgerEntry."Document Situation"::"Closed BG/PO", CustLedgerEntry."Document Situation"::"Posted BG/PO"]);
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, OnBeforeCheckPurchDocNoIsNotUsed, '', true, true)]
    LOCAL PROCEDURE CU11_OnBeforeCheckPurchDocNoIsNotUsed(DocType: Option; DocNo: Code[20]; VAR IsHandled: Boolean);
    VAR
        GenJournalLine: Record 81;
        VendorLedgerEntry: Record 25;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Si estamos recirculando omitir verificaci�n del nro de documento repetido en compras
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 04/04/22: - QB 1.10.31 Como el asiento es una tabla temporal buscamos la factura registrada para ver su �ltimo estado, si est� en cartera registrada o cerrada estamos repitiendo el n�mero
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SETRANGE("Document No.", DocNo);
        IF (VendorLedgerEntry.FINDLAST) THEN
            IsHandled := (VendorLedgerEntry."Document Situation" IN [VendorLedgerEntry."Document Situation"::"Closed BG/PO", VendorLedgerEntry."Document Situation"::"Posted BG/PO"]);
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeCheckPurchExtDocNo, '', true, true)]
    PROCEDURE CU12_OnBeforeCheckPurchExtDocNo(GenJournalLine: Record 81; VendorLedgerEntry: Record 25; CVLedgerEntryBuffer: Record 382; VAR Handled: Boolean);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Si estamos recirculando omitir verificaci�n del nro de documento repetido documento externo de compras
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //INESCO Q16712 (EPV) Permitir Recircular facturas a Cartera en �rdenes de pago registrada

        IF GenJournalLine."QB Redrawing" THEN
            Handled := TRUE;
    END;

    // [EventSubscriber(ObjectType::Report, 7000083, OnBeforeInsertGenJnlLine, '', true, true)]
    LOCAL PROCEDURE RP7000083_OnBeforeInsertGenJnlLine(VAR GenJournalLine: Record 81; VendorLedgerEntry: Record 25; NewPaymentMethod: Code[10]);
    VAR
        PaymentMethod: Record 289;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Se a�aden funciones para recircular documentos en �rdenes de pago registradas como factura en lugar de efecto
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //A partir de QIN INESCO 2018

        //Busco la forma de pago del diario, ser� la nueva si est� informada o la original si no lo est�
        IF NOT PaymentMethod.GET(GenJournalLine."Payment Method Code") THEN
            ERROR(PMError);

        IF (PaymentMethod."Invoices to Cartera") THEN BEGIN
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
            GenJournalLine.Description := STRSUBSTNO(NewDes, VendorLedgerEntry."Document No.");
            GenJournalLine."QB Redrawing" := TRUE;
        END;
    END;

    // [EventSubscriber(ObjectType::Report, 7000096, OnBeforeGenJnlLineInsert, '', true, true)]
    LOCAL PROCEDURE RP7000082_OnBeforeInsertGenJnlLine(VAR GenJournalLine: Record 81; CustLedgerEntry: Record 21; VAR NewPaymentMethod: Code[10]);
    VAR
        PaymentMethod: Record 289;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Se a�aden funciones para recircular documentos en remesas registradas como factura en lugar de efecto
        //--------------------------------------------------------------------------------------------------------------------------------------------------

        //Busco la forma de pago del diario, ser� la nueva si est� informada o la original si no lo est�
        IF NOT PaymentMethod.GET(GenJournalLine."Payment Method Code") THEN
            ERROR(PMError);

        IF (PaymentMethod."Invoices to Cartera") THEN BEGIN
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
            GenJournalLine.Description := STRSUBSTNO(NewDes, CustLedgerEntry."Document No.");
            GenJournalLine."QB Redrawing" := TRUE;
        END;
    END;

    PROCEDURE RedrawVendorPostedDoc(VAR PostedDoc: Record 7000003);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Esta funci�n recircula documentos a pagar en cartera regitrados, tanto facturas como efectos
        //--------------------------------------------------------------------------------------------------------------------------------------------------

        IF NOT PostedDoc.FIND('=><') THEN
            EXIT;

        PostedDoc.SETFILTER(Status, '<>%1', PostedDoc.Status::Open);
        IF (PostedDoc.ISEMPTY) THEN
            ERROR(Text1100004 + Text1100005);

        PostedDoc.SETFILTER("Document Type", '<>%1 & <>%2', PostedDoc."Document Type"::Bill, PostedDoc."Document Type"::Invoice);
        IF (NOT PostedDoc.ISEMPTY) THEN
            ERROR(Text1100006);
        PostedDoc.SETRANGE("Document Type");

        PostedDoc.SETRANGE(Redrawn, TRUE);
        IF (NOT PostedDoc.ISEMPTY) THEN
            ERROR(Text1100007);
        PostedDoc.SETRANGE(Redrawn);

        VendLedgEntry.RESET;
        REPEAT
            VendLedgEntry.GET(PostedDoc."Entry No.");
            VendLedgEntry.MARK(TRUE);
        UNTIL PostedDoc.NEXT = 0;

        VendLedgEntry.MARKEDONLY(TRUE);
        // REPORT.RUNMODAL(REPORT::"Redraw Payable Bills", TRUE, FALSE, VendLedgEntry);
    END;

    PROCEDURE RedrawVendorClosedDoc(VAR ClosedDoc: Record 7000004);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Esta funci�n recircula documentos a pagar en cartera cerrados, tanto facturas como efectos
        //--------------------------------------------------------------------------------------------------------------------------------------------------

        IF NOT ClosedDoc.FIND('=><') THEN
            EXIT;

        ClosedDoc.SETFILTER("Document Type", '<>%1 & <>%2', ClosedDoc."Document Type"::Bill, ClosedDoc."Document Type"::Invoice);
        IF (NOT ClosedDoc.ISEMPTY) THEN
            ERROR(Text1100006);
        ClosedDoc.SETRANGE("Document Type");

        ClosedDoc.SETRANGE(Redrawn, TRUE);
        IF (NOT ClosedDoc.ISEMPTY) THEN
            ERROR(Text1100007);
        ClosedDoc.SETRANGE(Redrawn);

        VendLedgEntry.RESET;
        REPEAT
            VendLedgEntry.GET(ClosedDoc."Entry No.");
            VendLedgEntry.MARK(TRUE);
        UNTIL ClosedDoc.NEXT = 0;

        VendLedgEntry.MARKEDONLY(TRUE);
        // REPORT.RUNMODAL(REPORT::"Redraw Payable Bills", TRUE, FALSE, VendLedgEntry);
    END;

    PROCEDURE RedrawCustomerPostedDoc(VAR PostedDoc: Record 7000003);
    VAR
        CustLedgerEntry: Record 21;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Esta funci�n recircula documentos a cobrar en cartera regitrados, tanto facturas como efectos
        //--------------------------------------------------------------------------------------------------------------------------------------------------

        IF NOT PostedDoc.FIND('=><') THEN
            EXIT;

        PostedDoc.SETFILTER(Status, '<>%1', PostedDoc.Status::Open);
        IF (PostedDoc.ISEMPTY) THEN
            ERROR(Text1100004 + Text1100005);

        PostedDoc.SETFILTER("Document Type", '<>%1 & <>%2', PostedDoc."Document Type"::Bill, PostedDoc."Document Type"::Invoice);
        IF (NOT PostedDoc.ISEMPTY) THEN
            ERROR(Text1100006);
        PostedDoc.SETRANGE("Document Type");

        PostedDoc.SETRANGE(Redrawn, TRUE);
        IF (NOT PostedDoc.ISEMPTY) THEN
            ERROR(Text1100007);
        PostedDoc.SETRANGE(Redrawn);

        CustLedgerEntry.RESET;
        REPEAT
            CustLedgerEntry.GET(PostedDoc."Entry No.");
            CustLedgerEntry.MARK(TRUE);
        UNTIL PostedDoc.NEXT = 0;

        CustLedgerEntry.MARKEDONLY(TRUE);
        // REPORT.RUNMODAL(REPORT::"Redraw Receivable Bills", TRUE, FALSE, CustLedgerEntry);
    END;

    PROCEDURE RedrawCustomerClosedDoc(VAR ClosedDoc: Record 7000004);
    VAR
        CustLedgerEntry: Record 21;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 26/03/22: - QB 1.10.28 Esta funci�n recircula documentos a cobrar en cartera cerrados, tanto facturas como efectos
        //--------------------------------------------------------------------------------------------------------------------------------------------------

        IF NOT ClosedDoc.FIND('=><') THEN
            EXIT;

        ClosedDoc.SETFILTER("Document Type", '<>%1 & <>%2', ClosedDoc."Document Type"::Bill, ClosedDoc."Document Type"::Invoice);
        IF (NOT ClosedDoc.ISEMPTY) THEN
            ERROR(Text1100006);
        ClosedDoc.SETRANGE("Document Type");

        ClosedDoc.SETRANGE(Redrawn, TRUE);
        IF (NOT ClosedDoc.ISEMPTY) THEN
            ERROR(Text1100007);
        ClosedDoc.SETRANGE(Redrawn);

        CustLedgerEntry.RESET;
        REPEAT
            CustLedgerEntry.GET(ClosedDoc."Entry No.");
            CustLedgerEntry.MARK(TRUE);
        UNTIL ClosedDoc.NEXT = 0;

        CustLedgerEntry.MARKEDONLY(TRUE);
        // REPORT.RUNMODAL(REPORT::"Redraw Receivable Bills", TRUE, FALSE, CustLedgerEntry);
    END;

    /*BEGIN
/*{
      JAV 23/09/20: - Cambia el vencimiento en un documento de cartera registrado. Manejo de confirming y factoring
      JAV 23/03/22: - QB 1.10.27 Se a�aden funciones para recircular documentos en �rdenes de pago registradas como factura en lugar de efecto. A partir de INESCO.
    }
END.*/
}










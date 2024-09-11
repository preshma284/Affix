Codeunit 7207353 "QB - Codeunit - Subscriber"
{


    Permissions = TableData 21 = rm,
                TableData 25 = rm,
                TableData 112 = rm,
                TableData 114 = rm,
                TableData 122 = rm,
                TableData 124 = rm,
                TableData 7000002 = rm,
                TableData 7207329 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        QBPostPreview: Codeunit 7207359;

    LOCAL PROCEDURE "----------------------------------------- Eventos para la vista previa de registro"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 19, OnAfterBindSubscription, '', true, true)]
    PROCEDURE GenJnlPostPreview_OnAfterBindSubscription();
    BEGIN
        //Activar las subscripciones a la vista previa de registro para QB.
        //OJO Esto no funciona en esta versi�n, lo hace pero luego no est�n activos los eventos, hay que ponerlo directamente en la CU 19

        IF NOT BINDSUBSCRIPTION(QBPostPreview) THEN
            MESSAGE('No he podido activar la CU de vista previa para QuoBuilding');
    END;

    [EventSubscriber(ObjectType::Codeunit, 19, OnAfterUnbindSubscription, '', true, true)]
    PROCEDURE GenJnlPostPreview_OnAfterUnbindSubscription();
    BEGIN
        //Desactivar las subscripciones a la vista previa de registro para QB

        IF NOT UNBINDSUBSCRIPTION(QBPostPreview) THEN
            MESSAGE('No he podido desactivar la CU de vista previa para QuoBuilding');
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 11"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, OnBeforeCheckDocType, '', true, true)]
    LOCAL PROCEDURE OnBeforeCheckDocType_CU11(GenJournalLine: Record 81; VAR IsHandled: Boolean);
    BEGIN
        //PGM 07/10/20: - QB 1.06.20 Provisionar albaranes por tipo Shipment
        IF GenJournalLine."Document Type" = GenJournalLine."Document Type"::Shipment THEN
            IsHandled := TRUE;

        //JAV 13/11/20: - QB 1.07.05 Provisionar Obra en Curso por tipo WIP
        IF GenJournalLine."Document Type" = GenJournalLine."Document Type"::WIP THEN
            IsHandled := TRUE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, OnBeforeRunCheck, '', true, true)]
    LOCAL PROCEDURE OnBeforeRunCheck_CU11(VAR GenJournalLine: Record 81);
    BEGIN
        //JAV 11/08/21: - QB 1.09.16 Usar la variable propia de QB para el proyecto
        IF (GenJournalLine."Document Type" = GenJournalLine."Document Type"::WIP) THEN
            SetLineJobNo(GenJournalLine);

        //++GenJournalLine."Job No." := '';
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, OnAfterCheckGenJnlLine, '', true, true)]
    LOCAL PROCEDURE OnAfterCheckGenJnlLine_CU11(VAR GenJournalLine: Record 81);
    BEGIN
        //JAV 11/08/21: - QB 1.09.16 Usar la variable propia de QB para el proyecto
        IF (GenJournalLine."Document Type" = GenJournalLine."Document Type"::WIP) THEN
            UnSetLineJobNo(GenJournalLine);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 12"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitCustLedgEntry, '', true, true)]
    LOCAL PROCEDURE OnAfterInitCustomerLedgEntry_CU12(VAR CustLedgerEntry: Record 21; GenJournalLine: Record 81);
    BEGIN
        //JAV 27/06/21: - QB 1.09.03 Si se ha guardado el proyecto en la l�nea, me lo guardo en el movimiento de cliente
        IF GenJournalLine."QW WithHolding Job No." <> '' THEN
            CustLedgerEntry."QB Job No." := GenJournalLine."QW WithHolding Job No."
        ELSE IF GenJournalLine."QB Job No." <> '' THEN
            CustLedgerEntry."QB Job No." := GenJournalLine."QB Job No."
        ELSE
            CustLedgerEntry."QB Job No." := GenJournalLine."Job No.";

        //JAV 25/05/22: - QB 1.10.44 Se incluye la partida presupuestaria en el movimiento del cliente
        //JAV 16/06/22: - QB 1.10.50 El campo que se usaba no era el correcto para la unidad de obra/partida presupuestaria
        CustLedgerEntry."QB Budget Item" := GenJournalLine."Piecework Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitVendLedgEntry, '', true, true)]
    LOCAL PROCEDURE OnAfterInitVendLedgEntry_CU12(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    BEGIN
        //JAV 27/06/21: - QB 1.09.03 Si se ha guardado el proyecto en la l�nea, me lo guardo en el movimiento de proveedor
        IF GenJournalLine."QW WithHolding Job No." <> '' THEN
            VendorLedgerEntry."QB Job No." := GenJournalLine."QW WithHolding Job No."
        ELSE IF GenJournalLine."QB Job No." <> '' THEN
            VendorLedgerEntry."QB Job No." := GenJournalLine."QB Job No."
        ELSE
            VendorLedgerEntry."QB Job No." := GenJournalLine."Job No.";

        //JAV 21/10/20: - QB 1.06.21 Me guardo la l�nea de albar�n de origen del movimiento
        VendorLedgerEntry."QB Shipment Line No" := GenJournalLine."Shipment Line No";
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnPostGLAccOnBeforeInsertGLEntry, '', true, true)]
    LOCAL PROCEDURE OnPostGLAccOnBeforeInsertGLEntry_CU12(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR IsHandled: Boolean);
    BEGIN
        IF (GLEntry."Job No." = '') THEN
            IF GenJournalLine."QW WithHolding Job No." <> '' THEN
                GLEntry."Job No." := GenJournalLine."QW WithHolding Job No."
            ELSE
                GLEntry."Job No." := GenJournalLine."Job No.";

        //JAV 16/06/22: - QB 1.10.50 Pasar la unidad de obra al movimiento contable
        GLEntry."QB Piecework Code" := GenJournalLine."Piecework Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeVendUnrealizedVAT, '', true, true)]
    LOCAL PROCEDURE OnBeforeVendUnrealizedVAT_CU12(VAR GenJnlLine: Record 81; VAR VendorLedgerEntry: Record 25; SettledAmount: Decimal; VAR IsHandled: Boolean);
    VAR
        VendLedgEntry3: Record 25;
    BEGIN
        //Para la migraci�n, si no existe la factura salir sin mas
        VendLedgEntry3.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
        VendLedgEntry3.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendLedgEntry3.SETRANGE("Document No.", VendorLedgerEntry."Document No.");
        IsHandled := VendLedgEntry3.ISEMPTY; //Si no existe la factura, no procesar el IVA no realizado
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitGLEntry, '', true, true)]
    PROCEDURE OnAfterInitGLEntry_CU12(VAR GLEntry: Record 17; GenJournalLine: Record 81);
    VAR
        Vendor: Record 23;
        VendorPostingGroup: Record 93;
        Job: Record 167;
        JobPostingGroup: Record 208;
        GLAccount: Record 15;
    BEGIN
        //PGM 07/10/20: - QB 1.06.20 Tomar el valor de la cuenta para "Albaranes pendiente de recibir" cuando el asiento va contra Proveedor y es de tipo Albaran
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) AND (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Shipment) THEN BEGIN
            Vendor.GET(GenJournalLine."Account No.");
            IF VendorPostingGroup.GET(Vendor."Vendor Posting Group") THEN
                GLEntry."G/L Account No." := VendorPostingGroup."Acct. Purch. Rcpt Pending Inv.";
        END;

        //JAV 13/11/20: - QB 1.07.05 Tomar el valor de la cuenta para "Obra en Curso" cuando el asiento va contra Cliente y es de tipo WIP
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) AND (GenJournalLine."Document Type" = GenJournalLine."Document Type"::WIP) THEN BEGIN
            IF (GenJournalLine."QB Job No." <> '') THEN   //JAV 11/08/21: - QB 1.09.16 Usar la variable propia de QB para el proyecto que siempre estar� informada
                Job.GET(GenJournalLine."QB Job No.")
            ELSE
                Job.GET(GenJournalLine."Job No.");
            IF JobPostingGroup.GET(Job."Job Posting Group") THEN
                GLEntry."G/L Account No." := JobPostingGroup."Cont. Acc. Job in Progress(+)"
        END;

        //JAV 17/06/22: - QB 1.10.50 Si el asiento no tiene proyecto eliminamos unidad de obra/partida
        IF (GLEntry."Job No." = '') THEN
            GLEntry."QB Piecework Code" := '';
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInsertDtldVendLedgEntry, '', true, true)]
    LOCAL PROCEDURE OnBeforeInsertDtldVendLedgEntry_CU12(VAR DtldVendLedgEntry: Record 380; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383);
    VAR
        FunctionQB: Codeunit 7207272;
        VendorLedgerEntry: Record 25;
        PurchRcptHeader: Record 120;
    BEGIN
        //JAV 09/10/20: - QB 1.06.20 Cambio el evento propio "InheritFieldsDetailedVendorGenJnlPostLine" por el evento est�ndar de la CU 12
        //              -            Se traslada a esta funci�n el c�digo de "InheritFieldsVendorDetailed" de la CU 7207273 "Modific. Management" para no hacer dos llamadas

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            DtldVendLedgEntry."QB Expense Note Code" := GenJournalLine."Expense Note Code";

            //JAV 09/10/20: - QB 1.06.20 Marcamos que el movimiento detallado no entra en el c�lculo del saldo del proveedor, por tanto no estar� pendiente tampoco el movimiento del proveedor
            IF (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Shipment) THEN BEGIN
                PurchRcptHeader.GET(DtldVendLedgEntry."Document No.");

                VendorLedgerEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");
                VendorLedgerEntry.Open := FALSE;
                VendorLedgerEntry.VALIDATE("Dimension Set ID", PurchRcptHeader."Dimension Set ID");   //Debe tomar las dimensiones del albar�n
                VendorLedgerEntry.MODIFY;

                DtldVendLedgEntry."Excluded from calculation" := TRUE;
                DtldVendLedgEntry."QB Job No." := VendorLedgerEntry."QB Job No.";
                DtldVendLedgEntry."QB Shipment Line No" := GenJournalLine."Shipment Line No";  //JAV 21/10/20: - QB 1.06.21 Guardarse la l�nea del albar�n de origen
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInsertDtldCustLedgEntry, '', true, true)]
    LOCAL PROCEDURE OnBeforeInsertDtldCustLedgEntry_CU12(VAR DtldCustLedgEntry: Record 379; GenJournalLine: Record 81; DtldCVLedgEntryBuffer: Record 383);
    VAR
        FunctionQB: Codeunit 7207272;
        CustLedgerEntry: Record 21;
    BEGIN
        //JAV 13/11/20: - QB 1.07.05 Marcamos que el movimiento detallado no entra en el c�lculo del saldo del cliente, por tanto no estar� pendiente tampoco el movimiento del cliente
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (GenJournalLine."Document Type" = GenJournalLine."Document Type"::WIP) THEN BEGIN
                CustLedgerEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.");
                CustLedgerEntry.Open := FALSE;
                CustLedgerEntry.MODIFY;

                DtldCustLedgEntry."Excluded from calculation" := TRUE;
                DtldCustLedgEntry."QB Job No." := DtldCustLedgEntry."QB Job No.";
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterGLFinishPosting, '', true, true)]
    LOCAL PROCEDURE OnAfterGLFinishPosting_CU12(GLEntry: Record 17; VAR GenJnlLine: Record 81; IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; VAR GLRegister: Record 45; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    VAR
        GLEntry1: Record 17;
        FunctionQB: Codeunit 7207272;
        DetailedVendorLedgEntry: Record 380;
        Currency: Record 4;
        PurchaseRcptPendingInvoice: Codeunit 7207295;
        AdjustAmount: Decimal;
        RemainingAmount: Decimal;
        TotalAmount: Decimal;
        TLines: Integer;
        NLine: Integer;
        amt: Decimal;
    BEGIN
        //JAV 28/10/20: - QB 1.07.01 Evento tras registrar una l�nea del diario, si es un pago a un proveedor procesar las diferencias de cambio
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) THEN BEGIN
                //Busco el movimiento de ajuste de divisas y su importe
                DetailedVendorLedgEntry.RESET;
                DetailedVendorLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                DetailedVendorLedgEntry.SETFILTER("Entry Type", '%1|%2', DetailedVendorLedgEntry."Entry Type"::"Realized Gain", DetailedVendorLedgEntry."Entry Type"::"Realized Loss");
                IF (NOT DetailedVendorLedgEntry.FINDFIRST) THEN
                    EXIT;

                AdjustAmount := DetailedVendorLedgEntry."Amount (LCY)";
                RemainingAmount := AdjustAmount;
                //Leo la divisa
                Currency.GET(DetailedVendorLedgEntry."Currency Code");
                Currency.InitRoundingPrecision;

                //Busco los movimientos que se han liquidado
                DetailedVendorLedgEntry.RESET;
                DetailedVendorLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                DetailedVendorLedgEntry.SETFILTER("Vendor Ledger Entry No.", '<>%1', DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
                TotalAmount := DetailedVendorLedgEntry."Amount (LCY)";
                IF (TotalAmount = 0) THEN
                    EXIT;

                //Busco la cuenta de las diferencias
                GLEntry1.RESET;
                GLEntry1.SETRANGE("Document No.", GLEntry."Document No.");
                GLEntry1.SETRANGE("Posting Date", GLEntry."Posting Date");
                GLEntry1.SETFILTER("G/L Account No.", '%1|%2', Currency."Realized Gains Acc.", Currency."Realized Losses Acc.");
                IF (NOT GLEntry1.FINDFIRST) THEN
                    EXIT;

                TLines := DetailedVendorLedgEntry.COUNT;
                NLine := 0;
                IF (DetailedVendorLedgEntry.FINDSET) THEN
                    REPEAT
                        NLine += 1;
                        IF (NLine = TLines) THEN
                            amt := RemainingAmount
                        ELSE
                            amt := ROUND(AdjustAmount * DetailedVendorLedgEntry."Amount (LCY)" / TotalAmount, Currency."Amount Rounding Precision");
                        RemainingAmount -= amt;
                        PurchaseRcptPendingInvoice.JobJournalExchangesDif(DetailedVendorLedgEntry, GLEntry."Document No.", amt, GLEntry1."G/L Account No.");
                    UNTIL DetailedVendorLedgEntry.NEXT = 0;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeCode, '', true, true)]
    LOCAL PROCEDURE CU12_OnBeforeCode(VAR GenJnlLine: Record 81; CheckLine: Boolean; VAR IsPosted: Boolean; VAR GLReg: Record 45);
    BEGIN
        //JAV 27/06/21: - QB 1.09.03 Guardarse el c�digo del proyecto en la variable auxiliar y eliminarla si la l�nes es de tipo cliente o proveedor
        SetLineJobNo(GenJnlLine);
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitVendLedgEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnAfterInitVendLedgEntry(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------
        //JAV 25/05/22: - QB 1.10.44 Rellenar datos en el movimiento del proveedor
        //-------------------------------------------------------------------------------------------------------------
        //JAV 25/05/22: - QB 1.10.44 Se elimina la funci�n InheritFieldVendor y la funci�n FunInheritFieldVendor de la CU 7207273, en su lugar se captura el evento OnAfterInitVendLedgEntry de la CU 12
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN  //JAV 25/05/22: - QB 1.10.44 Se amplia a RE y QPR
            VendorLedgerEntry."QB Expense Note Code" := GenJournalLine."Expense Note Code";

            //JAV 25/05/22: - QB 1.10.44 Se incluye la partida presupuestaria en el movimiento del proveedor
            //JAV 16/06/22: - QB 1.10.50 El campo que se usaba no era el correcto para la unidad de obra/partida presupuestaria
            VendorLedgerEntry."QB Budget Item" := GenJournalLine."Piecework Code";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforePostGenJnlLine, '', true, true)]
    LOCAL PROCEDURE OnBeforePostGenJnlLine_CU12(VAR GenJournalLine: Record 81; Balancing: Boolean);
    VAR
        RecSource: Record 242;
    BEGIN
        //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. -
        IF NOT (Balancing) THEN EXIT;

        RecSource.GET;

        IF (GenJournalLine."Source Code" = RecSource."QW Withholding Releasing")
        AND (GenJournalLine."QW Withholding Type" = GenJournalLine."QW Withholding Type"::"G.E")
        AND ((GenJournalLine."Source Type" = GenJournalLine."Source Type"::Vendor) OR (GenJournalLine."Source Type" = GenJournalLine."Source Type"::Customer))
        THEN BEGIN
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
            GenJournalLine."Bill No." := '';
        END;
        //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. +
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 13"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 13, OnBeforeCode, '', true, true)]
    LOCAL PROCEDURE CU13_OnBeforeCode(VAR GenJournalLine: Record 81; PreviewMode: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
        //JAV 27/06/21: - QB 1.09.03 Guardarse el c�digo del proyecto en la variable auxiliar y eliminarla si la l�nes es de tipo cliente o proveedor
        SetLineJobNo(GenJournalLine);
    END;

    LOCAL PROCEDURE SetLineJobNo(VAR GenJournalLine: Record 81);
    BEGIN
        //JAV 27/06/21: - QB 1.09.03 Guardarse el c�digo del proyecto en la variable auxiliar y eliminarla si la l�nes es de tipo cliente o proveedor
        IF (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]) THEN BEGIN
            IF (GenJournalLine."QB Job No." = '') THEN
                GenJournalLine."QB Job No." := GenJournalLine."Job No.";

            //++GenJournalLine."Job No." := '';
            IF GenJournalLine.MODIFY THEN; //Si existe me la guardo
        END;
    END;

    LOCAL PROCEDURE UnSetLineJobNo(VAR GenJournalLine: Record 81);
    BEGIN
        //JAV 27/06/21: - QB 1.09.03 Guardarse el c�digo del proyecto en la variable auxiliar y eliminarla si la l�nes es de tipo cliente o proveedor
        IF (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]) THEN BEGIN
            IF (GenJournalLine."QB Job No." <> '') THEN BEGIN
                GenJournalLine."Job No." := GenJournalLine."QB Job No.";
                IF GenJournalLine.MODIFY THEN; //Si existe me la guardo
            END;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 74"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnBeforeTransferLineToPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforeTransferLineToPurchaseDoc_CU74(VAR PurchRcptHeader: Record 120; VAR PurchRcptLine: Record 121; VAR PurchaseHeader: Record 38; VAR TransferLine: Boolean);
    BEGIN
        //JAV 28/10/20: - QB 1.07.01 Poner el proyecto en la cabecera si no lo tiene informado
        IF (PurchaseHeader."QB Job No." <> '') OR (PurchRcptLine."Job No." = '') THEN
            EXIT;

        PurchaseHeader."QB Job No." := PurchRcptLine."Job No.";
        PurchaseHeader.MODIFY;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 80"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostCustomerEntry, '', true, true)]
    LOCAL PROCEDURE OnBeforePostCustomerEntry_CU80(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
        GenJnlLine."Job No." := SalesHeader."QB Job No.";

        //JAV 25/11/21: - QBPostPreview 1.10.01 A�ado el banco
        GenJnlLine."QB Payment Bank No." := SalesHeader."QB Payment Bank No.";   //Q8960

        //JAV 25/05/22: - QB 1.10.44 Se a�ade la partida presupuestaria en el diario desde el documento de cliente o de proveedor
        //JAV 16/06/22: - QB 1.10.50 El campo que se usaba no era el correcto para la unidad de obra/partida presupuestaria
        GenJnlLine."Piecework Code" := SalesHeader."QB Budget item";
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnPostSalesLineOnBeforeTestJobNo, '', true, true)]
    LOCAL PROCEDURE OnPostSalesLineOnBeforeTestJobNo_CU80(SalesLine: Record 37; VAR IsHandled: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IsHandled := TRUE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterCheckMandatoryFields, '', true, true)]
    LOCAL PROCEDURE OnAfterCheckMandatoryFields_CU80(VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        GLAccount: Record 15;
        FunctionQB: Codeunit 7207272;
        SalesLine: Record 37;
    BEGIN
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT;

        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Skip Required Project" THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER(SalesLine.Type, '<>%1', SalesLine.Type::"Fixed Asset");
        IF SalesLine.FINDSET(FALSE) THEN
            REPEAT
                IF SalesLine.Type <> SalesLine.Type::" " THEN BEGIN
                    IF SalesLine.Type = SalesLine.Type::"G/L Account" THEN BEGIN
                        IF GLAccount.GET(SalesLine."No.") THEN BEGIN
                            IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                                SalesLine.TESTFIELD("Job No.");
                            END;
                        END;
                    END ELSE BEGIN
                        SalesLine.TESTFIELD("Job No.");
                    END;
                END
            UNTIL SalesLine.NEXT = 0;
    END;

    PROCEDURE EmptyJobEntry_CU80(VAR ModificManagement: Codeunit 7207273);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            ModificManagement.EmptyJobEntry;
    END;

    PROCEDURE ExitIfJobExist_CU80(salesLine: Record 37; VAR leave: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF salesLine."Job No." <> '' THEN
                leave := TRUE;
    END;

    PROCEDURE UpdateInvoicedCert_CU80(VAR SalesLine: Record 37; SalesDocumentNo: Code[20]; SalesDocumentPostingDate: Date);
    VAR
        FunctionQB: Codeunit 7207272;
        PostCert: Codeunit 7207278;
    BEGIN
        //JAV 11/12/20: - QB 1.07.11 Se a�ade el manejo de la obra en curso

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            PostCert.FunActInvoicedCertification(SalesLine, SalesDocumentNo, SalesDocumentPostingDate);
            PostCert.FunActInvoicedWIP(SalesLine, SalesDocumentNo, SalesDocumentPostingDate);
        END;
    END;

    PROCEDURE UpdateInvoicedCertAndMilestone_CU80(VAR SalesLine: Record 37; SalesDocumentNo: Code[20]; SalesDocumentPostingDate: Date);
    VAR
        FunctionQB: Codeunit 7207272;
        PostCertification: Codeunit 7207278;
        InvoiceMilestone: Record 7207331;
    BEGIN
        //JAV 11/12/20: - QB 1.07.11 Se llama a la funci�n UpdateInvoicedCert_CU80 en lugar de directamente a PostCert.FunActInvoicedCertification, as� solo hay una funci�n
        //                           que ejecute el registro.

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            UpdateInvoicedCert_CU80(SalesLine, SalesDocumentNo, SalesDocumentPostingDate);

            InvoiceMilestone.RESET;
            InvoiceMilestone.SETRANGE(InvoiceMilestone."Job No.", SalesLine."Job No.");
            InvoiceMilestone.SETRANGE(InvoiceMilestone."Milestone No.", SalesLine."QB Milestone No.");
            IF InvoiceMilestone.FINDFIRST THEN BEGIN
                InvoiceMilestone."Posted Invoice No." := SalesDocumentNo;
                InvoiceMilestone.MODIFY;
            END;
        END;
    END;

    PROCEDURE GenerateConsumptionOfJob_CU80(SalesHeader: Record 36; Ship: Boolean; Receive: Boolean; VAR ModificManagement: Codeunit 7207273);
    VAR
        FunctionQB: Codeunit 7207272;
        OutputShipmentHeader: Record 7207308;
        SalesHeader2: Record 36;
        // RealizeConsumption: Report 7207290;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            ModificManagement.UnqueueJobEntry;

        IF Ship OR Receive THEN BEGIN
            IF OutputShipmentHeader.READPERMISSION THEN
                IF FunctionQB.AccessToQuobuilding THEN BEGIN
                    // CLEAR(RealizeConsumption);
                    SalesHeader2.RESET;
                    SalesHeader2.COPYFILTERS(SalesHeader);
                    SalesHeader2.SETRANGE("Document Type", SalesHeader."Document Type");
                    SalesHeader2.SETRANGE("No.", SalesHeader."No.");
                    // RealizeConsumption.SETTABLEVIEW(SalesHeader2);
                    // RealizeConsumption.USEREQUESTPAGE(FALSE);
                    // RealizeConsumption.RUNMODAL;
                END;
        END;
    END;

    PROCEDURE ModifyGenJnlLine_CU80(VAR GenJnlLine: Record 81; SalesHeader: Record 36; invPostingBufferJobNo: Code[20]);
    VAR
        ModificManagement: Codeunit 7207273;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            ModificManagement.UpdateSalesLine(GenJnlLine);
            GenJnlLine."Job Sale Doc. Type" := SalesHeader."QB Job Sale Doc. Type";
            GenJnlLine."Job No." := invPostingBufferJobNo;
        END;
    END;

    PROCEDURE PostJobManual_CU80(SalesLine: Record 37; SalesHeader: Record 36; SalesInvHeaderNo: Code[20]; SalesCrMemoNo: Code[20]; VAR ModificManagement: Codeunit 7207273);
    VAR
        FunctionQB: Codeunit 7207272;
        JobPostLine: Codeunit 1001;
    BEGIN
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT;

        IF SalesLine."Job Contract Entry No." <> 0 THEN
            EXIT;

        IF SalesLine.Type = SalesLine.Type::" " THEN
            EXIT;

        IF SalesLine."No." = '' THEN
            EXIT;

        IF SalesLine."Job No." = '' THEN
            EXIT;

        SalesLine.TESTFIELD("Job No.");

        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
            SalesLine."Document No." := SalesInvHeaderNo;
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
            SalesLine."Document No." := SalesCrMemoNo;

        SaleInvoiceJobManual(SalesHeader, SalesLine, ModificManagement);
    END;

    LOCAL PROCEDURE SaleInvoiceJobManual(SalesHeader: Record 36; SalesLine: Record 37; VAR ModificManagement: Codeunit 7207273);
    VAR
        FunctionQB: Codeunit 7207272;
        JobJnlLine: Record 210;
        SourceCodeSetup: Record 242;
        JobTask: Record 1001;
        GLSetup: Record 98;
        recCurrency: Record 4;
    BEGIN
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT;

        IF NOT SalesHeader.Invoice THEN
            EXIT;
        IF (SalesLine."Job No." <> '') AND (SalesLine."Qty. to Invoice" <> 0) AND
           (SalesLine."Job Contract Entry No." = 0) THEN BEGIN

            JobJnlLine.INIT;
            JobJnlLine."Posting Date" := SalesHeader."Posting Date";
            JobJnlLine."Document Date" := SalesHeader."Document Date";
            JobJnlLine."Country/Region Code" := SalesHeader."VAT Country/Region Code";
            JobJnlLine."Reason Code" := SalesHeader."Reason Code";
            JobJnlLine."Job No." := SalesLine."Job No.";
            JobJnlLine."No." := SalesLine."No.";
            JobJnlLine."Variant Code" := SalesLine."Variant Code";
            JobJnlLine.Description := SalesLine.Description;
            JobJnlLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
            JobJnlLine."Location Code" := SalesLine."Location Code";
            JobJnlLine."Posting Group" := SalesLine."Posting Group";
            JobJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
            JobJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            JobJnlLine."Work Type Code" := SalesLine."Work Type Code";
            JobJnlLine."Job Task No." := SalesLine."Job Task No.";
            IF JobTask.GET(SalesLine."Job No.", SalesLine."Job Task No.") THEN
                JobJnlLine."Posting Group" := JobTask."Job Posting Group";

            JobJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
            JobJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
            JobJnlLine."Transaction Type" := SalesLine."Transaction Type";
            JobJnlLine."Transport Method" := SalesLine."Transport Method";
            JobJnlLine."Entry/Exit Point" := SalesLine."Exit Point";
            JobJnlLine.Area := SalesLine.Area;
            JobJnlLine."Transaction Specification" := SalesLine."Transaction Specification";
            JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Sale;
            JobJnlLine."Job Posting Only" := TRUE;

            JobJnlLine."Document No." := SalesLine."Document No.";


            SourceCodeSetup.GET;
            JobJnlLine."Source Code" := SourceCodeSetup.Sales;
            JobJnlLine."Post Job Entry Only" := TRUE;
            JobJnlLine."Currency Code" := SalesHeader."Currency Code";
            JobJnlLine."Currency Factor" := SalesHeader."Currency Factor";
            JobJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            JobJnlLine.Type := Enum::"Job Journal Line Type".FromInteger(3 - SalesLine.Type.AsInteger());
            IF JobJnlLine.Type = JobJnlLine.Type::Resource THEN BEGIN
                JobJnlLine.Quantity := SalesLine."Qty. to Invoice";
                JobJnlLine."Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";
                JobJnlLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
            END ELSE BEGIN
                IF (SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") OR
                   (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") THEN BEGIN
                    JobJnlLine.Quantity := SalesLine."Qty. to Invoice";
                    JobJnlLine."Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";
                    JobJnlLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
                END ELSE BEGIN
                    JobJnlLine.Quantity := -SalesLine."Qty. to Invoice";
                    JobJnlLine."Quantity (Base)" := -SalesLine."Qty. to Invoice (Base)";
                    JobJnlLine."Qty. per Unit of Measure" := -SalesLine."Qty. per Unit of Measure";
                END;
            END;
            IF SalesHeader."Currency Code" <> '' THEN BEGIN
                recCurrency.GET(SalesHeader."Currency Code");
                recCurrency.InitRoundingPrecision;
            END;

            JobJnlLine."Direct Unit Cost (LCY)" := SalesLine."Unit Cost (LCY)";
            JobJnlLine."Unit Cost (LCY)" := SalesLine."Unit Cost (LCY)";
            JobJnlLine."Unit Cost" := SalesLine."Unit Cost";

            JobJnlLine."Total Cost" :=
               ROUND(SalesLine."Unit Cost" * JobJnlLine.Quantity, recCurrency."Unit-Amount Rounding Precision");

            JobJnlLine."Total Cost (LCY)" :=
               ROUND(SalesLine."Unit Cost (LCY)" * JobJnlLine.Quantity, GLSetup."Unit-Amount Rounding Precision");

            IF (SalesLine."Currency Code" <> '') OR SalesHeader."Prices Including VAT" THEN
                JobJnlLine."Unit Price" := ROUND(SalesLine.Amount / SalesLine.Quantity, recCurrency."Unit-Amount Rounding Precision")
            ELSE
                JobJnlLine."Unit Price" := SalesLine."Unit Price";

            IF JobJnlLine.Type = JobJnlLine.Type::Resource THEN BEGIN
                JobJnlLine."Total Price" := ROUND(SalesLine."Qty. to Invoice" * JobJnlLine."Unit Price",
                                            recCurrency."Amount Rounding Precision")
            END ELSE BEGIN
                IF (SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") OR
                   (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") THEN
                    JobJnlLine."Total Price" := ROUND(SalesLine."Qty. to Invoice" * JobJnlLine."Unit Price",
                                                recCurrency."Amount Rounding Precision")
                ELSE
                    JobJnlLine."Total Price" := ROUND(-SalesLine."Qty. to Invoice" * JobJnlLine."Unit Price",
                                                recCurrency."Amount Rounding Precision");
            END;
            IF SalesHeader."Currency Code" = '' THEN BEGIN
                JobJnlLine."Unit Price (LCY)" := JobJnlLine."Unit Price";
                JobJnlLine."Total Price (LCY)" := JobJnlLine."Total Price";
            END ELSE BEGIN
                JobJnlLine."Unit Price (LCY)" := ROUND(JobJnlLine."Unit Price" / SalesHeader."Currency Factor",
                                                       GLSetup."Amount Rounding Precision");
                JobJnlLine."Total Price (LCY)" := ROUND(JobJnlLine."Total Price" / SalesHeader."Currency Factor",
                                                           GLSetup."Amount Rounding Precision");
            END;
            IF SalesHeader."Currency Code" <> '' THEN BEGIN
                JobJnlLine."Source Currency Code" := SalesHeader."Currency Code";
                JobJnlLine."Source Currency Total Cost" :=
                   ROUND(SalesLine."Unit Cost" * JobJnlLine.Quantity, recCurrency."Amount Rounding Precision");
                JobJnlLine."Source Currency Total Price" := SalesLine.Amount;
            END;
            JobJnlLine."Job Sale Doc. Type" := SalesHeader."QB Job Sale Doc. Type";

            JobJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";

            ///Se informa el importe linea en base a las l�neas
            JobJnlLine."Line Amount" := JobJnlLine."Unit Price" * JobJnlLine.Quantity;
            JobJnlLine."Line Amount (LCY)" := JobJnlLine."Unit Price (LCY)" * JobJnlLine.Quantity;


            //GAP888
            JobJnlLine."Source Document Type" := JobJnlLine."Source Document Type"::Invoice;
            JobJnlLine."Source Type" := JobJnlLine."Source Type"::Customer;
            JobJnlLine."Source No." := SalesHeader."Sell-to Customer No.";
            JobJnlLine."Source Name" := SalesHeader."Sell-to Customer Name";

            ModificManagement.QueueJobEntry(JobJnlLine);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePurchRcptLineInsert, '', true, true)]
    LOCAL PROCEDURE CU80_OnBeforePurchRcptLineInsert(VAR PurchRcptLine: Record 121; PurchRcptHeader: Record 120; PurchOrderLine: Record 39; DropShptPostBuffer: Record 223; CommitIsSuppressed: Boolean);
    BEGIN
        //JAV 28/10/21: - Al registrar, poner importes correctos
        PurchRcptLine.SetAmounts;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostInvPostBuffer, '', true, true)]
    LOCAL PROCEDURE CU80_OnBeforePostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 49; SalesHeader: Record 36; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean);
    BEGIN
        //JAV 16/06/22: - QB 1.10.50 Informarmos de la U.O./Partida en la l�nea
        GenJnlLine."Job No." := InvoicePostBuffer."Job No.";
        GenJnlLine."Piecework Code" := InvoicePostBuffer."Piecework Code";
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 80 y 90"();
    BEGIN
    END;

    PROCEDURE OnBeforeValidatePostingDate(PostingDate: Date; Invoice: Boolean; Register: Boolean): Boolean;
    VAR
        Text001: TextConst ENU = 'Posting Date (%1) must not be higher than QuoSII Sending Date (%2).', ESP = 'La fecha de registro (%1) no puede ser superior a la de subida al SII (%2)';
        Text002: TextConst ENU = 'The posting deadline of %2 days for sending to SII has been exceeded (Posting Date %1, since %3 days ago). Do you wish to continue?', ESP = 'Se ha superado el plazo de registro de %2 d�as para la subida al SII (Fecha de registro %1, hace %3 d�as). �Desea continuar?';
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Ok: Boolean;
        CompanyInformation: Record 79;
        Text003: TextConst ENU = 'Canceled by user.', ESP = 'Cancelado por el usuario.';
    BEGIN
        //QCPM_GAP18 PGM 30/04/2019 - Se controla si la factura a registrar supera el plazo de registro.
        IF (Invoice) AND (PostingDate <> 0D) THEN BEGIN
            QuoBuildingSetup.GET();
            //JAV 05/10/21: - QB 1.09.20 Controlar las fechas de registro solo si el SII o el QUOSII est�n activos
            IF (FunctionQB.AccessToSII) OR (FunctionQB.AccessToQuoSII) THEN BEGIN
                IF (QuoBuildingSetup."Day of the Period" <> 0) THEN BEGIN
                    IF (Register) AND (PostingDate > WORKDATE) THEN BEGIN
                        ERROR(Text001, PostingDate, WORKDATE);
                    END;
                    //Q19407-
                    CompanyInformation.GET();
                    IF CompanyInformation."QuoSII Use Auto Date" THEN BEGIN
                        IF (WORKDATE + QuoBuildingSetup."Day of the Period" < TODAY) THEN BEGIN
                            Ok := CONFIRM(Text002, TRUE, WORKDATE, QuoBuildingSetup."Day of the Period", TODAY - WORKDATE);
                            IF (NOT Ok) THEN
                                ERROR(Text003);
                        END;
                    END ELSE IF (PostingDate + QuoBuildingSetup."Day of the Period" < TODAY) THEN BEGIN
                        Ok := CONFIRM(Text002, TRUE, PostingDate, QuoBuildingSetup."Day of the Period", TODAY - PostingDate);
                        IF (NOT Ok) THEN
                            ERROR(Text003);
                        //IF (PostingDate + QuoBuildingSetup."Day of the Period" < WORKDATE) THEN BEGIN
                        //  Ok := CONFIRM(Text002, TRUE, PostingDate, QuoBuildingSetup."Day of the Period", WORKDATE - PostingDate);
                        //  IF (NOT Ok) THEN
                        //    ERROR('');
                        //Q19407+
                    END;
                END;
            END;
        END;
        EXIT(TRUE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostSalesDoc(VAR SalesHeader: Record 36);
    VAR
        QuoBuildingSetup: Record 7207278;
        Result: Boolean;
    BEGIN
        //JAV 30/06/22: - QB 1.10.47 Verificar que la fecha de documento sea inferior o igual a la de registro
        IF (SalesHeader."Document Date" > SalesHeader."Posting Date") THEN
            ERROR('La fecha del documento no puede ser superior a la de registro.');

        //QCPM_GAP18 PGM 30/04/2019 - Se controla si la factura a registrar supera el plazo de registro.
        OnBeforeValidatePostingDate(SalesHeader."Posting Date",
                                    SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"],
                                    TRUE);

        //JAV 25/11/21: - QB 1.10.01 Bancos obligatorios
        IF QuoBuildingSetup.GET THEN
            IF (QuoBuildingSetup."Payment Bank Mandatory") AND (SalesHeader."QB Payment Bank No." = '') THEN
                ERROR('No ha definido el banco de cobro del documento');
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostPurchaseDoc(VAR PurchaseHeader: Record 38);
    VAR
        QuoBuildingSetup: Record 7207278;
        Result: Boolean;
    BEGIN
        //JAV 30/06/22: - QB 1.10.47 Verificar que la fecha de documento sea inferior o igual a la de registro
        IF (PurchaseHeader."Document Date" > PurchaseHeader."Posting Date") THEN
            ERROR('La fecha del documento no puede ser superior a la de registro.');

        //QCPM_GAP18 PGM 30/04/2019 - Se controla si la factura a registrar supera el plazo de registro.
        OnBeforeValidatePostingDate(PurchaseHeader."Posting Date",
                                    PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"],
                                    TRUE);

        //JAV 25/11/21: - QB 1.10.01 Bancos obligatorios
        IF QuoBuildingSetup.GET THEN
            IF (QuoBuildingSetup."Payment Bank Mandatory") AND (PurchaseHeader."QB Payable Bank No." = '') THEN
                ERROR('No ha definido el banco de pago del documento');
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 90"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnRunPurchPostPurchaseRcpt, '', true, true)]
    LOCAL PROCEDURE GeneratePurchaseRcpt_OnRunPurchPostPurchaseRcpt_CU90(VAR PurchaseHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR TempPurchRcptLine: Record 121 TEMPORARY);
    VAR
        FunctionQB: Codeunit 7207272;
        SalesShipmentPendingInvoice: Codeunit 7207295;
        PurchSetup: Record 312;
        PurchRcptLine: Record 121;
    BEGIN
        //Funcion para registro de albaranes, hace la previsi�n al crearlos y la desprovisi�n al facturarlos

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF PurchaseHeader.Receive OR PurchaseHeader.Ship THEN BEGIN
                SalesShipmentPendingInvoice.ActivatePurchaseRcpt(PurchRcptHeader, PurchRcptHeader."Posting Date");
                //Esto crea una entrada de almac�n en el proyecto, junto a los movimientos de producto y de valor asociados al albar�n
                SalesShipmentPendingInvoice.CreatePurchaseRcpttOutQuantityStock(PurchRcptHeader, FALSE);

                //Q15921.Begin
                PurchSetup.GET;
                IF PurchSetup."Receipt on Invoice" AND PurchaseHeader.Invoice THEN BEGIN
                    //SalesShipmentPendingInvoice.ActivatePurchaseRcpt(PurchRcptHeader,PurchRcptHeader."Posting Date");
                    //Esto crea una entrada de almac�n en el proyecto, junto a los movimientos de producto y de valor asociados al albar�n
                    //SalesShipmentPendingInvoice.CreatePurchaseRcpttOutQuantityStock(PurchRcptHeader, FALSE);

                    //En las facturas directas viene la cabecera del albar�n pero no las l�neas
                    IF TempPurchRcptLine.ISEMPTY THEN BEGIN
                        PurchRcptLine.RESET;
                        PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
                        IF PurchRcptLine.FINDSET THEN
                            REPEAT
                                TempPurchRcptLine := PurchRcptLine;
                                TempPurchRcptLine.INSERT;
                            UNTIL PurchRcptLine.NEXT = 0;
                    END;
                    //-Q19877
                    SalesShipmentPendingInvoice.Invoice_Dif(PurchaseHeader);
                    //+Q19877
                    SalesShipmentPendingInvoice.DeactivatePurchaseRcpt(PurchaseHeader."Posting Date", TempPurchRcptLine);
                END;
                //Q15921.End
            END
            //qb2130 IF PurchaseHeader.Invoice THEN
            ELSE BEGIN
                //-Q19877
                SalesShipmentPendingInvoice.Invoice_Dif(PurchaseHeader);
                //+Q19877
                SalesShipmentPendingInvoice.DeactivatePurchaseRcpt(PurchaseHeader."Posting Date", TempPurchRcptLine);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnRunPurchPostReturnShipment, '', true, true)]
    LOCAL PROCEDURE GeneratePurchaseRcpt_OnRunPurchPostReturnShipment_CU90(VAR PurchaseHeader: Record 38; VAR ReturnShipmentHeader: Record 6650; VAR TempReturnShipmentLine: Record 6651 TEMPORARY; PurchCrMemoHeader: Record 124);
    VAR
        FunctionQB: Codeunit 7207272;
        SalesShipmentPendingInvoice: Codeunit 7207295;
        PurchCrMemoLine: Record 125;
    BEGIN
        //Q15921.Begin
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF PurchaseHeader.Receive OR PurchaseHeader.Ship THEN BEGIN
                SalesShipmentPendingInvoice.ActivateReturnShipment(ReturnShipmentHeader, ReturnShipmentHeader."Posting Date");
                //Esto crea una entrada de almac�n en el proyecto, junto a los movimientos de producto y de valor asociados al albar�n
                SalesShipmentPendingInvoice.CreatePurchaseReturnShipmentOutQuantityStock(ReturnShipmentHeader, FALSE);
            END
            //qb2130 IF PurchaseHeader.Invoice THEN
            ELSE
                SalesShipmentPendingInvoice.DeactivateReturnShipment(PurchaseHeader."Posting Date", TempReturnShipmentLine, PurchaseHeader);
        END;
        //Q15921.End
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnPostItemResourceLine, '', true, true)]
    LOCAL PROCEDURE PostJobOnPurchaseLine_OnPostItemResourceLine_CU90(VAR PurchHeader: Record 38; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHeader: Record 124; PurchLine: Record 39; Sourcecode: Code[10]);
    VAR
        FunctionQB: Codeunit 7207272;
        JobPostLine: Codeunit 1001;
    BEGIN
        //PostJobOnPurchaseLine
        IF (FunctionQB.AccessToQuobuilding) THEN
            IF (PurchLine."Job No." <> '') AND (PurchLine."Qty. to Invoice" <> 0) THEN
                JobPostLine.PostJobOnPurchaseLine(PurchHeader, PurchInvHeader, PurchCrMemoHeader, PurchLine, Sourcecode);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnPostItemJnlLinePurchPost, '', true, true)]
    LOCAL PROCEDURE GetFields_OnPostItemJnlLinePurchPost_CU90(PurchaseLine: Record 39; VAR ItemJournalLine: Record 83; QtyToBeReceivedBase: Decimal);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //Esta funci�n prepara la l�nea del diario de producto con el almac�n de la obra

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (PurchaseLine."Job No." <> '') AND (QtyToBeReceivedBase <> 0) THEN BEGIN
                /*{---  //JAV 03/04/21: - QB 1.08.32 Esto se hac�a porque el movimiento creaba una l�nea de entrada y una de consumo autom�tico, ahora no tiene sentido pues solo genera la entrada.
                          ItemJournalLine."Unit Cost" := 0;
                          ItemJournalLine."Unit Amount" := 0;
                          ItemJournalLine.Amount := 0;
                          ItemJournalLine."Discount Amount" := 0;
                          ItemJournalLine."Unit Cost (ACY)" := 0;
                          ItemJournalLine."Amount (ACY)" := 0;
                          ---}*/
                IF PurchaseLine."Location Code" <> '' THEN
                    ItemJournalLine."Location Code" := PurchaseLine."Location Code"
                ELSE BEGIN
                    Job.GET(PurchaseLine."Job No.");
                    ItemJournalLine."Location Code" := Job."Job Location";
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnTestPurchLinePurchPost, '', true, true)]
    LOCAL PROCEDURE TestFieldJobTaskNo_OnTestPurchLinePurchPost_CU90(PurchaseLine: Record 39);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            Job.GET(PurchaseLine."Job No.");
            IF Job."Management by tasks" THEN
                PurchaseLine.TESTFIELD("Job Task No.");
        END ELSE
            PurchaseLine.TESTFIELD("Job Task No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostInvPostBuffer, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 49; VAR PurchHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        CodeunitModificManagement: Codeunit 7207273;
        GLAccount: Record 15;
    BEGIN
        //JAV 16/06/22: - Se cambia la funci�n "UpdateLinePurchase_OnRunGenJnlPostLinePurchPost_CU90" para que en lugar de llamarse desde la CU 7207352 con el evento "OnRunGenJnlPostLinePurchPost"
        //                apunte al evento OnBeforePostInvPostBuffer de la CU 90, que es mas apropiado. Ahora la funci�n se llama "CU90_OnBeforePostInvPostBuffer", y se elimina la llamada de la CU90


        //JAV 16/06/22: - QB 1.10.50 ampliamos el tratamiento en la funci�n UpdateLinePurchase_OnRunGenJnlPostLinePurchPost_CU90 para que contemple QB/RE/CECO
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN
            CodeunitModificManagement.UpdateLinePurchase(GenJnlLine, InvoicePostBuffer);

        //JAV 16/06/22: - QB 1.10.50 Informarmos de la U.O./Partida en la l�nea
        GenJnlLine."Piecework Code" := '';
        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") THEN
            IF (GLAccount.GET(GenJnlLine."Account No.")) THEN
                IF (GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement") THEN BEGIN
                    GenJnlLine."Job No." := InvoicePostBuffer."Job No.";
                    GenJnlLine."Piecework Code" := InvoicePostBuffer."Piecework Code";
                END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnGetFieldsTempInvoicePostBuffer, '', true, true)]
    LOCAL PROCEDURE FromGenJnlLine_OnGetFieldsTempInvoicePostBuffer_CU90(VAR GenJnlLine: Record 81; TempInvoicePostBuffer: Record 55 TEMPORARY);
    VAR
        FunctionQB: Codeunit 7207272;
        Job: Record 167;
    BEGIN
        //JAV 16/06/22: - QB 1.10.50 Poner la unidad de obra/partida en su lugar, solo si hay proyecto ***
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            //  IF (GenJnlLine."Job No." = '') THEN
            //    GenJnlLine."Piecework Code" := ''
            //  ELSE

            IF TempInvoicePostBuffer."Job No." <> '' THEN BEGIN
                GenJnlLine."Job No." := TempInvoicePostBuffer."Job No.";
                // GenJnlLine."Piecework Code" := TempInvoicePostBuffer."Piecework Code";
                Job.GET(TempInvoicePostBuffer."Job No.");
                //    IF NOT Job."Management by tasks" THEN
                //      GenJnlLine."Piecework Code" := TempInvoicePostBuffer."Piecework Code"
                //    ELSE BEGIN
                //      GenJnlLine."Piecework Code" := '';
                //      GenJnlLine."Job Task No." := TempInvoicePostBuffer."Piecework Code";
                //    END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnPostItemTrackingPurchPost, '', true, true)]
    LOCAL PROCEDURE OnPostItemTrackingPurchPost_CU90(VAR PurchRcptLine: Record 121; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; VAR TempPurchRcptLine: Record 121 TEMPORARY);
    VAR
        SalesShipmentPendingInvoice: Codeunit 7207295;
    BEGIN
        IF (PurchRcptLine.Accounted) AND (QtyToBeInvoiced <> 0) AND (QtyToBeInvoicedBase <> 0) THEN
            SalesShipmentPendingInvoice.InQueuePurchaseRcptToDeactivate(PurchRcptLine, QtyToBeInvoiced, TempPurchRcptLine);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnPostItemTrackingPurchShipment, '', true, true)]
    LOCAL PROCEDURE OnPostItemTrackingPurchShipment_CU90(VAR ReturnShptLine: Record 6651; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; VAR TempReturnShptLine: Record 6651 TEMPORARY);
    VAR
        SalesShipmentPendingInvoice: Codeunit 7207295;
    BEGIN
        //-Q20364
        //IF (ReturnShptLine.Accounted) AND (QtyToBeInvoiced <> 0) AND (QtyToBeInvoicedBase <> 0) THEN
        //  SalesShipmentPendingInvoice.InQueuePurchaseRcptToDeactivate(ReturnShptLine,QtyToBeInvoiced,TempReturnShptLine);
        IF (ReturnShptLine.Accounted) AND (QtyToBeInvoiced <> 0) AND (QtyToBeInvoicedBase <> 0) THEN
            SalesShipmentPendingInvoice.InQueuePurchaseReturnToDeactivate(ReturnShptLine, QtyToBeInvoiced, TempReturnShptLine);
        //Vuelto a activar.
    END;

    LOCAL PROCEDURE "-- eventos std"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostPurchaseDoc_CU90(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        Txt001: TextConst ESP = 'Debe informar siempre un proyecto en la cabecera al que imputar la factura si lo ha indicado en alguna l�nea (l�nea %1 ,proyecto %2)';
        PurchaseLine: Record 39;
        JobNoLIne: Code[20];
        ResultOK: Boolean;
        HaveError: Boolean;
        JobBudget: Record 7207407;
    BEGIN
        //JAV 04/02/20: - Verificar el importe del proveedor con el de la factura
        ValidatePurchaseAmount(PurchaseHeader, PreviewMode);

        IF (NOT FunctionQB.AccessToQuobuilding) THEN
            EXIT;

        //JAV 28/10/20: - QB 1.07.01 Si es una empresa de QuoBuilding debe tener un proyecto en la cabecera
        //JAV 30/05/22: - QB 1.10.45 Excepto para pedidos contra almac�n
        IF (PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Job) AND (PurchaseHeader."QB Job No." = '') THEN BEGIN
            //JAV 27/04/21: - QB 1.08.41 Siempre que lo tenga en alguna l�nea
            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
            PurchaseLine.SETFILTER("Job No.", '<>%1', '');
            IF (PurchaseLine.FINDFIRST) THEN
                ERROR(Txt001, PurchaseLine."Line No.", PurchaseLine."Job No.");
        END;

        //Q13715 - Verificar el registro en periodos cerrados
        IF (FunctionQB.QB_ControlBudgetDates) THEN BEGIN
            IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"]) THEN BEGIN
                JobNoLIne := '';

                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                IF PurchaseLine.FINDSET THEN BEGIN
                    REPEAT
                        IF (PurchaseLine."Job No." <> '') AND (JobNoLIne <> PurchaseLine."Job No.") THEN BEGIN
                            ResultOK := TestJobRegister(PurchaseLine."Job No.", PurchaseHeader."Posting Date", PreviewMode, HaveError);
                            IF HaveError THEN BEGIN
                                IF (NOT ResultOK) THEN
                                    ERROR(GETLASTERRORTEXT)
                                ELSE BEGIN
                                    //MESSAGE(GETLASTERRORTEXT);
                                    JobBudget.RESET;
                                    JobBudget.SETRANGE("Job No.", PurchaseLine."Job No.");
                                    JobBudget.SETFILTER("Budget Date", '>=%1', PurchaseHeader."Posting Date");
                                    JobBudget.SETRANGE("Budget Simulation", FALSE);
                                    IF JobBudget.FINDFIRST THEN BEGIN
                                        JobBudget."Cost in closed period" := TRUE;
                                        JobBudget.MODIFY;
                                    END;
                                END;
                            END;
                            JobNoLIne := PurchaseLine."Job No.";
                        END;
                    UNTIL PurchaseLine.NEXT = 0;
                END;
            END;
        END;
        //Q13715 +
    END;

    [TryFunction]
    LOCAL PROCEDURE TestJobRegister(JobNo: Code[20]; PostingDate: Date; Preview: Boolean; VAR HaveError: Boolean);
    VAR
        Job: Record 167;
        DateOutRange: TextConst ENU = 'Record date out of range', ESP = 'Fecha anterior a la de inicio del proyecto';
        TAuxJobsStatus: Record 7207440;
        JobsStatus: TextConst ENU = 'Jobs Status is not operative', ESP = 'El estado del proyecto es no operativo';
        JobBudget: Record 7207407;
        UserSetup: Record 91;
        CheckAllowRegistration: Boolean;
        RegisterClosed: TextConst ENU = '"You do not have permission to register in a closed Job Budget "', ESP = 'No tiene permiso para registraren fecha anterio a la del Presupuesto activo';
        OutsideOpenPeriod: TextConst ENU = 'The document is outside an open period in the project %1', ESP = 'El documento est� fuera de un periodo abierto en el proyecto %1';
        WantRegister: TextConst ENU = '"The document is out of an open period in project %1. Confirm that you want to register. "', ESP = 'El documento est� fuera de un periodo abierto en el proyecto %1. Confirme que desea efectuar el registro.';
    BEGIN
        //Q13715
        Job.RESET;
        IF Job.GET(JobNo) THEN BEGIN
            //Mirar si el proyecto est� bloqueado
            Job.TestBlocked;

            //Mirar que el estado sea operativo
            TAuxJobsStatus.RESET;
            IF TAuxJobsStatus.GET(TAuxJobsStatus.Usage::"Proyecto operativo", Job."Internal Status") THEN
                IF (NOT TAuxJobsStatus.Operative) THEN BEGIN
                    HaveError := TRUE;
                    IF Preview THEN BEGIN
                        MESSAGE(JobsStatus);
                        EXIT;
                    END ELSE
                        ERROR(JobsStatus);
                END;
            //Mirar el presupuesto al que se va a asociar por su fecha
            JobBudget.RESET;
            JobBudget.SETCURRENTKEY("Job No.", "Budget Date");
            JobBudget.SETRANGE("Job No.", JobNo);
            JobBudget.SETRANGE(Status, JobBudget.Status::Open);
            JobBudget.SETFILTER("Budget Date", '<=%1', PostingDate);
            JobBudget.SETRANGE("Budget Simulation", FALSE);
            IF (NOT JobBudget.FINDLAST) THEN BEGIN
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    IF (NOT UserSetup."QB Register in closed period") THEN BEGIN
                        HaveError := TRUE;
                        IF Preview THEN BEGIN
                            MESSAGE(RegisterClosed);
                            EXIT;
                        END ELSE
                            ERROR(RegisterClosed);
                    END ELSE BEGIN
                        IF (NOT Preview) THEN BEGIN
                            HaveError := TRUE;
                            IF CONFIRM(WantRegister, FALSE, JobNo) THEN
                                EXIT
                            ELSE
                                ERROR(OutsideOpenPeriod, JobNo);
                        END;
                    END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostVendorEntry, '', true, true)]
    LOCAL PROCEDURE OnBeforePostVendorEntry_CU90(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
        GenJnlLine."Job No." := PurchHeader."QB Job No.";

        //JAV 25/11/21: - QBPostPreview 1.10.01 A�ado el banco
        GenJnlLine."QB Payment Bank No." := PurchHeader."QB Payable Bank No.";   //Q8960

        //JAV 25/05/22: - QB 1.10.44 Se a�ade la partida presupuestaria en el diario desde el documento de cliente o de proveedor
        //JAV 16/06/22: - QB 1.10.50 El campo que se usaba no era el correcto para la unidad de obra/partida presupuestaria para la unidad de obra/partida presupuestaria
        GenJnlLine."Piecework Code" := PurchHeader."QB Budget item";
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostCommitPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostCommitPurchaseDoc_CU90(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; ModifyHeader: Boolean);
    VAR
        Vendor: Record 23;
        PaymentMethod: Record 289;
        MandatoryBankText: TextConst ENU = '%1 must be indicated.', ESP = '%1 debe ser informado.';
    BEGIN
        //QPE6439: En factura compras, si la forma de pago tiene marcado "Banco proveedor obligatorio"
        //         y no tiene informado "Cuenta bancaria preferida" salta mensaje.

        IF PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice THEN
            EXIT;

        IF NOT Vendor.GET(PurchaseHeader."Buy-from Vendor No.") THEN
            EXIT;

        IF Vendor."Preferred Bank Account Code" <> '' THEN
            EXIT;

        IF PaymentMethod.GET(PurchaseHeader."Payment Method Code") THEN BEGIN
            IF PaymentMethod."Mandatory Vendor Bank" THEN
                IF PreviewMode THEN
                    MESSAGE(MandatoryBankText, Vendor.FIELDCAPTION("Preferred Bank Account Code"))
                ELSE
                    ERROR(MandatoryBankText, Vendor.FIELDCAPTION("Preferred Bank Account Code"));
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 91, OnBeforeConfirmPost, '', true, true)]
    LOCAL PROCEDURE OnBeforeConfirmPost_CU91(VAR PurchaseHeader: Record 38; VAR HideDialog: Boolean; VAR IsHandled: Boolean; VAR DefaultOption: Integer);
    BEGIN
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) THEN BEGIN
            IsHandled := (NOT ConfirmPost(PurchaseHeader));
            HideDialog := TRUE;
            PurchaseHeader."Print Posted Documents" := FALSE;
        END ELSE BEGIN
            IsHandled := FALSE;
            HideDialog := FALSE;
        END;
        Event_OnBeforeConfirmPost_CU91(PurchaseHeader, HideDialog, IsHandled, DefaultOption);  //Para clientes
    END;

    [EventSubscriber(ObjectType::Codeunit, 92, OnBeforeConfirmPost, '', true, true)]
    LOCAL PROCEDURE OnBeforeConfirmPost_CU92(VAR PurchaseHeader: Record 38; VAR HideDialog: Boolean; VAR IsHandled: Boolean);
    BEGIN
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) THEN BEGIN
            IsHandled := (NOT ConfirmPost(PurchaseHeader));
            HideDialog := TRUE;
            PurchaseHeader."Print Posted Documents" := TRUE;
        END ELSE BEGIN
            IsHandled := FALSE;
            HideDialog := FALSE;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePurchRcptHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnBeforePurchRcptHeaderInsert_CU90(VAR PurchRcptHeader: Record 120; VAR PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
        //JAV 10/10/20: - QB 1.06.20 Hay que actualizar el factor de cambio de la divisa en el albar�n, ya que ahora se registra contablemente

        //Esto de momento no se va a efectuar por que crea incosistencia con el pedido y luego no cuadra pedido con recibido
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE EmptyQueueJobJnlLineOnBeforePostPurchaseDoc_CU90(VAR PurchaseHeader: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
        TmpJobJournalLine: Record 210 TEMPORARY;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            TmpJobJournalLine.DELETEALL;
    END;

    LOCAL PROCEDURE "-- otras"();
    BEGIN
    END;

    PROCEDURE ValidatePurchaseAmount(PurchaseHeader: Record 38; WithMessage: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        ImporteDoc: Decimal;
        Text001: TextConst ESP = 'No cuadran los importes:\     %1 factura.......: %2\     %1 proveedor: %3';
        Text1: Text;
        Text2: Text;
        Text3: Text;
        Text000: TextConst ESP = 'No ha indicado el importe del proveedor';
    BEGIN
        //JAV 04/02/20: - Verificar el importe del proveedor con el de la factura
        QuoBuildingSetup.GET;

        IF (QuoBuildingSetup."Vendor Amount Mandatory") AND (PurchaseHeader."QB Total document amount" = 0) THEN BEGIN
            IF WithMessage THEN
                MESSAGE(Text000)
            ELSE
                ERROR(Text000);
        END;

        //-Q20099
        //IF (PurchaseHeader."QB Total document amount" <> 0) THEN BEGIN
        IF (PurchaseHeader."QB Total document amount" <> 0) AND (QuoBuildingSetup."Vendor Amount Mandatory") THEN BEGIN
            //+Q20099  PurchaseHeader.CALCFIELDS(Amount, "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

            CASE QuoBuildingSetup."Dif. Amount On" OF
                QuoBuildingSetup."Dif. Amount On"::Base:
                    ImporteDoc := PurchaseHeader.Amount;
                QuoBuildingSetup."Dif. Amount On"::Total:
                    ImporteDoc := PurchaseHeader."Amount Including VAT" - PurchaseHeader."QW Total Withholding PIT";
                QuoBuildingSetup."Dif. Amount On"::Payment:
                    ImporteDoc := PurchaseHeader."Amount Including VAT" - PurchaseHeader."QW Total Withholding PIT" - PurchaseHeader."QW Total Withholding GE";
            END;

            IF (ABS(ImporteDoc - PurchaseHeader."QB Total document amount") > QuoBuildingSetup."Max. Dif. Amount Invoice") THEN BEGIN
                Text1 := FORMAT(ImporteDoc, 0, '<Precision,2:2><Standard Format,0>');
                Text2 := FORMAT(PurchaseHeader."QB Total document amount", 0, '<Precision,2:2><Standard Format,0>');
                Text3 := STRSUBSTNO(Text001, FORMAT(QuoBuildingSetup."Dif. Amount On"), Text1, Text2);
                IF WithMessage THEN
                    MESSAGE(Text3)
                ELSE
                    ERROR(Text3);
            END;
        END;
    END;

    LOCAL PROCEDURE ConfirmPost(VAR PurchaseHeader: Record 38): Boolean;
    VAR
        QBCodeunitPublisher: Codeunit 7207352;
        PurchaseLine: Record 39;
        PurchSetup: Record 312;
        UserSetup: Record 91;
        Job: Record 167;
        QBProform: Codeunit 7207345;
        FRI: Boolean;
        Option: Integer;
        HaveLinesProform: Integer;
        HaveLinesNotProform: Integer;
        HaveLinesLocation: Integer;
        HaveLinesNotLocation: Integer;
        HaveQtyReceive: Boolean;
        HaveQtyProform: Boolean;
        HaveQtyInvoice: Boolean;
        Text001: TextConst ENU = 'Generate &FRI''S', ESP = 'Generar &FRI';
        Text002: TextConst ENU = 'Generate Proform', ESP = 'Generar &Proforma';
        Text003: TextConst ENU = 'Receive', ESP = 'Generar &Albar�n';
        Text004: TextConst ENU = 'Receive in Location', ESP = 'Recibir en Almac�n';
        Text005: TextConst ENU = 'Invoice', ESP = 'F&acturar';
        Text006: TextConst ENU = 'Receive & Invoice', ESP = 'R&ecibir y facturar';
        TextOptions: Text;
        txtDate: Text;
    BEGIN
        //JAV 20/03/19: - Verificar si el usuario debe usar FRI obligatoriamente
        //Las opciones son:
        //                  1 - Generar FRI                                   Recibir   FRI
        //                  2 - Generar FRI y Generar Proforma                Recibir   FRI   Proforma
        //                  3 - Generar Proforma                                              Proforma
        //                  4 - Generar Albar�n                               Recibir
        //                  5 - Generar Albar�n y Recibir en Almac�n          Recibir
        //                  6 - Facturar                                                                Facturar
        //                  7 - Recibir y facturar                            Recibir                   Facturar

        IF NOT UserSetup.GET(USERID) THEN
            UserSetup.INIT;
        PurchSetup.GET;
        CASE UserSetup."Use FRI" OF
            UserSetup."Use FRI"::Conf:
                FRI := PurchSetup."Always Use FRI";
            UserSetup."Use FRI"::Always:
                FRI := TRUE;
            UserSetup."Use FRI"::Optional:
                FRI := FALSE;
        END;

        HaveLinesProform := 0;
        HaveLinesNotProform := 0;
        HaveLinesLocation := 0;
        HaveLinesNotLocation := 0;
        HaveQtyReceive := FALSE;
        HaveQtyProform := FALSE;
        HaveQtyInvoice := FALSE;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF (PurchaseLine.FINDSET) THEN
            REPEAT
                //Si tiene cantidades a recibir, seg�n sean proformables
                IF (PurchaseLine."Qty. to Receive" <> 0) THEN BEGIN
                    HaveQtyReceive := TRUE;
                    IF (PurchaseLine."QB Line Proformable") THEN
                        HaveLinesProform += 1
                    ELSE
                        HaveLinesNotProform += 1;

                    //Si tiene cantidades a recibir en el almac�n de la obra
                    //-Q20073
                    //IF Job.GET(PurchaseLine."Job No.") AND (PurchaseLine."Piecework No." = Job."Warehouse Cost Unit") THEN
                    IF (Job.GET(PurchaseLine."Job No.") AND (PurchaseLine."Piecework No." = Job."Warehouse Cost Unit")) AND (PurchaseLine."Piecework No." <> '') THEN //No se admite si no hay informado unidad coste alm. en blanco
                                                                                                                                                                      //+Q20073
                        HaveLinesLocation += 1
                    ELSE
                        HaveLinesNotLocation += 1;
                END;

                //Si tiene cantidades a proformar
                IF (PurchaseLine."QB Qty. To Proform" <> 0) THEN
                    HaveQtyProform := TRUE;

                //Si tiene cantidades a facturar
                IF (PurchaseLine."Qty. to Invoice" <> 0) THEN
                    HaveQtyInvoice := TRUE;

            UNTIL PurchaseLine.NEXT = 0;

        //Si tiene l�neas proformable y no proformables solo puede generar FRI, si tiene l�neas con y sin almac�n solo informamos de almac�n para evitar problemas
        IF (HaveQtyReceive) AND (HaveLinesProform <> 0) AND (HaveLinesNotProform <> 0) THEN
            HaveLinesNotProform := 0;

        IF (HaveQtyReceive) AND (HaveLinesLocation <> 0) AND (HaveLinesNotLocation <> 0) THEN
            HaveLinesNotLocation := 0;

        //Montar la lista de opciones posibles
        TextOptions := '';
        Option := 0;

        // 1 - Generar FRI
        IF (HaveLinesProform <> 0) AND (HaveQtyReceive) THEN BEGIN
            TextOptions += Text001;
            IF (Option = 0) THEN
                Option := 1;
        END;
        TextOptions += ',';

        // 2 - Generar FRI y Proforma
        IF (HaveLinesProform <> 0) AND (HaveQtyReceive) AND (HaveQtyProform) THEN BEGIN
            TextOptions += Text001 + ' y ' + Text002;
            IF (Option = 0) THEN
                Option := 2;
        END;
        TextOptions += ',';

        // 3 - Generar solo la Proforma, pero si no hay nada que se pueda recibir, si no generar solo la proforma no sirve.
        IF (NOT HaveQtyReceive) AND (HaveQtyProform) THEN BEGIN
            TextOptions += Text002;
            IF (Option = 0) THEN
                Option := 3;
        END;
        TextOptions += ',';

        // 4 - Generar Albar�n
        IF (HaveLinesNotProform <> 0) AND (HaveLinesNotLocation <> 0) AND (HaveQtyReceive) THEN BEGIN
            TextOptions += Text003;
            IF (Option = 0) THEN
                Option := 4;
        END;
        TextOptions += ',';

        // 5 - Generar Albar�n y Recibir en Almac�n
        IF (HaveLinesNotProform <> 0) AND (HaveLinesLocation <> 0) AND (HaveQtyReceive) THEN BEGIN
            TextOptions += Text003 + ' y ' + Text004;
            IF (Option = 0) THEN
                Option := 5;
        END;
        TextOptions += ',';

        // 6 - Facturar

        IF (NOT FRI) AND (HaveQtyInvoice) THEN BEGIN
            TextOptions += Text005;
            IF (Option = 0) THEN
                Option := 6;
        END;
        TextOptions += ',';

        // 7 - Recibir y facturar
        IF (NOT FRI) AND (HaveQtyReceive) AND (HaveQtyInvoice) THEN BEGIN
            TextOptions += Text006;
            IF (Option = 0) THEN
                Option := 7;
        END;
        TextOptions += ',';

        //JAV 18/02/22: - QB 1.10.20 Para que se puedan a�adir otras opciones personalizadas
        QBCodeunitPublisher.OnBeforeMountTextForConfirmPost(PurchaseHeader, TextOptions, Option);

        TextOptions := DELCHR(TextOptions, '>', ',');
        IF (TextOptions = '') THEN
            ERROR('Nada que registrar');

        //Presentar el men� y salir si no eligen nada
        txtDate := 'Registrar con fecha ' + FORMAT(PurchaseHeader."Posting Date");
        Option := STRMENU(TextOptions, Option, txtDate);
        IF Option = 0 THEN
            EXIT(FALSE);

        //Montar lo que hay que registrar segun las opciones
        PurchaseHeader.Receive := Option IN [1, 2, 4, 5, 7];
        PurchaseHeader.Invoice := Option IN [6, 7];
        PurchaseHeader."QB Receive in FRIS" := Option IN [1, 2];
        PurchaseHeader."QB Generate Proform" := (Option IN [2, 3]);

        //Si hay que recibir o facturar lanzamos el registro
        IF (PurchaseHeader.Receive) OR (PurchaseHeader.Invoice) THEN
            EXIT(TRUE);

        //Si no hay que recibir ni facturar pero si proformar lo hacemos
        IF (PurchaseHeader."QB Generate Proform") THEN BEGIN
            QBProform.Proform(PurchaseHeader, FALSE, FALSE);
            PurchaseHeader."QB Generate Proform" := FALSE;
            PurchaseHeader.MODIFY;
            COMMIT;
        END;

        EXIT(FALSE);
    END;

    // [EventSubscriber(ObjectType::Codeunit, 90, OnPostItemJnlLineJobConsumption, '', true, true)]
    LOCAL PROCEDURE CU90_OnPostItemJnlLineJobConsumption(PurchHeader: Record 38; VAR PurchLine: Record 39; ItemJournalLine: Record 83; VAR TempPurchReservEntry: Record 337 TEMPORARY; QtyToBeInvoiced: Decimal; QtyToBeReceived: Decimal; VAR TempTrackingSpecification: Record 337 TEMPORARY; PurchItemLedgEntryNo: Integer; VAR IsHandled: Boolean);
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        //AML 14/06/22: - QB 1.10.49 Si est� activo el nuevo sistema de stock saltar este control  --> 22/06/22 Se elimina
        // IF (PurchasesPayablesSetup.GET) THEN
        //  IF (PurchasesPayablesSetup."QB Stocks Active New Function" <> PurchasesPayablesSetup."QB Stocks Active New Function"::No) THEN
        //    IsHandled := TRUE;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 353"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 353, OnAfterCalcItemPlanningFields, '', true, true)]
    LOCAL PROCEDURE CU353_OnAfterCalcItemPlanningFields(VAR Item: Record 27);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            Item.CALCFIELDS("QB Quantity Planned Purchase");
    END;

    [EventSubscriber(ObjectType::Codeunit, 353, OnAfterCalculateNeed, '', true, true)]
    LOCAL PROCEDURE CU353_OnAfterCalculateNeed(VAR Item: Record 27; VAR GrossRequirement: Decimal; VAR PlannedOrderReceipt: Decimal; VAR ScheduledReceipt: Decimal; VAR PlannedOrderReleases: Decimal);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            GrossRequirement += Item."QB Quantity Planned Purchase";
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 408"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 408, OnAfterSetupObjectNoList, '', true, true)]
    LOCAL PROCEDURE RunSetupObjectNoListDimensionManagement(VAR TempAllObjWithCaption: Record 2000000058 TEMPORARY);
    VAR
        FunctionQB: Codeunit 7207272;
        DimensionManagement: Codeunit 408;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            DimensionManagement.InsertObject(TempAllObjWithCaption, DATABASE::Piecework);
            DimensionManagement.InsertObject(TempAllObjWithCaption, DATABASE::"Data Piecework For Production");
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 700"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 700, OnAfterGetPageID, '', true, true)]
    LOCAL PROCEDURE OnAfterGetPageID(RecordRef: RecordRef; VAR PageID: Integer);
    VAR
        Job: Record 167;
        OperativeJobsCard: Page 7207478;
        QuotesCard: Page 7207361;
        VersionsQuoteCard: Page 7207363;
    BEGIN
        IF (RecordRef.NUMBER = DATABASE::Job) THEN BEGIN
            RecordRef.SETTABLE(Job);
            CASE Job."Card Type" OF
                Job."Card Type"::"Proyecto operativo":
                    PageID := PAGE::"Operative Jobs Card";

                Job."Card Type"::Estudio:
                    IF (Job."Original Quote Code" = '') THEN
                        PageID := PAGE::"Quotes Card"
                    ELSE
                        PageID := PAGE::"Versions Quote Card";
            END;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 846"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 846, OnAfterCreateForecastEntry, '', true, true)]
    LOCAL PROCEDURE CU846_OnAfterCreateForecastEntry(VAR CashFlowForecastEntry: Record 847; CashFlowWorksheetLine: Record 846);
    BEGIN
        //JAV 24/11/21: - QB 1.10.01 Se pasa de la CU propia a esta, y se a�aden mas campos
        CashFlowForecastEntry."QB Job No." := CashFlowWorksheetLine."Job No.";
        CashFlowForecastEntry."QB Payment Method Code" := CashFlowWorksheetLine."Payment Method Code";
        CashFlowForecastEntry."QB Currency Code" := CashFlowWorksheetLine."Currency Code";
        CashFlowForecastEntry."QB Piecework Code" := CashFlowWorksheetLine."Piecework Code";
        CashFlowForecastEntry."QB Bank Account" := CashFlowWorksheetLine."Bank Account";
        CashFlowForecastEntry."QB Amount" := CashFlowWorksheetLine.Amount;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 1004"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 1004, OnAfterFromPurchaseLineToJnlLine, '', true, true)]
    LOCAL PROCEDURE CU1004_OnAfterFromPurchaseLineToJnlLine(VAR JobJnlLine: Record 210; PurchHeader: Record 38; PurchInvHeader: Record 122; PurchCrMemoHeader: Record 124; PurchLine: Record 39; SourceCode: Code[10]);
    BEGIN
        //GAP888
        CASE PurchHeader."Document Type" OF
            PurchHeader."Document Type"::"Return Order", PurchHeader."Document Type"::"Credit Memo":
                JobJnlLine."Source Document Type" := JobJnlLine."Source Document Type"::"Credit Memo";
            ELSE
                JobJnlLine."Source Document Type" := JobJnlLine."Source Document Type"::Invoice;
        END;

        JobJnlLine."Source Type" := JobJnlLine."Source Type"::Vendor;
        JobJnlLine."Source No." := PurchHeader."Buy-from Vendor No.";
        JobJnlLine."Source Name" := PurchHeader."Buy-from Vendor Name";

        //JAV 04/07/22: - QB 1.10.58 Se traslada el c�digo de la funci�n RunAddFromPurchaseLineToJnlLineCJobTransferLine a CU1004_OnAfterFromPurchaseLineToJnlLine para usar el evento est�ndar
        JobJnlLine."Piecework Code" := PurchLine."Piecework No.";
        IF (PurchLine.Type = PurchLine.Type::"G/L Account") THEN BEGIN
            JobJnlLine."Quantity (Base)" := JobJnlLine."Total Cost (LCY)";
            IF JobJnlLine.Quantity <> 0 THEN
                JobJnlLine."Qty. per Unit of Measure" := JobJnlLine."Quantity (Base)" / JobJnlLine.Quantity
            ELSE
                JobJnlLine."Qty. per Unit of Measure" := JobJnlLine."Quantity (Base)";
        END;
        IF JobJnlLine."Line Type" = JobJnlLine."Line Type"::" " THEN
            JobJnlLine."Line Type" := JobJnlLine."Line Type"::"Both Budget and Billable";

        //JAV 04/07/22: - QB 1.10.58 Se traslada el c�digo en la codeunit 1004 al evento OnAfterFromPurchaseLineToJnlLine que es lo adecuado
        //JMMA 28/09/20 a�adido para llevar el importe de coste en la divisa original de la transacci�n
        JobJnlLine."Transaction Currency" := JobJnlLine."Currency Code";
        JobJnlLine."Total Cost (TC)" := JobJnlLine."Total Cost";
    END;

    // [EventSubscriber(ObjectType::Codeunit, 1004, OnAfterFromPlanningSalesLineToJnlLine, '', true, true)]
    LOCAL PROCEDURE CU1004_OnAfterFromPlanningSalesLineToJnlLine(VAR JobJnlLine: Record 210; JobPlanningLine: Record 1003; SalesHeader: Record 36; SalesLine: Record 37; EntryType: Option "Usage","Sale");
    BEGIN
        //GAP888
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                JobJnlLine."Source Document Type" := JobJnlLine."Source Document Type"::Invoice;
            SalesHeader."Document Type"::"Credit Memo":
                JobJnlLine."Source Document Type" := JobJnlLine."Source Document Type"::"Credit Memo";
        END;

        JobJnlLine."Source Type" := JobJnlLine."Source Type"::Customer;
        JobJnlLine."Source No." := SalesHeader."Sell-to Customer No.";
        JobJnlLine."Source Name" := SalesHeader."Sell-to Customer Name";
    END;

    [EventSubscriber(ObjectType::Codeunit, 1004, OnAfterFromGenJnlLineToJnlLine, '', true, true)]
    LOCAL PROCEDURE CU1004_OnAfterFromGenJnlLineToJnlLine(VAR JobJnlLine: Record 210; GenJnlLine: Record 81);
    BEGIN
        JobJnlLine."Job Sale Doc. Type" := GenJnlLine."Job Sale Doc. Type";
    END;

    [EventSubscriber(ObjectType::Codeunit, 1004, OnAfterFromJnlLineToLedgEntry, '', true, true)]
    LOCAL PROCEDURE CU1004_OnAfterFromJnlLineToLedgEntry(VAR JobLedgerEntry: Record 169; JobJournalLine: Record 210);
    VAR
        Job: Record 167;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        Factor: Decimal;
    BEGIN
        //JAV 20/11/20: - QB 1.07.06 Informar de los importes en la divisa adicional del proyecto si los tiene al crear el movimiento de proyecto
        //JAV 04/07/22: - QB 1.10.58 La variable Factor estaba definida como par�metro en lugar de como variable local del proceso
        Job.GET(JobLedgerEntry."Job No.");
        IF Job."Aditional Currency" <> '' THEN BEGIN
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", JobJournalLine."Unit Cost (LCY)", '', Job."Aditional Currency", JobJournalLine."Posting Date", 0, JobLedgerEntry."Unit Cost (ACY)", Factor);
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", JobJournalLine."Total Cost (LCY)", '', Job."Aditional Currency", JobJournalLine."Posting Date", 0, JobLedgerEntry."Total Cost (ACY)", Factor);
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", JobJournalLine."Total Price (LCY)", '', Job."Aditional Currency", JobJournalLine."Posting Date", 0, JobLedgerEntry."Total Price (ACY)", Factor);
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", JobJournalLine."Unit Price (LCY)", '', Job."Aditional Currency", JobJournalLine."Posting Date", 0, JobLedgerEntry."Unit Price (ACY)", Factor);
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", JobJournalLine."Line Amount (LCY)", '', Job."Aditional Currency", JobJournalLine."Posting Date", 0, JobLedgerEntry."Line Amount (ACY)", Factor);
            JobLedgerEntry."Exchange Rate (ACY)" := Factor;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 1012"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnRunWithCheckJobJnlPostLine, '', true, true)]
    LOCAL PROCEDURE OnRunWithCheckJobJnlPostLine_CU1012(JobJournalLine: Record 210; VAR ExitBool: Boolean);
    VAR
        GLAccount: Record 15;
        FunctionQB: Codeunit 7207272;
    BEGIN
        ExitBool := FALSE;
        IF FunctionQB.AccessToQuobuilding THEN
            IF JobJournalLine.Type = JobJournalLine.Type::"G/L Account" THEN BEGIN
                GLAccount.GET(JobJournalLine."No.");
                //JAV 06/10/22: - QB 1.12.00 Se a�aden los movimientos de las cuentas de activaci�n en la creaci�n de mov. de proyecto
                IF (GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Balance Sheet") AND (NOT JobJournalLine."QB Activation Mov.") THEN
                    ExitBool := TRUE;
            END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnJobEntryCreateJobLedgEntryJobJnlPostLine, '', true, true)]
    LOCAL PROCEDURE OnJobEntryCreateJobLedgEntryJobJnlPostLine_CU1012(JobJnlLine2: Record 210; VAR JobLedgEntry: Record 169);
    VAR
        FunctionQB: Codeunit 7207272;
        CodeunitModificManagement: Codeunit 7207273;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            CodeunitModificManagement.InheritFieldJob(JobJnlLine2, JobLedgEntry);
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 5055"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 5055, OnAfterUpdateVendor, '', true, true)]
    LOCAL PROCEDURE CU5055_OnAfterUpdateVendor(VAR Vendor: Record 23; Contact: Record 5050);
    VAR
        ContactActivitiesQB: Record 7207430;
        VendorQualityData: Record 7207418;
    BEGIN
        ContactActivitiesQB.RESET;
        ContactActivitiesQB.SETRANGE("Contact No.", Contact."No.");
        IF ContactActivitiesQB.FINDSET THEN
            REPEAT
                CLEAR(VendorQualityData);
                VendorQualityData."Vendor No." := Vendor."No.";
                VendorQualityData.VALIDATE("Activity Code", ContactActivitiesQB."Activity Code");
                VendorQualityData."Area Activity" := ContactActivitiesQB."Area Activity";
                IF VendorQualityData.INSERT(TRUE) THEN;
            UNTIL ContactActivitiesQB.NEXT = 0;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 5530"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 5530, OnAfterGetDocumentEntries, '', true, true)]
    LOCAL PROCEDURE CU5530_OnAfterGetDocumentEntries(VAR InvtEventBuf: Record 5530; VAR Item: Record 27; VAR CurrEntryNo: Integer);
    VAR
        PurchJnlLine: Record 7207281;
        CalcItemAvailability: Codeunit 5530;
        CalcItemAvailability2: Codeunit 50017;
        RecRef: RecordRef;
    BEGIN
        IF PurchJnlLine.READPERMISSION THEN BEGIN
            PurchJnlLine.RESET;
            PurchJnlLine.SETRANGE(Type, PurchJnlLine.Type::Item);
            PurchJnlLine.SETRANGE("No.", Item."No.");
            PurchJnlLine.SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
            PurchJnlLine.SETFILTER("Date Needed", Item.GETFILTER("Date Filter"));
            PurchJnlLine.SETFILTER(Quantity, '<>0');
            IF PurchJnlLine.FINDSET THEN
                REPEAT
                    RecRef.GETTABLE(PurchJnlLine);
                    TransferFromPurchJnlLine(PurchJnlLine, RecRef.RECORDID);
                    CalcItemAvailability2.QB_InsertEntry(InvtEventBuf);
                UNTIL PurchJnlLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 5813"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 5813, OnBeforeOnRun, '', true, true)]
    LOCAL PROCEDURE OnBeforeOnRun_CU5813(VAR PurchRcptLine: Record 121; VAR IsHandled: Boolean);
    VAR
        // Cancellationofoutsshipments: Report 7207399;
        FunctionQB: Codeunit 7207272;
        Text50000: TextConst ESP = 'Ya ha anulado esta l�nea del albar�n';
        Text50001: TextConst ESP = 'No hay cantidad que cancelar';
    BEGIN
        //JAV 04/04/21: - Si la l�nea ya se ha anulado por el proceso de QB, no hacer nada
        IF PurchRcptLine.Cancelled THEN
            IsHandled := TRUE;
        //AML 28/03/22: - QB_ST01 - Deshacer l�neas recepci�n de compras de productos da error Modificaciones: OnBeforeOnRun_CU5813. Se anula la llamada recursiva.
        EXIT;

        //CPA 28/01/22: Q16247 - Deshacer l�neas recepci�n de compras de productos da error.Begin
        //JAV 04/04/21: - QB 1.08.32 Para QuoBuilding se usa la rutina propia de anulaci�n
        IF (NOT IsHandled) AND (FunctionQB.AccessToQuobuilding) THEN BEGIN
            IF PurchRcptLine.Cancelled THEN
                ERROR(Text50000);
            IF PurchRcptLine.Quantity = 0 THEN
                ERROR(Text50001);

            // CLEAR(Cancellationofoutsshipments);
            // Cancellationofoutsshipments.CancelLine(PurchRcptLine, TRUE);

            IsHandled := TRUE;
        END;
        //CPA 28/01/22: Q16247 - Deshacer l�neas recepci�n de compras de productos da error.End
    END;

    [EventSubscriber(ObjectType::Codeunit, 5813, OnBeforeNewPurchRcptLineInsert, '', true, true)]
    LOCAL PROCEDURE OnBeforeNewPurchRcptLineInsert_CU5813(VAR NewPurchRcptLine: Record 121; OldPurchRcptLine: Record 121);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 04/04/21: - QB 1.08.32 Al cancelar un albar�n y generar la nueva l�nea, marcar como cancelada y si viene de un proyecto poner la cantidad facturada a cero en esa l�nea
        IF (FunctionQB.AccessToQuobuilding) THEN BEGIN
            NewPurchRcptLine.Cancelled := TRUE;
            IF (NewPurchRcptLine."Job No." <> '') THEN BEGIN
                NewPurchRcptLine."Quantity Invoiced" := 0;
                NewPurchRcptLine."Qty. Invoiced (Base)" := 0;

                //JAV 15/12/21: - QB 1.10.07 Se a�aden los datos de la provisi�n y se elimina el almac�n
                NewPurchRcptLine."Location Code" := '';
                NewPurchRcptLine."QB Qty Provisioned" := 0;
                NewPurchRcptLine."QB Amount Provisioned" := 0;
            END;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 5601"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 5601, OnGetBalAccAfterSaveGenJnlLineFields, '', true, true)]
    LOCAL PROCEDURE OnGetBalAccAfterSaveGenJnlLineFields_CU5601(VAR ToGenJnlLine: Record 81; FromGenJnlLine: Record 81; VAR SkipInsert: Boolean);
    VAR
        FADepreciationBook: Record 5612;
        FixedAsset: Record 5600;
    BEGIN
        //AML Q17292 A�adido en 10/10/23
        //CPA 27/10/22 Q18216.Begin
        IF FromGenJnlLine."QB Job No." <> '' THEN BEGIN
            ToGenJnlLine.VALIDATE("Job No.", FromGenJnlLine."QB Job No.");
            ToGenJnlLine.VALIDATE("Piecework Code", FromGenJnlLine."Piecework Code");
            ToGenJnlLine.VALIDATE("Dimension Set ID", FromGenJnlLine."Dimension Set ID");
            EXIT;
        END;


        //JAV 17/10/20: - QB 1.06.21 Me guardo el proyecto y la U.O. del activo en el registro temporal

        //JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
        //FADepreciationBook.GET(FromGenJnlLine."Account No.", FromGenJnlLine."Depreciation Book Code");
        //ToGenJnlLine.VALIDATE("Job No.", FADepreciationBook."OLD_Asset Allocation Job");
        //ToGenJnlLine.VALIDATE("Piecework Code", FADepreciationBook."OLD_Piecework Code");
        FixedAsset.GET(FromGenJnlLine."Account No.");
        ToGenJnlLine.VALIDATE("Job No.", FixedAsset."Asset Allocation Job");
        ToGenJnlLine.VALIDATE("Piecework Code", FixedAsset."Piecework Code");
    END;

    [EventSubscriber(ObjectType::Codeunit, 5601, OnGetBalAccAfterRestoreGenJnlLineFields, '', true, true)]
    LOCAL PROCEDURE OnGetBalAccAfterRestoreGenJnlLineFields_CU5601(VAR ToGenJnlLine: Record 81; FromGenJnlLine: Record 81);
    VAR
        FADepreciationBook: Record 5612;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 17/10/20: - QB 1.06.21 Ajusto la contrapartida de la l�nea del Activo Fijo para que tome proyecto y U.O.
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            ToGenJnlLine.VALIDATE("Job No.", FromGenJnlLine."Job No.");
            ToGenJnlLine.VALIDATE("Piecework Code", FromGenJnlLine."Piecework Code");

            //PSM Q17292 A�adido en 10/10/23
            //CPA 27/10/22 Q18216.Begin
            ToGenJnlLine.VALIDATE("Dimension Set ID", FromGenJnlLine."Dimension Set ID");
            //CPA 27/10/22 Q18216.End
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 6620"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 6620, OnAfterCopyPurchaseDocument, '', true, true)]
    LOCAL PROCEDURE OnAfterCopyPurchaseDocument_CU6620(FromDocumentType: Option; FromDocumentNo: Code[20]; VAR ToPurchaseHeader: Record 38; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; IncludeHeader: Boolean);
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 6620, OnCopyArchSalesLineOnBeforeToSalesLineInsert, '', true, true)]
    LOCAL PROCEDURE CU6620_OnCopyArchSalesLineOnBeforeToSalesLineInsert(VAR ToSalesLine: Record 37; FromSalesLineArchive: Record 5108; RecalculateLines: Boolean);
    BEGIN
        //JAV 06/07/22: - QB 1.10.59 Se guarda el proyecto al copiar las l�neas de documento de venta
        ToSalesLine."Job No." := FromSalesLineArchive."Job No.";
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 7000005"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000005, OnBeforeSplitSalesInvCreateBills, '', true, true)]
    LOCAL PROCEDURE OnBeforeSplitSalesInvCreateBills_CU7000005(VAR GenJournalLine: Record 81; SalesHeader: Record 36);
    BEGIN
        //JAV 20/03/19: - Pasar al diario el proyecto
        GenJournalLine."Job No." := SalesHeader."QB Job No.";

        //JAV 25/11/21: - QB 1.10.01 Pasar el banco
        GenJournalLine."QB Payment Bank No." := SalesHeader."QB Payment Bank No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000005, OnBeforeSplitSalesInvCloseEntry, '', true, true)]
    LOCAL PROCEDURE OnBeforeSplitSalesInvCloseEntry_CU7000005(VAR GenJournalLine: Record 81; SalesHeader: Record 36);
    BEGIN
        //JAV 20/03/19: - Pasar al diario el proyecto
        GenJournalLine."Job No." := SalesHeader."QB Job No.";

        //JAV 25/11/21: - QB 1.10.01 Pasar el banco
        GenJournalLine."QB Payment Bank No." := SalesHeader."QB Payment Bank No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000005, OnBeforeSplitPurchInvCloseEntry, '', true, true)]
    LOCAL PROCEDURE OnBeforeSplitPurchInvCloseEntry_CU7000005(VAR GenJournalLine: Record 81; PurchaseHeader: Record 38);
    BEGIN
        //JAV 20/03/19: - Pasar al diario el proyecto
        GenJournalLine."Job No." := PurchaseHeader."QB Job No.";

        //JAV 25/11/21: - QB 1.10.01 Pasar el banco
        GenJournalLine."QB Payment Bank No." := PurchaseHeader."QB Payable Bank No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000005, OnBeforeSplitPurchInvCreateBills, '', true, true)]
    LOCAL PROCEDURE OnBeforeSplitPurchInvCreateBills_CU7000005(VAR GenJournalLine: Record 81; PurchaseHeader: Record 38);
    BEGIN
        //JAV 20/03/19: - Pasar al diario el proyecto
        GenJournalLine."Job No." := PurchaseHeader."QB Job No.";

        //JAV 25/11/21: - QB 1.10.01 Pasar el banco
        GenJournalLine."QB Payment Bank No." := PurchaseHeader."QB Payable Bank No.";
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 7000006"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000006, OnBeforeCreateReceivableDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforeCreateReceivableDoc_CU7000006(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    VAR
        CustLedgerEntry: Record 21;
        GLEntry: Record 17;
    BEGIN
        //A�adir campos propios en documentos de cartera a cobrar
        IF (GenJournalLine."Job No." <> '') THEN
            CarteraDoc."Job No." := GenJournalLine."Job No."
        ELSE BEGIN
            CustLedgerEntry.RESET;
            CustLedgerEntry.SETCURRENTKEY("Document No.");
            CustLedgerEntry.SETRANGE("Document No.", GenJournalLine."Document No.");
            CustLedgerEntry.SETRANGE("Document Date", GenJournalLine."Document Date");
            CustLedgerEntry.SETRANGE("Customer No.", GenJournalLine."Account No.");
            CustLedgerEntry.SETFILTER("QB Job No.", '<>%1', '');
            IF (CustLedgerEntry.FINDFIRST) THEN
                CarteraDoc."Job No." := CustLedgerEntry."QB Job No."
            ELSE BEGIN
                //Aqu� no debe llegar nunca, pero por si acaso
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                GLEntry.SETRANGE("Document No.", GenJournalLine."Document No.");
                GLEntry.SETRANGE("Document Date", GenJournalLine."Document Date");
                GLEntry.SETFILTER("Job No.", '<>%1', '');
                IF (GLEntry.FINDFIRST) THEN
                    CarteraDoc."Job No." := GLEntry."Job No."
                ELSE
                    CarteraDoc."Job No." := GenJournalLine."QB Job No.";
            END;
        END;

        //JAV 25/11/21: - QB 1.10.01 Pasar el banco
        CarteraDoc."QB Payment bank No." := GenJournalLine."QB Payment Bank No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7000006, OnBeforeCreatePayableDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforeCreatePayableDoc_CU7000006(VAR CarteraDoc: Record 7000002; GenJournalLine: Record 81);
    VAR
        VendorLedgerEntry: Record 25;
        GLEntry: Record 17;
    BEGIN
        //A�adir campos propios en documentos de cartera a pagar
        IF (GenJournalLine."Job No." <> '') THEN
            CarteraDoc."Job No." := GenJournalLine."Job No."
        ELSE BEGIN
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETCURRENTKEY("Document No.");
            VendorLedgerEntry.SETRANGE("Document No.", GenJournalLine."Document No.");
            VendorLedgerEntry.SETRANGE("Document Date", GenJournalLine."Document Date");
            VendorLedgerEntry.SETRANGE("Vendor No.", GenJournalLine."Account No.");
            VendorLedgerEntry.SETFILTER("QB Job No.", '<>%1', '');
            IF (VendorLedgerEntry.FINDFIRST) THEN
                CarteraDoc."Job No." := VendorLedgerEntry."QB Job No."
            ELSE BEGIN
                //Aqu� no debe llegar nunca, pero por si acaso
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                GLEntry.SETRANGE("Document No.", GenJournalLine."Document No.");
                GLEntry.SETRANGE("Document Date", GenJournalLine."Document Date");
                GLEntry.SETFILTER("Job No.", '<>%1', '');
                IF (GLEntry.FINDFIRST) THEN
                    CarteraDoc."Job No." := GLEntry."Job No.";
            END;
        END;

        //JAV 25/11/21: - QB 1.10.01 Pasar el banco
        CarteraDoc."QB Payment bank No." := GenJournalLine."QB Payment Bank No.";
    END;

    LOCAL PROCEDURE "Cambiar banco en movimientos registrados de clinete y proveedor"();
    BEGIN
    END;

    PROCEDURE ChangeVendorBank(DocNo: Code[20]; oldBank: Code[20]; newBank: Code[20]; pError: Boolean; pSkip: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        PurchInvHeader: Record 122;
        VendorLedgerEntry: Record 25;
        CarteraDoc: Record 7000002;
        WithholdingMovements: Record 7207329;
        Posted: Boolean;
    BEGIN
        //JAV 24/11/21: - QB 1.10.01 Modificar el banco de pago en movimientos de proveedor y en cartera

        //JAV 31/03/22 Se modifica el arreglo por cambios posteriores, se a�ade par�metro, se verifica coherencia
        IF (pError) THEN
            pSkip := FALSE;

        //Si es obligatorio indicar el banco, miro que el documento est� pendiente.
        QuoBuildingSetup.GET;
        IF (pError) AND (QuoBuildingSetup."Payment Bank Mandatory") AND (newBank = '') THEN BEGIN
            Posted := FALSE;
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Document No.", DocNo);
            VendorLedgerEntry.SETRANGE(Open, TRUE);
            IF VendorLedgerEntry.FINDSET THEN
                REPEAT
                    IF NOT (VendorLedgerEntry."Document Situation" IN [VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera]) THEN
                        Posted := TRUE;
                UNTIL VendorLedgerEntry.NEXT = 0;
            IF (NOT Posted) THEN
                ERROR('Es obligatorio indicar un banco de pago');
        END;

        //Solo si ha cambiado lo modificamos en los registros relacionados
        IF (oldBank <> newBank) THEN BEGIN
            //Se modifica en el documento registrado
            IF PurchInvHeader.GET(DocNo) THEN BEGIN
                PurchInvHeader."QB Payment Bank No." := newBank;
                PurchInvHeader.MODIFY;
            END;

            //Se modifica el campo de banco propio de los movimientos de proveedor
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Document No.", DocNo);
            VendorLedgerEntry.SETRANGE(Open, TRUE);
            IF VendorLedgerEntry.FINDSET THEN
                REPEAT
                    IF NOT (VendorLedgerEntry."Document Situation" IN [VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera]) THEN BEGIN
                        // EPV 30/03/22: - QB 1.10.29 (BUG) Si pError es TRUE significar� que no se puede cambiar el Banco, si es FALSE s� se cambiar�.
                        //                 En funci�n de si se llama desde el registro de la Reme./Ord. Pago, o desde un doc. o movto., el par�metro que se pase ser� uno u otro.
                        // JAV 31/03/22: - Se a�ade un par�metro para saltar el cambio, si se llama desde la ficha del proveedor no dar� error pero no tocar� estos documentos
                        IF (pSkip) THEN
                            EXIT;
                        IF (pError) THEN
                            ERROR('No puede cambiar el banco de pago cuando el documento est� en %1', VendorLedgerEntry."Document Situation");
                        // --> EPV 30/03/22 BUG
                    END;
                    VendorLedgerEntry.VALIDATE("QB Payable Bank No.", newBank);
                    VendorLedgerEntry.MODIFY;
                UNTIL VendorLedgerEntry.NEXT = 0;

            //Se modifica el campo de banco propio en los documentos de cartera pendientes, si est� en una remesa ya tiene un banco real asociado y no se toca
            CarteraDoc.RESET;
            CarteraDoc.SETRANGE("Document No.", DocNo);
            IF CarteraDoc.FINDSET THEN
                REPEAT
                    CarteraDoc."QB Payment bank No." := newBank;
                    CarteraDoc.MODIFY;
                UNTIL CarteraDoc.NEXT = 0;

            //Se modifica el campo de banco propio en los movimientos de retenciones
            WithholdingMovements.RESET;
            WithholdingMovements.SETRANGE("Document No.", DocNo);
            WithholdingMovements.SETRANGE("Withholding Type", WithholdingMovements."Withholding Type"::"G.E");
            IF WithholdingMovements.FINDSET THEN
                REPEAT
                    WithholdingMovements.VALIDATE("QB Payment bank No.", newBank);
                    WithholdingMovements.MODIFY;
                UNTIL WithholdingMovements.NEXT = 0;
        END;
    END;

    PROCEDURE ChangeCustomerBank(DocNo: Code[20]; oldBank: Code[20]; newBank: Code[20]; pError: Boolean; pSkip: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        SalesInvoiceHeader: Record 112;
        CustLedgerEntry: Record 21;
        CarteraDoc: Record 7000002;
        WithholdingMovements: Record 7207329;
        Posted: Boolean;
    BEGIN
        //JAV 24/11/21: - QB 1.10.01 Modificar el banco de pago en movimientos de cliente y en cartera

        //JAV 31/03/22 Se modifica el arreglo por cambios posteriores, se a�ade par�metro, se verifica coherencia
        IF (pError) THEN
            pSkip := FALSE;

        //Si es obligatorio indicar el banco, miro que el documento est� pendiente
        QuoBuildingSetup.GET;
        IF (pError) AND (QuoBuildingSetup."Payment Bank Mandatory") AND (newBank = '') THEN BEGIN
            Posted := FALSE;
            CustLedgerEntry.RESET;
            CustLedgerEntry.SETRANGE("Document No.", DocNo);
            CustLedgerEntry.SETRANGE(Open, TRUE);
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    IF NOT (CustLedgerEntry."Document Situation" IN [CustLedgerEntry."Document Situation"::" ", CustLedgerEntry."Document Situation"::Cartera]) THEN
                        Posted := TRUE;
                UNTIL CustLedgerEntry.NEXT = 0;
            IF (NOT Posted) THEN
                ERROR('Es obligatorio indicar un banco de pago');
        END;

        //Solo si ha cambiado lo modificamos en los registros relacionados
        IF (oldBank <> newBank) THEN BEGIN
            //Se modifica en el documento registrado
            IF SalesInvoiceHeader.GET(DocNo) THEN BEGIN
                SalesInvoiceHeader."Payment bank No." := newBank;
                SalesInvoiceHeader.MODIFY;
            END;

            //Se modifica el campo de banco propio de los movimientos de clientes
            CustLedgerEntry.RESET;
            CustLedgerEntry.SETRANGE("Document No.", DocNo);
            CustLedgerEntry.SETRANGE(Open, TRUE);
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    IF NOT (CustLedgerEntry."Document Situation" IN [CustLedgerEntry."Document Situation"::" ", CustLedgerEntry."Document Situation"::Cartera]) THEN BEGIN
                        // EPV 30/03/22: - QB 1.10.29 (BUG) Si pError es TRUE significar� que no se puede cambiar el Banco, si es FALSE s� se cambiar�.
                        //                 En funci�n de si se llama desde el registro de la Reme./Ord. Pago, o desde un doc. o movto., el par�metro que se pase ser� uno u otro.
                        // JAV 31/03/22: - Se a�ade un par�metro para saltar el cambio, si se llama desde la ficha del proveedor no dar� error pero no tocar� estos documentos
                        IF (pSkip) THEN
                            EXIT;
                        IF (pError) THEN
                            ERROR('No puede cambiar el banco de pago cuando el documento est� en %1', CustLedgerEntry."Document Situation");
                        // --> EPV 30/03/22 BUG
                    END;
                    CustLedgerEntry.VALIDATE("QB Receivable Bank No.", newBank);
                    CustLedgerEntry.MODIFY;
                UNTIL CustLedgerEntry.NEXT = 0;

            //Se modifica el campo de banco propio en los documentos de cartera pendientes, si est� en una remesa ya tiene un banco real asociado y no se toca
            CarteraDoc.RESET;
            CarteraDoc.SETRANGE("Document No.", DocNo);
            IF CarteraDoc.FINDSET THEN
                REPEAT
                    CarteraDoc."QB Payment bank No." := newBank;
                    CarteraDoc.MODIFY;
                UNTIL CarteraDoc.NEXT = 0;

            //Se modifica el campo de banco propio en los movimientos de retenciones
            WithholdingMovements.RESET;
            WithholdingMovements.SETRANGE("Document No.", DocNo);
            WithholdingMovements.SETRANGE("Withholding Type", WithholdingMovements."Withholding Type"::"G.E");
            IF WithholdingMovements.FINDSET THEN
                REPEAT
                    WithholdingMovements.VALIDATE("QB Payment bank No.", newBank);
                    WithholdingMovements.MODIFY;
                UNTIL WithholdingMovements.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU propias de QB"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, ItemOutputCheckLine, '', true, true)]
    LOCAL PROCEDURE ItemOutputCheckLine(VAR OutboundWarehouseLines: Record 7207309; ItemCheckAvail: Codeunit 311);
    VAR
        FunctionQB: Codeunit 7207272;
        Rollback: Boolean;
        boolean: Boolean;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            ItemLineOutputShowWarning(OutboundWarehouseLines, boolean);
            //JMMA   IF boolean THEN
            //JMMA     Rollback := ItemCheckAvail.ShowAndHandleAvailabilityPage;
        END;
    END;

    LOCAL PROCEDURE ItemLineOutputShowWarning(OutboundWarehouseLines: Record 7207309; VAR P_Boolean: Boolean);
    VAR
        ItemJournalLine: Record 83;
        SalesReceivablesSetup: Record 311;
        ItemNetChange: Decimal;
        ItemCheckAvail: Codeunit 311;
    BEGIN
        //JAV 04/07/22: - QB 1.10.58 Se refactoriaza la funci�n ItemLineOutputShowWarning para usar otra funci�n diferente de la CU 311 ItemCheckAvail
        SalesReceivablesSetup.GET;
        IF NOT SalesReceivablesSetup."Stockout Warning" THEN
            P_Boolean := FALSE;
        ItemNetChange := -OutboundWarehouseLines.Quantity;

        // P_Boolean := ItemCheckAvail.QB_ItemLineOutputShowWarning(OutboundWarehouseLines."No.",'',OutboundWarehouseLines."Outbound Warehouse",OutboundWarehouseLines."Unit of Measure Code",
        //                                                          OutboundWarehouseLines."Unit of Mensure Quantity",ItemNetChange,0,0D,0D);

        //Creamos un registro de Item Journal Line para pasarlo a la funci�n
        ItemJournalLine.INIT;
        ItemJournalLine."Item No." := OutboundWarehouseLines."No.";
        ItemJournalLine."Variant Code" := '';
        ItemJournalLine."Location Code" := OutboundWarehouseLines."Outbound Warehouse";
        ItemJournalLine."Unit of Measure Code" := OutboundWarehouseLines."Unit of Measure Code";
        ItemJournalLine."Qty. per Unit of Measure" := OutboundWarehouseLines."Unit of Mensure Quantity";
        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
        ItemJournalLine.Quantity := OutboundWarehouseLines.Quantity;  //El proceso lo cambia a negativo
        P_Boolean := ItemCheckAvail.ItemJnlLineShowWarning(ItemJournalLine);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnGetJobConsumptionValueEntryJobJnlPostLine, '', true, true)]
    LOCAL PROCEDURE FilterTypeOnGetJobConsumptionValueEntryJobJnlPostLine(VAR ValueEntry: Record 5802);
    BEGIN
        ValueEntry.SETFILTER("Item Ledger Entry Type", '%1|%2',
                                 ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                                 ValueEntry."Item Ledger Entry Type"::Sale);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnInitCreateJobLedgEntryJobJnlPostLine, '', true, true)]
    LOCAL PROCEDURE IsJobPostingOnlyOnInitCreateJobLedgEntryJobJnlPostLine(VAR JobLedgEntry: Record 169; JobJnlLine2: Record 210);
    BEGIN
        JobLedgEntry.Quantity := JobJnlLine2.Quantity;
        JobLedgEntry."Quantity (Base)" := JobJnlLine2."Quantity (Base)";

        JobLedgEntry."Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)";
        JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost";

        JobLedgEntry."Total Price (LCY)" := JobJnlLine2."Total Price (LCY)";
        JobLedgEntry."Total Price" := JobJnlLine2."Total Price";

        JobLedgEntry."Line Amount (LCY)" := JobJnlLine2."Line Amount (LCY)";
        JobLedgEntry."Line Amount" := JobJnlLine2."Line Amount";

        JobLedgEntry."Line Discount Amount (LCY)" := JobJnlLine2."Line Discount Amount (LCY)";
        JobLedgEntry."Line Discount Amount" := JobJnlLine2."Line Discount Amount";

        JobLedgEntry."Additional-Currency Total Cost" := JobLedgEntry."Additional-Currency Total Cost";
        JobLedgEntry."Add.-Currency Total Price" := JobLedgEntry."Add.-Currency Total Price";
        JobLedgEntry."Add.-Currency Line Amount" := JobLedgEntry."Add.-Currency Line Amount";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnTypeSaleCreateJobLedgEntryJobJnlPostLine, '', true, true)]
    LOCAL PROCEDURE ValueUnitPriceOnTypeSaleCreateJobLedgEntryJobJnlPostLine(VAR JobLedgEntry: Record 169);
    BEGIN
        IF JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Sale THEN
            IF JobLedgEntry.Quantity <> 0 THEN BEGIN
                JobLedgEntry."Unit Price (LCY)" := JobLedgEntry."Total Price (LCY)" / JobLedgEntry.Quantity;
                JobLedgEntry."Unit Price" := JobLedgEntry."Total Price" / JobLedgEntry.Quantity;
            END;
        IF JobLedgEntry."Line Type" = JobLedgEntry."Line Type"::" " THEN
            JobLedgEntry."Line Type" := JobLedgEntry."Line Type"::"Both Budget and Billable";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, AdditionalControlGenJnlCheckLine, '', true, true)]
    LOCAL PROCEDURE AdditionalControlGenJnlCheckLine(recLinJnlGen: Record 81);
    VAR
        UserFunctionQB: Codeunit 7207272;
        modificManagement: Codeunit 7207273;
    BEGIN
        //Llamada a una funci�n que establece un control sobre la cuenta de contrapartida.
        IF (UserFunctionQB.AccessToQuobuilding) THEN
            modificManagement.AdditionalControls(recLinJnlGen);

        UnSetLineJobNo(recLinJnlGen); //JAV 11/08/21: - QB 1.09.16 Poner otra vez el proyecto
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, CreateActiveDimGenJnlPostLine, '', true, true)]
    LOCAL PROCEDURE CreateActiveDimGenJnlPostLine(VAR GenJnlLine: Record 81; TempFAGLPostBuff: Record 5637);
    VAR
        ModificManagement: Codeunit 7207273;
    BEGIN
        IF TempFAGLPostBuff."Job No." <> '' THEN BEGIN
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::"Fixed Asset";
            GenJnlLine."Source No." := GenJnlLine."Account No.";
            //-Q20269
            GenJnlLine."Piecework Code" := TempFAGLPostBuff."Piecework Code";
            //+Q20269
            ModificManagement.FunCreateAssetsDim(GenJnlLine, TempFAGLPostBuff."Account No.", TempFAGLPostBuff."Job No.");
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, ReturnDimensionesFinishPostingGenJnlPostLine, '', true, true)]
    LOCAL PROCEDURE ReturnDimensionesFinishPostingGenJnlPostLine(VAR GenJnlLineQB: Record 81; VAR boolReturnDim: Boolean; GlobalGLEntry: Record 17; DimensionSetID: Integer);
    VAR
        RecGLAccount: Record 15;
        DimMgt: Codeunit 408;
    BEGIN
        IF GenJnlLineQB."Source Type" <> GenJnlLineQB."Source Type"::"Fixed Asset" THEN BEGIN
            RecGLAccount.GET(GlobalGLEntry."G/L Account No.");
            IF RecGLAccount."Income/Balance" = RecGLAccount."Income/Balance"::"Balance Sheet" THEN BEGIN

                IF NOT boolReturnDim THEN
                    EXIT;

                GenJnlLineQB."Dimension Set ID" := DimensionSetID;
                DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLineQB."Dimension Set ID", GenJnlLineQB."Shortcut Dimension 1 Code", GenJnlLineQB."Shortcut Dimension 2 Code");
                boolReturnDim := FALSE;
            END ELSE
                IF GenJnlLineQB."Currency Code" = '' THEN
                    boolReturnDim := FALSE;

        END ELSE
            boolReturnDim := FALSE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, InheritFieldsGLEntryGenJnlPostLine, '', true, true)]
    LOCAL PROCEDURE InheritFieldsGLEntryGenJnlPostLine(VAR GLEntry: Record 17; VAR GenJnlLine: Record 81; GLAccNo: Code[20]);
    VAR
        FunctionQB: Codeunit 7207272;
        ModificManagement: Codeunit 7207273;
    BEGIN

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            ModificManagement.FunInheritFieldsGL(GenJnlLine, GLEntry);

            IF GLAccNo <> '' THEN
                ModificManagement.FunCreateAllocation(GenJnlLine, GLEntry);
            //Gestion de UTES
            GLEntry."QB Destination Entry JV" := GenJnlLine."Destination Entry JV";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, CheckRemainingUnrealizedVATGenJnlPostLine, '', true, true)]
    LOCAL PROCEDURE CheckRemainingUnrealizedVATGenJnlPostLine(VATPostingSetup: Record 325; VATEntry2: Record 254; VAR VATPart: Decimal; CustLedgerEntryDocNo: Code[20]);
    VAR
        CustLedgEntry: Record 21;
    BEGIN
        IF (VATPostingSetup."Unrealized VAT Type" > 0) AND
                   ((VATEntry2."Remaining Unrealized Amount" <> 0) OR
                   (VATEntry2."Remaining Unrealized Base" <> 0)) THEN BEGIN
            CustLedgEntry.SETRANGE("Document No.", CustLedgerEntryDocNo);
            CustLedgEntry.SETRANGE(Open, TRUE);
            IF NOT CustLedgEntry.FINDFIRST THEN
                VATPart := 1;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, CheckRemainingUnrealizedVATVendorLedgerGenJnlPostLine, '', true, true)]
    LOCAL PROCEDURE CheckRemainingUnrealizedVATVendLedgGenJnlPostLine(VATPostingSetup: Record 325; VATEntry2: Record 254; VAR VATPart: Decimal; VendLedgerEntryDocNo: Code[20]);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        IF (VATPostingSetup."Unrealized VAT Type" > 0) AND
                   ((VATEntry2."Remaining Unrealized Amount" <> 0) OR
                   (VATEntry2."Remaining Unrealized Base" <> 0)) THEN BEGIN

            VendLedgEntry.SETRANGE("Document No.", VendLedgerEntryDocNo);
            VendLedgEntry.SETRANGE(Open, TRUE);
            IF NOT VendLedgEntry.FINDFIRST THEN
                VATPart := 1;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, ResetLedgerEntryGenJnlPostLine, '', true, true)]
    LOCAL PROCEDURE ResetLedgEntryGenJnlPostLine(VAR NextEntryNo: Integer);
    BEGIN
        CLEAR(NextEntryNo);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnSaveStatusBlanketPurchOrdertoOrder, '', true, true)]
    LOCAL PROCEDURE RunOnSaveStatusBlanketPurchOrdertoOrder(VAR PurchaseHeader: Record 38; VAR PurchHeader_Status: Record 38);
    BEGIN
        PurchHeader_Status.Status := PurchaseHeader.Status;
        PurchaseHeader.Status := PurchaseHeader.Status::Open;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnFindResPriceNewResourceFindPrice, '', true, true)]
    LOCAL PROCEDURE RunOnFindResPriceNewResourceFindPrice(ResPrice: Record 201; VAR ResPrice2: Record 201; VAR AnswerPar: Boolean);
    VAR
        Resource: Record 156;
    BEGIN
        WITH ResPrice DO BEGIN
            IF Resource.GET(Code) THEN;
            IF ResPrice2.GET(Type::Resource, Code, "Work Type Code", "Currency Code", "Job No.") THEN
                AnswerPar := TRUE
            ELSE
                IF ResPrice2.GET(Type::Resource, Code, "Work Type Code", '', "Job No.") THEN
                    AnswerPar := TRUE
                ELSE
                    IF ResPrice2.GET(Type::"Group(Resource)", Resource."Resource Group No.", "Work Type Code", "Currency Code", "Job No.") THEN
                        AnswerPar := TRUE
                    ELSE
                        IF ResPrice2.GET(Type::"Group(Resource)", Resource."Resource Group No.", "Work Type Code", '', "Job No.") THEN
                            AnswerPar := TRUE
                        ELSE
                            IF ResPrice2.GET(Type::All, '', "Work Type Code", "Currency Code", "Job No.") THEN
                                AnswerPar := TRUE
                            ELSE
                                IF ResPrice2.GET(Type::All, '', "Work Type Code", '', "Job No.") THEN
                                    AnswerPar := TRUE
                                ELSE
                                    IF ResPrice2.GET(Type::Resource, Code, "Work Type Code", "Currency Code", '') THEN
                                        AnswerPar := TRUE
                                    ELSE
                                        IF ResPrice2.GET(Type::Resource, Code, "Work Type Code", '', '') THEN
                                            AnswerPar := TRUE
                                        ELSE
                                            IF ResPrice2.GET(Type::"Group(Resource)", Resource."Resource Group No.", "Work Type Code", "Currency Code", '') THEN
                                                AnswerPar := TRUE
                                            ELSE
                                                IF ResPrice2.GET(Type::"Group(Resource)", Resource."Resource Group No.", "Work Type Code", '', '') THEN
                                                    AnswerPar := TRUE
                                                ELSE
                                                    IF ResPrice2.GET(Type::All, '', "Work Type Code", "Currency Code", '') THEN
                                                        AnswerPar := TRUE
                                                    ELSE
                                                        IF ResPrice2.GET(Type::All, '', "Work Type Code", '', '') THEN
                                                            AnswerPar := TRUE;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, TestLinDiaproyCJobJnlCheckLine, '', true, true)]
    LOCAL PROCEDURE RunTestLinDiaproyCJobJnlCheckLine(VAR JobJnlLine: Record 210);
    VAR
        Job: Record 167;
        Text001: TextConst ENU = 'Piecework Code or greater of job units is obligatory for Job %1', ESP = 'Unidad de obra o mayor de unidad de obra es obligatoria para proyecto %1';
        Text002: TextConst ENU = 'Job %1 you should assign a Work', ESP = 'En el proyecto %1 debe imputar a un trabajo';
        Text003: TextConst ENU = 'It is only possible to impute to Piecework Code', ESP = 'Solo es posible imputar a unidades de de obra';
        Text004: TextConst ENU = 'The Piecework Code %1 is not a Production Unit', ESP = 'La unidad de obra %1 del proyecto %2 no es una unidad de control de producci�n';
        Text005: TextConst ENU = 'You can only allocate tasks to the Job for %1', ESP = 'Solo es posible imputar por tareas al proyecto %1';
        DataPieceworkForProduction: Record 7207386;
        QuoBuildingSetup: Record 7207278;
        GLAccount: Record 15;
    BEGIN
        Job.GET(JobJnlLine."Job No.");

        IF JobJnlLine."Entry Type" = JobJnlLine."Entry Type"::Usage THEN BEGIN
            CASE Job."Mandatory Allocation Term By" OF
                Job."Mandatory Allocation Term By"::"AT Any Level":
                    BEGIN
                        IF JobJnlLine."Piecework Code" = '' THEN
                            ERROR(Text001, JobJnlLine."Job No.");
                    END;
                Job."Mandatory Allocation Term By"::"Only Per Piecework":
                    BEGIN
                        IF JobJnlLine."Piecework Code" = '' THEN
                            ERROR(Text003, JobJnlLine."Job No.")
                        ELSE BEGIN
                            DataPieceworkForProduction.GET(Job."No.", JobJnlLine."Piecework Code");
                            IF DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading THEN
                                ERROR(Text003, JobJnlLine."Job No.");
                            IF NOT DataPieceworkForProduction."Production Unit" THEN
                                ERROR(Text004, DataPieceworkForProduction."Piecework Code", Job."No."); //JAV 08/07/19: - Se mejora el mensaje de error de la U.O. a�adiendo el proyecto al que pertenece
                        END;
                    END;
            END;
        END;

        IF (Job."Allocation Item by Unfold") AND
           (Job."Job Matrix - Work" = Job."Job Matrix - Work"::"Matrix Job") THEN
            ERROR(Text002, JobJnlLine."Job No.");

        IF Job."Management by tasks" THEN
            IF JobJnlLine."Job Task No." = '' THEN
                ERROR(Text005, JobJnlLine."Job No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, ExistsPurchaseJournalLineCUCalcItemPlanWksh, '', true, true)]
    LOCAL PROCEDURE RunExistsPurchaseJournalLineCUCalcItemPlanWksh(Item: Record 27; VAR ExistsPurchJnLine: Boolean);
    VAR
        PurchaseJournalLine: Record 7207281;
    BEGIN
        PurchaseJournalLine.RESET;
        PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Item);
        PurchaseJournalLine.SETRANGE("No.", Item."No.");
        IF NOT PurchaseJournalLine.ISEMPTY THEN
            ExistsPurchJnLine := TRUE;
    END;

    LOCAL PROCEDURE TransferFromPurchJnlLine(PurchJnlLine: Record 7207281; RecID: RecordID);
    VAR
        InventoryEventBuffer: Record 5530;
        RecRef: RecordRef;
    BEGIN
        IF PurchJnlLine.Type <> PurchJnlLine.Type::Item THEN
            EXIT;

        InventoryEventBuffer.INIT;
        RecRef.GETTABLE(PurchJnlLine);
        InventoryEventBuffer."Source Line ID" := RecID;
        InventoryEventBuffer."Item No." := PurchJnlLine."No.";
        InventoryEventBuffer."Location Code" := PurchJnlLine."Location Code";
        InventoryEventBuffer."Availability Date" := PurchJnlLine."Date Needed";
        InventoryEventBuffer.Type := InventoryEventBuffer.Type::Job;
        InventoryEventBuffer."Remaining Quantity (Base)" := -PurchJnlLine.Quantity;
        InventoryEventBuffer.Positive := NOT (PurchJnlLine.Quantity < 0);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, GetSourceReferencesCUCalcItemAvailabiity, '', true, true)]
    LOCAL PROCEDURE GetSourceReferencesCUCalcItemAvailabiity(VAR SourceType: Integer; VAR SourceID: Code[20]; VAR SourceBatchName: Code[10]; VAR SourceRefNo: Integer);
    VAR
        RecRef: RecordRef;
        PurchaseJournalLine: Record 7207281;
    BEGIN
        BEGIN
            RecRef.SETTABLE(PurchaseJournalLine);
            SourceType := DATABASE::"Purchase Journal Line";
            SourceID := PurchaseJournalLine."Job No.";
            SourceBatchName := '';
            SourceRefNo := PurchaseJournalLine."Line No.";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, ShowDocumentCUCacItemAvailability, '', true, true)]
    LOCAL PROCEDURE ShowDocumentCUCacItemAvailability(CalcItemAvailability: Codeunit 5530);
    VAR
        RecRef: RecordRef;
        PurchaseJournalLine: Record 7207281;
        AssemblyHeader: Record 900;
    BEGIN
        BEGIN
            RecRef.SETTABLE(PurchaseJournalLine);
            PAGE.RUNMODAL(PAGE::"Purchase Journal Line", PurchaseJournalLine);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, OnRunCUFAInsertGLAccount, '', true, true)]
    LOCAL PROCEDURE OnRunCUFAInsertGLAccount(VAR FALedgerEntry: Record 5601);
    VAR
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
        FADepreciationBook: Record 5612;
        FAGLPostingBuffer: Record 5637;
        FixedAsset: Record 5600;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF FAGLPostingBuffer."Account No." <> '' THEN BEGIN
                IF GLAccount.GET(FAGLPostingBuffer."Account No.") THEN BEGIN
                    IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                        //JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
                        //FADepreciationBook.GET(FALedgerEntry."FA No.",FALedgerEntry."Depreciation Book Code");
                        //FAGLPostingBuffer."Job No." := FADepreciationBook."OLD_Asset Allocation Job";
                        FixedAsset.GET(FALedgerEntry."FA No.");
                        FAGLPostingBuffer."Job No." := FixedAsset."Asset Allocation Job";
                    END;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, InsertMaintenanceAccNoCUFAInsertGLAccount, '', true, true)]
    LOCAL PROCEDURE InsertMaintenanceAccNoCUFAInsertGLAccount(VAR MaintenanceLedgerEntry: Record 5625);
    VAR
        FunctionQB: Codeunit 7207272;
        FAGLPostingBuffer: Record 5637;
        GLAccount: Record 15;
        FADepreciationBook: Record 5612;
        FixedAsset: Record 5600;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF FAGLPostingBuffer."Account No." <> '' THEN BEGIN
                IF GLAccount.GET(FAGLPostingBuffer."Account No.") THEN BEGIN
                    IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                        //JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
                        //FADepreciationBook.GET(MaintenanceLedgerEntry."FA No.",MaintenanceLedgerEntry."Depreciation Book Code");
                        //FAGLPostingBuffer."Job No." := FADepreciationBook."OLD_Asset Allocation Job";
                        FixedAsset.GET(MaintenanceLedgerEntry."FA No.");
                        FAGLPostingBuffer."Job No." := FixedAsset."Asset Allocation Job";
                    END;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, InsertBufferBalAccCUFAInsertGLAccount, '', true, true)]
    LOCAL PROCEDURE InsertBufferBalAccCUFAInsertGLAccount(FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss"; AllocAmount: Decimal; DeprBookCode: Code[20]; PostingGrCode: Code[20]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; DimSetID: Integer; AutomaticEntry: Boolean; Correction: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        FAGLPostingBuffer: Record 5637;
        FAAllocation: Record 5615;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FAGLPostingBuffer."Job No." := FAAllocation."Job No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, InsertBufferBalAcc2CUFAInsertGLAccount, '', true, true)]
    LOCAL PROCEDURE InsertBufferBalAcc2CUFAInsertGLAccount(FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss"; AllocAmount: Decimal; DeprBookCode: Code[20]; PostingGrCode: Code[20]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; DimSetID: Integer; AutomaticEntry: Boolean; Correction: Boolean; GLAccNo: Code[20]);
    VAR
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
        FAGLPostingBuffer: Record 5637;
        FAAllocation: Record 5615;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GlobalDim2Code = '' THEN BEGIN
                GLAccount.GET(GLAccNo);
                FAGLPostingBuffer."Global Dimension 2 Code" := GLAccount."Global Dimension 2 Code";
            END;
            FAGLPostingBuffer."Job No." := FAAllocation."Job No.";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, InsertBalAccCUFAInsertGLAccount, '', true, true)]
    LOCAL PROCEDURE InsertBalAccCUFAInsertGLAccount(VAR FALedgerEntry: Record 5601);
    VAR
        FunctionQB: Codeunit 7207272;
        FAAllocation: Record 5615;
        FADepreciationBook: Record 5612;
        FixedAsset: Record 5600;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF FAAllocation."Job No." = '' THEN BEGIN
                //JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
                //FADepreciationBook.GET(FALedgerEntry."FA No.",FALedgerEntry."Depreciation Book Code");
                //FAAllocation."Job No." := FADepreciationBook."OLD_Asset Allocation Job";
                //FAAllocation."Piecework Code" := FADepreciationBook."OLD_Piecework Code";
                FixedAsset.GET(FALedgerEntry."FA No.");
                FAAllocation."Job No." := FixedAsset."Asset Allocation Job";
                FAAllocation."Piecework Code" := FixedAsset."Piecework Code";
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, PostUpdateWhseDocumentsCUWhsePostReceipt, '', true, true)]
    LOCAL PROCEDURE PostUpdateWhseDocumentsCUWhsePostReceipt(VAR WarehouseReceiptHeader: Record 7316);
    VAR
        WarehouseReceiptLine2: Record 7317;
    BEGIN
        BEGIN
            WarehouseReceiptLine2."Qty. Outstanding" := WarehouseReceiptLine2."Qty. Outstanding" - WarehouseReceiptLine2."Qty. to Receive";
            WarehouseReceiptLine2.TESTFIELD("Qty. per Unit of Measure");
            WarehouseReceiptLine2."Qty. Outstanding (Base)" :=
              ROUND(WarehouseReceiptLine2."Qty. Outstanding" * WarehouseReceiptLine2."Qty. per Unit of Measure", 0.00001);
            WarehouseReceiptLine2."Qty. to Receive" := 0;
            WarehouseReceiptLine2."Qty. to Receive (Base)" := 0;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, PostInvtPostBufCUInventoryPostingToGL, '', true, true)]
    LOCAL PROCEDURE PostInvtPostBufCUInventoryPostingToGL(GenJournalLine: Record 81; InvtPostingBuffer: Record 48);
    VAR
        FunctionQB: Codeunit 7207272;
        CodeunitModificManagement: Codeunit 7207273;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            CodeunitModificManagement.VariationStock(GenJournalLine, InvtPostingBuffer);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, FindSalesLinePriceCUSalesPriceCalcMgt, '', true, true)]
    LOCAL PROCEDURE FindSalesLinePriceCUSalesPriceCalcMgt(SalesHeader: Record 36; VAR SalesLine: Record 37);
    VAR
        SalesPriceCalcMgt: Codeunit 7000;
        SalesPriceCalcMgt2: Codeunit 50021;
    BEGIN
        SalesPriceCalcMgt2.QB_SetResPrice(SalesLine."No.", SalesLine."Work Type Code", SalesLine."Currency Code", SalesLine."Job No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, FindServLinePriceCUSalesPriceCalcMgt, '', true, true)]
    LOCAL PROCEDURE FindServLinePriceCUSalesPriceCalcMgt(ServiceHeader: Record 5900; VAR ServiceLine: Record 5902);
    VAR
        SalesPriceCalcMgt: Codeunit 7000;
        SalesPriceCalcMgt2: Codeunit 50021;
    BEGIN
        SalesPriceCalcMgt2.QB_SetResPrice(ServiceLine."No.", ServiceLine."Work Type Code", ServiceLine."Currency Code", ServiceLine."Job No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, FindJobPlanningLinePriceCUSalesPriceCalcMgt, '', true, true)]
    LOCAL PROCEDURE FindJobPlanningLinePriceCUSalesPriceCalcMgt(VAR JobPlanningLine: Record 1003; CalledByFieldNo: Integer);
    VAR
        SalesPriceCalcMgt: Codeunit 7000;
        SalesPriceCalcMgt2: Codeunit 50021;
    BEGIN
        SalesPriceCalcMgt2.QB_SetResPrice(JobPlanningLine."No.", JobPlanningLine."Work Type Code", JobPlanningLine."Currency Code", JobPlanningLine."Job No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207352, FindJobJbLinePriceCUSalesPriceCalcMgt, '', true, true)]
    LOCAL PROCEDURE FindJobJbLinePriceCUSalesPriceCalcMgt(VAR JobJnlLine: Record 210; CalledByFieldNo: Integer);
    VAR
        SalesPriceCalcMgt: Codeunit 7000;
        SalesPriceCalcMgt2: Codeunit 50021;
    BEGIN
        SalesPriceCalcMgt2.QB_SetResPrice(JobJnlLine."No.", JobJnlLine."Work Type Code", JobJnlLine."Currency Code", JobJnlLine."Job No.");   // QB
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE Event_OnBeforeConfirmPost_CU91(VAR PurchaseHeader: Record 38; VAR HideDialog: Boolean; VAR IsHandled: Boolean; VAR DefaultOption: Integer);
    BEGIN
    END;

    /*BEGIN
/*{
      PEL 21/05/18: - QVE_1853 A�adido GLAccNo a InsertBufferBalAcc2CUFAInsertGLAccount
      qb2130
      PEL         : - QB3257 Error SII duplicado
      JAV 08/07/19: - Se mejora el mensaje de error de la U.O. a�adiendo el proyecto al que pertenece
      PGM 30/04/19: - QCPM_GAP18 Se controla si la factura a registrar supera el plazo de registro.
      JAV 11/10/19: - Se elimina la funci�n "RunOpenClosePurchaseOrder" y sus llamadas pues no hace nada �til
      JAV 21/10/19: - Se trasladan las funciones relacionadas con las retenciones a la CU de retenciones
                                      GenerateCustomerWithholdingMovs
                                      GenerateVendorWithholdingMovs
                                      GenerateWithholdingMovsSalesPost
                                      AddTotalWithholdingLCYSalesPost
                                      GenerateWithholdingMovsPurchasePost
                                      AddOrSubtractTotalWithholdingPurchasePost
                                      AdjustWithholdingsSalesPost
                                      AdjustWithholdingsPurchasePost
                                      GetNotApplicableAmountApliccSalesPost
                                      AddOrSubtractTotalWithholdingSalesPost
                                      GetNotApplicableAmountApliccPurchasePost
                                      InitWithholdingFieldsOnReopenATOsReleaseSalesDoc
                                      UpdateSalesLineCUCopyDocumentMgt
                                      UpdatePurchLineCUCopyDocumentMgt
                                      Cod12_OnAfterInitVendLedgEntry
                                      Cod12_OnAfterInitCustLedgEntry
      JAV 09/09/20: - QB 1.06.12 - Se amplian los campos modificados en facturas de venta creando una funci�n "UpdateSalesInvoiceHeader"
      PGM 07/10/20: - QB 1.06.20 Provisionar albaranes por tipo Shipment
      JAV 09/10/20: - QB 1.06.20 Cambio el evento propio "InheritFieldsDetailedVendorGenJnlPostLine" por el evento est�ndar de la CU 12
      JAV 10/10/20: - QB 1.06.20 Se eliminan las respuestas a losw eventos OnAfterInsertDtldCustLedgEntry_CU12 y OnAfterInsertDtldVendLedgEntry_CU12 pues no se usan ya
      JAV 10/10/20: - QB 1.06.20 Nueva respuesta de evento al crear la cabecera del albar�n de compra por las divisas
      JAV 17/10/20: - QB 1.06.21 Se eliminan la funci�n "GetBalAccCUAFInsertGLAccount" que no hace nada, y se a�ade respuestas de eventos para la CU 5601
                                 Se a�ade la funci�n ChangePurchInvHeader_CU1405 para cambiar datos de las facturas registradas
      JAV 10/12/20: - QB 1.07.11 Se pasan de evento a funci�n para su uso mas r�pido desde la CU80, y se renombran las funciones:
                                      EmptyJobEntryCUSalesPost                  -> EmptyJobEntry_CU80
                                      ExitIfExistJobNoCUSalesPost               -> ExitIfJobExist_CU80
                                      UpdateInvoicedCertAndMilestoneCUSalesPost -> UpdateInvoicedCertAndMilestone_CU80
                                      UpdateInvoicedCertCUSalesPost             -> UpdateInvoicedCert_CU80
                                      PostJobManualCUSalesPost                  -> PostJobManual_CU80
                                      GenerateConsumptionOfJobCUSalesPost       -> GenerateConsumptionOfJob_CU80
                                      ModifyGenJnlLineCUSalesPost               -> ModifyGenJnlLine_CU80
                                      ExitIfExistJobNoSalesHeaderCUSalesPost    -> Esta no se usa, se elimina directamente
      JAV 07/01/21: - QB 1.07.19 Se elimina la funci�n "InheritFieldsVATGenJnlPostLine" que no se usa
      QMD 23/06/21: - Q13715 Limitar registros por fechas
      JAV 15/12/21: - QB 1.10.07 Se a�aden los datos de la provisi�n y se elimina el almac�n
      CPA 15/12/21: - QB 1.10.23 (Q15921) - Trazabilidad en albaranes de almac�n. Mod: GeneratePurchaseRcpt_OnRunPurchPostPurchaseRcpt_CU90  New: GeneratePurchaseRcpt_OnRunPurchPostReturnShipment_CU90
      DGG 21/12/21: - QRE16040:En las funciones:InsertBufferBalAccCUFAInsertGLAccount, InsertBufferBalAcc2CUFAInsertGLAccount, se amplia el tama�o del parametro PostingGrCode de 10 a 20.
      LCG 13/01/22: - RE15718 Si se trata de una oferta no pedir que informe el proyecto.
      CPA 28/01/22: - QB 1.10.23 (Q16247) - Deshacer l�neas recepci�n de compras de productos da error Modificaciones: OnBeforeOnRun_CU5813
      AML 28/03/22: - QB_ST01 - Deshacer l�neas recepci�n de compras de productos da error Modificaciones: OnBeforeOnRun_CU5813. Se anula la llamada recursiva.
      EPV 30/03/22: - QB 1.10.29 (Bug) - Al registrar �rdenes de pago no modifica el movimiento de proveedor. JAV 31/03/22 Se modifica el arreglo por cambios posteriores
      JAV 20/04/22: - QB 1.10.36 Se dan permisos para las tablas que se modifican al cambiar el banco de pago en las Remesas/�rdenes de pago 21,25,112,114,122,124,7000002,7207329
      JAV 27/04/22: - QB 1.10.37 Se eliminan las funciones RunOnTestfieldLocationCodeReleasePurchDoc y OnRestrictionsReleasePurchDoc
      JAV 25/05/22: - QB 1.10.44 Se a�ade la partida presupuestaria en el diario desde el documento de cliente o de proveedor
                                 Se elimina la funci�n InheritFieldVendor y la funci�n FunInheritFieldVendor de la CU 7207273, en su lugar se captura el evento OnAfterInitVendLedgEntry de la CU 12
                                 Se incluye la partida presupuestaria en el movimiento del cliente y del proveedor
      AML 14/06/22: - QB 1.10.49 Si est� activo el nuevo sistema de stock saltar este control  --> 22/06/22 Se elimina
      JAV 16/06/22: - QB 1.10.50 El campo que se usaba no era el correcto para la unidad de obra/partida presupuestaria
                                 Ampliamos el tratamiento en la funci�n UpdateLinePurchase_OnRunGenJnlPostLinePurchPost_CU90 para que contemple QB/RE/CECO
                                 Informarmos de la U.O./Partida en la l�nea
                                 Si el asiento no tiene proyecto eliminamos unidad de obra/partida
                                 Se cambia la funci�n "UpdateLinePurchase_OnRunGenJnlPostLinePurchPost_CU90" para que en lugar de llamarse desde la CU 7207352 con el evento "OnRunGenJnlPostLinePurchPost"
                                 apunte al evento OnBeforePostInvPostBuffer de la CU 90, que es mas apropiado. Ahora la funci�n se llama "CU90_OnBeforePostInvPostBuffer", y se elimina la llamada de la CU90
      JAV 30/06/22: - QB 1.10.47 Verificar que la fecha de documento sea inferior o igual a la de registro antes de registrar un documento de compra o de venta
      JAV 04/07/22: - QB 1.10.58 Se elimina la funci�n RunAddFromPurchaseLineToJnlLineCJobTransferLine, su c�digo pasa a CU1004_OnAfterFromPurchaseLineToJnlLine para usar el evento est�ndar
                                 Se renombran las funciones relacionadas con las CU 1004 para que siempre empiecen por CU1004_
                                 Se cambia en CU1004_OnAfterFromJnlLineToLedgEntry la variable Factor que estaba definida como par�metro en lugar de como variable local del proceso
                                 Se elimina la funci�n ConvertPriceToVATCUPurchPriceCalcMgt , no tiene sentido lo que hac�a por lo que se retorna la CU 7010 a la est�ndar
                                 Se refactoriaza la funci�n ItemLineOutputShowWarning para usar otra funci�n diferente de la CU 311 ItemCheckAvail que pasa a est�ndar
                                 Se eliminan las llamadas a funciones ConvertPriceToVAT1CUSalesPriceCalcMgt, ConvertPriceToVAT2CUSalesPriceCalcMgt, ConvertPriceToVAT3CUSalesPriceCalcMgt no tienen sentido
      JAV 05/07/22: - QB 1.10.59 (Q17292) cambiamos el uso de las variables del libro de amortizaci�n al propio activo
                                 Se elimina la funci�n AddFromPurchaseLineToJnlLineCJobTransferLine, su c�digo pasa a la CU 1004 evento OnAfterFromPurchaseLineToJnlLine
                                 Se elimina la funci�n ConvertPriceToVATCUPurchPriceCalcMgt , no tiene sentido lo que hac�a por lo que se retorna la CU 7010 a la est�ndar
                                 Se eliminan las llamadas a funciones ConvertPriceToVAT1CUSalesPriceCalcMgt, ConvertPriceToVAT2CUSalesPriceCalcMgt, ConvertPriceToVAT3CUSalesPriceCalcMgt no tienen sentido
                                 Se elimina la funci�n CopyPurchLineCUCopyDocumentMgt que est� mal y no hace nada necesario
                                 Se guarda el proyecto al copiar las l�neas de documento de venta
                                 Se elimina la funci�n OnCalcNewFieldsItemAvailabilityFormsMgt, en su lugar se usa CU353_OnAfterCalcItemPlanningFields
                                 Se elimina la funci�n OnCalcNeedFieldsItemAvailabilityFormsMgt, en su lugar se usa CU353_OnAfterCalculateNeed
                                 Se pasan las funciones CU1405_OnBeforeChangeDocumentPurchHeader, CU10767_OnBeforeChangeDocumentPurchaseCrMemo, CU10765_OnBeforeChangeDocumentSalesInvoice,
                                                        CU10766_OnBeforeChangeDocumentSalesCrMemo a la CU de Pages por cambiar su forma de manejo
                                 Se cambia la funci�n OnUpdateActivitiesContact, pasa a ser CU5055_OnAfterUpdateVendor y captura el evento de la CU 5055
                                 Se cambia la funci�n RunTryGetPurchJournalLineCUCalcItemAvailability, en su lugar se usa el evento est�ndar OnAfterGetDocumentEntries de la CU 5530
                                 Se cambia la funci�n ItemLineOutputShowWarning que deja de responder a un evento que no se usaba
                                 Se eliminan las funciones que no se usan funSaveDimensionGenJnlPostLine, RunAutoTextResourceTransferExtendedText, TrackingFRISReceiptNoAndReceiptLineNo_PurchasePost_CU90,
                                                                          RunGenJnlPostLine, OnPurchPostCUOnAfterCreateBills, InitDiscount_OnPostItemJnlLineJobConsumption
      JAV 13/07/22: - QB 1.11.00 Se elimina la funci�n CreateDimensionAllocationsGenJnlPostBatch que no es necesaria
      JAV 06/10/22: - QB 1.12.00 Se a�aden los movimientos de las cuentas de activaci�n en la creaci�n de mov. de proyecto
      PSM 24/02/23: - Q19407 Modificar el mensaje de d�as de QuoSII vencidos si se usa Fecha Auto en QuoSII
      CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE.  New function - OnBeforePostGenJnlLine_CU12
      AML 07/07/23: - Q19877 Error en cancelacion de albaranes
      AML 19/09/23 - Q20099 Que la comprobaci�n de importes dependa del flag importe proveedor obligatorioValidatePurchaseAmount
      AML 28/09/23: - Q20073 No permitir Unidad coste almacen en blanco.
      AML 10/10/23: - Q17292 A�adido c�digo perdido
      PSM 10/10/23: - Q17292 A�adido c�digo perdido
      AML 19/10/23: - Q20269 A�adido traspaso de UO. CreateActiveDimGenJnlPostLine
      AML 24/10/23: - Q20364 Abonos.
    }
END.*/
}








Codeunit 7207347 "QB - Table - Subscriber"
{


    Permissions = TableData 349 = rim;
    trigger OnRun()
    BEGIN
    END;

    VAR
        TempUO: Code[20];

    LOCAL PROCEDURE "------------------------------------------------------------------- Location (14)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnLookupDepartamentCode, '', true, true)]
    LOCAL PROCEDURE IsFalseValidateOnLookupDepartamentCode(VAR Location: Record 14);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.LookUpDpto(Location."QB Departament Code", FALSE) THEN
            Location.VALIDATE("QB Departament Code");
    END;

    [EventSubscriber(ObjectType::Table, 14, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnInsertTLocation(VAR Rec: Record 14; RunTrigger: Boolean);
    VAR
        InventoryPostingSetup: Record 5813;
        InventoryPostingSetupDest: Record 5813;
    BEGIN
        IF (NOT RunTrigger) THEN
            EXIT;

        InventoryPostingSetup.SETRANGE("Location Code", '');
        IF InventoryPostingSetup.FINDSET(FALSE) THEN
            REPEAT
                InventoryPostingSetupDest.INIT;
                InventoryPostingSetupDest := InventoryPostingSetup;
                InventoryPostingSetupDest."Location Code" := Rec.Code;
                InventoryPostingSetupDest.INSERT(TRUE);
            UNTIL InventoryPostingSetup.NEXT = 0;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Customer (18)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 18, OnBeforeValidateEvent, "QB JV Dimension Code", true, true)]
    LOCAL PROCEDURE OnValidateJVDimensionCodeTCustomer(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateJV(Rec."QB JV Dimension Code");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnLookupJVDimensionCodeTCustomer, '', true, true)]
    LOCAL PROCEDURE OnLookupJVDimensionCodeTCustomer(Customer: Record 18);
    VAR
        FunctionQB: Codeunit 7207272;
        CJV: Code[20];
    BEGIN
        IF Customer."No." <> '' THEN BEGIN
            IF FunctionQB.LookUpJV(CJV, FALSE) THEN
                Customer.VALIDATE("QB JV Dimension Code", CJV)
        END ELSE BEGIN
            IF FunctionQB.LookUpJV(CJV, FALSE) THEN;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, 'QB Receivable Bank No.', true, true)]
    LOCAL PROCEDURE T18_OnAfterValidateEvent_QBReceivableBankNo(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        QBCodeunitSubscriber: Codeunit 7207353;
        SalesHeader: Record 36;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
    BEGIN
        //JAV 25/11/21: - QB 1.10.01 Si cambia el banco de pago por defecto del cliente, cambiar en todos los documentos pendientes del mismo
        IF (Rec."QB Receivable Bank No." <> '') AND (Rec."QB Receivable Bank No." <> xRec."QB Receivable Bank No.") THEN BEGIN
            IF (CONFIRM('�Desea cambiar el banco en todos los documentos pendientes de pago del cliente?', TRUE)) THEN BEGIN
                //Facturas sin registrar
                SalesHeader.RESET;
                SalesHeader.SETRANGE("Sell-to Customer No.", Rec."No.");
                SalesHeader.MODIFYALL("QB Payment Bank No.", Rec."QB Receivable Bank No.");

                //Facturas registradas
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("Sell-to Customer No.", Rec."No.");
                IF (SalesInvoiceHeader.FINDSET(TRUE)) THEN
                    REPEAT
                        //JAV 31/03/22: - QB 1.10.29 Se a�ade par�metro en la llamada a la funci�n
                        QBCodeunitSubscriber.ChangeCustomerBank(SalesInvoiceHeader."No.", Rec."QB Receivable Bank No.", SalesInvoiceHeader."Payment bank No.", FALSE, TRUE);

                        SalesInvoiceHeader."Payment bank No." := Rec."QB Receivable Bank No.";
                        SalesInvoiceHeader.MODIFY;
                    UNTIL (SalesInvoiceHeader.NEXT = 0);

                //Abonos registradas
                SalesCrMemoHeader.RESET;
                SalesCrMemoHeader.SETRANGE("Sell-to Customer No.", Rec."No.");
                IF (SalesCrMemoHeader.FINDSET(TRUE)) THEN
                    REPEAT
                        //JAV 31/03/22: - QB 1.10.29 Se a�ade par�metro en la llamada a la funci�n
                        QBCodeunitSubscriber.ChangeCustomerBank(SalesCrMemoHeader."No.", Rec."QB Receivable Bank No.", SalesCrMemoHeader."Payment bank No.", FALSE, TRUE);

                        SalesCrMemoHeader."Payment bank No." := Rec."QB Receivable Bank No.";
                        SalesCrMemoHeader.MODIFY;
                    UNTIL (SalesCrMemoHeader.NEXT = 0);
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Customer Ledget Entry (21)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 21, OnAfterCopyCustLedgerEntryFromGenJnlLine, '', true, true)]
    LOCAL PROCEDURE T21_OnAfterCopyCustLedgerEntryFromGenJnlLine(VAR CustLedgerEntry: Record 21; GenJournalLine: Record 81);
    BEGIN
        //JAV 25/11/21: - QB 1.10.01 Poner el banco
        CustLedgerEntry.VALIDATE("QB Receivable Bank No.", GenJournalLine."QB Payment Bank No.");

        //JAV 13/01/22: - QB 1.10.09 Se a�ade el manejo del confirming
        CustLedgerEntry."QB Confirming" := GenJournalLine."QB Confirming";
        CustLedgerEntry."QB Confirming Dealing Type" := GenJournalLine."QB Confirming Dealing Type";
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Vendor (23)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertEvent_TVendor(VAR Rec: Record 23; RunTrigger: Boolean);
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        //PEL 19/03/19: - OBR Marcar Obralia por defecto al crear un proveedor. No se activa de momento, pues no todos lo tendr�n
        //Rec.VALIDATE(Obralia, TRUE);
        //Rec.MODIFY(TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 23, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeDeleteEvent_TVendor(VAR Rec: Record 23; RunTrigger: Boolean);
    VAR
        VendorQualityData: Record 7207418;
        ConditionsVendor: Record 7207420;
        VendorConditionsData: Record 7207414;
        Text001: TextConst ENU = 'The Vendor %1 can not be deleted because it has data in offer comparisons', ESP = 'No puede borrarse el proveedor %1 porque tiene datos en comparativas de oferta';
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        VendorConditionsData.SETRANGE("Vendor No.", Rec."No.");
        IF NOT VendorConditionsData.ISEMPTY THEN
            ERROR(Text001, Rec."No.");
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterDeleteEvent_TVendor(VAR Rec: Record 23; RunTrigger: Boolean);
    VAR
        VendorQualityData: Record 7207418;
        ConditionsVendor: Record 7207420;
        VendorConditionsData: Record 7207414;
        Text001: TextConst ENU = 'The Vendor %1 can not be deleted because it has data in offer comparisons', ESP = 'No puede borrarse el proveedor %1 porque tiene datos en comparativas de oferta';
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        VendorQualityData.SETRANGE("Vendor No.", Rec."No.");
        VendorQualityData.DELETEALL(TRUE);

        ConditionsVendor.SETRANGE("Vendor No.", Rec."No.");
        ConditionsVendor.DELETEALL(TRUE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnLookupJVDimensionCode, '', true, true)]
    LOCAL PROCEDURE RunOnLookupJVDimensionCode(VAR Vendor: Record 23);
    VAR
        FunctionQB: Codeunit 7207272;
        JVDimensionCode: Code[20];
    BEGIN
        IF FunctionQB.LookUpJV(JVDimensionCode, FALSE) THEN
            Vendor.VALIDATE("QB JV Dimension Code", JVDimensionCode);
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "Payment Method Code", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PaymentMethodCode_Vendor(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        MandatoryBankText: TextConst ENU = '%1 must be indicated.', ESP = '%1 debe ser informado.';
        PaymentMethod: Record 289;
    BEGIN
        //QPE6439: Si la forma de pago del proveedor tiene marcado "Banco proveedor obligatorio" y no tiene informado "Cuenta bancaria preferida" salta mensaje.
        CheckVendorBank(Rec);
    END;

    LOCAL PROCEDURE CheckVendorBank(VAR Rec: Record 23);
    VAR
        MandatoryBankText: TextConst ENU = '%1 must be indicated.', ESP = '%1 debe ser informado.';
        PaymentMethod: Record 289;
        VendorBankAccount: Record 288;
        BankAccountText: TextConst ENU = '%1 must be indicated.', ESP = 'No ha indicado cuenta bancaria en el banco del proveedor';
    BEGIN
        //QPE6439: Si la forma de pago del proveedor tiene marcado "Banco proveedor obligatorio" y no tiene informado "Cuenta bancaria preferida" salta mensaje.
        // IF PaymentMethod.GET(Rec."Payment Method Code") THEN
        //     IF PaymentMethod."Mandatory Vendor Bank" THEN
        //         IF (NOT VendorBankAccount.GET(Rec."No.", Rec."Preferred Bank Account Code")) THEN
        //             MESSAGE(MandatoryBankText, Rec.FIELDCAPTION("Preferred Bank Account Code"))
        //         ELSE IF (VendorBankAccount."CCC No." = '') THEN
        //             MESSAGE(BankAccountText);
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, 'QB Payable Bank No.', true, true)]
    LOCAL PROCEDURE T23_OnAfterValidateEvent_QBPayableBankNo(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        QBCodeunitSubscriber: Codeunit 7207353;
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
    BEGIN
        //JAV 25/11/21: - QB 1.10.01 Si cambia el banco de pago por defecto del cliente, cambiar en todos los documentos pendientes del mismo
        IF (Rec."QB Payable Bank No." <> '') AND (Rec."QB Payable Bank No." <> xRec."QB Payable Bank No.") THEN BEGIN
            // EPV 30/03/22: - QB 1.10.29 (BUG) Error al usar funciones de cliente para cambio de banco del proveedor
            //IF (CONFIRM('�Desea cambiar el banco en todos los documentos pendientes de pago del cliente?', TRUE)) THEN BEGIN
            IF (CONFIRM('�Desea cambiar el banco en todos los documentos pendientes de pago del proveedor?', TRUE)) THEN BEGIN
                //--> BUG
                //Facturas sin registrar
                PurchaseHeader.RESET;
                PurchaseHeader.SETRANGE("Buy-from Vendor No.", Rec."No.");
                PurchaseHeader.MODIFYALL("QB Payable Bank No.", Rec."QB Payable Bank No.");

                //Facturas registradas
                PurchInvHeader.RESET;
                PurchInvHeader.SETRANGE("Buy-from Vendor No.", Rec."No.");
                IF (PurchInvHeader.FINDSET(TRUE)) THEN
                    REPEAT
                        // EPV 30/03/22: - QB 1.10.29 (BUG) Error al usar funciones de cliente para cambio de banco del proveedor
                        //QBCodeunitSubscriber.ChangeCustomerBank(PurchInvHeader."No.", Rec."QB Payable Bank No.", PurchInvHeader."QB Payment Bank No.", FALSE);
                        //JAV 31/03/22: - QB 1.10.29 Se a�ade par�metro en la llamada a la funci�n
                        QBCodeunitSubscriber.ChangeVendorBank(PurchInvHeader."No.", Rec."QB Payable Bank No.", PurchInvHeader."QB Payment Bank No.", FALSE, TRUE);
                        //-->> BUG
                        PurchInvHeader."QB Payment Bank No." := Rec."QB Payable Bank No.";
                        PurchInvHeader.MODIFY;
                    UNTIL (PurchInvHeader.NEXT = 0);

                //Abonos registrados
                PurchCrMemoHdr.RESET;
                PurchCrMemoHdr.SETRANGE("Buy-from Vendor No.", Rec."No.");
                IF (PurchCrMemoHdr.FINDSET(TRUE)) THEN
                    REPEAT
                        // EPV 30/03/22: - QB 1.10.29 (BUG) Error al usar funciones de cliente para cambio de banco del proveedor
                        //QBCodeunitSubscriber.ChangeCustomerBank(PurchCrMemoHdr."No.", Rec."QB Payable Bank No.", PurchCrMemoHdr."QB Payment Bank No.", FALSE);
                        //JAV 31/03/22: - QB 1.10.29 Se a�ade par�metro en la llamada a la funci�n
                        QBCodeunitSubscriber.ChangeVendorBank(PurchCrMemoHdr."No.", Rec."QB Payable Bank No.", PurchCrMemoHdr."QB Payment Bank No.", FALSE, TRUE);
                        //--> BUG

                        PurchCrMemoHdr."QB Payment Bank No." := Rec."QB Payable Bank No.";
                        PurchCrMemoHdr.MODIFY;
                    UNTIL (PurchCrMemoHdr.NEXT = 0);
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Vendor Ledger Entry (25)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 25, OnAfterCopyVendLedgerEntryFromGenJnlLine, '', true, true)]
    LOCAL PROCEDURE OnAfterCopyVendLedgerEntryFromGenJnlLine_TVendorLedgerEntry(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    BEGIN
        //JAV 19/03/20: - La funci¢n OnAfterCopyVendLedgerEntryFromGenJnlLine_TVendorLedgerEntry reemplaza al evento y la funci¢n CopyFromGenJnlLineTVendorLedgerEntry pues hay uno est ndar que ya lo hace
        IF VendorLedgerEntry.Amount > 0 THEN
            VendorLedgerEntry."Amount to Apply" := -GenJournalLine."Not Applicable Amount Appl."
        ELSE
            VendorLedgerEntry."Amount to Apply" := GenJournalLine."Not Applicable Amount Appl.";

        //JAV 25/11/21: - QB 1.10.01 Poner el banco
        VendorLedgerEntry.VALIDATE("QB Payable Bank No.", GenJournalLine."QB Payment Bank No.");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Item (27)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 27, OnBeforeValidateEvent, "QB Activity Code", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_ActivityCode_TItem(VAR Rec: Record 27; VAR xRec: Record 27; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        ActivityQB: Record 7207280;
    BEGIN
        // Vamos a llevar a la ficha producto los g.c.p y g.c.e que existan en la t(71026) Actividad-Producto
        IF (FunctionQB.AccessToQuobuilding) THEN BEGIN
            ActivityQB.RESET;
            ActivityQB.SETRANGE(ActivityQB."Activity Code", Rec."QB Activity Code");
            IF ActivityQB.FINDFIRST THEN BEGIN
                IF (ActivityQB."Posting Group Stock" <> '') THEN
                    Rec."Inventory Posting Group" := ActivityQB."Posting Group Stock";
                IF (ActivityQB."Posting Group Product" <> '') THEN
                    Rec."Gen. Prod. Posting Group" := ActivityQB."Posting Group Product";
            END;
        END;
        Rec.VALIDATE("Gen. Prod. Posting Group");
    END;

    PROCEDURE Item_SetDim(VAR Rec: Record 27; CA: Code[20]);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 01/11/21: QB 1.09.26 Establecer las dimensiones globales en un registro de tipo RECURSO
        CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
            1:
                Rec.VALIDATE("Global Dimension 1 Code", CA);
            2:
                Rec.VALIDATE("Global Dimension 2 Code", CA);
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Sales Header (36)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertEvent_TSalesHeader(VAR Rec: Record 36; RunTrigger: Boolean);
    VAR
        Job: Record 167;
        txtFilter: Text;
    BEGIN
        // Si entro en la tabla desde proyecto, heredo de forma autom tica el proyecto desde el que vengo.
        //JAV 11/03/21: - QB 1.08.23 Se mejora para que tome el filtro de proyectos correctamente

        Rec.FILTERGROUP(2);
        txtFilter := Rec.GETFILTER("QB Job No.");
        IF (Rec.HASFILTER AND (STRLEN(txtFilter) <= MAXSTRLEN(Rec."QB Job No."))) THEN
            IF (Job.GET(txtFilter)) THEN
                Rec.VALIDATE("QB Job No.", Job."No.");
        Rec.FILTERGROUP(0);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T36_OnAfterDeleteEvent(VAR Rec: Record 36; RunTrigger: Boolean);
    VAR
        QBPostedServiceOrderHeader: Record 7206968;
        SalesHeaderExt: Record 7207071;
    BEGIN
        //JAV 02/02/22: - QB 1.10.15 Al eliminar el registro se elimina el de extensi�n si existe
        IF SalesHeaderExt.Read(Rec.RECORDID) THEN
            SalesHeaderExt.DELETE;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterInitRecord, '', true, true)]
    LOCAL PROCEDURE OnAfterInitRecord_TSalesHeader(VAR SalesHeader: Record 36);
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del cliente en la descripci¢n del registro
        SalesHeader.VALIDATE("Posting Description");
        SalesHeader.VALIDATE("QB SII Year-Month");
    END;

    // [EventSubscriber(ObjectType::Table, 36, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs_TSalesHeader(VAR SalesHeader: Record 36; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        QBSalesHeaderExt: Record 7238726;
        FunctionQB: Codeunit 7207272;
        i: Integer;
    BEGIN
        //A¤adir la dimensi¢n proyecto en el documento de venta
        FOR i := 1 TO ARRAYLEN(TableID) DO
            IF (TableID[i] = DATABASE::Job) OR (TableID[i] = 0) THEN BEGIN
                TableID[i] := DATABASE::Job;
                No[i] := SalesHeader."QB Job No.";
                BREAK;
            END;

        //JAV 17/11/21: - QB 1.10.00 RE 0.00.00 A¤adir las dimensiones de Real Estate en el documento de venta
        //JAV 19/05/22: - QB 1.10.42 Solo para Real Estate
        IF FunctionQB.AccessToRealEstate THEN BEGIN
            QBSalesHeaderExt.RESET();
            QBSalesHeaderExt.SETRANGE("Record Id", SalesHeader.RECORDID);
            IF NOT QBSalesHeaderExt.FINDFIRST THEN
                QBSalesHeaderExt.INIT;

            FOR i := 1 TO ARRAYLEN(TableID) DO
                IF (TableID[i] = DATABASE::"Proyectos inmobiliarios") OR (TableID[i] = 0) THEN BEGIN
                    TableID[i] := DATABASE::"Proyectos inmobiliarios";
                    No[i] := QBSalesHeaderExt."QB_Classif Code 1";
                    BREAK;
                END;

            FOR i := 1 TO ARRAYLEN(TableID) DO
                IF (TableID[i] = DATABASE::"Clasificación Clasif 2") OR (TableID[i] = 0) THEN BEGIN
                    TableID[i] := DATABASE::"Clasificación Clasif 2";
                    No[i] := QBSalesHeaderExt."Cod Clasif2";
                    BREAK;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeRecreateSalesLines, '', true, true)]
    LOCAL PROCEDURE OnBeforeRecreateSalesLines_TSalesHeader(VAR SalesHeader: Record 36);
    VAR
        SalesLine: Record 37;
    BEGIN
        //JAV 12/05/20: - El sistema valida el proyecto en blanco, debo quitarlo antes del proceso
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER("No.", '<>%1', '');
        IF (SalesLine.FINDSET(TRUE)) THEN
            REPEAT
                SalesLine."QB Temp Dimension Set ID" := SalesLine."Dimension Set ID";
                SalesLine."QB Temp Job No" := SalesLine."Job No.";
                SalesLine."Job No." := '';
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterRecreateSalesLine, '', true, true)]
    LOCAL PROCEDURE OnAfterRecreateSalesLine_TSalesHeader(VAR SalesLine: Record 37; VAR TempSalesLine: Record 37 TEMPORARY);
    BEGIN
        SalesLine."Job No." := TempSalesLine."QB Temp Job No";
        SalesLine.VALIDATE("Dimension Set ID", TempSalesLine."QB Temp Dimension Set ID");
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    LOCAL PROCEDURE "OnAfterValidateEvent_Sell-to Customer No_TSalesHeader"(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        Rec.VALIDATE("Posting Description");
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "Posting Date", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_PostingDate_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        QBCodeunitSubscriber: Codeunit 7207353;
    BEGIN
        //QB-1.05 JAV 13/06/20: Informar ejercicio/periodo
        Rec.VALIDATE("QB SII Year-Month");

        //QCPM_GAP18: Verificar plazo para el SII
        QBCodeunitSubscriber.OnBeforeValidatePostingDate(Rec."Posting Date", Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"], FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Posting Description", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PostingDescription_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        AuxText: Text;
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del cliente en la descripci¢n de registro para la factura de venta
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Purch. Document Regiter Text" <> '') THEN BEGIN
            AuxText := STRSUBSTNO(QuoBuildingSetup."Sales Document Regiter Text", FORMAT(Rec."Document Type"), Rec."External Document No.", Rec."Bill-to Name");
            Rec."Posting Description" := COPYSTR(AuxText, 1, MAXSTRLEN(Rec."Posting Description"));
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "External Document No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_ExternalDocumentNo_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del cliente en la descripci¢n del registro
        Rec.VALIDATE("Posting Description");
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_JobNo_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        Job: Record 167;
    BEGIN
        //JAV 20/06/19: - N£mero de serie de registro por proyecto
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Series for Job") THEN
            IF (Job.GET(Rec."QB Job No.")) THEN BEGIN
                CASE Rec."Document Type" OF
                    Rec."Document Type"::Invoice:
                        IF (Job."Serie Registro Fras Vta." <> '') THEN
                            Rec."Posting No. Series" := Job."Serie Registro Fras Vta.";
                    Rec."Document Type"::"Credit Memo":
                        IF (Job."Serie Registro Abonos Vta." <> '') THEN
                            Rec."Posting No. Series" := Job."Serie Registro Abonos Vta.";
                END;
            END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_JobNo_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        CJob: Code[20];
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        Dict: Dictionary of [Integer, Code[20]];
    BEGIN
        Rec.MessageIfSalesLinesExist(Rec.FIELDCAPTION("QB Job No."));

        // Rec.CreateDim(
        //   DATABASE::Customer,Rec."Bill-to Customer No.",
        //   DATABASE::"Salesperson/Purchaser",Rec."Salesperson Code",
        //   DATABASE::Campaign,Rec."Campaign No.",
        //   DATABASE::"Responsibility Center",Rec."Responsibility Center",
        //   DATABASE::"Customer Template",Rec."Bill-to Customer Template Code");

        Clear(Dict);
        Dict.Add(DATABASE::Customer, Rec."Bill-to Customer No.");
        DefaultDimSource.Add(Dict);
        Clear(Dict);
        Dict.Add(DATABASE::"Salesperson/Purchaser", Rec."Salesperson Code");
        DefaultDimSource.Add(Dict);
        Clear(Dict);
        Dict.Add(DATABASE::Campaign, Rec."Campaign No.");
        DefaultDimSource.Add(Dict);
        Clear(Dict);
        Dict.Add(DATABASE::"Responsibility Center", Rec."Responsibility Center");
        DefaultDimSource.Add(Dict);
        Clear(Dict);
        Dict.Add(DATABASE::"Customer Templ.", Rec."Bill-to Customer Templ. Code");
        DefaultDimSource.Add(Dict);
        Rec.CreateDim(DefaultDimSource);



        Rec.VALIDATE("Location Code", GetWarehouseFromJob(Rec."QB Job No."));

        IF Job.GET(Rec."QB Job No.") THEN
            IF Job."Language Code" <> '' THEN
                Rec.VALIDATE("Language Code", Job."Language Code");
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Bill-to Customer No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_BillToCustomerNo_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        Customer: Record 18;
        Error001: TextConst ENU = 'Bill-to Customer No. should not be empty.', ESP = 'Factura-a N§ cliente no puede estar vac¡o.';
    BEGIN
        //Q3707
        Customer.RESET;
        Customer.SETRANGE("No.", Rec."Bill-to Customer No.");
        IF Customer.FINDFIRST THEN
            Rec."QB Payment Bank No." := Customer."QB Receivable Bank No."
        ELSE
            ERROR(Error001);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_SelltoCustomerNo_TSalesHeader(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        UserSetupManagement: Codeunit 5700;
        Customer: Record 18;
    BEGIN
        IF Rec."QB Job No." = '' THEN
            Rec.VALIDATE("Location Code", UserSetupManagement.GetLocation(0, Customer."Location Code", Rec."Responsibility Center"))
        ELSE
            Rec.VALIDATE("Location Code", GetLocationJobFromSalesHeader(Rec."QB Job No."));
    END;

    LOCAL PROCEDURE GetLocationJobFromSalesHeader(CJob: Code[20]): Code[10];
    VAR
        Job: Record 167;
    BEGIN
        CLEAR(Job);
        IF Job.GET(CJob) THEN
            EXIT(Job."Job Location")
        ELSE
            EXIT('');
    END;

    PROCEDURE ChangeJobNo_TSalesHeader(VAR Rec: Record 36);
    VAR
        Text001: TextConst ENU = 'You can not specify Job on orders against Location', ESP = 'No puede especificar proyecto en pedidos contra almac‚n';
        GeneralLedgerSetup: Record 98;
        TmpDimSetEntry: Record 480 TEMPORARY;
        DefaultDimension: Record 352;
        DimSetEntry: Record 480;
        DimMgt: Codeunit 408;
        newDimSetID: Integer;
    BEGIN
        //Al cambiar el proyecto en la cabecera, actualizar las dimensiones

        //A¤ado las dimensiones del proyecto
        TmpDimSetEntry.DELETEALL;
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", Rec."QB Job No.");
        DefaultDimension.SETFILTER("Dimension Value Code", '<>%1', '');
        IF (DefaultDimension.FINDSET) THEN
            REPEAT
                TmpDimSetEntry.INIT;
                TmpDimSetEntry."Dimension Set ID" := 0;
                TmpDimSetEntry."Dimension Code" := DefaultDimension."Dimension Code";
                TmpDimSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                TmpDimSetEntry.INSERT;
            UNTIL DefaultDimension.NEXT = 0;

        //Copio el resto de dimensiones del documento
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
        IF (DimSetEntry.FINDSET) THEN
            REPEAT
                TmpDimSetEntry := DimSetEntry;
                TmpDimSetEntry."Dimension Set ID" := 0;
                IF NOT TmpDimSetEntry.INSERT THEN;
            UNTIL DimSetEntry.NEXT = 0;

        //Busco el ID y actualizo
        Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TmpDimSetEntry);
        DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
        Rec.MODIFY;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_SellToCustomerNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        T36_SetVATbusPstGrp(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Sell-to Customer Template Code", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_SellToCustomerTemplateCode(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        T36_SetVATbusPstGrp(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Bill-to Customer No.", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_BillToCustomerNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        T36_SetVATbusPstGrp(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "VAT Bus. Posting Group", true, true)]
    LOCAL PROCEDURE T36_OnBeforeValidateEvent_VATBusPostingGroup(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        IF (xRec."Gen. Bus. Posting Group" <> Rec."Gen. Bus. Posting Group") THEN
            T36_SetVATbusPstGrp(Rec);
    END;

    LOCAL PROCEDURE T36_SetVATbusPstGrp(VAR SalesHeader: Record 36): Code[10];
    VAR
        VATBusinessPostingGroup: Record 323;
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"]) THEN
            IF (VATBusinessPostingGroup.GET(SalesHeader."VAT Bus. Posting Group")) THEN
                IF (VATBusinessPostingGroup."VAT Bus.Pst.Grp. in Cr.Memos" <> '') THEN
                    SalesHeader."VAT Bus. Posting Group" := VATBusinessPostingGroup."VAT Bus.Pst.Grp. in Cr.Memos";
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Sales Line (37)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterDeleteEvent_TSalesLine(VAR Rec: Record 37; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        InvoiceMilestone: Record 7207331;
    BEGIN
        // Vamos a controlar que al borrar una l¡nea de factura de venta si corresponde a una l¡nea de hitos de facturaci¢n vencidos
        // y no ha sido registrado (algo obvio) le eliminamos el campo N§ borrador factura, para que siga pdte una vez eliminada la
        // linea de la factura
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            InvoiceMilestone.RESET;
            InvoiceMilestone.SETRANGE(InvoiceMilestone."Job No.", Rec."Job No.");
            InvoiceMilestone.SETRANGE(InvoiceMilestone."Milestone No.", Rec."QB Milestone No.");
            IF InvoiceMilestone.FINDSET(TRUE) THEN
                REPEAT
                    InvoiceMilestone."Draft Invoice No." := '';
                    InvoiceMilestone.MODIFY;
                UNTIL InvoiceMilestone.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnBeforeValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_No_TSalesLine(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN
        // validar el proyecto nuevamente
        IF Rec."Job No." <> '' THEN
            Rec.VALIDATE("Job No.");
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_No_TSalesLine(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        SalesHeader: Record 36;
    BEGIN
        IF (Rec."Job No." = '') AND (FunctionQB.AccessToQuobuilding) THEN BEGIN
            SalesHeader.GET(Rec."Document Type", Rec."Document No.");
            IF NOT (Rec.Type IN [Rec.Type::"Fixed Asset", Rec.Type::"Charge (Item)"]) THEN
                Rec."Job No." := SalesHeader."QB Job No.";
        END;

        // validar el proyecto nuevamente
        IF Rec."Job No." <> '' THEN
            Rec.VALIDATE("Job No.");
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, "Work Type Code", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_WorkTypeCode_TSalesLine(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            GetPriceAssignment(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnBeforeValidateEvent, "Job No.", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_JobNo_TSalesLine(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        WhseValidateSourceLine: Codeunit 5777;
        Text000: TextConst ENU = '"Must not be specified when %1 = %2"', ESP = '"No se debe especificar cuando %1 = %2"';
        DimensionManagement: Codeunit 408;
        DimensionManagement2: codeunit 50361;
        FunctionQB: Codeunit 7207272;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        Dict: Dictionary of [Integer, Code[20]];
    BEGIN
        IF Rec.Type <> Rec.Type::" " THEN BEGIN
            Rec.TestStatusOpen;
            Rec.TESTFIELD("Drop Shipment", FALSE);
            IF (xRec."Job No." <> Rec."Job No.") AND (Rec.Quantity <> 0) THEN BEGIN
                Rec.CALCFIELDS("Reserved Qty. (Base)");
                Rec.TESTFIELD("Reserved Qty. (Base)", 0);
                WhseValidateSourceLine.SalesLineVerifyChange(Rec, xRec);
            END;
            Rec.UpdateUnitPrice(Rec.FIELDNO("Job No."));
            Rec.VALIDATE("Unit Price");
            IF Rec.Type IN [Rec.Type::"Fixed Asset", Rec.Type::"Charge (Item)"] THEN
                IF Rec."Job No." <> '' THEN
                    Rec.FIELDERROR(
                      "Job No.", STRSUBSTNO(Text000, Rec.FIELDCAPTION(Type), Rec.Type));
        END;

        // Rec.CreateDim(
        //   DATABASE::Job, Rec."Job No.",
        //   DimensionManagement2.TypeToTableID3(Rec.Type), Rec."No.",
        //   DATABASE::"Responsibility Center", Rec."Responsibility Center");


        Clear(Dict);
        Dict.Add(DATABASE::Job, Rec."Job No.");
        DefaultDimSource.Add(Dict);
        Clear(Dict);
        Dict.Add(DimensionManagement2.TypeToTableID3(Rec.Type), Rec."No.");
        DefaultDimSource.Add(Dict);
        Clear(Dict);
        Dict.Add(DATABASE::"Responsibility Center", Rec."Responsibility Center");
        DefaultDimSource.Add(Dict);
        Rec.CreateDim(DefaultDimSource);

        // En caso de que haya cesion traigo los coste de cesi¢n
        IF Rec.Type <> Rec.Type::" " THEN BEGIN
            IF FunctionQB.AccessToQuobuilding THEN BEGIN
                GetPriceAssignment(Rec);
                GetLocationJob(Rec);
                // proponemos el CA Vta del GCProy y el Dpto del proyecto
                InsCAGrAccountJob(Rec);
            END;
        END;

        //JAV 05/11/20: - Pasar el proyecto a la cabecera
        //--
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, "Job No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_JobNo_TSalesLine(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        SalesHeader: Record 36;
        UserSetup: Record 91;
        FunctionQB: Codeunit 7207272;
        Text002: TextConst ESP = 'Ha cambiado el proyecto en la l¡nea, ¨desea cambiarlo en la cabecera?';
    BEGIN
        //JAV 05/11/20: - QB 1.07.03 Al cambiar el proyecto en la l�nea de venta llevarlo a la cabecera
        IF (Rec."Job No." <> '') AND (FunctionQB.AccessToQuobuilding) THEN BEGIN
            SalesHeader.GET(Rec."Document Type", Rec."Document No.");

            //Miramos el proyecto de la cabecera, primero guardamos para evitar que entre en bucle
            IF Rec.MODIFY THEN BEGIN
                //Si no tiene proyecto en cabecera, se lo pongo
                IF (SalesHeader."QB Job No." = '') THEN BEGIN
                    SalesHeader."QB Job No." := Rec."Job No.";
                    ChangeJobNo_TSalesHeader(SalesHeader);
                    SalesHeader.MODIFY;
                END;
                //Si el proyecto cambia en la l¡nea, pregunto si cambiarlo en cabecera
                IF (SalesHeader."QB Job No." <> Rec."Job No.") THEN BEGIN
                    IF CONFIRM(Text002, TRUE) THEN BEGIN
                        SalesHeader."QB Job No." := Rec."Job No.";
                        ChangeJobNo_TSalesHeader(SalesHeader);
                        SalesHeader.MODIFY;
                    END;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE GetPriceAssignment(VAR SalesLine: Record 37);
    VAR
        Job: Record 167;
        Resource: Record 156;
        FunctionQB: Codeunit 7207272;
        TransferPriceCost: Record 7207299;
    BEGIN
        IF SalesLine.Type = SalesLine.Type::Resource THEN BEGIN
            IF Job.GET(SalesLine."Job No.") THEN;
            IF Resource.GET(SalesLine."No.") THEN;

            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
                IF Resource."Global Dimension 1 Code" <> Job."Global Dimension 1 Code" THEN
                    IF TransferPriceCost.GET(TransferPriceCost.Type::Resource, Resource."No.", Job."Global Dimension 1 Code", SalesLine."Work Type Code") THEN
                        SalesLine.VALIDATE("Unit Cost (LCY)", TransferPriceCost."Unit Cost");
            END;

            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN BEGIN
                IF Resource."Global Dimension 2 Code" <> Job."Global Dimension 2 Code" THEN
                    IF TransferPriceCost.GET(TransferPriceCost.Type::Resource, Resource."No.", Job."Global Dimension 2 Code", SalesLine."Work Type Code") THEN
                        SalesLine.VALIDATE("Unit Cost (LCY)", TransferPriceCost."Unit Cost");
            END;
        END;
    END;

    LOCAL PROCEDURE GetLocationJob(VAR SalesLine: Record 37);
    VAR
        Job: Record 167;
    BEGIN
        IF Job.GET(SalesLine."Job No.") THEN
            SalesLine.VALIDATE("Location Code", Job."Job Location");
    END;

    LOCAL PROCEDURE InsCAGrAccountJob(VAR SalesLine: Record 37);
    VAR
        Job: Record 167;
        JobPostingGroup: Record 208;
        FunctionQB: Codeunit 7207272;
        DimensionManagement: Codeunit 408;
    BEGIN
        // Proponemos el CA Vta del GCProy varLocal: GCProy
        IF Job.GET(SalesLine."Job No.") THEN BEGIN
            ;
            Job.TESTFIELD(Job."Job Posting Group");
            JobPostingGroup.GET(Job."Job Posting Group");
            SalesLine.VALIDATE("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
            SalesLine.VALIDATE("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, JobPostingGroup."Sales Analytic Concept", SalesLine."Dimension Set ID");
            DimensionManagement.UpdateGlobalDimFromDimSetID(SalesLine."Dimension Set ID", SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Purchase Header (38)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertEvent_TPurchaseHeader(VAR Rec: Record 38; RunTrigger: Boolean);
    VAR
        Job: Record 167;
        txtFilter: Text;
    BEGIN
        //JAV 11/03/21: - QB 1.08.23 Se mejora para que tome el filtro de proyectos correctamente

        Rec.FILTERGROUP(2);
        txtFilter := Rec.GETFILTER("QB Job No.");
        IF (Rec.HASFILTER AND (STRLEN(txtFilter) <= MAXSTRLEN(Rec."QB Job No."))) THEN
            IF (Job.GET(txtFilter)) THEN
                Rec.VALIDATE("QB Job No.", Job."No.");
        Rec.FILTERGROUP(0);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeDeleteEvent_TPurchaseHeader(VAR Rec: Record 38; RunTrigger: Boolean);
    VAR
        ComparativeQuoteHeader: Record 7207412;
        ComparativeQuoteLines: Record 7207413;
        Text007: TextConst ESP = 'El documento no se puede eliminar porque existen l�neas con cantidad recibida.';
        PurchaseLine: Record 39;
        QuoBuildingSetup: Record 7207278;
        ControlContratos: Codeunit 7206907;
    BEGIN
        IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
            EXIT;

        //Busco los comparativos que est�n asociados al documento y les quito el documento generado
        ComparativeQuoteHeader.RESET;
        ComparativeQuoteHeader.SETRANGE("Generated Contract Doc Type", Rec."Document Type");
        ComparativeQuoteHeader.SETRANGE("Generated Contract Doc No.", Rec."No.");
        IF (ComparativeQuoteHeader.FINDSET) THEN
            REPEAT
                ComparativeQuoteHeader.EliminarContrato(FALSE);
            UNTIL (ComparativeQuoteHeader.NEXT = 0);

        //Como no existe ya el documento de compra, hay que dejar en blanco el campo del documento a ampliar de los comparativos para evitar errores
        ComparativeQuoteHeader.RESET;
        ComparativeQuoteHeader.SETRANGE("Main Contract Doc Type", Rec."Document Type");
        ComparativeQuoteHeader.SETRANGE("Main Contract Doc No.", Rec."No.");
        IF (ComparativeQuoteHeader.FINDSET(TRUE)) THEN
            REPEAT
                CLEAR(ComparativeQuoteHeader."Main Contract Doc Type");
                ComparativeQuoteHeader."Main Contract Doc No." := '';
                ComparativeQuoteHeader.MODIFY;
            UNTIL (ComparativeQuoteHeader.NEXT = 0);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterInitRecord, '', true, true)]
    LOCAL PROCEDURE OnAfterInitRecord_TPurchaseHeader(VAR PurchHeader: Record 38);
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del proveedor en la descripci¢n del registro
        PurchHeader.VALIDATE("Posting Description");
        PurchHeader.VALIDATE("QB SII Year-Month");
    END;

    // [EventSubscriber(ObjectType::Table, 38, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs_TPurchaseHeader(VAR PurchaseHeader: Record 38; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        i: Integer;
    BEGIN
        //A¤adir la dimensi¢n proyecto en el documento de compra
        FOR i := 1 TO ARRAYLEN(TableID) DO
            IF (TableID[i] = 0) THEN BEGIN
                TableID[i] := DATABASE::Job;
                No[i] := PurchaseHeader."QB Job No.";
                EXIT;
            END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE "T38_OnAfterValidateEvent_Buy-fromVendorNo"(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Vendor: Record 23;
        QBSIIOperationDescription: Record 7206931;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF (NOT FunctionQB.AccessToQuobuilding) THEN
            EXIT;

        Rec."Location Code" := '';    //JAV 11/05/21: - QB 1.08.42 Quito el almac�n que ha venido del proveedor si estamos en QuoBuilding

        Rec.VALIDATE("Posting Description");

        IF (Vendor.GET(Rec."Buy-from Vendor No.")) THEN BEGIN
            //Calculo del vto
            QuoBuildingSetup.GET();
            IF (Vendor."QB Calc Due Date" = Vendor."QB Calc Due Date"::Standar) THEN
                Rec.VALIDATE("QB Calc Due Date", QuoBuildingSetup."Calc Due Date")
            ELSE
                Rec.VALIDATE("QB Calc Due Date", Vendor."QB Calc Due Date");
            Rec.VALIDATE("QB No. Days Calc Due Date", QuoBuildingSetup."No. Days Calc Due Date");
            Rec.VALIDATE("Payment Terms Code");

            //Descripci�n de la operaci�n para el SII
            IF (Vendor."QB SII Operation Description" <> '') THEN
                Rec.VALIDATE("QB SII Operation Description", Vendor."QB SII Operation Description");

            //JAV 25/11/21: - QB 1.10.01 Poner el banco
            Rec."QB Payable Bank No." := Vendor."QB Payable Bank No.";
        END;

        //Si no tiene Descripci�n de la operaci�n para el SII, mirar si hay una por defecto
        IF (Rec."QB SII Operation Description" = '') THEN BEGIN
            QBSIIOperationDescription.RESET;
            QBSIIOperationDescription.SETRANGE(Default, TRUE);
            IF (QBSIIOperationDescription.FINDFIRST) THEN
                Rec.VALIDATE("QB SII Operation Description", QBSIIOperationDescription.Code);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "QB Order To", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_OrderTo_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PurchaseLine: Record 39;
        Location: Record 14;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not specify location in orders against job', ESP = 'No puede especificar almac�n en pedidos contra proyecto en la l¡nea %1';
        Text002: TextConst ENU = 'You can not specify a location with delivery costs on orders against location', ESP = 'No puede especificar un Almac�n de Obra en pedidos contra almac�n en la l¡nea %1';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF Rec."QB Order To" <> xRec."QB Order To" THEN BEGIN
                IF ((Rec."QB Order To" = Rec."QB Order To"::Location) AND (Rec."QB Job No." <> '')) THEN
                    Rec."QB Job No." := '';
                IF ((Rec."QB Order To" = Rec."QB Order To"::Job) AND (Rec."Location Code" <> '')) THEN
                    Rec."Location Code" := '';

                //Verificar las l¡neas
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                PurchaseLine.SETRANGE("Document No.", Rec."No.");
                PurchaseLine.SETFILTER("No.", '<>%1', '');
                IF PurchaseLine.FINDSET(FALSE) THEN
                    REPEAT
                        IF (Rec."QB Order To" = Rec."QB Order To"::Job) AND (PurchaseLine."Location Code" <> '') THEN
                            ERROR(Text001, PurchaseLine."Line No.");
                        IF (Location.GET(PurchaseLine."Location Code")) THEN
                            IF (Rec."QB Order To" = Rec."QB Order To"::Location) AND (Location."QB Job Location") THEN
                                ERROR(Text002, PurchaseLine."Line No.");
                    UNTIL PurchaseLine.NEXT = 0;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Location Code", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_LocationCode_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not specify location in orders against job', ESP = 'No puede especificar almac�n en pedidos contra proyecto';
        Text002: TextConst ENU = 'You can not specify a location with delivery costs on orders against location', ESP = 'No puede especificar un Almac�n de Obra en pedidos contra almac�n';
        Location: Record 14;
    BEGIN
        //JAV 24/04/20: - Si viene de un contrato, er  contra proyecto y eliminamos el almac�n
        IF (Rec."QB Contract") THEN BEGIN
            Rec."QB Order To" := Rec."QB Order To"::Job;
            Rec."Location Code" := '';
        END ELSE IF Location.GET(Rec."Location Code") THEN BEGIN
            IF FunctionQB.AccessToQuobuilding THEN BEGIN
                IF Rec."QB Order To" = Rec."QB Order To"::Job THEN
                    ERROR(Text001);
                IF (Rec."QB Order To" = Rec."QB Order To"::Location) AND (Location."QB Job Location") THEN
                    ERROR(Text002);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Posting Description", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PostingDescription_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        AuxText: Text;
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del proveedor en la descripci¢n del registro
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Purch. Document Regiter Text" <> '') THEN BEGIN
            AuxText := STRSUBSTNO(QuoBuildingSetup."Purch. Document Regiter Text", FORMAT(Rec."Document Type"), '', Rec."Buy-from Vendor Name");

            IF (Rec."Vendor Invoice No." <> '') THEN
                AuxText := STRSUBSTNO(QuoBuildingSetup."Purch. Document Regiter Text", FORMAT(Rec."Document Type"), Rec."Vendor Invoice No.", Rec."Buy-from Vendor Name");
            IF (Rec."Vendor Cr. Memo No." <> '') THEN
                AuxText := STRSUBSTNO(QuoBuildingSetup."Purch. Document Regiter Text", FORMAT(Rec."Document Type"), Rec."Vendor Cr. Memo No.", Rec."Buy-from Vendor Name");

            Rec."Posting Description" := COPYSTR(AuxText, 1, MAXSTRLEN(Rec."Posting Description"));
        END;
        //JAV fin
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Vendor Invoice No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_VendorInvoiceNo_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del proveedor en la descripci¢n del registro
        Rec.VALIDATE("Posting Description");
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Vendor Cr. Memo No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_VendorCrMemoNo_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 03/07/19: - Poner doc externo y nombre del proveedor en la descripci¢n del registro
        Rec.VALIDATE("Posting Description");
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Posting Date", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PostingDate_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        QBCodeunitSubscriber: Codeunit 7207353;
    BEGIN
        //QB-1.05 JAV 13/06/20: Informar ejercicio/periodo
        Rec.VALIDATE("QB SII Year-Month");

        //QCPM_GAP18: Verificar plazo para el SII
        QBCodeunitSubscriber.OnBeforeValidatePostingDate(Rec."Posting Date", Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"], FALSE);

        //Si cambia la fecha de registro, no cambiar siempre la del documento
        IF (xRec."Posting Date" <> xRec."Document Date") AND (xRec."Document Date" <> 0D) THEN
            Rec."Document Date" := xRec."Document Date";
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "Document Date", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_DocumentDate_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Err001: TextConst ESP = 'La fecha de emisi¢n del documento no puede ser superior a la de registro';
    BEGIN
        //JAV 04/07/19: - La fecha del documento no puede ser nunca mayor a la de registro
        //JAV 04/02/20: - Si no hay fecha de registro, no dar el error de fecha del documento
        IF (Rec."Posting Date" <> 0D) AND (Rec."Document Date" > Rec."Posting Date") THEN
            ERROR(Err001);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "Due Date", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_DueDate_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PaymentTerms: Record 3;
        NewDate: Date;
    BEGIN
        //JAV 20/03/20: - Me guardo la fecha del documento y la cambio por la fecha base de c lculo del vto, ya que el validate del campo mira esa fecha
        Rec."QB Temp Document Date" := Rec."Document Date";

        //Si ha cambiado la fecha base de c�lculo sobre la anterior, me la guardo y recalculo otras fechas a partir de esta
        NewDate := DateBaseForDueDate(Rec);
        IF (Rec."QB Due Date Base" <> NewDate) THEN
            Rec.VALIDATE("QB Due Date Base", NewDate);

        //Pongo como fecha del documento la base del c�lculo, as� lo hace autom�ticamente
        Rec."Document Date" := Rec."QB Due Date Base"
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Due Date", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_DueDate_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PaymentTerms: Record 3;
    BEGIN
        //JAV 20/03/20: - Restauro la fecha del documento tras la validaci¢n
        Rec."Document Date" := Rec."QB Temp Document Date";
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "Prepayment Due Date", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_PrepaymentDueDate_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PaymentTerms: Record 3;
    BEGIN
        //JAV 20/03/20: - Me guardo la fecha del documento y la cambio por la fecha base de c lculo del vto, ya que el validate del campo mira esa fecha
        Rec."QB Temp Document Date" := Rec."Document Date";
        Rec."Document Date" := DateBaseForDueDate(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Prepayment Due Date", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PrepaymentDueDate_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PaymentTerms: Record 3;
    BEGIN
        //JAV 20/03/20: - Restauro la fecha del documento tras la validaci¢n
        Rec."Document Date" := Rec."QB Temp Document Date";
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Payment Terms Code", true, true)]
    LOCAL PROCEDURE "OnAfterValidateEvent_Payment Terms Code_TPurchaseHeader"(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PaymentTerms: Record 3;
        AdjustDueDate: Codeunit 10700;
    BEGIN
        //JAV 20/03/20: - Si cambiamos la fecha base de c lculo de vencimiento
        IF (NeedChangeDateBaseForDueDate) THEN BEGIN
            Rec.VALIDATE("Due Date", DateBaseForDueDate(Rec));
            IF PaymentTerms.GET(Rec."Payment Terms Code") THEN BEGIN
                IF (NOT Rec.IsCreditDocType) OR PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                    Rec."Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", DateBaseForDueDate(Rec));
                    AdjustDueDate.PurchAdjustDueDate(
                      Rec."Due Date", DateBaseForDueDate(Rec), PaymentTerms.CalculateMaxDueDate(DateBaseForDueDate(Rec)), Rec."Pay-to Vendor No.");
                    Rec."Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", DateBaseForDueDate(Rec));
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Prepmt. Payment Terms Code", true, true)]
    LOCAL PROCEDURE "OnAfterValidateEvent_PrepmtPayment Terms Code_TPurchaseHeader"(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        PaymentTerms: Record 3;
        AdjustDueDate: Codeunit 10700;
    BEGIN
        //JAV 20/03/20: - Si cambiamos la fecha base de c lculo de vencimiento
        IF (NeedChangeDateBaseForDueDate) THEN BEGIN
            Rec.VALIDATE("Prepayment Due Date", DateBaseForDueDate(Rec));
            IF PaymentTerms.GET(Rec."Payment Terms Code") THEN BEGIN
                IF (NOT Rec.IsCreditDocType) OR PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                    Rec."Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", DateBaseForDueDate(Rec));
                    AdjustDueDate.PurchAdjustDueDate(
                      Rec."Prepayment Due Date", DateBaseForDueDate(Rec), PaymentTerms.CalculateMaxDueDate(DateBaseForDueDate(Rec)), Rec."Pay-to Vendor No.");
                    Rec."Prepmt. Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", DateBaseForDueDate(Rec));
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Payment Method Code", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PaymentMethodCode_TPurchaseHeader(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Vendor: Record 23;
        PaymentMethod: Record 289;
        MandatoryBankText: TextConst ENU = '%1 must be indicated.', ESP = '%1 debe ser informado.';
    BEGIN
        //QPE6439: En factura compras, si la forma de pago tiene marcado "Banco proveedor obligatorio" y no tiene informado "Cuenta bancaria preferida" salta mensaje.
        IF (Rec."Document Type" <> Rec."Document Type"::Invoice) THEN
            EXIT;

        IF Vendor.GET(Rec."Buy-from Vendor No.") THEN
            CheckVendorBank(Vendor);
    END;

    LOCAL PROCEDURE NeedChangeDateBaseForDueDate(): Boolean;
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 04/02/20: - Si podemos usar otra fecha que no sea la estandar como base para el c lculo del vencimiento del documento de compra
        EXIT(FunctionQB.AccessToChangeBaseVtos);
    END;

    LOCAL PROCEDURE DateBaseForDueDate(PurchaseHeader: Record 38): Date;
    VAR
        QuoBuildingSetup: Record 7207278;
        Fecha: Date;
    BEGIN
        //JAV 04/02/20: - Retorna la fecha que se usa como base para el c lculo del vencimiento del documento de compra
        CASE PurchaseHeader."QB Calc Due Date" OF
            PurchaseHeader."QB Calc Due Date"::Standar, PurchaseHeader."QB Calc Due Date"::Document:
                Fecha := PurchaseHeader."Document Date";
            PurchaseHeader."QB Calc Due Date"::Reception:
                IF (PurchaseHeader."QB Receipt Date" <> 0D) THEN
                    Fecha := PurchaseHeader."QB Receipt Date" + PurchaseHeader."QB No. Days Calc Due Date"
                ELSE
                    Fecha := PurchaseHeader."Document Date";
            PurchaseHeader."QB Calc Due Date"::Approval:
                IF (PurchaseHeader."OLD_QBApproval Date" <> 0D) THEN
                    Fecha := PurchaseHeader."OLD_QBApproval Date"
                ELSE
                    Fecha := PurchaseHeader."Document Date";
        END;
        IF (Fecha = 0D) THEN
            Fecha := PurchaseHeader."Document Date";
        IF (Fecha = 0D) THEN
            Fecha := TODAY;
        EXIT(Fecha);
    END;

    PROCEDURE ChangeJobNo_TPurchaseHeader(VAR Rec: Record 38);
    VAR
        Text001: TextConst ENU = 'You can not specify Job on orders against Location', ESP = 'No puede especificar proyecto en pedidos contra almac‚n';
        GeneralLedgerSetup: Record 98;
        TmpDimSetEntry: Record 480 TEMPORARY;
        DefaultDimension: Record 352;
        DimSetEntry: Record 480;
        DimMgt: Codeunit 408;
        newDimSetID: Integer;
    BEGIN
        //Al cambiar el proyecto en la cabecera, actualizar las dimensiones

        //A¤ado las dimensiones del proyecto
        TmpDimSetEntry.DELETEALL;
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", Rec."QB Job No.");
        DefaultDimension.SETFILTER("Dimension Value Code", '<>%1', '');
        IF (DefaultDimension.FINDSET) THEN
            REPEAT
                TmpDimSetEntry.INIT;
                TmpDimSetEntry."Dimension Set ID" := 0;
                TmpDimSetEntry."Dimension Code" := DefaultDimension."Dimension Code";
                TmpDimSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                TmpDimSetEntry.INSERT;
            UNTIL DefaultDimension.NEXT = 0;

        //Copio el resto de dimensiones del documento
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
        IF (DimSetEntry.FINDSET) THEN
            REPEAT
                TmpDimSetEntry := DimSetEntry;
                TmpDimSetEntry."Dimension Set ID" := 0;
                IF NOT TmpDimSetEntry.INSERT THEN;
            UNTIL DimSetEntry.NEXT = 0;

        //Busco el ID y actualizo
        Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TmpDimSetEntry);
        DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
        Rec.MODIFY;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_BuyFromVendorNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        T38_SetVATbusPstGrp(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Pay-to Vendor No.", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_PayToVendorNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        T38_SetVATbusPstGrp(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "VAT Bus. Posting Group", true, true)]
    LOCAL PROCEDURE T38_OnBeforeValidateEvent_VATBusPostingGroup(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los abonos
        IF (xRec."VAT Bus. Posting Group" <> Rec."VAT Bus. Posting Group") THEN
            T38_SetVATbusPstGrp(Rec);
    END;

    LOCAL PROCEDURE T38_SetVATbusPstGrp(VAR PurchaseHeader: Record 38);
    VAR
        VATBusinessPostingGroup: Record 323;
    BEGIN
        //JAV 28/10/21: - DynPlus Cambiamos el grupo registro de IVA para los documentos de tipo abonos
        IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::"Credit Memo", PurchaseHeader."Document Type"::"Return Order"]) THEN
            IF (VATBusinessPostingGroup.GET(PurchaseHeader."VAT Bus. Posting Group")) THEN
                IF (VATBusinessPostingGroup."VAT Bus.Pst.Grp. in Cr.Memos" <> '') THEN
                    PurchaseHeader."VAT Bus. Posting Group" := VATBusinessPostingGroup."VAT Bus.Pst.Grp. in Cr.Memos";
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Purchase Line (39)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeInsertEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    BEGIN
        IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
            EXIT;

        //GEN005-02
        Rec.VALIDATE("QB Outstanding Amount (JC)");
        Rec.VALIDATE("QB Outstanding Amount (ACY)");

        //iF (Rec."Job No." <> '') THEN
        //  Rec.VALIDATE("Job No.");
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeModifyEvent(VAR Rec: Record 39; VAR xRec: Record 39; RunTrigger: Boolean);
    BEGIN
        IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
            EXIT;

        //GEN005-02
        Rec.VALIDATE("QB Outstanding Amount (JC)");
        Rec.VALIDATE("QB Outstanding Amount (ACY)");

        // IF (Rec."Job No." <> '') THEN
        //  Rec.VALIDATE("Job No.");

        //JAV 07/11/22: - QB 1.12.13 Control de lineas divididas, solo puede modificarse la �ltima divisi�n
        IF (Rec."QB Splitted Line Date" <> 0D) THEN
            ERROR('No puede modificar una l�nea dividida');
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeDeleteEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        Text001: TextConst ENU = 'You cannot delete a line that comes from a contract', ESP = 'No puede eliminar una l�nea que proviene de un comparativo';
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        WithholdingTreating: Codeunit 7207306;
        ActStatus: Enum "Purchase Document Status";
    BEGIN
        IF (NOT RunTrigger) OR (Rec.ISTEMPORARY) THEN
            EXIT;

        //JAV 08/02/21: - QB 1.08.08 Si la l�nea proviene de un contrato, no dejamos eliminarla
        Rec.CALCFIELDS("QB Contract Qty. Original");
        IF (Rec."QB Contract Qty. Original" <> 0) THEN
            ERROR(Text001);

        //JAV 07/11/22: - QB 1.12.13 Control de lineas divididas, solo se borra la �ltima divisi�n
        IF (Rec."QB Splitted Line Date" <> 0D) THEN
            ERROR('No puede eliminar una l�nea dividida');

        IF (Rec."QB Splitted Line Base" <> 0) THEN BEGIN          //Esta es la l�nea que se cre� al dividir, hay que reponer la l�nea original
                                                                  //Abrimos la cabecera para poder modificar sin problemas
            PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
            ActStatus := PurchaseHeader.Status;
            PurchaseHeader.Status := PurchaseHeader.Status::Open;
            PurchaseHeader.MODIFY(FALSE);

            //Aumentamos la cantidad de la l�nea y quitamos que est� dividida
            PurchaseLine.GET(Rec."Document Type", Rec."Document No.", Rec."QB Splitted Line Base");
            PurchaseLine.VALIDATE(Quantity, PurchaseLine.Quantity + Rec.Quantity);
            PurchaseLine."QB Splitted Line Date" := TODAY;
            PurchaseLine.MODIFY(TRUE);

            //Reponer el estado de la cabecera
            PurchaseHeader.Status := ActStatus; //option to enum
            PurchaseHeader.MODIFY(FALSE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Shortcut Dimension 1 Code", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_Dim1(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        InventoryPostingSetup: Record 5813;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 22/06/21: - QB 1.09.19 Si la UO es la de almac�n, usaremos el CA del almac�n en la dimensi�n C.A.
        IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1) THEN BEGIN
            IF (Rec.Type = Rec.Type::Item) AND (FunctionQB.AccessToQuobuilding) THEN
                IF Job.GET(Rec."Job No.") THEN
                    IF (Job."Warehouse Cost Unit" <> '') AND (Rec."Piecework No." = Job."Warehouse Cost Unit") THEN //JAV 18/11/21: - QB 1.09.28 No si no est� establecido el almac�n en la obra
                        IF (Item.GET(Rec."No.")) THEN BEGIN
                            InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group");
                            IF (Rec."Shortcut Dimension 1 Code" <> InventoryPostingSetup."Analytic Concept") THEN
                                ERROR('No pude cambiar el C.A. en las entradas de almac�n');
                        END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Shortcut Dimension 2 Code", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_Dim2(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        InventoryPostingSetup: Record 5813;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 22/06/21: - QB 1.09.19 Si la UO es la de almac�n, usaremos el CA del almac�n en la dimensi�n C.A.
        IF (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2) THEN BEGIN
            IF (Rec.Type = Rec.Type::Item) AND (FunctionQB.AccessToQuobuilding) THEN
                IF Job.GET(Rec."Job No.") THEN
                    IF (Job."Warehouse Cost Unit" <> '') AND (Rec."Piecework No." = Job."Warehouse Cost Unit") THEN //JAV 18/11/21: - QB 1.09.28 No si no est� establecido el almac�n en la obra
                        IF (Item.GET(Rec."No.")) THEN BEGIN
                            InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group");
                            IF (Rec."Shortcut Dimension 2 Code" <> InventoryPostingSetup."Analytic Concept") THEN
                                ERROR('No pude cambiar el C.A. en las entradas de almac�n');
                        END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Dimension Set ID", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_DimSetID(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 22/06/21: - QB 1.09.19 Si la UO es la de almac�n, usaremos el CA del almac�n en la dimensi�n C.A.
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            Rec.VALIDATE("Shortcut Dimension 1 Code")
        ELSE
            Rec.VALIDATE("Shortcut Dimension 2 Code")
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "QB Outstanding Amount (JC)", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_JobCurrencyAmount(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
        PurchaseHeader: Record 38;
        Job: Record 167;
    BEGIN
        //GEN005-02
        //JAV 20/10/20: - QB 1.06.21 Se cambia el uso del proyecto de la cabecera por el de la l�nea
        Rec."QB Outstanding Amount (JC)" := 0;
        Rec."QB Job Curr. Exch. Rate" := 0;

        IF Job.GET(Rec."Job No.") THEN BEGIN
            PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."Outstanding Amount", PurchaseHeader."Currency Code", Job."Currency Code",
                                                               PurchaseHeader."Posting Date", 0, AssignedAmount, CurrencyFactor);
            Rec."QB Outstanding Amount (JC)" := AssignedAmount;
            Rec."QB Job Curr. Exch. Rate" := CurrencyFactor;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "QB Outstanding Amount (ACY)", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_AditionalCurrencyAmount(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
        PurchaseHeader: Record 38;
        Job: Record 167;
    BEGIN
        //GEN005-02
        Rec."QB Outstanding Amount (ACY)" := 0;
        Rec."QB Aditional Curr. Exch. Rate" := 0;

        IF Job.GET(PurchaseHeader."QB Job No.") THEN BEGIN
            PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
            JobCurrencyExchangeFunction.CalculateCurrencyValue(PurchaseHeader."QB Job No.", Rec."Outstanding Amount", PurchaseHeader."Currency Code", Job."Aditional Currency",
                                                               PurchaseHeader."Posting Date", 0, AssignedAmount, CurrencyFactor);
            Rec."QB Outstanding Amount (ACY)" := AssignedAmount;
            Rec."QB Aditional Curr. Exch. Rate" := CurrencyFactor;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "Direct Unit Cost", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_DirectUnitCost(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        PurchRcptHeader: Record 120;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not change the cost price with respect to the one you had in the contract', ESP = '"No se puede modificar el precio de coste con respecto al que tenia en el contrato "';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec.FIELDNO("Direct Unit Cost") <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
                EXIT;
            IF Rec."Document Type" <> Rec."Document Type"::Invoice THEN
                EXIT;

            QuoBuildingSetup.GET;
            IF NOT QuoBuildingSetup."Mant. Contract Prices In Fact." THEN
                EXIT;
            IF PurchRcptHeader.GET(Rec."Receipt No.") THEN
                IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchRcptHeader."Order No.") THEN
                    IF PurchaseHeader.Status <> PurchaseHeader.Status::Open THEN
                        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchRcptHeader."Order No.", Rec."Receipt Line No.") THEN
                            IF Rec."Direct Unit Cost" <> PurchaseLine."Direct Unit Cost" THEN
                                ERROR(Text001);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Direct Unit Cost", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_DirectUnitCost(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        PurchRcptHeader: Record 120;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not change the cost price with respect to the one you had in the contract', ESP = '"No se puede modificar el precio de coste con respecto al que tenia en el contrato "';
    BEGIN
        //JAV 07/11/22: - QB 1.12.13 Controlar que no se cambien precios de l�neas con cantidades recibidas
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec.FIELDNO("Direct Unit Cost") <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
                EXIT;

            //Solo para pedidos de compra
            IF (Rec."Document Type" = Rec."Document Type"::Order) THEN BEGIN
                IF (Rec."Direct Unit Cost" <> xRec."Direct Unit Cost") AND (Rec."Quantity Received" <> 0) THEN BEGIN
                    IF CONFIRM('No puede cambiar el precio de l�neas con cantidad recibida, �Desea dividir la l�nea?', FALSE) THEN BEGIN
                        T39_SplitLine(Rec, Rec."Direct Unit Cost", xRec."Direct Unit Cost");
                        Rec.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.");  //Volver a leer la l�nea que ha cambiado
                        xRec."Line Amount" := Rec."Line Amount";
                        xRec := Rec;
                        xRec."Line Amount" := Rec."Line Amount";

                        Rec.MODIFY(FALSE);
                    END ELSE
                        ERROR('');
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Appl.-to Item Entry", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_AppltoItemEntry(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF (Rec.Type = Rec.Type::Item) AND (Rec."Job No." = '') THEN
                ProposedDepartmentFromLocation(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "Job No.", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_JobNo(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        UserSetup: Record 91;
        SubcontractingControl: Record 7207300;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ESP = 'No tiene pemisos para el acceso al proyecto %1';
    BEGIN
        IF (Rec."Job No." <> '') THEN BEGIN
            //Mirar que el proyecto est� asignado al usuario
            IF NOT FunctionQB.CanUserAccessJob(Rec."Job No.") THEN
                ERROR(Text001, Rec."Job No.");
        END;

        //Guardamos el tipo de l¡nea, si es recurso lo cambiamos por cuenta por una validaci�n del est�ndar
        //JAV 28/04/22: - QB 1.10.37 Se a�ade tambi�n tipo en blanco
        Rec."QB Temp Type" := Rec.Type.AsInteger();
        IF (Rec.Type IN [Rec.Type::Resource, Rec.Type::" "]) THEN
            Rec.Type := Rec.Type::"G/L Account";
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Job No.", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_JobNo(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        UserSetup: Record 91;
        SubcontractingControl: Record 7207300;
        DataPieceworkForProduction: Record 7207386;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not specify job on orders against location', ESP = 'No puede especificar proyecto en pedidos contra almac�n';
        Text002: TextConst ESP = 'Ha cambiado el proyecto en la l¡nea, ¨desea cambiarlo en la cabecera?';
    BEGIN
        //Recupero el tipo de l¡nea
        Rec.Type := Enum::"Purchase Line Type".FromInteger(Rec."QB Temp Type");

        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            //Actualizamos la dimensi�n
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, Rec."Job No.", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");
            IF (Rec."Job No." <> '') THEN BEGIN
                PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");

                ProposeAnalyticalConciliation(Rec);
                IF SubcontractingControl.READPERMISSION THEN
                    ProposeCAResource(Rec);
                IF (Rec.Type = Rec.Type::Item) AND (Rec."Job No." = '') THEN
                    ProposedDepartmentFromLocation(Rec);
                JobLines(Rec);
                IF PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Location THEN
                    ERROR(Text001);

                //JAV 17/06/22: - QB 1.10.50 Si el pedido es contra almac�n no hay que indicar proyecto en cabecera
                IF PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Job THEN BEGIN
                    //Miramos el proyecto de la cabecera, si no lo tiene y si en la l�nea lo actualizo en cabecera. Primero guardamos para evitar que entre en bucle
                    IF Rec.MODIFY THEN BEGIN
                        //Si no tiene proyecto en cabecera, se lo pongo
                        IF (PurchaseHeader."QB Job No." = '') THEN BEGIN
                            PurchaseHeader."QB Job No." := Rec."Job No.";
                            ChangeJobNo_TPurchaseHeader(PurchaseHeader);
                            PurchaseHeader.MODIFY;
                        END;
                        //JAV 05/05/22: - QB 1.10.40 No se pregunta cambiar proyecto en cabecera si cambia en l�neas
                        /*{-----------------------------------------------------------------------------------
                                      //Si el proyecto cambia en la l¡nea, pregunto si cambiarlo en cabecera
                                      IF (PurchaseHeader."QB Job No." <> Rec."Job No.") THEN BEGIN
                                        //JAV 28/04/22 Solo si el proyecto es de Presupuesto o Real Estate se pide cambiarlo en cabecera
                                        IF (NOT FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
                                          IF CONFIRM(Text002, TRUE) THEN BEGIN
                                            PurchaseHeader."QB Job No." := Rec."Job No.";
                                            ChangeJobNo_TPurchaseHeader(PurchaseHeader);
                                            PurchaseHeader.MODIFY;
                                          END;
                                        END;
                                      END;
                                      -----------------------------------------------------------------------------------}*/
                    END;
                END;
            END;

            //JAV 28/04/22: - QB 1.10.37 Por si ha cambiado el proyecto, miro si la unidad de obra existe y lanzo su validaci�n
            //JAV 16/06/22: - QB 1.10.50 Si no hay proyecto en la l�nea de compra se elimina la U.O. de la l�nea
            IF (Rec."Job No." = '') THEN
                Rec."Piecework No." := ''
            ELSE IF (Rec."Piecework No." <> '') THEN BEGIN
                IF (NOT DataPieceworkForProduction.GET(Rec."Job No.", Rec."Piecework No.")) THEN
                    Rec."Piecework No." := ''
                ELSE
                    Rec.VALIDATE("Piecework No.");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "Piecework No.", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_PieceworkNo(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        DataPieceworkForProduction: Record 7207386;
        PurchaseHeader: Record 38;
        Job: Record 167;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
        DimensionManagement: Codeunit 408;
        PieceworkNo: Code[20];
        Text001: TextConst ESP = 'No ha seleccionado un proyecto';
        Text002: TextConst ENU = 'You can only buy products against warehouse', ESP = '"Solo puede comprar productos contra almac�n "';
        Text003: TextConst ENU = 'Product does not exist', ESP = 'No existe el producto';
        Text004: TextConst ENU = 'You can only buy inventory-type products against the warehouse', ESP = 'Solo puede comprar contra almac�n productos de tipo inventario';
    BEGIN
        IF Rec."Piecework No." <> '' THEN BEGIN
            PieceworkNo := Rec."Piecework No.";
            PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
            IF DataPieceworkForProduction.GET(PurchaseHeader."QB Job No.", Rec."Piecework No.") THEN BEGIN
                //JAV 02/06/22: - QB 1.10.47 Se soluciona un problema por el que al cambiar el recurso asociado entraba en un bucle cont�nuo, ahora solo lo cambia una vez.
                IF (DataPieceworkForProduction."No. Subcontracting Resource" <> '') AND (Rec."No." <> DataPieceworkForProduction."No. Subcontracting Resource") THEN BEGIN
                    Rec.VALIDATE(Type, Rec.Type::Resource);
                    Rec.VALIDATE("No.", DataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.VALIDATE("Unit of Measure Code", DataPieceworkForProduction."Unit Of Measure");
                    //JAV 02/06/22: - QB 1.10.47 Se cambia la funci�n de dimensiones a la nueva en un solo paso
                    //FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,DataPieceworkForProduction."Analytical Concept Subcon Code",Rec."Dimension Set ID");
                    //DimensionManagement.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID",Rec."Shortcut Dimension 1 Code",Rec."Shortcut Dimension 2 Code");
                    FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, DataPieceworkForProduction."Analytical Concept Subcon Code",
                                                         Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");
                END;
            END;
            Rec."Piecework No." := PieceworkNo;

            //JAV 30/04/20: - No permitir usar almac�n mas que con productos de inventario
            IF NOT Job.GET(Rec."Job No.") THEN
                ERROR(Text001);
            IF (Rec."Piecework No." = Job."Warehouse Cost Unit") THEN BEGIN
                IF (Rec.Type <> Rec.Type::Item) THEN
                    ERROR(Text002);
                IF NOT Item.GET(Rec."No.") THEN
                    ERROR(Text003);
                IF (Item.Type <> Item.Type::Inventory) THEN
                    ERROR(Text004);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        UserSetup: Record 91;
        SubcontractingControl: Record 7207300;
        DataPieceworkForProduction: Record 7207386;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not specify job on orders against location', ESP = 'No puede especificar proyecto en pedidos contra almac�n';
        Text002: TextConst ESP = 'Ha cambiado el proyecto en la l¡nea, ¨desea cambiarlo en la cabecera?';
        Value: Code[20];
    BEGIN
        //JAV 30/05/22: - QB 1.10.45 Revisar dimensiones tras validar el No.
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            //La del proyecto siempre es esta
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, Rec."Job No.", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");
            //La CA solo si no se ha estblaecido desde el Revisar el CA si no se ha establecido desde el producto/recurso/cuenta
            Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, Rec."Dimension Set ID");
            IF (Value = '') THEN
                FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, Rec."QB CA Value", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "QB Qty. to Receive Origin", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_QtyToReceiveOrigin(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        Rec.VALIDATE("Qty. to Receive", Rec."QB Qty. to Receive Origin" - Rec."Quantity Received");
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "Location Code", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_LocationCode(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        Location: Record 14;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not specify location in orders against job', ESP = 'No puede especificar almac�n en pedidos contra proyecto';
        Text002: TextConst ENU = 'You can not specify a location with delivery costs on orders against location', ESP = 'No puede especificar un Almac�n de Obra en pedidos contra almac�n';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF Location.GET(Rec."Location Code") THEN BEGIN
                PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
                IF PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Job THEN
                    ERROR(Text001);
                IF (PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Location) AND (Location."QB Job Location") THEN
                    ERROR(Text002);
                IF (Rec.Type = Rec.Type::Item) AND (Rec."Job No." = '') THEN
                    ProposedDepartmentFromLocation(Rec);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, Quantity, true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_Quantity(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        ComparativeQuoteHeader: Record 7207412;
        ComparativeQuoteLines: Record 7207413;
        Text001: TextConst ENU = 'You cannot increase the amount above that of the source contract.', ESP = 'No puede aumentar la cantidad por encima de la del contrato de origen.';
        Text002: TextConst ENU = 'The amount has changed over the contracted one, the contract will be modified. Do you confirm?', ESP = 'Ha cambiado la cantidad sobre la contratada, se modificar� el comparativo. �Confirma?';
    BEGIN
        //JAV 08/02/21: - QB 1.08.08 Si la cantidad de la l�nea del pedido es menor de la cantidad original del contrato, reducir la cantidad en el contrato
        //                           Si la cantidad de la l�nea del pedido es mayor de la cantidad original del contrato, da un error pues no se puede ampliar desde aqu�.
        Rec.CALCFIELDS("QB Contract Qty. Original");
        IF (Rec."QB Contract Qty. Original" <> 0) THEN BEGIN
            //-16539 Solo se procesa si el comparativo se trabaja por cantidades, no por importes
            ComparativeQuoteHeader.RESET;
            ComparativeQuoteHeader.SETRANGE("Generated Contract Doc No.", Rec."Document No.");
            IF ComparativeQuoteHeader.FINDFIRST THEN
                IF ComparativeQuoteHeader."QB Comp Value Qty.  Purc. Line" = ComparativeQuoteHeader."QB Comp Value Qty.  Purc. Line"::Quantity THEN    //+16539

            IF (Rec.Quantity > Rec."QB Contract Qty. Original") THEN
                        ERROR(Text001)
                    ELSE IF (Rec.Quantity <> Rec."QB Contract Qty. Original") THEN BEGIN
                        IF NOT CONFIRM(Text002, FALSE) THEN
                            ERROR('');

                        //Buscar el comparativo y modificarlo
                        ComparativeQuoteLines.RESET;
                        ComparativeQuoteLines.SETRANGE("Contract Document Type", Rec."Document Type");
                        ComparativeQuoteLines.SETRANGE("Contract Document No.", Rec."Document No.");
                        ComparativeQuoteLines.SETRANGE("Contract Line No.", Rec."Line No.");
                        IF (ComparativeQuoteLines.FINDFIRST) THEN BEGIN
                            ComparativeQuoteLines.Quantity := Rec.Quantity;
                            ComparativeQuoteLines.MODIFY;
                        END;
                    END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, Quantity, true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_Quantity(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        //Calcular cantidad a recibir a origen
        CalAmountToReceive(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "Qty. to Receive", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_QtyToReceive(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        QtyOrigin: Decimal;
    BEGIN
        //JAV 07/05/21: - QB 1.08.41 Validar la cantidad a recibir, si es negativa la valido, la guardo y la dejo a cero para saltar la validaci�n del est�ndar
        Rec."QB tmp Qty to recive" := 0;
        QtyOrigin := Rec."Qty. to Receive" + Rec."Quantity Received";

        //Si la cantidad del documento es positiva o negativa, se controlan los m�ximos admisibles
        IF (Rec.Quantity > 0) AND (QtyOrigin < 0) THEN
            ERROR('En esta l�nea no puede recibir a origen en negativo (%1)', QtyOrigin)
        ELSE IF (Rec.Quantity < 0) AND (QtyOrigin > 0) THEN
            ERROR('En esta l�nea no puede recibir a origen en positivo (%1)', QtyOrigin)
        ELSE IF (ABS(QtyOrigin) > ABS(Rec.Quantity)) THEN
            ERROR('La cantidad a origen (%1) no puede superar a la del documento (%2)', QtyOrigin, Rec.Quantity);

        IF (Rec."Qty. to Receive" <= 0) THEN BEGIN
            Rec."QB tmp Qty to recive" := Rec."Qty. to Receive";
            Rec."Qty. to Receive" := 0;
            Rec."Qty. to Receive (Base)" := 0;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Qty. to Receive", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_QtyToReceive(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        //JAV 07/05/21: - QB 1.08.41 Validar la cantidad a recibir, si es negativa la recupero tras saltar la validaci�n del est�ndar
        IF (Rec."QB tmp Qty to recive" <> 0) THEN BEGIN
            Rec."Qty. to Receive" := Rec."QB tmp Qty to recive";
            IF Rec."Qty. per Unit of Measure" <> 0 THEN
                Rec."Qty. to Receive (Base)" := ROUND(Rec."Qty. to Receive" * Rec."Qty. per Unit of Measure", 0.00001)
            ELSE
                Rec."Qty. to Receive (Base)" := Rec."Qty. to Receive";

            Rec."QB tmp Qty to recive" := 0;
        END;

        //Calcular cantidad a recibir a origen
        CalAmountToReceive(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnValidateTypeOnCopyFromTempPurchLine, '', true, true)]
    LOCAL PROCEDURE T39_OnValidateTypeOnCopyFromTempPurchLine(VAR PurchLine: Record 39; TempPurchaseLine: Record 39 TEMPORARY);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 24/04/22: - QB 1.10.37 Recuperamos datos de la l�nea al cambiar el tipo de la l�nea
        IF FunctionQB.AccessToQuobuilding OR FunctionQB.AccessToBudgets OR FunctionQB.AccessToRealEstate THEN BEGIN
            PurchLine."Job No." := TempPurchaseLine."Job No.";
            PurchLine."Piecework No." := TempPurchaseLine."Piecework No.";
            PurchLine.VALIDATE("QB CA Code");
            PurchLine."QB CA Value" := TempPurchaseLine."QB CA Value";
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, PurchLine."Job No.", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, PurchLine."QB CA Value", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnValidateNoOnCopyFromTempPurchLine, '', true, true)]
    LOCAL PROCEDURE T39_OnValidateNoOnCopyFromTempPurchLine(VAR PurchLine: Record 39; TempPurchaseLine: Record 39 TEMPORARY);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV Recuperamos datos de la l�nea al cambiar el c�digo de la l�nea
        IF FunctionQB.AccessToQuobuilding OR FunctionQB.AccessToBudgets OR FunctionQB.AccessToRealEstate THEN BEGIN  //Ampliamos a presupuesto y Real Estate
            PurchLine."Job No." := TempPurchaseLine."Job No.";                      //JAV 24/04/22: - QB 1.10.37 Recuperamos el proyecto de la l�nea al cambiar el C�digo
            PurchLine."Piecework No." := TempPurchaseLine."Piecework No.";
            //JAV 30/05/22: - QB 1.10.45 Recuperamos el CA y establecemos dimensiones
            PurchLine.VALIDATE("QB CA Code");
            PurchLine."QB CA Value" := TempPurchaseLine."QB CA Value";
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, PurchLine."Job No.", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, PurchLine."QB CA Value", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInitHeaderDefaults, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterInitHeaderDefaults(VAR PurchLine: Record 39; PurchHeader: Record 38);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            //JAV 17/06/22: - QB 1.10.50 En pedidos contra almac�n no hay que indicar proyecto
            IF (PurchHeader."QB Order To" = PurchHeader."QB Order To"::Job) THEN BEGIN
                IF (PurchLine."Job No." = '') AND (PurchHeader."QB Job No." <> '') THEN
                    PurchLine.VALIDATE("Job No.", PurchHeader."QB Job No.");
            END;

            IF (PurchLine."Job No." = '') AND (PurchLine.Type = PurchLine.Type::Item) THEN
                ProposedDepartmentFromLocation(PurchLine);

            //JAV 21/05/22: - QB 1.10.42 Establecer la dimensi�n para el CA en su campo
            PurchLine.VALIDATE("QB CA Code");
            PurchLine.VALIDATE("QB CA Value");
            //  FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, PurchLine."Job No.",     PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");
            //  FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA,   PurchLine."QB CA Value", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");

        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterAssignFieldsForNo, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterAssignFieldsForNo(VAR PurchLine: Record 39; VAR xPurchLine: Record 39; PurchHeader: Record 38);
    VAR
        QuoBuildingSetup: Record 7207278;
        UserSetup: Record 91;
        Resource: Record 156;
        SubcontractingControl: Record 7207300;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You can not purchase resources that are not of the Subcontracting type', ESP = 'No se pueden comprar recursos que no sean de tipo Subcontrataci¢n.';
        Text002: TextConst ENU = 'You can not buy resources.', ESP = 'No se pueden comprar recursos.';
    BEGIN
        //JAV 20/05/22: - QB 1.10.43 Ampliamos a presupuesto y Real Estate
        IF FunctionQB.AccessToQuobuilding OR FunctionQB.AccessToBudgets OR FunctionQB.AccessToRealEstate THEN BEGIN
            IF (PurchLine.Type = PurchLine.Type::Resource) THEN BEGIN
                IF SubcontractingControl.READPERMISSION THEN BEGIN
                    Resource.GET(PurchLine."No.");
                    Resource.TESTFIELD(Resource.Blocked, FALSE);
                    Resource.TESTFIELD(Resource."Gen. Prod. Posting Group");
                    //QRE-LCG-INI
                    //IF Resource.Type <> Resource.Type::Subcontracting THEN
                    IF Resource.Type IN [Resource.Type::Person, Resource.Type::ExternalWorker, Resource.Type::Machine] THEN
                        //QRE-LCG-FIN
                        ERROR(Text001);
                    PurchLine.Description := Resource.Name;
                    PurchLine."Description 2" := Resource."Name 2";
                    PurchLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                    PurchLine."VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group";
                    PurchLine."Tax Group Code" := Resource."Tax Group Code";
                    PurchLine."Allow Item Charge Assignment" := FALSE;
                    PurchLine."Unit Price (LCY)" := Resource."Unit Price";
                    PurchLine."Direct Unit Cost" := Resource."Direct Unit Cost";
                    PurchLine."Indirect Cost %" := Resource."Indirect Cost %";
                    FindResUnitCost(PurchLine);
                    FindResPrice(PurchLine);
                    PurchLine.VALIDATE("Unit of Measure Code", Resource."Base Unit of Measure");
                END ELSE
                    ERROR(Text002);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInitQtyToReceive, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterInitQtyToReceive(VAR PurchLine: Record 39; CurrFieldNo: Integer);
    BEGIN
        //Calcular cantidad a recibir a origen
        CalAmountToReceive(PurchLine);
    END;

    // [EventSubscriber(ObjectType::Table, 39, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterCreateDimTableIDs(VAR PurchLine: Record 39; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        DataPieceworkForProduction: Record 7207386;
        i: Integer;
    BEGIN
        //JAV 21/05/22: - QB 1.10.42 Las l�neas de tipo recurso no son est�ndar, hay que tratarlas por aqu� en lugar de por la funci�n TypeToTableID3 de la CU 408 que as� mantenemos est�ndar
        IF (PurchLine.Type = PurchLine.Type::Resource) OR (PurchLine."QB Temp Type" = PurchLine.Type::Resource.AsInteger()) THEN BEGIN
            FOR i := 1 TO ARRAYLEN(TableID) DO
                IF (TableID[i] = 0) THEN BEGIN
                    TableID[i] := DATABASE::Resource;
                    No[i] := PurchLine."No.";
                    BREAK;
                END;
        END;

        //JAV 04/03/21: - QB 1.08.20 A¤adir la dimensi¢n u.o. en el documento de compra
        IF (DataPieceworkForProduction.GET(PurchLine."Job No.", PurchLine."Piecework No.")) THEN BEGIN
            FOR i := 1 TO ARRAYLEN(TableID) DO
                IF (TableID[i] = 0) THEN BEGIN
                    TableID[i] := DATABASE::"Data Piecework For Production";
                    No[i] := DataPieceworkForProduction."Unique Code";
                    BREAK;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterTestStatusOpen, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterTestStatusOpen(VAR PurchaseLine: Record 39; PurchaseHeader: Record 38);
    VAR
        Text001: TextConst ENU = 'You can''t modify or insert in a authorized order', ESP = 'No se puede modificar ni insertar en un pedido no abierto';
    BEGIN
        IF PurchaseLine."Document Type" <> PurchaseLine."Document Type"::"Blanket Order" THEN BEGIN
            IF PurchaseLine.Type = PurchaseLine.Type::Resource THEN
                IF PurchaseHeader.Status <> PurchaseHeader.Status::Open THEN
                    ERROR(Text001);
        END;

        IF (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) OR (PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Blanket Order") THEN BEGIN
            //RE16309-LCG-090222-INI
            //IF (PurchaseHeader.Status <> PurchaseHeader.Status::Open) THEN
            IF (PurchaseHeader.Status <> PurchaseHeader.Status::Open) AND (PurchaseHeader.Status <> PurchaseHeader.Status::"Pending Prepayment") THEN
                //RE16309-LCG-090222-FIN
                ERROR(Text001);
        END;
    END;

    LOCAL PROCEDURE CalAmountToReceive(VAR PurchLine: Record 39);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            PurchLine."QB Qty. to Receive Origin" := PurchLine."Qty. to Receive" + PurchLine."Quantity Received";
    END;

    LOCAL PROCEDURE JobLines(VAR PurchLine: Record 39);
    VAR
        PurchHeader: Record 38;
        FunctionQB: Codeunit 7207272;
        Job: Record 167;
    BEGIN
        PurchHeader.GET(PurchLine."Document Type", PurchLine."Document No.");
        IF PurchHeader."QB Job No." <> PurchLine."Job No." THEN BEGIN

            //-5526
            IF Job.GET(PurchHeader."QB Job No.") THEN
                IF Job."Card Type" <> Job."Card Type"::"Proyecto operativo" THEN
                    EXIT;
            //+5526

            //JAV 30/05/22: - Nuevo sistema de modificar dimensiones. Se establece Proyecto en la l�nea de compra
            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, PurchLine."Job No.", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code", PurchLine."Dimension Set ID");
            /*{
                    CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimJobs) OF
                      1 : PurchLine.ValidateShortcutDimCode(1,PurchLine."Job No.");
                      2 : PurchLine.ValidateShortcutDimCode(2,PurchLine."Job No.");
                      3 : PurchLine.ValidateShortcutDimCode(3,PurchLine."Job No.");
                      4 : PurchLine.ValidateShortcutDimCode(4,PurchLine."Job No.");
                      5 : PurchLine.ValidateShortcutDimCode(5,PurchLine."Job No.");
                      6 : PurchLine.ValidateShortcutDimCode(6,PurchLine."Job No.");
                      7 : PurchLine.ValidateShortcutDimCode(7,PurchLine."Job No.");
                      8 : PurchLine.ValidateShortcutDimCode(8,PurchLine."Job No.");
                    END;
                    }*/

        END;
    END;

    LOCAL PROCEDURE FindResUnitCost(VAR PurchaseLine: Record 39);
    VAR
        ResourceCost: Record 202;
        ResourceFindCost: Codeunit 220;
    BEGIN
        ResourceCost.INIT;
        ResourceCost.Code := PurchaseLine."No.";
        ResourceFindCost.RUN(ResourceCost);
        PurchaseLine."Direct Unit Cost" := ResourceCost."Direct Unit Cost";
        IF ResourceCost."Unit Cost" <> 0 THEN
            PurchaseLine."Unit Cost" := ResourceCost."Unit Cost";
        PurchaseLine.VALIDATE("Unit Cost");
    END;

    LOCAL PROCEDURE FindResPrice(VAR PurchaseLine: Record 39);
    VAR
        ResourcePrice: Record 201;
        ResourceFindPrice: Codeunit 221;
    BEGIN
        ResourcePrice.INIT;
        ResourcePrice."Job No." := PurchaseLine."Job No.";
        ResourcePrice.Code := PurchaseLine."No.";
        ResourcePrice."Work Type Code" := '';
        ResourcePrice."Currency Code" := PurchaseLine."Currency Code";
        ResourceFindPrice.RUN(ResourcePrice);
        IF ResourcePrice."Unit Price" <> 0 THEN
            PurchaseLine."Unit Price (LCY)" := ResourcePrice."Unit Price";
        PurchaseLine.VALIDATE("Unit Price (LCY)");
    END;

    LOCAL PROCEDURE ProposedDepartmentFromLocation(PurchLine: Record 39);
    VAR
        Location: Record 14;
        DimValue: Record 349;
        FunctionQB: Codeunit 7207272;
        DimMgt: Codeunit 408;
    BEGIN
        IF Location.GET(PurchLine."Location Code") THEN BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, Location."QB Departament Code", PurchLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code",
                                               PurchLine."Shortcut Dimension 2 Code");

            IF DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code") THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, DimValue."Job Structure Warehouse", PurchLine."Dimension Set ID");
                DimMgt.UpdateGlobalDimFromDimSetID(PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code",
                                                   PurchLine."Shortcut Dimension 2 Code");
            END;
        END;
    END;

    PROCEDURE ProposeAnalyticalConciliation(PurchaseLine: Record 39);
    VAR
        InventoryPostingSetup: Record 5813;
        DimValue: Record 349;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
        DimMgt: Codeunit 408;
    BEGIN
        IF PurchaseLine.Type <> PurchaseLine.Type::Item THEN
            EXIT;

        IF (Item.GET(PurchaseLine."No.")) THEN   //JAV 28/04/22: - QB 1.10.37 Solo si existe el producto
            IF InventoryPostingSetup.GET(PurchaseLine."Location Code", Item."Inventory Posting Group") THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."Analytic Concept", PurchaseLine."Dimension Set ID");
                DimMgt.UpdateGlobalDimFromDimSetID(PurchaseLine."Dimension Set ID", PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
            END;
    END;

    PROCEDURE ProposeCAResource(PurchaseLine: Record 39);
    VAR
        ResourceCost: Record 202;
        Resource: Record 156;
        DefaultDimension: Record 352;
        FunctionQB: Codeunit 7207272;
        DimMgt: Codeunit 408;
    BEGIN
        IF PurchaseLine.Type <> PurchaseLine.Type::Resource THEN
            EXIT;

        ResourceCost.RESET;
        ResourceCost.SETFILTER(ResourceCost.Type, '%1', ResourceCost.Type::Resource);
        ResourceCost.SETRANGE(ResourceCost.Code, PurchaseLine."No.");
        ResourceCost.SETRANGE(ResourceCost."Work Type Code", '');
        IF ResourceCost.FINDFIRST THEN BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Direct Cost Allocation", PurchaseLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(PurchaseLine."Dimension Set ID", PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
        END ELSE BEGIN
            //JAV 27/10/21: - QB 1.08.24 Si no hay todav�a un recurso no dar un error
            IF (Resource.GET(PurchaseLine."No.")) THEN BEGIN
                DefaultDimension.SETRANGE("Table ID", DATABASE::Resource);
                DefaultDimension.SETRANGE("No.", Resource."No.");
                DefaultDimension.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                IF (DefaultDimension.FINDFIRST) AND (DefaultDimension."Dimension Value Code" <> '') THEN BEGIN
                    FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, DefaultDimension."Dimension Value Code", PurchaseLine."Dimension Set ID");
                    DimMgt.UpdateGlobalDimFromDimSetID(PurchaseLine."Dimension Set ID", PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
                END;
            END;
        END;
    END;

    PROCEDURE T39_SplitLine(VAR Rec: Record 39; NewPrice: Decimal; OldPrice: Decimal);
    VAR
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        WithholdingTreating: Codeunit 7207306;
        ActStatus: Enum "Purchase Document Status";
    BEGIN
        //JAV 07/11/22: - QB 1.12.13 Proceso para dividir una l�nea, se crea la acci�n QB_Split y la funci�n QB_SplitLine
        IF (Rec."QB Splitted Line Date" <> 0D) THEN
            ERROR('L�nea ya dividida.');

        IF (Rec."Quantity Received" = 0) THEN
            ERROR('No hay cantidad recibida para poder dividir la l�nea');

        IF (Rec.Quantity - Rec."Quantity Received" <= 0) THEN
            ERROR('No hay cantidad pendiente de recibir');

        //Abrimos la cabecera para poder modificar sin problemas
        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        ActStatus := PurchaseHeader.Status;
        PurchaseHeader.Status := PurchaseHeader.Status::Open;
        PurchaseHeader.MODIFY(FALSE);

        //Crear la nueva l�nea con la cantidad pendiente
        PurchaseLine := Rec;
        PurchaseLine."Line No." += 1;
        PurchaseLine."Direct Unit Cost" := NewPrice;
        // EPV 11/01/23 - BUG corregido - Fallaba porque se validaba la cantidad antes de anular la cantidad recibida.
        //PurchaseLine.VALIDATE(Quantity, Rec.Quantity - Rec."Quantity Received");
        //-->
        PurchaseLine."Quantity Invoiced" := 0;
        PurchaseLine."Qty. Invoiced (Base)" := 0;
        PurchaseLine."Quantity Received" := 0;
        PurchaseLine."Qty. Received (Base)" := 0;
        PurchaseLine."Qty. Rcd. Not Invoiced" := 0;
        PurchaseLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        // EPV 11/01/23 - BUG corregido - Fallaba porque se validaba la cantidad antes de anular la cantidad recibida.
        PurchaseLine.VALIDATE(Quantity, Rec.Quantity - Rec."Quantity Received");
        //-->
        PurchaseLine.INSERT(TRUE);

        //Ajustar y marcar la anterior l�nea como dividida para que no sea editable
        Rec."Direct Unit Cost" := OldPrice;
        Rec.VALIDATE(Quantity, Rec."Quantity Received");
        Rec.MODIFY(TRUE);

        //Volver a calcular las retenciones
        WithholdingTreating.CalculateWithholding_PurchaseHeader(PurchaseHeader);

        //Marcar las l�neas tras los cambios
        PurchaseLine."QB Splitted Line Base" := Rec."Line No.";
        PurchaseLine.MODIFY(FALSE);

        Rec."QB Splitted Line Date" := TODAY;
        Rec.MODIFY(FALSE);

        //Reponer el estado de la cabecera
        PurchaseHeader.Status := ActStatus; //option to enum
        PurchaseHeader.MODIFY(FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Piecework No.", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidatePieceworkCode(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        Error001: TextConst ENU = 'No puede modificar la UO si viene de un comparativo.';
        Error002: TextConst ENU = 'No puede modificar la UO con cantidades recibidas';
        Job: Record 167;
        Error003: TextConst ENU = 'La UO debe ser la Unidad coste almac�n';
    BEGIN
        //+Q18816
        //+c Si viene en blanco permitir cambiarla
        //IF (Rec."Piecework No." <> xRec."Piecework No.") THEN BEGIN
        IF (Rec."Piecework No." <> xRec."Piecework No.") THEN BEGIN
            IF (Rec."QB Contract Qty. Original" <> 0) AND (xRec."Piecework No." = '') THEN BEGIN
                Job.GET(Rec."Job No.");
                IF Job."Warehouse Cost Unit" <> Rec."Piecework No." THEN ERROR(Error003);
            END;
            IF (Rec."QB Contract Qty. Original" <> 0) AND (xRec."Piecework No." <> '') THEN
                ERROR(Error001)
            ELSE BEGIN
                IF Rec."Quantity Received" <> 0 THEN ERROR(Error002);
            END;
        END;
        //-Q18816
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "QB CA Value", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateQBCAvalue(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        Error001: TextConst ENU = 'No puede modificar el CA si viene de un comparativo.';
        Error002: TextConst ENU = 'No puede modificar el CA con cantidades recibidas';
    BEGIN
        //+Q18816
        //AML Correcci�n para evitar error al crear la l�nea.
        //IF (Rec."QB CA Value" <> xRec."QB CA Value") THEN BEGIN
        IF (Rec."QB CA Value" <> xRec."QB CA Value") AND (xRec."QB CA Value" <> '') THEN BEGIN
            IF Rec."QB Contract Qty. Original" <> 0 THEN
                ERROR(Error001)
            ELSE
                IF Rec."Quantity Received" <> 0 THEN ERROR(Error002);
        END;
        //-Q18816
    END;

    [EventSubscriber(ObjectType::Table, 43, OnAfterValidateEvent, Comment, true, true)]
    LOCAL PROCEDURE OnValidateComment_TPurchCommentLine(VAR Rec: Record 43; VAR xRec: Record 43; CurrFieldNo: Integer);
    BEGIN
        //QBA5412
        IF Rec.Comment <> xRec.Comment THEN
            Rec.VALIDATE(User, USERID);
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Sales Comment Line (44)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 44, OnAfterValidateEvent, Comment, true, true)]
    LOCAL PROCEDURE OnValidateComment_TSalesCommentLine(VAR Rec: Record 44; VAR xRec: Record 44; CurrFieldNo: Integer);
    BEGIN
        //QBA5412
        IF Rec.Comment <> xRec.Comment THEN
            Rec.VALIDATE(User, USERID);
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Invoice Post. Buffer (49)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 49, OnAfterInvPostBufferPreparePurchase, '', true, true)]
    LOCAL PROCEDURE PreparePurchaseTInvoicePostBuffer(VAR PurchaseLine: Record 39; VAR InvoicePostBuffer: Record 49);
    VAR
        FunctionQB: Codeunit 7207272;
        Job: Record 167;
    BEGIN
        //JAV 17/06/22: - QB 1.10.50 Se amplian los tipos de proyecto a tratar en compras QB/RE/CECO
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            IF PurchaseLine.Type = PurchaseLine.Type::Resource THEN
                InvoicePostBuffer.Type := InvoicePostBuffer.Type::Resource;

            // Agrupamos por almac�n
            InvoicePostBuffer."Location Code" := PurchaseLine."Location Code";
            InvoicePostBuffer."Piecework Code" := PurchaseLine."Piecework No.";
            IF PurchaseLine."Job No." <> '' THEN BEGIN
                Job.GET(PurchaseLine."Job No.");
                IF NOT Job."Management by tasks" THEN BEGIN
                    InvoicePostBuffer."Piecework Code" := PurchaseLine."Piecework No.";
                END ELSE BEGIN
                    InvoicePostBuffer."Piecework Code" := PurchaseLine."Job Task No.";
                    InvoicePostBuffer."Job Task No." := PurchaseLine."Job Task No.";
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 49, OnAfterInvPostBufferPrepareSales, '', true, true)]
    LOCAL PROCEDURE T49_OnAfterInvPostBufferPrepareSales(VAR SalesLine: Record 37; VAR InvoicePostBuffer: Record 49);
    VAR
        FunctionQB: Codeunit 7207272;
        Job: Record 167;
    BEGIN
        //JAV 17/06/22: - QB 1.10.50 Nueva funcion que captura el eveto para preparar la tabla en ventas
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            InvoicePostBuffer."Piecework Code" := SalesLine."QB_Piecework No.";
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Report Selections (77)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 77, OnBeforePrintWithGUIYesNoVendor, '', true, true)]
    LOCAL PROCEDURE T77_OnBeforePrintWithGUIYesNoVendor(ReportUsage: Integer; RecordVariant: Variant; IsGUI: Boolean; VendorNoFieldNo: Integer; VAR Handled: Boolean);
    VAR
        QBReportSelections: Record 7206901;
        ReportSelection: Record 77;
    BEGIN
        //JAV 12/03/21: - QB 1.08.23 Este proceso captura el manejador de impresi�n est�ndar para reports de ventas y cambia cuando es necesario por el propio
        CASE ReportUsage OF
            ReportSelection.Usage::"P.Receipt".AsInteger(): //Albar�n de compra
                BEGIN
                    QBReportSelections.Print(QBReportSelections.Usage::P2, RecordVariant);
                    Handled := TRUE;
                END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Gen. Journal Line (81)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, "Document Type", true, true)]
    LOCAL PROCEDURE OnAfterValidateDocumentType_TGenJournalLine(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    BEGIN
        //JAV 08/10/20: - QB 1.06.20 Solo permitimos tipo de movimiento albar�n si es para un proveedor
        ValidateTypeAndAccount_TGenJournalLine(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, "Account Type", true, true)]
    LOCAL PROCEDURE OnAfterValidateAccountType_TGenJournalLine(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    BEGIN
        //JAV 08/10/20: - QB 1.06.20 Solo permitimos tipo de movimiento albar�n si es para un proveedor
        ValidateTypeAndAccount_TGenJournalLine(Rec);
    END;

    LOCAL PROCEDURE ValidateTypeAndAccount_TGenJournalLine(Rec: Record 81);
    VAR
        Txt01: TextConst ESP = 'Solo puede usar tipo de documento "Albar�n" cuando el tipo de cuenta es "Proveedor"';
        Txt02: TextConst ESP = 'Solo puede usar tipo de documento "Obra en Curso" cuando el tipo de cuenta es "Cliente"';
    BEGIN
        //JAV 08/10/20: - QB 1.06.20 Solo permitimos tipo de movimiento albar�n si es para un proveedor
        IF (Rec."Document Type" = Rec."Document Type"::Shipment) AND (Rec."Account Type" <> Rec."Account Type"::Vendor) THEN
            ERROR(Txt01);

        //JAV 08/10/20: - QB 1.06.20 Solo permitimos tipo de movimiento obra en curso si es para un cliente
        IF (Rec."Document Type" = Rec."Document Type"::WIP) AND (Rec."Account Type" <> Rec."Account Type"::Customer) THEN
            ERROR(Txt02);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnValidateAccountNo1TGenJournalLine, '', true, true)]
    LOCAL PROCEDURE OnValidateAccountNo1TGenJournalLine(GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF NOT FunctionQB.AccessToQuobuilding THEN
            GenJournalLine.VALIDATE("Job No.", '');
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, GetCustomerAccountTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE GetCustomerAccountTGenJournalLine(GenJournalLine: Record 81);
    VAR
        Customer: Record 18;
    BEGIN
        GenJournalLine."Destination Entry JV" := Customer."QB JV Dimension Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, GetVendorAccountTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE GetVendorAccountTGenJournalLine(GenJournalLine: Record 81);
    VAR
        Vendor: Record 23;
    BEGIN
        GenJournalLine."Destination Entry JV" := Vendor."QB JV Dimension Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, GetBankAccountTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE GetBankAccountTGenJournalLine(GenJournalLine: Record 81);
    VAR
        BankAccount: Record 270;
    BEGIN
        GenJournalLine."Destination Entry JV" := BankAccount."JV Dimension Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, GetCustomerBalAccountTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE GetCustomerBalAccountTGenJournalLine(GenJournalLine: Record 81);
    VAR
        Customer: Record 18;
    BEGIN
        GenJournalLine."App. Account Dest. Entry JV" := Customer."QB JV Dimension Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, GetVendorBalAccountTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE GetVendorBalAccountTGenJournalLine(GenJournalLine: Record 81);
    VAR
        Vendor: Record 23;
    BEGIN
        GenJournalLine."App. Account Dest. Entry JV" := Vendor."QB JV Dimension Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, GetBankAccountTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE GetBankBalAccountTGenJournalLine(GenJournalLine: Record 81);
    VAR
        BankAccount: Record 270;
    BEGIN
        GenJournalLine."App. Account Dest. Entry JV" := BankAccount."JV Dimension Code";
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnValidateJobNo2TGenJournalLine, '', true, true)]
    LOCAL PROCEDURE OnValidateJobNo2TGenJournalLine(GenJournalLine: Record 81);
    VAR
        Text000: TextConst ENU = 'No job is specified for journal lines other than account type or fixed asset', ESP = 'No se especifica proyecto para l¡neas de diario de tipo %1';
    BEGIN
        IF NOT (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Fixed Asset",
                                                 GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]) THEN
            ERROR(Text000, GenJournalLine."Account Type");
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, "Source No.", true, true)]
    LOCAL PROCEDURE OnValidateSourceTypeTGenJournalLine(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    BEGIN
        IF (Rec."Source Type" = Rec."Source Type"::Customer) OR (Rec."Source Type" = Rec."Source Type"::Vendor) THEN
            Rec."Bill-to/Pay-to No." := Rec."Source No.";
        //++Rec.UpdateCountryCodeAndVATRegNo(Rec."Source No.");
        UpdateCountryCodeAndVATRegNoTGenJournalLine(Rec);
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, UpdateCountryCodeAndVATRegNoTGenJournalLine, '', true, true)]
    LOCAL PROCEDURE UpdateCountryCodeAndVATRegNoTGenJournalLine(GenJournalLine: Record 81);
    VAR
        Customer: Record 18;
        Vendor: Record 23;
        No: Code[20];
    BEGIN
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") AND
           ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) OR
            (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo")) THEN BEGIN
            IF GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Sale THEN BEGIN
                Customer.GET(GenJournalLine."Bill-to/Pay-to No.");
                GenJournalLine."Country/Region Code" := Customer."Country/Region Code";
                GenJournalLine."VAT Registration No." := Customer."VAT Registration No.";
            END;
            IF GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Purchase THEN BEGIN
                Vendor.GET(GenJournalLine."Bill-to/Pay-to No.");
                GenJournalLine."Country/Region Code" := Vendor."Country/Region Code";
                GenJournalLine."VAT Registration No." := Vendor."VAT Registration No.";
            END;
        END;
    END;

    // [EventSubscriber(ObjectType::Table, 81, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs_TGenJournalLine(VAR GenJournalLine: Record 81; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        DataPieceworkForProduction: Record 7207386;
        i: Integer;
    BEGIN
        //JAV 04/03/21: - QB 1.08.20 A¤adir la dimensi¢n u.o. en el documento de compra
        IF (DataPieceworkForProduction.GET(GenJournalLine."Job No.", GenJournalLine."Piecework Code")) THEN BEGIN
            FOR i := 1 TO ARRAYLEN(TableID) DO
                IF (TableID[i] = 0) THEN BEGIN
                    TableID[i] := DATABASE::"Data Piecework For Production";
                    No[i] := DataPieceworkForProduction."Unique Code";
                    EXIT;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, "Payment Method Code", true, true)]
    LOCAL PROCEDURE T81_OnAfterValidateEvent_PaymentMethod(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    VAR
        rPaymentMethod: Record 289;
    BEGIN
        //JAV 13/01/22: - QB 1.10.09 Tras validar m�todo de pago en el diario contable
        Rec."QB Confirming" := FALSE;
        IF rPaymentMethod.GET(Rec."Payment Method Code") THEN
            Rec."QB Confirming" := rPaymentMethod."QB Confirming Customer";
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterCopyGenJnlLineFromGenJnlAllocation, '', true, true)]
    LOCAL PROCEDURE T81_OnAfterCopyGenJnlLineFromGenJnlAllocation(GenJnlAllocation: Record 221; VAR GenJournalLine: Record 81);
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        //JAV 13/07/22: QB 1.11.00 A�adir en la l�nea del diario contable los datos del proyecto y UO/Partida desde las l�neas de distribuci�n
        //-----------------------------------------------------------------------------------------------------------------------------------------

        GenJournalLine."Job No." := GenJnlAllocation."Job No.";
        GenJournalLine."Piecework Code" := GenJnlAllocation."Piecework Code";
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------------Item journal Line (83)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 83, OnAfterCopyItemJnlLineFromPurchLine, '', true, true)]
    LOCAL PROCEDURE T83_OnAfterCopyItemJnlLineFromPurchLine(VAR ItemJnlLine: Record 83; PurchLine: Record 39);
    BEGIN
        // Control prestados.
        ItemJnlLine."QB Ceded Control" := TRUE;
    END;

    // [EventSubscriber(ObjectType::Table, 83, OnAfterCreateDimTableIDs, '', true, true)]
    LOCAL PROCEDURE T83_OnAfterCreateDimTableIDs(VAR ItemJournalLine: Record 83; FieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20]);
    VAR
        DataPieceworkForProduction: Record 7207386;
        i: Integer;
    BEGIN
        //JAV 20/04/22: - QB 1.10.36 A¤adir la dimensi¢n JOB en el diario de productos
        FOR i := 1 TO ARRAYLEN(TableID) DO BEGIN
            IF (TableID[i] = DATABASE::Job) THEN
                EXIT;

            IF (TableID[i] = 0) THEN BEGIN
                TableID[i] := DATABASE::Job;
                No[i] := ItemJournalLine."Job No.";
                EXIT;
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Acc. Schedule Line (85)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 85, OnBeforeValidateEvent, "Analytic Concept", true, true)]
    LOCAL PROCEDURE OnValidateAnalyticConceptTAccScheduleLine(VAR Rec: Record 85; VAR xRec: Record 85; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        DimensionValue: Record 349;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            FunctionQB.ValidateCA(Rec."Analytic Concept");
            IF DimensionValue.GET(FunctionQB.ReturnDimCA, Rec."Analytic Concept") THEN;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 85, OnBeforeValidateEvent, "Row No.", true, true)]
    LOCAL PROCEDURE OnValidateRowNoTAccScheduleLine(VAR Rec: Record 85; VAR xRec: Record 85; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.CheckCharacters(Rec.FIELDCAPTION(Rec."Row No."), Rec."Row No.");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Customer Posting Group (92)"();
    BEGIN
    END;

    PROCEDURE T92_ChangeCustomerConfirmingAccount(VAR GenJournalLine: Record 81; VAR Account: Code[20]);
    VAR
        PaymentMethod: Record 289;
        CustomerPostingGroup: Record 92;
        QBTableSubscriber: Codeunit 7207347;
    BEGIN
        //JAV 13/01/22: - QB 1.10.09 Cambiar la cuenta del confirming como cliente
        IF PaymentMethod.GET(GenJournalLine."Payment Method Code") THEN
            IF PaymentMethod."QB Confirming Customer" THEN BEGIN
                GenJournalLine."QB Confirming" := TRUE;

                CustomerPostingGroup.GET(GenJournalLine."Posting Group");
                CASE GenJournalLine."QB Confirming Dealing Type" OF
                    GenJournalLine."QB Confirming Dealing Type"::" ":
                        BEGIN
                            CustomerPostingGroup.TESTFIELD("QB Confirming Account");
                            Account := CustomerPostingGroup."QB Confirming Account";
                        END;
                    GenJournalLine."QB Confirming Dealing Type"::Collection:
                        BEGIN
                            CustomerPostingGroup.TESTFIELD("QB Confirming Collection Acc.");
                            Account := CustomerPostingGroup."QB Confirming Collection Acc.";
                        END;
                    GenJournalLine."QB Confirming Dealing Type"::Discount:
                        BEGIN
                            CustomerPostingGroup.TESTFIELD("QB Confirming Discount Acc.");
                            Account := CustomerPostingGroup."QB Confirming Discount Acc.";
                        END;
                END;
            END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Vendor Posting Group (93)"();
    BEGIN
    END;

    PROCEDURE T93_ChangeVendorConfirmingAccount(PaymentMethodCode: Code[20]; VendorPostingGroupCode: Code[20]; VAR Account: Code[20]);
    VAR
        PaymentMethod: Record 289;
        VendorPostingGroup: Record 93;
    BEGIN
        //JAV 13/01/22: - QB 1.10.09 Cambiar la cuenta del confirming como proveedor
        IF PaymentMethod.GET(PaymentMethodCode) THEN
            IF PaymentMethod."QB Confirming Vendor" THEN BEGIN

                VendorPostingGroup.GET(VendorPostingGroupCode);
                VendorPostingGroup.TESTFIELD("QB Confirming Account");
                Account := VendorPostingGroup."QB Confirming Account";
            END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- G/L Budget Name (95)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 95, OnBeforeRenameEvent, '', true, true)]
    LOCAL PROCEDURE OnRenameTGLBudgetName(VAR Rec: Record 95; VAR xRec: Record 95; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'It can not be renamed, it is for internal Quobuilding treatment.', ESP = 'No puede renombrar, es para tratamiento interno de Quobuilding.';
    BEGIN
        // No se puede renombrar el registro donde nombre =PROYECTO
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec.Name <> xRec.Name) AND (xRec.Name = FunctionQB.ReturnBudgetJobs) THEN
                ERROR(Text000);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 95, OnBeforeValidateEvent, Name, true, true)]
    LOCAL PROCEDURE OnValidateNeameTGLBudgetName(VAR Rec: Record 95; VAR xRec: Record 95; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'It can not be renamed, it is for internal Quobuilding treatment.', ESP = 'No puede modificar, es para tratamiento interno de Quobuilding.';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec.Name <> xRec.Name) AND (xRec.Name = FunctionQB.ReturnBudgetJobs) THEN
                ERROR(Text000);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 95, OnBeforeValidateEvent, "Budget Dimension 1 Code", true, true)]
    LOCAL PROCEDURE OnValidateBudgetDimension1CodeTGLBudgetName(VAR Rec: Record 95; VAR xRec: Record 95; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'It can not be renamed, it is for internal Quobuilding treatment.', ESP = 'No puede modificar, es para tratamiento interno de Quobuilding.';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (xRec."Budget Dimension 1 Code" <> '') THEN
                IF (Rec."Budget Dimension 1 Code" <> xRec."Budget Dimension 1 Code") AND (Rec.Name = FunctionQB.ReturnBudgetJobs) THEN
                    ERROR(Text000);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 95, OnBeforeValidateEvent, "Budget Dimension 2 Code", true, true)]
    LOCAL PROCEDURE OnValidateBudgetDimension2CodeTGLBudgetName(VAR Rec: Record 95; VAR xRec: Record 95; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'It can not be renamed, it is for internal Quobuilding treatment.', ESP = 'No puede modificar, es para tratamiento interno de Quobuilding.';
    BEGIN
        IF FunctionQB.AccessToReestimates THEN BEGIN
            IF (xRec."Budget Dimension 2 Code" <> '') THEN
                IF (Rec."Budget Dimension 2 Code" <> xRec."Budget Dimension 2 Code") AND (Rec.Name = FunctionQB.ReturnBudgetJobs) THEN
                    MESSAGE(Text000);
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------------  G/L Budget Entry (96)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 96, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnDeleteTGLBudgetEntry(VAR Rec: Record 96; RunTrigger: Boolean);
    VAR
        AnalysisViewBudgetEntry: Record 366;
    BEGIN
        // Borro los mov. ppto. vista analisis T 366
        //JMMA 18/10/19: - SE COMENTA ESTE CODIGO POR LENTITUD EN EL CAL. PPTO ANAL�TICO. EL EST�NDAR YA BORRA LA ENTRADA DE LA VISTA DE AN�LISIS.
        // IF FunctionQB.AccessToQuobuilding THEN BEGIN
        //  AnalysisViewBudgetEntry.RESET;
        //  AnalysisViewBudgetEntry.SETCURRENTKEY("Entry No.");
        //  AnalysisViewBudgetEntry.SETRANGE("Entry No.",Rec."Entry No.");
        //  IF AnalysisViewBudgetEntry.FINDFIRST THEN
        //    AnalysisViewBudgetEntry.DELETE(TRUE);
        // END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Comment Line (97)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 97, OnAfterValidateEvent, Comment, true, true)]
    LOCAL PROCEDURE OnValidateComment_TCommentLine(VAR Rec: Record 97; VAR xRec: Record 97; CurrFieldNo: Integer);
    BEGIN
        //QBA5412
        IF Rec.Comment <> xRec.Comment THEN
            Rec.VALIDATE(User, USERID);
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Sales Rcpt. Line (111)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 111, OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine, '', true, true)]
    LOCAL PROCEDURE T111_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(VAR SalesShptLine: Record 111; VAR SalesLine: Record 37; VAR NextLineNo: Integer; VAR Handled: Boolean);
    VAR
        Txt000: TextConst ESP = 'de fecha %1:';
    BEGIN
        //JAV 28/10/21: - DynPlus A�adir la fecha del albar�n, le quito los : al final para a�adir la fecha al final
        //-Q20398
        //SalesLine.Description := COPYSTR(SalesLine.Description, 1, STRLEN(SalesLine.Description) - 1) + ' ' + STRSUBSTNO(Txt000, SalesShptLine."Posting Date");
        //SalesLine.Description := COPYSTR(SalesLine.Description + ' ' + STRSUBSTNO(Txt000, SalesShptLine."Posting Date"), 1, 50) ;
        SalesLine.Description := COPYSTR(SalesLine.Description, 1, 50);
        //+Q20398
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Purch. Rcpt. Line (121)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 121, OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine, '', true, true)]
    LOCAL PROCEDURE T121_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(VAR PurchRcptLine: Record 121; VAR PurchLine: Record 39; VAR NextLineNo: Integer; VAR Handled: Boolean);
    VAR
        Txt000: TextConst ESP = 'de fecha %1:';
    BEGIN
        //JAV 28/10/21: - DynPlus A�adir la fecha del albar�n, le quito los : al final para a�adir la fecha al final
        PurchLine.Description := COPYSTR(PurchLine.Description, 1, STRLEN(PurchLine.Description) - 1) + ' ' + STRSUBSTNO(Txt000, PurchRcptLine."Posting Date");
    END;

    [EventSubscriber(ObjectType::Table, 121, OnBeforeInsertInvLineFromRcptLine, '', true, true)]
    [TryFunction]
    LOCAL PROCEDURE T21_OnBeforeInsertInvLineFromRcptLine(VAR PurchRcptLine: Record 121; VAR PurchLine: Record 39; PurchOrderLine: Record 39);
    BEGIN
        //17277 24/05/21
        PurchLine."Order No." := PurchRcptLine."Order No.";
        PurchLine."Order Line No." := PurchRcptLine."Order Line No.";

        //CPA 27/03/23 Q16226. + Facturar Albaranes con mismo producto al mismo precio.
        PurchLine.VALIDATE("Direct Unit Cost", PurchRcptLine."Unit Cost");
        //CPA 27/03/23 Q16226. - Facturar Albaranes con mismo producto al mismo precio.
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Resource Group (152)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 152, OnBeforeValidateEvent, "Cod. C.A. Direct Cost", true, true)]
    LOCAL PROCEDURE OnValidateCodCADirectCostResourceGroup(VAR Rec: Record 152; VAR xRec: Record 152; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateCA(Rec."Cod. C.A. Direct Cost");
    END;

    [EventSubscriber(ObjectType::Table, 152, OnBeforeValidateEvent, "Cod. C.A. Indirect Cost", true, true)]
    LOCAL PROCEDURE OnValidateCodCAIndirectCostResourceGroup(VAR Rec: Record 152; VAR xRec: Record 152; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateCA(Rec."Cod. C.A. Indirect Cost");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Resource (156)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 156, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnValidateGetDefaultCalendarResource(VAR Rec: Record 156; RunTrigger: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET;
            Rec."Type Calendar" := QuoBuildingSetup."Default Calendar";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 156, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE UpdateJobDesviationAndNotAssignedWhenChangeDepResource(VAR Rec: Record 156; VAR xRec: Record 156; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        recDimValues: Record 349;
    BEGIN
        IF (NOT RunTrigger) THEN
            EXIT;

        IF (FunctionQB.AccessToQuobuilding) THEN BEGIN
            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
                IF Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" THEN BEGIN
                    recDimValues.GET(FunctionQB.ReturnDimDpto, Rec."Global Dimension 1 Code");
                    Rec."Jobs Deviation" := recDimValues."Jobs desviation";
                    Rec."Jobs Not Assigned" := recDimValues."Jobs Not Assigned";
                END;
            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
                IF Rec."Global Dimension 2 Code" <> xRec."Global Dimension 2 Code" THEN BEGIN
                    recDimValues.GET(FunctionQB.ReturnDimDpto, Rec."Global Dimension 2 Code");
                    Rec."Jobs Deviation" := recDimValues."Jobs desviation";
                    Rec."Jobs Not Assigned" := recDimValues."Jobs Not Assigned";
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 156, OnBeforeValidateEvent, Type, true, true)]
    LOCAL PROCEDURE OnValidateTypeResource(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF (FunctionQB.AccessToQuobuilding) AND (NOT FunctionQB.AccessToRentalManagement) THEN
            IF (Rec.Type = Rec.Type::Subcontracting) THEN
                Rec."Type Calendar" := '';
    END;

    [EventSubscriber(ObjectType::Table, 156, OnAfterValidateEvent, "Resource Group No.", true, true)]
    LOCAL PROCEDURE OnValidateResourceGroupNo(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            GetCADefault(Rec);
            GetFamilyCostResource(Rec);
            GetSalesGroupResource(Rec);
            GetTransferGroupResource(Rec);
        END;
    END;

    LOCAL PROCEDURE GetFamilyCostResource(Resource: Record 156);
    VAR
        ResourceCost: Record 202;
        ResourceCost2: Record 202;
    BEGIN
        ResourceCost2.RESET;
        ResourceCost2.SETCURRENTKEY(Type, Code, "Work Type Code");
        ResourceCost2.SETRANGE(Type, ResourceCost2.Type::"Group(Resource)");
        ResourceCost2.SETRANGE(Code, Resource."Resource Group No.");
        IF ResourceCost2.FINDSET(FALSE) THEN BEGIN
            REPEAT
                ResourceCost.INIT;
                ResourceCost.Type := ResourceCost.Type::Resource;
                ResourceCost.Code := Resource."No.";
                ResourceCost."Work Type Code" := ResourceCost2."Work Type Code";
                ResourceCost."Direct Unit Cost" := ResourceCost2."Direct Unit Cost";
                ResourceCost."Unit Cost" := ResourceCost2."Unit Cost";
                ResourceCost."C.A. Direct Cost Allocation" := ResourceCost2."C.A. Direct Cost Allocation";
                ResourceCost."Acc. Direct Cost Allocation" := ResourceCost2."Acc. Direct Cost Allocation";
                ResourceCost."C.A. Direct Cost Appl. Account" := ResourceCost2."C.A. Direct Cost Appl. Account";
                ResourceCost."Acc. Direct Cost Appl. Account" := ResourceCost2."Acc. Direct Cost Appl. Account";
                ResourceCost."C.A. Indirect Cost Allocation" := ResourceCost2."C.A. Indirect Cost Allocation";
                ResourceCost."Acc. Indirect Cost Allocation" := ResourceCost2."Acc. Indirect Cost Allocation";
                ResourceCost."C.A. Ind. Cost Appl. Account" := ResourceCost2."C.A. Ind. Cost Appl. Account";
                ResourceCost."Acc. Ind. Cost Appl. Account" := ResourceCost2."Acc. Ind. Cost Appl. Account";
                IF NOT ResourceCost.INSERT THEN
                    ResourceCost.MODIFY;
            UNTIL ResourceCost2.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE GetCADefault(VAR Resource: Record 156);
    VAR
        ResourceGroup: Record 152;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF (ResourceGroup.GET(Resource."Resource Group No.")) THEN BEGIN
            IF (ResourceGroup."Cod. C.A. Direct Cost" <> '') THEN BEGIN
                CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
                    1:
                        Resource.VALIDATE("Global Dimension 1 Code", ResourceGroup."Cod. C.A. Direct Cost");
                    2:
                        Resource.VALIDATE("Global Dimension 2 Code", ResourceGroup."Cod. C.A. Direct Cost");
                END;
            END;
            IF (ResourceGroup."Cod. C.A. Indirect Cost" <> '') THEN
                Resource.VALIDATE("Cod. C.A. Indirect Costs", ResourceGroup."Cod. C.A. Indirect Cost");
        END;
    END;

    LOCAL PROCEDURE GetSalesGroupResource(Resource: Record 156);
    VAR
        ResourcePrice: Record 201;
        ResourcePrice2: Record 201;
    BEGIN
        ResourcePrice2.RESET;
        ResourcePrice2.SETRANGE(Type, ResourcePrice2.Type::"Group(Resource)");
        ResourcePrice2.SETRANGE(Code, Resource."Resource Group No.");
        IF ResourcePrice2.FINDSET(FALSE) THEN BEGIN
            REPEAT
                ResourcePrice.INIT;
                ResourcePrice."Job No." := ResourcePrice2."Job No.";
                ResourcePrice.Type := ResourcePrice.Type::Resource;
                ResourcePrice.Code := Resource."No.";
                ResourcePrice."Work Type Code" := ResourcePrice2."Work Type Code";
                ResourcePrice."Unit Price" := ResourcePrice2."Unit Price";
                IF NOT ResourcePrice.INSERT THEN
                    ResourcePrice.MODIFY;
            UNTIL ResourcePrice2.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE GetTransferGroupResource(Resource: Record 156);
    VAR
        TransferPriceCost: Record 7207299;
        TransferPriceCost2: Record 7207299;
        FunctionQB: Codeunit 7207272;
    BEGIN
        TransferPriceCost.RESET;
        TransferPriceCost.SETRANGE(Type, TransferPriceCost.Type::"Group(Resource)");
        TransferPriceCost.SETRANGE(Code, Resource."Resource Group No.");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
            TransferPriceCost.SETFILTER("Cod. Dept.", '<>%1', Resource."Global Dimension 1 Code");
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
            TransferPriceCost.SETFILTER("Cod. Dept.", '<>%1', Resource."Global Dimension 2 Code");
        IF TransferPriceCost.FINDSET(FALSE) THEN BEGIN
            REPEAT
                TransferPriceCost2.INIT;
                TransferPriceCost2.Type := TransferPriceCost2.Type::Resource;
                TransferPriceCost2.Code := Resource."No.";
                TransferPriceCost2."Cod. Dept." := TransferPriceCost."Cod. Dept.";
                TransferPriceCost2."Work Type Code" := TransferPriceCost."Work Type Code";
                TransferPriceCost2."Unit Cost" := TransferPriceCost."Unit Cost";
                IF NOT TransferPriceCost2.INSERT THEN
                    TransferPriceCost2.MODIFY;
            UNTIL TransferPriceCost.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 156, OnBeforeValidateEvent, "Jobs Deviation", true, true)]
    LOCAL PROCEDURE OnValidateJobDesviationResource(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        Text005BIS: TextConst ENU = 'Status Job must be Order', ESP = 'El Estado del proyecto debe ser pedido';
        Text006BIS: TextConst ENU = 'Job must not be Blocked', ESP = 'El proyecto no debe estar bloqueado';
        recJob: Record 167;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF Rec."Jobs Deviation" <> '' THEN BEGIN
                recJob.GET(Rec."Jobs Deviation");
                IF recJob.Status <> recJob.Status::Open THEN
                    ERROR(Text005BIS);
                IF recJob.Blocked <> recJob.Blocked::" " THEN
                    ERROR(Text006BIS);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 156, OnBeforeValidateEvent, "Jobs Not Assigned", true, true)]
    LOCAL PROCEDURE OnvalidateJobsNotAssignedResource(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        recJob: Record 167;
        FunctionQB: Codeunit 7207272;
        Text005BIS: TextConst ENU = 'Status Job must be Order', ESP = 'El Estado del proyecto debe ser pedido';
        Text006BIS: TextConst ENU = 'Job must not be Blocked', ESP = 'El proyecto no debe estar bloqueado';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF Rec."Jobs Not Assigned" <> '' THEN BEGIN
                recJob.GET(Rec."Jobs Not Assigned");
                IF recJob.Status <> recJob.Status::Open THEN
                    ERROR(Text005BIS);
                IF recJob.Blocked <> recJob.Blocked::" " THEN
                    ERROR(Text006BIS);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 156, OnBeforeValidateEvent, "Cod. Type Jobs not Assigned", true, true)]
    LOCAL PROCEDURE OnValidateCodTypeJobsNotAssignedResource(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        RecWorkType: Record 200;
        text008: TextConst ENU = 'Type Work Must have field "Compute Hours" active', ESP = 'El tipo de trabajo debe tener activo el campo computa para horas';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            RecWorkType.RESET;
            RecWorkType.GET(Rec."Cod. Type Jobs not Assigned");
            IF RecWorkType."Compute Hours" = FALSE THEN
                ERROR(text008);
        END
    END;

    [EventSubscriber(ObjectType::Table, 156, OnBeforeValidateEvent, "Activity Code", true, true)]
    LOCAL PROCEDURE OnValidateCodActivityResource(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        ActivityQB: Record 7207280;
    BEGIN
        //Vamos a llevar a la ficha recResource los g.c.p  que existan en la t(71026) Actividad-Producto
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            ActivityQB.SETRANGE(ActivityQB."Activity Code", Rec."Activity Code");
            IF ActivityQB.FINDFIRST THEN BEGIN
                IF ActivityQB."Posting Group Product" <> '' THEN
                    Rec."Gen. Prod. Posting Group" := ActivityQB."Posting Group Product";
                Rec.RESET;
            END;
        END;
        Rec.VALIDATE("Gen. Prod. Posting Group");
    END;

    [EventSubscriber(ObjectType::Table, 156, OnBeforeValidateEvent, "Cod. C.A. Indirect Costs", true, true)]
    LOCAL PROCEDURE OnValidateCodCAIndirectCostResource(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."Cod. C.A. Indirect Costs");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, ValidateShortCutDimCodeResource, '', true, true)]
    LOCAL PROCEDURE ValidateShortCutDimCodeResource(VAR ShortcutDimCode: Code[20]; VAR recResource: Record 156);
    VAR
        recDefaultDim: Record 352;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF ShortcutDimCode <> '' THEN BEGIN
                IF recDefaultDim.GET(DATABASE::Resource, recResource."No.", FunctionQB.ReturnDimDpto) THEN
                    AssignJobsDesviation(recResource, recDefaultDim);
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Job Ledger Entry (169)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 169, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeInsertEvent_TJobLedgerEntry(VAR Rec: Record 169; RunTrigger: Boolean);
    BEGIN
        //GEN005-02
        Rec.VALIDATE("Total Price (ACY)");
    END;

    [EventSubscriber(ObjectType::Table, 169, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeModifyEvent_TJobLedgerEntry(VAR Rec: Record 169; VAR xRec: Record 169; RunTrigger: Boolean);
    BEGIN
        //GEN005-02
        Rec.VALIDATE("Total Price (ACY)");
    END;

    [EventSubscriber(ObjectType::Table, 169, OnAfterValidateEvent, "Add.-Currency Line Amount", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_AditionalCurrencyAmount_TJobLedgerEntry(VAR Rec: Record 169; VAR xRec: Record 169; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
        Job: Record 167;
        Type: Option "Cost","Sale","General";
    BEGIN
        //GEN005-02
        IF NOT Job.GET(Rec."Job No.") THEN
            EXIT;

        IF (Job."Aditional Currency" = '') THEN BEGIN
            Rec."Total Price (ACY)" := 0;
            Rec."Exchange Rate (ACY)" := 0;
        END ELSE BEGIN
            //jmma divisas corregir error
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."Total Cost (LCY)", '', Job."Aditional Currency", Rec."Posting Date", Type::Cost, AssignedAmount, CurrencyFactor);
            Rec."Total Price (ACY)" := AssignedAmount;
            Rec."Exchange Rate (ACY)" := CurrencyFactor;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Work Type (200)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "C.A. Direct Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateCADirectCostAllocationTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."C.A. Direct Cost Allocation");
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "Acc. Direct Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateAccDirectCostAllocationTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        CAccount: Code[20];
        Text001: TextConst ENU = 'Account %1 is blocked', ESP = 'La cuenta %1 est  bloqueada';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GLAccount.GET(CAccount) THEN BEGIN
                IF GLAccount.Blocked = TRUE THEN
                    ERROR(Text001, CAccount);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "C.A. Direct Cost App. Account", true, true)]
    LOCAL PROCEDURE OnValidateCADirectCostAppAccountTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."C.A. Direct Cost App. Account");
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "Acc. Direct Cost App. Account", true, true)]
    LOCAL PROCEDURE OnValidateAccDirectCostAppAccountTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        CAccount: Code[20];
        Text001: TextConst ENU = 'Account %1 is blocked', ESP = 'La cuenta %1 est  bloqueada';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GLAccount.GET(CAccount) THEN BEGIN
                IF GLAccount.Blocked = TRUE THEN
                    ERROR(Text001, CAccount);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "C.A. Indirect Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateCAIndirectCostAllocationTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."C.A. Indirect Cost Allocation");
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "Acc. Indirect Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateAccIndirectCostAllocationTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        CAccount: Code[20];
        Text001: TextConst ENU = 'Account %1 is blocked', ESP = 'La cuenta %1 est  bloqueada';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GLAccount.GET(CAccount) THEN BEGIN
                IF GLAccount.Blocked = TRUE THEN
                    ERROR(Text001, CAccount);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "C.A. Indirect Cost App. Accoun", true, true)]
    LOCAL PROCEDURE OnValidateCAIndirectCostAppAccountTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."C.A. Indirect Cost App. Accoun");
    END;

    [EventSubscriber(ObjectType::Table, 200, OnBeforeValidateEvent, "Acc. Indirect Cost App. Accoun", true, true)]
    LOCAL PROCEDURE OnValidateAccIndirectCostAppAccountTWorkType(VAR Rec: Record 200; VAR xRec: Record 200; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        CAccount: Code[20];
        Text001: TextConst ENU = 'Account %1 is blocked', ESP = 'La cuenta %1 est  bloqueada';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF GLAccount.GET(CAccount) THEN BEGIN
                IF GLAccount.Blocked = TRUE THEN
                    ERROR(Text001, CAccount);
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Resource Cost (202)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 202, OnAfterValidateEvent, Code, true, true)]
    LOCAL PROCEDURE OnValidateCodeTResourceCost(VAR Rec: Record 202; VAR xRec: Record 202; CurrFieldNo: Integer);
    VAR
        ResourceGroup: Record 152;
        FunctionQB: Codeunit 7207272;
        Resource: Record 156;
    BEGIN
        IF Rec.Type = Rec.Type::"Group(Resource)" THEN BEGIN
            IF ResourceGroup.GET(Rec.Code) THEN BEGIN
                IF Rec."Work Type Code" = '' THEN BEGIN
                    Rec.VALIDATE("C.A. Direct Cost Allocation", ResourceGroup."Cod. C.A. Direct Cost");
                    Rec.VALIDATE("C.A. Indirect Cost Allocation", ResourceGroup."Cod. C.A. Indirect Cost");
                END;
            END;
        END;

        IF Rec.Type = Rec.Type::Resource THEN BEGIN
            IF Resource.GET(Rec.Code) THEN BEGIN
                IF Rec."Work Type Code" = '' THEN BEGIN
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                        Rec.VALIDATE("C.A. Direct Cost Allocation", Resource."Global Dimension 2 Code");
                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                        Rec.VALIDATE("C.A. Direct Cost Allocation", Resource."Global Dimension 1 Code");
                    Rec.VALIDATE("C.A. Indirect Cost Allocation", Resource."Cod. C.A. Indirect Costs");
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 202, OnBeforeValidateEvent, "Work Type Code", true, true)]
    LOCAL PROCEDURE OnValidateWorkTypeCodeTResourceCost(VAR Rec: Record 202; VAR xRec: Record 202; CurrFieldNo: Integer);
    VAR
        WorkType: Record 200;
    BEGIN
        IF WorkType.GET(Rec."Work Type Code") THEN BEGIN
            Rec.VALIDATE("C.A. Direct Cost Allocation", WorkType."C.A. Direct Cost Allocation");
            Rec.VALIDATE("Acc. Direct Cost Allocation", WorkType."Acc. Direct Cost Allocation");
            Rec.VALIDATE("C.A. Direct Cost Appl. Account", WorkType."C.A. Direct Cost App. Account");
            Rec.VALIDATE("Acc. Direct Cost Appl. Account", WorkType."Acc. Direct Cost App. Account");

            Rec.VALIDATE("C.A. Indirect Cost Allocation", WorkType."C.A. Indirect Cost Allocation");
            Rec.VALIDATE("Acc. Indirect Cost Allocation", WorkType."Acc. Indirect Cost Allocation");
            Rec.VALIDATE("C.A. Ind. Cost Appl. Account", WorkType."C.A. Indirect Cost App. Accoun");
            Rec.VALIDATE("Acc. Ind. Cost Appl. Account", WorkType."Acc. Indirect Cost App. Accoun");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 202, OnBeforeValidateEvent, "Direct Unit Cost", true, true)]
    LOCAL PROCEDURE OnValidateDirectUnitCostTResourceCost(VAR Rec: Record 202; VAR xRec: Record 202; CurrFieldNo: Integer);
    BEGIN
        IF Rec."Unit Cost" = 0 THEN
            Rec."Unit Cost" := Rec."Direct Unit Cost";
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "C.A. Direct Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateCADirectCostAllocationResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN
        //     FunctionQB.ValidateCA(Rec."C.A. Direct Cost Allocation");
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "Acc. Direct Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateAccountDirectCostAllocationResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        GLAccount: Record 15;
        Text001: TextConst ENU = 'This Account cannot be used because it is Blocked', ESP = 'No puede usar esta cuenta porque est  bloqueada';
        Text002: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser de tipo comercial';
        Text003: TextConst ENU = 'Account must be "Posting" type', ESP = 'La cuenta debe ser de tipo auxiliar';
        Text004: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser Comercial.';
        FunctionQB: Codeunit 7207272;
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN
        //     IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
        //         IF GLAccount.GET(Rec."Acc. Direct Cost Allocation") THEN BEGIN
        //             IF GLAccount.Blocked THEN
        //                 ERROR(Text001);
        //             IF GLAccount."Income/Balance" <> GLAccount."Income/Balance"::"Income Statement" THEN
        //                 ERROR(Text002);
        //             IF GLAccount."Account Type" <> GLAccount."Account Type"::Posting THEN
        //                 ERROR(Text003);
        //         END;
        //     END ELSE
        //         ERROR(Text004);
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "C.A. Direct Cost Appl. Account", true, true)]
    LOCAL PROCEDURE OnValidateCADirectCostApplAccountResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN
        //     FunctionQB.ValidateCA(Rec."C.A. Direct Cost Appl. Account");
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "Acc. Direct Cost Appl. Account", true, true)]
    LOCAL PROCEDURE OnValidateCtaDirectCostApplAccountResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
        Text001: TextConst ENU = 'This Account cannot be used because it is Blocked', ESP = 'No puede usar esta cuenta porque est  bloqueada';
        Text002: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser de tipo comercial';
        Text003: TextConst ENU = 'Account must be "Posting" type', ESP = 'La cuenta debe ser de tipo auxiliar';
        Text004: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser Comercial.';
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN BEGIN
        //     IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN
        //         IF GLAccount.GET(Rec."Acc. Direct Cost Appl. Account") THEN BEGIN
        //             IF GLAccount.Blocked THEN
        //                 ERROR(Text001);
        //             IF GLAccount."Income/Balance" <> GLAccount."Income/Balance"::"Income Statement" THEN
        //                 ERROR(Text002);
        //             IF GLAccount."Account Type" <> GLAccount."Account Type"::Posting THEN
        //                 ERROR(Text003);
        //         END;
        // END ELSE
        //     ERROR(Text004);
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "C.A. Indirect Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateCAIndirectCostAllocationResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN
        //     FunctionQB.ValidateCA(Rec."C.A. Indirect Cost Allocation");
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "Acc. Indirect Cost Allocation", true, true)]
    LOCAL PROCEDURE OnValidateAccountIndCostAllocationResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
        Text001: TextConst ENU = 'This Account cannot be used because it is Blocked', ESP = 'No puede usar esta cuenta porque est  bloqueada';
        Text002: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser de tipo comercial';
        Text003: TextConst ENU = 'Account must be "Posting" type', ESP = 'La cuenta debe ser de tipo auxiliar';
        Text004: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser Comercial.';
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN BEGIN
        //     IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" THEN
        //         IF GLAccount.GET(Rec."Acc. Indirect Cost Allocation") THEN BEGIN
        //             IF GLAccount.Blocked THEN
        //                 ERROR(Text001);
        //             IF GLAccount."Income/Balance" <> GLAccount."Income/Balance"::"Income Statement" THEN
        //                 ERROR(Text002);
        //             IF GLAccount."Account Type" <> GLAccount."Account Type"::Posting THEN
        //                 ERROR(Text003);
        //         END;
        // END ELSE
        //     ERROR(Text004);
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "C.A. Ind. Cost Appl. Account", true, true)]
    LOCAL PROCEDURE OnValidateCAIndirectCostApplAccountResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN
        //     FunctionQB.ValidateCA(Rec."C.A. Ind. Cost Appl. Account");
    END;

    // [EventSubscriber(ObjectType::Table, 7001, OnBeforeValidateEvent, "Acc. Ind. Cost Appl. Account", true, true)]
    LOCAL PROCEDURE OnValidateCtaIndirectCostApplAccountResourceCost(VAR Rec: Record 7001; VAR xRec: Record 7001; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
        Text001: TextConst ENU = 'This Account cannot be used because it is Blocked', ESP = 'No puede usar esta cuenta porque est  bloqueada';
        Text002: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser de tipo comercial';
        Text003: TextConst ENU = 'Account must be "Posting" type', ESP = 'La cuenta debe ser de tipo auxiliar';
        Text004: TextConst ENU = 'Account must be "Income Statement" type', ESP = 'La cuenta debe ser Comercial.';
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN BEGIN
        //     IF GLAccount.GET(Rec."Acc. Ind. Cost Appl. Account") THEN BEGIN
        //         IF GLAccount.Blocked THEN
        //             ERROR(Text001);
        //         IF GLAccount."Income/Balance" <> GLAccount."Income/Balance"::"Income Statement" THEN
        //             ERROR(Text002);
        //         IF GLAccount."Account Type" <> GLAccount."Account Type"::Posting THEN
        //             ERROR(Text003);
        //     END;
        // END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Job Posting Group (208)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 208, OnBeforeValidateEvent, "Sales Analytic Concept", true, true)]
    LOCAL PROCEDURE OnValidateSalesAnalyticConceptTJobPostingGroup(VAR Rec: Record 208; VAR xRec: Record 208; CurrFieldNo: Integer);
    VAR
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'You must specify an analytical concept of income type.', ESP = 'Debe especificar un concepto anal¡tico de tipo ingresos.';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            FunctionQB.ValidateCA(Rec."Sales Analytic Concept");
            IF DimensionValue.GET(FunctionQB.ReturnDimCA, Rec."Sales Analytic Concept") THEN
                IF DimensionValue.Type <> DimensionValue.Type::Income THEN BEGIN
                    Rec."Sales Analytic Concept" := xRec."Sales Analytic Concept";
                    ERROR(Text001);
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 208, OnBeforeValidateEvent, "CA Income Job in Progress", true, true)]
    LOCAL PROCEDURE OnValidateCAIncomeJobinProgressTJobPostingGroup(VAR Rec: Record 208; VAR xRec: Record 208; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."CA Income Job in Progress");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Job Journal Line (210)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 210, OnBeforeValidateEvent, "Post Job Entry Only", true, true)]
    LOCAL PROCEDURE OnValidatePostEntryOnlyTJobJournalLine(VAR Rec: Record 210; VAR xRec: Record 210; CurrFieldNo: Integer);
    VAR
        Text000: TextConst ENU = 'You cannot change %1 when %2 is %3.', ESP = 'No se puede cambiar %1 cuando %2 es %3.';
        Location: Record 14;
        JobJnlLine: Record 210;
    BEGIN
        IF (Rec.Type <> Rec.Type::Item) THEN
            ERROR(
              Text000,
              Rec.FIELDCAPTION("Post Job Entry Only"), Rec.FIELDCAPTION(Type), JobJnlLine.Type);
        IF (Rec.Type = Rec.Type::Item) AND (NOT Rec."Post Job Entry Only") THEN BEGIN

            IF Rec."Location Code" = '' THEN
                CLEAR(Location)
            ELSE
                IF Location.Code <> Rec."Location Code" THEN
                    Location.GET(Rec."Location Code");
            Location.TESTFIELD("Directed Put-away and Pick", FALSE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 210, OnBeforeValidateEvent, "Post Job Entry Only", true, true)]
    LOCAL PROCEDURE OnValidatePostJobEntryOnlyTJobJurnalLine(VAR Rec: Record 210; VAR xRec: Record 210; CurrFieldNo: Integer);
    VAR
        Text000: TextConst ENU = 'You cannot change %1 when %2 is %3.', ESP = 'No se puede cambiar %1 cuando %2 es %3.';
        JobJournalLine: Record 210;
        Location: Record 14;
    BEGIN
        IF (Rec.Type <> Rec.Type::Item) THEN
            ERROR(
              Text000,
              Rec.FIELDCAPTION("Post Job Entry Only"), Rec.FIELDCAPTION(Type), JobJournalLine.Type);
        IF (Rec.Type = Rec.Type::Item) AND (NOT Rec."Post Job Entry Only") THEN BEGIN
            IF (Location.GET(Rec."Location Code")) THEN
                Location.TESTFIELD("Directed Put-away and Pick", FALSE);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, "OnValidateUnitCost(LCY)TJobJournalLine", '', true, true)]
    LOCAL PROCEDURE "OnValidateUnitCost(LCY)TJobJournalLine"(JobJournalLine: Record 210);
    VAR
        Item: Record 27;
        Text000: TextConst ENU = 'You cannot change %1 when %2 is %3.', ESP = 'No se puede cambiar %1 cuando %2 es %3.';
    BEGIN
        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
            IF JobJournalLine."Unit Cost" <> Item."Standard Cost" THEN
                ERROR(
                  Text000,
                  JobJournalLine.FIELDCAPTION("Unit Cost"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Gen. Jnl. Allocation (221)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 221, OnBeforeValidateEvent, "Job No.", true, true)]
    LOCAL PROCEDURE OnValidateJobNoTGenJnlAllocation(VAR Rec: Record 221; VAR xRec: Record 221; CurrFieldNo: Integer);
    BEGIN
        Rec.CreateDim(DATABASE::Job, Rec."Job No.");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Bank Account (270)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 270, OnBeforeValidateEvent, "JV Dimension Code", true, true)]
    LOCAL PROCEDURE OnValidateJVDimensionCodeTBankAccount(VAR Rec: Record 270; VAR xRec: Record 270; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateJV(Rec."JV Dimension Code");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Payment Method (289)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 289, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T289_OnAfterModifyEvent(VAR Rec: Record 289; VAR xRec: Record 289; RunTrigger: Boolean);
    BEGIN
        //JAV 13/01/22: - QB 1.10.09 Antes de modificar las formas de pago, revisar el confirming
        //Q5547 PER 25.01.19 Se indican controles para evitar que se indique el check de confirming de manera incoherente.

        IF NOT RunTrigger THEN
            EXIT;

        IF Rec."QB Confirming Customer" THEN BEGIN
            Rec.TESTFIELD("Create Bills");
            Rec.TESTFIELD("Collection Agent", Rec."Collection Agent"::Bank);
            Rec.TESTFIELD("Bal. Account No.", '');
            Rec.TESTFIELD("Bill Type", Rec."Bill Type"::" ");
        END ELSE IF Rec."QB Confirming Vendor" THEN BEGIN
            Rec.TESTFIELD("Invoices to Cartera");
            Rec.TESTFIELD("Collection Agent", Rec."Collection Agent"::Bank);
            Rec.TESTFIELD("Bal. Account No.", '');
            Rec.TESTFIELD("Bill Type", Rec."Bill Type"::" ");
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Column Layout (334)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 334, OnBeforeValidateEvent, "Column No.", true, true)]
    LOCAL PROCEDURE OnValidateColumnNoTColumnLayout(VAR Rec: Record 334; VAR xRec: Record 334; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.CheckCharacters(Rec.FIELDCAPTION("Column No."), Rec."Column No.");
    END;

    [EventSubscriber(ObjectType::Table, 348, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnDeleteTDimension(VAR Rec: Record 348; RunTrigger: Boolean);
    VAR
        Text014BIS: TextConst ENU = 'No se puede eliminar la dimensi¢n.%1 esta siendo usada en Configuraci¢n de contabilidad como C¢d. dimensi¢n para CA.', ESP = 'The dimension can not be deleted.%1 is being used in Accounting Settings as Code. Dimension for AC.';
        Text015BIS: TextConst ENU = 'No se puede eliminar la dimensi¢n.%1 esta siendo usada en Configuraci¢n de contabilidad como C¢d. dimensi¢n para Proyectos.', ESP = 'The dimension can not be deleted.%1 is being used in Accounting Settings as Code. Dimension for Jobs.';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF FunctionQB.ReturnDimCA <> '' THEN BEGIN
                IF Rec.Code = FunctionQB.ReturnDimCA THEN
                    ERROR(Text014BIS, Rec.Code);
            END;
            IF FunctionQB.ReturnDimJobs <> '' THEN BEGIN
                IF Rec.Code = FunctionQB.ReturnDimJobs THEN
                    ERROR(Text015BIS, Rec.Code);
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Dimension (338)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 348, OnBeforeRenameEvent, '', true, true)]
    LOCAL PROCEDURE OnRenameTDimension(VAR Rec: Record 348; VAR xRec: Record 348; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'It can not be renamed, it is for internal Quobuilding treatment.', ESP = 'No puede renombrar, es para tratamiento interno de Quobuilding.';
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec.Code <> xRec.Code) AND (xRec.Code IN [FunctionQB.ReturnDimCA, FunctionQB.ReturnDimJobs,
                 FunctionQB.ReturnDimReest, FunctionQB.ReturnDimDpto]) THEN
                ERROR(Text000);
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Dimension Value (349)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 349, OnBeforeValidateEvent, "Transfer Analytical Concept", true, true)]
    LOCAL PROCEDURE OnValidateTransferAnalyticalConceptTDimensionValue(VAR Rec: Record 349; VAR xRec: Record 349; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."Transfer Analytical Concept");
    END;

    [EventSubscriber(ObjectType::Table, 23, OnBeforeValidateEvent, "QB JV Dimension Code", true, true)]
    LOCAL PROCEDURE ValidateJVDimensionCodeVendor(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'There is no JV %1', ESP = 'No existe la UTE %1';
    BEGIN
        IF Rec."QB JV Dimension Code" = '' THEN
            EXIT;

        IF NOT DimensionValue.GET(FunctionQB.ReturnDimJV, Rec."QB JV Dimension Code") THEN
            ERROR(Text001, Rec."QB JV Dimension Code");
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Default Dimension(352)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 352, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE OnModify_TDefaultDimensions(VAR Rec: Record 352; VAR xRec: Record 352; RunTrigger: Boolean);
    VAR
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = 'Can not remove maintenance of this dimension since job %1 is in effect', ESP = 'No se puede eliminar el mantenimiento de esta dimensi¢n ya que el proyecto %1 est  en vigor';
    BEGIN
        IF NOT RunTrigger THEN  //JAV 14/03/22: - QB 1.10.24 Si no estamos ejecutando con el trigger activado salimos
            EXIT;

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF Job.GET(Rec."No.") THEN BEGIN
                IF (Rec."Table ID" = DATABASE::Job) AND
                   (Rec."Dimension Code" = FunctionQB.ReturnDimJobs) AND
                   (Rec."No." = Job."No.") THEN
                    ERROR(Text001, Job."No.");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 352, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnDelete_TDefaultDimensions(VAR Rec: Record 352; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
        Job: Record 167;
        Text001: TextConst ENU = 'Can not remove maintenance of this dimension since job %1 is in effect', ESP = 'No se puede eliminar el mantenimiento de esta dimensi¢n ya que el proyecto %1 est  en vigor';
    BEGIN
        // IF FunctionQB.AccessToQuobuilding THEN BEGIN //QB Se elimina para dejar borrar
        //  IF Job.GET(Rec."No.") THEN BEGIN
        //    IF (Rec."Table ID"= DATABASE::Job) AND
        //       (Rec."Dimension Code" = FunctionQB.ReturnDimJobs) AND
        //       (Rec."No." = Job."No.") THEN
        //      ERROR(Text001,Job."No.");
        //  END;
        // END;
    END;

    [EventSubscriber(ObjectType::Table, 352, OnAfterValidateEvent, "Dimension Value Code", true, true)]
    LOCAL PROCEDURE OnValidate_DimensionValueCode_TDefaultDimension(VAR Rec: Record 352; VAR xRec: Record 352; CurrFieldNo: Integer);
    VAR
        Resource: Record 156;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            AssignJobsDesviation(Resource, Rec);
    END;

    [EventSubscriber(ObjectType::Table, 352, OnBeforeValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_No_TDefaultDimensions(VAR Rec: Record 352; VAR xRec: Record 352; CurrFieldNo: Integer);
    BEGIN
        //JAV 04/03/21: - QB 1.08.20 Si es de la tabla de unidades de obra del proyecto no se puede validar por el campo clave sino por el c�digo �nico, antes del validate lo dejo en blanco
        //JAV 08/03/21: - QB 1.08.22 Si es de la tabla de unidades de obra del preciario no se puede validar por el campo clave sino por el c�digo �nico, antes del validate lo dejo en blanco
        IF (Rec."Table ID" IN [DATABASE::"Data Piecework For Production", DATABASE::Piecework]) THEN BEGIN
            xRec."No." := Rec."No.";
            Rec."No." := '';
        END;
    END;

    [EventSubscriber(ObjectType::Table, 352, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_No_TDefaultDimensions(VAR Rec: Record 352; VAR xRec: Record 352; CurrFieldNo: Integer);
    BEGIN
        //JAV 04/03/21: - QB 1.08.20 Si es de la tabla de unidades de obra del proyecto, no se puede validar por el campo clave sino por el c�digo �nico, despu�s del validate lo recupero
        //JAV 08/03/21: - QB 1.08.22 Si es de la tabla de unidades de obra del preciario no se puede validar por el campo clave sino por el c�digo �nico, antes del validate lo dejo en blanco
        IF (Rec."Table ID" IN [DATABASE::"Data Piecework For Production", DATABASE::Piecework]) THEN BEGIN
            Rec."No." := xRec."No.";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, AssignJobDesviationTDefaultDimension, '', true, true)]
    LOCAL PROCEDURE AssignJobsDesviation(VAR recResource: Record 156; recDefaultDimension: Record 352);
    VAR
        FunctionQB: Codeunit 7207272;
        recDimensionValue: Record 349;
    BEGIN
        IF recDefaultDimension."Table ID" <> DATABASE::Resource THEN
            EXIT;

        IF recDefaultDimension."Dimension Code" <> FunctionQB.ReturnDimDpto THEN
            EXIT;

        IF (recDefaultDimension."Dimension Value Code" = '') THEN
            EXIT;

        recResource.GET(recDefaultDimension."No.");
        IF recResource."Jobs Deviation" <> '' THEN BEGIN
            IF FunctionQB.GetDepartment(DATABASE::Job, recResource."Jobs Deviation") <>
               FunctionQB.GetDepartment(DATABASE::Resource, recDefaultDimension."No.") THEN BEGIN
                recDimensionValue.GET(recDefaultDimension."Dimension Code", recDefaultDimension."Dimension Value Code");
                recResource."Jobs Deviation" := recDimensionValue."Jobs desviation";
            END;
        END ELSE BEGIN
            recDimensionValue.GET(recDefaultDimension."Dimension Code", recDefaultDimension."Dimension Value Code");
            recResource."Jobs Deviation" := recDimensionValue."Jobs desviation";
        END;

        IF recResource."Jobs Not Assigned" <> '' THEN BEGIN
            IF FunctionQB.GetDepartment(DATABASE::Job, recResource."Jobs Not Assigned") <>
               FunctionQB.GetDepartment(DATABASE::Resource, recDefaultDimension."No.") THEN BEGIN
                recDimensionValue.GET(recDefaultDimension."Dimension Code", recDefaultDimension."Dimension Value Code");
                recResource."Jobs Not Assigned" := recDimensionValue."Jobs Not Assigned";
            END;
        END ELSE BEGIN
            recDimensionValue.GET(recDefaultDimension."Dimension Code", recDefaultDimension."Dimension Value Code");
            recResource."Jobs Not Assigned" := recDimensionValue."Jobs Not Assigned";
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Excel Buffer (370)"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Table, 370, TA370_OnParseCellValue_LimitTo250Chars, '', true, true)]
    LOCAL PROCEDURE TA370_OnParseCellValue_LimitTo250Chars(VAR Value: Text);
    BEGIN
        //QB_2785

        Value := COPYSTR(Value, 1, 250);
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Job Planning Line (1003)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 1003, OnBeforeValidateEvent, "Analytical concept", true, true)]
    LOCAL PROCEDURE ValidateAnalyticalConcept(VAR Rec: Record 1003; VAR xRec: Record 1003; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."Analytical concept");
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnValidateNo1TJobPlanningLine, '', true, true)]
    LOCAL PROCEDURE OnValidateNo1TJobPlanningLine(JobPlanningLine: Record 1003);
    VAR
        ResourceCost: Record 202;
        Job: Record 167;
        Resource: Record 156;
        FunctionQB: Codeunit 7207272;
        TransferPriceCost: Record 7207299;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            ResourceCost.RESET;
            IF JobPlanningLine.Type = JobPlanningLine.Type::Resource THEN
                ResourceCost.SETFILTER(ResourceCost.Type, '%1', ResourceCost.Type::Resource);

            ResourceCost.SETRANGE(ResourceCost.Code, JobPlanningLine."No.");
            ResourceCost.SETRANGE(ResourceCost."Work Type Code", '');
            IF ResourceCost.FINDSET THEN
                JobPlanningLine."Analytical concept" := ResourceCost."C.A. Direct Cost Allocation";

            Job.GET(JobPlanningLine."Job No.");

            IF JobPlanningLine.Type = JobPlanningLine.Type::Resource THEN BEGIN
                Resource.GET(JobPlanningLine."No.");
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
                    IF Resource."Global Dimension 1 Code" <> Job."Global Dimension 1 Code" THEN BEGIN
                        TransferPriceCost.RESET;
                        TransferPriceCost.SETFILTER(TransferPriceCost.Type, '%1', TransferPriceCost.Type::Resource);
                        TransferPriceCost.SETRANGE(TransferPriceCost."Cod. Dept.", Job."Global Dimension 1 Code");
                        TransferPriceCost.SETRANGE(TransferPriceCost."Work Type Code", '');
                        TransferPriceCost.SETRANGE(TransferPriceCost.Code, Resource."No.");
                        IF TransferPriceCost.FINDFIRST THEN BEGIN
                            JobPlanningLine."Unit Cost (LCY)" := TransferPriceCost."Unit Cost";
                            JobPlanningLine."Direct Unit Cost (LCY)" := TransferPriceCost."Unit Cost";
                        END;
                    END;
                END;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN BEGIN
                    IF Resource."Global Dimension 2 Code" <> Job."Global Dimension 2 Code" THEN BEGIN
                        TransferPriceCost.RESET;
                        TransferPriceCost.SETFILTER(TransferPriceCost.Type, '%1', TransferPriceCost.Type::Resource);
                        TransferPriceCost.SETRANGE(TransferPriceCost."Cod. Dept.", Job."Global Dimension 2 Code");
                        TransferPriceCost.SETRANGE(TransferPriceCost."Work Type Code", '');
                        TransferPriceCost.SETRANGE(TransferPriceCost.Code, Resource."No.");
                        IF TransferPriceCost.FINDFIRST THEN BEGIN
                            JobPlanningLine."Unit Cost (LCY)" := TransferPriceCost."Unit Cost";
                            JobPlanningLine."Direct Unit Cost (LCY)" := TransferPriceCost."Unit Cost";
                        END;
                    END;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnValidateNo2TJobPlanningLine, '', true, true)]
    LOCAL PROCEDURE OnValidateNo2TJobPlanningLine(JobPlanningLine: Record 1003);
    VAR
        VLocation: Code[10];
        Item: Record 27;
        InventoryPostingSetup: Record 5813;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            VLocation := '';
            Item.GET(JobPlanningLine."No.");
            InventoryPostingSetup.GET(VLocation, Item."Inventory Posting Group");
            JobPlanningLine."Analytical concept" := InventoryPostingSetup."Analytic Concept";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnValidateNo3TJobPlanningLine, '', true, true)]
    LOCAL PROCEDURE OnValidateNo3TJobPlanningLine(JobPlanningLine: Record 1003);
    VAR
        DefaultDimension: Record 352;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            DefaultDimension.RESET;
            DefaultDimension.SETRANGE(DefaultDimension."Table ID", DATABASE::"G/L Account");
            DefaultDimension.SETRANGE(DefaultDimension."No.", JobPlanningLine."No.");
            DefaultDimension.SETRANGE(DefaultDimension."Dimension Code", FunctionQB.ReturnDimCA);
            IF DefaultDimension.FINDFIRST THEN
                JobPlanningLine."Analytical concept" := DefaultDimension."Dimension Value Code";
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Contact (5050),"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 7207346, OnDeleteTContact, '', true, true)]
    LOCAL PROCEDURE OnDeleteTContact(Contact: Record 5050);
    VAR
        ContactActivitiesQB: Record 7207430;
    BEGIN
        ContactActivitiesQB.SETRANGE("Contact No.", Contact."No.");
        ContactActivitiesQB.DELETEALL;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Value Entry (5802),"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 5802, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeInsertEvent_TValueEntry(VAR Rec: Record 5802; RunTrigger: Boolean);
    BEGIN
        //GEN005-02
        Rec.VALIDATE("QB Outstanding Amount (JC)");
        Rec.VALIDATE("QB Outstanding Amount (ACY)");
    END;

    [EventSubscriber(ObjectType::Table, 5802, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeModifyEvent_TValueEntry(VAR Rec: Record 5802; VAR xRec: Record 5802; RunTrigger: Boolean);
    BEGIN
        //GEN005-02
        Rec.VALIDATE("QB Outstanding Amount (JC)");
        Rec.VALIDATE("QB Outstanding Amount (ACY)");
    END;

    [EventSubscriber(ObjectType::Table, 5802, OnAfterValidateEvent, "QB Outstanding Amount (JC)", true, true)]
    LOCAL PROCEDURE T5802_OnAfterValidateEvent_JobCurrencyAmount(VAR Rec: Record 5802; VAR xRec: Record 5802; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
        Job: Record 167;
    BEGIN
        //GEN005-02
        Rec."QB Outstanding Amount (JC)" := 0;
        Rec."QB Job Curr. Exch. Rate" := 0;
        IF Job.GET(Rec."Job No.") THEN BEGIN
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."Cost Amount (Actual)", '', Job."Currency Code", Rec."Posting Date", 2, AssignedAmount, CurrencyFactor);
            Rec."QB Outstanding Amount (JC)" := AssignedAmount;
            Rec."QB Job Curr. Exch. Rate" := CurrencyFactor;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 5802, OnAfterValidateEvent, "QB Outstanding Amount (ACY)", true, true)]
    LOCAL PROCEDURE T5802_OnAfterValidateEvent_AditionalCurrencyAmount(VAR Rec: Record 5802; VAR xRec: Record 5802; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
        Job: Record 167;
    BEGIN
        //GEN005-02
        Rec."QB Outstanding Amount (ACY)" := 0;
        Rec."QB Aditional Curr. Exch. Rate" := 0;
        IF Job.GET(Rec."Job No.") THEN BEGIN
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."Job No.", Rec."Cost Amount (Actual)", '', Job."Aditional Currency", Rec."Posting Date", 2, AssignedAmount, CurrencyFactor);
            Rec."QB Outstanding Amount (ACY)" := AssignedAmount;
            Rec."QB Aditional Curr. Exch. Rate" := CurrencyFactor;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Inventory Posting Setup (5813)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 5813, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertEvent_TInventoryPostingSetup(VAR Rec: Record 5813; RunTrigger: Boolean);
    VAR
        InventoryPostingSetup: Record 5813;
        Location: Record 14;
    BEGIN
        IF NOT RunTrigger THEN
            EXIT;

        //Si es de configuraci¢n, a¤adir el grupo en todos los almacenes
        IF (Rec."Location Code" = '') THEN BEGIN
            Location.RESET;
            Location.SETFILTER(Code, '<>%1', '');
            IF (Location.FINDSET) THEN
                REPEAT
                    InventoryPostingSetup := Rec;
                    InventoryPostingSetup."Location Code" := Location.Code;
                    IF NOT InventoryPostingSetup.INSERT(FALSE) THEN;
                UNTIL Location.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 5813, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterModifyEvent_TInventoryPostingSetup(VAR Rec: Record 5813; VAR xRec: Record 5813; RunTrigger: Boolean);
    VAR
        InventoryPostingSetup: Record 5813;
        Location: Record 14;
    BEGIN
        IF NOT RunTrigger THEN
            EXIT;

        //Si es de configuraci¢n, modificar el grupo en todos los almacenes
        IF (Rec."Location Code" = '') THEN BEGIN
            Location.RESET;
            Location.SETFILTER(Code, '<>%1', '');
            IF (Location.FINDSET) THEN
                REPEAT
                    InventoryPostingSetup := Rec;
                    InventoryPostingSetup."Location Code" := Location.Code;
                    IF NOT InventoryPostingSetup.MODIFY(FALSE) THEN
                        InventoryPostingSetup.INSERT(FALSE);
                UNTIL Location.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 5813, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeDeleteEvent_TInventoryPostingSetup(VAR Rec: Record 5813; RunTrigger: Boolean);
    VAR
        InventoryPostingSetup: Record 5813;
        txt01: TextConst ESP = 'No puede eliminar el grupo %1, lo usa el almac‚n %2';
    BEGIN
        IF NOT RunTrigger THEN
            EXIT;

        //Si es de configuraci¢n, no se puede eliminar un grupo de configuraci¢n que se utilice
        IF (Rec."Location Code" = '') THEN BEGIN
            InventoryPostingSetup.RESET;
            InventoryPostingSetup.SETFILTER("Location Code", '<>%1', '');
            InventoryPostingSetup.SETRANGE("Invt. Posting Group Code", Rec."Invt. Posting Group Code");
            IF (InventoryPostingSetup.FINDFIRST) THEN
                ERROR(txt01, Rec."Invt. Posting Group Code", InventoryPostingSetup."Location Code");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 5813, OnBeforeValidateEvent, "App. Account Concept Analytic", true, true)]
    LOCAL PROCEDURE OnValidateAppAccountAnalyticConcept_TInventoryPostingSetup(VAR Rec: Record 5813; VAR xRec: Record 5813; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            FunctionQB.ValidateCA(Rec."App. Account Concept Analytic");
    END;

    PROCEDURE OnLookupAppAccountAnalyticConcept_TInventoryPostingSetup(VAR InventoryPostingSetup: Record 5813);
    VAR
        FunctionQB: Codeunit 7207272;
        CA: Code[20];
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            CA := InventoryPostingSetup."App. Account Concept Analytic";
            IF FunctionQB.LookUpCA(CA, FALSE) THEN
                InventoryPostingSetup.VALIDATE("App. Account Concept Analytic", CA);
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------- Cartera Doc. (7000002)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7000002, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7000002_OnAfterModifyEvent(VAR Rec: Record 7000002; VAR xRec: Record 7000002; RunTrigger: Boolean);
    VAR
        BillGroup: Record 7000005;
        rPaymentMethod: Record 289;
        BoolConfirming: Boolean;
        Text50000: TextConst ENU = 'Error, the confirming remittance check must be checked to include document %1.', ESP = 'Error, debe estar marcado el check de remesa confirming para incluir el documento %1.';
        Text50001: TextConst ENU = 'Error, you can not include confirming documents in the remittance.', ESP = 'Error, no se puede incluir documentos no confirming en la remesa.';
    BEGIN
        //JAV 13/01/22: - QB 1.10.09 Gestion del confirming
        //Q5719. Se evita que se puedan incluir documentos con/sin confirming.

        IF (Rec.Type = Rec.Type::Receivable) AND (Rec."Bill Gr./Pmt. Order No." <> '') THEN BEGIN
            BoolConfirming := FALSE;
            IF rPaymentMethod.GET(Rec."Payment Method Code") THEN
                BoolConfirming := rPaymentMethod."QB Confirming Customer";

            IF (BillGroup.GET(Rec."Bill Gr./Pmt. Order No.")) AND
               (BillGroup."QB Bill Group Confirming") AND
               (NOT BoolConfirming) THEN
                ERROR(Text50001);

            IF (BillGroup.GET(Rec."Bill Gr./Pmt. Order No.")) AND
               (NOT BillGroup."QB Bill Group Confirming") AND
               (BoolConfirming) THEN
                ERROR(Text50000, Rec."Document No.");

        END;
    END;

    LOCAL PROCEDURE "----------------------------------------------- Marcar que se debe recalcular"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterInsertEvent, '', true, true)]
    PROCEDURE T7207386_OnAfterInsert(VAR Rec: Record 7207386; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec.GETFILTER("Budget Filter"));
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterModifyEvent, '', true, true)]
    PROCEDURE T7207386_OnAfterModify(VAR Rec: Record 7207386; VAR xRec: Record 7207386; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec.GETFILTER("Budget Filter"));
    END;

    [EventSubscriber(ObjectType::Table, 7207386, OnAfterDeleteEvent, '', true, true)]
    PROCEDURE T7207386_OnAfterDelete(VAR Rec: Record 7207386; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec.GETFILTER("Budget Filter"));
    END;

    [EventSubscriber(ObjectType::Table, 7207387, OnAfterInsertEvent, '', true, true)]
    PROCEDURE T7207387_OnAfterInsert(VAR Rec: Record 7207387; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Cod. Budget");
    END;

    [EventSubscriber(ObjectType::Table, 7207387, OnAfterModifyEvent, '', true, true)]
    PROCEDURE T7207387_OnAfterModify(VAR Rec: Record 7207387; VAR xRec: Record 7207387; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Cod. Budget");
    END;

    [EventSubscriber(ObjectType::Table, 7207387, OnAfterDeleteEvent, '', true, true)]
    PROCEDURE T7207387_OnAfterDelete(VAR Rec: Record 7207387; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Cod. Budget");
    END;

    [EventSubscriber(ObjectType::Table, 7207390, OnAfterInsertEvent, '', true, true)]
    PROCEDURE T7207390_OnAfterInsert(VAR Rec: Record 7207390; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Code Budget");
    END;

    [EventSubscriber(ObjectType::Table, 7207390, OnAfterModifyEvent, '', true, true)]
    PROCEDURE T7207390_OnAfterModify(VAR Rec: Record 7207390; VAR xRec: Record 7207390; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Code Budget");
    END;

    [EventSubscriber(ObjectType::Table, 7207390, OnAfterDeleteEvent, '', true, true)]
    PROCEDURE T7207390_OnAfterDelete(VAR Rec: Record 7207390; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Code Budget");
    END;

    [EventSubscriber(ObjectType::Table, 7207388, OnAfterInsertEvent, '', true, true)]
    PROCEDURE T7207388_OnAfterInsert(VAR Rec: Record 7207388; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Budget Code");
    END;

    [EventSubscriber(ObjectType::Table, 7207388, OnAfterModifyEvent, '', true, true)]
    PROCEDURE T7207388_OnAfterModify(VAR Rec: Record 7207388; VAR xRec: Record 7207388; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Budget Code");
    END;

    [EventSubscriber(ObjectType::Table, 7207388, OnAfterDeleteEvent, '', true, true)]
    PROCEDURE T7207388_OnAfterDelete(VAR Rec: Record 7207388; RunTrigger: Boolean);
    BEGIN
        //JAV 30/01/20: - Marcar que el proyecto debe recalcularse
        SetNeedRecalculate(Rec."Job No.", Rec."Budget Code");
    END;

    LOCAL PROCEDURE SetNeedRecalculate(pJob: Code[20]; pBudget: Code[20]);
    VAR
        JobBudget: Record 7207407;
        Job: Record 167;
    BEGIN
        //JAV 30/01/20: - Marcar que el Presupuesto o el proyecto debe recalcularse
        IF (JobBudget.GET(pJob, pBudget)) THEN BEGIN
            JobBudget."Pending Calculation Budget" := TRUE;
            JobBudget."Pending Calculation Analitical" := TRUE;
            JobBudget.MODIFY;
        END ELSE IF (Job.GET(pJob)) THEN BEGIN
            Job."Pending Calculation Budget" := TRUE;
            Job."Pending Calculation Analitical" := TRUE;
            Job.MODIFY;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------- T167 Jobs"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeInsertEvent_TJob(VAR Rec: Record 167; RunTrigger: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        NoSeriesManagement: Codeunit 396;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF (NOT RunTrigger) THEN
            EXIT;

        IF (NOT FunctionQB.AccessToQuobuilding) THEN
            EXIT;

        //Numeraci¢n de estudios y obras, si es de trabajo usar como base  el n£mero del padre
        IF Rec."Job Matrix - Work" = Rec."Job Matrix - Work"::Work THEN BEGIN
            CASE Rec."Card Type" OF
                Rec."Card Type"::"Proyecto operativo":
                    CreateAccountWorkTJob(Rec);
                Rec."Card Type"::Estudio:
                    CreateAccountVersionsTJob(Rec);
            END;
        END;

        //Numeraci¢n de estudios y obras, si no tiene n£mero lo buscamos
        TJob_AssignJobNo(Rec);        //JAV 01/12/21: - QB 1.10.04 Nueva forma de obtener los contadores seg�n la tabla de Clasificaci�n del proyecto

        CreateCATJob(Rec);
        CreateDimensionsPredetermined(Rec);
        LoadSetupAccount(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsert_TJob(VAR Rec: Record 167; RunTrigger: Boolean);
    VAR
        CLevelDefault: Code[20];
        QuoBuildingSetup: Record 7207278;
        InternalStatus: Record 7207440;
        FunctionQB: Codeunit 7207272;
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
        Txt001: TextConst ENU = 'You must inform the field "%1" in QuoBuilding Setup', ESP = 'Debe informar el campo "%1" en la configuraci�n de QuoBuilding';
        Alta: Boolean;
        Type: Option;
        QBJobResponsible: Record 7206992;
        QBApprovalManagement: Codeunit 7207354;
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        IF (NOT FunctionQB.AccessToQuobuilding) THEN
            EXIT;

        //JAV 23/08/19: - Informar del valor de la dimensi¢n departamento en el registro. Se cambian los nombres de las funciones que crean dimensiones de proyecto por unas mas adecuadas a lo que hacen

        QuoBuildingSetup.GET;

        IF (Rec."Card Type" IN [Rec."Card Type"::Estudio, Rec."Card Type"::"Proyecto operativo"]) THEN
            IF QuoBuildingSetup."Department Equal To Project" THEN
                CreateJobDepartmentDim(Rec);

        CASE Rec."Card Type" OF
            Rec."Card Type"::Estudio:
                CreateQuoteDefaultDim(Rec);
            Rec."Card Type"::"Proyecto operativo":
                CreateJobDefaultDim(Rec);
            Rec."Card Type"::Presupuesto:
                ; //No hay dimensiones por defecto para presupuestos
            Rec."Card Type"::Promocion:
                ; //No hay dimensiones por defecto para Real Estate
        END;

        //Valores iniciales del proyecto
        CreateLocation(Rec);

        CASE Rec."Card Type" OF
            Rec."Card Type"::Estudio, Rec."Card Type"::"Proyecto operativo":
                BEGIN
                    //JAV 27/10/20: - QB 1.07.00 Dar errores si faltan valores de configuraci�n necesarios
                    IF (QuoBuildingSetup."Initial Record Code" = '') THEN  //Expediente de venta
                        ERROR(Txt001, QuoBuildingSetup.FIELDCAPTION("Initial Record Code"));
                    IF (QuoBuildingSetup."Initial Budget Code" = '') THEN  //Presupuesto de coste
                        ERROR(Txt001, QuoBuildingSetup.FIELDCAPTION("Initial Budget Code"));

                    IF Rec."Job Type" = Rec."Job Type"::Operative THEN BEGIN
                        Rec."Management By Production Unit" := TRUE;
                        Rec."Mandatory Allocation Term By" := Rec."Mandatory Allocation Term By"::"Only Per Piecework";
                        Rec."Production Calculate Mode" := Rec."Production Calculate Mode"::"Production by Piecework";
                        Rec."% Margin" := QuoBuildingSetup."% Generic Margin Sale Piecewor";
                        //JMMA 15/04/19 cambio card type
                        //IF Rec.Status = Rec.Status::Open THEN
                        IF Rec."Card Type" = Rec."Card Type"::"Proyecto operativo" THEN
                            Rec."Initial Budget Piecework" := QuoBuildingSetup."Initial Budget Code";
                        CreateInitialBudget(Rec);
                    END ELSE BEGIN
                        Rec."Management By Production Unit" := FALSE;
                        Rec."Mandatory Allocation Term By" := Rec."Mandatory Allocation Term By"::"Not necessary";
                        IF Rec."Job Type" = Rec."Job Type"::Structure THEN
                            Rec."Production Calculate Mode" := Rec."Production Calculate Mode"::Free
                        ELSE
                            Rec."Production Calculate Mode" := Rec."Production Calculate Mode"::"Without Production";
                        Rec."% Margin" := 0;
                    END;
                END;
            Rec."Card Type"::Presupuesto,  //JAV 14/07/21: - QB 1.09.05 A�adimos la gesti�n de los presupuestos
            Rec."Card Type"::Promocion:   //JAV 17/11/21: - QB 1.10.00 A�adimos la gesti�n de Real Estate
                BEGIN
                    Rec."Starting Date" := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)); //Comienza este a�o por defecto
                    Rec."Management By Production Unit" := TRUE;
                    Rec."Mandatory Allocation Term By" := Rec."Mandatory Allocation Term By"::"Only Per Piecework";
                    Rec."Production Calculate Mode" := Rec."Production Calculate Mode"::"Production by Piecework";
                    Rec."Initial Budget Piecework" := FORMAT(DATE2DMY(WORKDATE, 3));
                    CreateInitialBudget(Rec);
                END;
        END;

        //JAV 06/02/20: - Activamos campos necesarios para QB en el alta del Proyecto
        Rec."Apply Usage Link" := TRUE; //Para que se gestiones sin usar tareas en proyectos

        //PGM 19/03/19 - Se a¤ade la acci¢n para cargar Mandatory Allocation Term By en los estudios
        IF Rec."Card Type" = Rec."Card Type"::Estudio THEN
            Rec."Mandatory Allocation Term By" := Rec."Mandatory Allocation Term By"::"Not necessary";

        //JMMA 15/04/19 CAMBIO CARD TYPE
        //IF Rec.Status = Rec.Status::Open THEN
        //IF Rec."Card Type" = Rec."Card Type"::"Proyecto operativo" THEN  //JAV 29/11/21: - QB 1.10.02 Se debe marcar para todos los proyectos que no sean del est�ndar
        IF Rec."Card Type" <> Rec."Card Type"::" " THEN
            Rec."Purcharse Shipment Provision" := TRUE;

        //JAV 06/02/20: - Alta de los responsables   - JAV 19/11/21: - QB 1.09.28 Ampliado para Grupos de responsables
        // IF (Rec."Card Type" <> Rec."Card Type"::" ") THEN BEGIN
        //  IF ((Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (Rec."Matrix Job it Belongs" = '')) OR (Rec."Original Quote Code" = '') THEN  //No si es una versi¢n del estudio
        //    CreateResponsiblesFromTemplate(0, Rec."No.");
        // END;
        IF ((Rec."Card Type" <> Rec."Card Type"::Estudio) OR (Rec."Original Quote Code" = '')) THEN BEGIN                         //No para una versi¢n del estudio
            Alta := TRUE;
            CASE Rec."Card Type" OF
                Rec."Card Type"::Estudio, Rec."Card Type"::"Proyecto operativo":
                    Type := 0;
                Rec."Card Type"::Presupuesto:
                    Type := 2;
                Rec."Card Type"::Promocion:
                    Type := 3;
            END;

            IF ((Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (Rec."Matrix Job it Belongs" <> '')) THEN BEGIN       //Los proyectos hijo lo pueden heredar del padre
                IF (CONFIRM('Desea heredar los responsables del proyecto padre (si no lo hace crear� nuevos responsables para el proyecto hijo)', TRUE)) THEN BEGIN
                    Alta := FALSE;
                    QBJobResponsible.CopyFrom(Type, Rec."Matrix Job it Belongs", Rec."No.");
                END;
            END;

            IF (Alta) THEN
                QBApprovalManagement.CreateResponsiblesFromTemplate(Type, Rec."No.", FALSE);
        END;

        //Si est  activo el filtro por centro de responsabilidad
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        IF UserRespCenter <> '' THEN
            Rec."Responsibility Center" := UserRespCenter;

        //-QCPM_GAP05
        InternalStatus.RESET;
        InternalStatus.SETCURRENTKEY(Usage, Order);
        InternalStatus.SETRANGE(Usage, Rec."Card Type");
        IF InternalStatus.FINDFIRST THEN
            Rec.VALIDATE("Internal Status", InternalStatus.Code);
        //+QCPM_GAP05

        //PGM 05/09/2019 >>
        IF Rec."Card Type" <> Rec."Card Type"::" " THEN
            Rec.Status := Rec.Status::Open;
        //PGM 05/09/2019 <<

        //JAV 12/10/20: - QB 1.06.20 Al crear un nuevo proyecto se informa la UO y el CA para ajustes de divisas desde la configuraci�n
        Rec."Adjust Exchange Rate Piecework" := QuoBuildingSetup."Adjust Exchange Rate Piecework";
        Rec."Adjust Exchange Rate A.C." := QuoBuildingSetup."Adjust Exchange Rate A.C.";

        //JAV 25/11/20: - QB 1.07.08 Al crear el proyecto poner el c�lculo del WIP por defecto
        Rec."Calculate WIP by periods" := QuoBuildingSetup."Calculate WIP by periods";

        //JAV 11/02/21: - QB 1.08.10 Nuevo campo para grupo registro por defecto en proyectos
        IF (QuoBuildingSetup."Default Job Posting Group" <> '') THEN
            Rec.VALIDATE("Job Posting Group", QuoBuildingSetup."Default Job Posting Group");

        Rec.MODIFY(FALSE);

        //JAV 25/09/20: - QB 1.06.15 Revisar las dimensiones del proyecto
        AdjustJobDimensions(Rec);
        Rec.MODIFY(FALSE);

        Rec.GET(Rec."No.");  //JAV 29/09/21: - QB 1.09.20 Vuelvo a leer el registro ya que se ha modificado y as� no hay problemas
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterModify_TJob(VAR Rec: Record 167; VAR xRec: Record 167; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec.Description <> xRec.Description) THEN
                ModifyJobDimValueName(Rec);
            ControlDepJobStructLocation(Rec, xRec);
        END;

        //JAV 25/09/20: - QB 1.06.15 Revisar las dimensiones del proyecto
        AdjustJobDimensions(Rec);

        Rec.MODIFY(FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeDelete_TJob(VAR Rec: Record 167; RunTrigger: Boolean);
    VAR
        Job2: Record 167;
        ResponsibilityCenter: Record 5714;
        UserSetupMgt: Codeunit 5700;
        Text022: TextConst ENU = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.', ESP = 'No puede borrar este documento. Su identificaci¢n est  configurada s¢lo para procesar %1 %2.';
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[10];
        Text035: TextConst ESP = 'No se puede eliminar una oferta que tiene definida versiones, elimine las versiones antes de continuar';
        Text000: TextConst ENU = 'You cannot change %1 because one or more entries are associated with this %2.', ESP = 'No puede cambiar el %1 porque hay uno o m s movimientos asociados con este %2.';
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            DeleteCATJob(Rec);
            FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
            IF NOT UserSetupMgt.CheckRespCenter(3, Rec."Responsibility Center") THEN
                ERROR(
                  Text022,
                  ResponsibilityCenter.TABLECAPTION, UserRespCenter);

            IF Rec."Job Matrix - Work" = Rec."Job Matrix - Work"::"Matrix Job" THEN BEGIN
                Job2.RESET;
                //JMMA 15/04/19 CAMBIO CARD TYPE Job2.SETRANGE(Status,Job2.Status::Planning);
                Job2.SETRANGE("Job Matrix - Work", Job2."Job Matrix - Work"::Work);
                Job2.SETRANGE("Original Quote Code", Rec."No.");
                IF Job2.FINDFIRST THEN
                    ERROR(Text035);
            END;
            //IF Rec.Status = Rec.Status::Order THEN
            //  ERROR(Text000); //QB Se elimina para dejar borrar
        END;

        Rec.MODIFY(FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterDelete_TJob(VAR Rec: Record 167; RunTrigger: Boolean);
    VAR
        QBText: Record 7206918;
        InventoryPostingSetup: Record 5813;
        DataPieceworkForProduction: Record 7207386;
        DataCostByPiecework: Record 7207387;
        ExpectedTimeUnitData: Record 7207388;
        TMPExpectedTimeUnitData: Record 7207389;
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        InvoiceMilestone: Record 7207331;
    BEGIN
        //JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
        IF (NOT RunTrigger) THEN
            EXIT;

        IF FunctionQB.AccessToQuobuilding THEN
            DeleteAssociated(Rec);

        //QB4443 >>
        QBText.RESET;
        QBText.SETRANGE(Table, QBText.Table::Job);
        QBText.SETFILTER(Key1, Rec."No.");
        QBText.DELETEALL;

        //JAV 07/04/19: - Se mejora el borrado del almac�n del proyecto
        //InventoryPostingSetup.RESET;
        //InventoryPostingSetup.SETRANGE("Location Code",Rec."No.");
        //IF InventoryPostingSetup.FINDSET THEN
        //  REPEAT
        //    InventoryPostingSetup.DELETE(TRUE);
        //  UNTIL InventoryPostingSetup.NEXT = 0;
        IF (Rec."Job Location" <> '') THEN BEGIN
            InventoryPostingSetup.RESET;
            InventoryPostingSetup.SETRANGE("Location Code", Rec."Job Location");
            InventoryPostingSetup.DELETEALL(TRUE);
        END;
        //Esto ya no deber­a hacerse en esta versi¢n, pero por si acaso
        IF (Rec."No." <> '') THEN BEGIN
            InventoryPostingSetup.RESET;
            InventoryPostingSetup.SETRANGE("Location Code", COPYSTR(Rec."No.", 1, MAXSTRLEN(InventoryPostingSetup."Location Code")));
            InventoryPostingSetup.DELETEALL(TRUE);
        END;
        //JAV 07/04/19 fin


        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", Rec."No.");
        IF DataPieceworkForProduction.FINDSET THEN
            REPEAT
                DataPieceworkForProduction.DELETE(TRUE);
            UNTIL DataPieceworkForProduction.NEXT = 0;

        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", Rec."No.");
        IF DataCostByPiecework.FINDSET THEN
            REPEAT
                DataCostByPiecework.DELETE(TRUE);
            UNTIL DataCostByPiecework.NEXT = 0;

        ExpectedTimeUnitData.RESET;
        ExpectedTimeUnitData.SETRANGE("Job No.", Rec."No.");
        IF ExpectedTimeUnitData.FINDSET THEN
            REPEAT
                ExpectedTimeUnitData.DELETE(TRUE);
            UNTIL ExpectedTimeUnitData.NEXT = 0;

        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETRANGE("Job No.", Rec."No.");
        IF TMPExpectedTimeUnitData.FINDSET THEN
            REPEAT
                TMPExpectedTimeUnitData.DELETE(TRUE);
            UNTIL TMPExpectedTimeUnitData.NEXT = 0;
        //QB4443 <<

        //JAV 23/08/19: - Si viene de un estudio, lo quitamos como generado en el mismo
        Job.RESET;
        Job.SETRANGE("Generated Job", Rec."No.");
        IF Job.FINDFIRST THEN BEGIN
            Job."Generated Job" := '';
            Job.MODIFY;
        END;

        //JAV 05/10/20: - QB 1.06.18 Borrar los hitos de facturaci�n asociados al eliminar el proyecto
        InvoiceMilestone.RESET;
        InvoiceMilestone.SETRANGE("Job No.", Rec."No.");
        InvoiceMilestone.DELETEALL;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeRenameEvent, '', true, true)]
    LOCAL PROCEDURE OnBeforeRename_TJob(VAR Rec: Record 167; VAR xRec: Record 167; RunTrigger: Boolean);
    VAR
        Txt001: TextConst ESP = 'No puede cambiar el c¢digo de este proyecto pues est  vac¡o, eliminelo.';
    BEGIN
        IF Rec."No." = '' THEN
            ERROR(Txt001);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterRenameEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterRename_TJob(VAR Rec: Record 167; VAR xRec: Record 167; RunTrigger: Boolean);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            RenameCA(Rec, xRec);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, Description, true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_Description_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DimensionValue: Record 349;
    BEGIN
        //JAV 01/04/20: - Si cambiamos el nombre del proyecto, cambiamos la descripci¢n del valor de dimensi¢n asociado
        DimensionValue.RESET;
        DimensionValue.SETRANGE(Code, Rec."No.");
        IF DimensionValue.FINDFIRST THEN BEGIN
            DimensionValue.Name := Rec.Description;
            DimensionValue.MODIFY;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Bill-to Customer No.", true, true)]
    LOCAL PROCEDURE OnBeforeValidateEvent_BillCustomerNo_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    BEGIN
        //JAV 22/10/20: - QB 1.07.00 Cambio el c�digo de los expedientres al despu�s y no al antes del validate
        //JAV 04/05/20: - QB 1.04  se permite el cambio del cliente si antes no lo ten¡a informado, para ello cambio el xRec y me salto el error
        IF (xRec."Bill-to Customer No." = '') THEN
            xRec."Bill-to Customer No." := Rec."Bill-to Customer No.";
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Bill-to Customer No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_BillCustomerNo_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        JobDefaultDimension: Record 352;
        DefaultDimension: Record 352;
        Dimension: Record 348;
        SalespersonPurchaser: Record 13;
        QuoBuildingSetup: Record 7207278;
        DimMgt: Codeunit 408;
        Records: Record 7207393;
        Customer: Record 18;
    BEGIN
        //JAV 22/10/20: - QB 1.07.00 Guardo el registro del proyecto antes de cambiar mas datos por el cliente
        //-Q19785
        //Rec.MODIFY(FALSE); Por que en ocasiones aun no se ha hecho el insert.
        IF Rec.MODIFY(FALSE) THEN;
        //+Q19785
        //JAV 22/05/20: - QB 1.04 Si cambia el cliente, cambiarlo en los expedientes de venta. Lo muevo desde el antes del validate
        IF (Rec."Bill-to Customer No." <> '') AND (Rec."Bill-to Customer No." <> xRec."Bill-to Customer No.") THEN BEGIN
            Records.RESET;
            Records.SETRANGE("Job No.", Rec."No.");
            IF (Rec."Multi-Client Job" = Rec."Multi-Client Job"::ByCustomers) THEN  //Si es multicliente, solo cambiamos cuando coincide con el cliente anterior
                Records.SETRANGE("Customer No.", xRec."Bill-to Customer No.");
            Records.MODIFYALL("Customer No.", Rec."Bill-to Customer No.");
        END;

        //QBA5412
        //JAV 11/06/19: - No podemos quitar las anteriores dimensiones del proyecto, sino a¤adir las del cliente
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Customer);
        DefaultDimension.SETRANGE("No.", Rec."Bill-to Customer No.");
        IF DefaultDimension.FINDSET THEN BEGIN
            REPEAT
                //JAV 25/09/20: - QB 1.06.15 Revisar las dimensiones del proyecto
                Dimension.GET(DefaultDimension."Dimension Code");
                IF (NOT Dimension."Not for Job") THEN BEGIN
                    JobDefaultDimension.INIT;
                    JobDefaultDimension.VALIDATE("Table ID", DATABASE::Job);
                    JobDefaultDimension.VALIDATE("No.", Rec."No.");
                    JobDefaultDimension.VALIDATE("Dimension Code", DefaultDimension."Dimension Code");
                    JobDefaultDimension.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                    JobDefaultDimension.VALIDATE("Value Posting", DefaultDimension."Value Posting");
                    IF JobDefaultDimension.INSERT(TRUE) THEN
                        JobDefaultDimension.MODIFY(TRUE);
                END;
            UNTIL DefaultDimension.NEXT = 0;
        END;

        //JAV 13/05/19: - Se crea la dimensi¢n del vendedor solo si est  as¡ configurado
        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Use Salesperson dimension" THEN BEGIN
            IF SalespersonPurchaser.GET(Rec."Income Statement Responsible") THEN BEGIN
                DefaultDimension.RESET;
                DefaultDimension.SETRANGE("Table ID", DATABASE::"Salesperson/Purchaser");
                DefaultDimension.SETRANGE("No.", SalespersonPurchaser.Code);
                IF DefaultDimension.FINDSET THEN BEGIN
                    REPEAT
                        //JAV 25/09/20: - QB 1.06.15 Revisar las dimensiones del proyecto
                        Dimension.GET(DefaultDimension."Dimension Code");
                        IF (NOT Dimension."Not for Job") THEN BEGIN
                            JobDefaultDimension.INIT;
                            JobDefaultDimension.VALIDATE("Table ID", DATABASE::Job);
                            JobDefaultDimension.VALIDATE("No.", Rec."No.");
                            JobDefaultDimension.VALIDATE("Dimension Code", DefaultDimension."Dimension Code");
                            JobDefaultDimension.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                            JobDefaultDimension.VALIDATE("Value Posting", DefaultDimension."Value Posting");
                            IF JobDefaultDimension.INSERT(TRUE) THEN
                                JobDefaultDimension.MODIFY(TRUE);
                        END;
                    UNTIL DefaultDimension.NEXT = 0;
                END;
            END;
        END;

        DimMgt.UpdateDefaultDim(DATABASE::Job, Rec."No.", Rec."Global Dimension 1 Code", Rec."Global Dimension 2 Code");

        //JAV 17/02/22: - QB 1.10.20 Al cargar el cliente, cargo el tipo de cliente a la vez
        IF Customer.GET(Rec."Bill-to Customer No.") THEN
            IF (Customer."QB Customer Type" <> '') THEN
                Rec."Customer Type" := Customer."QB Customer Type";


        //JAV 22/10/20: - QB 1.07.00 Guardo el registro del proyecto tras cambiar datos del cliente
        Rec.MODIFY(FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Bill-to Contact No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_BilltoContactNoTJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    BEGIN
        //QB5662

        IF (Rec."Bill-to Contact No." = '') AND (Rec."Bill-to Customer No." = '') THEN BEGIN
            Rec.VALIDATE("Card Type", xRec."Card Type");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Job Type", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_JobType_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Change: Boolean;
        Text006BIS: TextConst ENU = 'Will change job type% 1, Do you want to continue?', ESP = 'Va a cambiar el proyecto %1 de tipo, ¨Desea continuar?';
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF ((xRec."Job Type" = Rec."Job Type"::Deviations) OR
                (xRec."Job Type" = Rec."Job Type"::Structure)) THEN BEGIN
                IF Rec."Job Type" = Rec."Job Type"::Operative THEN BEGIN
                    Change := CONFIRM(STRSUBSTNO(Text006BIS, Rec."No."), TRUE);
                    IF NOT Change THEN BEGIN
                        Rec."Job Type" := xRec."Job Type";
                        EXIT;
                    END;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Management By Production Unit", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_ManagementByProductionUni_tTJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        JobTask: Record 1001;
        Text009BIS: TextConst ENU = 'You can not activate the Management Production Units field if there is a budget per item.', ESP = 'No se puede activar el campo Gesti¢n por unidades de producci¢n si existe presupuesto por item.';
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        // Control de que al seleccionar esta opci¢n no existan Tareas de proyecto
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF Rec."Management By Production Unit" THEN BEGIN
                JobTask.RESET;
                JobTask.SETRANGE("Job No.", Rec."No.");
                //JMMA eliminado para ROIG CYS, esto realmente no se usa en proyectos de QB por tanto se elimina para todos
                //IF JobTask.FINDFIRST THEN
                //  ERROR(Text009BIS);
                Rec."Production Calculate Mode" := Rec."Production Calculate Mode"::"Production by Piecework";
                QuoBuildingSetup.GET;
                Rec."% Margin" := QuoBuildingSetup."% Generic Margin Sale Piecewor";
                //JMMA 15/04/19 Cambio por campo card type
                //IF Rec.Status = Rec.Status::Open THEN
                IF Rec."Card Type" = Rec."Card Type"::"Proyecto operativo" THEN
                    Rec."Initial Budget Piecework" := QuoBuildingSetup."Initial Budget Code";
                CreateInitialBudget(Rec);
            END;
            IF NOT Rec."Management By Production Unit" THEN BEGIN
                Rec."Production Calculate Mode" := Rec."Production Calculate Mode"::Administration;
                Rec."% Margin" := 0;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Production Calculate Mode", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_ProductionCalculateMode_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Text012BIS: TextConst ENU = 'You can not select the "Production by Piecework" option if the "Management By Production Unit" field is not enabled', ESP = 'No se pede seleccionar la opci¢n "Producci¢n por UO" si el campo "Gesti¢n por unidad de Producci¢n" no est  activado.';
        Text013BIS: TextConst ENU = 'You can not select a production method other than "Production By Piecework" if the field "Management By Production Unit" is enabled.', ESP = 'No se puede seleccionar un m‚todo de producci¢n distinto de "Producci¢n por UO" si est  activado el campo "Gesti¢n por unidad de producci¢n".';
        FunctionQB: Codeunit 7207272;
    BEGIN
        // No se puede seleccionar "Prodcci¢n por UO" si no est  a TRUE el campo "Gesti¢n por UO"
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF (Rec."Management By Production Unit" = FALSE) AND
               (Rec."Production Calculate Mode" = Rec."Production Calculate Mode"::"Production by Piecework") THEN
                ERROR(Text012BIS);

            //ADMITIMOS TAMBIN TANTO ALZADO EN GESTIàN POR PRODUCCIàN
            //  IF (Rec."Management By Production Unit" = TRUE) AND
            //     (Rec."Production Calculate Mode" <> Rec."Production Calculate Mode"::"Production by Piecework") THEN
            //     ERROR(Text013BIS);
            IF (Rec."Management By Production Unit" = TRUE) AND
               ((Rec."Production Calculate Mode" <> Rec."Production Calculate Mode"::"Production by Piecework") AND
                (Rec."Production Calculate Mode" <> Rec."Production Calculate Mode"::"Lump Sums")) THEN
                ERROR(Text013BIS);

        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Latest Reestimation Code", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_LastestReestimationCode_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateReest(Rec."Latest Reestimation Code");
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Reestimation Filter", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_ReestimationFilter_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateReest(Rec."Reestimation Filter");
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Responsibility Center", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_ResponsabilityCenter_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        UserSetupManagement: Codeunit 5700;
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci¢n est  configurada para procesar s¢lo desde %1 %2.';
        ResponsibilityCenter: Record 5714;
        HasGotSalesUserSEtup: Boolean;
        UserRespCenter: Code[20];
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF NOT UserSetupManagement.CheckRespCenter(3, Rec."Responsibility Center") THEN
                FunctionQB.GetJobFilter(HasGotSalesUserSEtup, UserRespCenter);
            ERROR(Text027, ResponsibilityCenter.TABLECAPTION, UserRespCenter);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Mandatory Allocation Term By", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_MandatoryAllocationTermBy_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Text033: TextConst ENU = 'The job must have management per unit of production to True', ESP = 'El proyecto tiene que tener gesti¢n por unidad de producci¢n a True';
    BEGIN
        IF (NOT Rec."Management By Production Unit") AND (Rec."Mandatory Allocation Term By" <> Rec."Mandatory Allocation Term By"::"Not necessary") THEN
            ERROR(Text033);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Initial Reestimation Code", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_InitialReestimationCode_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        DimensionValue: Record 349;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF FunctionQB.LookUpReest(DimensionValue."Dimension Code", FALSE) THEN
                Rec.VALIDATE("Initial Reestimation Code", DimensionValue."Dimension Code");
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Low Coefficient", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_LowCoefficient_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DataPieceworkForProduction: Record 7207386;
        Jobredetermination: Record 7207437;
    BEGIN
        UpdateCoefficients(Rec, Jobredetermination, DataPieceworkForProduction);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Industrial Benefit", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_IndustrialBenefit_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Jobredetermination: Record 7207437;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        UpdateCoefficients(Rec, Jobredetermination, DataPieceworkForProduction);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "General Expenses / Other", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_GeneralExpensesOther_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Jobredetermination: Record 7207437;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        UpdateCoefficients(Rec, Jobredetermination, DataPieceworkForProduction);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Quality deduction", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_QualityDeduction_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Jobredetermination: Record 7207437;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        UpdateCoefficients(Rec, Jobredetermination, DataPieceworkForProduction);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Dimensions JV Code", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_DimensionJVCode_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.ValidateJV(Rec."Dimensions JV Code");
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Job P.C.", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_PCoftheJob_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        CodeCountry: Code[10];
        PostCode: Record 225;
    BEGIN
        CodeCountry := 'ES';
        PostCode.ValidatePostCode(Rec."Job City", Rec."Job P.C.", Rec."Job Province", CodeCountry, (CurrFieldNo <> 0) AND GUIALLOWED);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Use Unit Price Ratio", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_UserUnitPriceRatio_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Text000: TextConst ENU = 'In job/offers with use of unit price ratio it is not possible to select separation.', ESP = 'En proyectos/ofertas con uso de relaci¢n de precios unitarios no es posible seleccionar separaci¢n.';
    BEGIN
        IF Rec."Use Unit Price Ratio" THEN BEGIN
            IF Rec."Separation Job Unit/Cert. Unit" THEN BEGIN
                MESSAGE(Text000);
                Rec."Separation Job Unit/Cert. Unit" := FALSE;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "Offert Price", true, true)]
    LOCAL PROCEDURE OnBeforeValidate_OfferPrice_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DataPieceworkForProduction: Record 7207386;
        Jobredetermination: Record 7207437;
    BEGIN
        IF Rec."Offert Price" = Rec."Offert Price"::Normal THEN BEGIN
            Rec."Industrial Benefit" := 0;
            Rec."General Expenses / Other" := 0;
            Rec."Quality Deduction" := 0;
            Rec."Low Coefficient" := 0;
        END
        ELSE BEGIN
            Rec."% Margin" := 0;
        END;
        UpdateCoefficients(Rec, Jobredetermination, DataPieceworkForProduction);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Global Dimension 1 Code", true, true)]
    LOCAL PROCEDURE OnAfterValidate_GlobalDimension1_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DefaultDimension: Record 352;
        Location: Record 14;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
                DefaultDimension.RESET;
                DefaultDimension.SETRANGE(DefaultDimension."Table ID", DATABASE::Job);
                DefaultDimension.SETRANGE(DefaultDimension."No.", Rec."No.");
                DefaultDimension.SETRANGE(DefaultDimension."Dimension Value Code", Rec."Global Dimension 1 Code");
                IF DefaultDimension.FINDFIRST THEN BEGIN
                    DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
                    DefaultDimension.MODIFY;
                END;
                IF Rec."Job Location" = Rec."No." THEN BEGIN
                    IF Location.GET(Rec."No.") THEN BEGIN
                        Location."QB Departament Code" := Rec."Global Dimension 1 Code";
                        Location.MODIFY;
                    END;
                END;
            END;
            ControlDepJobStructLocation(Rec, xRec);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Global Dimension 1 Code", true, true)]
    LOCAL PROCEDURE OnAfterValidate_GlobalDimension2_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DefaultDimension: Record 352;
        Location: Record 14;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN BEGIN
                DefaultDimension.RESET;
                DefaultDimension.SETRANGE(DefaultDimension."Table ID", DATABASE::Job);
                DefaultDimension.SETRANGE(DefaultDimension."No.", Rec."No.");
                DefaultDimension.SETRANGE(DefaultDimension."Dimension Value Code", Rec."Global Dimension 2 Code");
                IF DefaultDimension.FINDFIRST THEN BEGIN
                    DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
                    DefaultDimension.MODIFY;
                END;
                IF Rec."Job Location" = Rec."No." THEN BEGIN
                    IF Location.GET(Rec."No.") THEN BEGIN
                        Location."QB Departament Code" := Rec."Global Dimension 2 Code";
                        Location.MODIFY;
                    END;
                END;
            END;
            ControlDepJobStructLocation(Rec, xRec);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Starting Date", true, true)]
    LOCAL PROCEDURE OnAfterValidate_StartingDateTJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    BEGIN
        CreateInitialBudget(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Ending Date", true, true)]
    LOCAL PROCEDURE TabJob_OnAfterValidate_EndingDateTJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    BEGIN
        //RE16067-LCG-281221-INI
        CreateInitialBudget(Rec);
        //RE16067-LCG-281221-FIN
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, "% Unforeseen", true, true)]
    LOCAL PROCEDURE OnBeforevalidate_PercentageUnforessen_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Currency: Record 4;
        LJobRedetermination: Record 7207437;
        Text000: TextConst ENU = 'The job has validated redeterminations and it is not possible to change the coefficients', ESP = 'El proyecto tiene redeterminaciones validadas y no es posible cambiar los coeficientes';
        LDataPieceworkForProduction: Record 7207386;
    BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision;

        LJobRedetermination.SETRANGE("Job No.", Rec."No.");
        LJobRedetermination.SETRANGE(Validated, TRUE);
        IF LJobRedetermination.FINDFIRST THEN
            ERROR(Text000);

        LDataPieceworkForProduction.SETRANGE("Job No.", Rec."No.");
        LDataPieceworkForProduction.SETRANGE("Customer Certification Unit", TRUE);
        LDataPieceworkForProduction.SETRANGE("Account Type", LDataPieceworkForProduction."Account Type"::Unit);
        IF LDataPieceworkForProduction.FINDFIRST THEN
            REPEAT
                LDataPieceworkForProduction."Unit Price Sale (base)" := ROUND((LDataPieceworkForProduction."Contract Price" *
                                                                        (1 + (Rec."General Expenses / Other" / 100) + (Rec."Industrial Benefit" / 100)) *
                                                                        (1 - (Rec."Low Coefficient" / 100)) *
                                                                        (1 - (Rec."Quality Deduction" / 100)))
                                                              , Currency."Unit-Amount Rounding Precision");
                LDataPieceworkForProduction.VALIDATE("Unit Price Sale (base)");
                LDataPieceworkForProduction.MODIFY(TRUE);
            UNTIL LDataPieceworkForProduction.NEXT = 0;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Job Posting Group", true, true)]
    LOCAL PROCEDURE OnAfterValidate_JobPostingGroup_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        vJob: Record 167;
    BEGIN
        //JAV 22/02/20: - Se a¤ade el evento OnValidateJobPostingGroupTJob, cuando se cambia el grupo lo cambia en todas las versiones
        IF (Rec."Job Posting Group" <> xRec."Job Posting Group") AND (Rec."Job Posting Group" <> '') THEN BEGIN
            vJob.RESET;
            vJob.SETRANGE("Original Quote Code", Rec."No.");
            vJob.MODIFYALL("Job Posting Group", Rec."Job Posting Group");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnBeforeValidateEvent, Status, true, true)]
    LOCAL PROCEDURE OnBeforeValidate_Status_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Text001: TextConst ENU = 'The Withholding Return Date''s Field must be filled.', ESP = 'El campo Fecha devoluci¢n retenci¢n debe estar relleno.';
    BEGIN
        //PGM 22/07/19: -GAP009 KALAM Control para que Estado no pueda pasar a completado si el periodo devoluci¢n retenci¢n no est  relleno.
        //IF Rec."Withholding Return Period" = 0d THEN
        //  ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Currency Code", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CurrencyCode_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
    BEGIN
        //JAV Si ha cambiado la divisa, se cambia en los proyectos hijos o las versiones
        IF (Rec."Currency Code" <> xRec."Currency Code") THEN BEGIN
            Job.RESET;
            IF (Rec."Card Type" = Rec."Card Type"::Estudio) AND (Rec."Original Quote Code" = '') THEN BEGIN
                Job.SETRANGE("Original Quote Code", Rec."No.");
                Job.MODIFYALL("Currency Code", Rec."Currency Code");
            END;
            IF (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (Rec."Matrix Job it Belongs" = '') THEN BEGIN
                Job.SETRANGE("Matrix Job it Belongs", Rec."No.");
                Job.MODIFYALL("Currency Code", Rec."Currency Code");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Aditional Currency", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_AditionalCurrency_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
    BEGIN
        //JAV Si ha cambiado la divisa adicional, se cambia en los proyectos hijos o las versiones
        IF (Rec."Aditional Currency" <> xRec."Aditional Currency") THEN BEGIN
            Job.RESET;
            IF (Rec."Card Type" = Rec."Card Type"::Estudio) AND (Rec."Original Quote Code" = '') THEN BEGIN
                Job.SETRANGE("Original Quote Code", Rec."No.");
                Job.MODIFYALL("Aditional Currency", Rec."Aditional Currency");
            END;
            IF (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (Rec."Matrix Job it Belongs" = '') THEN BEGIN
                Job.SETRANGE("Matrix Job it Belongs", Rec."No.");
                Job.MODIFYALL("Aditional Currency", Rec."Aditional Currency");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "General Currencies", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_GeneralCurrencies_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
    BEGIN
        //JAV Si ha cambiado la fecha de la divisa, se cambia en los proyectos hijos o las versiones
        IF (Rec."General Currencies" <> xRec."General Currencies") THEN BEGIN
            Job.RESET;
            IF (Rec."Card Type" = Rec."Card Type"::Estudio) AND (Rec."Original Quote Code" = '') THEN BEGIN
                Job.SETRANGE("Original Quote Code", Rec."No.");
                Job.MODIFYALL("General Currencies", Rec."General Currencies");
            END;
            IF (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (Rec."Matrix Job it Belongs" = '') THEN BEGIN
                Job.SETRANGE("Matrix Job it Belongs", Rec."No.");
                Job.MODIFYALL("General Currencies", Rec."General Currencies");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Currency Value Date", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CurrencyValueDate_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
    BEGIN
        //GEN003-02
        Rec.VALIDATE("Assigned Amount (LCY)");
        Rec.VALIDATE("Assigned Amount (ACY)");

        //JAV Si ha cambiado la fecha de la divisa, se cambia en los proyectos hijos o las versiones
        IF (Rec."Currency Value Date" <> xRec."Currency Value Date") THEN BEGIN
            Job.RESET;
            IF (Rec."Card Type" = Rec."Card Type"::Estudio) AND (Rec."Original Quote Code" = '') THEN BEGIN
                Job.SETRANGE("Original Quote Code", Rec."No.");
                Job.MODIFYALL("Currency Value Date", Rec."Currency Value Date");
            END;
            IF (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (Rec."Matrix Job it Belongs" = '') THEN BEGIN
                Job.SETRANGE("Matrix Job it Belongs", Rec."No.");
                Job.MODIFYALL("Currency Value Date", Rec."Currency Value Date");
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Assigned Amount", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_AssignedAmount_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        //GEN003-02 JAV este evento faltaba
        Rec.VALIDATE("Assigned Amount (LCY)");
        Rec.VALIDATE("Assigned Amount (ACY)");
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Assigned Amount (LCY)", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_AssignedAmountLCY_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
    BEGIN
        //GEN003-02
        JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."No.", Rec."Assigned Amount", Rec."Currency Code", '', Rec."Currency Value Date", 1, AssignedAmount, CurrencyFactor);
        Rec."Assigned Amount (LCY)" := AssignedAmount;
        Rec."Currency Factor (LCY)" := CurrencyFactor;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Assigned Amount (ACY)", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_AssignedAmountACY_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        AssignedAmount: Decimal;
        CurrencyFactor: Decimal;
    BEGIN
        //GEN003-02
        IF (Rec."Aditional Currency" = '') THEN BEGIN
            Rec."Assigned Amount (ACY)" := 0;
            Rec."Currency Factor (ACY)" := 0;
        END ELSE BEGIN
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."No.", Rec."Assigned Amount", Rec."Currency Code", Rec."Aditional Currency", Rec."Currency Value Date", 1, AssignedAmount, CurrencyFactor);
            Rec."Assigned Amount (ACY)" := AssignedAmount;
            Rec."Currency Factor (ACY)" := CurrencyFactor;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Planned K", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_PlannedK_TJob(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        DataPieceworkForProduction: Record 7207386;
        Text001: TextConst ESP = 'Si modifica la K se recalcular�n todos los precios de venta, �realmente desea modificarla?';
        Window: Dialog;
        Text002: TextConst ESP = 'Procesando #1###################';
    BEGIN
        IF NOT CONFIRM(Text001, FALSE) THEN
            ERROR('')
        ELSE BEGIN
            Rec.MODIFY; //Guardar la K en la ficha
                        //Q8163
            Window.OPEN(Text002);
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", Rec."No.");
            DataPieceworkForProduction.SETRANGE("Passing K", 0);      //No tocar las que tengan una K manual
            IF DataPieceworkForProduction.FINDSET THEN
                REPEAT
                    Window.UPDATE(1, DataPieceworkForProduction."Piecework Code");
                    DataPieceworkForProduction.VALIDATE("Passing K", 0);
                    DataPieceworkForProduction.MODIFY;
                UNTIL DataPieceworkForProduction.NEXT = 0;
            Window.CLOSE;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterChangeJobCompletionStatus, '', true, true)]
    LOCAL PROCEDURE TJob_OnAfterChangeJobCompletionStatus(VAR Job: Record 167; VAR xJob: Record 167);
    VAR
        Text001: TextConst ENU = 'The real construction ending date is not assigned, it will procced to assing the system date.', ESP = 'La fecha real de cierre de la obra no est  asignada, se va a proceder a asignarle %1';
        Text002: TextConst ENU = 'The Real construction ending date is %1.', ESP = 'La fecha final de obra real se establer� a  %1.';
        FunctionQB: Codeunit 7207272;
        ok: Boolean;
    BEGIN
        IF (FunctionQB.AccessToQuobuilding) THEN BEGIN
            IF Job."End Real Construction Date" = 0D THEN BEGIN
                ok := TRUE;
                MESSAGE(Text001, WORKDATE);
            END ELSE
                ok := DIALOG.CONFIRM(Text002, FALSE, WORKDATE);

            IF (ok) THEN BEGIN
                Job."End Real Construction Date" := WORKDATE;
                Job.MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------- Jobs (167) funciones p£blicas que no son eventos"();
    BEGIN
    END;

    PROCEDURE ChangeGenericCustomer_TJob(VAR Job: Record 167);
    VAR
        ListofQuoteVersions: Page 7207362;
        Job2: Record 167;
        Opportunity: Record 5092;
        Confirmation: Boolean;
        InternalStatus: Record 7207440;
        CustRecold: Record 18;
        CustomerList: Page 22;
        CustRec: Record 18;
        JobRec: Record 167;
        TextQX001: TextConst ENU = 'Do you want to change de Customer No. for this study and also for the versions?', ESP = '¨Quiere cambiar el N§ de Cliente del estudio y de todas sus versiones?';
        TextQX002: TextConst ENU = 'The quote has already been accepted.', ESP = 'La oferta ya ha sido aceptada.';
        TextQX003: TextConst ENU = 'There is already a job generated for this quote.', ESP = 'Ya existe un proyecto generado para esta oferta.';
        NoSalesPerson: Code[20];
    BEGIN
        //QX7105 >>
        IF CONFIRM(TextQX001, FALSE) THEN BEGIN
            IF Job."Quote Status" = Job."Quote Status"::Accepted THEN
                ERROR(TextQX002);
            IF Job."Generated Job" <> '' THEN
                ERROR(TextQX003);
            CustRec.RESET;
            CustomerList.SETTABLEVIEW(CustRec);
            CustomerList.LOOKUPMODE(TRUE);
            IF CustomerList.RUNMODAL <> ACTION::LookupOK THEN
                EXIT;
            //CustomerList.GETRECORD(CustRec);
            CustomerList.SETSELECTIONFILTER(CustRec);
            CLEAR(CustomerList);
            IF NOT CustRec.FINDFIRST THEN
                EXIT;

            //Job.VALIDATE("Bill-to Customer No.",CustRec."No."); //Con esta linea da error, se hace en 3 partes, Modify-Validate-Modify
            Job."Bill-to Customer No." := CustRec."No.";
            NoSalesPerson := Job."Income Statement Responsible";
            Job.MODIFY;
            Job.VALIDATE("Bill-to Customer No.");
            IF NoSalesPerson <> '' THEN
                Job."Income Statement Responsible" := NoSalesPerson;
            Job.MODIFY;
            //COMMIT;
            //MODIFY;
            JobRec.RESET;
            JobRec.SETRANGE("Original Quote Code", Job."No.");
            IF JobRec.FINDSET THEN
                REPEAT
                    //JobRec.VALIDATE("Bill-to Customer No.",CustRec."No."); //Con esta linea da error, se hace en 3 partes, Modify-Validate-Modify
                    JobRec."Bill-to Customer No." := CustRec."No.";
                    NoSalesPerson := JobRec."Income Statement Responsible";
                    JobRec.MODIFY;
                    JobRec.VALIDATE("Bill-to Customer No.");
                    IF NoSalesPerson <> '' THEN
                        JobRec."Income Statement Responsible" := NoSalesPerson;
                    JobRec.MODIFY;
                UNTIL JobRec.NEXT = 0;

            //COMMIT;
            //CurrPage.UPDATE;
            //COMMIT;
        END;
        //QX7105 <<
    END;

    PROCEDURE CreateJobDefaultDim(VAR Rec: Record 167);
    VAR
        DefaultDim: Record 352;
        JobsSetup: Record 315;
        DimensionValue: Record 349;
        QuoBuildingSetup: Record 7207278;
        value: Code[20];
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 23/08/19: - Se cambian los nombres de las funciones que crean dimensiones de proyecto por unas mas adecuadas a lo que hacen
        //5526
        QuoBuildingSetup.GET();
        QuoBuildingSetup.TESTFIELD("Dimension for Jobs Code");
        QuoBuildingSetup.TESTFIELD("Dimension for Dpto Code");

        //JAV 23/08/19: - Se informa de la dimensi¢n departamento si es diferente a la de proyecto, seg£n sea operativo o de estructura
        QuoBuildingSetup.GET();
        IF (Rec."Job Type" = Rec."Job Type"::Operative) THEN
            value := QuoBuildingSetup."Value dimension for job"
        ELSE
            value := QuoBuildingSetup."Value dimension for structure";

        IF (NOT QuoBuildingSetup."Department Equal To Project") AND (value <> '') THEN BEGIN
            CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) OF
                1:
                    Rec.VALIDATE("Global Dimension 1 Code", value);
                2:
                    Rec.VALIDATE("Global Dimension 2 Code", value);
                ELSE BEGIN
                    IF DefaultDim.GET(DATABASE::Job, Rec."No.", QuoBuildingSetup."Dimension for Dpto Code") THEN
                        DefaultDim.DELETE;

                    DefaultDim.INIT;
                    DefaultDim.VALIDATE("Table ID", DATABASE::Job);
                    DefaultDim.VALIDATE("No.", Rec."No.");
                    DefaultDim.VALIDATE("Dimension Code", QuoBuildingSetup."Dimension for Dpto Code");
                    DefaultDim.VALIDATE("Dimension Value Code", value);
                    DefaultDim.VALIDATE("Value Posting", DefaultDim."Value Posting"::"Same Code");
                    DefaultDim.INSERT;
                END;
            END;
        END;

        //JAV 10/02/21: QB 1.08.08 La dimensi¢n CA es obligatoria en los proyectos, siempre que no se salte esto por configuraci�n
        IF (QuoBuildingSetup."Not  AC obligatory in jobs" = FALSE) THEN BEGIN
            DefaultDim.INIT;
            DefaultDim.VALIDATE("Table ID", DATABASE::Job);
            DefaultDim.VALIDATE("No.", Rec."No.");
            DefaultDim.VALIDATE("Dimension Code", FunctionQB.ReturnDimCA);
            DefaultDim.VALIDATE("Dimension Value Code", '');
            DefaultDim.VALIDATE("Value Posting", DefaultDim."Value Posting"::"Code Mandatory");
            IF NOT DefaultDim.INSERT THEN
                DefaultDim.MODIFY;
        END;

        //Dimensi¢n Estudio: Si tiene una por defecto la informa si no hay ninguna establecida
        IF (QuoBuildingSetup."Dim. Default Value for Quote" <> '') THEN BEGIN
            IF DefaultDim.GET(DATABASE::Job, Rec."No.", FunctionQB.ReturnDimQuote) THEN
                DefaultDim.DELETE;
            DefaultDim.INIT;
            DefaultDim.VALIDATE("Table ID", DATABASE::Job);
            DefaultDim.VALIDATE("No.", Rec."No.");
            DefaultDim.VALIDATE("Dimension Code", FunctionQB.ReturnDimQuote);
            DefaultDim.VALIDATE("Dimension Value Code", QuoBuildingSetup."Dim. Default Value for Quote");
            DefaultDim.VALIDATE("Value Posting", DefaultDim."Value Posting"::"Same Code");
            DefaultDim.INSERT;
        END;
    END;

    PROCEDURE LookupCustomerFromJob(pJob: Code[20]; pCustomer: Code[20]; VAR pReturn: Code[20]): Boolean;
    VAR
        Job: Record 167;
        Records: Record 7207393;
        QBJobCustomers: Record 7207272;
        Customer: Record 18;
        CustomerList: Page 22;
        Filtro: Text;
        Txt001: TextConst ENU = 'The project only has one client', ESP = 'El proyecto solo tiene un cliente';
    BEGIN
        //Realiza un lookup de los clientes relacionados con el proyecto
        Job.GET(pJob);
        CASE Job."Multi-Client Job" OF
            Job."Multi-Client Job"::No:
                BEGIN
                    MESSAGE(Txt001);
                    pReturn := Job."Bill-to Customer No.";
                    EXIT(TRUE);
                END;
            Job."Multi-Client Job"::ByCustomers:
                BEGIN
                    Filtro := Job."Bill-to Customer No." + '|';   //A¤adimos el principal siempre
                    Records.RESET;
                    Records.SETRANGE("Job No.", pJob);
                    IF Records.FINDSET THEN
                        REPEAT
                            IF (STRPOS(Filtro, Records."Customer No.") = 0) THEN
                                Filtro += Records."Customer No." + '|';
                        UNTIL Records.NEXT = 0;
                END;
            Job."Multi-Client Job"::ByPercentages:
                BEGIN
                    Filtro := Job."Bill-to Customer No." + '|';   //A¤adimos el principal siempre
                    QBJobCustomers.RESET;
                    QBJobCustomers.SETRANGE("Job no.", pJob);
                    IF QBJobCustomers.FINDSET THEN
                        REPEAT
                            IF (STRPOS(Filtro, QBJobCustomers."Customer No.") = 0) THEN
                                Filtro += QBJobCustomers."Customer No." + '|';
                        UNTIL QBJobCustomers.NEXT = 0;
                END;
        END;

        Filtro := DELCHR(Filtro, '>', '|');

        Customer.RESET;
        Customer.FILTERGROUP(2);
        Customer.SETFILTER("No.", Filtro);
        Customer.FILTERGROUP(0);

        CLEAR(CustomerList);
        CustomerList.LOOKUPMODE(TRUE);
        CustomerList.SETTABLEVIEW(Customer);
        IF (pCustomer = '') THEN
            Customer.GET(Job."Bill-to Customer No.")
        ELSE
            Customer.GET(pCustomer);
        CustomerList.SETRECORD(Customer);

        IF CustomerList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            CustomerList.GETRECORD(Customer);
            pReturn := Customer."No.";
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    PROCEDURE ValidateCustomerFromJob(pJob: Code[20]; pCustomer: Code[20]): Boolean;
    VAR
        Job: Record 167;
        Records: Record 7207393;
        QBJobCustomers: Record 7207272;
        Customer: Record 18;
        CustomerList: Page 22;
        Filtro: Text;
    BEGIN
        //Verifica que el cliente est� entre los relacionados con el proyecto
        Job.GET(pJob);
        IF (pCustomer = Job."Bill-to Customer No.") THEN
            EXIT(TRUE);

        CASE Job."Multi-Client Job" OF
            Job."Multi-Client Job"::No:
                EXIT(FALSE);
            Job."Multi-Client Job"::ByCustomers:
                BEGIN
                    Records.RESET;
                    Records.SETRANGE("Job No.", pJob);
                    Records.SETRANGE("Customer No.", pCustomer);
                    EXIT(NOT Records.ISEMPTY);
                END;
            Job."Multi-Client Job"::ByPercentages:
                BEGIN
                    QBJobCustomers.RESET;
                    QBJobCustomers.SETRANGE("Job no.", pJob);
                    QBJobCustomers.SETRANGE("Customer No.", pCustomer);
                    EXIT(NOT QBJobCustomers.ISEMPTY);
                END;
        END;

        EXIT(FALSE);
    END;

    PROCEDURE TJob_OnLookupReestimationFilter(VAR Job: Record 167);
    VAR
        FunctionQB: Codeunit 7207272;
        ReestimationCode: Code[20];
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF FunctionQB.LookUpReest(ReestimationCode, FALSE) THEN
                Job.VALIDATE("Reestimation Filter", ReestimationCode);
    END;

    PROCEDURE TJob_OnLookupLastestReestimationCode(VAR Job: Record 167);
    VAR
        FunctionQB: Codeunit 7207272;
        ReestimationCode: Code[20];
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF FunctionQB.LookUpReest(ReestimationCode, FALSE) THEN
                Job.VALIDATE("Latest Reestimation Code", ReestimationCode);
    END;

    PROCEDURE TJob_OnLookupInitialReestimationCode(VAR Job: Record 167);
    VAR
        FunctionQB: Codeunit 7207272;
        ReestimationCode: Code[20];
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF FunctionQB.LookUpReest(ReestimationCode, FALSE) THEN
                Job.VALIDATE("Initial Reestimation Code", ReestimationCode);
    END;

    PROCEDURE TJob_OnLookupDimensionsJVCode(VAR Job: Record 167);
    VAR
        FunctionQB: Codeunit 7207272;
        CodeJV: Code[20];
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN
            IF FunctionQB.LookUpJV(CodeJV, FALSE) THEN
                Job.VALIDATE("Dimensions JV Code", CodeJV)
    END;

    PROCEDURE TJob_OnLookupAcceptedVersionNo(VAR Rec: Record 167);
    VAR
        job: Record 167;
        FunctionQB: Codeunit 7207272;
        ListofQuoteVersions: Page 7207362;
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            job.RESET;
            job.SETRANGE("Original Quote Code", Rec."No.");  //Busco todas las versiones del estudio

            CLEAR(ListofQuoteVersions);
            ListofQuoteVersions.SETTABLEVIEW(job);
            ListofQuoteVersions.EDITABLE(FALSE);
            ListofQuoteVersions.LOOKUPMODE(TRUE);
            IF ListofQuoteVersions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ListofQuoteVersions.GETRECORD(job);
                Rec.VALIDATE("Accepted Version No.", job."No.");
            END;
        END;
    END;

    PROCEDURE TJob_CalcPorcAmountsWQty(Job: Record 167; Amount: Decimal; VAR AmountGE: Decimal; VAR AmountIB: Decimal; VAR AmountLow: Decimal; VAR AmountQD: Decimal);
    VAR
        Currency: Record 4;
    BEGIN
        //JAV 30/10/21: - QB 1.09.26 Retorna los importes de GG/BI/Baja/Calidad de un proyecto sobre un importe dado
        Currency.InitRoundingPrecision;
        AmountGE := ROUND((Amount) * Job."General Expenses / Other" / 100, Currency."Unit-Amount Rounding Precision");
        AmountIB := ROUND((Amount) * Job."Industrial Benefit" / 100, Currency."Unit-Amount Rounding Precision");
        AmountLow := ROUND((Amount + AmountGE + AmountIB) * Job."Low Coefficient" / 100, Currency."Unit-Amount Rounding Precision");
        AmountQD := ROUND((Amount + AmountGE + AmountIB - AmountLow) * Job."Quality Deduction" / 100, Currency."Unit-Amount Rounding Precision");
    END;

    PROCEDURE TJob_CalcPorcAmounts(Job: Record 167; Amount: Decimal; VAR AmountGE: Decimal; VAR AmountIB: Decimal; VAR AmountLow: Decimal);
    VAR
        Void: Decimal;
    BEGIN
        //JAV 30/10/21: - QB 1.09.26 Retorna los importes de GG/BI/Baja de un proyecto sobre un importe dado
        TJob_CalcPorcAmountsWQty(Job, Amount, AmountGE, AmountIB, AmountLow, Void);
    END;

    PROCEDURE TJob_ControlRespCenter(Job: Record 167);
    VAR
        UserSetup: Codeunit 5700;
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci¢n est  configurada para procesar s¢lo desde %1 %2.';
        RespCenter: Record 5714;
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[10];
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF NOT UserSetup.CheckRespCenter(3, Job."Responsibility Center") THEN BEGIN
            FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
            ERROR(Text027, RespCenter.TABLECAPTION, UserRespCenter);
        END;
    END;

    PROCEDURE TJob_CalMarginRealized(Job: Record 167; VAR Amount: Decimal; VAR Perc: Decimal);
    BEGIN
        Job.CALCFIELDS("Invoiced Price (LCY)", "Usage (Cost) (LCY)");
        Amount := Job."Invoiced Price (LCY)" - Job."Usage (Cost) (LCY)";
        IF (Job."Invoiced Price (LCY)" <> 0) THEN
            Perc := (Job."Invoiced Price (LCY)" - Job."Usage (Cost) (LCY)") / (Job."Invoiced Price (LCY)") * 100
        ELSE
            Perc := 0;
    END;

    PROCEDURE TJob_ProductionTheoricalProcess(Job: Record 167): Decimal;
    VAR
        DataPieceworkForProduction: Record 7207386;
        Amount: Decimal;
    BEGIN
        Amount := 0;
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"));
        DataPieceworkForProduction.SETFILTER("Filter Date", Job.GETFILTER("Posting Date Filter"));
        DataPieceworkForProduction.SETFILTER("Filter Analytical Concept", Job.GETFILTER("Analytic Concept Filter"));
        DataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        IF DataPieceworkForProduction.FINDSET(FALSE) THEN BEGIN
            REPEAT
                DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                Amount += DataPieceworkForProduction."Amount Production Budget";
            UNTIL DataPieceworkForProduction.NEXT = 0;
        END;
        EXIT(Amount);
    END;

    PROCEDURE TJob_ProductionBudgetWithoutProcess(Job: Record 167): Decimal;
    VAR
        DataPieceworkForProduction: Record 7207386;
        Amount: Decimal;
    BEGIN
        Amount := 0;
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETFILTER("Budget Filter", Job.GETFILTER(Job."Budget Filter"));
        DataPieceworkForProduction.SETFILTER("Filter Date", Job.GETFILTER(Job."Posting Date Filter"));
        DataPieceworkForProduction.SETFILTER("Filter Analytical Concept", Job.GETFILTER(Job."Analytic Concept Filter"));
        DataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        IF DataPieceworkForProduction.FINDSET(FALSE) THEN BEGIN
            REPEAT
                DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                Amount += DataPieceworkForProduction."Amount Production Budget";
            UNTIL DataPieceworkForProduction.NEXT = 0;
        END;
        EXIT(Amount);
    END;

    PROCEDURE TJob_Accept(VAR Job: Record 167);
    VAR
        Text000: TextConst ENU = 'The quote has already been accepted.', ESP = 'La oferta ya ha sido aceptada.';
        Text001: TextConst ENU = 'A rejected quote can not be accepted, to accept it must be pending.', ESP = 'Una oferta rechazada no puede aceptarse, para aceptarla debe estar en estado pendiente.';
        ListofQuoteVersions: Page 7207362;
        Job2: Record 167;
        Opportunity: Record 5092;
        Text002: TextConst ENU = 'You will accept this Study. Once accepted, you can not refuse or return to the previous situation. Are you sure?', ESP = 'Va a aceptar este Estudio, en la siguiente pantalla debe seleccionar la versi¢n aprobada. ¨Est  seguro?';
        InternalsStatus: Record 7207440;
        CustRec: Record 18;
        Text010: TextConst ENU = 'You will accept the presented %1 version of this Study. Are you sure?', ESP = 'Va a aceptar la versi¢n presentada %1 de este Estudio. ¨Est  seguro?';
        Text011: TextConst ENU = 'You will accept the only version %1 of this Study. Are you sure?', ESP = 'Va a aceptar la £nica versi¢n %1 de este Estudio. ¨Est  seguro?';
        Text012: TextConst ENU = 'You cannot accept an offer with the generic customer.', ESP = 'No puede aceptar una oferta con el cliente gen‚rico.';
        Text013: TextConst ENU = 'You have not created any version, you cannot accept the study.', ESP = 'No ha creado ninguna versi¢n, no puede aceptar el estudio.';
        ApprovalJobs: Codeunit 7206919;
        Confirmation: Boolean;
    BEGIN
        //JAV 19/09/19: - Se modifica la funci¢n AcceptTJob
        //                - Primero se mira si es posible hacerlo antes de preguntar si se desea hacerlo
        //                - Al aceptar, aunque no se seleccionara versi¢n se pasaba la oportunidad a ganada y el estado a finalizado
        //                - Se hace que si solo hay una versi¢n o ya hay una versi¢n presentada, no pregunte cual se aprueba

        CASE Job."Quote Status" OF
            Job."Quote Status"::Accepted:
                ERROR(Text000);
            Job."Quote Status"::Rejected:
                ERROR(Text001);
        END;

        //QX7105 >>
        CustRec.GET(Job."Bill-to Customer No.");
        IF (CustRec."QB Generic Customer") THEN
            ERROR(Text012);
        //QX7105 <<

        IF (Job."Presented Version" <> '') THEN BEGIN
            Job2.GET(Job."Presented Version");
            Confirmation := CONFIRM(Text010, TRUE, Job."Presented Version");
        END ELSE BEGIN
            Job2.RESET;
            Job2.SETRANGE("Original Quote Code", Job."No.");
            IF (Job2.ISEMPTY) THEN
                ERROR(Text013)
            ELSE IF (Job2.COUNT = 1) THEN BEGIN
                Job2.FINDFIRST;
                Confirmation := CONFIRM(Text011, TRUE, Job2."No.");
            END ELSE BEGIN
                CLEAR(ListofQuoteVersions);
                ListofQuoteVersions.SETTABLEVIEW(Job2);
                ListofQuoteVersions.LOOKUPMODE(TRUE);
                IF ListofQuoteVersions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ListofQuoteVersions.GETRECORD(Job2);
                    Confirmation := TRUE;
                END ELSE
                    Confirmation := FALSE;
            END;
        END;

        IF Confirmation THEN BEGIN
            //Verificar que est� aprobado
            //  ApprovalJobs.VerifyApprovalStatus(Job2);

            //Actualizar el proyecto
            Job.VALIDATE(Job."Quote Status", Job2."Quote Status"::Accepted);
            Job."Approved/Refused By" := USERID;
            Job.VALIDATE("Accepted Version No.", Job2."No.");

            //-QCPM_GAP05
            Job."Old Internal Status" := Job."Internal Status";
            InternalsStatus.RESET;
            InternalsStatus.SETCURRENTKEY(Order);
            InternalsStatus.SETRANGE(Usage, Job."Card Type");
            IF InternalsStatus.FINDLAST THEN
                Job.VALIDATE("Internal Status", InternalsStatus.Code);
            //+QCPM_GAP05

            Job.MODIFY;

            //Actualizar oportunidad
            IF Job."Opportunity Code" <> '' THEN BEGIN
                Opportunity.GET(Job."Opportunity Code");
                Opportunity.VALIDATE(Status, Opportunity.Status::Won);
                Opportunity.MODIFY(TRUE);
            END;

        END;
    END;

    PROCEDURE TJob_Reject(VAR Job: Record 167);
    VAR
        Text000: TextConst ENU = 'The quote has already been rejected.', ESP = 'La oferta ya ha sido rechazada.';
        Text001: TextConst ENU = 'An accepted quote can not be rejected, to reject it must be in pending status.', ESP = 'Una oferta aceptada no puede rechazarse, para rechazarla debe estar en estado pendiente.';
        Opportunity: Record 5092;
        QuotesRejected: Page 7207367;
        InternalsStatus: Record 7207440;
    BEGIN
        //JAV 19/09/19: - En la funci¢n RejectTJob
        //                - Aunque se cancelara se pasaba la oportunidad a perdida y el estado a finalizado
        //                - En la page auxiliar donde se establece el motivo, se hace que sea lookup para que quede mas claro aceptar o rechazar

        CASE Job."Quote Status" OF
            Job."Quote Status"::Rejected:
                ERROR(Text000);
            Job."Quote Status"::Accepted:
                ERROR(Text001);
        END;

        CLEAR(QuotesRejected);
        QuotesRejected.GetQuote(Job);
        QuotesRejected.LOOKUPMODE(TRUE);
        IF QuotesRejected.RUNMODAL = ACTION::LookupOK THEN BEGIN
            //Actualizar el estudio
            QuotesRejected.SetRejected(Job);

            //-QCPM_GAP05
            Job."Old Internal Status" := Job."Internal Status";
            InternalsStatus.RESET;
            InternalsStatus.SETCURRENTKEY(Order);
            InternalsStatus.SETRANGE(Usage, Job."Card Type");
            IF InternalsStatus.FINDLAST THEN
                Job.VALIDATE("Internal Status", InternalsStatus.Code);
            Job.MODIFY;
            //+QCPM_GAP05

            //Actualizar oportunidad
            IF Job."Opportunity Code" <> '' THEN BEGIN
                Opportunity.GET(Job."Opportunity Code");
                Opportunity.VALIDATE(Status, Opportunity.Status::Lost);
                Opportunity.MODIFY(TRUE);
            END;

        END;
    END;

    PROCEDURE TJob_Reopen(VAR Job: Record 167);
    VAR
        Text000: TextConst ENU = 'The quote is already pending.', ESP = 'La oferta esta ya en estado pendiente.';
        Text001: TextConst ENU = 'Are you sure you want to revert to the pending status of quote %1?', ESP = '¨Esta seguro de que desea volver a dejar en estado pendiente la oferta %1?';
        Opportunity: Record 5092;
    BEGIN
        //JAV 19/09/19: - En la funci¢n ReopenTJob no se cambiaba la oportunidad

        IF Job."Quote Status" = Job."Quote Status"::Pending THEN
            ERROR(Text000);

        IF CONFIRM(Text001, TRUE, Job."No.") THEN BEGIN

            Job."Quote Status" := Job."Quote Status"::Pending;
            Job."Approved/Refused By" := '';
            Job."Rejection Reason" := '';
            Job.Observations := '';
            Job."Generated Job" := '';
            Job."Accepted Version No." := '';
            Job."Internal Status" := Job."Old Internal Status";
            Job.MODIFY(TRUE);

            //Actualizar oportunidad
            IF Job."Opportunity Code" <> '' THEN BEGIN
                Opportunity.GET(Job."Opportunity Code");
                Opportunity.VALIDATE(Status, Opportunity.Status::"In Progress");
                Opportunity.MODIFY(TRUE);
            END;

        END;
    END;

    PROCEDURE TJob_CreateJob(VAR Job: Record 167);
    VAR
        // GenerateQuotes: Report 7207292;
        CustRec: Record 18;
        Err001: TextConst ESP = 'No puede crear un proyecto usando el cliente gen‚rico';
        Version: Record 167;
    BEGIN
        //QX7105 >>
        CustRec.GET(Job."Bill-to Customer No.");
        IF (CustRec."QB Generic Customer") THEN
            ERROR(Err001);
        //QX7105 <<

        //JAV 22/09/19: - Se cambia el uso de Job para que no cambie el registro seleccionado
        Version.RESET;
        Version.SETRANGE("No.", Job."Accepted Version No.");

        // CLEAR(GenerateQuotes);
        // GenerateQuotes.SetParam(Job."Accepted Version No.", '');
        // GenerateQuotes.VersionJob(FALSE);
        // GenerateQuotes.USEREQUESTPAGE(TRUE);
        // GenerateQuotes.SETTABLEVIEW(Version);
        // GenerateQuotes.RUNMODAL;

        //JAV 22/09/19: - No cambiar el usuairo que la aprob¢/rechaz¢, no tiene sentido cambiarlo otra vez
        //Job."Approved/Refused By" := USERID;
        // Job.VALIDATE("Generated Job", GenerateQuotes.GetJobGenerate);
    END;

    LOCAL PROCEDURE "--------------------------------------------- Jobs (167) funciones locales"();
    BEGIN
    END;

    LOCAL PROCEDURE CreateQuoteDefaultDim(VAR Rec: Record 167);
    VAR
        DefaultDim: Record 352;
        JobsSetup: Record 315;
        DimensionValue: Record 349;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Value: Code[20];
    BEGIN
        //JAV 23/08/19: - Se cambian los nombres de las funciones que crean dimensiones de proyecto por unas mas adecuadas a lo que hacen
        //5526
        QuoBuildingSetup.GET();
        QuoBuildingSetup.TESTFIELD("Dimension for Jobs Code");
        QuoBuildingSetup.TESTFIELD("Dimension for Dpto Code");

        //JAV 23/08/19: - Se informa de la dimensi¢n departamento si es diferente a la de proyecto
        Value := QuoBuildingSetup."Value dimension for quote";

        //++
        IF (NOT QuoBuildingSetup."Department Equal To Project") AND (Value <> '') THEN BEGIN
            CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) OF
                1:
                    Rec.VALIDATE("Global Dimension 1 Code", Value);
                2:
                    Rec.VALIDATE("Global Dimension 2 Code", Value);
                ELSE BEGIN
                    IF DefaultDim.GET(DATABASE::Job, Rec."No.", QuoBuildingSetup."Dimension for Dpto Code") THEN
                        DefaultDim.DELETE;

                    DefaultDim.INIT;
                    DefaultDim.VALIDATE("Table ID", DATABASE::Job);
                    DefaultDim.VALIDATE("No.", Rec."No.");
                    DefaultDim.VALIDATE("Dimension Code", QuoBuildingSetup."Dimension for Dpto Code");
                    DefaultDim.VALIDATE("Dimension Value Code", Value);
                    DefaultDim.VALIDATE("Value Posting", DefaultDim."Value Posting"::"Same Code");
                    DefaultDim.INSERT;
                END;
            END;
        END;

        //Dimensi¢n proyecto: Si tiene una por defecto la informa si no hay ninguna establecida
        IF (QuoBuildingSetup."Dim. Default Value for Job" <> '') THEN BEGIN
            IF DefaultDim.GET(DATABASE::Job, Rec."No.", QuoBuildingSetup."Dimension for Jobs Code") THEN
                DefaultDim.DELETE;

            DefaultDim.INIT;
            DefaultDim.VALIDATE("Table ID", DATABASE::Job);
            DefaultDim.VALIDATE("No.", Rec."No.");
            DefaultDim.VALIDATE("Dimension Code", QuoBuildingSetup."Dimension for Jobs Code");
            DefaultDim.VALIDATE("Dimension Value Code", QuoBuildingSetup."Dim. Default Value for Job");
            DefaultDim.VALIDATE("Value Posting", DefaultDim."Value Posting"::"Same Code");
            DefaultDim.INSERT;
        END;
    END;

    LOCAL PROCEDURE CreateCATJob(VAR Job: Record 167);
    VAR
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        DimValue: Code[20];
    BEGIN
        //Crear el valor de dimensi¢n asociado al proyecto
        CASE Job."Card Type" OF
            Job."Card Type"::"Proyecto operativo":
                DimValue := FunctionQB.ReturnDimJobs;
            Job."Card Type"::Estudio:
                DimValue := FunctionQB.ReturnDimQuote;
            Job."Card Type"::Presupuesto:
                DimValue := FunctionQB.ReturnDimBudget;  //JAV 14/07/21: - QB 1.09.05 Nuevo tratamiento para presupuestos
            Job."Card Type"::Promocion:
                DimValue := FunctionQB.ReturnDimRE;      //JAV 17/11/21: - QB 1.10.00 Nuevo tratamiento para Real Estate
        END;
        DimensionValue."Dimension Code" := DimValue;
        DimensionValue.Code := Job."No.";
        DimensionValue.Name := Job.Description;
        DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
        IF NOT DimensionValue.INSERT(TRUE) THEN
            DimensionValue.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE DeleteCATJob(VAR Job: Record 167);
    VAR
        DimValue: Record 349;
        FunctionQB: Codeunit 7207272;
        DimValueV: Code[20];
    BEGIN
        //Borrar dimensiones asociadas al proyecto
        CASE Job."Card Type" OF
            Job."Card Type"::"Proyecto operativo":
                DimValueV := FunctionQB.ReturnDimJobs;
            Job."Card Type"::Estudio:
                DimValueV := FunctionQB.ReturnDimQuote;
            Job."Card Type"::Presupuesto:
                DimValueV := FunctionQB.ReturnDimBudget;  //JAV 14/07/21: - QB 1.09.05 Nuevo tratamiento para presupuestos
            Job."Card Type"::Promocion:
                DimValueV := FunctionQB.ReturnDimRE;      //JAV 17/11/21: - QB 1.10.00 Nuevo tratamiento para Real Estate
        END;

        IF (DimValue.GET(DimValueV, Job."No.")) THEN
            DimValue.DELETE;
    END;

    LOCAL PROCEDURE CreateDimensionsPredetermined(VAR Job: Record 167);
    VAR
        DefaultDim: Record 352;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //Crear el registro de la dimensi¢n predeterminada asociado al proyecto
        DefaultDim.INIT;
        DefaultDim."Table ID" := DATABASE::Job;
        DefaultDim."No." := Job."No.";
        CASE Job."Card Type" OF
            Job."Card Type"::"Proyecto operativo":
                DefaultDim."Dimension Code" := FunctionQB.ReturnDimJobs;
            Job."Card Type"::Estudio:
                DefaultDim."Dimension Code" := FunctionQB.ReturnDimQuote;
            Job."Card Type"::Presupuesto:
                DefaultDim."Dimension Code" := FunctionQB.ReturnDimBudget;  //JAV 14/07/21: - QB 1.09.05 Nuevo tratamiento para presupuestos
            Job."Card Type"::Promocion:
                DefaultDim."Dimension Code" := FunctionQB.ReturnDimRE;      //JAV 17/11/21: - QB 1.10.00 Nuevo tratamiento para Real Estate
        END;
        DefaultDim."Dimension Value Code" := Job."No.";

        //QBV101<<
        DefaultDim."Value Posting" := DefaultDim."Value Posting"::"Same Code";

        IF NOT DefaultDim.INSERT(TRUE) THEN
            DefaultDim.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE AdjustJobDimensions(Rec: Record 167);
    VAR
        Dimension: Record 348;
        DefaultDimension: Record 352;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 25/09/20: - QB 1.06.15 Revisar las dimensiones del proyecto
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", Rec."No.");
        IF DefaultDimension.FINDSET(TRUE) THEN BEGIN
            REPEAT
                //JAV 05/03/21 Si no encuentra la dimensi�n, elimina el registro para evitar errores posteriores
                IF NOT Dimension.GET(DefaultDimension."Dimension Code") THEN
                    DefaultDimension.DELETE
                ELSE IF (Dimension."Not for Job") THEN
                    DefaultDimension.DELETE;
            UNTIL DefaultDimension.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE LoadSetupAccount(VAR Job: Record 167);
    VAR
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //Informar en el proyecto del presupuesto contable y la vista de an lisis

        QuoBuildingSetup.GET;

        //JAV 05/05/21: - QB 1.08.41 Mejora en el campo Card Type
        CASE Job."Card Type" OF
            Job."Card Type"::Estudio:
                BEGIN
                    QuoBuildingSetup.TESTFIELD("Analysis View for Quotes");
                    Job."Job Analysis View Code" := QuoBuildingSetup."Analysis View for Quotes";
                    //Job."Jobs Budget Code" := FunctionQB.ReturnBudgetQuote; //JAV 28/06/21: - QB 1.09.03 Ya no se usa el campo "Jobs Budget Code" en su lugar se llama a FunctionQB.ReturnBudgetJobs o a FunctionQB.ReturnBudgetQuote
                END;
            Job."Card Type"::"Proyecto operativo":
                BEGIN
                    QuoBuildingSetup.TESTFIELD("Analysis View for Job");
                    Job."Job Analysis View Code" := QuoBuildingSetup."Analysis View for Job";
                    //Job."Jobs Budget Code" := FunctionQB.ReturnBudgetJobs; //JAV 28/06/21: - QB 1.09.03 Ya no se usa el campo "Jobs Budget Code" en su lugar se llama a FunctionQB.ReturnBudgetJobs o a FunctionQB.ReturnBudgetQuote
                END;
            Job."Card Type"::Presupuesto,  //JAV 14/07/21: - QB 1.09.05 Nuevo tratamiento para presupuestos, en este caso es opcional la vista de an�lisis
            Job."Card Type"::Promocion:   //JAV 17/11/21: - QB 1.10.00 Nuevo tratamiento para REAL ESTATE, en este caso es opcional la vista de an�lisis
                BEGIN
                    IF (QuoBuildingSetup."Analysis View for Job" <> '') THEN
                        Job."Job Analysis View Code" := QuoBuildingSetup."Analysis View for Job";
                END;
        END;
    END;

    LOCAL PROCEDURE ModifyJobDimValueName(VAR Job: Record 167);
    VAR
        DimValue: Record 349;
        FunctionQB: Codeunit 7207272;
        DimValueV: Code[20];
    BEGIN
        //JMMA 15/04/19: - Se modifica la descripci¢n del valor de dimensi¢n asociada cuando cambia el estudio o proyecto operativo
        //JAV  14/09/20: - QB 1.06.12 El IF estaba mal para estudios, se cambia y se a�ade un exit si no es estudio ni proyecto
        CASE Job."Card Type" OF
            Job."Card Type"::"Proyecto operativo":
                DimValueV := FunctionQB.ReturnDimJobs;
            Job."Card Type"::Estudio:
                DimValueV := FunctionQB.ReturnDimQuote;
            ELSE
                EXIT;
        END;

        IF (DimValue.GET(DimValueV, Job."No.")) THEN BEGIN
            DimValue.Name := Job.Description;
            DimValue.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE ControlDepJobStructLocation(VAR Job: Record 167; xJob: Record 167);
    VAR
        DimValue: Record 349;
        FunctionQB: Codeunit 7207272;
        Text032: TextConst ENU = 'Can not modify the Dept., it is being used in Job  Location structure %1', ESP = 'No se puede modificar el Dpto., esta siendo utilizado como Proyecto de estructura de almac�n en el proyecto %1';
    BEGIN
        IF Job."Job Type" <> Job."Job Type"::Structure THEN
            EXIT;

        //JAV 22/10/21: - QB 1.09.22 Se elimina c�digo duplicado
        IF ((FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1) AND (Job."Global Dimension 1 Code" <> xJob."Global Dimension 1 Code")) OR
           ((FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2) AND (Job."Global Dimension 2 Code" <> xJob."Global Dimension 2 Code")) THEN BEGIN
            DimValue.RESET;
            DimValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimDpto);
            IF DimValue.FINDSET(TRUE) THEN
                REPEAT
                    IF DimValue."Job Structure Warehouse" = Job."No."
                      THEN
                        ERROR(Text032, DimValue.Code);
                UNTIL DimValue.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE DeleteAssociated(VAR Job: Record 167);
    VAR
        InvoiceMilestone: Record 7207331;
        GLBudgetName: Record 95;
        GLBudgetEntry: Record 96;
        DataPieceworkForProduction: Record 7207386;
        DataPieceworkForProduction2: Record 7207386;
        Job1: Record 167;
        Job2: Record 167;
        MeasureLinePieceworkCertif: Record 7207343;
        FunctionQB: Codeunit 7207272;
        DeleteBudget: Boolean;
        Location: Record 14;
        DimValue: Record 349;
        JobBudget: Record 7207407;
        QBJobResponsible: Record 7206992;
    BEGIN
        IF Job.Status = Job.Status::Completed THEN BEGIN
            InvoiceMilestone.RESET;
            InvoiceMilestone.SETRANGE("Job No.", Job."No.");
            InvoiceMilestone.DELETEALL(TRUE);
            GLBudgetName.RESET;
            GLBudgetName.SETRANGE(Name, FunctionQB.ReturnBudgetJobs);
            IF NOT GLBudgetName.FINDFIRST THEN
                CLEAR(GLBudgetName);
            GLBudgetEntry.RESET;
            GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudgetJobs);
            DeleteBudget := FALSE;
            IF GLBudgetName."Budget Dimension 1 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF GLBudgetName."Budget Dimension 2 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 2 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF GLBudgetName."Budget Dimension 3 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 3 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF GLBudgetName."Budget Dimension 4 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 4 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF DeleteBudget THEN
                GLBudgetEntry.DELETEALL(TRUE);
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
            DataPieceworkForProduction.SETRANGE("Piecework Code", Job."Piecework Filter");
            //DataPieceworkForProduction.DELETEALL(TRUE); pgm
            DataPieceworkForProduction.DELETEALL;
            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETRANGE("Job No.", Job."No.");
            //DataPieceworkForProduction2.DELETEALL(TRUE); pgm
            DataPieceworkForProduction2.DELETEALL;
            IF Job."Original Quote Code" <> '' THEN BEGIN
                IF Job1.GET(Job."Original Quote Code") THEN BEGIN
                    IF Job2.GET(Job1."Original Quote Code") THEN BEGIN
                        Job2."Generated Job" := '';
                        Job2.MODIFY;
                    END;
                END;
            END;
            MeasureLinePieceworkCertif.SETRANGE("Job No.", Job."No.");
            MeasureLinePieceworkCertif.DELETEALL;
        END;
        //jmma 15/04/19 cambio card type

        //IF Job.Status = Job.Status::Planning THEN BEGIN
        IF Job."Card Type" = Job."Card Type"::Estudio THEN BEGIN
            InvoiceMilestone.RESET;
            InvoiceMilestone.SETRANGE("Job No.", Job."No.");
            InvoiceMilestone.DELETEALL(TRUE);
            GLBudgetName.RESET;
            GLBudgetName.SETRANGE(Name, FunctionQB.ReturnBudgetQuote);
            IF NOT GLBudgetName.FINDFIRST THEN
                CLEAR(GLBudgetName);
            GLBudgetEntry.RESET;
            GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudgetQuote);
            DeleteBudget := FALSE;
            IF GLBudgetName."Budget Dimension 1 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF GLBudgetName."Budget Dimension 2 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 2 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF GLBudgetName."Budget Dimension 3 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 3 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF GLBudgetName."Budget Dimension 1 Code" = FunctionQB.ReturnDimQuote THEN BEGIN
                GLBudgetEntry.SETRANGE("Budget Dimension 4 Code", Job."No.");
                DeleteBudget := TRUE;
            END;
            IF DeleteBudget THEN
                GLBudgetEntry.DELETEALL(TRUE);
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
            //DataPieceworkForProduction.DELETEALL(TRUE);
            DataPieceworkForProduction.DELETEALL;
            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETRANGE("Job No.", Job."No.");
            //DataPieceworkForProduction2.DELETEALL(TRUE);
            DataPieceworkForProduction2.DELETEALL;
            IF Job."Original Quote Code" <> '' THEN BEGIN
                IF Job1.GET(Job."Original Quote Code") THEN BEGIN
                    IF Job2.GET(Job1."Original Quote Code") THEN BEGIN
                        Job2."Generated Job" := '';
                        Job2.MODIFY;
                    END;
                END;
            END;
            MeasureLinePieceworkCertif.SETRANGE("Job No.", Job."No.");
            MeasureLinePieceworkCertif.DELETEALL;
        END;

        //JAV 26/03/19: - Se mejora el borrado del almac�n del proyecto
        //Location.RESET;
        //IF Location.GET(Job."No.") THEN
        //  Location.DELETE(TRUE);
        IF (Job."Job Location" <> '') THEN
            IF Location.GET(Job."Job Location") THEN
                Location.DELETE(TRUE);
        //Esto ya no deber¡a hacerse en esta versi¢n, pero por si acaso
        IF Location.GET(COPYSTR(Job."No.", 1, MAXSTRLEN(Location.Code))) THEN
            Location.DELETE(TRUE);
        //JAV fin

        DimValue.RESET;
        DimValue.SETRANGE(DimValue."Dimension Code", FunctionQB.ReturnDimDpto);
        DimValue.SETRANGE(DimValue.Code, Job."No.");
        IF DimValue.FINDFIRST THEN
            DimValue.DELETE(TRUE);

        IF DeleteBudget = TRUE THEN BEGIN
            JobBudget.RESET;
            JobBudget.SETRANGE("Job No.", Job."No.");
            JobBudget.DELETEALL(TRUE);
        END;

        //JAV 08/04/19: - Se mejora el borrado de proyectos, no eliminaba usuarios
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);    //JAV 23/10/20 - QB 1.07.00 Se a�ade que es para proyectos
        QBJobResponsible.SETRANGE("Table Code", Job."No.");
        QBJobResponsible.DELETEALL;

        //JAV 16/05/22: - QRE 1.00.15 Se elimnan tambi�n los usuarios de las partidas por si existen al eliminar un proyecto
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Piecework);
        QBJobResponsible.SETRANGE("Table Code", Job."No.");
        QBJobResponsible.DELETEALL;
    END;

    LOCAL PROCEDURE RenameCA(VAR Rec: Record 167; xRec: Record 167);
    VAR
        VDimensionValue: Code[20];
        FunctionQB: Codeunit 7207272;
        DimensionValue: Record 349;
    BEGIN
        //Esta funci¢n va a renombrar la clave ppal del proyecto[variables G: recDimValue,varDimValue,FunctionQB]
        //jmma 15/04/19 cambio card type
        //IF Rec.Status = Rec.Status::Open THEN
        //  VDimensionValue := FunctionQB.ReturnDimJobs;
        //IF Rec.Status = Rec.Status::Planning THEN
        //  VDimensionValue := FunctionQB.ReturnDimQuote;

        IF Rec."Card Type" = Rec."Card Type"::"Proyecto operativo" THEN
            VDimensionValue := FunctionQB.ReturnDimJobs;
        IF Rec."Card Type" = Rec."Card Type"::Estudio THEN
            VDimensionValue := FunctionQB.ReturnDimQuote;


        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", VDimensionValue);
        DimensionValue.SETRANGE(Code, xRec."No.");
        IF DimensionValue.FINDFIRST THEN
            DimensionValue.RENAME(VDimensionValue, Rec."No.");
    END;

    LOCAL PROCEDURE UpdateCoefficients(VAR Rec: Record 167; Jobredetermination: Record 7207437; DataPieceworkForProduction: Record 7207386);
    VAR
        Text7022600: TextConst ENU = 'The job has validated redeterminations and it is not possible to change the coefficients.', ESP = 'El proyecto tiene redeterminaciones validadas y no es posible cambiar los coeficienes.';
        Currency: Record 4;
        UnitPriceSaleBase: Decimal;
        Amount1: Decimal;
        Amount2: Decimal;
        Amount3: Decimal;
        TotalAmount: Decimal;
        CurrUnitAMountRoundingPrec: Decimal;
    BEGIN
        Currency.InitRoundingPrecision;

        Jobredetermination.SETRANGE("Job No.", Rec."No.");
        Jobredetermination.SETRANGE(Validated, TRUE);
        IF Jobredetermination.FINDFIRST THEN
            ERROR(Text7022600);
        //JMMA
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", Rec."No.");
        DataPieceworkForProduction.SETRANGE("Customer Certification Unit", TRUE);
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        IF DataPieceworkForProduction.FINDSET THEN
            //-QB2817
            /*{---
                    REPEAT
                      DataPieceworkForProduction."Unit Price Sale (base)" := ROUND((DataPieceworkForProduction."Contract Price" *
                                                                                   (1 + (Rec."General Expenses / Other" / 100) + (Rec."Industrial Benefit" / 100)) *
                                                                                   (1 - (Rec."Low Coefficient" / 100)) *
                                                                                   (1 + (Rec."Quality Deduction" / 100))),
                                                                                   Currency."Unit-Amount Rounding Precision");//JMMA SE CAMBIA EL SIGNO DE QUALITY DEDUCTION
                      DataPieceworkForProduction.VALIDATE("Unit Price Sale (base)");
                      DataPieceworkForProduction.MODIFY(TRUE);
                    UNTIL DataPieceworkForProduction.NEXT = 0;
                    ---}*/

        DataPieceworkForProduction.FINDSET;

        Amount1 := (1 + (Rec."General Expenses / Other" / 100) + (Rec."Industrial Benefit" / 100));
        Amount2 := (1 - (Rec."Low Coefficient" / 100));
        Amount3 := (1 + (Rec."Quality Deduction" / 100)); //JMMA SE CAMBIA EL SIGNO DE QUALITY DEDUCTION
        TotalAmount := Amount1 * Amount2 * Amount3;
        CurrUnitAMountRoundingPrec := Currency."Unit-Amount Rounding Precision";

        REPEAT
            UnitPriceSaleBase := 0;
            UnitPriceSaleBase := ROUND((DataPieceworkForProduction."Contract Price" * TotalAmount), CurrUnitAMountRoundingPrec);
            IF UnitPriceSaleBase <> DataPieceworkForProduction."Unit Price Sale (base)" THEN BEGIN
                DataPieceworkForProduction.VALIDATE("Unit Price Sale (base)", UnitPriceSaleBase);
                DataPieceworkForProduction.MODIFY(TRUE);
            END;
        UNTIL DataPieceworkForProduction.NEXT = 0;
        //+QB2817
    END;

    LOCAL PROCEDURE GetWarehouseFromJob(CJob: Code[20]): Code[20];
    VAR
        Job: Record 167;
    BEGIN
        CLEAR(Job);
        IF Job.GET(CJob) THEN
            EXIT(Job."Job Location")
        ELSE
            EXIT('');
    END;

    LOCAL PROCEDURE CreateJobDepartmentDim(VAR Job: Record 167);
    VAR
        QuoBuildingSetup: Record 7207278;
        DimValue: Record 349;
        DefaultDim: Record 352;
        FunctionQB: Codeunit 7207272;
        Text001: TextConst ENU = '"Department of the work n§ "', ESP = '"Departamento de la obra n§ "';
        Jobs: Record 167;
    BEGIN
        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Department Equal To Project" THEN BEGIN
            //-5526 no para las versiones
            IF (Job."Original Quote Code" = '') THEN BEGIN
                DimValue.INIT;
                DimValue."Dimension Code" := FunctionQB.ReturnDimDpto;
                DimValue.Code := Job."No.";
                DimValue.Name := Text001 + Job."No.";
                DimValue."Global Dimension No." := FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto);
                DimValue."Job Structure Warehouse" := Job."No.";       //TO-DO Esto no deber�a ser as�. debe usar el proyecto general de estructura de almac�n

                IF NOT DimValue.INSERT THEN
                    DimValue.MODIFY;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
                    //Job."Global Dimension 1 Code" := Job."No.";
                    Job.VALIDATE("Global Dimension 1 Code", Job."No.");
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
                    //Job."Global Dimension 2 Code" := Job."No.";
                    Job.VALIDATE("Global Dimension 2 Code", Job."No.");
                CLEAR(DefaultDim);
                DefaultDim.RESET;
                DefaultDim."Table ID" := DATABASE::Job;
                DefaultDim."No." := Job."No.";
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
                    IF Job."Global Dimension 1 Code" <> '' THEN BEGIN
                        DefaultDim."Dimension Code" := FunctionQB.ReturnDimDpto;
                        DefaultDim."Dimension Value Code" := Job."Global Dimension 1 Code";
                    END;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
                    IF Job."Global Dimension 2 Code" <> '' THEN BEGIN
                        DefaultDim."Dimension Code" := FunctionQB.ReturnDimDpto;
                        DefaultDim."Dimension Value Code" := Job."Global Dimension 2 Code";
                    END;
                DefaultDim."Value Posting" := DefaultDim."Value Posting"::"Same Code";
                IF NOT DefaultDim.INSERT(TRUE) THEN
                    DefaultDim.MODIFY(TRUE);

            END;
            //5526
        END;
    END;

    LOCAL PROCEDURE CreateLocation(VAR Job: Record 167);
    VAR
        QuoBuildingSetup: Record 7207278;
        Location: Record 14;
        Text001: TextConst ENU = '"Location job N. "', ESP = 'Almac�n obra %1';
        FunctionQB: Codeunit 7207272;
    BEGIN
        //Solo crea almac�n en proyectos operativos que no sean de desviaciones
        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") AND (Job."Job Type" <> Job."Job Type"::Deviations) THEN BEGIN
            QuoBuildingSetup.GET;
            IF QuoBuildingSetup."Create Location Equal To Proj." THEN BEGIN
                Location.INIT;
                Location.Code := COPYSTR(Job."No.", 1, MAXSTRLEN(Location.Code));
                Location.Name := STRSUBSTNO(Text001, Job."No.");
                //JAV 17/06/10: - Se pone el c�digo de departamento a partir del que tenga la configuraci�n o si no el de la obra, y se marca coste medio
                IF (QuoBuildingSetup."Value dimension for location" = '') THEN
                    Location."QB Departament Code" := FunctionQB.GetDepartment(DATABASE::Job, Job."No.")
                ELSE
                    Location."QB Departament Code" := QuoBuildingSetup."Value dimension for location";
                Location."QB Job Location" := TRUE;
                //JAV fin
                IF Location.INSERT(TRUE) THEN;
                Job."Job Location" := Location.Code;
            END;
        END;
    END;

    LOCAL PROCEDURE CreateInitialBudget(VAR Job: Record 167);
    VAR
        JobBudget: Record 7207407;
        Txt001: TextConst ENU = 'INITIAL', ESP = 'INICIAL';
    BEGIN
        IF NOT JobBudget.GET(Job."No.", Job."Initial Budget Piecework") THEN BEGIN
            JobBudget."Job No." := Job."No.";
            JobBudget."Cod. Budget" := Job."Initial Budget Piecework";
            JobBudget."Budget Name" := 'A�o ' + JobBudget."Cod. Budget";
            JobBudget.INSERT;

            Job."Current Piecework Budget" := Job."Initial Budget Piecework"; //JAV 22/10/20: - QB 1.07.00 El presupuesto actual es el inicial al crear el proyecto
        END;

        //JAV 22/10/20: - QB 1.07.00 Le pongo un nombre al presupuesto inicial
        CASE Job."Card Type" OF
            Job."Card Type"::Estudio, Job."Card Type"::"Proyecto operativo":
                BEGIN
                    JobBudget."Budget Name" := Txt001;
                    JobBudget."Budget Date" := Job."Starting Date";
                END;

            Job."Card Type"::Presupuesto:  //JAV 14/07/21: - QB 1.09.05 Nuevo tratamiento para presupuestos
                BEGIN
                    //RE16067-LCG-281221
                    JobBudget."Budget Date" := DMY2DATE(1, 1, DATE2DMY(Job."Starting Date", 3));
                    JobBudget."QPR End Date" := DMY2DATE(31, 12, DATE2DMY(Job."Starting Date", 3));
                END;
            Job."Card Type"::Promocion:   //JAV 17/11/21: - QB 1.10.00 Nuevo tratamiento para REAL ESTATE
                BEGIN
                    //RE16067-LCG-281221-INI
                    IF JobBudget."Approval Status" = JobBudget."Approval Status"::Open THEN BEGIN
                        JobBudget."Budget Date" := Job."Starting Date";
                        JobBudget."QPR End Date" := Job."Ending Date";
                    END;
                END;
        END;
        JobBudget."Initial Budget" := TRUE;             //Lo marco como el presupuesto inicial
        JobBudget."Actual Budget" := TRUE;              //JAV 22/10/20: - QB 1.07.00 Lo marco como el presupuesto actual
        JobBudget.MODIFY;
    END;

    LOCAL PROCEDURE TJob_AssignJobNo(VAR rec: Record 167);
    VAR
        JobClassification: Record 7207276;
        QuoBuildingSetup: Record 7207278;
        NoSeriesManagement: Codeunit 396;
        PGJobClassification: Page 7207285;
        Series: Code[20];
    BEGIN
        //JAV 01/12/21: - QB 1.10.04 Nueva forma de obtener los contadores seg�n la tabla de Clasificaci�n de proyectos
        IF rec."No." = '' THEN BEGIN //No para numeraci�n manual
            QuoBuildingSetup.GET;
            Series := '';
            CASE rec."Card Type" OF
                rec."Card Type"::Estudio:
                    BEGIN
                        JobClassification.RESET;
                        JobClassification.SETFILTER("Serie for Quotes", '<>%1', '');
                        //Si no hay definido ning�n contador a usar en ninguna clasificaci�n, uso el contador gen�rico
                        IF (JobClassification.COUNT = 0) THEN BEGIN
                            QuoBuildingSetup.TESTFIELD("Serie for Offers");
                            Series := QuoBuildingSetup."Serie for Offers";
                            //Si solo hay una clasificaci�n, utilizo su contador directamente
                        END ELSE IF (JobClassification.COUNT = 1) THEN BEGIN
                            JobClassification.FINDFIRST;  //JAV 25/03/22: - QB 1.10.27 No se le�a el registro
                            Series := JobClassification."Serie for Quotes";
                            //Si hay varias clasificaciones, hago que elijan
                        END ELSE BEGIN
                            CLEAR(PGJobClassification);
                            PGJobClassification.LOOKUPMODE(TRUE);
                            PGJobClassification.CAPTION(STRSUBSTNO('Seleccione una clasificaci�n para el %1', rec."Card Type"));
                            PGJobClassification.SETTABLEVIEW(JobClassification);
                            IF PGJobClassification.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                PGJobClassification.GETRECORD(JobClassification);
                                Series := JobClassification."Serie for Quotes";
                                rec.Clasification := JobClassification.Code;
                            END ELSE
                                ERROR('Alta cancelada'); //Cancelamos el proceso de alta
                        END;
                    END;
                rec."Card Type"::"Proyecto operativo":
                    BEGIN
                        JobClassification.RESET;
                        JobClassification.SETFILTER("Serie for Jobs", '<>%1', '');
                        IF (JobClassification.COUNT = 0) THEN BEGIN
                            QuoBuildingSetup.TESTFIELD("Serie for Jobs");
                            Series := QuoBuildingSetup."Serie for Jobs";
                        END ELSE IF (JobClassification.COUNT = 1) THEN BEGIN
                            Series := JobClassification."Serie for Jobs";
                        END ELSE BEGIN
                            CLEAR(PGJobClassification);
                            PGJobClassification.LOOKUPMODE(TRUE);
                            PGJobClassification.CAPTION(STRSUBSTNO('Seleccione una clasificaci�n para el %1', rec."Card Type"));
                            PGJobClassification.SETTABLEVIEW(JobClassification);
                            IF PGJobClassification.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                PGJobClassification.GETRECORD(JobClassification);
                                //JAV 08/09/22: - QB 1.11.02 (Q17952) Error en el contador seleccionado para los proyectos a partir de su clasificaci�n
                                //Series := JobClassification."Serie for Quotes";
                                Series := JobClassification."Serie for Jobs";
                                rec.Clasification := JobClassification.Code;
                            END ELSE
                                ERROR('Alta cancelada'); //Cancelamos el proceso de alta
                        END;
                    END;
                rec."Card Type"::Presupuesto: //JAV 14/07/21: - QB 1.09.05 Nuevo tipo para presupuestos
                    BEGIN
                        QuoBuildingSetup.TESTFIELD("QPR Serie for Budgets");
                        NoSeriesManagement.InitSeries(QuoBuildingSetup."QPR Serie for Budgets", rec."No. Series", 0D, rec."No.", rec."No. Series");
                    END;
                rec."Card Type"::Promocion: //JAV 17/11/21: - QB 1.10.00 Nuevo tipo para Real Estate
                    BEGIN
                        QuoBuildingSetup.TESTFIELD("RE Serie for RE Proyect");
                        NoSeriesManagement.InitSeries(QuoBuildingSetup."RE Serie for RE Proyect", rec."No. Series", 0D, rec."No.", rec."No. Series");
                    END;
            END;
            NoSeriesManagement.InitSeries(Series, rec."No. Series", 0D, rec."No.", rec."No. Series");

        END;
    END;

    LOCAL PROCEDURE CreateAccountWorkTJob(VAR Job: Record 167);
    VAR
        LJob: Record 167;
        DefaultDim: Record 352;
        FunctionQB: Codeunit 7207272;
        nro: Integer;
        nroTxt: Text;
    BEGIN
        IF Job."Job Matrix - Work" = Job."Job Matrix - Work"::Work THEN BEGIN
            LJob.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
            LJob.SETRANGE("Job Matrix - Work", LJob."Job Matrix - Work"::Work);
            LJob.SETRANGE("Matrix Job it Belongs", Job."Matrix Job it Belongs");
            //JAV 26/10/20: - QB 1.07.00 Cambio la forma de crear los hijos ya que el si hay mas de 99 el orden en NAV ser�a -10, -100, -11 ... -99 y vuelve a darle el 100
            //IF LJob.FINDLAST THEN
            //  Job."No." := INCSTR(LJob."No.")
            //ELSE
            //  Job."No." := DELCHR(Job."Matrix Job it Belongs",'<>') + '-00';
            //Cuento cuantos registros hay y busco un n�mero libre a partir de este para dar el alta, normalmente debe ser el siguiente, pero por si acaso
            nro := LJob.COUNT;
            REPEAT
                IF (nro < 10) THEN
                    nroTxt := '0' + FORMAT(nro)
                ELSE
                    nroTxt := FORMAT(nro);
                Job."No." := DELCHR(Job."Matrix Job it Belongs", '<>') + '-' + nroTxt;
                nro += 1;
            UNTIL (NOT LJob.GET(Job."No."));
            //JAV Fin

            IF (Job."Matrix Job it Belongs" <> '') THEN BEGIN
                DefaultDim."Table ID" := DATABASE::Job;
                DefaultDim."No." := Job."No.";
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
                    IF Job."Global Dimension 1 Code" <> '' THEN BEGIN
                        DefaultDim."Dimension Code" := FunctionQB.ReturnDimDpto;
                        DefaultDim."Dimension Value Code" := Job."Global Dimension 1 Code";
                    END;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
                    IF Job."Global Dimension 2 Code" <> '' THEN BEGIN
                        DefaultDim."Dimension Code" := FunctionQB.ReturnDimDpto;
                        DefaultDim."Dimension Value Code" := Job."Global Dimension 2 Code";
                    END;
                DefaultDim."Value Posting" := DefaultDim."Value Posting"::"Same Code";
                IF NOT DefaultDim.INSERT(TRUE) THEN
                    DefaultDim.MODIFY(TRUE);
            END;
        END;
    END;

    LOCAL PROCEDURE CreateAccountVersionsTJob(VAR Job: Record 167);
    VAR
        LJob: Record 167;
        DefaultDim: Record 352;
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF Job."Job Matrix - Work" = Job."Job Matrix - Work"::Work THEN BEGIN
            LJob.SETRANGE("Job Matrix - Work", LJob."Job Matrix - Work"::Work);
            LJob.SETRANGE("Original Quote Code", Job."Original Quote Code");
            IF LJob.FINDLAST THEN
                Job."No." := INCSTR(LJob."No.")
            ELSE
                Job."No." := DELCHR(Job."Original Quote Code", '<>') + '-00';
            IF LJob."Original Quote Code" <> '' THEN BEGIN
                DefaultDim."Table ID" := DATABASE::Job;
                DefaultDim."No." := Job."No.";
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
                    IF Job."Global Dimension 1 Code" <> '' THEN BEGIN
                        DefaultDim."Dimension Code" := FunctionQB.ReturnDimDpto;
                        DefaultDim."Dimension Value Code" := Job."Global Dimension 1 Code";
                    END;
                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
                    IF Job."Global Dimension 2 Code" <> '' THEN BEGIN
                        DefaultDim."Dimension Code" := FunctionQB.ReturnDimDpto;
                        DefaultDim."Dimension Value Code" := Job."Global Dimension 2 Code";
                    END;
                DefaultDim."Value Posting" := DefaultDim."Value Posting"::"Same Code";
                IF NOT DefaultDim.INSERT(TRUE) THEN
                    DefaultDim.MODIFY(TRUE);
            END;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------- T167 Jobs Funciones actualmente no usadas"();
    BEGIN
    END;

    LOCAL PROCEDURE SeeIfSonSheetTJob(Job: Record 167): Boolean;
    VAR
        Piecework: Record 7207277;
        PieceworkSon: Record 7207277;
    BEGIN
        IF Piecework."Account Type" = Piecework."Account Type"::Unit THEN
            EXIT(TRUE);
        PieceworkSon.SETRANGE("Cost Database Default", Piecework."Cost Database Default");
        PieceworkSon.SETFILTER("No.", Piecework.Totaling);
        IF PieceworkSon.FINDSET THEN
            REPEAT
                IF (PieceworkSon."No." <> Piecework."No.") THEN BEGIN
                    IF (PieceworkSon."Account Type" = PieceworkSon."Account Type"::Heading) OR
                       (PieceworkSon."Certification Unit") THEN
                        EXIT(FALSE);
                END;
            UNTIL PieceworkSon.NEXT = 0;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE MultiplierTJob(Piecework: Record 7207277; VAR Multiplier: Decimal; Job: Record 167);
    VAR
        VPiecework: Record 7207277;
    BEGIN
        Multiplier := 1;
        Piecework.SETRANGE("Cost Database Default", Piecework."Cost Database Default");
        VPiecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
        IF VPiecework.FINDFIRST THEN
            REPEAT
                IF COPYSTR(Piecework."No.", 1, STRLEN(VPiecework."No.")) =
                   VPiecework."No." THEN BEGIN
                    IF VPiecework."Measurement Cost" <> 0 THEN
                        Multiplier := Multiplier * VPiecework."Measurement Cost"
                    ELSE
                        // Antes estaba por 1 y ahora ponemos por cero porque hay unidades que vienen con medici¢n cero
                        // Lo vuelvo a 1
                        Multiplier := Multiplier * 1;
                END;
            UNTIL VPiecework.NEXT = 0;
    END;

    LOCAL PROCEDURE "---------------------------------------------T7207308 OutPut Shipment Header"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207308, OnAfterValidateEvent, "Posting Date", true, true)]
    LOCAL PROCEDURE OnAfterValidate_PostingDate(VAR Rec: Record 7207308; VAR xRec: Record 7207308; CurrFieldNo: Integer);
    VAR
        TextError: TextConst ENU = 'Posting Date must be equal or later of Request Date', ESP = 'La fecha de registro debe ser igual o posterior a la fecha de Solicitud';
    BEGIN
        //-PAT 11/04/23: - Q19156 Salidas Almacen: Fecha solicitud no deberia ser superior a Fecha Registro

        IF (Rec."Posting Date" < Rec."Request Date") THEN BEGIN
            ERROR(TextError);
        END;
        //+PAT 11/04/23: - Q19156 Salidas Almacen: Fecha solicitud no deberia ser superior a Fecha Registro
    END;

    [EventSubscriber(ObjectType::Table, 7207308, OnAfterValidateEvent, "Request Date", true, true)]
    LOCAL PROCEDURE OnAfterValidate_RequestDate(VAR Rec: Record 7207308; VAR xRec: Record 7207308; CurrFieldNo: Integer);
    VAR
        TextError2: TextConst ENU = 'Request Date must be equal or earlier than Posting Date', ESP = 'La Fecha de solicitud debe ser igual o anterior a la Fecha de Registros';
    BEGIN
        //-PAT 11/04/23: - Q19156 Salidas Almacen: Fecha solicitud no deberia ser superior a Fecha Registro
        IF (Rec."Request Date" > Rec."Posting Date") THEN BEGIN
            ERROR(TextError2);
        END;
        //+PAT 11/04/23: - Q19156 Salidas Almacen: Fecha solicitud no deberia ser superior a Fecha Registro
    END;


    /*BEGIN
/*{
      NZG  24/01/18: - QBV101 Modificaci¢n en la funcion CreateDimensionsPredetermined para que en las versiones tome el valor de dimension del original
      PEL  11/07/18: - QB_2785 Limitar a 250 Char.
      PGM  11/10/18: - QVE2834 A¤adir un mensaje de confirmacion al aceptar un Estudio
      PGM  15/10/18: - QVE4512 Comentada linea para que deje en blanco el Cod. Departamento.
      PGM  26/12/18: - QBA5412 A¤adidas distintas funcionalidades en los Estudios(ofertas).
      PEL  12/02/19: - QB6224 A¤adir coeficiente indirecto antes de realizar el calculo de gasto general.
      PGM  19/03/19: - Se a¤ade la acci¢n para cargar Mandatory Allocation Term By en los estudios
      PEL  19/03/19: - OBR Marcar Obralia al crear un proveedor
      JAV  26/03/19: - Se mejora el borrado del almac�n del proyecto
      JAV  07/04/19: - Se mejora el borrado del almac�n del proyecto
      JAV  08/04/19: - Se mejora el borrado de proyectos, no eliminaba usuarios
      JAV  13/05/19: - Se salta el vendedor solo si est  as¡ configurado
      PEL  29/04/19: - QCPM_GAP05 Al aceptar o rechazar una oferta poner ultimo estado interno
      RSH  02/05/19: - QX7105 A¤adir c¢digo en la funci¢n AcceptTJob para que no deje aceptar un Estudio con el cliente gen�rico.
      RSH  02/05/19: - QX7105 A¤adir c¢digo en la funci¢n CreateJobTJob para que no deje pasar un Estudio a Proyecto con el cliente gen�rico.
      RSH  02/05/19: - QX7105 A¤adir funci¢n ChangeBillToTJob para usar en el page action "Cambiar N§ Cliente" de la pagina Quotes Card.
      JAV  02/06/19: - Se elimina la funci¢n "OnValidateQuotePhase_TJob" que ya no se usa
      JAV  11/06/19: - No podemos quitar las anteriores del proyecto, sino a¤adir las del cliente
      JAV  17/06/10: - Al crear el almac�n se pone c¢digo de departamento a partir del que tenga la obra, y se marca coste medio
      JAV  11/07/19: - Sacar la lista de proyectos de la tabla de usurios por proyecto, no del filtro
      PGM  22/07/19: - KALAM GAP009 Control para que Estado no pueda pasar a completado si el periodo devoluci¢n retenci¢n no est  relleno.
      JAV  18/08/19: - Se eliminan las funciones de c lculo de retenciones, pues se ha cambiado su manejo
      JAV  23/08/19: - Se cambian los nombres de las funciones que crean dimensiones de proyecto por unas mas adecuadas a lo que hacen pues
                       funcionaban al contrario de su nombre, y se informa en las funciones de la dimensi¢n departamento por defecto
      JAV  29/08/19: - Se recalculan las retenciones al traspasar al documento desde cliente o proveedor
      JAV  19/09/19: - Se modifica la funci¢n AcceptTJob
                       - Primero se mira si es posible hacerlo antes de preguntar si se desea hacerlo
                       - Al aceptar, aunque no se seleccionada versi¢n se pasaba la oportunidad a ganada y el estado a finalizado
                       - Se hace que si solo hay una versi¢n o ya hay una versi¢n presentada, no pregunte cual se aprueba
      JAV  05/10/19:  - Se elimina de la tabla "data piecework for production" la funci¢n "GenerateUniqueCode" y se pasa al validate del campo "Unique code"
      JMMA 18/10/19: - En la funci¢n  OnDeleteTGLBudgetEntry SE COMENTA ESTE CODIGO POR LENTITUD EN EL CAL. PPTO ANAL�TICO. EL EST�NDAR YA BORRA LA ENTRADA DE LA VISTA DE AN�LISIS.
      JAV  24/10/19: - Se pasan los eventos de retenciones a su CU
      JAV 30/10/19: - Si un FRI est  anulado no sumar su importe como pendiente
      JAV 01/11/19: - Se elimina un par mentro en el CreateDim de la funci¢n AfterValidateJobNo que se pasa ahora internamente
      JAV 06/11/19: - Se cambia a la nueva forma de obtener certificados obligatorios en la funci¢n ControlCertificatesTreasury
      PGM 12/11/19: - Q8163 Cuando se valida el campo "Planned K" de la tabla 167, me llevo el valor a todas las unidades de obra de la tabla "Data Piecework for Production" para ese proyecto.
      JAV 12/11/19: - Se pasa a la CU "Quality Management" las funciones relacionadas con la calidad
                          ValidateEval
                          DeleteQualityOnDeleteTVendor
      JAV 21/11/19: - Se eliminan las funciones de otras condiciones que no se usan
                          OnValidateOtherVendorConditionsCode1
                          OnValidateOtherVendorConditionsCode2
                          OnValidateOtherVendorConditionsCode1TPurchasePayablesSetup
                          OnValidateOtherVendorConditionsCode2TPurchasePayablesSetup
      JAV 28/01/20: - En el alta del proyecto se crean los responsables a partir de las plantillas
      JAV 02/02/20: - Se pasan a la CU "Quality Management" las funci¢nes:
                          OnValidateBuyfromVendorNoPurchHeader
                          OnValidatePaytoVendorNoPurchHeader
                          ControlCertificatesTreasury
      JAV 02/02/20: - Se crean funciones para marcar el presupuesto como pendiente de rec lculo
      JAV 06/02/20: - Se reagrupan las funciones de la T167, se unifican las tres funciones OnAfterInsert, se unifican nombres de funciones
                    - En el alta de un estudio o proyecto se crean los responsables
                    - Activamos campos necesarios para QB en el alta del Proyecto
      JAV 22/02/20: - Se a¤ade el evento OnValidateJobPostingGroupTJob, cuando se cambia el grupo lo cambia en todas las versiones
                    - Se eliminan los eventos que ya no se usan y estaban duplicados
                          OnValidateOtherVendorConditionsCode1
                          OnValidateOtherVendorConditionsCode2
                          OnValidateOtherVendorConditionsCode1TPurchasePayablesSetup
                          OnValidateOtherVendorConditionsCode2TPurchasePayablesSetup
      JAV 25/02/20: - Los procesos Before/After Create, Modify, Delete y Rename no deben actuar si no est  as¡ configurado
      JAV 27/02/20: - Se a¤aden eventos para marcar que hay que recalcular T7207388_OnAfterInsert, T7207388_OnAfterModify, T7207388_OnAfterDelete
      JAV 10/03/20: - Se traspasa la funci¢n CreateResponsiblesFromTemplate desde la tabla Job
                    - Se elimina la funci¢n duplicada BeforeValidateActivityCode
      JAV 19/03/20: - La funci¢n OnAfterCopyVendLedgerEntryFromGenJnlLine_TVendorLedgerEntry reemplaza al evento y la funci¢n CopyFromGenJnlLineTVendorLedgerEntry pues hay uno est ndar que ya lo hace
      JAV 05/10/20: - QB 1.06.18 Borrar los hitos de facturaci�n asociados al eliminar el proyecto
      JAV 08/10/20: - QB 1.06.20 Solo permitimos tipo de movimiento albar�n si es para un proveedor
      JAV 12/10/20: - QB 1.06.20 Al crear un nuevo proyecto se informa la UO para ajustes de divisas desde la configuraci�n
      PGM 15/10/20: - QB 1.07.00 funci�n OnAfterValidateEvent_No_TPurchaseLine para traer precios del contrato marco
      JAV 22/10/20: - QB 1.07.00 Guardo el registro del proyecto antes de cambiar sus dimensiones por el cliente
      JAV 29/10/20: - QB 1.07.02 Se eliminan las funciones que no se usan: RunOnLookupNo, GetPercentagesFromHeaderPurchaseLines, DelMarginDirectTJob, CalMarginPricePercentageTJob, CheckGLAccTGenJournalLine,
                                                                           UpdateGlobalDimCodeTDefaultDimension, UpdateRentalElementsGlobalDimCode, UpdateHeaderContractElementGlobalDimCode,
                                                                           UpdateHeaderDeliveryReturnElementGlobalDimCode, UpdateHeaderUtilizationGlobalDimCode, UpdateHeaderActivationGlobalDimCode,
                                                                           UpdatePieceworkGlobalDimCode, InsertInvLineFromRetShptLineTReturnShipmentLine
      JAV 05/11/20: - QB 1.07.03 Al cambiar el proyecto en la l�nea de venta llevarlo a la cabecera
      JAV 29/12/20: - QB 1.07.17 Se elimina FilterLevelTJob que no se usa ya
      Q12867 JDC 25/02/21 - Removed function "OnAfterValidateEvent_No_TPurchaseLine", "OnAfterValidateEvent_Quantity_TPurchaseLine2", "OnAfterDeleteEvent_TPurchaseLine2"

      JAV 23/03/21: - QB 1.08.27 Se traslada la funci�n "OnAfterValidateEvent_Quantity_TSalesLine" a la CU de certificaci�n
      JAV 28/06/21: - QB 1.09.03 Ya no se usa el campo "Jobs Budget Code" en su lugar se llama a FunctionQB.ReturnBudgetJobs o a FunctionQB.ReturnBudgetQuote

      TO-DO Esto no deber�a ser as�. debe usar el proyecto general de estructura de almac�n
      JAV 29/10/21: - QB 1.09.26 Se eliminan funciones que ya no se usan:  CalAmountPendingPurchaseInterimTPurRcLine, CalcAmountPendingPurchaseTPurRcLine, CalculateAmountPourchaseTPurchRcptLine
                                                                           ReturnMarginDirectTJob, ReturnCostIndirectTJob, RefillContract, ControlMilestoneTJob  (Pasa a page subscriver)
                                 Estas no son evento y se pasan a funci�n: OnValidateCompleteJob               -> TJob_OnAfterChangeJobCompletionStatus
                                                                           OnLookupReestimationFilterTJob      -> TJob_OnLookupReestimationFilter
                                                                           OnLookupLastestReestimationCodeTJob -> TJob_OnLookupLastestReestimationCode
                                                                           OnLookupInitialReestimationCodeTJob -> TJob_OnLookupInitialReestimationCode
                                                                           OnLookupDimensionsJVCodeTJob        -> TJob_OnLookupDimensionsJVCode
                                                                           OnLookupAcceptedVersionNoTJob       -> TJob_OnLookupAcceptedVersionNo
                                                                           JobControlTJob                      -> TJob_ControlRespCenter
                                                                           AcceptTJob                          -> TJob_Accept
                                                                           RejectTJob                          -> TJob_Reject
                                                                           ReopenTJob                          -> TJob_Reopen
                                                                           CreateJobTJob                       -> TJob_Create
                                                                           ProductionTheoricalProcessTJob      -> TJob_ProductionTheoricalProcess
                                                                           ProductionBudgetWithoutProcessTJob  -> TJob_ProductionBudgetWithoutProcess
                                                                           AmountGeneralExpensesTJob, AmountIndustrialBenefitTJob, AmountLowTJob, AmountQualityDeductionTJob -> TJob_CalcPorcAmounts y TJob_CalcPorcAmountsWQty
                                                                           CalMarginRealizedTJob,CalMarginRealizedPercentageTJob -> TJob_CalMarginRealized
      JAV 01/12/21: - QB 1.10.04 Nueva forma de obtener los contadores seg�n la tabla de Clasificaci�n del proyecto
      LCG 28/12/21: - RE16067 Cambiar la asignaci�n de fechas cuando el proyecto es tipo promoci�n.
      JAV 13/01/22: - QB 1.10.09 Nuevas funciones y eventos para confirming
                                    T92_ChangeCustomerConfirmingAccount
                                    T93_ChangeVendorConfirmingAccount
                                    T289_OnAfterModifyEvent : Antes de modificar las formas de pago, revisar el confirming
                                    T81_OnAfterValidateEvent_PaymentMethod : Tras validar m�todo de pago en el diario contable
                                    T7000002_OnAfterModifyEvent : Se evita que se puedan incluir documentos con/sin confirming.
                                    T21_OnAfterCopyCustLedgerEntryFromGenJnlLine : SOLO Se a�ade el manejo del confirming
      EPV 18/02/22: - Control prestados: T83_OnAfterCopyItemJnlLineFromPurchLine
      JAV 24/02/22: - QB 1.10.22 Se traslada la funci�n CreateResponsiblesFromTemplate a la CU "QB - Approval - Management"
      DGG 08/03/22: - RE16539 Modificacion para que tenga en cuenta el tipo de valor que se tiene tiene que llevar del comparativo al pedido.
      JAV 25/03/22: - QB 1.10.27 No se le�a el registro
      EPV 30/03/22: - QB 1.10.29 (BUG) Error al usar funciones de cliente para cambio de banco del proveedor
      JAV 31/03/22: - QB 1.10.29 Se a�ade par�metro en la llamada a la funci�n
      JAV 20/04/22: - QB 1.10.36 A¤adir la dimensi¢n JOB en el diario de productos
      JAV 16/05/22: - QRE 1.00.15 Se eliminan tambi�n los usuarios de las partidas por si existen al eliminar un proyecto
      JAV 19/05/22: - QB 1.10.42 Solo para Real Estate
      JAV 21/05/22: - QB 1.10.42 Establecer la dimensi�n para el CA en su campo al inicializar el registro
      JAV 21/05/22: - QB 1.10.42 Las l�neas de tipo recurso no son est�ndar, hay que tratarlas por aqu� en lugar de por la funci�n TypeToTableID3 de la CU 408 que as� mantenemos est�ndar
      DGG 24/05/22: - RE17277 T21_OnBeforeInsertInvLineFromRcptLine para que se informe el numero de pedido y linea de pedido al traer albaranes a la factura de compras.
      JAV 30/05/22: - QB 1.10.45 Nuevo sistema de modificar dimensiones. Se establece Proyecto en la l�nea de compra
      JAV 02/06/22: - QB 1.10.47 Se soluciona un problema por el que al cambiar el recurso asociado entraba en un bucle cont�nuo, ahora solo lo cambia una vez.
      JAV 16/06/22: - QB 1.10.50 Si no hay proyecto en la l�nea de compra se elimina la U.O. de la l�nea
      JAV 17/06/22: - QB 1.10.50 Se amplian los tipos de proyecto a tratar en compras QB/RE/CECO
                                 Nueva funcion que captura el eveto para preparar la tabla en ventas
                                 En pedidos contra almac�n no hay que indicar proyecto
      JAV 06/07/22: - QB 1.10.59 Se quitan como eventos las funciones CreateAccountWorkTJob y CreateAccountVersionsTJob que no tienen sentido que lo sean, son funciones locales
                                 Se elimina la funci�n GetCurrency que no se emplea en ningun lugar externo
      JAV 13/07/22: - QB 1.11.00 A�adir en la l�nea del diario contable los datos del proyecto y UO/Partida desde las l�neas de distribuci�n
      JAV 08/09/22: - QB 1.11.02 (Q17952) Error en el contador seleccionado para los proyectos a partir de su clasificaci�n
      JAV 07/11/22: - QB 1.12.13 Control de lineas divididas, se a�ade c�digo en T39_OnBeforeModifyEvent, T39_OnBeforeDeleteEvent, T39_OnBeforeValidateEvent_DirectUnitCost. Nueva funci�n T39_SplitLine
      EPV 11/01/23: - BUG corregido - Fallaba porque se validaba la cantidad antes de anular la cantidad recibida.
      CPA 27/03/23: - Q16226. Facturar Albaranes con mismo producto al mismo precio.
                      Modificaciones:T21_OnBeforeInsertInvLineFromRcptLine
      JJEP 10/04/23: - Q18816 - PEDIDO - Impedir edici�n de campos.
      PAT 11/04/23: - Q19156 Salidas Almacen: Fecha solicitud no deberia ser superior a Fecha Registro
      AML 24/5/23   - Q18816 Correcci�n para poder crear las l�neas de compra.
      AML 05/07/23: - Q19864 MEzclado con Q18816 Correccion para poder modificar la UO cuando viene de un comparativo si est� en blanco.
      AML 28/09/23: - Q19785 Problemas al dar de alta un proyecto.
      AML 30/10/23: - Q20398 Correcci�n
    }
END.*/
}








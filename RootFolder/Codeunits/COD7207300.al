Codeunit 7207300 "QB Prepayment Management"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        FunctionQB: Codeunit 7207272;
        QBP: Record 7206928 TEMPORARY;
        Text000: TextConst ESP = 'Anticipo al %1';
        Text001: TextConst ENU = 'Discounting the advance payment', ESP = 'Descontar el anticipo';
        Text002: TextConst ESP = 'Anticipo proyecto %1 de %2';
        Text003: TextConst ESP = 'No puede descontar mas anticipo que la base imponible de la factura';
        Text004: TextConst ESP = 'No puede descontar mas anticipo del importe a pagar de la factura';
        Text005: TextConst ESP = 'Cliente';
        Text006: TextConst ESP = 'Proveedor';
        Text007: TextConst ESP = 'Proyecto';
        Text008: TextConst ESP = 'Divisa';
        Text009: TextConst ESP = 'No puede cambiar el %1 de una factura de anticipo';
        Text010: TextConst ESP = 'Si cambia el %1 perder� el anticipo aplicado, �Realmente desea hacerlo?';
        Text011: TextConst ESP = 'Cambio Cancelado';
        Text012: TextConst ESP = 'La cuenta %1 no puede tener tipo de registro ni grupos de registro para no generar IVA.';
        Text020: TextConst ESP = '"   Total %1 %2 del Proyecto %3"';
        Text021: TextConst ESP = '"      Total %1 del Proyecto %2"';
        Text013: TextConst ESP = 'Canc.Anticipo proy. %1 de %2';

    LOCAL PROCEDURE "----------------------------------------- Funciones para clientes"();
    BEGIN
    END;

    PROCEDURE AccessToCustomerPrepayment(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
        PrepmtPostingGrpErr: TextConst ENU = 'The %1 has not been defined.', ESP = 'El %1 no ha sido definido.';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Verifica si se tiene acceso a los prepagos de clientes, retorna true o false
        //-------------------------------------------------------------------------------------------------------------------

        //Q12879 -
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET;
            IF QuoBuildingSetup."Use Customer Prepayment" THEN BEGIN
                //JAV 27/06/22: - QB 1.10.55 Se a�ade el manejo de "Prepayment Posting Group 1" para efectos y "Prepayment Posting Group 2" para Fras
                IF (QuoBuildingSetup."Prepayment Posting Group 1" = '') THEN
                    ERROR(STRSUBSTNO(PrepmtPostingGrpErr, QuoBuildingSetup.FIELDCAPTION("Prepayment Posting Group 1")));
                IF (QuoBuildingSetup."Prepayment Posting Group 2" = '') THEN
                    ERROR(STRSUBSTNO(PrepmtPostingGrpErr, QuoBuildingSetup.FIELDCAPTION("Prepayment Posting Group 2")));
                EXIT(QuoBuildingSetup."Use Customer Prepayment");
            END;
        END;
        //Q12879 +
    END;

    PROCEDURE AccessToCustomerPrepaymentError();
    VAR
        QBModuleActErr: TextConst ENU = 'This QuoBuilding''s module is not active.', ESP = 'Este m�duclo de QuoBuilding no est� activo.';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Verifica si se tiene acceso a los prepagos de clientes, si no da un error
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        IF NOT AccessToCustomerPrepayment THEN  //JAV 22/11/21: - QB 1.09.29 Error en la variable usada, miraba proveedor en lugar de cliente
            ERROR(QBModuleActErr);
        //Q12879 +
    END;

    PROCEDURE SeeJobCustomer(JobNo: Code[20]);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentList: Page 7207031;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Ver los anticipos de clientes de un proyecto
        //-------------------------------------------------------------------------------------------------------------------
        AccessToCustomerPrepayment;

        QBPrepayment.RESET;
        QBPrepayment.FILTERGROUP(2);
        QBPrepayment.SETRANGE("Job No.", JobNo);
        QBPrepayment.SETRANGE("Account Type", QBP."Account Type"::Customer);

        PAGE.RUNMODAL(PAGE::"QB Job Prepayment List", QBPrepayment);
    END;

    PROCEDURE CreateSalesInvoice(VAR QBPrepayment: Record 7206928);
    VAR
        QuoBuildingSetup: Record 7207278;
        SalesSetup: Record 311;
        QBApprovalsSetup: Record 7206994;
        Job: Record 167;
        SalesHeader: Record 36;
        SalesHeaderList: Record 36;
        SalesLine: Record 37;
        NoSeriesMgt: Codeunit 396;
        SalesPost: Codeunit 80;
        SalesInvoice: Page 43;
        nLin: Integer;
        i: Integer;
        QBPrepaymentEdit: Page 7207281;
        GLAccount: Record 15;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Crear un documento de tipo Factura de venta
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.35 Pedir la fecha de registro antes de generar la factura
        CLEAR(QBPrepaymentEdit);
        QBPrepaymentEdit.SetPost(QBPrepayment."Job No.", QBPrepayment."Account Type", QBPrepayment."Account No.", FORMAT(QBPrepayment."Generate Document"), QBPrepayment."Not Approved Amount",
                                 //Q18899-
                                 QBPrepayment."Payment Terms Code", QBPrepayment."Document Date", QBPrepayment."Posting Date");
        //QBPrepayment."Payment Terms Code");  //JAV 20/04/22: - QB 1.10.36 Se incluye el t�rmino de pago para el c�lculo del vencimiento
        //Q18899+
        QBPrepaymentEdit.LOOKUPMODE(TRUE);
        IF (QBPrepaymentEdit.RUNMODAL <> ACTION::LookupOK) THEN
            EXIT;

        //JAV 20/04/22: - QB 1.10.36 Se ampl�an los par�metros de registro con fecha de registro, fecha del documento, t�mino de pago y fecha de vencimiento
        QBPrepaymentEdit.GetPost(QBPrepayment."Posting Date", QBPrepayment."Document Date", QBPrepayment."Payment Terms Code", QBPrepayment."Due Date");
        QBPrepayment.MODIFY(TRUE);

        QuoBuildingSetup.GET();
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
        Job.GET(QBPrepayment."Job No.");
        Job.TESTFIELD("VAT Prod. PostingGroup");

        SalesHeader.INIT;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."Document Date" := QBPrepayment."Document Date";
        SalesHeader.VALIDATE("Posting Date", QBPrepayment."Posting Date");
        SalesHeader.VALIDATE("Document Date");
        SalesHeader."QB Prepayment Use" := SalesHeader."QB Prepayment Use"::Prepayment;
        SalesHeader.INSERT(TRUE);

        SalesHeader.VALIDATE("Sell-to Customer No.", QBPrepayment."Account No.");
        SalesHeader.VALIDATE("QB Job No.", QBPrepayment."Job No.");
        SalesHeader.VALIDATE("Currency Code", QBPrepayment."Currency Code");
        SalesHeader."Posting No." := NoSeriesMgt.GetNextNo(SalesSetup."Posted Prepmt. Inv. Nos.", SalesHeader."Posting Date", TRUE);
        SalesHeader."Posting Description" := COPYSTR(STRSUBSTNO(Text002, QBPrepayment."Job No.", QBPrepayment."Account No."), 1, MAXSTRLEN(SalesHeader."Posting Description"));
        SalesHeader.VALIDATE("Payment Discount %", 0);  //No puede tener descuentos adicionales
        SalesHeader.VALIDATE("VAT Base Discount %", 0);  //No puede tener descuentos adicionales
        SalesHeader."QB Job Sale Doc. Type" := SalesHeader."QB Job Sale Doc. Type"::"Advance by Store";  //JAV 29/03/22: - QB 1.10.29 Se marca que es una factura de anticipo
        SalesHeader."External Document No." := QBPrepayment."External Document No."; //JAV 04/04/22: - QB 1.10.31 Se informa del documento externo

        //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�ge, m�todo de pago y fecha de vencimiento
        SalesHeader.VALIDATE("Document Date", QBPrepayment."Document Date"); //Q18899
        SalesHeader."Payment Method Code" := QBPrepayment."Payment Method Code";
        SalesHeader."Payment Terms Code" := QBPrepayment."Payment Terms Code";
        SalesHeader."Due Date" := QBPrepayment."Due Date";
        SalesHeader.MODIFY(TRUE);

        nLin := 10000;

        SalesLine.INIT;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := nLin;
        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.", GetSalesPrepaymentAccount(SalesHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2")); //JAV 27/06/22: - QB 1.10.55 grupo para Fras
        SalesLine.VALIDATE("Gen. Bus. Posting Group", SalesHeader."Gen. Bus. Posting Group");
        //Q18899-
        IF (GLAccount.GET(GetSalesPrepaymentAccount(SalesHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"))) AND
           (GLAccount."Gen. Prod. Posting Group" <> '') THEN
            SalesLine.VALIDATE("Gen. Prod. Posting Group", GLAccount."Gen. Prod. Posting Group")
        ELSE
            //Q18899+
            SalesLine.VALIDATE("Gen. Prod. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2");  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                                                                                                            //Q18899-
        IF (GLAccount.GET(GetSalesPrepaymentAccount(SalesHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"))) AND
           (GLAccount."VAT Prod. Posting Group" <> '') THEN
            SalesLine.VALIDATE("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting Group")
        ELSE
            //Q18899+
            SalesLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
        SalesLine.Description := COPYSTR(QBPrepayment."Description Line 1", 1, MAXSTRLEN(SalesLine.Description));
        SalesLine.VALIDATE(Quantity, 1);
        SalesLine.VALIDATE("Unit Price", QBPrepayment."Not Approved Amount");
        SalesLine.VALIDATE("Job No.", QBPrepayment."Job No.");
        SalesLine.INSERT(TRUE);

        REPEAT
            nLin += 10000;
            SalesLine.INIT;
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := nLin;

            IF (STRLEN(QBPrepayment."Description Line 2") < MAXSTRLEN(SalesLine.Description)) THEN BEGIN
                SalesLine.Description := QBPrepayment."Description Line 2";
                SalesLine.INSERT(TRUE);
                QBPrepayment."Description Line 2" := '';
            END ELSE BEGIN
                i := MAXSTRLEN(SalesLine.Description) + 1;
                REPEAT
                    i -= 1;
                UNTIL (COPYSTR(QBPrepayment."Description Line 2", i, 1) = ' ');
                SalesLine.Description := COPYSTR(QBPrepayment."Description Line 2", 1, i - 1);
                SalesLine.INSERT(TRUE);
                QBPrepayment."Description Line 2" := COPYSTR(QBPrepayment."Description Line 2", i + 1);
            END;
        UNTIL (QBPrepayment."Description Line 2" = '');

        //JAV 10/04/22: - QB 1.10.34 Pasar la aprobaci�n del anticipo al documento generado.
        //JAV 20/04/22: - QB 1.10.36 Se cambia de lugar para crear primero las l�neas
        IF (QBApprovalsSetup.GET) THEN BEGIN
            IF (QBApprovalsSetup."Send App. Prepayment to Doc.") AND (QBPrepayment."Approval Status" = QBPrepayment."Approval Status"::Released) THEN BEGIN
                SalesHeader.Status := SalesHeader.Status::Released;
                SalesHeader.MODIFY(FALSE);
                //No est� creada la aprobaci�n de facturas de venta, esta parte no se puede ejecutar
                //IF (ApprovalSalesInvoice.IsApprovalsWorkflowEnabled(SalesHeader)) THEN
                //  QBApprovalManagement.CopyApprovalChain(QBPrepayment.RECORDID, SalesHeader.RECORDID, ApprovalEntry."QB Document Type"::salesinvoice);
            END;
        END;

        //Guardar el nro de la factura en el anticipo
        QBPrepayment."Document No." := SalesHeader."No.";
        QBPrepayment.MODIFY(TRUE);

        COMMIT;

        //Presentar la factura creada
        SalesHeaderList.RESET;
        SalesHeaderList.SETRANGE("No.", SalesHeader."No.");

        CLEAR(SalesInvoice);
        SalesInvoice.SETTABLEVIEW(SalesHeaderList);
        SalesInvoice.RUNMODAL;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T36_OnAfterDeleteEvent(VAR Rec: Record 36; RunTrigger: Boolean);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 31/03/22: - QB 1.10.29 Si se elimina una factura, quitarla de anticipos pendientes
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN BEGIN
            QBPrepayment.RESET;
            QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Customer);
            QBPrepayment.SETRANGE("Account No.", Rec."Sell-to Customer No.");
            QBPrepayment.SETRANGE("Document No.", Rec."No.");
            QBPrepayment.SETRANGE("Generate Document", QBPrepayment."Generate Document"::Invoice);
            IF (QBPrepayment.FINDFIRST) THEN BEGIN
                QBPrepayment."Document No." := '';
                QBPrepayment.MODIFY(TRUE);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE CU80_OnBeforePostSalesDoc(VAR Sender: Codeunit 80; VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        Amount: Decimal;
        Txt: Text;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Verificar que el importe total del documento no supere el anticipo a descontar antes de registrar
        //-------------------------------------------------------------------------------------------------------------------
        Txt := '';
        CASE SalesHeader."QB Prepayment Type" OF
            SalesHeader."QB Prepayment Type"::Invoice:
                BEGIN
                    SalesHeader.CALCFIELDS(Amount);
                    IF (SalesHeader.Amount < 0) THEN
                        Txt := Text003;
                END;
            SalesHeader."QB Prepayment Type"::Bill:
                BEGIN
                    SalesHeader.CALCFIELDS("Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");
                    Amount := SalesHeader."Amount Including VAT" - SalesHeader."QW Total Withholding PIT" - SalesHeader."QW Total Withholding GE";
                    IF (SalesHeader."QB Prepayment Apply" > Amount) THEN
                        Txt := Text004;
                END;
        END;

        IF (Txt <> '') THEN
            IF PreviewMode THEN
                MESSAGE(Txt)
            ELSE
                ERROR(Txt);
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostCustomerEntry, '', true, true)]
    LOCAL PROCEDURE CU80_OnAfterPostCustomerEntry(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    VAR
        SalesInvoiceHeader: Record 112;
        QBPrepayment: Record 7206928;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Esta funci�n se lanza tras registrar el importe del cliente en el diario, aqu� la capturamos para crear y descontar la retenci�n de Buena Ejecuci�n
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //Solo tiene sentido para facturas de venta, los abonos no pueden generar anticipo mas que con su cancelaci�n, que se trata en otro lugar
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            IF SalesHeader."No. Series" <> SalesHeader."Posting No. Series" THEN
                SalesHeader."Last Posting No." := SalesHeader."Posting No."
            ELSE
                SalesHeader."Last Posting No." := SalesHeader."No.";

            IF (SalesInvoiceHeader.GET(SalesHeader."Last Posting No.")) THEN BEGIN
                CASE SalesInvoiceHeader."QB Prepayment Use" OF
                    SalesInvoiceHeader."QB Prepayment Use"::Prepayment:
                        //Si se genera un nuevo anticipo con factura hay que Cambiar el nro de documento del anticipo y pasar el importe del campo sin aprobar al definitivo
                        BEGIN
                            QBPrepayment.RESET;
                            QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Customer);
                            QBPrepayment.SETRANGE("Account No.", SalesHeader."Sell-to Customer No.");
                            QBPrepayment.SETRANGE("Document No.", SalesHeader."No.");
                            QBPrepayment.SETRANGE("Generate Document", QBPrepayment."Generate Document"::Invoice);
                            IF (QBPrepayment.FINDFIRST) THEN BEGIN
                                QBPrepayment.Description := SalesInvoiceHeader."Posting Description";
                                QBPrepayment."Document No." := SalesInvoiceHeader."No.";
                                QBPrepayment.Amount := QBPrepayment."Not Approved Amount";
                                QBPrepayment."Amount (LCY)" := QBPrepayment."Not Approved Amount (LCY)";
                                QBPrepayment."Not Approved Amount" := 0;
                                QBPrepayment."Not Approved Amount (LCY)" := 0;
                                QBPrepayment.MODIFY(TRUE);
                            END;
                        END;
                    SalesInvoiceHeader."QB Prepayment Use"::Application:
                        BEGIN
                            //Si es la aplicaci�n de un efecto hay que liquidarlo contra la factura
                            IF (SalesInvoiceHeader."QB Prepayment Type" = SalesInvoiceHeader."QB Prepayment Type"::Bill) THEN
                                GenerateCustomerJournal(SalesInvoiceHeader);
                            //A�adir la liquidaci�n a los movimientos de anticipo
                            AddSalesInvoice(SalesInvoiceHeader);
                        END;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostBalancingEntry, '', true, true)]
    LOCAL PROCEDURE CU80_OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        QBPrepaymentData: Record 7206998;
        CurrencyExRate: Record 330;
        Amount: Decimal;
        Amount_LCY: Decimal;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Si el documento tiene una forma de pago que se liquida autom�ticamente, debemos reducir los importes de la retenci�n del total a pagar
        //                           No se puede hacer con el proceso anterior porque los importes no se pasan con VAR a la siguiente funci�n y se pierde el cambio
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF (SalesHeader."QB Prepayment Use" = SalesHeader."QB Prepayment Use"::Application) AND (SalesHeader."QB Prepayment Type" = SalesHeader."QB Prepayment Type"::Bill) THEN BEGIN
            Amount := 0;
            QBPrepaymentData.RESET;
            QBPrepaymentData.SETRANGE("Register No.", SalesHeader."QB Prepayment Data");
            IF (QBPrepaymentData.FINDSET(FALSE)) THEN
                REPEAT
                    Amount += QBPrepaymentData."To Apply Amount";
                UNTIL (QBPrepaymentData.NEXT = 0);


            IF SalesHeader."Currency Code" <> '' THEN BEGIN
                Amount_LCY := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date", SalesHeader."Currency Code", Amount, SalesHeader."Currency Factor"));
            END ELSE
                Amount_LCY := Amount;


            GenJnlLine.Amount -= (Amount);
            GenJnlLine."Amount (LCY)" -= (Amount_LCY);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterFinalizePostingOnBeforeCommit, '', true, true)]
    LOCAL PROCEDURE CU80_OnAfterFinalizePostingOnBeforeCommit(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; VAR GenJnlPostLine: Codeunit 12; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        QBPrepayment: Record 7206928;
        Nro: Integer;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 29/06/22: QB 1.10.57 Tras registrar un abono de venta de cancelaci�n de anticipo crear el registro en los anticipos
        //-------------------------------------------------------------------------------------------------------------------

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND (SalesHeader."QB Prepayment Use" = SalesHeader."QB Prepayment Use"::Prepayment) THEN BEGIN
            //Buscar el anticipo que se cancela
            QBPrepayment.RESET;
            QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Customer);
            QBPrepayment.SETRANGE("Document No.", SalesCrMemoHeader."Corrected Invoice No.");
            QBPrepayment.FINDFIRST;
            Nro := QBPrepayment."Entry No.";

            //Crear el registro que anula
            SalesCrMemoHeader.CALCFIELDS(Amount);
            QBPrepayment.INIT;
            QBPrepayment."Job No." := SalesCrMemoHeader."Job No.";
            QBPrepayment."Account Type" := QBP."Account Type"::Customer;
            QBPrepayment."Account No." := SalesCrMemoHeader."Sell-to Customer No.";
            QBPrepayment."Document No." := SalesCrMemoHeader."No.";
            QBPrepayment."Posting Date" := SalesCrMemoHeader."Posting Date";
            QBPrepayment."Document Date" := SalesCrMemoHeader."Document Date";
            QBPrepayment."Currency Code" := SalesCrMemoHeader."Currency Code";

            QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Cancelation;
            QBPrepayment.Description := SalesCrMemoHeader."Posting Description";
            ;
            QBPrepayment.VALIDATE(Amount, -SalesCrMemoHeader.Amount);
            QBPrepayment."Apply to Entry No." := Nro;
            QBPrepayment.INSERT(TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Page, 43, OnQueryClosePageEvent, '', true, true)]
    LOCAL PROCEDURE P43_OnQueryClosePageEvent(VAR Rec: Record 36; VAR AllowClose: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 29/06/22: QB 1.10.57 Si la factura es de anticipo, no dejar salir sin grabar o borrar para evitar problemas
        //-------------------------------------------------------------------------------------------------------------------
        // IF (Rec.FIND('=')) THEN  //Por si lo han borrado
        //  IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN BEGIN
        //    ERROR('La factura crea un anticipo, debe registrarla o eliminarla para poder salir de esta p�gina');
        //    AllowClose := FALSE;
        //  END;
    END;

    [EventSubscriber(ObjectType::Page, 44, OnQueryClosePageEvent, '', true, true)]
    LOCAL PROCEDURE P44_OnQueryClosePageEvent(VAR Rec: Record 36; VAR AllowClose: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 29/06/22: QB 1.10.57 Si el abono es de anticipo, no dejar salir sin grabar o borrar para evitar problemas
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec.FIND('=')) THEN  //Por si lo han borrado
            IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN BEGIN
                ERROR('El abono cancela un anticipo, debe registrarlo o eliminarlo para poder salir de esta p�gina');
                AllowClose := FALSE;
            END;
    END;

    PROCEDURE GenerateCustomerJournal(SalesInvoiceHeader: Record 112);
    VAR
        Customer: Record 18;
        GenJournalLine: Record 81;
        SourceCodeSetup: Record 242;
        QuoBuildingSetup: Record 7207278;
        GenJnlPostLine: Codeunit 12;
        QBPrepaymentData: Record 7206998;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Genera un pago y lo liquida contra la factura recien registrada
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 13/06/22: - QB 1.10.49 Se genera por cada l�nea que se ha aplicado

        Customer.GET(SalesInvoiceHeader."Bill-to Customer No.");
        SourceCodeSetup.GET;
        QuoBuildingSetup.GET;

        QBPrepaymentData.RESET;
        QBPrepaymentData.SETRANGE("Register No.", SalesInvoiceHeader."QB Prepayment Data");
        IF (QBPrepaymentData.FINDSET(FALSE)) THEN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                GenJournalLine."Document No." := SalesInvoiceHeader."No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                GenJournalLine.VALIDATE("Account No.", SalesInvoiceHeader."Bill-to Customer No.");
                GenJournalLine.Description := COPYSTR(QBPrepaymentData.Description, 1, MAXSTRLEN(GenJournalLine.Description));
                GenJournalLine."Posting Date" := SalesInvoiceHeader."Posting Date";
                GenJournalLine.VALIDATE("Currency Code", SalesInvoiceHeader."Currency Code");
                GenJournalLine."Currency Factor" := SalesInvoiceHeader."Currency Factor";

                //-Q20153
                //GenJournalLine.VALIDATE(Amount, -SalesInvoiceHeader."QB Prepayment Apply");
                GenJournalLine.VALIDATE(Amount, -QBPrepaymentData."To Apply Amount");
                //+Q20153
                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Customer;
                GenJournalLine."Source No." := SalesInvoiceHeader."Bill-to Customer No.";
                GenJournalLine."Dimension Set ID" := SalesInvoiceHeader."Dimension Set ID";
                GenJournalLine."Shortcut Dimension 1 Code" := SalesInvoiceHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := SalesInvoiceHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Source Code" := SourceCodeSetup.Sales;
                GenJournalLine."System-Created Entry" := TRUE;
                GenJournalLine."Due Date" := SalesInvoiceHeader."Due Date";
                GenJournalLine."Document Date" := SalesInvoiceHeader."Document Date";
                GenJournalLine."Bill-to/Pay-to No." := SalesInvoiceHeader."Sell-to Customer No.";

                //JMMA 24/01/20: - Se a�ade al diario el c�d. de proyecto
                GenJournalLine."QB Job No." := SalesInvoiceHeader."Job No.";

                //Aplicamos la l�nea a la factura para que la liquide
                GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
                GenJournalLine."Applies-to Doc. No." := SalesInvoiceHeader."No.";

                //Montar la contrapartida
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                //Q19607-
                IF QBPrepaymentData."Entry Type" = QBPrepaymentData."Entry Type"::Invoice THEN
                    GenJournalLine.VALIDATE("Bal. Account No.", GetSalesPrepaymentAccount(Customer."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"))
                ELSE
                    GenJournalLine.VALIDATE("Bal. Account No.", GetSalesPrepaymentAccount(Customer."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 1"));
                //GenJournalLine.VALIDATE("Bal. Account No.",  GetSalesPrepaymentAccount(Customer."Gen. Bus. Posting Group",QuoBuildingSetup."Prepayment Posting Group 2"));  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                //Q19607+

                CLEAR(GenJnlPostLine);
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            UNTIL (QBPrepaymentData.NEXT = 0);
    END;

    LOCAL PROCEDURE AddSalesInvoice(SalesInvoiceHeader: Record 112);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentData: Record 7206998;
        Entry: Integer;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Da de alta una factura de venta en el registro de anticipos del proyecto
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 13/06/22: - QB 1.10.49 Se genera por cada l�nea que se ha aplicado

        SalesInvoiceHeader.CALCFIELDS(Amount);

        CASE SalesInvoiceHeader."QB Prepayment Use" OF
            SalesInvoiceHeader."QB Prepayment Use"::Prepayment:
                BEGIN
                    QBPrepayment.INIT;
                    QBPrepayment."Job No." := SalesInvoiceHeader."Job No.";
                    QBPrepayment."Account Type" := QBP."Account Type"::Customer;
                    QBPrepayment."Account No." := SalesInvoiceHeader."Sell-to Customer No.";
                    QBPrepayment."Document No." := SalesInvoiceHeader."No.";
                    QBPrepayment."Posting Date" := SalesInvoiceHeader."Posting Date";
                    QBPrepayment."Document Date" := SalesInvoiceHeader."Document Date";
                    QBPrepayment."Currency Code" := SalesInvoiceHeader."Currency Code";

                    QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Invoice;
                    QBPrepayment.Description := STRSUBSTNO(Text000, Text005);
                    QBPrepayment.VALIDATE(Amount, SalesInvoiceHeader.Amount);

                    QBPrepayment.INSERT(TRUE);
                END;
            SalesInvoiceHeader."QB Prepayment Use"::Application:
                BEGIN
                    QBPrepaymentData.RESET;
                    QBPrepaymentData.SETRANGE("Register No.", SalesInvoiceHeader."QB Prepayment Data");
                    IF (QBPrepaymentData.FINDSET(FALSE)) THEN
                        REPEAT
                            QBPrepayment.INIT;
                            QBPrepayment."Job No." := SalesInvoiceHeader."Job No.";
                            QBPrepayment."Account Type" := QBP."Account Type"::Customer;
                            QBPrepayment."Account No." := SalesInvoiceHeader."Sell-to Customer No.";
                            QBPrepayment."Document No." := SalesInvoiceHeader."No.";
                            QBPrepayment."Posting Date" := SalesInvoiceHeader."Posting Date";
                            QBPrepayment."Document Date" := SalesInvoiceHeader."Document Date";
                            QBPrepayment."Currency Code" := SalesInvoiceHeader."Currency Code";

                            QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Application;
                            QBPrepayment.Description := QBPrepaymentData.Description;
                            QBPrepayment.VALIDATE(Amount, -QBPrepaymentData."To Apply Amount");
                            //-Q19985
                            QBPrepayment."Apply to Entry No." := QBPrepaymentData."Entry No.";
                            //+Q19985
                            QBPrepayment.INSERT(TRUE);
                        UNTIL (QBPrepaymentData.NEXT = 0);
                END;
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Calculo de anticipos en los documentos de Venta"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T36_OnAfterInsertEvent(VAR Rec: Record 36; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19: - Se recalculan las anticipos al insertar un registro
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN
            CreatePrepayment_SalesLines(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T36_OnAfterModifyEvent(VAR Rec: Record 36; VAR xRec: Record 36; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19 - Se recalculan las anticipos al modificar un registro
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN
            CreatePrepayment_SalesLines(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T36_OnBeforeDeleteEvent(VAR Rec: Record 36; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19 - Se eliminan los anticipos al borrar un registro
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN
            DeletePrepayment_SalesLines(ConvertDocumentTypeToOptionSalesDocumentType(Rec."Document Type"), Rec."No.");

    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "Sell-to Customer No.", true, true)]
    LOCAL PROCEDURE T36_OnBeforeValidateEvent_SellToCustomerNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19 - Si cambia el cliente limpiamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."Sell-to Customer No." <> xRec."Sell-to Customer No.") AND (xRec."Sell-to Customer No." <> '') THEN
            SalesValidateFields(Rec, Text005);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_SellToCustomerNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al validar el cliente ver si tiene anticipos
        //-------------------------------------------------------------------------------------------------------------------
        GenerateSalesPrepaymentAmount(Rec, xRec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE T36_OnBeforeValidateEvent_QBJobNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19 - Si cambia el proyecto limpiamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."Sell-to Customer No." <> xRec."Sell-to Customer No.") AND (xRec."Sell-to Customer No." <> '') THEN
            SalesValidateFields(Rec, Text007);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_QBJobNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al validar el proyecto ver si tiene anticipos
        //-------------------------------------------------------------------------------------------------------------------
        GenerateSalesPrepaymentAmount(Rec, xRec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "Currency Code", true, true)]
    LOCAL PROCEDURE T36_OnBeforeValidateEvent_CurrencyCode(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Si cambia la divisa limpiamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."Currency Code" <> xRec."Currency Code") AND (xRec."Currency Code" <> '') THEN
            SalesValidateFields(Rec, Text008);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Currency Code", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_CurrencyCode(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al validar la divisa ver si tiene anticipos
        //-------------------------------------------------------------------------------------------------------------------
        GenerateSalesPrepaymentAmount(Rec, xRec, TRUE);
    END;

    LOCAL PROCEDURE SalesValidateFields(VAR Rec: Record 36; pField: Text);
    VAR
        QBPrepaymentData: Record 7206998;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: QB 1.10.24 Si cambia un campo de anticipo hay que confirmar si se pierde el anticipo
        //-------------------------------------------------------------------------------------------------------------------

        //JAV 12/03/21: - QB 1.10.24 Si no procesamos no hay que hacer nada
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::DontProcess) THEN
            EXIT;

        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN
            ERROR(Text009, pField);

        IF (Rec."QB Prepayment Apply" <> 0) THEN BEGIN
            IF (CONFIRM(Text010, FALSE, pField)) THEN BEGIN
                Rec."QB Prepayment Apply" := 0;
                Rec."QB Prepayment Type" := Rec."QB Prepayment Type"::No;
                IF (Rec."QB Prepayment Data" <> 0) THEN BEGIN
                    QBPrepaymentData.RESET;
                    QBPrepaymentData.SETRANGE("Register No.", Rec."QB Prepayment Data");
                    QBPrepaymentData.DELETEALL;
                END;
            END ELSE BEGIN
                ERROR(Text011);
            END;
        END;
    END;

    PROCEDURE GenerateSalesPrepaymentAmount(VAR SalesHeader: Record 36; xSalesHeader: Record 36; pConfirm: Boolean);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentEdit: Page 7207281;
        BaseAmount: Decimal;
        PrepmtAmount: Decimal;
        Txt001: TextConst ESP = 'El cliente tiene un anticipo pendiente de liquidar, �desea descontarlo de la factura?';
        Description: Text;
        Type: Option;
        Ok: Boolean;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Desde una factura de venta, busca si hay un anticipo que se pueda aplicar al cliente
        //-------------------------------------------------------------------------------------------------------------------

        //JAV 29/11/21: - QB 1.10.02 Solo se aplican los anticipos a las facturas
        IF (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) THEN
            EXIT;

        //JAV 12/03/21: - QB 1.10.24 Si no procesamos o es la factura de anticipo no hay que hacer nada
        IF (SalesHeader."QB Prepayment Use" IN [SalesHeader."QB Prepayment Use"::DontProcess, SalesHeader."QB Prepayment Use"::Prepayment]) THEN
            EXIT;

        //JAV 12/03/22: - QB 1.10.24 Verificar cambios en el registro antes de comenzar
        T36_OnBeforeValidateEvent_QBJobNo(SalesHeader, xSalesHeader, 0);
        T36_OnBeforeValidateEvent_SellToCustomerNo(SalesHeader, xSalesHeader, 0);
        T36_OnBeforeValidateEvent_CurrencyCode(SalesHeader, xSalesHeader, 0);

        IF (SalesHeader."Sell-to Customer No." = '') OR (SalesHeader."QB Job No." = '') THEN   //Debe tener cliente y proyecto
            EXIT;

        //Busco si tiene un importe de anticipo pendiente, si no lo hay salimos
        SalesHeader.CALCFIELDS("QB Prepayment Pending");
        IF (SalesHeader."QB Prepayment Pending" = 0) THEN
            EXIT;

        //Pido confirmaci�n para aplicar el anticipo
        IF pConfirm THEN
            Ok := CONFIRM(Txt001, TRUE)
        ELSE
            Ok := TRUE;

        IF (Ok) THEN BEGIN
            COMMIT; //Para el RunModal es necesario

            //JAV 14/06/22: - QB 1.10.49 Cambios para tratar los anticipos de manera individual
            CLEAR(QBPrepaymentEdit);
            QBPrepaymentEdit.SetAplicacion(SalesHeader."QB Prepayment Data", SalesHeader."QB Job No.", QBP."Account Type"::Customer, SalesHeader."Sell-to Customer No.", SalesHeader."Currency Code");
            QBPrepaymentEdit.LOOKUPMODE(TRUE);
            IF QBPrepaymentEdit.RUNMODAL = ACTION::LookupOK THEN BEGIN
                QBPrepaymentEdit.GetApplication(SalesHeader."QB Prepayment Data", BaseAmount, PrepmtAmount, Type);
                IF (PrepmtAmount <> 0) THEN BEGIN
                    SalesHeader."QB Prepayment Apply" := PrepmtAmount;
                    SalesHeader."QB Prepayment Type" := Type;
                    SalesHeader.VALIDATE("QB Prepayment Use", SalesHeader."QB Prepayment Use"::Application);
                END ELSE BEGIN
                    SalesHeader."QB Prepayment Apply" := 0;
                    SalesHeader."QB Prepayment Type" := SalesHeader."QB Prepayment Type"::No;
                    SalesHeader.VALIDATE("QB Prepayment Use", SalesHeader."QB Prepayment Use"::No);
                END;
                SalesHeader.MODIFY;
                CreatePrepayment_SalesLines(SalesHeader);
            END;
        END;

        //Revisar el importe del anticipo aplicado sobre el posible por si ha cambiado
        SalesHeader.CALCFIELDS("QB Prepayment Pending");
        IF (SalesHeader."QB Prepayment Apply" > SalesHeader."QB Prepayment Pending") THEN
            SalesHeader."QB Prepayment Apply" := SalesHeader."QB Prepayment Pending";
    END;

    LOCAL PROCEDURE GetSalesPrepaymentAccount(GR1: Code[20]; GR2: Code[20]): Code[20];
    VAR
        GenPostingSetup: Record 252;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Retorna la cuenta para anticipos de venta
        //-------------------------------------------------------------------------------------------------------------------
        IF (GR1 = '') THEN
            ERROR('No ha definido el grupo registro General en la cabecera');

        IF (GR2 = '') THEN
            ERROR('No ha definido el grupo registro de prepagos');

        GenPostingSetup.GET(GR1, GR2);
        EXIT(GenPostingSetup.GetSalesPrepmtAccount);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE T37_OnBeforeModifyEvent(VAR Rec: Record 37; VAR xRec: Record 37; RunTrigger: Boolean);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar modificar la l�nea del anticipo, campos que afectan a los importes o las retenciones
        //-------------------------------------------------------------------------------------------------------------------

        IF (RunTrigger) AND (Rec."QB Prepayment Line") THEN
            IF (Rec.Amount <> xRec.Amount) OR (NOT Rec."QW Not apply Withholding by GE") OR (NOT Rec."QW Not apply Withholding PIT") THEN
                ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T37_OnBeforeDeleteEvent(VAR Rec: Record 37; RunTrigger: Boolean);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar borrar la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) AND (Rec."QB Prepayment Line") THEN
            ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnBeforeValidateEvent, Type, true, true)]
    LOCAL PROCEDURE T37_OnBeforeValidateEvent_Type(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar modificar la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Line") AND (Rec.Type <> xRec.Type) THEN
            ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnBeforeValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE T37_OnBeforeValidateEvent_No(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar modificar la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Line") AND (Rec."No." <> xRec."No.") THEN
            ERROR(Text001);
    END;

    PROCEDURE CreatePrepayment_SalesLines(SalesHeader: Record 36): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
        WithholdingGroup: Record 7207330;
        Job: Record 167;
        Currency: Record 4;
        SalesLine: Record 37;
        NLine1: Integer;
        NLine2: Integer;
        bAux: Boolean;
        oldStatus: Option;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/08/19: - Funci�n que a�ade o modifica la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        QuoBuildingSetup.GET();
        IF NOT Job.GET(SalesHeader."QB Job No.") THEN
            EXIT;

        //JAV 12/03/21: - QB 1.10.24 Si no procesamos o no est� abierto no podemos a�adir nada al documento
        IF (SalesHeader."QB Prepayment Use" = SalesHeader."QB Prepayment Use"::DontProcess) OR (SalesHeader.Status <> SalesHeader.Status::Open) THEN
            EXIT;

        SalesHeader.CALCFIELDS("QB Prepayment Pending");
        IF (NOT Currency.GET(SalesHeader."Currency Code")) THEN
            CLEAR(Currency);
        Currency.InitRoundingPrecision;


        //Guardo el estado y lo cambio a abierto
        oldStatus := ConvertDocumentTypeToOptionSalesDocumentStatus(SalesHeader.Status);
        SalesHeader.Status := SalesHeader.Status::Open;
        SalesHeader.MODIFY;

        //Borro las l�neas de la retenci�n si las tuviera
        DeletePrepayment_SalesLines(ConvertDocumentTypeToOptionSalesDocumentType(SalesHeader."Document Type"), SalesHeader."No.");

        CASE SalesHeader."QB Prepayment Type" OF
            SalesHeader."QB Prepayment Type"::Invoice:
                BEGIN
                    //Si hay importe, creo la l�nea
                    IF (SalesHeader."QB Prepayment Apply" <> 0) THEN BEGIN
                        //Busco la primera l�nea
                        SalesLine.RESET;
                        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                        IF SalesLine.FINDFIRST THEN BEGIN
                            NLine1 := ROUND(SalesLine."Line No." / 2, 1);
                            NLine2 := NLine1 + 1;
                        END ELSE BEGIN
                            NLine1 := 10000;
                            NLine2 := 20000;
                        END;

                        //Creo la l�nea del anticipo
                        SalesLine.INIT;
                        SalesLine."Document Type" := SalesHeader."Document Type";
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := NLine1;
                        SalesLine.Type := SalesLine.Type::"G/L Account";
                        SalesLine.VALIDATE("No.", GetSalesPrepaymentAccount(SalesHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"));  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                        SalesLine.VALIDATE("Gen. Bus. Posting Group", SalesHeader."Gen. Bus. Posting Group");
                        SalesLine.VALIDATE("Gen. Prod. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2");  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                        SalesLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
                        SalesLine.Description := SalesHeader."Posting Description";
                        SalesLine.VALIDATE(Quantity, -1);
                        SalesLine.VALIDATE("Unit Price", ROUND(SalesHeader."QB Prepayment Apply", Currency."Amount Rounding Precision"));
                        SalesLine."QW Not apply Withholding by GE" := TRUE;
                        SalesLine."QW Not apply Withholding PIT" := TRUE;
                        SalesLine."QB Prepayment Line" := TRUE;
                        SalesLine.INSERT(FALSE);

                        //Separador
                        bAux := (SalesLine.Type = SalesLine.Type::" ") AND (SalesLine."No." = '');  //Para no meter mas separadores de la cuenta
                        IF (NOT bAux) THEN BEGIN
                            SalesLine.INIT;
                            SalesLine."Document Type" := SalesHeader."Document Type";
                            SalesLine."Document No." := SalesHeader."No.";
                            SalesLine."Line No." := NLine2;
                            SalesLine.Type := SalesLine.Type::" ";
                            SalesLine."QB Prepayment Line" := TRUE;
                            SalesLine.INSERT(FALSE);
                        END;
                    END;
                    EXIT(TRUE)
                END;
        //Q13154 -
        //SalesHeader."QB Prepayment Type"::Bill :  //No hay que hacer nada aqu�, solo en el momento del registro
        //Q13154 +
        END;

        //Recupero el estado
        SalesHeader.Status := Enum::"Sales Document Status".FromInteger(oldStatus); //option to enum
        SalesHeader.MODIFY;
    END;

    PROCEDURE DeletePrepayment_SalesLines(SalesHeaderType: Option; SalesHeaderNo: Code[20]);
    VAR
        SalesLine: Record 37;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/08/19: - Funci�n que borra las l�neas del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeaderType);
        SalesLine.SETRANGE("Document No.", SalesHeaderNo);
        SalesLine.SETRANGE("QB Prepayment Line", TRUE);
        SalesLine.DELETEALL(FALSE)
    END;

    [EventSubscriber(ObjectType::Page, 43, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE PG43_OnOpenPageEvent(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Si abrimos la p�gina de una factura de venta, quitar la marca de no procesar anticipos
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::DontProcess) THEN BEGIN
            Rec."QB Prepayment Use" := Rec."QB Prepayment Use"::No;
            Rec.MODIFY;
        END;

        //JAV 01/06/22: - QB 1.10.46 Si ya tiene un anticipo aplicado, solo se informa al abrir el documento
        IF (Rec."QB Prepayment Apply" <> 0) THEN
            MESSAGE('El documento tiene aplicado un anticipo por importe de %1', Rec."QB Prepayment Apply")
        ELSE
            GenerateSalesPrepaymentAmount(Rec, Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 43, OnBeforeActionEvent, Post, true, true)]
    LOCAL PROCEDURE PG43_OnBeforeActionEvent_Post(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 43, OnBeforeActionEvent, PostAndNew, true, true)]
    LOCAL PROCEDURE PG43_OnBeforeActionEvent_PostAndNew(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 43, OnBeforeActionEvent, PostAndSend, true, true)]
    LOCAL PROCEDURE PG43_OnBeforeActionEvent_PostAndSend(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 43, OnBeforeActionEvent, Preview, true, true)]
    LOCAL PROCEDURE PG43_OnBeforeActionEvent_Preview(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 9301, OnBeforeActionEvent, Post, true, true)]
    LOCAL PROCEDURE PG9301_OnBeforeActionEvent_Post(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 9301, OnBeforeActionEvent, PostAndSend, true, true)]
    LOCAL PROCEDURE PG9301_OnBeforeActionEvent_PostAndSend(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 9301, OnBeforeActionEvent, Preview, true, true)]
    LOCAL PROCEDURE PG9301_OnBeforeActionEvent_Preview(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        SalesPage_VerifyPrepayment(Rec);
    END;

    LOCAL PROCEDURE SalesPage_VerifyPrepayment(VAR Rec: Record 36);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/21: - QB 1.10.24 Si no est� abierto no podemos a�adir nada al documento
        IF (Rec.Status <> Rec.Status::Open) THEN
            EXIT;

        IF (Rec."QB Prepayment Apply" = 0) THEN BEGIN
            GenerateSalesPrepaymentAmount(Rec, Rec, TRUE);
            COMMIT;  //Guardamos por si luego se cancela el proceso
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Funciones para proveedores"();
    BEGIN
    END;

    PROCEDURE AccessToVendorPrepayment(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
        PrepmtPostingGrpErr: TextConst ENU = 'The %1 has not been defined.', ESP = 'El %1 no ha sido definido.';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Verifica si se tiene acceso a los prepagos de proveedores, retorna true o false
        //-------------------------------------------------------------------------------------------------------------------

        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            QuoBuildingSetup.GET;
            IF QuoBuildingSetup."Use Vendor Prepayment" THEN BEGIN
                //JAV 27/06/22: - QB 1.10.55 Se a�ade el manejo de "Prepayment Posting Group 1" para efectos y "Prepayment Posting Group 2" para Fras
                IF QuoBuildingSetup."Prepayment Posting Group 1" = '' THEN
                    ERROR(STRSUBSTNO(PrepmtPostingGrpErr, QuoBuildingSetup.FIELDCAPTION("Prepayment Posting Group 1")));
                IF QuoBuildingSetup."Prepayment Posting Group 2" = '' THEN
                    ERROR(STRSUBSTNO(PrepmtPostingGrpErr, QuoBuildingSetup.FIELDCAPTION("Prepayment Posting Group 2")));
                EXIT(QuoBuildingSetup."Use Vendor Prepayment");
            END;
        END;
        //Q12879 +
    END;

    PROCEDURE AccessToVendorPrepaymentError();
    VAR
        QBModuleActErr: TextConst ENU = 'This QuoBuilding''s module is not active.', ESP = 'Este m�duclo de QuoBuilding no est� activo.';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Verifica si se tiene acceso a los prepagos de proveedores, si no da un error
        //-------------------------------------------------------------------------------------------------------------------

        //Q12879 -
        IF NOT AccessToVendorPrepayment THEN
            ERROR(QBModuleActErr);
        //Q12879 +
    END;

    PROCEDURE SeeJobVendor(JobNo: Code[20]);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentList: Page 7207280;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Ver los anticipos de proveedores de un proyecto
        //-------------------------------------------------------------------------------------------------------------------

        //Q12879 -
        AccessToVendorPrepayment;

        QBPrepayment.RESET;
        QBPrepayment.FILTERGROUP(2);
        QBPrepayment.SETRANGE("Job No.", JobNo);
        QBPrepayment.SETRANGE("Account Type", QBP."Account Type"::Vendor);
        PAGE.RUNMODAL(PAGE::"QB Job Prepayment List", QBPrepayment);
    END;

    PROCEDURE CreatePurchaseInvoice(VAR QBPrepayment: Record 7206928);
    VAR
        PurchaseSetup: Record 312;
        QBApprovalsSetup: Record 7206994;
        ApprovalEntry: Record 454;
        Job: Record 167;
        PurchaseHeader: Record 38;
        PurchaseHeaderList: Record 38;
        PurchaseLine: Record 39;
        QuoBuildingSetup: Record 7207278;
        PurchaseInvoice: Page 51;
        ApprovalPurchaseInvoice: Codeunit 7206913;
        QBApprovalManagement: Codeunit 7207354;
        NoSeriesMgt: Codeunit 396;
        PurchPost: Codeunit 90;
        GLAccNo: Code[20];
        LineNo: Integer;
        i: Integer;
        Text002: TextConst ENU = 'Job %1 prepayment to %2', ESP = 'Anticipo proyecto %1 para %2';
        QBPrepaymentEdit: Page 7207281;
        GLAccount: Record 15;
        Withholdingtreating: Codeunit 7207306;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Crear un documento de tipo Factura de compra
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.35 Pedir la fecha de registro antes de generar la factura
        CLEAR(QBPrepaymentEdit);
        QBPrepaymentEdit.SetPost(QBPrepayment."Job No.", QBPrepayment."Account Type", QBPrepayment."Account No.", FORMAT(QBPrepayment."Generate Document"), QBPrepayment."Not Approved Amount",
                                 //Q18899-
                                 QBPrepayment."Payment Terms Code", QBPrepayment."Document Date", QBPrepayment."Posting Date");
        //QBPrepayment."Payment Terms Code");  //JAV 20/04/22: - QB 1.10.36 Se incluye el t�rmino de pago para el c�lculo del vencimiento
        //Q18899+
        QBPrepaymentEdit.LOOKUPMODE(TRUE);
        IF (QBPrepaymentEdit.RUNMODAL <> ACTION::LookupOK) THEN
            EXIT;

        //JAV 20/04/22: - QB 1.10.36 Se ampl�an los par�metros de registro con fecha de registro, fecha del documento, t�mino de pago y fecha de vencimiento
        QBPrepaymentEdit.GetPost(QBPrepayment."Posting Date", QBPrepayment."Document Date", QBPrepayment."Payment Terms Code", QBPrepayment."Due Date");
        QBPrepayment.MODIFY(TRUE);


        QuoBuildingSetup.GET();
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
        Job.GET(QBPrepayment."Job No.");
        Job.TESTFIELD("VAT Prod. PostingGroup");

        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader."Document Date" := QBPrepayment."Document Date";
        PurchaseHeader.VALIDATE("Posting Date", QBPrepayment."Posting Date");
        PurchaseHeader.VALIDATE("Document Date");
        PurchaseHeader."QB Prepayment Use" := PurchaseHeader."QB Prepayment Use"::Prepayment;
        PurchaseHeader.INSERT(TRUE);

        PurchaseHeader.VALIDATE("Buy-from Vendor No.", QBPrepayment."Account No.");
        PurchaseHeader.VALIDATE("QB Job No.", QBPrepayment."Job No.");
        PurchaseHeader.VALIDATE("Currency Code", QBPrepayment."Currency Code");
        PurchaseHeader."Posting No." := NoSeriesMgt.GetNextNo(PurchaseSetup."Posted Prepmt. Inv. Nos.", PurchaseHeader."Posting Date", TRUE);
        PurchaseHeader."Posting Description" := COPYSTR(STRSUBSTNO(Text002, QBPrepayment."Job No.", QBPrepayment."Account No."), 1, MAXSTRLEN(PurchaseHeader."Posting Description"));
        PurchaseHeader.VALIDATE("Payment Discount %", 0);  //No puede tener descuentos adicionales
        PurchaseHeader.VALIDATE("VAT Base Discount %", 0);  //No puede tener descuentos adicionales
        PurchaseHeader."Vendor Invoice No." := QBPrepayment."External Document No."; //JAV 04/04/22: - QB 1.10.31 Se informa del documento externo

        //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�ge, m�todo de pago y fecha de vencimiento
        PurchaseHeader.VALIDATE("Document Date", QBPrepayment."Document Date"); //Q18899
        PurchaseHeader."Payment Method Code" := QBPrepayment."Payment Method Code";
        PurchaseHeader."Payment Terms Code" := QBPrepayment."Payment Terms Code";
        PurchaseHeader."Due Date" := QBPrepayment."Due Date";

        PurchaseHeader.MODIFY(TRUE);

        LineNo := 10000;

        PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := LineNo;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.VALIDATE("No.", GetPurchasePrepaymentAccount(PurchaseHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"));  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
        PurchaseLine.VALIDATE("Gen. Bus. Posting Group", PurchaseHeader."Gen. Bus. Posting Group");
        //Q18899-
        IF (GLAccount.GET(GetPurchasePrepaymentAccount(PurchaseHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"))) AND
           (GLAccount."Gen. Prod. Posting Group" <> '') THEN
            PurchaseLine.VALIDATE("Gen. Prod. Posting Group", GLAccount."Gen. Prod. Posting Group")
        ELSE
            //Q18899+
            PurchaseLine.VALIDATE("Gen. Prod. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2");  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                                                                                                               //Q18899-
        IF (GLAccount.GET(GetPurchasePrepaymentAccount(PurchaseHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"))) AND
           (GLAccount."VAT Prod. Posting Group" <> '') THEN
            PurchaseLine.VALIDATE("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting Group")
        ELSE
            //Q18899+
            PurchaseLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
        PurchaseLine.Description := COPYSTR(QBPrepayment."Description Line 1", 1, MAXSTRLEN(PurchaseLine.Description));
        PurchaseLine.VALIDATE(Quantity, 1);
        PurchaseLine.VALIDATE("Direct Unit Cost", QBPrepayment."Not Approved Amount");
        PurchaseLine.VALIDATE("Job No.", QBPrepayment."Job No.");
        PurchaseLine.INSERT(TRUE);
        //-Q19834
        Withholdingtreating.CalculateWithholding_PurchaseLine(PurchaseLine, FALSE);  //Para que calcule las retenciones
        PurchaseLine.MODIFY;
        //+Q19834


        REPEAT
            LineNo += 10000;
            PurchaseLine.INIT;
            PurchaseLine."Document Type" := PurchaseHeader."Document Type";
            PurchaseLine."Document No." := PurchaseHeader."No.";
            PurchaseLine."Line No." := LineNo;

            IF (STRLEN(QBPrepayment."Description Line 2") < MAXSTRLEN(PurchaseLine.Description)) THEN BEGIN
                PurchaseLine.Description := QBPrepayment."Description Line 2";
                PurchaseLine.INSERT(TRUE);
                QBPrepayment."Description Line 2" := '';
            END ELSE BEGIN
                i := MAXSTRLEN(PurchaseLine.Description) + 1;
                REPEAT
                    i -= 1;
                UNTIL (COPYSTR(QBPrepayment."Description Line 2", i, 1) = ' ');
                PurchaseLine.Description := COPYSTR(QBPrepayment."Description Line 2", 1, i - 1);
                PurchaseLine.INSERT(TRUE);
                //-Q19834
                Withholdingtreating.CalculateWithholding_PurchaseLine(PurchaseLine, FALSE);  //Para que calcule las retenciones
                PurchaseLine.MODIFY;
                //+Q19834
                QBPrepayment."Description Line 2" := COPYSTR(QBPrepayment."Description Line 2", i + 1);
            END;
        UNTIL QBPrepayment."Description Line 2" = '';
        //JAV 10/04/22: - QB 1.10.34 Pasar la aprobaci�n del anticipo al documento generado.
        //JAV 20/04/22: - QB 1.10.36 Se cambia de lugar para crear primero las l�neas
        IF (QBApprovalsSetup.GET) THEN BEGIN
            IF (QBApprovalsSetup."Send App. Prepayment to Doc.") AND (QBPrepayment."Approval Status" = QBPrepayment."Approval Status"::Released) THEN BEGIN
                PurchaseHeader.Status := PurchaseHeader.Status::Released;
                PurchaseHeader.MODIFY(FALSE);
                IF (ApprovalPurchaseInvoice.IsApprovalsWorkflowEnabled(PurchaseHeader)) THEN
                    //-17368 DGG Se a�ade par�metro
                    //QBApprovalManagement.CopyApprovalChain(QBPrepayment.RECORDID, PurchaseHeader.RECORDID, ApprovalEntry."QB Document Type"::PurchaseInvoice);
                    QBApprovalManagement.CopyApprovalChain(QBPrepayment.RECORDID, PurchaseHeader.RECORDID, ApprovalEntry."QB Document Type"::PurchaseInvoice, PurchaseHeader."No.");
                //+
            END;
        END;

        //Guardar el nro de la factura en el anticipo
        QBPrepayment."Document No." := PurchaseHeader."No.";
        QBPrepayment.MODIFY(TRUE);

        COMMIT;

        //Presentar la factura creada
        PurchaseHeaderList.RESET;
        PurchaseHeaderList.SETRANGE("No.", PurchaseHeader."No.");

        CLEAR(PurchaseInvoice);
        PurchaseInvoice.SETTABLEVIEW(PurchaseHeaderList);
        PurchaseInvoice.RUNMODAL;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnAfterDeleteEvent(VAR Rec: Record 38; RunTrigger: Boolean);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 31/03/22: - QB 1.10.29 Si se elimina una factura, quitarla de anticipos pendientes
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN BEGIN
            QBPrepayment.RESET;
            QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Vendor);
            QBPrepayment.SETRANGE("Account No.", Rec."Buy-from Vendor No.");
            QBPrepayment.SETRANGE("Document No.", Rec."No.");
            QBPrepayment.SETRANGE("Generate Document", QBPrepayment."Generate Document"::Invoice);
            IF (QBPrepayment.FINDFIRST) THEN BEGIN
                QBPrepayment."Document No." := '';
                QBPrepayment.MODIFY(TRUE);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostPurchaseDoc(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        Amount: Decimal;
        Txt: Text;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Verificar que el importe total del documento no supere el anticipo a descontar antes de registrar
        //-------------------------------------------------------------------------------------------------------------------
        Txt := '';
        CASE PurchaseHeader."QB Prepayment Type" OF
            PurchaseHeader."QB Prepayment Type"::Invoice:
                BEGIN
                    PurchaseHeader.CALCFIELDS(Amount);
                    IF (PurchaseHeader.Amount < 0) THEN
                        Txt := Text003;
                END;
            PurchaseHeader."QB Prepayment Type"::Bill:
                BEGIN
                    PurchaseHeader.CALCFIELDS("Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");
                    Amount := PurchaseHeader."Amount Including VAT" - PurchaseHeader."QW Total Withholding PIT" - PurchaseHeader."QW Total Withholding GE";
                    IF (PurchaseHeader."QB Prepayment Apply" > Amount) THEN
                        Txt := Text004;
                END;
        END;

        IF (Txt <> '') THEN
            IF PreviewMode THEN
                MESSAGE(Txt)
            ELSE
                ERROR(Txt);
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostVendorEntry, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostVendorEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; CommitIsSupressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    VAR
        PurchInvHeader: Record 122;
        QBPrepayment: Record 7206928;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Esta funci�n se lanza tras registrar el importe del proveedor en el diario, aqu� la capturamos para descontar el anticipo
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //Solo tiene sentido para facturas de compra, los abonos no pueden generar anticipo mas que con su cancelaci�n, que se trata en otro lugar
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) THEN BEGIN
            IF PurchHeader."No. Series" <> PurchHeader."Posting No. Series" THEN
                PurchHeader."Last Posting No." := PurchHeader."Posting No."
            ELSE
                PurchHeader."Last Posting No." := PurchHeader."No.";

            IF (PurchInvHeader.GET(PurchHeader."Last Posting No.")) THEN BEGIN
                CASE PurchInvHeader."QB Prepayment Use" OF
                    PurchInvHeader."QB Prepayment Use"::Prepayment:
                        //Si es con factura Cambiar el nro de documento del anticipo y el importe de campo
                        BEGIN
                            QBPrepayment.RESET;
                            QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Vendor);
                            QBPrepayment.SETRANGE("Account No.", PurchHeader."Buy-from Vendor No.");
                            QBPrepayment.SETRANGE("Document No.", PurchHeader."No.");
                            QBPrepayment.SETRANGE("Generate Document", QBPrepayment."Generate Document"::Invoice);
                            IF (QBPrepayment.FINDFIRST) THEN BEGIN
                                QBPrepayment.Description := PurchInvHeader."Posting Description";
                                QBPrepayment."Document No." := PurchInvHeader."No.";
                                QBPrepayment.Amount := QBPrepayment."Not Approved Amount";
                                QBPrepayment."Amount (LCY)" := QBPrepayment."Not Approved Amount (LCY)";
                                QBPrepayment."Not Approved Amount" := 0;
                                QBPrepayment."Not Approved Amount (LCY)" := 0;
                                QBPrepayment.MODIFY(TRUE);
                            END;
                        END;
                    PurchInvHeader."QB Prepayment Use"::Application:
                        BEGIN
                            //Si es un efecto hay que liquidarlo contra la factura
                            IF (PurchInvHeader."QB Prepayment Type" = PurchInvHeader."QB Prepayment Type"::Bill) THEN
                                GenerateVendorJournal(PurchInvHeader);
                            //A�adir el documento a los anticipos
                            AddPurchaseInvoice(PurchInvHeader);
                        END;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostBalancingEntry, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        QBPrepaymentData: Record 7206998;
        CurrencyExRate: Record 330;
        Amount: Decimal;
        Amount_LCY: Decimal;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Si el documento tiene una forma de pago que se liquida autom�ticamente, debemos reducir los importes del anticipo con efecto del total a pagar
        //                           No se puede hacer con el proceso anterior porque los importes no se pasan con VAR a la siguiente funci�n y se pierde el cambio
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF (PurchHeader."QB Prepayment Use" = PurchHeader."QB Prepayment Use"::Application) AND (PurchHeader."QB Prepayment Type" = PurchHeader."QB Prepayment Type"::Bill) THEN BEGIN
            Amount := 0;
            QBPrepaymentData.RESET;
            QBPrepaymentData.SETRANGE("Register No.", PurchHeader."QB Prepayment Data");
            IF (QBPrepaymentData.FINDSET(FALSE)) THEN
                REPEAT
                    Amount += QBPrepaymentData."To Apply Amount";
                UNTIL (QBPrepaymentData.NEXT = 0);


            IF PurchHeader."Currency Code" <> '' THEN BEGIN
                Amount_LCY := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date", PurchHeader."Currency Code", Amount, PurchHeader."Currency Factor"));
            END ELSE
                Amount_LCY := Amount;


            GenJnlLine.Amount -= (Amount);
            GenJnlLine."Amount (LCY)" -= (Amount_LCY);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterFinalizePostingOnBeforeCommit, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterFinalizePostingOnBeforeCommit(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShptHeader: Record 6650; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        PurchCrMemoLine: Record 125;
        QBPrepayment: Record 7206928;
        Job: Record 167;
        Nro: Integer;
        PurchPost: Codeunit 90;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 29/06/22: QB 1.10.57 Tras registrar un abono de compra de cancelaci�n de anticipo crear el registro en los anticipos
        //-------------------------------------------------------------------------------------------------------------------

        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") AND (PurchHeader."QB Prepayment Use" = PurchHeader."QB Prepayment Use"::Prepayment) THEN BEGIN
            //Buscar el anticipo que se cancela
            QBPrepayment.RESET;
            //JAV 08/11/22: - QB 1.12.16 Error al cancelar anticipo de compra, usaba cliente en lugar de proveedor
            //QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Customer);
            QBPrepayment.SETRANGE("Account Type", QBPrepayment."Account Type"::Vendor);
            QBPrepayment.SETRANGE("Document No.", PurchCrMemoHdr."Corrected Invoice No.");
            QBPrepayment.FINDFIRST;
            Nro := QBPrepayment."Entry No.";

            //Crear el registro que anula
            PurchCrMemoHdr.CALCFIELDS(Amount);
            QBPrepayment.INIT;
            QBPrepayment."Job No." := PurchCrMemoHdr."Job No.";
            //JAV 08/11/22: - QB 1.12.16 Error al cancelar anticipo de compra, usaba cliente en lugar de proveedor
            //QBPrepayment."Account Type" := QBP."Account Type"::Customer;
            //QBPrepayment."Account No." := PurchCrMemoHdr."Sell-to Customer No.";
            QBPrepayment."Account Type" := QBP."Account Type"::Vendor;
            QBPrepayment."Account No." := PurchCrMemoHdr."Buy-from Vendor No.";

            QBPrepayment."Document No." := PurchCrMemoHdr."No.";
            QBPrepayment."Posting Date" := PurchCrMemoHdr."Posting Date";
            QBPrepayment."Document Date" := PurchCrMemoHdr."Document Date";
            QBPrepayment."Currency Code" := PurchCrMemoHdr."Currency Code";
            QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Cancelation;

            //JAV 08/11/22: - QB 1.12.16 Cambiar la descripci�n en el movimiento del anticipo para que sea mas informativa
            PurchCrMemoLine.RESET;
            PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHdr."No.");
            IF PurchCrMemoLine.FINDFIRST THEN
                QBPrepayment.Description := PurchCrMemoLine.Description
            ELSE
                QBPrepayment.Description := PurchCrMemoHdr."Posting Description";

            //JAV 09/11/22: - QB 1.12.16 Poner la descripci�n del proyecto
            IF (Job.GET(QBPrepayment."Job No.")) THEN
                QBPrepayment."Job Descripcion" := Job.Description;

            QBPrepayment.VALIDATE(Amount, -PurchCrMemoHdr.Amount);
            QBPrepayment."Apply to Entry No." := Nro;
            QBPrepayment.INSERT(TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Page, 51, OnQueryClosePageEvent, '', true, true)]
    LOCAL PROCEDURE P51_OnQueryClosePageEvent(VAR Rec: Record 38; VAR AllowClose: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 29/06/22: QB 1.10.57 Si la factura es de anticipo, no dejar salir sin grabar o borrar para evitar problemas
        //-------------------------------------------------------------------------------------------------------------------
        // IF (Rec.FIND('=')) THEN  //Por si lo han borrado
        //  IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN BEGIN
        //    ERROR('La factura crea un anticipo, debe registrarla o eliminarla para poder salir de esta p�gina');
        //    AllowClose := FALSE;
        //  END;
    END;

    [EventSubscriber(ObjectType::Page, 52, OnQueryClosePageEvent, '', true, true)]
    LOCAL PROCEDURE P52_OnQueryClosePageEvent(VAR Rec: Record 38; VAR AllowClose: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 29/06/22: QB 1.10.57 Si el abono es de anticipo, no dejar salir sin grabar o borrar para evitar problemas
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec.FIND('=')) THEN  //Por si lo han borrado
            IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN BEGIN
                ERROR('El abono cancela un anticipo, debe registrarlo o eliminarlo para poder salir de esta p�gina');
                AllowClose := FALSE;
            END;
    END;

    PROCEDURE GenerateVendorJournal(PurchInvHeader: Record 122);
    VAR
        Vendor: Record 23;
        GenJournalLine: Record 81;
        SourceCodeSetup: Record 242;
        QuoBuildingSetup: Record 7207278;
        GenJnlPostLine: Codeunit 12;
        QBPrepaymentData: Record 7206998;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Genera un pago y lo liquida contra la factura recien registrada
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 13/06/22: - QB 1.10.49 Se genera por cada l�nea que se ha aplicado

        Vendor.GET(PurchInvHeader."Buy-from Vendor No.");
        SourceCodeSetup.GET;
        QuoBuildingSetup.GET;

        QBPrepaymentData.RESET;
        QBPrepaymentData.SETRANGE("Register No.", PurchInvHeader."QB Prepayment Data");
        IF (QBPrepaymentData.FINDSET(FALSE)) THEN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Line No." := QBPrepaymentData."Entry No.";
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                GenJournalLine."Document No." := PurchInvHeader."No." + '_LIQ';
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.VALIDATE("Account No.", PurchInvHeader."Buy-from Vendor No.");
                GenJournalLine.Description := COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(GenJournalLine.Description));
                GenJournalLine."Posting Date" := PurchInvHeader."Posting Date";
                GenJournalLine.VALIDATE("Currency Code", PurchInvHeader."Currency Code");
                GenJournalLine."Currency Factor" := PurchInvHeader."Currency Factor";

                GenJournalLine.VALIDATE(Amount, QBPrepaymentData."To Apply Amount");

                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
                GenJournalLine."Source No." := PurchInvHeader."Buy-from Vendor No.";
                GenJournalLine."Dimension Set ID" := PurchInvHeader."Dimension Set ID";
                GenJournalLine."Shortcut Dimension 1 Code" := PurchInvHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := PurchInvHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Source Code" := SourceCodeSetup.Sales;
                GenJournalLine."System-Created Entry" := TRUE;
                GenJournalLine."Due Date" := PurchInvHeader."Due Date";
                GenJournalLine."Document Date" := PurchInvHeader."Document Date";
                GenJournalLine."Bill-to/Pay-to No." := PurchInvHeader."Pay-to Vendor No.";

                //JMMA 24/01/20: - Se a�ade al diario el c�d. de proyecto
                GenJournalLine."QB Job No." := PurchInvHeader."Job No.";

                //Aplicamos la l�nea a la factura para que la liquide
                GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
                GenJournalLine."Applies-to Doc. No." := PurchInvHeader."No.";

                //Montar la contrapartida
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                //AML Q19562 29/05/23 Correccion Error Q19607
                //GenJournalLine.VALIDATE("Bal. Account No.", GetPurchasePrepaymentAccount(Vendor."Gen. Bus. Posting Group",QuoBuildingSetup."Prepayment Posting Group 2"));
                IF QBPrepaymentData."Entry Type" = QBPrepaymentData."Entry Type"::Invoice THEN
                    GenJournalLine.VALIDATE("Bal. Account No.", GetPurchasePrepaymentAccount(Vendor."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"))
                ELSE
                    GenJournalLine.VALIDATE("Bal. Account No.", GetPurchasePrepaymentAccount(Vendor."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 1"));
                //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                //Q19562

                CLEAR(GenJnlPostLine);
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            UNTIL (QBPrepaymentData.NEXT = 0);
    END;

    LOCAL PROCEDURE AddPurchaseInvoice(PurchInvoiceHeader: Record 122);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentData: Record 7206998;
        Entry: Integer;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Da de alta una factura de compra en el registro de anticipos del proyecto
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 13/06/22: - QB 1.10.49 Se genera por cada l�nea que se ha aplicado

        //Q12879 -
        //El importe es negativo en proveedores, lo cambiamos para que sea positivo anticipo y negativo aplicaci�n

        CASE PurchInvoiceHeader."QB Prepayment Use" OF
            PurchInvoiceHeader."QB Prepayment Use"::Prepayment:
                BEGIN
                    QBPrepayment.INIT;
                    QBPrepayment."Job No." := PurchInvoiceHeader."Job No.";
                    QBPrepayment."Account Type" := QBP."Account Type"::Vendor;
                    QBPrepayment."Account No." := PurchInvoiceHeader."Buy-from Vendor No.";
                    QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Invoice;
                    QBPrepayment."Document No." := PurchInvoiceHeader."No.";
                    QBPrepayment."Posting Date" := PurchInvoiceHeader."Posting Date";
                    QBPrepayment."Document Date" := PurchInvoiceHeader."Document Date";
                    QBPrepayment."Currency Code" := PurchInvoiceHeader."Currency Code";

                    QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Invoice;
                    QBPrepayment.Description := STRSUBSTNO(Text000, Text006);
                    QBPrepayment.VALIDATE(Amount, PurchInvoiceHeader.Amount);  //JAV 10/11/21: - QB 1.09.27 Anticipos en positivo y Aplicaciones en negativo
                    QBPrepayment.INSERT(TRUE);
                END;
            PurchInvoiceHeader."QB Prepayment Use"::Application:
                BEGIN
                    PurchInvoiceHeader.CALCFIELDS(Amount);
                    QBPrepaymentData.RESET;
                    QBPrepaymentData.SETRANGE("Register No.", PurchInvoiceHeader."QB Prepayment Data");
                    IF (QBPrepaymentData.FINDSET(FALSE)) THEN
                        REPEAT
                            QBPrepayment.INIT;
                            QBPrepayment."Job No." := PurchInvoiceHeader."Job No.";
                            QBPrepayment."Account Type" := QBP."Account Type"::Vendor;
                            QBPrepayment."Account No." := PurchInvoiceHeader."Buy-from Vendor No.";
                            QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Invoice;
                            QBPrepayment."Document No." := PurchInvoiceHeader."No.";
                            QBPrepayment."Posting Date" := PurchInvoiceHeader."Posting Date";
                            QBPrepayment."Document Date" := PurchInvoiceHeader."Document Date";
                            QBPrepayment."Currency Code" := PurchInvoiceHeader."Currency Code";

                            QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Application;
                            QBPrepayment."Apply to Entry No." := QBPrepaymentData."Entry No.";
                            QBPrepayment.Description := QBPrepaymentData."To Apply Description";
                            QBPrepayment.VALIDATE(Amount, -QBPrepaymentData."To Apply Amount");  //JAV 10/11/21: - QB 1.09.27 Anticipos en positivo y Aplicaciones en negativo
                            QBPrepayment.INSERT(TRUE);
                        UNTIL QBPrepaymentData.NEXT = 0;
                END;
        END;
        //Q12879 +
    END;

    LOCAL PROCEDURE "----------------------------------------- Calculo de anticipos en los documentos de Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnAfterInsertEvent(VAR Rec: Record 38; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al insertar el registor se revisan los anticipos
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        IF (RunTrigger) THEN
            CreatePrepayment_PurchaseLines(Rec);
        //Q12879 +
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnAfterModifyEvent(VAR Rec: Record 38; VAR xRec: Record 38; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al modificar el registro se revisan los anticipos
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        //-Q19834 Se quita el volver a crear en caso de modificaci�n.
        //IF (RunTrigger) THEN
        //CreatePrepayment_PurchaseLines(Rec);
        //+Q18934
        //Q12879 +
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnBeforeDeleteEvent(VAR Rec: Record 36; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19 - Se eliminan los anticipos
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN
            DeletePrepayment_PurchaseLines(ConvertDocumentTypeToOptionSalesDocumentType(Rec."Document Type"), Rec."No.");
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE T38_OnBeforeValidateEvent_BuyfromVendorNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/09/19 - Si cambia el proveedor limpiamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Estaba apuntado al cliente de la tabla de cabeceras de ventas, se cambia a proveedor en compras
        IF (Rec."Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND (xRec."Buy-from Vendor No." <> '') THEN
            PurchaseValidateFields(Rec, Text006);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_BuyfromVendorNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al validar el proveedor miramos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        GeneratePurchasePrepaymentAmount(Rec, xRec, TRUE);
        //Q12879 +
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE T38_OnBeforeValidateEvent_QBJobNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Si cambia el proyecto quitar el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Job No." <> xRec."QB Job No.") AND (xRec."QB Job No." <> '') THEN
            PurchaseValidateFields(Rec, Text007);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QB Job No.", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_QBJobNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al validar el proyecto buscamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        GeneratePurchasePrepaymentAmount(Rec, xRec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "Currency Code", true, true)]
    LOCAL PROCEDURE T38_OnBeforeValidateEvent_CurrencyCode(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Si cambia la divisa limpiamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879
        IF (Rec."Currency Code" <> xRec."Currency Code") AND (xRec."Currency Code" <> '') THEN
            PurchaseValidateFields(Rec, Text008);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Currency Code", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_CurrencyCode(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Al validar la divisa buscamos el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        GeneratePurchasePrepaymentAmount(Rec, xRec, TRUE);
    END;

    LOCAL PROCEDURE PurchaseValidateFields(VAR Rec: Record 38; pField: Text);
    VAR
        QBPrepaymentData: Record 7206998;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: QB 1.10.24 Si cambia un campo de anticipo hay que confirmar si se pierde el anticipo
        //-------------------------------------------------------------------------------------------------------------------

        //JAV 12/03/21: - QB 1.10.24 Si no procesamos no hay que hacer nada
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::DontProcess) THEN
            EXIT;

        //JAV 12/03/21: - QB 1.10.24 Si es la factura de anticipo no se puede cambiar proveedor o proyecto
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::Prepayment) THEN
            ERROR(Text009, pField);

        IF (Rec."QB Prepayment Apply" <> 0) THEN BEGIN
            IF (CONFIRM(Text010, FALSE, pField)) THEN BEGIN
                Rec."QB Prepayment Apply" := 0;
                Rec."QB Prepayment Type" := Rec."QB Prepayment Type"::No;
                IF (Rec."QB Prepayment Data" <> 0) THEN BEGIN
                    QBPrepaymentData.RESET;
                    QBPrepaymentData.SETRANGE("Register No.", Rec."QB Prepayment Data");
                    QBPrepaymentData.DELETEALL;
                END;
            END ELSE BEGIN
                ERROR(Text011);
            END;
        END;
    END;

    PROCEDURE GeneratePurchasePrepaymentAmount(VAR PurchaseHeader: Record 38; xPurchaseHeader: Record 38; pConfirm: Boolean);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentEdit: Page 7207281;
        BaseAmount: Decimal;
        PrepmtAmount: Decimal;
        VendorPedingPrepmtMsg: TextConst ENU = 'The vendor has a prepayment pending to settle, Would younlike to discounting it from the invoice?', ESP = 'El proveedor tiene un anticipo pendiente de liquidar, �desea descontarlo de la factura?';
        Description: Text;
        type: Option;
        Ok: Boolean;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/03/22: - QB 1.10.24 Si cambiamos el proyecto y antes ten�a un anticipo, hay que quitarlo para que no haya incoherencias
        //-------------------------------------------------------------------------------------------------------------------

        //JAV 29/11/21: - QB 1.10.02 Solo se aplican los anticipos a las facturas
        IF (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice) THEN
            EXIT;

        //JAV 12/03/21: - QB 1.10.24 Si no procesamos o es la factura de anticipo no hay que hacer nada
        IF (PurchaseHeader."QB Prepayment Use" IN [PurchaseHeader."QB Prepayment Use"::DontProcess, PurchaseHeader."QB Prepayment Use"::Prepayment]) THEN
            EXIT;

        //JAV 12/03/22: - QB 1.10.24 Verificar cambios en el registro antes de comenzar
        T38_OnBeforeValidateEvent_QBJobNo(PurchaseHeader, xPurchaseHeader, 0);
        T38_OnBeforeValidateEvent_BuyfromVendorNo(PurchaseHeader, xPurchaseHeader, 0);
        T38_OnBeforeValidateEvent_CurrencyCode(PurchaseHeader, xPurchaseHeader, 0);

        IF (PurchaseHeader."Buy-from Vendor No." = '') OR (PurchaseHeader."QB Job No." = '') THEN
            EXIT;

        //Busco si tiene un importe de anticipo pendiente, si no lo hay salimos
        PurchaseHeader.CALCFIELDS("QB Prepayment Pending");
        IF (PurchaseHeader."QB Prepayment Pending" = 0) THEN
            EXIT;

        //Pido confirmaci�n para aplicar el anticipo
        IF pConfirm THEN
            Ok := CONFIRM(VendorPedingPrepmtMsg, TRUE)
        ELSE
            Ok := TRUE;

        IF (Ok) THEN BEGIN
            COMMIT;

            //JAV 14/06/22: - QB 1.10.49 Cambios para tratar los anticipos de manera individual
            CLEAR(QBPrepaymentEdit);
            QBPrepaymentEdit.SetAplicacion(PurchaseHeader."QB Prepayment Data", PurchaseHeader."QB Job No.", QBP."Account Type"::Vendor, PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."Currency Code");
            QBPrepaymentEdit.LOOKUPMODE(TRUE);
            IF QBPrepaymentEdit.RUNMODAL = ACTION::LookupOK THEN BEGIN
                QBPrepaymentEdit.GetApplication(PurchaseHeader."QB Prepayment Data", BaseAmount, PrepmtAmount, type);
                IF (PrepmtAmount <> 0) THEN BEGIN
                    PurchaseHeader."QB Prepayment Apply" := PrepmtAmount;
                    PurchaseHeader."QB Prepayment Type" := type;
                    PurchaseHeader.VALIDATE("QB Prepayment Use", PurchaseHeader."QB Prepayment Use"::Application);
                END ELSE BEGIN
                    PurchaseHeader."QB Prepayment Apply" := 0;
                    PurchaseHeader."QB Prepayment Type" := PurchaseHeader."QB Prepayment Type"::No;
                    PurchaseHeader.VALIDATE("QB Prepayment Use", PurchaseHeader."QB Prepayment Use"::No);
                END;
                PurchaseHeader.MODIFY;
                CreatePrepayment_PurchaseLines(PurchaseHeader);
            END;
        END;

        //Revisar el importe del anticipo aplicado sobre el posible por si ha cambiado
        PurchaseHeader.CALCFIELDS("QB Prepayment Pending");
        IF (PurchaseHeader."QB Prepayment Apply" > PurchaseHeader."QB Prepayment Pending") THEN
            PurchaseHeader."QB Prepayment Apply" := PurchaseHeader."QB Prepayment Pending";
        //Q12879 +
    END;

    LOCAL PROCEDURE GetPurchasePrepaymentAccount(GR1: Code[20]; GR2: Code[20]): Code[20];
    VAR
        GenPostingSetup: Record 252;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Retorna la cuenta para anticipos de compra
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        GenPostingSetup.GET(GR1, GR2);
        EXIT(GenPostingSetup.GetPurchPrepmtAccount);
        //Q12879 +
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeModifyEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeModifyEvent(VAR Rec: Record 39; VAR xRec: Record 39; RunTrigger: Boolean);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar modificar la l�nea del anticipo, campos que afectan a los importes o las retenciones
        //-------------------------------------------------------------------------------------------------------------------

        IF (RunTrigger) AND (Rec."QB Prepayment Line") THEN
            //-Q19834
            //(IF (Rec.Amount <> xRec.Amount) OR (NOT Rec."QW Not apply Withholding GE") OR (NOT Rec."QW Not apply Withholding PIT") THEN
            //+Q19834
            IF (Rec.Amount <> xRec.Amount) THEN
                ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeDeleteEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        DeletingNotAllowedErr: TextConst ENU = 'You cannot delete the G.E. in invoice line. You must go to "Discount Prepayment" on Invoice Details tab.', ESP = 'No puede borrar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //No dejar borrar la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        IF (RunTrigger) AND (Rec."QB Prepayment Line") THEN
            ERROR(DeletingNotAllowedErr);
        //Q12879 +
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, Type, true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_Type(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar modificar la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Line") AND (Rec.Type <> xRec.Type) THEN
            ERROR(Text001);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnBeforeValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE T39_OnBeforeValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede modificar la l�nea del anticipo, h�galo desde el campo "Descontar Anticipo" del panel de Detalles de la factura';
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 19/10/19: - No dejar modificar la l�nea del anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Line") AND (Rec."No." <> xRec."No.") THEN
            ERROR(Text001);
    END;

    PROCEDURE CreatePrepayment_PurchaseLines(PurchaseHeader: Record 38): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
        WithholdingGroup: Record 7207330;
        Job: Record 167;
        Currency: Record 4;
        PurchaseLine: Record 39;
        LineNo: Integer;
        LineNo2: Integer;
        bAux: Boolean;
        QBPrepaymentData: Record 7206998;
        Withholdingtreating: Codeunit 7207306;
        PurchInvLine: Record 123;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Crear las l�neas de anticipo en el documento de compra
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        QuoBuildingSetup.GET();
        IF NOT Job.GET(PurchaseHeader."QB Job No.") THEN
            EXIT;

        //JAV 12/03/21: - QB 1.10.24 Si no procesamos o no est� abierto no podemos a�adir nada al documento
        IF (PurchaseHeader."QB Prepayment Use" = PurchaseHeader."QB Prepayment Use"::DontProcess) OR (PurchaseHeader.Status <> PurchaseHeader.Status::Open) THEN
            EXIT;

        PurchaseHeader.CALCFIELDS("QB Prepayment Pending");
        IF (NOT Currency.GET(PurchaseHeader."Currency Code")) THEN
            CLEAR(Currency);
        Currency.InitRoundingPrecision;

        DeletePrepayment_PurchaseLines(ConvertDocumentTypeToOptionPurchaseDocumentType(PurchaseHeader."Document Type"), PurchaseHeader."No.");

        IF (PurchaseHeader."QB Prepayment Type" <> PurchaseHeader."QB Prepayment Type"::Invoice) THEN
            EXIT;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchaseLine.FINDFIRST THEN BEGIN
            LineNo := ROUND(PurchaseLine."Line No." / 2, 1);
            LineNo2 := 1;
        END ELSE BEGIN
            LineNo := 10000;
            LineNo2 := 10000;
        END;

        QBPrepaymentData.RESET;
        QBPrepaymentData.SETRANGE("Register No.", PurchaseHeader."QB Prepayment Data");
        QBPrepaymentData.SETFILTER("To Apply Amount", '<>0');
        IF (QBPrepaymentData.FINDSET(FALSE)) THEN
            REPEAT
                PurchaseLine.INIT;
                PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                PurchaseLine."Document No." := PurchaseHeader."No.";
                PurchaseLine."Line No." := LineNo;
                PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                PurchaseLine.VALIDATE("No.", GetPurchasePrepaymentAccount(PurchaseHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2"));  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                PurchaseLine.VALIDATE("Gen. Bus. Posting Group", PurchaseHeader."Gen. Bus. Posting Group");
                PurchaseLine.VALIDATE("Gen. Prod. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2");  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
                                                                                                                   //-Q20312
                PurchInvLine.SETRANGE("Document No.", QBPrepaymentData."Document No.");
                PurchInvLine.FINDFIRST;
                PurchaseLine.VALIDATE("VAT Prod. Posting Group", PurchInvLine."VAT Prod. Posting Group");
                //PurchaseLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
                //+Q20312
                PurchaseLine.Description := QBPrepaymentData."To Apply Description";
                PurchaseLine.VALIDATE(Quantity, -1);
                PurchaseLine.VALIDATE("Direct Unit Cost", ROUND(QBPrepaymentData."To Apply Amount", Currency."Amount Rounding Precision"));
                PurchaseLine."QB Prepayment Line" := TRUE;
                PurchaseLine."QW Not apply Withholding GE" := TRUE;
                PurchaseLine."QW Not apply Withholding PIT" := TRUE;
                PurchaseLine.INSERT(FALSE);
                //-Q19834
                Withholdingtreating.CalculateWithholding_PurchaseLine(PurchaseLine, FALSE);  //Para que calcule las retenciones
                PurchaseLine.MODIFY;
                //+Q19834
                LineNo += LineNo2;
            UNTIL (QBPrepaymentData.NEXT = 0);

        //L�nea de separaci�n
        bAux := (PurchaseLine.Type = PurchaseLine.Type::" ") AND (PurchaseLine."No." = '');  //Para no meter mas separadores de la cuenta
        IF (NOT bAux) THEN BEGIN
            PurchaseLine.INIT;
            PurchaseLine."Document Type" := PurchaseHeader."Document Type";
            PurchaseLine."Document No." := PurchaseHeader."No.";
            PurchaseLine."Line No." := LineNo;
            PurchaseLine.Type := PurchaseLine.Type::" ";
            PurchaseLine."QB Prepayment Line" := TRUE;
            PurchaseLine.INSERT(FALSE);
            //-Q19834
            Withholdingtreating.CalculateWithholding_PurchaseLine(PurchaseLine, FALSE);  //Para que calcule las retenciones
            PurchaseLine.MODIFY;
            //+Q19834
        END;

        //Q13154 +
        EXIT(TRUE)
        //Q12879 +
    END;

    PROCEDURE DeletePrepayment_PurchaseLines(PurchaseHeaderType: Option; PurchaseHeaderNo: Code[20]);
    VAR
        PurchaseLine: Record 39;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Eliminar las l�neas de anticipo en documentos de compra
        //-------------------------------------------------------------------------------------------------------------------
        //Q12879 -
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeaderType);
        PurchaseLine.SETRANGE("Document No.", PurchaseHeaderNo);
        PurchaseLine.SETRANGE("QB Prepayment Line", TRUE);
        PurchaseLine.DELETEALL(FALSE)
        //Q12879 +
    END;

    [EventSubscriber(ObjectType::Codeunit, 7206913, OnAfterSendApproval, '', true, true)]
    LOCAL PROCEDURE CU7206913_OnAfterSendApproval(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 51, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE PG51_OnOpenPageEvent(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Si abrimos la p�gina de una factura de compra, quitar la marca de no procesar anticipos
        //-------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Prepayment Use" = Rec."QB Prepayment Use"::DontProcess) THEN BEGIN
            Rec."QB Prepayment Use" := Rec."QB Prepayment Use"::No;
            Rec.MODIFY;
        END;

        //JAV 01/06/22: - QB 1.10.46 Si ya tiene un anticipo aplicado, solo se informa al abrir el documento
        IF (Rec."QB Prepayment Apply" <> 0) THEN
            MESSAGE('El documento tiene aplicado un anticipo por importe de %1', Rec."QB Prepayment Apply")
        ELSE
            GeneratePurchasePrepaymentAmount(Rec, Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 51, OnBeforeActionEvent, Post, true, true)]
    LOCAL PROCEDURE PG51_OnBeforeActionEvent_Post(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 51, OnBeforeActionEvent, PostAndPrint, true, true)]
    LOCAL PROCEDURE PG51_OnBeforeActionEvent_PostAndPrint(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 51, OnBeforeActionEvent, Preview, true, true)]
    LOCAL PROCEDURE PG51_OnBeforeActionEvent_Preview(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 9308, OnBeforeActionEvent, Post, true, true)]
    LOCAL PROCEDURE PG9308_OnBeforeActionEvent_Post(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 9308, OnBeforeActionEvent, PostAndPrint, true, true)]
    LOCAL PROCEDURE PG9308_OnBeforeActionEvent_PostAndPrint(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 9308, OnBeforeActionEvent, Preview, true, true)]
    LOCAL PROCEDURE PG9308_OnBeforeActionEvent_Preview(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        PurchasePage_VerifyPrepayment(Rec);
    END;

    LOCAL PROCEDURE PurchasePage_VerifyPrepayment(VAR Rec: Record 38);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/22: - QB 1.10.24 Antes de lanzar, registrar o vista previa de la solicitud de aprobaci�n verificar si hay un anticipo aplicable
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/03/21: - QB 1.10.24 Si no est� abierto no podemos a�adir nada al documento
        IF (Rec.Status <> Rec.Status::Open) THEN
            EXIT;

        IF (Rec."QB Prepayment Apply" = 0) THEN BEGIN
            GeneratePurchasePrepaymentAmount(Rec, Rec, TRUE);
            COMMIT;  //Guardamos por si luego se cancela el proceso
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Creaci¢n de Efectos"();
    BEGIN
    END;

    PROCEDURE CreateQBPrepmtBillEntry(QBPrepayment: Record 7206928);
    VAR
        GenJnlLine: Record 81;
        tmpGenJnlLine: Record 81 TEMPORARY;
        Option: Integer;
        Msg001: TextConst ESP = 'Confirme registro sin factura del anticipo a %1 por un importe de %2 %3';
        Divisa: Text;
        QBPrepaymentEdit: Page 7207281;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 27/06/21: - QB 1.09.03 Creaci�n del movimiento del anticipo sin factura
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 28/03/22: - QB 1.10.29 Se simplifica la funci�n
        //IF (QBPrepayment."Currency Code" = '') THEN
        //  Divisa := '�'
        //ELSE
        //  Divisa := QBPrepayment."Currency Code";
        //
        //IF CONFIRM(Msg001, TRUE, QBPrepayment."Account Description", QBPrepayment."Pending Amount", Divisa) THEN
        //  CreateGenJnlLines(QBPrepayment, TRUE);


        //JAV 11/04/22: - QB 1.10.35 Pedir la fecha de registro antes de generar el asiento
        CLEAR(QBPrepaymentEdit);
        QBPrepaymentEdit.SetPost(QBPrepayment."Job No.", QBPrepayment."Account Type", QBPrepayment."Account No.", FORMAT(QBPrepayment."Generate Document"), QBPrepayment."Not Approved Amount",
                                 //Q18899-
                                 QBPrepayment."Payment Terms Code", QBPrepayment."Document Date", QBPrepayment."Posting Date");
        //QBPrepayment."Payment Terms Code");  //JAV 20/04/22: - QB 1.10.36 Se incluye el t�rmino de pago para el c�lculo del vencimiento
        //Q18899-
        QBPrepaymentEdit.LOOKUPMODE(TRUE);
        IF (QBPrepaymentEdit.RUNMODAL <> ACTION::LookupOK) THEN
            EXIT;

        //JAV 20/04/22: - QB 1.10.36 Se ampl�an los par�metros de registro con fecha de registro, fecha del documento, t�mino de pago y fecha de vencimiento
        QBPrepaymentEdit.GetPost(QBPrepayment."Posting Date", QBPrepayment."Document Date", QBPrepayment."Payment Terms Code", QBPrepayment."Due Date");

        QBPrepayment.MODIFY(TRUE);
        CreateGenJnlLines(QBPrepayment, TRUE);
    END;

    PROCEDURE CreateGenJnlLines(QBPrepayment: Record 7206928; Post: Boolean);
    VAR
        GenJnlLine: Record 81;
        GenJnlLineBase: Record 81 TEMPORARY;
        QuoBuildingSetup: Record 7207278;
        PurchaseSetup: Record 312;
        Customer: Record 18;
        Vendor: Record 23;
        Job: Record 167;
        DimensionSetEntry: Record 480;
        DefaultDimension: Record 352;
        SourceCodeSetup: Record 242;
        PaymentMethod: Record 289;
        NoSeriesMgt: Codeunit 396;
        DimensionManagement: Codeunit 408;
        GenJnlPostLine: Codeunit 12;
        GenJnlPost: Codeunit 231;
        DueDate: Date;
        Txt1: Text;
        Txt2: Text;
        ok: Boolean;
        GeneralJournal: Page 39;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 27/06/21: - QB 1.09.03 Creaci�n de las l�neas del diario para un anticipo sin factura
        //-------------------------------------------------------------------------------------------------------------------

        //JAV 28/03/22: - QB 1.10.29 Se modifica para que se pueda lanzar la vista previa de registro

        CASE QBPrepayment."Account Type" OF
            QBPrepayment."Account Type"::Customer:
                BEGIN
                    Customer.GET(QBPrepayment."Account No.");
                    Txt1 := Customer.TABLECAPTION;
                    Txt2 := Customer.Name
                END;
            QBPrepayment."Account Type"::Vendor:
                BEGIN
                    Vendor.GET(QBPrepayment."Account No.");
                    Txt1 := Vendor.TABLECAPTION;
                    Txt2 := Vendor.Name
                END;
        END;

        QuoBuildingSetup.GET;
        PurchaseSetup.GET;
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("QB Prepayments");
        //Linea.SetDescription;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");       //TO-DO dejarlo en blanco y con tablas temporales
        GenJnlLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        GenJnlLine.DELETEALL;

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJnlLine.VALIDATE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        GenJnlLine.VALIDATE("Line No.", 10000); //Por si da un error saber que l�nea es la relacionada

        GenJnlLine.VALIDATE("Posting Date", QBPrepayment."Posting Date");
        GenJnlLine.VALIDATE("Document Date", QBPrepayment."Document Date");

        CASE QBPrepayment."Account Type" OF
            QBPrepayment."Account Type"::Customer:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Account No.", QBPrepayment."Account No.");
                    GenJnlLine.VALIDATE(Amount, QBPrepayment."Not Approved Amount");
                    //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�go, m�todo de pago y fecha de vencimiento
                    //GenJnlLine.VALIDATE("Payment Terms Code",  Customer."Payment Terms Code");
                    //IF (QuoBuildingSetup."Prepayment Payment Method" <> '') THEN
                    //  GenJnlLine.VALIDATE("Payment Method Code", QuoBuildingSetup."Prepayment Payment Method");
                END;
            QBPrepayment."Account Type"::Vendor:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.VALIDATE("Account No.", QBPrepayment."Account No.");
                    GenJnlLine.VALIDATE(Amount, -QBPrepayment."Not Approved Amount");
                    //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�go, m�todo de pago y fecha de vencimiento
                    //GenJnlLine.VALIDATE("Payment Terms Code",  Vendor."Payment Terms Code");
                    //IF (QuoBuildingSetup."Prepayment Payment Method" <> '') THEN
                    //  GenJnlLine.VALIDATE("Payment Method Code", QuoBuildingSetup."Prepayment Payment Method");
                END;
        END;

        //JAV 28/03/22: - El tipo de documento depender� de la forma de pago del cliente o proveedor
        PaymentMethod.GET(GenJnlLine."Payment Method Code");
        IF (PaymentMethod."Create Bills") THEN BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Bill);
            GenJnlLine.VALIDATE("Bill No.", '1');
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Invoice);
        END;

        IF (QuoBuildingSetup."Serie For Prepayment Bills" = '') THEN
            ERROR('No ha definido una serie de registo de anticipos con efecto en Conf. QuoBuilding');

        //JAV 04/04/22: - QB 1.10.31 Se cambia el contador de facturas por el espec�fico de efectos
        //-Q20107
        GenJnlLine.VALIDATE("Document No.", NoSeriesMgt.GetNextNo(QuoBuildingSetup."Serie For Prepayment Bills", QBPrepayment."Posting Date", TRUE));
        GenJnlLine."External Document No." := QBPrepayment."External Document No.";
        IF GenJnlLine."External Document No." = '' THEN BEGIN
            //+Q20107
            GenJnlLine."External Document No." := 'Ant-' + GenJnlLine."Document No.";
            //-Q20107
        END;
        //+Q20107

        GenJnlLine.VALIDATE("Source No.", QBPrepayment."Account No.");
        GenJnlLine.VALIDATE(Description, COPYSTR(QBPrepayment."Description Line 1", 1, MAXSTRLEN(GenJnlLine.Description)));
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", QBPrepayment."Account No.");
        GenJnlLine.VALIDATE("Source Code", SourceCodeSetup."QB Prepayments");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", QBPrepayment."Currency Code");

        GenJnlLine."QB Prepayment Entry No" := QBPrepayment."Entry No.";
        GenJnlLine."Job No." := '';                           //No puede tener proyecto directamente
        GenJnlLine."QB Job No." := QBPrepayment."Job No.";    //Pongo el proyecto en la variable auxiliar directamente

        //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�go, m�todo de pago y fecha de vencimiento
        GenJnlLine."Payment Method Code" := QBPrepayment."Payment Method Code";
        GenJnlLine."Payment Terms Code" := QBPrepayment."Payment Terms Code";
        GenJnlLine."Due Date" := QBPrepayment."Due Date";

        //Q19607-
        GenJnlLine.VALIDATE("Do not sent to SII", TRUE);
        //Q19607+

        GenJnlLine.INSERT;

        GenJnlLineBase := GenJnlLine; // Guardar la l�nea que se acaba de generar para usarla en la pr�xima

        // Contrapartida en otra l�nea
        GenJnlLine.VALIDATE("Line No.", 20000); //Por si da un error saber que l�nea es la relacionada
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Bill No.", '');

        CASE QBPrepayment."Account Type" OF
            QBPrepayment."Account Type"::Customer:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", GetSalesPrepaymentAccount(Customer."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 1"));  //JAV 27/06/22: - QB 1.10.55 grupo para efectos
                END;
            QBPrepayment."Account Type"::Vendor:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", GetPurchasePrepaymentAccount(Vendor."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 1"));  //JAV 27/06/22: - QB 1.10.55 grupo para efectos
                END;
        END;
        GenJnlLine.VALIDATE("Payment Terms Code", GenJnlLineBase."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", GenJnlLineBase."Payment Method Code");

        //Nunca debe tener IVA
        IF (GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::" ") THEN
            ERROR(Text012, GenJnlLine."Account No.");

        GenJnlLine.VALIDATE(Description, COPYSTR(QBPrepayment."Description Line 1", 1, MAXSTRLEN(GenJnlLineBase.Description)));
        GenJnlLine.VALIDATE("Currency Code", QBPrepayment."Currency Code");
        GenJnlLine.VALIDATE(Amount, -GenJnlLineBase.Amount);
        GenJnlLine.VALIDATE("Job No.", QBPrepayment."Job No.");  //Para que tome bien las dimensiones
                                                                 //Q19607-
        GenJnlLine.VALIDATE("Do not sent to SII", TRUE);
        //Q19607
        GenJnlLine.INSERT;

        //AddBill(GenJnlLineBase, TRUE);  //Lo hace el sistema tras el registro, as� sirve para la vista previa

        IF Post THEN BEGIN //+++
            CLEAR(GenJnlPost);
            GenJnlPost.RUN(GenJnlLine);
        END ELSE BEGIN
            COMMIT; //Por el run modal
            CLEAR(GenJnlPost);
            GenJnlPost.Preview(GenJnlLine);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterPostCust, '', true, true)]
    LOCAL PROCEDURE CU12_OnAfterPostCust(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 28/03/22: - QB 1.10.29 Tras registrar el cliente cambiar los datos del anticipo sin factura
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 09/06/22: - QB 1.10.49 Si el registro es positivo es una aplicaci�n, si es negativo una cancelaci�n
        IF (GenJournalLine."QB Prepayment Entry No" > 0) THEN
            ChangePrepaymentBill(GenJournalLine);
        IF (GenJournalLine."QB Prepayment Entry No" < 0) THEN
            AddBill(GenJournalLine, QBPrepayment."Entry Type"::Cancelation);
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterPostVend, '', true, true)]
    LOCAL PROCEDURE CU12_OnAfterPostVend(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 28/03/22: - QB 1.10.29 Tras registrar el proveedor cambiar los datos del anticipo sin factura
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 09/06/22: - QB 1.10.49 Si el registro es positivo es una aplicaci�n, si es negativo una cancelaci�n
        IF (GenJournalLine."QB Prepayment Entry No" > 0) THEN
            ChangePrepaymentBill(GenJournalLine);
        IF (GenJournalLine."QB Prepayment Entry No" < 0) THEN
            AddBill(GenJournalLine, QBPrepayment."Entry Type"::Cancelation);
    END;

    LOCAL PROCEDURE ChangePrepaymentBill(GenJournalLine: Record 81);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 28/03/22: - QB 1.10.29 Tras registrar el proveedor cambiar los datos del anticipo sin factura
        //-------------------------------------------------------------------------------------------------------------------
        QBPrepayment.GET(GenJournalLine."QB Prepayment Entry No");
        QBPrepayment."Document No." := GenJournalLine."Document No.";
        QBPrepayment.Description := GenJournalLine.Description;
        QBPrepayment.Amount := QBPrepayment."Not Approved Amount";
        QBPrepayment."Amount (LCY)" := QBPrepayment."Not Approved Amount (LCY)";
        QBPrepayment."Not Approved Amount" := 0;
        QBPrepayment."Not Approved Amount (LCY)" := 0;
        QBPrepayment.MODIFY(TRUE)
    END;

    [TryFunction]
    //[External]
    PROCEDURE Preview(VAR GenJnlLine: Record 81);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // ??? No se si se utiliza pero no hace nada
        //-------------------------------------------------------------------------------------------------------------------
    END;

    LOCAL PROCEDURE AddBill(GenJnlLine: Record 81; Type: Option);
    VAR
        QBPrepayment: Record 7206928;
        Entry: Integer;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // Da de alta un efecto en el registro de anticipos del proyecto
        //-------------------------------------------------------------------------------------------------------------------
        //El importe es negativo en proveedores, lo cambiamos para que sea siempre positivo el anticipo y negativa la aplicaci�n

        QBPrepayment.INIT;
        QBPrepayment."Job No." := GenJnlLine."QB Job No.";
        CASE GenJnlLine."Account Type" OF
            GenJnlLine."Account Type"::Customer:
                QBPrepayment."Account Type" := QBP."Account Type"::Customer;
            GenJnlLine."Account Type"::Vendor:
                QBPrepayment."Account Type" := QBP."Account Type"::Vendor;
        END;
        QBPrepayment."Account No." := GenJnlLine."Account No.";
        QBPrepayment."Document No." := GenJnlLine."Document No.";
        QBPrepayment."Posting Date" := GenJnlLine."Posting Date";
        QBPrepayment."Document Date" := GenJnlLine."Document Date";
        QBPrepayment."Currency Code" := GenJnlLine."Currency Code";
        CASE Type OF
            QBPrepayment."Entry Type"::Bill:
                BEGIN
                    QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Bill;
                    QBPrepayment.Description := GenJnlLine.Description;
                    QBPrepayment.VALIDATE(Amount, ABS(GenJnlLine.Amount));
                END;
            QBPrepayment."Entry Type"::Application:
                BEGIN
                    QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Application;
                    QBPrepayment.Description := Text001;
                    QBPrepayment.VALIDATE(Amount, -ABS(GenJnlLine.Amount));
                    QBPrepayment."Apply to Entry No." := ABS(GenJnlLine."QB Prepayment Entry No");
                END;
            QBPrepayment."Entry Type"::Cancelation:
                BEGIN
                    QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Cancelation;
                    QBPrepayment.Description := GenJnlLine.Description;
                    QBPrepayment.VALIDATE(Amount, -ABS(GenJnlLine.Amount));
                    QBPrepayment."Apply to Entry No." := ABS(GenJnlLine."QB Prepayment Entry No");
                END;
        END;
        QBPrepayment.INSERT(TRUE)
    END;

    [EventSubscriber(ObjectType::Codeunit, 231, OnBeforeCode, '', true, true)]
    LOCAL PROCEDURE CU231_OnBeforeCode(VAR GenJournalLine: Record 81; VAR HideDialog: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 04/04/22: - QB 1.10.31 No pedir una segunda confirmaci�n del diario
        //-------------------------------------------------------------------------------------------------------------------

        HideDialog := TRUE;
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos generales relacionados con Retenciones"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeSalesLineByChangedFieldNo, '', true, true)]
    LOCAL PROCEDURE T36_OnBeforeSalesLineByChangedFieldNo(SalesHeader: Record 36; VAR SalesLine: Record 37; ChangedFieldNo: Integer; VAR IsHandled: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Si estamos modificando las l�neas desde una acci�n propia de la tabla, no modificamos la l�nea de la retenci�n
        //-------------------------------------------------------------------------------------------------------------------
        IsHandled := SalesLine."Prepayment Line";
    END;

    [EventSubscriber(ObjectType::Page, 344, OnAfterNavigateFindRecords, '', true, true)]
    LOCAL PROCEDURE PG344_OnAfterNavigateFindRecords(VAR DocumentEntry: Record 265; DocNoFilter: Text; PostingDateFilter: Text);
    VAR
        QBPrepayment: Record 7206928;
        Navigate: Page 344;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al navegar incluir los documentos de anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF QBPrepayment.READPERMISSION THEN BEGIN
            QBPrepayment.RESET;
            QBPrepayment.SETCURRENTKEY("Document No.", "Posting Date");
            QBPrepayment.SETFILTER("Document No.", DocNoFilter);
            QBPrepayment.SETFILTER("Posting Date", PostingDateFilter);

            Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"QB Prepayment", Enum::"Document Entry Document Type".FromInteger(0), QBPrepayment.TABLECAPTION, QBPrepayment.COUNT);
        END;
    END;

    [EventSubscriber(ObjectType::Page, 344, OnAfterNavigateShowRecords, '', true, true)]
    LOCAL PROCEDURE PG344_OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; VAR TempDocumentEntry: Record 265 TEMPORARY);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //Al navegar ver los documentos de anticipo
        //-------------------------------------------------------------------------------------------------------------------
        IF (TableID = DATABASE::"QB Prepayment") THEN BEGIN
            QBPrepayment.RESET;
            QBPrepayment.SETCURRENTKEY("Document No.", "Posting Date");
            QBPrepayment.SETFILTER("Document No.", DocNoFilter);
            QBPrepayment.SETFILTER("Posting Date", PostingDateFilter);

            //Q19607-
            PAGE.RUN(7207031, QBPrepayment);
            //PAGE.RUN(0,QBPrepayment);
            //Q19607+
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7206928, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7206928_OnAfterInsert(VAR Rec: Record 7206928; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.36 Retorna el �ltimo registro de la tabla de anticipos
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN
            CalcTotals(Rec);  //A�adir totales del registro creado
    END;

    [EventSubscriber(ObjectType::Table, 7206928, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7206928_OnAfterModifyEvent(VAR Rec: Record 7206928; VAR xRec: Record 7206928; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.36 Retorna el �ltimo registro de la tabla de anticipos
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN BEGIN
            CalcTotals(xRec);  //Eliminar totales del registro anterior
            CalcTotals(Rec);   //A�adir   totales del registro nuevo
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7206928, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T7206928_OnAfterDelete(VAR Rec: Record 7206928; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.36 Retorna el �ltimo registro de la tabla de anticipos
        //-------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN
            CalcTotals(Rec);  //Eliminar totales del registro eliminado
    END;

    PROCEDURE CalcTotals(Rec: Record 7206928);
    VAR
        QBPrepayment: Record 7206928;
        Total: Decimal;
        TotalDL: Decimal;
        Txt: Text;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.36 Crea las l�neas de totales de cliente/proveedor y del proyecto. Solo se puede hacer DESPUES del altam/modificaci�n/baja
        //-------------------------------------------------------------------------------------------------------------------

        IF (Rec.TC) OR (Rec.TJ) THEN
            EXIT;

        //Crear el total por cliente/proveedor si no existe
        QBPrepayment.RESET;
        QBPrepayment.CHANGECOMPANY(Rec.CURRENTCOMPANY);  //Por si viene de otra empresa
        QBPrepayment.SETRANGE("Job No.", Rec."Job No.");
        QBPrepayment.SETRANGE("Account Type", Rec."Account Type");
        QBPrepayment.SETRANGE("Account No.", Rec."Account No.");
        QBPrepayment.SETRANGE("Entry Type", QBPrepayment."Entry Type"::TAccount);
        IF (NOT QBPrepayment.FINDFIRST) THEN BEGIN
            QBPrepayment.INIT;
            QBPrepayment."Entry No." := CalcEntryNo(Rec) + 1;
            QBPrepayment."Job No." := Rec."Job No.";
            QBPrepayment."Account Type" := Rec."Account Type";
            QBPrepayment."Account No." := Rec."Account No.";
            QBPrepayment."Entry Type" := Rec."Entry Type"::TAccount;
            QBPrepayment.Description := STRSUBSTNO(Text020, FORMAT(Rec."Account Type"), QBPrepayment."Account No.", Rec."Job No.");
            QBPrepayment.TC := TRUE;
            QBPrepayment.INSERT(FALSE);
        END;

        //JAV 11/04/22: - QB 1.10.35 Nuevos campos para filtrar en las pantallas
        QBPrepayment.CALCFIELDS("Sum Account Not App. Amt.", "Sum Account Amount", "Exist Account Not App. Reg.");
        QBPrepayment."See in Pending" := (QBPrepayment."Sum Account Not App. Amt." <> 0) OR (QBPrepayment."Exist Account Not App. Reg.");
        QBPrepayment."See in Posting" := (QBPrepayment."Sum Account Amount" <> 0);
        IF (QBPrepayment."See in Pending") OR (QBPrepayment."See in Posting") THEN BEGIN
            QBPrepayment.VALIDATE(Order);
            QBPrepayment.MODIFY(FALSE);
        END ELSE
            QBPrepayment.DELETE(FALSE);

        //Crear el total por Proyectos si no existe
        QBPrepayment.RESET;
        QBPrepayment.CHANGECOMPANY(Rec.CURRENTCOMPANY);  //Por si viene de otra empresa
        QBPrepayment.SETRANGE("Job No.", Rec."Job No.");
        QBPrepayment.SETRANGE("Account Type", Rec."Account Type");
        QBPrepayment.SETRANGE("Entry Type", QBPrepayment."Entry Type"::TJob);
        IF (NOT QBPrepayment.FINDFIRST) THEN BEGIN
            QBPrepayment.INIT;
            QBPrepayment."Entry No." := CalcEntryNo(Rec) + 1;
            QBPrepayment."Job No." := Rec."Job No.";
            QBPrepayment."Account Type" := Rec."Account Type";
            QBPrepayment."Entry Type" := Rec."Entry Type"::TJob;
            CASE Rec."Account Type" OF
                Rec."Account Type"::Customer:
                    Txt := 'Clientes';
                Rec."Account Type"::Vendor:
                    Txt := 'Proveedores';
            END;
            QBPrepayment.Description := STRSUBSTNO(Text021, Txt, Rec."Job No.");
            QBPrepayment.TJ := TRUE;
            QBPrepayment.INSERT(FALSE);
        END;

        //JAV 11/04/22: - QB 1.10.35 Nuevos campos para filtrar en las pantallas
        QBPrepayment.CALCFIELDS("Sum Job Not App. Amount", "Sum Job Amount", "Exist Job Not App. Reg.");
        QBPrepayment."See in Pending" := (QBPrepayment."Sum Job Not App. Amount" <> 0) OR (QBPrepayment."Exist Job Not App. Reg.");
        QBPrepayment."See in Posting" := (QBPrepayment."Sum Job Amount" <> 0);
        IF (QBPrepayment."See in Pending") OR (QBPrepayment."See in Posting") THEN BEGIN
            QBPrepayment.VALIDATE(Order);
            QBPrepayment.MODIFY(FALSE);
        END ELSE
            QBPrepayment.DELETE(FALSE);
    END;

    PROCEDURE CalcEntryNo(Rec: Record 7206928): Integer;
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.36 Retorna el �ltimo registro de la tabla de anticipos
        //-------------------------------------------------------------------------------------------------------------------

        QBPrepayment.RESET;
        QBPrepayment.CHANGECOMPANY(Rec.CURRENTCOMPANY);  //Por si viene de otra empresa
        IF QBPrepayment.FINDLAST THEN
            EXIT(QBPrepayment."Entry No.")
        ELSE
            EXIT(0);
    END;

    PROCEDURE RegenerateTotals(Rec: Record 7206928);
    VAR
        QBPrepayment: Record 7206928;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 11/04/22: - QB 1.10.36 Regenera todos los totales
        //-------------------------------------------------------------------------------------------------------------------

        QBPrepayment.RESET;
        QBPrepayment.CHANGECOMPANY(Rec.CURRENTCOMPANY);  //Por si viene de otra empresa
        QBPrepayment.SETFILTER("Entry Type", '%1|%2', QBPrepayment."Entry Type"::TAccount, QBPrepayment."Entry Type"::TJob);
        QBPrepayment.DELETEALL(FALSE);

        QBPrepayment.RESET;
        QBPrepayment.CHANGECOMPANY(Rec.CURRENTCOMPANY);  //Por si viene de otra empresa
        IF (QBPrepayment.FINDSET(FALSE)) THEN
            REPEAT
                IF NOT (QBPrepayment."Entry Type" IN [QBPrepayment."Entry Type"::TAccount, QBPrepayment."Entry Type"::TJob]) THEN BEGIN
                    QBPrepayment."See in Pending" := (QBPrepayment.Amount = 0);
                    QBPrepayment."See in Posting" := (QBPrepayment.Amount <> 0);
                    QBPrepayment.VALIDATE(Order);
                    QBPrepayment.MODIFY(FALSE);

                    CalcTotals(QBPrepayment);
                END;
            UNTIL QBPrepayment.NEXT = 0;
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos para la vista previa de registro"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 19, OnAfterBindSubscription, '', true, true)]
    LOCAL PROCEDURE GenJnlPostPreview_OnAfterBindSubscription();
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //No funciona si lo pongo as�, de momento se comenta
        //-------------------------------------------------------------------------------------------------------------------
        //IF NOT BINDSUBSCRIPTION(QBPrepaymentPreview) THEN
        //  MESSAGE('No he podido activar la CU de vista previa de retenciones');
    END;

    [EventSubscriber(ObjectType::Codeunit, 19, OnAfterUnbindSubscription, '', true, true)]
    LOCAL PROCEDURE GenJnlPostPreview_OnAfterUnbindSubscription();
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //No funciona si lo pongo as�, de momento se comenta
        //-------------------------------------------------------------------------------------------------------------------
        //IF NOT UNBINDSUBSCRIPTION(QBPrepaymentPreview) THEN
        //  MESSAGE('No he podido desactivar la CU de vista previa de retenciones');
    END;

    LOCAL PROCEDURE "------------------------------------------- Funciones comunes a las P ginas"();
    BEGIN
    END;

    PROCEDURE SeeDocument(QBPrepayment: Record 7206928);
    VAR
        SalesHeader: Record 36;
        SalesInvoiceHeader: Record 112;
        SalesInvoice: Page 43;
        PostedSalesInvoice: Page 132;
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
        PurchaseInvoice: Page 51;
        PostedPurchaseInvoice: Page 138;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 31/03/22: - QB 1.10.29 Mostar la factura asociada al documento
        //-------------------------------------------------------------------------------------------------------------------

        IF (QBPrepayment."Generate Document" <> QBPrepayment."Generate Document"::Invoice) THEN
            ERROR('No puede ver documentos que no sean facturas');

        IF (QBPrepayment."Account Type" = QBPrepayment."Account Type"::Customer) THEN BEGIN
            IF (QBPrepayment.Amount = 0) THEN BEGIN
                SalesHeader.RESET;
                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
                SalesHeader.SETRANGE("No.", QBPrepayment."Document No.");
                IF SalesHeader.FINDFIRST THEN BEGIN
                    CLEAR(SalesInvoice);
                    SalesInvoice.SETRECORD(SalesHeader);
                    SalesInvoice.RUNMODAL;
                END;
            END ELSE BEGIN
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("No.", QBPrepayment."Document No.");
                IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                    CLEAR(PostedSalesInvoice);
                    PostedSalesInvoice.SETRECORD(SalesInvoiceHeader);
                    PostedSalesInvoice.RUNMODAL;
                END;
            END;
        END ELSE BEGIN
            IF (QBPrepayment.Amount = 0) THEN BEGIN
                PurchaseHeader.RESET;
                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Invoice);
                PurchaseHeader.SETRANGE("No.", QBPrepayment."Document No.");
                IF PurchaseHeader.FINDFIRST THEN BEGIN
                    CLEAR(PurchaseInvoice);
                    PurchaseInvoice.SETRECORD(PurchaseHeader);
                    PurchaseInvoice.RUNMODAL;
                END;
            END ELSE BEGIN
                PurchInvHeader.RESET;
                PurchInvHeader.SETRANGE("No.", QBPrepayment."Document No.");
                IF PurchInvHeader.FINDFIRST THEN BEGIN
                    CLEAR(PostedPurchaseInvoice);
                    PostedPurchaseInvoice.SETRECORD(PurchInvHeader);
                    PostedPurchaseInvoice.RUNMODAL;
                END;
            END;
        END;
    END;

    PROCEDURE Navigate(QBPrepayment: Record 7206928);
    VAR
        NavigateForm: Page 344;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 04/04/22: - QB 1.10.31 Navegar al documento relacionado con el anticipo
        //-------------------------------------------------------------------------------------------------------------------
        NavigateForm.SetDoc(QBPrepayment."Posting Date", QBPrepayment."Document No.");
        NavigateForm.RUN;
    END;

    PROCEDURE Generate(QBPrepayment: Record 7206928);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 04/04/22: - QB 1.10.31 Generar el documento adecuado, factura o efecto
        //-------------------------------------------------------------------------------------------------------------------

        QBPrepayment.CheckData;  //Verificar datos antes de registrar

        //JAV 29/06/22: - QB 1.10.47 Al generar un documento, ponemos su tipo
        CASE QBPrepayment."Generate Document" OF
            QBPrepayment."Generate Document"::Invoice:
                QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Invoice;
            QBPrepayment."Generate Document"::Bill:
                QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Bill;
        END;

        CASE QBPrepayment."Account Type" OF
            //Crear un documento para el cliente
            QBPrepayment."Account Type"::Customer:
                BEGIN
                    CASE QBPrepayment."Generate Document" OF
                        QBPrepayment."Generate Document"::Invoice:
                            CreateSalesInvoice(QBPrepayment);
                        QBPrepayment."Generate Document"::Bill:
                            CreateQBPrepmtBillEntry(QBPrepayment);
                    END;
                END;

            //Crear un documento para el proveedor
            QBPrepayment."Account Type"::Vendor:
                BEGIN
                    CASE QBPrepayment."Generate Document" OF
                        QBPrepayment."Generate Document"::Invoice:
                            CreatePurchaseInvoice(QBPrepayment);
                        QBPrepayment."Generate Document"::Bill:
                            CreateQBPrepmtBillEntry(QBPrepayment);
                    END;
                END;
        END;
    END;

    PROCEDURE Cancel(Rec: Record 7206928);
    VAR
        QBPrepayment: Record 7206928;
        QBPrepaymentData: Record 7206998;
        QBPrepaymentEdit: Page 7207281;
        DataApply: Integer;
        PostingDate: Date;
    BEGIN
        //------------------------------------------------------------------------------------------
        //JAV 09/06/22: - QB 1.10.49 Cancelar anticipos
        //------------------------------------------------------------------------------------------
        CLEAR(QBPrepaymentEdit);
        QBPrepaymentEdit.SetCancel(Rec);
        QBPrepaymentEdit.LOOKUPMODE(TRUE);
        IF (QBPrepaymentEdit.RUNMODAL <> ACTION::LookupOK) THEN
            EXIT;

        QBPrepaymentEdit.GetCancel(DataApply, PostingDate);

        QBPrepaymentData.RESET;
        QBPrepaymentData.SETRANGE("Register No.", DataApply);
        QBPrepaymentData.SETFILTER("To Apply Amount", '<>0');
        IF (QBPrepaymentData.FINDSET(FALSE)) THEN
            REPEAT
                CASE QBPrepaymentData."Entry Type" OF
                    QBPrepaymentData."Entry Type"::Invoice:
                        CASE QBPrepaymentData."Account Type" OF
                            QBPrepaymentData."Account Type"::Customer:
                                CancelSalesInvoice(QBPrepaymentData, PostingDate);
                            QBPrepaymentData."Account Type"::Vendor:
                                CancelPurchaseInvoice(QBPrepaymentData, PostingDate);
                        END;
                    QBPrepaymentData."Entry Type"::Bill:
                        CancelBill(QBPrepaymentData, PostingDate);
                END;
            UNTIL (QBPrepaymentData.NEXT = 0);
    END;

    PROCEDURE CancelBill(QBPrepaymentData: Record 7206998; PostingDate: Date);
    VAR
        QBPrepayment: Record 7206928;
        GenJnlLine: Record 81;
        GenJnlLineBase: Record 81 TEMPORARY;
        QuoBuildingSetup: Record 7207278;
        PurchaseSetup: Record 312;
        Customer: Record 18;
        Vendor: Record 23;
        Job: Record 167;
        DimensionSetEntry: Record 480;
        DefaultDimension: Record 352;
        SourceCodeSetup: Record 242;
        PaymentMethod: Record 289;
        NoSeriesMgt: Codeunit 396;
        DimensionManagement: Codeunit 408;
        GenJnlPostLine: Codeunit 12;
        GenJnlPost: Codeunit 231;
        DueDate: Date;
        Txt1: Text;
        Txt2: Text;
        ok: Boolean;
        GeneralJournal: Page 39;
        Post: Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------
        //JAV 09/06/22: - QB 1.10.49 Cancelar anticipos con efecto. Genera un movimiento
        //------------------------------------------------------------------------------------------
        CASE QBPrepaymentData."Account Type" OF
            QBPrepaymentData."Account Type"::Customer:
                BEGIN
                    Customer.GET(QBPrepaymentData."Account No.");
                    Txt1 := Customer.TABLECAPTION;
                    Txt2 := Customer.Name
                END;
            QBPrepaymentData."Account Type"::Vendor:
                BEGIN
                    Vendor.GET(QBPrepaymentData."Account No.");
                    Txt1 := Vendor.TABLECAPTION;
                    Txt2 := Vendor.Name
                END;
        END;

        //Crear movimientos contables
        QuoBuildingSetup.GET;
        PurchaseSetup.GET;
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("QB Prepayments");

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");       //TO-DO dejarlo en blanco y con tablas temporales
        GenJnlLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        GenJnlLine.DELETEALL;

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJnlLine.VALIDATE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        GenJnlLine.VALIDATE("Line No.", 10000); //Por si da un error saber que l�nea es la relacionada

        GenJnlLine.VALIDATE("Posting Date", PostingDate);
        GenJnlLine.VALIDATE("Document Date", PostingDate);

        CASE QBPrepaymentData."Account Type" OF
            QBPrepaymentData."Account Type"::Customer:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Account No.", QBPrepaymentData."Account No.");
                    GenJnlLine.VALIDATE(Amount, QBPrepaymentData."To Apply Amount");
                END;
            QBPrepaymentData."Account Type"::Vendor:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.VALIDATE("Account No.", QBPrepaymentData."Account No.");
                    GenJnlLine.VALIDATE(Amount, QBPrepaymentData."To Apply Amount");
                END;
        END;

        //JAV 28/03/22: - El tipo de documento depender� de la forma de pago del cliente o proveedor
        PaymentMethod.GET(GenJnlLine."Payment Method Code");
        IF (PaymentMethod."Create Bills") THEN BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
            GenJnlLine.VALIDATE("Bill No.", '2');
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::"Credit Memo");
        END;

        IF (QuoBuildingSetup."Serie For Prepayment Bills" = '') THEN
            ERROR('No ha definido una serie de registo de anticipos con efecto en Conf. QuoBuilding');

        //JAV 04/04/22: - QB 1.10.31 Se cambia el contador de facturas por el espec�fico de efectos
        GenJnlLine.VALIDATE("Document No.", NoSeriesMgt.GetNextNo(QuoBuildingSetup."Serie For Prepayment Bills", QBPrepaymentData."Posting Date", TRUE));
        //-Q20107
        GenJnlLine."External Document No." := QBPrepaymentData."External Document No.";
        IF GenJnlLine."External Document No." = '' THEN BEGIN
            GenJnlLine."External Document No." := 'Ant-' + GenJnlLine."Document No.";
        END;
        //+Q20107
        GenJnlLine.VALIDATE(Description, COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(GenJnlLineBase.Description)));
        GenJnlLine.VALIDATE("Source No.", QBPrepaymentData."Account No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", QBPrepaymentData."Account No.");
        GenJnlLine.VALIDATE("Source Code", SourceCodeSetup."QB Prepayments");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", QBPrepaymentData."Currency Code");

        GenJnlLine."QB Prepayment Entry No" := -QBPrepaymentData."Entry No.";  //Para indicar que estamos cancelando
        GenJnlLine."Job No." := '';                                            //No puede tener proyecto directamente
        GenJnlLine."QB Job No." := QBPrepaymentData."Job No.";                 //Pongo el proyecto en la variable auxiliar directamente

        //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�go, m�todo de pago y fecha de vencimiento
        QBPrepayment.GET(QBPrepaymentData."Entry No.");
        GenJnlLine."Payment Method Code" := QBPrepayment."Payment Method Code";
        GenJnlLine."Payment Terms Code" := QBPrepayment."Payment Terms Code";
        GenJnlLine."Due Date" := QBPrepayment."Due Date";
        //Q19607-
        GenJnlLine.VALIDATE("Do not sent to SII", TRUE);
        //Q19607+
        GenJnlLine.INSERT;

        GenJnlLineBase := GenJnlLine; // Guardar la l�nea que se acaba de generar para usarla en la pr�xima

        // Contrapartida en otra l�nea
        GenJnlLine.VALIDATE("Line No.", 20000); //Por si da un error saber que l�nea es la relacionada
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Bill No.", '');

        CASE QBPrepaymentData."Account Type" OF
            QBPrepaymentData."Account Type"::Customer:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", GetSalesPrepaymentAccount(Customer."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 1"));  //JAV 27/06/22: - QB 1.10.55 grupo para efectos
                END;
            QBPrepaymentData."Account Type"::Vendor:
                BEGIN
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", GetPurchasePrepaymentAccount(Vendor."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 1"));  //JAV 27/06/22: - QB 1.10.55 grupo para efectos
                END;
        END;
        GenJnlLine.VALIDATE("Payment Terms Code", GenJnlLineBase."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", GenJnlLineBase."Payment Method Code");

        //Nunca debe tener IVA
        IF (GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::" ") THEN
            ERROR(Text012, GenJnlLine."Account No.");

        GenJnlLine.VALIDATE(Description, COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(GenJnlLineBase.Description)));
        GenJnlLine.VALIDATE(Amount, -GenJnlLineBase.Amount);
        GenJnlLine.VALIDATE("Job No.", QBPrepaymentData."Job No.");  //Para que tome bien las dimensiones
        GenJnlLine."QB Prepayment Entry No" := 0;                    //Para indicar que no debe hacer nada
                                                                     //Q19607-
        GenJnlLine.VALIDATE("Do not sent to SII", TRUE);
        //Q19607+
        GenJnlLine.INSERT;

        Post := TRUE; //No puede haber vista previa de momento
        IF Post THEN BEGIN //+++
            CLEAR(GenJnlPost);
            GenJnlPost.RUN(GenJnlLine);
        END ELSE BEGIN
            COMMIT; //Por el run modal
            CLEAR(GenJnlPost);
            GenJnlPost.Preview(GenJnlLine);
        END;
    END;

    PROCEDURE CancelSalesInvoice(QBPrepaymentData: Record 7206998; PostingDate: Date);
    VAR
        QuoBuildingSetup: Record 7207278;
        SalesSetup: Record 311;
        QBApprovalsSetup: Record 7206994;
        Job: Record 167;
        SalesHeader: Record 36;
        SalesHeaderList: Record 36;
        SalesLine: Record 37;
        NoSeriesMgt: Codeunit 396;
        SalesPost: Codeunit 80;
        SalesCreditMemo: Page 44;
        nLin: Integer;
        i: Integer;
        QBPrepaymentEdit: Page 7207281;
    BEGIN
        //------------------------------------------------------------------------------------------
        //JAV 29/06/22: - QB 1.10.57 Cancelar anticipos de cliente con factura. Genera un abono
        //------------------------------------------------------------------------------------------

        QuoBuildingSetup.GET();
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
        Job.GET(QBPrepaymentData."Job No.");
        Job.TESTFIELD("VAT Prod. PostingGroup");

        SalesHeader.INIT;
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader."Document Date" := PostingDate;
        SalesHeader.VALIDATE("Posting Date", PostingDate);
        SalesHeader.VALIDATE("Document Date");
        SalesHeader."QB Prepayment Use" := SalesHeader."QB Prepayment Use"::Prepayment;
        SalesHeader.INSERT(TRUE);

        SalesHeader.VALIDATE("Sell-to Customer No.", QBPrepaymentData."Account No.");
        SalesHeader.VALIDATE("QB Job No.", QBPrepaymentData."Job No.");
        SalesHeader.VALIDATE("Currency Code", QBPrepaymentData."Currency Code");
        SalesHeader."Posting No." := NoSeriesMgt.GetNextNo(SalesSetup."Posted Prepmt. Inv. Nos.", SalesHeader."Posting Date", TRUE);
        SalesHeader."Posting Description" := COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(SalesHeader."Posting Description"));
        SalesHeader.VALIDATE("Payment Discount %", 0);  //No puede tener descuentos adicionales
        SalesHeader.VALIDATE("VAT Base Discount %", 0);  //No puede tener descuentos adicionales
        SalesHeader."QB Job Sale Doc. Type" := SalesHeader."QB Job Sale Doc. Type"::"Advance by Store";  //JAV 29/03/22: - QB 1.10.29 Se marca que es una factura de anticipo
        SalesHeader."External Document No." := QBPrepaymentData."External Document No."; //JAV 04/04/22: - QB 1.10.31 Se informa del documento externo
        SalesHeader."Corrected Invoice No." := QBPrepaymentData."Document No.";          //Factura corregida = la original
                                                                                         //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�ge, m�todo de pago y fecha de vencimiento
                                                                                         //++SalesHeader."Payment Method Code" := QBPrepaymentData."Payment Method Code";
                                                                                         //++SalesHeader."Payment Terms Code" := QBPrepaymentData."Payment Terms Code";
                                                                                         //++SalesHeader."Due Date" := QBPrepaymentData."Due Date";
        SalesHeader.MODIFY(TRUE);

        nLin := 10000;

        SalesLine.INIT;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := nLin;
        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.", GetSalesPrepaymentAccount(SalesHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2")); //JAV 27/06/22: - QB 1.10.55 grupo para Fras
        SalesLine.VALIDATE("Gen. Bus. Posting Group", SalesHeader."Gen. Bus. Posting Group");
        SalesLine.VALIDATE("Gen. Prod. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2");  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
        SalesLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
        SalesLine.Description := COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(SalesLine.Description));
        SalesLine.VALIDATE(Quantity, 1);
        SalesLine.VALIDATE("Unit Price", QBPrepaymentData."To Apply Amount");
        SalesLine.VALIDATE("Job No.", QBPrepaymentData."Job No.");
        SalesLine.INSERT(TRUE);

        //JAV 10/04/22: - QB 1.10.34 El documento pasa como aprobado
        SalesHeader.Status := SalesHeader.Status::Released;
        SalesHeader.MODIFY(FALSE);

        //Presentar el abono creado
        COMMIT;
        SalesHeaderList.RESET;
        SalesHeaderList.SETRANGE("No.", SalesHeader."No.");

        CLEAR(SalesCreditMemo);
        SalesCreditMemo.SETTABLEVIEW(SalesHeaderList);
        SalesCreditMemo.RUNMODAL;
    END;

    LOCAL PROCEDURE CancelPurchaseInvoice(QBPrepaymentData: Record 7206998; PostingDate: Date);
    VAR
        PurchaseSetup: Record 312;
        QBApprovalsSetup: Record 7206994;
        ApprovalEntry: Record 454;
        Job: Record 167;
        PurchaseHeader: Record 38;
        PurchaseHeaderList: Record 38;
        PurchaseLine: Record 39;
        QuoBuildingSetup: Record 7207278;
        PurchaseCreditMemo: Page 52;
        ApprovalPurchaseInvoice: Codeunit 7206913;
        QBApprovalManagement: Codeunit 7207354;
        NoSeriesMgt: Codeunit 396;
        PurchPost: Codeunit 90;
        GLAccNo: Code[20];
        LineNo: Integer;
        i: Integer;
        QBPrepaymentEdit: Page 7207281;
    BEGIN
        //------------------------------------------------------------------------------------------
        //JAV 29/06/22: - QB 1.10.57 Cancelar anticipos de proveedor con factura. Genera un abono
        //------------------------------------------------------------------------------------------
        QuoBuildingSetup.GET();
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
        Job.GET(QBPrepaymentData."Job No.");
        Job.TESTFIELD("VAT Prod. PostingGroup");

        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
        PurchaseHeader."Document Date" := PostingDate;
        PurchaseHeader.VALIDATE("Posting Date", PostingDate);
        PurchaseHeader.VALIDATE("Document Date");
        PurchaseHeader."QB Prepayment Use" := PurchaseHeader."QB Prepayment Use"::Prepayment;
        PurchaseHeader.INSERT(TRUE);

        //JAV 08/11/22: - QB 1.12.16 Error al cancelar anticipo de compra, usaba cliente en lugar de proveedor
        //PurchaseHeader.VALIDATE("Sell-to Customer No.",QBPrepaymentData."Account No.");
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", QBPrepaymentData."Account No.");

        PurchaseHeader.VALIDATE("QB Job No.", QBPrepaymentData."Job No.");
        PurchaseHeader.VALIDATE("Currency Code", QBPrepaymentData."Currency Code");
        PurchaseHeader."Posting No." := NoSeriesMgt.GetNextNo(PurchaseSetup."Posted Prepmt. Inv. Nos.", PurchaseHeader."Posting Date", TRUE);
        //JAV 08/11/22: - QB 1.12.16 Esto debe ser lo �ltimo para que no lo cambie con los otros datos
        //PurchaseHeader."Posting Description" := COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(PurchaseHeader."Posting Description"));
        PurchaseHeader.VALIDATE("Payment Discount %", 0);  //No puede tener descuentos adicionales
        PurchaseHeader.VALIDATE("VAT Base Discount %", 0);  //No puede tener descuentos adicionales
        PurchaseHeader."Vendor Invoice No." := QBPrepaymentData."External Document No."; //JAV 04/04/22: - QB 1.10.31 Se informa del documento externo
        PurchaseHeader."Vendor Cr. Memo No." := QBPrepaymentData."External Document No." + '-CAN';          //Factura corregida = la original
        PurchaseHeader."Corrected Invoice No." := QBPrepaymentData."Document No.";          //Factura corregida = la original
                                                                                            //JAV 20/04/22: - QB 1.10.36 Se incluye el manejo de forma de p�ge, m�todo de pago y fecha de vencimiento
                                                                                            //++purchaseHeader."Payment Method Code" := QBPrepaymentData."Payment Method Code";
                                                                                            //++purchaseHeader."Payment Terms Code" := QBPrepaymentData."Payment Terms Code";
                                                                                            //++purchaseHeader."Due Date" := QBPrepaymentData."Due Date";
        PurchaseHeader."Posting Description" := COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(PurchaseHeader."Posting Description"));
        PurchaseHeader.MODIFY(TRUE);

        LineNo := 10000;

        PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := LineNo;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.VALIDATE("No.", GetPurchasePrepaymentAccount(PurchaseHeader."Gen. Bus. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2")); //JAV 27/06/22: - QB 1.10.55 grupo para Fras
        PurchaseLine.VALIDATE("Gen. Bus. Posting Group", PurchaseHeader."Gen. Bus. Posting Group");
        PurchaseLine.VALIDATE("Gen. Prod. Posting Group", QuoBuildingSetup."Prepayment Posting Group 2");  //JAV 27/06/22: - QB 1.10.55 grupo para Fras
        PurchaseLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
        PurchaseLine.Description := COPYSTR(QBPrepaymentData."To Apply Description", 1, MAXSTRLEN(PurchaseLine.Description));
        PurchaseLine.VALIDATE(Quantity, 1);
        //JAV 08/11/22: - QB 1.12.16 Error al cancelar anticipo de compra, mal el campo del importe a cancelar en la l�nea del abono
        //PurchaseLine.VALIDATE("Unit Cost",QBPrepaymentData."To Apply Amount");
        PurchaseLine.VALIDATE("Direct Unit Cost", QBPrepaymentData."To Apply Amount");

        PurchaseLine.VALIDATE("Job No.", QBPrepaymentData."Job No.");
        PurchaseLine.INSERT(TRUE);

        //JAV 10/04/22: - QB 1.10.34 El documento pasa como aprobado
        PurchaseHeader.Status := PurchaseHeader.Status::Released;
        PurchaseHeader.MODIFY(FALSE);

        //Presentar el abono creado
        COMMIT;
        PurchaseHeaderList.RESET;
        PurchaseHeaderList.SETRANGE("No.", PurchaseHeader."No.");

        //JAV 08/11/22: - QB 1.12.16 Error al cancelar anticipo de compra, sacaba la pantalla de factura en lugar de la de abono
        //CLEAR(PurchaseInvoice);
        //PurchaseInvoice.SETTABLEVIEW(PurchaseHeaderList);
        //PurchaseInvoice.RUNMODAL;
        CLEAR(PurchaseCreditMemo);
        PurchaseCreditMemo.SETTABLEVIEW(PurchaseHeaderList);
        PurchaseCreditMemo.RUNMODAL;
    END;

    procedure ConvertDocumentTypeToOptionSalesDocumentType(DocumentType: Enum "Sales Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionSalesDocumentStatus(DocumentType: Enum "Sales Document Status"): Option;
    var
        optionValue: Option "Pending Approval","Pending Prepayment";
    begin
        case DocumentType of
            DocumentType::"Pending Approval":
                optionValue := optionValue::"Pending Approval";
            DocumentType::"Pending Prepayment":
                optionValue := optionValue::"Pending Prepayment";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionPurchaseDocumentType(DocumentType: Enum "Purchase Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;
    /*BEGIN
/*{
      JDC 02/03/21: - Q12879 Modified function "NewJobCustomer", "GenerateSalesPrepaymentAmount".
                             Created function "SeeJobVendor", "NewJobVendor", "CU90_OnAfterPostPurchaseDoc", "AddPurchaseInvoice", "PurchaseHeader_OnAfterValidateEvent_BuyfromVendorNo",
                             "PurchaseHeader_OnAfterValidateEvent_QBJobNo", "PurchaseHeader_OnBeforeValidateEvent_CurrencyCode", "PurchaseHeader_OnAfterValidateEvent_CurrencyCode",
                             "GeneratePurchasePrepaymentAmount", "GetPurchasePrepaymentAccount", "PurchaseHeader_OnAfterInsertEvent", "PurchaseHeader_OnAfterModifyEvent",
                             "PurchaseLine_OnBeforeModifyEvent", "PurchaseLine_OnBeforeDeleteEvent", "CreatePrepayment_Purchase", "DeletePrepayment_Purchase",
                             "AccessToVendorPrepayment", "AccessToVendorPrepaymentError"
      JDC 07/05/21: - Q13154 Modified function "NewJobCustomer", "AddSalesInvoice", "CreatePrepayment_Sales", "NewJobVendor", "AddPurchaseInvoice", "CreatePrepayment_Purchase"
      JAV 10/11/21: - QB 1.09.27 Siempre Anticipos en positivo y Aplicaciones en negativo
      PSM 10/03/22: - QB 1.10.23 Para evitar un error por no estar informada la fecha del documento
      JAV 12/03/22: - QB 1.10.24 Se reordenan y cambian los nombres de las funciones de eventos unificando la estructura del nombre a: TXX_Evento[_Campo]
                                 Mejoras generales en los validates de Cliente, Proveedor y Proyecto, se llaman antes de generar el anticipo por si ha cambiado el campo
                                 Se ponen todos los textos como constantes
                                 Nuevas acciones antes de solicitar aprobaci�n, y antes de registro y vista previa en las pages de compras y ventas
      JAV 28/03/22: - QB 1.10.29 Modificaciones para el tratamiento del anticipo sin factura, se a�ade su vista previa
      JAV 29/03/22: - QB 1.10.29 Nuevo sistema de aprobaciones de los anticipos
      JAV 10/04/22: - QB 1.10.34 Pasar la aprobaci�n del anticipo al documento generado, factura de venta o de compra
      DGG 26/05/22: - QB 1.10.45 Q17368. Modificaci�n para usar la funci�n QBApprovalManagement.CopyApprovalChain con el nuevo par�metro incorporado.
      JAV 01/06/22: - QB 1.10.46 Si ya tiene un anticipo aplicado, solo se informa del importe al abrir el documento de compra o de venta
      JAV 09/06/22: - QB 1.10.49 Modificaci�n general para tratar los anticipos de manera individual en aplicaci�n. Se a�ade la Cancelaci�n de anticipos.
      JAV 27/06/22: - QB 1.10.55 Se a�ade el manejo de "Prepayment Posting Group 1" para efectos y "Prepayment Posting Group 2" para Fras
      JAV 29/06/22: - QB 1.10.57 Se completa la cancelaci�n de anticipos con factura. Se hace que no se pueda cerrar la p�gina de fra/abono de compra/venta cunado tiene anticipo para evitar problemas
      JAV 30/06/22: - QB 1.10.57 Se cambia de nombre y del evento que captura CU80_OnAfterPostGLAndCustomer por CU80_OnAfterPostCustomerEntry
                                 Se cambia de nombre y del evento que captura CU90_OnAfterPostGLAndVendor   por CU90_OnAfterPostVendorEntry
                                 Se a�anden las funciones CU80_OnBeforePostBalancingEntry y CU90_OnBeforePostBalancingEntry para ajustar el importe cuando la forma de pago liquida directamente el documento
      JAV 08/11/22: - QB 1.12.16 Error al cancelar anticipo de compra, usaba cliente en lugar de proveedor y mal el campo del importe del abono
      Q18899 PSM 13/02/23: - Se incluyen las fechas de documento y registro del anticipo en la p�gina de generaci�n de anticipos
                           - Se valida la fecha de documento del anticipo
                           - Se utilizan el grupo contable producto y el grupo registro IVA producto de la cuenta de anticipo, en caso de estar rellenos
      AML 29/05/23  - Q19562 Correccion Error

      Q19607 PSM 01/06/23: - Marcar en el diario "No subir al SII" en los anticipos de tipo Efecto o sus cancelaciones
                           - Al aplicar un anticipo de tipo Efecto, usar el grupo contable definido para Efectos
                           (pasado por AML 05/06/23);
      Q19834 AML 03/07/23: - Poder desmarcar las retenciones en los anticipos y calculo correcto de retenciones en anticipos.
      Q19985 AML PSM 27/07/23 - Correcion en la aplicaci�n de anticipos.
      Q20153 AML 22/09/23 - Correccion importe cancelacion anticipos.
      Q20107 AML 05/10/23 - Num. externo solo si est� vac�o.
      Q20312 AML 19/10/23 - Cambiar el Gr. Registro Producto en liquidacion de anticipos de compra.
    }
END.*/
}








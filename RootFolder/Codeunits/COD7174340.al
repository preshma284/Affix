Codeunit 7174340 "QuoFacturae subscriptions"
{


    Permissions = TableData 112 = rm,
                TableData 120 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text80200: TextConst ENU = 'Only "Invoice" type documents can be sent to Factura-e.', ESP = 'S�lo se pueden enviar a Factura-e movimientos de tipo "Factura" o "Abono"';
        ClientNotFoundErr: TextConst ENU = 'Client No. %1 Not Found in QuoFacturae Admin. Center', ESP = 'Cliente %1 no encontrado en el Administrador de QuoFacurae con el tipo %2';
        Text001: TextConst ESP = 'Env�o manual';
        Text002: TextConst ESP = 'por el usuario';

    PROCEDURE OpenCustAdmCenters(VAR Cust: Code[20]);
    VAR
        Customer: Record 18;
        QuoFacturaeadmincenter: Record 7174370;
    BEGIN
        IF NOT AccessToFacturae THEN
            EXIT;

        Customer.SETRANGE("No.", Cust);
        IF Customer.FINDFIRST THEN BEGIN
            QuoFacturaeadmincenter.RESET;
            QuoFacturaeadmincenter.SETRANGE("Customer no.", Cust);
            PAGE.RUNMODAL(PAGE::"QuoFacturae Adm. centers", QuoFacturaeadmincenter);
        END;
    END;

    [EventSubscriber(ObjectType::Page, 25, OnAfterActionEvent, SendFacturae, true, true)]
    LOCAL PROCEDURE Page25SendInvoiceToFacturae(VAR Rec: Record 21);
    BEGIN
        Send(Rec."Document No.");
    END;

    [EventSubscriber(ObjectType::Page, 25, OnAfterActionEvent, ExportFacturaefile, true, true)]
    LOCAL PROCEDURE Page25ExportFacturaeFile(VAR Rec: Record 21);
    BEGIN
        Export(Rec."Customer No.", Rec."Document No.");
    END;

    [EventSubscriber(ObjectType::Page, 25, OnAfterActionEvent, RequestFacturae, true, true)]
    LOCAL PROCEDURE Page25RequestFacturaeRequest(VAR Rec: Record 21);
    BEGIN
        Request(Rec."Document No.");
    END;

    [EventSubscriber(ObjectType::Page, 25, OnAfterActionEvent, VoidFacturae, true, true)]
    LOCAL PROCEDURE Page25VoidFacturae(VAR Rec: Record 21);
    BEGIN
        Void(Rec."Document No.");
    END;

    [EventSubscriber(ObjectType::Page, 132, OnAfterActionEvent, SendFacturae, true, true)]
    LOCAL PROCEDURE Page132_SendInvoiceToFacturae(VAR Rec: Record 112);
    BEGIN
        Send(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 132, OnAfterActionEvent, ExportFacturaefile, true, true)]
    LOCAL PROCEDURE Page132_ExportFacturaeFile(VAR Rec: Record 112);
    BEGIN
        Export(Rec."Sell-to Customer No.", Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 132, OnAfterActionEvent, RequestFacturae, true, true)]
    LOCAL PROCEDURE Page132_RequestFacturaeRequest(VAR Rec: Record 112);
    BEGIN
        Request(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 132, OnAfterActionEvent, VoidFacturae, true, true)]
    LOCAL PROCEDURE Page132_VoidFacturae(VAR Rec: Record 112);
    BEGIN
        Void(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 132, OnAfterActionEvent, AddLogFacturae, true, true)]
    LOCAL PROCEDURE Page132_AddLogFacturae(VAR Rec: Record 112);
    BEGIN
        AddLog(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 134, OnAfterActionEvent, SendFacturae, true, true)]
    LOCAL PROCEDURE Page134_SendInvoiceToFacturae(VAR Rec: Record 114);
    BEGIN
        Send(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 134, OnAfterActionEvent, ExportFacturaefile, true, true)]
    LOCAL PROCEDURE Page134_ExportFacturaeFile(VAR Rec: Record 114);
    BEGIN
        Export(Rec."Sell-to Customer No.", Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 134, OnAfterActionEvent, RequestFacturae, true, true)]
    LOCAL PROCEDURE Page134_RequestFacturaeRequest(VAR Rec: Record 114);
    BEGIN
        Request(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 134, OnAfterActionEvent, VoidFacturae, true, true)]
    LOCAL PROCEDURE Page134_VoidFacturae(VAR Rec: Record 114);
    BEGIN
        Void(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 143, OnAfterActionEvent, SendFacturae, true, true)]
    LOCAL PROCEDURE Page143_SendInvoiceToFacturae(VAR Rec: Record 112);
    BEGIN
        Send(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 143, OnAfterActionEvent, ExportFacturaefile, true, true)]
    LOCAL PROCEDURE Page143_ExportFacturaeFile(VAR Rec: Record 112);
    BEGIN
        Export(Rec."Sell-to Customer No.", Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 143, OnAfterActionEvent, RequestFacturae, true, true)]
    LOCAL PROCEDURE Page143_RequestFacturaeRequest(VAR Rec: Record 112);
    BEGIN
        Request(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 143, OnAfterActionEvent, VoidFacturae, true, true)]
    LOCAL PROCEDURE Page143_VoidFacturae(VAR Rec: Record 112);
    BEGIN
        Void(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 144, OnAfterActionEvent, SendFacturae, true, true)]
    LOCAL PROCEDURE Page144_SendInvoiceToFacturae(VAR Rec: Record 114);
    BEGIN
        Send(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 144, OnAfterActionEvent, ExportFacturaefile, true, true)]
    LOCAL PROCEDURE Page144_ExportFacturaeFile(VAR Rec: Record 114);
    BEGIN
        Export(Rec."Sell-to Customer No.", Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 144, OnAfterActionEvent, RequestFacturae, true, true)]
    LOCAL PROCEDURE Page144_RequestFacturaeRequest(VAR Rec: Record 114);
    BEGIN
        Request(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Page, 144, OnAfterActionEvent, VoidFacturae, true, true)]
    LOCAL PROCEDURE Page144_VoidFacturae(VAR Rec: Record 114);
    BEGIN
        Void(Rec."No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE Cod80OnBeforePostSalesDoc(VAR SalesHeader: Record 36);
    VAR
        Customer: Record 18;
        QuoFacturaeAdminCenter: Record 7174370;
        SalesLine: Record 37;
        Text50001: TextConst ENU = 'You must fill the Unit of measure code in all lines, to be sent by Face.', ESP = 'Debe tener relleno el c�d. unidad medida de todas las l�neas, para poder ser enviada por Face.';
        Text50002: TextConst ENU = 'You must have filled the unit of measure code of all lines, to be sent by Face. Do you want to continue?', ESP = 'No tiene relleno el cod. unidad de medida de todas las l�neas por lo que la factura no podr�a ser enviada a Face. �Desea continuar?';
        Error1: TextConst ENU = 'Canceled Process', ESP = 'Proceso Cancelado';
    BEGIN
        // QFA 0.2 Controlamos que el cod. unidad de medida vaya relleno en todas las l�neas porque es obligatorio.
        IF NOT AccessToFacturae THEN
            EXIT;

        IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader.Invoice = TRUE)) OR ((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETFILTER(Quantity, '<>%1', 0);
            SalesLine.SETRANGE("Unit of Measure Code", '');
            IF SalesLine.FINDSET THEN BEGIN
                QuoFacturaeAdminCenter.RESET;
                QuoFacturaeAdminCenter.SETRANGE("Customer no.", SalesHeader."Bill-to Customer No.");
                IF QuoFacturaeAdminCenter.FINDFIRST THEN BEGIN
                    ERROR(Text50001);
                END ELSE BEGIN
                    //-8792
                    /*{IF CONFIRM(Text50002,FALSE)= FALSE THEN
                                 ERROR(Text50001);}*/
                    IF NOT CONFIRM(Text50002, FALSE) THEN
                        ERROR(Error1);
                    //+8792
                END;
            END;
        END;
    END;

    PROCEDURE AccessToFacturae(): Boolean;
    VAR
        QuoFacturaeSetup: Record 7174368;
    BEGIN
        //Busca un campo booleano en una tabla y retorna su valor
        IF AccessToTablePermision(7174368) THEN
            IF QuoFacturaeSetup.GET() THEN
                EXIT(QuoFacturaeSetup.Enabled);

        EXIT(FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE AccessToTablePermision(pFile: Integer);
    VAR
        rRef: RecordRef;
        fRef: FieldRef;
    BEGIN
        //Verifico que existe la tabla y puedo acceder a ella
        rRef.OPEN(pFile);
        IF rRef.FINDFIRST THEN;
        rRef.CLOSE;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Funciones comunes a las PAGES"();
    BEGIN
    END;

    LOCAL PROCEDURE Send(NDoc: Code[20]);
    VAR
        CustLedgerEntry: Record 21;
        QuoFacturaeAdminCenter: Record 7174370;
        QuoFacturaeUploadManagement: Codeunit 7174341;
    BEGIN
        IF NOT AccessToFacturae THEN
            EXIT;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", NDoc);
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        IF NOT (CustLedgerEntry.FINDFIRST) THEN
            ERROR(Text80200);

        QuoFacturaeAdminCenter.RESET;
        QuoFacturaeAdminCenter.SETRANGE("Customer no.", CustLedgerEntry."Customer No.");
        QuoFacturaeAdminCenter.SETRANGE(Type, QuoFacturaeAdminCenter.Type::Payer);
        IF QuoFacturaeAdminCenter.FINDFIRST THEN
            //�Se controla que ya se haya enviado?
            QuoFacturaeUploadManagement.SendManualInvoiceToFace(CustLedgerEntry."Entry No.")
        ELSE
            ERROR(ClientNotFoundErr, CustLedgerEntry."Customer No.", QuoFacturaeAdminCenter.Type::Payer);
    END;

    LOCAL PROCEDURE Export(Customer: Code[20]; NDoc: Code[20]);
    VAR
        CustLedgerEntry: Record 21;
        QuoFacturaeAdminCenter: Record 7174370;
        QuoFacturaeUploadManagement: Codeunit 7174341;
        i: Integer;
    BEGIN
        IF NOT AccessToFacturae THEN
            EXIT;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", Customer);
        CustLedgerEntry.SETRANGE("Document No.", NDoc);
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        IF NOT (CustLedgerEntry.FINDFIRST) THEN
            ERROR(Text80200);

        QuoFacturaeAdminCenter.RESET;
        QuoFacturaeAdminCenter.SETRANGE("Customer no.", CustLedgerEntry."Customer No.");
        QuoFacturaeAdminCenter.SETRANGE(Type, QuoFacturaeAdminCenter.Type::Payer);
        IF QuoFacturaeAdminCenter.FINDFIRST THEN
            //�Se controla que ya se haya enviado?
            QuoFacturaeUploadManagement.CreateXMLFile(CustLedgerEntry."Entry No.")
        ELSE
            ERROR(ClientNotFoundErr, CustLedgerEntry."Customer No.", QuoFacturaeAdminCenter.Type::Payer);
    END;

    LOCAL PROCEDURE Request(NDoc: Code[20]);
    VAR
        CustLedgerEntry: Record 21;
        QuoFacturaeUploadManagement: Codeunit 7174341;
    BEGIN
        IF NOT AccessToFacturae THEN
            EXIT;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", NDoc);
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        IF NOT (CustLedgerEntry.FINDFIRST) THEN
            ERROR(Text80200);

        QuoFacturaeUploadManagement.SendManualRequestInvoiceToFace(CustLedgerEntry."Entry No.")
    END;

    LOCAL PROCEDURE Void(NDoc: Code[20]);
    VAR
        CustLedgerEntry: Record 21;
        QuoFacturaeUploadManagement: Codeunit 7174341;
        [RUNONCLIENT]
        Form: DotNet Form; // RUNONCLIENT;
        [RUNONCLIENT]
        FormBorderStyle: DotNet FormBorderStyle;// RUNONCLIENT;
        [RUNONCLIENT]
        FormStartPosition: DotNet FormStartPosition;// RUNONCLIENT;
        [RUNONCLIENT]
        LblRows: DotNet Label;// RUNONCLIENT;
        [RUNONCLIENT]
        TxtRows: DotNet RichTextBox;// RUNONCLIENT;
        [RUNONCLIENT]
        ButtonOk: DotNet Button;// RUNONCLIENT;
        [RUNONCLIENT]
        ButtonCancel: DotNet Button;// RUNONCLIENT;
        [RUNONCLIENT]
        DialogResult: DotNet DialogResult;// RUNONCLIENT;
    BEGIN
        IF NOT AccessToFacturae THEN
            EXIT;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", NDoc);
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        IF NOT (CustLedgerEntry.FINDFIRST) THEN
            ERROR(Text80200);

        Form := Form.Form();
        Form.Width := 400;
        Form.Height := 300;
        Form.FormBorderStyle := FormBorderStyle.FixedDialog;
        Form.Text := 'Anulaci�n de factura en Facturae';
        Form.StartPosition := FormStartPosition.CenterScreen;

        LblRows := LblRows.Label();
        LblRows.Text('Introduzca un motivo para la anulaci�n:');
        LblRows.Left(20);
        LblRows.Top(20);
        LblRows.AutoSize(TRUE);

        TxtRows := TxtRows.RichTextBox();
        TxtRows.Left(20);
        TxtRows.Top(50);
        TxtRows.Width(350);
        TxtRows.Height(150);

        ButtonOk := ButtonOk.Button();
        ButtonOk.Text('Ok');
        ButtonOk.Left(50);
        ButtonOk.Top(220);
        ButtonOk.Width(100);
        ButtonOk.DialogResult := DialogResult.OK;

        ButtonCancel := ButtonCancel.Button();
        ButtonCancel.Text('Cancel');
        ButtonCancel.Left(200);
        ButtonCancel.Top(220);
        ButtonCancel.Width(100);
        ButtonCancel.DialogResult := DialogResult.Cancel;

        Form.Controls.Add(LblRows);
        Form.Controls.Add(TxtRows);
        Form.Controls.Add(ButtonOk);
        Form.Controls.Add(ButtonCancel);

        Form.CancelButton := ButtonCancel;
        Form.AcceptButton := ButtonOk;

        IF Form.ShowDialog().ToString() = DialogResult.OK.ToString() THEN BEGIN
            IF TxtRows.Text <> '' THEN BEGIN
                QuoFacturaeUploadManagement.SendManualVoidInvoiceToFace(CustLedgerEntry."Entry No.", COPYSTR(TxtRows.Text, 1, 1024))
            END;
        END;

        Form.Dispose;
    END;

    LOCAL PROCEDURE AddLog(NDoc: Code[20]);
    VAR
        CustLedgerEntry: Record 21;
        QuoFacturaeEntry: Record 7174369;
        QuofacturaeManualEntry: Page 7174501;
        LastEntryNo: Integer;
    BEGIN
        IF NOT AccessToFacturae THEN
            EXIT;


        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", NDoc);
        CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        IF NOT (CustLedgerEntry.FINDFIRST) THEN
            ERROR(Text80200);

        CLEAR(QuofacturaeManualEntry);
        QuofacturaeManualEntry.LOOKUPMODE(TRUE);
        IF (QuofacturaeManualEntry.RUNMODAL = ACTION::LookupOK) THEN BEGIN

            QuoFacturaeEntry.RESET;
            IF QuoFacturaeEntry.FINDLAST THEN
                LastEntryNo := QuoFacturaeEntry."Entry no.";

            CLEAR(QuoFacturaeEntry);
            QuoFacturaeEntry.RESET;
            QuoFacturaeEntry.INIT;
            QuoFacturaeEntry.Datetime := CREATEDATETIME(TODAY, TIME);
            QuoFacturaeEntry."Document type" := QuoFacturaeEntry."Document type"::"Sales invoice";
            QuoFacturaeEntry."Document no." := CustLedgerEntry."Document No.";
            QuoFacturaeEntry."Entry no." := LastEntryNo + 1;
            QuoFacturaeEntry.Status := QuoFacturaeEntry.Status::Posted;
            QuoFacturaeEntry.Description := Text001 + ' ' + QuofacturaeManualEntry.GetNro + ' (' + Text002 + ' ' + USERID + ')';
            QuoFacturaeEntry.INSERT;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------------------PG 10766,10767 Cambios en documentos registrados"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Page, 10765, OnBeforeChangeDocument, '', true, true)]
    PROCEDURE PG10765_OnBeforeChangeDocument(Rec: Record 112);
    VAR
        SalesInvoiceHeader: Record 112;
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        WorkDescription: Text;
        xWorkDescription: Text;
        CR: Code[1];
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 06/07/22: - QFA 1.3r Esta funci�n maneja los cambios en Facturas de venta Regitradas, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        SalesInvoiceHeader.GET(Rec."No.");

        Rec.CALCFIELDS("Work Description");
        IF NOT Rec."Work Description".HASVALUE THEN
            WorkDescription := ''
        ELSE BEGIN
            CR[1] := 10;
            // TempBlob.Blob := Rec."Work Description";
            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(Rec."Work Description");
            // WorkDescription := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(CR);
            WorkDescription := CR;
        END;

        SalesInvoiceHeader.CALCFIELDS("Work Description");
        IF NOT Rec."Work Description".HASVALUE THEN
            xWorkDescription := ''
        ELSE BEGIN
            CR[1] := 10;
            //TempBlob.Blob := SalesInvoiceHeader."Work Description";
            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(SalesInvoiceHeader."Work Description");
            //xWorkDescription := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(CR);
            xWorkDescription := CR;
        END;

        IF (Rec."QFA Period Start Date" = SalesInvoiceHeader."QFA Period Start Date") AND
           (Rec."QFA Period End Date" = SalesInvoiceHeader."QFA Period End Date") AND
           (WorkDescription = xWorkDescription) THEN
            EXIT;


        //TempBlob.WriteAsText(WorkDescription, TEXTENCODING::Windows);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("WorkDescription");
        //SalesInvoiceHeader."Work Description" := TempBlob.Blob;                           //Actualizar descripci�n del trabajo
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        Instr.Read(SalesInvoiceHeader."Work Description");
        SalesInvoiceHeader."QFA Period Start Date" := Rec."QFA Period Start Date";        //Actualizar fechas del periodo
        SalesInvoiceHeader."QFA Period End Date" := Rec."QFA Period End Date";
        SalesInvoiceHeader.MODIFY;
    END;

    // [EventSubscriber(ObjectType::Page, 10766, OnBeforeChangeDocument, '', true, true)]
    PROCEDURE PG10766_OnBeforeChangeDocument(Rec: Record 114);
    VAR
        SalesCrMemoHeader: Record 114;
        TempBlob: Codeunit "Temp Blob";
        Instr: InStream;
        Blob: OutStream;
        WorkDescription: Text;
        xWorkDescription: Text;
        CR: Code[1];
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 06/07/22: - QFA 1.3r Esta funci�n maneja los cambios en Abonos de venta Regitrados, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        SalesCrMemoHeader.GET(Rec."No.");

        Rec.CALCFIELDS("Work Description");
        IF NOT Rec."Work Description".HASVALUE THEN
            WorkDescription := ''
        ELSE BEGIN
            CR[1] := 10;
            //TempBlob.Blob := Rec."Work Description";
            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(Rec."Work Description");
            //WorkDescription := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(CR);
            WorkDescription := CR;
        END;

        SalesCrMemoHeader.CALCFIELDS("Work Description");
        IF NOT SalesCrMemoHeader."Work Description".HASVALUE THEN
            xWorkDescription := ''
        ELSE BEGIN
            CR[1] := 10;
            //TempBlob.Blob := SalesCrMemoHeader."Work Description";
            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(SalesCrMemoHeader."Work Description");
            //xWorkDescription := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(CR);
            xWorkDescription := CR;
        END;

        IF (Rec."QFA Period Start Date" = SalesCrMemoHeader."QFA Period Start Date") AND
           (Rec."QFA Period End Date" = SalesCrMemoHeader."QFA Period End Date") AND
           (WorkDescription = xWorkDescription) THEN
            EXIT;

        //TempBlob.WriteAsText(WorkDescription, TEXTENCODING::Windows);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(WorkDescription);

        //SalesCrMemoHeader."Work Description" := TempBlob.Blob;                                        //Actualizar descripci�n del trabajo
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        Instr.Read(SalesCrMemoHeader."Work Description");
        SalesCrMemoHeader."QFA Period Start Date" := SalesCrMemoHeader."QFA Period Start Date";       //Actualizar fechas del periodo
        SalesCrMemoHeader."QFA Period End Date" := SalesCrMemoHeader."QFA Period End Date";
        SalesCrMemoHeader.MODIFY;
    END;


    /*BEGIN
    /*{
          QFA 0.2 08/11/18 JALA - Controlamos que todas las l�neas de factura tienen el cod. unidad de medida informado.
          Q8792 JMA 20/02/20 - Se reordena mensaje de confirmaci�n en Funci�n Cod80OnBeforePostSalesDoc
          JAV 14/09/20: - Se mejora la verificaci�n de que el m�dulo est� activo
          JAV 21/03/21: - QFA 1.3g Actualizar campos en las facturas de venta registradas para QFA
          JAV 24/03/21: - QFA 1.3h Se cambian las funciones que manejan los botones de Mov.Cli para que se puedan llamar desde mas pages
          Q13694 QMD 23/06/21 - Errores y pendientes de QuoSII
          JAV 06/07/22: - QFA 1.3r Se cambian las funciones CU10765_OnBeforeChangeDocumentSalesInvoice por PG10765_OnBeforeChangeDocument
                                                            CU10766_OnBeforeChangeDocumentSalesCrMemo  por PG10766_OnBeforeChangeDocument
        }
    END.*/
}










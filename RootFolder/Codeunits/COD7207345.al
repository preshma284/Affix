Codeunit 7207345 "QB Proform"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        OptProform: TextConst ENU = 'Proform,Invoice Proform', ESP = 'Proforma,�ltima Proforma';
        Text000: TextConst ESP = 'L�nea no genera proforma.';
        Text001: TextConst ESP = 'No puede generar proforma por mas de la cantidad a recibir mas lo recibido sin generar proforma menos lo recibido proformado (%1)';
        Text002: TextConst ESP = 'Reciba antes de generar proforma para poder registrar correctamente la proforma.';
        Text003: TextConst ESP = 'No puede generar proforma por mas de la cantidad recibida menos la ya generada (%1) en la l�nea %2';
        Text004: TextConst ESP = 'Gen. Proforma con fecha %1';
        Text005: TextConst ESP = 'Ha incluido l�neas que pueden estar en proformas, confirme que realmente desea continuar';
        Text006: TextConst ESP = 'Proceso Cancelado';
        Text007: TextConst ESP = '�Desea generar proforma por las cantidades indicadas en el documento?';
        Text008: TextConst ESP = 'No hay documentos posibles';
        Text009: TextConst ESP = 'Si genera la �ltima proforma se ajustar�n las cantidades del documento, �realmente desea generar la �ltima proforma?';
        Text010: TextConst ESP = 'Ya facturada';
        Text011: TextConst ESP = 'No encuentro el pedido %1';
        Text012: TextConst ESP = 'No ha indicado el n�mero de factura del proveedor';
        Text013: TextConst ESP = 'No hay una factura informada del proveedor y proyecto con ese n�mero.';
        Text014: TextConst ESP = 'El documento ya tiene l�neas, se eliminar�n antes de crear las nuevas, �Desea continuar?';
        Text015: TextConst ESP = 'No se ha generado una factura correcta,Importe Proforma: %1, Importe Factura: %2. Rev�selo bien antes de registrar.';
        Text016: TextConst ESP = 'Proforma %1';
        Text017: TextConst ESP = 'No facturada.';
        Text018: TextConst ESP = 'Factura registrada, no se puede desasociar.';
        Text019: TextConst ESP = 'No puede dejar la cantidad a recibir a origen (%1) por debajo de la cantidad en proformas generadas (%2).';
        PurchReceiptHeadNo_Vg: Code[20];

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos Tabla 38 Cabecera de Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnAfterInsertEvent(VAR Rec: Record 38; RunTrigger: Boolean);
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION DESPUES DE INSERTAR UN DOCUMENTO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------

        IF (RunTrigger) THEN BEGIN
            PurchasesPayablesSetup.GET;
            Rec."QB % Proformar" := PurchasesPayablesSetup."QB % Proforma";
            Rec.MODIFY;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnAfterDeleteEvent(VAR Rec: Record 38; RunTrigger: Boolean);
    VAR
        QBProformHeader: Record 7206960;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION DESPUES DE ELIMINAR UN DOCUMENTO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        IF (RunTrigger) THEN BEGIN
            IF (QBProformHeader.GET(Rec."QB From Proform")) THEN BEGIN
                QBProformHeader."Invoice No." := '';
                QBProformHeader.MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos Tabla 39 Lineas Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION AL VALIDAR EL CAMPO NO. DE UNA L�NEA DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - Al validar el campo "No." establecer la marca de proformable

        T39_SetLineProformable(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterSetDefaultQuantity, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterSetDefaultQuantity(VAR PurchLine: Record 39; VAR xPurchLine: Record 39);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION AL VALIDAR EL CAMPO CANTIDAD DE UNA L�NEA DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 24/04/21: - Tras validar la cantidad por defecto a recibir, volvemos a validar el campo para que lance los controles necesarios
        //++PurchLine.VALIDATE("Qty. to Receive");
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Qty. to Receive", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_QtytoReceive(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchasesPayablesSetup: Record 312;
        PurchaseHeader: Record 38;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION AL VALIDAR EL CAMPO CANTIDAD A RECIBIR DE UNA L�NEA DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - Cantidad que ponemos a proformar por defecto, solo de l�neas proformables

        //Establecer si la l�nea es proformable
        T39_SetLineProformable(Rec);

        //Si la l�nea es proformable
        IF (Rec."QB Line Proformable") THEN BEGIN
            //No podemos dejar la cantidad a recibir a origen por debajo de la cantidad proformada
            //OJO: He dejado a cero la cantidad a recibir por temas del est�ndar, uso el campo donde la guard� en su lugar
            IF (Rec."Quantity Received" + Rec."QB tmp Qty to recive" < Rec."QB Qty. Proformed") THEN
                ERROR(Text019, Rec."Quantity Received" + Rec."QB tmp Qty to recive", Rec."QB Qty. Proformed");

            //Si no estamos facturando desde una proforma ponemos la cantidad seg�n el % indicado en la cabecera
            IF (PurchaseHeader."QB From Proform" = '') THEN BEGIN
                PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
                Rec.VALIDATE("QB Qty. To Proform", ROUND(Rec."Qty. to Receive" * PurchaseHeader."QB % Proformar" / 100, 0.00001));
            END;
        END ELSE
            Rec.VALIDATE("QB Qty. To Proform", 0);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "QB Qty. To Proform", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_QBQtyToProform(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        MaxQty: Decimal;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION AL VALIDAR EL CAMPO CANTIDAD A PROFORMAR DE UNA L�NEA DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - Validar la cantidad a proformar
        IF (Rec."Document Type" <> Rec."Document Type"::Order) THEN
            EXIT;

        IF (Rec."QB Qty. To Proform" <> 0) THEN BEGIN
            IF (NOT Rec."QB Line Proformable") THEN
                ERROR(Text000);

            IF (NOT T39_Verify_QBQtyToProform(Rec, FALSE, MaxQty)) THEN
                ERROR(Text001, MaxQty);
        END;
    END;

    PROCEDURE T39_SetLineProformable(VAR Rec: Record 39);
    VAR
        Item: Record 27;
        Resource: Record 156;
        Ant: Boolean;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ESTABLECE EL CAMPO DE PROFORMABLE DE UNA L�NEA DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - Seg�n sea el producto o recurso poner la marca de proformable en la l�nea
        Ant := Rec."QB Line Proformable";

        Rec."QB Line Proformable" := FALSE;
        CASE Rec.Type OF
            Rec.Type::Item:
                IF (Item.GET(Rec."No.")) THEN
                    Rec."QB Line Proformable" := Item."QB Proformable";

            Rec.Type::Resource:
                IF (Resource.GET(Rec."No.")) THEN
                    Rec."QB Line Proformable" := Resource."QB Proformable";
        END;

        //Si ha cambiado me lo guardo si existe
        IF (Rec."QB Line Proformable" <> Ant) THEN
            IF Rec.MODIFY THEN;
    END;

    LOCAL PROCEDURE T39_Verify_QBQtyToProform(Rec: Record 39; OnlyReceived: Boolean; VAR MaxQty: Decimal): Boolean;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // VERIFICA QUE LA CANTIDAD A PROFORMAR ES CORRECTA EN UNA L�NEA DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - Verificar que es posible usar la cantidad a proformar

        IF (Rec."QB Line Proformable") THEN BEGIN
            Rec.CALCFIELDS("QB Qty. Proformed");
            IF (OnlyReceived) THEN
                MaxQty := Rec."Quantity Received" - Rec."QB Qty. Proformed"                             //M�ximo = Lo recibido menos lo ya proformado
            ELSE
                MaxQty := Rec."Qty. to Receive" + Rec."Quantity Received" - Rec."QB Qty. Proformed";    //M�ximo = Lo que vamos a recibir mas lo recibido menos lo ya proformado

            IF (Rec."QB Qty. To Proform" <> 0) AND (Rec."QB Qty. To Proform" > MaxQty) THEN
                EXIT(FALSE);

            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos Tabla 156 Recursos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 156, OnAfterValidateEvent, Type, true, true)]
    LOCAL PROCEDURE T156_OnAfterValidateEvent_Type(VAR Rec: Record 156; VAR xRec: Record 156; CurrFieldNo: Integer);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCION AL VALIDAR EL CAMPO TIPO DE UN RECURSO
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - Validar el tipo, si es subcontrata marcamos que es proformable por defecto

        Rec."QB Proformable" := (Rec.Type = Rec.Type::Subcontracting);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos Page 50"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 50, OnAfterActionEvent, Proform, true, true)]
    LOCAL PROCEDURE P50_OnAfterActionEvent_Proform(VAR Rec: Record 38);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCI�N DEL BOT�N PARA GENERAR UNA PROFORMA DESDE UN PEDIDO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------

        Btn_Proform(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 50, OnAfterActionEvent, QB_SeeProform, true, true)]
    LOCAL PROCEDURE P50_OnAfterActionEvent_QB_SeeProform(VAR Rec: Record 38);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCI�N DEL BOT�N PARA VER LAS PROFORMAS ASOCIADAS A UN PEDIDO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - QB 1.08.41 Ver las proformas de un pedido de compra

        Btn_SeeProform(Rec);
    END;

    LOCAL PROCEDURE Btn_Proform(VAR Rec: Record 38);
    VAR
        Selection: Integer;
        DefaultOption: Integer;
        txtDate: Text;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // GENERAR UNA PROFORMA DESDE UN PEDIDO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //Acci�n para generar la proforma
        DefaultOption := 1;
        txtDate := STRSUBSTNO(Text004, Rec."Posting Date");
        Selection := STRMENU(OptProform, DefaultOption, txtDate);
        CASE Selection OF
            1:
                Proform(Rec, FALSE, FALSE);
            2:
                Proform(Rec, TRUE, FALSE);
        END;
    END;

    LOCAL PROCEDURE Btn_SeeProform(VAR Rec: Record 38);
    VAR
        QBProformHeader: Record 7206960;
        QBProformList: Page 7207002;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // VER LA LISTA DE PROFORMAS ASOCIADAS A UN PEDIDO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 20/04/21: - QB 1.08.41 Ver las proformas de un pedido de compra

        QBProformHeader.RESET;
        QBProformHeader.SETRANGE("Order No.", Rec."No.");

        COMMIT; //Para el RunModal
        CLEAR(QBProformList);
        QBProformList.SETTABLEVIEW(QBProformHeader);
        QBProformList.RUNMODAL;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos Page 54"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 54, OnBeforeActionEvent, QB_LastProform, true, true)]
    LOCAL PROCEDURE P54_OnAfterActionEvent_Proform(VAR Rec: Record 39);
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // ACCI�N DEL BOT�N PARA CALCULAR LAS CANTIDADES DE LA �LTIMA PROFORMA EN LINEAS DE UN PEDIDO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------

        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        SetLastProformQty(PurchaseHeader);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos CU 74"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnAfterInsertLines, '', true, true)]
    LOCAL PROCEDURE CU74_OnAfterInsertLines(VAR PurchHeader: Record 38);
    VAR
        PurchaseHeaderOrder: Record 38;
        PurchaseLine: Record 39;
        PurchRcptLine: Record 121;
        Salir: Boolean;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // EVENTO DESPUES de insertar las l�neas de albar�n en la factura
        //--------------------------------------------------------------------------------------------------------------------------------
        IF (PurchHeader."QB From Proform" <> '') THEN   //JAV 08/06/21: QB 1.08.48 Saltar esto si entramos para facturar una proforma
            EXIT;

        Salir := FALSE;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
        IF (PurchaseLine.FINDSET(FALSE)) THEN
            REPEAT
                IF (PurchRcptLine.GET(PurchaseLine."Receipt No.", PurchaseLine."Receipt Line No.")) THEN BEGIN
                    PurchRcptLine.CALCFIELDS("QB Have Proforms");
                    IF (PurchRcptLine."QB Have Proforms") THEN BEGIN
                        IF NOT CONFIRM(Text005, FALSE) THEN
                            ERROR(Text006);
                        Salir := TRUE;
                    END;
                END;
            UNTIL (Salir) OR (PurchaseLine.NEXT = 0);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos CU 90 Post"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePurchInvHeaderInsert, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePurchInvHeaderInsert(VAR PurchInvHeader: Record 122; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // EVENTO ANTES de insertar la factura a generar en la CU de registro de compras
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 17/05/21: - QB 1.08.42 Al crear la factura desde una proforma, informar del pedido de origen
        IF (PurchHeader."QB Order No." <> '') THEN
            PurchInvHeader."Order No." := PurchHeader."QB Order No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostPurchaseDoc(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        PurchaseLine: Record 39;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // EVENTO ANTES de registrar la factura generada en la CU de registro de compras
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 04/05/21: - QB 1.08.41 Antes de registrar miro si tiene cantidades a proformar, si es as� pregunto si desea proformar esas cantidades

        IF (PreviewMode) OR (NOT PurchaseHeader.Receive) OR (PurchaseHeader."QB Generate Proform") THEN
            EXIT;

        IF (DocHaveProformQtry(PurchaseHeader)) THEN
            IF CONFIRM(Text007, TRUE) THEN
                Proform(PurchaseHeader, FALSE, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchLine, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostPurchLine(VAR PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    VAR
        PurchRcptLine: Record 121;
        QBProformLine: Record 7206961;
        Price: Decimal;
        Pasada: Integer;
        Cantidad: Decimal;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // EVENTO DESPUES de registrar una l�nea de una factura generada en la CU de registro de compras
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 21/04/21: - QB 1.08.41 Tras registrar una factura reducir la cantidad pendiente de facturar de la proforma

        //No para las facturas que se generan desde la proforma
        IF (PurchaseHeader."QB From Proform" = '') THEN BEGIN
            //Tomo el precio de la l�nea, pero si viene de un albar�n tomo el del albar�n
            Price := PurchaseLine."Direct Unit Cost";
            IF (PurchRcptLine.GET(PurchaseLine."Receipt No.", PurchaseLine."Receipt Line No.")) THEN
                Price := PurchRcptLine."Direct Unit Cost";

            Pasada := 0;
            Cantidad := PurchaseLine."Qty. to Invoice";
            REPEAT
                Pasada += 1;
                QBProformLine.RESET;
                QBProformLine.SETRANGE("Buy-from Vendor No.", PurchaseLine."Buy-from Vendor No.");
                QBProformLine.SETRANGE("Job No.", PurchaseLine."Job No.");
                QBProformLine.SETRANGE("No.", PurchaseLine."No.");
                QBProformLine.SETRANGE("Direct Unit Cost", Price);
                QBProformLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>0');
                IF (QBProformLine.FINDSET(TRUE)) THEN
                    REPEAT
                        IF (Cantidad >= QBProformLine."Qty. Rcd. Not Invoiced") THEN BEGIN
                            Cantidad -= QBProformLine."Qty. Rcd. Not Invoiced";
                            QBProformLine."Quantity Invoiced" += QBProformLine."Qty. Rcd. Not Invoiced";
                            QBProformLine."Qty. Rcd. Not Invoiced" := 0;
                        END ELSE BEGIN
                            QBProformLine."Quantity Invoiced" += Cantidad;
                            QBProformLine."Qty. Rcd. Not Invoiced" -= Cantidad;
                            Cantidad := 0;
                        END;

                        QBProformLine.MODIFY;
                    UNTIL (Cantidad <= 0) OR (QBProformLine.NEXT = 0);
                Price := 0; //Si queda cantidad sin repartir, la buscamos sin el mismo precio, no es lo mejor pero debe funcionar.
            UNTIL (Cantidad <= 0) OR (Pasada = 2);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostPurchaseDoc(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean);
    VAR
        QBProformHeader: Record 7206960;
        QBProformLine: Record 7206961;
        PurchInvLine: Record 123;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // EVENTO DESPUES de terminar el proceso de registro en la CU de registro de compras
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 21/04/21: - QB 1.08.41 Tras registrar una factura reducir la cantidad pendiente de facturar de la proforma

        //Solo para las facturas que se generan desde la proforma, guardo el n�mero de la factura definitivo y la cantidad facturada
        IF (QBProformHeader.GET(PurchaseHeader."QB From Proform")) THEN BEGIN
            QBProformHeader."Invoice No." := PurchInvHdrNo;
            QBProformHeader.MODIFY;

            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Document No.", PurchInvHdrNo);
            IF (PurchInvLine.FINDSET(FALSE)) THEN
                REPEAT
                    QBProformLine.RESET;
                    QBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
                    QBProformLine.SETRANGE("Order No.", PurchInvLine."Order No.");
                    QBProformLine.SETRANGE("Order Line No.", PurchInvLine."Order Line No.");
                    IF (QBProformLine.FINDFIRST) THEN BEGIN
                        QBProformLine."Quantity Invoiced" += PurchInvLine.Quantity;
                        QBProformLine."Qty. Rcd. Not Invoiced" -= PurchInvLine.Quantity;
                        QBProformLine.MODIFY;
                    END;
                UNTIL (PurchInvLine.NEXT = 0);

            //Quito la marca de la proforma del pedido de compra
            PurchaseHeader."QB From Proform" := '';
            IF PurchaseHeader.MODIFY THEN;
        END;

        //Q19675 BS18286 CSM 30/03/2023. � Mediciones al cancelar albar�n. -
        PurchReceiptHeadNo_Vg := PurchRcpHdrNo;
        //Q19675 BS18286 CSM 30/03/2023. � Mediciones al cancelar albar�n. +


        //Si tras registrar un albar�n debemos genera proforma
        IF (PurchaseHeader."QB Generate Proform") THEN BEGIN
            Proform(PurchaseHeader, FALSE, FALSE);
            PurchaseHeader."QB Generate Proform" := FALSE;
            PurchaseHeader.MODIFY;
        END;
    END;

    PROCEDURE DocHaveProformQtry(PurchaseHeader: Record 38): Boolean;
    VAR
        PurchaseLine: Record 39;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // VERIFICAR QUE UN DOCUMENTO DE COMPRA TENGA CANTIDADES A PROFORMAR
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 04/05/21: - QB 1.08.41 Retorna si el documento tiene cantidades a proformar informadas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.SETFILTER("QB Qty. To Proform", '<>0');
        EXIT(NOT PurchaseLine.ISEMPTY);
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Auxiliares para las proformas"();
    BEGIN
    END;

    PROCEDURE CreateNewRecord(VAR QBProformHeader: Record 7206960): Code[20];
    VAR
        PurchaseHeader: Record 38;
        PurchaseList: Page 53;
        DocNo: Code[20];
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // CREAR UNA PROFORMA EN BLANCO A PARTIR DE UN PEDIDO DE COMPRA
        //--------------------------------------------------------------------------------------------------------------------------------

        IF NOT SelectDocument(PurchaseHeader, ConvertDocumentTypeToOptionPurchaseDocumentType(PurchaseHeader."Document Type"::Order), '', '') THEN
            ERROR(Text006);

        EXIT(Proform(PurchaseHeader, FALSE, TRUE))
    END;

    PROCEDURE SelectDocument(VAR PurchaseHeader: Record 38; pType: Option; pJob: Code[20]; pVendor: Code[20]): Boolean;
    VAR
        PurchaseList: Page 53;
        i: Integer;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // PRESENTAR LA LISTA DE DOCUMENTOS DE COMPRA Y ELEGIR UNO
        //--------------------------------------------------------------------------------------------------------------------------------

        CASE pType OF
            ConvertDocumentTypeToOptionPurchaseDocumentType(PurchaseHeader."Document Type"::Order): //Si es desde un pedido sacamos todos los que tengan proyecto
                BEGIN
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETFILTER("QB Job No.", '<>%1', '');
                    PurchaseHeader.FILTERGROUP(2);
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.FILTERGROUP(0);
                END;
            ConvertDocumentTypeToOptionPurchaseDocumentType(PurchaseHeader."Document Type"::Invoice):
                BEGIN
                    //Si es desde una factura sacamos las facturas creadas del proyecto y proveedor
                    PurchaseHeader.RESET;
                    PurchaseHeader.FILTERGROUP(2);
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Invoice);
                    PurchaseHeader.SETRANGE("Buy-from Vendor No.", pVendor);
                    PurchaseHeader.SETRANGE("QB Job No.", pJob);
                    PurchaseHeader.FILTERGROUP(0);
                END;
        END;

        IF (PurchaseHeader.ISEMPTY) THEN BEGIN
            ERROR(Text008);
            EXIT(FALSE);
        END;

        CLEAR(PurchaseList);
        PurchaseList.SETTABLEVIEW(PurchaseHeader);
        PurchaseList.LOOKUPMODE(TRUE);

        IF (PurchaseList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            PurchaseList.GETRECORD(PurchaseHeader);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    END;

    PROCEDURE GetRecurrentLines(VAR QBProformHeader: Record 7206960);
    VAR
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        QBProformLine: Record 7206961;
        StdVendPurchCode: Record 175;
        LineNo: Integer;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // A�adir l�neas recurrentes a la proforma. Uso el procedimiento est�ndar de incluir l�neas recurrentes en documentos de compra
        //--------------------------------------------------------------------------------------------------------------------------------

        //Busco la �ltima l�nea de la proforma, si no hay ninguna esta proforma no es v�lida
        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
        QBProformLine.FINDLAST;
        LineNo := QBProformLine."Line No.";

        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE("Document Type", 100);
        PurchaseHeader.DELETEALL;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", 100);
        PurchaseLine.DELETEALL;

        //Crear una cabecera de compra auxiliar
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := Enum::"Purchase Document Type From".FromInteger(100);
        PurchaseHeader."No." := 'R' + FORMAT(SESSIONID);
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", QBProformHeader."Buy-from Vendor No.");
        PurchaseHeader."Currency Code" := QBProformHeader."Currency Code";
        PurchaseHeader."Prices Including VAT" := FALSE;
        PurchaseHeader.INSERT;

        COMMIT; // Por el Run Modal
        StdVendPurchCode.InsertPurchLines(PurchaseHeader);

        //Traspaso las l�neas a la proforma y las elimino de la tabla de l�neas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchaseLine.FINDSET(TRUE) THEN
            REPEAT
                LineNo += 10000;

                QBProformLine.INIT;
                QBProformLine.TRANSFERFIELDS(PurchaseLine);
                QBProformLine."Document No." := QBProformHeader."No.";
                QBProformLine."Line No." := LineNo;
                QBProformLine."QB Recurrent Line" := TRUE;
                QBProformLine.INSERT;

                PurchaseLine.DELETE;
            UNTIL PurchaseLine.NEXT = 0;

        //Borrar el documento auxiliar creado
        PurchaseHeader.DELETE;
        COMMIT;
    END;

    PROCEDURE SetLastProformQty(VAR PurchHeader: Record 38);
    VAR
        PurchLine: Record 39;
        NothingToPostErr: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // AJUSTAR LAS CANTIDADES DE LA �LTIMA PROFORMA
        //--------------------------------------------------------------------------------------------------------------------------------
        //Informar de las cantidades te�ricas de la �ltima proforma, cantidad recibida total - cantidad proformada total

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        PurchLine.SETRANGE("QB Line Proformable", TRUE);
        IF (PurchLine.FINDSET(TRUE)) THEN
            REPEAT
                PurchLine.CALCFIELDS("QB Qty. Proformed");
                PurchLine."QB Qty. To Proform" := PurchLine."Qty. to Receive" + PurchLine."Quantity Received" - PurchLine."QB Qty. Proformed";
                PurchLine.MODIFY;
            UNTIL (PurchLine.NEXT = 0);
    END;

    PROCEDURE RecalculateOrigin(QBProformHeader: Record 7206960);
    VAR
        QBProformLine: Record 7206961;
        QBProformLineOrigin: Record 7206961;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // Funci�n que recalcula las cantidades a origen de todas las l�neas de una proforma
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 24/05/21: - QB 1.08.44 recalcular
        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
        IF (QBProformLine.FINDSET(TRUE)) THEN
            REPEAT
                RecalculateLineOrigin(QBProformLine, QBProformLineOrigin.Quantity);
            UNTIL (QBProformLine.NEXT = 0);
    END;

    PROCEDURE RecalculateLineOrigin(VAR QBProformLine: Record 7206961; pQty: Decimal);
    VAR
        QBProformLineOrigin: Record 7206961;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // Funci�n que recalcula las cantidades a origen de una l�nea de la proforma
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 24/05/21: - QB 1.08.46 recalcular

        //Empezamos poniendo la cantidad que nos indican y sumamos luego las de anteriores documentos
        IF (QBProformLine."QB Recurrent Line") THEN
            QBProformLine."QB Qty. Proformed Origin" := 0
        ELSE
            QBProformLine."QB Qty. Proformed Origin" := pQty;

        QBProformLineOrigin.RESET;
        QBProformLineOrigin.SETRANGE("Order No.", QBProformLine."Order No.");
        QBProformLineOrigin.SETRANGE("Order Line No.", QBProformLine."Order Line No.");
        QBProformLineOrigin.SETFILTER("Document No.", '<%1', QBProformLine."Document No.");
        IF (QBProformLineOrigin.FINDSET(TRUE)) THEN
            REPEAT
                IF (NOT QBProformLineOrigin."QB Recurrent Line") THEN
                    QBProformLine."QB Qty. Proformed Origin" += QBProformLineOrigin.Quantity;
            UNTIL (QBProformLineOrigin.NEXT = 0);

        //JAV 29/11/21: - QB 1.10.02 Esto es por si hay l�neas mal calculadas, as� si arreglan, pero si no existe todav�a la l�nea no puedo modificar
        QBProformLine.CalculateAmounts;
        IF QBProformLine.MODIFY THEN;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Registrar"();
    BEGIN
    END;

    PROCEDURE Proform(VAR PurchHeader: Record 38; Last: Boolean; Empty: Boolean): Code[20];
    VAR
        PurchasesPayablesSetup: Record 312;
        QBProformHeader: Record 7206960;
        QBProformLine: Record 7206961;
        DataPieceworkForProduction: Record 7207386;
        SourceCodeSetup: Record 242;
        PurchLine: Record 39;
        NoSeriesMgt: Codeunit 396;
        NothingToPostErr: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        DocNumber: Code[20];
        MaxQty: Decimal;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // Funci�n que crea una proforma a partir de un pedido de compra, con cantidades informadas o sin ellas
        //--------------------------------------------------------------------------------------------------------------------------------
        //JAV 21/04/21: - QB 1.08.41 Crear una proforma

        SourceCodeSetup.GET;
        PurchasesPayablesSetup.GET;

        //Ver si hay algo que registrar
        IF (NOT Empty) THEN BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.SETFILTER("QB Qty. To Proform", '<>%1', 0);
            IF PurchLine.ISEMPTY THEN
                ERROR(NothingToPostErr);
        END;

        //Si es la �ltima proforma confirmar el cierre del documento, si se cierra hay que dejar la cantidad igual a la proformada a origen para que no se siga recibiendo mas
        IF (Last) THEN BEGIN
            IF (NOT CONFIRM(Text009, FALSE)) THEN
                EXIT;

            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.SETRANGE("QB Line Proformable", TRUE);
            IF (PurchLine.FINDSET(TRUE)) THEN
                REPEAT
                    PurchLine.CALCFIELDS("QB Qty. Proformed");
                    PurchLine.Quantity := PurchLine."Quantity Received";
                    PurchLine."Outstanding Quantity" := 0;
                    PurchLine.MODIFY;
                UNTIL (PurchLine.NEXT = 0);
        END;

        //Crear la cabecera de la proforma
        DocNumber := NoSeriesMgt.GetNextNo(PurchasesPayablesSetup."QB Proforma No. Series", PurchHeader."Posting Date", TRUE); //No. serie en la configuraci�n de compras y pagos
        QBProformHeader.INIT;
        QBProformHeader.TRANSFERFIELDS(PurchHeader);
        QBProformHeader."No." := DocNumber;
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN BEGIN
            QBProformHeader."Order No. Series" := PurchHeader."No. Series";
            QBProformHeader."Order No." := PurchHeader."No.";
        END;
        QBProformHeader."No. Printed" := 0;
        QBProformHeader."Source Code" := SourceCodeSetup.Purchases;
        QBProformHeader."User ID" := USERID;
        QBProformHeader."Last Proform" := Last;
        QBProformHeader."Last Proform Generated" := Last;   //Indica que se ha generado directamente como �ltima proforma para que no se pueda tocar
        QBProformHeader."Order No." := PurchHeader."No.";

        IF (Empty) AND (PurchasesPayablesSetup."QB Proforma Date" = PurchasesPayablesSetup."QB Proforma Date"::Work) THEN
            QBProformHeader.VALIDATE("Order Date", WORKDATE)
        ELSE
            QBProformHeader.VALIDATE("Order Date", PurchHeader."Posting Date");

        QBProformHeader.INSERT(TRUE);

        //Establecer si las l�neas son proformables por si ha cambiado algo
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        IF PurchLine.FINDSET(TRUE) THEN
            REPEAT
                T39_SetLineProformable(PurchLine);

                //Si la l�nea es proformable, revisar que  no se supere la cantidad m�xima
                IF (PurchLine."QB Line Proformable") THEN BEGIN
                    IF (NOT T39_Verify_QBQtyToProform(PurchLine, NOT PurchHeader."QB Generate Proform", MaxQty)) THEN
                        IF (PurchLine."Qty. to Receive" <> 0) THEN
                            ERROR(Text002)
                        ELSE
                            ERROR(Text003, MaxQty, PurchLine."Line No.");
                END;
            UNTIL (PurchLine.NEXT = 0);

        //Crear las l�neas de la proforma
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        PurchLine.SETRANGE("QB Line Proformable", TRUE);
        IF PurchLine.FINDSET(TRUE) THEN
            REPEAT
                IF (NOT DataPieceworkForProduction.GET(PurchLine."Job No.", PurchLine."Piecework No.")) THEN
                ;//++  ERROR(txtErr01);

                QBProformLine.INIT;
                QBProformLine.TRANSFERFIELDS(PurchLine);
                QBProformLine."Document No." := DocNumber;

                QBProformLine."Posting Date" := QBProformHeader."Posting Date";
                QBProformLine."Document No." := QBProformHeader."No.";
                QBProformLine.Quantity := PurchLine."QB Qty. To Proform";
                QBProformLine."Quantity Invoiced" := 0;
                QBProformLine."Qty. Rcd. Not Invoiced" := QBProformLine.Quantity - QBProformLine."Quantity Invoiced";
                QBProformLine."Order No." := PurchLine."Document No.";
                QBProformLine."Order Line No." := PurchLine."Line No.";
                QBProformLine."QB Qty Received Origin" := PurchLine."Quantity Received";
                //-Q19675 BS18286 CSM 30/03/2023. � Mediciones al cancelar albar�n. -
                IF PurchReceiptHeadNo_Vg <> '' THEN
                    QBProformLine."Receipt No." := PurchReceiptHeadNo_Vg
                ELSE
                    QBProformLine."Receipt No." := PurchHeader."Last Receiving No.";
                //+Q19675 BS18286 CSM 30/03/2023. � Mediciones al cancelar albar�n. +
                QBProformLine.INSERT(TRUE);

                PurchLine."QB Qty. To Proform" := 0;
                PurchLine.MODIFY;
            UNTIL PurchLine.NEXT = 0;

        //Recalcular a origen
        RecalculateOrigin(QBProformHeader);

        //Retornamos el n�mero de proforma creado
        EXIT(QBProformHeader."No.");
    END;

    PROCEDURE Invoice(VAR QBProformHeader: Record 7206960; NewInvoide: Boolean);
    VAR
        QBProformLine: Record 7206961;
        tmpQBProformLine: Record 7206961 TEMPORARY;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseLine2: Record 39;
        PurchRcptLine: Record 121;
        PurchRcptLine2: Record 121;
        PurchaseInvoice: Page 51;
        PurchPost: Codeunit 90;
        PurchGetReceipt: Codeunit 74;
        WithholdingTreating: Codeunit 7207306;
        TotalQty: Decimal;
        Qty: Decimal;
        LineNo: Integer;
        GrVAT: Code[20];
        txtAux: Text;
        TAmount: Decimal;
        TOrigin: Decimal;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // JAV 05/05/21: - QB 1.08.41 Crear la factura de compra de la proforma
        //--------------------------------------------------------------------------------------------------------------------------------

        IF (QBProformHeader."Invoice No." <> '') THEN
            ERROR('Ya facturada');

        IF (NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, QBProformHeader."Order No.")) THEN
            ERROR(Text011, QBProformHeader."Order No.");

        //Si hay que crear una factura nueva o usar una existente
        IF (NewInvoide) THEN BEGIN
            IF (QBProformHeader."Vendor Invoice No." = '') THEN
                ERROR(Text012);

            //Preparar la cabecera de la factura
            CLEAR(PurchaseHeader);
            PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Invoice);
            PurchaseHeader.VALIDATE("Buy-from Vendor No.", QBProformHeader."Buy-from Vendor No.");
            PurchaseHeader.VALIDATE("Vendor Invoice No.", QBProformHeader."Vendor Invoice No.");
            PurchaseHeader.VALIDATE("Posting Date", QBProformHeader."Posting Date");          //Para que tome el n�mero correctamente seg�n la fecha debe estar antes de crear
            PurchaseHeader.INSERT(TRUE);
            //Ajustar campos
            PurchaseHeader.VALIDATE("Document Date", QBProformHeader."Document Date");        //No podemos ponerla antes de crear porque la cambia a la de trabajo
            PurchaseHeader.VALIDATE("Payment Method Code", QBProformHeader."Payment Method Code");
            PurchaseHeader.VALIDATE("Payment Terms Code", QBProformHeader."Payment Terms Code");
            PurchaseHeader.VALIDATE("Currency Code", QBProformHeader."Currency Code");
            PurchaseHeader.VALIDATE("Purchaser Code", QBProformHeader."Purchaser Code");
            PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", QBProformHeader."Shortcut Dimension 1 Code");
            PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code", QBProformHeader."Shortcut Dimension 2 Code");
            PurchaseHeader.VALIDATE("Dimension Set ID", QBProformHeader."Dimension Set ID");
            PurchaseHeader.MODIFY(TRUE);
        END ELSE BEGIN
            //Si no ponen el n�mero de la factura, lo buscamos entre las facturas sin registrar existentes del proveedor
            IF (QBProformHeader."Vendor Invoice No." = '') THEN BEGIN
                IF NOT SelectDocument(PurchaseHeader, ConvertDocumentTypeToOptionPurchaseDocumentType(PurchaseHeader."Document Type"::Invoice), QBProformHeader."Job No.", QBProformHeader."Buy-from Vendor No.") THEN
                    ERROR(Text006);
            END ELSE BEGIN
                //Si hay nro de factura, busco ese documento expresamente
                PurchaseHeader.RESET;
                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Invoice);
                PurchaseHeader.SETRANGE("Buy-from Vendor No.", QBProformHeader."Buy-from Vendor No.");
                PurchaseHeader.SETRANGE("QB Job No.", QBProformHeader."Job No.");
                PurchaseHeader.SETRANGE("Vendor Invoice No.", QBProformHeader."Vendor Invoice No.");
                IF (NOT PurchaseHeader.FINDFIRST) THEN
                    ERROR(Text013);
            END;
        END;
        //Datos adicionales en la cabecera
        PurchaseHeader.VALIDATE("QB Order No.", QBProformHeader."Order No.");  //JAV 17/05/21 - QB 1.08.43 Se a�ade el pedido de origen
        PurchaseHeader."QB From Proform" := QBProformHeader."No.";
        //JAV 10/11/21: - QB 1.09.27 Establecemos el proyecto en la cabecera si no tiene uno o es diferente al que tenemos.
        IF (PurchaseHeader."QB Job No." <> QBProformHeader."Job No.") THEN
            PurchaseHeader.VALIDATE("QB Job No.", QBProformHeader."Job No.");

        PurchaseHeader.MODIFY(TRUE);

        //Guardar los datos de la factura en la proforma
        QBProformHeader."Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
        QBProformHeader."Posting Date" := PurchaseHeader."Posting Date";
        QBProformHeader."Document Date" := PurchaseHeader."Document Date";
        QBProformHeader."Invoice No." := PurchaseHeader."No.";
        QBProformHeader.MODIFY;

        //Miro si tiene l�neas el documento para pedir confirmaci�n
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF (NOT PurchaseLine.ISEMPTY) THEN
            IF NOT CONFIRM(Text014, FALSE) THEN
                ERROR('');
        PurchaseLine.DELETEALL;
        //COMMIT;   ////JAV 11/07/22: - QB 1.11.00 Solo para pruebas

        //----------------------------------------------------------------------------------------
        // Crear las l�neas
        //----------------------------------------------------------------------------------------

        //A�ado la l�nea de la proforma
        PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 10000;
        PurchaseLine.Description := STRSUBSTNO(Text016, QBProformHeader."No.");
        PurchaseLine.INSERT;

        //JAV 29/11/21: - QB 1.10.02 Cambio la manera de obtener los albaranes a facturar. Ahora recorro las l�neas de la proforma, de ellos
        //                           busco los albaranes que se corresponden con el mismo pedido y l�nea que son los que debo facturar
        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
        QBProformLine.SETRANGE("QB Recurrent Line", FALSE);
        QBProformLine.SETFILTER(Quantity, '<>0');  //Solo miro l�neas con cantidad, las que est�n a cero no hay que hacer nada con ellas
        IF (QBProformLine.FINDSET(FALSE)) THEN
            REPEAT
                Qty := QBProformLine.Quantity;   //Esta es la cantidad total que debo buscar en los albaranes

                //Busco los albaranes de la misma l�nea de pedido para facturarlos
                PurchRcptLine.RESET;
                PurchRcptLine.SETCURRENTKEY("Order No.", "Order Line No.");
                PurchRcptLine.SETRANGE("Order No.", QBProformLine."Order No.");
                PurchRcptLine.SETRANGE("Order Line No.", QBProformLine."Order Line No.");
                PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>0');   //Facturamos la cantidad pendiente, si no tiene no considero la l�nea
                PurchRcptLine.SETRANGE(Cancelled, FALSE); //JAV 11/07/22: - QB 1.11.00 Se fuerza que las l�neas de los albaranes no est�n canceladas
                IF (PurchRcptLine.FINDSET(TRUE)) THEN
                    REPEAT
                        //Preparo la l�nea
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        //A�ado la l�nea del albar�n
                        PurchRcptLine2 := PurchRcptLine;
                        PurchRcptLine2.InsertInvLineFromRcptLine(PurchaseLine);
                        //Ajusto la cantidad si es necesario, al insertarla ya me la ha reducido con la cantidad pendiente
                        IF (PurchaseLine.Quantity > Qty) THEN BEGIN
                            PurchaseLine.VALIDATE(Quantity, Qty);
                            PurchaseLine.MODIFY;
                        END;

                        //JAV 15/12/21: - QB 1.10.07 Si tiene almac�n se lo quito
                        IF (PurchaseLine."Location Code" <> '') THEN BEGIN
                            PurchaseLine."Location Code" := '';
                            PurchaseLine.MODIFY;
                        END;

                        //Quito del total pendiente lo que he incluido en el documento
                        Qty -= PurchaseLine.Quantity;
                    UNTIL (Qty = 0) OR (PurchRcptLine.NEXT = 0);
            UNTIL (QBProformLine.NEXT = 0);

        //Verificar que el importe coincida
        PurchaseHeader.CALCFIELDS(Amount);
        QBProformHeader.CalculateTotal(TAmount, TOrigin);  //+++
        IF (ABS(PurchaseHeader.Amount - TAmount) > 0.05) THEN
            MESSAGE(Text015, TAmount, PurchaseHeader.Amount);
        /*{-----------------------------------------------------------------------------------------------------------------------------------------
              //Usando el est�ndar para traer todos los albaranes a la factura
              PurchRcptLine.RESET;
              PurchRcptLine.SETRANGE("Buy-from Vendor No.", QBProformHeader."Buy-from Vendor No.");
              PurchRcptLine.SETRANGE("Job No.", QBProformHeader."Job No.");
              PurchRcptLine.SETRANGE("Order No.", QBProformHeader."Order No.");
              PurchRcptLine.SETRANGE("Currency Code", QBProformHeader."Currency Code");

              PurchRcptLine.SETRANGE(Correction,FALSE); //JAV 24/09/21: - QB 1.09.19 No incluir las l�neas de correcci�n +++

              CLEAR(PurchGetReceipt);
              PurchGetReceipt.SetPurchHeader(PurchaseHeader);
              PurchGetReceipt.CreateInvLines(PurchRcptLine);

              //Ajustar las cantidades de la factura creada con la cantidad a proformar, monto una tabla auxiliar sumando cantidades del mismo producto/recurso/precio +++
              tmpQBProformLine.RESET;
              tmpQBProformLine.DELETEALL;
              CLEAR(tmpQBProformLine);

              QBProformLine.RESET;
              QBProformLine.SETCURRENTKEY("Document No.",Type,"No.");
              QBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
              QBProformLine.SETRANGE("QB Recurrent Line", FALSE);
              QBProformLine.SETFILTER(Quantity, '<>0');  //Solo miro l�neas con cantidad, las que est�n a cero no hay que hacer nada con ellas
              IF (QBProformLine.FINDSET(FALSE)) THEN
                REPEAT
              //    IF (QBProformLine.Type = tmpQBProformLine.Type) AND (QBProformLine."No." = tmpQBProformLine."No.") AND (QBProformLine."Direct Unit Cost" = tmpQBProformLine."Direct Unit Cost") THEN BEGIN
              //      tmpQBProformLine.Quantity += QBProformLine.Quantity;
              //      tmpQBProformLine.MODIFY;
              //    END ELSE BEGIN
                    tmpQBProformLine := QBProformLine;
                    tmpQBProformLine.INSERT;
              //    END;
                UNTIL (QBProformLine.NEXT = 0);

              TotalQty := 0;
              tmpQBProformLine.RESET;
              //tmpQBProformLine.SETCURRENTKEY("Document No.",Type,"No.");
              tmpQBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
              tmpQBProformLine.SETRANGE("QB Recurrent Line", FALSE);
              IF (tmpQBProformLine.FINDSET(FALSE)) THEN
                REPEAT
                  Qty := tmpQBProformLine.Quantity;
                  TotalQty += Qty;
                  //Ajusto las cantidades de los albaranes
                  PurchaseLine.RESET;
                  PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                  PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                  PurchaseLine.SETRANGE(Type, tmpQBProformLine.Type);
                  PurchaseLine.SETRANGE("No.", tmpQBProformLine."No.");
                  PurchaseLine.SETRANGE("Direct Unit Cost", tmpQBProformLine."Direct Unit Cost");   //JAV 24/09/21: - QB 1.09.19 Deben tener el mismo precio
                  PurchaseLine.SETRANGE("QB Proform Adjusted", FALSE);                              //JAV 24/09/21: - QB 1.09.19 que no haya sido ya ajustada
                  IF (PurchaseLine.FINDSET(TRUE)) THEN
                    REPEAT
                      IF (Qty > 0) AND (PurchaseLine.Quantity > 0) THEN BEGIN
                        IF (Qty >= PurchaseLine.Quantity) THEN
                          Qty -= PurchaseLine.Quantity
                        ELSE BEGIN
                          PurchaseLine.VALIDATE(Quantity, Qty);
                          Qty := 0;
                        END;
                        PurchaseLine."QB Proform Adjusted" := TRUE;
                      END;
                      IF (Qty < 0) AND (PurchaseLine.Quantity < 0) THEN BEGIN
                        IF (Qty <= PurchaseLine.Quantity) THEN
                          Qty += PurchaseLine.Quantity
                        ELSE BEGIN
                          PurchaseLine.VALIDATE(Quantity, Qty);
                          Qty := 0;
                        END;
                        PurchaseLine."QB Proform Adjusted" := TRUE;
                      END;
                      IF (PurchaseLine."QB Proform Adjusted") THEN BEGIN
                        PurchaseLine.MODIFY;
                        TotalQty -= PurchaseLine.Quantity;
                      END;
                    UNTIL (PurchaseLine.NEXT = 0);
                UNTIL (tmpQBProformLine.NEXT = 0);

              IF (TotalQty <> 0) THEN
                MESSAGE(Text015, TotalQty);

              //Borro las l�neas no ajustadas y las l�neas a cero de la factura
              PurchaseLine.RESET;
              PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
              PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
              PurchaseLine.SETFILTER("No.", '<>%1','');
              PurchaseLine.SETRANGE("QB Proform Adjusted", FALSE);
              PurchaseLine.DELETEALL;

              PurchaseLine.SETRANGE("QB Proform Adjusted");
              PurchaseLine.SETRANGE(Quantity, 0);
              PurchaseLine.DELETEALL;

              //Quito cabeceras de albar�n sin l�neas
              PurchaseLine.RESET;
              PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
              PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
              PurchaseLine.SETFILTER("No.",'=%1','');
              IF (PurchaseLine.FINDSET(TRUE)) THEN
                REPEAT
                  PurchaseLine2.RESET;
                  PurchaseLine2.SETRANGE("Document Type", PurchaseLine."Document Type");
                  PurchaseLine2.SETRANGE("Document No.", PurchaseLine."Document No.");
                  PurchaseLine2.SETFILTER("Line No.", '>%1', PurchaseLine."Line No.");
                  IF (NOT PurchaseLine2.FINDFIRST) OR (PurchaseLine2."No." = '') THEN
                    PurchaseLine.DELETE;
                UNTIL (PurchaseLine.NEXT = 0);


              //JAV 08/06/21: - QB 1.08.48 A�ado el nro de la proforma en el documento en las l�neas con el n� de albar�n
              PurchaseLine.RESET;
              PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
              PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
              PurchaseLine.SETFILTER("No.",'=%1','');
              IF (PurchaseLine.FINDSET(TRUE)) THEN
                REPEAT
                  txtAux := STRSUBSTNO(Text016, QBProformHeader."No.");
                  IF (STRLEN(txtAux) + STRLEN(PurchaseLine.Description) < MAXSTRLEN(PurchaseLine.Description)) THEN
                    PurchaseLine.Description := txtAux + ' ' + PurchaseLine.Description
                  ELSE BEGIN
                    PurchaseLine."Description 2" := PurchaseLine.Description;
                    PurchaseLine.Description := txtAux;
                  END;
                  PurchaseLine.MODIFY;
                UNTIL (PurchaseLine.NEXT = 0);

              -----------------------------------------------------------------------------------------------------------------------------------------}*/

        //Busco el grupo de iva de las l�neas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.SETFILTER("VAT Prod. Posting Group", '<>%1', '');
        IF (PurchaseLine.FINDFIRST) THEN
            GrVAT := PurchaseLine."VAT Prod. Posting Group";

        //----------------------------------------------------------------------------------------
        //A�adir las l�neas recurrentes
        //----------------------------------------------------------------------------------------
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF (PurchaseLine.FINDLAST) THEN
            LineNo := PurchaseLine."Line No."
        ELSE
            LineNo := 0;

        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", QBProformHeader."No.");
        QBProformLine.SETRANGE("QB Recurrent Line", TRUE);
        IF (QBProformLine.FINDSET(FALSE)) THEN
            REPEAT
                REPEAT
                    LineNo += 10000;
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Line No." := LineNo;
                    PurchaseLine.VALIDATE(Type, QBProformLine.Type);
                    PurchaseLine.VALIDATE("No.", QBProformLine."No.");
                    PurchaseLine.VALIDATE(Description, QBProformLine.Description);
                    PurchaseLine.VALIDATE(Quantity, QBProformLine.Quantity);
                    PurchaseLine.VALIDATE("Direct Unit Cost", QBProformLine."Direct Unit Cost");
                    IF (GrVAT <> '') THEN
                        PurchaseLine.VALIDATE("VAT Prod. Posting Group", GrVAT);
                    PurchaseLine.INSERT;
                UNTIL (PurchaseLine.NEXT = 0);
            UNTIL (QBProformLine.NEXT = 0);

        //----------------------------------------------------------------------------------------
        // Finalizar los procesos
        //----------------------------------------------------------------------------------------

        //JAV 24/09/21: - QB 1.09.19 Recalcular las retenciones
        WithholdingTreating.CalculateWithholding_PurchaseHeader(PurchaseHeader);
        PurchaseHeader.MODIFY(TRUE);

        //Presentar la factura creada
        CLEAR(PurchaseInvoice);
        PurchaseInvoice.SETRECORD(PurchaseHeader);
        PurchaseInvoice.RUN;
    END;

    PROCEDURE ClearInvoice(VAR QBProformHeader: Record 7206960);
    VAR
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
    BEGIN
        //--------------------------------------------------------------------------------------------------------------------------------
        // JAV 24/05/21: - QB 1.08.44 Desasociar de la proforma la factura de compra sin registrar, sin eliminar la factura
        //--------------------------------------------------------------------------------------------------------------------------------
        IF (QBProformHeader."Invoice No." = '') THEN
            ERROR(Text017);

        IF (PurchInvHeader.GET(QBProformHeader."Invoice No.")) THEN
            ERROR(Text018);

        //Quito la marca de la proforma de la factura
        IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, QBProformHeader."Invoice No.") THEN BEGIN
            PurchaseHeader."QB From Proform" := '';
            PurchaseHeader.MODIFY;
        END;

        //Quito el nro de factura de la proforma
        QBProformHeader."Invoice No." := '';
        QBProformHeader.MODIFY;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------- Eventos Page 50047 y 50054, solo para ARPADA"();
    BEGIN
    END;

    // [EventSubscriber(ObjectType::Page, 50047, OnAfterActionEvent, Proform, true, true)]
    LOCAL PROCEDURE P50047_OnAfterActionEvent_Proform(VAR Rec: Record 38);
    BEGIN
        //Acci�n para generar la proforma
        Btn_Proform(Rec);
    END;

    // [EventSubscriber(ObjectType::Page, 50047, OnAfterActionEvent, QB_SeeProform, true, true)]
    LOCAL PROCEDURE P50047_OnAfterActionEvent_QB_SeeProform(VAR Rec: Record 38);
    BEGIN
        //JAV 20/04/21: - QB 1.08.41 Ver las proformas de un pedido de compra
        Btn_SeeProform(Rec);
    END;

    // [EventSubscriber(ObjectType::Page, 50054, OnAfterActionEvent, Proform, true, true)]
    LOCAL PROCEDURE P50054_OnAfterActionEvent_Proform(VAR Rec: Record 38);
    BEGIN
        //Acci�n para generar la proforma
        Btn_Proform(Rec);
    END;

    // [EventSubscriber(ObjectType::Page, 50054, OnAfterActionEvent, QB_SeeProform, true, true)]
    LOCAL PROCEDURE P50054_OnAfterActionEvent_QB_SeeProform(VAR Rec: Record 38);
    BEGIN
        //JAV 20/04/21: - QB 1.08.41 Ver las proformas de un pedido de compra
        Btn_SeeProform(Rec);
    END;

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
      JAV 24/09/21: - QB 1.09.19 No incluir las l�neas de correcci�n al traer los albaranes a la factura y recalcular las retenciones al final
      JAV 15/12/21: - QB 1.10.07 Si tiene almac�n se lo quito
      JAV 11/07/22: - QB 1.11.00 Se fuerza que las l�neas de los albaranes no est�n canceladas
      AML 03/07/23: - Q19675 BS18286 CSM 30/03/2023. � Mediciones al cancelar albar�n.
            Modify functions: CU90_OnAfterPostPurchaseDoc, Proform
            New global vble: PurchReceiptHeadNo_Vg
    }
END.*/
}








Codeunit 7206918 "QB Framework Contracts Mgt."
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        QuoBuildingSetup: Record 7207278;
        Text001: TextConst ESP = 'Ha cambiado el precio y existe un contrato marco asociado, si continua se eliminar� este. �Confirma cambiar el precio?';
        Text002: TextConst ESP = 'El albar�n proviene de un Contrato Marco, no puede cambiar el precio';
        Text003: TextConst ESP = 'El albar�n proviene de un Contrato Marco, no puede cambiar la cantidad';

    LOCAL PROCEDURE UseFrameworkContract(): Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // Q12867 - Si se emplean o no los contratos marco en la empresa actual
        //------------------------------------------------------------------------------------------------------------------
        QuoBuildingSetup.GET;
        EXIT(QuoBuildingSetup."Blanket Purchase Multy-company")
        //Q12867 +
    END;

    LOCAL PROCEDURE FindFrameworkContrat_Line(VAR QBFrameworkContrHeader: Record 7206937; VAR QBFrameworkContrLine: Record 7206938; pVendor: Code[20]; pDate: Date; pType: Option; pNo: Code[20]): Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Buscar un contrato marco utilizable para un producto o recurso. Retorna si lo ha encontrado
        //------------------------------------------------------------------------------------------------------------------
        EXIT(FindFrameworkContrat(QBFrameworkContrHeader, QBFrameworkContrLine, pVendor, pDate, FALSE, pType, pNo));
    END;

    LOCAL PROCEDURE FindFrameworkContrat_Header(VAR QBFrameworkContrHeader: Record 7206937; pVendor: Code[20]; pDate: Date): Boolean;
    VAR
        QBFrameworkContrLine: Record 7206938;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Buscar un contrato marco gen�rico. Retorna si lo ha encontrado
        //------------------------------------------------------------------------------------------------------------------
        EXIT(FindFrameworkContrat(QBFrameworkContrHeader, QBFrameworkContrLine, pVendor, pDate, TRUE, 0, ''));
    END;

    LOCAL PROCEDURE FindFrameworkContrat(VAR QBFrameworkContrHeader: Record 7206937; VAR ret_QBFrameworkContrLine: Record 7206938; pVendor: Code[20]; pDate: Date; pGeneric: Boolean; pType: Option; pNo: Code[20]): Boolean;
    VAR
        QBFrameworkContrLine: Record 7206938;
        tmpQBFrameworkContrLine: Record 7206938 TEMPORARY;
        QBFrameworkContrCompany: Record 7206939;
        QBFrameworkContrUse: Record 7206956;
        QtyFound: Boolean;
        ErrQuantity: TextConst ENU = 'The quantity entered is greater than that available in the blanket Order', ESP = 'La cantidad introducida es mayor que la disponible en el contrato marco';
        Valid: Boolean;
        FoundGeneric: Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Buscar un contrato marco utilizable gen�rico o espec�fico. Retorna si lo ha encontrado
        //------------------------------------------------------------------------------------------------------------------

        //Elimino los registros de la tabla temporal
        tmpQBFrameworkContrLine.RESET;
        tmpQBFrameworkContrLine.DELETEALL;

        FoundGeneric := FALSE;

        IF (pGeneric) OR (pType IN [QBFrameworkContrLine.Type::Item, QBFrameworkContrLine.Type::Resource]) THEN BEGIN
            //Busco un contrato activo, aprobado y v�lido en esa fecha, y si me pasan proveedor que sea de ese expresamente
            QBFrameworkContrHeader.RESET;
            IF (pVendor <> '') THEN
                QBFrameworkContrHeader.SETRANGE("Vendor No.", pVendor);
            QBFrameworkContrHeader.SETFILTER("Init Date", '<=%1', pDate);
            QBFrameworkContrHeader.SETFILTER("End Date", '>=%1', pDate);
            //QBFrameworkContrHeader.SETRANGE("OLD_Approval Situation",QBFrameworkContrHeader."OLD_Approval Situation"::Approved);  //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
            QBFrameworkContrHeader.SETRANGE(Status, QBFrameworkContrHeader.Status::Operative);  //JAV 10/08/22: - QB 1.11.01 Se cambia el campo y el estado
                                                                                                //JAV 16/07/21 Si busco uno gen�rico
            IF (pGeneric) THEN
                QBFrameworkContrHeader.SETRANGE(Generic, TRUE);
            IF QBFrameworkContrHeader.FINDSET THEN
                REPEAT
                    //JAV 16/07/21 Cambio el orden por el uso de gen�ricos, primero miro que lo pueda usar en esta empresa
                    Valid := TRUE;
                    IF (QBFrameworkContrHeader."Use In" = QBFrameworkContrHeader."Use In"::Some) THEN BEGIN
                        QBFrameworkContrCompany.SETRANGE("Document No.", QBFrameworkContrHeader."No.");
                        QBFrameworkContrCompany.SETRANGE("Company Name", UPPERCASE(COMPANYNAME));
                        Valid := (QBFrameworkContrCompany.FINDFIRST);
                    END;

                    //Si no busco uno gen�rico, debo localizar el producto o recurso entre las l�neas
                    IF (Valid) AND (NOT pGeneric) THEN BEGIN
                        Valid := FALSE;
                        IF (pNo <> '') THEN BEGIN
                            QBFrameworkContrLine.RESET;
                            QBFrameworkContrLine.SETRANGE("Document No.", QBFrameworkContrHeader."No.");
                            QBFrameworkContrLine.SETRANGE(Type, pType);
                            QBFrameworkContrLine.SETRANGE("No.", pNo);
                            IF QBFrameworkContrLine.FINDFIRST THEN
                                //Debe ser abierto o disponer de cantidad pendiente para poder usarlo
                                Valid := (QBFrameworkContrLine."Quantity Max" = 0) OR (QBFrameworkContrLine.QuantityPending > 0);
                        END;
                    END;

                    //Si he encontrado algo v�lido, me guardo la l�nea y sigo buscando
                    IF (Valid) THEN BEGIN
                        FoundGeneric := TRUE;

                        tmpQBFrameworkContrLine := QBFrameworkContrLine;
                        tmpQBFrameworkContrLine.INSERT;
                    END;
                UNTIL (QBFrameworkContrHeader.NEXT = 0) OR (QtyFound);
        END;

        tmpQBFrameworkContrLine.RESET;
        CASE tmpQBFrameworkContrLine.COUNT OF
            0:
                EXIT(FoundGeneric);
            1:
                BEGIN
                    tmpQBFrameworkContrLine.FINDFIRST;
                    ret_QBFrameworkContrLine := tmpQBFrameworkContrLine;
                    EXIT(TRUE);
                END;
            ELSE BEGIN
                //TO-DO sacar una lista y que seleccionen cual desean utilizar, ahora saca el primero
                tmpQBFrameworkContrLine.FINDFIRST;
                ret_QBFrameworkContrLine := tmpQBFrameworkContrLine;
                EXIT(TRUE);
            END;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Manejo en Descompuestos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207387, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE T7207387_OnAfterValidate_No(VAR Rec: Record 7207387; VAR xRec: Record 7207387; CurrFieldNo: Integer);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        optType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Al validar el c�digo del producto o recurso ver si hay un contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        IF NOT (Rec."Cost Type" IN [Rec."Cost Type"::Item, Rec."Cost Type"::Resource]) THEN
            EXIT;

        CASE Rec."Cost Type" OF
            Rec."Cost Type"::Item:
                optType := QBFrameworkContrLine.Type::Item;
            Rec."Cost Type"::Resource:
                optType := QBFrameworkContrLine.Type::Resource;
            ELSE
                optType := QBFrameworkContrLine.Type::" ";
        END;

        IF FindFrameworkContrat_Line(QBFrameworkContrHeader, QBFrameworkContrLine, '', TODAY, optType, Rec."No.") THEN BEGIN
            IF CONFIRM(QBFrameworkContrLine.MsgSelect(0), TRUE) THEN BEGIN
                Rec."QB Framework Contr. No." := ''; //Para que el validate del precio no actue
                Rec.VALIDATE("Direc Unit Cost", QBFrameworkContrLine."Direct Unit Cost");
                Rec.VALIDATE(Vendor, QBFrameworkContrLine."Vendor No.");
                Rec."QB Framework Contr. No." := QBFrameworkContrLine."Document No.";
                Rec."QB Framework Contr. Line" := QBFrameworkContrLine."Line No.";

                IF NOT Rec.INSERT(TRUE) THEN;    //Por si todav�a no existe la l�nea
                UpdateQBBlanketPurchUseEntryFromJob(Rec, FALSE);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7207387, OnAfterValidateEvent, "Performance By Piecework", true, true)]
    LOCAL PROCEDURE T7207387_OnAfterValidate_Qty(VAR Rec: Record 7207387; VAR xRec: Record 7207387; CurrFieldNo: Integer);
    VAR
        QBFrameworkContrLine: Record 7206938;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Si cambia la cantidad y hay un contrato marco se actualiza la cantidad
        //------------------------------------------------------------------------------------------------------------------
        IF (QBFrameworkContrLine.GET(Rec."QB Framework Contr. No.", Rec."QB Framework Contr. Line")) THEN BEGIN
            UpdateQBBlanketPurchUseEntryFromJob(Rec, FALSE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7207387, OnAfterValidateEvent, "Direc Unit Cost", true, true)]
    LOCAL PROCEDURE T7207387_OnAfterValidate_DirectUnitCost(VAR Rec: Record 7207387; VAR xRec: Record 7207387; CurrFieldNo: Integer);
    VAR
        QBBlanketPurchLine: Record 7206938;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Si cambia el precio y hay un contrato marco, preguntar si se elimina
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Framework Contr. No." <> '') AND (Rec."Direc Unit Cost" <> xRec."Direc Unit Cost") THEN BEGIN
            IF CONFIRM(Text001, FALSE) THEN BEGIN
                UpdateQBBlanketPurchUseEntryFromJob(Rec, TRUE);
                Rec."QB Framework Contr. No." := ''
            END ELSE
                ERROR('');
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Manejo en Comparativos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207412, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T7207415_OnAfterModify(VAR Rec: Record 7207412; VAR xRec: Record 7207412; RunTrigger: Boolean);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        DataPricesVendor: Record 7207415;
        optType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 02/06/22: - QB 1.10.48 Al modificar un comparativo si cambia el estado ajustar datos
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        DataPricesVendor.RESET;
        DataPricesVendor.SETRANGE("Quote Code", Rec."No.");
        IF (DataPricesVendor.FINDSET(FALSE)) THEN
            REPEAT
                ComparativeLine_Update(DataPricesVendor, FALSE, FALSE);
            UNTIL DataPricesVendor.NEXT = 0;
    END;

    [EventSubscriber(ObjectType::Table, 7207415, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T7207415_OnAfterInsert(VAR Rec: Record 7207415; RunTrigger: Boolean);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        optType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Al crea una l�nea, mirar si hay un contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        ComparativeLine_Update(Rec, TRUE, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 7207415, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T7207415_OnAfterDelete(VAR Rec: Record 7207415; RunTrigger: Boolean);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        optType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 02/06/22: - QB 1.10.48 Al eliminar una l�nea quitarla del uso del contrato marco, tiene en cuenta las versiones
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        ComparativeLine_Update(Rec, FALSE, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 7207415, OnAfterValidateEvent, "Vendor Price", true, true)]
    LOCAL PROCEDURE T7207415_OnAfterValidate_Qty(VAR Rec: Record 7207415; VAR xRec: Record 7207415; CurrFieldNo: Integer);
    VAR
        QBFrameworkContrLine: Record 7206938;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Si cambia la cantidad y hay un contrato marco se actualiza la cantidad
        //------------------------------------------------------------------------------------------------------------------
        IF (QBFrameworkContrLine.GET(Rec."QB Framework Contr. No.", Rec."QB Framework Contr. Line")) THEN BEGIN
            UpdateQBBlanketPurchUseEntryFromComparative(Rec, FALSE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 7207415, OnAfterValidateEvent, "Vendor Price", true, true)]
    LOCAL PROCEDURE T7207415_OnAfterValidate_VendorPrice(VAR Rec: Record 7207415; VAR xRec: Record 7207415; CurrFieldNo: Integer);
    VAR
        QBBlanketPurchLine: Record 7206938;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Si cambia el precio y hay un contrato marco, preguntar si se elimina
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec."QB Framework Contr. No." <> '') AND (Rec."Vendor Price" <> xRec."Vendor Price") THEN
            IF CONFIRM(Text001, FALSE) THEN BEGIN
                UpdateQBBlanketPurchUseEntryFromComparative(Rec, TRUE);
                Rec."QB Framework Contr. No." := ''
            END ELSE
                ERROR('');
    END;

    LOCAL PROCEDURE ComparativeLine_Update(Rec: Record 7207415; pMessage: Boolean; pDelete: Boolean);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        QBUsedBlanketPurchLine: Record 7206956;
        optType: Option;
        Ok: Boolean;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Al crea o modificar una l�nea de condiciones del comparativo, mirar si hay un contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        IF NOT (Rec.Type IN [Rec.Type::Item, Rec.Type::Resource]) THEN
            EXIT;

        CASE Rec.Type OF
            Rec.Type::Item:
                optType := QBFrameworkContrLine.Type::Item;
            Rec.Type::Resource:
                optType := QBFrameworkContrLine.Type::Resource;
            ELSE
                optType := QBFrameworkContrLine.Type::" ";
        END;

        IF FindFrameworkContrat_Line(QBFrameworkContrHeader, QBFrameworkContrLine, Rec."Vendor No.", TODAY, optType, Rec."No.") THEN BEGIN
            IF (NOT pMessage) THEN
                Ok := TRUE
            ELSE BEGIN
                //Buscar la cantidad en otros comparativos
                QBUsedBlanketPurchLine.RESET;
                QBUsedBlanketPurchLine.SETRANGE("Document Type", QBUsedBlanketPurchLine."Document Type"::Comparative);
                QBUsedBlanketPurchLine.SETFILTER("Document No.", '<>%1', Rec."Quote Code");
                QBUsedBlanketPurchLine.CALCSUMS(Quantity);
                Ok := CONFIRM(QBFrameworkContrLine.MsgSelect(QBUsedBlanketPurchLine.Quantity), TRUE);
            END;

            IF (Ok) THEN BEGIN
                IF (NOT pDelete) THEN BEGIN
                    Rec."QB Framework Contr. No." := ''; //Para que el validate del precio no actue
                    Rec.VALIDATE("Vendor Price", QBFrameworkContrLine."Direct Unit Cost");
                    Rec."QB Framework Contr. No." := QBFrameworkContrLine."Document No.";
                    Rec."QB Framework Contr. Line" := QBFrameworkContrLine."Line No.";
                    Rec.MODIFY;
                END;
                UpdateQBBlanketPurchUseEntryFromComparative(Rec, pDelete);
            END;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Manejo en documentos de compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE PurchHeader_OnAfterValidateEvent_Vendor(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        QBFrameworkContrHeader: Record 7206937;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 16/07/21: - QB 1.09.05 Al indicar el c�digo del proveedor, buscar un contrato marco gen�rico y aplicarlo existe
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        //JAV 20/07/21: - QB 1.09.10 No buscar contratos marco gen�ricos para facturas que se generan desde una proforma
        IF (Rec."QB From Proform" <> '') THEN
            EXIT;

        IF FindFrameworkContrat_Header(QBFrameworkContrHeader, Rec."Buy-from Vendor No.", Rec."Posting Date") THEN
            IF (CONFIRM('Existe un contrato marco gen�rico para ese proveedor, �desea usarlo?', TRUE)) THEN
                PurchHeader_SetConditions(Rec, QBFrameworkContrHeader, FALSE);
    END;

    LOCAL PROCEDURE PurchHeader_SetConditions(VAR PurchaseHeader: Record 38; QBFrameworkContrHeader: Record 7206937; pMod: Boolean);
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 16/07/21: - QB 1.09.05 Establece en el documento las condiciones del contrato marco
        //------------------------------------------------------------------------------------------------------------------

        PurchaseHeader.VALIDATE("Payment Terms Code", QBFrameworkContrHeader."Payment Terms Code");
        PurchaseHeader.VALIDATE("Payment Method Code", QBFrameworkContrHeader."Payment Method Code");
        IF (pMod) THEN
            PurchaseHeader.MODIFY;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInsertEvent, '', true, true)]
    PROCEDURE PurchLine_OnAfterInsertEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        ConfBlnktOrder: TextConst ENU = 'There is a Blanket Order with the %1 %2 with a %3 of %4. Would you like to bring the information?', ESP = 'Hay un contrato marco a precio de %1 con una cantidad disponible de %2, �Desea utilizarlo?';
        PurchaseHeader: Record 38;
        opcType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 02/06/22: - QB 1.10.47 Al insertar una l�nea verificar si hay que generar la de uso en contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        UpdateQBBlanketPurchUseEntryFromPurchase(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterModifyEvent, '', true, true)]
    PROCEDURE PurchLine_OnAfterModifytEvent(VAR Rec: Record 39; VAR xRec: Record 39; RunTrigger: Boolean);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        ConfBlnktOrder: TextConst ENU = 'There is a Blanket Order with the %1 %2 with a %3 of %4. Would you like to bring the information?', ESP = 'Hay un contrato marco a precio de %1 con una cantidad disponible de %2, �Desea utilizarlo?';
        PurchaseHeader: Record 38;
        opcType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 02/06/22: - QB 1.10.47 Al insertar una l�nea verificar si hay que generar la de uso en contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        UpdateQBBlanketPurchUseEntryFromPurchase(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterDeleteEvent, '', true, true)]
    PROCEDURE PurchLine_OnAfterDeleteEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        QBUsedBlanketPurchLineQty: Record 7206956;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 - Proceso si se elimina una l�nea asociada a un contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) OR (Rec."QB Framework Contr. No." = '') THEN
            EXIT;

        UpdateQBBlanketPurchUseEntryFromPurchase(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "No.", true, true)]
    PROCEDURE PurchLine_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        QBFrameworkContrHeader: Record 7206937;
        QBFrameworkContrLine: Record 7206938;
        ConfBlnktOrder: TextConst ENU = 'There is a Blanket Order with the %1 %2 with a %3 of %4. Would you like to bring the information?', ESP = 'Hay un contrato marco a precio de %1 con una cantidad disponible de %2, �Desea utilizarlo?';
        PurchaseHeader: Record 38;
        opcType: Option;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Al indicar el c�digo del producto o recurso, buscar un contrato marco y aplicarlo si es necesario
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        IF (Rec."QB tmp From Comparative") OR                                                           //Si la estoy creando desde un comparativo
           NOT (Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice]) OR   //O Si no es un pedido o una factura de compra
           NOT (Rec.Type IN [Rec.Type::Item, Rec.Type::Resource]) THEN                                  //O Si no es producto o recurso
            EXIT;

        IF (Rec."No." = xRec."No.") AND (Rec."QB Framework Contr. No." <> '') THEN                      //Si no cambia el producto y ya est� en un contrato marco, no hay que hacer nada
            EXIT;

        CASE Rec.Type OF
            Rec.Type::Item:
                opcType := QBFrameworkContrLine.Type::Item;
            Rec.Type::Resource:
                opcType := QBFrameworkContrLine.Type::Resource;
            ELSE
                opcType := QBFrameworkContrLine.Type::" ";
        END;

        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        IF FindFrameworkContrat_Line(QBFrameworkContrHeader, QBFrameworkContrLine, PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."Posting Date", opcType, Rec."No.") THEN BEGIN
            IF CONFIRM(QBFrameworkContrLine.MsgSelect(0), TRUE) THEN BEGIN
                Rec.VALIDATE("Direct Unit Cost", QBFrameworkContrLine."Direct Unit Cost");
                Rec.VALIDATE("QB Framework Contr. No.", QBFrameworkContrLine."Document No.");
                Rec.VALIDATE("QB Framework Contr. Line", QBFrameworkContrLine."Line No.");
                IF (Rec.Quantity <> 0) THEN
                    Rec.VALIDATE(Quantity);
                //JAV 16/07/21: - Poner las condiciones del contrato marco en la cabecera
                PurchHeader_SetConditions(PurchaseHeader, QBFrameworkContrHeader, TRUE);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, Quantity, true, true)]
    PROCEDURE PurchLine_OnAfterValidateEvent_Quantity(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        QBFrameworkContrLine: Record 7206938;
        Text001: TextConst ESP = 'No puede usar mas cantidad de la disponible en el contrato marco: %1';
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Proceso para validar la cantidad de la l�nea si est� asociada a un contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        IF (Rec."QB tmp From Comparative") OR                                                         //Si la estoy creando desde un comparativo
           (Rec.Quantity = xRec.Quantity) THEN                                                        //Si no han canbiado la cantidad
            EXIT;

        //TO-DO Esto hay que mejorarlo, si viene de un albar�n debemos cambiar la cantidad en albaranes facturados
        IF (Rec."QB Framework Contr. No." <> '') AND (Rec."Receipt No." <> '') THEN                     //Si tiene contrato marco y viene de un albar�n no dejo tocar la cantidad
            ERROR(Text003);

        IF (QBFrameworkContrLine.GET(Rec."QB Framework Contr. No.", Rec."QB Framework Contr. Line")) THEN BEGIN
            IF (QBFrameworkContrLine."Quantity Max" <> 0) AND (Rec.Quantity > QBFrameworkContrLine.QuantityPending + xRec.Quantity) THEN
                ERROR(Text001, QBFrameworkContrLine.QuantityPending);

            IF NOT Rec.INSERT(TRUE) THEN;    //Por si todav�a no existe la l�nea
            UpdateQBBlanketPurchUseEntryFromPurchase(Rec, FALSE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Direct Unit Cost", true, true)]
    LOCAL PROCEDURE PurchLine_OnAfterValidateEvent_DirectUnitCost(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        DirectUnitCostErr: TextConst ENU = 'The current %1 of %2 cannot be changed, as the line is related with the %3 %4', ESP = 'Si cambia el precio se dejar� de usar el contrato marco, �desea continuar?';
        QBFrameworkContrLine: Record 7206938;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Proceso para validar el precio de la l�nea si est� asociada a un contrato marco
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) OR (Rec."QB Framework Contr. No." = '') THEN
            EXIT;

        IF (Rec."QB tmp From Comparative") OR                       //Si la estoy creando desde un comparativo
           (Rec."QB Framework Contr. No." = '') OR                  //Si no tiene contrato marco
           (Rec."Direct Unit Cost" = xRec."Direct Unit Cost") THEN  //Si no cambia el precio
            EXIT;

        IF (Rec."QB Framework Contr. No." <> '') AND (Rec."Receipt No." <> '') THEN  //Si tiene contrato marco y viene de un albar�n no se puede cambiar el precio
            ERROR(Text002);

        IF (QBFrameworkContrLine.GET(Rec."QB Framework Contr. No.", Rec."QB Framework Contr. Line")) THEN
            IF (Rec."Direct Unit Cost" <> QBFrameworkContrLine."Direct Unit Cost") THEN
                IF (NOT CONFIRM(DirectUnitCostErr, FALSE)) THEN
                    ERROR('')
                ELSE BEGIN
                    UpdateQBBlanketPurchUseEntryFromPurchase(Rec, TRUE);
                    Rec."QB Framework Contr. No." := '';
                    Rec."QB Framework Contr. Line" := 0;
                END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnValidateNoOnCopyFromTempPurchLine, '', true, true)]
    LOCAL PROCEDURE PurchLine_OnValidateNoOnCopyFromTempPurchLine(VAR PurchLine: Record 39; TempPurchaseLine: Record 39 TEMPORARY);
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 - Al validar el campo No se deben restaurar ciertos valores de la l�nea
        //------------------------------------------------------------------------------------------------------------------
        PurchLine."QB tmp From Comparative" := TempPurchaseLine."QB tmp From Comparative";
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Manejo del albar n de compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 121, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T121_OnAfterInsert(VAR Rec: Record 121; RunTrigger: Boolean);
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 11/03/21: - QB 1.08.23 Al crear el albar�n a�adir la l�nea en la tabla de usos
        //------------------------------------------------------------------------------------------------------------------
        IF (Rec.ISTEMPORARY) OR (NOT UseFrameworkContract) THEN
            EXIT;

        IF (Rec."QB Framework Contr. No." <> '') THEN
            UpdateQBBlanketPurchUseEntryFromShipment(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnBeforeTransferLineToPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU74_1(VAR PurchRcptHeader: Record 120; VAR PurchRcptLine: Record 121; VAR PurchaseHeader: Record 38; VAR TransferLine: Boolean);
    VAR
        PurchOrderLine: Record 39;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 11/03/21: - QB 1.08.23 Antes de facturar el albar�n marcar la l�nea del pedido como que no se controle el contrato marco
        //------------------------------------------------------------------------------------------------------------------
        PurchOrderLine.RESET;
        PurchOrderLine.SETRANGE("Document Type", PurchOrderLine."Document Type"::Order);
        PurchOrderLine.SETRANGE("Document No.", PurchRcptHeader."Order No.");
        PurchOrderLine.MODIFYALL("QB tmp From Comparative", TRUE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnAfterInsertLines, '', true, true)]
    LOCAL PROCEDURE CU74_2(VAR PurchHeader: Record 38);
    VAR
        PurchaseLine: Record 39;
        PurchOrderLine: Record 39;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 11/03/21: - QB 1.08.23 Despu�s de facturar el albar�n quitar de las l�neas de la factura y de las l�neas del pedido la marca de que no se controle el contrato marco
        //------------------------------------------------------------------------------------------------------------------
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
        IF (PurchaseLine.FINDSET(TRUE)) THEN
            REPEAT
                PurchaseLine."QB tmp From Comparative" := FALSE;
                PurchaseLine.MODIFY;

                PurchOrderLine.RESET;
                PurchOrderLine.SETRANGE("Document Type", PurchOrderLine."Document Type"::Order);
                PurchOrderLine.SETRANGE("Document No.", PurchaseLine."Order No.");
                PurchOrderLine.SETRANGE("QB tmp From Comparative", TRUE);
                PurchOrderLine.MODIFYALL("QB tmp From Comparative", FALSE);

            UNTIL (PurchaseLine.NEXT = 0);
    END;

    LOCAL PROCEDURE "--------------------------------------------------- Manejo de la tabla de entradas"();
    BEGIN
    END;

    LOCAL PROCEDURE UpdateQBBlanketPurchUseEntryFromJob(DataCostByPiecework: Record 7207387; pDelete: Boolean);
    VAR
        QBUsedBlanketPurchLine: Record 7206956;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Funci�n que actualiza la l�nea de uso relacionada con un descompuesto de un proyecto
        //------------------------------------------------------------------------------------------------------------------
        CreateQBBlanketPurchUseEntry(DataCostByPiecework."QB Framework Contr. No.", DataCostByPiecework."QB Framework Contr. Line",
                                     QBUsedBlanketPurchLine."Document Type"::Job, DataCostByPiecework."Piecework Code", 0,
                                     DataCostByPiecework.Vendor, DataCostByPiecework."Job No.",
                                     DataCostByPiecework."Cost Type", DataCostByPiecework."No.", DataCostByPiecework.Quantity, DataCostByPiecework."Direc Unit Cost",
                                     pDelete);
    END;

    LOCAL PROCEDURE UpdateQBBlanketPurchUseEntryFromComparative(DataPricesVendor: Record 7207415; pDelete: Boolean);
    VAR
        ComparativeQuoteHeader: Record 7207412;
        QBUsedBlanketPurchLine: Record 7206956;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Funci�n que actualiza la l�nea de uso relacionada con el comparativo de ofertas
        //------------------------------------------------------------------------------------------------------------------
        ComparativeQuoteHeader.GET(DataPricesVendor."Quote Code");
        IF (ComparativeQuoteHeader."Comparative Status" IN [ComparativeQuoteHeader."Comparative Status"::Approved, ComparativeQuoteHeader."Comparative Status"::Generated]) THEN
            pDelete := TRUE;

        CreateQBBlanketPurchUseEntry(DataPricesVendor."QB Framework Contr. No.", DataPricesVendor."QB Framework Contr. Line",
                                     QBUsedBlanketPurchLine."Document Type"::Comparative, DataPricesVendor."Quote Code", DataPricesVendor."Line No.",
                                     DataPricesVendor."Vendor No.", DataPricesVendor."Job No.",
                                     DataPricesVendor.Type, DataPricesVendor."No.", DataPricesVendor.Quantity, DataPricesVendor."Vendor Price",
                                     pDelete);
    END;

    LOCAL PROCEDURE UpdateQBBlanketPurchUseEntryFromPurchase(PurchLine: Record 39; pDelete: Boolean);
    VAR
        QBUsedBlanketPurchLine: Record 7206956;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Funci�n que actualiza la l�nea de uso relacionada con el documento de compra
        //------------------------------------------------------------------------------------------------------------------
        CASE PurchLine."Document Type" OF
            PurchLine."Document Type"::Order:
                CreateQBBlanketPurchUseEntry(PurchLine."QB Framework Contr. No.", PurchLine."QB Framework Contr. Line",
                                             QBUsedBlanketPurchLine."Document Type"::Order, PurchLine."Document No.", PurchLine."Line No.",
                                             PurchLine."Buy-from Vendor No.", PurchLine."Job No.",
                                             PurchLine.Type, PurchLine."No.", PurchLine.Quantity, PurchLine."Direct Unit Cost",
                                             pDelete);

            PurchLine."Document Type"::Invoice:
                CreateQBBlanketPurchUseEntry(PurchLine."QB Framework Contr. No.", PurchLine."QB Framework Contr. Line",
                                             QBUsedBlanketPurchLine."Document Type"::Invoice, PurchLine."Document No.", PurchLine."Line No.",
                                             PurchLine."Buy-from Vendor No.", PurchLine."Job No.",
                                             PurchLine.Type, PurchLine."No.", PurchLine.Quantity, PurchLine."Direct Unit Cost",
                                             pDelete);
        END;
    END;

    LOCAL PROCEDURE UpdateQBBlanketPurchUseEntryFromShipment(PurchRcptLine: Record 121; pDelete: Boolean);
    VAR
        QBUsedBlanketPurchLine: Record 7206956;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Funci�n que actualiza la l�nea de uso relacionada con el albar�n de compra
        //------------------------------------------------------------------------------------------------------------------
        CreateQBBlanketPurchUseEntry(PurchRcptLine."QB Framework Contr. No.", PurchRcptLine."QB Framework Contr. Line",
                                     QBUsedBlanketPurchLine."Document Type"::Shipment, PurchRcptLine."Document No.", PurchRcptLine."Line No.",
                                     PurchRcptLine."Buy-from Vendor No.", PurchRcptLine."Job No.",
                                     PurchRcptLine.Type, PurchRcptLine."No.", PurchRcptLine.Quantity, PurchRcptLine."Direct Unit Cost",
                                     pDelete);
    END;

    LOCAL PROCEDURE CreateQBBlanketPurchUseEntry(pContractNo: Code[20]; pContractLine: Integer; pDocumentType: Option; pDocumentNo: Code[20]; pDocumentLine: Integer; pVendor: Code[20]; pJob: Code[20]; pType: Enum "Purchase Line Type"; pNo: Code[20]; pQty: Decimal; pPrice: Decimal; pDelete: Boolean);
    VAR
        QBUsedBlanketPurchLine: Record 7206956;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------------
        // JAV 10/03/21: - QB 1.08.23 Funci�n que actualiza una l�nea de uso
        //------------------------------------------------------------------------------------------------------------------
        QBUsedBlanketPurchLine.SETRANGE("Framework Contr. No.", pContractNo);
        QBUsedBlanketPurchLine.SETRANGE("Framework Contr. Line", pContractLine);
        QBUsedBlanketPurchLine.SETRANGE(Company, UPPERCASE(COMPANYNAME));
        QBUsedBlanketPurchLine.SETRANGE("Document Type", pDocumentType);
        QBUsedBlanketPurchLine.SETRANGE("Document No.", pDocumentNo);
        QBUsedBlanketPurchLine.SETRANGE("Line No.", pDocumentLine);
        IF QBUsedBlanketPurchLine.FINDFIRST THEN BEGIN
            IF (pDelete) OR (pQty = 0) THEN BEGIN
                QBUsedBlanketPurchLine.DELETE;
            END ELSE BEGIN
                QBUsedBlanketPurchLine.Quantity := pQty;
                QBUsedBlanketPurchLine.MODIFY;
            END;
        END ELSE IF (NOT pDelete) AND (pQty <> 0) THEN BEGIN
            QBUsedBlanketPurchLine.RESET;
            IF QBUsedBlanketPurchLine.FINDLAST THEN
                LineNo := QBUsedBlanketPurchLine."Entry No." + 1
            ELSE
                LineNo := 1;

            QBUsedBlanketPurchLine.INIT;
            QBUsedBlanketPurchLine."Entry No." := LineNo;
            QBUsedBlanketPurchLine."Entry Date" := TODAY;
            QBUsedBlanketPurchLine."Framework Contr. No." := pContractNo;
            QBUsedBlanketPurchLine."Framework Contr. Line" := pContractLine;
            QBUsedBlanketPurchLine.Company := UPPERCASE(COMPANYNAME);
            QBUsedBlanketPurchLine."Document Type" := pDocumentType;
            QBUsedBlanketPurchLine."Document No." := pDocumentNo;
            QBUsedBlanketPurchLine."Line No." := pDocumentLine;
            QBUsedBlanketPurchLine."Vendor No." := pVendor;
            QBUsedBlanketPurchLine."Job No." := pJob;
            QBUsedBlanketPurchLine.Type := pType;
            QBUsedBlanketPurchLine."No." := pNo;
            QBUsedBlanketPurchLine."Unit Price" := pPrice;
            QBUsedBlanketPurchLine.Quantity := pQty;
            QBUsedBlanketPurchLine.INSERT(TRUE);
        END;
    END;


   
    /*BEGIN
    /*{
          JDC 25/02/21: - Q12867 Added function "UseFrameworkContract", "PurchLine_OnAfterValidateEvent_No", "PurchLine_OnAfterValidateEvent_Quantity", "PurchLine_OnAfterValidateEvent_DirectUnitCost",
                                                "PurchLine_OnAfterDeleteEvent", "PurchPost_OnAfterPostPurchLine", "FindBlanketPurchOrder",
                                                "CreateQBBlanketPurchUseEntry", "UpdateQBBlanketPurchUseEntry", "DeleteQBBlanketPurchUseEntry"
          JAV 10/03/21: - QB 1.08.23 Se rehace el m�dulo casi por completo
          JAV 20/07/21: - QB 1.09.10 No buscar contratos marco gen�ricos para facturas que se generan desde una proforma
          JAV 10/08/22: - QB 1.11.01 Se cambia el campo estado y el propio estado. Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
        }
    END.*/
}










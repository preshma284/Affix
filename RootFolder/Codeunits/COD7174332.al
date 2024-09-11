Codeunit 7174332 "SII Procesing"
{


    Permissions = TableData 112 = rm,
                TableData 114 = rm,
                TableData 122 = rm,
                TableData 124 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text7174335: TextConst ENU = 'No se permite el tipo %1 para el tipo de documento %2.', ESP = 'No se permite el tipo %1 para el tipo de documento %2.';
        txtQuoSII_01: TextConst ESP = 'No se puede cambiar la entidad cuando existen l�neas';

    PROCEDURE ActivatedQuoSII(): Boolean;
    VAR
        CompanyInformation: Record 79;
    BEGIN
        IF CompanyInformation.GET THEN
            EXIT(CompanyInformation."QuoSII Activate");
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Activar solo uno de los dos SII"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 79, OnAfterValidateEvent, 'QuoSII Activate', true, true)]
    LOCAL PROCEDURE "T79_OnAfterValidateEvent_QuoSII Activate"(VAR Rec: Record 79; VAR xRec: Record 79; CurrFieldNo: Integer);
    VAR
        Text7174331: TextConst ESP = 'Tiene activado el SII de Microsoft, no puede activar ambos simult�neamente, �Desea desactivarlo?';
        SIISetup: Record 10751;
        Text7174332: TextConst ESP = 'Proceso cancelado';
    BEGIN
        IF (Rec."QuoSII Activate") THEN BEGIN //JAV 22/03/22: - QuoSII 1.06.05 Solo se activa esta verificaci�n si intentamos habilitar el SII est�ndar
            IF (SIISetup.GET) THEN BEGIN
                IF (SIISetup.Enabled) THEN
                    IF CONFIRM(Text7174331, TRUE) THEN BEGIN
                        SIISetup.Enabled := FALSE;
                        SIISetup.MODIFY;
                    END ELSE
                        ERROR(Text7174332);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 10751, OnAfterValidateEvent, Enabled, true, true)]
    LOCAL PROCEDURE T10751_OnAfterValidateEvent_Enabled(VAR Rec: Record 10751; VAR xRec: Record 10751; CurrFieldNo: Integer);
    VAR
        CompanyInformation: Record 79;
        Text7174331: TextConst ESP = 'Tiene activado el QuoSII, no puede activar ambos simult�neamente, �Desea desactivarlo?';
        Text7174332: TextConst ESP = 'Proceso cancelado';
    BEGIN
        //JAV 22/03/22: - QuoSII 1.06.05 Se pasa la funcionalidad a una funci�n para poder llamarla desde otros lugares
        T10751_ValidateEnabled(Rec);
    END;

    PROCEDURE T10751_ValidateEnabled(VAR Rec: Record 10751);
    VAR
        CompanyInformation: Record 79;
        Text7174331: TextConst ESP = 'Tiene activado el QuoSII, no puede activar ambos simult�neamente, �Desea desactivarlo?';
        Text7174332: TextConst ESP = 'Proceso cancelado';
    BEGIN
        //JAV 22/03/22: - QuoSII 1.06.05 Se pasa la funcionalidad de validar la activaci�n del SII a una funci�n para poder llamarla desde otros lugares
        IF (Rec.Enabled) THEN BEGIN //JAV 22/03/22: - QuoSII 1.06.05 Solo se activa esta verificaci�n si intentamos habilitar el QuoSII
            IF (CompanyInformation.GET) THEN BEGIN
                IF (CompanyInformation."QuoSII Activate") THEN
                    IF CONFIRM(Text7174331, TRUE) THEN BEGIN
                        CompanyInformation."QuoSII Activate" := FALSE;
                        CompanyInformation.MODIFY;
                    END ELSE
                        ERROR(Text7174332);
            END;
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Funciones de tabla para campos propios de QuoSII"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, "QuoSII Sales Special Regimen", true, true)]
    LOCAL PROCEDURE T18_OnAfterValidate_QuoSIISalesSpecialRegimen(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortSalesSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen 1")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen 2"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, "QuoSII Sales Special Regimen 1", true, true)]
    LOCAL PROCEDURE T18_OnAfterValidate_QuoSIISalesSpecialRegimen1(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortSalesSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen 1")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen 2"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, "QuoSII Sales Special Regimen 2", true, true)]
    LOCAL PROCEDURE T18_OnAfterValidate_QuoSIISalesSpecialRegimen2(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortSalesSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen 1")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special Regimen 2"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, "QuoSII Sales Special R. ATCN", true, true)]
    LOCAL PROCEDURE T18_OnAfterValidate_QuoSIISalesSpecialRegimenATCN(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortSalesSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. 1 ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. 2 ATCN"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, "QuoSII Sales Special R. 1 ATCN", true, true)]
    LOCAL PROCEDURE T18_OnAfterValidate_QuoSIISalesSpecialRegimen1ATCN(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortSalesSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. 1 ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. 2 ATCN"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, "QuoSII Sales Special R. 2 ATCN", true, true)]
    LOCAL PROCEDURE T18_OnAfterValidate_QuoSIISalesSpecialRegimen2ATCN(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortSalesSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. 1 ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Sales Special R. 2 ATCN"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "QuoSII Purch Special Regimen", true, true)]
    LOCAL PROCEDURE T23_OnAfterValidate_QuoSIIPurchSpecialRegimen(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortPurchaseSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen 1")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen 2"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "QuoSII Purch Special Regimen 1", true, true)]
    LOCAL PROCEDURE T23_OnAfterValidate_QuoSIIPurchSpecialRegimen1(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortPurchaseSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen 1")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen 2"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "QuoSII Purch Special Regimen 2", true, true)]
    LOCAL PROCEDURE T23_OnAfterValidate_QuoSIIPurchSpecialRegimen2(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortPurchaseSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen 1")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special Regimen 2"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "QuoSII Purch Special R. ATCN", true, true)]
    LOCAL PROCEDURE T23_OnAfterValidate_QuoSIIPurchSpecialRegimenATCN(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortPurchaseSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. 1 ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. 2 ATCN"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "QuoSII Purch Special R. 1 ATCN", true, true)]
    LOCAL PROCEDURE T23_OnAfterValidate_QuoSIIPurchSpecialRegimen1ATCN(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortPurchaseSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. 1 ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. 2 ATCN"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    [EventSubscriber(ObjectType::Table, 23, OnAfterValidateEvent, "QuoSII Purch Special R. 2 ATCN", true, true)]
    LOCAL PROCEDURE T23_OnAfterValidate_QuoSIIPurchSpecialRegimen2ATCN(VAR Rec: Record 23; VAR xRec: Record 23; CurrFieldNo: Integer);
    VAR
        rRef: RecordRef;
    BEGIN
        rRef.GETTABLE(Rec);
        IF SortPurchaseSpecialRegimen(rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. 1 ATCN")), rRef.FIELD(Rec.FIELDNO("QuoSII Purch Special R. 2 ATCN"))) THEN
            rRef.SETTABLE(Rec);
        rRef.CLOSE;
    END;

    PROCEDURE ValidateSalesSpecialRegimen(fBase: FieldRef; fValor: FieldRef);
    VAR
        vBase: Code[20];
        vValor: Code[20];
    BEGIN
        //Verificar las posibles combinaciones de operaci�n Especial en ventas
        vBase := FORMAT(fBase.VALUE);
        vValor := FORMAT(fValor.VALUE);

        IF (vBase <> '') AND (vValor <> '') THEN BEGIN
            CASE vBase OF
                '07':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '01 03 05 09 11 12 13 14 15');
                '05':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '01 06 07 08 11 12 13');
                '06':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '05 11 12 13 14 15');
                '11', '12', '13':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '06 07 08 15');
                '03':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '01');
                '01':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '02 05 07 08');
            END;
        END;
    END;

    PROCEDURE SortSalesSpecialRegimen(fClave: FieldRef; fClave1: FieldRef; fClave2: FieldRef): Boolean;
    VAR
        vClave: Code[20];
        vClave1: Code[20];
        vClave2: Code[20];
        Changed: Boolean;
    BEGIN
        //Ordenar por el orden especificado por la AEAT para ventas
        ValidateSalesSpecialRegimen(fClave, fClave1);  //Verifico combinaci�n posible entre la clave principal y la uno
        ValidateSalesSpecialRegimen(fClave, fClave2);  //Verifico combinaci�n posible entre la clave principal y la dos

        Changed := FALSE;
        IF (FORMAT(fClave1.VALUE) = '') AND (FORMAT(fClave2.VALUE) <> '') THEN
            Changed := Swap(fClave1, fClave2)
        ELSE
            CASE FORMAT(fClave2.VALUE) OF
                '07':
                    Changed := Swap(fClave1, fClave2);
                '05':
                    IF (FORMAT(fClave1.VALUE) <> '07') THEN
                        Changed := Swap(fClave1, fClave2);
                '06':
                    IF (FORMAT(fClave1.VALUE) IN ['11', '12', '13']) THEN
                        Changed := Swap(fClave1, fClave2);
                '03':
                    IF (FORMAT(fClave1.VALUE) = '01') THEN
                        Changed := Swap(fClave1, fClave2);
            END;

        IF (FORMAT(fClave.VALUE) = '') AND (FORMAT(fClave1.VALUE) <> '') THEN
            Changed := Swap(fClave, fClave1)
        ELSE
            CASE FORMAT(fClave1.VALUE) OF
                '07':
                    Changed := Swap(fClave, fClave1);
                '05':
                    IF (FORMAT(fClave.VALUE) <> '07') THEN
                        Changed := Swap(fClave, fClave1);
                '06':
                    IF (FORMAT(fClave.VALUE) IN ['11', '12', '13']) THEN
                        Changed := Swap(fClave, fClave1);
                '03':
                    IF (FORMAT(fClave.VALUE) = '01') THEN
                        Changed := Swap(fClave, fClave1);
            END;

        EXIT(Changed);
    END;

    PROCEDURE ValidatePurchaseSpecialRegimen(fBase: FieldRef; fValor: FieldRef);
    VAR
        vBase: Code[20];
        vValor: Code[20];
    BEGIN
        //Verificar las posibles combinaciones de operaci�n Especial en compras
        vBase := FORMAT(fBase.VALUE);
        vValor := FORMAT(fValor.VALUE);

        IF (vBase <> '') AND (vValor <> '') THEN BEGIN
            CASE vBase OF
                '07':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '01 03 05 12');
                '05':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '01 06 07 08 12');
                '12':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '05 06 07 08');
                '03':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '01');
                '01':
                    CheckSpecialRegimen(vBase, fBase.CAPTION, vValor, fValor.CAPTION, '08');
            END;
        END;
    END;

    PROCEDURE SortPurchaseSpecialRegimen(fClave: FieldRef; fClave1: FieldRef; fClave2: FieldRef): Boolean;
    VAR
        vClave: Code[20];
        vClave1: Code[20];
        vClave2: Code[20];
        Changed: Boolean;
    BEGIN
        //Ordenar por el orden especificado por la AEAT para compras
        ValidatePurchaseSpecialRegimen(fClave, fClave1);  //Verifico combinaci�n posible entre la clave principal y la uno
        ValidatePurchaseSpecialRegimen(fClave, fClave2);  //Verifico combinaci�n posible entre la clave principal y la dos

        Changed := FALSE;
        IF (FORMAT(fClave1.VALUE) = '') AND (FORMAT(fClave2.VALUE) <> '') THEN
            Changed := Swap(fClave1, fClave2)
        ELSE
            CASE FORMAT(fClave2.VALUE) OF
                '07':
                    Changed := Swap(fClave1, fClave2);
                '05':
                    IF (FORMAT(fClave1.VALUE) <> '07') THEN
                        Changed := Swap(fClave1, fClave2);
                '06':
                    IF (FORMAT(fClave1.VALUE) = '12') THEN
                        Changed := Swap(fClave1, fClave2);
                '03':
                    IF (FORMAT(fClave1.VALUE) = '01') THEN
                        Changed := Swap(fClave1, fClave2);
            END;

        IF (FORMAT(fClave.VALUE) = '') AND (FORMAT(fClave1.VALUE) <> '') THEN
            Changed := Swap(fClave, fClave1)
        ELSE
            CASE FORMAT(fClave1.VALUE) OF
                '07':
                    Changed := Swap(fClave, fClave1);
                '05':
                    IF (FORMAT(fClave.VALUE) <> '07') THEN
                        Changed := Swap(fClave, fClave1);
                '06':
                    IF (FORMAT(fClave.VALUE) = '12') THEN
                        Changed := Swap(fClave, fClave1);
                '03':
                    IF (FORMAT(fClave.VALUE) = '01') THEN
                        Changed := Swap(fClave, fClave1);
            END;

        EXIT(Changed);
    END;

    LOCAL PROCEDURE CheckSpecialRegimen(vBase: Code[20]; cBase: Text; vValor: Code[20]; cValor: Text; lValores: Text);
    VAR
        Text7174331: TextConst ESP = 'Cuando %1 es %2 el campo %3 s�lo puede tomar los valores: %4';
        Text7174332: TextConst ESP = 'Cuando %1 es %2 el campo %3 s�lo puede tomar el valor: %4';
    BEGIN
        //Verifica un valor del r�gimen especial posible
        IF (STRPOS(lValores, vValor) = 0) THEN
            IF (STRLEN(lValores) = 2) THEN
                ERROR(Text7174332, cBase, vBase, cValor, lValores)
            ELSE
                ERROR(Text7174331, cBase, vBase, cValor, lValores)
    END;

    LOCAL PROCEDURE Swap(fValor1: FieldRef; fValor2: FieldRef): Boolean;
    VAR
        fAux: Code[20];
    BEGIN
        //Intercambia el valor de dos fieldRef
        IF (fValor1.VALUE = fValor2.VALUE) THEN
            EXIT(FALSE)
        ELSE BEGIN
            fAux := FORMAT(fValor1.VALUE);
            fValor1.VALUE := fValor2.VALUE;
            fValor2.VALUE := fAux;
            EXIT(TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QuoSII Entity", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_QuoSIIEntity(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        SalesLine: Record 37;
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad desde la tabla para unificar
        //----------------------------------------------------------------------------------------------------------------------------------
        //QuoSII_1.4.02.042.begin
        IF (Rec."QuoSII Entity" <> xRec."QuoSII Entity") THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", Rec."Document Type");
            SalesLine.SETRANGE("Document No.", Rec."No.");
            //JAV 10/05/22: - QuoSII 1.06.07 Si cambiamos la entidad en la cabecera cambiarlo en todas las l�neas, no dar el error
            //IF SalesLine.COUNT > 0 THEN
            //  ERROR(txtQuoSII_01,Rec.FIELDCAPTION("QuoSII Entity"));
            SalesLine.MODIFYALL("QuoSII Entity", Rec."QuoSII Entity");
        END;
        //QuoSII_1.4.02.042.end
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QuoSII Sales Cr.Memo Type", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_QuoSIISalesCrMemoType(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad desde la tabla para unificar
        //----------------------------------------------------------------------------------------------------------------------------------
        IF (Rec."Document Type" IN [Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order"]) AND (Rec."QuoSII Sales Cr.Memo Type" = 'S') THEN
            ERROR(Text7174335, Rec."QuoSII Sales Cr.Memo Type", Rec."Document Type");
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QuoSII Entity", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_QuoSIIEntity(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad desde la tabla para unificar
        //----------------------------------------------------------------------------------------------------------------------------------
        //QuoSII_1.4.02.042.begin
        //JAV 10/05/22: - QuoSII 1.06.07 Si cambiamos la entidad en la cabecera no hacer nada, ya que no se usa en las l�neas
        /*{---
              IF ("QuoSII Entity" <> xRec."QuoSII Entity") THEN BEGIN
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type","Document Type");
                PurchaseLine.SETRANGE("Document No.","No.");
                IF PurchaseLine.COUNT > 0 THEN
                  ERROR(txtQuoSII_01,Rec.FIELDCAPTION("QuoSII Entity"));
              END;
              ---}*/
        //QuoSII_1.4.02.042.end
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QuoSII Purch. Cr.Memo Type", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_QuoSIIPurchCrMemoType(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad desde la tabla para unificar
        //----------------------------------------------------------------------------------------------------------------------------------
        IF (Rec."Document Type" IN [Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order"]) AND (Rec."QuoSII Purch. Cr.Memo Type" = 'S') THEN
            ERROR(Text7174335, Rec."QuoSII Purch. Cr.Memo Type", Rec."Document Type");
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Eventos de tablas para campos no del QuoSII"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, 'Country/Region Code', true, true)]
    LOCAL PROCEDURE T18_OnAfterValidateEvent_CountryRegionCode(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        CountryRegion: Record 9;
    BEGIN
        //QuoSII_1.4.97.999.begin
        IF (ActivatedQuoSII) THEN BEGIN
            IF CountryRegion.GET(Rec."Country/Region Code") THEN
                IF CountryRegion."QuoSII VAT Reg No. Type" <> '' THEN
                    Rec.VALIDATE("QuoSII VAT Reg No. Type", CountryRegion."QuoSII VAT Reg No. Type");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, 'VAT Registration No.', true, true)]
    LOCAL PROCEDURE T18_OnAfterValidateEvent_VATRegistrationNo(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        SIIDocuments: Record 7174333;
        SIIDocuments2: Record 7174333;
        NewVatRegistrationNo: Code[20];
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            IF Rec."VAT Registration No." <> xRec."VAT Registration No." THEN BEGIN
                NewVatRegistrationNo := Rec."VAT Registration No.";
                SIIDocuments.RESET;
                SIIDocuments.SETFILTER("Document Type", FORMAT(SIIDocuments."Document Type"::FE));
                SIIDocuments.SETFILTER(SIIDocuments."Cust/Vendor No.", Rec."No.");
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::OI);
                SIIDocuments.SETRANGE("Declarate Key UE", 'D');
                SIIDocuments.SETRANGE(SIIDocuments."Cust/Vendor No.", Rec."No.");
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::CE);
                SIIDocuments.SETRANGE(SIIDocuments."Cust/Vendor No.", Rec."No.");
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::CM);
                SIIDocuments.SETRANGE(SIIDocuments."Cust/Vendor No.", Rec."No.");
                SIIDocuments.SETFILTER("AEAT Status", '<>%1|<>%2', 'CORRECTO', 'ANULADA'); //QuoSII1.4
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, 'Country/Region Code', true, true)]
    LOCAL PROCEDURE T21_OnAfterValidateEvent_CountryRegionCode(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        CountryRegion: Record 9;
    BEGIN
        //QuoSII_1.4.97.999.begin
        IF (ActivatedQuoSII) THEN BEGIN
            IF CountryRegion.GET(Rec."Country/Region Code") THEN
                IF CountryRegion."QuoSII VAT Reg No. Type" <> '' THEN
                    Rec.VALIDATE("QuoSII VAT Reg No. Type", CountryRegion."QuoSII VAT Reg No. Type");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 18, OnAfterValidateEvent, 'VAT Registration No.', true, true)]
    LOCAL PROCEDURE T21_OnAfterValidateEvent_VATRegistrationNo(VAR Rec: Record 18; VAR xRec: Record 18; CurrFieldNo: Integer);
    VAR
        SIIDocuments: Record 7174333;
        SIIDocuments2: Record 7174333;
        NewVatRegistrationNo: Code[20];
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            IF Rec."VAT Registration No." <> xRec."VAT Registration No." THEN BEGIN
                NewVatRegistrationNo := Rec."VAT Registration No.";
                SIIDocuments.RESET;
                SIIDocuments.SETFILTER("Document Type", FORMAT(SIIDocuments."Document Type"::FE));
                SIIDocuments.SETFILTER(SIIDocuments."Cust/Vendor No.", Rec."No.");
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::OI);
                SIIDocuments.SETRANGE("Declarate Key UE", 'D');
                SIIDocuments.SETRANGE(SIIDocuments."Cust/Vendor No.", Rec."No.");
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::CE);
                SIIDocuments.SETRANGE(SIIDocuments."Cust/Vendor No.", Rec."No.");
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Document Type", SIIDocuments."Document Type"::CM);
                SIIDocuments.SETRANGE(SIIDocuments."Cust/Vendor No.", Rec."No.");
                SIIDocuments.SETFILTER("AEAT Status", '<>%1|<>%2', 'CORRECTO', 'ANULADA'); //QuoSII1.4
                IF SIIDocuments.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        ChangeDocumentsVatRegistration(NewVatRegistrationNo, SIIDocuments);
                        SIIDocuments2.RESET;
                        SIIDocuments2 := SIIDocuments;
                        SIIDocuments2.RENAME(SIIDocuments2."Document Type", SIIDocuments2."Document No.", NewVatRegistrationNo, SIIDocuments2."Posting Date", SIIDocuments2."Entry No.",
                                             SIIDocuments2."Register Type");  //JAV 30/05
                    UNTIL SIIDocuments.NEXT = 0;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE ChangeDocumentsVatRegistration(NewVatRegistrationNo: Code[20]; SIIDocuments: Record 7174333);
    VAR
        SIIDocumentLine: Record 7174334;
        SIIDocumentLine2: Record 7174334;
        SIIDocumentShipmentLine: Record 7174336;
        SIIDocumentShipmentLine2: Record 7174336;
    BEGIN
        //QuoSII.BEGIN
        IF (ActivatedQuoSII) THEN BEGIN
            SIIDocumentLine.RESET;
            SIIDocumentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
            SIIDocumentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
            SIIDocumentLine.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
            SIIDocumentLine.SETRANGE("Entry No.", SIIDocuments."Entry No.");
            SIIDocumentLine.SETRANGE("Register Type", SIIDocuments."Register Type");
            IF SIIDocumentLine.FINDSET THEN BEGIN
                REPEAT
                    SIIDocumentLine2.RESET;
                    SIIDocumentLine2 := SIIDocumentLine;
                    SIIDocumentLine2.RENAME(SIIDocumentLine2."Document Type", SIIDocumentLine2."Document No.", NewVatRegistrationNo,
                                            SIIDocumentLine2."Entry No.", SIIDocumentLine2."Register Type",                                //QuoSII_1.3.02.005.begin
                                            SIIDocumentLine2."% VAT", SIIDocumentLine2."% RE", SIIDocumentLine2."No Taxable VAT", SIIDocumentLine2.Exent,
                                            SIIDocumentLine2.Servicio, SIIDocumentLine2."Inversión Sujeto Pasivo");
                UNTIL SIIDocumentLine.NEXT = 0;
            END;

            SIIDocumentShipmentLine.RESET;
            SIIDocumentShipmentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
            SIIDocumentShipmentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
            SIIDocumentShipmentLine.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
            SIIDocumentShipmentLine.SETRANGE("Posting Date", SIIDocuments."Posting Date");
            SIIDocumentShipmentLine.SETRANGE("Entry No.", SIIDocuments."Entry No.");
            SIIDocumentShipmentLine.SETRANGE("Register Type", SIIDocuments."Register Type");
            IF SIIDocumentShipmentLine.FINDSET THEN BEGIN
                REPEAT
                    SIIDocumentShipmentLine2.RESET;
                    SIIDocumentShipmentLine2 := SIIDocumentShipmentLine;
                    SIIDocumentShipmentLine2.RENAME(SIIDocumentShipmentLine."Ship No.", SIIDocumentShipmentLine."Document No.", NewVatRegistrationNo
                                                    //QuoSII_1.3.02.005.begin
                                                    , SIIDocumentShipmentLine."Posting Date", SIIDocumentShipmentLine."Entry No.", SIIDocumentShipmentLine."Register Type");
                //QuoSII_1.3.02.005.end
                UNTIL SIIDocumentShipmentLine.NEXT = 0;
            END;
            //QuoSII.END
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, 'Sell-to Customer No.', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_SelltoCustomerNo(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        CustomerPostGroup: Record 92;
        VATBusinessPostingGroup: Record 323;
        GeneralLedgerSetup: Record 98;
        Cust: Record 18;
        CompanyInfo: Record 79;
    BEGIN
        //QuoSII_1.4.02.042
        //QuoSII_1.4.92.999
        IF (ActivatedQuoSII) THEN BEGIN
            Cust.GET(Rec."Sell-to Customer No.");
            //QuoSII_1.4.02.042 //QuoSII_1.4.92.999.begin
            IF VATBusinessPostingGroup.GET(Cust."VAT Bus. Posting Group") THEN BEGIN
                VATBusinessPostingGroup.TESTFIELD("QuoSII Entity");
                Rec.VALIDATE("QuoSII Entity", VATBusinessPostingGroup."QuoSII Entity");
            END ELSE BEGIN
                GeneralLedgerSetup.GET;
                Rec.VALIDATE("QuoSII Entity", GeneralLedgerSetup."QuoSII Default SII Entity");
            END;
            //QuoSII_1.4.92.999
            CustomerPostGroup.GET(Cust."Customer Posting Group");
            //QuoSII_1.4.02.042.22.begin
            //IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Return Order"] THEN BEGIN
            IF Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice, Rec."Document Type"::"Return Order", Rec."Document Type"::"Credit Memo"] THEN BEGIN
                //QuoSII_1.4.02.042.22.end
                IF CustomerPostGroup."QuoSII Type" = CustomerPostGroup."QuoSII Type"::OI THEN BEGIN
                    Rec.VALIDATE("QuoSII Sales UE Inv Type", 'A');
                    Rec.VALIDATE("QuoSII Bienes Description", 'Operaci�n Intracomunitaria');
                    Rec.VALIDATE("QuoSII Operator Address", Cust."Country/Region Code" + Cust."VAT Registration No.");
                END ELSE BEGIN
                    IF CustomerPostGroup."QuoSII Type" = CustomerPostGroup."QuoSII Type"::LF THEN BEGIN
                        //QuoSII_2_4.begin
                        IF (Rec."Document Type" <> Rec."Document Type"::"Credit Memo") THEN //QuoSII_1.4.02.042.22  //QuoSII_1.4.92.999
                            Rec.VALIDATE("QuoSII Sales Invoice Type", 'F1');
                        //QuoSII_2_4.end
                        IF Rec."QuoSII Entity" = 'AEAT' THEN BEGIN//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Sales Special Regimen", Cust."QuoSII Sales Special Regimen");
                            Rec.VALIDATE("QuoSII Sales Special Regimen 1", Cust."QuoSII Sales Special Regimen 1");
                            Rec.VALIDATE("QuoSII Sales Special Regimen 2", Cust."QuoSII Sales Special Regimen 2");
                        END ELSE BEGIN//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Sales Special Regimen", Cust."QuoSII Sales Special R. ATCN");//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Sales Special Regimen 1", Cust."QuoSII Sales Special R. 1 ATCN");//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Sales Special Regimen 2", Cust."QuoSII Sales Special R. 2 ATCN");//QuoSII_1.4.02.042.04
                        END;//QuoSII_1.4.02.042.04
                            //QuoSII1.4.begin
                        CompanyInfo.GET;
                        IF (CompanyInfo."QuoSII Inclusion Date" <> 0D) AND (Rec."Posting Date" < CompanyInfo."QuoSII Inclusion Date") THEN BEGIN
                            Rec.VALIDATE("QuoSII Sales Special Regimen", '16');
                            Rec.VALIDATE("QuoSII Sales Special Regimen 1", '');
                            Rec.VALIDATE("QuoSII Sales Special Regimen 2", '');
                        END;
                        //QuoSII1.4.end
                    END;
                END;
            END;
            //QuoSII_1.4.02.042.end

            //QuoSII_1.5y  JAV 29/07/21: - Se manejan ejercicio y periodo del documento al crear el documento
            SalesHeader_CalculatePeriod(Rec);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, 'No.', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_No(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        VATPostingSetup: Record 325;
        SalesHeader: Record 36;
    BEGIN
        //QuoSII_1.4.02.042.
        IF (ActivatedQuoSII) THEN BEGIN
            SalesHeader.GET(Rec."Document Type", Rec."Document No.");
            VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");//QuoSII_1.4.02.042.02
            IF VATPostingSetup."QuoSII Entity" <> SalesHeader."QuoSII Entity" THEN//QuoSII_1.4.02.042.02
                ERROR('El valor del campo %1 de la tabla %2 es distinto del valor del campo %3 de la cabecera.',
                      VATPostingSetup.FIELDCAPTION("QuoSII Entity"), VATPostingSetup.TABLECAPTION, SalesHeader.FIELDCAPTION("QuoSII Entity"));//QuoSII_1.4.02.042.02
            Rec."QuoSII Entity" := SalesHeader."QuoSII Entity";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, 'Document Date', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_DocumentDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento
        SalesHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, 'Posting Date', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_PostingDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento
        SalesHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, 'Due Date', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_DueDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento
        SalesHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, 'QFA Period End Date', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_PeriodEndDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento
        SalesHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, 'QB Operation date SII', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_OperationDateSII(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento
        SalesHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, 'QuoSII Sales Special Regimen', true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_QuoSIISalesSpecialRegimen(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento
        SalesHeader_CalculatePeriod(Rec);
    END;

    LOCAL PROCEDURE SalesHeader_CalculatePeriod(VAR Rec: Record 36);
    VAR
        CompanyInformation: Record 79;
        SalesLine: Record 37;
        FunctionQB: Codeunit 7207272;
        SkipShipment: Boolean;
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan Fecha de Operaci�n, ejercicio y periodo del documento

        //QuoSII 1.06.02 JAV 09/02/22: - No se debe hacer para pedidos abiertos.
        IF (Rec."Document Type" = Rec."Document Type"::"Blanket Order") THEN
            EXIT;

        IF (ActivatedQuoSII) THEN BEGIN
            CompanyInformation.GET();

            //Calcular la fecha de operaci�n, por defecto la del documento, pero se calcula de otra forma para facturas
            Rec."QuoSII Operation Date" := Rec."Posting Date";
            IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN
                //Si es una de tipo 14, la fecha de operaci�n es la del vencimiento
                IF (Rec."QuoSII Sales Special Regimen" = '14') OR
                   (Rec."QuoSII Sales Special Regimen 1" = '14') OR
                   (Rec."QuoSII Sales Special Regimen 2" = '14') THEN
                    Rec."QuoSII Operation Date" := Rec."Due Date"
                ELSE BEGIN
                    //Si no es tipo 14 se usa en este orden: Fecha operaci�n informada, fecha fin periodo informado, fecha de env�o de las l�neas, fecha del documento
                    //   pero me salto el ver las fechas de envio de las l�neas si estamos en QB o hemos marcado que se salte.
                    SkipShipment := (FunctionQB.AccessToQuobuilding) OR (CompanyInformation."QuoSII Not Use Shipment Date");
                    Rec."QuoSII Operation Date" := 0D;
                    IF (Rec."QB Operation date SII" <> 0D) THEN
                        Rec."QuoSII Operation Date" := Rec."QB Operation date SII"
                    ELSE IF (Rec."QFA Period End Date" <> 0D) THEN
                        Rec."QuoSII Operation Date" := Rec."QFA Period End Date"
                    ELSE IF (NOT SkipShipment) THEN BEGIN
                        SalesLine.RESET;
                        SalesLine.SETRANGE("Document Type", Rec."Document Type");
                        SalesLine.SETRANGE("Document No.", Rec."No.");
                        IF SalesLine.FINDSET THEN
                            REPEAT
                                IF SalesLine."Shipment Date" > Rec."QuoSII Operation Date" THEN
                                    Rec."QuoSII Operation Date" := SalesLine."Shipment Date";
                            UNTIL SalesLine.NEXT = 0;
                    END;
                    //Si no hay todav�a fecha de operaci�n, se usa la del documento
                    IF (Rec."QuoSII Operation Date" = 0D) THEN
                        Rec."QuoSII Operation Date" := Rec."Document Date";
                END;
            END;

            Rec."QuoSII Exercise-Period" := FORMAT(DATE2DMY(Rec."QuoSII Operation Date", 2)) + '-' + FORMAT(DATE2DMY(Rec."QuoSII Operation Date", 3));
            IF (STRLEN(Rec."QuoSII Exercise-Period") = 6) THEN
                Rec."QuoSII Exercise-Period" := '0' + Rec."QuoSII Exercise-Period";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, 'Buy-from Vendor No.', true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_BuyfromVendorNo(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        VendorPostGroup: Record 93;
        VATBusinessPostingGroup: Record 323;
        GeneralLedgerSetup: Record 98;
        Vend: Record 23;
        CompanyInfo: Record 79;
    BEGIN
        //QuoSII_1.4.02.042
        //QuoSII_1.4.92.999
        IF (ActivatedQuoSII) THEN BEGIN
            Vend.GET(Rec."Buy-from Vendor No.");

            IF VATBusinessPostingGroup.GET(Vend."VAT Bus. Posting Group") THEN BEGIN
                VATBusinessPostingGroup.TESTFIELD("QuoSII Entity");
                Rec.VALIDATE("QuoSII Entity", VATBusinessPostingGroup."QuoSII Entity");
            END ELSE BEGIN
                GeneralLedgerSetup.GET;
                Rec.VALIDATE("QuoSII Entity", GeneralLedgerSetup."QuoSII Default SII Entity");
            END;

            VendorPostGroup.GET(Vend."Vendor Posting Group");
            //QuoSII_1.4.02.042.22.begin
            //IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Return Order"] THEN BEGIN
            IF Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice, Rec."Document Type"::"Return Order", Rec."Document Type"::"Credit Memo"] THEN BEGIN
                //QuoSII_1.4.02.042.22.end
                IF VendorPostGroup."QuoSII Type" = VendorPostGroup."QuoSII Type"::OI THEN BEGIN
                    Rec.VALIDATE("QuoSII Purch. UE Inv Type", 'A');
                    Rec.VALIDATE("QuoSII Bienes Description", 'Operaci�n Intracomunitaria');
                    Rec.VALIDATE("QuoSII Operator Address", Vend."Country/Region Code" + Vend."VAT Registration No.");
                END ELSE BEGIN
                    IF VendorPostGroup."QuoSII Type" = VendorPostGroup."QuoSII Type"::LF THEN BEGIN
                        //QuoSII.2_4.begin
                        IF (Rec."Document Type" <> Rec."Document Type"::"Credit Memo") THEN //QuoSII_1.4.02.042.22   //QuoSII_1.4.92.999
                            Rec.VALIDATE("QuoSII Purch. Invoice Type", 'F1');
                        //QuoSII.2_4.end
                        IF Rec."QuoSII Entity" = 'AEAT' THEN BEGIN//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Purch Special Regimen", Vend."QuoSII Purch Special Regimen");
                            Rec.VALIDATE("QuoSII Purch Special Regimen 1", Vend."QuoSII Purch Special Regimen 1");
                            Rec.VALIDATE("QuoSII Purch Special Regimen 2", Vend."QuoSII Purch Special Regimen 2");
                        END ELSE BEGIN//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Purch Special Regimen", Vend."QuoSII Purch Special R. ATCN");//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Purch Special Regimen 1", Vend."QuoSII Purch Special R. 1 ATCN");//QuoSII_1.4.02.042.04
                            Rec.VALIDATE("QuoSII Purch Special Regimen 2", Vend."QuoSII Purch Special R. 2 ATCN");//QuoSII_1.4.02.042.04
                        END;//QuoSII_1.4.02.042.04
                            //QuoSII1.4.begin
                        CompanyInfo.GET;
                        IF (CompanyInfo."QuoSII Inclusion Date" <> 0D) AND (Rec."Posting Date" < CompanyInfo."QuoSII Inclusion Date") THEN BEGIN
                            Rec.VALIDATE("QuoSII Purch Special Regimen", '14');
                            Rec.VALIDATE("QuoSII Purch Special Regimen 1", '');
                            Rec.VALIDATE("QuoSII Purch Special Regimen 2", '');
                        END;
                        //QuoSII1.4.end
                    END;
                END;
            END;
            //QuoSII_1.4.02.042.end
            //QuoSII.end
            //Rec."SII Auto Posting Date" := TODAY;//QuoSII_1.3.03.006

            //QuoSII_1.5y  JAV 29/07/21: - Se manejan ejercicio y periodo del documento al crear el documento
            PurchaseHeader_CalculatePeriod(Rec);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, 'Posting Date', true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_PostingDate(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan ejercicio y periodo del documento
        PurchaseHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, 'Document Date', true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_DocumentDate(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan ejercicio y periodo del documento
        PurchaseHeader_CalculatePeriod(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, 'QuoSII Exercise-Period', true, true)]
    LOCAL PROCEDURE PurchaseHeader_CalculatePeriod(VAR Rec: Record 38);
    VAR
        CompanyInformation: Record 79;
        auxDate: Date;
    BEGIN
        //QuoSII_1.5d  JAV 12/04/21: - Se manejan ejercicio y periodo del documento

        //QuoSII 1.06.02 JAV 09/02/22: - No se debe hacer para pedidos abiertos.
        IF (Rec."Document Type" = Rec."Document Type"::"Blanket Order") THEN
            EXIT;

        IF (ActivatedQuoSII) THEN BEGIN
            CompanyInformation.GET();
            IF (CompanyInformation."QuoSII Day Periodo Purchase" = 0) THEN  //JAV 12/04/21 se hace configurable el campo del �ltimo d�a, si no se informa es el 15
                CompanyInformation."QuoSII Day Periodo Purchase" := 15;

            auxDate := Rec."Posting Date";
            IF (CompanyInformation."QuoSII Purch. Invoices Period") AND
               (DATE2DMY(Rec."Posting Date", 1) <= CompanyInformation."QuoSII Day Periodo Purchase") AND
               (DATE2DMY(Rec."Document Date", 2) < DATE2DMY(Rec."Posting Date", 2)) THEN
                auxDate := CALCDATE('-1M+PM', Rec."Posting Date");    //Quito un mes y me voy al �ltimo d�a de ese mes

            Rec."QuoSII Exercise-Period" := FORMAT(DATE2DMY(auxDate, 2)) + '-' + FORMAT(DATE2DMY(auxDate, 3));
            IF (STRLEN(Rec."QuoSII Exercise-Period") = 6) THEN
                Rec."QuoSII Exercise-Period" := '0' + Rec."QuoSII Exercise-Period";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterValidateEvent, 'Account No.', true, true)]
    LOCAL PROCEDURE T81_OnAfterValidateEvent_AccountNo(VAR Rec: Record 81; VAR xRec: Record 81; CurrFieldNo: Integer);
    VAR
        VATBusinessPostingGroup: Record 323;
        GeneralLedgerSetup: Record 98;
        Vendor: Record 23;
        Customer: Record 18;
    BEGIN
        //QuoSII_1.4.92.999.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII_1.4.02.042.begin
            IF Rec."Account Type" IN [Rec."Account Type"::Customer, Rec."Account Type"::Vendor] THEN
                IF (Rec."Document Type" IN [Rec."Document Type"::" ", Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo", Rec."Document Type"::Payment]) THEN BEGIN
                    IF Rec."Account Type" = Rec."Account Type"::Customer THEN BEGIN
                        Customer.RESET;
                        IF NOT Customer.GET(Rec."Account No.") THEN;
                        IF VATBusinessPostingGroup.GET(Customer."VAT Bus. Posting Group") THEN BEGIN
                            VATBusinessPostingGroup.TESTFIELD("QuoSII Entity");
                            Rec.VALIDATE("QuoSII Entity", VATBusinessPostingGroup."QuoSII Entity");
                        END ELSE BEGIN
                            GeneralLedgerSetup.GET;
                            Rec.VALIDATE("QuoSII Entity", GeneralLedgerSetup."QuoSII Default SII Entity");
                        END;
                    END ELSE BEGIN
                        Vendor.RESET;
                        IF NOT Vendor.GET(Rec."Account No.") THEN;
                        IF VATBusinessPostingGroup.GET(Vendor."VAT Bus. Posting Group") THEN BEGIN
                            VATBusinessPostingGroup.TESTFIELD("QuoSII Entity");
                            Rec.VALIDATE("QuoSII Entity", VATBusinessPostingGroup."QuoSII Entity");
                        END ELSE BEGIN
                            GeneralLedgerSetup.GET;
                            Rec.VALIDATE("QuoSII Entity", GeneralLedgerSetup."QuoSII Default SII Entity");
                        END;
                    END;
                END;
            //QuoSII_1.4.02.042.end
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterAccountNoOnValidateGetCustomerAccount, '', true, true)]
    LOCAL PROCEDURE T81_OnAfterAccountNoOnValidateGetCustomerAccount(VAR GenJournalLine: Record 81; VAR Customer: Record 18; CallingFieldNo: Integer);
    VAR
        CustomerPostGroup: Record 92;
        CompanyInfo: Record 79;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.2_7.begin
            IF GenJournalLine."Document Type" IN [GenJournalLine."Document Type"::Invoice, GenJournalLine."Document Type"::"Credit Memo"] THEN BEGIN
                //QuoSII.2_7.end
                CustomerPostGroup.GET(Customer."Customer Posting Group");
                IF CustomerPostGroup."QuoSII Type" = CustomerPostGroup."QuoSII Type"::OI THEN BEGIN
                    IF GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice THEN BEGIN
                        GenJournalLine.VALIDATE("QuoSII Sales UE Inv Type", 'A'); //QuoSII_1.4.02.042
                        GenJournalLine.VALIDATE("QuoSII Bienes Description", 'Operaci�n Intracomunitaria');
                        GenJournalLine.VALIDATE("QuoSII Operator Address", '');
                    END;
                END ELSE BEGIN
                    IF CustomerPostGroup."QuoSII Type" = CustomerPostGroup."QuoSII Type"::LF THEN BEGIN
                        //QuoSII.2_4.begin
                        GenJournalLine.VALIDATE("QuoSII Sales Invoice Type QS", 'F1'); //QuoSII_1.4.02.042
                                                                                       //QuoSII.2_4.end
                        IF GenJournalLine."QuoSII Entity" = 'AEAT' THEN BEGIN//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen", Customer."QuoSII Sales Special Regimen");
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen 1", Customer."QuoSII Sales Special Regimen 1");
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen 2", Customer."QuoSII Sales Special Regimen 2");
                        END ELSE BEGIN//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen", Customer."QuoSII Sales Special R. ATCN");//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen 1", Customer."QuoSII Sales Special R. 1 ATCN");//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen 2", Customer."QuoSII Sales Special R. 2 ATCN");//QuoSII_1.4.02.042.04
                        END;//QuoSII_1.4.02.042.04
                            //QSI14-2.begin
                        CompanyInfo.GET;
                        IF (CompanyInfo."QuoSII Inclusion Date" <> 0D) AND (GenJournalLine."Posting Date" < CompanyInfo."QuoSII Inclusion Date") THEN BEGIN
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen", '16'); //QuoSII_1.4.02.042
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen 1", ''); //QuoSII_1.4.02.042
                            GenJournalLine.VALIDATE("QuoSII Sales Special Regimen 2", ''); //QuoSII_1.4.02.042
                        END;
                        //QSI14-2.end
                    END;
                END;
                //QuoSII.2_7.begin
            END;
            //QuoSII_1.4.93.999.begin
            IF (Customer."QuoSII Sales Special Regimen" = '07') THEN
                GenJournalLine.VALIDATE("QuoSII Sales Special Regimen", Customer."QuoSII Sales Special Regimen");
            //QuoSII_1.4.93.999.end
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterAccountNoOnValidateGetVendorAccount, '', true, true)]
    LOCAL PROCEDURE T81_OnAfterAccountNoOnValidateGetVendorAccount(VAR GenJournalLine: Record 81; VAR Vendor: Record 23; CallingFieldNo: Integer);
    VAR
        VendorPostGroup: Record 93;
        CompanyInfo: Record 79;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            //QuoSII.2_7.begin
            IF GenJournalLine."Document Type" IN [GenJournalLine."Document Type"::Invoice, GenJournalLine."Document Type"::"Credit Memo"] THEN BEGIN
                //QuoSII.2_7.end
                VendorPostGroup.GET(Vendor."Vendor Posting Group");
                IF VendorPostGroup."QuoSII Type" = VendorPostGroup."QuoSII Type"::OI THEN BEGIN
                    IF GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice THEN BEGIN
                        GenJournalLine.VALIDATE("QuoSII Purch. UE Inv Type", 'A'); //QuoSII_1.4.02.042
                        GenJournalLine.VALIDATE("QuoSII Bienes Description", 'Operaci�n Intracomunitaria');
                        GenJournalLine.VALIDATE("QuoSII Operator Address", '');
                    END;
                END ELSE BEGIN
                    IF VendorPostGroup."QuoSII Type" = VendorPostGroup."QuoSII Type"::LF THEN BEGIN
                        //QuoSII.2_4.begin
                        GenJournalLine.VALIDATE("QuoSII Purch. Invoice Type QS", 'F1'); //QuoSII_1.4.02.042
                                                                                        //QuoSII.2_4.end
                        IF GenJournalLine."QuoSII Entity" = 'AEAT' THEN BEGIN//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Regimen", Vendor."QuoSII Purch Special Regimen");
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Reg. 1", Vendor."QuoSII Purch Special Regimen 1");
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Reg. 2", Vendor."QuoSII Purch Special Regimen 2");
                        END ELSE BEGIN//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Regimen", Vendor."QuoSII Purch Special R. ATCN");    //QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Reg. 1", Vendor."QuoSII Purch Special R. 1 ATCN");//QuoSII_1.4.02.042.04
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Reg. 2", Vendor."QuoSII Purch Special R. 2 ATCN");//QuoSII_1.4.02.042.04
                        END;//QuoSII_1.4.02.042.04

                        //QSI14-2.begin
                        CompanyInfo.GET;
                        IF (CompanyInfo."QuoSII Inclusion Date" <> 0D) AND (GenJournalLine."Posting Date" < CompanyInfo."QuoSII Inclusion Date") THEN BEGIN
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Regimen", '14'); //QuoSII_1.4.02.042
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Reg. 1", '');  //QuoSII_1.4.02.042
                            GenJournalLine.VALIDATE("QuoSII Purch. Special Reg. 2", '');  //QuoSII_1.4.02.042
                        END;
                        //QSI14-2.end
                    END;
                END;
                //QuoSII.2_7.begin
            END;
            //QuoSII_1.4.93.999.begin
            IF (Vendor."QuoSII Purch Special Regimen" = '07') THEN
                GenJournalLine.VALIDATE("QuoSII Purch. Special Regimen", Vendor."QuoSII Purch Special Regimen");
            //QuoSII_1.4.93.999.end
        END;
    END;

    [EventSubscriber(ObjectType::Table, 81, OnAfterAccountNoOnValidateGetBankBalAccount, '', true, true)]
    LOCAL PROCEDURE T81_OnAfterAccountNoOnValidateGetBankBalAccount(VAR GenJournalLine: Record 81; VAR BankAccount: Record 270; CallingFieldNo: Integer);
    BEGIN
        //QuoSII_02_07.begin
        IF (ActivatedQuoSII) THEN BEGIN
            GenJournalLine."QuoSII Medio Cobro/Pago" := '01';
            GenJournalLine."QuoSII Cuenta Medio Cobro/Pago" := BankAccount.IBAN;
        END;
    END;

    // [EventSubscriber(ObjectType::Table, 81, OnAfterSetJournalLineFieldsFromApplication, '', true, true)]
    LOCAL PROCEDURE T81_OnAfterSetJournalLineFieldsFromApplication(VAR GenJournalLine: Record 81; AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee"; AccNo: Code[20]);
    VAR
        SalesInvoiceHeader: Record 112;
        PurchInvHeader: Record 122;
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 11/05/22: - QuoSII 1.06.07 Al indicar el documento a pagar o a cobrar en el diario se aplica su r�gimen especial a la l�nea
        //----------------------------------------------------------------------------------------------------------------------------------
        GenJournalLine."QuoSII Sales Special Regimen" := '';

        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) THEN
            IF (SalesInvoiceHeader.GET(GenJournalLine."Applies-to Doc. No.")) THEN
                GenJournalLine."QuoSII Sales Special Regimen" := SalesInvoiceHeader."QuoSII Sales Special Regimen";

        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) THEN
            IF (PurchInvHeader.GET(GenJournalLine."Applies-to Doc. No.")) THEN
                GenJournalLine."QuoSII Purch. Special Regimen" := PurchInvHeader."QuoSII Purch Special Regimen";
    END;

    [EventSubscriber(ObjectType::Table, 113, OnAfterInitFromSalesLine, '', true, true)]
    LOCAL PROCEDURE T113_OnAfterInitFromSalesLine(VAR SalesInvLine: Record 113; SalesInvHeader: Record 112; SalesLine: Record 37);
    BEGIN
        //QuoSII.007.begin
        IF (ActivatedQuoSII) THEN BEGIN
            SalesInvLine."QuoSII Situacion Inmueble" := SalesLine."QuoSII Situacion Inmueble";
            SalesInvLine."QuoSII Referencia Catastral" := SalesLine."QuoSII Referencia Catastral";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 113, OnAfterInitFromSalesLine, '', true, true)]
    LOCAL PROCEDURE T115_OnAfterInitFromSalesLine(VAR SalesInvLine: Record 113; SalesInvHeader: Record 112; SalesLine: Record 37);
    BEGIN
        //QuoSII.007.begin
        IF (ActivatedQuoSII) THEN BEGIN
            SalesInvLine."QuoSII Situacion Inmueble" := SalesLine."QuoSII Situacion Inmueble";
            SalesInvLine."QuoSII Referencia Catastral" := SalesLine."QuoSII Referencia Catastral";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 325, OnAfterValidateEvent, "VAT Bus. Posting Group", true, true)]
    LOCAL PROCEDURE T325_OnAfterValidateEvent_CountryRegionCode(VAR Rec: Record 325; VAR xRec: Record 325; CurrFieldNo: Integer);
    VAR
        VATBusinessPostingGroup: Record 323;
    BEGIN
        //QuoSII_1.4.02.042.02
        IF (ActivatedQuoSII) THEN BEGIN
            VATBusinessPostingGroup.RESET;
            IF VATBusinessPostingGroup.GET(Rec."VAT Bus. Posting Group") THEN
                Rec."QuoSII Entity" := VATBusinessPostingGroup."QuoSII Entity";
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Funciones de Pages"();
    BEGIN
    END;

    PROCEDURE PG_Ventas_SetFieldNotEditable(VAR Rec: Record 36; VAR SalesInvoiceTypeB: Boolean; VAR SalesCorrectedInvoiceTypeB: Boolean; VAR SalesCrMemoTypeB: Boolean; VAR SalesUEInvTypeB: Boolean; VAR BienesDescriptionB: Boolean; VAR OperatorAddressB: Boolean; VAR FirstTicketNoB: Boolean; VAR LastTicketNoB: Boolean);
    VAR
        CustomerPostingGroup: Record 92;
        UE: Boolean;
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 29/07/21: - QuoSII 1.5y Se a�ade el campo PurchInvoiceTypeB y se mejoran los procesos de bloqueo de campos
        //----------------------------------------------------------------------------------------------------------------------------------
        IF (ActivatedQuoSII) THEN BEGIN
            //Si el grupo registro es de intracomunitarias, marco los campos y establezco los valores
            UE := FALSE;
            IF Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice, Rec."Document Type"::"Return Order", Rec."Document Type"::"Credit Memo"] THEN BEGIN
                IF (CustomerPostingGroup.GET(Rec."Customer Posting Group")) THEN BEGIN
                    IF CustomerPostingGroup."QuoSII Type" = CustomerPostingGroup."QuoSII Type"::OI THEN BEGIN
                        UE := TRUE;

                        IF (Rec."QuoSII Sales UE Inv Type" = '') THEN
                            Rec."QuoSII Sales UE Inv Type" := 'A';
                        IF (Rec."QuoSII Bienes Description" = '') THEN
                            Rec.VALIDATE("QuoSII Bienes Description", 'Operaci�n Intracomunitaria');
                        IF (Rec."QuoSII Operator Address" = '') THEN
                            Rec.VALIDATE("QuoSII Operator Address", Rec."Sell-to Country/Region Code" + Rec."VAT Registration No.");

                        Rec."QuoSII Sales Invoice Type" := '';
                        Rec."QuoSII Sales Cor. Invoice Type" := '';
                        Rec."QuoSII Sales Cr.Memo Type" := '';
                    END;
                END;
            END;

            IF (NOT UE) THEN BEGIN
                Rec."QuoSII Sales UE Inv Type" := '';
                Rec.VALIDATE("QuoSII Bienes Description", '');
                Rec.VALIDATE("QuoSII Operator Address", '');
            END;

            //Si no es rectificativa, eliminamos el dato del tipo de abono
            IF (Rec."QuoSII Sales Cor. Invoice Type" = '') THEN
                Rec."QuoSII Sales Cr.Memo Type" := '';

            //Campos de bloqueos de edici�n
            SalesInvoiceTypeB := (Rec."QuoSII Sales Cor. Invoice Type" = '') AND (Rec."QuoSII Sales UE Inv Type" = '');
            SalesCorrectedInvoiceTypeB := (Rec."QuoSII Sales Invoice Type" = '') AND (Rec."QuoSII Sales UE Inv Type" = '');
            SalesCrMemoTypeB := (Rec."QuoSII Sales Cor. Invoice Type" <> '');
            SalesUEInvTypeB := UE;
            BienesDescriptionB := UE;
            OperatorAddressB := UE;
            LastTicketNoB := (Rec."QuoSII Sales Invoice Type" = 'F4');
            FirstTicketNoB := (Rec."QuoSII Sales Invoice Type" = 'F4');
        END;
    END;

    PROCEDURE PG_Compras_SetFieldNotEditable(VAR Rec: Record 38; VAR PurchInvoiceTypeB: Boolean; VAR PurchCorrectedInvoiceTypeB: Boolean; VAR PurchCrMemoTypeB: Boolean; VAR PurchUEInvTypeB: Boolean; VAR BienesDescriptionB: Boolean; VAR OperatorAddressB: Boolean; VAR FirstTicketNoB: Boolean; VAR LastTicketNoB: Boolean);
    VAR
        VendorPostGroup: Record 93;
        UE: Boolean;
    BEGIN
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 29/07/21: - QuoSII 1.5y Se a�ade el campo PurchInvoiceTypeB y se mejoran los procesos de bloqueo de campos
        //----------------------------------------------------------------------------------------------------------------------------------
        IF (ActivatedQuoSII) THEN BEGIN
            //Si el grupo registro es de intracomunitarias, marco los campos y establezco los valores
            UE := FALSE;
            IF Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice, Rec."Document Type"::"Return Order", Rec."Document Type"::"Credit Memo"] THEN BEGIN
                IF (VendorPostGroup.GET(Rec."Vendor Posting Group")) THEN BEGIN
                    IF VendorPostGroup."QuoSII Type" = VendorPostGroup."QuoSII Type"::OI THEN BEGIN
                        UE := TRUE;

                        IF (Rec."QuoSII Purch. UE Inv Type" = '') THEN
                            Rec."QuoSII Purch. UE Inv Type" := 'A';
                        IF (Rec."QuoSII Bienes Description" = '') THEN
                            Rec.VALIDATE("QuoSII Bienes Description", 'Operaci�n Intracomunitaria');
                        IF (Rec."QuoSII Operator Address" = '') THEN
                            Rec.VALIDATE("QuoSII Operator Address", Rec."Buy-from Country/Region Code" + Rec."VAT Registration No.");

                        Rec."QuoSII Purch. Invoice Type" := '';
                        Rec."QuoSII Purch. Cor. Inv. Type" := '';
                        Rec."QuoSII Purch. Cr.Memo Type" := '';
                    END;
                END;
            END;

            IF (NOT UE) THEN BEGIN
                Rec."QuoSII Purch. UE Inv Type" := '';
                Rec.VALIDATE("QuoSII Bienes Description", '');
                Rec.VALIDATE("QuoSII Operator Address", '');
            END;

            //Si no es rectificativa, eliminamos el dato del tipo de abono
            IF (Rec."QuoSII Purch. Cor. Inv. Type" = '') THEN
                Rec."QuoSII Purch. Cr.Memo Type" := '';

            //Campos de bloqueos de edici�n
            PurchInvoiceTypeB := (Rec."QuoSII Purch. Cor. Inv. Type" = '') AND (Rec."QuoSII Purch. UE Inv Type" = '');
            PurchCorrectedInvoiceTypeB := (Rec."QuoSII Purch. Invoice Type" = '') AND (Rec."QuoSII Purch. UE Inv Type" = '');
            PurchCrMemoTypeB := (Rec."QuoSII Purch. Cor. Inv. Type" <> '');
            PurchUEInvTypeB := UE;
            BienesDescriptionB := UE;
            OperatorAddressB := UE;
            LastTicketNoB := (Rec."QuoSII Purch. Invoice Type" = 'F4');
            FirstTicketNoB := (Rec."QuoSII Purch. Invoice Type" = 'F4');
        END;
    END;

    PROCEDURE P253_SetFieldNotEditable(GenJournalLine: Record 81; VAR SalesCorrectedInvoiceTypeB: Boolean; VAR SalesCrMemoTypeB: Boolean; VAR SalesUEInvTypeB: Boolean; VAR BienesDescriptionB: Boolean; VAR OperatorAddressB: Boolean; VAR FirstTicketNoB: Boolean; VAR LastTicketNoB: Boolean);
    BEGIN
        //QuoSII_1.4.98.999.begin
        IF (ActivatedQuoSII) THEN BEGIN
            IF GenJournalLine."QuoSII Sales Invoice Type QS" <> '' THEN
                SalesCorrectedInvoiceTypeB := FALSE
            ELSE
                SalesCorrectedInvoiceTypeB := TRUE;

            IF GenJournalLine."QuoSII Sales Cor. Invoice Type" <> '' THEN
                SalesCrMemoTypeB := TRUE
            ELSE
                SalesCrMemoTypeB := FALSE;

            IF (GenJournalLine."QuoSII Sales Invoice Type QS" = '') AND (GenJournalLine."QuoSII Sales Cr.Memo Type" = '') THEN
                SalesUEInvTypeB := TRUE
            ELSE
                SalesUEInvTypeB := FALSE;

            IF GenJournalLine."QuoSII Sales UE Inv Type" <> '' THEN BEGIN
                BienesDescriptionB := TRUE;
                OperatorAddressB := TRUE;
            END ELSE BEGIN
                BienesDescriptionB := FALSE;
                OperatorAddressB := FALSE;
            END;

            IF GenJournalLine."QuoSII Sales Invoice Type QS" = 'F4' THEN BEGIN
                LastTicketNoB := TRUE;
                FirstTicketNoB := TRUE;
            END ELSE BEGIN
                LastTicketNoB := FALSE;
                FirstTicketNoB := FALSE;
            END;

            //QuoSII_1.4.98.999.end
        END;
    END;

    PROCEDURE P254_SetFieldNotEditable(GenJournalLine: Record 81; VAR PurchCorrectedInvoiceTypeB: Boolean; VAR PurchCrMemoTypeB: Boolean; VAR PurchUEInvTypeB: Boolean; VAR BienesDescriptionB: Boolean; VAR OperatorAddressB: Boolean; VAR FirstTicketNoB: Boolean; VAR LastTicketNoB: Boolean);
    BEGIN
        //QuoSII_1.4.98.999.begin
        IF (ActivatedQuoSII) THEN BEGIN
            IF GenJournalLine."QuoSII Purch. Invoice Type QS" <> '' THEN
                PurchCorrectedInvoiceTypeB := FALSE
            ELSE
                PurchCorrectedInvoiceTypeB := TRUE;

            IF GenJournalLine."QuoSII Purch. Cor. Inv. Type" <> '' THEN
                PurchCrMemoTypeB := TRUE
            ELSE
                PurchCrMemoTypeB := FALSE;

            IF (GenJournalLine."QuoSII Purch. Invoice Type QS" = '') AND (GenJournalLine."QuoSII Purch. Cr.Memo Type" = '') THEN
                PurchUEInvTypeB := TRUE
            ELSE
                PurchUEInvTypeB := FALSE;

            IF GenJournalLine."QuoSII Purch. UE Inv Type" <> '' THEN BEGIN
                BienesDescriptionB := TRUE;
                OperatorAddressB := TRUE;
            END ELSE BEGIN
                BienesDescriptionB := FALSE;
                OperatorAddressB := FALSE;
            END;

            IF GenJournalLine."QuoSII Purch. Invoice Type QS" = 'F4' THEN BEGIN
                LastTicketNoB := TRUE;
                FirstTicketNoB := TRUE;
            END ELSE BEGIN
                LastTicketNoB := FALSE;
                FirstTicketNoB := FALSE;
            END;

            //QuoSII_1.4.98.999.end
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------ Eventos de Code Units"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitCustLedgEntry, '', true, true)]
    LOCAL PROCEDURE C12_OnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record 21; GenJournalLine: Record 81);
    VAR
        PaymentMethod: Record 289;
        BankAccount: Record 270;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            CustLedgerEntry."QuoSII Sales Invoice Type" := GenJournalLine."QuoSII Sales Invoice Type QS";
            CustLedgerEntry."QuoSII Sales Corrected In.Type" := GenJournalLine."QuoSII Sales Cor. Invoice Type";
            CustLedgerEntry."QuoSII Sales Cr.Memo Type" := GenJournalLine."QuoSII Sales Cr.Memo Type";
            CustLedgerEntry."QuoSII Sales Special Regimen" := GenJournalLine."QuoSII Sales Special Regimen";
            CustLedgerEntry."QuoSII Sales Special Regimen 1" := GenJournalLine."QuoSII Sales Special Regimen 1";
            CustLedgerEntry."QuoSII Sales Special Regimen 2" := GenJournalLine."QuoSII Sales Special Regimen 2";
            CustLedgerEntry."QuoSII Sales UE Inv Type" := GenJournalLine."QuoSII Sales UE Inv Type";
            CustLedgerEntry."QuoSII Bienes Description" := GenJournalLine."QuoSII Bienes Description";
            CustLedgerEntry."QuoSII Operator Address" := GenJournalLine."QuoSII Operator Address";
            CustLedgerEntry."QuoSII UE Country" := GenJournalLine."QuoSII UE Country";
            CustLedgerEntry."QuoSII Last Ticket No." := GenJournalLine."QuoSII Last Ticket No.";
            //QuoSII.T70.BEGIN
            CustLedgerEntry."QuoSII First Ticket No." := GenJournalLine."QuoSII First Ticket No.";
            //QuoSII.T70.END
            CustLedgerEntry."QuoSII Third Party" := GenJournalLine."QuoSII Sales Third Party";
            //QuoSII.007.begin
            CustLedgerEntry."QuoSII Situacion Inmueble" := GenJournalLine."QuoSII Situacion Inmueble";
            CustLedgerEntry."QuoSII Referencia Catastral" := GenJournalLine."QuoSII Referencia Catastral";
            //QuoSII.007.end
            CustLedgerEntry."QuoSII Entity" := GenJournalLine."QuoSII Entity";//QuoSII_1.4.02.042

            IF GenJournalLine."QuoSII Medio Cobro/Pago" = '' THEN BEGIN//QuoSII_1.4.01.034
                PaymentMethod.RESET;
                PaymentMethod.SETRANGE(Code, GenJournalLine."Payment Method Code");
                IF PaymentMethod.FINDFIRST THEN BEGIN
                    CustLedgerEntry."QuoSII Medio Cobro" := PaymentMethod."QuoSII Type SII";//QuoSII_1.4.02.042
                    IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccount.RESET;
                        BankAccount.SETRANGE("No.", PaymentMethod."Bal. Account No.");
                        IF BankAccount.FINDFIRST THEN
                            CustLedgerEntry."QuoSII CuentaMedioCobro" := BankAccount.IBAN;
                    END;
                END ELSE BEGIN
                    CustLedgerEntry."QuoSII Medio Cobro" := GenJournalLine."QuoSII Medio Cobro/Pago";
                    CustLedgerEntry."QuoSII CuentaMedioCobro" := GenJournalLine."QuoSII Cuenta Medio Cobro/Pago";
                END;
            END ELSE BEGIN //QuoSII_1.4.01.034
                CustLedgerEntry."QuoSII Medio Cobro" := GenJournalLine."QuoSII Medio Cobro/Pago"; //QuoSII_1.4.01.034
                CustLedgerEntry."QuoSII CuentaMedioCobro" := GenJournalLine."QuoSII Cuenta Medio Cobro/Pago"; //QuoSII_1.4.01.034
            END; //QuoSII_1.4.01.034
                 //JAV 11/05/22: - QuoSII 1.06.07 Tratamiento del nuevo campo No subir al SII
            CustLedgerEntry."Do not sent to SII" := GenJournalLine."Do not sent to SII";
        END;
        //QuoSII.end
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitVendLedgEntry, '', true, true)]
    LOCAL PROCEDURE C12_OnAfterInitVendLedgEntry(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    VAR
        CompanyInformation: Record 79;
        PaymentMethod: Record 289;
        BankAccount: Record 270;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            VendorLedgerEntry."QuoSII Purch. Invoice Type" := GenJournalLine."QuoSII Purch. Invoice Type QS";
            VendorLedgerEntry."QuoSII Purch. Cr.Memo Type" := GenJournalLine."QuoSII Purch. Cr.Memo Type";
            VendorLedgerEntry."QuoSII Purch. Corr. Inv. Type" := GenJournalLine."QuoSII Purch. Cor. Inv. Type";
            VendorLedgerEntry."QuoSII Purch. Special Reg." := GenJournalLine."QuoSII Purch. Special Regimen";
            VendorLedgerEntry."QuoSII Purch. Special Reg. 1" := GenJournalLine."QuoSII Purch. Special Reg. 1";
            VendorLedgerEntry."QuoSII Purch. Special Reg. 2" := GenJournalLine."QuoSII Purch. Special Reg. 2";
            VendorLedgerEntry."QuoSII Purch. UE Inv Type" := GenJournalLine."QuoSII Purch. UE Inv Type";
            VendorLedgerEntry."QuoSII Bienes Description" := GenJournalLine."QuoSII Bienes Description";
            VendorLedgerEntry."QuoSII Operator Address" := GenJournalLine."QuoSII Operator Address";
            VendorLedgerEntry."QuoSII UE Country" := GenJournalLine."QuoSII UE Country";
            VendorLedgerEntry."QuoSII Last Ticket No." := GenJournalLine."QuoSII Last Ticket No.";
            VendorLedgerEntry."QuoSII Third Party" := GenJournalLine."QuoSII Purch. Third Party";

            //QuoSII_1.3.03.006.begin
            //VendorLedgerEntry."SII Auto Posting Date" := "SII Auto Posting Date";
            //JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
            //VendorLedgerEntry."QuoSII Auto Posting Date" := TODAY; //QuoSII_1.4.01.040
            VendorLedgerEntry."QuoSII Auto Posting Date" := SetAutoPostingDate(0D, GenJournalLine."Document Date");

            CompanyInformation.GET;
            VendorLedgerEntry."QuoSII Use Auto Date" := CompanyInformation."QuoSII Use Auto Date";
            //QuoSII_1.3.03.006.end


            VendorLedgerEntry."QuoSII Entity" := GenJournalLine."QuoSII Entity";//QuoSII_1.4.02.042

            IF GenJournalLine."QuoSII Medio Cobro/Pago" = '' THEN BEGIN//QuoSII_1.4.01.034
                PaymentMethod.RESET;
                PaymentMethod.SETRANGE(Code, GenJournalLine."Payment Method Code");
                IF PaymentMethod.FINDFIRST THEN BEGIN
                    VendorLedgerEntry."QuoSII Medio Pago" := PaymentMethod."QuoSII Type SII";//QuoSII_1.4.02.042
                    IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccount.RESET;
                        BankAccount.SETRANGE("No.", PaymentMethod."Bal. Account No.");
                        IF BankAccount.FINDFIRST THEN
                            VendorLedgerEntry."QuoSII CuentaMedioPago" := BankAccount.IBAN;
                    END;
                END ELSE BEGIN
                    VendorLedgerEntry."QuoSII Medio Pago" := GenJournalLine."QuoSII Medio Cobro/Pago";
                    VendorLedgerEntry."QuoSII CuentaMedioPago" := GenJournalLine."QuoSII Cuenta Medio Cobro/Pago";
                END;
            END ELSE BEGIN //QuoSII_1.4.01.034
                VendorLedgerEntry."QuoSII Medio Pago" := GenJournalLine."QuoSII Medio Cobro/Pago";  //QuoSII_1.4.01.034
                VendorLedgerEntry."QuoSII CuentaMedioPago" := GenJournalLine."QuoSII Cuenta Medio Cobro/Pago";//QuoSII_1.4.01.034
            END; //QuoSII_1.4.01.034

            //JAV 11/05/22: - QuoSII 1.06.07 Tratamiento del nuevo campo No subir al SII en movimientos
            VendorLedgerEntry."Do not sent to SII" := GenJournalLine."Do not sent to SII";

        END;
        //QuoSII.end
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitGLEntry, '', true, true)]
    LOCAL PROCEDURE C12_OnAfterInitGLEntry(VAR GLEntry: Record 17; GenJournalLine: Record 81);
    BEGIN
        IF (ActivatedQuoSII) THEN BEGIN
            GLEntry."QiuoSII Entity" := GenJournalLine."QuoSII Entity";//QuoSII_1.4.02.042
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE C80_OnBeforePostSalesDoc(VAR Sender: Codeunit 80; VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        CompanyInformation: Record 79;
        CustPostingGr: Record 92;
        Text7174331: TextConst ENU = 'No ha informado el campo %1 o el campo %2, obligatorio para documentos SII.', ESP = 'No ha informado el campo %1 o el campo %2, obligatorio para facturas SII.';
        Text7174332: TextConst ENU = 'No ha informado alguno de los siguientes campos %1, %2 o %3, obligatorio para documentos SII.', ESP = 'No ha informado alguno de los siguientes campos %1, %2 o %3, obligatorio para facturas SII.';
        Text7174333: TextConst ENU = 'El campo %1 es obligatorio cuando se informa en el campo %2 uno de los siguientes valores: %3,%4,%5,%6 o %7.', ESP = 'El campo %1 es obligatorio cuando se informa en el campo %2 uno de los siguientes valores: %3,%4,%5,%6 o %7.';
        Text7174334: TextConst ENU = 'No ha informado el campo %1, obligatorio para documentos SII.', ESP = 'No ha informado el campo %1 o el campo %2, obligatorio para facturas SII.';
        Text7174335: TextConst ESP = 'No ha informado el campo %1 o el campo %2, obligatorio para documentos SII de %3 %4.';
    BEGIN
        //QuoSII.beign
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII_1.4.02.042.begin
            //QuoSII1.4.begin
            CompanyInformation.GET;
            IF (CompanyInformation."QuoSII Inclusion Date" <> 0D) AND (SalesHeader."Posting Date" < CompanyInformation."QuoSII Inclusion Date") THEN BEGIN
                SalesHeader.TESTFIELD("QuoSII Sales Special Regimen", '16');
            END;
            //QuoSII1.4.end

            CustPostingGr.RESET;
            CustPostingGr.SETRANGE(Code, SalesHeader."Customer Posting Group");
            IF CustPostingGr.FINDFIRST THEN BEGIN
                IF CustPostingGr."QuoSII Type" = CustPostingGr."QuoSII Type"::OI THEN BEGIN
                    IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader.Invoice)) OR
                        (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") AND (SalesHeader.Invoice)) THEN
                        IF (SalesHeader."QuoSII Bienes Description" = '') OR (SalesHeader."QuoSII Operator Address" = '') OR (SalesHeader."QuoSII Sales UE Inv Type" = '') THEN
                            ERROR(STRSUBSTNO(Text7174332, SalesHeader.FIELDCAPTION("QuoSII Bienes Description"), SalesHeader.FIELDCAPTION("QuoSII Sales UE Inv Type"), SalesHeader.FIELDCAPTION("QuoSII Operator Address")));
                END ELSE
                    IF CustPostingGr."QuoSII Type" = CustPostingGr."QuoSII Type"::LF THEN
                        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader.Invoice)) OR
                            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") AND (SalesHeader.Invoice)) THEN BEGIN
                            IF (SalesHeader."QuoSII Sales Special Regimen" = '') THEN
                                //>>PSM 22/08/21
                                ERROR(STRSUBSTNO(Text7174334, SalesHeader.FIELDCAPTION(SalesHeader."QuoSII Sales Invoice Type"), SalesHeader.FIELDCAPTION("QuoSII Sales Special Regimen")))
                            //ERROR(STRSUBSTNO(Text7174334,SalesHeader.FIELDCAPTION("QuoSII Sales Special Regimen")))
                            //<<PSM 22/08/21
                            ELSE BEGIN
                                IF (SalesHeader."QuoSII Sales Invoice Type" = '') AND
                                    (SalesHeader."QuoSII Sales Cor. Invoice Type" = '')
                                THEN
                                    ERROR(STRSUBSTNO(Text7174331, SalesHeader.FIELDCAPTION("QuoSII Sales Invoice Type"), SalesHeader.FIELDCAPTION("QuoSII Sales Cor. Invoice Type")))
                                ELSE BEGIN
                                    IF (SalesHeader."QuoSII Sales Invoice Type" = '') AND (SalesHeader."QuoSII Sales Cor. Invoice Type" <> '') AND (SalesHeader."QuoSII Sales Cr.Memo Type" = '') THEN
                                        ERROR(STRSUBSTNO(Text7174333, SalesHeader.FIELDCAPTION("QuoSII Sales Cr.Memo Type"), SalesHeader.FIELDCAPTION("QuoSII Sales Cor. Invoice Type"), 'R1', 'R2', 'R3', 'R4', 'R5'));
                                END;
                            END;
                            //>>PSM 22/08/21
                            IF (SalesHeader."QuoSII Sales Invoice Type" = 'F4') AND ((SalesHeader."QuoSII First Ticket No." = '') OR (SalesHeader."QuoSII Last Ticket No." = '')) THEN
                                ERROR(Text7174335, SalesHeader.FIELDCAPTION("QuoSII First Ticket No."), SalesHeader.FIELDCAPTION("QuoSII Last Ticket No."),
                                      SalesHeader.FIELDCAPTION("QuoSII Sales Invoice Type"), 'F4');
                            //<<PSM 22/08/21
                        END;
            END;
            //QuoSII_1.4.02.042.end

            CustPostingGr.RESET;
            //QuoSII.end
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostCustomerEntry, '', true, true)]
    LOCAL PROCEDURE C80_OnBeforePostCustomerEntry(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        CountryRegion: Record 9;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            GenJnlLine."QuoSII Sales Invoice Type QS" := SalesHeader."QuoSII Sales Invoice Type";
            GenJnlLine."QuoSII Sales Cor. Invoice Type" := SalesHeader."QuoSII Sales Cor. Invoice Type";
            GenJnlLine."QuoSII Sales Cr.Memo Type" := SalesHeader."QuoSII Sales Cr.Memo Type";
            GenJnlLine."QuoSII Sales Special Regimen" := SalesHeader."QuoSII Sales Special Regimen";
            GenJnlLine."QuoSII Sales Special Regimen 1" := SalesHeader."QuoSII Sales Special Regimen 1";
            GenJnlLine."QuoSII Sales Special Regimen 2" := SalesHeader."QuoSII Sales Special Regimen 2";
            GenJnlLine."QuoSII Sales UE Inv Type" := SalesHeader."QuoSII Sales UE Inv Type";
            GenJnlLine."QuoSII Bienes Description" := SalesHeader."QuoSII Bienes Description";
            GenJnlLine."QuoSII Operator Address" := SalesHeader."QuoSII Operator Address";
            //QuoSII.006.begin
            CountryRegion.RESET;
            CountryRegion.GET(SalesHeader."Sell-to Country/Region Code");
            GenJnlLine."QuoSII UE Country" := CountryRegion."EU Country/Region Code";
            //QuoSII.006.end
            GenJnlLine."QuoSII Last Ticket No." := SalesHeader."QuoSII Last Ticket No.";
            //QuoSII.T70.BEGIN
            GenJnlLine."QuoSII First Ticket No." := SalesHeader."QuoSII First Ticket No.";
            //QuoSII.T70.END
            GenJnlLine."QuoSII Sales Third Party" := SalesHeader."QuoSII Third Party";
            GenJnlLine."QuoSII Entity" := SalesHeader."QuoSII Entity";//QuoSII_1.4.02.042//QuoSII_1.4.02.042.03

            //QuoSII_1.4.01.034.begin
            /*{---
                    PaymentMethod.RESET;
                    PaymentMethod.SETRANGE(Code,"Payment Method Code");
                    IF PaymentMethod.FINDFIRST THEN BEGIN
                      GenJnlLine2."Medio Cobro/Pago" := PaymentMethod."Type SII";//QuoSII_1.4.02.042
                      IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccount.RESET;
                        BankAccount.SETRANGE("No.",PaymentMethod."Bal. Account No.");
                        IF BankAccount.FINDFIRST THEN
                          GenJnlLine2."Cuenta Medio Cobro/Pago" := BankAccount.IBAN;
                      END;
                    END;
                    ---}*/
            //QuoSII_1.4.01.034.end
            //QuoSII.end
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostBalancingEntry, '', true, true)]
    LOCAL PROCEDURE C80_OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        CountryRegion: Record 9;
        PaymentMethod: Record 289;
        BankAccount: Record 270;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            GenJnlLine."QuoSII Sales Invoice Type QS" := SalesHeader."QuoSII Sales Invoice Type";
            GenJnlLine."QuoSII Sales Cor. Invoice Type" := SalesHeader."QuoSII Sales Cor. Invoice Type";
            GenJnlLine."QuoSII Sales Cr.Memo Type" := SalesHeader."QuoSII Sales Cr.Memo Type";
            GenJnlLine."QuoSII Sales Special Regimen" := SalesHeader."QuoSII Sales Special Regimen";
            GenJnlLine."QuoSII Sales Special Regimen 1" := SalesHeader."QuoSII Sales Special Regimen 1";
            GenJnlLine."QuoSII Sales Special Regimen 2" := SalesHeader."QuoSII Sales Special Regimen 2";
            GenJnlLine."QuoSII Sales UE Inv Type" := SalesHeader."QuoSII Sales UE Inv Type";
            GenJnlLine."QuoSII Bienes Description" := SalesHeader."QuoSII Bienes Description";
            GenJnlLine."QuoSII Operator Address" := SalesHeader."QuoSII Operator Address";
            //QuoSII.006.begin
            CountryRegion.RESET;
            CountryRegion.GET(SalesHeader."Sell-to Country/Region Code");
            GenJnlLine."QuoSII UE Country" := CountryRegion."EU Country/Region Code";
            //QuoSII.006.end
            GenJnlLine."QuoSII Last Ticket No." := SalesHeader."QuoSII Last Ticket No.";
            //QuoSII.T70.BEGIN
            GenJnlLine."QuoSII First Ticket No." := SalesHeader."QuoSII First Ticket No.";
            //QuoSII.T70.END
            GenJnlLine."QuoSII Sales Third Party" := SalesHeader."QuoSII Third Party";
            GenJnlLine."QuoSII Entity" := SalesHeader."QuoSII Entity";//QuoSII_1.4.02.042//QuoSII_1.4.02.042.03

            PaymentMethod.RESET;
            PaymentMethod.SETRANGE(Code, SalesHeader."Payment Method Code");
            IF PaymentMethod.FINDFIRST THEN BEGIN
                GenJnlLine."QuoSII Medio Cobro/Pago" := PaymentMethod."QuoSII Type SII";//QuoSII_1.4.02.042
                IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account" THEN BEGIN
                    BankAccount.RESET;
                    BankAccount.SETRANGE("No.", PaymentMethod."Bal. Account No.");
                    IF BankAccount.FINDFIRST THEN
                        GenJnlLine."QuoSII Cuenta Medio Cobro/Pago" := BankAccount.IBAN;
                END;
            END;
            //QuoSII.end

        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforeSalesInvHeaderInsert, '', true, true)]
    LOCAL PROCEDURE C80_OnBeforeSalesInvHeaderInsert(VAR SalesInvHeader: Record 112; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            SalesInvHeader."QuoSII Sales Invoice Type QS" := SalesHeader."QuoSII Sales Invoice Type";
            //QuoSII.2_4.begin
            SalesInvHeader."QuoSII Sales Cr.Memo Type" := SalesHeader."QuoSII Sales Cr.Memo Type";
            SalesInvHeader."QuoSII Sales Corr. Inv. Type" := SalesHeader."QuoSII Sales Cor. Invoice Type";
            //QuoSII.2_4.end
            SalesInvHeader."QuoSII Sales Special Regimen" := SalesHeader."QuoSII Sales Special Regimen";
            SalesInvHeader."QuoSII Sales Special Regimen 1" := SalesHeader."QuoSII Sales Special Regimen 1";
            SalesInvHeader."QuoSII Sales Special Regimen 2" := SalesHeader."QuoSII Sales Special Regimen 2";
            SalesInvHeader."QuoSII Sales UE Inv Type" := SalesHeader."QuoSII Sales UE Inv Type";
            SalesInvHeader."QuoSII Bienes Description" := SalesHeader."QuoSII Bienes Description";
            SalesInvHeader."QuoSII Operator Address" := SalesHeader."QuoSII Operator Address";
            SalesInvHeader."QuoSII Last Ticket No." := SalesHeader."QuoSII Last Ticket No.";
            //QuoSII.T70.BEGIN
            SalesInvHeader."QuoSII First Ticket No." := SalesHeader."QuoSII First Ticket No.";
            //QuoSII.T70.END
            SalesInvHeader."QuoSII Third Party" := SalesHeader."QuoSII Third Party";
            SalesInvHeader."QuoSII Entity" := SalesHeader."QuoSII Entity";//QuoSII_1.4.02.042
                                                                          //QuoSII.end
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforeSalesCrMemoHeaderInsert, '', true, true)]
    LOCAL PROCEDURE C80_OnBeforeSalesCrMemoHeaderInsert(VAR SalesCrMemoHeader: Record 114; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            SalesCrMemoHeader."QuoSII Sales Cor. Inv. Type" := SalesHeader."QuoSII Sales Cor. Invoice Type";
            SalesCrMemoHeader."QuoSII Sales Cr.Memo Type" := SalesHeader."QuoSII Sales Cr.Memo Type";
            //QuoSII.2_4.begin
            SalesCrMemoHeader."QuoSII Sales Invoice Type QS" := SalesHeader."QuoSII Sales Invoice Type";
            //QuoSII.2_4.end
            SalesCrMemoHeader."QuoSII Sales Special Regimen" := SalesHeader."QuoSII Sales Special Regimen";
            SalesCrMemoHeader."QuoSII Sales Special Regimen 1" := SalesHeader."QuoSII Sales Special Regimen 1";
            SalesCrMemoHeader."QuoSII Sales Special Regimen 2" := SalesHeader."QuoSII Sales Special Regimen 2";
            SalesCrMemoHeader."QuoSII Sales UE Inv Type" := SalesHeader."QuoSII Sales UE Inv Type";
            SalesCrMemoHeader."QuoSII Bienes Description" := SalesHeader."QuoSII Bienes Description";
            SalesCrMemoHeader."QuoSII Operator Address" := SalesHeader."QuoSII Operator Address";
            SalesCrMemoHeader."QuoSII Last Ticket No." := SalesHeader."QuoSII Last Ticket No.";
            //QuoSII.T70.BEGIN
            SalesCrMemoHeader."QuoSII First Ticket No." := SalesHeader."QuoSII First Ticket No.";
            //QuoSII.T70.END
            SalesCrMemoHeader."QuoSII Third Party" := SalesHeader."QuoSII Third Party";
            SalesCrMemoHeader."QuoSII Entity" := SalesHeader."QuoSII Entity";//QuoSII_1.4.02.042
                                                                             //QuoSII.end

        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE C90_OnBeforePostSalesDoc(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        CompanyInformation: Record 79;
        VendPostingGr: Record 93;
        Text7174331: TextConst ENU = 'No ha informado el campo %1 o el campo %2, obligatorio para documentos SII.', ESP = 'No ha informado el campo %1 o el campo %2, obligatorio para facturas SII.';
        Text7174332: TextConst ENU = 'No ha informado alguno de los siguientes campos %1, %2 o %3, obligatorio para documentos SII.', ESP = 'No ha informado alguno de los siguientes campos %1, %2 o %3, obligatorio para facturas SII.';
        Text7174333: TextConst ENU = 'El campo %1 es obligatorio cuando se informa en el campo %2 uno de los siguientes valores: %3,%4,%5,%6 o %7.', ESP = 'El campo %1 es obligatorio cuando se informa en el campo %2 uno de los siguientes valores: %3,%4,%5,%6 o %7.';
        Text7174334: TextConst ENU = 'No ha informado el campo %1, obligatorio para documentos SII.', ESP = 'No ha informado el campo %1 o el campo %2, obligatorio para facturas SII.';
        Text7174335: TextConst ESP = 'No ha informado el campo %1 o el campo %2, obligatorio para documentos SII de %3 %4.';
    BEGIN
        //QuoSII.beign
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            //QuoSII1.4.begin
            //QuoSII_1.4.02.042.begin
            CompanyInformation.GET;
            IF (CompanyInformation."QuoSII Inclusion Date" <> 0D) AND (PurchaseHeader."Posting Date" < CompanyInformation."QuoSII Inclusion Date") THEN BEGIN
                PurchaseHeader.TESTFIELD("QuoSII Purch Special Regimen", '14');
            END;
            //QuoSII1.4.end
            VendPostingGr.RESET;
            VendPostingGr.SETRANGE(Code, PurchaseHeader."Vendor Posting Group");
            IF VendPostingGr.FINDFIRST THEN BEGIN
                IF VendPostingGr."QuoSII Type" = VendPostingGr."QuoSII Type"::OI THEN BEGIN
                    IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) OR ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) AND (PurchaseHeader.Invoice)) OR
                        (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") OR ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") AND (PurchaseHeader.Invoice))
                    THEN
                        IF (PurchaseHeader."QuoSII Bienes Description" = '') OR (PurchaseHeader."QuoSII Operator Address" = '') OR (PurchaseHeader."QuoSII Purch. UE Inv Type" = '') THEN
                            ERROR(STRSUBSTNO(Text7174332, PurchaseHeader.FIELDCAPTION("QuoSII Bienes Description"), PurchaseHeader.FIELDCAPTION("QuoSII Purch. UE Inv Type"), PurchaseHeader.FIELDCAPTION("QuoSII Operator Address")));
                END ELSE
                    IF VendPostingGr."QuoSII Type" = VendPostingGr."QuoSII Type"::LF THEN
                        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) OR ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) AND (PurchaseHeader.Invoice)) OR
                            (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") OR ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") AND (PurchaseHeader.Invoice))
                        THEN BEGIN
                            IF (PurchaseHeader."QuoSII Purch Special Regimen" = '') THEN
                                //>>PSM 22/08/21
                                ERROR(STRSUBSTNO(Text7174334, PurchaseHeader.FIELDCAPTION(PurchaseHeader."QuoSII Purch. Invoice Type"), PurchaseHeader.FIELDCAPTION("QuoSII Purch Special Regimen")))
                            ELSE BEGIN
                                IF (PurchaseHeader."QuoSII Purch. Invoice Type" = '') AND (PurchaseHeader."QuoSII Purch. Cor. Inv. Type" = '')
                                THEN
                                    ERROR(STRSUBSTNO(Text7174331, PurchaseHeader.FIELDCAPTION("QuoSII Purch. Invoice Type"), PurchaseHeader.FIELDCAPTION("QuoSII Purch. Cor. Inv. Type")))
                                ELSE BEGIN
                                    IF (PurchaseHeader."QuoSII Purch. Invoice Type" = '') AND (PurchaseHeader."QuoSII Purch. Cor. Inv. Type" <> '') AND (PurchaseHeader."QuoSII Purch. Cr.Memo Type" = '') THEN
                                        ERROR(STRSUBSTNO(Text7174333, PurchaseHeader.FIELDCAPTION("QuoSII Purch. Cr.Memo Type"), PurchaseHeader.FIELDCAPTION("QuoSII Purch. Cor. Inv. Type"), 'R1', 'R2', 'R3', 'R4', 'R5'));
                                END;
                            END;
                            //>>PSM 22/08/21
                            IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) OR
                                ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) AND (PurchaseHeader.Invoice)) THEN
                                IF (PurchaseHeader."QuoSII Purch. Invoice Type" = 'F4') AND ((PurchaseHeader."Vendor Invoice No." = '') OR (PurchaseHeader."QuoSII Last Ticket No." = '')) THEN
                                    ERROR(Text7174335, PurchaseHeader.FIELDCAPTION("Vendor Invoice No."), PurchaseHeader.FIELDCAPTION("QuoSII Last Ticket No."),
                                          PurchaseHeader.FIELDCAPTION("QuoSII Purch. Invoice Type"), 'F4');
                            IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") OR
                                ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order") AND (PurchaseHeader.Invoice)) THEN
                                IF (PurchaseHeader."QuoSII Purch. Invoice Type" = 'F4') AND ((PurchaseHeader."Vendor Cr. Memo No." = '') OR (PurchaseHeader."QuoSII Last Ticket No." = '')) THEN
                                    ERROR(Text7174335, PurchaseHeader.FIELDCAPTION("Vendor Cr. Memo No."), PurchaseHeader.FIELDCAPTION("QuoSII Last Ticket No."),
                                          PurchaseHeader.FIELDCAPTION("QuoSII Purch. Invoice Type"), 'F4');
                            //<<PSM 22/08/21
                        END;
            END;
            VendPostingGr.RESET;
            //QuoSII_1.4.02.042.end
            //QuoSII.end


        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostVendorEntry, '', true, true)]
    LOCAL PROCEDURE C90_OnBeforePostVendorEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        CountryRegion: Record 9;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin    1702
            GenJnlLine."QuoSII Purch. Invoice Type QS" := PurchHeader."QuoSII Purch. Invoice Type";
            //QuoSII.2_4.begin
            GenJnlLine."QuoSII Purch. Cr.Memo Type" := PurchHeader."QuoSII Purch. Cr.Memo Type";
            //QuoSII.2_4.end
            GenJnlLine."QuoSII Purch. Cor. Inv. Type" := PurchHeader."QuoSII Purch. Cor. Inv. Type";
            GenJnlLine."QuoSII Purch. Special Regimen" := PurchHeader."QuoSII Purch Special Regimen";
            GenJnlLine."QuoSII Purch. Special Reg. 1" := PurchHeader."QuoSII Purch Special Regimen 1";
            GenJnlLine."QuoSII Purch. Special Reg. 2" := PurchHeader."QuoSII Purch Special Regimen 2";
            GenJnlLine."QuoSII Bienes Description" := PurchHeader."QuoSII Bienes Description";
            GenJnlLine."QuoSII Operator Address" := PurchHeader."QuoSII Operator Address";
            GenJnlLine."QuoSII Purch. UE Inv Type" := PurchHeader."QuoSII Purch. UE Inv Type";
            //QuoSII.006.begin
            //1701
            IF GenJnlLine."VAT Registration No." <> '' THEN BEGIN
                CountryRegion.RESET;
                CountryRegion.GET(PurchHeader."Buy-from Country/Region Code");
                GenJnlLine."QuoSII UE Country" := CountryRegion."EU Country/Region Code";
            END;
            //QuoSII.006.end
            GenJnlLine."QuoSII Last Ticket No." := PurchHeader."QuoSII Last Ticket No.";
            GenJnlLine."QuoSII Purch. Third Party" := PurchHeader."QuoSII Third Party";
            //GenJnlLine2."SII Auto Posting Date" := PurchHeader."SII Auto Posting Date"; //QuoSII_1.3.03.006

            //JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
            //GenJnlLine."QuoSII Auto Posting Date" := TODAY; //QuoSII_1.4.01.40
            GenJnlLine."QuoSII Auto Posting Date" := SetAutoPostingDate(0D, GenJnlLine."Document Date");

            GenJnlLine."QuoSII Entity" := PurchHeader."QuoSII Entity";//QuoSII_1.4.02.042//QuoSII_1.4.02.042.03
                                                                      //QuoSII_1.4.01.034.end
                                                                      //QuoSII.end    1702
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostBalancingEntry, '', true, true)]
    LOCAL PROCEDURE C90_OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        CountryRegion: Record 9;
        PaymentMethod: Record 289;
        BankAccount: Record 270;
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            GenJnlLine."QuoSII Purch. Invoice Type QS" := PurchHeader."QuoSII Purch. Invoice Type";
            //QuoSII.2_4.begin
            GenJnlLine."QuoSII Purch. Cr.Memo Type" := PurchHeader."QuoSII Purch. Cr.Memo Type";
            //QuoSII.2_4.end
            GenJnlLine."QuoSII Purch. Cor. Inv. Type" := PurchHeader."QuoSII Purch. Cor. Inv. Type";
            GenJnlLine."QuoSII Purch. Cr.Memo Type" := PurchHeader."QuoSII Purch. Cr.Memo Type";
            GenJnlLine."QuoSII Purch. Special Regimen" := PurchHeader."QuoSII Purch Special Regimen";
            GenJnlLine."QuoSII Purch. Special Reg. 1" := PurchHeader."QuoSII Purch Special Regimen 1";
            GenJnlLine."QuoSII Purch. Special Reg. 2" := PurchHeader."QuoSII Purch Special Regimen 2";
            GenJnlLine."QuoSII Bienes Description" := PurchHeader."QuoSII Bienes Description";
            GenJnlLine."QuoSII Operator Address" := PurchHeader."QuoSII Operator Address";
            GenJnlLine."QuoSII Purch. UE Inv Type" := PurchHeader."QuoSII Purch. UE Inv Type";
            //QuoSII.006.begin
            CountryRegion.RESET;
            CountryRegion.GET(PurchHeader."Buy-from Country/Region Code");
            GenJnlLine."QuoSII UE Country" := CountryRegion."EU Country/Region Code";
            //QuoSII.006.end
            GenJnlLine."QuoSII Purch. UE Inv Type" := PurchHeader."QuoSII Purch. UE Inv Type";
            GenJnlLine."QuoSII Last Ticket No." := PurchHeader."QuoSII Last Ticket No.";
            GenJnlLine."QuoSII Purch. Third Party" := PurchHeader."QuoSII Third Party";

            //GenJnlLine."SII Auto Posting Date" := PurchHeader."SII Auto Posting Date"; //QuoSII_1.3.03.006
            //JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
            //GenJnlLine."QuoSII Auto Posting Date" := TODAY; //QuoSII_1.4.01.40
            GenJnlLine."QuoSII Auto Posting Date" := SetAutoPostingDate(0D, PurchHeader."Document Date");

            GenJnlLine."QuoSII Entity" := PurchHeader."QuoSII Entity";//QuoSII_1.4.02.042//QuoSII_1.4.02.042.03

            //QuoSII_1.4.01.034.begin
            /*{---
                    PaymentMethod.RESET;
                    PaymentMethod.SETRANGE(Code,GenJnlLine."Payment Method Code");
                    IF PaymentMethod.FINDFIRST THEN BEGIN
                      GenJnlLine."Medio Cobro/Pago" := PaymentMethod."Type SII";//QuoSII_1.4.02.042
                      IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccount.RESET;
                        BankAccount.SETRANGE("No.",PaymentMethod."Bal. Account No.");
                        IF BankAccount.FINDFIRST THEN
                          GenJnlLine."Cuenta Medio Cobro/Pago" := BankAccount.IBAN;
                      END;
                    END;
                    ---}*/
            //QuoSII_1.4.01.034.end
            //QuoSII.end
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePurchInvHeaderInsert, '', true, true)]
    LOCAL PROCEDURE C90_OnBeforePurchInvHeaderInsert(VAR PurchInvHeader: Record 122; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            PurchInvHeader."QuoSII Purch. Invoice Type" := PurchHeader."QuoSII Purch. Invoice Type";
            //QuoSII.2_4.begin
            PurchInvHeader."QuoSII Purch. Cor. Inv. Type" := PurchHeader."QuoSII Purch. Cor. Inv. Type";
            PurchInvHeader."QuoSII Purch. Cr.Memo Type" := PurchHeader."QuoSII Purch. Cr.Memo Type";
            //QuoSII.2_4.end
            PurchInvHeader."QuoSII Purch Special Regimen" := PurchHeader."QuoSII Purch Special Regimen";
            PurchInvHeader."QuoSII Purch Special Regimen 1" := PurchHeader."QuoSII Purch Special Regimen 1";
            PurchInvHeader."QuoSII Purch Special Regimen 2" := PurchHeader."QuoSII Purch Special Regimen 2";
            PurchInvHeader."QuoSII Purch. UE Inv Type" := PurchHeader."QuoSII Purch. UE Inv Type";
            PurchInvHeader."QuoSII Bienes Description" := PurchHeader."QuoSII Bienes Description";
            PurchInvHeader."QuoSII Operator Address" := PurchHeader."QuoSII Operator Address";
            PurchInvHeader."QuoSII Last Ticket No." := PurchHeader."QuoSII Last Ticket No.";
            PurchInvHeader."QuoSII Third Party" := PurchHeader."QuoSII Third Party";

            //PurchInvHeader."SII Auto Posting Date" := PurchHeader."SII Auto Posting Date"; //QuoSII_1.3.03.006
            //JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
            //PurchInvHeader."QuoSII Auto Posting Date" := TODAY; //QuoSII_1.4.01.040
            PurchInvHeader."QuoSII Auto Posting Date" := SetAutoPostingDate(0D, PurchHeader."Document Date");

            PurchInvHeader."QuoSII Entity" := PurchHeader."QuoSII Entity";//QuoSII_1.4.02.042
                                                                          //QuoSII.end
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePurchCrMemoHeaderInsert, '', true, true)]
    LOCAL PROCEDURE C90_OnBeforePurchCrMemoHeaderInsert(VAR PurchCrMemoHdr: Record 124; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
        //QuoSII.begin
        IF (ActivatedQuoSII) THEN BEGIN
            //QuoSII.begin
            //QuoSII.2_4.begin
            PurchCrMemoHdr."QuoSII Purch. Invoice Type" := PurchHeader."QuoSII Purch. Invoice Type";
            //QuoSII.2_4.end
            PurchCrMemoHdr."QuoSII Purch. Cr.Memo Type" := PurchHeader."QuoSII Purch. Cr.Memo Type";
            PurchCrMemoHdr."QuoSII Purch. Cor. Inv. Type" := PurchHeader."QuoSII Purch. Cor. Inv. Type";

            //JAV 08/06/22: - QuoSII 1.06.09 Se cambian variables err�neas
            //PurchCrMemoHdr."QuoSII Purch Special Regimen 2" := PurchHeader."QuoSII Purch Special Regimen";
            //PurchCrMemoHdr."QuoSII Purch. UE Inv Type" := PurchHeader."QuoSII Purch Special Regimen 1";
            //PurchCrMemoHdr."QuoSII Purch Special Regimen 1" := PurchHeader."QuoSII Purch Special Regimen 2";
            //PurchCrMemoHdr."QuoSII Purch Special Regimen" := PurchHeader."QuoSII Purch. UE Inv Type";
            PurchCrMemoHdr."QuoSII Purch Special Regimen" := PurchHeader."QuoSII Purch Special Regimen";
            PurchCrMemoHdr."QuoSII Purch Special Regimen 1" := PurchHeader."QuoSII Purch Special Regimen 1";
            PurchCrMemoHdr."QuoSII Purch Special Regimen 2" := PurchHeader."QuoSII Purch Special Regimen 2";
            PurchCrMemoHdr."QuoSII Purch. UE Inv Type" := PurchHeader."QuoSII Purch. UE Inv Type";

            PurchCrMemoHdr."QuoSII Bienes Description" := PurchHeader."QuoSII Bienes Description";
            PurchCrMemoHdr."QuoSII Operator Address" := PurchHeader."QuoSII Operator Address";
            PurchCrMemoHdr."QuoSII Last Ticket No." := PurchHeader."QuoSII Last Ticket No.";
            PurchCrMemoHdr."QuoSII Third Party" := PurchHeader."QuoSII Third Party";

            //PurchCrMemoHdr."SII Auto Posting Date" := PurchHeader."SII Auto Posting Date"; //QuoSII_1.3.03.006
            //JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
            //PurchCrMemoHdr."QuoSII Auto Posting Date" := TODAY; //QuoSII_1.4.01.040
            PurchCrMemoHdr."QuoSII Auto Posting Date" := SetAutoPostingDate(0D, PurchHeader."Document Date");

            PurchCrMemoHdr."QuoSII Entity" := PurchHeader."QuoSII Entity";//QuoSII_1.4.02.042//QuoSII_1.4.02.042.03
                                                                          //QuoSII.end
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7174331, OnBeforeProcessShipment, '', true, true)]
    LOCAL PROCEDURE C7174332_OnBeforeProcessShipment();
    VAR
        CompanyInformation: Record 79;
        NFile: Text;
    BEGIN
        //JAV 23/07/20: Eliminar el fichero de LOG antes de procesar
        CompanyInformation.GET;
        NFile := DELCHR(CompanyInformation."QuoSII Export SII Path", '>', '\') + '\Errores.log';
        IF FILE.ERASE(NFile) THEN;
    END;

    [EventSubscriber(ObjectType::Codeunit, 7174331, OnAfterProcessShipment, '', true, true)]
    LOCAL PROCEDURE C7174332_OnAfterProcessShipment();
    VAR
        CompanyInformation: Record 79;
        NFile: Text;
        tFile: File;
        tInStream: InStream;
        txt: Text;
        txt2: Text;
        i: Integer;
        TXTINICIO: TextConst ESP = '''.';
        TXTFIN: TextConst ESP = 'Traza:';
    BEGIN
        //JAV 23/07/20: Ver si hay errores en el fichero de LOG despu�s de procesar
        IF GUIALLOWED THEN BEGIN
            CompanyInformation.GET;
            NFile := DELCHR(CompanyInformation."QuoSII Export SII Path", '>', '\') + '\Errores.log';
            IF (FILE.EXISTS(NFile)) THEN BEGIN
                txt := '';
                tFile.TEXTMODE(TRUE);
                tFile.WRITEMODE(FALSE);
                tFile.OPEN(NFile, TEXTENCODING::Windows);
                tFile.CREATEINSTREAM(tInStream);
                WHILE NOT (tInStream.EOS) DO BEGIN
                    tInStream.READTEXT(txt2);
                    txt += txt2;
                END;
                tFile.CLOSE();
                i := STRPOS(txt, TXTINICIO);
                txt := COPYSTR(txt, i + 2);
                i := STRPOS(txt, TXTFIN);
                txt := COPYSTR(txt, 1, i - 1);
                txt := DELCHR(txt, '<>', ' ');
                IF (txt <> 'No existe el documento SII') THEN
                    MESSAGE('El proceso ha terminado con el mensaje: ' + txt);
            END;
        END;
    END;

    LOCAL PROCEDURE SetAutoPostingDate(AutoPostingDate: Date; DocumentDate: Date): Date;
    VAR
        NewAutoPostingDate: Date;
    BEGIN
        //JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
        IF (AutoPostingDate = 0D) THEN
            //Q19407-
            NewAutoPostingDate := WORKDATE;
        //NewAutoPostingDate := TODAY;
        //Q19407+

        IF (NewAutoPostingDate < DocumentDate) THEN
            NewAutoPostingDate := DocumentDate;

        EXIT(NewAutoPostingDate);
    END;

    LOCAL PROCEDURE "------------------------------------------------------ CU 87 y 97"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 87, OnBeforeInsertSalesOrderHeader, '', true, true)]
    LOCAL PROCEDURE CU87_OnBeforeInsertSalesOrderHeader(VAR SalesOrderHeader: Record 36; BlanketOrderSalesHeader: Record 36);
    VAR
        tmpSalesHeader: Record 36;
    BEGIN
        //JAV 09/02/22: - QuoSII 1.06.02 Al crear un pedido de venta desde un pedido abierto, poner los campos del SII
        tmpSalesHeader := SalesOrderHeader;
        T36_OnAfterValidateEvent_SelltoCustomerNo(SalesOrderHeader, tmpSalesHeader, 0);
    END;

    [EventSubscriber(ObjectType::Codeunit, 97, OnBeforeInsertPurchOrderHeader, '', true, true)]
    LOCAL PROCEDURE CU97_OnBeforeInsertPurchOrderHeader(VAR PurchOrderHeader: Record 38; BlanketOrderPurchHeader: Record 38);
    VAR
        tmpPurchaseHeader: Record 38;
    BEGIN
        //JAV 09/02/22: - QuoSII 1.06.02 Al crear un pedido de compra desde un pedido abierto, poner los campos del SII
        tmpPurchaseHeader := PurchOrderHeader;
        T38_OnAfterValidateEvent_BuyfromVendorNo(PurchOrderHeader, tmpPurchaseHeader, 0);
    END;

    LOCAL PROCEDURE "PG 1351,10765,10766,10767 Cambios en documentos registrados"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 1351, OnQueryClosePageEvent, '', true, true)]
    PROCEDURE PG1351_OnQueryClosePageEvent(VAR Rec: Record 122; VAR AllowClose: Boolean);
    VAR
        PurchInvHeader: Record 122;
        VendorLedgerEntry: Record 25;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 12/07/22: - QuoSII 1.06.10 Esta funci�n maneja los cambios en Facturas de compra Regitradas, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
        PurchInvHeader.GET(Rec."No.");

        Rec."QuoSII Auto Posting Date" := SetAutoPostingDate(Rec."QuoSII Auto Posting Date", PurchInvHeader."Document Date"); //JAV 12/07/22: - QuoSII 1.06.10 Ajusto la fecha antes de guardar

        IF (Rec."QuoSII Auto Posting Date" = PurchInvHeader."QuoSII Auto Posting Date") THEN
            EXIT;

        //Cambiar movimientos de proveedor asociados si cambia la fecha
        IF (Rec."QuoSII Auto Posting Date" <> PurchInvHeader."QuoSII Auto Posting Date") THEN BEGIN
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETCURRENTKEY("Document No.");
            VendorLedgerEntry.SETRANGE("Document No.", Rec."No.");
            VendorLedgerEntry.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
            VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
            VendorLedgerEntry.MODIFYALL("QuoSII Auto Posting Date", Rec."QuoSII Auto Posting Date");
        END;

        //JAV 13/05/21: - QB 1.08.42 Cambiar datos de las facturas de compra registradas
        PurchInvHeader.GET(Rec."No.");
        PurchInvHeader."QuoSII Auto Posting Date" := Rec."QuoSII Auto Posting Date";
        PurchInvHeader.MODIFY;
    END;

    [EventSubscriber(ObjectType::Page, 10767, OnQueryClosePageEvent, '', true, true)]
    PROCEDURE PG10767_OnQueryClosePageEvent(VAR Rec: Record 124; VAR AllowClose: Boolean);
    VAR
        PurchCrMemoHdr: Record 124;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 12/07/22: - QuoSII 1.06.10 Esta funci�n maneja los cambios en Abonos de compra Regitrados, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
    END;

    [EventSubscriber(ObjectType::Page, 10765, OnQueryClosePageEvent, '', true, true)]
    PROCEDURE PG10765_OnQueryClosePageEvent(VAR Rec: Record 112; VAR AllowClose: Boolean);
    VAR
        SalesInvoiceHeader: Record 112;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 12/07/22: - QuoSII 1.06.10 Esta funci�n maneja los cambios en Facturas de venta Regitradas, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
    END;

    [EventSubscriber(ObjectType::Page, 10766, OnQueryClosePageEvent, '', true, true)]
    PROCEDURE PG10766_OnQueryClosePageEvent(VAR Rec: Record 114; VAR AllowClose: Boolean);
    VAR
        SalesCrMemoHeader: Record 114;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------
        //JAV 12/07/22: - QuoSII 1.06.10 Esta funci�n maneja los cambios en Abonos de venta Regitrados, por el cambio de forma de manejarlas
        //---------------------------------------------------------------------------------------------------------------------------------------
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- Caclular estado de un documento"();
    BEGIN
    END;

    PROCEDURE QuoSII_GetStatus(pType: Option; pDoc: Text; VAR pText: Text; VAR pStyle: Text);
    VAR
        SIIDocuments: Record 7174333;
    BEGIN
        //JAV 14/06/21: - QB 1.08.48 ver el estado del QuoSII del documento
        pStyle := 'Standard';

        IF NOT ActivatedQuoSII THEN
            EXIT;

        SIIDocuments.RESET;
        SIIDocuments.SETRANGE("Document Type", pType);
        SIIDocuments.SETRANGE("External Reference", pDoc);
        IF (SIIDocuments.FINDLAST) THEN BEGIN
            SIIDocuments.CALCFIELDS("Shipment Status");
            CASE SIIDocuments."Shipment Status" OF
                SIIDocuments."Shipment Status"::" ":
                    pStyle := 'StandardAccent';
                SIIDocuments."Shipment Status"::Enviado:
                    pStyle := 'Favorable';
                ELSE
                    pStyle := 'Unfavorable';
            END;

            IF (SIIDocuments."Shipment Status" = SIIDocuments."Shipment Status"::" ") THEN
                pText := 'Creada sin enviar'
            ELSE
                pText := FORMAT(SIIDocuments."Shipment Status");
        END ELSE BEGIN
            pText := 'No en QuoSII';
            pStyle := 'Subordinate';
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------------------------ Exportar datos"();
    BEGIN
    END;

    PROCEDURE Exportar();
    VAR
        Company: Record 2000000006;
        tbFields: Record 2000000041;
        ExcelBuffer: Record 370 TEMPORARY;
        Window: Dialog;
        nField: Integer;
        f: Integer;
        Lista1: ARRAY[100] OF Integer;
        Lista3: ARRAY[100] OF Integer;
        Destino_T: Integer;
        Destino_F: Integer;
        TableNo: Integer;
    BEGIN
        Window.OPEN(' Empresa: #1##########################\' +
                    '   Tabla: #2##########################\');

        Company.RESET;
        IF (Company.FINDSET(FALSE)) THEN
            REPEAT
                Window.UPDATE(1, FORMAT(Company.Name));
                TableNo := 0;

                tbFields.RESET;
                tbFields.SETRANGE(TableNo, 0, 7999999);
                tbFields.SETRANGE(ObsoleteState, tbFields.ObsoleteState::No);
                IF tbFields.FINDSET(FALSE) THEN
                    REPEAT
                        //Montamos la lista de campos a traspasar
                        IF (TableNo <> tbFields.TableNo) THEN BEGIN
                            Window.UPDATE(2, FORMAT(tbFields.TableNo));
                            //La tabla anterior
                            IF (nField <> 0) THEN
                                RecorrerTabla(Company.Name, TableNo, Destino_T, nField, Lista1, Lista3, ExcelBuffer);

                            TableNo := tbFields.TableNo;
                            Destino_T := tbFields.TableNo;
                            nField := 0;
                            CLEAR(Lista1);
                            CLEAR(Lista3);
                        END;

                        //Valores por defecto, van a la misma tabla y al mismo campo
                        Destino_F := 0;
                        IF (tbFields.TableNo >= 7174331) AND (tbFields.TableNo <= 7174336) THEN BEGIN            //Tablas que van completas
                            Destino_T := 0;
                            Destino_F := tbFields."No."
                        END ELSE IF (UPPERCASE(COPYSTR(tbFields.FieldName, 1, 6)) = 'QUOSII') THEN   //Campos espec�ficos
                                Destino_F := tbFields."No.";

                        //Campos especiales que ir�n a otro campo o a otra tabla y campo
                        IF (tbFields.TableNo = 79) AND (tbFields."No." IN [7174331 .. 7174360]) THEN BEGIN
                            Destino_T := 7174337;
                        END;
                        IF (tbFields.TableNo = 98) AND (tbFields."No." = 7174331) THEN BEGIN
                            Destino_T := 7174337;
                            Destino_F := 7174330;
                        END;

                        IF (tbFields.TableNo = 21) AND (tbFields."No." = 7207277) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 25) AND (tbFields."No." = 7207300) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 36) AND (tbFields."No." = 7174366) THEN Destino_F := 7174361;
                        IF (tbFields.TableNo = 36) AND (tbFields."No." = 7207280) THEN Destino_F := 7174362;
                        IF (tbFields.TableNo = 36) AND (tbFields."No." = 7207291) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 38) AND (tbFields."No." = 7207280) THEN Destino_F := 7174362;
                        IF (tbFields.TableNo = 38) AND (tbFields."No." = 7207291) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 81) AND (tbFields."No." = 7207300) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 112) AND (tbFields."No." = 7174366) THEN Destino_F := 7174361;
                        IF (tbFields.TableNo = 112) AND (tbFields."No." = 7207280) THEN Destino_F := 7174362;
                        IF (tbFields.TableNo = 112) AND (tbFields."No." = 7207291) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 114) AND (tbFields."No." = 7174366) THEN Destino_F := 7174361;
                        IF (tbFields.TableNo = 114) AND (tbFields."No." = 7207280) THEN Destino_F := 7174362;
                        IF (tbFields.TableNo = 114) AND (tbFields."No." = 7207291) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 122) AND (tbFields."No." = 7207280) THEN Destino_F := 7174362;
                        IF (tbFields.TableNo = 122) AND (tbFields."No." = 7207291) THEN Destino_F := 7174360;
                        IF (tbFields.TableNo = 124) AND (tbFields."No." = 7207280) THEN Destino_F := 7174362;
                        IF (tbFields.TableNo = 124) AND (tbFields."No." = 7207291) THEN Destino_F := 7174360;


                        IF (Destino_F <> 0) THEN BEGIN
                            nField += 1;
                            Lista1[nField] := tbFields."No.";
                            Lista3[nField] := Destino_F;
                        END;


                    UNTIL (tbFields.NEXT = 0);
            UNTIL (Company.NEXT = 0);

        //Por si queda una tabla por recorrer
        IF (nField <> 0) THEN
            RecorrerTabla(Company.Name, TableNo, Destino_T, nField, Lista1, Lista3, ExcelBuffer);

        Window.CLOSE;

        ExcelBuffer.RESET;
        IF (ExcelBuffer.ISEMPTY) THEN
            MESSAGE('Nada que traspasar')
        ELSE BEGIN
            ExcelBuffer.CreateNewBook('QuoSII');
            ExcelBuffer.WriteSheet('', COMPANYNAME, USERID);
            ExcelBuffer.CloseBook;
            ExcelBuffer.OpenExcel;
        END;
    END;

    LOCAL PROCEDURE RecorrerTabla(pCompany: Text; TOrigen: Integer; TDestino: Integer; nField: Integer; Lista1: ARRAY[100] OF Integer; Lista3: ARRAY[100] OF Integer; VAR ExcelBuffer: Record 370 TEMPORARY);
    VAR
        rRef: RecordRef;
        Claves: Text;
        f: Integer;
    BEGIN
        rRef.OPEN(TOrigen);
        rRef.RESET;
        IF (rRef.FINDSET(FALSE)) THEN
            REPEAT
                Claves := FORMAT(rRef.RECORDID);
                FOR f := 1 TO nField DO BEGIN
                    IF (Lista1[f] <> 0) THEN BEGIN
                        MontarCampo(pCompany, TOrigen, TDestino, rRef, Lista1[f], Lista3[f], Claves, ExcelBuffer);
                    END;
                END;
            UNTIL (rRef.NEXT = 0);
        rRef.CLOSE;
    END;

    LOCAL PROCEDURE MontarCampo(pEmpresa: Text; oTable: Integer; dTable: Integer; rRef: RecordRef; oField: Integer; dField: Integer; Claves: Text; VAR ExcelBuffer: Record 370);
    VAR
        ok: Boolean;
        n: Integer;
        CR: Text;
        LF: Text;
        Valor: Text;
        TempBlob: codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Blob: OutStream;
        InStr: InStream;
        fRef: FieldRef;
    BEGIN
        fRef := rRef.FIELD(oField);
        Valor := FORMAT(fRef.VALUE);
        ok := FALSE;
        CASE FORMAT(fRef.TYPE) OF
            'Boolean':
                ok := (Valor <> FORMAT(FALSE));
            'Integer', 'Decimal':
                ok := (Valor <> '0');
            'Option':
                BEGIN
                    n := fRef.VALUE;
                    Valor := FORMAT(n);
                    ok := (n <> 0);
                END;
            'Date':
                BEGIN
                    ok := (Valor <> FORMAT(0D));
                    IF ok THEN Valor := FORMAT(fRef.VALUE, 0, '<Day,2>/<Month,2>/<Year4>');
                END;
            'BLOB':
                BEGIN
                    fRef.CALCFIELD;
                    //TempBlob.Blob := fRef.VALUE;
                    TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                    Blob.Write(fRef.VALUE);
                    //Valor := TempBlob.ToBase64String();
                    TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                    InStr.Read(Valor);
                    Valor := Base64Convert.ToBase64(Valor);
                    ok := TRUE;
                END;
            ELSE
                ok := (Valor <> '');
        END;

        //Valor := CONVERTSTR(Valor,'"',' ');
        Valor := DELCHR(Valor, '>', ' ');

        IF (ok) AND (Valor <> '') THEN BEGIN
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(pEmpresa, FALSE, '', FALSE, FALSE, FALSE, '', 1);
            ExcelBuffer.AddColumn(FORMAT(oTable), FALSE, '', FALSE, FALSE, FALSE, '', 1);
            ExcelBuffer.AddColumn(FORMAT(dTable), FALSE, '', FALSE, FALSE, FALSE, '', 1);
            IF (dTable = 0) THEN
                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', 1)
            ELSE
                ExcelBuffer.AddColumn(FORMAT(Claves), FALSE, '', FALSE, FALSE, FALSE, '', 1);

            ExcelBuffer.AddColumn(FORMAT(dField), FALSE, '', FALSE, FALSE, FALSE, '', 1);
            WHILE Valor <> '' DO BEGIN
                IF (STRLEN(Valor) <= 250) THEN BEGIN
                    ExcelBuffer.AddColumn(Valor, FALSE, '', FALSE, FALSE, FALSE, '', 1);
                    Valor := '';
                END ELSE BEGIN
                    ExcelBuffer.AddColumn(COPYSTR(Valor, 1, 250), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                    Valor := COPYSTR(Valor, 251);
                END;
            END;
        END;
    END;

    PROCEDURE Importar();
    VAR
        ExcelBuffer: Record 370 TEMPORARY;
        FileName: Text;
        Window: Dialog;
        myFile: File;
        iStream: InStream;
        Linea: Text;
        n: Integer;
        Empresa: Text;
        fOrigen: Integer;
        fDEstino: Integer;
        rID: RecordID;
        rRef: RecordRef;
        fRef: FieldRef;
        Campo: Integer;
        Leido: Boolean;
        ValorCampo: Text;
        Valor: Text;
        Tipo: Text;
        tin: Integer;
        tde: Decimal;
        tda: Date;
        tdt: DateTime;
        top: Option;
        tti: Time;
        tdf: DateFormula;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit 419;
    BEGIN
        FileName := FileManagement.UploadFile('Importar fich. Excel', '.xlsx');
        ExcelBuffer.OpenBookStream(iStream, 'QuoSII');
        ExcelBuffer.ReadSheet;

        Window.OPEN('Leyendo #1########### de #2#############');
        ExcelBuffer.RESET;
        Window.UPDATE(2, FORMAT(ExcelBuffer.COUNT));

        n := 1;
        WHILE (ExcelBuffer.GET(n, 1)) DO BEGIN
            Window.UPDATE(1, FORMAT(n));

            Empresa := LeerTxt(ExcelBuffer, n, 1);
            fOrigen := LeerInt(ExcelBuffer, n, 2);
            fDEstino := LeerInt(ExcelBuffer, n, 3);
            n += 1;
        END;
        Window.CLOSE;
        EXIT;
        /*{---
              myFile.TEXTMODE(TRUE);
              myFile.WRITEMODE(FALSE);
              myFile.OPEN(FileName, TEXTENCODING::Windows);
              myFile.CREATEINSTREAM(iStream);
              n := 0;
              WHILE NOT iStream.EOS DO BEGIN
                n += 1;
                iStream.READTEXT(Linea);
                //Empresa := SacarCampo(Linea, '~');
                //fOrigen := SacarEntero(Linea, '~');
                //fDEstino := SacarEntero(Linea, '~');
                Valor := SacarCampo(Linea, '~');
                IF (fOrigen = fDEstino) THEN
                  EVALUATE(rID, Valor);


                IF (fDEstino <> 0) THEN
                  rRef.OPEN(fDEstino, FALSE, Empresa)
                ELSE
                  rRef.OPEN(fOrigen, FALSE, Empresa);

                IF (fOrigen = fDEstino) THEN BEGIN
                  Leido := rRef.GET(rID);
                END ELSE BEGIN
                  Leido := rRef.FINDFIRST;
                  IF NOT Leido THEN BEGIN
                    rRef.INIT;
                    rRef.INSERT(FALSE);
                  END;
                END;

                IF (Leido) THEN BEGIN
                  WHILE (Linea <> '') DO BEGIN
                    ValorCampo := SacarCampo(Linea, '~');
                    Campo := SacarEntero(ValorCampo,':');
                    Valor := DELCHR(ValorCampo,'<>','"');

                    //Guardo el campo
                    fRef := rRef.FIELD(Campo);
                    Tipo := FORMAT(fRef.TYPE);
                    CASE Tipo OF
                      'Boolean'     :                               fRef.VALUE(TRUE);
                      'Integer'     : BEGIN EVALUATE(tin, Valor);   fRef.VALUE(tin); END;
                      'Decimal'     : BEGIN EVALUATE(tde, Valor);   fRef.VALUE(tde); END;
                      'Option'      : BEGIN EVALUATE(top, Valor);   fRef.VALUE(top); END;
                      'Date'        : BEGIN EVALUATE(tda, Valor);   fRef.VALUE(tda); END;
                      'DateTime'    : BEGIN EVALUATE(tdt, Valor);   fRef.VALUE(tdt); END;
                      'Time'        : BEGIN EVALUATE(tti, Valor);   fRef.VALUE(tti); END;
                      'RecordID'    : BEGIN EVALUATE(rID, Valor);   fRef.VALUE(rID); END;
                      'DateFormula' : BEGIN EVALUATE(tdf, Valor);   fRef.VALUE(tdf); END;
                      'BLOB'        :
                        BEGIN
                          TempBlob.FromBase64String(Valor);
                          fRef.VALUE(TempBlob.Blob);
                        END;
                      ELSE fRef.VALUE(Valor);
                    END;
                  END;

                  IF NOT rRef.MODIFY(FALSE) THEN ;
                END;

                rRef.CLOSE;
              END;

              myFile.CLOSE;
              ---}*/
    END;

    LOCAL PROCEDURE LeerTxt(VAR ExcelBuffer: Record 370 TEMPORARY; nReg: Integer; Nro: Integer): Text;
    VAR
        n: Integer;
        tex: Text;
    BEGIN
        IF NOT ExcelBuffer.GET(nReg, Nro) THEN
            EXIT('')
        ELSE
            EXIT(ExcelBuffer."Cell Value as Text");
    END;

    LOCAL PROCEDURE LeerInt(VAR ExcelBuffer: Record 370 TEMPORARY; nReg: Integer; Nro: Integer): Integer;
    VAR
        n: Integer;
        texto: Text;
        valor: Integer;
    BEGIN
        texto := LeerTxt(ExcelBuffer, nReg, Nro);
        IF (texto = '') THEN
            EXIT(0);

        EVALUATE(valor, texto);
        EXIT(valor);
    END;

    /*BEGIN
/*{
      PSM 25/02/21: - Ampliar variable local NewVatRegistrationNo de Code10 a Code20 en eventos T18_OnAfterValidateEvent_VATRegistrationNo y T21_OnAfterValidateEvent_VATRegistrationNo
      PSM 22/04/21: - Correcci�n de la b�squeda de facturas y abonos incluidos en env�os QuoSII
      PSM 22/08/21: - Correcci�n en controles previos a la facturaci�n
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
                    - Se mejoran los procesos de la tabla y p�gina de clientes, proveedores, documentos de vneta y de compra
      JAV 09/02/22: - QuoSII 1.06.02 Al crear un pedido de compra o de venta desde un pedido abierto, poner los campos del SII
      JAV 11/05/22: - QuoSII 1.06.07 Al indicar el documento a pagar o a cobrar en el diario se aplica su r�gimen especial a la l�nea
                                     Tratamiento del nuevo campo No subir al SII en movimientos
                                     Se traspasa la funcionalidad desde las tablas 36 y 38 para unificar
      JAV 08/06/22: - QuoSII 1.06.09 Se cambian variables err�neas
      JAV 12/07/22: - QuoSII 1.06.10 Se ajusta la fecha de registro autom�tica
                                     Se cambian los eventos de las CU 1405,10767,10765,10766 por los de PG 1351,10765,10766,10767 para los cambios en documentos registrados
                                     Se arreglan los eventos T23_OnAfterValidate_QuoSIIPurchSpecialRegimen1 y T23_OnAfterValidate_QuoSIIPurchSpecialRegimen2 que apuntaban a un campo err�neo
                                     Se elimina una contante no usada en T36_OnAfterValidateEvent_QuoSIISalesCrMemoType
                                     Se elimina la propiedad OnMissingLicense=Skip en las funciones que no sirve para nada
      PSM 24/02/23: - Q19407 Usar WORKDATE para la Fecha Auto de QuoSII, en vez de TODAY
    }
END.*/
}










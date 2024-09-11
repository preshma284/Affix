Codeunit 7207293 "Quality Management"
{


    trigger OnRun()
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 23, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE VendorOnAfterDeleteEvent(VAR Rec: Record 23; RunTrigger: Boolean);
    VAR
        VendorQualityData: Record 7207418;
        ConditionsVendor: Record 7207420;
        VendorConditionsData: Record 7207414;
        Text001: TextConst ENU = 'The Vendor %1 can not be deleted because it has data in offer comparisons', ESP = 'No puede borrarse el proveedor %1 porque tiene datos en comparativas de oferta';
    BEGIN
        //Al borrar el proveedor, borrar sus datos de calidad

        VendorConditionsData.SETRANGE("Vendor No.", Rec."No.");
        IF NOT VendorConditionsData.ISEMPTY THEN
            ERROR(Text001, Rec."No.");

        VendorQualityData.SETRANGE("Vendor No.", Rec."No.");
        VendorQualityData.DELETEALL(TRUE);

        ConditionsVendor.SETRANGE("Vendor No.", Rec."No.");
        ConditionsVendor.DELETEALL(TRUE);
    END;

    PROCEDURE ValidateEval(VendorEvalHeader: Record 7207424);
    VAR
        VendorEvalLine: Record 7207425;
        Text002: TextConst ENU = 'You want to validate the document %1', ESP = 'Quiere validar el documento %1';
        VendorEvalLine2: Record 7207425;
        VendorQltyData: Record 7207418;
        Text003: TextConst ENU = 'The evaluation %1 has been validated', ESP = 'Se ha validado la evaluaci�n %1';
        Text004: TextConst ENU = 'You want to validate the document %1', ESP = 'Quiere quitar la validaci�n del documento %1';
        Text005: TextConst ENU = 'The evaluation %1 has been validated', ESP = 'Proceso finalizado';
        Modified: Boolean;
    BEGIN
        //JAV 08/11/19: - Funci�n que cambia el estado de validado de la evaluaci�n

        VendorEvalHeader.TESTFIELD("Vendor No.");
        VendorEvalHeader.TESTFIELD("Evaluation Date");
        VendorEvalHeader.TESTFIELD("Job No.");
        //JAV 26/11/19: - Se elimina el campo "Posting Date" que no se usa
        //VendorEvalHeader.TESTFIELD("Posting Date");

        Modified := FALSE;
        IF (NOT VendorEvalHeader.Validated) THEN
            Modified := CONFIRM(Text002, TRUE, VendorEvalHeader."No.")
        ELSE
            Modified := CONFIRM(Text004, TRUE, VendorEvalHeader."No.");

        IF (Modified) THEN BEGIN
            //Cambio la cabecera
            VendorEvalHeader.Validated := NOT VendorEvalHeader.Validated;
            IF (VendorEvalHeader.Validated) THEN
                VendorEvalHeader."User ID." := USERID
            ELSE
                VendorEvalHeader."User ID." := '';
            VendorEvalHeader.MODIFY;

            //JAV 15/08/19: - Recalculo la evaluaci�n de las l�neas
            VendorEvalLine2.RESET;
            VendorEvalLine2.SETRANGE("Evaluation No.", VendorEvalHeader."No.");
            IF VendorEvalLine2.FINDSET(TRUE) THEN
                REPEAT
                    VendorEvalLine2.Validated := VendorEvalHeader.Validated;
                    VendorEvalLine2.SetAverageReviewScore;
                    VendorEvalLine2.MODIFY;
                UNTIL VendorEvalLine2.NEXT = 0;

            //JAV 15/08/19: - Recalculo la evaluaci�n de la cabecera
            VendorEvalHeader.SetEvaluationScore;
            VendorEvalHeader.MODIFY;
        END;
    END;

    PROCEDURE GetCertificates(pVendor: Code[20]; pActivity: Code[20]; pDate: Date; pView: Boolean): Integer;
    VAR
        VendorEvaluationHeader: Record 7207424;
        VendorCertificates: Record 7207419;
        VendorCertificatesTypes: Record 7207427;
        VendorCertificatesList: Page 7207340;
        fIni: Date;
        fEnd: Date;
    BEGIN
        //Busco los certificados del proveedor en vigor de la actividad o sin actividad
        VendorCertificates.RESET;
        VendorCertificates.CLEARMARKS;
        VendorCertificates.SETRANGE("Vendor No.", pVendor);
        IF VendorCertificates.FINDSET(FALSE) THEN
            REPEAT
                IF (VendorCertificates."Activity Code" = '') OR (VendorCertificates."Activity Code" = pActivity) THEN BEGIN
                    IF (VendorCertificatesTypes.GET(VendorCertificates."Certificate Code")) THEN BEGIN
                        IF (VendorCertificatesTypes."Type of Certificate" <> VendorCertificatesTypes."Type of Certificate"::"Current Payment") THEN BEGIN
                            IF (VendorCertificates.IsValid(pDate, fIni, fEnd)) THEN BEGIN
                                VendorCertificates.MARK(TRUE);
                            END;
                        END;
                    END;
                END;
            UNTIL VendorCertificates.NEXT = 0;
        VendorCertificates.MARKEDONLY(TRUE);

        //Presentar los certificados
        IF (pView) THEN BEGIN
            CLEAR(VendorCertificatesList);
            VendorCertificatesList.SETTABLEVIEW(VendorCertificates);
            VendorCertificatesList.RUNMODAL;
        END;

        EXIT(VendorCertificates.COUNT);
    END;

    PROCEDURE GetConditions(pVendor: Code[20]; pJob: Code[20]; pActivity: Code[20]; pDate: Date);
    VAR
        VendorConditions: Record 7207420;
        VendorConditionsList: Page 7207341;
        find: Boolean;
    BEGIN
        //Busco y presento la lista de las condiciones del proveedor

        SetConditionsRanges(VendorConditions, pVendor, pJob, pActivity, pDate);
        IF VendorConditions.FINDSET(FALSE) THEN BEGIN
            REPEAT
                VendorConditions.MARK(TRUE);
            UNTIL VendorConditions.NEXT = 0;
        END ELSE IF (pActivity <> '') THEN BEGIN
            //Si no hay ninguna, la creo a partir de las generales
            SetConditionsRanges(VendorConditions, pVendor, pJob, pActivity, pDate);
            VendorConditions.INSERT(TRUE);
            VendorConditions.VALIDATE("Use Generals");
            VendorConditions.MARK(TRUE);
            COMMIT;
        END;
        VendorConditions.MARKEDONLY(TRUE);

        //Presentar las condiciones
        CLEAR(VendorConditionsList);
        VendorConditionsList.SETTABLEVIEW(VendorConditions);
        VendorConditionsList.RUNMODAL;
    END;

    PROCEDURE GetActualConditions(VAR pConditions: Record 7207420; pVendor: Code[20]; pJob: Code[20]; pActivity: Code[20]; pDate: Date);
    VAR
        Vendor: Record 23;
        VendorConditions: Record 7207420;
        find: Boolean;
    BEGIN
        //Busco las condiciones del proveedor en vigor de la actividad, si no las encuentro busco las generales

        //Si no encuentro condiciones, usar� las generales
        pConditions.INIT;
        pConditions."Use Generals" := TRUE;

        //Busco las condiciones
        SetConditionsRanges(VendorConditions, pVendor, pJob, pActivity, pDate);
        IF VendorConditions.FINDLAST THEN BEGIN
            IF (NOT VendorConditions."Use Generals") THEN
                pConditions := VendorConditions;
        END;

        //Ajusto los campos no informados
        Vendor.GET(pVendor);
        pConditions."Activity Code" := pActivity;
        pConditions."Job No." := pJob;

        IF (FORMAT(pConditions."Validity Quotes") = '') THEN
            pConditions."Validity Quotes" := Vendor."QB Validity Quotes";
        IF (pConditions."Withholding Code" = '') THEN
            pConditions."Withholding Code" := Vendor."QW Withholding Group by G.E.";
        IF (FORMAT(pConditions.Warranty) = '') THEN
            pConditions.Warranty := Vendor."QB Warranty";
        IF (pConditions."Payment Terms Code" = '') THEN
            pConditions."Payment Terms Code" := Vendor."Payment Terms Code";
        IF (pConditions."Payment Method Code" = '') THEN
            pConditions."Payment Method Code" := Vendor."Payment Method Code";
        IF (pConditions."Payment Phases" = '') THEN
            pConditions."Payment Phases" := Vendor."QB Payment Phases";
    END;

    LOCAL PROCEDURE SetConditionsRanges(VAR pConditions: Record 7207420; pVendor: Code[20]; pJob: Code[20]; pActivity: Code[20]; pDate: Date);
    BEGIN
        //Busco las condiciones del proveedor en vigor de la actividad, si no las encuentro busco las generales
        pConditions.RESET;
        pConditions.SETRANGE("Vendor No.", pVendor);
        pConditions.SETFILTER("Date Init", '<=%1', pDate);
        pConditions.SETFILTER("Date End", '=%1 | >=%2', 0D, pDate);

        //Caso 1: Busco con proyecto y actividad
        IF (TRUE) THEN BEGIN
            pConditions.SETFILTER("Job No.", '=%1', pJob);
            pConditions.SETFILTER("Activity Code", '=%1', pActivity);
        END;

        //Caso 2: Con proyecto sin actividad
        IF (pConditions.ISEMPTY) THEN BEGIN
            pConditions.SETFILTER("Job No.", '=%1', pJob);
            pConditions.SETFILTER("Activity Code", '=%1', '');
        END;

        //Caso 3: Sin proyecto con actividad
        IF (pConditions.ISEMPTY) THEN BEGIN
            pConditions.SETFILTER("Job No.", '=%1', '');
            pConditions.SETFILTER("Activity Code", '=%1', pActivity);
        END;

        //Caso 4: Sin proyecto ni actividad
        IF (pConditions.ISEMPTY) THEN BEGIN
            pConditions.SETFILTER("Job No.", '=%1', '');
            pConditions.SETFILTER("Activity Code", '=%1', '');
        END;
    END;

    PROCEDURE IsCertificateControlActive(): Boolean;
    VAR
        FunctionQB: Codeunit 7207272;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 06/11/19: - Funci�n que retorna si el control de certificados est� o no activo
        IF NOT FunctionQB.AccessToQuobuilding THEN
            EXIT(FALSE);

        QuoBuildingSetup.GET();
        EXIT(QuoBuildingSetup."Use certificate control");
    END;

    PROCEDURE VendorCertificatesDued(VendorCode: Code[20]; pDate: Date; VAR pText: Text): Boolean;
    VAR
        Vendor: Record 23;
        VendorCertificates: Record 7207419;
        VendorCertificatesHistory: Record 7207426;
        TextError: Text[250];
        Valid: Boolean;
        DateIni: Date;
        DateEnd: Date;
    BEGIN
        //JAV 06/11/19: - Se cambia a la nueva forma de obtener certificados obligatorios en la funci�n ControlCertificatesTreasury.
        //              - Retorna FALSE si no hay que controla o los tiene en vigor, TRUE si debe controlar y alguno no est� en vigor
        pText := '';
        IF NOT IsCertificateControlActive THEN
            EXIT(FALSE);

        IF (pDate = 0D) THEN
            pDate := WORKDATE;

        IF Vendor.GET(VendorCode) THEN BEGIN
            IF (Vendor."QB Do not control certificates") THEN
                EXIT(FALSE);

            //-Q20145 CONTROL CERTIFICADOS PROVEEDOR
            /*{ Q20145 CONTROL CERTIFICADOS PROVEEDOR
                    VendorCertificates.SETRANGE("Vendor No.", VendorCode);
                    VendorCertificates.SETRANGE(Required, TRUE);
                    VendorCertificates.SETFILTER("Active From", '=%1 | <= %2', 0D, pDate);
                    VendorCertificates.SETFILTER("Active To",   '=%1 | <= %2', 0D, pDate);
                    IF (VendorCertificates.FINDSET(FALSE)) THEN
                      REPEAT
                        IF NOT VendorCertificates.IsValid(pDate, DateIni, DateEnd) THEN
                          pText += ' [' + VendorCertificates."Certificate Code" + ']';
                      UNTIL VendorCertificates.NEXT = 0;
                  }*/
            Valid := FALSE;
            VendorCertificates.SETRANGE("Vendor No.", VendorCode);
            VendorCertificates.SETRANGE(Required, TRUE);
            VendorCertificates.SETRANGE("Active From", 0D, pDate);
            VendorCertificates.SETFILTER("Active To", '=%1 | >= %2', 0D, pDate);
            IF (VendorCertificates.FINDSET(FALSE)) THEN
                REPEAT
                    IF NOT VendorCertificates.IsValid(pDate, DateIni, DateEnd) THEN
                        pText += ' [' + VendorCertificates."Certificate Code" + ']';
                UNTIL VendorCertificates.NEXT = 0;
            //+Q20145 CONTROL CERTIFICADOS PROVEEDOR
        END;

        EXIT(pText <> '');
    END;

    [EventSubscriber(ObjectType::Page, 51, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE "OnAfterValidateEvent_Buy-fromVendorNo_Page-PurchaseInvoice"(VAR Rec: Record 38; VAR xRec: Record 38);
    VAR
        TxtError: Text;
    BEGIN
        VendorCertificatesDued(Rec."Buy-from Vendor No.", Rec."Posting Date", TxtError);
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE "OnBeforePostPurchaseDoc_Codeunit-90"(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        TxtError: Text;
        Text01: TextConst ENU = 'The Treasury Payment Certificate expired', ESP = 'El proveedor %1 tiene certificados caducados: \  -%2';
        Type: Option "Msg","Err";
    BEGIN
        IF VendorCertificatesDued(PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."Posting Date", TxtError) THEN BEGIN
            IF (PreviewMode) THEN
                Type := Type::Msg
            ELSE BEGIN
                QuoBuildingSetup.GET;
                CASE QuoBuildingSetup."Due Certificate Action" OF
                    QuoBuildingSetup."Due Certificate Action"::No:
                        Type := Type::Err;
                    QuoBuildingSetup."Due Certificate Action"::Shipment:
                        IF ((PurchaseHeader.Invoice)) OR (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) THEN
                            Type := Type::Err;
                END;
            END;

            CASE Type OF
                Type::Msg:
                    MESSAGE(STRSUBSTNO(Text01, PurchaseHeader."Buy-from Vendor No.", TxtError));
                Type::Err:
                    ERROR(STRSUBSTNO(Text01, PurchaseHeader."Buy-from Vendor No.", TxtError));
            END;
        END;
    END;

    /*BEGIN
/*{
      JAV 08/11/19: - Se agrupan las funciones de Calidad en esta CU
      JAV 26/11/19: - Se elimina el campo "Posting Date" que no se usa
      JAV 02/02/20: - Se pasa desde la CU "QB - Table - Subscriber" la funci�n "ControlCertificatesTreasury", con el nombre "ControlVendorCertificates"
      JAV 05/03/20: - Funci�n para controlar certificados vencidos al insertar documentos en una relaci�n de pagos
      AML 25/09/23: - Q20145 Fallo en el control de certificados.
    }
END.*/
}








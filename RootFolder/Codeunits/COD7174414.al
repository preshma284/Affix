Codeunit 7174414 "DP Management"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        gDeductibleStatus: Option "No","All","None","Both";
        Window: Dialog;
        n1: Integer;
        nt: Integer;
        Txt005: TextConst ESP = 'No ha indicado un a�o para el registro';
        Txt010: TextConst ENU = 'Final prorrata has already been calculated.', ESP = '"La prorrata definitiva ya ha sido calculada "';
        Txt011: TextConst ENU = 'prorrata Calc. Type not a Blanc', ESP = 'El tipo prorrata no debe ser Blanco';
        Txt012: TextConst ESP = 'Antes de este proceso debe calcular la definitiva';

    PROCEDURE AccessToProrrata(): Boolean;
    VAR
        DPSetup: Record 7174350;
    BEGIN
        //JAV 31/05/22: - DP 1.00.00 Si est� activo el m�dulo de prorrata
        IF AccessToTablePermision(7174350) THEN BEGIN
            IF DPSetup.GET THEN
                EXIT(DPSetup."DP Use Prorrata");
        END;

        EXIT(FALSE);
    END;

    PROCEDURE AccessToNonDeductible(): Boolean;
    VAR
        DPSetup: Record 7174350;
    BEGIN
        //JAV 31/05/22: - DP 1.00.00 Si est� activo el m�dulo de IVA no deducible
        IF AccessToTablePermision(7174350) THEN BEGIN
            IF DPSetup.GET THEN
                EXIT(DPSetup."DP Use Non Deductible");
        END;

        EXIT(FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE AccessToTablePermision(pFile: Integer);
    VAR
        Object: Record 2000000001;
        rRef: RecordRef;
        fRef: FieldRef;
    BEGIN
        //Verifico que existe la tabla y puedo acceder a ella
        Object.RESET;
        Object.SETRANGE(Type, Object.Type::Table);
        Object.SETRANGE(ID, pFile);
        IF Object.ISEMPTY THEN
            ERROR('No existe la tabla');

        rRef.OPEN(pFile);
        IF rRef.FINDFIRST THEN;
        rRef.CLOSE;
    END;

    PROCEDURE DimensionForProrrata(): Code[20];
    VAR
        DPSetup: Record 7174350;
    BEGIN
        //JAV 31/05/22: - DP 1.00.00 Si est� activo el m�dulo de prorrata
        IF (AccessToProrrata) THEN BEGIN
            DPSetup.GET;
            IF (DPSetup."DP Dimension Associated" = '') THEN
                ERROR('No ha establecido la dimensi�n asociada a la prorrata para seleccionar deducibles y no deducibles');
            EXIT(DPSetup."DP Dimension Associated");
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------------------------------- Manejo en tablas y p ginas de Compras"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnBeforeDeleteEvent(VAR Rec: Record 38; RunTrigger: Boolean);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Trigger antes de borrar una cabecera de compras, quitar la prorrata
        //-------------------------------------------------------------------------------------------------------------------
        IF (NOT RunTrigger) THEN
            EXIT;

        Rec."DP Apply Prorrata Type" := 333;    //Esto marca que vamos a borrar
        Rec.MODIFY(FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "DP Force Not Use Prorrata", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_DPForceNotUseProrrata(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Validate del campo "DP Force Not Use Prorrata" en la cabecera de compras
        //-------------------------------------------------------------------------------------------------------------------

        SetProrrata_PurchaseHeader(Rec);
        SetProrrata_PurchaseLines(Rec);
        Rec.CALCFIELDS("DP Deductible VAT Amount", "DP Non Deductible VAT Amount");
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterInsertEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Trigger tras el alta de una l�nea de compras, ajustar no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF (NOT RunTrigger) THEN
            EXIT;

        OnChange_PurchaseLine(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterModifyEvent(VAR Rec: Record 39; VAR xRec: Record 39; RunTrigger: Boolean);
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Trigger tras modificar una l�nea de compras, ajustar no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF (NOT RunTrigger) THEN
            EXIT;

        OnChange_PurchaseLine(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnAfterDeleteEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Trigger tras eliminar una l�nea de compras, ajustar no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF (NOT RunTrigger) THEN
            EXIT;

        OnChange_PurchaseLine(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "VAT Prod. Posting Group", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_VATProdPostingGroup(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        VATPostingSetup: Record 325;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Trigger tras el validate del grupo de iva de una l�nea de compras, ajustar no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF Rec.MODIFY(FALSE) THEN
            OnChange_PurchaseLine(Rec, TRUE);

        //Si cambia el IVA establecer el porcentaje no deducible por defecto
        IF (Rec."VAT Prod. Posting Group" <> xRec."VAT Prod. Posting Group") AND (Rec."VAT Prod. Posting Group" <> '') THEN BEGIN
            VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
            Rec."DP Non Deductible VAT Line" := VATPostingSetup."DP Non Deductible VAT Line";
            Rec.VALIDATE("DP Non Deductible VAT %", VATPostingSetup."DP Non Deductible VAT %");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, Amount, true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_Amount(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Trigger tras el validate del importe total de una l�nea de compras, ajustar no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF Rec.MODIFY(FALSE) THEN
            OnChange_PurchaseLine(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "DP Non Deductible VAT Line", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_DPNonDeductibleVATLine(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 14/07/22: - DP 1.00.04 Trigger tras el validate de si la l�nea tiene IVA no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF Rec.MODIFY(FALSE) THEN
            OnChange_PurchaseLine(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "DP Non Deductible VAT %", true, true)]
    LOCAL PROCEDURE T39_OnAfterValidateEvent_DPNonDeductibleVATPorc(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 14/07/22: - DP 1.00.04 Trigger tras el validate de si la l�nea tiene % de IVA no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF Rec.MODIFY(FALSE) THEN
            OnChange_PurchaseLine(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterActionEvent, Action1904974904, true, true)]
    LOCAL PROCEDURE P55_OnAfterActionEvent_Dimensiones(VAR Rec: Record 39);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        // JAV 21/06/22: - DP 1.00.00 Acci�n en p�gina de l�neas de facturas de compra tras el bot�n de dimensiones, ajustar no deducible
        //-------------------------------------------------------------------------------------------------------------------
        IF Rec.MODIFY(FALSE) THEN BEGIN
            OnChange_PurchaseLine(Rec, TRUE);
            Rec.GET(Rec."Document Type", Rec."Document No.", Rec."Line No."); //volver a leer la l�nea, puede haber cambiado
        END;
    END;

    LOCAL PROCEDURE SetProrrata_PurchaseHeader(VAR PurchaseHeader: Record 38);
    VAR
        DPProrrataPercentajes: Record 7174351;
        MsgErr01: TextConst ENU = '"There is not pro-rata configurarion for posting date %1 "', ESP = 'No hay l�nea de configuraci�n de prorrata para la fecha registro %1';
        PurchaseLine: Record 39;
        MsgErr02: TextConst ENU = 'There is not Prorrata calc type configuration for the year %1.', ESP = 'No hay tipo de calculo configurado para el a�o %1.';
        VATPostingSetup: Record 325;
        NewType: Option;
        NewPorc: Decimal;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Establece los datos de la prorrata en la cabecera del documento de compra. Basado en CEI14253 de mercabarna
        //-------------------------------------------------------------------------------------------------------------------

        //Por defecto eliminamos la prorrata
        NewType := PurchaseHeader."DP Apply Prorrata Type"::No;
        NewPorc := 0;

        //Si tiene acceso a las prorratas y es una factura o abono, calculamos el porcentaje de la cabecera
        IF (AccessToProrrata) THEN BEGIN
            IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"]) THEN BEGIN
                //Busco el registro de prorrata del a�o del documento
                DPProrrataPercentajes.RESET;
                DPProrrataPercentajes.SETRANGE("Application Year", DATE2DMY(PurchaseHeader."Posting Date", 3));
                IF NOT DPProrrataPercentajes.FINDFIRST THEN
                    ERROR(MsgErr01, PurchaseHeader."Posting Date");

                CASE DPProrrataPercentajes."Prorrata Calc. Type" OF
                    DPProrrataPercentajes."Prorrata Calc. Type"::General:
                        BEGIN
                            NewType := PurchaseHeader."DP Apply Prorrata Type"::General;
                            NewPorc := DPProrrataPercentajes."Prorrata %";
                        END;
                    DPProrrataPercentajes."Prorrata Calc. Type"::Special:
                        BEGIN
                            NewType := PurchaseHeader."DP Apply Prorrata Type"::Especial;
                            //Obtenemos de las l�neas si son deducibles
                            CASE SetDeductible_PurchaseLines(PurchaseHeader, FALSE) OF
                                gDeductibleStatus::All:
                                    NewPorc := 100;                                   //=1 Todos deducibles
                                gDeductibleStatus::None:
                                    NewPorc := 0;                                     //=2 Todos no deducibles
                                gDeductibleStatus::Both:
                                    NewPorc := DPProrrataPercentajes."Prorrata %";    //=3 Algunos deducibles otros no
                            END;
                        END;
                END;
            END;
        END;

        //Si ha cambiado guardo los valores en la cabecera y calcular las l�neas
        IF (NewType <> PurchaseHeader."DP Apply Prorrata Type") OR (NewPorc <> PurchaseHeader."DP Prorrata %") THEN BEGIN
            PurchaseHeader."DP Apply Prorrata Type" := NewType;
            PurchaseHeader."DP Prorrata %" := NewPorc;
            IF PurchaseHeader.MODIFY(FALSE) THEN BEGIN  //Para evitar que entre en bucle de c�mbios
                SetDeductible_PurchaseLines(PurchaseHeader, TRUE);
                SetProrrata_PurchaseLines(PurchaseHeader);
            END;
        END;
    END;

    LOCAL PROCEDURE OnChange_PurchaseLine(VAR Rec: Record 39; pModify: Boolean);
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        IF (PurchaseHeader.GET(Rec."Document Type", Rec."Document No.")) THEN
            IF (PurchaseHeader."DP Apply Prorrata Type" <> 333) THEN BEGIN
                SetProrrata_PurchaseHeader(PurchaseHeader);
                IF (pModify) THEN
                    SetProrrata_PurchaseLine(PurchaseHeader, Rec);
            END;
    END;

    LOCAL PROCEDURE SetDeductible_PurchaseLines(VAR Rec: Record 38; pModify: Boolean): Integer;
    VAR
        PurchaseLine: Record 39;
        DedStatus: Option;
        value: Option;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Establece los datos en las l�neas del documento de compra sobre si son o no deducibles seg�n la dimensi�n
        //                           Retorna si todas las l�neas son deducibles, no deducibles o tiene de ambos tipos
        //-------------------------------------------------------------------------------------------------------------------

        DedStatus := gDeductibleStatus::No;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF PurchaseLine.FINDSET(TRUE) THEN
            REPEAT
                //Mirar si todas las l�neas son o no deducibles, pero solo de l�neas que se consideren
                value := GetDeductible_PurchaseLine(PurchaseLine);
                IF (value <> PurchaseLine."DP Deductible VAT Line"::No) THEN BEGIN
                    CASE DedStatus OF
                        gDeductibleStatus::No:
                            IF (value = PurchaseLine."DP Deductible VAT Line"::Yes) THEN
                                DedStatus := gDeductibleStatus::All ELSE
                                DedStatus := gDeductibleStatus::None;
                        gDeductibleStatus::All:
                            IF (value = PurchaseLine."DP Deductible VAT Line"::Yes) THEN
                                DedStatus := gDeductibleStatus::All ELSE
                                DedStatus := gDeductibleStatus::Both;
                        gDeductibleStatus::None:
                            IF (value = PurchaseLine."DP Deductible VAT Line"::Yes) THEN
                                DedStatus := gDeductibleStatus::Both ELSE
                                DedStatus := gDeductibleStatus::None;
                        ELSE
                            DedStatus := gDeductibleStatus::Both;
                    END;
                END;
            UNTIL PurchaseLine.NEXT = 0;

        EXIT(DedStatus);
    END;

    LOCAL PROCEDURE GetDeductible_PurchaseLine(VAR Rec: Record 39): Integer;
    VAR
        PurchaseLine: Record 39;
        DimensionValue: Record 349;
        DedStatus: Option;
        value: Option;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Establece en una sola l�nea del documento de compra si es o no deducible seg�n la dimensi�n
        //-------------------------------------------------------------------------------------------------------------------

        value := Rec."DP Deductible VAT Line"::NotUsed;
        IF (ReturnProrrataPosible_PurchaseLines(Rec)) THEN BEGIN
            IF (NOT DimensionValue.GET(DimensionForProrrata, GetDimValueFromID(DimensionForProrrata, Rec."Dimension Set ID"))) THEN
                DimensionValue.INIT;

            IF (DimensionValue."DP Prorrata Non deductible") THEN
                value := Rec."DP Deductible VAT Line"::No
            ELSE
                value := Rec."DP Deductible VAT Line"::Yes;
        END;

        EXIT(value);
    END;

    LOCAL PROCEDURE SetProrrata_PurchaseLines(VAR Rec: Record 38);
    VAR
        PurchaseLine: Record 39;
        VATToChange: Text;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Establece los datos de la prorrata en las l�neas del documento de compra.
        //-------------------------------------------------------------------------------------------------------------------

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF PurchaseLine.FINDSET(TRUE) THEN
            REPEAT
                SetProrrata_PurchaseLine(Rec, PurchaseLine);
            UNTIL PurchaseLine.NEXT = 0;
    END;

    LOCAL PROCEDURE SetProrrata_PurchaseLine(PurchaseHeader: Record 38; VAR PurchaseLine: Record 39);
    VAR
        VATPostingSetup: Record 325;
        Currency: Record 4;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Establece los datos de la prorrata en una l�nea del documento de compra. Basado en Q12228 de mercabarna
        //JAV 14/07/22: - DP 1.00.04 Se a�ade el control de la divisas y los decimales del redondeo. Se a�ade el IVA no deducible general
        //-------------------------------------------------------------------------------------------------------------------

        //JAV 28/09/22: - DP 1.00.05 Por defecto no tiene prorrata
        PurchaseLine."DP Deductible VAT Line" := PurchaseLine."DP Deductible VAT Line"::NotUsed;
        PurchaseLine."DP VAT Amount" := 0;
        PurchaseLine."DP Apply Prorrata Type" := PurchaseLine."DP Apply Prorrata Type"::No;
        PurchaseLine."DP Prorrata %" := 0;
        PurchaseLine."DP Deductible VAT amount" := 0;
        PurchaseLine."DP Non Deductible VAT amount" := 0;
        IF (AccessToProrrata) THEN BEGIN

            //Control de la divisa
            IF (PurchaseHeader."Currency Code" <> '') THEN
                ERROR('No puede usar divisas en documentos con importe no deducible de IVA');

            Currency.InitRoundingPrecision;

            //JAV 28/09/22: - DP 1.00.09 Solo si existe el registro del tipo de IVA podemos aplicarlo
            IF VATPostingSetup.GET(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group") THEN BEGIN
                PurchaseLine."DP Deductible VAT Line" := GetDeductible_PurchaseLine(PurchaseLine);

                IF (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") THEN
                    PurchaseLine."DP VAT Amount" := ROUND(PurchaseLine.Amount * VATPostingSetup."VAT %" / 100, 0.01)
                ELSE
                    PurchaseLine."DP VAT Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;

                //Datos por defecto
                PurchaseLine."DP Apply Prorrata Type" := PurchaseLine."DP Apply Prorrata Type"::No;
                PurchaseLine."DP Prorrata %" := 0;
                PurchaseLine."DP Deductible VAT amount" := PurchaseLine."DP VAT Amount";
                PurchaseLine."DP Non Deductible VAT amount" := 0;

                //Datos de la prorrata
                IF (PurchaseLine."DP Deductible VAT Line" <> PurchaseLine."DP Deductible VAT Line"::NotUsed) AND
                   (NOT PurchaseHeader."DP Force Not Use Prorrata") AND (PurchaseHeader."DP Apply Prorrata Type" <> PurchaseHeader."DP Apply Prorrata Type"::No) THEN BEGIN
                    PurchaseLine."DP Apply Prorrata Type" := PurchaseHeader."DP Apply Prorrata Type";
                    PurchaseLine."DP Prorrata %" := PurchaseHeader."DP Prorrata %";
                    PurchaseLine."DP Deductible VAT amount" := ROUND(PurchaseLine."DP VAT Amount" * PurchaseHeader."DP Prorrata %" / 100, Currency."Amount Rounding Precision");
                    PurchaseLine."DP Non Deductible VAT amount" := PurchaseLine."DP VAT Amount" - PurchaseLine."DP Deductible VAT amount";
                END;

                //Datos del IVA no deducible general
                IF (PurchaseLine."DP Non Deductible VAT Line") THEN BEGIN
                    PurchaseLine."DP Non Deductible VAT amount" := ROUND(PurchaseLine."DP VAT Amount" * PurchaseLine."DP Non Deductible VAT %" / 100, Currency."Amount Rounding Precision");
                    PurchaseLine."DP Deductible VAT amount" := PurchaseLine."DP VAT Amount" - PurchaseLine."DP Non Deductible VAT amount";
                END;
            END;
        END;

        PurchaseLine.MODIFY(FALSE);  //Para que no entre en bucle de c�mbios
    END;

    LOCAL PROCEDURE ReturnProrrataPosible_PurchaseLines(PurchaseLine: Record 39): Boolean;
    VAR
        VATPostingSetup: Record 325;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Retorna si se puede aplciar prorrata a una l�nea de compra
        //-------------------------------------------------------------------------------------------------------------------

        //Si no tiene importe no se puede aplicar la prorrata
        IF (PurchaseLine.Amount = 0) THEN
            EXIT(FALSE);

        //Si es IVA total no se puede aplicar prorrata
        VATPostingSetup.GET(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group");
        IF (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Full VAT") THEN
            EXIT(FALSE);

        //Si es reversi�n SI aplicamos prorrata
        //IF (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") THEN
        //  EXIT(false);

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE "--------------------------------------------------------------------- CU de Registro de compras"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostPurchaseDoc(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        prorrataPercentage: Decimal;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Antes de registrar una factura o un abono, revisar la prorrata
        //-------------------------------------------------------------------------------------------------------------------
        SetProrrata_PurchaseHeader(PurchaseHeader);
    END;

    [EventSubscriber(ObjectType::Table, 49, OnAfterInvPostBufferPreparePurchase, '', true, true)]
    LOCAL PROCEDURE T49_OnAfterInvPostBufferPreparePurchase(VAR PurchaseLine: Record 39; VAR InvoicePostBuffer: Record 49);
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 A�adir informaci�n de la prorrata para la agrupaci�n de las l�neas de compra
        //JAV 14/07/22: - DP 1.00.04 A�adimos el manejo del IVA no deducible
        //-------------------------------------------------------------------------------------------------------------------

        IF (PurchaseLine."DP Apply Prorrata Type" <> PurchaseLine."DP Apply Prorrata Type"::No) THEN
            InvoicePostBuffer."DP Prorrata %" := PurchaseLine."DP Prorrata %";
        IF (PurchaseLine."DP Non Deductible VAT Line") THEN
            InvoicePostBuffer."DP Non Deductible %" := PurchaseLine."DP Non Deductible VAT %";
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostInvPostBuffer, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostInvPostBuffer(VAR GenJnlLine: Record 81; VAR InvoicePostBuffer: Record 49; VAR PurchHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        Currency: Record 4;
        PurchaseLine: Record 39;
        Deductible: Decimal;
        NonDeductible: Decimal;
        GenJnlLine2: Record 81;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 A�adir informaci�n de la prorrata al diario contable asociado a la agrupaci�n de l�neas de compra
        //JAV 14/07/22: - DP 1.00.04 A�adimos el manejo del IVA no deducible
        //-------------------------------------------------------------------------------------------------------------------
        //Guarda datos en el diario

        NonDeductible := 0;
        Deductible := InvoicePostBuffer."VAT Amount";

        //Inicialziamos los datos
        GenJnlLine."DP Original VAT Amount" := 0;
        GenJnlLine."DP Non Deductible %" := 0;
        GenJnlLine."DP Non Deductible Amount" := 0;
        GenJnlLine."DP Prorrata Type" := GenJnlLine."DP Prorrata Type"::" ";
        GenJnlLine."DP Prov. Prorrata %" := 0;

        //Prorrata
        IF (NOT PurchHeader."DP Force Not Use Prorrata") AND (PurchHeader."DP Apply Prorrata Type" <> PurchHeader."DP Apply Prorrata Type"::No) THEN BEGIN
            Deductible := ROUND(InvoicePostBuffer."VAT Amount" * InvoicePostBuffer."DP Prorrata %" / 100, 0.01);
            NonDeductible := InvoicePostBuffer."VAT Amount" - Deductible;

            GenJnlLine."DP Original VAT Amount" := InvoicePostBuffer."VAT Amount";
            GenJnlLine."DP Prorrata Type" := GenJnlLine."DP Prorrata Type"::Provisional;         //Siempre ser� provisional cuando registramos compras, ser� final cuando se cierre
            GenJnlLine."DP Prov. Prorrata %" := InvoicePostBuffer."DP Prorrata %";
        END;

        //Manejo del IVA no deducible general
        IF (InvoicePostBuffer."DP Non Deductible %" <> 0) THEN BEGIN
            NonDeductible := ROUND(InvoicePostBuffer."VAT Amount" * InvoicePostBuffer."DP Non Deductible %" / 100, 0.01);
            Deductible := InvoicePostBuffer."VAT Amount" - NonDeductible;

            GenJnlLine."DP Original VAT Amount" := InvoicePostBuffer."VAT Amount";
            GenJnlLine."DP Non Deductible %" := InvoicePostBuffer."DP Non Deductible %";
            GenJnlLine."DP Non Deductible Amount" := NonDeductible;
        END;

        //Aumentar el gasto con la parte no deducible
        IF (NonDeductible <> 0) THEN BEGIN
            InvoicePostBuffer.Amount += NonDeductible;
            InvoicePostBuffer."VAT Amount" -= NonDeductible;

            GenJnlLine.Amount += NonDeductible;
            GenJnlLine."VAT Amount" -= NonDeductible;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInsertVATEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnBeforeInsertVATEntry(VAR VATEntry: Record 254; GenJournalLine: Record 81);
    BEGIN
        VATEntry."DP Original VAT Amount" := GenJournalLine."DP Original VAT Amount";
        VATEntry."DP Non Deductible %" := GenJournalLine."DP Non Deductible %";
        VATEntry."DP Non Deductible Amount" := GenJournalLine."DP Non Deductible Amount";
        VATEntry."DP Prorrata Type" := GenJournalLine."DP Prorrata Type";
        VATEntry."DP Prov. Prorrata %" := GenJournalLine."DP Prov. Prorrata %";
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitGLEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnAfterInitGLEntry(VAR GLEntry: Record 17; GenJournalLine: Record 81);
    VAR
        VATPostingSetup: Record 325;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 21/06/22: - DP 1.00.00 Guardar los valores aplicados en el movimiento contable.
        //                           Si la l�nea es de reversi�n del IVA, el importe es el original de la l�nea pero en negativo
        //JAV 14/07/22: - DP 1.00.04 Se a�ade el manejo del IVA no deducible
        //-------------------------------------------------------------------------------------------------------------------

        //Guardar los valores aplicados en el movimiento contable
        GLEntry."DP Original VAT Amount" := GenJournalLine."DP Original VAT Amount";
        GLEntry."DP Non Deductible %" := GenJournalLine."DP Non Deductible %";
        GLEntry."DP Non Deductible Amount" := GenJournalLine."DP Non Deductible Amount";
        GLEntry."DP Prorrata Type" := GenJournalLine."DP Prorrata Type";
        GLEntry."DP Prov. Prorrata %" := GenJournalLine."DP Prov. Prorrata %";

        //Si el iva es de reversi�n, hay que poner en el apunte contable el importe total no el reducido
        IF (GenJournalLine."DP Prorrata Type" <> GenJournalLine."DP Prorrata Type"::" ") OR
           (GenJournalLine."DP Non Deductible %" <> 0) THEN BEGIN
            VATPostingSetup.GET(GenJournalLine."VAT Bus. Posting Group", GenJournalLine."VAT Prod. Posting Group");
            IF (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") THEN BEGIN
                IF (VATPostingSetup."Reverse Chrg. VAT Acc." = GLEntry."G/L Account No.") THEN BEGIN
                    //Por si est� mal configurado y no puedo detectar cuando es la cuenta normal y cuando la de reversi�n
                    IF (VATPostingSetup."Reverse Chrg. VAT Acc." = VATPostingSetup."Purchase VAT Account") THEN
                        ERROR('No puede emplear la misma cuenta para el IVA de la compra y el de Reversi�n');
                    GLEntry.Amount := -GenJournalLine."DP Original VAT Amount";
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1004, OnAfterFromPurchaseLineToJnlLine, '', true, true)]
    LOCAL PROCEDURE CU1004_OnAfterFromPurchaseLineToJnlLine(VAR JobJnlLine: Record 210; PurchHeader: Record 38; PurchInvHeader: Record 122; PurchCrMemoHeader: Record 124; PurchLine: Record 39; SourceCode: Code[10]);
    VAR
        Currency: Record 4;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/07/22: - DP 1.00.03 Aumentar el gasto en el proyecto por la prorrata
        //-------------------------------------------------------------------------------------------------------------------
        IF (PurchLine."DP Non Deductible VAT amount" = 0) OR (JobJnlLine.Quantity = 0) THEN
            EXIT;

        IF (JobJnlLine."Currency Code" <> '') THEN
            ERROR('No puede usar divisas en documentos con importe no deducible de IVA');

        Currency.InitRoundingPrecision;

        JobJnlLine."Total Cost" += PurchLine."DP Non Deductible VAT amount";
        JobJnlLine."Unit Cost" := ROUND(JobJnlLine."Total Cost" / JobJnlLine.Quantity, Currency."Unit-Amount Rounding Precision");

        JobJnlLine."Total Cost (LCY)" += PurchLine."DP Non Deductible VAT amount";
        JobJnlLine."Unit Cost (LCY)" := ROUND(JobJnlLine."Total Cost (LCY)" / JobJnlLine.Quantity, Currency."Unit-Amount Rounding Precision");
        JobJnlLine."Direct Unit Cost (LCY)" := JobJnlLine."Unit Cost (LCY)";
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforeItemJnlPostLine, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforeItemJnlPostLine(VAR Sender: Codeunit 90; VAR ItemJournalLine: Record 83; PurchaseLine: Record 39; PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    VAR
        Currency: Record 4;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 12/07/22: - DP 1.00.03 Aumentar el gasto en el producto por la prorrata
        //-------------------------------------------------------------------------------------------------------------------
        IF (PurchaseLine."DP Non Deductible VAT amount" = 0) OR (ItemJournalLine."Invoiced Quantity" = 0) THEN   //JAV 14/05/22: - QP 1.00.04 Va sobre la cantidad facturada, no sobre la general
            EXIT;

        Currency.InitRoundingPrecision;

        ItemJournalLine.Amount += PurchaseLine."DP Non Deductible VAT amount";
        ItemJournalLine."Unit Cost" := ROUND(ItemJournalLine.Amount / ItemJournalLine."Invoiced Quantity", Currency."Unit-Amount Rounding Precision");
    END;

    LOCAL PROCEDURE "---------------------------------------------------------------------- GLOBALES"();
    BEGIN
    END;

    LOCAL PROCEDURE GetDimValueFromID(pDimension: Code[20]; pDimensionSetID: Integer): Code[20];
    VAR
        DimensionManagement: Codeunit 408;
        TempDimSetEntry: Record 480 TEMPORARY;
        DimensionValue: Record 349;
    BEGIN
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //JAV 26/04/22: - QB 1.10.37 Esta funci�n actualiza un valor de dimensi�n en un registro de una tabla que tenga campos para las dimensiones globales
        // Par�metros de entrada :
        //    pDimension        : C�digo de la dimensi�n
        //    pDimensionSetID   : Valor del ID de dimensones
        // Par�metros de salida : Valor de la dimension o blancos
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //Montar la tabla auxiliar
        DimensionManagement.GetDimensionSet(TempDimSetEntry, pDimensionSetID);
        //Si est� entre las dimensiones y ha cambiado la eliminamos
        IF (TempDimSetEntry.GET(pDimensionSetID, pDimension)) THEN
            EXIT(TempDimSetEntry."Dimension Value Code");

        EXIT('');
    END;

    LOCAL PROCEDURE "--------------------------------------------------------------------- Calculos de la definitiva"();
    BEGIN
    END;

    PROCEDURE GenerateYear();
    VAR
        DPProrrataPercentajes: Record 7174351;
        InputIntegerDialog: Page 7174352;
        YearCalc: Integer;
        Type: Option;
        Percentaje: Decimal;
    BEGIN
        //JAV 21/06/22: - DP 1.00.00 Crear un nuevo ejercicio para la prorrata. Basado en CEI14253 con modificaciones
        //JAV 05/07/22: - DP 1.00.02 Se pasan funciones de la tabla y las pages a esta CU que es lo adecuado.

        DPProrrataPercentajes.RESET;
        IF DPProrrataPercentajes.FINDLAST THEN
            YearCalc := DATE2DMY(DPProrrataPercentajes."Starting Date", 3) + 1
        ELSE
            YearCalc := DATE2DMY(TODAY, 3);

        CLEAR(InputIntegerDialog);
        InputIntegerDialog.SetData(0, YearCalc);
        InputIntegerDialog.LOOKUPMODE(TRUE);
        IF (InputIntegerDialog.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            InputIntegerDialog.GetData1(YearCalc, Type, Percentaje);
            IF YearCalc = 0 THEN
                ERROR(Txt005);

            DPProrrataPercentajes.INIT;
            DPProrrataPercentajes."Starting Date" := DMY2DATE(1, 1, YearCalc);
            DPProrrataPercentajes."Ending Date" := DMY2DATE(31, 12, YearCalc);
            DPProrrataPercentajes."Application Year" := YearCalc;
            DPProrrataPercentajes."Prorrata Calc. Type" := Type;
            DPProrrataPercentajes."Prorrata %" := Percentaje;
            DPProrrataPercentajes.INSERT;
        END;
    END;

    PROCEDURE CalculateFinalProrrataPercentage(Rec: Record 7174351);
    VAR
        GLEntry: Record 17;
        VATPostingSetup: Record 325;
        DPProrrataPercentajes: Record 7174351;
        ImporteNoSujeto: Decimal;
        ImporteSujeto: Decimal;
        i: Integer;
    BEGIN
        //JAV 05/07/22: - DP 1.00.03 Calcular el porcentaje de prorrata y el resto de campos de la tabla que le corresponde al ejercicio
        //JAV 05/07/22: - DP 1.00.02 Se pasan funciones de la tabla y las pages a esta CU que es lo adecuado.

        ImporteNoSujeto := 0;
        ImporteSujeto := 0;
        Window.OPEN('#1###########################/' +
                     '@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        CalculateFinalProrrataSales(Rec);       //Calcular importes de ventas del ejercicio
        CalculateFinalProrrataPurchase(Rec);    //Calcular importes de compras del ejercicio
        CalculateFinalProrrataVATApplied(Rec);  //Calcular importe de IVA aplicado en el ejercicio

        //Ver si es posible cambiar el tipo a utilizar, si la general es mayor al 10% de la especial hay que usar la especial
        IF (Rec."General prorrata Amount" > (Rec."Special prorrata Amount" * 1.1)) THEN BEGIN
            Rec."New Prorrata Type" := Rec."New Prorrata Type"::Special;
        END ELSE BEGIN
            //Si no es as�, solo se puede cambiar si han pasado tres a�os con la especial
            DPProrrataPercentajes.RESET;
            DPProrrataPercentajes.SETFILTER("Starting Date", '%1..%2', DMY2DATE(1, 1, Rec."Application Year" - 3), DMY2DATE(31, 12, Rec."Application Year"));
            DPProrrataPercentajes.SETRANGE("Prorrata Calc. Type", DPProrrataPercentajes."Prorrata Calc. Type"::Special);
            IF DPProrrataPercentajes.COUNT = 3 THEN  //Si los tres �ltimos a�os han sido de especial
                Rec."New Prorrata Type" := Rec."New Prorrata Type"::General
            ELSE
                Rec."New Prorrata Type" := Rec."New Prorrata Type"::Special;
        END;

        Rec."Final Prorrata Calculated" := TRUE;
        Rec.MODIFY;

        Window.CLOSE;
    END;

    LOCAL PROCEDURE CalculateFinalProrrataSales(VAR Rec: Record 7174351);
    VAR
        GLEntry: Record 17;
        VATPostingSetup: Record 325;
        ImporteNoSujeto: Decimal;
        ImporteSujeto: Decimal;
        n1: Integer;
        nt: Integer;
    BEGIN
        //JAV 05/07/22: - DP 1.00.03 Calcular los datos de ventas del ejercicio

        Window.UPDATE(1, 'Calculando ventas');
        ImporteNoSujeto := 0;
        ImporteSujeto := 0;

        GLEntry.RESET;
        GLEntry.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
        GLEntry.SETRANGE("Gen. Posting Type", GLEntry."Gen. Posting Type"::Sale);
        n1 := 0;
        nt := GLEntry.COUNT;
        IF (GLEntry.FINDSET(FALSE)) THEN
            REPEAT
                n1 += 1;
                Window.UPDATE(2, (n1 DIV nt) * 10000);

                IF VATPostingSetup.GET(GLEntry."VAT Bus. Posting Group", GLEntry."VAT Prod. Posting Group") THEN BEGIN
                    CASE VATPostingSetup."VAT Calculation Type" OF
                        VATPostingSetup."VAT Calculation Type"::"No Taxable VAT":
                            ImporteNoSujeto += GLEntry.Amount;
                        VATPostingSetup."VAT Calculation Type"::"Normal VAT", VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            ImporteSujeto += GLEntry.Amount;
                    END;
                END;
            UNTIL (GLEntry.NEXT = 0);

        ImporteNoSujeto -= 547157.25;  ///// Solo para pruebas


        Rec."Deductible Sales" := ABS(ImporteSujeto);
        Rec."Total Sales" := ABS(ImporteSujeto + ImporteNoSujeto);
        IF (Rec."Total Sales" = 0) THEN
            Rec."Final Prorrata %" := 0
        ELSE
            Rec."Final Prorrata %" := ROUND((Rec."Deductible Sales" / Rec."Total Sales") * 100, 1);
    END;

    LOCAL PROCEDURE CalculateFinalProrrataPurchase(Rec: Record 7174351);
    VAR
        GenlLedSet: Record 98;
        NewDPProrrataPercentajes: Record 7174351;
        OtherDPProrrataPercentajes: Record 7174351;
        GLEntry: Record 17;
        SumAmoundDeductibleSales: Decimal;
        DimensionValue: Record 349;
        NewProrrata: Decimal;
        PctNewProrrata: Decimal;
        SumAmoundSales: Decimal;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
        VATEntry: Record 254;
        DeductibleBasePurchases: Decimal;
        DeductiblePurchasesGeneral: Decimal;
        DeductiblePurchasesSpecial: Decimal;
        NonDeductibleBasePurchases: Decimal;
        NonDeductiblePurchasesGeneral: Decimal;
        JointBasePurchases: Decimal;
        JointPurchases: Decimal;
        ProvisionalVATdeducted: Decimal;
        DeductibleBaseCreditMemo: Decimal;
        DeductibleCreditMemoGeneral: Decimal;
        DeductibleCreditMemoSpecial: Decimal;
        NonDeductibleBaseCreditMemo: Decimal;
        NonDeductibleCreditMemoGeneral: Decimal;
        JointBaseCreditMemo: Decimal;
        JointCreditMemo: Decimal;
        NonDeductibleBase: Decimal;
        countr: Integer;
        LastYear: Integer;
        counterYears: Integer;
    BEGIN
        //JAV 05/07/22: - DP 1.00.03 Calcular los datos de ventas del ejercicio

        Window.UPDATE(1, 'Calculando compras');
        GenlLedSet.GET;

        //Calculo de los importes de facturas de compra
        DeductibleBasePurchases := 0;
        DeductiblePurchasesGeneral := 0;
        DeductiblePurchasesSpecial := 0;
        NonDeductibleBasePurchases := 0;
        NonDeductiblePurchasesGeneral := 0;
        JointBasePurchases := 0;
        JointPurchases := 0;

        PurchInvHeader.RESET;
        PurchInvHeader.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
        PurchCrMemoHdr.RESET;
        PurchCrMemoHdr.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
        n1 := 0;
        nt := PurchInvHeader.COUNT + PurchCrMemoHdr.COUNT;

        //Recorrer las facturas
        IF PurchInvHeader.FINDFIRST THEN
            REPEAT
                n1 += 1;
                Window.UPDATE(2, (n1 DIV nt) * 10000);

                VATEntry.RESET;
                VATEntry.SETFILTER(Type, '=%1', VATEntry.Type::Purchase);
                VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    CASE PurchInvHeader."DP Prorrata %" OF
                        100:
                            BEGIN
                                DeductibleBasePurchases += VATEntry.Base;
                                DeductiblePurchasesGeneral += ((VATEntry.Base * VATEntry."VAT %") * Rec."Final Prorrata %");
                                DeductiblePurchasesSpecial += (VATEntry.Base * VATEntry."VAT %");
                            END;
                        0:
                            BEGIN
                                NonDeductibleBasePurchases += VATEntry.Base;
                                NonDeductiblePurchasesGeneral += ((VATEntry.Base * VATEntry."VAT %") * Rec."Final Prorrata %");
                            END;
                        ELSE BEGIN
                            JointBasePurchases += VATEntry.Base;
                            JointPurchases += (VATEntry.Base * VATEntry."VAT %" * Rec."Final Prorrata %")
                        END;
                    END;
                END;
            UNTIL PurchInvHeader.NEXT = 0;
        ;

        //Recorrer los abonos
        IF PurchCrMemoHdr.FINDFIRST THEN
            REPEAT
                n1 += 1;
                Window.UPDATE(2, (n1 DIV nt) * 10000);

                VATEntry.RESET;
                VATEntry.SETFILTER(Type, '=%1', VATEntry.Type::Purchase);
                VATEntry.SETFILTER("Document No.", PurchCrMemoHdr."No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    CASE PurchInvHeader."DP Prorrata %" OF
                        100:
                            BEGIN
                                DeductibleBaseCreditMemo += VATEntry.Base;
                                DeductibleCreditMemoGeneral += ((VATEntry.Base * VATEntry."VAT %") * Rec."Final Prorrata %");
                                DeductibleCreditMemoSpecial += (VATEntry.Base * VATEntry."VAT %");
                            END;
                        0:
                            BEGIN
                                NonDeductibleBasePurchases += VATEntry.Base;
                                NonDeductiblePurchasesGeneral += ((VATEntry.Base * VATEntry."VAT %") * Rec."Final Prorrata %");
                            END;
                        ELSE BEGIN
                            JointBasePurchases += VATEntry.Base;
                            JointPurchases += (VATEntry.Base * VATEntry."VAT %" * Rec."Final Prorrata %")
                        END;
                    END;
                END;
            UNTIL PurchInvHeader.NEXT = 0;

        Rec."Deductible Base Purchases" := ROUND(DeductibleBasePurchases + DeductibleBaseCreditMemo, GenlLedSet."Amount Rounding Precision");
        Rec."Deductible Purchases General" := ROUND(DeductiblePurchasesGeneral + DeductibleCreditMemoGeneral, GenlLedSet."Amount Rounding Precision");
        Rec."Deductible Purchases Special" := ROUND(DeductiblePurchasesSpecial + DeductibleCreditMemoSpecial, GenlLedSet."Amount Rounding Precision");
        Rec."Non-deductible Base Purchases" := ROUND(NonDeductibleBasePurchases, GenlLedSet."Amount Rounding Precision");
        Rec."Non-deductible Purchases Gral." := ROUND(NonDeductiblePurchasesGeneral, GenlLedSet."Amount Rounding Precision");
        Rec."Joint Base Purchases" := JointBasePurchases;
        Rec."Joint Purchases" := JointPurchases;
        Rec."General prorrata Amount" := Rec."Deductible Purchases General" + Rec."Non-deductible Purchases Gral." + Rec."Joint Purchases";
        Rec."Special prorrata Amount" := Rec."Deductible Purchases Special" + Rec."Joint Purchases";
    END;

    LOCAL PROCEDURE CalculateFinalProrrataVATApplied(Rec: Record 7174351);
    VAR
        VATEntry: Record 254;
        ProvisionalVATdeducted: Decimal;
    BEGIN
        //JAV 05/07/22: - DP 1.00.03 Calcular los datos del IVA realmente aplicado del ejercicio

        Window.UPDATE(1, 'IVA provisional aplicado');

        //Calculo "Provisional VAT deducted" se obtendr  como suma del valor del "Amount" de todos los registros de la tabla 254 "VAT Entry"
        //cuyo campo Type tenga el valor Purchase y el campo Posting Date este entre el 01/01 al 31/12 del a¤o indicado en la Request Page del proceso.
        ProvisionalVATdeducted := 0;
        VATEntry.RESET;
        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
        VATEntry.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
        n1 := 0;
        nt := VATEntry.COUNT;
        IF VATEntry.FINDSET(FALSE) THEN
            REPEAT
                n1 += 1;
                Window.UPDATE(2, (n1 DIV nt) * 10000);
                ProvisionalVATdeducted += VATEntry.Amount;
            UNTIL VATEntry.NEXT = 0;

        Rec."Provisional VAT deducted" := ProvisionalVATdeducted;
    END;

    PROCEDURE ApplyFinalProrrata(Rec: Record 7174351);
    VAR
        NewDPProrrataPercentajes: Record 7174351;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------
        //JAV 05/07/22: - Aplicar la prorrata final calculada y crear un nuevo ejercicio. Basado en CEI14253 con modificaciones
        //-----------------------------------------------------------------------------------------------------------------------------
        //JAV 05/07/22: - DP 1.00.02 Se pasan funciones de la tabla y las pages a esta CU que es lo adecuado.

        IF NOT Rec."Final Prorrata Calculated" THEN
            ERROR(Txt012);

        IF Rec."Final Prorrata" THEN
            ERROR(Txt010);

        IF Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::" " THEN
            ERROR(Txt011);

        //Los importes y porcentajes ya se han calculado anteriormente

        //"Application difference" calcula por diferencia entre el IVA provisional deducido y el importe de prorrata aplicable.
        //Ademas este campo se indicar  en la declaraci¢n 303 de £ltimo periodo, en el campo de pregunta habilitado para ello.
        //En base al valor de "prorrata Calc. Type":
        //   Si tiene el valor "General" se calcular  como "Provisional VAT deducted" - "General prorrata Amount";
        //   Si tiene el valor "Special" se calcular  como "Provisional VAT deducted" - "Special prorrata Amount".
        IF Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::General THEN
            Rec."Application difference" := Rec."Provisional VAT deducted" - Rec."General prorrata Amount"
        ELSE IF Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::Special THEN
            Rec."Application difference" := Rec."Provisional VAT deducted" - Rec."Special prorrata Amount";

        //Marcamos que hemos calculado la prorrata final y guardamos
        Rec."Final Prorrata" := TRUE;
        Rec.MODIFY;

        //Inserci¢n de registro nuevo de siguiente a¤o.
        NewDPProrrataPercentajes.SETRANGE("Application Year", Rec."Application Year" + 1);
        IF NewDPProrrataPercentajes.FINDFIRST THEN
            NewDPProrrataPercentajes.DELETE;

        NewDPProrrataPercentajes.INIT;
        NewDPProrrataPercentajes."Starting Date" := DMY2DATE(1, 1, Rec."Application Year" + 1);
        NewDPProrrataPercentajes."Ending Date" := DMY2DATE(31, 12, Rec."Application Year" + 1);
        NewDPProrrataPercentajes."Application Year" := Rec."Application Year" + 1;
        NewDPProrrataPercentajes."Prorrata %" := Rec."Prorrata %";
        NewDPProrrataPercentajes."Prorrata Calc. Type" := Rec."New Prorrata Type";
        NewDPProrrataPercentajes."Final Prorrata" := FALSE;
        NewDPProrrataPercentajes.INSERT;

        //Actualizar los movimientos de IVA
        UpdateVATEntry(Rec);
    END;

    PROCEDURE UpdateVATEntry(Rec: Record 7174351);
    VAR
        VATEntry: Record 254;
        VATPostingSetup: Record 325;
        ProrrataDefinitiva: Decimal;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------
        //JAV 05/07/22: - DP 1.00.02 Se incluye el proceso del report "DP Update def. Prorrata" que traspasa el % definitivo a los movimientos de IVA
        //-----------------------------------------------------------------------------------------------------------------------------

        Window.OPEN('Ajustando prorrata definitiva\' +
                    '#2############################\' +
                    '@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        IF (Rec."Final Prorrata % Manual" <> 0) THEN
            ProrrataDefinitiva := Rec."Final Prorrata % Manual"
        ELSE
            ProrrataDefinitiva := Rec."Final Prorrata %";

        VATEntry.RESET;
        VATEntry.SETRANGE("Posting Date", Rec."Starting Date", Rec."Ending Date");
        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
        VATEntry.SETFILTER("DP Prorrata Type", '<>%1', VATEntry."DP Prorrata Type"::" ");
        nt := VATEntry.COUNT;
        n1 := 0;
        IF (VATEntry.FINDSET(FALSE)) THEN
            REPEAT
                n1 += 1;
                Window.UPDATE(2, VATEntry."Entry No.");
                Window.UPDATE(3, (n1 DIV nt) * 10000);

                VATEntry."DP Prorrata Type" := VATEntry."DP Prorrata Type"::Definitiva;
                VATEntry."DP Def. Prorrata %" := ProrrataDefinitiva;

                VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                IF (VATPostingSetup."VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") THEN
                    VATEntry."DP Prorrata Def. VAT Amount" := ROUND(VATEntry."DP Original VAT Amount" * (ProrrataDefinitiva / 100), 0.01)
                ELSE
                    VATEntry."DP Prorrata Def. VAT Amount" := 0;

                VATEntry.MODIFY;
            UNTIL (VATEntry.NEXT = 0);

        Window.CLOSE;
    END;


    /*BEGIN
    /*{
          JAV 21/06/22: - DP 1.00.00 Se a�ade nueva CU para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
                                     Se unifica en esta CU lo que en Mercabarna estaba en otras 4.
                                     Se modifica ampliamente el manejo
          JAV 04/07/22: - DP 1.00.02 Se eliminan variables no usadas y las funciones que no se usan:
                                       CU90_OnAfterFinalizePosting, CU12_OnBeforeStartOrContinuePosting, T254_OnBeforeInsertEvent, CheckProrrataSetup, GetProrrataPercentage, ChangeProrrataGenJnlLine,
                                       TotalVAT, GetCurrencyExchRate, GetCurrency, ChangeProrrataGenJnlLinePurchPost, CalcOVerdueBalanceLCY, GetNextLineNo, CheckVATPostingSetup,
                                       CreateGenJournalProrrataInvoice, CreateGenJournalProrrataCrMemo, ChangeProrataGenJnlLine, PostGeneralJournal
          JAV 05/07/22: - DP 1.00.02 Se pasan funciones de la tabla y las pages a esta CU que es lo adecuado.
                                     Se mejoran las funciones de c�lculo de la definitiva, se divide en dos partes una calcula y otra aplica.
                                     Se incluye el proceso del report "DP Update def. Prorrata" que traspasa el % definitivo a los movimientos de IVA
          JAV 12/07/22: - DP 1.00.03 Nueva funci�n CU1004_OnAfterFromPurchaseLineToJnlLine para aumentar el gasto en el proyecto por la prorrata
          JAV 14/07/22: - DP 1.00.04 Se a�aden funciones para el IVA no deducible general: AccessToNonDeductible, T39_OnAfterValidateEvent_DPNonDeductibleVATLine, T39_OnAfterValidateEvent_DPNonDeductibleVATPorc
                                     Cambios generales para a�adir el c�lculo del IVA no deducible. Se eliminan las funciones no usuadas GetFinalProrrataPercentage y BuscarInicioFinEjercicio
          JAV 28/09/22: - DP 1.00.05 Mejora en el manejo de la prorrata cuando no est� activa
        }
    END.*/
}










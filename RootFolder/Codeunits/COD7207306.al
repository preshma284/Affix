Codeunit 7207306 "Withholding Treating"
{


    Permissions = TableData 111 = rimd,
                TableData 113 = rimd,
                TableData 115 = rimd,
                TableData 121 = rimd,
                TableData 123 = rimd,
                TableData 125 = rimd,
                TableData 6651 = rimd,
                TableData 6661 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        OptType: Option "GE","PIT";
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = 'No ha definido forma de pago de liberaci�n de retenciones en el grupo de retenciones por %1: %2';
        Text001: TextConst ESP = 'No existe la forma de pago %1';

    LOCAL PROCEDURE "----------------------------------------- Calculo de las retenciones en los documentos registrados de Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 50105, OnAfterPostPurchLines, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostPurchLines(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShipmentHeader: Record 6650; WhseShip: Boolean; WhseReceive: Boolean; VAR PurchLinesProcessed: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones en documentos de compra registrados

        IF (ReturnShipmentHeader."No." <> '') THEN
            CU90_AdjustReturnShipment(ReturnShipmentHeader);

        IF (PurchInvHeader."No." <> '') THEN
            CU90_AdjustPurchaseInvoice(PurchInvHeader);

        IF (PurchCrMemoHdr."No." <> '') THEN
            CU90_AdjustPurchaseCrMemo(PurchCrMemoHdr);
    END;

    LOCAL PROCEDURE CU90_AdjustReturnShipment(VAR Rec: Record 6650);
    VAR
        RecLine: Record 6651;
    BEGIN
        //JAV 19/09/19: - Se eliminan las retenciones en un albar�n de compra registrado

        RecLine.RESET;
        RecLine.SETRANGE("Document No.", Rec."No.");
        RecLine.SETRANGE("QW Withholding by GE Line", TRUE);
        RecLine.DELETEALL;
    END;

    LOCAL PROCEDURE CU90_AdjustPurchaseInvoice(VAR Rec: Record 122);
    VAR
        RecLine: Record 123;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones en una factura de compra registrada

        //Copiar el documento a uno de compra provisional
        PurchaseHeader.TRANSFERFIELDS(Rec);
        PurchaseHeader."Document Type" := Enum::"Purchase Document Type".FromInteger(99);
        PurchaseHeader.INSERT;

        RecLine.RESET;
        RecLine.SETRANGE("Document No.", Rec."No.");
        IF (RecLine.FINDSET) THEN
            REPEAT
                IF (RecLine."QW Withholding by G.E Line") THEN
                    RecLine.DELETE
                ELSE BEGIN
                    PurchaseLine.TRANSFERFIELDS(RecLine);
                    PurchaseLine."Document Type" := Enum::"Purchase Document Type".FromInteger(99);
                    PurchaseLine.INSERT;
                END;
            UNTIL (RecLine.NEXT = 0);

        //Calcular las retenciones
        CalculateWithholding_PurchaseHeader(PurchaseHeader);

        //Pasar las retenciones a las l�neas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", 99);
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF (PurchaseLine.FINDSET(FALSE)) THEN
            REPEAT
                IF (RecLine.GET(Rec."No.", PurchaseLine."Line No.")) THEN BEGIN
                    RecLine."QW % Withholding by GE" := PurchaseLine."QW % Withholding by GE";
                    RecLine."QW Withholding Amount by GE" := PurchaseLine."QW Withholding Amount by GE";
                    RecLine."QW % Withholding by PIT" := PurchaseLine."QW % Withholding by PIT";
                    RecLine."QW Withholding Amount by PIT" := PurchaseLine."QW Withholding Amount by PIT";
                    RecLine."QW Not apply Withholding GE" := PurchaseLine."QW Not apply Withholding GE";
                    RecLine."QW Not apply Withholding PIT" := PurchaseLine."QW Not apply Withholding PIT";
                    RecLine."QW Base Withholding by GE" := PurchaseLine."QW Base Withholding by GE";
                    RecLine."QW Base Withholding by PIT" := PurchaseLine."QW Base Withholding by PIT";
                    RecLine."QW Withholding by G.E Line" := PurchaseLine."QW Withholding by GE Line";
                    RecLine.MODIFY;
                END ELSE BEGIN
                    RecLine.TRANSFERFIELDS(PurchaseLine);
                    RecLine.INSERT;
                END;
            UNTIL (PurchaseLine.NEXT = 0);


        //Eliminar el documento provisional
        PurchaseHeader.DELETE;

        PurchaseLine.SETRANGE("Document Type", 99);
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.DELETEALL;
    END;

    LOCAL PROCEDURE CU90_AdjustPurchaseCrMemo(VAR Rec: Record 124);
    VAR
        RecLine: Record 125;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones en una factura de compra registrada

        //Copiar el documento a uno de compra provisional
        PurchaseHeader.TRANSFERFIELDS(Rec);
        PurchaseHeader."Document Type" := Enum::"Purchase Document Type".FromInteger(99);
        PurchaseHeader.INSERT;

        RecLine.RESET;
        RecLine.SETRANGE("Document No.", Rec."No.");
        IF (RecLine.FINDSET) THEN
            REPEAT
                IF (RecLine."QW Withholding by GE Line") THEN
                    RecLine.DELETE
                ELSE BEGIN
                    PurchaseLine.TRANSFERFIELDS(RecLine);
                    PurchaseLine."Document Type" := Enum::"Purchase Document Type".FromInteger(99);
                    PurchaseLine.INSERT;
                END;
            UNTIL (RecLine.NEXT = 0);

        //Calcular las retenciones
        CalculateWithholding_PurchaseHeader(PurchaseHeader);

        //Pasar las retenciones a las l�neas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", 99);
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF (PurchaseLine.FINDSET(FALSE)) THEN
            REPEAT
                IF (RecLine.GET(Rec."No.", PurchaseLine."Line No.")) THEN BEGIN
                    RecLine."QW % Withholding by GE" := PurchaseLine."QW % Withholding by GE";
                    RecLine."QW Withholding Amount by GE" := PurchaseLine."QW Withholding Amount by GE";
                    RecLine."QW % Withholding by PIT" := PurchaseLine."QW % Withholding by PIT";
                    RecLine."QW Withholding Amount by PIT" := PurchaseLine."QW Withholding Amount by PIT";
                    RecLine."QW Not apply Withholding GE" := PurchaseLine."QW Not apply Withholding GE";
                    RecLine."QW Not apply Withholding PIT" := PurchaseLine."QW Not apply Withholding PIT";
                    RecLine."QW Base Withholding by GE" := PurchaseLine."QW Base Withholding by GE";
                    RecLine."QW Base Withholding by PIT" := PurchaseLine."QW Base Withholding by PIT";
                    RecLine."QW Withholding by GE Line" := PurchaseLine."QW Withholding by GE Line";
                    RecLine.MODIFY;
                END ELSE BEGIN
                    RecLine.TRANSFERFIELDS(PurchaseLine);
                    RecLine.INSERT;
                END;
            UNTIL (PurchaseLine.NEXT = 0);


        //Eliminar el documento provisional
        PurchaseHeader.DELETE;

        PurchaseLine.SETRANGE("Document Type", 99);
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.DELETEALL;
    END;

    LOCAL PROCEDURE "----------------------------------------- Calculo de las retenciones en los documentos de Compra"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeInsertEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones
        IF (RunTrigger) THEN
            CalculateWithholding_PurchaseLine(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeModifyEvent(VAR Rec: Record 39; VAR xRec: Record 39; RunTrigger: Boolean);
    BEGIN
        //JAV 19/09/19 - Se recalculan las retenciones
        IF (RunTrigger) THEN
            CalculateWithholding_PurchaseLine(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeDeleteEvent(VAR Rec: Record 39; RunTrigger: Boolean);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede eliminar la l¡nea de retenci¢n de B.E. en factura.';
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones
        IF (RunTrigger) THEN BEGIN
            //JAV 19/10/19: - No dejar borrar la l�nea de la retenci�n
            IF (Rec."QW Withholding by GE Line") THEN
                ERROR(Text001);
            CalculateWithholding_PurchaseLine(Rec, TRUE);
        END;
    END;

    PROCEDURE CalculateWithholding_PurchaseHeader(VAR PurchaseHeader: Record 38);
    VAR
        PurchaseLine: Record 39;
        Calculated: Boolean;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula todos los importes de retenciones de las l�neas de una factura de compra
        //JAV 19/10/19: - Mejora para que no se calculen varias veces la retecni�n de factura
        IF NOT FunctionQB.AccessToWithholding THEN
            EXIT;

        Calculated := FALSE;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF (PurchaseLine.FINDSET(TRUE)) THEN
            REPEAT
                CalculateWithholding_PurchaseLine_All(PurchaseLine, FALSE, Calculated);
                PurchaseLine.MODIFY(FALSE);
            UNTIL (PurchaseLine.NEXT = 0);
    END;

    PROCEDURE CalculateWithholding_PurchaseLine(VAR PurchaseLine: Record 39; pDelete: Boolean): Boolean;
    VAR
        Calculated: Boolean;
    BEGIN
        //JAV 19/10/19: - Funci�n que calcula importes de retenciones de una �nica l�nea de compra
        CalculateWithholding_PurchaseLine_All(PurchaseLine, pDelete, Calculated);
    END;

    PROCEDURE CalculateWithholding_PurchaseLine_All(VAR PurchaseLine: Record 39; pDelete: Boolean; VAR pCalculated: Boolean): Boolean;
    VAR
        Calculated: Boolean;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula importes de retenciones de una l�nea de compra de un documento
        //JAV 19/10/19: - Mejora para que no se calculen varias veces la retecni�n de factura
        IF NOT FunctionQB.AccessToWithholding THEN
            EXIT;

        //No recalculamos para las l�neas  retenci�n en factura
        IF (PurchaseLine."QW Withholding by GE Line") THEN
            EXIT;

        //Calculamos retenci�n de Buena Ejecuci�n cuando es retenci�n con factura que va antes de la base imponible. Esto solo hay que hacerlo una vez para cada factura
        IF NOT pCalculated THEN
            pCalculated := CalculateWithholding_PurchaseLine_GE_Invoice(PurchaseLine, pDelete);

        //Calculamos retenci�n de IRPF. Sobre la base siempre
        IF (NOT pDelete) THEN
            CalculateWithholding_PurchaseLine_PIT(PurchaseLine);

        //Calculamos retenci�n de Buena Ejecuci�n cuando es retenci�n de pago va siempre sobre el total de la factura
        IF (NOT pDelete) THEN
            CalculateWithholding_PurchaseLine_GE_Payment(PurchaseLine);
    END;

    PROCEDURE CalculateWithholding_PurchaseLine_PIT(VAR PurchaseLine: Record 39);
    VAR
        PurchaseHeader: Record 38;
        WithholdingGroup: Record 7207330;
        Currency: Record 4;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula importes de la retenci�n por IRPF de una l�nea de compra

        PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        IF (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::PIT, PurchaseHeader."QW Cod. Withholding by PIT")) THEN
            CLEAR(WithholdingGroup);

        IF (PurchaseLine."QW Not apply Withholding PIT") OR (WithholdingGroup."Percentage Withholding" = 0) THEN BEGIN
            PurchaseLine."QW Base Withholding by PIT" := 0;
            PurchaseLine."QW % Withholding by PIT" := 0;
            PurchaseLine."QW Withholding Amount by PIT" := 0;
        END ELSE BEGIN
            IF (NOT Currency.GET(PurchaseHeader."Currency Code")) THEN
                CLEAR(Currency);
            Currency.InitRoundingPrecision;

            PurchaseLine."QW % Withholding by PIT" := WithholdingGroup."Percentage Withholding";
            CASE WithholdingGroup."Withholding Base" OF
                WithholdingGroup."Withholding Base"::"Invoice Amount":
                    PurchaseLine."QW Base Withholding by PIT" := PurchaseLine.Amount;
                WithholdingGroup."Withholding Base"::"Amount Including VAT":
                    PurchaseLine."QW Base Withholding by PIT" := PurchaseLine."Amount Including VAT";
            END;
            PurchaseLine."QW Withholding Amount by PIT" := ROUND(PurchaseLine."QW Base Withholding by PIT" * PurchaseLine."QW % Withholding by PIT" / 100,
                                                              Currency."Amount Rounding Precision");
        END;
    END;

    PROCEDURE CalculateWithholding_PurchaseLine_GE_Payment(VAR PurchaseLine: Record 39);
    VAR
        PurchaseHeader: Record 38;
        WithholdingGroup: Record 7207330;
        Currency: Record 4;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula importes de la retenci�n de garant�a con retenci�n de pago de una l�nea de compra

        PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        IF (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", PurchaseHeader."QW Cod. Withholding by GE")) THEN
            CLEAR(WithholdingGroup);

        IF (WithholdingGroup."Withholding treating" <> WithholdingGroup."Withholding treating"::"Payment Withholding") OR
           (PurchaseLine."QW Not apply Withholding GE") OR (WithholdingGroup."Percentage Withholding" = 0) THEN BEGIN
            PurchaseLine."QW Base Withholding by GE" := 0;
            PurchaseLine."QW % Withholding by GE" := 0;
            PurchaseLine."QW Withholding Amount by GE" := 0;
        END ELSE BEGIN
            IF (NOT Currency.GET(PurchaseHeader."Currency Code")) THEN
                CLEAR(Currency);
            Currency.InitRoundingPrecision;

            IF (WithholdingGroup."Withholding treating" = WithholdingGroup."Withholding treating"::"Payment Withholding") THEN BEGIN
                IF (NOT PurchaseLine."QW Not apply Withholding GE") THEN BEGIN
                    PurchaseLine."QW % Withholding by GE" := WithholdingGroup."Percentage Withholding";
                    CASE WithholdingGroup."Withholding Base" OF
                        WithholdingGroup."Withholding Base"::"Invoice Amount":
                            PurchaseLine."QW Base Withholding by GE" := PurchaseLine.Amount;
                        WithholdingGroup."Withholding Base"::"Amount Including VAT":
                            PurchaseLine."QW Base Withholding by GE" := PurchaseLine."Amount Including VAT" - PurchaseLine."QW Withholding Amount by PIT";
                    END;
                    PurchaseLine."QW Withholding Amount by GE" := ROUND(PurchaseLine."QW Base Withholding by GE" * PurchaseLine."QW % Withholding by GE" / 100,
                                                                      Currency."Amount Rounding Precision");
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE CalculateWithholding_PurchaseLine_GE_Invoice(PurchaseLine: Record 39; pDelete: Boolean): Boolean;
    VAR
        PurchaseHeader: Record 38;
        WithholdingGroup: Record 7207330;
        Currency: Record 4;
        PurchaseLineW: Record 39;
        NLine: Integer;
        i: Integer;
        bAux: Boolean;
        Ocupado: ARRAY[10] OF Boolean;
        Amount: ARRAY[10] OF Decimal;
        GrupoRegGen: ARRAY[10] OF Code[20];
        GrupoIVANeg: ARRAY[10] OF Code[20];
        GrupoIVAPro: ARRAY[10] OF Code[20];
        PorcIVA: ARRAY[10] OF Decimal;
    BEGIN
        //JAV 11/08/19: - Funci�n que a�ade o modifica la l�nea de la retenci�n de B.E. con factura

        PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        IF (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", PurchaseHeader."QW Cod. Withholding by GE")) THEN
            CLEAR(WithholdingGroup);
        IF (NOT Currency.GET(PurchaseHeader."Currency Code")) THEN
            CLEAR(Currency);
        Currency.InitRoundingPrecision;

        //Borro las l�neas de la retenci�n si las tuviera
        CalculateWithholding_PurchaseLine_GE_Invoice_Delete(ConvertDocumentTypeToOptionPurchaseDocumentType(PurchaseLine."Document Type"), PurchaseLine."Document No.");

        IF (WithholdingGroup."Withholding treating" = WithholdingGroup."Withholding treating"::"Pending Invoice") THEN BEGIN
            CLEAR(Amount);
            CLEAR(GrupoRegGen);
            CLEAR(GrupoIVAPro);
            CLEAR(GrupoIVANeg);
            CLEAR(PorcIVA);
            bAux := FALSE;

            //Busco el importe total
            PurchaseLineW.RESET;
            PurchaseLineW.SETRANGE("Document Type", PurchaseLine."Document Type");
            PurchaseLineW.SETRANGE("Document No.", PurchaseLine."Document No.");
            PurchaseLineW.SETRANGE("QW Not apply Withholding GE", FALSE);
            PurchaseLine.SETFILTER(Amount, '<> 0');
            IF (PurchaseLineW.FINDSET) THEN
                REPEAT
                    IF (PurchaseLineW."Line No." = PurchaseLine."Line No.") THEN BEGIN
                        IF (NOT pDelete) THEN
                            CalculateWithholding_PurchaseLine_GE_Invoice_Sum(PurchaseLine, Ocupado, Amount, GrupoRegGen, GrupoIVANeg, GrupoIVAPro, PorcIVA);
                        bAux := TRUE;
                    END ELSE
                        CalculateWithholding_PurchaseLine_GE_Invoice_Sum(PurchaseLineW, Ocupado, Amount, GrupoRegGen, GrupoIVANeg, GrupoIVAPro, PorcIVA);
                UNTIL (PurchaseLineW.NEXT = 0);

            IF (NOT bAux) THEN
                CalculateWithholding_PurchaseLine_GE_Invoice_Sum(PurchaseLine, Ocupado, Amount, GrupoRegGen, GrupoIVANeg, GrupoIVAPro, PorcIVA);

            //Busco la �ltima l�nea
            PurchaseLineW.RESET;
            PurchaseLineW.SETRANGE("Document Type", PurchaseLine."Document Type");
            PurchaseLineW.SETRANGE("Document No.", PurchaseLine."Document No.");
            IF NOT PurchaseLineW.FINDLAST THEN //Si no hay l�neas no hay nada que calcular
                EXIT;
            NLine := PurchaseLineW."Line No." + 100;

            i := 0;
            bAux := (PurchaseLineW.Type = PurchaseLineW.Type::" ") AND (PurchaseLineW."No." = '');  //Para no meter mas separadores de la cuenta
            REPEAT
                i += 1;
                IF (Ocupado[i]) THEN BEGIN
                    //Separador
                    IF (NOT bAux) THEN BEGIN
                        bAux := TRUE;
                        NLine += 10000;
                        PurchaseLineW.INIT;
                        PurchaseLineW."Document Type" := PurchaseLine."Document Type";
                        PurchaseLineW."Document No." := PurchaseLine."Document No.";
                        PurchaseLineW."Line No." := NLine;
                        PurchaseLineW.Type := PurchaseLineW.Type::" ";
                        PurchaseLineW."QW Withholding by GE Line" := TRUE;
                        PurchaseLineW.INSERT(FALSE);
                    END;

                    //Creo las l�neas de la retenci�n
                    NLine += 10000;
                    PurchaseLineW.INIT;
                    PurchaseLineW."Document Type" := PurchaseLine."Document Type";
                    PurchaseLineW."Document No." := PurchaseLine."Document No.";
                    PurchaseLineW."Line No." := NLine;
                    PurchaseLineW.Type := PurchaseLineW.Type::"G/L Account";
                    PurchaseLineW."QW Withholding by GE Line" := TRUE;
                    PurchaseLineW.VALIDATE("No.", WithholdingGroup."Withholding Account");    //Para que no recalcule, pero limpia lo que hemos establecido en la l�nea anterior y luego hay que volver a ponerlo
                    PurchaseLineW.Description := COPYSTR(STRSUBSTNO('Retenci�n del %1% sobre %2 (%3% IVA)',
                                                                     WithholdingGroup."Percentage Withholding",
                                                                     FORMAT(Amount[i], 0, '<Precision,2:2><Standard Format,0>'),
                                                                     PorcIVA[i]), 1, MAXSTRLEN(PurchaseLineW.Description));

                    PurchaseLineW."QW Withholding by GE Line" := TRUE;
                    PurchaseLineW."QW Not apply Withholding GE" := TRUE;

                    PurchaseLineW.VALIDATE("Gen. Prod. Posting Group", GrupoRegGen[i]);
                    PurchaseLineW.VALIDATE("VAT Bus. Posting Group", GrupoIVANeg[i]);
                    PurchaseLineW.VALIDATE("VAT Prod. Posting Group", GrupoIVAPro[i]);
                    PurchaseLineW.VALIDATE(Quantity, -1);
                    PurchaseLineW.VALIDATE("Direct Unit Cost", ROUND(Amount[i] * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision"));
                    //JAV 23/10/19: - a�ado la base de c�lculo en la l�nea
                    PurchaseLineW."QW Base Withholding by GE" := Amount[i];

                    //Calculamos retenci�n de IRPF de la nueva l�nea, si la tiene
                    CalculateWithholding_PurchaseLine_PIT(PurchaseLineW);

                    PurchaseLineW.INSERT(FALSE);
                END;
            UNTIL (NOT Ocupado[i]) OR (i = ARRAYLEN(Amount));
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    END;

    PROCEDURE CalculateWithholding_PurchaseLine_GE_Invoice_Delete(PurchaseHeaderType: Option; PurchaseHeaderNo: Code[20]);
    VAR
        PurchaseLineW: Record 39;
    BEGIN
        //JAV 11/08/19: - Funci�n que borra la l�nea de la retenci�n de B.E. con factura
        PurchaseLineW.RESET;
        PurchaseLineW.SETRANGE("Document Type", PurchaseHeaderType);
        PurchaseLineW.SETRANGE("Document No.", PurchaseHeaderNo);
        PurchaseLineW.SETRANGE("QW Withholding by GE Line", TRUE);
        IF (PurchaseLineW.FINDSET) THEN
            REPEAT
                IF (PurchaseLineW."No." <> '') OR (PurchaseLineW.Description = '') THEN
                    PurchaseLineW.DELETE(FALSE)
                ELSE BEGIN
                    PurchaseLineW."QW Withholding by GE Line" := FALSE;
                    PurchaseLineW.MODIFY(FALSE);
                END;
            UNTIL (PurchaseLineW.NEXT = 0);
    END;

    LOCAL PROCEDURE CalculateWithholding_PurchaseLine_GE_Invoice_Sum(PurchaseLine: Record 39; VAR Ocupado: ARRAY[10] OF Boolean; VAR Amount: ARRAY[10] OF Decimal; VAR GrupoRegGen: ARRAY[10] OF Code[20]; VAR GrupoIVANeg: ARRAY[10] OF Code[20]; VAR GrupoIVAPro: ARRAY[10] OF Code[20]; VAR PorcIVA: ARRAY[10] OF Decimal);
    VAR
        i: Integer;
        MismoGrupo: Boolean;
        RecRef: RecordRef;
        FieldRef1: FieldRef;
        FieldRef3: FieldRef;
        bol: Boolean;
        dec: Decimal;
    BEGIN
        //JAV 11/08/19: - Funci�n que suma el importe de la l�nea a los totales
        IF (NOT PurchaseLine."QW Not apply Withholding GE") AND (PurchaseLine.Amount <> 0) THEN BEGIN
            i := 0;
            MismoGrupo := FALSE;
            REPEAT
                i += 1;
                MismoGrupo := ((GrupoRegGen[i] = PurchaseLine."Gen. Prod. Posting Group") AND
                               (GrupoIVANeg[i] = PurchaseLine."VAT Bus. Posting Group") AND
                               (GrupoIVAPro[i] = PurchaseLine."VAT Prod. Posting Group"));
                IF (MismoGrupo) OR (NOT Ocupado[i]) THEN BEGIN
                    GrupoRegGen[i] := PurchaseLine."Gen. Prod. Posting Group";
                    GrupoIVANeg[i] := PurchaseLine."VAT Bus. Posting Group";
                    GrupoIVAPro[i] := PurchaseLine."VAT Prod. Posting Group";
                    PorcIVA[i] := PurchaseLine."VAT %";
                    Amount[i] += PurchaseLine.Amount;
                    Ocupado[i] := TRUE;
                    MismoGrupo := TRUE;
                END;
            UNTIL (MismoGrupo) OR (i = ARRAYLEN(Amount));
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Calculo de las retenciones en los documentos registrados de Venta"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostSalesLines, '', true, true)]
    LOCAL PROCEDURE CU80_OnAfterPostSalesLines(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; WhseShip: Boolean; WhseReceive: Boolean; VAR SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones en documentos de compra registrados

        IF (ReturnReceiptHeader."No." <> '') THEN
            CU80_AdjustReturnReceipt(ReturnReceiptHeader);

        IF (SalesInvoiceHeader."No." <> '') THEN
            CU80_AdjustSalesInvoice(SalesInvoiceHeader);

        IF (SalesCrMemoHeader."No." <> '') THEN
            CU80_AdjustSalesCrMemo(SalesCrMemoHeader);
    END;

    LOCAL PROCEDURE CU80_AdjustReturnReceipt(VAR Rec: Record 6660);
    VAR
        RecLine: Record 6661;
    BEGIN
        //JAV 19/09/19: - Se eliminan las retenciones en un albar�n de compra registrado

        RecLine.RESET;
        RecLine.SETRANGE("Document No.", Rec."No.");
        RecLine.SETRANGE("QW Withholding by G.E Line", TRUE);
        RecLine.DELETEALL;
    END;

    LOCAL PROCEDURE CU80_AdjustSalesInvoice(VAR Rec: Record 112);
    VAR
        RecLine: Record 113;
        SalesHeader: Record 36;
        SalesLine: Record 37;
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones en una factura de compra registrada

        //Copiar el documento a uno de compra provisional
        SalesHeader.TRANSFERFIELDS(Rec);
        SalesHeader."Document Type" := Enum::"Purchase Document Type".FromInteger(99);
        SalesHeader.INSERT;

        RecLine.RESET;
        RecLine.SETRANGE("Document No.", Rec."No.");
        IF (RecLine.FINDSET) THEN
            REPEAT
                IF (RecLine."QW Withholding by GE Line") THEN
                    RecLine.DELETE
                ELSE BEGIN
                    SalesLine.TRANSFERFIELDS(RecLine);
                    SalesLine."Document Type" := Enum::"Sales Document Type".FromInteger(99);
                    SalesLine.INSERT;
                END;
            UNTIL (RecLine.NEXT = 0);

        //Calcular las retenciones
        CalculateWithholding_SalesHeader(SalesHeader);

        //Pasar las retenciones a las l�neas
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", 99);
        SalesLine.SETRANGE("Document No.", Rec."No.");
        IF (SalesLine.FINDSET(FALSE)) THEN
            REPEAT
                IF (RecLine.GET(Rec."No.", SalesLine."Line No.")) THEN BEGIN
                    RecLine."QW % Withholding by GE" := SalesLine."QW % Withholding by GE";
                    RecLine."QW Withholding Amount by GE" := SalesLine."QW Withholding Amount by GE";
                    RecLine."QW % Withholding by PIT" := SalesLine."QW % Withholding by PIT";
                    RecLine."QW Withholding Amount by PIT" := SalesLine."QW Withholding Amount by PIT";
                    RecLine."QWNot apply Withholding GE" := SalesLine."QW Not apply Withholding by GE";
                    RecLine."QW Not apply Withholding PIT" := SalesLine."QW Not apply Withholding PIT";
                    RecLine."QW Base Withholding by GE" := SalesLine."QW Base Withholding by GE";
                    RecLine."QW Base Withholding by PIT" := SalesLine."QW Base Withholding by PIT";
                    RecLine."QW Withholding by GE Line" := SalesLine."QW Withholding by GE Line";
                    RecLine.MODIFY;
                END ELSE BEGIN
                    RecLine.TRANSFERFIELDS(SalesLine);
                    RecLine.INSERT;
                END;
            UNTIL (SalesLine.NEXT = 0);


        //Eliminar el documento provisional
        SalesHeader.DELETE;

        SalesLine.SETRANGE("Document Type", 99);
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.DELETEALL;
    END;

    LOCAL PROCEDURE CU80_AdjustSalesCrMemo(VAR Rec: Record 114);
    VAR
        SalesHeader: Record 36;
        SalesLine: Record 37;
        RecLine: Record 115;
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones en una factura de compra registrada

        //Copiar el documento a uno de compra provisional
        SalesHeader.TRANSFERFIELDS(Rec);
        SalesHeader."Document Type" := Enum::"Sales Document Type".FromInteger(99);
        SalesHeader.INSERT;

        RecLine.RESET;
        RecLine.SETRANGE("Document No.", Rec."No.");
        IF (RecLine.FINDSET) THEN
            REPEAT
                IF (RecLine."QW Withholding by GE Line") THEN
                    RecLine.DELETE
                ELSE BEGIN
                    SalesLine.TRANSFERFIELDS(RecLine);
                    SalesLine."Document Type" := Enum::"Sales Document Type".FromInteger(99);
                    SalesLine.INSERT;
                END;
            UNTIL (RecLine.NEXT = 0);

        //Calcular las retenciones
        CalculateWithholding_SalesHeader(SalesHeader);

        //Pasar las retenciones a las l�neas
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", 99);
        SalesLine.SETRANGE("Document No.", Rec."No.");
        IF (SalesLine.FINDSET(FALSE)) THEN
            REPEAT
                IF (RecLine.GET(Rec."No.", SalesLine."Line No.")) THEN BEGIN
                    RecLine."QW % Withholding by GE" := SalesLine."QW % Withholding by GE";
                    RecLine."QW Withholding Amount by GE" := SalesLine."QW Withholding Amount by GE";
                    RecLine."QW % Withholding by PIT" := SalesLine."QW % Withholding by PIT";
                    RecLine."QW Withholding Amount by PIT" := SalesLine."QW Withholding Amount by PIT";
                    RecLine."QW Not apply Withholding GE" := SalesLine."QW Not apply Withholding by GE";
                    RecLine."QW Not apply Withholding PIT" := SalesLine."QW Not apply Withholding PIT";
                    RecLine."QW Base Withholding by GE" := SalesLine."QW Base Withholding by GE";
                    RecLine."QW Base Withholding by PIT" := SalesLine."QW Base Withholding by PIT";
                    RecLine."QW Withholding by GE Line" := SalesLine."QW Withholding by GE Line";
                    RecLine.MODIFY;
                END ELSE BEGIN
                    RecLine.TRANSFERFIELDS(SalesLine);
                    RecLine.INSERT;
                END;
            UNTIL (SalesLine.NEXT = 0);


        //Eliminar el documento provisional
        SalesHeader.DELETE;

        SalesLine.SETRANGE("Document Type", 99);
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.DELETEALL;
    END;

    LOCAL PROCEDURE "----------------------------------------- Calculo de las retenciones en los documentos de Venta"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T37_OnBeforeInsertEvent(VAR Rec: Record 37; RunTrigger: Boolean);
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones
        IF (RunTrigger) THEN
            CalculateWithholding_SalesLine(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterModifyEvent, '', true, true)]
    LOCAL PROCEDURE T37_OnBeforeModifyEvent(VAR Rec: Record 37; VAR xRec: Record 37; RunTrigger: Boolean);
    BEGIN
        //JAV 19/09/19 - Se recalculan las retenciones
        IF (RunTrigger) THEN
            CalculateWithholding_SalesLine(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T37_OnBeforeDeleteEvent(VAR Rec: Record 37; RunTrigger: Boolean);
    VAR
        Text001: TextConst ENU = 'You cannot delete the G.E. in invoice line.', ESP = 'No puede eliminar la l¡nea de retenci¢n de B.E. en factura.';
    BEGIN
        //JAV 19/09/19: - Se recalculan las retenciones
        IF (RunTrigger) THEN BEGIN
            //JAV 19/10/19: - No dejar borrar la l�nea de la retenci�n
            IF (Rec."QW Withholding by GE Line") THEN
                ERROR(Text001);
            CalculateWithholding_SalesLine(Rec, TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "Document Date", true, true)]
    LOCAL PROCEDURE T37_OnBeforeValidateEvent_DocumentDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        QBCodeunitSubscriber: Codeunit 7207353;
    BEGIN
        //QB-1.06.07 JAV 30/07/20: Fecha vto retenci�n
        Rec.VALIDATE("QW Witholding Due Date", 0D);
    END;

    PROCEDURE CalculateWithholding_SalesHeader(VAR SalesHeader: Record 36);
    VAR
        SalesLine: Record 37;
        Calculated: Boolean;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula todos los importes de retenciones de las l�neas de una factura de venta
        //JAV 19/10/19: - Mejora para que no se calculen varias veces la retecni�n de factura
        IF NOT FunctionQB.AccessToWithholding THEN
            EXIT;

        Calculated := FALSE;
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF (SalesLine.FINDSET(TRUE)) THEN
            REPEAT
                CalculateWithholding_SalesLine_All(SalesLine, FALSE, Calculated);
                SalesLine.MODIFY(FALSE);
            UNTIL (SalesLine.NEXT = 0);
    END;

    PROCEDURE CalculateWithholding_SalesLine(VAR SalesLine: Record 37; pDelete: Boolean): Boolean;
    VAR
        Calculated: Boolean;
    BEGIN
        //JAV 19/10/19: - Funci�n que calcula importes de retenciones de una �nica l�nea de venta
        CalculateWithholding_SalesLine_All(SalesLine, pDelete, Calculated);
    END;

    PROCEDURE CalculateWithholding_SalesLine_All(VAR SalesLine: Record 37; pDelete: Boolean; VAR pCalculated: Boolean): Boolean;
    VAR
        Calculated: Boolean;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula importes de retenciones de una l�nea de venta de un documento
        //JAV 19/10/19: - Mejora para que no se calculen varias veces la retecni�n de factura
        IF NOT FunctionQB.AccessToWithholding THEN
            EXIT;

        //No recalculamos para las l�neas  retenci�n en factura
        IF (SalesLine."QW Withholding by GE Line") THEN
            EXIT;

        //Calculamos retenci�n de Buena Ejecuci�n cuando es retenci�n con factura que va antes de la base imponible. Esto solo hay que hacerlo una vez para cada factura
        IF NOT pCalculated THEN
            pCalculated := CalculateWithholding_SalesLine_GE_Invoice(SalesLine, pDelete);

        //Calculamos retenci�n de IRPF. Sobre la base siempre
        IF (NOT pDelete) THEN
            CalculateWithholding_SalesLine_PIT(SalesLine);

        //Calculamos retenci�n de Buena Ejecuci�n cuando es retenci�n de pago va siempre sobre el total de la factura
        IF (NOT pDelete) THEN
            CalculateWithholding_SalesLine_GE_Payment(SalesLine);
    END;

    PROCEDURE CalculateWithholding_SalesLine_PIT(VAR SalesLine: Record 37);
    VAR
        SalesHeader: Record 36;
        WithholdingGroup: Record 7207330;
        Currency: Record 4;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula importes de la retenci�n por IRPF de una l�nea de venta

        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::PIT, SalesHeader."QW Cod. Withholding by PIT")) THEN
            CLEAR(WithholdingGroup);

        IF (SalesLine."QW Not apply Withholding PIT") OR (WithholdingGroup."Percentage Withholding" = 0) THEN BEGIN
            SalesLine."QW Base Withholding by PIT" := 0;
            SalesLine."QW % Withholding by PIT" := 0;
            SalesLine."QW Withholding Amount by PIT" := 0;
        END ELSE BEGIN
            IF (NOT Currency.GET(SalesHeader."Currency Code")) THEN
                CLEAR(Currency);
            Currency.InitRoundingPrecision;

            SalesLine."QW % Withholding by PIT" := WithholdingGroup."Percentage Withholding";
            CASE WithholdingGroup."Withholding Base" OF
                WithholdingGroup."Withholding Base"::"Invoice Amount":
                    SalesLine."QW Base Withholding by PIT" := SalesLine.Amount;
                WithholdingGroup."Withholding Base"::"Amount Including VAT":
                    SalesLine."QW Base Withholding by PIT" := SalesLine."Amount Including VAT";
            END;
            SalesLine."QW Withholding Amount by PIT" := ROUND(SalesLine."QW Base Withholding by PIT" * SalesLine."QW % Withholding by PIT" / 100,
                                                              Currency."Amount Rounding Precision");
        END;
    END;

    PROCEDURE CalculateWithholding_SalesLine_GE_Payment(VAR SalesLine: Record 37);
    VAR
        SalesHeader: Record 36;
        WithholdingGroup: Record 7207330;
        Currency: Record 4;
    BEGIN
        //JAV 11/08/19: - Funci�n que calcula importes de la retenci�n de garant�a con retenci�n de pago de una l�nea de venta

        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", SalesHeader."QW Cod. Withholding by GE")) THEN
            CLEAR(WithholdingGroup);

        IF (WithholdingGroup."Withholding treating" <> WithholdingGroup."Withholding treating"::"Payment Withholding") OR
           (SalesLine."QW Not apply Withholding by GE") OR (WithholdingGroup."Percentage Withholding" = 0) THEN BEGIN
            SalesLine."QW Base Withholding by GE" := 0;
            SalesLine."QW % Withholding by GE" := 0;
            SalesLine."QW Withholding Amount by GE" := 0;
        END ELSE BEGIN
            IF (NOT Currency.GET(SalesHeader."Currency Code")) THEN
                CLEAR(Currency);
            Currency.InitRoundingPrecision;

            IF (WithholdingGroup."Withholding treating" = WithholdingGroup."Withholding treating"::"Payment Withholding") THEN BEGIN
                IF (NOT SalesLine."QW Not apply Withholding by GE") THEN BEGIN
                    SalesLine."QW % Withholding by GE" := WithholdingGroup."Percentage Withholding";
                    CASE WithholdingGroup."Withholding Base" OF
                        WithholdingGroup."Withholding Base"::"Invoice Amount":
                            SalesLine."QW Base Withholding by GE" := SalesLine.Amount;
                        WithholdingGroup."Withholding Base"::"Amount Including VAT":
                            SalesLine."QW Base Withholding by GE" := SalesLine."Amount Including VAT" - SalesLine."QW Withholding Amount by PIT";
                    END;
                    SalesLine."QW Withholding Amount by GE" := ROUND(SalesLine."QW Base Withholding by GE" * SalesLine."QW % Withholding by GE" / 100,
                                                                      Currency."Amount Rounding Precision");
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE CalculateWithholding_SalesLine_GE_Invoice(VAR SalesLine: Record 37; pDelete: Boolean): Boolean;
    VAR
        SalesHeader: Record 36;
        WithholdingGroup: Record 7207330;
        Currency: Record 4;
        SalesLineW: Record 37;
        NLine: Integer;
        i: Integer;
        bAux: Boolean;
        Ocupado: ARRAY[10] OF Boolean;
        Amount: ARRAY[10] OF Decimal;
        GrupoRegGen: ARRAY[10] OF Code[20];
        GrupoIVANeg: ARRAY[10] OF Code[20];
        GrupoIVAPro: ARRAY[10] OF Code[20];
        PorcIVA: ARRAY[10] OF Decimal;
    BEGIN
        //JAV 11/08/19: - Funci�n que a�ade o modifica la l�nea de la retenci�n de B.E. con factura

        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", SalesHeader."QW Cod. Withholding by GE")) THEN
            CLEAR(WithholdingGroup);
        IF (NOT Currency.GET(SalesHeader."Currency Code")) THEN
            CLEAR(Currency);
        Currency.InitRoundingPrecision;

        //Borro las l�neas de la retenci�n si las tuviera
        CalculateWithholding_SalesLine_GE_Invoice_Delete(SalesLine."Document Type", SalesLine."Document No.");

        IF (WithholdingGroup."Withholding treating" = WithholdingGroup."Withholding treating"::"Pending Invoice") THEN BEGIN
            CLEAR(Amount);
            CLEAR(GrupoRegGen);
            CLEAR(GrupoIVAPro);
            CLEAR(GrupoIVANeg);
            CLEAR(PorcIVA);
            bAux := FALSE;

            //Busco el importe total
            SalesLineW.RESET;
            SalesLineW.SETRANGE("Document Type", SalesLine."Document Type");
            SalesLineW.SETRANGE("Document No.", SalesLine."Document No.");
            SalesLineW.SETRANGE("QW Not apply Withholding by GE", FALSE);
            SalesLine.SETFILTER(Amount, '<> 0');
            IF (SalesLineW.FINDSET) THEN
                REPEAT
                    IF (SalesLineW."Line No." = SalesLine."Line No.") THEN BEGIN
                        IF (NOT pDelete) THEN
                            CalculateWithholding_SalesLine_GE_Invoice_Sum(SalesLine, Ocupado, Amount, GrupoRegGen, GrupoIVANeg, GrupoIVAPro, PorcIVA);
                        bAux := TRUE;
                    END ELSE
                        CalculateWithholding_SalesLine_GE_Invoice_Sum(SalesLineW, Ocupado, Amount, GrupoRegGen, GrupoIVANeg, GrupoIVAPro, PorcIVA);
                UNTIL (SalesLineW.NEXT = 0);

            IF (NOT bAux) THEN
                CalculateWithholding_SalesLine_GE_Invoice_Sum(SalesLine, Ocupado, Amount, GrupoRegGen, GrupoIVANeg, GrupoIVAPro, PorcIVA);

            //Busco la �ltima l�nea
            SalesLineW.RESET;
            SalesLineW.SETRANGE("Document Type", SalesLine."Document Type");
            SalesLineW.SETRANGE("Document No.", SalesLine."Document No.");
            IF NOT SalesLineW.FINDLAST THEN //Si no hay l�neas no hay nada que calcular
                EXIT;
            NLine := SalesLineW."Line No." + 100;

            i := 0;
            bAux := (SalesLineW.Type = SalesLineW.Type::" ") AND (SalesLineW."No." = '');  //Para no meter mas separadores de la cuenta
            REPEAT
                i += 1;
                IF (Ocupado[i]) THEN BEGIN
                    //Separador
                    IF (NOT bAux) THEN BEGIN
                        bAux := TRUE;
                        NLine += 10000;
                        SalesLineW.INIT;
                        SalesLineW."Document Type" := SalesLine."Document Type";
                        SalesLineW."Document No." := SalesLine."Document No.";
                        SalesLineW."Line No." := NLine;
                        SalesLineW.Type := SalesLineW.Type::" ";
                        SalesLineW."QW Withholding by GE Line" := TRUE;
                        SalesLineW.INSERT(FALSE);
                    END;

                    //Creo las l�neas de la retenci�n
                    NLine += 10000;
                    SalesLineW.INIT;
                    SalesLineW."Document Type" := SalesLine."Document Type";
                    SalesLineW."Document No." := SalesLine."Document No.";
                    SalesLineW."Line No." := NLine;
                    SalesLineW.Type := SalesLineW.Type::"G/L Account";
                    SalesLineW."QW Withholding by GE Line" := TRUE;
                    SalesLineW.VALIDATE("No.", WithholdingGroup."Withholding Account");    //Para que no recalcule, pero limpia lo que hemos establecido en la l�nea anterior y luego hay que volver a ponerlo
                    SalesLineW.Description := COPYSTR(STRSUBSTNO('Retenci�n del %1% sobre %2 (%3% IVA)',
                                                                 WithholdingGroup."Percentage Withholding",
                                                                 FORMAT(Amount[i], 0, '<Precision,2:2><Standard Format,0>'),
                                                                 PorcIVA[i]), 1, MAXSTRLEN(SalesLineW.Description));

                    SalesLineW."QW Withholding by GE Line" := TRUE;
                    SalesLineW."QW Not apply Withholding by GE" := TRUE;

                    SalesLineW.VALIDATE("Gen. Prod. Posting Group", GrupoRegGen[i]);
                    SalesLineW.VALIDATE("VAT Bus. Posting Group", GrupoIVANeg[i]);
                    SalesLineW.VALIDATE("VAT Prod. Posting Group", GrupoIVAPro[i]);
                    SalesLineW.VALIDATE(Quantity, -1);
                    SalesLineW.VALIDATE("Unit Price", ROUND(Amount[i] * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision"));
                    //JAV 23/10/19: - a�ado la base de c�lculo en la l�nea
                    SalesLineW."QW Base Withholding by GE" := Amount[i];

                    //Calculamos retenci�n de IRPF de la nueva l�nea, si la tiene
                    CalculateWithholding_SalesLine_PIT(SalesLineW);

                    SalesLineW.INSERT(FALSE);
                END;
            UNTIL (NOT Ocupado[i]) OR (i = ARRAYLEN(Amount));
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    END;

    PROCEDURE CalculateWithholding_SalesLine_GE_Invoice_Delete(SalesHeaderType: Enum "Sales Document Type"; SalesHeaderNo: Code[20]);
    VAR
        SalesLineW: Record 37;
    BEGIN
        //JAV 11/08/19: - Funci�n que borra la l�nea de la retenci�n de B.E. con factura
        SalesLineW.RESET;
        SalesLineW.SETRANGE("Document Type", SalesHeaderType);
        SalesLineW.SETRANGE("Document No.", SalesHeaderNo);
        SalesLineW.SETRANGE("QW Withholding by GE Line", TRUE);
        IF (SalesLineW.FINDSET) THEN
            REPEAT
                IF (SalesLineW."No." <> '') OR (SalesLineW.Description = '') THEN
                    SalesLineW.DELETE(FALSE)
                ELSE BEGIN
                    SalesLineW."QW Withholding by GE Line" := FALSE;
                    SalesLineW.MODIFY(FALSE);
                END;
            UNTIL (SalesLineW.NEXT = 0);
    END;

    LOCAL PROCEDURE CalculateWithholding_SalesLine_GE_Invoice_Sum(SalesLine: Record 37; VAR Ocupado: ARRAY[10] OF Boolean; VAR Amount: ARRAY[10] OF Decimal; VAR GrupoRegGen: ARRAY[10] OF Code[20]; VAR GrupoIVANeg: ARRAY[10] OF Code[20]; VAR GrupoIVAPro: ARRAY[10] OF Code[20]; VAR PorcIVA: ARRAY[10] OF Decimal);
    VAR
        i: Integer;
        MismoGrupo: Boolean;
        RecRef: RecordRef;
        FieldRef1: FieldRef;
        FieldRef3: FieldRef;
        bol: Boolean;
        dec: Decimal;
    BEGIN
        //JAV 11/08/19: - Funci�n que suma el importe de la l�nea a los totales
        IF (NOT SalesLine."QW Not apply Withholding by GE") AND (SalesLine.Amount <> 0) THEN BEGIN
            i := 0;
            MismoGrupo := FALSE;
            REPEAT
                i += 1;
                MismoGrupo := ((GrupoRegGen[i] = SalesLine."Gen. Prod. Posting Group") AND
                               (GrupoIVANeg[i] = SalesLine."VAT Bus. Posting Group") AND
                               (GrupoIVAPro[i] = SalesLine."VAT Prod. Posting Group"));
                IF (MismoGrupo) OR (NOT Ocupado[i]) THEN BEGIN
                    GrupoRegGen[i] := SalesLine."Gen. Prod. Posting Group";
                    GrupoIVANeg[i] := SalesLine."VAT Bus. Posting Group";
                    GrupoIVAPro[i] := SalesLine."VAT Prod. Posting Group";
                    PorcIVA[i] := SalesLine."VAT %";
                    Amount[i] += SalesLine.Amount;
                    Ocupado[i] := TRUE;
                    MismoGrupo := TRUE;
                END;
            UNTIL (MismoGrupo) OR (i = ARRAYLEN(Amount));
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Utilidades de retenciones registradas"();
    BEGIN
    END;

    PROCEDURE FunReleaseWitholding(VAR WithholdingMovements: Record 7207329);
    VAR
        Window: Dialog;
        total: Integer;
        read: Integer;
        liq: Integer;
        inv: Integer;
        r: Boolean;
        Text000: TextConst ESP = 'Confirme que desea liberar %1 retenciones.';
        Text001: TextConst ENU = 'Releasing Whithholding/s... \#1#######', ESP = 'Liberando retenci�n #1#######';
    BEGIN
        total := WithholdingMovements.COUNT;
        read := 0;
        liq := 0;
        inv := 0;
        IF (CONFIRM(Text000, FALSE, total)) THEN BEGIN
            Window.OPEN(Text001);
            IF WithholdingMovements.FINDSET(TRUE) THEN
                REPEAT
                    read += 1;
                    Window.UPDATE(1, STRSUBSTNO('%1 de %2', read, total));
                    IF (WithholdingMovements.Open) THEN BEGIN
                        CASE WithholdingMovements.Type OF
                            WithholdingMovements.Type::Vendor:
                                r := FunReleaseVendorWithholding(WithholdingMovements);
                            WithholdingMovements.Type::Customer:
                                r := FunReleaseCustomerWithholding(WithholdingMovements);
                        END;
                        IF (r) THEN
                            inv += 1
                        ELSE
                            liq += 1;
                    END;
                UNTIL WithholdingMovements.NEXT = 0;
            Window.CLOSE;
            IF (liq = 0) AND (inv = 0) THEN
                MESSAGE('No se ha liquidado ning�n movimiento')
            ELSE IF (liq <> 0) AND (inv = 0) THEN
                MESSAGE('De los %1 movimientos se han generado %2 efectos', read, liq, inv)
            ELSE IF (liq = 0) AND (inv <> 0) THEN
                MESSAGE('De los %1 movimientos se han generado %3 documentos', read, liq, inv)
            ELSE
                MESSAGE('De los %1 movimientos se han generado: %2 efectos y %3 documentos', read, liq, inv);
        END;
    END;

    PROCEDURE FunReleaseVendorWithholding(VAR WithholdingMovements: Record 7207329): Boolean;
    VAR
        Text000: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'No se pueden liberar retenciones de IRPF';
        Text002: TextConst ENU = 'Entry must be open', ESP = 'Para liberar la retenci¢n el movimiento debe estar Pendiente';
    BEGIN
        IF (NOT WithholdingMovements.Open) THEN
            ERROR(Text002);

        CASE WithholdingMovements."Withholding treating" OF
            WithholdingMovements."Withholding treating"::PIT:
                ERROR(Text000);  //No se liberan las de IRPF
            WithholdingMovements."Withholding treating"::"Withholding Payment":
                FunReleaseVendorWithholdingPayment(WithholdingMovements);  //Si la retenci�n es de pago, generamos un efecto
            WithholdingMovements."Withholding treating"::"Pending Invoice":
                FunReleaseVendorWithholdingInvoice(WithholdingMovements);  //Si la retenci�n es de factura generamos una
        END;

        EXIT(WithholdingMovements."Withholding treating" = WithholdingMovements."Withholding treating"::"Pending Invoice");
    END;

    PROCEDURE FunReleaseVendorWithholdingPayment(VAR WithholdingMovements: Record 7207329);
    VAR
        GenJournalLine: Record 81;
        RecSource: Record 242;
        WithholdingGroup: Record 7207330;
        VendorLedgerEntry: Record 25;
        Vendor: Record 23;
        PurchInvHeader: Record 122;
        Text001: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'La forma de pago %1 no genera efectos ni va a cartera, no se puede utilizar para liberar el efecto.';
        PurchCrMemoHdr: Record 124;
        PaymentMethod: Record 289;
        GenJnlPostLine: Codeunit 12;
        nro: Code[10];
        aux: Code[10];
        PMCode: Code[20];
        Text001_B: TextConst ENU = 'La forma de pago %1 no genera efectos.  Por ello no se puede utilizar para liberar el efecto.', ESP = 'La forma de pago %1 no genera efectos.  Por ello no se puede utilizar para liberar el efecto.';
    BEGIN
        WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", WithholdingMovements."Withholding Code");
        Vendor.GET(WithholdingMovements."No.");

        //JAV 27/03/22: - QB 1.10.28 Cambiar la forma de obtener la forma de pago, si existe una para liberar se utilizar� esta, si no la del documento original
        PMCode := WithholdingGroup."Payment Method Liberation";
        IF (WithholdingGroup."Payment Method Liberation" = '') THEN BEGIN
            IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) THEN BEGIN
                IF PurchInvHeader.GET(WithholdingMovements."Document No.") THEN
                    PMCode := PurchInvHeader."Payment Method Code";
            END ELSE BEGIN
                IF PurchCrMemoHdr.GET(WithholdingMovements."Document No.") THEN
                    PMCode := PurchCrMemoHdr."Payment Method Code";
            END;
        END;

        IF (NOT PaymentMethod.GET(PMCode)) THEN
            IF PMCode = '' THEN
                ERROR(Text000, WithholdingGroup."Withholding Type", WithholdingGroup.Code)
            ELSE
                ERROR(Text001, PMCode);


        //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. -
        //obligatorio crear Efecto para liberar Retenci�n BE.
        IF NOT (PaymentMethod."Create Bills") THEN
            ERROR(Text001_B, PMCode);
        //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. +


        //Creo el asiento que genera el movimiento para liquidar la retenci�n
        GenJournalLine.INIT;
        GenJournalLine."Posting Date" := WORKDATE;
        GenJournalLine."Document Date" := GenJournalLine."Posting Date";  //JAV 27/03/22: - QB 1.10.27 Usar la fecha de registro como fecha del documento
        GenJournalLine."Document No." := WithholdingMovements."Document No.";
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
        GenJournalLine.VALIDATE("Account No.", WithholdingMovements."No.");

        //JAV 27/03/22 - QB 1.10.27 No generar IVA de este documento
        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
        GenJournalLine."VAT Prod. Posting Group" := '';

        GenJournalLine.VALIDATE("Payment Method Code", PMCode);
        GenJournalLine."External Document No." := WithholdingMovements."External Document No.";

        //Si es factura y la forma de pago crea efectos usaremos un efecto, si no ser� factura
        IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) AND (PaymentMethod."Create Bills") THEN BEGIN
            nro := '0';
            //Leo todos porque no tienen por que estar ordenados (aunque deber�a).
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETCURRENTKEY("Document No.");
            //VendorLedgerEntry.SETRANGE("Vendor No.",WithholdingMovements."No.");    //JAV 13/10/20: - QB 1.06.20 Puede existir documentos de varios proveedores con el mismo n�mero
            VendorLedgerEntry.SETRANGE("Document No.", WithholdingMovements."Document No.");
            VendorLedgerEntry.SETFILTER("Bill No.", '<>%1', '');
            IF VendorLedgerEntry.FINDSET THEN
            //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. -
            BEGIN
                //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. +
                REPEAT
                    //JAV 13/10/22: - QB 1.12.03 Al dar el valor al n�mero del efecto cuando se crea uno, al buscar solo considerar los que sean num�ricos o tengan un n�mero al final
                    //IF (nro < VendorLedgerEntry."Bill No.") THEN
                    //  nro := VendorLedgerEntry."Bill No.";
                    aux := INCSTR(VendorLedgerEntry."Bill No.");
                    IF (aux <> '') AND (nro < aux) THEN
                        nro := aux;
                UNTIL VendorLedgerEntry.NEXT = 0;
                //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. -
            END ELSE
                nro := '1';
            //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. +

            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Bill;
            GenJournalLine."Bill No." := nro;  //JAV 13/10/22: - QB 1.12.03 el n�mero ya ha sido incrementado por el proceso anterior

        END ELSE BEGIN
            IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) THEN
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice
            ELSE
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::"Credit Memo";
            GenJournalLine."Document No." := GenJournalLine."Document No." + '-ret';
            GenJournalLine."External Document No." := GenJournalLine."External Document No." + '-ret';
            GenJournalLine."Bill No." := '';
        END;

        //JAV 27/03/22 - QB 1.10.27 El importe de cancelaci�n debe ser negativo para facturas y positivo para abonos por ser un registro de PROVEEDOR
        GenJournalLine.VALIDATE(Amount, -WithholdingMovements.Amount);

        GenJournalLine."Currency Code" := WithholdingMovements."Currency Code";
        GenJournalLine."Shortcut Dimension 1 Code" := WithholdingMovements."Global Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := WithholdingMovements."Global Dimension 2 Code";
        RecSource.GET;
        GenJournalLine."Source Code" := RecSource."QW Withholding Releasing";
        GenJournalLine."System-Created Entry" := TRUE;
        IF (WithholdingMovements."Due Date" >= WORKDATE) THEN
            GenJournalLine."Due Date" := WithholdingMovements."Due Date"
        ELSE
            GenJournalLine."Due Date" := WORKDATE;
        GenJournalLine."Bill-to/Pay-to No." := WithholdingMovements."No.";
        GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Bal. Account No.", WithholdingGroup."Withholding Account");
        GenJournalLine.VALIDATE("QW Withholding Base", WithholdingMovements.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := WithholdingMovements."Global Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := WithholdingMovements."Global Dimension 2 Code";
        GenJournalLine.Description := COPYSTR('Liberar Retenci�n ' + WithholdingMovements.Description, 1, MAXSTRLEN(GenJournalLine.Description));
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
        GenJournalLine."Source No." := WithholdingMovements."No.";
        GenJournalLine."QW WithHolding Job No." := WithholdingMovements."Job No.";
        GenJournalLine."Dimension Set ID" := WithholdingMovements."Dimension Set ID";

        //JAV 25/11/21: - QB 1.10.01 A�adir el banco
        GenJournalLine."QB Payment Bank No." := WithholdingMovements."QB Payment bank No."; //Q13407

        //JAV 11/05/22: - QB 1.10.40 No subir a SII estos movimientos de liberar la retenci�n
        GenJournalLine."Do not sent to SII" := TRUE;


        GenJnlPostLine.RunWithCheck(GenJournalLine);
        CLEAR(GenJnlPostLine);

        //Marco como liberada la retenci�n
        WithholdingMovements.Open := FALSE;
        WithholdingMovements."Release Date" := WORKDATE;
        WithholdingMovements."Released by Amount" := GenJournalLine.Amount;

        IF (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Bill) THEN
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::ME
        ELSE
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::MF;
        WithholdingMovements."Released-to Doc. No" := GenJournalLine."Document No.";
        WithholdingMovements."Released-to Bill No." := GenJournalLine."Bill No.";
        WithholdingMovements.VALIDATE("Released-to Document No.");

        WithholdingMovements.MODIFY;
    END;

    PROCEDURE FunReleaseVendorWithholdingInvoice(VAR WithholdingMovements: Record 7207329);
    VAR
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchInvLine: Record 123;
        PurchCrMemoLine: Record 125;
        WithholdingGroup: Record 7207330;
        Text000: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'No se pueden liberar retenciones de IRPF';
        Text002: TextConst ENU = 'Entry must be open', ESP = 'Para liberar la retenci¢n el movimiento debe estar Pendiente';
    BEGIN
        WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", WithholdingMovements."Withholding Code");

        PurchaseHeader.INIT;
        IF WithholdingMovements.Amount >= 0 THEN
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice
        ELSE
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";

        //AML 29/05/23 Q19515 Correcci�n para evitar error por falta de fecha documento -
        PurchaseHeader."Document Date" := WORKDATE;
        //AML 29/05/23 Q19515 Correcci�n para evitar error por falta de fecha documento +

        PurchaseHeader.VALIDATE("Posting Date", WORKDATE);
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", WithholdingMovements."No.");
        PurchaseHeader.VALIDATE("QW Cod. Withholding by GE", '');
        PurchaseHeader.VALIDATE("QB Job No.", WithholdingMovements."Job No.");
        PurchaseHeader.VALIDATE("Vendor Invoice No.", WithholdingMovements."External Document No." + '/liq');
        PurchaseHeader.VALIDATE("QW Withholding mov liq.", WithholdingMovements."Entry No.");
        PurchaseHeader.MODIFY(TRUE);

        PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 10000;
        PurchaseLine.Description := COPYSTR('Liquidar retenci�n Fra ' + WithholdingMovements."Document No." + ' del ' + FORMAT(WithholdingMovements."Posting Date"), 1, MAXSTRLEN(PurchaseLine.Description));
        PurchaseLine.INSERT(TRUE);

        IF WithholdingMovements.Amount >= 0 THEN BEGIN
            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Document No.", WithholdingMovements."Document No.");
            PurchInvLine.SETRANGE("QW Withholding by G.E Line", TRUE);
            IF (PurchInvLine.FINDSET) THEN
                REPEAT
                    PurchaseLine.TRANSFERFIELDS(PurchInvLine);
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."QW Withholding by GE Line" := FALSE;
                    PurchaseLine.VALIDATE(Quantity, -PurchaseLine.Quantity);
                    PurchaseLine.INSERT(TRUE);
                UNTIL PurchInvLine.NEXT = 0;
        END ELSE BEGIN
            PurchCrMemoLine.RESET;
            PurchCrMemoLine.SETRANGE("Document No.", WithholdingMovements."Document No.");
            PurchCrMemoLine.SETRANGE("QW Withholding by GE Line", TRUE);
            IF (PurchCrMemoLine.FINDSET) THEN
                REPEAT
                    PurchaseLine.TRANSFERFIELDS(PurchCrMemoLine);
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";   //JAV 30/06/22: - Apuntaba a SalesHeader en lugar de PurchaseHeader
                    PurchaseLine."Document No." := PurchaseHeader."No.";              //JAV 30/06/22: - Apuntaba a SalesHeader en lugar de PurchaseHeader
                    PurchaseLine."QW Withholding by GE Line" := FALSE;
                    PurchaseLine.VALIDATE(Quantity, -PurchaseLine.Quantity);
                    PurchaseLine.INSERT(TRUE);
                UNTIL PurchCrMemoLine.NEXT = 0;
        END;

        IF WithholdingMovements.Amount >= 0 THEN
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::FB
        ELSE
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::AB;
        WithholdingMovements."Released-to Doc. No" := PurchaseHeader."No.";
        WithholdingMovements."Released-to Bill No." := '';
        WithholdingMovements.VALIDATE("Released-to Document No.");
        WithholdingMovements.MODIFY;
    END;

    PROCEDURE FunReleaseCustomerWithholding(VAR WithholdingMovements: Record 7207329): Boolean;
    VAR
        Text000: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'No se pueden liberar retenciones de IRPF';
        Text002: TextConst ENU = 'Entry must be open', ESP = 'Para liberar la retenci¢n el movimiento debe estar Pendiente';
    BEGIN
        IF (NOT WithholdingMovements.Open) THEN
            ERROR(Text002);

        CASE WithholdingMovements."Withholding treating" OF
            WithholdingMovements."Withholding treating"::PIT:
                ERROR(Text000);  //No se liberan las de IRPF
            WithholdingMovements."Withholding treating"::"Withholding Payment":
                FunReleaseCustomerWithholdingPayment(WithholdingMovements);  //Si la retenci�n es de pago, generamos un efecto
            WithholdingMovements."Withholding treating"::"Pending Invoice":
                FunReleaseCustomerWithholdingInvoice(WithholdingMovements);  //Si la retenci�n es de factura generamos una
        END;

        EXIT(WithholdingMovements."Withholding treating" = WithholdingMovements."Withholding treating"::"Pending Invoice");
    END;

    PROCEDURE FunReleaseCustomerWithholdingPayment(VAR WithholdingMovements: Record 7207329);
    VAR
        GenJournalLine: Record 81;
        RecSource: Record 242;
        WithholdingGroup: Record 7207330;
        CustLedgerEntry: Record 21;
        PaymentMethod: Record 289;
        Text001: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'La forma de pago %1 no genera efectos ni va a cartera, no se puede utilizar para liberar una retenci�n.';
        Customer: Record 18;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        GenJnlPostLine: Codeunit 12;
        nro: Code[10];
        PMCode: Code[20];
        Text001_B: TextConst ENU = 'La forma de pago %1 no genera efectos.  Por ello no se puede utilizar para liberar el efecto.', ESP = 'La forma de pago %1 no genera efectos.  Por ello no se puede utilizar para liberar el efecto.';
    BEGIN
        WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", WithholdingMovements."Withholding Code");
        Customer.GET(WithholdingMovements."No.");

        //JAV 27/03/22: - QB 1.10.28 Cambiar la forma de obtener la forma de pago, si existe una para liberar se utilizar� esta, si no la del documento original
        PMCode := WithholdingGroup."Payment Method Liberation";
        IF (WithholdingGroup."Payment Method Liberation" = '') THEN BEGIN
            IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) THEN BEGIN
                IF SalesInvoiceHeader.GET(WithholdingMovements."Document No.") THEN
                    PMCode := SalesInvoiceHeader."Payment Method Code";
            END ELSE BEGIN
                IF SalesCrMemoHeader.GET(WithholdingMovements."Document No.") THEN
                    PMCode := SalesCrMemoHeader."Payment Method Code";
            END;
        END;

        IF (NOT PaymentMethod.GET(PMCode)) THEN
            IF PMCode = '' THEN
                ERROR(Text000, WithholdingGroup."Withholding Type", WithholdingGroup.Code)
            ELSE
                ERROR(Text001, PMCode);

        //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. -
        //obligatorio crear Efecto para liberar Retenci�n BE.
        IF NOT (PaymentMethod."Create Bills") THEN
            ERROR(Text001_B, PMCode);
        //CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE. +


        //Creo el asiento que genera el movimiento para liquidar la retenci�n
        GenJournalLine.INIT;
        GenJournalLine."Posting Date" := WORKDATE;
        GenJournalLine."Document Date" := GenJournalLine."Posting Date";  //JAV 27/03/22: - QB 1.10.27 Usar la fecha de registro como fecha del documento
        GenJournalLine."Document No." := WithholdingMovements."Document No.";
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
        GenJournalLine.VALIDATE("Account No.", WithholdingMovements."No.");

        //JAV 27/03/22 - QB 1.10.27 No generar IVA de este documento
        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
        GenJournalLine."VAT Prod. Posting Group" := '';

        GenJournalLine.VALIDATE("Payment Method Code", PMCode);
        GenJournalLine."External Document No." := WithholdingMovements."External Document No.";

        //Si es factura y la forma de pago crea efectos usaremos un efecto, si no ser� factura
        IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) AND (PaymentMethod."Create Bills") THEN BEGIN
            nro := '0';
            //Leo todos porque no tienen por que estar ordenados (aunque deber�a).
            CustLedgerEntry.RESET;
            CustLedgerEntry.SETCURRENTKEY("Document No.");
            //CustLedgerEntry.SETRANGE("Customer No.",WithholdingMovements."No.");             //JAV 13/10/20: - QB 1.06.20 Puede existir documentos de varios clientes con el mismo n�mero
            CustLedgerEntry.SETRANGE("Document No.", WithholdingMovements."Document No.");
            CustLedgerEntry.SETFILTER("Bill No.", '<>%1', '');
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    IF (nro < CustLedgerEntry."Bill No.") THEN
                        nro := CustLedgerEntry."Bill No.";
                UNTIL CustLedgerEntry.NEXT = 0;

            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Bill;
            GenJournalLine."Bill No." := INCSTR(nro);
        END ELSE BEGIN
            IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) THEN
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice
            ELSE
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::"Credit Memo";
            GenJournalLine."Document No." := GenJournalLine."Document No." + '-ret';
            GenJournalLine."External Document No." := GenJournalLine."External Document No." + '-ret';
            GenJournalLine."Bill No." := '';
        END;

        //JAV 27/03/22 - QB 1.10.27 El importe de cancelaci�n debe ser positivo para facturas y negativo para abonos por ser un registro de CLIENTE
        GenJournalLine.VALIDATE(Amount, WithholdingMovements.Amount);

        GenJournalLine."Currency Code" := WithholdingMovements."Currency Code";
        GenJournalLine."Shortcut Dimension 1 Code" := WithholdingMovements."Global Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := WithholdingMovements."Global Dimension 2 Code";
        RecSource.GET;
        GenJournalLine."Source Code" := RecSource."QW Withholding Releasing";
        GenJournalLine."System-Created Entry" := TRUE;
        IF (WithholdingMovements."Due Date" >= WORKDATE) THEN
            GenJournalLine."Due Date" := WithholdingMovements."Due Date"
        ELSE
            GenJournalLine."Due Date" := WORKDATE;
        GenJournalLine."Bill-to/Pay-to No." := WithholdingMovements."No.";
        GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Bal. Account No.", WithholdingGroup."Withholding Account");
        GenJournalLine.VALIDATE("QW Withholding Base", WithholdingMovements.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := WithholdingMovements."Global Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := WithholdingMovements."Global Dimension 2 Code";
        GenJournalLine.Description := COPYSTR('Liberar Retenci�n ' + WithholdingMovements.Description, 1, MAXSTRLEN(GenJournalLine.Description));
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::Customer;
        GenJournalLine."Source No." := WithholdingMovements."No.";
        GenJournalLine."QW WithHolding Job No." := WithholdingMovements."Job No.";
        GenJournalLine."Dimension Set ID" := WithholdingMovements."Dimension Set ID";

        //JAV 25/11/21: - QB 1.10.01 A�adir el banco
        GenJournalLine."QB Payment Bank No." := WithholdingMovements."QB Payment bank No."; //Q13407

        //JAV 11/05/22: - QB 1.10.40 No subir a SII estos movimientos de liberar la retenci�n
        GenJournalLine."Do not sent to SII" := TRUE;

        GenJnlPostLine.RunWithCheck(GenJournalLine);
        CLEAR(GenJnlPostLine);

        //Marco como liberada la retenci�n
        WithholdingMovements.Open := FALSE;
        WithholdingMovements."Release Date" := WORKDATE;
        WithholdingMovements."Released by Amount" := GenJournalLine.Amount;

        IF (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Bill) THEN
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::ME
        ELSE
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::MF;
        WithholdingMovements."Released-to Doc. No" := GenJournalLine."Document No.";
        WithholdingMovements."Released-to Bill No." := GenJournalLine."Bill No.";
        WithholdingMovements.VALIDATE("Released-to Document No.");

        WithholdingMovements.MODIFY;
    END;

    PROCEDURE FunReleaseCustomerWithholdingInvoice(VAR WithholdingMovements: Record 7207329);
    VAR
        Text000: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'No se pueden liberar retenciones de IRPF';
        Text002: TextConst ENU = 'Entry must be open', ESP = 'Para liberar la retenci¢n el movimiento debe estar Pendiente';
        SalesHeader: Record 36;
        SalesLine: Record 37;
        SalesInvoiceLine: Record 113;
        SalesCrMemoLine: Record 115;
        WithholdingGroup: Record 7207330;
    BEGIN
        WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", WithholdingMovements."Withholding Code");

        SalesHeader.INIT;
        IF WithholdingMovements.Amount >= 0 THEN
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice
        ELSE
            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

        //AML Q19515 Para evitar error por falta de fecha de Document Date
        //SalesHeader."Document Date" := WithholdingMovements."Document Date";
        SalesHeader."Document Date" := WORKDATE;
        //AML 29/05/23 Q19515 Correcci�n para evitar error por falta de fecha documento +

        SalesHeader.VALIDATE("Posting Date", WORKDATE);

        SalesHeader.INSERT(TRUE);
        SalesHeader.VALIDATE("Sell-to Customer No.", WithholdingMovements."No.");
        SalesHeader.VALIDATE("QW Cod. Withholding by GE", '');
        SalesHeader.VALIDATE("QB Job No.", WithholdingMovements."Job No.");
        SalesHeader.VALIDATE("QW Withholding mov liq.", WithholdingMovements."Entry No.");
        SalesHeader.MODIFY(TRUE);

        SalesLine.INIT;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine.Description := COPYSTR('Liquidar retenci�n Fra ' + WithholdingMovements."Document No." + ' del ' + FORMAT(WithholdingMovements."Posting Date"), 1, MAXSTRLEN(SalesLine.Description));
        SalesLine.INSERT(TRUE);

        IF WithholdingMovements.Amount > 0 THEN BEGIN
            SalesInvoiceLine.RESET;
            SalesInvoiceLine.SETRANGE("Document No.", WithholdingMovements."Document No.");
            SalesInvoiceLine.SETRANGE("QW Withholding by GE Line", TRUE);
            IF (SalesInvoiceLine.FINDSET) THEN
                REPEAT
                    SalesLine.TRANSFERFIELDS(SalesInvoiceLine);
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."QW Withholding by GE Line" := FALSE;
                    SalesLine.VALIDATE(Quantity, -SalesLine.Quantity);
                    SalesLine.INSERT(TRUE);
                UNTIL SalesInvoiceLine.NEXT = 0;
        END ELSE BEGIN
            SalesCrMemoLine.RESET;
            SalesCrMemoLine.SETRANGE("Document No.", WithholdingMovements."Document No.");
            SalesCrMemoLine.SETRANGE("QW Withholding by GE Line", TRUE);
            IF (SalesCrMemoLine.FINDSET) THEN
                REPEAT
                    SalesLine.TRANSFERFIELDS(SalesCrMemoLine);
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."QW Withholding by GE Line" := FALSE;
                    SalesLine.VALIDATE(Quantity, -SalesLine.Quantity);
                    SalesLine.INSERT(TRUE);
                UNTIL SalesCrMemoLine.NEXT = 0;
        END;

        IF WithholdingMovements.Amount >= 0 THEN
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::FB
        ELSE
            WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::AB;
        WithholdingMovements."Released-to Doc. No" := SalesHeader."No.";
        WithholdingMovements."Released-to Bill No." := '';
        WithholdingMovements.VALIDATE("Released-to Document No.");
        WithholdingMovements.MODIFY;
    END;

    PROCEDURE FunMarkApplication(VAR parWithholdingMovements: Record 7207329);
    BEGIN
        IF parWithholdingMovements."Applies-to ID" <> '' THEN
            parWithholdingMovements."Applies-to ID" := ''
        ELSE
            parWithholdingMovements."Applies-to ID" := USERID;
        parWithholdingMovements.MODIFY;
    END;

    PROCEDURE FunMarkPostApplication(VAR parWithholdingMovements: Record 7207329);
    VAR
        locWithholdingMovements: Record 7207329;
        locWithholdingMovementsApply: Record 7207329;
        VarMovNumber: Integer;
        locWithholdingMovementsInsert: Record 7207329;
        locWithholdingMovementsApplyInsert: Record 7207329;
        Text003: TextConst ENU = 'There isn''t nothing to apply', ESP = 'No hay nada que liquidar';
    BEGIN
        locWithholdingMovements.RESET;
        IF locWithholdingMovements.FINDLAST THEN
            VarMovNumber := locWithholdingMovements."Entry No." + 1
        ELSE
            VarMovNumber := 1;

        locWithholdingMovements.SETCURRENTKEY(Open, Type, "No.", "Withholding Type", "Document No.", "Withholding treating", "Posting Date");
        locWithholdingMovements.SETRANGE(Open, TRUE);
        locWithholdingMovements.SETRANGE(Type, parWithholdingMovements.Type);
        locWithholdingMovements.SETRANGE("No.", parWithholdingMovements."No.");
        locWithholdingMovements.SETRANGE("Withholding Type", parWithholdingMovements."Withholding Type");
        locWithholdingMovements.SETRANGE("Withholding treating", parWithholdingMovements."Withholding treating");
        locWithholdingMovements.SETRANGE("Currency Code", parWithholdingMovements."Currency Code");
        locWithholdingMovements.SETRANGE("Global Dimension 1 Code", parWithholdingMovements."Global Dimension 1 Code");
        locWithholdingMovements.SETRANGE("Global Dimension 2 Code", parWithholdingMovements."Global Dimension 2 Code");
        locWithholdingMovements.SETRANGE("Applies-to ID", parWithholdingMovements."Applies-to ID");
        locWithholdingMovementsApply.COPYFILTERS(locWithholdingMovements);
        IF locWithholdingMovements.FINDSET(TRUE) THEN BEGIN
            IF locWithholdingMovements.Amount > 0 THEN
                locWithholdingMovementsApply.SETFILTER(Amount, '<0')
            ELSE
                locWithholdingMovementsApply.SETFILTER(Amount, '>0');
            IF NOT locWithholdingMovementsApply.FINDFIRST THEN
                ERROR(Text003);

            REPEAT
                IF locWithholdingMovements.Amount > 0 THEN
                    locWithholdingMovementsApply.SETFILTER(Amount, '<0')
                ELSE
                    locWithholdingMovementsApply.SETFILTER(Amount, '>0');
                IF NOT locWithholdingMovementsApply.FINDSET(TRUE) THEN
                    EXIT;
                REPEAT
                    IF ABS(locWithholdingMovements.Amount) > ABS(locWithholdingMovementsApply.Amount) THEN BEGIN
                        //Separo el original en dos y liquido uno
                        locWithholdingMovementsInsert := locWithholdingMovements;
                        VarMovNumber := VarMovNumber + 1;
                        locWithholdingMovementsInsert."Entry No." := VarMovNumber;
                        locWithholdingMovementsInsert.Amount := -locWithholdingMovementsApply.Amount;
                        locWithholdingMovementsInsert."Amount (LCY)" := -locWithholdingMovementsApply."Amount (LCY)";
                        locWithholdingMovementsInsert."Applies-to ID" := '';
                        locWithholdingMovementsInsert.Open := FALSE;
                        locWithholdingMovementsInsert."Release Date" := WORKDATE;
                        locWithholdingMovementsInsert."Released-to Movement No." := locWithholdingMovementsApply."Entry No.";
                        locWithholdingMovementsInsert."Released-to Doc. Type" := locWithholdingMovementsInsert."Released-to Doc. Type"::L;
                        locWithholdingMovementsInsert."Released-to Doc. No" := locWithholdingMovementsApply."Document No.";
                        locWithholdingMovementsInsert."Released-to Bill No." := '';
                        locWithholdingMovementsInsert.VALIDATE("Released-to Document No.");
                        locWithholdingMovementsInsert.INSERT;

                        locWithholdingMovementsApplyInsert := locWithholdingMovementsApply;
                        locWithholdingMovementsApplyInsert."Applies-to ID" := '';
                        locWithholdingMovementsApplyInsert.Open := FALSE;
                        locWithholdingMovementsApplyInsert."Release Date" := WORKDATE;
                        locWithholdingMovementsApplyInsert."Released-to Movement No." := locWithholdingMovementsInsert."Entry No.";
                        locWithholdingMovementsApplyInsert."Released-to Doc. Type" := locWithholdingMovementsInsert."Released-to Doc. Type"::L;
                        locWithholdingMovementsApplyInsert."Released-to Doc. No" := locWithholdingMovementsInsert."Document No.";
                        locWithholdingMovementsApplyInsert."Released-to Bill No." := '';
                        locWithholdingMovementsApplyInsert.VALIDATE("Released-to Document No.");
                        locWithholdingMovementsApplyInsert.MODIFY;
                        locWithholdingMovements.Amount := locWithholdingMovements.Amount + locWithholdingMovementsApply.Amount;
                        locWithholdingMovements."Amount (LCY)" := locWithholdingMovements."Amount (LCY)" +
                                                                   locWithholdingMovementsApply."Amount (LCY)";
                        locWithholdingMovements.MODIFY;
                    END ELSE BEGIN
                        IF ABS(locWithholdingMovements.Amount) = ABS(locWithholdingMovementsApply.Amount) THEN BEGIN
                            locWithholdingMovementsApplyInsert := locWithholdingMovementsApply;
                            locWithholdingMovementsApplyInsert."Applies-to ID" := '';
                            locWithholdingMovementsApplyInsert.Open := FALSE;
                            locWithholdingMovementsApplyInsert."Release Date" := WORKDATE;
                            locWithholdingMovementsApplyInsert."Released-to Movement No." := locWithholdingMovements."Entry No.";
                            locWithholdingMovementsApplyInsert."Released-to Doc. Type" := locWithholdingMovementsApplyInsert."Released-to Doc. Type"::L;
                            locWithholdingMovementsApplyInsert."Released-to Doc. No" := locWithholdingMovements."Document No.";
                            locWithholdingMovementsApplyInsert."Released-to Bill No." := '';
                            locWithholdingMovementsApplyInsert.VALIDATE("Released-to Document No.");
                            locWithholdingMovementsApplyInsert.MODIFY;
                            locWithholdingMovementsInsert := locWithholdingMovements;
                            locWithholdingMovementsInsert."Applies-to ID" := '';
                            locWithholdingMovementsInsert.Open := FALSE;
                            locWithholdingMovementsInsert."Release Date" := WORKDATE;
                            locWithholdingMovementsInsert."Released-to Movement No." := locWithholdingMovementsApply."Entry No.";
                            locWithholdingMovementsApplyInsert."Released-to Doc. Type" := locWithholdingMovementsApplyInsert."Released-to Doc. Type"::L;
                            locWithholdingMovementsApplyInsert."Released-to Doc. No" := locWithholdingMovementsApply."Document No.";
                            locWithholdingMovementsApplyInsert."Released-to Bill No." := '';
                            locWithholdingMovementsApplyInsert.VALIDATE("Released-to Document No.");
                            locWithholdingMovementsInsert.MODIFY;
                        END ELSE BEGIN
                            IF ABS(locWithholdingMovements.Amount) < ABS(locWithholdingMovementsApply.Amount) THEN BEGIN
                                //Separo el nuevo en dos y liquido uno
                                locWithholdingMovementsApplyInsert := locWithholdingMovementsApply;
                                VarMovNumber := VarMovNumber + 1;
                                locWithholdingMovementsApplyInsert."Entry No." := VarMovNumber;
                                locWithholdingMovementsApplyInsert.Amount := -locWithholdingMovements.Amount;
                                locWithholdingMovementsApplyInsert."Amount (LCY)" := -locWithholdingMovements."Amount (LCY)";
                                locWithholdingMovementsApplyInsert."Applies-to ID" := '';
                                locWithholdingMovementsApplyInsert.Open := FALSE;
                                locWithholdingMovementsApplyInsert."Release Date" := WORKDATE;
                                locWithholdingMovementsApplyInsert."Released-to Movement No." := locWithholdingMovements."Entry No.";
                                locWithholdingMovementsApplyInsert."Released-to Doc. Type" := locWithholdingMovementsApplyInsert."Released-to Doc. Type"::L;
                                locWithholdingMovementsApplyInsert."Released-to Doc. No" := locWithholdingMovements."Document No.";
                                locWithholdingMovementsApplyInsert."Released-to Bill No." := '';
                                locWithholdingMovementsApplyInsert.VALIDATE("Released-to Document No.");
                                locWithholdingMovementsApplyInsert.INSERT;

                                locWithholdingMovementsInsert := locWithholdingMovements;
                                locWithholdingMovementsInsert."Applies-to ID" := '';
                                locWithholdingMovementsInsert.Open := FALSE;
                                locWithholdingMovementsInsert."Release Date" := WORKDATE;
                                locWithholdingMovementsInsert."Released-to Movement No." := locWithholdingMovementsApplyInsert."Entry No.";
                                locWithholdingMovementsInsert."Released-to Doc. Type" := locWithholdingMovementsInsert."Released-to Doc. Type"::L;
                                locWithholdingMovementsInsert."Released-to Doc. No" := locWithholdingMovementsApplyInsert."Document No.";
                                locWithholdingMovementsInsert."Released-to Bill No." := '';
                                locWithholdingMovementsApplyInsert.VALIDATE("Released-to Document No.");
                                locWithholdingMovementsInsert.MODIFY;
                                locWithholdingMovementsApply.Amount := locWithholdingMovementsApply.Amount + locWithholdingMovements.Amount;
                                locWithholdingMovementsApply."Amount (LCY)" := locWithholdingMovementsApply."Amount (LCY)" +
                                                                           locWithholdingMovements."Amount (LCY)";
                                locWithholdingMovementsApply.MODIFY;
                            END;
                        END;
                    END;
                UNTIL locWithholdingMovementsApply.NEXT = 0;
            UNTIL locWithholdingMovements.NEXT = 0;
        END;
    END;

    PROCEDURE FunDeferWithholding(parWithholdingMovements: Record 7207329);
    VAR
        locWithholdingMovements: Record 7207329;
        pageDeferWithholding: Page 7207402;
        Amount: Decimal;
        Date1: Date;
        Date2: Date;
    BEGIN
        locWithholdingMovements.FILTERGROUP(2);
        locWithholdingMovements.SETRANGE("Entry No.", parWithholdingMovements."Entry No.");
        locWithholdingMovements.FILTERGROUP(0);
        CLEAR(pageDeferWithholding);
        pageDeferWithholding.SETTABLEVIEW(locWithholdingMovements);
        pageDeferWithholding.LOOKUPMODE(TRUE);
        IF (pageDeferWithholding.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            pageDeferWithholding.GetData(Amount, Date1, Date2);
            FunsplitWithholding(parWithholdingMovements, Amount, Date1, Date2);
        END;
    END;

    PROCEDURE FunsplitWithholding(pWithholdingMovementsToDefer: Record 7207329; pAmountToSplit: Decimal; pDueDate1: Date; pDueDate2: Date);
    VAR
        WithholdingMovements: Record 7207329;
        WithholdingMovements2: Record 7207329;
        Percentage: Decimal;
        Currency: Record 4;
        decAmountToReleaseCurrency: Decimal;
        VarMovNumber: Integer;
        Text004: TextConst ENU = 'Amount to be defered musn''t be higher than total withholding', ESP = 'El importe a fraccionar no debe ser mayor que la retenci¢n total';
    BEGIN
        IF ABS(pAmountToSplit) > ABS(pWithholdingMovementsToDefer.Amount) THEN
            ERROR(Text004, ABS(pWithholdingMovementsToDefer.Amount));

        IF (pWithholdingMovementsToDefer.Amount = 0) THEN
            Percentage := 0
        ELSE
            Percentage := ABS(pAmountToSplit) / ABS(pWithholdingMovementsToDefer.Amount);
        Currency.InitRoundingPrecision;

        IF pWithholdingMovementsToDefer."Currency Code" <> '' THEN BEGIN
            Currency.GET(pWithholdingMovementsToDefer."Currency Code");
            Currency.InitRoundingPrecision;
            decAmountToReleaseCurrency := ROUND(pWithholdingMovementsToDefer.Amount * Percentage, Currency."Amount Rounding Precision");
        END ELSE BEGIN
            decAmountToReleaseCurrency := pAmountToSplit;
        END;

        WithholdingMovements.LOCKTABLE;
        IF WithholdingMovements.FINDLAST THEN
            VarMovNumber := WithholdingMovements."Entry No." + 1
        ELSE
            VarMovNumber := 1;

        WithholdingMovements.INIT;
        IF (pAmountToSplit <> 0) THEN BEGIN //Si no hay importe solo cambia el vencimiento, si lo hay dividimos creando uno nuevo
            WithholdingMovements := pWithholdingMovementsToDefer;
            WithholdingMovements."Entry No." := VarMovNumber;
            WithholdingMovements."Withholding Base" := ROUND(WithholdingMovements."Withholding Base" * Percentage, Currency."Amount Rounding Precision");
            WithholdingMovements."Withholding Base (LCY)" := ROUND(WithholdingMovements."Withholding Base (LCY)" * Percentage, Currency."Amount Rounding Precision");
            WithholdingMovements.Amount := decAmountToReleaseCurrency;
            WithholdingMovements."Amount (LCY)" := pAmountToSplit;
            WithholdingMovements."Due Date" := pDueDate2;
            WithholdingMovements.INSERT;
        END;

        pWithholdingMovementsToDefer."Withholding Base" := pWithholdingMovementsToDefer."Withholding Base" - WithholdingMovements."Withholding Base";
        pWithholdingMovementsToDefer."Withholding Base (LCY)" := pWithholdingMovementsToDefer."Withholding Base (LCY)" - WithholdingMovements."Withholding Base (LCY)";
        pWithholdingMovementsToDefer.Amount := pWithholdingMovementsToDefer.Amount - decAmountToReleaseCurrency;
        pWithholdingMovementsToDefer."Amount (LCY)" := pWithholdingMovementsToDefer."Amount (LCY)" - pAmountToSplit;
        pWithholdingMovementsToDefer."Due Date" := pDueDate1;
        pWithholdingMovementsToDefer.MODIFY;
    END;

    PROCEDURE UpdateWithholdingDueDate(DocumentNo: Code[20]; PostingDate: Date; NewDueDate: Date; Messages: Boolean);
    VAR
        WithholdingMovements: Record 7207329;
    BEGIN
        //Actualizar el vto de la retenci�n
        WithholdingMovements.RESET;
        WithholdingMovements.SETRANGE(Type, WithholdingMovements.Type::Customer);
        WithholdingMovements.SETRANGE("Posting Date", PostingDate);
        WithholdingMovements.SETRANGE("Document No.", DocumentNo);
        IF (WithholdingMovements.FINDFIRST) THEN BEGIN
            IF (WithholdingMovements.Open) THEN BEGIN
                WithholdingMovements."Due Date" := NewDueDate;
                WithholdingMovements.MODIFY;
            END ELSE IF (Messages) THEN
                    MESSAGE('Solo se puede modificar el vencimiento de una retenci�n pendiente.');
        END;
    END;

    PROCEDURE CalcDueDate(CodigoRetencion: Code[20]; FechaVencimientoActual: Date; FechaVencimientoAnterior: Date; Fecha: Date): Date;
    VAR
        Textmsg01: TextConst ENU = 'La fecha de vto. de la retenci�n es MENOR a la anterior, �realmente desea cambiarla?';
        WithholdingGroup: Record 7207330;
    BEGIN
        //Q13647 +
        //JAV 19/10/21: - QB 1.09.22 Se amplia de Code[10] a Code[20] para evitar error de desbordamiento

        //Si hay una fecha de vencimiento la validamos sobre la anterior
        IF (FechaVencimientoAnterior <> 0D) AND (FechaVencimientoActual <> 0D) AND (FechaVencimientoActual < FechaVencimientoAnterior) THEN BEGIN
            IF CONFIRM(Textmsg01) THEN
                EXIT(FechaVencimientoAnterior)
            ELSE
                EXIT(Fecha);
        END;

        //Si no la hay la calculamos siempre que podamos hacerlo
        IF (Fecha = 0D) OR (CodigoRetencion = '') OR (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", CodigoRetencion)) THEN
            EXIT(0D);

        EXIT(CALCDATE(WithholdingGroup."Warranty Period", Fecha));
        //Q13647 -
    END;

    PROCEDURE AdjustCustomerDueDate(codigoProyecto: Code[20]);
    VAR
        Job: Record 167;
        WithholdingMovements: Record 7207329;
        WithholdingGroup: Record 7207330;
        newDate: Date;
    BEGIN
        //Q13647 +
        //JAV 19/10/21: - QB 1.09.22 Se amplia de Code[10] a Code[20] para evitar error de desbordamiento

        IF codigoProyecto = '' THEN
            EXIT;

        IF Job.GET(codigoProyecto) THEN BEGIN
            WithholdingMovements.SETRANGE("Job No.", codigoProyecto);
            WithholdingMovements.SETFILTER(Type, '%1', WithholdingMovements.Type::Customer);
            WithholdingMovements.SETFILTER("Withholding Type", '%1', WithholdingMovements."Withholding Type"::"G.E");
            WithholdingMovements.SETFILTER(Open, '%1', TRUE);
            IF WithholdingMovements.FINDSET(TRUE) THEN
                REPEAT
                    IF WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", WithholdingMovements."Withholding Code") THEN BEGIN
                        newDate := WithholdingMovements."Due Date";
                        IF WithholdingGroup."Calc Due Date" = WithholdingGroup."Calc Due Date"::DocDate THEN
                            newDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, WithholdingMovements."Posting Date")
                        ELSE
                            //CEI-15413-LCG-051021-INI
                            //newDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, Job."Ending Date");
                            newDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, EvaluatingEndingDateJob(Job));
                        //CEI-15413-LCG-051021-FIN

                        IF (newDate <> 0D) AND (newDate <> WithholdingMovements."Due Date") THEN BEGIN
                            WithholdingMovements."Due Date" := newDate;
                            WithholdingMovements.MODIFY;
                        END;
                    END;
                UNTIL WithholdingMovements.NEXT = 0;
        END;
        //Q13647 -
    END;

    PROCEDURE AdjustVendorDueDate(codigoProyecto: Code[20]; codigoProveedor: Code[20]; FechaDFin: Date);
    VAR
        Job: Record 167;
        WithholdingMovements: Record 7207329;
        WithholdingGroup: Record 7207330;
        Vendor: Record 23;
        Calc: Option "Doc","Work","Job";
        NewDate: Date;
    BEGIN
        //Q13647 +
        //JAV 19/10/21: - QB 1.09.22 Se amplia de Code[10] a Code[20] para evitar error de desbordamiento

        IF (codigoProyecto = '') THEN
            EXIT;

        IF Job.GET(codigoProyecto) THEN BEGIN
            WithholdingMovements.SETRANGE("Job No.", codigoProyecto);
            WithholdingMovements.SETFILTER(Type, '%1', WithholdingMovements.Type::Vendor);
            WithholdingMovements.SETFILTER("Withholding Type", '%1', WithholdingMovements."Withholding Type"::"G.E");
            WithholdingMovements.SETFILTER(Open, '%1', TRUE);
            IF codigoProveedor <> '' THEN
                WithholdingMovements.SETFILTER("No.", '%1', codigoProveedor);

            IF WithholdingMovements.FINDSET(TRUE) THEN
                REPEAT
                    IF WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", WithholdingMovements."Withholding Code") THEN BEGIN
                        IF NOT Vendor.GET(WithholdingMovements."No.") THEN
                            CLEAR(Vendor."QW Calc Due Date");

                        //El calculo se hace seg�n el grupo de retenci�n o el campo del proveedor
                        NewDate := WithholdingMovements."Due Date";
                        CASE TRUE OF
                            (WithholdingGroup."Calc Due Date" = WithholdingGroup."Calc Due Date"::DocDate) OR (Vendor."QW Calc Due Date" = Vendor."QW Calc Due Date"::DocDate):
                                NewDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, WithholdingMovements."Posting Date");
                            (WithholdingGroup."Calc Due Date" = WithholdingGroup."Calc Due Date"::WorkEnd) OR (Vendor."QW Calc Due Date" = Vendor."QW Calc Due Date"::WorkEnd):
                                NewDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, FechaDFin);
                            (WithholdingGroup."Calc Due Date" = WithholdingGroup."Calc Due Date"::JobEnd) OR (Vendor."QW Calc Due Date" = Vendor."QW Calc Due Date"::JobEnd):
                                //CEI-15413-LCG-051021-INI
                                NewDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, EvaluatingEndingDateJob(Job));
                        //NewDate := CalcDueDate(WithholdingGroup.Code, 0D, 0D, Job."Ending Date");
                        //CEI-15413-LCG-051021-FIN
                        END;

                        IF (NewDate <> 0D) AND (NewDate <> WithholdingMovements."Due Date") THEN BEGIN
                            WithholdingMovements."Due Date" := NewDate;
                            WithholdingMovements.MODIFY;
                        END;
                    END;
                UNTIL WithholdingMovements.NEXT = 0;
        END;
        //Q13647 -
    END;

    LOCAL PROCEDURE "----------------------------------------- Generar asientos y movimientos de retenci¢n"();
    BEGIN
    END;

    PROCEDURE FunGenerateVendorGLWithholdingMov(PurchaseHeader: Record 38; VAR TotalWithholding: Decimal; VAR cduPost: Codeunit 12; Post: Boolean);
    VAR
        PurchHeader: Record 38;
        PurchaseLine: Record 39;
        AmountGE: Decimal;
        AmountPIT: Decimal;
        BaseAmountGE: Decimal;
        BaseAmountPIT: Decimal;
    BEGIN
        CLEAR(cduPost); //JAV 14/07/21: - QB 1.09.04 Se limpia la code de registro antes de usarla para que no arrastre cosas que no debe

        PurchHeader.COPY(PurchaseHeader);

        AmountGE := 0;
        AmountPIT := 0;
        BaseAmountGE := 0;
        BaseAmountPIT := 0;

        //Si es un pedido, hay que promediar los importes sobre lo que se recibe realmente
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
            PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
            PurchaseLine.SETFILTER("Qty. to Receive", '<>0');
            PurchaseLine.SETFILTER(Quantity, '<>0');
            IF PurchaseLine.FINDSET(FALSE) THEN BEGIN
                REPEAT
                    IF (PurchaseLine."QW % Withholding by GE" <> 0) THEN BEGIN
                        BaseAmountGE += ROUND(PurchaseLine."QW Base Withholding by GE" * PurchaseLine."Qty. to Receive" / PurchaseLine.Quantity, 0.01);
                        AmountGE += ROUND(PurchaseLine."QW Withholding Amount by GE" * PurchaseLine."Qty. to Receive" / PurchaseLine.Quantity, 0.01);
                    END;
                    IF (PurchaseLine."QW % Withholding by PIT" <> 0) THEN BEGIN
                        BaseAmountPIT += ROUND(PurchaseLine."QW Base Withholding by PIT" * PurchaseLine."Qty. to Receive" / PurchaseLine.Quantity, 0.01);
                        AmountPIT += ROUND(PurchaseLine."QW Withholding Amount by PIT" * PurchaseLine."Qty. to Receive" / PurchaseLine.Quantity, 0.01);
                    END;
                UNTIL PurchaseLine.NEXT = 0;
            END;
        END ELSE BEGIN
            //Si es una factura, ya tenemos los importes calculados
            PurchaseHeader.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
            AmountGE := PurchaseHeader."QW Total Withholding GE";
            AmountPIT := PurchaseHeader."QW Total Withholding PIT";
            BaseAmountGE := PurchaseHeader."QW Base Withholding GE";
            BaseAmountPIT := PurchaseHeader."QW Base Withholding PIT";
        END;

        TotalWithholding := AmountGE + AmountPIT;

        IF Post THEN BEGIN
            IF (PurchaseHeader."QW Cod. Withholding by GE" <> '') AND (AmountGE <> 0) THEN
                FunGenerateVendorJournalAmount(OptType::GE, AmountGE, cduPost, BaseAmountGE, PurchaseHeader."Applies-to Doc. No.", PurchaseHeader); //JAV 30/06/22: - QB 1.10.57 Se pasa como par�metro la cabecera en lugar de usar una global

            IF (PurchaseHeader."QW Cod. Withholding by PIT" <> '') AND (AmountPIT <> 0) THEN
                FunGenerateVendorJournalAmount(OptType::PIT, AmountPIT, cduPost, BaseAmountPIT, PurchaseHeader."Applies-to Doc. No.", PurchHeader); //JAV 30/06/22: - QB 1.10.57 Se pasa como par�metro la cabecera en lugar de usar una global
        END;
    END;

    PROCEDURE FunGenerateVendorJournalAmount(Type: Option "GE","PIT"; DecAmount: Decimal; VAR cduPost: Codeunit 12; baseAmount: Decimal; parNoAppliedDoc: Code[20]; PurchHeader: Record 38);
    VAR
        QuoBuildingSetup: Record 7207278;
        GenJournalLine: Record 81;
        CurrExchRate: Record 330;
        PurchaseLine: Record 39;
        CduRegJournalGen: Codeunit 12;
        WithholdingGroup: Record 7207330;
        GLAccount: Record 15;
        RecSource: Record 242;
    BEGIN
        //JAV 30/06/22: - QB 1.10.57 Se pasa como par�metro la cabecera en lugar de usar una global

        GenJournalLine.INIT;
        GenJournalLine."Posting Date" := PurchHeader."Posting Date";
        GenJournalLine."Document No." := PurchHeader."Last Posting No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.VALIDATE("Account No.", PurchHeader."Pay-to Vendor No.");

        CASE Type OF
            Type::GE:
                BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. Pago ' + GenJournalLine.Description, 1, MAXSTRLEN(GenJournalLine.Description));
                    WithholdingGroup.GET(Type, PurchHeader."QW Cod. Withholding by GE");
                END;
            Type::PIT:
                BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. IRPF ' + GenJournalLine.Description, 1, MAXSTRLEN(GenJournalLine.Description));
                    WithholdingGroup.GET(Type, PurchHeader."QW Cod. Withholding by PIT");
                END;
        END;

        GenJournalLine."QW Withholding Entry" := TRUE; //QB_180720
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine."Posting Date" := PurchHeader."Posting Date";
        GenJournalLine.VALIDATE("Currency Code", PurchHeader."Currency Code");
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) OR
           (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) THEN
            GenJournalLine.VALIDATE(Amount, DecAmount);
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
            GenJournalLine.VALIDATE(Amount, -DecAmount);
        GenJournalLine."Currency Factor" := PurchHeader."Currency Factor";
        GenJournalLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
        RecSource.GET;
        GenJournalLine."Source Code" := RecSource.Purchases;
        GenJournalLine."System-Created Entry" := TRUE;

        //JMMA 24/01/20: - Se a�ade al diario el c�d. de proyecto para la retenci�n del proveedor.
        GenJournalLine."QW WithHolding Job No." := PurchHeader."QB Job No.";

        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) OR
           (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) THEN
            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";

        GenJournalLine."Applies-to Doc. No." := PurchHeader."Last Posting No.";
        GenJournalLine."Due Date" := PurchHeader."Due Date";
        GenJournalLine."Document Date" := PurchHeader."Document Date";
        GenJournalLine."Bill-to/Pay-to No." := PurchHeader."Buy-from Vendor No.";

        GenJournalLine."QW Withholding Type" := Type;
        IF Type = Type::GE THEN BEGIN
            GenJournalLine."QW Withholding Group" := PurchHeader."QW Cod. Withholding by GE";
        END ELSE BEGIN
            GenJournalLine."QW Withholding Group" := PurchHeader."QW Cod. Withholding by PIT";
        END;

        //Por si no viene calculada la fecha, se la pongo
        IF (PurchHeader."QW Witholding Due Date" = 0D) THEN
            PurchHeader.VALIDATE("QW Witholding Due Date");

        GenJournalLine."QW Withholding Due Date" := PurchHeader."QW Witholding Due Date";
        GLAccount.GET(WithholdingGroup."Withholding Account");

        //Montar la contrapartida
        VerificarCuenta(WithholdingGroup);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Bal. Account No.", WithholdingGroup."Withholding Account");

        PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");
        CASE PurchHeader."Document Type" OF
            PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::Order:
                BEGIN
                    GenJournalLine."External Document No." := PurchHeader."Vendor Invoice No.";
                    GenJournalLine.VALIDATE("QW Withholding Base", baseAmount);
                END;
            PurchHeader."Document Type"::"Credit Memo":
                BEGIN
                    GenJournalLine."External Document No." := PurchHeader."Vendor Cr. Memo No.";
                    GenJournalLine.VALIDATE("QW Withholding Base", -baseAmount);
                END;
        END;

        //JMMA 24/01/20: - Se a�ade al diario el c�d. de proyecto para la retenci�n del proveedor.
        GenJournalLine."QW WithHolding Job No." := PurchHeader."QB Job No.";

        GenJournalLine."QW Applies-to Withholding Doc." := parNoAppliedDoc;

        GenJournalLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
        GenJournalLine."Source No." := PurchHeader."Pay-to Vendor No.";
        GenJournalLine."Dimension Set ID" := PurchHeader."Dimension Set ID";

        cduPost.RunWithCheck(GenJournalLine);
    END;

    PROCEDURE FunGenerateCustomerGLWithholdingMov(parSalesHeader: Record 36; VAR TotalWithholding: Decimal; VAR cduGenJnlPostLine: Codeunit 12; Post: Boolean);
    VAR
        SalesHeader: Record 36;
        SalesLine: Record 37;
        AmountGE: Decimal;
        AmountPIT: Decimal;
        BaseAmountGE: Decimal;
        BaseAmountPIT: Decimal;
    BEGIN
        CLEAR(cduGenJnlPostLine); //JAV 14/07/21: - QB 1.09.04 Se limpia la code de registro antes de usarla para que no arrastre cosas que no debe

        SalesHeader.COPY(parSalesHeader);

        AmountGE := 0;
        AmountPIT := 0;
        BaseAmountGE := 0;
        BaseAmountPIT := 0;

        //Si es un pedido, hay que promediar los importes sobre lo que se sirve realmente
        IF parSalesHeader."Document Type" = parSalesHeader."Document Type"::Order THEN BEGIN
            SalesLine.SETRANGE("Document Type", parSalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", parSalesHeader."No.");
            SalesLine.SETFILTER("Qty. to Ship", '<>0');
            SalesLine.SETFILTER(Quantity, '<>0');
            IF SalesLine.FINDSET(FALSE) THEN BEGIN
                REPEAT
                    IF (SalesLine."QW % Withholding by GE" <> 0) THEN BEGIN
                        BaseAmountGE += ROUND(SalesLine."QW Base Withholding by GE" * SalesLine."Qty. to Ship" / SalesLine.Quantity, 0.01);
                        AmountGE += ROUND(SalesLine."QW Withholding Amount by GE" * SalesLine."Qty. to Ship" / SalesLine.Quantity, 0.01);
                    END;
                    IF (SalesLine."QW % Withholding by PIT" <> 0) THEN BEGIN
                        BaseAmountPIT += ROUND(SalesLine."QW Base Withholding by PIT" * SalesLine."Qty. to Ship" / SalesLine.Quantity, 0.01);
                        AmountPIT += ROUND(SalesLine."QW Withholding Amount by PIT" * SalesLine."Qty. to Ship" / SalesLine.Quantity, 0.01);
                    END;
                UNTIL SalesLine.NEXT = 0;
            END;
        END ELSE BEGIN
            //Si es una factura, ya tenemos los importes calculados
            parSalesHeader.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Base Withholding PIT", "QW Total Withholding PIT");
            AmountGE := parSalesHeader."QW Total Withholding GE";
            AmountPIT := parSalesHeader."QW Total Withholding PIT";
            BaseAmountGE := parSalesHeader."QW Base Withholding GE";
            BaseAmountPIT := parSalesHeader."QW Base Withholding PIT";
        END;

        TotalWithholding := AmountGE + AmountPIT;

        IF Post THEN BEGIN
            IF (parSalesHeader."QW Cod. Withholding by GE" <> '') AND (AmountGE <> 0) THEN
                FunGenerateCustomerJournalAmount(OptType::GE, AmountGE, cduGenJnlPostLine, BaseAmountGE, parSalesHeader."Applies-to Doc. No.", SalesHeader);  //JAV 30/06/22: - QB 1.10.57 Se pasa como par�metro la cabecera

            IF (parSalesHeader."QW Cod. Withholding by PIT" <> '') AND (AmountPIT <> 0) THEN
                FunGenerateCustomerJournalAmount(OptType::PIT, AmountPIT, cduGenJnlPostLine, BaseAmountPIT, parSalesHeader."Applies-to Doc. No.", SalesHeader);  //JAV 30/06/22: - QB 1.10.57 Se pasa como par�metro la cabecera
        END;
    END;

    PROCEDURE FunGenerateCustomerJournalAmount(type: Option "GE","PIT"; decAmount: Decimal; VAR parcduGenJnlPostLine: Codeunit 12; baseAmount: Decimal; parCodeNumDocApply: Code[20]; SalesHeader: Record 36);
    VAR
        GenJournalLine: Record 81;
        CurrExchRate: Record 330;
        SalesLine: Record 37;
        cduGenJnlPostLine: Codeunit 12;
        WithholdingGroup: Record 7207330;
        GLAccount: Record 15;
        SourceCodeSetup: Record 242;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 30/06/22: - QB 1.10.57 Se pasa como par�metro la cabecera en lugar de usar una global
        GenJournalLine.INIT;
        GenJournalLine."Posting Date" := SalesHeader."Posting Date";
        GenJournalLine."Document No." := SalesHeader."Last Posting No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine.VALIDATE("Account No.", SalesHeader."Bill-to Customer No.");

        CASE type OF
            type::GE:
                BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. Cobro ' + GenJournalLine.Description, 1, MAXSTRLEN(GenJournalLine.Description));
                    WithholdingGroup.GET(type, SalesHeader."QW Cod. Withholding by GE");
                END;
            type::PIT:
                BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. IRPF ' + GenJournalLine.Description, 1, MAXSTRLEN(GenJournalLine.Description));
                    WithholdingGroup.GET(type, SalesHeader."QW Cod. Withholding by PIT");
                END;
        END;

        GenJournalLine."QW Withholding Entry" := TRUE; //QB_180720
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine.VALIDATE("Currency Code", SalesHeader."Currency Code");
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            GenJournalLine.VALIDATE(Amount, -decAmount);
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
            GenJournalLine.VALIDATE(Amount, decAmount);

        GenJournalLine."Currency Factor" := SalesHeader."Currency Factor";
        GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
        SourceCodeSetup.GET;
        GenJournalLine."Source Code" := SourceCodeSetup.Sales;
        GenJournalLine."System-Created Entry" := TRUE;

        //JMMA 24/01/20: - Se a�ade al diario el c�d. de proyecto para la retenci�n del cliente.
        GenJournalLine."QW WithHolding Job No." := SalesHeader."QB Job No.";

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";

        GenJournalLine."Applies-to Doc. No." := SalesHeader."Last Posting No.";
        GenJournalLine."Due Date" := SalesHeader."Due Date";
        GenJournalLine."Document Date" := SalesHeader."Document Date";
        GenJournalLine."Bill-to/Pay-to No." := SalesHeader."Sell-to Customer No.";

        GenJournalLine."QW Withholding Type" := type;
        IF type = type::GE THEN BEGIN
            GenJournalLine."QW Withholding Group" := SalesHeader."QW Cod. Withholding by GE";
        END ELSE BEGIN
            GenJournalLine."QW Withholding Group" := SalesHeader."QW Cod. Withholding by PIT";
        END;

        //Por si no viene calculada la fecha, se la pongo
        IF (SalesHeader."QW Witholding Due Date" = 0D) THEN
            SalesHeader.VALIDATE("QW Witholding Due Date");

        GenJournalLine."QW Withholding Due Date" := SalesHeader."QW Witholding Due Date";
        GLAccount.GET(WithholdingGroup."Withholding Account");

        //Montar la contrapartida
        VerificarCuenta(WithholdingGroup);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Bal. Account No.", WithholdingGroup."Withholding Account");

        SalesHeader.CALCFIELDS(Amount, "Amount Including VAT");
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order:
                BEGIN
                    GenJournalLine.VALIDATE("QW Withholding Base", baseAmount);
                END;
            SalesHeader."Document Type"::"Credit Memo":
                BEGIN
                    GenJournalLine.VALIDATE("QW Withholding Base", -baseAmount);
                END;
        END;

        //JMMA 24/01/20: - Se a�ade al diario el c�d. de proyecto para la retenci�n del cliente.
        GenJournalLine."QW WithHolding Job No." := SalesHeader."QB Job No.";

        GenJournalLine."QW Applies-to Withholding Doc." := parCodeNumDocApply;
        GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::Customer;
        GenJournalLine."Source No." := SalesHeader."Bill-to Customer No.";
        GenJournalLine."Dimension Set ID" := SalesHeader."Dimension Set ID";

        parcduGenJnlPostLine.RunWithCheck(GenJournalLine);
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInitVAT, '', true, true)]
    LOCAL PROCEDURE OnBeforeInitVat(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR VATPostingSetup: Record 325);
    VAR
        WithholdingGroup: Record 7207330;
    BEGIN
        //JAV 22/08/19: - se captura el evento OnBeforeInitVAT de la codeunit 12, ya que si es una linea de retenci�n de pago no lleva IVA
        IF (GenJournalLine."QW Withholding Entry") AND (GenJournalLine."QW Withholding Type" = GenJournalLine."QW Withholding Type"::"G.E") THEN BEGIN
            WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", GenJournalLine."QW Withholding Group");
            IF WithholdingGroup."Withholding treating" = WithholdingGroup."Withholding treating"::"Payment Withholding" THEN
                GenJournalLine."Gen. Posting Type" := Enum::"General Posting Type".FromInteger(0);
        END;
    END;

    PROCEDURE FunGenerateWithholdingMov(GenJournalLine: Record 81; MovNo: Integer);
    VAR
        WithholdingMovements: Record 7207329;
        WithholdingMovements2: Record 7207329;
        DimMgt: Codeunit 408;
        WithholdingGroup: Record 7207330;
        WithholdingMovementsToApply: Record 7207329;
    BEGIN
        //Funci�n que general el movimiento de retenci�n a partir del diario contable

        IF GenJournalLine."QW Withholding Group" = '' THEN
            EXIT;

        WithholdingMovements.INIT;

        WithholdingMovements2.RESET;
        IF WithholdingMovements2.FINDLAST THEN
            WithholdingMovements."Entry No." := WithholdingMovements2."Entry No." + 1
        ELSE
            WithholdingMovements."Entry No." := 1;

        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN
            WithholdingMovements.Type := WithholdingMovements.Type::Vendor;
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer THEN
            WithholdingMovements.Type := WithholdingMovements.Type::Customer;

        WithholdingMovements."Movement No" := MovNo;
        WithholdingMovements.VALIDATE("No.", GenJournalLine."Account No.");  //JAV 07/06/22: - QB 1.10.49 Se cambia igual por validate para que cargue el nombre del cliente o proveedor
        WithholdingMovements."Posting Date" := GenJournalLine."Posting Date";
        WithholdingMovements."Document No." := GenJournalLine."Document No.";
        WithholdingMovements.Description := COPYSTR(GenJournalLine.Description, 1, MAXSTRLEN(WithholdingMovements.Description));
        WithholdingMovements."Withholding Code" := GenJournalLine."QW Withholding Group";

        IF GenJournalLine."QW Withholding Type" = GenJournalLine."QW Withholding Type"::"G.E" THEN BEGIN
            WithholdingMovements."Withholding Type" := WithholdingMovements."Withholding Type"::"G.E";
            WithholdingGroup.GET(WithholdingMovements."Withholding Type"::"G.E", WithholdingMovements."Withholding Code");
        END;

        IF GenJournalLine."QW Withholding Type" = GenJournalLine."QW Withholding Type"::PIT THEN BEGIN
            WithholdingMovements."Withholding Type" := WithholdingMovements."Withholding Type"::PIT;
            WithholdingGroup.GET(WithholdingMovements."Withholding Type"::PIT, WithholdingMovements."Withholding Code");
        END;

        WithholdingMovements."Currency Code" := GenJournalLine."Currency Code";
        WithholdingMovements."Global Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
        WithholdingMovements."Global Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
        WithholdingMovements."User ID" := USERID;
        WithholdingMovements."Source Code" := GenJournalLine."Source Code";
        WithholdingMovements."Due Date" := GenJournalLine."QW Withholding Due Date";
        WithholdingMovements."Document Date" := GenJournalLine."Document Date";
        WithholdingMovements."External Document No." := GenJournalLine."External Document No.";

        //JAV 26/03/22: - QB 1.10.28 A�adir el tipo de documento y cambiar el signo, positivo facturas negativo abonos tanto para clientes como proveedores
        IF (GenJournalLine."Applies-to Doc. Type" = GenJournalLine."Applies-to Doc. Type"::"Credit Memo") THEN BEGIN
            WithholdingMovements."Document Type" := WithholdingMovements."Document Type"::CrMemo;
            WithholdingMovements."Withholding Base" := -ABS(GenJournalLine."QW Withholding Base");
            WithholdingMovements."Withholding Base (LCY)" := -ABS(GenJournalLine."QW Withholding Base (LCY)");
            WithholdingMovements.Amount := -ABS(GenJournalLine.Amount);
            WithholdingMovements."Amount (LCY)" := -ABS(GenJournalLine."Amount (LCY)");
        END ELSE BEGIN
            WithholdingMovements."Document Type" := WithholdingMovements."Document Type"::Invoice;
            WithholdingMovements."Withholding Base" := ABS(GenJournalLine."QW Withholding Base");
            WithholdingMovements."Withholding Base (LCY)" := ABS(GenJournalLine."QW Withholding Base (LCY)");
            WithholdingMovements.Amount := ABS(GenJournalLine.Amount);
            WithholdingMovements."Amount (LCY)" := ABS(GenJournalLine."Amount (LCY)");
        END;

        WithholdingMovements.Open := TRUE;
        WithholdingMovements."Withholding treating" := WithholdingGroup."Withholding treating";
        WithholdingMovements."Dimension Set ID" := GenJournalLine."Dimension Set ID";

        //JMMA 24/01/20: - Se a�ade al movimiento de retenci�n el c�d. de proyecto.
        WithholdingMovements."Job No." := GenJournalLine."QW WithHolding Job No.";

        //JAV 26/05/20: - Se a�ade el porcentaje de retenci�n aplicado
        WithholdingMovements."Withholding %" := WithholdingGroup."Percentage Withholding";

        //JAV 25/11/21: - QB 1.10.01 A�adir el banco
        WithholdingMovements."QB Payment bank No." := GenJournalLine."QB Payment Bank No."; //Q13407

        WithholdingMovements.INSERT(TRUE);

        IF (GenJournalLine."QW Applies-to Withholding Doc." <> '') AND
           (GenJournalLine."Applies-to Doc. Type" = GenJournalLine."Applies-to Doc. Type"::"Credit Memo") THEN BEGIN
            WithholdingMovementsToApply.SETCURRENTKEY("Document No.", "Posting Date");
            WithholdingMovementsToApply.SETRANGE("Document No.", GenJournalLine."QW Applies-to Withholding Doc.");
            IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN
                WithholdingMovementsToApply.SETRANGE(Type, WithholdingMovementsToApply.Type::Vendor);
            IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer THEN
                WithholdingMovementsToApply.SETRANGE(Type, WithholdingMovementsToApply.Type::Customer);
            WithholdingMovementsToApply.SETRANGE("No.", GenJournalLine."Account No.");
            IF GenJournalLine."QW Withholding Type" = GenJournalLine."QW Withholding Type"::"G.E" THEN
                WithholdingMovementsToApply.SETRANGE("Withholding Type", WithholdingMovementsToApply."Withholding Type"::"G.E")
            ELSE
                WithholdingMovementsToApply.SETRANGE("Withholding Type", WithholdingMovementsToApply."Withholding Type"::PIT);
            WithholdingMovementsToApply.SETRANGE("Withholding Code", GenJournalLine."QW Withholding Group");
            WithholdingMovementsToApply.SETRANGE(Open, TRUE);
            IF WithholdingMovementsToApply.FINDFIRST THEN BEGIN
                WithholdingMovementsToApply."Applies-to ID" := WithholdingMovements."Document No.";
                WithholdingMovementsToApply.MODIFY;
            END;
            WithholdingMovementsToApply := WithholdingMovements;
            WithholdingMovementsToApply."Applies-to ID" := WithholdingMovements."Document No.";
            WithholdingMovementsToApply.MODIFY;
            FunMarkPostApplication(WithholdingMovementsToApply);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostPurchaseDoc_cu90(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        PurchaseLine: Record 39;
        GenJournalLine: Record 81;
        WithholdingGroup: Record 7207330;
        Base: Decimal;
        Amount: Decimal;
        Account: Code[20];
    BEGIN
        //JAV 29/10/19: - Se a�ade el movimento de retenci�n CON FACTURA, que no se crea autom�ticamente, aqu� solo si es para vista previa

        IF (NOT PreviewMode) THEN
            EXIT;
        IF NOT (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo",
                                                   PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Return Order"]) THEN
            EXIT;

        IF (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", PurchaseHeader."QW Cod. Withholding by GE")) THEN BEGIN
            Base := 0;
            Amount := 0;
            Account := '';

            IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"]) THEN BEGIN
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLine.SETRANGE("QW Withholding by GE Line", TRUE);
                IF (PurchaseLine.FINDSET(FALSE)) THEN
                    REPEAT
                        Account := PurchaseLine."No.";
                        Base += PurchaseLine."QW Base Withholding by GE";
                        Amount += -PurchaseLine.Amount
                    UNTIL PurchaseLine.NEXT = 0;
            END ELSE BEGIN
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLine.SETRANGE("QW Withholding by GE Line", FALSE);
                IF (PurchaseLine.FINDSET(FALSE)) THEN
                    REPEAT
                        Account := PurchaseLine."No.";
                        Base += ROUND(PurchaseLine."Qty. to Invoice" * PurchaseLine."Direct Unit Cost", 0.01);
                        Amount := ROUND(Base * WithholdingGroup."Percentage Withholding" / 100, 0.01);
                    UNTIL PurchaseLine.NEXT = 0;
            END;

            //Por si no viene calculada la fecha, se la pongo
            IF (PurchaseHeader."QW Witholding Due Date" = 0D) THEN
                PurchaseHeader.VALIDATE("QW Witholding Due Date");

            IF (Amount <> 0) THEN BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No." := PurchaseHeader."Buy-from Vendor No.";
                GenJournalLine."Posting Date" := PurchaseHeader."Posting Date";

                //JAV 26/03/22: - QB 1.10.28 Ponemos el tipo de documento para pasarlo a la retenci�n
                IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") THEN
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo"
                ELSE
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;

                GenJournalLine."Document No." := PurchaseHeader."No.";
                GenJournalLine."QW Withholding Group" := PurchaseHeader."QW Cod. Withholding by GE";
                GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
                GenJournalLine."Currency Code" := PurchaseHeader."Currency Code";
                GenJournalLine."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := PurchaseHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Dimension Set ID" := PurchaseHeader."Dimension Set ID";
                GenJournalLine."Source Code" := PurchaseHeader."Buy-from Vendor No.";
                GenJournalLine."QW Withholding Due Date" := PurchaseHeader."QW Witholding Due Date";
                GenJournalLine."Document Date" := PurchaseHeader."Document Date";
                GenJournalLine."QW WithHolding Job No." := PurchaseHeader."QB Job No.";
                IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) THEN BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. Fra. ' + PurchaseHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                    GenJournalLine.VALIDATE("QW Withholding Base", Base);
                    GenJournalLine.VALIDATE(Amount, Amount);
                    GenJournalLine."External Document No." := PurchaseHeader."Vendor Invoice No.";
                END ELSE BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. Ab. ' + PurchaseHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                    GenJournalLine.VALIDATE("QW Withholding Base", -Base);
                    GenJournalLine.VALIDATE(Amount, -Amount);
                    GenJournalLine."External Document No." := PurchaseHeader."Vendor Cr. Memo No.";
                END;
                FunGenerateWithholdingMov(GenJournalLine, 0);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnAfterPostPurchaseDoc_cu90(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]);
    VAR
        PurchInvHeader: Record 122;
        PurchInvLine: Record 123;
        PurchCrMemoHdr: Record 124;
        PurchCrMemoLine: Record 125;
        GenJournalLine: Record 81;
        WithholdingGroup: Record 7207330;
        WithholdingMovements: Record 7207329;
        Base: Decimal;
        Amount: Decimal;
        Account: Code[20];
    BEGIN
        //JAV 26/05/20: - Si la factura liquida una retenci�n, la marco como liquidada
        IF (PurchInvHeader.GET(PurchInvHdrNo)) THEN BEGIN
            IF (PurchInvHeader."QW Withholding mov liq." <> 0) THEN BEGIN
                IF (WithholdingMovements.GET(PurchInvHeader."QW Withholding mov liq.")) THEN BEGIN
                    PurchInvHeader.CALCFIELDS(Amount);
                    WithholdingMovements.Open := FALSE;
                    WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::FR;
                    WithholdingMovements."Released-to Doc. No" := PurchInvHeader."No.";
                    WithholdingMovements."Released-to Bill No." := '';
                    WithholdingMovements.VALIDATE("Released-to Document No.");
                    WithholdingMovements."Release Date" := PurchInvHeader."Posting Date";
                    WithholdingMovements."Released by Amount" := PurchInvHeader.Amount;

                    //JAV 25/11/21: - QB 1.10.01 A�adir el banco
                    WithholdingMovements."QB Payment bank No." := PurchInvHeader."QB Payment Bank No."; //Q13407

                    WithholdingMovements.MODIFY;
                END;
            END;
        END;
        IF (PurchCrMemoHdr.GET(PurchCrMemoHdrNo)) THEN BEGIN
            IF (PurchCrMemoHdr."QW Withholding mov liq." <> 0) THEN BEGIN
                IF (WithholdingMovements.GET(PurchCrMemoHdr."QW Withholding mov liq.")) THEN BEGIN
                    PurchCrMemoHdr.CALCFIELDS(Amount);
                    WithholdingMovements.Open := FALSE;
                    WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::AR;
                    WithholdingMovements."Released-to Doc. No" := PurchCrMemoHdr."No.";
                    WithholdingMovements."Released-to Bill No." := '';
                    WithholdingMovements.VALIDATE("Released-to Document No.");
                    WithholdingMovements."Release Date" := PurchCrMemoHdr."Posting Date";
                    WithholdingMovements."Released by Amount" := -PurchCrMemoHdr.Amount;

                    //JAV 25/11/21: - QB 1.10.01 A�adir el banco
                    WithholdingMovements."QB Payment bank No." := PurchCrMemoHdr."QB Payment Bank No."; //Q13407

                    WithholdingMovements.MODIFY;
                END;
            END;
        END;

        //JAV 29/10/19: - Se a�ade el movimento de retenci�n CON FACTURA, que no se crea autom�ticamente
        IF (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", PurchaseHeader."QW Cod. Withholding by GE")) THEN BEGIN
            Base := 0;
            Amount := 0;
            Account := '';
            IF (PurchInvHeader.GET(PurchInvHdrNo)) THEN BEGIN
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", PurchInvHdrNo);
                PurchInvLine.SETRANGE("QW Withholding by G.E Line", TRUE);
                IF (PurchInvLine.FINDSET(FALSE)) THEN
                    REPEAT
                        Account := PurchInvLine."No.";
                        Base += PurchInvLine."QW Base Withholding by GE";
                        IF (PurchInvLine."QW Withholding by G.E Line") THEN
                            Amount += -PurchInvLine.Amount
                        ELSE
                            Amount += PurchInvLine."QW Withholding Amount by GE";
                    UNTIL PurchInvLine.NEXT = 0;
            END;
            IF (PurchCrMemoHdr.GET(PurchCrMemoHdrNo)) THEN BEGIN
                PurchCrMemoLine.RESET;
                PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHdrNo);
                PurchCrMemoLine.SETRANGE("QW Withholding by GE Line", TRUE);
                IF (PurchCrMemoLine.FINDSET(FALSE)) THEN
                    REPEAT
                        Account := PurchCrMemoLine."No.";
                        Base += PurchCrMemoLine."QW Base Withholding by GE";
                        IF (PurchInvLine."QW Withholding by G.E Line") THEN
                            Amount -= -PurchInvLine.Amount
                        ELSE
                            Amount -= PurchInvLine."QW Withholding Amount by GE";
                    UNTIL PurchCrMemoLine.NEXT = 0;
            END;

            //Por si no viene calculada la fecha, se la pongo
            IF (PurchaseHeader."QW Witholding Due Date" = 0D) THEN   //JAV 30/06/22: - QB 1.10.57 Se cambia la variable que era err�nea
                PurchaseHeader.VALIDATE("QW Witholding Due Date");

            IF (Account <> '') THEN BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."Account No." := PurchaseHeader."Buy-from Vendor No.";
                GenJournalLine."Posting Date" := PurchaseHeader."Posting Date";

                IF (PurchInvHeader.GET(PurchInvHdrNo)) THEN BEGIN
                    //JAV 26/03/22: - QB 1.10.28 Ponemos el tipo de documento para pasarlo a la retenci�n
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
                    GenJournalLine."Document No." := PurchInvHeader."No.";
                    GenJournalLine.Description := COPYSTR('Ret. Fra. ' + PurchInvHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                END;
                IF (PurchCrMemoHdr.GET(PurchCrMemoHdrNo)) THEN BEGIN
                    //JAV 26/03/22: - QB 1.10.28 Ponemos el tipo de documento para pasarlo a la retenci�n
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";
                    GenJournalLine."Document No." := PurchCrMemoHdr."No.";
                    GenJournalLine.Description := COPYSTR('Ret. Fra. ' + PurchCrMemoHdr."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                END;

                GenJournalLine."QW Withholding Group" := PurchaseHeader."QW Cod. Withholding by GE";
                GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
                GenJournalLine."Currency Code" := PurchaseHeader."Currency Code";
                GenJournalLine."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := PurchaseHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Dimension Set ID" := PurchaseHeader."Dimension Set ID";
                GenJournalLine."Source Code" := PurchaseHeader."Buy-from Vendor No.";
                GenJournalLine."QW Withholding Due Date" := PurchaseHeader."QW Witholding Due Date";    //JAV 30/06/22: - QB 1.10.57 Se cambia la variable que era err�nea
                GenJournalLine."Document Date" := PurchaseHeader."Document Date";
                GenJournalLine."External Document No." := PurchaseHeader."Vendor Invoice No.";
                GenJournalLine.VALIDATE(Amount, Amount);
                GenJournalLine.VALIDATE("QW Withholding Base", Base);
                GenJournalLine."QW WithHolding Job No." := PurchaseHeader."QB Job No.";
                FunGenerateWithholdingMov(GenJournalLine, 0);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostSalesDoc_cu80(VAR Sender: Codeunit 80; VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        SalesLine: Record 37;
        GenJournalLine: Record 81;
        WithholdingGroup: Record 7207330;
        Base: Decimal;
        Amount: Decimal;
        Account: Code[20];
    BEGIN
        //JAV 29/10/19: - Se a�ade el movimento de retenci�n CON FACTURA, que no se crea autom�ticamente, aqu� solo si es para vista previa

        IF (NOT PreviewMode) THEN
            EXIT;
        IF NOT (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]) THEN
            EXIT;

        IF (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", SalesHeader."QW Cod. Withholding by GE")) THEN BEGIN
            Base := 0;
            Amount := 0;
            Account := '';

            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE("QW Withholding by GE Line", TRUE);
            IF (SalesLine.FINDSET(FALSE)) THEN
                REPEAT
                    Account := SalesLine."No.";
                    Base += SalesLine."QW Base Withholding by GE";
                    Amount += -SalesLine.Amount
                UNTIL SalesLine.NEXT = 0;

            //Por si no viene calculada la fecha, se la pongo
            IF (SalesHeader."QW Witholding Due Date" = 0D) THEN
                SalesHeader.VALIDATE("QW Witholding Due Date");

            IF (Account <> '') THEN BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                GenJournalLine."Account No." := SalesHeader."Sell-to Customer No.";
                GenJournalLine."Posting Date" := SalesHeader."Posting Date";

                //JAV 26/03/22: - QB 1.10.28 Ponemos el tipo de documento para pasarlo a la retenci�n
                IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") THEN
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo"
                ELSE
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;

                GenJournalLine."Document No." := SalesHeader."No.";
                GenJournalLine."QW Withholding Group" := SalesHeader."QW Cod. Withholding by GE";
                GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
                GenJournalLine."Currency Code" := SalesHeader."Currency Code";
                GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
                GenJournalLine."Source Code" := SalesHeader."Sell-to Customer No.";
                GenJournalLine."QW Withholding Due Date" := SalesHeader."QW Witholding Due Date";
                GenJournalLine."Document Date" := SalesHeader."Document Date";
                GenJournalLine."QW WithHolding Job No." := SalesHeader."QB Job No.";
                IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. Fra. ' + SalesHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                    GenJournalLine.VALIDATE("QW Withholding Base", Base);
                    GenJournalLine.VALIDATE(Amount, Amount);
                    GenJournalLine."External Document No." := '';
                END ELSE BEGIN
                    GenJournalLine.Description := COPYSTR('Ret. Ab. ' + SalesHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                    GenJournalLine.VALIDATE("QW Withholding Base", -Base);
                    GenJournalLine.VALIDATE(Amount, -Amount);
                    GenJournalLine."External Document No." := '';
                END;
                FunGenerateWithholdingMov(GenJournalLine, 0);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostSalesDoc, '', true, true)]
    LOCAL PROCEDURE OnAfterPostSalesDoc_cu80(VAR SalesHeader: Record 36; VAR GenJnlPostLine: Codeunit 12; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]);
    VAR
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        SalesCrMemoHeader: Record 114;
        SalesCrMemoLine: Record 115;
        GenJournalLine: Record 81;
        WithholdingGroup: Record 7207330;
        WithholdingMovements: Record 7207329;
        Base: Decimal;
        Amount: Decimal;
        Account: Code[20];
    BEGIN
        //JAV 26/05/20: - Si la factura liquida una retenci�n, la marco como liquidada
        IF (SalesInvoiceHeader.GET(SalesInvHdrNo)) THEN BEGIN
            IF (SalesInvoiceHeader."QW Withholding mov liq." <> 0) THEN BEGIN
                IF (WithholdingMovements.GET(SalesInvoiceHeader."QW Withholding mov liq.")) THEN BEGIN
                    SalesInvoiceHeader.CALCFIELDS(Amount);
                    WithholdingMovements.Open := FALSE;
                    WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::FR;
                    WithholdingMovements."Released-to Doc. No" := SalesInvoiceHeader."No.";
                    WithholdingMovements."Released-to Bill No." := '';
                    WithholdingMovements.VALIDATE("Released-to Document No.");
                    WithholdingMovements."Release Date" := SalesInvoiceHeader."Posting Date";
                    WithholdingMovements."Released by Amount" := SalesInvoiceHeader.Amount;

                    //JAV 25/11/21: - QB 1.10.01 A�adir el banco
                    WithholdingMovements."QB Payment bank No." := SalesInvoiceHeader."Payment bank No."; //Q13407

                    WithholdingMovements.MODIFY;
                END;
            END;
        END;
        IF (SalesCrMemoHeader.GET(SalesCrMemoHdrNo)) THEN BEGIN
            IF (SalesCrMemoHeader."QW Withholding mov liq." <> 0) THEN BEGIN
                IF (WithholdingMovements.GET(SalesCrMemoHeader."QW Withholding mov liq.")) THEN BEGIN
                    SalesCrMemoHeader.CALCFIELDS(Amount);
                    WithholdingMovements.Open := FALSE;
                    WithholdingMovements."Released-to Doc. Type" := WithholdingMovements."Released-to Doc. Type"::AR;
                    WithholdingMovements."Released-to Doc. No" := SalesCrMemoHeader."No.";
                    WithholdingMovements."Released-to Bill No." := '';
                    WithholdingMovements.VALIDATE("Released-to Document No.");
                    WithholdingMovements."Release Date" := SalesCrMemoHeader."Posting Date";
                    WithholdingMovements."Released by Amount" := -SalesCrMemoHeader.Amount;

                    //JAV 25/11/21: - QB 1.10.01 A�adir el banco
                    WithholdingMovements."QB Payment bank No." := SalesCrMemoHeader."Payment bank No."; //Q13407

                    WithholdingMovements.MODIFY;
                END;
            END;
        END;

        //JAV 29/10/19: - Se a�ade el movimento de retenci�n con factura, que no se crea autom�ticamente
        IF (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", SalesHeader."QW Cod. Withholding by GE")) THEN BEGIN
            Base := 0;
            Amount := 0;
            Account := '';
            IF (SalesInvoiceHeader.GET(SalesInvHdrNo)) THEN BEGIN
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", SalesInvHdrNo);
                SalesInvoiceLine.SETRANGE("QW Withholding by GE Line", TRUE);
                IF (SalesInvoiceLine.FINDSET(FALSE)) THEN
                    REPEAT
                        Account := SalesInvoiceLine."No.";
                        Base += SalesInvoiceLine."QW Base Withholding by GE";
                        IF (SalesInvoiceLine."QW Withholding by GE Line") THEN
                            Amount += -SalesInvoiceLine.Amount
                        ELSE
                            Amount += SalesInvoiceLine."QW Withholding Amount by GE";
                    UNTIL SalesInvoiceLine.NEXT = 0;
            END;
            IF (SalesCrMemoHeader.GET(SalesCrMemoHdrNo)) THEN BEGIN
                SalesCrMemoLine.RESET;
                SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdrNo);
                SalesCrMemoLine.SETRANGE("QW Withholding by GE Line", TRUE);
                IF (SalesCrMemoLine.FINDSET(FALSE)) THEN
                    REPEAT
                        Account := SalesCrMemoLine."No.";
                        Base += SalesCrMemoLine."QW Base Withholding by GE";
                        IF (SalesInvoiceLine."QW Withholding by GE Line") THEN
                            Amount -= -SalesInvoiceLine.Amount
                        ELSE
                            Amount -= SalesCrMemoLine."QW Withholding Amount by GE";
                    UNTIL SalesCrMemoLine.NEXT = 0;
            END;

            //Por si no viene calculada la fecha, se la pongo
            IF (SalesHeader."QW Witholding Due Date" = 0D) THEN
                SalesHeader.VALIDATE("QW Witholding Due Date");

            IF (Account <> '') THEN BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                GenJournalLine."Account No." := SalesHeader."Sell-to Customer No.";
                GenJournalLine."Posting Date" := SalesHeader."Posting Date";


                IF (SalesInvoiceHeader.GET(SalesInvHdrNo)) THEN BEGIN
                    //JAV 26/03/22: - QB 1.10.28 Ponemos el tipo de documento para pasarlo a la retenci�n
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
                    GenJournalLine."Document No." := SalesInvoiceHeader."No.";
                    GenJournalLine.Description := COPYSTR('Ret. Fra. ' + SalesInvoiceHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                END;
                IF (SalesCrMemoHeader.GET(SalesCrMemoHdrNo)) THEN BEGIN
                    //JAV 26/03/22: - QB 1.10.28 Ponemos el tipo de documento para pasarlo a la retenci�n
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";
                    GenJournalLine."Document No." := SalesCrMemoHeader."No.";
                    GenJournalLine.Description := COPYSTR('Ret. Fra. ' + SalesCrMemoHeader."Posting Description", 1, MAXSTRLEN(GenJournalLine.Description));
                END;

                GenJournalLine."QW Withholding Group" := SalesHeader."QW Cod. Withholding by GE";
                GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
                GenJournalLine."Currency Code" := SalesHeader."Currency Code";
                GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
                GenJournalLine."Source Code" := SalesHeader."Sell-to Customer No.";
                GenJournalLine."QW Withholding Due Date" := SalesHeader."QW Witholding Due Date";
                GenJournalLine."Document Date" := SalesHeader."Document Date";
                GenJournalLine."External Document No." := '';
                GenJournalLine.VALIDATE(Amount, Amount);
                GenJournalLine.VALIDATE("QW Withholding Base", Base);
                GenJournalLine."QW WithHolding Job No." := SalesHeader."QB Job No.";
                FunGenerateWithholdingMov(GenJournalLine, 0);
            END;
        END;
    END;

    LOCAL PROCEDURE VerificarCuenta(pGrupo: Record 7207330);
    VAR
        GLAccount: Record 15;
        Txt001: TextConst ENU = 'PIT Withholdings cannot be released', ESP = 'No ha especificado la cuenta de retenci¢n en el grupo %1';
        Txt002: TextConst ENU = 'Entry must be open', ESP = 'No existe la cuenta %1 especificada en el grupo de retenci¢n %2';
        Txt003: TextConst ESP = 'No debe informar el campo "%1" en la cuenta %2 para su uso en retenciones.';
        GenProductPostingGroup: Record 251;
        CompanyInformation: Record 79;
    BEGIN
        IF (pGrupo."Withholding Account" = '') THEN
            ERROR(Txt001, pGrupo.Code);

        IF NOT GLAccount.GET(pGrupo."Withholding Account") THEN
            ERROR(Txt002, pGrupo."Withholding Account", pGrupo.Code);

        //Esta informaci�n no se debe suministrar en las cuentas de retenci�n, si est� mal configurado puede dar errores
        //19170 -
        CompanyInformation.GET;
        IF CompanyInformation."QuoSII Activate" = TRUE THEN BEGIN
            IF GenProductPostingGroup.GET(GLAccount."Gen. Prod. Posting Group") THEN
                IF GenProductPostingGroup."QuoSII IRPF Type" = FALSE THEN BEGIN
                    IF (GLAccount."Gen. Posting Type" <> GLAccount."Gen. Posting Type"::" ") THEN
                        ERROR(Txt003, GLAccount.FIELDCAPTION("Gen. Posting Type"), pGrupo."Withholding Account");
                    IF (GLAccount."Gen. Bus. Posting Group" <> '') THEN
                        ERROR(Txt003, GLAccount.FIELDCAPTION("Gen. Bus. Posting Group"), pGrupo."Withholding Account");
                    IF (GLAccount."Gen. Prod. Posting Group" <> '') THEN
                        ERROR(Txt003, GLAccount.FIELDCAPTION("Gen. Prod. Posting Group"), pGrupo."Withholding Account");
                    IF (GLAccount."VAT Bus. Posting Group" <> '') THEN
                        ERROR(Txt003, GLAccount.FIELDCAPTION("VAT Bus. Posting Group"), pGrupo."Withholding Account");
                    IF (GLAccount."VAT Prod. Posting Group" <> '') THEN
                        ERROR(Txt003, GLAccount.FIELDCAPTION("VAT Prod. Posting Group"), pGrupo."Withholding Account");
                END;
        END ELSE BEGIN
            //19170 +
            IF (GLAccount."Gen. Posting Type" <> GLAccount."Gen. Posting Type"::" ") THEN
                ERROR(Txt003, GLAccount.FIELDCAPTION("Gen. Posting Type"), pGrupo."Withholding Account");
            IF (GLAccount."Gen. Bus. Posting Group" <> '') THEN
                ERROR(Txt003, GLAccount.FIELDCAPTION("Gen. Bus. Posting Group"), pGrupo."Withholding Account");
            IF (GLAccount."Gen. Prod. Posting Group" <> '') THEN
                ERROR(Txt003, GLAccount.FIELDCAPTION("Gen. Prod. Posting Group"), pGrupo."Withholding Account");
            IF (GLAccount."VAT Bus. Posting Group" <> '') THEN
                ERROR(Txt003, GLAccount.FIELDCAPTION("VAT Bus. Posting Group"), pGrupo."Withholding Account");
            IF (GLAccount."VAT Prod. Posting Group" <> '') THEN
                ERROR(Txt003, GLAccount.FIELDCAPTION("VAT Prod. Posting Group"), pGrupo."Withholding Account");
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos de Tabla relacionados con Retenciones"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QW Cod. Withholding by GE", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_CodWithholdingGE(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    BEGIN
        //JAV 16/07/21: - QB 1.09.06 Se trasladan acciones desde la tabla
        Rec.VALIDATE("QW Witholding Due Date", 0D);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "QW Witholding Due Date", true, true)]
    LOCAL PROCEDURE T36_OnAfterValidateEvent_WitholdingDueDate(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        WithholdingGroup: Record 7207330;
        SalesInvHdr: Record 112;
        BaseDate: Date;
    BEGIN
        //JAV 06/07/21: - QB 1.09.04 Validate de la fecha de vto. de la retenci�n
        Rec."QW Witholding Due Date" := 0D;

        IF (Rec."QW Cod. Withholding by GE" = '') OR (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", Rec."QW Cod. Withholding by GE")) THEN
            EXIT;

        IF (Rec."QB Job No." = '') OR (NOT Job.GET(Rec."QB Job No.")) THEN
            Job.INIT;
        //Q15413-LCG-141021-INI
        CASE WithholdingGroup."Calc Due Date" OF
            WithholdingGroup."Calc Due Date"::DocDate:
                BaseDate := Rec."Document Date";
            WithholdingGroup."Calc Due Date"::WorkEnd:
                BEGIN
                    //      SalesInvHdr.RESET();
                    //      SalesInvHdr.SETCURRENTKEY("Posting Date");
                    //      SalesHeader.SETRANGE(job);
                    //Preguntar como quieren sacar la �ltima factura de venta.
                END;
            WithholdingGroup."Calc Due Date"::JobEnd:

                //IF (WithholdingGroup."Calc Due Date" = WithholdingGroup."Calc Due Date"::JobEnd) THEN
                IF Rec."QB Job No." <> '' THEN
                    BaseDate := EvaluatingEndingDateJob(Job);
        //  IF (Job."Ending Date" <> 0D) THEN
        //    BaseDate := Job."Ending Date";
        END;
        //Q15413-LCG-141021-FIN
        Rec."QW Witholding Due Date" := CalcDueDate(Rec."QW Cod. Withholding by GE", Rec."QW Witholding Due Date", xRec."QW Witholding Due Date", BaseDate);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeRecreateSalesLines, '', true, true)]
    LOCAL PROCEDURE T37_OnBeforeRecreateSalesLines(VAR SalesHeader: Record 36);
    VAR
        WithholdingTreating: Codeunit 7207306;
        SalesLine: Record 37;
    BEGIN
        //JAV 03/09/19: - Para poder cambiar el cliente, elimino la l�nea de la retenci�n
        CalculateWithholding_SalesLine_GE_Invoice_Delete((SalesHeader."Document Type"), SalesHeader."No.");
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    LOCAL PROCEDURE "T37_OnAfterValidateEvent_Sell-toCustomerNo"(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        Customer: Record 18;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 03/09/19: - Se calculan las retenciones del cliente  23/10/19: - Se cambia a la CU de retenciones
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF Customer.GET(Rec."Bill-to Customer No.") THEN BEGIN
                Rec."QW Cod. Withholding by GE" := Customer."QW Withholding Group by GE";
                Rec."QW Cod. Withholding by PIT" := Customer."QW Withholding Group by PIT";
                //JAV 29/08/19: - Se recalculan las retenciones al traspasar al documento desde cliente o proveedor
                IF NOT Rec.MODIFY THEN;
                CalculateWithholding_SalesHeader(Rec);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "QW Cod. Withholding by GE", true, true)]
    LOCAL PROCEDURE T37_OnValidateCodWithholdingByGE(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text034: TextConst ENU = 'You must update lines manually', ESP = 'Debe actualizar las l¡neas manualmente';
    BEGIN
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF Rec.SalesLinesExist THEN
                IF Rec."QW Cod. Withholding by GE" <> xRec."QW Cod. Withholding by GE" THEN BEGIN
                    //JAV 11/08/19: - Al cambiar la retenci�n, actualizar las l�neas
                    Rec.MODIFY;
                    CalculateWithholding_SalesHeader(Rec);
                    //MESSAGE(Text034);
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, OnBeforeValidateEvent, "QW Cod. Withholding by PIT", true, true)]
    LOCAL PROCEDURE T37_OnValidateCodWithholdingByPIT(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text034: TextConst ENU = 'You must update lines manually', ESP = 'Debe actualizar las l¡neas manualmente';
    BEGIN
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF Rec.SalesLinesExist THEN
                IF Rec."QW Cod. Withholding by PIT" <> xRec."QW Cod. Withholding by PIT" THEN BEGIN
                    //JAV 11/08/19: - Al cambiar la retenci�n, actualizar las l�neas
                    Rec.MODIFY;
                    CalculateWithholding_SalesHeader(Rec);
                    //MESSAGE(Text034);
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QW Cod. Withholding by GE", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_CodWithholdingGE(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    BEGIN
        //JAV 16/07/21: - QB 1.09.06 Se trasladan acciones desde la tabla
        Rec.VALIDATE("QW Witholding Due Date", 0D);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "QW Witholding Due Date", true, true)]
    LOCAL PROCEDURE T38_OnAfterValidateEvent_WitholdingDueDate(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Job: Record 167;
        Vendor: Record 23;
        WithholdingGroup: Record 7207330;
        BaseDate: Date;
        PurchInvHeader: Record 122;
        NumCalcDueDate: Integer;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        //JAV 06/07/21: - QB 1.09.04 Validate de la fecha de vto. de la retenci�n
        Rec."QW Witholding Due Date" := 0D;

        IF (Rec."QW Cod. Withholding by GE" = '') OR (NOT WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", Rec."QW Cod. Withholding by GE")) THEN
            EXIT;

        IF (Rec."Buy-from Vendor No." = '') OR (NOT Vendor.GET(Rec."Buy-from Vendor No.")) THEN
            EXIT;

        IF (Rec."QB Job No." = '') OR (NOT Job.GET(Rec."QB Job No.")) THEN
            Job.INIT;

        //Si es por documento o si es la �ltima proforma, se hacen por la fecha del documento, si es por obra por fecha fin de obra
        //Q15413-LCG-141021-INI
        IF Vendor."QW Calc Due Date" <> Vendor."QW Calc Due Date"::Group THEN
            NumCalcDueDate := GetCalcDueDateOfVendor(Vendor)
        ELSE
            NumCalcDueDate := GetCalcDueDateOfWithh(WithholdingGroup);

        CASE NumCalcDueDate OF
            1:
                //Q15413-LCG-151021-INI
                CASE Rec."QB Calc Due Date" OF
                    Rec."QB Calc Due Date"::Document:
                        BaseDate := Rec."Document Date";
                    Rec."QB Calc Due Date"::Reception:
                        BaseDate := Rec."QB Receipt Date";
                    Rec."QB Calc Due Date"::Approval:
                        BaseDate := Rec."OLD_QBApproval Date";
                    Rec."QB Calc Due Date"::Standar:
                        BEGIN
                            QuoBuildingSetup.GET();
                            CASE QuoBuildingSetup."Calc Due Date" OF
                                QuoBuildingSetup."Calc Due Date"::Standar, QuoBuildingSetup."Calc Due Date"::Document:
                                    BaseDate := Rec."Document Date";
                                QuoBuildingSetup."Calc Due Date"::Reception:
                                    BaseDate := Rec."QB Receipt Date";
                                QuoBuildingSetup."Calc Due Date"::Approval:
                                    BaseDate := Rec."OLD_QBApproval Date";
                            END;
                        END;
                END;
            //Q15413-LCG-151021-FIN
            2:
                BEGIN

                    PurchInvHeader.RESET;
                    PurchInvHeader.SETCURRENTKEY("Posting Date");
                    PurchInvHeader.SETRANGE("Job No.", Rec."QB Job No.");
                    PurchInvHeader.SETRANGE("Order No.", Rec."QB Order No.");
                    IF PurchInvHeader.FINDLAST THEN
                        BaseDate := PurchInvHeader."Document Date";
                END;
            //IF (WithholdingGroup."Calc Due Date" = WithholdingGroup."Calc Due Date"::JobEnd) OR (Vendor."QW Calc Due Date" = Vendor."QW Calc Due Date"::JobEnd) THEN

            3:
                IF Rec."QB Job No." <> '' THEN
                    BaseDate := EvaluatingEndingDateJob(Job);
        END;
        //  IF (Job."Ending Date" <> 0D) THEN
        //    BaseDate := Job."Ending Date";
        //Q15413-LCG-141021-FIN

        Rec."QW Witholding Due Date" := CalcDueDate(Rec."QW Cod. Withholding by GE", Rec."QW Witholding Due Date", xRec."QW Witholding Due Date", BaseDate);
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeRecreatePurchLines, '', true, true)]
    LOCAL PROCEDURE T39_OnBeforeRecreatePurchLines(VAR PurchHeader: Record 38);
    VAR
        WithholdingTreating: Codeunit 7207306;
    BEGIN
        //JAV 03/09/19: - Para poder cambiar el proveedor, elimino la l�nea de la retenci�n
        CalculateWithholding_PurchaseLine_GE_Invoice_Delete(ConvertDocumentTypeToOptionPurchaseDocumentType(PurchHeader."Document Type"), PurchHeader."No.");
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE "T39_OnAfterValidateEvent_Buy-fromVendorNo"(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Vendor: Record 23;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //JAV 03/09/19: - Se calculan las retenciones del proveedor  23/10/19: - Se cambia a la CU de retenciones
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF Vendor.GET(Rec."Pay-to Vendor No.") THEN BEGIN
                Rec."QW Cod. Withholding by GE" := Vendor."QW Withholding Group by G.E.";
                Rec."QW Cod. Withholding by PIT" := Vendor."QW Withholding Group by PIT";
                //JAV 29/08/19: - Se recalculan las retenciones al traspasar al documento desde cliente o proveedor
                IF NOT Rec.MODIFY THEN;
                CalculateWithholding_PurchaseHeader(Rec);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "QW Cod. Withholding by GE", true, true)]
    LOCAL PROCEDURE T39_OnValidateCodWithholdingByGE(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text034: TextConst ENU = 'You must update lines manually', ESP = 'Debe actualizar las l¡neas manualmente';
    BEGIN
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF Rec.PurchLinesExist THEN
                IF Rec."QW Cod. Withholding by GE" <> xRec."QW Cod. Withholding by GE" THEN BEGIN
                    //JAV 11/08/19: - Al cambiar la retenci�n, actualizar las l�neas
                    Rec.MODIFY;
                    CalculateWithholding_PurchaseHeader(Rec);
                    //MESSAGE(Text034);
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 38, OnBeforeValidateEvent, "QW Cod. Withholding by PIT", true, true)]
    LOCAL PROCEDURE T39_OnValidateCodWithholdingByPIT(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
        Text034: TextConst ENU = 'You must update lines manually', ESP = 'Debe actualizar las l¡neas manualmente';
    BEGIN
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF Rec.PurchLinesExist THEN
                IF Rec."QW Cod. Withholding by PIT" <> xRec."QW Cod. Withholding by PIT" THEN BEGIN
                    //JAV 11/08/19: - Al cambiar la retenci�n, actualizar las l�neas
                    Rec.MODIFY;
                    CalculateWithholding_PurchaseHeader(Rec);
                    //MESSAGE(Text034);
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "Ending Date", true, true)]
    PROCEDURE T167_OnAfterValidateEndingDate(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    VAR
        txtmsglocal01: TextConst ENU = 'The end-of-time date has been changed, do you want to change the expiration of the warranty withholding as well?', ESP = 'Se ha cambiado la fecha de fin de obra, �desea cambiar tambi�n los vencimientos de las retenciones de garant�a?';
        WithholdingMovements: Record 7207329;
    BEGIN
        //-------------------------------------------------------------------------------------------------------------------------
        // Q13647 - Verificar si cambia la fecha de fin de la obra si se desea cambiar los vencimientos de las retenciones
        //-------------------------------------------------------------------------------------------------------------------------
        //Q13647 +
        //Solo si tenemos activo el m�dulo de retenciones
        IF (FunctionQB.AccessToWithholding) THEN BEGIN
            //Si ha cambiado la fecha de fin y es un proyecto operativo
            IF (xRec."Ending Date" <> Rec."Ending Date") AND (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") THEN BEGIN
                //CEI-15413-LCG-051021-INI
                OnAfterValidateDueDate(Rec, xRec);
                //    //Solo si tiene retenciones registradas
                //    WithholdingMovements.RESET;
                //    WithholdingMovements.SETRANGE("Job No.", Rec."No.");
                //    IF (NOT WithholdingMovements.ISEMPTY) THEN
                //      IF CONFIRM(txtmsglocal01,TRUE) THEN BEGIN
                //        //Cambiar las de clientes y las de proveedores
                //        AdjustCustomerDueDate(Rec."No.");
                //        AdjustVendorDueDate(Rec."No.",'',0D);
                //      END;
            END;
        END;
        //Q13647 -
        //CEI-15413-LCG-051021-FIN
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "End Prov. Date Construction", true, true)]
    LOCAL PROCEDURE T167_OnAfterJobGaranteeDateInit(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    BEGIN
        //CEI-15413-LCG-051021-INI
        //Solo si tenemos activo el m�dulo de retenciones
        IF (FunctionQB.AccessToWithholding) THEN BEGIN
            //Si ha cambiado la fecha de fin y es un proyecto operativo
            IF (xRec."Job Guarrantee Date Init" <> Rec."Job Guarrantee Date Init") AND (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") THEN
                OnAfterValidateDueDate(Rec, xRec);
        END;
        //CEI-15413-LCG-051021-FIN
    END;

    [EventSubscriber(ObjectType::Table, 167, OnAfterValidateEvent, "End Prov. Date Construction", true, true)]
    LOCAL PROCEDURE T167_OnAfterEndProvDateConstruction(VAR Rec: Record 167; VAR xRec: Record 167; CurrFieldNo: Integer);
    BEGIN
        //CEI-15413-LCG-051021-INI
        //Solo si tenemos activo el m�dulo de retenciones
        IF (FunctionQB.AccessToWithholding) THEN BEGIN
            //Si ha cambiado la fecha de fin y es un proyecto operativo
            IF (xRec."End Prov. Date Construction" <> Rec."End Prov. Date Construction") AND (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") THEN
                OnAfterValidateDueDate(Rec, xRec);
        END;
        //CEI-15413-LCG-051021-FIN
    END;

    [EventSubscriber(ObjectType::Table, 7206960, OnAfterValidateEvent, "Last Proform", true, true)]
    PROCEDURE T7206960_OnAfterValidateEvent_LastProform(VAR Rec: Record 7206960; VAR xRec: Record 7206960; CurrFieldNo: Integer);
    VAR
        Msg001: TextConst ENU = 'The end-of-time date has been changed, do you want to change the expiration of the warranty withholding as well?', ESP = '�Desea cambiar los vencimientos de las retenciones de garant�a a partir del %1?';
        WithholdingMovements: Record 7207329;
        WithholdingTreating: Codeunit 7207306;
    BEGIN
        //JAV  06/07/21: - QB 1.09.04 Validate de la �ltima proforma para cerrar el trabajo, si existen retenciones del proveedor las recalcula

        IF (Rec."Last Proform") AND (Rec."Last Proform" <> xRec."Last Proform") THEN BEGIN
            WithholdingMovements.RESET;
            WithholdingMovements.SETRANGE("Job No.", Rec."Job No.");
            WithholdingMovements.SETFILTER(Type, '%1', WithholdingMovements.Type::Vendor);
            WithholdingMovements.SETFILTER("Withholding Type", '%1', WithholdingMovements."Withholding Type"::"G.E");
            WithholdingMovements.SETFILTER(Open, '%1', TRUE);
            WithholdingMovements.SETFILTER("No.", '%1', Rec."Buy-from Vendor No.");

            IF (NOT WithholdingMovements.ISEMPTY) THEN
                IF (CONFIRM(Msg001, TRUE, Rec."Order Date")) THEN
                    AdjustVendorDueDate(Rec."Job No.", Rec."Buy-from Vendor No.", Rec."Order Date");
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos de CU relacionados con Retenciones"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterPostVend, '', true, true)]
    LOCAL PROCEDURE CU12_GenerateVendorWithholdingMovs(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToWithholding THEN
            FunGenerateWithholdingMov(GenJournalLine, TempGLEntryBuf."Entry No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterPostCust, '', true, true)]
    LOCAL PROCEDURE CU12_GenerateCustomerWithholdingMovs(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    BEGIN
        IF FunctionQB.AccessToWithholding THEN
            FunGenerateWithholdingMov(GenJournalLine, TempGLEntryBuf."Entry No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitVendLedgEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnAfterInitVendLedgEntry(VAR VendorLedgerEntry: Record 25; GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToWithholding THEN
            VendorLedgerEntry."QW Withholding Entry" := GenJournalLine."QW Withholding Entry";
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInitCustLedgEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record 21; GenJournalLine: Record 81);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        IF FunctionQB.AccessToWithholding THEN
            CustLedgerEntry."QW Withholding Entry" := GenJournalLine."QW Withholding Entry";
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostCustomerEntry, '', true, true)]
    LOCAL PROCEDURE CU80_OnAfterPostCustomerEntry(VAR GenJnlLine: Record 81; VAR SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    VAR
        CurrExchRate: Record 330;
        decTotalWithholding: Decimal;
        decTotalWithholdingLCY: Decimal;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Esta funci�n se lanza tras registrar el importe del cliente en el diario, aqu� la capturamos para crear y descontar la retenci�n de Buena Ejecuci�n
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF SalesHeader.Invoice THEN BEGIN
                IF SalesHeader."No. Series" <> SalesHeader."Posting No. Series" THEN
                    SalesHeader."Last Posting No." := SalesHeader."Posting No."
                ELSE
                    SalesHeader."Last Posting No." := SalesHeader."No.";

                //decTotalWithholding := 0;  //JAV 30/06/22: - QB 1.10.57 Este c�lculo no sirve para nada pues no se usa
                FunGenerateCustomerGLWithholdingMov(SalesHeader, decTotalWithholding, GenJnlPostLine, TRUE);
                //decTotalWithholdingLCY := 0;
                //IF SalesHeader."Currency Code" <> '' THEN BEGIN
                //  decTotalWithholdingLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date",SalesHeader."Currency Code",decTotalWithholding,SalesHeader."Currency Factor"));
                //END ELSE
                //  decTotalWithholdingLCY := decTotalWithholding;

                SalesHeader."Last Posting No." := '';
                IF SalesHeader."Bal. Account No." <> '' THEN BEGIN
                    CLEAR(GenJnlPostLine);
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostBalancingEntry, '', true, true)]
    LOCAL PROCEDURE CU80_OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; SalesHeader: Record 36; VAR TotalSalesLine: Record 37; VAR TotalSalesLineLCY: Record 37; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        CurrencyExRate: Record 330;
        AmountGE: Decimal;
        AmountGE_LCY: Decimal;
        AmountPIT: Decimal;
        AmountPIT_LCY: Decimal;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Si el documento tiene una forma de pago que se liquida autom�ticamente, debemos reducir los importes de la retenci�n del total a pagar
        //                           No se puede hacer con el proceso anterior porque los importes no se pasan con VAR a la siguiente funci�n y se pierde el cambio
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        SalesHeader.CALCFIELDS("QW Total Withholding GE", "QW Total Withholding PIT");
        AmountGE := SalesHeader."QW Total Withholding GE";
        IF SalesHeader."Currency Code" <> '' THEN BEGIN
            AmountGE_LCY := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date", SalesHeader."Currency Code", AmountGE, SalesHeader."Currency Factor"));
        END ELSE
            AmountGE_LCY := AmountGE;

        AmountPIT := SalesHeader."QW Total Withholding PIT";
        IF SalesHeader."Currency Code" <> '' THEN BEGIN
            AmountPIT_LCY := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date", SalesHeader."Currency Code", AmountPIT, SalesHeader."Currency Factor"));
        END ELSE
            AmountPIT_LCY := AmountPIT;

        //-Q19571 AML Correcci�n
        //GenJnlLine.Amount -= (AmountGE + AmountPIT);
        //GenJnlLine."Amount (LCY)" -= (AmountGE_LCY + AmountPIT_LCY);
        GenJnlLine.Amount += (AmountGE + AmountPIT);
        GenJnlLine."Amount (LCY)" += (AmountGE_LCY + AmountPIT_LCY);
        //+Q19571
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostVendorEntry, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostVendorEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; CommitIsSupressed: Boolean; VAR GenJnlPostLine: Codeunit 12);
    VAR
        CurrencyExRate: Record 330;
        decTotalWithholding: Decimal;
        decTotalWithholdingLCY: Decimal;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Esta funci�n se lanza tras registrar el importe del proveedor en el diario, aqu� la capturamos para crear y descontar la retenci�n de Buena Ejecuci�n
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF PurchHeader.Invoice THEN BEGIN
                IF PurchHeader."No. Series" <> PurchHeader."Posting No. Series" THEN
                    PurchHeader."Last Posting No." := PurchHeader."Posting No."
                ELSE
                    PurchHeader."Last Posting No." := PurchHeader."No.";
                //decTotalWithholding := 0;    //JAV 30/06/22: - QB 1.10.57 Este c�lculo no sirve para nada pues no se usa
                FunGenerateVendorGLWithholdingMov(PurchHeader, decTotalWithholding, GenJnlPostLine, TRUE);
                //decTotalWithholdingLCY := 0;
                //IF PurchHeader."Currency Code" <> '' THEN BEGIN
                //  decTotalWithholding := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date",PurchHeader."Currency Code",decTotalWithholding,PurchHeader."Currency Factor"));
                //END ELSE
                //  decTotalWithholdingLCY := decTotalWithholding;
                PurchHeader."Last Posting No." := '';
                IF PurchHeader."Bal. Account No." <> '' THEN BEGIN
                    CLEAR(GenJnlPostLine);
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostBalancingEntry, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostBalancingEntry(VAR GenJnlLine: Record 81; VAR PurchHeader: Record 38; VAR TotalPurchLine: Record 39; VAR TotalPurchLineLCY: Record 39; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    VAR
        CurrencyExRate: Record 330;
        AmountGE: Decimal;
        AmountGE_LCY: Decimal;
        AmountPIT: Decimal;
        AmountPIT_LCY: Decimal;
    BEGIN
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //JAV 30/06/22: - QB 1.10.57 Si el documento tiene una forma de pago que se liquida autom�ticamente, debemos reducir los importes de la retenci�n del total a pagar
        //                           No se puede hacer con el proceso anterior porque los importes no se pasan con VAR a la siguiente funci�n y se pierde el cambio
        //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        PurchHeader.CALCFIELDS("QW Total Withholding GE", "QW Total Withholding PIT");
        AmountGE := PurchHeader."QW Total Withholding GE";
        IF PurchHeader."Currency Code" <> '' THEN BEGIN
            AmountGE_LCY := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date", PurchHeader."Currency Code", AmountGE, PurchHeader."Currency Factor"));
        END ELSE
            AmountGE_LCY := AmountGE;

        AmountPIT := PurchHeader."QW Total Withholding PIT";
        IF PurchHeader."Currency Code" <> '' THEN BEGIN
            AmountPIT_LCY := ROUND(CurrencyExRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date", PurchHeader."Currency Code", AmountPIT, PurchHeader."Currency Factor"));
        END ELSE
            AmountPIT_LCY := AmountPIT;

        GenJnlLine.Amount -= (AmountGE + AmountPIT);
        GenJnlLine."Amount (LCY)" -= (AmountGE_LCY + AmountPIT_LCY);
    END;

    [EventSubscriber(ObjectType::Codeunit, 6620, OnAfterUpdatePurchLine, '', true, true)]
    LOCAL PROCEDURE CU6620_UpdatePurchLine(VAR ToPurchHeader: Record 38; VAR ToPurchLine: Record 39; VAR FromPurchHeader: Record 38; VAR FromPurchLine: Record 39; VAR CopyThisLine: Boolean; RecalculateAmount: Boolean; FromPurchDocType: Option; VAR CopyPostedDeferral: Boolean);
    BEGIN
        ToPurchLine."QW Withholding Amount by GE" := 0;
        ToPurchLine."QW Withholding Amount by PIT" := 0;
    END;

    [EventSubscriber(ObjectType::Codeunit, 6620, OnAfterCopyPurchaseDocument, '', true, true)]
    LOCAL PROCEDURE CU6620_OnAfterCopyPurchaseDocument(FromDocumentType: Option; FromDocumentNo: Code[20]; VAR ToPurchaseHeader: Record 38; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; IncludeHeader: Boolean);
    BEGIN
        CalculateWithholding_PurchaseHeader(ToPurchaseHeader);
    END;

    [EventSubscriber(ObjectType::Codeunit, 6620, OnAfterUpdateSalesLine, '', true, true)]
    LOCAL PROCEDURE CU6620_UpdateSalesLine(VAR ToSalesHeader: Record 36; VAR ToSalesLine: Record 37; VAR FromSalesHeader: Record 36; VAR FromSalesLine: Record 37; VAR CopyThisLine: Boolean; RecalculateAmount: Boolean; FromSalesDocType: Option; VAR CopyPostedDeferral: Boolean);
    BEGIN
        ToSalesLine."QW Withholding Amount by GE" := 0;
        ToSalesLine."QW Withholding Amount by PIT" := 0;
    END;

    [EventSubscriber(ObjectType::Codeunit, 6620, OnAfterCopySalesDocument, '', true, true)]
    LOCAL PROCEDURE CU6620_OnAfterCopySalesDocument(FromDocumentType: Option; FromDocumentNo: Code[20]; VAR ToSalesHeader: Record 36; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; IncludeHeader: Boolean);
    BEGIN
        CalculateWithholding_SalesHeader(ToSalesHeader);
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnBeforeTransferLineToPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU74_OnBeforeTransferLineToPurchaseDoc(VAR PurchRcptHeader: Record 120; VAR PurchRcptLine: Record 121; VAR PurchaseHeader: Record 38; VAR TransferLine: Boolean);
    VAR
        PurchaseHeaderOrder: Record 38;
    BEGIN
        //Al crear una factura desde un albar�n, toma las retenciones del contrato (pedido) de origen

        IF (PurchaseHeaderOrder.GET(PurchaseHeaderOrder."Document Type"::Order, PurchRcptHeader."Order No.")) THEN BEGIN
            PurchaseHeader.VALIDATE("QW Cod. Withholding by GE", PurchaseHeaderOrder."QW Cod. Withholding by GE");
            PurchaseHeader.VALIDATE("QW Cod. Withholding by PIT", PurchaseHeaderOrder."QW Cod. Withholding by PIT");
            PurchaseHeader.MODIFY(TRUE);
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnAfterInsertLines, '', true, true)]
    LOCAL PROCEDURE CU74_OnAfterInsertLines(VAR PurchHeader: Record 38);
    BEGIN
        //Recalcular las retenciones tras insertar las l�neas
        CalculateWithholding_PurchaseHeader(PurchHeader);
    END;

    LOCAL PROCEDURE "----------------------------------------- Eventos de Page relacionados con Retenciones (Navegar)"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 344, OnAfterNavigateFindRecords, '', true, true)]
    LOCAL PROCEDURE PG344_OnAfterNavigateFindRecords(VAR DocumentEntry: Record 265; DocNoFilter: Text; PostingDateFilter: Text);
    VAR
        WithholdingMovements: Record 7207329;
        Navigate: Page 344;
    BEGIN
        IF FunctionQB.AccessToWithholding THEN BEGIN
            IF WithholdingMovements.READPERMISSION THEN BEGIN
                WithholdingMovements.RESET;
                WithholdingMovements.SETCURRENTKEY("Document No.", "Posting Date");
                WithholdingMovements.SETFILTER("Document No.", DocNoFilter);
                WithholdingMovements.SETFILTER("Posting Date", PostingDateFilter);

                Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"Withholding Movements", Enum::"Document Entry Document Type".FromInteger(0), WithholdingMovements.TABLECAPTION, WithholdingMovements.COUNT);
            END;

        END;
    END;

    [EventSubscriber(ObjectType::Page, 344, OnAfterNavigateShowRecords, '', true, true)]
    LOCAL PROCEDURE PG344_OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; VAR TempDocumentEntry: Record 265 TEMPORARY);
    VAR
        WithholdingMovements: Record 7207329;
    BEGIN
        IF (TableID = DATABASE::"Withholding Movements") THEN BEGIN
            WithholdingMovements.RESET;
            WithholdingMovements.SETCURRENTKEY("Document No.", "Posting Date");
            WithholdingMovements.SETFILTER("Document No.", DocNoFilter);
            WithholdingMovements.SETFILTER("Posting Date", PostingDateFilter);

            PAGE.RUN(0, WithholdingMovements);
        END;
    END;

    LOCAL PROCEDURE "-----------------------------------------QRE"();
    BEGIN
    END;

    LOCAL PROCEDURE OnAfterValidateDueDate(VAR Rec: Record 167; VAR xRec: Record 167);
    VAR
        txtmsglocal01: TextConst ENU = 'The end-of-time date has been changed, do you want to change the expiration of the warranty withholding as well?', ESP = 'Se ha cambiado la fecha de fin de obra, �desea cambiar tambi�n los vencimientos de las retenciones de garant�a?';
        WithholdingMovements: Record 7207329;
        nDate: Date;
        xDate: Date;
    BEGIN
        //CEI-15413-LCG-051021-INI
        //-------------------------------------------------------------------------------------------------------------------------
        // Q13647 - Verificar si cambia la fecha de fin de la obra si se desea cambiar los vencimientos de las retenciones
        //-------------------------------------------------------------------------------------------------------------------------
        //Q13647 +
        //Solo si tenemos activo el m�dulo de retenciones
        IF (FunctionQB.AccessToWithholding) THEN BEGIN
            //Si ha cambiado la fecha de fin y es un proyecto operativo
            xDate := EvaluatingEndingDateJob(xRec);  //JAV 26/10/21: - QB 1.09.23 Debe calcularse seg�n las fechas indicadas, no cuando cambie cualquiera de ellas
            nDate := EvaluatingEndingDateJob(Rec);
            IF (Rec."Card Type" = Rec."Card Type"::"Proyecto operativo") AND (nDate <> xDate) THEN BEGIN
                //Solo si tiene retenciones registradas
                WithholdingMovements.RESET;
                WithholdingMovements.SETRANGE("Job No.", Rec."No.");
                IF (NOT WithholdingMovements.ISEMPTY) THEN
                    IF CONFIRM(txtmsglocal01, TRUE) THEN BEGIN
                        //Cambiar las de clientes y las de proveedores
                        AdjustCustomerDueDate(Rec."No.");
                        AdjustVendorDueDate(Rec."No.", '', 0D);
                    END;
            END;
        END;
        //Q13647 -
        //CEI-15413-LCG-051021-FIN
    END;

    LOCAL PROCEDURE EvaluatingEndingDateJob(Job: Record 167): Date;
    VAR
        TEXT0001Txt: TextConst ESP = 'Especifique ''Fecha Inicio Garant�a Obra'', ''Fecha final'' o ''Fecha prev. fin construcci�n'' en el proyecto %1.';
    BEGIN
        //CEI-15413-LCG-051021-INI
        //JAV 26/10/21: - QB 1.09.23 Se cambia el orden por uno mas adecuado
        IF (Job."Job Guarrantee Date Init" <> 0D) THEN
            EXIT(Job."Job Guarrantee Date Init")
        ELSE IF (Job."End Prov. Date Construction" <> 0D) THEN
            EXIT(Job."End Prov. Date Construction")
        ELSE IF (Job."Ending Date" <> 0D) THEN
            EXIT(Job."Ending Date")
        ELSE
            ERROR(TEXT0001Txt, Job."No.")
        //CEI-15413-LCG-051021-FIN
    END;

    PROCEDURE FunUnpaidWithholding(VAR WithholdingMovements: Record 7207329);
    VAR
        GenJournalLine: Record 81;
        grpWithholding: Record 7207330;
        GenJnlPostLine: Codeunit 12;
        GenJournalLine2: Record 81;
        GenJournalLine3: Record 81;
    BEGIN
        //Q15417 LCG 06/10/21-INI
        grpWithholding.RESET;
        grpWithholding.SETRANGE("Withholding Type", WithholdingMovements."Withholding Type");
        grpWithholding.SETRANGE(Code, WithholdingMovements."Withholding Code");
        grpWithholding.FINDFIRST();
        grpWithholding.TESTFIELD("Withholding Account");
        grpWithholding.TESTFIELD("QB_Unpaid Account");


        //Create the journal line:
        GenJournalLine.INIT();
        // GenJournalLine."Journal Template Name" := 'GENERAL';
        // GenJournalLine."Journal Batch Name" := 'PROYECTOS';
        GenJournalLine."Document No." := WithholdingMovements."Document No.";
        GenJournalLine3.RESET;
        GenJournalLine3.SETRANGE("Journal Template Name", '');
        GenJournalLine3.SETRANGE("Journal Batch Name", '');
        IF GenJournalLine3.FINDLAST THEN
            GenJournalLine."Line No." := GenJournalLine3."Line No." + 10000
        ELSE
            GenJournalLine."Line No." := 10000;

        GenJournalLine.VALIDATE("Posting Date", WORKDATE());
        GenJournalLine."Shortcut Dimension 1 Code" := WithholdingMovements."Global Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := WithholdingMovements."Global Dimension 2 Code";
        GenJournalLine.Description := COPYSTR('Impago ' + WithholdingMovements.Description, 1, MAXSTRLEN(GenJournalLine.Description));
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.VALIDATE("Account No.", grpWithholding."Withholding Account");
        GenJournalLine."External Document No." := WithholdingMovements."External Document No.";
        GenJournalLine."Currency Code" := WithholdingMovements."Currency Code";
        //JAV 28/03/22: - QB 1.10.28 Mirar el importe segun cliente/proveedor y tipo de documento
        IF (WithholdingMovements.Type = WithholdingMovements.Type::Customer) THEN BEGIN
            IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) THEN
                GenJournalLine.VALIDATE(Amount, WithholdingMovements.Amount)
            ELSE
                GenJournalLine.VALIDATE(Amount, -WithholdingMovements.Amount)
        END ELSE BEGIN
            IF (WithholdingMovements."Document Type" = WithholdingMovements."Document Type"::Invoice) THEN
                GenJournalLine.VALIDATE(Amount, -WithholdingMovements.Amount)
            ELSE
                GenJournalLine.VALIDATE(Amount, WithholdingMovements.Amount)
        END;

        GenJournalLine."QW Withholding Type" := GenJournalLine."QW Withholding Type"::"G.E";
        GenJournalLine."QW WithHolding Job No." := WithholdingMovements."Job No.";
        GenJournalLine."Job No." := WithholdingMovements."Job No.";
        GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.VALIDATE("Bal. Account No.", grpWithholding."QB_Unpaid Account");

        GenJournalLine.INSERT();

        CLEAR(GenJnlPostLine);
        GenJnlPostLine.RUN(GenJournalLine);

        WithholdingMovements.Open := FALSE;
        WithholdingMovements.QB_Unpaid := TRUE;
        WithholdingMovements.MODIFY();

        //Eliminar l�neas despu�s de registrar.
        GenJournalLine2.RESET();
        GenJournalLine2.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine2.SETRANGE("Line No.", GenJournalLine."Line No.");
        IF GenJournalLine2.FINDFIRST() THEN
            GenJournalLine2.DELETE();

        //Q15417 LCG 06/10/21-FIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE CU80_OnBeforePostSalesHeader(VAR Sender: Codeunit 80; VAR SalesHeader: Record 36; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    BEGIN
        //Q15413-LCG-141021-INI
        SalesHeader.VALIDATE("QW Witholding Due Date");
        SalesHeader.MODIFY();
        //Q15413-LCG-141021-FIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostPurchHeader(VAR Sender: Codeunit 90; VAR PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    BEGIN
        //Q15413-LCG-141021-INI
        PurchaseHeader.VALIDATE("QW Witholding Due Date");
        PurchaseHeader.MODIFY();
        //Q15413-LCG-141021-FIN
    END;

    LOCAL PROCEDURE GetCalcDueDateOfVendor(Vendor: Record 23): Integer;
    BEGIN
        CASE Vendor."QW Calc Due Date" OF
            Vendor."QW Calc Due Date"::DocDate:
                EXIT(1);
            Vendor."QW Calc Due Date"::WorkEnd:
                EXIT(2);
            Vendor."QW Calc Due Date"::JobEnd:
                EXIT(3);
        END;
    END;

    LOCAL PROCEDURE GetCalcDueDateOfWithh(WithholdingGroup: Record 7207330): Integer;
    BEGIN
        CASE WithholdingGroup."Calc Due Date" OF
            WithholdingGroup."Calc Due Date"::DocDate:
                EXIT(1);
            WithholdingGroup."Calc Due Date"::WorkEnd:
                EXIT(2);
            WithholdingGroup."Calc Due Date"::JobEnd:
                EXIT(3);
        END;
    END;

    LOCAL PROCEDURE "----------------------------------------- Funciones para el c lculo de la declaraci¢n de IRPF"();
    BEGIN
    END;

    PROCEDURE CalculateSumOfLines(VAR IRPFVATStatementLine: Record 7206979);
    VAR
        Lines: Record 7206979;
        Sum: Decimal;
    BEGIN
        //QRE-LCG-Q15408-141021-INI
        IF IRPFVATStatementLine.QB_Type <> IRPFVATStatementLine.QB_Type::"Row Totaling" THEN
            EXIT;

        Lines.RESET;
        Lines.SETRANGE("QB_IRPF Declaration", IRPFVATStatementLine."QB_IRPF Declaration");
        Lines.SETFILTER(QB_Type, '%1|%2', Lines.QB_Type::Numerical, Lines.QB_Type::Ask);
        Lines.SETFILTER("QB_No.", IRPFVATStatementLine."QB_Row Totaling");
        IF Lines.FINDSET() THEN
            REPEAT
                IF Lines.QB_Value <> '' THEN BEGIN

                    IF Lines."QB_Print with" = Lines."QB_Print with"::"Opposite Sign" THEN
                        Sum -= GetValueNumber(Lines.QB_Value)
                    ELSE
                        Sum += GetValueNumber(Lines.QB_Value);
                END;
            //Preguntar a Patricia como van a ser los valores y como coger decimales para sumarlos.
            UNTIL Lines.NEXT() = 0;
        //Convertimos a text la suma para asignarla a Valor del total.
        IRPFVATStatementLine.QB_Value := GetValueText(Sum);
        //QRE-LCG-Q15408-141021-FIN
    END;

    PROCEDURE UpdateSumOfRowTotaling(VAR IRPFVATStatementLine: Record 7206979; OldValueRow: Text[250]; NewValueRow: Text[250]) NumTotalTxt: Text[250];
    VAR
        NumTotalDec: Decimal;
    BEGIN
        //QRE-LCG-Q15408-141021-INI
        NumTotalDec := GetValueNumber(IRPFVATStatementLine.QB_Value) - GetValueNumber(OldValueRow) + GetValueNumber(NewValueRow);
        NumTotalTxt := GetValueText(NumTotalDec);
        //QRE-LCG-Q15408-141021-FIN
    END;

    LOCAL PROCEDURE GetValueNumber(Text: Text[250]): Decimal;
    VAR
        NumText: Text[250];
        NumDec: Decimal;
        i: Integer;
    BEGIN
        //QRE-LCG-Q15408-141021-INI
        //JAV 28/03/22: - QB 1.10.28 Quitar comas de separaci�n de miles y convertir el punto decimal en coma para Espa�a
        FOR i := 1 TO STRLEN(Text) DO BEGIN
            CASE COPYSTR(Text, i, 1) OF
                '.':
                    NumText += ',';
                ',':
                    NumText += '';
                ELSE
                    NumText += COPYSTR(Text, i, 1)
            END;
        END;
        EVALUATE(NumDec, NumText);
        EXIT(NumDec);
        //QRE-LCG-Q15408-141021-FIN
    END;

    LOCAL PROCEDURE GetValueText(Number: Decimal): Text[250];
    VAR
        pos: Integer;
        NumText: Text[250];
        NumText1: Text[250];
        NumText2: Text[250];
        counter: Integer;
        i: Integer;
    BEGIN
        //QRE-LCG-Q15408-141021-INI
        NumText := FORMAT(Number);
        NumText := DELCHR(NumText, '=', '.');
        pos := STRPOS(NumText, ',');
        IF pos <> 0 THEN BEGIN
            NumText2 := COPYSTR(NumText, pos + 1);
            IF STRLEN(NumText2) < 2 THEN
                NumText2 := NumText2 + '0';
            NumText1 := COPYSTR(NumText, 1, pos - 1);
            //NumText := DELCHR(NumText,'=',',')
            NumText := NumText1 + NumText2;
        END ELSE
            NumText := NumText + '00';
        counter := 17 - STRLEN(NumText);
        IF counter > 0 THEN
            FOR i := 1 TO counter DO
                NumText := '0' + NumText;
        EXIT(NumText);
        //QRE-LCG-Q15408-141021-FIN
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

        exit(optionValue)
    end;



    /*BEGIN
/*{
      PEL  20/07/18: - QB_180720 Se modifica el tipo de movimiento retenci�n.
      JAV  03/06/19: - Si usan el SII de Microsoft, no puede ser factura o abono para que no lo suba dos veces
      JAV  11/08/19: - Nuevas funciones para calcular el importe de las retenciones de facturas y sus l�neas de compra y de venta
      JAV  18/08/19: - Se elimina el campo "Estimation Type" que no tienen sentido usarse
      JAV  22/08/19: - se captura el evento OnBeforeInitVAT de la codeunit 12, ya que si es una linea de retenci�n de pago no lleva IVA
      JAV  31/08/19: - Se a�ade el proyecto a la l�nea del diario
      JAV  19/09/19: - Se a�aden eventos para recalcular las retenciones
      JAV  03/06/19: - No se sube la l�nea de la retenci�n en factura por esta rutina, se eliminan l�neas asociadas al asiento contable de estas retenciones
      JAV  19/10/19: - Se mejora para que en caso de calcular toda la factura no pase varias veces por el c�lculo de retenciones en factura
                     - No dejar borrar la l�nea de la retenci�n
      JAV  23/10/19: - Se trasladan los eventos de Retenciones de las CU de QuoBuilding
      JAV  29/10/19: - Se a�ade el movimento de retenci�n con factura, que no se crea autom�ticamente
      JMMA 24/01/20: - Se a�ade al movimiento de retenci�n el c�d. de proyecto.
      JAV  13/10/20: - QB 1.06.20 Puede existir documentos de varios proveedores o de varios clientes con el mismo n�mero, lo cambio para buscar el n.� del efecto
      JAV  18/10/20: - QB 1.06.21 Se limitan todos los campos description a su longitud m�xima
      JAV  19/10/20: - QB 1.06.21 Busco forma de pago para liquidar en el documento, si no puedo usarla se cambiar� a la del grupo registro, siempre debe poder generar efecto
      MMS  30/06/21: - Q13647 Gesti�n Retenciones.Se a�aden las funciones (CalcDueDate, AdjustVendorDueDate, AdjustCustomerDueDate) y funcion evento T167_OnAfterValidateEndingDate
      JAV  06/07/21: - QB 1.09.04 Validate de la fecha de vto. de la retenci�n en las funciones T36_OnAfterValidateEvent_QWWitholdingDueDate y T38_OnAfterValidateEvent_QWWitholdingDueDate
                                  Validate de la �ltima proforma en la funci�n T7206960_OnAfterValidateEvent_LastProform
      JAV  14/07/21: - QB 1.09.04 Se limpia la code de registro antes de usarla para que no arrastre cosas que no debe
      LCG  05/10/21: - Q15413-QRE A�adir para c�lculo vto, "Job Warranty Date Init" y "End Prov. Date Construction", adem�s de la que estaba. Si ninguna est� informada dar error
      LCG  06/10/21: - Q15417-QRE Crear funci�n para impagar retenciones.
      LCG  14/10/21: - Q15413-QRE Al calcula Fecha Vto. cambiar la operativa anterior. S�lo cog�a fecha registro.
      LCG  14/10/21: - Q15408-QRE A�adir funci�n para calcular la suma de filas cuando tipo es Row Totaling
      JAV  19/10/21: - QB 1.09.22 Se amplia de Code[10] a Code[20] para evitar error de desbordamiento en varios par�metros de funciones
      JAV  26/03/22: - QB 1.10.28 A�adir el tipo de documento a los movimientos de retenci�n
                                  Cambiar el signo, positivo facturas y negativo abonos tanto para clientes como proveedores
                                  Se permite liberar las retenciones generado factura a cartera en lugar de generar siempre efecto
      JAV  11/05/22: - QB 1.10.40 No subir a SII los movimientos de liberar la retenci�n
      JAV  07/06/22: - QB 1.10.49 Se cambia igual por validate para que cargue el nombre del cliente o proveedor
      JAV  30/06/22: - QB 1.10.57 Se cambia de nombre y del evento que captura CU80_GenerateWithholdingMovsSalesPost    por CU80_OnAfterPostCustomerEntry, dentro de esta se elimina un c�lculo que no se usa.
                                  Se cambia de nombre y del evento que captura CU90_GenerateWithholdingMovsPurchasePost por CU90_OnAfterPostVendorEntry,   dentro de esta se elimina un c�lculo que no se usa.
                                  Se a�anden las funciones CU80_OnBeforePostBalancingEntry y CU90_OnBeforePostBalancingEntry para ajustar el importe cuando la forma de pago liquida directamente el documento
                                  Se eliminan las variables globales PurchHeader y SalesHeader que pasan a ser locales y se arreglan lugares donde se usaban err�neamente
      JAV 13/10/22: - QB 1.12.03 (Q18139) Al dar el valor al n�mero del efecto cuando se crea uno, al buscar solo considerar los que sean num�ricos o tengan un n�mero al final
      PGM 21/03/23: 19170 Modificada la funci�n VerificarCuenta
      AML 29/05/23 Q19515 Correcci�n para evitar error por falta de fecha documento
      AML 31/05/23 Q19571 Correcci�n porque al tener retenciones en venta con forma de pago con contrapartida se liquidaba mal.
      CSM 04/07/23 - Q18032 Crear efecto al liberar retenci�n BE.
                     Modify FUNCTIONS: FunReleaseVendorWithholdingPayment, FunReleaseCustomerWithholdingPayment.
    }
END.*/
}








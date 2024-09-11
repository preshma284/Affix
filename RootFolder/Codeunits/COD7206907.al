Codeunit 7206907 "Contracts Control"
{


    TableNo = 38;
    trigger OnRun()
    BEGIN
    END;

    VAR

        tJob: ARRAY[20] OF Code[20];
        tContrato: ARRAY[20] OF Code[20];
        tImporte: ARRAY[20] OF Decimal;
        tDescuento: ARRAY[20] OF Decimal;
        Txt000: TextConst ESP = 'Ha sobrepasado el m�ximo del contrato \   Disponible: %1 \   Necesario..: %2';
        Txt001: TextConst ESP = 'Ha sobrepasado el m�ximo sin contrato \   Disponible: %1 \   Necesario..: %2';
        Txt002: TextConst ESP = '<Precision,2:2><Standard Format,0>';
        Txt003: TextConst ESP = '�Desea a�adir %1 al control del contrato?';
        Txt004: TextConst ESP = '�Desea a�adir %1 al control del proveedor?';

    PROCEDURE ModuloActivo(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        QuoBuildingSetup.GET();
        EXIT(QuoBuildingSetup."Use Contract Control");
    END;

    PROCEDURE AsociarContrato(parComparativo: Record 7207412; parBorrar: Boolean);
    VAR
        ControlContratos: Record 7206912;
        PurchaseHeader: Record 38;
        lComparativo: Record 7207413;
        importComp: Decimal;
    BEGIN
        //A�ade o quita un contrato del control de contratos
        IF NOT ModuloActivo THEN
            EXIT;

        //Lo leo para refrescar el valor del campo
        parComparativo.GET(parComparativo."No.");

        //Busco el documento de compra
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE("No.", parComparativo."Generated Contract Doc No.");
        PurchaseHeader.SETFILTER("Document Type", '%1|%2', PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Blanket Order");
        PurchaseHeader.FINDFIRST;
        PurchaseHeader.CALCFIELDS(Amount);

        //Q20392 El importe debe ser el del comparativo no el del pedido.
        importComp := 0;
        lComparativo.SETRANGE("Quote No.", parComparativo."No.");
        IF lComparativo.FINDSET THEN
            REPEAT
                lComparativo.CALCFIELDS("Purchase Amount");
                importComp += lComparativo."Purchase Amount";
            UNTIL lComparativo.NEXT = 0;

        //Creo el registro o lo elimino
        IF NOT parBorrar THEN
            //Q28392 Enviamos el precio del comparativo
            //InsertarDocumento(parComparativo."Job No.", parComparativo."Generated Contract Doc No.", parComparativo."Generated Contract Ext No.",
            //                  parComparativo."Selected Vendor", ControlContratos."Tipo Documento"::Order, parComparativo."Generated Contract Doc No.",
            //                  PurchaseHeader."Posting Date", PurchaseHeader.Amount, 0)
            InsertarDocumento(parComparativo."Job No.", parComparativo."Generated Contract Doc No.", parComparativo."Generated Contract Ext No.",
                          parComparativo."Selected Vendor", ControlContratos."Tipo Documento"::Order, parComparativo."Generated Contract Doc No.",
                          PurchaseHeader."Posting Date", importComp, 0)
        ELSE
            BorrarDocumento(parComparativo."Job No.", parComparativo."Generated Contract Doc No.", parComparativo."Generated Contract Ext No.");
    END;

    PROCEDURE VerificarImportes(VAR PurchaseHeader: Record 38);
    VAR
        ControlContratos: Record 7206912;
        Job: Record 167;
        Vendor: Record 23;
        NroContrato: Code[20];
        i: Integer;
        importe: Decimal;
    BEGIN
        //Verificar importes de contrato si est� activo el m�dulo
        IF NOT ModuloActivo THEN
            EXIT;

        //Si no se controla el proveedor, salimos
        Vendor.GET(PurchaseHeader."Buy-from Vendor No.");
        IF Vendor."QB Do not control in contracts" THEN
            EXIT;

        //Solo si es una factura verificar importes
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice THEN BEGIN

            FOR i := 1 TO MontarDocumento(PurchaseHeader."Document Type", PurchaseHeader."No.") DO BEGIN //enum to option
                IF Job.GET(tJob[i]) THEN BEGIN
                    //Solo para proyectos operativos y que no esten excluidos
                    IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") AND (NOT Job."No controlar en contratos") THEN BEGIN
                        //Verifico el m�ximo del contrato
                        IF (tContrato[i] <> '') THEN BEGIN
                            importe := DisponibleContrato(tJob[i], tContrato[i]);
                            IF tImporte[i] > importe THEN
                                ERROR(Txt000, FORMAT(importe, 0, Txt002), FORMAT(tImporte[i], 0, Txt002));
                        END;

                        //Verifico el m�ximos sin contrato
                        IF (tContrato[i] = '') THEN BEGIN
                            importe := DisponibleProveedor(tJob[i], PurchaseHeader."Buy-from Vendor No.");
                            IF tImporte[i] > importe THEN
                                ERROR(Txt001, FORMAT(importe, 0, Txt002), FORMAT(tImporte[i], 0, Txt002));
                        END;

                    END;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE DisponibleContrato(pJob: Code[20]; pContrato: Code[20]): Decimal;
    VAR
        ControlContratos: Record 7206912;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, pJob);
        ControlContratos.SETRANGE(Contrato, pContrato);
        ControlContratos.SETRANGE("Tipo Movimiento", ControlContratos."Tipo Movimiento"::TotGrupo);
        IF (ControlContratos.FINDFIRST) THEN BEGIN
            ControlContratos.CALCFIELDS("Suma Importe Pendiente");
            EXIT(ControlContratos."Suma Importe Pendiente");
        END ELSE BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Contratos Importe");
        END;
    END;

    LOCAL PROCEDURE DisponibleProveedor(pJob: Code[20]; pProveedor: Code[20]): Decimal;
    VAR
        ControlContratos: Record 7206912;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, pJob);
        ControlContratos.SETFILTER(Contrato, '');
        ControlContratos.SETRANGE(Proveedor, pProveedor);
        ControlContratos.SETRANGE("Tipo Movimiento", ControlContratos."Tipo Movimiento"::TotGrupo);
        IF (ControlContratos.FINDFIRST) THEN BEGIN
            ControlContratos.CALCFIELDS("Suma Importe Pendiente");
            EXIT(ControlContratos."Suma Importe Pendiente");
        END ELSE BEGIN
            QuoBuildingSetup.GET;
            EXIT(QuoBuildingSetup."Sin Contrato Importe");
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    PROCEDURE VerificarImportesRegistar(VAR PurchaseHeader: Record 38);
    VAR
        ControlContratos: Record 7206912;
        Job: Record 167;
        NroContrato: Code[20];
    BEGIN
        //Antes de registrar un documento de compra verificar importes de contrato
        IF NOT ModuloActivo THEN
            EXIT;

        VerificarImportes(PurchaseHeader);
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', true, true)]
    PROCEDURE AddDocumento(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]);
    VAR
        ControlContratos: Record 7206912;
        Job: Record 167;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
        PurchRcptHeader: Record 120;
        i: Integer;
    BEGIN
        //Insertar el documento si est� activo el m�dulo
        IF NOT ModuloActivo THEN
            EXIT;

        //Si es un albar�n
        IF (PurchRcpHdrNo <> '') THEN BEGIN
            PurchRcptHeader.GET(PurchRcpHdrNo);
            FOR i := 1 TO MontarAlbaran(PurchRcpHdrNo) DO BEGIN
                IF Job.GET(tJob[i]) THEN BEGIN
                    IF Job."Card Type" = Job."Card Type"::"Proyecto operativo" THEN BEGIN
                        InsertarDocumento(tJob[i], tContrato[i], 0, PurchRcptHeader."Buy-from Vendor No.", ControlContratos."Tipo Documento"::Albaran,
                                          PurchRcptHeader."No.", PurchRcptHeader."Posting Date", tImporte[i], 0);
                    END;
                END;
            END;
        END;

        //Si es una factura
        IF (PurchInvHdrNo <> '') THEN BEGIN
            PurchInvHeader.GET(PurchInvHdrNo);
            FOR i := 1 TO MontarFactura(PurchInvHdrNo) DO BEGIN
                IF Job.GET(tJob[i]) THEN BEGIN
                    IF Job."Card Type" = Job."Card Type"::"Proyecto operativo" THEN BEGIN
                        InsertarDocumento(tJob[i], tContrato[i], 0, PurchInvHeader."Buy-from Vendor No.", ControlContratos."Tipo Documento"::Invoice,
                                          PurchInvHeader."No.", PurchInvHeader."Posting Date", tImporte[i], tDescuento[i]);
                    END;
                END;
            END;
        END;

        //Si es un abono
        IF (PurchCrMemoHdrNo <> '') THEN BEGIN
            PurchCrMemoHdr.GET(PurchCrMemoHdrNo);
            FOR i := 1 TO MontarAbono(PurchCrMemoHdrNo) DO BEGIN
                IF Job.GET(tJob[i]) THEN BEGIN
                    IF Job."Card Type" = Job."Card Type"::"Proyecto operativo" THEN BEGIN
                        InsertarDocumento(tJob[i], tContrato[i], 0, PurchCrMemoHdr."Buy-from Vendor No.", ControlContratos."Tipo Documento"::"Credit Memo",
                                          PurchCrMemoHdr."No.", PurchCrMemoHdr."Posting Date", tImporte[i], 0);
                    END;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE MontarDocumento(pTipo: Enum "Purchase Document Type"; pNro: Code[20]): Integer;
    VAR
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchRcptLine: Record 121;
        contrato: Code[20];
        i: Integer;
        salir: Boolean;
    BEGIN
        CLEAR(tJob);
        CLEAR(tContrato);
        CLEAR(tImporte);
        CLEAR(tDescuento);

        PurchaseHeader.GET(pTipo, pNro);

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", pTipo);
        PurchaseLine.SETRANGE("Document No.", pNro);
        PurchaseLine.SETFILTER(Amount, '<>0');
        IF PurchaseLine.FINDSET(FALSE) THEN
            REPEAT
                i := 0;
                salir := FALSE;
                REPEAT
                    i += 1;

                    contrato := '';
                    IF PurchRcptLine.GET(PurchaseLine."Receipt No.", PurchaseLine."Receipt Line No.") THEN
                        contrato := PurchRcptLine."Order No.";
                    IF (contrato = '') THEN
                        contrato := PurchaseHeader."QB Contract No.";

                    IF ((tJob[i] = PurchaseLine."Job No.") AND (tContrato[i] = contrato)) OR
                       (tJob[i] = '') OR (i = ARRAYLEN(tJob)) THEN BEGIN
                        salir := TRUE;
                        tJob[i] := PurchaseLine."Job No.";
                        tContrato[i] := contrato;
                        tImporte[i] += PurchaseLine.Amount;
                        IF (PurchaseLine."Receipt No." <> '') THEN
                            tDescuento[i] += PurchaseLine.Amount;
                    END;
                UNTIL (salir);
            UNTIL PurchaseLine.NEXT = 0;
        EXIT(i);
    END;

    LOCAL PROCEDURE MontarAlbaran(pNro: Code[20]): Integer;
    VAR
        PurchRcptLine: Record 121;
        i: Integer;
        salir: Boolean;
    BEGIN
        CLEAR(tJob);
        CLEAR(tContrato);
        CLEAR(tImporte);
        CLEAR(tDescuento);

        PurchRcptLine.RESET;
        PurchRcptLine.SETRANGE("Document No.", pNro);
        PurchRcptLine.SETFILTER(Quantity, '<>0');
        IF PurchRcptLine.FINDSET(FALSE) THEN
            REPEAT
                i := 0;
                salir := FALSE;
                REPEAT
                    i += 1;
                    IF ((tJob[i] = PurchRcptLine."Job No.") AND (tContrato[i] = PurchRcptLine."Order No.")) OR
                       (tJob[i] = '') OR (i = ARRAYLEN(tJob)) THEN BEGIN
                        salir := TRUE;
                        tJob[i] := PurchRcptLine."Job No.";
                        tContrato[i] := PurchRcptLine."Order No.";
                        tImporte[i] += ROUND(PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost", 0.01);
                    END;
                UNTIL (salir);
            UNTIL PurchRcptLine.NEXT = 0;
        EXIT(i);
    END;

    LOCAL PROCEDURE MontarFactura(pNro: Code[20]): Integer;
    VAR
        PurchInvHeader: Record 122;
        PurchInvLine: Record 123;
        PurchRcptLine: Record 121;
        contrato: Code[20];
        i: Integer;
        salir: Boolean;
    BEGIN
        CLEAR(tJob);
        CLEAR(tContrato);
        CLEAR(tImporte);
        CLEAR(tDescuento);

        PurchInvHeader.GET(pNro);

        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Document No.", pNro);
        PurchInvLine.SETFILTER(Amount, '<>0');
        IF PurchInvLine.FINDSET(FALSE) THEN
            REPEAT
                i := 0;
                salir := FALSE;
                REPEAT
                    i += 1;

                    contrato := '';
                    IF PurchRcptLine.GET(PurchInvLine."Receipt No.", PurchInvLine."Receipt Line No.") THEN
                        contrato := PurchRcptLine."Order No.";
                    IF (contrato = '') THEN
                        contrato := PurchInvHeader."Contract No.";

                    IF ((tJob[i] = PurchInvLine."Job No.") AND (tContrato[i] = contrato)) OR
                       (tJob[i] = '') OR (i = ARRAYLEN(tJob)) THEN BEGIN
                        salir := TRUE;
                        tJob[i] := PurchInvLine."Job No.";
                        tContrato[i] := contrato;
                        tImporte[i] += PurchInvLine.Amount;
                        IF (PurchInvLine."Receipt No." <> '') THEN
                            tDescuento[i] += PurchInvLine.Amount;
                    END;
                UNTIL (salir);
            UNTIL PurchInvLine.NEXT = 0;
        EXIT(i);
    END;

    LOCAL PROCEDURE MontarAbono(pNro: Code[20]): Integer;
    VAR
        PurchCrMemoHdr: Record 124;
        PurchCrMemoLine: Record 125;
        PurchRcptLine: Record 121;
        i: Integer;
        salir: Boolean;
    BEGIN
        CLEAR(tJob);
        CLEAR(tContrato);
        CLEAR(tImporte);
        CLEAR(tDescuento);

        PurchCrMemoHdr.GET(pNro);

        PurchCrMemoLine.RESET;
        PurchCrMemoLine.SETRANGE("Document No.", pNro);
        PurchCrMemoLine.SETFILTER(Amount, '<>0');
        IF PurchCrMemoLine.FINDSET(FALSE) THEN
            REPEAT
                i := 0;
                salir := FALSE;
                REPEAT
                    i += 1;
                    IF ((tJob[i] = PurchCrMemoLine."Job No.") AND (tContrato[i] = PurchCrMemoHdr."Contract No.")) OR
                       (tJob[i] = '') OR (i = ARRAYLEN(tJob)) THEN BEGIN
                        salir := TRUE;
                        tJob[i] := PurchCrMemoLine."Job No.";
                        tContrato[i] := PurchCrMemoHdr."Contract No.";
                        tImporte[i] += PurchCrMemoLine.Amount;
                    END;
                UNTIL (salir);
            UNTIL PurchCrMemoLine.NEXT = 0;
        EXIT(i);
    END;

    LOCAL PROCEDURE BuscarContrato(parPurchaseHeader: Record 38): Code[20];
    VAR
        PurchaseLine: Record 39;
        PurchRcptHeader: Record 120;
    BEGIN
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document No.", parPurchaseHeader."No.");
        IF PurchaseLine.FINDSET(FALSE) THEN
            REPEAT
                IF PurchRcptHeader.GET(PurchaseLine."Receipt No.") THEN
                    EXIT(PurchRcptHeader."Order No.");
            UNTIL PurchaseLine.NEXT = 0;

        EXIT('');
    END;

    LOCAL PROCEDURE BuscarContratoFactura(parPurchInvHeader: Record 122): Code[20];
    VAR
        PurchInvLine: Record 123;
        PurchRcptHeader: Record 120;
    BEGIN
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Document No.", parPurchInvHeader."No.");
        IF PurchInvLine.FINDSET(FALSE) THEN
            REPEAT
                IF PurchRcptHeader.GET(PurchInvLine."Receipt No.") THEN
                    EXIT(PurchRcptHeader."Order No.");
            UNTIL PurchInvLine.NEXT = 0;

        EXIT('');
    END;

    LOCAL PROCEDURE CalcularAlbaranes(parPurchInvHeader: Record 122): Decimal;
    VAR
        PurchInvLine: Record 123;
        PurchRcptHeader: Record 120;
        Importe: Decimal;
    BEGIN
        Importe := 0;
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Document No.", parPurchInvHeader."No.");
        IF PurchInvLine.FINDSET(FALSE) THEN
            REPEAT
                IF (PurchInvLine."Receipt No." <> '') THEN
                    Importe += PurchInvLine.Amount;
            UNTIL PurchInvLine.NEXT = 0;

        EXIT(Importe);
    END;

    LOCAL PROCEDURE BuscarContratoAbono(parPurchCrMemoHdr: Record 124): Code[20];
    VAR
        PurchCrMemoLine: Record 125;
        PurchRcptHeader: Record 120;
    BEGIN
        PurchCrMemoLine.RESET;
        PurchCrMemoLine.SETRANGE("Document No.", parPurchCrMemoHdr."No.");
        IF PurchCrMemoLine.FINDSET(FALSE) THEN
            REPEAT
                IF PurchRcptHeader.GET(PurchCrMemoLine."Receipt No.") THEN
                    EXIT(PurchRcptHeader."Order No.");
            UNTIL PurchCrMemoLine.NEXT = 0;
        EXIT('');
    END;

    LOCAL PROCEDURE InsertarDocumento(parJob: Code[20]; parContrato: Code[20]; parAmpliacion: Integer; parVendor: Code[20]; parTipoDoc: Option; parNDoc: Code[20]; parFecha: Date; parImporte: Decimal; parDescontar: Decimal);
    VAR
        ControlContratos: Record 7206912;
    BEGIN
        ControlContratos.INIT;
        ControlContratos.Linea := 0;
        ControlContratos.Proyecto := parJob;
        ControlContratos.Contrato := parContrato;
        ControlContratos."Extension No." := parAmpliacion;
        ControlContratos.Fecha := parFecha;
        ControlContratos."Tipo Documento" := parTipoDoc;
        ControlContratos."No. Documento" := parNDoc;
        ControlContratos.Proveedor := parVendor;
        ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::Movimiento;
        CASE parTipoDoc OF
            ControlContratos."Tipo Documento"::Order:
                ControlContratos."Importe Contrato" := parImporte;
            ControlContratos."Tipo Documento"::Albaran:
                ControlContratos."Importe Albaran" := parImporte;
            ControlContratos."Tipo Documento"::Invoice:
                ControlContratos."Importe Factura/abono" := parImporte;
            ControlContratos."Tipo Documento"::"Credit Memo":
                ControlContratos."Importe Factura/abono" := -parImporte;
        END;
        ControlContratos."Importe Albaran" -= parDescontar;
        ControlContratos.INSERT(TRUE);
    END;

    LOCAL PROCEDURE BorrarDocumento(parJob: Code[20]; parContrato: Code[20]; parExtension: Integer);
    VAR
        ControlContratos: Record 7206912;
    BEGIN
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, parJob);
        ControlContratos.SETRANGE(Contrato, parContrato);
        ControlContratos.SETRANGE("Tipo Documento", ControlContratos."Tipo Documento"::Order);
        ControlContratos.SETRANGE("Extension No.", parExtension);
        ControlContratos.DELETEALL(TRUE);
    END;

    PROCEDURE AmpliarFactura(PurchaseHeader: Record 38);
    VAR
        Job: Record 167;
        ControlContratos: Record 7206912;
        Importe: Decimal;
        Ok: Boolean;
    BEGIN
        IF NOT ModuloActivo THEN
            EXIT;

        MontarDocumento(PurchaseHeader."Document Type", PurchaseHeader."No."); //enum to option
        IF Job.GET(tJob[1]) THEN BEGIN
            IF Job."Card Type" = Job."Card Type"::"Proyecto operativo" THEN BEGIN

                IF (tContrato[1] <> '') THEN BEGIN  //importe disponible del contrato
                    Importe := DisponibleContrato(tJob[1], tContrato[1]);
                    IF tImporte[1] > Importe THEN
                        Ok := CONFIRM(Txt003, FALSE, tImporte[1] - Importe);
                END ELSE BEGIN                      //importe disponible sin contrato
                    Importe := DisponibleProveedor(tJob[1], PurchaseHeader."Buy-from Vendor No.");
                    IF tImporte[1] > Importe THEN
                        Ok := CONFIRM(Txt004, FALSE, tImporte[1] - Importe);
                END;

                IF (Ok) THEN BEGIN
                    ControlContratos.INIT;
                    ControlContratos.Linea := 0;
                    ControlContratos.Proyecto := tJob[1];
                    ControlContratos.Contrato := tContrato[1];
                    ControlContratos.Fecha := TODAY;
                    ControlContratos."Tipo Documento" := ControlContratos."Tipo Documento"::Ampliacion;
                    ControlContratos."No. Documento" := PurchaseHeader."No.";
                    ControlContratos.Proveedor := PurchaseHeader."Buy-from Vendor No.";
                    ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::Movimiento;
                    ControlContratos."Importe Ampliaciones" := tImporte[1] - Importe;
                    ControlContratos.INSERT(TRUE);
                END;
            END;
        END;
    END;

    PROCEDURE AmpliarContrato(ComparativeQuoteHeader: Record 7207412);
    VAR
        Job: Record 167;
        ControlContratos: Record 7206912;
        Importe: Decimal;
        AddContractImport: Page 7207567;
        Text001: TextConst ESP = 'El nuevo importe (%1) no puede ser menor que el importe disponible (%2)';
    BEGIN
        IF NOT ModuloActivo THEN
            EXIT;

        IF (Job.GET(ComparativeQuoteHeader."Job No.")) THEN BEGIN
            IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN BEGIN
                ComparativeQuoteHeader.CALCFIELDS("Contrac Amount Max", "Contrac Amount in extensions", "Contrac Amount in fac", "Contrac Amount available");
                CLEAR(AddContractImport);
                AddContractImport.LOOKUPMODE := TRUE;
                AddContractImport.SetData(ComparativeQuoteHeader."Contrac Amount Max" + ComparativeQuoteHeader."Contrac Amount in extensions", ComparativeQuoteHeader."Contrac Amount in fac");
                IF AddContractImport.RUNMODAL = ACTION::LookupOK THEN
                    Importe := AddContractImport.GetData();

                IF (ComparativeQuoteHeader."Contrac Amount Max" + ComparativeQuoteHeader."Contrac Amount in extensions" + Importe < ComparativeQuoteHeader."Contrac Amount available") THEN
                    ERROR(Text001, ComparativeQuoteHeader."Contrac Amount Max" + ComparativeQuoteHeader."Contrac Amount in extensions" + Importe, ComparativeQuoteHeader."Contrac Amount available");

                ControlContratos.INIT;
                ControlContratos.Linea := 0;
                ControlContratos.Proyecto := ComparativeQuoteHeader."Job No.";
                ControlContratos.Contrato := ComparativeQuoteHeader."Generated Contract Doc No.";
                ControlContratos.Fecha := TODAY;
                ControlContratos."Tipo Documento" := ControlContratos."Tipo Documento"::ARcontrato;
                ControlContratos.Proveedor := ComparativeQuoteHeader."Selected Vendor";
                ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::Movimiento;
                ControlContratos."Importe Contrato" := Importe;
                ControlContratos.INSERT(TRUE);
            END;
        END;
    END;



    /*BEGIN
/*{
      AML 27/10/23 Modificaciones control de contratos
    }
END.*/
}










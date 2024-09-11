Codeunit 7206922 "QB Funciones Pagares"
{


    Permissions = TableData 25 = rim,
                TableData 272 = rim,
                TableData 380 = rim;
    trigger OnRun()
    BEGIN
    END;

    VAR
        TipoLinea: Option "Efecto","Factura","NuevoEfecto","LiquidarEfecto";

    PROCEDURE RegistrarRelacion(VAR Cabecera: Record 7206922);
    VAR
        GenJnlLine: Record 81;
        Text000: TextConst ESP = 'Nada que registrar';
        BankAccount: Record 270;
        Text001: TextConst ESP = 'No ha seleccionado el tipo de la relaci�n';
        Text002: TextConst ESP = 'No ha generado pagar�s para todas las l�neas';
        Text003: TextConst ESP = 'No ha generado el fichero N67 para todas las l�neas.';
        Text004: TextConst ESP = 'No ha agrupado todas las l�neas.';
        Text005: TextConst ESP = 'No existe el banco indicado en la relaci�n';
        Lineas: Record 7206923;
        DocPost: Codeunit 7000006;
    BEGIN
        //Registrar una relaci�n de pagos, de tipo pagar�s o relaci�n de pago

        //Verifica la cabecera y que todas las l�neas tengan los datos necesarios
        Cabecera.VerificarErrores();

        //Debe tener un banco
        IF (NOT BankAccount.GET(Cabecera."Bank Account No.")) THEN
            ERROR(Text005);

        //Eliminamos las l�neas que no se procesan
        //JAV 18/11/20: - QB 1.07.05 No eliminar si no es una orden de pago
        IF (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago) THEN BEGIN
            Lineas.RESET;
            Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
            Lineas.SETRANGE("Include in Payment Order", FALSE);
            Lineas.DELETEALL;
        END;

        //Verificar que existen l�neas, que tienen n�mero de pagar� y que han sido exportadas con N67 si es obligatorio
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        IF (NOT Lineas.FINDSET(FALSE)) THEN
            ERROR(Text000)
        ELSE
            REPEAT
                CASE Cabecera."Bank Payment Type" OF
                    Cabecera."Bank Payment Type"::" ":
                        BEGIN
                            ERROR(Text001);
                        END;
                    Cabecera."Bank Payment Type"::"Computer Check":
                        BEGIN
                            IF (Lineas."No. Pagare" = '') THEN
                                ERROR(Text002);
                            IF (BankAccount."N67 Obligatoria") THEN
                                IF (Lineas."Tipo Linea" <> Lineas."Tipo Linea"::Abono) AND (NOT Lineas."Exported to Payment File") THEN
                                    ERROR(Text003);
                        END;
                    Cabecera."Bank Payment Type"::"Manual Check":
                        BEGIN
                            IF (Lineas."No. Pagare" = '') THEN
                                ERROR(Text002);
                        END;
                    Cabecera."Bank Payment Type"::OrdenPago:
                        BEGIN
                            IF (Lineas."Include in Payment Order") AND (Lineas."No. Agrupacion" = '') THEN
                                ERROR(Text004);
                        END;
                END;
            UNTIL Lineas.NEXT = 0;

        //verifico fechas de registro
        DocPost.CheckPostingDate(Cabecera."Posting Date");

        //Verifica que el diario est� vac�o
        VerificarDiario;

        //Generar el diario seg�n el tipo de relaci�n
        IF (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago) THEN
            GenerarRelacionEfectos(Cabecera, GenJnlLine)
        ELSE
            GenerarRelacionPagares(Cabecera, GenJnlLine);

        //Registrar el diario
        IF (GenJnlLine.COUNT <> 0) THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);

            Cabecera.Registrada := TRUE;
            Cabecera.MODIFY(TRUE);
        END;

        COMMIT;   //Guardo todo para que al crear la relaci�n est� disponible

        //Generar la orden de pago si es de este tipo
        IF (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago) THEN
            CrearOrdenPago(Cabecera."Relacion No.");
    END;

    PROCEDURE GenerarRelacionPagares(VAR Cabecera: Record 7206922; VAR GenJnlLine: Record 81);
    VAR
        Lineas: Record 7206923;
        Text001: TextConst ESP = 'Nada que registrar';
        BankAccount: Record 270;
        LineaFactura: Record 7206923;
        VendorLedgerEntryAbono: Record 25;
        VendorLedgerEntryFactura: Record 25;
        DocPost: Codeunit 7000006;
        NroLinea: Integer;
        Importe: Decimal;
        Text002: TextConst ESP = 'No ha generado pagar�s para todas las l�neas';
        Text003: TextConst ESP = 'No ha generado el fichero N67 para todas las l�neas.';
    BEGIN
        //Generar el diario para una relaci�n de pagar�s autom�ticos o manuales

        //Primero Aplicamos abonos a facturas
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETRANGE("Tipo Linea", Lineas."Tipo Linea"::Abono);
        IF Lineas.FINDSET THEN
            REPEAT
                //Busco la factura que liquida
                LineaFactura.RESET;
                LineaFactura.SETRANGE("Relacion No.", Cabecera."Relacion No.");
                LineaFactura.SETRANGE("Document No.", Lineas."Liquida Documento");
                LineaFactura.FINDFIRST;

                //Busco movimientos y liquido
                VendorLedgerEntryAbono.GET(Lineas."No. Mov. Proveedor");
                VendorLedgerEntryFactura.GET(LineaFactura."No. Mov. Proveedor");
                LiquidarDocumentos(VendorLedgerEntryAbono, VendorLedgerEntryFactura);
            UNTIL Lineas.NEXT = 0;

        NroLinea := 0;
        CLEAR(GenJnlLine);
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETFILTER("Tipo Linea", '<>%1', Lineas."Tipo Linea"::Abono);
        IF Lineas.FINDSET THEN
            REPEAT
                CASE Lineas."Tipo Linea" OF
                    Lineas."Tipo Linea"::Factura:
                        BEGIN
                            Importe := Lineas."Importe Pendiente";
                            //L�nea que cancela la factura
                            NroLinea += 10000;
                            CrearLineaDiario(TipoLinea::Factura, Lineas, Importe, GenJnlLine, NroLinea);
                            //L�nea que crea el efecto relacionado
                            NroLinea += 10000;
                            CrearLineaDiario(TipoLinea::Efecto, Lineas, Importe, GenJnlLine, NroLinea);
                        END;
                    Lineas."Tipo Linea"::Anticipado:
                        BEGIN
                            Importe := Lineas.Amount;
                            //L�nea que crea el pago anticipado y su contrapartida
                            NroLinea += 10000;
                            CrearLineaDiarioAnticipo(Lineas, Importe, GenJnlLine, NroLinea);
                        END;
                    Lineas."Tipo Linea"::Cambio:
                        BEGIN
                            //Registro un diario con una L�nea que cancela el pagar� original y otra que crea el nuevo efecto
                            NroLinea += 10000;
                            AddLineaCambioVto(FALSE, Lineas, GenJnlLine, NroLinea);
                            NroLinea += 10000;
                            AddLineaCambioVto(TRUE, Lineas, GenJnlLine, NroLinea);
                        END;
                END;
            UNTIL Lineas.NEXT = 0;
    END;

    PROCEDURE GenerarRelacionEfectos(VAR Cabecera: Record 7206922; VAR GenJnlLine: Record 81);
    VAR
        Lineas: Record 7206923;
        Lineas2: Record 7206923;
        Text001: TextConst ESP = 'Nada que registrar';
        DocPost: Codeunit 7000006;
        NroLinea: Integer;
        Importe: Decimal;
        Text002: TextConst ESP = 'No ha generado pagar�s para todas las l�neas';
        Text003: TextConst ESP = 'No ha generado el fichero N67 para todas las l�neas.';
        AntAgrupacion: Code[20];
    BEGIN
        //Generar el diario para crear los efectos necesarios para generar una orden de pago

        NroLinea := 0;
        Importe := 0;
        AntAgrupacion := '';
        CLEAR(GenJnlLine);

        Lineas.RESET;
        Lineas.SETCURRENTKEY("Relacion No.", "No. Agrupacion");
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETRANGE("Include in Payment Order", TRUE);
        IF Lineas.FINDSET(FALSE) THEN
            REPEAT
                //Si cambia el c�digo de la agrupaci�n, insertamos la l�nea que crea el nuevo efecto
                IF (AntAgrupacion <> Lineas."No. Agrupacion") THEN BEGIN
                    Lineas2.RESET;
                    Lineas2.SETCURRENTKEY("Relacion No.", "No. Agrupacion");
                    Lineas2.SETRANGE("Relacion No.", Lineas."Relacion No.");
                    Lineas2.SETRANGE("No. Agrupacion", Lineas."No. Agrupacion");
                    Lineas2.CALCSUMS("Importe Pendiente");
                    Importe := Lineas2."Importe Pendiente";

                    GenerarRelacionEfectos_Efecto(Lineas, Importe, GenJnlLine, NroLinea);
                    AntAgrupacion := Lineas."No. Agrupacion";
                END;

                //L�nea que cancela la factura
                NroLinea += 10000;
                CrearLineaDiario(TipoLinea::LiquidarEfecto, Lineas, Lineas."Importe Pendiente", GenJnlLine, NroLinea);
                Importe += Lineas."Importe Pendiente";

            UNTIL Lineas.NEXT = 0;
    END;

    PROCEDURE GenerarRelacionEfectos_Efecto(Lineas: Record 7206923; Importe: Decimal; VAR GenJnlLine: Record 81; VAR NroLinea: Integer);
    VAR
        Text001: TextConst ESP = 'Nada que registrar';
        Text002: TextConst ESP = 'No ha generado pagar�s para todas las l�neas';
        Text003: TextConst ESP = 'No ha generado el fichero N67 para todas las l�neas.';
    BEGIN
        //L�nea que crea el nuevo efecto
        Lineas."Document No." := Lineas."No. Agrupacion";
        NroLinea += 10000;
        CrearLineaDiario(TipoLinea::NuevoEfecto, Lineas, Importe, GenJnlLine, NroLinea);
    END;

    PROCEDURE LiquidarDocumentos(VendorLedgerEntryOrigen: Record 25; VendorLedgerEntryDestino: Record 25);
    VAR
        Text000: TextConst ESP = 'Confirme que desea generar los efectos de la presente relaci�n';
        Text001: TextConst ESP = 'Nada que registrar';
        Text002: TextConst ESP = 'Diario descuadrado, no es posible registrar';
        Text003: TextConst ESP = 'No tiene n�mero de pagar� en todos los registros';
        Text004: TextConst ESP = 'No ha generado el fichero electr�nico';
        Text005: TextConst ESP = 'El diario %1 secci�n %2 tiene l�neas, eliminelas antes de procesar';
        Text006: TextConst ESP = 'No ha seleccionado tipo de pago';
        QBRelationshipSetup: Record 7207335;
        DetailedVendorLedgEntry: Record 380;
        NroMov: Integer;
        Importe: Decimal;
        ImporteLCY: Decimal;
    BEGIN
        QBRelationshipSetup.GET();

        //Busco importes
        VendorLedgerEntryOrigen.CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
        Importe := VendorLedgerEntryOrigen."Remaining Amount";
        ImporteLCY := VendorLedgerEntryOrigen."Remaining Amt. (LCY)";

        //Busco nro del registro
        DetailedVendorLedgEntry.RESET;
        IF DetailedVendorLedgEntry.FINDLAST THEN
            NroMov := DetailedVendorLedgEntry."Entry No."
        ELSE
            NroMov := 0;

        //Datos comunes
        DetailedVendorLedgEntry.INIT;
        DetailedVendorLedgEntry."Entry Type" := DetailedVendorLedgEntry."Entry Type"::Application;
        DetailedVendorLedgEntry."Posting Date" := VendorLedgerEntryOrigen."Posting Date";
        DetailedVendorLedgEntry."Document Type" := VendorLedgerEntryOrigen."Document Type";
        DetailedVendorLedgEntry."Document No." := VendorLedgerEntryOrigen."Document No.";
        DetailedVendorLedgEntry."Vendor No." := VendorLedgerEntryOrigen."Vendor No.";
        DetailedVendorLedgEntry."Currency Code" := VendorLedgerEntryOrigen."Currency Code";
        DetailedVendorLedgEntry."User ID" := USERID;
        DetailedVendorLedgEntry."Source Code" := QBRelationshipSetup."RP Codigo Origen";
        DetailedVendorLedgEntry."Applied Vend. Ledger Entry No." := VendorLedgerEntryOrigen."Entry No.";

        //Linea del documento al que se aplica
        DetailedVendorLedgEntry."Entry No." := NroMov + 1;
        DetailedVendorLedgEntry."Vendor Ledger Entry No." := VendorLedgerEntryDestino."Entry No.";
        SetImportes(DetailedVendorLedgEntry, Importe, ImporteLCY);
        DetailedVendorLedgEntry."Initial Entry Due Date" := VendorLedgerEntryDestino."Due Date";
        DetailedVendorLedgEntry."Initial Entry Global Dim. 1" := VendorLedgerEntryDestino."Global Dimension 1 Code";
        DetailedVendorLedgEntry."Initial Entry Global Dim. 2" := VendorLedgerEntryDestino."Global Dimension 2 Code";
        DetailedVendorLedgEntry."Initial Document Type" := VendorLedgerEntryDestino."Document Type";
        DetailedVendorLedgEntry."Application No." := VendorLedgerEntryOrigen."Entry No.";
        DetailedVendorLedgEntry.INSERT;

        VendorLedgerEntryDestino.CALCFIELDS("Remaining Amount");
        IF VendorLedgerEntryDestino."Remaining Amount" = 0 THEN BEGIN
            VendorLedgerEntryDestino.Open := FALSE;
            VendorLedgerEntryDestino.MODIFY;
        END;

        //Linea del documento de origen
        DetailedVendorLedgEntry."Entry No." := NroMov + 2;
        DetailedVendorLedgEntry."Vendor Ledger Entry No." := VendorLedgerEntryOrigen."Entry No.";
        SetImportes(DetailedVendorLedgEntry, -Importe, -ImporteLCY);
        DetailedVendorLedgEntry."Initial Entry Due Date" := VendorLedgerEntryOrigen."Due Date";
        DetailedVendorLedgEntry."Initial Entry Global Dim. 1" := VendorLedgerEntryOrigen."Global Dimension 1 Code";
        DetailedVendorLedgEntry."Initial Entry Global Dim. 2" := VendorLedgerEntryOrigen."Global Dimension 2 Code";
        DetailedVendorLedgEntry."Initial Document Type" := VendorLedgerEntryOrigen."Document Type";
        DetailedVendorLedgEntry."Application No." := VendorLedgerEntryDestino."Entry No.";
        DetailedVendorLedgEntry.INSERT;

        VendorLedgerEntryOrigen.CALCFIELDS("Remaining Amount");
        IF VendorLedgerEntryOrigen."Remaining Amount" = 0 THEN BEGIN
            VendorLedgerEntryOrigen.Open := FALSE;
            VendorLedgerEntryOrigen.MODIFY;
        END;
    END;

    PROCEDURE SetImportes(VAR DetailedVendorLedgEntry: Record 380; importe: Decimal; importeLCY: Decimal);
    BEGIN
        DetailedVendorLedgEntry.Amount := importe;
        DetailedVendorLedgEntry."Amount (LCY)" := importeLCY;
        IF (importe > 0) THEN BEGIN
            DetailedVendorLedgEntry."Debit Amount" := DetailedVendorLedgEntry.Amount;
            DetailedVendorLedgEntry."Credit Amount" := 0;
            DetailedVendorLedgEntry."Debit Amount (LCY)" := DetailedVendorLedgEntry."Amount (LCY)";
            DetailedVendorLedgEntry."Credit Amount (LCY)" := 0;
        END ELSE BEGIN
            DetailedVendorLedgEntry."Debit Amount" := 0;
            DetailedVendorLedgEntry."Credit Amount" := -DetailedVendorLedgEntry.Amount;
            DetailedVendorLedgEntry."Debit Amount (LCY)" := 0;
            DetailedVendorLedgEntry."Credit Amount (LCY)" := -DetailedVendorLedgEntry."Amount (LCY)";
        END;
    END;

    PROCEDURE CrearLineaDiario(parTipo: Option; Linea: Record 7206923; Importe: Decimal; VAR GenJnlLine: Record 81; NroLinea: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        VendorLedgerEntry: Record 25;
        GenJnlLine2: Record 81;
        Cabecera: Record 7206922;
    BEGIN
        QBRelationshipSetup.GET();
        Linea.SetDescription;
        Cabecera.GET(Linea."Relacion No.");

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);
        GenJnlLine.VALIDATE("Posting Date", Linea."Posting Date");

        //La l�nea ser� de cuenta de proveedor
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Linea."Vendor No.");

        //Tipo de documento
        CASE parTipo OF
            TipoLinea::Efecto, TipoLinea::NuevoEfecto:
                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Bill);
            TipoLinea::Factura, TipoLinea::LiquidarEfecto:
                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        END;

        //Nro de documento
        GenJnlLine.VALIDATE("Document No.", Linea."Document No.");

        //Nro de efecto
        IF (parTipo IN [TipoLinea::Efecto, TipoLinea::NuevoEfecto]) THEN BEGIN
            IF (Linea."No. Pagare" = '') THEN
                GenJnlLine.VALIDATE("Bill No.", Linea."Bill No.")
            ELSE
                GenJnlLine.VALIDATE("Bill No.", Linea."No. Pagare");

            IF GenJnlLine."Bill No." = '' THEN
                GenJnlLine.VALIDATE("Bill No.", '1');
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Bill No.", '');
        END;

        //Descripci�n
        IF (parTipo IN [TipoLinea::Efecto, TipoLinea::NuevoEfecto]) THEN
            GenJnlLine.VALIDATE(Description, Linea.Description2)
        ELSE
            GenJnlLine.VALIDATE(Description, Linea.Description1);

        GenJnlLine.VALIDATE("Document Date", Linea."Document Date");
        GenJnlLine.VALIDATE("Recipient Bank Account", Linea."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Reason Code", CrearCodigoAuditoria(Cabecera."Bank Account No."));        //C�digo de auditor�a es el banco
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", Linea."Currency Code");

        //JAV 26/10/20: - El n�mero de documento externo ser� el de la acrupaci�n si es relaci�n, en caso contrario ser� el de la l�nea
        IF (parTipo = TipoLinea::NuevoEfecto) THEN
            GenJnlLine.VALIDATE("External Document No.", Linea."No. Agrupacion")
        ELSE
            GenJnlLine.VALIDATE("External Document No.", Linea."External Document No.");

        //Importe
        IF (parTipo IN [TipoLinea::Efecto, TipoLinea::NuevoEfecto]) THEN
            GenJnlLine.VALIDATE(Amount, -Importe)
        ELSE
            GenJnlLine.VALIDATE(Amount, Importe);

        //Forma y t�rminos de pago
        GenJnlLine.VALIDATE("Payment Terms Code", Linea."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", Linea."Payment Method Code");
        IF (parTipo IN [TipoLinea::Factura, TipoLinea::LiquidarEfecto]) THEN BEGIN
            IF (VendorLedgerEntry.GET(Linea."No. Mov. Proveedor")) THEN BEGIN
                GenJnlLine.VALIDATE("Payment Terms Code", VendorLedgerEntry."Payment Terms Code");
                GenJnlLine.VALIDATE("Payment Method Code", VendorLedgerEntry."Payment Method Code");
            END;
        END;

        //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
        GenJnlLine."Due Date" := Linea."Due Date";

        //Dimensiones
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Linea."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Linea."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Dimension Set ID", Linea."Dimension Set ID");

        //GenJnlLine.VALIDATE("Job No.", Linea."Job No.");

        //Si se liquida algo con esta l�nea
        IF (parTipo IN [TipoLinea::Factura, TipoLinea::LiquidarEfecto]) THEN BEGIN
            //Seg�n sea efecto, abono o pago anticipado
            CASE Linea."Tipo Linea" OF
                Linea."Tipo Linea"::Factura:
                    BEGIN
                        GenJnlLine.VALIDATE("Applies-to Doc. Type", Linea."Document Type");
                        GenJnlLine.VALIDATE("Applies-to Doc. No.", Linea."Document No.");
                        IF (parTipo = TipoLinea::LiquidarEfecto) THEN
                            GenJnlLine.VALIDATE("Applies-to Bill No.", Linea."Bill No.");
                    END;
                Linea."Tipo Linea"::Anticipado:
                    BEGIN
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Bal. Account No.", QBRelationshipSetup."RP Cuenta para Pago anticipado");
                        GenJnlLine.VALIDATE("Bank Payment Type", Cabecera."Bank Payment Type");
                        GenJnlLine.VALIDATE("Check Printed", Linea.Printed);
                        GenJnlLine.VALIDATE("Exported to Payment File", Linea."Exported to Payment File");
                    END;
            END;
        END;

        GenJnlLine.INSERT(TRUE);
    END;

    PROCEDURE CrearLineaDiarioAnticipo(Linea: Record 7206923; Importe: Decimal; VAR GenJnlLine: Record 81; NroLinea: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        VendorLedgerEntry: Record 25;
        GenJnlLine2: Record 81;
        Cabecera: Record 7206922;
    BEGIN
        QBRelationshipSetup.GET();
        Linea.SetDescription;
        Cabecera.GET(Linea."Relacion No.");

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);
        GenJnlLine.VALIDATE("Posting Date", Linea."Posting Date");

        //La l�nea ser� de vendedor y la contrapatrida la cuenta de anticipos
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", QBRelationshipSetup."RP Cuenta para Pago anticipado");


        //Tipo de documento
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Bill);

        //Nro de documento
        GenJnlLine.VALIDATE("Document No.", Linea."Document No.");

        //Nro de efecto
        IF (Linea."No. Pagare" = '') THEN
            GenJnlLine.VALIDATE("Bill No.", Linea."Bill No.")
        ELSE
            GenJnlLine.VALIDATE("Bill No.", Linea."No. Pagare");

        IF GenJnlLine."Bill No." = '' THEN
            GenJnlLine.VALIDATE("Bill No.", '1');

        //Descripci�n
        GenJnlLine.VALIDATE(Description, Linea.Description1);

        GenJnlLine.VALIDATE("Document Date", Linea."Document Date");
        GenJnlLine.VALIDATE("External Document No.", Linea."External Document No.");
        GenJnlLine.VALIDATE("Recipient Bank Account", Linea."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Reason Code", CrearCodigoAuditoria(Cabecera."Bank Account No."));        //C�digo de auditor�a es el banco
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", Linea."Currency Code");
        //GenJnlLine."Job No." := Linea."Job No.";

        //Importe
        GenJnlLine.VALIDATE(Amount, -Importe);

        //Forma y t�rminos de pago
        GenJnlLine.VALIDATE("Payment Terms Code", Linea."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", Linea."Payment Method Code");
        IF (VendorLedgerEntry.GET(Linea."No. Mov. Proveedor")) THEN BEGIN
            GenJnlLine.VALIDATE("Payment Terms Code", VendorLedgerEntry."Payment Terms Code");
            GenJnlLine.VALIDATE("Payment Method Code", VendorLedgerEntry."Payment Method Code");
        END;

        //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
        GenJnlLine."Due Date" := Linea."Due Date";

        //Dimensiones
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Linea."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Linea."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Dimension Set ID", Linea."Dimension Set ID");

        //GenJnlLine.VALIDATE("Bank Payment Type", Linea."Bank Payment Type");
        //GenJnlLine.VALIDATE("Check Printed", Linea.Printed);
        //GenJnlLine.VALIDATE("Exported to Payment File", Linea."Exported to Payment File");

        GenJnlLine.INSERT(TRUE);
    END;

    PROCEDURE DividirLinea(parRelacion: Integer; parLinea: Integer);
    VAR
        Cabecera: Record 7206922;
        Lineas1: Record 7206923;
        Lineas2: Record 7206923;
        nroLinea: Integer;
        nroEfecto: Text;
        importe: Decimal;
        Text000: TextConst ESP = 'Confirme que desea generar los efectos de la presente relaci�n';
        Text001: TextConst ESP = 'Nada que registrar';
        Text002: TextConst ESP = 'Diario descuadrado, no es posible registrar';
        Text003: TextConst ESP = 'No tiene n�mero de pagar� en todos los registros';
        Text004: TextConst ESP = 'No ha generado el fichero electr�nico';
        Text005: TextConst ESP = 'El diario %1 secci�n %2 tiene l�neas, eliminelas antes de procesar';
        Text006: TextConst ESP = 'No ha seleccionado tipo de pago';
    BEGIN
        //Divide una l�nea de la relaci�n en dos partes iguales
        Lineas1.GET(parRelacion, parLinea);

        Lineas2.RESET;
        Lineas2.SETRANGE("Relacion No.", parRelacion);
        Lineas2.SETFILTER("Line No.", '>%1', parLinea);
        IF (Lineas2.FINDFIRST) THEN
            nroLinea := ROUND((Lineas2."Line No." + parLinea) / 2, 1)
        ELSE
            nroLinea := parLinea + 10000;

        nroEfecto := '';
        Lineas2.RESET;
        Lineas2.SETRANGE("Relacion No.", parRelacion);
        Lineas2.SETRANGE("Document Type", Lineas1."Document Type");
        Lineas2.SETRANGE("Document No.", Lineas1."Document No.");
        IF (Lineas2.FINDSET) THEN
            REPEAT
                IF (Lineas2."Bill No." > nroEfecto) THEN
                    nroEfecto := Lineas2."Bill No.";
            UNTIL Lineas2.NEXT = 0;
        IF (nroEfecto = '') THEN
            nroEfecto := '2'
        ELSE
            nroEfecto := INCSTR(nroEfecto);

        Lineas2.GET(parRelacion, parLinea);
        importe := Lineas1.Amount;

        Lineas1.Amount := ROUND(importe / 2, 0.01);
        IF (Lineas1."Bill No." = '') THEN
            Lineas1."Bill No." := '1';
        Lineas1.SetDescription;
        Lineas1.MODIFY;

        Lineas2."Line No." := nroLinea;
        Lineas2.Amount -= Lineas1.Amount;
        Lineas2."Bill No." := nroEfecto;
        Lineas2.SetDescription;
        Lineas2.INSERT;
    END;

    PROCEDURE CrearOrdenPago(parRelacion: Integer);
    VAR
        Cabecera: Record 7206922;
        Lineas: Record 7206923;
        PaymentOrder: Record 7000020;
        CarteraDoc: Record 7000002;
        pgPaymentOrder: Page 7000050;
        NextLineNo: Integer;
        Text001: TextConst ESP = 'Relaci�n no registrada';
    BEGIN
        Cabecera.GET(parRelacion);
        IF (NOT Cabecera.Registrada) THEN
            ERROR(Text001);

        //Creo la Orden de Pago
        IF (Cabecera.OrdenPago <> '') THEN
            PaymentOrder.GET(Cabecera.OrdenPago)
        ELSE BEGIN
            PaymentOrder.INIT;
            PaymentOrder."No." := '';
            PaymentOrder.INSERT(TRUE);
        END;
        PaymentOrder.VALIDATE("Posting Date", Cabecera."Posting Date");
        PaymentOrder.VALIDATE("Bank Account No.", Cabecera."Bank Account No.");
        PaymentOrder.VALIDATE("Reason Code", CrearCodigoAuditoria(Cabecera."Bank Account No."));        //C�digo de auditor�a es el banco
        PaymentOrder.MODIFY(TRUE);

        //A�ado los documentos a la orden de pago
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        IF Lineas.FINDSET THEN
            REPEAT
                CarteraDoc.RESET;
                CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
                CarteraDoc.SETRANGE("Document Type", CarteraDoc."Document Type"::Bill);
                IF (Lineas."Include in Payment Order") AND (Lineas."No. Agrupacion" <> '') THEN
                    CarteraDoc.SETRANGE("Document No.", Lineas."No. Agrupacion")
                ELSE IF (Lineas."No. Pagare" <> '') THEN
                    CarteraDoc.SETRANGE("Document No.", Lineas."No. Pagare")
                ELSE
                    CarteraDoc.SETRANGE("Document No.", Lineas."Document No.");

                IF (CarteraDoc.FINDFIRST) THEN BEGIN
                    CarteraDoc."Bill Gr./Pmt. Order No." := PaymentOrder."No.";
                    CarteraDoc."Collection Agent" := CarteraDoc."Collection Agent"::Bank;
                    CarteraDoc.MODIFY;
                END;
            UNTIL Lineas.NEXT = 0;

        Cabecera.OrdenPago := PaymentOrder."No.";
        Cabecera.MODIFY;

        COMMIT; //Para el runmodal

        CLEAR(pgPaymentOrder);
        pgPaymentOrder.SETRECORD(PaymentOrder);
        pgPaymentOrder.RUNMODAL;
    END;

    PROCEDURE AgruparEfectos(parRelacion: Integer; pAgrupar: Boolean);
    VAR
        Lineas: Record 7206923;
        Lineas2: Record 7206923;
        Text001: TextConst ESP = 'Relaci�n no registrada';
        Nro: Integer;
    BEGIN
        //Calcular el nro de agrupaci�n de las l�neas de una relaci�n de pagos

        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", parRelacion);
        Lineas.MODIFYALL("No. Agrupacion", '');

        Nro := 0;
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", parRelacion);
        Lineas.SETRANGE("Include in Payment Order", TRUE);
        IF Lineas.FINDSET(TRUE) THEN
            REPEAT
                IF (Lineas."No. Agrupacion" = '') THEN BEGIN
                    Nro += 1;
                    Lineas2.RESET;
                    Lineas2.SETRANGE("Relacion No.", parRelacion);
                    Lineas2.SETRANGE("Include in Payment Order", TRUE);
                    Lineas2.SETFILTER("No. Agrupacion", '=%1', '');
                    IF (pAgrupar) THEN BEGIN
                        Lineas2.SETRANGE("Vendor No.", Lineas."Vendor No.");
                        Lineas2.SETRANGE("Due Date", Lineas."Due Date");
                    END ELSE BEGIN
                        Lineas2.SETRANGE("Line No.", Lineas."Line No.");
                    END;
                    Lineas2.MODIFYALL("No. Agrupacion", 'RP' + AdjustToNumer(parRelacion, 5) + '-' + AdjustToNumer(Nro, 2), TRUE);
                END;
            UNTIL Lineas.NEXT = 0;
    END;

    PROCEDURE CrearPagares(Cabecera: Record 7206922);
    VAR
        BankAccount: Record 270;
        Lineas: Record 7206923;
        Lineas2: Record 7206923;
        CheckLedgEntry: Record 272;
        CheckManagement: Codeunit 367;
        opcChequeAdicional: Text;
        opcDigitoControlCheque: Integer;
        opcControlAdicional: Integer;
        opcSerie: Text;
        DcontrolChequeTXT: Text;
        varDividendo: Integer;
        varNoModPagare: Text;
        decNumCheque: Decimal;
        decEntero1: Decimal;
        decEntero2: Decimal;
        decEntero3: Integer;
        varNroPagareImpresion: Text;
        AntVendor: Code[20];
        AntFecha: Date;
        Text001: TextConst ESP = 'No ha definido n�mero de cheque/pagar� en el banco %1';
        Text002: TextConst ESP = 'El n� de serie del cheque/pagar� debe estar compuesto solo por numeros';
        Text003: TextConst ESP = 'Ha sobrepasado el n�mero m�ximo de cheques/pagar�s a imprimir\N�mero %1\M�ximo configurado para el banco %2';
        Text004: TextConst ESP = 'Los digitos de control del banco para la Norma 67 debe ser 4';
        Text005: TextConst ESP = 'El C�digo de Identificaci�n debe estar compuesto solo por numeros';
        Text010: TextConst ESP = 'El documento %1 no tiene fecha de vencimiento establecida.';
        Text011: TextConst ESP = 'El documento %1 tiene fecha de vencimiento inferior a la original.';
        Cabecera2: Record 7206922;
        I_Nro: Code[20];
        I_Rep: Integer;
        I_Max: Text;
    BEGIN
        //Ver si hay n�mero de formato
        IF (Cabecera.Report = 0) THEN
            ERROR('Debe seleccionar un formato de impresi�n');

        //Busco banco y sus datos
        BankAccount.GET(Cabecera."Bank Account No.");
        BankAccount.TESTFIELD(Blocked, FALSE);

        IF (Cabecera.Report = BankAccount."Rep4 Check Report ID") THEN BEGIN
            I_Rep := 4;
            I_Nro := BankAccount."Rep4 Last Check No.";
            I_Max := BankAccount."Rep4 Maximo  No. Cheque";
        END ELSE IF (Cabecera.Report = BankAccount."Rep3 Check Report ID") THEN BEGIN
            I_Rep := 3;
            I_Nro := BankAccount."Rep3 Last Check No.";
            I_Max := BankAccount."Rep3 Maximo  No. Cheque";
        END ELSE IF (Cabecera.Report = BankAccount."Rep2 Check Report ID") THEN BEGIN
            I_Rep := 2;
            I_Nro := BankAccount."Rep2 Last Check No.";
            I_Max := BankAccount."Rep2 Maximo  No. Cheque";
        END ELSE BEGIN
            I_Rep := 1;
            I_Nro := BankAccount."Last Check No.";
            I_Max := BankAccount."Maximo  No. Cheque";
        END;

        IF I_Nro = '' THEN
            ERROR(Text001, Cabecera."Bank Account No.");
        IF NOT EVALUATE(decEntero3, I_Nro) THEN
            ERROR(Text002);

        //Para pagar�s sin c�digo de barras impreso, hay que calcular estos datos
        IF (BankAccount."Pagare sin Barras") THEN BEGIN
            opcSerie := BankAccount."Serie banco";
            opcDigitoControlCheque := BankAccount."No. control cheque";
            opcChequeAdicional := BankAccount."No. cheque adicional";
            opcControlAdicional := BankAccount."No. control cheque adicional";

            //Calculo el d�gito de control del c�digo adicional
            BankAccount.TESTFIELD(BankAccount."Digitos banco N 67");
            IF (STRLEN(BankAccount."Digitos banco N 67") <> 4) THEN
                ERROR(Text004);

            opcChequeAdicional := BankAccount."Digitos banco N 67";

            IF NOT EVALUATE(varDividendo, opcChequeAdicional) THEN
                ERROR(Text005);

            //Cargo el divisor de m�dulo 7 y cargo el DC del Cod. identificacion.
            opcControlAdicional := (varDividendo MOD 7);

            //Cargo el DC del n� de pagar�
            varNoModPagare := FORMAT(opcChequeAdicional) + FORMAT(varDividendo);

            EVALUATE(decNumCheque, opcChequeAdicional + '0000000');
            EVALUATE(decEntero3, I_Nro);
            decEntero1 := decEntero3;
            decEntero1 += decNumCheque;
            decEntero2 := decEntero1 DIV 7;
            decEntero1 := decEntero1 / 7;
            opcDigitoControlCheque := ROUND((decEntero1 - decEntero2) * 7, 1);

            IF STRLEN(FORMAT(opcDigitoControlCheque)) = 1 THEN
                DcontrolChequeTXT := FORMAT(opcDigitoControlCheque);
        END;

        //Numerar los pagar�s que no tienen todav�a n�mero
        AntVendor := '';
        AntFecha := 0D;

        Lineas.RESET;
        Lineas.SETCURRENTKEY("Relacion No.", "Vendor No.", "Payment Method Code");
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETFILTER("Tipo Linea", '<>%1', Lineas."Tipo Linea"::Abono);
        Lineas.SETFILTER("No. Pagare", '=%1', '');
        IF Lineas.FINDSET THEN
            REPEAT
                //JAV 30/06/22: - QB 1.10.57 No imprimir mientras no est� aprobado y tengan errores
                IF (Lineas.IsApproved(Lineas."Vendor No.", Lineas."Document No.")) AND (NOT Lineas.BuscarErrores(TRUE)) THEN BEGIN

                    IF (Lineas."Due Date" = 0D) THEN
                        ERROR(Text010, Lineas."Document No.");
                    //IF (Lineas."Tipo Linea" = Lineas."Tipo Linea"::Cambio) AND (Lineas."Due Date" < Lineas."Original Due Date") THEN
                    //  ERROR(Text011, Lineas."Document No.");

                    //Dar n�mero al pagar�
                    IF (NOT Cabecera.Agrupar) OR (AntVendor <> Lineas."Vendor No.") OR (AntFecha <> Lineas."Due Date") THEN BEGIN
                        I_Nro := INCSTR(I_Nro);
                        IF (I_Max <> '') AND (I_Nro > I_Max) THEN
                            ERROR(Text003, I_Nro, I_Max);

                        IF (BankAccount."Pagare sin Barras") THEN BEGIN
                            opcDigitoControlCheque += 1;
                            IF opcDigitoControlCheque > 6 THEN
                                opcDigitoControlCheque := 0;

                            varNroPagareImpresion := STRSUBSTNO('%1     %2     %3          %4        %5', opcSerie, I_Nro, opcDigitoControlCheque,
                                                                opcChequeAdicional, opcControlAdicional);
                        END;
                    END;
                    AntVendor := Lineas."Vendor No.";
                    AntFecha := Lineas."Due Date";

                    Lineas2.GET(Lineas."Relacion No.", Lineas."Line No.");
                    Lineas2."No. Pagare" := I_Nro;
                    IF (BankAccount."Pagare sin Barras") THEN BEGIN
                        Lineas2."Imp0 No. Serie" := opcSerie;
                        Lineas2.Imp1 := I_Nro;
                        Lineas2.Imp2 := opcDigitoControlCheque;
                        Lineas2."Imp3 No. Cheque Adicional" := opcChequeAdicional;
                        Lineas2.Imp4 := opcControlAdicional;
                    END;
                    Lineas2.MODIFY(TRUE);

                    //Movimiento de cheque
                    CheckLedgEntry.RESET;
                    CheckLedgEntry.SETRANGE("Bank Account No.", Cabecera."Bank Account No.");
                    CheckLedgEntry.SETRANGE("Check No.", I_Nro);
                    CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                    IF CheckLedgEntry.FINDFIRST THEN BEGIN
                        CheckLedgEntry.Amount += Lineas.Amount;
                        CheckLedgEntry.MODIFY;
                    END ELSE BEGIN
                        CheckLedgEntry.INIT;
                        CheckLedgEntry."Bank Account No." := Cabecera."Bank Account No.";
                        CheckLedgEntry."Check No." := I_Nro;
                        CheckLedgEntry."Check Date" := Lineas."Due Date";
                        CheckLedgEntry."Posting Date" := Lineas."Posting Date";
                        CheckLedgEntry."Document Type" := Enum::"Gen. Journal Document Type".FromInteger(Lineas."Document Type"); //option to enum
                        CheckLedgEntry."Document No." := Lineas."Document No.";
                        CheckLedgEntry.Description := Lineas.Description1;
                        CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Computer Check";
                        CheckLedgEntry."Bal. Account Type" := CheckLedgEntry."Bal. Account Type"::Vendor;
                        CheckLedgEntry."Bal. Account No." := Lineas."Vendor No.";
                        CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                        CheckLedgEntry.Amount := Lineas.Amount;
                        CheckLedgEntry."Payment Relation" := Lineas."Relacion No.";

                        CLEAR(CheckManagement);
                        CheckManagement.InsertCheck(CheckLedgEntry, Lineas.RECORDID);
                    END;
                END;
            UNTIL Lineas.NEXT = 0;

        CASE I_Rep OF
            1:
                BankAccount."Last Check No." := I_Nro;
            2:
                BankAccount."Rep2 Last Check No." := I_Nro;
            3:
                BankAccount."Rep3 Last Check No." := I_Nro;
            4:
                BankAccount."Rep4 Last Check No." := I_Nro;
        END;
        IF (BankAccount."Pagare sin Barras") THEN BEGIN
            BankAccount."No. control cheque" := opcDigitoControlCheque;
            BankAccount."No. cheque adicional" := opcChequeAdicional;
            BankAccount."No. control cheque adicional" := opcControlAdicional;
        END;
        BankAccount.MODIFY;

        //Revisar los abonos
        Lineas.RESET;
        Lineas.SETCURRENTKEY("Relacion No.", "Vendor No.", "Payment Method Code");
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETRANGE("Tipo Linea", Lineas."Tipo Linea"::Abono);
        Lineas.SETFILTER("No. Pagare", '=%1', '');
        IF Lineas.FINDSET THEN
            REPEAT
                Lineas2.RESET;
                Lineas2.SETRANGE("Relacion No.", Cabecera."Relacion No.");
                Lineas2.SETRANGE("Document No.", Lineas."Liquida Documento");
                IF (Lineas2.FINDFIRST) THEN BEGIN
                    Lineas.VALIDATE("No. Pagare", Lineas2."No. Pagare");
                    Lineas.MODIFY;

                    //Movimiento de cheque
                    Cabecera2.GET(Lineas2."Relacion No.");
                    CheckLedgEntry.RESET;
                    CheckLedgEntry.SETRANGE("Bank Account No.", Cabecera2."Bank Account No.");
                    CheckLedgEntry.SETRANGE("Check No.", Lineas2."No. Pagare");
                    CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                    IF CheckLedgEntry.FINDFIRST THEN BEGIN
                        CheckLedgEntry.Amount += Lineas.Amount;
                        CheckLedgEntry.MODIFY;
                    END;
                END;
            UNTIL Lineas.NEXT = 0;
    END;

    PROCEDURE ImprimirPagares(parRelacion: Record 7206922; parNumero: Code[20]);
    VAR
        QBReportSelections: Record 7206901;
        Lineas: Record 7206923;
    BEGIN
        //Ver si hay n�mero
        IF (parRelacion.Report = 0) THEN
            ERROR('Debe seleccionar un formato de impresi�n');

        //Crear los pagar�s que no tienen n�mero todav�a
        IF parNumero = '' THEN
            CrearPagares(parRelacion);

        COMMIT; //Para el run modal

        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", parRelacion."Relacion No.");
        IF (parNumero = '') THEN
            Lineas.SETRANGE(Printed, FALSE);

        IF (Lineas.COUNT = 0) THEN
            ERROR('Nada que imprimir, si ya ha impreso los pagar�s debe usar la opci�n de reimprimir en la zona de l�neas');

        //JAV 17/06/22: - QB 1.10.51 Nuevo par�metro en la funci�n de impresi�n
        QBReportSelections.PrintOneReport(parRelacion.Report, TRUE, Lineas);
        //QBReportSelections.Print(QBReportSelections.Usage::G2, Lineas);
    END;

    PROCEDURE ImprimirCarta(parRelacion: Record 7206922; parNumero: Code[20]);
    VAR
        // rpPagareA: Report 7207438;
        // rpPagareB: Report 7207439;
        QBRelationshipSetup: Record 7207335;
        QBReportSelections: Record 7206901;
        Lineas: Record 7206923;
    BEGIN
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", parRelacion."Relacion No.");
        IF (parNumero = '') THEN BEGIN
            Lineas.SETRANGE(Printed, TRUE);
            Lineas.SETRANGE(Carta, FALSE);
        END;
        IF (Lineas.COUNT = 0) THEN
            ERROR('Nada que imprimir, primero imprima los pagar�s, si ya los ha impreso y tambi�n la carta, debe usar la opci�n de reimprimir en la zona de l�neas');

        QBReportSelections.Print(QBReportSelections.Usage::G3, Lineas);
    END;

    PROCEDURE AnularPagare(Linea: Record 7206923);
    VAR
        Cabecera: Record 7206922;
        GenJnlLine: Record 81;
        Linea2: Record 7206923;
        CheckLedgEntry: Record 272;
        CheckManagement: Codeunit 367;
    BEGIN
        Cabecera.GET(Linea."Relacion No.");

        //Busco el Movimiento de cheque
        CheckLedgEntry.RESET;
        CheckLedgEntry.SETRANGE("Bank Account No.", Cabecera."Bank Account No.");
        CheckLedgEntry.SETRANGE("Check No.", Linea."No. Pagare");
        CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
        IF CheckLedgEntry.FINDFIRST THEN BEGIN

            GenJnlLine.INIT;
            GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
            GenJnlLine."Check Printed" := TRUE;
            GenJnlLine."Document No." := Linea."No. Pagare";
            GenJnlLine."Document Date" := Linea."Document Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := Linea."Vendor No.";
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
            GenJnlLine."Bal. Account No." := Cabecera."Bank Account No.";
            GenJnlLine.Amount := ABS(Linea.Amount);
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Currency Code" := Linea."Currency Code";
            GenJnlLine."Posting Date" := Linea."Posting Date";

            CheckManagement.VoidCheck(GenJnlLine);

            //Busco l�neas con el mismo n�mero de pagar�
            Linea2.RESET;
            Linea2.SETRANGE("Relacion No.", Linea."Relacion No.");
            Linea2.SETRANGE("No. Pagare", Linea."No. Pagare");
            IF (Linea2.FINDSET) THEN
                REPEAT
                    Linea2."No. Pagare" := '';
                    Linea2.Printed := FALSE;
                    Linea2.Carta := FALSE;
                    Linea2."Exported to Payment File" := FALSE;
                    Linea2.MODIFY(TRUE);
                UNTIL Linea2.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CrearCodigoAuditoria(parBanco: Text): Text;
    VAR
        BankAccount: Record 270;
        ReasonCode: Record 231;
    BEGIN
        //JAV 18/11/20: - QB 1.07.05 Limitar lognitud del c�digo
        BankAccount.GET(parBanco);

        ReasonCode.INIT;
        ReasonCode.Code := COPYSTR(parBanco, 1, MAXSTRLEN(ReasonCode.Code));
        ReasonCode.Description := COPYSTR(BankAccount.Name, 1, MAXSTRLEN(ReasonCode.Description));
        IF NOT ReasonCode.INSERT THEN;
        EXIT(ReasonCode.Code);
    END;

    PROCEDURE CambioVto(parVendorLedgerEntry: Record 25; parFechaRegistro: Date; parFechaVto: Date; parOldBanco: Code[20]; parNewBanco: Code[20]);
    VAR
        QBRelationshipSetup: Record 7207335;
        GenJnlLine: Record 81;
        Cabecera: Record 7206922;
        Linea: Record 7206923;
        BankAccount: Record 270;
        DocPost: Codeunit 7000006;
        // rpExportN67: Report 7207434;
        NroLinea: Integer;
        NroPagare: Code[20];
        Text001: TextConst ESP = 'Se ha creado el fichero N67 %1';
    BEGIN
        VerificarDiario;

        //Creo una relaci�n con el documento
        Cabecera.INIT;
        Cabecera."Posting Date" := parFechaRegistro;
        Cabecera."Bank Account No." := parNewBanco;
        Cabecera."Bank Payment Type" := Cabecera."Bank Payment Type"::"Computer Check";
        Cabecera.INSERT(TRUE);

        Linea.INIT;
        Linea."Relacion No." := Cabecera."Relacion No.";
        Linea."Line No." := 10000;
        Linea."Posting Date" := parFechaRegistro;
        Linea."Tipo Linea" := Linea."Tipo Linea"::Cambio;
        Linea.VALIDATE("No. Mov. Proveedor", parVendorLedgerEntry."Entry No.");
        Linea."Due Date" := parFechaVto;
        Linea.INSERT(TRUE);

        //Imprimo el pagar�
        ImprimirPagares(Cabecera, '');
        Linea.GET(Cabecera."Relacion No.", 10000);
        IF (NOT Linea.Printed) THEN BEGIN
            AnularPagare(Linea);
            Cabecera.DELETE(TRUE);
            COMMIT;
            ERROR('No ha impreso el pagar�, se cancela el proceso');
        END;

        //Crear el fichero N67 si es obligatorio
        BankAccount.GET(parNewBanco);
        IF (BankAccount."N67 Obligatoria") THEN BEGIN
            COMMIT;  //Por el runmodal
            // CLEAR(rpExportN67);
            // rpExportN67.SetFiltros(Cabecera."Relacion No.");
            // rpExportN67.USEREQUESTPAGE(FALSE);
            // rpExportN67.RUNMODAL;

            Cabecera.GET(Cabecera."Relacion No.");
            MESSAGE(Text001, Cabecera.Fichero);
        END;

        //Registrar
        RegistrarRelacion(Cabecera);
    END;

    LOCAL PROCEDURE AddLineaCambioVto(parNuevo: Boolean; Linea: Record 7206923; VAR GenJnlLine: Record 81; NroLinea: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        VendorLedgerEntry: Record 25;
        Cabecera: Record 7206922;
    BEGIN
        QBRelationshipSetup.GET();
        VendorLedgerEntry.GET(Linea."No. Mov. Proveedor");
        Cabecera.GET(Linea."Relacion No.");
        Linea.SetDescription;

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);
        GenJnlLine.VALIDATE("Posting Date", Linea."Posting Date");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", VendorLedgerEntry."Vendor No.");

        //Datos del documento seg�n si es la l�nea de su anulaci�n o la del nuevo vto
        IF (NOT parNuevo) THEN BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
            GenJnlLine.VALIDATE("Document No.", VendorLedgerEntry."Document No.");
            GenJnlLine.VALIDATE("Bill No.", VendorLedgerEntry."Bill No.");
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Bill);
            GenJnlLine.VALIDATE("Document No.", VendorLedgerEntry."Document No.");
            GenJnlLine.VALIDATE("Bill No.", Linea."No. Pagare");
        END;

        GenJnlLine.VALIDATE("Document Date", VendorLedgerEntry."Document Date");
        GenJnlLine.VALIDATE("External Document No.", VendorLedgerEntry."External Document No.");
        GenJnlLine.VALIDATE("Recipient Bank Account", VendorLedgerEntry."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", VendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", VendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", VendorLedgerEntry."Currency Code");
        GenJnlLine.VALIDATE("Payment Terms Code", Linea."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", Linea."Payment Method Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", VendorLedgerEntry."Global Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", VendorLedgerEntry."Global Dimension 2 Code");
        GenJnlLine.VALIDATE("Dimension Set ID", VendorLedgerEntry."Dimension Set ID");

        VendorLedgerEntry.CALCFIELDS("Remaining Amount");
        IF (NOT parNuevo) THEN BEGIN
            GenJnlLine.Description := Linea.Description1;
            GenJnlLine.VALIDATE(Amount, -VendorLedgerEntry."Remaining Amount");
            GenJnlLine."Due Date" := VendorLedgerEntry."Due Date";
            GenJnlLine.VALIDATE("Reason Code", VendorLedgerEntry."Reason Code");
            GenJnlLine.VALIDATE("Applies-to Doc. Type", VendorLedgerEntry."Document Type");
            GenJnlLine.VALIDATE("Applies-to Doc. No.", VendorLedgerEntry."Document No.");
        END ELSE BEGIN
            GenJnlLine.Description := Linea.Description2;
            GenJnlLine.VALIDATE(Amount, VendorLedgerEntry."Remaining Amount");
            GenJnlLine."Due Date" := Linea."Due Date";
            GenJnlLine.VALIDATE("Reason Code", CrearCodigoAuditoria(Cabecera."Bank Account No."));
        END;

        GenJnlLine.INSERT(TRUE);
    END;

    LOCAL PROCEDURE VerificarDiario();
    VAR
        QBRelationshipSetup: Record 7207335;
        Text005: TextConst ESP = 'El diario %1 secci�n %2 tiene l�neas, eliminelas antes de procesar';
        GenJnlLine: Record 81;
    BEGIN
        QBRelationshipSetup.GET();
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");

        GenJnlLine.DELETEALL;

        IF (GenJnlLine.COUNT <> 0) THEN
            ERROR(Text005, QBRelationshipSetup."RP Gen.Journal Template Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
    END;

    PROCEDURE LiquidarAnticipado(VAR Linea: Record 7206923; parLiquidar: Boolean);
    VAR
        Text000: TextConst ESP = 'Confirme que desea liquidar el efecto anticipado';
        Text001: TextConst ESP = 'Confirme que desea cancelar el efecto anticipado';
        GenJnlLine: Record 81;
        Text002: TextConst ESP = 'Debe indicar la factura contra la que liquida el anticipo.';
        VendorLedgerEntryAnticipo: Record 25;
        VendorLedgerEntryFactura: Record 25;
        Text003: TextConst ESP = 'No debe indicar la factura contra la que CANCELAR el anticipo.';
        QBCrearEfectosLinea: Record 7206923;
        QBLiquidarAnticipo: Page 7206942;
        Texto: Text;
        nro: Integer;
        importe: Decimal;
        ok: Boolean;
        FechaRegistro: Date;
    BEGIN
        IF (parLiquidar) THEN BEGIN
            IF (Linea."Anticipo Liquidar con" = '') THEN
                ERROR(Text002);
            Linea.VALIDATE("Anticipo Liquidar con");
            IF (Linea."Document No." = Linea."Anticipo Liquidar con") THEN
                ERROR('No puede liquidar el anticipo contra si mismo');
        END ELSE
            IF (Linea."Anticipo Liquidar con" <> '') THEN
                ERROR(Text003);

        //Calculo el pendiente
        Linea.CALCFIELDS("Anticipo Aplicado");
        Linea."Importe Pendiente" := Linea.Amount + Linea."Anticipo Aplicado";

        //Verifica que el diario est� vac�o
        VerificarDiario;

        //Pedir datos
        ok := FALSE;
        IF parLiquidar THEN BEGIN
            VendorLedgerEntryFactura.GET(Linea."No. Mov. a Liquidar");

            CLEAR(QBLiquidarAnticipo);
            QBLiquidarAnticipo.LOOKUPMODE(TRUE);
            QBLiquidarAnticipo.SetVLE(Linea, VendorLedgerEntryFactura);
            COMMIT;
            ok := (QBLiquidarAnticipo.RUNMODAL = ACTION::LookupOK);
            FechaRegistro := QBLiquidarAnticipo.GetDate;
        END ELSE BEGIN
            ok := CONFIRM(Text001, FALSE);
            FechaRegistro := WORKDATE;
        END;

        //Crear el diario y la liquidaci�n
        IF ok THEN BEGIN
            CLEAR(GenJnlLine);

            //Busco movimientos
            VendorLedgerEntryFactura.GET(Linea."No. Mov. a Liquidar");
            VendorLedgerEntryFactura.CALCFIELDS("Remaining Amount");
            importe := VendorLedgerEntryFactura."Remaining Amount";
            IF (ABS(importe) > ABS(Linea."Importe Pendiente")) THEN
                importe := -Linea."Importe Pendiente";

            //L�nea para liquidar el pago anticipado contrapartida proveedor
            RegistrarLineaLiquidacion(parLiquidar, TRUE, Linea, importe, GenJnlLine, 1);

            //L�nea que crea el movimiento del proveedor
            RegistrarLineaLiquidacion(parLiquidar, FALSE, Linea, importe, GenJnlLine, 2);

            //Registrar el diario
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);

            //Liquidar factura y anticipo

            //Busco movimientos
            VendorLedgerEntryAnticipo.RESET;
            VendorLedgerEntryAnticipo.SETRANGE("Document Type", VendorLedgerEntryAnticipo."Document Type"::Payment);
            VendorLedgerEntryAnticipo.SETRANGE("Document No.", Linea."Document No.");
            //VendorLedgerEntryAnticipo.SETRANGE("Bill No.", Linea."No. Pagare");
            VendorLedgerEntryAnticipo.SETRANGE(Open, TRUE);
            VendorLedgerEntryAnticipo.SETRANGE(Positive, TRUE);
            VendorLedgerEntryAnticipo.FINDLAST;

            VendorLedgerEntryFactura.GET(Linea."No. Mov. a Liquidar");

            LiquidarDocumentos(VendorLedgerEntryAnticipo, VendorLedgerEntryFactura);

            //Creo la l�nea de liquidaci�n o cancelacion
            QBCrearEfectosLinea.RESET;
            QBCrearEfectosLinea.SETRANGE("Relacion No.", Linea."Relacion No.");
            QBCrearEfectosLinea.FINDLAST;
            nro := QBCrearEfectosLinea."Line No." + 10000;

            QBCrearEfectosLinea := Linea;
            QBCrearEfectosLinea."Line No." := nro;
            QBCrearEfectosLinea."Anticipo Estado" := Linea."Anticipo Estado"::Aplicacion;
            QBCrearEfectosLinea."Anticipo liquidado por" := USERID;
            QBCrearEfectosLinea."Anticipo liquidado en fecha" := WORKDATE;
            QBCrearEfectosLinea."No. Mov. del Anticipado" := VendorLedgerEntryAnticipo."Entry No.";
            QBCrearEfectosLinea."Anticipo Liquidado documento" := Linea."Anticipo Liquidar con";
            QBCrearEfectosLinea.Amount := importe;
            QBCrearEfectosLinea."Importe Pendiente" := 0;
            QBCrearEfectosLinea.Description1 := 'Aplicaci�n sobre el anticipo';
            QBCrearEfectosLinea.INSERT(FALSE);

            Linea."Anticipo Liquidar con" := '';
            Linea.CALCFIELDS("Anticipo Aplicado");
            Linea."Importe Pendiente" := Linea.Amount + Linea."Anticipo Aplicado";
            IF (NOT parLiquidar) THEN
                Linea."Anticipo Estado" := Linea."Anticipo Estado"::Cancelado
            ELSE IF (Linea."Importe Pendiente" <> 0) THEN
                Linea."Anticipo Estado" := Linea."Anticipo Estado"::Parcial
            ELSE
                Linea."Anticipo Estado" := Linea."Anticipo Estado"::Liquidado;

            Linea.MODIFY(FALSE);
        END;
    END;

    PROCEDURE RegistrarLineaLiquidacion(parLiquidar: Boolean; parAnticipo: Boolean; Linea: Record 7206923; parImporte: Decimal; VAR GenJnlLine: Record 81; NroLinea: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        VendorLedgerEntry: Record 25;
        Vendor: Record 23;
        Cabecera: Record 7206922;
    BEGIN
        QBRelationshipSetup.GET();
        Cabecera.GET(Linea."Relacion No.");

        VendorLedgerEntry.GET(Linea."No. Mov. a Liquidar");
        VendorLedgerEntry.CALCFIELDS("Remaining Amount");
        Vendor.GET(VendorLedgerEntry."Vendor No.");

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);

        //Fecha del d�a
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);

        IF (parAnticipo) THEN BEGIN
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", QBRelationshipSetup."RP Cuenta para Pago anticipado");
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Bal. Account No.", Linea."Vendor No.");
        END;

        //Documento
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.VALIDATE("Document No.", Linea."Document No.");
        //GenJnlLine.VALIDATE("Bill No.", Linea."No. Pagare");

        //Descripci�n
        IF (parLiquidar) THEN
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('Liquidar Anticipo %1 %2 %3', '', VendorLedgerEntry."External Document No.", Vendor.Name), 1, MAXSTRLEN(GenJnlLine.Description))
        ELSE
            GenJnlLine.Description := COPYSTR('Cancelar ' + Linea.Description1, 1, MAXSTRLEN(GenJnlLine.Description));

        GenJnlLine.VALIDATE("Document Date", Linea."Document Date");
        GenJnlLine.VALIDATE("External Document No.", Linea."External Document No.");
        GenJnlLine.VALIDATE("Recipient Bank Account", Linea."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Reason Code", CrearCodigoAuditoria(Cabecera."Bank Account No."));        //C�digo de auditor�a es el banco
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", Linea."Currency Code");

        //Importe
        //++IF (parAnticipo) THEN
        //  GenJnlLine.VALIDATE(Amount, -Linea.Amount)
        //ELSE
        //  GenJnlLine.VALIDATE(Amount, Linea.Amount);
        IF (parLiquidar) THEN
            GenJnlLine.VALIDATE(Amount, parImporte)
        ELSE
            GenJnlLine.VALIDATE(Amount, Linea."Importe Pendiente");

        //Forma y t�rminos de pago
        GenJnlLine.VALIDATE("Payment Terms Code", Linea."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", Linea."Payment Method Code");

        //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
        GenJnlLine."Due Date" := Linea."Due Date";

        //Dimensiones de la l�nea
        IF (parAnticipo) THEN BEGIN
            //Dimensiones de la l�nea
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Linea."Shortcut Dimension 1 Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Linea."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE("Dimension Set ID", Linea."Dimension Set ID");
        END ELSE BEGIN
            //Dimensiones de la factura
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", VendorLedgerEntry."Global Dimension 1 Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", VendorLedgerEntry."Global Dimension 2 Code");
            GenJnlLine.VALIDATE("Dimension Set ID", VendorLedgerEntry."Dimension Set ID");
        END;

        //Si no es el anticipo, liquido el documento
        //IF (NOT parAnticipo) THEN BEGIN
        //  GenJnlLine.VALIDATE("Applies-to Doc. Type", Linea."Document Type");
        //  GenJnlLine.VALIDATE("Applies-to Doc. No.", Linea."Document No.");
        //  GenJnlLine.VALIDATE("Applies-to Bill No.", Linea."No. Pagare");
        //END;

        GenJnlLine.INSERT(TRUE);
    END;

    PROCEDURE CambioProyecto(parVendorLedgerEntry: Record 25; parFechaRegistro: Date; parNewProyecto: Code[20]);
    VAR
        GenJnlLine: Record 81;
        VendorLedgerEntry: Record 25;
        DocPost: Codeunit 7000006;
        NroEfecto: Code[20];
        Text001: TextConst ESP = 'Se ha creado el fichero N67 %1';
    BEGIN
        VerificarDiario;

        NroEfecto := '1';
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Document Type", parVendorLedgerEntry."Document Type");
        VendorLedgerEntry.SETRANGE("Document No.", parVendorLedgerEntry."Document No.");
        IF VendorLedgerEntry.FINDLAST THEN
            NroEfecto := INCSTR(VendorLedgerEntry."Bill No.");

        RegistrarLineaCambioProyecto(TRUE, parVendorLedgerEntry, parFechaRegistro, parNewProyecto, parVendorLedgerEntry."Bill No.", GenJnlLine, 1);
        RegistrarLineaCambioProyecto(FALSE, parVendorLedgerEntry, parFechaRegistro, parNewProyecto, NroEfecto, GenJnlLine, 2);
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
    END;

    PROCEDURE RegistrarLineaCambioProyecto(parAnterior: Boolean; parVendorLedgerEntry: Record 25; parFechaRegistro: Date; parNewProyecto: Code[20]; parEfecto: Code[10]; VAR GenJnlLine: Record 81; NroLinea: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        VendorLedgerEntry: Record 25;
        GenJnlLine2: Record 81;
    BEGIN
        QBRelationshipSetup.GET();
        parVendorLedgerEntry.CALCFIELDS("Remaining Amount");

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);
        GenJnlLine.VALIDATE("Posting Date", parFechaRegistro);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", parVendorLedgerEntry."Vendor No.");

        //Documento
        IF (parAnterior) THEN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ")
        ELSE
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Bill);

        GenJnlLine.VALIDATE("Document No.", parVendorLedgerEntry."Document No.");
        GenJnlLine.VALIDATE("Bill No.", parEfecto);

        //Descripci�n
        GenJnlLine.VALIDATE(Description, COPYSTR('Cambio Proyecto ' + parVendorLedgerEntry.Description, 1, MAXSTRLEN(GenJnlLine.Description)));

        GenJnlLine.VALIDATE("Document Date", parVendorLedgerEntry."Document Date");
        GenJnlLine.VALIDATE("External Document No.", parVendorLedgerEntry."External Document No.");
        GenJnlLine.VALIDATE("Recipient Bank Account", parVendorLedgerEntry."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", parVendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", parVendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Reason Code", parVendorLedgerEntry."Reason Code");
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", parVendorLedgerEntry."Currency Code");

        //Importe
        IF (parAnterior) THEN
            GenJnlLine.VALIDATE(Amount, -parVendorLedgerEntry."Remaining Amount")
        ELSE
            GenJnlLine.VALIDATE(Amount, parVendorLedgerEntry."Remaining Amount");

        //Forma, t�rminos de pago, vtos.
        GenJnlLine."Payment Terms Code" := parVendorLedgerEntry."Payment Terms Code";
        GenJnlLine."Payment Method Code" := parVendorLedgerEntry."Payment Method Code";
        GenJnlLine."Due Date" := parVendorLedgerEntry."Due Date";

        //Dimensiones
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", parVendorLedgerEntry."Global Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", parVendorLedgerEntry."Global Dimension 2 Code");
        GenJnlLine.VALIDATE("Dimension Set ID", parVendorLedgerEntry."Dimension Set ID");

        IF (NOT parAnterior) THEN
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", parNewProyecto);

        //Liquidamos la l�nea anterior
        IF (parAnterior) THEN BEGIN
            GenJnlLine.VALIDATE("Applies-to Doc. Type", parVendorLedgerEntry."Document Type");
            GenJnlLine.VALIDATE("Applies-to Doc. No.", parVendorLedgerEntry."Document No.");
        END;

        GenJnlLine.INSERT(TRUE);
    END;

    PROCEDURE AnularPagareRegistrado(parVendorLedgerEntry: Record 25);
    VAR
        QBRelationshipSetup: Record 7207335;
        GenJnlLine: Record 81;
        Cabecera: Record 7206922;
        Linea: Record 7206923;
        BankAccount: Record 270;
        VendorLedgerEntry: Record 25;
        DocPost: Codeunit 7000006;
        QBAnularPagare: Page 7206941;
        // rpExportN67: Report 7207434;
        NroLinea: Integer;
        NroPagare: Code[20];
        Text001: TextConst ESP = 'Se ha creado el fichero N67 %1';
        FechaRegistro: Date;
        Importe: Decimal;
    BEGIN
        IF (parVendorLedgerEntry."Bill No." = '') THEN
            ERROR('No tiene n�mero de efecto, no puede anular el pagar�');
        IF (parVendorLedgerEntry."Reason Code" = '') THEN
            ERROR('No tiene banco, no puede anular el pagar�');

        CLEAR(QBAnularPagare);
        QBAnularPagare.LOOKUPMODE(TRUE);
        QBAnularPagare.SetVLE(parVendorLedgerEntry);
        IF (QBAnularPagare.RUNMODAL = ACTION::LookupOK) THEN BEGIN
            //IF CONFIRM('Conforme que desea cancelar el pagar� %1 de venciento %2',FALSE, parVendorLedgerEntry."Bill No.", parVendorLedgerEntry."Due Date") THEN BEGIN

            //verifico fechas de registro
            FechaRegistro := QBAnularPagare.GetDate;
            DocPost.CheckPostingDate(FechaRegistro);
            NroLinea := 0;

            //Verifica que el diario est� vac�o
            VerificarDiario;

            //Para efectos ant�guos que no traen el n�mero del documento externo
            IF (parVendorLedgerEntry."External Document No." = '') THEN
                parVendorLedgerEntry."External Document No." := 'Anul.Pagar� ' + parVendorLedgerEntry."Bill No.";

            //Guardo el importe del pagar�
            Importe := parVendorLedgerEntry."Remaining Amount";

            //Registro un diario con una L�nea que cancela el pagar� original y otra que crea de nuevo la factura
            NroLinea += 10000;
            AddLineaAnularPagare(FALSE, parVendorLedgerEntry, GenJnlLine, NroLinea, FechaRegistro);
            NroLinea += 10000;
            AddLineaAnularPagare(TRUE, parVendorLedgerEntry, GenJnlLine, NroLinea, FechaRegistro);

            //Registrar el diario
            IF (NroLinea <> 0) THEN BEGIN
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);

                //Anular el pagar�
                parVendorLedgerEntry.CALCFIELDS("Remaining Amount");

                Cabecera.INIT;
                Cabecera."Posting Date" := FechaRegistro;
                Cabecera."Bank Account No." := parVendorLedgerEntry."Reason Code";
                Cabecera.Registrada := TRUE;
                Cabecera.INSERT(TRUE);

                Linea.INIT;
                Linea."Relacion No." := Cabecera."Relacion No.";
                Linea."Line No." := 10000;
                Linea."Vendor No." := parVendorLedgerEntry."Vendor No.";
                Linea."No. Pagare" := parVendorLedgerEntry."Bill No.";
                Linea."Document Date" := parVendorLedgerEntry."Document Date";
                Linea."Posting Date" := FechaRegistro;
                Linea.Amount := Importe;
                Linea."Currency Code" := parVendorLedgerEntry."Currency Code";
                Linea.Registrada := TRUE;
                Linea.INSERT(FALSE);

                AnularPagare(Linea);
            END;
        END;
    END;

    LOCAL PROCEDURE AddLineaAnularPagare(parNuevo: Boolean; parVendorLedgerEntry: Record 25; VAR GenJnlLine: Record 81; NroLinea: Integer; parFechaRegistro: Date);
    VAR
        QBRelationshipSetup: Record 7207335;
        Linea: Record 7206923;
        PaymentMethod: Record 289;
        VendorLedgerEntry: Record 25;
        NDoc: Text;
        EDoc: Text;
    BEGIN
        QBRelationshipSetup.GET();

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);
        GenJnlLine.VALIDATE("Posting Date", parFechaRegistro);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", parVendorLedgerEntry."Vendor No.");

        //Datos del documento seg�n si es la l�nea de su anulaci�n o la del nuevo vto
        IF (NOT parNuevo) THEN BEGIN
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
            GenJnlLine.VALIDATE("Document No.", parVendorLedgerEntry."Document No.");
            GenJnlLine.VALIDATE("Bill No.", parVendorLedgerEntry."Bill No.");
            GenJnlLine.VALIDATE("External Document No.", parVendorLedgerEntry."External Document No.");
        END ELSE BEGIN
            //Buscar un n�mero de documento que no est� repetido
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Vendor No.", parVendorLedgerEntry."Vendor No.");
            VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
            VendorLedgerEntry.SETFILTER("Document No.", parVendorLedgerEntry."Document No." + '*');
            IF (VendorLedgerEntry.COUNT = 0) THEN BEGIN
                NDoc := parVendorLedgerEntry."Document No.";
                EDoc := parVendorLedgerEntry."External Document No.";
            END ELSE BEGIN
                IF (STRPOS(parVendorLedgerEntry."Document No.", '_') = 0) THEN
                    NDoc := parVendorLedgerEntry."Document No." + '_' + FORMAT(VendorLedgerEntry.COUNT)
                ELSE
                    NDoc := INCSTR(parVendorLedgerEntry."Document No.");
                IF (STRPOS(parVendorLedgerEntry."External Document No.", '_') = 0) THEN
                    EDoc := parVendorLedgerEntry."External Document No." + '_' + FORMAT(VendorLedgerEntry.COUNT)
                ELSE
                    EDoc := INCSTR(parVendorLedgerEntry."External Document No.");
            END;

            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Invoice);
            GenJnlLine.VALIDATE("Document No.", NDoc);
            GenJnlLine.VALIDATE("External Document No.", EDoc);
        END;

        GenJnlLine.VALIDATE("Document Date", parVendorLedgerEntry."Document Date");
        GenJnlLine.VALIDATE("Recipient Bank Account", parVendorLedgerEntry."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", parVendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", parVendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", parVendorLedgerEntry."Currency Code");
        GenJnlLine.VALIDATE("Payment Terms Code", parVendorLedgerEntry."Payment Terms Code");
        IF (NOT parNuevo) THEN
            GenJnlLine.VALIDATE("Payment Method Code", parVendorLedgerEntry."Payment Method Code")
        ELSE
            GenJnlLine.VALIDATE("Payment Method Code", QBRelationshipSetup."RP Forma Pago Anulacion");

        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", parVendorLedgerEntry."Global Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", parVendorLedgerEntry."Global Dimension 2 Code");
        GenJnlLine.VALIDATE("Dimension Set ID", parVendorLedgerEntry."Dimension Set ID");
        GenJnlLine."Due Date" := parVendorLedgerEntry."Due Date";
        parVendorLedgerEntry.CALCFIELDS("Remaining Amount");
        IF (NOT parNuevo) THEN BEGIN
            GenJnlLine.Description := SetDescription(parNuevo, parVendorLedgerEntry);
            GenJnlLine.VALIDATE(Amount, -parVendorLedgerEntry."Remaining Amount");
            GenJnlLine.VALIDATE("Reason Code", parVendorLedgerEntry."Reason Code");
            GenJnlLine.VALIDATE("Applies-to Doc. Type", parVendorLedgerEntry."Document Type");
            GenJnlLine.VALIDATE("Applies-to Doc. No.", parVendorLedgerEntry."Document No.");
        END ELSE BEGIN
            GenJnlLine.Description := SetDescription(parNuevo, parVendorLedgerEntry);
            GenJnlLine.VALIDATE(Amount, parVendorLedgerEntry."Remaining Amount");
        END;

        GenJnlLine.INSERT(TRUE);
    END;

    LOCAL PROCEDURE SetDescription(parNuevo: Boolean; parVendorLedgerEntry: Record 25): Text;
    VAR
        QBRelationshipSetup: Record 7207335;
        Vendor: Record 23;
        GenJnlLine: Record 81;
        auxtxt: Text;
    BEGIN
        QBRelationshipSetup.GET;
        Vendor.GET(parVendorLedgerEntry."Vendor No.");

        IF (NOT parNuevo) THEN
            auxtxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Cancelar Pagaré", parVendorLedgerEntry."Bill No.", parVendorLedgerEntry."External Document No.", Vendor.Name)
        ELSE
            auxtxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Nueva Fra.", parVendorLedgerEntry."Bill No.", parVendorLedgerEntry."External Document No.", Vendor.Name);

        EXIT(COPYSTR(auxtxt, 1, MAXSTRLEN(GenJnlLine.Description)));
    END;

    LOCAL PROCEDURE AdjustToNumer(pValue: Integer; pLon: Integer): Text;
    VAR
        auxTxt: Text;
    BEGIN
        auxTxt := PADSTR('', pLon, '0') + FORMAT(pValue);
        auxTxt := COPYSTR(auxTxt, STRLEN(auxTxt) - pLon + 1);
        EXIT(auxTxt);
    END;

    /*BEGIN
/*{
      JAV 17/06/22: - QB 1.10.51 Nuevo par�metro en la funci�n de impresi�n de un report para sacar la pantalla de opciones
    }
END.*/
}










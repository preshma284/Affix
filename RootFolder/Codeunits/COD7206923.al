Codeunit 7206923 "QB Funciones Efectos"
{


    Permissions = TableData 272 = rimd,
                TableData 7000002 = rimd,
                TableData 7000003 = rimd,
                TableData 7000004 = rimd,
                TableData 7000005 = rimd,
                TableData 7000006 = rimd,
                TableData 7000007 = rimd,
                TableData 7000020 = rimd,
                TableData 7000021 = rimd,
                TableData 7000022 = rimd;
    trigger OnRun()
    BEGIN
    END;

    PROCEDURE RegistrarRelacionPagos(parRelacion: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        GenJnlLine: Record 81;
        Cabecera: Record 7206924;
        Lineas: Record 7206925;
        Text000: TextConst ESP = 'Confirme que desea liquidar los efectos de la presente relaci�n';
        Text001: TextConst ESP = 'Nada que registrar';
        Text005: TextConst ESP = 'El diario %1 secci�n %2 tiene l�neas, eliminelas antes de procesar';
        DocPost: Codeunit 7000006;
        NroLinea: Integer;
        Procesados: Integer;
        Importe: Decimal;
    BEGIN
        Cabecera.GET(parRelacion);

        //Eliminar l�neas sobrantes
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETRANGE(Liquidar, FALSE);
        Lineas.DELETEALL;

        //Verificar las l�neas
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        IF (NOT Lineas.FINDSET(FALSE)) THEN
            ERROR(Text001)
        ELSE
            REPEAT
                IF Lineas."Document No." = '' THEN
                    ERROR('No hay documento en la linea');
                Lineas.CALCFIELDS("Cnt. Movimientos");
                IF (Lineas."Cnt. Movimientos" <> 1) THEN
                    ERROR('El documento %1 est� %2 veces en la relaci�n, no es posible registrar', Lineas."Document No.", Lineas."Cnt. Movimientos");
                IF (Lineas.Amount = 0) THEN
                    ERROR('El documento %1 tiene importe cero o negativo, no es sosible registarlo', Lineas."Document No.");
            UNTIL Lineas.NEXT = 0;

        //verifico fechas de registro
        DocPost.CheckPostingDate(Cabecera."Posting Date");

        //Crear el dario y registrarlo
        IF CONFIRM(Text000, FALSE) THEN BEGIN
            QBRelationshipSetup.GET();
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
            IF (GenJnlLine.COUNT <> 0) THEN
                ERROR(Text005, QBRelationshipSetup."RP Gen.Journal Template Name", QBRelationshipSetup."RP Gen.Journal Batch Name");

            //Poner fecha de cargo en las l�neas
            Lineas.RESET;
            Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
            Lineas.SETRANGE("Fecha Cargo", 0D);
            Lineas.MODIFYALL("Fecha Cargo", Cabecera."Posting Date");

            //Proceso de registro
            NroLinea := 0;
            CLEAR(GenJnlLine);
            Lineas.RESET;
            Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
            IF Lineas.FINDSET THEN
                REPEAT
                    CASE Lineas."Document Situation" OF
                        Lineas."Document Situation"::Cartera:
                            BEGIN
                                //L�nea que crea el pago
                                NroLinea += 10000;
                                RegistrarLinea(Cabecera, Lineas, GenJnlLine, NroLinea);
                                Procesados += 1;
                            END;
                        Lineas."Document Situation"::"BG/PO":
                            BEGIN
                                //La saco de la orden de pago
                                SacarDeOP(Lineas."No. Mov. Proveedor");
                                //L�nea que crea el pago
                                NroLinea += 10000;
                                RegistrarLinea(Cabecera, Lineas, GenJnlLine, NroLinea);
                                Procesados += 1;
                            END;
                        Lineas."Document Situation"::"Posted BG/PO":
                            BEGIN
                                //La liquido desde la orden de pago
                                SacarDeOPR(Lineas."No. Mov. Proveedor", Lineas."Fecha Cargo");
                                Procesados += 1;
                            END;
                    END;
                UNTIL Lineas.NEXT = 0;

            //Registrar el diario
            IF (NroLinea <> 0) THEN BEGIN
                COMMIT; //Desbloquear tablas antes de empezar el registro

                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
                GenJnlLine.DELETEALL;
            END;

            IF Procesados <> 0 THEN BEGIN
                Cabecera.Registrado := TRUE;
                Cabecera.MODIFY;
            END;

            COMMIT; //Desbloquear tablas al finalizar todo
        END;
    END;

    PROCEDURE RegistrarLinea(Cabecera: Record 7206924; Linea: Record 7206925; VAR GenJnlLine: Record 81; NroLinea: Integer);
    VAR
        QBRelationshipSetup: Record 7207335;
        Vendor: Record 23;
        VendorLedgerEntry: Record 25;
        GenJnlLine2: Record 81;
        txtAux: Text;
    BEGIN
        QBRelationshipSetup.GET();
        Vendor.GET(Linea."Vendor No.");
        VendorLedgerEntry.GET(Linea."No. Mov. Proveedor");

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RP Gen.Journal Template Name");
        GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RP Gen.Journal Batch Name");
        GenJnlLine.VALIDATE("Line No.", NroLinea);
        GenJnlLine.VALIDATE("Posting Date", Linea."Fecha Cargo");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Linea."Vendor No.");

        //Documento
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.VALIDATE("Document No.", Linea."Document No.");
        GenJnlLine.VALIDATE("Bill No.", Linea."Bill No.");

        //Descripci�n
        txtAux := 'Pago ' + VendorLedgerEntry.Description; //STRSUBSTNO(QBRelationshipSetup."Texto para Liquidar Efecto", Linea."Document No.", VendorLedgerEntry."External Document No.", Vendor.Name);
        GenJnlLine.Description := COPYSTR(txtAux, 1, MAXSTRLEN(GenJnlLine.Description));

        GenJnlLine.VALIDATE("Document Date", VendorLedgerEntry."Document Date");
        GenJnlLine.VALIDATE("External Document No.", VendorLedgerEntry."External Document No.");
        GenJnlLine.VALIDATE("Recipient Bank Account", VendorLedgerEntry."Recipient Bank Account");
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Linea."Vendor No.");
        GenJnlLine.VALIDATE("Reason Code", VendorLedgerEntry."Bal. Account No.");        //C�digo de auditor�a es el banco
        GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RP Codigo Origen");
        GenJnlLine.VALIDATE("System-Created Entry", TRUE);
        GenJnlLine.VALIDATE("Currency Code", Linea."Currency Code");

        //Importe
        GenJnlLine.VALIDATE(Amount, Linea.Amount);

        //Forma y t�rminos de pago
        GenJnlLine.VALIDATE("Payment Terms Code", VendorLedgerEntry."Payment Terms Code");
        GenJnlLine.VALIDATE("Payment Method Code", VendorLedgerEntry."Payment Method Code");

        //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
        GenJnlLine."Due Date" := Linea."Due Date";

        //Liquidaci�n
        GenJnlLine.VALIDATE("Applies-to Doc. Type", Linea."Document Type");
        GenJnlLine.VALIDATE("Applies-to Doc. No.", Linea."Document No.");

        //Contrapartida
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
        GenJnlLine.VALIDATE("Bal. Account No.", Linea."Bank Account No.");

        //Dimensiones
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Linea."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Linea."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Dimension Set ID", Linea."Dimension Set ID");

        GenJnlLine.INSERT(TRUE);
    END;

    LOCAL PROCEDURE SacarDeOP(parNroMov: Integer);
    VAR
        CarteraDoc: Record 7000002;
        PaymentOrder: Record 7000020;
        CarteraManagement: Codeunit 7000000;
        op: Code[20];
    BEGIN
        CarteraDoc.RESET;
        CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
        CarteraDoc.SETRANGE("Entry No.", parNroMov);
        IF CarteraDoc.FINDFIRST THEN BEGIN
            IF (CarteraDoc."Bill Gr./Pmt. Order No." <> '') THEN BEGIN
                IF (CarteraDoc."Elect. Pmts Exported") THEN
                    ERROR('En la Orden de pago %1 se han generado pagos electr�nicos, debe cancelarlos antes de pagar los efectos.', CarteraDoc."Bill Gr./Pmt. Order No.");
                op := CarteraDoc."Bill Gr./Pmt. Order No.";
                CarteraManagement.RemovePayableDocs(CarteraDoc);

                CarteraDoc.RESET;
                CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", op);
                IF (CarteraDoc.ISEMPTY) THEN BEGIN
                    PaymentOrder.GET(op);
                    PaymentOrder.DELETE;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE SacarDeOPR(parNroMov: Integer; parFEcha: Date);
    VAR
        PostedCarteraDoc: Record 7000003;
        PostedPaymentOrder: Record 7000021;
        // rpReg: Report 7000082;
        Fecha: Date;
    BEGIN
        PostedCarteraDoc.RESET;
        PostedCarteraDoc.SETRANGE(Type, PostedCarteraDoc.Type::Payable);
        PostedCarteraDoc.SETRANGE("Entry No.", parNroMov);
        IF PostedCarteraDoc.FINDFIRST THEN BEGIN
            IF (PostedCarteraDoc.Status = PostedCarteraDoc.Status::Open) THEN BEGIN
                // CLEAR(rpReg);
                // rpReg.SETTABLEVIEW(PostedCarteraDoc);
                // rpReg.USEREQUESTPAGE(FALSE);
                // rpReg.SetPostingDate(parFEcha);
                // rpReg.SetHidePrintDialog := TRUE;
                // rpReg.RUNMODAL;
            END;
        END;
    END;

    /* BEGIN
END.*/
}










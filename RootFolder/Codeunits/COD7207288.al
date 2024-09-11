Codeunit 7207288 "QB Debit Relations"
{
  
  
    trigger OnRun()
BEGIN
          END;

    [EventSubscriber(ObjectType::Table, 7206920, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterDelete_TLines(VAR Rec : Record 7206920;RunTrigger : Boolean);
    BEGIN
      IF (NOT RunTrigger) THEN
        EXIT;

      IF (Rec.Type = Rec.Type::Amount) THEN
        CalculateBills(Rec."Relacion No.");
    END;

    LOCAL PROCEDURE VerificarDiario();
    VAR
      QBRelationshipSetup : Record 7207335;
      Text005 : TextConst ESP='El diario %1 secci�n %2 tiene l�neas, eliminelas antes de procesar';
      GenJnlLine : Record 81;
    BEGIN
      QBRelationshipSetup.GET();
      GenJnlLine.RESET;
      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", QBRelationshipSetup."RC Gen.Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name", QBRelationshipSetup."RC Gen.Journal Batch Name");
      GenJnlLine.DELETEALL;
    END;

    LOCAL PROCEDURE "----------------------------- A¥ADIR IMPORTES Y CREAR EFECTOS"();
    BEGIN
    END;

    PROCEDURE SetAmount(Cabecera : Record 7206919);
    VAR
      QBRelationshipSetup : Record 7207335;
      Lineas : Record 7206920;
      QBDebitRelationsAux : Page 7207673;
      Importe : Decimal;
      Desde : Date;
      Meses : Integer;
      Anterior : Decimal;
      i : Integer;
      TablaMeses : ARRAY [50] OF Date;
      TablaImportes : ARRAY [50] OF Decimal;
      Reparto : Decimal;
      NextBillNo : Text;
      NextLineNo : Integer;
      texto : Text;
    BEGIN
      IF Cabecera.Closed THEN
        ERROR('No puede ampliar una relaci�n cerrada');

      CLEAR(QBDebitRelationsAux);
      QBDebitRelationsAux.SetType(0);
      QBDebitRelationsAux.LOOKUPMODE(TRUE);
      IF QBDebitRelationsAux.RUNMODAL = ACTION::LookupOK THEN BEGIN
        QBDebitRelationsAux.GetDataAmount(Importe, Desde, Meses);
        IF (Importe = 0) THEN
          ERROR('Debe indicar importe');
        IF (Desde = 0D) THEN
          ERROR('Debe indicar fecha de inicio');
        IF (Meses = 0) THEN
          ERROR('Debe indicar meses');

        //Busco primera l�nea a usar
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        IF (Lineas.FINDLAST) THEN
          NextLineNo := Lineas."Line No." + 1
        ELSE
          NextLineNo := 1;

        //A�ado la l�nea de importe
        Lineas.INIT;
        Lineas."Relacion No." := Cabecera."Relacion No.";
        Lineas."Line No." := NextLineNo;
        Lineas.Type := Lineas.Type::Amount;
        Lineas.Date := Desde;
        Lineas.Months := Meses;
        Lineas.VALIDATE(Amount, Importe);
        IF (NextLineNo = 1) THEN
          Lineas.Description := 'Importe inicial de la relaci�n'
        ELSE
          Lineas.Description := 'Cambio del importe';
        Lineas.INSERT(TRUE);

        //Calculo los efectos
        CalculateBills(Lineas."Relacion No.");

      END;
    END;

    PROCEDURE CalculateBills(pNumber : Code[20]);
    VAR
      QBRelationshipSetup : Record 7207335;
      Cabecera : Record 7206919;
      Lineas : Record 7206920;
      tmpLines : Record 7206920 TEMPORARY;
      LineBill : Record 7206920;
      QBDebitRelationsAux : Page 7207673;
      i : Integer;
      Reparto : Decimal;
      LastAmount : Decimal;
      NextBillNo : Text;
      NextLineNo : Integer;
      texto : Text;
      Fecha : Date;
    BEGIN
      Cabecera.GET(pNumber);
      Cabecera.CALCFIELDS("Customer Name");
      QBRelationshipSetup.GET;

      //Borro los efectos no registrados
      LineBill.RESET;
      LineBill.SETRANGE("Relacion No.", pNumber);
      LineBill.SETRANGE(Type, Lineas.Type::Bill);
      LineBill.SETRANGE(Post, FALSE);
      LineBill.DELETEALL;


      tmpLines.RESET;
      tmpLines.DELETEALL;

      Lineas.RESET;
      Lineas.SETRANGE("Relacion No.", pNumber);
      Lineas.SETRANGE(Type, Lineas.Type::Amount);
      Lineas.SETRANGE(Post, FALSE);
      IF (Lineas.FINDFIRST) THEN
        REPEAT
          Reparto := ROUND(Lineas.Amount / Lineas.Months, 0.01);
          LastAmount := Reparto + Lineas.Amount - (Reparto * Lineas.Months);
          Fecha := Lineas.Date;

          FOR i:= 1 TO Lineas.Months DO BEGIN
            //Aumento el contador de efectos y de l�neas
            NextLineNo += 1;

            //creo nuevas l�neas
            tmpLines.INIT;
            tmpLines."Relacion No." := pNumber;
            tmpLines."Line No." := NextLineNo;
            tmpLines.Type := tmpLines.Type::Bill;
            tmpLines.Date := Fecha;
            tmpLines."Due Date" := Fecha;
            IF i <> Lineas.Months THEN
              tmpLines.Amount := Reparto
            ELSE
              tmpLines.Amount := LastAmount;
            tmpLines.INSERT(TRUE);

            Fecha := CALCDATE('+1m',tmpLines.Date);
          END;
        UNTIL Lineas.NEXT = 0;

      //Busco primera l�nea a usar
      LineBill.RESET;
      LineBill.SETRANGE("Relacion No.", pNumber);
      IF (LineBill.FINDLAST) THEN
        NextLineNo := LineBill."Line No." + 1
      ELSE
        NextLineNo := 1;

      //Busco primer efecto a usar
      LineBill.RESET;
      LineBill.SETRANGE("Relacion No.", pNumber);
      LineBill.SETRANGE(Type, LineBill.Type::Bill);
      IF (LineBill.FINDLAST) THEN
        NextBillNo := INCSTR(LineBill."Bill No.")
      ELSE
        NextBillNo := '01';

      tmpLines.RESET;
      tmpLines.SETCURRENTKEY("Relacion No.","Due Date");
      IF tmpLines.FINDSET THEN
        REPEAT
          LineBill.RESET;
          LineBill.SETRANGE("Due Date", tmpLines."Due Date");
          LineBill.SETRANGE(Post, FALSE);
          IF (LineBill.FINDFIRST) THEN BEGIN
            LineBill.Amount += tmpLines.Amount;
            LineBill.MODIFY;
          END ELSE BEGIN
            LineBill := tmpLines;
            LineBill."Line No." := NextLineNo;
            LineBill."Bill No." := NextBillNo;
            texto := STRSUBSTNO(QBRelationshipSetup."RC Texto para crear Efectos", pNumber, Cabecera."Job No.", Cabecera."Customer Name", LineBill."Line No.");
            LineBill.Description := COPYSTR(texto, 1, MAXSTRLEN(LineBill.Description));
            LineBill.INSERT;
            NextLineNo += 1;
            NextBillNo := INCSTR(NextBillNo);
          END;
        UNTIL tmpLines.NEXT = 0;
    END;

    LOCAL PROCEDURE "----------------------------- REGISTRAR RELACION"();
    BEGIN
    END;

    PROCEDURE Registrar(Cabecera : Record 7206919);
    VAR
      GenJnlLine : Record 81;
      Lineas : Record 7206920;
      LineasBill : Record 7206920;
      Text001 : TextConst ESP='Confirme que desea registrar los efectos contablemente';
      Text002 : TextConst ESP='Nada que registrar';
      QBDebitRelationsAux : Page 7207673;
      DocPost : Codeunit 7000006;
      NroLinea : Integer;
      Importe : Decimal;
      toDate : Date;
    BEGIN
      IF (CONFIRM(Text001, FALSE)) THEN BEGIN

        //verifico fechas de registro
        DocPost.CheckPostingDate(Cabecera.Date);

        //Verifica que el diario est� vac�o
        VerificarDiario;

        CLEAR(GenJnlLine);
        NroLinea := 0;

        //Verificar que existen l�neas con importe correcto
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        Lineas.SETRANGE(Type, Lineas.Type::Amount);
        Lineas.SETRANGE(Post, FALSE);
        IF (NOT Lineas.FINDSET) THEN
          ERROR(Text002)
        ELSE BEGIN
          Lineas.Post := TRUE;
          Lineas.MODIFY;

          LineasBill.RESET;
          LineasBill.SETRANGE("Relacion No.", Cabecera."Relacion No.");
          LineasBill.SETRANGE(Type, LineasBill.Type::Bill);
          LineasBill.SETRANGE(Post, FALSE);
          IF LineasBill.FINDSET(TRUE) THEN
            REPEAT
              LineasBill.Post := TRUE;
              LineasBill.MODIFY;
            UNTIL LineasBill.NEXT = 0;

          //L�nea que crea el anticipo por todos los efectos creados
          NroLinea += 1;
          CrearEfecto(TRUE,  Cabecera, Lineas, GenJnlLine, NroLinea, Lineas.Amount);
          NroLinea += 1;
          CrearEfecto(FALSE, Cabecera, Lineas, GenJnlLine, NroLinea, Lineas.Amount);

          //Registrar el diario
          IF (NroLinea <> 0) THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
        END;
      END;
    END;

    PROCEDURE CrearEfecto(parCliente : Boolean;Cabecera : Record 7206919;Linea : Record 7206920;VAR GenJnlLine : Record 81;NroLinea : Integer;LineAmount : Decimal);
    VAR
      QBRelationshipSetup : Record 7207335;
      VendorLedgerEntry : Record 25;
      GenJnlLine2 : Record 81;
      txt : Text;
    BEGIN
      QBRelationshipSetup.GET();
      txt := STRSUBSTNO(QBRelationshipSetup."RC Texto para Registrar", Cabecera."Relacion No.", Cabecera."Job No.", Cabecera."Customer Name");

      GenJnlLine.INIT;
      GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RC Gen.Journal Template Name");
      GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RC Gen.Journal Batch Name");
      GenJnlLine.VALIDATE("Line No.", NroLinea);
      GenJnlLine.VALIDATE("Posting Date", Cabecera.Date);
      IF (parCliente) THEN BEGIN
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", Cabecera."Customer No.");
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Bill No.", Linea."Bill No.");
        GenJnlLine.VALIDATE(Amount, LineAmount);
      END ELSE BEGIN
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", QBRelationshipSetup."RC Cuenta Cobro anticipado");
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Bill No.", '');
        GenJnlLine.VALIDATE(Amount, -LineAmount);
      END;
      GenJnlLine.VALIDATE(Description, COPYSTR(txt,1,MAXSTRLEN(GenJnlLine.Description)));
      GenJnlLine.VALIDATE("Document No.", Linea."Document No.");
      GenJnlLine.VALIDATE("Document Date", Cabecera.Date);
      GenJnlLine.VALIDATE("External Document No.", Cabecera."Relacion No.");
      GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
      GenJnlLine.VALIDATE("Source No.", Cabecera."Customer No.");
      GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Cabecera."Customer No.");
      GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RC Codigo Origen");
      GenJnlLine.VALIDATE("System-Created Entry", TRUE);
      //GenJnlLine.VALIDATE("Payment Terms Code", Cabecera."Payment Terms Code");
      GenJnlLine.VALIDATE("Payment Method Code", QBRelationshipSetup."RC Payment Method Code");
      //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
      GenJnlLine."Due Date" := Linea."Due Date";

      //Dimensiones
      GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Cabecera."Shortcut Dimension 1 Code");
      GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Cabecera."Shortcut Dimension 2 Code");
      GenJnlLine.VALIDATE("Dimension Set ID", Cabecera."Dimension Set ID");

      GenJnlLine.INSERT(TRUE);
    END;

    LOCAL PROCEDURE "---------------------------- TRATAMIENTO DE LAS FACTURAS"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforePostSalesDoc, '', true, true)]
    LOCAL PROCEDURE OnBeforePostSalesDoc(VAR Sender : Codeunit 80;VAR SalesHeader : Record 36;CommitIsSuppressed : Boolean;PreviewMode : Boolean);
    VAR
      Cabecera : Record 7206919;
      PaymentMethod : Record 289;
    BEGIN
      //Verificar que la forma de pago no genere efectos si se aplica a una relaci�n de pagos
      IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]) THEN BEGIN
        Cabecera.RESET;
        Cabecera.SETRANGE("Job No.", SalesHeader."QB Job No.");
        Cabecera.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
        IF (Cabecera.FINDFIRST) THEN BEGIN
          PaymentMethod.GET(SalesHeader."Payment Method Code");
          IF (PaymentMethod."Create Bills") OR (NOT PaymentMethod."Invoices to Cartera") THEN BEGIN
            ERROR('La forma de pago crea efectos o es de contado, no se puede aplicar a la relaci�n de cobros %1', Cabecera."Relacion No.");
          END;
        END;
      END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostSalesDoc, '', true, true)]
    PROCEDURE OnAfterPostSalesDoc(VAR SalesHeader : Record 36;VAR GenJnlPostLine : Codeunit 12;SalesShptHdrNo : Code[20];RetRcpHdrNo : Code[20];SalesInvHdrNo : Code[20];SalesCrMemoHdrNo : Code[20]);
    VAR
      GenJnlLine : Record 81;
      Cabecera : Record 7206919;
      Lineas : Record 7206920;
      Lineas2 : Record 7206920;
      SalesInvoiceHeader : Record 112;
      SalesCrMemoHeader : Record 114;
      DocPost : Codeunit 7000006;
      NextLineNo : Integer;
      NoLiquidacion : Code[10];
      Pendiente : Decimal;
    BEGIN
      //Solo para facturas y abonos
      IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]) THEN BEGIN
        Cabecera.RESET;
        Cabecera.SETRANGE("Job No.", SalesHeader."QB Job No.");
        Cabecera.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
        IF (Cabecera.FINDFIRST) THEN BEGIN
          //Miro el total pendiente
          Cabecera.CALCFIELDS(Amount, "Amount Invoiced");
          Pendiente := Cabecera.Amount - Cabecera."Amount Invoiced";

          //Buscar nro de l�nea
          Lineas.RESET;
          Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
          IF Lineas.FINDLAST THEN
            NextLineNo := Lineas."Line No." + 1
          ELSE
            NextLineNo := 1;

          //Relleno la l�nea en el registro de relaciones
          Lineas.INIT;
          Lineas."Relacion No." := Cabecera."Relacion No.";
          Lineas."Line No." := NextLineNo;
          Lineas.Type := Lineas.Type::Invoice;
          Lineas."No. Liquidation" := NoLiquidacion;
          IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            SalesInvoiceHeader.GET(SalesInvHdrNo);
            Lineas."Document Type" := Lineas."Document Type"::Bill;
            Lineas."Document No." := SalesInvHdrNo;
            Lineas.Date := SalesInvoiceHeader."Posting Date";
            Lineas."Due Date" := SalesInvoiceHeader."Due Date";
            Lineas.Description := SalesInvoiceHeader."Posting Description";
            SalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
            Lineas.Amount := SalesInvoiceHeader."Amount Including VAT";
            IF (Lineas.Amount <= Pendiente) THEN
              Lineas."Applied Amount" := Lineas.Amount
            ELSE
              Lineas."Applied Amount" := Pendiente;
          END ELSE BEGIN
            SalesCrMemoHeader.GET(SalesCrMemoHdrNo);
            Lineas."Document Type" := Lineas."Document Type"::Invoice;
            Lineas."Document No." := SalesCrMemoHdrNo;
            Lineas.Date := SalesCrMemoHeader."Posting Date";
            Lineas."Due Date" := SalesCrMemoHeader."Due Date";
            Lineas.Description := SalesCrMemoHeader."Posting Description";
            SalesCrMemoHeader.CALCFIELDS("Amount Including VAT");
            Lineas.Amount := -SalesCrMemoHeader."Amount Including VAT";
            Lineas."Applied Amount" := Lineas.Amount;
          END;
          Lineas.INSERT(TRUE);

          //Liquidar la factura
          Pendiente := Lineas."Applied Amount";
          Lineas2.INIT;
          Lineas2.SETRANGE("Relacion No.", Cabecera."Relacion No.");
          Lineas2.SETRANGE(Type, Lineas2.Type::Bill);
          IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            IF (Lineas2.FINDSET) THEN
              REPEAT
                IF (Lineas2.Amount - Lineas2."Applied Amount" <> 0) THEN BEGIN
                  IF (Lineas2.Amount - Lineas2."Applied Amount" >= Pendiente) THEN BEGIN
                    Lineas2.VALIDATE("Applied Amount", Pendiente);
                    Pendiente := 0;
                  END ELSE BEGIN
                    Pendiente -= Lineas2.Amount - Lineas2."Applied Amount";
                    Lineas2.VALIDATE("Applied Amount", Lineas2.Amount);
                  END;
                  Lineas2.MODIFY;
                END;
              UNTIL (Pendiente <= 0) OR (Lineas2.NEXT = 0);
          END ELSE BEGIN
            Lineas2.SETFILTER("Applied Amount", '<>0');
            IF (Lineas2.FINDLAST) THEN
              REPEAT
                IF (Lineas2.Amount <= Pendiente) THEN BEGIN
                  Lineas2.VALIDATE("Applied Amount",  -Pendiente);
                  Pendiente := 0;
                END ELSE BEGIN
                  Pendiente += Lineas2."Applied Amount";
                  Lineas2.VALIDATE("Applied Amount", 0);
                END;
                Lineas2.MODIFY;
              UNTIL (Pendiente <= 0) OR (Lineas2.NEXT(-1) = 0);
          END;

          //Crear asiento y registrar el diario
          VerificarDiario;
          CLEAR(GenJnlLine);
          RegistrarLiquidacion(FALSE, Cabecera, Lineas, GenJnlLine, 1);
          RegistrarLiquidacion(TRUE , Cabecera, Lineas, GenJnlLine, 2);

          CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);

        END;
      END;
    END;

    PROCEDURE RegistrarLiquidacion(parFactura : Boolean;Cabecera : Record 7206919;Linea : Record 7206920;VAR GenJnlLine : Record 81;NroLinea : Integer);
    VAR
      QBRelationshipSetup : Record 7207335;
      VendorLedgerEntry : Record 25;
      GenJnlLine2 : Record 81;
      txt : Text;
      importe : Decimal;
    BEGIN
      QBRelationshipSetup.GET();
      txt := STRSUBSTNO(QBRelationshipSetup."RC Texto para Liquidar Fac-Ab", Cabecera."Relacion No.", Cabecera."Job No.", Cabecera."Customer Name");

      GenJnlLine.INIT;
      GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RC Gen.Journal Template Name");
      GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RC Gen.Journal Batch Name");
      GenJnlLine.VALIDATE("Line No.", NroLinea);
      GenJnlLine.VALIDATE("Posting Date", Linea.Date);
      IF (NOT parFactura) THEN BEGIN
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", QBRelationshipSetup."RC Cuenta Cobro anticipado");
        GenJnlLine.VALIDATE(Amount, Linea."Applied Amount");
      END ELSE BEGIN
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", Cabecera."Customer No.");
        IF (Linea.Amount > 0) THEN
          GenJnlLine.VALIDATE("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice)
        ELSE
          GenJnlLine.VALIDATE("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
        GenJnlLine.VALIDATE("Applies-to Doc. No.", Linea."Document No.");
        GenJnlLine.VALIDATE(Amount, -Linea."Applied Amount");
      END;

      GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
      GenJnlLine.VALIDATE("Document No.", Cabecera."Relacion No.");
      GenJnlLine.VALIDATE("Bill No.", '');
      GenJnlLine.VALIDATE(Description, COPYSTR(txt,1,MAXSTRLEN(GenJnlLine.Description)));
      GenJnlLine.VALIDATE("Document Date", Cabecera.Date);
      GenJnlLine.VALIDATE("External Document No.", Cabecera."Relacion No.");
      GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
      GenJnlLine.VALIDATE("Source No.", Cabecera."Customer No.");
      GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Cabecera."Customer No.");
      GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RC Codigo Origen");
      GenJnlLine.VALIDATE("System-Created Entry", TRUE);
      //GenJnlLine.VALIDATE("Payment Terms Code", Cabecera."Payment Terms Code");
      GenJnlLine.VALIDATE("Payment Method Code", QBRelationshipSetup."RC Payment Method Code");
      //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
      GenJnlLine."Due Date" := Linea."Due Date";

      //Dimensiones
      GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Cabecera."Shortcut Dimension 1 Code");
      GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Cabecera."Shortcut Dimension 2 Code");
      GenJnlLine.VALIDATE("Dimension Set ID", Cabecera."Dimension Set ID");

      GenJnlLine.INSERT(TRUE);
    END;

    LOCAL PROCEDURE "---------------------------- RECIBIR LOS PAGARES"();
    BEGIN
    END;

    PROCEDURE Recibir(Cabecera : Record 7206919);
    VAR
      GenJnlLine : Record 81;
      Lineas : Record 7206920;
      BillLines : Record 7206920;
      Text001 : TextConst ESP='Nada que registrar';
      QBDebitRelationsAux : Page 7207673;
      DocPost : Codeunit 7000006;
      NroLinea : Integer;
      Importes : ARRAY [10] OF Decimal;
      Text002 : TextConst ESP='No ha generado pagar�s para todas las l�neas';
      Text003 : TextConst ESP='Las l�neas suman %1, la cabecera indicar %2, revise los datos.';
      Text004 : TextConst ESP='Solo puede registrar por este procedimiento las relaciones lineales';
      Fechas : ARRAY [10] OF Date;
      Tipos : ARRAY [10] OF Option;
      NextLineNo : Integer;
      i : Integer;
      Total : Decimal;
    BEGIN
      //IF (Cabecera.Type <> Cabecera.Type::Linear) THEN
      //  ERROR(Text004);

      IF Cabecera.Closed THEN
        ERROR('No puede ampliar una relaci�n cerrada');

      CLEAR(QBDebitRelationsAux);
      QBDebitRelationsAux.SetType(1);
      QBDebitRelationsAux.LOOKUPMODE(TRUE);
      IF QBDebitRelationsAux.RUNMODAL = ACTION::LookupOK THEN BEGIN
        QBDebitRelationsAux.GetDataReceived(Importes, Fechas, Tipos);

        //verifico fechas de registro
        DocPost.CheckPostingDate(Cabecera.Date);

        //Verifica que el diario est� vac�o
        VerificarDiario;

        CLEAR(GenJnlLine);
        NroLinea := 0;

        //Buscar nro de l�nea
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        IF Lineas.FINDLAST THEN
          NextLineNo := Lineas."Line No." + 1
        ELSE
          NextLineNo := 1;

        //Relleno las l�neas de lo recibido
        Total := 0;
        FOR i:= 1 TO 10 DO BEGIN
          IF (Importes[i] <> 0) THEN BEGIN
            IF (Fechas[i] = 0D) THEN
              ERROR('No ha especificado la fecha %1', i);

            Lineas.INIT;
            Lineas."Relacion No." := Cabecera."Relacion No.";
            Lineas."Line No." := NextLineNo;
            Lineas.Type := Lineas.Type::Payment;
            Lineas."Document Type" := Lineas."Document Type"::" ";
            Lineas."Document No." := '***';
            Lineas.Date := Fechas[i];
            Lineas."Due Date" := Fechas[i];
            Lineas.Description := '***';
            Lineas.Amount := Importes[i];
            Lineas.INSERT(TRUE);

            NextLineNo += 1;
            Total += Lineas.Amount;

            NroLinea += 1;
            CrearPagare(TRUE, Cabecera, Lineas, GenJnlLine, NroLinea, Lineas."Applied Amount");
            NroLinea += 1;
            CrearPagare(FALSE, Cabecera, Lineas, GenJnlLine, NroLinea, Lineas."Applied Amount");
          END;
        END;

        //Liquidar los efectos
        BillLines.RESET;
        BillLines.SETRANGE("Relacion No.", Cabecera."Relacion No.");
        BillLines.SETRANGE(Type, Lineas.Type::Bill);
        IF (BillLines.FINDSET) THEN
          REPEAT
            IF BillLines.Amount - BillLines."Received Amount" <> 0 THEN BEGIN
              IF (BillLines.Amount - BillLines."Received Amount" > Total) THEN BEGIN
                BillLines."Received Amount" := Total;
                Total := 0;
              END ELSE BEGIN
                Total -= BillLines.Amount - BillLines."Received Amount";
                BillLines."Received Amount" := BillLines.Amount;
              END;
              BillLines.MODIFY;
            END;
          UNTIL (Total = 0) OR (BillLines.NEXT = 0);

      EXIT;

        //Registrar el diario
        IF (NroLinea <> 0) THEN
          CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);

      END;
    END;

    PROCEDURE CrearPagare(parEfecto : Boolean;Cabecera : Record 7206919;Linea : Record 7206920;VAR GenJnlLine : Record 81;NroLinea : Integer;LineAmount : Decimal);
    VAR
      QBRelationshipSetup : Record 7207335;
      VendorLedgerEntry : Record 25;
      GenJnlLine2 : Record 81;
      txt : Text;
    BEGIN
      QBRelationshipSetup.GET();

      GenJnlLine.INIT;
      GenJnlLine.VALIDATE("Journal Template Name", QBRelationshipSetup."RC Gen.Journal Template Name");
      GenJnlLine.VALIDATE("Journal Batch Name", QBRelationshipSetup."RC Gen.Journal Batch Name");
      GenJnlLine.VALIDATE("Line No.", NroLinea);
      GenJnlLine.VALIDATE("Posting Date", Cabecera.Date);
      IF (NOT parEfecto) THEN BEGIN
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", QBRelationshipSetup."RC Cuenta Cobro anticipado");
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Bill No.", '');
        txt := STRSUBSTNO(QBRelationshipSetup."RC Texto para Registrar", Cabecera."Relacion No.", Cabecera."Job No.", Cabecera."Customer Name");
        GenJnlLine.VALIDATE(Description, COPYSTR(txt,1,MAXSTRLEN(GenJnlLine.Description)));
        GenJnlLine.VALIDATE(Amount, -LineAmount);
      END ELSE BEGIN
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", Cabecera."Customer No.");
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Bill);
        GenJnlLine.VALIDATE("Bill No.", Linea."Bill No.");
        GenJnlLine.VALIDATE(Description, Linea.Description);
        GenJnlLine.VALIDATE(Amount, LineAmount);
      END;

      GenJnlLine.VALIDATE("Document No.", Linea."Document No.");
      GenJnlLine.VALIDATE("Document Date", Cabecera.Date);
      GenJnlLine.VALIDATE("External Document No.", Cabecera."Relacion No.");
      GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
      GenJnlLine.VALIDATE("Source No.", Cabecera."Customer No.");
      GenJnlLine.VALIDATE("Bill-to/Pay-to No.", Cabecera."Customer No.");
      GenJnlLine.VALIDATE("Source Code", QBRelationshipSetup."RC Codigo Origen");
      GenJnlLine.VALIDATE("System-Created Entry", TRUE);
      //GenJnlLine.VALIDATE("Payment Terms Code", Cabecera."Payment Terms Code");
      GenJnlLine.VALIDATE("Payment Method Code", QBRelationshipSetup."RC Payment Method Code");
      //Vencimiento, No lo valido por si supera lo m�ximo permitido en la forma de pago
      GenJnlLine."Due Date" := Linea."Due Date";

      //Dimensiones
      GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Cabecera."Shortcut Dimension 1 Code");
      GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Cabecera."Shortcut Dimension 2 Code");
      GenJnlLine.VALIDATE("Dimension Set ID", Cabecera."Dimension Set ID");

      GenJnlLine.INSERT(TRUE);
    END;

    /*BEGIN
/*{
      Relaciones de cobros para QuoBuilding
    }
END.*/
}








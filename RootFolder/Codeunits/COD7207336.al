Codeunit 7207336 "QB Payment Phases and Due Date"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Txt000 : TextConst ENU='You cannot change the payment phase, you have already used lines',ESP='No puede cambiar la fase de pago, ya ha usado l�neas';
      Txt001 : TextConst ESP='La pantilla de fases de pago %1 no tiene l�neas';

    PROCEDURE MountDocument(PurchaseHeader : Record 38);
    VAR
      QBPaymentsPhasesLines : Record 7206930;
      QBPaymentsPhasesDoc : Record 7206932;
      Total : Decimal;
    BEGIN
      //JAV 05/01/20: - QB 1.07.19 Montar las fases de pago del documento desde la plantilla

      IF (PurchaseHeader."QB Payment Phases" = '') THEN       //JAV 03/04/21: - QB 1.08.32 Si no hya c�digo no hacer nada
        EXIT;

      //Eliminamos lo que ya exista
      QBPaymentsPhasesDoc.RESET;
      QBPaymentsPhasesDoc.SETRANGE("Document Type", PurchaseHeader."Document Type");
      QBPaymentsPhasesDoc.SETRANGE("Document No.", PurchaseHeader."No.");
      QBPaymentsPhasesDoc.SETRANGE(Used, TRUE);
      IF (NOT QBPaymentsPhasesDoc.ISEMPTY) THEN
        ERROR(Txt000);
      QBPaymentsPhasesDoc.SETRANGE(Used);
      QBPaymentsPhasesDoc.DELETEALL;

      //Calculo el importe total del documento
      PurchaseHeader.CALCFIELDS(Amount, "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");
      Total := PurchaseHeader."Amount Including VAT" - PurchaseHeader."QW Total Withholding PIT" - PurchaseHeader."QW Total Withholding GE";

      //Creamos las l�neas
      QBPaymentsPhasesLines.RESET;
      QBPaymentsPhasesLines.SETRANGE(Code, PurchaseHeader."QB Payment Phases");
      IF (QBPaymentsPhasesLines.ISEMPTY) THEN
        ERROR(Txt001, PurchaseHeader."QB Payment Phases");

      QBPaymentsPhasesLines.FINDSET(TRUE);
      REPEAT
        QBPaymentsPhasesDoc.INIT;
        QBPaymentsPhasesDoc.TRANSFERFIELDS(QBPaymentsPhasesLines);
        QBPaymentsPhasesDoc."Document Type" := PurchaseHeader."Document Type";
        QBPaymentsPhasesDoc."Document No."  := PurchaseHeader."No.";
        QBPaymentsPhasesDoc."Line No."      := QBPaymentsPhasesLines."Line No.";
        QBPaymentsPhasesDoc."Document Date" := PurchaseHeader."Document Date";
        QBPaymentsPhasesDoc."Document Amount" := Total;
        QBPaymentsPhasesDoc.VALIDATE(Amount);
        QBPaymentsPhasesDoc.VALIDATE("Calculated Date");
        QBPaymentsPhasesDoc.INSERT;
      UNTIL QBPaymentsPhasesLines.NEXT = 0;
    END;

    PROCEDURE SeeDocumentPhases(PurchaseHeader : Record 38);
    VAR
      QBPaymentsPhasesDoc : Record 7206932;
      pgQBPaymentPhasesDocument : Page 7206946;
    BEGIN
      QBPaymentsPhasesDoc.RESET;
      QBPaymentsPhasesDoc.SETRANGE("Document Type", PurchaseHeader."Document Type");
      QBPaymentsPhasesDoc.SETRANGE("Document No.", PurchaseHeader."No.");

      CLEAR(pgQBPaymentPhasesDocument);
      pgQBPaymentPhasesDocument.SETTABLEVIEW(QBPaymentsPhasesDoc);
      pgQBPaymentPhasesDocument.RUNMODAL;
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- T38"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterValidateEvent, "Buy-from Vendor No.", true, true)]
    LOCAL PROCEDURE "TB38_OnAfterValidateEvent_Buy-from Vendor No."(VAR Rec : Record 38;VAR xRec : Record 38;CurrFieldNo : Integer);
    VAR
      Vendor : Record 23;
    BEGIN
      IF (Vendor.GET(Rec."Buy-from Vendor No.")) THEN
        Rec.VALIDATE("QB Payment Phases",Vendor."QB Payment Phases");
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 90"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforePostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforePostPurchaseDoc(VAR Sender : Codeunit 90;VAR PurchaseHeader : Record 38;PreviewMode : Boolean;CommitIsSupressed : Boolean);
    VAR
      QBPaymentsPhases : Record 7206929;
      QBPaymentsPhasesLines : Record 7206930;
      QBPaymentsPhasesDoc : Record 7206932;
      QBPaymentsPhasesDoc2 : Record 7206932;
      QBPaymentPhasesCard : Page 7206946;
      Vendor : Record 23;
      PurchaseLine : Record 39;
      nLinea : Integer;
      AmReceived : Decimal;
      AmUsed : Decimal;
      AmPend : Decimal;
      AmReg : Decimal;
    BEGIN
      //Si hay fases de pago, hay que elegirla antes de registrar el documento

      IF (PurchaseHeader."QB Payment Phases" = '') THEN
        EXIT;

      //Si estamos en la vista previa no podemos sacar la lista, en su luigar usamos los del proveedor
      IF (PreviewMode) THEN BEGIN
        IF (NOT Vendor.GET(PurchaseHeader."Buy-from Vendor No.")) THEN
          ERROR('No existe el proveedor %1',PurchaseHeader."Buy-from Vendor No.");
        PurchaseHeader."Payment Method Code" := Vendor."Payment Method Code";
        PurchaseHeader."Payment Terms Code" := Vendor."Payment Terms Code";
        EXIT;
      END;

      //Calcular importes
      PurchaseHeader.CALCFIELDS(Amount); //Base imponible del pedido
      AmReceived := 0;
      PurchaseLine.RESET;
      PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
      PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
      IF (PurchaseLine.FINDSET(FALSE)) THEN
        REPEAT
          AmReceived += ROUND(PurchaseLine."Quantity Received" * PurchaseLine."Direct Unit Cost", 0.01);  //Importe registrado
          AmReg      += ROUND(PurchaseLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost", 0.01);    //Importe a registrar
        UNTIL (PurchaseLine.NEXT = 0);

      //Buscar fase de pago y montar el auxiliar
      IF NOT QBPaymentsPhases.GET(PurchaseHeader."QB Payment Phases") THEN
        ERROR('No existe la fase de pago %1', PurchaseHeader."QB Payment Phases");



      //A�adimos las l�neas que no est�n
      QBPaymentsPhasesLines.RESET;
      QBPaymentsPhasesLines.SETRANGE(Code, PurchaseHeader."QB Payment Phases");
      IF NOT QBPaymentsPhasesLines.FINDSET(TRUE) THEN
        ERROR('La pantilla de fases de pago no tiene l�neas')
      ELSE
        REPEAT
          QBPaymentsPhasesDoc.RESET;
          //++QBPaymentsPhasesDoc.SETRANGE("Phase Code",QBPaymentsPhasesLines.Code);
          //++QBPaymentsPhasesDoc.SETRANGE("Phase Line",QBPaymentsPhasesLines."Line No.");
          IF (QBPaymentsPhasesDoc.ISEMPTY) THEN BEGIN
            QBPaymentsPhasesDoc.INIT;
            QBPaymentsPhasesDoc.TRANSFERFIELDS(QBPaymentsPhasesLines);
            QBPaymentsPhasesDoc."Document Type" := PurchaseHeader."Document Type";
            QBPaymentsPhasesDoc."Document No."  := PurchaseHeader."No.";
            QBPaymentsPhasesDoc.Used := FALSE;
            QBPaymentsPhasesDoc.INSERT;
          END;
        UNTIL QBPaymentsPhasesLines.NEXT = 0;

      COMMIT;

      //Mostrar la pantalla
      QBPaymentsPhasesDoc.RESET;
      QBPaymentsPhasesDoc.SETRANGE("Document Type", PurchaseHeader."Document Type");
      QBPaymentsPhasesDoc.SETRANGE("Document No." , PurchaseHeader."No.");

      CLEAR(QBPaymentPhasesCard);
      IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"]) THEN
        QBPaymentPhasesCard.SetInvoice(PurchaseHeader.Amount,AmReceived,AmReg)
      ELSE
        QBPaymentPhasesCard.SetOrder(PurchaseHeader.Amount,AmReceived,AmReg);

      QBPaymentPhasesCard.SETTABLEVIEW(QBPaymentsPhasesDoc);
      QBPaymentPhasesCard.LOOKUPMODE(TRUE);
      CASE QBPaymentPhasesCard.RUNMODAL OF
        ACTION::LookupCancel : ERROR('');
        ACTION::LookupOK :
          BEGIN
            QBPaymentPhasesCard.GETRECORD(QBPaymentsPhasesDoc);
            //***QBPaymentsPhasesDoc."Phase Used" += 1;
            QBPaymentsPhasesDoc.MODIFY;
            PurchaseHeader.VALIDATE("Payment Method Code",QBPaymentsPhasesDoc."Payment Method Code");
            PurchaseHeader.VALIDATE("Payment Terms Code",QBPaymentsPhasesDoc."Payment Terms Code");
            PurchaseHeader.VALIDATE("QB Calc Due Date", QBPaymentsPhasesDoc."Calc Due Date");
            PurchaseHeader.VALIDATE("QB No. Days Calc Due Date", QBPaymentsPhasesDoc."No. Days Calc Due Date");
            EXIT;
          END;
      END;
      ERROR('No ha seleccionado fase, proceso cancelado');
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostPurchaseDoc(VAR PurchaseHeader : Record 38;VAR GenJnlPostLine : Codeunit 12;PurchRcpHdrNo : Code[20];RetShptHdrNo : Code[20];PurchInvHdrNo : Code[20];PurchCrMemoHdrNo : Code[20];CommitIsSupressed : Boolean);
    BEGIN
      //Si hay fases de pago, hay que quitar los campos de forma y m�todo de pago despu�s de registrar
      IF (PurchaseHeader."QB Payment Phases" = '') THEN
        EXIT;

      PurchaseHeader."Payment Method Code" := '';
      PurchaseHeader."Payment Terms Code" := '';
      IF NOT PurchaseHeader.MODIFY THEN ;              //Si era una factura o abono, se ha eliminado por lo que no podemos modificarla
    END;

    LOCAL PROCEDURE "-------------------------------------------------------------- CU 74"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnBeforeInsertLines, '', true, true)]
    LOCAL PROCEDURE CU74_OnBeforeInsertLines(VAR PurchaseHeader : Record 38);
    VAR
      FunctionQB : Codeunit 7207272;
      PurchaseLine : Record 39;
    BEGIN
      //Si no est� marcado mezclar albaranes y no hay l�neas, marco la cabecera para que las condiciones de pago las establezca el primer albar�n
      IF (PurchaseHeader."QB Merge conditions in Rcpt.") THEN
        EXIT;

      PurchaseLine.RESET;
      PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
      PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
      IF (PurchaseLine.ISEMPTY) THEN BEGIN
        PurchaseHeader."QB First Receipt" := TRUE;
        PurchaseHeader.MODIFY(TRUE);
      END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 74, OnBeforeTransferLineToPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE CU74_OnBeforeTransferLineToPurchaseDoc(VAR PurchRcptHeader : Record 120;VAR PurchRcptLine : Record 121;VAR PurchaseHeader : Record 38;VAR TransferLine : Boolean);
    VAR
      txt01 : TextConst ESP='El albar�n tiene una forma de pago que no se corresponde con los otros incluidos';
      txt02 : TextConst ESP='El albar�n tiene unos t�minos de pago que no se corresponde con los otros incluidos';
      txt03 : TextConst ESP='El albar�n tiene una forma de c�lculo de vencimiento que no se corresponde con los otros incluidos';
      FunctionQB : Codeunit 7207272;
    BEGIN
      //Q8468 >> Al traer un albar�n a la factura, usa forma y m�todo de pago del contrato, que es el que estaba en el albar�n

      //Si es el primer albar�n que estamos incluyendo, usar� sus condiciones en la factura
      IF (PurchaseHeader."QB First Receipt") THEN BEGIN
        PurchaseHeader."QB First Receipt" := FALSE;
        PurchaseHeader.VALIDATE("Payment Method Code",PurchRcptHeader."Payment Method Code");
        PurchaseHeader.VALIDATE("Payment Terms Code",PurchRcptHeader."Payment Terms Code");                //Esto recalcula el vencimiento
        PurchaseHeader.VALIDATE("QB Calc Due Date",PurchRcptHeader."QB Calc Due Date");                    //Esto recalcula el vencimiento
        PurchaseHeader.VALIDATE("QB No. Days Calc Due Date",PurchRcptHeader."QB No. Days Calc Due Date");  //Esto recalcula el vencimiento
        PurchaseHeader.MODIFY(TRUE);
      END ELSE IF (NOT PurchaseHeader."QB Merge conditions in Rcpt.") THEN BEGIN                           //No es el primero y no est� marcado mezclar, verificamos los datos
        IF (PurchaseHeader."Payment Method Code" <> PurchRcptHeader."Payment Method Code") THEN
          ERROR(txt01);
        IF (PurchaseHeader."Payment Terms Code" <> PurchRcptHeader."Payment Terms Code") THEN
          ERROR(txt02);
        IF (PurchaseHeader."QB Calc Due Date" <> PurchRcptHeader."QB Calc Due Date") THEN
          ERROR(txt03);
        IF (PurchaseHeader."QB No. Days Calc Due Date" <> PurchRcptHeader."QB No. Days Calc Due Date") THEN
          ERROR(txt03);
      END;
    END;


    /* /*BEGIN
END.*/
}








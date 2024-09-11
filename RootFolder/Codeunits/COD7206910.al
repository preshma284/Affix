Codeunit 7206910 "QB Suscripciones Almacen"
{
  
  
    Permissions=TableData 169=rm;
    trigger OnRun()
BEGIN
          END;
    VAR
      BoolNewReg : Boolean;

    [EventSubscriber(ObjectType::Codeunit, 22, OnAfterInsertItemLedgEntry, '', true, true)]
    LOCAL PROCEDURE Cdu22_OnAfterInsertItemLedgEntry(VAR ItemLedgerEntry : Record 32;ItemJournalLine : Record 83);
    VAR
      Ceded : Record 7206975;
      CededEntry : Record 7206976;
      rLocation : Record 14;
      NewLocation : Code[20];
      Nomov : Integer;
      QuoBuildingSetup : Record 7207278;
      BoolNewLine : Boolean;
      QtyItemLedEntry : Decimal;
      TEMPReceiptTransferHeaderInesco : Record 50008 TEMPORARY;
      TEMPReceiptTransferLineInesco : Record 50009 TEMPORARY;
      CededQty : Decimal;
      PostReceiptTransfer : Codeunit 7206909;
    BEGIN
      //QUONEXT PER 08.03.2019 QBGA Control de prestados.
      //Comprobar almacen permite cedidos y deposito.
      ItemLedgerEntry."QB Ceded Control" := ItemJournalLine."QB Ceded Control";
      ItemLedgerEntry."QB Diverse Entrance" := ItemJournalLine."QB Diverse Entrance";

      IF NOT rLocation.GET(ItemLedgerEntry."Location Code") THEN
        EXIT;

      ItemLedgerEntry.MODIFY;

      QuoBuildingSetup.GET;
      IF NOT QuoBuildingSetup."Ceded Control" THEN
        EXIT;

      IF NOT ItemLedgerEntry."QB Ceded Control" THEN
         EXIT;

      IF ItemLedgerEntry."QB Diverse Entrance" THEN
         EXIT;

      BoolNewReg := TRUE;
      QtyItemLedEntry := ItemLedgerEntry.Quantity;
      CASE ItemLedgerEntry."Entry Type" OF
        ItemLedgerEntry."Entry Type"::Purchase: BEGIN

          //Tiene movimientos pendientes.
          IF NOT FncCheckEntryCeded(ItemLedgerEntry."Item No.",ItemLedgerEntry."Location Code",Nomov,QtyItemLedEntry) THEN
            EXIT;
          BoolNewReg := FALSE;
          FncFillEntryCeded(ItemLedgerEntry,ItemLedgerEntry."Location Code",ItemJournalLine.Quantity);



        //Q9386 <<
        END;
        ItemLedgerEntry."Entry Type"::Transfer: BEGIN

         NewLocation := ItemJournalLine."Location Code";
         rLocation.GET(NewLocation);

          IF ItemLedgerEntry."Location Code" <> NewLocation THEN BEGIN
            ///Tiene movimientos pendientes
            BoolNewLine := FALSE;
            IF NOT FncCheckEntryCeded(ItemLedgerEntry."Item No.",NewLocation,Nomov,QtyItemLedEntry) THEN
               BoolNewLine := TRUE;

            IF BoolNewLine THEN BEGIN
              ///Crea una nueva linea de prestado.
              Ceded.FillData(ItemLedgerEntry,Ceded."Entry Type"::Input,NewLocation,QtyItemLedEntry,Nomov);
              CededEntry.CreateCededEntry(ItemLedgerEntry,Nomov,NewLocation,QtyItemLedEntry,0);

            END ELSE BEGIN

               FncFillEntryCeded(ItemLedgerEntry,NewLocation,ItemJournalLine.Quantity);

            END;

           END;

        END;

        ItemLedgerEntry."Entry Type"::"Positive Adjmt.": BEGIN
            //Q17138 16-05-2022 CPA.BEGIN
            NewLocation := ItemJournalLine."New Location Code";
            //Q17138 16-05-2022 CPA.END

            ///Tiene movimientos pendientes
            BoolNewLine := FALSE;
            IF NOT FncCheckEntryCeded(ItemLedgerEntry."Item No.",NewLocation,Nomov,QtyItemLedEntry) THEN
               BoolNewLine := TRUE;

            IF BoolNewLine THEN BEGIN
              ///Crea una nueva linea de prestado.
              Ceded.FillData(ItemLedgerEntry,Ceded."Entry Type"::Input,NewLocation,QtyItemLedEntry,Nomov);
              CededEntry.CreateCededEntry(ItemLedgerEntry,Nomov,NewLocation,QtyItemLedEntry,0);

            END ELSE BEGIN
               BoolNewReg := FALSE;
               FncFillEntryCeded(ItemLedgerEntry,NewLocation,ItemJournalLine.Quantity);

            END;
        END;
/*{
        ItemLedgerEntry."Entry Type"::"Negative Adjmt.": BEGIN

            //NewLocation := ItemJournalLine."Location Code";
            NewLocation := ItemJournalLine."New Location Code";


            ///Tiene movimientos pendientes
            BoolNewLine := FALSE;
            IF NOT FncCheckEntryCeded(ItemLedgerEntry."Item No.",NewLocation,Nomov,QtyItemLedEntry) THEN
               BoolNewLine := TRUE;

            IF BoolNewLine THEN BEGIN


              ///Crea una nueva linea de prestado.
              Ceded.FillData(ItemLedgerEntry,Ceded."Entry Type"::Input,NewLocation,QtyItemLedEntry,Nomov);
              CededEntry.CreateCededEntry(ItemLedgerEntry,Nomov,NewLocation,-QtyItemLedEntry,0);

            END ELSE BEGIN
               BoolNewReg := FALSE;
               FncFillEntryCeded(ItemLedgerEntry,NewLocation,-ItemJournalLine.Quantity);

            END;
        END;
        }*/
      END;
    END;

    LOCAL PROCEDURE FncCheckEntryCeded(pItemNo : Code[20];pLocation : Code[20];VAR pNomov : Integer;VAR pQtyRemaining : Decimal) : Boolean;
    VAR
      rCeded : Record 7206975;
    BEGIN

      rCeded.RESET;
      rCeded.SETRANGE("Item No.",pItemNo);
      rCeded.SETRANGE("Destination Location",pLocation);
      rCeded.SETRANGE(Open,TRUE);
      IF rCeded.FINDSET THEN
        REPEAT
          rCeded.CALCFIELDS("Remaining Quantity");
          IF (rCeded."Remaining Quantity" <> 0)THEN BEGIN
            pNomov := rCeded."Entry No.";
            pQtyRemaining := rCeded."Remaining Quantity";
            EXIT(TRUE);
          END;
        UNTIL rCeded.NEXT = 0;
    END;

    LOCAL PROCEDURE FncFillEntryCeded(VAR pItemLedgerEntry : Record 32;pLocationNo : Code[20];pQtyLine : Decimal);
    VAR
      BoolExit : Boolean;
      QtyCeded : Decimal;
      QtyCededTotal : Decimal;
      Ceded : Record 7206975;
      CededEntry : Record 7206976;
      Nomov : Integer;
    BEGIN

        BoolExit := FALSE;
        QtyCededTotal := pQtyLine;
        QtyCeded      := pItemLedgerEntry.Quantity;
        WHILE (QtyCededTotal > 0) AND (NOT BoolExit) DO BEGIN


            IF NOT FncCheckEntryCeded(pItemLedgerEntry."Item No.",pLocationNo,Nomov,QtyCeded) THEN
               BoolExit := TRUE;

            IF NOT BoolExit THEN BEGIN
              // PGM 06/10/20 -
/*{
              IF (QtyCeded >= pQtyLine) THEN BEGIN
                CededEntry.CreateCededEntry(pItemLedgerEntry,Nomov,pLocationNo,-QtyCededTotal);
                QtyCededTotal :=  QtyCededTotal-pQtyLine
              END ELSE BEGIN
                CededEntry.CreateCededEntry(pItemLedgerEntry,Nomov,pLocationNo,-QtyCeded);
                QtyCededTotal :=  QtyCededTotal-QtyCeded;
              END;
              }*/
              CededEntry.CreateCededEntry(pItemLedgerEntry,Nomov,pLocationNo,-QtyCeded,-QtyCededTotal);
              IF QtyCeded <= QtyCededTotal THEN
                QtyCededTotal := QtyCededTotal - QtyCeded
              ELSE
                QtyCededTotal := 0;
              // PGM 06/10/20 +
            END;
        END;

        IF BoolNewReg THEN BEGIN
          //Q9386
          IF (BoolExit) AND (QtyCededTotal >= 0) THEN BEGIN
          //IF ABS(QtyCededTotal) >= 0 THEN BEGIN
                ///Crea una nueva linea de prestado.
              Ceded.FillData(pItemLedgerEntry,Ceded."Entry Type"::Input,pLocationNo,QtyCededTotal,Nomov);
              CededEntry.CreateCededEntry(pItemLedgerEntry,Nomov,pLocationNo,QtyCededTotal,0);
          END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterFinalizePosting, '', true, true)]
    LOCAL PROCEDURE Cod90_OnAfterFinalizePosting(VAR PurchHeader : Record 38;VAR PurchRcptHeader : Record 120;VAR PurchInvHeader : Record 122;VAR PurchCrMemoHdr : Record 124;VAR ReturnShptHeader : Record 6650;VAR GenJnlPostLine : Codeunit 12);
    VAR
      CededEntry : Record 7206976;
      Ceded : Record 7206975;
      ItemLedgEntry : Record 32;
      CededItemLedgEntry : Record 32;
      GLSetup : Record 98;
      CededCostAmount : Decimal;
      CededEntry2 : Record 7206976;
      rlValueEntry : Record 5802;
      vPurchRcptHeaderNo : Code[20];
      bAjustarCoste : Boolean;
      bRealizarMovProductoPrestado : Boolean;
      vCostPerUnit : Decimal;
    BEGIN

      // Si se registra la recepci¢n del producto, se devuelve el prestado.
      // Si solo se factura el albar n ya recibido no se vueve a devolver el producto prestado.
      bRealizarMovProductoPrestado := TRUE;

      // Obtener el n§ de Albar n cuando la factura no lo trae (por medio del movimiento de valor). SOLO ES VµLIDO PARA UN éNICO ALBARµN POR FACTURA
      vPurchRcptHeaderNo:='';
      IF PurchRcptHeader."No." = '' THEN
        BEGIN
          bRealizarMovProductoPrestado:= FALSE; // Caso "Facturar" (No "Recibir y Facturar")

          CLEAR(rlValueEntry);
          rlValueEntry.SETRANGE("Document No.", PurchInvHeader."No.");
          rlValueEntry.SETRANGE("Posting Date", PurchInvHeader."Posting Date");
          IF rlValueEntry.FINDSET THEN
            IF ItemLedgEntry.GET(rlValueEntry."Item Ledger Entry No.") THEN
              BEGIN
                vPurchRcptHeaderNo:= ItemLedgEntry."Document No.";
                PurchRcptHeader.GET(vPurchRcptHeaderNo);
                vCostPerUnit:= rlValueEntry."Cost per Unit";
                bAjustarCoste:= TRUE;
              END;
        END
        ELSE
          BEGIN
            vPurchRcptHeaderNo:= PurchRcptHeader."No.";
            bAjustarCoste:= FALSE;
          END;

      //Si no encontramos un albar n no hacemos nada (Salimos)
      IF PurchRcptHeader."No." = '' THEN
        EXIT;
/*{
      //Control para registro de Albaranes no facturados. Recibir (y No Facturar)
      bAjustarCoste:=TRUE;
      CededEntry.RESET;
      CededEntry.SETRANGE("Document No.",PurchRcptHeader."No.");
      IF CededEntry.FINDSET THEN
        IF ItemLedgEntry.GET(CededEntry."Item Entry No.") THEN
          IF ItemLedgEntry."Invoiced Quantity" = 0 THEN
            bAjustarCoste:= FALSE;
      }*/

      GLSetup.GET;

      CededEntry.RESET;
      CededEntry.SETRANGE("Document No.",PurchRcptHeader."No.");
      IF CededEntry.FINDSET THEN
        REPEAT
          //Q17138 16-05-2022 CPA.BEGIN

          // Cuando se registra la factura (sin recibir) puede que haya un coste diferente (al registrado en el albar n) que necesitamos actualizar en el movimiento de prestado.
          IF bAjustarCoste THEN
            IF CededEntry."Cost Amount (Actual)" <> vCostPerUnit THEN
              BEGIN
                CededEntry."Cost Amount (Actual)":= vCostPerUnit;
                CededEntry.MODIFY;
              END;

          //Buscamos el movimiento de producto Cedido y lo revalorizamos al coste de la compra, ya que viene de una transferencia sin coste y modifica el valor del inventario en el almac‚n.
          IF CededItemLedgEntry."Entry No." <> CededEntry."Item Entry No." THEN
            ItemLedgEntry.GET(CededEntry."Item Entry No.");

          ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");

          IF Ceded."Entry No." <> CededEntry."Ceded Entry No." THEN BEGIN
            Ceded.GET(CededEntry."Ceded Entry No.");
            CededItemLedgEntry.GET(Ceded."Item Entry No.");
            CededItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
          END;


          // El nuevo coste real del movimiento de cedido se ir  actualizando conforme se vaya devolviendo el pr‚stamo, con las entradas a coste real
          // Si se produce una entrada de albar n sin facturar, se actualiza el movimiento con el coste esperado.
          // Una vez se factura el albar n, se actualiza el coste real en el movimiento de prestado.
          CededEntry2.RESET;
          CededEntry2.GET(CededEntry."Entry No.");
          CededCostAmount := FncCalcAdjustCost(CededItemLedgEntry."Entry No.");

          // Si el ajuste es por la misma cantidad que el movimiento da un error de divisi¢n por cero
          IF (ItemLedgEntry.Quantity <> 0) AND (CededCostAmount <> CededItemLedgEntry."Cost Amount (Actual)") THEN
            AdjustUnitCostItemLedgEntry(CededItemLedgEntry, - CededEntry.Quantity, CededCostAmount, PurchHeader."Posting Date");
          //Q17138 16-05-2022 CPA.END

          // Se hace la devoluci¢n del producto prestado al almac‚n QA (Cuando se registra el albar n)
          IF bRealizarMovProductoPrestado THEN
            FncCreateTransferCeded(CededEntry);
        UNTIL CededEntry.NEXT = 0;
    END;

    PROCEDURE FncCreateTransferCeded(VAR pCededEntry : Record 7206976);
    VAR
      ItemJournalLine : Record 83;
      pCeded : Record 7206975;
      ItemJnlPostLine : Codeunit 22;
      QuoBuildingSetup : Record 7207278;
      ItemJnlPostBatch : Codeunit 23;
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN
      pCeded.GET(pCededEntry."Ceded Entry No.");

      QuoBuildingSetup.GET;
      QuoBuildingSetup.TESTFIELD("Receipt Management Section");
      QuoBuildingSetup.TESTFIELD("Receipt Management Journal");

      ItemJournalLine.INIT;
      ItemJournalLine.SETRANGE("Journal Template Name" ,QuoBuildingSetup."Receipt Management Journal");
      ItemJournalLine.SETRANGE("Journal Batch Name",QuoBuildingSetup."Receipt Management Section");
      IF ItemJournalLine.FINDFIRST THEN
        ItemJournalLine.DELETEALL(TRUE);

      ItemJournalLine.INIT;
      ItemJournalLine."Journal Template Name" := QuoBuildingSetup."Receipt Management Journal";
      ItemJournalLine."Journal Batch Name" := QuoBuildingSetup."Receipt Management Section";
      ItemJournalLine."Line No." := 10000;
      ItemJournalLine.VALIDATE("Posting Date",pCededEntry."Posting Date");
      ItemJournalLine.VALIDATE("Entry Type",ItemJournalLine."Entry Type"::"Negative Adjmt.");
      ItemJournalLine.VALIDATE("Document No.",pCededEntry."Document No.");
      ItemJournalLine.VALIDATE("Item No.",pCededEntry."Item No.");
      ItemJournalLine.VALIDATE(Description,pCededEntry.Description);
      ItemJournalLine.VALIDATE("Location Code",pCeded."Destination Location");
      ItemJournalLine.VALIDATE(Quantity,ABS(pCededEntry.Quantity)); //Q9386
      ItemJournalLine.INSERT(TRUE);

      ItemJournalLine.INIT;
      ItemJournalLine."Journal Template Name" := QuoBuildingSetup."Receipt Management Journal";
      ItemJournalLine."Journal Batch Name" := QuoBuildingSetup."Receipt Management Section";
      ItemJournalLine."Line No." := 20000;
      ItemJournalLine.VALIDATE("Posting Date",pCededEntry."Posting Date");
      ItemJournalLine.VALIDATE("Entry Type",ItemJournalLine."Entry Type"::"Positive Adjmt.");
      ItemJournalLine.VALIDATE("Document No.",pCededEntry."Document No.");
      ItemJournalLine.VALIDATE("Item No.",pCededEntry."Item No.");
      ItemJournalLine.VALIDATE(Description,pCededEntry.Description);
      ItemJournalLine.VALIDATE("Location Code",pCeded."Origin Location");
      ItemJournalLine.VALIDATE(Quantity,ABS(pCededEntry.Quantity)); //Q9386

      //Coste cero para el mov. de entrada en almac‚n cedido.
      ItemJournalLine.VALIDATE("Unit Cost", 0);
      ItemJournalLine.INSERT(TRUE);

      CLEAR(ItemJnlPostBatch);
      ItemJnlPostBatch.RUN(ItemJournalLine);
/*{
          ItemJournalLine.INIT;
          ItemJournalLine."Journal Template Name" := QuoBuildingSetup."Receipt Management Journal";
          ItemJournalLine."Journal Batch Name" := QuoBuildingSetup."Receipt Management Section";
          ItemJournalLine."Line No." := 10000;
          ItemJournalLine.VALIDATE("Posting Date",pCededEntry."Posting Date");
          ItemJournalLine.VALIDATE("Entry Type",ItemJournalLine."Entry Type"::Transfer);
          ItemJournalLine.VALIDATE("Document No.",pCededEntry."Document No.");
          ItemJournalLine.VALIDATE("Item No.",pCededEntry."Item No.");
          ItemJournalLine.VALIDATE(Description,pCededEntry.Description);
          ItemJournalLine.VALIDATE("Location Code",pCeded."Destination Location");
          IF pCeded."Origin Location"<> '' THEN
            ItemJournalLine.VALIDATE("New Location Code",pCeded."Origin Location");
          ItemJournalLine.VALIDATE(Quantity,ABS(pCededEntry.Quantity)); //Q9386
          ItemJournalLine.INSERT(TRUE);
          CLEAR(ItemJnlPostLine);
          ItemJnlPostLine.RUN(ItemJournalLine);
      }*/
      //Q17138 16-05-2022 CPA.END
    END;

    PROCEDURE AdjustReturnCededItemLedgEntryApplication(CededEntryNo : Integer;PurchItemLedgEntryNo : Integer;VAR UnapliedQuantity : Decimal);
    VAR
      PurchaseItemApplicationEntry : Record 339;
      CededApplicationEntry : Record 339;
      InboudItemLedgEntry : Record 32;
      InboudItemLedgEntry2 : Record 32;
      OutboundItemLedgEntry : Record 32;
      PurchaseItemLedgEntry : Record 32;
      ReturnCededItemLedgEntry : Record 32;
      ConsumptionItemLedgEntry : Record 32;
      RemainingQtyToUnaply : Decimal;
      Item : Record 27;
      Ceded : Record 7206975;
      CededEntry : Record 7206976;
      CededInboundItemLedgEntry : Record 32;
      CededEntryUnappliedQuantity : Decimal;
      CededEntryAppliedQuantity : Decimal;
      bFoundConsumptionApplication : Boolean;
      QtyToUnapply : Decimal;
      CededAppliedQuantity_Difference : Decimal;
      PurchaseAppliedQuantity_Difference : Decimal;
      CededLocationCode : Code[20];
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN
      //Movimiento de la compra
      PurchaseItemLedgEntry.GET(PurchItemLedgEntryNo);


      //Obtenemos el movimiento de transferencia de entrada del cedido
      CededEntry.RESET;
      CededEntry.SETCURRENTKEY("Item No.");
      CededEntry.SETRANGE("Item No.", PurchaseItemLedgEntry."Item No.");
      CededEntry.SETRANGE("Ceded Entry No.", CededEntryNo);
      CededEntry.SETRANGE("Destination Location", PurchaseItemLedgEntry."Location Code");
      CededEntry.SETFILTER(Quantity, '>%1', 0);
      IF CededEntry.FINDFIRST THEN BEGIN
        CededInboundItemLedgEntry.GET(CededEntry."Item Entry No.");
        CededLocationCode := CededEntry."Origin Location";
      END ELSE
        EXIT;

      //Comprobamos que existe el movimiento de transferencia de salida de devoluci¢n del cedido asociado a la compra
      CededEntry.RESET;
      CededEntry.SETCURRENTKEY("Item No.");
      CededEntry.SETRANGE("Item No.", PurchaseItemLedgEntry."Item No.");
      CededEntry.SETRANGE("Item Entry No.", PurchaseItemLedgEntry."Entry No.");
      CededEntry.SETRANGE("Destination Location", PurchaseItemLedgEntry."Location Code");
      CededEntry.SETFILTER(Quantity, '<%1', 0);
      IF NOT CededEntry.FINDFIRST THEN
        EXIT;

      // Cuando hay un cedido el movimiento de compra se liquida contra un movimiento de tipo Transferencia- que corresponde a la devoluci¢n del cedido.
      // Buscamos ese movimiento Dev. Cedido (Transf-) para liquidarlo contra el movimiento Cedido (Trasf+).
      // Tenemos que desliquidar el movimiento de compra cuando est‚ liquidado por movimientos de tipo Transferencia- (Dev. Cedido) para liquidarlo contra movimientos de Consumos.
      PurchaseItemApplicationEntry.RESET;
      PurchaseItemApplicationEntry.SETCURRENTKEY("Inbound Item Entry No.","Item Ledger Entry No.","Outbound Item Entry No.","Cost Application");
      PurchaseItemApplicationEntry.SETRANGE("Inbound Item Entry No.", PurchItemLedgEntryNo);
      PurchaseItemApplicationEntry.SETRANGE("Cost Application", FALSE);
      IF PurchaseItemApplicationEntry.FINDSET THEN REPEAT
        ReturnCededItemLedgEntry.GET(PurchaseItemApplicationEntry."Outbound Item Entry No.");
        IF ReturnCededItemLedgEntry."Entry Type" = OutboundItemLedgEntry."Entry Type"::Transfer THEN BEGIN


          CededApplicationEntry.RESET;
          CededApplicationEntry.SETCURRENTKEY("Inbound Item Entry No.","Item Ledger Entry No.","Outbound Item Entry No.","Cost Application");
          CededApplicationEntry.SETRANGE("Inbound Item Entry No.", CededInboundItemLedgEntry."Entry No.");
          CededApplicationEntry.SETRANGE("Cost Application", FALSE);
          IF CededApplicationEntry.FINDSET THEN REPEAT
            InboudItemLedgEntry2.GET(CededApplicationEntry."Outbound Item Entry No.");

            PurchaseAppliedQuantity_Difference := ABS(PurchaseItemApplicationEntry.Quantity - CededApplicationEntry.Quantity);

            //Desliquidamos la cantidad liquidada entre movimiento de Compra y Dev. Cedido
            QtyToUnapply := PurchaseItemApplicationEntry.Quantity;
            PurchaseItemLedgEntry."Remaining Quantity" += -QtyToUnapply; PurchaseItemLedgEntry.MODIFY;
            ReturnCededItemLedgEntry."Remaining Quantity" += QtyToUnapply; ReturnCededItemLedgEntry.MODIFY;
            PurchaseItemApplicationEntry.Quantity := 0; PurchaseItemApplicationEntry.MODIFY;

            //Desliquidamos la cantidad liquidada entre movimiento Cedido y InboudItemLedgEntry2
            QtyToUnapply := CededApplicationEntry.Quantity;
            CededInboundItemLedgEntry."Remaining Quantity" += -QtyToUnapply; CededInboundItemLedgEntry.MODIFY;
            InboudItemLedgEntry2."Remaining Quantity" += QtyToUnapply; InboudItemLedgEntry2.MODIFY;
            CededApplicationEntry.Quantity := 0; CededApplicationEntry.MODIFY;

            //El movimiento Cedido se liquida contra el movimiento Dev.Cedido por toda la cantidad que indique Dev. Cedido
            IF (ABS(ReturnCededItemLedgEntry."Remaining Quantity") < ABS(CededInboundItemLedgEntry."Remaining Quantity")) THEN
              QtyToUnapply := ReturnCededItemLedgEntry."Remaining Quantity"
            ELSE
              QtyToUnapply := -CededInboundItemLedgEntry."Remaining Quantity";

            PurchaseItemApplicationEntry."Inbound Item Entry No." := CededInboundItemLedgEntry."Entry No.";
            PurchaseItemApplicationEntry.Quantity := QtyToUnapply;
            PurchaseItemApplicationEntry.MODIFY;

            CededInboundItemLedgEntry."Remaining Quantity" -= -QtyToUnapply;
            CededInboundItemLedgEntry.MODIFY;

            ReturnCededItemLedgEntry."Remaining Quantity" -= QtyToUnapply;
            ReturnCededItemLedgEntry.MODIFY;

            //El movimiento Compra se liquida contra el movimiento de consumo InboudItemLedgEntry2 por la menor cantidad pendiente entre ambos
            IF (ABS(PurchaseItemLedgEntry."Remaining Quantity") < ABS(InboudItemLedgEntry2."Remaining Quantity")) THEN
              QtyToUnapply := -PurchaseItemLedgEntry."Remaining Quantity"
            ELSE
              QtyToUnapply := InboudItemLedgEntry2."Remaining Quantity";

            CededApplicationEntry."Inbound Item Entry No." := PurchaseItemLedgEntry."Entry No.";
            CededApplicationEntry.Quantity := QtyToUnapply;
            CededApplicationEntry.MODIFY;

            PurchaseItemLedgEntry."Remaining Quantity" -= -QtyToUnapply;
            PurchaseItemLedgEntry.MODIFY;

            InboudItemLedgEntry2."Remaining Quantity" -= QtyToUnapply;
            InboudItemLedgEntry2.MODIFY;


            //Busco la contraparte del movimiento de devoluci¢n de Cedido:
            //Un movimiento de entrada de tipo transferencia+ al almac‚n de cedidos
            //para revalorizarlo a cero
            InboudItemLedgEntry2.RESET;
            InboudItemLedgEntry2.SETCURRENTKEY("Item No.",Open,"Variant Code","Location Code","Item Tracking","Lot No.","Serial No.");
            InboudItemLedgEntry2.SETRANGE("Item No.", ReturnCededItemLedgEntry."Item No.");
            InboudItemLedgEntry2.SETRANGE("Variant Code", ReturnCededItemLedgEntry."Variant Code");
            InboudItemLedgEntry2.SETRANGE("Location Code", CededLocationCode);
            InboudItemLedgEntry2.SETRANGE("Document No.", ReturnCededItemLedgEntry."Document No.");
            InboudItemLedgEntry2.SETRANGE(Positive, TRUE);
            InboudItemLedgEntry2.SETRANGE("Entry Type", InboudItemLedgEntry2."Entry Type"::Transfer);
            IF InboudItemLedgEntry2.FINDFIRST THEN
              AdjustUnitCostItemLedgEntry(InboudItemLedgEntry2, InboudItemLedgEntry2.Quantity,0,InboudItemLedgEntry2."Posting Date");

          UNTIL CededApplicationEntry.NEXT = 0;
        END;
      UNTIL (PurchaseItemApplicationEntry.NEXT = 0);
      //Q17138 16-05-2022 CPA.END
    END;

    LOCAL PROCEDURE AdjustUnitCostItemLedgEntry(ItemLedgEntry : Record 32;ValuedQuantity : Decimal;NewCostAmount : Decimal;NewPostingDate : Date);
    VAR
      ItemJnlLine : Record 83;
      InvSetuo : Record 313;
      ItemJnlTemplate : Record 82;
      JnlTemplateName : Code[10];
      ItemJnlBatch : Record 233;
      ItemJnlPostLine : Codeunit 22;
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN
      ItemJnlBatch.RESET;
      ItemJnlBatch.SETRANGE(Recurring, FALSE);
      ItemJnlBatch.SETRANGE("Template Type", ItemJnlBatch."Template Type"::Revaluation);
      ItemJnlBatch.FINDFIRST;

      ItemJnlLine.RESET;
      ItemJnlLine.INIT;
      ItemJnlLine.VALIDATE("Journal Template Name", ItemJnlBatch."Journal Template Name");
      ItemJnlLine.VALIDATE("Journal Batch Name", ItemJnlBatch.Name);
      ItemJnlLine.VALIDATE("Document No.", ItemLedgEntry."Document No.");


      //ItemJnlLine.VALIDATE("Posting Date", ItemLedgEntry."Posting Date");

      ItemJnlLine.VALIDATE("Value Entry Type", ItemJnlLine."Value Entry Type"::Revaluation);
      ItemJnlLine.VALIDATE("Item No.", ItemLedgEntry."Item No.");
      ItemJnlLine.VALIDATE("Applies-to Entry", ItemLedgEntry."Entry No.");

      ItemJnlLine.VALIDATE("Posting Date", NewPostingDate); // Despu‚s de "Applies-To Entry" para que no lo sobreescriba.

      ItemJnlLine.VALIDATE(Quantity, ValuedQuantity);
      ItemJnlLine.VALIDATE("Invoiced Quantity", ValuedQuantity);

      ItemJnlLine.VALIDATE("Inventory Value (Revalued)", NewCostAmount);
      //ItemJnlLine.VALIDATE("Unit Cost (Revalued)", NewCost);

      ItemJnlPostLine.RUN(ItemJnlLine);
      //Q17138 16-05-2022 CPA.END
    END;

    LOCAL PROCEDURE FncCalcAdjustCost(pItemEntryNo : Integer) : Decimal;
    VAR
      GLSetup : Record 98;
      QBCededEntry : Record 7206976;
      QBCededEntryInput : Record 7206976;
      vQtyInput : Decimal;
      vAmountInput : Decimal;
      vAmount : Decimal;
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN
      vAmount:=0;

      GLSetup.GET;

      CLEAR(QBCededEntry);
      QBCededEntry.SETRANGE("Item Entry No.", pItemEntryNo);
      IF QBCededEntry.FINDSET THEN
        BEGIN
          vQtyInput:=0;
          vAmountInput:=0;
          CLEAR(QBCededEntryInput);
          QBCededEntryInput.SETRANGE("Ceded Entry No.", QBCededEntry."Ceded Entry No.");
          QBCededEntryInput.SETFILTER(Quantity, '<0');
          IF QBCededEntryInput.FINDSET THEN
            REPEAT
              vQtyInput+=QBCededEntryInput.Quantity; // Cantidad Negativa
              vAmountInput+= ABS(QBCededEntryInput.Quantity) * QBCededEntryInput."Cost Amount (Actual)";

            UNTIL QBCededEntryInput.NEXT=0;

          // El valor del movimiento ser  lo pendiente de ajustar multiplicado por el coste te¢rico
          // m s el coste real que ya se ha ajustado.
          vAmount := (QBCededEntry.Quantity + vQtyInput) * QBCededEntry."Cost Amount (Expected)" +
                      vAmountInput;
          vAmount := ROUND(vAmount, GLSetup."Amount Rounding Precision");

          EXIT(vAmount);

        END;
      //Q17138 16-05-2022 CPA.END
    END;

    [EventSubscriber(ObjectType::Table, 5802, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertValueEntry(VAR Rec : Record 5802;RunTrigger : Boolean);
    VAR
      JobLedgEntry : Record 169;
      ItemLedgEntry : Record 32;
      DimensionValue : Record 349;
      GLSetup : Record 98;
      rlItem : Record 27;
      QuoBuildingSetup : Record 7207278;
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN
      IF Rec.ISTEMPORARY THEN EXIT;

      //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.Begin
      QuoBuildingSetup.GET;
      IF NOT QuoBuildingSetup."Ceded Control" THEN
        EXIT;
      //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.End

      AdjustUnitCostJobLedgEntry(Rec."Item Ledger Entry No.", - Rec."Cost Amount (Actual)", Rec."Document No.", Rec."Posting Date", Rec."Entry No.");
      //Q17138 16-05-2022 CPA.END
    END;

    [EventSubscriber(ObjectType::Table, 169, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE OnAfterInsertJobLedgEntry(VAR Rec : Record 169;RunTrigger : Boolean);
    VAR
      DimensionValue : Record 349;
      GLSetup : Record 98;
    BEGIN
/*{
      GLSetup.GET;

      IF Rec."Job No." = 'ALMACEN' THEN

        DimensionValue.RESET;
        DimensionValue.GET(GLSetup."Global Dimension 1 Code", Rec."Global Dimension 1 Code");
        IF DimensionValue."Job Structure Warehouse" = Rec."Job No." THEN
          //ERROR('Encontrado');
      }*/
    END;

    LOCAL PROCEDURE AdjustUnitCostJobLedgEntry(RevaluatedItemLedgerEntryNo : Integer;TotalCostIncrement : Decimal;NewDocumentNo : Code[20];NewPostingDate : Date;ValueEntryNo : Integer);
    VAR
      JobJnlLine : Record 210;
      LineNo : Integer;
      jobJnlPostBatch : Codeunit 1021;
      JobJnlTemplate : Record 209;
      JobJnlBatch : Record 237;
      JobJnlTemplateName : Code[10];
      JobJnlBatchName : Code[10];
      JobLedgEntry : Record 169;
      JobLedgEntry2 : Record 169;
      GLSetup : Record 98;
      ItemLedgEntry : Record 32;
      UnitCost : Decimal;
      NewUnitCostLCY : Decimal;
      QuoBuildingSetup : Record 7207278;
      Job : Record 167;
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN
      IF TotalCostIncrement = 0 THEN EXIT;

      GLSetup.GET;
      ItemLedgEntry.GET(RevaluatedItemLedgerEntryNo);

      JobLedgEntry.RESET;
      JobLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
      JobLedgEntry.SETRANGE("Document No.", ItemLedgEntry."Document No.");
      JobLedgEntry.SETRANGE("Posting Date", ItemLedgEntry."Posting Date");

      JobLedgEntry.SETRANGE(Type, JobLedgEntry.Type::Item);
      JobLedgEntry.SETRANGE("No.", ItemLedgEntry."Item No.");

      JobLedgEntry.SETRANGE(Correction, FALSE);
      IF JobLedgEntry.FINDLAST THEN BEGIN
        //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.Begin
        Job.GET(JobLedgEntry."Job No.");
        //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.End

        QuoBuildingSetup.RESET;
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Job revaluation Jnl. Template");
        QuoBuildingSetup.TESTFIELD("Job revaluation Jnl. Batch");

        JobJnlTemplateName := QuoBuildingSetup."Job revaluation Jnl. Template";
        JobJnlBatchName := QuoBuildingSetup."Job revaluation Jnl. Batch";

        NewUnitCostLCY := ROUND((JobLedgEntry."Total Cost (LCY)" + TotalCostIncrement) / JobLedgEntry.Quantity, GLSetup."Unit-Amount Rounding Precision");

        JobJnlLine.RESET;
        JobJnlLine.SETRANGE("Journal Template Name", JobJnlTemplateName);
        JobJnlLine.SETRANGE("Journal Batch Name", JobJnlBatchName);
        IF JobJnlLine.FINDLAST THEN
          LineNo := JobJnlLine."Line No.";
        //JobJnlLine.DELETEALL;
        REPEAT
          //05/07/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.Begin
          Job.GET(JobLedgEntry."Job No.");
          //05/07/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.End

          LineNo += 10000;
          JobJnlLine.INIT;
          JobJnlLine.VALIDATE("Journal Template Name", JobJnlTemplateName);
          JobJnlLine.VALIDATE("Journal Batch Name", JobJnlBatchName);
          JobJnlLine."Line No." := LineNo;
          JobJnlLine.VALIDATE("Job No.", JobLedgEntry."Job No.");
          JobJnlLine.VALIDATE("Posting Date", NewPostingDate);
          JobJnlLine.VALIDATE("Document No.", NewDocumentNo);
          JobJnlLine.VALIDATE(Type, JobLedgEntry.Type);
          JobJnlLine.VALIDATE("No.", JobLedgEntry."No.");
          JobJnlLine.VALIDATE(Description, JobLedgEntry.Description);
          JobJnlLine.VALIDATE("Description 2", JobLedgEntry."Description 2");
          JobJnlLine."External Document No." := FORMAT(ValueEntryNo);
          JobJnlLine.VALIDATE("Location Code", JobLedgEntry."Location Code");

          JobJnlLine.VALIDATE(Quantity, - JobLedgEntry.Quantity);
          JobJnlLine.VALIDATE("Unit Cost (LCY)", JobLedgEntry."Unit Cost (LCY)");

          JobJnlLine.VALIDATE("Unit of Measure Code", JobLedgEntry."Unit of Measure Code");
          JobJnlLine.VALIDATE("Dimension Set ID", JobLedgEntry."Dimension Set ID");
          JobJnlLine.VALIDATE("Shortcut Dimension 1 Code", JobLedgEntry."Global Dimension 1 Code");
          JobJnlLine.VALIDATE("Shortcut Dimension 2 Code", JobLedgEntry."Global Dimension 2 Code");
          JobJnlLine.VALIDATE("Unit Price", JobLedgEntry."Unit Price");
          JobJnlLine.VALIDATE("Ledger Entry Type", JobLedgEntry."Ledger Entry Type");
          JobJnlLine.VALIDATE("Ledger Entry No.", JobLedgEntry."Ledger Entry No.");

          //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.Begin
          //JobJnlLine.VALIDATE("Piecework Code", JobLedgEntry."Piecework No.");
          IF Job."Mandatory Allocation Term By" = Job."Mandatory Allocation Term By"::"Only Per Piecework" THEN
            JobJnlLine.VALIDATE("Piecework Code", JobLedgEntry."Piecework No.");
          //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.End

          JobJnlLine."Corrected Job. Ledg. Entry No." := JobLedgEntry."Entry No.";
          JobJnlLine."Job Posting Only" := TRUE;

          JobJnlLine."Related Item Entry No." := JobLedgEntry."Related Item Entry No.";
          JobJnlLine."Job Posting Only" := TRUE;
          JobJnlLine."Activation Entry" := TRUE;

          //JobJnlLine.INSERT(TRUE);

          CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post Line",JobJnlLine);

          LineNo += 10000;
          JobJnlLine.INIT;
          JobJnlLine.VALIDATE("Journal Template Name", JobJnlTemplateName);
          JobJnlLine.VALIDATE("Journal Batch Name", JobJnlBatchName);
          JobJnlLine."Line No." := LineNo;
          JobJnlLine.VALIDATE("Job No.", JobLedgEntry."Job No.");
          JobJnlLine.VALIDATE("Posting Date", NewPostingDate);
          JobJnlLine.VALIDATE("Document No.", NewDocumentNo);
          JobJnlLine.VALIDATE(Type, JobLedgEntry.Type);
          JobJnlLine.VALIDATE("No.", JobLedgEntry."No.");
          JobJnlLine.VALIDATE(Description, JobLedgEntry.Description);
          JobJnlLine.VALIDATE("Description 2", FORMAT(ValueEntryNo));
          JobJnlLine."External Document No." := FORMAT(ValueEntryNo);
          JobJnlLine.VALIDATE("Location Code", JobLedgEntry."Location Code");

          JobJnlLine.VALIDATE(Quantity, JobLedgEntry.Quantity);
          JobJnlLine.VALIDATE("Unit Cost (LCY)", NewUnitCostLCY);

          JobJnlLine.VALIDATE("Unit of Measure Code", JobLedgEntry."Unit of Measure Code");
          JobJnlLine.VALIDATE("Dimension Set ID", JobLedgEntry."Dimension Set ID");
          JobJnlLine.VALIDATE("Shortcut Dimension 1 Code", JobLedgEntry."Global Dimension 1 Code");
          JobJnlLine.VALIDATE("Shortcut Dimension 2 Code", JobLedgEntry."Global Dimension 2 Code");
          JobJnlLine.VALIDATE("Unit Price", JobLedgEntry."Unit Price");
          JobJnlLine.VALIDATE("Ledger Entry Type", JobLedgEntry."Ledger Entry Type");
          JobJnlLine.VALIDATE("Ledger Entry No.", JobLedgEntry."Ledger Entry No.");

          //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.Begin
          //JobJnlLine.VALIDATE("Piecework Code", JobLedgEntry."Piecework No.");
          IF Job."Mandatory Allocation Term By" = Job."Mandatory Allocation Term By"::"Only Per Piecework" THEN
            JobJnlLine.VALIDATE("Piecework Code", JobLedgEntry."Piecework No.");
          //28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto.End

          JobJnlLine."Job Posting Only" := TRUE;
          JobJnlLine."Related Item Entry No." := JobLedgEntry."Related Item Entry No.";
          JobJnlLine."Activation Entry" := TRUE;
          //JobJnlLine.INSERT(TRUE);

          CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post Line",JobJnlLine);

        UNTIL JobLedgEntry.NEXT(-1) = 0;

        //CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post Batch",JobJnlLine);
      END;
      //Q17138 16-05-2022 CPA.END
    END;

    [EventSubscriber(ObjectType::Codeunit, 1012, OnAfterRunCode, '', true, true)]
    LOCAL PROCEDURE Cod_JobJnlPostLineOnAfterRunCode(VAR JobJournalLine : Record 210;JobLedgEntryNo : Integer);
    VAR
      JobLedgEntry : Record 169;
    BEGIN
      //Q17138 16-05-2022 CPA.BEGIN

      //Si la l¡nea del diario trae el N§ de movimiento al que corrige marcamos ambos movimientos como correcci¢n
      IF (JobJournalLine."Corrected Job. Ledg. Entry No." <> 0) AND (JobLedgEntryNo <> 0) THEN BEGIN
        JobLedgEntry.GET(JobJournalLine."Corrected Job. Ledg. Entry No.");
        JobLedgEntry.Correction := TRUE;
        JobLedgEntry.MODIFY;

        JobLedgEntry.GET(JobLedgEntryNo);
        JobLedgEntry.Correction := TRUE;
        JobLedgEntry.MODIFY;
      END;
      //Q17138 16-05-2022 CPA.END
    END;

    PROCEDURE CalcPurchAveragePrice(pItemNo : Code[20]) : Decimal;
    VAR
      rlQuoBuildingSetup : Record 7207278;
      rlGeneralLedgerSetup : Record 98;
      rlItem : Record 27;
      rlItemLedgerEntry : Record 32;
      vCoste : Decimal;
      vCantidad : Decimal;
    BEGIN
      //Q17138 15-06-2022 EPV
      // Funci¢n que calcula el coste medio de compra (Precio medio ponderado) en un periodo determinado por par metro en QB Setup

      IF rlQuoBuildingSetup.GET THEN;
      IF rlGeneralLedgerSetup.GET THEN;
      vCoste:=0;
      IF rlItem.GET(pItemNo) THEN
        rlItem.CALCFIELDS("QB Main Location");

      CLEAR(rlItemLedgerEntry);
      rlItemLedgerEntry.SETRANGE("Item No.",pItemNo);
      rlItemLedgerEntry.SETRANGE("Location Code", rlItem."QB Main Location");
      rlItemLedgerEntry.SETFILTER("Posting Date", '%1..', CALCDATE(rlQuoBuildingSetup."Periodo Calc. Precio Compra", WORKDATE));
      rlItemLedgerEntry.SETRANGE("Document Type", rlItemLedgerEntry."Document Type"::"Purchase Receipt");
      IF rlItemLedgerEntry.FINDSET THEN
        BEGIN
          REPEAT
            rlItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
            vCoste+= (rlItemLedgerEntry."Cost Amount (Actual)" + rlItemLedgerEntry."Cost Amount (Expected)");
            vCantidad+= rlItemLedgerEntry.Quantity;
          UNTIL rlItemLedgerEntry.NEXT = 0;

          IF vCantidad <> 0 THEN
            EXIT(ROUND(vCoste/vCantidad, rlGeneralLedgerSetup."Unit-Amount Rounding Precision"))
          ELSE
            EXIT(0);

        END
      ELSE
        EXIT(0);
    END;

    /*BEGIN
/*{
      16-05-2022 CPA. Funcionalidad de productos prestados
      10/06/22 EPV Q17138 Productos prestados. Actualizaci¢n del coste real del movimiento de prestado.
      28/06/22 CPA Q17620 Al registrar facturas de compras imputando las l¡neas a partidas da error la revalorizaci¢n de movs. de proyecto
                            - Correcci¢n en OnAfterInsertValueEntry
                            - Correcci¢n en AdjustUnitCostJobLedgEntry
      05/07/22 CPA - Correcci¢n de un error asociado a no indicar la Unidad de Obra.
    }
END.*/
}










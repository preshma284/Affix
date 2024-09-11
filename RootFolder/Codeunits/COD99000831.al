Codeunit 51360 "Reservation Engine Mgt.1"
{
  
  
    Permissions=TableData 32=rm,
                TableData 337=rimd,
                TableData 99000849=rid;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='%1 must be greater than 0.',ESP='%1 debe ser mayor que 0.';
      Text001 : TextConst ENU='%1 must be less than 0.',ESP='%1 debe ser menor que 0.';
      Text002 : TextConst ENU='Use Cancel Reservation.',ESP='Utilice cancelar reserva.';
      Text003 : TextConst ENU='%1 can only be reduced.',ESP='%1 s�lo se puede reducir.';
      Text005 : TextConst ENU='Outbound,Inbound',ESP='Salida,Entrada';
      DummySalesLine : Record 37;
      DummyPurchLine : Record 39;
      DummyItemJnlLine : Record 83;
      DummyProdOrderLine : Record 5406;
      CalcAsmHeader : Record 900;
      CalcAsmLine : Record 901;
      Item : Record 27;
      TempSurplusEntry : Record 337 TEMPORARY;
      TempSortRec1 : Record 337 TEMPORARY;
      TempSortRec2 : Record 337 TEMPORARY;
      TempSortRec3 : Record 337 TEMPORARY;
      TempSortRec4 : Record 337 TEMPORARY;
      Text006 : TextConst ENU='Signing mismatch.',ESP='Acepta no coincidencia.';
      Text007 : TextConst ENU='Renaming reservation entries...',ESP='Renombrando movs. reserva...';
      DummyJobJnlLine : Record 210;
      ReservMgt : Codeunit 99000845;
      LostReservationQty : Decimal;
      Text008 : TextConst ENU='"You cannot state %1 or %2 on a demand when it is linked to a supply by %3 = %4."',ESP='"No puede establecer %1 ni %2 en una demanda cuando �sta est� vinculada a un suministro (%3 = %4)�."';
      ReservationsModified : Boolean;

    //[External]
    // PROCEDURE CancelReservation(ReservEntry : Record 337);
    // VAR
    //   ReservEntry3 : Record 337;
    // BEGIN
    //   ReservEntry.TESTFIELD("Reservation Status",ReservEntry."Reservation Status"::Reservation);
    //   ReservEntry.TESTFIELD("Disallow Cancellation",FALSE);

    //   ReservEntry3.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive);
    //   IF ReservEntry3.TrackingExists OR ReservEntry.TrackingExists THEN BEGIN
    //     ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
    //     ReservEntry.Binding := ReservEntry.Binding::" ";
    //     ReservEntry3."Reservation Status" := ReservEntry3."Reservation Status"::Surplus;
    //     ReservEntry3.Binding := ReservEntry3.Binding::" ";
    //     RevertDateToSourceDate(ReservEntry);
    //     ReservEntry.MODIFY;
    //     ReservEntry3.DELETE;
    //     ReservEntry3."Entry No." := 0;
    //     RevertDateToSourceDate(ReservEntry3);
    //     ReservEntry3.INSERT;
    //     TempSurplusEntry.DELETEALL;
    //     UpdateTempSurplusEntry(ReservEntry);
    //     UpdateTempSurplusEntry(ReservEntry3);
    //     UpdateOrderTracking(TempSurplusEntry);
    //   END ELSE
    //     CloseReservEntry(ReservEntry,TRUE,FALSE);
    // END;

    // LOCAL PROCEDURE RevertDateToSourceDate(VAR ReservEntry : Record 337);
    // VAR
    //   SalesLine : Record 37;
    //   PurchaseLine : Record 39;
    //   TransferLine : Record 5741;
    //   ServiceLine : Record 5902;
    //   ProdOrderLine : Record 5406;
    //   ProdOrderComponent : Record 5407;
    //   PlanningComponent : Record 99000829;
    //   ItemLedgerEntry : Record 32;
    // BEGIN
    //   WITH ReservEntry DO
    //     CASE "Source Type" OF
    //       DATABASE::"Sales Line":
    //         BEGIN
    //           SalesLine.GET("Source Subtype","Source ID","Source Ref. No.");
    //           IF Positive THEN
    //             ChangeDateFieldOnResEntry(ReservEntry,"Expected Receipt Date",0D)
    //           ELSE
    //             ChangeDateFieldOnResEntry(ReservEntry,0D,SalesLine."Shipment Date");
    //         END;
    //       DATABASE::"Purchase Line":
    //         BEGIN
    //           PurchaseLine.GET("Source Subtype","Source ID","Source Ref. No.");
    //           IF Positive THEN
    //             ChangeDateFieldOnResEntry(ReservEntry,PurchaseLine."Expected Receipt Date",0D)
    //           ELSE
    //             ChangeDateFieldOnResEntry(ReservEntry,0D,"Shipment Date");
    //         END;
    //       DATABASE::"Planning Component":
    //         BEGIN
    //           PlanningComponent.GET("Source ID","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
    //           ChangeDateFieldOnResEntry(ReservEntry,0D,PlanningComponent."Due Date")
    //         END;
    //       DATABASE::"Item Ledger Entry":
    //         BEGIN
    //           ItemLedgerEntry.GET("Source Ref. No.");
    //           ChangeDateFieldOnResEntry(ReservEntry,ItemLedgerEntry."Posting Date",0D);
    //         END;
    //       DATABASE::"Prod. Order Line":
    //         BEGIN
    //           ProdOrderLine.GET("Source Subtype","Source ID","Source Prod. Order Line");
    //           ChangeDateFieldOnResEntry(ReservEntry,ProdOrderLine."Due Date",0D);
    //         END;
    //       DATABASE::"Prod. Order Component":
    //         BEGIN
    //           ProdOrderComponent.GET("Source Subtype","Source ID","Source Prod. Order Line","Source Ref. No.");
    //           ChangeDateFieldOnResEntry(ReservEntry,0D,ProdOrderComponent."Due Date");
    //           EXIT;
    //         END;
    //       DATABASE::"Transfer Line":
    //         BEGIN
    //           TransferLine.GET("Source ID","Source Ref. No.");
    //           IF Positive THEN
    //             ChangeDateFieldOnResEntry(ReservEntry,TransferLine."Receipt Date",0D)
    //           ELSE
    //             ChangeDateFieldOnResEntry(ReservEntry,0D,TransferLine."Shipment Date");
    //         END;
    //       DATABASE::"Service Line":
    //         BEGIN
    //           ServiceLine.GET("Source Subtype","Source ID","Source Ref. No.");
    //           ChangeDateFieldOnResEntry(ReservEntry,0D,ServiceLine."Needed by Date");
    //         END;
    //     END;
    // END;

    // LOCAL PROCEDURE ChangeDateFieldOnResEntry(VAR ReservEntry : Record 337;ExpectedReceiptDate : Date;ShipmentDate : Date);
    // BEGIN
    //   ReservEntry."Expected Receipt Date" := ExpectedReceiptDate;
    //   ReservEntry."Shipment Date" := ShipmentDate;
    // END;

    //[External]
    PROCEDURE CloseReservEntry(ReservEntry : Record 337;ReTrack : Boolean;DeleteAll : Boolean);
    VAR
      ReservEntry2 : Record 337;
      SurplusReservEntry : Record 337;
      DummyReservEntry : Record 337;
      TotalQty : Decimal;
      AvailabilityDate : Date;
    BEGIN
      ReservEntry.DELETE;
      IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Prospect THEN
        EXIT;

      ModifyActionMessage(ReservEntry);

      IF ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Surplus THEN BEGIN
        GetItem(ReservEntry."Item No.");
        ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive);
        IF (Item."Order Tracking Policy" = Item."Order Tracking Policy"::None) AND
           (NOT TransferLineWithItemTracking(ReservEntry2)) AND
           (((ReservEntry.Binding = ReservEntry.Binding::"Order-to-Order") AND ReservEntry2.Positive ) OR
            (ReservEntry2."Source Type" = DATABASE::"Item Ledger Entry") OR NOT ReservEntry2.TrackingExists)
        THEN
          ReservEntry2.DELETE
        ELSE BEGIN
          ReservEntry2."Reservation Status" := ReservEntry2."Reservation Status"::Surplus;

          IF ReservEntry2.Positive THEN BEGIN
            AvailabilityDate := ReservEntry2."Expected Receipt Date";
            ReservEntry2."Shipment Date" := 0D
          END ELSE BEGIN
            AvailabilityDate := ReservEntry2."Shipment Date";
            ReservEntry2."Expected Receipt Date" := 0D;
          END;
          ReservEntry2.MODIFY;
          ReservMgt.SetSkipUntrackedSurplus(TRUE);
          ReservEntry2."Quantity (Base)" :=
            ReservMgt.MatchSurplus(ReservEntry2,SurplusReservEntry,ReservEntry2."Quantity (Base)",NOT ReservEntry2.Positive,
              AvailabilityDate,Item."Order Tracking Policy");
          IF ReservEntry2."Quantity (Base)" = 0 THEN BEGIN
            ReservEntry2.DELETE(TRUE);
          END ELSE BEGIN
            ReservEntry2.VALIDATE("Quantity (Base)");
            ReservEntry2.VALIDATE(Binding,ReservEntry2.Binding::" ");
            IF Item."Order Tracking Policy".AsInteger() > Item."Order Tracking Policy"::None.AsInteger() THEN
              ReservEntry2."Untracked Surplus" := ReservEntry2.IsResidualSurplus;
            ReservEntry2.MODIFY;

            IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN BEGIN
              ModifyActionMessageDating(ReservEntry2);
              IF DeleteAll THEN
                ReservMgt.IssueActionMessage(ReservEntry2,FALSE,ReservEntry)
              ELSE
                ReservMgt.IssueActionMessage(ReservEntry2,FALSE,DummyReservEntry);
            END;
          END;
        END;
      END;

      IF ReTrack THEN BEGIN
        TotalQty := ReservMgt.SourceQuantity(ReservEntry,TRUE);
        ReservMgt.AutoTrack(TotalQty);
      END;
    END;

    //[External]
    // PROCEDURE CloseSurplusTrackingEntry(ReservEntry : Record 337);
    // VAR
    //   ReservEntry2 : Record 337;
    // BEGIN
    //   ReservEntry.DELETE;
    //   GetItem(ReservEntry."Item No.");
    //   IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Prospect THEN
    //     EXIT;

    //   ModifyActionMessage(ReservEntry);
    //   IF ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Surplus THEN BEGIN
    //     ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive);
    //     IF NOT TransferLineWithItemTracking(ReservEntry2) AND
    //        ((ReservEntry2."Source Type" = DATABASE::"Item Ledger Entry") OR NOT ReservEntry2.TrackingExists)
    //     THEN
    //       ReservEntry2.DELETE
    //     ELSE BEGIN
    //       ReservEntry2."Reservation Status" := ReservEntry2."Reservation Status"::Surplus;
    //       ReservEntry2.MODIFY;
    //     END;
    //   END;
    // END;

    //[External]
    // PROCEDURE ModifyReservEntry(ReservEntry : Record 337;NewQuantity : Decimal;NewDescription : Text[50];ModifyReserved : Boolean);
    // VAR
    //   TotalQty : Decimal;
    // BEGIN
    //   ReservEntry.TESTFIELD("Reservation Status",ReservEntry."Reservation Status"::Reservation);
    //   IF NewQuantity * ReservEntry."Quantity (Base)" < 0 THEN
    //     IF NewQuantity < 0 THEN
    //       ERROR(Text000,ReservEntry.FIELDCAPTION("Quantity (Base)"))
    //     ELSE
    //       ERROR(Text001,ReservEntry.FIELDCAPTION("Quantity (Base)"));
    //   IF NewQuantity = 0 THEN
    //     ERROR(Text002);
    //   IF ABS(NewQuantity) > ABS(ReservEntry."Quantity (Base)") THEN
    //     ERROR(Text003,ReservEntry.FIELDCAPTION("Quantity (Base)"));

    //   IF ModifyReserved THEN BEGIN
    //     IF ReservEntry."Item No." <> Item."No." THEN
    //       GetItem(ReservEntry."Item No.");

    //     ReservEntry.GET(ReservEntry."Entry No.",ReservEntry.Positive); // Get existing entry
    //     ReservEntry.VALIDATE("Quantity (Base)",NewQuantity);
    //     ReservEntry.Description := NewDescription;
    //     ReservEntry."Changed By" := USERID;
    //     ReservEntry.MODIFY;
    //     IF Item."Order Tracking Policy" > Item."Order Tracking Policy"::None THEN BEGIN
    //       TotalQty := ReservMgt.SourceQuantity(ReservEntry,TRUE);
    //       ReservMgt.AutoTrack(TotalQty);
    //     END;

    //     IF ReservEntry.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive) THEN BEGIN // Get related entry
    //       ReservEntry.VALIDATE("Quantity (Base)",-NewQuantity);
    //       ReservEntry.Description := NewDescription;
    //       ReservEntry."Changed By" := USERID;
    //       ReservEntry.MODIFY;
    //       IF Item."Order Tracking Policy" > Item."Order Tracking Policy"::None THEN BEGIN
    //         TotalQty := ReservMgt.SourceQuantity(ReservEntry,TRUE);
    //         ReservMgt.AutoTrack(TotalQty);
    //       END;
    //     END;
    //   END;
    // END;

    //[External]
    // PROCEDURE CreateForText(ReservEntry : Record 337) : Text[80];
    // BEGIN
    //   IF ReservEntry.GET(ReservEntry."Entry No.",FALSE) THEN
    //     EXIT(CreateText(ReservEntry));

    //   EXIT('');
    // END;

    //[External]
    // PROCEDURE CreateFromText(ReservEntry : Record 337) : Text[80];
    // BEGIN
    //   IF ReservEntry.GET(ReservEntry."Entry No.",TRUE) THEN
    //     EXIT(CreateText(ReservEntry));

    //   EXIT('');
    // END;

    //[External]
    // PROCEDURE CreateText(ReservEntry : Record 337) SourceTypeDesc : Text[80];
    // VAR
    //   SourceType : Option " ","Sales","Requisition Line","Purchase","Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component","Transfer","Service","Job Journal","Job","Assembly Header","Assembly Line";
    //   SourceTypeText : TextConst ENU='Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service,Job Journal,Job,Assembly Header,Assembly Line',ESP='Ventas,L�n. repos.,Compras,Diario prod.,Diario L.M.,Mov. prod.,L�n. orden producc.,Comp. orden producc.,Planif. l�n.,Planif. componente,Transfer.,Servicio,Diario proyecto,Proyecto,Encabezado ensamblado,L�nea ensamblado';
    // BEGIN
    //   WITH ReservEntry DO BEGIN
    //     CASE "Source Type" OF
    //       DATABASE::"Sales Line":
    //         BEGIN
    //           SourceType := SourceType::Sales;
    //           DummySalesLine."Document Type" := "Source Subtype";
    //           EXIT(STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               DummySalesLine."Document Type","Source ID"));
    //         END;
    //       DATABASE::"Purchase Line":
    //         BEGIN
    //           SourceType := SourceType::Purchase;
    //           DummyPurchLine."Document Type" := "Source Subtype";
    //           EXIT(STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               DummyPurchLine."Document Type","Source ID"));
    //         END;
    //       DATABASE::"Requisition Line":
    //         BEGIN
    //           SourceType := SourceType::"Requisition Line";
    //           EXIT(STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               "Source ID","Source Batch Name"));
    //         END;
    //       DATABASE::"Planning Component":
    //         BEGIN
    //           SourceType := SourceType::"Planning Component";
    //           EXIT(STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               "Source ID","Source Batch Name"));
    //         END;
    //       DATABASE::"Item Journal Line":
    //         BEGIN
    //           SourceType := SourceType::"Item Journal";
    //           DummyItemJnlLine."Entry Type" := "Source Subtype";
    //           EXIT(STRSUBSTNO('%1 %2 %3 %4',SELECTSTR(SourceType,SourceTypeText),
    //               DummyItemJnlLine."Entry Type","Source ID","Source Batch Name"));
    //         END;
    //       DATABASE::"Job Journal Line":
    //         BEGIN
    //           SourceType := SourceType::"Job Journal";
    //           EXIT(STRSUBSTNO('%1 %2 %3 %4',SELECTSTR(SourceType,SourceTypeText),
    //               DummyJobJnlLine."Entry Type","Source ID","Source Batch Name"));
    //         END;
    //       DATABASE::"Item Ledger Entry":
    //         BEGIN
    //           SourceType := SourceType::"Item Ledger Entry";
    //           EXIT(STRSUBSTNO('%1 %2',SELECTSTR(SourceType,SourceTypeText),"Source Ref. No."));
    //         END;
    //       DATABASE::"Prod. Order Line":
    //         BEGIN
    //           SourceType := SourceType::"Prod. Order Line";
    //           DummyProdOrderLine.Status := "Source Subtype";
    //           EXIT(STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               DummyProdOrderLine.Status,"Source ID"));
    //         END;
    //       DATABASE::"Prod. Order Component":
    //         BEGIN
    //           SourceType := SourceType::"Prod. Order Component";
    //           DummyProdOrderLine.Status := "Source Subtype";
    //           EXIT(STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               DummyProdOrderLine.Status,"Source ID"));
    //         END;
    //       DATABASE::"Transfer Line":
    //         BEGIN
    //           SourceType := SourceType::Transfer;
    //           EXIT(STRSUBSTNO('%1 %2, %3',SELECTSTR(SourceType,SourceTypeText),
    //               "Source ID",SELECTSTR("Source Subtype" + 1,Text005)));
    //         END;
    //       DATABASE::"Service Line":
    //         BEGIN
    //           SourceType := SourceType::Service;
    //           EXIT(STRSUBSTNO('%1 %2',SELECTSTR(SourceType,SourceTypeText),"Source ID"));
    //         END;
    //       DATABASE::"Job Planning Line":
    //         BEGIN
    //           SourceType := SourceType::Job;
    //           EXIT(STRSUBSTNO('%1 %2',SELECTSTR(SourceType,SourceTypeText),"Source ID"));
    //         END;
    //       DATABASE::"Assembly Header":
    //         BEGIN
    //           CalcAsmHeader.INIT;
    //           SourceType := SourceType::"Assembly Header";
    //           CalcAsmHeader."Document Type" := "Source Subtype";
    //           EXIT(
    //             STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               CalcAsmHeader."Document Type","Source ID"));
    //         END;
    //       DATABASE::"Assembly Line":
    //         BEGIN
    //           CalcAsmLine.INIT;
    //           SourceType := SourceType::"Assembly Line";
    //           CalcAsmLine."Document Type" := "Source Subtype";
    //           EXIT(
    //             STRSUBSTNO('%1 %2 %3',SELECTSTR(SourceType,SourceTypeText),
    //               CalcAsmLine."Document Type","Source ID"));
    //         END;
    //     END;

    //     SourceTypeDesc := '';
    //     OnAfterCreateText(ReservEntry,SourceTypeDesc);
    //     EXIT(SourceTypeDesc);
    //   END;
    // END;

    //[External]
    // PROCEDURE ModifyShipmentDate(VAR ReservEntry : Record 337;NewShipmentDate : Date);
    // VAR
    //   ReservEntry2 : Record 337;
    // BEGIN
    //   ReservEntry2 := ReservEntry;
    //   ReservEntry2."Shipment Date" := NewShipmentDate;
    //   ReservEntry2."Changed By" := USERID;
    //   ReservEntry2.MODIFY;

    //   IF ReservEntry2.GET(ReservEntry2."Entry No.",NOT ReservEntry2.Positive) THEN BEGIN // Get related entry
    //     ReservEntry2."Shipment Date" := NewShipmentDate;
    //     ReservEntry2."Changed By" := USERID;
    //     ReservEntry2.MODIFY;

    //     ModifyActionMessageDating(ReservEntry2);
    //   END;

    //   OnAfterModifyShipmentDate(ReservEntry2,ReservEntry);
    // END;

    LOCAL PROCEDURE ModifyActionMessage(ReservEntry : Record 337);
    BEGIN
      GetItem(ReservEntry."Item No.");
      IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Surplus THEN BEGIN
        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
          ReservMgt.ModifyActionMessage(ReservEntry."Entry No.",0,TRUE); // Delete related action messages
      END ELSE
        IF ReservEntry.Binding = ReservEntry.Binding::"Order-to-Order" THEN
          IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
            ReservMgt.ModifyActionMessage(ReservEntry."Entry No.",0,TRUE); // Delete related action messages
    END;

    //[External]
    // PROCEDURE ModifyExpectedReceiptDate(VAR ReservEntry : Record 337;NewExpectedReceiptDate : Date);
    // VAR
    //   ReservEntry2 : Record 337;
    // BEGIN
    //   ReservEntry2 := ReservEntry;
    //   ReservEntry2."Expected Receipt Date" := NewExpectedReceiptDate;
    //   ReservEntry2."Changed By" := USERID;
    //   ReservEntry2.MODIFY;

    //   ModifyActionMessageDating(ReservEntry2);

    //   IF ReservEntry2.GET(ReservEntry2."Entry No.",NOT ReservEntry2.Positive) THEN BEGIN // Get related entry
    //     ReservEntry2."Expected Receipt Date" := NewExpectedReceiptDate;
    //     ReservEntry2."Changed By" := USERID;
    //     ReservEntry2.MODIFY;
    //   END;
    // END;

    //[External]
    PROCEDURE InitFilterAndSortingFor(VAR FilterReservEntry : Record 337;SetFilters : Boolean);
    BEGIN
      FilterReservEntry.RESET;
      FilterReservEntry.SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Reservation Status");
      IF SetFilters THEN
        FilterReservEntry.SETRANGE("Reservation Status",FilterReservEntry."Reservation Status"::Reservation);
    END;

    //[External]
    PROCEDURE InitFilterAndSortingLookupFor(VAR FilterReservEntry : Record 337;SetFilters : Boolean);
    BEGIN
      FilterReservEntry.RESET;
      FilterReservEntry.SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Reservation Status",
        "Shipment Date","Expected Receipt Date");
      IF SetFilters THEN
        FilterReservEntry.SETRANGE("Reservation Status",FilterReservEntry."Reservation Status"::Reservation);
    END;

    //[External]
    PROCEDURE ModifyUnitOfMeasure(VAR ReservEntry : Record 337;NewQtyPerUnitOfMeasure : Decimal);
    VAR
      ReservEntry2 : Record 337;
    BEGIN
      ReservEntry.TESTFIELD("Source Type");
      ReservEntry2.RESET;
      ReservEntry2.SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Reservation Status",
        "Shipment Date","Expected Receipt Date");

      ReservEntry2.SETRANGE("Source ID",ReservEntry."Source ID");
      ReservEntry2.SETRANGE("Source Ref. No.",ReservEntry."Source Ref. No.");
      ReservEntry2.SETRANGE("Source Type",ReservEntry."Source Type");
      ReservEntry2.SETRANGE("Source Subtype",ReservEntry."Source Subtype");
      ReservEntry2.SETRANGE("Source Batch Name",ReservEntry."Source Batch Name");
      ReservEntry2.SETRANGE("Source Prod. Order Line",ReservEntry."Source Prod. Order Line");

      IF ReservEntry2.FINDSET THEN
        IF NewQtyPerUnitOfMeasure <> ReservEntry2."Qty. per Unit of Measure" THEN
          REPEAT
            ReservEntry2.VALIDATE("Qty. per Unit of Measure",NewQtyPerUnitOfMeasure);
            ReservEntry2.MODIFY;
          UNTIL ReservEntry2.NEXT = 0;
    END;

    //[External]
    PROCEDURE ModifyActionMessageDating(VAR ReservEntry : Record 337);
    VAR
      ReservEntry2 : Record 337;
      ActionMessageEntry : Record 99000849;
      ManufacturingSetup : Record 99000765;
      FirstDate : Date;
      NextEntryNo : Integer;
      DateFormula : DateFormula;
    BEGIN
      IF NOT (ReservEntry."Source Type" IN [DATABASE::"Prod. Order Line",
                                            DATABASE::"Purchase Line"])
      THEN
        EXIT;

      IF NOT ReservEntry.Positive THEN
        EXIT;

      GetItem(ReservEntry."Item No.");
      IF Item."Order Tracking Policy" <> Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
        EXIT;

      ActionMessageEntry.SETCURRENTKEY(
        "Source Type","Source Subtype","Source ID","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
      ActionMessageEntry.SETRANGE("Source Type",ReservEntry."Source Type");
      ActionMessageEntry.SETRANGE("Source Subtype",ReservEntry."Source Subtype");
      ActionMessageEntry.SETRANGE("Source ID",ReservEntry."Source ID");
      ActionMessageEntry.SETRANGE("Source Batch Name",ReservEntry."Source Batch Name");
      ActionMessageEntry.SETRANGE("Source Prod. Order Line",ReservEntry."Source Prod. Order Line");
      ActionMessageEntry.SETRANGE("Source Ref. No.",ReservEntry."Source Ref. No.");
      ActionMessageEntry.SETRANGE(Quantity,0);

      ReservEntry2.COPY(ReservEntry);
      ReservEntry2.SetPointerFilter;
      ReservEntry2.SETRANGE(
        "Reservation Status",ReservEntry2."Reservation Status"::Reservation,ReservEntry2."Reservation Status"::Tracking);
      FirstDate := ReservMgt.FindDate(ReservEntry2,0,TRUE);

      ManufacturingSetup.GET;
      IF (FORMAT(ManufacturingSetup."Default Dampener Period") = '') OR
         ((ReservEntry.Binding = ReservEntry.Binding::"Order-to-Order") AND
          (ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Reservation))
      THEN
        EVALUATE(ManufacturingSetup."Default Dampener Period",'<0D>');

      ActionMessageEntry.DELETEALL;

      IF FirstDate = 0D THEN
        EXIT;

      EVALUATE(DateFormula,STRSUBSTNO('%1%2','-',FORMAT(ManufacturingSetup."Default Dampener Period")));
      IF CALCDATE(DateFormula,FirstDate) <= ReservEntry."Expected Receipt Date" THEN
        EXIT;

      IF ReservEntry."Planning Flexibility" = ReservEntry."Planning Flexibility"::None THEN
        EXIT;

      ActionMessageEntry.RESET;
      IF NOT ActionMessageEntry.FINDLAST THEN
        NextEntryNo := 1
      ELSE
        NextEntryNo := ActionMessageEntry."Entry No." + 1;
      ActionMessageEntry.INIT;
      ActionMessageEntry.TransferFromReservEntry(ReservEntry);
      ActionMessageEntry."Entry No." := NextEntryNo;
      ActionMessageEntry.Type := ActionMessageEntry.Type::Reschedule;
      ActionMessageEntry."New Date" := FirstDate;
      ActionMessageEntry."Reservation Entry" := ReservEntry2."Entry No.";
      WHILE NOT ActionMessageEntry.INSERT DO
        ActionMessageEntry."Entry No." += 1;
    END;

    //[External]
    // PROCEDURE AddItemTrackingToTempRecSet(VAR TempReservEntry : Record 337 TEMPORARY;VAR TrackingSpecification : Record 336;QtyToAdd : Decimal;VAR QtyToAddAsBlank : Decimal;SNSpecific : Boolean;LotSpecific : Boolean) : Decimal;
    // VAR
    //   ReservStatus : Integer;
    // BEGIN
    //   WITH TempReservEntry DO BEGIN
    //     LostReservationQty := 0; // Late Binding
    //     ReservationsModified := FALSE;
    //     SETCURRENTKEY(
    //       "Source ID","Source Ref. No.","Source Type","Source Subtype",
    //       "Source Batch Name","Source Prod. Order Line","Reservation Status");

    //     // Process entry in descending order against field Reservation Status
    //     FOR ReservStatus := "Reservation Status"::Prospect DOWNTO "Reservation Status"::Reservation DO
    //       ModifyItemTrkgByReservStatus(
    //         TempReservEntry,TrackingSpecification,ReservStatus,
    //         QtyToAdd,QtyToAddAsBlank,SNSpecific,LotSpecific);

    //     EXIT(QtyToAdd);
    //   END;
    // END;

    LOCAL PROCEDURE ModifyItemTrkgByReservStatus(VAR TempReservEntry : Record 337 TEMPORARY;VAR TrackingSpecification : Record 336;ReservStatus : Option "Reservation","Tracking","Surplus","Prospect";VAR QtyToAdd : Decimal;VAR QtyToAddAsBlank : Decimal;SNSpecific : Boolean;LotSpecific : Boolean);
    BEGIN
      IF QtyToAdd = 0 THEN
        EXIT;

      TempReservEntry.SETRANGE("Reservation Status",ReservStatus);
      IF TempReservEntry.FINDSET THEN
        REPEAT
          QtyToAdd :=
            ModifyItemTrackingOnTempRec(
              TempReservEntry,TrackingSpecification,QtyToAdd,
              QtyToAddAsBlank,0,SNSpecific,LotSpecific,FALSE,FALSE);
        UNTIL (TempReservEntry.NEXT = 0) OR (QtyToAdd = 0);
    END;

    LOCAL PROCEDURE ModifyItemTrackingOnTempRec(VAR TempReservEntry : Record 337 TEMPORARY;VAR TrackingSpecification : Record 336;QtyToAdd : Decimal;VAR QtyToAddAsBlank : Decimal;LastEntryNo : Integer;SNSpecific : Boolean;LotSpecific : Boolean;EntryMismatch : Boolean;CalledRecursively : Boolean) : Decimal;
    VAR
      TempReservEntryCopy : Record 337 TEMPORARY;
      ReservEntry1 : Record 337;
      ReservEntry2 : Record 337;
      TempReservEntry2 : Record 337 TEMPORARY;
      TrackingSpecification2 : Record 336;
      QtyToAdd2 : Decimal;
      ModifyPartnerRec : Boolean;
    BEGIN
      IF NOT CalledRecursively THEN BEGIN
        TempReservEntryCopy := TempReservEntry;

        IF TempReservEntry."Reservation Status" IN
           [TempReservEntry."Reservation Status"::Reservation,
            TempReservEntry."Reservation Status"::Tracking]
        THEN BEGIN
          ModifyPartnerRec := TRUE;
          ReservEntry1 := TempReservEntry;
          ReservEntry1.GET(ReservEntry1."Entry No.",NOT ReservEntry1.Positive);
          TempReservEntry2 := ReservEntry1;
          TrackingSpecification2 := TrackingSpecification;

          SetItemTracking2(TempReservEntry2,TrackingSpecification2);

          EntryMismatch :=
            CheckTrackingNoMismatch(TempReservEntry,TrackingSpecification,TrackingSpecification2,SNSpecific,LotSpecific);
          QtyToAdd2 := -QtyToAdd;
        END;
      END;

      ReservEntry1 := TempReservEntry;
      ReservEntry1.GET(TempReservEntry."Entry No.",TempReservEntry.Positive);
      IF ABS(TempReservEntry."Quantity (Base)") > ABS(QtyToAdd) THEN BEGIN // Split entry
        ReservEntry2 := TempReservEntry;
        ReservEntry2.VALIDATE("Quantity (Base)",QtyToAdd);
        ReservEntry2."Lot No." := TrackingSpecification."Lot No.";
        ReservEntry2."Serial No." := TrackingSpecification."Serial No.";
        ReservEntry2."Warranty Date" := TrackingSpecification."Warranty Date";
        ReservEntry2."Expiration Date" := TrackingSpecification."Expiration Date";
        ReservEntry2."Entry No." := LastEntryNo;
        OnBeforeUpdateItemTracking(ReservEntry2,TrackingSpecification);
        ReservEntry2.UpdateItemTracking;
        IF EntryMismatch THEN BEGIN
          IF NOT CalledRecursively THEN
            SaveLostReservQty(ReservEntry2); // Late Binding
          ReservEntry2."Reservation Status" := ReservEntry2."Reservation Status"::Surplus;
          IF ReservEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN BEGIN
            GetItem(ReservEntry2."Item No.");
            IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
              ReservEntry2."Quantity (Base)" := 0;
          END;
        END ELSE
          IF NOT CalledRecursively THEN
            ReservationsModified := ReservEntry2."Reservation Status" = ReservEntry2."Reservation Status"::Reservation;
        IF NOT CalledRecursively THEN
          VerifySurplusRecord(ReservEntry2,QtyToAddAsBlank);
        IF ReservEntry2."Quantity (Base)" <> 0 THEN BEGIN
          ReservEntry2.INSERT;
          LastEntryNo := ReservEntry2."Entry No.";
        END;

        IF EntryMismatch THEN
          LastEntryNo := 0;

        ReservEntry1.VALIDATE("Quantity (Base)",ReservEntry1."Quantity (Base)" - QtyToAdd);
        ReservEntry1.MODIFY;
        TempReservEntry := ReservEntry1;
        IF NOT CalledRecursively THEN BEGIN
          TempReservEntry := ReservEntry2;
          IF TempReservEntry."Quantity (Base)" <> 0 THEN
            TempReservEntry.INSERT;
          TempReservEntry := ReservEntry1;
          TempReservEntry.MODIFY;
        END ELSE
          TempReservEntry := ReservEntry1;
        QtyToAdd := 0;
        UpdateTempSurplusEntry(ReservEntry1);
        UpdateTempSurplusEntry(ReservEntry2);
      END ELSE BEGIN // Modify entry directly
        ReservEntry1."Qty. to Handle (Base)" := ReservEntry1."Quantity (Base)";
        ReservEntry1."Qty. to Invoice (Base)" := ReservEntry1."Quantity (Base)";
        ReservEntry1."Lot No." := TrackingSpecification."Lot No.";
        ReservEntry1."Serial No." := TrackingSpecification."Serial No.";
        ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
        ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
        IF ReservEntry1.Positive THEN
          ReservEntry1."Appl.-from Item Entry" := TrackingSpecification."Appl.-from Item Entry"
        ELSE
          ReservEntry1."Appl.-to Item Entry" := TrackingSpecification."Appl.-to Item Entry";
        OnBeforeUpdateItemTracking(ReservEntry1,TrackingSpecification);
        ReservEntry1.UpdateItemTracking;
        IF EntryMismatch THEN BEGIN
          IF NOT CalledRecursively THEN
            SaveLostReservQty(ReservEntry1); // Late Binding
          GetItem(ReservEntry1."Item No.");
          IF (ReservEntry1."Source Type" = DATABASE::"Item Ledger Entry") AND
             (Item."Order Tracking Policy" = Item."Order Tracking Policy"::None)
          THEN BEGIN
            ReservEntry1.DELETE;
          END ELSE BEGIN
            ReservEntry1."Reservation Status" := ReservEntry1."Reservation Status"::Surplus;
            IF CalledRecursively THEN BEGIN
              ReservEntry1.DELETE;
              ReservEntry1."Entry No." := LastEntryNo;
              ReservEntry1.INSERT;
              LastEntryNo := ReservEntry1."Entry No.";
            END ELSE
              ReservEntry1.MODIFY;
          END;
        END ELSE BEGIN
          IF NOT CalledRecursively THEN
            ReservationsModified := ReservEntry2."Reservation Status" = ReservEntry2."Reservation Status"::Reservation;
          ReservEntry1.MODIFY;
        END;
        QtyToAdd -= ReservEntry1."Quantity (Base)";
        IF NOT CalledRecursively THEN BEGIN
          IF VerifySurplusRecord(ReservEntry1,QtyToAddAsBlank) THEN
            ReservEntry1.MODIFY;
          IF ReservEntry1."Quantity (Base)" = 0 THEN BEGIN
            TempReservEntry := ReservEntry1;
            TempReservEntry.DELETE;
            ReservEntry1.DELETE;
            ReservMgt.ModifyActionMessage(ReservEntry1."Entry No.",0,TRUE); // Delete related Action Msg.
          END ELSE BEGIN
            TempReservEntry := ReservEntry1;
            TempReservEntry.MODIFY;
          END;
        END;
        UpdateTempSurplusEntry(ReservEntry1);
      END;

      IF ModifyPartnerRec THEN
        ModifyItemTrackingOnTempRec(TempReservEntry2,TrackingSpecification2,
          QtyToAdd2,QtyToAddAsBlank,LastEntryNo,SNSpecific,LotSpecific,EntryMismatch,TRUE);

      TempSurplusEntry.RESET;
      IF TempSurplusEntry.FINDSET THEN BEGIN
        GetItem(TempSurplusEntry."Item No.");
        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
          REPEAT
            UpdateActionMessages(TempSurplusEntry);
          UNTIL TempSurplusEntry.NEXT = 0;
      END;

      IF NOT CalledRecursively THEN
        TempReservEntry := TempReservEntryCopy;

      EXIT(QtyToAdd);
    END;

    LOCAL PROCEDURE VerifySurplusRecord(VAR ReservEntry : Record 337;VAR QtyToAddAsBlank : Decimal) Modified : Boolean;
    BEGIN
      IF ReservEntry.TrackingExists THEN
        EXIT;
      IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Prospect THEN BEGIN
        ReservEntry.VALIDATE("Quantity (Base)",0);
        EXIT(TRUE);
      END;
      IF ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Surplus THEN
        EXIT;
      IF QtyToAddAsBlank * ReservEntry."Quantity (Base)" < 0 THEN
        ERROR(Text006);
      IF ABS(QtyToAddAsBlank) < ABS(ReservEntry."Quantity (Base)") THEN BEGIN
        ReservEntry.VALIDATE("Quantity (Base)",QtyToAddAsBlank);
        Modified := TRUE;
      END;
      QtyToAddAsBlank -= ReservEntry."Quantity (Base)";
      EXIT(Modified);
    END;

    LOCAL PROCEDURE UpdateTempSurplusEntry(VAR ReservEntry : Record 337);
    BEGIN
      IF ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Surplus THEN
        EXIT;
      IF ReservEntry."Quantity (Base)" = 0 THEN
        EXIT;
      TempSurplusEntry := ReservEntry;
      IF NOT TempSurplusEntry.INSERT THEN
        TempSurplusEntry.MODIFY;
    END;

    //[External]
    // PROCEDURE CollectAffectedSurplusEntries(VAR TempReservEntry : Record 337 TEMPORARY) : Boolean;
    // BEGIN
    //   TempSurplusEntry.RESET;
    //   TempReservEntry.RESET;

    //   IF NOT TempSurplusEntry.FINDSET THEN
    //     EXIT(FALSE);

    //   REPEAT
    //     TempReservEntry := TempSurplusEntry;
    //     TempReservEntry.INSERT;
    //   UNTIL TempSurplusEntry.NEXT = 0;

    //   TempSurplusEntry.DELETEALL;

    //   EXIT(TRUE);
    // END;

    //[External]
    // PROCEDURE UpdateOrderTracking(VAR TempReservEntry : Record 337 TEMPORARY);
    // VAR
    //   ReservEntry : Record 337;
    //   SurplusEntry : Record 337;
    //   ReservationMgt : Codeunit 99000845;
    //   AvailabilityDate : Date;
    //   FirstLoop : Boolean;
    // BEGIN
    //   FirstLoop := TRUE;

    //   WHILE TempReservEntry.FINDSET DO BEGIN
    //     IF FirstLoop THEN BEGIN
    //       GetItem(TempReservEntry."Item No.");
    //       IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN BEGIN
    //         REPEAT
    //           IF (TempReservEntry."Source Type" = DATABASE::"Item Ledger Entry") OR NOT TempReservEntry.TrackingExists THEN BEGIN
    //             ReservEntry := TempReservEntry;
    //             ReservEntry.DELETE;
    //           END;
    //         UNTIL TempReservEntry.NEXT = 0;
    //         EXIT;
    //       END;
    //       ReservationMgt.SetSkipUntrackedSurplus(TRUE);
    //       FirstLoop := FALSE;
    //     END;
    //     CLEAR(SurplusEntry);
    //     SurplusEntry.TESTFIELD("Entry No.",0);
    //     TempReservEntry.TESTFIELD("Item No.",Item."No.");
    //     IF ReservEntry.GET(TempReservEntry."Entry No.",TempReservEntry.Positive) THEN
    //       IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Surplus THEN
    //         ReservEntry."Quantity (Base)" := ReservationMgt.MatchSurplus(ReservEntry,SurplusEntry,
    //             ReservEntry."Quantity (Base)",NOT ReservEntry.Positive,AvailabilityDate,Item."Order Tracking Policy");
    //     TempReservEntry.DELETE;
    //     IF SurplusEntry."Entry No." <> 0 THEN BEGIN
    //       IF ReservEntry."Quantity (Base)" = 0 THEN
    //         ReservEntry.DELETE(TRUE)
    //       ELSE BEGIN
    //         ReservEntry.VALIDATE("Quantity (Base)");
    //         ReservEntry.MODIFY;
    //       END;
    //       TempReservEntry := SurplusEntry;
    //       IF NOT TempReservEntry.INSERT THEN
    //         TempReservEntry.MODIFY;
    //     END;
    //   END;
    // END;

    //[External]
    PROCEDURE UpdateActionMessages(SurplusEntry : Record 337);
    VAR
      DummyReservEntry : Record 337;
      ActionMessageEntry : Record 99000849;
    BEGIN
      ActionMessageEntry.RESET;
      ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
      ActionMessageEntry.SETRANGE("Reservation Entry",SurplusEntry."Entry No.");
      IF NOT ActionMessageEntry.ISEMPTY THEN
        ActionMessageEntry.DELETEALL;
      IF NOT (SurplusEntry."Reservation Status" = SurplusEntry."Reservation Status"::Surplus) THEN
        EXIT;
      ReservMgt.IssueActionMessage(SurplusEntry,FALSE,DummyReservEntry);
    END;

    LOCAL PROCEDURE GetItem(ItemNo : Code[20]);
    BEGIN
      IF Item."No." <> ItemNo THEN
        Item.GET(ItemNo);
    END;

    LOCAL PROCEDURE ItemTrackingMismatch(ReservEntry : Record 337;NewSerialNo : Code[50];NewLotNo : Code[50]) : Boolean;
    VAR
      ReservEntry2 : Record 337;
    BEGIN
      IF (NewLotNo = '') AND (NewSerialNo = '') THEN
        EXIT(FALSE);

      IF ReservEntry."Reservation Status".AsInteger() > ReservEntry."Reservation Status"::Tracking.AsInteger() THEN
        EXIT(FALSE);

      ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive);

      IF ReservEntry2."Item Tracking" = ReservEntry2."Item Tracking"::None THEN
        EXIT(FALSE);

      IF (ReservEntry2."Lot No." <> '') AND (NewLotNo <> '') THEN
        IF ReservEntry2."Lot No." <> NewLotNo THEN
          EXIT(TRUE);

      IF (ReservEntry2."Serial No." <> '') AND (NewSerialNo <> '') THEN
        IF ReservEntry2."Serial No." <> NewSerialNo THEN
          EXIT(TRUE);

      EXIT(FALSE);
    END;

    //[External]
    // PROCEDURE InitRecordSet(VAR ReservEntry : Record 337) : Boolean;
    // BEGIN
    //   EXIT(InitRecordSet2(ReservEntry,'',''));
    // END;

    //[External]
    PROCEDURE InitRecordSet2(VAR ReservEntry : Record 337;CurrSerialNo : Code[50];CurrLotNo : Code[50]) : Boolean;
    VAR
      IsDemand : Boolean;
      CarriesItemTracking : Boolean;
    BEGIN
      // Used for combining sorting of reservation entries with priorities
      IF NOT ReservEntry.FINDSET THEN
        EXIT(FALSE);

      IsDemand := ReservEntry."Quantity (Base)" < 0;

      TempSortRec1.RESET;
      TempSortRec2.RESET;
      TempSortRec3.RESET;
      TempSortRec4.RESET;

      TempSortRec1.DELETEALL;
      TempSortRec2.DELETEALL;
      TempSortRec3.DELETEALL;
      TempSortRec4.DELETEALL;

      REPEAT
        IF NOT ItemTrackingMismatch(ReservEntry,CurrSerialNo,CurrLotNo) THEN BEGIN
          TempSortRec1 := ReservEntry;
          TempSortRec1.INSERT;
          CarriesItemTracking := TempSortRec1.TrackingExists;
          IF CarriesItemTracking THEN BEGIN
            TempSortRec2 := TempSortRec1;
            TempSortRec2.INSERT;
          END;

          IF TempSortRec1."Reservation Status" = TempSortRec1."Reservation Status"::Reservation THEN
            IF TempSortRec1."Expected Receipt Date" = 0D THEN // Inventory
              IF IsDemand THEN
                IF CarriesItemTracking THEN BEGIN
                  TempSortRec4 := TempSortRec1;
                  TempSortRec4.INSERT;
                  TempSortRec2.DELETE;
                END ELSE BEGIN
                  TempSortRec3 := TempSortRec1;
                  TempSortRec3.INSERT;
                END;
        END;
      UNTIL ReservEntry.NEXT = 0;

      SetKeyAndFilters(TempSortRec1);
      SetKeyAndFilters(TempSortRec2);
      SetKeyAndFilters(TempSortRec3);
      SetKeyAndFilters(TempSortRec4);

      EXIT(NEXTRecord(ReservEntry) <> 0);
    END;

    //[External]
    PROCEDURE NEXTRecord(VAR ReservEntry : Record 337) : Integer;
    VAR
      Found : Boolean;
    BEGIN
      // Used for combining sorting of reservation entries with priorities
      IF NOT TempSortRec1.FINDFIRST THEN
        EXIT(0);

      IF TempSortRec1."Reservation Status" = TempSortRec1."Reservation Status"::Reservation THEN
        IF NOT TempSortRec4.ISEMPTY THEN BEGIN // Reservations with item tracking against inventory
          TempSortRec4.FINDFIRST;
          TempSortRec1 := TempSortRec4;
          TempSortRec4.DELETE;
          Found := TRUE;
        END ELSE
          IF NOT TempSortRec3.ISEMPTY THEN BEGIN // Reservations with no item tracking against inventory
            TempSortRec3.FINDFIRST;
            TempSortRec1 := TempSortRec3;
            TempSortRec3.DELETE;
            Found := TRUE;
          END;

      IF NOT Found THEN BEGIN
        TempSortRec2.SETRANGE("Reservation Status",TempSortRec1."Reservation Status");
        IF NOT TempSortRec2.ISEMPTY THEN BEGIN // Records carrying item tracking
          TempSortRec2.FINDFIRST;
          TempSortRec1 := TempSortRec2;
          TempSortRec2.DELETE;
        END ELSE BEGIN
          TempSortRec2.SETRANGE("Reservation Status");
          IF NOT TempSortRec2.ISEMPTY THEN BEGIN // Records carrying item tracking
            TempSortRec2.FINDFIRST;
            TempSortRec1 := TempSortRec2;
            TempSortRec2.DELETE;
          END;
        END;
      END;

      ReservEntry := TempSortRec1;
      TempSortRec1.DELETE;
      EXIT(1);
    END;

    LOCAL PROCEDURE SetKeyAndFilters(VAR ReservEntry : Record 337);
    BEGIN
      IF ReservEntry.ISEMPTY THEN
        EXIT;

      ReservEntry.SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Reservation Status",
        "Shipment Date","Expected Receipt Date");

      IF ReservEntry.FINDFIRST THEN
        ReservEntry.SetPointerFilter;
    END;

    //[External]
    // PROCEDURE RenamePointer(TableID : Integer;OldSubtype : Integer;OldID : Code[20];OldBatchName : Code[10];OldProdOrderLine : Integer;OldRefNo : Integer;NewSubtype : Integer;NewID : Code[20];NewBatchName : Code[10];NewProdOrderLine : Integer;NewRefNo : Integer);
    // VAR
    //   ReservEntry : Record 337;
    //   NewReservEntry : Record 337;
    //   W : Dialog;
    //   PointerFieldIsActive : ARRAY [6] OF Boolean;
    // BEGIN
    //   GetActivePointerFields(TableID,PointerFieldIsActive);
    //   IF NOT PointerFieldIsActive[1] THEN
    //     EXIT;

    //   ReservEntry.SETCURRENTKEY(
    //     "Source ID","Source Ref. No.","Source Type","Source Subtype",
    //     "Source Batch Name","Source Prod. Order Line","Reservation Status");

    //   IF PointerFieldIsActive[3] THEN
    //     ReservEntry.SETRANGE("Source ID",OldID)
    //   ELSE
    //     ReservEntry.SETRANGE("Source ID",'');

    //   IF PointerFieldIsActive[6] THEN
    //     ReservEntry.SETRANGE("Source Ref. No.",OldRefNo)
    //   ELSE
    //     ReservEntry.SETRANGE("Source Ref. No.",0);

    //   ReservEntry.SETRANGE("Source Type",TableID);

    //   IF PointerFieldIsActive[2] THEN
    //     ReservEntry.SETRANGE("Source Subtype",OldSubtype)
    //   ELSE
    //     ReservEntry.SETRANGE("Source Subtype",0);

    //   IF PointerFieldIsActive[4] THEN
    //     ReservEntry.SETRANGE("Source Batch Name",OldBatchName)
    //   ELSE
    //     ReservEntry.SETRANGE("Source Batch Name",'');

    //   IF PointerFieldIsActive[5] THEN
    //     ReservEntry.SETRANGE("Source Prod. Order Line",OldProdOrderLine)
    //   ELSE
    //     ReservEntry.SETRANGE("Source Prod. Order Line",0);

    //   ReservEntry.Lock;

    //   IF ReservEntry.FINDSET THEN BEGIN
    //     W.OPEN(Text007);
    //     REPEAT
    //       NewReservEntry := ReservEntry;
    //       IF OldSubtype <> NewSubtype THEN
    //         NewReservEntry."Source Subtype" := NewSubtype;
    //       IF OldID <> NewID THEN
    //         NewReservEntry."Source ID" := NewID;
    //       IF OldBatchName <> NewBatchName THEN
    //         NewReservEntry."Source Batch Name" := NewBatchName;
    //       IF OldProdOrderLine <> NewProdOrderLine THEN
    //         NewReservEntry."Source Prod. Order Line" := NewProdOrderLine;
    //       IF OldRefNo <> NewRefNo THEN
    //         NewReservEntry."Source Ref. No." := NewRefNo;
    //       ReservEntry.DELETE;
    //       NewReservEntry.INSERT;
    //     UNTIL ReservEntry.NEXT = 0;
    //     W.CLOSE;
    //   END;
    // END;

    // LOCAL PROCEDURE GetActivePointerFields(TableID : Integer;VAR PointerFieldIsActive : ARRAY [6] OF Boolean);
    // BEGIN
    //   CLEAR(PointerFieldIsActive);
    //   PointerFieldIsActive[1] := TRUE;  // Type

    //   CASE TableID OF
    //     DATABASE::"Sales Line",
    //     DATABASE::"Purchase Line",
    //     DATABASE::"Service Line",
    //     DATABASE::"Job Planning Line",
    //     DATABASE::"Assembly Line":
    //       BEGIN
    //         PointerFieldIsActive[2] := TRUE;  // SubType
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[6] := TRUE;  // RefNo
    //       END;
    //     DATABASE::"Requisition Line":
    //       BEGIN
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[4] := TRUE;  // BatchName
    //         PointerFieldIsActive[6] := TRUE;  // RefNo
    //       END;
    //     DATABASE::"Item Journal Line":
    //       BEGIN
    //         PointerFieldIsActive[2] := TRUE;  // SubType
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[4] := TRUE;  // BatchName
    //         PointerFieldIsActive[6] := TRUE;  // RefNo
    //       END;
    //     DATABASE::"Job Journal Line":
    //       BEGIN
    //         PointerFieldIsActive[2] := TRUE;  // SubType
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[4] := TRUE;  // BatchName
    //         PointerFieldIsActive[6] := TRUE;  // RefNo
    //       END;
    //     DATABASE::"Item Ledger Entry":
    //       PointerFieldIsActive[6] := TRUE;  // RefNo
    //     DATABASE::"Prod. Order Line":
    //       BEGIN
    //         PointerFieldIsActive[2] := TRUE;  // SubType
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[5] := TRUE;  // ProdOrderLine
    //       END;
    //     DATABASE::"Prod. Order Component",  DATABASE::"Transfer Line":
    //       BEGIN
    //         PointerFieldIsActive[2] := TRUE;  // SubType
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[5] := TRUE;  // ProdOrderLine
    //         PointerFieldIsActive[6] := TRUE;  // RefNo
    //       END;
    //     DATABASE::"Planning Component":
    //       BEGIN
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //         PointerFieldIsActive[4] := TRUE;  // BatchName
    //         PointerFieldIsActive[5] := TRUE;  // ProdOrderLine
    //         PointerFieldIsActive[6] := TRUE;  // RefNo
    //       END;
    //     DATABASE::"Assembly Header":
    //       BEGIN
    //         PointerFieldIsActive[2] := TRUE;  // SubType
    //         PointerFieldIsActive[3] := TRUE;  // ID
    //       END;
    //     ELSE
    //       PointerFieldIsActive[1] := FALSE;  // Type is not used
    //   END;
    // END;

    //[External]
    // PROCEDURE SplitTrackingConnection(ReservEntry2 : Record 337;NewDate : Date);
    // VAR
    //   ActionMessageEntry : Record 99000849;
    //   ReservEntry3 : Record 337;
    //   DummyReservEntry : Record 337;
    // BEGIN
    //   ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
    //   ActionMessageEntry.SETRANGE("Reservation Entry",ReservEntry2."Entry No.");
    //   IF NOT ActionMessageEntry.ISEMPTY THEN
    //     ActionMessageEntry.DELETEALL;

    //   IF ReservEntry2.Positive THEN BEGIN
    //     ReservEntry2."Expected Receipt Date" := NewDate;
    //     ReservEntry2."Shipment Date" := 0D;
    //   END ELSE BEGIN
    //     ReservEntry2."Shipment Date" := NewDate;
    //     ReservEntry2."Expected Receipt Date" := 0D;
    //   END;
    //   ReservEntry2."Changed By" := USERID;
    //   ReservEntry2."Reservation Status" := ReservEntry2."Reservation Status"::Surplus;
    //   ReservEntry2.MODIFY;

    //   IF ReservEntry3.GET(ReservEntry2."Entry No.",NOT ReservEntry2.Positive) THEN BEGIN // Get related entry
    //     ReservEntry3.DELETE;
    //     ReservEntry3."Entry No." := 0;
    //     ReservEntry3."Reservation Status" := ReservEntry3."Reservation Status"::Surplus;
    //     IF ReservEntry3.Positive THEN
    //       ReservEntry3."Shipment Date" := 0D
    //     ELSE
    //       ReservEntry3."Expected Receipt Date" := 0D;
    //     ReservEntry3.INSERT;
    //   END ELSE
    //     CLEAR(ReservEntry3);

    //   IF ReservEntry2."Quantity (Base)" <> 0 THEN
    //     ReservMgt.IssueActionMessage(ReservEntry2,FALSE,DummyReservEntry);

    //   IF ReservEntry3."Quantity (Base)" <> 0 THEN
    //     ReservMgt.IssueActionMessage(ReservEntry3,FALSE,DummyReservEntry);
    // END;

    LOCAL PROCEDURE SaveLostReservQty(ReservEntry : Record 337);
    BEGIN
      IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Reservation THEN BEGIN
        LostReservationQty += ReservEntry."Quantity (Base)";
        ReservationsModified := TRUE;
      END;
    END;

    //[External]
    // PROCEDURE RetrieveLostReservQty(VAR LostQuantity : Decimal) ReservEntriesHaveBeenModified : Boolean;
    // BEGIN
    //   LostQuantity := LostReservationQty;
    //   LostReservationQty := 0;
    //   ReservEntriesHaveBeenModified := ReservationsModified;
    //   ReservationsModified := FALSE;
    // END;

    LOCAL PROCEDURE SetItemTracking2(TempReservEntry2 : Record 337;VAR TrackingSpecification2 : Record 336);
    BEGIN
      IF TempReservEntry2.Binding = TempReservEntry2.Binding::"Order-to-Order" THEN BEGIN
        // only supply can change IT and demand must respect it
        IF TempReservEntry2.Positive AND
           ((TempReservEntry2."Serial No." <> TrackingSpecification2."Serial No.") OR
            (TempReservEntry2."Lot No." <> TrackingSpecification2."Lot No."))
        THEN
          ERROR(Text008,
            TempReservEntry2.FIELDCAPTION("Serial No."),
            TempReservEntry2.FIELDCAPTION("Lot No."),
            TempReservEntry2.FIELDCAPTION(Binding),
            TempReservEntry2.Binding);
      END ELSE BEGIN
        // each record brings/holds own IT
        TrackingSpecification2."Serial No." := TempReservEntry2."Serial No.";
        TrackingSpecification2."Lot No." := TempReservEntry2."Lot No.";
      END;
    END;

    //[External]
    // PROCEDURE ResvExistsForSalesHeader(VAR SalesHeader : Record 36) : Boolean;
    // VAR
    //   ReservEntry : Record 337;
    // BEGIN
    //   InitFilterAndSortingFor(ReservEntry,TRUE);

    //   WITH SalesHeader DO BEGIN
    //     ReservEntry.SETRANGE("Source Type",DATABASE::"Sales Line");
    //     ReservEntry.SETRANGE("Source Subtype","Document Type");
    //     ReservEntry.SETRANGE("Source ID","No.");
    //   END;

    //   EXIT(ResvExistsForHeader(ReservEntry));
    // END;

    //[External]
    // PROCEDURE ResvExistsForPurchHeader(VAR PurchHeader : Record 38) : Boolean;
    // VAR
    //   ReservEntry : Record 337;
    // BEGIN
    //   InitFilterAndSortingFor(ReservEntry,TRUE);

    //   WITH PurchHeader DO BEGIN
    //     ReservEntry.SETRANGE("Source Type",DATABASE::"Purchase Line");
    //     ReservEntry.SETRANGE("Source Subtype","Document Type");
    //     ReservEntry.SETRANGE("Source ID","No.");
    //   END;

    //   EXIT(ResvExistsForHeader(ReservEntry));
    // END;

    //[External]
    PROCEDURE ResvExistsForTransHeader(VAR TransHeader : Record 5740) : Boolean;
    VAR
      ReservEntry : Record 337;
    BEGIN
      InitFilterAndSortingFor(ReservEntry,TRUE);

      WITH TransHeader DO BEGIN
        ReservEntry.SETRANGE("Source Type",DATABASE::"Transfer Line");
        ReservEntry.SETRANGE("Source ID","No.");
      END;

      EXIT(ResvExistsForHeader(ReservEntry));
    END;

    LOCAL PROCEDURE ResvExistsForHeader(VAR ReservEntry : Record 337) : Boolean;
    BEGIN
      ReservEntry.SETRANGE("Source Batch Name",'');
      ReservEntry.SETRANGE("Source Prod. Order Line",0);
      ReservEntry.SETFILTER("Source Ref. No.",'>0');
      ReservEntry.SETFILTER("Expected Receipt Date",'<>%1',0D);

      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE TransferLineWithItemTracking(ReservEntry : Record 337) : Boolean;
    BEGIN
      EXIT((ReservEntry."Source Type" = DATABASE::"Transfer Line") AND ReservEntry.TrackingExists);
    END;

    LOCAL PROCEDURE CheckTrackingNoMismatch(ReservEntry : Record 337;TrackingSpecification : Record 336;TrackingSpecification2 : Record 336;SNSpecific : Boolean;LotSpecific : Boolean) : Boolean;
    VAR
      SNMismatch : Boolean;
      LotMismatch : Boolean;
    BEGIN
      IF ReservEntry.Positive THEN BEGIN
        IF TrackingSpecification2."Serial No." <> '' THEN
          SNMismatch := SNSpecific AND
            (TrackingSpecification."Serial No." <> TrackingSpecification2."Serial No.");
        IF TrackingSpecification2."Lot No." <> '' THEN
          LotMismatch := LotSpecific AND
            (TrackingSpecification."Lot No." <> TrackingSpecification2."Lot No.");
      END ELSE BEGIN
        IF TrackingSpecification."Serial No." <> '' THEN
          SNMismatch := SNSpecific AND
            (TrackingSpecification."Serial No." <> TrackingSpecification2."Serial No.");
        IF TrackingSpecification."Lot No." <> '' THEN
          LotMismatch := LotSpecific AND
            (TrackingSpecification."Lot No." <> TrackingSpecification2."Lot No.");
      END;
      EXIT(LotMismatch OR SNMismatch);
    END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterCreateText(ReservationEntry : Record 337;VAR SourceTypeText : Text);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterModifyShipmentDate(VAR ReservationEntry2 : Record 337;VAR ReservationEntry : Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdateItemTracking(VAR ReservEntry : Record 337;VAR TrackingSpecification : Record 336);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}






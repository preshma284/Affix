Codeunit 51197 "Create Pick 1"
{
  
  
    Permissions=TableData 6550=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      WhseActivHeader : Record 5766;
      TempWhseActivLine : Record 5767 TEMPORARY;
      TempWhseItemTrackingLine : Record 6550 TEMPORARY;
      TempTotalWhseItemTrackingLine : Record 6550 TEMPORARY;
      SourceWhseItemTrackingLine : Record 6550;
      WhseShptLine : Record 7321;
      WhseInternalPickLine : Record 7334;
      ProdOrderCompLine : Record 5407;
      AssemblyLine : Record 901;
      WhseWkshLine : Record 7326;
      WhseSetup : Record 5769;
      Location : Record 14;
      WhseSetupLocation : Record 14;
      Item : Record 27;
      Bin : Record 7354;
      BinType : Record 7303;
      SKU : Record 5700;
      WhseMgt : Codeunit 5775;
      WhseAvailMgt : Codeunit 7314;
      ItemTrackingMgt : Codeunit 6500;
      ItemTrackingMgt1 : Codeunit 51151;
      WhseSource : Option "Pick Worksheet","Shipment","Movement Worksheet","Internal Pick","Production","Assembly";
      SortPick : Option " ","Item","Document","Shelf/Bin No.","Due Date","Ship-To","Bin Ranking","Action Type";
      WhseDocType : Option "Put-away","Pick","Movement";
      SourceSubType : Enum "Production Order Status";
      SourceNo : Code[20];
      AssignedID : Code[50];
      ShippingAgentCode : Code[10];
      ShippingAgentServiceCode : Code[10];
      ShipmentMethodCode : Code[10];
      TransferRemQtyToPickBase : Decimal;
      TempNo : Integer;
      MaxNoOfLines : Integer;
      BreakbulkNo : Integer;
      TempLineNo : Integer;
      MaxNoOfSourceDoc : Integer;
      SourceType : Integer;
      SourceLineNo : Integer;
      SourceSubLineNo : Integer;
      LastWhseItemTrkgLineNo : Integer;
      WhseItemTrkgLineCount : Integer;
      PerZone : Boolean;
      Text000 : TextConst ENU='Nothing to handle. %1.',ESP='Nada a manipular. %1.';
      PerBin : Boolean;
      DoNotFillQtytoHandle : Boolean;
      BreakbulkFilter : Boolean;
      WhseItemTrkgExists : Boolean;
      SNRequired : Boolean;
      LNRequired : Boolean;
      CrossDock : Boolean;
      ReservationExists : Boolean;
      ReservedForItemLedgEntry : Boolean;
      CalledFromPickWksh : Boolean;
      CalledFromMoveWksh : Boolean;
      CalledFromWksh : Boolean;
      ReqFEFOPick : Boolean;
      HasExpiredItems : Boolean;
      CannotBeHandledReasons : ARRAY [20] OF Text;
      TotalQtyPickedBase : Decimal;
      BinIsNotForPickTxt : TextConst ENU='The quantity to be picked is in bin %1, which is not set up for picking',ESP='La cantidad para el picking est� en la ubicaci�n %1, que no est� definida para picking';
      BinIsForReceiveOrShipTxt : TextConst ENU='The quantity to be picked is in bin %1, which is set up for receiving or shipping',ESP='La cantidad para el picking est� en la ubicaci�n %1, que no est� definida para recepci�n o env�o';
      QtyReservedNotFromInventoryTxt : TextConst ENU='The quantity to be picked is not in inventory yet. You must first post the supply from which the source document is reserved',ESP='La cantidad para el picking no est� a�n en el inventario. Primero debe registrar el suministro desde el que se reserva el documento de origen';

    //[External]
    PROCEDURE CreateTempLine(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];FromBinCode : Code[20];ToBinCode : Code[20];QtyPerUnitofMeasure : Decimal;VAR TotalQtytoPick : Decimal;VAR TotalQtytoPickBase : Decimal);
    VAR
      QtyToPick : Decimal;
      RemQtyToPick : Decimal;
      i : Integer;
      RemQtyToPickBase : Decimal;
      QtyToPickBase : Decimal;
      QtyToTrackBase : Decimal;
      QtyBaseMaxAvailToPick : Decimal;
      TotalItemTrackedQtyToPick : Decimal;
      TotalItemTrackedQtyToPickBase : Decimal;
      NewQtyToHandle : Decimal;
    BEGIN
      TotalQtyPickedBase := 0;
      GetLocation(LocationCode);

      IF Location."Directed Put-away and Pick" THEN
        QtyBaseMaxAvailToPick := // Total qty (excl. Receive bin content) that are not assigned to any activity/ order
          CalcTotalQtyOnBinType('',LocationCode,ItemNo,VariantCode) -
          CalcTotalQtyAssgndOnWhse(LocationCode,ItemNo,VariantCode) +
          CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::"Put-away",LocationCode,ItemNo,VariantCode) -
          CalcTotalQtyOnBinType(GetBinTypeFilter(0),LocationCode,ItemNo,VariantCode) // Receive area
      ELSE
        QtyBaseMaxAvailToPick :=
          CalcAvailableQty(ItemNo,VariantCode) -
          CalcPickQtyAssigned(LocationCode,ItemNo,VariantCode,UnitofMeasureCode,FromBinCode,TempWhseItemTrackingLine);

      CheckReservation(
        QtyBaseMaxAvailToPick,SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,Location."Always Create Pick Line",
        QtyPerUnitofMeasure,TotalQtytoPick,TotalQtytoPickBase);

      OnAfterCreateTempLineCheckReservation(
        LocationCode,ItemNo,VariantCode,UnitofMeasureCode,QtyPerUnitofMeasure,TotalQtytoPick,TotalQtytoPickBase,
        SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo);

      RemQtyToPick := TotalQtytoPick;
      RemQtyToPickBase := TotalQtytoPickBase;
      ItemTrackingMgt1.CheckWhseItemTrkgSetup(ItemNo,SNRequired,LNRequired,FALSE);

      ReqFEFOPick := FALSE;
      HasExpiredItems := FALSE;
      IF PickAccordingToFEFO(LocationCode) OR
         PickStrictExpirationPosting(ItemNo)
      THEN BEGIN
        QtyToTrackBase := RemQtyToPickBase;
        IF UndefinedItemTrkg(QtyToTrackBase) THEN BEGIN
          CreateTempItemTrkgLines(ItemNo,VariantCode,QtyToTrackBase,TRUE);
          CreateTempItemTrkgLines(ItemNo,VariantCode,TransferRemQtyToPickBase,FALSE);
        END;
      END;
      IF TotalQtytoPickBase <> 0 THEN BEGIN
        TempWhseItemTrackingLine.RESET;
        TempWhseItemTrackingLine.SETFILTER("Qty. to Handle",'<> 0');
        IF TempWhseItemTrackingLine.FIND('-') THEN BEGIN
          REPEAT
            IF TempWhseItemTrackingLine."Qty. to Handle (Base)" <> 0 THEN BEGIN
              IF TempWhseItemTrackingLine."Qty. to Handle (Base)" > RemQtyToPickBase THEN BEGIN
                TempWhseItemTrackingLine."Qty. to Handle (Base)" := RemQtyToPickBase;
                TempWhseItemTrackingLine.MODIFY;
              END;
              NewQtyToHandle := ROUND(RemQtyToPick / RemQtyToPickBase * TempWhseItemTrackingLine."Qty. to Handle (Base)",0.00001);
              IF TempWhseItemTrackingLine."Qty. to Handle" <> NewQtyToHandle THEN BEGIN
                TempWhseItemTrackingLine."Qty. to Handle" := NewQtyToHandle;
                TempWhseItemTrackingLine.MODIFY;
              END;

              QtyToPick := TempWhseItemTrackingLine."Qty. to Handle";
              QtyToPickBase := TempWhseItemTrackingLine."Qty. to Handle (Base)";
              TotalItemTrackedQtyToPick += QtyToPick;
              TotalItemTrackedQtyToPickBase += QtyToPickBase;

              CreateTempLine2(
                LocationCode,ItemNo,VariantCode,UnitofMeasureCode,FromBinCode,ToBinCode,
                QtyPerUnitofMeasure,QtyToPick,TempWhseItemTrackingLine,QtyToPickBase);
              RemQtyToPickBase -= TempWhseItemTrackingLine."Qty. to Handle (Base)" - QtyToPickBase;
              RemQtyToPick -= TempWhseItemTrackingLine."Qty. to Handle" - QtyToPick;
            END;
          UNTIL (TempWhseItemTrackingLine.NEXT = 0) OR (RemQtyToPickBase <= 0);
          RemQtyToPick := Minimum(RemQtyToPick,TotalQtytoPick - TotalItemTrackedQtyToPick);
          RemQtyToPickBase := Minimum(RemQtyToPickBase,TotalQtytoPickBase - TotalItemTrackedQtyToPickBase);
          TotalQtytoPick := RemQtyToPick;
          TotalQtytoPickBase := RemQtyToPickBase;

          SaveTempItemTrkgLines;
          CLEAR(TempWhseItemTrackingLine);
          WhseItemTrkgExists := FALSE;
        END;
        IF TotalQtytoPickBase <> 0 THEN
          IF NOT HasExpiredItems THEN BEGIN
            IF SNRequired THEN BEGIN
              FOR i := 1 TO TotalQtytoPick DO BEGIN
                QtyToPick := 1;
                QtyToPickBase := 1;
                CreateTempLine2(LocationCode,ItemNo,VariantCode,UnitofMeasureCode,
                  FromBinCode,ToBinCode,QtyPerUnitofMeasure,QtyToPick,TempWhseItemTrackingLine,QtyToPickBase);
              END;
              TotalQtytoPick := 0;
              TotalQtytoPickBase := 0;
            END ELSE
              CreateTempLine2(LocationCode,ItemNo,VariantCode,UnitofMeasureCode,
                FromBinCode,ToBinCode,QtyPerUnitofMeasure,TotalQtytoPick,TempWhseItemTrackingLine,TotalQtytoPickBase);
          END;
      END;
    END;

    LOCAL PROCEDURE CreateTempLine2(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];FromBinCode : Code[20];ToBinCode : Code[20];QtyPerUnitofMeasure : Decimal;VAR TotalQtytoPick : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;VAR TotalQtytoPickBase : Decimal);
    VAR
      QtytoPick : Decimal;
      QtytoPickBase : Decimal;
      QtyAvailableBase : Decimal;
    BEGIN
      GetLocation(LocationCode);
      IF Location."Bin Mandatory" THEN BEGIN
        IF NOT Location."Directed Put-away and Pick" THEN BEGIN
          QtyAvailableBase :=
            CalcAvailableQty(ItemNo,VariantCode) -
            CalcPickQtyAssigned(LocationCode,ItemNo,VariantCode,UnitofMeasureCode,'',TempWhseItemTrackingLine);

          IF QtyAvailableBase > 0 THEN BEGIN
            IF TotalQtytoPickBase > QtyAvailableBase THEN
              TotalQtytoPickBase := QtyAvailableBase;
            CalcBWPickBin(
              LocationCode,ItemNo,VariantCode,UnitofMeasureCode,
              QtyPerUnitofMeasure,TotalQtytoPick,TotalQtytoPickBase,TempWhseItemTrackingLine);
          END;
          EXIT;
        END;

        IF (WhseSource = WhseSource::"Movement Worksheet") AND (FromBinCode <> '') THEN BEGIN
          InsertTempActivityLineFromMovWkshLine(
            LocationCode,ItemNo,VariantCode,FromBinCode,
            QtyPerUnitofMeasure,TotalQtytoPick,TempWhseItemTrackingLine,TotalQtytoPickBase);
          EXIT;
        END;

        IF (ReservationExists AND ReservedForItemLedgEntry) OR NOT ReservationExists THEN BEGIN
          IF Location."Use Cross-Docking" THEN
            CalcPickBin(
              LocationCode,ItemNo,VariantCode,UnitofMeasureCode,
              ToBinCode,QtyPerUnitofMeasure,
              TotalQtytoPick,TempWhseItemTrackingLine,TRUE,TotalQtytoPickBase);
          IF TotalQtytoPickBase > 0 THEN
            CalcPickBin(
              LocationCode,ItemNo,VariantCode,UnitofMeasureCode,
              ToBinCode,QtyPerUnitofMeasure,
              TotalQtytoPick,TempWhseItemTrackingLine,FALSE,TotalQtytoPickBase);
        END;
        IF (TotalQtytoPickBase > 0) AND Location."Always Create Pick Line" THEN BEGIN
          UpdateQuantitiesToPick(
            TotalQtytoPickBase,
            QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,
            QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,
            TotalQtytoPick,TotalQtytoPickBase);

          CreateTempActivityLine(
            LocationCode,'',UnitofMeasureCode,QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,1,0);
          CreateTempActivityLine(
            LocationCode,ToBinCode,UnitofMeasureCode,QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,2,0);
        END;
        EXIT;
      END;

      QtyAvailableBase :=
        CalcAvailableQty(ItemNo,VariantCode) -
        CalcPickQtyAssigned(LocationCode,ItemNo,VariantCode,UnitofMeasureCode,'',TempWhseItemTrackingLine);

      IF QtyAvailableBase > 0 THEN BEGIN
        UpdateQuantitiesToPick(
          QtyAvailableBase,
          QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,
          QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,
          TotalQtytoPick,TotalQtytoPickBase);

        CreateTempActivityLine(LocationCode,'',UnitofMeasureCode,QtyPerUnitofMeasure,QtytoPick,QtytoPickBase,0,0);
      END;
    END;

    LOCAL PROCEDURE InsertTempActivityLineFromMovWkshLine(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];FromBinCode : Code[20];QtyPerUnitofMeasure : Decimal;VAR TotalQtytoPick : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;VAR TotalQtyToPickBase : Decimal);
    VAR
      FromBinContent : Record 7302;
      FromItemUOM : Record 5404;
      FromQtyToPick : Decimal;
      FromQtyToPickBase : Decimal;
      ToQtyToPick : Decimal;
      ToQtyToPickBase : Decimal;
      QtyAvailableBase : Decimal;
    BEGIN
      QtyAvailableBase := TotalQtyToPickBase;

      IF WhseWkshLine."From Unit of Measure Code" <> WhseWkshLine."Unit of Measure Code" THEN BEGIN
        FromBinContent.GET(
          LocationCode,FromBinCode,ItemNo,VariantCode,WhseWkshLine."From Unit of Measure Code");
        FromBinContent.SetFilterOnUnitOfMeasure;
        FromBinContent.CALCFIELDS("Quantity (Base)","Pick Quantity (Base)","Negative Adjmt. Qty. (Base)");

        QtyAvailableBase :=
          FromBinContent."Quantity (Base)" - FromBinContent."Pick Quantity (Base)" -
          FromBinContent."Negative Adjmt. Qty. (Base)" -
          CalcPickQtyAssigned(
            LocationCode,ItemNo,VariantCode,
            WhseWkshLine."From Unit of Measure Code",
            WhseWkshLine."From Bin Code",TempWhseItemTrackingLine);

        FromItemUOM.GET(ItemNo,FromBinContent."Unit of Measure Code");

        BreakbulkNo := BreakbulkNo + 1;
      END;

      UpdateQuantitiesToPick(
        QtyAvailableBase,
        WhseWkshLine."Qty. per From Unit of Measure",FromQtyToPick,FromQtyToPickBase,
        QtyPerUnitofMeasure,ToQtyToPick,ToQtyToPickBase,
        TotalQtytoPick,TotalQtyToPickBase);

      CreateBreakBulkTempLines(
        WhseWkshLine."Location Code",
        WhseWkshLine."From Unit of Measure Code",
        WhseWkshLine."Unit of Measure Code",
        FromBinCode,
        WhseWkshLine."To Bin Code",
        WhseWkshLine."Qty. per From Unit of Measure",
        WhseWkshLine."Qty. per Unit of Measure",
        BreakbulkNo,
        ToQtyToPick,ToQtyToPickBase,FromQtyToPick,FromQtyToPickBase);

      TotalQtyToPickBase := 0;
      TotalQtytoPick := 0;
    END;

    LOCAL PROCEDURE CalcMaxQtytoPlace(VAR QtytoHandle : Decimal;QtyOutstanding : Decimal;VAR QtytoHandleBase : Decimal;QtyOutstandingBase : Decimal);
    VAR
      WhseActivLine2 : Record 5767;
    BEGIN
      WhseActivLine2.COPY(TempWhseActivLine);
      WITH TempWhseActivLine DO BEGIN
        SETCURRENTKEY(
          "Whse. Document No.","Whse. Document Type","Activity Type","Whse. Document Line No.");
        SETRANGE("Whse. Document Type","Whse. Document Type");
        SETRANGE("Whse. Document No.","Whse. Document No.");
        SETRANGE("Activity Type","Activity Type");
        SETRANGE("Whse. Document Line No.","Whse. Document Line No.");
        SETRANGE("Source Type","Source Type");
        SETRANGE("Source Subtype","Source Subtype");
        SETRANGE("Source No.","Source No.");
        SETRANGE("Source Line No.","Source Line No.");
        SETRANGE("Source Subline No.","Source Subline No.");
        SETRANGE("Action Type","Action Type"::Place);
        SETRANGE("Breakbulk No.",0);
        IF FIND('-') THEN BEGIN
          CALCSUMS(Quantity);
          IF QtyOutstanding < Quantity + QtytoHandle THEN
            QtytoHandle := QtyOutstanding - Quantity;
          IF QtytoHandle < 0 THEN
            QtytoHandle := 0;
          CALCSUMS("Qty. (Base)");
          IF QtyOutstandingBase < "Qty. (Base)" + QtytoHandleBase THEN
            QtytoHandleBase := QtyOutstandingBase - "Qty. (Base)";
          IF QtytoHandleBase < 0 THEN
            QtytoHandleBase := 0;
        END;
      END;
      TempWhseActivLine.COPY(WhseActivLine2);
    END;

    LOCAL PROCEDURE CalcBWPickBin(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];QtyPerUnitofMeasure : Decimal;VAR TotalQtyToPick : Decimal;VAR TotalQtytoPickBase : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY);
    VAR
      WhseSource2 : Option;
      ToBinCode : Code[20];
      DefaultBin : Boolean;
      CrossDockBin : Boolean;
    BEGIN
      // Basic warehousing

      IF (WhseSource = WhseSource::Shipment) AND WhseShptLine."Assemble to Order" THEN
        WhseSource2 := WhseSource::Assembly
      ELSE
        WhseSource2 := WhseSource;

      IF TotalQtytoPickBase > 0 THEN
        CASE WhseSource2 OF
          WhseSource::"Pick Worksheet":
            ToBinCode := WhseWkshLine."To Bin Code";
          WhseSource::Shipment:
            ToBinCode := WhseShptLine."Bin Code";
          WhseSource::Production:
            ToBinCode := ProdOrderCompLine."Bin Code";
          WhseSource::Assembly:
            ToBinCode := AssemblyLine."Bin Code";
        END;

      FOR CrossDockBin := TRUE DOWNTO FALSE DO
        FOR DefaultBin := TRUE DOWNTO FALSE DO
          IF TotalQtytoPickBase > 0 THEN
            FindBWPickBin(
              LocationCode,ItemNo,VariantCode,
              ToBinCode,UnitofMeasureCode,QtyPerUnitofMeasure,DefaultBin,CrossDockBin,
              TotalQtyToPick,TotalQtytoPickBase,TempWhseItemTrackingLine);
    END;

    LOCAL PROCEDURE FindBWPickBin(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];ToBinCode : Code[20];UnitofMeasureCode : Code[10];QtyPerUnitofMeasure : Decimal;DefaultBin : Boolean;CrossDockBin : Boolean;VAR TotalQtyToPick : Decimal;VAR TotalQtyToPickBase : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY);
    VAR
      FromBinContent : Record 7302;
      QtyAvailableBase : Decimal;
      QtyToPickBase : Decimal;
      QtytoPick : Decimal;
      BinCodeFilterText : Text[250];
      IsSetCurrentKeyHandled : Boolean;
    BEGIN
      IsSetCurrentKeyHandled := FALSE;
      OnBeforeFindBWPickBin(FromBinContent,IsSetCurrentKeyHandled);
      IF NOT IsSetCurrentKeyHandled THEN
        IF CrossDockBin THEN BEGIN
          FromBinContent.SETCURRENTKEY(
            "Location Code","Item No.","Variant Code","Cross-Dock Bin","Qty. per Unit of Measure","Bin Ranking");
          FromBinContent.ASCENDING(FALSE);
        END ELSE
          FromBinContent.SETCURRENTKEY(Default,"Location Code","Item No.","Variant Code","Bin Code");

      WITH FromBinContent DO BEGIN
        SETRANGE(Default,DefaultBin);
        SETRANGE("Cross-Dock Bin",CrossDockBin);
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        GetLocation(LocationCode);
        OnBeforeSetBinCodeFilter(BinCodeFilterText,LocationCode,ItemNo,VariantCode,ToBinCode);
        IF Location."Require Pick" AND (Location."Shipment Bin Code" <> '') THEN
          AddToFilterText(BinCodeFilterText,'&','<>',Location."Shipment Bin Code");
        IF Location."Require Put-away" AND (Location."Receipt Bin Code" <> '') THEN
          AddToFilterText(BinCodeFilterText,'&','<>',Location."Receipt Bin Code");
        IF ToBinCode <> '' THEN
          AddToFilterText(BinCodeFilterText,'&','<>',ToBinCode);
        IF BinCodeFilterText <> '' THEN
          SETFILTER("Bin Code",BinCodeFilterText);
        IF WhseItemTrkgExists THEN BEGIN
          SETRANGE("Lot No. Filter",TempWhseItemTrackingLine."Lot No.");
          SETRANGE("Serial No. Filter",TempWhseItemTrackingLine."Serial No.");
        END;
        IF FIND('-') THEN
          REPEAT
            QtyAvailableBase :=
              CalcQtyAvailToPick(0) -
              CalcPickQtyAssigned(LocationCode,ItemNo,VariantCode,'',"Bin Code",TempWhseItemTrackingLine);

            OnCalcAvailQtyOnFindBWPickBin(
              ItemNo,VariantCode,SNRequired,LNRequired,WhseItemTrkgExists,
              TempWhseItemTrackingLine."Serial No.",TempWhseItemTrackingLine."Lot No.","Location Code","Bin Code",
              SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo,TotalQtyToPickBase,QtyAvailableBase);

            IF QtyAvailableBase > 0 THEN BEGIN
              IF SNRequired THEN
                QtyAvailableBase := 1;

              UpdateQuantitiesToPick(
                QtyAvailableBase,
                QtyPerUnitofMeasure,QtytoPick,QtyToPickBase,
                QtyPerUnitofMeasure,QtytoPick,QtyToPickBase,
                TotalQtyToPick,TotalQtyToPickBase);

              CreateTempActivityLine(
                LocationCode,"Bin Code",UnitofMeasureCode,QtyPerUnitofMeasure,QtytoPick,QtyToPickBase,1,0);
              CreateTempActivityLine(
                LocationCode,ToBinCode,UnitofMeasureCode,QtyPerUnitofMeasure,QtytoPick,QtyToPickBase,2,0);
            END;
          UNTIL (NEXT = 0) OR (TotalQtyToPickBase = 0);
      END;
    END;

    LOCAL PROCEDURE CalcPickBin(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];ToBinCode : Code[20];QtyPerUnitofMeasure : Decimal;VAR TotalQtytoPick : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;CrossDock : Boolean;VAR TotalQtytoPickBase : Decimal);
    BEGIN
      // Directed put-away and pick
      OnBeforeCalcPickBin(
        TempWhseActivLine,TotalQtytoPick,TotalQtytoPickBase,TempWhseItemTrackingLine,CrossDock,WhseItemTrkgExists);

      IF TotalQtytoPickBase > 0 THEN BEGIN
        ItemTrackingMgt1.CheckWhseItemTrkgSetup(ItemNo,SNRequired,LNRequired,FALSE);
        FindPickBin(
          LocationCode,ItemNo,VariantCode,UnitofMeasureCode,
          ToBinCode,TempWhseActivLine,TotalQtytoPick,TempWhseItemTrackingLine,CrossDock,TotalQtytoPickBase);
        IF (TotalQtytoPickBase > 0) AND Location."Allow Breakbulk" THEN BEGIN
          FindBreakBulkBin(
            LocationCode,ItemNo,VariantCode,UnitofMeasureCode,ToBinCode,
            QtyPerUnitofMeasure,TempWhseActivLine,TotalQtytoPick,TempWhseItemTrackingLine,CrossDock,TotalQtytoPickBase);
          IF TotalQtytoPickBase > 0 THEN
            FindSmallerUOMBin(
              LocationCode,ItemNo,VariantCode,UnitofMeasureCode,ToBinCode,
              QtyPerUnitofMeasure,TotalQtytoPick,TempWhseItemTrackingLine,CrossDock,TotalQtytoPickBase);
        END;
      END;
    END;

    LOCAL PROCEDURE BinContentExists(VAR BinContent : Record 7302;ItemNo : Code[20];LocationCode : Code[10];UOMCode : Code[10];VariantCode : Code[10];CrossDock : Boolean;LNRequired : Boolean;SNRequired : Boolean) : Boolean;
    BEGIN
      WITH BinContent DO BEGIN
        SETCURRENTKEY("Location Code","Item No.","Variant Code","Cross-Dock Bin","Qty. per Unit of Measure","Bin Ranking");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE("Cross-Dock Bin",CrossDock);
        SETRANGE("Unit of Measure Code",UOMCode);
        IF WhseSource = WhseSource::"Movement Worksheet" THEN
          SETFILTER("Bin Ranking",'<%1',Bin."Bin Ranking");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No. Filter",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No. Filter",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No. Filter",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No. Filter",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END;
        ASCENDING(FALSE);
        OnAfterBinContentExistsFilter(BinContent);
        EXIT(FINDSET);
      END;
    END;

    LOCAL PROCEDURE BinContentBlocked(LocationCode : Code[10];BinCode : Code[20];ItemNo : Code[20];VariantCode : Code[10];UnitOfMeasureCode : Code[10]) : Boolean;
    VAR
      BinContent : Record 7302;
    BEGIN
      WITH BinContent DO BEGIN
        GET(LocationCode,BinCode,ItemNo,VariantCode,UnitOfMeasureCode);
        IF "Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All] THEN
          EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE BreakBulkPlacingExists(VAR TempBinContent : Record 7302 TEMPORARY;ItemNo : Code[20];LocationCode : Code[10];UOMCode : Code[10];VariantCode : Code[10];CrossDock : Boolean;LNRequired : Boolean;SNRequired : Boolean) : Boolean;
    VAR
      BinContent2 : Record 7302;
      WhseActivLine2 : Record 5767;
    BEGIN
      TempBinContent.RESET;
      TempBinContent.DELETEALL;
      WITH BinContent2 DO BEGIN
        SETCURRENTKEY("Location Code","Item No.","Variant Code","Cross-Dock Bin","Qty. per Unit of Measure","Bin Ranking");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE("Cross-Dock Bin",CrossDock);
        IF WhseSource = WhseSource::"Movement Worksheet" THEN
          SETFILTER("Bin Ranking",'<%1',Bin."Bin Ranking");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No. Filter",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No. Filter",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No. Filter",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No. Filter",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END;
        ASCENDING(FALSE);
      END;

      WhseActivLine2.COPY(TempWhseActivLine);
      WITH TempWhseActivLine DO BEGIN
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE("Unit of Measure Code",UOMCode);
        SETRANGE("Action Type","Action Type"::Place);
        SETFILTER("Breakbulk No.",'<>0');
        SETRANGE("Bin Code");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No.",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No.",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No.",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No.",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END;
        IF FINDFIRST THEN
          REPEAT
            BinContent2.SETRANGE("Bin Code","Bin Code");
            BinContent2.SETRANGE("Unit of Measure Code",UOMCode);
            IF BinContent2.ISEMPTY THEN BEGIN
              BinContent2.SETRANGE("Unit of Measure Code");
              IF BinContent2.FINDFIRST THEN BEGIN
                TempBinContent := BinContent2;
                TempBinContent.VALIDATE("Unit of Measure Code",UOMCode);
                IF TempBinContent.INSERT THEN;
              END;
            END;
          UNTIL NEXT = 0;
      END;
      TempWhseActivLine.COPY(WhseActivLine2);
      EXIT(NOT TempBinContent.ISEMPTY);
    END;

    LOCAL PROCEDURE FindPickBin(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];ToBinCode : Code[20];VAR TempWhseActivLine2 : Record 5767 TEMPORARY;VAR TotalQtytoPick : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;CrossDock : Boolean;VAR TotalQtytoPickBase : Decimal);
    VAR
      FromBinContent : Record 7302;
      FromQtyToPick : Decimal;
      FromQtyToPickBase : Decimal;
      ToQtyToPick : Decimal;
      ToQtyToPickBase : Decimal;
      TotalAvailQtyToPickBase : Decimal;
      AvailableQtyBase : Decimal;
      BinIsForPick : Boolean;
      BinIsForReplenishment : Boolean;
    BEGIN
      // Directed put-away and pick
      GetBin(LocationCode,ToBinCode);
      GetLocation(LocationCode);
      WITH FromBinContent DO
        IF BinContentExists(FromBinContent,ItemNo,LocationCode,UnitofMeasureCode,VariantCode,CrossDock,TRUE,TRUE) THEN BEGIN
          TotalAvailQtyToPickBase :=
            CalcTotalAvailQtyToPick(
              LocationCode,ItemNo,VariantCode,
              TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.",
              SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,TotalQtytoPickBase,FALSE);
          IF TotalAvailQtyToPickBase < 0 THEN
            TotalAvailQtyToPickBase := 0;

          REPEAT
            BinIsForPick := UseForPick(FromBinContent) AND (WhseSource <> WhseSource::"Movement Worksheet");
            BinIsForReplenishment := UseForReplenishment(FromBinContent) AND (WhseSource = WhseSource::"Movement Worksheet");
            IF "Bin Code" <> ToBinCode THEN
              CalcBinAvailQtyToPick(AvailableQtyBase,FromBinContent,TempWhseActivLine2);
            IF BinIsForPick OR BinIsForReplenishment THEN BEGIN
              IF TotalAvailQtyToPickBase < AvailableQtyBase THEN
                AvailableQtyBase := TotalAvailQtyToPickBase;

              IF TotalQtytoPickBase < AvailableQtyBase THEN
                AvailableQtyBase := TotalQtytoPickBase;

              OnCalcAvailQtyOnFindPickBin(
                ItemNo,VariantCode,SNRequired,LNRequired,WhseItemTrkgExists,
                TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.","Location Code","Bin Code",
                SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo,TotalQtytoPickBase,AvailableQtyBase);


              IF AvailableQtyBase > 0 THEN BEGIN
                ToQtyToPickBase := CalcQtyToPickBase(FromBinContent);
                IF AvailableQtyBase > ToQtyToPickBase THEN
                  AvailableQtyBase := ToQtyToPickBase;

                UpdateQuantitiesToPick(
                  AvailableQtyBase,
                  "Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,
                  "Qty. per Unit of Measure",ToQtyToPick,ToQtyToPickBase,
                  TotalQtytoPick,TotalQtytoPickBase);

                CreateTempActivityLine(
                  LocationCode,"Bin Code",UnitofMeasureCode,"Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,1,0);
                CreateTempActivityLine(
                  LocationCode,ToBinCode,UnitofMeasureCode,"Qty. per Unit of Measure",ToQtyToPick,ToQtyToPickBase,2,0);

                TotalAvailQtyToPickBase := TotalAvailQtyToPickBase - ToQtyToPickBase;
              END;
            END ELSE
              EnqueueCannotBeHandledReason(
                GetMessageForUnhandledQtyDueToBin(
                  BinIsForPick,BinIsForReplenishment,WhseSource = WhseSource::"Movement Worksheet",AvailableQtyBase,"Bin Code"));
          UNTIL (NEXT = 0) OR (TotalQtytoPickBase = 0);
        END;
    END;

    LOCAL PROCEDURE FindBreakBulkBin(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];ToUOMCode : Code[10];ToBinCode : Code[20];ToQtyPerUOM : Decimal;VAR TempWhseActivLine2 : Record 5767 TEMPORARY;VAR TotalQtytoPick : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;CrossDock : Boolean;VAR TotalQtytoPickBase : Decimal);
    VAR
      FromItemUOM : Record 5404;
      FromBinContent : Record 7302;
      FromQtyToPick : Decimal;
      FromQtyToPickBase : Decimal;
      ToQtyToPick : Decimal;
      ToQtyToPickBase : Decimal;
      QtyAvailableBase : Decimal;
      TotalAvailQtyToPickBase : Decimal;
    BEGIN
      // Directed put-away and pick
      GetBin(LocationCode,ToBinCode);

      TotalAvailQtyToPickBase :=
        CalcTotalAvailQtyToPick(
          LocationCode,ItemNo,VariantCode,TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.",
          SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,0,FALSE);

      IF TotalAvailQtyToPickBase < 0 THEN
        TotalAvailQtyToPickBase := 0;

      IF NOT Location."Always Create Pick Line" THEN BEGIN
        IF TotalAvailQtyToPickBase = 0 THEN
          EXIT;

        IF TotalAvailQtyToPickBase < TotalQtytoPickBase THEN BEGIN
          TotalQtytoPickBase := TotalAvailQtyToPickBase;
          TotalQtytoPick := ROUND(TotalQtytoPickBase / ToQtyPerUOM,0.00001);
        END;
      END;

      FromItemUOM.SETCURRENTKEY("Item No.","Qty. per Unit of Measure");
      FromItemUOM.SETRANGE("Item No.",ItemNo);
      FromItemUOM.SETFILTER("Qty. per Unit of Measure",'>=%1',ToQtyPerUOM);
      FromItemUOM.SETFILTER(Code,'<>%1',ToUOMCode);
      IF FromItemUOM.FIND('-') THEN
        WITH FromBinContent DO
          REPEAT
            IF BinContentExists(
                 FromBinContent,ItemNo,LocationCode,FromItemUOM.Code,VariantCode,CrossDock,LNRequired,SNRequired)
            THEN
              REPEAT
                IF ("Bin Code" <> ToBinCode) AND
                   ((UseForPick(FromBinContent) AND (WhseSource <> WhseSource::"Movement Worksheet")) OR
                    (UseForReplenishment(FromBinContent) AND (WhseSource = WhseSource::"Movement Worksheet")))
                THEN BEGIN
                  // Check and use bulk that has previously been broken
                  QtyAvailableBase := CalcBinAvailQtyInBreakbulk(TempWhseActivLine2,FromBinContent,ToUOMCode);

                  OnCalcAvailQtyOnFindBreakBulkBin(
                    TRUE,ItemNo,VariantCode,SNRequired,LNRequired,WhseItemTrkgExists,
                    TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.","Location Code","Bin Code",
                    SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo,TotalQtytoPickBase,QtyAvailableBase);

                  IF QtyAvailableBase > 0 THEN BEGIN
                    UpdateQuantitiesToPick(
                      QtyAvailableBase,
                      ToQtyPerUOM,FromQtyToPick,FromQtyToPickBase,
                      ToQtyPerUOM,ToQtyToPick,ToQtyToPickBase,
                      TotalQtytoPick,TotalQtytoPickBase);

                    CreateBreakBulkTempLines(
                      "Location Code",ToUOMCode,ToUOMCode,
                      "Bin Code",ToBinCode,ToQtyPerUOM,ToQtyPerUOM,
                      0,FromQtyToPick,FromQtyToPickBase,ToQtyToPick,ToQtyToPickBase);
                  END;

                  IF TotalQtytoPickBase <= 0 THEN
                    EXIT;

                  // Now break bulk and use
                  QtyAvailableBase := CalcBinAvailQtyToBreakbulk(TempWhseActivLine2,FromBinContent);

                  OnCalcAvailQtyOnFindBreakBulkBin(
                    FALSE,ItemNo,VariantCode,SNRequired,LNRequired,WhseItemTrkgExists,
                    TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.","Location Code","Bin Code",
                    SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo,TotalQtytoPickBase,QtyAvailableBase);

                  IF QtyAvailableBase > 0 THEN BEGIN
                    FromItemUOM.GET(ItemNo,"Unit of Measure Code");
                    UpdateQuantitiesToPick(
                      QtyAvailableBase,
                      FromItemUOM."Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,
                      ToQtyPerUOM,ToQtyToPick,ToQtyToPickBase,
                      TotalQtytoPick,TotalQtytoPickBase);

                    BreakbulkNo := BreakbulkNo + 1;
                    CreateBreakBulkTempLines(
                      "Location Code","Unit of Measure Code",ToUOMCode,
                      "Bin Code",ToBinCode,FromItemUOM."Qty. per Unit of Measure",ToQtyPerUOM,
                      BreakbulkNo,ToQtyToPick,ToQtyToPickBase,FromQtyToPick,FromQtyToPickBase);
                  END;
                  IF TotalQtytoPickBase <= 0 THEN
                    EXIT;
                END;
              UNTIL NEXT = 0;
          UNTIL FromItemUOM.NEXT = 0;
    END;

    LOCAL PROCEDURE FindSmallerUOMBin(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];ToBinCode : Code[20];QtyPerUnitOfMeasure : Decimal;VAR TotalQtytoPick : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;CrossDock : Boolean;VAR TotalQtytoPickBase : Decimal);
    VAR
      ItemUOM : Record 5404;
      FromBinContent : Record 7302;
      TempFromBinContent : Record 7302 TEMPORARY;
      FromQtyToPick : Decimal;
      FromQtyToPickBase : Decimal;
      ToQtyToPick : Decimal;
      ToQtyToPickBase : Decimal;
      QtyAvailableBase : Decimal;
      TotalAvailQtyToPickBase : Decimal;
    BEGIN
      // Directed put-away and pick
      TotalAvailQtyToPickBase :=
        CalcTotalAvailQtyToPick(
          LocationCode,ItemNo,VariantCode,
          TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.",
          SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,0,FALSE);

      IF TotalAvailQtyToPickBase < 0 THEN
        TotalAvailQtyToPickBase := 0;

      IF NOT Location."Always Create Pick Line" THEN BEGIN
        IF TotalAvailQtyToPickBase = 0 THEN
          EXIT;

        IF TotalAvailQtyToPickBase < TotalQtytoPickBase THEN BEGIN
          TotalQtytoPickBase := TotalAvailQtyToPickBase;
          ItemUOM.GET(ItemNo,UnitofMeasureCode);
          TotalQtytoPick := ROUND(TotalQtytoPickBase / ItemUOM."Qty. per Unit of Measure",0.00001);
        END;
      END;

      GetBin(LocationCode,ToBinCode);

      ItemUOM.SETCURRENTKEY("Item No.","Qty. per Unit of Measure");
      ItemUOM.SETRANGE("Item No.",ItemNo);
      ItemUOM.SETFILTER("Qty. per Unit of Measure",'<%1',QtyPerUnitOfMeasure);
      ItemUOM.SETFILTER(Code,'<>%1',UnitofMeasureCode);
      ItemUOM.ASCENDING(FALSE);
      IF ItemUOM.FIND('-') THEN
        WITH FromBinContent DO
          REPEAT
            IF BinContentExists(FromBinContent,ItemNo,LocationCode,ItemUOM.Code,VariantCode,CrossDock,LNRequired,SNRequired) THEN
              REPEAT
                IF ("Bin Code" <> ToBinCode) AND
                   ((UseForPick(FromBinContent) AND (WhseSource <> WhseSource::"Movement Worksheet")) OR
                    (UseForReplenishment(FromBinContent) AND (WhseSource = WhseSource::"Movement Worksheet")))
                THEN BEGIN
                  CalcBinAvailQtyFromSmallerUOM(QtyAvailableBase,FromBinContent,FALSE);

                  OnCalcAvailQtyOnFindSmallerUOMBin(
                    FALSE,ItemNo,VariantCode,SNRequired,LNRequired,WhseItemTrkgExists,
                    TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.","Location Code","Bin Code",
                    SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo,TotalQtytoPickBase,QtyAvailableBase);

                  IF QtyAvailableBase > 0 THEN BEGIN
                    UpdateQuantitiesToPick(
                      QtyAvailableBase,
                      ItemUOM."Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,
                      QtyPerUnitOfMeasure,ToQtyToPick,ToQtyToPickBase,
                      TotalQtytoPick,TotalQtytoPickBase);

                    CreateTempActivityLine(
                      LocationCode,"Bin Code","Unit of Measure Code",
                      ItemUOM."Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,1,0);
                    CreateTempActivityLine(
                      LocationCode,ToBinCode,UnitofMeasureCode,
                      QtyPerUnitOfMeasure,ToQtyToPick,ToQtyToPickBase,2,0);

                    TotalAvailQtyToPickBase := TotalAvailQtyToPickBase - ToQtyToPickBase;
                  END;
                END;
              UNTIL (NEXT = 0) OR (TotalQtytoPickBase = 0);
            IF TotalQtytoPickBase > 0 THEN
              IF BreakBulkPlacingExists(TempFromBinContent,ItemNo,LocationCode,ItemUOM.Code,VariantCode,CrossDock,LNRequired,SNRequired) THEN
                REPEAT
                  WITH TempFromBinContent DO
                    IF ("Bin Code" <> ToBinCode) AND
                       ((UseForPick(TempFromBinContent) AND (WhseSource <> WhseSource::"Movement Worksheet")) OR
                        (UseForReplenishment(TempFromBinContent) AND (WhseSource = WhseSource::"Movement Worksheet")))
                    THEN BEGIN
                      CalcBinAvailQtyFromSmallerUOM(QtyAvailableBase,TempFromBinContent,TRUE);

                      OnCalcAvailQtyOnFindSmallerUOMBin(
                        TRUE,ItemNo,VariantCode,SNRequired,LNRequired,WhseItemTrkgExists,
                        TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.","Location Code","Bin Code",
                        SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo,TotalQtytoPickBase,QtyAvailableBase);

                      IF QtyAvailableBase > 0 THEN BEGIN
                        UpdateQuantitiesToPick(
                          QtyAvailableBase,
                          ItemUOM."Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,
                          QtyPerUnitOfMeasure,ToQtyToPick,ToQtyToPickBase,
                          TotalQtytoPick,TotalQtytoPickBase);

                        CreateTempActivityLine(
                          LocationCode,"Bin Code","Unit of Measure Code",
                          ItemUOM."Qty. per Unit of Measure",FromQtyToPick,FromQtyToPickBase,1,0);
                        CreateTempActivityLine(
                          LocationCode,ToBinCode,UnitofMeasureCode,
                          QtyPerUnitOfMeasure,ToQtyToPick,ToQtyToPickBase,2,0);
                        TotalAvailQtyToPickBase := TotalAvailQtyToPickBase - ToQtyToPickBase;
                      END;
                    END;
                UNTIL (TempFromBinContent.NEXT = 0) OR (TotalQtytoPickBase = 0);
          UNTIL (ItemUOM.NEXT = 0) OR (TotalQtytoPickBase = 0);
    END;

    // LOCAL PROCEDURE FindWhseActivLine(VAR TempWhseActivLine : Record 5767 TEMPORARY;Location : Record 14;VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20]) : Boolean;
    // BEGIN
    //   TempWhseActivLine.SETRANGE("Location Code",TempWhseActivLine."Location Code");
    //   IF Location."Bin Mandatory" THEN
    //     TempWhseActivLine.SETRANGE("Action Type",TempWhseActivLine."Action Type"::Take)
    //   ELSE
    //     TempWhseActivLine.SETRANGE("Action Type",TempWhseActivLine."Action Type"::" ");

    //   IF NOT TempWhseActivLine.FIND('-') THEN BEGIN
    //     OnAfterFindWhseActivLine(FirstWhseDocNo,LastWhseDocNo);
    //     EXIT(FALSE);
    //   END;

    //   EXIT(TRUE);
    // END;

    LOCAL PROCEDURE CalcBinAvailQtyToPick(VAR QtyToPickBase : Decimal;VAR BinContent : Record 7302;VAR TempWhseActivLine : Record 5767);
    VAR
      AvailableQtyBase : Decimal;
    BEGIN
      WITH TempWhseActivLine DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type",
          "Variant Code","Unit of Measure Code","Breakbulk No.");
        SETRANGE("Item No.",BinContent."Item No.");
        SETRANGE("Bin Code",BinContent."Bin Code");
        SETRANGE("Location Code",BinContent."Location Code");
        SETRANGE("Unit of Measure Code",BinContent."Unit of Measure Code");
        SETRANGE("Variant Code",BinContent."Variant Code");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No.",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No.",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No.",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No.",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END;

        IF Location."Allow Breakbulk" THEN BEGIN
          SETRANGE("Action Type","Action Type"::Place);
          SETFILTER("Breakbulk No.",'<>0');
          CALCSUMS("Qty. (Base)");
          AvailableQtyBase := "Qty. (Base)";
        END;

        SETRANGE("Action Type","Action Type"::Take);
        SETRANGE("Breakbulk No.",0);
        CALCSUMS("Qty. (Base)");
      END;

      QtyToPickBase := BinContent.CalcQtyAvailToPick(AvailableQtyBase - TempWhseActivLine."Qty. (Base)");
    END;

    LOCAL PROCEDURE CalcBinAvailQtyToBreakbulk(VAR TempWhseActivLine2 : Record 5767;VAR BinContent : Record 7302) QtyToPickBase : Decimal;
    BEGIN
      WITH BinContent DO BEGIN
        SetFilterOnUnitOfMeasure;
        CALCFIELDS("Quantity (Base)","Pick Quantity (Base)","Negative Adjmt. Qty. (Base)");
        QtyToPickBase := "Quantity (Base)" - "Pick Quantity (Base)" - "Negative Adjmt. Qty. (Base)";
      END;
      IF QtyToPickBase <= 0 THEN
        EXIT(0);

      WITH TempWhseActivLine2 DO BEGIN
        SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type",
          "Variant Code","Unit of Measure Code","Breakbulk No.");
        SETRANGE("Action Type","Action Type"::Take);
        SETRANGE("Location Code",BinContent."Location Code");
        SETRANGE("Bin Code",BinContent."Bin Code");
        SETRANGE("Item No.",BinContent."Item No.");
        SETRANGE("Unit of Measure Code",BinContent."Unit of Measure Code");
        SETRANGE("Variant Code",BinContent."Variant Code");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No.",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No.",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No.",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No.",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END ELSE
          ClearTrackingFilter;

        ClearSourceFilter;
        SETRANGE("Breakbulk No.");
        CALCSUMS("Qty. (Base)");
        QtyToPickBase := QtyToPickBase - "Qty. (Base)";
        EXIT(QtyToPickBase);
      END;
    END;

    LOCAL PROCEDURE CalcBinAvailQtyInBreakbulk(VAR TempWhseActivLine2 : Record 5767;VAR BinContent : Record 7302;ToUOMCode : Code[10]) QtyToPickBase : Decimal;
    BEGIN
      WITH TempWhseActivLine2 DO BEGIN
        IF (MaxNoOfSourceDoc > 1) OR (MaxNoOfLines <> 0) THEN
          EXIT(0);

        SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type",
          "Variant Code","Unit of Measure Code","Breakbulk No.");
        SETRANGE("Action Type","Action Type"::Take);
        SETRANGE("Location Code",BinContent."Location Code");
        SETRANGE("Bin Code",BinContent."Bin Code");
        SETRANGE("Item No.",BinContent."Item No.");
        SETRANGE("Unit of Measure Code",ToUOMCode);
        SETRANGE("Variant Code",BinContent."Variant Code");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No.",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No.",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No.",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No.",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END ELSE BEGIN
          SETRANGE("Lot No.");
          SETRANGE("Serial No.");
        END;
        SETRANGE("Breakbulk No.",0);
        CALCSUMS("Qty. (Base)");
        QtyToPickBase := "Qty. (Base)";

        SETRANGE("Action Type","Action Type"::Place);
        SETFILTER("Breakbulk No.",'<>0');
        SETRANGE("No.",FORMAT(TempNo));
        IF MaxNoOfSourceDoc = 1 THEN BEGIN
          SETRANGE("Source Type",WhseWkshLine."Source Type");
          SETRANGE("Source Subtype",WhseWkshLine."Source Subtype");
          SETRANGE("Source No.",WhseWkshLine."Source No.");
        END;
        CALCSUMS("Qty. (Base)");
        QtyToPickBase := "Qty. (Base)" - QtyToPickBase;
        EXIT(QtyToPickBase);
      END;
    END;

    LOCAL PROCEDURE CalcBinAvailQtyFromSmallerUOM(VAR AvailableQtyBase : Decimal;VAR BinContent : Record 7302;AllowInitialZero : Boolean);
    BEGIN
      WITH BinContent DO BEGIN
        SetFilterOnUnitOfMeasure;
        CALCFIELDS("Quantity (Base)","Pick Quantity (Base)","Negative Adjmt. Qty. (Base)");
        AvailableQtyBase := "Quantity (Base)" - "Pick Quantity (Base)" - "Negative Adjmt. Qty. (Base)";
      END;
      IF (AvailableQtyBase < 0) OR ((AvailableQtyBase = 0) AND (NOT AllowInitialZero)) THEN
        EXIT;

      WITH TempWhseActivLine DO BEGIN
        SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type",
          "Variant Code","Unit of Measure Code","Breakbulk No.");

        SETRANGE("Item No.",BinContent."Item No.");
        SETRANGE("Bin Code",BinContent."Bin Code");
        SETRANGE("Location Code",BinContent."Location Code");
        SETRANGE("Action Type","Action Type"::Take);
        SETRANGE("Variant Code",BinContent."Variant Code");
        SETRANGE("Unit of Measure Code",BinContent."Unit of Measure Code");
        IF WhseItemTrkgExists THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No.",TempWhseItemTrackingLine."Lot No.")
          ELSE
            SETFILTER("Lot No.",'%1|%2',TempWhseItemTrackingLine."Lot No.",'');
          IF SNRequired THEN
            SETRANGE("Serial No.",TempWhseItemTrackingLine."Serial No.")
          ELSE
            SETFILTER("Serial No.",'%1|%2',TempWhseItemTrackingLine."Serial No.",'');
        END ELSE BEGIN
          SETRANGE("Lot No.");
          SETRANGE("Serial No.");
        END;
        CALCSUMS("Qty. (Base)");
        AvailableQtyBase := AvailableQtyBase - "Qty. (Base)";

        SETRANGE("Action Type","Action Type"::Place);
        SETFILTER("Breakbulk No.",'<>0');
        CALCSUMS("Qty. (Base)");
        AvailableQtyBase := AvailableQtyBase + "Qty. (Base)";
        RESET;
      END;
    END;

    LOCAL PROCEDURE CreateBreakBulkTempLines(LocationCode : Code[10];FromUOMCode : Code[10];ToUOMCode : Code[10];FromBinCode : Code[20];ToBinCode : Code[20];FromQtyPerUOM : Decimal;ToQtyPerUOM : Decimal;BreakbulkNo2 : Integer;ToQtyToPick : Decimal;ToQtyToPickBase : Decimal;FromQtyToPick : Decimal;FromQtyToPickBase : Decimal);
    VAR
      QtyToBreakBulk : Decimal;
    BEGIN
      // Directed put-away and pick
      IF FromUOMCode <> ToUOMCode THEN BEGIN
        CreateTempActivityLine(
          LocationCode,FromBinCode,FromUOMCode,FromQtyPerUOM,FromQtyToPick,FromQtyToPickBase,1,BreakbulkNo2);

        IF FromQtyToPickBase = ToQtyToPickBase THEN
          QtyToBreakBulk := ToQtyToPick
        ELSE
          QtyToBreakBulk := ROUND(FromQtyToPick * FromQtyPerUOM / ToQtyPerUOM,0.00001);
        CreateTempActivityLine(
          LocationCode,FromBinCode,ToUOMCode,ToQtyPerUOM,QtyToBreakBulk,FromQtyToPickBase,2,BreakbulkNo2);
      END;
      CreateTempActivityLine(LocationCode,FromBinCode,ToUOMCode,ToQtyPerUOM,ToQtyToPick,ToQtyToPickBase,1,0);
      CreateTempActivityLine(LocationCode,ToBinCode,ToUOMCode,ToQtyPerUOM,ToQtyToPick,ToQtyToPickBase,2,0);
    END;

    //[External]
    // PROCEDURE CreateWhseDocument(VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20];ShowError : Boolean);
    // VAR
    //   WhseActivLine : Record 5767;
    //   OldNo : Code[20];
    //   OldSourceNo : Code[20];
    //   OldLocationCode : Code[10];
    //   OldBinCode : Code[20];
    //   OldZoneCode : Code[10];
    //   NoOfLines : Integer;
    //   NoOfSourceDoc : Integer;
    //   CreateNewHeader : Boolean;
    //   WhseDocCreated : Boolean;
    //   IsHandled : Boolean;
    // BEGIN
    //   TempWhseActivLine.RESET;
    //   IF NOT TempWhseActivLine.FIND('-') THEN BEGIN
    //     OnCreateWhseDocumentOnBeforeShowError(ShowError);
    //     IF ShowError THEN
    //       ERROR(Text000,DequeueCannotBeHandledReason);
    //     EXIT;
    //   END;

    //   OnBeforeCreateWhseDocument(TempWhseActivLine,WhseSource);

    //   WhseActivHeader.LOCKTABLE;
    //   IF WhseActivHeader.FINDLAST THEN;
    //   WhseActivLine.LOCKTABLE;
    //   IF WhseActivLine.FINDLAST THEN;

    //   IF WhseSource = WhseSource::"Movement Worksheet" THEN
    //     TempWhseActivLine.SETRANGE("Activity Type",TempWhseActivLine."Activity Type"::Movement)
    //   ELSE
    //     TempWhseActivLine.SETRANGE("Activity Type",TempWhseActivLine."Activity Type"::Pick);

    //   NoOfLines := 0;
    //   NoOfSourceDoc := 0;

    //   REPEAT
    //     GetLocation(TempWhseActivLine."Location Code");
    //     IF NOT FindWhseActivLine(TempWhseActivLine,Location,FirstWhseDocNo,LastWhseDocNo) THEN
    //       EXIT;

    //     IF PerBin THEN
    //       TempWhseActivLine.SETRANGE("Bin Code",TempWhseActivLine."Bin Code");
    //     IF PerZone THEN
    //       TempWhseActivLine.SETRANGE("Zone Code",TempWhseActivLine."Zone Code");

    //     OnCreateWhseDocumentOnAfterSetFiltersBeforeLoop(TempWhseActivLine,PerBin,PerZone);

    //     REPEAT
    //       IsHandled := FALSE;
    //       CreateNewHeader := FALSE;
    //       OnCreateWhseDocumentOnBeforeCreateDocAndLine(TempWhseActivLine,IsHandled,CreateNewHeader);
    //       IF IsHandled THEN BEGIN
    //         IF CreateNewHeader THEN BEGIN
    //           CreateWhseActivHeader(
    //             TempWhseActivLine."Location Code",FirstWhseDocNo,LastWhseDocNo,
    //             NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //           CreateWhseDocLine;
    //         END ELSE
    //           CreateNewWhseDoc(
    //             OldNo,OldSourceNo,OldLocationCode,FirstWhseDocNo,LastWhseDocNo,
    //             NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //       END ELSE
    //         IF PerBin THEN BEGIN
    //           IF TempWhseActivLine."Bin Code" <> OldBinCode THEN BEGIN
    //             CreateWhseActivHeader(
    //               TempWhseActivLine."Location Code",FirstWhseDocNo,LastWhseDocNo,
    //               NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //             CreateWhseDocLine;
    //           END ELSE
    //             CreateNewWhseDoc(
    //               OldNo,OldSourceNo,OldLocationCode,FirstWhseDocNo,LastWhseDocNo,
    //               NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //         END ELSE BEGIN
    //           IF PerZone THEN BEGIN
    //             IF TempWhseActivLine."Zone Code" <> OldZoneCode THEN BEGIN
    //               CreateWhseActivHeader(
    //                 TempWhseActivLine."Location Code",FirstWhseDocNo,LastWhseDocNo,
    //                 NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //               CreateWhseDocLine;
    //             END ELSE
    //               CreateNewWhseDoc(
    //                 OldNo,OldSourceNo,OldLocationCode,FirstWhseDocNo,LastWhseDocNo,
    //                 NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //           END ELSE
    //             CreateNewWhseDoc(
    //               OldNo,OldSourceNo,OldLocationCode,FirstWhseDocNo,LastWhseDocNo,
    //               NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //         END;

    //       OldZoneCode := TempWhseActivLine."Zone Code";
    //       OldBinCode := TempWhseActivLine."Bin Code";
    //       OldNo := TempWhseActivLine."No.";
    //       OldSourceNo := TempWhseActivLine."Source No.";
    //       OldLocationCode := TempWhseActivLine."Location Code";
    //       OnCreateWhseDocumentOnAfterSaveOldValues(TempWhseActivLine);
    //     UNTIL TempWhseActivLine.NEXT = 0;
    //     OnCreateWhseDocumentOnBeforeClearFilters(TempWhseActivLine);
    //     TempWhseActivLine.SETRANGE("Bin Code");
    //     TempWhseActivLine.SETRANGE("Zone Code");
    //     TempWhseActivLine.SETRANGE("Location Code");
    //     TempWhseActivLine.SETRANGE("Action Type");
    //     OnCreateWhseDocumentOnAfterSetFiltersAfterLoop(TempWhseActivLine);
    //     IF NOT TempWhseActivLine.FIND('-') THEN BEGIN
    //       OnAfterCreateWhseDocument(FirstWhseDocNo,LastWhseDocNo);
    //       EXIT;
    //     END;

    //   UNTIL FALSE;
    // END;

    // LOCAL PROCEDURE CreateNewWhseDoc(OldNo : Code[20];OldSourceNo : Code[20];OldLocationCode : Code[10];VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20];VAR NoOfSourceDoc : Integer;VAR NoOfLines : Integer;VAR WhseDocCreated : Boolean);
    // BEGIN
    //   OnBeforeCreateNewWhseDoc(
    //     TempWhseActivLine,OldNo,OldSourceNo,OldLocationCode,FirstWhseDocNo,LastWhseDocNo,NoOfSourceDoc,NoOfLines,WhseDocCreated);

    //   IF (TempWhseActivLine."No." <> OldNo) OR
    //      (TempWhseActivLine."Location Code" <> OldLocationCode)
    //   THEN BEGIN
    //     CreateWhseActivHeader(
    //       TempWhseActivLine."Location Code",FirstWhseDocNo,LastWhseDocNo,
    //       NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //     CreateWhseDocLine;
    //   END ELSE BEGIN
    //     NoOfLines := NoOfLines + 1;
    //     IF TempWhseActivLine."Source No." <> OldSourceNo THEN
    //       NoOfSourceDoc := NoOfSourceDoc + 1;
    //     IF (MaxNoOfSourceDoc > 0) AND (NoOfSourceDoc > MaxNoOfSourceDoc) THEN
    //       CreateWhseActivHeader(
    //         TempWhseActivLine."Location Code",FirstWhseDocNo,LastWhseDocNo,
    //         NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //     IF (MaxNoOfLines > 0) AND (NoOfLines > MaxNoOfLines) THEN
    //       CreateWhseActivHeader(
    //         TempWhseActivLine."Location Code",FirstWhseDocNo,LastWhseDocNo,
    //         NoOfSourceDoc,NoOfLines,WhseDocCreated);
    //     CreateWhseDocLine;
    //   END;
    // END;

    // LOCAL PROCEDURE CreateWhseActivHeader(LocationCode : Code[10];VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20];VAR NoOfSourceDoc : Integer;VAR NoOfLines : Integer;VAR WhseDocCreated : Boolean);
    // BEGIN
    //   WhseActivHeader.INIT;
    //   WhseActivHeader."No." := '';
    //   IF WhseDocType = WhseDocType::Movement THEN
    //     WhseActivHeader.Type := WhseActivHeader.Type::Movement
    //   ELSE
    //     WhseActivHeader.Type := WhseActivHeader.Type::Pick;
    //   WhseActivHeader."Location Code" := LocationCode;
    //   IF AssignedID <> '' THEN
    //     WhseActivHeader.VALIDATE("Assigned User ID",AssignedID);
    //   WhseActivHeader."Sorting Method" := SortPick;
    //   WhseActivHeader."Breakbulk Filter" := BreakbulkFilter;
    //   OnBeforeWhseActivHeaderInsert(WhseActivHeader);
    //   WhseActivHeader.INSERT(TRUE);

    //   NoOfLines := 1 ;
    //   NoOfSourceDoc := 1;

    //   IF NOT WhseDocCreated THEN BEGIN
    //     FirstWhseDocNo := WhseActivHeader."No.";
    //     WhseDocCreated := TRUE;
    //   END;
    //   LastWhseDocNo := WhseActivHeader."No.";
    // END;

    LOCAL PROCEDURE CreateWhseDocLine();
    VAR
      WhseActivLine : Record 5767;
      LineNo : Integer;
    BEGIN
      TempWhseActivLine.SETRANGE("Breakbulk No.",0);
      TempWhseActivLine.FIND('-');
      WhseActivLine.SETRANGE("Activity Type",WhseActivHeader.Type);
      WhseActivLine.SETRANGE("No.",WhseActivHeader."No.");
      IF WhseActivLine.FINDLAST THEN
        LineNo := WhseActivLine."Line No."
      ELSE
        LineNo := 0;

      ItemTrackingMgt1.CheckWhseItemTrkgSetup(
        TempWhseActivLine."Item No.",SNRequired,LNRequired,FALSE);

      LineNo := LineNo + 10000;
      WhseActivLine.INIT;
      WhseActivLine := TempWhseActivLine;
      WhseActivLine."No." := WhseActivHeader."No.";
      IF NOT (WhseActivLine."Whse. Document Type" IN [
                                                      WhseActivLine."Whse. Document Type"::"Internal Pick",
                                                      WhseActivLine."Whse. Document Type"::"Movement Worksheet"])
      THEN
        WhseActivLine."Source Document" := Enum::"Warehouse Activity Source Document".FromInteger(WhseMgt.GetSourceDocument(WhseActivLine."Source Type",WhseActivLine."Source Subtype"));

      IF Location."Bin Mandatory" AND (NOT SNRequired) THEN
        CreateWhseDocTakeLine(WhseActivLine,LineNo)
      ELSE
        TempWhseActivLine.DELETE;

      IF WhseActivLine."Qty. (Base)" <> 0 THEN BEGIN
        WhseActivLine."Line No." := LineNo;
        IF DoNotFillQtytoHandle THEN BEGIN
          WhseActivLine."Qty. to Handle" := 0;
          WhseActivLine."Qty. to Handle (Base)" := 0;
          WhseActivLine.Cubage := 0;
          WhseActivLine.Weight := 0;
        END;
        OnBeforeWhseActivLineInsert(WhseActivLine,WhseActivHeader);
        WhseActivLine.INSERT;
        OnAfterWhseActivLineInsert(WhseActivLine);
      END;

      IF Location."Bin Mandatory" THEN
        CreateWhseDocPlaceLine(WhseActivLine.Quantity,WhseActivLine."Qty. (Base)",LineNo);
    END;

    LOCAL PROCEDURE CreateWhseDocTakeLine(VAR WhseActivLine : Record 5767;VAR LineNo : Integer);
    VAR
      WhseActivLine2 : Record 5767;
      TempWhseActivLine2 : Record 5767 TEMPORARY;
      WhseActivLine3 : Record 5767;
    BEGIN
      TempWhseActivLine2.COPY(TempWhseActivLine);
      TempWhseActivLine.SETCURRENTKEY(
        "Whse. Document No.","Whse. Document Type","Activity Type","Whse. Document Line No.","Action Type");
      TempWhseActivLine.DELETE;

      TempWhseActivLine.SETRANGE("Whse. Document Type",TempWhseActivLine2."Whse. Document Type");
      TempWhseActivLine.SETRANGE("Whse. Document No.",TempWhseActivLine2."Whse. Document No.");
      TempWhseActivLine.SETRANGE("Activity Type",TempWhseActivLine2."Activity Type");
      TempWhseActivLine.SETRANGE("Whse. Document Line No.",TempWhseActivLine2."Whse. Document Line No.");
      TempWhseActivLine.SETRANGE("Action Type",TempWhseActivLine2."Action Type"::Take);
      TempWhseActivLine.SetSourceFilter(
        TempWhseActivLine2."Source Type",TempWhseActivLine2."Source Subtype",TempWhseActivLine2."Source No.",
        TempWhseActivLine2."Source Line No.",TempWhseActivLine2."Source Subline No.",FALSE);
      TempWhseActivLine.SETRANGE("No.",TempWhseActivLine2."No.");
      TempWhseActivLine.SETFILTER("Line No.",'>%1',TempWhseActivLine2."Line No.");
      TempWhseActivLine.SETRANGE("Bin Code",TempWhseActivLine2."Bin Code");
      TempWhseActivLine.SETRANGE("Unit of Measure Code",WhseActivLine."Unit of Measure Code");
      TempWhseActivLine.SETRANGE("Zone Code");
      TempWhseActivLine.SETRANGE("Breakbulk No.",0);
      // TempWhseActivLine.SetTrackingFilter(TempWhseActivLine2."Serial No.",TempWhseActivLine2."Lot No.");
      OnCreateWhseDocTakeLineOnAfterSetFilters(TempWhseActivLine,TempWhseActivLine2);
      IF TempWhseActivLine.FIND('-') THEN BEGIN
        REPEAT
          WhseActivLine.Quantity := WhseActivLine.Quantity + TempWhseActivLine.Quantity;
        UNTIL TempWhseActivLine.NEXT = 0;
        TempWhseActivLine.DELETEALL;
        WhseActivLine.VALIDATE(Quantity);
      END;

      // insert breakbulk lines
      IF Location."Directed Put-away and Pick" THEN BEGIN
        TempWhseActivLine.ClearSourceFilter;
        TempWhseActivLine.SETRANGE("Line No.");
        TempWhseActivLine.SETRANGE("Unit of Measure Code");
        TempWhseActivLine.SETFILTER("Breakbulk No.",'<>0');
        IF TempWhseActivLine.FIND('-') THEN
          REPEAT
            WhseActivLine2.INIT;
            WhseActivLine2 := TempWhseActivLine;
            WhseActivLine2."No." := WhseActivHeader."No.";
            WhseActivLine2."Line No." := LineNo;
            WhseActivLine2."Source Document" := WhseActivLine."Source Document";

            IF DoNotFillQtytoHandle THEN BEGIN
              WhseActivLine2."Qty. to Handle" := 0;
              WhseActivLine2."Qty. to Handle (Base)" := 0;
              WhseActivLine2.Cubage := 0;
              WhseActivLine2.Weight := 0;
            END;
            WhseActivLine2.INSERT;
            OnAfterWhseActivLineInsert(WhseActivLine2);

            TempWhseActivLine.DELETE;
            LineNo := LineNo + 10000;

            WhseActivLine3.COPY(TempWhseActivLine);
            TempWhseActivLine.SETRANGE("Action Type",TempWhseActivLine."Action Type"::Place);
            TempWhseActivLine.SETRANGE("Line No.");
            TempWhseActivLine.SETRANGE("Unit of Measure Code",WhseActivLine."Unit of Measure Code");
            TempWhseActivLine.SETRANGE("Breakbulk No.",TempWhseActivLine."Breakbulk No.");
            TempWhseActivLine.FIND('-');

            WhseActivLine2.INIT;
            WhseActivLine2 := TempWhseActivLine;
            WhseActivLine2."No." := WhseActivHeader."No.";
            WhseActivLine2."Line No." := LineNo;
            WhseActivLine2."Source Document" := WhseActivLine."Source Document";

            IF DoNotFillQtytoHandle THEN BEGIN
              WhseActivLine2."Qty. to Handle" := 0;
              WhseActivLine2."Qty. to Handle (Base)" := 0;
              WhseActivLine2.Cubage := 0;
              WhseActivLine2.Weight := 0;
            END;

            WhseActivLine2."Original Breakbulk" :=
              WhseActivLine."Qty. (Base)" = WhseActivLine2."Qty. (Base)";
            IF BreakbulkFilter THEN
              WhseActivLine2.Breakbulk := WhseActivLine2."Original Breakbulk";
            WhseActivLine2.INSERT;
            OnAfterWhseActivLineInsert(WhseActivLine2);

            TempWhseActivLine.DELETE;
            LineNo := LineNo + 10000;

            TempWhseActivLine.COPY(WhseActivLine3);
            WhseActivLine."Original Breakbulk" := WhseActivLine2."Original Breakbulk";
            IF BreakbulkFilter THEN
              WhseActivLine.Breakbulk := WhseActivLine."Original Breakbulk";
          UNTIL TempWhseActivLine.NEXT = 0;
      END;

      TempWhseActivLine.COPY(TempWhseActivLine2);
    END;

    LOCAL PROCEDURE CreateWhseDocPlaceLine(PickQty : Decimal;PickQtyBase : Decimal;VAR LineNo : Integer);
    VAR
      WhseActivLine : Record 5767;
      TempWhseActivLine2 : Record 5767 TEMPORARY;
      TempWhseActivLine3 : Record 5767 TEMPORARY;
    BEGIN
      TempWhseActivLine2.COPY(TempWhseActivLine);
      TempWhseActivLine.SETCURRENTKEY(
        "Whse. Document No.","Whse. Document Type","Activity Type","Whse. Document Line No.","Action Type");
      TempWhseActivLine.SETRANGE("Whse. Document No.",TempWhseActivLine2."Whse. Document No.");
      TempWhseActivLine.SETRANGE("Whse. Document Type",TempWhseActivLine2."Whse. Document Type");
      TempWhseActivLine.SETRANGE("Activity Type",TempWhseActivLine2."Activity Type");
      TempWhseActivLine.SETRANGE("Whse. Document Line No.",TempWhseActivLine2."Whse. Document Line No.");
      TempWhseActivLine.SETRANGE("Source Subline No.",TempWhseActivLine2."Source Subline No.");
      TempWhseActivLine.SETRANGE("No.",TempWhseActivLine2."No.");
      TempWhseActivLine.SETRANGE("Action Type",TempWhseActivLine2."Action Type"::Place);
      TempWhseActivLine.SETFILTER("Line No.",'>%1',TempWhseActivLine2."Line No.");
      TempWhseActivLine.SETRANGE("Bin Code");
      TempWhseActivLine.SETRANGE("Zone Code");
      TempWhseActivLine.SETRANGE("Item No.",TempWhseActivLine2."Item No.");
      TempWhseActivLine.SETRANGE("Variant Code",TempWhseActivLine2."Variant Code");
      TempWhseActivLine.SETRANGE("Breakbulk No.",0);
      // TempWhseActivLine.SetTrackingFilter(TempWhseActivLine2."Serial No.",TempWhseActivLine2."Lot No.");
      OnCreateWhseDocPlaceLineOnAfterSetFilters(TempWhseActivLine,TempWhseActivLine2);
      IF TempWhseActivLine.FIND('-') THEN
        REPEAT
          LineNo := LineNo + 10000;
          WhseActivLine.INIT;
          WhseActivLine := TempWhseActivLine;

          WITH WhseActivLine DO
            IF (PickQty * "Qty. per Unit of Measure") <> PickQtyBase THEN
              PickQty := ROUND(PickQtyBase / "Qty. per Unit of Measure",0.00001);

          PickQtyBase := PickQtyBase - WhseActivLine."Qty. (Base)";
          PickQty := PickQty - WhseActivLine.Quantity;

          WhseActivLine."No." := WhseActivHeader."No.";
          WhseActivLine."Line No." := LineNo;

          IF NOT (WhseActivLine."Whse. Document Type" IN [
                                                          WhseActivLine."Whse. Document Type"::"Internal Pick",
                                                          WhseActivLine."Whse. Document Type"::"Movement Worksheet"])
          THEN
            WhseActivLine."Source Document" := Enum::"Warehouse Activity Source Document".FromInteger(WhseMgt.GetSourceDocument(WhseActivLine."Source Type",WhseActivLine."Source Subtype"));

          TempWhseActivLine.DELETE;
          IF PickQtyBase > 0 THEN BEGIN
            TempWhseActivLine3.COPY(TempWhseActivLine);
            TempWhseActivLine.SETRANGE(
              "Unit of Measure Code",WhseActivLine."Unit of Measure Code");
            TempWhseActivLine.SETFILTER("Line No.",'>%1',TempWhseActivLine."Line No.");
            TempWhseActivLine.SETRANGE("No.",TempWhseActivLine2."No.");
            TempWhseActivLine.SETRANGE("Bin Code",WhseActivLine."Bin Code");
            IF TempWhseActivLine.FIND('-') THEN BEGIN
              REPEAT
                IF TempWhseActivLine."Qty. (Base)" >= PickQtyBase THEN BEGIN
                  WhseActivLine.Quantity := WhseActivLine.Quantity + PickQty;
                  WhseActivLine."Qty. (Base)" := WhseActivLine."Qty. (Base)" + PickQtyBase;
                  PickQty := 0;
                  PickQtyBase := 0;
                END ELSE BEGIN
                  WhseActivLine.Quantity := WhseActivLine.Quantity + TempWhseActivLine.Quantity;
                  WhseActivLine."Qty. (Base)" := WhseActivLine."Qty. (Base)" + TempWhseActivLine."Qty. (Base)";
                  PickQty := PickQty - TempWhseActivLine.Quantity;
                  PickQtyBase := PickQtyBase - TempWhseActivLine."Qty. (Base)";
                  TempWhseActivLine.DELETE;
                END;
              UNTIL (TempWhseActivLine.NEXT = 0) OR (PickQtyBase = 0);
            END ELSE
              IF TempWhseActivLine.DELETE THEN;
            TempWhseActivLine.COPY(TempWhseActivLine3);
          END;

          IF WhseActivLine.Quantity > 0 THEN BEGIN
            TempWhseActivLine3 := WhseActivLine;
            WhseActivLine.VALIDATE(Quantity);
            WhseActivLine."Qty. (Base)" := TempWhseActivLine3."Qty. (Base)";
            WhseActivLine."Qty. Outstanding (Base)" := TempWhseActivLine3."Qty. (Base)";
            WhseActivLine."Qty. to Handle (Base)" := TempWhseActivLine3."Qty. (Base)";
            IF DoNotFillQtytoHandle THEN BEGIN
              WhseActivLine."Qty. to Handle" := 0;
              WhseActivLine."Qty. to Handle (Base)" := 0;
              WhseActivLine.Cubage := 0;
              WhseActivLine.Weight := 0;
            END;
            WhseActivLine.INSERT;
            OnAfterWhseActivLineInsert(WhseActivLine);
          END;
        UNTIL (TempWhseActivLine.NEXT = 0) OR (PickQtyBase = 0);

      TempWhseActivLine.COPY(TempWhseActivLine2);
    END;

    LOCAL PROCEDURE AssignSpecEquipment(LocationCode : Code[10];BinCode : Code[20];ItemNo : Code[20];VariantCode : Code[10]) : Code[10];
    BEGIN
      IF (BinCode <> '') AND
         (Location."Special Equipment" =
          Location."Special Equipment"::"According to Bin")
      THEN BEGIN
        GetBin(LocationCode,BinCode);
        IF Bin."Special Equipment Code" <> '' THEN
          EXIT(Bin."Special Equipment Code");

        GetSKU(LocationCode,ItemNo,VariantCode);
        IF SKU."Special Equipment Code" <> '' THEN
          EXIT(SKU."Special Equipment Code");

        GetItem(ItemNo);
        EXIT(Item."Special Equipment Code");
      END;
      GetSKU(LocationCode,ItemNo,VariantCode);
      IF SKU."Special Equipment Code" <> '' THEN
        EXIT(SKU."Special Equipment Code");

      GetItem(ItemNo);
      IF Item."Special Equipment Code" <> '' THEN
        EXIT(Item."Special Equipment Code");

      GetBin(LocationCode,BinCode);
      EXIT(Bin."Special Equipment Code");
    END;

    LOCAL PROCEDURE CalcAvailableQty(ItemNo : Code[20];VariantCode : Code[10]) : Decimal;
    VAR
      AvailableQtyBase : Decimal;
      LineReservedQty : Decimal;
      QtyReservedOnPickShip : Decimal;
      WhseSource2 : Option;
    BEGIN
      // For locations with pick/ship and without directed put-away and pick
      GetItem(ItemNo);
      AvailableQtyBase := WhseAvailMgt.CalcInvtAvailQty(Item,Location,VariantCode,TempWhseActivLine);

      IF (WhseSource = WhseSource::Shipment) AND WhseShptLine."Assemble to Order" THEN
        WhseSource2 := WhseSource::Assembly
      ELSE
        WhseSource2 := WhseSource;
      CASE WhseSource2 OF
        // WhseSource::"Pick Worksheet",WhseSource::"Movement Worksheet":
        //   LineReservedQty :=
            // WhseAvailMgt.CalcLineReservedQtyOnInvt(
            //   WhseWkshLine."Source Type",
            //   WhseWkshLine."Source Subtype",
            //   WhseWkshLine."Source No.",
            //   WhseWkshLine."Source Line No.",
            //   WhseWkshLine."Source Subline No.",
            //   TRUE,'','',TempWhseActivLine);
        // WhseSource::Shipment:
        //   LineReservedQty :=
        //     WhseAvailMgt.CalcLineReservedQtyOnInvt(
        //       WhseShptLine."Source Type",
        //       WhseShptLine."Source Subtype",
        //       WhseShptLine."Source No.",
        //       WhseShptLine."Source Line No.",
        //       0,
        //       TRUE,'','',TempWhseActivLine);
        // WhseSource::Production:
        //   LineReservedQty :=
        //     WhseAvailMgt.CalcLineReservedQtyOnInvt(
        //       DATABASE::"Prod. Order Component",
        //       ProdOrderCompLine.Status,
        //       ProdOrderCompLine."Prod. Order No.",
        //       ProdOrderCompLine."Prod. Order Line No.",
        //       ProdOrderCompLine."Line No.",
        //       TRUE,'','',TempWhseActivLine);
        // WhseSource::Assembly:
        //   LineReservedQty :=
        //     WhseAvailMgt.CalcLineReservedQtyOnInvt(
        //       DATABASE::"Assembly Line",
        //       AssemblyLine."Document Type",
        //       AssemblyLine."Document No.",
        //       AssemblyLine."Line No.",
        //       0,
        //       TRUE,'','',TempWhseActivLine);
      END;

      QtyReservedOnPickShip := WhseAvailMgt.CalcReservQtyOnPicksShips(Location.Code,ItemNo,VariantCode,TempWhseActivLine);

      EXIT(AvailableQtyBase + LineReservedQty + QtyReservedOnPickShip);
    END;

    LOCAL PROCEDURE CalcPickQtyAssigned(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UOMCode : Code[10];BinCode : Code[20];VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY) PickQtyAssigned : Decimal;
    VAR
      WhseActivLine2 : Record 5767;
    BEGIN
      WhseActivLine2.COPY(TempWhseActivLine);
      WITH TempWhseActivLine DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type","Variant Code",
          "Unit of Measure Code","Breakbulk No.","Activity Type","Lot No.","Serial No.");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Location Code",LocationCode);
        IF Location."Bin Mandatory" THEN BEGIN
          SETRANGE("Action Type","Action Type"::Take);
          IF BinCode <> '' THEN
            SETRANGE("Bin Code",BinCode)
          ELSE
            SETFILTER("Bin Code",'<>%1','');
        END ELSE BEGIN
          SETRANGE("Action Type","Action Type"::" ");
          SETRANGE("Bin Code",'');
        END;
        SETRANGE("Variant Code",VariantCode);
        IF UOMCode <> '' THEN
          SETRANGE("Unit of Measure Code",UOMCode);
        SETRANGE("Activity Type","Activity Type");
        SETRANGE("Breakbulk No.",0);
        IF WhseItemTrkgExists THEN BEGIN
          IF TempWhseItemTrackingLine."Lot No." <> '' THEN
            SETRANGE("Lot No.",TempWhseItemTrackingLine."Lot No.");
          IF TempWhseItemTrackingLine."Serial No." <> '' THEN
            SETRANGE("Serial No.",TempWhseItemTrackingLine."Serial No.");
        END;
        CALCSUMS("Qty. Outstanding (Base)");
        PickQtyAssigned := "Qty. Outstanding (Base)";
      END;
      TempWhseActivLine.COPY(WhseActivLine2);
      EXIT(PickQtyAssigned);
    END;

    LOCAL PROCEDURE CalcQtyAssignedToPick(ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];BinCode : Code[20];LotNo : Code[50];LNRequired : Boolean;SerialNo : Code[50];SNRequired : Boolean) : Decimal;
    VAR
      WhseActivLine : Record 5767;
    BEGIN
      WITH WhseActivLine DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Item No.","Location Code","Activity Type","Bin Type Code",
          "Unit of Measure Code","Variant Code","Breakbulk No.","Action Type");

        SETRANGE("Item No.",ItemNo);
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Activity Type","Activity Type"::Pick);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE("Breakbulk No.",0);
        SETFILTER("Action Type",'%1|%2',"Action Type"::" ","Action Type"::Take);
        SETFILTER("Bin Code",BinCode);
        IF LotNo <> '' THEN
          IF LNRequired THEN
            SETRANGE("Lot No.",LotNo)
          ELSE
            SETFILTER("Lot No.",'%1|%2',LotNo,'');
        IF SerialNo <> '' THEN
          IF SNRequired THEN
            SETRANGE("Serial No.",SerialNo)
          ELSE
            SETFILTER("Serial No.",'%1|%2',SerialNo,'');
        CALCSUMS("Qty. Outstanding (Base)");

        EXIT("Qty. Outstanding (Base)" + CalcBreakbulkOutstdQty(WhseActivLine,LNRequired,SNRequired));
      END;
    END;

    LOCAL PROCEDURE UseForPick(FromBinContent : Record 7302) : Boolean;
    BEGIN
      WITH FromBinContent DO BEGIN
        IF "Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All] THEN
          EXIT(FALSE);

        GetBinType("Bin Type Code");
        EXIT(BinType.Pick);
      END;
    END;

    LOCAL PROCEDURE UseForReplenishment(FromBinContent : Record 7302) : Boolean;
    BEGIN
      WITH FromBinContent DO BEGIN
        IF "Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All] THEN
          EXIT(FALSE);

        GetBinType("Bin Type Code");
        EXIT(NOT (BinType.Receive OR BinType.Ship));
      END;
    END;

    LOCAL PROCEDURE GetLocation(LocationCode : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        Location := WhseSetupLocation
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetBinType(BinTypeCode : Code[10]);
    BEGIN
      IF BinTypeCode = '' THEN
        BinType.INIT
      ELSE
        IF BinType.Code <> BinTypeCode THEN
          BinType.GET(BinTypeCode);
    END;

    LOCAL PROCEDURE GetBin(LocationCode : Code[10];BinCode : Code[20]);
    BEGIN
      IF (Bin."Location Code" <> LocationCode) OR
         (Bin.Code <> BinCode)
      THEN
        IF NOT Bin.GET(LocationCode,BinCode) THEN
          CLEAR(Bin);
    END;

    LOCAL PROCEDURE GetItem(ItemNo : Code[20]);
    BEGIN
      IF Item."No." <> ItemNo THEN
        Item.GET(ItemNo);
    END;

    LOCAL PROCEDURE GetSKU(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10]) : Boolean;
    BEGIN
      IF (SKU."Location Code" <> LocationCode) OR
         (SKU."Item No." <> ItemNo) OR
         (SKU."Variant Code" <> VariantCode)
      THEN
        IF NOT SKU.GET(LocationCode,ItemNo,VariantCode) THEN BEGIN
          CLEAR(SKU);
          EXIT(FALSE)
        END;
      EXIT(TRUE);
    END;

    //[External]
    PROCEDURE SetValues(AssignedID2 : Code[50];WhseDocument2 : Option "Pick Worksheet","Shipment","Movement Worksheet","Internal Pick","Production","Assembly";SortPick2 : Option " ","Item","Document","Shelf/Bin No.","Due Date","Ship-To","Bin Ranking","Action Type";WhseDocType2 : Option "Put-away","Pick","Movement";MaxNoOfSourceDoc2 : Integer;MaxNoOfLines2 : Integer;PerZone2 : Boolean;DoNotFillQtytoHandle2 : Boolean;BreakbulkFilter2 : Boolean;PerBin2 : Boolean);
    BEGIN
      WhseSource := WhseDocument2;
      AssignedID := AssignedID2;
      SortPick := SortPick2;
      WhseDocType := WhseDocType2;
      PerBin := PerBin2;
      IF PerBin THEN
        PerZone := FALSE
      ELSE
        PerZone := PerZone2;
      DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
      MaxNoOfSourceDoc := MaxNoOfSourceDoc2;
      MaxNoOfLines := MaxNoOfLines2;
      BreakbulkFilter := BreakbulkFilter2;
      WhseSetup.GET;
      WhseSetupLocation.GetLocationSetup('',WhseSetupLocation);
      CLEAR(TempWhseActivLine);
      LastWhseItemTrkgLineNo := 0;

      OnAfterSetValues(AssignedID,SortPick,MaxNoOfSourceDoc,MaxNoOfLines,PerBin,PerZone,DoNotFillQtytoHandle,BreakbulkFilter);
    END;

    //[External]
    PROCEDURE SetWhseWkshLine(WhseWkshLine2 : Record 7326;TempNo2 : Integer);
    BEGIN
      WhseWkshLine := WhseWkshLine2;
      TempNo := TempNo2;
      SetSource(
        WhseWkshLine2."Source Type",
        Enum::"Production Order Status".FromInteger(WhseWkshLine2."Source Subtype"),
        WhseWkshLine2."Source No.",
        WhseWkshLine2."Source Line No.",
        WhseWkshLine2."Source Subline No.");

      OnAfterSetWhseWkshLine(WhseWkshLine);
    END;

    //[External]
    PROCEDURE SetWhseShipment(WhseShptLine2 : Record 7321;TempNo2 : Integer;ShippingAgentCode2 : Code[10];ShippingAgentServiceCode2 : Code[10];ShipmentMethodCode2 : Code[10]);
    BEGIN
      WhseShptLine := WhseShptLine2;
      TempNo := TempNo2;
      ShippingAgentCode := ShippingAgentCode2;
      ShippingAgentServiceCode := ShippingAgentServiceCode2;
      ShipmentMethodCode := ShipmentMethodCode2;
      SetSource(
        WhseShptLine2."Source Type",
        Enum::"Production Order Status".FromInteger(WhseShptLine2."Source Subtype"),
        WhseShptLine2."Source No.",
        WhseShptLine2."Source Line No.",
        0);

      OnAfterSetWhseShipment(WhseShptLine);
    END;

    //[External]
    // PROCEDURE SetWhseInternalPickLine(WhseInternalPickLine2 : Record 7334;TempNo2 : Integer);
    // BEGIN
    //   WhseInternalPickLine := WhseInternalPickLine2;
    //   TempNo := TempNo2;

    //   OnAfterSetWhseInternalPickLine(WhseInternalPickLine);
    // END;

    //[External]
    PROCEDURE SetProdOrderCompLine(ProdOrderCompLine2 : Record 5407;TempNo2 : Integer);
    BEGIN
      ProdOrderCompLine := ProdOrderCompLine2;
      TempNo := TempNo2;
      SetSource(
        DATABASE::"Prod. Order Component",
        ProdOrderCompLine2.Status,
        ProdOrderCompLine2."Prod. Order No.",
        ProdOrderCompLine2."Prod. Order Line No.",
        ProdOrderCompLine2."Line No.");

      OnAfterSetProdOrderCompLine(ProdOrderCompLine);
    END;

    //[External]
    // PROCEDURE SetAssemblyLine(AssemblyLine2 : Record 901;TempNo2 : Integer);
    // BEGIN
    //   AssemblyLine := AssemblyLine2;
    //   TempNo := TempNo2;
    //   SetSource(
    //     DATABASE::"Assembly Line",
    //     AssemblyLine2."Document Type",
    //     AssemblyLine2."Document No.",
    //     AssemblyLine2."Line No.",
    //     0);

    //   OnAfterSetAssemblyLine(AssemblyLine);
    // END;

    //[External]
    PROCEDURE SetTempWhseItemTrkgLine(SourceID : Code[20];SourceType : Integer;SourceBatchName : Code[10];SourceProdOrderLine : Integer;SourceRefNo : Integer;LocationCode : Code[10]);
    VAR
      WhseItemTrackingLine : Record 6550;
    BEGIN
      TempWhseItemTrackingLine.DELETEALL;
      TempWhseItemTrackingLine.INIT;
      WhseItemTrkgLineCount := 0;
      WhseItemTrkgExists := FALSE;
      WhseItemTrackingLine.RESET;
      WhseItemTrackingLine.SETCURRENTKEY(
        "Source ID","Source Type","Source Subtype","Source Batch Name",
        "Source Prod. Order Line","Source Ref. No.","Location Code");
      WhseItemTrackingLine.SETRANGE("Source ID",SourceID);
      WhseItemTrackingLine.SETRANGE("Source Type",SourceType);
      WhseItemTrackingLine.SETRANGE("Source Batch Name",SourceBatchName);
      WhseItemTrackingLine.SETRANGE("Source Prod. Order Line",SourceProdOrderLine);
      WhseItemTrackingLine.SETRANGE("Source Ref. No.",SourceRefNo);
      WhseItemTrackingLine.SETRANGE("Location Code",LocationCode);
      IF WhseItemTrackingLine.FIND('-') THEN
        REPEAT
          IF WhseItemTrackingLine."Qty. to Handle (Base)" > 0 THEN BEGIN
            TempWhseItemTrackingLine := WhseItemTrackingLine;
            TempWhseItemTrackingLine."Entry No." := LastWhseItemTrkgLineNo + 1;
            TempWhseItemTrackingLine.INSERT;
            LastWhseItemTrkgLineNo := TempWhseItemTrackingLine."Entry No.";
            WhseItemTrkgExists := TRUE;
            WhseItemTrkgLineCount += 1;
          END;
        UNTIL WhseItemTrackingLine.NEXT = 0;

      OnAfterCreateTempWhseItemTrackingLines(TempWhseItemTrackingLine);

      SourceWhseItemTrackingLine.INIT;
      SourceWhseItemTrackingLine."Source Type" := SourceType;
      SourceWhseItemTrackingLine."Source ID" := SourceID;
      SourceWhseItemTrackingLine."Source Batch Name" := SourceBatchName;
      SourceWhseItemTrackingLine."Source Prod. Order Line" := SourceProdOrderLine;
      SourceWhseItemTrackingLine."Source Ref. No." := SourceRefNo;
    END;

    LOCAL PROCEDURE SaveTempItemTrkgLines();
    VAR
      i : Integer;
    BEGIN
      IF WhseItemTrkgLineCount = 0 THEN
        EXIT;

      i := 0;
      TempWhseItemTrackingLine.RESET;
      IF TempWhseItemTrackingLine.FIND('-') THEN
        REPEAT
          TempTotalWhseItemTrackingLine := TempWhseItemTrackingLine;
          TempTotalWhseItemTrackingLine.INSERT;
          i += 1;
        UNTIL (TempWhseItemTrackingLine.NEXT = 0) OR (i = WhseItemTrkgLineCount);
    END;

    //[External]
    // PROCEDURE ReturnTempItemTrkgLines(VAR TempWhseItemTrackingLine2 : Record 6550 TEMPORARY);
    // BEGIN
    //   IF TempTotalWhseItemTrackingLine.FIND('-') THEN
    //     REPEAT
    //       TempWhseItemTrackingLine2 := TempTotalWhseItemTrackingLine;
    //       TempWhseItemTrackingLine2.INSERT;
    //     UNTIL TempTotalWhseItemTrackingLine.NEXT = 0;
    // END;

    LOCAL PROCEDURE CreateTempItemTrkgLines(ItemNo : Code[20];VariantCode : Code[10];TotalQtytoPickBase : Decimal;HasExpiryDate : Boolean);
    VAR
      EntrySummary : Record 338;
      DummyEntrySummary2 : Record 338;
      WhseItemTrackingFEFO : Codeunit 7326;
      TotalAvailQtyToPickBase : Decimal;
      RemQtyToPickBase : Decimal;
      QtyToPickBase : Decimal;
      QtyTracked : Decimal;
      FromBinContentQty : Decimal;
      QtyCanBePicked : Decimal;
    BEGIN
      IF NOT HasExpiryDate THEN
        IF TotalQtytoPickBase <= 0 THEN
          EXIT;

      WhseItemTrackingFEFO.SetSource(SourceType,SourceSubType.AsInteger(),SourceNo,SourceLineNo,SourceSubLineNo);
      WhseItemTrackingFEFO.SetCalledFromMovementWksh(CalledFromMoveWksh);
      WhseItemTrackingFEFO.CreateEntrySummaryFEFO(Location,ItemNo,VariantCode,HasExpiryDate);

      RemQtyToPickBase := TotalQtytoPickBase;
      IF HasExpiryDate THEN
        TransferRemQtyToPickBase := TotalQtytoPickBase;
      IF WhseItemTrackingFEFO.FindFirstEntrySummaryFEFO(EntrySummary) THEN BEGIN
        ReqFEFOPick := TRUE;
        REPEAT
          IF ((EntrySummary."Expiration Date" <> 0D) AND HasExpiryDate) OR
             ((EntrySummary."Expiration Date" = 0D) AND (NOT HasExpiryDate))
          THEN BEGIN
            QtyTracked := ItemTrackedQuantity(EntrySummary."Lot No.",EntrySummary."Serial No.");

            IF NOT ((EntrySummary."Serial No." <> '') AND (QtyTracked > 0)) THEN BEGIN
              TotalAvailQtyToPickBase :=
                CalcTotalAvailQtyToPick(
                  Location.Code,ItemNo,VariantCode,
                  EntrySummary."Lot No.",EntrySummary."Serial No.",
                  SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,0,HasExpiryDate);

              IF CalledFromWksh AND (WhseWkshLine."From Bin Code" <> '') THEN BEGIN
                FromBinContentQty :=
                  GetFromBinContentQty(
                    WhseWkshLine."Location Code",WhseWkshLine."From Bin Code",WhseWkshLine."Item No.",
                    WhseWkshLine."Variant Code",WhseWkshLine."From Unit of Measure Code",
                    EntrySummary."Lot No.",EntrySummary."Serial No.");
                IF TotalAvailQtyToPickBase > FromBinContentQty THEN
                  TotalAvailQtyToPickBase := FromBinContentQty;
              END;

              QtyCanBePicked :=
                CalcQtyCanBePicked(Location.Code,ItemNo,VariantCode,
                  EntrySummary."Lot No.",EntrySummary."Serial No.",HasExpiryDate);
              TotalAvailQtyToPickBase := Minimum(TotalAvailQtyToPickBase,QtyCanBePicked);

              TotalAvailQtyToPickBase := TotalAvailQtyToPickBase - QtyTracked;
              QtyToPickBase := 0;

              OnBeforeInsertTempItemTrkgLine(EntrySummary,RemQtyToPickBase,TotalAvailQtyToPickBase);

              IF TotalAvailQtyToPickBase > 0 THEN
                IF TotalAvailQtyToPickBase >= RemQtyToPickBase THEN BEGIN
                  QtyToPickBase := RemQtyToPickBase;
                  RemQtyToPickBase := 0
                END ELSE BEGIN
                  QtyToPickBase := TotalAvailQtyToPickBase;
                  RemQtyToPickBase := RemQtyToPickBase - QtyToPickBase;
                END;

              IF QtyToPickBase > 0 THEN
                InsertTempItemTrkgLine(Location.Code,ItemNo,VariantCode,EntrySummary,QtyToPickBase);
            END;
          END;
        UNTIL NOT WhseItemTrackingFEFO.FindNextEntrySummaryFEFO(EntrySummary) OR (RemQtyToPickBase = 0);
        IF HasExpiryDate THEN
          TransferRemQtyToPickBase := RemQtyToPickBase;
      END;
      IF NOT HasExpiryDate THEN
        IF RemQtyToPickBase > 0 THEN
          IF Location."Always Create Pick Line" THEN
            InsertTempItemTrkgLine(Location.Code,ItemNo,VariantCode,DummyEntrySummary2,RemQtyToPickBase);
      IF NOT HasExpiredItems THEN BEGIN
        HasExpiredItems := WhseItemTrackingFEFO.GetHasExpiredItems;
        EnqueueCannotBeHandledReason(WhseItemTrackingFEFO.GetResultMessageForExpiredItem);
      END;
    END;

    //[External]
    PROCEDURE ItemTrackedQuantity(LotNo : Code[50];SerialNo : Code[50]) : Decimal;
    BEGIN
      WITH TempWhseItemTrackingLine DO BEGIN
        RESET;
        IF (LotNo = '') AND (SerialNo = '') THEN
          IF ISEMPTY THEN
            EXIT(0);

        IF SerialNo <> '' THEN BEGIN
          SETCURRENTKEY("Serial No.","Lot No.");
          SETRANGE("Serial No.",SerialNo);
          IF ISEMPTY THEN
            EXIT(0);

          EXIT(1);
        END;

        IF LotNo <> '' THEN BEGIN
          SETCURRENTKEY("Serial No.","Lot No.");
          SETRANGE("Lot No.",LotNo);
          IF ISEMPTY THEN
            EXIT(0);
        END;

        SETCURRENTKEY(
          "Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.","Location Code");
        IF LotNo <> '' THEN
          SETRANGE("Lot No.",LotNo);
        CALCSUMS("Qty. to Handle (Base)");
        EXIT("Qty. to Handle (Base)");
      END;
    END;

    //[External]
    PROCEDURE InsertTempItemTrkgLine(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];EntrySummary : Record 338;QuantityBase : Decimal);
    BEGIN
      WITH TempWhseItemTrackingLine DO BEGIN
        INIT;
        "Entry No." := LastWhseItemTrkgLineNo + 1;
        "Location Code" := LocationCode;
        "Item No." := ItemNo;
        "Variant Code" := VariantCode;
        "Lot No." := EntrySummary."Lot No.";
        "Serial No." := EntrySummary."Serial No.";
        "Expiration Date" := EntrySummary."Expiration Date";
        "Source ID" := SourceWhseItemTrackingLine."Source ID";
        "Source Type" := SourceWhseItemTrackingLine."Source Type";
        "Source Batch Name" := SourceWhseItemTrackingLine."Source Batch Name";
        "Source Prod. Order Line" := SourceWhseItemTrackingLine."Source Prod. Order Line";
        "Source Ref. No." := SourceWhseItemTrackingLine."Source Ref. No.";
        VALIDATE("Quantity (Base)",QuantityBase);
        OnBeforeTempWhseItemTrkgLineInsert(TempWhseItemTrackingLine,SourceWhseItemTrackingLine,EntrySummary);
        INSERT;
        LastWhseItemTrkgLineNo := "Entry No.";
        WhseItemTrkgExists := TRUE;
      END;
    END;

    LOCAL PROCEDURE TransferItemTrkgFields(VAR WhseActivLine2 : Record 5767;TempWhseItemTrackingLine : Record 6550 TEMPORARY);
    VAR
      EntriesExist : Boolean;
    BEGIN
      IF WhseItemTrkgExists THEN BEGIN
        IF TempWhseItemTrackingLine."Serial No." <> '' THEN
          TempWhseItemTrackingLine.TESTFIELD("Qty. per Unit of Measure",1);
        WhseActivLine2."Serial No." := TempWhseItemTrackingLine."Serial No.";
        WhseActivLine2."Lot No." := TempWhseItemTrackingLine."Lot No.";
        WhseActivLine2."Warranty Date" := TempWhseItemTrackingLine."Warranty Date";
        IF TempWhseItemTrackingLine.TrackingExists THEN
          WhseActivLine2."Expiration Date" :=
            ItemTrackingMgt1.ExistingExpirationDate(
              TempWhseItemTrackingLine."Item No.",TempWhseItemTrackingLine."Variant Code",
              TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.",
              FALSE,EntriesExist);
        OnAfterTransferItemTrkgFields(WhseActivLine2,TempWhseItemTrackingLine,EntriesExist);
      END ELSE
        IF SNRequired THEN
          WhseActivLine2.TESTFIELD("Qty. per Unit of Measure",1);
    END;

    //[External]
    PROCEDURE SetSource(SourceType2 : Integer;SourceSubType2 : Enum "Production Order Status";SourceNo2 : Code[20];SourceLineNo2 : Integer;SourceSubLineNo2 : Integer);
    BEGIN
      SourceType := SourceType2;
      SourceSubType := SourceSubType2;
      SourceNo := SourceNo2;
      SourceLineNo := SourceLineNo2;
      SourceSubLineNo := SourceSubLineNo2;
    END;

    //[External]
    PROCEDURE CheckReservation(QtyBaseAvailToPick : Decimal;SourceType : Integer;SourceSubType : Enum "Production Order Status";SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer;AlwaysCreatePickLine : Boolean;QtyPerUnitOfMeasure : Decimal;VAR Quantity : Decimal;VAR QuantityBase : Decimal);
    VAR
      ReservEntry : Record 337;
      WhseManagement : Codeunit 5775;
      Quantity2 : Decimal;
      QuantityBase2 : Decimal;
      QtyBaseResvdNotOnILE : Decimal;
      QtyResvdNotOnILE : Decimal;
      SrcDocQtyBaseToBeFilledByInvt : Decimal;
      SrcDocQtyToBeFilledByInvt : Decimal;
    BEGIN
      ReservationExists := FALSE;
      ReservedForItemLedgEntry := FALSE;
      Quantity2 := Quantity;
      QuantityBase2 := QuantityBase;

      SetFiltersOnReservEntry(ReservEntry,SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo);
      IF ReservEntry.FIND('-') THEN BEGIN
        ReservationExists := TRUE;
        REPEAT
          QtyResvdNotOnILE += CalcQtyResvdNotOnILE(ReservEntry."Entry No.",ReservEntry.Positive);
        UNTIL ReservEntry.NEXT = 0;
        QtyBaseResvdNotOnILE := QtyResvdNotOnILE;
        QtyResvdNotOnILE := ROUND(QtyResvdNotOnILE / QtyPerUnitOfMeasure,0.00001);

        WhseManagement.GetOutboundDocLineQtyOtsdg(SourceType,SourceSubType.AsInteger(),
          SourceNo,SourceLineNo,SourceSubLineNo,SrcDocQtyToBeFilledByInvt,SrcDocQtyBaseToBeFilledByInvt);
        SrcDocQtyBaseToBeFilledByInvt := SrcDocQtyBaseToBeFilledByInvt - QtyBaseResvdNotOnILE;
        SrcDocQtyToBeFilledByInvt := SrcDocQtyToBeFilledByInvt - QtyResvdNotOnILE;

        IF QuantityBase > SrcDocQtyBaseToBeFilledByInvt THEN BEGIN
          QuantityBase := SrcDocQtyBaseToBeFilledByInvt;
          Quantity := SrcDocQtyToBeFilledByInvt;
        END;

        IF QuantityBase <= SrcDocQtyBaseToBeFilledByInvt THEN
          IF (QuantityBase > QtyBaseAvailToPick) AND (QtyBaseAvailToPick >= 0) THEN BEGIN
            QuantityBase := QtyBaseAvailToPick;
            Quantity := ROUND(QtyBaseAvailToPick / QtyPerUnitOfMeasure,0.00001);
          END;

        ReservedForItemLedgEntry := QuantityBase <> 0;
        IF AlwaysCreatePickLine THEN BEGIN
          Quantity := Quantity2;
          QuantityBase := QuantityBase2;
        END;

        IF Quantity <= 0 THEN
          EnqueueCannotBeHandledReason(GetMessageForUnhandledQtyDueToReserv);
      END ELSE
        ReservationExists := FALSE;
    END;

    //[External]
    PROCEDURE CalcTotalAvailQtyToPick(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];LotNo : Code[50];SerialNo : Code[50];SourceType : Integer;SourceSubType : Enum "Production Order Status";SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer;NeededQtyBase : Decimal;RespectLocationBins : Boolean) : Decimal;
    VAR
      WhseActivLine : Record 5767;
      TempWhseItemTrackingLine2 : Record 6550 TEMPORARY;
      TempTrackingSpecification : Record 336 TEMPORARY;
      TotalAvailQtyBase : Decimal;
      QtyInWhse : Decimal;
      QtyOnPickBins : Decimal;
      QtyOnPutAwayBins : Decimal;
      QtyOnOutboundBins : Decimal;
      QtyOnReceiveBins : Decimal;
      QtyOnDedicatedBins : Decimal;
      QtyBlocked : Decimal;
      SubTotal : Decimal;
      QtyReservedOnPickShip : Decimal;
      LineReservedQty : Decimal;
      QtyAssignedPick : Decimal;
      QtyAssignedToPick : Decimal;
      AvailableAfterReshuffle : Decimal;
      QtyOnToBinsBase : Decimal;
      QtyOnToBinsBaseInPicks : Decimal;
      ReservedQtyOnInventory : Decimal;
      ResetWhseItemTrkgExists : Boolean;
      BinTypeFilter : Text[1024];
    BEGIN
      // Directed put-away and pick
      GetLocation(LocationCode);

      ItemTrackingMgt1.CheckWhseItemTrkgSetup(ItemNo,SNRequired,LNRequired,FALSE);
      ReservedQtyOnInventory :=
        CalcReservedQtyOnInventory(ItemNo,LocationCode,VariantCode,LotNo,LNRequired,SerialNo,SNRequired);
      QtyAssignedToPick := CalcQtyAssignedToPick(ItemNo,LocationCode,VariantCode,'',LotNo,LNRequired,SerialNo,SNRequired);

      QtyInWhse := SumWhseEntries(ItemNo,LocationCode,VariantCode,LNRequired,LotNo,SNRequired,SerialNo,'','');

      // calculate quantity in receipt area and fixed receipt bin at location
      // quantity in pick bins is considered as total quantity on the warehouse excluding receipt area and fixed receipt bin
      CalcQtyOnPickAndReceiveBins(
        QtyOnReceiveBins,QtyOnPickBins,
        ItemNo,LocationCode,VariantCode,LNRequired,LotNo,SNRequired,SerialNo,RespectLocationBins);

      IF CalledFromMoveWksh THEN BEGIN
        BinTypeFilter := GetBinTypeFilter(4); // put-away only
        IF BinTypeFilter <> '' THEN
          QtyOnPutAwayBins :=
            SumWhseEntries(ItemNo,LocationCode,VariantCode,LNRequired,LotNo,SNRequired,SerialNo,BinTypeFilter,'');

        IF WhseWkshLine."To Bin Code" <> '' THEN
          IF NOT IsShipZone(WhseWkshLine."Location Code",WhseWkshLine."To Zone Code") THEN BEGIN
            QtyOnToBinsBase :=
              SumWhseEntries(ItemNo,LocationCode,VariantCode,LNRequired,LotNo,SNRequired,SerialNo,'',WhseWkshLine."To Bin Code");
            QtyOnToBinsBaseInPicks :=
              CalcQtyAssignedToPick(
                ItemNo,LocationCode,VariantCode,WhseWkshLine."To Bin Code",LotNo,LNRequired,SerialNo,SNRequired);
            QtyOnToBinsBase -= Minimum(QtyOnToBinsBase,QtyOnToBinsBaseInPicks);
          END;
      END;

      QtyOnOutboundBins := CalcQtyOnOutboundBins(LocationCode,ItemNo,VariantCode,LotNo,SerialNo,TRUE);

      // QtyOnDedicatedBins := WhseAvailMgt.CalcQtyOnDedicatedBins(LocationCode,ItemNo,VariantCode,LotNo,SerialNo);

      // QtyBlocked :=
      //   WhseAvailMgt.CalcQtyOnBlockedITOrOnBlockedOutbndBins(
      //     LocationCode,ItemNo,VariantCode,LotNo,SerialNo,LNRequired,SNRequired);

      TempWhseItemTrackingLine2.COPY(TempWhseItemTrackingLine);
      IF ReqFEFOPick THEN BEGIN
        TempWhseItemTrackingLine2."Entry No." := TempWhseItemTrackingLine2."Entry No." + 1;
        TempWhseItemTrackingLine2."Lot No." := LotNo;
        TempWhseItemTrackingLine2."Serial No." := SerialNo;
        IF NOT WhseItemTrkgExists THEN BEGIN
          WhseItemTrkgExists := TRUE;
          ResetWhseItemTrkgExists := TRUE;
        END;
      END;

      QtyAssignedPick := CalcPickQtyAssigned(LocationCode,ItemNo,VariantCode,'','',TempWhseItemTrackingLine2);

      IF ResetWhseItemTrkgExists THEN BEGIN
        WhseItemTrkgExists := FALSE;
        ResetWhseItemTrkgExists := FALSE;
      END;

      IF Location."Always Create Pick Line" OR CrossDock THEN BEGIN
        FilterWhsePickLinesWithUndefinedBin(
          WhseActivLine,ItemNo,LocationCode,VariantCode,LNRequired,LotNo,SNRequired,SerialNo);
        WhseActivLine.CALCSUMS("Qty. Outstanding (Base)");
        QtyAssignedPick := QtyAssignedPick - WhseActivLine."Qty. Outstanding (Base)";
      END;

      SubTotal :=
        QtyInWhse - QtyOnPickBins - QtyOnPutAwayBins - QtyOnOutboundBins - QtyOnDedicatedBins - QtyBlocked -
        QtyOnReceiveBins - ABS(ReservedQtyOnInventory);

      IF (SubTotal < 0) OR CalledFromPickWksh OR CalledFromMoveWksh THEN BEGIN
        TempTrackingSpecification."Lot No." := LotNo;
        TempTrackingSpecification."Serial No." := SerialNo;
        QtyReservedOnPickShip :=
          WhseAvailMgt.CalcReservQtyOnPicksShipsWithItemTracking(
            TempWhseActivLine,TempTrackingSpecification,LocationCode,ItemNo,VariantCode);

        // LineReservedQty :=
        //   WhseAvailMgt.CalcLineReservedQtyOnInvt(
        //     SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,TRUE,'','',TempWhseActivLine);

        IF SubTotal < 0 THEN
          IF ABS(SubTotal) < QtyReservedOnPickShip + LineReservedQty THEN
            QtyReservedOnPickShip := ABS(SubTotal) - LineReservedQty;

        CASE TRUE OF
          CalledFromPickWksh:
            BEGIN
              TotalAvailQtyBase :=
                QtyOnPickBins - QtyAssignedToPick - ABS(ReservedQtyOnInventory) +
                QtyReservedOnPickShip + LineReservedQty;
              MovementFromShipZone(TotalAvailQtyBase,QtyOnOutboundBins + QtyBlocked);
            END;
          CalledFromMoveWksh:
            BEGIN
              TotalAvailQtyBase :=
                QtyOnPickBins + QtyOnPutAwayBins - QtyAssignedToPick - ABS(ReservedQtyOnInventory) +
                QtyReservedOnPickShip + LineReservedQty;
              IF CalledFromWksh THEN
                TotalAvailQtyBase := TotalAvailQtyBase - QtyAssignedPick - QtyOnPutAwayBins;
              MovementFromShipZone(TotalAvailQtyBase,QtyOnOutboundBins + QtyBlocked);
            END;
          ELSE
            TotalAvailQtyBase :=
              QtyOnPickBins -
              QtyAssignedPick - QtyAssignedToPick +
              SubTotal +
              QtyReservedOnPickShip +
              LineReservedQty;
        END
      END ELSE
        TotalAvailQtyBase := QtyOnPickBins - QtyAssignedPick - QtyAssignedToPick;

      IF (NeededQtyBase <> 0) AND (NeededQtyBase > TotalAvailQtyBase) THEN
        IF ReleaseNonSpecificReservations(
             LocationCode,ItemNo,VariantCode,LotNo,SerialNo,NeededQtyBase - TotalAvailQtyBase)
        THEN BEGIN
          AvailableAfterReshuffle :=
            CalcTotalAvailQtyToPick(
              LocationCode,ItemNo,VariantCode,
              TempWhseItemTrackingLine."Lot No.",TempWhseItemTrackingLine."Serial No.",
              SourceType,SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo,0,FALSE);
          EXIT(AvailableAfterReshuffle);
        END;

      EXIT(TotalAvailQtyBase - QtyOnToBinsBase);
    END;

    LOCAL PROCEDURE CalcQtyOnPickAndReceiveBins(VAR QtyOnReceiveBins : Decimal;VAR QtyOnPickBins : Decimal;ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];IsLNRequired : Boolean;LotNo : Code[50];IsSNRequired : Boolean;SerialNo : Code[50];RespectLocationBins : Boolean);
    VAR
      WhseEntry : Record 7312;
      BinTypeFilter : Text;
    BEGIN
      GetLocation(LocationCode);

      WITH WhseEntry DO BEGIN
        FilterWhseEntry(WhseEntry,ItemNo,LocationCode,VariantCode,IsLNRequired,LotNo,IsSNRequired,SerialNo,FALSE);
        BinTypeFilter := GetBinTypeFilter(0);
        IF BinTypeFilter <> '' THEN BEGIN
          IF RespectLocationBins AND (Location."Receipt Bin Code" <> '') THEN BEGIN
            SETRANGE("Bin Code",Location."Receipt Bin Code");
            CALCSUMS("Qty. (Base)");
            QtyOnReceiveBins := "Qty. (Base)";

            SETFILTER("Bin Code",'<>%1',Location."Receipt Bin Code");
          END;
          SETFILTER("Bin Type Code",BinTypeFilter); // Receive
          CALCSUMS("Qty. (Base)");
          QtyOnReceiveBins += "Qty. (Base)";

          SETFILTER("Bin Type Code",'<>%1',BinTypeFilter);
        END;
        CALCSUMS("Qty. (Base)");
        QtyOnPickBins := "Qty. (Base)";
      END;
    END;

    //[External]
    PROCEDURE CalcQtyOnOutboundBins(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];LotNo : Code[50];SerialNo : Code[50];ExcludeDedicatedBinContent : Boolean) QtyOnOutboundBins : Decimal;
    VAR
      WhseEntry : Record 7312;
      WhseShptLine : Record 7321;
    BEGIN
      // Directed put-away and pick
      GetLocation(LocationCode);

      IF Location."Directed Put-away and Pick" THEN
        WITH WhseEntry DO BEGIN
          FilterWhseEntry(
            WhseEntry,ItemNo,LocationCode,VariantCode,TRUE,LotNo,TRUE,SerialNo,ExcludeDedicatedBinContent);
          SETFILTER("Bin Type Code",GetBinTypeFilter(1)); // Shipping area
          CALCSUMS("Qty. (Base)");
          QtyOnOutboundBins := "Qty. (Base)";
          IF Location."Adjustment Bin Code" <> '' THEN BEGIN
            SETRANGE("Bin Type Code");
            SETRANGE("Bin Code",Location."Adjustment Bin Code");
            CALCSUMS("Qty. (Base)");
            QtyOnOutboundBins += "Qty. (Base)";
          END
        END
      ELSE
        IF Location."Require Pick" THEN
          IF Location."Bin Mandatory" AND ((LotNo <> '') OR (SerialNo <> '')) THEN BEGIN
            FilterWhseEntry(WhseEntry,ItemNo,LocationCode,VariantCode,TRUE,LotNo,TRUE,SerialNo,FALSE);
            WITH WhseEntry DO BEGIN
              SETRANGE("Whse. Document Type","Whse. Document Type"::Shipment);
              SETRANGE("Reference Document","Reference Document"::Pick);
              SETFILTER("Qty. (Base)",'>%1',0);
              QtyOnOutboundBins := CalcResidualPickedQty(WhseEntry);
            END
          END ELSE
            WITH WhseShptLine DO BEGIN
              SETRANGE("Item No.",ItemNo);
              SETRANGE("Location Code",LocationCode);
              SETRANGE("Variant Code",VariantCode);
              CALCSUMS("Qty. Picked (Base)","Qty. Shipped (Base)");
              QtyOnOutboundBins := "Qty. Picked (Base)" - "Qty. Shipped (Base)";
            END;
    END;

    LOCAL PROCEDURE CalcQtyCanBePicked(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];LotNo : Code[50];SerialNo : Code[50];HasExpiryDate : Boolean) : Decimal;
    VAR
      QtyOnPickBins : Decimal;
      QtyOnReceiveBins : Decimal;
      QtyOnOutboundBins : Decimal;
      QtyOnDedicatedBins : Decimal;
      IsLNRequired : Boolean;
      IsSNRequired : Boolean;
    BEGIN
      ItemTrackingMgt1.CheckWhseItemTrkgSetup(ItemNo,IsSNRequired,IsLNRequired,FALSE);

      CalcQtyOnPickAndReceiveBins(
        QtyOnReceiveBins,QtyOnPickBins,ItemNo,LocationCode,VariantCode,
        IsLNRequired,LotNo,IsSNRequired,SerialNo,HasExpiryDate);

      QtyOnOutboundBins :=
        CalcQtyOnOutboundBins(LocationCode,ItemNo,VariantCode,LotNo,SerialNo,TRUE);

      // QtyOnDedicatedBins :=
      //   WhseAvailMgt.CalcQtyOnDedicatedBins(Location.Code,ItemNo,VariantCode,LotNo,SerialNo);

      EXIT(QtyOnPickBins - QtyOnOutboundBins - QtyOnDedicatedBins);
    END;

    //[External]
    PROCEDURE GetBinTypeFilter(Type : Option "Receive","Ship","Put Away","Pick","Put Away only") : Text[1024];
    VAR
      BinType : Record 7303;
      Filter : Text[1024];
    BEGIN
      WITH BinType DO BEGIN
        CASE Type OF
          Type::Receive:
            SETRANGE(Receive,TRUE);
          Type::Ship:
            SETRANGE(Ship,TRUE);
          Type::"Put Away":
            SETRANGE("Put Away",TRUE);
          Type::Pick:
            SETRANGE(Pick,TRUE);
          Type::"Put Away only":
            BEGIN
              SETRANGE("Put Away",TRUE);
              SETRANGE(Pick,FALSE);
            END;
        END;
        IF FIND('-') THEN
          REPEAT
            Filter := STRSUBSTNO('%1|%2',Filter,Code);
          UNTIL NEXT = 0;
        IF Filter <> '' THEN
          Filter := COPYSTR(Filter,2);
      END;
      EXIT(Filter);
    END;

    //[External]
    // PROCEDURE CheckOutBound(SourceType : Integer;SourceSubType : Integer;SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer) : Decimal;
    // VAR
    //   WhseShipLine : Record 7321;
    //   WhseActLine : Record 5767;
    //   ProdOrderComp : Record 5407;
    //   AsmLine : Record 901;
    //   OutBoundQty : Decimal;
    // BEGIN
    //   CASE SourceType OF
    //     DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Transfer Line":
    //       BEGIN
    //         WhseShipLine.RESET;
    //         WhseShipLine.SETCURRENTKEY(
    //           "Source Type","Source Subtype","Source No.","Source Line No.");
    //         WhseShipLine.SETRANGE("Source Type",SourceType);
    //         WhseShipLine.SETRANGE("Source Subtype",SourceSubType);
    //         WhseShipLine.SETRANGE("Source No.",SourceNo);
    //         WhseShipLine.SETRANGE("Source Line No.",SourceLineNo);
    //         IF WhseShipLine.FINDFIRST THEN BEGIN
    //           WhseShipLine.CALCFIELDS("Pick Qty. (Base)");
    //           OutBoundQty := WhseShipLine."Pick Qty. (Base)" + WhseShipLine."Qty. Picked (Base)";
    //         END ELSE BEGIN
    //           WhseActLine.RESET;
    //           WhseActLine.SETCURRENTKEY(
    //             "Source Type","Source Subtype","Source No.","Source Line No.");
    //           WhseActLine.SETRANGE("Source Type",SourceType);
    //           WhseActLine.SETRANGE("Source Subtype",SourceSubType);
    //           WhseActLine.SETRANGE("Source No.",SourceNo);
    //           WhseActLine.SETRANGE("Source Line No.",SourceLineNo);
    //           IF WhseActLine.FINDFIRST THEN
    //             OutBoundQty := WhseActLine."Qty. Outstanding (Base)"
    //           ELSE
    //             OutBoundQty := 0;
    //         END;
    //       END;
    //     DATABASE::"Prod. Order Component":
    //       BEGIN
    //         ProdOrderComp.RESET;
    //         ProdOrderComp.SETRANGE(Status,SourceSubType);
    //         ProdOrderComp.SETRANGE("Prod. Order No.",SourceNo);
    //         ProdOrderComp.SETRANGE("Prod. Order Line No.",SourceSubLineNo);
    //         ProdOrderComp.SETRANGE("Line No.",SourceLineNo);
    //         IF ProdOrderComp.FINDFIRST THEN BEGIN
    //           ProdOrderComp.CALCFIELDS("Pick Qty. (Base)");
    //           OutBoundQty := ProdOrderComp."Pick Qty. (Base)" + ProdOrderComp."Qty. Picked (Base)";
    //         END ELSE
    //           OutBoundQty := 0;
    //       END;
    //     DATABASE::"Assembly Line":
    //       BEGIN
    //         IF AsmLine.GET(SourceSubType,SourceNo,SourceLineNo) THEN BEGIN
    //           AsmLine.CALCFIELDS("Pick Qty. (Base)");
    //           OutBoundQty := AsmLine."Pick Qty. (Base)" + AsmLine."Qty. Picked (Base)";
    //         END ELSE
    //           OutBoundQty := 0;
    //       END;
    //   END;
    //   EXIT(OutBoundQty);
    // END;

    //[External]
    // PROCEDURE SetCrossDock(CrossDock2 : Boolean);
    // BEGIN
    //   CrossDock := CrossDock2;
    // END;

    //[External]
    // PROCEDURE GetReservationStatus(VAR ReservationExists2 : Boolean;VAR ReservedForItemLedgEntry2 : Boolean);
    // BEGIN
    //   ReservationExists2 := ReservationExists;
    //   ReservedForItemLedgEntry2 := ReservedForItemLedgEntry;
    // END;

    //[External]
    // PROCEDURE SetCalledFromPickWksh(CalledFromPickWksh2 : Boolean);
    // BEGIN
    //   CalledFromPickWksh := CalledFromPickWksh2;
    // END;

    //[External]
    // PROCEDURE SetCalledFromMoveWksh(CalledFromMoveWksh2 : Boolean);
    // BEGIN
    //   CalledFromMoveWksh := CalledFromMoveWksh2;
    // END;

    LOCAL PROCEDURE CalcQtyToPickBase(VAR BinContent : Record 7302) : Decimal;
    VAR
      WhseEntry : Record 7312;
      WhseActivLine : Record 5767;
      WhseJrnl : Record 7311;
      QtyPlaced : Decimal;
      QtyTaken : Decimal;
    BEGIN
      WITH BinContent DO BEGIN
        WhseEntry.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
        WhseEntry.SETRANGE("Location Code","Location Code");
        WhseEntry.SETRANGE("Bin Code","Bin Code");
        WhseEntry.SETRANGE("Item No.","Item No.");
        WhseEntry.SETRANGE("Variant Code","Variant Code");
        WhseEntry.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        COPYFILTER("Serial No. Filter",WhseEntry."Serial No.");
        COPYFILTER("Lot No. Filter",WhseEntry."Lot No.");
        WhseEntry.CALCSUMS("Qty. (Base)");

        WhseActivLine.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code",
          "Action Type","Variant Code","Unit of Measure Code","Breakbulk No.","Activity Type","Lot No.","Serial No.");
        WhseActivLine.SETRANGE("Location Code","Location Code");
        WhseActivLine.SETRANGE("Action Type",WhseActivLine."Action Type"::Take);
        WhseActivLine.SETRANGE("Bin Code","Bin Code");
        WhseActivLine.SETRANGE("Item No.","Item No." );
        WhseActivLine.SETRANGE("Variant Code","Variant Code");
        WhseActivLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        COPYFILTER("Lot No. Filter",WhseActivLine."Lot No.");
        COPYFILTER("Serial No. Filter",WhseActivLine."Serial No.");
        WhseActivLine.CALCSUMS("Qty. Outstanding (Base)");
        QtyTaken := WhseActivLine."Qty. Outstanding (Base)";

        TempWhseActivLine.COPY(WhseActivLine);
        TempWhseActivLine.CALCSUMS("Qty. Outstanding (Base)");
        QtyTaken += TempWhseActivLine."Qty. Outstanding (Base)";

        TempWhseActivLine.SETRANGE("Action Type",WhseActivLine."Action Type"::Place);
        TempWhseActivLine.CALCSUMS("Qty. Outstanding (Base)");
        QtyPlaced := TempWhseActivLine."Qty. Outstanding (Base)";

        TempWhseActivLine.RESET;

        WhseJrnl.SETCURRENTKEY(
          "Item No.","From Bin Code","Location Code","Entry Type","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
        WhseJrnl.SETRANGE("Location Code","Location Code");
        WhseJrnl.SETRANGE("From Bin Code","Bin Code");
        WhseJrnl.SETRANGE("Item No.","Item No." );
        WhseJrnl.SETRANGE("Variant Code","Variant Code");
        WhseJrnl.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        COPYFILTER("Lot No. Filter",WhseJrnl."Lot No.");
        COPYFILTER("Serial No. Filter",WhseJrnl."Serial No.");
        WhseJrnl.CALCSUMS("Qty. (Absolute, Base)");

        EXIT(WhseEntry."Qty. (Base)" + WhseJrnl."Qty. (Absolute, Base)" + QtyPlaced - QtyTaken);
      END;
    END;

    LOCAL PROCEDURE PickAccordingToFEFO(LocationCode : Code[10]) : Boolean;
    BEGIN
      GetLocation(LocationCode);
      EXIT(Location."Pick According to FEFO" AND (SNRequired OR LNRequired));
    END;

    LOCAL PROCEDURE UndefinedItemTrkg(VAR QtyToTrackBase : Decimal) : Boolean;
    BEGIN
      QtyToTrackBase := QtyToTrackBase - ItemTrackedQuantity('','');
      EXIT(QtyToTrackBase > 0);
    END;

    LOCAL PROCEDURE ReleaseNonSpecificReservations(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];LotNo : Code[50];SerialNo : Code[50];QtyToRelease : Decimal) : Boolean;
    VAR
      LateBindingMgt : Codeunit 6502;
      LateBindingMgt1 : Codeunit 51153;
      xReservedQty : Decimal;
    BEGIN
      IF QtyToRelease <= 0 THEN
        EXIT;

      IF LNRequired OR SNRequired THEN
        IF Item."Reserved Qty. on Inventory" > 0 THEN BEGIN
          xReservedQty := Item."Reserved Qty. on Inventory";
          LateBindingMgt1.ReleaseForReservation(ItemNo,VariantCode,LocationCode,SerialNo,LotNo,QtyToRelease);
          Item.CALCFIELDS("Reserved Qty. on Inventory");
        END;

      EXIT(xReservedQty > Item."Reserved Qty. on Inventory");
    END;

    //[External]
    // PROCEDURE SetCalledFromWksh(NewCalledFromWksh : Boolean);
    // BEGIN
    //   CalledFromWksh := NewCalledFromWksh;
    // END;

    LOCAL PROCEDURE GetFromBinContentQty(LocCode : Code[10];FromBinCode : Code[20];ItemNo : Code[20];Variant : Code[20];UoMCode : Code[10];LotNo : Code[50];SerialNo : Code[50]) : Decimal;
    VAR
      BinContent : Record 7302;
    BEGIN
      BinContent.GET(LocCode,FromBinCode,ItemNo,Variant,UoMCode);
      BinContent.SETRANGE("Lot No. Filter",LotNo);
      BinContent.SETRANGE("Serial No. Filter",SerialNo);
      BinContent.CALCFIELDS("Quantity (Base)");
      EXIT(BinContent."Quantity (Base)");
    END;

    //[External]
    PROCEDURE CreateTempActivityLine(LocationCode : Code[10];BinCode : Code[20];UOMCode : Code[10];QtyPerUOM : Decimal;QtyToPick : Decimal;QtyToPickBase : Decimal;ActionType : Integer;BreakBulkNo : Integer);
    VAR
      WhseSource2 : Option;
    BEGIN
      IF Location."Directed Put-away and Pick" THEN
        GetBin(LocationCode,BinCode);

      TempLineNo := TempLineNo + 10000;
      WITH TempWhseActivLine DO BEGIN
        RESET;
        INIT;

        "No." := FORMAT(TempNo);
        "Location Code" := LocationCode;
        "Unit of Measure Code" := UOMCode;
        "Qty. per Unit of Measure" := QtyPerUOM;
        "Starting Date" := WORKDATE;
        "Bin Code" := BinCode;
        "Action Type" := Enum::"Warehouse Action Type".FromInteger(ActionType);
        "Breakbulk No." := BreakBulkNo;
        "Line No." := TempLineNo;

        CASE WhseSource OF
          WhseSource::"Pick Worksheet":
            TransferFromPickWkshLine(WhseWkshLine);
          WhseSource::Shipment:
            IF WhseShptLine."Assemble to Order" THEN
              TransferFromATOShptLine(WhseShptLine,AssemblyLine)
            ELSE
              TransferFromShptLine(WhseShptLine);
          WhseSource::"Internal Pick":
            TransferFromIntPickLine(WhseInternalPickLine);
          WhseSource::Production:
            TransferFromCompLine(ProdOrderCompLine);
          WhseSource::Assembly:
            TransferFromAssemblyLine(AssemblyLine);
          WhseSource::"Movement Worksheet":
            TransferFromMovWkshLine(WhseWkshLine);
        END;

        IF (WhseSource = WhseSource::Shipment) AND WhseShptLine."Assemble to Order" THEN
          WhseSource2 := WhseSource::Assembly
        ELSE
          WhseSource2 := WhseSource;
        IF (BreakBulkNo = 0) AND ("Action Type" = "Action Type"::Place) THEN
          CASE WhseSource2 OF
            WhseSource::"Pick Worksheet",WhseSource::"Movement Worksheet":
              CalcMaxQtytoPlace(
                QtyToPick,WhseWkshLine."Qty. to Handle",QtyToPickBase,WhseWkshLine."Qty. to Handle (Base)");
            WhseSource::Shipment:
              BEGIN
                WhseShptLine.CALCFIELDS("Pick Qty.","Pick Qty. (Base)");
                CalcMaxQtytoPlace(
                  QtyToPick,
                  WhseShptLine.Quantity -
                  WhseShptLine."Qty. Picked" -
                  WhseShptLine."Pick Qty.",
                  QtyToPickBase,
                  WhseShptLine."Qty. (Base)" -
                  WhseShptLine."Qty. Picked (Base)" -
                  WhseShptLine."Pick Qty. (Base)");
              END;
            WhseSource::"Internal Pick":
              BEGIN
                WhseInternalPickLine.CALCFIELDS("Pick Qty.","Pick Qty. (Base)");
                CalcMaxQtytoPlace(
                  QtyToPick,
                  WhseInternalPickLine.Quantity -
                  WhseInternalPickLine."Qty. Picked" -
                  WhseInternalPickLine."Pick Qty.",
                  QtyToPickBase,
                  WhseInternalPickLine."Qty. (Base)" -
                  WhseInternalPickLine."Qty. Picked (Base)" -
                  WhseInternalPickLine."Pick Qty. (Base)");
              END;
            WhseSource::Production:
              BEGIN
                ProdOrderCompLine.CALCFIELDS("Pick Qty.","Pick Qty. (Base)");
                CalcMaxQtytoPlace(
                  QtyToPick,
                  ProdOrderCompLine."Expected Quantity" -
                  ProdOrderCompLine."Qty. Picked" -
                  ProdOrderCompLine."Pick Qty.",
                  QtyToPickBase,
                  ProdOrderCompLine."Expected Qty. (Base)" -
                  ProdOrderCompLine."Qty. Picked (Base)" -
                  ProdOrderCompLine."Pick Qty. (Base)");
              END;
            WhseSource::Assembly:
              BEGIN
                AssemblyLine.CALCFIELDS("Pick Qty.","Pick Qty. (Base)");
                CalcMaxQtytoPlace(
                  QtyToPick,
                  AssemblyLine.Quantity -
                  AssemblyLine."Qty. Picked" -
                  AssemblyLine."Pick Qty.",
                  QtyToPickBase,
                  AssemblyLine."Quantity (Base)" -
                  AssemblyLine."Qty. Picked (Base)" -
                  AssemblyLine."Pick Qty. (Base)");
              END;
          END;

        IF (LocationCode <> '') AND (BinCode <> '') THEN BEGIN
          GetBin(LocationCode,BinCode);
          Dedicated := Bin.Dedicated;
        END;
        IF Location."Directed Put-away and Pick" THEN BEGIN
          "Zone Code" := Bin."Zone Code";
          "Bin Ranking" := Bin."Bin Ranking";
          "Bin Type Code" := Bin."Bin Type Code";
          IF Location."Special Equipment" <> Location."Special Equipment"::" " THEN
            "Special Equipment Code" :=
              AssignSpecEquipment(LocationCode,BinCode,"Item No.","Variant Code");
        END;

        VALIDATE(Quantity,QtyToPick);
        IF QtyToPickBase <> 0 THEN BEGIN
          "Qty. (Base)" := QtyToPickBase;
          "Qty. to Handle (Base)" := QtyToPickBase;
          "Qty. Outstanding (Base)" := QtyToPickBase;
        END;

        CASE WhseSource OF
          WhseSource::Shipment:
            BEGIN
              "Shipping Agent Code" := ShippingAgentCode;
              "Shipping Agent Service Code" := ShippingAgentServiceCode;
              "Shipment Method Code" := ShipmentMethodCode;
              "Shipping Advice" := "Shipping Advice";
            END;
          WhseSource::Production,WhseSource::Assembly:
            IF "Shelf No." = '' THEN BEGIN
              Item."No." := "Item No.";
              Item.ItemSKUGet(Item,"Location Code","Variant Code");
              "Shelf No." := Item."Shelf No.";
            END;
          WhseSource::"Movement Worksheet":
            IF (WhseWkshLine."Qty. Outstanding" <> QtyToPick) AND (BreakBulkNo = 0) THEN BEGIN
              "Source Type" := DATABASE::"Whse. Worksheet Line";
              "Source No." := WhseWkshLine."Worksheet Template Name";
              "Source Line No." := "Line No.";
            END;
        END;

        TransferItemTrkgFields(TempWhseActivLine,TempWhseItemTrackingLine);

        IF (BreakBulkNo = 0) AND (ActionType <> 2) THEN
          TotalQtyPickedBase += QtyToPickBase;

        OnBeforeTempWhseActivLineInsert(TempWhseActivLine,ActionType);
        INSERT;
      END;
    END;

    LOCAL PROCEDURE UpdateQuantitiesToPick(QtyAvailableBase : Decimal;FromQtyPerUOM : Decimal;VAR FromQtyToPick : Decimal;VAR FromQtyToPickBase : Decimal;ToQtyPerUOM : Decimal;VAR ToQtyToPick : Decimal;VAR ToQtyToPickBase : Decimal;VAR TotalQtyToPick : Decimal;VAR TotalQtyToPickBase : Decimal);
    BEGIN
      UpdateToQtyToPick(QtyAvailableBase,ToQtyPerUOM,ToQtyToPick,ToQtyToPickBase,TotalQtyToPick,TotalQtyToPickBase);
      UpdateFromQtyToPick(QtyAvailableBase,FromQtyPerUOM,FromQtyToPick,FromQtyToPickBase,ToQtyPerUOM,ToQtyToPick,ToQtyToPickBase);
      UpdateTotalQtyToPick(ToQtyToPick,ToQtyToPickBase,TotalQtyToPick,TotalQtyToPickBase)
    END;

    //[External]
    PROCEDURE UpdateFromQtyToPick(QtyAvailableBase : Decimal;FromQtyPerUOM : Decimal;VAR FromQtyToPick : Decimal;VAR FromQtyToPickBase : Decimal;ToQtyPerUOM : Decimal;ToQtyToPick : Decimal;ToQtyToPickBase : Decimal);
    BEGIN
      CASE FromQtyPerUOM OF
        ToQtyPerUOM:
          BEGIN
            FromQtyToPick := ToQtyToPick;
            FromQtyToPickBase := ToQtyToPickBase;
          END;
        0..ToQtyPerUOM:
          BEGIN
            FromQtyToPick := ROUND(ToQtyToPickBase / FromQtyPerUOM,0.00001);
            FromQtyToPickBase := ToQtyToPickBase;
          END;
        ELSE
          FromQtyToPick := ROUND(ToQtyToPickBase / FromQtyPerUOM,1,'>');
          FromQtyToPickBase := FromQtyToPick * FromQtyPerUOM;
          IF FromQtyToPickBase > QtyAvailableBase THEN BEGIN
            FromQtyToPickBase := ToQtyToPickBase;
            FromQtyToPick := ROUND(FromQtyToPickBase / FromQtyPerUOM,0.00001);
          END;
      END;
    END;

    LOCAL PROCEDURE UpdateToQtyToPick(QtyAvailableBase : Decimal;ToQtyPerUOM : Decimal;VAR ToQtyToPick : Decimal;VAR ToQtyToPickBase : Decimal;TotalQtyToPick : Decimal;TotalQtyToPickBase : Decimal);
    BEGIN
      ToQtyToPickBase := QtyAvailableBase;
      IF ToQtyToPickBase > TotalQtyToPickBase THEN
        ToQtyToPickBase := TotalQtyToPickBase;

      ToQtyToPick := ROUND(ToQtyToPickBase / ToQtyPerUOM,0.00001);
      IF ToQtyToPick > TotalQtyToPick THEN
        ToQtyToPick := TotalQtyToPick;
      IF (ToQtyToPick <> TotalQtyToPick) AND (ToQtyToPickBase = TotalQtyToPickBase) THEN
        IF ABS(1 - ToQtyToPick / TotalQtyToPick) <= 0.00001 THEN
          ToQtyToPick := TotalQtyToPick;
    END;

    //[External]
    PROCEDURE UpdateTotalQtyToPick(ToQtyToPick : Decimal;ToQtyToPickBase : Decimal;VAR TotalQtyToPick : Decimal;VAR TotalQtyToPickBase : Decimal);
    BEGIN
      TotalQtyToPick := TotalQtyToPick - ToQtyToPick;
      TotalQtyToPickBase := TotalQtyToPickBase - ToQtyToPickBase;
    END;

    LOCAL PROCEDURE CalcTotalQtyAssgndOnWhse(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10]) : Decimal;
    VAR
      WhseShipmentLine : Record 7321;
      ProdOrderComp : Record 5407;
      AsmLine : Record 901;
      QtyAssgndToWhseAct : Decimal;
      QtyAssgndToShipment : Decimal;
      QtyAssgndToProdComp : Decimal;
      QtyAssgndToAsmLine : Decimal;
    BEGIN
      QtyAssgndToWhseAct +=
        CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::" ",LocationCode,ItemNo,VariantCode);
      QtyAssgndToWhseAct +=
        CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::"Put-away",LocationCode,ItemNo,VariantCode);
      QtyAssgndToWhseAct +=
        CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::Pick,LocationCode,ItemNo,VariantCode);
      QtyAssgndToWhseAct +=
        CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::Movement,LocationCode,ItemNo,VariantCode);
      QtyAssgndToWhseAct +=
        CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::"Invt. Put-away",LocationCode,ItemNo,VariantCode);
      QtyAssgndToWhseAct +=
        CalcTotalQtyAssgndOnWhseAct(TempWhseActivLine."Activity Type"::"Invt. Pick",LocationCode,ItemNo,VariantCode);

      WITH WhseShipmentLine DO BEGIN
        SETCURRENTKEY("Item No.","Location Code","Variant Code","Due Date");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        CALCSUMS("Qty. Picked (Base)","Qty. Shipped (Base)");
        QtyAssgndToShipment := "Qty. Picked (Base)" - "Qty. Shipped (Base)";
      END;

      WITH ProdOrderComp DO BEGIN
        SETCURRENTKEY("Item No.","Variant Code","Location Code",Status,"Due Date");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE(Status,Status::Released);
        CALCSUMS("Qty. Picked (Base)","Expected Qty. (Base)","Remaining Qty. (Base)");
        QtyAssgndToProdComp := "Qty. Picked (Base)" - ("Expected Qty. (Base)" - "Remaining Qty. (Base)");
      END;

      WITH AsmLine DO BEGIN
        SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Location Code");
        SETRANGE("Document Type","Document Type"::Order);
        SETRANGE("Location Code",LocationCode);
        SETRANGE(Type,Type::Item);
        SETRANGE("No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        CALCSUMS("Qty. Picked (Base)","Consumed Quantity (Base)");
        QtyAssgndToAsmLine := CalcQtyPickedNotConsumedBase;
      END;

      EXIT(QtyAssgndToWhseAct + QtyAssgndToShipment + QtyAssgndToProdComp + QtyAssgndToAsmLine);
    END;

    LOCAL PROCEDURE CalcTotalQtyAssgndOnWhseAct(ActivityType : Enum "Warehouse Activity Type";LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10]) : Decimal;
    VAR
      WhseActivLine : Record 5767;
    BEGIN
      WITH WhseActivLine DO BEGIN
        SETCURRENTKEY(
          "Item No.","Location Code","Activity Type","Bin Type Code",
          "Unit of Measure Code","Variant Code","Breakbulk No.","Action Type");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE("Activity Type",ActivityType);
        SETRANGE("Breakbulk No.",0);
        SETFILTER("Action Type",'%1|%2',"Action Type"::" ","Action Type"::Take);
        CALCSUMS("Qty. Outstanding (Base)");
        EXIT("Qty. Outstanding (Base)");
      END;
    END;

    LOCAL PROCEDURE CalcTotalQtyOnBinType(BinTypeFilter : Text[1024];LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10]) : Decimal;
    BEGIN
      EXIT(SumWhseEntries(ItemNo,LocationCode,VariantCode,FALSE,'',FALSE,'',BinTypeFilter,''));
    END;

    LOCAL PROCEDURE SumWhseEntries(ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];IsLNRequired : Boolean;LotNo : Code[50];IsSNRequired : Boolean;SerialNo : Code[50];BinTypeCodeFilter : Text;BinCodeFilter : Text) : Decimal;
    VAR
      WhseEntry : Record 7312;
    BEGIN
      WITH WhseEntry DO BEGIN
        FilterWhseEntry(
          WhseEntry,ItemNo,LocationCode,VariantCode,IsLNRequired,LotNo,IsSNRequired,SerialNo,FALSE);
        SETFILTER("Bin Type Code",BinTypeCodeFilter);
        SETFILTER("Bin Code",BinCodeFilter);

        CALCSUMS("Qty. (Base)");
        EXIT("Qty. (Base)");
      END;
    END;

    //[External]
    PROCEDURE CalcBreakbulkOutstdQty(VAR WhseActivLine : Record 5767;LNRequired : Boolean;SNRequired : Boolean) : Decimal;
    VAR
      BinContent : Record 7302;
      WhseActivLine1 : Record 5767;
      WhseActivLine2 : Record 5767;
      TempUOM : Record 204 TEMPORARY;
      QtyOnBreakbulk : Decimal;
    BEGIN
      WITH WhseActivLine1 DO BEGIN
        COPYFILTERS(WhseActivLine);
        SETFILTER("Breakbulk No.",'<>%1',0);
        SETRANGE("Action Type","Action Type"::Place);
        IF FINDSET THEN BEGIN
          BinContent.SETCURRENTKEY(
            "Location Code","Item No.","Variant Code","Cross-Dock Bin","Qty. per Unit of Measure","Bin Ranking");
          BinContent.SETRANGE("Location Code","Location Code");
          BinContent.SETRANGE("Item No.","Item No.");
          BinContent.SETRANGE("Variant Code","Variant Code");
          BinContent.SETRANGE("Cross-Dock Bin",CrossDock);

          REPEAT
            IF NOT TempUOM.GET("Unit of Measure Code") THEN BEGIN
              TempUOM.INIT;
              TempUOM.Code := "Unit of Measure Code";
              TempUOM.INSERT;
              SETRANGE("Unit of Measure Code","Unit of Measure Code");
              CALCSUMS("Qty. Outstanding (Base)");
              QtyOnBreakbulk += "Qty. Outstanding (Base)";

              // Exclude the qty counted in QtyAssignedToPick
              BinContent.SETRANGE("Unit of Measure Code","Unit of Measure Code");
              IF LNRequired THEN
                BinContent.SETRANGE("Lot No. Filter","Lot No.")
              ELSE
                BinContent.SETFILTER("Lot No. Filter",'%1|%2',"Lot No.",'');
              IF SNRequired THEN
                BinContent.SETRANGE("Serial No. Filter","Serial No.")
              ELSE
                BinContent.SETFILTER("Serial No. Filter",'%1|%2',"Serial No.",'');

              IF BinContent.FINDSET THEN
                REPEAT
                  BinContent.SetFilterOnUnitOfMeasure;
                  BinContent.CALCFIELDS("Quantity (Base)","Pick Quantity (Base)");
                  IF BinContent."Pick Quantity (Base)" > BinContent."Quantity (Base)" THEN
                    QtyOnBreakbulk -= (BinContent."Pick Quantity (Base)" - BinContent."Quantity (Base)");
                UNTIL BinContent.NEXT = 0
              ELSE BEGIN
                WhseActivLine2.COPYFILTERS(WhseActivLine1);
                WhseActivLine2.SETFILTER("Action Type",'%1|%2',"Action Type"::" ","Action Type"::Take);
                WhseActivLine2.SETRANGE("Breakbulk No.",0);
                WhseActivLine2.CALCSUMS("Qty. Outstanding (Base)");
                QtyOnBreakbulk -= WhseActivLine2."Qty. Outstanding (Base)";
              END;
              SETRANGE("Unit of Measure Code");
            END;
          UNTIL NEXT = 0;
        END;
        EXIT(QtyOnBreakbulk);
      END;
    END;

    //[External]
    PROCEDURE GetExpiredItemMessage() : Text[100];
    BEGIN
      // obsolete
      EXIT(DequeueCannotBeHandledReason);
    END;

    //[External]
    // PROCEDURE GetCannotBeHandledReason() : Text;
    // BEGIN
    //   EXIT(DequeueCannotBeHandledReason);
    // END;

    LOCAL PROCEDURE PickStrictExpirationPosting(ItemNo : Code[20]) : Boolean;
    VAR
      StrictExpirationPosting : Boolean;
      IsHandled : Boolean;
    BEGIN
      IsHandled := FALSE;
      OnBeforePickStrictExpirationPosting(ItemNo,SNRequired,LNRequired,StrictExpirationPosting,IsHandled);
      IF IsHandled THEN
        EXIT(StrictExpirationPosting);

      EXIT(ItemTrackingMgt.StrictExpirationPosting(ItemNo) AND (SNRequired OR LNRequired));
    END;

    LOCAL PROCEDURE AddToFilterText(VAR TextVar : Text[250];Separator : Code[1];Comparator : Code[2];Addendum : Code[20]);
    BEGIN
      IF TextVar = '' THEN
        TextVar := Comparator + Addendum
      ELSE
        TextVar += Separator + Comparator + Addendum;
    END;

    //[External]
    // PROCEDURE CreateAssemblyPickLine(AsmLine : Record 901);
    // VAR
    //   QtyToPickBase : Decimal;
    //   QtyToPick : Decimal;
    // BEGIN
    //   WITH AsmLine DO BEGIN
    //     TESTFIELD("Qty. per Unit of Measure");
    //     QtyToPickBase := CalcQtyToPickBase;
    //     QtyToPick := CalcQtyToPick;
    //     IF QtyToPick > 0 THEN BEGIN
    //       SetAssemblyLine(AsmLine,1);
    //       SetTempWhseItemTrkgLine(
    //         "Document No.",DATABASE::"Assembly Line",'',0,"Line No.","Location Code");
    //       CreateTempLine(
    //         "Location Code","No.","Variant Code","Unit of Measure Code",'',"Bin Code",
    //         "Qty. per Unit of Measure",QtyToPick,QtyToPickBase);
    //     END;
    //   END;
    // END;

    LOCAL PROCEDURE MovementFromShipZone(VAR TotalAvailQtyBase : Decimal;QtyOnOutboundBins : Decimal);
    BEGIN
      IF NOT IsShipZone(WhseWkshLine."Location Code",WhseWkshLine."To Zone Code") THEN
        TotalAvailQtyBase := TotalAvailQtyBase - QtyOnOutboundBins;
    END;

    //[External]
    PROCEDURE IsShipZone(LocationCode : Code[10];ZoneCode : Code[10]) : Boolean;
    VAR
      Zone : Record 7300;
      BinType : Record 7303;
    BEGIN
      IF NOT Zone.GET(LocationCode,ZoneCode) THEN
        EXIT(FALSE);
      IF NOT BinType.GET(Zone."Bin Type Code") THEN
        EXIT(FALSE);
      EXIT(BinType.Ship);
    END;

    LOCAL PROCEDURE Minimum(a : Decimal;b : Decimal) : Decimal;
    BEGIN
      IF a < b THEN
        EXIT(a);

      EXIT(b);
    END;

    //[External]
    PROCEDURE CalcQtyResvdNotOnILE(ReservEntryNo : Integer;ReservEntryPositive : Boolean) QtyResvdNotOnILE : Decimal;
    VAR
      ReservEntry : Record 337;
    BEGIN
      IF ReservEntry.GET(ReservEntryNo,NOT ReservEntryPositive) THEN
        IF ReservEntry."Source Type" <> DATABASE::"Item Ledger Entry" THEN
          QtyResvdNotOnILE += ReservEntry."Quantity (Base)";

      EXIT(QtyResvdNotOnILE);
    END;

    //[External]
    PROCEDURE SetFiltersOnReservEntry(VAR ReservEntry : Record 337;SourceType : Integer;SourceSubType : Enum "Production Order Status";SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer);
    BEGIN
      WITH ReservEntry DO BEGIN
        SETCURRENTKEY(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Reservation Status");
        SETRANGE("Source ID",SourceNo);
        IF SourceType = DATABASE::"Prod. Order Component" THEN BEGIN
          SETRANGE("Source Ref. No.",SourceSubLineNo);
          SETRANGE("Source Prod. Order Line",SourceLineNo);
        END ELSE
          SETRANGE("Source Ref. No.",SourceLineNo);
        SETRANGE("Source Type",SourceType);
        SETRANGE("Source Subtype",SourceSubType);
        SETRANGE("Reservation Status","Reservation Status"::Reservation);
      END;
    END;

    //[External]
    // PROCEDURE GetActualQtyPickedBase() : Decimal;
    // BEGIN
    //   EXIT(TotalQtyPickedBase);
    // END;

    //[External]
    PROCEDURE CalcReservedQtyOnInventory(ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];LotNo : Code[50];LNRequired : Boolean;SerialNo : Code[50];SNRequired : Boolean) ReservedQty : Decimal;
    VAR
      ReservationEntry : Record 337;
      TempBinContentBuffer : Record 7330 TEMPORARY;
    BEGIN
      ReservedQty := 0;

      WITH ReservationEntry DO BEGIN
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
        SETRANGE("Source Subtype",0);
        SETRANGE("Reservation Status","Reservation Status"::Reservation);
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Variant Code",VariantCode);
        IF LotNo <> '' THEN BEGIN
          IF LNRequired THEN
            SETRANGE("Lot No.",LotNo)
          ELSE
            SETFILTER("Lot No.",'%1|%2',LotNo,'');
        END;
        IF SerialNo <> '' THEN BEGIN
          IF SNRequired THEN
            SETRANGE("Serial No.",SerialNo)
          ELSE
            SETFILTER("Serial No.",'%1|%2',SerialNo,'');
        END;

        IF FINDSET THEN
          REPEAT
            InsertTempBinContentBuf(
              TempBinContentBuffer,"Location Code",'',"Item No.","Variant Code",'',"Lot No.","Serial No.","Quantity (Base)");
          UNTIL NEXT = 0;

        DistrubuteReservedQtyByBins(TempBinContentBuffer);
        TempBinContentBuffer.CALCSUMS("Qty. to Handle (Base)");
        ReservedQty := TempBinContentBuffer."Qty. to Handle (Base)";
      END;

      OnAfterCalcReservedQtyOnInventory(ItemNo,LocationCode,VariantCode,LotNo,LNRequired,SerialNo,SNRequired,ReservedQty);
    END;

    LOCAL PROCEDURE FilterWhseEntry(VAR WarehouseEntry : Record 7312;ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];IsLNRequired : Boolean;LotNo : Code[50];IsSNRequired : Boolean;SerialNo : Code[50];ExcludeDedicatedBinContent : Boolean);
    BEGIN
      WITH WarehouseEntry DO BEGIN
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Variant Code",VariantCode);
        IF LotNo <> '' THEN
          IF IsLNRequired THEN
            SETRANGE("Lot No.",LotNo)
          ELSE
            SETFILTER("Lot No.",'%1|%2',LotNo,'');
        IF SerialNo <> '' THEN
          IF IsSNRequired THEN
            SETRANGE("Serial No.",SerialNo)
          ELSE
            SETFILTER("Serial No.",'%1|%2',SerialNo,'');
        IF ExcludeDedicatedBinContent THEN
          SETRANGE(Dedicated,FALSE);
      END;
    END;

    //[External]
    PROCEDURE CalcResidualPickedQty(VAR WhseEntry : Record 7312) Result : Decimal;
    VAR
      WhseEntry2 : Record 7312;
    BEGIN
      IF WhseEntry.FINDSET THEN
        REPEAT
          WhseEntry.SETRANGE("Bin Code",WhseEntry."Bin Code");
          WITH WhseEntry2 DO BEGIN
            COPYFILTERS(WhseEntry);
            SETRANGE("Whse. Document Type");
            SETRANGE("Reference Document");
            SETRANGE("Qty. (Base)");
            CALCSUMS("Qty. (Base)");
            Result += "Qty. (Base)";
          END;
          WhseEntry.FINDLAST;
          WhseEntry.SETRANGE("Bin Code");
        UNTIL WhseEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE DistrubuteReservedQtyByBins(VAR TempBinContentBuffer : Record 7330 TEMPORARY);
    VAR
      TempBinContentBufferByBins : Record 7330 TEMPORARY;
      TempBinContentBufferByBlockedBins : Record 7330 TEMPORARY;
      WarehouseEntry : Record 7312;
      QtyLeftToDistribute : Decimal;
      QtyInBin : Decimal;
    BEGIN
      WITH TempBinContentBuffer DO BEGIN
        IF FINDSET THEN
          REPEAT
            QtyLeftToDistribute := "Qty. to Handle (Base)";
            WarehouseEntry.SETCURRENTKEY(
              "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.",
              "Entry Type",Dedicated);
            WarehouseEntry.SETRANGE("Location Code","Location Code");
            WarehouseEntry.SETRANGE("Item No.","Item No.");
            WarehouseEntry.SETRANGE("Variant Code","Variant Code");
            WarehouseEntry.SETRANGE("Lot No.","Lot No.");
            WarehouseEntry.SETRANGE("Serial No.","Serial No.");
            GetLocation("Location Code");
            IF Location."Adjustment Bin Code" <> '' THEN BEGIN
              WarehouseEntry.FILTERGROUP(2);
              WarehouseEntry.SETFILTER("Bin Code",'<>%1',Location."Adjustment Bin Code");
              WarehouseEntry.FILTERGROUP(0);
            END;
            WarehouseEntry.SETFILTER("Bin Type Code",'<>%1',GetBinTypeFilter(0));

            IF WarehouseEntry.FINDSET THEN
              REPEAT
                WarehouseEntry.SETRANGE("Bin Code",WarehouseEntry."Bin Code");
                WarehouseEntry.SETRANGE("Unit of Measure Code",WarehouseEntry."Unit of Measure Code");
                WarehouseEntry.CALCSUMS("Qty. (Base)");
                IF WarehouseEntry."Qty. (Base)" > 0 THEN
                  IF NOT BinContentBlocked(
                       "Location Code",WarehouseEntry."Bin Code","Item No.","Variant Code",WarehouseEntry."Unit of Measure Code")
                  THEN BEGIN
                    QtyInBin := Minimum(QtyLeftToDistribute,WarehouseEntry."Qty. (Base)");
                    QtyLeftToDistribute -= QtyInBin;
                    InsertTempBinContentBuf(
                      TempBinContentBufferByBins,
                      "Location Code",WarehouseEntry."Bin Code","Item No.","Variant Code",
                      WarehouseEntry."Unit of Measure Code","Lot No.","Serial No.",QtyInBin);
                  END ELSE
                    InsertTempBinContentBuf(
                      TempBinContentBufferByBlockedBins,
                      "Location Code",WarehouseEntry."Bin Code","Item No.","Variant Code",
                      WarehouseEntry."Unit of Measure Code","Lot No.","Serial No.",WarehouseEntry."Qty. (Base)");
                WarehouseEntry.FINDLAST;
                WarehouseEntry.SETRANGE("Unit of Measure Code");
                WarehouseEntry.SETRANGE("Bin Code");
              UNTIL (WarehouseEntry.NEXT = 0) OR (QtyLeftToDistribute = 0);

            IF (QtyLeftToDistribute > 0) AND TempBinContentBufferByBlockedBins.FINDSET THEN
              REPEAT
                QtyInBin := Minimum(QtyLeftToDistribute,TempBinContentBufferByBlockedBins."Qty. to Handle (Base)");
                QtyLeftToDistribute -= QtyInBin;
                InsertTempBinContentBuf(
                  TempBinContentBufferByBins,
                  "Location Code",TempBinContentBufferByBlockedBins."Bin Code","Item No.","Variant Code",
                  TempBinContentBufferByBlockedBins."Unit of Measure Code","Lot No.","Serial No.",QtyInBin);
              UNTIL (TempBinContentBufferByBlockedBins.NEXT = 0) OR (QtyLeftToDistribute = 0);
          UNTIL NEXT = 0;

        DELETEALL;
        IF TempBinContentBufferByBins.FINDSET THEN
          REPEAT
            IF NOT BlockedBinOrTracking(TempBinContentBufferByBins) THEN BEGIN
              TempBinContentBuffer := TempBinContentBufferByBins;
              INSERT;
            END;
          UNTIL TempBinContentBufferByBins.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertTempBinContentBuf(VAR TempBinContentBuffer : Record 7330 TEMPORARY;LocationCode : Code[10];BinCode : Code[20];ItemNo : Code[20];VariantCode : Code[10];UnitOfMeasureCode : Code[10];LotNo : Code[50];SerialNo : Code[50];QtyBase : Decimal);
    BEGIN
      WITH TempBinContentBuffer DO
        IF GET(LocationCode,BinCode,ItemNo,VariantCode,UnitOfMeasureCode,LotNo,SerialNo) THEN BEGIN
          "Qty. to Handle (Base)" += QtyBase;
          MODIFY;
        END ELSE BEGIN
          INIT;
          "Location Code" := LocationCode;
          "Bin Code" := BinCode;
          "Item No." := ItemNo;
          "Variant Code" := VariantCode;
          "Unit of Measure Code" := UnitOfMeasureCode;
          "Lot No." := LotNo;
          "Serial No." := SerialNo;
          "Qty. to Handle (Base)" := QtyBase;
          INSERT;
        END;
    END;

    LOCAL PROCEDURE BlockedBinOrTracking(BinContentBuffer : Record 7330) : Boolean;
    VAR
      LotNoInformation : Record 6505;
      SerialNoInformation : Record 6504;
    BEGIN
      WITH BinContentBuffer DO BEGIN
        IF BinContentBlocked("Location Code","Bin Code","Item No.","Variant Code","Unit of Measure Code") THEN
          EXIT(TRUE);
        IF LotNoInformation.GET("Item No.","Variant Code","Lot No.") THEN
          IF LotNoInformation.Blocked THEN
            EXIT(TRUE);
        IF SerialNoInformation.GET("Item No.","Variant Code","Serial No.") THEN
          IF SerialNoInformation.Blocked THEN
            EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetMessageForUnhandledQtyDueToBin(BinIsForPick : Boolean;BinIsForReplenishment : Boolean;IsMoveWksh : Boolean;AvailableQtyBase : Decimal;BinCode : Code[20]) : Text[100];
    BEGIN
      IF AvailableQtyBase <= 0 THEN
        EXIT('');
      IF NOT BinIsForPick AND NOT IsMoveWksh THEN
        EXIT(STRSUBSTNO(BinIsNotForPickTxt,BinCode));
      IF NOT BinIsForReplenishment AND IsMoveWksh THEN
        EXIT(STRSUBSTNO(BinIsForReceiveOrShipTxt,BinCode));
    END;

    LOCAL PROCEDURE GetMessageForUnhandledQtyDueToReserv() : Text;
    BEGIN
      EXIT(QtyReservedNotFromInventoryTxt);
    END;

    //[External]
    PROCEDURE FilterWhsePickLinesWithUndefinedBin(VAR WarehouseActivityLine : Record 5767;ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];IsLNRequired : Boolean;LotNo : Code[50];IsSNRequired : Boolean;SerialNo : Code[50]);
    VAR
      LotNoFilter : Text;
      SerialNoFilter : Text;
    BEGIN
      IF LotNo <> '' THEN
        IF IsLNRequired THEN
          LotNoFilter := LotNo
        ELSE
          LotNoFilter := STRSUBSTNO('%1|%2',LotNo,'');
      IF SerialNo <> '' THEN
        IF IsSNRequired THEN
          SerialNoFilter := SerialNo
        ELSE
          SerialNoFilter := STRSUBSTNO('%1|%2',SerialNo,'');

      WITH WarehouseActivityLine DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type","Variant Code","Unit of Measure Code","Breakbulk No.","Activity Type");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Bin Code",'');
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Action Type","Action Type"::Take);
        SETRANGE("Variant Code",VariantCode);
        SETFILTER("Lot No.",LotNoFilter);
        SETFILTER("Serial No.",SerialNoFilter);
        SETRANGE("Breakbulk No.",0);
        SETRANGE("Activity Type","Activity Type"::Pick);
      END;
    END;

    LOCAL PROCEDURE EnqueueCannotBeHandledReason(CannotBeHandledReason : Text);
    VAR
      NewReasonAdded : Boolean;
      i : Integer;
    BEGIN
      IF CannotBeHandledReason = '' THEN
        EXIT;

      REPEAT
        i += 1;
        IF CannotBeHandledReasons[i] = '' THEN BEGIN
          CannotBeHandledReasons[i] := CannotBeHandledReason;
          NewReasonAdded := TRUE;
        END;
      UNTIL NewReasonAdded OR (i = ARRAYLEN(CannotBeHandledReasons));
    END;

    LOCAL PROCEDURE DequeueCannotBeHandledReason() CannotBeHandledReason : Text;
    BEGIN
      CannotBeHandledReason := CannotBeHandledReasons[1];
      CannotBeHandledReasons[1] := '';
      COMPRESSARRAY(CannotBeHandledReasons);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcReservedQtyOnInventory(ItemNo : Code[20];LocationCode : Code[10];VariantCode : Code[10];LotNo : Code[50];LNRequired : Boolean;SerialNo : Code[50];SNRequired : Boolean;VAR ReservedQty : Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterWhseActivLineInsert(VAR WarehouseActivityLine : Record 5767);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateTempLineCheckReservation(LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];UnitofMeasureCode : Code[10];QtyPerUnitofMeasure : Decimal;VAR TotalQtytoPick : Decimal;VAR TotalQtytoPickBase : Decimal;SourceType : Integer;SourceSubType : Enum "Production Order Status";SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateTempWhseItemTrackingLines(VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateWhseDocument(VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindWhseActivLine(VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetValues(VAR AssignedID : Code[50];VAR SortPick : Option " ","Item","Document","Shelf/Bin No.","Due Date","Ship-To","Bin Ranking","Action Type";VAR MaxNoOfSourceDoc : Integer;VAR MaxNoOfLines : Integer;VAR PerBin : Boolean;VAR PerZone : Boolean;VAR DoNotFillQtytoHandle : Boolean;VAR BreakbulkFilter : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetAssemblyLine(VAR AssemblyLine : Record 901);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetProdOrderCompLine(VAR ProdOrderComp : Record 5407);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetWhseShipment(VAR WarehouseShipmentLine : Record 7321);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetWhseWkshLine(VAR WhseWorksheetLine : Record 7326);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetWhseInternalPickLine(VAR WhseInternalPickLine : Record 7334);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTransferItemTrkgFields(VAR WarehouseActivityLine : Record 5767;WhseItemTrackingLine : Record 6550;EntriesExist : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterBinContentExistsFilter(VAR BinContent : Record 7302);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalcPickBin(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY;VAR TotalQtytoPick : Decimal;VAR TotalQtytoPickBase : Decimal;VAR TempWhseItemTrackingLine : Record 6550 TEMPORARY;CrossDock : Boolean;WhseTrackingExists : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateWhseDocument(VAR TempWhseActivLine : Record 5767 TEMPORARY;WhseSource : Option "Pick Worksheet","Shipment","Movement Worksheet","Internal Pick","Production","Assembly");
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateNewWhseDoc(VAR TempWhseActivLine : Record 5767 TEMPORARY;OldNo : Code[20];OldSourceNo : Code[20];OldLocationCode : Code[10];VAR FirstWhseDocNo : Code[20];VAR LastWhseDocNo : Code[20];VAR NoOfSourceDoc : Integer;VAR NoOfLines : Integer;VAR WhseDocCreated : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindBWPickBin(VAR BinContent : Record 7302;VAR IsSetCurrentKeyHandled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSetBinCodeFilter(VAR BinCodeFilterText : Text[250];LocationCode : Code[10];ItemNo : Code[20];VariantCode : Code[10];ToBinCode : Code[20]);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePickStrictExpirationPosting(ItemNo : Code[20];SNRequired : Boolean;LNRequired : Boolean;VAR StrictExpirationPosting : Boolean;VAR IsHandled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertTempItemTrkgLine(VAR EntrySummary : Record 338;RemQtyToPickBase : Decimal;VAR TotalAvailQtyToPickBase : Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempWhseActivLineInsert(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY;ActionType : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempWhseItemTrkgLineInsert(VAR WhseItemTrackingLine : Record 6550;FromWhseItemTrackingLine : Record 6550;EntrySummary : Record 338);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeWhseActivHeaderInsert(VAR WarehouseActivityHeader : Record 5766);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeWhseActivLineInsert(VAR WarehouseActivityLine : Record 5767;WarehouseActivityHeader : Record 5766);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcAvailQtyOnFindBWPickBin(ItemNo : Code[20];VariantCode : Code[10];SNRequired : Boolean;LNRequired : Boolean;WhseItemTrkgExists : Boolean;SerialNo : Code[50];LotNo : Code[50];LocationCode : Code[10];BinCode : Code[20];SourceType : Integer;SourceSubType : Integer;SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer;TotalQtyToPickBase : Decimal;VAR QtyAvailableBase : Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcAvailQtyOnFindPickBin(ItemNo : Code[20];VariantCode : Code[10];SNRequired : Boolean;LNRequired : Boolean;WhseItemTrkgExists : Boolean;SerialNo : Code[50];LotNo : Code[50];LocationCode : Code[10];BinCode : Code[20];SourceType : Integer;SourceSubType : Integer;SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer;TotalQtyToPickBase : Decimal;VAR QtyAvailableBase : Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcAvailQtyOnFindBreakBulkBin(Broken : Boolean;ItemNo : Code[20];VariantCode : Code[10];SNRequired : Boolean;LNRequired : Boolean;WhseItemTrkgExists : Boolean;SerialNo : Code[50];LotNo : Code[50];LocationCode : Code[10];BinCode : Code[20];SourceType : Integer;SourceSubType : Integer;SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer;TotalQtyToPickBase : Decimal;VAR QtyAvailableBase : Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCalcAvailQtyOnFindSmallerUOMBin(Broken : Boolean;ItemNo : Code[20];VariantCode : Code[10];SNRequired : Boolean;LNRequired : Boolean;WhseItemTrkgExists : Boolean;SerialNo : Code[50];LotNo : Code[50];LocationCode : Code[10];BinCode : Code[20];SourceType : Integer;SourceSubType : Integer;SourceNo : Code[20];SourceLineNo : Integer;SourceSubLineNo : Integer;TotalQtyToPickBase : Decimal;VAR QtyAvailableBase : Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocumentOnAfterSaveOldValues(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocumentOnAfterSetFiltersAfterLoop(VAR TempWhseActivLine : Record 5767 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocumentOnAfterSetFiltersBeforeLoop(VAR TempWhseActivLine : Record 5767 TEMPORARY;PerBin : Boolean;PerZone : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocumentOnBeforeClearFilters(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocumentOnBeforeCreateDocAndLine(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY;VAR IsHandled : Boolean;VAR CreateNewHeader : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocumentOnBeforeShowError(VAR ShowError : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocTakeLineOnAfterSetFilters(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY;WarehouseActivityLine : Record 5767);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCreateWhseDocPlaceLineOnAfterSetFilters(VAR TempWarehouseActivityLine : Record 5767 TEMPORARY;WarehouseActivityLine : Record 5767);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}








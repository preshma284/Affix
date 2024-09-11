Codeunit 51050 "Show Applied Entries 1"
{
  
  
    TableNo=32;
    Permissions=TableData 32=rim,
                TableData 339=r;
    trigger OnRun()
BEGIN
            TempItemEntry.DELETEALL;
            FindAppliedEntry(Rec);
            PAGE.RUNMODAL(PAGE::"Applied Item Entries",TempItemEntry);
          END;
    VAR
      TempItemEntry : Record 32 TEMPORARY;

    LOCAL PROCEDURE FindAppliedEntry(ItemLedgEntry : Record 32);
    VAR
      ItemApplnEntry : Record 339;
    BEGIN
      WITH ItemLedgEntry DO
        IF Positive THEN BEGIN
          ItemApplnEntry.RESET;
          ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.","Outbound Item Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Inbound Item Entry No.","Entry No.");
          ItemApplnEntry.SETFILTER("Outbound Item Entry No.",'<>%1',0);
          ItemApplnEntry.SETRANGE("Cost Application",TRUE);
          IF ItemApplnEntry.FIND('-') THEN
            REPEAT
              InsertTempEntry(ItemApplnEntry."Outbound Item Entry No.",ItemApplnEntry.Quantity);
            UNTIL ItemApplnEntry.NEXT = 0;
        END ELSE BEGIN
          ItemApplnEntry.RESET;
          ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Outbound Item Entry No.","Entry No.");
          ItemApplnEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
          ItemApplnEntry.SETRANGE("Cost Application",TRUE);
          IF ItemApplnEntry.FIND('-') THEN
            REPEAT
              InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity);
            UNTIL ItemApplnEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE InsertTempEntry(EntryNo : Integer;AppliedQty : Decimal);
    VAR
      ItemLedgEntry : Record 32;
    BEGIN
      ItemLedgEntry.GET(EntryNo);
      IF AppliedQty * ItemLedgEntry.Quantity < 0 THEN
        EXIT;

      IF NOT TempItemEntry.GET(EntryNo) THEN BEGIN
        TempItemEntry.INIT;
        TempItemEntry := ItemLedgEntry;
        TempItemEntry.Quantity := AppliedQty;
        TempItemEntry.INSERT;
      END ELSE BEGIN
        TempItemEntry.Quantity := TempItemEntry.Quantity + AppliedQty;
        TempItemEntry.MODIFY;
      END;
    END;

    /* /*BEGIN
END.*/
}






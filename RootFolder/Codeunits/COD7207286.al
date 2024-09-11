Codeunit 7207286 "Purchase Journal Management"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Last_PurchaseJournalLine : Record 7207281;
      JobNo : Code[20];
      OpenFromBatch : Boolean;

    PROCEDURE OpenJournalName(VAR NowJournalBatchName : Code[20];VAR PurchaseJournalLine : Record 7207281);
    BEGIN
      CheckJournalName(NowJournalBatchName);
      PurchaseJournalLine.FILTERGROUP := 2;
      PurchaseJournalLine.SETRANGE("Journal Batch Name",NowJournalBatchName);
      PurchaseJournalLine.FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE CheckJournalName(VAR NowJournalBatchName : Code[20]);
    VAR
      JournalBatchPurchase : Record 7207282;
      Text004 : TextConst ENU='Defaul',ESP='PREDET.';
      Text005 : TextConst ENU='Diario predet.',ESP='Diario predet.';
    BEGIN
      IF (NowJournalBatchName = '') THEN
        NowJournalBatchName := Text004;
      IF NOT JournalBatchPurchase.GET(NowJournalBatchName) THEN BEGIN
        JournalBatchPurchase.INIT;
        JournalBatchPurchase."Section Code" := Text004;
        JournalBatchPurchase."Section Description" := Text005;
        JournalBatchPurchase.INSERT(TRUE);
      END;
    END;

    PROCEDURE CheckName(NowJournalBatch : Code[20]);
    VAR
      JournalBatchPurchase : Record 7207282;
    BEGIN
      JournalBatchPurchase.GET(NowJournalBatch);
    END;

    PROCEDURE SetName(NowJournalBatch : Code[20];VAR PurchaseJournalLine : Record 7207281);
    BEGIN
      PurchaseJournalLine.FILTERGROUP := 2;
      PurchaseJournalLine.SETRANGE("Journal Batch Name",NowJournalBatch);
      PurchaseJournalLine.FILTERGROUP := 0;
      IF PurchaseJournalLine.FINDSET THEN;
    END;

    PROCEDURE SearchName(VAR NowJournalBatch : Code[20];VAR PurchaseJournalLine : Record 7207281) : Boolean;
    VAR
      PurchaseJournalBatch1 : Record 7207282;
      PurchaseJournalBatch2 : Record 7207282;
      PurchaseJournalBatches : Page 7207354;
    BEGIN
      COMMIT;

      PurchaseJournalBatch1.RESET;
      PurchaseJournalBatch2.GET(NowJournalBatch);

      CLEAR(PurchaseJournalBatches);
      PurchaseJournalBatches.SETTABLEVIEW(PurchaseJournalBatch1);
      PurchaseJournalBatches.SETRECORD(PurchaseJournalBatch2);
      PurchaseJournalBatches.LOOKUPMODE(TRUE);
      IF PurchaseJournalBatches.RUNMODAL = ACTION::LookupOK THEN BEGIN
        PurchaseJournalBatches.GETRECORD(PurchaseJournalBatch1);
        NowJournalBatch := PurchaseJournalBatch1."Section Code";
        SetName(NowJournalBatch,PurchaseJournalLine);
      END;
    END;

    /* /*BEGIN
END.*/
}








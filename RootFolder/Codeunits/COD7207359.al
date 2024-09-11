Codeunit 7207359 "QB Post Preview"
{
  
  
    EventSubscriberInstance=Manual;
    trigger OnRun()
BEGIN
          END;
    VAR
      tmpWithholdingMovements : Record 7207329 TEMPORARY;
      tmpQBPrepayment : Record 7206928 TEMPORARY;
      tmpQBDetailedJobLedgerEntry : Record 7207328 TEMPORARY;
      tmpPostedOutputShipmentLines : Record 7207311 TEMPORARY;
      tmpCarteraDoc : Record 7000002 TEMPORARY;
      tmpPostedCarteraDoc : Record 7000003 TEMPORARY;
      tmpClosedCarteraDoc : Record 7000004 TEMPORARY;
      PostingPreviewEventHandler : Codeunit 20;

    LOCAL PROCEDURE "---------------------------------------------------------- Tablas que manejamos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207329, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE WithholdingMovements_OnAfterInsertEvent(VAR Rec : Record 7207329;RunTrigger : Boolean);
    BEGIN
      //Al insertar un registro en la tabla de retenciones, si no es tabla temporal la a�adimos a los temporales de vista previa
      IF Rec.ISTEMPORARY THEN
        EXIT;

      PostingPreviewEventHandler.PreventCommit;
      tmpWithholdingMovements := Rec;
      tmpWithholdingMovements."Document No." := '***';
      tmpWithholdingMovements.INSERT;
    END;

    [EventSubscriber(ObjectType::Table, 7206928, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE QBPrepayment_OnAfterInsertEvent(VAR Rec : Record 7206928;RunTrigger : Boolean);
    BEGIN
      //Al insertar un registro en la tabla de prepagos, si no es tabla temporal la a�adimos a los temporales de vista previa
      IF Rec.ISTEMPORARY THEN
        EXIT;

      IF (NOT Rec.TC) AND (NOT Rec.TJ) THEN BEGIN
        PostingPreviewEventHandler.PreventCommit;
        tmpQBPrepayment := Rec;
        tmpQBPrepayment."Document No." := '***';
        tmpQBPrepayment.INSERT;
      END;
    END;

    [EventSubscriber(ObjectType::Table, 7207328, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE QBDetailedJobLedgerEntry_OnAfterInsertEvent(VAR Rec : Record 7207328;RunTrigger : Boolean);
    BEGIN
      IF Rec.ISTEMPORARY THEN
        EXIT;

      PostingPreviewEventHandler.PreventCommit;
      tmpQBDetailedJobLedgerEntry := Rec;
      tmpQBDetailedJobLedgerEntry."Document No." := '***';
      tmpQBDetailedJobLedgerEntry.INSERT;
    END;

    [EventSubscriber(ObjectType::Table, 7207311, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE PostedOutputShipmentLines_OnAfterInsertEvent(VAR Rec : Record 7207311;RunTrigger : Boolean);
    BEGIN
      IF Rec.ISTEMPORARY THEN
        EXIT;

      PostingPreviewEventHandler.PreventCommit;
      tmpPostedOutputShipmentLines := Rec;
      tmpPostedOutputShipmentLines."No." := '***';
      tmpPostedOutputShipmentLines.INSERT;
    END;

    [EventSubscriber(ObjectType::Table, 7000002, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE CarteraDoc_OnAfterInsertEvent(VAR Rec : Record 7000002;RunTrigger : Boolean);
    BEGIN
      //--------------------------------------------------------------------------------------------------
      //JAV 28/03/22: - QB 1.10.29 Se a�ade la vista previa de documentos en cartera
      //--------------------------------------------------------------------------------------------------
      IF Rec.ISTEMPORARY THEN
        EXIT;

      PostingPreviewEventHandler.PreventCommit;
      tmpCarteraDoc := Rec;
      tmpCarteraDoc."No." := '***';
      tmpCarteraDoc.INSERT;
    END;

    [EventSubscriber(ObjectType::Table, 7000003, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE PostedCarteraDoc_OnAfterInsertEvent(VAR Rec : Record 7000003;RunTrigger : Boolean);
    BEGIN
      //--------------------------------------------------------------------------------------------------
      //JAV 28/03/22: - QB 1.10.29 Se a�ade la vista previa de documentos en cartera registrados
      //--------------------------------------------------------------------------------------------------
      IF Rec.ISTEMPORARY THEN
        EXIT;

      PostingPreviewEventHandler.PreventCommit;
      tmpPostedCarteraDoc := Rec;
      tmpPostedCarteraDoc."No." := '***';
      tmpPostedCarteraDoc.INSERT;
    END;

    [EventSubscriber(ObjectType::Table, 7000004, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE ClosedCarteraDoc_OnAfterInsertEvent(VAR Rec : Record 7000004;RunTrigger : Boolean);
    BEGIN
      //--------------------------------------------------------------------------------------------------
      //JAV 28/03/22: - QB 1.10.29 Se a�ade la vista previa de documentos en cartera cerrados
      //--------------------------------------------------------------------------------------------------
      IF Rec.ISTEMPORARY THEN
        EXIT;

      PostingPreviewEventHandler.PreventCommit;
      tmpClosedCarteraDoc := Rec;
      tmpClosedCarteraDoc."No." := '***';
      tmpClosedCarteraDoc.INSERT;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------- Eventos que se capturan"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 20, OnAfterFillDocumentEntry, '', true, true)]
    LOCAL PROCEDURE cuPostingPreviewEventHandler_OnAfterFillDocumentEntry(VAR DocumentEntry : Record 265);
    BEGIN
      //Cuando desde la CodeUnit de vista previa insertamos un registro

      PostingPreviewEventHandler.InsertDocumentEntry(tmpWithholdingMovements, DocumentEntry);
      PostingPreviewEventHandler.InsertDocumentEntry(tmpQBPrepayment, DocumentEntry);
      PostingPreviewEventHandler.InsertDocumentEntry(tmpQBDetailedJobLedgerEntry, DocumentEntry);
      PostingPreviewEventHandler.InsertDocumentEntry(tmpPostedOutputShipmentLines, DocumentEntry);

      //JAV 28/03/22: - QB 1.10.29 Se a�ade la vista previa de documentos en cartera
      PostingPreviewEventHandler.InsertDocumentEntry(tmpCarteraDoc, DocumentEntry);
      PostingPreviewEventHandler.InsertDocumentEntry(tmpPostedCarteraDoc, DocumentEntry);
      PostingPreviewEventHandler.InsertDocumentEntry(tmpClosedCarteraDoc, DocumentEntry);
    END;

    [EventSubscriber(ObjectType::Codeunit, 20, OnAfterShowEntries, '', true, true)]
    LOCAL PROCEDURE cuPostingPreviewEventHandler_OnAfterShowEntries(TableNo : Integer);
    BEGIN
      //Cuando desde la CodeUnit de vista previa queremos ver un registro

      CASE TableNo OF
        DATABASE::"Withholding Movements"         : PAGE.RUN(PAGE::"Withholding Movements", tmpWithholdingMovements);
        DATABASE::"QB Prepayment"                 : PAGE.RUN(PAGE::"QB Job Prepayment List", tmpQBPrepayment);
        DATABASE::"QB Detailed Job Ledger Entry"  : PAGE.RUN(0, tmpQBDetailedJobLedgerEntry);
        DATABASE::"Posted Output Shipment Lines"  : PAGE.RUN(0, tmpPostedOutputShipmentLines);

        //JAV 28/03/22: - QB 1.10.29 Se a�ade la vista previa de documentos en cartera
        DATABASE::"Cartera Doc."                  : PAGE.RUN(0, tmpCarteraDoc);
        DATABASE::"Posted Cartera Doc."           : PAGE.RUN(0, tmpPostedCarteraDoc);
        DATABASE::"Closed Cartera Doc."           : PAGE.RUN(0, tmpClosedCarteraDoc);
      END;
    END;

    /*BEGIN
/*{
      JAV 24/10/19: - Nueva CU para la vista previa de movimientos de retenci�n antes del registro, los eventos son manuales por tanto
                      hay que llamarla tras un bindig
      JAV 08/07/19: - QB 1.09.04 Se convierte en una CU general para QuoBuilding, no solo para retenciones. Se a�aden movimientos de Anticipos
      JAV 28/03/22: - QB 1.10.29 Se a�ade la vista previa de documentos en cartera
    }
END.*/
}








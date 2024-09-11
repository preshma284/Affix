Codeunit 50926 "Graph Mgt - Sales Header 1"
{
  
  
    trigger OnRun()
BEGIN
          END;

    //[External]
    PROCEDURE UpdateIntegrationRecords(OnlyItemsWithoutId : Boolean);
    VAR
      DummySalesHeader : Record 36;
      GraphMgtGeneralTools : Codeunit 5465;
      GraphMgtGeneralTools1: Codeunit 50917;
      SalesHeaderRecordRef : RecordRef;
    BEGIN
      SalesHeaderRecordRef.OPEN(DATABASE::"Sales Header");
      GraphMgtGeneralTools1.UpdateIntegrationRecords(SalesHeaderRecordRef,DummySalesHeader.FIELDNO(SystemId),OnlyItemsWithoutId);
    END;

    PROCEDURE UpdateReferencedIdFieldOnSalesHeader(VAR RecRef : RecordRef;NewId : GUID;VAR Handled : Boolean);
    VAR
      DummySalesHeader : Record 36;
      GraphMgtGeneralTools : Codeunit 5465;
    BEGIN
      IF NOT CheckSupportedTable(RecRef) THEN
        EXIT;

      GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,NewId,Handled,
        RecRef.NUMBER,DummySalesHeader.FIELDNO(SystemId));
    END;

    PROCEDURE GetPredefinedIdValue(VAR Id : GUID;VAR RecRef : RecordRef;VAR Handled : Boolean);
    VAR
      DummySalesHeader : Record 36;
      GraphMgtGeneralTools : Codeunit 5465;
      GraphMgtGeneralTools1: Codeunit 50917;
    BEGIN
      IF NOT CheckSupportedTable(RecRef) THEN
        EXIT;

      GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
        RecRef.NUMBER,DummySalesHeader.FIELDNO(SystemId));
    END;

    [EventSubscriber(ObjectType::Codeunit, 5465, ApiSetup, '', true, true)]
    LOCAL PROCEDURE HandleApiSetup();
    BEGIN
      UpdateIntegrationRecords(FALSE);
      UpdateIds;
    END;

    LOCAL PROCEDURE CheckSupportedTable(VAR RecRef : RecordRef) : Boolean;
    VAR
      SalesHeader : Record 36;
    BEGIN
      IF RecRef.NUMBER = DATABASE::"Sales Header" THEN BEGIN
        RecRef.SETTABLE(SalesHeader);
        IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Blanket Order") OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order"))
        THEN
          EXIT(FALSE);
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    //[External]
    PROCEDURE UpdateIds();
    VAR
      SalesInvoiceEntityAggregate : Record 5475;
    BEGIN
      WITH SalesInvoiceEntityAggregate DO BEGIN
        IF FINDSET THEN
          REPEAT
            UpdateReferencedRecordIds;
            MODIFY(FALSE);
          UNTIL NEXT = 0;
      END;
    END;

    /*BEGIN
/*{
      // This Graph Mgt code unit is used to generate id fields for all
      // sales docs other than invoice and order. If special logic is required
      // for any of these sales docs, create a seperate code unit.
    }
END.*/
}








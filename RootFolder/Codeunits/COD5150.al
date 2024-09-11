Codeunit 50845 "Integration Management 1"
{
  
  
    Permissions=TableData 112=rm,
                TableData 113=rm,
                TableData 5079=r;
    SingleInstance=true;
    trigger OnRun()
BEGIN
          END;
    VAR
      IntegrationIsActivated : Boolean;
      PageServiceNameTok : TextConst ENU='Integration %1',ESP='Integraci�n %1';
      IntegrationServicesEnabledMsg : TextConst ENU='Integration services have been enabled.\The %1 service should be restarted.',ESP='Se habilitaron los servicios de integraci�n.\Se recomienda reiniciar el servicio %1.';
      IntegrationServicesDisabledMsg : TextConst ENU='Integration services have been disabled.\The %1 service should be restarted.',ESP='Se deshabilitaron los servicios de integraci�n.\Se recomienda reiniciar el servicio %1.';
      HideMessages : Boolean;

    //[External]
    PROCEDURE GetDatabaseTableTriggerSetup(TableID : Integer;VAR Insert : Boolean;VAR Modify : Boolean;VAR Delete : Boolean;VAR Rename : Boolean);
    VAR
      Enabled : Boolean;
    BEGIN
      IF COMPANYNAME = '' THEN
        EXIT;

      IF NOT GetIntegrationActivated THEN
        EXIT;

      OnEnabledDatabaseTriggersSetup(TableID,Enabled);
      IF NOT Enabled THEN
        Enabled := IsIntegrationRecord(TableID) OR IsIntegrationRecordChild(TableID);

      IF Enabled THEN BEGIN
        Insert := TRUE;
        Modify := TRUE;
        Delete := TRUE;
        Rename := TRUE;
      END;
    END;

    //[External]
    PROCEDURE OnDatabaseInsert(RecRef : RecordRef);
    VAR
      TimeStamp : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    END;

    //[External]
    PROCEDURE OnDatabaseModify(RecRef : RecordRef);
    VAR
      TimeStamp : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    END;

    //[External]
    PROCEDURE OnDatabaseDelete(RecRef : RecordRef);
    VAR
      SalesHeader : Record 36;
      IntegrationRecord : Record "Integration Record 1";
      // IntegrationRecordArchive : Record 5152;
      SkipDeletion : Boolean;
      TimeStamp : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      IF IsIntegrationRecord(RecRef.NUMBER) THEN
        IF IntegrationRecord.FindByRecordId(RecRef.RECORDID) THEN BEGIN
          // Handle exceptions where "Deleted On" should not be set.
          IF RecRef.NUMBER = DATABASE::"Sales Header" THEN BEGIN
            RecRef.SETTABLE(SalesHeader);
            SkipDeletion := SalesHeader.Invoice;
          END;

          // Archive
          // IntegrationRecordArchive.TRANSFERFIELDS(IntegrationRecord);
          // IF IntegrationRecordArchive.INSERT THEN;

          IF NOT SkipDeletion THEN BEGIN
            OnDeleteIntegrationRecord(RecRef);
            IntegrationRecord."Deleted On" := TimeStamp;
          END;

          CLEAR(IntegrationRecord."Record ID");
          IntegrationRecord."Modified On" := TimeStamp;
          IntegrationRecord.MODIFY;
        END;
    END;

    //[External]
    PROCEDURE OnDatabaseRename(RecRef : RecordRef;XRecRef : RecordRef);
    VAR
      IntegrationRecord : Record "Integration Record 1";
      TimeStamp : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      IF IsIntegrationRecord(RecRef.NUMBER) THEN
        IF IntegrationRecord.FindByRecordId(XRecRef.RECORDID) THEN BEGIN
          IntegrationRecord."Record ID" := RecRef.RECORDID;
          IntegrationRecord.MODIFY;
        END;

      InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    END;

    LOCAL PROCEDURE UpdateParentIntegrationRecord(RecRef : RecordRef;TimeStamp : DateTime);
    VAR
      Currency : Record 4;
      SalesHeader : Record 36;
      SalesLine : Record 37;
      SalesInvoiceHeader : Record 112;
      SalesInvoiceLine : Record 113;
      SalesCrMemoHeader : Record 114;
      SalesCrMemoLine : Record 115;
      Customer : Record 18;
      ShipToAddress : Record 222;
      CurrencyExchangeRate : Record 330;
      SalesPrice : Record 7002;
      CustomerPriceGroup : Record 6;
      ContactProfileAnswer : Record 5089;
      ContactAltAddress : Record 5051;
      RlshpMgtCommentLine : Record 5061;
      Contact : Record 5050;
      Vendor : Record 23;
      VendorBankAccount : Record 288;
      PurchaseHeader : Record 38;
      PurchaseLine : Record 39;
      ParentRecRef : RecordRef;
    BEGIN
      // Handle cases where entities change should update the parent record
      // Function must not fail even if the parent record cannot be found
      CASE RecRef.NUMBER OF
        DATABASE::"Sales Line":
          BEGIN
            RecRef.SETTABLE(SalesLine);
            IF SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(SalesHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Sales Invoice Line":
          BEGIN
            RecRef.SETTABLE(SalesInvoiceLine);
            IF SalesInvoiceHeader.GET(SalesInvoiceLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(SalesInvoiceHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Sales Cr.Memo Line":
          BEGIN
            RecRef.SETTABLE(SalesCrMemoLine);
            IF SalesCrMemoHeader.GET(SalesCrMemoLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(SalesCrMemoHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Sales Price":
          BEGIN
            RecRef.SETTABLE(SalesPrice);
            IF SalesPrice."Sales Type" <> SalesPrice."Sales Type"::"Customer Price Group" THEN
              EXIT;

            IF CustomerPriceGroup.GET(SalesPrice."Sales Code") THEN BEGIN
              ParentRecRef.GETTABLE(CustomerPriceGroup);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Ship-to Address":
          BEGIN
            RecRef.SETTABLE(ShipToAddress);
            IF Customer.GET(ShipToAddress."Customer No.") THEN BEGIN
              ParentRecRef.GETTABLE(Customer);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Currency Exchange Rate":
          BEGIN
            RecRef.SETTABLE(CurrencyExchangeRate);
            IF Currency.GET(CurrencyExchangeRate."Currency Code") THEN BEGIN
              ParentRecRef.GETTABLE(Currency);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Contact Alt. Address":
          BEGIN
            RecRef.SETTABLE(ContactAltAddress);
            IF Contact.GET(ContactAltAddress."Contact No.") THEN BEGIN
              ParentRecRef.GETTABLE(Contact);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Contact Profile Answer":
          BEGIN
            RecRef.SETTABLE(ContactProfileAnswer);
            IF Contact.GET(ContactProfileAnswer."Contact No.") THEN BEGIN
              ParentRecRef.GETTABLE(Contact);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Rlshp. Mgt. Comment Line":
          BEGIN
            RecRef.SETTABLE(RlshpMgtCommentLine);
            IF RlshpMgtCommentLine."Table Name" = RlshpMgtCommentLine."Table Name"::Contact THEN
              IF Contact.GET(RlshpMgtCommentLine."No.") THEN BEGIN
                ParentRecRef.GETTABLE(Contact);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              END;
          END;
        DATABASE::"Vendor Bank Account":
          BEGIN
            RecRef.SETTABLE(VendorBankAccount);
            IF Vendor.GET(VendorBankAccount."Vendor No.") THEN BEGIN
              ParentRecRef.GETTABLE(Vendor);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Purchase Line":
          BEGIN
            RecRef.SETTABLE(PurchaseLine);
            IF PurchaseHeader.GET(PurchaseLine."Document Type",PurchaseLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(PurchaseHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
      END;
    END;

    //[External]
    PROCEDURE SetupIntegrationTables();
    VAR
      TempNameValueBuffer : Record 823 TEMPORARY;
      TableId : Integer;
    BEGIN
      CreateIntegrationPageList(TempNameValueBuffer);
      TempNameValueBuffer.FINDFIRST;
      REPEAT
        EVALUATE(TableId,TempNameValueBuffer.Value);
        InitializeIntegrationRecords(TableId);
      UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    //[External]
    PROCEDURE CreateIntegrationPageList(VAR TempNameValueBuffer : Record 823 TEMPORARY);
    VAR
      NextId : Integer;
    BEGIN
      WITH TempNameValueBuffer DO BEGIN
        DELETEALL;
        NextId := 1;

        AddToIntegrationPageList(PAGE::"Resource List",DATABASE::Resource,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Payment Terms",DATABASE::"Payment Terms",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Shipment Methods",DATABASE::"Shipment Method",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Shipping Agents",DATABASE::"Shipping Agent",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::Currencies,DATABASE::Currency,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Salespersons/Purchasers",DATABASE::"Salesperson/Purchaser",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Customer Card",DATABASE::Customer,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Vendor Card",DATABASE::Vendor,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Company Information",DATABASE::"Company Information",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Item Card",DATABASE::Item,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"G/L Account Card",DATABASE::"G/L Account",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Sales Order",DATABASE::"Sales Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Sales Invoice",DATABASE::"Sales Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Sales Credit Memo",DATABASE::"Sales Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"General Journal Batches",DATABASE::"Gen. Journal Batch",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"General Journal",DATABASE::"Gen. Journal Line",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(
          PAGE::"VAT Business Posting Groups",DATABASE::"VAT Business Posting Group",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"VAT Product Posting Groups",DATABASE::"VAT Product Posting Group",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"VAT Clauses",DATABASE::"VAT Clause",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Tax Groups",DATABASE::"Tax Group",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Tax Area List",DATABASE::"Tax Area",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Posted Sales Invoice",DATABASE::"Sales Invoice Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Posted Sales Credit Memos",DATABASE::"Sales Cr.Memo Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Units of Measure",DATABASE::"Unit of Measure",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Ship-to Address",DATABASE::"Ship-to Address",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Contact Card",DATABASE::Contact,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Countries/Regions",DATABASE::"Country/Region",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Shipment Methods",DATABASE::"Shipment Method",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Opportunity List",DATABASE::Opportunity,TempNameValueBuffer,NextId);
        // AddToIntegrationPageList(PAGE::"Units of Measure Entity",DATABASE::"Unit of Measure",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::Dimensions,DATABASE::Dimension,TempNameValueBuffer,NextId);
        // AddToIntegrationPageList(PAGE::"Item Categories Entity",DATABASE::"Item Category",TempNameValueBuffer,NextId);
        // AddToIntegrationPageList(PAGE::"Currencies Entity",DATABASE::Currency,TempNameValueBuffer,NextId);
        // AddToIntegrationPageList(PAGE::"Country/Regions Entity",DATABASE::"Country/Region",TempNameValueBuffer,NextId);
        // AddToIntegrationPageList(PAGE::"Payment Methods Entity",DATABASE::"Payment Method",TempNameValueBuffer,NextId);
        // AddToIntegrationPageList(PAGE::"Employee Entity",DATABASE::Employee,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Unlinked Attachments",DATABASE::"Unlinked Attachment",TempNameValueBuffer,NextId);
      END;
    END;

    //[External]
    PROCEDURE IsIntegrationServicesEnabled() : Boolean;
    VAR
      WebService : Record 2000000076;
    BEGIN
      EXIT(WebService.GET(WebService."Object Type"::Codeunit,'Integration Service'));
    END;

    //[External]
    PROCEDURE IsIntegrationActivated() : Boolean;
    BEGIN
      EXIT(GetIntegrationActivated);
    END;

    //[External]
    PROCEDURE EnableIntegrationServices();
    BEGIN
      IF IsIntegrationServicesEnabled THEN
        EXIT;

      SetupIntegrationService;
      SetupIntegrationServices;
      IF NOT HideMessages THEN
        MESSAGE(IntegrationServicesEnabledMsg,PRODUCTNAME.FULL);
    END;

    //[External]
    PROCEDURE DisableIntegrationServices();
    BEGIN
      IF NOT IsIntegrationServicesEnabled THEN
        EXIT;

      DeleteIntegrationService;
      DeleteIntegrationServices;

      MESSAGE(IntegrationServicesDisabledMsg,PRODUCTNAME.FULL);
    END;

    //[External]
    PROCEDURE SetConnectorIsEnabledForSession(IsEnabled : Boolean);
    BEGIN
      IntegrationIsActivated := IsEnabled;
    END;

    //[External]
    PROCEDURE IsIntegrationRecord(TableID : Integer) : Boolean;
    VAR
      isIntegrationRecord : Boolean;
    BEGIN
      OnIsIntegrationRecord(TableID,isIntegrationRecord);
      IF isIntegrationRecord THEN
        EXIT(TRUE);
      EXIT(TableID IN
        [DATABASE::Resource,
         DATABASE::"Shipping Agent",
         DATABASE::"Salesperson/Purchaser",
         DATABASE::Customer,
         DATABASE::Vendor,
         DATABASE::Dimension,
         DATABASE::"Dimension Value",
         DATABASE::"Company Information",
         DATABASE::Item,
         DATABASE::"G/L Account",
         DATABASE::"Sales Header",
         DATABASE::"Sales Invoice Header",
         DATABASE::"Gen. Journal Batch",
         DATABASE::"Sales Cr.Memo Header",
         DATABASE::"Gen. Journal Line",
         DATABASE::"VAT Business Posting Group",
         DATABASE::"VAT Product Posting Group",
         DATABASE::"VAT Clause",
         DATABASE::"Tax Group",
         DATABASE::"Tax Area",
         DATABASE::"Unit of Measure",
         DATABASE::"Ship-to Address",
         DATABASE::Contact,
         DATABASE::"Country/Region",
         DATABASE::"Customer Price Group",
         DATABASE::"Sales Price",
         DATABASE::"Payment Terms",
         DATABASE::"Shipment Method",
         DATABASE::Opportunity,
         DATABASE::"Item Category",
         DATABASE::"Country/Region",
         DATABASE::"Payment Method",
         DATABASE::Currency,
         DATABASE::Employee,
         DATABASE::"Incoming Document Attachment",
         DATABASE::"Unlinked Attachment",
         DATABASE::"Purchase Header",
         DATABASE::"Purch. Inv. Header",
         DATABASE::"G/L Entry"]);
    END;

    //[IntegrationEvent]
    //[External]
    PROCEDURE OnIsIntegrationRecord(TableID : Integer;VAR isIntegrationRecord : Boolean);
    BEGIN
    END;

    //[External]
    PROCEDURE IsIntegrationRecordChild(TableID : Integer) : Boolean;
    VAR
      isIntegrationRecordChild : Boolean;
    BEGIN
      OnIsIntegrationRecordChild(TableID,isIntegrationRecordChild);
      IF isIntegrationRecordChild THEN
        EXIT(TRUE);

      EXIT(TableID IN
        [DATABASE::"Sales Line",
         DATABASE::"Currency Exchange Rate",
         DATABASE::"Sales Invoice Line",
         DATABASE::"Sales Cr.Memo Line",
         DATABASE::"Contact Alt. Address",
         DATABASE::"Contact Profile Answer",
         DATABASE::"Dimension Value",
         DATABASE::"Rlshp. Mgt. Comment Line",
         DATABASE::"Vendor Bank Account"]);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnIsIntegrationRecordChild(TableID : Integer;VAR isIntegrationRecordChild : Boolean);
    BEGIN
    END;

    //[External]
    PROCEDURE ResetIntegrationActivated();
    BEGIN
      IntegrationIsActivated := FALSE;
    END;

    LOCAL PROCEDURE GetIntegrationActivated() : Boolean;
    VAR
      GraphSyncRunner : Codeunit 50906;
      IsSyncEnabled : Boolean;
      IsSyncDisabled : Boolean;
    BEGIN
      OnGetIntegrationDisabled(IsSyncDisabled);
      IF IsSyncDisabled THEN
        EXIT(FALSE);
      IF NOT IntegrationIsActivated THEN BEGIN
        OnGetIntegrationActivated(IsSyncEnabled);
        IF IsSyncEnabled THEN
          IntegrationIsActivated := TRUE
        ELSE
          IntegrationIsActivated := IsCRMConnectionEnabled OR GraphSyncRunner.IsGraphSyncEnabled;
      END;

      EXIT(IntegrationIsActivated);
    END;

    [IntegrationEvent(false,false)]
    LOCAL PROCEDURE OnGetIntegrationActivated(VAR IsSyncEnabled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetIntegrationDisabled(VAR IsSyncDisabled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnEnabledDatabaseTriggersSetup(TableID : Integer;VAR Enabled : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE IsCRMConnectionEnabled() : Boolean;
    VAR
      CRMConnectionSetup : Record 5330;
    BEGIN
      IF NOT CRMConnectionSetup.GET THEN
        EXIT(FALSE);

      EXIT(CRMConnectionSetup."Is Enabled");
    END;

    LOCAL PROCEDURE SetupIntegrationService();
    VAR
      WebService : Record 2000000076;
      WebServiceManagement : Codeunit 9750;
    BEGIN
      // WebServiceManagement.CreateWebService(
      //   WebService."Object Type"::Codeunit,CODEUNIT::"Integration Service",'Integration Service',TRUE);
    END;

    LOCAL PROCEDURE DeleteIntegrationService();
    VAR
      WebService : Record 2000000076;
    BEGIN
      IF WebService.GET(WebService."Object Type"::Codeunit,'Integration Service') THEN
        WebService.DELETE;
    END;

    LOCAL PROCEDURE SetupIntegrationServices();
    VAR
      TempNameValueBuffer : Record 823 TEMPORARY;
      WebService : Record 2000000076;
      Objects : Record 2000000038;
      WebServiceManagement : Codeunit 9750;
      PageId : Integer;
    BEGIN
      CreateIntegrationPageList(TempNameValueBuffer);
      TempNameValueBuffer.FINDFIRST;

      REPEAT
        EVALUATE(PageId,TempNameValueBuffer.Name);

        Objects.SETRANGE("Object Type",Objects."Object Type"::Page);
        Objects.SETRANGE("Object ID",PageId);
        IF Objects.FINDFIRST THEN
          WebServiceManagement.CreateWebService(WebService."Object Type"::Page,Objects."Object ID",
            STRSUBSTNO(PageServiceNameTok,Objects."Object Name"),TRUE);
      UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteIntegrationServices();
    VAR
      TempNameValueBuffer : Record 823 TEMPORARY;
      WebService : Record 2000000076;
      Objects : Record 2000000038;
      PageId : Integer;
    BEGIN
      CreateIntegrationPageList(TempNameValueBuffer);
      TempNameValueBuffer.FINDFIRST;

      WebService.SETRANGE("Object Type",WebService."Object Type"::Page);
      REPEAT
        EVALUATE(PageId,TempNameValueBuffer.Name);
        WebService.SETRANGE("Object ID",PageId);

        Objects.SETRANGE("Object Type",WebService."Object Type"::Page);
        Objects.SETRANGE("Object ID",PageId);
        IF Objects.FINDFIRST THEN BEGIN
          WebService.SETRANGE("Service Name",STRSUBSTNO(PageServiceNameTok,Objects."Object Name"));
          IF WebService.FINDFIRST THEN
            WebService.DELETE;
        END;
      UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE InitializeIntegrationRecords(TableID : Integer);
    VAR
      RecRef : RecordRef;
    BEGIN
      WITH RecRef DO BEGIN
        OPEN(TableID,FALSE);
        IF FINDSET(FALSE) THEN
          REPEAT
            InsertUpdateIntegrationRecord(RecRef,CURRENTDATETIME);
          UNTIL NEXT = 0;
        CLOSE;
      END;
    END;

    //[External]
    PROCEDURE InsertUpdateIntegrationRecord(RecRef : RecordRef;IntegrationLastModified : DateTime) IntegrationID : GUID;
    VAR
      IntegrationRecord : Record "Integration Record 1";
      Handled : Boolean;
    BEGIN
      IF IsIntegrationRecord(RecRef.NUMBER) THEN
        WITH IntegrationRecord DO BEGIN
          IF FindByRecordId(RecRef.RECORDID) THEN BEGIN
            "Modified On" := IntegrationLastModified;
            UpdateReferencedIdField("Integration ID",RecRef,Handled);
            OnUpdateRelatedRecordIdFields(RecRef);
            MODIFY;
          END ELSE BEGIN
            RESET;
            INIT;
            GetPredefinedIdValue("Integration ID",RecRef,Handled);
            IF NOT Handled THEN
              "Integration ID" := CREATEGUID;
            "Record ID" := RecRef.RECORDID;
            "Table ID" := RecRef.NUMBER;
            "Modified On" := IntegrationLastModified;
            INSERT;
            IF NOT Handled THEN
              UpdateReferencedIdField("Integration ID",RecRef,Handled);
            OnUpdateRelatedRecordIdFields(RecRef);
          END;

          IntegrationID := "Integration ID";
          ReactivateJobForTable(RecRef.NUMBER);
        END;
    END;

    LOCAL PROCEDURE ReactivateJobForTable(TableNo : Integer);
    VAR
      JobQueueEntry : Record 472;
      DataUpgradeMgt : Codeunit 9900;
    BEGIN
      IF DataUpgradeMgt.IsUpgradeInProgress THEN
        EXIT;
      JobQueueEntry.FilterInactiveOnHoldEntries;
      IF JobQueueEntry.ISEMPTY THEN
        EXIT;
      JobQueueEntry.FINDSET;
      REPEAT
        IF IsJobActsOnTable(JobQueueEntry,TableNo) THEN
          JobQueueEntry.Restart;
      UNTIL JobQueueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE IsJobActsOnTable(JobQueueEntry : Record 472;TableNo : Integer) : Boolean;
    VAR
      IntegrationTableMapping : Record 5335;
      RecRef : RecordRef;
    BEGIN
      IF RecRef.GET(JobQueueEntry."Record ID to Process") AND
         (RecRef.NUMBER = DATABASE::"Integration Table Mapping")
      THEN BEGIN
        RecRef.SETTABLE(IntegrationTableMapping);
        EXIT(IntegrationTableMapping."Table ID" = TableNo);
      END;
    END;

    LOCAL PROCEDURE AddToIntegrationPageList(PageId : Integer;TableId : Integer;VAR TempNameValueBuffer : Record 823 TEMPORARY;VAR NextId : Integer);
    BEGIN
      WITH TempNameValueBuffer DO BEGIN
        INIT;
        ID := NextId;
        NextId := NextId + 1;
        Name := FORMAT(PageId);
        Value := FORMAT(TableId);
        INSERT;
      END;
    END;

    //[External]
    PROCEDURE SetHideMessages(HideMessagesNew : Boolean);
    BEGIN
      HideMessages := HideMessagesNew;
    END;

    //[External]
    PROCEDURE GetIdWithoutBrackets(Id : GUID) : Text;
    BEGIN
      EXIT(COPYSTR(FORMAT(Id),2,STRLEN(FORMAT(Id)) - 2));
    END;

    LOCAL PROCEDURE GetPredefinedIdValue(VAR Id : GUID;VAR RecRef : RecordRef;VAR Handled : Boolean);
    VAR
      DummyGenJnlLine : Record 81;
      DummyGLAccount : Record 15;
      DummyTaxGroup : Record 321;
      DummyVATProductPostingGroup : Record 324;
      DummyGenJournalBatch : Record 232;
      DummyCustomer : Record 18;
      DummyVendor : Record 23;
      DummyCompanyInfo : Record 79;
      DummyItem : Record 27;
      DummySalesInvoiceEntityAggregate : Record 5475;
      DummyPurchInvEntityAggregate : Record 5477;
      DummyEmployee : Record 5200;
      DummyCurrency : Record 4;
      DummyPaymentMethod : Record 289;
      DummyDimension : Record 348;
      DummyDimensionValue : Record 349;
      DummyPaymentTerms : Record 3;
      DummyShipmentMethod : Record 10;
      DummyItemCategory : Record 5722;
      DummyCountryRegion : Record 9;
      DummyUnitOfMeasure : Record 204;
      DummyPurchaseHeader : Record 38;
      DummyUnlinkedAttachment : Record 138;
      DummyTaxArea : Record 318;
      DummySalesCrMemoEntityBuffer : Record 5507;
      DummyIncomingDocumentAttachment : Record 133;
      GraphMgtGeneralTools : Codeunit 5465;
      GraphMgtGeneralTools1 : Codeunit 50917;
      GraphMgtSalesHeader : Codeunit 5474;
      GraphMgtSalesHeader1 : Codeunit 50926;
    BEGIN
      CASE RecRef.NUMBER OF
        DATABASE::"Gen. Journal Line":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::"Gen. Journal Line",DummyGenJnlLine.FIELDNO(SystemId));
        DATABASE::"G/L Account":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::"G/L Account",DummyGLAccount.FIELDNO(SystemId));
        DATABASE::"Tax Group":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,RecRef.NUMBER,DummyTaxGroup.FIELDNO(SystemId));
        DATABASE::"VAT Product Posting Group":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,RecRef.NUMBER,DummyVATProductPostingGroup.FIELDNO(SystemId));
        DATABASE::"Gen. Journal Batch":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::"Gen. Journal Batch",DummyGenJournalBatch.FIELDNO(SystemId));
        DATABASE::Customer:
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,DATABASE::Customer,DummyCustomer.FIELDNO(SystemId));
        DATABASE::Vendor:
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,DATABASE::Vendor,DummyVendor.FIELDNO(SystemId));
        DATABASE::"Company Information":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,
            Handled,DATABASE::"Company Information",DummyCompanyInfo.FIELDNO(SystemId));
        DATABASE::Item:
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,DATABASE::Item,DummyItem.FIELDNO(SystemId));
        DATABASE::"Sales Header":
          GraphMgtSalesHeader1.GetPredefinedIdValue(Id,RecRef,Handled);
        DATABASE::"Sales Invoice Header":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,RecRef.NUMBER,DummySalesInvoiceEntityAggregate.FIELDNO(Id));
        DATABASE::Employee:
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::Employee,DummyEmployee.FIELDNO(SystemId));
        DATABASE::Currency:
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::Currency,DummyCurrency.FIELDNO(SystemId));
        DATABASE::"Payment Method":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Payment Method",DummyPaymentMethod.FIELDNO(SystemId));
        DATABASE::Dimension:
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::Dimension,DummyDimension.FIELDNO(SystemId));
        DATABASE::"Dimension Value":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::"Dimension Value",DummyDimensionValue.FIELDNO(SystemId));
        DATABASE::"Payment Terms":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::"Payment Terms",DummyPaymentTerms.FIELDNO(SystemId));
        DATABASE::"Shipment Method":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,DATABASE::"Shipment Method",DummyShipmentMethod.FIELDNO(SystemId));
        DATABASE::"Item Category":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Item Category",DummyItemCategory.FIELDNO(SystemId));
        DATABASE::"Country/Region":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Country/Region",DummyCountryRegion.FIELDNO(SystemId));
        DATABASE::"Unit of Measure":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Unit of Measure",DummyUnitOfMeasure.FIELDNO(SystemId));
        DATABASE::"Purchase Header":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Purchase Header",DummyPurchaseHeader.FIELDNO(SystemId));
        DATABASE::"Unlinked Attachment":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Unlinked Attachment",DummyUnlinkedAttachment.FIELDNO(Id));
        DATABASE::"VAT Business Posting Group",DATABASE::"Tax Area",DATABASE::"VAT Clause":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            RecRef.NUMBER,DummyTaxArea.FIELDNO(SystemId));
        DATABASE::"Sales Cr.Memo Header":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,RecRef.NUMBER,DummySalesCrMemoEntityBuffer.FIELDNO(Id));
        DATABASE::"Purch. Inv. Header":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(
            Id,RecRef,Handled,RecRef.NUMBER,DummyPurchInvEntityAggregate.FIELDNO(Id));
        DATABASE::"Incoming Document Attachment":
          GraphMgtGeneralTools1.HandleGetPredefinedIdValue(Id,RecRef,Handled,
            DATABASE::"Incoming Document Attachment",DummyIncomingDocumentAttachment.FIELDNO(SystemId));
        DATABASE::"Sales Invoice Line",DATABASE::"Purch. Inv. Line",DATABASE::"Vendor Bank Account":
          Handled := TRUE;
        ELSE
          OnGetPredefinedIdValue(Id,RecRef,Handled)
      END;
    END;

    LOCAL PROCEDURE UpdateReferencedIdField(VAR Id : GUID;VAR RecRef : RecordRef;VAR Handled : Boolean);
    VAR
      DummyGenJnlLine : Record 81;
      DummyGLAccount : Record 15;
      DummyTaxGroup : Record 321;
      DummyVATProductPostingGroup : Record 324;
      DummyGenJournalBatch : Record 232;
      DummyCustomer : Record 18;
      DummyVendor : Record 23;
      DummyCompanyInfo : Record 79;
      DummyItem : Record 27;
      DummySalesInvoiceEntityAggregate : Record 5475;
      DummyPurchInvEntityAggregate : Record 5477;
      DummyEmployee : Record 5200;
      DummyCurrency : Record 4;
      DummyPaymentMethod : Record 289;
      DummyDimension : Record 348;
      DummyDimensionValue : Record 349;
      DummyPaymentTerms : Record 3;
      DummyShipmentMethod : Record 10;
      DummyItemCategory : Record 5722;
      DummyCountryRegion : Record 9;
      DummyUnitOfMeasure : Record 204;
      DummyPurchaseHeader : Record 38;
      DummyUnlinkedAttachment : Record 138;
      DummyTaxArea : Record 318;
      DummySalesCrMemoEntityBuffer : Record 5507;
      DummyIncomingDocumentAttachment : Record 133;
      GraphMgtGeneralTools : Codeunit 5465;
      GraphMgtSalesHeader : Codeunit 5474;
      GraphMgtSalesHeader1 : Codeunit 50926;
    BEGIN
      CASE RecRef.NUMBER OF
        DATABASE::"Gen. Journal Line":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Gen. Journal Line",DummyGenJnlLine.FIELDNO(SystemId));
        DATABASE::"G/L Account":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"G/L Account",DummyGLAccount.FIELDNO(SystemId));
        DATABASE::"Tax Group":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,RecRef.NUMBER,DummyTaxGroup.FIELDNO(SystemId));
        DATABASE::"VAT Product Posting Group":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,RecRef.NUMBER,DummyVATProductPostingGroup.FIELDNO(SystemId));
        DATABASE::"Gen. Journal Batch":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Gen. Journal Batch",DummyGenJournalBatch.FIELDNO(SystemId));
        DATABASE::Customer:
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::Customer,DummyCustomer.FIELDNO(SystemId));
        DATABASE::Vendor:
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::Vendor,DummyVendor.FIELDNO(SystemId));
        DATABASE::"Company Information":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Company Information",DummyCompanyInfo.FIELDNO(SystemId));
        DATABASE::Item:
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::Item,DummyItem.FIELDNO(SystemId));
        DATABASE::"Sales Header":
          GraphMgtSalesHeader1.UpdateReferencedIdFieldOnSalesHeader(RecRef,Id,Handled);
        DATABASE::"Sales Invoice Header":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,RecRef.NUMBER,DummySalesInvoiceEntityAggregate.FIELDNO(Id));
        DATABASE::Employee:
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,Id,Handled,
            DATABASE::Employee,DummyEmployee.FIELDNO(SystemId));
        DATABASE::Currency:
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,Id,Handled,
            DATABASE::Currency,DummyCurrency.FIELDNO(SystemId));
        DATABASE::"Payment Method":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,Id,Handled,
            DATABASE::"Payment Method",DummyPaymentMethod.FIELDNO(SystemId));
        DATABASE::Dimension:
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::Dimension,DummyDimension.FIELDNO(SystemId));
        DATABASE::"Dimension Value":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Dimension Value",DummyDimensionValue.FIELDNO(SystemId));
        DATABASE::"Payment Terms":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Payment Terms",DummyPaymentTerms.FIELDNO(SystemId));
        DATABASE::"Shipment Method":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Shipment Method",DummyShipmentMethod.FIELDNO(SystemId));
        DATABASE::"Item Category":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,Id,Handled,
            DATABASE::"Item Category",DummyItemCategory.FIELDNO(SystemId));
        DATABASE::"Country/Region":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,Id,Handled,
            DATABASE::"Country/Region",DummyCountryRegion.FIELDNO(SystemId));
        DATABASE::"Unit of Measure":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Unit of Measure",DummyUnitOfMeasure.FIELDNO(SystemId));
        DATABASE::"Purchase Header":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,Id,Handled,
            DATABASE::"Purchase Header",DummyPurchaseHeader.FIELDNO(SystemId));
        DATABASE::"Unlinked Attachment":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Unlinked Attachment",DummyUnlinkedAttachment.FIELDNO(Id));
        DATABASE::"VAT Business Posting Group",DATABASE::"Tax Area",DATABASE::"VAT Clause":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,RecRef.NUMBER,DummyTaxArea.FIELDNO(SystemId));
        DATABASE::"Sales Cr.Memo Header":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Sales Cr.Memo Header",DummySalesCrMemoEntityBuffer.FIELDNO(Id));
        DATABASE::"Purch. Inv. Header":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,RecRef.NUMBER,DummyPurchInvEntityAggregate.FIELDNO(Id));
        DATABASE::"Incoming Document Attachment":
          GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(
            RecRef,Id,Handled,DATABASE::"Incoming Document Attachment",DummyIncomingDocumentAttachment.FIELDNO(SystemId));
        DATABASE::"Sales Invoice Line",DATABASE::"Purch. Inv. Line",DATABASE::"Vendor Bank Account":
          Handled := TRUE;
        ELSE
          OnUpdateReferencedIdField(RecRef,Id,Handled);
      END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnDeleteIntegrationRecord(VAR RecRef : RecordRef);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateReferencedIdField(VAR RecRef : RecordRef;NewId : GUID;VAR Handled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetPredefinedIdValue(VAR Id : GUID;VAR RecRef : RecordRef;VAR Handled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnUpdateRelatedRecordIdFields(VAR RecRef : RecordRef);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}








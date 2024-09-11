Codeunit 50027 "SII Scheme Code Mgt. 1"
{


    trigger OnRun()
    BEGIN
    END;

    //[External]
    PROCEDURE GetMaxNumberOfRegimeCodes(): Integer;
    BEGIN
        EXIT(3);
    END;

    //[External]
    PROCEDURE SalesDocHasRegimeCodes(RecVar: Variant): Boolean;
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        IF NOT GetSIISalesDocRecFromRec(SIISalesDocumentSchemeCode, RecVar) THEN
            EXIT(FALSE);
        EXIT(NOT SIISalesDocumentSchemeCode.ISEMPTY);
    END;

    //[External]
    PROCEDURE SalesDrillDownRegimeCodes(RecVar: Variant);
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        IF GetSIISalesDocRecFromRec(SIISalesDocumentSchemeCode, RecVar) THEN
            PAGE.RUNMODAL(0, SIISalesDocumentSchemeCode);
    END;

    LOCAL PROCEDURE GetSIISalesDocRecFromRec(VAR SIISalesDocumentSchemeCode: Record 10755; RecVar: Variant): Boolean;
    VAR
        SalesHeader: Record 36;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        ServiceHeader: Record 5900;
        ServiceInvoiceHeader: Record 5992;
        ServiceCrMemoHeader: Record 5994;
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(RecVar);
        CASE RecRef.NUMBER OF
            DATABASE::"Sales Header":
                BEGIN
                    RecRef.SETTABLE(SalesHeader);
                    SIISalesDocumentSchemeCode.SETRANGE("Entry Type", SIISalesDocumentSchemeCode."Entry Type"::Sales);
                    SIISalesDocumentSchemeCode.SETRANGE("Document Type", SalesHeader."Document Type");
                    SIISalesDocumentSchemeCode.SETRANGE("Document No.", SalesHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Sales Invoice Header":
                BEGIN
                    RecRef.SETTABLE(SalesInvoiceHeader);
                    SIISalesDocumentSchemeCode.SETRANGE("Entry Type", SIISalesDocumentSchemeCode."Entry Type"::Sales);
                    SIISalesDocumentSchemeCode.SETRANGE("Document Type", SIISalesDocumentSchemeCode."Document Type"::"Posted Invoice");
                    SIISalesDocumentSchemeCode.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    RecRef.SETTABLE(SalesCrMemoHeader);
                    SIISalesDocumentSchemeCode.SETRANGE("Entry Type", SIISalesDocumentSchemeCode."Entry Type"::Sales);
                    SIISalesDocumentSchemeCode.SETRANGE("Document Type", SIISalesDocumentSchemeCode."Document Type"::"Posted Credit Memo");
                    SIISalesDocumentSchemeCode.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Service Header":
                BEGIN
                    RecRef.SETTABLE(ServiceHeader);
                    SIISalesDocumentSchemeCode.SETRANGE("Entry Type", SIISalesDocumentSchemeCode."Entry Type"::Service);
                    SIISalesDocumentSchemeCode.SETRANGE("Document Type", ServiceHeader."Document Type");
                    SIISalesDocumentSchemeCode.SETRANGE("Document No.", ServiceHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Service Invoice Header":
                BEGIN
                    RecRef.SETTABLE(ServiceInvoiceHeader);
                    SIISalesDocumentSchemeCode.SETRANGE("Entry Type", SIISalesDocumentSchemeCode."Entry Type"::Service);
                    SIISalesDocumentSchemeCode.SETRANGE("Document Type", SIISalesDocumentSchemeCode."Document Type"::"Posted Invoice");
                    SIISalesDocumentSchemeCode.SETRANGE("Document No.", ServiceInvoiceHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Service Cr.Memo Header":
                BEGIN
                    RecRef.SETTABLE(ServiceCrMemoHeader);
                    SIISalesDocumentSchemeCode.SETRANGE("Entry Type", SIISalesDocumentSchemeCode."Entry Type"::Service);
                    SIISalesDocumentSchemeCode.SETRANGE("Document Type", SIISalesDocumentSchemeCode."Document Type"::"Posted Credit Memo");
                    SIISalesDocumentSchemeCode.SETRANGE("Document No.", ServiceCrMemoHeader."No.");
                    EXIT(TRUE);
                END;
        END;
    END;

    LOCAL PROCEDURE MoveSalesRegimeCodesToPostedDoc(DocType: Option; DocNo: Code[20]; EntryType: Option; PostedDocType: Option; PostedDocNo: Code[20]);
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
        NewSIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        SIISalesDocumentSchemeCode.SETRANGE("Entry Type", EntryType);
        SIISalesDocumentSchemeCode.SETRANGE("Document Type", DocType);
        SIISalesDocumentSchemeCode.SETRANGE("Document No.", DocNo);
        IF NOT SIISalesDocumentSchemeCode.FINDSET THEN
            EXIT;

        REPEAT
            NewSIISalesDocumentSchemeCode := SIISalesDocumentSchemeCode;
            NewSIISalesDocumentSchemeCode."Document Type" := PostedDocType;
            NewSIISalesDocumentSchemeCode."Document No." := PostedDocNo;
            NewSIISalesDocumentSchemeCode.INSERT;
        UNTIL SIISalesDocumentSchemeCode.NEXT = 0;
        SIISalesDocumentSchemeCode.DELETEALL(TRUE);
    END;

    //[External]
    PROCEDURE PurchDocHasRegimeCodes(RecVar: Variant): Boolean;
    VAR
        SIIPurchDocSchemeCode: Record 10756;
    BEGIN
        IF NOT GetSIIPurchDocRecFromRec(SIIPurchDocSchemeCode, RecVar) THEN
            EXIT(FALSE);
        EXIT(NOT SIIPurchDocSchemeCode.ISEMPTY);
    END;

    //[External]
    PROCEDURE PurchDrillDownRegimeCodes(RecVar: Variant);
    VAR
        SIIPurchDocSchemeCode: Record 10756;
    BEGIN
        IF GetSIIPurchDocRecFromRec(SIIPurchDocSchemeCode, RecVar) THEN
            PAGE.RUNMODAL(0, SIIPurchDocSchemeCode);
    END;

    LOCAL PROCEDURE GetSIIPurchDocRecFromRec(VAR SIIPurchDocSchemeCode: Record 10756; RecVar: Variant): Boolean;
    VAR
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(RecVar);
        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseHeader);
                    SIIPurchDocSchemeCode.SETRANGE("Document Type", PurchaseHeader."Document Type");
                    SIIPurchDocSchemeCode.SETRANGE("Document No.", PurchaseHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Purch. Inv. Header":
                BEGIN
                    RecRef.SETTABLE(PurchInvHeader);
                    SIIPurchDocSchemeCode.SETRANGE("Document Type", SIIPurchDocSchemeCode."Document Type"::"Posted Invoice");
                    SIIPurchDocSchemeCode.SETRANGE("Document No.", PurchInvHeader."No.");
                    EXIT(TRUE);
                END;
            DATABASE::"Purch. Cr. Memo Hdr.":
                BEGIN
                    RecRef.SETTABLE(PurchCrMemoHdr);
                    SIIPurchDocSchemeCode.SETRANGE("Document Type", SIIPurchDocSchemeCode."Document Type"::"Posted Credit Memo");
                    SIIPurchDocSchemeCode.SETRANGE("Document No.", PurchCrMemoHdr."No.");
                    EXIT(TRUE);
                END;
        END;
    END;

    LOCAL PROCEDURE MovePurchRegimeCodesToPostedDoc(PurchaseHeader: Record 38; PostedDocType: Option; PostedDocNo: Code[20]);
    VAR
        SIIPurchDocSchemeCode: Record 10756;
        NewSIIPurchDocSchemeCode: Record 10756;
    BEGIN
        SIIPurchDocSchemeCode.SETRANGE("Document Type", PurchaseHeader."Document Type");
        SIIPurchDocSchemeCode.SETRANGE("Document No.", PurchaseHeader."No.");
        IF NOT SIIPurchDocSchemeCode.FINDSET THEN
            EXIT;

        REPEAT
            NewSIIPurchDocSchemeCode := SIIPurchDocSchemeCode;
            NewSIIPurchDocSchemeCode."Document Type" := PostedDocType;
            NewSIIPurchDocSchemeCode."Document No." := PostedDocNo;
            NewSIIPurchDocSchemeCode.INSERT;
        UNTIL SIIPurchDocSchemeCode.NEXT = 0;
        SIIPurchDocSchemeCode.DELETEALL(TRUE);
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterSalesInvHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterSalesInvHeaderInsert(VAR SalesInvHeader: Record 112; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        MoveSalesRegimeCodesToPostedDoc(
          ConvertDocumentTypeToOptionSalesDocumentType(SalesHeader."Document Type"), SalesHeader."No.", SIISalesDocumentSchemeCode."Entry Type"::Sales,
          SIISalesDocumentSchemeCode."Document Type"::"Posted Invoice", SalesInvHeader."No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterSalesCrMemoHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterSalesCrMemoHeaderInsert(VAR SalesCrMemoHeader: Record 114; SalesHeader: Record 36; CommitIsSuppressed: Boolean);
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        MoveSalesRegimeCodesToPostedDoc(
          ConvertDocumentTypeToOptionSalesDocumentType(SalesHeader."Document Type"), SalesHeader."No.", SIISalesDocumentSchemeCode."Entry Type"::Sales,
          SIISalesDocumentSchemeCode."Document Type"::"Posted Credit Memo", SalesCrMemoHeader."No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 5988, OnAfterServInvHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterServInvHeaderInsert(VAR ServiceInvoiceHeader: Record 5992; ServiceHeader: Record 5900);
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        MoveSalesRegimeCodesToPostedDoc(
          ConvertDocumentTypeToOptionServiceDocumentType(ServiceHeader."Document Type"), ServiceHeader."No.", SIISalesDocumentSchemeCode."Entry Type"::Service,
          SIISalesDocumentSchemeCode."Document Type"::"Posted Invoice", ServiceInvoiceHeader."No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 5988, OnAfterServCrMemoHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterServCrMemoHeaderInsert(VAR ServiceCrMemoHeader: Record 5994; ServiceHeader: Record 5900);
    VAR
        SIISalesDocumentSchemeCode: Record 10755;
    BEGIN
        MoveSalesRegimeCodesToPostedDoc(
          ConvertDocumentTypeToOptionServiceDocumentType(ServiceHeader."Document Type"), ServiceHeader."No.", SIISalesDocumentSchemeCode."Entry Type"::Service,
          SIISalesDocumentSchemeCode."Document Type"::"Posted Credit Memo", ServiceCrMemoHeader."No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPurchInvHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterPurchInvHeaderInsert(VAR PurchInvHeader: Record 122; VAR PurchHeader: Record 38);
    VAR
        SIIPurchDocSchemeCode: Record 10756;
    BEGIN
        MovePurchRegimeCodesToPostedDoc(PurchHeader, SIIPurchDocSchemeCode."Document Type"::"Posted Invoice", PurchInvHeader."No.");
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPurchCrMemoHeaderInsert, '', true, true)]
    LOCAL PROCEDURE OnAfterPurchCrMemoHeaderInsert(VAR PurchCrMemoHdr: Record 124; VAR PurchHeader: Record 38; CommitIsSupressed: Boolean);
    VAR
        SIIPurchDocSchemeCode: Record 10756;
    BEGIN
        MovePurchRegimeCodesToPostedDoc(PurchHeader, SIIPurchDocSchemeCode."Document Type"::"Posted Credit Memo", PurchCrMemoHdr."No.");
    END;


    //procedures to convert enum to option
    procedure ConvertDocumentTypeToOptionSalesDocumentType(DocumentType: Enum "Sales Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionServiceDocumentType(DocumentType: Enum "Service Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    /* /*BEGIN
END.*/
}










tableextension 50209 "QBU SII Doc. Upload StateExt" extends "SII Doc. Upload State"
{


    CaptionML = ENU = 'SII Doc. Upload States', ESP = 'Estados de carga de doc. SII';

    fields
    {
    }
    keys
    {
        // key(key1;"Id")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Entry No")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
    }


    // procedure CreateNewRequest (EntryNo@1100000 : Integer;DocumentSource@1100001 : 'Customer Ledger,Vendor Ledger,Detailed Customer Ledger,Detailed Vendor Ledger';DocumentType@1100006 : ',Payment,Invoice,Credit Memo';DocumentNo@1100005 : Code[35];ExternalDocumentNo@1100010 : Code[35];PostingDate@1100007 :

    /*
    procedure CreateNewRequest (EntryNo: Integer;DocumentSource: Option "Customer Ledger","Vendor Ledger","Detailed Customer Ledger","Detailed Vendor Ledger";DocumentType: ',Payment,Invoice,Credit Memo';DocumentNo: Code[35];ExternalDocumentNo: Code[35];PostingDate: Date)
        begin
          CreateNewRequestInternal(EntryNo,0,DocumentSource,DocumentType,DocumentNo,ExternalDocumentNo,PostingDate);
        end;
    */


    //     procedure CreateNewCollectionsInCashRequest (CustomerNo@1100000 : Code[20];PostingDate@1100007 : Date;TotalAmount@1100001 :

    /*
    procedure CreateNewCollectionsInCashRequest (CustomerNo: Code[20];PostingDate: Date;TotalAmount: Decimal) : Boolean;
        var
    //       Customer@1100005 :
          Customer: Record 18;
    //       SIIHistory@1100002 :
          SIIHistory: Record 10750;
    //       SIIDocUploadState@1100004 :
          SIIDocUploadState: Record 10752;
    //       SIIManagement@1100006 :
          SIIManagement: Codeunit 10756;
        begin
          if not SIIManagement.IsSIISetupEnabled then
            exit;

          SIIDocUploadState.SETRANGE("Posting Date",PostingDate);
          SIIDocUploadState.SETRANGE("CV No.",CustomerNo);
          SIIDocUploadState.SETRANGE("Transaction Type",SIIDocUploadState."Transaction Type"::"Collection In Cash");
          if SIIDocUploadState.FINDFIRST then begin
            if SIIDocUploadState."Total Amount In Cash" = TotalAmount then
              exit(FALSE);
            SIIDocUploadState.VALIDATE("Total Amount In Cash",TotalAmount);
            SIIDocUploadState.VALIDATE("Retry Accepted",
              SIIDocUploadState.Status IN [SIIDocUploadState.Status::Accepted,SIIDocUploadState.Status::"Accepted With Errors"]);
            SIIDocUploadState.MODIFY(TRUE);
            SIIHistory.CreateNewRequest(
              SIIDocUploadState.Id,SIIHistory."Upload Type"::"Collection In Cash",4,FALSE,SIIDocUploadState."Retry Accepted");
            exit(TRUE);
          end;
          SIIDocUploadState.INIT;
          SIIDocUploadState."Document Source" := SIIDocUploadState."Document Source"::"Customer Ledger";
          SIIDocUploadState."Posting Date" := PostingDate;
          SetStatus(SIIDocUploadState);
          SIIDocUploadState."Transaction Type" := SIIDocUploadState."Transaction Type"::"Collection In Cash";
          SIIDocUploadState.VALIDATE("CV No.",CustomerNo);
          Customer.GET(SIIDocUploadState."CV No.");
          SIIDocUploadState.VALIDATE("VAT Registration No.",Customer."VAT Registration No.");
          SIIDocUploadState.VALIDATE("CV Name",Customer.Name);
          SIIDocUploadState.VALIDATE("Country/Region Code",Customer."Country/Region Code");
          SIIDocUploadState.VALIDATE("Total Amount In Cash",TotalAmount);
          SIIDocUploadState.INSERT;
          SIIHistory.CreateNewRequest(SIIDocUploadState.Id,SIIHistory."Upload Type"::"Collection In Cash",4,FALSE,FALSE);
          exit(TRUE);
        end;
    */


    //     procedure CreateNewVendPmtRequest (PmtEntryNo@1100005 : Integer;InvEntryNo@1100000 : Integer;DocumentNo@1100004 : Code[35];PostingDate@1100002 :

    /*
    procedure CreateNewVendPmtRequest (PmtEntryNo: Integer;InvEntryNo: Integer;DocumentNo: Code[35];PostingDate: Date)
        begin
          CreateNewRequestInternal(
            PmtEntryNo,InvEntryNo,"Document Source"::"Detailed Vendor Ledger","Document Type"::Payment,DocumentNo,'',PostingDate);
        end;
    */


    //     procedure CreateNewCustPmtRequest (PmtEntryNo@1100005 : Integer;InvEntryNo@1100000 : Integer;DocumentNo@1100004 : Code[30];PostingDate@1100002 :

    /*
    procedure CreateNewCustPmtRequest (PmtEntryNo: Integer;InvEntryNo: Integer;DocumentNo: Code[30];PostingDate: Date)
        begin
          CreateNewRequestInternal(
            PmtEntryNo,InvEntryNo,"Document Source"::"Detailed Customer Ledger","Document Type"::Payment,DocumentNo,'',PostingDate);
        end;
    */


    // //     LOCAL procedure CreateNewRequestInternal (EntryNo@1100000 : Integer;InvEntryNo@1100008 : Integer;DocumentSource@1100001 : 'Customer Ledger,Vendor Ledger,Detailed Customer Ledger,Detailed Vendor Ledger';DocumentType@1100006 : ',Payment,Invoice,Credit Memo';DocumentNo@1100005 : Code[35];ExternalDocumentNo@1100010 : Code[35];PostingDate@1100007 :
    // LOCAL procedure CreateNewRequestInternal(EntryNo: Integer; InvEntryNo: Integer; DocumentSource: Option "Customer Ledger","Vendor Ledger","Detailed Customer Ledger","Detailed Vendor Ledger"; DocumentType: Option "","Payment","Invoice","Credit Memo"; DocumentNo: Code[35]; ExternalDocumentNo: Code[35]; PostingDate: Date)
    // var
    //     //       SIIHistory@1100002 :
    //     SIIHistory: Record 10750;
    //     //       SIIDocUploadState@1100004 :
    //     SIIDocUploadState: Record 10752;
    //     //       TempSIIDocUploadState@1100011 :
    //     TempSIIDocUploadState: Record 10752 TEMPORARY;
    //     //       SIIManagement@1100003 :
    //     SIIManagement: Codeunit 10756;
    //     //       IsCVPayment@1100009 :
    //     IsCVPayment: Boolean;
    // begin
    //     if not SIIManagement.IsSIISetupEnabled then
    //         exit;

    //     IsCVPayment := DocumentSource IN [SIIDocUploadState."Document Source"::"Detailed Customer Ledger",
    //                                       SIIDocUploadState."Document Source"::"Detailed Vendor Ledger"];
    //     if IsCVPayment then
    //         SIIDocUploadState.SETRANGE("Inv. Entry No", InvEntryNo)
    //     else
    //         SIIDocUploadState.SETRANGE("Entry No", EntryNo);
    //     SIIDocUploadState.SETRANGE("Document Source", DocumentSource);
    //     if SIIDocUploadState.FINDFIRST then begin
    //         if IsCVPayment then begin
    //             // Create additional request to handle one more partial payment if no such request in state Pending
    //             SIIHistory.SETRANGE("Document State Id", SIIDocUploadState.Id);
    //             SIIHistory.SETRANGE(Status, SIIHistory.Status::Pending);
    //             if SIIHistory.ISEMPTY then
    //                 SIIHistory.CreateNewRequest(SIIDocUploadState.Id, SIIHistory."Upload Type"::Regular, 4, FALSE, TRUE);
    //         end;
    //         exit;
    //     end;

    //     TempSIIDocUploadState.INIT;
    //     ValidateDocInfo(TempSIIDocUploadState, EntryNo, DocumentSource, DocumentType, DocumentNo);
    //     SIIDocUploadState.INIT;
    //     SIIDocUploadState := TempSIIDocUploadState;
    //     SIIDocUploadState."Document No." := DocumentNo;
    //     SIIDocUploadState."External Document No." := ExternalDocumentNo;
    //     SIIDocUploadState."Posting Date" := PostingDate;
    //     SIIDocUploadState."Transaction Type" := SIIDocUploadState."Transaction Type"::Regular;
    //     SIIDocUploadState."Inv. Entry No" := InvEntryNo;
    //     SIIDocUploadState.GetCorrectionInfo(
    //       SIIDocUploadState."Corrected Doc. No.", SIIDocUploadState."Corr. Posting Date", SIIDocUploadState."Posting Date");
    //     SIIDocUploadState."Version No." := GetSIIVersionNo;
    //     SetStatus(SIIDocUploadState);
    //     SIIDocUploadState.INSERT;

    //     SIIHistory.CreateNewRequest(SIIDocUploadState.Id, SIIHistory."Upload Type"::Regular, 4, FALSE, FALSE);
    // end;


    /*
    procedure CreateCommunicationErrorRetries ()
        var
    //       SIIHistory@1100000 :
          SIIHistory: Record 10750;
    //       SIIDocUploadState@1100001 :
          SIIDocUploadState: Record 10752;
        begin
          SIIDocUploadState.SETRANGE(Status,SIIDocUploadState.Status::"Communication Error");

          if SIIDocUploadState.FINDSET then begin
            repeat
              // We want latest first. Ideally we'd use something like 'by date desc', but since NAV does not allow us to do that,
              // we rely on PK and that the date does not change in a weird way.
              SIIHistory.RESET;
              SIIHistory.ASCENDING(FALSE);
              SIIHistory.SETRANGE("Document State Id",SIIDocUploadState.Id);
              SIIHistory.SETRANGE("Is Manual",FALSE);

              SIIHistory.SETRANGE("Upload Type",SIIHistory."Upload Type"::Regular);
              // if the latest doc is in "CommunicationError" state, we issue a retry.
              CreateCommunicationErrorRetryRequest(SIIHistory);
            until SIIDocUploadState.NEXT = 0;
          end;
        end;
    */


    //     LOCAL procedure CreateCommunicationErrorRetryRequest (var SIIHistory@1100000 :

    /*
    LOCAL procedure CreateCommunicationErrorRetryRequest (var SIIHistory: Record 10750)
        begin
          if SIIHistory.FINDFIRST then
            if SIIHistory.Status = SIIHistory.Status::"Communication Error" then
              SIIHistory.CreateNewRequest(
                SIIHistory."Document State Id",SIIHistory."Upload Type",
                SIIHistory."Retries Left",FALSE,FALSE);
        end;
    */


    //     LOCAL procedure SetStatus (var SIIDocUploadState@1100000 :

    /*
    LOCAL procedure SetStatus (var SIIDocUploadState: Record 10752)
        begin
          SIIDocUploadState.Status := Status::Pending;
        end;
    */


    //     procedure UpdateDocInfoOnSIIDocUploadState (DocFieldNo@1100000 :

    /*
    procedure UpdateDocInfoOnSIIDocUploadState (DocFieldNo: Integer)
        begin
          if not (Status IN [Status::Pending,Status::Incorrect,Status::"Accepted With Errors"]) then
            FIELDERROR(Status);
          UpdateFieldOnSIIDOcUploadState(DocFieldNo);
        end;
    */


    //     procedure UpdateFieldOnSIIDOcUploadState (FieldNo@1100000 :

    /*
    procedure UpdateFieldOnSIIDOcUploadState (FieldNo: Integer)
        var
    //       RecRef@1100002 :
          RecRef: RecordRef;
    //       FieldRef@1100001 :
          FieldRef: FieldRef;
        begin
          RecRef.GETTABLE(Rec);
          FieldRef := RecRef.FIELD(FieldNo);
          FieldRef.VALIDATE(FieldRef.VALUE);
          RecRef.MODIFY(TRUE);
          RecRef.SETTABLE(Rec);
        end;
    */


    //     procedure GetSIIDocUploadStateByCustLedgEntry (CustLedgEntry@1100000 :

    /*
    procedure GetSIIDocUploadStateByCustLedgEntry (CustLedgEntry: Record 21)
        begin
          RESET;
          SETRANGE("Document Source","Document Source"::"Customer Ledger");
          CASE CustLedgEntry."Document Type" OF
            CustLedgEntry."Document Type"::Invoice:
              SETRANGE("Document Type","Document Type"::Invoice);
            CustLedgEntry."Document Type"::"Credit Memo":
              SETRANGE("Document Type","Document Type"::"Credit Memo");
            else
              exit;
          end;
          SETRANGE("Entry No",CustLedgEntry."Entry No.");
          FINDFIRST;
        end;
    */


    //     procedure GetSIIDocUploadStateByVendLedgEntry (VendorLedgerEntry@1100000 :

    /*
    procedure GetSIIDocUploadStateByVendLedgEntry (VendorLedgerEntry: Record 25)
        begin
          RESET;
          SETRANGE("Document Source","Document Source"::"Vendor Ledger");
          CASE VendorLedgerEntry."Document Type" OF
            VendorLedgerEntry."Document Type"::Invoice:
              SETRANGE("Document Type","Document Type"::Invoice);
            VendorLedgerEntry."Document Type"::"Credit Memo":
              SETRANGE("Document Type","Document Type"::"Credit Memo");
            else
              exit;
          end;
          SETRANGE("Entry No",VendorLedgerEntry."Entry No.");
          FINDFIRST;
        end;
    */


    //     procedure GetSIIDocUploadStateByDocument (DocSource@1100000 : Option;DocType@1100001 : Option;PostingDate@1100003 : Date;DocNo@1100002 :
    procedure GetSIIDocUploadStateByDocument(DocSource: Option; DocType: Option; PostingDate: Date; DocNo: Code[20]): Boolean;
    begin
        SETRANGE("Document Source", DocSource);
        SETRANGE("Document Type", DocType);
        SETRANGE("Posting Date", PostingDate);
        SETRANGE("Document No.", DocNo);
        exit(FINDLAST);
    end;

    LOCAL procedure GetSIIVersionNo(): Integer;
    begin
        if DATE2DMY(WORKDATE, 3) >= 2021 then
            exit("Version No."::"2.1");
        exit("Version No."::"1.1");
    end;

    //     procedure ValidateDocInfo (var TempSIIDocUploadState@1100005 : TEMPORARY Record 10752;EntryNo@1100010 : Integer;DocumentSource@1100008 : 'Customer Ledger,Vendor Ledger,Detailed Customer Ledger,Detailed Vendor Ledger';DocumentType@1100007 : ',Payment,Invoice,Credit Memo';DocumentNo@1100006 :

    /*
    procedure ValidateDocInfo (var TempSIIDocUploadState: Record 10752 TEMPORARY;EntryNo: Integer;DocumentSource: Option "Customer Ledger","Vendor Ledger","Detailed Customer Ledger","Detailed Vendor Ledger";DocumentType: ',Payment,Invoice,Credit Memo';DocumentNo: Code[35])
        var
    //       CustLedgerEntry@1100011 :
          CustLedgerEntry: Record 21;
    //       VendLedgEntry@1100012 :
          VendLedgEntry: Record 25;
    //       SalesInvoiceHeader@1100004 :
          SalesInvoiceHeader: Record 112;
    //       ServiceHeader@1100003 :
          ServiceHeader: Record 5900;
    //       SalesCrMemoHeader@1100002 :
          SalesCrMemoHeader: Record 114;
    //       PurchInvHeader@1100001 :
          PurchInvHeader: Record 122;
    //       PurchCrMemoHdr@1100000 :
          PurchCrMemoHdr: Record 124;
    //       SIIManagement@1100009 :
          SIIManagement: Codeunit 10756;
        begin
          TempSIIDocUploadState.VALIDATE("Entry No",EntryNo);
          TempSIIDocUploadState.VALIDATE("Document Source",DocumentSource);
          TempSIIDocUploadState.VALIDATE("Document Type",DocumentType);
          TempSIIDocUploadState.VALIDATE("Is Credit Memo Removal",TempSIIDocUploadState.IsCreditMemoRemoval);
          CASE DocumentSource OF
            "Document Source"::"Customer Ledger":
              CASE DocumentType OF
                "Document Type"::Invoice:
                  begin
                    if SalesInvoiceHeader.GET(DocumentNo) then
                      if not SIIManagement.IsAllowedSalesInvType(SalesInvoiceHeader."Invoice Type") then
                        SalesInvoiceHeader.FIELDERROR("Invoice Type");
                    if SalesInvoiceHeader."No." = '' then begin
                      // Get Service Header instead of Service Invoice Header because it's not inserted yet
                      ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Invoice);
                      ServiceHeader.SETRANGE("Posting No.",DocumentNo);
                      if ServiceHeader.FINDFIRST then begin
                        if not SIIManagement.IsAllowedServInvType(ServiceHeader."Invoice Type") then
                          ServiceHeader.FIELDERROR("Invoice Type");
                        // Increase Invoice Type and Special Scheme Code because in SII Doc. Upload state there is blank option in the beginning
                        TempSIIDocUploadState.UpdateSalesSIIDocUploadStateInfo(
                          ServiceHeader."Bill-to Customer No.",ServiceHeader."Invoice Type" + 1,0,ServiceHeader."Special Scheme Code" + 1,
                          ServiceHeader."Succeeded Company Name",ServiceHeader."Succeeded VAT Registration No.",ServiceHeader."ID Type");
                      end else begin
                        CustLedgerEntry.GET(EntryNo);
                        TempSIIDocUploadState.UpdateSalesSIIDocUploadStateInfo(
                          CustLedgerEntry."Customer No.",CustLedgerEntry."Invoice Type" + 1,0,CustLedgerEntry."Special Scheme Code" + 1,
                          CustLedgerEntry."Succeeded Company Name",CustLedgerEntry."Succeeded VAT Registration No.",
                          CustLedgerEntry."ID Type");
                      end;
                    end else
                      TempSIIDocUploadState.UpdateSalesSIIDocUploadStateInfo(
                        SalesInvoiceHeader."Bill-to Customer No.",SalesInvoiceHeader."Invoice Type" + 1,0,
                        SalesInvoiceHeader."Special Scheme Code" + 1,SalesInvoiceHeader."Succeeded Company Name",
                        SalesInvoiceHeader."Succeeded VAT Registration No.",SalesInvoiceHeader."ID Type");
                  end;
                "Document Type"::"Credit Memo":
                  if SalesCrMemoHeader.GET(DocumentNo) then
                    TempSIIDocUploadState.UpdateSalesSIIDocUploadStateInfo(
                      SalesCrMemoHeader."Bill-to Customer No.",0,SalesCrMemoHeader."Cr. Memo Type" + 1,
                      SalesCrMemoHeader."Special Scheme Code" + 1,SalesCrMemoHeader."Succeeded Company Name",
                      SalesCrMemoHeader."Succeeded VAT Registration No.",SalesCrMemoHeader."ID Type")
                  else begin
                    ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::"Credit Memo");
                    ServiceHeader.SETRANGE("Posting No.",DocumentNo);
                    if ServiceHeader.FINDFIRST then
                      TempSIIDocUploadState.UpdateSalesSIIDocUploadStateInfo(
                        ServiceHeader."Bill-to Customer No.",0,ServiceHeader."Cr. Memo Type" + 1,ServiceHeader."Special Scheme Code" + 1,
                        ServiceHeader."Succeeded Company Name",ServiceHeader."Succeeded VAT Registration No.",ServiceHeader."ID Type")
                    else begin
                      CustLedgerEntry.GET(EntryNo);
                      TempSIIDocUploadState.UpdateSalesSIIDocUploadStateInfo(
                        CustLedgerEntry."Customer No.",0,CustLedgerEntry."Cr. Memo Type" + 1,CustLedgerEntry."Special Scheme Code" + 1,
                        CustLedgerEntry."Succeeded Company Name",CustLedgerEntry."Succeeded VAT Registration No.",
                        CustLedgerEntry."ID Type");
                    end;
                  end;
              end;
            "Document Source"::"Vendor Ledger":
              CASE DocumentType OF
                "Document Type"::Invoice:
                  if PurchInvHeader.GET(DocumentNo) then
                    TempSIIDocUploadState.UpdatePurchSIIDocUploadState(
                      PurchInvHeader."Pay-to Vendor No.",PurchInvHeader."Invoice Type" + 1,0,PurchInvHeader."Special Scheme Code" + 1,
                      PurchInvHeader."Succeeded Company Name",PurchInvHeader."Succeeded VAT Registration No.",PurchInvHeader."ID Type")
                  else begin
                    VendLedgEntry.GET(EntryNo);
                    TempSIIDocUploadState.UpdatePurchSIIDocUploadState(
                      VendLedgEntry."Vendor No.",VendLedgEntry."Invoice Type" + 1,0,VendLedgEntry."Special Scheme Code" + 1,
                      VendLedgEntry."Succeeded Company Name",VendLedgEntry."Succeeded VAT Registration No.",VendLedgEntry."ID Type");
                  end;
                "Document Type"::"Credit Memo":
                  if PurchCrMemoHdr.GET(DocumentNo) then
                    TempSIIDocUploadState.UpdatePurchSIIDocUploadState(
                      PurchCrMemoHdr."Pay-to Vendor No.",0,PurchCrMemoHdr."Cr. Memo Type" + 1,PurchCrMemoHdr."Special Scheme Code" + 1,
                      PurchCrMemoHdr."Succeeded Company Name",PurchCrMemoHdr."Succeeded VAT Registration No.",PurchCrMemoHdr."ID Type")
                  else begin
                    VendLedgEntry.GET(EntryNo);
                    TempSIIDocUploadState.UpdatePurchSIIDocUploadState(
                      VendLedgEntry."Vendor No.",0,VendLedgEntry."Cr. Memo Type" + 1,VendLedgEntry."Special Scheme Code" + 1,
                      VendLedgEntry."Succeeded Company Name",VendLedgEntry."Succeeded VAT Registration No.",VendLedgEntry."ID Type");
                  end;
              end;
          end;
        end;
    */



    /*
    procedure IsCreditMemoRemoval () : Boolean;
        var
    //       CustLedgerEntry@1100004 :
          CustLedgerEntry: Record 21;
    //       VendorLedgerEntry@1100007 :
          VendorLedgerEntry: Record 25;
    //       SalesCrMemoHeader@1100005 :
          SalesCrMemoHeader: Record 114;
    //       ServiceCrMemoHeader@1100006 :
          ServiceCrMemoHeader: Record 5994;
    //       PurchCrMemoHdr@1100002 :
          PurchCrMemoHdr: Record 124;
        begin
          if ("Document Source" = "Document Source"::"Customer Ledger") and ("Document Type" = "Document Type"::"Credit Memo") then
            if CustLedgerEntry.GET("Entry No") then begin
              if SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") then
                exit(SalesCrMemoHeader."Correction Type" = SalesCrMemoHeader."Correction Type"::Removal);
              if ServiceCrMemoHeader.GET(CustLedgerEntry."Document No.") then
                exit(ServiceCrMemoHeader."Correction Type" = ServiceCrMemoHeader."Correction Type"::Removal);
            end;

          if ("Document Source" = "Document Source"::"Vendor Ledger") and ("Document Type" = "Document Type"::"Credit Memo") then
            if VendorLedgerEntry.GET("Entry No") then
              if PurchCrMemoHdr.GET(VendorLedgerEntry."Document No.") then
                exit(PurchCrMemoHdr."Correction Type" = PurchCrMemoHdr."Correction Type"::Removal);

          exit(FALSE);
        end;
    */


    //     procedure GetCorrectionInfo (var CorrectedDocNo@1100005 : Code[35];var CorrectionDate@1100006 : Date;PostingDate@1100000 :

    /*
    procedure GetCorrectionInfo (var CorrectedDocNo: Code[35];var CorrectionDate: Date;PostingDate: Date)
        var
    //       CustLedgerEntry@1100004 :
          CustLedgerEntry: Record 21;
    //       VendorLedgerEntry@1100003 :
          VendorLedgerEntry: Record 25;
    //       SalesCrMemoHeader@1100002 :
          SalesCrMemoHeader: Record 114;
    //       PurchCrMemoHdr@1100001 :
          PurchCrMemoHdr: Record 124;
        begin
          CorrectedDocNo := '';
          CorrectionDate := 0D;
          if (not ("Document Source" IN ["Document Source"::"Customer Ledger","Document Source"::"Vendor Ledger"])) or
             ("Document Type" <> "Document Type"::"Credit Memo")
          then
            exit;

          if "Document Source" = "Document Source"::"Customer Ledger" then begin
            if SalesCrMemoHeader.GET("Document No.") then
              GetCorrInfoFromCustLedgEntry(CorrectedDocNo,CorrectionDate,SalesCrMemoHeader."Corrected Invoice No.")
            else begin
              CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::"Credit Memo");
              CustLedgerEntry.SETRANGE("Document No.","Document No.");
              CustLedgerEntry.SETRANGE("Posting Date",PostingDate);
              if CustLedgerEntry.FINDFIRST then
                GetCorrInfoFromCustLedgEntry(CorrectedDocNo,CorrectionDate,CustLedgerEntry."Corrected Invoice No.");
            end;
            exit;
          end;

          if PurchCrMemoHdr.GET("Document No.") then
            GetCorrInfoFromVendLedgEntry(CorrectedDocNo,CorrectionDate,PurchCrMemoHdr."Corrected Invoice No.")
          else begin
            VendorLedgerEntry.SETRANGE("Document Type",VendorLedgerEntry."Document Type"::"Credit Memo");
            VendorLedgerEntry.SETRANGE("Document No.","Document No.");
            VendorLedgerEntry.SETRANGE("Posting Date",PostingDate);
            if VendorLedgerEntry.FINDFIRST then
              GetCorrInfoFromVendLedgEntry(CorrectedDocNo,CorrectionDate,VendorLedgerEntry."Corrected Invoice No.");
          end;
        end;
    */


    //     LOCAL procedure GetCorrInfoFromCustLedgEntry (var CorrectedDocNo@1100002 : Code[35];var CorrectionDate@1100001 : Date;DocNo@1100000 :

    /*
    LOCAL procedure GetCorrInfoFromCustLedgEntry (var CorrectedDocNo: Code[35];var CorrectionDate: Date;DocNo: Code[20])
        var
    //       CustLedgerEntry@1100003 :
          CustLedgerEntry: Record 21;
        begin
          if DocNo = '' then
            exit;

          CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
          CustLedgerEntry.SETRANGE("Document No.",DocNo);
          if CustLedgerEntry.FINDFIRST then begin
            CorrectedDocNo := CustLedgerEntry."Document No.";
            CorrectionDate := CustLedgerEntry."Posting Date";
          end;
        end;
    */


    //     LOCAL procedure GetCorrInfoFromVendLedgEntry (var CorrectedDocNo@1100003 : Code[35];var CorrectionDate@1100002 : Date;DocNo@1100001 :

    /*
    LOCAL procedure GetCorrInfoFromVendLedgEntry (var CorrectedDocNo: Code[35];var CorrectionDate: Date;DocNo: Code[20])
        var
    //       VendorLedgerEntry@1100000 :
          VendorLedgerEntry: Record 25;
        begin
          if DocNo = '' then
            exit;

          VendorLedgerEntry.SETRANGE("Document Type",VendorLedgerEntry."Document Type"::Invoice);
          VendorLedgerEntry.SETRANGE("Document No.",DocNo);
          if VendorLedgerEntry.FINDFIRST then begin
            if VendorLedgerEntry."External Document No." = '' then
              CorrectedDocNo := VendorLedgerEntry."Document No."
            else
              CorrectedDocNo := VendorLedgerEntry."External Document No.";
            CorrectionDate := VendorLedgerEntry."Document Date";
          end;
        end;
    */


    //     procedure UpdateSalesSIIDocUploadStateInfo (CustNo@1100001 : Code[20];InvType@1100002 : Option;CrMemoType@1100000 : Option;SpecialSchemeCode@1100003 : Option;SucceededCompanyName@1100004 : Text[250];SucceededVATRegNo@1100005 : Text[20];NewIDType@1100008 :

    /*
    procedure UpdateSalesSIIDocUploadStateInfo (CustNo: Code[20];InvType: Option;CrMemoType: Option;SpecialSchemeCode: Option;SucceededCompanyName: Text[250];SucceededVATRegNo: Text[20];NewIDType: Option)
        begin
          VALIDATE("CV No.",CustNo);
          if InvType = 0 then
            VALIDATE("Sales Cr. Memo Type",CrMemoType)
          else
            VALIDATE("Sales Invoice Type",InvType);
          VALIDATE("Sales Special Scheme Code",SpecialSchemeCode);
          VALIDATE("Succeeded Company Name",SucceededCompanyName);
          VALIDATE("Succeeded VAT Registration No.",SucceededVATRegNo);
          VALIDATE(IDType,NewIDType);
        end;
    */


    //     procedure UpdatePurchSIIDocUploadState (VendNo@1100001 : Code[20];InvType@1100002 : Option;CrMemoType@1100000 : Option;SpecialSchemeCode@1100003 : Option;SucceededCompanyName@1100004 : Text[250];SucceededVATRegNo@1100005 : Text[20];NewIDType@1100008 :

    /*
    procedure UpdatePurchSIIDocUploadState (VendNo: Code[20];InvType: Option;CrMemoType: Option;SpecialSchemeCode: Option;SucceededCompanyName: Text[250];SucceededVATRegNo: Text[20];NewIDType: Option)
        begin
          VALIDATE("CV No.",VendNo);
          if InvType = 0 then
            VALIDATE("Purch. Cr. Memo Type",CrMemoType)
          else
            VALIDATE("Purch. Invoice Type",InvType);
          VALIDATE("Purch. Special Scheme Code",SpecialSchemeCode);
          VALIDATE("Succeeded Company Name",SucceededCompanyName);
          VALIDATE("Succeeded VAT Registration No.",SucceededVATRegNo);
          VALIDATE(IDType,NewIDType);
        end;

        /*begin
        //{
    //      JAV 19/05/21: - QB 1.08.43 Se actualiza al objeto de la versi�n BC14 CU23 (NAVES14.23 del 26/02/21)
    //    }
        end.
      */
}






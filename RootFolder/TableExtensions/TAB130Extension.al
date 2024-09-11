tableextension 50142 "MyExtension50142" extends "Incoming Document"
{
  
  DataCaptionFields="Vendor Name","Vendor Invoice No.","Description";
    CaptionML=ENU='Incoming Document',ESP='Documento entrante';
    LookupPageID="Incoming Documents";
    DrillDownPageID="Incoming Documents";
  
  fields
{
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Status")
  //  {
       /* ;
 */
   // }
   // key(key3;"Document No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key4;"OCR Status")
  //  {
       /* ;
 */
   // }
   // key(key5;"Vendor No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"Created Date-Time","Description","Amount Incl. VAT","Status","Currency Code")
   // {
       // 
   // }
}
  
    var
//       IncomingDocumentsSetup@1001 :
      IncomingDocumentsSetup: Record 131;
//       UrlTooLongErr@1003 :
      UrlTooLongErr: TextConst ENU='Only URLs with a maximum 1000 characters are allowed.',ESP='S¢lo se permiten URL con un m ximo de 1000 caracteres.';
//       TempErrorMessage@1011 :
      TempErrorMessage: Record 700 TEMPORARY;
//       DocumentType@1005 :
      DocumentType: Option "Invoice","Credit Memo";
//       NoDocumentMsg@1008 :
      NoDocumentMsg: TextConst ENU='There is no incoming document for this combination of posting date and document number.',ESP='No existe ning£n documento entrante con esta combinaci¢n de fecha de registro y n£mero de documento.';
//       AlreadyUsedInJnlErr@1004 :
      AlreadyUsedInJnlErr: 
// "%1 = journal batch name, %2=line number."
TextConst ENU='The incoming document has already been assigned to journal batch %1, line number. %2.',ESP='El documento entrante ya se ha asignado a la secci¢n de diario %1, n£mero de l¡nea. %2.';
//       AlreadyUsedInDocHdrErr@1006 :
      AlreadyUsedInDocHdrErr: 
// "%1=document type, %2=document number, %3=table name, e.g. Sales Header."
TextConst ENU='The incoming document has already been assigned to %1 %2 (%3).',ESP='El documento entrante ya se ha asignado a %1 %2 (%3).';
//       DocPostedErr@1009 :
      DocPostedErr: TextConst ENU='The document related to this incoming document has been posted.',ESP='El documento relacionado con este documento entrante se ha registrado.';
//       DocApprovedErr@1010 :
      DocApprovedErr: TextConst ENU='This incoming document requires releasing.',ESP='Este documento entrante requiere liberaci¢n.';
//       DetachQst@1012 :
      DetachQst: TextConst ENU='Do you want to remove the reference from this incoming document to posted document %1, posting date %2?',ESP='¨Desea quitar la referencia de este documento entrante al documento registrado %1, con fecha de registro %2?';
//       NotSupportedPurchErr@1013 :
      NotSupportedPurchErr: 
// %1 will be Sales/Purchase Header. %2 will be invoice, Credit Memo.
TextConst ENU='Purchase documents of type %1 are not supported.',ESP='Los documentos de compra del tipo %1 no son compatibles.';
//       NotSupportedSalesErr@1016 :
      NotSupportedSalesErr: 
// %1 will be Sales/Purchase Header. %2 will be invoice, Credit Memo.
TextConst ENU='Sales documents of type %1 are not supported.',ESP='Los documentos de venta del tipo %1 no son compatibles.';
//       EntityNotFoundErr@1014 :
      EntityNotFoundErr: TextConst ENU='Cannot create the document. Make sure the data exchange definition is correct.',ESP='No se puede crear el documento. Aseg£rese de que la definici¢n de intercambio de datos es correcta.';
//       DocAlreadyCreatedErr@1015 :
      DocAlreadyCreatedErr: TextConst ENU='The document has already been created.',ESP='El documento ya se ha creado.';
//       DocNotCreatedMsg@1017 :
      DocNotCreatedMsg: TextConst ENU='The document was not created due to errors in the conversion process.',ESP='El documento no se cre¢ debido a errores en el proceso de conversi¢n.';
//       DocCreatedMsg@1018 :
      DocCreatedMsg: 
// %1 can be Purchase Invoice, %2 is an ID (e.g. 1001)
TextConst ENU='%1 %2 has been created.',ESP='Se ha creado %1 %2.';
//       DocCreatedWarningsMsg@1019 :
      DocCreatedWarningsMsg: 
// %1 can be Purchase Invoice, %2 is an ID (e.g. 1001)
TextConst ENU='%1 %2 has been created with warnings.',ESP='%1 %2 se ha creado con advertencias.';
//       RemovePostedRecordManuallyMsg@1024 :
      RemovePostedRecordManuallyMsg: TextConst ENU='The reference to the posted record has been removed.\\Remember to correct the posted record if needed.',ESP='Se ha quitado la referencia del registro registrado.\\Recuerde corregir dicho registro si fuera necesario.';
//       DeleteRecordQst@1025 :
      DeleteRecordQst: TextConst ENU='The reference to the record has been removed.\\Do you want to delete the record?',ESP='Se ha quitado la referencia del registro.\\¨Desea eliminar el registro?';
//       DocWhenApprovalIsCompleteErr@1026 :
      DocWhenApprovalIsCompleteErr: TextConst ENU='The document can only be created when the approval process is complete.',ESP='El documento solo se puede crear una vez completado el proceso de aprobaci¢n.';
//       InvalidCurrencyCodeErr@1000 :
      InvalidCurrencyCodeErr: TextConst ENU='You must enter a valid currency code.',ESP='Debe introducir un c¢digo de divisa v lido.';
//       ReplaceMainAttachmentQst@1002 :
      ReplaceMainAttachmentQst: TextConst ENU='Are you sure you want to replace the attached file?',ESP='¨Est  seguro de que desea sustituir el archivo adjunto?';
//       PurchaseTxt@1031 :
      PurchaseTxt: TextConst ENU='Purchase',ESP='Compras';
//       SalesTxt@1030 :
      SalesTxt: TextConst ENU='Sales',ESP='Ventas';
//       PurchaseInvoiceTxt@2002 :
      PurchaseInvoiceTxt: TextConst ENU='Purchase Invoice',ESP='Factura compra';
//       PurchaseCreditMemoTxt@1007 :
      PurchaseCreditMemoTxt: TextConst ENU='Purchase Credit Memo',ESP='Abono compra';
//       SalesInvoiceTxt@1020 :
      SalesInvoiceTxt: TextConst ENU='Sales Invoice',ESP='Factura venta';
//       SalesCreditMemoTxt@1021 :
      SalesCreditMemoTxt: TextConst ENU='Sales Credit Memo',ESP='Abono venta';
//       JournalTxt@1022 :
      JournalTxt: TextConst ENU='Journal',ESP='Diario';
//       DoYouWantToRemoveReferenceQst@1023 :
      DoYouWantToRemoveReferenceQst: TextConst ENU='Do you want to remove the reference?',ESP='¨Confirma que quiere eliminar la referencia?';
//       DataExchangeTypeEmptyErr@1027 :
      DataExchangeTypeEmptyErr: TextConst ENU='You must select a value in the Data Exchange Type field on the incoming document.',ESP='Debe seleccionar un valor en el campo Tipo de intercambio de datos en el documento entrante.';
//       NoDocAttachErr@1028 :
      NoDocAttachErr: TextConst ENU='No document is attached.\\Attach a document, and then try again.',ESP='No hay ning£n documento adjunto.\\Adjunte uno y vuelva a intentarlo.';
//       GeneralLedgerEntriesTxt@1029 :
      GeneralLedgerEntriesTxt: TextConst ENU='General Ledger Entries',ESP='Movs. contabilidad';
//       CannotReplaceMainAttachmentErr@1032 :
      CannotReplaceMainAttachmentErr: TextConst ENU='Cannot replace the main attachment because the document has already been sent to OCR.',ESP='No se puede reemplazar el archivo adjunto principal porque el documento ya se ha enviado a OCR.';

    
    


/*
trigger OnInsert();    var
//                OCRServiceSetup@1001 :
               OCRServiceSetup: Record 1270;
             begin
               if OCRServiceSetup.GET then;
               "Created Date-Time" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Created By User ID" := USERSECURITYID;
               if "OCR Service Doc. Template Code" = '' then
                 "OCR Service Doc. Template Code" := OCRServiceSetup."Default OCR Doc. Template";
             end;


*/

/*
trigger OnModify();    begin
               "Last Date-Time Modified" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Last Modified By User ID" := USERSECURITYID;
             end;


*/

/*
trigger OnDelete();    var
//                IncomingDocumentAttachment@1000 :
               IncomingDocumentAttachment: Record 133;
//                ActivityLog@1001 :
               ActivityLog: Record 710;
//                ApprovalsMgmt@1002 :
               ApprovalsMgmt: Codeunit 1535;
             begin
               TESTFIELD(Posted,FALSE);

               ApprovalsMgmt.DeleteApprovalEntries(RECORDID);
               ClearRelatedRecords;

               IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
               if not IncomingDocumentAttachment.ISEMPTY then
                 IncomingDocumentAttachment.DELETEALL;

               ActivityLog.SETRANGE("Record ID",RECORDID);
               if not ActivityLog.ISEMPTY then
                 ActivityLog.DELETEALL;

               ClearErrorMessages;
             end;

*/




/*
procedure GetURL () : Text;
    begin
      exit(URL1 + URL2 + URL3 + URL4);
    end;
*/


    
//     procedure SetURL (URL@1000 :
    
/*
procedure SetURL (URL: Text)
    begin
      TESTFIELD(Status,Status::New);

      TESTFIELD(Posted,FALSE);
      if STRLEN(URL) > 1000 then
        ERROR(UrlTooLongErr);
      URL2 := '';
      URL3 := '';
      URL4 := '';
      URL1 := COPYSTR(URL,1,250);
      if STRLEN(URL) > 250 then
        URL2 := COPYSTR(URL,251,250);
      if STRLEN(URL) > 500 then
        URL3 := COPYSTR(URL,501,250);
      if STRLEN(URL) > 750 then
        URL4 := COPYSTR(URL,751,250);
    end;
*/


    
    
/*
procedure Release ()
    var
//       ReleaseIncomingDocument@1000 :
      ReleaseIncomingDocument: Codeunit 132;
    begin
      ReleaseIncomingDocument.PerformManualRelease(Rec);
    end;
*/


    
    
/*
procedure Reject ()
    var
//       ReleaseIncomingDocument@1000 :
      ReleaseIncomingDocument: Codeunit 132;
    begin
      ReleaseIncomingDocument.PerformManualReject(Rec);
    end;
*/


    
    
/*
procedure CheckNotCreated ()
    begin
      if Status = Status::Created then
        ERROR(DocAlreadyCreatedErr);
    end;
*/


    
    
/*
procedure CreateDocumentWithDataExchange ()
    var
//       RelatedRecord@1000 :
      RelatedRecord: Variant;
    begin
      if GetRecord(RelatedRecord) then
        ERROR(DocAlreadyCreatedErr);

      CreateWithDataExchange("Document Type"::" ")
    end;
*/


    
    
/*
procedure TryCreateDocumentWithDataExchange ()
    begin
      CreateDocumentWithDataExchange
    end;
*/


    
    
/*
procedure CreateReleasedDocumentWithDataExchange ()
    var
//       PurchaseHeader@1002 :
      PurchaseHeader: Record 38;
//       ReleasePurchaseDocument@1003 :
      ReleasePurchaseDocument: Codeunit 415;
//       Variant@1001 :
      Variant: Variant;
//       RecordRef@1000 :
      RecordRef: RecordRef;
    begin
      CreateWithDataExchange("Document Type"::" ");
      GetRecord(Variant);
      RecordRef.GETTABLE(Variant);
      if RecordRef.NUMBER <> DATABASE::"Purchase Header" then
        exit;
      RecordRef.SETTABLE(PurchaseHeader);
      ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);
    end;
*/


//     LOCAL procedure CreateWithDataExchange (DocumentType@1001 :
    
/*
LOCAL procedure CreateWithDataExchange (DocumentType: Option)
    var
//       ErrorMessage@1000 :
      ErrorMessage: Record 700;
//       ApprovalsMgmt@1002 :
      ApprovalsMgmt: Codeunit 1535;
//       ReleaseIncomingDocument@1003 :
      ReleaseIncomingDocument: Codeunit 132;
//       OldStatus@1004 :
      OldStatus: Option;
    begin
      FIND;

      if ApprovalsMgmt.IsIncomingDocApprovalsWorkflowEnabled(Rec) and (Status = Status::New) then
        ERROR(DocWhenApprovalIsCompleteErr);

      OnCheckIncomingDocCreateDocRestrictions;

      if "Data Exchange Type" = '' then
        ERROR(DataExchangeTypeEmptyErr);

      "Document Type" := DocumentType;
      MODIFY;

      ClearErrorMessages;
      TestReadyForProcessing;

      CheckNotCreated;

      if Status IN [Status::New,Status::Failed] then begin
        OldStatus := Status;
        CODEUNIT.RUN(CODEUNIT::"Release Incoming Document",Rec);
        TESTFIELD(Status,Status::Released);
        Status := OldStatus;
        MODIFY;
      end;

      COMMIT;
      if not CODEUNIT.RUN(CODEUNIT::"Incoming Doc. with Data. Exch.",Rec) then begin
        ErrorMessage.CopyFromTemp(TempErrorMessage);
        SetProcessFailed('');
        exit;
      end;

      ErrorMessage.SetContext(RECORDID);
      if ErrorMessage.HasErrors(FALSE) then begin
        SetProcessFailed('');
        exit;
      end;

      // identify the created doc
      if not UpdateDocumentFields then begin
        SetProcessFailed('');
        exit;
      end;

      ReleaseIncomingDocument.Create(Rec);

      if ErrorMessage.ErrorMessageCount(ErrorMessage."Message Type"::Warning) > 0 then
        MESSAGE(DocCreatedWarningsMsg,FORMAT("Document Type"),"Document No.")
      else
        MESSAGE(DocCreatedMsg,FORMAT("Document Type"),"Document No.");
    end;
*/


    
    
/*
procedure CreateManually ()
    var
//       RelatedRecord@1002 :
      RelatedRecord: Variant;
//       DocumentTypeOption@1000 :
      DocumentTypeOption: Integer;
    begin
      if GetRecord(RelatedRecord) then
        ERROR(DocAlreadyCreatedErr);

      DocumentTypeOption :=
        STRMENU(
          STRSUBSTNO('%1,%2,%3,%4,%5',JournalTxt,SalesInvoiceTxt,SalesCreditMemoTxt,PurchaseInvoiceTxt,PurchaseCreditMemoTxt),1);

      if DocumentTypeOption < 1 then
        exit;

      DocumentTypeOption -= 1;

      CASE DocumentTypeOption OF
        "Document Type"::"Purchase Invoice":
          CreatePurchInvoice;
        "Document Type"::"Purchase Credit Memo":
          CreatePurchCreditMemo;
        "Document Type"::"Sales Invoice":
          CreateSalesInvoice;
        "Document Type"::"Sales Credit Memo":
          CreateSalesCreditMemo;
        "Document Type"::Journal:
          CreateGenJnlLine;
      end;
    end;
*/


    
    
/*
procedure CreateGenJnlLine ()
    var
//       GenJnlLine@1000 :
      GenJnlLine: Record 81;
//       LastGenJnlLine@1002 :
      LastGenJnlLine: Record 81;
//       LineNo@1001 :
      LineNo: Integer;
    begin
      if "Document Type" <> "Document Type"::Journal then
        TestIfAlreadyExists;
      TestReadyForProcessing;
      IncomingDocumentsSetup.TESTFIELD("General Journal Template Name");
      IncomingDocumentsSetup.TESTFIELD("General Journal Batch Name");
      GenJnlLine.SETRANGE("Journal Template Name",IncomingDocumentsSetup."General Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name",IncomingDocumentsSetup."General Journal Batch Name");
      GenJnlLine.SETRANGE("Incoming Document Entry No.","Entry No.");
      if not GenJnlLine.ISEMPTY then
        exit; // instead; go to the document

      GenJnlLine.SETRANGE("Incoming Document Entry No.");

      "Document Type" := "Document Type"::Journal;

      if GenJnlLine.FINDLAST then;
      LastGenJnlLine := GenJnlLine;
      LineNo := GenJnlLine."Line No." + 10000;
      GenJnlLine.INIT;
      GenJnlLine."Journal Template Name" := IncomingDocumentsSetup."General Journal Template Name";
      GenJnlLine."Journal Batch Name" := IncomingDocumentsSetup."General Journal Batch Name";
      GenJnlLine."Line No." := LineNo;
      GenJnlLine.SetUpNewLine(LastGenJnlLine,0,TRUE);
      GenJnlLine."Incoming Document Entry No." := "Entry No.";
      GenJnlLine.Description := COPYSTR(Description,1,MAXSTRLEN(GenJnlLine.Description));

      if GenJnlLine.INSERT(TRUE) then
        OnAfterCreateGenJnlLineFromIncomingDocSuccess(Rec)
      else
        OnAfterCreateGenJnlLineFromIncomingDocFail(Rec);

      if GenJnlLine.HASLINKS then
        GenJnlLine.DELETELINKS;
      if GetURL <> '' then
        GenJnlLine.ADDLINK(GetURL,Description);

      ShowRecord;
    end;
*/


    
    
/*
procedure CreatePurchInvoice ()
    begin
      if "Document Type" <> "Document Type"::"Purchase Invoice" then
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Purchase Invoice";
      CreatePurchDoc(DocumentType::Invoice);
    end;
*/


    
    
/*
procedure CreatePurchCreditMemo ()
    begin
      if "Document Type" <> "Document Type"::"Purchase Credit Memo" then
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Purchase Credit Memo";
      CreatePurchDoc(DocumentType::"Credit Memo");
    end;
*/


    
    
/*
procedure CreateSalesInvoice ()
    begin
      if "Document Type" <> "Document Type"::"Sales Invoice" then
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Sales Invoice";
      CreateSalesDoc(DocumentType::Invoice);
    end;
*/


    
    
/*
procedure CreateSalesCreditMemo ()
    begin
      if "Document Type" <> "Document Type"::"Sales Credit Memo" then
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Sales Credit Memo";
      CreateSalesDoc(DocumentType::"Credit Memo");
    end;
*/


    
    
/*
procedure CreateGeneralJournalLineWithDataExchange ()
    var
//       ErrorMessage@1002 :
      ErrorMessage: Record 700;
//       RelatedRecord@1000 :
      RelatedRecord: Variant;
    begin
      if GetRecord(RelatedRecord) then
        ERROR(DocAlreadyCreatedErr);

      CreateWithDataExchange("Document Type"::Journal);

      ErrorMessage.SetContext(RECORDID);
      if not ErrorMessage.HasErrors(FALSE) then
        OnAfterCreateGenJnlLineFromIncomingDocSuccess(Rec)
      else
        OnAfterCreateGenJnlLineFromIncomingDocFail(Rec);
    end;
*/


    
    
/*
procedure TryCreateGeneralJournalLineWithDataExchange ()
    begin
      CreateGeneralJournalLineWithDataExchange
    end;
*/


    
//     procedure RemoveReferenceToWorkingDocument (EntryNo@1000 :
    
/*
procedure RemoveReferenceToWorkingDocument (EntryNo: Integer)
    begin
      if EntryNo = 0 then
        exit;
      if not GET(EntryNo) then
        exit;

      TESTFIELD(Posted,FALSE);

      "Document Type" := "Document Type"::" ";
      "Document No." := '';
      // To clear the filters and prevent the page from putting values back
      SETRANGE("Document Type");
      SETRANGE("Document No.");

      if Released then
        Status := Status::Released
      else
        Status := Status::New;

      ClearErrorMessages;
      "Created Doc. Error Msg. Type" := "Created Doc. Error Msg. Type"::Error;

      MODIFY;
    end;
*/


    
/*
LOCAL procedure RemoveIncomingDocumentEntryNoFromUnpostedDocument ()
    var
//       SalesHeader@1004 :
      SalesHeader: Record 36;
//       DataTypeManagement@1003 :
      DataTypeManagement: Codeunit 701;
//       RelatedRecordRecordRef@1002 :
      RelatedRecordRecordRef: RecordRef;
//       RelatedRecordFieldRef@1001 :
      RelatedRecordFieldRef: FieldRef;
//       RelatedRecord@1000 :
      RelatedRecord: Variant;
    begin
      if not GetUnpostedRecord(RelatedRecord) then
        exit;
      RelatedRecordRecordRef.GETTABLE(RelatedRecord);
      DataTypeManagement.FindFieldByName(
        RelatedRecordRecordRef,RelatedRecordFieldRef,SalesHeader.FIELDNAME("Incoming Document Entry No."));
      RelatedRecordFieldRef.VALUE := 0;
      RelatedRecordRecordRef.MODIFY(TRUE);
    end;
*/


    
//     procedure CreateIncomingDocument (NewDescription@1003 : Text;NewURL@1002 :
    
/*
procedure CreateIncomingDocument (NewDescription: Text;NewURL: Text) : Integer;
    begin
      RESET;
      CLEAR(Rec);
      INIT;
      Description := COPYSTR(NewDescription,1,MAXSTRLEN(Description));
      SetURL(NewURL);
      INSERT(TRUE);
      exit("Entry No.");
    end;
*/


    
//     procedure CreateIncomingDocumentFromServerFile (FileName@1000 : Text;FilePath@1001 :
    
/*
procedure CreateIncomingDocumentFromServerFile (FileName: Text;FilePath: Text)
    var
//       IncomingDocument@1006 :
      IncomingDocument: Record 130;
    begin
      if (FileName = '') or (FilePath = '') then
        exit;
      IncomingDocument.COPYFILTERS(Rec);
      CreateIncomingDocument(FileName,'');
      AddAttachmentFromServerFile(FileName,FilePath);
      COPYFILTERS(IncomingDocument);
    end;
*/


    
/*
LOCAL procedure TestIfAlreadyExists ()
    var
//       GenJnlLine@1002 :
      GenJnlLine: Record 81;
//       SalesHeader@1001 :
      SalesHeader: Record 36;
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
    begin
      CASE "Document Type" OF
        "Document Type"::Journal:
          begin
            GenJnlLine.SETRANGE("Incoming Document Entry No.","Entry No.");
            if GenJnlLine.FINDFIRST then
              ERROR(AlreadyUsedInJnlErr,GenJnlLine."Journal Batch Name",GenJnlLine."Line No.");
          end;
        "Document Type"::"Sales Invoice","Document Type"::"Sales Credit Memo":
          begin
            SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            if SalesHeader.FINDFIRST then
              ERROR(AlreadyUsedInDocHdrErr,SalesHeader."Document Type",SalesHeader."No.",SalesHeader.TABLECAPTION);
          end;
        "Document Type"::"Purchase Invoice","Document Type"::"Purchase Credit Memo":
          begin
            PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            if PurchaseHeader.FINDFIRST then
              ERROR(AlreadyUsedInDocHdrErr,PurchaseHeader."Document Type",PurchaseHeader."No.",PurchaseHeader.TABLECAPTION);
          end;
      end;
    end;
*/


    
    
/*
procedure TestReadyForProcessing ()
    begin
      TestReadyForProcessingForcePosted(FALSE);
    end;
*/


//     LOCAL procedure TestReadyForProcessingForcePosted (ForcePosted@1000 :
    
/*
LOCAL procedure TestReadyForProcessingForcePosted (ForcePosted: Boolean)
    begin
      if not ForcePosted and Posted then
        ERROR(DocPostedErr);

      IncomingDocumentsSetup.Fetch;
      if IncomingDocumentsSetup."Require Approval To Create" and (not Released) then
        ERROR(DocApprovedErr);
    end;
*/


    
//     procedure PostedDocExists (DocumentNo@1000 : Code[20];PostingDate@1001 :
    
/*
procedure PostedDocExists (DocumentNo: Code[20];PostingDate: Date) : Boolean;
    begin
      SETRANGE(Posted,TRUE);
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      exit(not ISEMPTY);
    end;
*/


    
//     procedure GetPostedDocType (PostingDate@1000 : Date;DocNo@1001 : Code[20];var IsPosted@1003 :
    
/*
procedure GetPostedDocType (PostingDate: Date;DocNo: Code[20];var IsPosted: Boolean) : Integer;
    var
//       SalesInvoiceHeader@1008 :
      SalesInvoiceHeader: Record 112;
//       SalesCrMemoHeader@1007 :
      SalesCrMemoHeader: Record 114;
//       PurchInvHeader@1006 :
      PurchInvHeader: Record 122;
//       PurchCrMemoHdr@1005 :
      PurchCrMemoHdr: Record 124;
//       GLEntry@1002 :
      GLEntry: Record 17;
    begin
      IsPosted := TRUE;
      CASE TRUE OF
        ((PostingDate = 0D) or (DocNo = '')):
          exit("Document Type"::" ");
        PurchInvHeader.GET(DocNo):
          if PurchInvHeader."Posting Date" = PostingDate then
            exit("Document Type"::"Purchase Invoice");
        PurchCrMemoHdr.GET(DocNo):
          if PurchCrMemoHdr."Posting Date" = PostingDate then
            exit("Document Type"::"Purchase Credit Memo");
        SalesInvoiceHeader.GET(DocNo):
          if SalesInvoiceHeader."Posting Date" = PostingDate then
            exit("Document Type"::"Sales Invoice");
        SalesCrMemoHeader.GET(DocNo):
          if SalesCrMemoHeader."Posting Date" = PostingDate then
            exit("Document Type"::"Sales Credit Memo");
        else
          GLEntry.SETRANGE("Posting Date",PostingDate);
          GLEntry.SETRANGE("Document No.",DocNo);
          IsPosted := not GLEntry.ISEMPTY;
          exit("Document Type"::Journal);
      end;
      IsPosted := FALSE;
      exit("Document Type"::" ");
    end;
*/


    
//     procedure SetPostedDocFields (PostingDate@1000 : Date;DocNo@1001 :
    
/*
procedure SetPostedDocFields (PostingDate: Date;DocNo: Code[20])
    begin
      SetPostedDocFieldsForcePosted(PostingDate,DocNo,FALSE);
    end;
*/


    
//     procedure SetPostedDocFieldsForcePosted (PostingDate@1000 : Date;DocNo@1001 : Code[20];ForcePosted@1003 :
    
/*
procedure SetPostedDocFieldsForcePosted (PostingDate: Date;DocNo: Code[20];ForcePosted: Boolean)
    var
//       IncomingDocumentAttachment@1002 :
      IncomingDocumentAttachment: Record 133;
//       RelatedRecord@1006 :
      RelatedRecord: Variant;
//       RelatedRecordRef@1004 :
      RelatedRecordRef: RecordRef;
    begin
      TestReadyForProcessingForcePosted(ForcePosted);
      Posted := TRUE;
      Status := Status::Posted;
      Processed := TRUE;
      "Posted Date-Time" := CURRENTDATETIME;
      "Document No." := DocNo;
      "Posting Date" := PostingDate;
      if FindPostedRecord(RelatedRecord) then begin
        RelatedRecordRef.GETTABLE(RelatedRecord);
        "Related Record ID" := RelatedRecordRef.RECORDID;
      end;
      ClearErrorMessages;
      MODIFY(TRUE);
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.MODIFYALL("Document No.","Document No.");
      IncomingDocumentAttachment.MODIFYALL("Posting Date","Posting Date");
    end;
*/


    
    
/*
procedure UndoPostedDocFields ()
    var
//       IncomingDocumentAttachment@1002 :
      IncomingDocumentAttachment: Record 133;
//       DummyRecordID@1000 :
      DummyRecordID: RecordID;
    begin
      if "Entry No." = 0 then
        exit;
      if not Posted then
        exit;
      if not CONFIRM(STRSUBSTNO(DetachQst,"Document No.","Posting Date"),FALSE) then
        exit;
      Posted := FALSE;
      Processed := FALSE;
      Status := Status::Released;
      "Posted Date-Time" := 0DT;
      "Related Record ID" := DummyRecordID;
      "Document No." := '';
      "Document Type" := "Document Type"::" ";
      "Posting Date" := 0D;

      // To clear the filters and prevent the page from putting values back
      SETRANGE("Posted Date-Time");
      SETRANGE("Document No.");
      SETRANGE("Document Type");
      SETRANGE("Posting Date");

      MODIFY(TRUE);
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.MODIFYALL("Document No.","Document No.");
      IncomingDocumentAttachment.MODIFYALL("Posting Date","Posting Date");

      MESSAGE(RemovePostedRecordManuallyMsg);
    end;
*/


    
//     procedure UpdateIncomingDocumentFromPosting (IncomingDocumentNo@1000 : Integer;PostingDate@1001 : Date;DocNo@1002 :
    
/*
procedure UpdateIncomingDocumentFromPosting (IncomingDocumentNo: Integer;PostingDate: Date;DocNo: Code[20])
    var
//       IncomingDocument@1003 :
      IncomingDocument: Record 130;
    begin
      if IncomingDocumentNo = 0 then
        exit;

      if not IncomingDocument.GET(IncomingDocumentNo) then
        exit;

      IncomingDocument.SetPostedDocFieldsForcePosted(PostingDate,DocNo,TRUE);
      IncomingDocument.MODIFY;
    end;
*/


    
/*
LOCAL procedure ClearRelatedRecords ()
    var
//       GenJnlLine@1002 :
      GenJnlLine: Record 81;
//       SalesHeader@1001 :
      SalesHeader: Record 36;
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
    begin
      CASE "Document Type" OF
        "Document Type"::Journal:
          begin
            GenJnlLine.SETRANGE("Incoming Document Entry No.","Entry No.");
            GenJnlLine.MODIFYALL("Incoming Document Entry No.",0,TRUE);
          end;
        "Document Type"::"Sales Invoice","Document Type"::"Sales Credit Memo":
          begin
            SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            SalesHeader.MODIFYALL("Incoming Document Entry No.",0,TRUE);
          end;
        "Document Type"::"Purchase Invoice","Document Type"::"Purchase Credit Memo":
          begin
            PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            PurchaseHeader.MODIFYALL("Incoming Document Entry No.",0,TRUE);
          end;
      end;
    end;
*/


//     LOCAL procedure CreateSalesDoc (DocType@1000 :
    
/*
LOCAL procedure CreateSalesDoc (DocType: Option)
    var
//       SalesHeader@1001 :
      SalesHeader: Record 36;
    begin
      TestReadyForProcessing;
      SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      if not SalesHeader.ISEMPTY then begin
        ShowRecord;
        exit;
      end;
      SalesHeader.RESET;
      SalesHeader.INIT;
      CASE DocType OF
        DocumentType::Invoice:
          SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        DocumentType::"Credit Memo":
          SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
      end;
      SalesHeader.INSERT(TRUE);
      OnAfterCreateSalesHeaderFromIncomingDoc(SalesHeader);
      if GetURL <> '' then
        SalesHeader.ADDLINK(GetURL,Description);
      SalesHeader."Incoming Document Entry No." := "Entry No.";
      SalesHeader.MODIFY;
      "Document No." := SalesHeader."No.";
      MODIFY(TRUE);
      COMMIT;
      ShowRecord;
    end;
*/


//     LOCAL procedure CreatePurchDoc (DocType@1000 :
    
/*
LOCAL procedure CreatePurchDoc (DocType: Option)
    var
//       PurchHeader@1001 :
      PurchHeader: Record 38;
    begin
      TestReadyForProcessing;
      PurchHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      if not PurchHeader.ISEMPTY then begin
        ShowRecord;
        exit;
      end;
      PurchHeader.RESET;
      PurchHeader.INIT;
      CASE DocType OF
        DocumentType::Invoice:
          PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
        DocumentType::"Credit Memo":
          PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
      end;
      PurchHeader.INSERT(TRUE);
      OnAfterCreatePurchHeaderFromIncomingDoc(PurchHeader);
      if GetURL <> '' then
        PurchHeader.ADDLINK(GetURL,Description);
      PurchHeader."Incoming Document Entry No." := "Entry No.";
      PurchHeader.MODIFY;
      "Document No." := PurchHeader."No.";
      MODIFY(TRUE);
      COMMIT;
      ShowRecord;
    end;
*/


    
//     procedure SetGenJournalLine (var GenJnlLine@1000 :
    
/*
procedure SetGenJournalLine (var GenJnlLine: Record 81)
    begin
      if GenJnlLine."Incoming Document Entry No." = 0 then
        exit;
      GET(GenJnlLine."Incoming Document Entry No.");
      TestReadyForProcessing;
      TestIfAlreadyExists;
      "Document Type" := "Document Type"::Journal;
      MODIFY(TRUE);
      if not DocLinkExists(GenJnlLine) then
        GenJnlLine.ADDLINK(GetURL,Description);
    end;
*/


    
//     procedure SetSalesDoc (var SalesHeader@1000 :
    
/*
procedure SetSalesDoc (var SalesHeader: Record 36)
    begin
      if SalesHeader."Incoming Document Entry No." = 0 then
        exit;
      GET(SalesHeader."Incoming Document Entry No.");
      TestReadyForProcessing;
      TestIfAlreadyExists;
      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::Invoice:
          "Document Type" := "Document Type"::"Sales Invoice";
        SalesHeader."Document Type"::"Credit Memo":
          "Document Type" := "Document Type"::"Sales Credit Memo";
      end;
      MODIFY;
      if not DocLinkExists(SalesHeader) then
        SalesHeader.ADDLINK(GetURL,Description);
    end;
*/


    
//     procedure SetPurchDoc (var PurchaseHeader@1000 :
    
/*
procedure SetPurchDoc (var PurchaseHeader: Record 38)
    begin
      if PurchaseHeader."Incoming Document Entry No." = 0 then
        exit;
      GET(PurchaseHeader."Incoming Document Entry No.");
      TestReadyForProcessing;
      TestIfAlreadyExists;
      CASE PurchaseHeader."Document Type" OF
        PurchaseHeader."Document Type"::Invoice:
          "Document Type" := "Document Type"::"Purchase Invoice";
        PurchaseHeader."Document Type"::"Credit Memo":
          "Document Type" := "Document Type"::"Purchase Credit Memo";
      end;
      MODIFY;
      if not DocLinkExists(PurchaseHeader) then
        PurchaseHeader.ADDLINK(GetURL,Description);
    end;
*/


//     LOCAL procedure DocLinkExists (RecVar@1000 :
    
/*
LOCAL procedure DocLinkExists (RecVar: Variant) : Boolean;
    var
//       RecordLink@1002 :
      RecordLink: Record 2000000068;
//       RecRef@1001 :
      RecRef: RecordRef;
    begin
      if GetURL = '' then
        exit(TRUE);
      RecRef.GETTABLE(RecVar);
      RecordLink.SETRANGE("Record ID",RecRef.RECORDID);
      RecordLink.SETRANGE(URL1,URL1);
      RecordLink.SETRANGE(Description,Description);
      exit(not RecordLink.ISEMPTY);
    end;
*/


    
//     procedure HyperlinkToDocument (DocumentNo@1000 : Code[20];PostingDate@1001 :
    
/*
procedure HyperlinkToDocument (DocumentNo: Code[20];PostingDate: Date)
    var
//       IncomingDocumentAttachment@1002 :
      IncomingDocumentAttachment: Record 133;
    begin
      if ForwardToExistingLink(DocumentNo,PostingDate) then
        exit;
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETFILTER(Type,'<>%1',IncomingDocumentAttachment.Type::XML);
      if IncomingDocumentAttachment.FINDFIRST then
        IncomingDocumentAttachment.Export('',TRUE);
    end;
*/


    
//     procedure ForwardToExistingLink (DocumentNo@1001 : Code[20];PostingDate@1000 :
    
/*
procedure ForwardToExistingLink (DocumentNo: Code[20];PostingDate: Date) : Boolean;
    begin
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      if not FINDFIRST then begin
        MESSAGE(NoDocumentMsg);
        exit(TRUE);
      end;
      if GetURL <> '' then begin
        HYPERLINK(GetURL);
        exit(TRUE);
      end;
    end;
*/


    
//     procedure ShowCard (DocumentNo@1000 : Code[20];PostingDate@1001 :
    
/*
procedure ShowCard (DocumentNo: Code[20];PostingDate: Date)
    begin
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      if not FINDFIRST then
        exit;
      SETRECFILTER;
      PAGE.RUN(PAGE::"Incoming Document",Rec);
    end;
*/


    
//     procedure ShowCardFromEntryNo (EntryNo@1000 :
    
/*
procedure ShowCardFromEntryNo (EntryNo: Integer)
    begin
      if EntryNo = 0 then
        exit;
      GET(EntryNo);
      SETRECFILTER;
      PAGE.RUN(PAGE::"Incoming Document",Rec);
    end;
*/


    
//     procedure ImportAttachment (var IncomingDocument@1001 :
    
/*
procedure ImportAttachment (var IncomingDocument: Record 130)
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.NewAttachment;
      IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.")
    end;
*/


    
//     procedure AddXmlAttachmentFromXmlText (var IncomingDocumentAttachment@1002 : Record 133;OrgFileName@1000 : Text;XmlText@1001 :
    
/*
procedure AddXmlAttachmentFromXmlText (var IncomingDocumentAttachment: Record 133;OrgFileName: Text;XmlText: Text)
    var
//       FileManagement@1004 :
      FileManagement: Codeunit 419;
//       OutStr@1003 :
      OutStr: OutStream;
    begin
      TESTFIELD("Entry No.");
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      if not IncomingDocumentAttachment.FINDLAST then
        IncomingDocumentAttachment."Line No." := 10000
      else
        IncomingDocumentAttachment."Line No." += 10000;
      IncomingDocumentAttachment."Incoming Document Entry No." := "Entry No.";
      IncomingDocumentAttachment.INIT;
      IncomingDocumentAttachment.Name :=
        COPYSTR(FileManagement.GetFileNameWithoutExtension(OrgFileName),1,MAXSTRLEN(IncomingDocumentAttachment.Name));
      IncomingDocumentAttachment.VALIDATE("File Extension",'xml');
      IncomingDocumentAttachment.Content.CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF8);
      OutStr.WRITETEXT(XmlText);
      IncomingDocumentAttachment.INSERT(TRUE);
      if IncomingDocumentAttachment.Type IN [IncomingDocumentAttachment.Type::Image,IncomingDocumentAttachment.Type::PDF] then
        IncomingDocumentAttachment.OnAttachBinaryFile;
    end;
*/


    
//     procedure AddAttachmentFromStream (var IncomingDocumentAttachment@1002 : Record 133;OrgFileName@1000 : Text;FileExtension@1006 : Text;var InStr@1001 :
    
/*
procedure AddAttachmentFromStream (var IncomingDocumentAttachment: Record 133;OrgFileName: Text;FileExtension: Text;var InStr: InStream)
    var
//       FileManagement@1004 :
      FileManagement: Codeunit 419;
//       OutStr@1003 :
      OutStr: OutStream;
    begin
      TESTFIELD("Entry No.");
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      if not IncomingDocumentAttachment.FINDLAST then
        IncomingDocumentAttachment."Line No." := 10000
      else
        IncomingDocumentAttachment."Line No." += 10000;
      IncomingDocumentAttachment."Incoming Document Entry No." := "Entry No.";
      IncomingDocumentAttachment.INIT;
      IncomingDocumentAttachment.Name :=
        COPYSTR(FileManagement.GetFileNameWithoutExtension(OrgFileName),1,MAXSTRLEN(IncomingDocumentAttachment.Name));
      IncomingDocumentAttachment.VALIDATE(
        "File Extension",COPYSTR(FileExtension,1,MAXSTRLEN(IncomingDocumentAttachment."File Extension")));
      IncomingDocumentAttachment.Content.CREATEOUTSTREAM(OutStr);
      COPYSTREAM(OutStr,InStr);
      IncomingDocumentAttachment.INSERT(TRUE);
    end;
*/


    
//     procedure AddAttachmentFromServerFile (FileName@1000 : Text;FilePath@1001 :
    
/*
procedure AddAttachmentFromServerFile (FileName: Text;FilePath: Text)
    var
//       IncomingDocumentAttachment@1005 :
      IncomingDocumentAttachment: Record 133;
//       FileManagement@1004 :
      FileManagement: Codeunit 419;
//       File@1003 :
      File: File;
//       InStr@1002 :
      InStr: InStream;
    begin
      if (FileName = '') or (FilePath = '') then
        exit;
      if not File.OPEN(FilePath) then
        exit;
      File.CREATEINSTREAM(InStr);
      AddAttachmentFromStream(IncomingDocumentAttachment,FileName,FileManagement.GetExtension(FileName),InStr);
      File.CLOSE;
      if ERASE(FilePath) then;
    end;
*/


//     LOCAL procedure SetProcessFailed (ErrorMsg@1000 :
    
/*
LOCAL procedure SetProcessFailed (ErrorMsg: Text[250])
    var
//       ErrorMessage@1001 :
      ErrorMessage: Record 700;
//       ReleaseIncomingDocument@1002 :
      ReleaseIncomingDocument: Codeunit 132;
    begin
      ReleaseIncomingDocument.Fail(Rec);

      if ErrorMsg = '' then begin
        ErrorMsg := COPYSTR(GETLASTERRORTEXT,1,MAXSTRLEN(ErrorMessage.Description));
        CLEARLASTERROR;
      end;

      if ErrorMsg <> '' then begin
        ErrorMessage.SetContext(RECORDID);
        ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error,ErrorMsg);
      end;

      if GUIALLOWED then
        MESSAGE(DocNotCreatedMsg);
    end;

    [TryFunction]
*/

    
/*
LOCAL procedure UpdateDocumentFields ()
    var
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
//       SalesHeader@1001 :
      SalesHeader: Record 36;
//       GenJournalLine@1002 :
      GenJournalLine: Record 81;
//       DocExists@1003 :
      DocExists: Boolean;
    begin
      // if purchase
      PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      if PurchaseHeader.FINDFIRST then begin
        CASE PurchaseHeader."Document Type" OF
          PurchaseHeader."Document Type"::Invoice:
            "Document Type" := "Document Type"::"Purchase Invoice";
          PurchaseHeader."Document Type"::"Credit Memo":
            "Document Type" := "Document Type"::"Purchase Credit Memo";
          else
            ERROR(NotSupportedPurchErr,FORMAT(PurchaseHeader."Document Type"));
        end;
        "Document No." := PurchaseHeader."No.";
        exit;
      end;

      // if sales
      SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      if SalesHeader.FINDFIRST then begin
        CASE SalesHeader."Document Type" OF
          SalesHeader."Document Type"::Invoice:
            "Document Type" := "Document Type"::"Sales Invoice";
          SalesHeader."Document Type"::"Credit Memo":
            "Document Type" := "Document Type"::"Sales Credit Memo";
          else
            ERROR(NotSupportedSalesErr,FORMAT(SalesHeader."Document Type"));
        end;
        "Document No." := SalesHeader."No.";
        exit;
      end;

      // if general journal line
      GenJournalLine.SETRANGE("Incoming Document Entry No.","Entry No.");
      if GenJournalLine.FINDFIRST then begin
        "Document No." := GenJournalLine."Document No.";
        exit;
      end;

      DocExists := FALSE;
      OnAfterUpdateDocumentFields(Rec,DocExists);
      if not DocExists then
        ERROR(EntityNotFoundErr);
    end;
*/


    
/*
LOCAL procedure ClearErrorMessages ()
    var
//       ErrorMessage@1000 :
      ErrorMessage: Record 700;
    begin
      ErrorMessage.SETRANGE("Context Record ID",RECORDID);
      ErrorMessage.DELETEALL;
      TempErrorMessage.SETRANGE("Context Record ID",RECORDID);
      TempErrorMessage.DELETEALL;
    end;
*/


    
//     procedure SelectIncomingDocument (EntryNo@1000 : Integer;RelatedRecordID@1004 :
    
/*
procedure SelectIncomingDocument (EntryNo: Integer;RelatedRecordID: RecordID) : Integer;
    var
//       IncomingDocumentsSetup@1003 :
      IncomingDocumentsSetup: Record 131;
//       IncomingDocument@1001 :
      IncomingDocument: Record 130;
//       IncomingDocuments@1002 :
      IncomingDocuments: Page 190;
    begin
      if EntryNo <> 0 then begin
        IncomingDocument.GET(EntryNo);
        IncomingDocuments.SETRECORD(IncomingDocument);
      end;
      if IncomingDocumentsSetup.GET then
        if IncomingDocumentsSetup."Require Approval To Create" then
          IncomingDocument.SETRANGE(Released,TRUE);
      IncomingDocument.SETRANGE(Posted,FALSE);
      IncomingDocuments.SETTABLEVIEW(IncomingDocument);
      IncomingDocuments.LOOKUPMODE := TRUE;
      if IncomingDocuments.RUNMODAL = ACTION::LookupOK then begin
        IncomingDocuments.GETRECORD(IncomingDocument);
        IncomingDocument.VALIDATE("Related Record ID",RelatedRecordID);
        IncomingDocument.MODIFY;
        exit(IncomingDocument."Entry No.");
      end;
      exit(EntryNo);
    end;
*/


    
//     procedure SelectIncomingDocumentForPostedDocument (DocumentNo@1000 : Code[20];PostingDate@1003 : Date;RelatedRecordID@1005 :
    
/*
procedure SelectIncomingDocumentForPostedDocument (DocumentNo: Code[20];PostingDate: Date;RelatedRecordID: RecordID)
    var
//       IncomingDocument@1001 :
      IncomingDocument: Record 130;
//       EntryNo@1002 :
      EntryNo: Integer;
//       IsPosted@1004 :
      IsPosted: Boolean;
    begin
      if (DocumentNo = '') or (PostingDate = 0D) then
        exit;
      EntryNo := SelectIncomingDocument(0,RelatedRecordID);
      if EntryNo = 0 then
        exit;

      IncomingDocument.GET(EntryNo);
      IncomingDocument.SetPostedDocFields(PostingDate,DocumentNo);
      IncomingDocument."Document Type" := GetPostedDocType(PostingDate,DocumentNo,IsPosted);
    end;
*/


    
//     procedure SendToJobQueue (ShowMessages@1001 :
    
/*
procedure SendToJobQueue (ShowMessages: Boolean)
    var
//       SendIncomingDocumentToOCR@1000 :
      SendIncomingDocumentToOCR: Codeunit 133;
    begin
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.SendToJobQueue(Rec);
    end;
*/


    
    
/*
procedure ResetOriginalOCRData ()
    var
//       OCRServiceMgt@1000 :
      OCRServiceMgt: Codeunit 1294;
//       OriginalXMLRootNode@1004 :
      OriginalXMLRootNode: DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    begin
      OCRServiceMgt.GetOriginalOCRXMLRootNode(Rec,OriginalXMLRootNode);
      OCRServiceMgt.UpdateIncomingDocWithOCRData(Rec,OriginalXMLRootNode);
    end;
*/


    
    
/*
procedure UploadCorrectedOCRData () : Boolean;
    var
//       OCRServiceMgt@1000 :
      OCRServiceMgt: Codeunit 1294;
    begin
      exit(OCRServiceMgt.UploadCorrectedOCRFile(Rec))
    end;
*/


    
//     procedure SaveErrorMessages (var TempErrorMessageRef@1000 :
    
/*
procedure SaveErrorMessages (var TempErrorMessageRef: Record 700 TEMPORARY)
    begin
      if not TempErrorMessageRef.FINDSET then
        exit;

      repeat
        TempErrorMessage := TempErrorMessageRef;
        TempErrorMessage.INSERT;
      until TempErrorMessageRef.NEXT = 0;
    end;
*/


    
//     procedure RemoveFromJobQueue (ShowMessages@1001 :
    
/*
procedure RemoveFromJobQueue (ShowMessages: Boolean)
    var
//       SendIncomingDocumentToOCR@1000 :
      SendIncomingDocumentToOCR: Codeunit 133;
    begin
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.RemoveFromJobQueue(Rec);
    end;
*/


    
//     procedure SendToOCR (ShowMessages@1001 :
    
/*
procedure SendToOCR (ShowMessages: Boolean)
    var
//       SendIncomingDocumentToOCR@1000 :
      SendIncomingDocumentToOCR: Codeunit 133;
    begin
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.SendDocToOCR(Rec);
      SendIncomingDocumentToOCR.ScheduleJobQueueReceive;
    end;
*/


    
//     procedure SetStatus (NewStatus@1000 :
    
/*
procedure SetStatus (NewStatus: Option)
    begin
      Status := NewStatus;
      MODIFY;
    end;
*/


    
//     procedure RetrieveFromOCR (ShowMessages@1001 :
    
/*
procedure RetrieveFromOCR (ShowMessages: Boolean)
    var
//       SendIncomingDocumentToOCR@1000 :
      SendIncomingDocumentToOCR: Codeunit 133;
    begin
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.RetrieveDocFromOCR(Rec);
    end;
*/


    
//     procedure GetGeneratedFromOCRAttachment (var IncomingDocumentAttachment@1000 :
    
/*
procedure GetGeneratedFromOCRAttachment (var IncomingDocumentAttachment: Record 133) : Boolean;
    begin
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE("Generated from OCR",TRUE);
      exit(IncomingDocumentAttachment.FINDFIRST)
    end;
*/


    
//     procedure GetDataExchangePath (FieldNumber@1000 :
    
/*
procedure GetDataExchangePath (FieldNumber: Integer) : Text;
    var
//       DataExchangeType@1001 :
      DataExchangeType: Record 1213;
//       DataExchLineDef@1003 :
      DataExchLineDef: Record 1227;
//       PurchaseHeader@1002 :
      PurchaseHeader: Record 38;
//       VendorBankAccount@1004 :
      VendorBankAccount: Record 288;
//       Vendor@1005 :
      Vendor: Record 23;
//       GLEntry@1006 :
      GLEntry: Record 17;
//       DataExchangePath@1007 :
      DataExchangePath: Text;
    begin
      if not DataExchangeType.GET("Data Exchange Type") then
        exit('');
      DataExchLineDef.SETRANGE("Data Exch. Def Code",DataExchangeType."Data Exch. Def. Code");
      DataExchLineDef.SETRANGE("Parent Code",'');
      if not DataExchLineDef.FINDFIRST then
        exit('');
      CASE FieldNumber OF
        FIELDNO("Vendor Name"):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Buy-from Vendor Name")));
        FIELDNO("Vendor Id"):
          exit(DataExchLineDef.GetPath(DATABASE::Vendor,Vendor.FIELDNO(Id)));
        FIELDNO("Vendor VAT Registration No."):
          exit(DataExchLineDef.GetPath(DATABASE::Vendor,Vendor.FIELDNO("VAT Registration No.")));
        FIELDNO("Vendor IBAN"):
          exit(DataExchLineDef.GetPath(DATABASE::"Vendor Bank Account",VendorBankAccount.FIELDNO(IBAN)));
        FIELDNO("Vendor Bank Branch No."):
          exit(DataExchLineDef.GetPath(DATABASE::"Vendor Bank Account",VendorBankAccount.FIELDNO("Bank Branch No.")));
        FIELDNO("Vendor Bank Account No."):
          exit(DataExchLineDef.GetPath(DATABASE::"Vendor Bank Account",VendorBankAccount.FIELDNO("Bank Account No.")));
        FIELDNO("Vendor Phone No."):
          exit(DataExchLineDef.GetPath(DATABASE::Vendor,Vendor.FIELDNO("Phone No.")));
        FIELDNO("Vendor Invoice No."):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Vendor Invoice No.")));
        FIELDNO("Document Date"):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Document Date")));
        FIELDNO("Due Date"):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Due Date")));
        FIELDNO("Currency Code"):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Currency Code")));
        FIELDNO("Amount Excl. VAT"):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO(Amount)));
        FIELDNO("Amount Incl. VAT"):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Amount Including VAT")));
        FIELDNO("Order No."):
          exit(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Vendor Order No.")));
        FIELDNO("VAT Amount"):
          exit(DataExchLineDef.GetPath(DATABASE::"G/L Entry",GLEntry.FIELDNO("VAT Amount")));
        else begin
          OnGetDataExchangePath(DataExchLineDef,FieldNumber,DataExchangePath);
          if  DataExchangePath <> '' then
            exit(DataExchangePath);
        end;
      end;

      exit('');
    end;
*/


    
    
/*
procedure ShowRecord ()
    var
//       PageManagement@1000 :
      PageManagement: Codeunit 700;
//       DataTypeManagement@1003 :
      DataTypeManagement: Codeunit 701;
//       RecRef@1002 :
      RecRef: RecordRef;
//       RelatedRecord@1001 :
      RelatedRecord: Variant;
    begin
      if GetRecord(RelatedRecord) then begin
        DataTypeManagement.GetRecordRef(RelatedRecord,RecRef);
        PageManagement.PageRun(RecRef);
      end;
    end;
*/


    
//     procedure GetRecord (var RelatedRecord@1001 :
    
/*
procedure GetRecord (var RelatedRecord: Variant) : Boolean;
    begin
      if Posted then
        exit(GetPostedRecord(RelatedRecord));
      exit(GetUnpostedRecord(RelatedRecord));
    end;
*/


//     LOCAL procedure GetPostedRecord (var RelatedRecord@1000 :
    
/*
LOCAL procedure GetPostedRecord (var RelatedRecord: Variant) : Boolean;
    var
//       RelatedRecordRef@1001 :
      RelatedRecordRef: RecordRef;
    begin
      if GetRelatedRecord(RelatedRecordRef) then begin
        RelatedRecord := RelatedRecordRef;
        exit(TRUE);
      end;
      exit(FindPostedRecord(RelatedRecord));
    end;
*/


//     LOCAL procedure FindPostedRecord (var RelatedRecord@1000 :
    
/*
LOCAL procedure FindPostedRecord (var RelatedRecord: Variant) : Boolean;
    var
//       SalesInvoiceHeader@1004 :
      SalesInvoiceHeader: Record 112;
//       SalesCrMemoHeader@1005 :
      SalesCrMemoHeader: Record 114;
//       PurchInvHeader@1003 :
      PurchInvHeader: Record 122;
//       PurchCrMemoHdr@1006 :
      PurchCrMemoHdr: Record 124;
//       GLEntry@1002 :
      GLEntry: Record 17;
//       RecordFound@1001 :
      RecordFound: Boolean;
    begin
      CASE "Document Type" OF
        "Document Type"::Journal:
          begin
            GLEntry.SETCURRENTKEY("Document No.","Posting Date");
            GLEntry.SETRANGE("Document No.","Document No.");
            GLEntry.SETRANGE("Posting Date","Posting Date");
            if GLEntry.FINDFIRST then begin
              RelatedRecord := GLEntry;
              exit(TRUE);
            end;
          end;
        "Document Type"::"Sales Invoice":
          if SalesInvoiceHeader.GET("Document No.") then begin
            RelatedRecord := SalesInvoiceHeader;
            exit(TRUE);
          end;
        "Document Type"::"Sales Credit Memo":
          if SalesCrMemoHeader.GET("Document No.") then begin
            RelatedRecord := SalesCrMemoHeader;
            exit(TRUE);
          end;
        "Document Type"::"Purchase Invoice":
          if PurchInvHeader.GET("Document No.") then begin
            RelatedRecord := PurchInvHeader;
            exit(TRUE);
          end;
        "Document Type"::"Purchase Credit Memo":
          if PurchCrMemoHdr.GET("Document No.") then begin
            RelatedRecord := PurchCrMemoHdr;
            exit(TRUE);
          end;
      end;
      RecordFound := FALSE;
      OnAfterFindPostedRecord(RelatedRecord,RecordFound);
      exit(RecordFound);
    end;
*/


//     LOCAL procedure GetUnpostedRecord (var RelatedRecord@1000 :
    
/*
LOCAL procedure GetUnpostedRecord (var RelatedRecord: Variant) : Boolean;
    var
//       RelatedRecordRef@1001 :
      RelatedRecordRef: RecordRef;
    begin
      if GetRelatedRecord(RelatedRecordRef) then begin
        RelatedRecord := RelatedRecordRef;
        exit(TRUE);
      end;
      exit(FindUnpostedRecord(RelatedRecord));
    end;
*/


//     LOCAL procedure FindUnpostedRecord (var RelatedRecord@1000 :
    
/*
LOCAL procedure FindUnpostedRecord (var RelatedRecord: Variant) : Boolean;
    var
//       SalesHeader@1005 :
      SalesHeader: Record 36;
//       PurchaseHeader@1004 :
      PurchaseHeader: Record 38;
//       GenJournalLine@1003 :
      GenJournalLine: Record 81;
//       RecordFound@1001 :
      RecordFound: Boolean;
    begin
      CASE "Document Type" OF
        "Document Type"::Journal:
          begin
            GenJournalLine.SETRANGE("Incoming Document Entry No.","Entry No.");
            if GenJournalLine.FINDFIRST then begin
              GenJournalLine.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
              GenJournalLine.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
              RelatedRecord := GenJournalLine;
              exit(TRUE)
            end;
          end;
        "Document Type"::"Sales Invoice",
        "Document Type"::"Sales Credit Memo":
          begin
            SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            if SalesHeader.FINDFIRST then begin
              RelatedRecord := SalesHeader;
              exit(TRUE);
            end;
          end;
        "Document Type"::"Purchase Invoice",
        "Document Type"::"Purchase Credit Memo":
          begin
            PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            if PurchaseHeader.FINDFIRST then begin
              RelatedRecord := PurchaseHeader;
              exit(TRUE);
            end;
          end;
      end;
      RecordFound := FALSE;
      OnAfterFindUnpostedRecord(RelatedRecord,RecordFound);
      exit(RecordFound);
    end;
*/


//     LOCAL procedure GetRelatedRecord (var RelatedRecordRef@1000 :
    
/*
LOCAL procedure GetRelatedRecord (var RelatedRecordRef: RecordRef) : Boolean;
    var
//       RelatedRecordID@1001 :
      RelatedRecordID: RecordID;
    begin
      RelatedRecordID := "Related Record ID";
      if RelatedRecordID.TABLENO = 0 then
        exit(FALSE);
      RelatedRecordRef := RelatedRecordID.GETRECORD;
      exit(RelatedRecordRef.GET(RelatedRecordID));
    end;
*/


    
    
/*
procedure RemoveLinkToRelatedRecord ()
    var
//       DummyRecordID@1000 :
      DummyRecordID: RecordID;
    begin
      "Related Record ID" := DummyRecordID;
      "Document No." := '';
      "Document Type" := "Document Type"::" ";
      MODIFY(TRUE);
    end;
*/


    
    
/*
procedure RemoveReferencedRecords ()
    var
//       RecRef@1000 :
      RecRef: RecordRef;
//       NavRecordVariant@1001 :
      NavRecordVariant: Variant;
    begin
      if Posted then
        UndoPostedDocFields
      else begin
        if not CONFIRM(DoYouWantToRemoveReferenceQst) then
          exit;

        if CONFIRM(DeleteRecordQst) then
          if GetRecord(NavRecordVariant) then begin
            RecRef.GETTABLE(NavRecordVariant);
            RecRef.DELETE(TRUE);
            exit;
          end;

        RemoveIncomingDocumentEntryNoFromUnpostedDocument;
        RemoveReferenceToWorkingDocument("Entry No.");
      end;
    end;
*/


    
    
/*
procedure CreateFromAttachment ()
    var
//       IncomingDocumentAttachment@1001 :
      IncomingDocumentAttachment: Record 133;
//       IncomingDocument@1004 :
      IncomingDocument: Record 130;
    begin
      if IncomingDocumentAttachment.Import then begin
        IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.");
        PAGE.RUN(PAGE::"Incoming Document",IncomingDocument);
      end;
    end;
*/


    
//     procedure GetMainAttachment (var IncomingDocumentAttachment@1001 :
    
/*
procedure GetMainAttachment (var IncomingDocumentAttachment: Record 133) : Boolean;
    begin
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE("Main Attachment",TRUE);
      exit(IncomingDocumentAttachment.FINDFIRST);
    end;
*/


    
    
/*
procedure GetMainAttachmentFileName () : Text;
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      if GetMainAttachment(IncomingDocumentAttachment) then
        exit(IncomingDocumentAttachment.GetFullName);

      exit('');
    end;
*/


    
    
/*
procedure GetRecordLinkText () : Text;
    var
//       DataTypeManagement@1001 :
      DataTypeManagement: Codeunit 701;
//       RecRef@1000 :
      RecRef: RecordRef;
//       VariantRecord@1002 :
      VariantRecord: Variant;
    begin
      if GetRecord(VariantRecord) and DataTypeManagement.GetRecordRef(VariantRecord,RecRef) then
        exit(GetRelatedRecordCaption(RecRef));
      exit('');
    end;
*/


//     LOCAL procedure GetRelatedRecordCaption (var RelatedRecordRef@1003 :
    
/*
LOCAL procedure GetRelatedRecordCaption (var RelatedRecordRef: RecordRef) : Text;
    var
//       GenJournalLine@1001 :
      GenJournalLine: Record 81;
//       RecCaption@1000 :
      RecCaption: Text;
    begin
      if RelatedRecordRef.ISEMPTY then
        exit('');

      CASE RelatedRecordRef.NUMBER OF
        DATABASE::"Sales Header":
          RecCaption := STRSUBSTNO('%1 %2',SalesTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Sales Invoice Header":
          RecCaption := STRSUBSTNO('%1 - %2',SalesInvoiceTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Sales Cr.Memo Header":
          RecCaption := STRSUBSTNO('%1 - %2',SalesCreditMemoTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Purchase Header":
          RecCaption := STRSUBSTNO('%1 %2',PurchaseTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Purch. Inv. Header":
          RecCaption := STRSUBSTNO('%1 - %2',PurchaseInvoiceTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Purch. Cr. Memo Hdr.":
          RecCaption := STRSUBSTNO('%1 - %2',PurchaseCreditMemoTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"G/L Entry":
          RecCaption := STRSUBSTNO('%1 - %2',"Document Type",GeneralLedgerEntriesTxt);
        DATABASE::"Gen. Journal Line":
          if Posted then
            RecCaption := STRSUBSTNO('%1 - %2',"Document Type",GeneralLedgerEntriesTxt)
          else begin
            RelatedRecordRef.SETTABLE(GenJournalLine);
            if GenJournalLine."Document Type" <> GenJournalLine."Document Type"::" " then
              RecCaption := STRSUBSTNO('%1 - %2',GenJournalLine."Document Type",GetRecordCaption(RelatedRecordRef))
            else
              RecCaption := STRSUBSTNO('%1 - %2',JournalTxt,GetRecordCaption(RelatedRecordRef));
          end;
        else
          RecCaption := STRSUBSTNO('%1 - %2',RelatedRecordRef.CAPTION,GetRecordCaption(RelatedRecordRef));
      end;
      OnAfterGetRelatedRecordCaption(RelatedRecordRef,RecCaption);
      exit(RecCaption);
    end;
*/


//     LOCAL procedure GetRecordCaption (var RecRef@1005 :
    
/*
LOCAL procedure GetRecordCaption (var RecRef: RecordRef) : Text;
    var
//       KeyRef@1003 :
      KeyRef: KeyRef;
//       FieldRef@1001 :
      FieldRef: FieldRef;
//       KeyNo@1006 :
      KeyNo: Integer;
//       FieldNo@1007 :
      FieldNo: Integer;
//       RecCaption@1000 :
      RecCaption: Text;
    begin
      FOR KeyNo := 1 TO RecRef.KEYCOUNT DO begin
        KeyRef := RecRef.KEYINDEX(KeyNo);
        if KeyRef.ACTIVE then begin
          FOR FieldNo := 1 TO KeyRef.FIELDCOUNT DO begin
            FieldRef := KeyRef.FIELDINDEX(FieldNo);
            if RecCaption <> '' then
              RecCaption := STRSUBSTNO('%1 - %2',RecCaption,FieldRef.VALUE)
            else
              RecCaption := FORMAT(FieldRef.VALUE);
          end;
          BREAK;
        end
      end;
      exit(RecCaption);
    end;
*/


    
    
/*
procedure GetOCRResutlFileName () : Text;
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
//       FileName@1001 :
      FileName: Text;
    begin
      FileName := '';
      if GetGeneratedFromOCRAttachment(IncomingDocumentAttachment) then
        FileName := IncomingDocumentAttachment.GetFullName;

      exit(FileName);
    end;
*/


    
    
/*
procedure MainAttachmentDrillDown ()
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      if not GetMainAttachment(IncomingDocumentAttachment) then begin
        IncomingDocumentAttachment.NewAttachment;
        exit;
      end;

      // Download
      IncomingDocumentAttachment.Export('',TRUE);
    end;
*/


    
    
/*
procedure ReplaceOrInsertMainAttachment ()
    begin
      ReplaceMainAttachment('');
    end;
*/


    
//     procedure ReplaceMainAttachment (FilePath@1001 :
    
/*
procedure ReplaceMainAttachment (FilePath: Text)
    var
//       MainIncomingDocumentAttachment@1002 :
      MainIncomingDocumentAttachment: Record 133;
//       NewIncomingDocumentAttachment@1004 :
      NewIncomingDocumentAttachment: Record 133;
//       ImportAttachmentIncDoc@1003 :
      ImportAttachmentIncDoc: Codeunit 134;
    begin
      if not CanReplaceMainAttachment then
        ERROR(CannotReplaceMainAttachmentErr);

      if not GetMainAttachment(MainIncomingDocumentAttachment) then begin
        MainIncomingDocumentAttachment.NewAttachment;
        exit;
      end;

      if not CONFIRM(ReplaceMainAttachmentQst) then
        exit;

      if FilePath = '' then
        ImportAttachmentIncDoc.UploadFile(NewIncomingDocumentAttachment,FilePath);

      if FilePath = '' then
        exit;

      MainIncomingDocumentAttachment.DELETE;
      COMMIT;

      NewIncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      ImportAttachmentIncDoc.ImportAttachment(NewIncomingDocumentAttachment,FilePath);
    end;
*/


    
    
/*
procedure ShowMainAttachment ()
    var
//       IncomingDocumentAttachment@1001 :
      IncomingDocumentAttachment: Record 133;
    begin
      if GetMainAttachment(IncomingDocumentAttachment) then
        IncomingDocumentAttachment.Export('',TRUE);
    end;
*/


    
    
/*
procedure OCRResultDrillDown ()
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      if not GetGeneratedFromOCRAttachment(IncomingDocumentAttachment) then
        exit;

      IncomingDocumentAttachment.Export('',TRUE);
    end;
*/


    
//     procedure GetAdditionalAttachments (var IncomingDocumentAttachment@1001 :
    
/*
procedure GetAdditionalAttachments (var IncomingDocumentAttachment: Record 133) : Boolean;
    begin
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE("Main Attachment",FALSE);
      IncomingDocumentAttachment.SETRANGE("Generated from OCR",FALSE);
      exit(IncomingDocumentAttachment.FINDSET);
    end;
*/


    
    
/*
procedure DefaultAttachmentIsXML () : Boolean;
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE(Default,TRUE);

      if IncomingDocumentAttachment.FINDFIRST then
        exit(IncomingDocumentAttachment.Type = IncomingDocumentAttachment.Type::XML);

      exit(FALSE);
    end;
*/


    
//     procedure FindByDocumentNoAndPostingDate (MainRecordRef@1003 : RecordRef;var IncomingDocument@1006 :
    
/*
procedure FindByDocumentNoAndPostingDate (MainRecordRef: RecordRef;var IncomingDocument: Record 130) : Boolean;
    var
//       SalesInvoiceHeader@1000 :
      SalesInvoiceHeader: Record 112;
//       VATEntry@1002 :
      VATEntry: Record 254;
//       DataTypeManagement@1001 :
      DataTypeManagement: Codeunit 701;
//       DocumentNoFieldRef@1004 :
      DocumentNoFieldRef: FieldRef;
//       PostingDateFieldRef@1005 :
      PostingDateFieldRef: FieldRef;
//       PostingDate@1007 :
      PostingDate: Date;
    begin
      if not DataTypeManagement.FindFieldByName(MainRecordRef,DocumentNoFieldRef,SalesInvoiceHeader.FIELDNAME("No.")) then
        if not DataTypeManagement.FindFieldByName(MainRecordRef,DocumentNoFieldRef,VATEntry.FIELDNAME("Document No.")) then
          exit(FALSE);

      if not DataTypeManagement.FindFieldByName(MainRecordRef,PostingDateFieldRef,SalesInvoiceHeader.FIELDNAME("Posting Date")) then
        exit(FALSE);

      IncomingDocument.SETRANGE("Document No.",FORMAT(DocumentNoFieldRef.VALUE));
      EVALUATE(PostingDate,FORMAT(PostingDateFieldRef.VALUE));
      IncomingDocument.SETRANGE("Posting Date",PostingDate);
      if (FORMAT(DocumentNoFieldRef.VALUE) = '') or (PostingDate = 0D) then
        exit;
      exit(IncomingDocument.FINDFIRST);
    end;
*/


    
//     procedure FindFromIncomingDocumentEntryNo (MainRecordRef@1001 : RecordRef;var IncomingDocument@1000 :
    
/*
procedure FindFromIncomingDocumentEntryNo (MainRecordRef: RecordRef;var IncomingDocument: Record 130) : Boolean;
    var
//       SalesHeader@1008 :
      SalesHeader: Record 36;
//       DataTypeManagement@1006 :
      DataTypeManagement: Codeunit 701;
//       IncomingDocumentEntryNoFieldRef@1002 :
      IncomingDocumentEntryNoFieldRef: FieldRef;
    begin
      if not DataTypeManagement.FindFieldByName(
           MainRecordRef,IncomingDocumentEntryNoFieldRef,SalesHeader.FIELDNAME("Incoming Document Entry No."))
      then
        exit(FALSE);

      exit(IncomingDocument.GET(FORMAT(IncomingDocumentEntryNoFieldRef.VALUE)));
    end;
*/


    
    
/*
procedure GetStatusStyleText () : Text;
    begin
      CASE Status OF
        Status::Rejected,
        Status::Failed:
          exit('Unfavorable');
        else
          exit('Standard');
      end;
    end;

    [Integration(TRUE)]
*/

    
    
/*
procedure OnCheckIncomingDocReleaseRestrictions ()
    begin
    end;

    [Integration(TRUE)]
*/

    
    
/*
procedure OnCheckIncomingDocCreateDocRestrictions ()
    begin
    end;

    [Integration(TRUE)]
*/

    
    
/*
procedure OnCheckIncomingDocSetForOCRRestrictions ()
    begin
    end;
*/


    
    
/*
procedure WaitingToReceiveFromOCR () : Boolean;
    begin
      if "OCR Status" IN ["OCR Status"::Sent,"OCR Status"::"Awaiting Verification"] then
        exit(TRUE);
      exit(FALSE);
    end;
*/


    
    
/*
procedure OCRIsEnabled () : Boolean;
    var
//       OCRServiceSetup@1000 :
      OCRServiceSetup: Record 1270;
    begin
      if not OCRServiceSetup.GET then
        exit(FALSE);
      exit(OCRServiceSetup.Enabled);
    end;
*/


    
    
/*
procedure IsADocumentAttached () : Boolean;
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      if GetURL = '' then
        if IncomingDocumentAttachment.ISEMPTY then
          exit(FALSE);
      exit(TRUE);
    end;
*/


    
    
/*
procedure TestReadyForApproval ()
    begin
      if IsADocumentAttached then
        exit;
      ERROR(NoDocAttachErr);
    end;
*/


    
    
//     procedure OnAfterCreateGenJnlLineFromIncomingDocSuccess (var IncomingDocument@1000 :
    
/*
procedure OnAfterCreateGenJnlLineFromIncomingDocSuccess (var IncomingDocument: Record 130)
    begin
    end;
*/


    
    
//     procedure OnAfterCreateGenJnlLineFromIncomingDocFail (var IncomingDocument@1000 :
    
/*
procedure OnAfterCreateGenJnlLineFromIncomingDocFail (var IncomingDocument: Record 130)
    begin
    end;

    [Integration(TRUE)]
*/

//     LOCAL procedure OnAfterCreateSalesHeaderFromIncomingDoc (var SalesHeader@1000 :
    
/*
LOCAL procedure OnAfterCreateSalesHeaderFromIncomingDoc (var SalesHeader: Record 36)
    begin
    end;

    [Integration(TRUE)]
*/

//     LOCAL procedure OnAfterCreatePurchHeaderFromIncomingDoc (var PurchHeader@1000 :
    
/*
LOCAL procedure OnAfterCreatePurchHeaderFromIncomingDoc (var PurchHeader: Record 38)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterFindPostedRecord (var RelatedRecord@1001 : Variant;var RecordFound@1000 :
    
/*
LOCAL procedure OnAfterFindPostedRecord (var RelatedRecord: Variant;var RecordFound: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterFindUnpostedRecord (var RelatedRecord@1000 : Variant;var RecordFound@1001 :
    
/*
LOCAL procedure OnAfterFindUnpostedRecord (var RelatedRecord: Variant;var RecordFound: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterGetRelatedRecordCaption (var RelatedRecordRef@1000 : RecordRef;var RecCaption@1001 :
    
/*
LOCAL procedure OnAfterGetRelatedRecordCaption (var RelatedRecordRef: RecordRef;var RecCaption: Text)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateDocumentFields (var IncomingDocument@1000 : Record 130;DocExists@1001 :
    
/*
LOCAL procedure OnAfterUpdateDocumentFields (var IncomingDocument: Record 130;DocExists: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnGetDataExchangePath (DataExchLineDef@1000 : Record 1227;FieldNumber@1001 : Integer;var DataExchangePath@1002 :
    
/*
LOCAL procedure OnGetDataExchangePath (DataExchLineDef: Record 1227;FieldNumber: Integer;var DataExchangePath: Text)
    begin
    end;
*/


    
    
/*
procedure HasAttachment () : Boolean;
    var
//       IncomingDocumentAttachment@1000 :
      IncomingDocumentAttachment: Record 133;
    begin
      exit(GetMainAttachment(IncomingDocumentAttachment));
    end;
*/


    
    
/*
procedure CanReplaceMainAttachment () : Boolean;
    begin
      if not HasAttachment then
        exit(TRUE);
      exit(not WasSentToOCR);
    end;
*/


    
/*
LOCAL procedure WasSentToOCR () : Boolean;
    begin
      exit("OCR Status" <> "OCR Status"::" ");
    end;

    /*begin
    end.
  */
}





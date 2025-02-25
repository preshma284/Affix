pageextension 50175 MyExtension344 extends 344//265
{
layout
{


}

actions
{


}

//trigger

//trigger

var
      Text000 : TextConst ENU='The business contact type was not specified.',ESP='No se ha indicado tipo negocio.';
      Text001 : TextConst ENU='There are no posted records with this external document number.',ESP='No existe informaci¢n registrada con el n§ documento externo indicado.';
      Text002 : TextConst ENU='Counting records...',ESP='Contando registros...';
      Text003 : TextConst ENU='Posted Sales Invoice',ESP='Hist¢rico facturas venta';
      Text004 : TextConst ENU='Posted Sales Credit Memo',ESP='Hist¢rico abonos venta';
      Text005 : TextConst ENU='Posted Sales Shipment',ESP='Hist¢rico albaranes venta';
      Text006 : TextConst ENU='Issued Reminder',ESP='Recordatorio emitido';
      Text007 : TextConst ENU='Issued Finance Charge Memo',ESP='Doc. inter‚s emitido';
      Text008 : TextConst ENU='Posted Purchase Invoice',ESP='Hist¢rico facturas compra';
      Text009 : TextConst ENU='Posted Purchase Credit Memo',ESP='Hist¢rico abono compra';
      Text010 : TextConst ENU='Posted Purchase Receipt',ESP='Hist¢rico albaranes compra';
      Text011 : TextConst ENU='The document number has been used more than once.',ESP='El mismo n§ documento se ha utilizado en varios documentos';
      Text012 : TextConst ENU='This combination of document number and posting date has been used more than once.',ESP='La combinaci¢n del n§ documento y fecha registro se ha utilizado m s de una vez.';
      Text013 : TextConst ENU='There are no posted records with this document number.',ESP='No existe informaci¢n registrada con el n§ documento indicado.';
      Text014 : TextConst ENU='There are no posted records with this combination of document number and posting date.',ESP='No existe informaci¢n registrada con esta combinaci¢n de n§ documento y fecha de registro.';
      Text015 : TextConst ENU='The search results in too many external documents. Specify a business contact no.',ESP='El resultado de la b£squeda incluye demasiados documentos externos. Especifique un valor en tipo negocio.';
      Text016 : TextConst ENU='The search results in too many external documents. Use Navigate from the relevant ledger entries.',ESP='El resultado de la b£squeda incluye demasiados documentos. Utilice Navegar desde otros movimientos m s aproximados.';
      Text017 : TextConst ENU='Posted Return Receipt',ESP='Hist¢rico recep. devoluci¢n';
      Text018 : TextConst ENU='Posted Return Shipment',ESP='Hist¢rico env¡o devoluci¢n';
      Text019 : TextConst ENU='Posted Transfer Shipment',ESP='Hist¢rico env¡o transferencia';
      Text020 : TextConst ENU='Posted Transfer Receipt',ESP='Hist¢rico recep. transferencia';
      Text021 : TextConst ENU='Sales Order',ESP='Pedido venta';
      Text022 : TextConst ENU='Sales Invoice',ESP='Factura venta';
      Text023 : TextConst ENU='Sales Return Order',ESP='Devoluci¢n venta';
      Text024 : TextConst ENU='Sales Credit Memo',ESP='Abono venta';
      Text025 : TextConst ENU='Posted Assembly Order',ESP='Pedido de ensamblado registrado';
      sText003 : TextConst ENU='Posted Service Invoice',ESP='Factura servicio registrada (ventas)';
      sText004 : TextConst ENU='Posted Service Credit Memo',ESP='Abono servicio regis. (ventas)';
      sText005 : TextConst ENU='Posted Service Shipment',ESP='Env¡o servicio registrado';
      sText021 : TextConst ENU='Service Order',ESP='Pedido servicio';
      sText022 : TextConst ENU='Service Invoice',ESP='Factura servicio';
      sText024 : TextConst ENU='Service Credit Memo',ESP='Abono servicio';
      Text99000000 : TextConst ENU='Production Order',ESP='Orden producci¢n';
      [SecurityFiltering(SecurityFilter::Filtered)]
      Cust : Record 18 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      Vend : Record 23 ;
      SOSalesHeader : Record 36;
      SISalesHeader : Record 36;
      SROSalesHeader : Record 36;
      SCMSalesHeader : Record 36;
      [SecurityFiltering(SecurityFilter::Filtered)]
      SalesShptHeader : Record 110 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      SalesInvHeader : Record 112 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ReturnRcptHeader : Record 6660 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      SalesCrMemoHeader : Record 114 ;
      SOServHeader : Record 5900;
      SIServHeader : Record 5900;
      SCMServHeader : Record 5900;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ServShptHeader : Record 5990 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ServInvHeader : Record 5992 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ServCrMemoHeader : Record 5994 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      IssuedReminderHeader : Record 297 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      IssuedFinChrgMemoHeader : Record 304 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PurchRcptHeader : Record 120 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PurchInvHeader : Record 122 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ReturnShptHeader : Record 6650 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PurchCrMemoHeader : Record 124 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ProductionOrderHeader : Record 5405 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PostedAssemblyHeader : Record 910 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      TransShptHeader : Record 5744 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      TransRcptHeader : Record 5746 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PostedWhseRcptLine : Record 7319 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PostedWhseShptLine : Record 7323 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      GLEntry : Record 17 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      VATEntry : Record 254 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      CustLedgEntry : Record 21 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      DtldCustLedgEntry : Record 379 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      VendLedgEntry : Record 25 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      DtldVendLedgEntry : Record 380 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      EmplLedgEntry : Record 5222 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      DtldEmplLedgEntry : Record 5223 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ItemLedgEntry : Record 32 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PhysInvtLedgEntry : Record 281 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ResLedgEntry : Record 203 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      JobLedgEntry : Record 169 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      JobWIPEntry : Record 1004 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      JobWIPGLEntry : Record 1005 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ValueEntry : Record 5802 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      BankAccLedgEntry : Record 271 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      CheckLedgEntry : Record 272 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ReminderEntry : Record 300 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      FALedgEntry : Record 5601 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      MaintenanceLedgEntry : Record 5625 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      InsuranceCovLedgEntry : Record 5629 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      CapacityLedgEntry : Record 5832 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ServLedgerEntry : Record 5907 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      WarrantyLedgerEntry : Record 5908 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      WhseEntry : Record 7312 ;
      TempRecordBuffer : Record 6529 TEMPORARY ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      CostEntry : Record 1104 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      IncomingDocument : Record 130 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      NoTaxableEntry : Record 10740 ;
      TextManagement : Codeunit 41;
      ItemTrackingNavigateMgt : Codeunit 6529;
      Window : Dialog;
      DocNoFilter : Text;
      PostingDateFilter : Text;
      NewDocNo : Code[20];
      ContactNo : Code[250];
      ExtDocNo : Code[250];
      NewPostingDate : Date;
      DocType : Text[100];
      SourceType : Text[30];
      SourceNo : Code[20];
      SourceName : Text[50];
      ContactType: Option " ","Vendor","Customer";
      DocExists : Boolean;
      NewSerialNo : Code[50];
      NewLotNo : Code[50];
      SerialNoFilter : Text;
      LotNoFilter : Text;
      [SecurityFiltering(SecurityFilter::Filtered)]
      CarteraDoc : Record 7000002 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PostedCarteraDoc : Record 7000003 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ClosedCarteraDoc : Record 7000004 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PostedBillGr : Record 7000006 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ClosedBillGr : Record 7000007 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      PostedPmtOrd : Record 7000021 ;
      [SecurityFiltering(SecurityFilter::Filtered)]
      ClosedPmtOrd : Record 7000022 ;
      CarteraDocNoFilter : Text[250];
      ShowEnable : Boolean ;
      PrintEnable : Boolean ;
      DocTypeEnable : Boolean ;
      SourceTypeEnable : Boolean ;
      SourceNoEnable : Boolean ;
      SourceNameEnable : Boolean ;
      UpdateForm : Boolean;
      FindBasedOn: Option "Document","Business Contact","Item Reference";
      DocumentVisible : Boolean ;
      BusinessContactVisible : Boolean ;
      ItemReferenceVisible : Boolean ;
      FilterSelectionChangedTxtVisible : Boolean ;
      PageCaptionTxt : TextConst ENU='Selected - %1',ESP='Seleccionado - %1';
      "-------------Quobuilding--------------------" : Integer;
      WorksheetHeaderHist : Record 7207292;
      HistMeasurements : Record 7207338;
      PostCertifications : Record 7207341;
      HistProdMeasureHeader : Record 7207401;
      PostedOutputShipmentHeader : Record 7207310;
      HistReestimationHeader : Record 7207317;
      CostsheetHeaderHist : Record 7207435;
      HistExpenseNotesHeader : Record 7207323;
      PostedHeaTCostsInvoices : Record 7207288;
      HistHeadDelivRetElement : Record 7207359;
      UsageHeaderHist : Record 7207365;
      ActivationHeaderHist : Record 7207370;
      GLEntry2 : Record 17;
      VendLedgEntry2 : Record 25;
      DtlVendorLedgEntry2 : Record 380;
      RentalElements : Record 7207344;
      RentalElementsEntries : Record 7207345;
      JobLedgEntry2 : Record 169;
      QBPageSubscriber : Codeunit 7207349;
      Text025BIS : TextConst ENU='" Generated by Invoice in Expense Notes"',ESP='" Generados por fact. en notas de gasto"';
      QBDetailedJobLedgerEntry : Record 7207328;

    

//procedure
//procedure SetDoc(PostingDate : Date;DocNo : Code[20]);
//    begin
//      NewDocNo := DocNo;
//      NewPostingDate := PostingDate;
//    end;
//Local procedure FindExtRecords();
//    var
      // [SecurityFiltering(SecurityFilter::Filtered)]
//      VendLedgEntry2 : Record 25 ;
//      FoundRecords : Boolean;
//      DateFilter2 : Text;
//      DocNoFilter2 : Text;
//    begin
//      FoundRecords := FALSE;
//      CASE ContactType OF
//        ContactType::Vendor:
//          begin
//            VendLedgEntry2.SETCURRENTKEY("External Document No.");
//            VendLedgEntry2.SETFILTER("External Document No.",ExtDocNo);
//            VendLedgEntry2.SETFILTER("Vendor No.",ContactNo);
//            if ( VendLedgEntry2.FINDSET  )then begin
//              repeat
//                MakeExtFilter(
//                  DateFilter2,
//                  VendLedgEntry2."Posting Date",
//                  DocNoFilter2,
//                  VendLedgEntry2."Document No.");
//              until VendLedgEntry2.NEXT = 0;
//              SetPostingDate(DateFilter2);
//              SetDocNo(DocNoFilter2);
//              FindRecords;
//              FoundRecords := TRUE;
//            end;
//          end;
//        ContactType::Customer:
//          begin
//            Rec.DELETEALL;
//            rec."Entry No." := 0;
//            FindUnpostedSalesDocs(SOSalesHeader."Document Type"::Order,Text021,SOSalesHeader);
//            FindUnpostedSalesDocs(SISalesHeader."Document Type"::Invoice,Text022,SISalesHeader);
//            FindUnpostedSalesDocs(SROSalesHeader."Document Type"::"Return Order",Text023,SROSalesHeader);
//            FindUnpostedSalesDocs(SCMSalesHeader."Document Type"::"Credit Memo",Text024,SCMSalesHeader);
//            if ( SalesShptHeader.READPERMISSION  )then begin
//              SalesShptHeader.RESET;
//              SalesShptHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
//              SalesShptHeader.SETFILTER("Sell-to Customer No.",ContactNo);
//              SalesShptHeader.SETFILTER("External Document No.",ExtDocNo);
//              InsertIntoDocEntry(Rec,DATABASE::"Sales Shipment Header",Enum::"Document Entry Document Type".FromInteger(0),Text005,SalesShptHeader.COUNT);
//            end;
//            if ( SalesInvHeader.READPERMISSION and (CarteraDocNoFilter = '') )then begin
//              SalesInvHeader.RESET;
//              SalesInvHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
//              SalesInvHeader.SETFILTER("Sell-to Customer No.",ContactNo);
//              SalesInvHeader.SETFILTER("External Document No.",ExtDocNo);
//              InsertIntoDocEntry(Rec,DATABASE::"Sales Invoice Header",Enum::"Document Entry Document Type".FromInteger(0),Text003,SalesInvHeader.COUNT);
//            end;
//            if ( ReturnRcptHeader.READPERMISSION  )then begin
//              ReturnRcptHeader.RESET;
//              ReturnRcptHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
//              ReturnRcptHeader.SETFILTER("Sell-to Customer No.",ContactNo);
//              ReturnRcptHeader.SETFILTER("External Document No.",ExtDocNo);
//              InsertIntoDocEntry(Rec,DATABASE::"Return Receipt Header",Enum::"Document Entry Document Type".FromInteger(0),Text017,ReturnRcptHeader.COUNT);
//            end;
//            if ( SalesCrMemoHeader.READPERMISSION and (CarteraDocNoFilter = '') )then begin
//              SalesCrMemoHeader.RESET;
//              SalesCrMemoHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
//              SalesCrMemoHeader.SETFILTER("Sell-to Customer No.",ContactNo);
//              SalesCrMemoHeader.SETFILTER("External Document No.",ExtDocNo);
//              InsertIntoDocEntry(Rec,DATABASE::"Sales Cr.Memo Header",Enum::"Document Entry Document Type".FromInteger(0),Text004,SalesCrMemoHeader.COUNT);
//            end;
//            FindUnpostedServDocs(SOServHeader."Document Type"::Order,sText021,SOServHeader);
//            FindUnpostedServDocs(SIServHeader."Document Type"::Invoice,sText022,SIServHeader);
//            FindUnpostedServDocs(SCMServHeader."Document Type"::"Credit Memo",sText024,SCMServHeader);
//            if ( ServShptHeader.READPERMISSION  )then
//              if ( ExtDocNo = ''  )then begin
//                ServShptHeader.RESET;
//                ServShptHeader.SETCURRENTKEY("Customer No.");
//                ServShptHeader.SETFILTER("Customer No.",ContactNo);
//                InsertIntoDocEntry(Rec,DATABASE::"Service Shipment Header",Enum::"Document Entry Document Type".FromInteger(0),sText005,ServShptHeader.COUNT);
//              end;
//            if ( ServInvHeader.READPERMISSION  )then
//              if ( ExtDocNo = ''  )then begin
//                ServInvHeader.RESET;
//                ServInvHeader.SETCURRENTKEY("Customer No.");
//                ServInvHeader.SETFILTER("Customer No.",ContactNo);
//                InsertIntoDocEntry(Rec,DATABASE::"Service Invoice Header",Enum::"Document Entry Document Type".FromInteger(0),sText003,ServInvHeader.COUNT);
//              end;
//            if ( ServCrMemoHeader.READPERMISSION  )then
//              if ( ExtDocNo = ''  )then begin
//                ServCrMemoHeader.RESET;
//                ServCrMemoHeader.SETCURRENTKEY("Customer No.");
//                ServCrMemoHeader.SETFILTER("Customer No.",ContactNo);
//                InsertIntoDocEntry(Rec,DATABASE::"Service Cr.Memo Header",Enum::"Document Entry Document Type".FromInteger(0),sText004,ServCrMemoHeader.COUNT);
//              end;
//
//            DocExists := Rec.FINDFIRST;
//
//            UpdateFormAfterFindRecords;
//            FoundRecords := DocExists;
//          end;
//        ELSE
//          ERROR(Text000);
//      end;
//
//      if ( not FoundRecords  )then begin
//        SetSource(0D,'','',Enum::"Document Entry Document Type".FromInteger(0),'');
//        MESSAGE(Text001);
//      end;
//    end;
LOCAL procedure FindRecords();
    begin
      Window.OPEN(Text002);
      Rec.RESET;
      Rec.DELETEALL;
      rec."Entry No." := 0;
      FindIncomingDocumentRecords;
      FindEmployeeRecords;
      FindSalesShipmentHeader;
      if ( SalesInvHeader.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        SalesInvHeader.RESET;
        SalesInvHeader.SETFILTER("No.",DocNoFilter);
        SalesInvHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Sales Invoice Header",Enum::"Document Entry Document Type".FromInteger(0),Text003,SalesInvHeader.COUNT);
      end;
      if ( ReturnRcptHeader.READPERMISSION  )then begin
        ReturnRcptHeader.RESET;
        ReturnRcptHeader.SETFILTER("No.",DocNoFilter);
        ReturnRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Return Receipt Header",Enum::"Document Entry Document Type".FromInteger(0),Text017,ReturnRcptHeader.COUNT);
      end;
      if ( SalesCrMemoHeader.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        SalesCrMemoHeader.RESET;
        SalesCrMemoHeader.SETFILTER("No.",DocNoFilter);
        SalesCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Sales Cr.Memo Header",Enum::"Document Entry Document Type".FromInteger(0),Text004,SalesCrMemoHeader.COUNT);
      end;
      if ( ServShptHeader.READPERMISSION  )then begin
        ServShptHeader.RESET;
        ServShptHeader.SETFILTER("No.",DocNoFilter);
        ServShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Service Shipment Header",Enum::"Document Entry Document Type".FromInteger(0),sText005,ServShptHeader.COUNT);
      end;
      if ( ServInvHeader.READPERMISSION  )then begin
        ServInvHeader.RESET;
        ServInvHeader.SETFILTER("No.",DocNoFilter);
        ServInvHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Service Invoice Header",Enum::"Document Entry Document Type".FromInteger(0),sText003,ServInvHeader.COUNT);
      end;
      if ( ServCrMemoHeader.READPERMISSION  )then begin
        ServCrMemoHeader.RESET;
        ServCrMemoHeader.SETFILTER("No.",DocNoFilter);
        ServCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Service Cr.Memo Header",Enum::"Document Entry Document Type".FromInteger(0),sText004,ServCrMemoHeader.COUNT);
      end;
      if ( IssuedReminderHeader.READPERMISSION  )then begin
        IssuedReminderHeader.RESET;
        IssuedReminderHeader.SETFILTER("No.",DocNoFilter);
        IssuedReminderHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Issued Reminder Header",Enum::"Document Entry Document Type".FromInteger(0),Text006,IssuedReminderHeader.COUNT);
      end;
      if ( IssuedFinChrgMemoHeader.READPERMISSION  )then begin
        IssuedFinChrgMemoHeader.RESET;
        IssuedFinChrgMemoHeader.SETFILTER("No.",DocNoFilter);
        IssuedFinChrgMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Issued Fin. Charge Memo Header",Enum::"Document Entry Document Type".FromInteger(0),Text007,
          IssuedFinChrgMemoHeader.COUNT);
      end;
      if ( PurchRcptHeader.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        PurchRcptHeader.RESET;
        PurchRcptHeader.SETFILTER("No.",DocNoFilter);
        PurchRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Purch. Rcpt. Header",Enum::"Document Entry Document Type".FromInteger(0),Text010,PurchRcptHeader.COUNT);
      end;
      if ( PurchInvHeader.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        PurchInvHeader.RESET;
        PurchInvHeader.SETFILTER("No.",DocNoFilter);
        PurchInvHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Purch. Inv. Header",Enum::"Document Entry Document Type".FromInteger(0),Text008,PurchInvHeader.COUNT);
      end;
      if ( ReturnShptHeader.READPERMISSION  )then begin
        ReturnShptHeader.RESET;
        ReturnShptHeader.SETFILTER("No.",DocNoFilter);
        ReturnShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Return Shipment Header",Enum::"Document Entry Document Type".FromInteger(0),Text018,ReturnShptHeader.COUNT);
      end;
      if ( PurchCrMemoHeader.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        PurchCrMemoHeader.RESET;
        PurchCrMemoHeader.SETFILTER("No.",DocNoFilter);
        PurchCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Purch. Cr. Memo Hdr.",Enum::"Document Entry Document Type".FromInteger(0),Text009,PurchCrMemoHeader.COUNT);
      end;
      if ( ProductionOrderHeader.READPERMISSION  )then begin
        ProductionOrderHeader.RESET;
        ProductionOrderHeader.SETRANGE(
          Status,
          ProductionOrderHeader.Status::Released,
          ProductionOrderHeader.Status::Finished);
        ProductionOrderHeader.SETFILTER("No.",DocNoFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Production Order",Enum::"Document Entry Document Type".FromInteger(0),Text99000000,ProductionOrderHeader.COUNT);
      end;
      if ( PostedAssemblyHeader.READPERMISSION  )then begin
        PostedAssemblyHeader.RESET;
        PostedAssemblyHeader.SETFILTER("No.",DocNoFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Posted Assembly Header",Enum::"Document Entry Document Type".FromInteger(0),Text025,PostedAssemblyHeader.COUNT);
      end;
      if ( TransShptHeader.READPERMISSION  )then begin
        TransShptHeader.RESET;
        TransShptHeader.SETFILTER("No.",DocNoFilter);
        TransShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Transfer Shipment Header",Enum::"Document Entry Document Type".FromInteger(0),Text019,TransShptHeader.COUNT);
      end;
      if ( TransRcptHeader.READPERMISSION  )then begin
        TransRcptHeader.RESET;
        TransRcptHeader.SETFILTER("No.",DocNoFilter);
        TransRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Transfer Receipt Header",Enum::"Document Entry Document Type".FromInteger(0),Text020,TransRcptHeader.COUNT);
      end;
      if ( PostedWhseShptLine.READPERMISSION  )then begin
        PostedWhseShptLine.RESET;
        PostedWhseShptLine.SETCURRENTKEY("Posted Source No.","Posting Date");
        PostedWhseShptLine.SETFILTER("Posted Source No.",DocNoFilter);
        PostedWhseShptLine.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Posted Whse. Shipment Line",Enum::"Document Entry Document Type".FromInteger(0),
          PostedWhseShptLine.TABLECAPTION,PostedWhseShptLine.COUNT);
      end;
      if ( PostedWhseRcptLine.READPERMISSION  )then begin
        PostedWhseRcptLine.RESET;
        PostedWhseRcptLine.SETCURRENTKEY("Posted Source No.","Posting Date");
        PostedWhseRcptLine.SETFILTER("Posted Source No.",DocNoFilter);
        PostedWhseRcptLine.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Posted Whse. Receipt Line",Enum::"Document Entry Document Type".FromInteger(0),
          PostedWhseRcptLine.TABLECAPTION,PostedWhseRcptLine.COUNT);
      end;

      // QB -----------------------------------------------------------------------------------------------------------------------------------------------------
      QBPageSubscriber.IncludeQuoBuildingDocumentsPageNavigate(Rec, DocNoFilter,PostingDateFilter,
                                                               WorksheetHeaderHist,HistMeasurements,PostCertifications,HistProdMeasureHeader,
                                                               //JAV 03/04/21: - QB 1.08.32 Se unifican los mov.salida almac‚n obra
                                                               PostedOutputShipmentHeader,
                                                               HistReestimationHeader,CostsheetHeaderHist,HistExpenseNotesHeader,PostedHeaTCostsInvoices,
                                                               HistHeadDelivRetElement,UsageHeaderHist,ActivationHeaderHist, RentalElementsEntries);
      // QB -----------------------------------------------------------------------------------------------------------------------------------------------------

      if ( GLEntry.READPERMISSION  )then begin
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("Document No.","Posting Date");
        GLEntry.SETFILTER("Document No.",DocNoFilter);
        GLEntry.SETFILTER("Bill No.",CarteraDocNoFilter);
        GLEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"G/L Entry",Enum::"Document Entry Document Type".FromInteger(0),GLEntry.TABLECAPTION,GLEntry.COUNT);
      end;

      QBPageSubscriber.ShowGLEntriesFromExpenseNoteCodePageNavigate(Rec, GLEntry2,GLEntry,DocNoFilter,PostingDateFilter); //QB

      if ( VATEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        VATEntry.RESET;
        VATEntry.SETCURRENTKEY("Document No.","Posting Date");
        VATEntry.SETFILTER("Document No.",DocNoFilter);
        VATEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"VAT Entry",Enum::"Document Entry Document Type".FromInteger(0),VATEntry.TABLECAPTION,VATEntry.COUNT);
      end;
      if ( CustLedgEntry.READPERMISSION  )then begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document No.","Document Type");
        CustLedgEntry.SETFILTER("Document No.",DocNoFilter);
        CustLedgEntry.SETFILTER("Bill No.",CarteraDocNoFilter);
        CustLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Cust. Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),CustLedgEntry.TABLECAPTION,CustLedgEntry.COUNT);
        if ( CustLedgEntry.FINDFIRST  )then
          FindCarteraDocs(CarteraDoc.Type::Receivable.AsInteger());
      end;
      if ( DtldCustLedgEntry.READPERMISSION  )then begin
        DtldCustLedgEntry.RESET;
        DtldCustLedgEntry.SETCURRENTKEY("Document No.","Document Type");
        DtldCustLedgEntry.SETFILTER("Document No.",DocNoFilter);
        DtldCustLedgEntry.SETFILTER("Bill No.",CarteraDocNoFilter);
        DtldCustLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Detailed Cust. Ledg. Entry",Enum::"Document Entry Document Type".FromInteger(0),DtldCustLedgEntry.TABLECAPTION,DtldCustLedgEntry.COUNT);
      end;
      if ( ReminderEntry.READPERMISSION  )then begin
        ReminderEntry.RESET;
        ReminderEntry.SETCURRENTKEY(Type,"No.");
        ReminderEntry.SETFILTER("No.",DocNoFilter);
        ReminderEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Reminder/Fin. Charge Entry",Enum::"Document Entry Document Type".FromInteger(0),ReminderEntry.TABLECAPTION,ReminderEntry.COUNT);
      end;
      if ( VendLedgEntry.READPERMISSION  )then begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETFILTER("Document No.",DocNoFilter);
        VendLedgEntry.SETFILTER("Bill No.",CarteraDocNoFilter);
        VendLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Vendor Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),VendLedgEntry.TABLECAPTION,VendLedgEntry.COUNT);
        if ( VendLedgEntry.FINDFIRST  )then
          FindCarteraDocs(CarteraDoc.Type::Payable.AsInteger());
      end;

      QBPageSubscriber.ShowVendorLedgEntriesFromExpenseNoteCodePageNavigate(Rec, VendLedgEntry2,DocNoFilter,PostingDateFilter); //QB

      if ( DtldVendLedgEntry.READPERMISSION  )then begin
        DtldVendLedgEntry.RESET;
        DtldVendLedgEntry.SETCURRENTKEY("Document No.");
        DtldVendLedgEntry.SETFILTER("Document No.",DocNoFilter);
        DtldVendLedgEntry.SETFILTER("Bill No.",CarteraDocNoFilter);
        DtldVendLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Detailed Vendor Ledg. Entry",Enum::"Document Entry Document Type".FromInteger(0),DtldVendLedgEntry.TABLECAPTION,DtldVendLedgEntry.COUNT);
      end;

      QBPageSubscriber.ShowDtlVendorLedgEntriesFromExpenseNoteCodePageNavigate(Rec, DtlVendorLedgEntry2,DocNoFilter,PostingDateFilter); //QB

      if ( ItemLedgEntry.READPERMISSION  )then begin
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Document No.");
        ItemLedgEntry.SETFILTER("Document No.",DocNoFilter);
        ItemLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Item Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),ItemLedgEntry.TABLECAPTION,ItemLedgEntry.COUNT);
      end;
      if ( ValueEntry.READPERMISSION  )then begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETFILTER("Document No.",DocNoFilter);
        ValueEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Value Entry",Enum::"Document Entry Document Type".FromInteger(0),ValueEntry.TABLECAPTION,ValueEntry.COUNT);
      end;
      if ( PhysInvtLedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        PhysInvtLedgEntry.RESET;
        PhysInvtLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        PhysInvtLedgEntry.SETFILTER("Document No.",DocNoFilter);
        PhysInvtLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Phys. Inventory Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),PhysInvtLedgEntry.TABLECAPTION,PhysInvtLedgEntry.COUNT);
      end;
      if ( ResLedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        ResLedgEntry.RESET;
        ResLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        ResLedgEntry.SETFILTER("Document No.",DocNoFilter);
        ResLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Res. Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),ResLedgEntry.TABLECAPTION,ResLedgEntry.COUNT);
      end;
      FindJobRecords;
      if ( BankAccLedgEntry.READPERMISSION  )then begin
        BankAccLedgEntry.RESET;
        BankAccLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        BankAccLedgEntry.SETFILTER("Document No.",DocNoFilter);
        BankAccLedgEntry.SETFILTER("Bill No.",CarteraDocNoFilter);
        BankAccLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Bank Account Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry.COUNT);
      end;
      if ( CheckLedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        CheckLedgEntry.SETFILTER("Document No.",DocNoFilter);
        CheckLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Check Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),CheckLedgEntry.TABLECAPTION,CheckLedgEntry.COUNT);
      end;
      if ( FALedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        FALedgEntry.RESET;
        FALedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        FALedgEntry.SETFILTER("Document No.",DocNoFilter);
        FALedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"FA Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),FALedgEntry.TABLECAPTION,FALedgEntry.COUNT);
      end;
      if ( MaintenanceLedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        MaintenanceLedgEntry.RESET;
        MaintenanceLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        MaintenanceLedgEntry.SETFILTER("Document No.",DocNoFilter);
        MaintenanceLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Maintenance Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry.COUNT);
      end;
      if ( InsuranceCovLedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        InsuranceCovLedgEntry.RESET;
        InsuranceCovLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        InsuranceCovLedgEntry.SETFILTER("Document No.",DocNoFilter);
        InsuranceCovLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          Rec,DATABASE::"Ins. Coverage Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),InsuranceCovLedgEntry.TABLECAPTION,InsuranceCovLedgEntry.COUNT);
      end;
      if ( CapacityLedgEntry.READPERMISSION  )then begin
        CapacityLedgEntry.RESET;
        CapacityLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        CapacityLedgEntry.SETFILTER("Document No.",DocNoFilter);
        CapacityLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Capacity Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),CapacityLedgEntry.TABLECAPTION,CapacityLedgEntry.COUNT);
      end;
      if ( WhseEntry.READPERMISSION  )then begin
        WhseEntry.RESET;
        WhseEntry.SETCURRENTKEY("Reference No.","Registering Date");
        WhseEntry.SETFILTER("Reference No.",DocNoFilter);
        WhseEntry.SETFILTER("Registering Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Warehouse Entry",Enum::"Document Entry Document Type".FromInteger(0),WhseEntry.TABLECAPTION,WhseEntry.COUNT);
      end;

      if ( ServLedgerEntry.READPERMISSION  )then begin
        ServLedgerEntry.RESET;
        ServLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
        ServLedgerEntry.SETFILTER("Document No.",DocNoFilter);
        ServLedgerEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Service Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),ServLedgerEntry.TABLECAPTION,ServLedgerEntry.COUNT);
      end;
      if ( WarrantyLedgerEntry.READPERMISSION  )then begin
        WarrantyLedgerEntry.RESET;
        WarrantyLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
        WarrantyLedgerEntry.SETFILTER("Document No.",DocNoFilter);
        WarrantyLedgerEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Warranty Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),WarrantyLedgerEntry.TABLECAPTION,WarrantyLedgerEntry.COUNT);
      end;

      if ( CostEntry.READPERMISSION  )then begin
        CostEntry.RESET;
        CostEntry.SETCURRENTKEY("Document No.","Posting Date");
        CostEntry.SETFILTER("Document No.",DocNoFilter);
        CostEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Cost Entry",Enum::"Document Entry Document Type".FromInteger(0),CostEntry.TABLECAPTION,CostEntry.COUNT);
      end;

      if ( PostedBillGr.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        PostedBillGr.RESET;
        PostedBillGr.SETCURRENTKEY("No.");
        PostedBillGr.SETFILTER("No.",DocNoFilter);
        PostedBillGr.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Posted Bill Group",Enum::"Document Entry Document Type".FromInteger(0),PostedBillGr.TABLECAPTION,PostedBillGr.COUNT);
      end;
      if ( ClosedBillGr.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        ClosedBillGr.RESET;
        ClosedBillGr.SETCURRENTKEY("No.");
        ClosedBillGr.SETFILTER("No.",DocNoFilter);
        ClosedBillGr.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Closed Bill Group",Enum::"Document Entry Document Type".FromInteger(0),ClosedBillGr.TABLECAPTION,ClosedBillGr.COUNT);
      end;
      if ( PostedPmtOrd.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        PostedPmtOrd.RESET;
        PostedPmtOrd.SETCURRENTKEY("No.");
        PostedPmtOrd.SETFILTER("No.",DocNoFilter);
        PostedPmtOrd.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Posted Payment Order",Enum::"Document Entry Document Type".FromInteger(0),PostedPmtOrd.TABLECAPTION,PostedPmtOrd.COUNT);
      end;
      if ( ClosedPmtOrd.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        ClosedPmtOrd.RESET;
        ClosedPmtOrd.SETCURRENTKEY("No.");
        ClosedPmtOrd.SETFILTER("No.",DocNoFilter);
        ClosedPmtOrd.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Closed Payment Order",Enum::"Document Entry Document Type".FromInteger(0),ClosedPmtOrd.TABLECAPTION,ClosedPmtOrd.COUNT);
      end;

      OnAfterNavigateFindRecords(Rec,DocNoFilter,PostingDateFilter);
      DocExists := Rec.FINDFIRST;

      SetSource(0D,'','',0,'');
      if ( DocExists  )then begin

        if ( GetDocumentCount <= 1  )then begin
          // Service Management
          if ( NoOfRecords(DATABASE::"Service Ledger Entry") = 1  )then begin
            ServLedgerEntry.FINDFIRST;
            if ( ServLedgerEntry.Type = ServLedgerEntry.Type::"Service Contract"  )then
              SetSource(
                ServLedgerEntry."Posting Date",FORMAT(ServLedgerEntry."Document Type"),ServLedgerEntry."Document No.",
                2,ServLedgerEntry."Service Contract No.")
            ELSE
              SetSource(
                ServLedgerEntry."Posting Date",FORMAT(ServLedgerEntry."Document Type"),ServLedgerEntry."Document No.",
                2,ServLedgerEntry."Service Order No.")
          end;
          if ( NoOfRecords(DATABASE::"Warranty Ledger Entry") = 1  )then begin
            WarrantyLedgerEntry.FINDFIRST;
            SetSource(
              WarrantyLedgerEntry."Posting Date",'',WarrantyLedgerEntry."Document No.",
              2,WarrantyLedgerEntry."Service Order No.")
          end;

          // Sales
          if ( NoOfRecords(DATABASE::"Cust. Ledger Entry") = 1  )then begin
            CustLedgEntry.FINDFIRST;
            SetSource(
              CustLedgEntry."Posting Date",FORMAT(CustLedgEntry."Document Type"),CustLedgEntry."Document No.",
              1,CustLedgEntry."Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Detailed Cust. Ledg. Entry") = 1  )then begin
            DtldCustLedgEntry.FINDFIRST;
            SetSource(
              DtldCustLedgEntry."Posting Date",FORMAT(DtldCustLedgEntry."Document Type"),DtldCustLedgEntry."Document No.",
              1,DtldCustLedgEntry."Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Sales Invoice Header") = 1  )then begin
            SalesInvHeader.FINDFIRST;
            SetSource(
              SalesInvHeader."Posting Date",FORMAT(rec."Table Name"),SalesInvHeader."No.",
              1,SalesInvHeader."Bill-to Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Sales Cr.Memo Header") = 1  )then begin
            SalesCrMemoHeader.FINDFIRST;
            SetSource(
              SalesCrMemoHeader."Posting Date",FORMAT(rec."Table Name"),SalesCrMemoHeader."No.",
              1,SalesCrMemoHeader."Bill-to Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Return Receipt Header") = 1  )then begin
            ReturnRcptHeader.FINDFIRST;
            SetSource(
              ReturnRcptHeader."Posting Date",FORMAT(rec."Table Name"),ReturnRcptHeader."No.",
              1,ReturnRcptHeader."Sell-to Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Sales Shipment Header") = 1  )then begin
            SalesShptHeader.FINDFIRST;
            SetSource(
              SalesShptHeader."Posting Date",FORMAT(rec."Table Name"),SalesShptHeader."No.",
              1,SalesShptHeader."Sell-to Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Posted Whse. Shipment Line") = 1  )then begin
            PostedWhseShptLine.FINDFIRST;
            SetSource(
              PostedWhseShptLine."Posting Date",FORMAT(rec."Table Name"),PostedWhseShptLine."Posted Source No.",
              1,PostedWhseShptLine."Destination No.");
          end;
          if ( NoOfRecords(DATABASE::"Issued Reminder Header") = 1  )then begin
            IssuedReminderHeader.FINDFIRST;
            SetSource(
              IssuedReminderHeader."Posting Date",FORMAT(rec."Table Name"),IssuedReminderHeader."No.",
              1,IssuedReminderHeader."Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") = 1  )then begin
            IssuedFinChrgMemoHeader.FINDFIRST;
            SetSource(
              IssuedFinChrgMemoHeader."Posting Date",FORMAT(rec."Table Name"),IssuedFinChrgMemoHeader."No.",
              1,IssuedFinChrgMemoHeader."Customer No.");
          end;

          if ( NoOfRecords(DATABASE::"Service Invoice Header") = 1  )then begin
            ServInvHeader.FINDFIRST;
            SetSource(
              ServInvHeader."Posting Date",FORMAT(rec."Table Name"),ServInvHeader."No.",
              1,ServInvHeader."Bill-to Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Service Cr.Memo Header") = 1  )then begin
            ServCrMemoHeader.FINDFIRST;
            SetSource(
              ServCrMemoHeader."Posting Date",FORMAT(rec."Table Name"),ServCrMemoHeader."No.",
              1,ServCrMemoHeader."Bill-to Customer No.");
          end;
          if ( NoOfRecords(DATABASE::"Service Shipment Header") = 1  )then begin
            ServShptHeader.FINDFIRST;
            SetSource(
              ServShptHeader."Posting Date",FORMAT(rec."Table Name"),ServShptHeader."No.",
              1,ServShptHeader."Customer No.");
          end;

          // Purchase
          if ( NoOfRecords(DATABASE::"Vendor Ledger Entry") = 1  )then begin
            if ( VendLedgEntry.FINDFIRST  )then //QB
            SetSource(
              VendLedgEntry."Posting Date",FORMAT(VendLedgEntry."Document Type"),VendLedgEntry."Document No.",
              2,VendLedgEntry."Vendor No.");
              QBPageSubscriber.VendorLedgerEntrySetSourcePageNavigate(VendLedgEntry2); //QB
          end;
          if ( NoOfRecords(DATABASE::"Detailed Vendor Ledg. Entry") = 1  )then begin
            if ( DtldVendLedgEntry.FINDFIRST  )then //QB
            SetSource(
              DtldVendLedgEntry."Posting Date",FORMAT(DtldVendLedgEntry."Document Type"),DtldVendLedgEntry."Document No.",
              2,DtldVendLedgEntry."Vendor No.");
              QBPageSubscriber.DtlVendorLedgerEntrySetSourcePageNavigate(DtlVendorLedgEntry2); //QB
          end;
          if ( NoOfRecords(DATABASE::"Purch. Inv. Header") = 1  )then begin
            PurchInvHeader.FINDFIRST;
            SetSource(
              PurchInvHeader."Posting Date",FORMAT(rec."Table Name"),PurchInvHeader."No.",
              2,PurchInvHeader."Pay-to Vendor No.");
          end;
          if ( NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") = 1  )then begin
            PurchCrMemoHeader.FINDFIRST;
            SetSource(
              PurchCrMemoHeader."Posting Date",FORMAT(rec."Table Name"),PurchCrMemoHeader."No.",
              2,PurchCrMemoHeader."Pay-to Vendor No.");
          end;
          if ( NoOfRecords(DATABASE::"Return Shipment Header") = 1  )then begin
            ReturnShptHeader.FINDFIRST;
            SetSource(
              ReturnShptHeader."Posting Date",FORMAT(rec."Table Name"),ReturnShptHeader."No.",
              2,ReturnShptHeader."Buy-from Vendor No.");
          end;
          if ( NoOfRecords(DATABASE::"Purch. Rcpt. Header") = 1  )then begin
            PurchRcptHeader.FINDFIRST;
            SetSource(
              PurchRcptHeader."Posting Date",FORMAT(rec."Table Name"),PurchRcptHeader."No.",
              2,PurchRcptHeader."Buy-from Vendor No.");
          end;
          if ( NoOfRecords(DATABASE::"Posted Whse. Receipt Line") = 1  )then begin
            PostedWhseRcptLine.FINDFIRST;
            SetSource(
              PostedWhseRcptLine."Posting Date",FORMAT(rec."Table Name"),PostedWhseRcptLine."Posted Source No.",
              2,'');

          QBPageSubscriber.RentalElementEntriesSetSourcePageNavigate(RentalElementsEntries);  //QB

          end;
        end ELSE begin
          if ( DocNoFilter <> ''  )then
            if ( PostingDateFilter = ''  )then
              MESSAGE(Text011)
            ELSE
              MESSAGE(Text012);
        end;
      end ELSE
        if ( PostingDateFilter = ''  )then
          MESSAGE(Text013)
        ELSE
          MESSAGE(Text014);

      if ( UpdateForm  )then
        UpdateFormAfterFindRecords;
      Window.CLOSE;
    end;
LOCAL procedure FindJobRecords();
    begin
      if ( JobLedgEntry.READPERMISSION and (CarteraDocNoFilter = '')  )then begin
        JobLedgEntry.RESET;
        JobLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        JobLedgEntry.SETFILTER("Document No.",DocNoFilter);
        JobLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Job Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),JobLedgEntry.TABLECAPTION,JobLedgEntry.COUNT);
      end;

      //QB --------------
      QBPageSubscriber.ShowJobLedgerEntryFromExpenseNoteCodePageNavigate(Rec, JobLedgEntry2,DocNoFilter,PostingDateFilter,CarteraDocNoFilter); //QB
      QBPageSubscriber.ShowDetailedJobLedgEntriesPageNavigate(Rec, QBDetailedJobLedgerEntry, DocNoFilter, PostingDateFilter); //QB
      //QB --------------

      if ( JobWIPEntry.READPERMISSION  )then begin
        JobWIPEntry.RESET;
        JobWIPEntry.SETFILTER("Document No.",DocNoFilter);
        JobWIPEntry.SETFILTER("WIP Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Job WIP Entry",Enum::"Document Entry Document Type".FromInteger(0),JobWIPEntry.TABLECAPTION,JobWIPEntry.COUNT);
      end;
      if ( JobWIPGLEntry.READPERMISSION  )then begin
        JobWIPGLEntry.RESET;
        JobWIPGLEntry.SETCURRENTKEY("Document No.","Posting Date");
        JobWIPGLEntry.SETFILTER("Document No.",DocNoFilter);
        JobWIPGLEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(Rec,DATABASE::"Job WIP G/L Entry",Enum::"Document Entry Document Type".FromInteger(0),JobWIPGLEntry.TABLECAPTION,JobWIPGLEntry.COUNT);
      end;
    end;
Local procedure FindIncomingDocumentRecords();
   begin
     if ( IncomingDocument.READPERMISSION  )then begin
       IncomingDocument.RESET;
       IncomingDocument.SETFILTER("Document No.",DocNoFilter);
       IncomingDocument.SETFILTER("Posting Date",PostingDateFilter);
       InsertIntoDocEntry(Rec,DATABASE::"Incoming Document",Enum::"Document Entry Document Type".FromInteger(0),IncomingDocument.TABLECAPTION,IncomingDocument.COUNT);
     end;
   end;
Local procedure FindSalesShipmentHeader();
   begin
     if ( SalesShptHeader.READPERMISSION  )then begin
       SalesShptHeader.RESET;
       SalesShptHeader.SETFILTER("No.",DocNoFilter);
       SalesShptHeader.SETFILTER("Posting Date",PostingDateFilter);
       InsertIntoDocEntry(Rec,DATABASE::"Sales Shipment Header",Enum::"Document Entry Document Type".FromInteger(0),Text005,SalesShptHeader.COUNT);
     end;
   end;
Local procedure FindEmployeeRecords();
   begin
     if ( EmplLedgEntry.READPERMISSION  )then begin
       EmplLedgEntry.RESET;
       EmplLedgEntry.SETCURRENTKEY("Document No.");
       EmplLedgEntry.SETFILTER("Document No.",DocNoFilter);
       EmplLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
       InsertIntoDocEntry(Rec,DATABASE::"Employee Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),EmplLedgEntry.TABLECAPTION,EmplLedgEntry.COUNT);
     end;
     if ( DtldEmplLedgEntry.READPERMISSION  )then begin
       DtldEmplLedgEntry.RESET;
       DtldEmplLedgEntry.SETCURRENTKEY("Document No.");
       DtldEmplLedgEntry.SETFILTER("Document No.",DocNoFilter);
       DtldEmplLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
       InsertIntoDocEntry(Rec,DATABASE::"Detailed Employee Ledger Entry",Enum::"Document Entry Document Type".FromInteger(0),DtldEmplLedgEntry.TABLECAPTION,DtldEmplLedgEntry.COUNT);
     end;
   end;
Local procedure UpdateFormAfterFindRecords();
   begin
     OnBeforeUpdateFormAfterFindRecords;

     ShowEnable := DocExists;
     PrintEnable := DocExists;
     CurrPage.UPDATE(FALSE);
     DocExists := Rec.FINDFIRST;
     if ( DocExists  )then;
   end;
//
//    //[External]
//procedure InsertIntoDocEntry(var TempDocumentEntry : Record 265 TEMPORARY ;DocTableID : Integer;DocType : Option;DocTableName : Text[1024];DocNoOfRecords : Integer);
//    begin
//      if ( DocNoOfRecords = 0  )then
//        exit;
//
//      WITH TempDocumentEntry DO begin
//        Rec.INIT;
//        rec."Entry No." := rec."Entry No." + 1;
//        rec."Table ID" := DocTableID;
//        rec."Document Type" := DocType;
//        rec."Table Name" := COPYSTR(DocTableName,1,MAXSTRLEN(rec."Table Name"));
//        rec."No. of Records" := DocNoOfRecords;
//        Rec.INSERT;
//      end;
//    end;
LOCAL procedure NoOfRecords(TableID : Integer) : Integer;
    begin
      Rec.SETRANGE("Table ID",TableID);
      if ( not Rec.FINDFIRST  )then
        Rec.INIT;
      Rec.SETRANGE("Table ID");
      exit(rec."No. of Records");
    end;
LOCAL procedure SetSource(PostingDate : Date;DocType2 : Text[100];DocNo : Text[50];SourceType2 : Integer;SourceNo2 : Code[20]);
    begin
      if ( SourceType2 = 0  )then begin
        DocType := '';
        SourceType := '';
        SourceNo := '';
        SourceName := '';
      end ELSE begin
        DocType := DocType2;
        SourceNo := SourceNo2;
        Rec.SETRANGE("Document No.",DocNo);
        Rec.SETRANGE("Posting Date",PostingDate);
        DocNoFilter := Rec.GETFILTER("Document No.");
        PostingDateFilter := Rec.GETFILTER("Posting Date");
        CASE SourceType2 OF
          1:
            begin
              SourceType := Cust.TABLECAPTION;
              if ( not Cust.GET(SourceNo)  )then
                Cust.INIT;
              SourceName := Cust.Name;
            end;
          2:
            begin
              SourceType := Vend.TABLECAPTION;
              if ( not Vend.GET(SourceNo)  )then
                Vend.INIT;
              SourceName := Vend.Name;
            end;
        end;
      end;
      DocTypeEnable := SourceType2 <> 0;
      SourceTypeEnable := SourceType2 <> 0;
      SourceNoEnable := SourceType2 <> 0;
      SourceNameEnable := SourceType2 <> 0;
    end;
LOCAL procedure ShowRecords();
    var
      IsHandled : Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeNavigateShowRecords(rec."Table ID",DocNoFilter,PostingDateFilter,ItemTrackingSearch,Rec,IsHandled);
      if ( IsHandled  )then
        exit;

      if ( ItemTrackingSearch  )then
        ItemTrackingNavigateMgt.Show(rec."Table ID")
      ELSE
        CASE rec."Table ID" OF
          DATABASE::"Incoming Document":
            PAGE.RUN(PAGE::"Incoming Document",IncomingDocument);
          DATABASE::"Sales Header":
            ShowSalesHeaderRecords;
          DATABASE::"Sales Invoice Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Sales Invoices",SalesInvHeader);
          DATABASE::"Sales Cr.Memo Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Sales Credit Memos",SalesCrMemoHeader);
          DATABASE::"Return Receipt Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Return Receipt",ReturnRcptHeader)
            ELSE
              PAGE.RUN(0,ReturnRcptHeader);
          DATABASE::"Sales Shipment Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Sales Shipment",SalesShptHeader)
            ELSE
              PAGE.RUN(0,SalesShptHeader);
          DATABASE::"Issued Reminder Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Issued Reminder",IssuedReminderHeader)
            ELSE
              PAGE.RUN(0,IssuedReminderHeader);
          DATABASE::"Issued Fin. Charge Memo Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Issued Finance Charge Memo",IssuedFinChrgMemoHeader)
            ELSE
              PAGE.RUN(0,IssuedFinChrgMemoHeader);
          DATABASE::"Purch. Inv. Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Purchase Invoices",PurchInvHeader);
          DATABASE::"Purch. Cr. Memo Hdr.":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Purchase Credit Memos",PurchCrMemoHeader);
          DATABASE::"Return Shipment Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Return Shipment",ReturnShptHeader)
            ELSE
              PAGE.RUN(0,ReturnShptHeader);
          DATABASE::"Purch. Rcpt. Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
            ELSE
              PAGE.RUN(0,PurchRcptHeader);
          DATABASE::"Production Order":
            PAGE.RUN(0,ProductionOrderHeader);
          DATABASE::"Posted Assembly Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Assembly Order",PostedAssemblyHeader)
            ELSE
              PAGE.RUN(0,PostedAssemblyHeader);
          DATABASE::"Transfer Shipment Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Transfer Shipment",TransShptHeader)
            ELSE
              PAGE.RUN(0,TransShptHeader);
          DATABASE::"Transfer Receipt Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Transfer Receipt",TransRcptHeader)
            ELSE
              PAGE.RUN(0,TransRcptHeader);
          //QB++
          DATABASE::"Worksheet Header Hist.":         PAGE.RUN(0, WorksheetHeaderHist);
          DATABASE::"Hist. Measurements":             PAGE.RUN(0, HistMeasurements);
          DATABASE::"Hist. Prod. Measure Header":     PAGE.RUN(0, HistProdMeasureHeader);
          DATABASE::"Post. Certifications":           PAGE.RUN(0, PostCertifications);
          DATABASE::"Posted Output Shipment Header":  PAGE.RUN(0, PostedOutputShipmentHeader);    //JAV 03/04/21: - QB 1.08.32 Se unifican las salidas almac‚n obra
          DATABASE::"Hist. Reestimation Header":      PAGE.RUN(0, HistReestimationHeader);
          DATABASE::"Costsheet Header Hist.":         PAGE.RUN(0, CostsheetHeaderHist);
          DATABASE::"Tran. Between Jobs Post Header": PAGE.RUN(0, PostedHeaTCostsInvoices);
          DATABASE::"Hist. Expense Notes Header":     PAGE.RUN(0, HistExpenseNotesHeader);
          DATABASE::"Hist. Head. Deliv/Ret. Element": PAGE.RUN(0, HistHeadDelivRetElement);
          DATABASE::"Usage Header Hist.":             PAGE.RUN(0, UsageHeaderHist);
          DATABASE::"Activation Header Hist.":        PAGE.RUN(0, ActivationHeaderHist);
          DATABASE::"QB Detailed Job Ledger Entry" :  PAGE.RUN(0, QBDetailedJobLedgerEntry);
         //QB--

          DATABASE::"Posted Whse. Shipment Line":
            PAGE.RUN(0,PostedWhseShptLine);
          DATABASE::"Posted Whse. Receipt Line":
            PAGE.RUN(0,PostedWhseRcptLine);
          DATABASE::"G/L Entry":
            QBPageSubscriber.RunGLEntryPageNavigate(GLEntry,GLEntry2,Rec);  //QB
          DATABASE::"VAT Entry":
            PAGE.RUN(0,VATEntry);
          DATABASE::"Rental Elements Entries":
            PAGE.RUN(0,RentalElementsEntries);//QB
          DATABASE::"Detailed Cust. Ledg. Entry":
            PAGE.RUN(0,DtldCustLedgEntry);
          DATABASE::"Cust. Ledger Entry":
            PAGE.RUN(0,CustLedgEntry);
          DATABASE::"Reminder/Fin. Charge Entry":
            PAGE.RUN(0,ReminderEntry);
          DATABASE::"Vendor Ledger Entry":
            QBPageSubscriber.RunVendLedgEntryPageNavigate(VendLedgEntry,VendLedgEntry2,Rec);  //QB
          DATABASE::"Detailed Vendor Ledg. Entry":
            // +QB
            QBPageSubscriber.RunDtldVendorLedgEntryPageNavigate(DtldVendLedgEntry,DtlVendorLedgEntry2,Rec);
            //PAGE.RUN(0,DtldVendLedgEntry);
            // -QB
          DATABASE::"Employee Ledger Entry":
            ShowEmployeeLedgerEntries;
          DATABASE::"Detailed Employee Ledger Entry":
            ShowDetailedEmployeeLedgerEntries;
          DATABASE::"Item Ledger Entry":
            PAGE.RUN(0,ItemLedgEntry);
          DATABASE::"Value Entry":
            PAGE.RUN(0,ValueEntry);
          DATABASE::"Phys. Inventory Ledger Entry":
            PAGE.RUN(0,PhysInvtLedgEntry);
          DATABASE::"Res. Ledger Entry":
            PAGE.RUN(0,ResLedgEntry);
          DATABASE::"Job Ledger Entry":
            QBPageSubscriber.RunGLJobLedgerEntryNavigate(JobLedgEntry,JobLedgEntry2,Rec);  //QB
          DATABASE::"Job WIP Entry":
            PAGE.RUN(0,JobWIPEntry);
          DATABASE::"Job WIP G/L Entry":
            PAGE.RUN(0,JobWIPGLEntry);
          DATABASE::"Bank Account Ledger Entry":
            PAGE.RUN(0,BankAccLedgEntry);
          DATABASE::"Check Ledger Entry":
            PAGE.RUN(0,CheckLedgEntry);
          DATABASE::"FA Ledger Entry":
            PAGE.RUN(0,FALedgEntry);
          DATABASE::"Maintenance Ledger Entry":
            PAGE.RUN(0,MaintenanceLedgEntry);
          DATABASE::"Ins. Coverage Ledger Entry":
            PAGE.RUN(0,InsuranceCovLedgEntry);
          DATABASE::"Capacity Ledger Entry":
            PAGE.RUN(0,CapacityLedgEntry);
          DATABASE::"Warehouse Entry":
            PAGE.RUN(0,WhseEntry);
          DATABASE::"Service Header":
            ShowServiceHeaderRecords;
          DATABASE::"Service Invoice Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Service Invoice",ServInvHeader)
            ELSE
              PAGE.RUN(0,ServInvHeader);
          DATABASE::"Service Cr.Memo Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Service Credit Memo",ServCrMemoHeader)
            ELSE
              PAGE.RUN(0,ServCrMemoHeader);
          DATABASE::"Service Shipment Header":
            if ( rec."No. of Records" = 1  )then
              PAGE.RUN(PAGE::"Posted Service Shipment",ServShptHeader)
            ELSE
              PAGE.RUN(0,ServShptHeader);
          DATABASE::"Service Ledger Entry":
            PAGE.RUN(0,ServLedgerEntry);
          DATABASE::"Warranty Ledger Entry":
            PAGE.RUN(0,WarrantyLedgerEntry);
          DATABASE::"Cost Entry":
            PAGE.RUN(0,CostEntry);
          DATABASE::"Cartera Doc.":
            PAGE.RUN(0,CarteraDoc);
          DATABASE::"Posted Cartera Doc.":
            PAGE.RUN(0,PostedCarteraDoc);
          DATABASE::"Closed Cartera Doc.":
            PAGE.RUN(0,ClosedCarteraDoc);
          DATABASE::"Posted Bill Group":
            PAGE.RUN(0,PostedBillGr);
          DATABASE::"Closed Bill Group":
            PAGE.RUN(0,ClosedBillGr);
          DATABASE::"Posted Payment Order":
            PAGE.RUN(0,PostedPmtOrd);
          DATABASE::"Closed Payment Order":
            PAGE.RUN(0,ClosedPmtOrd);
        end;

      OnAfterNavigateShowRecords(rec."Table ID",DocNoFilter,PostingDateFilter,ItemTrackingSearch,Rec);
    end;
Local procedure ShowSalesHeaderRecords();
   begin
     Rec.TESTfield("Table ID",DATABASE::"Sales Header");

     CASE rec."Document Type" OF
       rec."Document Type"::Order:
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Sales Order",SOSalesHeader)
         ELSE
           PAGE.RUN(0,SOSalesHeader);
       rec."Document Type"::Invoice:
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Sales Invoice",SISalesHeader)
         ELSE
           PAGE.RUN(0,SISalesHeader);
       rec."Document Type"::"Return Order":
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Sales Return Order",SROSalesHeader)
         ELSE
           PAGE.RUN(0,SROSalesHeader);
       rec."Document Type"::"Credit Memo":
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Sales Credit Memo",SCMSalesHeader)
         ELSE
           PAGE.RUN(0,SCMSalesHeader);
     end;
   end;
Local procedure ShowServiceHeaderRecords();
   begin
     Rec.TESTfield("Table ID",DATABASE::"Service Header");

     CASE rec."Document Type" OF
       rec."Document Type"::Order:
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Service Order",SOServHeader)
         ELSE
           PAGE.RUN(0,SOServHeader);
       rec."Document Type"::Invoice:
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Service Invoice",SIServHeader)
         ELSE
           PAGE.RUN(0,SIServHeader);
       rec."Document Type"::"Credit Memo":
         if ( rec."No. of Records" = 1  )then
           PAGE.RUN(PAGE::"Service Credit Memo",SCMServHeader)
         ELSE
           PAGE.RUN(0,SCMServHeader);
     end;
   end;
Local procedure ShowEmployeeLedgerEntries();
   begin
     PAGE.RUN(PAGE::"Employee Ledger Entries",EmplLedgEntry);
   end;
Local procedure ShowDetailedEmployeeLedgerEntries();
   begin
     PAGE.RUN(PAGE::"Detailed Empl. Ledger Entries",DtldEmplLedgEntry);
   end;
//Local procedure SetPostingDate(PostingDate : Text);
//    begin
//      TextManagement.MakeDateFilter(PostingDate);
//      Rec.SETFILTER("Posting Date",PostingDate);
//      PostingDateFilter := Rec.GETFILTER("Posting Date");
//    end;
//Local procedure SetDocNo(DocNo : Text);
//    begin
//      Rec.SETFILTER("Document No.",DocNo);
//      DocNoFilter := Rec.GETFILTER("Document No.");
//      PostingDateFilter := Rec.GETFILTER("Posting Date");
//    end;
//Local procedure ClearSourceInfo();
//    begin
//      if ( DocExists  )then begin
//        DocExists := FALSE;
//        Rec.DELETEALL;
//        ShowEnable := FALSE;
//        SetSource(0D,'','',Enum::"Document Entry Document Type".FromInteger(0),'');
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure MakeExtFilter(var DateFilter : Text;AddDate : Date;var DocNoFilter : Text;AddDocNo : Code[20]);
//    begin
//      if ( DateFilter = ''  )then
//        DateFilter := FORMAT(AddDate)
//      ELSE
//        if ( STRPOS(DateFilter,FORMAT(AddDate)) = 0  )then
//          if ( MAXSTRLEN(DateFilter) >= STRLEN(DateFilter + '|' + FORMAT(AddDate))  )then
//            DateFilter := DateFilter + '|' + FORMAT(AddDate)
//          ELSE
//            TooLongFilter;
//
//      if ( DocNoFilter = ''  )then
//        DocNoFilter := AddDocNo
//      ELSE
//        if ( STRPOS(DocNoFilter,AddDocNo) = 0  )then
//          if ( MAXSTRLEN(DocNoFilter) >= STRLEN(DocNoFilter + '|' + AddDocNo)  )then
//            DocNoFilter := DocNoFilter + '|' + AddDocNo
//          ELSE
//            TooLongFilter;
//    end;
//Local procedure FindPush();
//    begin
//      if (DocNoFilter = '') and (CarteraDocNoFilter = '') and (PostingDateFilter = '') and
//         (not ItemTrackingSearch) and
//         ((ContactType <> 0) or (ContactNo <> '') or (ExtDocNo <> ''))
//      then
//        FindExtRecords
//      ELSE
//        if ItemTrackingSearch and
//           (DocNoFilter = '') and (PostingDateFilter = '') and
//           (ContactType = 0) and (ContactNo = '') and (ExtDocNo = '')
//        then
//          FindTrackingRecords
//        ELSE
//          FindRecords;
//    end;
//Local procedure TooLongFilter();
//    begin
//      if ( ContactNo = ''  )then
//        ERROR(Text015);
//
//      ERROR(Text016);
//    end;
//Local procedure FindUnpostedSalesDocs(DocType : Option;DocTableName : Text[100];var SalesHeader : Record 36);
//    begin
//      SalesHeader."SECURITYFILTERING"(SECURITYFILTER::Filtered);
//      if ( SalesHeader.READPERMISSION  )then begin
//        SalesHeader.RESET;
//        SalesHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
//        SalesHeader.SETFILTER("Sell-to Customer No.",ContactNo);
//        SalesHeader.SETFILTER("External Document No.",ExtDocNo);
//        SalesHeader.SETRANGE("Document Type",DocType);
//        InsertIntoDocEntry(Rec,DATABASE::"Sales Header",DocType,DocTableName,SalesHeader.COUNT);
//      end;
//    end;
//Local procedure FindUnpostedServDocs(DocType : Option;DocTableName : Text[100];var ServHeader : Record 5900);
//    begin
//      ServHeader."SECURITYFILTERING"(SECURITYFILTER::Filtered);
//      if ( ServHeader.READPERMISSION  )then
//        if ( ExtDocNo = ''  )then begin
//          ServHeader.RESET;
//          ServHeader.SETCURRENTKEY("Customer No.");
//          ServHeader.SETFILTER("Customer No.",ContactNo);
//          ServHeader.SETRANGE("Document Type",DocType);
//          InsertIntoDocEntry(Rec,DATABASE::"Service Header",DocType,DocTableName,ServHeader.COUNT);
//        end;
//    end;
//Local procedure FindTrackingRecords();
//    var
//      DocNoOfRecords : Integer;
//    begin
//      Window.OPEN(Text002);
//      Rec.DELETEALL;
//      rec."Entry No." := 0;
//
//      CLEAR(ItemTrackingNavigateMgt);
//      ItemTrackingNavigateMgt.FindTrackingRecords(SerialNoFilter,LotNoFilter,'','');
//
//      ItemTrackingNavigateMgt.Collect(TempRecordBuffer);
//      TempRecordBuffer.SETCURRENTKEY("Table No.","Record Identifier");
//      if ( TempRecordBuffer.FIND('-')  )then
//        repeat
//          TempRecordBuffer.SETRANGE("Table No.",TempRecordBuffer."Table No.");
//
//          DocNoOfRecords := 0;
//          if ( TempRecordBuffer.FIND('-')  )then
//            repeat
//              TempRecordBuffer.SETRANGE("Record Identifier",TempRecordBuffer."Record Identifier");
//              TempRecordBuffer.FIND('+');
//              TempRecordBuffer.SETRANGE("Record Identifier");
//              DocNoOfRecords += 1;
//            until TempRecordBuffer.NEXT = 0;
//
//          InsertIntoDocEntry(Rec,TempRecordBuffer."Table No.",Enum::"Document Entry Document Type".FromInteger(0),TempRecordBuffer."Table Name",DocNoOfRecords);
//
//          TempRecordBuffer.SETRANGE("Table No.");
//        until TempRecordBuffer.NEXT = 0;
//
//      OnAfterNavigateFindTrackingRecords(Rec,SerialNoFilter,LotNoFilter);
//
//      DocExists := Rec.FIND('-');
//
//      UpdateFormAfterFindRecords;
//      Window.CLOSE;
//    end;
Local procedure GetDocumentCount() DocCount : Integer;
   begin
     DocCount :=
       NoOfRecords(DATABASE::"Sales Invoice Header") + NoOfRecords(DATABASE::"Sales Cr.Memo Header") +
       NoOfRecords(DATABASE::"Sales Shipment Header") + NoOfRecords(DATABASE::"Issued Reminder Header") +
       NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") + NoOfRecords(DATABASE::"Purch. Inv. Header") +
       NoOfRecords(DATABASE::"Return Shipment Header") + NoOfRecords(DATABASE::"Return Receipt Header") +
       NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") + NoOfRecords(DATABASE::"Purch. Rcpt. Header") +
       NoOfRecords(DATABASE::"Service Invoice Header") + NoOfRecords(DATABASE::"Service Cr.Memo Header") +
       NoOfRecords(DATABASE::"Service Shipment Header") +
       NoOfRecords(DATABASE::"Transfer Shipment Header") + NoOfRecords(DATABASE::"Transfer Receipt Header");

     OnAfterGetDocumentCount(DocCount);
   end;
//
//    //[External]
//procedure SetTracking(SerialNo : Code[50];LotNo : Code[50]);
//    begin
//      NewSerialNo := SerialNo;
//      NewLotNo := LotNo;
//    end;
//Local procedure ItemTrackingSearch() : Boolean;
//    begin
//      exit((SerialNoFilter <> '') or (LotNoFilter <> ''));
//    end;
//Local procedure ClearTrackingInfo();
//    begin
//      SerialNoFilter := '';
//      LotNoFilter := '';
//    end;
//Local procedure ClearInfo();
//    begin
//      SetDocNo('');
//      SetPostingDate('');
//      ContactType := ContactType::" ";
//      ContactNo := '';
//      ExtDocNo := '';
//    end;
//procedure FindCarteraDocs(AccountType: Option "Customer","Vendor");
//    begin
//      if ( CarteraDoc.READPERMISSION  )then begin
//        CarteraDoc.RESET;
//        CarteraDoc.SETCURRENTKEY(Type,"Original Document No.");
//        CarteraDoc.SETFILTER("Original Document No.",DocNoFilter);
//        CarteraDoc.SETFILTER("No.",CarteraDocNoFilter);  // C2
//        CarteraDoc.SETFILTER("Posting Date",PostingDateFilter);
//        CarteraDoc.SETRANGE(Type,AccountType);
//        InsertIntoDocEntry(Rec,DATABASE::"Cartera Doc.",Enum::"Document Entry Document Type".FromInteger(0),CarteraDoc.TABLECAPTION,CarteraDoc.COUNT);
//      end;
//      if ( PostedCarteraDoc.READPERMISSION  )then begin
//        PostedCarteraDoc.RESET;
//        PostedCarteraDoc.SETCURRENTKEY(Type,"Original Document No.");
//        PostedCarteraDoc.SETFILTER("Original Document No.",DocNoFilter);
//        PostedCarteraDoc.SETFILTER("No.",CarteraDocNoFilter);  // C2
//        PostedCarteraDoc.SETFILTER("Posting Date",PostingDateFilter);
//        InsertIntoDocEntry(Rec,DATABASE::"Posted Cartera Doc.",Enum::"Document Entry Document Type".FromInteger(0),PostedCarteraDoc.TABLECAPTION,PostedCarteraDoc.COUNT);
//      end;
//      if ( ClosedCarteraDoc.READPERMISSION  )then begin
//        ClosedCarteraDoc.RESET;
//        ClosedCarteraDoc.SETCURRENTKEY(Type,"Original Document No.");
//        ClosedCarteraDoc.SETFILTER("Original Document No.",DocNoFilter);
//        ClosedCarteraDoc.SETFILTER("No.",CarteraDocNoFilter);  // C2
//        ClosedCarteraDoc.SETFILTER("Posting Date",PostingDateFilter);
//        ClosedCarteraDoc.SETRANGE(Type,AccountType);
//        InsertIntoDocEntry(Rec,DATABASE::"Closed Cartera Doc.",Enum::"Document Entry Document Type".FromInteger(0),ClosedCarteraDoc.TABLECAPTION,ClosedCarteraDoc.COUNT);
//      end;
//    end;
//Local procedure DocNoFilterOnAfterValidate();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure PostingDateFilterOnAfterValida();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure CarteraDocNoFilterOnAfterValid();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure ExtDocNoOnAfterValidate();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure ContactTypeOnAfterValidate();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure ContactNoOnAfterValidate();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure SerialNoFilterOnAfterValidate();
//    begin
//      ClearSourceInfo;
//    end;
//Local procedure LotNoFilterOnAfterValidate();
//    begin
//      ClearSourceInfo;
//    end;
//
//    //[External]
//procedure FindRecordsOnOpen();
//    begin
//      if ( (NewDocNo = '') and (NewPostingDate = 0D) and (NewSerialNo = '') and (NewLotNo = '')  )then begin
//        Rec.DELETEALL;
//        ShowEnable := FALSE;
//        PrintEnable := FALSE;
//        SetSource(0D,'','',Enum::"Document Entry Document Type".FromInteger(0),'');
//      end ELSE
//        if ( (NewSerialNo <> '') or (NewLotNo <> '')  )then begin
//          SetSource(0D,'','',Enum::"Document Entry Document Type".FromInteger(0),'');
//          Rec.SETRANGE("Serial No. Filter",NewSerialNo);
//          Rec.SETRANGE("Lot No. Filter",NewLotNo);
//          SerialNoFilter := Rec.GETFILTER("Serial No. Filter");
//          LotNoFilter := Rec.GETFILTER("Lot No. Filter");
//          ClearInfo;
//          FindTrackingRecords;
//        end ELSE begin
//          Rec.SETRANGE("Document No.",NewDocNo);
//          Rec.SETRANGE("Posting Date",NewPostingDate);
//          DocNoFilter := Rec.GETFILTER("Document No.");
//          PostingDateFilter := Rec.GETFILTER("Posting Date");
//          ContactType := ContactType::" ";
//          ContactNo := '';
//          ExtDocNo := '';
//          ClearTrackingInfo;
//          FindRecords;
//        end;
//    end;
//
//    //[External]
//procedure UpdateNavigateForm(UpdateFormFrom : Boolean);
//    begin
//      UpdateForm := UpdateFormFrom;
//    end;
//
//    //[External]
//procedure ReturnDocumentEntry(var TempDocumentEntry : Record 265 TEMPORARY );
//    begin
//      Rec.SETRANGE("Table ID");  // Clear filter.
//      Rec.FINDSET;
//      repeat
//        TempDocumentEntry.INIT;
//        TempDocumentEntry := Rec;
//        TempDocumentEntry.INSERT;
//      until Rec.NEXT = 0;
//    end;
//Local procedure UpdateFindByGroupsVisibility();
//    begin
//      DocumentVisible := FALSE;
//      BusinessContactVisible := FALSE;
//      ItemReferenceVisible := FALSE;
//
//      CASE FindBasedOn OF
//        FindBasedOn::Document:
//          DocumentVisible := TRUE;
//        FindBasedOn::"Business Contact":
//          BusinessContactVisible := TRUE;
//        FindBasedOn::"Item Reference":
//          ItemReferenceVisible := TRUE;
//      end;
//
//      CurrPage.UPDATE;
//    end;
//Local procedure FilterSelectionChanged();
//    begin
//      FilterSelectionChangedTxtVisible := TRUE;
//    end;
//Local procedure GetCaptionText() : Text;
//    begin
//      if ( rec."Table Name" <> ''  )then
//        exit(STRSUBSTNO(PageCaptionTxt,rec."Table Name"));
//
//      exit('');
//    end;
//
  //  [Integrationevent(false,false)]
Local procedure OnAfterGetDocumentCount(var DocCount : Integer);
   begin
   end;
//
  //  [Integrationevent(false,TRUE)]
Local procedure OnAfterNavigateFindRecords(var DocumentEntry : Record 265;DocNoFilter : Text;PostingDateFilter : Text);
   begin
   end;
//
//    [Integration]
//Local procedure OnAfterNavigateFindTrackingRecords(var DocumentEntry : Record 265;SerialNoFilter : Text;LotNoFilter : Text);
//    begin
//    end;
//
  //  [IntegrationEvent(false,false)]
Local procedure OnAfterNavigateShowRecords(TableID : Integer;DocNoFilter : Text;PostingDateFilter : Text;ItemTrackingSearch : Boolean;var TempDocumentEntry : Record 265 TEMPORARY );
   begin
   end;
//
  //  [IntegrationEvent(false,false)]
Local procedure OnBeforeNavigateShowRecords(TableID : Integer;DocNoFilter : Text;PostingDateFilter : Text;ItemTrackingSearch : Boolean;var TempDocumentEntry : Record 265 TEMPORARY ;var IsHandled : Boolean);
   begin
   end;
//
  //  [IntegrationEvent(TRUE,TRUE)]
Local procedure OnBeforeUpdateFormAfterFindRecords();
   begin
   end;
LOCAL procedure "---------------------------------------------------- QB"();
    begin
    end;
procedure QB_NoOfRecords(TableID : Integer) : Integer;
    begin
      exit(NoOfRecords(TableID));
    end;
procedure QB_SetSource(PostingDate : Date;DocType2 : Text[100];DocNo : Text[50];SourceType2 : Integer;SourceNo2 : Code[20]);
    begin
      SetSource(PostingDate, DocType2, DocNo, SourceType2, SourceNo2);
    end;

//procedure
}


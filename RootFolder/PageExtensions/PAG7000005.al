pageextension 50255 MyExtension7000005 extends 7000005//7000003
{
layout
{
addafter("Account No.")
{
    field("Customer Name";rec."Customer Name")
    {
        
}
}

}

actions
{
addafter("Redraw")
{
    action("QB_Redraw")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Redraw',ESP='Recircular';
                      ToolTipML=ENU='Create a new copy of the old bill or order, with the possibility of creating it with a new, later due date and a different payment method.',ESP='Crea una nueva copia del documento quedando otra vez disponible en los documentos en cartera, con la posibilidad de crearlo con una nueva fecha de vencimiento (siempre igual o posterior) y con una forma de pago igual o distinta.';
                      ApplicationArea=Basic,Suite;
                      Enabled=TRUE;
                      Image=RefreshVoucher;
                      
                                trigger OnAction()    VAR
                                 QBCartera : Codeunit 7206905;
                               BEGIN
                                 //JAV 26/03/22: - QB 1.10.28 Posibilidad de recircular facturas o efectos
                                 CurrPage.SETSELECTIONFILTER(PostedDoc);
                                 QBCartera.RedrawCustomerPostedDoc(PostedDoc);
                                 CurrPage.UPDATE(FALSE);
                               END;


}
}


modify("Redraw")
{
Visible=FALSE;


}

}

//trigger

//trigger

var
      Text1100000 : TextConst ENU='No documents have been found that can be settled. \',ESP='No hay documentos que liquidar. \';
      Text1100001 : TextConst ENU='Please check that at least one open document was selected.',ESP='Compruebe que ha seleccionado al menos un documento pendiente.';
      Text1100002 : TextConst ENU='No documents have been found that can be rejected. \',ESP='No hay documentos que impagar. \';
      Text1100003 : TextConst ENU='Only invoices in Bill Groups marked as %1 Risked can be rejected.',ESP='S¢lo se pueden impagar las facturas remesadas marcadas como %1 con recurso.';
      Text1100004 : TextConst ENU='No documents have been found that can be redrawn. \',ESP='No hay documentos que se puedan recircular. \';
      Text1100005 : TextConst ENU='Please check that at least one rejected or honored document was selected.',ESP='Compruebe que ha seleccionado al menos un documento pagado o impagado.';
      Text1100006 : TextConst ENU='Only bills can be redrawn.',ESP='S¢lo se pueden recircular efectos.';
      Text1100007 : TextConst ENU='Please check that one open document was selected.',ESP='Compruebe que ha seleccionado un documento pendiente.';
      Text1100008 : TextConst ENU='Only one open document can be selected',ESP='S¢lo se puede seleccionar un documento pendiente.';
      PostedDoc : Record 7000003;
      CustLedgEntry : Record 21;
      SalesInvHeader : Record 112;
      CarteraManagement : Codeunit 7000000;

    
    

//procedure
//procedure Categorize();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      CarteraManagement.CategorizePostedDocs(PostedDoc);
//    end;
//procedure Decategorize();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      CarteraManagement.DecategorizePostedDocs(PostedDoc);
//    end;
//procedure Settle();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      if ( not PostedDoc.FIND('=><')  )then
//        exit;
//
//      PostedDoc.SETRANGE("Status",PostedDoc.Status::Open);
//      if ( not PostedDoc.FIND('-')  )then
//        ERROR(
//          Text1100000 +
//          Text1100001);
//
//      REPORT.RUNMODAL(REPORT::"Settle Docs. in Post. Bill Gr.",TRUE,FALSE,PostedDoc);
//      CurrPage.UPDATE(FALSE);
//    end;
//procedure Reject();
//    var
//      PostedBillGr : Record 7000006;
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      if ( not PostedDoc.FIND('=><')  )then
//        exit;
//
//      PostedDoc.SETRANGE("Status",PostedDoc.Status::Open);
//      if ( not PostedDoc.FIND('-')  )then
//        ERROR(
//          Text1100002 +
//          Text1100001);
//      if ( PostedDoc.Factoring <> PostedDoc.Factoring::" "  )then begin
//        PostedBillGr.GET(PostedDoc."Bill Gr./Pmt. Order No.");
//        if ( PostedBillGr.Factoring = PostedBillGr.Factoring::Unrisked  )then
//          ERROR(Text1100003,
//            PostedBillGr.FIELDCAPTION("Factoring"));
//      end;
//      CustLedgEntry.RESET;
//      repeat
//        CustLedgEntry.GET(PostedDoc."Entry No.");
//        CustLedgEntry.MARK(TRUE);
//      until PostedDoc.NEXT = 0;
//
//      CustLedgEntry.MARKEDONLY(TRUE);
//      REPORT.RUNMODAL(REPORT::"Reject Docs.",TRUE,FALSE,CustLedgEntry);
//      CurrPage.UPDATE(FALSE);
//    end;
procedure Redraw();
    begin
      PostedDoc.RESET;
      CurrPage.SETSELECTIONFILTER(PostedDoc);
      if ( not PostedDoc.FIND('=><')  )then
        exit;

      PostedDoc.SETFILTER("Status",'<>%1',PostedDoc.Status::Open);
      if ( not PostedDoc.FIND('-')  )then
        ERROR(
          Text1100004 +
          Text1100005);

      PostedDoc.SETFILTER("Document Type",'<>%1',PostedDoc."Document Type"::Bill);
      if ( PostedDoc.FIND('-')  )then
        ERROR(Text1100006);
      PostedDoc.SETRANGE("Document Type");

      CustLedgEntry.RESET;
      repeat
        CustLedgEntry.GET(PostedDoc."Entry No.");
        CustLedgEntry.MARK(TRUE);
      until PostedDoc.NEXT = 0;

      CustLedgEntry.MARKEDONLY(TRUE);
      REPORT.RUNMODAL(REPORT::"Redraw Receivable Bills",TRUE,FALSE,CustLedgEntry);
      CurrPage.UPDATE(FALSE);
    end;
//procedure PrintDoc();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      if ( not PostedDoc.FIND('-')  )then
//        exit;
//
//      if ( PostedDoc."Document Type" = PostedDoc."Document Type"::Bill  )then begin
//        CustLedgEntry.RESET;
//        repeat
//          CustLedgEntry.GET(PostedDoc."Entry No.");
//          CustLedgEntry.MARK(TRUE);
//        until PostedDoc.NEXT = 0;
//        CustLedgEntry.MARKEDONLY(TRUE);
//        CurrPage.UPDATE(FALSE);
//        REPORT.RUNMODAL(REPORT::"Receivable Bill",TRUE,FALSE,CustLedgEntry);
//      end ELSE begin
//        SalesInvHeader.RESET;
//        repeat
//          SalesInvHeader.GET(PostedDoc."Document No.");
//          SalesInvHeader.MARK(TRUE);
//        until PostedDoc.NEXT = 0;
//        SalesInvHeader.MARKEDONLY(TRUE);
//        CurrPage.UPDATE(FALSE);
//        REPORT.RUNMODAL(REPORT::"Sales - Invoice",TRUE,FALSE,SalesInvHeader);
//      end;
//    end;
//procedure Navigate();
//    begin
//      CarteraManagement.NavigatePostedDoc(Rec);
//    end;
//procedure PartialSettle();
//    var
//      CustLedgEntry2 : Record 21;
//      PartialSettleReceivable : Report 7000084;
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      if ( not PostedDoc.FIND('=><')  )then
//        exit;
//
//      PostedDoc.SETRANGE("Status",PostedDoc.Status::Open);
//      if ( not PostedDoc.FIND('-')  )then
//        ERROR(
//          Text1100000 +
//          Text1100007);
//      if ( PostedDoc.COUNT > 1  )then
//        ERROR(Text1100008);
//
//
//      CLEAR(PartialSettleReceivable);
//      CustLedgEntry2.GET(PostedDoc."Entry No.");
//      if (WORKDATE <= CustLedgEntry2."Pmt. Discount Date") and
//         (PostedDoc."Document Type" = PostedDoc."Document Type"::Invoice)
//      then
//        PartialSettleReceivable.SetInitValue(PostedDoc."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible",
//          PostedDoc."Currency Code",PostedDoc."Entry No.")
//      ELSE
//        PartialSettleReceivable.SetInitValue(PostedDoc."Remaining Amount",
//          PostedDoc."Currency Code",PostedDoc."Entry No.");
//      PartialSettleReceivable.SETTABLEVIEW(PostedDoc);
//      PartialSettleReceivable.RUNMODAL;
//
//      CurrPage.UPDATE(FALSE);
//    end;
//procedure ShowDimension();
//    begin
//      rec.ShowDimensions;
//    end;

//procedure
}


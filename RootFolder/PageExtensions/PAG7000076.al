pageextension 50274 MyExtension7000076 extends 7000076//7000003
{
layout
{
addafter("Due Date")
{
    field("Original Due Date";rec."Original Due Date")
    {
        
                Visible=seeConfirming ;
}
} addafter("Description")
{
    field("QB_CustVendorBankAccCode";rec."Cust./Vendor Bank Acc. Code")
    {
        
}
} addafter("Account No.")
{
    field("Vendor Name";rec."Vendor Name")
    {
        
}
}

}

actions
{
addafter("Settle")
{
//     action("Redraw")
//     {
        
//                       Ellipsis=true;
//                       CaptionML=ENU='Redraw',ESP='Recircular';
//                       ToolTipML=ENU='Create a new copy of the old bill or order, with the possibility of creating it with a new, later due date and a different payment method.',ESP='Crea una nueva copia del antiguo efecto u orden, con la posibilidad de crearlo con una fecha de vencimiento nueva y posterior y con una forma de pago distinta.';
//                       ApplicationArea=Basic,Suite;
//                       Visible=FALSE;
//                       Enabled=TRUE;
//                       Image=RefreshVoucher;
                      
//                                 trigger OnAction()    BEGIN
//                                  Redraw;
//                                END;


// }
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
                                 QBCartera.RedrawVendorPostedDoc(PostedDoc);
                                 CurrPage.UPDATE(FALSE);
                               END;


}
} addafter("Navigate")
{
    action("QB_ChangeDueDate")
    {
        
                      CaptionML=ESP='Cambiar Vto.';
                      Visible=seeConfirming;
                      Enabled=actChangeDueDate;
                      Image=ChangeToLines;
                      
                                
    trigger OnAction()    VAR
                                 QBCartera : Codeunit 7206905;
                               BEGIN
                                 QBCartera.ChangePostedDocDueDate(Rec);
                               END;


}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 //Confirming
                 seeConfirming := (QBCartera.IsFactoringActive);
               END;
trigger OnAfterGetRecord()    BEGIN
                       //QB
                       PostedPaymentOrder.GET(rec."Bill Gr./Pmt. Order No.");
                       actChangeDueDate := (PostedPaymentOrder.Confirming);
                       //QB fin
                     END;


//trigger

var
      Text1100000 : TextConst ENU='No documents have been found that can be settled. \',ESP='No hay documentos que liquidar. \';
      Text1100001 : TextConst ENU='Please check that at least one open document was selected.',ESP='Compruebe que ha seleccionado al menos un documento pendiente.';
      Text1100004 : TextConst ENU='No documents have been found that can be redrawn. \',ESP='No hay documentos que se puedan recircular. \';
      Text1100005 : TextConst ENU='Please check that at least one rejected or honored document was selected.',ESP='Compruebe que ha seleccionado al menos un documento pagado o impagado.';
      Text1100006 : TextConst ENU='Only bills can be redrawn.',ESP='S¢lo se pueden recircular efectos.';
      Text1100007 : TextConst ENU='Please check that one open document was selected.',ESP='Compruebe que ha seleccionado un documento pendiente.';
      Text1100008 : TextConst ENU='Only one open document can be selected',ESP='S¢lo se puede seleccionar un documento pendiente.';
      PostedDoc : Record 7000003;
      VendLedgEntry : Record 25;
      CarteraManagement : Codeunit 7000000;
      "---------------------------------------- QB" : Integer;
      DocumentNo : Text;
      actChangeDueDate : Boolean;
      PostedPaymentOrder : Record 7000021;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;

    
    

//procedure
//Local procedure Categorize();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      CarteraManagement.CategorizePostedDocs(PostedDoc);
//    end;
//Local procedure Decategorize();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      CarteraManagement.DecategorizePostedDocs(PostedDoc);
//    end;
//Local procedure Settle();
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
//      REPORT.RUNMODAL(REPORT::"Settle Docs. in Posted PO",TRUE,FALSE,PostedDoc);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure Redraw();
//    begin
//      CurrPage.SETSELECTIONFILTER(PostedDoc);
//      if ( not PostedDoc.FIND('=><')  )then
//        exit;
//
//      PostedDoc.SETFILTER("Status",'<>%1',PostedDoc.Status::Open);
//      if ( not PostedDoc.FIND('-')  )then
//        ERROR(
//          Text1100004 +
//          Text1100005);
//
//      PostedDoc.SETFILTER("Document Type",'<>%1',PostedDoc."Document Type"::Bill);
//      if ( PostedDoc.FIND('-')  )then
//        ERROR(Text1100006);
//      PostedDoc.SETRANGE("Document Type");
//
//      VendLedgEntry.RESET;
//      repeat
//        VendLedgEntry.GET(PostedDoc."Entry No.");
//        VendLedgEntry.MARK(TRUE);
//      until PostedDoc.NEXT = 0;
//
//      VendLedgEntry.MARKEDONLY(TRUE);
//      REPORT.RUNMODAL(REPORT::"Redraw Payable Bills",TRUE,FALSE,VendLedgEntry);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure Navigate();
//    begin
//      CarteraManagement.NavigatePostedDoc(Rec);
//    end;
//Local procedure PartialSettle();
//    var
//      VendLedgEntry2 : Record 25;
//      PartialSettlePayable : Report 7000085;
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
//      CLEAR(PartialSettlePayable);
//      VendLedgEntry2.GET(PostedDoc."Entry No.");
//      if (WORKDATE <= VendLedgEntry2."Pmt. Discount Date") and
//         (PostedDoc."Document Type" = PostedDoc."Document Type"::Invoice)
//      then
//        PartialSettlePayable.SetInitValue(PostedDoc."Remaining Amount" + VendLedgEntry2."Remaining Pmt. Disc. Possible",
//          PostedDoc."Currency Code",PostedDoc."Entry No.")
//      ELSE
//        PartialSettlePayable.SetInitValue(PostedDoc."Remaining Amount",
//          PostedDoc."Currency Code",PostedDoc."Entry No.");
//      PartialSettlePayable.SETTABLEVIEW(PostedDoc);
//      PartialSettlePayable.RUNMODAL;
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure ShowDimension();
//    begin
//      rec.ShowDimensions;
//    end;

//procedure
}


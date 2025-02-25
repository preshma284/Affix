pageextension 50275 MyExtension7000077 extends 7000077//7000004
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
                                 CurrPage.SETSELECTIONFILTER(ClosedDoc);
                                 QBCartera.RedrawVendorClosedDoc(ClosedDoc);
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
trigger OnOpenPage()    BEGIN
                 //Confirming
                 seeConfirming := (QBCartera.IsFactoringActive);
               END;


//trigger

var
      Text1100000 : TextConst ENU='Only bills can be redrawn.',ESP='S¢lo se pueden recircular efectos.';
      ClosedDoc : Record 7000004;
      VendLedgEntry : Record 25;
      CarteraManagement : Codeunit 7000000;
      "---------------------------------------- QB" : Integer;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;

    
    

//procedure
//procedure Navigate();
//    begin
//      CarteraManagement.NavigateClosedDoc(Rec);
//    end;
//Local procedure Redraw();
//    begin
//      CurrPage.SETSELECTIONFILTER(ClosedDoc);
//      if ( not ClosedDoc.FIND('=><')  )then
//        exit;
//
//      ClosedDoc.SETFILTER("Document Type",'<>%1',ClosedDoc."Document Type"::Bill);
//      if ( ClosedDoc.FIND('-')  )then
//        ERROR(Text1100000);
//      ClosedDoc.SETRANGE("Document Type");
//
//      VendLedgEntry.RESET;
//      repeat
//        VendLedgEntry.GET(ClosedDoc."Entry No.");
//        VendLedgEntry.MARK(TRUE);
//      until ClosedDoc.NEXT = 0;
//
//      VendLedgEntry.MARKEDONLY(TRUE);
//      REPORT.RUNMODAL(REPORT::"Redraw Payable Bills",TRUE,FALSE,VendLedgEntry);
//      CurrPage.UPDATE(FALSE);
//    end;
//procedure ShowDimension();
//    begin
//      rec.ShowDimensions;
//    end;

//procedure
}


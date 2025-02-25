pageextension 50258 MyExtension7000008 extends 7000008//7000004
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
                                 CurrPage.SETSELECTIONFILTER(ClosedDoc);
                                 QBCartera.RedrawCustomerClosedDoc(ClosedDoc);
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
      Text1100000 : TextConst ENU='Only bills can be redrawn.',ESP='S¢lo se pueden recircular efectos.';
      ClosedDoc : Record 7000004;
      CustLedgEntry : Record 21;
      CarteraManagement : Codeunit 7000000;

    
    

//procedure
//procedure Navigate();
//    begin
//      CarteraManagement.NavigateClosedDoc(Rec);
//    end;
procedure Redraw();
    begin
      CurrPage.SETSELECTIONFILTER(ClosedDoc);
      if ( not ClosedDoc.FIND('=><')  )then
        exit;

      ClosedDoc.SETFILTER("Document Type",'<>%1',ClosedDoc."Document Type"::Bill);
      if ( ClosedDoc.FIND('-')  )then
        ERROR(Text1100000);
      ClosedDoc.SETRANGE("Document Type");

      CustLedgEntry.RESET;
      repeat
        CustLedgEntry.GET(ClosedDoc."Entry No.");
        CustLedgEntry.MARK(TRUE);
      until ClosedDoc.NEXT = 0;

      CustLedgEntry.MARKEDONLY(TRUE);
      REPORT.RUNMODAL(REPORT::"Redraw Receivable Bills",TRUE,FALSE,CustLedgEntry);

      CurrPage.UPDATE(FALSE);
    end;
//procedure ShowDimension();
//    begin
//      rec.ShowDimensions;
//    end;

//procedure
}


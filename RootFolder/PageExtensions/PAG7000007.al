pageextension 50257 MyExtension7000007 extends 7000007//7000004
{
layout
{
addafter("Entry No.")
{
    field("QB_PaymentBankNo";rec."Bank Account No.")
    {
        
                Editable=false ;
}
    field("QB_PaymentBankName";FunctionQB.GetBankName(rec."Bank Account No."))
    {
        
                CaptionML=ENU='Own Bank Name',ESP='Nombre del banco propio';
                Enabled=false 

  ;
}
}

}

actions
{


}

//trigger

//trigger

var
      Text1100000 : TextConst ENU='Only bills can be redrawn.',ESP='S¢lo se pueden recircular efectos.';
      Text1100001 : TextConst ENU='Only receivable bills can be redrawn.',ESP='S¢lo se pueden recircular efectos a cobrar.';
      Text1100002 : TextConst ENU='No bills have been found that can be redrawn. \',ESP='No hay efectos que recircular. \';
      Text1100003 : TextConst ENU='Please check that at least one rejected bill was selected.',ESP='Compruebe que ha seleccionado al menos un efecto impagado.';
      ClosedDoc : Record 7000004;
      CustLedgEntry : Record 21;
      CarteraManagement : Codeunit 7000000;
      "---------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;

    
    

//procedure
//procedure Redraw();
//    begin
//      CurrPage.SETSELECTIONFILTER(ClosedDoc);
//      if ( not ClosedDoc.FIND('=><')  )then
//        exit;
//
//      ClosedDoc.SETRANGE("Document Type",ClosedDoc."Document Type"::Bill);
//      if ( not ClosedDoc.FIND('-')  )then
//        ERROR(
//          Text1100000);
//
//      ClosedDoc.SETRANGE("Type",ClosedDoc.Type::ivable);
//      if ( not ClosedDoc.FIND('-')  )then
//        ERROR(
//          Text1100001);
//
//      ClosedDoc.SETRANGE("Status",ClosedDoc.Status::Rejected);
//      if ( not ClosedDoc.FIND('-')  )then
//        ERROR(
//          Text1100002 +
//          Text1100003);
//
//      CustLedgEntry.RESET;
//      repeat
//        CustLedgEntry.GET(ClosedDoc."Entry No.");
//        CustLedgEntry.MARK(TRUE);
//      until ClosedDoc.NEXT = 0;
//
//      CustLedgEntry.MARKEDONLY(TRUE);
//      REPORT.RUNMODAL(REPORT::"Redraw Receivable Bills",TRUE,FALSE,CustLedgEntry);
//    end;

//procedure
}


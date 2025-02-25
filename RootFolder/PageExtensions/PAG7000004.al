pageextension 50254 MyExtension7000004 extends 7000004//7000002
{
layout
{
addafter("Description")
{
    field("QB_CustVendorBankAccCode";rec."Cust./Vendor Bank Acc. Code")
    {
        
}
} addafter("Remaining Amt. (LCY)")
{
    field("Unrisk Amount";rec."Unrisk Amount")
    {
        
}
} addafter("Account No.")
{
    field("Customer Name";rec."Customer Name")
    {
        
}
} addafter("Direct Debit Mandate ID")
{
    field("QB_PaymentBankNo";rec."QB Payment bank No.")
    {
        
                Editable=false ;
}
    field("QB_PaymentBankName";FunctionQB.GetBankName(rec."QB Payment bank No."))
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
      Doc : Record 7000002;
      CustLedgEntry : Record 21;
      SalesInvHeader : Record 112;
      CarteraManagement : Codeunit 7000000;
      "--------------------------------- QB" : Integer;
      QBCartera : Codeunit 7206905;
      FunctionQB : Codeunit 7207272;

    
    

//procedure
//procedure Categorize();
//    begin
//      CurrPage.SETSELECTIONFILTER(Doc);
//      CarteraManagement.CategorizeDocs(Doc);
//    end;
//procedure Decategorize();
//    begin
//      CurrPage.SETSELECTIONFILTER(Doc);
//      CarteraManagement.DecategorizeDocs(Doc);
//    end;
procedure AddReceivableDocs();
    begin
      Doc.COPY(Rec);
      CarteraManagement.InsertReceivableDocs(Doc);

      //QB 1.06.15 JAV 23/09/20: - Verificar l¡mites del factoring
      if ( Rec.FINDFIRST  )then
        QBCartera.VerifyFactoringLimit(Rec."Bill Gr./Pmt. Order No.", FALSE);
    end;
procedure RemoveDocs(BGPONo : Code[20]);
    begin
      Doc.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(Doc);
      CarteraManagement.RemoveReceivableDocs(Doc);

      //QB 1.06.15 JAV 23/09/20: - Verificar l¡mites del factoring
      QBCartera.VerifyFactoringLimit(BGPONo, FALSE);
    end;
//procedure PrintDoc();
//    begin
//      CurrPage.SETSELECTIONFILTER(Doc);
//      if ( not Doc.FIND('-')  )then
//        exit;
//
//      if ( Doc."Document Type" = Doc."Document Type"::Bill  )then begin
//        CustLedgEntry.RESET;
//        repeat
//          CustLedgEntry.GET(Doc."Entry No.");
//          CustLedgEntry.MARK(TRUE);
//        until Doc.NEXT = 0;
//
//        CustLedgEntry.MARKEDONLY(TRUE);
//        CustLedgEntry.PrintBill(TRUE);
//      end ELSE begin
//        SalesInvHeader.RESET;
//        repeat
//          SalesInvHeader.GET(Doc."Document No.");
//          SalesInvHeader.MARK(TRUE);
//        until Doc.NEXT = 0;
//
//        SalesInvHeader.MARKEDONLY(TRUE);
//        SalesInvHeader.PrintRecords(TRUE);
//      end;
//    end;
//procedure Navigate();
//    begin
//      CarteraManagement.NavigateDoc(Rec);
//    end;
//procedure ShowDimension();
//    begin
//      rec.ShowDimensions;
//    end;

//procedure
}


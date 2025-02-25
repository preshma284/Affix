pageextension 50273 MyExtension7000075 extends 7000075//7000002
{
layout
{
addafter("Description")
{
    field("QB_CustVendorBankAccCode";rec."Cust./Vendor Bank Acc. Code")
    {
        
}
} addafter("Account No.")
{
    field("Vendor Name";rec."Vendor Name")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_ExternalDocumentNo";rec."External Document No.")
    {
        
}
    field("QB_TransferType";rec."Transfer Type")
    {
        
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
      CarteraManagement : Codeunit 7000000;
      "------------------------------- qb" : Integer;
      QBCartera : Codeunit 7206905;

    
    

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
procedure AddPayableDocs(BGPONo : Code[20]);
    var
      PaymentOrder : Record 7000020;
    begin
      Doc.COPY(Rec);

      if ( PaymentOrder.GET(BGPONo)  )then
        PaymentOrder.TESTfield("Elect. Pmts Exported",FALSE);
      CarteraManagement.InsertPayableDocs(Doc);

      //QB 1.06.15 JAV 23/09/20: - Verificar l¡mites del confirming
      if ( Rec.FINDFIRST  )then
        QBCartera.VerifyConfirmingLimit(Rec."Bill Gr./Pmt. Order No.", FALSE);
    end;
procedure RemoveDocs(BGPONo : Code[20]);
    var
      PaymentOrder : Record 7000020;
    begin
      Doc.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(Doc);
      if ( PaymentOrder.GET(BGPONo)  )then
        PaymentOrder.TESTfield("Elect. Pmts Exported",FALSE);
      CarteraManagement.RemovePayableDocs(Doc);

      //QB 1.06.15 JAV 23/09/20: - Verificar l¡mites del confirming
      QBCartera.VerifyConfirmingLimit(BGPONo, FALSE);
    end;
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


pageextension 50256 MyExtension7000006 extends 7000006//7000003
{
layout
{
addafter("Place")
{
    field("QB_CustVendorBankAccCode";rec."Cust./Vendor Bank Acc. Code")
    {
        
}
} addafter("Entry No.")
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
      CarteraManagement : Codeunit 7000000;
      "-------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;

    

//procedure

//procedure
}


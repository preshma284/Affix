pageextension 50173 MyExtension315 extends 315//254
{
layout
{
addafter("Delivery Operation Code")
{
    field("DP_OriginalVATAmount";rec."DP Original VAT Amount")
    {
        
                Visible=seeProrrata or seeNonDeductible ;
}
    field("DP_NonDeductiblePorc";rec."DP Non Deductible %")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP_NonDeductibleAmount";rec."DP Non Deductible Amount")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP_Prorrata";rec."DP Prorrata Type")
    {
        
                Visible=seeProrrata ;
}
    field("DP_ProvProrrataPorc";rec."DP Prov. Prorrata %")
    {
        
                Visible=seeProrrata ;
}
    field("DP_DefProrrataPorc";rec."DP Def. Prorrata %")
    {
        
                Visible=seeProrrata ;
}
    field("DP_ProrrataDefVATAmount";rec."DP Prorrata Def. VAT Amount")
    {
        
                Visible=seeProrrata ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 GeneralLedgerSetup : Record 98;
               BEGIN
                 IF GeneralLedgerSetup.GET THEN
                   IsUnrealizedVATEnabled := GeneralLedgerSetup."Unrealized VAT" OR GeneralLedgerSetup."Prepayment Unrealized VAT";

                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
                 seeNonDeductible := DPManagement.AccessToNonDeductible;  //JAV 14/07/22: - DP 1.00.04 Se a¤ade el IVA no deducible
               END;


//trigger

var
      Navigate : Page 344;
      HasIncomingDocument : Boolean;
      IsUnrealizedVATEnabled : Boolean;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      seeNonDeductible : Boolean;

    

//procedure

//procedure
}


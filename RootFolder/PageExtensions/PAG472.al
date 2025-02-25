pageextension 50203 MyExtension472 extends 472//325
{
layout
{
addafter("No Taxable Type")
{
    field("ISP Description";rec."ISP Description")
    {
        
}
    field("QuoSII Exent Type";rec."QuoSII Exent Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII No VAT Type";rec."QuoSII No VAT Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII DUA Compensation";rec."QuoSII DUA Compensation")
    {
        
                Visible=vQuoSII ;
}
    field("DP Non Deductible VAT Line";rec."DP Non Deductible VAT Line")
    {
        
                ToolTipML=ESP='Este campo indica si al usar este tipo de IVA en una factura de compra la l¡nea tiene una parte del IVA no deducible que aumentar  el importe del gasto';
                Visible=seeNonDeductible ;
}
    field("DP Non Deductible VAT %";rec."DP Non Deductible VAT %")
    {
        
                ToolTipML=ESP='Este campo indica al usar este tipo de IVA en una factura de compra se le aplciar  a la l¡nea  este valor como % no deducible de la l¡nea que aumentar  el importe del gasto';
                Visible=seeNonDeductible ;
}
}


modify("No Taxable Type")
{
Visible=vSII ;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 rec.SetAccountsVisibility(UnrealizedVATVisible,AdjustForPmtDiscVisible);

                 //QB
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 vSII    := FunctionQB.AccessToSII;

                 //JAV 21/06/22: - DP 1.00.04 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeNonDeductible := DPManagement.AccessToNonDeductible;  //JAV 14/07/22: - DP 1.00.04 Se a¤ade el IVA no deducible
               END;


//trigger

var
      CopyVATPostingSetup : Report 85;
      UnrealizedVATVisible : Boolean;
      AdjustForPmtDiscVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;
      vSII : Boolean;
      "----------------------------------------------- No Deducible" : Integer;
      DPManagement : Codeunit 7174414;
      seeNonDeductible : Boolean;

    

//procedure

//procedure
}


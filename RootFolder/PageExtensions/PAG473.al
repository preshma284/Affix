pageextension 50204 MyExtension473 extends 473//325
{
layout
{
addafter("Tax Category")
{
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
} addafter("No Taxable Type")
{
    field("ISP Description";rec."ISP Description")
    {
        
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 rec.SetAccountsVisibility(UnrealizedVATVisible,AdjustForPmtDiscVisible);

                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;


//trigger

var
      CopyVATPostingSetup : Report 85;
      UnrealizedVATVisible : Boolean;
      AdjustForPmtDiscVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    

//procedure

//procedure
}


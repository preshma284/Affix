pageextension 50201 MyExtension470 extends 470//323
{
layout
{
addafter("Description")
{
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
    field("VAT Bus.Pst.Grp. in Cr.Memos";rec."VAT Bus.Pst.Grp. in Cr.Memos")
    {
        
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;


//trigger

var
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    

//procedure

//procedure
}


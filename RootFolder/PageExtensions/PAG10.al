pageextension 50100 MyExtension10 extends 10//9
{
layout
{
addafter("VAT Scheme")
{
    field("QuoSII Country Code";rec."QuoSII Country Code")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII VAT Reg No. Type";rec."QuoSII VAT Reg No. Type")
    {
        
                Visible=vQuoSII ;
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


pageextension 50172 MyExtension313 extends 313//251
{
layout
{
addafter("Operation Code")
{
    field("QuoSII Type";rec."QuoSII Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII IRPF Type";rec."QuoSII IRPF Type")
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


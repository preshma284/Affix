pageextension 50270 MyExtension7000055 extends 7000055//7000021
{
layout
{
addafter("Remaining Amount (LCY)")
{
    field("Confirming";rec."Confirming")
    {
        
                Visible=seeConfirming ;
}
    field("Confirming Line";rec."Confirming Line")
    {
        
                Visible=seeConfirming ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 //rec."Confirming"
                 seeConfirming := (QBCartera.IsFactoringActive);
               END;


//trigger

var
      PostedPmtOrd : Record 7000021;
      "------------------------------ QB" : Integer;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;

    

//procedure

//procedure
}


pageextension 50272 MyExtension7000061 extends 7000061//7000022
{
layout
{
addafter("Amount Grouped (LCY)")
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
      ClosedPmtOrd : Record 7000022;
      "------------------------------ QB" : Integer;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;

    

//procedure

//procedure
}


pageextension 50271 MyExtension7000060 extends 7000060//7000022
{
layout
{
addafter("Amount Grouped (LCY)")
{
    field("Confirming";rec."Confirming")
    {
        
                Visible=seeConfirming;
                Editable=false ;
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
      Navigate : Page 344;
      "------------------------------ QB" : Integer;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;

    

//procedure

//procedure
}


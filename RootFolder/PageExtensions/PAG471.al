pageextension 50202 MyExtension471 extends 471//324
{
layout
{
addafter("Delivery Operation Code")
{
    field("QFA Code Tax Type";rec."QFA Code Tax Type")
    {
        
                Visible=seeFacturae ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 vQuoSII := FunctionQB.AccessToFacturae;
                 seeFacturae := FunctionQB.AccessToFacturae;
               END;


//trigger

var
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;
      seeFacturae : Boolean;

    

//procedure

//procedure
}


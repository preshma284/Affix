pageextension 50187 MyExtension4 extends 4//3
{
layout
{
addafter("Description")
{
    field("QB Requires purchase approval";rec."QB Requires purchase approval")
    {
        
                ToolTipML=ENU='Indicates if the use of this payment method in purchases needs approval',ESP='Indica si el uso de este m‚todo de pago en compras necesita aprobaci¢n';
                Visible=seeQB ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 //JAV 01/03/21: - QB 1.08.19 Se hacen visibles los campos de QB solo si est  activo
                 seeQB := FunctionQB.AccessToQuobuilding;
               END;


//trigger

var
      seeQB : Boolean;
      FunctionQB : Codeunit 7207272;

    

//procedure

//procedure
}


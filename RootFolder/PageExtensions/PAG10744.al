pageextension 50103 MyExtension10744 extends 10744//10744
{
layout
{
addafter("Customer/Vendor No.")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
}
    field("QB_CustomerVendorName";rec."Customer/Vendor Name")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      Text001 : TextConst ENU='There are lines with empty property location for the operation code R.',ESP='Hay l¡neas con una ubicaci¢n de propiedad vac¡a para el c¢digo de operaci¢n R.';
      OperationCodeEditable : Boolean ;
      PropertyLocationEditable : Boolean ;
      PropertyTaxAccountNoEditable : Boolean ;

    
    

//procedure
//Local procedure SetRControlsEditable();
//    begin
//      PropertyLocationEditable := rec."Operation Code" = 'R';
//      PropertyTaxAccountNoEditable := rec."Operation Code" = 'R';
//    end;

//procedure
}


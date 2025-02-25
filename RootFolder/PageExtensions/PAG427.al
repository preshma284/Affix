pageextension 50194 MyExtension427 extends 427//289
{
layout
{
addafter("Bill Type")
{
    field("QB_Convertir";rec."Convert in Payment Relation")
    {
        
}
    field("QB_MandatoryVendorBank";rec."Mandatory Vendor Bank")
    {
        
}
    field("QB_RequiresApprovalOnPurchases SourceExpr=Requires approval on purchases";rec."Requires approval on purchases")
    {
        
}
    field("QB_DiscountProforms";rec."QB % Discount in Proforms")
    {
        
}
} addafter("Use for Invoicing")
{
    field("QB Confirming Customer";rec."QB Confirming Customer")
    {
        
                ToolTipML=ESP='Indica si esta forma de pago se usa para operaciones de Confirming como Cliente';
}
    field("QB Confirming Vendor";rec."QB Confirming Vendor")
    {
        
                ToolTipML=ESP='Indica si esta forma de pago se usa para operaciones de Confirming para Proveedores';
}
    field("QuoSII Cobro Metalico SII";rec."QuoSII Cobro Metalico SII")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Type SII";rec."QuoSII Type SII")
    {
        
                Visible=vQuoSII ;
}
} addafter("SII Payment Method Code")
{
    field("QFA Payment Means Type";rec."QFA Payment Means Type")
    {
        
                Visible=vQFA ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 //JAV 08/05/19: - Se a¤ade el campo "Convertir" visible si activas relaciones de pagos
                 verRelacionesPagos := FunctionQB.AccessToPaymentRelations;
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 vQFA := FunctionQB.AccessToFacturae;
               END;


//trigger

var
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;
      vQFA : Boolean;
      verRelacionesPagos : Boolean ;

    

//procedure

//procedure
}


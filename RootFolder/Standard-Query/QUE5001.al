query 50220 "Locations from items Sales 1"
{
  
  
    CaptionML=ENU='Locations from items Sales',ESP='Ubicaciones de los productos de Ventas';
  
  elements
{

DataItem("Sales_Line";"Sales Line")
{

               DataItemTableFilter="Document Type"=CONST("Order"),
                                   "Type"=CONST("Item"),
                                   "Location Code"=FILTER(<>''),
                                   "No."=FILTER(<>''),
                                   "Quantity"=FILTER(<>0);
Column(Document_No;"Document No.")
{

}Column("Location_Code";"Location Code")
{

}DataItem("Location";"Location")
{

               DataItemTableFilter="Use As In-Transit"=CONST(false);
DataItemLink="Code"= "Sales_Line"."Location Code";
Column(Require_Shipment;"Require Shipment")
{

}Column(Require_Pick;"Require Pick")
{

}
}
}
}
  

    /*begin
    end.
  */
}





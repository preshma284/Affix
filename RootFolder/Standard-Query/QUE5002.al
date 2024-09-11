query 50221 "Locations from items Purch 1"
{
  
  
    CaptionML=ENU='Locations from items Purch',ESP='Ubicaciones de los productos de Compras';
  
  elements
{

DataItem("Purchase_Line";"Purchase Line")
{

               DataItemTableFilter="Document Type"=CONST("Order"),
                                   "Type"=CONST("Item"),
                                   "Location Code"=FILTER(<>''),
                                   "No."=FILTER(<>''),
                                   "Quantity"=FILTER(<>0);
Column("Document_No";"Document No.")
{

}Column("Location_Code";"Location Code")
{

}DataItem("Location";"Location")
{

               DataItemTableFilter="Use As In-Transit"=CONST(false);
DataItemLink="Code"= "Purchase_Line"."Location Code";
Column("Require_Put_away";"Require Put-away")
{

}Column("Require_Receive";"Require Receive")
{

}
}
}
}
  

    /*begin
    end.
  */
}





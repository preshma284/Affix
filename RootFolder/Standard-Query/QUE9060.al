query 50233 "Count Sales Orders 1"
{


    CaptionML = ENU = 'Count Sales Orders', ESP = 'Contar pedidos de venta';

    elements
    {

        DataItem("Sales_Header"; "Sales Header")
        {

            DataItemTableFilter = "Document Type" = CONST("Order");
            Filter("Status"; "Status")
            {

            }
            Filter("Shipped"; "Shipped")
            {

            }
            Filter("Completely_Shipped"; "Completely Shipped")
            {

            }
            Filter("Responsibility_Center"; "Responsibility Center")
            {

            }
            Filter("Shipped_Not_Invoiced"; "Shipped Not Invoiced")
            {

            }
            Filter("Ship"; "Ship")
            {

            }
            Filter("Date_Filter"; "Date Filter")
            {

            }
            Filter("Late_Order_Shipping"; "Late Order Shipping")
            {

            }
            Filter("Shipment_Date"; "Shipment Date")
            {

            }
            Column(Count_Orders)
            {
                //MethodType=Totals;
                Method = Count;
            }
        }
    }


    /*begin
    end.
  */
}





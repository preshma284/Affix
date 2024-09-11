query 50234 "Count Purchase Orders 1"
{


    CaptionML = ENU = 'Count Purchase Orders', ESP = 'Contar pedidos de compra';

    elements
    {

        DataItem("Purchase_Header"; "Purchase Header")
        {

            DataItemTableFilter = "Document Type" = CONST("Order");
            Filter("Completely_Received"; "Completely Received")
            {

            }
            Filter("Responsibility_Center"; "Responsibility Center")
            {

            }
            Filter("Status"; "Status")
            {

            }
            Filter("Partially_Invoiced"; "Partially Invoiced")
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





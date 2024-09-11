query 50205 "Trailing Sales Order Qry 1"
{


    CaptionML = ENU = 'Trailing Sales Order Qry', ESP = 'Consulta pedidos de venta final';

    elements
    {

        DataItem("Sales_Header"; "Sales Header")
        {

            DataItemTableFilter = "Document Type" = CONST("Order");
            Filter(ShipmentDate; "Shipment Date")
            {

            }
            Filter("Status"; "Status")
            {

            }
            Filter(DocumentDate; "Document Date")
            {

            }
            Column(CurrencyCode; "Currency Code")
            {

            }
            DataItem("Sales_Line"; "Sales Line")
            {

                DataItemTableFilter = "Amount" = FILTER(<> 0);
                DataItemLink = "Document Type" = "Sales_Header"."Document Type",
                            "Document No." = "Sales_Header"."No.";
                SqlJoinType = InnerJoin;
                //DataItemLinkType=Exclude Row If No Match;
                Column(Amount; "Amount")
                {

                    //MethodType=Totals;
                    Method = Sum;
                }
            }
        }
    }


    /*begin
    end.
  */
}





query 50227 "Customer Sales Entity 1"
{



    CaptionML = ENU = 'customerSales',
               ESP = 'customerSales'; //, Locked=true;
    //Locked = true;
    EntitySetName = 'customerSales';
    EntityName = 'customerSales';
    QueryType = API;

    elements
    {

        DataItem("Customer"; "Customer")
        {

            Column(customerId; SystemId)
            {
                CaptionML = //@@@='{Locked}';
                          ENU = 'Id',
                          ESP = 'Id';
            }
            Column(customerNumber; "No.")
            {
                CaptionML =//@@@='{Locked}';
                          ENU = 'No',
                          ESP = 'No';
            }
            Column(name; "Name")
            {
                CaptionML =//@@@='{Locked}';
                ENU = 'Name',
                ESP = 'Name';
            }
            DataItem("Cust_Ledger_Entry"; "Cust. Ledger Entry")
            {

                DataItemTableFilter = "Document Type" = FILTER('Invoice' | 'Credit Memo');
                DataItemLink = "Customer No." = Customer."No.";
                //Added in Base query
                //SqlJoinType = LeftOuterJoin;
                //DataItemLinkType=SQL Advanced Options;
                Column(totalSalesAmount; "Sales (LCY)")
                {
                    CaptionML = //@@@='{Locked}';
                    ENU = 'TotalSalesAmount',
                    ESP = 'TotalSalesAmount';
                    //MethodType=Totals;
                    Method = Sum;
                }
                Filter(dateFilter; "Posting Date")
                {
                    CaptionML = //@@@='{Locked';
                    ENU = 'DateFilter',
                    ESP = 'DateFilte';
                }
            }
        }
    }


    /*begin
    end.
  */
}





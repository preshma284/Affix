query 50228 "Vendor Purchases Entity 1"
{


    //Caption = 'vendorPurchases',Locked=true;
    CaptionML = //@@@='Locked';
    ENU = 'vendorPurchases',
    ESP = 'vendorPurchases';
    EntitySetName = 'vendorPurchases';
    EntityName = 'vendorPurchase';
    QueryType = API;

    elements
    {

        DataItem("Vendor"; "Vendor")
        {

            Column(vendorId; SystemId)
            {
                CaptionML = //@@@='{Locked}';
                ENU = 'Id',
                ESP = 'Id';
            }
            Column(vendorNumber; "No.")
            {
                CaptionML = //@@@='{Locked}';
                ENU = 'No',
                ESP = 'No';
            }
            Column(name; "Name")
            {
                CaptionML = //@@@='{Locked}';
                ENU = 'Name',
                ESP = 'Name';
            }
            DataItem("Vendor_Ledger_Entry"; "Vendor Ledger Entry")
            {

                DataItemLink = "Vendor No." = Vendor."No.";
                //Added from Base Query
                //SqlJoinType=LeftOuterJoin;
                //DataItemLinkType=SQL Advanced Options;
                Column(totalPurchaseAmount; "Purchase (LCY)")
                {
                    CaptionML = //@@@='{Locked}';
                    ENU = 'TotalPurchaseAmount',
                    ESP = 'TotalPurchaseAmount';
                    ReverseSign = false;
                    //MethodType=Totals;
                    Method = Sum;
                }
                Filter(dateFilter; "Posting Date")
                {
                    CaptionML =// @@@='{Locked';
                    ENU = 'DateFilter',
                    ESP = 'DateFilter';
                }
            }
        }
    }


    /*begin
    end.
  */
}





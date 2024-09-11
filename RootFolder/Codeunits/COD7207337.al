Codeunit 7207337 "Get Orders Job"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE GetOrdersJob(HeaderJobReception : Record 7207410);
    VAR
      PurchaseHeader : Record 38;
      // GetOrderPurchaseJob : Report 7207402;
      PurchaseList : Page 53;
    BEGIN
      HeaderJobReception.FIND;

      PurchaseHeader.FILTERGROUP(2);
      PurchaseHeader.SETRANGE("QB Job No.",HeaderJobReception."Job No.");
      PurchaseHeader.SETRANGE("Buy-from Vendor No.",HeaderJobReception."Vendor No.");
      PurchaseHeader.SETRANGE(Status,PurchaseHeader.Status::Released);
      PurchaseHeader.SETRANGE("Document Type",PurchaseHeader."Document Type"::Order);
      PurchaseHeader.FILTERGROUP(0);

      PurchaseList.LOOKUPMODE(TRUE);
      PurchaseList.SETTABLEVIEW(PurchaseHeader);
      IF PurchaseList.RUNMODAL <> ACTION::LookupOK THEN
        EXIT;
      PurchaseList.GetResult(PurchaseHeader);
      // GetOrderPurchaseJob.GetHeaderRecpJob(HeaderJobReception);
      // GetOrderPurchaseJob.USEREQUESTPAGE(FALSE);
      // GetOrderPurchaseJob.SETTABLEVIEW(PurchaseHeader);
      // GetOrderPurchaseJob.RUNMODAL;
    END;

    /* /*BEGIN
END.*/
}








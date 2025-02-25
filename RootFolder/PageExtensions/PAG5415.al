pageextension 50227 MyExtension5415 extends 5415//5401
{
layout
{
addafter("Item.""Scheduled Need (Qty.)""")
{
    field("QB_QuantityInJobsPurchaseNeeds";Item."QB Quantity Planned Purchase")
    {
        
                CaptionML=ESP='Cantidad necesidades Proyectos';
                
                             ;trigger OnDrillDown()    BEGIN
                              ShowneedPurchaseJob;
                            END;


}
}

}

actions
{


}

//trigger

//trigger

var
      Item : Record 27;
      ItemAvailFormsMgt : Codeunit 353;
      ExpectedInventory : Decimal;
      QtyAvailable : Decimal;
      AmountType: Option "Net Change","Balance at Date";
      PlannedOrderReleases : Decimal;
      GrossRequirement : Decimal;
      PlannedOrderRcpt : Decimal;
      ScheduledRcpt : Decimal;
      ProjAvailableBalance : Decimal;
      PeriodStart : Date;
      PeriodEnd : Date;

    

//procedure
//procedure Set(var NewItem : Record 27;NewAmountType: Option "Net Change","Balance at Date");
//    begin
//      Item.COPY(NewItem);
//      PeriodStart := Item.GETRANGEMIN("Date Filter");
//      PeriodEnd := Item.GETRANGEMAX("Date Filter");
//      AmountType := NewAmountType;
//      CurrPage.UPDATE(FALSE);
//    end;
Local procedure SetItemFilter();
   begin
     if ( AmountType = AmountType::"Net Change"  )then
       Item.SETRANGE("Date Filter",PeriodStart,PeriodEnd)
     ELSE
       Item.SETRANGE("Date Filter",0D,PeriodEnd);
     Item.SETRANGE("Variant Filter",rec."Code");
   end;
//Local procedure ShowItemAvailLineList(What : Integer);
//    begin
//      SetItemFilter;
//      ItemAvailFormsMgt.ShowItemAvailLineList(Item,What);
//    end;
//Local procedure CalcAvailQuantities(var GrossRequirement : Decimal;var PlannedOrderRcpt : Decimal;var ScheduledRcpt : Decimal;var PlannedOrderReleases : Decimal;var ProjAvailableBalance : Decimal;var ExpectedInventory : Decimal;var QtyAvailable : Decimal);
//    begin
//      SetItemFilter;
//      ItemAvailFormsMgt.CalcAvailQuantities(
//        Item,AmountType = AmountType::"Balance at Date",
//        GrossRequirement,PlannedOrderRcpt,ScheduledRcpt,
//        PlannedOrderReleases,ProjAvailableBalance,ExpectedInventory,QtyAvailable);
//    end;
LOCAL procedure ShowneedPurchaseJob();
    var
      QBPagePublisher : Codeunit 7207348;
      FunctionQB : Codeunit 7207272;
    begin
      if ( FunctionQB.AccessToQuobuilding  )then begin
        SetItemFilter;
        QBPagePublisher.ShowPurchaseJobPItemAvailabilityLines(Item);
      end;
    end;

//procedure
}


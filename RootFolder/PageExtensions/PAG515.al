pageextension 50218 MyExtension515 extends 515//14
{
layout
{
addafter("Item.""Scheduled Need (Qty.)""")
{
    field("QB_QuantityPlannedPurchase";Item."QB Quantity Planned Purchase")
    {
        
                
                             ;trigger OnDrillDown()    BEGIN
                              QB_ShowNeedPurchaseJob;//QB
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
      LocationCode : Code[10];
      "---------------------------- QB" : Integer;
      QBPagePublisher : Codeunit 7207348;
      FunctionQB : Codeunit 7207272;

    

//procedure
//procedure Set(var NewItem : Record 27;NewAmountType: Option "Net Change","Balance at Date");
//    begin
//      Item.COPY(NewItem);
//      PeriodStart := Item.GETRANGEMIN("Date Filter");
//      PeriodEnd := Item.GETRANGEMAX("Date Filter");
//      AmountType := NewAmountType;
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure SetItemFilter();
//    begin
//      if ( AmountType = AmountType::"Net Change"  )then
//        Item.SETRANGE("Date Filter",PeriodStart,PeriodEnd)
//      ELSE
//        Item.SETRANGE("Date Filter",0D,PeriodEnd);
//      LocationCode := rec."Code";
//      Item.SETRANGE("Location Filter",rec."Code");
//    end;
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
LOCAL procedure "------------------------------------ QB"();
    begin
    end;
procedure QB_ShowNeedPurchaseJob();
    begin
      if ( FunctionQB.AccessToQuobuilding  )then begin
        SetItemFilter;
        QBPagePublisher.ShowPurchaseJobPItemAvailabilityLines(Item);
      end
    end;

//procedure
}


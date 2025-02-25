pageextension 50176 MyExtension353 extends 353//2000000007
{
layout
{
addafter("Item.""Net Change""")
{
    field("QB_QuantityPlannedPurchase";Item."QB Quantity Planned Purchase")
    {
        
                CaptionML=ESP='Cantidad necesidades Proyectos';
                Editable=FALSE;
                
                             

  ;trigger OnDrillDown()    BEGIN
                              ShowPurchaseJob;
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
      PeriodFormMgt : Codeunit 50324; //change from 359
      PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
      AmountType: Option "Net Change","Balance at Date";
      ExpectedInventory : Decimal;
      QtyAvailable : Decimal;
      PlannedOrderReleases : Decimal;
      GrossRequirement : Decimal;
      PlannedOrderRcpt : Decimal;
      ScheduledRcpt : Decimal;
      ProjAvailableBalance : Decimal;
      QBPagePublisher : Codeunit 7207348;

    

//procedure
//procedure Set(var NewItem : Record 27;NewPeriodType : Integer;NewAmountType: Option "Net Change","Balance at Date");
//    begin
//      Item.COPY(NewItem);
//      PeriodType := NewPeriodType;
//      AmountType := NewAmountType;
//      CurrPage.UPDATE(FALSE);
//
//      OnAfterSet(Item,PeriodType,AmountType);
//    end;
Local procedure SetItemFilter();
   begin
     if ( AmountType = AmountType::"Net Change"  )then
       Item.SETRANGE("Date Filter",rec."Period Start",rec."Period end")
     ELSE
       Item.SETRANGE("Date Filter",0D,rec."Period end");
     OnAfterSetItemFilter(Item,rec."Period Start",rec."Period end");
   end;
//Local procedure ShowItemAvailLineList(What : Integer);
//    begin
//      SetItemFilter;
//      ItemAvailFormsMgt.ShowItemAvailLineList(Item,What);
//    end;
//Local procedure CalcAvailQuantities(var Item : Record 27;var GrossRequirement : Decimal;var PlannedOrderRcpt : Decimal;var ScheduledRcpt : Decimal;var PlannedOrderReleases : Decimal;var ProjAvailableBalance : Decimal;var ExpectedInventory : Decimal;var QtyAvailable : Decimal);
//    begin
//      SetItemFilter;
//      ItemAvailFormsMgt.CalcAvailQuantities(
//        Item,AmountType = AmountType::"Balance at Date",
//        GrossRequirement,PlannedOrderRcpt,ScheduledRcpt,
//        PlannedOrderReleases,ProjAvailableBalance,ExpectedInventory,QtyAvailable);
//    end;
//
//    [Integration]
//Local procedure OnAfterSet(var Item : Record 27;PeriodType : Integer;AmountType: Option "Net Change","Balance at Date");
//    begin
//    end;
//
  //  [IntegrationEvent(false,false)]
Local procedure OnAfterSetItemFilter(var Item : Record 27;PeriodStart : Date;PeriodEnd : Date);
   begin
   end;
LOCAL procedure ShowPurchaseJob();
    var
      FunctionQB : Codeunit 7207272;
    begin
      if ( FunctionQB.AccessToQuobuilding  )then begin//QB
        SetItemFilter;
        QBPagePublisher.ShowPurchaseJobPItemAvailabilityLines(Item);//QB
      end//QB
    end;

//procedure
}


pageextension 50121 MyExtension128 extends 128//25
{
layout
{
addafter("Description")
{
    field("QB Job No.";rec."QB Job No.")
    {
        
}
    field("QB Budget Item";rec."QB Budget Item")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      TempDetailedVendLedgEntry : Record 380 TEMPORARY ;
      DimensionSetIDFilter : Page 481;
      StyleTxt : Text;
      AmountFCY : Decimal;
      AmountLCY : Decimal;
      RemainingAmountFCY : Decimal;
      RemainingAmountLCY : Decimal;
      OriginalAmountLCY : Decimal;
      OriginalAmountFCY : Decimal;

    

//procedure
//procedure Set(var TempVendLedgerEntry : Record 25 TEMPORARY ;var TempDetailedVendLedgEntry2 : Record 380 TEMPORARY );
//    begin
//      if ( TempVendLedgerEntry.FINDSET  )then
//        repeat
//          Rec := TempVendLedgerEntry;
//          Rec.INSERT;
//        until TempVendLedgerEntry.NEXT = 0;
//
//      if ( TempDetailedVendLedgEntry2.FINDSET  )then
//        repeat
//          TempDetailedVendLedgEntry := TempDetailedVendLedgEntry2;
//          TempDetailedVendLedgEntry.INSERT;
//        until TempDetailedVendLedgEntry2.NEXT = 0;
//    end;
//Local procedure CalcAmounts(var AmountFCY : Decimal;var AmountLCY : Decimal;var RemainingAmountFCY : Decimal;var RemainingAmountLCY : Decimal;var OriginalAmountFCY : Decimal;var OriginalAmountLCY : Decimal);
//    begin
//      AmountFCY := 0;
//      AmountLCY := 0;
//      RemainingAmountLCY := 0;
//      RemainingAmountFCY := 0;
//      OriginalAmountLCY := 0;
//      OriginalAmountFCY := 0;
//
//      TempDetailedVendLedgEntry.SETRANGE("Vendor Ledger Entry No.",rec."Entry No.");
//      if ( TempDetailedVendLedgEntry.FINDSET  )then
//        repeat
//          if ( TempDetailedVendLedgEntry."Entry Type" = TempDetailedVendLedgEntry."Entry Type"::"Initial Entry"  )then begin
//            OriginalAmountFCY += TempDetailedVendLedgEntry.Amount;
//            OriginalAmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
//          end;
//          if not (TempDetailedVendLedgEntry."Entry Type" IN [TempDetailedVendLedgEntry."Entry Type"::Application,
//                                                             TempDetailedVendLedgEntry."Entry Type"::"Appln. Rounding"])
//          then begin
//            AmountFCY += TempDetailedVendLedgEntry.Amount;
//            AmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
//          end;
//          RemainingAmountFCY += TempDetailedVendLedgEntry.Amount;
//          RemainingAmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
//        until TempDetailedVendLedgEntry.NEXT = 0;
//    end;
//Local procedure DrilldownAmounts(AmountType: Option "Amount","Remaining Amount","Original Amount");
//    var
//      DetailedVendEntriesPreview : Page 129;
//    begin
//      CASE AmountType OF
//        AmountType::"Amount":
//          TempDetailedVendLedgEntry.SETFILTER("Entry Type",'<>%1&<>%2',
//            TempDetailedVendLedgEntry."Entry Type"::Application,TempDetailedVendLedgEntry."Entry Type"::"Appln. Rounding");
//        AmountType::"Original Amount":
//          TempDetailedVendLedgEntry.SETRANGE("Entry Type",TempDetailedVendLedgEntry."Entry Type"::"Initial Entry");
//        AmountType::"Remaining Amount":
//          TempDetailedVendLedgEntry.SETRANGE("Entry Type");
//      end;
//      DetailedVendEntriesPreview.Set(TempDetailedVendLedgEntry);
//      DetailedVendEntriesPreview.RUNMODAL;
//      CLEAR(DetailedVendEntriesPreview);
//    end;

//procedure
}


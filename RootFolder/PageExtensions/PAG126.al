pageextension 50120 MyExtension126 extends 126//21
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
      TempDetailedCustLedgEntry : Record 379 TEMPORARY ;
      DimensionSetIDFilter : Page 481;
      StyleTxt : Text;
      AmountFCY : Decimal;
      AmountLCY : Decimal;
      RemainingAmountFCY : Decimal;
      RemainingAmountLCY : Decimal;
      OriginalAmountLCY : Decimal;
      OriginalAmountFCY : Decimal;

    

//procedure
//procedure Set(var TempCustLedgerEntry : Record 21 TEMPORARY ;var TempDetailedCustLedgEntry2 : Record 379 TEMPORARY );
//    begin
//      if ( TempCustLedgerEntry.FINDSET  )then
//        repeat
//          Rec := TempCustLedgerEntry;
//          Rec.INSERT;
//        until TempCustLedgerEntry.NEXT = 0;
//
//      if ( TempDetailedCustLedgEntry2.FIND('-')  )then
//        repeat
//          TempDetailedCustLedgEntry := TempDetailedCustLedgEntry2;
//          TempDetailedCustLedgEntry.INSERT;
//        until TempDetailedCustLedgEntry2.NEXT = 0;
//    end;
//
//    //[External]
//procedure CalcAmounts();
//    begin
//      AmountFCY := 0;
//      AmountLCY := 0;
//      RemainingAmountLCY := 0;
//      RemainingAmountFCY := 0;
//      OriginalAmountLCY := 0;
//      OriginalAmountFCY := 0;
//
//      TempDetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",rec."Entry No.");
//      if ( TempDetailedCustLedgEntry.FINDSET  )then
//        repeat
//          if ( TempDetailedCustLedgEntry."Entry Type" = TempDetailedCustLedgEntry."Entry Type"::"Initial Entry"  )then begin
//            OriginalAmountFCY += TempDetailedCustLedgEntry.Amount;
//            OriginalAmountLCY += TempDetailedCustLedgEntry."Amount (LCY)";
//          end;
//          if not (TempDetailedCustLedgEntry."Entry Type" IN [TempDetailedCustLedgEntry."Entry Type"::Application,
//                                                             TempDetailedCustLedgEntry."Entry Type"::"Appln. Rounding"])
//          then begin
//            AmountFCY += TempDetailedCustLedgEntry.Amount;
//            AmountLCY += TempDetailedCustLedgEntry."Amount (LCY)";
//          end;
//          RemainingAmountFCY += TempDetailedCustLedgEntry.Amount;
//          RemainingAmountLCY += TempDetailedCustLedgEntry."Amount (LCY)";
//        until TempDetailedCustLedgEntry.NEXT = 0;
//    end;
//Local procedure DrilldownAmounts(AmountType: Option "Amount","Remaining Amount","Original Amount");
//    var
//      DetCustLedgEntrPreview : Page 127;
//    begin
//      CASE AmountType OF
//        AmountType::"Amount":
//          TempDetailedCustLedgEntry.SETFILTER("Entry Type",'<>%1&<>%2',
//            TempDetailedCustLedgEntry."Entry Type"::Application,TempDetailedCustLedgEntry."Entry Type"::"Appln. Rounding");
//        AmountType::"Original Amount":
//          TempDetailedCustLedgEntry.SETRANGE("Entry Type",TempDetailedCustLedgEntry."Entry Type"::"Initial Entry");
//        AmountType::"Remaining Amount":
//          TempDetailedCustLedgEntry.SETRANGE("Entry Type");
//      end;
//      DetCustLedgEntrPreview.Set(TempDetailedCustLedgEntry);
//      DetCustLedgEntrPreview.RUNMODAL;
//      CLEAR(DetCustLedgEntrPreview);
//    end;

//procedure
}


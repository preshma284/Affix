pageextension 50167 MyExtension284 extends 284//221
{
layout
{
addafter("Shortcut Dimension 2 Code")
{
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_PieceworkCode";rec."Piecework Code")
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
      AllocationAmount : Decimal;
      TotalAllocationAmount : Decimal;
      ShowAllocationAmount : Boolean;
      ShowTotalAllocationAmount : Boolean;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      AllocationAmountVisible : Boolean ;
      TotalAllocationAmountVisible : Boolean ;

    
    

//procedure
//Local procedure UpdateAllocationAmount();
//    var
//      TempGenJnlAlloc : Record 221;
//    begin
//      TempGenJnlAlloc.COPYFILTERS(Rec);
//      ShowTotalAllocationAmount := TempGenJnlAlloc.CALCSUMS("Amount");
//      if ( ShowTotalAllocationAmount  )then begin
//        TotalAllocationAmount := TempGenJnlAlloc.Amount;
//        if ( rec."Line No." = 0  )then
//          TotalAllocationAmount := TotalAllocationAmount + xRec.Amount;
//      end;
//
//      if ( rec."Line No." <> 0  )then begin
//        TempGenJnlAlloc.SETRANGE("Line No.",0,rec."Line No.");
//        ShowAllocationAmount := TempGenJnlAlloc.CALCSUMS("Amount");
//        if ( ShowAllocationAmount  )then
//          AllocationAmount := TempGenJnlAlloc.Amount;
//      end ELSE begin
//        TempGenJnlAlloc.SETRANGE("Line No.",0,xRec."Line No.");
//        ShowAllocationAmount := TempGenJnlAlloc.CALCSUMS("Amount");
//        if ( ShowAllocationAmount  )then begin
//          AllocationAmount := TempGenJnlAlloc.Amount;
//          TempGenJnlAlloc.COPYFILTERS(Rec);
//          TempGenJnlAlloc := xRec;
//          if ( TempGenJnlAlloc.NEXT = 0  )then
//            AllocationAmount := AllocationAmount + xRec.Amount;
//        end;
//      end;
//
//      AllocationAmountVisible := ShowAllocationAmount;
//      TotalAllocationAmountVisible := ShowTotalAllocationAmount;
//    end;
//Local procedure AllocationQuantityOnAfterValid();
//    begin
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure Allocation37OnAfterValidate();
//    begin
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure AmountOnAfterValidate();
//    begin
//      CurrPage.UPDATE(FALSE);
//    end;

//procedure
}


query 50230 "Item Analysis View Source 1"
{
  
  
    CaptionML=ENU='Item Analysis View Source',ESP='Origen de vista de an lisis de producto';
  
  elements
{

DataItem(ItemAnalysisView;"Item Analysis View")
{

Filter(AnalysisArea;"Analysis Area")
{

}Filter(AnalysisViewCode;"Code")
{

}DataItem(ValueEntry;"Value Entry")
{

               //DataItemLinkType=SQL Advanced Options;
               SQLJoinType=CrossJoin;
Filter(EntryNo;"Entry No.")
{

}Column(ItemNo;"Item No.")
{

}Column(SourceType;"Source Type")
{

}Column(SourceNo;"Source No.")
{

}Column(EntryType;"Entry Type")
{

}Column(ItemLedgerEntryType;"Item Ledger Entry Type")
{

}Column(ItemLedgerEntryNo;"Item Ledger Entry No.")
{

}Column(ItemChargeNo;"Item Charge No.")
{

}Column(LocationCode;"Location Code")
{

}Column(PostingDate;"Posting Date")
{

}Column(DimensionSetID;"Dimension Set ID")
{

}Column(ILEQuantity;"Item Ledger Entry Quantity")
{

               //MethodType=Totals;
               Method=Sum;
}Column(InvoicedQuantity;"Invoiced Quantity")
{

               //MethodType=Totals;
               Method=Sum;
}Column(SalesAmountActual;"Sales Amount (Actual)")
{

               //MethodType=Totals;
               Method=Sum;
}Column(SalesAmountExpected;"Sales Amount (Expected)")
{

               //MethodType=Totals;
               Method=Sum;
}Column(CostAmountActual;"Cost Amount (Actual)")
{

               //MethodType=Totals;
               Method=Sum;
}Column(CostAmountNonInvtbl;"Cost Amount (Non-Invtbl.)")
{

               //MethodType=Totals;
               Method=Sum;
}Column(CostAmountExpected;"Cost Amount (Expected)")
{

               //MethodType=Totals;
               Method=Sum;
}DataItem(DimSet1;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "ValueEntry"."Dimension Set ID",
                            "Dimension Code"= "ItemAnalysisView"."Dimension 1 Code";
Column(DimVal1;"Dimension Value Code")
{

}DataItem(DimSet2;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "ValueEntry"."Dimension Set ID",
                            "Dimension Code"= "ItemAnalysisView"."Dimension 2 Code";
Column(DimVal2;"Dimension Value Code")
{

}DataItem(DimSet3;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "ValueEntry"."Dimension Set ID",
                            "Dimension Code"= "ItemAnalysisView"."Dimension 3 Code";
Column(DimVal3;"Dimension Value Code")
{

}
}
}
}
}
}
}
  

    /*begin
    end.
  */
}





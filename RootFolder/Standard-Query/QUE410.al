query 50203 "Analysis View Source 1"
{
  
  
    CaptionML=ENU='Analysis View Source',ESP='Origen de vista de an lisis';
  
  elements
{

DataItem("Analysis_View";"Analysis View")
{

Filter(AnalysisViewCode;"Code")
{

}DataItem("G_L_Entry";"G/L Entry")
{

               //DataItemLinkType=SQL Advanced Options;
               SQLJoinType=CrossJoin;
Filter(EntryNo;"Entry No.")
{

}Column(GLAccNo;"G/L Account No.")
{

}Column(BusinessUnitCode;"Business Unit Code")
{

}Column(PostingDate;"Posting Date")
{

}Column(DimensionSetID;"Dimension Set ID")
{

}Column(Amount;"Amount")
{

               //MethodType=Totals;
               Method=Sum;
}Column(DebitAmount;"Debit Amount")
{

               //MethodType=Totals;
               Method=Sum;
}Column(CreditAmount;"Credit Amount")
{

               //MethodType=Totals;
               Method=Sum;
}Column(AmountACY;"Additional-Currency Amount")
{

               //MethodType=Totals;
               Method=Sum;
}Column(DebitAmountACY;"Add.-Currency Debit Amount")
{

               //MethodType=Totals;
               Method=Sum;
}Column(CreditAmountACY;"Add.-Currency Credit Amount")
{

               //MethodType=Totals;
               Method=Sum;
}DataItem(DimSet1;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "G_L_Entry"."Dimension Set ID",
                            "Dimension Code"= "Analysis_View"."Dimension 1 Code";
Column(DimVal1;"Dimension Value Code")
{

}DataItem(DimSet2;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "G_L_Entry"."Dimension Set ID",
                            "Dimension Code"= "Analysis_View"."Dimension 2 Code";
Column(DimVal2;"Dimension Value Code")
{

}DataItem(DimSet3;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "G_L_Entry"."Dimension Set ID",
                            "Dimension Code"= "Analysis_View"."Dimension 3 Code";
Column(DimVal3;"Dimension Value Code")
{

}DataItem(DimSet4;"Dimension Set Entry")
{

DataItemLink="Dimension Set ID"= "G_L_Entry"."Dimension Set ID",
                            "Dimension Code"= "Analysis_View"."Dimension 4 Code";
Column(DimVal4;"Dimension Value Code")
{

}
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





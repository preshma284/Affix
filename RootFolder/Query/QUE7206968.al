query 50147 "QB BI Cobros v2"
{
  
  
  elements
{

DataItem("Cust_Ledger_Entry";"Cust. Ledger Entry")
{

Column("EntryNo";"Entry No.")
{

}Column("CustomerNo";"Customer No.")
{

}Column("PostingDate";"Posting Date")
{

}Column("DocumentType";"Document Type")
{

}Column("DocumentNo";"Document No.")
{

}Column("Amount";"Amount")
{

}Column("RemainingAmount";"Remaining Amount")
{

}DataItem("Detailed_Cust_Ledg_Entry";"Detailed Cust. Ledg. Entry")
{

               DataItemTableFilter="Applied Cust. Ledger Entry No."=FILTER(<>0),
                                   "Unapplied"=FILTER(false);
DataItemLink="Cust. Ledger Entry No."= "Cust_Ledger_Entry"."Entry No.";
               //DataItemLinkType=SQL Advanced Options;
               SQLJoinType=LeftOuterJoin;
Column("AppliedCustLedgerEntryNo";"Applied Cust. Ledger Entry No.")
{

}DataItem(Appl;"Cust. Ledger Entry")
{

DataItemLink="Entry No."= "Detailed_Cust_Ledg_Entry"."Applied Cust. Ledger Entry No.";
Column(Appl_Entry_No;"Entry No.")
{

}Column(Appl_Customer_No;"Customer No.")
{

}Column(Appl_Posting_Date;"Posting Date")
{

}Column(Appl_Document_Type;"Document Type")
{

}Column(Appl_Document_No;"Document No.")
{

}Column(Appl_Amount;"Amount")
{

}Column(Appl_Remaining_Amount;"Remaining Amount")
{

}
}
}
}
}
  

    /*begin
    end.
  */
}









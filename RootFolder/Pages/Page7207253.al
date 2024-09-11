page 7207253 "QB BI Cobros v2 SubPage"
{
SourceTable=379;
    SourceTableView=WHERE("Applied Cust. Ledger Entry No."=FILTER(<>0),"Unapplied"=FILTER(false));
    PageType=List;
    // EntitySetName=Cobros v2 SubPage;
    // EntityName=Cobros v2;
  layout
{
area(content)
{
group("General")
{
    field("Applied Cust. Ledger Entry No.";rec."Applied Cust. Ledger Entry No.")
    {
        
    }
    part("part1";7207255)
    {
        SubPageLink="Entry No."=FIELD("Applied Cust. Ledger Entry No.");
    }

}

}
}
  

    /*begin
    end.
  
*/
}








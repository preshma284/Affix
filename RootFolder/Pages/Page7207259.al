page 7207259 "QB BI Data Piecework for Prod."
{
SourceTable=7207386;
    SourceTableView=WHERE("Account Type"=FILTER("Unit"),"Customer Certification Unit"=FILTER(true));
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Sale Amount";rec."Sale Amount")
    {
        
    }
    field("Piecework Code";rec."Piecework Code")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}








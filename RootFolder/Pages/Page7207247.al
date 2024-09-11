page 7207247 "QB BI Certificaciones"
{
SourceTable=7207341;
    SourceTableView=WHERE("Cancel No."=FILTER(''),"Cancel By"=FILTER(''));
    PageType=Card;
  layout
{
area(content)
{
group("General")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Measurement Date";rec."Measurement Date")
    {
        
    }
    part("Hist. Certification Lines";7207258)
    {
        SubPageLink="Document No."=FIELD("No.");
    }

}

}
}
  

    /*begin
    end.
  
*/
}








page 7207053 "QB Price x job reviews"
{
  ApplicationArea=All;

CaptionML=ENU='Price x job reviews',ESP='Revisiones precio x proyecto';
    SourceTable=7206965;
    PopulateAllFields=true;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Review code";rec."Review code")
    {
        
    }
    field("Percentage";rec."Percentage")
    {
        
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.AccessToServiceOrder(TRUE);
               END;



    var
      FunctionQB : Codeunit 7207272;

    /*begin
    end.
  
*/
}









page 7207055 "QB Gropuing Criteria List"
{
  ApplicationArea=All;

CaptionML=ENU='QB Grouping Criteria',ESP='Criterios de agrupaci¢n';
    SourceTable=7207406;
    SourceTableView=SORTING("Code");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Name";rec."Name")
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









page 7206954 "QB External Worksheet FB Pos"
{
Editable=false;
    CaptionML=ENU='Posted Worksheet Statistic',ESP='Estadística parte registrado';
    SourceTable=7206935;
    PageType=CardPart;
    
  layout
{
area(content)
{
    field("Amount";rec."Amount")
    {
        
    }
    field("No. Hours";rec."No. Hours")
    {
        
    }
    field("Allocation Term";rec."Allocation Term")
    {
        
                CaptionML=ENU='Allocation Term',ESP='Periodo de imputación';
    }

}
}
  
trigger OnAfterGetRecord()    BEGIN
                       CLEARALL;
                     END;




    /*begin
    end.
  
*/
}









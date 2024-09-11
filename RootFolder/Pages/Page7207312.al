page 7207312 "Quobulding Activity List"
{
CaptionML=ENU='Quobulding Activity List',ESP='Lista Actividades Quobuilding';
    SourceTable=7207280;
    PageType=List;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Activity Code";rec."Activity Code")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Evaluation Type";rec."Evaluation Type")
    {
        
    }
    field("Posting Group Product";rec."Posting Group Product")
    {
        
    }
    field("Posting Group Stock";rec."Posting Group Stock")
    {
        
    }
    field("Cod. Resource Subcontracting";rec."Cod. Resource Subcontracting")
    {
        
    }

}

}
}
  /*

    begin
    {
      JAV 21/09/19: - Se a¤ade la columna rec."Evaluation Type", que indica si se usar  para poder evaluar que sean servicios, productos u otros
    }
    end.*/
  

}








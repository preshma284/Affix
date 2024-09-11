page 7206961 "QB Job Task Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Job Task Setup',ESP='Configurar Tareas de Proyecto';
    SourceTable=7206902;
    SourceTableView=SORTING("Job Type","Status","Order");
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
                Visible=False ;
    }
    field("Job Type";rec."Job Type")
    {
        
    }
    field("Status";rec."Status")
    {
        
    }
    field("Order";rec."Order")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Approval Circuit";rec."Approval Circuit")
    {
        
    }
    field("Mandatory before the rest";rec."Mandatory before the rest")
    {
        
                ToolTipML=ESP='Si se marca esta casilla, es obligatorio establecer este estado antes de los siguientes, si no se marca es independiente';
    }
    field("Erasable with Rec.NEXT";rec."Erasable with NEXT")
    {
        
                ToolTipML=ESP='Si se marca esta casilla, se puede borrar el estado aunque el siguiente est� informado, si no se mcarca es independiente';
    }
    field("Perform Type";rec."Perform Type")
    {
        
    }
    field("Perform Object";rec."Perform Object")
    {
        
    }
    field("Cancel Type";rec."Cancel Type")
    {
        
    }
    field("Cancel Object";rec."Cancel Object")
    {
        
    }

}

}
}actions
{
area(Processing)
{


}
}
  

    /*begin
    end.
  
*/
}










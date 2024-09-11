page 7207040 "QB Approval Circuit List"
{
CaptionML=ENU='Approval Circuit List',ESP='Lista de Circuitos de Aprobaci¢n';
    SourceTable=7206986;
    PageType=List;
    CardPageID="QB Approval Circuit Header";
  layout
{
area(content)
{
repeater("Group")
{
        
                Editable=FALSE;
    field("Circuit Code";rec."Circuit Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Approval By";rec."Approval By")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("CA";rec."CA")
    {
        
    }
    field("Department";rec."Department")
    {
        
    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=TRUE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=TRUE;
    }

}
}
  /*

    begin
    {
      JAV 21/03/22: - QB 1.10.26 Se a¤ade el campo 12 rec."Approval By" para el tipo de condicionantes de la aprobaci¢n proyecto o departamento
    }
    end.*/
  

}








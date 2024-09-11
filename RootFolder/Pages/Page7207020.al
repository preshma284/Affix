page 7207020 "QPR Budget Template List"
{
  ApplicationArea=All;

CaptionML=ENU='Budget Template List',ESP='Lista de Plantillas de Presupuesto';
    SourceTable=7206980;
    PageType=List;
    CardPageID="QPR Budget Template Card";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Template Code";rec."Template Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }

}

}
}
  
    var
      QB_QPRCostGroupLine : Record 7206981;
      QB_QPRCostGroupCard : Page 7207021;/*

    begin
    {
      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a¤ade activable
    }
    end.*/
  

}









page 7207023 "QPR Budget Template SubForm"
{
CaptionML=ENU='Budget Template Card',ESP='Ficha de Plantilla de Presupuesto';
    SourceTable=7206981;
    PageType=ListPart;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Account Type";rec."Account Type")
    {
        
    }
    field("Indentation";rec."Indentation")
    {
        
    }
    field("Totaling";rec."Totaling")
    {
        
                Visible=false ;
    }
    field("QPR Type";rec."QPR Type")
    {
        
    }
    field("QPR No.";rec."QPR No.")
    {
        
    }
    field("QPR Name";rec."QPR Name")
    {
        
    }
    field("QPR Use";rec."QPR Use")
    {
        
    }
    field("QPR Activable";rec."QPR Activable")
    {
        
                ToolTipML=ESP='Si se marca indica que se pueden generar gastos activables de esta partida presupuestaria (se generan siempre que el proyecto y el estado del mismo lo permitan)';
    }
    field("QPR AC";rec."QPR AC")
    {
        
    }
    field("QPR Gen Prod. Posting Group";rec."QPR Gen Prod. Posting Group")
    {
        
    }
    field("QPR Gen Posting Group";rec."QPR Gen Posting Group")
    {
        
    }
    field("QPR VAT Prod. Posting Group";rec."QPR VAT Prod. Posting Group")
    {
        
    }
    field("QPR Account No";rec."QPR Account No")
    {
        
    }

}

}
}
  /*

    begin
    {
      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a¤ade activable
    }
    end.*/
  

}








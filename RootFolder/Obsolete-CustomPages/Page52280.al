page 52280 "Outlook Synch. Setup Details"
{
CaptionML=ENU='Outlook Synch. Setup Details',ESP='Detalles config. sinc. Outlook';
    SourceTable=51288;
    DataCaptionExpression=GetFormCaption;
    DelayedInsert=true;
    PageType=List;
  layout
{
area(content)
{
repeater("Control1")
{
        
    field("Outlook Collection";rec."Outlook Collection")
    {
        
                DrillDown=false;
                ToolTipML=ENU='Specifies the name of the Outlook collection which is selected to be synchronized.',ESP='Especifica el nombre de la colecci¢n de Outlook seleccionada para su sincronizaci¢n.';
                ApplicationArea=Basic,Suite;
    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=FALSE;
    }

}
}
  

    //[External]
    procedure GetFormCaption() : Text[80];
    var
      OSynchEntity : Record 51280;
    begin
      OSynchEntity.GET(rec."Synch. Entity Code");
      exit(STRSUBSTNO('%1 %2',OSynchEntity.TABLECAPTION,rec."Synch. Entity Code"));
    end;

    // begin//end
}








page 7174659 "Library Types"
{
CaptionML=ENU='Library Types',ESP='Tipo Librer¡a';
    SourceTable=7174654;
    PageType=List;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Description";rec."Description")
    {
        
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Entry No.";rec."Entry No.")
    {
        
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Name";rec."Name")
    {
        
    }
    field("Internal Name";rec."Internal Name")
    {
        
    }
    field("Last Date Modified";rec."Last Date Modified")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("CreateValues")
    {
        
                      CaptionML=ENU='Create values',ESP='Crear valores';
                      RunObject=Page 7174661;
                      RunPageView=SORTING("Metadata Site Defs","Name");
RunPageLink="Metadata Site Defs"=FIELD("Metadata Site Defs"), "Name"=FIELD("Name");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Add;
                      PromotedCategory=Process;
                      PromotedOnly=true 
    ;
    }

}
}
  /*

    begin
    {
      QUONEXT 20.07.17 DRAG&DROP. Asociaci¢n del tipo de libreria a la definici¢n del documento.
    }
    end.*/
  

}









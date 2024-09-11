page 7174653 "Definition Metadata Line"
{
CaptionML=ENU='Definition Metadata Line',ESP='Definici¢n Metadatos del sitio Sharepoint';
    MultipleNewLines=true;
    SourceTable=7174652;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Internal Name";rec."Internal Name")
    {
        
    }
    field("Name";rec."Name")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Field Filter";rec."Field Filter")
    {
        
    }
    field("Field Group";rec."Field Group")
    {
        
    }
    field("Value Type";rec."Value Type")
    {
        
    }
    field("Value";rec."Value")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Name Fields";rec."Name Fields")
    {
        
                Style=Favorable;
                StyleExpr=TRUE ;
    }
    field("Type Field Sharepoint";rec."Type Field Sharepoint")
    {
        
    }

}

}
}
  /*

    begin
    {
      QUONEXT 20.07.17 DRAG&DROP. Definici¢n de los metadatos asociados a un site de sharepoint.
    }
    end.*/
  

}









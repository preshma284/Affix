page 7206915 "Job Attr. Value Translations"
{
CaptionML=ENU='Job Attribute Value Translations',ESP='Traducciones de valor de atributo de proyecto/estudio';
    SourceTable=7503;
    DataCaptionExpression=DynamicCaption;
    DelayedInsert=true;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Language Code";rec."Language Code")
    {
        
                ToolTipML=ENU='Specifies the language that is used when translating specified text on documents to foreign business partner, such as an Job description on an order confirmation.',ESP='Especifica el idioma que se usa al traducir el texto especificado en los documentos destinados a un socio comercial extranjero, como, por ejemplo, la descripci¢n del proyecto/estudio en una confirmaci¢n de pedido.';
                ApplicationArea=Basic,Suite;
                LookupPageID="Languages" ;
    }
    field("Name";rec."Name")
    {
        
                ToolTipML=ENU='Specifies the translated name of the Job attribute value.',ESP='Especifica el nombre traducido del valor de atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
    }

}

}
}
  trigger OnAfterGetCurrRecord()    BEGIN
                           UpdateWindowCaption
                         END;



    var
      DynamicCaption : Text;

    LOCAL procedure UpdateWindowCaption();
    var
      JobAttributeValue : Record 7501;
    begin
      if JobAttributeValue.GET(rec."Attribute ID",rec.ID) then
        DynamicCaption := JobAttributeValue.Value
      ELSE
        DynamicCaption := '';
    end;

    // begin
    /*{
      JAV 13/02/20: - Gesti¢n de atributos para proyectos
    }*///end
}









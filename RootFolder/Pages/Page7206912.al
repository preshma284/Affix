page 7206912 "Job Attribute Translations"
{
CaptionML=ENU='Job Attribute Translations',ESP='Traducciones de atributo de proyecto/estudio';
    SourceTable=7206907;
    DataCaptionFields="Attribute ID";
    PageType=List;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Language Code";rec."Language Code")
    {
        
                ToolTipML=ENU='Specifies the language that is used when translating specified text on documents to foreign business partner, such as an Job description on an order confirmation.',ESP='Especifica el idioma que se usa al traducir el texto especificado en los documentos destinados a un socio comercial extranjero, como, por ejemplo, la descripci¢n del proyecto/estudio en una confirmaci¢n de pedido.';
                ApplicationArea=Basic,Suite;
                LookupPageID="Languages" ;
    }
    field("Name";rec."Name")
    {
        
                ToolTipML=ENU='Specifies the translated name of the Job attribute.',ESP='Especifica el nombre traducido del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
    }

}

}
}
  /*

    begin
    {
      JAV 13/02/20: - Gesti¢n de atributos para proyectos
    }
    end.*/
  

}









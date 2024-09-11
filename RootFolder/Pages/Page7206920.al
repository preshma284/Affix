page 7206920 "Job Attribute Value Editor"
{
CaptionML=ENU='Job Attribute Values',ESP='Valores de atributo de proyecto/estudio';
    SourceTable=167;
    PageType=StandardDialog;
    
  layout
{
area(content)
{
    part("JobAttributeValueList";7206914)
    {
        
                ApplicationArea=Basic,Suite;
    }

}
}
  trigger OnOpenPage()    BEGIN
                 CurrPage.JobAttributeValueList.PAGE.LoadAttributes(rec."No.");
               END;


/*

    

begin
    {
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }
    end.*/
  

}









page 7207285 "Job Classification"
{
  ApplicationArea=All;

CaptionML=ENU='Job Classification',ESP='Clasificaci¢n de proyectos';
    SourceTable=7207276;
    PageType=List;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("Serie for Quotes";rec."Serie for Quotes")
    {
        
    }
    field("Serie for Jobs";rec."Serie for Jobs")
    {
        
    }

}

}
}
  /*

    begin
    {
      PGM 27/12/18: - QBA5412 A¤adido los campos de plazos
      JAV 01/12/21: - QB 1.10.04 Se eliminan los campos de plazos de la tabla Job Classification que no se utilizan para nada
      JAV 01/12/21: - QB 1.10.04 Se a¤aden los contadores para proyectos y Obras, si est  en blanco se us  el contador general
    }
    end.*/
  

}









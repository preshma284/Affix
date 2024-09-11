table 7206982 "QBU OLD_Responsibles Group Templat"
{
  
  
    CaptionML=ESP='Grupos de Plantillas de responsables';
  
  fields
{
    field(1;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Use in";Option)
    {
        OptionMembers="All","Jobs","QPR","RE";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Use in',ESP='Usar Para';
                                                   OptionCaptionML=ENU='All,Jobs,Budgets,Real Estate',ESP='Cualquiera,Proyectos,Presupuestos,Promoci¢n';
                                                   
                                                   Description='QB 1.10.09   JAV 19/12/21: [TT] Para que tipo proyectos puede usarse';


    }
    field(10;"Include";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Include',ESP='Incluir';
                                                   Description='QB 1.10.09   JAV 20/12/21: Campo temporal para seleccionar [TT] Maque las plantillas que desea incluir en el proyecto' ;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 25/02/22: - QB 1.10.22 ELIMINADO, se pasa al nuevo sistema de aprobaciones. No se borra porque se usa en el proceso de cambios de versiones
    }
    end.
  */
}








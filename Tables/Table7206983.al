table 7206983 "QBU OLD_Responsibles Group"
{
  
  
    CaptionML=ESP='Grupos de Responsables';
  
  fields
{
    field(1;"Type";Option)
    {
        OptionMembers="Job","Department","Budget";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='Job,Department,Budget',ESP='Proyecto,Departamento,Presupuestos';
                                                   
                                                   Description='JAV 23/10/20: - QB 1.07.00 Tipo de registro (Proyecto/Departamento)';


    }
    field(2;"Table Code";Code[20])
    {
        CaptionML=ENU='Job No.',ESP='C¢digo';


    }
    field(3;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='ID';
                                                   Description='JAV 13/01/19: - Id del registro, se usa para poder tener registros con los cargos duplicados';


    }
    field(10;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n'; ;


    }
}
  keys
{
    key(key1;"Type","Table Code","Code")
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








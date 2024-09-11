table 7206907 "Job Attribute Translation"
{
  
  
    CaptionML=ENU='Job Attribute Translation',ESP='Traducci¢n del atributo de proyecto/estudio';
  
  fields
{
    field(1;"Attribute ID";Integer)
    {
        TableRelation="Job Attribute";
                                                   CaptionML=ENU='Attribute ID',ESP='Id. de atributo';
                                                   NotBlank=true;


    }
    field(2;"Language Code";Code[10])
    {
        TableRelation="Language";
                                                   CaptionML=ENU='Language Code',ESP='C¢d. idioma';
                                                   NotBlank=true;


    }
    field(3;"Name";Text[250])
    {
        CaptionML=ENU='Name',ESP='Nombre'; ;


    }
}
  keys
{
    key(key1;"Attribute ID","Language Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 13/02/20: - Gesti¢n de atributos para proyectos
    }
    end.
  */
}








table 7207276 "Job Classification"
{
  
  
    CaptionML=ENU='Job classification',ESP='Clasificaci¢n de proyectos';
    LookupPageID="Job Classification";
    DrillDownPageID="Job Classification";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(10;"Serie for Quotes";Code[20])
    {
        TableRelation="No. Series";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ serie para Estudios';
                                                   Description='QB 1.10.04 - JAV 01/12/21: - Contador para proyectos, si est  en blanco se usa el general';


    }
    field(11;"Serie for Jobs";Code[20])
    {
        TableRelation="No. Series";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ serie para Obras';
                                                   Description='QB 1.10.04 - JAV 01/12/21: - Contador para obras, si est  en blanco se usa el general';


    }
    field(50000;"OLD_Start Quote Term";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Start Quote Term',ESP='Plazo comienzo estudio';
                                                   Description='### ELIMINAR ### No se utiliza';


    }
    field(50001;"OLD_Quote Execution Term";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Quote Execution Term',ESP='Plazo ejecuci¢n estudio';
                                                   Description='### ELIMINAR ### No se utiliza';


    }
    field(50002;"OLD_End Quote Term";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='End Quote Term',ESP='Plazo fin estudio';
                                                   Description='### ELIMINAR ### No se utiliza';


    }
    field(50003;"OLD_Sent Quote Term";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Sent Quote Term',ESP='Plazo oferta enviada';
                                                   Description='### ELIMINAR ### No se utiliza';


    }
    field(50004;"OLD_Resolution Term";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Resolution Term',ESP='Plazo resoluci¢n';
                                                   Description='### ELIMINAR ### No se utiliza' ;


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
      PGM 27/12/18: - QBA5412 A¤adido los campos de plazos
      JAV 01/12/21: - QB 1.10.04 Se eliminan los campos de plazos de la tabla Job Classification que no se utilizan para nada
      JAV 01/12/21: - QB 1.10.04 Se a¤aden los contadores para proyectos y Obras, si est  en blanco se us  el contador general
    }
    end.
  */
}








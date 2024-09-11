table 7206977 "QB_TipoRetencionIRPF"
{
  
  
    CaptionML=ESP='Tipos de Retenci¢n de IRPF';
    LookupPageID="QB_TiposRetencionIRPF";
    DrillDownPageID="QB_TiposRetencionIRPF";
  
  fields
{
    field(1;"QB_Codigo";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';
                                                   Description='QRE';


    }
    field(2;"QB_Descripcion";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n';
                                                   Description='QRE';


    }
    field(3;"QB_Clave";Code[1])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Clave';
                                                   Description='QRE';


    }
    field(4;"QB_Subclave";Code[2])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Subclave';
                                                   Description='QRE' ;


    }
}
  keys
{
    key(key1;"QB_Codigo")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}








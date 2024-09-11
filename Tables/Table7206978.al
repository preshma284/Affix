table 7206978 "QBU IRPF Statement Names"
{
  
  
    CaptionML=ESP='Declaraciones de IRPF';
  
  fields
{
    field(1;"QB_Declaration";Code[10])
    {
        DataClassification=ToBeClassified;


    }
    field(2;"QB_Description";Text[30])
    {
        DataClassification=ToBeClassified ;


    }
}
  keys
{
    key(key1;"QB_Declaration")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      CEI-15408-LCG-051021- Crear tabla y campos
    }
    end.
  */
}








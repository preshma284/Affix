table 7206914 "TAux Job Phases"
{
  
  
    CaptionML=ENU='Job Phases',ESP='Fases de proyecto';
    LookupPageID="TAux Job Phases List";
    DrillDownPageID="TAux Job Phases List";
  
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
                                                   CaptionML=ENU='Description',ESP='Descripci¢n'; ;


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
      JAV 14/09/22: - QB 1.11.02 Se a¤aden las p ginas de Lookup
    }
    end.
  */
}








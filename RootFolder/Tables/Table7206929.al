table 7206929 "QB Payments Phases"
{
  
  
    CaptionML=ENU='Payments Phases',ESP='Fases de pago';
    LookupPageID="QB Payment Phases List";
    DrillDownPageID="QB Payment Phases List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';


    }
    field(10;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n';


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
    end.
  */
}








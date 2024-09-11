table 7206989 "QB Position"
{
  
  
    CaptionML=ENU='Charge',ESP='Cargo';
    LookupPageID="QB Position List";
    DrillDownPageID="QB Position List";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[80])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(11;"Default Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nivel por defecto';


    }
    field(14;"No in Approvals";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No Aprueba';
                                                   Description='QB 1.10.36 JAV 22/04/22: [TT] Si se marca este campo, el usuario asociado a este cargo por defecto no interviene en las aprobaciones' ;


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








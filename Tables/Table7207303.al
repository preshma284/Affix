table 7207303 "QBU Sheet Improvement"
{
  
  
    CaptionML=ENU='Sheet Improvement',ESP='Mejora pliego';
    LookupPageID="Sheet Improvement";
    DrillDownPageID="Sheet Improvement";
  
  fields
{
    field(1;"Version Code";Code[20])
    {
        TableRelation="Job"."No.";
                                                   CaptionML=ENU='Version Code',ESP='Cod. Versi¢n';


    }
    field(2;"Number";Integer)
    {
        CaptionML=ENU='Number',ESP='N£mero';


    }
    field(3;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n'; ;


    }
}
  keys
{
    key(key1;"Version Code","Number")
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








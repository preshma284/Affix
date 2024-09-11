table 7207333 "QBU Reason for Rejection"
{
  
  
    CaptionML=ENU='Reason for Rejection',ESP='Motivos de rechazo';
    LookupPageID="Reason for Rejection List";
    DrillDownPageID="Reason for Rejection List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[30])
    {
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
    end.
  */
}








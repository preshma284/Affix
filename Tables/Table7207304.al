table 7207304 "QBU Penalization/Quote"
{
  
  
    CaptionML=ENU='Penalization/Quote',ESP='Penalizaci¢n/oferta';
    LookupPageID="Penalization/Quote";
    DrillDownPageID="Penalization/Quote";
  
  fields
{
    field(1;"Quote Code";Code[20])
    {
        TableRelation="Job"."No.";
                                                   CaptionML=ENU='Quote Code',ESP='Cod. oferta';


    }
    field(2;"Penalization Code";Code[10])
    {
        TableRelation="Penalization Code"."Code";
                                                   CaptionML=ENU='Penalization Code',ESP='Cod. penalizaci¢n';


    }
    field(3;"Number";Integer)
    {
        CaptionML=ENU='Number',ESP='N£mero';


    }
    field(4;"Penalization Text";Text[80])
    {
        CaptionML=ENU='Penalization Text',ESP='Texto penalizaci¢n'; ;


    }
}
  keys
{
    key(key1;"Quote Code","Penalization Code","Number")
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








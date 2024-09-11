table 7206944 "QBU Replacement Line"
{
  
  
  ;
  fields
{
    field(1;"Replacement Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Replacement Code',ESP='C¢digo sustituci¢n';


    }
    field(2;"External Data";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Old Data',ESP='C¢digo Externo';


    }
    field(3;"Internal Data";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='New Data',ESP='C¢digo Interno'; ;


    }
}
  keys
{
    key(key1;"Replacement Code","External Data")
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








table 7207378 "Tempory Model Decide"
{
  
  
    CaptionML=ENU='Tempory Model Decide',ESP='Det. modelo temporal';
  
  fields
{
    field(1;"Model Code";Code[10])
    {
        TableRelation="Models Tempory";
                                                   CaptionML=ENU='Model Code',ESP='Cod. Modelo';


    }
    field(2;"Sequence No.";Integer)
    {
        CaptionML=ENU='Sequence No.',ESP='No. secuencia';


    }
    field(3;"Term Formula";Code[20])
    {
        CaptionML=ENU='Term Formula',ESP='F¢rmula plazo';


    }
    field(4;"%To Applied";Decimal)
    {
        CaptionML=ENU='%To Applied',ESP='%a aplicar'; ;


    }
}
  keys
{
    key(key1;"Model Code")
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








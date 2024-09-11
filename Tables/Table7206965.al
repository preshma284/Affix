table 7206965 "QBU Price x job review"
{
  
  
    CaptionML=ENU='Price x job review',ESP='Revision precios x proyecto';
    LookupPageID="QB Price x job reviews";
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation=Job."No." WHERE ("Blocked"=CONST(" "));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='Cod. Proyecto';
                                                   NotBlank=true;
                                                   Description='Job.No. WHERE (Blocked=CONST())';


    }
    field(3;"Review code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Review code',ESP='Cod. Revision';
                                                   NotBlank=true;


    }
    field(5;"Percentage";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Percentage',ESP='Porcentaje'; ;


    }
}
  keys
{
    key(key1;"Job No.","Review code")
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








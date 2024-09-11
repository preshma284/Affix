table 7206959 "QB Grouping Code"
{
  
  
  ;
  fields
{
    field(1;"Code";Code[20])
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
    fieldgroup(DropDown;"Code","Description")
    {
        
    }
}
  

    /*begin
    end.
  */
}








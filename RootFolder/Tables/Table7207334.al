table 7207334 "TAUX Budget Category"
{
  
  
    CaptionML=ENU='Budget Category',ESP='Categor¡a Presupuesto';
    LookupPageID="TAux Budget Category List";
    DrillDownPageID="TAux Budget Category List";
  
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
      //GAP010 JDC 12/08/19 - Created
    }
    end.
  */
}








table 7206926 "QB TAux General Sub-Categories"
{
  
  
    CaptionML=ENU='General Categories',ESP='Sub-Categorias Generales';
    LookupPageID="QB TAux Sub Categories List";
    DrillDownPageID="QB TAux Sub Categories List";
  
  fields
{
    field(1;"Categorie";Code[20])
    {
        TableRelation="TAux General Categories";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Categor¡a';


    }
    field(2;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(3;"Description";Text[100])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n'; ;


    }
}
  keys
{
    key(key1;"Categorie","Code")
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








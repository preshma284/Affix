table 7207377 "Models Tempory"
{
  
  
    CaptionML=ENU='Models Tempory',ESP='Modelos temporales';
    LookupPageID="Tempory Models List";
    DrillDownPageID="Tempory Models List";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Assigned Total";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Tempory Model Decide"."%To Applied" WHERE ("Model Code"=FIELD("Code")));
                                                   CaptionML=ENU='Assigned Total',ESP='Total asignado';
                                                   Editable=false ;


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








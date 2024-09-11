table 7207314 "QBU TAux Award Procedure"
{
  
  
    CaptionML=ENU='Awarding procedure',ESP='Procedimiento de adjudicaci¢n';
    LookupPageID="TAux Award procedure List";
    DrillDownPageID="TAux Award procedure List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;


    }
    field(2;"Description";Text[50])
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
  

    

trigger OnDelete();    var
//                GenProductPostingGroup@1000 :
               GenProductPostingGroup: Record 251;
             begin
             end;



/*begin
    end.
  */
}








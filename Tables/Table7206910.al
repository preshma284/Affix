table 7206910 "QBU Job Attribute Value Mapping"
{
  
  
    CaptionML=ENU='Job Attribute Value Mapping',ESP='Asignaci¢n de valor de atributo de proyecto/estudio';
  
  fields
{
    field(1;"Table ID";Integer)
    {
        CaptionML=ENU='Table ID',ESP='Id. tabla';


    }
    field(2;"No.";Code[20])
    {
        CaptionML=ENU='No.',ESP='N§';


    }
    field(3;"Job Attribute ID";Integer)
    {
        TableRelation="Job Attribute";
                                                   CaptionML=ENU='Job Attribute ID',ESP='Id. de atributo de proyecto/estudio';


    }
    field(4;"Job Attribute Value ID";Integer)
    {
        TableRelation="Job Attribute Value"."ID";
                                                   CaptionML=ENU='Job Attribute Value ID',ESP='Id. de valor de atributo de proyecto/estudio'; ;


    }
}
  keys
{
    key(key1;"Table ID","No.","Job Attribute ID")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    
    

trigger OnDelete();    var
//                JobAttribute@1002 :
               JobAttribute: Record 7206905;
//                JobAttributeValue@1000 :
               JobAttributeValue: Record 7206906;
//                JobAttributeValueMapping@1001 :
               JobAttributeValueMapping: Record 7206910;
             begin
               JobAttribute.GET("Job Attribute ID");
               if JobAttribute.Type = JobAttribute.Type::Option then
                 exit;

               if not JobAttributeValue.GET("Job Attribute ID","Job Attribute Value ID") then
                 exit;

               JobAttributeValueMapping.SETRANGE("Job Attribute ID","Job Attribute ID");
               JobAttributeValueMapping.SETRANGE("Job Attribute Value ID","Job Attribute Value ID");
               if JobAttributeValueMapping.COUNT <> 1 then
                 exit;

               JobAttributeValueMapping := Rec;
               if JobAttributeValueMapping.FIND then
                 JobAttributeValue.DELETE;
             end;



// procedure RenameJobAttributeValueMapping (PrevNo@1000 : Code[20];NewNo@1001 :
procedure RenameJobAttributeValueMapping (PrevNo: Code[20];NewNo: Code[20])
    var
//       JobAttributeValueMapping@1003 :
      JobAttributeValueMapping: Record 7206910;
    begin
      SETRANGE("Table ID",DATABASE::Job);
      SETRANGE("No.",PrevNo);
      if FINDSET then
        repeat
          JobAttributeValueMapping := Rec;
          JobAttributeValueMapping.RENAME("Table ID",NewNo,"Job Attribute ID");
        until NEXT = 0;
    end;

    /*begin
    //{
//      JAV 13/02/20: - Gesti¢n de atributos para proyectos
//    }
    end.
  */
}








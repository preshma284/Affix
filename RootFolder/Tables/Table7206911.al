table 7206911 "Filter Job Attributes Buffer"
{
  
  
    CaptionML=ENU='Filter Job Attributes Buffer',ESP='Filtrar b£fer de atributos de proyecto/estudio';
  
  fields
{
    field(1;"Attribute";Text[250])
    {
        

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=ENU='Attribute',ESP='Atributo';

trigger OnValidate();
    VAR
//                                                                 JobAttribute@1001 :
                                                                JobAttribute: Record 7206905;
                                                              BEGIN 
                                                                IF NOT FindJobAttributeCaseInsensitive(JobAttribute) THEN
                                                                  ERROR(AttributeDoesntExistErr,Attribute);
                                                                CheckForDuplicate;
                                                                AdjustAttributeName(JobAttribute);
                                                              END;


    }
    field(2;"Value";Text[250])
    {
        

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=ENU='Value',ESP='Valor';

trigger OnValidate();
    VAR
//                                                                 JobAttributeValue@1003 :
                                                                JobAttributeValue: Record 7206906;
//                                                                 JobAttribute@1002 :
                                                                JobAttribute: Record 7206905;
                                                              BEGIN 
                                                                IF Value <> '' THEN
                                                                  IF FindJobAttributeCaseSensitive(JobAttribute) THEN
                                                                    IF JobAttribute.Type = JobAttribute.Type::Option THEN
                                                                      IF FindJobAttributeValueCaseInsensitive(JobAttribute,JobAttributeValue) THEN
                                                                        AdjustAttributeValue(JobAttributeValue);
                                                              END;


    }
    field(3;"ID";GUID)
    {
        DataClassification=SystemMetadata;
                                                   CaptionML=ENU='ID',ESP='ID'; ;


    }
}
  keys
{
    key(key1;"Attribute")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       AttributeDoesntExistErr@1005 :
      AttributeDoesntExistErr: 
// %1 - arbitrary name
TextConst ENU='The Job attribute ''%1'' doesn''t exist.',ESP='El atributo de proyecto/estudio ''%1'' no existe.';
//       AttributeValueAlreadySpecifiedErr@1001 :
      AttributeValueAlreadySpecifiedErr: 
// %1 - attribute name
TextConst ENU='You have already specified a value for Job attribute ''%1''.',ESP='Ya especific¢ un valor para el atributo de proyecto/estudio ''%1''.';

    
    

trigger OnInsert();    begin
               if ISNULLGUID(ID) then
                 ID := CREATEGUID;
             end;



procedure ValueAssistEdit ()
    var
//       JobAttribute@1000 :
      JobAttribute: Record 7206905;
//       FilterJobsAssistEdit@1001 :
      FilterJobsAssistEdit: Page 7206917;
    begin
      if FindJobAttributeCaseSensitive(JobAttribute) then
        if JobAttribute.Type = JobAttribute.Type::Option then begin
          FilterJobsAssistEdit.SETRECORD(JobAttribute);
          Value := COPYSTR(FilterJobsAssistEdit.LookupOptionValue(Value),1,MAXSTRLEN(Value));
          exit;
        end;

      FilterJobsAssistEdit.SETTABLEVIEW(JobAttribute);
      FilterJobsAssistEdit.LOOKUPMODE(TRUE);
      if FilterJobsAssistEdit.RUNMODAL = ACTION::LookupOK then
        Value := COPYSTR(FilterJobsAssistEdit.GenerateFilter,1,MAXSTRLEN(Value));
    end;

//     LOCAL procedure FindJobAttributeCaseSensitive (var JobAttribute@1000 :
    LOCAL procedure FindJobAttributeCaseSensitive (var JobAttribute: Record 7206905) : Boolean;
    begin
      JobAttribute.SETRANGE(Name,Attribute);
      exit(JobAttribute.FINDFIRST);
    end;

//     LOCAL procedure FindJobAttributeCaseInsensitive (var JobAttribute@1000 :
    LOCAL procedure FindJobAttributeCaseInsensitive (var JobAttribute: Record 7206905) : Boolean;
    var
//       AttributeName@1001 :
      AttributeName: Text[250];
    begin
      if FindJobAttributeCaseSensitive(JobAttribute) then
        exit(TRUE);

      AttributeName := LOWERCASE(Attribute);
      JobAttribute.SETRANGE(Name);
      if JobAttribute.FINDSET then
        repeat
          if LOWERCASE(JobAttribute.Name) = AttributeName then
            exit(TRUE);
        until JobAttribute.NEXT = 0;

      exit(FALSE);
    end;

//     LOCAL procedure FindJobAttributeValueCaseInsensitive (var JobAttribute@1000 : Record 7206905;var JobAttributeValue@1002 :
    LOCAL procedure FindJobAttributeValueCaseInsensitive (var JobAttribute: Record 7206905;var JobAttributeValue: Record 7206906) : Boolean;
    var
//       AttributeValue@1001 :
      AttributeValue: Text[250];
    begin
      JobAttributeValue.SETRANGE("Attribute ID",JobAttribute.ID);
      JobAttributeValue.SETRANGE(Value,Value);
      if JobAttributeValue.FINDFIRST then
        exit(TRUE);

      JobAttributeValue.SETRANGE(Value);
      if JobAttributeValue.FINDSET then begin
        AttributeValue := LOWERCASE(Value);
        repeat
          if LOWERCASE(JobAttributeValue.Value) = AttributeValue then
            exit(TRUE);
        until JobAttributeValue.NEXT = 0;
      end;
      exit(FALSE);
    end;

    LOCAL procedure CheckForDuplicate ()
    var
//       TempFilterJobAttributesBuffer@1001 :
      TempFilterJobAttributesBuffer: Record 7206911 TEMPORARY;
//       AttributeName@1003 :
      AttributeName: Text[250];
    begin
      if ISEMPTY then
        exit;
      AttributeName := LOWERCASE(Attribute);
      TempFilterJobAttributesBuffer.COPY(Rec,TRUE);
      if TempFilterJobAttributesBuffer.FINDSET then
        repeat
          if TempFilterJobAttributesBuffer.ID <> ID then
            if LOWERCASE(TempFilterJobAttributesBuffer.Attribute) = AttributeName then
              ERROR(AttributeValueAlreadySpecifiedErr,Attribute);
        until TempFilterJobAttributesBuffer.NEXT = 0;
    end;

//     LOCAL procedure AdjustAttributeName (var JobAttribute@1000 :
    LOCAL procedure AdjustAttributeName (var JobAttribute: Record 7206905)
    begin
      if Attribute <> JobAttribute.Name then
        Attribute := JobAttribute.Name;
    end;

//     LOCAL procedure AdjustAttributeValue (var JobAttributeValue@1000 :
    LOCAL procedure AdjustAttributeValue (var JobAttributeValue: Record 7206906)
    begin
      if Value <> JobAttributeValue.Value then
        Value := JobAttributeValue.Value;
    end;

    /*begin
    //{
//      JAV 13/02/20: - Gesti¢n de atributos para proyectos
//    }
    end.
  */
}








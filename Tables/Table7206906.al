table 7206906 "QBU Job Attribute Value"
{
  
  DataCaptionFields="Value";
    CaptionML=ENU='Job Attribute Value',ESP='Valor de atributo de proyecto/estudio';
    LookupPageID="Job Attribute Values";
  
  fields
{
    field(1;"Attribute ID";Integer)
    {
        TableRelation="Job Attribute"."ID" WHERE ("Blocked"=CONST(false));
                                                   CaptionML=ENU='Attribute ID',ESP='Id. de atributo';
                                                   NotBlank=true;


    }
    field(2;"ID";Integer)
    {
        AutoIncrement=true;
                                                   CaptionML=ENU='ID',ESP='Id.';


    }
    field(3;"Value";Text[250])
    {
        

                                                   CaptionML=ENU='Value',ESP='Valor';

trigger OnValidate();
    VAR
//                                                                 JobAttribute@1000 :
                                                                JobAttribute: Record 7206905;
                                                              BEGIN 
                                                                IF xRec.Value = Value THEN
                                                                  EXIT;

                                                                TESTFIELD(Value);
                                                                IF HasBeenUsed THEN
                                                                  IF NOT CONFIRM(RenameUsedAttributeValueQst) THEN
                                                                    ERROR('');

                                                                CheckValueUniqueness(Rec,Value);
                                                                DeleteTranslationsConditionally(xRec,Value);

                                                                JobAttribute.GET("Attribute ID");
                                                                IF IsNumeric(JobAttribute) THEN
                                                                  EVALUATE("Numeric Value",Value);
                                                                IF JobAttribute.Type = JobAttribute.Type::Date THEN
                                                                  EVALUATE("Date Value",Value);
                                                              END;


    }
    field(4;"Numeric Value";Decimal)
    {
        

                                                   CaptionML=ENU='Numeric Value',ESP='Valor num‚rico';
                                                   BlankZero=true;

trigger OnValidate();
    VAR
//                                                                 JobAttribute@1000 :
                                                                JobAttribute: Record 7206905;
                                                              BEGIN 
                                                                IF xRec."Numeric Value" = "Numeric Value" THEN
                                                                  EXIT;

                                                                JobAttribute.GET("Attribute ID");
                                                                IF IsNumeric(JobAttribute) THEN
                                                                  VALIDATE(Value,FORMAT("Numeric Value",0,9));
                                                              END;


    }
    field(5;"Date Value";Date)
    {
        

                                                   CaptionML=ENU='Date Value',ESP='Valor de fecha';

trigger OnValidate();
    VAR
//                                                                 JobAttribute@1000 :
                                                                JobAttribute: Record 7206905;
                                                              BEGIN 
                                                                IF xRec."Date Value" = "Date Value" THEN
                                                                  EXIT;

                                                                JobAttribute.GET("Attribute ID");
                                                                IF JobAttribute.Type = JobAttribute.Type::Date THEN
                                                                  VALIDATE(Value,FORMAT("Date Value"));
                                                              END;


    }
    field(6;"Blocked";Boolean)
    {
        CaptionML=ENU='Blocked',ESP='Bloqueado';


    }
    field(10;"Attribute Name";Text[250])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Job Attribute"."Name" WHERE ("ID"=FIELD("Attribute ID")));
                                                   CaptionML=ENU='Attribute Name',ESP='Nombre de atributo'; ;


    }
}
  keys
{
    key(key1;"Attribute ID","ID")
    {
        Clustered=true;
    }
}
  fieldgroups
{
    fieldgroup(DropDown;"Value")
    {
        
    }
    fieldgroup(Brick;"Attribute Name","Value")
    {
        
    }
}
  
    var
//       NameAlreadyExistsErr@1000 :
      NameAlreadyExistsErr: 
// %1 - arbitrary name
TextConst ENU='The Job attribute value with value ''%1'' already exists.',ESP='Ya existe el valor de atributo de proyecto/estudio con el valor ''%1''.';
//       ReuseValueTranslationsQst@1001 :
      ReuseValueTranslationsQst: 
// %1 - arbitrary name,%2 - arbitrary name
TextConst ENU='There are translations for Job attribute value ''%1''.\\Do you want to reuse these translations for the new value ''%2''?',ESP='Ya existen traducciones del valor de atributo de proyecto/estudio ''%1''.\\¨Quiere volver a usar estas traducciones para el nuevo valor ''%2''?';
//       DeleteUsedAttributeValueQst@1003 :
      DeleteUsedAttributeValueQst: TextConst ENU='This Job attribute value has been assigned to at least one Job.\\Are you sure you want to delete it?',ESP='El valor de atributo de proyecto/estudio se asign¢ a un proyecto/estudio como m¡nimo.\\¨Est  seguro de que quiere eliminarlo?';
//       RenameUsedAttributeValueQst@1002 :
      RenameUsedAttributeValueQst: TextConst ENU='This Job attribute value has been assigned to at least one Job.\\Are you sure you want to rename it?',ESP='El valor de atributo de proyecto/estudio se asign¢ a un proyecto/estudio como m¡nimo.\\¨Est  seguro de que quiere cambiarle el nombre?';
//       TransformationRule@1004 :
      TransformationRule: Record 1237;

    
    

trigger OnDelete();    var
//                JobAttrValueTranslation@1000 :
               JobAttrValueTranslation: Record 7206908;
//                JobAttributeValueMapping@1001 :
               JobAttributeValueMapping: Record 7206910;
             begin
               if HasBeenUsed then
                 if not CONFIRM(DeleteUsedAttributeValueQst) then
                   ERROR('');
               JobAttributeValueMapping.SETRANGE("Job Attribute ID","Attribute ID");
               JobAttributeValueMapping.SETRANGE("Job Attribute Value ID",ID);
               JobAttributeValueMapping.DELETEALL;

               JobAttrValueTranslation.SETRANGE("Attribute ID","Attribute ID");
               JobAttrValueTranslation.SETRANGE(ID,ID);
               JobAttrValueTranslation.DELETEALL;
             end;



// procedure LookupAttributeValue (AttributeID@1000 : Integer;var AttributeValueID@1001 :
procedure LookupAttributeValue (AttributeID: Integer;var AttributeValueID: Integer)
    var
//       JobAttributeValue@1003 :
      JobAttributeValue: Record 7206906;
//       JobAttributeValues@1002 :
      JobAttributeValues: Page 7206911;
    begin
      JobAttributeValue.SETRANGE("Attribute ID",AttributeID);
      JobAttributeValues.LOOKUPMODE := TRUE;
      JobAttributeValues.SETTABLEVIEW(JobAttributeValue);
      if JobAttributeValue.GET(AttributeID,AttributeValueID) then
        JobAttributeValues.SETRECORD(JobAttributeValue);
      if JobAttributeValues.RUNMODAL = ACTION::LookupOK then begin
        JobAttributeValues.GETRECORD(JobAttributeValue);
        AttributeValueID := JobAttributeValue.ID;
      end;
    end;

    
    procedure GetAttributeNameInCurrentLanguage () : Text[250];
    var
//       JobAttribute@1000 :
      JobAttribute: Record 7206905;
    begin
      if JobAttribute.GET("Attribute ID") then
        exit(JobAttribute.GetNameInCurrentLanguage);
      exit('');
    end;

    
    procedure GetValueInCurrentLanguage () : Text[250];
    var
//       JobAttribute@1000 :
      JobAttribute: Record 7206905;
//       ValueTxt@1002 :
      ValueTxt: Text;
    begin
      ValueTxt := GetValueInCurrentLanguageWithoutUnitOfMeasure;

      if JobAttribute.GET("Attribute ID") then
        CASE JobAttribute.Type OF
          JobAttribute.Type::Integer,
          JobAttribute.Type::Decimal:
            if ValueTxt <> '' then
              exit(AppendUnitOfMeasure(ValueTxt,JobAttribute));
        end;

      exit(ValueTxt);
    end;

    
    procedure GetValueInCurrentLanguageWithoutUnitOfMeasure () : Text[250];
    var
//       JobAttribute@1000 :
      JobAttribute: Record 7206905;
    begin
      if JobAttribute.GET("Attribute ID") then
        CASE JobAttribute.Type OF
          JobAttribute.Type::Option:
            exit(GetTranslatedName(GLOBALLANGUAGE));
          JobAttribute.Type::Text:
            exit(Value);
          JobAttribute.Type::Integer:
            if Value <> '' then
              exit(FORMAT(Value));
          JobAttribute.Type::Decimal:
            if Value <> '' then
              exit(FORMAT("Numeric Value"));
          JobAttribute.Type::Date:
            exit(FORMAT("Date Value"));
          else begin
            OnGetValueInCurrentLanguage(JobAttribute,Rec);
            exit(Value);
          end;
        end;
      exit('');
    end;

    
//     procedure GetTranslatedName (LanguageID@1000 :
    procedure GetTranslatedName (LanguageID: Integer) : Text[250];
    var
//       Language@1001 :
      Language: Record 8;
    begin
      Language.SETRANGE("Windows Language ID",LanguageID);
      if Language.FINDFIRST then
        exit(GetAttributeValueTranslation(Language.Code));
      exit(Value);
    end;

//     LOCAL procedure GetAttributeValueTranslation (LanguageCode@1000 :
    LOCAL procedure GetAttributeValueTranslation (LanguageCode: Code[10]) : Text[250];
    var
//       JobAttrValueTranslation@1001 :
      JobAttrValueTranslation: Record 7206908;
    begin
      if not JobAttrValueTranslation.GET("Attribute ID",ID,LanguageCode) then
        exit(Value);
      exit(JobAttrValueTranslation.Name);
    end;

//     LOCAL procedure CheckValueUniqueness (JobAttributeValue@1000 : Record 7206906;NameToCheck@1001 :
    LOCAL procedure CheckValueUniqueness (JobAttributeValue: Record 7206906;NameToCheck: Text[250])
    begin
      JobAttributeValue.SETRANGE("Attribute ID","Attribute ID");
      JobAttributeValue.SETFILTER(ID,'<>%1',JobAttributeValue.ID);
      JobAttributeValue.SETRANGE(Value,NameToCheck);
      if not JobAttributeValue.ISEMPTY then
        ERROR(NameAlreadyExistsErr,NameToCheck);
    end;

//     LOCAL procedure DeleteTranslationsConditionally (JobAttributeValue@1000 : Record 7206906;NameToCheck@1001 :
    LOCAL procedure DeleteTranslationsConditionally (JobAttributeValue: Record 7206906;NameToCheck: Text[250])
    var
//       JobAttrValueTranslation@1002 :
      JobAttrValueTranslation: Record 7206908;
    begin
      if (JobAttributeValue.Value <> '') and (JobAttributeValue.Value <> NameToCheck) then begin
        JobAttrValueTranslation.SETRANGE("Attribute ID","Attribute ID");
        JobAttrValueTranslation.SETRANGE(ID,ID);
        if not JobAttrValueTranslation.ISEMPTY then
          if not CONFIRM(STRSUBSTNO(ReuseValueTranslationsQst,JobAttributeValue.Value,NameToCheck)) then
            JobAttrValueTranslation.DELETEALL;
      end;
    end;

//     LOCAL procedure AppendUnitOfMeasure (String@1000 : Text;JobAttribute@1001 :
    LOCAL procedure AppendUnitOfMeasure (String: Text;JobAttribute: Record 7206905) : Text;
    begin
      if JobAttribute."Unit of Measure" <> '' then
        exit(STRSUBSTNO('%1 %2',String,FORMAT(JobAttribute."Unit of Measure")));
      exit(String);
    end;

    
    procedure HasBeenUsed () : Boolean;
    var
//       JobAttributeValueMapping@1000 :
      JobAttributeValueMapping: Record 7206910;
//       AttributeHasBeenUsed@1001 :
      AttributeHasBeenUsed: Boolean;
    begin
      JobAttributeValueMapping.SETRANGE("Job Attribute ID","Attribute ID");
      JobAttributeValueMapping.SETRANGE("Job Attribute Value ID",ID);
      AttributeHasBeenUsed := not JobAttributeValueMapping.ISEMPTY;
      OnAfterHasBeenUsed(Rec,AttributeHasBeenUsed);
      exit(AttributeHasBeenUsed);
    end;

//     procedure SetValueFilter (var JobAttribute@1000 : Record 7206905;FilterText@1001 :
    procedure SetValueFilter (var JobAttribute: Record 7206905;FilterText: Text)
    var
//       IndexOfOrCondition@1003 :
      IndexOfOrCondition: Integer;
    begin
      SETRANGE("Numeric Value");
      SETRANGE(Value);

      if IsNumeric(JobAttribute) then begin
        SETFILTER("Numeric Value",FilterText);
        exit;
      end;

      if JobAttribute.Type = JobAttribute.Type::Text then
        if (STRPOS(FilterText,'*') = 0) and (STRPOS(FilterText,'''') = 0) then begin
          FilterText := STRSUBSTNO('@*%1*',LOWERCASE(FilterText));
          IndexOfOrCondition := STRPOS(FilterText,'|');
          if IndexOfOrCondition > 0 then begin
            TransformationRule.INIT;
            TransformationRule."Find Value" := '|';
            TransformationRule."Replace Value" := '*|@*';
            TransformationRule."Transformation Type" := TransformationRule."Transformation Type"::Replace;
            FilterText := TransformationRule.TransformText(FilterText);
          end
        end;

      SETFILTER(Value,FilterText);
    end;

//     LOCAL procedure IsNumeric (var JobAttribute@1000 :
    LOCAL procedure IsNumeric (var JobAttribute: Record 7206905) : Boolean;
    begin
      exit(JobAttribute.Type IN [JobAttribute.Type::Integer,JobAttribute.Type::Decimal]);
    end;

    
//     procedure LoadJobAttributesFactBoxData (KeyValue@1000 :
    procedure LoadJobAttributesFactBoxData (KeyValue: Code[20])
    var
//       JobAttributeValueMapping@1001 :
      JobAttributeValueMapping: Record 7206910;
//       JobAttributeValue@1002 :
      JobAttributeValue: Record 7206906;
    begin
      RESET;
      DELETEALL;
      JobAttributeValueMapping.SETRANGE("Table ID",DATABASE::Job);
      JobAttributeValueMapping.SETRANGE("No.",KeyValue);
      if JobAttributeValueMapping.FINDSET then
        repeat
          if JobAttributeValue.GET(JobAttributeValueMapping."Job Attribute ID",JobAttributeValueMapping."Job Attribute Value ID") then begin
            TRANSFERFIELDS(JobAttributeValue);
            INSERT;
          end
        until JobAttributeValueMapping.NEXT = 0;
    end;

    
//     procedure LoadCategoryAttributesFactBoxData (CategoryCode@1000 :
    procedure LoadCategoryAttributesFactBoxData (CategoryCode: Code[20])
    var
//       JobAttributeValueMapping@1001 :
      JobAttributeValueMapping: Record 7206910;
//       JobAttributeValue@1002 :
      JobAttributeValue: Record 7206906;
//       JobCategory@1003 :
      JobCategory: Record 5722;
    begin
      RESET;
      DELETEALL;
      if CategoryCode = '' then
        exit;
      //++ JobAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Job Category");
      repeat
        JobAttributeValueMapping.SETRANGE("No.",CategoryCode);
        if JobAttributeValueMapping.FINDSET then
          repeat
            if JobAttributeValue.GET(JobAttributeValueMapping."Job Attribute ID",JobAttributeValueMapping."Job Attribute Value ID") then
              if not AttributeExists(JobAttributeValue."Attribute ID") then begin
                TRANSFERFIELDS(JobAttributeValue);
                INSERT;
              end;
          until JobAttributeValueMapping.NEXT = 0;
        if JobCategory.GET(CategoryCode) then
          CategoryCode := JobCategory."Parent Category"
        else
          CategoryCode := '';
      until CategoryCode = '';
    end;

//     LOCAL procedure AttributeExists (AttributeID@1001 :
    LOCAL procedure AttributeExists (AttributeID: Integer) AttribExist : Boolean;
    begin
      SETRANGE("Attribute ID",AttributeID);
      AttribExist := not ISEMPTY;
      RESET;
    end;

    
//     LOCAL procedure OnAfterHasBeenUsed (JobAttributeValue@1000 : Record 7206906;var AttributeHasBeenUsed@1001 :
    LOCAL procedure OnAfterHasBeenUsed (JobAttributeValue: Record 7206906;var AttributeHasBeenUsed: Boolean)
    begin
    end;

    
//     LOCAL procedure OnGetValueInCurrentLanguage (JobAttribute@1000 : Record 7206905;var JobAttributeValue@1001 :
    LOCAL procedure OnGetValueInCurrentLanguage (JobAttribute: Record 7206905;var JobAttributeValue: Record 7206906)
    begin
    end;

    /*begin
    //{
//      JAV 13/02/20: - Gesti¢n de atributos para proyectos
//    }
    end.
  */
}








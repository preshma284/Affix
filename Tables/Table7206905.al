table 7206905 "QBU Job Attribute"
{
  
  DataCaptionFields="Name";
    CaptionML=ENU='Job Attribute',ESP='Atributo de proyecto/estudio';
    LookupPageID="Job Attributes";
  
  fields
{
    field(1;"ID";Integer)
    {
        AutoIncrement=true;
                                                   CaptionML=ENU='ID',ESP='Id.';
                                                   NotBlank=true;


    }
    field(2;"Name";Text[250])
    {
        

                                                   CaptionML=ENU='Name',ESP='Nombre';
                                                   NotBlank=true;

trigger OnValidate();
    BEGIN 
                                                                IF xRec.Name = Name THEN
                                                                  EXIT;

                                                                TESTFIELD(Name);
                                                                IF HasBeenUsed THEN
                                                                  IF NOT CONFIRM(RenameUsedAttributeQst) THEN
                                                                    ERROR('');
                                                                CheckNameUniqueness(Rec,Name);
                                                                DeleteValuesAndTranslationsConditionally(xRec,Name);
                                                              END;


    }
    field(6;"Blocked";Boolean)
    {
        CaptionML=ENU='Blocked',ESP='Bloqueado';


    }
    field(7;"Type";Option)
    {
        OptionMembers="Option","Text","Integer","Decimal","Date";InitValue="Text";
                                                   

                                                   CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Option,Text,Integer,Decimal,Date',ESP='Opci¢n,Texto,Entero,Decimal,Fecha';
                                                   

trigger OnValidate();
    VAR
//                                                                 JobAttributeValue@1000 :
                                                                JobAttributeValue: Record 7206906;
                                                              BEGIN 
                                                                IF xRec.Type <> Type THEN BEGIN 
                                                                  JobAttributeValue.SETRANGE("Attribute ID",ID);
                                                                  IF NOT JobAttributeValue.ISEMPTY THEN
                                                                    ERROR(ChangingAttributeTypeErr,Name);
                                                                END;
                                                              END;


    }
    field(8;"Unit of Measure";Text[30])
    {
        

                                                   CaptionML=ENU='Unit of Measure',ESP='Unidad medida'; ;

trigger OnValidate();
    BEGIN 
                                                                IF (xRec."Unit of Measure" <> '') AND (xRec."Unit of Measure" <> "Unit of Measure") THEN
                                                                  IF HasBeenUsed THEN
                                                                    IF NOT CONFIRM(ChangeUsedAttributeUoMQst) THEN
                                                                      ERROR('');
                                                              END;


    }
}
  keys
{
    key(key1;"ID")
    {
        Clustered=true;
    }
}
  fieldgroups
{
    fieldgroup(DropDown;"Name")
    {
        
    }
    fieldgroup(Brick;"ID","Name")
    {
        
    }
}
  
    var
//       JobAttributeTranslation@1022 :
      JobAttributeTranslation: Record 7206907;
//       NameAlreadyExistsErr@1000 :
      NameAlreadyExistsErr: 
// %1 - arbitrary name
TextConst ENU='The Job attribute with name ''%1'' already exists.',ESP='Ya existe el atributo de proyecto/estudio con el nombre ''%1''.';
//       ReuseValueTranslationsQst@1001 :
      ReuseValueTranslationsQst: 
// %1 - arbitrary name,%2 - arbitrary name
TextConst ENU='There are values and translations for Job attribute ''%1''.\\Do you want to reuse them after changing the Job attribute name to ''%2''?',ESP='Ya existen valores y traducciones del atributo de proyecto/estudio ''%1''.\\¨Quiere volver a usar estos valores una vez que haya cambiado el nombre del atributo de proyecto/estudio a ''%2''?';
//       ChangingAttributeTypeErr@1002 :
      ChangingAttributeTypeErr: 
// %1 - arbirtrary text
TextConst ENU='You cannot change the type of Job attribute ''%1'', because it is either in use or it has predefined values.',ESP='No puede cambiar el tipo de atributo de proyecto/estudio ''%1'', porque ya est  en uso o tiene valores predeterminados.';
//       DeleteUsedAttributeQst@1004 :
      DeleteUsedAttributeQst: TextConst ENU='This Job attribute has been assigned to at least one Job.\\Are you sure you want to delete it?',ESP='Este atributo de proyecto/estudio se asign¢ a un proyecto/estudio como m¡nimo.\\¨Est  seguro de que quiere eliminarlo?';
//       RenameUsedAttributeQst@1005 :
      RenameUsedAttributeQst: TextConst ENU='This Job attribute has been assigned to at least one Job.\\Are you sure you want to rename it?',ESP='Este atributo de proyecto/estudio se asign¢ a un proyecto/estudio como m¡nimo.\\¨Est  seguro de que quiere cambiarle el nombre?';
//       ChangeUsedAttributeUoMQst@1003 :
      ChangeUsedAttributeUoMQst: TextConst ENU='This Job attribute has been assigned to at least one Job.\\Are you sure you want to change its unit of measure?',ESP='Este atributo de proyecto/estudio se asign¢ a un proyecto/estudio como m¡nimo.\\¨Est  seguro de que quiere cambiar su unidad de medida?';
//       ChangeToOptionQst@1006 :
      ChangeToOptionQst: TextConst ENU='Predefined values can be defined only for Job attributes of type Option.\\Do you want to change the type of this Job attribute to Option?',ESP='Solo se pueden definir valores predefinidos para los atributos de proyecto/estudio del tipo Opci¢n.\\¨Quiere cambiar el tipo del atributo de proyecto/estudio a Opci¢n?';

    
    

trigger OnDelete();    begin
               if HasBeenUsed then
                 if not CONFIRM(DeleteUsedAttributeQst) then
                   ERROR('');
               DeleteValuesAndTranslations;
             end;

trigger OnRename();    var
//                JobAttributeValue@1000 :
               JobAttributeValue: Record 7206906;
             begin
               JobAttributeValue.SETRANGE("Attribute ID",xRec.ID);
               if JobAttributeValue.FINDSET then
                 repeat
                   JobAttributeValue.RENAME(ID,JobAttributeValue.ID);
                 until JobAttributeValue.NEXT = 0;
             end;



// procedure GetTranslatedName (LanguageID@1000 :
procedure GetTranslatedName (LanguageID: Integer) : Text[250];
    var
//       Language@1001 :
      Language: Record 8;
    begin
      Language.SETRANGE("Windows Language ID",LanguageID);
      if Language.FINDFIRST then begin
        GetAttributeTranslation(Language.Code);
        exit(JobAttributeTranslation.Name);
      end;
      exit(Name);
    end;

    
    procedure GetNameInCurrentLanguage () : Text[250];
    begin
      exit(GetTranslatedName(GLOBALLANGUAGE));
    end;

//     LOCAL procedure GetAttributeTranslation (LanguageCode@1000 :
    LOCAL procedure GetAttributeTranslation (LanguageCode: Code[10])
    begin
      if (JobAttributeTranslation."Attribute ID" <> ID) or (JobAttributeTranslation."Language Code" <> LanguageCode) then
        if not JobAttributeTranslation.GET(ID,LanguageCode) then begin
          JobAttributeTranslation.INIT;
          JobAttributeTranslation."Attribute ID" := ID;
          JobAttributeTranslation."Language Code" := LanguageCode;
          JobAttributeTranslation.Name := Name;
        end;
    end;

    
    procedure GetValues () Values : Text;
    var
//       JobAttributeValue@1000 :
      JobAttributeValue: Record 7206906;
    begin
      if Type <> Type::Option then
        exit('');
      JobAttributeValue.SETRANGE("Attribute ID",ID);
      if JobAttributeValue.FINDSET then
        repeat
          if Values <> '' then
            Values += ',';
          Values += JobAttributeValue.Value;
        until JobAttributeValue.NEXT = 0;
    end;

    
    procedure HasBeenUsed () : Boolean;
    var
//       JobAttributeValueMapping@1000 :
      JobAttributeValueMapping: Record 7206910;
    begin
      JobAttributeValueMapping.SETRANGE("Job Attribute ID",ID);
      exit(not JobAttributeValueMapping.ISEMPTY);
    end;

    
    procedure RemoveUnusedArbitraryValues ()
    var
//       JobAttributeValue@1000 :
      JobAttributeValue: Record 7206906;
    begin
      if Type = Type::Option then
        exit;

      JobAttributeValue.SETRANGE("Attribute ID",ID);
      if JobAttributeValue.FINDSET then
        repeat
          if not JobAttributeValue.HasBeenUsed then
            JobAttributeValue.DELETE;
        until JobAttributeValue.NEXT = 0;
    end;

    
    procedure OpenJobAttributeValues ()
    var
//       JobAttributeValue@1000 :
      JobAttributeValue: Record 7206906;
    begin
      JobAttributeValue.SETRANGE("Attribute ID",ID);
      if (Type <> Type::Option) and JobAttributeValue.ISEMPTY then
        if CONFIRM(ChangeToOptionQst) then begin
          VALIDATE(Type,Type::Option);
          MODIFY;
        end;

      if Type = Type::Option then
        PAGE.RUN(PAGE::"Job Attribute Values",JobAttributeValue);
    end;

//     LOCAL procedure CheckNameUniqueness (JobAttribute@1000 : Record 7206905;NameToCheck@1001 :
    LOCAL procedure CheckNameUniqueness (JobAttribute: Record 7206905;NameToCheck: Text[250])
    begin
      OnBeforeCheckNameUniqueness(JobAttribute,Rec);

      JobAttribute.SETRANGE(Name,NameToCheck);
      JobAttribute.SETFILTER(ID,'<>%1',JobAttribute.ID);
      if not JobAttribute.ISEMPTY then
        ERROR(NameAlreadyExistsErr,NameToCheck);
    end;

//     LOCAL procedure DeleteValuesAndTranslationsConditionally (JobAttribute@1000 : Record 7206905;NameToCheck@1001 :
    LOCAL procedure DeleteValuesAndTranslationsConditionally (JobAttribute: Record 7206905;NameToCheck: Text[250])
    var
//       JobAttributeTranslation@1002 :
      JobAttributeTranslation: Record 7206907;
//       JobAttributeValue@1003 :
      JobAttributeValue: Record 7206906;
//       ValuesOrTranslationsExist@1004 :
      ValuesOrTranslationsExist: Boolean;
    begin
      if (JobAttribute.Name <> '') and (JobAttribute.Name <> NameToCheck) then begin
        JobAttributeValue.SETRANGE("Attribute ID",ID);
        JobAttributeTranslation.SETRANGE("Attribute ID",ID);
        ValuesOrTranslationsExist := not (JobAttributeValue.ISEMPTY and JobAttributeTranslation.ISEMPTY);
        if ValuesOrTranslationsExist then
          if not CONFIRM(STRSUBSTNO(ReuseValueTranslationsQst,JobAttribute.Name,NameToCheck)) then
            DeleteValuesAndTranslations;
      end;
    end;

    LOCAL procedure DeleteValuesAndTranslations ()
    var
//       JobAttributeValue@1000 :
      JobAttributeValue: Record 7206906;
//       JobAttributeValueMapping@1001 :
      JobAttributeValueMapping: Record 7206910;
//       JobAttrValueTranslation@1002 :
      JobAttrValueTranslation: Record 7206908;
    begin
      JobAttributeValueMapping.SETRANGE("Job Attribute ID",ID);
      JobAttributeValueMapping.DELETEALL;

      JobAttributeValue.SETRANGE("Attribute ID",ID);
      JobAttributeValue.DELETEALL;

      JobAttributeTranslation.SETRANGE("Attribute ID",ID);
      JobAttributeTranslation.DELETEALL;

      JobAttrValueTranslation.SETRANGE("Attribute ID",ID);
      JobAttrValueTranslation.DELETEALL;
    end;

    
//     LOCAL procedure OnBeforeCheckNameUniqueness (var NewJobAttribute@1000 : Record 7206905;JobAttribute@1001 :
    LOCAL procedure OnBeforeCheckNameUniqueness (var NewJobAttribute: Record 7206905;JobAttribute: Record 7206905)
    begin
    end;

    /*begin
    //{
//      JAV 13/02/20: - Gesti¢n de atributos para proyectos
//    }
    end.
  */
}








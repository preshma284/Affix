page 7206914 "Job Attribute Value List"
{
CaptionML=ENU='Job Attribute Values',ESP='Valores de atributo de proyecto/estudio';
    LinksAllowed=false;
    SourceTable=7206909;
    DelayedInsert=true;
    PageType=ListPart;
    SourceTableTemporary=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Attribute Name";rec."Attribute Name")
    {
        
                AssistEdit=false;
                CaptionML=ENU='Attribute',ESP='Atributo';
                ToolTipML=ENU='Specifies the Job attribute.',ESP='Especifica el atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
                TableRelation="Job Attribute".Name WHERE ("Blocked"=CONST(false));
                
                            ;trigger OnValidate()    VAR
                             JobAttributeValue : Record 7206906;
                             JobAttributeValueMapping : Record 7206910;
                           BEGIN
                             IF xRec."Attribute Name" <> '' THEN
                               DeleteJobAttributeValueMapping(xRec."Attribute ID");

                             IF NOT rec.FindAttributeValue(JobAttributeValue) THEN
                               rec.InsertJobAttributeValue(JobAttributeValue,Rec);

                             IF JobAttributeValue.GET(JobAttributeValue."Attribute ID",JobAttributeValue.ID) THEN BEGIN
                               JobAttributeValueMapping.RESET;
                               JobAttributeValueMapping.INIT;
                               JobAttributeValueMapping."Table ID" := DATABASE::Job;
                               JobAttributeValueMapping."No." := RelatedRecordCode;
                               JobAttributeValueMapping."Job Attribute ID" := JobAttributeValue."Attribute ID";
                               JobAttributeValueMapping."Job Attribute Value ID" := JobAttributeValue.ID;
                               JobAttributeValueMapping.INSERT;
                             END;
                           END;


    }
    field("Value";rec."Value")
    {
        
                CaptionML=ENU='Value',ESP='Valor';
                ToolTipML=ENU='Specifies the value of the Job attribute.',ESP='Especifica el valor del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
                TableRelation=IF ("Attribute Type"=CONST(Option)) "Job Attribute Value".Value WHERE ("Attribute ID"=FILTER('Proyecto operativo'),"Attribute ID"=FIELD("Attribute ID"),"Blocked"=CONST(false));
                
                            ;trigger OnValidate()    VAR
                             JobAttributeValue : Record 7206906;
                             JobAttributeValueMapping : Record 7206910;
                             JobAttribute : Record 7206905;
                           BEGIN
                             IF NOT rec.FindAttributeValue(JobAttributeValue) THEN
                               rec.InsertJobAttributeValue(JobAttributeValue,Rec);

                             JobAttributeValueMapping.SETRANGE("Table ID",DATABASE::Job);
                             JobAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
                             JobAttributeValueMapping.SETRANGE("Job Attribute ID",JobAttributeValue."Attribute ID");

                             IF JobAttributeValueMapping.FINDFIRST THEN BEGIN
                               JobAttributeValueMapping."Job Attribute Value ID" := JobAttributeValue.ID;
                               OnBeforeJobAttributeValueMappingModify(JobAttributeValueMapping,JobAttributeValue,RelatedRecordCode);
                               JobAttributeValueMapping.MODIFY;
                             END;

                             JobAttribute.GET(rec."Attribute ID");
                             IF JobAttribute.Type <> JobAttribute.Type::Option THEN
                               IF rec.FindAttributeValueFromRecord(JobAttributeValue,xRec) THEN
                                 IF NOT JobAttributeValue.HasBeenUsed THEN
                                   JobAttributeValue.DELETE;
                           END;


    }
    field("Unit of Measure";rec."Unit of Measure")
    {
        
                ToolTipML=ENU='Specifies the name of the Job or resources unit of measure, such as piece or hour.',ESP='Especifica el nombre de la unidad de medida del proyecto/estudio o recurso, como la unidad o la hora.';
                ApplicationArea=Basic,Suite;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 CurrPage.EDITABLE(TRUE);
               END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     DeleteJobAttributeValueMapping(rec."Attribute ID");
                   END;



    var
      RelatedRecordCode : Code[20];

    //[External]
    procedure LoadAttributes(JobNo : Code[20]);
    var
      JobAttributeValueMapping : Record 7206910;
      TempJobAttributeValue : Record 7206906 TEMPORARY;
      JobAttributeValue : Record 7206906;
    begin
      RelatedRecordCode := JobNo;
      JobAttributeValueMapping.SETRANGE("Table ID",DATABASE::Job);
      JobAttributeValueMapping.SETRANGE("No.",JobNo);
      if JobAttributeValueMapping.FINDSET then
        repeat
          JobAttributeValue.GET(JobAttributeValueMapping."Job Attribute ID",JobAttributeValueMapping."Job Attribute Value ID");
          TempJobAttributeValue.TRANSFERFIELDS(JobAttributeValue);
          TempJobAttributeValue.INSERT;
        until JobAttributeValueMapping.NEXT = 0;

      rec.PopulateJobAttributeValueSelection(TempJobAttributeValue);
    end;

    LOCAL procedure DeleteJobAttributeValueMapping(AttributeToDeleteID : Integer);
    var
      JobAttributeValueMapping : Record 7206910;
      JobAttribute : Record 7206905;
    begin
      JobAttributeValueMapping.SETRANGE("Table ID",DATABASE::Job);
      JobAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
      JobAttributeValueMapping.SETRANGE("Job Attribute ID",AttributeToDeleteID);
      if JobAttributeValueMapping.FINDFIRST then begin
        JobAttributeValueMapping.DELETE;
        OnAfterJobAttributeValueMappingDelete(AttributeToDeleteID,RelatedRecordCode);
      end;

      JobAttribute.GET(AttributeToDeleteID);
      JobAttribute.RemoveUnusedArbitraryValues;
    end;

    [IntegrationEvent(false,false)]
    LOCAL procedure OnAfterJobAttributeValueMappingDelete(AttributeToDeleteID : Integer;RelatedRecordCode : Code[20]);
    begin
    end;

    [IntegrationEvent(false,false)]
    LOCAL procedure OnBeforeJobAttributeValueMappingModify(var JobAttributeValueMapping : Record 7206910;JobAttributeValue : Record 7206906;RelatedRecordCode : Code[20]);
    begin
    end;

    // begin
    /*{
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }*///end
}









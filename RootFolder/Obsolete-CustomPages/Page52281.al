page 52281 "Outlook Synch. Dependencies"
{
CaptionML=ENU='Outlook Synch. Dependencies',ESP='Dependencias sinc. Outlook';
    SourceTable=51289;
    DataCaptionExpression=GetFormCaption;
    DelayedInsert=true;
    DataCaptionFields="Synch. Entity Code";
    PageType=List;
  layout
{
area(content)
{
repeater("Control1")
{
        
    field("Depend. Synch. Entity Code";rec."Depend. Synch. Entity Code")
    {
        
                ToolTipML=ENU='Specifies the code of the synchronization entity. The program copies this code from the Code field of the Outlook Synch. Entity table.',ESP='Especifica el c¢digo de la entidad de sincronizaci¢n. El programa lo copia del campo C¢digo de la tabla Entidad sinc. Outlook.';
                ApplicationArea=Basic,Suite;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a brief description of the entity which code is specified in the Description field of the Outlook Synch. Entity table.',ESP='Especifica una descripci¢n breve de la entidad cuyo c¢digo se especifica en el campo Descripci¢n de la tabla Entidad sinc. Outlook.';
                ApplicationArea=Basic,Suite;
    }
    field("Condition";rec."Condition")
    {
        
                ToolTipML=ENU='Specifies the filter expression which is applied to the collections table defined by the Depend. Synch. Entity Code and Element No. fields. This condition is required when one collection search field relates to several different tables (the conditional table relation).',ESP='Especifica la expresi¢n de filtro que se aplica a la tabla de la colecci¢n que se define mediante los campos C¢digo objeto sinc. depend. y N.§ elemento. Esta condici¢n es necesaria cuando un campo de b£squeda de la colecci¢n se relaciona con varias tablas diferentes (relaci¢n de tabla condicional).';
                ApplicationArea=Basic,Suite;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF ISNULLGUID(rec."Record GUID") THEN
                                 rec."Record GUID" := CREATEGUID;

                               OSynchEntityElement.GET(rec."Synch. Entity Code",rec."Element No.");
                               rec."Condition" :=
                                 COPYSTR(OSynchSetupMgt.ShowOSynchFiltersForm(rec."Record GUID",OSynchEntityElement."Table No.",0),1,MAXSTRLEN(rec."Condition"));
                             END;


    }
    field("Table Relation";rec."Table Relation")
    {
        
                ToolTipML=ENU='Specifies a filter expression. It is used to select the record from the table on which Dependent Synch. Entity is based.',ESP='Especifica una expresi¢n de filtro. Se usa para seleccionar el registro de la tabla en que se basa la entidad de sincronizaci¢n dependiente.';
                ApplicationArea=Basic,Suite;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF ISNULLGUID(rec."Record GUID") THEN
                                 rec."Record GUID" := CREATEGUID;

                               OSynchEntity.GET(rec."Depend. Synch. Entity Code");
                               OSynchEntityElement.GET(rec."Synch. Entity Code",rec."Element No.");
                               rec."Table Relation" :=
                                 COPYSTR(
                                   OSynchSetupMgt.ShowOSynchFiltersForm(rec."Record GUID",OSynchEntity."Table No.",OSynchEntityElement."Table No."),
                                   1,MAXSTRLEN(rec."Condition"));
                             END;


    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=FALSE;
    }

}
}
  
    var
      OSynchEntity : Record 51280;
      OSynchEntityElement : Record 51281;
      OSynchSetupMgt : Codeunit 50849;

    //[External]
    procedure GetFormCaption() : Text[80];
    begin
      exit(STRSUBSTNO('%1 %2 %3',OSynchEntityElement.TABLECAPTION,rec."Synch. Entity Code",rec."Element No."));
    end;

    // begin//end
}








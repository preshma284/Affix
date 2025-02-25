page 52274 "Outlook Synch. Fields"
{
CaptionML=ENU='Outlook Synch. Fields',ESP='Campos sinc. Outlook';
    SourceTable=51284;
    DataCaptionExpression=GetFormCaption;
    DelayedInsert=true;
    DataCaptionFields="Synch. Entity Code";
    PageType=List;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("Control1")
{
        
    field("Condition";rec."Condition")
    {
        
                ToolTipML=ENU='Specifies the criteria for defining a set of specific entries to use in the synchronization process. This filter is applied to the table you specified in the Table No. field. If the Table No. field is not filled in, the program uses the value in the Master Table No. field.',ESP='Especifica los criterios para definir un conjunto de movimientos concretos que se deben usar en el proceso de sincronizaci¢n. Este filtro se aplica a la tabla especificada en el campo N.§ tabla. Si en dicho campo no hay ning£n valor, el programa usa el valor del campo N.§ tabla principal.';
                ApplicationArea=Basic,Suite;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF ISNULLGUID(rec."Record GUID") THEN
                                 rec."Record GUID" := CREATEGUID;

                               rec."Condition" := COPYSTR(OSynchSetupMgt.ShowOSynchFiltersForm(rec."Record GUID",rec."Master Table No.",0),1,MAXSTRLEN(rec."Condition"));
                             END;


    }
    field("Table No.";rec."Table No.")
    {
        
                ToolTipML=ENU='Specifies the number of the supplementary table, which is used in the synchronization process when more details than those specified in the Master Table No. field are required.',ESP='Especifica el n£mero de la tabla adicional, que se usa en el proceso de sincronizaci¢n cuando se requieren m s detalles que los especificados en el campo N.§ tabla principal.';
                ApplicationArea=Basic,Suite;
    }
    field("Table Caption";rec."Table Caption")
    {
        
                ToolTipML=ENU='Specifies the name of the Dynamics 365 table to synchronize. The program fills in this field when you specify a table number in the Table No. field.',ESP='Especifica el nombre de la tabla de Dynamics 365 que se va a sincronizar. El programa rellena este campo cuando se especifica un n£mero de tabla en el campo N.§ÿtabla.';
                ApplicationArea=Basic,Suite;
    }
    field("Table Relation";rec."Table Relation")
    {
        
                ToolTipML=ENU='Specifies a filter expression. It is used to define relation between table specified in the Table No. and Table No.',ESP='Especifica una expresi¢n de filtro. Se usa para definir relaciones entre las tablas especificadas en los campos N.§ tabla.';
                ApplicationArea=Basic,Suite;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF rec."Table No." <> 0 THEN BEGIN
                                 IF ISNULLGUID(rec."Record GUID") THEN
                                   rec."Record GUID" := CREATEGUID;
                                 rec."Table Relation" :=
                                   COPYSTR(OSynchSetupMgt.ShowOSynchFiltersForm(rec."Record GUID",rec."Table No.",rec."Master Table No."),1,MAXSTRLEN(rec."Table Relation"));
                               END;
                             END;


    }
    field("Field No.";rec."Field No.")
    {
        
                ToolTipML=ENU='Specifies the number of the field with values that are used in the filter expression. The value in this field is appropriate if you specified the number of the table in the Table No. field. If you do not specify the table number, the program uses the number of the master table.',ESP='Especifica el n£mero del campo cuyos valores se usan en la expresi¢n de filtro. El valor de este campo es adecuado si se especifica el n£mero de la tabla en el campo N.§ tabla. Si no se especifica el n£mero de tabla, el programa usa el n£mero de la tabla principal.';
                ApplicationArea=Basic,Suite;
    }
    field("GetFieldCaption";rec.GetFieldCaption)
    {
        
                CaptionML=ENU='Field Name',ESP='Nombre de campo';
                ToolTipML=ENU='Specifies the name of the field that will be synchronized.',ESP='Especifica el nombre del campo que se sincronizar .';
                ApplicationArea=Basic,Suite;
    }
    field("Field Default Value";rec."Field Default Value")
    {
        
                ToolTipML=ENU='Specifies a value which is inserted automatically in the field whose number is specified in the Field No. field.',ESP='Especifica un valor que se inserta autom ticamente en el campo cuyo n£mero se especifica en el campo N.§ campo.';
                ApplicationArea=Basic,Suite;
    }
    field("User-Defined";rec."User-Defined")
    {
        
                ToolTipML=ENU='Specifies that this field is defined by the user and does not belong to the standard set of fields. This option refers only to Outlook Items properties.',ESP='Indica que el usuario define el campo y que no pertenece al conjunto est ndar de campos. Esta opci¢n hace referencia £nicamente a las propiedades de los elementos de Outlook.';
                ApplicationArea=Basic,Suite;
                Editable=UserDefinedEditable ;
    }
    field("Outlook Property";rec."Outlook Property")
    {
        
                ToolTipML=ENU='Specifies the number of the Outlook item property that will be synchronized with the Dynamics 365 table field specified in the Field No. field.',ESP='Especifica el n£mero de la propiedad del elemento de Outlook que se sincronizar  con el campo de la tabla de Dynamicsÿ365 especificado en el campo N.§ campo.';
                ApplicationArea=Basic,Suite;
    }
    field("Search Field";rec."Search Field")
    {
        
                ToolTipML=ENU='Specifies that the field will be the key property on which the search in Outlook will be based on.',ESP='Especifica que el campo ser  la propiedad principal en la que se basar  la b£squeda en Outlook.';
                ApplicationArea=Basic,Suite;
                Editable=SearchFieldEditable ;
    }
    field("Read-Only Status";rec."Read-Only Status")
    {
        
                ToolTipML=ENU='Specifies the synchronization status for the mapped table field. This field has three options:',ESP='Especifica el estado de sincronizaci¢n del campo de tabla asignado. Hay tres opciones:';
                ApplicationArea=Basic,Suite;
                Visible=FALSE ;
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
}actions
{
area(Navigation)
{

group("group31")
{
        CaptionML=ENU='F&ield',ESP='&Campo';
                      Image="OutlookSyncFields";
    action("Action32")
    {
        CaptionML=ENU='Option Correlations',ESP='Correlaciones entre opciones';
                      ToolTipML=ENU='View option fields and the corresponding Outlook property which has the same structure (enumerations and integer). The Business Central option field can be different from the corresponding Outlook option (different element names, different elements order). In this window you set relations between option elements.',ESP='Muestra los campos de opci¢n y las propiedades correspondientes de Outlook que tengan la misma estructura (de tipo enumeraci¢n o entero). El campo de opci¢n Business Central puede ser distinto que la opci¢n de Outlook correspondiente (distintos nombres de elementos, distinto orden de elementos). En esta ventana puede establecer relaciones entre los elementos de opci¢n.';
                      ApplicationArea=Basic,Suite;
                      Image="OutlookSyncSubFields";
                      
                                
    trigger OnAction()    BEGIN
                                 rec.ShowOOptionCorrelForm;
                               END;


    }

}

}
}
  trigger OnInit()    BEGIN
             UserDefinedEditable := TRUE;
             SearchFieldEditable := TRUE;
           END;

trigger OnAfterGetRecord()    BEGIN
                       SearchFieldEditable := rec."Element No." <> 0;
                       UserDefinedEditable := rec."Element No." = 0;
                     END;


    var
      OSynchSetupMgt : Codeunit 50849;
      SearchFieldEditable : Boolean ;
      UserDefinedEditable : Boolean ;

    //[External]
    procedure GetFormCaption() : Text[80];
    var
      OSynchEntity : Record 51280;
      OSynchEntityElement : Record 51281;
    begin
      if rec."Element No." = 0 then begin
        OSynchEntity.GET(rec."Synch. Entity Code");
        exit(STRSUBSTNO('%1 %2',OSynchEntity.TABLECAPTION,rec."Synch. Entity Code"));
      end;
      exit(STRSUBSTNO('%1 %2 %3',OSynchEntityElement.TABLECAPTION,rec."Synch. Entity Code",rec."Element No."));
    end;

    // begin//end
}








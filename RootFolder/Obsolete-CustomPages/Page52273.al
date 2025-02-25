page 52273 "Outlook Synch. Filters"
{
CaptionML=ENU='Outlook Synch. Filters',ESP='Filtros sinc. Outlook';
    SourceTable=51283;
    DelayedInsert=true;
    DataCaptionFields="Filter Type";
    PageType=Worksheet;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
group("Control11")
{
        
                CaptionML=ENU='Filter',ESP='Filtro';
    field("RecomposeFilterExpression";rec.RecomposeFilterExpression)
    {
        
                CaptionML=ENU='Filtering Expression',ESP='Expresi¢n de filtro';
                ToolTipML=ENU='Specifies a filter defined on the lines of the Outlook Synch. Filters window. The expression in this field is composed according to Dynamics 365 filter syntax.',ESP='Especifica un filtro definido en las l¡neas de la ventana Filtros sinc. Outlook. La expresi¢n de este campo se redacta siguiendo la sintaxis de los filtros de Dynamicsÿ365.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE ;
    }

}
repeater("Control1")
{
        
    field("Field No.";rec."Field No.")
    {
        
                ToolTipML=ENU='Specifies the number of the field with values that are used in the filter expression. A value in this field is appropriate if you specified the number of the table in the Table No. field.',ESP='Especifica el n£mero del campo cuyos valores se usan en la expresi¢n de filtro. Es recomendable insertar un valor en este campo si se especific¢ el n£mero de la tabla en el campo N.§ tabla.';
                ApplicationArea=Basic,Suite;
    }
    field("GetFieldCaption";rec.GetFieldCaption)
    {
        
                CaptionML=ENU='Field Name',ESP='Nombre de campo';
                ToolTipML=ENU='Specifies the name of the field whose values will be used in the filter expression. The program fills in this field when you specify the number of the field in the Field No. field.',ESP='Especifica el nombre del campo cuyos valores se usar n en la expresi¢n de filtro. El programa rellena este campo cuando se introduce el n£mero del campo que aparece en el campo N.§ campo.';
                ApplicationArea=Basic,Suite;
    }
    field("Type";rec."Type")
    {
        
                ToolTipML=ENU='Specifies what type of filtration is applied. There are three options you can choose from:',ESP='Especifica qu‚ tipo de filtro se aplica. Hay tres opciones disponibles:';
                ApplicationArea=Basic,Suite;
                
                            ;trigger OnValidate()    BEGIN
                             CheckValueAvailability;
                           END;


    }
    field("Value";rec."Value")
    {
        
                ToolTipML=ENU='Specifies the value that is compared with the value in the Field No. field.',ESP='Especifica el valor que se compara con el valor del campo N.§ campo.';
                ApplicationArea=Basic,Suite;
                Editable=ValueEditable ;
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
  trigger OnInit()    BEGIN
             ValueEditable := TRUE;
           END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  rec.SetTablesNo(TableLeftNo,TableRightNo);
                  CheckValueAvailability;
                END;

trigger OnInsertRecord(BelowxRec: Boolean): Boolean    VAR
                     ExistentFilterExpression : Text[250];
                   BEGIN
                     ExistentFilterExpression := OSynchSetupMgt.ComposeFilterExpression(rec."Record GUID",rec."Filter Type");
                     IF (STRLEN(ExistentFilterExpression) +
                         STRLEN(rec.GetFieldCaption) +
                         STRLEN(FORMAT(rec."Type")) +
                         STRLEN(rec."Value")) > MAXSTRLEN(ExistentFilterExpression)
                     THEN
                       ERROR(Text001);
                     EXIT(TRUE);
                   END;

trigger OnAfterGetCurrRecord()    BEGIN
                           CheckValueAvailability;
                         END;


    var
      OSynchSetupMgt : Codeunit 50849;
      TableLeftNo : Integer;
      TableRightNo : Integer;
      Text001 : TextConst ENU='The filter cannot be processed because the expression is too long. Redefine your criteria.',ESP='El filtro no se puede procesar porque la expresi¢n es demasiado larga. Vuelva a definir los criterios.';
      ValueEditable : Boolean ;

    //[External]
    procedure SetTables(LeftNo : Integer;RightNo : Integer);
    begin
      TableLeftNo := LeftNo;
      TableRightNo := RightNo;
    end;

    //[External]
    procedure CheckValueAvailability();
    begin
      if rec.Type = rec."Type"::FIELD then
        ValueEditable := FALSE
      ELSE
        ValueEditable := TRUE;
    end;

    // begin//end
}








page 7206919 "Filter Jobs by Att. Phone"
{
CaptionML=ENU='Filter Jobs by Attribute',ESP='Filtrar proyectos/estudios por atributo';
    SourceTable=7506;
    DataCaptionExpression='';
    PageType=List;
    SourceTableTemporary=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Attribute";rec."Attribute")
    {
        
                ToolTipML=ENU='Specifies the name of the attribute to filter on.',ESP='Especifica el nombre del atributo por el que se va a filtrar.';
                ApplicationArea=Basic,Suite;
                TableRelation="Job Attribute".Name ;
    }
    field("Value";rec."Value")
    {
        
                AssistEdit=true;
                ToolTipML=ENU='"Specifies the value of the filter. You can use single values or filter expressions, such as >,<,> ,< ,|,&, and 1..100."',ESP='"Especifica el valor del filtro. Puede usar valores �nicos o expresiones de filtro, como >, <, > , < , |, & y 1..100."';
                ApplicationArea=Basic,Suite;
                
                              

  ;trigger OnAssistEdit()    BEGIN
                               rec.ValueAssistEdit;
                             END;


    }

}

}
}
  trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       Rec.SETRANGE(Value,'');
                       Rec.DELETEALL;
                     END;


/*

    

begin
    {
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }
    end.*/
  

}









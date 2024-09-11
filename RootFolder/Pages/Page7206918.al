page 7206918 "Select Job Attribute Value"
{
CaptionML=ENU='Select Job Attribute Value',ESP='Seleccionar valor de atributo de proyecto/estudio';
    SourceTable=7206906;
    DataCaptionExpression='';
    PageType=StandardDialog;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Value";rec."Value")
    {
        
                ToolTipML=ENU='Specifies the value of the option.',ESP='Especifica el valor de la opci¢n.';
                ApplicationArea=Basic,Suite;
    }

}

}
}
  trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       CLEAR(DummySelectedJobAttributeValue);
                       CurrPage.SETSELECTIONFILTER(DummySelectedJobAttributeValue);
                     END;



    var
      DummySelectedJobAttributeValue : Record 7206906;

    //[External]
    procedure GetSelectedValue(var JobAttributeValue : Record 7206906);
    begin
      JobAttributeValue.COPY(DummySelectedJobAttributeValue);
    end;

    // begin
    /*{
      JAV 13/02/20: - Gesti¢n de atributos para proyectos
    }*///end
}









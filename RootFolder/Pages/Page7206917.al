page 7206917 "Filter Jobs - AssistEdit"
{
CaptionML=ENU='Specify Filter Value',ESP='Especificar valor de filtro';
    SourceTable=7206905;
    PageType=StandardDialog;
    
  layout
{
area(content)
{
group("group28")
{
        
group("group29")
{
        
                Visible=TextGroupVisible;
    field("TextConditions";TextConditions)
    {
        
                CaptionML=ENU='Condition',ESP='Condici�n';
                ToolTipML=ENU='"Specifies the condition for the filter value. Example: To specify that the value for a Material Description attribute must start with blue, fill the fields as follows: Condition field   Starts With. Value field   blue."',ESP='"Especifica la condici�n del valor de filtro. Por ejemplo, para especificar que el valor de un atributo Descripci�n del material debe comenzar por azul, rellene los campos de la siguiente manera: campo Condici�n   Empieza por. Campo Valor   azul."';
                OptionCaptionML=ENU='Condition',ESP='Condici�n';
                ApplicationArea=Basic,Suite;
    }
    field("TextValue";TextValue)
    {
        
                CaptionML=ENU='Value',ESP='Valor';
                ToolTipML=ENU='Specifies the filter value that the condition applies to.',ESP='Especifica el valor de filtro al que se aplica la condici�n.';
                ApplicationArea=Basic,Suite;
    }

}
group("group32")
{
        
                Visible=NumericGroupVisible;
    field("NumericConditions";NumericConditions)
    {
        
                CaptionML=ENU='Condition',ESP='Condici�n';
                ToolTipML=ENU='"Specifies the condition for the filter value. Example: To specify that the value for a Quantity attribute must be higher than 10, fill the fields as follows: Condition field > Greater. Value field   10."',ESP='"Especifica la condici�n del valor de filtro. Por ejemplo, para especificar que el valor de un atributo Cantidad sea mayor que 10, rellene los campos de la siguiente manera: campo Condici�n > Mayor. Campo Valor   10."';
                OptionCaptionML=ENU='Condition',ESP='Condici�n';
                ApplicationArea=Basic,Suite;
                
                            ;trigger OnValidate()    BEGIN
                             UpdateGroupVisiblity;
                           END;


    }
    field("NumericValue";NumericValue)
    {
        
                CaptionML=ENU='Value',ESP='Valor';
                ToolTipML=ENU='Specifies the filter value that the condition applies to.',ESP='Especifica el valor de filtro al que se aplica la condici�n.';
                ApplicationArea=Basic,Suite;
                
                            ;trigger OnValidate()    BEGIN
                             ValidateValueIsNumeric(NumericValue);
                           END;


    }
group("group35")
{
        
                Visible=NumericGroupMaxValueVisible;
    field("MaxNumericValue";MaxNumericValue)
    {
        
                CaptionML=ENU='To Value',ESP='Hasta valor';
                ToolTipML=ENU='Specifies the end value in the range.',ESP='Especifica el valor final del intervalo.';
                ApplicationArea=Basic,Suite;
                
                            

  ;trigger OnValidate()    BEGIN
                             ValidateValueIsNumeric(MaxNumericValue);
                           END;


    }

}

}

}

}
}
  trigger OnAfterGetCurrRecord()    BEGIN
                           UpdateGroupVisiblity;
                         END;



    var
      TextValue : Text

[240];
      TextConditions: Option "Contains","Starts With","Ends With","Exact Match";
      NumericConditions: Option "=  - Equals","..  - Range","  - Less","<= - Less or Equal",">  - Greater",">= - Greater or Equal";
      NumericValue : Text;
      MaxNumericValue : Text;
      NumericGroupVisible : Boolean;
      NumericGroupMaxValueVisible : Boolean;
      TextGroupVisible : Boolean;

    LOCAL procedure UpdateGroupVisiblity();
    begin
      TextGroupVisible := rec.Type = rec.Type::Text;
      NumericGroupVisible := rec.Type IN [rec.Type::Decimal,rec.Type::Integer];
      NumericGroupMaxValueVisible := NumericGroupVisible and (NumericConditions = NumericConditions::"..  - Range")
    end;

    LOCAL procedure ValidateValueIsNumeric(TextValue : Text);
    var
      ValidDecimal : Decimal;
      ValidInteger : Integer;
    begin
      if rec.Type = rec.Type::Decimal then
        EVALUATE(ValidDecimal,TextValue);

      if rec.Type = rec.Type::Integer then
        EVALUATE(ValidInteger,TextValue);
    end;

    //[External]
    procedure LookupOptionValue(PreviousValue : Text) : Text;
    var
      JobAttributeValue : Record 7206906;
      SelectedJobAttributeValue : Record 7206906;
      SelectJobAttributeValue : Page 7206918;
      OptionFilter : Text;
    begin
      JobAttributeValue.SETRANGE("Attribute ID",rec.ID);
      SelectJobAttributeValue.SETTABLEVIEW(JobAttributeValue);
      // SelectJobAttributeValue.LOOKUPMODE(TRUE);
      SelectJobAttributeValue.EDITABLE(FALSE);

      if not (SelectJobAttributeValue.RUNMODAL IN [ACTION::OK,ACTION::LookupOK]) then
        exit(PreviousValue);

      OptionFilter := '';
      SelectJobAttributeValue.GetSelectedValue(SelectedJobAttributeValue);
      if SelectedJobAttributeValue.FINDSET then begin
        repeat
          if SelectedJobAttributeValue.Value <> '' then
            OptionFilter := STRSUBSTNO('%1|%2',SelectedJobAttributeValue.Value,OptionFilter);
        until SelectedJobAttributeValue.NEXT = 0;
        OptionFilter := COPYSTR(OptionFilter,1,STRLEN(OptionFilter) - 1);
      end;

      exit(OptionFilter);
    end;

    //[External]
    procedure GenerateFilter() FilterText : Text;
    begin
      CASE rec.Type OF
        rec.Type::Decimal,rec.Type::Integer:
          begin
            if NumericValue = '' then
              exit('');

            if NumericConditions = NumericConditions::"..  - Range" then
              FilterText := STRSUBSTNO('%1..%2',NumericValue,MaxNumericValue)
            ELSE
              FilterText := STRSUBSTNO('%1%2',DELCHR(COPYSTR(FORMAT(NumericConditions),1,2),'=',' '),NumericValue);
          end;
        rec.Type::Text:
          begin
            if TextValue = '' then
              exit('');

            CASE TextConditions OF
              TextConditions::"Starts With":
                FilterText := STRSUBSTNO('@%1*',TextValue);
              TextConditions::"Ends With":
                FilterText := STRSUBSTNO('@*%1',TextValue);
              TextConditions::Contains:
                FilterText := STRSUBSTNO('@*%1*',TextValue);
              TextConditions::"Exact Match":
                FilterText := STRSUBSTNO('''%1''',TextValue);
            end;
          end;
      end;
    end;

    // begin
    /*{
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }*///end
}









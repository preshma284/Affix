page 7206911 "Job Attribute Values"
{
  ApplicationArea=All;

CaptionML=ENU='Job Attribute Values',ESP='Valores de atributo de proyecto/estudio';
    SourceTable=7206906;
    DataCaptionFields="Attribute ID";
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Value";rec."Value")
    {
        
                ToolTipML=ENU='Specifies the value of the Job attribute.',ESP='Especifica el valor del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
    }
    field("Blocked";rec."Blocked")
    {
        
                ToolTipML=ENU='Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an Job that is placed in quarantine.',ESP='Especifica que se ha bloqueado el registro relacionado para que no se registre en transacciones, por ejemplo, en el caso de un cliente que ha sido declarado insolvente o de un elemento que se encuentra en cuarentena.';
                ApplicationArea=Basic,Suite;
    }

}

}
}actions
{
area(Processing)
{

group("Process")
{
        
                      CaptionML=ENU='Process',ESP='Procesar';
    action("JobAttributeValueTranslations")
    {
        
                      CaptionML=ENU='Translations',ESP='Traducciones';
                      ToolTipML=ENU='Opens a window in which you can specify the translations of the selected Job attribute value.',ESP='Abre una ventana en la que se pueden especificar las traducciones del valor de atributo de proyecto/estudio seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 7206915;
RunPageLink="Attribute ID"=FIELD("Attribute ID"), "ID"=FIELD("ID");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Translations;
                      PromotedCategory=Process 
    ;
    }

}

}
}
  
trigger OnOpenPage()    VAR
                 AttributeID : Integer;
               BEGIN
                 IF Rec.GETFILTER("Attribute ID") <> '' THEN
                   AttributeID := Rec.GETRANGEMIN("Attribute ID");
                 IF AttributeID <> 0 THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Attribute ID",AttributeID);
                   Rec.FILTERGROUP(0);
                 END;
               END;


/*

    begin
    {
      JAV 13/02/20: - Gesti¢n de atributos para proyectos
    }
    end.*/
  

}










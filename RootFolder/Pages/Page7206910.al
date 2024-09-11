page 7206910 "Job Attributes"
{
  ApplicationArea=All;

CaptionML=ENU='"Job Attribute"s',ESP='Atributos de proyecto/estudio';
    SourceTable=7206905;
    PageType=List;
    UsageCategory=Lists;
    CardPageID="Job Attribute";
    RefreshOnActivate=true;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Name";rec."Name")
    {
        
                ToolTipML=ENU='Specifies the name of the Job attribute.',ESP='Especifica el nombre del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
    }
    field("Type";rec."Type")
    {
        
                ToolTipML=ENU='Specifies the type of the Job attribute.',ESP='Especifica el tipo del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
    }
    field("Values";rec."GetValues")
    {
        
                CaptionML=ENU='Values',ESP='Valores';
                ToolTipML=ENU='Specifies the values of the Job attribute.',ESP='Especifica los valores del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
                
                             ;trigger OnDrillDown()    BEGIN
                              rec.OpenJobAttributeValues;
                            END;


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

group("group2")
{
        CaptionML=ENU='&Attribute',ESP='&Atributo';
                      Image=Attributes;
    action("JobAttributeValues")
    {
        
                      CaptionML=ENU='Job Attribute &Values',ESP='&Valores de atributo de proyecto/estudio';
                      ToolTipML=ENU='Opens a window in which you can define the values for the selected Job attribute.',ESP='Abre una ventana en la que se pueden definir los valores para el atributo de proyecto/estudio seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 7206911;
RunPageLink="Attribute ID"=FIELD("ID");
                      Promoted=true;
                      Enabled=(rec.Type = rec.Type::Option);
                      PromotedIsBig=true;
                      Image=CalculateInventory;
                      PromotedCategory=Process;
                      PromotedOnly=true ;
    }
    action("JobAttributeTranslations")
    {
        
                      CaptionML=ENU='Translations',ESP='Traducciones';
                      ToolTipML=ENU='Opens a window in which you can define the translations for the selected Job attribute.',ESP='Abre una ventana en la que se pueden definir las traducciones para el atributo de proyecto/estudio seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 7206912;
RunPageLink="Attribute ID"=FIELD("ID");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Translations;
                      PromotedCategory=Process;
                      PromotedOnly=true 
    ;
    }

}

}
}
  /*

    begin
    {
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }
    end.*/
  

}










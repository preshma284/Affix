page 7206913 "Job Attribute"
{
CaptionML=ENU='Job Attribute',ESP='Atributo de proyecto/estudio';
    SourceTable=7206905;
    PageType=Card;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
group("group5")
{
        
group("group6")
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
                
                            ;trigger OnValidate()    BEGIN
                             UpdateControlVisibility;
                           END;


    }
    field("Blocked";rec."Blocked")
    {
        
                ToolTipML=ENU='Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an Job that is placed in quarantine.',ESP='Especifica que se ha bloqueado el registro relacionado para que no se registre en transacciones, por ejemplo, en el caso de un cliente que ha sido declarado insolvente o de un elemento que se encuentra en cuarentena.';
                ApplicationArea=Basic,Suite;
    }

}
group("group10")
{
        
                Visible=ValuesDrillDownVisible;
    field("Values";rec."GetValues")
    {
        
                CaptionML=ENU='Values',ESP='Valores';
                ToolTipML=ENU='Specifies the values of the Job attribute.',ESP='Especifica los valores del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE;
                
                             ;trigger OnDrillDown()    BEGIN
                              rec.OpenJobAttributeValues;
                            END;


    }

}
group("group12")
{
        
                Visible=UnitOfMeasureVisible;
    field("Unit of Measure";rec."Unit of Measure")
    {
        
                DrillDown=false;
                ToolTipML=ENU='Specifies the name of the Job or resources unit of measure, such as piece or hour.',ESP='Especifica el nombre de la unidad de medida del proyecto/estudio o recurso, como la unidad o la hora.';
                ApplicationArea=Basic,Suite;
                
                             

  ;trigger OnDrillDown()    BEGIN
                              rec.OpenJobAttributeValues;
                            END;


    }

}

}

}
}actions
{
area(Processing)
{

    action("JobAttributeValues")
    {
        
                      CaptionML=ENU='Job Attribute &Values',ESP='&Valores de atributo de proyecto/estudio';
                      ToolTipML=ENU='Opens a window in which you can define the values for the selected Job attribute.',ESP='Abre una ventana en la que se pueden definir los valores para el atributo de proyecto/estudio seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 7206911;
RunPageLink="Attribute ID"=FIELD("ID");
                      Promoted=true;
                      Enabled=ValuesDrillDownVisible;
                      PromotedIsBig=true;
                      Image=CalculateInventory;
                      PromotedCategory=Process ;
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
                      PromotedCategory=Process 
    ;
    }

}
}
  
trigger OnOpenPage()    BEGIN
                 UpdateControlVisibility;
               END;

trigger OnAfterGetCurrRecord()    BEGIN
                           UpdateControlVisibility;
                         END;



    var
      ValuesDrillDownVisible : Boolean;
      UnitOfMeasureVisible : Boolean;

    

LOCAL procedure UpdateControlVisibility();
    begin
      ValuesDrillDownVisible := (rec.Type = rec.Type::Option);
      UnitOfMeasureVisible := (rec.Type = rec.Type::Decimal) or (rec.Type = rec.Type::Integer);
    end;

    // begin
    /*{
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }*///end
}









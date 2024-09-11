page 7206921 "Job Attributes Factbox"
{
CaptionML=ENU='Job Attributes',ESP='Atributos de proyecto/estudio';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206906;
    PageType=ListPart;
    SourceTableTemporary=true;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Attribute";rec."GetAttributeNameInCurrentLanguage")
    {
        
                CaptionML=ENU='Attribute',ESP='Atributo';
                ToolTipML=ENU='Specifies the name of the Job attribute.',ESP='Especifica el nombre del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
                Visible=TranslatedValuesVisible ;
    }
    field("Value";rec."GetValueInCurrentLanguage")
    {
        
                CaptionML=ENU='Value',ESP='Valor';
                ToolTipML=ENU='Specifies the value of the Job attribute.',ESP='Especifica el valor del atributo de proyecto/estudio.';
                ApplicationArea=Basic,Suite;
                Visible=TranslatedValuesVisible ;
    }
    field("Attribute Name";rec."Attribute Name")
    {
        
                CaptionML=ENU='Attribute',ESP='Atributo';
                ToolTipML=ENU='Specifies the name of the Job attribute.',ESP='Especifica el nombre del atributo de art�culo.';
                ApplicationArea=Basic,Suite;
                Visible=NOT TranslatedValuesVisible ;
    }
    field("RawValue";rec."Value")
    {
        
                CaptionML=ENU='Value',ESP='Valor';
                ToolTipML=ENU='Specifies the value of the Job attribute.',ESP='Especifica el valor del atributo de art�culo.';
                ApplicationArea=Basic,Suite;
                Visible=NOT TranslatedValuesVisible 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("Edit")
    {
        
                      AccessByPermission=TableData 7206905=R;
                      CaptionML=ENU='Edit',ESP='Editar';
                      ToolTipML=ENU='Edit Jobs attributes, such as color, size, or other characteristics that help to describe the Job.',ESP='Permite editar los atributos del proyecto/estudio, como el color, el tama�o u otras caracter�sticas que ayudan a describir el proyecto/estudio.';
                      ApplicationArea=Basic,Suite;
                      Visible=IsJob;
                      Image=Edit;
                      
                                
    trigger OnAction()    VAR
                                 Job : Record 167;
                               BEGIN
                                 IF NOT IsJob THEN
                                   EXIT;
                                 IF NOT Job.GET(ContextValue) THEN
                                   EXIT;
                                 PAGE.RUNMODAL(PAGE::"Job Attribute Value Editor",Job);
                                 CurrPage.SAVERECORD;
                                 LoadJobAttributesData(ContextValue);
                               END;


    }

}
}
  trigger OnOpenPage()    BEGIN
                 Rec.SETAUTOCALCFIELDS("Attribute Name");
                 TranslatedValuesVisible := ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Phone;
               END;



    var
      ClientTypeManagement : Codeunit 50192;
      TranslatedValuesVisible : Boolean;
      ContextType: Option "None","Job","Category";
      ContextValue : Code[20];
      IsJob : Boolean;

    //[External]
    procedure LoadJobAttributesData(KeyValue : Code[20]);
    begin
      rec.LoadJobAttributesFactBoxData(KeyValue);
      SetContext(ContextType::Job,KeyValue);
      CurrPage.UPDATE(FALSE);
    end;

    //[External]
    procedure LoadCategoryAttributesData(CategoryCode : Code[20]);
    begin
      rec.LoadCategoryAttributesFactBoxData(CategoryCode);
      SetContext(ContextType::Category,CategoryCode);
      CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure SetContext(NewType : Option;NewValue : Code[20]);
    begin
      ContextType := NewType;
      ContextValue := NewValue;
      IsJob := ContextType = ContextType::Job;
    end;

    // begin
    /*{
      JAV 13/02/20: - Gesti�n de atributos para proyectos
    }*///end
}









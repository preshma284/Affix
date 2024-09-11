page 50003 "QuoSync Tables Setup"
{
CaptionML=ENU='Company Sync Tables Setup',ESP='Sincronizar Empresas: Tablas';
    SourceTable=50003;
    DelayedInsert=true;
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("table1")
{
        
    field("Table";rec."Table")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("Table Name";rec."Table Name")
    {
        
    }
    field("Field";rec."Field")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
    field("Caption";rec."Caption")
    {
        
    }
    field("Direction";rec.Direction)
    {
        
                Editable=edTable ;
    }
    field("Not Sync";rec."Not Sync")
    {
        
                ToolTipML=ESP='En la sicronizaci�n por tablas, incica si el campo no ser� editable en la empresa de destino de la sincronizaci�n';
                Editable=edField 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("SyncAll")
    {
        
                      CaptionML=ENU='Sync Table',ESP='Sincronizar Tabla';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=CopyItem;
                      PromotedCategory=Process 
    ;
    }

}
}
  trigger OnOpenPage()    BEGIN
                 QuoBuildingSetup.GET;
               END;

trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;



    var
      QuoBuildingSetup : Record 7207278;
      edTable : Boolean;
      edField : Boolean;

    LOCAL procedure SetEditable();
    begin
      edTable := (rec.Field = 0);
      edField := (rec.Field <> 0);
    end;

    // begin//end
}









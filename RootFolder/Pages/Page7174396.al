page 7174396 "QM Data Synchronization Log Ge"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Data Synchronization Log',ESP='Log de Sincronizaci�n';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174395;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Table";rec."Table")
    {
        
    }
    field("RecordID";rec.RecordID)
    {
        
                Visible=FALSE ;
    }
    field("Code 1";rec."Code 1")
    {
        
    }
    field("From Company";rec."From Company")
    {
        
    }
    field("With Company";rec."With Company")
    {
        
    }
    field("QMMasterDataManagement.ExistCompany(rec.With Company)";QMMasterDataManagement.ExistCompany(rec."With Company"))
    {
        
                CaptionML=ESP='Existe la empresa';
    }
    field("QMMasterDataManagement.ExistCodeInCompany(RecordID, With Company)";QMMasterDataManagement.ExistCodeInCompany(rec.RecordID, rec."With Company"))
    {
        
                CaptionML=ESP='Existe en destino';
                Editable=FALSE ;
    }
    field("Creation Date";rec."Creation Date")
    {
        
    }
    field("Update Date";rec."Update Date")
    {
        
                Editable=FALSE ;
    }
    field("Modified in Destination";rec."Modified in Destination")
    {
        
    }
    field("Not in Master";rec."Not in Master")
    {
        
    }

}

}
}actions
{
area(Processing)
{


}
}
  
    var
      QMMasterDataManagement : Codeunit 7174368;

    /*begin
    end.
  
*/
}










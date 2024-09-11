page 7174395 "QM Data Synchronization Log"
{
CaptionML=ENU='Data Synchronization',ESP='Sincronizar entre empresas';
    SourceTable=7174395;
    PageType=ListPart;
    
  layout
{
area(content)
{
group("group6")
{
        
                Visible=SeeInDestination;
    field("MDL.From Company";MDL."From Company")
    {
        
                CaptionML=ESP='Desde la empresa';
                Editable=false ;
    }
    field("MDL.Creation Date";MDL."Creation Date")
    {
        
                CaptionML=ESP='Fecha de creaci�n';
                Editable=false ;
    }
    field("MDL.Update Date";MDL."Update Date")
    {
        
                CaptionML=ESP='Fecha de actualziaci�n';
                Editable=false ;
    }
    field("MDL.Modified in Destination";MDL."Modified in Destination")
    {
        
                CaptionML=ESP='Modificado en la empresa actual';
                Editable=false ;
    }

}
repeater("Group")
{
        
                Visible=SeeInMaster;
    field("Table";rec."Table")
    {
        
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("RecordID";rec.RecordID)
    {
        
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("With Company";rec."With Company")
    {
        
    }
    field("ExistCompany(Rec)";rec.ExistCompany(Rec))
    {
        
                CaptionML=ESP='Existe la empresa';
    }
    field("QMMasterDataManagement.IsSyncActiveFromTable(Rec.With Company, Rec.Table)";QMMasterDataManagement.IsSyncActiveFromTable(Rec."With Company", Rec.Table))
    {
        
                CaptionML=ESP='Sincronizaci�n Autom�tica';
                Editable=false ;
    }
    field("ExistCodeInCompany(Rec)";rec.ExistCodeInCompany(Rec))
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

}

}
}actions
{
area(Processing)
{

    action("QM_Cargar")
    {
        
                      CaptionML=ESP='Cargar Empresas';
                      Promoted=true;
                      Visible=SeeInMaster;
                      PromotedIsBig=true;
                      Image=SetupList;
                      
                                trigger OnAction()    BEGIN
                                 CurrPage.UPDATE;

                                 QMMasterDataCompanieTable.RESET;
                                 QMMasterDataCompanieTable.SETRANGE("Table No.", gTable);
                                 QMMasterDataCompanieTable.SETRANGE(Sync, QMMasterDataCompanieTable.Sync::Manual);
                                 IF (QMMasterDataCompanieTable.FINDSET(FALSE)) THEN
                                   REPEAT
                                     QMMasterDataDataSyncLog.INIT;
                                     QMMasterDataDataSyncLog.Table := gTable;
                                     QMMasterDataDataSyncLog.RecordID := gRecordID;
                                     QMMasterDataDataSyncLog."With Company" := QMMasterDataCompanieTable.Company;
                                     //QMMasterDataDataSyncLog."Code 1" := gCode1;
                                     QMMasterDataDataSyncLog."From Company" := QMMasterDataManagement.GetMaster;
                                     IF NOT QMMasterDataDataSyncLog.INSERT(TRUE) THEN;
                                   UNTIL (QMMasterDataCompanieTable.NEXT = 0);

                                 CurrPage.UPDATE;
                               END;


    }
    action("QM_Sync")
    {
        
                      CaptionML=ESP='Sincronizar';
                      Promoted=true;
                      Visible=SeeInMaster;
                      PromotedIsBig=true;
                      Image=Copy;
                      
                                trigger OnAction()    BEGIN
                                 CurrPage.UPDATE;
                                 rec.SyncUp(rec.RecordID);
                               END;


    }
    action("QM_Update")
    {
        
                      CaptionML=ESP='Actualizar';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=UpdateDescription;
                      
                                
    trigger OnAction()    VAR
                                 oRR : RecordRef;
                               BEGIN
                                 CurrPage.UPDATE;
                                 IF (QMMasterDataManagement.IsMasterCompany) THEN
                                   //Estamos en la empresa master, actualizamos todos los registros de las empresas relacionadas
                                   rec.UpdateFields(rec.RecordID)
                                 ELSE BEGIN
                                   //No estamos en la empresa master, actualizamos el restro actual desde las master
                                   oRR.OPEN(Rec.Table);                                                      //Abro el registro de destino
                                   oRR.CHANGECOMPANY(QMMasterDataManagement.GetMaster);                      //Cambio la empresa en el destino
                                   oRR.GET(rec.RecordID);                                                        //Busco el restro en destino
                                   QMMasterDataManagement.UpdateRecord(COMPANYNAME, oRR, FALSE, TRUE);       //Copiamos el registro desde Master al actual
                                   GetRegister;
                                 END;
                               END;


    }

}
}
  trigger OnInit()    BEGIN
             SeeInMaster := TRUE;
             SeeInDestination := TRUE;
           END;

trigger OnOpenPage()    BEGIN
                 SeeInMaster := QMMasterDataManagement.IsMasterCompany;
                 SeeInDestination := NOT SeeInMaster;
               END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  Rec.Table := gTable;
                  Rec."Code 1" := gCode1;
                  Rec.RecordID := gRecordID;
                END;



    var
      gTable : Integer;
      gCode1 : Code[20];
      gRecordID : RecordID;
      "-------------------------------" : Integer;
      QMMasterDataManagement : Codeunit 7174368;
      QMMasterDataCompanieTable : Record 7174394;
      QMMasterDataDataSyncLog : Record 7174395;
      MDL : Record 7174395;
      SeeInMaster : Boolean;
      SeeInDestination : Boolean;
      IsAutomatic : Boolean;

    procedure SetData(pRecordID : RecordID);
    var
      Txt : Text;
      i : Integer;
    begin
      Rec.SetCodesFromRId(pRecordID);

      gTable := pRecordID.TABLENO;
      gRecordID := pRecordID;
      gCode1 := Rec."Code 1";

      GetRegister;
    end;

    LOCAL procedure GetRegister();
    begin
      MDL.RESET;
      MDL.SETRANGE(Table, gTable);
      MDL.SETRANGE("With Company", COMPANYNAME);
      MDL.SETRANGE("Code 1", gCode1);
      if not MDL.FINDFIRST then
        MDL.INIT;
    end;

    // begin//end
}









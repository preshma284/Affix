pageextension 50277 MyExtension76 extends 76//156
{
layout
{
addafter("General")
{
group("Control100000001")
{
        
                CaptionML=ENU='Invoicing',ESP='QuoBuilding';
    field("QB_DataMissedMessage";rec."Data Missed Message")
    {
        
                Visible=QB_MandatoryFields ;
}
group("Control100000002")
{
        
                CaptionML=ENU='Invoicing',ESP='Facturaci¢n y Externos';
    field("Jobs Deviation";rec."Jobs Deviation")
    {
        
}
    field("Vendor No.";rec."Vendor No.")
    {
        
}
}
group("Control1100286002")
{
        
                CaptionML=ENU='Invoicing',ESP='Facturaci¢n';
    field("Activity Code";rec."Activity Code")
    {
        
}
    field("QB Proformable";rec."QB Proformable")
    {
        
                ToolTipML=ESP='Si el recurso se puede incluir en una proforma (por defecto los que sean tipo subcontrata lo ser n)';
}
    field("Cod. C.A. Direct Costs";rec."Cod. C.A. Direct Costs")
    {
        
}
    field("Cod. C.A. Indirect Costs";rec."Cod. C.A. Indirect Costs")
    {
        
}
    field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
    {
        
}
    field("Global Dimension 2 Code";rec."Global Dimension 2 Code")
    {
        
}
    field("Created by PRESTO S/N";rec."Created by PRESTO S/N")
    {
        
}
}
group("Control7001111")
{
        
                CaptionML=ENU='Machine',ESP='Maquinaria';
    field("Type Calendar";rec."Type Calendar")
    {
        
}
    field("Cod. Type Jobs not Assigned";rec."Cod. Type Jobs not Assigned")
    {
        
}
    field("Jobs Not Assigned";rec."Jobs Not Assigned")
    {
        
}
    field("Cod. Type Depreciation Jobs";rec."Cod. Type Depreciation Jobs")
    {
        
}
    field("Potency (PH)";rec."Potency (PH)")
    {
        
}
    field("Actual Cost";rec."Actual Cost")
    {
        
}
    field("Usage (ITS/HR x HP)";rec."Usage (ITS/HR x HP)")
    {
        
}
}
}
    part("QM_Data_Synchronization_Log";7174395)
    {
        
                SubPageView=SORTING("Table","RecordID","With Company");SubPageLink="Table"=CONST(18), "Code 1"=field("No.");
                Visible=verMasterData;
}
group("Control100000003")
{
        
                CaptionML=ENU='Invoicing',ESP='Facturaci¢n';
}
}

}

actions
{
addafter("Costs")
{
    action("QB_GetTransferCost")
    {
        CaptionML=ENU='Transfer Cost',ESP='Costes de cesi¢n';
                      Promoted=true;
                      Image=CalculateCost;
                      PromotedCategory=Process;
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 QMMasterDataManagement : Codeunit 7174368;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 SetNoFieldVisible;
                 IsCountyVisible := FormatAddress.UseCounty(rec."Country/Region Code");

                 //QB
                 //JAV 02/04/20: - Campo visible si faltan datos
                 rRef.GETTABLE(Rec);
                 QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);

                 //JAV 01/03/21: - QB 1.08.19 Se pasan funciones de QBSetup a Functions QB
                 //JAV 14/02/22: - QM 1.00.00 Se pasana las funciones de MasterData a su propia CU
                 verMasterData := QMMasterDataManagement.SetMasterDataVisible(DATABASE::Resource);
               END;
trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  IF GUIALLOWED THEN BEGIN
                    IF rec."No." = '' THEN
                      NewMode := TRUE;
                  END;
                END;
trigger OnAfterGetCurrRecord()    VAR
                           CRMCouplingManagement : Codeunit 5331;
                         BEGIN
                           CreateResourceFromTemplate;

                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
                             IF rec."No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;

                           //QB
                           //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
                           QB_BlockedEnabled  := NOT rec."Data Missed";

                           //JAV 14/02/22: - QM 1.00.00 Se pasan los valores adecuados a la subp gina
                           CurrPage.QM_Data_Synchronization_Log.PAGE.SetData(Rec.RECORDID);
                         END;


//trigger

var
      CRMIntegrationManagement : Codeunit 5330;
      FormatAddress : Codeunit 365;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      NoFieldVisible : Boolean;
      IsCountyVisible : Boolean;
      "--------------------------- QB" : Integer;
      NewMode : Boolean;
      QB_MandatoryFields : Boolean;
      rRef : RecordRef;
      QBTablesSetup : Record 7206903;
      QB_BlockedEnabled : Boolean;
      verMasterData : Boolean;
      FunctionQB : Codeunit 7207272;

    
    

//procedure
Local procedure SetNoFieldVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
   begin
     NoFieldVisible := DocumentNoVisibility.ResourceNoIsVisible;
   end;
LOCAL procedure "--------------------------------------- QB"();
    begin
    end;
LOCAL procedure CreateResourceFromTemplate();
    var
      Resource : Record 156;
    begin
      if ( NewMode  )then begin
        if ( NewResourceFromTemplate(Resource)  )then begin
          Rec.COPY(Resource);
          CurrPage.UPDATE;
        end;
        NewMode := FALSE;
      end;
    end;

    //[Internal]
procedure NewResourceFromTemplate(var Resource : Record 156) : Boolean;
    var
      ConfigTemplateHeader : Record 8618;
      ConfigTemplates : Page 1340;
    begin
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Resource);
      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);

      if ( ConfigTemplateHeader.COUNT = 1  )then begin
        ConfigTemplateHeader.FINDFIRST;
        InsertResourceFromTemplate(ConfigTemplateHeader, Resource);
        exit(TRUE);
      end;

      if ( (ConfigTemplateHeader.COUNT > 1) and GUIALLOWED  )then begin
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        ConfigTemplates.SetNewMode;
        if ( ConfigTemplates.RUNMODAL = ACTION::LookupOK  )then begin
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          InsertResourceFromTemplate(ConfigTemplateHeader, Resource);
          exit(TRUE);
        end;
      end;

      exit(FALSE);
    end;

    //[External]
procedure InsertResourceFromTemplate(ConfigTemplateHeader : Record 8618;var Resource : Record 156);
    var
      DimensionsTemplate : Record 1302;
      ConfigTemplateMgt : Codeunit 8612;
      RecRef : RecordRef;
    begin
      InitResourceNo(Resource, ConfigTemplateHeader);
      Resource.INSERT(TRUE);
      RecRef.GETTABLE(Resource);
      ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader, RecRef);
      RecRef.SETTABLE(Resource);

      DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Resource."No.",DATABASE::Resource);
      Resource.FIND;
    end;
LOCAL procedure InitResourceNo(var Resource : Record 156;ConfigTemplateHeader : Record 8618);
    var
      NoSeriesMgt : Codeunit 396;
    begin
      if ( ConfigTemplateHeader."Instance No. Series" <> ''  )then
        NoSeriesMgt.InitSeries(ConfigTemplateHeader."Instance No. Series", '', 0D, Resource."No.", Resource."No. Series");
    end;

//procedure
}


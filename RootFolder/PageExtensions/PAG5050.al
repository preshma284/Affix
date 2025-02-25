pageextension 50209 MyExtension5050 extends 5050//5050
{
layout
{
addafter("Parental Consent Received")
{
    field("QB_AreaActivity";rec."Area Activity")
    {
        
}
    field("QB_ActivityFilter";rec."Activity Filter")
    {
        
}
    field("QB_Category";rec."Category")
    {
        
}
    field("QB_Referente";rec."Tipo Referente")
    {
        
                Visible=verReferente;
                Editable=edEmpresa ;
}
    field("QB_DimReferente";rec."Valor Dimension")
    {
        
                Visible=verDimReferente;
                Editable=edEmpresa ;
}
    field("QB_Bloqueado";rec."Bloqueado")
    {
        
                Visible=verDimReferente ;
}
}

}

actions
{
addafter("Office Customer/Vendor")
{
    action("QB_ContactActivities")
    {
        CaptionML=ENU='Contact Activities',ESP='Actividades del Contacto';
                      RunObject=Page 7207605;
                      RunPageView=SORTING("Contact No.","Activity Code");
RunPageLink="Contact No."=field("No.");
                      Image=WorkCenter;
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 OfficeManagement : Codeunit 1630;
               BEGIN
                 IsOfficeAddin := OfficeManagement.IsAvailable;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 SetNoFieldVisible;
                 SetParentalConsentReceivedEnable;

                 //QBA-01 03/05/19 JAV: - Mejora en las adaptaciones de los clientes
                 verReferente := FunctionQB.QB_UseReferents;
                 verDimReferente := (FunctionQB.ReturnDimReferents <> '');
               END;
trigger OnAfterGetCurrRecord()    VAR
                           CRMCouplingManagement : Codeunit 5331;
                         BEGIN
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
                             IF rec."No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;

                           xRec := Rec;
                           EnableFields;

                           IF rec.Type = rec."Type"::Person THEN
                             IntegrationFindCustomerNo
                           ELSE
                             IntegrationCustomerNo := '';

                           //QBA-01 19/01/19 JAV - Editable el campo de tipo
                           edEmpresa := (rec."Type" = rec."Type"::Company);
                         END;


//trigger

var
      CRMIntegrationManagement : Codeunit 5330;
      CompanyDetails : Page 5054;
      NameDetails : Page 5055;
      IntegrationCustomerNo : Code[20];
      CurrencyCodeEnable : Boolean ;
      VATRegistrationNoEnable : Boolean ;
      CompanyNameEnable : Boolean ;
      OrganizationalLevelCodeEnable : Boolean ;
      CompanyGroupEnabled : Boolean;
      PersonGroupEnabled : Boolean;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      IsOfficeAddin : Boolean;
      ActionVisible : Boolean;
      ShowMapLbl : TextConst ENU='Show Map',ESP='Mostrar mapa';
      NoFieldVisible : Boolean;
      ParentalConsentReceivedEnable : Boolean;
      "-------------------------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      edEmpresa : Boolean ;
      verReferente : Boolean ;
      verDimReferente : Boolean ;
      recContact : Record 5050;

    
    

//procedure
Local procedure EnableFields();
   begin
     CompanyGroupEnabled := rec."Type" = rec."Type"::Company;
     PersonGroupEnabled := rec."Type" = rec."Type"::Person;
     CurrencyCodeEnable := rec."Type" = rec."Type"::Company;
     VATRegistrationNoEnable := rec."Type" = rec."Type"::Company;
     CompanyNameEnable := rec."Type" = rec."Type"::Person;
     OrganizationalLevelCodeEnable := rec."Type" = rec."Type"::Person;
   end;
Local procedure IntegrationFindCustomerNo();
   var
     ContactBusinessRelation : Record 5054;
   begin
     ContactBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
     ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
     ContactBusinessRelation.SETRANGE("Contact No.",rec."Company No.");
     if ( ContactBusinessRelation.FINDFIRST  )then begin
       IntegrationCustomerNo := ContactBusinessRelation."No.";
     end ELSE
       IntegrationCustomerNo := '';
   end;
//Local procedure TypeOnAfterValidate();
//    begin
//      EnableFields;
//    end;
Local procedure SetNoFieldVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
   begin
     NoFieldVisible := DocumentNoVisibility.ContactNoIsVisible;
   end;
Local procedure SetParentalConsentReceivedEnable();
   begin
     if ( rec."Minor"  )then
       ParentalConsentReceivedEnable := TRUE
     ELSE begin
       rec."Parental Consent Received" := FALSE;
       ParentalConsentReceivedEnable := FALSE;
     end;
   end;
//
//    [Integration]
//Local procedure OnBeforePrintContactCoverSheet(var ContactCoverSheetReportID : Integer);
//    begin
//    end;

//procedure
}


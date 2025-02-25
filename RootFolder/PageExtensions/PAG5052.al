pageextension 50210 MyExtension5052 extends 5052//5050
{
layout
{
addafter("Company Name")
{
    field("QB_TipoReferente";rec."Tipo Referente")
    {
        
                Visible=verReferente ;
}
    field("QB_ValorDimension";rec."Valor Dimension")
    {
        
                Visible=verReferente ;
}
    field("QB_Bloqueado";rec."Bloqueado")
    {
        
                Visible=verReferente ;
}
}

}

actions
{
addafter("Statistics")
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
                 CRMIntegrationManagement : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 //QBA-01 03/05/19 JAV: - Mejora en las adaptaciones de los clientes
                 verReferente := FunctionQB.QB_UseReferents;
               END;


//trigger

var
      ClientTypeManagement : Codeunit 50192; //change from  4
      CRMCouplingManagement : Codeunit 5331;
      StyleIsStrong : Boolean ;
      CompanyGroupEnabled : Boolean;
      PersonGroupEnabled : Boolean;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      ActionVisible : Boolean;
      "----------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      verReferente : Boolean ;

    
    

//procedure
//Local procedure EnableFields();
//    begin
//      CompanyGroupEnabled := rec."Type" = rec."Type"::Company;
//      PersonGroupEnabled := rec."Type" = rec."Type"::Person;
//    end;
//
//    //[Internal]
//procedure SyncExchangeContacts(FullSync : Boolean);
//    var
//      ExchangeSync : Record 6700;
//      O365SyncManagement : Codeunit 6700;
//      ExchangeContactSync : Codeunit 6703;
//    begin
//      if ( O365SyncManagement.IsO365Setup(TRUE)  )then
//        if ( ExchangeSync.GET(USERID)  )then begin
//          ExchangeContactSync.GetRequestParameters(ExchangeSync);
//          O365SyncManagement.SyncExchangeContacts(ExchangeSync,FullSync);
//        end;
//    end;
//
//    //[External]
//procedure GetSelectionFilter() : Text;
//    var
//      Contact : Record 5050;
//      SelectionFilterManagement : Codeunit 46;
//    begin
//      CurrPage.SETSELECTIONFILTER(Contact);
//      exit(SelectionFilterManagement.GetSelectionFilterForContact(Contact));
//    end;
//
//    //[External]
//procedure SetSelection(var Contact : Record 5050);
//    begin
//      CurrPage.SETSELECTIONFILTER(Contact);
//    end;
procedure SelectContact(var ContactPass : Record 5050);
    begin
      CurrPage.SETSELECTIONFILTER(ContactPass); //QB2515
    end;

//procedure
}


pageextension 50164 MyExtension27 extends 27//23
{
layout
{
addafter("Name")
{
    field("VAT Registration No.";rec."VAT Registration No.")
    {
        
}
    field("QB No. Activities";rec."QB No. Activities")
    {
        
}
    field("E-Mail";rec."E-Mail")
    {
        
                CaptionML=ESP='Correo electr¢nico';
}
    field("QB_Address";rec."Address")
    {
        
}
    field("QB_City";rec."City")
    {
        
}
    field("County";rec."County")
    {
        
}
    field("Net Change";rec."Net Change")
    {
        
}
    field("QW Withholding Group by G.E.";rec."QW Withholding Group by G.E.")
    {
        
}
    field("QW Withholding Group by PIT";rec."QW Withholding Group by PIT")
    {
        
}
    field("QB Employee";rec."QB Employee")
    {
        
}
    field("QB Main Activity Code";rec."QB Main Activity Code")
    {
        
}
    field("QB Main Activity Description";rec."QB Main Activity Description")
    {
        
}
    field("QB Obralia";rec."QB Obralia")
    {
        
                Visible=vObralia ;
}
} addafter("Payment Terms Code")
{
    field("QB_PaymentMethodCode";rec."Payment Method Code")
    {
        
}
} addfirst("factboxes")
{    part("DropArea";7174655)
    {
        
                Visible=seeDragDrop;
}
    part("FilesSP";7174656)
    {
        
                Visible=seeDragDrop;
}
} addafter("VendorDetailsFactBox")
{
    part("part7";7207403)
    {
        SubPageLink="No."=field("No.");
                Visible=TRUE;
}
}

}

actions
{
addafter("History")
{
group("Action1100286004")
{
        CaptionML=ENU='History',ESP='Datos';
                      Image=History ;
    action("QB_Quality")
    {
        CaptionML=ENU='Quality',ESP='Calidad';
                      RunObject=Page 7207339;
RunPageLink="Vendor No."=field("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=TransferFunds;
                      PromotedCategory=Category5;
}
}
} addafter("Ledger E&ntries")
{
    action("QB_WithholdingMovs")
    {
        CaptionML=ENU='Withholding Movs.',ESP='Movs. retenci¢n';
                      RunObject=Page 7207400;
                      RunPageView=SORTING("Type","No.","Open");
RunPageLink="Type"=FILTER('Vendor'), "No."=field("No."), "Open"=CONST(true);
                      Promoted=true;
                      Image=ReturnRelated;
                      PromotedCategory=Process;
}
}

}

//trigger
trigger OnOpenPage()    VAR
                //  SocialListeningSetup : Record 870;
               BEGIN
                 Rec.SETFILTER("Date Filter",'..%1',WORKDATE);
                //  WITH SocialListeningSetup DO
                //    SocialListeningSetupVisible := Rec.GET AND "Show on Customers" AND "Accept License Agreement" AND ("Solution ID" <> '');

                 ResyncVisible := ReadSoftOCRMasterDataSync.IsSyncEnabled;

                 vObralia := FunctionQB.AccessToObralia;

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Vendor);
                 //Q7357 +
               END;
trigger OnAfterGetCurrRecord()    VAR
                           SocialListeningMgt : Codeunit 50455;
                         BEGIN
                           IF SocialListeningSetupVisible THEN
                             SocialListeningMgt.GetVendFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           // Contextual Power BI FactBox: send data to filter the report in the FactBox
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection(rec."No.",FALSE,PowerBIVisible);
                         END;


//trigger

var
      ApprovalsMgmt : Codeunit 1535;
      ReadSoftOCRMasterDataSync : Codeunit 884;
      WorkflowWebhookManagement : Codeunit 1543;
      SocialListeningSetupVisible : Boolean ;
      SocialListeningVisible : Boolean ;
      OpenApprovalEntriesExist : Boolean;
      CanCancelApprovalForRecord : Boolean;
      PowerBIVisible : Boolean;
      ResyncVisible : Boolean;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      "--------------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vObralia : Boolean;
      seeDragDrop : Boolean;

    

//procedure
//procedure GetSelectionFilter() : Text;
//    var
//      Vend : Record 23;
//      SelectionFilterManagement : Codeunit 46;
//    begin
//      CurrPage.SETSELECTIONFILTER(Vend);
//      exit(SelectionFilterManagement.GetSelectionFilterForVendor(Vend));
//    end;
//
//    //[External]
//procedure SetSelection(var Vend : Record 23);
//    begin
//      CurrPage.SETSELECTIONFILTER(Vend);
//    end;
//Local procedure SetVendorNoVisibilityOnFactBoxes();
//    begin
//      CurrPage.VendorDetailsFactBox.PAGE.SetVendorNoVisibility(FALSE);
//      CurrPage.VendorHistBuyFromFactBox.PAGE.SetVendorNoVisibility(FALSE);
//      CurrPage.VendorHistPayToFactBox.PAGE.SetVendorNoVisibility(FALSE);
//      CurrPage.VendorStatisticsFactBox.PAGE.SetVendorNoVisibility(FALSE);
//    end;

//procedure
}


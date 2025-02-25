pageextension 50132 MyExtension140 extends 140//124
{
layout
{
addafter("Buy-from Vendor Name")
{
    field("QB_JobNo";rec."Job No.")
    {
        
                Editable=FALSE ;
}
} addafter("Posting Date")
{
    field("QB_DocumentAmount";rec."Total document amount")
    {
        
                Visible=verSII;
                Editable=FALSE ;
}
} addafter("Document Date")
{
    field("QB_DonotsendtoSII>";rec."Do not send to SII")
    {
        
                Visible=verSII;
                Editable=FALSE ;
}
} addafter("Location Code")
{
    field("QB_PaymentBankNo";rec."QB Payment Bank No.")
    {
        
                Editable=false ;
}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payment Bank No."))
    {
        
                CaptionML=ENU='Bank Name',ESP='Nombre del banco';
                Enabled=false ;
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
}


modify("SII Information")
{
Visible=versii;


}


modify("OperationDescription")
{
Visible=versii;


}


modify("Special Scheme Code")
{
Visible=versii;


}


modify("Cr. Memo Type")
{
Visible=versii;


}


modify("Correction Type")
{
Visible=versii;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 OfficeMgt : Codeunit 1630;
                 SIIManagement : Codeunit 10756;
               BEGIN
                 rec.SetSecurityFilterOnRespCenter;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 ActivateFields;

                 //JAV 04/07/19: - Control del SII de Mirosoft, se incluye la fecha de operaci¢n
                 verSII :=  FunctionQB.AccessToSII;

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Purch. Cr. Memo Hdr.");
                 //Q7357 +

                 vQuoSII := FunctionQB.AccessToQuoSII;

                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
               END;
trigger OnAfterGetCurrRecord()    VAR
                           IncomingDocument : Record 130;
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists(rec."No.",rec."Posting Date");
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                           //+Q8636
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //-Q8636
                         END;


//trigger

var
      PurchCrMemoHeader : Record 124;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      HasIncomingDocument : Boolean;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      PurchCorrectiveCrMemoExists : Boolean;
      IsBuyFromCountyVisible : Boolean;
      IsPayToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      OperationDescription : Text[500];
      "--------------------- QB" : Integer;
      vQuoSII : Boolean;
      SIISetup : Record 10751;
      verSII : Boolean ;
      seeDragDrop : Boolean;
      FunctionQB : Codeunit 7207272;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     IsBuyFromCountyVisible := FormatAddress.UseCounty(rec."Buy-from Country/Region Code");
     IsPayToCountyVisible := FormatAddress.UseCounty(rec."Pay-to Country/Region Code");
     IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
   end;

//procedure
}


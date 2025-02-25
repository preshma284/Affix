pageextension 50130 MyExtension138 extends 138//122
{
layout
{
addafter("Buy-from Vendor Name")
{
    field("VAT Registration No.";rec."VAT Registration No.")
    {
        
}
} addafter("Corrective")
{
group("QB")
{
        
                CaptionML=ENU='Quobuilding',ESP='Quobuilding';
    field("QB_TotalDdocumentAmount";rec."Total document amount")
    {
        
                Visible=verSII;
                Editable=FALSE ;
}
    field("QB_DoNotSsendToSII";rec."Do not send to SII")
    {
        
                Visible=versii;
                Editable=FALSE ;
}
    field("QB_OperationDateSII";rec."Operation date SII")
    {
        
                Visible=verSII;
                Editable=FALSE ;
}
    field("QB_CodWithholdingByGE";rec."QW Cod. Withholding by GE")
    {
        
                Editable=FALSE ;
}
    field("QB_CodWithholdingByPIT";rec."QW Cod. Withholding by PIT")
    {
        
                Editable=FALSE ;
}
    field("QB_OrderTo";rec."Order To")
    {
        
                Editable=FALSE ;
}
    field("QB_Job No";rec."Job No.")
    {
        
                Editable=FALSE ;
}
    field("QB_OnHold";rec."On Hold")
    {
        
}
}
} addafter("Expected Receipt Date")
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


modify("Invoice Type")
{
Visible=versii;


}


modify("ID Type")
{
Visible=versii;


}


modify("Succeeded Company Name")
{
Visible=versii;


}


modify("Succeeded VAT Registration No.")
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

                 //JAV 04/07/19: - Control del SII de Microsoft, se incluye la fecha de operaci¢n, se ver  si no tiene QuoSII activado
                 verSII := FunctionQB.AccessToSII;

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Purch. Inv. Header");
                 //Q7357 +

                 vQuoSII := FunctionQB.AccessToQuoSII;

                 //Obralia
                 vObralia := (FunctionQB.AccessToObralia);

                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
               END;
trigger OnAfterGetRecord()    BEGIN
                       IF NOT ObraliaLogEntry.GET(rec."Obralia Entry") THEN
                         ObraliaLogEntry.INIT
                       ELSE
                         ObraliaStyle := ObraliaLogEntry.GetResponseStyle;
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
      PurchInvHeader : Record 122;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      FormatAddress : Codeunit 365;
      HasIncomingDocument : Boolean;
      IsOfficeAddin : Boolean;
      IsFoundationEnabled : Boolean;
      IsBuyFromCountyVisible : Boolean;
      IsPayToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      OperationDescription : Text[500];
      "--------------------- QB" : Integer;
      vQuoSII : Boolean;
      verSII : Boolean ;
      seeDragDrop : Boolean;
      FunctionQB : Codeunit 7207272;
      vObralia : Boolean;
      Obralia : Codeunit 7206901;
      ObraliaLogEntry : Record 7206904;
      ObraliaStyle : Text;
      Job : Record 167;
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


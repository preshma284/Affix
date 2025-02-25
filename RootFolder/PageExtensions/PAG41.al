pageextension 50192 MyExtension41 extends 41//36
{
layout
{
addafter("Payment Method Code")
{
    field("QB Payment Bank No.";rec."QB Payment Bank No.")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      SalesHeaderArchive : Record 5107;
      CopySalesDoc : Report 292;
      DocPrint : Codeunit 229;
      UserMgt : Codeunit 5700;
      ArchiveManagement : Codeunit 5063;
      SalesCalcDiscByType : Codeunit 56;
      CustomerMgt : Codeunit 1302;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      EnableBillToCustomerNo : Boolean ;
      EnableSellToCustomerTemplateCode : Boolean;
      HasIncomingDocument : Boolean;
      DocNoVisible : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      IsOfficeAddin : Boolean;
      CanCancelApprovalForRecord : Boolean;
      PaymentServiceVisible : Boolean;
      PaymentServiceEnabled : Boolean;
      IsCustomerOrContactNotEmpty : Boolean;
      WorkDescription : Text;
      ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
      BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";
      EmptyShipToCodeErr : TextConst ENU='The Code field can only be empty if you select Custom Address in the Ship-to field.',ESP='El campo C¢digo solo puede estar vac¡o si selecciona Direcci¢n personalizada en el campo Direcci¢n de env¡o.';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      IsSaaS : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;

    
    

//procedure
//Local procedure ActivateFields();
//    begin
//      EnableBillToCustomerNo := rec."Bill-to Customer Template Code" = '';
//      EnableSellToCustomerTemplateCode := rec."Sell-to Customer No." = '';
//      IsBillToCountyVisible := FormatAddress.UseCounty(rec."Bill-to Country/Region Code");
//      IsSellToCountyVisible := FormatAddress.UseCounty(rec."Sell-to Country/Region Code");
//      IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
//    end;
//Local procedure ApproveCalcInvDisc();
//    begin
//      CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
//    end;
//Local procedure SaveInvoiceDiscountAmount();
//    var
//      DocumentTotals : Codeunit 57;
//    begin
//      CurrPage.SAVERECORD;
//      DocumentTotals.SalesRedistributeInvoiceDiscountAmountsOnDocument(Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure ClearSellToFilter();
//    begin
//      if ( Rec.GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No."  )then
//        if ( "Sell-to Customer No." <> xRec."Sell-to Customer No."  )then
//          Rec.SETRANGE("Sell-to Customer No.");
//      if ( Rec.GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No."  )then
//        if ( "Sell-to Contact No." <> xRec."Sell-to Contact No."  )then
//          Rec.SETRANGE("Sell-to Contact No.");
//    end;
//Local procedure SetDocNoVisible();
//    var
//      DocumentNoVisibility : Codeunit 1400;
//      DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Reminder","FinChMemo";
//    begin
//      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Quote,rec."No.");
//    end;
//Local procedure SetControlAppearance();
//    var
//      ApprovalsMgmt : Codeunit 1535;
//      WorkflowWebhookMgt : Codeunit 1543;
//    begin
//      HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
//
//      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
//      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
//      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
//      IsCustomerOrContactNotEmpty := (rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> '');
//
//      WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
//    end;
//Local procedure CheckSalesCheckAllLinesHaveQuantityAssigned();
//    var
//      ApplicationAreaMgmtFacade : Codeunit 9179;
//      LinesInstructionMgt : Codeunit 1320;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
//    end;
//Local procedure UpdatePaymentService();
//    var
//      PaymentServiceSetup : Record 1060;
//    begin
//      PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
//    end;
//Local procedure UpdateShipToBillToGroupVisibility();
//    begin
//      CustomerMgt.CalculateShipToBillToOptions(ShipToOptions,BillToOptions,Rec);
//    end;
//
//    [Integration]
//Local procedure OnBeforeStatisticsAction(var SalesHeader : Record 36;var Handled : Boolean);
//    begin
//    end;

//procedure
}


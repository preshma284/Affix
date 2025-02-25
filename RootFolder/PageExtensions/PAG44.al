pageextension 50196 MyExtension44 extends 44//36
{
layout
{
addafter("Sell-to Customer Name")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
                Importance=Additional ;
}
    field("QB Job No.";rec."QB Job No.")
    {
        
                Visible=seeJob;
                
                          ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                             CurrPage.UPDATE;
                           END;

trigger OnLookup(var Text: Text): Boolean    VAR
                           JobNo : Code[20];
                         BEGIN
                           //JAV 25/07/19: - Al sacar la lista de proyectos, filtrar por los que se pueden ver por el usuario
                           JobNo := Rec."QB Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funci¢n
                           IF FunctionQB.LookupUserJobs(JobNo) THEN BEGIN
                             Rec.VALIDATE("QB Job No.", JobNo);
                             CurrPage.UPDATE(TRUE);
                           END;
                         END;


}
    field("QB Budget item";rec."QB Budget item")
    {
        
                Visible=seeQPR;
                Enabled=edQPR ;
}
    field("QB Job Sale Doc. Type";rec."QB Job Sale Doc. Type")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
}
    field("Posting No. Series";rec."Posting No. Series")
    {
        
}
} addafter("Posting Description")
{
    field("Posting No.";rec."Posting No.")
    {
        
                ToolTipML=ENU='Specifies the number of the posted invoice that will be created if you post the sales invoice.',ESP='Especifica el n£mero de la factura registrada que se crear  si se registra la factura de venta.';
                ApplicationArea=Basic,Suite;
}
} addafter("Your Reference")
{
group("QB_GroupDate")
{
        
                CaptionML=ESP='Fechas';
}
} addafter("Posting Date")
{
    field("QB_SIIYearMonth";rec."QB SII Year-Month")
    {
        
                Visible=verSII ;
}
    field("QB Do not send to SII";rec."QB Do not send to SII")
    {
        
                Visible=verSII ;
}
} addafter("Shipment Date")
{
    field("QB Payment Bank No.";rec."QB Payment Bank No.")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payment Bank No."))
    {
        
                CaptionML=ENU='Bank Name',ESP='Nombre del banco';
                Enabled=false ;
}
} addafter("Payment Method Code")
{
    field("QW Cod. Withholding by GE";rec."QW Cod. Withholding by GE")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                           END;


}
    field("QW Witholding Due Date";rec."QW Witholding Due Date")
    {
        
                Editable=QB_edGEDuedate ;
}
    field("QW Cod. Withholding by PIT";rec."QW Cod. Withholding by PIT")
    {
        
}
} addafter("Foreign Trade")
{
group("Control7174339")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII Exercise-Period";rec."QuoSII Exercise-Period")
    {
        
}
    field("QuosII_DoNotSendToSI";rec."QB Do not send to SII")
    {
        
                ToolTipML=ESP='Si se marca este documento no subir  al SII, pero quedar  en la lista de documentos del SII como referencia';
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
}
    field("QuoSII Sales Invoice Type";rec."QuoSII Sales Invoice Type")
    {
        
                Enabled=SalesInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Sales Cor. Invoice Type";rec."QuoSII Sales Cor. Invoice Type")
    {
        
                Enabled=SalesCorrectedInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Sales Cr.Memo Type";rec."QuoSII Sales Cr.Memo Type")
    {
        
                Enabled=SalesCrMemoTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Sales Special Regimen";rec."QuoSII Sales Special Regimen")
    {
        
}
    field("QuoSII Sales Special Regimen 1";rec."QuoSII Sales Special Regimen 1")
    {
        
}
    field("QuoSII Sales Special Regimen 2";rec."QuoSII Sales Special Regimen 2")
    {
        
}
    field("QuoSII Sales UE Inv Type";rec."QuoSII Sales UE Inv Type")
    {
        
                Enabled=SalesUEInvTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Enabled=BienesDescriptionB ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Enabled=OperatorAddressB ;
}
    field("QuoSII First Ticket No.";rec."QuoSII First Ticket No.")
    {
        
                Enabled=FirstTicketNoB ;
}
    field("QuoSII Last Ticket No.";rec."QuoSII Last Ticket No.")
    {
        
                Enabled=LastTicketNoB ;
}
    field("QuoSII Third Party";rec."QuoSII Third Party")
    {
        
}
    field("QB Operation date SII";rec."QB Operation date SII")
    {
        
}
}
} addfirst("factboxes")
{}


modify("Sell-to Customer Name")
{

trigger OnAfterValidate()    BEGIN
// #1..8
END;

}


//modify("Posting Date")
//{
//
//
//}
//

//modify("Document Date")
//{
//
//
//}
//

//modify("Due Date")
//{
//
//
//}
//

modify("SII Information")
{
Visible=verSII;


}

}

actions
{
addafter("Preview Posting")
{
group("Action1100286016")
{
        CaptionML=ENU='P&osting',ESP='Proforma';
                      Image=Post ;
    action("Inesco_ProformaCrMemo")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Pro Forma Invoice',ESP='Abono proforma INESCO';
                      ToolTipML=ENU='View or print the pro forma sales invoice.',ESP='Permite imprimir el documento como un Abono Proforma';
                      Visible=seeInesco;
                      Image=ViewPostedOrder;
                      // PromotedCategory=Category5;
                      
                                
    trigger OnAction()    VAR
                                //  DraftSalesInvoice : Report 50048;
                                 SalesHeader : Record 36;
                               BEGIN

                                   SalesHeader.RESET;
                                   SalesHeader.SETRANGE("Document Type",rec."Document Type");
                                   SalesHeader.SETRANGE("No.",rec."No.");
                                   IF SalesHeader.FINDFIRST THEN;
                                  //  CLEAR(DraftSalesInvoice);
                                  //  DraftSalesInvoice.SETTABLEVIEW(SalesHeader);
                                  //  DraftSalesInvoice.RUN;
                               END;


}
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 SIIManagement : Codeunit 10756;
                 PermissionManager : Codeunit 9002;
                 PermissionManager1: Codeunit 51256;

               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   Rec.FILTERGROUP(0);
                 END;

                 ActivateFields;

                 IsSaaS := PermissionManager1.SoftwareAsAService;
                 SetDocNoVisible;
                 SetControlAppearance;
                 IF (rec."No." <> '') AND (rec."Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 //QuoSII_1.4.98.999.begin
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //SII estandar
                 verSII := FunctionQB.AccessToSII();

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);

                 //JAV 04/07/22: - QB 1.10.59 Activar impresi¢n de proformas para Inesco
                 seeInesco := FunctionQB.IsClient('INE');
               END;
trigger OnAfterGetRecord()    BEGIN
                       SetControlAppearance;
                       WorkDescription := rec.GetWorkDescription;

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
                           SetControlAppearance;

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);
                           //JAV 27/10/21: - QB 1.09.25 Campos editables
                           QB_SetEditable;
                         END;


//trigger

var
      CopySalesDoc : Report 292;
      MoveNegSalesLines : Report 6699;
      ReportPrint : Codeunit 228;
      UserMgt : Codeunit 5700;
      SalesCalcDiscByType : Codeunit 56;
      LinesInstructionMgt : Codeunit 1320;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      WorkDescription : Text;
      JobQueueVisible : Boolean ;
      JobQueueUsed : Boolean ;
      HasIncomingDocument : Boolean;
      DocNoVisible : Boolean;
      ExternalDocNoMandatory : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      OpenPostedSalesCrMemoQst : TextConst ENU='The credit memo is posted as number %1 and moved to the Posted Sales Credit Memos window.\\Do you want to open the posted credit memo?',ESP='La nota de cr‚dito se registr¢ con el n£mero %1 y se movi¢ a la ventana de notas de cr‚dito de ventas registradas.\\¨Quiere abrir la nota de cr‚dito registrada?';
      CanCancelApprovalForRecord : Boolean;
      DocumentIsPosted : Boolean;
      IsCustomerOrContactNotEmpty : Boolean;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      OperationDescription : Text[500];
      IsSaaS : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      QB_edGEDueDate : Boolean;
      verSII : Boolean;
      seeJob : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      seeInesco : Boolean;
      "--------------------------------------- QuoSII" : Integer;
      SIIProcesing : Codeunit 7174332;
      vQuoSII : Boolean;
      SalesInvoiceTypeB : Boolean;
      SalesCorrectedInvoiceTypeB : Boolean;
      SalesCrMemoTypeB : Boolean;
      SalesUEInvTypeB : Boolean;
      BienesDescriptionB : Boolean;
      OperatorAddressB : Boolean;
      FirstTicketNoB : Boolean;
      LastTicketNoB : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     IsBillToCountyVisible := FormatAddress.UseCounty(rec."Bill-to Country/Region Code");
     IsSellToCountyVisible := FormatAddress.UseCounty(rec."Sell-to Country/Region Code");
   end;
//Local procedure Post(PostingCodeunitID : Integer);
//    var
//      SalesHeader : Record 36;
//      SalesCrMemoHeader : Record 114;
//      OfficeMgt : Codeunit 1630;
//      InstructionMgt : Codeunit 1330;
//      PreAssignedNo : Code[20];
//      IsScheduledPosting : Boolean;
//    begin
//      CheckSalesCheckAllLinesHaveQuantityAssigned;
//      PreAssignedNo := rec."No.";
//
//      rec.SendToPosting(PostingCodeunitID);
//
//      IsScheduledPosting := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";
//      DocumentIsPosted := (not SalesHeader.GET(rec."Document Type",rec."No.")) or IsScheduledPosting;
//      OnPostOnAfterSetDocumentIsPosted(SalesHeader,IsScheduledPosting,DocumentIsPosted);
//
//      if ( IsScheduledPosting  )then
//        CurrPage.CLOSE;
//      CurrPage.UPDATE(FALSE);
//
//      if ( PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)"  )then
//        exit;
//
//      if ( OfficeMgt.IsAvailable  )then begin
//        SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
//        if ( SalesCrMemoHeader.FINDFIRST  )then
//          PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
//      end ELSE
//        if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//          ShowPostedConfirmationMessage(PreAssignedNo);
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
//Local procedure SalespersonCodeOnAfterValidate();
//    begin
//      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure ShortcutDimension1CodeOnAfterV();
//    begin
//      CurrPage.UPDATE;
//    end;
//Local procedure ShortcutDimension2CodeOnAfterV();
//    begin
//      CurrPage.UPDATE;
//    end;
//Local procedure PricesIncludingVATOnAfterValid();
//    begin
//      CurrPage.UPDATE;
//    end;
Local procedure SetDocNoVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
     DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Reminder","FinChMemo";
   begin
     DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Credit Memo",rec."No.");
   end;
Local procedure SetExtDocNoMandatoryCondition();
   var
     SalesReceivablesSetup : Record 311;
   begin
     SalesReceivablesSetup.GET;
     ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
   end;
//
//    //[External]
//procedure ShowPreview();
//    var
//      SalesPostYesNo : Codeunit 81;
//    begin
//      SalesPostYesNo.Preview(Rec);
//    end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookMgt : Codeunit 1543;
   begin
     JobQueueVisible := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";
     HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
     SetExtDocNoMandatoryCondition;

     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
     IsCustomerOrContactNotEmpty := (rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> '');

     WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
   end;
//Local procedure CheckSalesCheckAllLinesHaveQuantityAssigned();
//    var
//      ApplicationAreaMgmtFacade : Codeunit 9179;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
//    end;
//Local procedure ShowPostedConfirmationMessage(PreAssignedNo : Code[20]);
//    var
//      SalesCrMemoHeader : Record 114;
//      InstructionMgt : Codeunit 1330;
//    begin
//      SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
//      if ( SalesCrMemoHeader.FINDFIRST  )then
//        if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesCrMemoQst,SalesCrMemoHeader."No."),
//             InstructionMgt.ShowPostedConfirmationMessageCode)
//        then
//          PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
//    end;
//
//    [Integration]
//Local procedure OnBeforeStatisticsAction(var SalesHeader : Record 36;var Handled : Boolean);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnPostOnAfterSetDocumentIsPosted(SalesHeader : Record 36;var IsScheduledPosting : Boolean;var DocumentIsPosted : Boolean);
//    begin
//    end;
LOCAL procedure "----------------------------------------------------------"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    var
      Job : Record 167;
    begin
      QB_edGEDueDate := (rec."QW Cod. Withholding by GE" <> '');

      //JAV 27/10/21: - QB 1.09.25 Campos de presupuestos editables y l¡neas
      edQPR := FunctionQB.Job_IsBudget(Rec."QB Job No.");
      CurrPage.SalesLines.PAGE.QB_SetTxtPiecework(Rec."QB Job No.");

      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      QuoSII_SetEditable;
    end;
LOCAL procedure QuoSII_SetEditable();
    begin
      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      if ( (vQuoSII)  )then
        SIIProcesing.PG_Ventas_SetFieldNotEditable(Rec,SalesInvoiceTypeB,SalesCorrectedInvoiceTypeB,SalesCrMemoTypeB,SalesUEInvTypeB,BienesDescriptionB,
                                                       OperatorAddressB,FirstTicketNoB,LastTicketNoB);
    end;

//procedure
}


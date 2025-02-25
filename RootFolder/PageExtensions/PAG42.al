pageextension 50193 MyExtension42 extends 42//36
{
layout
{
addafter("Sell-to Customer Name")
{
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
} addafter("Status")
{
//     field("Combine Shipments";rec."Combine Shipments")
//     {
        
// }
    field("Posting No. Series";rec."Posting No. Series")
    {
        
}
} addafter("EU 3-Party Trade")
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
} addafter("Cust. Bank Acc. Code")
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
} addafter("Bill-to Contact")
{
group("Control7174338")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII Exercise-Period";rec."QuoSII Exercise-Period")
    {
        
}
    field("QuoSII Operation Date";rec."QuoSII Operation Date")
    {
        
                ToolTipML=ESP='Si est  informada la feha de operaci¢n se usar  esta, si no lo est  y hay fecha fin del periodo se usar  esta, si no hay ninguna informada se usara la mayor de las fechas de env¡o de las lineas que en general coincide con la fecha de registro';
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
}
}


modify("SII Information")
{
Visible=verSII;


}


//modify("Succeeded Company Name")
//{
//
//
//}
//
}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 PaymentServiceSetup : Record 1060;
                 CRMIntegrationManagement : Codeunit 5330;
                 OfficeMgt : Codeunit 1630;
                 SIIManagement : Codeunit 10756;
                 PermissionManager : Codeunit 9002;
                 PermissionManager1 :Codeunit 51256;
               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   Rec.FILTERGROUP(0);
                 END;

                 ActivateFields;

                 Rec.SETRANGE("Date Filter",0D,WORKDATE - 1);
                 SetDocNoVisible;

                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 IsOfficeHost := OfficeMgt.IsAvailable;
                 IsSaas := PermissionManager1.SoftwareAsAService;

                 IF rec."Quote No." <> '' THEN
                   ShowQuoteNo := TRUE;
                 IF (rec."No." <> '') AND (rec."Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);
                 PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
                 //QuoSII
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //Acceso al SII estandar
                 verSII := FunctionQB.AccessToSII();

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);
               END;
trigger OnAfterGetRecord()    BEGIN
                       ShowQuoteNo := rec."Quote No." <> '';

                       SetControlVisibility;
                       UpdateShipToBillToGroupVisibility;
                       WorkDescription := rec.GetWorkDescription;

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           SalesHeader : Record 36;
                           CRMCouplingManagement : Codeunit 5331;
                           CustCheckCrLimit : Codeunit 312;
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           DynamicEditable := CurrPage.EDITABLE;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
                           CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

                           UpdatePaymentService;
                           IF CallNotificationCheck THEN BEGIN
                             SalesHeader := Rec;
                             SalesHeader.CALCFIELDS("Amount Including VAT");
                             CustCheckCrLimit.SalesHeaderCheck(SalesHeader);
                             rec.CheckItemAvailabilityInLines;
                             CallNotificationCheck := FALSE;
                           END;

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);
                           //JAV 27/10/21: - QB 1.09.25 Campos editables
                           QB_SetEditable;
                         END;


//trigger

var
      CopySalesDoc : Report 292;
      MoveNegSalesLines : Report 6699;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      ApprovalsMgmt : Codeunit 1535;
      ReportPrint : Codeunit 228;
      DocPrint : Codeunit 229;
      ArchiveManagement : Codeunit 5063;
      SalesCalcDiscountByType : Codeunit 56;
      UserMgt : Codeunit 5700;
      CustomerMgt : Codeunit 1302;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      Usage: Option "Order Confirmation","Work Order","Pick Instruction";
      NavigateAfterPost: Option "Posted Document","New Document","Nowhere";
      JobQueueVisible : Boolean ;
      Text001 : TextConst ENU='Do you want to change %1 in all related records in the warehouse?',ESP='¨Desea cambiar %1 en todos los registros relacionados del almac‚n?';
      Text002 : TextConst ENU='The update has been interrupted to respect the warning.',ESP='Se ha interrumpido la actualizaci¢n para respetar la advertencia.';
      DynamicEditable : Boolean;
      HasIncomingDocument : Boolean;
      DocNoVisible : Boolean;
      ExternalDocNoMandatory : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      ShowWorkflowStatus : Boolean;
      IsOfficeHost : Boolean;
      CanCancelApprovalForRecord : Boolean;
      JobQueuesUsed : Boolean;
      ShowQuoteNo : Boolean;
      DocumentIsPosted : Boolean;
      OpenPostedSalesOrderQst : TextConst ENU='The order is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?',ESP='El pedido se registr¢ con el n£mero %1 y se movi¢ a la ventana de facturas de venta registradas.\\¨Quiere abrir la factura registrada?';
      PaymentServiceVisible : Boolean;
      PaymentServiceEnabled : Boolean;
      CallNotificationCheck : Boolean;
      ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
      BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";
      EmptyShipToCodeErr : TextConst ENU='The Code field can only be empty if you select Custom Address in the Ship-to field.',ESP='El campo C¢digo solo puede estar vac¡o si selecciona Direcci¢n personalizada en el campo Direcci¢n de env¡o.';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      IsCustomerOrContactNotEmpty : Boolean;
      WorkDescription : Text;
      OperationDescription : Text[500];
      IsSaas : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      QB_edGEDueDate : Boolean;
      verSII : Boolean;
      seeJob : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
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
     IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
   end;
//Local procedure Post(PostingCodeunitID : Integer;Navigate : Option);
//    var
//      SalesHeader : Record 36;
//      LinesInstructionMgt : Codeunit 1320;
//      InstructionMgt : Codeunit 1330;
//      IsScheduledPosting : Boolean;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
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
//      CASE Navigate OF
//        NavigateAfterPost::"Posted Document":
//          if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//            ShowPostedConfirmationMessage;
//        NavigateAfterPost::"New Document":
//          if ( DocumentIsPosted  )then begin
//            SalesHeader.INIT;
//            SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Order);
//            SalesHeader.INSERT(TRUE);
//            PAGE.RUN(PAGE::"Sales Order",SalesHeader);
//          end;
//      end;
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
//Local procedure Prepayment37OnAfterValidate();
//    begin
//      CurrPage.UPDATE;
//    end;
Local procedure SetDocNoVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
     DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Reminder","FinChMemo";
   begin
     DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order,rec."No.");
   end;
Local procedure SetExtDocNoMandatoryCondition();
   var
     SalesReceivablesSetup : Record 311;
   begin
     SalesReceivablesSetup.GET;
     ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
   end;
//Local procedure ShowPreview();
//    var
//      SalesPostYesNo : Codeunit 81;
//    begin
//      SalesPostYesNo.Preview(Rec);
//    end;
Local procedure SetControlVisibility();
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

     WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
     IsCustomerOrContactNotEmpty := (rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> '');
   end;
//Local procedure ShowPostedConfirmationMessage();
//    var
//      OrderSalesHeader : Record 36;
//      SalesInvoiceHeader : Record 112;
//      InstructionMgt : Codeunit 1330;
//    begin
//      if ( not OrderSalesHeader.GET(rec."Document Type",rec."No.")  )then begin
//        SalesInvoiceHeader.SETRANGE("No.",rec."Last Posting No.");
//        if ( SalesInvoiceHeader.FINDFIRST  )then
//          if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesOrderQst,SalesInvoiceHeader."No."),
//               InstructionMgt.ShowPostedConfirmationMessageCode)
//          then
//            PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
//      end;
//    end;
//Local procedure UpdatePaymentService();
//    var
//      PaymentServiceSetup : Record 1060;
//    begin
//      PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
//      PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
//    end;
//
//    //[External]
//procedure UpdateShipToBillToGroupVisibility();
//    begin
//      CustomerMgt.CalculateShipToBillToOptions(ShipToOptions,BillToOptions,Rec);
//    end;
//
//    [Integration]
//Local procedure OnBeforeStatisticsAction(var SalesHeader : Record 36;var Handled : Boolean);
//    begin
//    end;
//
//    //[External]
//procedure CheckNotificationsOnce();
//    begin
//      CallNotificationCheck := TRUE;
//    end;
//Local procedure ShowReleaseNotification() : Boolean;
//    var
//      LocationsQuery : Query 5001;
//    begin
//      if ( rec."Status" <> rec."Status"::Released  )then begin
//        LocationsQuery.SETRANGE(Document_No,rec."No.");
//        LocationsQuery.SETRANGE(Require_Pick,TRUE);
//        LocationsQuery.OPEN;
//        if ( LocationsQuery.READ  )then
//          exit(TRUE);
//        LocationsQuery.SETRANGE(Require_Pick);
//        LocationsQuery.SETRANGE(Require_Shipment,TRUE);
//        LocationsQuery.OPEN;
//        exit(LocationsQuery.READ);
//      end;
//      exit(FALSE);
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


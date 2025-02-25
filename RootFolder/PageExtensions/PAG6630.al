pageextension 50244 MyExtension6630 extends 6630//36
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
} addafter("Foreign Trade")
{
group("Control7174340")
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
                 SIIManagement : Codeunit 10756;
               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   Rec.FILTERGROUP(0);
                 END;

                 ActivateFields;

                 SetDocNoVisible;
                 IF (rec."No." <> '') AND (rec."Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 //QB
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);
               END;
trigger OnAfterGetRecord()    BEGIN
                       SetControlAppearance;

                       //QB
                       QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                           //QB
                           QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                           //JAV 27/10/21: - QB 1.09.25 Campos editables
                           QB_SetEditable;
                         END;


//trigger

var
      CopySalesDoc : Report 292;
      MoveNegSalesLines : Report 6699;
      CreateRetRelDocs : Report 6697;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      ReportPrint : Codeunit 228;
      DocPrint : Codeunit 229;
      UserMgt : Codeunit 5700;
      ArchiveManagement : Codeunit 5063;
      SalesCalcDiscByType : Codeunit 56;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      JobQueueVisible : Boolean ;
      JobQueueUsed : Boolean ;
      DocNoVisible : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      CanCancelApprovalForRecord : Boolean;
      DocumentIsPosted : Boolean;
      OpenPostedSalesReturnOrderQst : TextConst ENU='The return order is posted as number %1 and moved to the Posted Sales Credit Memos window.\\Do you want to open the posted credit memo?',ESP='El pedido de devoluci¢n se registr¢ con el n£mero %1 y se movi¢ a la ventana de notas de cr‚dito de ventas registradas.\\¨Quiere abrir la nota de cr‚dito registrada?';
      OperationDescription : Text[500];
      IsCustomerOrContactNotEmpty : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      "--------------------- QB" : Integer;
      seeJob : Boolean;
      seeQB : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      FunctionQB : Codeunit 7207272;
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
//Local procedure Post(PostingCodeunitID : Integer);
//    var
//      SalesHeader : Record 36;
//      InstructionMgt : Codeunit 1330;
//    begin
//      rec.SendToPosting(PostingCodeunitID);
//
//      DocumentIsPosted := not SalesHeader.GET(rec."Document Type",rec."No.");
//
//      if ( rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting"  )then
//        CurrPage.CLOSE;
//      CurrPage.UPDATE(FALSE);
//
//      if ( PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)"  )then
//        exit;
//
//      if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//        ShowPostedConfirmationMessage;
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
//      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure ShortcutDimension2CodeOnAfterV();
//    begin
//      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
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
     DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Return Order",rec."No.");
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
   begin
     JobQueueVisible := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";

     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
     IsCustomerOrContactNotEmpty := (rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> '');
   end;
//Local procedure ShowPostedConfirmationMessage();
//    var
//      ReturnOrderSalesHeader : Record 36;
//      SalesCrMemoHeader : Record 114;
//      InstructionMgt : Codeunit 1330;
//    begin
//      if ( not ReturnOrderSalesHeader.GET(rec."Document Type",rec."No.")  )then begin
//        SalesCrMemoHeader.SETRANGE("No.",rec."Last Posting No.");
//        if ( SalesCrMemoHeader.FINDFIRST  )then
//          if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesReturnOrderQst,SalesCrMemoHeader."No."),
//               InstructionMgt.ShowPostedConfirmationMessageCode)
//          then
//            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
//      end;
//    end;
//
//    [Integration]
//Local procedure OnBeforeStatisticsAction(var SalesHeader : Record 36;var Handled : Boolean);
//    begin
//    end;
LOCAL procedure "----------------------------------------------------------"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    var
      Job : Record 167;
    begin
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


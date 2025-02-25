pageextension 50246 MyExtension6640 extends 6640//38
{
layout
{
addafter("Buy-from Vendor Name")
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
} addafter("Payment Discount %")
{
    field("QW Cod. Withholding by PIT";rec."QW Cod. Withholding by PIT")
    {
        
}
    field("QW Cod. Withholding by GE";rec."QW Cod. Withholding by GE")
    {
        
}
} addafter("Foreign Trade")
{
group("Control80009")
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
    field("QuoSII Purch. Invoice Type";rec."QuoSII Purch. Invoice Type")
    {
        
                Enabled=PurchInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Purch. Cor. Inv. Type";rec."QuoSII Purch. Cor. Inv. Type")
    {
        
                Enabled=PurchCorrectedInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Purch. Cr.Memo Type";rec."QuoSII Purch. Cr.Memo Type")
    {
        
                Enabled=PurchCrMemoTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Purch Special Regimen";rec."QuoSII Purch Special Regimen")
    {
        
}
    field("QuoSII Purch Special Regimen 1";rec."QuoSII Purch Special Regimen 1")
    {
        
}
    field("QuoSII Purch Special Regimen 2";rec."QuoSII Purch Special Regimen 2")
    {
        
}
    field("QuoSII Purch. UE Inv Type";rec."QuoSII Purch. UE Inv Type")
    {
        
                Enabled=PurchUEInvTypeB;
                
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
                 SetDocNoVisible;

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   Rec.FILTERGROUP(0);
                 END;
                 IF (rec."No." <> '') AND (rec."Buy-from Vendor No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 ActivateFields;

                 //QB
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);
               END;
trigger OnAfterGetRecord()    BEGIN
                       CalculateCurrentShippingOption;

                       //QB
                       QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           SetControlAppearance;
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                           //QB
                           QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                           //JAV 27/10/21: - QB 1.09.25 Campos editables
                           QB_SetEditable;
                         END;


//trigger

var
      CopyPurchDoc : Report 492;
      MoveNegPurchLines : Report 6698;
      DocPrint : Codeunit 229;
      ReportPrint : Codeunit 228;
      UserMgt : Codeunit 5700;
      ArchiveManagement : Codeunit 5063;
      PurchCalcDiscByType : Codeunit 66;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      ShipToOptions: Option "Default (Vendor Address)","Alternate Vendor Address","Custom Address";
      JobQueueVisible : Boolean ;
      JobQueueUsed : Boolean ;
      DocNoVisible : Boolean;
      OpenApprovalEntriesExist : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      ShowWorkflowStatus : Boolean;
      CanCancelApprovalForRecord : Boolean;
      DocumentIsPosted : Boolean;
      OpenPostedPurchaseReturnOrderQst : TextConst ENU='The return order is posted as number %1 and moved to the Posted Purchase Credit Memos window.\\Do you want to open the posted credit memo?',ESP='El pedido de devoluci¢n se registr¢ con el n£mero %1 y se movi¢ a la ventana de notas de cr‚dito de compras registradas.\\¨Quiere abrir la nota de cr‚dito registrada?';
      IsBuyFromCountyVisible : Boolean;
      IsPayToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      OperationDescription : Text[500];
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      QBPagePublisher : Codeunit 7207348;
      seeJob : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      "---------------------------- QuoSII" : Integer;
      SIIProcesing : Codeunit 7174332;
      vQuoSII : Boolean;
      PurchInvoiceTypeB : Boolean;
      PurchCorrectedInvoiceTypeB : Boolean;
      PurchCrMemoTypeB : Boolean;
      PurchUEInvTypeB : Boolean;
      BienesDescriptionB : Boolean;
      OperatorAddressB : Boolean;
      FirstTicketNoB : Boolean;
      LastTicketNoB : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     IsBuyFromCountyVisible := FormatAddress.UseCounty(rec."Buy-from Country/Region Code");
     IsPayToCountyVisible := FormatAddress.UseCounty(rec."Pay-to Country/Region Code");
     IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
   end;
//Local procedure Post(PostingCodeunitID : Integer);
//    var
//      PurchaseHeader : Record 38;
//      InstructionMgt : Codeunit 1330;
//    begin
//      rec.SendToPosting(PostingCodeunitID);
//
//      DocumentIsPosted := not PurchaseHeader.GET(rec."Document Type",rec."No.");
//
//      if ( rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting"  )then
//        CurrPage.CLOSE;
//      CurrPage.UPDATE(FALSE);
//
//      if ( PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)"  )then
//        exit;
//
//      if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//        ShowPostedConfirmationMessage;
//    end;
//Local procedure ApproveCalcInvDisc();
//    begin
//      CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
//    end;
//Local procedure SaveInvoiceDiscountAmount();
//    var
//      DocumentTotals : Codeunit 57;
//    begin
//      CurrPage.SAVERECORD;
//      DocumentTotals.PurchaseRedistributeInvoiceDiscountAmountsOnDocument(Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure PurchaserCodeOnAfterValidate();
//    begin
//      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure ShortcutDimension1CodeOnAfterV();
//    begin
//      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure ShortcutDimension2CodeOnAfterV();
//    begin
//      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
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
     DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Return Order",rec."No.");
   end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
   begin
     JobQueueVisible := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";

     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
   end;
//Local procedure ShowPostedConfirmationMessage();
//    var
//      ReturnOrderPurchaseHeader : Record 38;
//      PurchCrMemoHdr : Record 124;
//      InstructionMgt : Codeunit 1330;
//    begin
//      if ( not ReturnOrderPurchaseHeader.GET(rec."Document Type",rec."No.")  )then begin
//        PurchCrMemoHdr.SETRANGE("No.",rec."Last Posting No.");
//        if ( PurchCrMemoHdr.FINDFIRST  )then
//          if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedPurchaseReturnOrderQst,PurchCrMemoHdr."No."),
//               InstructionMgt.ShowPostedConfirmationMessageCode)
//          then
//            PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
//      end;
//    end;
//Local procedure ValidateShippingOption();
//    begin
//      CASE ShipToOptions OF
//        ShipToOptions::"Default (Vendor Address)":
//          begin
//            Rec.VALIDATE("Order Address Code",'');
//            Rec.VALIDATE("Buy-from Vendor No.");
//          end;
//        ShipToOptions::"Alternate Vendor Address":
//          Rec.VALIDATE("Order Address Code",'');
//      end;
//    end;
Local procedure CalculateCurrentShippingOption();
   begin
     CASE TRUE OF
       rec."Order Address Code" <> '':
         ShipToOptions := ShipToOptions::"Alternate Vendor Address";
       rec.BuyFromAddressEqualsShipToAddress:
         ShipToOptions := ShipToOptions::"Default (Vendor Address)";
       ELSE
         ShipToOptions := ShipToOptions::"Custom Address";
     end;
   end;
LOCAL procedure "----------------------------------------------------------"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    var
      Job : Record 167;
    begin
      //JAV 27/10/21: - QB 1.09.25 Campos de presupuestos editables y l¡neas
      edQPR := FunctionQB.Job_IsBudget(Rec."QB Job No.");
      CurrPage.PurchLines.PAGE.QB_SetTxtPiecework(Rec."QB Job No.");

      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      QuoSII_SetEditable;
    end;
LOCAL procedure QuoSII_SetEditable();
    begin
      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      if ( (vQuoSII)  )then
        SIIProcesing.PG_Compras_SetFieldNotEditable(Rec,PurchInvoiceTypeB,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,
                                                        OperatorAddressB,FirstTicketNoB,LastTicketNoB);
    end;

//procedure
}


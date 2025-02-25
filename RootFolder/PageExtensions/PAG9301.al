pageextension 50289 MyExtension9301 extends 9301//36
{
layout
{
addafter("External Document No.")
{
    field("INESCO_PostingNo";rec."Posting No.")
    {
        
                ApplicationArea=Basic,Suite;
                Visible=seeInesco ;
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

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 SalesSetup : Record 311;
               BEGIN
                 rec.SetSecurityFilterOnRespCenter;
                 JobQueueActive := SalesSetup.JobQueueActive;

                 rec.CopySellToCustomerFilter;

                 //JAV 04/03/22: - QB 1.10.23 Manejo de las customizacines de los clientes
                 seeInesco := (FunctionQB.IsClient('INE'));

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Sales Header");
                 //Q7357 +
               END;
trigger OnAfterGetRecord()    BEGIN
                       //+Q8636
                       IF seeDragDrop THEN BEGIN
                         CurrPage.DropArea.PAGE.SetFilter(Rec);
                         CurrPage.FilesSP.PAGE.SetFilter(Rec);
                       END;
                       //-Q8636
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //CPA 25-05-22 - Q17160.Begin
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //CPA 25-05-22 - Q17160.End
                         END;


//trigger

var
      ApplicationAreaMgmtFacade : Codeunit 9179;
      ReportPrint : Codeunit 228;
      LinesInstructionMgt : Codeunit 1320;
      JobQueueActive : Boolean ;
      OpenApprovalEntriesExist : Boolean;
      OpenPostedSalesInvQst : TextConst ENU='The invoice is posted as number %1 and moved to the Posted Sales Invoice window.\\Do you want to open the posted invoice?',ESP='La factura se registr¢ con el n£mero %1 y se movi¢ a la ventana de facturas de venta registradas.\\¨Quiere abrir la factura registrada?';
      CanCancelApprovalForRecord : Boolean;
      ReadyToPostQst : TextConst ENU='%1 out of %2 selected invoices are ready for post. \Do you want to continue and post them?',ESP='%1 de las %2 facturas seleccionadas est n listas para el registro. \¨Desea continuar y registrarlas?';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      "----------------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      seeInesco : Boolean;
      seeDragDrop : Boolean;

    

//procedure
//procedure ShowPreview();
//    var
//      SalesPostYesNo : Codeunit 81;
//    begin
//      SalesPostYesNo.Preview(Rec);
//    end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookManagement : Codeunit 1543;
   begin
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

     WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
   end;
//Local procedure Post(PostingCodeunitID : Integer);
//    var
//      PreAssignedNo : Code[20];
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then begin
//        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
//        PreAssignedNo := rec."No.";
//      end;
//
//      rec.SendToPosting(PostingCodeunitID);
//
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        ShowPostedConfirmationMessage(PreAssignedNo);
//    end;
//Local procedure ShowPostedConfirmationMessage(PreAssignedNo : Code[20]);
//    var
//      SalesInvoiceHeader : Record 112;
//      InstructionMgt : Codeunit 1330;
//    begin
//      SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
//      SalesInvoiceHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
//      if ( SalesInvoiceHeader.FINDFIRST  )then
//        if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesInvQst,SalesInvoiceHeader."No."),
//             InstructionMgt.ShowPostedConfirmationMessageCode)
//        then
//          PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
//    end;

//procedure
}


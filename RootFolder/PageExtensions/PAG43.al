pageextension 50195 MyExtension43 extends 43//36
{
layout
{
addafter("General")
{
group("Service Order")
{
        
                CaptionML=ENU='Service Order',ESP='Pedido de Servicio';
                Visible=seeService;
    field("Expenses/Investment";SalesHeaderExt."Expenses/Investment")
    {
        
                CaptionML=ENU='Expenses/Investment',ESP='Gastos/Inversi¢n';
                Editable=false;
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Grouping Criteria";SalesHeaderExt."Grouping Criteria")
    {
        
                CaptionML=ENU='Grouping Criteria',ESP='Criterios de agrupaci¢n';
                Editable=false;
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
group("PriceReview")
{
        
                CaptionML=ENU='rec."Price review"',ESP='Revisi¢n precios';
    field("Price review";SalesHeaderExt."Price review")
    {
        
                CaptionML=ENU='rec."Price review"',ESP='Revision precios';
                
                            ;trigger OnValidate()    BEGIN
                             //Q12733
                             SalesHeaderExt.VALIDATE("Price review");
                             //--> Q12733

                             SalesHeaderExt.Save();
                           END;


}
    field("Price review code";SalesHeaderExt."Price review code")
    {
        
                CaptionML=ENU='rec."Price review code"',ESP='Cod. Revision precios';
                Editable=false;
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Price review percentage";SalesHeaderExt."Price review percentage")
    {
        
                CaptionML=ENU='rec."Price review percentage"',ESP='Porcentaje revision precios';
                Editable=FALSE;
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("IPC/Rev aplicado";SalesHeaderExt."IPC/Rev aplicado")
    {
        
                CaptionML=ENU='rec."IPC/Rev aplicado"',ESP='rec."IPC/Rev aplicado"';
                Editable=FALSE;
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
}
group("Control1100286031")
{
        
                CaptionML=ENU='Failiure Information',ESP='Informaci¢n aver¡as';
    field("Contract No.";SalesHeaderExt."Contract No.")
    {
        
                CaptionML=ENU='Contract No.',ESP='N§ contrato';
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Failiure Benefit Centre";SalesHeaderExt."Failiure Benefit Centre")
    {
        
                CaptionML=ENU='Benefit Centre',ESP='Centro beneficio';
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Failiure Budget Pos.";SalesHeaderExt."Failiure Budget Pos.")
    {
        
                CaptionML=ENU='Budget Pos.',ESP='Pos. presup.';
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Failiure Order";SalesHeaderExt."Failiure Order")
    {
        
                CaptionML=ENU='Order',ESP='Orden';
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Failiure Pep.";SalesHeaderExt."Failiure Pep.")
    {
        
                CaptionML=ESP='Pep.';
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
    field("Failiure Order No.";SalesHeaderExt."Failiure Order No.")
    {
        
                CaptionML=ENU='Order No.',ESP='N§ pedido';
                
                            ;trigger OnValidate()    BEGIN
                             SalesHeaderExt.Save();
                           END;


}
}
}
} addafter("Sell-to Customer Name")
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
        
                Visible=verRegisterSeries ;
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
} addafter("Applies-to Doc. No.")
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
group("QB_Datos")
{
        
                CaptionML=ENU='Payment',ESP='Datos para los C lculos';
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
} addafter("Payment")
{
group("Control1100286010")
{
        
                CaptionML=ENU='Payment',ESP='Periodo de facturaci¢n';
    field("QFA Period Start Date";rec."QFA Period Start Date")
    {
        
}
    field("QFA Period End Date";rec."QFA Period End Date")
    {
        
}
    field("QB Operation date SII";rec."QB Operation date SII")
    {
        
                ToolTipML=ESP='Si est  informada se usar  esta como fecha de la operaci¢n, si no lo est  y hay fecha fin del periodo se usar  esta, si no hay ninguna informada se usara la fecha de registro';
                Visible=vQuoSII ;
}
}
} addafter("Control58")
{
group("Control1100286013")
{
        
                CaptionML=ESP='General';
}
} addafter("Foreign Trade")
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


modify("Posting No.")
{
Visible=verRegisterSeries ;


}


//modify("Document Date")
//{
//
//
//}
//

//modify("Posting Date")
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

modify("Applies-to Doc. Type")
{
Importance=Additional ;


}


modify("Applies-to Doc. No.")
{
Importance=Additional ;


}


//modify("Payment Terms Code")
//{
//
//
//}
//

//modify("Payment Method Code")
//{
//
//
//}
//

modify("Pay-at Code")
{
Importance=Additional ;


}


modify("Prices Including VAT")
{
Importance=Additional;


}


//modify("VAT Bus. Posting Group")
//{
//
//
//}
//

modify("EU 3-Party Trade")
{
Importance=Additional ;


}


//modify("Control174")
//{
//
//
//}
//

//modify("SelectedPayments")
//{
//
//
//}
//

modify("Shortcut Dimension 1 Code")
{
Importance=Additional;


}


modify("Shortcut Dimension 2 Code")
{
Importance=Additional;


}


modify("Payment Discount %")
{
Importance=Additional ;


}


//modify("Pmt. Discount Date")
//{
//
//
//}
//

modify("Direct Debit Mandate ID")
{
Importance=Additional ;


}


//modify("Location Code")
//{
//
//
//}
//

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
addafter("Move Negative Lines")
{
    action("QB_SuggestDueMilestone")
    {
        CaptionML=ENU='Suggest Due Milestones',ESP='Proponer hitos vencidos';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=PayrollStatistics;
                      PromotedCategory=Process;
}
    action("QB_GenerateMilestoneBudget")
    {
        CaptionML=ENU='Invoice Budget by Item',ESP='Facturar presupuesto por item';
                      Promoted=true;
                      Visible=FALSE;
                      PromotedIsBig=true;
                      Image=LedgerBudget;
                      PromotedCategory=Process;
}
    action("QB_ApplyRevIPC")
    {
        
                      CaptionML=ENU='Apply price revision',ESP='Aplicar revision precio';
                      Visible=seeService;
                      Image=Action;
                      
                                trigger OnAction()    VAR
                                 QBServiceOrderProcesing : Codeunit 7206911;
                               BEGIN
                                 QBServiceOrderProcesing.RegistrarIPCVenta(Rec);
                                 CurrPage.UPDATE(TRUE);
                               END;


}
} addafter("P&osting")
{
group("Action1100286038")
{
        CaptionML=ENU='P&osting',ESP='Proforma';
                      Image=Post ;
    action("Inesco_ProformaInvoiceAveria")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Pro Forma Invoice',ESP='Factura proforma AVERIAS';
                      ToolTipML=ENU='View or print the pro forma sales invoice.',ESP='Permite ver o imprimir la factura de venta proforma.';
                      Visible=seeInesco;
                      Image=ViewPostedOrder;
                      // PromotedCategory=Category5;
                      
                                trigger OnAction()    VAR
                                //  DraftFailiureSalesInvoice : Report 50049;
                                 SalesHeader : Record 36;
                               BEGIN


                                   SalesHeader.RESET;
                                   SalesHeader.SETRANGE("Document Type",rec."Document Type");
                                   SalesHeader.SETRANGE("No.",rec."No.");
                                   IF SalesHeader.FINDFIRST THEN;

                                  //  CLEAR(DraftFailiureSalesInvoice);
                                  //  DraftFailiureSalesInvoice.SETTABLEVIEW(SalesHeader);
                                  //  DraftFailiureSalesInvoice.RUN;
                               END;


}
    action("Inesco_ProformaInvoice")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Pro Forma Invoice',ESP='Factura proforma INESCO';
                      ToolTipML=ENU='View or print the pro forma sales invoice.',ESP='Permite ver o imprimir la factura de venta proforma.';
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
                 PaymentServiceSetup : Record 1060;
                 OfficeMgt : Codeunit 1630;
                 PermissionManager : Codeunit 9002;
                 PermissionManager1: Codeunit 51256;
                 SIIManagement : Codeunit 10756;
               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   Rec.FILTERGROUP(0);
                 END;

                 ActivateFields;

                 SetDocNoVisible;
                 SetControlAppearance;

                 IF rec."Quote No." <> '' THEN
                   ShowQuoteNo := TRUE;

                 IF rec."No." = '' THEN
                   IF OfficeMgt.CheckForExistingInvoice(rec."Sell-to Customer No.") THEN
                     ERROR(''); // Cancel invoice creation
                 IsSaaS := PermissionManager1.SoftwareAsAService;
                 IF (rec."No." <> '') AND (rec."Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);
                 PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;

                 //JAV 20/06/19: - Se hace visible  el campo del N£mero de serie de registro si es por proyecto o usa series en ventas
                 verRegisterSeries := (FunctionQB.QB_UserSeriesForJob) OR (FunctionQB.QB_UserSeriesForSales);

                 //Si se ven los anticipos de clientes
                 seePrepayment := QBPrepaymentManagement.AccessToCustomerPrepayment;

                 //QuoSII_1.4.98.999.begin
                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //SII estandar
                 verSII := FunctionQB.AccessToSII();

                 //JAV 21/03/21: QFA
                 verQFA := FunctionQB.AccessToFacturae;

                 //JAV 14/10/21: - QB 1.09.21 Ver el panel de datos adicionales de los Pedidos de servicio
                 ////seeService := FunctionQB.Job_AllowServiceOrder(rec."QB Job No.");

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);

                 //JAV 24/01/22: - QB 1.10.14 Activar impresi¢n de proformas para Inesco
                 seeInesco := FunctionQB.IsClient('INE');  //JAV 04/02/22: - QB 1.10.16 Nueva forma de obtener el cliente

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Sales Header");
                 //Q7357 +
               END;
trigger OnAfterGetRecord()    BEGIN
                       ShowQuoteNo := rec."Quote No." <> '';

                       SetControlAppearance;
                       WorkDescription := rec.GetWorkDescription;
                       UpdateShipToBillToGroupVisibility;

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

                           UpdatePaymentService;

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                           //JAV 27/10/21: - QB 1.09.25 Campos editables
                           QB_SetEditable;

                           //+Q8636
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //-Q8636
                         END;


//trigger

var
      CopySalesDoc : Report 292;
      MoveNegSalesLines : Report 6699;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      ReportPrint : Codeunit 228;
      UserMgt : Codeunit 5700;
      SalesCalcDiscountByType : Codeunit 56;
      ApprovalsMgmt : Codeunit 1535;
      LinesInstructionMgt : Codeunit 1320;
      CustomerMgt : Codeunit 1302;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      NavigateAfterPost: Option "Posted Document","New Document","Nowhere";
      WorkDescription : Text;
      HasIncomingDocument : Boolean;
      DocNoVisible : Boolean;
      ExternalDocNoMandatory : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      PaymentServiceVisible : Boolean;
      PaymentServiceEnabled : Boolean;
      OpenPostedSalesInvQst : TextConst ENU='The invoice is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?',ESP='La factura se registr¢ con el n£mero %1 y se movi¢ a la ventana de facturas de venta registradas.\\¨Quiere abrir la factura registrada?';
      IsCustomerOrContactNotEmpty : Boolean;
      ShowQuoteNo : Boolean;
      JobQueuesUsed : Boolean;
      CanCancelApprovalForRecord : Boolean;
      DocumentIsPosted : Boolean;
      ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
      BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";
      EmptyShipToCodeErr : TextConst ENU='The Code field can only be empty if you select Custom Address in the Ship-to field.',ESP='El campo C¢digo solo puede estar vac¡o si selecciona Direcci¢n personalizada en el campo Direcci¢n de env¡o.';
      IsSaaS : Boolean;
      IsBillToCountyVisible : Boolean;
      IsSellToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      OperationDescription : Text[500];
      "--------------------------------------- QB" : Integer;
      verRegisterSeries : Boolean ;
      FunctionQB : Codeunit 7207272;
      QBPrepaymentManagement : Codeunit 7207300;
      seePrepayment : Boolean;
      QB_edGEDueDate : Boolean;
      verSII : Boolean;
      verQFA : Boolean;
      SalesHeaderExt : Record 7207071;
      seeService : Boolean;
      seeJob : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      seeInesco : Boolean;
      seeDragDrop : Boolean;
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
//      SalesInvoiceHeader : Record 112;
//      OfficeMgt : Codeunit 1630;
//      InstructionMgt : Codeunit 1330;
//      PreAssignedNo : Code[20];
//      IsScheduledPosting : Boolean;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
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
//        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
//        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
//        if ( SalesInvoiceHeader.FINDFIRST  )then
//          PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
//      end ELSE
//        CASE Navigate OF
//          NavigateAfterPost::"Posted Document":
//            if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//              ShowPostedConfirmationMessage(PreAssignedNo);
//          NavigateAfterPost::"New Document":
//            if ( DocumentIsPosted  )then begin
//              SalesHeader.INIT;
//              SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::"Invoice");
//              SalesHeader.INSERT(TRUE);
//              PAGE.RUN(PAGE::"Sales Invoice",SalesHeader);
//            end;
//        end;
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
//Local procedure SalespersonCodeOnAfterValidate();
//    begin
//      CurrPage.SalesLines.PAGE.UpdatePage(TRUE);
//    end;
Local procedure SetDocNoVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
     DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Reminder","FinChMemo";
   begin
     DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Invoice",rec."No.");
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
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookMgt : Codeunit 1543;
   begin
     HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
     SetExtDocNoMandatoryCondition;

     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

     IsCustomerOrContactNotEmpty := (rec."Sell-to Customer No." <> '') or (rec."Sell-to Contact No." <> '');

     WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
   end;
//Local procedure UpdatePaymentService();
//    var
//      PaymentServiceSetup : Record 1060;
//    begin
//      PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
//    end;
Local procedure UpdateShipToBillToGroupVisibility();
   begin
     CustomerMgt.CalculateShipToBillToOptions(ShipToOptions,BillToOptions,Rec);
   end;

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
      //Retenciones
      QB_edGEDueDate := (rec."QW Cod. Withholding by GE" <> '');

      //JAV 27/10/21: - QB 1.09.25 Campos de presupuestos editables y l¡neas
      edQPR := FunctionQB.Job_IsBudget(Rec."QB Job No.");
      CurrPage.SalesLines.PAGE.QB_SetTxtPiecework(Rec."QB Job No.");

      //JAV 14/10/21: - QB 1.09.21 Ver el panel de datos adicionales de los Pedidos de servicio
      seeService := FunctionQB.Job_AllowServiceOrder(rec."QB Job No.");

      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      QuoSII_SetEditable;

      SalesHeaderExt.Read(Rec.RECORDID);
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


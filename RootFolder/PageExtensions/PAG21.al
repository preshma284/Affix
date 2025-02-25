pageextension 50153 MyExtension21 extends 21//18
{
layout
{
addafter("General")
{
group("QB_QuoBuilding")
{
        
                CaptionML=ENU='QuoBuilding',ESP='QuoBuilding';
    field("QB_DataMissedMessage";rec."QB Data Missed Message")
    {
        
                Visible=QB_MandatoryFields ;
}
group("QB_DatosGeneralesQB")
{
        
                CaptionML=ESP='Datos Generales QB';
}
    field("QB_ReferringOfCustomer";rec."QB Referring of Customer")
    {
        
                Visible=QB_verReferente;
                
                            ;trigger OnValidate()    BEGIN
                             //QBA-01 19/02/19 JAV - Bloqueo de administradores
                             QB_OnAfterGetRecord;
                           END;


}
    field("QB_GenericCustomer";rec."QB Generic Customer")
    {
        
}
    field("QB Category";rec."QB Category")
    {
        
}
    field("QB Sub-Category";rec."QB Sub-Category")
    {
        
}
    field("QB Customer Type";rec."QB Customer Type")
    {
        
}
    field("QB_JVDimensionCode";rec."QB JV Dimension Code")
    {
        
}
    field("QB_ReceivableBankNo";rec."QB Receivable Bank No.")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Receivable Bank No."))
    {
        
                CaptionML=ESP='Nombre del banco';
                Enabled=false ;
}
    field("QB Third No.";rec."QB Third No.")
    {
        
                ToolTipML=ESP='Este campo relaciona al cliente con un proveedor, lo que permite liquidar movimientos entre ambos';
                
                            ;trigger OnValidate()    BEGIN
                             QB_OnAfterGetRecord;
                           END;


}
group("QB_Amounts")
{
        
                CaptionML=ESP='Importes';
    field("QB_WithholdingGroupByGE";rec."QW Withholding Group by GE")
    {
        
}
    field("QB_WithholdingGroupByPIT";rec."QW Withholding Group by PIT")
    {
        
                Visible=false ;
}
    field("QB_PendingWithholdingAmount";rec."QW Withholding Pending GE")
    {
        
}
    field("QB_WithholdingAmountPIT";rec."QW Withholding Amount PIT")
    {
        
                Visible=false ;
}
    field("QB Prepayment Amount";rec."QB Prepayment Amount")
    {
        
                Visible=seePrepayments ;
}
    field("QB Prepayment Amount (LCY)";rec."QB Prepayment Amount (LCY)")
    {
        
                Visible=seePrepayments ;
}
}
group("QB_DatosAuxiliares")
{
        
                CaptionML=ENU='Customers Representatives',ESP='Datos auxiliares';
    field("QB_FirstSurname";rec."QB First Surname")
    {
        
                Visible=false ;
}
    field("QB_SecondSurname";rec."QB Second Surname")
    {
        
                Visible=false ;
}
}
group("QB_Constitution")
{
        
                CaptionML=ENU='Constitution',ESP='Constituci¢n';
    field("QB_EstablishmentDate";rec."QB Establishment Date")
    {
        
}
    field("QB_BeforeTheNotary";rec."QB Before The Notary")
    {
        
}
    field("QB_ProtocolNo";rec."QB Protocol No.")
    {
        
}
    field("QB_CommercialRegister";rec."QB Commercial Register")
    {
        
}
}
group("QB_CustomerRepresentatives")
{
        
                CaptionML=ENU='Customers Representatives',ESP='Representantes';
    field("QB_Representative1";rec."QB Representative 1")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del primer representante del cliente para la impresi¢n de contratos';
}
    field("QB_Representative1Name";rec."QB Representative 1 Name")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del segundo representante del cliente para la impresi¢n de contratos';
}
    field("QB_Representative2";rec."QB Representative 2")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del primer representante del cliente para la impresi¢n de contratos';
}
    field("QB_Representative2Name";rec."QB Representative 2 Name")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del segundo representante del cliente para la impresi¢n de contratos';
}
}
}
    part("QM_Data_Synchronization_Log";7174395)
    {
        
                SubPageView=SORTING("Table","RecordID","With Company");SubPageLink="Table"=CONST(18), "Code 1"=field("No.");
                Visible=verMasterData;
}
group("Control1100286007")
{
        
                CaptionML=ENU='rec."Address" & rec."Contact"',ESP='Direcci¢n y contacto';
}
} addafter("Search Name")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
                ToolTipML=ENU='Specifies the customers VAT registration number for customers in EU countries/regions.',ESP='Especifica el CIF/NIF de clientes de pa¡ses o regiones de la UE.';
                ApplicationArea=Basic,Suite;
                
                             ;trigger OnDrillDown()    VAR
                              VATRegistrationLogMgt : Codeunit 249;
                            BEGIN
                              VATRegistrationLogMgt.AssistEditCustomerVATReg(Rec);
                            END;


}
} addafter("Copy Sell-to Addr. to Qte From")
{
group("Control1100286005")
{
        
                CaptionML=ESP='eFactura';
                Visible=seeFacturae;
    field("QFA Quofacturae endpoint";rec."QFA Quofacturae endpoint")
    {
        
                Visible=seeFacturae ;
}
}
} addafter("AgedAccReceivableChart")
{
  part("PriceAndLineDisc"; 1347)
            {

                CaptionML = ENU = 'Special Prices & Discounts', ESP = 'Precios y descuentos especiales';
                ApplicationArea = All;
                Visible = FoundationOnly;
            }
group("Control7174331")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII VAT Reg No. Type";rec."QuoSII VAT Reg No. Type")
    {
        
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
    field("QuoSII Sales Special R. ATCN";rec."QuoSII Sales Special R. ATCN")
    {
        
}
    field("QuoSII Sales Special R. 1 ATCN";rec."QuoSII Sales Special R. 1 ATCN")
    {
        
}
    field("QuoSII Sales Special R. 2 ATCN";rec."QuoSII Sales Special R. 2 ATCN")
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


modify("Blocked")
{
Enabled=QB_BlockedEnabled ;


}

}

actions
{
addafter("CustomerReportSelections")
{
    action("QFA_AdministrationCenters")
    {
        CaptionML=ENU='Administration Centers - Customer',ESP='Centros Administrativos';
                      RunObject=Page 7174498;
RunPageLink="Customer no."=field("No.");
                      Promoted=true;
                      Visible=seeFacturae;
                      PromotedIsBig=true;
                      Image=WarehouseSetup;
                      PromotedCategory=Category10;
                      PromotedOnly=true;
}
} addafter("Ledger E&ntries")
{
    action("QB_Withholding_Movs")
    {
        CaptionML=ENU='Withholding Movs.',ESP='Movs. retenci¢n';
                      RunObject=Page 7207400;
                      RunPageView=SORTING("Type","No.","Open");
RunPageLink="Type"=FILTER('Customer'), "No."=field("No."), "Open"=CONST(true);
                      Promoted=true;
                      Image=ReturnRelated;
                      PromotedCategory=Process;
}
    action("QB_LiquidateMovs")
    {
        
                      CaptionML=ENU='Open Invoices',ESP='Liquidar Tercero';
                      Promoted=true;
                      Enabled=actLiquidateMovs;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 Cust : Record 18;
                                 QBLiquidateMovs : Page 7206968;
                               BEGIN
                                 //PGM 17/09/20: - ORTIZ GFGAP029 Se a¤ade el campo "Related Vendor No." y el proceso de liquidar clientes con proveedores
                                 CLEAR(QBLiquidateMovs);
                                 QBLiquidateMovs.SetData(rec."QB Third No.", rec."Currency Code");
                                 QBLiquidateMovs.RUNMODAL;
                               END;


}
}

}

//trigger
trigger OnOpenPage()    VAR
                 OfficeManagement : Codeunit 1630;
                 PermissionManager : Codeunit 9002;
                 PermissionManager1: Codeunit 51256;
               BEGIN
                 ActivateFields;

                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 SetNoFieldVisible;
                 IsOfficeAddin := OfficeManagement.IsAvailable;
                 IsSaaS := PermissionManager1.SoftwareAsAService;

                 IF FoundationOnly THEN
                   CurrPage.PriceAndLineDisc.PAGE.InitPage(FALSE);

                 ShowCharts := rec."No." <> '';

                 QB_OnOpenPage;

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 if ( seeDragDrop  )then
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Customer);
                 //Q7357 +
               END;
trigger OnAfterGetRecord()    BEGIN
                       ActivateFields;
                       StyleTxt := rec.SetStyle;

                       //QBA-01 19/02/19 JAV - Revisar datos del registro
                       QB_OnAfterGetRecord;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           CRMCouplingManagement : Codeunit 5331;
                           WorkflowManagement : Codeunit 1501;
                           WorkflowEventHandling : Codeunit 1520;
                           WorkflowWebhookManagement : Codeunit 1543;
                           AgedAccReceivable : Codeunit 763;
                         BEGIN
                           CreateCustomerFromTemplate;
                           ActivateFields;
                           StyleTxt := rec.SetStyle;
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
                             IF rec."No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                           OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

                           IF FoundationOnly THEN BEGIN
                             GetSalesPricesAndSalesLineDisc;
                             BalanceExhausted := 10000 <= rec.CalcCreditLimitLCYExpendedPct;
                             DaysPastDueDate := AgedAccReceivable.InvoicePaymentDaysAverage(rec."No.");
                             AttentionToPaidDay := DaysPastDueDate > 0;
                           END;

                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

                           EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
                             WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

                           EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer,EventFilter);

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           IF rec."No." <> '' THEN BEGIN
                             IF ShowCharts THEN
                               CurrPage.AgedAccReceivableChart.PAGE.UpdateChartForCustomer(rec."No.");
                             IF IsOfficeAddin THEN
                               CurrPage.AgedAccReceivableChart2.PAGE.UpdateChartForCustomer(rec."No.");
                           END;

                           ExpectedMoneyOwed := GetMoneyOwedExpected;

                           //QBA-01 19/02/19 JAV - Revisar datos del registro
                           QB_OnAfterGetRecord;

                           //+Q8636
                           if ( seeDragDrop  )then BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //-Q8636
                         END;


//trigger

var
      CustomizedCalEntry : Record 7603;
      CustomizedCalendar : Record 7602;
      CalendarMgmt : Codeunit 7600;
      ApprovalsMgmt : Codeunit 1535;
      CRMIntegrationManagement : Codeunit 5330;
      CustomerMgt : Codeunit 1302;
      FormatAddress : Codeunit 365;
      StyleTxt : Text;
      ContactEditable : Boolean ;
      SocialListeningSetupVisible : Boolean ;
      SocialListeningVisible : Boolean ;
      ShowCharts : Boolean ;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      OpenApprovalEntriesExistCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      NoFieldVisible : Boolean;
      BalanceExhausted : Boolean;
      AttentionToPaidDay : Boolean;
      IsOfficeAddin : Boolean;
      NoPostedInvoices : Integer;
      NoPostedCrMemos : Integer;
      NoOutstandingInvoices : Integer;
      NoOutstandingCrMemos : Integer;
      Totals : Decimal;
      AmountOnPostedInvoices : Decimal;
      AmountOnPostedCrMemos : Decimal;
      AmountOnOutstandingInvoices : Decimal;
      AmountOnOutstandingCrMemos : Decimal;
      AdjmtCostLCY : Decimal;
      AdjCustProfit : Decimal;
      CustProfit : Decimal;
      AdjProfitPct : Decimal;
      CustInvDiscAmountLCY : Decimal;
      CustPaymentsLCY : Decimal;
      CustSalesLCY : Decimal;
      OverduePaymentsMsg : TextConst ENU='Overdue Payments as of %1',ESP='Pagos vencidos al %1';
      DaysPastDueDate : Decimal;
      PostedInvoicesMsg : TextConst ENU='Posted Invoices (%1)',ESP='Facturas registradas (%1)';
      CreditMemosMsg : TextConst ENU='Posted Credit Memos (%1)',ESP='Abono registrados (%1)';
      OutstandingInvoicesMsg : TextConst ENU='Ongoing Invoices (%1)',ESP='Facturas en curso (%1)';
      OutstandingCrMemosMsg : TextConst ENU='Ongoing Credit Memos (%1)',ESP='Abonos actuales (%1)';
      ShowMapLbl : TextConst ENU='Show on Map',ESP='Mostrar en el mapa';
      ExpectedMoneyOwed : Decimal;
      FoundationOnly : Boolean;
      CanCancelApprovalForRecord : Boolean;
      EnabledApprovalWorkflowsExist : Boolean;
      NewMode : Boolean;
      EventFilter : Text;
      CaptionTxt : Text;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      IsSaaS : Boolean;
      IsCountyVisible : Boolean;
      "--------------------- QB" : Integer;
      QB_verReferente : Boolean ;
      QB_BlockedEnabled : Boolean;
      QB_MandatoryFields : Boolean;
      seeFacturae : Boolean;
      seeDragDrop : Boolean;
      FunctionQB : Codeunit 7207272;
      QBPrepaymentManagement : Codeunit 7207300;
      seePrepayments : Boolean;
      vQuoSII : Boolean;
      verMasterData : Boolean;
      actLiquidateMovs : Boolean;
      BankAccount : Record 270;
      BankName : Text;

    
    

//procedure
Local procedure GetTotalSales() : Decimal;
   begin
     NoPostedInvoices := 0;
     NoPostedCrMemos := 0;
     NoOutstandingInvoices := 0;
     NoOutstandingCrMemos := 0;
     Totals := 0;

     AmountOnPostedInvoices := CustomerMgt.CalcAmountsOnPostedInvoices(rec."No.",NoPostedInvoices);
     AmountOnPostedCrMemos := CustomerMgt.CalcAmountsOnPostedCrMemos(rec."No.",NoPostedCrMemos);

     AmountOnOutstandingInvoices := CustomerMgt.CalculateAmountsOnUnpostedInvoices(rec."No.",NoOutstandingInvoices);
     AmountOnOutstandingCrMemos := CustomerMgt.CalculateAmountsOnUnpostedCrMemos(rec."No.",NoOutstandingCrMemos);

     Totals := AmountOnPostedInvoices + AmountOnPostedCrMemos + AmountOnOutstandingInvoices + AmountOnOutstandingCrMemos;

     CustomerMgt.CalculateStatistic(
       Rec,
       AdjmtCostLCY,AdjCustProfit,AdjProfitPct,
       CustInvDiscAmountLCY,CustPaymentsLCY,CustSalesLCY,
       CustProfit);
     exit(Totals)
   end;
Local procedure GetAmountOnPostedInvoices() : Decimal;
   begin
     exit(AmountOnPostedInvoices)
   end;
Local procedure GetAmountOnCrMemo() : Decimal;
   begin
     exit(AmountOnPostedCrMemos)
   end;
Local procedure GetAmountOnOutstandingInvoices() : Decimal;
   begin
     exit(AmountOnOutstandingInvoices)
   end;
Local procedure GetAmountOnOutstandingCrMemos() : Decimal;
   begin
     exit(AmountOnOutstandingCrMemos)
   end;
Local procedure GetMoneyOwedExpected() : Decimal;
   begin
     exit(CustomerMgt.CalculateAmountsWithVATOnUnpostedDocuments(rec."No."))
   end;
Local procedure GetSalesPricesAndSalesLineDisc();
   begin
     if ( rec."No." <> CurrPage.PriceAndLineDisc.PAGE.GetLoadedCustNo  )then begin
       CurrPage.PriceAndLineDisc.PAGE.LoadCustomer(Rec);
       CurrPage.PriceAndLineDisc.PAGE.UPDATE(FALSE);
     end;
   end;
Local procedure ActivateFields();
   begin
     SetSocialListeningFactboxVisibility;
     ContactEditable := rec."Primary Contact No." = '';
     IsCountyVisible := FormatAddress.UseCounty(rec."Country/Region Code");
   end;
Local procedure ContactOnAfterValidate();
   begin
     ActivateFields;
   end;
Local procedure SetSocialListeningFactboxVisibility();
   var
     SocialListeningMgt : Codeunit 50455;
   begin
     SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
   end;
Local procedure SetNoFieldVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
   begin
     NoFieldVisible := DocumentNoVisibility.CustomerNoIsVisible;
   end;
//Local procedure SetCustomerNoVisibilityOnFactBoxes();
//    begin
//      CurrPage.SalesHistSelltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
//      CurrPage.SalesHistBilltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
//      CurrPage.CustomerStatisticsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
//    end;
//
//    //[External]
//procedure RunReport(ReportNumber : Integer;CustomerNumber : Code[20]);
//    var
//      Customer : Record 18;
//    begin
//      Customer.SETRANGE("No.",CustomerNumber);
//      REPORT.RUNMODAL(ReportNumber,TRUE,TRUE,Customer);
//    end;
Local procedure CreateCustomerFromTemplate();
   var
     MiniCustomerTemplate : Record "Customer Templ.";
     Customer : Record 18;
     VATRegNoSrvConfig : Record 248;
     ConfigTemplateHeader : Record 8618;
     EUVATRegistrationNoCheck : Page 1339;
     CustomerRecRef : RecordRef;
   begin
     OnBeforeCreateCustomerFromTemplate(NewMode);

    //  if ( NewMode  )then begin
    //    if ( MiniCustomerTemplate.NewCustomerFromTemplate(Customer)  )then begin
    //      if ( VATRegNoSrvConfig.VATRegNoSrvIsEnabled  )then
    //        if ( Customer."Validate EU Vat Reg. No."  )then begin
    //          EUVATRegistrationNoCheck.SetRecordRef(Customer);
    //          COMMIT;
    //          EUVATRegistrationNoCheck.RUNMODAL;
    //          EUVATRegistrationNoCheck.GetRecordRef(CustomerRecRef);
    //          CustomerRecRef.SETTABLE(Customer);
    //        end;

    //      Rec.COPY(Customer);
    //      CurrPage.UPDATE;
    //    end ELSE begin
    //      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Customer);
    //      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
    //      if ( not ConfigTemplateHeader.ISEMPTY  )then
    //        CurrPage.CLOSE;
    //    end;
    //    NewMode := FALSE;
    //  end;
   end;
//
//    [Integration]
//procedure SetCaption(var InText : Text);
//    begin
//    end;
//
//    [Integration]
Local procedure OnBeforeCreateCustomerFromTemplate(var NewMode : Boolean);
   begin
   end;
LOCAL procedure "------------------------------------------------------ QB"();
    begin
    end;
LOCAL procedure QB_OnOpenPage();
    var
      QMMasterDataManagement : Codeunit 7174368;
      QBTablesSetup : Record 7206903;
      rRef : RecordRef;
    begin
      //QBA-01 03/05/19 JAV: - Mejora en las adaptaciones de los clientes   JAV 01/03/21: - QB 1.08.19 Se cambia el uso de QBSetup por la funci¢n
      QB_verReferente := FunctionQB.QB_AccessToReferentes;

      //JAV 02/04/20: - Campo visible si se controla que faltan datos
      rRef.GETTABLE(Rec);
      QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);

      //QFA
      seeFacturae := FunctionQB.AccessToFacturae;

      seePrepayments := QBPrepaymentManagement.AccessToCustomerPrepayment;
      vQuoSII := FunctionQB.AccessToQuoSII;

      //JAV 01/03/21: - QB 1.08.19 Se pasan funciones de QBSetup a Functions QB
      //JAV 14/02/22: - QM 1.00.00 Se pasana las funciones de MasterData a su propia CU
      verMasterData := QMMasterDataManagement.SetMasterDataVisible(DATABASE::Customer);

      //Q7357 -
      seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
      if ( seeDragDrop  )then
        CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Customer);
      //Q7357 +
    end;
LOCAL procedure QB_OnAfterGetRecord();
    var
      Contacto : Record 5050;
      Text001 : TextConst ESP='El contacto asociado al cliente est  bloqueado, debe cambiarlo';
    begin
      //QBA-01 19/02/19 JAV - Bloqueo de administradores
      if ( Contacto.GET(rec."QB Referring of Customer")  )then
        if ( Contacto.Bloqueado  )then
          MESSAGE(Text001);

      //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
      QB_BlockedEnabled := not rec."QB Data Missed";

      //JAV 20/09/20: - El bot¢n de liquidar con proveedor solo est  activo si tiene un proveedor relacionado
      actLiquidateMovs := (rec."QB Third No." <> '');


      //JAV 14/02/22: - QM 1.00.00 Se pasan los valores adecuados a la subp gina
      CurrPage.QM_Data_Synchronization_Log.PAGE.SetData(Rec.RECORDID);

      //+Q8636
      if ( seeDragDrop  )then begin
        CurrPage.DropArea.PAGE.SetFilter(Rec);
        CurrPage.FilesSP.PAGE.SetFilter(Rec);
      end;
      //-Q8636
    end;

//procedure
}


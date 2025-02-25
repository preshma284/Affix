pageextension 50163 MyExtension26 extends 26//23
{
layout
{
addafter("General")
{
group("QB_QuoBuilding")
{
        
                CaptionML=ENU='QuoBuilding',ESP='QuoBuilding';
    field("QB Data Missed Message";rec."QB Data Missed Message")
    {
        
                Visible=QB_MandatoryFields ;
}
    field("QB Employee";rec."QB Employee")
    {
        
}
    field("QB Obralia";rec."QB Obralia")
    {
        
                Visible=vObralia ;
}
    field("QB Category";rec."QB Category")
    {
        
}
    field("QB Sub-Category";rec."QB Sub-Category")
    {
        
}
    field("QB Payable Bank No.";rec."QB Payable Bank No.")
    {
        
}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payable Bank No."))
    {
        
                CaptionML=ESP='Nombre del banco';
                Enabled=false ;
}
    field("QB JV Dimension Code";rec."QB JV Dimension Code")
    {
        
}
    field("QB Operation Counties";rec."QB Operation Counties")
    {
        
                
                              ;trigger OnAssistEdit()    VAR
                               QBPageSubscriber : Codeunit 7207349;
                             BEGIN
                               //QUONEXT PER 05.06.19: - Elecnor, assist edit del campo de provincias en las que opera
                               QBPageSubscriber.GetOperationCounties(rec."QB Operation Counties");
                               Rec.VALIDATE("QB Operation Counties");
                             END;


}
    field("QB Operation Countries";rec."QB Operation Countries")
    {
        
                
                              ;trigger OnAssistEdit()    VAR
                               QBPageSubscriber : Codeunit 7207349;
                             BEGIN
                               //QUONEXT PER 05.06.19: - Elecnor, assist edit del campo de paises en los que opera
                               QBPageSubscriber.GetOperationCountries(rec."QB Operation Countries");
                               Rec.VALIDATE("QB Operation Countries");
                             END;


}
    field("QB SII Operation Description";rec."QB SII Operation Description")
    {
        
                ToolTipML=ESP='Que descripci¢n de operaci¢n se usar  por defecto con este proveedor para el SII';
}
    field("QB Third No.";rec."QB Third No.")
    {
        
                ToolTipML=ESP='Este campo relaciona al proveedor con un cliente, lo que permite liquidar movimientos entre ambos';
                
                            ;trigger OnValidate()    BEGIN
                             QB_OnAfterGetRecord;
                           END;


}
group("QB_Activity")
{
        
                CaptionML=ENU='Activity',ESP='Actividades';
    field("QB No. Activities";rec."QB No. Activities")
    {
        
}
grid("Control1100286027")
{
        
                GridLayout=Rows ;
group("QB_MainActivity")
{
        
                CaptionML=ESP='Actividad Principal';
    field("QB Main Activity Code";rec."QB Main Activity Code")
    {
        
                ShowCaption=false ;
}
    field("QB Main Activity Description";rec."QB Main Activity Description")
    {
        
                ShowCaption=false ;
}
}
}
}
group("QB_Certificates_")
{
        
                CaptionML=ENU='Certificates',ESP='Certificados';
    field("QB No. Cetificates";rec."QB No. Cetificates")
    {
        
}
    field("QB Do not control certificates";rec."QB Do not control certificates")
    {
        
}
}
group("QB_Conditions_")
{
        
                CaptionML=ENU='Conditions',ESP='Condiciones y Pagos';
    field("QB Validity Quotes";rec."QB Validity Quotes")
    {
        
}
    field("QB Warranty";rec."QB Warranty")
    {
        
}
    field("QB Payment Phases";rec."QB Payment Phases")
    {
        
                ToolTipML=ESP='Que fase de pago usar  el proveedor por defecto en las compras, puede quedar en blanco';
                Visible=QB_seePaymentPhases ;
}
    field("QB Calc Due Date";rec."QB Calc Due Date")
    {
        
                Visible=qb_verVtos;
                
                            ;trigger OnValidate()    BEGIN
                             QB_edDiasVtos := (rec."QB Calc Due Date" = rec."QB Calc Due Date"::Reception);
                             IF (NOT QB_edDiasVtos) THEN
                               rec."QB No. Days Calc Due Date" := 0;
                           END;


}
    field("QB No. Days Calc Due Date";rec."QB No. Days Calc Due Date")
    {
        
                Visible=qb_verVtos;
                Enabled=QB_edDiasVtos ;
}
}
group("QB_Invoicing")
{
        
                CaptionML=ENU='Invoicing',ESP='Contratos';
                Visible=QB_verControlContrato;
    field("QB Quantity available contract";rec."QB Quantity available contract")
    {
        
                Visible=QB_verControlContrato ;
}
    field("QB Do not control in contracts";rec."QB Do not control in contracts")
    {
        
                Visible=QB_verControlContrato;
                Editable=QB_edControlContrato ;
}
}
group("QB_Shipments")
{
        
                CaptionML=ENU='Withholding',ESP='Albaranes';
                Visible=verShipments;
    field("QB Shipments Balance";rec."QB Shipments Balance")
    {
        
                Visible=verShipments ;
}
    field("QB Shipments Balance (LCY)";rec."QB Shipments Balance (LCY)")
    {
        
                Visible=verShipments ;
}
}
group("QB_Withholding")
{
        
                CaptionML=ENU='Withholding',ESP='Retenciones y Anticipos';
    field("QW Withholding Group by G.E.";rec."QW Withholding Group by G.E.")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             //+ Q13647 MMS 30/06/21 permitir editar campo "QW Calc Due DateË (Calculo Vto. Retenci¢n) solo si el campo Grupo retenciones por B.E. no est  en blanco.
                             IF (rec."QW Withholding Group by G.E." = '') THEN
                               CLEAR(rec."QW Calc Due Date");
                             editGrupoRetencionesBE := (rec."QW Withholding Group by G.E." <> '');
                             //- Q13647
                           END;


}
    field("QW Calc Due Date";rec."QW Calc Due Date")
    {
        
                ToolTipML=ESP='Indica el m‚todo de c lculo de la fecha de vencimiento de las retenciones de B.E., si se indica por grupo usar  la configurada en el grupo de retenciones, si se indica otra se fuerza su uso.';
                Editable=editGrupoRetencionesBE ;
}
    field("QW Withholding Group by PIT";rec."QW Withholding Group by PIT")
    {
        
}
    field("QW Withholding Pending Amount";rec."QW Withholding Pending Amount")
    {
        
}
    field("QW Withholding Amount PIT";rec."QW Withholding Amount PIT")
    {
        
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
group("QB_Representatives")
{
        
                CaptionML=ENU='Customers Representatives',ESP='Representantes';
    field("QB Attorney";rec."QB Attorney")
    {
        
}
    field("QB Attorney Name";rec."QB Attorney Name")
    {
        
}
    field("QB Representative 1";rec."QB Representative 1")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del primer representante del cliente para la impresi¢n de contratos';
}
    field("QB Representative 1 Name";rec."QB Representative 1 Name")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del segundo representante del cliente para la impresi¢n de contratos';
}
    field("QB Representative 2";rec."QB Representative 2")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del primer representante del cliente para la impresi¢n de contratos';
}
    field("QB Representative 2 Name";rec."QB Representative 2 Name")
    {
        
                ToolTipML=ESP='Contacto en la ficha del cliente de la persona que hace las funciones del segundo representante del cliente para la impresi¢n de contratos';
}
    field("QB Representative PRL";rec."QB Representative PRL")
    {
        
}
    field("QB Representative PRL Name";rec."QB Representative PRL Name")
    {
        
}
}
group("QB_Establishment")
{
        
                CaptionML=ENU='Establishment',ESP='Constituci¢n y datos contrato';
    field("QB Establishment Date";rec."QB Establishment Date")
    {
        
}
    field("QB Before the notary";rec."QB Before the notary")
    {
        
}
    field("QB notary city";rec."QB notary city")
    {
        
}
    field("QB Protocol No.";rec."QB Protocol No.")
    {
        
}
    field("QB Business Registration";rec."QB Business Registration")
    {
        
}
    field("QB Reg. Sheet";rec."QB Reg. Sheet")
    {
        
}
    field("QB Seg.Soc. Number";rec."QB Seg.Soc. Number")
    {
        
}
}
}
    part("QM_Data_Synchronization_Log";7174395)
    {
        
                SubPageView=SORTING("Table","RecordID","With Company");SubPageLink="Table"=CONST(18), "Code 1"=field("No.");
                Visible=verMasterData;
}
} addafter("Name")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
                ToolTipML=ENU='Specifies the customers VAT registration number for customers in EU countries/regions.',ESP='Especifica el CIF/NIF de clientes de pa¡ses o regiones de la UE.';
                ApplicationArea=Basic,Suite;
                
                             ;trigger OnDrillDown()    VAR
                              VATRegistrationLogMgt : Codeunit 249;
                            BEGIN
                              VATRegistrationLogMgt.AssistEditVendorVATReg(Rec);
                            END;


}
    field("QuoSII_VATRegNoType";rec."QuoSII VAT Reg No. Type")
    {
        
                Visible=vQuoSII ;
}
} addafter("Receiving")
{
group("Control7174331")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII VAT Reg No. Type";rec."QuoSII VAT Reg No. Type")
    {
        
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
    field("QuoSII Purch Special R. ATCN";rec."QuoSII Purch Special R. ATCN")
    {
        
}
    field("QuoSII Purch Special R. 1 ATCN";rec."QuoSII Purch Special R. 1 ATCN")
    {
        
}
    field("QuoSII Purch Special R. 2 ATCN";rec."QuoSII Purch Special R. 2 ATCN")
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
} addafter("Control1903433907")
{
    part("QB_VendorStatisticsWithholdFB";7207403)
    {
        SubPageLink="No."=field("No.");
                Visible=TRUE;
}
}


modify("Blocked")
{
Enabled=QB_BlockedEnabled ;


}

}

actions
{
addafter("History")
{
group("Action7207274")
{
        CaptionML=ENU='&Data',ESP='Calidad';
    action("QB_Quality")
    {
        CaptionML=ENU='Quality',ESP='Calidad';
                      RunObject=Page 7207339;
RunPageLink="Vendor No."=field("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=TransferFunds;
                      PromotedCategory=Category9;
}
    action("QB_Conditions")
    {
        CaptionML=ENU='Conditions',ESP='Condiciones';
                      RunObject=Page 7207341;
RunPageLink="Vendor No."=field("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=BinContent;
                      PromotedCategory=Category9;
}
    action("QB_Certificates")
    {
        CaptionML=ENU='Certificates',ESP='Certificados';
                      RunObject=Page 7207340;
                      RunPageView=SORTING("Vendor No.","Certificate Line No.");
RunPageLink="Vendor No."=field("No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      PromotedCategory=Category9;
}
}
} addafter("Ledger E&ntries")
{
    action("QB_WithholdingMovs")
    {
        CaptionML=ENU='Withholding Movs.',ESP='Movs. retenci¢n';
                      RunObject=Page 7207400;
                      RunPageView=SORTING("Type","No.","Open");
RunPageLink="Type"=FILTER('Vendor'), "No."=field("No."), "Open"=CONST(true);
                      Promoted=true;
                      Image=ReturnRelated;
                      PromotedCategory=Process;
}
    action("QB_LiquidateMovs")
    {
        
                      CaptionML=ENU='Open Invoices',ESP='Liq. Tercero';
                      Promoted=true;
                      Enabled=actLiquidateMovs;
                      PromotedIsBig=true;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 Cust : Record 18;
                                 QBLiquidateMovs : Page 7206968;
                               BEGIN
                                 //JAV 20/09/20: - ORTIZ GFGAP029 Se a¤ade el campo "Related Customer No." y el proceso de liquidar clientes con proveedores

                                 CLEAR(QBLiquidateMovs);
                                 QBLiquidateMovs.SetData(rec."QB Third No.", rec."Currency Code");
                                 QBLiquidateMovs.RUNMODAL;
                               END;


}
}

}

//trigger

trigger OnOpenPage()
var
PermissionManager : Codeunit 9002;
PermissionManager1: Codeunit 51256;
               FunctionQB : Codeunit 7207272;
           
begin

                 ActivateFields;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 SetNoFieldVisible;
                 IsSaaS := PermissionManager1.SoftwareAsAService;

                 QB_OnOpenPage;

                 //JAV 27/06/22: - QB 1.10.55 Ver los anticipos
                 seePrepayments := QBPrepaymentManagement.AccessToCustomerPrepayment;


                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 if ( seeDragDrop  )then
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Customer);
                 //Q7357 +
               
             SetVendorNoVisibilityOnFactBoxes;

             ContactEditable := TRUE;

             //JAV 12/07/20: - Ver Calculo vtos.
             QB_verVtos := FunctionQB.AccessToChangeBaseVtos;
           
end;

trigger OnAfterGetRecord()    BEGIN
                       ActivateFields;

                       QB_OnAfterGetRecord;
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           CreateVendorFromTemplate;
                           ActivateFields;
                           OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);
                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           IF rec."No." <> '' THEN
                             CurrPage.AgedAccPayableChart.PAGE.UpdateChartForVendor(rec."No.");

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
      OfficeMgt : Codeunit 1630;
      CalendarMgmt : Codeunit 7600;
      PaymentToleranceMgt : Codeunit 426;
      WorkflowWebhookManagement : Codeunit 1543;
      ApprovalsMgmt : Codeunit 1535;
      Text001 : TextConst ENU='Do you want to allow payment tolerance for entries that are currently open?',ESP='¨Desea permitir la tolerancia de pago para movimientos pendientes?';
      Text002 : TextConst ENU='Do you want to remove payment tolerance from entries that are currently open?',ESP='¨Confirma que desea eliminar la tolerancia pago de los movimientos actualmente pendientes?';
      FormatAddress : Codeunit 365;
      ContactEditable : Boolean ;
      SocialListeningSetupVisible : Boolean ;
      SocialListeningVisible : Boolean ;
      OpenApprovalEntriesExistCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      ShowMapLbl : TextConst ENU='Show on Map',ESP='Mostrar en el mapa';
      IsOfficeAddin : Boolean;
      CanCancelApprovalForRecord : Boolean;
      SendToOCREnabled : Boolean;
      SendToOCRVisible : Boolean;
      SendToIncomingDocEnabled : Boolean;
      SendIncomingDocApprovalRequestVisible : Boolean;
      SendToIncomingDocumentVisible : Boolean;
      NoFieldVisible : Boolean;
      NewMode : Boolean;
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      IsSaaS : Boolean;
      IsCountyVisible : Boolean;
      "---------------------------- QB" : Integer;
      QB_verControlContrato : Boolean ;
      QB_edControlContrato : Boolean ;
      QB_UserSetup : Record 91;
      QB_BlockedEnabled : Boolean;
      QB_MandatoryFields : Boolean;
      QB_seePaymentPhases : Boolean;
      QB_verVtos : Boolean;
      QB_edDiasVtos : Boolean;
      FunctionQB : Codeunit 7207272;
      QBPrepaymentManagement : Codeunit 7207300;
      seePrepayments : Boolean;
      vQuoSII : Boolean;
      vObralia : Boolean;
      verMasterData : Boolean;
      actLiquidateMovs : Boolean;
      verShipments : Boolean;
      editGrupoRetencionesBE : Boolean;
      seeDragDrop : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     SetSocialListeningFactboxVisibility;
     ContactEditable := rec."Primary Contact No." = '';
     IsCountyVisible := FormatAddress.UseCounty(rec."Country/Region Code");
     if ( OfficeMgt.IsAvailable  )then
       ActivateIncomingDocumentsFields;
   end;
//Local procedure ContactOnAfterValidate();
//    begin
//      ActivateFields;
//    end;
Local procedure SetSocialListeningFactboxVisibility();
   var
     SocialListeningMgt : Codeunit 50455;
   begin
     SocialListeningMgt.GetVendFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
   end;
Local procedure SetVendorNoVisibilityOnFactBoxes();
   begin
    //  CurrPage.VendorHistBuyFromFactBox.PAGE.SetVendorNoVisibility(FALSE);
    //  CurrPage.VendorHistPayToFactBox.PAGE.SetVendorNoVisibility(FALSE);
    //  CurrPage.VendorStatisticsFactBox.PAGE.SetVendorNoVisibility(FALSE);
   end;
//Local procedure RunReport(ReportNumber : Integer);
//    var
//      Vendor : Record 23;
//    begin
//      Vendor.SETRANGE("No.",rec."No.");
//      REPORT.RUNMODAL(ReportNumber,TRUE,TRUE,Vendor);
//    end;
Local procedure ActivateIncomingDocumentsFields();
   var
     IncomingDocument : Record 130;
   begin
     if ( OfficeMgt.OCRAvailable  )then begin
       SendToIncomingDocumentVisible := TRUE;
       SendToIncomingDocEnabled := OfficeMgt.EmailHasAttachments;
       SendToOCREnabled := OfficeMgt.EmailHasAttachments;
       SendToOCRVisible := IncomingDocument.OCRIsEnabled and not IsIncomingDocApprovalsWorkflowEnabled;
       SendIncomingDocApprovalRequestVisible := IsIncomingDocApprovalsWorkflowEnabled;
     end;
   end;
Local procedure IsIncomingDocApprovalsWorkflowEnabled() : Boolean;
   var
     WorkflowEventHandling : Codeunit 1520;
     WorkflowDefinition : Query 1502;
   begin
     WorkflowDefinition.SETRANGE(Table_ID,DATABASE::"Incoming Document");
     WorkflowDefinition.SETRANGE(Entry_Point,TRUE);
     WorkflowDefinition.SETRANGE(Enabled,TRUE);
     WorkflowDefinition.SETRANGE(Type,WorkflowDefinition.Type::"Event");
     WorkflowDefinition.SETRANGE(Function_Name,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode);
     WorkflowDefinition.OPEN;
     WHILE WorkflowDefinition.READ DO
       exit(TRUE);

     exit(FALSE);
   end;
Local procedure CreateVendorFromTemplate();
   var
     MiniVendorTemplate : Record "Vendor Templ.";
     Vendor : Record 23;
     VATRegNoSrvConfig : Record 248;
     ConfigTemplateHeader : Record 8618;
     EUVATRegistrationNoCheck : Page 1339;
     VendorRecRef : RecordRef;
   begin
     OnBeforeCreateVendorFromTemplate(NewMode);

     if ( NewMode  )then begin
    //    if ( MiniVendorTemplate.NewVendorFromTemplate(Vendor)  )then begin
    //      if ( VATRegNoSrvConfig.VATRegNoSrvIsEnabled  )then
    //        if ( Vendor."Validate EU Vat Reg. No."  )then begin
    //          EUVATRegistrationNoCheck.SetRecordRef(Vendor);
    //          COMMIT;
    //          EUVATRegistrationNoCheck.RUNMODAL;
    //          EUVATRegistrationNoCheck.GetRecordRef(VendorRecRef);
    //          VendorRecRef.SETTABLE(Vendor);
    //        end;
    //      Rec.COPY(Vendor);
    //      CurrPage.UPDATE;
    //    end ELSE begin
    //      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Vendor);
    //      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
    //      if ( not ConfigTemplateHeader.ISEMPTY  )then
    //        CurrPage.CLOSE;
    //    end;
    //    NewMode := FALSE;
     end;
   end;
Local procedure SetNoFieldVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
   begin
     NoFieldVisible := DocumentNoVisibility.VendorNoIsVisible;
   end;

//    [Integration]
Local procedure OnBeforeCreateVendorFromTemplate(var NewMode : Boolean);
   begin
   end;
LOCAL procedure "----------------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_OnOpenPage();
    var
      rRef : RecordRef;
      QBTablesSetup : Record 7206903;
      FunctionQB : Codeunit 7207272;
      QMMasterDataManagement : Codeunit 7174368;
    begin
      //JAV 08/05/19 JAV - Se a¤ade el campo "Quantity available contracts" y su manejo
      FunctionQB.AccessToContratsControl(QB_verControlContrato, QB_edControlContrato);

      //JAV 02/04/20: - Campo visible si faltan datos
      rRef.GETTABLE(Rec);
      QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);

      QB_seePaymentPhases := FunctionQB.AccessToPaymentPhases;

      //Ver campos de albaranes pendientes
      verShipments := FunctionQB.QB_UseShipmentTypeInVendor;

      //JAV 01/03/21: - QB 1.08.19 Se pasan funciones de QBSetup a Functions QB
      //JAV 14/02/22: - QM 1.00.00 Se pasan las funciones de MasterData a su propia CU
      verMasterData := QMMasterDataManagement.SetMasterDataVisible(DATABASE::Vendor);

      vQuoSII := FunctionQB.AccessToQuoSII;
      vObralia := FunctionQB.AccessToObralia;

      //Q7357 -
      seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
      if ( seeDragDrop  )then
        CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Vendor);
      //Q7357 +
    end;
LOCAL procedure QB_OnAfterGetRecord();
    begin
      //-QPE6439
      Rec.VALIDATE("Payment Method Code");
      //+QPE6439

      //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
      QB_BlockedEnabled  := not rec."QB Data Missed";

      //JAV 12/07/20: - Ver Calculo vtos.
      Rec.VALIDATE("QB Calc Due Date");

      //JAV 20/09/20: - El bot¢n de liquidar con cliente solo est  activo si tiene uno relacionado
      actLiquidateMovs := (rec."QB Third No." <> '');

      //+ Q13647 MMS 30/06/21 permitir editar campo "QW Calc Due DateË (Calculo Vto. Retenci¢n) solo si el campo Grupo retenciones por B.E. no est  en blanco.
      editGrupoRetencionesBE := (rec."QW Withholding Group by G.E." <> '');
      //- Q13647


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


pageextension 50155 MyExtension22 extends 22//18
{
    layout
    {
        // addbefore("No.")
        // {
        //   field("trial field";rec."trial field")
        //   {

        //   }
        // }
        addafter("Phone No.")
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {

            }
            field("E-Mail"; rec."E-Mail")
            {

            }
            field("QB Referring of Customer"; rec."QB Referring of Customer")
            {

                Visible = verReferente;
            }
            field("QB Category"; rec."QB Category")
            {

            }
        }
        addafter("Payment Terms Code")
        {
            field("QB_PaymentMethodCode"; rec."Payment Method Code")
            {

            }
        }
        addafter("Payments (LCY)")
        {
            field("QB_NetChange"; rec."Net Change (LCY)")
            {

                ToolTipML = ESP = 'Especifica el saldo del cliente a la fecha indicada en el filtro';
            }
        }
        addfirst("factboxes")
        {
            part("DropArea"; 7174655)
            {

                Visible = seeDragDrop;
            }
            part("FilesSP"; 7174656)
            {

                Visible = seeDragDrop;
            }
        }

    }

    actions
    {
        addafter("ReportCustomerPaymentReceipt")
        {
            action("QB_WithholdingMovs")
            {
                CaptionML = ENU = 'Withholding Movs.', ESP = 'Movs. retenci¢n';
                RunObject = Page 7207400;
                RunPageView = SORTING("Type", "No.", "Open");
                RunPageLink = "Type" = FILTER('Customer'), "No." = field("No."), "Open" = CONST(true);
                Promoted = true;
                Image = ReturnRelated;
                PromotedCategory = Process;
            }
        }

    }

    //trigger
    trigger OnOpenPage()
    VAR
        CRMIntegrationManagement: Codeunit 5330;
    BEGIN
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        SetWorkflowManagementEnabledState;
        Rec.SETFILTER("Date Filter", '..%1', WORKDATE);

        //QBA-01 03/05/19 JAV: - Mejora en las adaptaciones de los clientes   JAV 01/03/21: - QB 1.08.19 Se cambia el uso de QBSetup por la funci¢n
        verReferente := FunctionQB.QB_AccessToReferentes;

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF seeDragDrop THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Customer);
        //Q7357 +
    END;

    trigger OnAfterGetCurrRecord()
    VAR
        CRMCouplingManagement: Codeunit 5331;
        WorkflowWebhookManagement: Codeunit 1543;
    //  SocialListeningMgt : Codeunit 871;
    BEGIN
        //  IF SocialListeningSetupVisible THEN
        //    SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);

        IF CRMIntegrationEnabled THEN
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);

        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        // Contextual Power BI FactBox: send data to filter the report in the FactBox
        CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection(rec."No.", FALSE, PowerBIVisible);

        SetWorkflowManagementEnabledState;
    END;


    //trigger

    var
        ApprovalsMgmt: Codeunit 1535;
        SocialListeningSetupVisible: Boolean;
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        PowerBIVisible: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        EventFilter: Text;
        CaptionTxt: Text;
        "------------------------ QB": Integer;
        verReferente: Boolean;
        seeDragDrop: Boolean;
        FunctionQB: Codeunit 7207272;



    //procedure
    procedure GetSelectionFilter(): Text;
    var
        Cust: Record 18;
        SelectionFilterManagement: Codeunit 46;
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        exit(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    end;

    //[External]
    procedure SetSelection(var Cust: Record 18);
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
    end;
    // Local procedure SetCustomerNoVisibilityOnFactBoxes();
    //    begin
    //      CurrPage.SalesHistSelltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    //      CurrPage.SalesHistBilltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    //      CurrPage.CustomerDetailsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    //      CurrPage.CustomerStatisticsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    //    end;
    Local procedure SetWorkflowManagementEnabledState();
    var
        WorkflowManagement: Codeunit 1501;
        WorkflowEventHandling: Codeunit 1520;
    begin
        EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer, EventFilter);
    end;

    //    [Integration]
    // procedure SetCaption(var InText : Text);
    //    begin
    //    end;

    //procedure
}


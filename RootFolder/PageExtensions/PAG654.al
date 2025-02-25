pageextension 50239 MyExtension654 extends 654//454
{
    layout
    {
        addafter("Currency Code")
        {
            field("QB_Position"; rec."QB Position")
            {

                ToolTipML = ESP = 'Informa del cargo de la persona que aprueba';
            }
            field("QB_Type"; rec."Type")
            {

            }
            field("QB_WithholdingPayment>"; rec."Withholding")
            {

            }
            field("QB_CustVendNo"; "CustVendNo")
            {

                CaptionML = ENU = 'Cust/Vend Name', ESP = 'Cliente/Proveedor';
            }
            field("QB_CustVendName"; "CustVendName")
            {

                CaptionML = ENU = 'Cust/Vend Name', ESP = 'Nombre Cliente/Proveedor';
            }
            field("QB_JobNo"; rec."Job No.")
            {

                Visible = false;
            }
        }
        addfirst("factboxes")
        {
            part("QB_ApprovalsFactBox"; 7207383)
            {

                SubPageView = SORTING("Entry No.");
                SubPageLink = "Entry No." = field("Entry No.");
            }
            part("IncomingDocAttachFactBox"; 193)
            {

                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
        }
        addafter("Change")
        {
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
        }

    }

    actions
    {
        addafter("Comments")
        {
            action("QB_SeeInvoice")
            {

                CaptionML = ESP = 'Ver Documento';
                Promoted = true;
                Visible = vDocumento;
                PromotedIsBig = true;
                Image = View;
                PromotedCategory = Process;

                trigger OnAction()
                VAR
                    CarteraDoc: Record 7000002;
                    PurchInvHeader: Record 122;
                    recref: RecordRef;
                    PostedPurchaseInvoice: Page 138;
                BEGIN
                    GetDocument(TRUE);
                END;


            }
        }
        addafter("Approve")
        {
            action("QB_WithHolding")
            {

                CaptionML = ENU = 'Delegate', ESP = 'Retener';
                ToolTipML = ENU = 'Withholding the approver.', ESP = 'Retiene temporalmente la solicitud de aprobaci¢n';
                ApplicationArea = Suite;
                Promoted = true;
                Visible = seeWithHolding;
                PromotedIsBig = true;
                Image = Lock;
                PromotedCategory = Process;
                Scope = Repeater;

                trigger OnAction()
                VAR
                    ApprovalEntry: Record 454;
                    QBApprovalManagement: Codeunit 7207354;
                BEGIN
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    QBApprovalManagement.WitHoldingRequest(ApprovalEntry);
                END;


            }
        }
        // addafter("Reject")
        // {
        //     action("Delegate")
        //     {

        //         CaptionML = ENU = 'Delegate', ESP = 'Delegar';
        //         ToolTipML = ENU = 'Delegate the approval to a substitute approver.', ESP = 'Delega la aprobaci¢n a un aprobador sustituto.';
        //         ApplicationArea = Suite;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         Image = Delegate;
        //         PromotedCategory = Process;
        //         Scope = Repeater;

        //         trigger OnAction()
        //         VAR
        //             ApprovalEntry: Record 454;
        //             ApprovalsMgmt: Codeunit 1535;
        //         BEGIN
        //             CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        //             ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
        //         END;


        //     }
        // }
        addafter("AllRequests")
        {
            action("QB_seeWithHolding")
            {

                CaptionML = ESP = 'Ver Retenidos';
                Promoted = true;
                Image = SuggestLines;
                PromotedCategory = Process;


                trigger OnAction()
                BEGIN
                    Rec.SETRANGE("Status", rec."Status"::Open);
                    Rec.SETRANGE("Withholding", TRUE);
                    ShowAllEntries := FALSE;
                END;


            }
        }


        //modify("OpenRequests")
        //{
        //
        //
        //}
        //

        //modify("AllRequests")
        //{
        //
        //
        //}
        //
    }

    //trigger
    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Approver ID", USERID);
        Rec.FILTERGROUP(0);
        Rec.SETRANGE("Status", rec."Status"::Open);

        //QB 10/05/20: - Por defecto no se ven las retenidas
        Rec.SETRANGE("Withholding", FALSE);
        //Lipiar el FactBox de datos del documento
        CurrPage.QB_ApprovalsFactBox.PAGE.ClearData;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetDateStyle;

        //CPA 16/03/22: - QB 1.10.27 (Q16730 Roig) Agregar una columna con el n£mero y nombre del proveedor en las pantallas de aprobaciones.
        ApprovalMgmt.GetCustVendFromRecRef(Rec."Record ID to Approve", CustVendNo, CustVendName);

        //+18218
        JobDescription := '';
        IF Job.GET(Rec."Job No.") THEN
            JobDescription := Job.Description;

        BudgetItemDescription := '';
        IF DataPieceworkForProduction.GET(Rec."Job No.", Rec."QB_Piecework No.") THEN
            BudgetItemDescription := DataPieceworkForProduction.Description;
        //-18218
    END;

    trigger OnAfterGetCurrRecord()
    VAR
        RecRef: RecordRef;
    BEGIN
        ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowCommentFactbox := CurrPage.CommentsFactBox.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowRecCommentsEnabled := RecRef.GET(rec."Record ID to Approve");

        //QB - Abrir el FactBox del archivo del documento
        GetDocument(FALSE);
    END;


    //trigger

    var
        DateStyle: Text;
        ShowAllEntries: Boolean;
        ShowChangeFactBox: Boolean;
        ShowRecCommentsEnabled: Boolean;
        ShowCommentFactbox: Boolean;
        "--------------------------------- QB": Integer;
        vDocumento: Boolean;
        seeWithHolding: Boolean;
        CarteraDoc: Record 7000002;
        CustVendNo: Text;
        CustVendName: Text;
        ApprovalMgmt: Codeunit 7207354;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        JobDescription: Text[50];
        BudgetItemDescription: Text;




    // procedure
    Local procedure SetDateStyle();
    begin
        DateStyle := '';
        if (rec.IsOverdue) then
            DateStyle := 'Attention';
    end;

    LOCAL procedure "---------------------- QB"();
    begin
    end;

    LOCAL procedure GetDocument(pVer: Boolean): Boolean;
    var
        CarteraDoc: Record 7000002;
        recref: RecordRef;
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
        PostedPurchaseInvoice: Page 138;
        PurchaseInvoice: Page 51;
        QBPrepayment: Record 7206928;
        QBJobPrepaymentCard: Page 7207032;
        SalesHeader: Record 36;
        SalesInvHeader: Record 112;
        PostedSalesInvoice: Page 132;
        SalesInvoice: Page 43;
        PurchaseCreditMemo: Page 52;
    begin
        //JAV 19/04/22: - QB 1.10.36 Por defecto no es visible el bot¢n de Ver Documento
        vDocumento := FALSE;

        if (recref.GET(rec."Record ID to Approve")) then begin
            CASE rec."QB Document Type" OF
                rec."QB Document Type"::PurchaseInvoice:
                    begin
                        recref.SETTABLE(PurchaseHeader);
                        //JAV 09/06/22: - QB 1.10.49 Usaba la variable PurchInvHeader en lugar de PurchaseHeader
                        //CPA 04/11/22 Q18099.begin
                        //if ( (PurchaseHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No."))  )then begin
                        //CPA 04/11/22 Q18099.end
                        if ((pVer)) then begin
                            CLEAR(PostedPurchaseInvoice);
                            PurchaseInvoice.SETRECORD(PurchaseHeader);
                            PurchaseInvoice.RUNMODAL;
                        end ELSE begin
                            vDocumento := TRUE;
                            seeWithHolding := TRUE;
                            CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(PurchaseHeader);
                            CurrPage.IncomingDocAttachFactBox.PAGE.SendUpdate;
                        end;
                        //CPA 04/11/22 Q18099.begin
                        //end;
                        //CPA 04/11/22 Q18099.end
                    end;
                rec."QB Document Type"::Payment, rec."QB Document Type"::PaymentDueCert:
                    begin
                        recref.SETTABLE(CarteraDoc);
                        if ((PurchInvHeader.GET(CarteraDoc."Document No."))) then begin
                            if ((pVer)) then begin
                                CLEAR(PostedPurchaseInvoice);
                                PostedPurchaseInvoice.SETRECORD(PurchInvHeader);
                                PostedPurchaseInvoice.RUNMODAL;
                            end ELSE begin
                                vDocumento := TRUE;
                                seeWithHolding := TRUE;
                                CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(PurchInvHeader);
                                CurrPage.IncomingDocAttachFactBox.PAGE.SendUpdate;
                            end;
                        end;
                    end;
                //JAV 19/04/22: - QB 1.10.36 A¤adimos ver los documentos de tipo anticipo
                rec."QB Document Type"::Prepayment:
                    begin
                        recref.SETTABLE(QBPrepayment);
                        if ((QBPrepayment.GET(QBPrepayment."Entry No."))) then begin
                            if ((pVer)) then begin
                                CLEAR(QBJobPrepaymentCard);
                                QBJobPrepaymentCard.SETRECORD(QBPrepayment);
                                QBJobPrepaymentCard.RUNMODAL;
                            end ELSE begin
                                vDocumento := TRUE;
                                seeWithHolding := TRUE;
                                CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(PurchInvHeader);
                                CurrPage.IncomingDocAttachFactBox.PAGE.SendUpdate;
                            end;
                        end;
                    end;

                //CPA 04/11/22 Q18099.begin
                rec."QB Document Type"::" ":
                    begin
                        CASE Rec."Table ID" OF
                            DATABASE::"Sales Header":
                                begin
                                    recref.SETTABLE(SalesHeader);
                                    if ((SalesHeader.GET(Rec."Document Type", Rec."Document No."))) then begin
                                        if ((pVer)) then begin
                                            CLEAR(PostedSalesInvoice);
                                            SalesInvoice.SETRECORD(SalesHeader);
                                            SalesInvoice.RUNMODAL;
                                        end ELSE begin
                                            vDocumento := TRUE;
                                            seeWithHolding := TRUE;
                                            CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(SalesHeader);
                                            CurrPage.IncomingDocAttachFactBox.PAGE.SendUpdate;
                                        end;
                                    end;
                                end;
                        end;
                    end;
                rec."QB Document Type"::PurchaseCredirMemo:
                    begin
                        recref.SETTABLE(PurchaseHeader);
                        //if ( (PurchaseHeader.GET(PurchaseHeader."Document Type", PurchaseHeader."No."))  )then begin
                        if ((pVer)) then begin
                            PurchaseCreditMemo.SETRECORD(PurchaseHeader);
                            PurchaseCreditMemo.RUNMODAL;
                        end ELSE begin
                            vDocumento := TRUE;
                            seeWithHolding := TRUE;
                            CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(PurchaseHeader);
                            CurrPage.IncomingDocAttachFactBox.PAGE.SendUpdate;
                        end;
                        //end;
                    end;
            //CPA 04/11/22 Q18099.end

            //TO-DO A¤adir otros documentos

            end;
        end;
    end;

    //procedure
}


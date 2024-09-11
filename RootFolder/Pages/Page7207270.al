page 7207270 "QB Worksheet Header"
{
    CaptionML = ENU = 'Work Sheet Header', ESP = 'Cab. partes de trabajo';
    SourceTable = 7207290;
    PopulateAllFields = true;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Sheet Type"; rec."Sheet Type")
                {


                    ; trigger OnValidate()
                    BEGIN
                        IF (rec."Sheet Type" <> xRec."Sheet Type") THEN
                            rec."No. Resource /Job" := '';

                        OnAfterGet;
                    END;

                    trigger OnControlAddIn(Index: Integer; Data: Text)
                    BEGIN
                        OnAfterGet;
                    END;


                }
                field("No. Resource /Job"; rec."No. Resource /Job")
                {

                    CaptionML = ENU = 'No. Resource', ESP = 'N� recurso';
                    CaptionClass = TipoOrigen;
                    Enabled = verCodigo;

                    ; trigger OnValidate()
                    BEGIN
                        OnAfterGet;
                    END;


                }
                field("Sheet Date"; rec."Sheet Date")
                {

                }
                field("Allocation Term"; rec."Allocation Term")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                }
                field("Approval Status"; rec."Approval Status")
                {

                }
                group("group32")
                {

                    CaptionML = ESP = 'Aprobaci�n';
                    field("QB Approval Circuit Code"; rec."QB Approval Circuit Code")
                    {

                        ToolTipML = ESP = 'Que circuito de aprobaci�n que se utilizar� para este documento';
                        Enabled = CanRequestApproval;
                    }
                    field("QBApprovalManagement.GetLastStatus(Rec.RECORDID, Approval Status)"; QBApprovalManagement.GetLastStatus(Rec.RECORDID, rec."Approval Status"))
                    {

                        CaptionML = ESP = 'Situaci�n';
                    }
                    field("QBApprovalManagement.GetLastDateTime(Rec.RECORDID)"; QBApprovalManagement.GetLastDateTime(Rec.RECORDID))
                    {

                        CaptionML = ESP = 'Ult.Acci�n';
                    }
                    field("QBApprovalManagement.GetLastComment(Rec.RECORDID)"; QBApprovalManagement.GetLastComment(Rec.RECORDID))
                    {

                        CaptionML = ESP = 'Ult.Comentario';
                    }

                }

            }
            part(LinDoc; 7207272)
            {
                SubPageLink = "Document No." = FIELD("No.");
                Visible = LinDocVisible;
                UpdatePropagation = Both;
            }
            group("Registro")
            {

                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension1CodeOnAfterV
                    END;


                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207505)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Sheet', ESP = '&Parte';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Sheet"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }

            }
            group("group5")
            {
                CaptionML = ENU = '&Actions', ESP = '&Aprobaciones';
                action("action3")
                {
                    CaptionML = ESP = 'Aprobaciones';
                    Image = Approvals;

                    trigger OnAction()
                    VAR
                        recApprovalEntry: Record 454;
                        ApprovalEntries: Page 658;
                    BEGIN
                        ApprovalEntries.Setfilters(DATABASE::"Worksheet Header qb", recApprovalEntry."QB Document Type"::PaymentDueCert, rec."No.");
                        ApprovalEntries.RUN;
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Send Approval Request', ESP = 'Enviar solicitud a&probaci�n';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    BEGIN
                        //IF WorkflowEventsQB.CheckWorksheetApprovalPossible(Rec) THEN
                        //  QBApprovalPublisher.OnSendWorksheetDocForApproval(Rec);
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Cancel Approval Request', ESP = '&Cancelar solicitud aprobaci�n';
                    Image = Reject;

                    trigger OnAction()
                    BEGIN
                        //QBApprovalPublisher.OnCancelWorksheetApprovalRequest(Rec);
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Release', ESP = 'Lanzar';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    VAR
                        ReleaseWorksheet: Codeunit 7207301;
                    BEGIN
                        //ReleaseWorksheet.PerformManualRelease(Rec);
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Open', ESP = 'Volver a abrir';
                    Image = ReOpen;

                    trigger OnAction()
                    VAR
                        ReleaseWorksheet: Codeunit 7207301;
                    BEGIN
                        //ReleaseWorksheet.PerformManualReopen(Rec);
                    END;


                }

            }
            group("<Action7001114>")
            {

                CaptionML = ENU = '&Line', ESP = 'Ficha';
                action("action8")
                {
                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Resource Card', ESP = 'Ficha Recurso';
                    Enabled = enResource;
                    Image = Resource;

                    trigger OnAction()
                    VAR
                        Resource: Record 156;
                        ResourceCard: Page 76;
                    BEGIN
                        IF rec."Sheet Type" = rec."Sheet Type"::"By Resource" THEN BEGIN
                            Resource.GET(rec."No. Resource /Job");

                            CLEAR(ResourceCard);
                            ResourceCard.SETRECORD(Resource);
                            ResourceCard.RUN;
                        END;
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = 'Job Card', ESP = 'Ficha Proyecto';
                    Enabled = enJob;
                    Image = Job;

                    trigger OnAction()
                    VAR
                        Job: Record 167;
                        OperativeJobsCard: Page 7207478;
                    BEGIN
                        IF rec."Sheet Type" = rec."Sheet Type"::"By Job" THEN BEGIN
                            Job.GET(rec."No. Resource /Job");

                            CLEAR(OperativeJobsCard);
                            OperativeJobsCard.SETRECORD(Job);
                            OperativeJobsCard.RUN;
                        END;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group15")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action10")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    Image = Post;

                    trigger OnAction()
                    BEGIN
                        //IF WorkflowEventsQB.PrePostApprovalCheckWorksheet(Rec) THEN
                        CODEUNIT.RUN(CODEUNIT::"Post Worksheet (Yes/No)", Rec);
                    END;


                }
                action("action11")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por &lotes';
                    Image = PostBatch;

                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Record by Document Lots", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }
            group("group18")
            {
                CaptionML = ENU = 'P&osting', ESP = 'Importar';
                action("action12")
                {
                    CaptionML = ESP = 'Importar Excel';
                    Image = ImportExcel;


                    trigger OnAction()
                    VAR
                        // ImportExcel: Report 7207441;
                    BEGIN
                        //JAV 18/10/19: - Nueva acci�n para importar desde Excel los datos
                        // CLEAR(ImportExcel);
                        // ImportExcel.SetFilters(Rec);
                        // ImportExcel.RUN;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
            }
            group(Category_Category4)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
            }
        }
    }






    trigger OnInit()
    BEGIN
        LinDocVisible := TRUE;
    END;

    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        IF Rec.FIND(Which) THEN
            EXIT(TRUE)
        ELSE BEGIN
            Rec.SETRANGE("No.");
            EXIT(Rec.FIND(Which));
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        OnAfterGet;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        HasGotSalesUserSetup: Boolean;
        UserRespCent: Code[20];
    BEGIN
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, rec."Responsibility Center");
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        OnAfterGet;
    END;



    var
        LinDocVisible: Boolean;
        FunctionQB: Codeunit 7207272;
        TipoOrigen: Text;
        verCodigo: Boolean;
        enResource: Boolean;
        enJob: Boolean;
        Txt000: TextConst ESP = 'Proyecto';
        Txt001: TextConst ESP = 'Recurso';
        Txt002: TextConst ESP = 'Mixto';
        "---------------------------------": Integer;
        QBApprovalManagement: Codeunit 7207354;
        CanRequestApproval: Boolean;



    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure OnAfterGet();
    begin
        CASE rec."Sheet Type" OF
            rec."Sheet Type"::"By Job":
                TipoOrigen := Txt000;
            rec."Sheet Type"::"By Resource":
                TipoOrigen := Txt001;
            rec."Sheet Type"::Mix:
                TipoOrigen := Txt002;
        end;
        verCodigo := (rec."Sheet Type" <> rec."Sheet Type"::Mix);
        CurrPage.LinDoc.PAGE.SetHeader(Rec);

        enResource := (rec."Sheet Type" = rec."Sheet Type"::"By Resource");
        enJob := (rec."Sheet Type" = rec."Sheet Type"::"By Job");
    end;

    // begin//end
}








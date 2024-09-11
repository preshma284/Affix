page 7207321 "Certification"
{
    CaptionML = ENU = 'Certification', ESP = 'Certificaci�n';
    SourceTable = 7207336;
    SourceTableView = SORTING("Document Type", "No.")
                    WHERE("Document Type" = CONST("Certification"));
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group16")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit() THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                group("group20")
                {

                    CaptionML = ENU = 'Customer', ESP = 'Cliente';
                    field("Customer No."; rec."Customer No.")
                    {

                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field("Name"; rec."Name")
                    {

                    }
                    field("Address"; rec."Address")
                    {

                        Importance = Additional;
                    }
                    field("City"; rec."City")
                    {

                        Importance = Additional;
                    }

                }
                group("group25")
                {

                    CaptionML = ENU = 'Certification', ESP = 'Certificaci�n';
                    field("No. Measure"; rec."No. Measure")
                    {

                        CaptionML = ENU = 'No. Measure', ESP = 'N� de certificaci�n';
                    }
                    field("Text Measure"; rec."Text Measure")
                    {

                        CaptionML = ENU = 'Text Measure', ESP = 'Texto Certificaci�n';
                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field("Certification Date"; rec."Certification Date")
                    {

                        ToolTipML = ESP = 'Hasta que fecha se ha efectuado la certificaci�n (la certificaci�n es desde el inicio de la obra hasta esta fecha)';
                    }
                    field("Send Date"; rec."Send Date")
                    {

                        ToolTipML = ESP = 'En que fecha se ha entregado al cliente';
                    }
                    field("Posting Date"; rec."Posting Date")
                    {

                        ToolTipML = ESP = 'En que fecha se cargar� en el proyecto';
                    }
                    field("Cancel No."; rec."Cancel No.")
                    {

                    }
                    field("Certification Type"; rec."Certification Type")
                    {

                        Visible = seeRED;

                        ; trigger OnValidate()
                        BEGIN
                            //++SR.001
                            FunRedetEditable;
                            //--SR.001
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Redetermination Code"; rec."Redetermination Code")
                    {

                        Importance = Additional;
                        Visible = seeRED;
                        Editable = booRedetEditable;
                    }

                }
                group("group34")
                {

                    CaptionML = ENU = 'Registry', ESP = 'Registro';
                    field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                    {

                        Importance = Additional;

                        ; trigger OnValidate()
                        BEGIN
                            ShortcutDimension1CodeOnAfterV;
                        END;


                    }
                    field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                    {

                        Importance = Additional;

                        ; trigger OnValidate()
                        BEGIN
                            ShortcutDimension2CodeOnAfterV;
                        END;


                    }
                    field("Currency Code"; rec."Currency Code")
                    {

                        Visible = FALSE;
                    }
                    field("Currency Factor"; rec."Currency Factor")
                    {

                        Importance = Additional;
                        Visible = FALSE;
                    }

                }

            }
            part(LinDoc;7207322)
            {
                SubPageLink="Document No."=FIELD("No.");
                UpdatePropagation=Both;
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207498)
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
                CaptionML = ENU = '&Certification', ESP = '&Certificaci�n';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Job';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("Page Quobuilding Comment WorkSheet")
                {

                    CaptionML = ENU = 'Comments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Certification"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group7")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("Codeunit Post certification  (y/n)")
                {

                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'Post', ESP = 'Registrar';
                    RunObject = Codeunit 7207279;
                    Image = Post;
                }
                action("action5")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por lotes';
                    Image = PostBatch;

                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Post. by Measurement Batch", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }
            action("action6")
            {
                Ellipsis = true;
                CaptionML = ENU = 'Print', ESP = '&Imprimir';
                Image = Print;

                trigger OnAction()
                VAR
                    MeasurementHeader: Record 7207336;
                    QBReportSelections: Record 7206901;
                BEGIN
                    //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                    MeasurementHeader.RESET;
                    MeasurementHeader.SETRANGE("No.", rec."No.");
                    QBReportSelections.Print(QBReportSelections.Usage::J6, MeasurementHeader);
                END;


            }
            action("BC3")
            {

                CaptionML = ENU = 'Crear BC3';
                Image = FiledOverview;

                trigger OnAction()
                VAR
                    // ExportaciónCertificaciónBC3: Report 7207463;
                BEGIN
                    // ExportaciónCertificaciónBC3.Parameters(0, rec."No.");
                    // ExportaciónCertificaciónBC3.RUNMODAL;
                END;


            }
            action("action8")
            {
                Ellipsis = true;
                CaptionML = ENU = 'Print', ESP = '&Imprimir Cert';
                Image = Print;

                trigger OnAction()
                VAR
                    MeasurementHeader: Record 7207336;
                    QBReportSelections: Record 7206901;
                BEGIN
                    MeasurementHeader.RESET;
                    MeasurementHeader.SETRANGE("No.", rec."No.");

                    //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                    //CLEAR(rptCertification);
                    //rptCertification.SETTABLEVIEW(MeasurementHeader);
                    //rptCertification.RUNMODAL;
                    //QBReportSelections.Print(QBReportSelections.Usage::J6, MeasurementHeader);
                    REPORT.RUNMODAL(7207464, TRUE, FALSE, MeasurementHeader);
                END;


            }
            group("group13")
            {
                CaptionML = ENU = 'Customers', ESP = 'Multi-cliente';
                action("JobCustomers")
                {

                    CaptionML = ENU = 'Customers', ESP = 'Clientes';
                    Image = CustomerGroup;


                    trigger OnAction()
                    VAR
                        QBJobCustomers: Record 7207272;
                        QBJobCustomersList: Page 7207295;
                        Txt001: TextConst ESP = 'Esta opci�n solo es v�lida para proyectos multicliente por porcentajes';
                        mJob: Record 167;
                    BEGIN
                        //Facturaci�n a varios clientes
                        mJob.GET(rec."Job No.");
                        IF (mJob."Multi-Client Job" <> mJob."Multi-Client Job"::ByPercentages) THEN
                            ERROR(Txt001);

                        QBJobCustomers.RESET;
                        QBJobCustomers.SETRANGE("Job no.", rec."Job No.");

                        CLEAR(QBJobCustomersList);
                        QBJobCustomersList.SETTABLEVIEW(QBJobCustomers);
                        QBJobCustomersList.RUNMODAL;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(BC3_Promoted; BC3)
                {
                }
                actionref("Codeunit Post certification  (y/n)_Promoted"; "Codeunit Post certification  (y/n)")
                {
                }
                actionref(JobCustomers_Promoted; JobCustomers)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);
        //JAV 25/05/21: - QB 1.08.45 Solo se filtra si no hay un proyecto por defecto
        IF (rec."Job No." = '') THEN
            FunctionQB.SetUserJobMeasurementHeaderFilter(Rec);

        RedetEditable := FALSE;
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
        FunRedetEditable;
        Rec.FILTERGROUP(2);
        JobFilter := Rec.GETFILTER("Job No.");
        IF (JobFilter = '') THEN
            FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        Rec.FILTERGROUP(0);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        rec."Document Type" := rec."Document Type"::Certification;
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    BEGIN
        Rec.FILTERGROUP(2);
        JobFilter := Rec.GETFILTER("Job No.");
        IF (JobFilter = '') THEN
            FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter)
        ELSE IF (STRLEN(JobFilter) <= MAXSTRLEN(Job."No.")) THEN BEGIN
            IF (Job.GET(JobFilter)) THEN
                Rec.VALIDATE("Job No.", Job."No.");
        END;
        Rec.FILTERGROUP(0);
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(TRUE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        FunRedetEditable;
    END;



    var
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        RedetEditable: Boolean;
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
        booRedetEditable: Boolean;
        JobFilter: Text;
        seeRED: Boolean;

    LOCAL procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    procedure FunRedetEditable();
    begin
        if rec."Certification Type" = rec."Certification Type"::"Price adjustment" then
            RedetEditable := TRUE
        ELSE
            RedetEditable := FALSE
    end;

    // begin
    /*{
      JAV 26/03/19: - Se a�ade el campo "No. Measure"
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
      JAV 25/05/21: - QB 1.08.45 Se ponen los filtros correctamente al abrir la pantalla, en el OnAfterGetRecord y en el OnInsertRecord
      JAV 15/09/21: - QB 1.09.18 Se hace no visible el campo rec."Redetermination Code"
      AML 14/06/23: - Q18345 Enlace para hacer BC3
    }*///end
}








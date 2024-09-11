page 7207336 "Post. Certifications List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = '"Post. Certifications" List', ESP = 'Lista hist�rico certificaciones';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207341;
    PageType = List;
    CardPageID = "Post. Certifications";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Certification Type"; rec."Certification Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Certification Date"; rec."Certification Date")
                {

                    CaptionML = ENU = 'Measurement Date', ESP = 'Fecha Certificaci�n';
                }
                field("No. Measure"; rec."No. Measure")
                {

                    CaptionML = ENU = 'No. de certificacion', ESP = 'N� de certificaci�n';
                }
                field("Text Measure"; rec."Text Measure")
                {

                    CaptionML = ENU = 'Text Measure', ESP = 'Texto Certificaci�n';
                }
                field("Amount Document"; rec."Amount Document")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }
                field("Comment"; rec."Comment")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Invoiced Certification"; rec."Invoiced Certification")
                {

                }
                field("Last Measure"; rec."Last Measure")
                {

                }
                field("Validated Measurement"; rec."Validated Measurement")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Measure Type"; rec."Measure Type")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207494)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
                UpdatePropagation = Both;
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Certificaci�n', ESP = '&Certificaci�n';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207305;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action2")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = '&Imprimir';
                Visible = false;
                Image = Print;

                trigger OnAction()
                BEGIN
                    //CurrForm.SETSELECTIONFILTER(PurchInvHeader);
                    //PurchInvHeader.PrintRecords(TRUE);

                    // CLEAR(CompleteCertification);
                    PostCertifications.RESET;
                    PostCertifications.SETRANGE("No.", rec."No.");
                    // CompleteCertification.SETTABLEVIEW(PostCertifications);
                    // CompleteCertification.RUNMODAL;
                END;


            }
            action("action3")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }
            action("action4")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = 'Imprimir';
                Image = Print;

                trigger OnAction()
                VAR
                    QBReportSelections: Record 7206901;
                BEGIN
                    PostCertifications.RESET;
                    PostCertifications.SETRANGE("No.", rec."No.");
                    PostCertifications.SETRANGE("Job No.", rec."Job No.");

                    //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                    //CLEAR(RpCertf);
                    //RpCertf.SETTABLEVIEW(PostCertifications);
                    //RpCertf.RUNMODAL;
                    QBReportSelections.Print(QBReportSelections.Usage::J7, PostCertifications);
                END;


            }
            action("action5")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = 'Imprimir Cert';
                Image = Print;

                trigger OnAction()
                VAR
                    QBReportSelections: Record 7206901;
                BEGIN
                    PostCertifications.RESET;
                    PostCertifications.SETRANGE("No.", rec."No.");
                    PostCertifications.SETRANGE("Job No.", rec."Job No.");

                    //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                    //CLEAR(RpCertf);
                    //RpCertf.SETTABLEVIEW(PostCertifications);
                    //RpCertf.RUNMODAL;
                    //QBReportSelections.Print(QBReportSelections.Usage::J7, PostCertifications);
                    REPORT.RUNMODAL(7207465, TRUE, FALSE, PostCertifications);
                END;


            }
            action("Cancel Certification")
            {

                CaptionML = ENU = 'Cancel Certification', ESP = 'Cancelar certificaci�n';
                Image = Cancel;

                trigger OnAction()
                VAR
                    QBMeasurements: Codeunit 7207274;
                BEGIN
                    //JAV 22/03/19: - Nueva acci�n para cancelar una medici�n registrada
                    QBMeasurements.PostCertificationsCancel(Rec);
                END;


            }
            group("group10")
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
                action("CreateInvoices")
                {

                    CaptionML = ESP = 'Crear Facturas';
                    Image = CreateJobSalesInvoice;

                    trigger OnAction()
                    VAR
                        cuPostCertification: Codeunit 7207278;
                    BEGIN
                        cuPostCertification.CreateInvoices(Rec, TRUE);
                    END;


                }
                action("SeeInvoices")
                {

                    CaptionML = ESP = 'Ver Facturas';
                    Image = JobSalesInvoice;

                    trigger OnAction()
                    VAR
                        SalesHeader: Record 36;
                        SalesInvoiceList: Page 9301;
                    BEGIN
                        SalesHeader.RESET;
                        SalesHeader.SETRANGE("QB Certification code", rec."No.");

                        CLEAR(SalesInvoiceList);
                        SalesInvoiceList.SETTABLEVIEW(SalesHeader);
                        SalesInvoiceList.RUNMODAL;
                    END;


                }
                action("SeePostedInvoices")
                {

                    CaptionML = ESP = 'Ver Fact. Reg.';
                    Image = PostedTaxInvoice;


                    trigger OnAction()
                    VAR
                        SalesInvoiceHeader: Record 112;
                        PostedSalesInvoices: Page 143;
                    BEGIN
                        SalesInvoiceHeader.RESET;
                        SalesInvoiceHeader.SETRANGE("Certification code", rec."No.");

                        CLEAR(PostedSalesInvoices);
                        PostedSalesInvoices.SETTABLEVIEW(SalesInvoiceHeader);
                        PostedSalesInvoices.RUNMODAL;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
            group(Category_Report)
            {
                actionref(CreateInvoices_Promoted; CreateInvoices)
                {
                }
                actionref(SeeInvoices_Promoted; SeeInvoices)
                {
                }
                actionref(SeePostedInvoices_Promoted; SeePostedInvoices)
                {
                }
                actionref(JobCustomers_Promoted; JobCustomers)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.ResponsabilityFilter(Rec);
    END;



    var
        // CompleteCertification: Report 7207300;
        PostCertifications: Record 7207341;
        // RpCertf: Report 7207410;
        // FormatoCertificacion: Report 7207408;

    procedure SeleccHistCert(var PostCertificationHeader: Record 7207341);
    begin
        CurrPage.SETSELECTIONFILTER(PostCertificationHeader);
    end;

    // begin
    /*{
      JAV 05/03/19: - Se a�aden los botones de impresi�n de las certificaciones resumida y completa
      JAV 08/04/19: - Se a�ade el factbox de totales del certificado para ver los importes del mismo
      JAV 11/04/19: - Se quita el report "Imprimir" que no saca nada
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector y se unifica resumido y completo
    }*///end
}









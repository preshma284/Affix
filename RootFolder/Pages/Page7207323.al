page 7207323 "Post. Certifications"
{
    Editable = false;
    CaptionML = ENU = 'Post. Certifications', ESP = 'Hist. Certificaciones';
    InsertAllowed = false;
    SourceTable = 7207341;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group20")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Editable = FALSE;
                    Style = Standard;
                    StyleExpr = TRUE;
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

                }
                field("No. Measure"; rec."No. Measure")
                {

                    CaptionML = ENU = 'No. Measure', ESP = 'N� de Certificaci�n';
                }
                field("Text Measure"; rec."Text Measure")
                {

                    CaptionML = ENU = 'Text Measure', ESP = 'Texto Certificaci�n';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Invoiced Certification"; rec."Invoiced Certification")
                {

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
                field("Cancel By"; rec."Cancel By")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    Visible = FALSE;
                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207494)
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
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Certification', ESP = 'General';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Certi. Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }
            group("group5")
            {
                CaptionML = ESP = 'Certificaci�n';
                // ActionContainerType =ActionItems ;
                action("action3")
                {
                    Ellipsis = true;
                    CaptionML = ENU = '&Print', ESP = '&Imprimir';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Print;
                    PromotedCategory = Process;

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
                action("action4")
                {
                    Ellipsis = true;
                    CaptionML = ENU = '&Print', ESP = 'Imprimir Cert';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Print;
                    PromotedCategory = Process;

                    trigger OnAction()
                    VAR
                        QBReportSelections: Record 7206901;
                    BEGIN
                        PostCertifications.RESET;
                        PostCertifications.SETRANGE("No.",rec. "No.");
                        PostCertifications.SETRANGE("Job No.", rec."Job No.");

                        //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                        //CLEAR(RpCertf);
                        //RpCertf.SETTABLEVIEW(PostCertifications);
                        //RpCertf.RUNMODAL;
                        //QBReportSelections.Print(QBReportSelections.Usage::J7, PostCertifications);
                        REPORT.RUNMODAL(7207465, TRUE, FALSE, PostCertifications);
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                    Promoted = true;
                    Image = Navigate;
                    PromotedCategory = Process;

                    trigger OnAction()
                    BEGIN
                        rec.Navigate;
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

            }
            group("group10")
            {
                CaptionML = ENU = 'Customers', ESP = 'Multi-cliente';
                action("JobCustomers")
                {

                    CaptionML = ENU = 'Customers', ESP = 'Clientes';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = CustomerGroup;
                    PromotedCategory = Report;

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
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = CreateJobSalesInvoice;
                    PromotedCategory = Report;

                    trigger OnAction()
                    BEGIN
                        cuPostCertification.CreateInvoices(Rec, FALSE);
                    END;


                }
                action("SeeInvoices")
                {

                    CaptionML = ESP = 'Ver Facturas';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = JobSalesInvoice;
                    PromotedCategory = Report;

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
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = PostedTaxInvoice;
                    PromotedCategory = Report;

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
            group("group15")
            {
                CaptionML = ESP = 'Admin';
                // ActionContainerType =ActionItems ;
                action("action11")
                {
                    CaptionML = ESP = 'Marcar Facturada';
                    Visible = seeMark;
                    Image = CancelLine;

                    trigger OnAction()
                    VAR
                        PostCertification: Codeunit 7207278;
                    BEGIN
                        //JAV 13/10/20: - QB 1.06.20 Nueva acci�n para marcar la certificaci�n como facturada, solo para administradores
                        IF (CONFIRM('�Desea cambiar la marca de facturado a %1?', FALSE, NOT rec."Invoiced Certification")) THEN
                            PostCertification.MarkInvoiced(Rec, NOT Rec."Invoiced Certification");
                    END;


                }
                action("action12")
                {
                    CaptionML = ESP = 'Eliminar';
                    Visible = seeAdmin;
                    Image = Delete;

                    trigger OnAction()
                    VAR
                        PostCertificationsLines: Record 7207342;
                    BEGIN
                        //JAV 13/10/20: - QB 1.06.20 Nueva acci�n para borrar completamente la certificaci�n, solo para administradores de QB
                        IF (CONFIRM('Va a eliminar la certificaci�n %1 sin posibilidad de volver a recuperarla. �Seguro?', FALSE, Rec."No.")) THEN
                            Rec.DELETE(TRUE);
                    END;


                }
                action("action13")
                {
                    CaptionML = ESP = 'Recalcular';
                    Visible = seeAdmin;
                    Image = CalculateLines;


                    trigger OnAction()
                    VAR
                        HistCertificationLines: Record 7207342;
                    BEGIN
                        //JAV 09/02/22: - QB 1.10.19 Se a�ade un bot�n para recalcular importes PEC, solo para personal de CEI
                        IF (CONFIRM('�Desea recalcular los importes de la certificaci�n %1?', TRUE, Rec."No.")) THEN BEGIN
                            HistCertificationLines.RESET;
                            HistCertificationLines.SETRANGE("Document No.", Rec."No.");
                            IF (HistCertificationLines.FINDSET(TRUE)) THEN
                                REPEAT
                                    HistCertificationLines."Cert Term PEC amount" := ROUND(HistCertificationLines."Cert Quantity to Term" * HistCertificationLines."Contract Price", 0.01);
                                    HistCertificationLines."Cert Source PEC amount" := ROUND(HistCertificationLines."Cert Quantity to Origin" * HistCertificationLines."Contract Price", 0.01);
                                    HistCertificationLines.MODIFY;
                                UNTIL (HistCertificationLines.NEXT = 0);
                        END;
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    VAR
        UserSetup: Record 91;
    BEGIN
        rec.ResponsabilityFilter(Rec);
        FunctionQB.SetUserJobPostCertificationsFilter(Rec);

        //JAV 13/10/20: - QB 1.06.20 Si es administrador de QB, podr� ver ciertos botones
        seeMark := FALSE;
        IF UserSetup.GET(USERID) THEN
            seeMark := UserSetup."Mark Certifications Invoiced";

        IF (FunctionQB.IsQBAdmin) THEN BEGIN
            seeAdmin := TRUE;
            seeMark := TRUE;
        END;
    END;



    var
        PostCertifications: Record 7207341;
        FunctionQB: Codeunit 7207272;
        // RpCertf: Report 7207410;
        // FormatoCertificacion: Report 7207408;
        cuPostCertification: Codeunit 7207278;
        seeAdmin: Boolean;
        txt000: TextConst ESP = 'Ya Facturada';
        seeMark: Boolean;/*

    begin
    {
      PGM 15/01/18: - QBV005 Se ha creado una accion para imprimir el resumen de certificaciones.
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector y se unifica resumido y completo
      JAV 15/10/19: - Se eliminan los campos 47 "Certification No." y 48 rec."Certification Date", se usan en su lugar "No. Measure" y "Measurement Date"
      JAV 13/10/20: - QB 1.06.20 Nueva acci�n para marcar la certificaci�n como facturada, solo para administradores de QB
                    - QB 1.06.20 Nueva acci�n para borrar completamente la certificaci�n, solo para administradores de QB
      JAV 09/02/22: - QB 1.10.19 Se a�ade un bot�on para recalcular importes PEC, solo para personal de CEI
    }
    end.*/


}








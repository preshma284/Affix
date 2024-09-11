page 7207482 "Certification List"
{
  ApplicationArea=All;

    CaptionML = ENU = '"Certification" List', ESP = 'Lista certificaci�n';
    SourceTable = 7207336;
    SourceTableView = WHERE("Document Type" = CONST("Certification"));
    PageType = List;
    CardPageID = "Certification";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                Editable = FALSE;
                field("No."; rec."No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Text Measure"; rec."Text Measure")
                {

                    CaptionML = ENU = 'Text Measure', ESP = 'Texto Certificaci�n';
                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Measurement Date"; rec."Measurement Date")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207498)
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
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunPageOnRec = true;
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        CASE rec."Document Type" OF
                            rec."Document Type"::Measuring:
                                PAGE.RUN(PAGE::Measurement, Rec);
                            rec."Document Type"::Certification:
                                PAGE.RUN(PAGE::Certification, Rec);
                        END;
                    END;


                }

            }

        }
        area(Processing)
        {

            action("action2")
            {
                Ellipsis = true;
                CaptionML = ENU = 'Print', ESP = '&Imprimir';
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
                    QBReportSelections.Print(QBReportSelections.Usage::J6, MeasurementHeader);
                END;


            }
            action("action3")
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
            group("group7")
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
                actionref(JobCustomers_Promoted; JobCustomers)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);
    END;



    var
        MeasurementHeader: Record 7207336;
        // BorradorCertificacion: Report 7207422;
        /*

    begin
    {
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
      JAV 15/10/19: - Se cambia el campo "Posting Description" quese elimina  por el rec."Text Measure" que da mejor informaci�n
    }
    end.*/


}









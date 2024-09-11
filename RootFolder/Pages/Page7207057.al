page 7207057 "QB Post. Service Order"
{
    Editable = false;
    CaptionML = ENU = 'Post. Service Order', ESP = 'Pedido servicio registrado.';
    InsertAllowed = false;
    SourceTable = 7206968;
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

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Job Description"; rec."Job Description")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Name"; rec."Name")
                {

                }
                field("Address"; rec."Address")
                {

                }
                field("Contract No."; rec."Contract No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Service Date"; rec."Service Date")
                {

                    CaptionML = ENU = 'Service Date', ESP = 'Fecha servicio';
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Service Order Type"; rec."Service Order Type")
                {

                }
                field("Grouping Criteria"; rec."Grouping Criteria")
                {

                }
                field("Total Cost"; rec."Total Cost")
                {

                }
                field("Base"; rec."Base")
                {

                }
                group("group24")
                {

                    CaptionML = ESP = 'Facturas generadas';
                    field("Pre-Assigned Invoice No."; rec."Pre-Assigned Invoice No.")
                    {

                    }
                    field("Posted Invoice No."; rec."Posted Invoice No.")
                    {

                    }

                }
                group("group27")
                {

                    CaptionML = ENU = 'Operation Result', ESP = 'Resultado operaci�n';
                    field("OperationResult"; "OperationResult")
                    {

                        ToolTipML = ENU = 'Specifies the products or service being offered.', ESP = 'Especifica los productos o servicios que se ofrecen.';
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        MultiLine = true;


                        ShowCaption = false;
                        trigger OnValidate()
                        BEGIN
                            rec.SetOperationResult(OperationResult);
                            CurrPage.UPDATE(TRUE);
                        END;


                    }

                }

            }

        }
        area(FactBoxes)
        {
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
                CaptionML = ENU = '&Document', ESP = 'Documento';
                action("seeInvoice")
                {

                    CaptionML = ENU = 'See Invoice', ESP = 'Ver Factura';
                    Enabled = enInvoice;
                    Image = Invoice;

                    trigger OnAction()
                    VAR
                        SalesHeader: Record 36;
                        SalesInvoiceHeader: Record 112;
                        pSalesInvoice: Page 43;
                        pPostedSalesInvoice: Page 132;
                    BEGIN
                        IF (SalesHeader.GET(SalesHeader."Document Type"::Invoice, Rec."Pre-Assigned Invoice No.")) THEN BEGIN
                            CLEAR(pSalesInvoice);
                            pSalesInvoice.SETRECORD(SalesHeader);
                            pSalesInvoice.RUNMODAL;
                        END ELSE IF (SalesInvoiceHeader.GET(Rec."Posted Invoice No.")) THEN BEGIN
                            CLEAR(pPostedSalesInvoice);
                            pPostedSalesInvoice.SETRECORD(SalesInvoiceHeader);
                            pPostedSalesInvoice.RUNMODAL;
                        END;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure Hist."), "No." = FIELD("No.");
                    Visible = false;
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                    Image = Navigate;


                    trigger OnAction()
                    BEGIN
                        rec.Navigate;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(seeInvoice_Promoted; seeInvoice)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);
        /*{SE COMENTA. NO EXISTE LA FUNCION FilterLevel
        UserMgt.FilterLevel(codeFilterLevel);
        Rec.FILTERGROUP(2);
        Rec.SETFILTER("Access Level",codeFilterLevel);
        Rec.FILTERGROUP(0);
        }*/
    END;

    trigger OnAfterGetRecord()
    BEGIN
        OperationResult := Rec.GetOperationResult;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        enInvoice := (rec."Pre-Assigned Invoice No." <> '') OR (rec."Posted Invoice No." <> '');
    END;



    var
        UserMgt: Codeunit 5700;
        codeFilterLevel: Code[250];
        OperationResult: Text;
        enInvoice: Boolean;

    /*begin
    end.
  
*/
}








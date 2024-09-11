page 7207051 "QB Service Order"
{
    CaptionML = ENU = 'Service Order', ESP = 'Pedido servicio';
    SourceTable = 7206966;
    DataCaptionExpression = DataCaption;
    SourceTableView = SORTING("No.")
                    WHERE("Status" = FILTER(<> Finished & <> Invoiced));
    DataCaptionFields = "Job Description";
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
                field("Job No."; rec."Job No.")
                {

                }
                field("Job Description"; rec."Job Description")
                {

                }
                field("Customer No."; rec."Customer No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        NoCustomerOnAfterValidate;
                    END;


                }
                field("Name"; rec."Name")
                {

                }
                field("Address"; rec."Address")
                {

                }
                field("City"; rec."City")
                {

                }
                field("Post Code"; rec."Post Code")
                {

                }
                field("County"; rec."County")
                {

                }
                field("Contract No."; rec."Contract No.")
                {

                }
                field("Service Date"; rec."Service Date")
                {

                    CaptionML = ENU = 'Service Date', ESP = 'Fecha servicio';
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Invoicing Date"; rec."Invoicing Date")
                {

                }
                field("Ext order service"; rec."Ext order service")
                {

                }
                field("Text Ext order service"; rec."Text Ext order service")
                {

                }
                group("group37")
                {

                    CaptionML = ESP = 'Importes';
                    field("Total Cost"; rec."Total Cost")
                    {

                        Editable = false;
                    }
                    field("Total Sale"; rec."Total Sale")
                    {

                        Editable = false;
                    }

                }
                group("group40")
                {

                    CaptionML = ESP = 'Datos del pedido';
                    field("Expenses/Investment"; rec."Expenses/Investment")
                    {

                    }
                    field("Service Order Type"; rec."Service Order Type")
                    {

                    }
                    field("Initial Order Type"; rec."Initial Order Type")
                    {

                    }
                    field("Final Order Type"; rec."Final Order Type")
                    {

                    }
                    field("Grouping Criteria"; rec."Grouping Criteria")
                    {

                    }
                    field("Ship-to Address"; rec."Ship-to Address")
                    {

                        ToolTipML = ENU = 'Specifies the address that the items are shipped to.', ESP = 'Especifica la direcci�n donde se env�an los productos.';
                        ApplicationArea = Service;
                    }
                    field("Ship-to City"; rec."Ship-to City")
                    {

                        ToolTipML = ENU = 'Specifies the city of the address that the items are shipped to.', ESP = 'Especifica la ciudad de la direcci�n de la ubicaci�n a la que se env�an los productos.';
                        ApplicationArea = Service;
                    }
                    field("Status"; rec."Status")
                    {

                        Editable = FALSE;
                    }

                }
                group("PriceReview")
                {

                    CaptionML = ENU = 'Price review', ESP = 'Revisi�n precios';
                    field("Price review"; rec."Price review")
                    {

                    }
                    field("Price review code"; rec."Price review code")
                    {

                        Editable = FALSE;
                    }
                    field("Price review percentage"; rec."Price review percentage")
                    {

                        Editable = FALSE;
                    }

                }
                group("group53")
                {

                    CaptionML = ENU = 'Operation Result', ESP = 'Resultado operaci�n';
                    field("OperationResult"; OperationResult)
                    {

                        ToolTipML = ENU = 'Specifies the products or service being offered.', ESP = 'Especifica los productos o servicios que se ofrecen.';
                        ApplicationArea = Basic, Suite;
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
            part(LinDoc; 7207052)
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Registro")
            {

                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension1CodeOnAfterV;
                    END;


                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension2CodeOnAfterV;
                    END;


                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }

            }
            group("Roturas")
            {

                CaptionML = ENU = 'Failiures', ESP = 'Roturas';
                field("Failure Caused By"; rec."Failure Caused By")
                {

                    MultiLine = true;
                }
                field("Failiure Company"; rec."Failiure Company")
                {

                }
                field("Failiure Phone No."; rec."Failiure Phone No.")
                {

                }
                field("Company Failure Maker"; rec."Company Failure Maker")
                {

                }
                field("Failiure Address"; rec."Failiure Address")
                {

                }
                field("Working Company"; rec."Working Company")
                {

                }
                field("Instaled Service"; rec."Instaled Service")
                {

                }
                field("Failiure Cause"; rec."Failiure Cause")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207056)
            {

                CaptionML = ENU = 'Service Order Statistics', ESP = 'Estad�stica Pedido Servicio';
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
                CaptionML = ENU = '&Document', ESP = '&Medici�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207309;
                    // RunPageLink = "No. Measurement" = FIELD("No.");
                    Visible = false;
                    Image = Statistics;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Job', ESP = 'Proyecto';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure"), "No." = FIELD("No.");
                    Visible = false;
                    Image = ViewComments;
                }
                action("action4")
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

            group("group8")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("Copiar")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Copy Lines', ESP = 'Copiar l�neas';
                    Visible = false;
                    Image = CopyToTask;

                    trigger OnAction()
                    VAR
                        // copyLinesMeasurement: Report 7207278;
                    BEGIN
                        //SE COMENTA. preguntar

                        // copyLinesMeasurement.SetDoc(Rec);
                        // copyLinesMeasurement.RUNMODAL;
                        // CLEAR(copyLinesMeasurement);

                    END;


                }
                action("Proponer")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Suggest Cost Database Piecework', ESP = 'Propo&ner U.O. del preciario de venta';
                    Visible = false;
                    Image = Reconcile;

                    trigger OnAction()
                    VAR
                        // SuggestCostDatabasePiecework: Report 7207279;
                    BEGIN
                        //SE COMENTA. preguntar

                        // SuggestCostDatabasePiecework.SetParameters(Rec);
                        // SuggestCostDatabasePiecework.RUNMODAL;
                        // CLEAR(SuggestCostDatabasePiecework);

                    END;


                }
                action("Estado")
                {

                    CaptionML = ENU = 'Status change', ESP = 'Cambio estado';
                    Image = Change;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(Rec);
                        PAGE.RUNMODAL(PAGE::"QB Change Status Order Serv", Rec);
                        CurrPage.UPDATE(TRUE);
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'Service Order Log.', ESP = 'Log. pedidos servicios';
                    RunObject = Page 7206966;
                    Visible = false;
                    trigger OnAction()
                    begin
                        /*{
                                 EN PROPIEDADES
                                 PropertyValue
                                 RunObjectPage 50023
                                 RunPageViewSORTING(No.,Service Order No.)
                                 RunPageLinkService Order No.=FIELD(No.)
                                 }*/
                    END;



                }
                action("action9")
                {
                    CaptionML = ENU = 'Delivery Notes', ESP = 'Albaranes de salida';
                    RunObject = Page 7207314;
                    RunPageView = SORTING("No.");
                    Visible = false;
                    Image = NewShipment;
                }
                action("action10")
                {
                    CaptionML = ENU = 'Posted Output Shipment List', ESP = '"Hist. albaranes salida "';
                    RunObject = Page 7207318;
                    RunPageView = SORTING("No.");
                    RunPageLink = "Job No." = FIELD("Job No.");
                    Visible = false;
                    Image = ListPage;
                }
                action("PageOpenCalasUserTask")
                {

                    CaptionML = ENU = 'Open Calas User Tasks', ESP = 'Tareas usuario calas abiertas';
                    // RunObject = Page 50036;
                    Visible = false;
                    Image = TaskList;
                    trigger OnAction()
                    begin
                        /*{
                                 EN PROPIEDADES
                                 PropertyValue
                                 RunObjectPage 50036
                                 RunPageViewWHERE(Percent Complete=FILTER(<>100))
                                 RunPageLinkJob No.=FIELD(Job No.), Service Order No.=FIELD(No.), Task Type=CONST(Calas)
                          }*/
                    END;
                }
                action("PageClosedCalasUserTask")
                {

                    CaptionML = ENU = 'Closed Calas User Tasks', ESP = 'Tareas usuario calas cerradas';
                    // RunObject = Page 50036;
                    Visible = false;
                    Image = TaskList;
                    trigger OnAction()
                    begin
                        /*{
                                 EN PROPIEDADES
                                 PropertyValue
                                 RunObjectPage 50036
                                 RunPageViewWHERE(Percent Complete=FILTER(100))
                                 RunPageLinkJob No.=FIELD(Job No.), Service Order No.=FIELD(No.), Task Type=CONST(Calas)
                         }*/
                    END;



                }

            }
            group("group17")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action13")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    Image = Post;

                    trigger OnAction()
                    VAR
                        QBServiceOrderProcesing: Codeunit 7206911;
                    BEGIN
                        QBServiceOrderProcesing.Post(Rec);
                    END;


                }
                action("Print")
                {

                    CaptionML = ENU = 'Print', ESP = 'Imprimir Roturas a terceros';
                    Visible = false;
                    Image = Print;
                    trigger OnAction()
                    begin
                        /*{
                               SE COMENTA. NO EXISTE REPORT
                               CurrPage.SETSELECTIONFILTER(Rec);
                               REPORT.RUNMODAL(REPORT::"Roturas a terceros",TRUE,TRUE,Rec);
                               }*/
                    END;

                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'Service Order', ESP = 'Pedido servicio';
            }
            group(Category_Process)
            {
                actionref(Copiar_Promoted; Copiar)
                {
                }
                actionref(Proponer_Promoted; Proponer)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
                actionref(Estado_Promoted; Estado)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref(PageOpenCalasUserTask_Promoted; PageOpenCalasUserTask)
                {
                }
                actionref(PageClosedCalasUserTask_Promoted; PageClosedCalasUserTask)
                {
                }
                actionref(Print_Promoted; Print)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action10_Promoted; action10)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);
        /*{SE COMENTA. NO EXISTE FUNCION FilterLevel
        UserMgt.FilterLevel(codeFilterLevel);
        Rec.FILTERGROUP(2);
        Rec.SETFILTER("Access Level",codeFilterLevel);
        Rec.FILTERGROUP(0);
        }*/
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
        GetRecord;

        OperationResult := rec.GetOperationResult;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*{SE COMENTA. NO EXISTE FUNCION GetJobFilter EN CODEUNIT 7207343
        "Responsibility Center" := SetupManagement.GetJobFilter;
        }*/
        GetRecord;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        Rec.TESTFIELD(Status, rec.Status::Pending);

        CurrPage.SAVERECORD;
        EXIT(TRUE);
    END;



    var
        DataCaption: Text;
        TEXT50000: TextConst ENU = 'Order Service %1 - %2.', ESP = 'Pedido servicio %1 - %2.';
        OperationResult: Text;

    LOCAL procedure GetRecord();
    begin

        xRec := Rec;
        DataCaption := STRSUBSTNO(TEXT50000, rec."No.", rec."Job Description");
    end;

    LOCAL procedure NoCustomerOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    LOCAL procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure ShiptoCodeOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      SORTING(Document Type,No.) WHERE(Document Type=CONST(Measuring),Measurement/Service=CONST(Service),Status=FILTER(<>Finished&<>Invoiced))
    }*///end
}








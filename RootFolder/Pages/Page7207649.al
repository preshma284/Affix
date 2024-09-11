page 7207649 "RC Quotes"
{
    CaptionML = ENU = 'Quotes', ESP = 'Estudios';
    PageType = RoleCenter;
    layout
    {
        area(RoleCenter)
        {
            group("group56")
            {

                part("part1"; 7207650)
                {
                    ;
                }
                systempart(Outlook; Outlook)
                {
                    ;
                }

            }
            group("group59")
            {

                part("part3"; 9154)
                {
                    ;
                }
                systempart(MyNotes; MyNotes)
                {
                    ;
                }
                part("part5"; 7207544)
                {
                    ;
                }

            }

        }
    }
    actions
    {
        area(Reporting)
        {

            action("action1")
            {
                CaptionML = ENU = 'Job &Analysis', ESP = '&An�lisis proyecto';
                RunObject = Report 1008;
                Image = Report;
            }
            action("action2")
            {
                CaptionML = ENU = 'Job Actual To &Budget', ESP = 'Pro&yecto real vs. presupuesto';
                RunObject = Report 1009;
                Image = Report;
            }
            action("action3")
            {
                CaptionML = ENU = 'Job - Pla&nning Line', ESP = 'Proyecto - L�&nea planificaci�n';
                RunObject = Report 1006;
                Image = Report;
            }
            action("action4")
            {
                CaptionML = ENU = 'Job Su&ggested Billing', ESP = 'Fact. su&gerida proyecto';
                RunObject = Report 1011;
                Image = Report;
            }
            action("action5")
            {
                CaptionML = ENU = 'Jobs per &Customer', ESP = 'Proyectos por &cliente';
                RunObject = Report 1012;
                Image = Report;
            }
            action("action6")
            {
                CaptionML = ENU = 'Items per &Job', ESP = '&Productos por proyecto';
                RunObject = Report 1013;
                Image = Report;
            }
            action("action7")
            {
                CaptionML = ENU = 'Jobs per &Item', ESP = 'Proyectos por pro&ducto';
                RunObject = Report 1014;
                Image = Report;
            }

        }
        area(Embedding)
        {

            action("action8")
            {
                CaptionML = ENU = 'Jobs', ESP = 'Proyectos';
                RunObject = Page 7207477;
            }
            action("action9")
            {
                CaptionML = ENU = 'Completed', ESP = 'Completados';
                RunObject = Page 7207477;
                RunPageView = WHERE("Status" = FILTER("Completed"));
            }
            action("action10")
            {
                CaptionML = ENU = 'Resources', ESP = 'Recursos';
                RunObject = Page 77;
            }
            action("action11")
            {
                CaptionML = ENU = 'Resource Groups', ESP = 'Familia recursos';
                RunObject = Page 72;
            }
            action("action12")
            {
                CaptionML = ENU = 'Items', ESP = 'Productos';
                RunObject = Page 31;
            }
            action("action13")
            {
                CaptionML = ENU = 'Customers', ESP = 'Clientes';
                RunObject = Page 22;
            }
            action("action14")
            {
                CaptionML = ENU = 'On Order', ESP = 'En pedido';
                RunObject = Page 7207477;
                RunPageView = WHERE("Status" = FILTER("Open"));
            }
            action("action15")
            {
                CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                RunObject = Page 658;
                Image = Approvals;
            }
            action("action16")
            {
                CaptionML = ENU = 'Purchase Documents', ESP = 'Documentos Compra';
                RunObject = Page 53;
            }
            action("action17")
            {
                CaptionML = ENU = 'Partes de costes', ESP = 'Partes de costes';
                RunObject = Page 7207538;
            }
            action("action18")
            {
                CaptionML = ENU = 'Blank Purchase Orders', ESP = 'Pedidos de Compra Abiertos';
                RunObject = Page 53;
                RunPageLink = "Document Type" = CONST("Blanket Order");
            }

        }
        area(Sections)
        {

            group("group22")
            {
                CaptionML = ENU = 'Journals', ESP = 'Diarios';
                action("action19")
                {
                    CaptionML = ENU = 'Job Journals', ESP = 'Diarios de proyectos';
                    RunObject = Page 276;
                    RunPageView = WHERE("Recurring" = CONST(false));
                    Image = JobJournal;
                }
                action("action20")
                {
                    CaptionML = ENU = 'Job G/L Journals', ESP = 'Diarios generales proyecto';
                    RunObject = Page 251;
                    RunPageView = WHERE("Template Type" = CONST("Jobs"), "Recurring" = CONST(false));
                    Image = Journal;
                }
                action("action21")
                {
                    CaptionML = ENU = 'Resource Journals', ESP = 'Diarios de recursos';
                    RunObject = Page 272;
                    RunPageView = WHERE("Recurring" = CONST(false));
                    Image = ResourceJournal;
                }
                action("action22")
                {
                    CaptionML = ENU = 'Item Journals', ESP = 'Diarios de productos';
                    RunObject = Page 262;
                    RunPageView = WHERE("Template Type" = CONST("Item"), "Recurring" = CONST(false));
                    Image = InventoryJournal;
                }
                action("action23")
                {
                    CaptionML = ENU = 'Recurring Job Journals', ESP = 'Diarios peri�dico proyecto';
                    RunObject = Page 276;
                    RunPageView = WHERE("Recurring" = CONST(true));
                    Image = JobJournal;
                }
                action("action24")
                {
                    CaptionML = ENU = 'Recurring Resource Journals', ESP = 'Diarios peri�dicos recursos';
                    RunObject = Page 272;
                    RunPageView = WHERE("Recurring" = CONST(true));
                    Image = ResourceJournal;
                }
                action("action25")
                {
                    CaptionML = ENU = 'Recurring Item Journals', ESP = 'Diario peri�dico productos';
                    RunObject = Page 262;
                    RunPageView = WHERE("Template Type" = CONST("Item"), "Recurring" = CONST(true));
                    Image = InventoryJournal;
                }
                action("action26")
                {
                    CaptionML = ENU = 'Diarios de producci�n', ESP = 'Diarios de producci�n';
                    RunObject = Page 7207326;
                    Image = Journal;
                }

            }
            group("group31")
            {
                CaptionML = ENU = 'Posted Documents', ESP = 'Documentos Hist�ricos';
                action("action27")
                {
                    CaptionML = ENU = 'Hist�rico mediciones', ESP = 'Hist�rico mediciones';
                    RunObject = Page 7207308;
                }
                action("action28")
                {
                    CaptionML = ENU = 'Hist�rico certificaciones', ESP = 'Hist�rico certificaciones';
                    RunObject = Page 7207336;
                }
                action("action29")
                {
                    CaptionML = ENU = 'Posted Sales Invoice', ESP = 'Hist�rico facturas venta';
                    RunObject = Page 143;
                }
                action("action30")
                {
                    CaptionML = ENU = 'Posted Sales Cr. Memos', ESP = 'Hist�rico abonos venta';
                    RunObject = Page 144;
                }
                action("action31")
                {
                    CaptionML = ENU = 'Posted Purchase Invoices', ESP = 'Hist�rico facturas compra';
                    RunObject = Page 146;
                }
                action("action32")
                {
                    CaptionML = ENU = 'Posted Purchase Cr. Memos', ESP = 'Hist�rico abonos compra';
                    RunObject = Page 147;
                }
                action("action33")
                {
                    CaptionML = ENU = 'Hist�rico notas de gastos', ESP = 'Hist�rico notas de gastos';
                    RunObject = Page 7207396;
                }
                action("action34")
                {
                    CaptionML = ENU = 'Hist�rico relaciones valoradas', ESP = 'Hist�rico relaciones valoradas';
                    RunObject = Page 7207522;
                }
                action("action35")
                {
                    CaptionML = ENU = 'Hist�rico partes de costes', ESP = 'Hist�rico partes de costes';
                    RunObject = Page 7207542;
                }
                action("action36")
                {
                    CaptionML = ENU = 'Hist�rico recepciones', ESP = 'Hist�rico recepciones';
                    RunObject = Page 7207611;
                }
                action("action37")
                {
                    CaptionML = ENU = 'Hist�rico albaranes de salida', ESP = 'Hist�rico albaranes de salida';
                    RunObject = Page 7207318;
                }
                action("action38")
                {
                    CaptionML = ENU = 'Hist�rico partes de trabajo recurso', ESP = 'Hist�rico partes de trabajo recurso';
                    RunObject = Page 7207276;
                }

            }

        }
        area(Processing)
        {

            action("action39")
            {
                CaptionML = ENU = 'Job J&ournal', ESP = 'Diario pr&oyectos';
                RunObject = Page 201;
                Image = JobJournal;
            }
            action("action40")
            {
                CaptionML = ENU = 'Job G/L &Journal', ESP = 'Diario &general proyecto';
                RunObject = Page 1020;
                Image = GLJournal;
            }
            action("action41")
            {
                CaptionML = ENU = 'R&esource Journal', ESP = 'Diario r&ecursos';
                RunObject = Page 207;
                Image = ResourceJournal;
            }
            action("action42")
            {
                CaptionML = ENU = 'C&hange Job Planning Line Date', ESP = 'Cambiar fec&has l�n. plan. proy.';
                RunObject = Report 1087;
                Image = Report;
            }
            action("action43")
            {
                CaptionML = ENU = 'Split Pla&nning Lines', ESP = 'Dividir l�&neas planificaci�n';
                RunObject = Report 1088;
                Image = Splitlines;
            }
            action("action44")
            {
                CaptionML = ENU = 'Job &Create Sales Invoice', ESP = '&Crear factura venta proyecto';
                RunObject = Report 1093;
                Image = CreateJobSalesInvoice;
            }
            action("action45")
            {
                CaptionML = ENU = 'Update Job I&tem Cost', ESP = 'Actuali&zar coste productos proyecto';
                RunObject = Report 1095;
                Image = Report;
            }
            action("action46")
            {
                CaptionML = ENU = 'Job Calculate &WIP', ESP = 'Calcular &WIP proyecto';
                RunObject = Report 1086;
                Image = Report;
            }
            action("action47")
            {
                CaptionML = ENU = 'Jo&b Post WIP to G/L', ESP = '&Registrar WIP en C/G proyecto';
                RunObject = Report 1085;
                Image = Report;
            }
            action("action48")
            {
                CaptionML = ENU = 'Navi&gate', ESP = 'N&avegar';
                RunObject = Page 344;
                Image = Navigate
    ;
            }

        }
    }


    /*begin
    end.
  
*/
}








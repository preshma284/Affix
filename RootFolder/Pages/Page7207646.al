page 7207646 "RC Resp Compras Contratacion"
{
    CaptionML = ESP = 'Responsables Compras y Contrataci�n';
    PageType = RoleCenter;
    layout
    {
        area(RoleCenter)
        {
            group("group33")
            {

                part("part1"; 7207647)
                {
                    ;
                }
                systempart(Outlook; Outlook)
                {
                    ;
                }

            }
            group("group36")
            {

                part("part3"; 7207648)
                {
                    ;
                }
                systempart(MyNotes; MyNotes)
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
                CaptionML = ENU = 'Lista de proveedores', ESP = 'Lista de proveedores';
                RunObject = Report 301;
                Image = Report;
            }
            action("action2")
            {
                CaptionML = ENU = 'Proveedor Listado 10 mejores', ESP = 'Proveedor Listado 10 mejores';
                RunObject = Report 311;
                Image = Report;
            }
            action("action3")
            {
                CaptionML = ENU = 'Compras producto/proveedor', ESP = 'Compras producto/proveedor';
                RunObject = Report 313;
                Image = Report;
            }
            action("action4")
            {
                CaptionML = ENU = 'Productos Pedidos de compras', ESP = 'Productos Pedidos de compras';
                RunObject = Report 309;
                Image = Report;
            }
            action("action5")
            {
                CaptionML = ENU = 'Producto Compra proveedores', ESP = 'Producto Compra proveedores';
                RunObject = Report 320;
                Image = Report;
            }
            action("action6")
            {
                CaptionML = ENU = 'Estad�sticas de compras', ESP = 'Estad�sticas de compras';
                RunObject = Report 312;
                Image = Report;
            }
            action("action7")
            {
                CaptionML = ENU = 'Facturas compra largo plazo', ESP = 'Facturas compra largo plazo';
                // RunObject = Report 10741;
                Visible = FALSE;
                Image = Report;
            }

        }
        area(Embedding)
        {

            action("action8")
            {
                CaptionML = ENU = 'Vendors', ESP = 'Proveedores';
                RunObject = Page 27;
            }
            action("action9")
            {
                CaptionML = ENU = 'Resources', ESP = 'Recursos';
                RunObject = Page 77;
            }
            action("action10")
            {
                CaptionML = ENU = 'Items', ESP = 'Productos';
                RunObject = Page 31;
            }
            action("action11")
            {
                CaptionML = ENU = 'Nonstock Item List', ESP = 'Productos sin stock';
                RunObject = Page 5726;
            }
            action("action12")
            {
                CaptionML = ENU = 'Customers', ESP = 'Clientes';
                RunObject = Page 22;
            }
            action("action13")
            {
                CaptionML = ENU = 'Jobs', ESP = 'Proyectos';
                RunObject = Page 7207477;
            }
            action("action14")
            {
                CaptionML = ENU = 'Jobs in process', ESP = 'Proyectos en pedido';
                RunObject = Page 7207477;
            }
            action("action15")
            {
                CaptionML = ENU = 'Finished jobs', ESP = 'Proyectos terminados';
                RunObject = Page 7207477;
                RunPageView = WHERE("Status" = FILTER("Completed"));
            }
            action("action16")
            {
                CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                RunObject = Page 662;
            }
            action("action17")
            {
                CaptionML = ENU = 'Orders', ESP = 'Pedidos';
                RunObject = Page 53;
            }

        }
        area(Sections)
        {

            group("group21")
            {
                CaptionML = ENU = 'Journals', ESP = 'Administraci�n Compras';
                action("action18")
                {
                    CaptionML = ENU = 'Job Journals', ESP = 'Actividades de compra';
                    RunObject = Page 7207379;
                }

            }
            group("group23")
            {
                CaptionML = ENU = 'Posted Documents', ESP = 'Documentos Hist�ricos';
                action("action19")
                {
                    CaptionML = ENU = 'Archivo pedido compras', ESP = 'Archivo pedido compras';
                    RunObject = Page 9347;
                }
                action("action20")
                {
                    CaptionML = ENU = 'Hist�rico de albaranes', ESP = 'Hist�rico de albaranes';
                    RunObject = Page 145;
                }
                action("action21")
                {
                    CaptionML = ENU = 'Hist�rico de recepciones', ESP = 'Hist�rico de recepciones';
                    RunObject = Page 7207611;
                }
                action("action22")
                {
                    CaptionML = ENU = 'Hist�rico de facturas', ESP = 'Hist�rico de facturas';
                    RunObject = Page 146;
                }
                action("action23")
                {
                    CaptionML = ENU = 'Hist�rico de abonos', ESP = 'Hist�rico de abonos';
                    RunObject = Page 147;
                }
                action("action24")
                {
                    CaptionML = ENU = 'Hist�rico de evaluaciones', ESP = 'Hist�rico de evaluaciones';
                    RunObject = Page 7207568;
                }

            }

        }
        area(Processing)
        {

            action("action25")
            {
                CaptionML = ENU = 'Informe An�lisis de compras', ESP = 'Informe an�lisis de compras';
                RunObject = Report 7118;
                Image = Report
    ;
            }

        }
    }


    /*begin
    end.
  
*/
}








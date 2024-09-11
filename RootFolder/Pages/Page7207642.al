page 7207642 "RC Administrativo Obra"
{
    CaptionML = ESP = 'Administrativo de Obra';
    PageType = RoleCenter;
    layout
    {
        area(RoleCenter)
        {
            group("group39")
            {

                part("part1"; 7207643)
                {
                    ;
                }
                systempart(Outlook; Outlook)
                {
                    ;
                }

            }
            group("group42")
            {

                part("part3"; 9154)
                {
                    ;
                }
                part("part4"; 9151)
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
                CaptionML = ENU = 'Antig�edad de cobros', ESP = 'Antig�edad de cobros';
                RunObject = Report 120;
                Image = Report;
            }
            action("action2")
            {
                CaptionML = ENU = 'Cobros por vencimiento', ESP = 'Cobros por vencimiento';
                // RunObject = Report 7000006;
                Image = Report;
            }
            action("action3")
            {
                CaptionML = ENU = 'Antig�edad de pagos', ESP = 'Antig�edad de pagos';
                RunObject = Report 322;
                Image = Report;
            }
            action("action4")
            {
                CaptionML = ENU = 'Pagos por vencimiento', ESP = 'Pagos por vencimiento';
                // RunObject = Report 7000007;
                Image = Report;
            }
            action("action5")
            {
                CaptionML = ENU = 'Proyectos - Movimientos', ESP = 'Proyectos - Movimientos';
                RunObject = Report 1007;
                Image = Report;
            }
            action("action6")
            {
                CaptionML = ENU = 'Proyectos por clientes', ESP = 'Proyectos por clientes';
                RunObject = Report 1012;
                Image = Report;
            }
            action("action7")
            {
                CaptionML = ENU = 'Productos por Proyectos', ESP = 'Productos por Proyectos';
                RunObject = Report 1013;
                Image = Report;
            }
            action("action8")
            {
                CaptionML = ENU = 'Proyecto por Producto', ESP = 'Proyecto por Producto';
                RunObject = Report 1014;
                Image = Report;
            }

        }
        area(Embedding)
        {

            action("action9")
            {
                CaptionML = ENU = 'Vendors', ESP = 'Proveedores';
                RunObject = Page 27;
            }
            action("action10")
            {
                CaptionML = ENU = 'Customers', ESP = 'Clientes';
                RunObject = Page 22;
            }
            action("action11")
            {
                CaptionML = ENU = 'On Order', ESP = 'Proyectos en proceso';
                RunObject = Page 7207477;
                RunPageView = WHERE("Status" = FILTER("Open"));
            }
            action("action12")
            {
                CaptionML = ENU = 'Purchase Documents', ESP = 'Documentos de Compra';
                RunObject = Page 53;
            }
            action("action13")
            {
                CaptionML = ENU = 'Notas de gastos', ESP = 'Notas de gastos';
                RunObject = Page 7207392;
            }
            action("action14")
            {
                CaptionML = ENU = 'Partes de trabajo recurso', ESP = 'Partes de trabajo recurso';
                RunObject = Page 7207271;
            }

        }
        area(Sections)
        {

            group("group18")
            {
                CaptionML = ENU = 'Journals', ESP = 'Rectificaciones';
                action("action15")
                {
                    CaptionML = ENU = 'Job Journals', ESP = 'Reclasificaci�n de imputaciones';
                    RunObject = Page 7207379;
                }
                action("action16")
                {
                    CaptionML = ENU = 'Job G/L Journals', ESP = 'Traspaso de facturaci�n';
                    RunObject = Page 7207379;
                }

            }
            group("group21")
            {
                CaptionML = ENU = 'Posted Documents', ESP = 'Documentos Hist�ricos';
                action("action17")
                {
                    CaptionML = ENU = 'Hist�rico recepciones', ESP = 'Hist�rico recepciones';
                    RunObject = Page 7207611;
                }
                action("action18")
                {
                    CaptionML = ENU = 'Hist�rico albaranes', ESP = 'Hist�rico albaranes';
                    RunObject = Page 145;
                }
                action("action19")
                {
                    CaptionML = ENU = 'Hist�rico facturas compra', ESP = 'Hist�rico facturas compra';
                    RunObject = Page 146;
                }
                action("action20")
                {
                    CaptionML = ENU = 'Hist�rico abonos compra', ESP = 'Hist�rico abonos compra';
                    RunObject = Page 147;
                }
                action("action21")
                {
                    CaptionML = ENU = 'Hist�rico albaranes de salida', ESP = 'Hist�rico albaranes de salida';
                    RunObject = Page 7207318;
                }
                action("action22")
                {
                    CaptionML = ENU = 'Hist�rico partes de trabajo recurso', ESP = 'Hist�rico partes de trabajo recurso';
                    RunObject = Page 7207276;
                }
                action("action23")
                {
                    CaptionML = ENU = 'Hist�rico imputaci�n de costes', ESP = 'Hist�rico imputaci�n de costes';
                    RunObject = Page 7207542;
                }
                action("action24")
                {
                    CaptionML = ENU = 'Hist�rico reclasific. de imputaciones', ESP = 'Hist�rico reclasific. de imputaciones';
                    RunObject = Page 7207276;
                }
                action("action25")
                {
                    CaptionML = ENU = 'Hist�rico traspasos de facturaci�n', ESP = 'Hist�rico traspasos de facturaci�n';
                    RunObject = Page 7207380;
                }
                action("action26")
                {
                    CaptionML = ENU = 'Registro movimientos', ESP = 'Registro movimientos';
                    RunObject = Page 278;
                }

            }

        }
        area(Processing)
        {

            action("action27")
            {
                CaptionML = ENU = 'Payment Journal', ESP = 'Diarios de pagos';
                RunObject = Page 256;
                Image = PaymentJournal;
            }
            action("action28")
            {
                CaptionML = ENU = 'Diarios de cobros', ESP = 'Diarios de cobros';
                RunObject = Page 255;
                Image = CashReceiptJournal;
            }
            action("action29")
            {
                CaptionML = ENU = 'Diarios generales', ESP = 'Diarios generales';
                RunObject = Page 39;
                Image = GLJournal;
            }
            action("action30")
            {
                CaptionML = ENU = 'Job Journals', ESP = 'Diarios de proyectos';
                RunObject = Page 201;
                Image = JobJournal;
            }
            action("action31")
            {
                CaptionML = ENU = 'Navi&gate', ESP = 'N&avegar';
                RunObject = Page 344;
                Image = Navigate
    ;
            }

        }
    }
    /*

      begin
      {
        AML Q19799 Cambiar la llamada de abonos a Documentos de compras
      }
      end.*/


}








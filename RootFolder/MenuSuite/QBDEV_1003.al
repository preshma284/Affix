profile QBDEV_1003
{
    Caption = 'QBDEV_1003';
    RoleCenter = "QBDEV1003";
    Promoted = true;
    Enabled = true;
}

page 52987 "QBDEV1003"
{
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            group("QuoFacturae")
            {
                Caption = 'QuoFacturae';


                action("Administrative centers")
                {
                    Caption = 'Administrative centers';
                    ApplicationArea = all;
                    RunObject = Page "QuoFacturae Adm. centers";
                }



                action("Factura-e entries")
                {
                    Caption = 'Factura-e entries';
                    ApplicationArea = all;
                    RunObject = Page "QuoFacturae entries";
                }


            }
            group("Drag&Drop")
            {
                Caption = 'Drag&Drop';


                action("Config. Arrastrar y soltar Sharepoint")
                {
                    Caption = 'Config. Arrastrar y soltar Sharepoint';
                    ApplicationArea = all;
                    RunObject = Page "DragDrop SP Setup";
                }



                action("Definici¢n Sitio Sharepoint Lista")
                {
                    Caption = 'Definici¢n Sitio Sharepoint Lista';
                    ApplicationArea = all;
                    RunObject = Page "Definition Sharepoint List";
                }



                action("Log. Ficheros a Sharepoint")
                {
                    Caption = 'Log. Ficheros a Sharepoint';
                    ApplicationArea = all;
                    RunObject = Page "Log. DragDrop Sharepoint";
                }


            }
            group("QuoSII")
            {
                Caption = 'QuoSII';


                action("Documentos")
                {
                    Caption = 'Documentos';
                    ApplicationArea = all;
                    RunObject = Page "SII Documents List";
                }



                action("Env¡os")
                {
                    Caption = 'Env¡os';
                    ApplicationArea = all;
                    RunObject = Page "SII Document Ship List";
                }



                action("Infome SII")
                {
                    Caption = 'Infome SII';
                    ApplicationArea = all;
                    RunObject = Page "SII Document Ship List";
                }



                action("Contraste SII")
                {
                    Caption = 'Contraste SII';
                    ApplicationArea = all;
                    RunObject = Page "SII Type";
                }



                action("Configuraci¢n QuoSII")
                {
                    Caption = 'Configuraci¢n QuoSII';
                    ApplicationArea = all;
                    RunObject = Page "SII Configuration";
                }



                action("SII Tipos")
                {
                    Caption = 'SII Tipos';
                    ApplicationArea = all;
                    RunObject = Page "SII Type";
                }



                action("Hist¢rico facturas de compra")
                {
                    Caption = 'Hist¢rico facturas de compra';
                    ApplicationArea = all;
                    RunObject = Page 146;
                }



                action("Lista hist. abono compra")
                {
                    Caption = 'Lista hist. abono compra';
                    ApplicationArea = all;
                    RunObject = Page 147;
                }



                action("Lista hist. facturas venta")
                {
                    Caption = 'Lista hist. facturas venta';
                    ApplicationArea = all;
                    RunObject = Page 143;
                }


            }
            group("Sincronizar Empresas")
            {
                Caption = 'Sincronizar Empresas';


                action("Sincronizar Empresas: Tabla externa")
                {
                    Caption = 'Sincronizar Empresas: Tabla externa';
                    ApplicationArea = all;
                    RunObject = Page "QuoSync Send External";
                }



                action("Sincronizar Empresas: Exportaci¢n")
                {
                    Caption = 'Sincronizar Empresas: Exportaci¢n';
                    ApplicationArea = all;
                    RunObject = Page "QuoSync Send";
                }



                action("Sincronizar Empresas: Recibir")
                {
                    Caption = 'Sincronizar Empresas: Recibir';
                    ApplicationArea = all;
                    RunObject = Page "QuoSync Received";
                }


            }
            group("Importar/Exportar")
            {
                Caption = 'Importar/Exportar';


                action("Exportaci¢n de datos")
                {
                    Caption = 'Exportaci¢n de datos';
                    ApplicationArea = all;
                    RunObject = Page "Journal Template (Element)";
                }



                action("Configuraci¢n de Tablas")
                {
                    Caption = 'Configuraci¢n de Tablas';
                    ApplicationArea = all;
                    RunObject = Page "QB Generic Import - Tables";
                }



                action("Replacements")
                {
                    Caption = 'Replacements';
                    ApplicationArea = all;
                    RunObject = Page "QB Replacements";
                }


            }
            group("Estudios")
            {
                Caption = 'Estudios';


                action("Lista ofertas")
                {
                    Caption = 'Lista ofertas';
                    ApplicationArea = all;
                    RunObject = Page "Quotes List";
                }



                action("Lista preciario1")
                {
                    Caption = 'Lista preciario';
                    ApplicationArea = all;
                    RunObject = Page "Cost Database List";
                }



                action("Atributos de Proyecto/Estudio1")
                {
                    Caption = 'Atributos de Proyecto/Estudio';
                    ApplicationArea = all;
                    RunObject = Page "Job Attribute Values";
                }



                action("Lista ofertas Archivadas")
                {
                    Caption = 'Lista ofertas Archivadas';
                    ApplicationArea = all;
                    RunObject = Page "Archived Quotes List";
                }


            }
            group("Obras")
            {
                Caption = 'Obras';


                action("Pedidos dev. compra")
                {
                    Caption = 'Pedidos dev. compra';
                    ApplicationArea = all;
                    RunObject = Page 9311;
                }



                action("Lista de sesiones")
                {
                    Caption = 'Lista de sesiones';
                    ApplicationArea = all;
                    RunObject = Page "Session List";
                }

                group("Planning")
                {
                    Caption = 'Planning';


                    action("Lista preciario")
                    {
                        Caption = 'Lista preciario';
                        ApplicationArea = all;
                        RunObject = Page "Cost Database List";
                    }



                    action("Lista unidad de obra")
                    {
                        Caption = 'Lista unidad de obra';
                        ApplicationArea = all;
                        RunObject = Page "Piecework List";
                    }



                    action("Calcular producci¢n proyectos1")
                    {
                        Caption = 'Calcular producci¢n proyectos';
                        ApplicationArea = all;
                        RunObject = Page "Cost Database Card";
                    }



                    action("Listado precios descompuestos")
                    {
                        Caption = 'Listado precios descompuestos';
                        ApplicationArea = all;
                        RunObject = Page "Job Offers Statistics";
                    }



                    action("Proyectos Operativos sin nivel")
                    {
                        Caption = 'Proyectos Operativos sin nivel';
                        ApplicationArea = all;
                        RunObject = Page "Job Situation Statistics";
                    }



                    action("Informe gastos por ppto nivel")
                    {
                        Caption = 'Informe gastos por ppto nivel';
                        ApplicationArea = all;
                        RunObject = Page "Hist. Head. Return Elem";
                    }



                    action("Gesti¢n de obras")
                    {
                        Caption = 'Gesti¢n de obras';
                        ApplicationArea = all;
                        RunObject = Page "Subform. Hist. Lin Delivery/Re";
                    }



                    action("Lista proyectos operativos")
                    {
                        Caption = 'Lista proyectos operativos';
                        ApplicationArea = all;
                        RunObject = Page "Operative Jobs List";
                    }



                    action("Lista proyectos de estructura")
                    {
                        Caption = 'Lista proyectos de estructura';
                        ApplicationArea = all;
                        RunObject = Page "Structure Jobs List";
                    }



                    action("Lista proyectos de Desviaciones")
                    {
                        Caption = 'Lista proyectos de Desviaciones';
                        ApplicationArea = all;
                        RunObject = Page "Deviations Jobs List";
                    }



                    action("Atributos de Proyecto/Estudio")
                    {
                        Caption = 'Atributos de Proyecto/Estudio';
                        ApplicationArea = all;
                        RunObject = Page "Job Attributes";
                    }



                    action("Informe gastos por obra sin unidades")
                    {
                        Caption = 'Informe gastos por obra sin unidades';
                        ApplicationArea = all;
                        RunObject = Page "Statistics Delivery/Return Ele";
                    }



                    action("Lista proyectos operativos archivados")
                    {
                        Caption = 'Lista proyectos operativos archivados';
                        ApplicationArea = all;
                        RunObject = Page "Archived Operative Jobs List";
                    }



                    action("Lista de preciarios Archivados")
                    {
                        Caption = 'Lista de preciarios Archivados';
                        ApplicationArea = all;
                        RunObject = Page "Cost Database List Archived";
                    }



                    action("Lista proyectos operativos1")
                    {
                        Caption = 'Lista proyectos operativos';
                        ApplicationArea = all;
                        RunObject = Page "Operative Matrix Jobs List";
                    }


                }

                action("Albaranes pendientes de facturar")
                {
                    Caption = 'Albaranes pendientes de facturar';
                    ApplicationArea = all;
                    RunObject = Page "QB Job Responsibles List";
                }

                group("Financial Management")
                {
                    Caption = 'Financial Management';

                }
                group("Expense Notes")
                {
                    Caption = 'Expense Notes';


                    action("Lista notas de gasto")
                    {
                        Caption = 'Lista notas de gasto';
                        ApplicationArea = all;
                        RunObject = Page "Expense Notes List";
                    }



                    action("Lista Hist. notas gasto")
                    {
                        Caption = 'Lista Hist. notas gasto';
                        ApplicationArea = all;
                        RunObject = Page "Hist. Expense Notes List";
                    }


                }
                group("Withholding")
                {
                    Caption = 'Withholding';


                    action("Lista Retenciones")
                    {
                        Caption = 'Lista Retenciones';
                        ApplicationArea = all;
                        RunObject = Page "Withholding Group List";
                    }



                    action("Movs. Retenciones1")
                    {
                        Caption = 'Movs. Retenciones';
                        ApplicationArea = all;
                        RunObject = Page "Withholding Movements B.E.";
                    }



                    action("Movs. Retenciones")
                    {
                        Caption = 'Movs. Retenciones';
                        ApplicationArea = all;
                        RunObject = Page "Withholding Movements IRPF";
                    }



                    action("Retenciones de IRPF de Proveedores")
                    {
                        Caption = 'Retenciones de IRPF de Proveedores';
                        ApplicationArea = all;
                        RunObject = Page "Cost Database List";
                    }



                    action("Facturas compra3")
                    {
                        Caption = 'Facturas compra';
                        ApplicationArea = all;
                        RunObject = Page 9308;
                    }



                    action("Abonos de compra3")
                    {
                        Caption = 'Abonos de compra';
                        ApplicationArea = all;
                        RunObject = Page 9309;
                    }



                    action("Invoices3")
                    {
                        Caption = 'Invoices';
                        ApplicationArea = all;
                        RunObject = Page 9301;
                    }



                    action("Credit Memos")
                    {
                        Caption = 'Credit Memos';
                        ApplicationArea = all;
                        RunObject = Page 9302;
                    }



                    action("Hist. facturas venta")
                    {
                        Caption = 'Hist. facturas venta';
                        ApplicationArea = all;
                        RunObject = Page 143;
                    }



                    action("Hist. abono venta")
                    {
                        Caption = 'Hist. abono venta';
                        ApplicationArea = all;
                        RunObject = Page 144;
                    }



                    action("Posted Invoices3")
                    {
                        Caption = 'Posted Invoices';
                        ApplicationArea = all;
                        RunObject = Page 146;
                    }



                    action("Posted Credit Memos3")
                    {
                        Caption = 'Posted Credit Memos';
                        ApplicationArea = all;
                        RunObject = Page 147;
                    }



                    action("Formato Transferencia IRPF")
                    {
                        Caption = 'Formato Transferencia IRPF';
                        ApplicationArea = all;
                        RunObject = Page "QB_IRPF Transference Format";
                    }


                }
                group("Deposit Guarantees")
                {
                    Caption = 'Deposit Guarantees';


                    action("Guarantee")
                    {
                        Caption = 'Guarantee';
                        ApplicationArea = all;
                        RunObject = Page "Guarantees List";
                    }



                    action("Tipo de Avale o Fianza")
                    {
                        Caption = 'Tipo de Avale o Fianza';
                        ApplicationArea = all;
                        RunObject = Page "Guarantees Types";
                    }



                    action("Registro de gastos de Garant¡as")
                    {
                        Caption = 'Registro de gastos de Garant¡as';
                        ApplicationArea = all;
                        RunObject = Page "Post. Certifications";
                    }


                }
                group("Indirect Costs")
                {
                    Caption = 'Indirect Costs';


                    action("Proponer partes costes")
                    {
                        Caption = 'Proponer partes costes';
                        ApplicationArea = all;
                        RunObject = Page "Hist. Reestimation Stat. Hdr.";
                    }



                    action("Lista partes costes")
                    {
                        Caption = 'Lista partes costes';
                        ApplicationArea = all;
                        RunObject = Page "Costsheet List";
                    }



                    action("Calcular Indirectos Porcentuales")
                    {
                        Caption = 'Calcular Indirectos Porcentuales';
                        ApplicationArea = all;
                        RunObject = Page "Reestimation statistic";
                    }



                    action("Diario general")
                    {
                        Caption = 'Diario general';
                        ApplicationArea = all;
                        RunObject = Page 39;
                    }



                    action("Hist. Partes coste")
                    {
                        Caption = 'Hist. Partes coste';
                        ApplicationArea = all;
                        RunObject = Page "Costsheet Hist. List";
                    }


                }
                group("Journals")
                {
                    Caption = 'Journals';


                    action("Job Journals")
                    {
                        Caption = 'Job Journals';
                        ApplicationArea = all;
                        RunObject = Page 201;
                    }



                    action("Job G/L Journals")
                    {
                        Caption = 'Job G/L Journals';
                        ApplicationArea = all;
                        RunObject = Page 1020;
                    }



                    action("Recurring Journals")
                    {
                        Caption = 'Recurring Journals';
                        ApplicationArea = all;
                        RunObject = Page 289;
                    }


                }
                group("Time Sheets")
                {
                    Caption = 'Time Sheets';


                    action("Lista partes de trabajo Recurso")
                    {
                        Caption = 'Lista partes de trabajo Recurso';
                        ApplicationArea = all;
                        RunObject = Page "QB Worksheet List";
                    }



                    action("Lista hist. partes de trabajo Recurso")
                    {
                        Caption = 'Lista hist. partes de trabajo Recurso';
                        ApplicationArea = all;
                        RunObject = Page "QB Worksheet List Hist.";
                    }



                    action("Calendarios")
                    {
                        Caption = 'Calendarios';
                        ApplicationArea = all;
                        RunObject = Page "Type Calendar List";
                    }



                    action("Recursos")
                    {
                        Caption = 'Recursos';
                        ApplicationArea = all;
                        RunObject = Page 77;
                    }



                    action("Tipos de trabajo")
                    {
                        Caption = 'Tipos de trabajo';
                        ApplicationArea = all;
                        RunObject = Page 208;
                    }



                    action("Precio de coste del recurso")
                    {
                        Caption = 'Precio de coste del recurso';
                        ApplicationArea = all;
                        RunObject = Page 203;
                    }



                    action("Periodos de imputaci¢n")
                    {
                        Caption = 'Periodos de imputaci¢n';
                        ApplicationArea = all;
                        RunObject = Page "Allocation Term List";
                    }



                    action("Lineas de Partes Registrados")
                    {
                        Caption = 'Lineas de Partes Registrados';
                        ApplicationArea = all;
                        RunObject = Page "QB WorkSheet Lines Posted";
                    }


                }
                group("Purchases")
                {
                    Caption = 'Purchases';


                    action("Lista comparativo ofertas")
                    {
                        Caption = 'Lista comparativo ofertas';
                        ApplicationArea = all;
                        RunObject = Page "Comparative Quote List";
                    }



                    action("Lista datos proveedor")
                    {
                        Caption = 'Lista datos proveedor';
                        ApplicationArea = all;
                        RunObject = Page "Vendor Data List";
                    }



                    action("Control Contratos")
                    {
                        Caption = 'Control Contratos';
                        ApplicationArea = all;
                        RunObject = Page "Contracts Control List";
                    }



                    action("Pedidos compra")
                    {
                        Caption = 'Pedidos compra';
                        ApplicationArea = all;
                        RunObject = Page 9307;
                    }



                    action("Facturas compra")
                    {
                        Caption = 'Facturas compra';
                        ApplicationArea = all;
                        RunObject = Page 9308;
                    }



                    action("Abonos de compra")
                    {
                        Caption = 'Abonos de compra';
                        ApplicationArea = all;
                        RunObject = Page 9309;
                    }



                    action("Hist¢rico albaranes de compra")
                    {
                        Caption = 'Hist¢rico albaranes de compra';
                        ApplicationArea = all;
                        RunObject = Page 145;
                    }



                    action("Posted Invoices4")
                    {
                        Caption = 'Posted Invoices';
                        ApplicationArea = all;
                        RunObject = Page 146;
                    }



                    action("Posted Credit Memos")
                    {
                        Caption = 'Posted Credit Memos';
                        ApplicationArea = all;
                        RunObject = Page 147;
                    }



                    action("Recepcion de Facturas de compra")
                    {
                        Caption = 'Recepcion de Facturas de compra';
                        ApplicationArea = all;
                        RunObject = Page "Receipt Purchase Invoices List";
                    }



                    action("Pedidos abiertos compra")
                    {
                        Caption = 'Pedidos abiertos compra';
                        ApplicationArea = all;
                        RunObject = Page 9310;
                    }



                    action("Vendors")
                    {
                        Caption = 'Vendors';
                        ApplicationArea = all;
                        RunObject = Page 27;
                    }



                    action("Lista de contratos marco")
                    {
                        Caption = 'Lista de contratos marco';
                        ApplicationArea = all;
                        RunObject = Page "QB Framework Contracts";
                    }



                    action("Verificar documentaci¢n Doc. Compras")
                    {
                        Caption = 'Verificar documentaci¢n Doc. Compras';
                        ApplicationArea = all;
                        RunObject = Page "QB Purchases Check";
                    }



                    action("Imputar albaranes pendientes")
                    {
                        Caption = 'Imputar albaranes pendientes';
                        ApplicationArea = all;
                        RunObject = Page "Trancking Materials Purchase";
                    }



                    action("Lista Contratos Marco Usados")
                    {
                        Caption = 'Lista Contratos Marco Usados';
                        ApplicationArea = all;
                        RunObject = Page "QB Framework Contr. Closed";
                    }



                    action("Lista de proformas")
                    {
                        Caption = 'Lista de proformas';
                        ApplicationArea = all;
                        RunObject = Page "QB Proform List";
                    }



                    action("Revisi¢n de Compras")
                    {
                        Caption = 'Revisi¢n de Compras';
                        ApplicationArea = all;
                        RunObject = Page "Subform. Posted Element Contra";
                    }



                    action("Revisi¢n Facturas/Proyectos")
                    {
                        Caption = 'Revisi¢n Facturas/Proyectos';
                        ApplicationArea = all;
                        RunObject = Page "Usage Statistics Header FB";
                    }



                    action("Lista comparativo ofertas Registrados")
                    {
                        Caption = 'Lista comparativo ofertas Registrados';
                        ApplicationArea = all;
                        RunObject = Page "Comparative Quote List Post";
                    }



                    action("Lista comparativo ofertas Cerradas")
                    {
                        Caption = 'Lista comparativo ofertas Cerradas';
                        ApplicationArea = all;
                        RunObject = Page "Comparative Quote List Closed";
                    }



                    action("Situaci¢n de Proveedores")
                    {
                        Caption = 'Situaci¢n de Proveedores';
                        ApplicationArea = all;
                        RunObject = Page "Status Draft Counter Elem FB";
                    }



                    action("Costes imputados por proveedores")
                    {
                        Caption = 'Costes imputados por proveedores';
                        ApplicationArea = all;
                        RunObject = Page "Status Delivery/Retrun Elem FB";
                    }


                }
                group("Earned Value Docs. and Work Certifications")
                {
                    Caption = 'Earned Value Docs. and Work Certifications';

                }
                group("Quantity Measurements")
                {
                    Caption = 'Quantity Measurements';


                    action("Mediciones")
                    {
                        Caption = 'Mediciones';
                        ApplicationArea = all;
                        RunObject = Page "Measurement List";
                    }



                    action("Hist. mediciones")
                    {
                        Caption = 'Hist. mediciones';
                        ApplicationArea = all;
                        RunObject = Page "Measure Post List";
                    }


                }
                group("Work Certifications")
                {
                    Caption = 'Work Certifications';


                    action("Certificaciones")
                    {
                        Caption = 'Certificaciones';
                        ApplicationArea = all;
                        RunObject = Page "Certification List";
                    }



                    action("Hist. Certificaciones")
                    {
                        Caption = 'Hist. Certificaciones';
                        ApplicationArea = all;
                        RunObject = Page "Post. Certifications List";
                    }



                    action("Invoices")
                    {
                        Caption = 'Invoices';
                        ApplicationArea = all;
                        RunObject = Page 9301;
                    }



                    action("Posted Invoices5")
                    {
                        Caption = 'Posted Invoices';
                        ApplicationArea = all;
                        RunObject = Page 143;
                    }


                }
                group("Earned Value Document List")
                {
                    Caption = 'Earned Value Document List';


                    action("Relaciones Valoradas")
                    {
                        Caption = 'Relaciones Valoradas';
                        ApplicationArea = all;
                        RunObject = Page "Prod. Measure List";
                    }



                    action("Lista hist. mediciones Prod.")
                    {
                        Caption = 'Lista hist. mediciones Prod.';
                        ApplicationArea = all;
                        RunObject = Page "Post. Prod. Measurement List";
                    }


                }
                group("Deferred VAT")
                {
                    Caption = 'Deferred VAT';


                    action("Liberar IVA diferido proveedor")
                    {
                        Caption = 'Liberar IVA diferido proveedor';
                        ApplicationArea = all;
                        RunObject = Page "Transfers Between Jobs Card";
                    }



                    action("Liberar IVA diferido cliente")
                    {
                        Caption = 'Liberar IVA diferido cliente';
                        ApplicationArea = all;
                        RunObject = Page "Transfers Between Jobs Lines";
                    }


                }
                group("Closing Month Process")
                {
                    Caption = 'Closing Month Process';


                    action("Calcular producci¢n proyectos")
                    {
                        Caption = 'Calcular producci¢n proyectos';
                        ApplicationArea = all;
                        RunObject = Page "Cost Database Card";
                    }



                    action("Lista Hist. notas gasto1")
                    {
                        Caption = 'Lista Hist. notas gasto';
                        ApplicationArea = all;
                        RunObject = Page "Usage Header Stat. Hist.";
                    }



                    action("Lin. diario producci¢n")
                    {
                        Caption = 'Lin. diario producci¢n';
                        ApplicationArea = all;
                        RunObject = Page "Production Daily Line";
                    }



                    action("Secciones diario producci¢n")
                    {
                        Caption = 'Secciones diario producci¢n';
                        ApplicationArea = all;
                        RunObject = Page "Production Daily Book";
                    }


                }
                group("Cost Transfers")
                {
                    Caption = 'Cost Transfers';


                    action("Cab. cargos y descargos")
                    {
                        Caption = 'Cab. cargos y descargos';
                        ApplicationArea = all;
                        RunObject = Page "Transfers Between Jobs List";
                    }



                    action("Lista hist. doc. traspasos")
                    {
                        Caption = 'Lista hist. doc. traspasos';
                        ApplicationArea = all;
                        RunObject = Page "Tran. Between Jobs Post List";
                    }


                }
                group("Approvals")
                {
                    Caption = 'Approvals';


                    action("Documentos a pagar")
                    {
                        Caption = 'Documentos a pagar';
                        ApplicationArea = all;
                        RunObject = Page "Payables Cartera Docs";
                    }



                    action("Approval Entries")
                    {
                        Caption = 'Approval Entries';
                        ApplicationArea = all;
                        RunObject = Page 654;
                    }


                }
                group("Setup")
                {
                    Caption = 'Setup';


                    action("Conf. QuoBuilding")
                    {
                        Caption = 'Conf. QuoBuilding';
                        ApplicationArea = all;
                        RunObject = Page "QuoBuilding Setup";
                    }



                    action("Conf. elementos de alquiler")
                    {
                        Caption = 'Conf. elementos de alquiler';
                        ApplicationArea = all;
                        RunObject = Page "Rental Elements Setup";
                    }



                    action("Conf. unidades de obra")
                    {
                        Caption = 'Conf. unidades de obra';
                        ApplicationArea = all;
                        RunObject = Page "Piecework Setup";
                    }



                    action("Estados internos")
                    {
                        Caption = 'Estados internos';
                        ApplicationArea = all;
                        RunObject = Page "Jobs Status List";
                    }



                    action("Clasificaci¢n de proyectos")
                    {
                        Caption = 'Clasificaci¢n de proyectos';
                        ApplicationArea = all;
                        RunObject = Page "Job Classification";
                    }



                    action("Fases de proyectos")
                    {
                        Caption = 'Fases de proyectos';
                        ApplicationArea = all;
                        RunObject = Page "TAux Job Phases List";
                    }



                    action("Lista grupos contables Unidades Obra")
                    {
                        Caption = 'Lista grupos contables Unidades Obra';
                        ApplicationArea = all;
                        RunObject = Page "Units Posting Group List";
                    }



                    action("C¢digos de evauaci¢n de proveedores")
                    {
                        Caption = 'C¢digos de evauaci¢n de proveedores';
                        ApplicationArea = all;
                        RunObject = Page "Codes Evaluation List";
                    }



                    action("Selecci¢n informes para QuoBuilding")
                    {
                        Caption = 'Selecci¢n informes para QuoBuilding';
                        ApplicationArea = all;
                        RunObject = Page "QB Report Selection";
                    }



                    action("Lista de tipos de Certificados de proveedor")
                    {
                        Caption = 'Lista de tipos de Certificados de proveedor';
                        ApplicationArea = all;
                        RunObject = Page "Vendor Certificates Types List";
                    }



                    action("Lista Cond. proveedor")
                    {
                        Caption = 'Lista Cond. proveedor';
                        ApplicationArea = all;
                        RunObject = Page "Other Def. Vendor Cond. List";
                    }



                    action("Nombres de campos en QuoBuilding")
                    {
                        Caption = 'Nombres de campos en QuoBuilding';
                        ApplicationArea = all;
                        RunObject = Page "QB Tables Setup List";
                    }



                    action("Lista categorias generales")
                    {
                        Caption = 'Lista categorias generales';
                        ApplicationArea = all;
                        RunObject = Page "TAux General Categories List";
                    }



                    action("Procedimiento de adjudicaci¢n")
                    {
                        Caption = 'Procedimiento de adjudicaci¢n';
                        ApplicationArea = all;
                        RunObject = Page "TAux Award procedure List";
                    }



                    action("Lista Categor¡as Presupuesto")
                    {
                        Caption = 'Lista Categor¡as Presupuesto';
                        ApplicationArea = all;
                        RunObject = Page "TAux Budget Category List";
                    }



                    action("Cambios divisas por proyectos")
                    {
                        Caption = 'Cambios divisas por proyectos';
                        ApplicationArea = all;
                        RunObject = Page "QB Job Currency Exchanges";
                    }



                    action("Asistente Configuraci¢n Aprobaciones")
                    {
                        Caption = 'Asistente Configuraci¢n Aprobaciones';
                        ApplicationArea = all;
                        RunObject = Page "QB Approval Assistant";
                    }



                    action("Asistente Configuraci¢n Almac‚n")
                    {
                        Caption = 'Asistente Configuraci¢n Almac‚n';
                        ApplicationArea = all;
                        RunObject = Page "QB Location Assistant";
                    }



                    action("Lista de Fases de Pago")
                    {
                        Caption = 'Lista de Fases de Pago';
                        ApplicationArea = all;
                        RunObject = Page "QB Payment Phases List";
                    }



                    action("Descripci¢n de Operaciones para el SII")
                    {
                        Caption = 'Descripci¢n de Operaciones para el SII';
                        ApplicationArea = all;
                        RunObject = Page "QB SII Operations Description";
                    }



                    action("Asistente Configuraci¢n Descripciones de campos")
                    {
                        Caption = 'Asistente Configuraci¢n Descripciones de campos';
                        ApplicationArea = all;
                        RunObject = Page "QB Tables Captions";
                    }



                    action("Asistente Configuraci¢n Campos Obligatorios")
                    {
                        Caption = 'Asistente Configuraci¢n Campos Obligatorios';
                        ApplicationArea = all;
                        RunObject = Page "QB Tables Mandatory Fields";
                    }



                    action("Asistente Configuraci¢n Dimensiones Tablas")
                    {
                        Caption = 'Asistente Configuraci¢n Dimensiones Tablas';
                        ApplicationArea = all;
                        RunObject = Page "QB Tables Automatic Dimensions";
                    }



                    action("Asistente Configuraci¢n de Usuarios")
                    {
                        Caption = 'Asistente Configuraci¢n de Usuarios';
                        ApplicationArea = all;
                        RunObject = Page "QB Manage Users";
                    }



                    action("Usuarios del Departamento")
                    {
                        Caption = 'Usuarios del Departamento';
                        ApplicationArea = all;
                        RunObject = Page "QB Organization Department";
                    }



                    action("Configuraci¢n c¢digos origen")
                    {
                        Caption = 'Configuraci¢n c¢digos origen';
                        ApplicationArea = all;
                        RunObject = Page 279;
                    }



                    action("Informaci¢n empresa")
                    {
                        Caption = 'Informaci¢n empresa';
                        ApplicationArea = all;
                        RunObject = Page 1;
                    }



                    action("Conf. compras y pagos")
                    {
                        Caption = 'Conf. compras y pagos';
                        ApplicationArea = all;
                        RunObject = Page 460;
                    }



                    action("C¢digos de Agrupaci¢n")
                    {
                        Caption = 'C¢digos de Agrupaci¢n';
                        ApplicationArea = all;
                        RunObject = Page "QB Groupings Codes";
                    }



                    action("Siglas de las Calles")
                    {
                        Caption = 'Siglas de las Calles';
                        ApplicationArea = all;
                        RunObject = Page "Siglas";
                    }


                }
                group("Payment Notes")
                {
                    Caption = 'Payment Notes';


                    action("Relaciones de Cobros")
                    {
                        Caption = 'Relaciones de Cobros';
                        ApplicationArea = all;
                        RunObject = Page "QB Debit Relations List";
                    }



                    action("Journals1")
                    {
                        Caption = 'Journals';
                        ApplicationArea = all;
                        RunObject = Page 253;
                    }



                    action("Invoices1")
                    {
                        Caption = 'Invoices';
                        ApplicationArea = all;
                        RunObject = Page 9301;
                    }



                    action("Credit Memos1")
                    {
                        Caption = 'Credit Memos';
                        ApplicationArea = all;
                        RunObject = Page 9302;
                    }



                    action("Clientes")
                    {
                        Caption = 'Clientes';
                        ApplicationArea = all;
                        RunObject = Page 22;
                    }



                    action("Configuraci¢n relaciones de cobros")
                    {
                        Caption = 'Configuraci¢n relaciones de cobros';
                        ApplicationArea = all;
                        RunObject = Page "QB Debit Relations Setup";
                    }


                }
                group("History")
                {
                    Caption = 'History';


                    action("Relaciones de Cobros Registradas")
                    {
                        Caption = 'Relaciones de Cobros Registradas';
                        ApplicationArea = all;
                        RunObject = Page "QB Debit Relations Closed";
                    }



                    action("Posted Invoices")
                    {
                        Caption = 'Posted Invoices';
                        ApplicationArea = all;
                        RunObject = Page 143;
                    }



                    action("Posted Credit Memos4")
                    {
                        Caption = 'Posted Credit Memos';
                        ApplicationArea = all;
                        RunObject = Page 144;
                    }


                }
                group("Auxiliary tables")
                {
                    Caption = 'Auxiliary tables';

                }
                group("Payment Notes1")
                {
                    Caption = 'Payment Notes';


                    action("Lista de Pagos1")
                    {
                        Caption = 'Lista de Pagos';
                        ApplicationArea = all;
                        RunObject = Page "QB Crear Efectos";
                    }



                    action("Lista de Pagos")
                    {
                        Caption = 'Lista de Pagos';
                        ApplicationArea = all;
                        RunObject = Page "QB Efectos Creados";
                    }



                    action("Relaci¢n de Efectos")
                    {
                        Caption = 'Relaci¢n de Efectos';
                        ApplicationArea = all;
                        RunObject = Page "QB Liquidar Efectos";
                    }



                    action("Relaci¢n de Efecto2")
                    {
                        Caption = 'Relaci¢n de Efectos';
                        ApplicationArea = all;
                        RunObject = Page "QB Efectos Liquidados";
                    }



                    action("Vendors3")
                    {
                        Caption = 'Vendors';
                        ApplicationArea = all;
                        RunObject = Page 27;
                    }



                    action("Payment Journals")
                    {
                        Caption = 'Payment Journals';
                        ApplicationArea = all;
                        RunObject = Page 256;
                    }



                    action("Docs. a pagar en Cartera1")
                    {
                        Caption = 'Docs. a pagar en Cartera';
                        ApplicationArea = all;
                        RunObject = Page "QB Documentos en cartera";
                    }



                    action("Docs. a pagar en Cartera2")
                    {
                        Caption = 'Docs. a pagar en Cartera';
                        ApplicationArea = all;
                        RunObject = Page "QB Efectos anticipados";
                    }



                    action("Docs. a pagar en Cartera")
                    {
                        Caption = 'Docs. a pagar en Cartera';
                        ApplicationArea = all;
                        RunObject = Page "QB Efectos anticipados Liq";
                    }



                    action("Configuraci¢n relaciones de pago")
                    {
                        Caption = 'Configuraci¢n relaciones de pago';
                        ApplicationArea = all;
                        RunObject = Page "QB Credit Relations Setup";
                    }


                }
                group("Warehouse")
                {
                    Caption = 'Warehouse';

                }
                group("Setup1")
                {
                    Caption = 'Setup';

                }
                group("External workers time sheets")
                {
                    Caption = 'External workers time sheets';


                    action("Lista partes de trabajo")
                    {
                        Caption = 'Lista partes de trabajo';
                        ApplicationArea = all;
                        RunObject = Page "QB External Worksheet List";
                    }



                    action("Lista partes de trabajo Registrados")
                    {
                        Caption = 'Lista partes de trabajo Registrados';
                        ApplicationArea = all;
                        RunObject = Page "QB External Worksheet List Pos";
                    }



                    action("Recursos1")
                    {
                        Caption = 'Recursos';
                        ApplicationArea = all;
                        RunObject = Page 77;
                    }



                    action("L¡neas de partes registrados")
                    {
                        Caption = 'L¡neas de partes registrados';
                        ApplicationArea = all;
                        RunObject = Page "QB External Worksheet Pos List";
                    }


                }
                group("Wizards")
                {
                    Caption = 'Wizards';

                }
                group("Confirming and Factoring")
                {
                    Caption = 'Confirming and Factoring';


                    action("L¡neas de confirming1")
                    {
                        Caption = 'L¡neas de confirming';
                        ApplicationArea = all;
                        RunObject = Page "QB Confirming Lines List";
                    }



                    action("Bank Accounts")
                    {
                        Caption = 'Bank Accounts';
                        ApplicationArea = all;
                        RunObject = Page 371;
                    }



                    action("L¡neas de confirming")
                    {
                        Caption = 'L¡neas de confirming';
                        ApplicationArea = all;
                        RunObject = Page "QB Factoring Lines List";
                    }



                    action("Customers")
                    {
                        Caption = 'Customers';
                        ApplicationArea = all;
                        RunObject = Page 22;
                    }


                }
                group("Stock uses")
                {
                    Caption = 'Stock uses';


                    action("Salidas del almac‚n auxiliar")
                    {
                        Caption = 'Salidas del almac‚n auxiliar';
                        ApplicationArea = all;
                        RunObject = Page "QB Aux. Loc.Out. Shipment List";
                    }



                    action("Hist¢rico salidas almac‚n auxiliar")
                    {
                        Caption = 'Hist¢rico salidas almac‚n auxiliar';
                        ApplicationArea = all;
                        RunObject = Page "Post. Aux. Loc.Out. Ship. List";
                    }


                }
                group("Pedidos de Servicio")
                {
                    Caption = 'Pedidos de Servicio';


                    action("QB Lista Pedidos Sevicio")
                    {
                        Caption = 'QB Lista Pedidos Sevicio';
                        ApplicationArea = all;
                        RunObject = Page "QB Service Order List";
                    }



                    action("QB Revisiones precio x proyecto")
                    {
                        Caption = 'QB Revisiones precio x proyecto';
                        ApplicationArea = all;
                        RunObject = Page "QB Price x job reviews";
                    }



                    action("QB Tipos pedido servicio")
                    {
                        Caption = 'QB Tipos pedido servicio';
                        ApplicationArea = all;
                        RunObject = Page "QB Service Order Types";
                    }



                    action("QB Gropuing Criteria List")
                    {
                        Caption = 'QB Gropuing Criteria List';
                        ApplicationArea = all;
                        RunObject = Page "QB Gropuing Criteria List";
                    }



                    action("QB Lista Pedido Servicio Registrado2")
                    {
                        Caption = 'QB Lista Pedido Servicio Registrado';
                        ApplicationArea = all;
                        RunObject = Page "QB Post. Service Order List";
                    }



                    action("QB Lista Pedido Servicio Registrado3")
                    {
                        Caption = 'QB Lista Pedido Servicio Registrado';
                        ApplicationArea = all;
                        //file missing
                        // RunObject = Page "QB Serv. Order Invoiced List";
                    }



                    action("Ventas/Costes pedidos servicio")
                    {
                        Caption = 'Ventas/Costes pedidos servicio';
                        ApplicationArea = all;
                        RunObject = Page "LM Rental Element";
                    }



                    action("Lista valoraciones desglosado")
                    {
                        Caption = 'Lista valoraciones desglosado';
                        ApplicationArea = all;
                        RunObject = Page "Rental Elements Card";
                    }



                    action("Fact. Pedidos Servicio")
                    {
                        Caption = 'Fact. Pedidos Servicio';
                        ApplicationArea = all;
                        RunObject = Page "Rental Elements List";
                    }


                }

                action("Location")
                {
                    Caption = 'Location';
                    ApplicationArea = all;
                    RunObject = Page "Quotes Rejected";
                }



                action("Almac‚n 2")
                {
                    Caption = 'Almac‚n 2';
                    ApplicationArea = all;
                    RunObject = Page "Element Journal Sections";
                }



                action("Warehouse Invoices")
                {
                    Caption = 'Warehouse Invoices';
                    ApplicationArea = all;
                    RunObject = Page "Hist. Head. Deliv Element List";
                }



                action("Lista albaran salida")
                {
                    Caption = 'Lista albaran salida';
                    ApplicationArea = all;
                    RunObject = Page "Output Shipment List";
                }



                action("Hist. Lista albaran salida")
                {
                    Caption = 'Hist. Lista albaran salida';
                    ApplicationArea = all;
                    RunObject = Page "Posted Output Shipment List";
                }



                action("Lista Recepci¢n/Traspaso")
                {
                    Caption = 'Lista Recepci¢n/Traspaso';
                    ApplicationArea = all;
                    RunObject = Page "QB Receipt/Transfer List";
                }



                action("Lista Recepci¢n/Traspaso registrados")
                {
                    Caption = 'Lista Recepci¢n/Traspaso registrados';
                    ApplicationArea = all;
                    RunObject = Page "QB Post. Receipt/Transfer List";
                }



                action("Productos por almac‚n")
                {
                    Caption = 'Productos por almac‚n';
                    ApplicationArea = all;
                    RunObject = Page "QB Items by Location";
                }



                action("Prestados")
                {
                    Caption = 'Prestados';
                    ApplicationArea = all;
                    RunObject = Page "QB Ceded List";
                }



                action("Lista mov. prestados")
                {
                    Caption = 'Lista mov. prestados';
                    ApplicationArea = all;
                    RunObject = Page "QB Ceded Entry List";
                }



                action("Coste unitario Producto")
                {
                    Caption = 'Coste unitario Producto';
                    ApplicationArea = all;
                    RunObject = Page "Rental Elements Statistics";
                }



                action("Productos cedidos")
                {
                    Caption = 'Productos cedidos';
                    ApplicationArea = all;
                    RunObject = Page "Chronovision Rental Elements";
                }

                group("Almac‚n Central")
                {
                    Caption = 'Almac‚n Central';

                }
                group("Almac‚n de Obra")
                {
                    Caption = 'Almac‚n de Obra';

                }
                group("Advanced payment")
                {
                    Caption = 'Advanced payment';


                    action("Anticipos de Proyecto")
                    {
                        Caption = 'Anticipos de Proyecto';
                        ApplicationArea = all;
                        RunObject = Page "QB Job Prepayment List";
                    }



                    action("Tipo de Prepago")
                    {
                        Caption = 'Tipo de Prepago';
                        ApplicationArea = all;
                        RunObject = Page "QB Job Prepayment Types";
                    }



                    action("Configuraci¢n de Anticipos")
                    {
                        Caption = 'Configuraci¢n de Anticipos';
                        ApplicationArea = all;
                        RunObject = Page "QB Job Prepayment Setup";
                    }


                }

                action("Documentos Ptes. en Remesas Cobro")
                {
                    Caption = 'Documentos Ptes. en Remesas Cobro';
                    ApplicationArea = all;
                    RunObject = Page "QB Docs. in Posted BG Subform";
                }



                action("Documentos Ptes. en O.Pago")
                {
                    Caption = 'Documentos Ptes. en O.Pago';
                    ApplicationArea = all;
                    RunObject = Page "QB Docs. in Posted PO";
                }

                group("Prorrata de IVA")
                {
                    Caption = 'Prorrata de IVA';


                    action("Configuraci¢n prorrata")
                    {
                        Caption = 'Configuraci¢n prorrata';
                        ApplicationArea = all;
                        RunObject = Page "DP Setup";
                    }


                }
            }
            group("Presupuestos")
            {
                Caption = 'Presupuestos';
                group("Planificaci¢n")
                {
                    Caption = 'Planificaci¢n';


                    action("Lista de Presupuestos")
                    {
                        Caption = 'Lista de Presupuestos';
                        ApplicationArea = all;
                        RunObject = Page "QPR Budget Jobs List";
                    }



                    action("Plantillas de presupuestos")
                    {
                        Caption = 'Plantillas de presupuestos';
                        ApplicationArea = all;
                        RunObject = Page "QPR Budget Template List";
                    }



                    action("Lista de Presupuestos Archivados")
                    {
                        Caption = 'Lista de Presupuestos Archivados';
                        ApplicationArea = all;
                        RunObject = Page "QPR Budget Jobs List Archived";
                    }


                }
                group("Configuraci¢n")
                {
                    Caption = 'Configuraci¢n';


                    action("Configuraci¢n de Presupuestos")
                    {
                        Caption = 'Configuraci¢n de Presupuestos';
                        ApplicationArea = all;
                        RunObject = Page "QPR Budgets Setup";
                    }



                    action("Estados internos1")
                    {
                        Caption = 'Estados internos';
                        ApplicationArea = all;
                        RunObject = Page "Jobs Status List";
                    }



                    action("Asistente Configuraci¢n Aprobaciones1")
                    {
                        Caption = 'Asistente Configuraci¢n Aprobaciones';
                        ApplicationArea = all;
                        RunObject = Page "QB Approval Assistant";
                    }


                }
                group("Activaci¢n de Gastos")
                {
                    Caption = 'Activaci¢n de Gastos';


                    action("Conf. Activaci¢n de Gastos")
                    {
                        Caption = 'Conf. Activaci¢n de Gastos';
                        ApplicationArea = all;
                        RunObject = Page "QB Activable Expenses Setup";
                    }



                    action("Lista de Activaci¢n de Gastos")
                    {
                        Caption = 'Lista de Activaci¢n de Gastos';
                        ApplicationArea = all;
                        RunObject = Page "QB Expenses Activation List";
                    }


                }
                group("New Group")
                {
                    Caption = 'New Group';

                }

                action("Delete Orphaned Record Links")
                {
                    Caption = 'Delete Orphaned Record Links';
                    ApplicationArea = all;
                    RunObject = Page 447;
                }



                action("Cost Account Allocation")
                {
                    Caption = 'Cost Account Allocation';
                    ApplicationArea = all;
                    RunObject = Page 1104;
                }



                action("349 Declaration Labels")
                {
                    Caption = '349 Declaration Labels';
                    ApplicationArea = all;
                    // RunObject = Page 10709;
                }



                action("Make 340 Declaration")
                {
                    Caption = 'Make 340 Declaration';
                    ApplicationArea = all;
                    // RunObject = Page 10743;
                }



                action("SII Requests History")
                {
                    Caption = 'SII Requests History';
                    ApplicationArea = all;
                    RunObject = Page "SII History";
                }



                action("Old Acc. - Official Acc. Book")
                {
                    Caption = 'Old Acc. - Official Acc. Book';
                    ApplicationArea = all;
                    // RunObject = page 10726;
                }



                action("Old Official Acc. Sum. Book")
                {
                    Caption = 'Old Official Acc. Sum. Book';
                    ApplicationArea = all;
                    // RunObject = Page 10727;
                }



                action("Export Hist. Consolidation")
                {
                    Caption = 'Export Hist. Consolidation';
                    ApplicationArea = all;
                    RunObject = Page "Gen. Prod. Post. Selection 340";
                }



                action("Customer - Overdue Payments")
                {
                    Caption = 'Customer - Overdue Payments';
                    ApplicationArea = all;
                    // RunObject = Page 10747;
                }


                group("QuoFacturae1")
                {
                    Caption = 'QuoFacturae';


                    action("QuoFacturae Setup")
                    {
                        Caption = 'QuoFacturae Setup';
                        ApplicationArea = all;
                        RunObject = Page "QuoFacturae Setup";
                    }



                    action("Factura-e entries1")
                    {
                        Caption = 'Factura-e entries';
                        ApplicationArea = all;
                        RunObject = Page "QuoFacturae entries";
                    }



                    action("Administrative centers1")
                    {
                        Caption = 'Administrative centers';
                        ApplicationArea = all;
                        RunObject = Page "QuoFacturae Adm. centers";
                    }

                }
                group("Drag&Drop1")
                {
                    Caption = 'Drag&Drop';


                    action("Log. ficheros factbox")
                    {
                        Caption = 'Log. ficheros factbox';
                        ApplicationArea = all;
                        RunObject = Page "Log. Files factbox SP";
                    }



                    action("Log. Ficheros a Sharepoint1")
                    {
                        Caption = 'Log. Ficheros a Sharepoint';
                        ApplicationArea = all;
                        RunObject = Page "Log. DragDrop Sharepoint";
                    }



                    action("Config. Arrastrar y soltar Sharepoint1")
                    {
                        Caption = 'Config. Arrastrar y soltar Sharepoint';
                        ApplicationArea = all;
                        RunObject = Page "DragDrop SP Setup";
                    }



                    action("Definici¢n Sitio Sharepoint Lista1")
                    {
                        Caption = 'Definici¢n Sitio Sharepoint Lista';
                        ApplicationArea = all;
                        RunObject = Page "Definition Sharepoint List";
                    }

                }
                group("QuoSII1")
                {
                    Caption = 'QuoSII';


                    action("Documentos1")
                    {
                        Caption = 'Documentos';
                        ApplicationArea = all;
                        RunObject = Page "SII Documents List";
                    }



                    action("Env¡os1")
                    {
                        Caption = 'Env¡os';
                        ApplicationArea = all;
                        RunObject = Page "SII Document Ship List";
                    }



                    action("Infome SII1")
                    {
                        Caption = 'Infome SII';
                        ApplicationArea = all;
                        RunObject = Page "SII Document Ship List";
                    }



                    action("Contraste SII1")
                    {
                        Caption = 'Contraste SII';
                        ApplicationArea = all;
                        RunObject = Page "SII Type";
                    }



                    action("Configuraci¢n QuoSII1")
                    {
                        Caption = 'Configuraci¢n QuoSII';
                        ApplicationArea = all;
                        RunObject = Page "SII Configuration";
                    }



                    action("SII Tipos1")
                    {
                        Caption = 'SII Tipos';
                        ApplicationArea = all;
                        RunObject = Page "SII Type";
                    }



                    action("Hist¢rico facturas de compra1")
                    {
                        Caption = 'Hist¢rico facturas de compra';
                        ApplicationArea = all;
                        RunObject = Page 146;
                    }



                    action("Lista hist. abono compra1")
                    {
                        Caption = 'Lista hist. abono compra';
                        ApplicationArea = all;
                        RunObject = Page 147;
                    }



                    action("Lista hist. facturas venta1")
                    {
                        Caption = 'Lista hist. facturas venta';
                        ApplicationArea = all;
                        RunObject = Page 143;
                    }



                    action("Lista hist. abono venta")
                    {
                        Caption = 'Lista hist. abono venta';
                        ApplicationArea = all;
                        RunObject = Page 144;
                    }

                }
                group("Sincronizar Empresas1")
                {
                    Caption = 'Sincronizar Empresas';


                    action("Sincronizar Empresas: Exportaci¢n1")
                    {
                        Caption = 'Sincronizar Empresas: Exportaci¢n';
                        ApplicationArea = all;
                        RunObject = Page "QuoSync Send";
                    }



                    action("Sincronizar Empresas: Recibir1")
                    {
                        Caption = 'Sincronizar Empresas: Recibir';
                        ApplicationArea = all;
                        RunObject = Page "QuoSync Received";
                    }



                    action("Sincronizar Empresas: Tabla externa1")
                    {
                        Caption = 'Sincronizar Empresas: Tabla externa';
                        ApplicationArea = all;
                        RunObject = Page "QuoSync Send External";
                    }



                    action("Sincronizar Empresas: Tablas")
                    {
                        Caption = 'Sincronizar Empresas: Tablas';
                        ApplicationArea = all;
                        RunObject = Page "QuoSync Setup";
                    }

                }
                group("Importar/Exportar1")
                {
                    Caption = 'Importar/Exportar';


                    action("Exportaci¢n de datos1")
                    {
                        Caption = 'Exportaci¢n de datos';
                        ApplicationArea = all;
                        RunObject = Page "Journal Template (Element)";
                    }



                    action("Configuraci¢n de Tablas1")
                    {
                        Caption = 'Configuraci¢n de Tablas';
                        ApplicationArea = all;
                        RunObject = Page "QB Generic Import - Tables";
                    }



                    action("Replacements1")
                    {
                        Caption = 'Replacements';
                        ApplicationArea = all;
                        RunObject = Page "QB Replacements";
                    }



                    action("Importaci¢n de datos")
                    {
                        Caption = 'Importaci¢n de datos';
                        ApplicationArea = all;
                        RunObject = Page "Element Entry Registry";
                    }



                    action("Documentos Ptes. en Remesas Cobro1")
                    {
                        Caption = 'Documentos Ptes. en Remesas Cobro';
                        ApplicationArea = all;
                        RunObject = Page "QB Docs. in Posted BG Subform";
                    }



                    action("Documentos Ptes. en O.Pago1")
                    {
                        Caption = 'Documentos Ptes. en O.Pago';
                        ApplicationArea = all;
                        RunObject = Page "QB Docs. in Posted PO";
                    }

                    group("Purchases1")
                    {
                        Caption = 'Purchases';


                        action("Vendors1")
                        {
                            Caption = 'Vendors';
                            ApplicationArea = all;
                            RunObject = Page 27;
                        }



                        action("Lista datos proveedor1")
                        {
                            Caption = 'Lista datos proveedor';
                            ApplicationArea = all;
                            RunObject = Page "Vendor Data List";
                        }



                        action("Lista de contratos marco1")
                        {
                            Caption = 'Lista de contratos marco';
                            ApplicationArea = all;
                            RunObject = Page "QB Framework Contracts";
                        }



                        action("Lista Contratos Marco Usados1")
                        {
                            Caption = 'Lista Contratos Marco Usados';
                            ApplicationArea = all;
                            RunObject = Page "QB Framework Contr. Closed";
                        }



                        action("Control Contratos1")
                        {
                            Caption = 'Control Contratos';
                            ApplicationArea = all;
                            RunObject = Page "Contracts Control List";
                        }



                        action("Recepcion de Facturas de compra1")
                        {
                            Caption = 'Recepcion de Facturas de compra';
                            ApplicationArea = all;
                            RunObject = Page "Receipt Purchase Invoices List";
                        }



                        action("Verificar documentaci¢n Doc. Compras1")
                        {
                            Caption = 'Verificar documentaci¢n Doc. Compras';
                            ApplicationArea = all;
                            RunObject = Page "QB Purchases Check";
                        }



                        action("Albaranes pendientes de facturar1")
                        {
                            Caption = 'Albaranes pendientes de facturar';
                            ApplicationArea = all;
                            RunObject = Page "QB Job Responsibles List";
                        }



                        action("Situaci¢n de Proveedores1")
                        {
                            Caption = 'Situaci¢n de Proveedores';
                            ApplicationArea = all;
                            RunObject = Page "Status Draft Counter Elem FB";
                        }



                        action("Lista comparativo ofertas1")
                        {
                            Caption = 'Lista comparativo ofertas';
                            ApplicationArea = all;
                            RunObject = Page "Comparative Quote List";
                        }



                        action("Pedidos abiertos compra1")
                        {
                            Caption = 'Pedidos abiertos compra';
                            ApplicationArea = all;
                            RunObject = Page 9310;
                        }



                        action("Pedidos compra1")
                        {
                            Caption = 'Pedidos compra';
                            ApplicationArea = all;
                            RunObject = Page 9307;
                        }



                        action("Pedidos dev. compra1")
                        {
                            Caption = 'Pedidos dev. compra';
                            ApplicationArea = all;
                            RunObject = Page 9311;
                        }



                        action("Facturas compra1")
                        {
                            Caption = 'Facturas compra';
                            ApplicationArea = all;
                            RunObject = Page 9308;
                        }



                        action("Abonos de compra1")
                        {
                            Caption = 'Abonos de compra';
                            ApplicationArea = all;
                            RunObject = Page 9309;
                        }



                        action("Lista de proformas1")
                        {
                            Caption = 'Lista de proformas';
                            ApplicationArea = all;
                            RunObject = Page "QB Proform List";
                        }



                        action("Hist¢rico albaranes de compra1")
                        {
                            Caption = 'Hist¢rico albaranes de compra';
                            ApplicationArea = all;
                            RunObject = Page 145;
                        }



                        action("Posted Invoices1")
                        {
                            Caption = 'Posted Invoices';
                            ApplicationArea = all;
                            RunObject = Page 146;
                        }



                        action("Posted Credit Memos1")
                        {
                            Caption = 'Posted Credit Memos';
                            ApplicationArea = all;
                            RunObject = Page 147;
                        }



                        action("Lista comparativo ofertas Registrados1")
                        {
                            Caption = 'Lista comparativo ofertas Registrados';
                            ApplicationArea = all;
                            RunObject = Page "Comparative Quote List Post";
                        }



                        action("Lista comparativo ofertas Cerradas1")
                        {
                            Caption = 'Lista comparativo ofertas Cerradas';
                            ApplicationArea = all;
                            RunObject = Page "Comparative Quote List Closed";
                        }



                        action("Imputar albaranes pendientes1")
                        {
                            Caption = 'Imputar albaranes pendientes';
                            ApplicationArea = all;
                            RunObject = Page "Trancking Materials Purchase";
                        }



                        action("Revisi¢n de Compras1")
                        {
                            Caption = 'Revisi¢n de Compras';
                            ApplicationArea = all;
                            RunObject = Page "Subform. Posted Element Contra";
                        }


                    }
                }
            }
            group("Real Estate")
            {
                Caption = 'Real Estate';
                group("Real Estate1")
                {
                    Caption = 'Real Estate';


                    action("Lista de Activos Inmobiliarios")
                    {
                        Caption = 'Lista de Activos Inmobiliarios';
                        ApplicationArea = all;
                        RunObject = Page "RE Active List";
                    }



                    action("Configuraci¢n de Proyectos Inmobiliarios")
                    {
                        Caption = 'Configuraci¢n de Proyectos Inmobiliarios';
                        ApplicationArea = all;
                        RunObject = Page "RE Setup";
                    }



                    action("Lista de Activos Inmobiliarios Archivados")
                    {
                        Caption = 'Lista de Activos Inmobiliarios Archivados';
                        ApplicationArea = all;
                        RunObject = Page "RE Active List Archived";
                    }


                }
                group("Activaci¢n de Gastos1")
                {
                    Caption = 'Activaci¢n de Gastos';


                    action("Lista de Activaci¢n de Gastos1")
                    {
                        Caption = 'Lista de Activaci¢n de Gastos';
                        ApplicationArea = all;
                        RunObject = Page "QB Expenses Activation List";
                    }



                    action("Conf. Activaci¢n de Gastos1")
                    {
                        Caption = 'Conf. Activaci¢n de Gastos';
                        ApplicationArea = all;
                        RunObject = Page "QB Activable Expenses Setup";
                    }


                }
                group("Purchases2")
                {
                    Caption = 'Purchases';


                    action("Vendors2")
                    {
                        Caption = 'Vendors';
                        ApplicationArea = all;
                        RunObject = Page 27;
                    }



                    action("Lista datos proveedor2")
                    {
                        Caption = 'Lista datos proveedor';
                        ApplicationArea = all;
                        RunObject = Page "Vendor Data List";
                    }



                    action("Lista de contratos marco2")
                    {
                        Caption = 'Lista de contratos marco';
                        ApplicationArea = all;
                        RunObject = Page "QB Framework Contracts";
                    }



                    action("Lista Contratos Marco Usados2")
                    {
                        Caption = 'Lista Contratos Marco Usados';
                        ApplicationArea = all;
                        RunObject = Page "QB Framework Contr. Closed";
                    }



                    action("Control Contratos2")
                    {
                        Caption = 'Control Contratos';
                        ApplicationArea = all;
                        RunObject = Page "Contracts Control List";
                    }



                    action("Recepcion de Facturas de compra2")
                    {
                        Caption = 'Recepcion de Facturas de compra';
                        ApplicationArea = all;
                        RunObject = Page "Receipt Purchase Invoices List";
                    }



                    action("Verificar documentaci¢n Doc. Compras2")
                    {
                        Caption = 'Verificar documentaci¢n Doc. Compras';
                        ApplicationArea = all;
                        RunObject = Page "QB Purchases Check";
                    }



                    action("Albaranes pendientes de facturar2")
                    {
                        Caption = 'Albaranes pendientes de facturar';
                        ApplicationArea = all;
                        RunObject = Page "QB Job Responsibles List";
                    }



                    action("Situaci¢n de Proveedores2")
                    {
                        Caption = 'Situaci¢n de Proveedores';
                        ApplicationArea = all;
                        RunObject = Page "Status Draft Counter Elem FB";
                    }



                    action("Lista comparativo ofertas2")
                    {
                        Caption = 'Lista comparativo ofertas';
                        ApplicationArea = all;
                        RunObject = Page "Comparative Quote List";
                    }



                    action("Pedidos abiertos compra2")
                    {
                        Caption = 'Pedidos abiertos compra';
                        ApplicationArea = all;
                        RunObject = Page 9310;
                    }



                    action("Pedidos compra2")
                    {
                        Caption = 'Pedidos compra';
                        ApplicationArea = all;
                        RunObject = Page 9307;
                    }



                    action("Pedidos dev. compra2")
                    {
                        Caption = 'Pedidos dev. compra';
                        ApplicationArea = all;
                        RunObject = Page 9311;
                    }



                    action("Facturas compra2")
                    {
                        Caption = 'Facturas compra';
                        ApplicationArea = all;
                        RunObject = Page 9308;
                    }



                    action("Abonos de compra2")
                    {
                        Caption = 'Abonos de compra';
                        ApplicationArea = all;
                        RunObject = Page 9309;
                    }



                    action("Lista de proformas2")
                    {
                        Caption = 'Lista de proformas';
                        ApplicationArea = all;
                        RunObject = Page "QB Proform List";
                    }



                    action("Hist¢rico albaranes de compra2")
                    {
                        Caption = 'Hist¢rico albaranes de compra';
                        ApplicationArea = all;
                        RunObject = Page 145;
                    }



                    action("Posted Invoices2")
                    {
                        Caption = 'Posted Invoices';
                        ApplicationArea = all;
                        RunObject = Page 146;
                    }



                    action("Posted Credit Memos2")
                    {
                        Caption = 'Posted Credit Memos';
                        ApplicationArea = all;
                        RunObject = Page 147;
                    }



                    action("Lista comparativo ofertas Registrados2")
                    {
                        Caption = 'Lista comparativo ofertas Registrados';
                        ApplicationArea = all;
                        RunObject = Page "Comparative Quote List Post";
                    }



                    action("Lista comparativo ofertas Cerradas2")
                    {
                        Caption = 'Lista comparativo ofertas Cerradas';
                        ApplicationArea = all;
                        RunObject = Page "Comparative Quote List Closed";
                    }



                    action("Imputar albaranes pendientes2")
                    {
                        Caption = 'Imputar albaranes pendientes';
                        ApplicationArea = all;
                        RunObject = Page "Trancking Materials Purchase";
                    }



                    action("Revisi¢n de Compras2")
                    {
                        Caption = 'Revisi¢n de Compras';
                        ApplicationArea = all;
                        RunObject = Page "Subform. Posted Element Contra";
                    }


                }
            }
            group("Master Data")
            {
                Caption = 'Master Data';


                action("Conf. Sincronizaci¢n Empresas1")
                {
                    Caption = 'Conf. Sincronizaci¢n Empresas';
                    ApplicationArea = all;
                    RunObject = Page "QM MasterData Setup";
                }



                action("Asistente Lista tablas de Configuraci¢n")
                {
                    Caption = 'Asistente Lista tablas de Configuraci¢n';
                    ApplicationArea = all;
                    RunObject = Page "QM MasterData Setup Tables";
                }



                action("Conf. Sincronizaci¢n Empresas")
                {
                    Caption = 'Conf. Sincronizaci¢n Empresas';
                    ApplicationArea = all;
                    RunObject = Page "QM MasterData Setup Companyes";
                }



                action("Configuraci¢n Empresa/Tabla")
                {
                    Caption = 'Configuraci¢n Empresa/Tabla';
                    ApplicationArea = all;
                    RunObject = Page "QM MasterData Table/Company";
                }



                action("MasterData Tablas de Configuraci¢n")
                {
                    Caption = 'MasterData Tablas de Configuraci¢n';
                    ApplicationArea = all;
                    RunObject = Page "QM MasterData Conf. Tables";
                }


            }
        }
    }
}
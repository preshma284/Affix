//page eliminated in newer version- check VersionList - ELIMINAR
// page 7206992 "OLD_QB Approvals Assistant"
// {
// CaptionML=ENU='Approvals Assitant',ESP='Asistente Configuraci¢n Aprobaciones';
//     PageType=Card;
    
//   layout
// {
// area(content)
// {
// group("group7")
// {
        
//                 CaptionML=ENU='General',ESP='Configuraci¢n';
// grid("group8")
// {
        
//                 CaptionML=ENU='General',ESP='General';
//                 GridLayout=Columns ;
//     field("Activar";Usuarios)
//     {
        
//                 CaptionML=ESP='Usuarios por proyecto';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("TemplateName";TemplateName)
//     {
        
//                 CaptionML=ESP='Nombre Plantilla general';
                
//                             ;trigger OnValidate()    BEGIN
//                              IF (TemplateName <> oldTemplateName) THEN BEGIN
//                                IF (CONFIRM('Si cambia el nombre se cambiar  en todos los lugares donde se use. Confirme la acci¢n', FALSE)) THEN BEGIN
//                                  SetData;
//                                  ChangeName;
//                                END ELSE
//                                  TemplateName := oldTemplateName;
//                              END;
//                            END;


//     }

// }
// grid("group11")
// {
        
//                 CaptionML=ENU='General',ESP='Aprobaciones por Proyecto';
//                 GridLayout=Columns ;
//     field("version";Versiones)
//     {
        
//                 CaptionML=ENU='No.',ESP='1. Versiones de estudios';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("comparativo";Comparativos)
//     {
        
//                 CaptionML=ESP='2. Comparativos';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
// group("group14")
// {
        
// grid("group15")
// {
        
//                 GridLayout=Rows ;
// group("group16")
// {
        
//                 CaptionML=ESP='3. Pedidos de compra';
//     field("pedido";Pedidos)
//     {
        
//                 CaptionML=ESP='Pedidos de Compra';
                

//                 ShowCaption=false ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("NroPedidos";NroPedidos)
//     {
        
//                 Editable=edPedidos;
                

//                 ShowCaption=false ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }

// }

// }

// }
// group("group19")
// {
        
// grid("group20")
// {
        
//                 GridLayout=Rows ;
// group("group21")
// {
        
//                 CaptionML=ESP='4. Facturas de compra';
//     field("Facturas";Facturas)
//     {
        
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("NroFacturas";NroFacturas)
//     {
        
//                 Editable=edFacturas;
                

//                 ShowCaption=false ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }

// }

// }

// }
//     field("abonos";Abonos)
//     {
        
//                 CaptionML=ESP='A. Abonos de compra';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("certificacion";Mediciones)
//     {
        
//                 CaptionML=ESP='5. Certificaci¢n';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("gastos";NotaGasto)
//     {
        
//                 CaptionML=ESP='7. Notas de gastos';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("horas";Horas)
//     {
        
//                 CaptionML=ESP='8. Hojas de horas';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("trasp";Traspasos)
//     {
        
//                 CaptionML=ESP='9. Traspasos entre proyectos';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }

// }
// grid("group29")
// {
        
//                 CaptionML=ENU='General',ESP='Presupuestos';
//                 GridLayout=Columns ;
// group("group30")
// {
        
// grid("group31")
// {
        
//                 GridLayout=Rows ;
// group("group32")
// {
        
//                 CaptionML=ESP='B. Presupuestos';
//     field("Presup";Presupuestos)
//     {
        
//                 CaptionML=ESP='B. Presupuestos';
                

//                 ShowCaption=false ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("NroPresupuestos";NroPresupuestos)
//     {
        
//                 CaptionML=ESP='N§ de circuitos';
//                 Enabled=false;
//                 Editable=edPedidos;
                
//                             ;trigger OnValidate()    BEGIN
//                              //SetData;
//                            END;


//     }

// }

// }

// }

// }
// grid("group35")
// {
        
//                 CaptionML=ENU='General',ESP='Aprobaci¢n de Pagos por Proyecto';
//                 GridLayout=Columns ;
//     field("pago";Pagos)
//     {
        
//                 CaptionML=ESP='6. Pagos';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("FacMan";PagosManual)
//     {
        
//                 CaptionML=ESP='Solicitud Manual';
//                 ToolTipML=ESP='Si se desea que la aprobaci¢n de pagos de facturas relacionadas con obras se deba lance manualmente, si no se marca ser  autom tico';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("check1";Check[1])
//     {
        
//                 CaptionML=ESP='Check adicional 1';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("check2";Check[2])
//     {
        
//                 CaptionML=ESP='Check adicional 2';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("check3";Check[3])
//     {
        
//                 CaptionML=ESP='Check adicional 3';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("check4";Check[4])
//     {
        
//                 CaptionML=ESP='Check adicional 4';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }
//     field("check5";Check[5])
//     {
        
//                 CaptionML=ESP='Check adicional 5';
                
//                             ;trigger OnValidate()    BEGIN
//                              SetData;
//                            END;


//     }

// }

// }
// group("group43")
// {
        
//     part("ApprovalUserSetup";7206993)
//     {
        
//                 Visible=verUsuarios;
//     }
//     part("ResponsiblesTemplatesList";7206907)
//     {
        
//                 Visible=verResponsables;
//     }
//     part("part3";7207023)
//     {
        
//                 Visible=verGrupos;
//                 UpdatePropagation=Both 

//   ;
//     }

// }

// }
// }actions
// {
// area(Processing)
// {

//     action("action1")
//     {
//         CaptionML=ESP='Ver Grupos';
//                       Image=ViewJob;
                      
//                                 trigger OnAction()    BEGIN
//                                  verGrupos := TRUE;
//                                  verResponsables := FALSE;
//                                  verUsuarios := FALSE;
//                                END;


//     }
//     action("action2")
//     {
//         CaptionML=ESP='Ver Responsables';
//                       Visible=btnVerResp;
//                       Image=ViewJob;
                      
//                                 trigger OnAction()    BEGIN
//                                  verGrupos := FALSE;
//                                  verResponsables := TRUE;
//                                  verUsuarios := FALSE;
//                                END;


//     }
//     action("action3")
//     {
//         CaptionML=ESP='Ver Usuarios';
//                       Image=ViewJob;
                      
//                                 trigger OnAction()    BEGIN
//                                  verGrupos := FALSE;
//                                  verResponsables := FALSE;
//                                  verUsuarios := TRUE;
//                                END;


//     }
//     action("action4")
//     {
//         CaptionML=ESP='Ver Ambos';
//                       Image=ViewJob;
                      
                                
//     trigger OnAction()    BEGIN
//                                  verUsuarios := TRUE;
//                                  SetRespSub(TRUE);
//                                END;


//     }

// }
//         area(Promoted)
//         {
//             group(Category_Process)
//             {
//                 actionref(action1_Promoted; action1)
//                 {
//                 }
//                 actionref(action2_Promoted; action2)
//                 {
//                 }
//                 actionref(action3_Promoted; action3)
//                 {
//                 }
//                 actionref(action4_Promoted; action4)
//                 {
//                 }
//             }
//         }
// }
  
// trigger OnOpenPage()    BEGIN
//                  //Configurar los flujos, eventos y tablas auxiliares necesarias para las aprobaciones
//                  QBApprovalManagement.CreateSetup;

//                  //Ver Paneles de Resposables y de usuarios por defecto
//                  verUsuarios := TRUE;
//                  SetRespSub(TRUE);
//                END;

// trigger OnAfterGetCurrRecord()    BEGIN
//                            //Leer los datos de la configuraci¢n y los flujos
//                            GetData;
//                          END;



//     var
//       QBApprovalManagement : Codeunit 7207354;
//       edPedidos : Boolean;
//       edFacturas : Boolean;
//       verUsuarios : Boolean;
//       verResponsables : Boolean;
//       verGrupos : Boolean;
//       btnVerResp : Boolean;
//       TemplateName : Code[10];
//       oldTemplateName : Code[10];
//       "--------------------------- Cheks de aprobaci¢n" : Integer;
//       Usuarios : Boolean;
//       Versiones : Boolean;
//       Comparativos : Boolean;
//       Pedidos : Boolean;
//       NroPedidos : Integer;
//       Facturas : Boolean;
//       NroFacturas : Integer;
//       Abonos : Boolean;
//       Pagos : Boolean;
//       PagosManual : Boolean;
//       Check : ARRAY [5] OF Text;
//       Mediciones : Boolean;
//       NotaGasto : Boolean;
//       Horas : Boolean;
//       Traspasos : Boolean;
//       Presupuestos : Boolean;
//       NroPresupuestos : Integer;

//     LOCAL procedure GetData();
//     begin
//       //QBApprovalManagement.GetJobsApprovalsDataOLD(TemplateName,Usuarios,Versiones,Comparativos,Pedidos,NroPedidos,Facturas,NroFacturas,Abonos,Pagos,PagosManual,Check,Mediciones,NotaGasto,Horas,Traspasos,Presupuestos);
//       /////////////////////////////////////////(TemplateName, Usuarios, Versiones, Comparativos, Pedidos, Facturas, Abonos, Pagos, PagosManual, Check,
//       ///////////////////////////////////////// Mediciones, NotaGasto, Horas, Traspasos, Presupuestos, NroCircuitos);




//       SetEditables;
//       oldTemplateName := TemplateName;
//     end;

//     LOCAL procedure SetData();
//     begin

//       //QBApprovalManagement.SetJobsApprovalsDataOLD(TemplateName, Usuarios,Versiones,Comparativos,Pedidos,NroPedidos,Facturas,NroFacturas,Abonos,Pagos,PagosManual,Check,Mediciones,NotaGasto,Horas,Traspasos,Presupuestos);
//       /////////////////////////////////////////(TemplateName, Usuarios, Versiones, Comparativos, Pedidos, Facturas, Abonos, Pagos, PagosManual, Check,
//       ///////////////////////////////////////// Mediciones, NotaGasto, Horas, Traspasos, Presupuestos);
//       SetEditables;
//       CurrPage.UPDATE;
//     end;

//     LOCAL procedure SetEditables();
//     begin
//       edPedidos := Pedidos;
//       edFacturas := Facturas;
//     end;

//     LOCAL procedure SetRespSub(pSee : Boolean);
//     var
//       QBResponsiblesGroupTemplate : Record 52047;
//     begin
//       QBResponsiblesGroupTemplate.RESET;
//       verResponsables := (pSee) and (QBResponsiblesGroupTemplate.COUNT < 2);
//       verGrupos := (pSee) and (QBResponsiblesGroupTemplate.COUNT > 1);
//       btnVerResp := (pSee) and (QBResponsiblesGroupTemplate.COUNT < 2);;
//     end;

//     LOCAL procedure ChangeName();
//     var
//       W : Dialog;
//       QuoBuildingSetup : Record 7207278;
//       QBResponsiblesGroupTemplate : Record 52047;
//       ResponsiblesTemplate1 : Record 7206902;
//       ResponsiblesTemplate2 : Record 7206902;
//       GENCODE : TextConst ESP='GENERAL';
//     begin
//       if (oldTemplateName = '') then
//         exit;


//       if QBResponsiblesGroupTemplate.GET(TemplateName) then
//         ERROR('No puede usar un c¢digo existente');

//       if QBResponsiblesGroupTemplate."Use in" <> QBResponsiblesGroupTemplate."Use in"::All then
//         ERROR('La plantilla generica debe ser de tipo todos');

//       W.OPEN('Tipo: #1####################### Registro: #2#######################');
//       W.UPDATE(1,'Plantillas');

//       QBResponsiblesGroupTemplate.GET(oldTemplateName);
//       QBResponsiblesGroupTemplate.Code := TemplateName;
//       QBResponsiblesGroupTemplate.INSERT;

//       QBResponsiblesGroupTemplate.GET(oldTemplateName);
//       QBResponsiblesGroupTemplate.DELETE;

//       //Paso todos los registro al nuevo c¢digo
//       ResponsiblesTemplate1.RESET;
//       ResponsiblesTemplate1.SETRANGE(Code, oldTemplateName);
//       if (ResponsiblesTemplate1.FINDSET) then
//         repeat
//           W.UPDATE(2,ResponsiblesTemplate1.Code);

//           ResponsiblesTemplate2 := ResponsiblesTemplate1;
//           ResponsiblesTemplate2.Code := TemplateName;
//           ResponsiblesTemplate2.INSERT;

//           ResponsiblesTemplate1.DELETE;
//         until ResponsiblesTemplate1.NEXT = 0;

//       W.CLOSE;
//     end;

//     // begin//end
// }








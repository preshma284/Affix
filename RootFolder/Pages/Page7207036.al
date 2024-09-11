page 7207036 "QB Approval Assistant"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Approvals Assitant', ESP = 'Asistente Configuraci¢n Aprobaciones';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206994;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group8")
            {

                CaptionML = ENU = 'General Setup', ESP = 'Configuraci¢n General';
                field("Approvals 00 Enabled"; rec."Approvals 00 Enabled")
                {

                }
                field("Activar"; Usuarios)
                {

                    CaptionML = ESP = 'Usuarios por proyecto';
                }
                field("User Approve"; rec."User Approve")
                {

                    ToolTipML = ESP = 'Indica si el usuario aprueba solo seg�n su cargo (si est� varias veces en la cadena de aprobaci�n deber� aprobar todas las veces), o bien al aprobar una vez ya aprueba todas las veces que aparezca en la aprobaci�n';
                }
                field("Evaluation Order"; rec."Evaluation Order")
                {

                    ToolTipML = ESP = 'En que orden desea que se evaluen las condiciones de los circuitos de aprobaci�n';
                    Visible = false;
                }
                field("Send Mail For Approved"; rec."Send Mail For Approved")
                {

                    ToolTipML = ESP = 'Si marca este campo, se remitir� un mail al remitente de la aprobaci�n cuando el documento se haya aprobado';
                }
                group("group14")
                {

                    CaptionML = ESP = 'Ajustes';
                    field("Due Date for Approvals"; rec."Due Date for Approvals")
                    {

                        ToolTipML = ESP = 'Este campo indica cuando vencen las aprobaciones pendientes, se indica como "nD" donde n es el n�mero de d�as deseado seguida de la letra D. Si se deja en blanco vencen el mismo d�a que se emiten.';

                        ; trigger OnValidate()
                        BEGIN
                            AdjustFlows;
                        END;


                    }
                    field("Delegate After"; rec."Delegate After")
                    {

                        ToolTipML = ESP = 'Este campo indica cuantos d�as debe estar vencida una aprobaci�n para que pasen autom�ticamente al delegado del usuario.';

                        ; trigger OnValidate()
                        BEGIN
                            AdjustFlows;
                        END;


                    }
                    field("Show Confirmation Message"; rec."Show Confirmation Message")
                    {

                        ToolTipML = ESP = 'Este campo indica si desea que al solicitar aprobaci�n se muestre un mensaje de confirmaci�n al usuario.';

                        ; trigger OnValidate()
                        BEGIN
                            AdjustFlows;
                        END;


                    }

                }
                group("group18")
                {

                    CaptionML = ESP = 'Tareas';
                    field("Tasks Circuits No"; rec."Tasks Circuits No")
                    {

                        ToolTipML = ESP = 'Indica el n�mero de circuitos de aprobaci�n definidos para el manejo de las Tareas de los proyectos';
                        Editable = false;
                    }

                }

            }
            grid("group20")
            {

                CaptionML = ENU = 'Approvals by Project', ESP = 'Aprobaciones por Proyecto';
                GridLayout = Columns;
                group("group21")
                {

                    CaptionML = ENU = 'General', ESP = 'Configuraci¢n';
                }
                group("group22")
                {

                    CaptionML = ESP = '1. Versiones de estudios';
                    group("group23")
                    {

                        grid("group24")
                        {

                            GridLayout = Rows;
                            group("group25")
                            {

                                CaptionML = ESP = 'Versiones de estudios';
                                field("Approvals 01 Enabled"; rec."Approvals 01 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 01 Type"; rec."Approvals 01 Type")
                                {

                                    Editable = edType01;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApJobs.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 01 No"; rec."Approvals 01 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group29")
                {

                    CaptionML = ESP = '2. Comparativos';
                    group("group30")
                    {

                        grid("group31")
                        {

                            GridLayout = Rows;
                            group("group32")
                            {

                                CaptionML = ESP = 'Comparativos';
                                field("Approvals 02 Enabled"; rec."Approvals 02 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 02 Type"; rec."Approvals 02 Type")
                                {

                                    Editable = edType02;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApComparativeQuote.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 02 No"; rec."Approvals 02 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }
                    field("Send App. Comparative to Order"; rec."Send App. Comparative to Order")
                    {

                        ToolTipML = ESP = 'Si est� marcado, cuando se genera un contrato desde un comparativo este se genera aprobado, as� no hay que aprobarlo dos veces.';
                    }

                }
                group("group37")
                {

                    CaptionML = ESP = '3. Pedidos de compra';
                    group("group38")
                    {

                        grid("group39")
                        {

                            GridLayout = Rows;
                            group("group40")
                            {

                                CaptionML = ESP = 'Pedidos de compra';
                                field("Approvals 03 Enabled"; rec."Approvals 03 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 03 Type"; rec."Approvals 03 Type")
                                {

                                    Editable = edType03;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApPurchaseOrder.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 03 No"; rec."Approvals 03 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group44")
                {

                    CaptionML = ESP = '4. Facturas de compra';
                    group("group45")
                    {

                        grid("group46")
                        {

                            GridLayout = Rows;
                            group("group47")
                            {

                                CaptionML = ESP = 'Facturas de compra';
                                field("Approvals 04 Enabled"; rec."Approvals 04 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 04 Type"; rec."Approvals 04 Type")
                                {

                                    Editable = edType04;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApPurchaseInvoice.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 04 No"; rec."Approvals 04 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group51")
                {

                    CaptionML = ESP = '10. Abonos de compra';
                    group("group52")
                    {

                        grid("group53")
                        {

                            GridLayout = Rows;
                            group("group54")
                            {

                                CaptionML = ESP = 'Abonos de compra';
                                field("Approvals 10 Enabled"; rec."Approvals 10 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 10 Type"; rec."Approvals 10 Type")
                                {

                                    Editable = edType10;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApPurchaseCrMemo.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 10 No"; rec."Approvals 10 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group58")
                {

                    CaptionML = ESP = '5. Certificaci¢n';
                    group("group59")
                    {

                        grid("group60")
                        {

                            GridLayout = Rows;
                            group("group61")
                            {

                                CaptionML = ESP = 'Certificaci¢n';
                                field("Approvals 05 Enabled"; rec."Approvals 05 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 05 Type"; rec."Approvals 05 Type")
                                {

                                    Editable = edType05;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApMeasurements.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 05 No"; rec."Approvals 05 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group65")
                {

                    CaptionML = ESP = '7. Notas de gastos';
                    group("group66")
                    {

                        grid("group67")
                        {

                            GridLayout = Rows;
                            group("group68")
                            {

                                CaptionML = ESP = 'Notas de gastos';
                                field("Approvals 07 Enabled"; rec."Approvals 07 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 07 Type"; rec."Approvals 07 Type")
                                {

                                    Editable = edType07;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApExpenseNotes.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 07 No"; rec."Approvals 07 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group72")
                {

                    CaptionML = ESP = '8. Hojas de horas';
                    group("group73")
                    {

                        grid("group74")
                        {

                            GridLayout = Rows;
                            group("group75")
                            {

                                CaptionML = ESP = 'Hojas de horas';
                                field("Approvals 08 Enabled"; rec."Approvals 08 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnLookup(var Text: Text): Boolean
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 08 Type"; rec."Approvals 08 Type")
                                {

                                    Editable = edType08;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApWorksheet.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 08 No"; rec."Approvals 08 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group79")
                {

                    CaptionML = ESP = '9. Traspasos entre proyectos';
                    group("group80")
                    {

                        grid("group81")
                        {

                            GridLayout = Rows;
                            group("group82")
                            {

                                CaptionML = ESP = 'Traspasos entre proyectos';
                                field("Approvals 09 Enabled"; rec."Approvals 09 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 09 Type"; rec."Approvals 09 Type")
                                {

                                    Editable = edType09;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApTransBetweenJobs.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 09 No"; rec."Approvals 09 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                group("group86")
                {

                    CaptionML = ESP = '12. Anticipos';
                    group("group87")
                    {

                        grid("group88")
                        {

                            GridLayout = Rows;
                            group("group89")
                            {

                                CaptionML = ESP = 'Anticipos';
                                field("Approvals 12 Enabled"; rec."Approvals 12 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 12 Type"; rec."Approvals 12 Type")
                                {

                                    Editable = edType12;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApPrepayment.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 12 No"; rec."Approvals 12 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }
                    field("Send App. Prepayment to Doc."; rec."Send App. Prepayment to Doc.")
                    {

                    }

                }
                group("group94")
                {

                    CaptionML = ESP = '14. Retenciones';
                    group("group95")
                    {

                        grid("group96")
                        {

                            GridLayout = Rows;
                            group("group97")
                            {

                                CaptionML = ESP = 'Retenciones';
                                field("Approvals 14 Enabled"; rec."Approvals 14 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 14 Type"; rec."Approvals 14 Type")
                                {

                                    Editable = edType14;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApWithholding.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 14 No"; rec."Approvals 14 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }

            }
            grid("group101")
            {

                CaptionML = ENU = 'Budgets', ESP = 'Presupuestos';
                GridLayout = Columns;
                group("group102")
                {

                    CaptionML = ESP = '11. Presupuestos';
                    group("group103")
                    {

                        grid("group104")
                        {

                            GridLayout = Rows;
                            group("group105")
                            {

                                CaptionML = ESP = 'Presupuestos';
                                field("Approvals 11 Enabled"; rec."Approvals 11 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 11 Type"; rec."Approvals 11 Type")
                                {

                                    Editable = edType11;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApBudget.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 11 No"; rec."Approvals 11 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }

            }
            grid("group109")
            {

                CaptionML = ENU = 'Bill Payment Approval', ESP = 'Aprobaci¢n de Pagos';
                GridLayout = Columns;
                grid("group110")
                {

                    CaptionML = ENU = 'General', ESP = '6. Pagos de Facturas';
                    GridLayout = Columns;
                    group("group111")
                    {

                        grid("group112")
                        {

                            GridLayout = Rows;
                            group("group113")
                            {

                                CaptionML = ESP = 'Pagos';
                                field("Approvals 06 Enabled"; rec."Approvals 06 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 06 Type"; rec."Approvals 06 Type")
                                {

                                    Editable = edType06;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApCarteraDoc.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 06 No"; rec."Approvals 06 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }
                    field("FacMan"; rec."Manual. App. Payments Request")
                    {

                        ToolTipML = ESP = 'Si se desea que la aprobaci¢n de pagos de facturas relacionadas con obras se deba lance manualmente, si no se marca ser  autom tico';
                        Editable = edType06;
                    }
                    field("check1"; rec."Approvals Payments Caption 1")
                    {

                        Enabled = edType06;
                    }
                    field("check2"; rec."Approvals Payments Caption 2")
                    {

                        Enabled = edType06;
                    }
                    field("check3"; rec."Approvals Payments Caption 3")
                    {

                        Enabled = edType06;
                    }
                    field("check4"; rec."Approvals Payments Caption 4")
                    {

                        Enabled = edType06;
                    }
                    field("check5"; rec."Approvals Payments Caption 5")
                    {

                        Enabled = edType06;
                    }

                }
                grid("group123")
                {

                    CaptionML = ENU = 'General', ESP = '13. Pagos con Certificados Vencidos';
                    GridLayout = Columns;
                    group("group124")
                    {

                        grid("group125")
                        {

                            GridLayout = Rows;
                            group("group126")
                            {

                                CaptionML = ESP = 'Pagos Cert. Vencido';
                                field("Approvals 13 Enabled"; rec."Approvals 13 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 13 Type"; rec."Approvals 13 Type")
                                {

                                    Editable = edType13;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApCarteraDoc.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 13 No"; rec."Approvals 13 No")
                                {

                                    Editable = false;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }

                }
                grid("group130")
                {

                    CaptionML = ENU = 'General', ESP = '20. �rdenes de Pago';
                    GridLayout = Columns;
                    group("group131")
                    {

                        grid("group132")
                        {

                            GridLayout = Rows;
                            group("group133")
                            {

                                CaptionML = ESP = 'Pagos';
                                field("Approvals 20 Enabled"; rec."Approvals 20 Enabled")
                                {



                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;


                                }
                                field("Approvals 20 Type"; rec."Approvals 20 Type")
                                {

                                    Editable = edType20;


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        CurrPage.UPDATE;
                                    END;

                                    trigger OnAssistEdit()
                                    BEGIN
                                        QBApprovalManagement.EditFlow(ApPaymentOrders.GetApprovalsText(0));
                                    END;


                                }
                                field("Approvals 20 No"; rec."Approvals 20 No")
                                {

                                    Editable = false;
                                    ShowCaption = false

  ;
                                }

                            }

                        }

                    }

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ESP = 'Cargos';
                Image = PersonInCharge;

                trigger OnAction()
                VAR
                    QBPosition: Record 7206989;
                    QBPositionList: Page 7207044;
                BEGIN
                    COMMIT; // Por el run modal

                    QBPosition.RESET;

                    CLEAR(QBPositionList);
                    QBPositionList.SETTABLEVIEW(QBPosition);
                    QBPositionList.RUNMODAL;
                END;


            }
            action("action2")
            {
                CaptionML = ESP = 'Grupos de Aprobadores';
                Image = Group;

                trigger OnAction()
                VAR
                    QBJobResponsiblesGroupTem: Record 7206990;
                    QBJobResponsiblesTemplList: Page 7207037;
                BEGIN
                    COMMIT; // Por el run modal

                    QBJobResponsiblesGroupTem.RESET;

                    CLEAR(QBJobResponsiblesTemplList);
                    QBJobResponsiblesTemplList.SETTABLEVIEW(QBJobResponsiblesGroupTem);
                    QBJobResponsiblesTemplList.RUNMODAL;
                END;


            }
            action("action3")
            {
                CaptionML = ESP = 'Circuitos de Aprobaci�n';
                Image = OpportunityList;

                trigger OnAction()
                VAR
                    QBApprovalCircuitHeader: Record 7206986;
                    QBApprovalCircuitList: Page 7207040;
                BEGIN
                    SetJobsApprovalsData;    //Guardo el estado porque luego lo recuperar�
                    COMMIT; // Por el run modal

                    QBApprovalCircuitHeader.RESET;

                    CLEAR(QBApprovalCircuitList);
                    QBApprovalCircuitList.SETTABLEVIEW(QBApprovalCircuitHeader);
                    QBApprovalCircuitList.RUNMODAL;

                    COMMIT; // Por el run modal
                    CurrPage.UPDATE;  //Calcular de nuevo los contadores
                END;


            }
            action("action4")
            {
                CaptionML = ESP = 'Usuarios';
                Image = Users;

                trigger OnAction()
                VAR
                    UserSetup: Record 91;
                    QBApprovalUserSetup: Page 7207039;
                BEGIN
                    COMMIT; // Por el run modal

                    UserSetup.RESET;

                    CLEAR(QBApprovalUserSetup);
                    QBApprovalUserSetup.SETTABLEVIEW(UserSetup);
                    QBApprovalUserSetup.RUNMODAL;
                END;


            }
            action("action5")
            {
                CaptionML = ESP = 'Departamentos Organizativos';
                RunObject = Page 7207355;
                Image = Departments;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.RESET;

        //JAV 03/04/22: - QB 1.10.19 Nueva tabla de configuraci�n de Aprobaciones
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;


        //Configurar los flujos, eventos y tablas auxiliares necesarias para las aprobaciones
        QBApprovalManagement.CreateSetup;

        //Leer los datos de flujos y textos
        GetJobsApprovalsData;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        SetJobsApprovalsData;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //Leer los datos de la configuraci¢n y los flujos
        SetEditable;
        SetJobsApprovalsData; //Activar o desactivar los flujos
    END;



    var
        QBApprovalManagement: Codeunit 7207354;
        QBApprovalCircuitHeader: Record 7206986;
        QBApprovalCircuitList: Page 7207040;
        "--------------------------- Datos de hasta 20 tipos de aprobación": Integer;
        Circuito: ARRAY[20] OF Boolean;
        Numero: ARRAY[20] OF Integer;
        Type: ARRAY[20] OF option "Por Proyecto","Por Departamento","Por Usarios";
      "-------------------------- Cheks de aprobaci¢n, nro de circuitos y datos generales": Integer;
        Usuarios: Boolean;
        PagosManual: Boolean;
        Check: ARRAY[5] OF Text;
        ComparativeToOrder: Boolean;
        PrepaymentToDocument: Boolean;
        QuoBuildingSetup: Record 7207278;
        ApprovalOrder: Option;
        UserApproval: Option;
        "---------------------- Editables": Integer;
        edType01: Boolean;
        edType02: Boolean;
        edType03: Boolean;
        edType04: Boolean;
        edType05: Boolean;
        edType06: Boolean;
        edType07: Boolean;
        edType08: Boolean;
        edType09: Boolean;
        edType10: Boolean;
        edType11: Boolean;
        edType12: Boolean;
        edType13: Boolean;
        edType14: Boolean;
        edType20: Boolean;
        "------------------------- CU de Aprobación": Integer;
        ApJobs: Codeunit 7206915;
        ApComparativeQuote: Codeunit 7206916;
        ApPurchaseOrder: Codeunit 7206912;
        ApPurchaseInvoice: Codeunit 7206913;
        ApMeasurements: Codeunit 7206914;
        ApExpenseNotes: Codeunit 7206919;
        ApWorksheet: Codeunit 7206920;
        ApTransBetweenJobs: Codeunit 7206921;
        ApPaymentOrders: Codeunit 7206927;
        ApPurchaseCrMemo: Codeunit 7206928;
        ApBudget: Codeunit 7206929;
        ApPrepayment: Codeunit 7206931;
        ApCarteraDoc: Codeunit 7206917;
        AplBudgets: Codeunit 7206929;
        ApWithholding: Codeunit 7206987;

    procedure GetJobsApprovalsData();
    var
        QuoBuildingSetup: Record 7207278;
        QBTablesSetup: Record 7206903;
        Workflow: Record 1501;
        i: Integer;
        QBApprovalCircuitHeader: Record 7206986;
    begin
        //JAV 04/04/21: - QB 1.10.31 Leer los datos de Configuraci�n General, de los checks y de los flujos de aprobaciones ACTIVOS

        //Estos datos van en la configuraci�n de QB
        QuoBuildingSetup.GET;
        Usuarios := QuoBuildingSetup."Job access control";

        //Los textos de los 5 checks que van en configuraci�n de tablas
        Rec.GetCkeckText;

        //JAV 10/04/22: - QB 1.10.34 Se a�ade flujo de aprobaci�n vencido
        if (Workflow.GET(QBApprovalManagement.GetStdApprovalsFixedText(0))) then
            Rec."Approvals 00 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApJobs.GetApprovalsText(0)) then
            Rec."Approvals 01 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApComparativeQuote.GetApprovalsText(0)) then
            Rec."Approvals 02 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApPurchaseOrder.GetApprovalsText(0)) then
            Rec."Approvals 03 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApPurchaseInvoice.GetApprovalsText(0)) then
            Rec."Approvals 04 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApMeasurements.GetApprovalsText(0)) then
            Rec."Approvals 05 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApCarteraDoc.GetApprovalsText(0)) then
            Rec."Approvals 06 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApExpenseNotes.GetApprovalsText(0)) then
            Rec."Approvals 07 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApWorksheet.GetApprovalsText(0)) then
            Rec."Approvals 08 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApTransBetweenJobs.GetApprovalsText(0)) then
            Rec."Approvals 09 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApPurchaseCrMemo.GetApprovalsText(0)) then
            Rec."Approvals 10 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApBudget.GetApprovalsText(0)) then
            Rec."Approvals 11 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApPrepayment.GetApprovalsText(0)) then
            Rec."Approvals 12 Enabled" := Workflow.Enabled;

        if Workflow.GET(ApPaymentOrders.GetApprovalsText(0)) then
            Rec."Approvals 20 Enabled" := Workflow.Enabled;

        Rec.MODIFY;
    end;

    procedure SetJobsApprovalsData();
    var
        QuoBuildingSetup: Record 7207278;
        QBTablesSetup: Record 7206903;
        Workflow: Record 1501;
        i: Integer;
        text: Text;
    begin
        //JAV 04/04/21: - QB 1.10.31 Guardar la configuraci�n de Configuraci�n General, de los checks y de los flujos de aprobaciones ACTIVOS

        //Estos datos van en la configuraci�n de QB
        QuoBuildingSetup.GET;
        QuoBuildingSetup."Job access control" := Usuarios;
        QuoBuildingSetup.MODIFY;

        //Estos son los flujos de aprobaci�n existentes, los activo o desactivo

        //JAV 10/04/22: - QB 1.10.34 Se a�ade flujo de aprobaci�n vencido
        if Workflow.GET(QBApprovalManagement.GetStdApprovalsFixedText(0)) then begin
            Workflow.Enabled := Rec."Approvals 00 Enabled";
            Workflow.MODIFY;
        end;



        if Workflow.GET(ApPurchaseInvoice.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 04 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApPurchaseOrder.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 03 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApJobs.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 01 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApComparativeQuote.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 02 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApMeasurements.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 05 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApExpenseNotes.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 07 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApWorksheet.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 08 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApTransBetweenJobs.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 09 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApCarteraDoc.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 06 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApPurchaseCrMemo.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 10 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApBudget.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 11 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApPrepayment.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 12 Enabled";
            Workflow.MODIFY;
        end;

        //El tipo 13 va junto al tipo 6, no necesita esta activaci�n

        //JAV 13/12/22: - QB 1.12.26 Retenciones
        if Workflow.GET(ApWithholding.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 14 Enabled";
            Workflow.MODIFY;
        end;

        if Workflow.GET(ApPaymentOrders.GetApprovalsText(0)) then begin
            Workflow.Enabled := Rec."Approvals 20 Enabled";
            Workflow.MODIFY;
        end;

        SetEditable;
    end;

    LOCAL procedure SetEditable();
    begin
        edType01 := (not rec."Approvals 01 Enabled");
        edType02 := (not rec."Approvals 02 Enabled");
        edType03 := (not rec."Approvals 03 Enabled");
        edType04 := (not rec."Approvals 04 Enabled");
        edType05 := (not rec."Approvals 05 Enabled");
        edType06 := (not rec."Approvals 06 Enabled");
        edType07 := (not rec."Approvals 07 Enabled");
        edType08 := (not rec."Approvals 08 Enabled");
        edType09 := (not rec."Approvals 09 Enabled");
        edType10 := (not rec."Approvals 10 Enabled");
        edType11 := (not rec."Approvals 11 Enabled");
        edType12 := (not rec."Approvals 12 Enabled");
        edType13 := (not rec."Approvals 13 Enabled");  //JAV 26/06/22: - QB 1.10.54 Se a�ade el tipo 13 pagos con certificado vencido
        edType14 := (not rec."Approvals 14 Enabled");  //JAV 13/12/22: - QB 1.12.26 Se a�ade el tipo 14 retenciones
        edType20 := (not rec."Approvals 20 Enabled");
    end;

    LOCAL procedure AdjustFlows();
    begin
        Rec.MODIFY; //Necesario porque la funci�n lee el registro de nuevo
        QBApprovalManagement.MountFlowCircuit;
    end;

    // begin
    /*{
      JAV 31/03/22: - QB 1.10.29 Se a�ade el manejo de anticipos. Se mejora el formato de la p�gina.
      JAV 04/04/22: - QB 1.10.31 Se cambia a la nueva tabla de configuraci�n de aprobaciones, reforma general de la p�gina
      JAV 21/04/22: - QB 1.10.36 Se a�aden nuevos par�metros de configuraci�n general, al cambiarlos se cambian los circuitos. Se a�ade navegar a los flujos.
      JAV 24/06/22: - QB 1.10.54 Se actualiza la p�gina al cambiar la habilitaci�n de los diferentes documentos
                                 Se a�aden pagos con cetificado vencido, tipo 13
      JAV 13/12/22: - QB 1.12.26 Nueva aprobaci�n de retenciones
    }*///end
}









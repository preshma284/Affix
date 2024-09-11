page 7174670 "Job List Example DragDrop"
{
    Editable = false;
    CaptionML = ENU = 'Job List', ESP = 'Lista de proyectos';
    SourceTable = 167;
    PageType = List;
    CardPageID = "Job Card";

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number for the job. You can use one of the following methods to fill in the number: Option " ","ESP="Especifica el n�mero del proyecto. Puede utilizar uno de los siguientes m�todos para rellenar el n�mero: Option " ","ESP="Specifies a short description of the job.', ESP = 'Especifica una descripci�n breve del proyecto.';
                    ApplicationArea = Jobs;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the customer that the job should be billed to.', ESP = 'Especifica el n�mero del cliente al que debe facturarse el proyecto.';
                    ApplicationArea = Jobs;
                }
                field("Status"; rec."Status")
                {

                    ToolTipML = ENU = 'Specifies a status for the current job. You can change the status for the job as it progresses. Final calculations can be made on completed jobs.', ESP = 'Especifica el estado del proyecto actual. Se puede cambiar el estado del proyecto a medida que avanza. Los c�lculos finales pueden realizarse en los proyectos completados.';
                    ApplicationArea = Jobs;
                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    ToolTipML = ENU = 'Specifies the name of the person responsible for the job. You can select a name from the list of resources available in the Resource List window. The name is copied from the No. field in the Resource table. You can choose the field to see a list of resources.', ESP = 'Especifica el nombre de la persona responsable del proyecto. Se puede seleccionar un nombre de la lista de recursos disponibles en la ventana Lista de recursos. El nombre se copia del campo N.� correspondiente a la tabla Recurso. Se puede elegir el campo para ver una lista de recursos.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                }
                field("Next Invoice Date"; rec."Next Invoice Date")
                {

                    ToolTipML = ENU = 'Specifies the Rec.NEXT invoice date for the job.', ESP = 'Especifica la fecha de la siguiente factura para el proyecto.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                }
                field("Job Posting Group"; rec."Job Posting Group")
                {

                    ToolTipML = ENU = 'Specifies a job posting group code for a job. To see the available codes, choose the field.', ESP = 'Especifica un c�digo de grupo contable de proyecto para un proyecto. Para ver los c�digos disponibles, elija el campo.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                }
                field("Search Description"; rec."Search Description")
                {

                    ToolTipML = ENU = 'Specifies the additional name for the job. The field is used for searching purposes.', ESP = 'Especifica el nombre adicional para el proyecto y se utiliza con el prop�sito de realizar b�squedas.';
                    ApplicationArea = Jobs;
                }
                field("% of Overdue Planning Lines"; rec."PercentOverdue")
                {

                    CaptionML = ENU = '% of Overdue Planning Lines', ESP = '% de l�neas de planificaci�n vencidas';
                    ToolTipML = ENU = 'Specifies the percent of planning lines that are overdue for this job.', ESP = 'Especifica el porcentaje de l�neas de planificaci�n vencidas para este proyecto.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("% Completed"; rec."PercentCompleted")
                {

                    CaptionML = ENU = '% Completed', ESP = '% Completado';
                    ToolTipML = ENU = 'Specifies the completion percentage for this job.', ESP = 'Especifica el porcentaje de compleci�n de este proyecto.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("% Invoiced"; rec."PercentInvoiced")
                {

                    CaptionML = ENU = '% Invoiced', ESP = '% Facturado';
                    ToolTipML = ENU = 'Specifies the invoiced percentage for this job.', ESP = 'Especifica el porcentaje facturado de este proyecto.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                    Editable = FALSE;
                }

            }

        }
        area(FactBoxes)
        {
            part("DropArea"; 7174655)
            {
                ;
            }
            part("FilesSP"; 7174656)
            {
                ;
            }
            part("part3"; 9081)
            {

                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = FALSE;
            }
            part("part4"; 9082)
            {

                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = FALSE;
            }
            part("part5"; 9099)
            {

                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            part("part6"; 1030)
            {

                CaptionML = ENU = 'Job Details', ESP = 'Detalles proyecto';
                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("No.");
                Visible = JobSimplificationAvailable;
            }
            systempart(Links; Links)
            {

                Visible = FALSE;
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
                CaptionML = ENU = '&Job', ESP = 'Pro&yecto';
                Image = Job;
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+T';
                    CaptionML = ENU = 'Job Task &Lines', ESP = '&L�neas tarea proyecto';
                    ToolTipML = ENU = 'Plan how you want to set up your planning information. In this window you can specify the tasks involved in a job. To start planning a job or to post usage for a job, you must set up at least one job task.', ESP = 'Permite planificar c�mo desea configurar la informaci�n de planificaci�n. En esta ventana, puede especificar las tareas que conforman un trabajo. Para comenzar la planificaci�n de un trabajo o para registrar el uso de un trabajo, debe configurar al menos una tarea de trabajo.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1002;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = TaskList;
                }
                group("group4")
                {
                    CaptionML = ENU = '&Dimensions', ESP = '&Dimensiones';
                    Image = Dimensions;
                    action("action2")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-&Single', ESP = 'Dimensiones-&Individual';
                        ToolTipML = ENU = 'View or edit the single set of dimensions that are set up for the selected record.', ESP = 'Permite ver o editar el grupo �nico de dimensiones configuradas para el registro seleccionado.';
                        ApplicationArea = Jobs;
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action3")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&M�ltiple';
                        ToolTipML = ENU = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.', ESP = 'Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar c�digos de dimensi�n a transacciones para distribuir los costes y analizar la informaci�n hist�rica.';
                        ApplicationArea = Jobs;
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            Job: Record 167;
                            DefaultDimensionsMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Job);
                            DefaultDimensionsMultiple.SetMultiJob(Job);
                            DefaultDimensionsMultiple.RUNMODAL;
                        END;


                    }

                }
                action("action4")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = '&Statistics', ESP = '&Estad�sticas';
                    ToolTipML = ENU = 'View this jobs statistics.', ESP = 'Permite ver las estad�sticas de este proyecto.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1025;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("SalesInvoicesCreditMemos")
                {

                    CaptionML = ENU = 'Sales &Invoices/Credit Memos', ESP = '&Facturas venta/Abonos venta';
                    ToolTipML = ENU = 'View sales invoices or sales credit memos that are related to the selected job.', ESP = 'Permite ver facturas de venta o abonos de venta relacionados con el trabajo seleccionado.';
                    ApplicationArea = Jobs;
                    Image = GetSourceDoc;

                    trigger OnAction()
                    VAR
                        JobInvoices: Page 1029;
                    BEGIN
                        JobInvoices.SetPrJob(Rec);
                        JobInvoices.RUNMODAL;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    ToolTipML = ENU = 'View the comment sheet for this job.', ESP = 'Permite ver la hoja de comentarios de este proyecto.';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }
            group("group10")
            {
                CaptionML = ENU = 'W&IP', ESP = 'W&IP';
                Image = WIP;
                action("action7")
                {
                    CaptionML = ENU = '&WIP Entries', ESP = 'Movimientos &WIP';
                    ToolTipML = ENU = 'View entries for the job that are posted as work in process.', ESP = 'Permite ver los movimientos del trabajo que se registran como trabajo en curso.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1008;
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date")
                                  ORDER(Descending);
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = WIPEntries;
                }
                action("action8")
                {
                    CaptionML = ENU = 'WIP &G/L Entries', ESP = 'Movs. conta&bilidad WIP';
                    ToolTipML = ENU = 'View the jobs WIP G/L entries.', ESP = 'Permite ver los movimientos de contabilidad general de WIP del trabajo.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1009;
                    RunPageView = SORTING("Job No.")
                                  ORDER(Descending);
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = WIPLedger;
                }

            }
            group("group13")
            {
                CaptionML = ENU = '&Prices', ESP = '&Precios';
                Image = Price;
                action("action9")
                {
                    CaptionML = ENU = '&Resource', ESP = '&Recurso';
                    ToolTipML = ENU = 'View this jobs resource prices.', ESP = 'Permite ver los precios de recursos de este proyecto.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1011;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = Resource;
                }
                action("action10")
                {
                    CaptionML = ENU = '&Item', ESP = '&Producto';
                    ToolTipML = ENU = 'View this jobs item prices.', ESP = 'Permite ver los precios de productos de este proyecto.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1012;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = Item;
                }
                action("action11")
                {
                    CaptionML = ENU = '&G/L Account', ESP = 'Cue&nta';
                    ToolTipML = ENU = 'View this jobs G/L account prices.', ESP = 'Permite ver los precios de las cuentas de contabilidad de este proyecto.';
                    ApplicationArea = Jobs;
                    RunObject = Page 1013;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = JobPrice;
                }

            }
            group("group17")
            {
                CaptionML = ENU = 'Plan&ning', ESP = 'Pla&nific.';
                Image = Planning;
                action("action12")
                {
                    CaptionML = ENU = 'Resource &Allocated per Job', ESP = '&Asignaci�n recursos';
                    ToolTipML = ENU = 'View this jobs resource allocation.', ESP = 'Permite ver la asignaci�n de recursos de este proyecto.';
                    ApplicationArea = Jobs;
                    RunObject = Page 221;
                    Image = ViewJob;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Res. Group All&ocated per Job', ESP = 'A&signaci�n fams. recursos';
                    ToolTipML = ENU = 'View the jobs resource group allocation.', ESP = 'Permite ver la asignaci�n del grupo de recursos del trabajo.';
                    ApplicationArea = Jobs;
                    RunObject = Page 228;
                    Image = ViewJob;
                }

            }
            group("group20")
            {
                CaptionML = ENU = 'History', ESP = 'Historial';
                Image = History;
                action("action14")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                    ApplicationArea = Jobs;
                    RunObject = Page 92;
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date")
                                  ORDER(Descending);
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = CustomerLedger;
                }

            }

        }
        area(Processing)
        {

            group("<Action9>")
            {

                CaptionML = ENU = 'F&unctions', ESP = 'F&unciones';
                // ActionContainerType=NewDocumentItems;
                Image = Action;
                action("CopyJob")
                {

                    Ellipsis = true;
                    CaptionML = ENU = '&Rec.COPY Job', ESP = 'C&opiar proyecto';
                    ToolTipML = ENU = 'Copy a job and its job tasks, planning lines, and prices.', ESP = 'Permite copiar un trabajo y sus tareas, l�neas de planificaci�n y precios.';
                    ApplicationArea = Jobs;
                    Image = CopyFromTask;

                    trigger OnAction()
                    VAR
                        CopyJob: Page 1040;
                    BEGIN
                        CopyJob.SetFromJob(Rec);
                        CopyJob.RUNMODAL;
                    END;


                }
                action("action16")
                {
                    CaptionML = ENU = 'Create Job &Sales Invoice', ESP = 'Crear factura &venta proyecto';
                    ToolTipML = ENU = 'Use a batch job to help you create job sales invoices for the involved job planning lines.', ESP = 'Permite usar un trabajo por lotes para que resulte m�s sencillo crear facturas de venta de trabajo para las l�neas de planificaci�n de trabajo relacionadas.';
                    ApplicationArea = Jobs;
                    RunObject = Report 1093;
                    Image = JobSalesInvoice;
                }
                group("group26")
                {
                    CaptionML = ENU = 'W&IP', ESP = 'W&IP';
                    Image = WIP;
                    action("<Action151>")
                    {

                        Ellipsis = true;
                        CaptionML = ENU = '&Calculate WIP', ESP = '&Calcular WIP';
                        ToolTipML = ENU = 'Run the Job Calculate WIP batch job.', ESP = 'Permite ejecutar el trabajo por lotes Calcular WIP proyecto.';
                        ApplicationArea = Jobs;
                        Image = CalculateWIP;

                        trigger OnAction()
                        VAR
                            Job: Record 167;
                        BEGIN
                            Rec.TESTFIELD("No.");
                            Job.COPY(Rec);
                            Job.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(REPORT::"Job Calculate WIP", TRUE, FALSE, Job);
                        END;


                    }
                    action("<Action152>")
                    {

                        Ellipsis = true;
                        CaptionML = ENU = '&Post WIP to G/L', ESP = 'Registrar &WIP en C/G';
                        ToolTipML = ENU = 'Run the Job Post WIP to G/L batch job.', ESP = 'Permite ejecutar el trabajo por lotes Registrar WIP en C/G proyecto.';
                        ApplicationArea = Jobs;
                        Image = PostOrder;

                        trigger OnAction()
                        VAR
                            Job: Record 167;
                        BEGIN
                            Rec.TESTFIELD("No.");
                            Job.COPY(Rec);
                            Job.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job);
                        END;


                    }

                }

            }

        }
        area(Reporting)
        {

            action("action19")
            {
                CaptionML = ENU = 'Job Actual to Budget', ESP = 'Proyecto real frente a presupuesto';
                ToolTipML = ENU = 'Compare budgeted and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.', ESP = 'Permite comparar las cantidades facturables y las cantidades de consumo de los trabajos seleccionados. Todas las l�neas del trabajo seleccionado muestran la cantidad, el coste total y el importe de l�nea.';
                ApplicationArea = Jobs;
                RunObject = Report 1009;
                Image = Report;
            }
            action("action20")
            {
                CaptionML = ENU = 'Job Analysis', ESP = 'An�lisis proyecto';
                ToolTipML = ENU = 'Analyze the job, such as the budgeted prices, usage prices, and contract prices, and then compares the three sets of prices.', ESP = '"Permite analizar el trabajo. por ejemplo, los precios presupuestados, los precios de uso y los precios de los contratos, y, luego, compara los tres conjuntos de precios."';
                ApplicationArea = Jobs;
                RunObject = Report 1008;
                Image = Report;
            }
            action("action21")
            {
                CaptionML = ENU = 'Job - Planning Lines', ESP = 'Proyecto - L�neas planificaci�n';
                ToolTipML = ENU = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).', ESP = 'Permite ver todas las l�neas de planificaci�n del proyecto. Use esta ventana para planificar qu� art�culos, recursos y gastos de contabilidad espera usar en un proyecto (Presupuesto) o puede especificar qu� ha acordado con el cliente en cuanto a lo que este debe pagar por el proyecto (Facturable).';
                ApplicationArea = Jobs;
                RunObject = Report 1006;
                Image = Report;
            }
            action("action22")
            {
                CaptionML = ENU = 'Job - Suggested Billing', ESP = 'Proyecto - Facturaci�n propuesta';
                ToolTipML = ENU = 'View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.', ESP = '"Permite ver una lista de todos los trabajos agrupados por cliente, as� como cu�nto se le ha facturado al cliente y cu�nto queda por facturar. es decir, la facturaci�n sugerida."';
                ApplicationArea = Jobs;
                RunObject = Report 1011;
                Image = Report;
            }
            action("action23")
            {
                CaptionML = ENU = 'Jobs per Customer', ESP = 'Proyectos por cliente';
                ToolTipML = ENU = 'Run the Jobs per Customer report.', ESP = 'Permite ejecutar el informe Proyectos por cliente.';
                ApplicationArea = Jobs;
                RunObject = Report 1012;
                Image = Report;
            }
            action("action24")
            {
                CaptionML = ENU = 'Items per Job', ESP = 'Productos por proyecto';
                ToolTipML = ENU = 'View which items are used for a specific job.', ESP = 'Permite ver qu� art�culos se usan para un determinado trabajo.';
                ApplicationArea = Jobs;
                RunObject = Report 1013;
                Image = Report;
            }
            action("action25")
            {
                CaptionML = ENU = 'Jobs per Item', ESP = 'Proyectos por producto';
                ToolTipML = ENU = 'Run the Jobs per item report.', ESP = 'Permite ejecutar el informe Proyectos por producto.';
                ApplicationArea = Jobs;
                RunObject = Report 1014;
                Image = Report;
            }
            action("Report Job Quote")
            {

                CaptionML = ENU = 'Preview Job Quote', ESP = 'Obtener vista previa de oferta de trabajo';
                ToolTipML = ENU = 'Open the Job Quote report.', ESP = 'Permite abrir el informe Oferta de trabajo.';
                ApplicationArea = Jobs;
                Image = Report;

                trigger OnAction()
                VAR
                    Job: Record 167;
                BEGIN
                    Job.SETCURRENTKEY("No.");
                    Job.SETFILTER("No.", rec."No.");
                    REPORT.RUN(REPORT::"Job Quote", TRUE, FALSE, Job);
                END;


            }
            action("Send Job Quote")
            {

                CaptionML = ENU = 'Send Job Quote', ESP = 'Enviar oferta de trabajo';
                ToolTipML = ENU = 'Send the job quote to the customer. You can change the way that the document is sent in the window that appears.', ESP = 'Permite enviar la oferta de trabajo al cliente. Se puede modificar el modo de env�o del documento en la ventana que se muestra.';
                ApplicationArea = Jobs;
                Image = SendTo;

                trigger OnAction()
                BEGIN
                    CODEUNIT.RUN(CODEUNIT::"Jobs-Send", Rec);
                END;


            }
            group("group39")
            {
                CaptionML = ENU = 'Financial Management', ESP = 'Gesti�n financiera';
                Image = Report;
                action("action28")
                {
                    CaptionML = ENU = 'Job WIP to G/L', ESP = 'WIP a C/G proyecto';
                    ToolTipML = ENU = 'View the value of work in process on the jobs that you select compared to the amount that has been posted in the general ledger.', ESP = 'Permite ver el valor del trabajo en curso de aquellos trabajos que seleccione en comparaci�n con la cantidad que se ha registrado en la contabilidad general.';
                    ApplicationArea = Jobs;
                    RunObject = Report 1010;
                    Image = Report;
                }

            }
            group("group41")
            {
                CaptionML = ENU = 'History', ESP = 'Historial';
                Image = Report;
                action("action29")
                {
                    CaptionML = ENU = 'Jobs - Transaction Detail', ESP = 'Proyectos - Movimientos';
                    ToolTipML = ENU = 'View all postings with entries for a selected job for a selected period, which have been charged to a certain job. At the end of each job list, the amounts are totaled separately for the Sales and Usage entry types.', ESP = 'Permite ver todos los registros con movimientos de un trabajo seleccionado durante un periodo especificado que se han imputado en un determinado trabajo. Al final de cada lista de trabajo, los importes de los movimientos de tipo Ventas y Uso se suman por separado.';
                    ApplicationArea = Jobs;
                    RunObject = Report 1007;
                    Image = Report;
                }
                action("action30")
                {
                    CaptionML = ENU = 'Job Register', ESP = 'Registro movs. proyecto';
                    ToolTipML = ENU = 'View one or more selected job registers. By using a filter, you can select only those register entries that you want to see. If you do not set a filter, the report can be impractical because it can contain a large amount of information. On the job journal template, you can indicate that you want the report to print when you post.', ESP = 'Permite ver uno o varios registros de trabajo seleccionados. Mediante la aplicaci�n de un filtro, puede seleccionar solo aquellos movimientos de registro que desea ver. Si no establece un filtro, el informe puede resultar poco pr�ctico, ya que contendr� gran cantidad de informaci�n. En la plantilla de diario de trabajos, puede indicar que desea imprimir el informe cuando realice el registro.';
                    ApplicationArea = Jobs;
                    RunObject = Report 1015;
                    Image = Report;
                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(CopyJob_Promoted; CopyJob)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(SalesInvoicesCreditMemos_Promoted; SalesInvoicesCreditMemos)
                {
                }
                actionref(action14_Promoted; action14)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action19_Promoted; action19)
                {
                }
                actionref(action20_Promoted; action20)
                {
                }
                actionref(action21_Promoted; action21)
                {
                }
                actionref(action22_Promoted; action22)
                {
                }
            }
        }
    }







    trigger OnInit()
    BEGIN
        JobSimplificationAvailable := rec.IsJobSimplificationAvailable;
    END;

    trigger OnOpenPage()
    BEGIN
        //QUONEXT 20.07.17 DRAG&DROP. Actualizaci�n de los ficheros.
        CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);
        ///FIN QUONEXT 20.07.17
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN

        //QUONEXT 20.07.17 DRAG&DROP.
        CurrPage.DropArea.PAGE.SetFilter(Rec);
        CurrPage.FilesSP.PAGE.SetFilter(Rec);
        ///FIN QUONEXT 20.07.17
    END;



    var
        JobSimplificationAvailable: Boolean;/*

    begin
    {
      QUONEXT 20.07.17 DRAG&DROP. Ejemplo del procedimiento para integrar otro maestro.
                       Dos nuevos factbox en la p�gina "Drop Area" y "FilesSP"
                       Dos nuevas llamadas a esos factbox en el m�todo OnAfterGetCurrRecord
    }
    end.*/


}









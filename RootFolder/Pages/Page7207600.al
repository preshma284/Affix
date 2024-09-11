page 7207600 "Control Records"
{
    Editable = true;
    CaptionML = ENU = 'Control Records', ESP = 'Expedientes Control';
    SourceTable = 7207393;
    PopulateAllFields = true;
    PageType = Card;

    layout
    {
        area(content)
        {
            field("JobDescription"; JobDescription)
            {

                CaptionML = ESP = 'Proyecto';
                Editable = FALSE;
                Style = Standard;
                StyleExpr = TRUE;
            }
            group("group30")
            {

                CaptionML = ENU = 'Sales budgets', ESP = 'Presupuestos de venta';
                repeater("table")
                {

                    field("No."; rec."No.")
                    {

                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("Customer No."; rec."Customer No.")
                    {

                        Editable = MultiCustJob;
                    }
                    field("Customer Name"; rec."Customer Name")
                    {

                    }
                    field("Description"; rec."Description")
                    {

                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("Record Type"; rec."Record Type")
                    {

                    }
                    field("Record Status"; rec."Record Status")
                    {

                    }
                    field("Estimated Amount"; rec."Estimated Amount")
                    {

                    }
                    field("Currency Amount Date"; rec."Currency Amount Date")
                    {

                        Visible = useCurrencies;

                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Sale Amount 0"; SA0)
                    {

                        CaptionML = ENU = 'Sale Amount', ESP = 'Importe venta (DC)';
                        CaptionClass = myCaptions[1];
                        Editable = FALSE;
                    }
                    field("Direct Cost Amount 0"; CA0)
                    {

                        CaptionML = ENU = 'Direct Cost Amount', ESP = 'Importe coste directo (DC)';
                        CaptionClass = myCaptions[2];
                        Editable = FALSE;
                    }
                    field("Sale Amount 1"; SA1)
                    {

                        CaptionML = ENU = 'Sale Amount (LCY)', ESP = 'Importe venta (DL)';
                        Visible = useCurrencies;
                        Editable = FALSE;
                    }
                    field("Direct Cost Amount 1"; CA1)
                    {

                        CaptionML = ENU = 'Direct Cost Amount (LCY)', ESP = 'Importe coste directo (DL)';
                        Visible = useCurrencies;
                        Editable = FALSE;
                    }
                    field("Sale Amount 2"; SA2)
                    {

                        CaptionML = ENU = 'Sale Amount (ACY)', ESP = 'Importe venta (DR)';
                        Visible = useCurrencies;
                        Editable = FALSE;
                    }
                    field("Direct Cost Amount 2"; CA2)
                    {

                        CaptionML = ENU = 'Direct Cost Amount (ACY)', ESP = 'Importe coste directo (DR)';
                        Visible = useCurrencies;
                        Editable = FALSE;
                    }
                    field("Accepted Amount"; rec.AcceptedAmount(0))
                    {

                        CaptionML = ENU = 'Accepted Amount', ESP = 'Importe producci�n aceptada';
                    }
                    field("Procedure Amount"; rec.ProcedureAmount(0))
                    {

                        CaptionML = ENU = 'Procedure Amount', ESP = 'Producci�n en tr�mite';
                    }
                    field("Entry Record Date"; rec."Entry Record Date")
                    {

                    }
                    field("Shipment To Central Date"; rec."Shipment To Central Date")
                    {

                    }
                    field("Initial Procedure Date"; rec."Initial Procedure Date")
                    {

                    }
                    field("Piecework No."; rec."Piecework No.")
                    {

                    }

                }

            }
            part(SalesUnits;7207337)
            {
                CaptionML=ENU='Sales Unit',
                           ESP='Unidades venta';
                SubPageView=SORTING("Job No.","No. Record");
                SubPageLink="Job No."=FIELD("Job No."),"No. Record"=FIELD("No.");
            }

        }
        area(FactBoxes)
        {
            part("FB_ContractedAmount"; 7207489)
            {
                SubPageLink = "Job No." = FIELD("Job No."), "No. Record" = FIELD("No.");
            }
            part("FB_BudgetCosts"; 7207488)
            {
                SubPageLink = "Job No." = FIELD("Job No."), "No. Record" = FIELD("No.");
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
                CaptionML = ENU = '&Records', ESP = 'Expedientes';
                action("action1")
                {
                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207571;
                    RunPageLink = "No." = FIELD("No."), "Job No." = FIELD("Job No.");
                    Image = View;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Vendor Evaluation"), "No." = FIELD("No.");
                    Image = Note;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Assigned Certifiaction', ESP = 'Agrupaciones de coste';
                    Visible = verAgrupaciones;
                    Image = LotInfo;

                    trigger OnAction()
                    VAR
                        CertificationAssigned: Page 7207591;
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        //JAV 31/10/20: - QB 1.07.03 Se usa la funci�n en la tabla para no repetir c�digo
                        Job.GET(rec."Job No.");
                        Job.AssignedCertification('');
                    END;


                }

            }
            group("<Page Comment Sheet>")
            {

                CaptionML = ENU = '&Acc. Record', ESP = 'Acc. Expediente';
                action("AssociateJobsUnits")
                {

                    CaptionML = ENU = '&Associate Jobs Units', ESP = 'Asociar Unidades de Obra';
                    Image = CopyFromTask;

                    trigger OnAction()
                    VAR
                        Text0001: TextConst ENU = 'It has been associated %1 job units', ESP = 'Se han asociado %1 unidades de obra';
                    BEGIN
                        CLEAR(AssociateJUToRecord);
                        DataJobUnitForProduction.RESET;
                        DataJobUnitForProduction.SETCURRENTKEY("Job No.", "No. Record");
                        DataJobUnitForProduction.FILTERGROUP(2);
                        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataJobUnitForProduction.SETFILTER("No. Record", '%1', '');
                        DataJobUnitForProduction.SETRANGE("Customer Certification Unit", TRUE);
                        DataJobUnitForProduction.FILTERGROUP(0);
                        AssociateJUToRecord.SETTABLEVIEW(DataJobUnitForProduction);
                        AssociateJUToRecord.EDITABLE(FALSE);
                        AssociateJUToRecord.LOOKUPMODE(TRUE);
                        AssociateJUToRecord.ReceiveData(Rec, ActionOption::Associate);
                        IF AssociateJUToRecord.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            AssociateJUToRecord.ReturnNumber(NumberInt);
                            IF NumberInt <> 0 THEN
                                MESSAGE(Text0001, NumberInt);
                        END;
                    END;


                }
                action("RemoveUnitsFromRecord")
                {

                    CaptionML = ENU = '&Remove Units From Record', ESP = 'Quitar Unidades del exp.';
                    Image = DeleteExpiredComponents;

                    trigger OnAction()
                    VAR
                        Text0001: TextConst ENU = 'It has been removed %1 job units', ESP = 'Se han quitado %1 unidades de obra';
                    BEGIN
                        CLEAR(AssociateJUToRecord);
                        DataJobUnitForProduction.RESET;
                        DataJobUnitForProduction.SETCURRENTKEY("Job No.", "No. Record");
                        DataJobUnitForProduction.FILTERGROUP(2);
                        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataJobUnitForProduction.SETFILTER("No. Record", '%1', rec."No.");
                        DataJobUnitForProduction.FILTERGROUP(0);
                        AssociateJUToRecord.SETTABLEVIEW(DataJobUnitForProduction);
                        AssociateJUToRecord.EDITABLE(FALSE);
                        AssociateJUToRecord.LOOKUPMODE(TRUE);
                        AssociateJUToRecord.ReceiveData(Rec, ActionOption::Remove);
                        IF AssociateJUToRecord.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            AssociateJUToRecord.ReturnNumber(NumberInt);
                            IF NumberInt <> 0 THEN
                                MESSAGE(Text0001, NumberInt);
                        END;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = '&Finish Record', ESP = 'Finalizar Expediente';
                    RunObject = Codeunit 7207330;
                    Image = ChangeStatus;
                }
                action("Print")
                {

                    CaptionML = ENU = 'Print', ESP = 'Imprimir expedientes';
                    Image = Print;

                    trigger OnAction()
                    VAR
                        ControlRecords: Record 7207393;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        //CLEAR(ReportHistRecords);
                        ControlRecords.RESET;
                        ControlRecords.SETRANGE("Job No.", rec."Job No.");
                        ControlRecords.SETRANGE("No.", rec."No.");

                        //JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
                        QBReportSelections.Print(QBReportSelections.Usage::J1, ControlRecords);
                        //ReportHistRecords.SETTABLEVIEW(ControlRecords); // Est�ndar
                        //ReportHistRecords.RUNMODAL;
                        //JobSalesRecords.SETTABLEVIEW(ControlRecords);  //El de Vesta
                        //JobSalesRecords.RUNMODAL;
                    END;


                }
                action("Update K")
                {

                    CaptionML = ENU = 'Update K', ESP = 'Actualizar K';
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                    END;


                }

            }
            group("group12")
            {
                CaptionML = ENU = 'Acc. &Unidades', ESP = 'Acc. &Unidades';
                action("action9")
                {
                    CaptionML = ENU = 'Save Initial', ESP = 'Guardar Inicial';
                    Image = Save;

                    trigger OnAction()
                    BEGIN
                        SaveInitial;
                    END;


                }
                action("Test")
                {

                    CaptionML = ENU = '&Test', ESP = 'Test';
                    Image = TestReport;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SalesUnits.PAGE.Test;
                    END;


                }
                action("action11")
                {
                    CaptionML = ENU = 'Calculate Budget Revision', ESP = 'Calcular revisi�n presupuesto';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        LJob: Record 167;
                        LJobBudgetActual: Record 7207407;
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        FunctionQB: Codeunit 7207272;
                        Text000: TextConst ESP = 'El presupuesto %1 esta cerrado';
                    BEGIN
                        CLEAR(RateBudgetsbyPiecework);
                        LJob.GET(rec."Job No.");
                        LJobBudgetActual.GET(rec."Job No.", LJob."Current Piecework Budget");
                        IF LJobBudgetActual.Status <> LJobBudgetActual.Status::Close THEN
                            RateBudgetsbyPiecework.ValueInitialization(LJob, LJobBudgetActual)
                        ELSE
                            MESSAGE(Text000, LJob."Current Piecework Budget");
                        CurrPage.UPDATE;
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'Calculate Analytic Budget', ESP = 'Calcular ppto. anal�tico';
                    Visible = FALSE;
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        Text008: TextConst ESP = 'Confirme que desea calcular el presupuesto anal�tico para %1';
                        DataPieceworkForProduction: Record 7207386;
                        LJob: Record 167;
                        ConvertToBudgetxCA: Codeunit 7207282;
                        Text005: TextConst ESP = 'Proceso finalizado';
                        IsVersion: Boolean;
                    BEGIN
                        LJob.GET(rec."Job No.");
                        IF CONFIRM(Text008, FALSE, LJob."Current Piecework Budget") THEN BEGIN
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                            DataPieceworkForProduction.SETRANGE("Budget Filter", LJob."Current Piecework Budget");
                            IF DataPieceworkForProduction.FINDSET THEN BEGIN
                                CLEAR(ConvertToBudgetxCA);
                                ConvertToBudgetxCA.PassBudget(LJob."Current Piecework Budget");
                                //ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction,IsVersion,"Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }
                action("action13")
                {
                    CaptionML = ENU = 'Get Cost Database', ESP = 'Traer preciario';
                    Image = JobPrice;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SalesUnits.PAGE.IncorporateCostDatabase;   //GetCostDatabase("Cod. Budget");
                    END;


                }
                action("Planificar")
                {

                    CaptionML = ESP = 'Planificar Certificaci�n';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        ExpectedTimeUnitData: Record 7207388;
                        TMPExpectedTimeUnitData: Record 7206984 TEMPORARY;
                        QBPlanJobCertification: Page 7207015;
                        Records: Record 7207393;
                    BEGIN
                        //QB16219
                        CLEAR(QBPlanJobCertification);
                        TMPExpectedTimeUnitData.RESET;
                        TMPExpectedTimeUnitData.SETRANGE("QB_Job No.", Rec."Job No.");
                        TMPExpectedTimeUnitData.SETRANGE("QB_Record No.", Rec."No.");
                        QBPlanJobCertification.SetDatas(Rec."Job No.", Rec."No.");
                        QBPlanJobCertification.SETTABLEVIEW(TMPExpectedTimeUnitData);
                        QBPlanJobCertification.RUN;
                    END;


                }
                action("PlanificacionGlobal")
                {

                    CaptionML = ENU = 'Planificacion global', ESP = 'Planificacion global';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        ExpectedTimeUnitData: Record 7207388;
                        TMPExpectedTimeUnitData: Record 7206984 TEMPORARY;
                        QBPlanJobCertification: Page 7207015;
                        Records: Record 7207393;
                    BEGIN
                        //QB16219
                        CLEAR(QBPlanJobCertification);
                        TMPExpectedTimeUnitData.RESET;
                        TMPExpectedTimeUnitData.SETRANGE("QB_Job No.", Rec."Job No.");
                        TMPExpectedTimeUnitData.SETRANGE("QB_Record No.", Rec."No.");
                        QBPlanJobCertification.SetDatas(Rec."Job No.", '');
                        QBPlanJobCertification.SETTABLEVIEW(TMPExpectedTimeUnitData);
                        QBPlanJobCertification.RUN;
                    END;


                }
                action("Redeterminations")
                {

                    CaptionML = ENU = 'Redeterminations', ESP = 'Redeterminaciones';
                }

            }
            group("group21")
            {
                CaptionML = ENU = 'Job Currency', ESP = 'Divisas Proyecto';
                Visible = useCurrencies;
                action("JobCurrencyExchanges")
                {

                    CaptionML = ENU = 'Job Currency Exchanges', ESP = 'Cambios de divisa';
                    Visible = useCurrencies;
                    Enabled = canEditJobsCurrencies;
                    Image = CurrencyExchangeRates;

                    trigger OnAction()
                    VAR
                        QBJobCurrencyExchange: Record 7206917;
                        QBJobCurrencyExchanges: Page 7207667;
                    BEGIN
                        //GEN003-02
                        QBJobCurrencyExchange.RESET;
                        QBJobCurrencyExchange.SETRANGE("Job No.", rec."Job No.");
                        CLEAR(QBJobCurrencyExchanges);
                        QBJobCurrencyExchanges.SETTABLEVIEW(QBJobCurrencyExchange);
                        QBJobCurrencyExchanges.RUNMODAL;
                        CurrPage.UPDATE;
                    END;


                }
                action("ChangeFactboxCurrency")
                {

                    CaptionML = ENU = 'Change Factbox Currency', ESP = 'Cambiar divisa factboxs';
                    Visible = useCurrencies;
                    Enabled = canChangeFactboxCurrency;
                    Image = Change;

                    trigger OnAction()
                    VAR
                        Salir: Boolean;
                    BEGIN
                        //Q7539 -
                        Salir := FALSE;
                        REPEAT
                            ShowCurrency := (ShowCurrency + 1) MOD 3;
                            CASE ShowCurrency OF
                                0:
                                    Salir := TRUE;
                                1:
                                    Salir := (Job."Currency Code" <> '');
                                2:
                                    Salir := (Job."Aditional Currency" <> '');
                            END;
                        UNTIL (Salir);
                        SetCurrencyFB;
                    END;


                }

            }
            group("group24")
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
            group("group26")
            {

                CaptionML = ESP = 'Varios';
                action("action20")
                {
                    CaptionML = ESP = 'Volver a traer precios';
                    Image = Text;


                    trigger OnAction()
                    VAR
                        QBPageSubscriber: Codeunit 7207349;
                    BEGIN
                        //JAV 22/03/19: - Nueva acci�n para cargar los textos desde el preciario de nuevo
                        QBPageSubscriber.CopyPricesToJob(Rec."Job No.");
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ESP = 'Proceso';

                actionref(AssociateJobsUnits_Promoted; AssociateJobsUnits)
                {
                }
                actionref(RemoveUnitsFromRecord_Promoted; RemoveUnitsFromRecord)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(Print_Promoted; Print)
                {
                }
                actionref("Update K_Promoted"; "Update K")
                {
                }
                actionref(JobCustomers_Promoted; JobCustomers)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Clientes';
            }
            group(Category_Category4)
            {
                CaptionML = ESP = 'Acciones';

                actionref(action9_Promoted; action9)
                {
                }
                actionref(Test_Promoted; Test)
                {
                }
                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ESP = 'Divisas';

                actionref(JobCurrencyExchanges_Promoted; JobCurrencyExchanges)
                {
                }
                actionref(ChangeFactboxCurrency_Promoted; ChangeFactboxCurrency)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnOpenPage()
    VAR
        JobDescription: Text[250];
        FunctionQB: Codeunit 7207272;
    BEGIN
        rec.CreateInitialRecord;

        //JAV 15/05/20: - El bot�n de agrupaciones ser� visible si se puede usar
        Job.GET(rec."Job No.");
        verAgrupaciones := (Job."Separation Job Unit/Cert. Unit");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        IF Rec.GETFILTER("Job No.") <> '' THEN
            rec."Job No." := Rec.GETFILTER("Job No.");
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CurrPage.UPDATE(FALSE);
    END;



    var
        DataJobUnitForProduction: Record 7207386;
        Job: Record 167;
        AssociateJUToRecord: Page 7207573;
        ActionOption: Option "Associate","Remove";
        NumberInt: Integer;
        JobDescription: Text[250];
        SA0: Decimal;
        SA1: Decimal;
        SA2: Decimal;
        CA0: Decimal;
        CA1: Decimal;
        CA2: Decimal;
        MultiCustJob: Boolean;
        FunctionQB: Codeunit 7207272;
        verAgrupaciones: Boolean;
        "--------------------------------------- Divisas": Integer;
        myCaptions: ARRAY[10] OF Text;
        Caption01a: TextConst ENU = 'Sales Amount (JC)', ESP = 'Importe venta (DC)';
        Caption01b: TextConst ENU = 'Sales amount', ESP = 'Importe venta';
        Caption02a: TextConst ENU = 'Direct Cost Amount (JC)', ESP = 'Importe coste directo (DC)';
        Caption02b: TextConst ENU = 'Direct Cost Amount', ESP = 'Importe coste directo';
        JobCurrencyExchangeFunction: Codeunit 7207332;
        useCurrencies: Boolean;
        edCurrencies: Boolean;
        edCurrencyCode: Boolean;
        edInvoiceCurrencyCode: Boolean;
        canEditJobsCurrencies: Boolean;
        canChangeFactboxCurrency: Boolean;
        ShowCurrency: Integer;

    LOCAL procedure SaveInitial();
    var
        Menu: TextConst ESP = 'Solo los que est�n a cero,Todos';
        opcion: Integer;
    begin
        opcion := STRMENU(Menu);
        if opcion = 0 then
            exit;

        DataJobUnitForProduction.RESET;
        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
        DataJobUnitForProduction.SETRANGE("Account Type", DataJobUnitForProduction."Account Type"::Unit);
        if (opcion = 1) then
            DataJobUnitForProduction.SETRANGE("Initial Sale Measurement", 0);
        if DataJobUnitForProduction.FINDSET(TRUE) then
            repeat
                DataJobUnitForProduction."Initial Sale Measurement" := DataJobUnitForProduction."Sale Quantity (base)";
                DataJobUnitForProduction.MODIFY;
            until DataJobUnitForProduction.NEXT = 0;
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        Job.INIT;
        rec."Job No." := '';
        if Rec.GETFILTER("Job No.") <> '' then begin
            rec."Job No." := Rec.GETFILTER("Job No.");
            Job.GET(rec."Job No.");
        end;
        JobDescription := FunctionQB.ShowDescriptionJob(rec."Job No.");

        //Si se pueden ver las divisas del proyecto
        JobCurrencyExchangeFunction.SetRecordCurrencies(Job, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        if useCurrencies then begin
            myCaptions[1] := Caption01a;
            myCaptions[2] := Caption02a;
        end ELSE begin
            myCaptions[1] := Caption01b;
            myCaptions[2] := Caption02b;
        end;

        //GAP029 -+
        MultiCustJob := rec.CheckMultiCust(rec."Job No.");

        SA0 := rec.SaleAmount(0);
        SA1 := rec.SaleAmount(1);
        SA2 := rec.SaleAmount(2);
        CA0 := rec.CostAmount(0);
        CA1 := rec.CostAmount(1);
        CA2 := rec.CostAmount(2);
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_BudgetCosts.PAGE.SetCurrency(ShowCurrency);
        CurrPage.FB_ContractedAmount.PAGE.SetCurrency(ShowCurrency);
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      JDC 25/07/19: - GAP029 KALAM. Se modifica "OnAfterGetRecord" y "OnNewRecord"
      JAV 26/07/19: - Se pasa el bot�n de cargar preciario a la cabecera
      JAV 03/02/19: - Se hace visible el bot�n de recalcular
      JAV 28/09/20: - QB 1.06.15 Nueva acci�n para traer precios de venta del preciario
      16219 01/02/22 DGG - Modificaciones para planificaci�n de Certificaciones. Se a�aden botones, "Planificar  Certificacion", y "Planificaci�n Global"
    }*///end
}








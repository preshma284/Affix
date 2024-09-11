page 7207638 "Cost Unit Data Quote"
{
    CaptionML = ENU = 'Cost Unit Data Quote', ESP = 'Datos unidad de coste oferta';
    SourceTable = 7207386;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = FILTER("Cost Unit"));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            group("group9")
            {

                group("group10")
                {

                    field("Indirect Cost Budget"; JobBudget."Budget Amount Cost Indirect")
                    {

                        CaptionML = ENU = 'Indirect Cost Budget', ESP = 'Importe Presupuesto';
                        Editable = false;
                    }

                }
                group("group12")
                {

                    field("JobBudget.Cod. Budget + ' - ' + JobBudget.Budget Name"; JobBudget."Cod. Budget" + ' - ' + JobBudget."Budget Name")
                    {

                        ShowCaption = false;
                    }

                }

            }
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code", Description;
                ShowAsTree = true;
                FreezeColumn = "Piecework Code";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Subtype Cost"; rec."Subtype Cost")
                {

                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Allocation Terms"; rec."Allocation Terms")
                {

                    StyleExpr = stLine;
                }
                field("Type Unit Cost"; rec."Type Unit Cost")
                {

                    StyleExpr = stLine;
                }
                field("% Expense Cost"; rec."% Expense Cost")
                {

                    Editable = ExpensesCostEditable;
                    StyleExpr = stLine;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    Editable = edMeasureBudgPieceworkSol;
                    StyleExpr = stMeasureBudgPieceworkSol;
                }
                field("Measure Pending Budget"; rec."Measure Pending Budget")
                {

                    Editable = MeasureBudgetPendingEditable;
                    StyleExpr = stLine;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    StyleExpr = stLine;
                }
                field("Planned Expense"; rec."Planned Expense")
                {

                    StyleExpr = stLine;
                }
                field("Periodic Cost"; rec."Periodic Cost")
                {

                    StyleExpr = stLine

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            //Name=<Action1900000004>;
            group("<Action1907935204>")
            {

                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = Card;

                    trigger OnAction()
                    BEGIN
                        ShowCard;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Bill of Item D&ata', ESP = 'D&atos de descompuesto';
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        ShowPiecework;
                    END;


                }
                action("ProportionalDistributionCost")
                {

                    CaptionML = ENU = 'Proportional Distribution Cost', ESP = 'R&epartir coste porporcional';
                    Image = ResourcePlanning;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        //JAV 18/03/19 - Unificar botones de acci�n
                        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                            DataPieceworkForProduction2.SETRANGE("Budget Filter", BudgetInProgress);
                        //JAV 18/03/19 - fin
                        // CLEAR(DistriProporBudgetCost);

                        //JAV 11/03/19: Pasamos al proceso fechas de inicio y fin del proyecto
                        Job.GET(rec."Job No.");
                        // DistriProporBudgetCost.setJob(Job."No.");  //JAV Se cambia el sistema
                                                                   //JAV 11/03/19 fin

                        // DistriProporBudgetCost.SETTABLEVIEW(DataPieceworkForProduction2);
                        // DistriProporBudgetCost.RUNMODAL;
                    END;


                }
                action("MoveBudgetInTime")
                {

                    CaptionML = ENU = 'Move Budget In Time', ESP = 'Mover presupuesto en el tiempo';
                    Image = CreateMovement;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                        // MoveCostsBudget: Report 7207356;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        //JAV 18/03/19 - Unificar botones de acci�n
                        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                            DataPieceworkForProduction2.SETRANGE("Budget Filter", BudgetInProgress);
                        //JAV 18/03/19 - fin
                        // CLEAR(MoveCostsBudget);
                        // MoveCostsBudget.SETTABLEVIEW(DataPieceworkForProduction2);
                        // MoveCostsBudget.RUNMODAL;
                    END;


                }
                action("PieceworkScheduling")
                {

                    CaptionML = ENU = 'Piecework Sch&eduling', ESP = '&Planificaci�n de UO';
                    Visible = TRUE;
                    Image = CalculateRegenerativePlan;


                    trigger OnAction()
                    BEGIN
                        SchedulePiecework;
                        //JAV 11/12/18: se llama desde aqu� para provechar la llamada anterior en otra acci�n
                        PAGE.RUNMODAL(PAGE::"Plan Job Units", DataJobUnitForProduction);
                        //JAV 11/12/18 fin
                    END;


                }

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
            }
            group(Category_Report)
            {
                actionref(ProportionalDistributionCost_Promoted; ProportionalDistributionCost)
                {
                }
                actionref(MoveBudgetInTime_Promoted; MoveBudgetInTime)
                {
                }
                actionref(PieceworkScheduling_Promoted; PieceworkScheduling)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 26/03/19: - Se lee el presupuesto en curso
        JobBudget.GET(CurrentJob, CurrentBudget);
        JobBudget.CALCFIELDS("Budget Amount Cost Indirect");
        //JAV 26/03/19 fin
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        Text011: TextConst ENU = 'You can not Rec.DELETE a larger drive if it is not deployed.', ESP = 'No se puede borrar una unidad de mayor si no esta desplegada.';
        Text008: TextConst ENU = 'The analytical budget will be calculated. Do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        Text005: TextConst ENU = 'The process is over.', ESP = 'El proceso ha terminado.';
        Text010: TextConst ENU = 'You can not define bill of item or plaificar in units of job of heading', ESP = 'No se puede definir descompuesto ni plaificar en unidades de obra de mayor';
        Text012: TextConst ENU = 'Preparing Planning Data Cost Unit # 1 #########', ESP = 'Preparando datos de planificaci�n unidad de coste #1#########';
        Text013: TextConst ENU = 'Does not have cost units that can be planned.', ESP = 'No tiene unidades de coste planificables.';
        MeasureBudgetPendingEditable: Boolean;
        ExpensesCostEditable: Boolean;
        JobBudget: Record 7207407;
        CurrentJob: Code[20];
        CurrentBudget: Code[20];
        NameBudget: Text[30];
        DescripcionIndent: Integer;
        CurrentExpansionStatus: Integer;
        PieceworkCodeEmphasize: Boolean;
        Identation: Integer;
        DescriptionEmphasize: Boolean;
        CostUnitTypeEmphasize: Boolean;
        PriceCostMeasureBudgetPendingEmphasize: Boolean;
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        Version: Boolean;
        Window: Dialog;
        DataPieceworkForProduction2: Record 7207386;
        // CostUnitPeriodify: Report 7207345;
        // DistriProporBudgetCost: Report 7207355;
        Text002: TextConst ENU = 'No bill of item or detail of measurement lines can be defined in major piecework.', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        BudgetInProgress: Code[20];
        DataJobUnitForProduction: Record 7207386;
        stLine: Text;
        stLineType: Text;
        stMeasureBudgPieceworkSol: Text;
        edMeasureBudgPieceworkSol: Boolean;

    LOCAL procedure OnFormatCodePiecework();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            PieceworkCodeEmphasize := TRUE;
        end;
    end;

    LOCAL procedure OnFormatDescription();
    begin
        DescripcionIndent := rec.Indentation;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DescriptionEmphasize := TRUE;
        end;
    end;

    LOCAL procedure OnFormatTypeCostUnit();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            CostUnitTypeEmphasize := TRUE;
        end;
    end;

    LOCAL procedure OnFormatExpensesCost();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            ExpensesCostEditable := TRUE;
        end;
    end;

    LOCAL procedure OnFormatAverCostPricePendBudget();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            PriceCostMeasureBudgetPendingEmphasize := TRUE;
        end;
    end;

    procedure PlanningUnitCost();
    var
        TMPExpectedTimeUnitData: Record 7207389;
        ExpectedTimeUnitData: Record 7207388;
        DataPieceworkForProduction: Record 7207386;
    begin
        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.");
        TMPExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
        TMPExpectedTimeUnitData.DELETEALL;

        Window.OPEN(Text012);
        ExpectedTimeUnitData.SETCURRENTKEY(ExpectedTimeUnitData."Job No.", ExpectedTimeUnitData."Piecework Code");
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Budget Filter", CurrentBudget);
        DataPieceworkForProduction.SETRANGE(Plannable, TRUE);
        if DataPieceworkForProduction.FINDSET then begin
            repeat
                Window.UPDATE(1, DataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Budget Code", CurrentBudget);
                ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                if ExpectedTimeUnitData.FINDSET then
                    repeat
                        CLEAR(TMPExpectedTimeUnitData);
                        TMPExpectedTimeUnitData.TRANSFERFIELDS(ExpectedTimeUnitData);
                        TMPExpectedTimeUnitData.INSERT;
                        DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");

                        TMPExpectedTimeUnitData."Expected Cost Amount" := ROUND(TMPExpectedTimeUnitData."Expected Measured Amount" *
                                                                DataPieceworkForProduction."Aver. Cost Price Pend. Budget", 0.01);
                        TMPExpectedTimeUnitData."Expected Production Amount" := ROUND(
                                   TMPExpectedTimeUnitData."Expected Measured Amount" *
                                   DataPieceworkForProduction.ProductionPrice, 0.01);
                        TMPExpectedTimeUnitData.MODIFY;
                    until ExpectedTimeUnitData.NEXT = 0;
            until DataPieceworkForProduction.NEXT = 0;
            Window.CLOSE;
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Plan Job Units", DataPieceworkForProduction);
        end ELSE
            ERROR(Text013);
    end;

    procedure ShowUnitCost();
    var
        DataCostByPiecework: Record 7207387;
        PG_BillOfItems: Page 7207515;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text010);

        if rec."Type Unit Cost" <> rec."Type Unit Cost"::External then begin
            DataCostByPiecework.RESET;
            DataCostByPiecework.SETRANGE("Job No.", rec."Job No.");
            DataCostByPiecework.SETRANGE("Piecework Code", rec."Piecework Code");
            DataCostByPiecework.SETRANGE("Cod. Budget", CurrentBudget);

            //JAV Abrir la page de descompuestos
            CLEAR(PG_BillOfItems);
            PG_BillOfItems.SETTABLEVIEW(DataCostByPiecework);
            PG_BillOfItems.RUNMODAL;
        end;
    end;

    procedure ReceivesJob(PCodeJob: Code[20]; PCodeBudget: Code[20]);
    begin
        CurrentJob := PCodeJob;
        CurrentBudget := PCodeBudget
    end;

    procedure ShowCard();
    var
        DataPieceworkForProduction: Record 7207386;
        JobPieceworkCard: Page 7207508;
    begin
        CLEAR(JobPieceworkCard);
        DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        Rec.FILTERGROUP(4);
        Rec.COPYFILTER("Budget Filter", DataPieceworkForProduction."Budget Filter");
        Rec.FILTERGROUP(0);
        if DataPieceworkForProduction.FINDFIRST then;

        JobPieceworkCard.SETTABLEVIEW(DataPieceworkForProduction);
        JobPieceworkCard.RUN;
    end;

    procedure ShowPiecework();
    var
        DataCostByPiecework: Record 7207387;
        PG_BillOfItems: Page 7207515;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);
        DataCostByPiecework.RESET;
        DataCostByPiecework.FILTERGROUP(2);
        DataCostByPiecework.SETRANGE("Job No.", rec."Job No.");
        DataCostByPiecework.SETRANGE("Piecework Code", rec."Piecework Code");
        if Rec.GETFILTER("Budget Filter") <> '' then
            DataCostByPiecework.SETFILTER("Cod. Budget", rec.GETFILTER("Budget Filter"));
        DataCostByPiecework.FILTERGROUP(0);

        //JAV Abrir la page de descompuestos
        CLEAR(PG_BillOfItems);
        PG_BillOfItems.SETTABLEVIEW(DataCostByPiecework);
        PG_BillOfItems.RUNMODAL;
    end;

    procedure SchedulePiecework();
    var
        LExpectedTimeUnitData: Record 7207388;
        LTMPExpectedTimeUnitData: Record 7207389;
        DialogWindow: Dialog;
        Text001: TextConst ENU = 'Preparing job unit planning data', ESP = 'Preparando datos de planificaci�n unidad de obra';
    begin
        LTMPExpectedTimeUnitData.RESET;
        LTMPExpectedTimeUnitData.SETCURRENTKEY("Job No.");
        LTMPExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
        LTMPExpectedTimeUnitData.DELETEALL;

        DialogWindow.OPEN(Text010);
        LExpectedTimeUnitData.SETCURRENTKEY(LExpectedTimeUnitData."Job No.", LExpectedTimeUnitData."Piecework Code");
        DataJobUnitForProduction.RESET;
        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
        DataJobUnitForProduction.SETRANGE("Budget Filter", BudgetInProgress);
        DataJobUnitForProduction.SETRANGE("Production Unit", TRUE);
        DataJobUnitForProduction.SETRANGE(Plannable, TRUE);
        if DataJobUnitForProduction.FINDSET then
            repeat
                DataJobUnitForProduction.CALCFIELDS("Measure Pending Budget New");
                // DialogWindow.UPDATE(1,DataJobUnitForProduction."Piecework Code");
                LExpectedTimeUnitData.SETRANGE("Job No.", DataJobUnitForProduction."Job No.");
                LExpectedTimeUnitData.SETRANGE("Piecework Code", DataJobUnitForProduction."Piecework Code");
                LExpectedTimeUnitData.SETRANGE("Budget Code", BudgetInProgress);
                LExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                if LExpectedTimeUnitData.FINDSET then
                    repeat
                        CLEAR(LTMPExpectedTimeUnitData);
                        LTMPExpectedTimeUnitData.TRANSFERFIELDS(LExpectedTimeUnitData);
                        LTMPExpectedTimeUnitData.INSERT;
                        DataJobUnitForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                        //if DataJobUnitForProduction."Account Type" = DataJobUnitForProduction."Account Type"::Unit then begin
                        LTMPExpectedTimeUnitData."Expected Cost Amount" := ROUND(LTMPExpectedTimeUnitData."Expected Measured Amount" *
                                                                  DataJobUnitForProduction."Aver. Cost Price Pend. Budget", 0.01);
                        LTMPExpectedTimeUnitData."Expected Production Amount" := ROUND(
                                     LTMPExpectedTimeUnitData."Expected Measured Amount" *
                                     DataJobUnitForProduction.ProductionPrice, 0.01);
                        if DataJobUnitForProduction."Measure Pending Budget New" <> 0 then
                            LTMPExpectedTimeUnitData."Expected Percentage" := LTMPExpectedTimeUnitData."Expected Measured Amount" * 100 /
                                                                                  DataJobUnitForProduction."Measure Pending Budget New"
                        ELSE
                            LTMPExpectedTimeUnitData."Expected Percentage" := 0;
                        LTMPExpectedTimeUnitData.MODIFY;
                    /*{end ELSE begin
                      LTMPExpectedTimeUnitData."Expected Measured Amount" := 0;
                      LTMPExpectedTimeUnitData."Expected Percentage" := 0;
                      LTMPExpectedTimeUnitData.MODIFY;
                    end;}*/
                    until LExpectedTimeUnitData.NEXT = 0;

            until DataJobUnitForProduction.NEXT = 0;
        DialogWindow.CLOSE;
        COMMIT;
        PAGE.RUNMODAL(PAGE::"Plan Job Units", DataJobUnitForProduction);
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        //Estilos de campos
        stLine := rec.GetStyle('');
        stLineType := rec.GetStyle('StrongAccent');

        if (rec."No. Medition detail Cost" <> 0) then
            stMeasureBudgPieceworkSol := rec.GetStyle('Subordinate')
        ELSE
            stMeasureBudgPieceworkSol := rec.GetStyle('StandardAccent');

        Rec.CALCFIELDS("No. Medition detail Cost");
        edMeasureBudgPieceworkSol := (rec."No. Medition detail Cost" = 0);
    end;

    // begin//end
}








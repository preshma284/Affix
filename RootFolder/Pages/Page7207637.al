page 7207637 "Piecework Data Quote"
{
    CaptionML = ENU = 'Piecework Data Quote', ESP = 'Datos unidad de obra oferta';
    InsertAllowed = false;
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));
    DataCaptionFields = "Job No.";
    PageType = Worksheet;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            field("Job.Direct Cost Amount PieceWork"; Job."Direct Cost Amount PieceWork")
            {

                CaptionML = ENU = 'Direct Cost Budget', ESP = 'Presupuesto de Costes Directos';
                Editable = FALSE;
                Style = Standard;
                StyleExpr = TRUE;
            }
            field("TotalAmountStudiedBudget"; TotalAmountStudiedBudget)
            {

                CaptionML = ENU = 'Total Amount Studied Budget', ESP = 'Total Importe estudiado presupuesto';
                // Numeric=false;
                Enabled = FALSE;
            }
            field("PercentStudiedBudget"; PercentStudiedBudget)
            {

                CaptionML = ENU = '% Studied/Budget', ESP = '% Estudiado/presupuesto';
                Enabled = FALSE;
            }
            repeater("table")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code", Description;
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        rec."Piecework Code" := UPPERCASE(rec."Piecework Code");
                        IF (xRec."Piecework Code" <> rec."Piecework Code") AND (xRec."Piecework Code" <> '') THEN BEGIN
                            IF NOT DataJobUnitForProduction.GET(rec."Job No.", rec."Piecework Code") THEN BEGIN
                                IF DataJobUnitForProduction.GET(xRec."Job No.", xRec."Piecework Code") THEN BEGIN
                                    DataJobUnitForProduction.DELETE;
                                    DataJobUnitForProduction.TRANSFERFIELDS(Rec, TRUE);
                                    DataJobUnitForProduction."Piecework Code" := rec."Piecework Code";
                                    IF DataJobUnitForProduction.INSERT THEN;
                                END;
                            END;
                        END;
                        OnAfterValidaCodePiecewrk;
                    END;


                }
                field("Totaling"; rec."Totaling")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Indentation"; rec."Indentation")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("% Of Margin"; rec."% Of Margin")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;
                }
                field("Rental Unit"; rec."Rental Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("ProductionPrice"; rec."ProductionPrice")
                {

                    CaptionML = ENU = 'Production Price', ESP = 'Precio de Produccion';
                    DecimalPlaces = 0 : 6;
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    CaptionML = ENU = 'Measure Budg. Piecework sol', ESP = 'Medici�n ppto. unidad obra';
                    BlankZero = true;
                    Editable = edMeasureBudgPieceworkSol;
                    StyleExpr = stMeasureBudgPieceworkSol;

                    ; trigger OnValidate()
                    BEGIN
                        OnABudgetMeasurePieceworkSol;
                        funOnAfterGetrecord;
                    END;


                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Measure Performed Budget"; rec."Measure Performed Budget")
                {

                    Visible = False;
                    Editable = False;
                    StyleExpr = stLine;
                }
                field("Measure Pending Budget New"; rec."Measure Pending Budget New")
                {

                    CaptionML = ENU = 'Measure Pending Budget', ESP = 'Medici�n ppto. pendiente';
                    BlankZero = true;
                    Visible = false;
                    Editable = False;
                    StyleExpr = stLine;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    CaptionML = ENU = 'Amount Cost Budget.', ESP = 'Importe coste ppto.';
                    StyleExpr = stLine;
                }
                field("Amount Budget Cost Pending"; rec."Amount Budget Cost Pending")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Amount Budget Cost Performed"; rec."Amount Budget Cost Performed")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Cost Price"; rec."CostPrice")
                {

                    CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                    Visible = seeMeasureDif;
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("MeasureDif"; MeasureDif)
                {

                    CaptionML = ESP = 'Diferencia Venta/Coste';
                    Visible = seeMeasureDif;
                    StyleExpr = stMeasureDif;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    Visible = seeMeasureDif;
                    StyleExpr = stLine;
                }
                field("Sale Amount"; rec."Sale Amount")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    BlankZero = true;
                    Visible = False;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        OnAfterBudgetProductionAmount;
                    END;


                }
                field("amountProductionInProgress"; rec."amountProductionInProgress")
                {

                    CaptionML = ENU = 'Amount Production In Progress', ESP = 'Importe producci�n en tr�mite';
                    BlankZero = true;
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("AmountProductionAccepted"; rec."AmountProductionAccepted")
                {

                    CaptionML = ENU = 'Amount Production Accepted', ESP = 'Importe producci�n aceptada';
                    BlankZero = true;
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Amount Sale Performed (JC)"; rec."Amount Sale Performed (JC)")
                {

                    BlankZero = true;
                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("% Processed Production"; rec."% Processed Production")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Reassuring"; rec."Reassuring")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Amount Sale Contract"; rec."Amount Sale Contract")
                {

                    StyleExpr = stLine;
                }
                field("Record Type"; rec."Record Type")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Studied"; rec."Studied")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 20/03/19: - Se mejora el c�lculo del importe estudiado, se recalcula lo estudiado al cambiar el valor
                        //CurrPage.UPDATE;
                        Rec.MODIFY(TRUE);
                        CalculateTotalAmountStudiedBudget;
                        CurrPage.UPDATE(FALSE);
                        //JAV 20/03/19
                    END;


                }

            }
            group("group60")
            {

                part("PG_BillOfItems"; 7207515)
                {

                    SubPageView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                    SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Cod. Budget" = FIELD("Budget Filter");
                    Visible = verDescompuestos;
                }
                part("MeasurementLines"; 7207666)
                {
                    SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Code Budget" = FIELD("Budget Filter");
                    Visible = verMediciones;
                    UpdatePropagation = Both;
                }
                part("LineasDescripcion"; 7207570)
                {

                    SubPageView = SORTING("Table", "Key1", "Key2");
                    SubPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Visible = verTextos;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("AccProyectos")
            {

                CaptionML = ENU = '&Acciones', ESP = '&Acciones';
                Visible = VisibleJobs;
                action("SurveyABC")
                {

                    CaptionML = ENU = 'Survey ABC', ESP = 'Estudio ABC';
                    Image = CalculateSimulation;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN

                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE("Budget Filter", BudgetInProgress);
                        IF DataPieceworkForProduction.FINDFIRST THEN
                            REPEAT
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                                DataPieceworkForProduction."Amount Cost Budget Planning" := DataPieceworkForProduction."Amount Cost Budget (JC)";
                                DataPieceworkForProduction.MODIFY;
                            UNTIL DataPieceworkForProduction.NEXT = 0;

                        StudyABC := NOT StudyABC;
                        CurrPage.UPDATE;
                        IF StudyABC THEN BEGIN
                            Rec.SETRANGE("Account Type", rec."Account Type"::Unit);
                            Rec.SETCURRENTKEY("Job No.", "Account Type", "Amount Cost Budget Planning");
                            rec.ASCENDING(FALSE);
                        END ELSE BEGIN
                            Rec.SETRANGE("Account Type");
                            Rec.SETCURRENTKEY("Job No.", "Piecework Code");
                            rec.ASCENDING(TRUE);
                        END;
                    END;


                }
                action("MarkStudiedDatapiecework")
                {

                    CaptionML = ENU = 'Mark Studied Data Piecework', ESP = 'Marcar estudiado';
                    Image = Approval;
                    trigger OnAction()
                    VAR
                        ConfirmMarkTrue: TextConst ENU = 'Do you want to Rec.MARK Datapiecework as studied?', ESP = '�Desea marcar como estudiado la unidad de obra?';
                        ConfirmMarkFalse: TextConst ENU = 'Do you want to unmark Datapiecework as studied?', ESP = '�Desea desmarcar como estudiado la unidad de obra?';
                        //  DataPieceworkForProductionAux : Record 7207386;
                        DataPieceworkForProductionAux: Record 7207386;
                        ConfirmMark: TextConst ESP = '�Desea cambiar la marca de estudiado a las unidades de obra seleccionadas?';
                        //  tmpDataPieceworkForProductionAux : TEMPORARY Record 7207386;
                        tmpDataPieceworkForProductionAux: Record 7207386 temporary;
                        i: Integer;
                    BEGIN
                        //JAV 20/03/19: - Cambio el proceso de marcar para que funcione mejor
                        IF CONFIRM(ConfirmMark, TRUE) THEN BEGIN
                            //Guardo los datos en un temporal
                            tmpDataPieceworkForProductionAux.RESET;
                            tmpDataPieceworkForProductionAux.DELETEALL;
                            CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionAux);
                            Rec.COPYFILTER("Budget Filter", DataPieceworkForProductionAux."Budget Filter"); // 19/03/2019
                            IF DataPieceworkForProductionAux.FINDSET(FALSE) THEN BEGIN
                                REPEAT
                                    tmpDataPieceworkForProductionAux := DataPieceworkForProductionAux;
                                    tmpDataPieceworkForProductionAux.INSERT;
                                UNTIL DataPieceworkForProductionAux.NEXT = 0;
                            END;

                            //Proceso por niveles ya que los padres me cambian a los hijos
                            i := 0;
                            REPEAT
                                CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionAux);
                                Rec.COPYFILTER("Budget Filter", DataPieceworkForProductionAux."Budget Filter"); // 19/03/2019
                                DataPieceworkForProductionAux.SETRANGE(Indentation, i);
                                IF DataPieceworkForProductionAux.FINDSET THEN BEGIN
                                    REPEAT
                                        //Si est� en el temporal, lo cambio
                                        tmpDataPieceworkForProductionAux.RESET;
                                        tmpDataPieceworkForProductionAux.SETRANGE("Piecework Code", DataPieceworkForProductionAux."Piecework Code");
                                        IF (NOT tmpDataPieceworkForProductionAux.ISEMPTY) THEN BEGIN
                                            DataPieceworkForProductionAux.VALIDATE(Studied, NOT DataPieceworkForProductionAux.Studied);
                                            DataPieceworkForProductionAux.MODIFY(TRUE);
                                        END;
                                        //Quito del temporal los ya cambiados
                                        tmpDataPieceworkForProductionAux.RESET;
                                        IF (DataPieceworkForProductionAux."Account Type" = DataPieceworkForProductionAux."Account Type"::Heading) THEN BEGIN
                                            IF DataPieceworkForProductionAux.Totaling = '' THEN
                                                DataPieceworkForProductionAux.VALIDATE(Totaling);
                                            tmpDataPieceworkForProductionAux.SETFILTER("Piecework Code", DataPieceworkForProductionAux.Totaling);
                                            IF tmpDataPieceworkForProductionAux.FINDSET THEN
                                                REPEAT
                                                    tmpDataPieceworkForProductionAux.DELETE;
                                                UNTIL tmpDataPieceworkForProductionAux.NEXT = 0;
                                            //tmpDataPieceworkForProductionAux.DELETEALL;
                                        END ELSE BEGIN
                                            tmpDataPieceworkForProductionAux.SETRANGE("Piecework Code", DataPieceworkForProductionAux."Piecework Code");
                                            tmpDataPieceworkForProductionAux.DELETEALL;
                                        END;
                                    UNTIL DataPieceworkForProductionAux.NEXT = 0;
                                END;
                                i += 1;
                                tmpDataPieceworkForProductionAux.RESET;
                            UNTIL tmpDataPieceworkForProductionAux.COUNT = 0;
                            CalculateTotalAmountStudiedBudget;
                            CurrPage.UPDATE(FALSE);
                        END;

                        //  {--------------------------------------------------------------------------------------------------

                        //  //QB4932

                        //  IF DataPieceworkForProductionAux.Studied THEN BEGIN
                        //    IF NOT CONFIRM(ConfirmMarkFalse, TRUE) THEN
                        //      EXIT;
                        //  END ELSE BEGIN
                        //    IF NOT CONFIRM(ConfirmMarkTrue, TRUE) THEN
                        //      EXIT;
                        //  END;

                        //  CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionAux);
                        //  Rec.COPYFILTER("Budget Filter",DataPieceworkForProductionAux."Budget Filter"); // 19/03/2019
                        //  IF DataPieceworkForProductionAux.FINDSET THEN BEGIN
                        //    REPEAT
                        //      DataPieceworkForProductionAux.VALIDATE(rec.Studied, NOT DataPieceworkForProductionAux.Studied);
                        //      DataPieceworkForProductionAux.MODIFY(TRUE);
                        //    UNTIL DataPieceworkForProductionAux.NEXT = 0;
                        //  END;
                        //  //CalculateTotalAmountStudiedBudget;
                        //  CurrPage.UPDATE;
                        //  ---------------------------------------------------------------------------------------------------}
                    END;
                }
                action("CopyBillOfItemsOfJUFromCostDatabase")
                {

                    CaptionML = ENU = 'Copy Bill Of Items Of JU From Cost Database', ESP = 'Copiar descompuesto de UO desde preciarios';
                    Image = CopyFromBOM;

                    trigger OnAction()
                    VAR
                        PriceBillofItemAssignment: Page 7207581;
                    BEGIN
                        CLEAR(PriceBillofItemAssignment);
                        IF rec."Piecework Code" = '' THEN
                            ERROR(Text009);

                        PriceBillofItemAssignment.GetPiecework(Rec, BudgetInProgress);
                        PriceBillofItemAssignment.DefinitionFilter(rec.Type::Piecework);
                        PriceBillofItemAssignment.RUNMODAL;
                        CurrPage.UPDATE;
                    END;


                }
                action("DeletePreviousAndCopyBillOfItems")
                {

                    CaptionML = ENU = 'Copy Bill Of Items Of JU From Cost Database and Rec.DELETE Previous', ESP = 'Copiar descompuesto de UO desde preciarios y borrar existentes';
                    Image = CopyFromBOM;

                    trigger OnAction()
                    VAR
                        PriceBillofItemAssignment: Page 7207581;
                        DataCostByPiecework: Record 7207387;
                    BEGIN
                        CLEAR(PriceBillofItemAssignment);
                        IF rec."Piecework Code" = '' THEN
                            ERROR(Text009);

                        DataCostByPiecework.RESET;
                        DataCostByPiecework.SETRANGE("Job No.", Rec."Job No.");
                        DataCostByPiecework.SETRANGE("Piecework Code", Rec."Piecework Code");
                        DataCostByPiecework.DELETEALL;
                        COMMIT;

                        PriceBillofItemAssignment.GetPiecework(Rec, BudgetInProgress);
                        PriceBillofItemAssignment.DefinitionFilter(rec.Type::Piecework);
                        PriceBillofItemAssignment.RUNMODAL;
                        CurrPage.UPDATE;
                    END;


                }
                action("CopyPieceworkAndBillOfItemsFromCostDatabase")
                {

                    CaptionML = ENU = 'Copy Piecework And Bill Of Items From Cost Database', ESP = 'Copiar UO y descompuestos desde preciarios';
                    Image = SplitChecks;

                    trigger OnAction()
                    VAR
                        BringPieceworktoTheJob: Page 7207584;
                    BEGIN
                        BringPieceworktoTheJob.ReceivedJob(rec."Job No.", Rec);
                        BringPieceworktoTheJob.RUNMODAL;
                        CLEAR(BringPieceworktoTheJob);
                    END;


                }
                action("DeletePreviousPworkAndBillOfItem")
                {

                    CaptionML = ENU = 'Copy Piecework And Bill Of Items From Cost Database and Rec.DELETE Previous', ESP = 'Copiar UO y descompuestos desde preciarios y borrar existentes';
                    Image = SplitChecks;

                    trigger OnAction()
                    VAR
                        BringPieceworktoTheJob: Page 7207584;
                        DataCostByPiecework: Record 7207387;
                    BEGIN

                        BringPieceworktoTheJob.ReceivedJob(rec."Job No.", Rec);
                        BringPieceworktoTheJob.RUNMODAL;
                        CLEAR(BringPieceworktoTheJob);
                    END;


                }
                action("CalculateAnalyticalBudget")
                {

                    CaptionML = ENU = '&Calculate Analytical Budget', ESP = '&Calcular Ppto. analitico';
                    Image = CalculateConsumption;

                    trigger OnAction()
                    BEGIN
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            //JAV 18/03/19 - Se cambia el campo Job.status por el Job."Card type"
                            //  IF Job.GET("Job No.") THEN BEGIN
                            //    IF (Job."Job Type" = Job."Job Type"::Operative) AND
                            //       (Job.Status = Job.Status::Planning) AND (Job."Original Quote Code" <> '') THEN
                            //      JobOrVersion :=TRUE
                            //    ELSE
                            //      JobOrVersion := FALSE;
                            //  END;
                            Job.GET(rec."Job No."); //Tiene que existir si hemos llegado a esta p�gina, si no mejor dar un error
                            JobOrVersion := (Job."Job Type" = Job."Job Type"::Operative) AND (Job."Card Type" = Job."Card Type"::Estudio) AND (Job."Original Quote Code" <> '');
                            //JAV 18/03/19 fin

                            DataJobUnitForProduction.RESET;
                            DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                            IF DataJobUnitForProduction.FIND('-') THEN BEGIN
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataJobUnitForProduction, JobOrVersion, rec."Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
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
            group("group13")
            {
                CaptionML = ESP = 'Ver';
                // ActionContainerType=ActivityButtons ;
                group("group14")
                {
                    CaptionML = ENU = 'View', ESP = 'Ver';
                    Image = ViewPage;
                    action("action11")
                    {
                        CaptionML = ESP = 'Descompuestos';

                        trigger OnAction()
                        BEGIN
                            //Ver solo descompuestos
                            verDescompuestos := TRUE;
                            verMediciones := FALSE;
                            verTextos := FALSE;
                        END;


                    }
                    action("action12")
                    {
                        CaptionML = ESP = 'Descompuestos+Textos';

                        trigger OnAction()
                        BEGIN
                            //Ver descompuesto+textos
                            verDescompuestos := TRUE;
                            verMediciones := FALSE;
                            verTextos := TRUE;
                        END;


                    }
                    action("action13")
                    {
                        CaptionML = ESP = 'Descompuestos+Medicion';

                        trigger OnAction()
                        BEGIN
                            //Ver Descompuestos+Medicion
                            verDescompuestos := TRUE;
                            verMediciones := TRUE;
                            verTextos := FALSE;
                        END;


                    }
                    action("action14")
                    {
                        CaptionML = ESP = 'Medici�n+Textos';


                        trigger OnAction()
                        BEGIN
                            //Ver Medici�n+Textos
                            verDescompuestos := FALSE;
                            verMediciones := TRUE;
                            verTextos := TRUE;
                        END;


                    }

                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(SurveyABC_Promoted; SurveyABC)
                {
                }
                actionref(MarkStudiedDatapiecework_Promoted; MarkStudiedDatapiecework)
                {
                }
                actionref(CopyBillOfItemsOfJUFromCostDatabase_Promoted; CopyBillOfItemsOfJUFromCostDatabase)
                {
                }
                actionref(DeletePreviousAndCopyBillOfItems_Promoted; DeletePreviousAndCopyBillOfItems)
                {
                }
                actionref(CopyPieceworkAndBillOfItemsFromCostDatabase_Promoted; CopyPieceworkAndBillOfItemsFromCostDatabase)
                {
                }
                actionref(DeletePreviousPworkAndBillOfItem_Promoted; DeletePreviousPworkAndBillOfItem)
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
        CalculateTotalAmountStudiedBudget;
        CurrPage.UPDATE;

        //JAV 08/05/19: - Se ponen las subpages igual que en obras. Poner visibles las pages del pie seg�n la configuraci�n
        QuoBuildingSetup.GET;
        verDescompuestos := (QuoBuildingSetup."Ver en Costes Directos" IN
                               [QuoBuildingSetup."Ver en Costes Directos"::d,
                                QuoBuildingSetup."Ver en Costes Directos"::dm,
                                QuoBuildingSetup."Ver en Costes Directos"::dt]);
        verTextos := (QuoBuildingSetup."Ver en Costes Directos" IN
                               [QuoBuildingSetup."Ver en Costes Directos"::dt,
                                QuoBuildingSetup."Ver en Costes Directos"::mt]);
        verMediciones := (QuoBuildingSetup."Ver en Costes Directos" IN
                               [QuoBuildingSetup."Ver en Costes Directos"::dm,
                                QuoBuildingSetup."Ver en Costes Directos"::mt]);

        //JAV 25/08/20: - Ver datos de venta
        seeMeasureDif := FALSE;
        IF (Job.GET(Rec."Job No.")) THEN BEGIN
            seeMeasureDif := (NOT Job."Separation Job Unit/Cert. Unit");
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetrecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetrecord;
    END;



    var
        Job: Record 167;
        DataJobUnitForProduction: Record 7207386;
        JobBudget: Record 7207407;
        DataPieceworkForProduction2: Record 7207386;
        QuoBuildingSetup: Record 7207278;
        ConvertToBudgetxCA: Codeunit 7207282;
        // DistriProporBudgetCost: Report 7207355;
        BudgetInProgress: Code[20];
        VisibleJobs: Boolean;
        JobOrVersion: Boolean;
        DescriptionIndent: Integer;
        JobInProgress: Code[20];
        StudyABC: Boolean;
        Text001: TextConst ENU = 'Bill of items and measure lines details cannot be defined in heading pieceworks', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        Text005: TextConst ENU = 'The process is over.', ESP = 'El proceso ha terminado.';
        Text008: TextConst ENU = 'The analytical budget will be calculated. Do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        Text009: TextConst ENU = 'You must create the code of Piecework before assigning the data.', ESP = 'Debe de crear el c�digo de Unidad de obra antes de asignar los datos.';
        Text010: TextConst ENU = 'Preparing work unit planning data #1#########', ESP = 'Preparaci�n de los datos de planificaci�n de la unidad de obra #1#########';
        TotalAmountStudiedBudget: Decimal;
        PercentStudiedBudget: Decimal;
        TotalAmountCostBudget: Decimal;
        MeasureDif: Decimal;
        verDescompuestos: Boolean;
        verMediciones: Boolean;
        verTextos: Boolean;
        stLine: Text;
        stLineType: Text;
        stMeasureBudgPieceworkSol: Text;
        edMeasureBudgPieceworkSol: Boolean;
        seeMeasureDif: Boolean;
        stMeasureDif: Text;

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
                DialogWindow.UPDATE(1, DataJobUnitForProduction."Piecework Code");
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

    procedure ShowPiecework();
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text001);

        DataJobUnitForProduction.RESET;
        DataJobUnitForProduction.FILTERGROUP(2);
        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
        DataJobUnitForProduction.SETRANGE("Account Type", DataJobUnitForProduction."Account Type"::Unit);
        DataJobUnitForProduction.SETRANGE("Production Unit", TRUE);
        DataJobUnitForProduction.SETRANGE(Type, DataJobUnitForProduction.Type::Piecework);
        DataJobUnitForProduction.FILTERGROUP(0);
        DataJobUnitForProduction.SETRANGE("Budget Filter", BudgetInProgress);
        DataJobUnitForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        if DataJobUnitForProduction.FINDFIRST then begin
            DataJobUnitForProduction.SETRANGE("Piecework Code");
            PAGE.RUNMODAL(PAGE::"Piecework Bill of Items Card", DataJobUnitForProduction);
        end;
    end;

    procedure ShowMeasureLinesPiecework();
    var
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text001);
        ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", BudgetInProgress, rec."Piecework Code");
    end;

    LOCAL procedure OnAfterValidaCodePiecewrk();
    begin
        CurrPage.UPDATE(TRUE);
    end;

    LOCAL procedure OnABudgetMeasurePieceworkSol();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    LOCAL procedure OnAfterBudgetProductionAmount();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    procedure ReceivedJob(PJob: Code[20]; Pbudget: Code[20]);
    begin
        JobInProgress := PJob;
        BudgetInProgress := Pbudget;
    end;

    LOCAL procedure CalculateTotalAmountStudiedBudget();
    var
        DataPieceworkForProduction3: Record 7207386;
    begin
        /*{
        //QBV102>>
        CLEAR(TotalAmountStudiedBudget);
        CLEAR(TotalAmountCostBudget);
        if Rec."Job No."<>'' then begin
          Job.GET(rec."Job No.");
          Job.CALCFIELDS("Direct Cost Amount PieceWork");
        end;
        DataPieceworkForProduction3.RESET;
        DataPieceworkForProduction3.SETRANGE( "Job No.", rec. "Job No.");
        DataPieceworkForProduction3.SETRANGE("Account Type",DataPieceworkForProduction3."Account Type"::Unit);
        DataPieceworkForProduction3.SETRANGE(Studied,TRUE);
        if DataPieceworkForProduction3.FINDSET then begin
          repeat
            DataPieceworkForProduction3.CALCFIELDS("Amount Studied Budget","Total Amount Cost Budget");//,"Amount Cost Budget");
            TotalAmountStudiedBudget += DataPieceworkForProduction3."Amount Studied Budget";
            //TotalAmountCostBudget += DataPieceworkForProduction3."Amount Cost Budget"; //-QB1103
          until DataPieceworkForProduction3.NEXT=0;
        end;
        }*/
        //QBV102>>
        CLEAR(TotalAmountStudiedBudget);
        CLEAR(TotalAmountCostBudget);
        if Rec."Job No." <> '' then begin
            Job.GET(rec."Job No.");
            Job.CALCFIELDS("Direct Cost Amount PieceWork");
        end;
        DataPieceworkForProduction3.RESET;
        DataPieceworkForProduction3.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction3.SETRANGE("Account Type", DataPieceworkForProduction3."Account Type"::Unit);
        if DataPieceworkForProduction3.FINDSET then begin
            repeat
                //JAV 20/03/19: - Se cambia el campo del c�lculo por otro mas adecuado
                //DataPieceworkForProduction3.CALCFIELDS("Amount Studied Budget","Total Amount Cost Budget"); //   ,"Amount Cost Budget LCY");
                //TotalAmountStudiedBudget += DataPieceworkForProduction3."Amount Studied Budget";
                //TotalAmountCostBudget += DataPieceworkForProduction3."Amount Cost Budget"; //-QB1103
                if (DataPieceworkForProduction3.Studied) then begin
                    DataPieceworkForProduction3.CALCFIELDS("Amount Cost Budget (JC)");
                    TotalAmountStudiedBudget += DataPieceworkForProduction3."Amount Cost Budget (JC)";
                end;
            //JAV 20/03/19 fin
            until DataPieceworkForProduction3.NEXT = 0;
        end;

        //-QB1103
        if Job."Direct Cost Amount PieceWork" <> 0 then
            PercentStudiedBudget := (TotalAmountStudiedBudget / Job."Direct Cost Amount PieceWork") * 100;
        //+QB1103

        //QBV102<<
    end;

    LOCAL procedure funOnAfterGetrecord();
    begin
        //Estilos de campos
        stLine := rec.GetStyle('');
        stLineType := rec.GetStyle('StrongAccent');

        Rec.CALCFIELDS("No. Medition detail Cost");
        if (rec."No. Medition detail Cost" <> 0) then
            stMeasureBudgPieceworkSol := rec.GetStyle('Subordinate')
        ELSE
            stMeasureBudgPieceworkSol := rec.GetStyle('StandardAccent');

        edMeasureBudgPieceworkSol := (rec."No. Medition detail Cost" = 0);

        MeasureDif := rec."Sale Quantity (base)" - rec."Measure Budg. Piecework Sol";
        CASE TRUE OF
            (MeasureDif > 0):
                stMeasureDif := rec.GetStyle('Favorable');
            (MeasureDif = 0):
                stMeasureDif := rec.GetStyle('Standard');
            (MeasureDif < 0):
                stMeasureDif := rec.GetStyle('Attention');
        end;
    end;

    // begin
    /*{
      NZG 16/01/18: - QBV102 A�adidos los campos rec."Studied" y "Amount Studied Budget" y el total estudiado.
      NZG 31/01/18: - QBV1096 A�adidas las acciones desde la page 7000373 y a�adiendo dos borrando descompuestos anteriores.
      PEL 11/09/18: - QB1103 % estudiado/presupuesto
      JAV 20/03/19: - Se corrige un error en la llamada a las l�neas de medici�n
                    - Se mejora el c�lculo del importe estudiado
      JAV 08/05/19: - Se ponen las subpages igual que en obras
      PER 28/08/19: - Se a�aden las acciones "CalculateAnalyticalBudget", "ProportionalDistributionCost", "MoveBudgetInTime" y "PieceworkScheduling"
      JAV 12/04/22: - QB 1.10.35 Se eliminan los campos DataPieceworkForProduction.Activable y JobLedgEntry.Activate porque no se usan para nada
    }*///end
}








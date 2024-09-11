page 7207620 "General Piecework RTC"
{
    CaptionML = ENU = 'General Piecework RTC', ESP = 'General Unidad de obra RTC';
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Production Unit" = CONST(true));
    PageType = ListPart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code";
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        rec."Piecework Code" := UPPERCASE(rec."Piecework Code");
                        IF (xRec."Piecework Code" <> rec."Piecework Code") AND (xRec."Piecework Code" <> '') THEN BEGIN
                            IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code") THEN BEGIN
                                IF DataPieceworkForProduction.GET(xRec."Job No.", xRec."Piecework Code") THEN BEGIN
                                    DataPieceworkForProduction.TRANSFERFIELDS(Rec, TRUE);
                                    DataPieceworkForProduction."Piecework Code" := rec."Piecework Code";
                                    IF DataPieceworkForProduction.INSERT THEN;
                                END;
                            END;
                        END;
                        OnAfterValidaPieceworkCode;
                    END;


                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    StyleExpr = stLine;
                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                    StyleExpr = stLine;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Totaling"; rec."Totaling")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Indentation"; rec."Indentation")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    StyleExpr = stLine;
                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Type"; rec."Type")
                {

                    StyleExpr = stLine;
                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    Editable = edMeasureBudgPieceworkSol;
                    StyleExpr = stMeasureBudgPieceworkSol;
                }
                field("Precio coste med. ppto pend"; rec."Aver. Cost Price Pend. Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (LCY)"; rec."Amount Cost Budget (LCY)")
                {

                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    StyleExpr = stLineVenta;
                }
                field("Margen"; rec."CalculateMarginBudget")
                {

                    CaptionML = ENU = 'Margin', ESP = 'Margen';
                    StyleExpr = stLine;
                }
                field("% Margen"; rec."CalculateMarginBudgetPerc")
                {

                    CaptionML = ENU = '% Margin', ESP = '% Margen';
                    StyleExpr = stLine;
                }
                field("PriceSales"; rec."PriceSales")
                {

                    CaptionML = ESP = 'Precio Vta. Calculado';
                    Visible = seePrince1;
                    StyleExpr = stLineVenta;
                }
                field("Contract Price"; rec."Contract Price")
                {

                    Visible = seePrince2;
                    Editable = false;
                    StyleExpr = stLineVenta;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    Visible = seePrince2;
                    StyleExpr = stLineVenta;
                }
                field("Total Measurement Production"; rec."Total Measurement Production")
                {

                    StyleExpr = stLine;
                }
                field("Importe coste realizado"; rec."Amount Cost Performed (JC)")
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

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';

            }
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
                CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                Image = Note;

                trigger OnAction()
                BEGIN
                    ShowComments;
                END;


            }
            action("action3")
            {
                CaptionML = ENU = 'Test', ESP = 'Test';
                Promoted = true;
                PromotedIsBig = true;
                Image = TestReport;
                PromotedCategory = Process;

                trigger OnAction()
                VAR
                    CostPieceworkJobIdent: Codeunit 7207296;
                BEGIN
                    //JAV 05/10/19: - Se a�ade el test en la lista de unidades de obra
                    CLEAR(CostPieceworkJobIdent);
                    CostPieceworkJobIdent.Process(rec."Job No.", rec."Budget Filter", 1);
                END;


            }
            group("group6")
            {
                CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                Image = Dimensions;
                action("action4")
                {
                    CaptionML = ENU = 'Dimensions Individual', ESP = 'Dimensiones Individuales';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        ShowDimensionsIndi;
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Dimensions Multiples', ESP = 'Dimensiones m�ltiples';
                    Image = DimensionSets;

                    trigger OnAction()
                    BEGIN
                        ShowDimensionGlobal;
                    END;


                }

            }
            action("Calculate")
            {

                CaptionML = ESP = 'Calcular U.O.';
                Visible = seeCalculate;
                Enabled = enCalculate;
                Image = Calculate;


                trigger OnAction()
                VAR
                    JobBudget: Record 7207407;
                    Job: Record 167;
                    RateBudgetsbyPiecework: Codeunit 7207329;
                    Text000: TextConst ENU = 'CLOSED BUDGET', ESP = 'PRESUPUESTO CERRADO';
                    Text003: TextConst ESP = 'false ha indicado la fecha en el presupuesto %1, no lo puede calcular';
                    BudgetNo: Text;
                BEGIN
                    //JAV 25/03/22: - QB 1.10.27 Nuevo bot�n para calcular una sola unidad de obra

                    Rec.FILTERGROUP(4);
                    BudgetNo := Rec.GETFILTER("Budget Filter");
                    Rec.FILTERGROUP(0);

                    Job.GET(rec."Job No.");
                    JobBudget.GET(Rec."Job No.", BudgetNo);
                    IF (JobBudget."Budget Date" = 0D) THEN
                        ERROR(Text003, JobBudget."Cod. Budget");

                    //Calcula solo esa unidad de obra del presupuesto
                    CLEAR(RateBudgetsbyPiecework);
                    IF JobBudget.Status <> JobBudget.Status::Close THEN BEGIN
                        RateBudgetsbyPiecework.SetDataPiecework(Rec."Piecework Code", FALSE, TRUE);
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget)
                    END ELSE
                        MESSAGE(Text000);
                END;


            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");

        //JAV 25/03/22: - QB 1.10.27 Nuevo bot�n para calcular una sola unidad de obra
        seeCalculate := FunctionQB.IsQBAdmin;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetStyles;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        // BringCostDatabase: Report 7207277;
        FunctionQB: Codeunit 7207272;
        stLine: Text;
        stLineVenta: Text;
        stLineType: Text;
        stMeasureBudgPieceworkSol: Text;
        edMeasureBudgPieceworkSol: Boolean;
        seeAditionalCode: Boolean;
        seePrince1: Boolean;
        seePrince2: Boolean;
        seeCalculate: Boolean;
        enCalculate: Boolean;

    LOCAL procedure OnAfterValidaPieceworkCode();
    begin
        CurrPage.UPDATE(TRUE);
    end;

    procedure ShowCard();
    var
        LDataPieceworkForProduction: Record 7207386;
        PageJobPieceworkCard: Page 7207508;
    begin
        CLEAR(PageJobPieceworkCard);
        LDataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        LDataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        Rec.FILTERGROUP(4);
        Rec.COPYFILTER("Budget Filter", LDataPieceworkForProduction."Budget Filter");
        Rec.FILTERGROUP(0);
        if LDataPieceworkForProduction.FINDFIRST then;

        PageJobPieceworkCard.SETTABLEVIEW(LDataPieceworkForProduction);
        PageJobPieceworkCard.RUN;
    end;

    procedure ShowComments();
    var
        LCommentLine: Record 97;
        PageCommentSheet: Page 124;
    begin
        CLEAR(LCommentLine);
        LCommentLine.SETRANGE("Table Name", LCommentLine."Table Name"::"Job Cost Piecework");
        LCommentLine.SETRANGE("No.", rec."Unique Code");
        PageCommentSheet.SETTABLEVIEW(LCommentLine);
        PageCommentSheet.RUNMODAL;
    end;

    procedure ShowDimensionsIndi();
    var
        LDefaultDimension: Record 352;
        PageDefaultDimensions: Page 540;
    begin
        LDefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
        LDefaultDimension.SETRANGE("No.", rec."Unique Code");
        PageDefaultDimensions.SETTABLEVIEW(LDefaultDimension);
        PageDefaultDimensions.RUNMODAL;
    end;

    procedure ShowDimensionGlobal();
    var
        DataPieceworkForProductionJob: Record 7207386;
        DefaultDimensionsMultiple: Page 542;
    begin
        //JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionJob);
        DefaultDimensionsMultiple.ClearTempDefaultDim;
        if DataPieceworkForProductionJob.FINDSET then
            repeat
                DefaultDimensionsMultiple.CopyDefaultDimToDefaultDim(DATABASE::"Data Piecework For Production", DataPieceworkForProductionJob."Unique Code");
            until Rec.NEXT = 0;
        DefaultDimensionsMultiple.RUNMODAL;
    end;

    procedure CopyBudgetOtherJob(codBudget: Code[20]; Initial: Boolean);
    var
        // JobBudgetCopy: Report 7207305;
    begin
        //JAV 11/04/19: - Enviar el presupuesto actual y el tipo al proceso de copiar de otro proyecto
        // CLEAR(JobBudgetCopy);
        //JobBudgetCopy.ColletData("Job No.");
        // JobBudgetCopy.ColletData(rec."Job No.", codBudget, Initial);
        // JobBudgetCopy.RUNMODAL;
    end;

    procedure GetCostDatabase(codBudget: Code[20]);
    begin
        // CLEAR(BringCostDatabase);
        // BringCostDatabase.GatherDate(rec."Job No.", codBudget);
        // BringCostDatabase.RUNMODAL;
    end;

    procedure CopyPieceworkBillofItem();
    var
        LBringPieceworktoTheJob: Page 7207584;
    begin
        LBringPieceworktoTheJob.ReceivedJob(rec."Job No.", Rec);
        LBringPieceworktoTheJob.RUNMODAL;
        CLEAR(LBringPieceworktoTheJob);
    end;

    LOCAL procedure SetStyles();
    begin
        stLine := rec.GetStyle('');
        stLineVenta := rec.GetStyle('Ambiguous');
        stLineType := rec.GetStyle('StrongAccent');

        Rec.CALCFIELDS("No. Medition detail Cost");
        if (rec."No. Medition detail Cost" <> 0) then
            stMeasureBudgPieceworkSol := rec.GetStyle('Subordinate')
        ELSE
            stMeasureBudgPieceworkSol := rec.GetStyle('StandardAccent');

        edMeasureBudgPieceworkSol := (rec."No. Medition detail Cost" = 0);

        Job.GET(rec."Job No.");
        seePrince1 := Job."Separation Job Unit/Cert. Unit";
        seePrince2 := not Job."Separation Job Unit/Cert. Unit";

        enCalculate := Rec."Account Type" = Rec."Account Type"::Unit;
    end;

    // begin
    /*{
      JAV 11/04/19: - Enviar el presupuesto actual al proceso de copiar de otro proyecto
      JAV 05/10/19: - Se promueven los botones de la linea para que se vena directamente y se a�ade el test en la lista de unidades de obra
      JAV 25/03/22: - QB 1.10.27 Nuevo bot�n para calcular una sola unidad de obra
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
    }*///end
}








page 7207104 "QPR Budget Data"
{
    CaptionML = ENU = 'Budget Units', ESP = 'Unidades del Presupuesto';
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
                field("QB_PieceWork Blocked"; rec."QB_PieceWork Blocked")
                {

                }
                field("Blocked"; rec."Blocked")
                {

                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    CaptionML = ENU = 'Piecework Code', ESP = 'C¢digo';
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
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("QPR Type"; rec."QPR Type")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                        SetEditable;
                    END;


                }
                field("QPR Company"; rec."QPR Company")
                {

                    Enabled = enCompany;
                    StyleExpr = stLine;
                }
                field("QPR No."; rec."QPR No.")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;

                    trigger OnAssistEdit()
                    VAR
                        Job: Record 167;
                        QPRBudgetJobsList: Page 7207106;
                        Company: Record 2000000006;
                    BEGIN
                        IF (rec."QPR Type" = rec."QPR Type"::BCompany) THEN BEGIN
                            Rec.VALIDATE(rec."QPR Company");
                            CLEAR(QPRBudgetJobsList);
                            QPRBudgetJobsList.LOOKUPMODE(TRUE);
                            QPRBudgetJobsList.SetCompany(rec."QPR Company");
                            IF (QPRBudgetJobsList.RUNMODAL = ACTION::LookupOK) THEN
                                Rec.VALIDATE("QPR No.", QPRBudgetJobsList.GetJob);
                        END;
                    END;


                }
                field("QPR Name"; rec."QPR Name")
                {

                    Editable = false;
                    StyleExpr = stLine;
                }
                field("QPR Use"; rec."QPR Use")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;
                }
                field("QPR Activable"; rec."QPR Activable")
                {

                    ToolTipML = ESP = 'Si se marca indica que se pueden generar gastos activables de esta partida presupuestaria (se generan siempre que el proyecto y el estado del mismo lo permitan)';
                    Enabled = edActivable;
                }
                field("QPR Financial Unit"; rec."QPR Financial Unit")
                {

                    ToolTipML = ESP = 'Este campo indica que la partida presupuestaria es actibable por la parte financiera �nicamente';
                    Enabled = edActivableFin;
                }
                field("QPR AC"; rec."QPR AC")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;
                }
                field("QPR Gen Posting Group"; rec."QPR Gen Posting Group")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;
                }
                field("QPR Gen Prod. Posting Group"; rec."QPR Gen Prod. Posting Group")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;
                }
                field("QPR VAT Prod. Posting Group"; rec."QPR VAT Prod. Posting Group")
                {

                    Editable = edPosting;
                    StyleExpr = stLine;
                }
                field("QPR Account No"; rec."QPR Account No")
                {

                    StyleExpr = stLine;
                }
                field("QPR Cost Amount"; rec."QPR Cost Amount")
                {

                    BlankZero = true;
                    Editable = edAmounts;
                    StyleExpr = stLineAmounts;

                    ; trigger OnValidate()
                    VAR
                        QBJobBudget: Record 7207407;
                        QPRAmounts: Record 7207383;
                    BEGIN

                        //QRE15469-LCG-021221-INI
                        IF Rec."QPR Cost Amount" = xRec."QPR Cost Amount" THEN
                            EXIT;
                        QREFunctions.ValidateCostAmountFromDataPiece(Rec, BudgetCode);

                        CurrPage.UPDATE();
                        //QRE15469-LCG-071221-FIN
                    END;


                }
                field("QPR Sale Amount"; rec."QPR Sale Amount")
                {

                    BlankZero = true;
                    Editable = edAmounts;
                    StyleExpr = stLineAmounts;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("QPR Sale Amount -rec. QPR Cost Amount"; rec."QPR Sale Amount" - rec."QPR Cost Amount")
                {

                    CaptionML = ESP = 'Total Presup.';
                    BlankZero = true;
                    StyleExpr = stLineTotals;
                }
                field("QPR Last Date Updated"; rec."QPR Last Date Updated")
                {

                }
                field("QPR Cost Comprometido"; rec."QPR Cost Comprometido")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("QPR Cost Performed"; rec."QPR Cost Performed")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("QPR Cost Invoiced"; rec."QPR Cost Invoiced")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("QPR Sale Comprometido"; rec."QPR Sale Comprometido")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("QPR Sale Performed"; rec."QPR Sale Performed")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("QPR Sale Invoiced"; rec."QPR Sale Invoiced")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Budget Filter"; rec."Budget Filter")
                {

                    Visible = FALSE

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
                CaptionML = ENU = '&Line', ESP = '&L¡nea';

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
                    //JAV 05/10/19: - Se a¤ade el test en la lista de unidades de obra
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
                    CaptionML = ENU = 'Dimensions Multiples', ESP = 'Dimensiones m£ltiples';
                    Image = DimensionSets;

                    trigger OnAction()
                    BEGIN
                        ShowDimensionGlobal;
                    END;


                }

            }
            action("OpenResponsible")
            {

                CaptionML = ESP = 'Abrir Responsable';
                Image = UserCertificate;


                trigger OnAction()
                VAR
                    Responsible: Record 7206992;
                    ResponsibleList: Page 7207291;
                    Job: Record 167;
                BEGIN
                    IF Rec."Account Type" = Rec."Account Type"::Heading THEN
                        ERROR('No puede asignar responsables a partidas de mayor')
                    ELSE BEGIN
                        Responsible.RESET;
                        Responsible.FILTERGROUP(2);
                        Responsible.SETRANGE(Type, Responsible.Type::Piecework);
                        Responsible.SETRANGE("Table Code", Rec."Job No.");
                        Responsible.SETRANGE("Piecework No.", Rec."Piecework Code");
                        Responsible.FILTERGROUP(0);

                        CLEAR(ResponsibleList);
                        ResponsibleList.SETTABLEVIEW(Responsible);
                        ResponsibleList.RUNMODAL();
                    END;
                END;


            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        OnAfterGet;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        OnAfterGet;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        Job1: Record 167;
        DataPieceworkForProduction: Record 7207386;
        // BringCostDatabase: Report 7207277;
        AmCost: Decimal;
        AmSales: Decimal;
        stLine: Text;
        stLineType: Text;
        stLineAmounts: Text;
        stLineTotals: Text;
        stMeasureBudgPieceworkSol: Text;
        edMeasureBudgPieceworkSol: Boolean;
        edPosting: Boolean;
        edAmounts: Boolean;
        enCompany: Boolean;
        QREFunctions: Codeunit 7238197;
        BudgetCode: Code[20];
        FilterTxt: Text;
        edActivable: Boolean;
        edActivableFin: Boolean;

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
        Job: Record 167;
    begin
        //JAV 11/04/19: - Enviar el presupuesto actual y el tipo al proceso de copiar de otro proyecto
        // CLEAR(JobBudgetCopy);
        //JobBudgetCopy.ColletData("Job No.");
        //RE16067-LCG-24122021-INI
        Job.GET(rec."Job No.");
        // JobBudgetCopy.SetCartdType(Job."Card Type");
        //RE16067-LCG-24122021-FIN
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

    LOCAL procedure OnAfterGet();
    begin
        stLine := rec.GetStyle('');
        stLineType := rec.GetStyle('StrongAccent');

        if (rec."Account Type" = rec."Account Type"::Heading) then
            stLineAmounts := stLineType
        ELSE if (rec."QPR Type" <> rec."QPR Type"::Budget) and (rec."QPR Type" <> rec."QPR Type"::BCompany) then
            stLineAmounts := 'Standar'
        ELSE
            stLineAmounts := 'Ambiguous';

        CASE TRUE OF
            rec."QPR Sale Amount" > rec."QPR Cost Amount":
                stLineTotals := 'Favorable';
            rec."QPR Sale Amount" = rec."QPR Cost Amount":
                stLineTotals := 'Subordinate';
            rec."QPR Sale Amount" < rec."QPR Cost Amount":
                stLineTotals := 'UnFavorable';
        end;

        //Importes
        Rec.CALCFIELDS("QPR Cost Amount", "QPR Sale Amount", "QPR Cost Amount Tot", "QPR Sale Amount Tot");
        AmCost := rec."QPR Cost Amount" + rec."QPR Cost Amount Tot";
        AmSales := rec."QPR Sale Amount" + rec."QPR Sale Amount Tot";

        SetEditable;
    end;

    LOCAL procedure SetEditable();
    begin
        edPosting := (rec."Account Type" = rec."Account Type"::Unit);
        edMeasureBudgPieceworkSol := (rec."No. Medition detail Cost" = 0);
        edAmounts := (rec."Account Type" = rec."Account Type"::Unit) and (rec."QPR Type" <> rec."QPR Type"::Budget) and (rec."QPR Type" <> rec."QPR Type"::BCompany);
        enCompany := (rec."QPR Type" = rec."QPR Type"::BCompany);

        //JAV 04/10/22: - QB 1.12.00 Gastos activables
        edActivable := FALSE;
        if Job1.GET(rec."Job No.") then
            edActivable := (Job1."QB Activable" = Job1."QB Activable"::activatable);  //JAV 04/10/22: - QB 1.12.00 CAmbio de boolean a option
        edActivableFin := Rec."QPR Activable";
    end;

    LOCAL procedure CalcultedCosts(var DataPieceWFP: Record 7207386);
    begin
        //QRE15469-LCG-021221-INI
        // DataPieceWFP."QPR Cost Comprometido" := QREFunctions.GetCommittedCost(DataPieceWFP."Job No.", DataPieceWFP."Piecework Code");
        // DataPieceWFP."QPR Cost Performed" := GetActualCost(DataPieceWFP."Job No.", DataPieceWFP."Piecework Code");
        // DataPieceWFP."QPR Cost Invoiced" := GetInvoicedCosts(DataPieceWFP."Job No.", DataPieceWFP."Piecework Code");
        //QRE15469-LCG-021221-FIN
    end;

    LOCAL procedure GetActualCost(JobNo: Code[20]; PieceWorkNo: Text[20]): Decimal;
    var
        PurchRcptLine: Record 121;
        ReturnShpLine: Record 6651;
        SumRcpt: Decimal;
        SumShpt: Decimal;
    begin
        //QRE15469-LCG-021221-INI
        PurchRcptLine.RESET();
        PurchRcptLine.SETRANGE("Job No.", JobNo);
        PurchRcptLine.SETRANGE("Piecework NÂº", PieceWorkNo);
        if PurchRcptLine.FINDSET() then
            repeat
                SumRcpt += PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost";
            until PurchRcptLine.NEXT() = 0;

        ReturnShpLine.RESET();
        ReturnShpLine.SETRANGE("Job No.", JobNo);
        ReturnShpLine.SETRANGE("Piecework NÂº", PieceWorkNo);
        if ReturnShpLine.FINDSET() then
            repeat
                SumShpt := ReturnShpLine.Quantity * ReturnShpLine."Direct Unit Cost";
            until ReturnShpLine.NEXT() = 0;

        exit(SumRcpt - SumShpt);
        //QRE15469-LCG-021221-FIN
    end;

    LOCAL procedure GetInvoicedCosts(JobNo: Code[20]; PieceWorkNo: Text[20]): Decimal;
    var
        PurchInvLine: Record 123;
        PurchCrMemoLine: Record 125;
        SumInv: Decimal;
        SumCrM: Decimal;
    begin
        //QRE15469-LCG-021221-INI
        PurchInvLine.RESET();
        PurchInvLine.SETCURRENTKEY("Job No.", "Piecework No.");
        PurchInvLine.SETRANGE("Job No.", JobNo);
        PurchInvLine.SETRANGE("Piecework No.", PieceWorkNo);
        if PurchInvLine.CALCSUMS(Amount) then
            SumInv := PurchInvLine.Amount;

        PurchCrMemoLine.RESET();
        PurchCrMemoLine.SETCURRENTKEY("Job No.", "Piecework No.");
        PurchCrMemoLine.SETRANGE("Job No.", JobNo);
        PurchCrMemoLine.SETRANGE("Piecework No.", PieceWorkNo);
        if PurchCrMemoLine.CALCSUMS(Amount) then
            SumCrM := PurchCrMemoLine.Amount;

        exit(SumInv - SumCrM);

        //QRE15469-LCG-021221-FIN
    end;

    procedure SetParameter(BudgetC: Code[20]);
    begin
        BudgetCode := BudgetC;
        CurrPage.UPDATE();
    end;

    // begin
    /*{
      JAV 11/04/19: - Enviar el presupuesto actual al proceso de copiar de otro proyecto
      JAV 05/10/19: - Se promueven los botones de la linea para que se vena directamente y se a¤ade el test en la lista de unidades de obra
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
      JAV 04/10/22: - QB 1.12.00 Se a�ade para la activaci�n de gastos los campos 611 QPR Activable y 612 QPR Financial Unit y su condici�n de visible
    }*///end
}








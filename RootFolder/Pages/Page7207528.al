page 7207528 "Data Piecework List"
{
    Editable = false;
    CaptionML = ENU = 'Piecework List', ESP = 'Listado de unidades de obra';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207386;
    PageType = List;
    CardPageID = "Job Piecework Card";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Blocked"; rec."Blocked")
                {

                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stline;
                }
                field("JOB_CodePieceworkPRESTO"; rec."Code Piecework PRESTO")
                {

                    Visible = seeJob;
                    StyleExpr = stline;
                }
                field("JOB_AdditionalTextCode"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                    StyleExpr = stline;
                }
                field("JOB_UnitOfMeasure"; rec."Unit Of Measure")
                {

                    Visible = seeJob;
                    StyleExpr = stline;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stline;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = false;
                    StyleExpr = stline;
                }
                field("JOB_SalesAmountBase"; rec."Sales Amount (Base)")
                {

                    Visible = seeJob;
                    StyleExpr = stline;
                }
                field("JOB_ContractPrice"; rec."Contract Price")
                {

                    Visible = seeJob;
                    StyleExpr = stline;
                }
                field("JOB_UnitPriceSalebase"; rec."Unit Price Sale (base)")
                {

                    Visible = seeJob;
                    StyleExpr = stline;
                }
                field("QPR_AccountType"; rec."Account Type")
                {

                    Visible = seeBudget;
                    StyleExpr = stLineType;
                }
                field("QPR_Type"; rec."QPR Type")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_Company"; rec."QPR Company")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_No"; rec."QPR No.")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_Name"; rec."QPR Name")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_Use"; rec."QPR Use")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_Activable"; rec."QPR Activable")
                {

                    ToolTipML = ESP = 'Si se marca indica que se pueden generar gastos activables de esta partida presupuestaria (se generan siempre que el proyecto y el estado del mismo lo permitan)';
                    Visible = seeBudget;
                }
                field("QPR_AC"; rec."QPR AC")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_GenPostingGroup"; rec."QPR Gen Posting Group")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_GenProdPostingGroup"; rec."QPR Gen Prod. Posting Group")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_VATProdPostingGroup"; rec."QPR VAT Prod. Posting Group")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_AccountNo"; rec."QPR Account No")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_CostAmount"; rec."QPR Cost Amount")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLineAmounts;
                }
                field("QPR_SaleAmount"; rec."QPR Sale Amount")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLineAmounts;
                }
                field("QPR_Total"; rec."QPR Sale Amount" - rec."QPR Cost Amount")
                {

                    CaptionML = ESP = 'Total Presup.';
                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLineTotals;
                }
                field("QPR_LastDateUpdated"; rec."QPR Last Date Updated")
                {

                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_CostComprometido"; rec."QPR Cost Comprometido")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_CostPerformed"; rec."QPR Cost Performed")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_CostInvoiced"; rec."QPR Cost Invoiced")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_SaleComprometido"; rec."QPR Sale Comprometido")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_SalePerformed"; rec."QPR Sale Performed")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLine;
                }
                field("QPR_SaleInvoiced"; rec."QPR Sale Invoiced")
                {

                    BlankZero = true;
                    Visible = seeBudget;
                    StyleExpr = stLine

  ;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Unidades de obra', ESP = '&Unidades de obra';
                action("Ficha")
                {

                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Visible = seejob;
                    Image = Card;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Job Piecework Card", Rec);
                    END;


                }
                action("Comentarios")
                {

                    CaptionML = ENU = '&Comments', ESP = '&Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job Cost Piecework"), "No." = FIELD("Unique Code");
                    Image = Comment;
                }
                action("Descompuestos")
                {

                    CaptionML = ENU = 'Bill of Item D&ata', ESP = 'D&atos de descompuesto';
                    Visible = seeJob;
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        ShowPiecework;
                    END;


                }
                action("Mediciones")
                {

                    CaptionML = ENU = '&L�neas de medici�n', ESP = '&L�neas de medici�n';
                    Visible = seeJob;
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        ShowMeasureLinePiecework;
                    END;


                }
                action("Textos")
                {

                    CaptionML = ENU = 'Extended Text', ESP = 'Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Visible = seeJob;
                    Image = Text;
                }
                action("Dimensiones")
                {

                    CaptionML = ENU = '&Dimensions', ESP = '&Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(7207386), "No." = FIELD("Unique Code");
                    Image = Dimensions
    ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET();
        seeAditionalCode := (seeJob) AND (QuoBuildingSetup."Use Aditional Code");

        //JAV 08/06/22: - QB 1.10.49 Si el proyecto es de RE o de Presupuestos se ven otras columnas
        seeJob := TRUE;
        seeBudget := FALSE;
        IF (Job.GET(Rec.GETFILTER("Job No."))) THEN BEGIN
            IF (Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion]) THEN BEGIN
                seeJob := FALSE;
                seeBudget := TRUE;
            END;
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetStyle;
    END;



    var
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        seeAditionalCode: Boolean;
        seeBudget: Boolean;
        seeJob: Boolean;
        stLine: Text;
        stLineType: Text;
        stLineTotals: Text;
        stLineAmounts: Text;
        Text002: TextConst ESP = 'No pude descomponer unidades de mayor';

    LOCAL procedure SetStyle();
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
        //Rec.CALCFIELDS("QPR Cost Amount","QPR Sale Amount","QPR Cost Amount Tot","QPR Sale Amount Tot");
        //AmCost := rec."QPR Cost Amount" + "QPR Cost Amount Tot";
        //AmSales := rec."QPR Sale Amount" + "QPR Sale Amount Tot";
    end;

    procedure ShowPiecework();
    var
        Job: Record 167;
        DataCostByPiecework: Record 7207387;
        BillofItemsPiecbyJobCard: Page 7207513;
        DataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);

        // DataCostByPiecework.FILTERGROUP(2);
        // DataCostByPiecework.RESET;
        // DataCostByPiecework.SETRANGE( "Job No.", rec. "Job No.");
        // DataCostByPiecework.SETRANGE( "Piecework Code", rec. "Piecework Code");
        // if Rec.GETFILTER("Budget Filter") <> '' then
        //  DataCostByPiecework.SETFILTER("Cod. Budget",GETFILTER("Budget Filter"))
        // ELSE begin
        //  Job.GET(rec."Job No.");
        //  DataCostByPiecework.SETFILTER("Cod. Budget", Job."Current Piecework Budget");
        // end;
        // DataCostByPiecework.FILTERGROUP(0);

        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        if Rec.GETFILTER("Budget Filter") <> '' then
            DataPieceworkForProduction.SETFILTER("Budget Filter", rec.GETFILTER("Budget Filter"))
        ELSE begin
            Job.GET(rec."Job No.");
            DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
        end;
        //MESSAGE(FORMAT(DataPieceworkForProduction.COUNT));
        DataPieceworkForProduction.FILTERGROUP(0);

        CLEAR(BillofItemsPiecbyJobCard);
        BillofItemsPiecbyJobCard.SETTABLEVIEW(DataPieceworkForProduction);
        BillofItemsPiecbyJobCard.SETRECORD(Rec);
        BillofItemsPiecbyJobCard.RUNMODAL;
    end;

    procedure ShowMeasureLinePiecework();
    var
        Job: Record 167;
        ManagementLineofMeasure: Codeunit 7207292;
        JobPieceworkCardforSales: Page 7207652;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text002);

        if Rec.GETFILTER("Budget Filter") <> '' then
            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Rec.GETFILTER("Budget Filter"), rec."Piecework Code")
        ELSE begin
            Job.GET(rec."Job No.");
            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Job."Current Piecework Budget", rec."Piecework Code");
        end;
    end;

    // begin
    /*{
      JAV 05/04/19: - Se a�aden los campos rec."Contract Price"y rec."Unit Price Sale (base)"
      JAV 08/06/22: - QB 1.10.49 Si el proyecto es de RE o de Presupuestos se ven otras columnas
      JAV 26/10/22: - QB 1.12.06 Eliminar condiciones de visible del campo Description y cambiar la de Description 2
    }*///end
}








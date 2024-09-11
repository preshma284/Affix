page 7207601 "Piecework Job Offer"
{
    CaptionML = ENU = 'Piecework Job Offer', ESP = 'Proyecto-UO Ofertas';
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Customer Certification Unit", "Piecework Code")
                    ORDER(Ascending)
                    WHERE("Type" = CONST("Piecework"), "Customer Certification Unit" = CONST(true));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowAsTree = true;
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;
                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    StyleExpr = stLine;
                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
                {

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
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                    Editable = edSaleQuantityBase;
                    StyleExpr = stSaleQuantityBase;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Contract Price"; rec."Contract Price")
                {

                    Editable = edContractPrice;
                    StyleExpr = stContractPrice;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    StyleExpr = stLine;
                }
                field("Sale Amount"; rec."Sale Amount")
                {

                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    StyleExpr = stLine;
                }
                field("Description 2"; rec."Description 2")
                {

                    StyleExpr = stLine;
                }
                field("% Assigned To Production"; rec."% Assigned To Production")
                {

                    StyleExpr = stLine;
                }
                field("Cumulative Amount"; rec."Cumulative Amount")
                {

                    StyleExpr = stLine;
                }
                field("Quantity in Measurements"; rec."Quantity in Measurements")
                {

                    StyleExpr = stLine;
                }
                field("Certified Quantity"; rec."Certified Quantity")
                {

                    StyleExpr = stLine;
                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                    StyleExpr = stLine;
                }
                field("Additional Auto Text"; rec."Additional Auto Text")
                {

                    StyleExpr = stLine;
                }

            }
            group("group39")
            {

                CaptionML = ESP = 'Totales';
                field("Amounts[1]_"; Amounts[1])
                {

                    CaptionML = ESP = 'Importe Contrato';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[2]_"; Amounts[2])
                {

                    CaptionML = ESP = 'Gastos Generales';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[3]_"; Amounts[3])
                {

                    CaptionML = ESP = 'Beneficio Industrial';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[4]_"; Amounts[4])
                {

                    CaptionML = ESP = 'Importe Baja';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[5]_"; Amounts[5])
                {

                    CaptionML = ESP = 'Total Importe Venta';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            part("part1"; 7207490)
            {
                SubPageLink = "No." = FIELD("Job No.");
            }
        }
        area(FactBoxes)
        {
            part("part2"; 7207490)
            {
                SubPageLink = "No." = FIELD("Job No.");
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Units', ESP = 'Datos de la U.O.';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = '&Ficha';
                    Image = Card;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                        JobPieceworkCard: Page 7207508;
                    BEGIN
                        //Q9291 >>
                        //PAGE.RUNMODAL(PAGE::"Job Piecework Card",Rec);
                        JobPieceworkCard.SetSale(TRUE);
                        DataPieceworkForProduction := Rec;
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                        JobPieceworkCard.SETTABLEVIEW(DataPieceworkForProduction);
                        JobPieceworkCard.RUNMODAL;
                        //Q9291 <<
                    END;


                }
                action("action2")
                {
                    CaptionML = ESP = 'Descompuestos';
                    RunObject = Page 7207480;
                    RunPageView = SORTING("Job No.", "Piecework Code", "No. Record", "Line Type", "No.");
                    RunPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code");
                    Image = BinContent;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Measurement', ESP = '&Medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        IF rec."Account Type" = rec."Account Type"::Heading THEN
                            ERROR(Text001)
                        ELSE BEGIN
                            Job.GET(rec."Job No.");
                            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Job."Current Piecework Budget", rec."Piecework Code");
                        END;
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Extended Text', ESP = '&Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2", "Key3");
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Image = AdjustItemCost;
                }
                action("action5")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job Cost Piecework"), "No." = FIELD("Unique Code");
                    Image = Comment;
                }
                action("action6")
                {
                    CaptionML = ENU = 'Individual Dimensions', ESP = 'Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(7207386), "No." = FIELD("Unique Code");
                    Image = Dimensions;
                }

            }
            group("group9")
            {
                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("action7")
                {
                    CaptionML = ENU = 'Get Cost Database', ESP = 'Traer preciario';
                    Image = JobPrice;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                        // BringCostDatabase: Report 7207277;
                    BEGIN
                        // CLEAR(BringCostDatabase);
                        // BringCostDatabase.GatherDate(rec."Job No.", rec."Budget Filter");
                        // BringCostDatabase.GatherRecord(rec."No. Record");
                        // BringCostDatabase.SetBudgetType(TRUE); //Q9291
                        // BringCostDatabase.RUNMODAL;
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = '&Rec.MODIFY Sale Amounts', ESP = '&Modificar importes de venta';
                    Image = InsertStartingFee;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                        // REPORT.RUNMODAL(REPORT::"Sales Amount Increase", TRUE, FALSE, DataPieceworkForProduction);
                        CLEAR(DataPieceworkForProduction);
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = 'Take to production cost database', ESP = 'Llevar a preciario de producci�n';
                    Image = CalculateDepreciation;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                        // CreatePieceworkProdBudget: Report 7207322;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                        // CLEAR(CreatePieceworkProdBudget);
                        // CreatePieceworkProdBudget.SETTABLEVIEW(DataPieceworkForProduction);
                        // CreatePieceworkProdBudget.RUNMODAL;
                    END;


                }
                action("<Action1100251035>")
                {

                    CaptionML = ENU = 'Inicialize production (distance)', ESP = 'Inicializar Producci�n (separaci�n)';
                    Image = JobPrice;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                        // CLEAR(ProductionDataInitialize);
                        // ProductionDataInitialize.SETTABLEVIEW(DataPieceworkForProduction);
                        // ProductionDataInitialize.RUNMODAL;
                    END;


                }
                action("action11")
                {
                    CaptionML = ENU = '&Test', ESP = '&Test';
                    Image = TestReport;

                    trigger OnAction()
                    VAR
                        CostPieceworkJobIdent: Codeunit 7207296;
                    BEGIN
                        //JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
                        CLEAR(CostPieceworkJobIdent);
                        CostPieceworkJobIdent.Process(rec."Job No.", rec."Budget Filter", 1);
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = '&Distribution sale budget to production cost', ESP = '&Repartir ppto venta a coste producci�n';
                    Visible = false;

                    trigger OnAction()
                    VAR
                        // DistributeSaleBudget: Report 7207304;
                    BEGIN
                        Job.SETRANGE("No.", rec."Job No.");
                        // DistributeSaleBudget.SETTABLEVIEW(Job);
                        // DistributeSaleBudget.RUNMODAL;
                    END;


                }

            }
            group("group16")
            {
                CaptionML = ENU = 'Delete', ESP = 'Borrar';
                action("action13")
                {
                    CaptionML = ENU = 'Delete', ESP = 'Borrar';
                    Image = Delete;


                    trigger OnAction()
                    BEGIN
                        IF CONFIRM(Text002, TRUE) THEN BEGIN
                            Rec.VALIDATE("Customer Certification Unit", FALSE);
                            Rec.MODIFY;
                        END;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                CaptionML = ESP = 'Datos U.O.';

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
                actionref(action6_Promoted; action6)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Procesos';

                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref("<Action1100251035>_Promoted"; "<Action1100251035>")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
        Job.GET(rec."Job No.");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        DescriptionIndent := 0;
        funOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        // ProductionDataInitialize: Report 7207385;
        Job: Record 167;
        Text001: TextConst ENU = 'You can not define bill of items or detail of measurement lines in major pieceworks.', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        Text002: TextConst ENU = 'Do you want to remove Data Piecework for certification?', ESP = '�Eliminiar datos unidad de obra para certificaci�n?';
        ManagementLineofMeasure: Codeunit 7207292;
        DescriptionIndent: Integer;
        stLine: Text;
        stLineType: Text;
        stSaleQuantityBase: Text;
        stContractPrice: Text;
        edContractPrice: Boolean;
        edSaleQuantityBase: Boolean;
        seeAditionalCode: Boolean;
        Amounts: ARRAY[10] OF Decimal;

    LOCAL procedure funOnAfterGetRecord();
    var
        QBTableSubscriber: Codeunit 7207347;
        void: Decimal;
    begin
        //Estilos de campos
        DescriptionIndent := rec.Indentation;

        stLine := rec.GetStyle('');
        stLineType := rec.GetStyle('StrongAccent');

        if rec."Account Type" = rec."Account Type"::Heading then begin
            edSaleQuantityBase := FALSE;
            edContractPrice := FALSE;
            stSaleQuantityBase := rec.GetStyle('');
            stContractPrice := rec.GetStyle('');
        end ELSE begin
            Rec.CALCFIELDS("No. DP Sale", "No. Medition detail Sales");
            edSaleQuantityBase := (rec."No. Medition detail Sales" = 0);
            edContractPrice := (rec."No. DP Sale" = 0);

            if (edSaleQuantityBase) then
                stSaleQuantityBase := rec.GetStyle('')
            ELSE
                stSaleQuantityBase := rec.GetStyle('Subordinate');

            if (edContractPrice) then
                stContractPrice := rec.GetStyle('')
            ELSE
                stContractPrice := rec.GetStyle('Subordinate');
        end;

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.CALCSUMS("Amount Sale Contract", "Sale Amount");

        QBTableSubscriber.TJob_CalcPorcAmounts(Job, rec."Amount Sale Contract", Amounts[2], Amounts[3], Amounts[4]);

        Amounts[1] := DataPieceworkForProduction."Amount Sale Contract";
        Amounts[5] := DataPieceworkForProduction."Sale Amount";
    end;

    // begin
    /*{
      PGM 04/10/18: - QVE2847 A�adida la acci�n de Traer preciario.
      JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
      PGM 14/05/20: - Q9291 Modificada las acciones de Medici�n, Ficha y Traer Preciario
    }*///end
}








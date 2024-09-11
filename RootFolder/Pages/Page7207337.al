page 7207337 "Job - Piecework Certification"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    DelayedInsert = true;
    SourceTableView = SORTING("Job No.", "Customer Certification Unit", "Piecework Code")
                    ORDER(Ascending)
                    WHERE("Type" = CONST("Piecework"), "Customer Certification Unit" = FILTER(true));
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code";
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        rec."Piecework Code" := UPPERCASE(rec."Piecework Code");
                        Rec.FILTERGROUP(4);
                        IF Job.GET(Rec.GETFILTER("Job No.")) THEN BEGIN
                            rec."Job No." := Job."No.";
                            rec."No. Record" := Rec.GETFILTER("No. Record");
                            Rec.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                            Rec.VALIDATE("Customer Certification Unit", TRUE);
                        END;
                        Rec.FILTERGROUP(0);
                    END;


                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    StyleExpr = stLine;
                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
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
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {

                    StyleExpr = stLine;
                }
                field("Grouping Code"; rec."Grouping Code")
                {

                    Visible = SeeGroupingCode;
                }
                field("Not Recalculate Sale"; rec."Not Recalculate Sale")
                {

                    StyleExpr = stLine;
                }
                field("Initial Sale Measurement"; rec."Initial Sale Measurement")
                {

                    StyleExpr = stLine;
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
                field("Currency Code"; rec."Currency Code")
                {

                    Visible = useCurrencies;
                    StyleExpr = stLine;
                }
                field("Contract Price (JC)"; rec."Contract Price (JC)")
                {

                    Visible = useCurrencies;
                    StyleExpr = stLine;
                }
                field("Contract Price"; rec."Contract Price")
                {

                    Editable = edContractPrice;
                    StyleExpr = stContractPrice;

                    ; trigger OnValidate()
                    BEGIN
                        IF rec."Account Type" = rec."Account Type"::Heading THEN
                            rec."Contract Price" := 0;
                        OnAfterValidatePriceContract;
                    END;


                }
                field("Amount Sale Contract"; rec."Amount Sale Contract")
                {

                    StyleExpr = stLine;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    StyleExpr = stLine;
                }
                field("Sales Amount (Base)"; rec."Sales Amount (Base)")
                {

                    StyleExpr = stLine;
                }
                field("Last Unit Price Redetermined"; rec."Last Unit Price Redetermined")
                {

                    Visible = seeRED;
                    StyleExpr = stLine;
                }
                field("Increased Amount Of Redeterm."; rec."Increased Amount Of Redeterm.")
                {

                    Visible = seeRED;
                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("CalculateMarginBudget"; CalculateMarginBudget)
                {

                    CaptionML = ENU = 'Margin Provided Amount', ESP = 'Importe margen previsto';
                    StyleExpr = stLine;
                }
                field("CalculateMarginBudgetPerc"; rec."CalculateMarginBudgetPerc")
                {

                    CaptionML = ENU = '% Margin Provided', ESP = '% Margen previsto';
                    StyleExpr = stLine;
                }
                field("% Assigned To Production"; rec."% Assigned To Production")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Cumulative Amount"; rec."Cumulative Amount")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Quantity in Measurements"; rec."Quantity in Measurements")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Certified Quantity"; rec."Certified Quantity")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Additional Auto Text"; rec."Additional Auto Text")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("<Initial Produc. Price>"; xRec."Initial Produc. Price")
                {

                    CaptionML = ENU = 'Initial Produc. Price', ESP = 'Precio producci�n inicial';
                    // OptionCaptionML = ENU = 'Initial Produc. Price', ESP = 'Precio producci�n inicial';
                    StyleExpr = stLine;
                }
                field("Importe venta"; rec."Sale Amount")
                {

                    CaptionML = ENU = 'Sale amount', ESP = 'Importe venta';
                    StyleExpr = stLine;
                }
                field("Amount Cost Budget"; rec."Amount Cost Budget")
                {

                    StyleExpr = stAmountCostBudget;
                }
                field("Amount Cost Budget (LCY)"; rec."Amount Cost Budget (LCY)")
                {

                    Visible = useCurrencies;
                    StyleExpr = stAmountCostBudget;
                }
                field("Amount Cost Budget (ACY)"; rec."Amount Cost Budget (ACY)")
                {

                    Visible = useCurrencies;
                    StyleExpr = stAmountCostBudget;
                }
                field("Contract Price (LCY)"; rec."Contract Price (LCY)")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Unit Price Sale (base) (LCY)"; rec."Unit Price Sale (base) (LCY)")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Sale Amount (LCY)"; rec."Sale Amount (LCY)")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Contract Price (ACY)"; rec."Contract Price (ACY)")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Unit Price Sale (base) (ACY)"; rec."Unit Price Sale (base) (ACY)")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Sale Amount (ACY)"; rec."Sale Amount (ACY)")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Calculated K"; rec."Calculated K")
                {

                    StyleExpr = stLine;
                }
                field("Planned K"; rec."Planned K")
                {

                    StyleExpr = stLine;
                }
                field("Registered Hours"; rec."Registered Hours")
                {

                    Visible = seeHours;
                    StyleExpr = stLine;
                }
                field("Registered Work Part"; rec."Registered Work Part")
                {

                    Visible = seeHours;
                    StyleExpr = stLine;
                }
                field("Manual Hours"; rec."Manual Hours")
                {

                    Visible = seeHours;
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
                CaptionML = ENU = '&Units', ESP = 'Datos';
                action("action1")
                {
                    CaptionML = ENU = 'Unit &Card', ESP = 'Ficha';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        ViewUnitCard;
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
                    CaptionML = ENU = '&Measure', ESP = 'Medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        ViewLinesMeasure;
                    END;


                }
                action("TextosAdicionales")
                {

                    CaptionML = ENU = 'Additional &Text', ESP = 'Textos adicionales';
                    Image = Text;

                    trigger OnAction()
                    BEGIN
                        ViewExtendedText;
                    END;


                }
                action("EliminarUnidades")
                {

                    CaptionML = ENU = 'Unit &Card', ESP = 'Eliminar';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        funDeleteUnits;
                    END;


                }

            }
            group("group8")
            {
                CaptionML = ENU = 'ACC. &Units', ESP = 'Utilidades';
                action("action6")
                {
                    CaptionML = ENU = 'I&Ncrease Sales Price', ESP = '&Modificar importes de venta';
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    BEGIN
                        ModifySalesPrice;
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Carry Cost Database', ESP = 'Llevar a preciario';
                    Image = CopyCostBudgettoCOA;

                    trigger OnAction()
                    BEGIN
                        CarryCostDatabaseProduction;
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'Inicialize Production (Separation)', ESP = 'Inicializar producci�n(separaci�n)';
                    Image = InsertStartingFee;

                    trigger OnAction()
                    BEGIN
                        InicializeProductionSeparation(TRUE);
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = 'Extend Production (Separation)', ESP = 'Ampliar producci�n (separaci�n)';
                    Image = InsertTravelFee;

                    trigger OnAction()
                    BEGIN
                        InicializeProductionSeparation(FALSE);
                    END;


                }
                action("action10")
                {
                    CaptionML = ESP = 'Recalcular';


                    trigger OnAction()
                    VAR
                        Cambiado: Boolean;
                        Importe: Decimal;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                        Cambiado := FALSE;
                        IF (DataPieceworkForProduction.FINDSET(TRUE)) THEN
                            REPEAT
                                Importe := DataPieceworkForProduction."Amount Sale Contract" + DataPieceworkForProduction."Sales Amount (Base)";
                                DataPieceworkForProduction.VALIDATE("Contract Price");
                                DataPieceworkForProduction.MODIFY;
                                IF (Importe <> DataPieceworkForProduction."Amount Sale Contract" + DataPieceworkForProduction."Sales Amount (Base)") THEN
                                    Cambiado := TRUE;
                            UNTIL (DataPieceworkForProduction.NEXT = 0);

                        CurrPage.UPDATE(FALSE);
                        IF (Cambiado) THEN
                            MESSAGE(Text000);
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(4);
        IF Job.GET(Rec.GETFILTER("Job No.")) THEN BEGIN
            Rec.SETRANGE("Budget Filter", Job."Current Piecework Budget");
            Job.SETRANGE("Budget Filter", Job."Current Piecework Budget");
            Job.CALCFIELDS("Amou Piecework Meas./Certifi.", "Contract Amount", Job."Direct Cost Amount PieceWork", Job."Indirect Cost Amount Piecework");
        END;
        Rec.FILTERGROUP(0);

        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);

        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
        seeHours := (QuoBuildingSetup."Hours control" <> QuoBuildingSetup."Hours control"::No);

        //-Q13152
        seeGroupingCode := QuoBuildingSetup."Use Grouping";
        //+Q13152

        seeRED := FALSE;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Rec.FILTERGROUP(4);
        IF Job.GET(Rec.GETFILTER("Job No.")) THEN BEGIN
            Rec.SETRANGE("Budget Filter", Job."Current Piecework Budget");
            Job.SETRANGE("Budget Filter", Job."Current Piecework Budget");
            Job.CALCFIELDS("Amou Piecework Meas./Certifi.", "Contract Amount", "Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
        END;
        Rec.FILTERGROUP(0);

        funOnAfterGetRecord;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        Rec.FILTERGROUP(4);
        IF Job.GET(Rec.GETFILTER("Job No.")) THEN BEGIN
            rec."Job No." := Job."No.";
            rec."No. Record" := Rec.GETFILTER("No. Record");
            Rec.SETRANGE("Budget Filter", Job."Current Piecework Budget");
            Rec.VALIDATE("Customer Certification Unit", TRUE);
        END;
        Rec.FILTERGROUP(0);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        Job: Record 167;
        Text000: TextConst ESP = 'Debe recalcular el presupuesto';
        Text001: TextConst ENU = 'No bill of item or detail of measurement lines can be defined in major piecework.', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        ManagementLineofMeasure: Codeunit 7207292;
        FunctionQB: Codeunit 7207272;
        CalculateMarginBudget: Decimal;
        useCurrencies: Boolean;
        stLine: Text;
        stAmountCostBudget: Text;
        stlinetype: Text;
        stSaleQuantityBase: Text;
        stContractPrice: Text;
        edContractPrice: Boolean;
        edSaleQuantityBase: Boolean;
        seeHours: Boolean;
        seeAditionalCode: Boolean;
        Text002: TextConst ESP = '�Confirma que desea borrar permanentemente estas unidades de venta?';
        seeGroupingCode: Boolean;
        seeRED: Boolean;
        JobCurrencyExchangeFunction: Codeunit 7207332;

    LOCAL procedure OnAfterValidatePriceContract();
    begin
        CurrPage.UPDATE;
    end;

    LOCAL procedure ViewUnitCard();
    begin
        //QB4853 >>
        PAGE.RUNMODAL(PAGE::"Job Piecework Card for Sales", Rec);
        //QB4853 <<
    end;

    LOCAL procedure ViewLinesMeasure();
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text001);
        ManagementLineofMeasure.editMeasureLinePieceworkCertif(rec."Job No.", rec."Piecework Code");
    end;

    LOCAL procedure ViewExtendedText();
    var
        QBText: Record 7206918;
        pgQBText: Page 7206929;
    begin
        QBText.RESET;
        QBText.SETRANGE(Table, QBText.Table::Job);
        QBText.SETRANGE(Key1, rec."Job No.");
        QBText.SETRANGE(Key2, rec."Piecework Code");

        CLEAR(pgQBText);
        pgQBText.SETTABLEVIEW(QBText);
        pgQBText.RUNMODAL;
    end;

    procedure ModifySalesPrice();
    var
        DataPieceworkForProduction: Record 7207386;
        // SalesAmountIncrease: Report 7207282;
    begin
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);

        // CLEAR(SalesAmountIncrease);
        // SalesAmountIncrease.SETTABLEVIEW(DataPieceworkForProduction);
        // SalesAmountIncrease.SetJob(rec."Job No.");
        // SalesAmountIncrease.RUNMODAL;

        CLEAR(DataPieceworkForProduction);
        CurrPage.UPDATE(FALSE);
    end;

    procedure CarryCostDatabaseProduction();
    var
        DataPieceworkForProduction: Record 7207386;
        // PieceworkProdBudgetCreate: Report 7207322;
    begin
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        Job.GET(rec."Job No.");
        DataPieceworkForProduction.FILTERGROUP(4);
        DataPieceworkForProduction.SETRANGE("Budget Filter");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        // CLEAR(PieceworkProdBudgetCreate);
        // PieceworkProdBudgetCreate.SETTABLEVIEW(DataPieceworkForProduction);
        // PieceworkProdBudgetCreate.RUNMODAL;
    end;

    procedure InicializeProductionSeparation(Inicialize: Boolean);
    var
        DataPieceworkForProduction: Record 7207386;
        // ProductionDataInitialize: Report 7207385;
    begin
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        DataPieceworkForProduction.SETRANGE("Budget Filter");
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        // CLEAR(ProductionDataInitialize);
        // ProductionDataInitialize.SETTABLEVIEW(DataPieceworkForProduction);
        // ProductionDataInitialize.InicializeF(Inicialize);
        // ProductionDataInitialize.RUNMODAL;
    end;

    procedure Test();
    var
        CostPieceworkJobIdent: Codeunit 7207296;
    begin
        //JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
        CLEAR(CostPieceworkJobIdent);
        CostPieceworkJobIdent.Process(rec."Job No.", rec."Budget Filter", 1);
    end;

    procedure IncorporateCostDatabase();
    var
        // BringCostDatabase: Report 7207277;
        JobBudget: Record 7207407;
        Text001: TextConst ESP = 'No hay un presupuesto de coste marcado como actual en el proyecto %1';
    begin
        // CLEAR(BringCostDatabase);
        //Q8116 >>
        //BringCostDatabase.GatherDate("Job No.","Budget Filter");
        JobBudget.RESET;
        JobBudget.SETRANGE("Job No.", rec."Job No.");
        JobBudget.SETRANGE("Actual Budget", TRUE);
        // if JobBudget.FINDFIRST then
            // BringCostDatabase.GatherDate(rec."Job No.", JobBudget."Cod. Budget")
        // ELSE
            // ERROR(Text001, rec."Job No.");
        //Q8116 <<
        // BringCostDatabase.GatherRecord(rec."No. Record");
        // BringCostDatabase.RUNMODAL;
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        stLine := rec.GetStyle('');
        stAmountCostBudget := rec.GetStyle('Favorable');
        stlinetype := rec.GetStyle('StrongAccent');

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
    end;

    LOCAL procedure funDeleteUnits();
    begin
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        if (CONFIRM(Text002, FALSE)) then
            DataPieceworkForProduction.DELETEALL(TRUE);
    end;

    // begin
    /*{
                    - Sacamos los nuevos campos de redeterminaciones
      PGM 22/11/18: - QB4853 Cambiada la llamada a la page en la funci�n UnitCard.
      PGM 19/03/19: - Se cambia caption del campo CalculateMarginBudget y se a�ade la columna CalculateMarginBudgetPerc
      JAV 02/04/19: - Se elimina la posibilidad de altas y eliminaciones de la p�gina
      JAV 26/07/19: - Se pasa el bot�n de cargar preciario de esta pantalla a la cabecera
      JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
      PGM 31/10/19: - Q8116 Se le a�ade a la llamada al report el filtro de cod. de presupuesto.
      JAV 03/02/19: - Se a�ade la columna "not Recalculate Sale"
      Q13152 DGG 21/06/21: Se muestra el campo Cod. Agrupaci�n. Solo visible si en QuoBuilding Setup se marca el campo Usar Agrupaciones en U.O Venta.
      JAV 15/09/21: - QB 1.09.18 Se ocultan los campos de las redeterminaciones
    }*///end
}








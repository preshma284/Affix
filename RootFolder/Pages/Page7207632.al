page 7207632 "Job - Piecework Certif. redete"
{
    CaptionML = ENU = 'Job - Piecework Certif. redetermination', ESP = 'Proyecto-UO Cert.Redetermina';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207438;
    DelayedInsert = true;
    SourceTableView = SORTING("Job No.", "Redetermination Code", "Piecework Code");
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Previous certified Quantity"; rec."Previous certified Quantity")
                {

                    Visible = False;
                }
                field("Certified Quantity to Adjust"; rec."Certified Quantity to Adjust")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Outstading Quantity to Cert."; rec."Outstading Quantity to Cert.")
                {

                    DecimalPlaces = 0 : 5;
                    Editable = QuantityofEditableSales;
                }
                field("Previous Unit Price"; rec."Previous Unit Price")
                {

                }
                field("Unit Price Redetermined"; rec."Unit Price Redetermined")
                {

                    DecimalPlaces = 0 : 6;
                    Editable = EditableContratPrice;
                }
                field("Unit Increase"; rec."Unit Increase")
                {

                    DecimalPlaces = 0 : 6;
                }
                field("Sales Amount (Base)"; rec.Amount(3))
                {

                    CaptionML = ENU = 'Sales Amount (Base)', ESP = 'Importe venta anterior';
                }
                field("Amount Sales Increase"; rec.Amount(2))
                {

                    CaptionML = ENU = 'Amount Sales Increase', ESP = 'Importe incremento venta';
                }
                field("Increased Amount of Redeterm."; rec.Amount(4))
                {

                    CaptionML = ENU = 'Increased amount of redeterm.', ESP = 'Importe de venta nuevo';
                }
                field("Amount Sales"; rec.Amount(0))
                {

                    CaptionML = ENU = 'AMount executed', ESP = 'Importe ejecutado';
                }
                field("Amount to Adjust"; rec.Amount(5))
                {

                    CaptionML = ENU = 'Amlount to Adjust', ESP = 'Importe a ajustar';
                    Visible = False;
                }
                field("Amount Pending Execution"; rec.Amount(1))
                {

                    CaptionML = ENU = 'Amount Pending Execution', ESP = 'Importe pendiente de ejecuci�n';
                    Visible = False

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("Units")
            {

                CaptionML = ENU = 'Units', ESP = 'Unidades';
                action("Unit Card")
                {

                    CaptionML = ENU = 'Unit Card', ESP = 'Ficha Unidad';

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        UnitCard;
                    END;


                }
                action("Additional Text")
                {

                    CaptionML = ENU = 'Additional Text', ESP = 'Texto adicionales';
                    RunObject = Page 7206929;
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                }

            }

        }
    }
    trigger OnInit()
    BEGIN
        EditableContratPrice := TRUE;
        QuantityofEditableSales := TRUE;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        PieceworkOnFormat;
        DescriptionOnFormat;
        AccountTypeOnFormat;
        AmountSalesOnFormat;
        UnitofMensureOnFormat;
        ContractPriceOnFormat;
        SalesUnitPriceOnFormat;
        SalesAmountOnFormat;
        Description2OnFormat;
        CalculateMarginBudgetOnFormat;
        AssignProductionOnFormat;
        QuantityAccumulateOnFormat;
        QuantityMeasureOnFormat;
        QuantityCertificationonFormat;
        QuantityInvoicedOnFormat;
    END;



    var
        EditableContratPrice: Boolean;
        QuantityofEditableSales: Boolean;
        PieceworkEmphasize: Boolean;
        AccountTypeEmphasize: Boolean;
        UnitofMeasureEmphasize: Boolean;
        ContractPriceEmphasize: Boolean;
        SalesUnitPriceEmphasize: Boolean;
        SalesAmountEmphasize: Boolean;
        Description2Emphasize: Boolean;
        BudgetCalculateMarginEmphasize: Boolean;
        ProductionAsignedEmphasize: Boolean;
        QuantityAccumulateEmphasize: Boolean;
        QuantityMeasureEmphasize: Boolean;
        QuantityCertificationEmphasize: Boolean;
        QuantityInvoicedEmphasize: Boolean;

    LOCAL procedure PieceworkOnFormat();
    begin
        PieceworkEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure DescriptionOnFormat();
    begin
    end;

    LOCAL procedure AccountTypeOnFormat();
    begin
        AccountTypeEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure AmountSalesOnFormat();
    begin
        SalesAmountEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure UnitofMensureOnFormat();
    begin
        UnitofMeasureEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure ContractPriceOnFormat();
    begin
        ContractPriceEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure SalesUnitPriceOnFormat();
    begin
        SalesUnitPriceEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure SalesAmountOnFormat();
    begin
        SalesAmountEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure Description2OnFormat();
    begin
        Description2Emphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure CalculateMarginBudgetOnFormat();
    begin
        BudgetCalculateMarginEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure AssignProductionOnFormat();
    begin
        ProductionAsignedEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure QuantityAccumulateOnFormat();
    begin
        QuantityAccumulateEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure QuantityMeasureOnFormat();
    begin
        QuantityMeasureEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure QuantityCertificationonFormat();
    begin
        QuantityCertificationEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure QuantityInvoicedOnFormat();
    begin
        QuantityInvoicedEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    procedure UnitCard();
    var
        DataPieceworkForProduction: Record 7207386;
    begin
        DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        PAGE.RUNMODAL(PAGE::"Job Piecework Card", DataPieceworkForProduction);
    end;

    // begin
    /*{
      Se pone la clave de ordenaci�n Cod. proyecto.
      Se pone la propiedad DeleteAllowed a No.
      Sacamos los nuevos cmpos de redeterminaciones
    }*///end
}








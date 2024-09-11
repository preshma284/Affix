page 7207480 "Bill of Items Piec Sales"
{
    CaptionML = ENU = 'Bill of Items SALES', ESP = 'DESCOMPUESTOS DE VENTA';
    SourceTable = 7207340;
    DelayedInsert = true;
    PageType = Card;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Has Additional Text"; rec."Has Additional Text")
                {

                    Enabled = edPage;
                }
                field("Job No."; rec."Job No.")
                {

                    Visible = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Visible = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No. Record"; rec."No. Record")
                {

                    Visible = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Line Type"; rec."Line Type")
                {

                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Description"; rec."Description")
                {

                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Cod. Measure Unit"; rec."Cod. Measure Unit")
                {

                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Performance By Piecework"; rec."Performance By Piecework")
                {

                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    Visible = useCurrencies;
                    Enabled = edPage;
                }
                field("Currency Date"; rec."Currency Date")
                {

                    Visible = useCurrencies;
                    Enabled = edPage;
                }
                field("Currency Factor"; rec."Currency Factor")
                {

                    Visible = useCurrencies;
                }
                field("Sale Price"; rec."Sale Price")
                {

                    Enabled = edPage;
                }
                field("Sale Amount"; rec."Sale Amount")
                {

                }
                field("Sale Price (LCY)"; rec."Sale Price (LCY)")
                {

                    Visible = useCurrencies;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Sale Amount (LCY)"; rec."Sale Amount (LCY)")
                {

                    DecimalPlaces = 2 : 3;
                    Visible = useCurrencies;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Sale Price (DR)"; rec."Sale Price (DR)")
                {

                    Visible = useCurrencies;
                }
                field("Sale Amount (DR)"; rec."Sale Amount (DR)")
                {

                    Visible = useCurrencies

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ESP = 'Texto Adicional';
                RunObject = Page 7206929;
                RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code"), "Key3" = FIELD("No.");
                Image = Text
    ;
            }

        }
    }
    trigger OnInit()
    BEGIN
        edPage := TRUE;
    END;

    trigger OnOpenPage()
    BEGIN
        //JAV 07/08/19: - Se hacen visibles los campos de c�lculo adicionales
        verAdicionales := QuoBuildingSetup."Use DCBP Aditional Fields";

        //JAV 08/04/20: - GEN003-02 Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Line Type" := rec."Line Type"::Resource;
    END;



    var
        Text014: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
        QuoBuildingSetup: Record 7207278;
        Modi: Boolean;
        verAdicionales: Boolean;
        edPage: Boolean;
        "--------------------------------------------- Divisas": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        useCurrencies: Boolean;

    procedure ShowBillOfItemsUse();
    var
        BillOfItemsUses: Page 7207580;
        DataCostByJU: Record 7207387;
    begin
        CLEAR(BillOfItemsUses);
        DataCostByJU.SETRANGE("Cost Type", rec."Line Type");
        DataCostByJU.SETRANGE("No.", rec."No.");
        DataCostByJU.SETRANGE("Job No.", rec."Job No.");
        BillOfItemsUses.SETTABLEVIEW(DataCostByJU);
        BillOfItemsUses.RUNMODAL;
    end;

    procedure setEditable(pEdit: Boolean);
    begin
        edPage := pEdit;
    end;

    // begin
    /*{
      JAV 25/07/19: - Se hacen visibles los campos de divisas seg�n configuraci�n de Quobuilding
      JAV 04/08/19: - Para CPM se a�aden las columnas "Performance", "Conversion Factor" y Vendor
      JAV 07/08/19: - Se hacen visibles los campos de c�lculo adicionales
      JAV 17/10/19: - Se a�ade el nombre del proveedor
      QMD 20/09/19: - GAP14 KALAM, VSTS 7594. Descompuestos - Unidades de medida - A�adir campos de horas previstas y reales
      JAV 06/12/19: - Se informa si la l�nea est� en un contrato para que no sean editables ciertos campos
      JAV 08/02/20: - Se a�aden "In Quote" e "In Quote Price"
    }*///end
}








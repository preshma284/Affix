page 7207515 "Bill of Items Piec by Job List"
{
    CaptionML = ENU = 'Bill of Items COST', ESP = 'DESCOMPUESTOS DE COSTE';
    SourceTable = 7207387;
    DelayedInsert = true;
    PageType = ListPart;

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
                field("Cod. Budget"; rec."Cod. Budget")
                {

                    Visible = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Cost Type"; rec."Cost Type")
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
                field("Activity Code"; rec."Activity Code")
                {

                    Editable = edPage;
                }
                field("BillOfItemsDescription"; rec."BillOfItemsDescription")
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                    Visible = FALSE;
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Analytical Concept Direct Cost"; rec."Analytical Concept Direct Cost")
                {

                    CaptionML = ESP = 'Concepto anal�tico';
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Qt. Measure Unit"; rec."Qt. Measure Unit")
                {

                    Visible = verAdicionales;
                    Enabled = edPage;
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Quantity"; rec."Quantity")
                {

                    BlankZero = true;
                    Visible = verAdicionales;
                    Enabled = edPage;
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Performance"; rec."Performance")
                {

                    BlankZero = true;
                    Visible = verAdicionales;
                    Enabled = edPage;
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Conversion Factor"; rec."Conversion Factor")
                {

                    BlankZero = true;
                    Visible = verAdicionales;
                    Enabled = edPage;
                    Style = Favorable;
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
                field("Direc Unit Cost"; rec."Direc Unit Cost")
                {

                    Enabled = edPage;
                }
                field("Budget Cost Currency"; rec."Budget Cost Currency")
                {

                    Visible = useCurrencies;
                }
                field("Direct Unitary Cost (JC)"; rec."Direct Unitary Cost (JC)")
                {

                    Visible = useCurrencies;
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Cost"; rec."Budget Cost")
                {

                    DecimalPlaces = 2 : 3;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Analytical Concept Ind. Cost"; rec."Analytical Concept Ind. Cost")
                {

                    Visible = FALSE;
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Indirect Unit Cost"; rec."Indirect Unit Cost")
                {

                    Visible = FALSE;
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("New Amount By Piec(Prox Reest)"; rec."New Amount By Piec(Prox Reest)")
                {

                    Visible = FALSE;
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("New Unit Cost (Prox Reest)"; rec."New Unit Cost (Prox Reest)")
                {

                    Visible = FALSE;
                    Enabled = edPage;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Direct Unitary Cost (DR)"; rec."Direct Unitary Cost (DR)")
                {

                    Visible = useCurrencies;
                }
                field("Budget Cost (DR)"; rec."Budget Cost (DR)")
                {

                    Visible = useCurrencies;
                }
                field("In Quote"; rec."In Quote")
                {

                }
                field("In Quote Price"; rec."In Quote Price")
                {

                }
                field("Vendor"; rec."Vendor")
                {

                    Enabled = edPage;
                    Editable = bInQuote;
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                }
                field("QB Framework Contr. No."; rec."QB Framework Contr. No.")
                {

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
        QuoBuildingSetup.GET();
        verAdicionales := QuoBuildingSetup."Use DCBP Aditional Fields";

        //JAV 08/04/20: - GEN003-02 Si se usan las divisas en los proyectos
        //jmma 28/10/20: - Se traslada a onInit el manejo de las divisas
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Cost Type" := rec."Cost Type"::Resource;
        Job.GET(rec."Job No.");
        //JAV 26/10/21: - QB 1.09.23 Si es un estudio no hay presupuesto
        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN BEGIN
            IF (Job."Current Piecework Budget" = '') THEN
                ERROR('No ha marcado el presupuesto actual');
            rec."Cod. Budget" := Job."Current Piecework Budget";
        END ELSE
            rec."Cod. Budget" := '';
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        Text014: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
        verAdicionales: Boolean;
        bInQuote: Boolean;
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
        DataCostByJU.SETRANGE("Cost Type", rec."Cost Type");
        DataCostByJU.SETRANGE("No.", rec."No.");
        DataCostByJU.SETRANGE("Job No.", rec."Job No.");
        BillOfItemsUses.SETTABLEVIEW(DataCostByJU);
        BillOfItemsUses.RUNMODAL;
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        //JAV 17/10/19: - Se a�ade el nombre del proveedor
        Rec.CALCFIELDS("Vendor Name");

        //JAV 06/12/19: - Se informa si la l�nea est� en un contrato para que no sean editables ciertos campos
        bInQuote := (not rec."In Quote");
    end;

    procedure setEditable(pEdit: Boolean);
    begin
        edPage := pEdit;
    end;

    // begin
    /*{
      JAV 25/07/19: - Se hacen visibles los campos de divisas seg�n configuraci�n de Quobuilding
      JAV 04/08/19: - Para CPM se a�aden las columnas rec."Performance", rec."Conversion Factor" y Vendor
      JAV 07/08/19: - Se hacen visibles los campos de c�lculo adicionales
      JAV 17/10/19: - Se a�ade el nombre del proveedor
      QMD 20/09/19: - GAP14 KALAM, VSTS 7594. Descompuestos - Unidades de medida - A�adir campos de horas previstas y reales
      JAV 06/12/19: - Se informa si la l�nea est� en un contrato para que no sean editables ciertos campos
      JAV 08/02/20: - Se a�aden rec."In Quote" e rec."In Quote Price"
    }*///end
}








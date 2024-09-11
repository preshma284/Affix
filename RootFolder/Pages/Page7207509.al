page 7207509 "Bill of Item Data"
{
    CaptionML = ENU = 'Bill of Item Data', ESP = 'Datos de descompuesto';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207277;
    PopulateAllFields = true;
    PageType = ListPlus;

    layout
    {
        area(content)
        {
            group("group8")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Units of Measure"; rec."Units of Measure")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                group("group12")
                {

                    CaptionML = ESP = 'Coste';
                    field("Measurement Cost"; rec."Measurement Cost")
                    {

                        Editable = edCostMeasure;
                    }
                    field("Price Cost"; rec."Price Cost")
                    {

                        Editable = edCostPrice;
                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("Total Amount Cost"; rec."Total Amount Cost")
                    {

                    }
                    field("CostDatabase.CI Cost"; CostDatabase."CI Cost")
                    {

                        CaptionML = ESP = '% CI Coste';
                        Editable = false;
                    }

                }
                group("group17")
                {

                    CaptionML = ESP = 'Venta';
                    field("Measurement Sale"; rec."Measurement Sale")
                    {

                        Editable = edSalesMeasure;
                    }
                    field("Proposed Sale Price"; rec."Proposed Sale Price")
                    {

                        Editable = edSalesPrice;
                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("Total Amount Sales"; rec."Total Amount Sales")
                    {

                    }
                    field("CostDatabase.CI Sales"; CostDatabase."CI Sales")
                    {

                        CaptionML = ESP = '% CI Venta';
                        Editable = false;
                    }

                }
                group("group22")
                {

                    CaptionML = ESP = 'Resultado';
                    field("Total Amount Sales - Total Amount Cost"; rec."Total Amount Sales" - rec."Total Amount Cost")
                    {

                        CaptionML = ESP = 'Diferencia Venta - Coste';
                    }
                    field("% Margin"; rec."% Margin")
                    {

                        Editable = edSalesPrice;
                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("Gross Profit Percentage"; rec."Gross Profit Percentage")
                    {

                        Style = Standard;
                        StyleExpr = TRUE;
                    }

                }

            }
            group("group26")
            {

                CaptionML = ESP = 'Coste';
                part("Cost"; 7207510)
                {

                    CaptionML = ESP = 'Descompuestos para Coste';
                    SubPageView = SORTING("Cod. Cost database", "Cod. Piecework", "Type", "No.")
                            WHERE("Use" = CONST("Cost"));
                    SubPageLink = "Cod. Cost database" = FIELD("Cost Database Default"), "Cod. Piecework" = FIELD("No.");
                    Visible = seePiecework;
                    UpdatePropagation = Both;
                }
                part("MedCost"; 7207372)
                {

                    SubPageView = SORTING("Cost Database Code", "Cod. Jobs Unit", "Line No.")
                            WHERE("Use" = CONST("Cost"));
                    SubPageLink = "Cost Database Code" = FIELD("Cost Database Default"), "Cod. Jobs Unit" = FIELD("No.");
                    Visible = seeMedition;
                    UpdatePropagation = Both;
                }

            }
            group("group29")
            {

                CaptionML = ESP = 'Venta';
                part("Sales"; 7207510)
                {

                    CaptionML = ESP = 'Descompuestos para Venta';
                    SubPageView = SORTING("Cod. Cost database", "Cod. Piecework", "Type", "No.")
                            WHERE("Use" = CONST("Sales"));
                    SubPageLink = "Cod. Cost database" = FIELD("Cost Database Default"), "Cod. Piecework" = FIELD("No.");
                    Visible = seePiecework;
                    UpdatePropagation = Both;
                }
                part("MedSales"; 7207372)
                {

                    SubPageView = SORTING("Cost Database Code", "Cod. Jobs Unit", "Line No.")
                            WHERE("Use" = CONST("Sales"));
                    SubPageLink = "Cost Database Code" = FIELD("Cost Database Default"), "Cod. Jobs Unit" = FIELD("No.");
                    Visible = seeMedition;
                    UpdatePropagation = Both

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
                CaptionML = ENU = 'Job Unit', ESP = 'Unidad de obra';
                action("action1")
                {
                    CaptionML = ENU = 'Calculate Cost JU', ESP = 'Recalcular Precios de UO';
                    Visible = false;
                    Image = CapacityLedger;

                    trigger OnAction()
                    BEGIN
                        CalculateAmounts;
                        MESSAGE(Text000);
                    END;


                }
                action("action2")
                {
                    CaptionML = ESP = 'Ver Descompuestos';

                    trigger OnAction()
                    BEGIN
                        seePiecework := TRUE;
                        seeMedition := FALSE;
                    END;


                }
                action("action3")
                {
                    CaptionML = ESP = 'Ver Medici�n';

                    trigger OnAction()
                    BEGIN
                        seePiecework := FALSE;
                        seeMedition := TRUE;
                    END;


                }
                action("action4")
                {
                    CaptionML = ESP = 'Ver Ambos';


                    trigger OnAction()
                    BEGIN
                        seePiecework := TRUE;
                        seeMedition := TRUE;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.SETRANGE("No.");
        seePiecework := TRUE;
        seeMedition := TRUE;
    END;

    trigger OnClosePage()
    VAR
        Piecework: Record 7207277;
    BEGIN
        IF (Modi) THEN BEGIN
            Piecework.GET(Rec."Cost Database Default", Rec."No.");
            Piecework.CalculateLine();
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Rec.SETRANGE("Account Type", rec."Account Type"::Unit);
        IF rec."Account Type" = rec."Account Type"::Heading THEN
            ERROR(Text001);

        Rec.CALCFIELDS("No. DP Cost", "No. DP Sale", "No. Medition detail Cost", "No. Medition detail Sales");
        edCostPrice := (rec."No. DP Cost" = 0);
        edSalesPrice := (rec."No. DP Sale" = 0);
        edCostMeasure := (rec."No. Medition detail Cost" = 0);
        edSalesMeasure := (rec."No. Medition detail Sales" = 0);
        //CalculateAmounts;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Modi := TRUE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        Rec.CALCFIELDS("No. DP Cost", "No. DP Sale", "No. Medition detail Cost", "No. Medition detail Sales");
        edCostPrice := (rec."No. DP Cost" = 0);
        edSalesPrice := (rec."No. DP Sale" = 0);
        edCostMeasure := (rec."No. Medition detail Cost" = 0);
        edSalesMeasure := (rec."No. Medition detail Sales" = 0);
        //CalculateAmounts;
        CostDatabase.GET(rec."Cost Database Default");

        rec.CalcTotalAmounts;
    END;



    var
        CostDatabase: Record 7207271;
        BillofItemData: Record 7207384;
        JobsUnits: Record 7207277;
        QBCostDatabase: Codeunit 7206986;
        Cost: Decimal;
        Text000: TextConst ESP = 'Finalizado';
        Text001: TextConst ENU = 'No bill of item is defined for highers', ESP = 'No se definen descompuestos para mayores de unidad de obra';
        Modi: Boolean;
        edCostPrice: Boolean;
        edSalesPrice: Boolean;
        edCostMeasure: Boolean;
        edSalesMeasure: Boolean;
        seePiecework: Boolean;
        seeMedition: Boolean;

    LOCAL procedure CalculateAmounts();
    begin
        //JAV 25/11/22: - QB 1.12.24 Se elimina el report para el rec�lculo, se llama directamente a la funci�n en la tabla
        CostDatabase.GET(rec."Cost Database Default");
        QBCostDatabase.CD_CalculateAll(CostDatabase, FALSE);

        Rec.GET(rec."Cost Database Default", rec."No."); //Lo vuelvo a leer por que el paso anterior lo cambi�
                                                         //CurrPage.SAVERECORD;
                                                         //CurrPage.UPDATE;
    end;

    // begin
    /*{
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3.
    }*///end
}








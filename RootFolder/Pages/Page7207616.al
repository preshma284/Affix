page 7207616 "Work Scorecard"
{
    Editable = false;
    CaptionML = ENU = 'Work Scorecard', ESP = 'Cuadro de mando';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;
    SourceTable = 167;
    DataCaptionFields = "No.", "Description";
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                // part("Gr�fico"; 7207618)
                part("Grfico"; 7207618)
                {

                    CaptionML = ENU = 'Indicators', ESP = 'Indicadores';
                }
                part("Advance"; 7207614)
                {

                    CaptionML = ESP = 'Avance';
                }

            }
            grid("Detalle")
            {

                CaptionML = ENU = 'Budget Indicator', ESP = 'Detalle';
                GridLayout = Columns;
                group("Study")
                {

                    CaptionML = ENU = 'Summary Study', ESP = 'Resumen estudio';
                    field("SalesBudgetStudy"; SalesBudgetStudy)
                    {

                        CaptionML = ENU = 'Sales Budget Study', ESP = 'Estudio venta ppto.';
                        Editable = False;
                    }
                    field("CostBudgetStudy"; CostBudgetStudy)
                    {

                        CaptionML = ENU = 'Cost Budget Study', ESP = 'Estudio coste ppto.';
                        Editable = False;
                    }
                    field("MarginBudgetStudy"; MarginBudgetStudy)
                    {

                        CaptionML = ENU = 'Study Margin', ESP = 'Margen estudio';
                        Editable = False;
                    }
                    field("MarginBudgetStudyPer"; MarginBudgetStudyPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Study Margin', ESP = 'Margen estudio';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group61")
                {

                    CaptionML = ENU = 'Summary Job', ESP = 'Resumen obra';
                    field("SalesActual"; SalesActual)
                    {

                        CaptionML = ENU = 'Sales Actual Budget', ESP = 'Venta ppto. actual';
                        Editable = False;
                    }
                    field("CostActualOri"; CostActualOri)
                    {

                        CaptionML = ENU = 'Cost Actual Budget', ESP = 'Coste ppto. actual';
                        Editable = False;
                    }
                    field("MarginActual"; MarginActual)
                    {

                        CaptionML = ESP = 'Margen ppto. actual';
                        Editable = False;
                    }
                    field("MarginActualPer"; MarginActualPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Margin Actual Budget', ESP = 'Margen ppto. actual';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group66")
                {

                    CaptionML = ENU = 'Certification', ESP = 'Avance certificaci�n';
                    field("AvSales"; SalesActualOri)
                    {

                        CaptionML = ENU = 'Origin Budget', ESP = 'Ppto. orgien';
                    }
                    field("CertAmount"; CertAmount)
                    {

                        CaptionML = ENU = 'Executed', ESP = 'Realizado';
                    }
                    field("CertAmountDif"; CertAmountDif)
                    {

                        CaptionML = ENU = 'Difference', ESP = 'Pendiente';
                    }
                    field("CertAmountPer"; CertAmountPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Progress', ESP = '% Avance';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group71")
                {

                    CaptionML = ENU = 'Production', ESP = 'Avance producci�n';
                    field("AvCost"; SalesActualOri)
                    {

                        CaptionML = ENU = 'Origin Budget', ESP = 'Ppto. origen';
                    }
                    field("ProdAmount"; ProdAmount)
                    {

                        CaptionML = ENU = 'Executed', ESP = 'Realizado';
                    }
                    field("ProdAmountDif"; ProdAmountDif)
                    {

                        CaptionML = ENU = 'Pending', ESP = 'Pendiente';
                    }
                    field("ProdAmountPer"; ProdAmountPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Progress', ESP = '% Avance';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group76")
                {

                    CaptionML = ENU = 'Execution', ESP = 'Avance ejecuci�n';
                    field("AvCost2"; CostActualOri)
                    {

                        CaptionML = ENU = 'Origin Budget', ESP = 'Ppto. coste origen';
                    }
                    field("Change"; CostActual)
                    {

                        CaptionML = ENU = 'Executed', ESP = 'Realizado';
                    }
                    field("Change2"; CostAmountDif)
                    {

                        CaptionML = ENU = 'Difference', ESP = 'Pendiente';
                    }
                    field("Change3"; costAmountPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Progress', ESP = '% Avance';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group81")
                {

                    CaptionML = ENU = 'Certification', ESP = 'Desviaci�n certificaci�n';
                    field("DesSales"; CertAmount)
                    {

                        CaptionML = ENU = 'Budget', ESP = 'Certificaci�n';
                    }
                    field("DesCert"; ProdAmount)
                    {

                        CaptionML = ENU = 'Executed', ESP = 'Producci�n';
                    }
                    field("CertAmountDevDif"; CertAmountDevDif)
                    {

                        CaptionML = ENU = 'Difference', ESP = 'Diferencia';
                    }
                    field("CertAmountDevPer"; CertAmountDevPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Progress', ESP = '% Desviaci�n';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group86")
                {

                    CaptionML = ENU = 'Production', ESP = 'Desviaci�n producci�n';
                    field("DesProd"; CostActual)
                    {

                        CaptionML = ENU = 'Budget', ESP = 'Coste';
                    }
                    field("DesProdAmount"; ProdAmount)
                    {

                        CaptionML = ENU = 'Executed', ESP = 'Producci�n';
                    }
                    field("ProdAmountDevDif"; ProdAmountDevDif)
                    {

                        CaptionML = ENU = 'Difference', ESP = 'Margen Actual';
                    }
                    field("ProdAmountDevPer"; ProdAmountDevPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Progress', ESP = '% Margen';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("group91")
                {

                    CaptionML = ENU = 'Ejecution', ESP = 'Desviaci�n ejecuci�n';
                    Visible = false;
                    field("DesCost"; CostActual)
                    {

                        CaptionML = ENU = 'Budget', ESP = 'Presupuesto';
                    }
                    field("Change5"; ProdAmount)
                    {

                        CaptionML = ENU = 'Executed', ESP = 'Realizado';
                    }
                    field("Change6"; ProdAmountDevDif)
                    {

                        CaptionML = ENU = 'Difference', ESP = 'Diferencia';
                    }
                    field("Change7"; ProdAmountDevPer)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = 'Progress', ESP = '%Desviaci�n';
                        MinValue = 0;
                        MaxValue = 100;
                    }

                }
                group("WIP")
                {

                    CaptionML = ENU = 'Work In Progress', ESP = 'Obra en curso';
                    group("RealicedDesv")
                    {

                        CaptionML = ENU = 'Execution Deviation', ESP = 'Desviaci�n ejecuci�n';
                        grid("RealMargin")
                        {

                            CaptionML = ENU = 'Real Margin', ESP = 'Margen real';
                            Editable = False;
                            GridLayout = Columns;

                        }

                    }
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcValues;
        UpdateChart;
    END;



    var
        CostActual: Decimal;
        CostAmountDif: Decimal;
        costAmountPer: Decimal;
        ProdAmount: Decimal;
        ProdAmountDevDif: Decimal;
        ProdAmountDevPer: Decimal;
        SalesActual: Decimal;
        MarginActual: Decimal;
        MarginActualPer: Decimal;
        JobOrigin: Record 167;
        JobStudy: Record 167;
        SalesBudgetStudy: Decimal;
        CostBudgetStudy: Decimal;
        MarginBudgetStudy: Decimal;
        MarginBudgetStudyPer: Decimal;
        SalesActualOri: Decimal;
        CertAmount: Decimal;
        CertAmountDif: Decimal;
        CertAmountPer: Decimal;
        CostActualOri: Decimal;
        ProdActualOri: Decimal;
        ProdAmountDif: Decimal;
        ProdAmountPer: Decimal;
        CertAmountDevDif: Decimal;
        CertAmountDevPer: Decimal;

    procedure CalcValues();
    begin
        Rec.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount", "Certification Amount", "Usage (Cost) (LCY)", "Actual Production Amount");

        // Valores presupuesto actual
        SalesActual := rec."Budget Sales Amount";
        CostActualOri := rec."Budget Cost Amount";
        MarginActual := rec.CalculateMarginProvided_DL;
        MarginActualPer := rec.CalculateMarginProvidedPercentage_DL;

        // Valores del estudio
        if JobStudy.GET(rec."Original Quote Code") then begin
            JobStudy.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount");
            SalesBudgetStudy := JobStudy."Budget Sales Amount";
            CostBudgetStudy := JobStudy."Budget Cost Amount";
            MarginBudgetStudy := JobStudy.CalculateMarginProvided_DL;
            MarginBudgetStudyPer := JobStudy.CalculateMarginProvidedPercentage_DL;
        end ELSE begin
            SalesBudgetStudy := 0;
            CostBudgetStudy := 0;
            MarginBudgetStudy := 0;
            MarginBudgetStudyPer := 0;
        end;


        JobOrigin.GET(rec."No.");
        JobOrigin.SETFILTER("Budget Filter", rec."Budget Filter");
        JobOrigin.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount", "Production Budget Amount");

        // Valores avance certificaci�n
        SalesActualOri := JobOrigin."Budget Sales Amount";
        CertAmount := rec."Certification Amount";
        CertAmountDif := SalesActualOri - CertAmount;
        if SalesActualOri <> 0 then
            CertAmountPer := (CertAmount / SalesActualOri) * 100
        ELSE
            CertAmountPer := 0;


        // Valores avance producci�n
        //CostActualOri :=  JobOrigin."Budget Cost Amount";
        ProdActualOri := JobOrigin."Production Budget Amount";
        //jmma ProdAmount := "Usage (Cost)";
        ProdAmount := rec."Actual Production Amount";
        ProdAmountDif := ProdActualOri - ProdAmount;
        if ProdActualOri <> 0 then
            ProdAmountPer := (ProdAmount / ProdActualOri) * 100
        ELSE
            ProdAmountPer := 0;

        // Valores de avance de ejecuci�n -------------------------- PENDIENTE DE DESARROLLOS DE SEPARACI�N
        CostActualOri := JobOrigin."Budget Cost Amount";
        //ProdActualOri:=JobOrigin."Production Budget Amount";
        CostActual := rec."Usage (Cost) (LCY)";
        CostAmountDif := CostActualOri - CostActual;

        if CostActualOri <> 0 then
            costAmountPer := (CostActual / CostActualOri) * 100
        ELSE
            costAmountPer := 0;


        // Valores desviaci�n certificaci�n
        CertAmountDevDif := CertAmount - ProdAmount;
        if CertAmount <> 0 then
            CertAmountDevPer := (CertAmountDevDif / CertAmount) * 100
        ELSE
            CertAmountDevPer := 0;


        //Valores desviaci�n producci�n
        ProdAmountDevDif := ProdAmount - CostActual;
        if ProdAmount <> 0 then
            ProdAmountDevPer := (ProdAmountDevDif / ProdAmount) * 100
        ELSE
            ProdAmountDevPer := 0;

        //Valores de desviaci�n de ejecuci�n -------------------------- PENDIENTE DE DESARROLLOS DE SEPARACI�N
    end;

    procedure UpdateChart();
    begin
        CurrPage.Grfico.PAGE.SetFilter(rec."No.", rec.GETFILTER("Posting Date Filter"));
        CurrPage.Grfico.PAGE.UpdateChart;

        CurrPage.Advance.PAGE.SetJob(rec."No.");
        CurrPage.Advance.PAGE.UpdateChart;
    end;

    // begin//end
}








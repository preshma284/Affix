page 7207357 "Aggregates Job Statistics"
{
    CaptionML = ENU = 'Aggregates Job Statistics', ESP = 'Estad�sticas proyecto agrega';
    SourceTable = 167;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("BudgetSalesAmount"; BudgetSalesAmount)
                {

                    CaptionML = ENU = 'Budget Sales Amount', ESP = 'Imp. venta ppto.';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountSalesBudget;
                    END;


                }
                field("BudgetCostAmount"; BudgetCostAmount)
                {

                    CaptionML = ENU = 'Budget Cost Amount', ESP = 'Imp. coste pto.';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountCostBudget;
                    END;


                }
                field("ExpectedMargin"; ExpectedMargin)
                {

                    CaptionML = ENU = 'Expected Margin', ESP = 'Margen previsto';
                }
                field("PercentageExpectedMargin"; PercentageExpectedMargin)
                {

                    CaptionML = ENU = 'Percentage Expected Margin', ESP = '% margen previsto';
                }
                field("SalesExpectedConsumedAmount"; SalesExpectedConsumedAmount)
                {

                    CaptionML = ENU = 'Sales Expected Consumed Amount', ESP = 'Imp. consumido a p. venta';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountConsuPriceSales;
                    END;


                }
                field("CostExpectedConsumeAmount"; CostExpectedConsumeAmount)
                {

                    CaptionML = ENU = 'Cost Expected Consume Amount', ESP = 'Consumo (p.coste)';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountConsuPriceCost;
                    END;


                }
                field("RealizeMargin"; RealizeMargin)
                {

                    CaptionML = ENU = 'Realize MArgin', ESP = 'Margen realizado';
                }
                field("PercentageRealizeMargin"; PercentageRealizeMargin)
                {

                    CaptionML = ENU = 'Percentage Realize Margin', ESP = '% margen realizado';
                }

            }
            group("group29")
            {

                CaptionML = ENU = 'Purcharse', ESP = 'Compras';
                field("ReceivePendingOrderAmount"; ReceivePendingOrderAmount)
                {

                    CaptionML = ENU = 'Receive Pending Order Amount', ESP = 'Imp. pedidos pdtes. recibir';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountOrderPendingReceived;
                    END;


                }
                field("ReceiveShipmentPendingAmount"; ReceiveShipmentPendingAmount)
                {

                    CaptionML = ENU = 'Receive Shipment Pending Amount', ESP = 'Imp. albaranes pdtes. recibir';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountShipmentPendingPurchase;
                    END;


                }

            }
            group("group32")
            {

                CaptionML = ENU = 'Warehouse', ESP = 'Almac�n';
                field("PendingOrderAmount"; PendingOrderAmount)
                {

                    CaptionML = ENU = 'Pending Order Amount', ESP = 'Imp. pedidos pendientes';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountOrderPending;
                    END;


                }
                field("WarehouseShipmentPendingAmount"; WarehouseShipmentPendingAmount)
                {

                    CaptionML = ENU = 'Warehouse Shipment Pending AMount', ESP = 'Imp. albaranes pendientes';
                }
                field("WarehouseExistenceAmount"; WarehouseExistenceAmount)
                {

                    CaptionML = ENU = 'Shipment Existence Amount', ESP = 'Importe existencia almac�n';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountInventoryWarehouse;
                    END;


                }

            }
            group("group36")
            {

                CaptionML = ENU = 'Certifications', ESP = 'Certificaciones';
                field("MeasureAmount"; MeasureAmount)
                {

                    CaptionML = ENU = 'Measure Amount', ESP = 'Importe mediciones';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountMeasure;
                    END;


                }
                field("CertificationsAmount"; CertificationsAmount)
                {

                    CaptionML = ENU = 'Certifications Amount', ESP = 'Importe certificaciones';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountCertification;
                    END;


                }
                field("InvoicedCertificationsAmount"; InvoicedCertificationsAmount)
                {

                    CaptionML = ENU = 'Invoiced CertificationsAmount', ESP = 'Certificaciones Facturadas';
                }

            }
            group("group40")
            {

                CaptionML = ENU = 'Production', ESP = 'Producci�n';
                field("InvoicedAmount"; InvoicedAmount)
                {

                    CaptionML = ENU = 'Invoiced Amount', ESP = 'Importe facturado (DL)';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountInvoiced(1);
                    END;


                }
                field("JobInProgress"; JobInProgress)
                {

                    CaptionML = ENU = 'Job in Progress', ESP = 'Obra en curso (DL)';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountInvoiced(2);
                    END;


                }
                field("RealProductionMeasureAmount"; RealProductionMeasureAmount)
                {

                    CaptionML = ENU = 'Real Production Measure Amount', ESP = 'Medici�n producci�n real';



                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountMeasureProductionReal;
                    END;


                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        CalculateValues;
    END;



    var
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        BudgetSalesAmount: Decimal;
        BudgetCostAmount: Decimal;
        ExpectedMargin: Decimal;
        PercentageExpectedMargin: Decimal;
        SalesExpectedConsumedAmount: Decimal;
        CostExpectedConsumeAmount: Decimal;
        RealizeMargin: Decimal;
        PercentageRealizeMargin: Decimal;
        ReceivePendingOrderAmount: Decimal;
        ReceiveShipmentPendingAmount: Decimal;
        PendingOrderAmount: Decimal;
        WarehouseShipmentPendingAmount: Decimal;
        WarehouseExistenceAmount: Decimal;
        MeasureAmount: Decimal;
        CertificationsAmount: Decimal;
        InvoicedCertificationsAmount: Decimal;
        InvoicedAmount: Decimal;
        JobInProgress: Decimal;
        RealProductionMeasureAmount: Decimal;
        ProductionAmount: Decimal;



    procedure ShowAmountShipmentPendingPurchase();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETRANGE(PurchRcptLine."Job No.", rec."No.");
        PAGE.RUN(0, PurchRcptLine);
    end;

    procedure ShowAmountShipmentPendingWarehouse();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETRANGE(PurchRcptLine."Job No.", '');
        PurchRcptLine.SETRANGE(PurchRcptLine."Location Code", rec."Job Location");
        PAGE.RUN(0, PurchRcptLine);
    end;

    procedure CalculateValues();
    begin
        Job.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
        Job.SETRANGE("Job Matrix - Work", Job."Job Matrix - Work"::Work);
        Job.SETRANGE("Matrix Job it Belongs", rec."No.");
        if Job.FINDSET then
            repeat
                Job.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount", "Usage (Price) (LCY)", "Usage (Cost) (LCY)", "Receive Pend. Order Amt (LCY)",
                                   "Pending Orders Amount (LCY)", "Warehouse Availability Amount", "Measure Amount", "Certification Amount",
                                   "Invoiced Certification", "Actual Production Amount", "Invoiced Price (LCY)", "Invoiced (LCY)", "Job in Progress (LCY)");
                BudgetSalesAmount += Job."Budget Sales Amount";
                BudgetCostAmount += Job."Budget Cost Amount";
                SalesExpectedConsumedAmount += Job."Usage (Price) (LCY)";
                CostExpectedConsumeAmount += Job."Usage (Cost) (LCY)";
                ReceivePendingOrderAmount += Job."Receive Pend. Order Amt (LCY)";
                PendingOrderAmount += Job."Pending Orders Amount (LCY)";
                WarehouseExistenceAmount += Job."Warehouse Availability Amount";
                MeasureAmount += Job."Measure Amount";
                CertificationsAmount += Job."Certification Amount";
                InvoicedCertificationsAmount += Job."Invoiced Certification";
                ProductionAmount += Job."Invoiced Price (LCY)";
                RealProductionMeasureAmount += Job."Actual Production Amount";
                ReceiveShipmentPendingAmount += CalculateAmountPendingShipmentPourchase2(Job);
                WarehouseShipmentPendingAmount += FCalculateAmountPendingShipmentWarehouse2(Job);
                InvoicedAmount += Job."Invoiced (LCY)";
                JobInProgress += Job."Job in Progress (LCY)";
            until Job.NEXT = 0;

        CalculateValuestoShow;
    end;

    procedure CalculateValuestoShow();
    begin
        Rec.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount", "Usage (Price) (LCY)", "Usage (Cost) (LCY)", "Receive Pend. Order Amt (LCY)",
                   "Pending Orders Amount (LCY)", "Warehouse Availability Amount", "Measure Amount", "Certification Amount",
                   "Invoiced Certification", "Actual Production Amount", "Invoiced Price (LCY)", "Invoiced (LCY)", "Job in Progress (LCY)");
        BudgetSalesAmount += rec."Budget Sales Amount";
        BudgetCostAmount += rec."Budget Cost Amount";
        SalesExpectedConsumedAmount += rec."Usage (Price) (LCY)";
        CostExpectedConsumeAmount += rec."Usage (Cost) (LCY)";
        ReceivePendingOrderAmount += rec."Receive Pend. Order Amt (LCY)";
        PendingOrderAmount += rec."Pending Orders Amount (LCY)";
        WarehouseExistenceAmount += rec."Warehouse Availability Amount";
        MeasureAmount += rec."Measure Amount";
        CertificationsAmount += rec."Certification Amount";
        InvoicedCertificationsAmount += rec."Invoiced Certification";
        RealProductionMeasureAmount += rec."Actual Production Amount";
        InvoicedAmount += rec."Invoiced (LCY)";
        JobInProgress += rec."Job in Progress (LCY)";

        ExpectedMargin := -BudgetSalesAmount - BudgetCostAmount;
        if BudgetSalesAmount = 0 then
            PercentageExpectedMargin := 0
        ELSE
            PercentageExpectedMargin := ((BudgetSalesAmount - BudgetCostAmount) / (BudgetSalesAmount) * 100);
        ProductionAmount += rec."Invoiced Price (LCY)";

        RealizeMargin := ProductionAmount - CostExpectedConsumeAmount;
        if ProductionAmount = 0 then
            PercentageRealizeMargin := 0
        ELSE
            PercentageRealizeMargin := ((ProductionAmount - CostExpectedConsumeAmount) / (ProductionAmount) * 100);
        ReceiveShipmentPendingAmount += CalculateAmountPendingShipmentPourchase2(Rec);
        WarehouseShipmentPendingAmount += FCalculateAmountPendingShipmentWarehouse2(Rec);
    end;

    procedure CalculateAmountPendingShipmentPourchase2(Job2: Record 167): Decimal;
    var
        PurchRcptLine: Record 121;
        VPourchaseShipmentAmount: Decimal;
    begin
        // Con esta funci�n nos recorremos el hist. alb compra y por cada registro calculamos la funci�n que tendr� en cuenta el valor de la
        // funci�n del hist�rico
        Job2.CALCFIELDS("Shipment Pend. Amt (LCY)");
        exit(rec."Shipment Pend. Amt (LCY)");
    end;

    procedure FCalculateAmountPendingShipmentWarehouse2(Job3: Record 167): Decimal;
    var
        PurchRcptLine: Record 121;
        VPourchaseShipmentAmountWarehouse: Decimal;
    begin
        //con esta funci�n nos recorremos el hist. alb compra y por cada registro calculamos la funci�n que tendr� en cuenta el valor de la
        //funci�n del hist�rico

        exit(0);
    end;

    procedure ShowAmountSalesBudget();
    var
        Job2: Record 167;
        GLBudgetEntry: Record 96;
    begin
        Job2.RESET;
        Job2.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
        Job2.SETRANGE("Job Matrix - Work", Job2."Job Matrix - Work"::Work);
        Job2.SETRANGE("Matrix Job it Belongs", rec."No.");

        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudget(Job2)); //JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
        GLBudgetEntry.SETRANGE(Type, GLBudgetEntry.Type::Revenues);

        if Job2.FINDSET then begin
            GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", Job2."Matrix Job it Belongs" + '*');
            PAGE.RUN(0, GLBudgetEntry);
        end ELSE begin
            GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", rec."No.");
            PAGE.RUN(0, GLBudgetEntry);
        end;
    end;

    procedure ShowAmountCostBudget();
    var
        Job2: Record 167;
        GLBudgetEntry: Record 96;
    begin
        Job2.RESET;
        Job2.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
        Job2.SETRANGE("Job Matrix - Work", Job2."Job Matrix - Work"::Work);
        Job2.SETRANGE("Matrix Job it Belongs", rec."No.");

        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudget(Job2)); //JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
        GLBudgetEntry.SETRANGE(Type, GLBudgetEntry.Type::Expenses);

        if Job2.FINDSET then begin
            GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", Job2."Matrix Job it Belongs" + '*');
            PAGE.RUN(0, GLBudgetEntry);
        end ELSE begin
            GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", rec."No.");
            PAGE.RUN(0, GLBudgetEntry);
        end;
    end;

    procedure ShowAmountConsuPriceSales();
    var
        Job2: Record 167;
        JobLedgerEntry: Record 169;
    begin
        Job2.RESET;
        Job2.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
        Job2.SETRANGE("Job Matrix - Work", Job2."Job Matrix - Work"::Work);
        Job2.SETRANGE("Matrix Job it Belongs", rec."No.");
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);

        if Job2.FINDSET then begin
            JobLedgerEntry.SETFILTER("Job No.", Job2."Matrix Job it Belongs" + '*');
            PAGE.RUN(0, JobLedgerEntry);
        end ELSE begin
            JobLedgerEntry.SETFILTER("Job No.", rec."No.");
            PAGE.RUN(0, JobLedgerEntry)
        end;
    end;

    procedure ShowAmountConsuPriceCost();
    var
        Job2: Record 167;
        JobLedgerEntry: Record 169;
    begin
        Job2.RESET;
        Job2.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
        Job2.SETRANGE("Job Matrix - Work", Job2."Job Matrix - Work"::Work);
        Job2.SETRANGE("Matrix Job it Belongs", rec."No.");
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);

        if Job2.FINDSET then begin
            JobLedgerEntry.SETFILTER("Job No.", Job2."Matrix Job it Belongs" + '*');
            PAGE.RUN(0, JobLedgerEntry)
        end ELSE begin
            JobLedgerEntry.SETFILTER("Job No.", rec."No.");
            PAGE.RUN(0, JobLedgerEntry)
        end;
    end;

    procedure ShowAmountOrderPendingReceived();
    var
        PurchaseLine: Record 39;
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETFILTER("Document Type", '%1|%2|%3', PurchaseLine."Document Type"::Order,
                               PurchaseLine."Document Type"::"Blanket Order", PurchaseLine."Document Type"::"Return Order");
        PurchaseLine.SETRANGE("Job No.", rec."No.");
        PAGE.RUN(0, PurchaseLine);
    end;

    procedure ShowAmountOrderPending();
    var
        PurchaseLine: Record 39;
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETFILTER("Document Type", '%1|%2|%3', PurchaseLine."Document Type"::Order,
                               PurchaseLine."Document Type"::"Blanket Order", PurchaseLine."Document Type"::"Return Order");
        PurchaseLine.SETRANGE("Job No.", '');
        PurchaseLine.SETRANGE("Location Code", rec."Job Location");
        PAGE.RUN(0, PurchaseLine);
    end;

    procedure ShowAmountInventoryWarehouse();
    var
        ValueEntry: Record 5802;
    begin
        ValueEntry.RESET;
        ValueEntry.SETRANGE("Location Code",rec."Job Location");
        ValueEntry.SETRANGE("Expected Cost", FALSE);
        ValueEntry.SETFILTER("Posting Date", rec.GETFILTER("Posting Date Filter"));
        PAGE.RUN(0, ValueEntry);
    end;

    procedure ShowAmountMeasure();
    var
        HistMeasureLines: Record 7207339;
    begin
        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Job No.", rec."No.");
        HistMeasureLines.SETFILTER("Piecework No.", rec.GETFILTER("Piecework Filter"));
        HistMeasureLines.SETFILTER("Posting Date", rec.GETFILTER("Posting Date Filter"));
        PAGE.RUN(0, HistMeasureLines);
    end;

    procedure ShowAmountCertification();
    var
        HistCertificationLines: Record 7207342;
    begin
        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Job No.", rec."No.");
        HistCertificationLines.SETFILTER("Piecework No.", rec.GETFILTER("Piecework Filter"));
        HistCertificationLines.SETFILTER("Job No.", rec.GETFILTER("Posting Date Filter"));
        PAGE.RUN(0, HistCertificationLines);
    end;

    procedure ShowAmountMeasureProductionReal();
    var
        HistProdMeasureLines: Record 7207402;
    begin
        HistProdMeasureLines.RESET;
        HistProdMeasureLines.SETRANGE("Job No.", rec."No.");
        HistProdMeasureLines.SETFILTER("Piecework No.", rec.GETFILTER("Piecework Filter"));
        HistProdMeasureLines.SETFILTER("Posting Date", rec.GETFILTER("Posting Date Filter"));
        PAGE.RUN(0, HistProdMeasureLines);
    end;

    procedure ShowAmountInvoiced(OCourse: Integer);
    var
        Job2: Record 167;
        JobLedgerEntry: Record 169;
    begin
        Job2.RESET;
        Job2.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
        Job2.SETRANGE("Job Matrix - Work", Job2."Job Matrix - Work"::Work);
        Job2.SETRANGE("Matrix Job it Belongs", rec."No.");
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", "Job in progress");
        if OCourse = 0 then
            JobLedgerEntry.SETRANGE("Job in progress");
        if OCourse = 1 then
            JobLedgerEntry.SETRANGE("Job in progress", FALSE);
        if OCourse = 2 then
            JobLedgerEntry.SETRANGE("Job in progress", TRUE);
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Sale);
        if Job2.FIND('-') then begin
            JobLedgerEntry.SETFILTER("Job No.", Job2."Matrix Job it Belongs" + '*');
            PAGE.RUN(0, JobLedgerEntry)
        end ELSE begin
            JobLedgerEntry.SETFILTER("Job No.", rec."No.");
            PAGE.RUN(0, JobLedgerEntry)
        end;
    end;

    // begin
    /*{
      JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
    }*///end
}








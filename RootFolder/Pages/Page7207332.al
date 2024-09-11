page 7207332 "Jobs Statistics"
{
    Editable = false;
    CaptionML = ENU = 'Jobs Statistics', ESP = 'Estad�sticas proyecto';
    SourceTable = 167;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Budget Sales Amount"; rec."Budget Sales Amount")
                {

                }
                field("Budget Cost Amount"; rec."Budget Cost Amount")
                {

                }
                field("Invoiced Price (LCY)"; rec."Invoiced Price (LCY)")
                {

                }
                field("Usage (Cost) (LCY)"; rec."Usage (Cost) (LCY)")
                {

                }
                field("Text19037728"; Text19037728)
                {

                    CaptionClass = Text19037728;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Direct Cost Amount PieceWork"; rec."Direct Cost Amount PieceWork")
                {

                    Editable = False;
                }
                field("Indirect Cost Amount Piecework"; rec."Indirect Cost Amount Piecework")
                {

                    CaptionML = ENU = 'Indirect Cost Amount Piecework', ESP = 'Importe Costes indirectos UO';
                    Editable = False;
                }
                field("CalculateMarginProvided_DL"; rec."CalculateMarginProvided_DL")
                {

                    CaptionML = ENU = 'Margin Pfovided', ESP = 'Margen previsto';
                }
                field("CalculateMarginProvidedPercentage_DL"; rec."CalculateMarginProvidedPercentage_DL")
                {

                    CaptionML = ENU = '% Margin Provided', ESP = '% margen previsto';
                }
                field("MarginRealized"; MarginRealized)
                {

                    CaptionML = ENU = 'Margin Realized', ESP = 'Margen realizado';
                }
                field("MarginRealizedPorc"; MarginRealizedPorc)
                {

                    CaptionML = ENU = '% Achieved margin', ESP = '% Margen realizado';
                }
                field("CalcMarginDirect_DL"; rec.CalcMarginDirect_DL)
                {

                    CaptionML = ENU = '% Margin Over Direct Costs', ESP = '% Margen sobre costes directos';
                    Editable = False;
                }
                field("CalcPercentageCostIndirect_DL"; rec.CalcPercentageCostIndirect_DL)
                {

                    CaptionML = ENU = '% Indirect Cost Over �Total Costs', ESP = '% de coste indirecto sobre total costes';
                    Editable = False;
                }

            }
            group("group36")
            {

                CaptionML = ENU = 'Purchase', ESP = 'Compras';
                group("group37")
                {

                    group("group38")
                    {

                        CaptionML = ENU = 'Amount', ESP = 'Importes';
                        field("Receive Pend. Order Amt (LCY)"; rec."Receive Pend. Order Amt (LCY)")
                        {

                        }
                        field("Shipment Pend. Amt (LCY) - Shipment FRI Pend. Amt (LCY)"; rec."Shipment Pend. Amt (LCY)" - rec."Shipment FRI Pend. Amt (LCY)")
                        {

                            CaptionML = ENU = 'Pending Shipment Amount Receive', ESP = 'Imp. albaranes pdtes. recibir';

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowAmountShipmentPendingPurchaseNormal;
                            END;


                        }
                        field("Shipment FRI Pend. Amt (LCY)"; rec."Shipment FRI Pend. Amt (LCY)")
                        {

                            CaptionML = ENU = 'FRIS Shipment Amount', ESP = 'Imp. albaranes FRIS';

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowAmountShipmentPendingPurchaseFRIS;
                            END;


                        }
                        field("Shipment Pend. Amt (LCY)"; rec."Shipment Pend. Amt (LCY)")
                        {

                            CaptionML = ENU = 'Pending Shipment Total', ESP = 'Total albaranes pendientes';
                            Style = Standard;
                            StyleExpr = TRUE;

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowAmountShipmentPendingPurchase;
                            END;


                        }

                    }

                }

            }
            group("group43")
            {

                CaptionML = ENU = 'Warehouse', ESP = 'Almac�n';
                field("Warehouse Availability Amount"; rec."Warehouse Availability Amount")
                {

                    CaptionML = ENU = 'Warehouse Availability Amount', ESP = 'Importe existencias almac�n';
                }

            }
            group("group45")
            {

                CaptionML = ENU = 'Certifications', ESP = 'Certificaciones';
                field("Measure Amount"; rec."Measure Amount")
                {

                    CaptionML = ENU = 'Measure Amount', ESP = 'Importe mediciones';
                }
                field("Certification Amount"; rec."Certification Amount")
                {

                }
                field("Invoiced Certification"; rec."Invoiced Certification")
                {

                }

            }
            group("group49")
            {

                CaptionML = ENU = 'Production', ESP = 'Producci�n';
                group("group50")
                {

                    group("group51")
                    {

                        CaptionML = ENU = 'Amount', ESP = 'Importes';
                        field("InvoicedSTD"; InvoicedSTD)
                        {

                            CaptionML = ENU = 'Standard Invoice', ESP = 'Facturas est�ndar';

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowInvoiced(OptTypeInvoiced::Standar);
                            END;


                        }
                        field("InvoicedStore"; InvoicedStore)
                        {

                            CaptionML = ENU = 'Store', ESP = 'Acopios';

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowInvoiced(OptTypeInvoiced::"Advance by Store");
                            END;


                        }
                        field("InvoicedEquipament"; InvoicedEquipament)
                        {

                            CaptionML = ENU = 'Equipament', ESP = 'Maquinaria';

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowInvoiced(OptTypeInvoiced::"Equipament Advance");
                            END;


                        }
                        field("InvoicedCheckPrice"; InvoicedCheckPrice)
                        {

                            CaptionML = ENU = 'Check Price', ESP = 'Revisi�n precios';

                            ; trigger OnDrillDown()
                            BEGIN
                                ShowInvoiced(OptTypeInvoiced::PriceReview);
                            END;


                        }
                        field("Invoiced (LCY)"; rec."Invoiced (LCY)")
                        {

                            CaptionML = ENU = 'Invoiced', ESP = 'Facturado total (DL)';
                            Style = Standard;
                            StyleExpr = TRUE;
                        }
                        field("Text001"; Text001)
                        {

                            Visible = False;
                        }
                        field("Job in Progress (LCY)"; rec."Job in Progress (LCY)")
                        {

                        }
                        field("Actual Production Amount"; rec."Actual Production Amount")
                        {

                        }

                    }

                }

            }

        }
    }
    trigger OnAfterGetCurrRecord()
    BEGIN
        Rec.SETRANGE("Reestimation Filter", rec."Latest Reestimation Code");
        Rec.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Advance by Store");
        Rec.CALCFIELDS("Invoiced (LCY)");
        InvoicedStore := rec."Invoiced (LCY)";

        Rec.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Eqipament Advance");
        Rec.CALCFIELDS("Invoiced (LCY)");
        InvoicedEquipament := rec."Invoiced (LCY)";

        Rec.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Price Review");
        Rec.CALCFIELDS("Invoiced (LCY)");
        InvoicedCheckPrice := rec."Invoiced (LCY)";

        Rec.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::Standar);
        Rec.CALCFIELDS("Invoiced (LCY)");
        InvoicedSTD := rec."Invoiced (LCY)";

        Rec.SETRANGE("Job Sales Doc Type Filter");
        Rec.CALCFIELDS("Invoiced (LCY)");

        QBTableSubscriber.TJob_CalMarginRealized(Rec, MarginRealized, MarginRealizedPorc);
    END;



    var
        Text001: TextConst ENU = 'Placeholder', ESP = 'Marcador de posici�n';
        Text19037728: TextConst ENU = 'Data per piecework', ESP = 'Datos por unidades de obra';
        QBTableSubscriber: Codeunit 7207347;
        InvoicedSTD: Decimal;
        InvoicedStore: Decimal;
        InvoicedEquipament: Decimal;
        InvoicedCheckPrice: Decimal;
        OptTypeInvoiced: Option "Standar","PriceReview","Equipament Advance","Advance by Store";
        MarginRealized: Decimal;
        MarginRealizedPorc: Decimal;

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

    procedure "FHP---------------------------"();
    begin
    end;

    procedure ShowAmountShipmentPendingPurchaseNormal();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETCURRENTKEY("Job No.", "Document No.");
        PurchRcptLine.SETRANGE(PurchRcptLine."Job No.", rec."No.");
        PurchRcptLine.SETRANGE(PurchRcptLine."Received on FRI", FALSE);
        if PurchRcptLine.FINDSET then
            repeat
                PurchRcptLine.MARK(TRUE);
            until PurchRcptLine.NEXT = 0;
        PurchRcptLine.SETRANGE(PurchRcptLine."Received on FRI", TRUE);
        PurchRcptLine.SETRANGE(Accounted, FALSE);
        if PurchRcptLine.FINDSET then
            repeat
                PurchRcptLine.MARK(TRUE);
            until PurchRcptLine.NEXT = 0;

        PurchRcptLine.SETCURRENTKEY("Document No.", "Line No.");
        PurchRcptLine.SETRANGE(Accounted);
        PurchRcptLine.MARKEDONLY(TRUE);
        PAGE.RUN(0, PurchRcptLine);
    end;

    procedure ShowAmountShipmentPendingPurchaseFRIS();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETCURRENTKEY("Job No.", "Document No.");
        PurchRcptLine.SETRANGE(PurchRcptLine."Job No.", rec."No.");
        PurchRcptLine.SETRANGE(PurchRcptLine."Received on FRI", TRUE);
        PurchRcptLine.SETRANGE(Accounted, TRUE);
        PAGE.RUN(0, PurchRcptLine);
    end;

    procedure ShowInvoiced(parOptTypeInvoiced: Option "Standar","PriceReview","Equipament Advance","Advance by Store");
    var
        JobLedgerEntry: Record 169;
    begin
        JobLedgerEntry.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", "Job in progress", "Job Sale Doc. Type");
        JobLedgerEntry.SETRANGE("Job No.", rec."No.");
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Sale);
        Rec.COPYFILTER("Posting Date Filter", JobLedgerEntry."Posting Date");
        JobLedgerEntry.SETRANGE("Job in progress", FALSE);
        JobLedgerEntry.SETRANGE("Job Sale Doc. Type", parOptTypeInvoiced);
        PAGE.RUN(0, JobLedgerEntry);
    end;

    // begin//end
}








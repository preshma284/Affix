page 7207622 "Seg. Piecework Data Ex. FB"
{
    CaptionML = ENU = 'Seg. iecework Data Ex. FB', ESP = 'Datos de ejecuci�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Production Unit" = CONST(true), "Type" = FILTER("Piecework" | "Cost Unit"));
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field("Amount Production Performed"; rec."Amount Production Performed")
            {

            }
            field("Advance*100"; Advance * 100)
            {

                ExtendedDatatype = Ratio;
                CaptionML = ENU = '% Advance', ESP = '% Avance';
            }
            group("group44")
            {

                CaptionML = ENU = 'Execution Data', ESP = 'Datos de ejecuci�n';
                field("Amount Cost Performed (JC)"; rec."Amount Cost Performed (JC)")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amount Production Performed-Amount Cost Performed (JC)"; rec."Amount Production Performed" - rec."Amount Cost Performed (JC)")
                {

                    CaptionML = ENU = 'Margin Real', ESP = 'Margen real';
                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("CalculateMarginRealPercentage"; rec."CalculateMarginRealPercentage")
                {

                    CaptionML = ENU = '% Margin Real', ESP = '% Margen Real';
                    Editable = False;
                    Style = StrongAccent;
                    StyleExpr = TRUE

  ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        JobinProgress := Rec.GETFILTER("Job No.");
        BudgetInProgress := Rec.GETFILTER("Budget Filter");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget", "Budget Measure", "Total Measurement Production",
        rec."Amount Production Performed", "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");

        DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        DataPieceworkForProduction.COPYFILTERS(Rec);
        Job.GET(rec."Job No.");
        DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");

        Advance := DataPieceworkForProduction.AdvanceProductionPercentage;
    END;



    var
        // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
        PeriodType: Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";
        JobinProgress: Code[20];
        BudgetInProgress: Code[20];
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        Advance: Decimal;

    LOCAL procedure FindPeriod(SearchText: Code[10]);
    var
        Calendar: Record 2000000007;
        AccountingPeriod: Record 50;
        PeriodFormMgt: Codeunit 50324;
    begin
        if Rec.GETFILTER("Filter Date") <> '' then begin
            Calendar.SETFILTER("Period Start", rec.GETFILTER("Filter Date"));
            if not PeriodFormMgt.FindDate('+', Calendar, PeriodType) then
                PeriodFormMgt.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SETRANGE("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText, Calendar, PeriodType);
        if AmountType = AmountType::"Net Change" then
            if Calendar."Period Start" = Calendar."Period end" then
                Rec.SETRANGE("Filter Date", Calendar."Period Start")
            ELSE
                Rec.SETRANGE("Filter Date", Calendar."Period Start", Calendar."Period end")
        ELSE
            Rec.SETRANGE("Filter Date", 0D, Calendar."Period end");
    end;

    procedure AmountTotal(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        VAmount: Decimal;
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Filter Date", rec.GETFILTER("Filter Date"));
        DataPieceworkForProduction.SETFILTER("Budget Filter", rec.GETFILTER("Budget Filter"));
        if DataPieceworkForProduction.FINDSET then begin
            repeat
                DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Amount Production Budget");
                VAmount += DataPieceworkForProduction."Amount Production Budget";
            until DataPieceworkForProduction.NEXT = 0;
        end;
        exit(VAmount);
    end;

    procedure CostTotal(): Decimal;
    var
        VCost: Decimal;
        DataPieceworkForProduction: Record 7207386;
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Filter Date", rec.GETFILTER("Filter Date"));
        DataPieceworkForProduction.SETFILTER("Budget Filter", rec.GETFILTER("Budget Filter"));
        if DataPieceworkForProduction.FINDSET then begin
            repeat
                DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                VCost += DataPieceworkForProduction."Amount Cost Budget (JC)";
            until DataPieceworkForProduction.NEXT = 0;
        end;
        exit(VCost);
    end;

    procedure Difference(): Decimal;
    var
        VAmount: Decimal;
        VCost: Decimal;
    begin
        exit(AmountTotal - CostTotal);
    end;

    procedure AmountProductionReal(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        VAmount: Decimal;
        Job: Record 167;
    begin
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Actual Production Amount");
        exit(Job."Actual Production Amount");
    end;

    procedure AmountCostReal(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        VAmount: Decimal;
        Job: Record 167;
    begin
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Usage (Cost) (LCY)");
        exit(Job."Usage (Cost) (LCY)");
    end;

    procedure DifferenceReal(): Decimal;
    var
        varImp: Decimal;
        varCost: Decimal;
    begin
        exit(AmountProductionReal - AmountCostReal);
    end;

    procedure ShowMeaureSubcontrating();
    var
        PurchRcptLine: Record 121;
        LDataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Unit then begin
            PurchRcptLine.RESET;
            PurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");
            PurchRcptLine.SETRANGE("Job No.", rec."Job No.");
            PurchRcptLine.SETRANGE("Piecework NÂº", rec."Piecework Code");
            // PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::"6");
            PurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
            PurchRcptLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", PurchRcptLine."Order Date");
            PAGE.RUNMODAL(0, PurchRcptLine);
        end ELSE begin
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");
                    PurchRcptLine.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                    PurchRcptLine.SETRANGE("Piecework NÂº", LDataPieceworkForProduction."Piecework Code");
                    // PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::"6");
                    PurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
                    PurchRcptLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", PurchRcptLine."Order Date");
                    if PurchRcptLine.FINDSET then begin
                        repeat
                            PurchRcptLine.MARK(TRUE);
                        until PurchRcptLine.NEXT = 0;
                    end;

                until LDataPieceworkForProduction.NEXT = 0;
            PurchRcptLine.SETRANGE("Job No.");
            PurchRcptLine.SETRANGE("Piecework NÂº");
            PurchRcptLine.SETRANGE(Type);
            PurchRcptLine.SETRANGE("No.");
            PurchRcptLine.SETRANGE("Order Date");
            PurchRcptLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, PurchRcptLine);
        end;
    end;

    procedure ShowInvoicedSubcontrating();
    var
        LPurchRcptLine: Record 121;
        LDataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Unit then begin
            LPurchRcptLine.RESET;
            LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Expected Receipt Date");
            LPurchRcptLine.SETRANGE("Job No.", rec."Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº", rec."Piecework Code");
            // LPurchRcptLine.SETRANGE(Type, LPurchRcptLine.Type::"6");
            LPurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
            LPurchRcptLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", LPurchRcptLine."Expected Receipt Date");
            PAGE.RUNMODAL(0, LPurchRcptLine);
        end ELSE begin
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LPurchRcptLine.RESET;
                    LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Expected Receipt Date");
                    LPurchRcptLine.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                    LPurchRcptLine.SETRANGE("Piecework NÂº", LDataPieceworkForProduction."Piecework Code");
                    // LPurchRcptLine.SETRANGE(Type, LPurchRcptLine.Type::"6");
                    LPurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
                    LPurchRcptLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", LPurchRcptLine."Expected Receipt Date");
                    if LPurchRcptLine.FINDSET then begin
                        repeat
                            LPurchRcptLine.MARK(TRUE);
                        until LPurchRcptLine.NEXT = 0;
                    end;

                until LDataPieceworkForProduction.NEXT = 0;
            LPurchRcptLine.SETRANGE("Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº");
            LPurchRcptLine.SETRANGE(Type);
            LPurchRcptLine.SETRANGE("No.");
            LPurchRcptLine.SETRANGE("Expected Receipt Date");
            LPurchRcptLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, LPurchRcptLine);
        end;
    end;

    procedure ShowCreditMemoSubcontrating();
    var
        LPurchRcptLine: Record 121;
        LDataPieceworkForProduction: Record 7207386;
    begin

        if rec."Account Type" = rec."Account Type"::Unit then begin
            LPurchRcptLine.RESET;
            LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Expected Receipt Date");
            LPurchRcptLine.SETRANGE("Job No.", rec."Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº", rec."Piecework Code");
            // LPurchRcptLine.SETRANGE(Type, LPurchRcptLine.Type::"6");
            LPurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
            LPurchRcptLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", LPurchRcptLine."Expected Receipt Date");
            PAGE.RUNMODAL(0, LPurchRcptLine);
        end ELSE begin
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LPurchRcptLine.RESET;
                    LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Expected Receipt Date");
                    LPurchRcptLine.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                    LPurchRcptLine.SETRANGE("Piecework NÂº", LDataPieceworkForProduction."Piecework Code");
                    // LPurchRcptLine.SETRANGE(Type, LPurchRcptLine.Type::"6");
                    LPurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
                    LPurchRcptLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", LPurchRcptLine."Expected Receipt Date");
                    if LPurchRcptLine.FINDSET then begin
                        repeat
                            LPurchRcptLine.MARK(TRUE);
                        until LPurchRcptLine.NEXT = 0;
                    end;

                until LDataPieceworkForProduction.NEXT = 0;
            LPurchRcptLine.SETRANGE("Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº");
            LPurchRcptLine.SETRANGE(Type);
            LPurchRcptLine.SETRANGE("No.");
            LPurchRcptLine.SETRANGE("Expected Receipt Date");
            LPurchRcptLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, LPurchRcptLine);
        end;
    end;

    // begin//end
}








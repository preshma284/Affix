page 7207592 "Certification Tracking"
{
    CaptionML = ENU = 'Certification Tracking', ESP = 'Seguimiento Certificaci�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Customer Certification Unit" = CONST(true));
    PageType = List;

    layout
    {
        area(content)
        {
            group("group9")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("FORMAT (txtJobDescription)"; FORMAT(txtJobDescription))
                {

                    CaptionClass = FORMAT(txtJobDescription);
                    Editable = FALSE;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }

            }
            group("group11")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'View by', ESP = 'Ver por';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'View by', ESP = 'Ver por';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF PeriodType = PeriodType::"Accounting Period" THEN
                            AccountingPerioPeriodTypeOnVal;
                        IF PeriodType = PeriodType::Year THEN
                            YearPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Quarter THEN
                            QuarterPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Month THEN
                            MonthPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Week THEN
                            WeekPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Day THEN
                            DayPeriodTypeOnValidate;
                    END;


                }
                field("AmountType"; AmountType)
                {

                    CaptionML = ENU = 'View as', ESP = 'Ver como';
                    ToolTipML = ENU = 'Net Change', ESP = 'Saldo periodo';
                    OptionCaptionML = ENU = 'View as', ESP = 'Ver como';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF AmountType = AmountType::"Balance at Date" THEN
                            BalanceatDateAmountTypeOnValid;
                        IF AmountType = AmountType::"Net Change" THEN
                            NetChangeAmountTypeOnValidate;
                    END;


                }

            }
            repeater("table")
            {

                Editable = FALSE;
                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code";
                ShowAsTree = true;
                FreezeColumn = "Descripcion";
                field("Piecework Code"; rec."Piecework Code")
                {

                    CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = booEmphasize;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    StyleExpr = booEmphasize;
                }
                field("Descripcion"; rec."Description")
                {

                    CaptionML = ENU = 'PieceWork', ESP = 'Unidad de Obra';
                    Editable = FALSE;
                    Style = Standard;
                    StyleExpr = booEmphasize;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    DecimalPlaces = 2 : 4;
                }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                }
                field("Sale Amount"; rec."Sale Amount")
                {

                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("Quantity in Measurements"; rec."Quantity in Measurements")
                {

                    Visible = FALSE;
                }
                field("Certified Quantity"; rec."Certified Quantity")
                {

                    Style = Standard;
                    StyleExpr = booEmphasize;
                }
                field("Certified Amount"; rec."Certified Amount")
                {

                }
                field("AdvanceCertificationsPercentage"; rec."AdvanceCertificationsPercentage")
                {

                    CaptionML = ENU = '% Advance Certif', ESP = '% Avance Certif';
                }
                field("AdvanceCertificationsPercentage * 100"; rec.AdvanceCertificationsPercentage * 100)
                {

                    ExtendedDatatype = Ratio;
                    CaptionML = ENU = 'Advance certification', ESP = 'Avance certificaci�n';
                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                    Visible = FALSE;
                }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    Editable = false;
                }
                field("Amount Sale Performed (JC)"; rec."Amount Sale Performed (JC)")
                {

                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("Total Measurement Production"; rec."Total Measurement Production")
                {

                }
                field("Importe Produccion realizada"; rec."RealizedProduction")
                {

                    CaptionML = ENU = 'Realized production', ESP = 'Produccion realizada';
                    Style = Standard;
                    StyleExpr = booEmphasize;
                }
                field("ProductionAdvancePercentage"; rec."ProductionAdvancePercentage")
                {

                    CaptionML = ENU = '%Advance Product', ESP = '%Avance Producc';
                }
                field("ProductionAdvancePercentage * 100"; rec.ProductionAdvancePercentage * 100)
                {

                    ExtendedDatatype = Ratio;
                    CaptionML = ENU = 'Advance production', ESP = 'Avance producci�n';
                }
                field("Diferencia"; rec."Certified Amount" - rec.RealizedProduction)
                {

                    CaptionML = ENU = 'Difference about certf.', ESP = 'Diferencia Certf./Prod.';
                    Style = StrongAccent;
                    StyleExpr = booEmphasize;
                }

            }
            group("group35")
            {

                group("group36")
                {

                    CaptionML = ESP = 'Importe total certificado';
                    field("TotalCertification_"; TotalCertification)
                    {

                        Style = Strong;
                        StyleExpr = TRUE;
                    }

                }
                group("group38")
                {

                    CaptionML = ESP = 'Importe Produccion realizada';
                    field("TotalProduction_"; TotalProduction)
                    {

                        CaptionML = ENU = 'Realized production amount', ESP = 'Importe Produccion realizada';
                        Style = Strong;
                        StyleExpr = TRUE;
                    }

                }
                group("group40")
                {

                    CaptionML = ESP = 'Diferencia';
                    field("Difference_"; Difference)
                    {

                        CaptionML = ENU = 'Difference', ESP = 'Diferencia';
                        Style = Strong;
                        StyleExpr = TRUE

  ;
                    }

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
                CaptionML = ENU = 'PieceWork', ESP = 'Unidad Obra';
                action("action1")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    RunObject = Page 92;
                    RunPageView = SORTING("Entry Type", "Job No.", "Piecework No.", "Type", "No.");
                    RunPageLink = "Job No." = FIELD("Job No."), "Piecework No." = FIELD("Piecework Code");
                    Image = JobLedger;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Piecework A&nalytics', ESP = 'A&nal�tica Unidad obra';
                    RunObject = Page 7207560;
                    RunPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Filter Date" = FIELD("Filter Date"), "Budget Filter" = FIELD("Budget Filter");
                    Image = InsertStartingFee;
                }

            }

        }
        area(Processing)
        {

            action("action3")
            {
                CaptionML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                ToolTipML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                Image = PreviousRecord;

                trigger OnAction()
                BEGIN
                    FindPeriod('<=');
                END;


            }
            action("action4")
            {
                CaptionML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                ToolTipML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                Image = NextRecord;


                trigger OnAction()
                BEGIN
                    FindPeriod('>=');
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action2_Promoted; action2)
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
        AmountType := AmountType::"Balance at Date";
        FindPeriod('');

        txtJobDescription := '';
        IF Rec.GETFILTER("Job No.") <> '' THEN
            txtJobDescription := FunctionQB.ShowDescriptionJob(Rec.GETFILTER("Job No."));
    END;

    trigger OnAfterGetRecord()
    BEGIN
        DescriptionIndent := 0;

        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget", "Budget Measure", "Total Measurement Production",
                    rec."Amount Production Budget", "Amount Cost Budget (JC)");
        //FieldsOnFormat;
        OnFormatCodePiecework;
        OnFormatDescription;
    END;



    var
        AmountType: Option "Net Change","Balance at Date";
        txtJobDescription: Text[250];
        FunctionQB: Codeunit 7207272;
        DescriptionIndent: Integer;
        // PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        PeriodType: Enum "Analysis Period Type";
        booEmphasize: Boolean;
        DescriptionEmphasize: Boolean;
        PieceworkCode: Boolean;

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

    procedure TotalCertification(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        varImp: Decimal;
        Job: Record 167;
    begin
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Certification Amount");
        exit(Job."Certification Amount");
    end;

    procedure TotalProduction(): Decimal;
    var
        varCost: Decimal;
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
    begin
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Actual Production Amount");
        exit(Job."Actual Production Amount");
    end;

    procedure Difference(): Decimal;
    var
        varImp: Decimal;
        varCost: Decimal;
    begin
        exit(TotalCertification - TotalProduction);
    end;

    procedure ShowMeasuredSubcontract();
    var
        PurchRcptLine: Record 121;
        DataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Unit then begin
            PurchRcptLine.RESET;
            PurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");
            PurchRcptLine.SETRANGE("Job No.", rec."Job No.");
            PurchRcptLine.SETRANGE("Piecework NÂº", rec."Piecework Code");
            PurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
            PurchRcptLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", PurchRcptLine."Order Date");
            PAGE.RUNMODAL(0, PurchRcptLine);
        end ELSE begin
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            //DataPieceworkForProduction.SETFILTER("Piecework Code",Totaling);
            if DataPieceworkForProduction.FINDSET then
                repeat
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");
                    PurchRcptLine.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                    PurchRcptLine.SETRANGE("Piecework NÂº", DataPieceworkForProduction."Piecework Code");
                    PurchRcptLine.SETRANGE(Type, "Purchase Line Type".FromInteger(6));
                    PurchRcptLine.SETRANGE("No.", DataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", PurchRcptLine."Order Date");
                    if PurchRcptLine.FINDSET then begin
                        repeat
                            PurchRcptLine.MARK(TRUE);
                        until PurchRcptLine.NEXT = 0;
                    end;

                until DataPieceworkForProduction.NEXT = 0;
            PurchRcptLine.SETRANGE("Job No.");
            PurchRcptLine.SETRANGE("Piecework NÂº");
            PurchRcptLine.SETRANGE(Type);
            PurchRcptLine.SETRANGE("No.");
            PurchRcptLine.SETRANGE("Order Date");
            PurchRcptLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, PurchRcptLine);
        end;
    end;

    procedure ShowSubcontractInvoice();
    var
        PurchInvLine: Record 123;
        DataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Unit then begin
            PurchInvLine.RESET;
            PurchInvLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
            PurchInvLine.SETRANGE("Job No.", rec."Job No.");
            PurchInvLine.SETRANGE("Piecework No.", rec."Piecework Code");
            PurchInvLine.SETRANGE(Type, PurchInvLine.Type::Resource);
            PurchInvLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", PurchInvLine."Expected Receipt Date");
            PAGE.RUNMODAL(0, PurchInvLine);
        end ELSE begin
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            DataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if DataPieceworkForProduction.FINDSET then
                repeat
                    PurchInvLine.RESET;
                    PurchInvLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
                    PurchInvLine.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                    PurchInvLine.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                    PurchInvLine.SETRANGE(Type, PurchInvLine.Type::Resource);
                    PurchInvLine.SETRANGE("No.", DataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", PurchInvLine."Expected Receipt Date");
                    if PurchInvLine.FINDSET then begin
                        repeat
                            PurchInvLine.MARK(TRUE);
                        until PurchInvLine.NEXT = 0;
                    end;

                until DataPieceworkForProduction.NEXT = 0;
            PurchInvLine.SETRANGE("Job No.");
            PurchInvLine.SETRANGE("Piecework No.");
            PurchInvLine.SETRANGE(Type);
            PurchInvLine.SETRANGE("No.");
            PurchInvLine.SETRANGE("Expected Receipt Date");
            PurchInvLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, PurchInvLine);
        end;
    end;

    procedure ShowSubcontractCrMemo();
    var
        PurchCrMemoLine: Record 125;
        DataPieceworkForProduction: Record 7207386;
    begin

        if rec."Account Type" = rec."Account Type"::Unit then begin
            PurchCrMemoLine.RESET;
            PurchCrMemoLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
            PurchCrMemoLine.SETRANGE("Job No.", rec."Job No.");
            PurchCrMemoLine.SETRANGE("Piecework No.", rec."Piecework Code");
            PurchCrMemoLine.SETRANGE(Type, PurchCrMemoLine.Type::Resource);
            PurchCrMemoLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", PurchCrMemoLine."Expected Receipt Date");
            PAGE.RUNMODAL(0, PurchCrMemoLine);
        end ELSE begin
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            DataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if DataPieceworkForProduction.FINDSET then
                repeat
                    PurchCrMemoLine.RESET;
                    PurchCrMemoLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
                    PurchCrMemoLine.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                    PurchCrMemoLine.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                    PurchCrMemoLine.SETRANGE(Type, PurchCrMemoLine.Type::Resource);
                    PurchCrMemoLine.SETRANGE("No.", DataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", PurchCrMemoLine."Expected Receipt Date");
                    if PurchCrMemoLine.FINDSET then begin
                        repeat
                            PurchCrMemoLine.MARK(TRUE);
                        until PurchCrMemoLine.NEXT = 0;
                    end;

                until DataPieceworkForProduction.NEXT = 0;
            PurchCrMemoLine.SETRANGE("Job No.");
            PurchCrMemoLine.SETRANGE("Piecework No.");
            PurchCrMemoLine.SETRANGE(Type);
            PurchCrMemoLine.SETRANGE("No.");
            PurchCrMemoLine.SETRANGE("Expected Receipt Date");
            PurchCrMemoLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, PurchCrMemoLine);
        end;
    end;

    LOCAL procedure ClosingEntryFilterOnAfterValid();
    begin
        CurrPage.UPDATE;
    end;

    LOCAL procedure DayPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure WeekPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure MonthPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure QuarterPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure YearPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure AccountingPerioPeriodTypOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
        FindPeriod('');
    end;

    procedure FieldsOnFormat();
    begin
        DescriptionIndent := rec.Indentation;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            booEmphasize := TRUE;
        end;
    end;

    LOCAL procedure DayPeriodTypeOnValidate();
    begin
        DayPeriodTypeOnPush;
    end;

    LOCAL procedure WeekPeriodTypeOnValidate();
    begin
        WeekPeriodTypeOnPush;
    end;

    LOCAL procedure MonthPeriodTypeOnValidate();
    begin
        MonthPeriodTypeOnPush;
    end;

    LOCAL procedure QuarterPeriodTypeOnValidate();
    begin
        QuarterPeriodTypeOnPush;
    end;

    LOCAL procedure YearPeriodTypeOnValidate();
    begin
        YearPeriodTypeOnPush;
    end;

    LOCAL procedure AccountingPerioPeriodTypeOnVal();
    begin
        AccountingPerioPeriodTypOnPush;
    end;

    LOCAL procedure NetChangeAmountTypeOnValidate();
    begin
        NetChangeAmountTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnValid();
    begin
        BalanceatDateAmountTypeOnPush;
    end;

    LOCAL procedure OnFormatDescription();
    begin
        DescriptionIndent := rec.Indentation * 220;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DescriptionEmphasize := TRUE;
        end;
    end;

    LOCAL procedure OnFormatCodePiecework();
    begin
        PieceworkCode := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    // begin//end
}








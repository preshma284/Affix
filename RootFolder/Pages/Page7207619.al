page 7207619 "Piecework Planning Matrix"
{
    CaptionML = ENU = 'Piecework Planning Matrix', ESP = 'Matriz planificaci�n unidad de obra';
    InsertAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Production Unit" = CONST(true));
    PageType = List;

    layout
    {
        area(content)
        {
            group("group106")
            {

                field("FiltroValor"; OptionValueOption)
                {

                    CaptionML = ENU = 'Value Filter', ESP = 'Filtro Valor';
                    OptionCaptionML = ENU = 'Value Filter', ESP = 'Filtro Valor';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }

            }
            repeater("table")
            {

                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                FreezeColumn = "Budget Measure";
                field("Piecework Code"; rec."Piecework Code")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Budget Measure"; rec."Budget Measure")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Field1"; MATRIX_CellData[1])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(1);
                    END;


                }
                field("Field2"; MATRIX_CellData[2])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(2);
                    END;


                }
                field("Field3"; MATRIX_CellData[3])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(3);
                    END;


                }
                field("Field4"; MATRIX_CellData[4])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(4);
                    END;


                }
                field("Field5"; MATRIX_CellData[5])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(5);
                    END;


                }
                field("Field6"; MATRIX_CellData[6])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(6);
                    END;


                }
                field("Field7"; MATRIX_CellData[7])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(7);
                    END;


                }
                field("Field8"; MATRIX_CellData[8])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(8);
                    END;


                }
                field("Field9"; MATRIX_CellData[9])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(9);
                    END;


                }
                field("Field10"; MATRIX_CellData[10])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(10);
                    END;


                }
                field("Field11"; MATRIX_CellData[11])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(11);
                    END;


                }
                field("Field12"; MATRIX_CellData[12])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(12);
                    END;


                }
                field("Field13"; MATRIX_CellData[13])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(13);
                    END;


                }
                field("Field14"; MATRIX_CellData[14])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(14);
                    END;


                }
                field("Field15"; MATRIX_CellData[15])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(15);
                    END;


                }
                field("Field16"; MATRIX_CellData[16])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(16);
                    END;


                }
                field("Field17"; MATRIX_CellData[17])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(17);
                    END;


                }
                field("Field18"; MATRIX_CellData[18])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(18);
                    END;


                }
                field("Field19"; MATRIX_CellData[19])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(19);
                    END;


                }
                field("Field20"; MATRIX_CellData[20])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(20);
                    END;


                }
                field("Field21"; MATRIX_CellData[21])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(21);
                    END;


                }
                field("Field22"; MATRIX_CellData[22])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(22);
                    END;


                }
                field("Field23"; MATRIX_CellData[23])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(23);
                    END;


                }
                field("Field24"; MATRIX_CellData[24])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(24);
                    END;


                }
                field("Field25"; MATRIX_CellData[25])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(25);
                    END;


                }
                field("Field26"; MATRIX_CellData[26])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(26);
                    END;


                }
                field("Field27"; MATRIX_CellData[27])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(27);
                    END;


                }
                field("Field28"; MATRIX_CellData[28])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(28);
                    END;


                }
                field("Field29"; MATRIX_CellData[29])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(29);
                    END;


                }
                field("Field30"; MATRIX_CellData[30])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(30);
                    END;


                }
                field("Field31"; MATRIX_CellData[31])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(31);
                    END;


                }
                field("Field32"; MATRIX_CellData[32])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];



                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(32);
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        OptionValueOption := OptionValueOption::Quantity;
    END;

    trigger OnAfterGetRecord()
    VAR
        MATRIX_CurrentColumnOrdinal: Integer;
        MATRIX_NoOfColumns: Integer;
    BEGIN
        DescriptionIndent := 0;
        MATRIX_CurrentColumnOrdinal := 1;
        MATRIX_NoOfColumns := ARRAYLEN(MATRIX_CellData);

        WHILE (MATRIX_CurrentColumnOrdinal <= MATRIX_NoOfColumns) DO BEGIN
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
        END;
        C243dPieceworkOnFormat;
        Description243nOnFormat;

        Rec.SETRANGE("Filter Date");
        Rec.SETFILTER("Job No.", CodJob);
        Rec.SETFILTER("Budget Filter", BudgetFilter);
        Rec.CALCFIELDS("Budget Measure", "Amount Cost Budget (JC)", "Amount Production Budget");
    END;



    var
        Date1: ARRAY[32] OF Record 2000000007;
        AmountType: Option "Net Change","Balance at Date";
        OptionValueOption: Option Quantity,Expenses,Incomes;
        MATRIX_CellData: ARRAY[32] OF Decimal;
        MATRIX_ColumnCaption: ARRAY[32] OF Text[1024];
        ExpectedTimeUnitData: Record 7207388;
        ForecastDataAmountPiecework: Record 7207392;
        PieceworkEmphasize: Boolean;
        DescriptionEmphasize: Boolean;
        DescriptionIndent: Integer;
        CodJob: Code[20];
        BudgetFilter: Code[20];

    LOCAL procedure SetDateFilter(ColumnID: Integer);
    begin
        if AmountType = AmountType::"Net Change" then
            if Date1[ColumnID]."Period Start" = Date1[ColumnID]."Period end" then
                Rec.SETRANGE("Filter Date", Date1[ColumnID]."Period Start")
            ELSE
                Rec.SETRANGE("Filter Date", Date1[ColumnID]."Period Start", Date1[ColumnID]."Period end")
        ELSE
            Rec.SETRANGE("Filter Date", 0D, Date1[ColumnID]."Period end");
    end;

    procedure Load(var MatrixColumns1: ARRAY[32] OF Text[1024]; var MatrixRecords1: ARRAY[32] OF Record 2000000007; AmountType1: Option "Net Change","Balance at Date"; CodJob1: Code[20]; BudgetFilter1: Code[20]);
    begin
        COPYARRAY(MATRIX_ColumnCaption, MatrixColumns1, 1);
        COPYARRAY(Date1, MatrixRecords1, 1);
        AmountType := AmountType1;
        CodJob := CodJob1;
        BudgetFilter := BudgetFilter1;
    end;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
        CASE OptionValueOption OF
            OptionValueOption::Quantity:
                begin
                    ExpectedTimeUnitData.RESET;
                    ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
                    ExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
                    if rec."Account Type" = rec."Account Type"::Unit then
                        ExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code")
                    ELSE
                        ExpectedTimeUnitData.SETFILTER("Piecework Code", rec.Totaling);
                    ExpectedTimeUnitData.SETFILTER("Budget Code", rec.GETFILTER("Budget Filter"));
                    ExpectedTimeUnitData.SETFILTER("Expected Date", rec.GETFILTER("Filter Date"));
                    PAGE.RUNMODAL(PAGE::Estimate, ExpectedTimeUnitData);
                end;
            OptionValueOption::Expenses:
                begin
                    ForecastDataAmountPiecework.RESET;
                    ForecastDataAmountPiecework.SETCURRENTKEY("Entry Type", "Job No.", "Piecework Code", "Cod. Budget", "Analytical Concept", "Expected Date");
                    ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                    ForecastDataAmountPiecework.SETRANGE("Job No.", rec."Job No.");
                    if rec."Account Type" = rec."Account Type"::Unit then
                        ForecastDataAmountPiecework.SETRANGE("Piecework Code", rec."Piecework Code")
                    ELSE
                        ForecastDataAmountPiecework.SETFILTER("Piecework Code", rec.Totaling);
                    ForecastDataAmountPiecework.SETFILTER("Cod. Budget", rec.GETFILTER("Budget Filter"));
                    ForecastDataAmountPiecework.SETFILTER("Expected Date", rec.GETFILTER("Filter Date"));
                    PAGE.RUNMODAL(PAGE::"Piecework Amount Planning", ForecastDataAmountPiecework);
                end;
            OptionValueOption::Incomes:
                begin
                    ForecastDataAmountPiecework.RESET;
                    ForecastDataAmountPiecework.SETCURRENTKEY("Entry Type", "Job No.", "Piecework Code", "Cod. Budget", "Analytical Concept", "Expected Date");
                    ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Incomes);
                    ForecastDataAmountPiecework.SETRANGE("Job No.", rec."Job No.");
                    if rec."Account Type" = rec."Account Type"::Unit then
                        ForecastDataAmountPiecework.SETRANGE("Piecework Code", rec."Piecework Code")
                    ELSE
                        ForecastDataAmountPiecework.SETFILTER("Piecework Code", rec.Totaling);
                    ForecastDataAmountPiecework.SETFILTER("Cod. Budget", rec.GETFILTER("Budget Filter"));
                    ForecastDataAmountPiecework.SETFILTER("Expected Date", rec.GETFILTER("Filter Date"));
                    PAGE.RUNMODAL(PAGE::"Piecework Amount Planning", ForecastDataAmountPiecework);
                end;
        end;
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord(ColumnID: Integer);
    begin
        SetDateFilter(ColumnID);
        Rec.SETFILTER("Job No.", CodJob);
        Rec.SETFILTER("Budget Filter", BudgetFilter);
        Rec.CALCFIELDS("Budget Measure", "Amount Cost Budget (JC)", "Amount Production Budget");

        CASE OptionValueOption OF
            OptionValueOption::Quantity:
                MATRIX_CellData[ColumnID] := rec."Budget Measure";
            OptionValueOption::Expenses:
                MATRIX_CellData[ColumnID] := rec."Amount Cost Budget (JC)";
            OptionValueOption::Incomes:
                MATRIX_CellData[ColumnID] := rec."Amount Production Budget";
        end;
    end;

    LOCAL procedure C243dPieceworkOnFormat();
    begin
        PieceworkEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure Description243nOnFormat();
    begin
        DescriptionIndent := rec.Indentation;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DescriptionEmphasize := TRUE;
        end;
    end;

    // begin//end
}








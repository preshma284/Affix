page 7207483 "Budget by CA Matrix"
{
    CaptionML = ENU = 'Budget by CA Matrix', ESP = 'Matriz presupuesto por CA';
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    SourceTable = 367;
    DataCaptionExpression = BudgetName;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code"; rec."Code")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = Emphasize;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        LookUpCode(LineDimOption, LineDimCode, rec.Code);
                    END;


                }
                field("Name"; rec."Name")
                {

                    Editable = False;
                    Style = Standard;
                    StyleExpr = Emphasize;
                }
                field("TotalBudgetedAmount"; rec."Amount")
                {

                    BlankZero = true;
                    Editable = False;
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    BEGIN
                        SetCommonFilters(GLAccBudgetBuffer);
                        SetDimFilters(GLAccBudgetBuffer, 0);
                        BudgetDrillDown;
                    END;


                }
                field("Field1"; MATRIX_CellData[1])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];

                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(1);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(1);
                    END;


                }
                field("Field2"; MATRIX_CellData[2])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];

                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(2);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(2);
                    END;


                }
                field("Field3"; MATRIX_CellData[3])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(3);
                    END;


                }
                field("Field4"; MATRIX_CellData[4])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(4);
                    END;


                }
                field("Field5"; MATRIX_CellData[5])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(5);
                    END;


                }
                field("Field6"; MATRIX_CellData[6])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(6);
                    END;


                }
                field("Field7"; MATRIX_CellData[7])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];

                    ; trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(7);
                    END;


                }
                field("Field8"; MATRIX_CellData[8])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];

                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(8);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(8);
                    END;


                }
                field("Field9"; MATRIX_CellData[9])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];

                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(9);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(9);
                    END;


                }
                field("Field10"; MATRIX_CellData[10])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];

                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(10);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(10);
                    END;


                }
                field("Field11"; MATRIX_CellData[11])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];

                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(11);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(11);
                    END;


                }
                field("Field12"; MATRIX_CellData[12])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];



                    ; trigger OnValidate()
                    BEGIN
                        UpdateAmount(12);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(12);
                    END;


                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = 'Balance', ESP = '&Saldo';
                action("action1")
                {
                    CaptionML = ESP = 'G/L cuenta balance/&presupuesto';
                    Image = Period;


                    trigger OnAction()
                    BEGIN
                        GLAccountBalanceBudget;
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 05/08/19: - La funci�n Rec.SETPERMISSIONFILTER esta obsoleta
        //GLAccBudgetBuffer.SETPERMISSIONFILTER;

        IF GLAccBudgetBuffer.GETFILTER("Global Dimension 1 Filter") <> '' THEN
            GlobalDim1Filter := GLAccBudgetBuffer.GETFILTER("Global Dimension 1 Filter");
        IF GLAccBudgetBuffer.GETFILTER("Global Dimension 2 Filter") <> '' THEN
            GlobalDim2Filter := GLAccBudgetBuffer.GETFILTER("Global Dimension 2 Filter");

        GeneralLedgerSetup.GET;
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        EXIT(FindRec(LineDimOption, Rec, Which));
    END;

    trigger OnNextRecord(Steps: Integer): Integer
    BEGIN
        EXIT(NextRec(LineDimOption, Rec, Steps));
    END;

    trigger OnAfterGetRecord()
    VAR
        MATRIX_CurrentColumnOrdinal: Integer;
    BEGIN
        NameIndent := 0;
        FOR MATRIX_CurrentColumnOrdinal := 1 TO MATRIX_CurrentNoOfMatrixColumn DO
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        rec.Amount := ToRoundedValue(CalcAmount(FALSE));
        FormatLine;
    END;



    var
        BudgetName: Code[10];
        GLAccBudgetBuffer: Record 374;
        GlobalDim1Filter: Code[250];
        GlobalDim2Filter: Code[250];
        BudgetDim1Filter: Code[250];
        BudgetDim2Filter: Code[250];
        BudgetDim3Filter: Code[250];
        BudgetDim4Filter: Code[250];
        GeneralLedgerSetup: Record 98;
        Text001: TextConst ENU = 'Period', ESP = 'Periodo';
        Text002: TextConst ENU = 'You may only edit column 1 to %1.', ESP = 'S�lo puede editar la columna 1 a %1.';
        GLBudgetName: Record 95;
        GLAccFilter: Code[250];
        PeriodInitialized: Boolean;
        DateFilter: Text[30];
        InternalDateFilter: Text[30];
        // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
        PeriodType : Enum "Analysis Period Type";
        RoundingFactor: Option None,"1","1000","1000000";
        BusUnitFilter: Code[250];
        LineDimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        ColumnDimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        MATRIX_MatrixRecord: Record 367;
        TheGLAccBudgetBuffer: Record 374;
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MATRIX_CellData: ARRAY[12] OF Decimal;
        MATRIX_CaptionSet: ARRAY[12] OF Text[80];
        MatrixRecords: ARRAY[12] OF Record 367;
        LineDimCode: Text[30];
        ShowColumnName: Boolean;
        MatrixHeader: Text[50];
        Emphasize: Boolean;
        NameIndent: Integer;

    LOCAL procedure DimCodeToOption(DimCode: Text[30]): Integer;
    var
        BusUnit: Record 220;
        GLAcc: Record 15;
    begin
        CASE DimCode OF
            '':
                exit(-1);
            GLAcc.TABLECAPTION:
                exit(0);
            Text001:
                exit(1);
            BusUnit.TABLECAPTION:
                exit(2);
            GeneralLedgerSetup."Global Dimension 1 Code":
                exit(3);
            GeneralLedgerSetup."Global Dimension 2 Code":
                exit(4);
            GLBudgetName."Budget Dimension 1 Code":
                exit(5);
            GLBudgetName."Budget Dimension 2 Code":
                exit(6);
            GLBudgetName."Budget Dimension 3 Code":
                exit(7);
            GLBudgetName."Budget Dimension 4 Code":
                exit(8);
            ELSE
                exit(-1);
        end;
    end;

    LOCAL procedure FindRec(DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; var DimCodeBuf: Record 367; Which: Text[250]): Boolean;
    var
        GLAcc: Record 15;
        BusUnit: Record 220;
        Period: Record 2000000007;
        DimVal: Record 349;
        PeriodFormMgt: Codeunit 50324;
        Found: Boolean;
    begin
        CASE DimOption OF
            DimOption::"G/L Account":
                begin
                    GLAcc."No." := DimCodeBuf.Code;
                    if GLAccFilter <> '' then
                        GLAcc.SETFILTER("No.", GLAccFilter);
                    Found := GLAcc.FIND(Which);
                    if Found then
                        CopyGLAccToBuf(GLAcc, DimCodeBuf);
                end;
            DimOption::Period:
                begin
                    if not PeriodInitialized then
                        DateFilter := '';
                    PeriodInitialized := TRUE;
                    Period."Period Start" := DimCodeBuf."Period Start";
                    if DateFilter <> '' then
                        Period.SETFILTER("Period Start", DateFilter)
                    ELSE
                        if not PeriodInitialized and (InternalDateFilter <> '') then
                            Period.SETFILTER("Period Start", InternalDateFilter);
                    Found := PeriodFormMgt.FindDate(Which, Period, PeriodType);
                    if Found then
                        CopyPeriodToBuf(Period, DimCodeBuf);
                end;
            DimOption::"Business Unit":
                begin
                    BusUnit.Code := DimCodeBuf.Code;
                    if BusUnitFilter <> '' then
                        BusUnit.SETFILTER(Code, BusUnitFilter);
                    Found := BusUnit.FIND(Which);
                    if Found then
                        CopyBusUnitToBuf(BusUnit, DimCodeBuf);
                end;
            DimOption::"Global Dimension 1":
                begin
                    if GlobalDim1Filter <> '' then
                        DimVal.SETFILTER(Code, GlobalDim1Filter);
                    DimVal."Dimension Code" := GeneralLedgerSetup."Global Dimension 1 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    Found := DimVal.FIND(Which);
                    if Found then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Global Dimension 2":
                begin
                    if GlobalDim2Filter <> '' then
                        DimVal.SETFILTER(Code, GlobalDim2Filter);
                    DimVal."Dimension Code" := GeneralLedgerSetup."Global Dimension 2 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    Found := DimVal.FIND(Which);
                    if Found then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 1":
                begin
                    if BudgetDim1Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim1Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    Found := DimVal.FIND(Which);
                    if Found then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 2":
                begin
                    if BudgetDim2Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim2Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    Found := DimVal.FIND(Which);
                    if Found then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 3":
                begin
                    if BudgetDim3Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim3Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    Found := DimVal.FIND(Which);
                    if Found then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 4":
                begin
                    if BudgetDim4Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim4Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    Found := DimVal.FIND(Which);
                    if Found then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
        end;
        exit(Found);
    end;

    LOCAL procedure NextRec(DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; var DimCodeBuf: Record 367; Steps: Integer): Integer;
    var
        GLAcc: Record 15;
        BusUnit: Record 220;
        Period: Record 2000000007;
        DimVal: Record 349;
        PeriodFormMgt: Codeunit 50324;
        ResultSteps: Integer;
    begin
        CASE DimOption OF
            DimOption::"G/L Account":
                begin
                    GLAcc."No." := DimCodeBuf.Code;
                    if GLAccFilter <> '' then
                        GLAcc.SETFILTER("No.", GLAccFilter);
                    ResultSteps := GLAcc.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyGLAccToBuf(GLAcc, DimCodeBuf);
                end;
            DimOption::Period:
                begin
                    if DateFilter <> '' then
                        Period.SETFILTER("Period Start", DateFilter);
                    Period."Period Start" := DimCodeBuf."Period Start";
                    ResultSteps := PeriodFormMgt.NextDate(Steps, Period, PeriodType);
                    if ResultSteps <> 0 then
                        CopyPeriodToBuf(Period, DimCodeBuf);
                end;
            DimOption::"Business Unit":
                begin
                    BusUnit.Code := DimCodeBuf.Code;
                    if BusUnitFilter <> '' then
                        BusUnit.SETFILTER(Code, BusUnitFilter);
                    ResultSteps := BusUnit.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyBusUnitToBuf(BusUnit, DimCodeBuf);
                end;
            DimOption::"Global Dimension 1":
                begin
                    if GlobalDim1Filter <> '' then
                        DimVal.SETFILTER(Code, GlobalDim1Filter);
                    DimVal."Dimension Code" := GeneralLedgerSetup."Global Dimension 1 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    ResultSteps := DimVal.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Global Dimension 2":
                begin
                    if GlobalDim2Filter <> '' then
                        DimVal.SETFILTER(Code, GlobalDim2Filter);
                    DimVal."Dimension Code" := GeneralLedgerSetup."Global Dimension 2 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    ResultSteps := DimVal.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 1":
                begin
                    if BudgetDim1Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim1Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    ResultSteps := DimVal.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 2":
                begin
                    if BudgetDim2Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim2Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    ResultSteps := DimVal.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 3":
                begin
                    if BudgetDim3Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim3Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    ResultSteps := DimVal.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
            DimOption::"Budget Dimension 4":
                begin
                    if BudgetDim4Filter <> '' then
                        DimVal.SETFILTER(Code, BudgetDim4Filter);
                    DimVal."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
                    DimVal.SETRANGE("Dimension Code", DimVal."Dimension Code");
                    DimVal.Code := DimCodeBuf.Code;
                    ResultSteps := DimVal.NEXT(Steps);
                    if ResultSteps <> 0 then
                        CopyDimValToBuf(DimVal, DimCodeBuf);
                end;
        end;
        exit(ResultSteps);
    end;

    LOCAL procedure CopyGLAccToBuf(var TheGLAcc: Record 15; var TheDimCodeBuf: Record 367);
    begin
        WITH TheDimCodeBuf DO begin
            Rec.INIT;
            Code := TheGLAcc."No.";
            Name := TheGLAcc.Name;
            Totaling := TheGLAcc.Totaling;
            Indentation := TheGLAcc.Indentation;
            "Show in Bold" := TheGLAcc."Account Type" <> TheGLAcc."Account Type"::Posting;
        end;
    end;

    LOCAL procedure CopyPeriodToBuf(var ThePeriod: Record 2000000007; var TheDimCodeBuf: Record 367);
    begin
        WITH TheDimCodeBuf DO begin
            Rec.INIT;
            Code := FORMAT(ThePeriod."Period Start");
            "Period Start" := ThePeriod."Period Start";
            "Period end" := ThePeriod."Period end";
            Name := ThePeriod."Period Name";
        end;
    end;

    LOCAL procedure CopyBusUnitToBuf(var TheBusUnit: Record 220; var TheDimCodeBuf: Record 367);
    begin
        WITH TheDimCodeBuf DO begin
            Rec.INIT;
            Code := TheBusUnit.Code;
            if TheBusUnit.Name <> '' then
                Name := TheBusUnit.Name
            ELSE
                Name := TheBusUnit."Company Name";
        end;
    end;

    LOCAL procedure CopyDimValToBuf(var TheDimVal: Record 349; var TheDimCodeBuf: Record 367);
    begin
        WITH TheDimCodeBuf DO begin
            Rec.INIT;
            Code := TheDimVal.Code;
            Name := TheDimVal.Name;
            Totaling := TheDimVal.Totaling;
            Indentation := TheDimVal.Indentation;
            "Show in Bold" :=
                      TheDimVal."Dimension Value Type" <> TheDimVal."Dimension Value Type"::Standard;
        end;
    end;

    LOCAL procedure FindPeriod(SearchText: Code[10]);
    var
        GLAcc: Record 15;
        Calendar: Record 2000000007;
        PeriodFormMgt: Codeunit 50324;
    begin
        if DateFilter <> '' then begin
            Calendar.SETFILTER("Period Start", DateFilter);
            if not PeriodFormMgt.FindDate('+', Calendar, PeriodType) then
                PeriodFormMgt.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SETRANGE("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText, Calendar, PeriodType);
        GLAcc.SETRANGE("Date Filter", Calendar."Period Start", Calendar."Period end");
        if GLAcc.GETRANGEMIN("Date Filter") = GLAcc.GETRANGEMAX("Date Filter") then
            GLAcc.SETRANGE("Date Filter", GLAcc.GETRANGEMIN("Date Filter"));
        InternalDateFilter := GLAcc.GETFILTER("Date Filter");
        if (LineDimOption <> LineDimOption::Period) and (ColumnDimOption <> ColumnDimOption::Period) then
            DateFilter := InternalDateFilter;
    end;

    LOCAL procedure LookUpCode(DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4"; DimCode: Text[30]; Code: Text[30]);
    var
        GLAcc: Record 15;
        BusUnit: Record 220;
        DimVal: Record 349;
        DimValList: Page 560;
    begin
        CASE DimOption OF
            DimOption::"G/L Account":
                begin
                    GLAcc.GET(rec.Code);
                    PAGE.RUNMODAL(PAGE::"G/L Account List", GLAcc);
                end;
            DimOption::Period:
                ;
            DimOption::"Business Unit":
                begin
                    BusUnit.GET(rec.Code);
                    PAGE.RUNMODAL(PAGE::"Business Unit List", BusUnit);
                end;
            DimOption::"Global Dimension 1", DimOption::"Global Dimension 2",
            DimOption::"Budget Dimension 1", DimOption::"Budget Dimension 2",
            DimOption::"Budget Dimension 3", DimOption::"Budget Dimension 4":
                begin
                    DimVal.SETRANGE("Dimension Code", DimCode);
                    DimVal.GET(DimCode, rec.Code);
                    DimValList.SETTABLEVIEW(DimVal);
                    DimValList.SETRECORD(DimVal);
                    DimValList.RUNMODAL;
                end;
        end;
    end;

    LOCAL procedure SetCommonFilters(var TheGLAccBudgetBuffer: Record 374);
    begin
        WITH TheGLAccBudgetBuffer DO begin
            Rec.RESET;
            SETRANGE("Budget Filter", GLBudgetName.Name);
            if BusUnitFilter <> '' then
                SETFILTER("Business Unit Filter", BusUnitFilter);
            if GLAccFilter <> '' then
                SETFILTER("G/L Account Filter", GLAccFilter);
            if DateFilter <> '' then
                SETFILTER("Date Filter", DateFilter);
            if GlobalDim1Filter <> '' then
                SETFILTER("Global Dimension 1 Filter", GlobalDim1Filter);
            if GlobalDim2Filter <> '' then
                SETFILTER("Global Dimension 2 Filter", GlobalDim2Filter);
            if BudgetDim1Filter <> '' then
                SETFILTER("Budget Dimension 1 Filter", BudgetDim1Filter);
            if BudgetDim2Filter <> '' then
                SETFILTER("Budget Dimension 2 Filter", BudgetDim2Filter);
            if BudgetDim3Filter <> '' then
                SETFILTER("Budget Dimension 3 Filter", BudgetDim3Filter);
            if BudgetDim4Filter <> '' then
                SETFILTER("Budget Dimension 4 Filter", BudgetDim4Filter);
        end;
    end;

    LOCAL procedure SetDimFilters(var TheGLAccBudgetBuf: Record 374; LineOrColumn: Option Line,"Column");
    var
        DimOption: Option "G/L Account",Period,"Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        DimCodeBuf: Record 367;
    begin
        if LineOrColumn = LineOrColumn::Line then begin
            DimCodeBuf := Rec;
            DimOption := LineDimOption;
        end ELSE begin
            DimCodeBuf := MATRIX_MatrixRecord;
            DimOption := ColumnDimOption;
        end;

        WITH TheGLAccBudgetBuffer DO
            CASE DimOption OF
                DimOption::"G/L Account":
                    if DimCodeBuf.Totaling <> '' then
                        GLAccBudgetBuffer.SETFILTER("G/L Account Filter", DimCodeBuf.Totaling)
                    ELSE
                        GLAccBudgetBuffer.SETRANGE("G/L Account Filter", DimCodeBuf.Code);
                DimOption::Period:
                    SETRANGE("Date Filter", DimCodeBuf."Period Start", DimCodeBuf."Period end");
                DimOption::"Business Unit":
                    SETRANGE("Business Unit Filter", DimCodeBuf.Code);
                DimOption::"Global Dimension 1":
                    if DimCodeBuf.Totaling <> '' then
                        SETFILTER("Global Dimension 1 Filter", DimCodeBuf.Totaling)
                    ELSE
                        SETRANGE("Global Dimension 1 Filter", DimCodeBuf.Code);
                DimOption::"Global Dimension 2":
                    if DimCodeBuf.Totaling <> '' then
                        SETFILTER("Global Dimension 2 Filter", DimCodeBuf.Totaling)
                    ELSE
                        SETRANGE("Global Dimension 2 Filter", DimCodeBuf.Code);
                DimOption::"Budget Dimension 1":
                    if DimCodeBuf.Totaling <> '' then
                        SETFILTER("Budget Dimension 1 Filter", DimCodeBuf.Totaling)
                    ELSE
                        SETRANGE("Budget Dimension 1 Filter", DimCodeBuf.Code);
                DimOption::"Budget Dimension 2":
                    if DimCodeBuf.Totaling <> '' then
                        SETFILTER("Budget Dimension 2 Filter", DimCodeBuf.Totaling)
                    ELSE
                        SETRANGE("Budget Dimension 2 Filter", DimCodeBuf.Code);
                DimOption::"Budget Dimension 3":
                    if DimCodeBuf.Totaling <> '' then
                        SETFILTER("Budget Dimension 3 Filter", DimCodeBuf.Totaling)
                    ELSE
                        SETRANGE("Budget Dimension 3 Filter", DimCodeBuf.Code);
                DimOption::"Budget Dimension 4":
                    if DimCodeBuf.Totaling <> '' then
                        SETFILTER("Budget Dimension 4 Filter", DimCodeBuf.Totaling)
                    ELSE
                        SETRANGE("Budget Dimension 4 Filter", DimCodeBuf.Code);
            end;
    end;

    LOCAL procedure BudgetDrillDown();
    var
        GLBudgetEntry: Record 96;
    begin
        GLBudgetEntry.SETRANGE("Budget Name", GLBudgetName.Name);
        if GLAccBudgetBuffer.GETFILTER("G/L Account Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("G/L Account Filter", GLBudgetEntry."G/L Account No.");
        if GLAccBudgetBuffer.GETFILTER("Business Unit Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Business Unit Filter", GLBudgetEntry."Business Unit Code");
        if GLAccBudgetBuffer.GETFILTER("Global Dimension 1 Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Global Dimension 1 Filter", GLBudgetEntry."Global Dimension 1 Code");
        if GLAccBudgetBuffer.GETFILTER("Global Dimension 2 Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Global Dimension 2 Filter", GLBudgetEntry."Global Dimension 2 Code");
        if GLAccBudgetBuffer.GETFILTER("Budget Dimension 1 Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Budget Dimension 1 Filter", GLBudgetEntry."Budget Dimension 1 Code");
        if GLAccBudgetBuffer.GETFILTER("Budget Dimension 2 Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Budget Dimension 2 Filter", GLBudgetEntry."Budget Dimension 2 Code");
        if GLAccBudgetBuffer.GETFILTER("Budget Dimension 3 Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Budget Dimension 3 Filter", GLBudgetEntry."Budget Dimension 3 Code");
        if GLAccBudgetBuffer.GETFILTER("Budget Dimension 4 Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Budget Dimension 4 Filter", GLBudgetEntry."Budget Dimension 4 Code");
        if GLAccBudgetBuffer.GETFILTER("Date Filter") <> '' then
            GLAccBudgetBuffer.COPYFILTER("Date Filter", GLBudgetEntry.Date)
        ELSE
            // GLBudgetEntry.SETRANGE(Date,0D,12319999D);
            GLBudgetEntry.SETRANGE(Date, 0D, 99991231D);
        WITH GLBudgetEntry DO
            if (GETFILTER("Global Dimension 1 Code") <> '') or (GETFILTER("Global Dimension 2 Code") <> '') or
               (GETFILTER("Business Unit Code") <> '')
            then
                SETCURRENTKEY("Budget Name", "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code")
            ELSE
                SETCURRENTKEY("Budget Name", "G/L Account No.", Date);
        PAGE.RUN(0, GLBudgetEntry);
    end;

    LOCAL procedure CalcAmount(SetColumnFilter: Boolean): Decimal;
    begin
        SetCommonFilters(GLAccBudgetBuffer);
        SetDimFilters(GLAccBudgetBuffer, 0);
        if SetColumnFilter then
            SetDimFilters(GLAccBudgetBuffer, 1);
        GLAccBudgetBuffer.CALCFIELDS("Budgeted Amount");
        exit(GLAccBudgetBuffer."Budgeted Amount");
    end;

    LOCAL procedure ToRoundedValue(OrgAmount: Decimal): Decimal;
    var
        NewAmount: Decimal;
    begin
        NewAmount := OrgAmount;
        CASE RoundingFactor OF
            RoundingFactor::"1":
                NewAmount := ROUND(OrgAmount, 1);
            RoundingFactor::"1000":
                NewAmount := ROUND(OrgAmount / 1000);
            RoundingFactor::"1000000":
                NewAmount := ROUND(OrgAmount / 1000000);
        end;
        exit(NewAmount);
    end;

    LOCAL procedure FromRoundedValue(OrgAmount: Decimal): Decimal;
    var
        NewAmount: Decimal;
    begin
        NewAmount := OrgAmount;
        CASE RoundingFactor OF
            RoundingFactor::"1000":
                NewAmount := OrgAmount * 1000;
            RoundingFactor::"1000000":
                NewAmount := OrgAmount * 1000000;
        end;
        exit(NewAmount);
    end;

    // procedure Load(var MatrixColumns1: ARRAY[32] OF Text[80]; var MatrixRecords1: ARRAY[12] OF Record 367; CurrentNoOfMatrixColumns: Integer; _LineDimCode: Text[30]; _LineDimOption: Integer; _ColumnDimOption: Integer; _GlobalDim1Filter: Code[250]; _GlobalDim2Filter: Code[250]; _BudgetDim1Filter: Code[250]; _BudgetDim2Filter: Code[250]; _BudgetDim3Filter: Code[250]; _BudgetDim4Filter: Code[250]; var _GLBudgetName: Record 95; _DateFilter: Text[30]; _GLAccFilter: Code[250]; _RoundingFactor: Integer; _PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period");
    procedure Load(var MatrixColumns1: ARRAY[32] OF Text[80]; var MatrixRecords1: ARRAY[12] OF Record 367; CurrentNoOfMatrixColumns: Integer; _LineDimCode: Text[30]; _LineDimOption: Integer; _ColumnDimOption: Integer; _GlobalDim1Filter: Code[250]; _GlobalDim2Filter: Code[250]; _BudgetDim1Filter: Code[250]; _BudgetDim2Filter: Code[250]; _BudgetDim3Filter: Code[250]; _BudgetDim4Filter: Code[250]; var _GLBudgetName: Record 95; _DateFilter: Text[30]; _GLAccFilter: Code[250]; _RoundingFactor: Integer; _PeriodType: Enum "Analysis Period Type");
    var
        i: Integer;
    begin
        FOR i := 1 TO 12 DO begin
            if MatrixColumns1[i] = '' then
                MATRIX_CaptionSet[i] := ' '
            ELSE
                MATRIX_CaptionSet[i] := MatrixColumns1[i];
            MatrixRecords[i] := MatrixRecords1[i];
        end;
        if MATRIX_CaptionSet[1] = '' then; // To make this form pass preCAL test
        if CurrentNoOfMatrixColumns > ARRAYLEN(MATRIX_CellData) then
            MATRIX_CurrentNoOfMatrixColumn := ARRAYLEN(MATRIX_CellData)
        ELSE
            MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
        LineDimCode := _LineDimCode;
        LineDimOption := _LineDimOption;
        ColumnDimOption := _ColumnDimOption;
        GlobalDim1Filter := _GlobalDim1Filter;
        GlobalDim2Filter := _GlobalDim2Filter;
        BudgetDim1Filter := _BudgetDim1Filter;
        BudgetDim2Filter := _BudgetDim2Filter;
        BudgetDim3Filter := _BudgetDim3Filter;
        BudgetDim4Filter := _BudgetDim4Filter;
        GLBudgetName := _GLBudgetName;
        DateFilter := _DateFilter;
        GLAccFilter := _GLAccFilter;
        RoundingFactor := _RoundingFactor;
        PeriodType := _PeriodType;
    end;

    LOCAL procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer);
    begin
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        SetCommonFilters(GLAccBudgetBuffer);
        SetDimFilters(GLAccBudgetBuffer, 0);
        SetDimFilters(GLAccBudgetBuffer, 1);
        BudgetDrillDown;
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer);
    begin
        if ShowColumnName then
            MatrixHeader := MatrixRecords[MATRIX_ColumnOrdinal].Name
        ELSE
            MatrixHeader := MatrixRecords[MATRIX_ColumnOrdinal].Code;
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        MATRIX_CellData[MATRIX_ColumnOrdinal] := ToRoundedValue(CalcAmount(TRUE));
    end;

    procedure UpdateAmount(MATRIX_ColumnOrdinal: Integer);
    var
        GLBudgEntry2: Record 96;
        ChangeLogMgt: Codeunit 423;
        RecRef: RecordRef;
        LastEntryNo2: Integer;
        LogInsertion: Boolean;
        NewAmount: Decimal;
    begin
        if MATRIX_ColumnOrdinal > MATRIX_CurrentNoOfMatrixColumn then
            ERROR(Text002, MATRIX_CurrentNoOfMatrixColumn);
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        NewAmount := FromRoundedValue(MATRIX_CellData[MATRIX_ColumnOrdinal]);

        if CalcAmount(TRUE) = 0 then; // To set filters correctly
        GLAccBudgetBuffer.CALCFIELDS("Budgeted Amount");
        GLAccBudgetBuffer.VALIDATE("Budgeted Amount", NewAmount);
        rec.Amount := ToRoundedValue(CalcAmount(FALSE));
        CurrPage.UPDATE;
    end;

    procedure GLAccountBalanceBudget();
    var
        GLAcc: Record 15;
    begin
        if DimCodeToOption(LineDimCode) = 0 then
            GLAcc.GET(rec.Code)
        ELSE begin
            if GLAccFilter <> '' then
                GLAcc.SETFILTER("No.", GLAccFilter);
            GLAcc.FINDFIRST;
            GLAcc.RESET;
        end;
        WITH GLAcc DO begin
            SETRANGE("Budget Filter", BudgetName);
            if BusUnitFilter <> '' then
                SETFILTER("Business Unit Filter", BusUnitFilter);
            if GLAccFilter <> '' then
                SETFILTER("No.", GLAccFilter);
            if GlobalDim1Filter <> '' then
                SETFILTER("Global Dimension 1 Filter", GlobalDim1Filter);
            if GlobalDim2Filter <> '' then
                SETFILTER("Global Dimension 2 Filter", GlobalDim2Filter);
        end;
        PAGE.RUN(PAGE::"G/L Account Balance/Budget", GLAcc);
    end;

    LOCAL procedure FormatLine();
    begin
        Emphasize := rec."Show in Bold";
        NameIndent := rec.Indentation;
    end;

    // begin
    /*{
      JAV 05/08/19: - La funci�n Rec.SETPERMISSIONFILTER esta obsoleta
    }*///end
}








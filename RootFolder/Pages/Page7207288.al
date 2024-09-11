page 7207288 "Data Piecework Matrix"
{
    CaptionML = ENU = 'Data Piecework Evolution', ESP = 'Planif. unidades de obra Mtriz';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = FILTER("Piecework"), "Production Unit" = CONST(true));
    PageType = List;

    layout
    {
        area(content)
        {
            group("group50")
            {

                field("FiltroValor"; OptValue)
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
                IndentationControls = "Piecework Code", Descripcion;
                ShowAsTree = true;
                FreezeColumn = "Field3";
                field("Piecework Code"; rec."Piecework Code")
                {

                    CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Descripcion"; rec."Description")
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                    Editable = FALSE;
                    StyleExpr = stLine;
                }
                field("Field1"; MATRIX_CellData[1])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(1);
                        MATRIX_OnValidate(1);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(1);
                    END;


                }
                field("Field2"; MATRIX_CellData[2])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(2);
                        MATRIX_OnValidate(2);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(2);
                    END;


                }
                field("Field3"; MATRIX_CellData[3])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    StyleExpr = stCol3;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(3);
                        MATRIX_OnValidate(3);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(3);
                    END;


                }
                field("Field4"; MATRIX_CellData[4])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(4);
                        MATRIX_OnValidate(4);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(4);
                    END;


                }
                field("Field5"; MATRIX_CellData[5])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(5);
                        MATRIX_OnValidate(5);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(5);
                    END;


                }
                field("Field6"; MATRIX_CellData[6])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(6);
                        MATRIX_OnValidate(6);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(6);
                    END;


                }
                field("Field7"; MATRIX_CellData[7])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(7);
                        MATRIX_OnValidate(7);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(7);
                    END;


                }
                field("Field8"; MATRIX_CellData[8])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(8);
                        MATRIX_OnValidate(8);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(8);
                    END;


                }
                field("Field9"; MATRIX_CellData[9])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(9);
                        MATRIX_OnValidate(9);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(9);
                    END;


                }
                field("Field10"; MATRIX_CellData[10])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(10);
                        MATRIX_OnValidate(10);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(10);
                    END;


                }
                field("Field11"; MATRIX_CellData[11])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(11);
                        MATRIX_OnValidate(11);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(11);
                    END;


                }
                field("Field12"; MATRIX_CellData[12])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(12);
                        MATRIX_OnValidate(12);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(12);
                    END;


                }
                field("Field13"; MATRIX_CellData[13])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(13);
                        MATRIX_OnValidate(13);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(13);
                    END;


                }
                field("Field14"; MATRIX_CellData[14])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(14);
                        MATRIX_OnValidate(14);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(14);
                    END;


                }
                field("Field15"; MATRIX_CellData[15])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(15);
                        MATRIX_OnValidate(15);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(15);
                    END;


                }
                field("Field16"; MATRIX_CellData[16])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(16);
                        MATRIX_OnValidate(16);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(16);
                    END;


                }
                field("Field17"; MATRIX_CellData[17])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(17);
                        MATRIX_OnValidate(17);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(17);
                    END;


                }
                field("Field18"; MATRIX_CellData[18])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(18);
                        MATRIX_OnValidate(18);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(18);
                    END;


                }
                field("Field19"; MATRIX_CellData[19])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(19);
                        MATRIX_OnValidate(19);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(19);
                    END;


                }
                field("Field20"; MATRIX_CellData[20])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(20);
                        MATRIX_OnValidate(20);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(20);
                    END;


                }
                field("Field21"; MATRIX_CellData[21])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(21);
                        MATRIX_OnValidate(21);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(21);
                    END;


                }
                field("Field22"; MATRIX_CellData[22])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(22);
                        MATRIX_OnValidate(22);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(22);
                    END;


                }
                field("Field23"; MATRIX_CellData[23])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(23);
                        MATRIX_OnValidate(23);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(23);
                    END;


                }
                field("Field24"; MATRIX_CellData[24])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(24);
                        MATRIX_OnValidate(24);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(24);
                    END;


                }
                field("Field25"; MATRIX_CellData[25])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(25);
                        MATRIX_OnValidate(25);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(25);
                    END;


                }
                field("Field26"; MATRIX_CellData[26])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(26);
                        MATRIX_OnValidate(26);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(26);
                    END;


                }
                field("Field27"; MATRIX_CellData[27])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(27);
                        MATRIX_OnValidate(27);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(27);
                    END;


                }
                field("Field28"; MATRIX_CellData[28])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(28);
                        MATRIX_OnValidate(28);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(28);
                    END;


                }
                field("Field29"; MATRIX_CellData[29])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(29);
                        MATRIX_OnValidate(29);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(29);
                    END;


                }
                field("Field30"; MATRIX_CellData[30])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(30);
                        MATRIX_OnValidate(30);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(30);
                    END;


                }
                field("Field31"; MATRIX_CellData[31])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(31);
                        MATRIX_OnValidate(31);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(31);
                    END;


                }
                field("Field32"; MATRIX_CellData[32])
                {

                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    StyleExpr = stLine;



                    ; trigger OnValidate()
                    BEGIN
                        ControlTypeEntry(32);
                        MATRIX_OnValidate(32);
                    END;

                    trigger OnDrillDown()
                    BEGIN
                        MATRIX_OnDrillDown(32);
                    END;


                }

            }

        }
    }
    actions
    {
        area(Processing)
        {


        }

    }

    trigger OnOpenPage()
    BEGIN
        OptValue := OptValue::Quantity;
        Job.GET(CodeJob);
        Rec.SETFILTER("Job No.", CodeJob);
        Rec.SETFILTER("Initial Budget Filter", Job."Initial Budget Piecework");
        Rec.CALCFIELDS("Initial Budget Measure", "Initial Budget Price");
    END;

    trigger OnAfterGetRecord()
    VAR
        nColumn: Integer;
    BEGIN
        DescriptionIndent := 0;
        nColumn := 1;

        WHILE (nColumn <= MaxColumns) DO BEGIN
            MATRIX_OnAfterGetRecord(nColumn);
            nColumn += 1;
        END;

        Rec.SETFILTER("Job No.", CodeJob);
        DescriptionIndent := rec.Indentation;

        IF rec."Account Type" = rec."Account Type"::Unit THEN
            stLine := 'Standard'
        ELSE
            stLine := 'Strong';
    END;



    var
        Text000: TextConst ENU = 'Do you want to approve the planning?', ESP = '�Desea aprobar la planificaci�n?';
        Text001: TextConst ENU = 'The budgeted measurement for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado la medici�n presupuestada para esta unidad de obra.';
        Text002: TextConst ENU = 'The budgeted cost for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado el coste presupuestado para esta unidad de obra.';
        Text003: TextConst ENU = 'The budgeted production for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado la producci�n presupuestada para esta unidad de obra.';
        Text004: TextConst ENU = 'Piecework/cost% 1 not fully planned.', ESP = 'La unidad de obra/coste %1 no esta totalmente planificada.';
        Text005: TextConst ENU = 'You can not Rec.MODIFY data for records whose Account Type is Heading.', ESP = 'No se pueden modificar datos para registros cuyo Tipo Mov. es Mayor.';
        Text006: TextConst ENU = 'Processing planning data.', ESP = 'Procesando datos de planificaci�n.';
        Job: Record 167;
        JobBudget: Record 7207407;
        OptValue: Option "Quantity","Price","Amount";
        CodeJob: Code[20];
        MaxColumns: Integer;
        DescriptionIndent: Integer;
        MATRIX_CellData: ARRAY[32] OF Decimal;
        MATRIX_ColumnCaption: ARRAY[32] OF Text[1024];
        stLine: Text;
        stCol3: Text;
        Value: Decimal;
        vInitial: Decimal;
        vActual: Decimal;
        Text007: TextConst ESP = 'INICIAL';
        Text008: TextConst ESP = 'ACTUAL';
        Text009: TextConst ESP = 'DIFERENCIA';

    procedure SetJob(pCodeJob: Code[20]);
    var
        i: Integer;
    begin
        CodeJob := pCodeJob;

        MATRIX_ColumnCaption[1] := Text007;
        MATRIX_ColumnCaption[2] := Text008;
        MATRIX_ColumnCaption[3] := Text009;

        MaxColumns := 3;
        JobBudget.RESET;
        JobBudget.SETCURRENTKEY("Job No.", "Budget Date");
        JobBudget.SETRANGE("Job No.", pCodeJob);
        if (JobBudget.FINDSET) then
            repeat
                MaxColumns += 1;
                MATRIX_ColumnCaption[MaxColumns] := JobBudget."Cod. Budget";
                if (JobBudget."Initial Budget") then
                    MATRIX_ColumnCaption[1] := Text007 + ' (' + JobBudget."Cod. Budget" + ')';
                if (JobBudget."Actual Budget") then
                    MATRIX_ColumnCaption[2] := Text008 + ' (' + JobBudget."Cod. Budget" + ')';

            until (JobBudget.NEXT = 0);
    end;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord(ColumnID: Integer);
    begin
        if (ColumnID = 3) then begin
            Value := vActual - vInitial;
            MATRIX_CellData[ColumnID] := Value;
            if (Value > 0) then
                stCol3 := 'Unfavorable'
            ELSE
                stCol3 := 'Favorable';
        end ELSE begin
            CASE ColumnID OF
                1:
                    Rec.SETFILTER("Budget Filter", Job."Initial Budget Piecework");
                2:
                    Rec.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                ELSE
                    Rec.SETFILTER("Budget Filter", MATRIX_ColumnCaption[ColumnID]);
            end;

            Rec.SETFILTER("Job No.", CodeJob);
            Rec.CALCFIELDS("Measure Budg. Piecework Sol", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");

            CASE OptValue OF
                OptValue::Quantity:
                    Value := rec."Measure Budg. Piecework Sol";
                OptValue::Price:
                    Value := rec."Aver. Cost Price Pend. Budget";
                OptValue::Amount:
                    Value := rec."Amount Cost Budget (JC)";
            end;

            MATRIX_CellData[ColumnID] := Value;

            CASE ColumnID OF
                1:
                    vInitial := Value;
                2:
                    vActual := Value;
            end;
        end;
    end;

    procedure MATRIX_OnValidate(ColumnID: Integer);
    begin
    end;

    procedure ControlTypeEntry(ColumnID: Integer);
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text005);
    end;

    // begin
    /*{
      JAV 26/08/20: - Nueva pantalla con la evoluci�n de las unidades de obra en los difernetes presupuestos
    }*///end
}








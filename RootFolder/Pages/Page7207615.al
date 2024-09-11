page 7207615 "Plan Job Units Matrix"
{
    CaptionML = ENU = 'Plan Job Units Matrix', ESP = 'Planif. unidades de obra Mtriz';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Plannable" = CONST(true), "Production Unit" = CONST(true));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            group("group6")
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
                field("ColumnSet"; ColumnSet)
                {

                    CaptionML = ENU = 'Column Set', ESP = 'Conjunto de valores';
                    Editable = FALSE;
                }

            }
            repeater("table")
            {

                IndentationColumn = DescriptionIndent;
                IndentationControls = "Piecework Code", Descripcion;
                ShowAsTree = true;
                FreezeColumn = "QuantityPending";
                field("Piecework Code"; rec."Piecework Code")
                {

                    CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Descripcion"; PADSTR('', rec.Indentation * 2, ' ') + rec.Description)
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field("QuantityBudget"; QuantityBudget)
                {

                    CaptionML = ENU = 'Budget', ESP = 'Presupuesto';
                    DecimalPlaces = 2 : 6;
                    Editable = FALSE;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("QuantityPending"; QuantityPending)
                {

                    CaptionML = ENU = 'Pending Planning', ESP = 'Pdte. planificar';
                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("QuantityPerformed"; QuantityPerformed)
                {

                    CaptionML = ENU = 'Performed', ESP = 'Realizado';
                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    Visible = false;
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("QuantityToPlanned"; QuantityToPlanned)
                {

                    CaptionML = ENU = 'Total to Plan', ESP = 'Pendiente';
                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    Visible = false;
                    Editable = FALSE;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("QuantityPlanned"; QuantityPlanned)
                {

                    CaptionML = ENU = 'Planning', ESP = 'Planificado';
                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    Visible = false;
                    Editable = FALSE;
                }
                field("PreviousBalance"; PreviousBalance)
                {

                    CaptionML = ENU = 'Previous Balance', ESP = 'Saldo Anterior';
                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    Editable = FALSE;
                }
                field("Field01"; MATRIX_CellData[1])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Visible = vColumn_01;
                    Editable = not Performed_01;
                    Style = Strong;
                    StyleExpr = Performed_01;

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
                field("Field02"; MATRIX_CellData[2])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Visible = vColumn_02;
                    Editable = not Performed_02;
                    Style = Strong;
                    StyleExpr = Performed_02;

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
                field("Field03"; MATRIX_CellData[3])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Visible = vColumn_03;
                    Editable = not Performed_03;
                    Style = Strong;
                    StyleExpr = Performed_03;

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
                field("Field04"; MATRIX_CellData[4])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Visible = vColumn_04;
                    Editable = not Performed_04;
                    Style = Strong;
                    StyleExpr = Performed_04;

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
                field("Field05"; MATRIX_CellData[5])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Visible = vColumn_05;
                    Editable = not Performed_05;
                    Style = Strong;
                    StyleExpr = Performed_05;

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
                field("Field06"; MATRIX_CellData[6])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Visible = vColumn_06;
                    Editable = not Performed_06;
                    Style = Strong;
                    StyleExpr = Performed_06;

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
                field("Field07"; MATRIX_CellData[7])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Visible = vColumn_07;
                    Editable = not Performed_07;
                    Style = Strong;
                    StyleExpr = Performed_07;

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
                field("Field08"; MATRIX_CellData[8])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Visible = vColumn_08;
                    Editable = not Performed_08;
                    Style = Strong;
                    StyleExpr = Performed_08;

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
                field("Field09"; MATRIX_CellData[9])
                {

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    Visible = vColumn_09;
                    Editable = not Performed_09;
                    Style = Strong;
                    StyleExpr = Performed_09;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    Visible = vColumn_10;
                    Editable = not Performed_10;
                    Style = Strong;
                    StyleExpr = Performed_10;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    Visible = vColumn_11;
                    Editable = not Performed_11;
                    Style = Strong;
                    StyleExpr = Performed_11;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    Visible = vColumn_12;
                    Editable = not Performed_12;
                    Style = Strong;
                    StyleExpr = Performed_12;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    Visible = vColumn_13;
                    Editable = not Performed_13;
                    Style = Strong;
                    StyleExpr = Performed_13;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    Visible = vColumn_14;
                    Editable = not Performed_14;
                    Style = Strong;
                    StyleExpr = Performed_14;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    Visible = vColumn_15;
                    Editable = not Performed_15;
                    Style = Strong;
                    StyleExpr = Performed_15;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    Visible = vColumn_16;
                    Editable = not Performed_16;
                    Style = Strong;
                    StyleExpr = Performed_16;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    Visible = vColumn_17;
                    Editable = not Performed_17;
                    Style = Strong;
                    StyleExpr = Performed_17;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    Visible = vColumn_18;
                    Editable = not Performed_18;
                    Style = Strong;
                    StyleExpr = Performed_18;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    Visible = vColumn_19;
                    Editable = not Performed_19;
                    Style = Strong;
                    StyleExpr = Performed_19;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    Visible = vColumn_20;
                    Editable = not Performed_20;
                    Style = Strong;
                    StyleExpr = Performed_20;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    Visible = vColumn_21;
                    Editable = not Performed_21;
                    Style = Strong;
                    StyleExpr = Performed_21;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    Visible = vColumn_22;
                    Editable = not Performed_22;
                    Style = Strong;
                    StyleExpr = Performed_22;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    Visible = vColumn_23;
                    Editable = not Performed_23;
                    Style = Strong;
                    StyleExpr = Performed_23;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    Visible = vColumn_24;
                    Editable = not Performed_24;
                    Style = Strong;
                    StyleExpr = Performed_24;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    Visible = vColumn_25;
                    Editable = not Performed_25;
                    Style = Strong;
                    StyleExpr = Performed_25;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    Visible = vColumn_26;
                    Editable = not Performed_26;
                    Style = Strong;
                    StyleExpr = Performed_26;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    Visible = vColumn_27;
                    Editable = not Performed_27;
                    Style = Strong;
                    StyleExpr = Performed_27;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    Visible = vColumn_28;
                    Editable = not Performed_28;
                    Style = Strong;
                    StyleExpr = Performed_28;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    Visible = vColumn_29;
                    Editable = not Performed_29;
                    Style = Strong;
                    StyleExpr = Performed_29;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    Visible = vColumn_30;
                    Editable = not Performed_30;
                    Style = Strong;
                    StyleExpr = Performed_30;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    Visible = vColumn_31;
                    Editable = not Performed_31;
                    Style = Strong;
                    StyleExpr = Performed_31;

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

                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    Visible = vColumn_32;
                    Editable = not Performed_32;
                    Style = Strong;
                    StyleExpr = Performed_32;

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
                field("NextBalance"; NextBalance)
                {

                    CaptionML = ENU = 'Next Balance', ESP = 'Saldo Siguiente';
                    DecimalPlaces = 2 : 6;
                    BlankZero = true;
                    Editable = FALSE

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Set")
            {

                CaptionML = ENU = 'Appr&ove', ESP = 'Apr&obar';
                Image = Confirm;

                trigger OnAction()
                VAR
                    TMPExpectedTimeUnitDataTemp: Record 7207389;
                    LJob: Record 167;
                    ExpectedTimeUnitData: Record 7207388;
                    ExpectedTimeUnitDataNewMSP: Record 7207388;
                    DataPieceworkForProductionDUO: Record 7207386;
                    Window: Dialog;
                    LastEntry: Integer;
                    TAmount: Decimal;
                    JobOVersion: Boolean;
                BEGIN
                    IF LJob.GET(CodeJob) THEN
                        LJob.JobStatus(CodeJob);

                    IF CONFIRM(Text010) THEN BEGIN
                        Window.OPEN(Text012);

                        IF FilterBudget = '' THEN
                            FilterBudget := LJob."Current Piecework Budget";

                        //Miramos que todas las unidades esten repartidas al 100% y eliminamos las que vamos a reemplazar
                        DataPieceworkForProductionUO.RESET;
                        DataPieceworkForProductionUO.SETRANGE("Job No.", CodeJob);
                        DataPieceworkForProductionUO.SETRANGE("Budget Filter", FilterBudget);
                        DataPieceworkForProductionUO.SETRANGE("Account Type", DataPieceworkForProductionUO."Account Type"::Unit);
                        IF DataPieceworkForProductionUO.FINDSET THEN
                            REPEAT
                                DataPieceworkForProductionUO.CALCFIELDS("Budget Measure");

                                TMPExpectedTimeUnitDataTemp.RESET;
                                TMPExpectedTimeUnitDataTemp.SETCURRENTKEY("Job No.", "Piecework Code");
                                TMPExpectedTimeUnitDataTemp.SETRANGE("Job No.", CodeJob);
                                TMPExpectedTimeUnitDataTemp.SETRANGE("Budget Code", FilterBudget);
                                TMPExpectedTimeUnitDataTemp.SETRANGE("Piecework Code", DataPieceworkForProductionUO."Piecework Code");
                                IF (NOT TMPExpectedTimeUnitDataTemp.ISEMPTY) THEN BEGIN
                                    TMPExpectedTimeUnitDataTemp.CALCSUMS(TMPExpectedTimeUnitDataTemp."Expected Measured Amount");
                                    IF (DataPieceworkForProductionUO."Budget Measure" - TMPExpectedTimeUnitDataTemp."Expected Measured Amount" > Decimales) THEN
                                        ERROR(Text013, DataPieceworkForProductionUO."Piecework Code", DataPieceworkForProductionUO."Budget Measure" - TMPExpectedTimeUnitDataTemp."Expected Measured Amount");

                                    ExpectedTimeUnitData.RESET;
                                    ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
                                    ExpectedTimeUnitData.SETRANGE("Job No.", CodeJob);
                                    ExpectedTimeUnitData.SETRANGE("Budget Code", FilterBudget);
                                    ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPieceworkForProductionUO."Piecework Code");
                                    ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                                    ExpectedTimeUnitData.DELETEALL;
                                END;
                            UNTIL DataPieceworkForProductionUO.NEXT = 0;

                        //Buscar el �ltimo registro de la tabla
                        ExpectedTimeUnitData.RESET;
                        ExpectedTimeUnitData.SETCURRENTKEY(ExpectedTimeUnitData."Entry No.");
                        IF ExpectedTimeUnitData.FINDLAST THEN
                            LastEntry := ExpectedTimeUnitData."Entry No."
                        ELSE
                            LastEntry := 0;

                        //Traspasar los registros
                        TMPExpectedTimeUnitDataTemp.RESET;
                        TMPExpectedTimeUnitDataTemp.SETCURRENTKEY("Job No.", "Piecework Code");
                        TMPExpectedTimeUnitDataTemp.SETRANGE("Job No.", CodeJob);
                        TMPExpectedTimeUnitDataTemp.SETRANGE("Budget Code", FilterBudget);
                        TMPExpectedTimeUnitDataTemp.SETRANGE(Performed, FALSE);
                        TMPExpectedTimeUnitDataTemp.SETFILTER("Expected Measured Amount", '<>0');
                        IF TMPExpectedTimeUnitDataTemp.FINDSET(FALSE) THEN BEGIN
                            REPEAT
                                LastEntry += 1;
                                ExpectedTimeUnitDataNewMSP.TRANSFERFIELDS(TMPExpectedTimeUnitDataTemp);
                                ExpectedTimeUnitDataNewMSP."Entry No." := LastEntry;
                                ExpectedTimeUnitDataNewMSP."Budget Code" := FilterBudget;
                                ExpectedTimeUnitDataNewMSP.INSERT;
                            UNTIL TMPExpectedTimeUnitDataTemp.NEXT = 0;
                        END;

                        //Recalcular el presupuesto completo
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", CodeJob);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", FilterBudget);
                        IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                            COMMIT; //Para mejorar el rendimiento de los c�lculos
                            JobOVersion := (LJob."Card Type" = LJob."Card Type"::Estudio);      //PGM 11/09/2019 >> se comprueba si es un estudio o un proyecto operativo
                            CLEAR(ConvertToBudgetxCA);
                            ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, JobOVersion, CodeJob);
                        END;

                        Window.CLOSE;
                    END;
                END;


            }
            action("Adjust")
            {

                CaptionML = ESP = 'Ajustar';
                Image = AdjustEntries;

                trigger OnAction()
                VAR
                    i: Integer;
                    Suma: Decimal;
                BEGIN
                    //Ajusta las diferencias en el �ltimo periodo existente en la tabla temporal
                    //JAV 03/05/22: - QB 1.10.38 Unificar los ajustes de diferencias entre las dos funciones que lo hacen

                    AdjustDiferences(TRUE);
                END;


            }
            action("Adjust All")
            {

                CaptionML = ENU = 'Ajustar Todo', ESP = 'Ajustar Todo';
                Image = AdjustEntries;
                trigger OnAction()
                VAR
                    i: Integer;
                    Suma: Decimal;
                BEGIN
                    //AML 03/05/22: - QB 1.10.38 Ajusta las peque�as diferencias de todas las l�neas en el �ltimo periodo existente en la tabla temporal
                    //JAV 03/05/22: - QB 1.10.38 Unificar los ajustes de diferencias entre las dos funciones que lo hacen

                    IF CONFIRM('Seguro que desea ajustar todas las l�neas pdtes de planificar?', FALSE) THEN BEGIN
                        IF (Rec.FINDSET) THEN
                            REPEAT
                                AdjustDiferences(FALSE);
                            UNTIL rec.NEXT = 0;
                    END;
                END;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Set_Promoted; Set)
                {
                }
                actionref(Adjust_Promoted; Adjust)
                {
                }
                actionref("Adjust All_Promoted"; "Adjust All")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        OptValue := OptValue::Quantity;

        Rec.RESET;
        Rec.SETFILTER("Job No.", CodeJob);
        Rec.SETFILTER("Budget Filter", FilterBudget);

        //JAV 22/06/21: - QB 1.09.01 Se a�ade el filtro de tipo de U.O.
        IF (vDir) AND (NOT vInd) THEN
            Rec.SETRANGE(Type, Rec.Type::Piecework);
        IF (NOT vDir) AND (vInd) THEN
            Rec.SETRANGE(Type, Rec.Type::"Cost Unit");

        Decimales := 0.000001;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        OnAfterGet;
    END;



    var
        Text000: TextConst ENU = 'The budgeted measurement for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado la cantidad para esta unidad de obra en %1 %2';
        Text001: TextConst ENU = 'You can not Rec.MODIFY data for records whose Account Type is Heading.', ESP = 'No se pueden modificar datos para registros cuyo Tipo Mov. es Mayor.';
        Text010: TextConst ENU = 'Piecework planning will be erased previous. Do you want to approve MSP planning?', ESP = 'Se borrar� la planificaci�n de U.O. anterior. �Desea aprobar la nueva planificaci�n?';
        Text011: TextConst ENU = 'No Microsoft Project data is pending processing.', ESP = 'No hay datos pendientes de procesar.';
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        TMPExpectedTimeUnitData: Record 7207389;
        Job: Record 167;
        JobBudget: Record 7207407;
        DataPieceworkForProductionUO: Record 7207386;
        DataPieceworkForProduction: Record 7207386;
        ConvertToBudgetxCA: Codeunit 7207282;
        Decimales: Decimal;
        ColumnSet: Text;
        MATRIX_CellData: ARRAY[32] OF Decimal;
        MATRIX_ColumnCaption: ARRAY[32] OF Text;
        MATRIX_Performed: ARRAY[32] OF Boolean;
        OptValue: Option "Quantity","Expenses","Income","Percentage";
        CodeJob: Code[20];
        FilterBudget: Code[20];
        DescriptionIndent: Integer;
        QuantityBudget: Decimal;
        QuantityPerformed: Decimal;
        QuantityToPlanned: Decimal;
        QuantityPlanned: Decimal;
        QuantityPending: Decimal;
        isHeading: Boolean;
        vDir: Boolean;
        vInd: Boolean;
        "-----Q13646": Integer;
        PreviousBalance: Decimal;
        NextBalance: Decimal;
        vColumn_01: Boolean;
        vColumn_02: Boolean;
        vColumn_03: Boolean;
        vColumn_04: Boolean;
        vColumn_05: Boolean;
        vColumn_06: Boolean;
        vColumn_07: Boolean;
        vColumn_08: Boolean;
        vColumn_09: Boolean;
        vColumn_10: Boolean;
        vColumn_11: Boolean;
        vColumn_12: Boolean;
        vColumn_13: Boolean;
        vColumn_14: Boolean;
        vColumn_15: Boolean;
        vColumn_16: Boolean;
        vColumn_17: Boolean;
        vColumn_18: Boolean;
        vColumn_19: Boolean;
        vColumn_20: Boolean;
        vColumn_21: Boolean;
        vColumn_22: Boolean;
        vColumn_23: Boolean;
        vColumn_24: Boolean;
        vColumn_25: Boolean;
        vColumn_26: Boolean;
        vColumn_27: Boolean;
        vColumn_28: Boolean;
        vColumn_29: Boolean;
        vColumn_30: Boolean;
        vColumn_31: Boolean;
        vColumn_32: Boolean;
        "----+Q13646": Integer;
        Performed_01: Boolean;
        Performed_02: Boolean;
        Performed_03: Boolean;
        Performed_04: Boolean;
        Performed_05: Boolean;
        Performed_06: Boolean;
        Performed_07: Boolean;
        Performed_08: Boolean;
        Performed_09: Boolean;
        Performed_10: Boolean;
        Performed_11: Boolean;
        Performed_12: Boolean;
        Performed_13: Boolean;
        Performed_14: Boolean;
        Performed_15: Boolean;
        Performed_16: Boolean;
        Performed_17: Boolean;
        Performed_18: Boolean;
        Performed_19: Boolean;
        Performed_20: Boolean;
        Performed_21: Boolean;
        Performed_22: Boolean;
        Performed_23: Boolean;
        Performed_24: Boolean;
        Performed_25: Boolean;
        Performed_26: Boolean;
        Performed_27: Boolean;
        Performed_28: Boolean;
        Performed_29: Boolean;
        Performed_30: Boolean;
        Performed_31: Boolean;
        Performed_32: Boolean;
        Text012: TextConst ENU = 'Processing planning data.', ESP = 'Procesando Unidades de Obra';
        Text013: TextConst ENU = 'Piecework/cost% 1 not fully planned.', ESP = 'La unidad de obra/coste %1 no esta totalmente planificada (falta %2)';
        Text020: TextConst ESP = 'Se a�adir� en %1 la cantidad de %2 %3, �Realmente desea realizar este ajuste?';
        Text021: TextConst ESP = 'No es posible ajustar, no se encuentra una columna v�lida';
        Text022: TextConst ESP = 'Nada que ajustar';

    LOCAL procedure SetDateFilter(ColumnID: Integer);
    begin
        if MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period end" then
            Rec.SETRANGE("Filter Date", MatrixRecords[ColumnID]."Period Start")
        ELSE
            Rec.SETRANGE("Filter Date", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period end");
    end;

    procedure Load(var MatrixColumns1: ARRAY[32] OF Text[1024]; var MatrixRecords1: ARRAY[32] OF Record 2000000007; QtyType1: Option "Quantity","Expenses","Income","Percentage"; pCodeJob: Code[20]; pFilterBudget: Code[20]; pColumnSet: Text; pDir: Boolean; pInd: Boolean);
    var
        i: Integer;
    begin
        COPYARRAY(MATRIX_ColumnCaption, MatrixColumns1, 1);
        COPYARRAY(MatrixRecords, MatrixRecords1, 1);
        ColumnSet := pColumnSet;

        CodeJob := pCodeJob;
        FilterBudget := pFilterBudget;
        //JAV 22/06/21: - QB 1.09.01 Se a�ade el filtro de tipo de U.O.
        vDir := pDir;
        vInd := pInd;

        //-Q13646
        vColumn_01 := ColumnVisible(1);
        vColumn_02 := ColumnVisible(2);
        vColumn_03 := ColumnVisible(3);
        vColumn_04 := ColumnVisible(4);
        vColumn_05 := ColumnVisible(5);
        vColumn_06 := ColumnVisible(6);
        vColumn_07 := ColumnVisible(7);
        vColumn_08 := ColumnVisible(8);
        vColumn_09 := ColumnVisible(9);
        vColumn_10 := ColumnVisible(10);
        vColumn_11 := ColumnVisible(11);
        vColumn_12 := ColumnVisible(12);
        vColumn_13 := ColumnVisible(13);
        vColumn_14 := ColumnVisible(14);
        vColumn_15 := ColumnVisible(15);
        vColumn_16 := ColumnVisible(16);
        vColumn_17 := ColumnVisible(17);
        vColumn_18 := ColumnVisible(18);
        vColumn_19 := ColumnVisible(19);
        vColumn_20 := ColumnVisible(20);
        vColumn_21 := ColumnVisible(21);
        vColumn_22 := ColumnVisible(22);
        vColumn_23 := ColumnVisible(23);
        vColumn_24 := ColumnVisible(24);
        vColumn_25 := ColumnVisible(25);
        vColumn_26 := ColumnVisible(26);
        vColumn_27 := ColumnVisible(27);
        vColumn_28 := ColumnVisible(28);
        vColumn_29 := ColumnVisible(29);
        vColumn_30 := ColumnVisible(30);
        vColumn_31 := ColumnVisible(31);
        vColumn_32 := ColumnVisible(32);
        //-Q13646
    end;

    LOCAL procedure SetEditable();
    begin
        Performed_01 := MATRIX_Performed[1];
        Performed_02 := MATRIX_Performed[2];
        Performed_03 := MATRIX_Performed[3];
        Performed_04 := MATRIX_Performed[4];
        Performed_05 := MATRIX_Performed[5];
        Performed_06 := MATRIX_Performed[6];
        Performed_07 := MATRIX_Performed[7];
        Performed_08 := MATRIX_Performed[8];
        Performed_09 := MATRIX_Performed[9];
        Performed_10 := MATRIX_Performed[10];
        Performed_11 := MATRIX_Performed[11];
        Performed_12 := MATRIX_Performed[12];
        Performed_13 := MATRIX_Performed[13];
        Performed_14 := MATRIX_Performed[14];
        Performed_15 := MATRIX_Performed[15];
        Performed_16 := MATRIX_Performed[16];
        Performed_17 := MATRIX_Performed[17];
        Performed_18 := MATRIX_Performed[18];
        Performed_19 := MATRIX_Performed[19];
        Performed_20 := MATRIX_Performed[20];
        Performed_21 := MATRIX_Performed[21];
        Performed_22 := MATRIX_Performed[22];
        Performed_23 := MATRIX_Performed[23];
        Performed_24 := MATRIX_Performed[24];
        Performed_25 := MATRIX_Performed[25];
        Performed_26 := MATRIX_Performed[26];
        Performed_27 := MATRIX_Performed[27];
        Performed_28 := MATRIX_Performed[28];
        Performed_29 := MATRIX_Performed[29];
        Performed_30 := MATRIX_Performed[30];
        Performed_31 := MATRIX_Performed[31];
        Performed_32 := MATRIX_Performed[32];
    end;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
        TMPExpectedTimeUnitData.SETFILTER("Job No.", CodeJob);
        if rec."Account Type" = rec."Account Type"::Unit then
            TMPExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code")
        ELSE
            TMPExpectedTimeUnitData.SETFILTER("Piecework Code", rec.Totaling);
        TMPExpectedTimeUnitData.SETFILTER("Budget Code", FilterBudget);
        TMPExpectedTimeUnitData.SETFILTER("Expected Date", '%1..%2', MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period end");
        PAGE.RUNMODAL(PAGE::"Schedule MSP", TMPExpectedTimeUnitData);
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord(ColumnID: Integer);
    begin
        MATRIX_CellData[ColumnID] := GetData(ColumnID);
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord_Zero(ColumnID: Integer);
    begin
        MATRIX_CellData[ColumnID] := 0;
    end;

    procedure ControlTypeEntry(ColumnID: Integer);
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text001);
    end;

    LOCAL procedure ColumnVisible(ColumnId: Integer): Boolean;
    begin
        //Q13646 ++
        exit(MATRIX_ColumnCaption[ColumnId] <> '');
    end;

    LOCAL procedure GetData(ColumnId: Integer): Decimal;
    begin
        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
        TMPExpectedTimeUnitData.SETRANGE("Job No.", CodeJob);
        if rec."Account Type" = rec."Account Type"::Unit then
            TMPExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code")
        ELSE
            TMPExpectedTimeUnitData.SETFILTER("Piecework Code", rec.Totaling);
        TMPExpectedTimeUnitData.SETFILTER("Budget Code", FilterBudget);
        TMPExpectedTimeUnitData.SETFILTER("Expected Date", '%1..%2', MatrixRecords[ColumnId]."Period Start", MatrixRecords[ColumnId]."Period end");
        if (not TMPExpectedTimeUnitData.FINDFIRST) then
            TMPExpectedTimeUnitData.INIT;

        CASE OptValue OF
            OptValue::Quantity:
                exit(TMPExpectedTimeUnitData."Expected Measured Amount");
            OptValue::Expenses:
                exit(TMPExpectedTimeUnitData."Expected Cost Amount");
            OptValue::Income:
                exit(TMPExpectedTimeUnitData."Expected Production Amount");
            OptValue::Percentage:
                exit(TMPExpectedTimeUnitData."Expected Percentage");
        end;
    end;

    LOCAL procedure OnAfterGet();
    var
        i: Integer;
        j: Integer;
        PeriodNo: Integer;
        LastPeriod: Integer;
    begin
        DescriptionIndent := rec.Indentation;
        isHeading := (rec."Account Type" = rec."Account Type"::Heading);

        LastPeriod := 1;
        FOR i := 1 TO ARRAYLEN(MATRIX_CellData) DO begin
            if (rec."Account Type" = rec."Account Type"::Unit) then begin
                MATRIX_OnAfterGetRecord(i);
                if (TMPExpectedTimeUnitData.Performed) then begin
                    FOR j := 1 TO i DO
                        MATRIX_Performed[j] := TRUE;
                end ELSE
                    MATRIX_Performed[i] := FALSE;
            end ELSE begin
                MATRIX_OnAfterGetRecord_Zero(i);
                MATRIX_Performed[i] := TRUE;
            end;

            if (MatrixRecords[i]."Period Start" <> 0D) then
                LastPeriod := i;
        end;
        SetEditable;

        QuantityBudget := 0;
        QuantityPlanned := 0;
        QuantityPerformed := 0;
        QuantityToPlanned := 0;

        PreviousBalance := 0;  //-Q13646
        NextBalance := 0;
        if rec."Account Type" = rec."Account Type"::Unit then begin
            Rec.SETFILTER("Job No.", CodeJob);
            Rec.SETFILTER("Budget Filter", FilterBudget);

            TMPExpectedTimeUnitData.RESET;
            TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
            TMPExpectedTimeUnitData.SETRANGE("Job No.", CodeJob);
            TMPExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code");
            TMPExpectedTimeUnitData.SETFILTER("Budget Code", FilterBudget);
            if (TMPExpectedTimeUnitData.FINDSET) then
                repeat
                    //-Q13646
                    if (TMPExpectedTimeUnitData."Expected Date" < MatrixRecords[1]."Period Start") then begin
                        CASE OptValue OF
                            OptValue::Quantity:
                                PreviousBalance += TMPExpectedTimeUnitData."Expected Measured Amount";
                            OptValue::Expenses:
                                PreviousBalance += TMPExpectedTimeUnitData."Expected Cost Amount";
                            OptValue::Income:
                                PreviousBalance += TMPExpectedTimeUnitData."Expected Production Amount";
                            OptValue::Percentage:
                                PreviousBalance += TMPExpectedTimeUnitData."Expected Percentage";
                        end;
                    end;
                    if (TMPExpectedTimeUnitData."Expected Date" > MatrixRecords[LastPeriod]."Period end") then begin
                        CASE OptValue OF
                            OptValue::Quantity:
                                NextBalance += TMPExpectedTimeUnitData."Expected Measured Amount";
                            OptValue::Expenses:
                                NextBalance += TMPExpectedTimeUnitData."Expected Cost Amount";
                            OptValue::Income:
                                NextBalance += TMPExpectedTimeUnitData."Expected Production Amount";
                            OptValue::Percentage:
                                NextBalance += TMPExpectedTimeUnitData."Expected Percentage";
                        end;
                    end;

                    CASE OptValue OF
                        OptValue::Quantity:
                            QuantityPlanned += TMPExpectedTimeUnitData."Expected Measured Amount";
                        OptValue::Expenses:
                            QuantityPlanned += TMPExpectedTimeUnitData."Expected Cost Amount";
                        OptValue::Income:
                            QuantityPlanned += TMPExpectedTimeUnitData."Expected Production Amount";
                        OptValue::Percentage:
                            QuantityPlanned += TMPExpectedTimeUnitData."Expected Percentage";
                    end;

                    CASE OptValue OF
                        OptValue::Quantity:
                            QuantityBudget := TMPExpectedTimeUnitData."Budget Measure";
                        OptValue::Expenses:
                            QuantityBudget := TMPExpectedTimeUnitData."Budget Cost Amount";
                        OptValue::Income:
                            QuantityBudget := TMPExpectedTimeUnitData."Budget Sale Amount";
                        OptValue::Percentage:
                            QuantityBudget := 100;
                    end;
                until (TMPExpectedTimeUnitData.NEXT = 0);



            Job.GET(CodeJob);
            DataPieceworkForProduction := Rec;
            DataPieceworkForProduction."Budget Filter" := FilterBudget;
            Rec.COPYFILTER("Budget Filter", DataPieceworkForProduction."Budget Filter");
            if not JobBudget.GET(rec."Job No.", rec.GETFILTER("Budget Filter")) then
                CLEAR(JobBudget);

            CASE OptValue OF
                OptValue::Quantity:
                    begin
                        //DataPieceworkForProduction.CALCFIELDS("Budget Measure", "Total Measurement Production");
                        //QuantityPlanned := DataPieceworkForProduction."Budget Measure";

                        DataPieceworkForProduction.SETRANGE("Filter Date", 0D, JobBudget."Budget Date" - 1);
                        DataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                        //QuantityBudget := DataPieceworkForProduction."Budget Measure New";
                        QuantityPerformed := DataPieceworkForProduction."Total Measurement Production";
                    end;
                OptValue::Expenses:
                    begin
                        //DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                        //QuantityPlanned := DataPieceworkForProduction."Amount Cost Budget (JC)";

                        DataPieceworkForProduction.SETRANGE("Filter Date", 0D, JobBudget."Budget Date" - 1);
                        DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
                        //QuantityBudget := DataPieceworkForProduction."Amount Cost Budget (JC)";
                        QuantityPerformed := DataPieceworkForProduction."Amount Cost Performed (JC)";
                    end;
                OptValue::Income:
                    begin
                        //DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                        //QuantityPlanned := DataPieceworkForProduction."Amount Production Budget";

                        DataPieceworkForProduction.SETRANGE("Filter Date", 0D, JobBudget."Budget Date" - 1);
                        DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                        //QuantityBudget := DataPieceworkForProduction."Amount Production Budget";
                        QuantityPerformed := DataPieceworkForProduction."Amount Production Performed";
                    end;
                OptValue::Percentage:
                    begin
                        //DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                        //if DataPieceworkForProduction."Budget Measure" <> 0 then begin
                        //  QuantityBudget := 100;
                        //end ELSE begin
                        //  QuantityBudget := 0;
                        //end;

                        //DataPieceworkForProduction.CALCFIELDS("OLD_Percentage Planned Budget");
                        //QuantityPlanned := DataPieceworkForProduction."OLD_Percentage Planned Budget";
                        QuantityPerformed := 0;  //JAV 17/12/2018 - No pon�a a cero "Realizado" al sacarlo por porcentajes y dejaba cualquier valor anterior que tuviera
                    end;
            end;
        end;

        QuantityToPlanned := QuantityBudget - QuantityPerformed;
        QuantityPending := QuantityBudget - QuantityPlanned;
    end;

    procedure MATRIX_OnValidate(ColumnID: Integer);
    var
        Suma: Decimal;
        i: Integer;
        NewValue: Decimal;
    begin
        Suma := 0;
        FOR i := 1 TO ARRAYLEN(MATRIX_CellData) DO
            Suma += MATRIX_CellData[i];

        if (Suma > QuantityBudget) then
            ERROR(Text000, Suma - QuantityBudget, rec."Unit Of Measure");

        DataPieceworkForProduction := Rec;
        DataPieceworkForProduction."Budget Filter" := FilterBudget;
        DataPieceworkForProduction.SETRANGE("Filter Date");
        //Rec.COPYFILTER("Budget Filter", DataPieceworkForProduction."Budget Filter");

        DataPieceworkForProduction.CALCFIELDS("Budget Measure", "Amount Production Budget", "Amount Cost Budget (JC)");

        NewValue := 0;
        CASE OptValue OF
            OptValue::Quantity:
                NewValue := MATRIX_CellData[ColumnID];
            OptValue::Expenses:
                if (DataPieceworkForProduction."Amount Cost Budget (JC)" <> 0) then
                    NewValue := MATRIX_CellData[ColumnID] * DataPieceworkForProduction."Budget Measure" / DataPieceworkForProduction."Amount Cost Budget (JC)";
            OptValue::Income:
                if (DataPieceworkForProduction."Amount Production Budget" <> 0) then
                    NewValue := MATRIX_CellData[ColumnID] * DataPieceworkForProduction."Budget Measure" / DataPieceworkForProduction."Amount Production Budget";
            OptValue::Percentage:
                NewValue := MATRIX_CellData[ColumnID] * DataPieceworkForProduction."Budget Measure" / 100;
        end;

        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
        TMPExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code");
        TMPExpectedTimeUnitData.SETRANGE("Budget Code", FilterBudget);
        TMPExpectedTimeUnitData.SETRANGE("Expected Date", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period end");
        if (TMPExpectedTimeUnitData.FINDFIRST) then begin
            TMPExpectedTimeUnitData.VALIDATE("Expected Measured Amount", ROUND(NewValue, Decimales));
            TMPExpectedTimeUnitData.MODIFY(TRUE);
        end ELSE begin
            TMPExpectedTimeUnitData.INIT;
            TMPExpectedTimeUnitData."Entry No." := 0;
            TMPExpectedTimeUnitData."Job No." := rec."Job No.";
            TMPExpectedTimeUnitData."Piecework Code" := rec."Piecework Code";
            TMPExpectedTimeUnitData."Budget Code" := FilterBudget;
            TMPExpectedTimeUnitData."Expected Date" := MatrixRecords[ColumnID]."Period Start";
            TMPExpectedTimeUnitData.VALIDATE("Expected Measured Amount", ROUND(NewValue, Decimales));
            TMPExpectedTimeUnitData.INSERT(TRUE);
        end;
        OnAfterGet;
    end;

    LOCAL procedure AdjustDiferences(pOnlyOne: Boolean);
    var
        suma: Decimal;
        i: Integer;
        ok: Boolean;
    begin
        //JAV 03/05/22: - QB 1.10.38 Unificar los ajustes de diferencias entre las dos funciones que lo hacen
        OnAfterGet;
        suma := PreviousBalance + NextBalance;
        FOR i := 1 TO ARRAYLEN(MATRIX_CellData) DO
            suma += MATRIX_CellData[i];

        if (suma = QuantityBudget) then begin
            if (pOnlyOne) then
                MESSAGE(Text022);
            exit;
        end;

        if (pOnlyOne) or (ABS(suma - QuantityBudget) < 0.02) then begin
            TMPExpectedTimeUnitData.RESET;
            TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
            TMPExpectedTimeUnitData.SETRANGE("Job No.", CodeJob);
            TMPExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code");
            TMPExpectedTimeUnitData.SETFILTER("Budget Code", FilterBudget);
            if (not TMPExpectedTimeUnitData.FINDLAST) then begin
                MESSAGE(Text021);
                exit;
            end;

            if (pOnlyOne) then
                ok := CONFIRM(Text020, TRUE, TMPExpectedTimeUnitData."Expected Date", QuantityBudget - suma, rec."Unit Of Measure")
            ELSE
                ok := TRUE;

            if (ok) then begin
                TMPExpectedTimeUnitData."Expected Measured Amount" += QuantityBudget - suma;
                TMPExpectedTimeUnitData.MODIFY;
                OnAfterGet;
            end;
        end;
    end;

    // begin
    /*{
      JAV 17/12/18: - No pon�a a cero "Realizado" al sacarlo por porcentajes y dejaba cualquier valor anterior que tuviera
      PGM 11/09/19: - Se comprueba si es un estudio o un proyecto operativo
      JAV 22/06/21: - QB 1.09.01 Se a�ade el filtro de tipo de U.O.
      DGG 05/07/21: - Q13646: Se A�aden las columnas "Saldo anterior" y Saldo siguienet.
                              Se modifica el dise�o de las columnas para que se muestren solo las que tengan caption.
                              Se modifica para que de error si se selecciona la opci�n para los porcentajes.
      AML 03/05/22: - QB 1.10.38 Ajusta las peque�as diferencias de todas las l�neas en el �ltimo periodo existente en la tabla temporal
      JAV 03/05/22: - QB 1.10.38 Unificar los ajustes de diferencias entre las dos funciones que lo hacen
    }*///end
}








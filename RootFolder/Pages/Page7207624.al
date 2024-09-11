page 7207624 "Planning Pieceworks MSP Mtrx"
{
    Editable = false;
    CaptionML = ENU = 'Planning Pieceworks MSP Matrix', ESP = 'Planif. unid. de obra MSP Mtrx';
    SourceTable = 7207386;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                FreezeColumn = "PptoTotal";
                field("Cod. unidad de obra"; rec."Piecework Code")
                {

                    CaptionML = ESP = 'C�d. unidad de obra';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Descripcion"; rec."Description")
                {

                    CaptionML = ESP = 'Descripci�n';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("PptoTotal"; AmountVar)
                {

                    CaptionML = ESP = 'Ppto. Total';
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
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = 'Approve', ESP = 'Apr&obar';
                Image = Confirm;
                trigger OnAction()
                VAR
                    recPlanificacionUO: Record 7207388;
                    Text50000: TextConst ESP='Se borrar� la planificaci�n de U.O. anterior. �Desea aprobar la planificaci�n de MSP';
                    // recPlanificacionUOTemp: Record 7207389;
                    recPlanificacionUOTemp: Record 7207389;
                    intUltNumMov: Integer;
                    // recPlanificacionUONuevosMSP: Record 7207388;
                    recPlanificacionUONuevosMSP: Record 7207388;
                    Text50001: TextConst ESP='No hay datos de Microsoft Project pendientes de procesar';
                    DiaVetana: Dialog;
                    // recDUO: Record 7207386;
                    recDUO: Record 7207386;
                    locrecJob: Record 167;
                    locdecPlanificadoaprobacion: Decimal;
                BEGIN
                    FunAprobar;
                END;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        QtyType := QtyType::"Net Change";

        Rec.SETFILTER("Job No.", CodJob);
        Rec.SETFILTER("Budget Filter", BudgetFilter);
    END;

    trigger OnAfterGetRecord()
    VAR
        MATRIX_CurrentColumnOrdinal: Integer;
        MATRIX_NoOfColumns: Integer;
    BEGIN
        MATRIX_CurrentColumnOrdinal := 1;
        MATRIX_NoOfColumns := ARRAYLEN(MATRIX_CellData);

        WHILE (MATRIX_CurrentColumnOrdinal <= MATRIX_NoOfColumns) DO BEGIN
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
        END;

        Rec.SETFILTER("Job No.", CodJob);
        Rec.SETFILTER("Budget Filter", BudgetFilter);

        DataJobUnitForProduction := Rec;
        DataJobUnitForProduction."Job No." := CodJob;
        DataJobUnitForProduction."Budget Filter" := BudgetFilter;
        DataJobUnitForProduction.CALCFIELDS("Measurement Budget MSP");
        OnFormatPieceworkCode;
        OnFormatAmount;
    END;



    var
        AccountingPeriod: Record 50;
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        ForecastDataAmountsJU: Record 7207392;
        Job: Record 167;
        JobBudget: Record 7207407;
        DataJobUnitForProduction: Record 7207386;
        TMPExpectedTimeUnitData: Record 7207389;
        PeriodFormManagement: Codeunit 50324;
        ConvertToBudgetxCA: Codeunit 7207282;
        PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
        QtyType: Option "Net Change","Balance at Date";
        codepptoencurso: Code[20];
        CodJob: Code[20];
        BudgetFilter: Code[20];
        MATRIX_ColumnCaption: ARRAY[32] OF Text[1024];
        decValor: Decimal;
        MATRIX_CellData: ARRAY[32] OF Decimal;
        decPendienteplanificar: Decimal;
        decCantidadaplanificar: Decimal;
        decCantidadppto: Decimal;
        decCantidadrealizada: Decimal;
        AmountVar: Decimal;
        ProyectoOVersión: Boolean;
        "Cod. unidad de obraEmphasize": Boolean;
        PptoTotalEmphasize: Boolean;
        intAprobar: Integer;
        dateFechareferencia: Date;
        Text001: TextConst ESP = 'Se ha sobrepasado la medici�n presupuestada para esta unidad de obra';
        Text002: TextConst ESP = 'Se ha sobrepasado el coste presupuestado para esta unidad de obra';
        Text003: TextConst ESP = 'Se ha sobrepasado la producci�n presupuestada para esta unidad de obra';
        Text50000: TextConst ESP = '"Recuerde aprobar la planificaci�n.�Desea salir sin aprobar? "';
        Text004: TextConst ESP = 'La unidad de obra/coste %1 no esta totalmente planificada';
        Text005: TextConst ESP = 'No se pueden modificar datos para registros cuyo Tipo Mov. es Mayor.';
        Text006: TextConst ESP = 'Procesando datos de planificaci�n';

    LOCAL procedure SetDateFilter(ColumnID: Integer);
    begin
        if QtyType = QtyType::"Net Change" then
            if MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period end" then
                Rec.SETRANGE("Filter Date", MatrixRecords[ColumnID]."Period Start")
            ELSE
                Rec.SETRANGE("Filter Date", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period end")
        ELSE
            Rec.SETRANGE("Filter Date", 0D, MatrixRecords[ColumnID]."Period end")
    end;

    procedure Load(var MatrixColumns1: ARRAY[32] OF Text[1024]; var MatrixRecords1: ARRAY[32] OF Record 2000000007; QtyType1: Option "Day","Week","Month","Quarter","Year","Accounting Period"; CodJob1: Code[20]; BudgetFilter1: Code[20]);
    begin
        COPYARRAY(MATRIX_ColumnCaption, MatrixColumns1, 1);
        COPYARRAY(MatrixRecords, MatrixRecords1, 1);
        QtyType := QtyType1;
        CodJob := CodJob1;
        BudgetFilter := BudgetFilter1;
    end;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
        Rec.SETRANGE("Filter Date", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period end");

        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
        TMPExpectedTimeUnitData.SETFILTER("Job No.", CodJob);
        if rec."Account Type" = rec."Account Type"::Unit then
            TMPExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code")
        ELSE
            TMPExpectedTimeUnitData.SETFILTER("Piecework Code", rec.Totaling);
        TMPExpectedTimeUnitData.SETFILTER("Budget Code", BudgetFilter);
        TMPExpectedTimeUnitData.SETFILTER("Expected Date", rec.GETFILTER("Filter Date"));
        PAGE.RUNMODAL(PAGE::"Schedule MSP", TMPExpectedTimeUnitData);
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord(ColumnID: Integer);
    var
        AmountVar: Decimal;
    begin
        SetDateFilter(ColumnID);
        Rec.SETFILTER("Job No.", CodJob);
        Rec.SETFILTER("Budget Filter", BudgetFilter);

        DataJobUnitForProduction := Rec;
        DataJobUnitForProduction."Job No." := CodJob;
        DataJobUnitForProduction."Budget Filter" := BudgetFilter;
        DataJobUnitForProduction.CALCFIELDS(DataJobUnitForProduction."Measurement Budget MSP");
        AmountVar := DataJobUnitForProduction."Measurement Budget MSP";

        Rec.CALCFIELDS("Measurement Budget MSP");

        MATRIX_CellData[ColumnID] := rec."Measurement Budget MSP";
    end;

    procedure FunAprobar();
    var
        ExpectedTimeUnitData: Record 7207388;
        ExpectedTimeUnitDataNewMSP: Record 7207388;
        recDUO: Record 7207386;
        Text50000: TextConst ESP = 'Se borrar� la planificaci�n de U.O. anterior. �Desea aprobar la planificaci�n de MSP?';
        Text50001: TextConst ESP = 'No hay datos de Microsoft Project pendientes de procesar';
        DialogWindow: Dialog;
        LastNumEntry: Integer;
    begin
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
        TMPExpectedTimeUnitData.SETRANGE("Job No.", CodJob);
        if not TMPExpectedTimeUnitData.FINDFIRST then
            ERROR(Text50001);

        if Job.GET(CodJob) then
            Job.JobStatus(CodJob);

        if CONFIRM(Text50000) then begin
            DialogWindow.OPEN(Text001);
            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY(ExpectedTimeUnitData."Entry No.");
            if ExpectedTimeUnitData.FINDLAST then
                LastNumEntry := ExpectedTimeUnitData."Entry No."
            ELSE
                LastNumEntry := 0;


            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Job No.", CodJob);
            if TMPExpectedTimeUnitData.FINDFIRST then begin
                repeat
                    ExpectedTimeUnitData.SETRANGE("Budget Code", TMPExpectedTimeUnitData."Budget Code");
                    ExpectedTimeUnitData.SETRANGE("Piecework Code", TMPExpectedTimeUnitData."Piecework Code");
                    ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                    if ExpectedTimeUnitData.FINDFIRST then
                        ExpectedTimeUnitData.DELETEALL;
                until TMPExpectedTimeUnitData.NEXT = 0;
            end;

            if TMPExpectedTimeUnitData.FINDFIRST then begin
                repeat
                    ExpectedTimeUnitDataNewMSP.TRANSFERFIELDS(TMPExpectedTimeUnitData);
                    LastNumEntry := LastNumEntry + 1;
                    ExpectedTimeUnitDataNewMSP."Entry No." := LastNumEntry;
                    ExpectedTimeUnitDataNewMSP."Budget Code" := TMPExpectedTimeUnitData."Budget Code";
                    if recDUO.GET(TMPExpectedTimeUnitData."Job No.", TMPExpectedTimeUnitData."Piecework Code") then begin
                        ExpectedTimeUnitDataNewMSP.INSERT;
                    end;
                until TMPExpectedTimeUnitData.NEXT = 0;
                TMPExpectedTimeUnitData.DELETEALL;
            end;
        end;
    end;

    LOCAL procedure OnFormatPieceworkCode();
    begin
        "Cod. unidad de obraEmphasize" := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure OnFormatAmount();
    begin
        PptoTotalEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    // begin//end
}








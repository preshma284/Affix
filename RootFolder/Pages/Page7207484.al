page 7207484 "Budget Forecast CA Matrix"
{
    Editable = false;
    CaptionML = ENU = 'Budget Forecast CA Matrix', ESP = 'Previsi�n ppto. CA Matrix';
    SourceTable = 7207316;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                IndentationControls = Descripcion;
                FreezeColumn = "Descripcion";
                field("Concepto analitico"; rec."Analytical concept")
                {

                    CaptionML = ESP = 'Concepto anal�tico';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Descripcion"; rec."Description")
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Field1"; MATRIX_CellData[1])
                {

                    DrillDown = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    DrillDownPageID = "Budget Forecast Mov. CA";

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
        Rec.SETFILTER("Job No.", CodProyecto);
        Rec.SETFILTER("Reestimation Code", CodReestimacion);
        Rec.CALCFIELDS("Estimated outstanding amount");
    END;

    trigger OnAfterGetRecord()
    VAR
        MATRIX_CurrentColumnOrdinal: Integer;
        MATRIX_NoOfColumns: Integer;
    BEGIN
        DescripcionIndent := 0;
        MATRIX_CurrentColumnOrdinal := 1;
        MATRIX_NoOfColumns := ARRAYLEN(MATRIX_CellData);

        WHILE (MATRIX_CurrentColumnOrdinal <= MATRIX_NoOfColumns) DO BEGIN
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
        END;
        Conceptoanal237ticoOnFormat;
        Descripci243nOnFormat;
    END;



    var
        MATRIX_CellData: ARRAY[32] OF Decimal;
        MATRIX_ColumnCaption: ARRAY[32] OF Text[1024];
        CodProyecto: Code[20];
        CodReestimacion: Code[20];
        DescripcionIndent: Integer;
        AmountType: Option "Net Change","Balance at Date";
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        MovBudgetForecast: Record 7207319;
        DimensionValue: Record 349;
        "Concepto analiticoEmphasize": Boolean;

    LOCAL procedure SetDateFilter(ColumnID: Integer);
    begin
        if AmountType = AmountType::"Net Change" then
            if MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period end" then
                Rec.SETRANGE("Date filter", MatrixRecords[ColumnID]."Period Start")
            ELSE
                Rec.SETRANGE("Date filter", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period end")
        ELSE
            Rec.SETRANGE("Date filter", 0D, MatrixRecords[ColumnID]."Period end");
    end;

    procedure Load(var MatrixColumns1: ARRAY[32] OF Text[1024]; var MatrixRecords1: ARRAY[32] OF Record 2000000007; AmountType1: Option "Net Change","Balance at Date"; CodProyecto1: Code[20]; CodReestimacion1: Code[20]);
    begin
        COPYARRAY(MATRIX_ColumnCaption, MatrixColumns1, 1);
        COPYARRAY(MatrixRecords, MatrixRecords1, 1);
        AmountType := AmountType1;
        CodProyecto := CodProyecto1;
        CodReestimacion := CodReestimacion1;
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord(ColumnID: Integer);
    begin
        Rec.SETFILTER("Job No.", CodProyecto);
        Rec.SETFILTER("Reestimation Code", CodReestimacion);
        SetDateFilter(ColumnID);
        Rec.CALCFIELDS("Estimated outstanding amount");
        MATRIX_CellData[ColumnID] := rec."Estimated outstanding amount";
    end;

    LOCAL procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer);
    begin
        SetDateFilter(MATRIX_ColumnOrdinal);
        MovBudgetForecast.SETCURRENTKEY("Job No.", "Document No.", "Line No.", "Anality Concept Code",
          "Reestimation code", "Forecast Date");
        MovBudgetForecast.SETRANGE("Job No.", rec."Job No.");
        MovBudgetForecast.SETRANGE("Document No.", rec."Document No.");
        MovBudgetForecast.SETRANGE("Line No.", rec."Line No.");
        MovBudgetForecast.SETRANGE("Anality Concept Code", rec."Analytical concept");
        MovBudgetForecast.SETRANGE("Reestimation Code", rec."Reestimation Code");
        MovBudgetForecast.SETFILTER("Forecast Date", Rec.GETFILTER("Date filter"));
        PAGE.RUN(PAGE::"Budget Forecast Mov. CA", MovBudgetForecast);
    end;

    LOCAL procedure Conceptoanal237ticoOnFormat();
    begin
        DimensionValue.GET('CA', rec."Analytical concept");
        "Concepto analiticoEmphasize" := DimensionValue."Dimension Value Type" <> DimensionValue."Dimension Value Type"::Standard;
    end;

    LOCAL procedure Descripci243nOnFormat();
    begin
        DimensionValue.GET('CA', rec."Analytical concept");
        DescripcionIndent := DimensionValue.Indentation * 220;
    end;

    // begin//end
}








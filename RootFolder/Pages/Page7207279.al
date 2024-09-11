page 7207279 "Budget by CA"
{
    CaptionML = ENU = 'Budget by CA', ESP = 'Presupuesto por CA';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    DataCaptionExpression = BudgetName;
    PageType = ListPlus;

    layout
    {
        area(content)
        {
            group("group17")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("BudgetName"; BudgetName)
                {

                    CaptionML = ENU = 'Budget Name', ESP = 'Nombre ppto.';
                    TableRelation = "G/L Budget Name";
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        ValidateBudgetName;
                        ValidateLineDimCode;
                        ValidateColumnDimCode;

                        UpdateMatrixSubform;
                        BudgetNameOnAfterValidate;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    VAR
                        GLBudgetNames: Page 121;
                    BEGIN
                        GLBudgetNames.LOOKUPMODE := TRUE;
                        GLBudgetNames.SETRECORD(GLBudgetName);
                        IF GLBudgetNames.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            GLBudgetNames.GETRECORD(GLBudgetName);
                            BudgetName := GLBudgetName.Name;
                            Text := GLBudgetName.Name;
                            ValidateBudgetName;
                            ValidateLineDimCode;
                            ValidateColumnDimCode;
                            CurrPage.UPDATE;
                            EXIT(TRUE);
                        END ELSE BEGIN
                            ValidateBudgetName;
                            ValidateLineDimCode;
                            ValidateColumnDimCode;
                            CurrPage.UPDATE;
                            EXIT(FALSE);
                        END;
                    END;


                }
                field("LineDimCode"; LineDimCode)
                {

                    CaptionML = ENU = 'Show as Lines', ESP = 'Muestra como l�neas';
                    Visible = False;

                    ; trigger OnValidate()
                    VAR
                        MATRIX_SetWanted: Option "First","Previous","Same","Next";
                    BEGIN
                        IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
                            ColumnDimCode := '';
                            ValidateColumnDimCode;
                        END;
                        ValidateLineDimCode;
                        MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::First);
                        LineDimCodeOnAfterValidate;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    VAR
                        NewCode: Text[30];
                    BEGIN
                        NewCode := GetDimSelection(LineDimCode);
                        IF NewCode = LineDimCode THEN
                            EXIT(FALSE)
                        ELSE BEGIN
                            Text := NewCode;
                            LineDimCode := NewCode;
                            ValidateLineDimCode;
                            CurrPage.UPDATE;
                            EXIT(TRUE);
                        END
                    END;


                }
                field("ColumnDimCode"; ColumnDimCode)
                {

                    CaptionML = ENU = 'Show as Columns', ESP = 'Muestra como columnas';

                    ; trigger OnValidate()
                    BEGIN
                        IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
                            LineDimCode := '';
                            ValidateLineDimCode;
                        END;
                        ValidateColumnDimCode;
                        MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
                        ColumnDimCodeOnAfterValidate;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    VAR
                        NewCode: Text[30];
                    BEGIN
                        NewCode := GetDimSelection(ColumnDimCode);
                        IF NewCode = ColumnDimCode THEN
                            EXIT(FALSE)
                        ELSE BEGIN
                            Text := NewCode;
                            ColumnDimCode := NewCode;
                            ValidateColumnDimCode;
                            CurrPage.UPDATE;
                            EXIT(TRUE);
                            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
                        END;
                    END;


                }
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'View by', ESP = 'Ver por';
                    OptionCaptionML = ENU = 'View by', ESP = 'Ver por';
                    Enabled = PeriodTypeEnable;

                    ; trigger OnValidate()
                    BEGIN
                        FindPeriod('');
                        PeriodTypeOnAfterValidate;
                    END;


                }
                field("RoundingFactor"; RoundingFactor)
                {

                    CaptionML = ENU = 'Rounding Factor', ESP = 'Factor redondeo';
                    OptionCaptionML = ENU = 'Rounding Factor', ESP = 'Factor redondeo';

                    ; trigger OnValidate()
                    BEGIN
                        UpdateMatrixSubform;
                    END;


                }
                field("ShowColumnName"; ShowColumnName)
                {

                    CaptionML = ENU = 'Show Column Name', ESP = 'Muestra nombre columna';

                    ; trigger OnValidate()
                    BEGIN
                        ShowColumnNameOnPush;
                    END;


                }

            }
            part("MatrixForm"; 7207483)
            {
                ;
            }
            group("group25")
            {

                CaptionML = ENU = 'Filter', ESP = 'Filtros';
                field("DateFilter"; DateFilter)
                {

                    CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';

                    ; trigger OnValidate()
                    VAR
                        ApplicationManagement: Codeunit "TextManagement 1";
                    BEGIN
                        IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
                        GLAccBudgetBuffer.SETFILTER("Date Filter", DateFilter);
                        DateFilter := GLAccBudgetBuffer.GETFILTER("Date Filter");
                        InternalDateFilter := DateFilter;
                        DateFilterOnAfterValidate;
                    END;


                }
                field("GLAccFilter"; GLAccFilter)
                {

                    CaptionML = ENU = 'Account Filter', ESP = 'Filtro cuenta';

                    ; trigger OnValidate()
                    BEGIN
                        GLAccFilterOnAfterValidate;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    VAR
                        GLAccountList: Page 18;
                    BEGIN
                        GLAccountList.LOOKUPMODE(TRUE);
                        IF NOT (GLAccountList.RUNMODAL = ACTION::LookupOK) THEN
                            EXIT(FALSE)
                        ELSE
                            Text := GLAccountList.GetSelectionFilter;
                        EXIT(TRUE);
                    END;


                }
                field("GlobalDim1Filter"; GlobalDim1Filter)
                {

                    CaptionML = ENU = 'Global Dimension 1 Filter', ESP = 'Filtro dimensi�n global 1';
                    CaptionClass = '1,3,1';
                    Enabled = GlobalDim1FilterEnable;
                    Editable = GlobalDim1FilterEditable;

                    ; trigger OnValidate()
                    BEGIN
                        GlobalDim1FilterOnAfterValidat;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        EXIT(LookUpDimFilter(GeneralLedgerSetup."Global Dimension 1 Code", Text));
                    END;


                }
                field("GlobalDim2Filter"; GlobalDim2Filter)
                {

                    CaptionML = ENU = 'Global Dimension 2 Filter', ESP = 'Filtro dimensi�n global 2';
                    CaptionClass = '1,3,2';
                    Enabled = GlobalDim2FilterEnable;
                    Editable = GlobalDim2FilterEditable;

                    ; trigger OnValidate()
                    BEGIN
                        GlobalDim2FilterOnAfterValidat;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        EXIT(LookUpDimFilter(GeneralLedgerSetup."Global Dimension 2 Code", Text));
                    END;


                }
                field("BudgetDim1Filter"; BudgetDim1Filter)
                {

                    CaptionML = ENU = 'Budget Dimension 1 Filter', ESP = 'Filtro dim. presupuesto 1';
                    CaptionClass = GetCaptionClass(1);
                    Enabled = BudgetDim1FilterEnable;
                    Editable = BudgetDim1FilterEditable;

                    ; trigger OnValidate()
                    BEGIN
                        BudgetDim1FilterOnAfterValidat;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        EXIT(LookUpDimFilter(GLBudgetName."Budget Dimension 1 Code", Text));
                    END;


                }
                field("BudgetDim2Filter"; BudgetDim2Filter)
                {

                    CaptionML = ENU = 'Busget Dimension 2 �Filter', ESP = 'Filtro dim. presupuesto 2';
                    CaptionClass = GetCaptionClass(2);
                    Enabled = BudgetDim2FilterEnable;

                    ; trigger OnValidate()
                    BEGIN
                        BudgetDim2FilterOnAfterValidat;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        EXIT(LookUpDimFilter(GLBudgetName."Budget Dimension 2 Code", Text));
                    END;


                }
                field("BudgetDim3Filter"; BudgetDim3Filter)
                {

                    CaptionML = ENU = 'Budget Dimension 3 Filter', ESP = 'Filtro dim. presupuesto 3';
                    CaptionClass = GetCaptionClass(3);
                    Enabled = BudgetDim3FilterEnable;
                    Editable = BudgetDim3FilterEditable;

                    ; trigger OnValidate()
                    BEGIN
                        BudgetDim3FilterOnAfterValidat;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        EXIT(LookUpDimFilter(GLBudgetName."Budget Dimension 3 Code", Text));
                    END;


                }
                field("BudgetDim4Filter"; BudgetDim4Filter)
                {

                    CaptionML = ENU = 'Budget Dimensions 4 Filter', ESP = 'Filtro dim. presupuesto 4';
                    CaptionClass = GetCaptionClass(4);
                    Enabled = BudgetDim4FilterEnable;
                    Editable = BudgetDim4FilterEditable;



                    ; trigger OnValidate()
                    BEGIN
                        BudgetDim4FilterOnAfterValidat;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        EXIT(LookUpDimFilter(GLBudgetName."Budget Dimension 4 Code", Text));
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
                CaptionML = ENU = 'F&unctions', ESP = 'Acciones';
                action("action1")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Copy Budget', ESP = 'Copiar presupuesto';
                    RunObject = Report 96;
                    Image = CopyBudget;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Delete Budget', ESP = 'Borrar presupuesto';
                    Image = Delete;

                    trigger OnAction()
                    BEGIN
                        DeleteBudget;
                    END;


                }
                separator("separator3")
                {

                }
                action("action4")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Export to Excel', ESP = 'Exportar ppto. a Excel';
                    Image = ExportToExcel;

                    trigger OnAction()
                    BEGIN
                        GLBudgetEntry.SETFILTER("Budget Name", BudgetName);
                        GLBudgetEntry.SETFILTER("Business Unit Code", BusUnitFilter);
                        GLBudgetEntry.SETFILTER("G/L Account No.", GLAccFilter);
                        GLBudgetEntry.SETFILTER("Global Dimension 1 Code", GlobalDim1Filter);
                        GLBudgetEntry.SETFILTER("Global Dimension 2 Code", GlobalDim2Filter);
                        GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", BudgetDim1Filter);
                        GLBudgetEntry.SETFILTER("Budget Dimension 2 Code", BudgetDim2Filter);
                        GLBudgetEntry.SETFILTER("Budget Dimension 3 Code", BudgetDim3Filter);
                        GLBudgetEntry.SETFILTER("Budget Dimension 4 Code", BudgetDim4Filter);
                        REPORT.RUN(REPORT::"Export Budget to Excel", TRUE, FALSE, GLBudgetEntry);
                    END;


                }
                action("action5")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Import Budget From Excel', ESP = 'Importar ppto. a Excel';
                    Image = ImportExcel;

                    trigger OnAction()
                    VAR
                        ImportBudgetfromExcel: Report 81;
                    BEGIN
                        //JAV 05/07/22: - QB 1.10.59 Se cambia la llamada a la funci�n propia para poner el presupuesto, que no funciona, por la est�ndar del informe que importa la Excel que si lo hace
                        CLEAR(ImportBudgetfromExcel);  //Por seguridad ssiempe hay que hacer el clear para que no de errores
                                                       //ImportBudgetfromExcel.SetGLBudgetName(BudgetName);
                        ImportBudgetfromExcel.SetParameters(BudgetName, 0);
                        ImportBudgetfromExcel.RUNMODAL;
                    END;


                }
                separator("separator6")
                {

                }
                action("action7")
                {
                    CaptionML = ENU = 'Reverse Line and Columnas', ESP = 'Invertir l�neas y columnas';
                    Visible = False;
                    Image = Reserve;

                    trigger OnAction()
                    VAR
                        TempDimCode: Text[30];
                    BEGIN
                        TempDimCode := ColumnDimCode;
                        ColumnDimCode := LineDimCode;
                        LineDimCode := TempDimCode;
                        ValidateLineDimCode;
                        ValidateColumnDimCode;

                        MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
                        UpdateMatrixSubform;
                    END;


                }

            }
            action("action8")
            {
                CaptionML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                Image = NextRecord;

                trigger OnAction()
                BEGIN
                    IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                        EXIT;
                    FindPeriod('>');
                    CurrPage.UPDATE;
                    UpdateMatrixSubform;
                END;


            }
            action("action9")
            {
                CaptionML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                Image = PreviousRecord;

                trigger OnAction()
                BEGIN
                    IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                        EXIT;
                    FindPeriod('<');
                    CurrPage.UPDATE;
                    UpdateMatrixSubform;
                END;


            }
            action("action10")
            {
                CaptionML = ENU = 'Previous Set', ESP = 'Conjunto anterior';
                ToolTipML = ENU = 'Previous Set', ESP = 'Conjunto anterior';
                Image = PreviousSet;

                trigger OnAction()
                BEGIN
                    MATRIX_GenerateColumnCaptions(MATRIX_Step::Previous);
                    UpdateMatrixSubform;
                END;


            }
            action("action11")
            {
                CaptionML = ENU = 'Previous Column', ESP = 'Columna anterior';
                Image = PreviousRecord;

                trigger OnAction()
                BEGIN
                    MATRIX_GenerateColumnCaptions(MATRIX_Step::PreviousColumn);
                    UpdateMatrixSubform;
                END;


            }
            action("action12")
            {
                CaptionML = ENU = 'Next Column', ESP = 'Columna siguiente';
                Image = NextRecord;

                trigger OnAction()
                BEGIN
                    MATRIX_GenerateColumnCaptions(MATRIX_Step::Next);
                    UpdateMatrixSubform;
                END;


            }
            action("action13")
            {
                CaptionML = ENU = 'Next Set', ESP = 'Conjunto siguiente';
                ToolTipML = ENU = 'Next Set', ESP = 'Conjunto siguiente';
                Image = NextSet;


                trigger OnAction()
                BEGIN
                    MATRIX_GenerateColumnCaptions(MATRIX_Step::Next);
                    UpdateMatrixSubform;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        BudgetDim4FilterEnable := TRUE;
        BudgetDim3FilterEnable := TRUE;
        BudgetDim2FilterEnable := TRUE;
        BudgetDim1FilterEnable := TRUE;
        PeriodTypeEnable := TRUE;
        GlobalDim2FilterEnable := TRUE;
        GlobalDim1FilterEnable := TRUE;
        GlobalDim2FilterEditable := TRUE;
        GlobalDim1FilterEditable := TRUE;
        BudgetDim4FilterEditable := TRUE;
        BudgetDim3FilterEditable := TRUE;
        BudgetDim1FilterEditable := TRUE;
    END;

    trigger OnOpenPage()
    VAR
        PosDim1: Boolean;
        PosDim2: Boolean;
    BEGIN
        //JAV 05/08/19: - La funci�n Rec.SETPERMISSIONFILTER esta obsoleta
        //GLAccBudgetBuffer.SETPERMISSIONFILTER;

        IF GLAccBudgetBuffer.GETFILTER("Global Dimension 1 Filter") <> '' THEN
            GlobalDim1Filter := GLAccBudgetBuffer.GETFILTER("Global Dimension 1 Filter");
        IF GLAccBudgetBuffer.GETFILTER("Global Dimension 2 Filter") <> '' THEN
            GlobalDim2Filter := GLAccBudgetBuffer.GETFILTER("Global Dimension 2 Filter");

        GeneralLedgerSetup.GET;

        GlobalDim1FilterEnable :=
          (GeneralLedgerSetup."Global Dimension 1 Code" <> '') AND
          (GLAccBudgetBuffer.GETFILTER("Global Dimension 1 Filter") = '');
        GlobalDim2FilterEnable :=
          (GeneralLedgerSetup."Global Dimension 2 Code" <> '') AND
          (GLAccBudgetBuffer.GETFILTER("Global Dimension 2 Filter") = '');

        //Se establecen el presupuesto para proyectos y la forma de establcerlos por CA
        //Si es versi�n debemos abrir el form con el Nombre presupuesto el config. en HP
        IF IsVersion THEN
            BudgetName := FunctionQB.ReturnBudgetQuote
        ELSE
            BudgetName := FunctionQB.ReturnBudgetJobs;
        LineDimCode := FunctionQB.ReturnDimCA;

        IF IsVersion THEN BEGIN
            IF Contrast THEN
                ColumnDimCode := FunctionQB.ReturnDimQuote
            ELSE
                ColumnDimCode := Text001;
        END ELSE
            ColumnDimCode := Text001;

        ValidateBudgetName;
        ValidateLineDimCode;
        ValidateColumnDimCode;


        // Se pone no editable el departamento
        PosDim1 := (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1);
        PosDim2 := (FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2);
        GlobalDim1FilterEditable := NOT PosDim1;
        GlobalDim2FilterEditable := NOT PosDim2;

        // CurrForm.GlobalDim1Filter.EDITABLE(NOT (FunctionQB.funGetPosDim(FunctionQB.DevolverDimDpto) = 1));
        // CurrForm.GlobalDim2Filter.EDITABLE(NOT (FunctionQB.funGetPosDim(FunctionQB.DevolverDimDpto) = 2));

        IF IsVersion THEN
            DimJob := FunctionQB.ReturnDimQuote
        ELSE
            DimJob := FunctionQB.ReturnDimJobs;
        BDimJob := FALSE;

        recCodDim.RESET;
        recNameJob.RESET;
        recNameJob.GET(BudgetName);

        IF recNameJob."Budget Dimension 1 Code" = DimJob THEN BEGIN
            BDimJob := TRUE;
            BudgetDim1Filter := NumJob;
            BudgetDim2Filter := Reest;  //copiamos en el filtro 2 que es fijo el valor de la reestimaci�n del filtro con el que ha pasado
            GlobalDim1Filter := Dpto;
            GLAccBudgetBuffer.SETFILTER("Budget Dimension 1 Filter", NumJob);
            GLAccBudgetBuffer.SETFILTER(GLAccBudgetBuffer."Global Dimension 1 Filter", Dpto);
            BudgetDim1FilterEditable := FALSE;
        END;

        IF recNameJob."Budget Dimension 3 Code" = DimJob THEN BEGIN
            BDimJob := TRUE;
            BudgetDim3Filter := NumJob;
            BudgetDim2Filter := Reest; //por si acaso el proyecto toma valor 3 llevamos el valor 2 de la reestimacion
            GlobalDim1Filter := Dpto;
            GLAccBudgetBuffer.SETFILTER("Budget Dimension 3 Filter", NumJob);
            GLAccBudgetBuffer.SETFILTER(GLAccBudgetBuffer."Global Dimension 1 Filter", Dpto);
            BudgetDim3FilterEditable := FALSE;
        END;

        IF recNameJob."Budget Dimension 4 Code" = DimJob THEN BEGIN
            BDimJob := TRUE;
            BudgetDim4Filter := NumJob;
            BudgetDim2Filter := Reest;  //idem que para el resto de casos
            GlobalDim1Filter := Dpto;
            GLAccBudgetBuffer.SETFILTER("Budget Dimension 4 Filter", NumJob);
            GLAccBudgetBuffer.SETFILTER(GLAccBudgetBuffer."Global Dimension 1 Filter", Dpto);
            BudgetDim4FilterEditable := FALSE;
        END;

        LineDimOption := DimCodeToOption(LineDimCode);
        ColumnDimOption := DimCodeToOption(ColumnDimCode);

        FindPeriod('');
        MATRIX_GenerateColumnCaptions(MATRIX_Step::First);

        UpdateMatrixSubform;
    END;



    var
        MATRIX_CaptionFieldNo: Integer;
        MATRIX_PrimKeyFirstCaptionInCu: Text[80];
        MATRIX_CurrentNoOfColumns: Integer;
        MATRIX_Step: Option "First","Previous","Same","Next","PreviousColumn","NextColumn";
        GlobalDim1Filter: Code[250];
        GlobalDim2Filter: Code[250];
        BudgetDim1Filter: Code[250];
        BudgetDim2Filter: Code[250];
        BudgetDim3Filter: Code[250];
        BudgetDim4Filter: Code[250];
        MATRIX_CaptionSet: ARRAY[32] OF Text[80];
        MATRIX_CaptionRange: Text[80];
        MATRIX_MatrixRecords: ARRAY[12] OF Record 367;
        FirstColumn: Text[80];
        LastColumn: Text[80];
        ColumnDimCode: Text[30];
        Text001: TextConst ENU = 'Period', ESP = 'Periodo';
        ShowColumnName: Boolean;
        // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting","Period";
        PeriodType : Enum "Analysis Period Type";
        DateFilter: Text[30];
        PeriodTypeEnable: Boolean;
        BudgetDim1FilterEditable: Boolean;
        BudgetDim3FilterEditable: Boolean;
        BudgetDim4FilterEditable: Boolean;
        GlobalDim1FilterEditable: Boolean;
        GlobalDim2FilterEditable: Boolean;
        GlobalDim1FilterEnable: Boolean;
        GlobalDim2FilterEnable: Boolean;
        BudgetDim1FilterEnable: Boolean;
        BudgetDim2FilterEnable: Boolean;
        BudgetDim3FilterEnable: Boolean;
        BudgetDim4FilterEnable: Boolean;
        GLAccFilter: Code[250];
        BusUnitFilter: Code[250];
        GeneralLedgerSetup: Record 98;
        GLBudgetName: Record 95;
        InternalDateFilter: Text[30];
        LineDimOption: Option "G/L Account","Period","Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        ColumnDimOption: Option "G/L Account","Period","Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";
        LineDimCode: Text[30];
        FunctionQB: Codeunit 7207272;
        Text003: TextConst ENU = 'Do you want to Rec.DELETE the budget entries shown?', ESP = '�Quiere borrar los movs. presupuest. mostrados?';
        BudgetName: Code[10];
        Text004: TextConst ENU = 'DEFAULT', ESP = 'GENERICO';
        Text005: TextConst ENU = 'Default budget', ESP = 'Ppto. gen�rico';
        GLAccBudgetBuffer: Record 374;
        PrevGLBudgetName: Record 95;
        Text006: TextConst ENU = '%1 is not a valid line definition.', ESP = '%1 no es una def. de l�nea v�lida.';
        Text007: TextConst ENU = '%1 is not a valid column definition.', ESP = '%1 no es una def. de columna v�lida.';
        Text008: TextConst ENU = '1,6,Budget Dimension 1 Filter', ESP = '1,6,Filtro dimensi�n presupuesto 1';
        Text009: TextConst ENU = '1,6,Budget Dimension 2 Filter', ESP = '1,6,Filtro dimensi�n presupuesto 2';
        Text010: TextConst ENU = '1,6,Budget Dimension 3 Filter', ESP = '1,6,Filtro dimensi�n presupuesto 3';
        Text011: TextConst ENU = '1,6,Budget Dimension 4 Filter', ESP = '1,6,Filtro dimensi�n presupuesto 4';
        Text012: TextConst ENU = 'You can not specify the Analytic Concept dimension in the columns', ESP = 'No puede especificar la dimensi�n Concepto Anal�tico en las columnas';
        NewBudgetName: Code[10];
        RoundingFactor: Option "None","1","1000","1000000";
        NumJob: Code[250];
        Dpto: Code[20];
        Reest: Code[20];
        IsVersion: Boolean;
        Contrast: Boolean;
        DimJob: Code[20];
        BDimJob: Boolean;
        recCodDim: Record 367;
        recNameJob: Record 95;
        GLBudgetEntry: Record 96;

    procedure MATRIX_GenerateColumnCaptions(MATRIX_SetWanted: Option "First","Previous","Same","Next","PreviousColumn","NextColumn");
    var
        MATRIX_PeriodRecords: ARRAY[32] OF Record 2000000007;
        BusUnit: Record 220;
        GLAccount: Record 15;
        MatrixMgt: Codeunit 9200;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        CurrentMatrixRecordOrdinal: Integer;
        i: Integer;
    begin
        CLEAR(MATRIX_CaptionSet);
        CurrentMatrixRecordOrdinal := 1;
        CLEAR(MATRIX_MatrixRecords);
        FirstColumn := '';
        LastColumn := '';
        MATRIX_CurrentNoOfColumns := 12;

        if ColumnDimCode = '' then
            exit;

        CASE ColumnDimCode OF
            Text001:
                begin
                    MatrixMgt.GeneratePeriodMatrixData(
                      MATRIX_SetWanted, MATRIX_CurrentNoOfColumns, ShowColumnName,
                      PeriodType, DateFilter, MATRIX_PrimKeyFirstCaptionInCu,
                      MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns, MATRIX_PeriodRecords);
                    FOR i := 1 TO MATRIX_CurrentNoOfColumns DO begin
                        MATRIX_MatrixRecords[i]."Period Start" := MATRIX_PeriodRecords[i]."Period Start";
                        MATRIX_MatrixRecords[i]."Period end" := MATRIX_PeriodRecords[i]."Period end";
                    end;
                    FirstColumn := FORMAT(MATRIX_PeriodRecords[1]."Period Start");
                    LastColumn := FORMAT(MATRIX_PeriodRecords[MATRIX_CurrentNoOfColumns]."Period end");
                    PeriodTypeEnable := TRUE;
                end;

            GLAccount.TABLECAPTION:
                begin
                    CLEAR(MATRIX_CaptionSet);
                    RecRef.GETTABLE(GLAccount);
                    RecRef.SETTABLE(GLAccount);
                    if GLAccFilter <> '' then begin
                        FieldRef := RecRef.FIELDINDEX(1);
                        FieldRef.SETFILTER(GLAccFilter);
                    end;
                    MatrixMgt.GenerateMatrixData(
                      RecRef, MATRIX_SetWanted, 12, 1,
                      MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                    FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
                        MATRIX_MatrixRecords[i].Code := COPYSTR(MATRIX_CaptionSet[i], 1, MAXSTRLEN(MATRIX_MatrixRecords[i].Code));
                    if ShowColumnName then
                        MatrixMgt.GenerateMatrixData(
                          RecRef, MATRIX_SetWanted::Same, 12, GLAccount.FIELDNO(Name),
                          MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                end;

            BusUnit.TABLECAPTION:
                begin
                    CLEAR(MATRIX_CaptionSet);
                    RecRef.GETTABLE(BusUnit);
                    RecRef.SETTABLE(BusUnit);
                    if BusUnitFilter <> '' then begin
                        FieldRef := RecRef.FIELDINDEX(1);
                        FieldRef.SETFILTER(BusUnitFilter);
                    end;
                    MatrixMgt.GenerateMatrixData(
                      RecRef, MATRIX_SetWanted, 12, 1,
                      MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                    FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
                        MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
                    if ShowColumnName then
                        MatrixMgt.GenerateMatrixData(
                          RecRef, MATRIX_SetWanted::Same, 12, BusUnit.FIELDNO(Name),
                          MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                end;

            GeneralLedgerSetup."Global Dimension 1 Code":
                begin
                    MatrixMgt.SetDimColumnSet(
                      GeneralLedgerSetup."Global Dimension 1 Code",
                      GlobalDim1Filter, MATRIX_SetWanted, MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns);
                    MatrixMgt.DimToCaptions(
                      MATRIX_CaptionSet, MATRIX_MatrixRecords, ColumnDimCode,
                      //FirstColumn,LastColumn,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange,FALSE);
                      FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange, '');
                end;
            GeneralLedgerSetup."Global Dimension 2 Code":
                begin
                    MatrixMgt.SetDimColumnSet(
                      GeneralLedgerSetup."Global Dimension 2 Code",
                      GlobalDim2Filter, MATRIX_SetWanted, MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns);
                    MatrixMgt.DimToCaptions(
                      MATRIX_CaptionSet, MATRIX_MatrixRecords, ColumnDimCode,
                      //FirstColumn,LastColumn,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange,FALSE);
                      FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange, '');
                end;
            GLBudgetName."Budget Dimension 1 Code":
                begin
                    MatrixMgt.SetDimColumnSet(
                      GLBudgetName."Budget Dimension 1 Code",
                      BudgetDim1Filter, MATRIX_SetWanted, MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns);
                    MatrixMgt.DimToCaptions(
                      MATRIX_CaptionSet, MATRIX_MatrixRecords, ColumnDimCode,
                      //FirstColumn,LastColumn,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange,FALSE);
                      FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange, '');
                end;
            GLBudgetName."Budget Dimension 2 Code":
                begin
                    MatrixMgt.SetDimColumnSet(
                      GLBudgetName."Budget Dimension 2 Code",
                      BudgetDim2Filter, MATRIX_SetWanted, MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns);
                    MatrixMgt.DimToCaptions(
                      MATRIX_CaptionSet, MATRIX_MatrixRecords, ColumnDimCode,
                      //FirstColumn,LastColumn,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange,FALSE);
                      FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange, '');
                end;
            GLBudgetName."Budget Dimension 3 Code":
                begin
                    MatrixMgt.SetDimColumnSet(
                      GLBudgetName."Budget Dimension 3 Code",
                      BudgetDim3Filter, MATRIX_SetWanted, MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns);
                    MatrixMgt.DimToCaptions(
                      MATRIX_CaptionSet, MATRIX_MatrixRecords, ColumnDimCode,
                      //FirstColumn,LastColumn,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange,FALse);
                      FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange, '');
                end;
            GLBudgetName."Budget Dimension 4 Code":
                begin
                    MatrixMgt.SetDimColumnSet(
                      GLBudgetName."Budget Dimension 4 Code",
                      BudgetDim4Filter, MATRIX_SetWanted, MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns);
                    MatrixMgt.DimToCaptions(
                      MATRIX_CaptionSet, MATRIX_MatrixRecords, ColumnDimCode,
                      //FirstColumn,LastColumn,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange,FALSE);
                      FirstColumn, LastColumn, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange, '');
                end;
        end;
    end;

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

    LOCAL procedure GetDimSelection(OldDimSelCode: Text[30]): Text[30];
    var
        GLAcc: Record 15;
        BusUnit: Record 220;
        DimSelection: Page 568;
    begin
        DimSelection.InsertDimSelBuf(FALSE, GLAcc.TABLECAPTION, GLAcc.TABLECAPTION);
        DimSelection.InsertDimSelBuf(FALSE, BusUnit.TABLECAPTION, BusUnit.TABLECAPTION);
        DimSelection.InsertDimSelBuf(FALSE, Text001, Text001);
        if GeneralLedgerSetup."Global Dimension 1 Code" <> '' then
            if ((GeneralLedgerSetup."Global Dimension 1 Code" <> FunctionQB.ReturnDimCA) and
                (GeneralLedgerSetup."Global Dimension 1 Code" <> FunctionQB.ReturnDimJobs)) then
                DimSelection.InsertDimSelBuf(FALSE, GeneralLedgerSetup."Global Dimension 1 Code", '');
        if GeneralLedgerSetup."Global Dimension 2 Code" <> '' then
            if ((GeneralLedgerSetup."Global Dimension 2 Code" <> FunctionQB.ReturnDimCA) and
                (GeneralLedgerSetup."Global Dimension 2 Code" <> FunctionQB.ReturnDimJobs)) then
                DimSelection.InsertDimSelBuf(FALSE, GeneralLedgerSetup."Global Dimension 2 Code", '');
        if GLBudgetName."Budget Dimension 1 Code" <> '' then
            if ((GLBudgetName."Budget Dimension 1 Code" <> FunctionQB.ReturnDimCA) and
                (GLBudgetName."Budget Dimension 1 Code" <> FunctionQB.ReturnDimJobs)) then
                DimSelection.InsertDimSelBuf(FALSE, GLBudgetName."Budget Dimension 1 Code", '');
        if GLBudgetName."Budget Dimension 2 Code" <> '' then
            if ((GLBudgetName."Budget Dimension 2 Code" <> FunctionQB.ReturnDimCA) and
                (GLBudgetName."Budget Dimension 2 Code" <> FunctionQB.ReturnDimJobs)) then
                DimSelection.InsertDimSelBuf(FALSE, GLBudgetName."Budget Dimension 2 Code", '');
        if GLBudgetName."Budget Dimension 3 Code" <> '' then
            if ((GLBudgetName."Budget Dimension 3 Code" <> FunctionQB.ReturnDimCA) and
                (GLBudgetName."Budget Dimension 3 Code" <> FunctionQB.ReturnDimJobs)) then
                DimSelection.InsertDimSelBuf(FALSE, GLBudgetName."Budget Dimension 3 Code", '');
        if GLBudgetName."Budget Dimension 4 Code" <> '' then
            if ((GLBudgetName."Budget Dimension 4 Code" <> FunctionQB.ReturnDimCA) and
                (GLBudgetName."Budget Dimension 4 Code" <> FunctionQB.ReturnDimJobs)) then
                DimSelection.InsertDimSelBuf(FALSE, GLBudgetName."Budget Dimension 4 Code", '');

        DimSelection.LOOKUPMODE := TRUE;
        if DimSelection.RUNMODAL = ACTION::LookupOK then
            exit(DimSelection.GetDimSelCode)
        ELSE
            exit(OldDimSelCode);
    end;

    LOCAL procedure LookUpDimFilter(Dim: Code[20]; var Text: Text[250]): Boolean;
    var
        DimVal: Record 349;
        DimValList: Page 560;
    begin
        if Dim = '' then
            exit(FALSE);
        DimValList.LOOKUPMODE(TRUE);
        DimVal.SETRANGE("Dimension Code", Dim);
        DimValList.SETTABLEVIEW(DimVal);
        if DimValList.RUNMODAL = ACTION::LookupOK then begin
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
        end;
        exit(TRUE);
    end;

    LOCAL procedure DeleteBudget();
    var
        GLBudgetEntry: Record 96;
        UpdateAnalysisView: Codeunit 410;
    begin
        if CONFIRM(Text003) then
            WITH GLBudgetEntry DO begin
                SETRANGE("Budget Name", BudgetName);
                if BusUnitFilter <> '' then
                    SETFILTER("Business Unit Code", BusUnitFilter);
                if GLAccFilter <> '' then
                    SETFILTER("G/L Account No.", GLAccFilter);
                if DateFilter <> '' then
                    SETFILTER(Date, DateFilter);
                if GlobalDim1Filter <> '' then
                    SETFILTER("Global Dimension 1 Code", GlobalDim1Filter);
                if GlobalDim2Filter <> '' then
                    SETFILTER("Global Dimension 2 Code", GlobalDim2Filter);
                if BudgetDim1Filter <> '' then
                    SETFILTER("Budget Dimension 1 Code", BudgetDim1Filter);
                if BudgetDim2Filter <> '' then
                    SETFILTER("Budget Dimension 2 Code", BudgetDim2Filter);
                if BudgetDim3Filter <> '' then
                    SETFILTER("Budget Dimension 3 Code", BudgetDim3Filter);
                if BudgetDim4Filter <> '' then
                    SETFILTER("Budget Dimension 4 Code", BudgetDim4Filter);
                SETCURRENTKEY("Entry No.");
                if FIND('-') then
                    UpdateAnalysisView.SetLastBudgetEntryNo(GLBudgetEntry."Entry No." - 1);
                SETCURRENTKEY("Budget Name");
                DELETEALL(TRUE);
            end;
    end;

    LOCAL procedure ValidateBudgetName();
    begin
        GLBudgetName.Name := BudgetName;
        if not GLBudgetName.FIND('=<>') then begin
            GLBudgetName.INIT;
            GLBudgetName.Name := Text004;
            GLBudgetName.Description := Text005;
            GLBudgetName.INSERT;
        end;
        BudgetName := GLBudgetName.Name;
        GLAccBudgetBuffer.SETRANGE("Budget Filter", BudgetName);
        if PrevGLBudgetName.Name <> '' then begin
            if (GLBudgetName."Budget Dimension 1 Code" <> PrevGLBudgetName."Budget Dimension 1 Code") then
                BudgetDim1Filter := '';
            if (GLBudgetName."Budget Dimension 2 Code" <> PrevGLBudgetName."Budget Dimension 2 Code") then
                BudgetDim2Filter := '';
            if (GLBudgetName."Budget Dimension 3 Code" <> PrevGLBudgetName."Budget Dimension 3 Code") then
                BudgetDim3Filter := '';
            if (GLBudgetName."Budget Dimension 4 Code" <> PrevGLBudgetName."Budget Dimension 4 Code") then
                BudgetDim4Filter := '';
        end;
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 1 Filter", BudgetDim1Filter);
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 2 Filter", BudgetDim2Filter);
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 3 Filter", BudgetDim3Filter);
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 4 Filter", BudgetDim4Filter);
        BudgetDim1FilterEnable := (GLBudgetName."Budget Dimension 1 Code" <> '');
        BudgetDim2FilterEnable := (GLBudgetName."Budget Dimension 2 Code" <> '');
        BudgetDim3FilterEnable := (GLBudgetName."Budget Dimension 3 Code" <> '');
        BudgetDim4FilterEnable := (GLBudgetName."Budget Dimension 4 Code" <> '');

        PrevGLBudgetName := GLBudgetName;
    end;

    LOCAL procedure ValidateLineDimCode();
    var
        BusUnit: Record 220;
        GLAcc: Record 15;
    begin
        if (UPPERCASE(LineDimCode) <> UPPERCASE(GLAcc.TABLECAPTION)) and
           (UPPERCASE(LineDimCode) <> UPPERCASE(BusUnit.TABLECAPTION)) and
           (UPPERCASE(LineDimCode) <> UPPERCASE(Text001)) and
           (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 1 Code") and
           (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 2 Code") and
           (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 3 Code") and
           (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 4 Code") and
           (UPPERCASE(LineDimCode) <> GeneralLedgerSetup."Global Dimension 1 Code") and
           (UPPERCASE(LineDimCode) <> GeneralLedgerSetup."Global Dimension 2 Code") and
           (LineDimCode <> '')
        then begin
            MESSAGE(Text006, LineDimCode);
            LineDimCode := '';
        end;
        LineDimOption := DimCodeToOption(LineDimCode);
        DateFilter := InternalDateFilter;
        if (LineDimOption <> LineDimOption::Period) and (ColumnDimOption <> ColumnDimOption::Period) then begin
            DateFilter := InternalDateFilter;
            if STRPOS(DateFilter, '&') > 1 then
                DateFilter := COPYSTR(DateFilter, 1, STRPOS(DateFilter, '&') - 1);
        end ELSE
            DateFilter := '';
    end;

    LOCAL procedure ValidateColumnDimCode();
    var
        BusUnit: Record 220;
        GLAcc: Record 15;
    begin
        if (UPPERCASE(ColumnDimCode) <> UPPERCASE(GLAcc.TABLECAPTION)) and
           (UPPERCASE(ColumnDimCode) <> UPPERCASE(BusUnit.TABLECAPTION)) and
           (UPPERCASE(ColumnDimCode) <> UPPERCASE(Text001)) and
           (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 1 Code") and
           (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 2 Code") and
           (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 3 Code") and
           (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 4 Code") and
           (UPPERCASE(ColumnDimCode) <> GeneralLedgerSetup."Global Dimension 1 Code") and
           (UPPERCASE(ColumnDimCode) <> GeneralLedgerSetup."Global Dimension 2 Code") and
           (ColumnDimCode <> '')
        then begin
            MESSAGE(Text007, ColumnDimCode);
            ColumnDimCode := '';
        end;
        ColumnDimOption := DimCodeToOption(ColumnDimCode);
        DateFilter := InternalDateFilter;
        if (LineDimOption <> LineDimOption::Period) and (ColumnDimOption <> ColumnDimOption::Period) then begin
            DateFilter := InternalDateFilter;
            if STRPOS(DateFilter, '&') > 1 then
                DateFilter := COPYSTR(DateFilter, 1, STRPOS(DateFilter, '&') - 1);
        end ELSE
            DateFilter := '';
    end;

    LOCAL procedure GetCaptionClass(BudgetDimType: Integer): Text[250];
    begin
        if GLBudgetName.Name <> BudgetName then
            GLBudgetName.GET(BudgetName);
        CASE BudgetDimType OF
            1:
                begin
                    if GLBudgetName."Budget Dimension 1 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 1 Code")
                    ELSE
                        exit(Text008);
                end;
            2:
                begin
                    if GLBudgetName."Budget Dimension 2 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 2 Code")
                    ELSE
                        exit(Text009);
                end;
            3:
                begin
                    if GLBudgetName."Budget Dimension 3 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 3 Code")
                    ELSE
                        exit(Text010);
                end;
            4:
                begin
                    if GLBudgetName."Budget Dimension 4 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 4 Code")
                    ELSE
                        exit(Text011);
                end;
        end;
    end;

    procedure SetBudgetName(NextBudgetName: Code[10]);
    begin
        NewBudgetName := NextBudgetName;
    end;

    procedure UpdateMatrixSubform();
    begin
        CurrPage.MatrixForm.PAGE.Load(
          MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, LineDimCode,
          LineDimOption, ColumnDimOption, GlobalDim1Filter, GlobalDim2Filter, BudgetDim1Filter,
          BudgetDim2Filter, BudgetDim3Filter, BudgetDim4Filter, GLBudgetName, DateFilter,
          GLAccFilter, RoundingFactor, PeriodType);
    end;

    procedure GetJob(LocNumJob: Code[250]; LocDpto: Code[20]; LocReest: Code[20]);
    begin
        NumJob := LocNumJob;
        Dpto := LocDpto;
        Reest := LocReest;
    end;

    procedure FIsVersion(var PIsVersion: Boolean);
    begin
        IsVersion := PIsVersion;
    end;

    procedure Contract(var PContrast: Boolean);
    begin
        Contrast := PContrast;
    end;

    LOCAL procedure BudgetNameOnAfterValidate();
    begin
        UpdateMatrixSubform;
    end;

    LOCAL procedure LineDimCodeOnAfterValidate();
    begin
        CurrPage.UPDATE;
        UpdateMatrixSubform;
    end;

    LOCAL procedure ColumnDimCodeOnAfterValidate();
    begin
        CurrPage.UPDATE;
        UpdateMatrixSubform;
    end;

    LOCAL procedure PeriodTypeOnAfterValidate();
    var
        MATRIX_Step: Option "First","Previous","Same","Next";
    begin
        if ColumnDimOption = ColumnDimOption::Period then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure GLAccFilterOnAfterValidate();
    begin
        GLAccBudgetBuffer.SETFILTER("G/L Account Filter", GLAccFilter);
        if ColumnDimOption = ColumnDimOption::"G/L Account" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure GlobalDim2FilterOnAfterValidat();
    begin
        GLAccBudgetBuffer.SETFILTER("Global Dimension 2 Filter", GlobalDim2Filter);
        if ColumnDimOption = ColumnDimOption::"Global Dimension 2" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure GlobalDim1FilterOnAfterValidat();
    begin
        GLAccBudgetBuffer.SETFILTER("Global Dimension 1 Filter", GlobalDim1Filter);
        if ColumnDimOption = ColumnDimOption::"Global Dimension 1" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure BudgetDim2FilterOnAfterValidat();
    begin
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 2 Filter", BudgetDim2Filter);
        if ColumnDimOption = ColumnDimOption::"Budget Dimension 2" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure BudgetDim1FilterOnAfterValidat();
    begin
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 1 Filter", BudgetDim1Filter);
        if ColumnDimOption = ColumnDimOption::"Budget Dimension 1" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure BudgetDim4FilterOnAfterValidat();
    begin
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 4 Filter", BudgetDim4Filter);
        if ColumnDimOption = ColumnDimOption::"Budget Dimension 4" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure BudgetDim3FilterOnAfterValidat();
    begin
        GLAccBudgetBuffer.SETFILTER("Budget Dimension 3 Filter", BudgetDim3Filter);
        if ColumnDimOption = ColumnDimOption::"Budget Dimension 3" then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure DateFilterOnAfterValidate();
    begin
        CurrPage.UPDATE;
        if ColumnDimOption = ColumnDimOption::Period then
            MATRIX_GenerateColumnCaptions(MATRIX_Step::First);
        UpdateMatrixSubform;
    end;

    LOCAL procedure ShowColumnNameOnPush();
    var
        MATRIX_Step: Option "First","Previous","Same","Next";
    begin
        MATRIX_GenerateColumnCaptions(MATRIX_Step::Same);
        UpdateMatrixSubform;
    end;

    // begin
    /*{
      JAV 05/08/19: - La funci�n SETPERMISSIONFILTER esta obsoleta
      JAV 05/07/22: - QB 1.10.59 Se cambia la llamada a la funci�n propia para poner el presupuesto, que no funciona, por la est�ndar del informe que importa la Excel que si lo hace
    }*///end
}








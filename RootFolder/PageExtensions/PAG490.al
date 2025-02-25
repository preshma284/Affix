pageextension 50206 MyExtension490 extends 490//85
{
    layout
    {



        modify("CurrentSchedName")
        {
            Editable = QB_EditDimension;


        }


        modify("Dim1Filter")
        {
            Editable = QB_EditDimension;


        }


        modify("Dim2Filter")
        {
            Editable = QB_EditDimension;


        }


        modify("Dim3Filter")
        {
            Editable = QB_EditDimension;


        }


        modify("Dim4Filter")
        {
            Editable = QB_EditDimension;


        }

    }

    actions
    {


    }

    //trigger

    trigger OnOpenPage()
    var

    begin

        UseAmtsInAddCurr := FALSE;
        GLSetup.GET;
        UseAmtsInAddCurrVisible := GLSetup."Additional Reporting Currency" <> '';
        IF NewCurrentSchedName <> '' THEN
            CurrentSchedName := NewCurrentSchedName;
        IF CurrentSchedName = '' THEN
            CurrentSchedName := Text000;
        IF NewCurrentColumnName <> '' THEN
            CurrentColumnName := NewCurrentColumnName;
        IF CurrentColumnName = '' THEN
            CurrentColumnName := Text000;
        IF NewPeriodTypeSet THEN
            PeriodType := ModifiedPeriodType;

        AccSchedManagement.CopyColumnsToTemp(CurrentColumnName, TempColumnLayout);
        AccSchedManagement.OpenSchedule(CurrentSchedName, Rec);
        AccSchedManagement.OpenColumns(CurrentColumnName, TempColumnLayout);
        AccSchedManagement.CheckAnalysisView(CurrentSchedName, CurrentColumnName, TRUE);
        UpdateColumnCaptions;
        if (AccSchedName.GET(CurrentSchedName)) then
            if (AccSchedName."Analysis View Name" <> '') then
                AnalysisView.GET(AccSchedName."Analysis View Name")
            ELSE BEGIN
                CLEAR(AnalysisView);
                AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
            END;

        AccSchedManagement.FindPeriod(Rec, '', ConvertOptionToEnum_AnalysisPeriodType(PeriodType));
        Rec.SETFILTER("Show", '<>%1', rec.Show::No);
        Rec.SETRANGE("Dimension 1 Filter");
        Rec.SETRANGE("Dimension 2 Filter");
        //Rec.SETRANGE("Dimension 3 Filter");
        Rec.SETRANGE("Dimension 4 Filter");
        Rec.SETRANGE("Cost Center Filter");
        Rec.SETRANGE("Cost Object Filter");
        Rec.SETRANGE("Cash Flow Forecast Filter");
        Rec.SETRANGE("Cost Budget Filter");
        Rec.SETRANGE("G/L Budget Filter");
        UpdateDimFilterControls;
        DateFilter := Rec.GETFILTER("Date Filter");
        QBPagePublisher.DimensionFilterSetRangePageAccScheduleOverview(Rec, codeJobFilter, AnalysisView);

        Dim4FilterEnable := TRUE;
        //JMMA 270121
        //Dim3FilterEnable := TRUE;
        Dim3FilterEnable := QB_EditDimension;
        Dim2FilterEnable := TRUE;
        Dim1FilterEnable := TRUE;

    end;


    var
        Text000: TextConst ENU = 'DEFAULT', ESP = 'GENERICO';
        Text005: TextConst ENU = '1,6,Dimension %1 Filter', ESP = '1,6,Filtro dimensi¢n %1';
        TempColumnLayout: Record 334 TEMPORARY;
        ColumnLayoutArr: ARRAY[12] OF Record 334;
        AccSchedName: Record 84;
        AnalysisView: Record 363;
        GLSetup: Record 98;
        AccSchedManagement: Codeunit 8;
        MatrixMgt: Codeunit 9200;
        DimensionManagement: Codeunit 408;
        CurrentSchedName: Code[10];
        CurrentColumnName: Code[10];
        NewCurrentSchedName: Code[10];
        NewCurrentColumnName: Code[10];
        ColumnValues: ARRAY[12] OF Decimal;
        ColumnCaptions: ARRAY[12] OF Text[80];
        PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
        UseAmtsInAddCurrVisible: Boolean;
        UseAmtsInAddCurr: Boolean;
        Dim1Filter: Text;
        Dim2Filter: Text;
        Dim3Filter: Text;
        Dim4Filter: Text;
        CostCenterFilter: Text;
        CostObjectFilter: Text;
        CashFlowFilter: Text;
        NoOfColumns: Integer;
        ColumnOffset: Integer;
        Dim1FilterEnable: Boolean;
        Dim2FilterEnable: Boolean;
        Dim3FilterEnable: Boolean;
        Dim4FilterEnable: Boolean;
        GLBudgetFilter: Text;
        CostBudgetFilter: Text;
        DateFilter: Text;
        ModifiedPeriodType: Option;
        NewPeriodTypeSet: Boolean;
        ColumnStyle1: Text;
        ColumnStyle2: Text;
        ColumnStyle3: Text;
        ColumnStyle4: Text;
        ColumnStyle5: Text;
        ColumnStyle6: Text;
        ColumnStyle7: Text;
        ColumnStyle8: Text;
        ColumnStyle9: Text;
        ColumnStyle10: Text;
        ColumnStyle11: Text;
        ColumnStyle12: Text;
        "---------------------------- QB": Integer;
        QBPagePublisher: Codeunit 7207348;
        codeJobFilter: Code[20];
        QB_EditDimension: Boolean;



    //procedure

    procedure ConvertOptionToEnum_AnalysisPeriodType(optionValue: Option "Day","Week","Month","Quarter","Year","Accounting Period"): Enum "Analysis Period Type";
    var
        enumVariable: Enum "Analysis Period Type";
    begin
        case optionValue of

            optionValue::"Day":
                enumVariable := enumVariable::"Day";

            optionValue::"Week":
                enumVariable := enumVariable::"Week";

            optionValue::"Month":
                enumVariable := enumVariable::"Month";

            optionValue::"Quarter":
                enumVariable := enumVariable::"Quarter";

            optionValue::"Year":
                enumVariable := enumVariable::"Year";

            optionValue::"Accounting Period":
                enumVariable := enumVariable::"Accounting Period";

            else
                Error('Invalid Option Value: %1', optionValue);
        end;
        exit(enumVariable);
    end;
    //procedure SetAccSchedName(NewAccSchedName : Code[10]);
    //    var
    //      AccSchedName : Record 84;
    //    begin
    //      NewCurrentSchedName := NewAccSchedName;
    //      if ( AccSchedName.GET(NewCurrentSchedName)  )then
    //        if ( AccSchedName."Default Column Layout" <> ''  )then
    //          NewCurrentColumnName := AccSchedName."Default Column Layout";
    //    end;
    //
    //    //[External]
    //procedure SetPeriodType(NewPeriodType : Option);
    //    begin
    //      ModifiedPeriodType := NewPeriodType;
    //      NewPeriodTypeSet := TRUE;
    //    end;
    procedure SetDimFilters(DimNo : Integer;DimValueFilter : Text);
       begin
         CASE DimNo OF
           1:
             if ( DimValueFilter = ''  )then
               Rec.SETRANGE("Dimension 1 Filter")
             ELSE begin
               DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 1 Code");
               Rec.SETFILTER("Dimension 1 Filter",DimValueFilter);
             end;
           2:
             if ( DimValueFilter = ''  )then
               Rec.SETRANGE("Dimension 2 Filter")
             ELSE begin
               DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 2 Code");
               Rec.SETFILTER("Dimension 2 Filter",DimValueFilter);
             end;
           3:
             if ( DimValueFilter = ''  )then
               Rec.SETRANGE("Dimension 3 Filter")
             ELSE begin
               DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 3 Code");
               Rec.SETFILTER("Dimension 3 Filter",DimValueFilter);
             end;
           4:
             if ( DimValueFilter = ''  )then
               Rec.SETRANGE("Dimension 4 Filter")
             ELSE begin
               DimensionManagement.ResolveDimValueFilter(DimValueFilter,AnalysisView."Dimension 4 Code");
               Rec.SETFILTER("Dimension 4 Filter",DimValueFilter);
             end;
         end;
    
         OnAfterSetDimFilters(Rec,DimNo,DimValueFilter,CostCenterFilter,CostObjectFilter);
         CurrPage.UPDATE;
       end;
    //Local procedure FormGetCaptionClass(DimNo : Integer) : Text[250];
    //    begin
    //      CASE DimNo OF
    //        1:
    //          begin
    //            if ( AnalysisView."Dimension 1 Code" <> ''  )then
    //              exit('1,6,' + AnalysisView."Dimension 1 Code");
    //
    //            exit(STRSUBSTNO(Text005,DimNo));
    //          end;
    //        2:
    //          begin
    //            if ( AnalysisView."Dimension 2 Code" <> ''  )then
    //              exit('1,6,' + AnalysisView."Dimension 2 Code");
    //
    //            exit(STRSUBSTNO(Text005,DimNo));
    //          end;
    //        3:
    //          begin
    //            if ( AnalysisView."Dimension 3 Code" <> ''  )then
    //              exit('1,6,' + AnalysisView."Dimension 3 Code");
    //
    //            exit(STRSUBSTNO(Text005,DimNo));
    //          end;
    //        4:
    //          begin
    //            if ( AnalysisView."Dimension 4 Code" <> ''  )then
    //              exit('1,6,' + AnalysisView."Dimension 4 Code");
    //
    //            exit(STRSUBSTNO(Text005,DimNo));
    //          end;
    //        5:
    //          exit(Rec.FIELDCAPTION("Date Filter"));
    //        6:
    //          exit(Rec.FIELDCAPTION("Cash Flow Forecast Filter"));
    //      end;
    //    end;
    //Local procedure DrillDown(ColumnNo : Integer);
    //    begin
    //      TempColumnLayout := ColumnLayoutArr[ColumnNo];
    //      AccSchedManagement.DrillDownFromOverviewPage(TempColumnLayout,Rec,PeriodType);
    //    end;
    //Local procedure UpdateColumnCaptions();
    //    var
    //      ColumnNo : Integer;
    //      i : Integer;
    //    begin
    //      CLEAR(ColumnCaptions);
    //      if ( TempColumnLayout.FINDSET  )then
    //        repeat
    //          ColumnNo := ColumnNo + 1;
    //          if ( (ColumnNo > ColumnOffset) and (ColumnNo - ColumnOffset <= ARRAYLEN(ColumnCaptions))  )then
    //            ColumnCaptions[ColumnNo - ColumnOffset] := TempColumnLayout."Column Header";
    //        until (ColumnNo - ColumnOffset = ARRAYLEN(ColumnCaptions)) or (TempColumnLayout.NEXT = 0);
    //      // Set unused columns to blank to prevent RTC to display control ID as caption
    //      FOR i := ColumnNo - ColumnOffset + 1 TO ARRAYLEN(ColumnCaptions) DO
    //        ColumnCaptions[i] := ' ';
    //      NoOfColumns := ColumnNo;
    //    end;
    //Local procedure AdjustColumnOffset(Delta : Integer);
    //    var
    //      OldColumnOffset : Integer;
    //    begin
    //      OldColumnOffset := ColumnOffset;
    //      ColumnOffset := ColumnOffset + Delta;
    //      if ( ColumnOffset + 12 > TempColumnLayout.COUNT  )then
    //        ColumnOffset := TempColumnLayout.COUNT - 12;
    //      if ( ColumnOffset < 0  )then
    //        ColumnOffset := 0;
    //      if ( ColumnOffset <> OldColumnOffset  )then begin
    //        UpdateColumnCaptions;
    //        CurrPage.UPDATE(FALSE);
    //      end;
    //    end;
    Local procedure UpdateDimFilterControls();
       begin
         Dim1Filter := Rec.GETFILTER("Dimension 1 Filter");
         Dim2Filter := Rec.GETFILTER("Dimension 2 Filter");
         Dim3Filter := Rec.GETFILTER("Dimension 3 Filter");
         Dim4Filter := Rec.GETFILTER("Dimension 4 Filter");
         CostCenterFilter := '';
         CostObjectFilter := '';
         CashFlowFilter := '';
         Dim1FilterEnable := AnalysisView."Dimension 1 Code" <> '';
         Dim2FilterEnable := AnalysisView."Dimension 2 Code" <> '';
         Dim3FilterEnable := AnalysisView."Dimension 3 Code" <> '';
         Dim4FilterEnable := AnalysisView."Dimension 4 Code" <> '';
         GLBudgetFilter := '';
         CostBudgetFilter := '';
       end;
    //Local procedure CurrentSchedNameOnAfterValidate();
    //    var
    //      AccSchedName : Record 84;
    //      PrevAnalysisView : Record 363;
    //    begin
    //      CurrPage.SAVERECORD;
    //      AccSchedManagement.SetName(CurrentSchedName,Rec);
    //      if ( AccSchedName.GET(CurrentSchedName)  )then begin
    //        if (AccSchedName."Default Column Layout" <> '') and
    //           (CurrentColumnName <> AccSchedName."Default Column Layout")
    //        then begin
    //          CurrentColumnName := AccSchedName."Default Column Layout";
    //          CurrentColumnNameOnAfterValidate;
    //        end ELSE
    //          AccSchedManagement.CheckAnalysisView(CurrentSchedName,CurrentColumnName,TRUE);
    //      end ELSE
    //        AccSchedManagement.CheckAnalysisView(CurrentSchedName,CurrentColumnName,TRUE);
    //
    //      if ( AccSchedName."Analysis View Name" <> AnalysisView.Code  )then begin
    //        PrevAnalysisView := AnalysisView;
    //        if ( AccSchedName."Analysis View Name" <> ''  )then
    //          AnalysisView.GET(AccSchedName."Analysis View Name")
    //        ELSE begin
    //          CLEAR(AnalysisView);
    //          AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
    //          AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
    //        end;
    //        if ( PrevAnalysisView."Dimension 1 Code" <> AnalysisView."Dimension 1 Code"  )then
    //          Rec.SETRANGE("Dimension 1 Filter");
    //        if ( PrevAnalysisView."Dimension 2 Code" <> AnalysisView."Dimension 2 Code"  )then
    //          Rec.SETRANGE("Dimension 2 Filter");
    //        if ( PrevAnalysisView."Dimension 3 Code" <> AnalysisView."Dimension 3 Code"  )then
    //          Rec.SETRANGE("Dimension 3 Filter");
    //        if ( PrevAnalysisView."Dimension 4 Code" <> AnalysisView."Dimension 4 Code"  )then
    //          Rec.SETRANGE("Dimension 4 Filter");
    //      end;
    //      UpdateDimFilterControls;
    //
    //      CurrPage.UPDATE(FALSE);
    //    end;
    //Local procedure CurrentColumnNameOnAfterValidate();
    //    begin
    //      AccSchedManagement.CopyColumnsToTemp(CurrentColumnName,TempColumnLayout);
    //      AccSchedManagement.SetColumnName(CurrentColumnName,TempColumnLayout);
    //      AccSchedManagement.CheckAnalysisView(CurrentSchedName,CurrentColumnName,TRUE);
    //      ColumnOffset := 0;
    //      UpdateColumnCaptions;
    //      CurrPage.UPDATE(FALSE);
    //    end;
    //
    //    //[External]
    //procedure FormatStr(ColumnNo : Integer) : Text;
    //    begin
    //      exit(MatrixMgt.GetFormatString(ColumnLayoutArr[ColumnNo]."Rounding Factor",UseAmtsInAddCurr));
    //    end;
    //
    //    //[External]
    //procedure RoundNone(Value : Decimal;RoundingFactor: Option "None","1","1000","1000000") : Decimal;
    //    begin
    //      if ( RoundingFactor <> RoundingFactor::None  )then
    //        exit(Value);
    //
    //      exit(ROUND(Value));
    //    end;
    //Local procedure GetStyle(ColumnNo : Integer;RowLineNo : Integer;ColumnLineNo : Integer);
    //    var
    //      ColumnStyle : Text;
    //      ErrorType: Option "None","Division by Zero","Period Error","Both";
    //    begin
    //      AccSchedManagement.CalcFieldError(ErrorType,RowLineNo,ColumnLineNo);
    //      if ( ErrorType > ErrorType::None  )then
    //        ColumnStyle := 'Unfavorable'
    //      ELSE
    //        if ( rec."Bold"  )then
    //          ColumnStyle := 'Strong'
    //        ELSE
    //          ColumnStyle := 'Standard';
    //
    //      CASE ColumnNo OF
    //        1:
    //          ColumnStyle1 := ColumnStyle;
    //        2:
    //          ColumnStyle2 := ColumnStyle;
    //        3:
    //          ColumnStyle3 := ColumnStyle;
    //        4:
    //          ColumnStyle4 := ColumnStyle;
    //        5:
    //          ColumnStyle5 := ColumnStyle;
    //        6:
    //          ColumnStyle6 := ColumnStyle;
    //        7:
    //          ColumnStyle7 := ColumnStyle;
    //        8:
    //          ColumnStyle8 := ColumnStyle;
    //        9:
    //          ColumnStyle9 := ColumnStyle;
    //        10:
    //          ColumnStyle10 := ColumnStyle;
    //        11:
    //          ColumnStyle11 := ColumnStyle;
    //        12:
    //          ColumnStyle12 := ColumnStyle;
    //      end;
    //    end;
    //
    //    [Integration]
    Local procedure OnAfterSetDimFilters(var AccScheduleLine : Record 85;var DimNo : Integer;var DimValueFilter : Text;var CostCenterFilter : Text;var CostObjectFilter : Text);
       begin
       end;
    //
    //    [Integration]
    //Local procedure OnAfterValidateCostCenterFilter(var AccScheduleLine : Record 85;var CostCenterFilter : Text;var Dim1Filter : Text);
    //    begin
    //    end;
    //
    //    [Integration]
    //Local procedure OnAfterValidateCostObjectFilter(var AccScheduleLine : Record 85;var CostObjectFilter : Text;var Dim2Filter : Text);
    //    begin
    //    end;
    procedure QB_SetEditable(Edit: Boolean);
    begin
        QB_EditDimension := Edit;
    end;

    //procedure
}


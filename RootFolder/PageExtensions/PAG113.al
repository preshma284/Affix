pageextension 50112 MyExtension113 extends 113//93
{
layout
{



//modify("LineDimCode")
//{
//
//
//}
//

//modify("ColumnDimCode")
//{
//
//
//}
//

modify("ShowColumnName")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}


modify("GLAccFilter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;
END;

}


modify("GlobalDim1Filter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}


modify("GlobalDim2Filter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}


modify("BudgetDim1Filter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}


modify("BudgetDim2Filter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}


modify("BudgetDim3Filter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}


modify("BudgetDim4Filter")
{

trigger OnAfterValidate()    BEGIN
CurrPage.Update;//QB
END;

}

}

actions
{


}

//trigger

//trigger

var
      GLSetup : Record 98;
      GLAccBudgetBuf : Record 374;
      GLBudgetName : Record 95;
      PrevGLBudgetName : Record 95;
      MATRIX_MatrixRecords : ARRAY [32] OF Record 367;
      MATRIX_CaptionSet : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange : Text[80];
      FirstColumn : Text;
      LastColumn : Text;
      MATRIX_PrimKeyFirstCaptionInCu : Text[80];
      MATRIX_CurrentNoOfColumns : Integer;
      Text001 : TextConst ENU='Period',ESP='Periodo';
      Text003 : TextConst ENU='Do you want to delete the budget entries shown?',ESP='¨Confirma que desea borrar los movs. presupuest. mostrados?';
      Text004 : TextConst ENU='DEFAULT',ESP='GENERICO';
      Text005 : TextConst ENU='Default budget',ESP='Ppto. gen‚rico';
      Text006 : TextConst ENU='%1 is not a valid line definition.',ESP='%1 no es una def. de l¡nea v lida.';
      Text007 : TextConst ENU='%1 is not a valid column definition.',ESP='%1 no es una def. de columna v lida.';
      Text008 : TextConst ENU='1,6,Budget Dimension 1 Filter',ESP='1,6,Filtro dimensi¢n presupuesto 1';
      Text009 : TextConst ENU='1,6,Budget Dimension 2 Filter',ESP='1,6,Filtro dimensi¢n presupuesto 2';
      Text010 : TextConst ENU='1,6,Budget Dimension 3 Filter',ESP='1,6,Filtro dimensi¢n presupuesto 3';
      Text011 : TextConst ENU='1,6,Budget Dimension 4 Filter',ESP='1,6,Filtro dimensi¢n presupuesto 4';
      MATRIX_Step: Option "Initial","Previous","Same","Next","PreviousColumn","NextColumn";
      BudgetName : Code[10];
      NewBudgetName : Code[10];
      LineDimOption: Option "G/L Account","Period","Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4","Historic G/L Account";
      ColumnDimOption: Option "G/L Account","Period","Business Unit","Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4","Historic G/L Account";
      LineDimCode : Text[30];
      ColumnDimCode : Text[30];
      PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
      RoundingFactor: Option "None","1","1000","1000000";
      GLAccCategoryFilter: Option " ","Assets","Liabilities","Equity","Income","Cost of Goods Sold","Expense";
      IncomeBalanceGLAccFilter: Option " ","Income Statement","Balance Sheet";
      ShowColumnName : Boolean;
      DateFilter : Text[30];
      InternalDateFilter : Text[30];
      BusUnitFilter : Text;
      GLAccFilter : Text;
      GlobalDim1Filter : Text;
      GlobalDim2Filter : Text;
      BudgetDim1Filter : Text;
      BudgetDim2Filter : Text;
      BudgetDim3Filter : Text;
      BudgetDim4Filter : Text;
      GlobalDim1FilterEnable : Boolean ;
      GlobalDim2FilterEnable : Boolean ;
      PeriodTypeEnable : Boolean ;
      BudgetDim1FilterEnable : Boolean ;
      BudgetDim2FilterEnable : Boolean ;
      BudgetDim3FilterEnable : Boolean ;
      BudgetDim4FilterEnable : Boolean ;

    
    

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
Local procedure MATRIX_GenerateColumnCaptions(MATRIX_SetWanted: Option "Initial","Previous","Same","Next","PreviousColumn","NextColumn");
   var
     MATRIX_PeriodRecords : ARRAY [32] OF Record 2000000007;
     BusUnit : Record 220;
     GLAccount : Record 15;
     MatrixMgt : Codeunit 9200;
     RecRef : RecordRef;
     FieldRef : FieldRef;
     IncomeBalFieldRef : FieldRef;
     GLAccCategoryFieldRef : FieldRef;
     i : Integer;
   begin
     CLEAR(MATRIX_CaptionSet);
     CLEAR(MATRIX_MatrixRecords);
     FirstColumn := '';
     LastColumn := '';
     MATRIX_CurrentNoOfColumns := 12;

     if ( ColumnDimCode = ''  )then
       exit;

     CASE ColumnDimCode OF
       Text001:  // Period
         begin
           MatrixMgt.GeneratePeriodMatrixData(
             MATRIX_SetWanted,MATRIX_CurrentNoOfColumns,ShowColumnName,
             ConvertOptionToEnum_AnalysisPeriodType(PeriodType),DateFilter,MATRIX_PrimKeyFirstCaptionInCu,
             MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns,MATRIX_PeriodRecords);
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
           if ( GLAccFilter <> ''  )then begin
             FieldRef := RecRef.FIELD(GLAccount.FIELDNO("No."));
             FieldRef.SETFILTER(GLAccFilter);
           end;
           if ( IncomeBalanceGLAccFilter <> IncomeBalanceGLAccFilter::" "  )then begin
             IncomeBalFieldRef := RecRef.FIELDINDEX(GLAccount.FIELDNO("Income/Balance"));
             CASE IncomeBalanceGLAccFilter OF
               IncomeBalanceGLAccFilter::"Balance Sheet":
                 IncomeBalFieldRef.SETRANGE(GLAccount."Income/Balance"::"Balance Sheet");
               IncomeBalanceGLAccFilter::"Income Statement":
                 IncomeBalFieldRef.SETRANGE(GLAccount."Income/Balance"::"Income Statement");
             end;
           end;
           if ( GLAccCategoryFilter <> GLAccCategoryFilter::" "  )then begin
             GLAccCategoryFieldRef := RecRef.FIELDINDEX(GLAccount.FIELDNO("Account Category"));
             GLAccCategoryFieldRef.SETRANGE(GLAccCategoryFilter);
           end;
           MatrixMgt.GenerateMatrixData(
             RecRef,MATRIX_SetWanted,12,1,
             MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
           FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
             MATRIX_MatrixRecords[i].Code := COPYSTR(MATRIX_CaptionSet[i],1,MAXSTRLEN(MATRIX_MatrixRecords[i].Code));
           if ( ShowColumnName  )then
             MatrixMgt.GenerateMatrixData(
               RecRef,MATRIX_SetWanted::Same,12,GLAccount.FIELDNO(Name),
               MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
         end;
       BusUnit.TABLECAPTION:
         begin
           CLEAR(MATRIX_CaptionSet);
           RecRef.GETTABLE(BusUnit);
           RecRef.SETTABLE(BusUnit);
           if ( BusUnitFilter <> ''  )then begin
             FieldRef := RecRef.FIELD(BusUnit.FIELDNO("Code"));
             FieldRef.SETFILTER(BusUnitFilter);
           end;
           MatrixMgt.GenerateMatrixData(
             RecRef,MATRIX_SetWanted,12,1,
             MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
           FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
             MATRIX_MatrixRecords[i].Code := COPYSTR(MATRIX_CaptionSet[i],1,MAXSTRLEN(MATRIX_MatrixRecords[i].Code));
           if ( ShowColumnName  )then
             MatrixMgt.GenerateMatrixData(
               RecRef,MATRIX_SetWanted::Same,12,BusUnit.FIELDNO(Name),
               MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
         end;
       // Apply dimension filter
       GLSetup."Global Dimension 1 Code":
         MatrixMgt.GenerateDimColumnCaption(
           GLSetup."Global Dimension 1 Code",
           GlobalDim1Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
           MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
       GLSetup."Global Dimension 2 Code":
         MatrixMgt.GenerateDimColumnCaption(
           GLSetup."Global Dimension 2 Code",
           GlobalDim2Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
           MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
       GLBudgetName."Budget Dimension 1 Code":
         MatrixMgt.GenerateDimColumnCaption(
           GLBudgetName."Budget Dimension 1 Code",
           BudgetDim1Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
           MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
       GLBudgetName."Budget Dimension 2 Code":
         MatrixMgt.GenerateDimColumnCaption(
           GLBudgetName."Budget Dimension 2 Code",
           BudgetDim2Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
           MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
       GLBudgetName."Budget Dimension 3 Code":
         MatrixMgt.GenerateDimColumnCaption(
           GLBudgetName."Budget Dimension 3 Code",
           BudgetDim3Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
           MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
       GLBudgetName."Budget Dimension 4 Code":
         MatrixMgt.GenerateDimColumnCaption(
           GLBudgetName."Budget Dimension 4 Code",
           BudgetDim4Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
           MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
     end;
   end;
//Local procedure DimCodeToOption(DimCode : Text[30]) : Integer;
//    var
//      BusUnit : Record 220;
//      GLAcc : Record 15;
//    begin
//      CASE DimCode OF
//        '':
//          exit(-1);
//        GLAcc.TABLECAPTION:
//          exit(0);
//        Text001:
//          exit(1);
//        BusUnit.TABLECAPTION:
//          exit(2);
//        GLSetup."Global Dimension 1 Code":
//          exit(3);
//        GLSetup."Global Dimension 2 Code":
//          exit(4);
//        GLBudgetName."Budget Dimension 1 Code":
//          exit(5);
//        GLBudgetName."Budget Dimension 2 Code":
//          exit(6);
//        GLBudgetName."Budget Dimension 3 Code":
//          exit(7);
//        GLBudgetName."Budget Dimension 4 Code":
//          exit(8);
//        ELSE
//          exit(-1);
//      end;
//    end;
//Local procedure FindPeriod(SearchText : Code[10]);
//    var
//      GLAcc : Record 15;
//      Calendar : Record 2000000007;
//      PeriodFormMgt : Codeunit 359;
//    begin
//      if ( DateFilter <> ''  )then begin
//        Calendar.SETFILTER("Period Start",DateFilter);
//        if ( not PeriodFormMgt.FindDate('+',Calendar,PeriodType)  )then
//          PeriodFormMgt.FindDate('+',Calendar,PeriodType::Day);
//        Calendar.SETRANGE("Period Start");
//      end;
//      PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
//      GLAcc.SETRANGE("Date Filter",Calendar."Period Start",Calendar."Period end");
//      if ( GLAcc.GETRANGEMIN("Date Filter") = GLAcc.GETRANGEMAX("Date Filter")  )then
//        GLAcc.SETRANGE("Date Filter",GLAcc.GETRANGEMIN("Date Filter"));
//      InternalDateFilter := GLAcc.GETFILTER("Date Filter");
//      if ( (LineDimOption <> LineDimOption::Period) and (ColumnDimOption <> ColumnDimOption::Period)  )then
//        DateFilter := InternalDateFilter;
//    end;
//Local procedure GetDimSelection(OldDimSelCode : Text[30]) : Text[30];
//    var
//      GLAcc : Record 15;
//      BusUnit : Record 220;
//      DimSelection : Page 568;
//    begin
//      DimSelection.InsertDimSelBuf(FALSE,GLAcc.TABLECAPTION,GLAcc.TABLECAPTION);
//      DimSelection.InsertDimSelBuf(FALSE,BusUnit.TABLECAPTION,BusUnit.TABLECAPTION);
//      DimSelection.InsertDimSelBuf(FALSE,Text001,Text001);
//      if ( GLSetup."Global Dimension 1 Code" <> ''  )then
//        DimSelection.InsertDimSelBuf(FALSE,GLSetup."Global Dimension 1 Code",'');
//      if ( GLSetup."Global Dimension 2 Code" <> ''  )then
//        DimSelection.InsertDimSelBuf(FALSE,GLSetup."Global Dimension 2 Code",'');
//      if ( GLBudgetName."Budget Dimension 1 Code" <> ''  )then
//        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 1 Code",'');
//      if ( GLBudgetName."Budget Dimension 2 Code" <> ''  )then
//        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 2 Code",'');
//      if ( GLBudgetName."Budget Dimension 3 Code" <> ''  )then
//        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 3 Code",'');
//      if ( GLBudgetName."Budget Dimension 4 Code" <> ''  )then
//        DimSelection.InsertDimSelBuf(FALSE,GLBudgetName."Budget Dimension 4 Code",'');
//
//      DimSelection.LOOKUPMODE := TRUE;
//      if ( DimSelection.RUNMODAL = ACTION::LookupOK  )then
//        exit(DimSelection.GetDimSelCode);
//
//      exit(OldDimSelCode);
//    end;
//Local procedure DeleteBudget();
//    var
//      GLBudgetEntry : Record 96;
//      UpdateAnalysisView : Codeunit 410;
//    begin
//      if ( CONFIRM(Text003)  )then
//        WITH GLBudgetEntry DO begin
//          SETRANGE("Budget Name",BudgetName);
//          if ( BusUnitFilter <> ''  )then
//            SETFILTER("Business Unit Code",BusUnitFilter);
//          if ( GLAccFilter <> ''  )then
//            SETFILTER("G/L Account No.",GLAccFilter);
//          if ( DateFilter <> ''  )then
//            SETFILTER(Date,DateFilter);
//          if ( GlobalDim1Filter <> ''  )then
//            SETFILTER("Global Dimension 1 Code",GlobalDim1Filter);
//          if ( GlobalDim2Filter <> ''  )then
//            SETFILTER("Global Dimension 2 Code",GlobalDim2Filter);
//          if ( BudgetDim1Filter <> ''  )then
//            SETFILTER("Budget Dimension 1 Code",BudgetDim1Filter);
//          if ( BudgetDim2Filter <> ''  )then
//            SETFILTER("Budget Dimension 2 Code",BudgetDim2Filter);
//          if ( BudgetDim3Filter <> ''  )then
//            SETFILTER("Budget Dimension 3 Code",BudgetDim3Filter);
//          if ( BudgetDim4Filter <> ''  )then
//            SETFILTER("Budget Dimension 4 Code",BudgetDim4Filter);
//          SETCURRENTKEY("Entry No.");
//          if ( FINDFIRST  )then
//            UpdateAnalysisView.SetLastBudgetEntryNo("Entry No." - 1);
//          SETCURRENTKEY("Budget Name");
//          DELETEALL(TRUE);
//        end;
//    end;
//Local procedure ValidateBudgetName();
//    begin
//      GLBudgetName.Name := BudgetName;
//      if ( not GLBudgetName.FIND('=<>')  )then begin
//        GLBudgetName.INIT;
//        GLBudgetName.Name := Text004;
//        GLBudgetName.Description := Text005;
//        GLBudgetName.INSERT;
//      end;
//      BudgetName := GLBudgetName.Name;
//      GLAccBudgetBuf.SETRANGE("Budget Filter",BudgetName);
//      if ( PrevGLBudgetName.Name <> ''  )then begin
//        if ( GLBudgetName."Budget Dimension 1 Code" <> PrevGLBudgetName."Budget Dimension 1 Code"  )then
//          BudgetDim1Filter := '';
//        if ( GLBudgetName."Budget Dimension 2 Code" <> PrevGLBudgetName."Budget Dimension 2 Code"  )then
//          BudgetDim2Filter := '';
//        if ( GLBudgetName."Budget Dimension 3 Code" <> PrevGLBudgetName."Budget Dimension 3 Code"  )then
//          BudgetDim3Filter := '';
//        if ( GLBudgetName."Budget Dimension 4 Code" <> PrevGLBudgetName."Budget Dimension 4 Code"  )then
//          BudgetDim4Filter := '';
//      end;
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 1 Filter",BudgetDim1Filter);
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 2 Filter",BudgetDim2Filter);
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 3 Filter",BudgetDim3Filter);
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 4 Filter",BudgetDim4Filter);
//      BudgetDim1FilterEnable := (GLBudgetName."Budget Dimension 1 Code" <> '');
//      BudgetDim2FilterEnable := (GLBudgetName."Budget Dimension 2 Code" <> '');
//      BudgetDim3FilterEnable := (GLBudgetName."Budget Dimension 3 Code" <> '');
//      BudgetDim4FilterEnable := (GLBudgetName."Budget Dimension 4 Code" <> '');
//
//      PrevGLBudgetName := GLBudgetName;
//    end;
//Local procedure ValidateLineDimCode();
//    var
//      BusUnit : Record 220;
//      GLAcc : Record 15;
//    begin
//      if (UPPERCASE(LineDimCode) <> UPPERCASE(GLAcc.TABLECAPTION)) and
//         (UPPERCASE(LineDimCode) <> UPPERCASE(BusUnit.TABLECAPTION)) and
//         (UPPERCASE(LineDimCode) <> UPPERCASE(Text001)) and
//         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 1 Code") and
//         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 2 Code") and
//         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 3 Code") and
//         (UPPERCASE(LineDimCode) <> GLBudgetName."Budget Dimension 4 Code") and
//         (UPPERCASE(LineDimCode) <> GLSetup."Global Dimension 1 Code") and
//         (UPPERCASE(LineDimCode) <> GLSetup."Global Dimension 2 Code") and
//         (LineDimCode <> '')
//      then begin
//        MESSAGE(Text006,LineDimCode);
//        LineDimCode := '';
//      end;
//      LineDimOption := DimCodeToOption(LineDimCode);
//      DateFilter := InternalDateFilter;
//      if ( (LineDimOption <> LineDimOption::Period) and (ColumnDimOption <> ColumnDimOption::Period)  )then begin
//        DateFilter := InternalDateFilter;
//        if ( STRPOS(DateFilter,'&') > 1  )then
//          DateFilter := COPYSTR(DateFilter,1,STRPOS(DateFilter,'&') - 1);
//      end ELSE
//        DateFilter := '';
//    end;
//Local procedure ValidateColumnDimCode();
//    var
//      BusUnit : Record 220;
//      GLAcc : Record 15;
//    begin
//      if (UPPERCASE(ColumnDimCode) <> UPPERCASE(GLAcc.TABLECAPTION)) and
//         (UPPERCASE(ColumnDimCode) <> UPPERCASE(BusUnit.TABLECAPTION)) and
//         (UPPERCASE(ColumnDimCode) <> UPPERCASE(Text001)) and
//         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 1 Code") and
//         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 2 Code") and
//         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 3 Code") and
//         (UPPERCASE(ColumnDimCode) <> GLBudgetName."Budget Dimension 4 Code") and
//         (UPPERCASE(ColumnDimCode) <> GLSetup."Global Dimension 1 Code") and
//         (UPPERCASE(ColumnDimCode) <> GLSetup."Global Dimension 2 Code") and
//         (ColumnDimCode <> '')
//      then begin
//        MESSAGE(Text007,ColumnDimCode);
//        ColumnDimCode := '';
//      end;
//      ColumnDimOption := DimCodeToOption(ColumnDimCode);
//      DateFilter := InternalDateFilter;
//      if ( (LineDimOption <> LineDimOption::Period) and (ColumnDimOption <> ColumnDimOption::Period)  )then begin
//        DateFilter := InternalDateFilter;
//        if ( STRPOS(DateFilter,'&') > 1  )then
//          DateFilter := COPYSTR(DateFilter,1,STRPOS(DateFilter,'&') - 1);
//      end ELSE
//        DateFilter := '';
//    end;
//Local procedure GetCaptionClass(BudgetDimType : Integer) : Text[250];
//    begin
//      if ( GLBudgetName.Name <> BudgetName  )then
//        GLBudgetName.GET(BudgetName);
//      CASE BudgetDimType OF
//        1:
//          begin
//            if ( GLBudgetName."Budget Dimension 1 Code" <> ''  )then
//              exit('1,6,' + GLBudgetName."Budget Dimension 1 Code");
//
//            exit(Text008);
//          end;
//        2:
//          begin
//            if ( GLBudgetName."Budget Dimension 2 Code" <> ''  )then
//              exit('1,6,' + GLBudgetName."Budget Dimension 2 Code");
//
//            exit(Text009);
//          end;
//        3:
//          begin
//            if ( GLBudgetName."Budget Dimension 3 Code" <> ''  )then
//              exit('1,6,' + GLBudgetName."Budget Dimension 3 Code");
//
//            exit(Text010);
//          end;
//        4:
//          begin
//            if ( GLBudgetName."Budget Dimension 4 Code" <> ''  )then
//              exit('1,6,' + GLBudgetName."Budget Dimension 4 Code");
//
//            exit(Text011);
//          end;
//      end;
//    end;
//
//    //[External]
//procedure SetBudgetName(NextBudgetName : Code[10]);
//    begin
//      NewBudgetName := NextBudgetName;
//    end;
//procedure SetGLAccountFilter(NewGLAccFilter : Code[250]);
//    begin
//      GLAccFilter := NewGLAccFilter;
//      GLAccFilterOnAfterValidate;
//    end;
//Local procedure UpdateMatrixSubform();
//    begin
//      CurrPage.MatrixForm.PAGE.Load(
//        MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,LineDimCode,
//        LineDimOption,ColumnDimOption,GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,
//        BudgetDim2Filter,BudgetDim3Filter,BudgetDim4Filter,GLBudgetName,DateFilter,
//        GLAccFilter,IncomeBalanceGLAccFilter,GLAccCategoryFilter,RoundingFactor,PeriodType);
//
//      CurrPage.UPDATE;
//    end;
//Local procedure LineDimCodeOnAfterValidate();
//    begin
//      UpdateMatrixSubform;
//    end;
//Local procedure ColumnDimCodeOnAfterValidate();
//    begin
//      UpdateMatrixSubform;
//    end;
//Local procedure PeriodTypeOnAfterValidate();
//    var
//      MATRIX_Step: Option "Initial","Previous","Same","Next","PreviousColumn","NextColumn";
//    begin
//      if ( ColumnDimOption = ColumnDimOption::Period  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure GLAccFilterOnAfterValidate();
//    begin
//      GLAccBudgetBuf.SETFILTER("G/L Account Filter",GLAccFilter);
//      if ( ColumnDimOption = ColumnDimOption::"G/L Account"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure ValidateIncomeBalanceGLAccFilter();
//    begin
//      GLAccBudgetBuf.SETRANGE("Income/Balance",IncomeBalanceGLAccFilter);
//      if ( ColumnDimOption = ColumnDimOption::"G/L Account"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure ValidateGLAccCategoryFilter();
//    begin
//      GLAccBudgetBuf.SETRANGE("Account Category",GLAccCategoryFilter);
//      if ( ColumnDimOption = ColumnDimOption::"G/L Account"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure GlobalDim2FilterOnAfterValidat();
//    begin
//      GLAccBudgetBuf.SETFILTER("Global Dimension 2 Filter",GlobalDim2Filter);
//      if ( ColumnDimOption = ColumnDimOption::"Global Dimension 2"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure GlobalDim1FilterOnAfterValidat();
//    begin
//      GLAccBudgetBuf.SETFILTER("Global Dimension 1 Filter",GlobalDim1Filter);
//      if ( ColumnDimOption = ColumnDimOption::"Global Dimension 1"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure BudgetDim2FilterOnAfterValidat();
//    begin
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 2 Filter",BudgetDim2Filter);
//      if ( ColumnDimOption = ColumnDimOption::"Budget Dimension 2"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure BudgetDim1FilterOnAfterValidat();
//    begin
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 1 Filter",BudgetDim1Filter);
//      if ( ColumnDimOption = ColumnDimOption::"Budget Dimension 1"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure BudgetDim4FilterOnAfterValidat();
//    begin
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 4 Filter",BudgetDim4Filter);
//      if ( ColumnDimOption = ColumnDimOption::"Budget Dimension 4"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
//Local procedure BudgetDim3FilterOnAfterValidat();
//    begin
//      GLAccBudgetBuf.SETFILTER("Budget Dimension 3 Filter",BudgetDim3Filter);
//      if ( ColumnDimOption = ColumnDimOption::"Budget Dimension 3"  )then
//        MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
//      UpdateMatrixSubform;
//    end;
Local procedure DateFilterOnAfterValidate();
   begin
     if ( ColumnDimOption = ColumnDimOption::Period  )then
       MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
     UpdateMatrixSubform;
   end;
//Local procedure ShowColumnNameOnPush();
//    var
//      MATRIX_Step: Option "Initial","Previous","Same","Next","PreviousColumn","NextColumn";
//    begin
//      MATRIX_GenerateColumnCaptions(MATRIX_Step::Same);
//      UpdateMatrixSubform;
//    end;
LOCAL procedure ValidateDateFilter(NewDateFilter : Text[30]);
    var
      TextManagement : Codeunit 41;
    begin
      TextManagement.MakeDateFilter(NewDateFilter);
      GLAccBudgetBuf.SETFILTER("Date Filter",NewDateFilter);
      DateFilter := COPYSTR(GLAccBudgetBuf.GETFILTER("Date Filter"),1,MAXSTRLEN(DateFilter));
      InternalDateFilter := NewDateFilter;
      DateFilterOnAfterValidate;

      // +QB
      CurrPage.UPDATE;//QB
      // -QB
    end;

//procedure
}


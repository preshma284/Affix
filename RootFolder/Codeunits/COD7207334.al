Codeunit 7207334 "Budget Reestimation Initialize"
{
  
  
    TableNo=7207407;
    trigger OnRun()
VAR
            Window : Dialog;
            locDataPieceworkForProduction : Record 7207386;
            JobBudget : Record 7207407;
            Job : Record 167;
            RateBudgetsbyPiecework : Codeunit 7207329;
          BEGIN
            Window.OPEN(Text010);
            Job.GET(rec."Job No.");
            rec.TESTFIELD("Budget Date");

            //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.Begin
            //JobBudget.SETRANGE("Job No.","Job No.");
            //JobBudget.SETRANGE("Cod. Budget",Job."Current Piecework Budget");
            //IF JobBudget.FINDFIRST THEN BEGIN
            IF JobBudget.GET(rec."Job No.", Job."Current Piecework Budget") THEN BEGIN
            //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.End
              //JAV 11/10/19: - Se marca como presupuesto reestimado y se informa del origen
              Rec.Reestimation := TRUE;
              Rec.Origin := JobBudget."Cod. Budget";
              Rec.MODIFY;

              locDataPieceworkForProduction.SETRANGE("Job No.",rec."Job No.");
              locDataPieceworkForProduction.SETFILTER("Piecework Code",'<>%1','');
              //JMMA
              //ORIGINAL locDataPieceworkForProduction.SETRANGE("Account Type",locDataPieceworkForProduction."Account Type"::Unit);
              IF Job."Mandatory Allocation Term By"=Job."Mandatory Allocation Term By"::"Only Per Piecework" THEN
                locDataPieceworkForProduction.SETRANGE("Account Type",locDataPieceworkForProduction."Account Type"::Unit);
              //JMMA
              locDataPieceworkForProduction.SETRANGE("Production Unit",TRUE);
              IF locDataPieceworkForProduction.FINDSET THEN BEGIN
                ExpectedTimeUnitDataQuantity.RESET;
                IF ExpectedTimeUnitDataQuantity.FINDLAST THEN
                  Entries := ExpectedTimeUnitDataQuantity."Entry No."
                ELSE
                  Entries := 0;
                ForecastDataAmountsPiecewok.RESET;
                IF ForecastDataAmountsPiecewok.FINDLAST THEN
                  EntryAmount := ForecastDataAmountsPiecewok."Entry No."
                ELSE
                  EntryAmount := 0;

                DeleteInitialitation(Job,Rec);
                REPEAT
                  Window.UPDATE(1,FORMAT(locDataPieceworkForProduction."Piecework Code"+'-'+locDataPieceworkForProduction.Description));

                  IF (locDataPieceworkForProduction.Type = locDataPieceworkForProduction.Type::Piecework) THEN BEGIN
                    GenEtryPieceworkProdTotalEstimates(Job,Rec,JobBudget,locDataPieceworkForProduction);
                    IF locDataPieceworkForProduction."Account Type"=locDataPieceworkForProduction."Account Type"::Unit THEN //JMMA
                      CalculateProdBudgetDefault(Job,Rec,JobBudget,locDataPieceworkForProduction)
                  END ELSE BEGIN
                    IF locDataPieceworkForProduction."Account Type"=locDataPieceworkForProduction."Account Type"::Unit THEN //JMMA
                      GenerateEntryCostTotalEstimat(Job,Rec,JobBudget,locDataPieceworkForProduction);
                    IF locDataPieceworkForProduction."Account Type"=locDataPieceworkForProduction."Account Type"::Unit THEN //JMMA
                      CalculateCostPenDefault(Job,Rec,JobBudget,locDataPieceworkForProduction);
                  END;

                  IF locDataPieceworkForProduction."Account Type"=locDataPieceworkForProduction."Account Type"::Unit THEN //JMMA
                    GenerateNewBillofItem(Rec,JobBudget,locDataPieceworkForProduction);

                  IF locDataPieceworkForProduction."Account Type"=locDataPieceworkForProduction."Account Type"::Unit THEN //JMMA
                    GenerateNewMeasureProd(Rec,JobBudget,locDataPieceworkForProduction);
                  //AML Suscriptor
                  OnReestimate(locDataPieceworkForProduction,rec."Cod. Budget",JobBudget."Cod. Budget");
                  //AML Suscriptor

                UNTIL locDataPieceworkForProduction.NEXT = 0;

                CLEAR(RateBudgetsbyPiecework);

                IF locDataPieceworkForProduction."Account Type"=locDataPieceworkForProduction."Account Type"::Unit THEN //JMMA
                  RateBudgetsbyPiecework.ValueInitialization(Job,Rec);
              END;
            END;
          END;
    VAR
      Text010 : TextConst ENU='Loading Pieceworks #1###############',ESP='"Cargando unidades de obra #1############### "';
      ExpectedTimeUnitDataQuantity : Record 7207388;
      Entries : Integer;
      ForecastDataAmountsPiecewok : Record 7207392;
      EntryAmount : Integer;
      ExpectedTimeUnitDataTime : Record 7207388;

    PROCEDURE DeleteInitialitation(Job : Record 167;JobBudget : Record 7207407);
    VAR
      DataCostByPiecework : Record 7207387;
      MeasurementLinPiecewProd : Record 7207390;
    BEGIN
      ExpectedTimeUnitDataQuantity.SETCURRENTKEY("Job No.","Piecework Code","Budget Code");
      ExpectedTimeUnitDataQuantity.SETRANGE("Job No.",JobBudget."Job No.");
      ExpectedTimeUnitDataQuantity.SETRANGE("Budget Code",JobBudget."Cod. Budget");
      IF ExpectedTimeUnitDataQuantity.FINDSET THEN
        ExpectedTimeUnitDataQuantity.DELETEALL;

      ForecastDataAmountsPiecewok.SETCURRENTKEY("Job No.","Piecework Code","Cod. Budget");
      ForecastDataAmountsPiecewok.SETRANGE("Job No.",JobBudget."Job No.");
      ForecastDataAmountsPiecewok.SETRANGE("Cod. Budget",JobBudget."Cod. Budget");

      //JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
      ForecastDataAmountsPiecewok.SETFILTER("Unit Type",'%1|%2',ForecastDataAmountsPiecewok."Entry Type"::Expenses,ForecastDataAmountsPiecewok."Entry Type"::Incomes);

      IF ForecastDataAmountsPiecewok.FINDSET THEN
        ForecastDataAmountsPiecewok.DELETEALL;

      DataCostByPiecework.SETRANGE("Job No.",JobBudget."Job No.");
      DataCostByPiecework.SETRANGE("Cod. Budget",JobBudget."Cod. Budget");
      DataCostByPiecework.DELETEALL;

      MeasurementLinPiecewProd.SETRANGE("Job No.",JobBudget."Job No.");
      MeasurementLinPiecewProd.SETRANGE("Code Budget",JobBudget."Cod. Budget");
      MeasurementLinPiecewProd.DELETEALL;

      ExpectedTimeUnitDataQuantity.RESET;
      ForecastDataAmountsPiecewok.RESET;
      DataCostByPiecework.RESET;
      MeasurementLinPiecewProd.RESET;
    END;

    PROCEDURE GenEtryPieceworkProdTotalEstimates(Job : Record 167;JobBudget : Record 7207407;JobBudgetBefore : Record 7207407;DataPieceworkForProduction : Record 7207386);
    VAR
      JobPostingGroup : Record 208;
      ExpectedTimeUnitData : Record 7207388;
      ForecastDataAmountsPiecework2 : Record 7207392;
      DimensionValue : Record 349;
      FunctionQB : Codeunit 7207272;
    BEGIN
      Job.TESTFIELD("Job Posting Group");
      JobPostingGroup.GET(Job."Job Posting Group");
      JobPostingGroup.TESTFIELD("Sales Analytic Concept");

      DataPieceworkForProduction.SETRANGE("Filter Date",0D,JobBudget."Budget Date" -1);
      DataPieceworkForProduction.CALCFIELDS("Total Measurement Production","Amount Production Performed");

      Entries := Entries + 1;
      IF DataPieceworkForProduction."Account Type"=DataPieceworkForProduction."Account Type"::Unit THEN BEGIN //JMMA
      ExpectedTimeUnitData.INIT;
      ExpectedTimeUnitData."Job No." := JobBudget."Job No.";
      ExpectedTimeUnitData."Piecework Code" := DataPieceworkForProduction."Piecework Code";
      ExpectedTimeUnitData."Expected Date" := JobBudget."Budget Date" - 1;
      ExpectedTimeUnitData."Budget Code" := JobBudget."Cod. Budget";
      ExpectedTimeUnitData."Expected Measured Amount" := DataPieceworkForProduction."Total Measurement Production";
      ExpectedTimeUnitData.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
      ExpectedTimeUnitData."Entry No." := Entries;
      ExpectedTimeUnitData."Unique Code" := DataPieceworkForProduction."Unique Code";
      ExpectedTimeUnitData."Cost Database Code" := DataPieceworkForProduction."Code Cost Database";
      ExpectedTimeUnitData."Unit Type" := DataPieceworkForProduction.Type;
      ExpectedTimeUnitData.Performed := TRUE;
      IF (ExpectedTimeUnitData."Expected Measured Amount" <> 0) THEN
        ExpectedTimeUnitData.INSERT;

      // Ahora a�adimos un registro en la tabla de planificaci�n de importes para la medici�n realizada.
      EntryAmount := EntryAmount + 1;
      ForecastDataAmountsPiecework2.INIT;
      ForecastDataAmountsPiecework2."Entry Type" := ForecastDataAmountsPiecework2."Entry Type"::Incomes;
      ForecastDataAmountsPiecework2."Job No." := JobBudget."Job No.";
      ForecastDataAmountsPiecework2."Piecework Code" := DataPieceworkForProduction."Piecework Code";
      ForecastDataAmountsPiecework2."Expected Date" := JobBudget."Budget Date" - 1;
      ForecastDataAmountsPiecework2."Cod. Budget" := JobBudget."Cod. Budget";
      ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Amount Production Performed";
      ForecastDataAmountsPiecework2.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
      ForecastDataAmountsPiecework2."Analytical Concept" := JobPostingGroup."Sales Analytic Concept";
      ForecastDataAmountsPiecework2."Entry No." := EntryAmount;
      ForecastDataAmountsPiecework2."Unique Code" := DataPieceworkForProduction."Unique Code";
      ForecastDataAmountsPiecework2."Code Cost Database" := DataPieceworkForProduction."Code Cost Database";
      //JMMA DIVISAS DIV
      ForecastDataAmountsPiecework2.VALIDATE("Currency Amount Date",ForecastDataAmountsPiecework2."Expected Date");

      ForecastDataAmountsPiecework2.Performed := TRUE;
      ForecastDataAmountsPiecework2."Unit Type" := DataPieceworkForProduction.Type;
      IF ForecastDataAmountsPiecework2.Amount <> 0 THEN
        ForecastDataAmountsPiecework2.INSERT;
      END; //JMMA
      // Ahora busco costes realizados por UO o concepto anal�tico para generar los movimientos reales en la tabla de previsi�n.
      DimensionValue.RESET;
      DimensionValue.SETRANGE("Dimension Code",FunctionQB.ReturnDimCA);
      //-QB19841 AML 18/05/23 No controlamos que tipo CA van a tener.
      //DimensionValue.SETFILTER("Dimension Value Type",'%1|%2',DimensionValue."Dimension Value Type"::Standard,
      //                                                        DimensionValue."Dimension Value Type"::"Begin-Total");
      //DimensionValue.SETRANGE(Type,DimensionValue.Type::Expenses);
      //+QB19841 AML 18/05/23 No controlamos que tipo CA van a tener.
      IF DimensionValue.FINDSET(FALSE) THEN BEGIN
        REPEAT
          DataPieceworkForProduction.SETFILTER("Filter Analytical Concept",DimensionValue.Code);
          DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)","Actual Cost DP");
          IF DataPieceworkForProduction."Amount Cost Performed (JC)" <> 0 THEN BEGIN
            EntryAmount := EntryAmount + 1;
            ForecastDataAmountsPiecework2.INIT;
            ForecastDataAmountsPiecework2."Entry Type" := ForecastDataAmountsPiecework2."Entry Type"::Expenses;
            ForecastDataAmountsPiecework2."Job No." := JobBudget."Job No.";
            ForecastDataAmountsPiecework2."Piecework Code" := DataPieceworkForProduction."Piecework Code";
            ForecastDataAmountsPiecework2."Expected Date" := JobBudget."Budget Date" -1;
            ForecastDataAmountsPiecework2."Cod. Budget" := JobBudget."Cod. Budget";
            //JMMA ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Amount Cost Performed LCY";
            IF Job."Mandatory Allocation Term By"=Job."Mandatory Allocation Term By"::"AT Any Level" THEN
              ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Actual Cost DP"
            ELSE
              ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Amount Cost Performed (JC)";
            ForecastDataAmountsPiecework2.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
            ForecastDataAmountsPiecework2."Analytical Concept" := DimensionValue.Code;
            //JMMA DIVISAS DIV
            ForecastDataAmountsPiecework2.VALIDATE("Currency Amount Date",ForecastDataAmountsPiecework2."Expected Date");
            ForecastDataAmountsPiecework2."Entry No." := EntryAmount;
            ForecastDataAmountsPiecework2.Performed := TRUE;
            ForecastDataAmountsPiecework2."Unit Type" := DataPieceworkForProduction.Type;
            ForecastDataAmountsPiecework2."Unique Code" := DataPieceworkForProduction."Unique Code";
            ForecastDataAmountsPiecework2."Code Cost Database" := DataPieceworkForProduction."Code Cost Database";
            ForecastDataAmountsPiecework2.INSERT;
          END;
        UNTIL DimensionValue.NEXT = 0;
      END;
      //-QB19841 AML 18/05/23 Para los movs con CA en blanco
      DataPieceworkForProduction.SETFILTER("Filter Analytical Concept",'%1','');
      DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)","Actual Cost DP");
      IF DataPieceworkForProduction."Amount Cost Performed (JC)" <> 0 THEN BEGIN
         EntryAmount := EntryAmount + 1;
         ForecastDataAmountsPiecework2.INIT;
         ForecastDataAmountsPiecework2."Entry Type" := ForecastDataAmountsPiecework2."Entry Type"::Expenses;
         ForecastDataAmountsPiecework2."Job No." := JobBudget."Job No.";
         ForecastDataAmountsPiecework2."Piecework Code" := DataPieceworkForProduction."Piecework Code";
         ForecastDataAmountsPiecework2."Expected Date" := JobBudget."Budget Date" -1;
         ForecastDataAmountsPiecework2."Cod. Budget" := JobBudget."Cod. Budget";
         IF Job."Mandatory Allocation Term By"=Job."Mandatory Allocation Term By"::"AT Any Level" THEN
           ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Actual Cost DP"
         ELSE
           ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Amount Cost Performed (JC)";
         ForecastDataAmountsPiecework2.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
         ForecastDataAmountsPiecework2."Analytical Concept" := '';
         ForecastDataAmountsPiecework2.VALIDATE("Currency Amount Date",ForecastDataAmountsPiecework2."Expected Date");
         ForecastDataAmountsPiecework2."Entry No." := EntryAmount;
         ForecastDataAmountsPiecework2.Performed := TRUE;
         ForecastDataAmountsPiecework2."Unit Type" := DataPieceworkForProduction.Type;
         ForecastDataAmountsPiecework2."Unique Code" := DataPieceworkForProduction."Unique Code";
         ForecastDataAmountsPiecework2."Code Cost Database" := DataPieceworkForProduction."Code Cost Database";
         ForecastDataAmountsPiecework2.INSERT;
      END;
      //+QB18841
    END;

    PROCEDURE CalculateProdBudgetDefault(PJob : Record 167;PJobBudget : Record 7207407;PJobBudgetBefore : Record 7207407;PDataPieceworkForProduction : Record 7207386);
    VAR
      MeasureRealizeTheoretical : Decimal;
      Difference : Decimal;
      Accumulated : Decimal;
      NumberPeriods : Integer;
      ExpectedTimeUnitDataPrev : Record 7207388;
    BEGIN
      PDataPieceworkForProduction.SETRANGE("Filter Date",0D,PJobBudget."Budget Date"-1);
      PDataPieceworkForProduction.SETRANGE("Budget Filter",PJobBudgetBefore."Cod. Budget");
      PDataPieceworkForProduction.CALCFIELDS("Total Measurement Production","Amount Production Performed","Budget Measure");
      ExpectedTimeUnitDataTime.RESET;
      ExpectedTimeUnitDataTime.SETCURRENTKEY("Job No.","Piecework Code","Budget Code","Expected Date");
      ExpectedTimeUnitDataTime.SETRANGE("Job No.",PJobBudget."Job No.");
      ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",PDataPieceworkForProduction."Piecework Code");
      ExpectedTimeUnitDataTime.SETRANGE("Budget Code",PJobBudgetBefore."Cod. Budget");
      ExpectedTimeUnitDataTime.SETRANGE("Expected Date",0D,PJobBudget."Budget Date" - 1);
      ExpectedTimeUnitDataTime.CALCSUMS("Expected Measured Amount");
      MeasureRealizeTheoretical := ExpectedTimeUnitDataTime."Expected Measured Amount";
      Difference := MeasureRealizeTheoretical - PDataPieceworkForProduction."Total Measurement Production";
      //jmma IF Difference > 0 THEN BEGIN
      IF Difference <> 0 THEN BEGIN
        Accumulated := 0;
        ExpectedTimeUnitDataTime.SETRANGE("Job No.",PJobBudget."Job No.");
        ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",PDataPieceworkForProduction."Piecework Code");
        ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',PJobBudget."Budget Date");
        ExpectedTimeUnitDataTime.SETRANGE("Budget Code",PJobBudgetBefore."Cod. Budget");
        NumberPeriods := ExpectedTimeUnitDataTime.COUNT;
        IF ExpectedTimeUnitDataTime.FINDSET(FALSE) THEN BEGIN
          REPEAT
            ExpectedTimeUnitDataPrev.RESET;
            ExpectedTimeUnitDataPrev.VALIDATE("Job No.",PJobBudget."Job No.");
            Entries := Entries + 1;
            ExpectedTimeUnitDataPrev.VALIDATE("Piecework Code",PDataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitDataPrev.VALIDATE("Budget Code",PJobBudget."Cod. Budget");
            ExpectedTimeUnitDataPrev.VALIDATE("Expected Date",ExpectedTimeUnitDataTime."Expected Date");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",ExpectedTimeUnitDataTime."Expected Measured Amount" +
                                              ROUND(Difference / NumberPeriods,0.01));
            ExpectedTimeUnitDataPrev."Entry No." := Entries;
            ExpectedTimeUnitDataPrev.Performed := FALSE;
            ExpectedTimeUnitDataPrev.INSERT;
            Accumulated := Accumulated + ROUND(Difference / NumberPeriods,0.01)

          UNTIL ExpectedTimeUnitDataTime.NEXT = 0;
          IF Accumulated <> Difference THEN BEGIN
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",ExpectedTimeUnitDataPrev."Expected Measured Amount" +
                                             (Difference - Accumulated));
            ExpectedTimeUnitDataPrev.MODIFY;
          END;
        END ELSE BEGIN
          ExpectedTimeUnitDataPrev.RESET;
          ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",PJobBudget."Job No.");
          Entries := Entries + 1;
          ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",PDataPieceworkForProduction."Piecework Code");
          ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",PJobBudget."Cod. Budget");
          ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",PJobBudget."Budget Date");
          ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",
                                            PDataPieceworkForProduction."Budget Measure" - PDataPieceworkForProduction."Total Measurement Production");
          ExpectedTimeUnitDataPrev."Entry No." := Entries;
          ExpectedTimeUnitDataPrev.Performed := FALSE;
          ExpectedTimeUnitDataPrev.INSERT;
        END;
      END ELSE BEGIN
        IF Difference = 0 THEN BEGIN
          ExpectedTimeUnitDataTime.SETRANGE("Job No.",PJobBudget."Job No.");
          ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",PDataPieceworkForProduction."Piecework Code");
          //JMMA ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',PJobBudgetBefore."Budget Date"); //CORREGIDO ERROR EN MIGRACI�N
          ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',PJobBudget."Budget Date");
          ExpectedTimeUnitDataTime.SETRANGE("Budget Code",PJobBudgetBefore."Cod. Budget");
          NumberPeriods := ExpectedTimeUnitDataTime.COUNT;
          IF ExpectedTimeUnitDataTime.FINDSET(FALSE) THEN BEGIN
            REPEAT
              ExpectedTimeUnitDataPrev.RESET;
              Entries := Entries + 1;
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",PJobBudget."Job No.");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",PDataPieceworkForProduction."Piecework Code");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",PJobBudget."Cod. Budget");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",ExpectedTimeUnitDataTime."Expected Date");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",ExpectedTimeUnitDataTime."Expected Measured Amount");
              ExpectedTimeUnitDataPrev."Entry No." := Entries;
              ExpectedTimeUnitDataPrev.Performed := FALSE;
              ExpectedTimeUnitDataPrev.INSERT;
            //JMMA ERROR MIGRACI�N UNTIL ExpectedTimeUnitDataPrev.NEXT = 0;
            UNTIL ExpectedTimeUnitDataTime.NEXT=0;
          END ELSE BEGIN
            ExpectedTimeUnitDataPrev.RESET;
            Entries := Entries + 1;
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",PJobBudget."Job No.");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",PDataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",PJobBudget."Cod. Budget");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",PJobBudget."Budget Date");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",
                                              PDataPieceworkForProduction."Budget Measure" - PDataPieceworkForProduction."Total Measurement Production");
            ExpectedTimeUnitDataPrev."Entry No." := Entries;
            ExpectedTimeUnitDataPrev.Performed := FALSE;
            ExpectedTimeUnitDataPrev.INSERT;
          END;
        END ELSE BEGIN
      // Si hay para restar resto
            ExpectedTimeUnitDataTime.SETRANGE("Job No.",PJobBudget."Job No.");
            ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",PDataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',PJobBudget."Budget Date");
            ExpectedTimeUnitDataTime.SETRANGE("Budget Code",PJobBudgetBefore."Cod. Budget");
            NumberPeriods := ExpectedTimeUnitDataTime.COUNT;
            IF ExpectedTimeUnitDataTime.FINDSET(FALSE) THEN BEGIN
              REPEAT
              ExpectedTimeUnitDataPrev.RESET;
              Entries := Entries + 1;
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",PJobBudget."Job No.");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",PDataPieceworkForProduction."Piecework Code");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",PJobBudget."Cod. Budget");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",ExpectedTimeUnitDataTime."Expected Date");
              IF ExpectedTimeUnitDataTime."Expected Measured Amount" >= ABS(Difference) THEN BEGIN
                ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",
                                                  ExpectedTimeUnitDataTime."Expected Measured Amount" +
                                                  Difference);
                Difference := 0;
              END ELSE BEGIN
                ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",0);
                Difference := Difference + ExpectedTimeUnitDataTime."Expected Measured Amount"
              END;
              ExpectedTimeUnitDataPrev."Entry No." := Entries;
              ExpectedTimeUnitDataPrev.Performed := FALSE;
              ExpectedTimeUnitDataPrev.INSERT;
            UNTIL ExpectedTimeUnitDataTime.NEXT = 0;
          END ELSE BEGIN
            ExpectedTimeUnitDataPrev.RESET;
            Entries := Entries + 1;
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",PJobBudget."Job No.");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",PDataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",PJobBudget."Cod. Budget");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",PJobBudget."Budget Date");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",
                                              PDataPieceworkForProduction."Budget Measure" - PDataPieceworkForProduction."Total Measurement Production");
            ExpectedTimeUnitDataPrev."Entry No." := Entries;
            ExpectedTimeUnitDataPrev.Performed := FALSE;
            ExpectedTimeUnitDataPrev.INSERT;
          END;
        END;
      END;
    END;

    PROCEDURE GenerateNewBillofItem(JobBudgetrPresent : Record 7207407;JobBudgetBefore : Record 7207407;DataPieceworkForProduction : Record 7207386);
    VAR
      DataCostByPiecework : Record 7207387;
      DataCostByPieceworkNew : Record 7207387;
    BEGIN
      // Ahora genero el nuevo descompuesto en vase al que se ha heredado o definido en la reestimaci�n
      DataCostByPiecework.SETRANGE("Job No.",JobBudgetBefore."Job No.");
      DataCostByPiecework.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");
      DataCostByPiecework.SETRANGE("Cod. Budget",JobBudgetBefore."Cod. Budget");
      IF DataCostByPiecework.FINDSET THEN
        REPEAT
          DataCostByPieceworkNew.INIT;
          DataCostByPieceworkNew."Job No." := DataCostByPiecework."Job No.";
          DataCostByPieceworkNew."Piecework Code" := DataCostByPiecework."Piecework Code";
          DataCostByPieceworkNew."Cod. Budget" := JobBudgetrPresent."Cod. Budget";
          DataCostByPieceworkNew."Cost Type" := DataCostByPiecework."Cost Type";
          //-Q18970 AML Traspasar el campo N
          DataCostByPieceworkNew."Order No." := DataCostByPiecework."Order No.";
          //+Q18970
          DataCostByPieceworkNew."No." := DataCostByPiecework."No.";
          DataCostByPieceworkNew."Analytical Concept Direct Cost" := DataCostByPiecework."Analytical Concept Direct Cost";
          DataCostByPieceworkNew."Analytical Concept Ind. Cost" := DataCostByPiecework."Analytical Concept Ind. Cost";
          DataCostByPieceworkNew."Performance By Piecework" := DataCostByPiecework."Performance By Piecework";
          DataCostByPieceworkNew."Budget Quantity" := DataCostByPiecework."Budget Quantity";
          //JMMA 020221
          DataCostByPieceworkNew."Activity Code":=DataCostByPiecework."Activity Code";
          //JMMA DIV
          DataCostByPieceworkNew."Currency Code":=DataCostByPiecework."Currency Code";
          DataCostByPieceworkNew."Currency Date":=DataCostByPiecework."Currency Date";
          DataCostByPieceworkNew."Currency Factor":=DataCostByPiecework."Currency Factor";
          DataCostByPieceworkNew."Direc Unit Cost":=DataCostByPiecework."Direc Unit Cost";
          //DIV
          DataCostByPieceworkNew."Direct Unitary Cost (JC)" := DataCostByPiecework."Direct Unitary Cost (JC)";
          DataCostByPieceworkNew."Indirect Unit Cost" := DataCostByPiecework."Indirect Unit Cost";
          DataCostByPieceworkNew."Budget Cost" := DataCostByPiecework."Budget Cost";
          DataCostByPieceworkNew."Cod. Measure Unit" := DataCostByPiecework."Cod. Measure Unit";
          DataCostByPieceworkNew."Code Cost Database" := DataCostByPiecework."Code Cost Database";
          DataCostByPieceworkNew."Unique Code" := DataCostByPiecework."Unique Code";
          DataCostByPieceworkNew.Description := DataCostByPiecework.Description;
          //-Q20031
          DataCostByPieceworkNew.Vendor := DataCostByPiecework.Vendor;
          DataCostByPieceworkNew."Vendor Name" := DataCostByPiecework."Vendor Name";
          //+Q20031
          DataCostByPieceworkNew.INSERT;
        UNTIL DataCostByPiecework.NEXT = 0;
    END;

    PROCEDURE GenerateNewMeasureProd(JobBudgetPresent : Record 7207407;JobBudgetBefore : Record 7207407;DataPieceworkForProduction : Record 7207386);
    VAR
      MeasurementLinesJUProd : Record 7207390;
      MeasurementLinesJUProdNew : Record 7207390;
    BEGIN
      MeasurementLinesJUProd.SETRANGE("Job No.",JobBudgetBefore."Job No.");
      MeasurementLinesJUProd.SETRANGE("Code Budget",JobBudgetBefore."Cod. Budget");
      MeasurementLinesJUProd.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");
      IF MeasurementLinesJUProd.FINDSET THEN
        REPEAT
          MeasurementLinesJUProdNew := MeasurementLinesJUProd;
          MeasurementLinesJUProdNew."Code Budget" := JobBudgetPresent."Cod. Budget";
          MeasurementLinesJUProdNew.INSERT;
        UNTIL MeasurementLinesJUProd.NEXT = 0;
    END;

    PROCEDURE CalculateCostPenDefault(Job : Record 167;JobBudget : Record 7207407;JobBudgetBefore : Record 7207407;DataPieceworkForProduction : Record 7207386);
    VAR
      ExpectedTimeUnitDataPrev : Record 7207388;
      PercentageCostIncurred : Decimal;
      QuantityPerform : Decimal;
      MeasurePerformedTheoretical : Decimal;
      Difference : Decimal;
      Accumulate : Decimal;
      NumberPeriodic : Integer;
      ExpectedMeasuredAmountDif : Decimal;
    BEGIN
      DataPieceworkForProduction.SETRANGE("Budget Filter",JobBudgetBefore."Cod. Budget");

      DataPieceworkForProduction.SETRANGE("Filter Date");
      DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Amount Cost Budget (JC)",DataPieceworkForProduction."Budget Measure");

      DataPieceworkForProduction.SETRANGE("Filter Date",0D,JobBudget."Budget Date"-1);
      DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Amount Cost Performed (JC)");

      IF DataPieceworkForProduction."Amount Cost Budget (JC)" <> 0 THEN
        PercentageCostIncurred := DataPieceworkForProduction."Amount Cost Performed (JC)" / DataPieceworkForProduction."Amount Cost Budget (JC)";

      QuantityPerform := DataPieceworkForProduction."Budget Measure" * PercentageCostIncurred;
      // Si me he pasado en los corrientes o en los diferidos no porcentua ya no sigo. Dejo el pendiente a cero.
      // Los diferidos porcentuales se van corrigiendo seg�n toquemos la producci�n.
      IF DataPieceworkForProduction."Amount Cost Performed (JC)" > DataPieceworkForProduction."Amount Cost Budget (JC)" THEN BEGIN
        IF (DataPieceworkForProduction.Type <> DataPieceworkForProduction.Type::Piecework) THEN BEGIN
          IF (DataPieceworkForProduction."Subtype Cost" = DataPieceworkForProduction."Subtype Cost"::"Current Expenses") OR
             ((DataPieceworkForProduction."Subtype Cost" = DataPieceworkForProduction."Subtype Cost"::"Deprec. Deferred") AND
              (DataPieceworkForProduction."% Expense Cost" = 0)) THEN
            EXIT;
        END;
      END;

      // El pendiente en los indirectos es el futuro desde fecha de estimaci�n.
      ExpectedTimeUnitDataTime.RESET;
      ExpectedTimeUnitDataTime.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
      ExpectedTimeUnitDataTime.SETRANGE("Job No.",JobBudget."Job No.");
      ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");

      //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.Begin
      //El Filtro "Expected Date" se usa m�s abajo, se elimina por redundante
      //ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',JobBudget."Budget Date");
      //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.End

      ExpectedTimeUnitDataTime.SETRANGE("Budget Code",JobBudgetBefore."Cod. Budget");
      ExpectedTimeUnitDataTime.SETRANGE("Expected Date",0D,JobBudget."Budget Date" - 1);
      ExpectedTimeUnitDataTime.CALCSUMS("Expected Measured Amount");
      //ERROR EN MIGRACI�N MeasurePerformedTheoretical := MeasurePerformedTheoretical - QuantityPerform;
      MeasurePerformedTheoretical:=ExpectedTimeUnitDataTime."Expected Measured Amount";
      Difference := MeasurePerformedTheoretical - QuantityPerform;
      //JMMA 011020 modificado para que haga el c�lculo cuando es negativo tambi�n
      //IF Difference > 0 THEN BEGIN
      IF Difference <> 0 THEN BEGIN
        Accumulate := 0;
        ExpectedTimeUnitDataTime.SETRANGE("Job No.",JobBudget."Job No.");
        ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");
        ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',JobBudget."Budget Date");
        ExpectedTimeUnitDataTime.SETRANGE("Budget Code",JobBudgetBefore."Cod. Budget");
        NumberPeriodic := ExpectedTimeUnitDataTime.COUNT;
        IF ExpectedTimeUnitDataTime.FINDSET(FALSE) THEN BEGIN
          REPEAT
            //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.Begin
            InsertNewExpectedTimeUnitData(
                JobBudget."Job No.", DataPieceworkForProduction."Piecework Code", JobBudget."Cod. Budget", ExpectedTimeUnitDataTime."Expected Date",
                ExpectedTimeUnitDataTime."Expected Measured Amount" + ROUND(Difference / NumberPeriodic,0.01),
                FALSE, ExpectedTimeUnitDataTime."Unit Type", ExpectedTimeUnitDataPrev);

            // ExpectedTimeUnitDataPrev.RESET;
            // ExpectedTimeUnitDataPrev.VALIDATE("Job No.",JobBudget."Job No.");
            // Entries := Entries + 1;
            // ExpectedTimeUnitDataPrev.VALIDATE("Piecework Code",DataPieceworkForProduction."Piecework Code");
            // ExpectedTimeUnitDataPrev.VALIDATE("Budget Code",JobBudget."Cod. Budget");
            // ExpectedTimeUnitDataPrev.VALIDATE("Expected Date",ExpectedTimeUnitDataTime."Expected Date");
            // ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",ExpectedTimeUnitDataTime."Expected Measured Amount" +
            //                                  ROUND(Difference / NumberPeriodic,0.01));
            // ExpectedTimeUnitDataPrev."Entry No." := Entries;
            // ExpectedTimeUnitDataPrev.Performed := FALSE;
            // //JMMA FALTA ASIGNAR TIPO ERROR001
            // ExpectedTimeUnitDataPrev."Unit Type":=ExpectedTimeUnitDataTime."Unit Type";
            // ExpectedTimeUnitDataPrev.INSERT;
            //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.End
            Accumulate := Accumulate + ROUND(Difference / NumberPeriodic,0.01)

          UNTIL ExpectedTimeUnitDataTime.NEXT = 0;
          IF Accumulate <> Difference THEN BEGIN
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",ExpectedTimeUnitDataPrev."Expected Measured Amount" +
                                             (Difference - Accumulate));
            ExpectedTimeUnitDataPrev.MODIFY;
          END;
        END ELSE BEGIN
          //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.Begin
          InsertNewExpectedTimeUnitData(
                JobBudget."Job No.", DataPieceworkForProduction."Piecework Code", JobBudget."Cod. Budget", JobBudget."Budget Date",
                DataPieceworkForProduction."Budget Measure" - QuantityPerform,
                FALSE, DataPieceworkForProduction.Type, ExpectedTimeUnitDataPrev);

          // ExpectedTimeUnitDataPrev.RESET;
          // ExpectedTimeUnitDataPrev.VALIDATE("Job No.",JobBudget."Job No.");
          // Entries := Entries + 1;
          // ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",DataPieceworkForProduction."Piecework Code");
          // ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",JobBudget."Cod. Budget");
          // ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",JobBudget."Budget Date");
          // ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",
          //                                  DataPieceworkForProduction."Budget Measure" - QuantityPerform);
          // ExpectedTimeUnitDataPrev."Entry No." := Entries;
          // ExpectedTimeUnitDataPrev.Performed := FALSE;
          // //JMMA ERROR001
          // ExpectedTimeUnitDataPrev."Unit Type":=DataPieceworkForProduction.Type;
          // ExpectedTimeUnitDataPrev.INSERT;
          //CPA 20-04-22: Q17004. Mejora del rendimiento del proceso de reestimaciones.End
        END;
      END ELSE BEGIN
        IF Difference = 0 THEN BEGIN
          ExpectedTimeUnitDataTime.SETRANGE("Job No.",JobBudget."Job No.");
          ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");
          ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',JobBudget."Budget Date");
          ExpectedTimeUnitDataTime.SETRANGE("Budget Code",JobBudgetBefore."Cod. Budget");
          NumberPeriodic := ExpectedTimeUnitDataTime.COUNT;
          IF ExpectedTimeUnitDataTime.FINDSET(FALSE) THEN BEGIN
            REPEAT
              ExpectedTimeUnitDataPrev.RESET;
              Entries := Entries + 1;
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",JobBudget."Job No.");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",DataPieceworkForProduction."Piecework Code");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",JobBudget."Cod. Budget");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",ExpectedTimeUnitDataTime."Expected Date");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",ExpectedTimeUnitDataTime."Expected Measured Amount");
              ExpectedTimeUnitDataPrev."Entry No." := Entries;
              ExpectedTimeUnitDataPrev.Performed := FALSE;
              //JMMA ERROR001
              ExpectedTimeUnitDataPrev."Unit Type":=ExpectedTimeUnitDataTime."Unit Type";
              ExpectedTimeUnitDataPrev.INSERT;
            UNTIL ExpectedTimeUnitDataTime.NEXT = 0;
          END ELSE BEGIN
            ExpectedTimeUnitDataPrev.RESET;
            Entries := Entries + 1;
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",JobBudget."Job No.");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",DataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",JobBudget."Cod. Budget");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",JobBudget."Budget Date");
            ExpectedTimeUnitDataPrev.VALIDATE("Expected Measured Amount",
                                              DataPieceworkForProduction."Budget Measure" - QuantityPerform);
            ExpectedTimeUnitDataPrev."Entry No." := Entries;
            ExpectedTimeUnitDataPrev.Performed := FALSE;
            //JMMA ERROR001
            ExpectedTimeUnitDataPrev."Unit Type":=DataPieceworkForProduction.Type;
            ExpectedTimeUnitDataPrev.INSERT;
          END;
        END ELSE BEGIN
      // Si hay para restar resto
          ExpectedTimeUnitDataTime.SETRANGE("Job No.",JobBudget."Job No.");
          ExpectedTimeUnitDataTime.SETRANGE("Piecework Code",DataPieceworkForProduction."Piecework Code");
          ExpectedTimeUnitDataTime.SETFILTER("Expected Date",'>=%1',JobBudget."Budget Date");
          ExpectedTimeUnitDataTime.SETRANGE("Budget Code",JobBudgetBefore."Cod. Budget");
          NumberPeriodic := ExpectedTimeUnitDataTime.COUNT;
          ExpectedTimeUnitDataTime.CALCSUMS("Expected Measured Amount"); //JMMA 1908
          ExpectedMeasuredAmountDif := ExpectedTimeUnitDataTime."Expected Measured Amount"; //JMMA 1908
          IF ExpectedTimeUnitDataTime.FINDSET(FALSE) THEN BEGIN
            REPEAT
              //JMMA 1908 se debe revisar este proceso porque cuando informo medici�n y corrijo en presupuesto de costes indirectos, crea m�s de una l�nea
              //en el expected time unit data y en este caso falla el c�lculo.
              ExpectedTimeUnitDataPrev.RESET;
              Entries := Entries + 1;
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",JobBudget."Job No.");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",DataPieceworkForProduction."Piecework Code");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",JobBudget."Cod. Budget");
              ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",ExpectedTimeUnitDataTime."Expected Date");
              IF ExpectedTimeUnitDataTime."Expected Measured Amount" >= ABS(Difference) THEN BEGIN
                //JMMA 1908 ExpectedTimeUnitDataPrev.VALIDATE("Expected Measured Amount",ExpectedTimeUnitDataTime."Expected Measured Amount" + Difference);
                ExpectedTimeUnitDataPrev.VALIDATE("Expected Measured Amount",ExpectedMeasuredAmountDif + Difference);
                Difference := 0;
              END ELSE BEGIN
                ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount",0);
                Difference := Difference + ExpectedTimeUnitDataTime."Expected Measured Amount"
              END;
              ExpectedTimeUnitDataPrev."Entry No." := Entries;
              ExpectedTimeUnitDataPrev.Performed := FALSE;
              //JMMA ERROR001
              ExpectedTimeUnitDataPrev."Unit Type":=ExpectedTimeUnitDataTime."Unit Type";
              ExpectedTimeUnitDataPrev.INSERT;
            UNTIL ExpectedTimeUnitDataTime.NEXT = 0;
          END ELSE BEGIN
            ExpectedTimeUnitDataPrev.RESET;
            Entries := Entries + 1;
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Job No.",JobBudget."Job No.");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Piecework Code",DataPieceworkForProduction."Piecework Code");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Budget Code",JobBudget."Cod. Budget");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Date",JobBudget."Budget Date");
            ExpectedTimeUnitDataPrev.VALIDATE(ExpectedTimeUnitDataPrev."Expected Measured Amount", DataPieceworkForProduction."Budget Measure" - QuantityPerform);
            ExpectedTimeUnitDataPrev."Entry No." := Entries;
            ExpectedTimeUnitDataPrev.Performed := FALSE;
            //JMMA ERROR001
            ExpectedTimeUnitDataPrev."Unit Type":=DataPieceworkForProduction.Type;
            ExpectedTimeUnitDataPrev.INSERT;
          END;
        END;
      END;
    END;

    PROCEDURE GenerateEntryCostTotalEstimat(Job : Record 167;JobBudgetPresent : Record 7207407;JobBudgetBefore : Record 7207407;DataPieceworkForProduction : Record 7207386);
    VAR
      JobPostingGroup : Record 208;
      ExpectedTimeUnitData3 : Record 7207388;
      ForecastDataAmountsPiecework2 : Record 7207392;
      DimensionValue : Record 349;
      FunctionQB : Codeunit 7207272;
      PercentageCostIncurred : Decimal;
    BEGIN
      Job.TESTFIELD("Job Posting Group");
      JobPostingGroup.GET(Job."Job Posting Group");

      DataPieceworkForProduction.SETRANGE("Budget Filter",JobBudgetBefore."Cod. Budget");
      DataPieceworkForProduction.SETRANGE("Filter Date");
      DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)","Budget Measure");
      DataPieceworkForProduction.SETRANGE("Filter Date",0D,JobBudgetPresent."Budget Date" - 1);
      DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");

      IF DataPieceworkForProduction."Amount Cost Budget (JC)" <> 0 THEN
        PercentageCostIncurred := DataPieceworkForProduction."Amount Cost Performed (JC)" / DataPieceworkForProduction."Amount Cost Budget (JC)"
      // Para que ponga los realizados si no tiene presupuesto de costes
      ELSE
        PercentageCostIncurred := 1;

      Entries := Entries + 1;
      ExpectedTimeUnitData3.INIT;
      ExpectedTimeUnitData3."Job No." := JobBudgetPresent."Job No.";
      ExpectedTimeUnitData3."Piecework Code" := DataPieceworkForProduction."Piecework Code";
      ExpectedTimeUnitData3."Expected Date" := JobBudgetPresent."Budget Date" - 1;
      ExpectedTimeUnitData3."Budget Code" := JobBudgetPresent."Cod. Budget";
      IF DataPieceworkForProduction."Subtype Cost" <> DataPieceworkForProduction."Subtype Cost"::"Current Expenses" THEN
        ExpectedTimeUnitData3."Expected Measured Amount" := DataPieceworkForProduction."Amount Cost Performed (JC)"
      ELSE
        ExpectedTimeUnitData3."Expected Measured Amount" := DataPieceworkForProduction."Budget Measure" * PercentageCostIncurred;

      ExpectedTimeUnitData3.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
      ExpectedTimeUnitData3."Entry No." := Entries;
      ExpectedTimeUnitData3."Unique Code" := DataPieceworkForProduction."Unique Code";
      ExpectedTimeUnitData3."Cost Database Code" := DataPieceworkForProduction."Code Cost Database";
      ExpectedTimeUnitData3."Unit Type" := DataPieceworkForProduction.Type;
      ExpectedTimeUnitData3.Performed := TRUE;
      IF (ExpectedTimeUnitData3."Expected Measured Amount" <> 0) THEN
        ExpectedTimeUnitData3.INSERT;

      // ahora busco costes realizados por UO y concepto anal�tico para generar los movimientos reales en la tabal de previsi�n.
      DimensionValue.RESET;
      DimensionValue.SETRANGE("Dimension Code",FunctionQB.ReturnDimCA);
      //-QB19841 AML 18/05/23 No controlamos el tipo de Dimension
      //DimensionValue.SETFILTER("Dimension Value Type",'%1|%2',DimensionValue."Dimension Value Type"::Standard,
      //                                                        DimensionValue."Dimension Value Type"::"Begin-Total");
      //DimensionValue.SETRANGE(Type,DimensionValue.Type::Expenses);
      //+QB19841
      IF DimensionValue.FINDSET(FALSE) THEN BEGIN
        REPEAT
          DataPieceworkForProduction.SETFILTER("Filter Analytical Concept",DimensionValue.Code);
          DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
          IF DataPieceworkForProduction."Amount Cost Performed (JC)" <> 0 THEN BEGIN
            EntryAmount := EntryAmount + 1;
            ForecastDataAmountsPiecework2.INIT;
            ForecastDataAmountsPiecework2."Entry Type" := ForecastDataAmountsPiecework2."Entry Type"::Expenses;
            ForecastDataAmountsPiecework2."Job No." := JobBudgetPresent."Job No.";
            ForecastDataAmountsPiecework2."Piecework Code" := DataPieceworkForProduction."Piecework Code";
            ForecastDataAmountsPiecework2."Expected Date" := JobBudgetPresent."Budget Date" - 1;
            ForecastDataAmountsPiecework2."Cod. Budget" := JobBudgetPresent."Cod. Budget";
            ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Amount Cost Performed (JC)";
            ForecastDataAmountsPiecework2.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
            ForecastDataAmountsPiecework2."Analytical Concept" := DimensionValue.Code;
            ForecastDataAmountsPiecework2."Entry No." := EntryAmount;
            //JMMA DIVISAS DIV
            ForecastDataAmountsPiecework2.VALIDATE("Currency Amount Date",ForecastDataAmountsPiecework2."Expected Date");
            ForecastDataAmountsPiecework2.Performed := TRUE;
            ForecastDataAmountsPiecework2."Unit Type" := DataPieceworkForProduction.Type;
            ForecastDataAmountsPiecework2."Unique Code" := DataPieceworkForProduction."Unique Code";
            ForecastDataAmountsPiecework2."Code Cost Database" := DataPieceworkForProduction."Code Cost Database";
            ForecastDataAmountsPiecework2.INSERT;
          END;
        UNTIL DimensionValue.NEXT = 0;
      END;

      //-QB19841 AML 18/05/23 Para CA en blanco
      DataPieceworkForProduction.SETFILTER("Filter Analytical Concept",'%1','');
      DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
      IF DataPieceworkForProduction."Amount Cost Performed (JC)" <> 0 THEN BEGIN
         EntryAmount := EntryAmount + 1;
         ForecastDataAmountsPiecework2.INIT;
         ForecastDataAmountsPiecework2."Entry Type" := ForecastDataAmountsPiecework2."Entry Type"::Expenses;
         ForecastDataAmountsPiecework2."Job No." := JobBudgetPresent."Job No.";
         ForecastDataAmountsPiecework2."Piecework Code" := DataPieceworkForProduction."Piecework Code";
         ForecastDataAmountsPiecework2."Expected Date" := JobBudgetPresent."Budget Date" - 1;
         ForecastDataAmountsPiecework2."Cod. Budget" := JobBudgetPresent."Cod. Budget";
         ForecastDataAmountsPiecework2.Amount := DataPieceworkForProduction."Amount Cost Performed (JC)";
         ForecastDataAmountsPiecework2.Description := COPYSTR(DataPieceworkForProduction.Description,1,30);
         ForecastDataAmountsPiecework2."Analytical Concept" := '';
         ForecastDataAmountsPiecework2."Entry No." := EntryAmount;
         //JMMA DIVISAS DIV
         ForecastDataAmountsPiecework2.VALIDATE("Currency Amount Date",ForecastDataAmountsPiecework2."Expected Date");
         ForecastDataAmountsPiecework2.Performed := TRUE;
         ForecastDataAmountsPiecework2."Unit Type" := DataPieceworkForProduction.Type;
         ForecastDataAmountsPiecework2."Unique Code" := DataPieceworkForProduction."Unique Code";
         ForecastDataAmountsPiecework2."Code Cost Database" := DataPieceworkForProduction."Code Cost Database";
         ForecastDataAmountsPiecework2.INSERT;
       END;
      //+QB19841
    END;

    LOCAL PROCEDURE InsertNewExpectedTimeUnitData(JobNo : Code[20];PieceworkCode : Text[20];BudgetCode : Code[20];ExpectedDate : Date;ExpectedMeasuredAmount : Decimal;Performed : Boolean;UnitType : Integer;VAR ExpectedTimeUnitData : Record 7207388);
    BEGIN
      Entries += 1;

      ExpectedTimeUnitData.INIT;
      ExpectedTimeUnitData."Entry No." := Entries;
      ExpectedTimeUnitData.VALIDATE("Job No.",JobNo);
      ExpectedTimeUnitData.VALIDATE("Piecework Code", PieceworkCode);
      ExpectedTimeUnitData.VALIDATE("Budget Code", BudgetCode);
      ExpectedTimeUnitData.VALIDATE("Expected Date", ExpectedDate);
      ExpectedTimeUnitData.VALIDATE("Expected Measured Amount", ExpectedMeasuredAmount);
      ExpectedTimeUnitData.Performed := Performed;
      ExpectedTimeUnitData."Unit Type":= UnitType;

      ExpectedTimeUnitData.INSERT;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnReestimate(VAR DataPieceworkForProduction : Record 7207386;JobBudgetNo : Code[20];OldJobBudgetNo : Code[20]);
    BEGIN
    END;

    /*BEGIN
/*{
      JAV 11/10/19: - Se marca como presupuesto reestimado y se informa del origen
      JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
      CPA 20/04/22: - QB 1.10.37 (Q17004) Mejora del rendimiento del proceso de reestimaciones
      AML 18/05/23 QB19841 Modificar la creaci�n de Forecast Data Amount Piecework para que tenga en cuenta los producidos con cualquier CA, tocadas las funciones
           GenEtryPieceworkProdTotalEstimates y GenerateEntryCostTotalEstimat
      AML 01/06/23  - Q18970 Copiar La tabla Data Cost By Piecework Con el campo N� ORden
      AML 05/09/23  - -Q20031 Copiar Vendor a la tabla Data Cost By Piecework
    }
END.*/
}








Codeunit 7207329 "Rate Budgets by Piecework"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      ExpectedTimeUnitData : Record 7207388;
      AmountTotal : Decimal;
      AmountAccumuled : Decimal;
      LastEntryPrevious : Integer;
      Job : Record 167;
      DataPieceworkForProduction : Record 7207386;
      DataPieceworkForProductionP : Record 7207386;
      JobGG : Decimal;
      JobIB : Decimal;
      JobLC : Decimal;
      JobIC : Decimal;
      DataPieceworkCode : Code[20];
      RecalculateBase : Boolean;
      NotSeeDialog : Boolean;
      MarkRecalculated : Boolean;

    PROCEDURE ValueInitialization(VAR JobP : Record 167;VAR JobBudgetP : Record 7207407);
    VAR
      QuoBuildingSetup : Record 7207278;
      Currency : Record 4;
      Job : Record 167;
      JobPostingGroup : Record 208;
      ForecastDataAmountsJU : Record 7207392;
      DataJobUnitForProduction : Record 7207386;
      DataCostByJU : Record 7207387;
      HistSalePricesJU : Record 7207385;
      DialogWindow : Dialog;
      TotalProductionAmount : Decimal;
      NumberEntry : Integer;
      Text000 : TextConst ESP='Calculando presupuesto\Presupuesto #1##########################\Unidad de obra #2##########################\Descompuesto #3##########################\Procesando #4##########################';
      Text001 : TextConst ENU='Adding incomes',ESP='Insertando ingresos';
      LAmountProductionTotal : Decimal;
      JobVersion : Boolean;
      ConvertToBudgetxCA : Codeunit 7207282;
    BEGIN
      IF (NotSeeDialog = FALSE) THEN
        DialogWindow.OPEN(Text000);

      CLEAR(Currency);
      Currency.InitRoundingPrecision;
      JobP.MODIFY;      //Guardo antes de empezar el c lculo
      JobP.TESTFIELD("Job Posting Group");
      JobPostingGroup.GET(JobP."Job Posting Group");
      JobPostingGroup.TESTFIELD("Sales Analytic Concept");

      IF (NotSeeDialog = FALSE) THEN BEGIN
        DialogWindow.UPDATE(1,FORMAT(JobP."No."+'-'+JobP.Description));
        DialogWindow.UPDATE(2,'');
        DialogWindow.UPDATE(3,'Preparando datos');
      END;

      //Elimino los registro de la tabla de movimientos de importes y busco el £ltimo registro ---------------------------------------------------------------------------------------------------------
      ForecastDataAmountsJU.RESET;
      ForecastDataAmountsJU.SETCURRENTKEY("Job No.","Cod. Budget","Unit Type",Performed,"Piecework Code");   //JAV 24/05/22: - QB 1.10.43 A¤adimos Key apropiada para acelerar el proceso //JAV 25/05/22 QB 1.10.44 Se mejora
      ForecastDataAmountsJU.SETRANGE("Job No.",JobP."No.");
      ForecastDataAmountsJU.SETRANGE("Cod. Budget",JobBudgetP."Cod. Budget");
      //Q18527
      //ForecastDataAmountsJU.SETRANGE(Performed,FALSE);
      IF JobBudgetP.Reestimation THEN ForecastDataAmountsJU.SETRANGE(Performed,FALSE);
      //Q18527

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        ForecastDataAmountsJU.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      //JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
      ForecastDataAmountsJU.SETFILTER("Unit Type",'%1|%2',ForecastDataAmountsJU."Entry Type"::Expenses,ForecastDataAmountsJU."Entry Type"::Incomes);

      //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
      IF ForecastDataAmountsJU.FINDSET THEN
        REPEAT
          IF (NotSeeDialog = FALSE) THEN
            DialogWindow.UPDATE(2, ForecastDataAmountsJU."Piecework Code");
          ForecastDataAmountsJU.DELETE(FALSE);
        UNTIL ForecastDataAmountsJU.NEXT = 0;

      ForecastDataAmountsJU.RESET;
      IF ForecastDataAmountsJU.FINDLAST THEN
        NumberEntry := ForecastDataAmountsJU."Entry No."
      ELSE
        NumberEntry := 0;

      //JAV 25/05/22: - QB 1.10.43 Optimizaciones, no se pasa funci¢n para alquiler si no est  activo el m¢dulo
      IF (QuoBuildingSetup."Rental Management") THEN
        CalculateUtilityRentInJobBudget(JobP,JobBudgetP);

      //Preparo los costes ----------------------------------------------------------------------------------------------------------------------------------------
      DataJobUnitForProduction.RESET;
      DataJobUnitForProduction.SETCURRENTKEY("Job No.","Account Type","Production Unit","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
      DataJobUnitForProduction.SETRANGE("Job No.",JobP."No.");
      DataJobUnitForProduction.SETRANGE("Account Type",DataJobUnitForProduction."Account Type"::Unit);
      DataJobUnitForProduction.SETRANGE("Production Unit",TRUE);

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        DataJobUnitForProduction.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      IF DataJobUnitForProduction.FINDSET(FALSE) THEN BEGIN
        REPEAT
          IF (NotSeeDialog = FALSE) THEN
            DialogWindow.UPDATE(2,FORMAT(DataJobUnitForProduction."Piecework Code" + '-' + DataJobUnitForProduction.Description));

          //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
          IF (NotSeeDialog = FALSE) THEN
            DialogWindow.UPDATE(4,'');

          IF (DataJobUnitForProduction.Type = DataJobUnitForProduction.Type::"Cost Unit") AND
             ((DataJobUnitForProduction."Periodic Cost") OR
             (DataJobUnitForProduction."Allocation Terms" <> DataJobUnitForProduction."Allocation Terms"::"Fixed Amount")) THEN BEGIN
          END ELSE BEGIN
            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Piecework Code","Budget Code",Performed);  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
            ExpectedTimeUnitData.SETRANGE("Job No.",DataJobUnitForProduction."Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code",DataJobUnitForProduction."Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
            //Q18527
            //ExpectedTimeUnitData.SETRANGE(Performed,FALSE); //JMMA todo lo que no es incurrido
            IF JobBudgetP.Reestimation THEN ExpectedTimeUnitData.SETRANGE(Performed,FALSE); //JMMA todo lo que no es incurrido
            //Q18527
            IF ExpectedTimeUnitData.FINDSET(FALSE) THEN BEGIN
              //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
              IF (NotSeeDialog = FALSE) THEN
                DialogWindow.UPDATE(4,ExpectedTimeUnitData."Piecework Code");

              REPEAT
                DataCostByJU.RESET;  //**
                DataCostByJU.SETCURRENTKEY("Job No.","Piecework Code","Cod. Budget");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento, esta es ya la clave primaria
                DataCostByJU.SETRANGE("Job No.",ExpectedTimeUnitData."Job No.");
                DataCostByJU.SETRANGE("Piecework Code",ExpectedTimeUnitData."Piecework Code");
                DataCostByJU.SETRANGE("Cod. Budget",JobBudgetP."Cod. Budget");
                IF DataCostByJU.FINDSET(FALSE) THEN BEGIN
                  REPEAT
                    IF (NotSeeDialog = FALSE) THEN
                      DialogWindow.UPDATE(3,FORMAT(DataCostByJU."Cost Type")+'-'+DataCostByJU."No."+' '+FORMAT(DataCostByJU."Performance By Piecework"));
                    NumberEntry += 1;
                    ForecastDataAmountsJU.INIT;
                    ForecastDataAmountsJU."Entry No." := NumberEntry;
                    ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Expenses;
                    ForecastDataAmountsJU."Job No." := DataCostByJU."Job No.";
                    ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                    ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                    ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                    IF DataCostByJU."Indirect Unit Cost" = 0 THEN BEGIN
                      ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount" * DataCostByJU."Budget Cost",
                                                    Currency."Amount Rounding Precision");
                    END ELSE BEGIN
                      ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount" *
                                               ROUND(DataCostByJU."Performance By Piecework" * DataCostByJU."Direct Unitary Cost (JC)",
                                               Currency."Amount Rounding Precision"),Currency."Amount Rounding Precision");
                    END;
                    ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                    ForecastDataAmountsJU."Analytical Concept" := DataCostByJU."Analytical Concept Direct Cost";
                    ForecastDataAmountsJU.Description := DataCostByJU.BillOfItemsDescription;
                    ForecastDataAmountsJU."Code Cost Database" := DataCostByJU."Code Cost Database";
                    ForecastDataAmountsJU."Unique Code" := DataCostByJU."Unique Code";
                    ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                    ForecastDataAmountsJU.INSERT;
                    IF (DataCostByJU."Indirect Unit Cost" <> 0) THEN BEGIN
                      DataCostByJU.TESTFIELD("Analytical Concept Ind. Cost");
                      NumberEntry += 1;
                      ForecastDataAmountsJU.INIT;
                      ForecastDataAmountsJU."Entry No." := NumberEntry;
                      ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Expenses;
                      ForecastDataAmountsJU."Job No." := DataCostByJU."Job No.";
                      ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                      ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                      ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                      ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*
                                              ROUND(DataCostByJU."Performance By Piecework" * DataCostByJU."Indirect Unit Cost",
                                              Currency."Amount Rounding Precision")
                                              ,Currency."Amount Rounding Precision");
                      ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                      ForecastDataAmountsJU."Analytical Concept" := DataCostByJU."Analytical Concept Ind. Cost";
                      ForecastDataAmountsJU.Description := DataCostByJU.BillOfItemsDescription;
                      ForecastDataAmountsJU."Code Cost Database" := DataCostByJU."Code Cost Database";
                      ForecastDataAmountsJU."Unique Code" := DataCostByJU."Unique Code";
                      ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                      ForecastDataAmountsJU.INSERT;
                    END;
                  UNTIL DataCostByJU.NEXT = 0;
                END;
              UNTIL ExpectedTimeUnitData.NEXT=0;
            END;
          END;
        UNTIL DataJobUnitForProduction.NEXT = 0;
      END;

      //Preparo los ingresos en funcion de los costes que deben estar previamente insertados ----------------------------------------------------------------------------------------------------------
      DataJobUnitForProduction.RESET;
      DataJobUnitForProduction.SETCURRENTKEY("Job No.","Account Type","Production Unit","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
      DataJobUnitForProduction.SETRANGE("Job No.",JobP."No.");
      DataJobUnitForProduction.SETRANGE("Account Type",DataJobUnitForProduction."Account Type"::Unit);
      DataJobUnitForProduction.SETRANGE("Production Unit",TRUE);

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        DataJobUnitForProduction.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      DataJobUnitForProduction.SETRANGE("Budget Filter",JobBudgetP."Cod. Budget");  //Este es un FlowFilter, no puede estar en la clave

      IF (DataJobUnitForProduction.FINDSET(FALSE)) THEN BEGIN
        REPEAT
          DataJobUnitForProduction.CALCFIELDS("Measure Pending Budget");
          IF DataJobUnitForProduction."Measure Pending Budget"<>0 THEN BEGIN
            IF (NotSeeDialog = FALSE) THEN
              DialogWindow.UPDATE(2,FORMAT(DataJobUnitForProduction."Piecework Code"+'-'+DataJobUnitForProduction.Description));
            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Piecework Code","Budget Code",Performed);  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
            ExpectedTimeUnitData.SETRANGE("Job No.",DataJobUnitForProduction."Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code",DataJobUnitForProduction."Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
            //Q18527
            //ExpectedTimeUnitData.SETRANGE(Performed,FALSE);
            IF JobBudgetP.Reestimation THEN ExpectedTimeUnitData.SETRANGE(Performed,FALSE);
            //Q18527
            IF ExpectedTimeUnitData.FINDSET(FALSE) THEN BEGIN
              REPEAT
                //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo  JAV 23/05/22: - QB 1.10.43 Se cambia de lugar para que se mueva un poco
                IF (NotSeeDialog = FALSE) THEN
                  DialogWindow.UPDATE(4,DataJobUnitForProduction."Piecework Code" + ' L¡nea ' + FORMAT(ExpectedTimeUnitData."Entry No."));

                IF (NotSeeDialog = FALSE) THEN BEGIN
                  DialogWindow.UPDATE(2, ExpectedTimeUnitData."Piecework Code");  //JAV 08/04/22: - QB 1.10.33 Presentar datos por pantalla
                  DialogWindow.UPDATE(3,Text001);
                END;
                NumberEntry += 1;
                ForecastDataAmountsJU.INIT;
                ForecastDataAmountsJU."Entry No." := NumberEntry;
                ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Incomes;
                ForecastDataAmountsJU."Job No." := JobP."No.";
                ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                IF JobBudgetP."Budget Date" <> 0D THEN
                  DataJobUnitForProduction.SETRANGE("Filter Date",0D,JobBudgetP."Budget Date"-1);
                //-Q18527 Modificar el calculo para copiar
                //Se desactiva por el momento
                //ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction.PendingProductionPrice,
                //                              Currency."Amount Rounding Precision");

                IF JobBudgetP.Reestimation THEN
                   ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction.PendingProductionPrice,
                                              Currency."Amount Rounding Precision")
                ELSE
                   ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction.PendingPrice,
                                              Currency."Amount Rounding Precision");

                //+Q18527
/*{//QVE >> Comentado por Manuel Mu¤oz, preguntar
                DataJobUnitForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                Job.GET(DataJobUnitForProduction."Job No.");
                JobGG := (ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget" * Job."General Expenses / Other")/100;
                JobIB := (ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget" * Job."Industrial Benefit")/100;
                JobLC := (ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget" * Job."Low Coefficient")/100;
                JobIC := (ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget" * Job."Quality Deduction")/100;
                ForecastDataAmountsJU.Amount := ROUND((ExpectedTimeUnitData."Expected Measured Amount" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget") + JobGG + JobIB + JobLC + JobIC,
                                              Currency."Amount Rounding Precision");
                //QVE <<
                }*/
                DataJobUnitForProduction.SETRANGE("Filter Date");
                ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                ForecastDataAmountsJU."Analytical Concept" := JobPostingGroup."Sales Analytic Concept";
                ForecastDataAmountsJU.Description := ExpectedTimeUnitData.Description;
                ForecastDataAmountsJU."Code Cost Database" := DataJobUnitForProduction."Code Cost Database";
                ForecastDataAmountsJU."Unique Code" := DataJobUnitForProduction."Unique Code";
                ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                ForecastDataAmountsJU.INSERT;
              UNTIL ExpectedTimeUnitData.NEXT=0;
            END;
            //Genero un registro en la tabla de precios de venta con el precio de venta inicial.
            HistSalePricesJU.INIT;
            HistSalePricesJU."Cod. Reestimate" := '';
            HistSalePricesJU."Job No." := DataJobUnitForProduction."Job No.";
            HistSalePricesJU."Piecework Code" := DataJobUnitForProduction."Piecework Code";
            HistSalePricesJU."Sale Price" := DataJobUnitForProduction.ProductionPrice;
            IF NOT HistSalePricesJU.INSERT THEN
              HistSalePricesJU.MODIFY;
/*{---------------------------------------------------------------------------------------------------------------------- NO ACTIVAR ESTO, da problemas
            //JAV 09/09/20: - QB 1.06.09 Si el proyecto tiene separaci¢n coste-venta, usar el precio correcto
            Job.GET(DataJobUnitForProduction."Job No.");
            IF (Job."Separation Job Unit/Cert. Unit") THEN BEGIN
              //JAV 04/08/20: - Pongo el precio de venta en las unidades de coste cuando hay separaci¢n coste-venta
              //IF (DataJobUnitForProduction."Production Unit") AND (NOT DataJobUnitForProduction."Customer Certification Unit") THEN BEGIN
                DataJobUnitForProduction.VALIDATE("Contract Price", DataJobUnitForProduction.ProductionPrice);
                DataJobUnitForProduction.MODIFY;
              //END;
            END;
            ----------------------------------------------------------------------------------------------------------------------}*/

        //cuando la cantidad pendiente es cero
          END ELSE BEGIN
            DataJobUnitForProduction.CALCFIELDS(DataJobUnitForProduction."Amount Budg. Prod. Performed");
            LAmountProductionTotal := DataJobUnitForProduction.AmountProductionAssigned;
            IF DataJobUnitForProduction."Amount Budg. Prod. Performed" <> LAmountProductionTotal THEN BEGIN
              //hay que poner una importe con la diferencia de producci¢n

                IF (NotSeeDialog = FALSE) THEN BEGIN
                  DialogWindow.UPDATE(2, DataJobUnitForProduction."Piecework Code");  //JAV 08/04/22: - QB 1.10.33 Presentar datos por pantalla
                  DialogWindow.UPDATE(3,Text001);
                  //JAV 23/05/22: - QB 1.10.43 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
                  DialogWindow.UPDATE(4,ForecastDataAmountsJU."Piecework Code" + ' L¡nea ' + FORMAT(ForecastDataAmountsJU."Entry No."));
                END;
                NumberEntry += 1;
                ForecastDataAmountsJU.INIT;
                ForecastDataAmountsJU."Entry No." := NumberEntry;
                ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Incomes;
                ForecastDataAmountsJU."Job No." := JobP."No.";
                ForecastDataAmountsJU."Expected Date" :=JobBudgetP."Budget Date";
                ForecastDataAmountsJU."Cod. Budget" := JobBudgetP."Cod. Budget";
                ForecastDataAmountsJU."Piecework Code" := DataJobUnitForProduction."Piecework Code";
                ForecastDataAmountsJU.Amount :=LAmountProductionTotal-DataJobUnitForProduction."Amount Budg. Prod. Performed";
                ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                ForecastDataAmountsJU."Analytical Concept" := JobPostingGroup."Sales Analytic Concept";
                ForecastDataAmountsJU.Description := DataJobUnitForProduction.Description;
                ForecastDataAmountsJU."Code Cost Database" := DataJobUnitForProduction."Code Cost Database";
                ForecastDataAmountsJU."Unique Code" := DataJobUnitForProduction."Unique Code";
                ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                ForecastDataAmountsJU.INSERT;
             END;
          END;

       UNTIL DataJobUnitForProduction.NEXT = 0;
      END;

      //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
      IF (NotSeeDialog = FALSE) THEN
        DialogWindow.UPDATE(4,'');


      //Los que van por porcentajes ----------------------------------------------------------------------------------------------------------------------------------------
      //JAV 18/05/22: - QB 1.10.42 Se mejoran los procesos de c lculo para los porcentuales, no considerar ejecutado porque no tiene sentido

      DataJobUnitForProduction.RESET;
      DataJobUnitForProduction.SETCURRENTKEY("Job No.","Account Type",Type,"Allocation Terms","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
      DataJobUnitForProduction.SETRANGE("Job No.",JobP."No.");
      DataJobUnitForProduction.SETRANGE("Account Type",DataJobUnitForProduction."Account Type"::Unit);
      DataJobUnitForProduction.SETRANGE(Type,DataJobUnitForProduction.Type::"Cost Unit");
      DataJobUnitForProduction.SETFILTER("Allocation Terms",'%1|%2', DataJobUnitForProduction."Allocation Terms"::"% on Production", DataJobUnitForProduction."Allocation Terms"::"% on Direct Costs");
      DataJobUnitForProduction.SETRANGE("Budget Filter",JobBudgetP."Cod. Budget");

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        DataJobUnitForProduction.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      IF DataJobUnitForProduction.FINDSET(TRUE) THEN BEGIN
        IF (NotSeeDialog = FALSE) THEN
          DialogWindow.UPDATE(2,FORMAT(DataJobUnitForProduction."Piecework Code"+'-'+DataJobUnitForProduction.Description));

        //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
        IF (NotSeeDialog = FALSE) THEN
          DialogWindow.UPDATE(4,'');

        REPEAT
          DataJobUnitForProduction.UpdateMeasurementByPercentage;  //JAV Se ha cambiado el nombre de la funci¢n para que est‚ mas claro
          IF NOT DataJobUnitForProduction."Periodic Cost" THEN BEGIN
            DataJobUnitForProduction.CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget");
            IF JobBudgetP."Budget Date" <> 0D THEN
              DataJobUnitForProduction.SETRANGE("Filter Date",0D,JobBudgetP."Budget Date"-1)
            ELSE
              DataJobUnitForProduction.SETRANGE("Filter Date",0D);
            DataJobUnitForProduction.CALCFIELDS("Amount Cost Performed (JC)");
            DataJobUnitForProduction.SETRANGE("Filter Date");
            AmountTotal := ROUND(DataJobUnitForProduction."Budget Measure" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget",
                                   Currency."Amount Rounding Precision") - DataJobUnitForProduction."Amount Cost Performed (JC)";

            DataJobUnitForProduction.MODIFY;
            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Piecework Code","Budget Code",Performed);  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
            ExpectedTimeUnitData.SETRANGE("Job No.",DataJobUnitForProduction."Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code",DataJobUnitForProduction."Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
            ExpectedTimeUnitData.SETRANGE(Performed,FALSE);
            IF ExpectedTimeUnitData.FINDFIRST THEN BEGIN
              REPEAT
                //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
                IF (NotSeeDialog = FALSE) THEN
                  DialogWindow.UPDATE(4,DataJobUnitForProduction."Piecework Code");

                DataCostByJU.RESET;
                DataCostByJU.SETCURRENTKEY("Job No.","Piecework Code","Cod. Budget");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento, esta es ya la clave primaria
                DataCostByJU.SETRANGE("Job No.",ExpectedTimeUnitData."Job No.");
                DataCostByJU.SETRANGE("Piecework Code",ExpectedTimeUnitData."Piecework Code");
                DataCostByJU.SETRANGE("Cod. Budget",JobBudgetP."Cod. Budget");
                IF DataCostByJU.FINDFIRST THEN BEGIN
                  REPEAT
                    IF (NotSeeDialog = FALSE) THEN
                      DialogWindow.UPDATE(3,FORMAT(DataCostByJU."Cost Type")+'-'+DataCostByJU."No."+' '+FORMAT(DataCostByJU."Performance By Piecework"));
                    NumberEntry += 1;
                    ForecastDataAmountsJU.INIT;
                    ForecastDataAmountsJU."Entry No." := NumberEntry;
                    ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Expenses;
                    ForecastDataAmountsJU."Job No." := DataCostByJU."Job No.";
                    ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                    ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                    ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                    IF DataCostByJU."Indirect Unit Cost" = 0 THEN BEGIN
                      ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*DataCostByJU."Budget Cost",
                                                    Currency."Amount Rounding Precision");
                    END ELSE BEGIN
                      ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*
                                               ROUND(DataCostByJU."Performance By Piecework" * DataCostByJU."Direct Unitary Cost (JC)",
                                               Currency."Amount Rounding Precision"),Currency."Amount Rounding Precision");
                    END;
                    ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                    ForecastDataAmountsJU."Analytical Concept" := DataCostByJU."Analytical Concept Direct Cost";
                    ForecastDataAmountsJU.Description := DataCostByJU.BillOfItemsDescription;
                    ForecastDataAmountsJU."Code Cost Database" := DataCostByJU."Code Cost Database";
                    ForecastDataAmountsJU."Unique Code" := DataCostByJU."Unique Code";
                    ForecastDataAmountsJU.Performed := FALSE;
                    ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                    ForecastDataAmountsJU.INSERT;
                    AmountAccumuled := AmountAccumuled + ForecastDataAmountsJU.Amount;
                    IF (DataCostByJU."Indirect Unit Cost" <> 0) THEN BEGIN
                      DataCostByJU.TESTFIELD("Analytical Concept Ind. Cost");
                      NumberEntry += 1;
                      ForecastDataAmountsJU.INIT;
                      ForecastDataAmountsJU."Entry No." := NumberEntry;
                      ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Expenses;
                      ForecastDataAmountsJU."Job No." := DataCostByJU."Job No.";
                      ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                      ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                      ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                      ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*
                                              ROUND(DataCostByJU."Performance By Piecework" * DataCostByJU."Indirect Unit Cost",
                                                    Currency."Amount Rounding Precision")
                                                   ,Currency."Amount Rounding Precision");
                      ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                      ForecastDataAmountsJU."Analytical Concept" := DataCostByJU."Analytical Concept Ind. Cost";
                      ForecastDataAmountsJU.Description := DataCostByJU.BillOfItemsDescription;
                      ForecastDataAmountsJU."Code Cost Database" := DataCostByJU."Code Cost Database";
                      ForecastDataAmountsJU."Unique Code" := DataCostByJU."Unique Code";
                      ForecastDataAmountsJU.Performed := FALSE;
                      ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                      ForecastDataAmountsJU.INSERT;
                      AmountAccumuled := AmountAccumuled + ForecastDataAmountsJU.Amount;
                    END;
                  UNTIL DataCostByJU.NEXT = 0;
                END;
              UNTIL ExpectedTimeUnitData.NEXT=0;
              //JAV 18/05/22: - QB 1.10.42 No ajustar nada, el c clulo siempre es sobre el total
/*{---
              //JAV 08/04/22: - QB 1.10.33 Solo modificamos si es la misma unidad de obra, no podemos tocar otras
              IF (ForecastDataAmountsJU."Piecework Code" = DataJobUnitForProduction."Piecework Code") AND (AmountAccumuled <> AmountTotal) THEN BEGIN
                ForecastDataAmountsJU.Amount := ForecastDataAmountsJU.Amount - (AmountAccumuled - AmountTotal);
                ForecastDataAmountsJU.MODIFY;
              END;
              ---}*/
              AmountAccumuled := 0;
            END;
          END;
        UNTIL DataJobUnitForProduction.NEXT = 0;
      END;

      //Comentarios: Gestion de costes indirectos periodificables ----------------------------------------------------------------------------------------------------------------------------------------
      //Preparo los costes indirectos periodificables
      DataJobUnitForProduction.RESET;
      DataJobUnitForProduction.SETCURRENTKEY("Job No.","Account Type",Type,"Type Unit Cost","Periodic Cost","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
      DataJobUnitForProduction.SETRANGE("Job No.",JobP."No.");
      DataJobUnitForProduction.SETRANGE("Account Type",DataJobUnitForProduction."Account Type"::Unit);
      DataJobUnitForProduction.SETRANGE(Type,DataJobUnitForProduction.Type::"Cost Unit");
      DataJobUnitForProduction.SETRANGE("Type Unit Cost",DataJobUnitForProduction."Type Unit Cost"::Internal);
      DataJobUnitForProduction.SETRANGE("Periodic Cost",TRUE);
      DataJobUnitForProduction.SETRANGE("Budget Filter",JobBudgetP."Cod. Budget");

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        DataJobUnitForProduction.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      IF DataJobUnitForProduction.FINDSET THEN BEGIN
        IF (NotSeeDialog = FALSE) THEN
          DialogWindow.UPDATE(2,FORMAT(DataJobUnitForProduction."Piecework Code"+'-'+DataJobUnitForProduction.Description));
        //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
        IF (NotSeeDialog = FALSE) THEN
          DialogWindow.UPDATE(4,'');

        REPEAT
      //RITMO DE AMORTIZACION
          //JMMA 07/05/202 Se comenta esta l¡nea porque en los indirectos fijos periodificables no calcula correctamente el pendiente
          //DataJobUnitForProduction.PlanQuantity;
          DataJobUnitForProduction.CALCFIELDS("Budget Measure",DataJobUnitForProduction."Aver. Cost Price Pend. Budget");
          IF JobBudgetP."Budget Date" <> 0D THEN
            DataJobUnitForProduction.SETRANGE("Filter Date",0D,JobBudgetP."Budget Date"-1)
          ELSE
            DataJobUnitForProduction.SETRANGE("Filter Date",0D);
          DataJobUnitForProduction.CALCFIELDS("Amount Cost Performed (JC)");
          DataJobUnitForProduction.SETRANGE("Filter Date");
          AmountTotal := ROUND(DataJobUnitForProduction."Budget Measure" * DataJobUnitForProduction."Aver. Cost Price Pend. Budget",
                                   Currency."Amount Rounding Precision") - DataJobUnitForProduction."Amount Cost Performed (JC)";
          DataJobUnitForProduction.MODIFY;
          ExpectedTimeUnitData.RESET;
          ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Piecework Code","Budget Code",Performed);  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
          ExpectedTimeUnitData.SETRANGE("Job No.",DataJobUnitForProduction."Job No.");
          ExpectedTimeUnitData.SETRANGE("Piecework Code",DataJobUnitForProduction."Piecework Code");
          ExpectedTimeUnitData.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
          ExpectedTimeUnitData.SETRANGE(Performed,FALSE);
          IF ExpectedTimeUnitData.FINDFIRST THEN BEGIN
            REPEAT
              //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
              IF (NotSeeDialog = FALSE) THEN
                DialogWindow.UPDATE(4,ExpectedTimeUnitData."Piecework Code");

              DataCostByJU.RESET;
              DataCostByJU.SETCURRENTKEY("Job No.","Piecework Code","Cod. Budget");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento, esta es ya la clave primaria
              DataCostByJU.SETRANGE("Job No.",ExpectedTimeUnitData."Job No.");
              DataCostByJU.SETRANGE("Piecework Code",ExpectedTimeUnitData."Piecework Code");
              DataCostByJU.SETRANGE("Cod. Budget",JobBudgetP."Cod. Budget");
              IF DataCostByJU.FINDFIRST THEN BEGIN
                REPEAT
                  IF (NotSeeDialog = FALSE) THEN
                    DialogWindow.UPDATE(3,FORMAT(DataCostByJU."Cost Type")+'-'+DataCostByJU."No."+' '+FORMAT(DataCostByJU."Performance By Piecework"));
                  NumberEntry += 1;
                  ForecastDataAmountsJU.INIT;
                  ForecastDataAmountsJU."Entry No." := NumberEntry;
                  ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Expenses;
                  ForecastDataAmountsJU."Job No." := DataCostByJU."Job No.";
                  ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                  ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                  ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                  IF DataCostByJU."Indirect Unit Cost" = 0 THEN BEGIN
                    ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*DataCostByJU."Budget Cost",
                                                  Currency."Amount Rounding Precision");
                  END ELSE BEGIN
                    ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*
                                             ROUND(DataCostByJU."Performance By Piecework" * DataCostByJU."Direct Unitary Cost (JC)",
                                             Currency."Amount Rounding Precision"),Currency."Amount Rounding Precision");
                  END;
                  ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                  ForecastDataAmountsJU."Analytical Concept" := DataCostByJU."Analytical Concept Direct Cost";
                  ForecastDataAmountsJU.Description := DataCostByJU.BillOfItemsDescription;
                  ForecastDataAmountsJU."Code Cost Database" := DataCostByJU."Code Cost Database";
                  ForecastDataAmountsJU."Unique Code" := DataCostByJU."Unique Code";
                  ForecastDataAmountsJU.Performed := FALSE;
                  ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                  ForecastDataAmountsJU.INSERT;
                  AmountAccumuled := AmountAccumuled + ForecastDataAmountsJU.Amount;
                  IF (DataCostByJU."Indirect Unit Cost" <> 0) THEN BEGIN
                    DataCostByJU.TESTFIELD("Analytical Concept Ind. Cost");
                    NumberEntry += 1;
                    ForecastDataAmountsJU.INIT;
                    ForecastDataAmountsJU."Entry No." := NumberEntry;
                    ForecastDataAmountsJU."Entry Type" := ForecastDataAmountsJU."Entry Type"::Expenses;
                    ForecastDataAmountsJU."Job No." := DataCostByJU."Job No.";
                    ForecastDataAmountsJU."Expected Date" := ExpectedTimeUnitData."Expected Date";
                    ForecastDataAmountsJU."Cod. Budget" := ExpectedTimeUnitData."Budget Code";
                    ForecastDataAmountsJU."Piecework Code" := ExpectedTimeUnitData."Piecework Code";
                    ForecastDataAmountsJU.Amount := ROUND(ExpectedTimeUnitData."Expected Measured Amount"*
                                            ROUND(DataCostByJU."Performance By Piecework" * DataCostByJU."Indirect Unit Cost",
                                                  Currency."Amount Rounding Precision")
                                                 ,Currency."Amount Rounding Precision");
                    ForecastDataAmountsJU."Unit Type" := DataJobUnitForProduction.Type;
                    ForecastDataAmountsJU."Analytical Concept" := DataCostByJU."Analytical Concept Ind. Cost";
                    ForecastDataAmountsJU.Description := DataCostByJU.BillOfItemsDescription;
                    ForecastDataAmountsJU."Code Cost Database" := DataCostByJU."Code Cost Database";
                    ForecastDataAmountsJU."Unique Code" := DataCostByJU."Unique Code";
                    ForecastDataAmountsJU.Performed := FALSE;
                    ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date"); //JobBudgetP."Value Date"); //GEN003-03
                    ForecastDataAmountsJU.INSERT;
                    AmountAccumuled := AmountAccumuled + ForecastDataAmountsJU.Amount;
                  END;
                UNTIL DataCostByJU.NEXT = 0;
              END;
            UNTIL ExpectedTimeUnitData.NEXT=0;

      //++
      // //      //JAV 08/04/22: - QB 1.10.33 Solo modificamos si es la misma unidad de obra, no podemos tocar otras
      // //      IF (ForecastDataAmountsJU."Piecework Code" = DataJobUnitForProduction."Piecework Code") AND (AmountAccumuled <> AmountTotal) THEN BEGIN
      // //        ForecastDataAmountsJU.Amount := ForecastDataAmountsJU.Amount - (AmountAccumuled - AmountTotal);
      // //        //JAV 17/05/22: - QB 1.10.42 No calculaba los importes en las otras divisas en el ajuste final del indirecto
      // //        ForecastDataAmountsJU.VALIDATE("Currency Amount Date", ForecastDataAmountsJU."Expected Date");
      // //        ForecastDataAmountsJU.MODIFY;
      // //      END;
            AmountAccumuled := 0;
          END;
        UNTIL DataJobUnitForProduction.NEXT = 0;
      END;

      //jmma recalculo de sumatorios para venta ----------------------------------------------------------------------------------------------------------------------------------------
      DataJobUnitForProduction.RESET;
      DataJobUnitForProduction.SETCURRENTKEY("Job No.","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
      DataJobUnitForProduction.SETRANGE("Job No.",JobP."No.");
      DataJobUnitForProduction.SETRANGE("Budget Filter",JobBudgetP."Cod. Budget");

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        DataJobUnitForProduction.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      IF DataJobUnitForProduction.FINDSET(FALSE) THEN
        REPEAT
          //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
          IF (NotSeeDialog = FALSE) THEN
            DialogWindow.UPDATE(4,ExpectedTimeUnitData."Piecework Code");

          IF DataJobUnitForProduction."Account Type" = DataJobUnitForProduction."Account Type"::Heading THEN BEGIN
            DataJobUnitForProduction."Sale Amount":=0;
            DataJobUnitForProduction."Amount Sale Contract":=0;
            DataPieceworkForProductionP.RESET;
            DataPieceworkForProductionP.SETCURRENTKEY("Job No.","Account Type","Customer Certification Unit","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejoras de rendimiento
            DataPieceworkForProductionP.SETRANGE("Job No.",DataJobUnitForProduction."Job No.");
            DataPieceworkForProductionP.SETFILTER("Piecework Code",DataJobUnitForProduction.Totaling);
            DataPieceworkForProductionP.SETRANGE("Account Type",DataPieceworkForProductionP."Account Type"::Unit);
            DataPieceworkForProductionP.SETRANGE("Customer Certification Unit",TRUE);
            IF DataPieceworkForProductionP.FINDSET THEN
              REPEAT
                DataJobUnitForProduction."Amount Sale Contract" += DataPieceworkForProductionP."Amount Sale Contract";
                DataJobUnitForProduction."Sale Amount" += DataPieceworkForProductionP."Sale Amount";
              UNTIL DataPieceworkForProductionP.NEXT = 0;
            DataJobUnitForProduction.MODIFY;
          END;
        UNTIL DataJobUnitForProduction.NEXT = 0;
      //jmma fin
      //JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n, evitar que se pare mucho en un lugar fijo
      IF (NotSeeDialog = FALSE) THEN
        DialogWindow.UPDATE(4,'');

      //JAV 30/01/20: - Marcar que el presupuesto est  calculado pero falta el anal¡tico, Solo si es una obra  ---------------------------------------------------------------------------------------------
      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      //JAV 05/05/21: - QB 1.08.41 Mejora en el campo Card Type
      IF (DataPieceworkCode = '') OR ((DataPieceworkCode <> '') AND (MarkRecalculated)) THEN BEGIN
        CASE JobP."Card Type" OF
          JobP."Card Type"::Estudio :
            BEGIN
              JobP."Pending Calculation Budget" := FALSE;
              JobP.MODIFY;
            END;
          JobP."Card Type"::"Proyecto operativo" :
            BEGIN
              JobBudgetP.GET(JobP."No.", JobBudgetP."Cod. Budget");
              JobBudgetP."Pending Calculation Budget" := FALSE;
              JobBudgetP.MODIFY;
            END;
          END;
      END;

      //Calcular datos adicionales de la producci¢n ----------------------------------------------------------------------------------------------------------------------------------------
      IF (NotSeeDialog = FALSE) THEN BEGIN
        DialogWindow.UPDATE(2,'');
        DialogWindow.UPDATE(3,'Producci¢n');
      END;
      JobBudgetP.CalculateProduction;

      COMMIT; //Si da un error en el anal¡tico el presupuesto ha quedado calculado correctamente
      IF (NotSeeDialog = FALSE) THEN
        DialogWindow.CLOSE;

      //Si hay que calcular el anal¡tico tras el presupuesto  ----------------------------------------------------------------------------------------------------------------------------------------
      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode = '') THEN BEGIN
        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."When Calculating Budget" = QuoBuildingSetup."When Calculating Budget"::Analitical) THEN BEGIN
          JobVersion := (JobP."Card Type" = JobP."Card Type"::Estudio) AND (JobP."Original Quote Code" <> '');
          DataPieceworkForProduction.RESET;
          DataPieceworkForProduction.SETRANGE("Job No.", JobP."No.");
          IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
            IF (JobP."Card Type" = JobP."Card Type"::"Proyecto operativo") THEN BEGIN
              ConvertToBudgetxCA.PassBudget(JobBudgetP."Cod. Budget");
              ConvertToBudgetxCA.SetCalledSinceReestimation(FALSE,'');
            END;
            ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, JobVersion, JobP."No.");
          END;
          COMMIT;
        END;
      END;
    END;

    PROCEDURE CalculateUtilityRentInJobBudget(JobP : Record 167;JobBudgetP : Record 7207407);
    VAR
      LJob2 : Record 167;
      DataPieceworkForProduction2 : Record 7207386;
      ExpectedTimeUnitData2 : Record 7207388;
      LRentalPlanningInformation : Record 7207361;
      DatePrevious : Date;
      QuantityAccumuled : Decimal;
    BEGIN
      ExpectedTimeUnitData2.RESET;
      IF ExpectedTimeUnitData2.FINDLAST THEN
         LastEntryPrevious := ExpectedTimeUnitData."Entry No." + 1;

      DataPieceworkForProduction2.RESET;
      DataPieceworkForProduction2.SETCURRENTKEY("Job No.","Account Type","Rental Unit","Piecework Code");  //JAV 25/05/22: - QB 1.10.44 Mejora del rendimiento
      DataPieceworkForProduction2.SETRANGE("Job No.",JobP."No.");
      DataPieceworkForProduction2.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
      DataPieceworkForProduction2.SETRANGE("Rental Unit",TRUE);

      //JAV 20/09/20: - QB 1.06.14 Poder calcular solo una U.O.
      IF (DataPieceworkCode <> '') THEN
        DataPieceworkForProduction2.SETRANGE("Piecework Code", DataPieceworkCode);
      //JAV fin

      IF DataPieceworkForProduction2.FINDSET THEN
        REPEAT
          ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Piecework Code","Budget Code",Performed);   //JAV 25/05/22: - QB 1.10.44 Mejora del rendimiento
          ExpectedTimeUnitData.SETRANGE("Job No.",DataPieceworkForProduction2."Job No.");
          ExpectedTimeUnitData.SETRANGE("Piecework Code",DataPieceworkForProduction2."Piecework Code");
          ExpectedTimeUnitData.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
          ExpectedTimeUnitData.SETRANGE(Performed,FALSE);
          ExpectedTimeUnitData.DELETEALL;
          LRentalPlanningInformation.SETCURRENTKEY("Job No.","Piecework Code","Expected Date");
          LRentalPlanningInformation.SETRANGE("Job No.",DataPieceworkForProduction2."Job No.");
          LRentalPlanningInformation.SETRANGE("Piecework Code",DataPieceworkForProduction2."Piecework Code");
          LRentalPlanningInformation.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
          DatePrevious := 0D;
          IF LRentalPlanningInformation.FINDSET(FALSE) THEN
            REPEAT
              ExpectedTimeUnitData.INIT;
              ExpectedTimeUnitData."Entry No.":=LastEntryPrevious;
              LastEntryPrevious:=LastEntryPrevious+1;
              ExpectedTimeUnitData."Job No.":=DataPieceworkForProduction2."Job No.";
              //JMMA01

              //JMMA01 ExpectedTimeUnitData."Expected Date":=LRentalPlanningInformation."Expected Date";
              IF JobP."Starting Date"<>0D THEN
                JobP."Starting Date":=TODAY;
              IF LRentalPlanningInformation."Expected Date"=0D THEN
                LRentalPlanningInformation."Expected Date":=JobP."Starting Date";
              ExpectedTimeUnitData."Expected Date":=LRentalPlanningInformation."Expected Date";
              //JMMA01
              QuantityAccumuled := QuantityAccumuled + LRentalPlanningInformation."Number Of Items";
              ExpectedTimeUnitData."Expected Measured Amount":=QuantityAccumuled*
                                       CalculateDayUtiliceJob(LRentalPlanningInformation."Expected Date",
                                                                  DateNextEntry(LRentalPlanningInformation),
                                                                   JobP);
              ExpectedTimeUnitData."Budget Code":=LRentalPlanningInformation."Budget Code";
              ExpectedTimeUnitData.VALIDATE("Piecework Code",LRentalPlanningInformation."Piecework Code");
              IF ExpectedTimeUnitData."Expected Measured Amount"<>0 THEN
                  ExpectedTimeUnitData.INSERT;
            UNTIL LRentalPlanningInformation.NEXT=0;
        UNTIL DataPieceworkForProduction2.NEXT=0;
    END;

    PROCEDURE CalculateDayUtiliceJob(PDateSince : Date;PDateUntil : Date;PJob : Record 167) : Decimal;
    BEGIN

      IF PDateUntil > PDateSince THEN
         EXIT(PDateUntil - PDateSince)
      ELSE
         EXIT(0);
    END;

    PROCEDURE DateNextEntry(PRentalPlanningInformation : Record 7207361) : Date;
    VAR
      RentalPlanningInformation3 : Record 7207361;
      LJob3 : Record 167;
    BEGIN
      LJob3.GET(PRentalPlanningInformation."Job No.");
      RentalPlanningInformation3.SETCURRENTKEY("Job No.","Piecework Code","Expected Date");
      RentalPlanningInformation3.SETRANGE("Job No.",PRentalPlanningInformation."Job No.");
      RentalPlanningInformation3.SETRANGE("Piecework Code",PRentalPlanningInformation."Piecework Code");
      RentalPlanningInformation3.SETRANGE("Budget Code",PRentalPlanningInformation."Budget Code");
      RentalPlanningInformation3.SETFILTER("Expected Date",'>=%1',PRentalPlanningInformation."Expected Date");
      RentalPlanningInformation3.SETFILTER("Entry No.",'>%1',PRentalPlanningInformation."Entry No.");

      IF RentalPlanningInformation3.FINDFIRST THEN
         EXIT(RentalPlanningInformation3."Expected Date")
      ELSE BEGIN
         LJob3.TESTFIELD("Ending Date");
         EXIT(LJob3."Ending Date");
      END;
    END;

    PROCEDURE SetDataPiecework(pDataPieceworkCode : Code[20];pNotSeeDialog : Boolean;pMarkRecaculated : Boolean);
    BEGIN
      DataPieceworkCode := pDataPieceworkCode;
      NotSeeDialog := pNotSeeDialog;
      MarkRecalculated := pMarkRecaculated;
    END;

    PROCEDURE GroupData(JobP : Record 167;JobBudgetP : Record 7207407);
    VAR
      ExpectedTimeUnitData : Record 7207388;
      ExpectedTimeUnitData2 : Record 7207388;
      DialogWindow : Dialog;
      Text000 : TextConst ESP='Agrupando Registros\Presupuesto #1##########################\Unidad de obra #2##########################\L¡nea #3##########################';
    BEGIN
      //JAV 25/05/22: - QB 1.10.44 Este proceso agrupa los datos por fechas para reducir el tama¤o del fichero
      DialogWindow.OPEN(Text000);

      DialogWindow.UPDATE(1,FORMAT(JobP."No."+'-'+JobP.Description));
      DialogWindow.UPDATE(2,'');
      DialogWindow.UPDATE(3,'');

      ExpectedTimeUnitData.RESET;
      ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Budget Code");
      ExpectedTimeUnitData.SETRANGE("Job No.",JobBudgetP."Job No.");
      ExpectedTimeUnitData.SETRANGE("Budget Code",JobBudgetP."Cod. Budget");
      IF ExpectedTimeUnitData.FINDSET(TRUE) THEN
        REPEAT
          DialogWindow.UPDATE(2,ExpectedTimeUnitData."Piecework Code");
          DialogWindow.UPDATE(3,FORMAT(ExpectedTimeUnitData."Entry No."));

          ExpectedTimeUnitData2.RESET;
          ExpectedTimeUnitData2.SETCURRENTKEY("Job No.","Budget Code");
          ExpectedTimeUnitData2.SETRANGE("Job No.",ExpectedTimeUnitData."Job No.");
          ExpectedTimeUnitData2.SETRANGE("Budget Code",ExpectedTimeUnitData."Budget Code");
          ExpectedTimeUnitData2.SETRANGE("Piecework Code", ExpectedTimeUnitData."Piecework Code");
          ExpectedTimeUnitData2.SETRANGE("Expected Date", ExpectedTimeUnitData."Expected Date");
          ExpectedTimeUnitData2.SETFILTER("Entry No.", '<>%1', ExpectedTimeUnitData."Entry No.");
          IF (NOT ExpectedTimeUnitData2.ISEMPTY) THEN BEGIN
            ExpectedTimeUnitData2.CALCSUMS("Expected Measured Amount");
            ExpectedTimeUnitData."Expected Measured Amount" += ExpectedTimeUnitData2."Expected Measured Amount";
            ExpectedTimeUnitData.MODIFY;
            ExpectedTimeUnitData2.DELETEALL;
          END;
        UNTIL ExpectedTimeUnitData.NEXT = 0;
    END;

    /*BEGIN
/*{
      PEL 18/09/18: - QB1103 Pasar el campo Studied
      PGM 11/03/19: - QVE Se ha modificado la forma de calcular el "importe produccion ppto."
      PEL 08/04/19: - GEN003-03 Divisa adicional. Adaptaci¢n.
      JAV 30/01/20: - Marcar que el presupuesto est  calculado 21/02/20 Solo si es obra
      JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
      JAV 08/04/22: - QB 1.10.33 Mejora en la visualizaci¢n evitar que se pare mucho en un lugar fijo. Solo modificamos datos si es la misma unidad de obra, no podemos tocar otras
                                 Solo modificamos datos de la U.O. de indirectos si es la misma unidad de obra, no podemos tocar otras
      JAV 18/05/22: - QB 1.10.42 Se cambia el proceso de c lculo de los indirectos porcentuales.
                                 No calculaba los importes en las otras divisas en el ajuste final del indirecto
      JAV 24/05/22: - QB 1.10.43 A¤adimos Key apropiada para acelerar el proceso
      AML 02/06/23  - Q18527 Modificar el calculo de produccion para los presupuestos copiados. PENDIENTE REVISAR
      AML 29/08/23  - Q20047 Mejora en el calculo de las uo de mayor para indirectos.
    }
END.*/
}








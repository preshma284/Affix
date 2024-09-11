Codeunit 7207282 "Convert To Budget x CA"
{


    Permissions = TableData 480 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Calculating analytical budget', ESP = 'Calculando presupuesto anal�tico';
        Text001: TextConst ENU = 'Action cannot be executed meanwhile the field Management By Production Unit of the Job %1 isn''t active', ESP = 'No se puede realizar la acci�n dado que el campo Gesti�n por unidad de producci�n del proyecto %1 no est� activo';
        QuoBuildingSetup: Record 7207278;
        JobBudgetCode: Code[20];
        CalledSinceReestimation: Boolean;
        ReestimationPrevious: Code[20];
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        DimReest: Code[20];
        Version: Boolean;
        DimJob: Code[20];
        BudgetName: Code[20];
        nDimJob: Integer;
        nDimReest: Integer;
        GLBudgetName: Record 95;
        GLBudgetEntry: Record 96;
        DataPieceworkForProduction: Record 7207386;
        NotEntry: Integer;
        Total: Decimal;
        ForecastDataAmountPiecework: Record 7207392;
        DataCostByPiecework: Record 7207387;
        Text002: TextConst ENU = 'You can not perform the action because there are undefined analytic concepts for the piecework %1', ESP = 'No se puede realizar la acci�n debido a que existen conceptos anal�ticos sin definir para la unidad de obra %1';
        Read: Decimal;
        Window: Dialog;
        Job: Record 167;
        CurrentReestimation: Code[20];
        DefaultDimension: Record 352;
        DimensionManagement: Codeunit 408;
        DimensionSetEntry: Record 480;
        JobPostingGroup: Record 208;
        Text003: TextConst ENU = 'In order to execute this action you must configure the job accounting group in the job tab %1', ESP = 'Para poder ejecutar esta acci�n debe de configurar el grupo contable proyecto en la ficha del proyecto %1';
        Text004: TextConst ENU = 'To be able to execute this action, you must fill in the sales analytic concept field for the accounting group job %1 of job %2', ESP = 'Para poder ejecutar esta acci�n debe rellenar el campo concepto anal�tico de ventas para el grupo contable proyecto %1 del proyecto %2';
        DimensionValuePrevious: Record 349;
        NoEntry: Integer;
        GLBudgetEntryInsert: Record 96;
        Text005: TextConst ESP = 'No ha definido "%1", para el valor "%3" de la dimensi�n "%2"';
        Text006: TextConst ESP = 'No ha definido una dimensi�n %1 en el presupuesto %2';

    PROCEDURE UpdateBudgetxCA(VAR PDataJobUnitForProduction: Record 7207386; VAR BoolIsVersion: Boolean; NoJobP: Code[20]);
    VAR
        ok: Boolean;
    BEGIN
        //[controlamos inicialmente que el campo Gesti�n por producci�n sea true]
        Job.GET(NoJobP);
        IF NOT Job."Management By Production Unit" THEN
            ERROR(Text001, Job."No.");

        BoolIsVersion := (Job."Card Type" = Job."Card Type"::Estudio) AND (Job."Original Quote Code" <> '');

        Window.OPEN(Text000 + '\' + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        ok := UpdateBudgetxCAProcess(PDataJobUnitForProduction, BoolIsVersion, NoJobP);
        Window.CLOSE;
        IF NOT ok THEN
            ERROR('');
    END;

    LOCAL PROCEDURE UpdateBudgetxCAProcess(VAR PDataJobUnitForProduction: Record 7207386; VAR BoolIsVersion: Boolean; NoJobP: Code[20]): Boolean;
    VAR
        JobBudget: Record 7207407;
        RestimationInProgress: Code[20];
        UpdateViews: Codeunit 410;
    BEGIN

        IF JobBudgetCode <> '' THEN BEGIN
            JobBudget.GET(NoJobP, JobBudgetCode);
            RestimationInProgress := JobBudget."Cod. Reestimation";
        END ELSE BEGIN
            RestimationInProgress := Job."Latest Reestimation Code";
        END;
        //JMMA 05/10/20
        CurrentReestimation := RestimationInProgress;

        DimensionValuePrevious.SETRANGE("Dimension Code", FunctionQB.ReturnDimReest);
        DimensionValuePrevious.SETRANGE(Code, '', RestimationInProgress);
        IF DimensionValuePrevious.FINDLAST THEN BEGIN
            IF DimensionValuePrevious.NEXT(-1) <> 0 THEN
                ReestimationPrevious := DimensionValuePrevious.Code + '0'
            ELSE
                ReestimationPrevious := ''
        END ELSE
            ReestimationPrevious := '';


        //[para actualizar el pptoxca (Tabla MovPpto) tenemos que eliminar el existente e insertar los datos seg�n sean Costes o Ingresos]
        //[vamos a recorrer los mov.presupuesto y localizamos la dimensi�n donde se copia el proyecto para eliminar sus l�neas]
        DimReest := FunctionQB.ReturnDimReest;  //JMMA

        IF BoolIsVersion THEN BEGIN
            DimJob := FunctionQB.ReturnDimQuote;
            BudgetName := FunctionQB.ReturnBudgetQuote;
        END ELSE BEGIN
            DimJob := FunctionQB.ReturnDimJobs;
            BudgetName := FunctionQB.ReturnBudgetJobs;
        END;

        nDimJob := 0;
        nDimReest := 0;

        GLBudgetName.RESET;
        GLBudgetName.GET(BudgetName);

        GLBudgetEntry.RESET;
        GLBudgetEntry.SETCURRENTKEY("Budget Name", Type, "Budget Dimension 1 Code", "Budget Dimension 2 Code",
                                 "Budget Dimension 3 Code", "Budget Dimension 4 Code", Date);
        GLBudgetEntry.SETRANGE("Budget Name", BudgetName);

        //Busco en n�mero de la diumensi�n proyecto/estudio en el presupuesto
        IF GLBudgetName."Budget Dimension 1 Code" = DimJob THEN BEGIN
            nDimJob := 1;
            GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", PDataJobUnitForProduction."Job No.");
        END;

        IF GLBudgetName."Budget Dimension 2 Code" = DimJob THEN BEGIN
            nDimJob := 2;
            GLBudgetEntry.SETRANGE("Budget Dimension 2 Code", PDataJobUnitForProduction."Job No.");
        END;

        IF GLBudgetName."Budget Dimension 3 Code" = DimJob THEN BEGIN
            nDimJob := 3;
            GLBudgetEntry.SETRANGE("Budget Dimension 3 Code", PDataJobUnitForProduction."Job No.");
        END;

        IF GLBudgetName."Budget Dimension 4 Code" = DimJob THEN BEGIN
            nDimJob := 4;
            GLBudgetEntry.SETRANGE("Budget Dimension 4 Code", PDataJobUnitForProduction."Job No.");
        END;

        IF (nDimJob = 0) THEN
            ERROR(Text006, DimJob, BudgetName);

        //Busco en n�mero de la dimensi�n reestimaci�n en el presupuesto
        IF GLBudgetName."Budget Dimension 1 Code" = DimReest THEN BEGIN
            nDimReest := 1;
            GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", '>=%1', ReestimationPrevious);
        END;

        IF GLBudgetName."Budget Dimension 2 Code" = DimReest THEN BEGIN
            nDimReest := 2;
            GLBudgetEntry.SETFILTER("Budget Dimension 2 Code", '>=%1', ReestimationPrevious);
        END;

        IF GLBudgetName."Budget Dimension 3 Code" = DimReest THEN BEGIN
            nDimReest := 3;
            GLBudgetEntry.SETFILTER("Budget Dimension 3 Code", '>=%1', ReestimationPrevious);
        END;

        IF GLBudgetName."Budget Dimension 4 Code" = DimReest THEN BEGIN
            nDimReest := 4;
            GLBudgetEntry.SETFILTER("Budget Dimension 4 Code", '>=%1', ReestimationPrevious);
        END;

        IF (QuoBuildingSetup.Reestimates) AND (nDimJob = 0) THEN
            ERROR(Text006, DimReest, BudgetName);

        //Proceso principal
        DeleteEntryBudget;
        NotEntry := NotEntryF;
        InsertUndoReestimationPrevious;

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", PDataJobUnitForProduction."Job No.");
        Total := DataPieceworkForProduction.COUNT;
        IF DataPieceworkForProduction.FINDSET(FALSE) THEN BEGIN
            REPEAT
                IF (DataPieceworkForProduction."Type Unit Cost" = DataPieceworkForProduction."Type Unit Cost"::External) THEN
                    DataPieceworkForProduction.VALIDATE("% Expense Cost");
                ForecastDataAmountPiecework.RESET;
                ForecastDataAmountPiecework.SETCURRENTKEY("Entry Type", "Job No.", "Piecework Code", "Cod. Budget");
                ForecastDataAmountPiecework.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                ForecastDataAmountPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", JobBudgetCode);
                //JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
                ForecastDataAmountPiecework.SETFILTER("Unit Type", '%1|%2', ForecastDataAmountPiecework."Entry Type"::Expenses, ForecastDataAmountPiecework."Entry Type"::Incomes);
                IF ForecastDataAmountPiecework.FINDSET(FALSE) THEN BEGIN
                    REPEAT
                        IF ForecastDataAmountPiecework."Analytical Concept" = '' THEN BEGIN
                            MESSAGE(Text002, ForecastDataAmountPiecework."Piecework Code");
                            EXIT(FALSE);
                        END;
                        DeleteDimensions(DataPieceworkForProduction);
                        IF ForecastDataAmountPiecework."Entry Type" = ForecastDataAmountPiecework."Entry Type"::Expenses THEN
                            InsertEntryBudgetExpenses
                        ELSE
                            IF NOT InsertEntryBudgetIncome THEN
                                EXIT(FALSE);
                    UNTIL ForecastDataAmountPiecework.NEXT = 0;
                END;
                Read := Read + 1;
                Window.UPDATE(1, ROUND(Read / Total * 10000, 1));
            UNTIL DataPieceworkForProduction.NEXT = 0;
        END;

        //JMMA ACTUALIZAR VISTAS DE AN�LISIS
        //JAV 22/03/21: - QB 1.08.27 Al calcular el presupuesto ver si tambi�n las vistas de an�lisis
        //UpdateViews.UpdateAll(2,TRUE);
        COMMIT;
        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."When Calculating Analitical" = QuoBuildingSetup."When Calculating Analitical"::AnView) THEN
            UpdateViews.UpdateAll(2, TRUE)
        ELSE
            MESSAGE('Proceso finalizado, debe recalcular las vistas de an�lisis');


        //JAV 30/01/20: - Marcar que el presupuesto est� calculado solo si es una obra
        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN BEGIN
            IF (JobBudgetCode = '') THEN
                JobBudgetCode := PDataJobUnitForProduction.GETFILTER("Budget Filter");
            JobBudget.GET(NoJobP, JobBudgetCode);
            JobBudget."Pending Calculation Analitical" := FALSE;
            JobBudget.MODIFY;
        END ELSE BEGIN
            Job."Pending Calculation Analitical" := FALSE;
            Job.MODIFY;
        END;
        //JAV 30/01/20
        //jmma a�ado para reestimaciones
        IF JobBudget."Actual Budget" THEN
            IF JobBudget."Cod. Reestimation" <> '' THEN BEGIN
                Job."Latest Reestimation Code" := JobBudget."Cod. Reestimation";
                Job.MODIFY;
            END;
        IF JobBudget."Initial Budget" THEN
            IF JobBudget."Cod. Reestimation" <> '' THEN BEGIN
                Job."Initial Reestimation Code" := JobBudget."Cod. Reestimation";
                Job.MODIFY;
            END;


        EXIT(TRUE);
    END;

    PROCEDURE SetCalledSinceReestimation(PCalledSinceReestimation: Boolean; PCodeReestimationPrevious: Code[20]);
    BEGIN
        CalledSinceReestimation := PCalledSinceReestimation;
        ReestimationPrevious := PCodeReestimationPrevious;
    END;

    PROCEDURE PassBudget(BudgetCode: Code[20]);
    BEGIN
        JobBudgetCode := BudgetCode;
    END;

    PROCEDURE DeleteEntryBudget();
    BEGIN
        GLBudgetEntry.SETRANGE(Type);
        GLBudgetEntry.DELETEALL;
    END;

    PROCEDURE NotEntryF(): Integer;
    BEGIN
        GLBudgetEntryInsert.RESET;
        IF GLBudgetEntryInsert.FINDLAST THEN
            NoEntry := GLBudgetEntryInsert."Entry No."
        ELSE
            NoEntry := 0;
        EXIT(NoEntry);
    END;

    PROCEDURE InsertUndoReestimationPrevious();
    VAR
        LGLBudgetEntryInsert: Record 96;
    BEGIN
        GLBudgetEntry.SETRANGE(Type);
        IF GLBudgetName."Budget Dimension 1 Code" = DimReest THEN BEGIN
            GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", DimensionValuePrevious.Code);
        END;

        IF GLBudgetName."Budget Dimension 2 Code" = DimReest THEN BEGIN
            GLBudgetEntry.SETRANGE("Budget Dimension 2 Code", DimensionValuePrevious.Code);
        END;

        IF GLBudgetName."Budget Dimension 3 Code" = DimReest THEN BEGIN
            GLBudgetEntry.SETRANGE("Budget Dimension 3 Code", DimensionValuePrevious.Code);
        END;

        IF GLBudgetName."Budget Dimension 4 Code" = DimReest THEN BEGIN
            GLBudgetEntry.SETRANGE("Budget Dimension 4 Code", DimensionValuePrevious.Code);
        END;

        IF GLBudgetEntry.FINDSET THEN
            REPEAT
                LGLBudgetEntryInsert := GLBudgetEntry;
                NotEntry := NotEntry + 1;
                LGLBudgetEntryInsert."Entry No." := NotEntry;

                CASE nDimReest OF
                    1:
                        LGLBudgetEntryInsert."Budget Dimension 1 Code" := ReestimationPrevious;
                    2:
                        LGLBudgetEntryInsert."Budget Dimension 2 Code" := ReestimationPrevious;
                    3:
                        LGLBudgetEntryInsert."Budget Dimension 3 Code" := ReestimationPrevious;
                    4:
                        LGLBudgetEntryInsert."Budget Dimension 4 Code" := ReestimationPrevious;
                END;
                LGLBudgetEntryInsert.INSERT;
            UNTIL GLBudgetEntry.NEXT = 0;

        GLBudgetEntry.SETRANGE(Type);
    END;

    PROCEDURE InsertEntryBudgetExpenses();
    BEGIN
        // Con esta funci�n insertamos en la tabla de mov.ppto el nuevo presupuesto seg�n los datos de la planificaci�n por unidad de obra

        NotEntry := NotEntry + 1;
        CLEAR(GLBudgetEntryInsert);

        GLBudgetEntryInsert."Entry No." := NotEntry;

        // el n�mero de la cuenta va a depender del valor del campo tipo de la tabla Valor Dimension (T349) seg�n el CA seleccionado
        DimensionValue.GET(FunctionQB.ReturnDimCA, ForecastDataAmountPiecework."Analytical Concept");
        IF DimensionValue.Type = DimensionValue.Type::Expenses THEN BEGIN
            IF (DimensionValue."Account Budget E Reestimations" = '') THEN
                ERROR(Text005, DimensionValue.FIELDCAPTION("Account Budget E Reestimations"), DimensionValue."Dimension Code", DimensionValue.Code);
            GLBudgetEntryInsert."G/L Account No." := DimensionValue."Account Budget E Reestimations";
            GLBudgetEntryInsert.Type := GLBudgetEntryInsert.Type::Expenses;
        END
        //-Q20266
        ELSE
            ERROR('Unidad de obra %1, tiene CA incorrecto en algun descompuesto', ForecastDataAmountPiecework."Piecework Code");

        GLBudgetEntryInsert."Budget Name" := BudgetName;
        IF ForecastDataAmountPiecework."Expected Date" <> 0D THEN
            GLBudgetEntryInsert.Date := ForecastDataAmountPiecework."Expected Date"
        ELSE
            GLBudgetEntryInsert.Date := TODAY;
        GLBudgetEntryInsert.VALIDATE(Amount, ForecastDataAmountPiecework."Amount (LCY)");  //Divisas RSH 09/07/2019

        //vamos a localizar el valor de la dimensi�n para introducir el concepto anal�tico
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            GLBudgetEntryInsert."Global Dimension 1 Code" := ForecastDataAmountPiecework."Analytical Concept";
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
            GLBudgetEntryInsert."Global Dimension 2 Code" := ForecastDataAmountPiecework."Analytical Concept";

        //vamos a localizar el valor de la dimensi�n para introducir el c�d.dpto del proyecto
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
            GLBudgetEntryInsert."Global Dimension 1 Code" := Job."Global Dimension 1 Code";
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
            GLBudgetEntryInsert."Global Dimension 2 Code" := Job."Global Dimension 2 Code";

        CASE nDimJob OF
            1:
                GLBudgetEntryInsert."Budget Dimension 1 Code" := DataPieceworkForProduction."Job No.";
            2:
                GLBudgetEntryInsert."Budget Dimension 2 Code" := DataPieceworkForProduction."Job No.";
            3:
                GLBudgetEntryInsert."Budget Dimension 3 Code" := DataPieceworkForProduction."Job No.";
            4:
                GLBudgetEntryInsert."Budget Dimension 4 Code" := DataPieceworkForProduction."Job No.";
        END;

        CASE nDimReest OF
            1:
                GLBudgetEntryInsert."Budget Dimension 1 Code" := CurrentReestimation;
            2:
                GLBudgetEntryInsert."Budget Dimension 2 Code" := CurrentReestimation;
            3:
                GLBudgetEntryInsert."Budget Dimension 3 Code" := CurrentReestimation;
            4:
                GLBudgetEntryInsert."Budget Dimension 4 Code" := CurrentReestimation;
        END;

        GLBudgetEntryInsert.Description := ForecastDataAmountPiecework.Description;

        IF GLBudgetEntryInsert.Amount <> 0 THEN
            GLBudgetEntryInsert.INSERT(TRUE);

        //ahora heredamos las demas dimensiones si las hubiese.
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
        DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
        IF DefaultDimension.FINDSET THEN BEGIN
            REPEAT
                DimensionManagement.GetDimensionSet(DimensionSetEntry, GLBudgetEntryInsert."Dimension Set ID");
                GLBudgetEntryInsert.UpdateDimSet(DimensionSetEntry, DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code");
                GLBudgetEntryInsert."Dimension Set ID" := DimensionManagement.GetDimensionSetID(DimensionSetEntry);
            UNTIL DefaultDimension.NEXT = 0;
        END;
    END;

    PROCEDURE InsertEntryBudgetIncome(): Boolean;
    VAR
        Txt001: TextConst ESP = 'No hay cuenta de venta asociada al valor de la dimensi�n %1, registro %2 %3';
        Txt002: TextConst ESP = 'Dimensi�n "%1", valor "%2": O no est� defindio de tipo INGRESO o no ha defindo el campo "%3"';
    BEGIN
        // Con esta funci�n insertamos en la tabla de mov.ppto el nuevo presupuesto seg�n los datos de la planificaci�n por unidad de obra]
        NotEntry := NotEntry + 1;
        CLEAR(GLBudgetEntryInsert);
        GLBudgetEntryInsert."Entry No." := NotEntry;

        // El n�mero de la cuenta va a depender del valor del campo tipo de la tabla Valor Dimension (T349) seg�n el CA seleccionado
        IF NOT JobPostingGroup.GET(Job."Job Posting Group") THEN BEGIN
            MESSAGE(Text003, Job."No.");
            EXIT(FALSE);
        END;
        IF JobPostingGroup."Sales Analytic Concept" = '' THEN BEGIN
            MESSAGE(Text004, JobPostingGroup.Code, Job."No.");
            EXIT(FALSE);
        END;

        DimensionValue.GET(FunctionQB.ReturnDimCA, JobPostingGroup."Sales Analytic Concept");
        IF DimensionValue.Type = DimensionValue.Type::Income THEN BEGIN
            //JAV muestra error si no hay cuenta asociada
            IF (DimensionValue."Account Budget E Reestimations" = '') THEN BEGIN
                MESSAGE(Txt001, DimensionValue."Dimension Code", DimensionValue.Code, DimensionValue.Name);
                EXIT(FALSE);
            END;
            GLBudgetEntryInsert."G/L Account No." := DimensionValue."Account Budget E Reestimations";
            GLBudgetEntryInsert.Type := GLBudgetEntryInsert.Type::Revenues;
        END;

        IF (GLBudgetEntryInsert."G/L Account No." = '') THEN BEGIN
            MESSAGE(Txt002, DimensionValue."Dimension Code", DimensionValue.Code, DimensionValue.FIELDCAPTION("Account Budget E Reestimations"));
            EXIT(FALSE);
        END;

        GLBudgetEntryInsert."Budget Name" := BudgetName;
        IF ForecastDataAmountPiecework."Expected Date" <> 0D THEN
            GLBudgetEntryInsert.Date := ForecastDataAmountPiecework."Expected Date"
        ELSE
            GLBudgetEntryInsert.Date := TODAY;
        GLBudgetEntryInsert.VALIDATE(Amount, -ForecastDataAmountPiecework."Amount (LCY)");    //Divisas RSH 09/07/2019

        // Vamos a localizar el valor de la dimensi�n para introducir el concepto anal�tico
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            GLBudgetEntryInsert."Global Dimension 1 Code" := JobPostingGroup."Sales Analytic Concept";
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
            GLBudgetEntryInsert."Global Dimension 2 Code" := JobPostingGroup."Sales Analytic Concept";

        //Vamos a localizar el valor de la dimensi�n para introducir el c�d.dpto del proyecto
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
            GLBudgetEntryInsert."Global Dimension 1 Code" := Job."Global Dimension 1 Code";
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
            GLBudgetEntryInsert."Global Dimension 2 Code" := Job."Global Dimension 2 Code";

        CASE nDimJob OF
            1:
                GLBudgetEntryInsert."Budget Dimension 1 Code" := DataPieceworkForProduction."Job No.";
            2:
                GLBudgetEntryInsert."Budget Dimension 2 Code" := DataPieceworkForProduction."Job No.";
            3:
                GLBudgetEntryInsert."Budget Dimension 3 Code" := DataPieceworkForProduction."Job No.";
            4:
                GLBudgetEntryInsert."Budget Dimension 4 Code" := DataPieceworkForProduction."Job No.";
        END;

        CASE nDimReest OF
            1:
                GLBudgetEntryInsert."Budget Dimension 1 Code" := CurrentReestimation;
            2:
                GLBudgetEntryInsert."Budget Dimension 2 Code" := CurrentReestimation;
            3:
                GLBudgetEntryInsert."Budget Dimension 3 Code" := CurrentReestimation;
            4:
                GLBudgetEntryInsert."Budget Dimension 4 Code" := CurrentReestimation;
        END;

        GLBudgetEntryInsert.Description := ForecastDataAmountPiecework.Description;

        IF GLBudgetEntryInsert.Amount <> 0 THEN
            GLBudgetEntryInsert.INSERT(TRUE);

        // Ahora heredamos las demas dimensiones si las hubiese.
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
        DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Unique Code");
        IF DefaultDimension.FINDSET THEN BEGIN
            REPEAT
                DimensionManagement.GetDimensionSet(DimensionSetEntry, GLBudgetEntryInsert."Dimension Set ID");
                GLBudgetEntryInsert.UpdateDimSet(DimensionSetEntry, DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code");
                GLBudgetEntryInsert."Dimension Set ID" := DimensionManagement.GetDimensionSetID(DimensionSetEntry);
            UNTIL DefaultDimension.NEXT = 0;
        END;

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE DeleteDimensions(DataPieceworkForProductionAux: Record 7207386);
    VAR
        DefaultDimension: Record 352;
    BEGIN
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
        DefaultDimension.SETRANGE("No.", DataPieceworkForProductionAux."Unique Code");
        IF DefaultDimension.FINDSET THEN
            DefaultDimension.DELETEALL(TRUE);
    END;

    /*BEGIN
/*{
      IF NOT Job."Management By Production Unit" THEN Calcular el presupuesto anal�tico del proyecto
      RSH 09/07/19: - Divisas
      JAV 02/05/20: - Se ajusta para que no de un error y deje la pantalla de progreso abierta, se lanzan mensajes y al final el error para que deshaga todo
      JAV 22/03/21: - QB 1.08.27 Al calcular el presupuesto ver si tambi�n las vistas de an�lisis
      JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
      AML 09/10/23: - Correccion de informaci�n de error.
    }
END.*/
}








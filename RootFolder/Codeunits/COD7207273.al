Codeunit 7207273 "Codeunit Modific. Management"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        recSourceCodeSetup: Record 242;
        FunctionQB: Codeunit 7207272;
        DimMgt: Codeunit 408;
        codeJob: Code[20];
        Text002: TextConst ENU = 'You must specified default analitical concept in Account %1', ESP = 'Debe especificar el Concepto anal�tico por defecto en cuenta %1.';
        Text000: TextConst ESP = 'Debe especificar en la cuenta %1 un valor de dimensi�n Proyecto por defecto para registro.';
        Text004: TextConst ENU = 'You must especified a Job in Account %1', ESP = 'Debe especificar proyecto en cuenta %1';
        Text010: TextConst ENU = 'Do you want to assign project planning to milestones?', ESP = '�Quiere asignar la planificaci�n del proyecto en funci�n de los hitos?';
        Text011: TextConst ENU = 'A new planning has been assigned', ESP = 'Se ha asignado la nueva planificaci�n';
        intNumLine: Integer;
        QueueTmpJobJnlLine: Record 210 TEMPORARY;
        JobJnlPostLine: Codeunit 1012;
        Text006: TextConst ENU = 'Define Existing Accounting Group Settings for location %1 and Stock Accounting Group %2', ESP = 'Defina configuraci�n grupos contables de existencia para almac�n %1 y grupo contable de existencias %2';

    PROCEDURE InheritFieldJob(JobJnlLine: Record 210; VAR JobLedgEntry: Record 169);
    VAR
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        JobTask: Record 1001;
        Text001: TextConst ENU = '%1: %2 is marked as %3 and has more than one task assigned.', ESP = 'El %1: %2, est� marcado como %3 y tiene m�s de una tarea asignada.';
        Text002: TextConst ENU = '%1: %2 is marked as %3 and has no assigned tasks.', ESP = 'El %1: %2, est� marcado como %3 y no tiene tareas asignadas.';
        JobCurExchange: Codeunit 7207332;
        CurFactor: Decimal;
        AmountCurTrans: Decimal;
        GLSetup: Record 98;
    BEGIN
        JobLedgEntry."Job Deviation Mov." := JobJnlLine."Job Deviation Entry";
        JobLedgEntry."Compute for hours" := JobJnlLine."Compute for hours";
        JobLedgEntry."Piecework No." := JobJnlLine."Piecework Code";
        JobLedgEntry."Job in progress" := JobJnlLine."Job in Progress";
        JobLedgEntry."Expense Notes Code" := JobJnlLine."Expense Notes Code";
        JobLedgEntry."Related Item Entry No." := JobJnlLine."Related Item Entry No.";
        //JAV 12/04/22: - QB 1.10.35 Se elimina el campo JobLedgEntry.Activate porque no se usa para nada
        //IF DataPieceworkForProduction.GET(JobLedgEntry."Job No.",JobLedgEntry."Piecework No.") THEN
        //  JobLedgEntry.Activate := DataPieceworkForProduction.Activable;
        JobLedgEntry."Plant Depreciation Sheet" := JobJnlLine."Plant Depreciation Sheet";
        JobLedgEntry."Movement of Closing of Job" := JobJnlLine."Job Closure Entry";
        JobLedgEntry."Job Sale Doc. Type" := JobJnlLine."Job Sale Doc. Type";

        //JMMA 280920 LLevar a job ledger entry la divisa original de la transacci�n, el importe original y el importe a cambio fijo.
        JobLedgEntry."Transaction Currency" := JobJnlLine."Transaction Currency";
        AmountCurTrans := 0;
        CurFactor := 0;
        JobCurExchange.CalculateCurrencyValue(JobJnlLine."Job No.", JobJnlLine."Total Cost (TC)", JobJnlLine."Transaction Currency", JobJnlLine."Currency Code", 0D, 0, AmountCurTrans, CurFactor);
        JobLedgEntry."Total Cost (TC)" := JobJnlLine."Total Cost (TC)";//JMMA: guardamos el importe de coste en la divisa original.
        JobLedgEntry."Total Cost (FC)" := AmountCurTrans;//JMMA: guardamos el importe en divisa del proyecto a tipo de cambio fijo (no el de la transacci�n)

        //DIVISA ADICIONAL/REPORTING
        Job.GET(JobJnlLine."Job No.");
        GLSetup.GET;

        IF Job."Aditional Currency" <> GLSetup."Additional Reporting Currency" THEN BEGIN
            JobCurExchange.CalculateCurrencyValue(JobJnlLine."Job No.", JobJnlLine."Total Cost (TC)", JobJnlLine."Transaction Currency", Job."Aditional Currency",
                                                  JobJnlLine."Posting Date", 2, AmountCurTrans, CurFactor);  //Se debe calcular siempre al cambio del d�a ya que es una operaci�n ejecutada
            JobLedgEntry."Total Cost (ACY)" := AmountCurTrans;
            JobLedgEntry."Exchange Rate (ACY)" := CurFactor;      //JAV 20/11/20: - QB 1.07.06 Guardarse el factor de cambio de la divisa adicional
        END ELSE BEGIN
            JobLedgEntry."Total Cost (ACY)" := JobJnlLine."Source Currency Total Cost";
        END;


        //++JMMA 280920

        //GAP888
        JobLedgEntry."Source Document Type" := JobJnlLine."Source Document Type";
        JobLedgEntry."Source Type" := JobJnlLine."Source Type";
        JobLedgEntry."Source No." := JobJnlLine."Source No.";
        JobLedgEntry.Provision := JobJnlLine.Provision;
        JobLedgEntry.Unprovision := JobJnlLine.Unprovision;
        JobLedgEntry."Source Name" := JobJnlLine."Source Name";

        IF JobLedgEntry."Job Task No." = '' THEN BEGIN
            Job.GET(JobLedgEntry."Job No.");
            IF Job."Management by tasks" THEN BEGIN
                JobTask.RESET;
                JobTask.SETRANGE("Job No.", JobLedgEntry."Job No.");
                IF JobTask.COUNT > 1 THEN
                    ERROR(Text001, Job.TABLECAPTION, Job."No.", Job.FIELDCAPTION("Management by tasks"));
                IF NOT JobTask.FINDFIRST THEN
                    ERROR(Text002, Job.TABLECAPTION, Job."No.", Job.FIELDCAPTION("Management by tasks"));
                JobLedgEntry."Job Task No." := JobTask."Job Task No.";
            END;
        END;

        //JAV 03/12/20: - Campos adicionales para divisas y WIP
        JobLedgEntry."Currency Adjust" := JobJnlLine."Currency Adjust";
        JobLedgEntry."Related G/L Entry" := JobJnlLine."Related G/L Entry";


        //Crear movimiento detallado de proyecto
        IF (JobJnlLine."Cancel WIP") THEN                 //JAV 12/12/20: - QB 1.07.11 Si es una l�nea de cancelaci�n
            CreateDetailedJobLedgerEntry(JobLedgEntry, 2)
        ELSE IF (JobJnlLine."Currency Adjust") THEN       //JAV 27/11/20: - QB 1.07.08 Si es una l�nea de ajust de tipo de cambio, crear el movimiento detallado de proyecto
            CreateDetailedJobLedgerEntry(JobLedgEntry, 1)
        ELSE IF (JobLedgEntry."Job in progress") THEN     //JAV 27/11/20: - QB 1.07.08 Si es una l�nea de obra en curso, crear el movimiento detallado de proyecto si es necesario
            CreateDetailedJobLedgerEntry(JobLedgEntry, 0);
    END;

    LOCAL PROCEDURE CreateDetailedJobLedgerEntry(JobLedgEntry: Record 169; pType: Option "Initial","Currency","CancelWIP");
    VAR
        Job: Record 167;
        AuxJobLedgerEntry: Record 169;
        QBDetailedJobLedgerEntry: Record 7207328;
        nro: Integer;
    BEGIN
        //JAV 03/12/20: - QB 1.07.10 Crear el movimiento detallado de Proyecto, pero solo si hay WIP por periodos
        Job.GET(JobLedgEntry."Job No.");
        IF (NOT Job."Calculate WIP by periods") THEN
            EXIT;

        QBDetailedJobLedgerEntry.RESET;
        IF (QBDetailedJobLedgerEntry.FINDLAST) THEN
            nro := QBDetailedJobLedgerEntry."Entry No." + 1
        ELSE
            nro := 1;

        QBDetailedJobLedgerEntry.INIT;
        QBDetailedJobLedgerEntry."Entry No." := nro;
        QBDetailedJobLedgerEntry."Job Ledger Entry No." := JobLedgEntry."Entry No.";
        QBDetailedJobLedgerEntry."Applied Job Ledger Entry No." := 0;
        CASE pType OF
            pType::Initial:
                BEGIN
                    QBDetailedJobLedgerEntry."Entry Type" := QBDetailedJobLedgerEntry."Entry Type"::"Initial Entry";
                    QBDetailedJobLedgerEntry.Amount := JobLedgEntry."Line Amount";
                    QBDetailedJobLedgerEntry."Amount (LCY)" := JobLedgEntry."Line Amount (LCY)";
                END;

            pType::Currency:
                BEGIN
                    IF (JobLedgEntry."Line Amount" < 0) THEN
                        QBDetailedJobLedgerEntry."Entry Type" := QBDetailedJobLedgerEntry."Entry Type"::"Realized Loss"
                    ELSE
                        QBDetailedJobLedgerEntry."Entry Type" := QBDetailedJobLedgerEntry."Entry Type"::"Realized Gain";

                    QBDetailedJobLedgerEntry.Amount := JobLedgEntry."Total Cost";
                    QBDetailedJobLedgerEntry."Amount (LCY)" := JobLedgEntry."Total Cost (LCY)";

                    //Buscar sobre que movimiento se aplica
                    AuxJobLedgerEntry.RESET;
                    AuxJobLedgerEntry.SETRANGE("Related G/L Entry", JobLedgEntry."Related G/L Entry");
                    IF (AuxJobLedgerEntry.FINDFIRST) THEN
                        QBDetailedJobLedgerEntry."Applied Job Ledger Entry No." := AuxJobLedgerEntry."Entry No.";
                END;

            pType::CancelWIP:
                BEGIN
                    QBDetailedJobLedgerEntry."Entry Type" := QBDetailedJobLedgerEntry."Entry Type"::"Initial Entry";
                    QBDetailedJobLedgerEntry.Amount := JobLedgEntry."Line Amount" - JobLedgEntry."Total Cost";
                    QBDetailedJobLedgerEntry."Amount (LCY)" := JobLedgEntry."Line Amount (LCY)" - JobLedgEntry."Total Cost (LCY)";
                END;


        END;
        QBDetailedJobLedgerEntry."Posting Date" := JobLedgEntry."Posting Date";
        QBDetailedJobLedgerEntry."Document No." := JobLedgEntry."Document No.";
        QBDetailedJobLedgerEntry."Job No." := JobLedgEntry."Job No.";
        QBDetailedJobLedgerEntry."Currency Code" := JobLedgEntry."Currency Code";
        QBDetailedJobLedgerEntry."User ID" := USERID;
        QBDetailedJobLedgerEntry."Source Code" := JobLedgEntry."Source Code";
        QBDetailedJobLedgerEntry."Reason Code" := JobLedgEntry."Reason Code";
        QBDetailedJobLedgerEntry.INSERT;
    END;

    PROCEDURE "PlannedJobMilestoneS/N"(PJob: Record 167);
    VAR
        Text010: TextConst ENU = 'Do you want to assign job planning to milestones?', ESP = '�Quiere asignar la planificaci�n del proyecto en funci�n de los hitos?';
        Text011: TextConst ENU = 'New schedule assigned', ESP = 'Se ha asignado la nueva planificaci�n';
    BEGIN
        IF NOT CONFIRM(Text010) THEN
            EXIT;

        PlanedJobMilestone(PJob);

        MESSAGE(Text011);
    END;

    PROCEDURE PlanedJobMilestone(PJob: Record 167);
    VAR
        DimensionValue: Record 349;
        Dimension: Record 348;
        GLBudgetName: Record 95;
        DimJob: Code[10];
        AmountCA: Decimal;
        FunctionQB: Codeunit 7207272;
    BEGIN
        Dimension.Code := FunctionQB.ReturnDimCA;
        DimensionValue.SETRANGE("Dimension Code", Dimension.Code);

        IF PJob.Status = PJob.Status::Planning THEN BEGIN
            DimJob := FunctionQB.ReturnDimQuote;
            GLBudgetName.Name := FunctionQB.ReturnBudgetQuote;
        END
        ELSE BEGIN
            DimJob := FunctionQB.ReturnDimJobs;
            GLBudgetName.Name := FunctionQB.ReturnBudgetJobs;
        END;

        GLBudgetName.GET(GLBudgetName.Name);

        IF DimensionValue.FINDSET(TRUE) THEN
            REPEAT
                AmountCA := DeletePlanPrevious(PJob, DimensionValue.Code, GLBudgetName, DimJob);

                PlanningConcept(PJob, DimensionValue.Code, AmountCA, GLBudgetName.Name, DimJob);
            UNTIL DimensionValue.NEXT = 0;
    END;

    PROCEDURE DeletePlanPrevious(PJob: Record 167; PCA: Code[20]; PGLBudgetName: Record 95; PDimBudget: Code[10]): Decimal;
    VAR
        GLBudgetEntry: Record 96;
        VAmountCA: Decimal;
        FunctionQB: Codeunit 7207272;
    BEGIN

        VAmountCA := 0;
        GLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", "Business Unit Code",
                                 "Global Dimension 1 Code", "Global Dimension 2 Code", "Budget Dimension 1 Code");
        GLBudgetEntry.SETRANGE("Budget Name", PGLBudgetName.Name);

        // Filtramos el CA
        // Vamos a localizar el valor de la dimensi�n para introducir el concepto anal�tico
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            GLBudgetEntry.SETRANGE("Global Dimension 1 Code", PCA);
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
            GLBudgetEntry.SETRANGE("Global Dimension 2 Code", PCA);

        // buscamos el la dimension proyecto
        IF PGLBudgetName."Budget Dimension 1 Code" = PDimBudget THEN
            GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", PJob."No.");

        IF PGLBudgetName."Budget Dimension 2 Code" = PDimBudget THEN
            GLBudgetEntry.SETRANGE("Budget Dimension 2 Code", PJob."No.");

        IF PGLBudgetName."Budget Dimension 3 Code" = PDimBudget THEN
            GLBudgetEntry.SETRANGE("Budget Dimension 3 Code", PJob."No.");

        IF PGLBudgetName."Budget Dimension 3 Code" = PDimBudget THEN
            GLBudgetEntry.SETRANGE("Budget Dimension 4 Code", PJob."No.");


        GLBudgetEntry.CALCSUMS(Amount);
        VAmountCA := GLBudgetEntry.Amount;

        // Una vez calculado borramos

        GLBudgetEntry.DELETEALL;

        EXIT(VAmountCA);
    END;

    PROCEDURE PlanningConcept(PJob: Record 167; PConcept: Code[20]; PAmountConcept: Decimal; PBudget: Code[10]; PDimJob: Code[10]);
    VAR
        MilestoneCostsPlanning: Record 7207376;
        AmountExpense: Decimal;
        DateExpense: Date;
        GLBudgetEntry: Record 96;
        NumberEntry: Integer;
    BEGIN
        GLBudgetEntry.RESET;
        IF GLBudgetEntry.FINDLAST THEN
            NumberEntry := GLBudgetEntry."Entry No."
        ELSE
            NumberEntry := 0;


        MilestoneCostsPlanning.SETRANGE("Job No.", PJob."No.");
        MilestoneCostsPlanning.SETRANGE("Concept Code", PConcept);
        IF MilestoneCostsPlanning.FINDSET THEN
            REPEAT
                AmountExpense := (PAmountConcept * MilestoneCostsPlanning.Percentage) / 100;
                DateExpense := MilestoneCostsPlanning.ShowDateMilestone;
                InsertAmount(PJob, PConcept, AmountExpense, DateExpense, PBudget, PDimJob);
            UNTIL MilestoneCostsPlanning.NEXT = 0
        ELSE BEGIN
            InsertAmount(PJob, PConcept, AmountExpense, PJob."Starting Date", PBudget, PDimJob);
        END;
    END;

    PROCEDURE InsertAmount(PJob: Record 167; PCA: Code[10]; PAmount: Decimal; PDate: Date; PBudget: Code[10]; PDimJob: Code[10]);
    VAR
        GLBudgetEntry: Record 96;
        DimensionValue: Record 349;
        VDimJob: Code[10];
        GLBudgetName: Record 95;
        NumberEntry: Integer;
        FunctionQB: Codeunit 7207272;
    BEGIN
        // [con esta funci�n insertamos en la tabla de mov.ppto
        IF NumberEntry = 0 THEN BEGIN
            GLBudgetEntry.FINDLAST;
            NumberEntry := GLBudgetEntry."Entry No.";
        END;

        NumberEntry := NumberEntry + 1;
        CLEAR(GLBudgetEntry);

        //el n�mero de la cuenta va a depender del valor del campo tipo de la tabla Valor Dimension (T349) seg�n el CA seleccionado
        DimensionValue.GET(FunctionQB.ReturnDimCA, PCA);
        IF DimensionValue.Type = DimensionValue.Type::Expenses THEN BEGIN
            GLBudgetEntry."G/L Account No." := DimensionValue."Account Budget E Reestimations";
            GLBudgetEntry.Type := GLBudgetEntry.Type::Expenses;
        END;

        GLBudgetEntry."Budget Name" := PBudget;
        GLBudgetEntry.Date := PDate;
        GLBudgetEntry.VALIDATE(Amount, PAmount);

        //vamos a localizar el valor de la dimensi�n para introducir el concepto anal�tico
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
            GLBudgetEntry."Global Dimension 1 Code" := PCA;
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
            GLBudgetEntry."Global Dimension 2 Code" := PCA;

        //vamos a localizar el valor de la dimensi�n para introducir el c�d.dpto del proyecto
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN
            GLBudgetEntry."Global Dimension 1 Code" := PJob."Global Dimension 1 Code";
        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 THEN
            GLBudgetEntry."Global Dimension 2 Code" := PJob."Global Dimension 2 Code";

        VDimJob := PDimJob;
        GLBudgetName.GET(PBudget);
        IF GLBudgetName."Budget Dimension 1 Code" = VDimJob THEN BEGIN
            GLBudgetEntry."Budget Dimension 1 Code" := PJob."No.";
        END;
        IF GLBudgetName."Budget Dimension 2 Code" = VDimJob THEN BEGIN
            GLBudgetEntry."Budget Dimension 2 Code" := PJob."No.";
        END;
        IF GLBudgetName."Budget Dimension 3 Code" = VDimJob THEN BEGIN
            GLBudgetEntry."Budget Dimension 3 Code" := PJob."No.";
        END;
        IF GLBudgetName."Budget Dimension 4 Code" = VDimJob THEN BEGIN
            GLBudgetEntry."Budget Dimension 4 Code" := PJob."No.";
        END;


        IF GLBudgetEntry.Amount <> 0 THEN BEGIN
            GLBudgetEntry.INSERT(TRUE);
        END;
    END;

    PROCEDURE UpdateLinePurchase(VAR GenJnlLine: Record 81; InvoicePostBuffer: Record 49);
    VAR
        Location: Record 14;
        DimValue: Record 349;
        DefaultDim: Record 352;
        codeCA: Code[20];
        InventoryPostSetup: Record 5813;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        CASE InvoicePostBuffer.Type OF
            InvoicePostBuffer.Type::"G/L Account":
                GenJnlLine."Already Generated Job Entry" := TRUE;
            InvoicePostBuffer.Type::Item:
                BEGIN
                    IF GenJnlLine."Job No." = '' THEN BEGIN
                        IF InvoicePostBuffer."Location Code" <> '' THEN BEGIN
                            Location.GET(InvoicePostBuffer."Location Code");
                            Location.TESTFIELD("QB Departament Code");
                            DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code");
                            QuoBuildingSetup.GET;
                            IF NOT QuoBuildingSetup."Skip Required Project" THEN BEGIN
                                DimValue.TESTFIELD("Job Structure Warehouse");
                                GenJnlLine."Job No." := DimValue."Job Structure Warehouse";
                                GenJnlLine."Already Generated Job Entry" := TRUE;
                                GenerateMovementJobLocation(GenJnlLine, InvoicePostBuffer)
                            END;
                            GenJnlLine."Job No." := DimValue."Job Structure Warehouse";
                            GenJnlLine."Already Generated Job Entry" := TRUE;
                        END;
                    END ELSE
                        GenJnlLine."Already Generated Job Entry" := TRUE;
                END;
            InvoicePostBuffer.Type::Resource:
                BEGIN
                    IF GenJnlLine."Job No." = '' THEN BEGIN
                        IF InvoicePostBuffer."Location Code" <> '' THEN BEGIN
                            Location.GET(InvoicePostBuffer."Location Code");
                            Location.TESTFIELD("QB Departament Code");
                            DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code");
                            DimValue.TESTFIELD("Job Structure Warehouse");
                            GenJnlLine."Job No." := DimValue."Job Structure Warehouse";
                            GenJnlLine."Already Generated Job Entry" := TRUE;
                            GenerateMovementJobLocation(GenJnlLine, InvoicePostBuffer)
                        END;
                    END ELSE
                        GenJnlLine."Already Generated Job Entry" := TRUE;
                END;
            InvoicePostBuffer.Type::"Fixed Asset":
                GenJnlLine."Already Generated Job Entry" := FALSE;
            ELSE
                GenJnlLine."Already Generated Job Entry" := TRUE;
        END;
    END;

    PROCEDURE GenerateMovementJobLocation(VAR GenJnlLine: Record 81; InvoicePostBuffer: Record 49);
    VAR
        JobJournalLine: Record 210;
        Amount: Decimal;
        JobJnlPostLine: Codeunit 1012;
        Job: Record 167;
    BEGIN
        JobJournalLine.INIT;
        JobJournalLine."Entry Type" := Enum::"Job Journal Line Entry Type".FromInteger(GenJnlLine."Usage/Sale"); //option to enum
        JobJournalLine."Job No." := GenJnlLine."Job No.";
        JobJournalLine."Posting Date" := GenJnlLine."Posting Date";
        JobJournalLine."Document No." := GenJnlLine."Document No.";
        JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
        JobJournalLine."No." := InvoicePostBuffer."G/L Account";
        JobJournalLine.Description := GenJnlLine.Description;
        IF ((InvoicePostBuffer.Amount > 0) AND (GenJnlLine."Usage/Sale" = GenJnlLine."Usage/Sale"::Usage)) OR
           ((InvoicePostBuffer.Amount < 0) AND (GenJnlLine."Usage/Sale" = GenJnlLine."Usage/Sale"::Sale)) THEN
            JobJournalLine.Quantity := 1
        ELSE
            JobJournalLine.Quantity := -1;

        Amount := InvoicePostBuffer.Amount;

        IF GenJnlLine."Usage/Sale" = GenJnlLine."Usage/Sale"::Usage THEN BEGIN
            JobJournalLine."Unit Cost (LCY)" := Amount;
            JobJournalLine."Total Cost (LCY)" := Amount;
        END ELSE BEGIN
            JobJournalLine."Unit Price (LCY)" := -Amount;
            JobJournalLine."Total Price (LCY)" := -Amount;
        END;
        JobJournalLine.VALIDATE("Unit Cost", JobJournalLine."Unit Cost");
        JobJournalLine.VALIDATE("Total Cost", JobJournalLine."Total Cost");
        JobJournalLine.VALIDATE("Unit Price", JobJournalLine."Unit Price");
        JobJournalLine.VALIDATE("Total Price", JobJournalLine."Total Price");
        JobJournalLine."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        JobJournalLine.Chargeable := TRUE;
        JobJournalLine."Posting Group" := GenJnlLine."Posting Group";
        JobJournalLine."Source Code" := GenJnlLine."Source Code";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
        JobJournalLine."Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
        JobJournalLine."Document Date" := GenJnlLine."Document Date";
        JobJournalLine."External Document No." := GenJnlLine."External Document No.";
        JobJournalLine."Source Currency Total Cost" := GenJnlLine."Source Currency Amount";
        JobJournalLine."Expense Notes Code" := GenJnlLine."Expense Note Code";
        JobJournalLine."Job Posting Only" := TRUE;
        Job.GET(GenJnlLine."Job No.");
        JobJournalLine."Piecework Code" := Job."Warehouse Cost Unit";
        GenJnlLine."Piecework Code" := Job."Warehouse Cost Unit";
        IF GenJnlLine."Job Task No." <> '' THEN
            JobJournalLine."Job Task No." := GenJnlLine."Job Task No."
        ELSE
            IF Job."Management by tasks" THEN
                JobJournalLine."Job Task No." := Job."Location Task No.";
        JobJournalLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";


        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE AdditionalControls(recLinJnlGen: Record 81);
    VAR
        recGLAccount: Record 15;
        Text003: TextConst ENU = '"you cannot specify an Income Statment Account as Bal. Account in a Posting Journal\Book: %1, Section: %2, Line: %3 "', ESP = 'No se puede especificar una cuenta de tipo comercial como contrapartida en un diario contable.\Libro %1, secci�n %2, l�nea %3';
        Text004: TextConst ENU = 'You must specify Job in Account %1', ESP = 'Debe especificar proyecto en cuenta %1';
    BEGIN
        //Funci�n que controla que la contrapartida de un diario nunca sea una cuenta de comercial.
        //Par�metros de entrada : Diario general de contabilidad.
        //Par�metros de salida : Ninguno.

        IF (recLinJnlGen."Adjust WIP") OR (recLinJnlGen."Document Type" = recLinJnlGen."Document Type"::WIP) THEN //JAV 11/08/21: - QB 1.09.16 No controlar esto si es WIP
            EXIT;

        IF recLinJnlGen."Bal. Account Type" = recLinJnlGen."Bal. Account Type"::"G/L Account" THEN BEGIN
            IF recLinJnlGen."Bal. Account No." <> '' THEN BEGIN
                recGLAccount.GET(recLinJnlGen."Bal. Account No.");
                IF recGLAccount."Income/Balance" = recGLAccount."Income/Balance"::"Income Statement" THEN
                    ERROR(Text003, recLinJnlGen."Journal Template Name", recLinJnlGen."Journal Batch Name", recLinJnlGen."Line No.");
            END;
        END;

        IF NOT recLinJnlGen."System-Created Entry" THEN BEGIN
            IF recLinJnlGen."Account Type" = recLinJnlGen."Account Type"::"G/L Account" THEN BEGIN
                IF recLinJnlGen."Account No." <> '' THEN BEGIN
                    recGLAccount.GET(recLinJnlGen."Account No.");
                    IF recGLAccount."Income/Balance" = recGLAccount."Income/Balance"::"Income Statement" THEN
                        IF recLinJnlGen."Job No." = '' THEN
                            ERROR(Text004, recLinJnlGen."Account No.");
                END;
            END;
        END;
    END;

    PROCEDURE FunCreateAssetsDim(VAR recGenJnlLine: Record 81; CodeCta: Code[20]; CodeJob: Code[20]);
    VAR
        recDepreciationBook: Record 5612;
        recGLAccount: Record 15;
        recDefaultDim: Record 352;
        recLinJnlJob: Record 210;
        recLinJnlJob2: Record 210;
        RecQuobuildingSetup: Record 7207278;
        intNumLine: Integer;
        cduPostJob: Codeunit 1012;
        codeCA: Code[20];
        decAmount: Decimal;
        FixedAsset: Record 5600;
    BEGIN
        WITH recGenJnlLine DO BEGIN
            recSourceCodeSetup.GET;
            IF (recGenJnlLine."Source Code" = recSourceCodeSetup."Close Income Statement") AND
               (NORMALDATE(recGenJnlLine."Posting Date") <> recGenJnlLine."Posting Date") THEN
                EXIT;

            recGLAccount.GET(CodeCta);
            RecQuobuildingSetup.GET;
            IF recGLAccount."Income/Balance" = recGLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                IF CodeJob <> '' THEN BEGIN
                    IF "Already Generated Job Entry" THEN
                        EXIT;
                    IF NOT "Already Generated Job Entry" THEN BEGIN
                        IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
                            //JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
                            //recDepreciationBook.GET(recGenJnlLine."Source No.",recGenJnlLine."Depreciation Book Code");
                            //recDepreciationBook.TESTFIELD("OLD_Asset Allocation Job");
                            //recGenJnlLine."Job No." := CodeJob;
                            //recGenJnlLine."Piecework Code":= recDepreciationBook."OLD_Piecework Code";
                            FixedAsset.GET(recGenJnlLine."Source No.");
                            FixedAsset.TESTFIELD("Asset Allocation Job");
                            recGenJnlLine."Job No." := CodeJob;
                            recGenJnlLine."Piecework Code" := FixedAsset."Piecework Code";


                            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                                      CodeJob,
                                                      recGenJnlLine."Dimension Set ID");
                            //Buscamos las dimensiones del proyecto del activo
                            recDefaultDim.RESET;
                            recDefaultDim.SETRANGE("Table ID", DATABASE::Job);
                            recDefaultDim.SETRANGE("No.", CodeJob);
                            recDefaultDim.SETFILTER("Dimension Value Code", '<>%1', '');
                            IF recDefaultDim.FINDSET THEN
                                REPEAT
                                    FunctionQB.UpdateDimSet(recDefaultDim."Dimension Code",
                                                              recDefaultDim."Dimension Value Code",
                                                              recGenJnlLine."Dimension Set ID");
                                UNTIL recDefaultDim.NEXT = 0;

                            DimMgt.UpdateGlobalDimFromDimSetID(recGenJnlLine."Dimension Set ID", recGenJnlLine."Shortcut Dimension 1 Code", recGenJnlLine."Shortcut Dimension 2 Code");
                        END;
                    END;
                END;
            END;
        END;
    END;

    PROCEDURE FunInheritFieldsGL(recLinJnlLine: Record 81; VAR recGLEntry: Record 17);
    BEGIN
        recGLEntry."QB Piecework Code" := recLinJnlLine."Piecework Code";
        recGLEntry."QB Expense Note Code" := recLinJnlLine."Expense Note Code";
    END;

    PROCEDURE FunCreateAllocation(VAR recLinJnlGen: Record 81; VAR recGLEntry: Record 17);
    VAR
        intNumLine: Integer;
        cduPostJob: Codeunit 1012;
        codeCA: Code[20];
        decAmount: Decimal;
        locIntNumDist: Integer;
        TempDimSetEntry: Record 480 TEMPORARY;
        recGLAccount: Record 15;
        QuobuildingSetup: Record 7207278;
        recDepreciationBook: Record 5612;
        recDimDefault: Record 352;
        recLinJnlJob: Record 210;
        recLinJnlJob2: Record 210;
        Customer: Record 18;
        Vendor: Record 23;
        Job: Record 167;
        FixedAsset: Record 5600;
    BEGIN
        //Funci�n que genera un la imputaci�n a los proyectos.Cada vez que se haga un movimiento contable a una cuenta
        //de comercial se debe generar un movimiento de proyecto.

        WITH recLinJnlGen DO BEGIN
            //Si es el asiento de regularizaci�n puede ir sin proyecto
            recSourceCodeSetup.GET;
            IF (recLinJnlGen."Source Code" = recSourceCodeSetup."Close Income Statement") AND
               (NORMALDATE(recLinJnlGen."Posting Date") <> recLinJnlGen."Posting Date") THEN
                EXIT;

            recGLAccount.GET(recGLEntry."G/L Account No.");
            QuobuildingSetup.GET;
            //JAV 06/10/22: - QB 1.12.00 Se a�aden los movimientos de las cuentas de activaci�n en la creaci�n de mov. de proyecto
            IF (recGLAccount."Income/Balance" = recGLAccount."Income/Balance"::"Income Statement") OR (recLinJnlGen."QB Activation Mov.") THEN BEGIN
                IF recGLEntry."Job No." <> '' THEN BEGIN
                    IF "Already Generated Job Entry" THEN
                        EXIT
                    ELSE
                        codeJob := recLinJnlGen."Job No.";
                END ELSE BEGIN
                    IF NOT "Already Generated Job Entry" THEN BEGIN
                        IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
                            //JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
                            //recDepreciationBook.GET(recLinJnlGen."Source No.",recLinJnlGen."Depreciation Book Code");
                            //recDepreciationBook.TESTFIELD("OLD_Asset Allocation Job");
                            //codeJob := recDepreciationBook."OLD_Asset Allocation Job";
                            //recGLEntry."Job No." := codeJob;
                            //recGLEntry."QB Piecework Code" := recDepreciationBook."OLD_Piecework Code";
                            //recLinJnlGen."Piecework Code" := recDepreciationBook."OLD_Piecework Code";
                            FixedAsset.GET(recLinJnlGen."Source No.");
                            FixedAsset.TESTFIELD("Asset Allocation Job");
                            codeJob := FixedAsset."Asset Allocation Job";
                            recGLEntry."Job No." := codeJob;
                            recGLEntry."QB Piecework Code" := FixedAsset."Piecework Code";
                            recLinJnlGen."Piecework Code" := FixedAsset."Piecework Code";


                            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                                      codeJob,
                                                      recGLEntry."Dimension Set ID");
                            DimMgt.UpdateGlobalDimFromDimSetID(recGLEntry."Dimension Set ID", recGLEntry."Global Dimension 1 Code", recGLEntry."Global Dimension 2 Code");

                            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                                      codeJob,
                                                      recLinJnlGen."Dimension Set ID");
                            DimMgt.UpdateGlobalDimFromDimSetID(recLinJnlGen."Dimension Set ID", recLinJnlGen."Shortcut Dimension 1 Code", recLinJnlGen."Shortcut Dimension 2 Code");

                            codeCA := FunctionQB.GetCA(DATABASE::"G/L Account", recGLEntry."G/L Account No.");
                            IF codeCA <> '' THEN BEGIN

                                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                                          codeCA,
                                                          recGLEntry."Dimension Set ID");
                                DimMgt.UpdateGlobalDimFromDimSetID(recGLEntry."Dimension Set ID", recGLEntry."Global Dimension 1 Code", recGLEntry."Global Dimension 2 Code");

                                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                                          codeCA,
                                                          recLinJnlGen."Dimension Set ID");
                                DimMgt.UpdateGlobalDimFromDimSetID(recLinJnlGen."Dimension Set ID", recLinJnlGen."Shortcut Dimension 1 Code", recLinJnlGen."Shortcut Dimension 2 Code");

                            END;
                        END ELSE BEGIN
                            recDimDefault.RESET;
                            IF (recDimDefault.GET(DATABASE::"G/L Account", recGLEntry."G/L Account No.", FunctionQB.ReturnDimJobs)) AND
                               (recDimDefault."Value Posting" = recDimDefault."Value Posting"::"Same Code") THEN BEGIN
                                recDimDefault.TESTFIELD("Dimension Value Code");
                                codeJob := recDimDefault."Dimension Value Code";
                                codeCA := FunctionQB.GetCA(DATABASE::"G/L Account", recGLEntry."G/L Account No.");

                                TempDimSetEntry.RESET;
                                TempDimSetEntry.DELETEALL;
                                DimMgt.GetDimensionSet(TempDimSetEntry, recLinJnlGen."Dimension Set ID");
                                TempDimSetEntry.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                                IF (NOT TempDimSetEntry.FINDFIRST) AND (codeCA = '') THEN
                                    ERROR(Text002, recGLEntry."G/L Account No.");

                                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                                          FunctionQB.GetDepartment(DATABASE::Job, codeJob),
                                                          recLinJnlGen."Dimension Set ID");
                                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                                          codeJob,
                                                          recLinJnlGen."Dimension Set ID");
                                IF codeCA <> '' THEN BEGIN
                                    TempDimSetEntry.RESET;
                                    TempDimSetEntry.DELETEALL;
                                    DimMgt.GetDimensionSet(TempDimSetEntry, recLinJnlGen."Dimension Set ID");
                                    TempDimSetEntry.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                                    IF NOT TempDimSetEntry.FINDFIRST THEN BEGIN
                                        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                                                  codeCA,
                                                                  recLinJnlGen."Dimension Set ID");
                                    END;
                                END;
                                DimMgt.UpdateGlobalDimFromDimSetID(recLinJnlGen."Dimension Set ID", recLinJnlGen."Shortcut Dimension 1 Code", recLinJnlGen."Shortcut Dimension 2 Code");

                                recGLEntry."Job No." := codeJob;
                                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                                          FunctionQB.GetDepartment(DATABASE::Job, codeJob),
                                                          recGLEntry."Dimension Set ID");
                                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                                          codeJob,
                                                          recGLEntry."Dimension Set ID");

                                IF codeCA <> '' THEN BEGIN
                                    TempDimSetEntry.RESET;
                                    TempDimSetEntry.DELETEALL;
                                    DimMgt.GetDimensionSet(TempDimSetEntry, recLinJnlGen."Dimension Set ID");
                                    TempDimSetEntry.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                                    IF NOT TempDimSetEntry.FINDFIRST THEN BEGIN
                                        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                                                  codeCA,
                                                                  recLinJnlGen."Dimension Set ID");
                                    END;
                                END;
                                DimMgt.UpdateGlobalDimFromDimSetID(recGLEntry."Dimension Set ID", recGLEntry."Global Dimension 1 Code", recGLEntry."Global Dimension 2 Code");
                            END ELSE
                                IF NOT QuobuildingSetup."Skip Required Project" THEN
                                    ERROR(Text000, recGLEntry."G/L Account No.")
                                ELSE
                                    EXIT;
                        END;
                    END ELSE
                        IF NOT QuobuildingSetup."Skip Required Project" THEN
                            ERROR(Text004, recGLEntry."G/L Account No.")
                        ELSE
                            EXIT
                END;
            END ELSE BEGIN
                recGLEntry."Job No." := '';
                EXIT;
            END;

            recLinJnlJob.INIT;
            recLinJnlJob."Entry Type" := Enum::"Job Journal Line Entry Type".FromInteger(recLinJnlGen."Usage/Sale"); //option to enum
            recLinJnlJob.VALIDATE("Job No.", codeJob);                         //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
            recLinJnlJob."Posting Date" := recLinJnlGen."Posting Date";
            recLinJnlJob."Document No." := recLinJnlGen."Document No.";
            recLinJnlJob.Type := recLinJnlJob.Type::"G/L Account";
            recLinJnlJob."No." := recGLEntry."G/L Account No.";
            recLinJnlJob.Description := recLinJnlGen.Description;

            IF (recGLEntry."G/L Account No." <> recLinJnlGen."Account No.") THEN BEGIN
                decAmount := recGLEntry.Amount;
            END ELSE BEGIN
                IF recLinJnlGen."VAT Posting" = recLinJnlGen."VAT Posting"::"Automatic VAT Entry" THEN
                    decAmount := recLinJnlGen."Amount (LCY)" - recLinJnlGen."VAT Amount (LCY)"
                ELSE
                    decAmount := recLinJnlGen."Amount (LCY)";
            END;

            IF ((recGLEntry.Amount > 0) AND (recLinJnlGen."Usage/Sale" = recLinJnlGen."Usage/Sale"::Usage)) THEN BEGIN
                recLinJnlJob.Quantity := 1;
                recLinJnlJob."Quantity (Base)" := ABS(decAmount);
                recLinJnlJob."Qty. per Unit of Measure" := ABS(decAmount);
                recLinJnlJob.VALIDATE("Unit Cost (LCY)", ABS(decAmount));   //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
                recLinJnlJob.VALIDATE("Total Cost (LCY)", decAmount);       //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
            END;

            IF ((recGLEntry.Amount < 0) AND (recLinJnlGen."Usage/Sale" = recLinJnlGen."Usage/Sale"::Usage)) THEN BEGIN
                recLinJnlJob.Quantity := -1;
                recLinJnlJob."Quantity (Base)" := -ABS(decAmount);
                recLinJnlJob."Qty. per Unit of Measure" := ABS(decAmount);
                recLinJnlJob.VALIDATE("Unit Cost (LCY)", ABS(decAmount));   //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
                recLinJnlJob.VALIDATE("Total Cost (LCY)", decAmount);       //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
            END;

            IF ((recGLEntry.Amount < 0) AND (recLinJnlGen."Usage/Sale" = recLinJnlGen."Usage/Sale"::Sale)) THEN BEGIN
                recLinJnlJob.Quantity := -1;
                recLinJnlJob."Quantity (Base)" := -ABS(decAmount);
                recLinJnlJob."Qty. per Unit of Measure" := -ABS(decAmount);
                recLinJnlJob.VALIDATE("Unit Cost (LCY)", ABS(decAmount)); //se deja positivo  //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
                recLinJnlJob.VALIDATE("Total Cost (LCY)", decAmount);                         //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
            END;

            IF ((recGLEntry.Amount > 0) AND (recLinJnlGen."Usage/Sale" = recLinJnlGen."Usage/Sale"::Sale)) THEN BEGIN
                recLinJnlJob.Quantity := 1;
                recLinJnlJob."Quantity (Base)" := ABS(decAmount);
                recLinJnlJob."Qty. per Unit of Measure" := ABS(decAmount);
                recLinJnlJob.VALIDATE("Unit Cost (LCY)", ABS(decAmount)); //se deja positivo  //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
                recLinJnlJob.VALIDATE("Total Cost", decAmount);                               //JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento, cambio := por validate
            END;

            //recLinJnlJob.VALIDATE("Unit Cost",recLinJnlJob."Unit Cost");
            //recLinJnlJob.VALIDATE("Total Cost",recLinJnlJob."Total Cost");
            recLinJnlJob."Shortcut Dimension 1 Code" := recLinJnlGen."Shortcut Dimension 1 Code";
            recLinJnlJob."Shortcut Dimension 2 Code" := recLinJnlGen."Shortcut Dimension 2 Code";
            recLinJnlJob.Chargeable := TRUE;
            recLinJnlJob."Posting Group" := recLinJnlGen."Posting Group";
            recLinJnlJob."Source Code" := recLinJnlGen."Source Code";
            recLinJnlJob."Post Job Entry Only" := TRUE;
            recLinJnlJob."Gen. Bus. Posting Group" := recLinJnlGen."Gen. Bus. Posting Group";
            recLinJnlJob."Gen. Prod. Posting Group" := recLinJnlGen."Gen. Prod. Posting Group";
            recLinJnlJob."Document Date" := recLinJnlGen."Document Date";
            recLinJnlJob."External Document No." := recLinJnlGen."External Document No.";
            recLinJnlJob."Source Currency Total Cost" := recLinJnlGen."Source Currency Amount";
            recLinJnlJob."Expense Notes Code" := recLinJnlGen."Expense Note Code";
            recLinJnlJob."Expense Notes Code" := recLinJnlGen."Expense Note Code";
            recLinJnlJob."Job Posting Only" := TRUE;
            recLinJnlJob."Job Task No." := recLinJnlGen."Job Task No.";
            recLinJnlJob."Job Closure Entry" := recLinJnlGen."Job Closure Entry";
            recLinJnlJob."Dimension Set ID" := recLinJnlGen."Dimension Set ID";
            recLinJnlJob."Piecework Code" := recLinJnlGen."Piecework Code";

            //GAP888
            CASE recLinJnlGen."Document Type" OF
                recLinJnlGen."Document Type"::Invoice:
                    recLinJnlJob."Source Document Type" := recLinJnlJob."Source Document Type"::Invoice;
                recLinJnlGen."Document Type"::"Credit Memo":
                    recLinJnlJob."Source Document Type" := recLinJnlJob."Source Document Type"::"Credit Memo";
            END;

            CASE recLinJnlGen."Account Type" OF
                recLinJnlGen."Account Type"::Customer:
                    BEGIN
                        recLinJnlJob."Source Type" := recLinJnlJob."Source Type"::Customer;
                        recLinJnlJob."Source No." := recLinJnlGen."Account No.";
                        IF Customer.GET(recLinJnlGen."Account No.") THEN
                            recLinJnlJob."Source Name" := Customer.Name;
                    END;
                recLinJnlGen."Account Type"::Vendor:
                    BEGIN
                        recLinJnlJob."Source Type" := recLinJnlJob."Source Type"::Vendor;
                        recLinJnlJob."Source No." := recLinJnlGen."Account No.";
                        IF Vendor.GET(recLinJnlGen."Account No.") THEN
                            recLinJnlJob."Source Name" := Vendor.Name;
                    END;

                //EPV 05/01/23: - Q18495
                recLinJnlGen."Account Type"::"G/L Account":
                    BEGIN
                        IF recLinJnlGen."Source Type" = recLinJnlGen."Source Type"::Vendor THEN BEGIN
                            recLinJnlJob."Source Type" := recLinJnlJob."Source Type"::Vendor;
                            recLinJnlJob."Source No." := recLinJnlGen."Source No.";
                            IF Vendor.GET(recLinJnlGen."Source No.") THEN
                                recLinJnlJob."Source Name" := Vendor.Name;
                        END;

                        IF recLinJnlGen."Source Type" = recLinJnlGen."Source Type"::Customer THEN BEGIN
                            recLinJnlJob."Source Type" := recLinJnlJob."Source Type"::Customer;
                            recLinJnlJob."Source No." := recLinJnlGen."Source No.";
                            IF Customer.GET(recLinJnlGen."Source No.") THEN
                                recLinJnlJob."Source Name" := Customer.Name;
                        END;
                    END;

            END;
            //GAP888 fin



            //JAV 20/11/20: - QB 1.07.06 Poner la divisa de la transaccion y su importe en el diario
            recLinJnlJob."Transaction Currency" := recLinJnlGen."Currency Code";
            recLinJnlJob."Total Cost (TC)" := recLinJnlGen.Amount;
            //JAV 20/11/20 fin

            //JAV 06/10/22: - QB 1.12.00 Se a�aden los movimientos de las cuentas de activaci�n en la creaci�n de mov. de proyecto
            recLinJnlJob."QB Activation Mov." := recLinJnlGen."QB Activation Mov.";

            cduPostJob.RunWithCheck(recLinJnlJob);
        END;
    END;

    PROCEDURE PlannedRestimationMilestones(ParCabReestimacion: Record 7207315);
    VAR
        LocPPto: Record 95;
        LocVarDimProyc: Code[10];
        LocImporteCA: Decimal;
        LocLinReestimacion: Record 7207316;
    BEGIN
        LocLinReestimacion.SETRANGE("Document No.", ParCabReestimacion."No.");
        LocVarDimProyc := FunctionQB.ReturnDimJobs;
        LocPPto.Name := FunctionQB.ReturnBudgetJobs;

        LocPPto.GET(LocPPto.Name);

        IF LocLinReestimacion.FINDSET(TRUE) THEN
            REPEAT
                LocLinReestimacion.CALCFIELDS("Estimated outstanding amount");
                PlannedOutstanding(LocLinReestimacion, LocLinReestimacion."Realized Amount", LocLinReestimacion."Estimated outstanding amount");
            UNTIL LocLinReestimacion.NEXT = 0;
    END;

    PROCEDURE "PlannedRestimationMilestonesY/N"(ParCabReestimacion: Record 7207315);
    BEGIN
        IF NOT CONFIRM(Text010) THEN
            EXIT;

        PlannedRestimationMilestones(ParCabReestimacion);

        MESSAGE(Text011);
    END;

    PROCEDURE PlannedOutstanding(ParLinReestimacion: Record 7207316; Realized: Decimal; OutstandigAmount: Decimal);
    VAR
        MilestoneCostsPlanning: Record 7207376;
        ExpenseAmount: Decimal;
        ExpenseDate: Date;
        RecMovppto: Record 7207319;
        RealPercent: Decimal;
        AcumulatedPercent: Decimal;
    BEGIN
        IF (Realized + OutstandigAmount) <> 0 THEN
            RealPercent := (Realized / (Realized + OutstandigAmount)) * 100;

        AcumulatedPercent := RealPercent;

        MilestoneCostsPlanning.SETRANGE("Job No.", ParLinReestimacion."Job No.");
        MilestoneCostsPlanning.SETRANGE("Concept Code", ParLinReestimacion."Analytical concept");
        IF MilestoneCostsPlanning.FINDFIRST THEN BEGIN
            //si hay planificaci�n borramos primero la informaci�n anterior

            RecMovppto.SETRANGE("Document No.", ParLinReestimacion."Document No.");
            RecMovppto.SETRANGE("Line No.", ParLinReestimacion."Line No.");
            RecMovppto.DELETEALL;

            REPEAT
                IF (MilestoneCostsPlanning.Percentage <= AcumulatedPercent) THEN
                    AcumulatedPercent := AcumulatedPercent - MilestoneCostsPlanning.Percentage
                ELSE BEGIN
                    ExpenseAmount := (OutstandigAmount * (MilestoneCostsPlanning.Percentage - AcumulatedPercent)) / 100;
                    AcumulatedPercent := 0;
                    ExpenseDate := MilestoneCostsPlanning.ShowDateMilestone;
                    InsertReestimationExpense(ParLinReestimacion, ExpenseAmount, ExpenseDate);
                END;
            UNTIL MilestoneCostsPlanning.NEXT = 0
        END;
    END;

    PROCEDURE InsertReestimationExpense(ReestimationLines: Record 7207316; Amount: Decimal; Date: Date);
    VAR
        MovBudgetForecast: Record 7207319;
        DimensionValue: Record 349;
        VarDimProy: Code[10];
        GLBudgetName: Record 95;
        ReestimationHeader: Record 7207315;
        NumMov: Integer;
    BEGIN
        //[con esta funci�n insertamos en la tabla de mov.ppto de reestimaci�n
        ReestimationHeader.GET(ReestimationLines."Document No.");

        IF NumMov = 0 THEN BEGIN
            MovBudgetForecast.FINDLAST;
            NumMov := MovBudgetForecast."Entry No.";
        END;
        CLEAR(MovBudgetForecast);


        NumMov := NumMov + 1;
        MovBudgetForecast."Entry No." := NumMov;
        MovBudgetForecast."Document No." := ReestimationLines."Document No.";
        MovBudgetForecast."Line No." := ReestimationLines."Line No.";
        MovBudgetForecast."Anality Concept Code" := ReestimationLines."Analytical concept";
        MovBudgetForecast.Description := ReestimationLines.Description;
        MovBudgetForecast."Forecast Date" := Date;
        MovBudgetForecast.VALIDATE("Outstanding Temporary Forecast", Amount);
        MovBudgetForecast.VALIDATE("Job No.", ReestimationLines."Job No.");
        MovBudgetForecast."Reestimation code" := ReestimationHeader."Reestimation Code";


        IF MovBudgetForecast."Outstanding Temporary Forecast" <> 0 THEN
            MovBudgetForecast.INSERT(TRUE);
    END;

    PROCEDURE ChargeRulesGenerals(PJob: Code[20]);
    VAR
        LRulesJobTreasury: Record 7207379;
        LDimensionValue: Record 349;
    BEGIN
        LDimensionValue.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
        LDimensionValue.SETRANGE("Dimension Value Type", LDimensionValue."Dimension Value Type"::Standard);
        IF LDimensionValue.FINDFIRST THEN
            REPEAT
                IF LRulesJobTreasury.GET(PJob, LDimensionValue.Code) THEN BEGIN
                    LRulesJobTreasury.VALIDATE(LRulesJobTreasury."Cash Mgt Rule Code", LDimensionValue."Cash MGT Rule Code");
                    LRulesJobTreasury.VALIDATE("VAT Prod. Posting Group", LDimensionValue."VAT Prod. Posting Group");
                    LRulesJobTreasury.MODIFY;
                END ELSE BEGIN
                    LRulesJobTreasury."Job No." := PJob;
                    LRulesJobTreasury."Analytic Concept" := LDimensionValue.Code;
                    LRulesJobTreasury.VALIDATE("Cash Mgt Rule Code", LDimensionValue."Cash MGT Rule Code");
                    LRulesJobTreasury.VALIDATE("VAT Prod. Posting Group", LDimensionValue."VAT Prod. Posting Group");
                    LRulesJobTreasury.INSERT;
                END;
            UNTIL LDimensionValue.NEXT = 0;
    END;

    PROCEDURE ReturnLocationEntry(PValueEntry: Record 5802): Code[10];
    VAR
        LTransferShipmentHeader: Record 5744;
        LTransferReceiptHeader: Record 5746;
    BEGIN
        // Devolvemos el almac�n real cuando es un mov. de tr�nsito
        IF PValueEntry."Item Ledger Entry Type" <> PValueEntry."Item Ledger Entry Type"::Transfer THEN
            EXIT(PValueEntry."Location Code");
        IF PValueEntry."Document Type" = PValueEntry."Document Type"::"Transfer Shipment" THEN BEGIN
            LTransferShipmentHeader.GET(PValueEntry."Document No.");
            EXIT(LTransferShipmentHeader."Transfer-from Code");
        END;
        IF PValueEntry."Document Type" = PValueEntry."Document Type"::"Transfer Receipt" THEN BEGIN
            LTransferReceiptHeader.GET(PValueEntry."Document No.");
            EXIT(LTransferReceiptHeader."Transfer-to Code");
        END;
    END;

    PROCEDURE VariationStock(VAR GenJournalLine: Record 81; InvtPostingBuffer: Record 48);
    VAR
        GLAccount: Record 15;
        InventoryPostingSetup: Record 5813;
        DimensionValue: Record 349;
        Location: Record 14;
        DefaultDimension: Record 352;
        CCA: Code[20];
        CDepartament: Code[20];
        CJob: Code[20];
        Job: Record 167;
        QuoBuildingSetup: Record 7207278;
    BEGIN
        QuoBuildingSetup.GET;
        IF GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"G/L Account" THEN
            EXIT;

        IF NOT GLAccount.GET(GenJournalLine."Account No.") THEN
            EXIT;

        IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Balance Sheet" THEN BEGIN
            GenJournalLine."Job No." := '';
            EXIT;
        END;

        IF InventoryPostingSetup.GET(InvtPostingBuffer."Location Code", InvtPostingBuffer."Inventory Posting Group") THEN BEGIN
            InventoryPostingSetup.TESTFIELD(InventoryPostingSetup."Analytic Concept");
            CCA := InventoryPostingSetup."Analytic Concept";
            IF Location.GET(InvtPostingBuffer."Location Code") THEN BEGIN
                Location.TESTFIELD("QB Departament Code");
                CDepartament := Location."QB Departament Code";
                DimensionValue.GET(FunctionQB.ReturnDimDpto, CDepartament);
                IF NOT QuoBuildingSetup."Skip Required Project" THEN
                    DimensionValue.TESTFIELD("Job Structure Warehouse");
                CJob := DimensionValue."Job Structure Warehouse";

            END ELSE
                EXIT;
        END ELSE
            ERROR(Text006, InvtPostingBuffer."Location Code", InvtPostingBuffer."Inventory Posting Group");

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                  CCA,
                                  GenJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");
        GenJournalLine."Job No." := CJob;
        IF Job.GET(CJob) THEN
            GenJournalLine."Piecework Code" := Job."Warehouse Cost Unit";

        IF CCA <> '' THEN BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                      CCA,
                                      GenJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");
        END;

        IF CJob <> '' THEN BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                      CJob,
                                      GenJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");
        END;
        IF CDepartament <> '' THEN BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                      CDepartament,
                                      GenJournalLine."Dimension Set ID");
        END;
    END;

    PROCEDURE TransferAdjustsJobConsumption(VAR GenJournalLine: Record 81; InvtPostBuf: Record 48; PValueEntry: Record 5802; VAR GenJnlPostLine: Codeunit 12);
    VAR
        LGenJournalLine: Record 81;
        GLAccount: Record 15;
        InventoryPostingSetup: Record 5813;
        DimensionValue: Record 349;
        Location: Record 14;
        DefaultDimension: Record 352;
        CCA: Code[20];
        CDepartament: Code[20];
        CJob: Code[20];
        Job: Record 167;
        JobLedgerEntry: Record 169;
        LGeneralLedgerSetup: Record 98;
    BEGIN
        IF GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"G/L Account" THEN
            EXIT;

        IF NOT GLAccount.GET(GenJournalLine."Account No.") THEN
            EXIT;

        IF GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Balance Sheet" THEN BEGIN
            GenJournalLine."Job No." := '';
            EXIT;
        END;

        IF InventoryPostingSetup.GET(InvtPostBuf."Location Code", InvtPostBuf."Inventory Posting Group") THEN BEGIN
            InventoryPostingSetup.TESTFIELD(InventoryPostingSetup."Analytic Concept");
            CCA := InventoryPostingSetup."Analytic Concept";
            IF Location.GET(InvtPostBuf."Location Code") THEN BEGIN
                Location.TESTFIELD("QB Departament Code");
                CDepartament := Location."QB Departament Code";
                DimensionValue.GET(FunctionQB.ReturnDimDpto, CDepartament);
                DimensionValue.TESTFIELD("Job Structure Warehouse");
                CJob := DimensionValue."Job Structure Warehouse";
            END ELSE
                EXIT;
        END ELSE
            ERROR(Text006, InvtPostBuf."Location Code", InvtPostBuf."Inventory Posting Group");

        JobLedgerEntry.SETCURRENTKEY(JobLedgerEntry."Related Item Entry No.", JobLedgerEntry."Job No.");
        JobLedgerEntry.SETRANGE("Related Item Entry No.", PValueEntry."Item Ledger Entry No.");
        JobLedgerEntry.SETFILTER("Job No.", '<>%1', CJob);
        IF JobLedgerEntry.FINDFIRST THEN BEGIN
            Job.GET(CJob);
            LGenJournalLine.INIT;
            LGenJournalLine.VALIDATE("Posting Date", GenJournalLine."Posting Date");
            LGenJournalLine."Account Type" := LGenJournalLine."Account Type"::"G/L Account";
            LGenJournalLine."Account No." := InventoryPostingSetup."App.Account Locat Acc. Consum.";
            LGenJournalLine."Document No." := GenJournalLine."Document No.";
            LGenJournalLine."External Document No." := GenJournalLine."External Document No.";
            LGenJournalLine.Description := GenJournalLine.Description;
            LGenJournalLine."Source Code" := GenJournalLine."Source Code";
            LGenJournalLine."System-Created Entry" := TRUE;
            LGenJournalLine."Dimension Set ID" := JobLedgerEntry."Dimension Set ID";


            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                       CCA,
                                       LGenJournalLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                       CDepartament,
                                       LGenJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(LGenJournalLine."Dimension Set ID", LGenJournalLine."Shortcut Dimension 1 Code", LGenJournalLine."Shortcut Dimension 2 Code");

            LGenJournalLine.VALIDATE(Amount, -GenJournalLine.Amount);
            LGenJournalLine."Gen. Bus. Posting Group" := '';
            LGenJournalLine."Gen. Prod. Posting Group" := '';
            LGenJournalLine."VAT Bus. Posting Group" := '';
            LGenJournalLine."VAT Prod. Posting Group" := '';

            LGenJournalLine."Job No." := CJob;
            LGenJournalLine."Piecework Code" := Job."Warehouse Cost Unit";
            IF (Job."Warehouse Cost Unit" = '') AND
               (Job."Mandatory Allocation Term By" <> Job."Mandatory Allocation Term By"::"Not necessary") THEN
                LGenJournalLine."Piecework Code" := JobLedgerEntry."Piecework No.";

            LGenJournalLine."Job Task No." := Job."Location Task No.";
            IF (Job."Location Task No." = '') AND (Job."Management by tasks") THEN
                LGenJournalLine."Job Task No." := JobLedgerEntry."Job Task No.";

            IF CCA <> '' THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                          CCA,
                                          LGenJournalLine."Dimension Set ID");
            END;

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                      CJob,
                                      LGenJournalLine."Dimension Set ID");

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                      CDepartament,
                                      LGenJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(LGenJournalLine."Dimension Set ID", LGenJournalLine."Shortcut Dimension 1 Code", LGenJournalLine."Shortcut Dimension 2 Code");
            GenJnlPostLine.RunWithCheck(LGenJournalLine);

            Job.GET(JobLedgerEntry."Job No.");
            LGenJournalLine.INIT;
            LGenJournalLine.VALIDATE("Posting Date", GenJournalLine."Posting Date");
            LGenJournalLine."Account Type" := LGenJournalLine."Account Type"::"G/L Account";
            LGenJournalLine."Account No." := InventoryPostingSetup."Location Account Consumption";
            LGenJournalLine."Document No." := GenJournalLine."Document No.";
            LGenJournalLine."External Document No." := GenJournalLine."External Document No.";
            LGenJournalLine.Description := GenJournalLine.Description;
            LGenJournalLine."Source Code" := GenJournalLine."Source Code";
            LGenJournalLine."System-Created Entry" := TRUE;
            LGenJournalLine."Dimension Set ID" := JobLedgerEntry."Dimension Set ID";

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                      CCA,
                                      LGenJournalLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                      FunctionQB.GetDepartment(DATABASE::Job, Job."No."),
                                      LGenJournalLine."Dimension Set ID");

            DimMgt.UpdateGlobalDimFromDimSetID(LGenJournalLine."Dimension Set ID", LGenJournalLine."Shortcut Dimension 1 Code", LGenJournalLine."Shortcut Dimension 2 Code");

            LGenJournalLine.VALIDATE(Amount, GenJournalLine.Amount);
            LGenJournalLine."Gen. Bus. Posting Group" := '';
            LGenJournalLine."Gen. Prod. Posting Group" := '';
            LGenJournalLine."VAT Bus. Posting Group" := '';
            LGenJournalLine."VAT Prod. Posting Group" := '';

            LGenJournalLine."Job No." := JobLedgerEntry."Job No.";
            IF JobLedgerEntry."Piecework No." <> '' THEN
                LGenJournalLine."Piecework Code" := JobLedgerEntry."Piecework No."
            ELSE
                LGenJournalLine."Piecework Code" := Job."Warehouse Cost Unit";    //JAV 30/03/21: - QB 1.08.31 se cambia el campo que era err�neo

            IF Job."Management by tasks" THEN BEGIN
                IF JobLedgerEntry."Job Task No." <> '' THEN
                    LGenJournalLine."Job Task No." := JobLedgerEntry."Job Task No."
                ELSE
                    LGenJournalLine."Job Task No." := Job."Location Task No.";
            END;

            IF CCA <> '' THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,
                                          CCA,
                                          LGenJournalLine."Dimension Set ID");
            END;

            IF JobLedgerEntry."Job No." <> '' THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,
                                          JobLedgerEntry."Job No.",
                                          LGenJournalLine."Dimension Set ID");

                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto,
                                          FunctionQB.GetDepartment(DATABASE::Job, JobLedgerEntry."Job No."),
                                          LGenJournalLine."Dimension Set ID");

            END;
            DimMgt.UpdateGlobalDimFromDimSetID(LGenJournalLine."Dimension Set ID", LGenJournalLine."Shortcut Dimension 1 Code", LGenJournalLine."Shortcut Dimension 2 Code");
            GenJnlPostLine.RunWithCheck(LGenJournalLine);
        END;
    END;

    LOCAL PROCEDURE "------------------------------------------ CU 80"();
    BEGIN
    END;

    PROCEDURE EmptyJobEntry();
    BEGIN
        //JAV 10/12/20: - QB 1.07.11 Se elimina la la variable global TmpJobJnlLine y se cambia su uso en la funcion EmptyJobEntry por QueueTmpJobJnlLine que es la apropiada
        QueueTmpJobJnlLine.DELETEALL;
    END;

    PROCEDURE QueueJobEntry(JobJnlLine: Record 210);
    BEGIN
        IF intNumLine = 0 THEN BEGIN
            IF QueueTmpJobJnlLine.FINDLAST THEN
                intNumLine := QueueTmpJobJnlLine."Line No." + 10000
            ELSE
                intNumLine := 10000;
        END ELSE
            intNumLine += 10000;

        QueueTmpJobJnlLine := JobJnlLine;
        QueueTmpJobJnlLine."Line No." := intNumLine;
        QueueTmpJobJnlLine.INSERT;
    END;

    PROCEDURE UnqueueJobEntry();
    VAR
        JobJnlLine: Record 210;
    BEGIN
        IF QueueTmpJobJnlLine.FINDSET(TRUE) THEN BEGIN
            REPEAT
                JobJnlLine.INIT;
                JobJnlLine := QueueTmpJobJnlLine;
                JobJnlLine."Line No." := 0;
                JobJnlPostLine.RunWithCheck(JobJnlLine);
            UNTIL QueueTmpJobJnlLine.NEXT = 0;
        END;
    END;

    PROCEDURE UpdateSalesLine(VAR recLinDiaGen: Record 81);
    BEGIN
        IF recLinDiaGen."Account Type" = recLinDiaGen."Account Type"::"Fixed Asset" THEN
            recLinDiaGen."Already Generated Job Entry" := FALSE
        ELSE
            recLinDiaGen."Already Generated Job Entry" := TRUE;
    END;

    /*BEGIN
/*{
      JAV 09/10/20: - QB 1.06.20 Se traslada el c�digo de "InheritFieldsVendorDetailed" a la cu 7207353 "QB - Codeunit - Subscriber" que es mas adecuado
      JAV 20/11/20: - QB 1.07.06 Poner la divisa del proyecto en el movimiento y los importes correctos entodas las divisas
      JAV 27/11/20: - QB 1.07.08 Crear el movimiento detallado de proyecto si es necesario
      JAV 10/12/20: - QB 1.07.11 Se elimina la variable global TmpJobJnlLine y se cambia su uso en la funcion EmptyJobEntry por QueueTmpJobJnlLine que es la apropiada
      JAV 31/12/20: - QB 1.07.18 Se elimina la funci�n InheritFieldsVAT que no se usa
      JAV 12/04/22: - QB 1.10.35 Se eliminan los campos DataPieceworkForProduction.Activable y JobLedgEntry.Activate porque no se usan para nada
      JAV 25/05/22: - QB 1.10.45 Se elimina la funci�n FunInheritFieldVendor que solo se usa en la CU 7207353 y se pasa el c�digo a esa cu
      JAV 05/07/22: - QB 1.10.58 (Q17292) cambiamos el uso de las variables del libro al propio activo
      JAV 13/07/22: - QB 1.11.00 Se elimina la funci�n CreateDimAllocation que no tiene sentido, ya lo hace al crear las l�neas
      JAV 06/10/22: - QB 1.12.00 Se a�aden los movimientos de las cuentas de activaci�n en la creaci�n de mov. de proyecto
      EPV 05/01/23: - Q18495 Se a�ade "N� origen" y "Tipo doc. origen" cuando el movimiento es de tipo Cuenta.
    }
END.*/
}










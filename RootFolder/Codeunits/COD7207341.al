Codeunit 7207341 "Validate Redetermination"
{


    TableNo = 7207437;
    trigger OnRun()
    VAR
        CertUnitRedetermination: Record 7207438;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        CertUnitRedeterminationBefore: Record 7207438;
        IncreaseTotal: Decimal;
    BEGIN
        IF rec.Validated THEN
            ERROR(Text003);
        IF NOT CONFIRM(Text001, FALSE, rec.Code) THEN
            ERROR(Text002);
        Job.GET(rec."Job No.");
        CertUnitRedeterminationBefore.SETCURRENTKEY("Job No.", "Piecework Code", Validated, "Aplication Date");
        CertUnitRedeterminationBefore.SETRANGE("Job No.", rec."Job No.");
        CertUnitRedeterminationBefore.SETRANGE(Validated, TRUE);
        CertUnitRedeterminationBefore.SETFILTER("Aplication Date", '>%1', rec."Aplication Date");
        CertUnitRedetermination.SETRANGE("Job No.", rec."Job No.");
        CertUnitRedetermination.SETRANGE("Redetermination Code", rec.Code);
        IF CertUnitRedetermination.FINDSET THEN BEGIN
            REPEAT
                IncreaseTotal := 0;
                DataPieceworkForProduction.GET(CertUnitRedetermination."Job No.", CertUnitRedetermination."Piecework Code");
                DataPieceworkForProduction."Last Unit Price Redetermined" := CertUnitRedetermination."Unit Price Redetermined";
                CertUnitRedeterminationBefore.SETRANGE("Piecework Code", CertUnitRedetermination."Piecework Code");
                IncreaseTotal := CertUnitRedetermination."Amount Sales Increase";
                IF CertUnitRedetermination.FINDSET THEN BEGIN
                    REPEAT
                        IncreaseTotal := IncreaseTotal + CertUnitRedetermination."Amount Sales Increase";
                    UNTIL CertUnitRedetermination.NEXT = 0;
                END;
                DataPieceworkForProduction."Increased Amount Of Redeterm." := IncreaseTotal;
                DataPieceworkForProduction."Sale Amount" := DataPieceworkForProduction."Sales Amount (Base)" + DataPieceworkForProduction."Increased Amount Of Redeterm.";
                DataPieceworkForProduction.MODIFY;

                CertUnitRedetermination.Validated := TRUE;
                CertUnitRedetermination.MODIFY;
            UNTIL CertUnitRedetermination.NEXT = 0;
        END;

        rec.Validated := TRUE;
        rec.MODIFY;

        // Lanzamos la reestiaci�n de coste para hacer que se acoja a la reterminaci�n de venta
        ThrowReestimation(Rec);
    END;

    VAR
        Text002: TextConst ENU = 'Process canceled by user', ESP = 'Proceso cancelado por el usuario';
        Text003: TextConst ENU = 'Redetermination has already been validated', ESP = 'La redeterminaci�n ya ha sido validada';
        Text001: TextConst ENU = 'Do you want to validate redetermination %1?', ESP = '�Desea validar la redeerminaci�n %1?';
        Text004: TextConst ENU = 'Date redetermination %1', ESP = 'Redeterminaci�n fecha %1';

    PROCEDURE ThrowReestimation(Jobredetermination: Record 7207437);
    VAR
        Job: Record 167;
        JobBudget: Record 7207407;
        BudgetReestimationInitialize: Codeunit 7207334;
    BEGIN
        Job.GET(Jobredetermination."Job No.");
        CLEAR(JobBudget);
        JobBudget.VALIDATE("Job No.", Jobredetermination."Job No.");
        JobBudget.VALIDATE("Cod. Budget", 'RC-' + Jobredetermination.Code);
        JobBudget.INSERT;
        JobBudget."Budget Name" := STRSUBSTNO(Text004, FORMAT(Jobredetermination."Aplication Date"));
        JobBudget.VALIDATE("Budget Date", CALCDATE('PM', DMY2DATE(1, DATE2DMY(Jobredetermination."Aplication Date", 2),
                                         DATE2DMY(Jobredetermination."Aplication Date", 3))) + 1);
        JobBudget.Status := JobBudget.Status::Open;
        JobBudget."Cod. Reestimation" := '';
        JobBudget."Actual Budget" := FALSE;
        JobBudget."Budget Simulation" := FALSE;
        JobBudget.MODIFY;

        COMMIT;
        CLEAR(BudgetReestimationInitialize);
        BudgetReestimationInitialize.RUN(JobBudget);
    END;

    /* /*BEGIN
END.*/
}








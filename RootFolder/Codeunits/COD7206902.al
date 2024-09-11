Codeunit 7206902 "QB Job Task Management"
{


    trigger OnRun()
    BEGIN
    END;

    PROCEDURE PerformedK(pJob: Code[20]; pDate: Date; pObject: Integer; pComment: Text);
    VAR
        QBJobTask: Record 7206902;
        QBJobTaskData: Record 7206927;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 12/08/22: - QB 1.11.02 Marca una tarea como correctamente realizada
        //---------------------------------------------------------------------------------------------------------

        QBJobTask.RESET;
        QBJobTask.SETRANGE("Job Type", GetJobType(pJob));
        QBJobTask.SETRANGE("Perform Object", pObject);
        IF (QBJobTask.FINDFIRST) THEN BEGIN
            IF (QBJobTaskData.GET(pJob, GetPeriod(pDate), QBJobTask."Perform Object")) THEN BEGIN
                IF (pComment <> '') THEN
                    QBJobTaskData.Comment := pComment;
                QBJobTaskData.Performed := TRUE;
                QBJobTaskData.MODIFY;
            END;
        END;
    END;

    PROCEDURE PerformedError(pJob: Code[20]; pDate: Date; pObject: Integer; pComment: Text);
    VAR
        QBJobTask: Record 7206902;
        QBJobTaskData: Record 7206927;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 12/08/22: - QB 1.11.02 Marca una tarea como err¢nea
        //---------------------------------------------------------------------------------------------------------

        QBJobTask.RESET;
        QBJobTask.SETRANGE("Job Type", GetJobType(pJob));
        QBJobTask.SETRANGE("Perform Object", pObject);
        IF (QBJobTask.FINDFIRST) THEN BEGIN
            IF (QBJobTaskData.GET(pJob, GetPeriod(pDate), QBJobTask."Perform Object")) THEN BEGIN
                IF (pComment <> '') THEN
                    QBJobTaskData.Comment := pComment
                ELSE
                    QBJobTaskData.Comment := 'La tarea finaliz¢ con error';
                QBJobTaskData.Performed := FALSE;
                QBJobTaskData.MODIFY;
            END;
        END;
    END;

    PROCEDURE CancelOK(pJob: Code[20]; pDate: Date; pObject: Integer; pComment: Text);
    VAR
        QBJobTask: Record 7206902;
        QBJobTaskData: Record 7206927;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 12/08/22: - QB 1.11.02 Marca una tarea como correctamente realizada
        //---------------------------------------------------------------------------------------------------------

        QBJobTask.RESET;
        QBJobTask.SETRANGE("Job Type", GetJobType(pJob));
        QBJobTask.SETRANGE("Cancel Object", pObject);
        IF (QBJobTask.FINDFIRST) THEN BEGIN
            IF (QBJobTaskData.GET(pJob, GetPeriod(pDate), QBJobTask."Cancel Object")) THEN BEGIN
                IF (pComment <> '') THEN
                    QBJobTaskData.Comment := pComment;
                QBJobTaskData.MODIFY;
            END;
        END;
    END;

    PROCEDURE CancelError(pJob: Code[20]; pDate: Date; pObject: Integer; pComment: Text);
    VAR
        QBJobTask: Record 7206902;
        QBJobTaskData: Record 7206927;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 12/08/22: - QB 1.11.02 Marca una tarea como err¢nea
        //---------------------------------------------------------------------------------------------------------

        QBJobTask.RESET;
        QBJobTask.SETRANGE("Job Type", GetJobType(pJob));
        QBJobTask.SETRANGE("Cancel Object", pObject);
        IF (QBJobTask.FINDFIRST) THEN BEGIN
            IF (QBJobTaskData.GET(pJob, GetPeriod(pDate), QBJobTask."Cancel Object")) THEN BEGIN
                IF (pComment <> '') THEN
                    QBJobTaskData.Comment := pComment
                ELSE
                    QBJobTaskData.Comment := 'No se pudo cancelar';
                QBJobTaskData.DELETE;
            END;
        END;
    END;

    PROCEDURE GetPeriod(pDate: Date): Text;
    VAR
        txt: Text;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 12/08/22: - QB 1.11.02 Retorna el periodo relacionado con una fecha dada
        //---------------------------------------------------------------------------------------------------------

        EXIT(FORMAT(pDate, 0, '<Year4>-<Month,2>'));
    END;

    PROCEDURE GetJobType(pJob: Code[20]): Integer;
    VAR
        Job: Record 167;
        QBJobTask: Record 7206902;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 12/08/22: - QB 1.11.02 Retorna el tipo de proyecto relacionado con un proyecto dato
        //---------------------------------------------------------------------------------------------------------

        Job.GET(pJob);
        CASE Job."Card Type" OF
            Job."Card Type"::"Proyecto operativo":
                EXIT(QBJobTask."Job Type"::QB);
            Job."Card Type"::Presupuesto:
                EXIT(QBJobTask."Job Type"::QPR);
            Job."Card Type"::Promocion:
                EXIT(QBJobTask."Job Type"::QRE);
        END;
    END;


    /*BEGIN
    /*{
          JAV 12/08/22: - QB 1.11.02 Nueva CE de manejo de Tareas de Proyectos
        }
    END.*/
}










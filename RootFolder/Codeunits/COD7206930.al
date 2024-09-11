Codeunit 7206930 "QPR Budgets Procesing"
{


    trigger OnRun()
    BEGIN
    END;

    LOCAL PROCEDURE "--------------------------------------------------------- Funciones"();
    BEGIN
    END;

    PROCEDURE SetAmounts(pCompanyOrigin: Text[50]; pJob: Code[20]; pBudget: Code[20]; pCompanyDestination: Text[50]; VAR Rec: Record 7207386);
    VAR
        Job: Record 167;
        JobBudget: Record 7207407;
        QPRAmounts: Record 7207383;
        sCos: Decimal;
        sIng: Decimal;
        LastNo: Integer;
    BEGIN
        QPRAmounts.RESET;
        QPRAmounts.CHANGECOMPANY(pCompanyDestination);
        QPRAmounts.SETRANGE("Job No.", Rec."Job No.");
        QPRAmounts.SETRANGE("Budget Code", pBudget);
        QPRAmounts.SETRANGE("Piecework code", Rec."Piecework Code");
        QPRAmounts.DELETEALL;
        Rec.VALIDATE("QPR Last Date Updated", 0D);


        Job.RESET;
        Job.CHANGECOMPANY(pCompanyOrigin);
        IF NOT Job.GET(pJob) THEN
            Job.INIT;

        Rec."QPR Name" := Job.Description;

        JobBudget.RESET;
        JobBudget.CHANGECOMPANY(pCompanyOrigin);
        IF JobBudget.GET(pJob, pBudget) THEN BEGIN
            Rec."QPR Name" := Job.Description + ' (' + JobBudget."Budget Name" + ')';

            sCos := 0;
            sIng := 0;

            QPRAmounts.RESET;
            QPRAmounts.CHANGECOMPANY(pCompanyOrigin);
            QPRAmounts.SETRANGE("Job No.", pJob);
            QPRAmounts.SETRANGE("Budget Code", pBudget);
            IF (QPRAmounts.FINDSET(FALSE)) THEN
                REPEAT
                    CASE QPRAmounts.Type OF
                        QPRAmounts.Type::Cost:
                            sCos += QPRAmounts."Cost Amount";
                        QPRAmounts.Type::Sales:
                            sIng += QPRAmounts."Sale Amount";
                    END;
                UNTIL (QPRAmounts.NEXT = 0);

            IF (pJob <> '') THEN BEGIN
                QPRAmounts.RESET;
                QPRAmounts.CHANGECOMPANY(pCompanyDestination);
                IF (QPRAmounts.FINDLAST) THEN
                    LastNo := QPRAmounts."Entry No."
                ELSE
                    LastNo := 0;

                QPRAmounts.INIT;
                QPRAmounts."Entry No." := LastNo + 1;
                QPRAmounts."Job No." := Rec."Job No.";
                QPRAmounts."Budget Code" := pBudget;
                QPRAmounts."Piecework code" := Rec."Piecework Code";
                QPRAmounts.Type := QPRAmounts.Type::Cost;
                QPRAmounts."Cost Amount" := sCos;
                QPRAmounts.INSERT;

                QPRAmounts."Entry No." := LastNo + 2;
                QPRAmounts.Type := QPRAmounts.Type::Sales;
                QPRAmounts."Cost Amount" := 0;
                QPRAmounts."Sale Amount" := sIng;
                QPRAmounts.INSERT;

                Rec.VALIDATE("QPR Last Date Updated", TODAY);
            END;
        END;
    END;

    LOCAL PROCEDURE "---------------------------------------------------------  Eventos de Tabla"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 7207383, OnAfterModifyEvent, '', true, true)]
    PROCEDURE T7207383_OnAfterModifyEvent(VAR Rec: Record 7207383; VAR xRec: Record 7207383; RunTrigger: Boolean);
    BEGIN
        //Verificar si hay que actualziar otros presupuestos de esta o de otras empresas
        IF (NOT RunTrigger) THEN
            EXIT;


        IF (Rec."Cost Amount" = xRec."Cost Amount") AND (Rec."Sale Amount" = xRec."Sale Amount") THEN
            EXIT;
    END;


    /*BEGIN
    /*{
          JAV 01/10/21: - QPR 1.00.00 Nueva CU para el manejo de los Presupuestos
        }
    END.*/
}










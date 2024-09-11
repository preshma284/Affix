Codeunit 7207357 "QB Objectives"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE CreateCardAPM(pJob : Code[20];pBudget : Code[20];pDate : Date);
    VAR
      HeaderCardAPM : Record 7207403;
    BEGIN
      CLEAR(HeaderCardAPM);
      HeaderCardAPM."Job No." := pJob;
      HeaderCardAPM."Budget Code" := pBudget;
      IF HeaderCardAPM.INSERT THEN;
      UpdateHeader(HeaderCardAPM);
    END;

    PROCEDURE UpdateHeader(VAR HeaderCardAPM : Record 7207403);
    VAR
      Job : Record 167;
      JobBudget : Record 7207407;
      DataPieceworkForProduction : Record 7207386;
      QBObjectivesLine : Record 7207404;
    BEGIN
      IF JobBudget.GET(HeaderCardAPM."Job No.", HeaderCardAPM."Budget Code") THEN BEGIN
        HeaderCardAPM."Budget Date" := JobBudget."Budget Date";
        HeaderCardAPM.MODIFY;

        CreateLinesForIncoming(HeaderCardAPM);
        CreateLinesForCost(HeaderCardAPM, DataPieceworkForProduction.Type::Piecework,   QBObjectivesLine."Line Type"::DirectCost);
        CreateLinesForCost(HeaderCardAPM, DataPieceworkForProduction.Type::"Cost Unit", QBObjectivesLine."Line Type"::IndirectCost);

        QBObjectivesLine.RESET;
        QBObjectivesLine.SETRANGE("Job No.", HeaderCardAPM."Job No.");
        QBObjectivesLine.SETRANGE("Budget Code", HeaderCardAPM."Budget Code");
        QBObjectivesLine.SETFILTER(Piecework, '<>%1', '');
        IF (QBObjectivesLine.FINDSET(TRUE)) THEN
          REPEAT
            QBObjectivesLine.VALIDATE(Piecework);
            QBObjectivesLine.MODIFY;
          UNTIL (QBObjectivesLine.NEXT = 0);

      END;
    END;

    PROCEDURE CreateLinesForIncoming(HeaderCardAPM : Record 7207403);
    VAR
      VRecords : Record 7207393;
      VDataPieceworkForProduction : Record 7207386;
      VTemporaryEnding : Decimal;
      VBudgetJob : Decimal;
      VJobExecuted : Decimal;
      VEndingP : Decimal;
      QBObjectivesLine : Record 7207404;
      Job : Record 167;
      TemporaryEnding : Decimal;
      BudgetJob : Decimal;
      JobExecuted : Decimal;
      EndingP : Decimal;
      DataPieceworkForProduction : Record 7207386;
    BEGIN
      Job.GET(HeaderCardAPM."Job No.");
      VRecords.SETRANGE("Job No.", HeaderCardAPM."Job No.");
      IF VRecords.FINDSET(FALSE) THEN
        REPEAT
          IF (NOT QBObjectivesLine.GET(HeaderCardAPM."Job No.", HeaderCardAPM."Budget Code", QBObjectivesLine."Line Type"::Sales, VRecords."No.",'')) THEN BEGIN
            CLEAR(QBObjectivesLine);
            QBObjectivesLine."Job No." := HeaderCardAPM."Job No.";
            QBObjectivesLine."Budget Code" := HeaderCardAPM."Budget Code";
            QBObjectivesLine."Line Type" := QBObjectivesLine."Line Type"::Sales;
            QBObjectivesLine.VALIDATE("Record No.", VRecords."No.");
            QBObjectivesLine.INSERT;
          END ELSE BEGIN
            QBObjectivesLine.VALIDATE("Record No.");
            QBObjectivesLine.MODIFY;
          END;
        UNTIL VRecords.NEXT = 0;
    END;

    PROCEDURE CreateLinesForCost(HeaderCardAPM : Record 7207403;dType : Option;CostType : Option);
    VAR
      JobBudget : Record 7207407;
      VDataPieceworkForProduction : Record 7207386;
      CostExecutedCostDirect : Decimal;
      QBObjectivesLine : Record 7207404;
    BEGIN
      JobBudget.GET(HeaderCardAPM."Job No.", HeaderCardAPM."Budget Code");
      JobBudget.CALCFIELDS("Budget Amount Cost Direct","Budget Amount Cost Indirect");
      JobBudget.CalculateProduction;

      QBObjectivesLine.RESET;
      QBObjectivesLine.SETRANGE("Job No.",HeaderCardAPM."Job No.");
      QBObjectivesLine.SETRANGE("Budget Code",HeaderCardAPM."Budget Code");
      QBObjectivesLine.SETRANGE("Line Type", CostType);
      QBObjectivesLine.SETRANGE("Record No.",'');
      IF NOT QBObjectivesLine.FINDFIRST THEN BEGIN
        CLEAR(QBObjectivesLine);
        QBObjectivesLine."Job No." := HeaderCardAPM."Job No.";
        QBObjectivesLine."Budget Code" := HeaderCardAPM."Budget Code";
        QBObjectivesLine."Line Type" := CostType;
        QBObjectivesLine."Record No." := '';
        QBObjectivesLine.INSERT;
      END;

      CASE CostType OF
        QBObjectivesLine."Line Type"::DirectCost   :
          BEGIN
            QBObjectivesLine.VALIDATE(Approved, JobBudget."Budget Amount Cost Direct");
            QBObjectivesLine.VALIDATE(Executed, JobBudget."Coste Directo Ejecutado");
          END;
        QBObjectivesLine."Line Type"::IndirectCost :
          BEGIN
            QBObjectivesLine.VALIDATE(Approved, JobBudget."Budget Amount Cost Indirect");
            QBObjectivesLine.VALIDATE(Executed, JobBudget."Coste Indirecto Ejecutado");
          END;
      END;
      QBObjectivesLine.MODIFY;
    END;

    LOCAL PROCEDURE "-------------------------- Eventos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 7207598, OnAfterActionEvent, Action7001122, true, true)]
    LOCAL PROCEDURE CardAPM(VAR Rec : Record 7207407);
    VAR
      LHeaderCardAPM : Record 7207403;
      LPageHeaderCardAPM : Page 7207594;
      QBObjectives : Codeunit 7207357;
    BEGIN
      CreateCardAPM(Rec."Job No.", Rec."Cod. Budget", Rec."Budget Date");
      COMMIT;

      LHeaderCardAPM.RESET;
      LHeaderCardAPM.FILTERGROUP(2);
      LHeaderCardAPM.SETRANGE("Job No.", Rec."Job No.");
      LHeaderCardAPM.SETRANGE("Budget Code", Rec."Cod. Budget");
      LHeaderCardAPM.FILTERGROUP(0);

      CLEAR(LPageHeaderCardAPM);
      LPageHeaderCardAPM.SETTABLEVIEW(LHeaderCardAPM);
      LPageHeaderCardAPM.RUNMODAL;
    END;

    /* /*BEGIN
END.*/
}








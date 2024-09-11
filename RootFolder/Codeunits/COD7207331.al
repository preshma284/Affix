Codeunit 7207331 "Change Budget Status"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Text001 : TextConst ENU='Are you sure you want to change the budget status?',ESP='¨Confirma que desea cambiar el estado del presupuesto?';
      Text002 : TextConst ENU='This budget is already set as current',ESP='Este presupuesto ya est  fijado como actual';
      Text003 : TextConst ENU='This budget is already set as current',ESP='Este presupuesto ya est  fijado como el inicial';

    PROCEDURE BudgetChangeStatus(VAR PJobBudget : Record 7207407);
    VAR
      UserSetup : Record 91;
      Txt001 : TextConst ESP='No tiene permiso para cambiar el estado del presupuesto';
    BEGIN
      //Cambiar estado del presupuesto, todos pueden cerrar, pero solo los que tengan permiso pueden abrir de nuevo
      IF (PJobBudget.Status = PJobBudget.Status::Close) THEN BEGIN
        UserSetup.GET(USERID);
        IF (NOT UserSetup."Modify Budget Status") THEN
          ERROR(Txt001);
      END;

      IF CONFIRM(Text001,FALSE) THEN BEGIN
        IF PJobBudget.Status = PJobBudget.Status::Open THEN
          PJobBudget.Status := PJobBudget.Status::Close
        ELSE
          PJobBudget.Status := PJobBudget.Status::Open;

        PJobBudget.MODIFY;
      END;
    END;

    PROCEDURE SetBudgetActual(VAR PJobBudget : Record 7207407);
    VAR
      LJobBudget : Record 7207407;
      LJob : Record 167;
    BEGIN
      //Establecer el presupuesto como el actual
      LJob.GET(PJobBudget."Job No.");
      LJob."Current Piecework Budget" := PJobBudget."Cod. Budget";
      LJob."Latest Reestimation Code" := PJobBudget."Cod. Reestimation";
      LJob.MODIFY;

      LJobBudget.SETRANGE("Job No.",PJobBudget."Job No.");
      LJobBudget.SETRANGE("Actual Budget",TRUE);
      LJobBudget.SETFILTER("Cod. Budget", '<>%1', PJobBudget."Cod. Budget");
      LJobBudget.MODIFYALL("Actual Budget", FALSE);

      IF PJobBudget."Actual Budget" THEN
       MESSAGE(Text002)
      ELSE BEGIN
        PJobBudget."Actual Budget" := TRUE;
        PJobBudget.MODIFY;
      END;
    END;

    PROCEDURE SetBudgetInitial(VAR PJobBudget : Record 7207407);
    VAR
      Job : Record 167;
      JobBudget : Record 7207407;
    BEGIN
      //Establecer el presupuesto como el inicial
      Job.GET(PJobBudget."Job No.");
      Job."Initial Budget Piecework" := PJobBudget."Cod. Budget";
      //JMMA a¤ado para reestimaciones
      IF PJobBudget."Cod. Reestimation"<>'' THEN
        Job."Initial Reestimation Code":=PJobBudget."Cod. Reestimation";
      Job.MODIFY;

      JobBudget.SETRANGE("Job No.",PJobBudget."Job No.");
      JobBudget.SETRANGE("Initial Budget",TRUE);
      JobBudget.SETFILTER("Cod. Budget", '<>%1', PJobBudget."Cod. Budget");
      JobBudget.MODIFYALL("Initial Budget", FALSE);

      IF (PJobBudget."Initial Budget") THEN
        MESSAGE(Text003)
      ELSE BEGIN
        PJobBudget."Initial Budget" := TRUE;
        PJobBudget.MODIFY;
      END;
    END;

    /*BEGIN
/*{
      QCPM_GAP08 29/04/19 PEL: Control al modificar estado ppto.
      JAV 06/08/19: - Se valida el cambio de estado para que tome el nuevo campo de bloqueado por
    }
END.*/
}








Codeunit 7238197 "QRE Functions"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE ValidateCostAmountFromDataPiece(Rec : Record 7207386;BudgetCode : Code[20]);
    VAR
      BudgetItemControl : Record 7238753;
      CostNotMinorThanCommitedErr : TextConst ESP='El %1 no puede ser menor que lo comprometido';
    BEGIN
      //QRE15469-LCG-091221-INI
      //Revisamos si el proyecto tiene marcado check de control presupuestario.
      CheckBudgetItemControl(Rec."Job No.");
      //Revisamos si est  aprobado
      CheckIfApprovedBudget(Rec."Job No.",BudgetCode);
      //Si el presupuesto esta abierto y no aprobado, no puede ser menor que el comprometido.
      IF Rec."QPR Cost Amount" < (Rec."QPR Cost Comprometido" + Rec."QPR Cost Performed" + Rec."QPR Cost Invoiced") THEN
        ERROR(CostNotMinorThanCommitedErr,Rec.FIELDCAPTION(Rec."QPR Cost Amount"));
      //QRE15469-LCG-091221-FIN

      //QRE15469-LCG-071221-INI

      //Controlamos que s¢lo haya una l¡nea de gasto.
      BudgetItemControl.RESET();
      BudgetItemControl.SETRANGE("QB_Job No.",Rec."Job No.");
      BudgetItemControl.SETRANGE("QB_Budget Code",BudgetCode);
      BudgetItemControl.SETRANGE("QB_PieceWork No.",Rec."Piecework Code");
      BudgetItemControl.SETRANGE(QB_Type,BudgetItemControl.QB_Type::Budget);
      IF BudgetItemControl.FINDFIRST THEN
        BEGIN
          BudgetItemControl.DELETEALL();
          BudgetItemControl.INIT;
          BudgetItemControl."QB_Job No." := Rec."Job No.";
          BudgetItemControl."QB_Budget Code" := BudgetCode;
          BudgetItemControl."QB_PieceWork No." := Rec."Piecework Code";

          BudgetItemControl.QB_Type := BudgetItemControl.QB_Type::Budget;
          BudgetItemControl."QB_Budget Amount" := Rec."QPR Cost Amount";
          BudgetItemControl.INSERT(TRUE);

        END;
      //QRE15469-LCG-071221-FIN
    END;

    PROCEDURE CheckBudgetItemControl(JobNo : Code[20]) : Boolean;
    VAR
      Job : Record 167;
    BEGIN
      //QRE15469-LCG-071221-INI
      Job.RESET();
      Job.SETRANGE("No.",JobNo);
      Job.SETRANGE("QB_Budget control", TRUE);
      IF Job.ISEMPTY THEN
        EXIT(FALSE)
      ELSE
        EXIT(TRUE);
      //QRE15469-LCG-071221-FIN
    END;

    PROCEDURE CheckIfApprovedBudget(JobNo : Code[20];BudgetCode : Code[20]);
    VAR
      DataPieceWFP : Record 7207386;
      JobBudget : Record 7207407;
      BudgetApprovedErr : TextConst ESP='El %1 %2 est  aprobado y no se puede modificar';
      PurchOrderAmount : Decimal;
      CommitedMoreThanBudgetErr : TextConst ESP='El %1 (%2) es mayor que el %3 (%4)';
    BEGIN
      //QRE15469-LCG-031221-INI
      //Si un proyecto est  aprobado no tocar el gasto de una partida presupuestaria.
      JobBudget.RESET();
      JobBudget.SETCURRENTKEY("Job No.","Cod. Budget");
      JobBudget.SETRANGE("Job No.",JobNo);
      JobBudget.SETRANGE("Actual Budget",TRUE);
      JobBudget.SETFILTER("Cod. Budget",BudgetCode);
      JobBudget.SETRANGE("Approval Status",JobBudget."Approval Status"::Released);
      IF JobBudget.FINDFIRST THEN
        ERROR(BudgetApprovedErr,JobBudget.FIELDCAPTION("Job No."),JobNo)
      //QRE15469-LCG-031221-FIN
    END;

    PROCEDURE ExistValDim(CA : Code[20]) : Boolean;
    VAR
      DimVal : Record 349;
      QuoBuildingSetup : Record 7207278;
    BEGIN
      QuoBuildingSetup.GET();
      QuoBuildingSetup.TESTFIELD("Dimension for CA Code");
      DimVal.RESET();
      DimVal.SETRANGE("Dimension Code",QuoBuildingSetup."Dimension for CA Code");
      DimVal.SETRANGE(Code,CA);
      IF NOT DimVal.ISEMPTY THEN
        EXIT(TRUE)
      ELSE
        EXIT(FALSE);
    END;

    /*BEGIN
/*{
      QRE16011-LCG-170122- Para no crear inconsistencia cuando se registre precontrato con iva.
      RE16187-LCG-190122- Al convertir una oferta insertamos el pedido en la oportunidad de inversi¢n.
      RE15469-LCG-200122- Se controla presupuesto actual y no por fecha o aprobado.
    }
END.*/
}








Codeunit 7207356 "Jobs Changes Log"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      JobsChangesLog : Record 7207445;
      SEPARADOR : TextConst ESP='_';

    PROCEDURE AddCostDatabase(Job : Record 167;CostDatabase : Record 7207271;p1 : Boolean;p2 : Boolean;p3 : Boolean;p4 : Boolean;p5 : Boolean);
    BEGIN
      JobsChangesLog.INIT;
      IF (Job."Original Quote Code" = '') THEN
        JobsChangesLog.Job := Job."No."
      ELSE BEGIN
        JobsChangesLog.Job := Job."Original Quote Code";
        JobsChangesLog.Version := Job."No.";
      END;

      CASE CostDatabase."Type JU" OF
        CostDatabase."Type JU"::Direct :
          BEGIN
            JobsChangesLog."Operation Code" := 'CPD';
            JobsChangesLog.Description := 'Carga preciario directos: ';
          END;
        CostDatabase."Type JU"::Indirect :
          BEGIN
            JobsChangesLog."Operation Code" := 'CPI';
            JobsChangesLog.Description := 'Carga preciario indirectos: ';
          END;
        CostDatabase."Type JU"::Booth :
          BEGIN
            JobsChangesLog."Operation Code" := 'CPA';
            JobsChangesLog.Description := 'Carga preciario mixto: ';
          END;

      END;
      JobsChangesLog.Description += CostDatabase.Code + ' [';
      IF (p1) THEN
        JobsChangesLog.Description +='S,'
      ELSE
        JobsChangesLog.Description += 'N,';

      IF (p2) THEN
        JobsChangesLog.Description +='S,'
      ELSE
        JobsChangesLog.Description += 'N,';

      IF (p3) THEN
        JobsChangesLog.Description +='S,'
      ELSE
        JobsChangesLog.Description += 'N,';

      IF (p4) THEN
        JobsChangesLog.Description +='S,'
      ELSE
        JobsChangesLog.Description += 'N,';

      IF (p5) THEN
        JobsChangesLog.Description +='S]'
      ELSE
        JobsChangesLog.Description += 'N]';

      JobsChangesLog."Parameter 1" := CostDatabase.Code;
      IF (p1) THEN
        JobsChangesLog."Parameter 2" :='S'
      ELSE
        JobsChangesLog."Parameter 2" := 'N';

      JobsChangesLog.INSERT(TRUE);
    END;

    /* /*BEGIN
END.*/
}








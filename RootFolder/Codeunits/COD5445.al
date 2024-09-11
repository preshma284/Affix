Codeunit 50902 "Graph Delta Sync 1"
{
  
  
    trigger OnRun()
VAR
            GraphSyncRunner : Codeunit 50906;
          BEGIN
            GraphSyncRunner.RunDeltaSync
          END;

    /* /*BEGIN
END.*/
}








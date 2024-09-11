Codeunit 7207302 "Change Job Level"
{
  
  
    TableNo=167;
    trigger OnRun()
VAR
            LModifyJobLevel : Page 7207383;
            LJob : Record 167;
          BEGIN
            CLEAR(LModifyJobLevel);
            LJob.FILTERGROUP(2);
            LJob.SETRANGE("No.",rec."No.");
            LJob.FILTERGROUP(0);
            LModifyJobLevel.SETTABLEVIEW(LJob);
            LModifyJobLevel.RUNMODAL;
          END;

    /* /*BEGIN
END.*/
}








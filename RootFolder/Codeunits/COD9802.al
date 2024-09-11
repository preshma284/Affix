Codeunit 51290 "Logon Management 1"
{
  
  
    SingleInstance=true;
    trigger OnRun()
BEGIN
          END;
    VAR
      LogonInProgress : Boolean;

    //[External]
    PROCEDURE IsLogonInProgress() : Boolean;
    BEGIN
      EXIT(LogonInProgress);
    END;

    //[External]
    PROCEDURE SetLogonInProgress(Value : Boolean);
    BEGIN
      LogonInProgress := Value;
    END;

    /* /*BEGIN
END.*/
}








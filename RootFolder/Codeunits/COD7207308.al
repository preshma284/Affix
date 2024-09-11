Codeunit 7207308 "Record Activation (y/n)"
{
  
  
    TableNo=7207367;
    trigger OnRun()
BEGIN
            ActivationHeader.COPY(Rec);
            Code_;
            Rec := ActivationHeader;
          END;
    VAR
      ActivationHeader : Record 7207367;
      RecordActivation : Codeunit 7207307;
      Selection : Integer;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el documento %1?';

    LOCAL PROCEDURE Code_();
    BEGIN
      WITH ActivationHeader DO BEGIN
        IF NOT CONFIRM(Text001,FALSE) THEN
          EXIT;
        RecordActivation.RUN(ActivationHeader);
      END;
    END;

    /* /*BEGIN
END.*/
}








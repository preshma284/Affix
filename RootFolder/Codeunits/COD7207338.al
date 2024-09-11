Codeunit 7207338 "RecpPr.-Post Receipt(Yes/No)"
{
  
  
    TableNo=7207411;
    trigger OnRun()
BEGIN
            LineReceptionJob.COPY(Rec);
            Code;
          END;
    VAR
      LineReceptionJob : Record 7207411;
      Text000 : TextConst ENU='Do you want to post the receipt?',ESP='�Confirma que desea registrar la recepci�n?';
      RecpJobPostReceipt : Codeunit 7207339;

    LOCAL PROCEDURE Code();
    BEGIN
      WITH LineReceptionJob DO BEGIN
        IF FIND THEN
          IF NOT CONFIRM(Text000,FALSE,"Recept. Document No.") THEN // VG
            EXIT;
        RecpJobPostReceipt.RUN(LineReceptionJob);
      END;
    END;

    /* /*BEGIN
END.*/
}








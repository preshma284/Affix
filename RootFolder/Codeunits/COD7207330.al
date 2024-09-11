Codeunit 7207330 "Close Record"
{
  
  
    TableNo=7207393;
    trigger OnRun()
BEGIN
            IF rec.Finished THEN BEGIN
              IF CONFIRM(STRSUBSTNO(Text0001,rec."No."),FALSE) THEN BEGIN
                rec.Finished := FALSE;
                rec."Finish Record Date" := 0D;
                rec.MODIFY;
              END;
            END ELSE BEGIN
              IF CONFIRM(STRSUBSTNO(Text0002,rec."No."),FALSE) THEN BEGIN
                rec.Finished := TRUE;
                rec."Finish Record Date" := WORKDATE;
                rec.MODIFY;
              END;
            END;
          END;
    VAR
      Text0001 : TextConst ENU='The Record %1 is already finished, Do you want to reopen it?',ESP='El Expediente %1 ya esta finalizado, �Desea volver abrirlo?';
      Text0002 : TextConst ENU='You are going to finish the record %1, Are you sure?',ESP='�Esta seguro que desea finalizar el Expediente %1?';

    /* /*BEGIN
END.*/
}








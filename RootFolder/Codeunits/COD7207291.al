Codeunit 7207291 "Post Reestimation (y/n)"
{
  
  
    TableNo=7207315;
    trigger OnRun()
BEGIN
            ReestimationHeader.COPY(Rec);
            Code;
            Rec := ReestimationHeader;
          END;
    VAR
      text002 : TextConst ENU='Are you sure you want to update the reestimated budget for the project?',ESP='"�Confirma que desea actualizar ppto. reestimado para el proyecto %1?   "';
      ReestimationHeader : Record 7207315;

    LOCAL PROCEDURE Code();
    VAR
      Postreestimation : Codeunit 7207290;
    BEGIN
      WITH ReestimationHeader DO BEGIN
        IF NOT CONFIRM(
          text002,FALSE,ReestimationHeader."Job No.")
         THEN EXIT;
        Postreestimation.RUN(ReestimationHeader);
      END;
    END;

    /* /*BEGIN
END.*/
}








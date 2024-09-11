Codeunit 7207275 "Post Measurement (Yes/No)"
{
  
  
    TableNo=7207336;
    trigger OnRun()
BEGIN
            MeasurementHeader.COPY(Rec);
            Code;
            Rec := MeasurementHeader;
          END;
    VAR
      MeasurementHeader : Record 7207336;
      Selection : Integer;
      boolMeasure : Boolean;
      boolMeasureCertif : Boolean;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar la %1?';
      Text002 : TextConst ENU='&Post. Measurement,Post Measurement and &Certificacion',ESP='&Reg. medici�n,Reg. medici�n y &certificaci�n';
      PostMeasurements : Codeunit 7207274;

    LOCAL PROCEDURE Code();
    BEGIN
      boolMeasure := FALSE;
      boolMeasureCertif := FALSE;

      WITH MeasurementHeader DO BEGIN
        //JAV 01/08/19: - Si es una medici�n de cancelaci�n solo debe registrarse la misma, no la certificaci�n. Adem�s esta parte estaba mal pues solo entramos desde una medici�n, se arregla
        IF (MeasurementHeader."Cancel No." = '') THEN BEGIN
          Selection := STRMENU(Text002,1);
          boolMeasure := Selection IN [1];
          boolMeasureCertif := Selection IN [2];
        END ELSE BEGIN
          boolMeasure := CONFIRM(Text001,FALSE,"Document Type");
        END;

        //JAV 15/10/19: - Se unifican las dos funciones de registro en una con un par�metro de certificaci�n si o no
        IF boolMeasure THEN
          PostMeasurements.PostMeasurement(MeasurementHeader, FALSE);
        IF boolMeasureCertif THEN
          PostMeasurements.PostMeasurement(MeasurementHeader, TRUE);
      END;
    END;

    /*BEGIN
/*{
      JAV 01/08/19: - Si es una medici�n de cancelaci�n solo debe registrarse la misma, no la certificaci�n
      JAV 15/10/19: - Se unifican las dos funciones de registro en una con un par�metro de certificaci�n si o no
    }
END.*/
}








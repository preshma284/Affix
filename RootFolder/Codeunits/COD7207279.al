Codeunit 7207279 "Post Certification (y/n)"
{
  
  
    TableNo=7207336;
    trigger OnRun()
BEGIN
            MeasurementHeader.COPY(Rec);
            Code;
            Rec := MeasurementHeader;
          END;
    VAR
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el/la %1?';
      Text002 : TextConst ENU='&Post certification,Post certification and &Invoice',ESP='&Reg. certificaci�n';
      MeasurementHeader : Record 7207336;
      PostCertification : Codeunit 7207278;
      Text003 : TextConst ESP='&Reg. certificaci�n,Reg. certificaci�n y &facturar';

    LOCAL PROCEDURE Code();
    VAR
      Selection : Integer;
      RegCert : Boolean;
      RegCertInv : Boolean;
    BEGIN

      IF MeasurementHeader."Document Type" = MeasurementHeader."Document Type"::Certification THEN BEGIN
        Selection := STRMENU(Text003,1);
        IF Selection = 0 THEN
          EXIT;
        RegCert := Selection IN [1];
        RegCertInv := Selection IN [2];
      END ELSE BEGIN
        IF NOT CONFIRM(Text001, FALSE, MeasurementHeader."Document Type") THEN
          EXIT;
      END;

      IF RegCert THEN
        PostCertification.PostCertification(MeasurementHeader, FALSE);
      IF RegCertInv THEN
        PostCertification.PostCertification(MeasurementHeader, TRUE);
    END;

    /*BEGIN
/*{
      GAP028 JDC 23/07/19 - Modified function "Code"
    }
END.*/
}








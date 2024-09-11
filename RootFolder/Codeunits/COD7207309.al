Codeunit 7207309 "Register Usage (s/n)"
{
  
  
    TableNo=7207362;
    trigger OnRun()
BEGIN
            UsageHeader.COPY(Rec);
            Code;
            Rec := UsageHeader;
          END;
    VAR
      UsageHeader : Record 7207362;
      CURegisterUsage : Codeunit 7207310;
      Selection : Integer;
      OmitQuestion : Boolean;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el documento %1?';
      Text000 : TextConst ENU='Register Only,Registrer and generate delivery note',ESP='S�lo registrar,Registrar y generar albaranes';
      Text002 : TextConst ENU='Register Only,Registrer and worksheet draft',ESP='Solo registrar,Registrar y borrador parte de trabajo';
      Text003 : TextConst ENU='Worksheet Draft no.%1 has been created',ESP='Se ha creado el borrador de parte de trabajo n� %1';

    LOCAL PROCEDURE Code();
    VAR
      LOGeneratedDocument : Code[20];
    BEGIN
      WITH UsageHeader DO BEGIN
        CASE "Contract Type" OF
          "Contract Type"::Vendor: BEGIN
            IF NOT OmitQuestion THEN BEGIN
              Selection := STRMENU(Text000,2);
            END;
            IF Selection = 0 THEN
              EXIT;
            IF Selection = 1 THEN
              CURegisterUsage.RUN(UsageHeader);
            IF Selection = 2 THEN BEGIN
              CURegisterUsage.CreatePurchaseOrder(UsageHeader);
              CURegisterUsage.RUN(UsageHeader);
            END;
          END ELSE BEGIN
            IF NOT OmitQuestion THEN BEGIN
              Selection := STRMENU(Text002,2);
            END;
            IF Selection = 0 THEN
              EXIT;
            IF Selection = 1 THEN
              CURegisterUsage.RUN(UsageHeader);
            IF Selection = 2 THEN BEGIN
              CURegisterUsage.CreateWorksheet(UsageHeader,LOGeneratedDocument);
              CURegisterUsage.RUN(UsageHeader);
              IF NOT OmitQuestion THEN
                MESSAGE(Text003,LOGeneratedDocument);
            END;
          END;
        END;
      END;
    END;

    PROCEDURE Omit_Question(parOmitQuestion : Boolean;parSelection : Integer);
    BEGIN
      OmitQuestion := parOmitQuestion;
      Selection := parSelection;
    END;

    /*BEGIN
/*{
      Filtro por cliente para que solo haga parte en los que son contratos de cliente.
    }
END.*/
}








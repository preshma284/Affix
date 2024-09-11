Codeunit 7207297 "Transfers Between Jobs"
{
  
  
    TableNo=7207286;
    trigger OnRun()
BEGIN
            HeaderTransCostsInvoice.COPY(Rec);
            Code;
            Rec := HeaderTransCostsInvoice;
          END;
    VAR
      HeaderTransCostsInvoice : Record 7207286;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el documento %1?';
      RegisterChargesandDischarge : Codeunit 7207298;

    LOCAL PROCEDURE Code();
    BEGIN
      WITH HeaderTransCostsInvoice DO BEGIN
        IF NOT CONFIRM(Text001, FALSE, HeaderTransCostsInvoice."No.") THEN //JAV 28/10/19: - Se a�ade el documento que le faltaba en la pregunta
          EXIT;
        RegisterChargesandDischarge.RUN(HeaderTransCostsInvoice);
      END;
    END;

    /*BEGIN
/*{
      JAV 28/10/19: - Se cambia el name y caption para que sea mas significativo del contenido
                    - Se a�ade el documento que le faltaba en la pregunta
    }
END.*/
}








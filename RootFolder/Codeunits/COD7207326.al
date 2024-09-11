Codeunit 7207326 "Record Costsheet (s/n)"
{
  
  
    TableNo=7207433;
    trigger OnRun()
BEGIN
            CostsheetHeader.COPY(Rec);
            Code;
            Rec := CostsheetHeader;
          END;
    VAR
      CostsheetHeader : Record 7207433;
      CURecordCostsheet : Codeunit 7207327;
      Selection : Integer;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el documento %1?';

    LOCAL PROCEDURE Code();
    BEGIN
      WITH CostsheetHeader DO BEGIN
        IF NOT CONFIRM(Text001,FALSE,"No.") THEN
          EXIT;
        CURecordCostsheet.RUN(CostsheetHeader);
      END;
    END;

    /* /*BEGIN
END.*/
}








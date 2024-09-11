Codeunit 7207277 "Register Shipment Output (s/n)"
{
  
  
    TableNo=7207308;
    trigger OnRun()
BEGIN
            OutputShipmentHeader.COPY(Rec);
            Code;
            Rec := OutputShipmentHeader;
          END;
    VAR
      OutputShipmentHeader : Record 7207308;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el documento?';
      PostPurchaseRcptOutput : Codeunit 7207276;

    LOCAL PROCEDURE Code();
    BEGIN
      WITH OutputShipmentHeader DO BEGIN
        IF NOT CONFIRM(Text001,FALSE) THEN
          EXIT;
        PostPurchaseRcptOutput.RUN(OutputShipmentHeader);
      END;
    END;

    /* /*BEGIN
END.*/
}








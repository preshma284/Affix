Codeunit 7207313 "Header Delive/Return Ele (s/n)"
{
  
  
    TableNo=7207356;
    trigger OnRun()
BEGIN
            HeaderDeliveryReturnElement.COPY(Rec);
            Code;
            Rec := HeaderDeliveryReturnElement;
          END;
    VAR
      HeaderDeliveryReturnElement : Record 7207356;
      Text001 : TextConst ENU='Do you want to post the %1?',ESP='�Confirma que desea registrar el documento %1?';
      RecordDeliveryReturnElement : Codeunit 7207312;

    LOCAL PROCEDURE Code();
    BEGIN
      WITH HeaderDeliveryReturnElement DO BEGIN
        IF NOT CONFIRM(Text001,FALSE,HeaderDeliveryReturnElement."No.") THEN
          EXIT;
       RecordDeliveryReturnElement.RUN(HeaderDeliveryReturnElement);
      END;
    END;

    /*BEGIN
/*{
      El Confirm no muestra el N� documento y solamente sale %1
    }
END.*/
}








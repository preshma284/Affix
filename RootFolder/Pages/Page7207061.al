page 7207061 "QB Change Status Order Serv"
{
CaptionML=ENU='Change Status Order Serv',ESP='Cambiar estado pedido servicio';
    SourceTable=7206966;
    PageType=StandardDialog;
    
  layout
{
area(content)
{
    field("NewStatus";NewStatus)
    {
        
                CaptionML=ENU='Status Service Order',ESP='Cambio estado ped. servicio';
    }

}
}
  trigger OnOpenPage()    BEGIN

                 SetStatus;
                 IF (rec.Status = rec.Status::Invoiced) OR
                    (rec.Status = rec.Status::Finished) THEN
                    ERROR(TEXT50000,rec.Status,rec."No.");
               END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN

                       IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
                         UpdateStatus;
                     END;



    var
      QBServiceOrderHeader : Record 7206966;
      TEXT50000 : TextConst ENU='Error, state %1 of service request %2 can not be changed.',ESP='"Error, no se puede cambiar el estado %1 del pedido de servicio %2. "';
      TEXT50001 : TextConst ENU='�Do you want to update the status of the service order?',ESP='�Desea actualizar el estado del pedido de servicio?';
      TEXT50002 : TextConst ENU='Error, operation canceled by the user.',ESP='Error, operaci�n cancelada por el usuario.';
      TEXT50003 : TextConst ENU='The service order status has been successfully modified to %1.',ESP='Se ha modificado correctamente el estado del pedido de servicio a %1.';
      NewStatus: Option "Pendiente","En proceso","En espera";

    LOCAL procedure UpdateStatus();
    begin

      if not CONFIRM(TEXT50001,TRUE) then
        ERROR(TEXT50002);

      QBServiceOrderHeader := Rec;

      CASE NewStatus OF
        NewStatus::"En espera"  : QBServiceOrderHeader.VALIDATE(Status,QBServiceOrderHeader.Status::"On Hold");
        NewStatus::"En proceso" : QBServiceOrderHeader.VALIDATE(Status,QBServiceOrderHeader.Status::"In Process");
        NewStatus::Pendiente    : QBServiceOrderHeader.VALIDATE(Status,QBServiceOrderHeader.Status::Pending);
      end;

      QBServiceOrderHeader.MODIFY;

      //MESSAGE(TEXT50003,QBServiceOrderHeader.Status);
    end;

    LOCAL procedure SetStatus();
    begin

      CASE rec.Status OF
        rec.Status::"On Hold"    : NewStatus := NewStatus::"En espera";
        rec.Status::"In Process" : NewStatus := NewStatus::"En proceso";
        rec.Status::Pending      : NewStatus := NewStatus::Pendiente;
      end;
    end;

    // begin//end
}








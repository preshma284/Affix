report 7207433 "QB Cambiar proyecto"
{
  
  
    CaptionML=ENU='Suggest Vendor Payments',ESP='Proponer Liquidaci¢n de efectos';
    ProcessingOnly=true;
    
  dataset
{

}
  requestpage
  {

    layout
{
area(content)
{
group("group864")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
group("group865")
{
        
                  CaptionML=ENU='Options',ESP='Datos del documento';

}
group("group870")
{
        
                  CaptionML=ENU='Options',ESP='Fecha de registro';
    field("varFechaRegistro";"varFechaRegistro")
    {
        
                  CaptionML=ENU='Posting Date',ESP='Fecha de registro';
                  ToolTipML=ENU='Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.',ESP='Especifica la fecha de registro de este proceso. La fecha de trabajo se introduce de forma predeterminada, pero es posible cambiarla.';
                  Editable=false ;
    }
    field("varProyectoNuevo";"varProyectoNuevo")
    {
        
                  CaptionML=ENU='Last Payment Date',ESP='Nuevo proyecto';
                  ToolTipML=ENU='Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.',ESP='Especifica la £ltima fecha de vencimiento que puede aparecer en los movimientos de proveedor que se van a incluir en el proceso. Solo se incluir n los movimientos cuya fecha de vencimiento sean iguales o anteriores a esta fecha. Si la fecha de vencimiento es anterior a la del sistema, se mostrar  una advertencia.';
                  ApplicationArea=Basic,Suite;
                  TableRelation=Job WHERE ("Card Type"=CONST("Proyecto operativo")) 

    ;
    }

}

}

}
}
  }
  labels
{
}
  
    var
//       Conf@7001111 :
      Conf: Record 7207278;
//       GenJnlLine@7001113 :
      GenJnlLine: Record 81;
//       Vendor@7001105 :
      Vendor: Record 23;
//       recLineas@7001116 :
      recLineas: Record 7206925;
//       BankAccount@7001102 :
      BankAccount: Record 270;
//       cuFuncionesPagos@7001114 :
      cuFuncionesPagos: Codeunit 7206922;
//       NextLineNo@7001181 :
      NextLineNo: Integer;
//       Text000@7001167 :
      Text000: TextConst ENU='Starting Document No. must contain a number.',ESP='No ha indicado fecha de registro';
//       NroRelacion@7001115 :
      NroRelacion: Integer;
//       nroLinea@7001112 :
      nroLinea: Integer;
//       "--- Opciones de la Page -------------------------------------------"@7001127 :
      "--- Opciones de la Page -------------------------------------------": Integer;
//       varFechaRegistro@7001132 :
      varFechaRegistro: Date;
//       varVendorLedgerEntry@7001103 :
      varVendorLedgerEntry: Record 25;
//       Text001@7001106 :
      Text001: TextConst ESP='No ha indicado nuevo proyecto';
//       Text002@7001110 :
      Text002: TextConst ESP='El nuevo proyecto no puede ser igual al anterior';
//       varProyectoNuevo@7001117 :
      varProyectoNuevo: Code[20];

    

trigger OnInitReport();    begin
                   varFechaRegistro := WORKDATE;
                 end;

trigger OnPreReport();    begin
                  if varFechaRegistro = 0D then
                    ERROR(Text000);

                  if varProyectoNuevo = '' then
                    ERROR(Text001);

                  if varProyectoNuevo = varVendorLedgerEntry."Global Dimension 1 Code" then
                    ERROR(Text002);

                  // Registrar diario con el cambio de fecha
                  cuFuncionesPagos.CambioProyecto(varVendorLedgerEntry, varFechaRegistro, varProyectoNuevo);
                end;



LOCAL procedure "-------------" ()
    begin
    end;

//     procedure SetDatos (parMov@1000 :
    procedure SetDatos (parMov: Record 25)
    begin
      varVendorLedgerEntry := parMov;
    end;

    /*begin
    end.
  */
  
}




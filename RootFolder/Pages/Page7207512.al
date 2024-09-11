page 7207512 "QB Electronic Payment Params"
{
CaptionML=ENU='QB Electronic Payment Parameters',ESP='Par metros de pagos electr¢nicos';
    PageType=Card;
    
  layout
{
area(content)
{
group("group59")
{
        
                CaptionML=ESP='Formato';
    field("opcReport";opcReport)
    {
        
                CaptionML=ESP='Formato';
                Enabled=enFormato;
                Style=StrongAccent;
                StyleExpr=TRUE;
                
                          ;trigger OnValidate()    BEGIN
                             EnableFields;
                           END;

trigger OnLookup(var Text: Text): Boolean    BEGIN
                           opcReport := STRMENU(txtMenu, opcReport, 'Seleccione formato');
                           EnableFields;
                         END;


    }
    field("GenerateElectronicsPayments.GetNameTxt(opcReport)";GenerateElectronicsPayments.GetNameTxt(opcReport))
    {
        
                CaptionML=ESP='Nombre';
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }

}
group("group62")
{
        
                CaptionML=ESP='Opciones formato Est ndard';
                Visible=en01;
    field("opcType_TC";opcType_TC)
    {
        
                CaptionML=ESP='Tipo';
                Enabled=en01 ;
    }
    field("opc52PaymentType";opc52PaymentType)
    {
        
                CaptionML=ESP='Tipo de pago';
                Enabled=en01 ;
    }
    field("opcDeliveryDate";opcDeliveryDate)
    {
        
                CaptionML=ESP='Fecha de proceso';
                Enabled=en01 ;
    }

}
group("group66")
{
        
                CaptionML=ESP='Opciones Bankinter';
                Visible=en03;
    field("opcPaymentType";opcPaymentType)
    {
        
                CaptionML=ESP='Tipo de Pago';
                Enabled=en03 ;
    }

}
group("group68")
{
        
                CaptionML=ESP='Opciones Cheque/Pagare Sabadell';
                Visible=en02;
    field("opc53TipoDoc";opc53TipoDoc)
    {
        
                CaptionML=ESP='Tipo de Documento';
                Enabled=en02 ;
    }
    field("opc53FormaEnvio";opc53FormaEnvio)
    {
        
                CaptionML=ESP='Formato de env¡o';
                Enabled=en02 ;
    }
    field("opc53TipoEnvio";opc53TipoEnvio)
    {
        
                CaptionML=ESP='Tipo de env¡o';
                Enabled=en02 ;
    }
    field("opc53IdiomaDoc";opc53IdiomaDoc)
    {
        
                CaptionML=ESP='Idioma del documento';
                Enabled=en02 ;
    }
    field("opc53Barrado";opc53Barrado)
    {
        
                CaptionML=ESP='Barrado';
                Enabled=en02 ;
    }

}
group("group74")
{
        
                CaptionML=ESP='Opciones Bankia 2';
                Visible=en05;
    field("O55";opcDeliveryDate)
    {
        
                CaptionML=ESP='Fecha de proceso';
                Enabled=en05 ;
    }

}
group("group76")
{
        
                CaptionML=ESP='Opciones Deutsche Bank';
                Visible=en09;
    field("O59";opcPaymentType)
    {
        
                CaptionML=ESP='Tipo de pago';
                Enabled=en09 

  ;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 opcDeliveryDate := TODAY;
                 txtMenu := GenerateElectronicsPayments.GetMenuTxt;
               END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF (CloseAction = ACTION::LookupOK) AND (NOT GenerateElectronicsPayments.ValidateNumber(opcReport)) THEN
                         ERROR('Debe seleccionar un formato');
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           EnableFields;
                         END;



    var
      QBReportSelections : Record 7206901;
      GenerateElectronicsPayments : Codeunit 7206908;
      txtMenu : Text;
      opcReport : Integer;
      opcPaymentType: Option "56 - Transferencia","57 - Cheque";
      opcDeliveryDate : Date;
      opcType_TC: Option "56 - Transferencia","57 - Cheque";
      opc52PaymentType: Option "56 - Transferencia","57 - Cheque";
      opc53TipoDoc: Option "56 - Transferencia","57 - Cheque";
      opc53FormaEnvio: Option "56 - Transferencia","57 - Cheque";
      opc53TipoEnvio: Option "56 - Transferencia","57 - Cheque";
      opc53IdiomaDoc: Option "56 - Transferencia","57 - Cheque";
      opc53Barrado : Boolean;
      enFormato : Boolean;
      en01 : Boolean;
      en02 : Boolean;
      en03 : Boolean ;
      en05 : Boolean;
      en09 : Boolean;

    LOCAL procedure EnableFields();
    begin
      en01 := (opcReport = 1);
      en02 := (opcReport = 2);
      en03 := (opcReport = 3);
      en05 := (opcReport = 5);
      en09 := (opcReport = 9);
    end;

    procedure SetOptions(Informe : Integer);
    begin
      opcReport := Informe;
      enFormato := (opcReport = 0);
      if (opcReport = 0) then
        opcReport := 1;
    end;

    procedure GetOptions(var Informe : Integer;var Opciones : ARRAY [5] OF Text);
    begin
      if (not GenerateElectronicsPayments.ValidateNumber(opcReport)) then
        ERROR('Debe seleccionar un formato');

      Informe := opcReport;
      CLEAR(Opciones);
      CASE opcReport OF
        1:
          begin
            Opciones[1] := FORMAT(opcDeliveryDate);                                           //Fecha de proceso
            Opciones[2] := COPYSTR(FORMAT(opc52PaymentType), 1, 1);                           //Tipo: 1-Estandar, 2-Pronto Pago, 3-Otros
            Opciones[3] := COPYSTR(FORMAT(opcType_TC), 1, 1);                                 //Tipo de Pago: T-Transferencia, C-Cheque
          end;
        2:
          begin
            Opciones[1] := COPYSTR(FORMAT(opc53TipoDoc), 1, 2);                               //'60': Cheque bancario, '70': Cheque Cuenta Corriente, '71': Pagar²
            Opciones[2] := COPYSTR(FORMAT(opc53FormaEnvio), 1, 1);                            //'B': entrega al beneficiario, 'O': distribuci¢n a trav‚s de la oficina
            Opciones[3] := COPYSTR(FORMAT(opc53TipoEnvio), 1, 1);                             //' ': Env¡o por BS Online, 'U': Env¡o por Infobanc
            Opciones[4] := COPYSTR(FORMAT(opc53IdiomaDoc), 1, 2);                             //'01': Castellano,'08': Catal n
            Opciones[5] := COPYSTR(FORMAT(opc53Barrado), 1, 1);                               //'S', 'N'
          end;
        3:
          begin
            Opciones[2] := COPYSTR(FORMAT(opcPaymentType), 1, 2);                             //Tipo de Pago: 57 - Cheque, 56 - Transferencia
          end;
        5:
          begin
            Opciones[1] := FORMAT(opcDeliveryDate);                                           //Fecha de proceso
          end;
        9:
          begin
            Opciones[2] := COPYSTR(FORMAT(opcPaymentType), 1, 2);                             //Tipo de Pago: 57 - Cheque, 56 - Transferencia
          end;
      end;
    end;

    // begin
    /*{
      JAV 15/09/21: - QB 1.09.17 Nueva pantalla para establecer los par metros de los formatos electr¢nicos de confirming
    }*///end
}








page 7207675 "QB Credit Relations Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Credit Relations Setup',ESP='Configuraci�n relaciones de pago';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7207335;
    
  layout
{
area(content)
{
group("group102")
{
        
                CaptionML=ESP='Relaciones de pagos';
    field("RP Use Payment Relations";rec."RP Use Payment Relations")
    {
        
    }
    field("RP Gen.Journal Template Name";rec."RP Gen.Journal Template Name")
    {
        
    }
    field("RP Gen.Journal Batch Name";rec."RP Gen.Journal Batch Name")
    {
        
    }
    field("RP Codigo Origen";rec."RP Codigo Origen")
    {
        
    }
    field("RP Fichero de Pagos";rec."RP Fichero de Pagos")
    {
        
    }
    field("RP Informe Pagares";rec."RP Informe Pagares")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }
    field("RP F.Pago Pagares por emitir";rec."RP F.Pago Pagares por emitir")
    {
        
    }
    field("RP F.Pago Tranf. por emitir";rec."RP F.Pago Tranf. por emitir")
    {
        
    }
    field("RP Serie para Pago Anticipado";rec."RP Serie para Pago Anticipado")
    {
        
    }
    field("RP Cuenta para Pago anticipado";rec."RP Cuenta para Pago anticipado")
    {
        
    }
    field("RP Forma Pago Anulacion";rec."RP Forma Pago Anulacion")
    {
        
    }

}
group("group114")
{
        
                CaptionML=ESP='Textos de asientos';
group("group115")
{
        
                CaptionML=ESP='Para registrar el pagar�';
    field("RP Texto para Factura";rec."RP Texto para Factura")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }
    field("RP Texto para Efecto";rec."RP Texto para Efecto")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }

}
group("group118")
{
        
                CaptionML=ESP='Para registrar Orden de Pago';
    field("RP Texto para Agrupar Fra";rec."RP Texto para Agrupar Fra")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }
    field("RP Texto para Efecto Agrupado";rec."RP Texto para Efecto Agrupado")
    {
        
    }

}
group("group121")
{
        
                CaptionML=ESP='Para liquidar';
    field("RP Texto para Aplicar Abono";rec."RP Texto para Aplicar Abono")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }
    field("RP Texto para Liquidar Efecto";rec."RP Texto para Liquidar Efecto")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }

}
group("group124")
{
        
                CaptionML=ESP='Para cambiar Vtos.';
    field("RP Texto para Cancelar Vto.";rec."RP Texto para Cancelar Vto.")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }
    field("RP Texto para Nuevo Vto.";rec."RP Texto para Nuevo Vto.")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor"';
    }

}
group("group127")
{
        
                CaptionML=ESP='Para cancelar un pagar� emitido';
    field("RP Texto para Cancelar Pagaré";rec."RP Texto para Cancelar Pagaré")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }
    field("RP Texto para Nueva Fra.";rec."RP Texto para Nueva Fra.")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }

}
group("group130")
{
        
                CaptionML=ESP='Para anticipos sin factura';
    field("RP Texto para Pago Anticipado";rec."RP Texto para Pago Anticipado")
    {
        
                ToolTipML=ESP='"Puede usar %1 N� efecto, %2 N� Fac.Proveedor, %3 Nombre Proveedor "';
    }

}

}

}
}
  trigger OnOpenPage()    BEGIN
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;
               END;



    var
      FunctionQB : Codeunit 7207272;
      Text00 : TextConst ENU='This option is not active',ESP='Esta opci�n no est� activa';

    /*begin
    end.
  
*/
}









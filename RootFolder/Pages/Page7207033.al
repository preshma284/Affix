page 7207033 "QB Job Prepayment Setup"
{
  ApplicationArea=All;

SourceTable=7207278;
    
  layout
{
area(content)
{
group("group5")
{
        
                CaptionML=ESP='Configuraci�n';
group("group6")
{
        
                CaptionML=ESP='Uso';
    field("Use Customer Prepayment";rec."Use Customer Prepayment")
    {
        
                ToolTipML=ESP='Indica si se van a usar los anticipos de clientes en los proyectos';
    }
    field("Use Vendor Prepayment";rec."Use Vendor Prepayment")
    {
        
                ToolTipML=ESP='Indica si se van a usar los anticipos de proveedores en los proyectos';
    }

}
group("group9")
{
        
                CaptionML=ESP='Generaci�n';
    field("Prepayment Document Type";rec."Prepayment Document Type")
    {
        
                ToolTipML=ESP='Indica el documento por defecto que se desea generar para registrar los anticipos, si tiene establecido SIEMPRE no podr� cambiarse, si no lo tiene establecido se podr� cambiar en cada documento.';
    }
    field("Prepayment Posting Group 1";rec."Prepayment Posting Group 1")
    {
        
                ToolTipML=ESP='Que "Grupo contable de producto" se usar� para obtener la cuenta de anticipo para clientes o proveedores cuando es con efecto';
    }
    field("Prepayment Posting Group 2";rec."Prepayment Posting Group 2")
    {
        
                ToolTipML=ESP='Que "Grupo contable de producto" se usar� para obtener la cuenta de anticipo para clientes o proveedores cuando es con Factura';
    }
    field("Prepayment Payment Terms";rec."Prepayment Payment Terms")
    {
        
                ToolTipML=ESP='Indica que T�rminos de pago se usar�n por defecto para los anticipos. Si no se informa se usar� la indicada en el cliente o proveedor.';
    }
    field("Prepayment Payment Method";rec."Prepayment Payment Method")
    {
        
                ToolTipML=ESP='Indica la forma de pago con la que se van a generar los anticipos por defecto.  Si no se informa se usar� la indicada en el cliente o proveedor.';
    }

}
group("group15")
{
        
                CaptionML=ESP='Contadores';
    field("Serie For Prepayment Bills";rec."Serie For Prepayment Bills")
    {
        
                ToolTipML=ESP='Indica la serie con la que se van a generar los documentos de tipo efecto para anticipos de Proyectos de clientes y proveedores';
    }
    field("SalesPrepmtNos";"SalesPrepmtNos")
    {
        
                CaptionML=ESP='N� Serie Factura Ant. Venta';
                TableRelation="No. Series";
                
                            ;trigger OnValidate()    BEGIN
                             SalesReceivablesSetup.GET;
                             SalesReceivablesSetup."Posted Prepmt. Inv. Nos." := SalesPrepmtNos;
                             SalesReceivablesSetup.MODIFY;
                           END;


    }
    field("PurchPrepmtNos";"PurchPrepmtNos")
    {
        
                CaptionML=ESP='N� Serie Factura Ant. Compra';
                TableRelation="No. Series";
                
                            

  ;trigger OnValidate()    BEGIN
                             PurchasesPayablesSetup.GET;
                             PurchasesPayablesSetup."Posted Prepmt. Inv. Nos." := PurchPrepmtNos;
                             PurchasesPayablesSetup.MODIFY;
                           END;


    }

}

}

}
}actions
{
area(Processing)
{

group("group2")
{
        CaptionML=ESP='Configuraci�n';
                      // ActionContainerType=NewDocumentItems ;
    action("action1")
    {
        CaptionML=ESP='Gr.Reg.General';
                      RunObject=Page 314;
                      Image=ItemGroup 
    ;
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       //Anticipos
                       SalesReceivablesSetup.GET;
                       SalesPrepmtNos := SalesReceivablesSetup."Posted Prepmt. Inv. Nos.";
                       PurchasesPayablesSetup.GET;
                       PurchPrepmtNos := PurchasesPayablesSetup."Posted Prepmt. Inv. Nos.";
                     END;



    var
      SalesReceivablesSetup : Record 311;
      PurchasesPayablesSetup : Record 312;
      SalesPrepmtNos : Code

[20];
      PurchPrepmtNos : Code[20];/*

    begin
    {
      JAV 10/06/22: - QB 1.10.49 Se a�ade el campo 84 "Prepayment By Document" que indica si es obligatorio manejar los anticipos por cada documento individual, o se pueden usar por importes totales
    }
    end.*/
  

}









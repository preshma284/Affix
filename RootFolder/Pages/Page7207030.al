page 7207030 "QB Job Prepayment Types"
{
  ApplicationArea=All;

CaptionML=ENU='Prepayment Type',ESP='Tipos de Anticipo';
    SourceTable=7206993;
  layout
{
area(content)
{
repeater("General")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
                ToolTipML=ESP='Que tipo de documento es el relacionado con el anticipo.';
    }
    field("Document Mandatory";rec."Document Mandatory")
    {
        
                ToolTipML=ESP='Si se marca indica que es obligatrorio informar del n£mero del documento';
    }
    field("Description for Invoices";rec."Description for Invoices")
    {
        
                ToolTipML=ESP='Descripci¢n para usar al generar facturas, se pueden usar %1 para el N§ de documento, %2 para base+porcentaje+importe, %3 para el nombre del proyecto, %4 para el nombre del cliente o proveedor';
    }
    field("Description for Bills";rec."Description for Bills")
    {
        
                ToolTipML=ESP='Descripci¢n para usar al generar efectos, se pueden usar %1 para el N§ de documento, %2 para base+porcentaje+importe, %3 para el nombre del proyecto, %4 para el nombre del cliente o proveedor';
    }
    field("Document to Generate";rec."Document to Generate")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}









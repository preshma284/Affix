table 7206993 "QBU Prepayment Types"
{
  
  
    CaptionML=ENU='Prepaiment Types',ESP='Tipos de Anticipo';
    LookupPageID="QB Job Prepayment Types";
    DrillDownPageID="QB Job Prepayment Types";
  
  fields
{
    field(1;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';


    }
    field(2;"Description for Invoices";Text[100])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n en Facturas';
                                                   Description='QB 1.10.28 JAV 30/03/22 [TT: Descripci¢n para usar al generar facturas, se pueden usar %1 para el N§ de documento, %2 para base+porcentaje+importe, %3 para el nombre del proyecto, %4 para el nombre del cliente o proveedor';


    }
    field(3;"Description for Bills";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n en Efectos';
                                                   Description='QB 1.10.28 JAV 30/03/22 [TT: Descripci¢n para usar al generar facturas, se pueden usar %1 para el N§ de documento, %2 para base+porcentaje+importe, %3 para el nombre del proyecto, %4 para el nombre del cliente o proveedor';


    }
    field(10;"Document Type";Option)
    {
        OptionMembers=" ","Order","Invoice";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de Documento';
                                                   OptionCaptionML=ENU='" ,Order,Invoice"',ESP='" ,Pedido,Factura"';
                                                   
                                                   Description='QB 1.10.33 JAV 08/04/22 [TT: Que tipo de documento es el relacionado con el anticipo.';


    }
    field(11;"Document Mandatory";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Documento Obligatorio';
                                                   Description='QB 1.10.33 JAV 08/04/22 [TT: Si se marca indica que es obligatrorio informar del n£mero del documento';


    }
    field(12;"Document to Generate";Option)
    {
        OptionMembers=" ","Invoice","Bill";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document to Generate',ESP='Documento a Generar';
                                                   OptionCaptionML=ENU='" ,Invoice,Bill"',ESP='" ,Factura,Efecto"';
                                                   
                                                   Description='QB 1.10.35 JAV 11/04/22 [TT: Si se informa el tipo de documento a generar este no se podr  cambiar en el Anticipo' ;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}








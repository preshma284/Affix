table 7174350 "QBU DP Setup"
{
  
  
    CaptionML=ENU='Non Deductible VAT Setup',ESP='Configuraci¢n IVA no deducible';
  
  fields
{
    field(1;"Primary Key";Code[10])
    {
        CaptionML=ENU='Primary Key',ESP='Clave primaria';


    }
    field(10;"DP Use Prorrata";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Activar Prorrata';
                                                   Description='DP 1.00.04 JAV 21/06/22: [TT] Indica si se desea utilizar el IVA de Prorrata en las facturas de compra';


    }
    field(11;"DP Dimension Associated";Code[20])
    {
        TableRelation="Dimension";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Dimension Associated',ESP='Dimensi¢n asociada';
                                                   Description='DP 1.00.00 JAV 21/06/22: [TT] Indica que dimensi¢n se desea utilizar para indicar las actividades deducibles y las no deducibles';


    }
    field(20;"DP Use Non Deductible";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Use non Deductible VAT',ESP='Usar IVA no deducible';
                                                   Description='DP 1.00.04 JAV 14/07/22: [TT] Indica si se desea utilizar IVA no deducible en las facturas de compra' ;


    }
}
  keys
{
    key(key1;"Primary Key")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 21/06/22: - DP 1.00.00 Se a¤ade nueva tabla para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
      JAV 14/07/22: - DP 1.00.04 Se cambia el caption del campo 10 y se a¤ade el 20 para el IVA no deducible general
    }
    end.
  */
}








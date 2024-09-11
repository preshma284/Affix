tableextension 50156 "MyExtension50156" extends "Source Code Setup"
{
  
  
    CaptionML=ENU='Source Code Setup',ESP='Configuraci¢n c¢digos origen';
  
  fields
{
    field(7207271;"Output Shipment to Job";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Output Shipment to Job',ESP='Albaran salida a proyecto';
                                                   Description='QB 1.00 - QB2412';


    }
    field(7207272;"QW Withholding Releasing";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Withholding Releasing',ESP='Liberacion de retenciones';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207273;"Comparative Quote";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Comparative Quote',ESP='Comparativo de ofertas';
                                                   Description='QB 1.00 - QB2515';


    }
    field(7207274;"WorkSheet";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Partes de trabajo',ESP='Partes de trabajo';
                                                   Description='QB 1.00 - QB2713';


    }
    field(7207275;"WIP";Code[10])
    {
        TableRelation="Source Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Obra en Curso';
                                                   Description='QB 1.07.14';


    }
    field(7207276;"Purchase Needs Journal";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Purchase Needs Journal',ESP='Diario de Neces. Compra';
                                                   Description='QB 1.00 - QB2515';


    }
    field(7207277;"Rent Delivery";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Rent Delivery',ESP='Entregas de alquiler';
                                                   Description='QB 1.00 - QB2413';


    }
    field(7207278;"Rent Contract";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ESP='Contrato de alquiler';
                                                   Description='QB 1.00 - QB2413';


    }
    field(7207279;"Rent Return";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Rent Return',ESP='Devoluci¢n de alquiler';
                                                   Description='QB 1.00 - QB2413';


    }
    field(7207280;"Rent Journal";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Rent Journal',ESP='Diario de alquiler';
                                                   Description='QB 1.00 - QB2413';


    }
    field(7207281;"Prod. Measuring";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Mediciones de produccion',ESP='Mediciones de producci¢n';
                                                   Description='QB 1.00 - QB2812';


    }
    field(7207282;"Expense Notes";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Expense Notes',ESP='Notas de gasto';
                                                   Description='QB 1.00 - QB2211';


    }
    field(7207283;"Charges and Discharge";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Charges and Discharge',ESP='Traspasos entre Proyectos';
                                                   Description='QB 1.00 - QB2414';


    }
    field(7207284;"Measurements and Certif.";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Measurements and Certif.',ESP='Mediciones y certificaciones';
                                                   Description='QB 1.00 - QB2812';


    }
    field(7207285;"JV Incorporation";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Integracion de UTES',ESP='Integraci¢n de UTES';
                                                   Description='QB 1.00';


    }
    field(7207286;"Reestimation";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Reestimation',ESP='Reestimaci¢n';
                                                   Description='QB 1.00 - QB2418';


    }
    field(7207287;"Stock Regularization";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Stock Regularization',ESP='Regularizaci¢n de stock';
                                                   Description='QB 1.00 - QB2412';


    }
    field(7207288;"Usage Document";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Usage Document',ESP='Documento de utilizaci¢n';
                                                   Description='QB 1.00';


    }
    field(7207289;"Elements Activation";Code[10])
    {
        TableRelation="Source Code";
                                                   CaptionML=ENU='Elements Activation',ESP='Activaci¢n elementos';
                                                   Description='QB 1.00 - QB25111';


    }
    field(7207290;"QB Prepayments";Code[10])
    {
        TableRelation="Source Code";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Anticipos de Proyecto';
                                                   Description='QB 1.08.43' ;


    }
}
  keys
{
   // key(key1;"Primary Key")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  

    /*begin
    {
      Q13154 JDC 05/05/21 - Added field 7207290 "QB Prepayments"
    }
    end.
  */
}





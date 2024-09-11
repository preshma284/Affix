table 7206997 "QBU Activable Expenses Setup"
{
  
  
  ;
  fields
{
    field(1;"Primary Key";Code[10])
    {
        CaptionML=ENU='Primary Key',ESP='Clave primaria';


    }
    field(10;"Activable QPR";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Capitalizable expenses',ESP='Se usan Gastos Activables en Presupuestos';
                                                   Description='QB 1.12.00 JAV 06/04/22 [TT] Indica si se permite en los proyectos de Presupuesto generar los movimientos de activaci¢n de los gastos';


    }
    field(11;"Activable RE";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Se usan Gastos Activables en Real Estate';
                                                   Description='QB 1.12.00 JAV 06/04/22 [TT] Indica si se permite en los proyectos de Real Estate generar los movimientos de activaci¢n de los gastos';


    }
    field(20;"Activable First Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Primera fecha de activaci¢n';
                                                   Description='QB 1.12.00 JAV 05/10/22 [TT] Indica la primera fecha en que se van a crear activaciones, si no se indica ser  el mes actual';


    }
    field(21;"Activable Detailed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Asiento Detallado';
                                                   Description='QB 1.12.00 JAV 05/10/22 [TT] Indica que el asiento se va a efectuar detallado, un movimiento por cada uno que active. Si no se agrupar n por cuenta, proyecto y partida';


    }
    field(22;"Serie for Activables Expenses";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ serie Gastos Activables';
                                                   Description='QB 1.10.35 JAV 11/04/22: [TT] N§ de serie que se usar  para numerar los registros de Gastos Activables';


    }
    field(30;"Journal Template";Code[10])
    {
        TableRelation="Gen. Journal Template";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Posting Book Integration JV',ESP='Diario';


    }
    field(31;"Journal Batch";Code[10])
    {
        TableRelation="Gen. Journal Batch"."Name" WHERE ("Journal Template Name"=FIELD("Journal Template"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Batch Rec. Integration JV',ESP='Secci¢n'; ;


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
    end.
  */
}








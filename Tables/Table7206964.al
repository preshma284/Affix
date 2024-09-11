table 7206964 "QBU Aux Measurement Det. Lines"
{
  
  
    CaptionML=ENU='Measure Lines Bill of Item',ESP='Descompuesto lineas medici¢n';
  
  fields
{
    field(2;"Document No.";Code[20])
    {
        CaptionML=ENU='Document No.',ESP='N§ documento';
                                                   Description='Key 2';


    }
    field(4;"Piecework Code";Code[20])
    {
        CaptionML=ENU='Piecework Code',ESP='N§ unidad de obra';


    }
    field(5;"Bill of Item No Line";Integer)
    {
        CaptionML=ENU='Bill of Item No Line',ESP='N§ l¡nea descompuesto';
                                                   Description='Key 4';


    }
    field(6;"Description";Text[80])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Description='Del Presupuesto';


    }
    field(7;"Budget Units";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Units',ESP='Uds ppto.';
                                                   DecimalPlaces=2:6;
                                                   Description='Del Presupuesto';
                                                   Editable=false;


    }
    field(8;"Budget Length";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Length',ESP='Lon ppto.';
                                                   Description='Del Presupuesto';
                                                   Editable=false;


    }
    field(9;"Budget Width";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Width',ESP='Anc ppto.';
                                                   Description='Del Presupuesto';
                                                   Editable=false;


    }
    field(10;"Budget Height";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Height',ESP='Alt ppto.';
                                                   Description='Del Presupuesto';
                                                   Editable=false;


    }
    field(11;"Budget Total";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Total ppto.',ESP='Tot  ppto.';
                                                   Description='Del Presupuesto';
                                                   Editable=false;


    }
    field(12;"Measured Units";Decimal)
    {
        CaptionML=ENU='Measure Units',ESP='Unidades Origen';
                                                   DecimalPlaces=2:6;
                                                   Description='A Origen';


    }
    field(16;"Measured Total";Decimal)
    {
        CaptionML=ENU='Total Measured',ESP='Total Origen';
                                                   Description='A Origen   JAV 17/09/19: - Se cambia el nombre del campo "Total Measured" para que mantenga la uniformidad  a "Measured Total"';
                                                   Editable=false;


    }
    field(17;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(18;"Realized Units";Decimal)
    {
        CaptionML=ENU='Realized Units',ESP='Uds realiz.';
                                                   DecimalPlaces=2:6;
                                                   Description='Anterior';
                                                   Editable=false;


    }
    field(22;"Realized Total";Decimal)
    {
        CaptionML=ENU='Total Realized',ESP='Tot realiz.';
                                                   Description='Anterior  JAV 17/09/19: - Se cambia el nombre del campo "Total Realized" para que mantenga la uniformidad  a "Realized Total"';
                                                   Editable=false;


    }
    field(30;"Period Units";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Measure Units',ESP='Unidades Periodo';
                                                   DecimalPlaces=2:6;
                                                   Description='Periodo     JAV 22/09/19: - Nuevo campo para establecer las unidades de avance del periodo de la l¡nea';


    }
    field(34;"Period Total";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Total Measured',ESP='Total Periodo';
                                                   Description='Periodo   JAV 22/09/19: - Nuevo campo para establecer el total de avance del periodo de la l¡nea';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Document No.","Piecework Code","Bill of Item No Line")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 06/04/21: - QB 1.08.33 Tabla auxiliar para imprimir mediciones
    }
    end.
  */
}








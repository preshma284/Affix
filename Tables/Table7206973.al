table 7206973 "QBU Posted Receipt/Trans.Lines"
{
  
  
    CaptionML=ENU='Posted Receipt Transfer Line',ESP='L¡n. Recepci¢n Traspaso registrado';
  
  fields
{
    field(1;"Document No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document No.',ESP='N§ documento';


    }
    field(2;"Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Line No.',ESP='N§ Linea';


    }
    field(3;"Item No.";Code[20])
    {
        TableRelation="Item";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Item No.',ESP='N§ producto';

trigger OnValidate();
    VAR
//                                                                 Item@1100286000 :
                                                                Item: Record 27;
                                                              BEGIN 
                                                              END;


    }
    field(4;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(5;"Unit of Measure Code";Text[10])
    {
        TableRelation="Unit of Measure"."Description";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unit of Measure Code',ESP='C¢d. unidad medida';


    }
    field(6;"Quantity";Decimal)
    {
        DataClassification=ToBeClassified;


    }
    field(7;"Unit Cost";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unit Cost',ESP='Coste unitario';


    }
    field(8;"Total Cost";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Total Cost',ESP='Coste total';
                                                   Editable=false;


    }
    field(9;"Service Order No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Service Order No.',ESP='N§ pedido servicio';


    }
    field(10;"Origin Location";Code[10])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Origin Location',ESP='Almac‚n origen';


    }
    field(11;"Destination Location";Code[10])
    {
        TableRelation="Location";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Destination Location',ESP='Almac‚n destino';


    }
    field(50;"Document Type";Option)
    {
        OptionMembers=" ","Receipt","Transfer","Setting";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='" ,Receipt,Transfer,Setting"',ESP='" ,Recepci¢n,Traspaso,Ajustes"';
                                                   


    }
    field(51;"Document Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto'; ;


    }
}
  keys
{
    key(key1;"Document No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 02/06/22: - Se a¤ade la key "Document Job No.,Document Type,Item No." para mejorar la velocidad
    }
    end.
  */
}








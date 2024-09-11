table 7207394 "QPR Company Budget Use"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='Where Budget Used',ESP='Donde se usa el Presupuesto';
  
  fields
{
    field(1;"QPR Origin Company";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa de Origen';


    }
    field(2;"QPR Origin Job";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto de Origen';


    }
    field(3;"QPR Destination Company";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa Destino';


    }
    field(4;"QPR Destination Job";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto Destino';


    }
    field(5;"QPR Destination Piecework code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. unidad de obra',ESP='C¢d. unidad de obra'; ;


    }
}
  keys
{
    key(key1;"QPR Origin Company","QPR Origin Job","QPR Destination Company","QPR Destination Job","QPR Destination Piecework code")
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








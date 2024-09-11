table 7206988 "QB Job Responsible/Circuit"
{
  
  
    CaptionML=ENU='TMP Job Responsible/Circuit',ESP='TEMPORAL Responsable/Circuito';
  
  fields
{
    field(1;"Position";Code[10])
    {
        TableRelation="QB Position";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Position',ESP='Cargo';


    }
    field(2;"User ID";Code[50])
    {
        TableRelation="User Setup"."User ID";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User ID',ESP='ID usuario';


    }
    field(3;"Circuit";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Circuito';


    }
    field(10;"Order";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Orden';
                                                   Description='Para ordenar los registros';


    }
    field(11;"Document Type";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de Documento';


    }
    field(20;"Position Description";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("QB Position"."Description" WHERE ("Code"=FIELD("Position")));
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(21;"User Name";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("User"."Full Name" WHERE ("User Name"=FIELD("User ID")));
                                                   CaptionML=ENU='Name',ESP='Nombre Usuario';
                                                   Editable=false;


    }
    field(22;"No in Approvals";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No Aprueba';


    }
    field(30;"Circuit Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nombre del circuito';


    }
    field(31;"Circuit Data";Text[30])
    {
        CaptionML=ESP='Datos del Circuito';
                                                   Description='Datos en el circuito de aprobaci¢n' ;


    }
}
  keys
{
    key(key1;"Position","User ID","Circuit")
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








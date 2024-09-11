table 7206940 "QBU Generic Import Header"
{
  
  
    CaptionML=ENU='QB Generic Import Header',ESP='QB Cabecera Importaci¢n Gen‚rica';
  
  fields
{
    field(1;"Setup Code";Code[20])
    {
        DataClassification=ToBeClassified;


    }
    field(2;"Table ID";Integer)
    {
        TableRelation=AllObjWithCaption."Object ID" WHERE ("Object Type"=FILTER("TableData"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Table ID',ESP='ID Tabla';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Table Name");
                                                              END;


    }
    field(3;"Table Name";Text[100])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE ("Object ID"=FIELD("Table ID")));
                                                   CaptionML=ENU='Table Name',ESP='Nombre Tabla';
                                                   Editable=false;


    }
    field(4;"Group";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Group',ESP='Agrupado';


    }
    field(5;"Skip from Begginnig";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Saltar del inicio';


    }
    field(6;"Skip form End";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Salta del final';


    }
    field(7;"File Name";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nombre del fichero';


    }
    field(8;"Sheet Name";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nombre de la hoja';


    }
    field(9;"Type";Option)
    {
        OptionMembers="Excel","Text","CSV";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='Excel,Text,CSV',ESP='Excel,Texto,CSV';
                                                   


    }
    field(10;"Sep";Text[1])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Separador';


    }
    field(11;"Del";Text[1])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Delimitador';


    }
}
  keys
{
    key(key1;"Setup Code")
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








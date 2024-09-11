table 7174332 "SII Document Error"
{
  
  
  ;
  fields
{
    field(1;"Ship No.";Code[20])
    {
        CaptionML=ENU='Ship No.',ESP='N§ Env¡o';


    }
    field(2;"Document Type";Option)
    {
        OptionMembers=" ","FE","FR","OS","CM","BI","OI","CE","PR";CaptionML=ENU='Document Type',ESP='Tipo Documento';
                                                   OptionCaptionML=ENU='" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Metalico,Fact. Bienes Inv.,Fact. Op. Intracomunitaria,Cobro Factura,Pago Factura"',ESP='" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Metalico,Fact. Bienes Inv.,Fact. Op. Intracomunitaria,Cobro Factura,Pago Factura"';
                                                   


    }
    field(3;"Document No.";Code[60])
    {
        CaptionML=ENU='Document No.',ESP='N§ Documento';


    }
    field(4;"Error Code";Code[20])
    {
        CaptionML=ENU='Error Code',ESP='C¢digo Error';


    }
    field(5;"Error Desc";Text[250])
    {
        CaptionML=ENU='Error Desc',ESP='Descripci¢n Error';


    }
    field(6;"HoraEnvio";DateTime)
    {
        CaptionML=ENU='Shipment Time',ESP='Hora Env¡o';


    }
    field(7;"AEAT Status";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("ShipStatus"));
                                                   CaptionML=ENU='AEAT Status',ESP='Estado AEAT';
                                                   Editable=false;


    }
    field(8;"Ship CSV";Text[250])
    {
        CaptionML=ENU='Ship CSV',ESP='Envio CSV';


    }
    field(9;"Document CSV";Text[250])
    {
        CaptionML=ENU='Document CSV',ESP='Documento CSV';


    }
    field(10;"ID";Integer)
    {
        AutoIncrement=true;
                                                   CaptionML=ENU='ID',ESP='ID';


    }
    field(19;"VAT Registration No.";Code[20])
    {
        CaptionML=ENU='VAT Registration No.',ESP='CIF/NIF';


    }
    field(22;"Posting Date";Date)
    {
        CaptionML=ENU='Posting Date',ESP='Fecha de Registro';
                                                   Description='QuoSII_02_07';


    }
    field(23;"Entry No.";Integer)
    {
        CaptionML=ENU='Entry No.',ESP='No. Movimiento';
                                                   Description='QuoSII_02_07';


    }
    field(24;"Tipo Entorno";Option)
    {
        OptionMembers="REAL","PRUEBAS";CaptionML=ENU='Environment Type',ESP='Tipo Entorno';
                                                   OptionCaptionML=ESP='REAL,PRUEBAS';
                                                   
                                                   Description='QuoSII1.4';


    }
    field(25;"Register Type";Code[5])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de Registro';
                                                   Description='QuoSII 1.5p' ;


    }
}
  keys
{
    key(key1;"Ship No.","Document No.","HoraEnvio","ID")
    {
        Clustered=true;
    }
    key(key2;"HoraEnvio")
    {
        ;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 08/09/21: - QuoSII 1.05z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as¤i no entra en confusi¢n con campos denominados Type
    }
    end.
  */
}








table 7174650 "QBU DragDrop SP Setup"
{
  
  
    CaptionML=ENU='DragDrop SP Setup',ESP='Conf. arrastrar y soltar Sharepoint';
  
  fields
{
    field(1;"Primary Key";Code[10])
    {
        CaptionML=ENU='Primary Key',ESP='Clave primaria';


    }
    field(2;"User";Text[250])
    {
        CaptionML=ENU='User',ESP='Usuario';


    }
    field(3;"Pass";Text[250])
    {
        CaptionML=ENU='Password',ESP='Contrase¤a';


    }
    field(4;"Url Sharepoint";Text[250])
    {
        CaptionML=ENU='Url',ESP='Url Sharepoint';


    }
    field(5;"Log";Boolean)
    {
        CaptionML=ENU='Log',ESP='Log';


    }
    field(6;"Def. Sharepoint Nos.";Code[20])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='No. Serie Def. Sharepoint',ESP='No. Serie Def. Sharepoint';


    }
    field(9;"Debug Level";Option)
    {
        OptionMembers="None","Info","All";CaptionML=ENU='Debug Level',ESP='Nivel de Debug';
                                                   OptionCaptionML=ENU='None,Info,All',ESP='Ninguno,Info,Todo';
                                                   


    }
    field(10;"Batch Synchronization";Boolean)
    {
        CaptionML=ENU='Batch Synchronization',ESP='Sincronizaci¢n por lotes';


    }
    field(11;"Enable Integration";Boolean)
    {
        CaptionML=ENU='Enable Integration',ESP='Habilitar integraci¢n';


    }
    field(12;"Library Name Default";Text[30])
    {
        CaptionML=ENU='Library Name Default',ESP='Nombre librer¡a por defecto';


    }
    field(13;"Serie No. Internal Name";Code[20])
    {
        TableRelation="No. Series"."Code";
                                                   CaptionML=ENU='Serie No. Internal Name',ESP='No. Serie Columnas SP';


    }
    field(14;"Master Setup Company";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa de configuraci¢n maestra';
                                                   Description='Indica que la empresa actual act£a como empresa maestra en la definici¢n de sitios de Sharepoint. La configuraci¢n de la empresa maestra se traslada al resto de empresas' ;


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
      QUONEXT 20.07.17 DRAG&DROP. Configuraci¢n.
    }
    end.
  */
}








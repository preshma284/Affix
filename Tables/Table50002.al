table 50002 "QBU QuoSync Setup"
{
  
  
    CaptionML=ENU='Sync Setup',ESP='Conf. de la Sincronizaci¢n';
  
  fields
{
    field(1;"Code";Code[10])
    {
        TableRelation=AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST("Table"));
                                                   DataClassification=ToBeClassified;
                                                   Description='Esto debe ser un INTEGER';


    }
    field(9;"Active";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Active',ESP='Activado';


    }
    field(10;"Destination Company";Text[50])
    {
        CaptionML=ENU='Destination Company',ESP='Empresa destino';


    }
    field(11;"Delete after days";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Eliminar tras d¡as';


    }
    field(12;"Company Type";Option)
    {
        OptionMembers="Master","Sync";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Company Type',ESP='Tipo de Empresa';
                                                   OptionCaptionML=ENU='Master,Sync',ESP='Master,Sincronizada';
                                                   


    }
    field(20;"Connection Type";Option)
    {
        OptionMembers="Internal","SQL","Azure";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Connection Type',ESP='Tipo de conexi¢n';
                                                   OptionCaptionML=ENU='Internal,External SQL,External Azure',ESP='Interna,Externa SQL,Externa Azure';
                                                   


    }
    field(21;"Server";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Servidor';


    }
    field(22;"Database";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nombre Base Datos';


    }
    field(23;"Security";Option)
    {
        OptionMembers="Integrated","UserPassword";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Seguridad';
                                                   OptionCaptionML=ENU='Integrated,User & Password',ESP='Integrada,Usuario y Contrase¤a';
                                                   


    }
    field(24;"User";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Usuario';


    }
    field(25;"Password";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Contrase¤a';


    }
    field(30;"Last Sync";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Last Sync',ESP='éltima sincronizaci¢n';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       rRef@1100286000 :
      rRef: RecordRef;
//       fRef@1100286001 :
      fRef: FieldRef;

    /*begin
    end.
  */
}








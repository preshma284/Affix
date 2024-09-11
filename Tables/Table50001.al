table 50001 "QBU QuoSync Received"
{
  
  
    
  fields
{
    field(1;"Entry No";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Entry No',ESP='N§ Movimiento';


    }
    field(10;"Origin";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Origin',ESP='Origen';


    }
    field(11;"Origin Entry No";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Movimiento en Origen';


    }
    field(12;"Destination";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Destination',ESP='Destino';


    }
    field(21;"Table";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Table',ESP='Tabla';


    }
    field(23;"Type";Option)
    {
        OptionMembers="New","Modification","Delete","Rename","SyncIni","SyncReg","SyncEnd";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='New,Modification,Delete,Rename,,,Ini Sync,Reg. Sync,End Sync',ESP='Alta,Modificaci¢n,Baja,Renombrar,,,Inicio Sinc.,Registro Sinc.,Fin Sinc.';
                                                   


    }
    field(24;"Key";RecordID)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Key',ESP='Clave';


    }
    field(26;"XML";BLOB)
    {
        DataClassification=ToBeClassified;


    }
    field(27;"XML Size";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='XML Size',ESP='Tama¤o XML';


    }
    field(30;"Date Send";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Date Send',ESP='Fecha Envío';


    }
    field(32;"Date Received";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Date reception',ESP='Fecha recepci¢n';


    }
    field(33;"Procesed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Procesed',ESP='Procesado';


    }
    field(34;"Date Procesed";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Date & Time',ESP='Fecha y hora procesado';


    }
    field(35;"Whit Error";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Whit Error',ESP='Hay error';


    }
    field(36;"Text Error";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Error',ESP='Error'; ;


    }
}
  keys
{
    key(key1;"Entry No")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBCompanySyncReceived@1100286000 :
      QBCompanySyncReceived: Record 50001;

    

trigger OnInsert();    begin
               QBCompanySyncReceived.RESET;
               if QBCompanySyncReceived.FINDLAST then
                 "Entry No" := QBCompanySyncReceived."Entry No" + 1
               else
                 "Entry No" := 1;
             end;



/*begin
    end.
  */
}








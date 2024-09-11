table 50000 "QBU QuoSync Send"
{


    DataPerCompany = false;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Entry No', ESP = 'N� Movimiento';


        }
        field(10; "Origin"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin', ESP = 'Origen';


        }
        field(12; "Destination"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination', ESP = 'Destino';


        }
        field(13; "Destination Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Entry No', ESP = 'N� Movimiento en Destino';


        }
        field(21; "Table"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Table', ESP = 'Tabla';


        }
        field(23; "Type"; Option)
        {
            OptionMembers = "New","Modification","Delete","Rename","SyncIni","SyncReg","SyncEnd";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'New,Modification,Delete,Rename,,,Ini Sync,Reg. Sync,End Sync', ESP = 'Alta,Modificaci�n,Baja,Renombrar,,,Inicio Sinc.,Registro Sinc.,Fin Sinc.';



        }
        field(24; "Key"; RecordID)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Key', ESP = 'Clave';


        }
        field(26; "XML"; BLOB)
        {
            DataClassification = ToBeClassified;


        }
        field(27; "XML Size"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'XML Size', ESP = 'Tama�o XML';


        }
        field(30; "Date Send"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date & Time', ESP = 'Fecha y hora env�o';


        }
        field(31; "Received"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Send', ESP = 'Recibido';


        }
        field(32; "Date Received"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date & Time', ESP = 'Fecha y hora recepci�n';
            ;


        }
    }
    keys
    {
        key(key1; "Entry No")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }




    trigger OnInsert();
    var
        //                QBCompanySyncSend@1100286000 :
        QBCompanySyncSend: Record 50000;
    begin
        QBCompanySyncSend.RESET;
        if QBCompanySyncSend.FINDLAST then
            "Entry No" := QBCompanySyncSend."Entry No" + 1
        else
            "Entry No" := 1;
    end;



    /*begin
        end.
      */
}








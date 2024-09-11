table 7206903 "QBU Tables Setup"
{


    DataPerCompany = false;
    CaptionML = ENU = 'QB Tables Setup', ESP = 'Conf. Tablas para QB';

    fields
    {
        field(1; "Table"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tabla';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Table Name");
            END;


        }
        field(2; "Field No."; Integer)
        {
            TableRelation = Field."No." WHERE("TableNo" = FIELD("Table"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Campo';

            trigger OnValidate();
            BEGIN
                CALCFIELDS(Caption);

                IF ("Field No." <> xRec."Field No.") THEN BEGIN
                    rRef.OPEN(Table);
                    fRef := rRef.FIELD("Field No.");              //Tabla relacionada con el campo, es fija en captios y para las dimensiones se puede cambiar
                    "MDimension Table" := fRef.RELATION;
                    rRef.CLOSE;
                    IF ("MDimension Table" = 0) THEN  //Si no est� relacionado con ninguna tabla, se usa la propia tabla para indicar el campo de Descripción
                        "MDimension Table" := Table;

                    rRef.OPEN("MDimension Table");
                    "MDimension Field" := 0;
                    IF ("MDimension Table" <> 0) THEN
                        GetDescripcionField();
                    rRef.CLOSE;
                END;
            END;


        }
        field(3; "Languaje"; Code[10])
        {
            TableRelation = "Language";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Idioma';


        }
        field(9; "Table Name"; Text[249])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object Type" = CONST("Table"),
                                                                                                                "Object ID" = FIELD("Table")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(10; "Caption"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Field"."Field Caption" WHERE("TableNo" = FIELD("Table"),
                                                                                                   "No." = FIELD("Field No.")));
            CaptionML = ESP = 'Descripción Original';
            Editable = false;


        }
        field(11; "New Caption"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Nueva Descripción';


        }
        field(20; "Mandatory Field"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cambo obligatorio';
            Description = 'QB 1.00.00 JAV 06/04/20: - [TT] Indica si el campo es obligatorio rellenarlo, si no se rellena el registro queda bloqueado';


        }
        field(30; "MDimension Code"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Mandatory Dimension', ESP = 'Dimensi�n obligatoria';
            Description = 'QB 1.00.00 JAV 10/03/20: - [TT] Para el manejo de la Dimensi�n autom�tica, el c�digo de la dimensi�n';


        }
        field(31; "MDimension Table"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tabla relacionada';
            BlankZero = true;
            Description = 'QB 1.00.00 JAV 10/03/20: - [TT] Para el manejo de la Dimensi�n autom�tica, la tabla relacionada';
            Editable = false;


        }
        field(32; "MDimension Field"; Integer)
        {
            TableRelation = Field."No." WHERE("TableNo" = FIELD("MDimension Table"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Campo Descripción';
            BlankZero = true;
            Description = 'QB 1.00.00 JAV 10/03/20: - [TT] Para el manejo de la Dimensi�n autom�tica,  que campo se usa para oa Descripción del valor de dimensi�n entre los existentes en la tabla relacionada';


        }
        field(33; "MDimension Prefix"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Prefijo';
            Description = 'QB 1.06.12 JAV 10/09/20: - [TT] Este prefijo se a�ade al valor del campo al crear el nuevo valor de dimensi�n asociado al registro';


        }
        field(41; "OLD_Not editable in destinatio"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_No editable en destino';
            Description = '###ELIMINAR###no se usa';


        }
        field(50; "OLD_Configuration"; Option)
        {
            OptionMembers = "No","Yes","QB";
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Configuraci�n';
            OptionCaptionML = ESP = 'No,Si,Para QuoBuilding';

            Description = '###ELIMINAR###no se usa';


        }
        field(51; "OLD_Syncronization"; Option)
        {
            OptionMembers = "Yes","No","nQB";
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Sincronizar';
            OptionCaptionML = ESP = 'Si,No,No para QuoBuilding';

            Description = '###ELIMINAR###no se usa';


        }
    }
    keys
    {
        key(key1; "Table", "Field No.", "Languaje")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBTablesSetup@1100286001 :
        QBTablesSetup: Record 7206903;
        //       QBTablesSetup2@1100286000 :
        QBTablesSetup2: Record 7206903;
        //       rRef@100000000 :
        rRef: RecordRef;
        //       fRef@100000001 :
        fRef: FieldRef;
        //       Txt@100000002 :
        Txt: Text;
        //       txtQB000@1100286002 :
        txtQB000: TextConst ESP = 'Los campos %1 y %2 de la tabla %3 "%4" usan la misma dimensi�n "%5", eso puede causar problemas';

    //     procedure IsMandatoryField (TableId@1100286001 : Integer;FieldId@1100286002 :
    procedure IsMandatoryField(TableId: Integer; FieldId: Integer): Boolean;
    var
        //       QBTablesSetup@1100286000 :
        QBTablesSetup: Record 7206903;
    begin
        QBTablesSetup.RESET;
        QBTablesSetup.SETRANGE(Table, TableId);
        QBTablesSetup.SETRANGE("Field No.", "Field No.");
        QBTablesSetup.SETRANGE("Mandatory Field", TRUE);
        exit(not QBTablesSetup.ISEMPTY);
    end;

    //     procedure AsMandatoryFields (TableId@1100286001 :
    procedure AsMandatoryFields(TableId: Integer): Boolean;
    var
        //       QBTablesSetup@1100286000 :
        QBTablesSetup: Record 7206903;
    begin
        QBTablesSetup.RESET;
        QBTablesSetup.SETRANGE(Table, TableId);
        QBTablesSetup.SETRANGE("Mandatory Field", TRUE);
        exit(not QBTablesSetup.ISEMPTY);
    end;

    [TryFunction]
    LOCAL procedure GetDescripcionField()
    var
        //       i@100000000 :
        i: Integer;
    begin
        FOR i := 1 TO rRef.FIELDCOUNT DO begin
            fRef := rRef.FIELDINDEX(i);
            Txt := fRef.NAME;
            if UPPERCASE(Txt) IN ['DESCRIPTION', 'NAME'] then begin
                "MDimension Field" := fRef.NUMBER;
                exit;
            end;
        end;
    end;

    procedure DeleteEmpty(): Boolean;
    begin
        //--------------------------------------------------------------------------------------------------------------
        //Si no tienen datos se eliminan los registros
        //--------------------------------------------------------------------------------------------------------------
        QBTablesSetup.RESET;
        if (QBTablesSetup.FINDSET) then
            repeat
                if (QBTablesSetup."New Caption" = '') and
                   (QBTablesSetup."Mandatory Field" = FALSE) and
                   (QBTablesSetup."MDimension Code" = '')
                //JAV 25/04/22: - QB 1.10.36 Se eliminan campos que pasan a QM Master Data
                //(QBTablesSetup."OLD_Not editable in destinatio" = FALSE) and
                //(QBTablesSetup.OLD_Configuration = QBTablesSetup.OLD_Configuration::No) and
                //(QBTablesSetup.OLD_Syncronization = QBTablesSetup.OLD_Syncronization::Yes)
                then
                    QBTablesSetup.DELETE;
            until (QBTablesSetup.NEXT = 0);

        //JAV 25/04/22: - QB 1.10.36 Se eliminan campos que pasan a QM Master Data
        //{
        //      //Eliminar campos que se sincronizan cuando ya no est� la tabla a sincronizar
        //      QBTablesSetup.RESET;
        //      QBTablesSetup.SETFILTER(OLD_Syncronization, '<>%1', QBTablesSetup.OLD_Syncronization::Yes);
        //      if (QBTablesSetup.FINDSET) then
        //        repeat
        //          if (not QBTablesSetup2.GET(QBTablesSetup.Table,0,'')) then
        //            QBTablesSetup.DELETE;
        //          else if (QBTablesSetup2.OLD_Configuration = QBTablesSetup2.OLD_Configuration::No) then
        //            QBTablesSetup.DELETE;
        //        until (QBTablesSetup.NEXT = 0);
        //      }
    end;

    //     procedure CargarTemporal (Type@1100286001 : 'Des,Obl,Dim,Conf';var tmpRec@1100286000 :
    procedure CargarTemporal(Type: Option "Des","Obl","Dim","Conf"; var tmpRec: Record 7206903)
    begin
        //Cargar el temporal con los datos de condiguraci�n
        FiltrarDatos(Type, QBTablesSetup);
        if (QBTablesSetup.FINDSET(FALSE)) then
            repeat
                tmpRec := QBTablesSetup;
                tmpRec.VALIDATE("Field No.");
                tmpRec.INSERT;
            until (QBTablesSetup.NEXT = 0);
    end;

    //     procedure GuardarTemporal (Type@1100286001 : 'Des,Obl,Dim,Conf';var tmpRec@1100286000 :
    procedure GuardarTemporal(Type: Option "Des","Obl","Dim","Conf"; var tmpRec: Record 7206903)
    begin
        //A partir del temporal hacemos las altas y modificaciones de registros
        tmpRec.RESET;
        if (tmpRec.FINDSET(FALSE)) then
            repeat
                if (not QBTablesSetup.GET(tmpRec.Table, tmpRec."Field No.", tmpRec.Languaje)) then begin
                    QBTablesSetup.INIT;
                    QBTablesSetup.Table := tmpRec.Table;
                    QBTablesSetup."Field No." := tmpRec."Field No.";
                    QBTablesSetup.Languaje := tmpRec.Languaje;
                    QBTablesSetup.INSERT;
                end;
                CASE Type OF
                    Type::Des:
                        begin
                            QBTablesSetup."New Caption" := tmpRec."New Caption";
                        end;
                    Type::Obl:
                        begin
                            QBTablesSetup."Mandatory Field" := tmpRec."Mandatory Field";
                        end;
                    Type::Dim:
                        begin
                            QBTablesSetup."MDimension Code" := tmpRec."MDimension Code";
                            QBTablesSetup."MDimension Prefix" := tmpRec."MDimension Prefix";
                            QBTablesSetup."MDimension Table" := tmpRec."MDimension Table";
                            QBTablesSetup."MDimension Field" := tmpRec."MDimension Field";
                        end;
                //JAV 25/04/22: - QB 1.10.36 Se eliminan campos que pasan a QM Master Data
                //Type::Conf :
                //  begin
                //    QBTablesSetup.OLD_Configuration := Rec.OLD_Configuration;
                //  end;
                end;
                QBTablesSetup.MODIFY(TRUE);
            until (tmpRec.NEXT = 0);

        //A partir de los registros miro el temporal y hacemos las Bajas
        FiltrarDatos(Type, QBTablesSetup);
        if (QBTablesSetup.FINDSET(TRUE)) then
            repeat
                if (not tmpRec.GET(QBTablesSetup.Table, QBTablesSetup."Field No.", '')) then begin
                    CASE Type OF
                        Type::Des:
                            begin
                                QBTablesSetup."New Caption" := '';
                            end;
                        Type::Obl:
                            begin
                                QBTablesSetup."Mandatory Field" := FALSE;
                            end;
                        Type::Dim:
                            begin
                                QBTablesSetup."MDimension Code" := '';
                                QBTablesSetup."MDimension Prefix" := '';
                            end;
                    //JAV 25/04/22: - QB 1.10.36 Se eliminan campos que pasan a QM Master Data
                    //Type::Conf :
                    //  begin
                    //    QBTablesSetup.OLD_Configuration := QBTablesSetup.OLD_Configuration::No;
                    //  end;
                    end;
                    QBTablesSetup.MODIFY(TRUE);
                end;
            until (QBTablesSetup.NEXT = 0);

        //Eliminar los registros vacios
        DeleteEmpty;

        //Verificar datos finales
        // if (Type = Type::Dim) then begin
        //  FiltrarDatos(Type,QBTablesSetup);
        //  if (QBTablesSetup.FINDSET(TRUE)) then
        //    repeat
        //      QBTablesSetup2.RESET;
        //      QBTablesSetup2.SETRANGE(Table, QBTablesSetup.Table);
        //      QBTablesSetup2.SETRANGE("MDimension Code", QBTablesSetup."MDimension Code");
        //      QBTablesSetup2.SETFILTER(Field,'<>%1',QBTablesSetup.Field);
        //      if (QBTablesSetup2.FINDFIRST) then begin
        //        QBTablesSetup.CALCFIELDS("Table Name");
        //        message(txtQB000,
        //                QBTablesSetup.Field, QBTablesSetup2.Field, QBTablesSetup.Table, QBTablesSetup."Table Name", QBTablesSetup."MDimension Code");
        //      end;
        //    until (QBTablesSetup.NEXT = 0);
        // end;
    end;

    //     LOCAL procedure FiltrarDatos (Type@1100286001 : 'Des,Obl,Dim,Conf';var QBTablesSetup@1100286000 :
    LOCAL procedure FiltrarDatos(Type: Option "Des","Obl","Dim","Conf"; var QBTablesSetup: Record 7206903)
    begin
        //Filtrar los registros a ver de la tabla
        QBTablesSetup.RESET;
        CASE Type OF
            Type::Des:
                QBTablesSetup.SETFILTER("New Caption", '<>%1', '');
            Type::Obl:
                QBTablesSetup.SETRANGE("Mandatory Field", TRUE);
            Type::Dim:
                QBTablesSetup.SETFILTER("MDimension Code", '<>%1', '');
        //JAV 25/04/22: - QB 1.10.36 Se eliminan campos que pasan a QM Master Data
        //Type::Conf : QBTablesSetup.SETFILTER(OLD_Configuration, '<>%1', QBTablesSetup.OLD_Configuration::No);
        end;
        if (Type <> Type::Des) then
            QBTablesSetup.SETFILTER(Languaje, '=%1', '');
    end;

    //     procedure CheckTable (pTables@1100286001 : ARRAY [50] OF Integer;pNum@1100286002 :
    procedure CheckTable(pTables: ARRAY[50] OF Integer; pNum: Integer): Boolean;
    var
        //       i@1100286000 :
        i: Integer;
    begin
        i := 1;
        repeat
            if (pTables[i] = pNum) then
                exit(TRUE);
            i += 1;
        until (pTables[i] = 0);
        exit(FALSE);
    end;

    //     procedure CheckField (pTables@1100286002 : ARRAY [50] OF Integer;pFields@1100286001 : ARRAY [50] OF Integer;pTable@1100286003 : Integer;pNum@1100286000 :
    procedure CheckField(pTables: ARRAY[50] OF Integer; pFields: ARRAY[50] OF Integer; pTable: Integer; pNum: Integer): Boolean;
    var
        //       i@1100286004 :
        i: Integer;
    begin
        i := 1;
        repeat
            if (pTables[i] = pTable) and (pFields[i] = pNum) then
                exit(TRUE);
            i += 1;
        until (pTables[i] = 0);
        exit(FALSE);
    end;

    //     procedure TableListToText (pTables@1100286000 :
    procedure TableListToText(pTables: ARRAY[50] OF Integer): Text;
    var
        //       i@1100286001 :
        i: Integer;
        //       rRef@1100286002 :
        rRef: RecordRef;
        //       AuxText@1100286003 :
        AuxText: Text;
    begin
        AuxText := '';
        FOR i := 1 TO ARRAYLEN(pTables) DO begin
            if (pTables[i] <> 0) then begin
                rRef.OPEN(pTables[i]);
                if (AuxText <> '') then
                    AuxText += ', ';
                AuxText += 'Tabla ' + FORMAT(pTables[i]) + ': ' + rRef.CAPTION;
                rRef.CLOSE;
            end;
        end;

        exit(AuxText);
    end;

    /*begin
    end.
  */
}








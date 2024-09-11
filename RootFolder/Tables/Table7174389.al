table 7174389 "QM MasterData Conf. Tables"
{


    DataPerCompany = false;
    CaptionML = ENU = 'MasterData Configuration Tables Setup', ESP = 'MasterData Tablas de Configuraci�n';

    fields
    {
        field(1; "Table No."; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Table"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tabla';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Table Name");
            END;


        }
        field(10; "Table Name"; Text[249])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Caption" WHERE("Object Type" = CONST("Table"),
                                                                                                                "Object ID" = FIELD("Table No.")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(50; "Configuration"; Option)
        {
            OptionMembers = "Yes","OnlyQB","No";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Configuraci�n';
            OptionCaptionML = ESP = 'Siempre,Solo para QuoBuilding,No Sincronizar';

            Description = 'MD 1.00.02 JAV 22/04/22: - [TT] Si es una tabla de configuraci�n a sincronizar desde la empresa Master, siempre, nunca, solo si la empresa tiene marcado QuoBuilding';


        }
    }
    keys
    {
        key(key1; "Table No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QMMasterDataTableField@1100286000 :
        QMMasterDataTableField: Record 7174393;
        //       QMMasterDataTable@1100286001 :
        QMMasterDataTable: Record 7174392;



    trigger OnInsert();
    begin
        QMMasterDataTableField.CreateFields("Table No.");
    end;

    trigger OnDelete();
    begin
        //Si lo eliminamos de aqu� y no hay registro en la de tablas a sincronizar eliminos los campos
        if (not QMMasterDataTable.GET(Rec."Table No.")) then begin
            QMMasterDataTableField.RESET;
            QMMasterDataTableField.SETRANGE("Table No.", Rec."Table No.");
            QMMasterDataTableField.DELETEALL;
        end;
    end;

    trigger OnRename();
    begin
        ERROR('No puede cambiar la tabla, cree una nueva y elimine esta');
    end;



    /*begin
        end.
      */
}








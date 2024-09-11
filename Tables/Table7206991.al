table 7206991 "QBU Job Responsibles Template" //7206991

{


    CaptionML = ENU = 'Responsibles Template', ESP = 'Pantillas de Responsables';

    fields
    {
        field(1; "Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Plantilla';
            Description = 'KEY 1. JAV 10/02/22: - QB 1.10.19 Plantilla de aprobaci¢n';


        }
        field(2; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C¢digo';
            Description = 'KEY 2. JAV 13/01/19: - Id del registro, se usa para poder tener registros con los cargos duplicados en lugar de usar la clave del cargo directamente';


        }
        field(10; "Use in"; Option)
        {
            OptionMembers = "Quotes","Operative Jobs","Quotes&Jobs","Budgets","RealEstate","All";
            CaptionML = ENU = 'Use in', ESP = 'Usar en';
            OptionCaptionML = ENU = 'Quotes,Operative Jobs,Quotes & Jobs,,Budgets,RealEstate,All', ESP = 'Estudios,Obras,Estudios y Obras,,Presupuestos,RealEstate,Todos';



        }
        field(11; "Position"; Code[10])
        {
            TableRelation = "QB Position";


            CaptionML = ENU = 'Position', ESP = 'Cargo';
            Description = 'JAV 28/07/19: - Cambio el Name que no est  bien traducido';

            trigger OnValidate();
            BEGIN
                QBPosition.GET(Position);
                Description := QBPosition.Description;
            END;


        }
        field(12; "Description"; Text[80])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci¢n';
            Editable = false;


        }
        field(13; "The User"; Option)
        {
            OptionMembers = "Can defined","is optional","is fixed","copy from quotes";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'El usuario';
            OptionCaptionML = ENU = 'Can defined,is optional,is fixed,copy from quotes', ESP = 'Debe definirse,es opcional,es fijo,copiar de estudios';



        }
        field(14; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";


            CaptionML = ENU = 'User ID', ESP = 'ID usuario';

            trigger OnValidate();
            BEGIN
                //JAV 28/07/19 buscar el nombre
                CALCFIELDS(Name);
            END;


        }
        field(15; "Name"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("User"."Full Name" WHERE("User Name" = FIELD("User ID")));
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Editable = false;


        }
        field(16; "User to Use"; Code[50])
        {
            TableRelation = "User Setup"."User ID";


            CaptionML = ENU = 'User ID', ESP = 'Usuario a utilizar';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Name of User to Use");
            END;


        }
        field(17; "Name of User to Use"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("User"."Full Name" WHERE("User Name" = FIELD("User to Use")));
            CaptionML = ENU = 'Name', ESP = 'Nombre Usuario a utilizar';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Template", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       UserSetup@7001100 :
        UserSetup: Record 91;
        //       QBPosition@7001101 :
        QBPosition: Record 7206989;
        //       Text005@1100286000 :
        Text005: TextConst ENU = 'You cannot have approval limits less than zero.', ESP = 'No puede tener l¡mites de aprobaci¢n inferiores a cero.';
        //       User@1100286002 :
        User: Record 2000000120;
        //       Int@1100286001 :
        Int: Integer;
        //       txtError@1100286004 :
        txtError: Text;

    //     procedure SetFilterType (pType@1100286001 : 'Jobs,Departments';pJobNo@1100286000 :
    procedure SetFilterType(pType: Option "Jobs","Departments"; pJobNo: Code[20]): Boolean;
    var
        //       Job@1100286002 :
        Job: Record 167;
    begin
        //JAV 31/08/21: - QB 1.09.99 Filtrar por los tipos
        Rec.RESET;

        CASE pType OF
            pType::Jobs:
                begin
                    Job.GET(pJobNo);
                    CASE Job."Card Type" OF
                        Job."Card Type"::Estudio:
                            Rec.SETFILTER("Use in", '%1|%2|%3', Rec."Use in"::Quotes, Rec."Use in"::"Quotes&Jobs", Rec."Use in"::All);
                        Job."Card Type"::"Proyecto operativo":
                            Rec.SETFILTER("Use in", '%1|%2|%3', Rec."Use in"::"Operative Jobs", Rec."Use in"::"Quotes&Jobs", Rec."Use in"::All);
                        Job."Card Type"::Presupuesto:
                            Rec.SETFILTER("Use in", '%1|%2', Rec."Use in"::Quotes, Rec."Use in"::All);
                        Job."Card Type"::Promocion:
                            Rec.SETFILTER("Use in", '%1|%2', Rec."Use in"::RealEstate, Rec."Use in"::All);
                    end;
                end;
            pType::Departments:
                begin
                    Rec.SETFILTER("Use in", '%1|%2', Rec."Use in"::"Quotes&Jobs", Rec."Use in"::All);
                    //"Quotes&Jobs" Use in option 3 rd value --> "Quotes&Jobs" //can be used
                end;
        end;

        exit(not Rec.ISEMPTY);
    end;

    /*begin
    //{
//      JAV 12/07/19: - Se quita de la clave principal el cargo, dejando solo proyecto y usuario, y se a¤ade una segunda clave solo usuario.
//      JAV 28/07/19: - Se a¤aden campos 10, 12, 13, 14 y 15 para aprobaciones de compras y comparativos
//      JAV 09/09/19: - Se a¤ade el campo 9 "Internal Id" para identificar los registros un¡vocamente
//                    - Se a¤ade la key "Job No.","Level","Internal Id"
//      JAV 10/02/22: - QB 1.10.19 Se a�ade el campo Template, clave primaria junto a code, y se eliminan las otras Key que no se utilizan
//      JAV 24/06/22: - QB 1.10.54 Se elimina el manejo por departamentos que no tiene sentido aqu�
//    }
    end.
  */
}








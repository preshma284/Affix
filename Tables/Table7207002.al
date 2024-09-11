table 7207002 "QBU Department"
{


    CaptionML = ENU = 'Departments', ESP = 'Departamentos';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'code', ESP = 'C�digo';


        }
        field(10; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(11; "Type"; Option)
        {
            OptionMembers = "Standard","Heading";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Standard,Heading', ESP = 'Est�ndar,Principal';



        }
        field(12; "Indentation"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Indentation', ESP = 'Indentar';


        }
        field(13; "For Payments"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'For Payments', ESP = 'Para Pagos';
            ;


        }
    }
    keys
    {
        key(key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBJobResponsible@1100286000 :
        QBJobResponsible: Record 7206992;



    trigger OnDelete();
    begin
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Department);
        QBJobResponsible.SETRANGE("Table Code", Rec.Code);
        QBJobResponsible.DELETEALL;
    end;

    trigger OnRename();
    begin
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Department);
        QBJobResponsible.SETRANGE("Table Code", Rec.Code);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if (QBJobResponsible.FINDSET(TRUE, TRUE)) then
        if (QBJobResponsible.FINDSET(TRUE)) then
            repeat
                QBJobResponsible.RENAME(QBJobResponsible.Type, Rec.Code, QBJobResponsible."ID Register", QBJobResponsible."Piecework No.");
            until (QBJobResponsible.NEXT = 0);
    end;



    /*begin
        end.
      */
}








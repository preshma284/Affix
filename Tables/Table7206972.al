table 7206972 "QBU Posted Receipt/Trans.Header"
{


    CaptionML = ENU = 'Posted Receipt/Transfer Header Inesco', ESP = 'Cabecera Recepci�n/Traspaso registrado Inesco';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(3; "User"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'User', ESP = 'Usuario';


        }
        field(4; "Type"; Option)
        {
            OptionMembers = " ","Receipt","Transfer","Setting";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,Receipt,Transfer,Setting"', ESP = '" ,Recepci�n,Traspaso,Ajustes"';



        }
        field(5; "Location"; Code[10])
        {
            TableRelation = "Location";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Location', ESP = 'Almac�n';


        }
        field(6; "Destination Location"; Code[10])
        {
            TableRelation = "Location";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Location', ESP = 'Almac�n destino';


        }
        field(7; "Allow Ceded"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow Ceded', ESP = 'Permite cedidos';


        }
        field(8; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(9; "Service Order No."; Code[20])
        {
            TableRelation = "QB Service Order Header"."No." WHERE("Status" = FILTER(<> "Invoiced"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Service Order No.', ESP = 'N� pedido servicio';


        }
        field(10; "Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posted', ESP = 'Registrado';


        }
        field(11; "No. Serie"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Serie', ESP = 'N� serie';


        }
        field(12; "Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comments', ESP = 'Comentarios';


        }
        field(13; "Diverse Entrance"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Diverse Entrance', ESP = 'Entrada diversa';
            ;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       WarehouseSetup@1100286000 :
        WarehouseSetup: Record 5769;
        //       NoSeriesManagement@1100286001 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";


    procedure Navigate()
    var
        //       NavigateForm@1000 :
        NavigateForm: Page "Navigate";
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.RUN;
    end;

    /*begin
    end.
  */
}








table 7207442 "QBU Guarantee Lines"
{


    CaptionML = ENU = 'Lines', ESP = 'Lineas';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo';


        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;


        }
        field(10; "Line Type"; Option)
        {
            OptionMembers = "ProvSol","ProvReg","ProvDev","ProvGastos","DefSol","DefReg","DefDev","DefGastos";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo';
            OptionCaptionML = ESP = 'Provisional Solicitud,Provisional Registro,Provisional Cancelada,Provisional Gastos,Definitiva Solicitud,Definitiva registro,Definitiva Cancelada,Definitiva Gastos';



        }
        field(11; "Date"; Date)
        {
            CaptionML = ENU = 'No. Series', ESP = 'Fecha';


        }
        field(12; "Descripción"; Text[65])
        {
            CaptionML = ESP = 'Descripción';


        }
        field(13; "User"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usuario';


        }
        field(14; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe';


        }
        field(15; "Financial Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe contabilizado';


        }
        field(16; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Documento';


        }
    }
    keys
    {
        key(key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       GuaranteeLines@1100286000 :
        GuaranteeLines: Record 7207442;



    trigger OnInsert();
    begin
        GuaranteeLines.RESET;
        GuaranteeLines.SETRANGE("No.", "No.");
        if (GuaranteeLines.FINDLAST) then
            "Line No." := GuaranteeLines."Line No." + 1
        else
            "Line No." := 1;
    end;



    /*begin
        end.
      */
}








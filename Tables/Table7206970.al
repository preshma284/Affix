table 7206970 "QBU Receipt/Transfer Header"
{


    CaptionML = ENU = 'Receipt/Transfer Header Inesco', ESP = 'Cabecera Recepci�n/Traspaso Inesco';

    fields
    {
        field(1; "No."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                QuoBuildingSetup.GET;
                NoSeriesManagement.TestManual(QuoBuildingSetup."Serie for Receipt/Transfer");
            END;


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


            trigger OnValidate();
            BEGIN
                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", "No.");
                IF ReceiptTransferLine.COUNT <> 0 THEN
                    ERROR(Error002);

                ///PostReceiptTransfer.CheckType(Rec);
                IF (Type <> Type::Transfer) AND
                   ("Destination Location" <> '') THEN
                    VALIDATE("Destination Location", '');

                IF Type = Type::Setting THEN
                    "Diverse Entrance" := TRUE
                ELSE
                    "Diverse Entrance" := FALSE;

                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", "No.");
                IF ReceiptTransferLine.FINDSET THEN BEGIN
                    REPEAT
                        ReceiptTransferLine.VALIDATE("Document Type", Type);
                        ReceiptTransferLine.MODIFY(TRUE);
                    UNTIL ReceiptTransferLine.NEXT = 0;
                END;
            END;


        }
        field(5; "Location"; Code[10])
        {
            TableRelation = "Location";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Location', ESP = 'Almac�n';

            trigger OnValidate();
            BEGIN
                IF Type = Type::" " THEN
                    ERROR(Error004);

                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", "No.");
                IF ReceiptTransferLine.COUNT <> 0 THEN
                    ERROR(Error001);

                Location1.RESET;
                Location1.SETRANGE(Code, Location);
                IF Location1.FINDFIRST THEN;

                Job.RESET;
                Job.SETRANGE("No.", "Job No.");
                IF Job.FINDFIRST THEN;

                //{//SE COMENTA faltan campos tabla estandard
                //                                                                IF (Location."Allow Ceded") THEN
                //                                                                  "Allow Ceded" := TRUE
                //                                                                ELSE
                //                                                                  "Allow Ceded" := FALSE;
                //
                //                                                                IF (Location."Allow Deposit") THEN
                //                                                                  "Allow Deposit" := TRUE
                //                                                                ELSE
                //                                                                  "Allow Deposit" := FALSE;
                //                                                                }
                IF "Destination Location" <> '' THEN
                    IF "Destination Location" = Location THEN
                        ERROR(Error005);
            END;


        }
        field(6; "Destination Location"; Code[10])
        {
            TableRelation = "Location";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Location', ESP = 'Almac�n destino';

            trigger OnValidate();
            BEGIN
                IF (Type <> Type::Transfer) AND ("Destination Location" <> '') THEN
                    ERROR(Error003);

                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", "No.");
                ReceiptTransferLine.SETFILTER("Item No.", '<>%1', '');
                IF ReceiptTransferLine.COUNT <> 0 THEN
                    ERROR(Error001);

                IF "Destination Location" <> '' THEN
                    IF "Destination Location" = Location THEN
                        ERROR(Error005);

                Location2.RESET;
                Location2.SETRANGE(Code, "Destination Location");
                IF Location2.FINDFIRST THEN;

                //{//SE COMENTA faltan campos tabla estandard
                //                                                                IF (Location2."Allow Deposit") THEN
                //                                                                  "Allow Deposit" := TRUE;
                //
                //                                                                IF (Location2."Allow Ceded") THEN
                //                                                                  "Allow Ceded" := TRUE;
                //                                                                  }
            END;


        }
        field(7; "Allow Ceded"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow Ceded', ESP = 'Permite cedidos';
            Editable = false;


        }
        field(8; "Job No."; Code[20])
        {
            TableRelation = "Job";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                Location1.RESET;
                Location1.SETRANGE(Code, Location);
                IF Location1.FINDFIRST THEN;

                Job.RESET;
                Job.SETRANGE("No.", "Job No.");
                IF Job.FINDFIRST THEN;

                //{//SE COMENTA faltan campos tabla estandard
                //                                                                IF (Location."Allow Ceded") AND (Job."Allow Ceded") THEN
                //                                                                  "Allow Ceded" := TRUE
                //                                                                ELSE
                //                                                                  "Allow Ceded" := FALSE;
                //                                                                }

                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", "No.");
                IF ReceiptTransferLine.FINDSET THEN BEGIN
                    REPEAT
                        ReceiptTransferLine.VALIDATE("Document Job No.", "Job No.");
                        ReceiptTransferLine.MODIFY(TRUE);
                    UNTIL ReceiptTransferLine.NEXT = 0;
                END;
            END;


        }
        field(9; "Service Order No."; Code[20])
        {
            TableRelation = "QB Service Order Header"."No." WHERE("Job No." = FIELD("Job No."),
                                                                                                      "Status" = FILTER(<> "Invoiced"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Service Order No.', ESP = 'N� pedido servicio';

            trigger OnValidate();
            BEGIN
                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", "No.");
                IF ReceiptTransferLine.FINDSET THEN BEGIN
                    REPEAT
                        ReceiptTransferLine.VALIDATE("Service Order No.", "Service Order No.");
                        ReceiptTransferLine.MODIFY(TRUE);
                    UNTIL ReceiptTransferLine.NEXT = 0;
                END;
            END;


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


        }
        field(14; "Allow Deposit"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow Deposit', ESP = 'Permite dep�sito';
            Editable = false;


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
        //       NoSeriesManagement@1100286001 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Location1@1100286002 :
        Location1: Record 14;
        //       Location2@1100286011 :
        Location2: Record 14;
        //       Job@1100286003 :
        Job: Record 167;
        //       ReceiptTransferLine@1100286004 :
        ReceiptTransferLine: Record 7206971;
        //       Error001@1100286005 :
        Error001: TextConst ENU = 'There are lines with informed origin location.', ESP = 'Existen l�neas con almac�n origen informado.';
        //       Error002@1100286006 :
        Error002: TextConst ENU = 'It can not be modified because there are lines created.', ESP = 'No se puede modificar porque existen l�neas creadas.';
        //       PostReceiptTransfer@1100286007 :
        PostReceiptTransfer: Codeunit 7206909;
        //       Error003@1100286008 :
        Error003: TextConst ENU = 'Error, you can only indicate destination storage when the value of the type field is transfer.', ESP = 'Error, solo se puede indicar almacen destino cuando el valor del campo tipo es traspaso.';
        //       Error004@1100286009 :
        Error004: TextConst ENU = 'Error, you must select a value in the type field.', ESP = 'Error, debe seleccionar un valor en el campo tipo.';
        //       Error005@1100286010 :
        Error005: TextConst ENU = 'Error, it is not possible to indicate the same warehouse code as source and destination.', ESP = 'Error, no es posible indicar el mismo c�digo de almac�n como origen y destino.';
        //       QuoBuildingSetup@1100286012 :
        QuoBuildingSetup: Record 7207278;



    trigger OnInsert();
    begin
        if "No." = '' then begin
            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD("Serie for Receipt/Transfer");
            NoSeriesManagement.InitSeries(QuoBuildingSetup."Serie for Receipt/Transfer", xRec."No.", WORKDATE, "No.", "No. Serie");
        end;

        "Posting Date" := WORKDATE;
        User := USERID;
    end;



    // procedure AssistEdit (OldRecTrans@1100000 :
    procedure AssistEdit(OldRecTrans: Record 7206970): Boolean;
    begin
        /*To be Tested*/
        //WITH OldRecTrans DO begin
        OldRecTrans := Rec;
        //{
        //        WarehouseSetup.GET;
        //        //SE COMENTA faltan campos en tabla estandard
        //        //WarehouseSetup.TESTFIELD("Receipt/Transfer Nos.");
        //        //if NoSeriesManagement.SelectSeries(WarehouseSetup."Receipt/Transfer Nos.",OldRecTrans."No.","No.") then begin
        //          //WarehouseSetup.GET;
        //          //WarehouseSetup.TESTFIELD("Receipt/Transfer Nos.");
        //          //NoSeriesManagement.SetSeries("No.");
        //          //Rec := OldRecTrans;
        //          exit(TRUE);
        //        //end;
        //        }
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Serie for Receipt/Transfer");
        if NoSeriesManagement.SelectSeries(QuoBuildingSetup."Serie for Receipt/Transfer", OldRecTrans."No.", "No.") then begin
            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD("Serie for Receipt/Transfer");
            NoSeriesManagement.SetSeries("No.");
            Rec := OldRecTrans;
            exit(TRUE);
        end;
        //end;
    end;

    /*begin
    end.
  */
}








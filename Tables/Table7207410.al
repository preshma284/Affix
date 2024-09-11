table 7207410 "QBU Header Job Reception"
{


    CaptionML = ENU = 'Header Job Reception', ESP = 'Cabecera recepci�n proyecto';
    LookupPageID = "Job Receptions List";
    DrillDownPageID = "Job Receptions List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                PieceworkSetup.GET;
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesManagement.TestManual(PieceworkSetup."Series Jobs Reception No.");
                    "Serie No." := '';
                END;
            END;


        }
        field(2; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Status" = CONST("Open"),
                                                                            "Job Type" = CONST("Operative"));
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(3; "Assignment Date"; Date)
        {
            CaptionML = ENU = 'Assignment Date', ESP = 'Fecha asignaci�n';
            Editable = false;


        }
        field(4; "Assignment Time"; Time)
        {
            CaptionML = ENU = 'Assignment Time', ESP = 'Tiempo asignaci�n';
            Editable = false;


        }
        field(5; "Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie No.', ESP = 'No. serie';


        }
        field(6; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Vendor No.', ESP = 'No. proveedor';

            trigger OnValidate();
            BEGIN
                IF Vendor.GET("Vendor No.") THEN
                    "Vendor Name" := Vendor.Name;
            END;


        }
        field(7; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(8; "Vendor Shipment No."; Code[20])
        {
            CaptionML = ENU = 'Vendor Shipment No.', ESP = 'No. albaran proveedor';


        }
        field(9; "Vendor Name"; Text[50])
        {
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre proveedor';
            Editable = false;


        }
        field(10; "Receiving No."; Code[20])
        {
            CaptionML = ENU = 'Receiving No.', ESP = 'No. sig. albar�n compra';


        }
        field(11; "Last Receiving No."; Code[20])
        {
            TableRelation = "Posted Whse. Receipt Header";
            CaptionML = ENU = 'Last Receiving No.', ESP = 'No. ultimo albar�n compra';


        }
        field(12; "Posted"; Boolean)
        {
            CaptionML = ENU = 'Posted', ESP = 'Registrado';
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
        //       PieceworkSetup@7001100 :
        PieceworkSetup: Record 7207279;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       LineReceptionJob@7001102 :
        LineReceptionJob: Record 7207411;
        //       Text008@7001104 :
        Text008: TextConst ENU = 'The Whse. Receipt is not completely received.\Do you really want to delete the Whse. Receipt?', ESP = 'La Recep. almac�n no se ha recibido completamente.\�Desea eliminar la Recep. almac�n?';
        //       Text009@7001103 :
        Text009: TextConst ENU = 'Cancelled.', ESP = 'Cancelado.';
        //       Text000@7001105 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Vendor@7001106 :
        Vendor: Record 23;
        //       HeaderJobReception@7001107 :
        HeaderJobReception: Record 7207410;



    trigger OnInsert();
    begin
        PieceworkSetup.GET;
        if "No." = '' then begin
            PieceworkSetup.TESTFIELD("Series Jobs Reception No.");
            NoSeriesManagement.InitSeries(PieceworkSetup."Series Jobs Reception No.", xRec."Serie No.", TODAY, "No.", "Serie No.");
        end;
        "Posting Date" := WORKDATE;
    end;

    trigger OnDelete();
    begin
        DeleteRelatedLines(TRUE);
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    // procedure DeleteRelatedLines (UseTableTrigger@1001 :
    procedure DeleteRelatedLines(UseTableTrigger: Boolean)
    var
        //       Confirmed@1000 :
        Confirmed: Boolean;
    begin
        LineReceptionJob.RESET;
        LineReceptionJob.SETRANGE("No.", "No.");
        if UseTableTrigger then begin
            if LineReceptionJob.FINDSET then begin
                repeat
                    if (LineReceptionJob.Quantity <> LineReceptionJob."Outstanding Quantity") and
                       (LineReceptionJob."Outstanding Quantity" <> 0) then
                        if not CONFIRM(Text008, FALSE) then
                            ERROR(Text009)
                        else
                            Confirmed := TRUE;
                until (LineReceptionJob.NEXT = 0) or Confirmed;
                LineReceptionJob.DELETEALL;
            end;
        end else
            LineReceptionJob.DELETEALL(UseTableTrigger);
    end;

    //     procedure AssistEdit (OldHeaderJobReception@1000 :
    procedure AssistEdit(OldHeaderJobReception: Record 7207410): Boolean;
    begin
        PieceworkSetup.GET;
        /*To be Tested*/
        // WITH HeaderJobReception DO begin
        HeaderJobReception := Rec;
        PieceworkSetup.TESTFIELD(PieceworkSetup."Series Jobs Reception No.");
        if NoSeriesManagement.SelectSeries(
          PieceworkSetup."Series Jobs Reception No.", OldHeaderJobReception."Serie No.", "Serie No.")
        then begin
            NoSeriesManagement.SetSeries("No.");
            Rec := HeaderJobReception;
            exit(TRUE);
        end;
        //end;
    end;

    /*begin
    end.
  */
}








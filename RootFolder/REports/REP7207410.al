report 7207410 "QB Approval Substitute"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Approval Entry"; "Approval Entry")
        {

            DataItemTableView = SORTING("Entry No.");

            ;
            trigger OnPreDataItem();
            BEGIN
                //Solo los movimientos que est‚n activos en este momento
                "Approval Entry".SETFILTER(Status, '%1|%2', "Approval Entry".Status::Created, "Approval Entry".Status::Open);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Changed := FALSE;

                //Si no hay substituci¢n, miro si ha cambiado el aprobador del usuario y lo marco como reemplazado
                IF (NOT Changed) AND (NOT "Approval Entry"."QB Substituted") THEN BEGIN
                    ApproverID := UserSetup.GetSubstitute("Approval Entry"."Approver ID");
                    IF ("Approval Entry"."Approver ID" <> ApproverID) THEN BEGIN
                        "Approval Entry"."QB Substituted" := TRUE;
                        "Approval Entry"."QB Original Approver" := "Approval Entry"."Approver ID";
                        "Approval Entry"."Approver ID" := ApproverID;
                        "Approval Entry".MODIFY;
                        Changed := TRUE;
                    END;
                END;

                //Si hay substituci¢n, mirar si ha terminado y ponemos el usuario original
                IF (NOT Changed) AND ("Approval Entry"."QB Substituted") THEN BEGIN
                    ApproverID := UserSetup.GetSubstitute("Approval Entry"."QB Original Approver");
                    IF ("Approval Entry"."QB Original Approver" = ApproverID) THEN BEGIN
                        "Approval Entry"."QB Substituted" := FALSE;
                        "Approval Entry"."QB Original Approver" := '';
                        "Approval Entry"."Approver ID" := ApproverID;
                        "Approval Entry".MODIFY;
                        Changed := TRUE;
                    END;
                END;

                //Si hay substituci¢n, mirar si el aprobador ha cambiado por otro substituto, en ese caso reeplazamos por el nuevo
                IF (NOT Changed) AND ("Approval Entry"."QB Substituted") THEN BEGIN
                    ApproverID := UserSetup.GetSubstitute("Approval Entry"."QB Original Approver");
                    IF ("Approval Entry"."Approver ID" <> ApproverID) THEN BEGIN
                        "Approval Entry"."Approver ID" := ApproverID;
                        "Approval Entry".MODIFY;
                        Changed := TRUE;
                    END;
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       UserSetup@1100286000 :
        UserSetup: Record 91;
        //       ApproverID@1100286001 :
        ApproverID: Code[50];
        //       Changed@1100286002 :
        Changed: Boolean;
        //       Txt001@1100286003 :
        Txt001: TextConst ENU = 'Ended', ESP = 'Finalizado';



    trigger OnPostReport();
    begin
        MESSAGE(Txt001);
    end;



    /*begin
        {
          JAV 24/12/20: - QB 1.07.17 Reemplazar usuarios de aprobaci¢n por substitutos
        }
        end.
      */

}




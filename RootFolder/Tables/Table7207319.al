table 7207319 "Mov. Budget Forecast"
{


    CaptionML = ENU = 'Mov. Budget Forecast', ESP = 'Mov. previsi�n ppto.';
    DrillDownPageID = "Budget Forecast Mov. CA";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';


        }
        field(3; "Anality Concept Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Anality Concept Code', ESP = 'Cod. concepto anal�tico';

            trigger OnValidate();
            VAR
                //                                                                 FunctionQB@7001100 :
                FunctionQB: Codeunit 7207272;
            BEGIN
                FunctionQB.ValidateCA("Anality Concept Code");
            END;

            trigger OnLookup();
            BEGIN
                FunctionQB.LookUpCA(codeca, FALSE);
            END;


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Forecast Date"; Date)
        {
            CaptionML = ENU = 'Forecast Date', ESP = 'Fecha previsi�n';


        }
        field(6; "Outstanding Temporary Forecast"; Decimal)
        {


            CaptionML = ENU = 'Outstanding Temporary Forecast', ESP = 'Previsi�n temp. del pdte.';

            trigger OnValidate();
            VAR
                //                                                                 ReestimationHeader@7001100 :
                ReestimationHeader: Record 7207315;
            BEGIN
                ReestimationHeader.GET("Document No.");
                IF "Forecast Date" = 0D THEN
                    "Forecast Date" := ReestimationHeader."Reestimation Date";
            END;


        }
        field(7; "User ID"; Code[50])
        {
            TableRelation = "User"; //User


            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               UserManagement@7001100 :
                UserManagement: Codeunit "User Management 1";
            BEGIN
                UserManagement.LookupUserID("User ID");
            END;


        }
        field(8; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'No. mov.';


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(10; "Reestimation code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Reestimation code', ESP = 'Cod. reestimaci�n';

            trigger OnLookup();
            VAR
                //                                                               DimensionValue@7001100 :
                DimensionValue: Record 349;
            BEGIN
                IF FunctionQB.LookUpReest(DimensionValue."Dimension Code", FALSE) THEN
                    VALIDATE("Reestimation code", DimensionValue."Dimension Code");
            END;


        }
        field(11; "Assigned %"; Decimal)
        {
            CaptionML = ENU = 'Assigned %', ESP = '% asignado';
            ;


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Job No.", "Document No.", "Line No.", "Anality Concept Code", "Reestimation code")
        {
            SumIndexFields = "Outstanding Temporary Forecast", "Assigned %";
        }
        key(key3; "Job No.", "Document No.", "Line No.", "Anality Concept Code", "Reestimation code", "Forecast Date")
        {
            SumIndexFields = "Outstanding Temporary Forecast", "Assigned %";
        }
    }
    fieldgroups
    {
    }

    var
        //       Text000@7001100 :
        Text000: TextConst ENU = 'Percentage', ESP = 'Porcentaje';
        //       FunctionQB@7001101 :
        FunctionQB: Codeunit 7207272;
        //       codeca@7001102 :
        codeca: Code[20];




    trigger OnInsert();
    begin
        if "Assigned %" <> 0 then begin
            "User ID" := Text000;
        end;
    end;



    /*begin
        end.
      */
}








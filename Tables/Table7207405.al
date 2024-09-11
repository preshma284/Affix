table 7207405 "QBU Objectives Line Detailed"
{


    CaptionML = ENU = 'Objectives Line Detailed', ESP = 'Detalle del objetivo';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(2; "Budget Code"; Code[20])
        {
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Code', ESP = 'Cod. presupuesto';


        }
        field(3; "Line Type"; Option)
        {
            OptionMembers = "Sales","DirectCost","IndirectCost";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line Type', ESP = 'Tipo l�nea';
            OptionCaptionML = ENU = 'Sales,Cost', ESP = 'Venta,Coste Directo,Coste Indirecto';

            Editable = false;


        }
        field(4; "Record No."; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Record No.', ESP = 'No. expediente';
            Editable = false;


        }
        field(5; "Piecework"; Code[20])
        {
            TableRelation = IF ("Line Type" = CONST("Sales")) "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."), "Budget Filter" = FIELD("Budget Code"), "Customer Certification Unit" = CONST(true)) ELSE IF ("Line Type" = FILTER('DirectCost' | 'IndirectCost')) "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."), "Budget Filter" = FIELD("Budget Code"), "Production Unit" = CONST(true));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.O.';


        }
        field(6; "Entry Date"; Date)
        {
            CaptionML = ENU = 'Entry Date', ESP = 'Fecha movimiento';


        }
        field(13; "Improvement"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Improvement', ESP = 'Mejora';

            trigger OnValidate();
            BEGIN
                VALIDATE(Probability);
            END;


        }
        field(14; "Probability"; Option)
        {
            OptionMembers = "A","M","B";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Probability', ESP = 'Probabilidad';
            OptionCaptionML = ENU = 'High,Average,Low', ESP = 'Alta,Media,Baja';


            trigger OnValidate();
            BEGIN
                PieceworkSetup.GET;
                CASE Probability OF
                    Probability::A:
                        "% Probability" := PieceworkSetup."Objective % High";
                    Probability::M:
                        "% Probability" := PieceworkSetup."Objective % Medium";
                    Probability::B:
                        "% Probability" := PieceworkSetup."Objective % Low";
                END;

                IF ("Line Type" = "Line Type"::Sales) THEN
                    "Improvement Amount" := ROUND((Improvement * "% Probability" / 100), 0.01)
                ELSE
                    "Improvement Amount" := -ROUND((Improvement * "% Probability" / 100), 0.01);
            END;


        }
        field(15; "Improvement Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Improvement Amount', ESP = 'Importe Mejora';
            Editable = false;


        }
        field(16; "% Probability"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Probability', ESP = '% Probabilidad';
            Editable = false;


        }
        field(20; "Comments"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comments', ESP = 'Comentarios';


        }
        field(21; "Comments Size"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Longitud';


        }
    }
    keys
    {
        key(key1; "Job No.", "Budget Code", "Line Type", "Record No.", "Piecework", "Entry Date")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       PieceworkSetup@1100286000 :
        PieceworkSetup: Record 7207279;
        //       TempBlob@1100286003 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       CR@1100286002 :
        CR: Text;

    procedure GetComment(): Text;
    begin
        CALCFIELDS(Comments);
        if not Comments.HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := Comments;
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(Comments);
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;

    //     procedure SetComment (pText@1100286000 :
    procedure SetComment(pText: Text)
    begin
        // TempBlob.WriteAsText(pText, TEXTENCODING::Windows);
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(pText);
        // Comments := TempBlob.Blob;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(Comments);
        "Comments Size" := Comments.LENGTH;
        if not MODIFY then
            INSERT;
    end;

    /*begin
    end.
  */
}








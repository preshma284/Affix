table 7207404 "QB Objectives Line"
{


    CaptionML = ENU = 'L�ne Card APM', ESP = 'L�neas ficha APM';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(2; "Budget Code"; Code[20])
        {
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Budget Code', ESP = 'Cod. presupuesto';


        }
        field(3; "Line Type"; Option)
        {
            OptionMembers = "Sales","DirectCost","IndirectCost";
            CaptionML = ENU = 'Line Type', ESP = 'Tipo l�nea';
            OptionCaptionML = ENU = 'Sales,Cost', ESP = 'Venta,Coste Directo,Coste Indirecto';

            Editable = false;


        }
        field(4; "Record No."; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Record No.', ESP = 'No. expediente';
            Editable = false;

            trigger OnValidate();
            BEGIN
                QBObjectivesHeader.GET("Job No.", "Budget Code");

                //JAV 19/10/21: - QB 1.09.22 Se cambia la forma de obtener el importe del expediente
                Records.GET("Job No.", "Record No.");
                Approved := Records.SaleAmount(0);

                DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                DataPieceworkForProduction.SETRANGE("No. Record", "Record No.");
                DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                Executed := 0;
                IF DataPieceworkForProduction.FINDSET(FALSE) THEN
                    REPEAT
                        GetIncomingAmounts("Job No.", DataPieceworkForProduction."Piecework Code", "Budget Code", QBObjectivesHeader."Budget Date", BudgetJob, JobExecuted);
                        //Approved += BudgetJob;
                        Executed += JobExecuted;
                    UNTIL DataPieceworkForProduction.NEXT = 0;

                VALIDATE(Approved);
                VALIDATE(Executed);
            END;


        }
        field(5; "Piecework"; Code[20])
        {
            TableRelation = IF ("Line Type" = CONST("Sales")) "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."), "Budget Filter" = FIELD("Budget Code"), "Customer Certification Unit" = CONST(true)) ELSE IF ("Line Type" = FILTER('DirectCost' | 'IndirectCost')) "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."), "Budget Filter" = FIELD("Budget Code"), "Production Unit" = CONST(true));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.O.';

            trigger OnValidate();
            BEGIN
                QBObjectivesHeader.GET("Job No.", "Budget Code");

                DataPieceworkForProduction.GET("Job No.", Piecework);
                IF ("Line Type" = "Line Type"::Sales) THEN BEGIN
                    "Record No." := DataPieceworkForProduction."No. Record";
                    IF ("Record No." = '') THEN
                        "Record No." := '~SIN EXPEDIENTE';

                    GetIncomingAmounts("Job No.", DataPieceworkForProduction."Piecework Code", "Budget Code", QBObjectivesHeader."Budget Date", BudgetJob, JobExecuted);
                    VALIDATE(Approved, BudgetJob);
                    VALIDATE(Executed, JobExecuted);
                END ELSE BEGIN
                    IF (DataPieceworkForProduction.Type <> DataPieceworkForProduction.Type::"Cost Unit") THEN
                        "Line Type" := "Line Type"::DirectCost
                    ELSE
                        "Line Type" := "Line Type"::IndirectCost;

                    GetCostAmounts("Job No.", DataPieceworkForProduction."Piecework Code", "Budget Code", QBObjectivesHeader."Budget Date", BudgetJob, JobExecuted);
                    VALIDATE(Approved, BudgetJob);
                    VALIDATE(Executed, JobExecuted);

                END;
            END;


        }
        field(10; "Approved"; Decimal)
        {


            CaptionML = ENU = 'Approved', ESP = 'Aprobado';
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE(Pending);
                VALIDATE(Objective);
            END;


        }
        field(11; "Executed"; Decimal)
        {


            CaptionML = ENU = 'Executed', ESP = 'Ejecutado';
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE(Pending);
            END;


        }
        field(12; "Pending"; Decimal)
        {


            CaptionML = ENU = 'Pending', ESP = 'Pendiente';
            Editable = false;

            trigger OnValidate();
            BEGIN
                Pending := Approved - Executed;
            END;


        }
        field(13; "Improvement"; Decimal)
        {


            CaptionML = ENU = 'Improvement', ESP = 'Mejora';

            trigger OnValidate();
            BEGIN
                VALIDATE(Probability);
            END;


        }
        field(14; "Probability"; Option)
        {
            OptionMembers = "High","Average","Low";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Probability', ESP = 'Probabilidad';
            OptionCaptionML = ENU = 'High,Average,Low', ESP = 'Alta,Media,Baja';


            trigger OnValidate();
            BEGIN
                PieceworkSetup.GET;
                CASE Probability OF
                    Probability::High:
                        "% Probability" := PieceworkSetup."Objective % High";
                    Probability::Average:
                        "% Probability" := PieceworkSetup."Objective % Medium";
                    Probability::Low:
                        "% Probability" := PieceworkSetup."Objective % Low";
                END;

                IF ("Line Type" = "Line Type"::Sales) THEN
                    "Improvement Amount" := ROUND((Improvement * "% Probability" / 100), 0.01)
                ELSE
                    "Improvement Amount" := -ROUND((Improvement * "% Probability" / 100), 0.01);

                IF (Approved >= Executed) THEN
                    Objective := Approved + "Improvement Amount"
                ELSE
                    Objective := Executed + "Improvement Amount";     //Si hemos ejecutado mas de lo aprobado, nuestro objetivo debe ser sobre este importe
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
        field(17; "Objective"; Decimal)
        {
            CaptionML = ENU = 'Objective', ESP = 'Objetivo';
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
        field(22; "Have Detailed Lines"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Objectives Line Detailed" WHERE("Job No." = FIELD("Job No."),
                                                                                                          "Budget Code" = FIELD("Budget Code"),
                                                                                                          "Line Type" = FIELD("Line Type"),
                                                                                                          "Record No." = FIELD("Record No."),
                                                                                                          "Piecework" = FIELD("Piecework")));
            CaptionML = ESP = 'L�neas Detalladas';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Job No.", "Budget Code", "Line Type", "Record No.", "Piecework")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBObjectivesHeader@1100286006 :
        QBObjectivesHeader: Record 7207403;
        //       PieceworkSetup@1100286003 :
        PieceworkSetup: Record 7207279;
        //       JobBudget@7001101 :
        JobBudget: Record 7207407;
        //       DataPieceworkForProduction@7001102 :
        DataPieceworkForProduction: Record 7207386;
        //       Records@1100286001 :
        Records: Record 7207393;
        //       TempBlob@1100286000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       CR@1100286002 :
        CR: Text;
        //       BudgetJob@1100286004 :
        BudgetJob: Decimal;
        //       JobExecuted@1100286005 :
        JobExecuted: Decimal;

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

    //     LOCAL procedure GetIncomingAmounts (pJob@1100286000 : Code[20];pPiecework@1100286001 : Code[20];pBudget@1100286003 : Code[20];pDate@1100286002 : Date;var AmAproved@1100286004 : Decimal;var AmExecuted@1100286005 :
    LOCAL procedure GetIncomingAmounts(pJob: Code[20]; pPiecework: Code[20]; pBudget: Code[20]; pDate: Date; var AmAproved: Decimal; var AmExecuted: Decimal)
    begin
        DataPieceworkForProduction.GET(pJob, pPiecework);
        DataPieceworkForProduction.SETRANGE("Budget Filter", pBudget);
        DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
        AmAproved := DataPieceworkForProduction."Amount Production Budget";

        DataPieceworkForProduction.SETFILTER("Filter Date", '..%1', pDate);
        DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
        AmExecuted := DataPieceworkForProduction."Amount Production Performed";
    end;

    //     LOCAL procedure GetCostAmounts (pJob@1100286000 : Code[20];pPiecework@1100286001 : Code[20];pBudget@1100286003 : Code[20];pDate@1100286002 : Date;var AmAproved@1100286004 : Decimal;var AmExecuted@1100286005 :
    LOCAL procedure GetCostAmounts(pJob: Code[20]; pPiecework: Code[20]; pBudget: Code[20]; pDate: Date; var AmAproved: Decimal; var AmExecuted: Decimal)
    begin
        DataPieceworkForProduction.GET(pJob, pPiecework);
        DataPieceworkForProduction.SETRANGE("Budget Filter", pBudget);
        DataPieceworkForProduction.SETFILTER("Filter Date", '..%1', pDate);
        DataPieceworkForProduction.CALCFIELDS("Amount Production Budget", "Amount Cost Performed (JC)");

        AmAproved := DataPieceworkForProduction."Amount Production Budget";
        AmExecuted := DataPieceworkForProduction."Amount Cost Performed (JC)";
    end;

    /*begin
    //{
//      JAV 19/10/21: - QB 1.09.22 Se cambia la forma de obtener el importe del expediente
//    }
    end.
  */
}








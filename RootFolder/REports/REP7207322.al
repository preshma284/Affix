report 7207322 "Create Piecework Prod. Budget"
{


    CaptionML = ENU = 'Create Piecework Prod. Budget', ESP = 'Crear ppto producci¢n UO';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Data Piecework For Production"; "Data Piecework For Production")
        {

            DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Customer Certification Unit" = CONST(true));

            ;
            trigger OnPreDataItem();
            BEGIN
                IF "Data Piecework For Production".GETFILTER("Job No.") = '' THEN
                    ERROR(Text50000);
                JobFilter := "Data Piecework For Production".GETFILTER("Job No.");
                Job.GET(JobFilter);

                IF Job."Separation Job Unit/Cert. Unit" THEN
                    ERROR(Text50007);

                //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                    Job.TESTFIELD("Initial Budget Piecework");


                Job.JobStatus(Job."No.");
                DataPieceworkForProduction.SETRANGE("Job No.", JobFilter);
                DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    IF NOT CONFIRM(Text50001) THEN BEGIN
                        MESSAGE(Text50002);
                        CurrReport.BREAK;
                    END;
                END;

                //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                    "Data Piecework For Production".SETRANGE("Budget Filter", Job."Initial Budget Piecework");
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF NOT "Data Piecework For Production"."Production Unit" THEN BEGIN
                    "Data Piecework For Production"."Production Unit" := TRUE;
                    IF "Data Piecework For Production".Type = "Data Piecework For Production".Type::Piecework THEN
                        "Data Piecework For Production".Plannable := TRUE;

                    IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                        "Data Piecework For Production".VALIDATE("Budget Measure", "Data Piecework For Production"."Sale Quantity (base)");
                        "Data Piecework For Production".VALIDATE("Data Piecework For Production"."Initial Produc. Price",
                                                                 "Data Piecework For Production"."Unit Price Sale (base)");

                        "Data Piecework For Production".MODIFY;
                        IF IncludeLineMeasure THEN BEGIN
                            ManagementLineofMeasure."GetLinMeasureCertif/Prod"("Data Piecework For Production"."Job No.",
                                                                                 "Data Piecework For Production"."Piecework Code",
                                                                                 "Data Piecework For Production"."Piecework Code");
                        END;
                        IF "Data Piecework For Production"."Code Cost Database" <> '' THEN BEGIN
                            BillofItemData.SETRANGE("Cod. Cost database", "Data Piecework For Production"."Code Cost Database");
                            BillofItemData.SETRANGE("Cod. Piecework", "Data Piecework For Production"."Piecework Code");
                            IF BillofItemData.FINDSET(FALSE, FALSE) THEN BEGIN
                                REPEAT
                                    CLEAR(DataCostByPiecework);
                                    DataCostByPiecework.VALIDATE("Job No.", "Data Piecework For Production"."Job No.");
                                    DataCostByPiecework.VALIDATE("Piecework Code", "Data Piecework For Production"."Piecework Code");

                                    //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                                    IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                                        DataCostByPiecework.VALIDATE("Cod. Budget", Job."Initial Budget Piecework");

                                    DataCostByPiecework.VALIDATE("Cost Type", BillofItemData.Type);
                                    DataCostByPiecework.VALIDATE("No.", BillofItemData."No.");
                                    DataCostByPiecework.INSERT(TRUE);
                                    DataCostByPiecework."Analytical Concept Direct Cost" := BillofItemData."Concep. Analytical Direct Cost";
                                    DataCostByPiecework.VALIDATE("Performance By Piecework", BillofItemData."Quantity By");
                                    DataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)", BillofItemData."Direct Unit Cost");
                                    DataCostByPiecework."Piecework Code" := BillofItemData."Units of Measure";
                                    DataCostByPiecework."Analytical Concept Ind. Cost" := BillofItemData."Concep. Anal. Indirect Cost";
                                    DataCostByPiecework.VALIDATE("Indirect Unit Cost", BillofItemData."Unit Cost Indirect");


                                    IF NOT Job."Use Unit Price Ratio" THEN BEGIN
                                        DataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)", BillofItemData."Direct Unit Cost");
                                        DataCostByPiecework.VALIDATE("Indirect Unit Cost", BillofItemData."Unit Cost Indirect");
                                    END;


                                    DataCostByPiecework."Code Cost Database" := BillofItemData."Cod. Cost database";
                                    DataCostByPiecework."Unique Code" := "Data Piecework For Production"."Unique Code";
                                    DataCostByPiecework.MODIFY(TRUE);
                                UNTIL BillofItemData.NEXT = 0;
                            END;
                            //Copio los comentarios asociados si existen
                            CommentLine.RESET;
                            //Verify
                            //CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"14");
                            CommentLine.SETRANGE("Table Name", 14);
                            CommentLine.SETRANGE("No.", "Data Piecework For Production"."Unique Code");
                            IF CommentLine.FINDSET(TRUE, TRUE) THEN BEGIN
                                REPEAT
                                    CommentLine2.INIT;
                                    CommentLine2.TRANSFERFIELDS(CommentLine);
                                    //verify
                                    // CommentLine2."Table Name" := CommentLine2."Table Name"::"15";
                                    CommentLine2."Table Name" := 15;
                                    CommentLine2."No." := "Data Piecework For Production"."Unique Code";
                                    IF CommentLine2.INSERT(TRUE) THEN;
                                UNTIL CommentLine.NEXT = 0;
                            END;
                            //Copio las dimensiones si existen
                            DefaultDimension.RESET;
                            DefaultDimension.SETRANGE("Table ID", DATABASE::Piecework);
                            DefaultDimension.SETRANGE("No.", "Data Piecework For Production"."Unique Code");
                            IF DefaultDimension.FINDSET(FALSE, FALSE) THEN BEGIN
                                REPEAT
                                    DefaultDimension2.INIT;
                                    DefaultDimension2.TRANSFERFIELDS(DefaultDimension);
                                    DefaultDimension2."Table ID" := DATABASE::"Data Piecework For Production";
                                    DefaultDimension2."No." := "Data Piecework For Production"."Unique Code";
                                    DefaultDimension2.INSERT(TRUE);
                                UNTIL DefaultDimension.NEXT = 0;
                            END;
                        END;
                        "Data Piecework For Production".VALIDATE("Data Piecework For Production"."Initial Produc. Price",
                                                                 "Data Piecework For Production"."Unit Price Sale (base)");

                    END;
                    "Data Piecework For Production".MODIFY;
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                Job.CALCFIELDS("Amou Piecework Meas./Certifi.");
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group489")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("IncludeLineMeasure"; "IncludeLineMeasure")
                    {

                        CaptionML = ENU = 'Include Line Bill of Item', ESP = 'Incluir descompuesto de l¡nea';
                    }
                    field("TextAdditional"; "TextAdditional")
                    {

                        CaptionML = ENU = 'Take Addicional Text', ESP = 'Llevar textos adicionales';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Text50000@7001102 :
        Text50000: TextConst ENU = 'You must select a job to perform this task', ESP = 'Debe seleccionar un proyecto para ejecutar esta tarea';
        //       Text50001@7001101 :
        Text50001: TextConst ENU = 'There is already a production budget. Do you want to continue with the creation of new piecework?', ESP = 'Existe ya un presupuesto de produccion. ¨Desea continuar con la creaci¢n de nuevas Unidades de obra?';
        //       Text50002@7001100 :
        Text50002: TextConst ENU = 'The process of creating certification and measurement budget has been canceled', ESP = 'Se ha cancelado el proceso de creaci¢n de presupuesto de certificaci¢n y medici¢n';
        //       Text50007@7001103 :
        Text50007: TextConst ENU = 'Can not assign production data to project with unit separation', ESP = 'No se puede asignar datos de producci¢n para proyecto con separaci¢n de unidades';
        //       JobFilter@7001104 :
        JobFilter: Code[20];
        //       Job@7001105 :
        Job: Record 167;
        //       DataPieceworkForProduction@7001106 :
        DataPieceworkForProduction: Record 7207386;
        //       IncludeLineMeasure@7001107 :
        IncludeLineMeasure: Boolean;
        //       ManagementLineofMeasure@7001108 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       BillofItemData@7001109 :
        BillofItemData: Record 7207384;
        //       DataCostByPiecework@7001110 :
        DataCostByPiecework: Record 7207387;
        //       CommentLine@7001111 :
        CommentLine: Record 97;
        //       CommentLine2@7001112 :
        CommentLine2: Record 97;
        //       DefaultDimension@7001113 :
        DefaultDimension: Record 352;
        //       DefaultDimension2@7001114 :
        DefaultDimension2: Record 352;
        //       Currency@7001115 :
        Currency: Record 4;
        //       TextAdditional@7001116 :
        TextAdditional: Boolean;
        //       ExtendedTextHeader@7001117 :
        ExtendedTextHeader: Record 279;
        //       ExtendedTextLine@7001118 :
        ExtendedTextLine: Record 280;

    /*begin
    end.
  */

}




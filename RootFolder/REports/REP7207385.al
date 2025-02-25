report 7207385 "Production Data Initialize"
{


    CaptionML = ENU = 'Production Data Initialize', ESP = 'Inicializar datos producci¢n';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Data Piecework For Production"; "Data Piecework For Production")
        {

            DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Customer Certification Unit" = CONST(true));
            ;
            DataItem("QB Text"; "QB Text")
            {

                DataItemTableView = SORTING("Table")
                                 WHERE("Table" = CONST("Certificacion"));
                DataItemLink = "Key1" = FIELD("Job No."),
                            "Key2" = FIELD("Piecework Code");
                trigger OnPreDataItem();
                BEGIN
                    IF NOT TextAdditional THEN
                        CurrReport.BREAK;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    QBText.CopyTo("QB Text".Table, "QB Text".Key1, "QB Text".Key2, '',
                                  QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code", '');
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IF "Data Piecework For Production".GETFILTER("Job No.") = '' THEN
                    ERROR(Text000);
                FilterJob := "Data Piecework For Production".GETFILTER("Job No.");
                Job.GET(FilterJob);

                //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN BEGIN
                    Job.TESTFIELD("Initial Budget Piecework");
                    IF NOT Job."Separation Job Unit/Cert. Unit" THEN
                        ERROR(Text007);
                END;

                Job.JobStatus(Job."No.");
                IF Initialize THEN BEGIN
                    DataPieceworkForProduction.SETRANGE("Job No.", FilterJob);
                    DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework);
                    DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
                    IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                        IF NOT CONFIRM(Text001) THEN BEGIN
                            MESSAGE(Text002);
                            CurrReport.BREAK;
                        END
                        ELSE BEGIN
                            DataPieceworkForProduction.DELETEALL(TRUE);
                        END;
                    END;
                END ELSE BEGIN
                    IF NOT CONFIRM(Text008) THEN BEGIN
                        MESSAGE(Text002);
                        CurrReport.BREAK;
                    END
                END;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF (NOT Initialize) AND (DataPieceworkForProduction.GET("Data Piecework For Production"."Job No.",
                                             'P' + "Data Piecework For Production"."Piecework Code")) THEN
                    CurrReport.SKIP;

                DataPieceworkForProduction := "Data Piecework For Production";
                DataPieceworkForProduction."Production Unit" := TRUE;
                DataPieceworkForProduction."Customer Certification Unit" := FALSE;
                DataPieceworkForProduction."Piecework Code" := 'P' + DataPieceworkForProduction."Piecework Code";
                DataPieceworkForProduction.Plannable := TRUE;
                DataPieceworkForProduction.INSERT(TRUE);
                //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                    DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Initial Budget Piecework");

                IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                    IF DataPieceworkForProductionOffer.GET(Job."Original Quote Code",
                               "Data Piecework For Production"."Piecework Code") THEN BEGIN
                        //DataPieceworkForProduction.VALIDATE("Budget Measure","Data Piecework For Production"."Sales Amount (Base)");
                        DataPieceworkForProduction.VALIDATE("Budget Measure", "Data Piecework For Production"."Sale Quantity (base)");
                        DataPieceworkForProduction.VALIDATE("Initial Produc. Price",
                                                                 "Data Piecework For Production"."Unit Price Sale (base)");

                        DataPieceworkForProduction.MODIFY;
                        IF IncludeMeasureLines THEN BEGIN
                            ManagementLineofMeasure."GetLinMeasureCertif/Prod"("Data Piecework For Production"."Job No.",
                                                                                 "Data Piecework For Production"."Piecework Code",
                                                                                 DataPieceworkForProduction."Piecework Code");
                        END;

                        DataCostByPieceworkOffer.SETRANGE("Job No.", DataPieceworkForProductionOffer."Job No.");
                        DataCostByPieceworkOffer.SETRANGE("Piecework Code", DataPieceworkForProductionOffer."Piecework Code");
                        IF DataCostByPieceworkOffer.FINDSET THEN BEGIN
                            REPEAT
                                CLEAR(DataCostByPiecework);
                                DataCostByPiecework := DataCostByPieceworkOffer;
                                DataCostByPiecework."Job No." := DataPieceworkForProduction."Job No.";
                                DataCostByPiecework."Piecework Code" := DataPieceworkForProduction."Piecework Code";

                                //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                                IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                                    DataCostByPiecework.VALIDATE("Cod. Budget", Job."Initial Budget Piecework");

                                DataCostByPiecework.INSERT(TRUE);

                                QBText.CopyTo(QBText.Table::Job, DataCostByPieceworkOffer."Job No.", DataCostByPieceworkOffer."Piecework Code", DataCostByPieceworkOffer."No.",
                                              QBText.Table::Job, DataCostByPiecework."Job No.", DataCostByPiecework."Piecework Code", DataCostByPiecework."No.");

                            UNTIL DataCostByPieceworkOffer.NEXT = 0;
                        END;
                        // Copio los comentarios asociados si existen
                        CommentLine.RESET;
                        //CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"15");
                        CommentLine.SETRANGE("Table Name", 15);
                        CommentLine.SETRANGE("No.", DataPieceworkForProductionOffer."Unique Code");
                        IF CommentLine.FINDSET THEN BEGIN
                            REPEAT
                                CommentLine2.INIT;
                                CommentLine2.TRANSFERFIELDS(CommentLine);
                                // CommentLine2."Table Name" := CommentLine2."Table Name"::"15";
                                CommentLine2."Table Name" := 15;
                                CommentLine2."No." := DataPieceworkForProduction."Unique Code";
                                IF CommentLine2.INSERT(TRUE) THEN;
                            UNTIL CommentLine.NEXT = 0;
                        END;
                        //Copio las dimensiones si existen
                        DefaultDimension.RESET;
                        DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
                        DefaultDimension.SETRANGE("No.", DataPieceworkForProductionOffer."Unique Code");
                        IF DefaultDimension.FINDSET THEN BEGIN
                            REPEAT
                                DefaultDimension.INIT;
                                DefaultDimension2.TRANSFERFIELDS(DefaultDimension);
                                DefaultDimension2."Table ID" := DATABASE::"Data Piecework For Production";
                                DefaultDimension2."No." := DataPieceworkForProduction."Unique Code";
                                DefaultDimension2.INSERT(TRUE);
                            UNTIL DefaultDimension.NEXT = 0;
                        END;

                        DataPieceworkForProduction.VALIDATE("Initial Produc. Price",
                                                                 "Data Piecework For Production"."Unit Price Sale (base)");
                        RelCertificationProduct.INIT;
                        RelCertificationProduct."Job No." := "Data Piecework For Production"."Job No.";
                        RelCertificationProduct."Production Unit Code" := DataPieceworkForProduction."Piecework Code";
                        RelCertificationProduct.VALIDATE("Certification Unit Code", "Data Piecework For Production"."Piecework Code");
                        RelCertificationProduct.INSERT;
                    END ELSE BEGIN
                        IF (Piecework.GET("Data Piecework For Production"."Code Cost Database",
                            "Data Piecework For Production"."Piecework Code")) THEN BEGIN
                            IF (Piecework."Account Type" = Piecework."Account Type"::Unit) THEN BEGIN
                                //JMMA DataPieceworkForProduction.VALIDATE("Budget Measure","Data Piecework For Production"."Sales Amount (Base)");
                                DataPieceworkForProduction.VALIDATE("Budget Measure", "Data Piecework For Production"."Sale Quantity (base)");
                                DataPieceworkForProduction.VALIDATE("Initial Produc. Price",
                                                                         "Data Piecework For Production"."Unit Price Sale (base)");

                                DataPieceworkForProduction.MODIFY;
                                IF IncludeMeasureLines THEN BEGIN
                                    ManagementLineofMeasure."GetLinMeasureCertif/Prod"("Data Piecework For Production"."Job No.",
                                                                                         "Data Piecework For Production"."Piecework Code",
                                                                                         DataPieceworkForProduction."Piecework Code");
                                END;

                                BillofItemData.SETRANGE("Cod. Cost database", "Data Piecework For Production"."Code Cost Database");
                                BillofItemData.SETRANGE("Cod. Piecework", "Data Piecework For Production"."Piecework Code");
                                IF BillofItemData.FINDSET THEN BEGIN
                                    REPEAT
                                        CLEAR(DataCostByPiecework);
                                        DataCostByPiecework.VALIDATE("Job No.", "Data Piecework For Production"."Job No.");
                                        DataCostByPiecework.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");

                                        //JAV 01/12/20: - QB 1.07.08 Si es un estudio, no hay presupuesto y debe quedar en blanco
                                        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                                            DataCostByPiecework.VALIDATE("Cod. Budget", Job."Initial Budget Piecework");

                                        DataCostByPiecework.VALIDATE("Cost Type", BillofItemData.Type);
                                        DataCostByPiecework.VALIDATE("No.", BillofItemData."No.");
                                        DataCostByPiecework.INSERT(TRUE);
                                        DataCostByPiecework."Analytical Concept Direct Cost" := BillofItemData."Concep. Analytical Direct Cost";
                                        DataCostByPiecework.VALIDATE("Performance By Piecework", BillofItemData."Quantity By");
                                        //DataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)",BillofItemData."Direct Unit Cost");
                                        DataCostByPiecework.SetOnChange;//JMMA 12/11/20
                                        DataCostByPiecework.VALIDATE("Direc Unit Cost", BillofItemData."Direct Unit Cost");
                                        DataCostByPiecework."Cod. Measure Unit" := BillofItemData."Units of Measure";
                                        DataCostByPiecework."Analytical Concept Ind. Cost" := BillofItemData."Concep. Anal. Indirect Cost";
                                        DataCostByPiecework.VALIDATE("Indirect Unit Cost", BillofItemData."Unit Cost Indirect");
                                        DataCostByPiecework."Code Cost Database" := BillofItemData."Cod. Cost database";
                                        DataCostByPiecework."Unique Code" := DataPieceworkForProduction."Unique Code";
                                        DataCostByPiecework.MODIFY(TRUE);
                                    UNTIL BillofItemData.NEXT = 0;
                                END;
                                //Copio los comentarios asociados si existen
                                CommentLine.RESET;
                                // CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"14");
                                CommentLine.SETRANGE("Table Name", 14);
                                CommentLine.SETRANGE("No.", "Data Piecework For Production"."Unique Code");
                                IF CommentLine.FINDSET THEN BEGIN
                                    REPEAT
                                        CommentLine2.INIT;
                                        CommentLine2.TRANSFERFIELDS(CommentLine);
                                        // CommentLine2."Table Name" := CommentLine2."Table Name"::"15";
                                        CommentLine2."Table Name" := 15;
                                        CommentLine2."No." := DataPieceworkForProduction."Unique Code";
                                        IF CommentLine2.INSERT(TRUE) THEN;
                                    UNTIL CommentLine.NEXT = 0;
                                END;
                                //Copio las dimensiones si existen
                                DefaultDimension.RESET;
                                DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
                                DefaultDimension.SETRANGE("No.", "Data Piecework For Production"."Unique Code");
                                IF DefaultDimension.FINDSET THEN BEGIN
                                    REPEAT
                                        DefaultDimension2.INIT;
                                        DefaultDimension2.TRANSFERFIELDS(DefaultDimension);
                                        DefaultDimension2."Table ID" := DATABASE::"Data Piecework For Production";
                                        DefaultDimension2."No." := DataPieceworkForProduction."Unique Code";
                                        DefaultDimension2.INSERT(TRUE);
                                    UNTIL DefaultDimension.NEXT = 0;
                                END;

                                DataPieceworkForProduction.VALIDATE("Initial Produc. Price",
                                                                         "Data Piecework For Production"."Sales Amount (Base)");
                                RelCertificationProduct.INIT;
                                RelCertificationProduct."Job No." := "Data Piecework For Production"."Job No.";
                                RelCertificationProduct."Production Unit Code" := DataPieceworkForProduction."Piecework Code";
                                RelCertificationProduct.VALIDATE("Certification Unit Code", "Data Piecework For Production"."Piecework Code");
                                RelCertificationProduct.INSERT;
                            END ELSE BEGIN
                                PieceworkP.SETRANGE("Cost Database Default", "Data Piecework For Production"."Code Cost Database");
                                PieceworkP.SETFILTER("No.", Piecework.Totaling);
                                IF PieceworkP.FINDSET THEN BEGIN
                                    First := TRUE;
                                    DataPieceworkForProduction."Account Type" := Piecework."Account Type";
                                    DataPieceworkForProduction.Totaling := DataPieceworkForProduction."Piecework Code" + '..' +
                                                                     DataPieceworkForProduction."Piecework Code" +
                                                                     PADSTR('', 20 - STRLEN(DataPieceworkForProduction."Piecework Code"), '9');
                                    DataPieceworkForProduction.MODIFY;
                                    REPEAT
                                        IF PieceworkP."No." <> Piecework."No." THEN BEGIN
                                            CLEAR(BringCostDatabase);
                                            BringCostDatabase.GatherDate("Job No.", '');
                                            BringCostDatabase.StartDataDistinction('P', PieceworkP."No.",
                                                                                             PieceworkP."Cost Database Default",
                                                                                             TRUE, IncludeMeasureLines);
                                            BringCostDatabase.USErequestpage(FALSE);
                                            BringCostDatabase.RUNMODAL;
                                            IF First THEN BEGIN
                                                First := FALSE;
                                                RelCertificationProduct.INIT;
                                                RelCertificationProduct."Job No." := "Data Piecework For Production"."Job No.";
                                                RelCertificationProduct."Production Unit Code" := 'P' + PieceworkP."No.";
                                                RelCertificationProduct.VALIDATE("Certification Unit Code", "Data Piecework For Production"."Piecework Code");
                                                RelCertificationProduct.INSERT;
                                            END ELSE BEGIN
                                                RelCertificationProduct.INIT;
                                                RelCertificationProduct."Job No." := "Data Piecework For Production"."Job No.";
                                                RelCertificationProduct."Production Unit Code" := 'P' + PieceworkP."No.";
                                                RelCertificationProduct."Certification Unit Code" := "Data Piecework For Production"."Piecework Code";
                                                RelCertificationProduct."Percentage Of Assignment" := 100;
                                                RelCertificationProduct.INSERT;
                                            END;
                                        END;
                                    UNTIL PieceworkP.NEXT = 0;
                                END;
                            END;
                        END ELSE BEGIN
                            //jmma DataPieceworkForProduction.VALIDATE("Budget Measure","Data Piecework For Production"."Sales Amount (Base)");
                            DataPieceworkForProduction.VALIDATE("Budget Measure", "Data Piecework For Production"."Sale Quantity (base)");
                            DataPieceworkForProduction.VALIDATE("Initial Produc. Price",
                                                                     "Data Piecework For Production"."Unit Price Sale (base)");
                            DataPieceworkForProduction.MODIFY;
                            IF IncludeMeasureLines THEN BEGIN
                                ManagementLineofMeasure."GetLinMeasureCertif/Prod"("Data Piecework For Production"."Job No.",
                                                                                     "Data Piecework For Production"."Piecework Code",
                                                                                     DataPieceworkForProduction."Piecework Code");
                            END;
                            DataPieceworkForProduction.VALIDATE("Initial Produc. Price",
                                                                     "Data Piecework For Production"."Unit Price Sale (base)");
                            RelCertificationProduct.INIT;
                            RelCertificationProduct."Job No." := "Data Piecework For Production"."Job No.";
                            RelCertificationProduct."Production Unit Code" := DataPieceworkForProduction."Piecework Code";
                            RelCertificationProduct.VALIDATE("Certification Unit Code", "Data Piecework For Production"."Piecework Code");
                            RelCertificationProduct.INSERT;
                        END;
                    END;
                END ELSE BEGIN
                    DataPieceworkForProduction.Totaling := DataPieceworkForProduction."Piecework Code" + '..' +
                                                        DataPieceworkForProduction."Piecework Code" +
                                                        PADSTR('', 20 - STRLEN(DataPieceworkForProduction."Piecework Code"), '9');
                END;
                DataPieceworkForProduction.MODIFY;
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
                group("group719")
                {

                    CaptionML = ENU = 'Optiones', ESP = 'Opciones';
                    field("IncludeMeasureLines"; "IncludeMeasureLines")
                    {

                        CaptionML = ENU = 'Include bill of item of measure lines', ESP = 'Incluir descompuesto de l¡neas de medici¢n';
                    }
                    field("TextAdditional"; "TextAdditional")
                    {

                        CaptionML = ENU = 'Take Additional Text', ESP = 'Llevar textos adicionales';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Text000@7001100 :
        Text000: TextConst ENU = 'You must select a job to perform this task', ESP = 'Debe seleccionar un proyecto para ejecutar esta tarea';
        //       FilterJob@7001101 :
        FilterJob: Code[20];
        //       Job@7001102 :
        Job: Record 167;
        //       Text007@7001103 :
        Text007: TextConst ENU = 'You can not assign production data without separation of units.', ESP = 'No se puede asignar datos de producci¢n sin separaci¢n de unidades.';
        //       Initialize@7001104 :
        Initialize: Boolean;
        //       DataPieceworkForProduction@7001105 :
        DataPieceworkForProduction: Record 7207386;
        //       Text001@7001106 :
        Text001: TextConst ENU = 'There is already a production budget. Do you want to delete it and continue with the creation?', ESP = 'Existe ya un presupuesto de Producci¢n. ¨Desea borrarlo y continuar con la creaci¢n?';
        //       Text002@7001107 :
        Text002: TextConst ENU = 'The process of creating certification and measurement budget has been canceled.', ESP = 'Se ha cancelado el proceso de creaci¢n de presupuesto de certificaci¢n y medici¢n';
        //       Text008@7001108 :
        Text008: TextConst ENU = 'There is already a production budget. Only new drives will be created. Continue with creation?', ESP = 'Existe ya un presupuesto de Producci¢n. Solo se crear n las unidades nuevas. ¨Continuar con la creaci¢n?';
        //       IncludeMeasureLines@7001109 :
        IncludeMeasureLines: Boolean;
        //       ManagementLineofMeasure@7001110 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       DataPieceworkForProductionOffer@7001111 :
        DataPieceworkForProductionOffer: Record 7207386;
        //       DataCostByPieceworkOffer@7001112 :
        DataCostByPieceworkOffer: Record 7207387;
        //       DataCostByPiecework@7001113 :
        DataCostByPiecework: Record 7207387;
        //       CommentLine@7001114 :
        CommentLine: Record 97;
        //       CommentLine2@7001115 :
        CommentLine2: Record 97;
        //       DefaultDimension@7001116 :
        DefaultDimension: Record 352;
        //       DefaultDimension2@7001117 :
        DefaultDimension2: Record 352;
        //       RelCertificationProduct@7001118 :
        RelCertificationProduct: Record 7207397;
        //       Piecework@7001119 :
        Piecework: Record 7207277;
        //       BillofItemData@7001120 :
        BillofItemData: Record 7207384;
        //       PieceworkP@7001121 :
        PieceworkP: Record 7207277;
        //       First@7001122 :
        First: Boolean;
        //       BringCostDatabase@7001123 :
        BringCostDatabase: Report 7207277;
        //       Currency@7001124 :
        Currency: Record 4;
        //       TextAdditional@7001125 :
        TextAdditional: Boolean;
        //       QBText@7001126 :
        QBText: Record 7206918;

    //     procedure InicializeF (PInicialize@7001100 :
    procedure InicializeF(PInicialize: Boolean)
    begin
        Initialize := PInicialize;
    end;

    /*begin
    end.
  */

}




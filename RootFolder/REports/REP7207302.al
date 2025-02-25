report 7207302 "Create Budget Cert. Piecework"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Data Piecework For Production"; "Data Piecework For Production")
        {

            DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Customer Certification Unit" = CONST(true));


            RequestFilterFields = "Job No.";
            DataItem("Rel. Certification/Product."; "Rel. Certification/Product.")
            {

                DataItemTableView = SORTING("Job No.", "Certification Unit Code");
                DataItemLink = "Job No." = FIELD("Job No."),
                            "Certification Unit Code" = FIELD("Piecework Code");
                DataItem("Data Piecework For Prd"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Production Unit Code");
                    trigger OnPreDataItem();
                    BEGIN
                        PriceUnitSales := 0;
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        "Data Piecework For Prd".CALCFIELDS("Budget Measure", "Data Piecework For Prd"."Amount Cost Budget (JC)");


                        IF "Data Piecework For Prd"."Budget Measure" <> 0 THEN
                            PriceUnitSales := PriceUnitSales + ROUND(("Data Piecework For Prd"."Amount Cost Budget (JC)" /
                                                                      "Data Piecework For Prd"."Budget Measure") * (1 +
                                                                      ("Data Piecework For Prd"."% Of Margin" / 100)),
                                                                      Currency."Unit-Amount Rounding Precision");


                        IF IncludeLinesMeasure THEN
                            ManagementLineofMeasure.CopyProduction_To_Certification("Data Piecework For Prd"."Job No.", "Data Piecework For Prd"."Piecework Code", Job."Initial Budget Piecework");
                    END;

                    trigger OnPostDataItem();
                    BEGIN
                        IF "Data Piecework For Production"."Sales Amount (Base)" <> 0 THEN
                            "Data Piecework For Production".VALIDATE("Unit Price Sale (base)",
                                                       ROUND(PriceUnitSales / "Data Piecework For Production"."Sales Amount (Base)",
                                                       Currency."Unit-Amount Rounding Precision"));
                        Job.CALCFIELDS("Amou Piecework Meas./Certifi.");
                        Currency.InitRoundingPrecision;
                    END;


                }
            }
            trigger OnPreDataItem();
            VAR
                //                                JobFilterCode@7001100 :
                JobFilterCode: Code[20];
            BEGIN
                IF "Data Piecework For Production".GETFILTER("Job No.") = '' THEN
                    ERROR(Text000);
                FilterJob := "Data Piecework For Production".GETFILTER("Job No.");
                Job.GET(FilterJob);
                //JAV 24/01/22: - QB 1.10.13 No se debe usar Job.Status para QB, en su lugar est  el tipo de ficha
                //IF Job.Status <> Job.Status::Planning THEN BEGIN 
                IF (Job."Card Type" <> Job."Card Type"::Estudio) THEN BEGIN
                    IF (Job."Initial Budget Piecework" = '') THEN
                        ERROR(Text006);
                END;
                DataPieceworkForProduction.SETRANGE("Job No.", FilterJob);
                DataPieceworkForProduction.SETRANGE("Customer Certification Unit", TRUE);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    IF NOT CONFIRM(Text001) THEN BEGIN
                        MESSAGE(Text002);
                        CurrReport.BREAK;
                    END ELSE BEGIN
                        HistMeasurements.RESET;
                        HistMeasurements.SETRANGE(HistMeasurements."Job No.", FilterJob);
                        IF HistMeasurements.FINDFIRST THEN
                            ERROR(Text005, FilterJob);

                        MeasureLinePieceworkCertif.SETRANGE("Job No.", FilterJob);
                        MeasureLinePieceworkCertif.DELETEALL;
                    END;
                END;

                Records.SETRANGE("Job No.", Job."No.");
                IF NOT Records.FINDFIRST THEN BEGIN
                    QuoBuildingSetup.GET;
                    IF QuoBuildingSetup."Initial Record Code" <> '' THEN BEGIN
                        CLEAR(Records);
                        Records."Job No." := Job."No.";
                        Records."No." := QuoBuildingSetup."Initial Record Code";
                        Records.Description := 'Initial Record';
                        Records."Sale Type" := Records."Sale Type"::"Main Contract";
                        Records."Record Type" := Records."Record Type"::Contract;
                        Records.INSERT;
                    END;
                END;

                CLEAR(Currency);
                Currency.InitRoundingPrecision;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF NOT Job."Separation Job Unit/Cert. Unit" THEN BEGIN
                    SETRANGE("Budget Filter", Job."Initial Budget Piecework");
                    CALCFIELDS("Budget Measure", "Amount Cost Budget (JC)", "Amount Production Budget");
                    IF "Budget Measure" <> 0 THEN
                        IF "% Of Margin" <> 0 THEN
                            VALIDATE("Contract Price", ROUND(("Amount Cost Budget (JC)" /
                                                                  "Budget Measure") * (1 + ("% Of Margin" / 100)),
                                                                  Currency."Unit-Amount Rounding Precision"))
                        ELSE
                            VALIDATE("Contract Price", ROUND(("Amount Production Budget" /
                                                                  "Budget Measure") * (1 + ("% Of Margin" / 100)),
                                                                  Currency."Unit-Amount Rounding Precision"))
                    ELSE
                        VALIDATE("Contract Price", 0);
                    VALIDATE("Sales Amount (Base)", "Budget Measure");
                    IF "No. Record" = '' THEN
                        "No. Record" := Records."No.";
                    MODIFY;
                    IF IncludeLinesMeasure THEN
                        ManagementLineofMeasure.CopyProduction_To_Certification("Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code", Job."Initial Budget Piecework");

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
        //       Job@7001100 :
        Job: Record 167;
        //       Text000@7001101 :
        Text000: TextConst ENU = 'You must select a job to perform this task', ESP = 'Debe seleccionar un proyecto para ejecutar esta tarea';
        //       FilterJob@7001102 :
        FilterJob: Code[20];
        //       Text006@7001103 :
        Text006: TextConst ENU = 'You must specify initial budget to create the certification budget.', ESP = 'Debe especificar presupuesto de inicial para crear el presupuesto de certificaci¢n.';
        //       DataPieceworkForProduction@7001104 :
        DataPieceworkForProduction: Record 7207386;
        //       Text001@7001105 :
        Text001: TextConst ENU = 'There is already a budget for certifications and measurements. Do you want to delete it and continue with the creation?', ESP = 'Existe ya un presupuesto de certificaciones y mediciones. ¨Desea borrarlo y continuar con la creaci¢n?';
        //       Text002@7001106 :
        Text002: TextConst ENU = 'The process of creating certification and measurement budget has been canceled.', ESP = 'Se ha cancelado el proceso de creaci¢n de presupuesto de certificaci¢n y medici¢n.';
        //       HistMeasurements@7001107 :
        HistMeasurements: Record 7207338;
        //       Text005@7001108 :
        Text005: TextConst ENU = 'You can not change the certification budget, there are measurements for job %1', ESP = 'No se puede modificar el presupuesto de certificaci¢n, exiten mediciones para el proyecto %1';
        //       MeasureLinePieceworkCertif@7001109 :
        MeasureLinePieceworkCertif: Record 7207343;
        //       Records@7001111 :
        Records: Record 7207393;
        //       QuoBuildingSetup@7001112 :
        QuoBuildingSetup: Record 7207278;
        //       Currency@7001113 :
        Currency: Record 4;
        //       IncludeLinesMeasure@7001114 :
        IncludeLinesMeasure: Boolean;
        //       ManagementLineofMeasure@7001115 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       TextAdditional@7001116 :
        TextAdditional: Boolean;
        //       PriceUnitSales@7001118 :
        PriceUnitSales: Decimal;

    /*begin
    end.
  */

}




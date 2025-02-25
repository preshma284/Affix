report 7207292 "Generate Quotes"
{


    CaptionML = ENU = 'Generate Quotes', ESP = 'Generar ofertas';
    ShowPrintStatus = false;
    ProcessingOnly = true;

    dataset
    {

        DataItem("JobVersion"; "Job")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Versions', ESP = 'Versiones';
            ;
            DataItem("Comment Line"; "Comment Line")
            {

                DataItemTableView = SORTING("Table Name", "No.", "Line No.")
                                 WHERE("Table Name" = CONST("Job"));
                DataItemLink = "No." = FIELD("No.");

            }
            DataItem("Invoice Milestone Comments"; "Invoice Milestone Comments")
            {

                DataItemTableView = SORTING("Type", "Job No.", "Milestone No.", "Line No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Invoice Milestone"; "Invoice Milestone")
            {

                DataItemTableView = SORTING("Job No.", "Milestone No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Resource Price"; "Resource Price")
            {

                DataItemTableView = SORTING("Job No.", "Type", "Code", "Work Type Code", "Currency Code");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("G/L Budget Entry"; "G/L Budget Entry")
            {

                DataItemTableView = SORTING("Entry No.");
                ;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code");
                DataItemLink = "Job No." = FIELD("No.");

            }
            DataItem("Expected Time Unit Data"; "Expected Time Unit Data")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code", "Expected Date");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Forecast Data Amount Piecework"; "Forecast Data Amount Piecework")
            {

                DataItemTableView = SORTING("Job No.", "Cod. Budget", "Expected Date");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Data Cost By Piecework"; "Data Cost By Piecework")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Measurement Lin. Piecew. Prod."; "Measurement Lin. Piecew. Prod.")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code", "Code Budget", "Line No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Data Cost By Piecework Cert."; "Data Cost By Piecework Cert.")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code", "No. Record", "Line Type", "No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Measure Line Piecework Certif."; "Measure Line Piecework Certif.")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code", "Line No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Periodification Unit Cost"; "Periodification Unit Cost")
            {

                DataItemTableView = SORTING("Job No.", "Unit Cost", "Date");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Job Task"; "Job Task")
            {

                DataItemTableView = SORTING("Job No.", "Job Task No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Job Planning Line"; "Job Planning Line")
            {

                DataItemTableView = SORTING("Job No.", "Job Task No.", "Line No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Rel. Certification/Product."; "Rel. Certification/Product.")
            {

                DataItemTableView = SORTING("Job No.", "Production Unit Code", "Certification Unit Code");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Unitary Cost By Job"; "Unitary Cost By Job")
            {

                DataItemTableView = SORTING("Job No.", "Type", "No.");
                DataItemLink = "Job No." = FIELD("No.");
            }
            DataItem("Purchase Journal Line"; "Purchase Journal Line")
            {

                DataItemTableView = SORTING("Job No.", "Line No.");
                DataItemLink = "Job No." = FIELD("No.");
                trigger OnAfterGetRecord();
                BEGIN
                    IF Version = TRUE THEN BEGIN
                        CountBudget += 1;
                        Window.UPDATE(4, CountBudget);
                        PurchaseJournalLine.COPY("Purchase Journal Line");
                        PurchaseJournalLine."Job No." := JobQuotes."No.";
                        PurchaseJournalLine."Line No." := NoLineNoPurchase;
                        PurchaseJournalLine.INSERT(TRUE);
                        NoLineNoPurchase += 1;
                    END ELSE BEGIN

                        IF DataPieceworkForProductionInsert.GET(Job."No.", "Job Unit") AND (DataPieceworkForProductionInsert."Production Unit") THEN BEGIN
                            PurchaseJournalLine.COPY("Purchase Journal Line");
                            CountBudget += 1;
                            Window.UPDATE(4, CountBudget);
                            PurchaseJournalLine."Job No." := Job."No.";
                            PurchaseJournalLine."Line No." := NoLineNoPurchase;
                            PurchaseJournalLine.INSERT(TRUE);
                            NoLineNoPurchase += 1;

                        END;
                    END;
                END;
            }
            DataItem("Comparative Quote Header"; "Comparative Quote Header")
            {

                DataItemTableView = SORTING("No.");
                DataItemLink = "Job No." = FIELD("No.");
                DataItem("Vendor Conditions Data"; "Vendor Conditions Data")
                {

                    DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.");
                    DataItemLink = "Quote Code" = FIELD("No.");
                    trigger OnAfterGetRecord();
                    BEGIN
                        IF Version = TRUE THEN BEGIN
                            CountBudget += 1;
                            Window.UPDATE(4, CountBudget);
                            VendorConditionsData.COPY("Vendor Conditions Data");
                            VendorConditionsData."Job No." := JobQuotes."No.";
                            VendorConditionsData."Quote Code" := ComparativeQuoteHeader."No.";
                            VendorConditionsData.INSERT(TRUE);
                            DataPricesVendor_Old.RESET;
                            DataPricesVendor_Old.SETRANGE("Quote Code", "Quote Code");
                            DataPricesVendor_Old.SETRANGE("Vendor No.", "Vendor No.");
                            IF DataPricesVendor_Old.FINDSET THEN
                                REPEAT
                                    DataPricesVendor := DataPricesVendor_Old;
                                    DataPricesVendor."Quote Code" := ComparativeQuoteHeader."No.";
                                    DataPricesVendor."Job No." := JobQuotes."No.";
                                    DataPricesVendor.INSERT;
                                UNTIL DataPricesVendor_Old.NEXT = 0;
                        END ELSE BEGIN

                            IF DataPieceworkForProductionInsert.GET(Job."No.", DataPieceworkForProductionInsert."Piecework Code") AND (DataPieceworkForProductionInsert."Production Unit") THEN BEGIN
                                VendorConditionsData.COPY("Vendor Conditions Data");
                                CountBudget += 1;
                                Window.UPDATE(4, CountBudget);
                                VendorConditionsData."Job No." := Job."No.";
                                VendorConditionsData."Quote Code" := ComparativeQuoteHeader."No.";
                                VendorConditionsData.INSERT(TRUE);
                                DataPricesVendor_Old.RESET;
                                DataPricesVendor_Old.SETRANGE("Quote Code", "Quote Code");
                                DataPricesVendor_Old.SETRANGE("Vendor No.", "Vendor No.");
                                IF DataPricesVendor_Old.FINDSET THEN
                                    REPEAT
                                        DataPricesVendor := DataPricesVendor_Old;
                                        DataPricesVendor."Quote Code" := ComparativeQuoteHeader."No.";
                                        DataPricesVendor."Job No." := Job."No.";
                                        DataPricesVendor.INSERT;
                                    UNTIL DataPricesVendor_Old.NEXT = 0;
                            END;
                        END;
                    END;

                }
                DataItem("External intervenors"; "External intervenors")
                {

                    DataItemTableView = SORTING("Job No.", "Contact No.");
                    DataItemLink = "Job No." = FIELD("No.");
                    trigger OnAfterGetRecord();
                    VAR
                        //                                   Externals2@1100286000 :
                        Externals2: Record 7206913;
                    BEGIN
                        //JAV 22/02/20: - Copio los contactos externos del estudio al proyecto, pero no a la versi¢n
                        IF Version = FALSE THEN BEGIN
                            Externals2.COPY("External intervenors");
                            Externals2."Job No." := Job."No.";
                            Externals2.INSERT(TRUE);
                        END;
                    END;


                }


            }
            trigger OnAfterGetRecord();
            BEGIN
                IF Version = TRUE THEN BEGIN
                    CountBudget += 1;
                    Window.UPDATE(4, CountBudget);
                    ComparativeQuoteHeader.COPY("Comparative Quote Header");
                    ComparativeQuoteHeader."No." := NoComparative;
                    ComparativeQuoteHeader."Job No." := JobQuotes."No.";
                    ComparativeQuoteHeader."Approval Status" := ComparativeQuoteHeader."Approval Status"::Open;
                    ComparativeQuoteHeader."OLD_Approval Situation" := ComparativeQuoteHeader."OLD_Approval Situation"::Pending;
                    ComparativeQuoteHeader."OLD_Approval Coment" := '';
                    ComparativeQuoteHeader."OLD_Approval Date" := 0D;
                    ComparativeQuoteHeader.INSERT(TRUE);
                    ComparativeQuoteLines_Old.RESET;
                    ComparativeQuoteLines_Old.SETRANGE("Quote No.", "No.");
                    IF ComparativeQuoteLines_Old.FINDSET THEN
                        REPEAT
                            ComparativeQuoteLines := ComparativeQuoteLines_Old;
                            ComparativeQuoteLines."Quote No." := ComparativeQuoteHeader."No.";
                            ComparativeQuoteLines."Job No." := JobQuotes."No.";
                            ComparativeQuoteLines.INSERT;
                        UNTIL ComparativeQuoteLines_Old.NEXT = 0;
                END ELSE BEGIN
                    IF DataPieceworkForProductionInsert.GET(Job."No.", DataPieceworkForProductionInsert."Piecework Code") AND (DataPieceworkForProductionInsert."Production Unit") THEN BEGIN
                        ComparativeQuoteHeader.COPY("Comparative Quote Header");
                        CountBudget += 1;
                        Window.UPDATE(4, CountBudget);
                        ComparativeQuoteHeader."No." := NoComparative;
                        ComparativeQuoteHeader."Job No." := Job."No.";
                        ComparativeQuoteHeader."Approval Status" := ComparativeQuoteHeader."Approval Status"::Open;
                        ComparativeQuoteHeader."OLD_Approval Situation" := ComparativeQuoteHeader."OLD_Approval Situation"::Pending;
                        ComparativeQuoteHeader."OLD_Approval Coment" := '';
                        ComparativeQuoteHeader."OLD_Approval Date" := 0D;
                        ComparativeQuoteHeader.INSERT(TRUE);
                        ComparativeQuoteLines_Old.RESET;
                        ComparativeQuoteLines_Old.SETRANGE("Quote No.", "No.");
                        IF ComparativeQuoteLines_Old.FINDSET THEN
                            REPEAT
                                ComparativeQuoteLines := ComparativeQuoteLines_Old;
                                ComparativeQuoteLines."Quote No." := ComparativeQuoteHeader."No.";
                                ComparativeQuoteLines."Job No." := Job."No.";
                                ComparativeQuoteLines.INSERT;
                            UNTIL ComparativeQuoteLines_Old.NEXT = 0;
                    END;
                END;
            END;


        }



    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("group412")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    group("group413")
                    {

                        CaptionML = ESP = 'Copiar Versi¢n';
                        Visible = VersionVisible;
                        field("CVersion"; "CVersion")
                        {

                            CaptionML = ENU = 'Origin Quote No.', ESP = 'No. de Estudio/Versi¢n a copiar';

                            ; trigger OnValidate()
                            BEGIN
                                IF CVersion <> '' THEN BEGIN
                                    Job.GET(CVersion);
                                    Job.RESET;
                                    Job.SETRANGE("No.", CVersion);
                                    //JMMA 15/04/19 CAMBIO CARD TYPE
                                    //Job.SETRANGE(Status,Job.Status::Planning);
                                    Job.SETRANGE("Card Type", Job."Card Type"::Estudio);
                                    Job.SETRANGE("Original Quote Code", CQuoteOrigin);
                                    IF NOT Job.FINDFIRST THEN
                                        ERROR(text002, CVersion, CQuoteOrigin);
                                END;
                            END;

                            trigger OnLookup(var Text: Text): Boolean
                            BEGIN
                                CLEAR(JobList);
                                Job.RESET;
                                Job.FILTERGROUP(2);
                                //JMMA 15/04/19 CAMBIO CARD TYPE
                                //Job.SETRANGE(Status,Job.Status::Planning);
                                Job.SETRANGE("Card Type", Job."Card Type"::Estudio);
                                Job.SETRANGE("Original Quote Code", CQuoteOrigin);
                                Job.FILTERGROUP(0);
                                IF Job.GET(CVersion) THEN
                                    JobList.SETRECORD(Job);
                                JobList.SETTABLEVIEW(Job);
                                JobList.LOOKUPMODE(TRUE);
                                IF JobList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    JobList.GETRECORD(Job);
                                    CVersion := Job."No.";
                                END;
                            END;


                        }

                    }
                    group("group415")
                    {

                        CaptionML = ESP = 'Crear proyecto';
                        Visible = ProyectoVisible;
                        field("Serie No."; "SerieNo")
                        {

                            Lookup = true;
                            CaptionML = ENU = 'Job Serie No.', ESP = 'No. serie proyecto';

                            ; trigger OnValidate()
                            BEGIN
                                IF SerieNo <> '' THEN BEGIN
                                    CVersion := '';
                                    CJob := '';
                                END;
                            END;

                            trigger OnLookup(var Text: Text): Boolean
                            BEGIN
                                QuoBuildingSetup.GET;
                                QuoBuildingSetup.TESTFIELD("Serie for Jobs");
                                CSerie := QuoBuildingSetup."Serie for Jobs";
                                NoSeriesManagement.SelectSeries(CSerie, CSerie, SerieNo);
                                IF SerieNo <> '' THEN BEGIN
                                    CVersion := '';
                                    CJob := '';
                                END;
                            END;


                        }
                        field("CodeJob"; "CJob")
                        {

                            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto manual';

                            ; trigger OnValidate()
                            BEGIN
                                IF CJob <> '' THEN BEGIN
                                    CVersion := '';
                                    SerieNo := '';
                                END;
                            END;


                        }
                        field("ICost"; "ICost")
                        {

                            CaptionML = ESP = 'Importe gastos imputados';
                            Visible = CosteVisible;
                            Editable = false;
                        }
                        field("TCost"; "TCost")
                        {

                            CaptionML = ESP = 'Traspasar coste al proyecto';
                            Visible = CosteVisible

    ;
                        }

                    }

                }

            }
        }
        trigger OnInit()
        BEGIN
            ProyectoVisible := TRUE;
            VersionVisible := TRUE;
            CosteVisible := TRUE;
        END;

        trigger OnOpenPage()
        BEGIN
            VersionVisible := (Version);
            ProyectoVisible := (NOT Version);

            Job.RESET;
            //JMMA 15/04/19 cambio card type
            //Job.SETRANGE(Status,Job.Status::Planning);
            Job.SETRANGE("Card Type", Job."Card Type"::Estudio);
            Job.SETRANGE("Original Quote Code", CQuoteOrigin);
            IF Job.FINDLAST THEN
                CVersion := Job."No.";

            //JAV 23/08/19: - Calculo el importe de gastos imputados
            IF NOT Version THEN BEGIN
                Job2.RESET;
                IF CVersion <> '' THEN
                    Job2.SETRANGE("No.", CVersion)
                ELSE
                    Job2.SETRANGE("No.", CQuoteOrigin);
                Job2.FINDFIRST;
                Job2.GET(Job2."Original Quote Code");

                JobLedgerEntry.RESET;
                JobLedgerEntry.SETCURRENTKEY("Job No.");
                JobLedgerEntry.SETFILTER("Job No.", Job2."No." + '*');
                JobLedgerEntry.CALCSUMS("Total Cost (LCY)", "Total Price (LCY)");
                ICost := -(JobLedgerEntry."Total Cost (LCY)" + JobLedgerEntry."Total Price (LCY)");
            END;

            QuoBuildingSetup.GET();
            TCost := (ICost <> 0) AND (QuoBuildingSetup."Quote to Job Expenses");
            CosteVisible := (ICost <> 0);
            SerieNo := QuoBuildingSetup."Serie for Jobs";  //JAV 23/08/19: - Pongo nro de serie por defecto
        END;


    }
    labels
    {
    }

    var
        //       "---------------------------------- Request Page"@1100286000 :
        "---------------------------------- Request Page": Integer;
        //       SerieNo@1100286003 :
        SerieNo: Code[20];
        //       CJob@1100286002 :
        CJob: Code[20];
        //       CVersion@1100286001 :
        CVersion: Code[20];
        //       ICost@1100286045 :
        ICost: Decimal;
        //       TCost@1100286046 :
        TCost: Boolean;
        //       VersionVisible@1100286050 :
        VersionVisible: Boolean;
        //       ProyectoVisible@1100286049 :
        ProyectoVisible: Boolean ;
        //       CosteVisible@1100286048 :
        CosteVisible: Boolean;
        //       "---------------------------------- Variables"@1100286004 :
        "---------------------------------- Variables": Integer;
        //       QuoBuildingSetup@1000000103 :
        QuoBuildingSetup: Record 7207278;
        //       Job@1100286012 :
        Job: Record 167;
        //       JobQuotes@1100286010 :
        JobQuotes: Record 167;
        //       Job2@1100286047 :
        Job2: Record 167;
        //       JobLedgerEntry@1100286039 :
        JobLedgerEntry: Record 169;
        //       Records@1000000109 :
        Records: Record 7207393;
        //       JobBudget@1100286007 :
        JobBudget: Record 7207407;
        //       ForecastDataAmountPiecework@1100286006 :
        ForecastDataAmountPiecework: Record 7207392;
        //       ExpectedTimeUnitData@1100286005 :
        ExpectedTimeUnitData: Record 7207388;
        //       CommentLine@1100286017 :
        CommentLine: Record 97;
        //       InvoiceMilestoneComments@1100286016 :
        InvoiceMilestoneComments: Record 7207332;
        //       InvoiceMilestone@1100286015 :
        InvoiceMilestone: Record 7207331;
        //       ResourcePrice@1100286014 :
        ResourcePrice: Record 201;
        //       GLBudgetEntry@1100286013 :
        GLBudgetEntry: Record 96;
        //       GLBudgetName@1100286034 :
        GLBudgetName: Record 95;
        //       DataPieceworkForProduction@1100286033 :
        DataPieceworkForProduction: Record 7207386;
        //       QBText@1100286032 :
        QBText: Record 7206918;
        //       QBTextDestination@1100286031 :
        QBTextDestination: Record 7206918;
        //       DataPieceworkForProductionInsert@1100286028 :
        DataPieceworkForProductionInsert: Record 7207386;
        //       MeasureLinePieceworkCertif@1100286027 :
        MeasureLinePieceworkCertif: Record 7207343;
        //       MeasurementLinPiecewProd@1100286026 :
        MeasurementLinPiecewProd: Record 7207390;
        //       DataCostByPiecework@1100286025 :
        DataCostByPiecework: Record 7207387;
        //       PeriodificationUnitCost@1100286024 :
        PeriodificationUnitCost: Record 7207432;
        //       JobTask@1100286023 :
        JobTask: Record 1001;
        //       JobPlanningLine@1100286022 :
        JobPlanningLine: Record 1003;
        //       RelCertificationProduct@1100286021 :
        RelCertificationProduct: Record 7207397;
        //       UnitaryCostByJob@1100286020 :
        UnitaryCostByJob: Record 7207439;
        //       PurchaseJournalLine@1100286036 :
        PurchaseJournalLine: Record 7207281;
        //       ComparativeQuoteHeader@1100286035 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@1100286044 :
        ComparativeQuoteLines: Record 7207413;
        //       ComparativeQuoteLines_Old@1100286043 :
        ComparativeQuoteLines_Old: Record 7207413;
        //       VendorConditionsData@1100286042 :
        VendorConditionsData: Record 7207414;
        //       DataPricesVendor@1100286041 :
        DataPricesVendor: Record 7207415;
        //       DataPricesVendor_Old@1100286040 :
        DataPricesVendor_Old: Record 7207415;
        //       FunctionQB@1100286038 :
        FunctionQB: Codeunit 7207272;
        //       NoSeriesManagement@1100286009 :
        NoSeriesManagement: Codeunit 396;
        //       JobList@1100286037 :
        JobList: Page 89;
        //       Version@7001100 :
        Version: Boolean;
        //       Text008@7001103 :
        Text008: TextConst ENU = 'It is imperative that you specify a serial number or a job code', ESP = 'Es imprescindible que especifique un N§ serie o bien un C¢digo de proyecto';
        //       Text003@7001104 :
        Text003: TextConst ENU = 'No. Job %1 was generated', ESP = 'Se ha generado el proyecto N§ %1';
        //       Window@7001106 :
        Window: Dialog;
        //       Text010@7001107 :
        Text010: TextConst ENU = 'Generating version\', ESP = 'Generando versi¢n\';
        //       Text005@7001110 :
        Text005: TextConst ENU = 'Generating comments           #2######\', ESP = 'Generando Comentarios           #2######\';
        //       Text006@7001108 :
        Text006: TextConst ENU = 'Generating price               #3######\', ESP = 'Generando precios               #3######\';
        //       Text007@7001109 :
        Text007: TextConst ENU = 'Generating budget          #4######\', ESP = 'Generando presupuestos          #4######\';
        //       Text011@7001111 :
        Text011: TextConst ENU = 'Generating Job\', ESP = 'Generando Proyecto\';
        //       NoEntryPrevious@7001112 :
        NoEntryPrevious: Integer;
        //       NoEntry@7001113 :
        NoEntry: Integer;
        //       CQuoteOrigin@7001116 :
        CQuoteOrigin: Code[20];
        //       Separation@7001118 :
        Separation: Boolean;
        //       Text012@7001122 :
        Text012: TextConst ENU = 'INITIAL CONTRACT ACCEPTED', ESP = 'CONTRATO INICIAL ACEPTADO';
        //       Text013@7001124 :
        Text013: TextConst ENU = 'INITIAL BUDGET', ESP = 'PRESUPUESTO INICIAL';
        //       NoEntryPreviousAmount@7001127 :
        NoEntryPreviousAmount: Integer;
        //       CountComent@7001128 :
        CountComent: Integer;
        //       CountPrice@7001132 :
        CountPrice: Integer;
        //       NumberEntry@7001135 :
        NumberEntry: Integer;
        //       CBudgetQuote@7001136 :
        CBudgetQuote: Code[20];
        //       CDimQuote@7001137 :
        CDimQuote: Code[20];
        //       CountBudget@7001139 :
        CountBudget: Integer;
        //       text002@7001166 :
        text002: TextConst ENU = 'Version %1 does not belong to the %2 offer.', ESP = 'La versi¢n %1 no pertenece a la oferta %2.';
        //       CSerie@7001170 :
        CSerie: Code[20];
        //       NoLineNoPurchase@7001171 :
        NoLineNoPurchase: Integer;
        //       NoComparative@7001173 :
        NoComparative: Text;
        //       NoJournalTemplateName@7001174 :
        NoJournalTemplateName: Text;
        //       NoJournalBatchName@7001175 :
        NoJournalBatchName: Text;
        //       Err001@1100286051 :
        Err001: TextConst ESP = 'El diario %1 secci¢n %2 tiene %3 l¡neas, ¨desea eliminarlas?';
        //       DefaultDimension@1100286053 :
        DefaultDimension: Record 352;
        //       DefaultDimensionVersion@1100286052 :
        DefaultDimensionVersion: Record 352;
        //       Err002@1100286054 :
        Err002: TextConst ESP = 'No puede crear nuevas versiones de un proyecto aprobado o rechazado';
        //       Err003@1100286055 :
        Err003: TextConst ESP = 'No puede crear nuevas versiones de un proyecto bloqueado';
        //       Err004@1100286056 :
        Err004: TextConst ESP = 'No puede crear un proyecto de un estudio no aprobado';
        //       CopyJobBudget@1100286057 :
        CopyJobBudget: Report 7207400;
        //       DataCostByPieceworkCert@1100286029 :
        DataCostByPieceworkCert: Record 7207340;



    trigger OnPreReport();
    begin
        if not Version then
            if (SerieNo = '') and (CJob = '') then
                ERROR(Text008);
    end;

    trigger OnPostReport();
    begin
        if not Version then begin
            MESSAGE(Text003, Job."No.");
        end;
    end;



    // procedure VersionJob (PrmVersion@1000000000 :
    procedure VersionJob(PrmVersion: Boolean): Boolean;
    begin
        Version := PrmVersion;
    end;

    //     procedure SetParam (JobQuote@1000000000 : Code[20];JobView@1000000001 :
    procedure SetParam(JobQuote: Code[20]; JobView: Code[20])
    begin
        CVersion := JobView;
        CQuoteOrigin := JobQuote;
    end;

    procedure GetJobGenerate(): Code[20];
    begin
        if Version then
            exit(JobQuotes."No.")
        else
            exit(Job."No.");
    end;

    LOCAL procedure QuoteToJobExpenses()
    var
        //       GenJournalLine@1100286001 :
        GenJournalLine: Record 81;
        //       DataPieceworkForProduction@1100286003 :
        DataPieceworkForProduction: Record 7207386;
        //       DataCostByPiecework@1100286004 :
        DataCostByPiecework: Record 7207387;
        //       Line@1100286002 :
        Line: Integer;
        //       Ok@1100286000 :
        Ok: Boolean;
    begin
        //JAV 23/08/19: - Traspasar autom ticamente los gastos de los estudios a las obras

        //Creo la u.o. para imputar los costes en el proyecto si no existe
        QuoBuildingSetup.GET();
        QuoBuildingSetup.TESTFIELD("Quote to Job Piecework");
        if (not DataPieceworkForProduction.GET(Job."No.", QuoBuildingSetup."Quote to Job Piecework")) then begin
            DataPieceworkForProduction.INIT;
            DataPieceworkForProduction."Job No." := Job."No.";
            DataPieceworkForProduction."Piecework Code" := QuoBuildingSetup."Quote to Job Piecework";
            DataPieceworkForProduction.INSERT;
        end;
        DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
        DataPieceworkForProduction."Type Unit Cost" := DataPieceworkForProduction."Type Unit Cost"::Internal;
        DataPieceworkForProduction.Description := 'Gastos del estudio ' + JobVersion."Original Quote Code";
        DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
        DataPieceworkForProduction."Subtype Cost" := DataPieceworkForProduction."Subtype Cost"::"Current Expenses";
        DataPieceworkForProduction."Production Unit" := TRUE;
        DataPieceworkForProduction."Customer Certification Unit" := FALSE;
        DataPieceworkForProduction.VALIDATE("Measure Pending Budget", 1);
        DataPieceworkForProduction.MODIFY;

        //Miro si hay l¡neas en el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        if (GenJournalLine.COUNT > 1) then
            if (not CONFIRM(Err001, TRUE, QuoBuildingSetup."Jobs Book", QuoBuildingSetup."Jobs Batch Book", GenJournalLine.COUNT)) then
                ERROR('');

        GenJournalLine.DELETEALL;

        // Busco los gastos imputados contra cuenta y monto el diario general de proyectos para traspasarlos
        Line := 0;
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.");
        JobLedgerEntry.SETFILTER("Job No.", JobVersion."Original Quote Code" + '*');
        JobLedgerEntry.SETRANGE(Type, JobLedgerEntry.Type::"G/L Account");
        if (JobLedgerEntry.FINDSET(FALSE)) then
            repeat
                //Quito la l¡nea del estudio
                Line += 10000;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := QuoBuildingSetup."Jobs Book";
                GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Jobs Batch Book";
                GenJournalLine."Line No." := Line;
                GenJournalLine."Posting Date" := TODAY;
                GenJournalLine."Document No." := JobLedgerEntry."Document No.";
                GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.VALIDATE("Account No.", JobLedgerEntry."No.");
                GenJournalLine.Description := STRSUBSTNO('Traspaso al proyecto %1', Job."No.");
                GenJournalLine.VALIDATE(Amount, -(JobLedgerEntry."Total Cost (LCY)" + JobLedgerEntry."Total Price (LCY)"));
                GenJournalLine.VALIDATE("Job No.", JobLedgerEntry."Job No.");
                GenJournalLine.VALIDATE("Dimension Set ID", JobLedgerEntry."Dimension Set ID");
                //GenJournalLine.VALIDATE("Usage/Sale", JobLedgerEntry."Entry Type");
                GenJournalLine.INSERT;

                //Pongo la l¡nea en la obra
                Line += 10000;
                GenJournalLine."Line No." := Line;
                GenJournalLine.Description := STRSUBSTNO('Traspaso desde el estudio %1', JobLedgerEntry."Job No.");
                GenJournalLine.VALIDATE(Amount, (JobLedgerEntry."Total Cost (LCY)" + JobLedgerEntry."Total Price (LCY)"));
                GenJournalLine.VALIDATE("Job No.", Job."No.");
                GenJournalLine.VALIDATE("Piecework Code", QuoBuildingSetup."Quote to Job Piecework");
                GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(JobLedgerEntry."Dimension Set ID", Job."No.", Job."Global Dimension 1 Code"));
                GenJournalLine.INSERT;

                //A¤ado la l¡nea del descompuesto
                //-Q18970.1
                DataCostByPiecework.SETRANGE("Job No.", Job."No.");
                DataCostByPiecework.SETRANGE("Piecework Code", QuoBuildingSetup."Quote to Job Piecework");
                DataCostByPiecework.SETRANGE("Cod. Budget", QuoBuildingSetup."Initial Budget Code");
                DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type");
                DataCostByPiecework.SETRANGE("No.", JobLedgerEntry."No.");
                if DataCostByPiecework.FINDSET then begin
                    repeat
                        //if (DataCostByPiecework.GET(Job."No.", QuoBuildingSetup."Quote to Job Piecework", QuoBuildingSetup."Initial Budget Code", DataCostByPiecework."Cost Type"::Account, JobLedgerEntry."No.")) then begin
                        DataCostByPiecework.VALIDATE("Direc Unit Cost", DataCostByPiecework."Direc Unit Cost" + GenJournalLine.Amount);
                        DataCostByPiecework.MODIFY;
                    until DataCostByPiecework.NEXT = 0;
                    //+Q18970.1
                end else begin
                    DataCostByPiecework.RESET;
                    DataCostByPiecework."Job No." := Job."No.";
                    DataCostByPiecework."Piecework Code" := QuoBuildingSetup."Quote to Job Piecework";
                    DataCostByPiecework."Cod. Budget" := QuoBuildingSetup."Initial Budget Code";
                    DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Account;
                    DataCostByPiecework."No." := JobLedgerEntry."No.";
                    DataCostByPiecework.Description := JobLedgerEntry.Description;
                    DataCostByPiecework.VALIDATE(Quantity, 1);
                    DataCostByPiecework.VALIDATE("Direc Unit Cost", GenJournalLine.Amount);
                    DataCostByPiecework.INSERT;
                end;
            until JobLedgerEntry.NEXT = 0;

        COMMIT;
        if (Line <> 0) then
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);


        // Busco los gastos imputados que no sean contra cuenta y monto el diario de proyectos para traspasarlos
        Line := 0;
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.");
        JobLedgerEntry.SETFILTER("Job No.", JobVersion."Original Quote Code" + '*');
        JobLedgerEntry.SETFILTER(Type, '<>51', JobLedgerEntry.Type::"G/L Account");
        if (JobLedgerEntry.FINDSET(FALSE)) then
            repeat

            until JobLedgerEntry.NEXT = 0;
    end;

    //     LOCAL procedure SetDefaultDimensions (Version@1100286000 : Boolean;pJobOri@1100286001 : Code[20];pJobDes@1100286006 :
    LOCAL procedure SetDefaultDimensions(Version: Boolean; pJobOri: Code[20]; pJobDes: Code[20])
    var
        //       GeneralLedgerSetup@1100286003 :
        GeneralLedgerSetup: Record 98;
        //       NewDefaultDimension@1100286004 :
        NewDefaultDimension: Record 352;
        //       DimensionValue@1100286005 :
        DimensionValue: Record 349;
    begin
        //PGM 06/09/19  >>
        //JAV 22/09/19: - Las dimensiones que se pasan cuando se crea un proyecto o versi¢n son las del estudio de base, no las de la versi¢n
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", pJobOri);
        //JAV fin
        if DefaultDimension.FINDSET then
            repeat
                DefaultDimensionVersion.INIT;
                DefaultDimensionVersion.VALIDATE("Table ID", DATABASE::Job);
                DefaultDimensionVersion.VALIDATE("No.", pJobDes);
                DefaultDimensionVersion.VALIDATE("Dimension Code", DefaultDimension."Dimension Code");
                DefaultDimensionVersion.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                //JAV 22/09/19: - Se toma la configurada y no un valor fijo
                //DefaultDimensionVersion.VALIDATE("Value Posting",DefaultDimensionVersion."Value Posting"::"Same Code");
                DefaultDimensionVersion.VALIDATE("Value Posting", DefaultDimension."Value Posting");
                if not DefaultDimensionVersion.INSERT(TRUE) then;
            until DefaultDimension.NEXT = 0;

        QuoBuildingSetup.GET;
        if QuoBuildingSetup."Department Equal To Project" then begin  //Se borra la dimension DPTO porque puede traer un valor erroneo.
            DefaultDimensionVersion.RESET;
            DefaultDimensionVersion.SETRANGE("Table ID", DATABASE::Job);
            DefaultDimensionVersion.SETRANGE("No.", pJobDes);
            DefaultDimensionVersion.SETRANGE("Dimension Code", FunctionQB.ReturnDimDpto);
            if DefaultDimensionVersion.FINDFIRST then
                DefaultDimensionVersion.DELETE(TRUE);

            DimensionValue.INIT;
            if (not Version) then begin
                DimensionValue.VALIDATE("Dimension Code", FunctionQB.ReturnDimJobs);
                DimensionValue.VALIDATE(Code, pJobDes);
                DimensionValue.VALIDATE(Name, COPYSTR(Job.Description, 1, 30));
            end else begin
                DimensionValue.VALIDATE("Dimension Code", FunctionQB.ReturnDimDpto);
                DimensionValue.VALIDATE(Code, pJobDes);
                DimensionValue.VALIDATE(Name, COPYSTR(JobQuotes.Description, 1, 30));
            end;
            DimensionValue.INSERT(TRUE);

            NewDefaultDimension.INIT;
            NewDefaultDimension.VALIDATE("Table ID", DATABASE::Job);
            if (not Version) then begin
                NewDefaultDimension.VALIDATE("No.", pJobDes);
                NewDefaultDimension.VALIDATE("Dimension Code", FunctionQB.ReturnDimDpto);
                NewDefaultDimension.VALIDATE("Dimension Value Code", pJobDes);
            end else begin
                NewDefaultDimension.VALIDATE("No.", pJobDes);
                NewDefaultDimension.VALIDATE("Dimension Code", FunctionQB.ReturnDimDpto);
                NewDefaultDimension.VALIDATE("Dimension Value Code", pJobDes);
            end;
            NewDefaultDimension.VALIDATE("Value Posting", DefaultDimensionVersion."Value Posting"::"Same Code");
            if not NewDefaultDimension.INSERT(TRUE) then;
        end;
        //PGM <<
    end;

    //     LOCAL procedure GetIdDimension (DimSetId@1100286000 : Integer;JobCode@1100286005 : Code[20];Dim1@1100286003 :
    LOCAL procedure GetIdDimension(DimSetId: Integer; JobCode: Code[20]; Dim1: Code[20]): Integer;
    var
        //       GeneralLedgerSetup@1100286004 :
        GeneralLedgerSetup: Record 98;
        //       DimensionSetEntry@1100286002 :
        DimensionSetEntry: Record 480 TEMPORARY;
        //       DimMgt@1100286001 :
        DimMgt: Codeunit 408;
        //       newDimSetId@1100286006 :
        newDimSetId: Integer;
    begin
        GeneralLedgerSetup.GET();
        QuoBuildingSetup.GET();
        DimMgt.GetDimensionSet(DimensionSetEntry, DimSetId);

        //Dimensi¢n 1
        if DimensionSetEntry.GET(DimSetId, GeneralLedgerSetup."Global Dimension 1 Code") then begin
            DimensionSetEntry.VALIDATE("Dimension Value Code", Dim1);
            DimensionSetEntry.MODIFY;
        end else begin
            DimensionSetEntry.VALIDATE("Dimension Set ID", DimSetId);
            DimensionSetEntry.VALIDATE("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
            DimensionSetEntry.VALIDATE("Dimension Value Code", Dim1);
            DimensionSetEntry.INSERT;
        end;

        //Dimensi¢n proyecto
        if DimensionSetEntry.GET(DimSetId, FunctionQB.ReturnDimJobs) then begin
            DimensionSetEntry.VALIDATE("Dimension Value Code", JobCode);
            DimensionSetEntry.MODIFY;
        end else begin
            DimensionSetEntry.VALIDATE("Dimension Set ID", DimSetId);
            DimensionSetEntry.VALIDATE("Dimension Code", FunctionQB.ReturnDimJobs);
            DimensionSetEntry.VALIDATE("Dimension Value Code", JobCode);
            DimensionSetEntry.INSERT;
        end;

        //Dimensi¢n Estudio
        if DimensionSetEntry.GET(DimSetId, FunctionQB.ReturnDimQuote) then
            DimensionSetEntry.DELETE;

        if (QuoBuildingSetup."Dim. Default Value for Quote" <> '') then begin
            DimensionSetEntry.VALIDATE("Dimension Set ID", DimSetId);
            DimensionSetEntry.VALIDATE("Dimension Code", FunctionQB.ReturnDimQuote);
            DimensionSetEntry.VALIDATE("Dimension Value Code", QuoBuildingSetup."Dim. Default Value for Quote");
            DimensionSetEntry.INSERT;
        end;

        newDimSetId := DimMgt.GetDimensionSetID(DimensionSetEntry);
        exit(newDimSetId);
    end;

    LOCAL procedure QuoteToJobGuarantees()
    var
        //       Guarantee@1100286000 :
        Guarantee: Record 7207441;
        //       cuGuarantees@1100286001 :
        cuGuarantees: Codeunit 7207355;
    begin
        //JAV 27/08/19: - Traspasar las garant¡as del estudio al proyecto

        Job2.GET(JobVersion."Original Quote Code");
        if (Job2."Guarantee Definitive" <> 0) then begin
            //Pongo el proyecto en el registro de la garant¡a
            Guarantee.RESET;
            Guarantee.SETRANGE("Quote No.", JobVersion."Original Quote Code");
            Guarantee.MODIFYALL("Job No.", Job."No.");

            //Paso el importe de la gant¡a definitiva al proyecto generado
            Job."Guarantee Definitive" := Job2."Guarantee Definitive";
            Job.MODIFY;

            //Se solicita a financiero la creaci¢n de la garant¡a definitiva
            cuGuarantees.SolicitudDefinitiva(Job, FALSE);
        end;
    end;

    /*begin
    //{
//      NZG 23/01/18: - QBV101 Modificaci¢n para que las versiones tomen las dimensiones de la oferta original.
//      JAV 23/08/19: - Traspasar autom ticamente los gastos de los estudios a las obras
//      JAV 24/08/19: - No usaba bien el tema de separaci¢n coste/venta
//      JAV 27/08/19: - Traspasar las garant¡as del estudio al proyecto
//      PGM 06/09/19: - Se traspasan las dimensiones al proyecto o a la versi¢n generada
//      JAV 22/09/19: - Las dimensiones que se pasan cuando se crea una obra son las del estudio, no las de la versi¢n
//      PGM 08/10/19: - GAP015 Se traspasa el campo "Project Management" al crear una versi¢n o un proyecto.
//      JAV 12/10/19: - Establezco el presupuesto inicial solo si hay uno de estudios
//      QMD 29/10/19: - Q8091 Guardarse el importe de venta en el proyecto generado
//      JAV 11/12/19: - Solo se copian los responsables del estudio al proyecto, no a las versiones
//      JAV 22/02/20: - Al crear el proyecto no cargamos campos que ya toma de la versi¢n
//                    - Mejora en el manejo de los responsables
//                    - Copio los contactos externos del estudio al proyecto, pero no a la versi¢n
//      JAV 23/10/20: - QB 1.07.00 Se elimina el dataitem para "Responsible" que no se usa
//      AML 12/06/23  - Q18970.1 Evitar los GET para Data Cost by Piecework
//    }
    end.
  */

}




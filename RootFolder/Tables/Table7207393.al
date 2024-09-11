table 7207393 "Records"
{

    DataCaptionFields = "Job No.", "Job Description", "No.", "Description";
    CaptionML = ENU = 'Records', ESP = 'Expedientes';
    LookupPageID = "Job Records List";
    DrillDownPageID = "Job Records List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'Key 2';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesManagement.TestManual(QuoBuildingSetup."Serie for Record");
                    "Series No." := '';
                END;
            END;


        }
        field(2; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripción';

            trigger OnValidate();
            BEGIN
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;
            END;


        }
        field(3; "Search Description"; Code[50])
        {
            CaptionML = ENU = 'Search Description', ESP = 'Alias';


        }
        field(4; "Description 2"; Text[50])
        {


            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';

            trigger OnValidate();
            BEGIN
                //Ejemplo de validate de campo que esta en funci�n de otro y se ejecuta desde el formulario, ver plantilla
                //maestra con borrador.
                IF Description = '' THEN
                    ERROR(Text001);
            END;


        }
        field(5; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Vendor Evaluation"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(6; "Blocked"; Boolean)
        {
            CaptionML = ENU = 'Blocked', ESP = 'Bloqueado';


        }
        field(7; "Last Modified Date"; Date)
        {
            CaptionML = ENU = 'Last Modified Date', ESP = 'Fecha �ltima modificaci�n';
            Editable = false;


        }
        field(8; "Filter Date"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Filter Date', ESP = 'Fecha filtro';


        }
        field(9; "Series No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Series No.', ESP = 'N� serie';
            Editable = false;


        }
        field(10; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'C�d. proyecto';
            Description = 'Key 1';
            Editable = false;


        }
        field(11; "Sale Type"; Option)
        {
            OptionMembers = "Main Contract","Annexes and Contradictories","Price Revision","Settlement","Supply","Extension of Contract";
            CaptionML = ENU = 'Sale Type', ESP = 'Tipo de venta';
            OptionCaptionML = ENU = 'Main Contract,Annexes and Contradictories,Price Revision,Settlement,Supply,Extension of Contract', ESP = 'Contrato Principal,Anexos y Contradictorios,Revision Precios,Liquidacion,Suplido,Ampliacion de contrato';



        }
        field(12; "Record Type"; Option)
        {
            OptionMembers = " ","Contract","Refurbished","Complementary","Settlement","Other Customers","Others","Prices Contradictories";

            CaptionML = ENU = 'Record Type', ESP = 'Tipo expediente';
            OptionCaptionML = ENU = '" ,Contract,Refurbished,Complementary,Settlement,Other Customers,Others,Prices Contradictories"', ESP = '" ,Contrato,Reformado,Complementario,Liquidacion,Otr. clientes,Otros,Precios Contradictorios"';


            trigger OnValidate();
            BEGIN
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                // IF JobDataUnitforProduction.FINDSET(TRUE, FALSE) THEN
                IF JobDataUnitforProduction.FINDSET(TRUE) THEN
                    REPEAT
                        JobDataUnitforProduction.VALIDATE("Record Type", "Record Type");
                        JobDataUnitforProduction.MODIFY;
                    UNTIL JobDataUnitforProduction.NEXT = 0;
            END;


        }
        field(13; "Record Status"; Option)
        {
            OptionMembers = "Management","Technical Approval","Approved";

            CaptionML = ENU = 'Record Status', ESP = 'Estado expediente';
            OptionCaptionML = ENU = 'Management,Technical Approval,Approved', ESP = 'Gestion,Aprobacion tecnica,Aprobado';


            trigger OnValidate();
            BEGIN
                //Asign % progress by record status
                ConfJobsUnits.GET;

                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                // IF JobDataUnitforProduction.FINDSET(TRUE, FALSE) THEN
                IF JobDataUnitforProduction.FINDSET(TRUE) THEN
                    REPEAT
                        JobDataUnitforProduction.VALIDATE("Record Status", "Record Status");
                        CASE "Record Status" OF
                            "Record Status"::Management:
                                BEGIN
                                    JobDataUnitforProduction."% Processed Production" := ConfJobsUnits."% Management Application";
                                END;
                            "Record Status"::"Technical Approval":
                                BEGIN
                                    JobDataUnitforProduction."% Processed Production" := ConfJobsUnits."% Appl. Tecnique Approval";
                                END;
                            "Record Status"::Approved:
                                BEGIN
                                    JobDataUnitforProduction."% Processed Production" := 100;
                                END;
                        END;
                        //JMMA 291020
                        JobDataUnitforProduction."Record Status" := "Record Status";
                        JobDataUnitforProduction."Record Type" := "Record Type";
                        JobDataUnitforProduction.MODIFY;
                    UNTIL JobDataUnitforProduction.NEXT = 0;
            END;


        }
        field(14; "Job Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Job"."Description" WHERE("No." = FIELD("Job No.")));
            CaptionML = ENU = 'Job Description', ESP = 'Descripción obra';
            Editable = false;


        }
        field(15; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N� cliente';


        }
        field(16; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."Name" WHERE("No." = FIELD("Customer No.")));
            CaptionML = ENU = 'Customer Name', ESP = 'Nombre cliente';
            Editable = false;


        }
        field(17; "Entry Record Date"; Date)
        {
            CaptionML = ENU = 'Entry Record Date', ESP = 'Fecha entrada expediente';


        }
        field(18; "Shipment To Central Date"; Date)
        {
            CaptionML = ENU = 'Shipment To Central Date', ESP = 'Fecha envio a central';


        }
        field(19; "Initial Procedure Date"; Date)
        {
            CaptionML = ENU = 'Initial Procedure Date', ESP = 'Fecha inicio tr�mites';


        }
        field(20; "Estimated Amount"; Decimal)
        {
            CaptionML = ENU = 'Estimated Amount', ESP = 'Importe estimado';


        }
        field(21; "Piecework No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Data Piecework For Production" WHERE("Job No." = FIELD("Job No."),
                                                                                                            "No. Record" = FIELD("No."),
                                                                                                            "Customer Certification Unit" = CONST(true)));
            CaptionML = ENU = 'Piecework No.', ESP = 'N� de unidades de obra';
            Editable = false;


        }
        field(22; "Finished"; Boolean)
        {
            CaptionML = ENU = 'Finished', ESP = 'Finalizado';
            Editable = false;


        }
        field(23; "Finish Record Date"; Date)
        {
            CaptionML = ENU = 'Finish Record Date', ESP = 'Fecha fin expediente';
            Editable = false;


        }
        field(24; "Launch Date"; Date)
        {
            CaptionML = ENU = 'Launch Date', ESP = 'Fecha presentaci�n';


        }
        field(25; "Technical Approval Date"; Date)
        {
            CaptionML = ENU = 'Technical Approval Date', ESP = 'Fecha aprobaci�n t�cnica';


        }
        field(26; "Definitive Approval Date"; Date)
        {
            CaptionML = ENU = 'Definitive Approval Date', ESP = 'Fecha aprobaci�n definitiva';


        }
        field(27; "Budget Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Budget Filter', ESP = 'Filtro presupuesto';


        }
        field(50; "Currency Amount Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Amount Date', ESP = 'Fecha valor divisa';
            Description = 'GEN003-04';


        }
    }
    keys
    {
        key(key1; "Job No.", "No.")
        {
            Clustered = true;
        }
        key(key2; "Search Description")
        {
            ;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Description", "Customer No.")
        {

        }
    }

    var
        //       CommentLine@7207771 :
        CommentLine: Record 97;
        //       QuoBuildingSetup@7207773 :
        QuoBuildingSetup: Record 7207278;
        //       Job@7207774 :
        Job: Record 167;
        //       ControlRecords@7207775 :
        ControlRecords: Record 7207393;
        //       JobDataUnitforProduction@7207776 :
        JobDataUnitforProduction: Record 7207386;
        //       ConfJobsUnits@7207777 :
        ConfJobsUnits: Record 7207279;
        //       GeneralLedgerSetup@100000003 :
        GeneralLedgerSetup: Record 98;
        //       JobCurrencyExchangeFunction@100000002 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       NoSeriesManagement@7207779 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       amountProcess@7207780 :
        amountProcess: Decimal;
        //       amountAccepted@7207781 :
        amountAccepted: Decimal;
        //       amountCost@7207782 :
        amountCost: Decimal;
        //       amountSale@7207783 :
        amountSale: Decimal;
        //       Text001@7207784 :
        Text001: TextConst ENU = 'You Must Fill Description 1 before fill Description 2', ESP = 'Debe rellenar primero la Descripción 1 para poder rellanar la 2';
        //       Text002@7207785 :
        Text002: TextConst ENU = 'The Job is blocked', ESP = 'El proyecto est� bloqueado';
        //       Text003@7207786 :
        Text003: TextConst ENU = 'Job must be of Structure', ESP = 'El proyecto debe ser de estructura';
        //       Text004@7207787 :
        Text004: TextConst ENU = 'Record can''t be deleted as there are jobs units associated', ESP = 'No se puede eliminar el Expediente ya que existen Unidades de obra asociadas';
        //       Text005@7207788 :
        Text005: TextConst ENU = 'RECORD INITIAL CONTRACT', ESP = 'EXP. CONTRATO INICIAL';
        //       AssignedAmount@100000001 :
        AssignedAmount: Decimal;
        //       CurrencyFactor@100000000 :
        CurrencyFactor: Decimal;



    trigger OnInsert();
    begin
        if "No." = '' then begin
            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD("Serie for Record");
            NoSeriesManagement.InitSeries(QuoBuildingSetup."Serie for Record", xRec."Series No.", 0D, "No.", "Series No.");
        end;

        //GAP029 -
        if Job.GET("Job No.") then
            if (Job."Multi-Client Job" <> Job."Multi-Client Job"::ByCustomers) then
                "Customer No." := Job."Bill-to Customer No.";
        //GAP029 -
    end;

    trigger OnModify();
    begin
        "Last Modified Date" := TODAY;
        MandatoryDef;
    end;

    trigger OnDelete();
    begin
        CommentLine.RESET;
        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::Vendor);
        CommentLine.SETRANGE("No.", "No.");
        CommentLine.DELETEALL;
        JobDataUnitforProduction.RESET;
        JobDataUnitforProduction.SETCURRENTKEY("Job No.", "No. Record");
        JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
        JobDataUnitforProduction.SETRANGE("No. Record", "No.");
        if JobDataUnitforProduction.FINDFIRST then
            ERROR(Text004);
    end;

    trigger OnRename();
    begin
        "Last Modified Date" := TODAY;
    end;



    procedure InsertRegistry()
    begin
        VALIDATE(Description);
        VALIDATE("Description 2");
        INSERT(TRUE);
    end;

    procedure MandatoryDef()
    begin
        TESTFIELD(Description);
    end;

    //     procedure JobControl (CodeJob@7207771 :
    procedure JobControl(CodeJob: Code[10])
    begin
        Job.GET(CodeJob);
        if Job.Blocked <> Job.Blocked::" " then
            ERROR(Text002);
        if Job."Job Type" <> Job."Job Type"::Structure then
            ERROR(Text003);
    end;

    //     procedure AssistEdit (PreviousRec@7207771 :
    procedure AssistEdit(PreviousRec: Record 7207393): Boolean;
    begin
        /*To be Tested*/
        // WITH ControlRecords DO begin
        ControlRecords := Rec;
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Serie for Record");
        if NoSeriesManagement.SelectSeries(QuoBuildingSetup."Serie for Record", PreviousRec."Series No.", "Series No.") then begin
            NoSeriesManagement.SetSeries("No.");
            Rec := ControlRecords;
            exit(TRUE);
        end;
        // end;
    end;

    //     procedure ProcedureAmount (parDivisa@100000000 :
    procedure ProcedureAmount(parDivisa: Option "Job","Local","Aditional"): Decimal;
    var
        //       RelCertificationproduct@7207771 :
        RelCertificationproduct: Record 7207397;
        //       JobDataUnitforProductionL@7207772 :
        JobDataUnitforProductionL: Record 7207386;
    begin
        //GEN003-04: A�adido el parametro parDivisa

        amountProcess := 0;
        if (Job.GET("Job No.")) then begin //JAV 17/05/21: QB 1.08.42 Por si no existe el proyecto
            if not Job."Separation Job Unit/Cert. Unit" then begin
                JobDataUnitforProduction.RESET;
                JobDataUnitforProduction.SETCURRENTKEY("Job No.", "No. Record");
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                // if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
                if JobDataUnitforProduction.FINDSET(FALSE) then begin
                    repeat
                        amountProcess += JobDataUnitforProduction.amountProductionInProgress;
                    until JobDataUnitforProduction.NEXT = 0;
                end;
            end else begin
                JobDataUnitforProduction.RESET;
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                JobDataUnitforProduction.SETRANGE("Customer Certification Unit", TRUE);
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                //if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
                if JobDataUnitforProduction.FINDSET(FALSE) then begin
                    repeat
                        RelCertificationproduct.SETRANGE("Job No.", JobDataUnitforProduction."Job No.");
                        RelCertificationproduct.SETRANGE("Certification Unit Code", JobDataUnitforProduction."Piecework Code");
                        if RelCertificationproduct.FINDFIRST then
                            repeat
                                if JobDataUnitforProductionL.GET(RelCertificationproduct."Job No.", RelCertificationproduct."Production Unit Code") then begin
                                    //jmma 291020 JobDataUnitforProductionL.SETRANGE("Budget Filter",Job."Initial Budget Piecework");
                                    JobDataUnitforProductionL.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                                    JobDataUnitforProductionL.CALCFIELDS("Amount Production Performed", "Amount Production Budget");
                                    //ponderaci�n por asignaci�n de presupuestos de venta
                                    if JobDataUnitforProductionL."Amount Production Budget" <> 0 then begin
                                        if (JobDataUnitforProduction."Sale Amount" * (RelCertificationproduct."Percentage Of Assignment" / 100) /
                                            JobDataUnitforProductionL."Amount Production Budget") <> 0 then begin
                                            amountProcess += (JobDataUnitforProductionL."Amount Production Performed" * (1 - JobDataUnitforProduction."% Processed Production" / 100)) *
                                                              (RelCertificationproduct."Percentage Of Assignment" / 100) *
                                                            (JobDataUnitforProduction."Sale Amount" * (RelCertificationproduct."Percentage Of Assignment" / 100) /
                                                             JobDataUnitforProductionL."Amount Production Budget");
                                        end;
                                    end;
                                end;
                            until RelCertificationproduct.NEXT = 0;
                    until JobDataUnitforProduction.NEXT = 0;
                end;
            end;

            //-GEN003-04
            AssignedAmount := 0;
            CurrencyFactor := 0;

            CASE parDivisa OF
                parDivisa::"Local":
                    begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountProcess, Job."Currency Code", '', "Currency Amount Date", 1, AssignedAmount, CurrencyFactor);
                        amountProcess := AssignedAmount;
                    end;
                parDivisa::"Aditional":
                    begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountProcess, Job."Currency Code", Job."Aditional Currency", "Currency Amount Date", 1, AssignedAmount, CurrencyFactor);
                        amountProcess := AssignedAmount;
                    end;
            end;
        end;

        exit(amountProcess);
    end;

    //     procedure AcceptedAmount (parDivisa@100000000 :
    procedure AcceptedAmount(parDivisa: Option "Job","Local","Aditional"): Decimal;
    var
        //       RelCertificationproduct@7207771 :
        RelCertificationproduct: Record 7207397;
        //       JobDataUnitforProductionL@7207772 :
        JobDataUnitforProductionL: Record 7207386;
    begin
        //GEN003-04: A�adido el parametro parDivisa

        amountAccepted := 0;
        if (Job.GET("Job No.")) then begin //JAV 17/05/21: QB 1.08.42 Por si no existe el proyecto
            if not Job."Separation Job Unit/Cert. Unit" then begin
                JobDataUnitforProduction.RESET;
                JobDataUnitforProduction.SETCURRENTKEY("Job No.", "No. Record");
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                // if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
                if JobDataUnitforProduction.FINDSET(FALSE) then begin
                    repeat
                        //amountAccepted += JobDataUnitforProduction.amountProductionInProgress;//JMMA 160920 Se modifica la l�nea por error en el c�lculo de la producci�n ejecutada
                        amountAccepted += JobDataUnitforProduction.AmountProductionAccepted;//JMMA 160920 Se modifica la l�nea por error en el c�lculo de la producci�n ejecutada
                    until JobDataUnitforProduction.NEXT = 0;
                end;
            end else begin
                JobDataUnitforProduction.RESET;
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                JobDataUnitforProduction.SETRANGE("Customer Certification Unit", TRUE);
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                // if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
                if JobDataUnitforProduction.FINDSET(FALSE) then begin
                    repeat
                        RelCertificationproduct.SETRANGE("Job No.", JobDataUnitforProduction."Job No.");
                        RelCertificationproduct.SETRANGE("Certification Unit Code", JobDataUnitforProduction."Piecework Code");
                        if RelCertificationproduct.FINDFIRST then
                            repeat
                                if JobDataUnitforProductionL.GET(RelCertificationproduct."Job No.", RelCertificationproduct."Production Unit Code") then begin
                                    //JMMA 291020 JobDataUnitforProductionL.SETRANGE("Budget Filter",Job."Initial Budget Piecework");
                                    JobDataUnitforProductionL.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                                    JobDataUnitforProductionL.CALCFIELDS("Amount Production Performed", "Amount Production Budget");
                                    //ponderaci�n por asignaci�n de presupuestos de venta
                                    if JobDataUnitforProductionL."Amount Production Budget" <> 0 then begin
                                        if (JobDataUnitforProduction."Sale Amount" * (RelCertificationproduct."Percentage Of Assignment" / 100) /
                                            JobDataUnitforProductionL."Amount Production Budget") <> 0 then begin
                                            amountAccepted += (JobDataUnitforProductionL."Amount Production Performed" * (JobDataUnitforProduction."% Processed Production" / 100)) *
                                                              (RelCertificationproduct."Percentage Of Assignment" / 100) *
                                                            (JobDataUnitforProduction."Sale Amount" * (RelCertificationproduct."Percentage Of Assignment" / 100) /
                                                             JobDataUnitforProductionL."Amount Production Budget");

                                        end;
                                    end;
                                end;
                            until RelCertificationproduct.NEXT = 0;
                    until JobDataUnitforProduction.NEXT = 0;
                end;
            end;

            //-GEN003-04
            AssignedAmount := 0;
            CurrencyFactor := 0;

            CASE parDivisa OF
                parDivisa::"Local":
                    begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountAccepted, Job."Currency Code", '', "Currency Amount Date", 1, AssignedAmount, CurrencyFactor);
                        amountAccepted := AssignedAmount;
                    end;
                parDivisa::Aditional:
                    begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountAccepted, Job."Currency Code", Job."Aditional Currency", "Currency Amount Date", 1, AssignedAmount, CurrencyFactor);
                        amountAccepted := AssignedAmount;
                    end;
            end;
        end;

        exit(amountAccepted);
    end;

    //     procedure SaleAmount (parDivisa@100000000 :
    procedure SaleAmount(parDivisa: Option "Job","Local","Aditional"): Decimal;
    begin
        //GEN003-04: A�adido el parametro parDivisa

        amountSale := 0;

        JobDataUnitforProduction.RESET;
        JobDataUnitforProduction.SETCURRENTKEY("Job No.", "No. Record");
        JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
        JobDataUnitforProduction.SETRANGE("No. Record", "No.");
        JobDataUnitforProduction.SETRANGE("Customer Certification Unit", TRUE);
        JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);

        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        // if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
        if JobDataUnitforProduction.FINDSET(FALSE) then begin
            repeat
                amountSale += JobDataUnitforProduction."Sale Amount";
            until JobDataUnitforProduction.NEXT = 0;
        end;

        //-GEN003-04
        AssignedAmount := 0;
        CurrencyFactor := 0;

        CASE parDivisa OF
            parDivisa::"Local":
                begin
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountSale, Job."Currency Code", '', "Currency Amount Date", 1, AssignedAmount, CurrencyFactor);
                    amountSale := AssignedAmount;
                end;
            parDivisa::Aditional:
                begin
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountSale, Job."Currency Code", Job."Aditional Currency", "Currency Amount Date", 1, AssignedAmount, CurrencyFactor);
                    amountSale := AssignedAmount;
                end;
        end;

        exit(amountSale);
    end;

    //     procedure CostAmount (parDivisa@100000000 :
    procedure CostAmount(parDivisa: Option "Job","Local","Aditional"): Decimal;
    var
        //       JobL@7207771 :
        JobL: Record 167;
        //       JobDataUnitforProductionL@7207772 :
        JobDataUnitforProductionL: Record 7207386;
        //       RelCertificationproduct@7207773 :
        RelCertificationproduct: Record 7207397;
    begin
        //GEN003-04: A�adido el parametro parDivisa

        amountCost := 0;
        if (JobL.GET("Job No.")) then begin  //JAV 17/05/21: QB 1.08.42 Por si no existe el proyecto
            if not JobL."Separation Job Unit/Cert. Unit" then begin
                JobDataUnitforProduction.RESET;
                JobDataUnitforProduction.SETCURRENTKEY("Job No.", "No. Record");
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                // if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
                if JobDataUnitforProduction.FINDSET(FALSE) then begin
                    repeat
                        //JMMA JobDataUnitforProduction.SETRANGE("Budget Filter",JobL."Initial Budget Piecework");
                        JobDataUnitforProduction.SETRANGE("Budget Filter", JobL."Current Piecework Budget");
                        JobDataUnitforProduction.CALCFIELDS("Amount Cost Budget (JC)");
                        amountCost += JobDataUnitforProduction."Amount Cost Budget (JC)";
                    until JobDataUnitforProduction.NEXT = 0;
                end;
            end else begin
                JobDataUnitforProduction.RESET;
                JobDataUnitforProduction.SETRANGE("Job No.", "Job No.");
                JobDataUnitforProduction.SETRANGE("Account Type", JobDataUnitforProduction."Account Type"::Unit);
                JobDataUnitforProduction.SETRANGE("No. Record", "No.");
                JobDataUnitforProduction.SETRANGE("Customer Certification Unit", TRUE);
                //used without Updatekey Parameter to avoid warning - may become error in future release
                /*To be Tested*/
                //if JobDataUnitforProduction.FINDSET(FALSE, FALSE) then begin
                if JobDataUnitforProduction.FINDSET(FALSE) then begin
                    repeat
                        RelCertificationproduct.SETRANGE("Job No.", JobDataUnitforProduction."Job No.");
                        RelCertificationproduct.SETRANGE("Certification Unit Code", JobDataUnitforProduction."Piecework Code");
                        if RelCertificationproduct.FINDFIRST then
                            repeat
                                if JobDataUnitforProductionL.GET(RelCertificationproduct."Job No.", RelCertificationproduct."Production Unit Code") then begin
                                    //jmma error JobDataUnitforProductionL.SETRANGE("Budget Filter",JobL."Initial Budget Piecework");
                                    JobDataUnitforProductionL.SETRANGE("Budget Filter", JobL."Current Piecework Budget");
                                    JobDataUnitforProductionL.CALCFIELDS("Amount Cost Budget (JC)", "Amount Production Budget");
                                    amountCost += JobDataUnitforProductionL."Amount Cost Budget (JC)" * (RelCertificationproduct."Assignment Cost Percentage" / 100);
                                end;
                            until RelCertificationproduct.NEXT = 0;
                    until JobDataUnitforProduction.NEXT = 0;
                end;
            end;

            //-GEN003-04
            AssignedAmount := 0;
            CurrencyFactor := 0;

            CASE parDivisa OF
                parDivisa::"Local":
                    begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountCost, Job."Currency Code", '', "Currency Amount Date", 0, AssignedAmount, CurrencyFactor);
                        amountCost := AssignedAmount;
                    end;
                parDivisa::Aditional:
                    begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", amountCost, Job."Currency Code", Job."Aditional Currency", "Currency Amount Date", 0, AssignedAmount, CurrencyFactor);
                        amountCost := AssignedAmount;
                    end;
            end;
        end;

        exit(amountCost);
    end;

    procedure CreateInitialRecord()
    var
        //       ControlRecordsL@7207771 :
        ControlRecordsL: Record 7207393;
    begin
        if GETFILTER("Job No.") = '' then
            exit;
        QuoBuildingSetup.GET;
        if QuoBuildingSetup."Initial Record Code" = '' then
            exit;
        ControlRecordsL.SETRANGE("Job No.", GETFILTER("Job No."));
        if not ControlRecordsL.FINDFIRST then begin
            "Job No." := GETFILTER("Job No.");
            "No." := QuoBuildingSetup."Initial Record Code";
            INSERT(TRUE);
            "Sale Type" := "Sale Type"::"Main Contract";
            "Record Type" := "Record Type"::Contract;
            "Record Status" := "Record Status"::Approved;
            "Entry Record Date" := WORKDATE;
            VALIDATE(Description, Text005);
            MODIFY;
        end;
    end;

    //     procedure CheckMultiCust (JobNo@100000000 :
    procedure CheckMultiCust(JobNo: Code[20]): Boolean;
    var
        //       Job2@100000001 :
        Job2: Record 167;
    begin
        Job2.GET(JobNo);
        exit(Job2."Multi-Client Job" = Job2."Multi-Client Job"::ByCustomers);
    end;

    /*begin
    //{
//      REQ. Que no exija la descripcion del expediente
//      Se cambian las etiquetas de los tipo de venta, tipo de expediente y se a�aden opciones nuevas para completar la informacion
//      Se cambia la tipificaci�n de los estados de los expedientes
//      Se a�aden las fechas de cambio de estado de los expedientes
//      JAV 30/05/19: - Error en el c�lculo de la produccion en tr�mite
//      JDC 24/07/19: - GAP029 KALAM. Facturar a varios clientes, se modifica el campo 15 "Customer No.", se a�ade la funcion "CheckMultiCust"
//    }
    end.
  */
}








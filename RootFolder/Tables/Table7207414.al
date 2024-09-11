table 7207414 "Vendor Conditions Data"
{


    CaptionML = ENU = 'Vendor Conditions Data', ESP = 'Datos condiciones proveedor';

    fields
    {
        field(1; "Quote Code"; Code[20])
        {
            CaptionML = ENU = 'Quote Code', ESP = 'C�d. Oferta';


        }
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Vendor No.', ESP = 'N� Proveedor';

            trigger OnValidate();
            VAR
                //                                                                 Txt01@1100286000 :
                Txt01: TextConst ESP = 'El proveedor %1 est� bloqueado para comparativos, no lo puede utilizar';
                //                                                                 Txt02@1100286001 :
                Txt02: TextConst ESP = 'El proveddor %1 no tiene ficha de condiciones para la actividad %2';
            BEGIN
                IF ComparativeQuoteHeader.GET("Quote Code") THEN
                    IF ComparativeQuoteHeader."Job No." <> '' THEN
                        "Job No." := ComparativeQuoteHeader."Job No.";

                IF "Vendor No." <> '' THEN BEGIN
                    //Ver si esta bloqueado para comparativos
                    VendorQualityData.RESET;
                    VendorQualityData.SETRANGE("Vendor No.", "Vendor No.");
                    VendorQualityData.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");
                    IF (VendorQualityData.FINDFIRST) THEN
                        IF (VendorQualityData."Comparative Blocked") THEN
                            ERROR(Txt01, "Vendor No.");

                    //JAV 18/11/19: - Ver las condiciones del proveedor seg�n el nuevo sistema, de la primera actividad del comparativo
                    ActivityQB.RESET;
                    ActivityQB.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");
                    ActivityQB.FINDFIRST;

                    QualityManagement.GetActualConditions(ConditionsVendor, "Vendor No.", "Job No.", ActivityQB."Activity Code", ComparativeQuoteHeader."Comparative Date");
                    VALIDATE("Quote Validity", ConditionsVendor."Validity Quotes");
                    VALIDATE("Payment Terms Code", ConditionsVendor."Payment Terms Code");
                    VALIDATE("Payment Method Code", ConditionsVendor."Payment Method Code");
                    VALIDATE("Payment Phases", ConditionsVendor."Payment Phases");
                    VALIDATE("Withholding Code", ConditionsVendor."Withholding Code");
                    VALIDATE(Warranty, ConditionsVendor.Warranty);

                    //A�adir puntuaciones de calidad
                    VendorQualityData.CALCFIELDS("Total Average Punctuation");
                    VALIDATE("Evaluation Activity", VendorQualityData."Punctuation end");
                    VALIDATE("Evaluation Global", VendorQualityData."Total Average Punctuation");

                    //A�adir las otras condiciones del proveedor para la l�nea de condiciones y para el proveedor en general
                    DataOtherConditions.RESET;
                    DataOtherConditions.SETRANGE("Vendor No.", "Vendor No.");
                    DataOtherConditions.SETFILTER("Line No.", '=%1 | =%2', 0, ConditionsVendor."Line No.");
                    //IF DataOtherConditions.FINDSET(FALSE,FALSE) THEN BEGIN 
                    //used without Updatekey Parameter to avoid warning - may become error in future release
                    /*To be Tested*/
                    IF DataOtherConditions.FINDSET(FALSE) THEN BEGIN
                        REPEAT
                            OtherVendorConditions.VALIDATE("Quote Code", "Quote Code");
                            OtherVendorConditions.VALIDATE("Vendor No.", DataOtherConditions."Vendor No.");
                            OtherVendorConditions.VALIDATE(Code, DataOtherConditions.Code);
                            OtherVendorConditions.VALIDATE(Description, DataOtherConditions.Description);
                            OtherVendorConditions.VALIDATE(Amount, DataOtherConditions.Amount);
                            IF (NOT OtherVendorConditions.INSERT(TRUE)) THEN;
                        UNTIL DataOtherConditions.NEXT = 0;
                    END;

                    //A�adir las l�neas de producto/recurso
                    ComparativeQuoteLines.RESET;
                    ComparativeQuoteLines.SETRANGE("Quote No.", "Quote Code");
                    //used without Updatekey Parameter to avoid warning - may become error in future release
                    /*To be Tested*/
                    //IF ComparativeQuoteLines.FINDSET(FALSE, FALSE) THEN BEGIN
                    IF ComparativeQuoteLines.FINDSET(FALSE) THEN BEGIN
                        REPEAT
                            CLEAR(DataPricesVendor);
                            DataPricesVendor.INIT;
                            DataPricesVendor.VALIDATE("Quote Code", "Quote Code");
                            DataPricesVendor.VALIDATE("Vendor No.", "Vendor No.");
                            DataPricesVendor.VALIDATE("Line No.", ComparativeQuoteLines."Line No.");
                            DataPricesVendor.VALIDATE(Type, ComparativeQuoteLines.Type);
                            DataPricesVendor.VALIDATE("No.", ComparativeQuoteLines."No.");
                            DataPricesVendor.VALIDATE(Quantity, ComparativeQuoteLines.Quantity);
                            DataPricesVendor.VALIDATE("Job No.", ComparativeQuoteLines."Job No.");
                            DataPricesVendor.VALIDATE("Location Code", ComparativeQuoteLines."Location Code");
                            DataPricesVendor.VALIDATE("Code Piecework PRESTO", ComparativeQuoteLines."Code Piecework PRESTO"); //QB3685
                                                                                                                               //JAV 08/03/19: - A�adir la U.O. en la linea
                            DataPricesVendor.VALIDATE("Piecework No.", ComparativeQuoteLines."Piecework No.");
                            //JAV --
                            IF DataPricesVendor.INSERT(TRUE) THEN;
                        UNTIL ComparativeQuoteLines.NEXT = 0;
                    END;
                END;
            END;

            trigger OnLookup();
            BEGIN
                ComparativeQuoteHeader.GET("Quote Code");

                VendorQualityData.RESET;
                VendorQualityData.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");

                CLEAR(VendorDataList);
                VendorDataList.LOOKUPMODE(TRUE);
                VendorDataList.SETTABLEVIEW(VendorQualityData);
                IF VendorDataList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    VendorDataList.GETRECORD(VendorQualityData);
                    VALIDATE("Vendor No.", VendorQualityData."Vendor No.");
                END;
            END;


        }
        field(4; "Quote Validity"; DateFormula)
        {
            CaptionML = ENU = 'Quote Validity', ESP = 'Validez Oferta';


        }
        field(5; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';


        }
        field(6; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';


        }
        field(7; "Withholding Code"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"),
                                                                                                 "Use in" = FILTER('Booth' | 'Vendor'));


            CaptionML = ENU = 'Withholding Code', ESP = 'C�d. retenci�n';

            trigger OnValidate();
            BEGIN
                IF WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", "Withholding Code") THEN
                    "Return Withholding" := WithholdingGroup."Warranty Period";
            END;


        }
        field(8; "Warranty"; DateFormula)
        {
            CaptionML = ENU = 'Warranty', ESP = 'Garant�a';


        }
        field(9; "Other Conditions"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Other Vendor Conditions" WHERE("Quote Code" = FIELD("Quote Code"),
                                                                                                      "Vendor No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Other Conditions', ESP = 'Otras condiciones';
            Editable = false;


        }
        field(10; "Selected Vendor"; Boolean)
        {
            CaptionML = ENU = 'Selected Vendor', ESP = 'Proveedor seleccionado';
            Editable = false;


        }
        field(11; "Total Estimated Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Comparative Quote Lines"."Estimated Amount" WHERE("Quote No." = FIELD("Quote Code")));
            CaptionML = ENU = 'Total Estimated Amount', ESP = 'Importe total previsto';
            Editable = false;
            AutoFormatType = 1;


        }
        field(12; "Total Target Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Comparative Quote Lines"."Target Amount" WHERE("Quote No." = FIELD("Quote Code")));
            CaptionML = ENU = 'Total Target Amount', ESP = 'Importe total objetivo';
            Editable = false;
            AutoFormatType = 1;


        }
        field(13; "Total Vendor Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Prices Vendor"."Purchase Amount" WHERE("Quote Code" = FIELD("Quote Code"),
                                                                                                                 "Vendor No." = FIELD("Vendor No."),
                                                                                                                 "Contact No." = FIELD("Contact No."),
                                                                                                                 "Version No." = FIELD("Version No.")));
            CaptionML = ENU = 'Total Vendor Amount', ESP = 'Importe total proveedor';
            Editable = false;
            AutoFormatType = 1;


        }
        field(14; "Other Conditions Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Other Vendor Conditions"."Amount" WHERE("Quote Code" = FIELD("Quote Code"),
                                                                                                           "Vendor No." = FIELD("Vendor No."),
                                                                                                           "Contact No." = FIELD("Contact No."),
                                                                                                           "Version No." = FIELD("Version No.")));
            CaptionML = ENU = 'Other Conditions Amount', ESP = 'Importe otras condiciones';
            Editable = false;
            AutoFormatType = 1;


        }
        field(15; "Return Withholding"; DateFormula)
        {
            CaptionML = ENU = 'Return Withholding', ESP = 'Devol. Retenci�n';


        }
        field(16; "Start Date"; Date)
        {
            CaptionML = ENU = 'Start Date', ESP = 'Fecha inicio';


        }
        field(17; "End Date"; Date)
        {
            CaptionML = ENU = 'End Date', ESP = 'Fecha fin';


        }
        field(18; "Quonte Date"; Date)
        {
            CaptionML = ENU = 'Quonte Date', ESP = 'Fecha oferta';


        }
        field(19; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Editable = false;


        }
        field(20; "Initial Estimated Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Comparative Quote Lines"."Initial Estimated Amount" WHERE("Quote No." = FIELD("Quote Code")));
            CaptionML = ENU = 'Initial Estimated Total Amount', ESP = 'Importe total previsto inicial';
            Editable = false;
            AutoFormatType = 1;


        }
        field(21; "Contact No."; Code[20])
        {
            TableRelation = Contact."No." WHERE("Type" = CONST("Company"));


            CaptionML = ENU = 'Contact No.', ESP = 'N� contacto';

            trigger OnValidate();
            BEGIN
                IF ComparativeQuoteHeader.GET("Quote Code") THEN BEGIN
                    IF ComparativeQuoteHeader."Job No." <> '' THEN
                        "Job No." := ComparativeQuoteHeader."Job No.";
                END;

                IF "Contact No." <> '' THEN BEGIN
                    ContactActivitiesQB.RESET;
                    ContactActivitiesQB.SETRANGE("Contact No.", "Contact No.");
                    ContactActivitiesQB.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");
                    IF NOT ContactActivitiesQB.FINDFIRST THEN
                        ERROR(Text005, "Vendor No.");

                    ComparativeQuoteLines.RESET;
                    ComparativeQuoteLines.SETRANGE(ComparativeQuoteLines."Quote No.", "Quote Code");
                    IF ComparativeQuoteLines.FIND('-') THEN BEGIN
                        REPEAT
                            CLEAR(DataPricesVendor);
                            DataPricesVendor.INIT;
                            DataPricesVendor.VALIDATE(DataPricesVendor."Quote Code", "Quote Code");
                            DataPricesVendor.VALIDATE(DataPricesVendor."Contact No.", "Contact No.");
                            DataPricesVendor.VALIDATE(DataPricesVendor."Vendor No.", "Vendor No.");
                            DataPricesVendor.VALIDATE(DataPricesVendor."Line No.", ComparativeQuoteLines."Line No.");
                            DataPricesVendor.VALIDATE(DataPricesVendor.Type, ComparativeQuoteLines.Type);
                            DataPricesVendor.VALIDATE(DataPricesVendor."No.", ComparativeQuoteLines."No.");
                            DataPricesVendor.VALIDATE(DataPricesVendor.Quantity, ComparativeQuoteLines.Quantity);
                            DataPricesVendor.VALIDATE(DataPricesVendor."Job No.", ComparativeQuoteLines."Job No.");
                            DataPricesVendor.VALIDATE(DataPricesVendor."Location Code", ComparativeQuoteLines."Location Code");
                            DataPricesVendor.VALIDATE("Code Piecework PRESTO", ComparativeQuoteLines."Code Piecework PRESTO"); //QB3685
                                                                                                                               //JAV 08/03/19: - A�adir la U.O. en la linea
                            DataPricesVendor.VALIDATE("Piecework No.", ComparativeQuoteLines."Piecework No.");
                            //JAV --
                            IF DataPricesVendor.INSERT(TRUE) THEN;
                        UNTIL ComparativeQuoteLines.NEXT = 0;
                    END;
                END;
            END;

            trigger OnLookup();
            BEGIN
                ComparativeQuoteHeader.GET("Quote Code");
                CLEAR(ContactActivitiesQB);
                ContactActivitiesQB.RESET;
                ContactActivitiesQB.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");

                CLEAR(ContactsofanActivity);
                ContactsofanActivity.LOOKUPMODE(TRUE);
                ContactsofanActivity.SETTABLEVIEW(ContactActivitiesQB);
                IF ContactsofanActivity.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ContactsofanActivity.GETRECORD(ContactActivitiesQB);
                    VALIDATE("Contact No.", ContactActivitiesQB."Contact No.");
                END;
            END;


        }
        field(22; "Payment Phases"; Code[20])
        {
            TableRelation = "QB Payments Phases";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fases de Pago';
            Description = 'QB 1.06.00 - JAV 06/07/20: - Si el pago se hacer por fases de pago';

            trigger OnValidate();
            BEGIN
                IF ("Payment Phases" <> '') THEN BEGIN
                    "Payment Method Code" := '';
                    "Payment Terms Code" := '';
                END ELSE BEGIN
                    IF Vendor.GET("Vendor No.") THEN BEGIN
                        IF ("Payment Method Code" = '') THEN
                            "Payment Method Code" := Vendor."Payment Method Code";
                        IF ("Payment Terms Code" = '') THEN
                            "Payment Terms Code" := Vendor."Payment Terms Code";
                    END;
                END;
            END;


        }
        field(23; "Lines whitout prices"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Data Prices Vendor" WHERE("Quote Code" = FIELD("Quote Code"),
                                                                                                 "Vendor No." = FIELD("Vendor No."),
                                                                                                 "Version No." = FIELD("Version No."),
                                                                                                 "Vendor Price" = CONST(0)));
            CaptionML = ESP = 'L�neas sin precio';
            Description = 'QB 1.07.13 - JAV 16/12/20: - Si tiene l�neas sin precio';
            Editable = false;


        }
        field(24; "Version No."; Integer)
        {
            InitValue = 0;
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Version No.', ESP = 'N� versi�n';
            NotBlank = true;
            Description = 'Q13150';
            Editable = false;


        }
        field(25; "Version Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de la Versi�n';
            Description = 'Q13150';


        }
        field(26; "MAX Version"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Max("Vendor Conditions Data"."Version No." WHERE("Quote Code" = FIELD("Quote Code"),
                                                                                                                 "Vendor No." = FIELD("Vendor No."),
                                                                                                                 "Contact No." = FIELD("Contact No.")));
            CaptionML = ENU = 'MAX Version', ESP = 'Mayor versi�n';
            Description = 'Q13150';


        }
        field(30; "Evaluation Global"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Evaluaci�n global';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Puntuaci�n final obtenida en esta actividad, en el momento de creaci�n del comparativo';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Clasification Global" := CodesEvaluation.GetClasification("Evaluation Global");
            END;


        }
        field(31; "Clasification Global"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n global';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Clasificaci�n final obtenida en esta actividad, en el momento de creaci�n del comparativo';
            Editable = false;


        }
        field(32; "Evaluation Activity"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Evaluaci�n de la actividad';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Puntuaci�n media del proveedor en todas las actividades,, en el momento de creaci�n del comparativo';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Clasification Activity" := CodesEvaluation.GetClasification("Evaluation Activity");
            END;


        }
        field(33; "Clasification Activity"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n de la actividad';
            Description = 'QB 1.06.08 - JAV 14/08/20: - Clasificaci�n media del proveedor en todas las actividades,, en el momento de creaci�n del comparativo';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Quote Code", "Vendor No.", "Contact No.", "Version No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       ComparativeQuoteHeader@7001100 :
        ComparativeQuoteHeader: Record 7207412;
        //       ConditionsVendor@7001101 :
        ConditionsVendor: Record 7207420;
        //       Vendor@7001102 :
        Vendor: Record 23;
        //       Text000@7001103 :
        Text000: TextConst ENU = 'You are trying to enter vendor %1 that has no condition data', ESP = 'Est� intentando introducir el proveedor %1 que no tiene datos de condiciones';
        //       DataOtherConditions@7001104 :
        DataOtherConditions: Record 7207421;
        //       OtherVendorConditions@7001106 :
        OtherVendorConditions: Record 7207416;
        //       ComparativeQuoteLines@7001107 :
        ComparativeQuoteLines: Record 7207413;
        //       DataPricesVendor@7001108 :
        DataPricesVendor: Record 7207415;
        //       VendorQualityData@7001109 :
        VendorQualityData: Record 7207418;
        //       WithholdingGroup@7001111 :
        WithholdingGroup: Record 7207330;
        //       ContactActivitiesQB@7001112 :
        ContactActivitiesQB: Record 7207430;
        //       VendorDataList@7001110 :
        VendorDataList: Page 7207338;
        //       ContactsofanActivity@7001114 :
        ContactsofanActivity: Page 7207603;
        //       Skip@7001115 :
        Skip: Boolean;
        //       QualityManagement@1100286000 :
        QualityManagement: Codeunit 7207293;
        //       PurchasesPayablesSetup@1100286001 :
        PurchasesPayablesSetup: Record 312;
        //       ActivityQB@100000000 :
        ActivityQB: Record 7207280;
        //       CodesEvaluation@1100286003 :
        CodesEvaluation: Record 7207422;
        //       Text001@1100286006 :
        Text001: TextConst ESP = 'No ha generado un proveedor para el contacto %1';
        //       Text002@1100286005 :
        Text002: TextConst ENU = 'You have selected the Vendor %1 that is already marked as selected in the %2 Quote.', ESP = 'Ha seleccionado el proveedor %1 que ya est� marcado como seleccionado en la oferta %2';
        //       Text003@1100286004 :
        Text003: TextConst ENU = 'You can not try to change the selected Vendor because the %1 Quote is approved.', ESP = 'No se puede intentar cambiar el proveedor seleccionado debido a que la oferta %1 est� aprobada por la D.C.';
        //       Text004@1100286002 :
        Text004: TextConst ESP = 'El proveedor %1 est� bloqueado para comparativos, no se puede utilizar';
        //       Text005@1100286007 :
        Text005: TextConst ENU = 'You are attempting to enter contact %1 which does not provide activities for this comparative', ESP = 'Est� intentando introducir el contacto %1 que no proporciona actividades para este comparativo';



    trigger OnInsert();
    begin
        CheckStatus;
    end;

    trigger OnModify();
    begin
        CheckStatus;
    end;

    trigger OnDelete();
    begin
        CheckStatus;

        DataPricesVendor.RESET;
        DataPricesVendor.SETRANGE("Quote Code", "Quote Code");
        DataPricesVendor.SETRANGE("Vendor No.", "Vendor No.");
        DataPricesVendor.SETRANGE("Contact No.", "Contact No.");
        DataPricesVendor.SETRANGE("Version No.", "Version No.");  //JAV 23/04/21: - Se a�ade la versi�n en el delete y en los c�lculos de los importes
        DataPricesVendor.DELETEALL;

        OtherVendorConditions.RESET;
        OtherVendorConditions.SETRANGE("Quote Code", "Quote Code");
        OtherVendorConditions.SETRANGE("Vendor No.", "Vendor No.");
        OtherVendorConditions.SETRANGE("Contact No.", "Contact No.");
        OtherVendorConditions.SETRANGE("Version No.", "Version No.");  //JAV 23/04/21: - Se a�ade la versi�n en el delete y en los c�lculos de los importes
        OtherVendorConditions.DELETEALL;
    end;



    procedure CheckStatus()
    begin
        if ComparativeQuoteHeader.GET("Quote Code") then begin
            ComparativeQuoteHeader.TESTFIELD("Approval Status", ComparativeQuoteHeader."Approval Status"::Open);
        end;
    end;

    procedure RelationshipBusinessCreated(): Code[20];
    var
        //       MarketingSetup@7001100 :
        MarketingSetup: Record 5079;
        //       ContactBusinessRelation@7001101 :
        ContactBusinessRelation: Record 5054;
    begin
        if "Contact No." = '' then
            exit('');
        MarketingSetup.GET;
        ContactBusinessRelation.SETRANGE("Contact No.", "Contact No.");
        ContactBusinessRelation.SETRANGE("Business Relation Code", MarketingSetup."Bus. Rel. Code for Vendors");
        if ContactBusinessRelation.FINDFIRST then
            exit(ContactBusinessRelation."No.")
        else
            exit('');
    end;

    procedure NameVendorContact(): Text[60];
    var
        //       Vendor@7001100 :
        Vendor: Record 23;
        //       Contact@7001101 :
        Contact: Record 5050;
    begin
        if "Vendor No." <> '' then begin
            if not Vendor.GET("Vendor No.") then
                CLEAR(Vendor);
            exit(Vendor.Name);
        end else begin
            if not Contact.GET("Contact No.") then
                CLEAR(Contact);
            exit(Contact.Name);
        end;
    end;

    procedure CountyVendorContact(): Text[60];
    var
        //       Vendor@7001100 :
        Vendor: Record 23;
        //       Contact@7001101 :
        Contact: Record 5050;
    begin
        //JAV 09/07/19: - Funci�n que retorna la provicia del vendedor o del contacto
        if "Vendor No." <> '' then begin
            if not Vendor.GET("Vendor No.") then
                CLEAR(Vendor);
            exit(Vendor.County);
        end else begin
            if not Contact.GET("Contact No.") then
                CLEAR(Contact);
            exit(Contact.County);
        end;
    end;

    //     procedure SelectVendor (var pVendorConditionsData@7001100 :
    procedure SelectVendor(var pVendorConditionsData: Record 7207414)
    var
        //       ComparativeQuoteHeader@7001101 :
        ComparativeQuoteHeader: Record 7207412;
        //       ContactBusinessRelation@7001102 :
        ContactBusinessRelation: Record 5054;
        //       VendorConditionsData@7001103 :
        VendorConditionsData: Record 7207414;
    begin
        if (ComparativeQuoteHeader.GET(pVendorConditionsData."Quote Code")) then begin
            if (ComparativeQuoteHeader."Approval Status" <> ComparativeQuoteHeader."Approval Status"::Open) then
                ERROR(Text003, ComparativeQuoteHeader."Job No.")
            else begin
                if (pVendorConditionsData."Selected Vendor") then
                    ERROR(Text002, pVendorConditionsData."Vendor No.", pVendorConditionsData."Quote Code")
                else begin
                    //Si est� bloqueado no se puede usar
                    VendorQualityData.RESET;
                    VendorQualityData.SETRANGE("Vendor No.", "Vendor No.");
                    VendorQualityData.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");
                    if (VendorQualityData.FINDFIRST) then
                        if (VendorQualityData."Comparative Blocked") then
                            ERROR(Text004, "Vendor No.");

                    //Quito la marcar de seleccionado si hubiera alguno
                    VendorConditionsData.SETRANGE("Quote Code", ComparativeQuoteHeader."No.");
                    VendorConditionsData.MODIFYALL("Selected Vendor", FALSE);
                    //Si no tiene vendedor, pero el contato si lo tiene, lo guardo
                    if (pVendorConditionsData."Vendor No." = '') and (pVendorConditionsData."Contact No." <> '') then begin
                        ContactBusinessRelation.SETRANGE("Contact No.", pVendorConditionsData."Contact No.");
                        ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);
                        ContactBusinessRelation.SETFILTER("No.", '<>%1', '');
                        if (ContactBusinessRelation.FINDFIRST) then
                            pVendorConditionsData."Vendor No." := ContactBusinessRelation."No.";
                    end;
                    //Si no tiene vendedor seleccionado dar un error
                    if (pVendorConditionsData."Vendor No." = '') then
                        ERROR(Text001);
                    //Marcar que es el seleccionado
                    pVendorConditionsData."Selected Vendor" := TRUE;
                    pVendorConditionsData.MODIFY;

                    //Marcar el proveedor seleccionado en el comparativo
                    ComparativeQuoteHeader."Selection Made" := TRUE;
                    ComparativeQuoteHeader."Selected Vendor" := pVendorConditionsData."Vendor No.";
                    ComparativeQuoteHeader."Contact Selectd No." := pVendorConditionsData."Contact No.";
                    ComparativeQuoteHeader."Amount Purchase" := pVendorConditionsData."Total Vendor Amount";

                    //Q13150 -
                    ComparativeQuoteHeader."Selected Version No." := pVendorConditionsData."Version No.";
                    //Q13150 +

                    //JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o al desechar, cambiar el estado
                    ComparativeQuoteHeader."Comparative Status" := ComparativeQuoteHeader."Comparative Status"::Selected;

                    ComparativeQuoteHeader.MODIFY(TRUE);

                    //JAV 28/02/22: - QB 1.10.22 Al seleccionar el vendedor hay que actualizar las dimensiones
                    ComparativeQuoteHeader.CreateDim();
                    ComparativeQuoteHeader.MODIFY(FALSE);

                end;
            end;
        end;
    end;

    //     procedure UnselectVendor (var parQuote@7001100 :
    procedure UnselectVendor(var parQuote: Code[20])
    var
        //       ComparativeQuoteHeader@7001101 :
        ComparativeQuoteHeader: Record 7207412;
        //       ContactBusinessRelation@7001102 :
        ContactBusinessRelation: Record 5054;
        //       Text001@1100251002 :
        Text001: TextConst ENU = 'Can not select a contact that has no related vendor', ESP = 'No se puede seleccionar un contacto que no tenga relaccionado proveedor';
        //       VendorConditionsData@7001103 :
        VendorConditionsData: Record 7207414;
        //       Text002@7001105 :
        Text002: TextConst ENU = 'You have selected the Vendor %1 that is already marked as selected in the %2 Quote.', ESP = 'Ha seleccionado el proveedor %1 que ya est� marcado como seleccionado en la oferta %2';
        //       Text003@7001104 :
        Text003: TextConst ENU = 'You can not try to change the selected Vendor because the %1 Quote is approved.', ESP = 'No se puede intentar cambiar el proveedor seleccionado debido a que la oferta %1 est� aprobada por la D.C.';
    begin
        ComparativeQuoteHeader.RESET;
        ComparativeQuoteHeader.SETRANGE(ComparativeQuoteHeader."No.", parQuote);
        if ComparativeQuoteHeader.FINDFIRST then begin
            if ComparativeQuoteHeader."Approval Status" <> ComparativeQuoteHeader."Approval Status"::Open then
                ERROR(Text003, ComparativeQuoteHeader."Job No.")
            else begin
                //Desmarco el seleccionado
                VendorConditionsData.SETRANGE("Quote Code", ComparativeQuoteHeader."No.");
                VendorConditionsData.MODIFYALL("Selected Vendor", FALSE);
                //Modifico los datos de la cabecera
                ComparativeQuoteHeader."Selection Made" := FALSE;
                ComparativeQuoteHeader."Selected Vendor" := '';
                ComparativeQuoteHeader."Contact Selectd No." := '';
                ComparativeQuoteHeader."Amount Purchase" := 0;

                //Q13150 -
                ComparativeQuoteHeader."Selected Version No." := 0;
                //Q13150 +

                //JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o al desechar, cambiar el estado
                ComparativeQuoteHeader."Comparative Status" := ComparativeQuoteHeader."Comparative Status"::InProcess;

                ComparativeQuoteHeader.MODIFY(TRUE);
            end;
        end;
    end;

    /*begin
    //{
//      PEL 25/09/18: - QB3685 Traspasar campo "Code Piecework PRESTO"
//      JAV 08/03/19: - A�adir la U.O. en la linea
//      JAV 09/07/19: - Funci�n que retorna la provicia del vendedor o del contacto
//      JAV 18/11/19: - Ver las condiciones del proveedor seg�n el nuevo sistema
//      JAV 04/12/19: - El importe total de la compra es el de las l�neas mas el de otras condiciones si est� as� configurado
//      JDC 30/03/21: - Q13150 Added field 24 "Version", 25 "MAX Version"
//                             Modified Primary Key
//                             Modified function "SelectVendor", "UnselectVendor"
//      JAV 23/04/21: - Se a�ade la versi�n en el delete y en loa c�lculos de los importes
//      JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o eliminarlo, o al desechar el comparativo, cambiar el estado del comparativo
//    }
    end.
  */
}








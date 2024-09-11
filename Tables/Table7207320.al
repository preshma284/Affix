table 7207320 "QBU Expense Notes Header"
{


    CaptionML = ENU = 'Expense Notes Header', ESP = 'Cab. Notas de gastos';
    LookupPageID = "Expense Notes List";
    DrillDownPageID = "Expense Notes List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    PurchasesSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := PurchasesSetup."Expense Notes No. Series";
                END;
            END;


        }
        field(2; "Employee"; Code[20])
        {
            TableRelation = Vendor."No." WHERE("QB Employee" = CONST(true));


            CaptionML = ENU = 'Employee', ESP = 'Empleado';

            trigger OnValidate();
            BEGIN
                IF Vendor.GET(Employee) THEN BEGIN
                    VALIDATE("Currency Code", Vendor."Currency Code");
                    VALIDATE("PIT Withholding Group", Vendor."QW Withholding Group by PIT");
                    VALIDATE("Expense Description", Vendor.Name);
                    VALIDATE("Payment Method Code", Vendor."Payment Method Code");
                END;

                CreateDim(DATABASE::Vendor, Employee);
            END;


        }
        field(3; "Expense Description"; Text[50])
        {
            CaptionML = ENU = 'Expense Description', ESP = 'Descripcion Gasto';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(5; "Validated Note"; Boolean)
        {
            CaptionML = ENU = 'Validated Note', ESP = 'Nota Validada';


        }
        field(6; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(7; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            END;


        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            END;


        }
        field(10; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            CaptionML = ENU = 'Currency Code', ESP = 'C�digo de divisa';

            trigger OnValidate();
            BEGIN
                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    ExpenseNotesLines.RESET;
                    ExpenseNotesLines.SETRANGE("Document No.", "No.");
                    ExpenseNotesLines."Currency Code" := "Currency Code";
                    ExpenseNotesLines.MODIFYALL("Currency Code", ExpenseNotesLines."Currency Code");
                END;
            END;


        }
        field(11; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;


        }
        field(12; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Lines Expen. Notes" WHERE("Document Type" = CONST("Expense Notes"),
                                                                                                         "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(13; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(15; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'N� Serie Registro';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    PurchasesSetup.GET;
                    TestNoSeries;
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            VAR
                //                                                               ExpenseNotesHeader@7207270 :
                ExpenseNotesHeader: Record 7207320;
            BEGIN
                /*To be Tested*/
                // WITH ExpenseNotesHeader DO BEGIN
                ExpenseNotesHeader := Rec;
                PurchasesSetup.GET;
                TestNoSeries;
                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := ExpenseNotesHeader;
                // END;
            END;


        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(17; "Expense Note Date"; Date)
        {
            CaptionML = ENU = 'Expense Note Date', ESP = 'Fecha Nota Gastos';


        }
        field(18; "PIT Withholding Group"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = CONST("PIT"));


            CaptionML = ENU = 'PIT Deduction Groups', ESP = 'Grupo Retenci�n IRPF';

            trigger OnValidate();
            BEGIN
                IF "PIT Withholding Group" <> xRec."PIT Withholding Group" THEN BEGIN
                    ExpenseNotesLines.RESET;
                    ExpenseNotesLines.SETRANGE("Document No.", "No.");
                    IF ExpenseNotesLines.FINDFIRST THEN
                        MESSAGE(text009);
                END;
            END;


        }
        field(19; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsability Center', ESP = 'Centro de Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 Respcenter@7207270 :
                Respcenter: Record 5714;
            BEGIN
                IF NOT UserMgt.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(Text027, Respcenter.TABLECAPTION, FunctionQB.GetUserJobResponsibilityCenter());
            END;


        }
        field(20; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expense Notes Lines"."Total Amount" WHERE("Document No." = FIELD("No."),
                                                                                                               "Expense Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';


        }
        field(21; "Amount Including VAT"; Decimal)
        {
            CaptionML = ENU = 'Amount Including VAT', ESP = 'Importe IVA Incluido';


        }
        field(22; "PIT Withholding"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expense Notes Lines"."Withholding Amount" WHERE("Document No." = FIELD("No."),
                                                                                                                     "Expense Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'PIT Withholding', ESP = 'Retenciones IRPF';


        }
        field(23; "VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expense Notes Lines"."VAT Amount" WHERE("Document No." = FIELD("No."),
                                                                                                             "Expense Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'VAT Amount', ESP = 'Importe IVA';
            Description = 'Field for statistics';


        }
        field(25; "Applies-to Doc. Type"; Option)
        {
            OptionMembers = " ","Payment","Invoce","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";

            CaptionML = ENU = 'Applies-to Doc. Type', ESP = 'Liq. por tipo documento';
            OptionCaptionML = ENU = '" ,Payment,Invoce,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,Bill"', ESP = '" ,Pago,Factura,Abonos,Docs. inter�s,Recordatorio,Reembolso,,,,,,,,,,,,,,Efecto"';


            trigger OnValidate();
            BEGIN
                IF "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" THEN
                    VALIDATE("Applies-to Doc. No.", '');
            END;


        }
        field(26; "Applies-to Doc. No."; Code[20])
        {


            CaptionML = ENU = 'Applies-to Doc. No.', ESP = 'Liq. por N� documento';

            trigger OnLookup();
            BEGIN
                CLEAR(VendLedgEntry);
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                VendLedgEntry.SETRANGE("Vendor No.", Employee);
                VendLedgEntry.SETRANGE(Open, TRUE);
                VendLedgEntry.SETRANGE(Positive, TRUE);

                IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
                    VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                    IF NOT VendLedgEntry.FINDFIRST THEN
                        VendLedgEntry.SETRANGE("Document Type");
                END;
                IF "Applies-to Doc. No." <> '' THEN BEGIN
                    VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                    IF NOT VendLedgEntry.FINDFIRST THEN
                        VendLedgEntry.SETRANGE("Document No.");
                END;
                VendLedgEntry.FINDFIRST;
                ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                ApplyVendEntries.SETRECORD(VendLedgEntry);
                ApplyVendEntries.LOOKUPMODE(TRUE);
                IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ApplyVendEntries.GETRECORD(VendLedgEntry);
                    CLEAR(ApplyVendEntries);
                    VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    //"Applies-to Doc. Type" := VendLedgEntry."Document Type";
                    /*To be Tested*/
                    "Applies-to Doc. Type" := ConvertDocumentTypeToOption(VendLedgEntry."Document Type");
                    "Applies-to Doc. No." := VendLedgEntry."Document No.";
                    "Remaining Advance Amount DL" := VendLedgEntry."Remaining Amt. (LCY)";
                END ELSE
                    CLEAR(ApplyVendEntries);
            END;


        }
        field(27; "Remaining Advance Amount DL"; Decimal)
        {
            CaptionML = ENU = 'Remaining Advance Amount DL', ESP = 'Importe pdte. anticipo DL';
            BlankZero = true;
            Editable = false;


        }
        field(30; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                CreateDim(DATABASE::Job, "Job No.");
            END;


        }
        field(31; "Bal. Account Type"; Option)
        {
            OptionMembers = " ","Account","Bank";

            CaptionML = ENU = 'Bal. Account Type', ESP = 'Tipo Contrapartida';
            OptionCaptionML = ENU = '" ,Account, Banco"', ESP = '" ,Cuenta,Banco"';


            trigger OnValidate();
            BEGIN
                IF "Bal. Account Type" <> xRec."Bal. Account Type" THEN
                    "Bal. Account Code" := '';
            END;


        }
        field(32; "Bal. Account Code"; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("Account")) "G/L Account" ELSE IF ("Bal. Account Type" = CONST("Bank")) "Bank Account";


            CaptionML = ENU = 'Bal. Account Code', ESP = 'C�d. Contrapartida';

            trigger OnValidate();
            VAR
                //                                                                 BankAccount@7207270 :
                BankAccount: Record 270;
            BEGIN
                IF "Bal. Account Type" = "Bal. Account Type"::Bank THEN BEGIN
                    IF "Bal. Account Code" <> '' THEN BEGIN
                        BankAccount.GET("Bal. Account Code");
                        BankAccount.TESTFIELD("Currency Code", "Currency Code");
                    END;
                END;
            END;


        }
        field(33; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Payment Code', ESP = 'Metodo pago';


        }
        field(34; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00- JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(121; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = '_Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(122; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Comentario Aprobaci�n';
            Description = '###ELIMINAR### no se usa';
            Editable = false;


        }
        field(123; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '_Fecha aprobaci�n';
            Description = '###ELIMINAR### no se usa';


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("ExpenseNote"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(7238177; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QPR';


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CommentLinesExpenNotes@7207274 :
        CommentLinesExpenNotes: Record 7207322;
        //       ExpenseNotesLines@7207273 :
        ExpenseNotesLines: Record 7207321;
        //       PurchasesSetup@7207270 :
        PurchasesSetup: Record 312;
        //       Vendor@7207276 :
        Vendor: Record 23;
        //       NoSeriesMgt@7207271 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       Text002@7207272 :
        Text002: TextConst ENU = 'Expense Note No:', ESP = 'Nota de gasto N�:';
        //       Text003@7207275 :
        Text003: TextConst ENU = 'Name can''t be changed to %1', ESP = 'No se puede cambiar el nombre a %1';
        //       DimMgt@7207278 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       FunctionQB@7207281 :
        FunctionQB: Codeunit 7207272;
        //       UserMgt@1100286000 :
        UserMgt: Codeunit 5700;
        //       OldDimSetID@7207277 :
        OldDimSetID: Integer;
        //       Text051@7207279 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Usted puede haber cambiado una dimension.\\Quiere actualizar las lineas?';
        //       text009@7207280 :
        text009: TextConst ENU = 'You must modify the personal income tax percentage manually', ESP = 'Debe modificar el % IRPF de las l�neas manualmente';
        //       Text027@7207282 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 to %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 a %2.';
        //       VendLedgEntry@7207283 :
        VendLedgEntry: Record 25;
        //       ApplyVendEntries@7207284 :
        ApplyVendEntries: Page 233;
        //       ExpenseNotesHeader@7001100 :
        ExpenseNotesHeader: Record 7207320;



    trigger OnInsert();
    begin
        //Aqui vamos a tomar cual es el contador desde el que vamos a generar n�meros de series.
        PurchasesSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;

        //Si entro en la tabla desde proyecto, heredo de forma autom�tica el proyecto desde el que vengo.
        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                VALIDATE("Job No.", GETRANGEMIN("Job No."));

        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Job No.") <> '')) then
            VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);
    end;

    trigger OnDelete();
    begin
        //JAV 19/12/22: - QB 1.12.28 No eliminar notas de gastos no abiertas
        VerifyOpen();

        ExpenseNotesLines.LOCKTABLE;

        //Se borraran las lineas asociadas al documento

        ExpenseNotesLines.SETRANGE("Document No.", "No.");
        ExpenseNotesLines.DELETEALL;

        CommentLinesExpenNotes.SETRANGE("Document Type", CommentLinesExpenNotes."Document Type"::"Expense Notes");
        CommentLinesExpenNotes.SETRANGE("No.", "No.");
        CommentLinesExpenNotes.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Gen. Journal Document Type"): Option;
    var
        optionValue: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";
    begin
        case DocumentType of
            DocumentType::" ":
                optionValue := optionValue::" ";
            DocumentType::Payment:
                optionValue := optionValue::Payment;
            DocumentType::Invoice:
                optionValue := optionValue::Invoice;
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Finance Charge Memo":
                optionValue := optionValue::"Finance Charge Memo";
            DocumentType::Reminder:
                optionValue := optionValue::Reminder;
            DocumentType::Refund:
                optionValue := optionValue::Refund;
            DocumentType::Bill:
                optionValue := optionValue::Bill;
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    //..



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        PurchasesSetup.TESTFIELD("Expense Notes No. Series");
        PurchasesSetup.TESTFIELD("Post. Expe. Notes No. Series");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        exit(PurchasesSetup."Expense Notes No. Series");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        exit(PurchasesSetup."Post. Expe. Notes No. Series");
    end;

    LOCAL procedure InitRecord()
    begin
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", PurchasesSetup."Post. Expe. Notes No. Series");
        "Posting Date" := WORKDATE;
        "Expense Note Date" := TODAY;
        "Posting Description" := Text002 + "No.";
    end;

    //     procedure CreateDim (Type1@7207270 : Integer;No1@7207271 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       SourceCodeSetup@7207272 :
        SourceCodeSetup: Record 242;
        //       TableID@7207273 :
        TableID: ARRAY[10] OF Integer;
        //       No@7207274 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Expense Notes",
                                                     "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code"
                                                     , 0, 0);
        if (OldDimSetID <> "Dimension Set ID") and LinesExist then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure LinesExist(): Boolean;
    begin
        ExpenseNotesLines.RESET;
        ExpenseNotesLines.SETRANGE("Document No.", "No.");
        exit(not ExpenseNotesLines.ISEMPTY);
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@7207270 : Integer;OldParentDimSetID@7207271 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@7207272 :
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;
        ExpenseNotesLines.RESET;
        ExpenseNotesLines.SETRANGE("Document No.", "No.");
        ExpenseNotesLines.LOCKTABLE;
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if ExpenseNotesLines.FINDSET(TRUE,FALSE) then
        if ExpenseNotesLines.FINDSET(TRUE) then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ExpenseNotesLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ExpenseNotesLines."Dimension Set ID" <> NewDimSetID then begin
                    ExpenseNotesLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ExpenseNotesLines."Dimension Set ID", ExpenseNotesLines."Shortcut Dimension 1 Code", ExpenseNotesLines."Shortcut Dimension 2 Code");
                    ExpenseNotesLines.MODIFY;
                end;
            until ExpenseNotesLines.NEXT = 0;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@7207270 : Integer;var ShortcutDimCode@7207271 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if LinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if LinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure FunFilterResponsibility (var NoteToFilter@1000000000 :
    procedure FunFilterResponsibility(var NoteToFilter: Record 7207320)
    begin
        if FunctionQB.GetUserJobResponsibilityCenter <> '' then begin
            NoteToFilter.FILTERGROUP(2);
            NoteToFilter.SETRANGE("Responsibility Center", FunctionQB.GetUserJobResponsibilityCenter);
            NoteToFilter.FILTERGROUP(0);
        end;
    end;

    procedure ConfirmDeletion(): Boolean;
    begin

        exit(TRUE);
    end;

    //     procedure AssistEdit (OldExpenseNotesHeader@1000 :
    procedure AssistEdit(OldExpenseNotesHeader: Record 7207320): Boolean;
    begin
        PurchasesSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldExpenseNotesHeader."No. Series", "No. Series") then begin
            PurchasesSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure VerifyOpen()
    begin
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) then
            ERROR('No puede modificar la nota de gastos en estado %1', Rec."Approval Status");
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//      JAV 19/12/22: - QB 1.12.28 No modificar notas de gastos no abiertas
//    }
    end.
  */
}








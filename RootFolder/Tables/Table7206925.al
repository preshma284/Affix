table 7206925 "QB Liq. Efectos Linea"
{


    Permissions = TableData 112 = r,
                TableData 1221 = rimd;

    fields
    {
        field(1; "Relacion No."; Integer)
        {
            TableRelation = "QB Liq. Efectos Cabecera";
            CaptionML = ENU = 'Journal Template Name', ESP = 'N� Liquidaci�n';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(15; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Account No.', ESP = 'Proveedor';

            trigger OnValidate();
            var
                DocumentTypeEnum: Enum "Document Type Enum";
            BEGIN
                IF (xRec."Vendor No." <> '') AND (xRec."Vendor No." <> Rec."Vendor No.") THEN BEGIN
                    IF ("Document No." <> '') OR (Amount <> 0) THEN
                        IF NOT CONFIRM(txtQB000, FALSE) THEN
                            ERROR('');
                    newVendor := "Vendor No.";
                    INIT;
                    "Vendor No." := newVendor;
                END;

                IF Vendor.GET("Vendor No.") THEN
                    Vendor.CheckBlockedVendOnJnls(Vendor, "DocumentTypeEnum", FALSE);
                VALIDATE("Document No.");
            END;


        }
        field(16; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Banco';

            trigger OnValidate();
            BEGIN
                BankAccount.GET("Bank Account No.");
                IF (BankAccount."Currency Code" <> "Currency Code") THEN
                    ERROR(txtQB001);

                CALCFIELDS("Bank Account Name");
            END;


        }
        field(17; "Bank Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Bank Account"."Name" WHERE("No." = FIELD("Bank Account No.")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(18; "Fecha Cargo"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(19; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ESP = 'Nombre Proveedor';
            Editable = false;


        }
        field(20; "Document Type"; Option)
        {
            OptionMembers = " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill"', ESP = '" ,Pago,Factura,Abono,Docs. inter�s,Recordatorio,Reembolso,,,,,,,,,,,,,,,Efecto"';

            Editable = false;


        }
        field(21; "Document No."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applies-to Doc. No.', ESP = 'N� documento';

            trigger OnValidate();
            BEGIN
                IF ("Document No." <> '') THEN BEGIN
                    VendorLedgerEntry.RESET;
                    IF ("Vendor No." <> '') THEN
                        VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                    VendorLedgerEntry.SETRANGE("Document No.", "Document No.");
                    VendorLedgerEntry.SETRANGE(Open, TRUE);
                    VendorLedgerEntry.SETRANGE(Positive, FALSE);
                    IF VendorLedgerEntry.FINDFIRST THEN
                        VALIDATE("No. Mov. Proveedor", VendorLedgerEntry."Entry No.");
                END;
            END;

            trigger OnLookup();
            VAR
                //                                                               PaymentToleranceMgt@1001 :
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
                //                                                               AccType@1002 :
                AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee";
                //                                                               AccNo@1003 :
                AccNo: Code[20];
            BEGIN
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                IF "Vendor No." <> '' THEN
                    VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                VendorLedgerEntry.SETRANGE(Open, TRUE);
                VendorLedgerEntry.SETRANGE(Positive, FALSE);
                VendorLedgerEntry.SETFILTER("Document Situation", '<>%1', VendorLedgerEntry."Document Situation"::" ");

                CLEAR(pgVendEntries);
                pgVendEntries.SETTABLEVIEW(VendorLedgerEntry);
                pgVendEntries.SETRECORD(VendorLedgerEntry);
                pgVendEntries.LOOKUPMODE(TRUE);
                IF pgVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    pgVendEntries.GETRECORD(VendorLedgerEntry);
                    IF (VendorLedgerEntry."Document Situation" = VendorLedgerEntry."Document Situation"::" ") THEN
                        ERROR(txtQB002);
                    VALIDATE("No. Mov. Proveedor", VendorLedgerEntry."Entry No.");
                END;
            END;


        }
        field(22; "Bill No."; Code[20])
        {
            CaptionML = ENU = 'Bill No.', ESP = 'N� efecto';
            Editable = false;


        }
        field(23; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(31; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha de Registro';
            Editable = false;


        }
        field(32; "Due Date"; Date)
        {


            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Posting Date" := "Due Date";
            END;


        }
        field(52; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 BankAcc@1000 :
                BankAcc: Record 270;
            BEGIN
                BankAcc.TESTFIELD("Currency Code", "Currency Code");
            END;


        }
        field(53; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(60; "Document Situation"; Enum "ES Document Situation")
        {
            // OptionMembers = " ","Posted BG/PO","Closed BG/PO","BG/PO","Cartera","Closed Documents";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Situation', ESP = 'Situaci�n documento';
            // OptionCaptionML = ENU = '" ,Posted BG/PO,Closed BG/PO,BG/PO,Cartera,Closed Documents"', ESP = '" ,Rem./Ord. pago regis.,Rem./Ord. pago cerrada,Rem./Ord. pago,Cartera,Docs. cerrados"';

            Editable = false;


        }
        field(70; "Liquidar"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Liquidar';


        }
        field(71; "Registered"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Registrado';
            Description = 'Si se ha registrado la l�nea';


        }
        field(77; "Texto Error"; Text[250])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comment', ESP = 'Error';
            Editable = false;


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(481; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1),
                                                                                               "Blocked" = CONST(false));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            Editable = false;
            CaptionClass = '1,2,1';


        }
        field(482; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2),
                                                                                               "Blocked" = CONST(false));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            Editable = false;
            CaptionClass = '1,2,2';


        }
        field(483; "No. Mov. Proveedor"; Integer)
        {


            CaptionML = ENU = 'Transaction No.', ESP = 'N� Mov. Proveedor';
            BlankZero = true;
            Editable = false;

            trigger OnValidate();
            BEGIN
                Cabecera.GET("Relacion No.");
                IF VendorLedgerEntry.GET("No. Mov. Proveedor") THEN BEGIN
                    VendorLedgerEntry.CALCFIELDS("Remaining Amount");

                    "Vendor No." := VendorLedgerEntry."Vendor No.";

                    "Document Type" := ConvertDocumentTypeToOption(VendorLedgerEntry."Document Type");
                    //"Document Type" := VendorLedgerEntry."Document Type";
                    "Document No." := VendorLedgerEntry."Document No.";
                    "Bill No." := VendorLedgerEntry."Bill No.";
                    Description := VendorLedgerEntry.Description;
                    VALIDATE("Due Date", VendorLedgerEntry."Due Date");
                    "Currency Code" := VendorLedgerEntry."Currency Code";
                    Amount := -VendorLedgerEntry."Remaining Amount";
                    "Document Situation" := VendorLedgerEntry."Document Situation";
                    "Shortcut Dimension 1 Code" := VendorLedgerEntry."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := VendorLedgerEntry."Global Dimension 2 Code";
                    "Dimension Set ID" := VendorLedgerEntry."Dimension Set ID";

                    CheckLedgerEntry.RESET;
                    CheckLedgerEntry.SETRANGE("Document No.", "Document No.");
                    CheckLedgerEntry.SETRANGE("Check No.", "Bill No.");
                    CheckLedgerEntry.SETRANGE("Entry Status", CheckLedgerEntry."Entry Status"::Printed);
                    IF CheckLedgerEntry.FINDFIRST THEN
                        VALIDATE("Bank Account No.", CheckLedgerEntry."Bank Account No.");


                    CASE VendorLedgerEntry."Document Situation" OF
                        VendorLedgerEntry."Document Situation"::"BG/PO":
                            BEGIN
                                CarteraDoc.GET(CarteraDoc.Type::Payable, VendorLedgerEntry."Entry No.");
                                PaymentOrder.GET(CarteraDoc."Bill Gr./Pmt. Order No.");
                                "Bank Account No." := PaymentOrder."Bank Account No.";
                            END;
                        VendorLedgerEntry."Document Situation"::"Posted BG/PO":
                            BEGIN
                                PostedCarteraDoc.GET(PostedCarteraDoc.Type::Payable, VendorLedgerEntry."Entry No.");
                                PostedPaymentOrder.GET(PostedCarteraDoc."Bill Gr./Pmt. Order No.");
                                "Bank Account No." := PostedPaymentOrder."Bank Account No.";
                            END;
                        VendorLedgerEntry."Document Situation"::"Closed BG/PO":
                            BEGIN
                                ClosedCarteraDoc.GET(ClosedCarteraDoc.Type::Payable, VendorLedgerEntry."Entry No.");
                                ClosedPaymentOrder.GET(ClosedCarteraDoc."Bill Gr./Pmt. Order No.");
                                "Bank Account No." := ClosedPaymentOrder."Bank Account No.";
                            END;
                        VendorLedgerEntry."Document Situation"::"Closed Documents":
                            BEGIN
                            END;
                    END;
                END;
            END;


        }
        field(484; "Cnt. Movimientos"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("QB Liq. Efectos Linea" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                    "No. Mov. Proveedor" = FIELD("No. Mov. Proveedor")));
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Relacion No.", "Line No.")
        {
            MaintainSIFTIndex = false;
            Clustered = true;
        }
        key(key2; "Relacion No.", "Vendor No.", "Due Date")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       Conf@7001107 :
        Conf: Record 7207278;
        //       BankAccount@7001104 :
        BankAccount: Record 270;
        //       CheckLedgerEntry@7001105 :
        CheckLedgerEntry: Record 272;
        //       Vendor@7001106 :
        Vendor: Record 23;
        //       VendorLedgerEntry@7001109 :
        VendorLedgerEntry: Record 25;
        //       Cabecera@7001101 :
        Cabecera: Record 7206924;
        //       Lineas@7001110 :
        Lineas: Record 7206925;
        //       CarteraDoc@7001114 :
        CarteraDoc: Record 7000002;
        //       PostedCarteraDoc@7001117 :
        PostedCarteraDoc: Record 7000003;
        //       ClosedCarteraDoc@7001118 :
        ClosedCarteraDoc: Record 7000004;
        //       PaymentOrder@7001102 :
        PaymentOrder: Record 7000020;
        //       PostedPaymentOrder@7001113 :
        PostedPaymentOrder: Record 7000021;
        //       ClosedPaymentOrder@7001103 :
        ClosedPaymentOrder: Record 7000022;
        //       pgVendEntries@7001112 :
        pgVendEntries: Page 29;
        //       dimMgt@7001100 :
        dimMgt: Codeunit "DimensionManagement";
        dimMgt1: Codeunit "DimensionManagement1";
        //       NoSeriesMgt@7001115 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       auxTxt@7001108 :
        auxTxt: Text;
        //       suma@7001111 :
        suma: Decimal;
        //       newVendor@7001116 :
        newVendor: Code[20];
        //       txtQB000@1100286000 :
        txtQB000: TextConst ESP = 'Si cambia el proveedor se eliminar�n los datos existentes, �continuar?';
        //       txtQB001@1100286001 :
        txtQB001: TextConst ESP = 'No puede usar un banco con una divisa diferente a la de la l�nea.';
        //       txtQB002@1100286002 :
        txtQB002: TextConst ESP = 'El documento no est� en cartera.';
        //       txtQB003@1100286003 :
        txtQB003: TextConst ESP = 'No ha indicado el documento.';
        //       txtQB004@1100286004 :
        txtQB004: TextConst ESP = 'No se pueden procesar l�neas a cero.';
        //       txtQB005@1100286005 :
        txtQB005: TextConst ESP = 'No ha indicado el banco por el que liquidar.';
        //       txtQB006@1100286006 :
        txtQB006: TextConst ESP = 'El documento no est� en la divisa del banco.';
        //       txtQB007@1100286007 :
        txtQB007: TextConst ESP = 'El documento est� mas de una vez en el registro.';
        //
        DocTypeEnum: Enum "Gen. Journal Document Type";

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


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          dimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Relacion No.", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure HayError(): Boolean;
    begin
        "Texto Error" := '';

        if ("No. Mov. Proveedor" = 0) then
            AddError(txtQB003);

        if (Amount = 0) then
            AddError(txtQB004);

        if not BankAccount.GET("Bank Account No.") then
            AddError(txtQB005)
        else if "Currency Code" <> BankAccount."Currency Code" then
            AddError(txtQB006);

        CALCFIELDS("Cnt. Movimientos");
        if ("Cnt. Movimientos" > 1) then
            AddError(txtQB007);

        MODIFY;

        exit("Texto Error" <> '');
    end;

    //     LOCAL procedure AddError (parTexto@7001100 :
    LOCAL procedure AddError(parTexto: Text)
    begin
        if ("Texto Error" <> '') then
            parTexto := "Texto Error" + ' ' + parTexto;
        "Texto Error" := COPYSTR(parTexto, 1, MAXSTRLEN("Texto Error"));
    end;

    /*begin
    end.
  */
}








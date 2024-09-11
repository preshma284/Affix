table 7206960 "QB Proform Header"
{

    DataCaptionFields = "No.", "Buy-from Vendor Name";
    CaptionML = ENU = 'QB Proform Header', ESP = 'QB Cabecera proforma';
    LookupPageID = "QB Proform Card";
    DrillDownPageID = "QB Proform Card";

    fields
    {
        field(2; "Buy-from Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Buy-from Vendor No.', ESP = 'Compra a-N� proveedor';
            NotBlank = true;


        }
        field(3; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Pay-to Vendor No.', ESP = 'Pago-a N� proveedor';
            NotBlank = true;


        }
        field(5; "Pay-to Name"; Text[50])
        {
            CaptionML = ENU = 'Pay-to Name', ESP = 'Pago a-Nombre';


        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            CaptionML = ENU = 'Pay-to Name 2', ESP = 'Pago a-Nombre 2';


        }
        field(7; "Pay-to dAddress"; Text[50])
        {
            CaptionML = ENU = 'Pay-to Address', ESP = 'Direcci�n pago';


        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            CaptionML = ENU = 'Pay-to Address 2', ESP = 'Direcci�n pago 2';


        }
        field(9; "Pay-to City"; Text[30])
        {
            TableRelation = "Post Code"."City";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Pay-to City', ESP = 'Pago a-Poblaci�n';


        }
        field(10; "Pay-to Contact"; Text[50])
        {
            CaptionML = ENU = 'Pay-to Contact', ESP = 'Pago a-Atenci�n';


        }
        field(11; "Your Reference"; Text[35])
        {
            CaptionML = ENU = 'Your Reference', ESP = 'Su/Ntra. ref.';


        }
        field(12; "Ship-to Code"; Code[10])
        {
            TableRelation = "Ship-to Address"."Code" WHERE("Customer No." = FIELD("Sell-to Customer No."));
            CaptionML = ENU = 'Ship-to Code', ESP = 'C�d. direcci�n env�o cliente';


        }
        field(13; "Ship-to Name"; Text[50])
        {
            CaptionML = ENU = 'Ship-to Name', ESP = 'Nombre direcci�n de env�o';


        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            CaptionML = ENU = 'Ship-to Name 2', ESP = 'Nombre direcci�n de env�o 2';


        }
        field(15; "Ship-to Address"; Text[50])
        {
            CaptionML = ENU = 'Ship-to Address', ESP = 'Direcci�n de env�o';


        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            CaptionML = ENU = 'Ship-to Address 2', ESP = 'Direcci�n de env�o 2';


        }
        field(17; "Ship-to City"; Text[30])
        {
            TableRelation = "Post Code"."City";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Ship-to City', ESP = 'Poblaci�n direcci�n de env�o';


        }
        field(18; "Ship-to Contact"; Text[50])
        {
            CaptionML = ENU = 'Ship-to Contact', ESP = 'Contacto de direcci�n de env�o';


        }
        field(19; "Order Date"; Date)
        {


            CaptionML = ENU = 'Order Date', ESP = 'Fecha Proforma';

            trigger OnValidate();
            BEGIN
                VALIDATE("Proform Number");
            END;


        }
        field(20; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                "Document Date" := "Posting Date";
            END;


        }
        field(22; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(23; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';


        }
        field(24; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';


        }
        field(25; "Payment Discount %"; Decimal)
        {
            CaptionML = ENU = 'Payment Discount %', ESP = '% Dto. P.P.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;


        }
        field(26; "Pmt. Discount Date"; Date)
        {
            CaptionML = ENU = 'Pmt. Discount Date', ESP = 'Fecha dto. P.P.';


        }
        field(27; "Shipment Method Code"; Code[10])
        {
            TableRelation = "Shipment Method";
            CaptionML = ENU = 'Shipment Method Code', ESP = 'C�d. condiciones env�o';


        }
        field(28; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            CaptionML = ENU = 'Location Code', ESP = 'C�d. almac�n';


        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(31; "Vendor Posting Group"; Code[20])
        {
            TableRelation = "Vendor Posting Group";
            CaptionML = ENU = 'Vendor Posting Group', ESP = 'Grupo registro proveedor';
            Editable = false;


        }
        field(32; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(33; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;


        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            CaptionML = ENU = 'Invoice Disc. Code', ESP = 'C�d. dto. factura';


        }
        field(41; "Language Code"; Code[10])
        {
            TableRelation = "Language";
            CaptionML = ENU = 'Language Code', ESP = 'C�d. idioma';


        }
        field(43; "Purchaser Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            CaptionML = ENU = 'Purchaser Code', ESP = 'C�d. comprador';


        }
        field(44; "Order No."; Code[20])
        {
            AccessByPermission = TableData 120 = R;
            CaptionML = ENU = 'Order No.', ESP = 'N� pedido';


        }
        field(46; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Purch. Comment Line" WHERE("Document Type" = CONST("Receipt"),
                                                                                                  "No." = FIELD("No."),
                                                                                                  "Document Line No." = CONST(0)));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(47; "No. Printed"; Integer)
        {
            CaptionML = ENU = 'No. Printed', ESP = 'N� copias impresas';
            Editable = false;


        }
        field(51; "On Hold"; Code[3])
        {
            CaptionML = ENU = 'On Hold', ESP = 'Esperar';


        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            OptionMembers = " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";
            CaptionML = ENU = 'Applies-to Doc. Type', ESP = 'Liq. por tipo documento';
            OptionCaptionML = ENU = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill"', ESP = '" ,Pago,Factura,Abono,Docs. inter�s,Recordatorio,Reembolso,,,,,,,,,,,,,,,Efecto"';



        }
        field(53; "Applies-to Doc. No."; Code[20])
        {


            CaptionML = ENU = 'Applies-to Doc. No.', ESP = 'Liq. por n� documento';

            trigger OnLookup();
            BEGIN
                VendLedgEntry.SETCURRENTKEY("Document No.");
                VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                VendLedgEntry.SETRANGE("Bill No.", "Applies-to Bill No.");
                PAGE.RUN(0, VendLedgEntry);
            END;


        }
        field(55; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
            CaptionML = ENU = 'Bal. Account No.', ESP = 'Cta. contrapartida';


        }
        field(66; "Vendor Order No."; Code[35])
        {
            CaptionML = ENU = 'Vendor Order No.', ESP = 'N� pedido proveedor';


        }
        field(67; "Vendor Shipment No."; Code[35])
        {
            CaptionML = ENU = 'Vendor Shipment No.', ESP = 'N� albar�n proveedor';


        }
        field(68; "Vendor Invoice No."; Code[35])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor Invoice No.', ESP = 'N� factura proveedor';

            trigger OnValidate();
            VAR
                //                                                                 VendorLedgerEntry@1000 :
                VendorLedgerEntry: Record 25;
            BEGIN
            END;


        }
        field(70; "VAT Registration No."; Text[20])
        {
            CaptionML = ENU = 'VAT Registration No.', ESP = 'CIF/NIF';


        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Sell-to Customer No.', ESP = 'Venta a-N� cliente';


        }
        field(73; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
            CaptionML = ENU = 'Gen. Bus. Posting Group', ESP = 'Grupo registro neg. gen.';


        }
        field(76; "Transaction Type"; Code[10])
        {
            TableRelation = "Transaction Type";
            CaptionML = ENU = 'Transaction Type', ESP = 'Naturaleza transacci�n';


        }
        field(77; "Transport Method"; Code[10])
        {
            TableRelation = "Transport Method";
            CaptionML = ENU = 'Transport Method', ESP = 'Modo transporte';


        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'VAT Country/Region Code', ESP = 'C�d. IVA pa�s/regi�n';


        }
        field(79; "Buy-from Vendor Name"; Text[50])
        {
            CaptionML = ENU = 'Buy-from Vendor Name', ESP = 'Compra a-Nombre';


        }
        field(80; "Buy-from Vendor Name 2"; Text[50])
        {
            CaptionML = ENU = 'Buy-from Vendor Name 2', ESP = 'Compra a-Nombre 2';


        }
        field(81; "Buy-from Address"; Text[50])
        {
            CaptionML = ENU = 'Buy-from Address', ESP = 'Compra a-Direcci�n';


        }
        field(82; "Buy-from Address 2"; Text[50])
        {
            CaptionML = ENU = 'Buy-from Address 2', ESP = 'Compra a-Direcci�n 2';


        }
        field(83; "Buy-from City"; Text[30])
        {
            TableRelation = "Post Code"."City";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Buy-from City', ESP = 'Compra a-Poblaci�n';


        }
        field(84; "Buy-from Contact"; Text[50])
        {
            CaptionML = ENU = 'Buy-from Contact', ESP = 'Compra a-Contacto';


        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Pay-to Post Code', ESP = 'Pago a-C.P.';


        }
        field(86; "Pay-to County"; Text[30])
        {
            CaptionML = ENU = 'Pay-to County', ESP = 'Pago a-Provincia';
            CaptionClass = '5,1,' + "Pay-to Country/Region Code";


        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Pay-to Country/Region Code', ESP = 'Pago a-C�d. pa�s/regi�n';


        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Buy-from Post Code', ESP = 'Compra a-C.P.';


        }
        field(89; "Buy-from County"; Text[30])
        {
            CaptionML = ENU = 'Buy-from County', ESP = 'Compra a-Provincia';
            CaptionClass = '5,1,' + "Buy-from Country/Region Code";


        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Buy-from Country/Region Code', ESP = 'Compra a-C�d. pa�s/regi�n';


        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Ship-to Post Code', ESP = 'C.P. direcci�n de env�o';


        }
        field(92; "Ship-to County"; Text[30])
        {
            CaptionML = ENU = 'Ship-to County', ESP = 'Provincia direcci�n de env�o';
            CaptionClass = '5,1,' + "Ship-to Country/Region Code";


        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Ship-to Country/Region Code', ESP = 'C�d. pa�s/regi�n direcci�n de env�o';


        }
        field(94; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account","Bank Account";
            CaptionML = ENU = 'Bal. Account Type', ESP = 'Tipo contrapartida';
            OptionCaptionML = ENU = 'G/L Account,Bank Account', ESP = 'Cuenta,Banco';



        }
        field(95; "Order Address Code"; Code[10])
        {
            TableRelation = "Order Address"."Code" WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
            CaptionML = ENU = 'Order Address Code', ESP = 'C�d. direcci�n pedido proveed.';


        }
        field(98; "Correction"; Boolean)
        {
            CaptionML = ENU = 'Correction', ESP = 'Correcci�n';


        }
        field(99; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha emisi�n documento';


        }
        field(101; "Area"; Code[10])
        {
            TableRelation = "Area";
            CaptionML = ENU = 'Area', ESP = 'C�d. provincia';


        }
        field(104; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';


        }
        field(109; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'Nos. serie';
            Editable = false;


        }
        field(110; "Order No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Order No. Series', ESP = 'N� serie pedido';


        }
        field(112; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            //TestTableRelation=false;
            DataClassification = EndUserIdentifiableInformation;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               UserMgt@1000 :
                UserMgt: Codeunit "User Management 1";
            BEGIN
                UserMgt.LookupUserID("User ID");
            END;


        }
        field(113; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(114; "Tax Area Code"; Code[20])
        {
            TableRelation = "Tax Area";
            CaptionML = ENU = 'Tax Area Code', ESP = 'C�d. �rea impuesto';


        }
        field(115; "Tax Liable"; Boolean)
        {
            CaptionML = ENU = 'Tax Liable', ESP = 'Sujeto a impuesto';


        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            CaptionML = ENU = 'VAT Bus. Posting Group', ESP = 'Grupo registro IVA neg.';


        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            CaptionML = ENU = 'VAT Base Discount %', ESP = '% Dto. base IVA';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;


        }
        field(151; "Quote No."; Code[20])
        {
            CaptionML = ENU = 'Quote No.', ESP = 'N� oferta';
            Editable = false;


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(7000000; "Applies-to Bill No."; Code[20])
        {
            CaptionML = ENU = 'Applies-to Bill No.', ESP = 'Liq. por n� efecto';


        }
        field(7000001; "Vendor Bank Acc. Code"; Code[20])
        {
            TableRelation = "Vendor Bank Account"."Code" WHERE("Vendor No." = FIELD("Pay-to Vendor No."));
            CaptionML = ENU = 'Vendor Bank Acc. Code', ESP = 'C�d. banco proveedor';


        }
        field(7000003; "Pay-at Code"; Code[10])
        {
            TableRelation = "Vendor Pmt. Address"."Code" WHERE("Vendor No." = FIELD("Pay-to Vendor No."));
            CaptionML = ENU = 'Pay-at Code', ESP = 'Pago en-C�digo';


        }
        field(7207270; "QW Cod. Withholding by GE"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"));
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'C�d. retenci�n por B.E.';


        }
        field(7207276; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(7207300; "Last Proform"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '�ltima Proforma';


        }
        field(7207301; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Factura generado';
            Description = 'Pone el n�mero de la factura creada o asociada a la proforma. Cuando se registra esta factura indica el n�mero de la factura registada.';
            Editable = false;


        }
        field(7207316; "Proform Number"; Code[10])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proforma N�';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //Montar el contador de proformas
                QBProformHeader.RESET;
                QBProformHeader.SETRANGE("Job No.", "Job No.");
                QBProformHeader.SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
                QBProformHeader.SETRANGE("Proform Number", MountNumber("Order Date", 0), MountNumber("Order Date", 99));
                IF (QBProformHeader.ISEMPTY) THEN
                    "Proform Number" := MountNumber("Order Date", 1)
                ELSE
                    "Proform Number" := MountNumber("Order Date", QBProformHeader.COUNT + 1);
            END;


        }
        field(7207317; "% Discount Proform"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Descuento por Proforma';
            MinValue = 0;
            MaxValue = 100;


        }
        field(7207318; "Validated By"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Validada por';
            Description = 'Usuario que la valid�';


        }
        field(7207319; "Validate Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Validaci�n';
            Description = 'Fecha de validaci�n';


        }
        field(7207328; "Last Proform Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Generado como �ltima proforma';
            Description = 'QB 1.08.43 Si se ha generado como �ltima proforma';


        }
        field(7207329; "Validated"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Validado';
            Description = 'Si est� validada';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
        key(key2; "Order No.")
        {
            ;
        }
        key(key3; "Pay-to Vendor No.")
        {
            ;
        }
        key(key4; "Buy-from Vendor No.")
        {
            ;
        }
        key(key5; "Posting Date")
        {
            ;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Posting Date", "Posting Description")
        {

        }
    }

    var
        //       QBProformHeader@1000 :
        QBProformHeader: Record 7206960;
        //       QBProformLine@1100286003 :
        QBProformLine: Record 7206961;
        //       QBProformLine2@1100286000 :
        QBProformLine2: Record 7206961;
        //       PurchCommentLine@1001 :
        PurchCommentLine: Record 43;
        //       VendLedgEntry@1002 :
        VendLedgEntry: Record 25;
        //       VendorPostingGroup@1100286001 :
        VendorPostingGroup: Record 93;
        //       DimMgt@1004 :
        DimMgt: Codeunit "DimensionManagement";
        //       ApprovalsMgmt@1008 :
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //       UserSetupMgt@1005 :
        UserSetupMgt: Codeunit 5700;
        //       QBProform@1100286002 :
        QBProform: Codeunit 7207345;
        //       Msg001@1100286004 :
        Msg001: TextConst ESP = 'Nada que a�adir a la proforma';
        //       Msg002@1100286005 :
        Msg002: TextConst ESP = 'Se han a�adido %1 l�nea(s)';




    trigger OnInsert();
    begin
        if ("Proform Number" = '') then
            VALIDATE("Proform Number");

        SetDiscountLine;
    end;

    trigger OnModify();
    begin
        if ("Proform Number" = '') then
            VALIDATE("Proform Number");

        SetDiscountLine;
    end;

    trigger OnDelete();
    var
        //                PostPurchDelete@1000 :
        PostPurchDelete: Codeunit 364;
    begin
        if ("Invoice No." <> '') then
            ERROR('No puede eliminar una proforma facturada.');

        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", Rec."No.");
        QBProformLine.DELETEALL(FALSE);
    end;



    // procedure PrintRecords (ShowRequestForm@1000 :
    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        //       QBReportSelections@1001 :
        QBReportSelections: Record 7206901;
    begin
        QBProformHeader.COPY(Rec);
        COMMIT;
        QBReportSelections.Print(QBReportSelections.Usage::P3, QBProformHeader);
    end;


    procedure Navigate()
    var
        //       NavigateForm@1000 :
        NavigateForm: Page "Navigate";
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.RUN;
    end;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    //     LOCAL procedure MountNumber (Date@1100286000 : Date;number@1100286001 :
    LOCAL procedure MountNumber(Date: Date; number: Integer): Code[10];
    var
        //       txtAux@1100286002 :
        txtAux: Text;
    begin
        txtAux := STRSUBSTNO('%1-%2-%3', AdjustNumber(DATE2DMY(Date, 3), 4), AdjustNumber(DATE2DMY(Date, 2), 2), AdjustNumber(number, 2));
        exit(txtAux);
    end;

    //     LOCAL procedure AdjustNumber (pNumber@1100286000 : Integer;pLon@1100286001 :
    LOCAL procedure AdjustNumber(pNumber: Integer; pLon: Integer): Text;
    var
        //       auxText@1100286002 :
        auxText: Text;
    begin
        auxText := FORMAT(pNumber);
        WHILE (STRLEN(auxText) < pLon) DO
            auxText := '0' + auxText;
        exit(auxText);
    end;

    procedure SetDiscountLine()
    var
        //       PaymentMethod@1100286000 :
        PaymentMethod: Record 289;
        //       LineNo@1100286001 :
        LineNo: Integer;
        //       BasePeriod@1100286002 :
        BasePeriod: Decimal;
        //       BaseOrigin@1100286003 :
        BaseOrigin: Decimal;
    begin
        if (PaymentMethod.GET("Payment Method Code")) then
            "% Discount Proform" := PaymentMethod."QB % Discount in Proforms"
        else
            "% Discount Proform" := 0;

        VendorPostingGroup.GET("Vendor Posting Group");

        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", "No.");
        QBProformLine.SETRANGE("QB Discount Line", TRUE);
        QBProformLine.DELETEALL;

        if ("% Discount Proform" <> 0) then begin
            CalculateTotal(BasePeriod, BaseOrigin);
            BasePeriod := ROUND(BasePeriod, 0.01);
            if (BasePeriod = 0) then
                exit;

            QBProformLine.RESET;
            QBProformLine.SETRANGE("Document No.", "No.");
            if (not QBProformLine.FINDLAST) then
                exit;
            LineNo := QBProformLine."Line No.";

            QBProformLine.INIT;
            QBProformLine."Document No." := "No.";
            QBProformLine."Line No." := LineNo + 10000;
            QBProformLine."QB Recurrent Line" := TRUE;
            QBProformLine."QB Discount Line" := TRUE;
            QBProformLine.Type := QBProformLine.Type::"G/L Account";
            QBProformLine."No." := VendorPostingGroup."Payment Disc. Credit Acc.";
            QBProformLine.Description := STRSUBSTNO('Descuento P.P. del %1% sobre %2', "% Discount Proform", FORMAT(BasePeriod, 0));
            QBProformLine.VALIDATE(Quantity, ROUND(BasePeriod * "% Discount Proform" / 100, 0.01));
            QBProformLine.VALIDATE("Direct Unit Cost", -1);
            QBProformLine.INSERT;
        end;
    end;

    //     procedure CalculateTotal (var tPeriod@1100286000 : Decimal;var tOrigin@1100286001 :
    procedure CalculateTotal(var tPeriod: Decimal; var tOrigin: Decimal)
    begin
        tPeriod := 0;
        tOrigin := 0;

        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", "No.");
        if (QBProformLine.FINDSET(FALSE)) then
            repeat
                QBProform.RecalculateLineOrigin(QBProformLine, QBProformLine.Quantity);  //Esto recalcula los importes de la l�nea
                tPeriod += QBProformLine.Amount;
                tOrigin += QBProformLine."QB Proform Amount Origin";
            until (QBProformLine.NEXT = 0);
    end;

    procedure AddLines()
    var
        //       LineNumber@1100286000 :
        LineNumber: Integer;
        //       NroAdd@1100286001 :
        NroAdd: Integer;
    begin
        //JAV 23/06/21: - QB 1.09.01 Nueva acci�n para traer a las l�neas las que est�n en certificciones anteriores pero no en esta
        NroAdd := 0;

        QBProformLine.RESET;
        QBProformLine.SETRANGE("Job No.", "Job No.");
        QBProformLine.SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
        QBProformLine.SETRANGE("Order No.", "Order No.");                           //JAV 05/07/21: - QB 1.09.04 Solo del pedido que ha originado la proforma
        QBProformLine.SETRANGE("QB Recurrent Line", FALSE);                         //No traigo l�neas recurrentes
        QBProformLine.SETFILTER("Document No.", '<%1', "No.");                      //Solo miro documentos anteriores
        if (not QBProformLine.FINDSET(FALSE)) then
            repeat
                QBProformLine2.RESET;
                QBProformLine2.SETRANGE("Document No.", "No.");
                QBProformLine2.SETRANGE("Order No.", QBProformLine."Order No.");            //Miro las l�neas de origen en el pedido, si no est�n las inserto
                QBProformLine2.SETRANGE("Order Line No.", QBProformLine."Order Line No.");
                if (QBProformLine2.ISEMPTY) then begin
                    QBProformLine2.RESET;
                    QBProformLine2.SETRANGE("Document No.", "No.");
                    QBProformLine2.FINDLAST;
                    LineNumber := QBProformLine2."Line No.";

                    QBProformLine2 := QBProformLine;
                    QBProformLine2."Document No." := "No.";
                    QBProformLine2."Line No." := LineNumber + 10000;
                    QBProformLine2.INSERT;
                    NroAdd += 1;
                end;
            until (QBProformLine.NEXT = 0);

        if (NroAdd = 0) then
            MESSAGE(Msg001)
        else
            MESSAGE(Msg002, NroAdd);
    end;

    /*begin
    //{
//      JAV 23/06/21: - QB 1.09.01 Nueva acci�n para traer a las l�neas las que est�n en certificciones anteriores pero no en esta
//    }
    end.
  */
}








table 7206923 "QB Crear Efectos Linea"
{


    Permissions = TableData 112 = r,
                TableData 1221 = rimd;

    fields
    {
        field(1; "Relacion No."; Integer)
        {
            TableRelation = "QB Crear Efectos Cabecera";
            CaptionML = ENU = 'Journal Template Name', ESP = 'N� Relaci�n';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(5; "Registrada"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;


        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de Registro';
            Editable = false;


        }
        field(10; "Tipo Linea"; Option)
        {
            OptionMembers = "Factura","Abono","Anticipado","Cambio";

            DataClassification = ToBeClassified;
            OptionCaptionML = ESP = 'Factura,Abono,Pago Anticipado,Cambio Vto.';


            trigger OnValidate();
            BEGIN
                IF (xRec."Tipo Linea" <> "Tipo Linea") AND ("No. Pagare" <> '') THEN
                    ERROR(txtQB002);

                IF (xRec."Tipo Linea" <> Rec."Tipo Linea") THEN BEGIN
                    IF ("Vendor No." <> '') OR ("Document No." <> '') OR (Amount <> 0) THEN
                        IF NOT CONFIRM(txtQB003, FALSE) THEN
                            ERROR('');
                    newTipo := "Tipo Linea";
                    INIT;
                    "Tipo Linea" := newTipo;
                END;

                IF ("Tipo Linea" = "Tipo Linea"::Anticipado) AND ("Document No." = '') THEN BEGIN
                    QBRelationshipSetup.GET();
                    QBRelationshipSetup.TESTFIELD("RP Serie para Pago Anticipado");
                    NoSeriesMgt.InitSeries(QBRelationshipSetup."RP Serie para Pago Anticipado", '', 0D, "Document No.", QBRelationshipSetup."RP Serie para Pago Anticipado");
                    SetDescription;
                END;
            END;


        }
        field(15; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Account No.', ESP = 'Proveedor';

            trigger OnValidate();
            BEGIN
                IF (xRec."Vendor No." <> '') AND (xRec."Vendor No." <> "Vendor No.") AND ("No. Pagare" <> '') THEN
                    ERROR(txtQB004);

                IF (xRec."Vendor No." <> '') AND (xRec."Vendor No." <> Rec."Vendor No.") THEN BEGIN
                    IF ("Document No." <> '') OR (Amount <> 0) THEN
                        IF NOT CONFIRM(txtQB005, FALSE) THEN
                            ERROR('');
                    newTipo := "Tipo Linea";
                    newVendor := "Vendor No.";
                    INIT;
                    "Tipo Linea" := newTipo;
                    "Vendor No." := newVendor;
                END;

                IF Vendor.GET("Vendor No.") THEN BEGIN
                    "Recipient Bank Account" := Vendor."Preferred Bank Account Code";
                    "Payment Method Code" := Vendor."Payment Method Code";
                    "Payment Terms Code" := Vendor."Payment Terms Code";
                    IF ("No. Mov. Proveedor" = 0) THEN BEGIN
                        //"Shortcut Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                        //"Shortcut Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                        TableID[1] := DATABASE::Vendor;
                        No[1] := "Vendor No.";
                        "Shortcut Dimension 1 Code" := '';
                        "Shortcut Dimension 2 Code" := '';
                        dimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
                        "Dimension Set ID" := dimMgt.GetDefaultDimID(DefaultDimSource, "Vendor No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
                    END;
                END;
                BuscarErrores(FALSE);

                CALCFIELDS("Vendor Name");
            END;


        }
        field(16; "Recipient Bank Account"; Code[20])
        {
            TableRelation = "Vendor Bank Account"."Code" WHERE("Vendor No." = FIELD("Vendor No."));
            CaptionML = ENU = 'Recipient Bank Account', ESP = 'Cta. bancaria destinatario';


        }
        field(17; "Vendor Name"; Text[100])
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

            trigger OnValidate();
            var
                DocumentTypeOption: Option;
                DocumentTypeEnum: Enum "Gen. Journal Document Type";
            BEGIN
                VALIDATE("Document No.");
                Vendor.GET("Vendor No.");
                // Explicitly convert the Option value to the Enum type
                DocumentTypeEnum := "Gen. Journal Document Type".FromInteger(DocumentTypeOption);
                Vendor.CheckBlockedVendOnJnls(Vendor, "DocumentTypeEnum", FALSE);
            END;


        }
        field(21; "Document No."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applies-to Doc. No.', ESP = 'N� documento';

            trigger OnValidate();
            BEGIN
                IF (xRec."Document No." <> '') AND (xRec."Document No." <> "Document No.") AND ("No. Pagare" <> '') THEN
                    ERROR(txtQB006);

                IF (xRec."Document No." <> '') AND ("Document No." = '') THEN BEGIN
                    IF NOT CONFIRM(txtQB007, FALSE) THEN
                        ERROR('');
                    newTipo := "Tipo Linea";
                    newVendor := "Vendor No.";
                    INIT;
                    "Tipo Linea" := newTipo;
                    "Vendor No." := newVendor;
                END;

                IF ("Document No." <> '') THEN BEGIN
                    BuscarDuplicados;

                    VendorLedgerEntry.RESET;
                    IF ("Vendor No." <> '') THEN
                        VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                    VendorLedgerEntry.SETRANGE("Document No.", "Document No.");
                    VendorLedgerEntry.SETRANGE(Open, TRUE);
                    VendorLedgerEntry.SETRANGE(Positive, ("Tipo Linea" = "Tipo Linea"::Abono));
                    IF VendorLedgerEntry.FINDFIRST THEN
                        VALIDATE("No. Mov. Proveedor", VendorLedgerEntry."Entry No.")
                    ELSE
                        ERROR(txtQB008);
                END;
                BuscarErrores(FALSE);
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
                IF ("Tipo Linea" <> "Tipo Linea"::Anticipado) THEN BEGIN
                    Cabecera.GET("Relacion No.");
                    BankAccount.GET(Cabecera."Bank Account No.");

                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                    IF "Vendor No." <> '' THEN
                        VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                    VendorLedgerEntry.SETRANGE(Open, TRUE);
                    VendorLedgerEntry.SETRANGE(Positive, ("Tipo Linea" = "Tipo Linea"::Abono));
                    VendorLedgerEntry.SETFILTER("Currency Code", '=%1', BankAccount."Currency Code");
                    //JAV 19/10/20: - QB 1.06.19 Si es una relaci�n de efectos, solo pueden ser facturas en cartera
                    IF (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago) THEN BEGIN
                        VendorLedgerEntry.SETFILTER("Document Situation", '%1|%2', VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera);
                        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                    END;

                    CLEAR(pgVendEntries);
                    pgVendEntries.SETTABLEVIEW(VendorLedgerEntry);
                    pgVendEntries.SETRECORD(VendorLedgerEntry);
                    pgVendEntries.LOOKUPMODE(TRUE);
                    IF pgVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        pgVendEntries.GETRECORD(VendorLedgerEntry);
                        //    IF ("Tipo Linea" <> "Tipo Linea"::Cambio) AND (VendorLedgerEntry."Document Situation" <> VendorLedgerEntry."Document Situation"::" ") THEN
                        //      ERROR('El documento ya est� en cartera');
                        //    IF ("Tipo Linea" = "Tipo Linea"::Cambio)  AND (VendorLedgerEntry."Document Situation" <> VendorLedgerEntry."Document Situation"::Cartera) THEN
                        //      ERROR('El documento no est� en cartera o est� en una orden de pago');
                        Vendor.GET(VendorLedgerEntry."Vendor No.");
                        //IF (Vendor.Employee) THEN
                        //  ERROR('este proceso solo se puede usar con proveedores');
                        VALIDATE("Vendor No.", VendorLedgerEntry."Vendor No.");
                        VALIDATE("Document No.", VendorLedgerEntry."Document No.");
                    END;
                END;
            END;


        }
        field(22; "Bill No."; Code[20])
        {
            CaptionML = ENU = 'Bill No.', ESP = 'N� efecto';
            Editable = false;


        }
        field(23; "Liquida Documento"; Code[20])
        {


            DataClassification = ToBeClassified;
            Description = 'Si es abono, que factura liquida';

            trigger OnValidate();
            BEGIN
                IF (xRec."Liquida Documento" <> '') AND (xRec."Liquida Documento" <> "Liquida Documento") AND ("No. Pagare" <> '') THEN
                    ERROR(txtQB009);

                IF ("Liquida Documento" <> '') THEN BEGIN
                    Lineas.RESET;
                    Lineas.SETRANGE("Relacion No.", "Relacion No.");
                    Lineas.SETRANGE("Tipo Linea", "Tipo Linea"::Factura);
                    Lineas.SETRANGE("Document No.", "Liquida Documento");
                    IF (Lineas.ISEMPTY) THEN
                        ERROR(txtQB010)
                END;
                LiquidarDocumento(xRec."Liquida Documento", "Liquida Documento");
                BuscarErrores(FALSE);
            END;

            trigger OnLookup();
            BEGIN
                IF ("Tipo Linea" = "Tipo Linea"::Abono) THEN BEGIN
                    auxTxt := '';
                    Lineas.RESET;
                    Lineas.SETRANGE("Relacion No.", "Relacion No.");
                    Lineas.SETRANGE("Tipo Linea", "Tipo Linea"::Factura);
                    Lineas.SETRANGE("Vendor No.", "Vendor No.");
                    IF Lineas.FINDSET THEN
                        REPEAT
                            IF (auxTxt <> '') THEN
                                auxTxt += '|';
                            auxTxt += Lineas."Document No.";
                        UNTIL Lineas.NEXT = 0;
                    IF (auxTxt = '') THEN
                        ERROR(txtQB011);

                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                    VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                    VendorLedgerEntry.SETRANGE(Open, TRUE);
                    VendorLedgerEntry.SETRANGE(Positive, FALSE);
                    VendorLedgerEntry.SETRANGE("Document Situation", VendorLedgerEntry."Document Situation"::" ");
                    VendorLedgerEntry.SETFILTER("Document No.", auxTxt);

                    CLEAR(pgVendEntries);
                    pgVendEntries.SETTABLEVIEW(VendorLedgerEntry);
                    pgVendEntries.SETRECORD(VendorLedgerEntry);
                    pgVendEntries.LOOKUPMODE(TRUE);
                    IF pgVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        pgVendEntries.GETRECORD(VendorLedgerEntry);
                        VALIDATE("Liquida Documento", VendorLedgerEntry."Document No.");
                    END;
                END;
            END;


        }
        field(24; "Anticipo Liquidar con"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Liquidar Anticipo con';
            Description = 'Si es anticipado, que factura liquida';

            trigger OnValidate();
            BEGIN
                IF ("Anticipo Liquidar con" <> '') THEN BEGIN
                    //Busco documento que liquida
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                    VendorLedgerEntry.SETRANGE("Document No.", "Anticipo Liquidar con");
                    VendorLedgerEntry.SETRANGE(Open, TRUE);
                    VendorLedgerEntry.SETRANGE(Positive, FALSE);
                    IF NOT VendorLedgerEntry.FINDFIRST THEN
                        ERROR(txtQB012);
                    //VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                    //IF (ABS(VendorLedgerEntry."Remaining Amount") < Amount) THEN
                    //  ERROR('El importe del documento no es suficiente para cancelar el efecto anticipado');
                    "No. Mov. a Liquidar" := VendorLedgerEntry."Entry No.";
                END;
            END;

            trigger OnLookup();
            BEGIN
                Cabecera.GET("Relacion No.");
                BankAccount.GET(Cabecera."Bank Account No.");

                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                VendorLedgerEntry.SETRANGE("Vendor No.", "Vendor No.");
                VendorLedgerEntry.SETRANGE(Open, TRUE);
                VendorLedgerEntry.SETRANGE(Positive, FALSE);
                VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                //VendorLedgerEntry.SETRANGE("Document Situation", VendorLedgerEntry."Document Situation"::" ");
                VendorLedgerEntry.SETFILTER("Currency Code", '=%1', BankAccount."Currency Code");

                CLEAR(pgVendEntries);
                pgVendEntries.SETTABLEVIEW(VendorLedgerEntry);
                pgVendEntries.SETRECORD(VendorLedgerEntry);
                pgVendEntries.LOOKUPMODE(TRUE);
                IF pgVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    pgVendEntries.GETRECORD(VendorLedgerEntry);
                    //IF (VendorLedgerEntry."Document Situation" <> VendorLedgerEntry."Document Situation"::" ") THEN
                    //  ERROR('El documento ya est� en cartera');

                    VALIDATE("Anticipo Liquidar con", VendorLedgerEntry."Document No.");
                END;
            END;


        }
        field(30; "External Document No."; Code[35])
        {


            CaptionML = ENU = 'External Document No.', ESP = 'N� documento externo';

            trigger OnValidate();
            BEGIN
                SetDescription;
                BuscarErrores(FALSE);
            END;


        }
        field(31; "Document Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Documento';

            trigger OnValidate();
            BEGIN
                IF (Fra.GET("Document No.")) THEN
                    "Document Date" := Fra."Document Date"
                ELSE IF (Abo.GET("Document No.")) THEN
                    "Document Date" := Abo."Document Date"
            END;


        }
        field(32; "Due Date"; Date)
        {


            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';

            trigger OnValidate();
            BEGIN
                IF (xRec."Due Date" <> 0D) AND (xRec."Due Date" <> "Due Date") AND ("No. Pagare" <> '') THEN
                    ERROR(txtQB013);
                BuscarErrores(FALSE);

                IF (xRec."Due Date" <> "Due Date") THEN
                    "No. Agrupacion" := '';
            END;


        }
        field(33; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";


            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';

            trigger OnValidate();
            BEGIN
                BuscarErrores(FALSE);
            END;


        }
        field(34; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";


            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';

            trigger OnValidate();
            BEGIN
                BuscarErrores(FALSE);
            END;


        }
        field(35; "Original Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha Vto. Original';
            Editable = false;


        }
        field(36; "Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Card Type" = CONST("Proyecto operativo"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';

            trigger OnValidate();
            BEGIN
                IF ("Job No." <> '') THEN BEGIN
                    DimensionSetEntry.RESET;
                    DimensionSetEntry.DELETEALL;

                    DefaultDimension.RESET;
                    DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
                    DefaultDimension.SETRANGE("No.", "Job No.");
                    IF (DefaultDimension.FINDSET) THEN
                        REPEAT
                            IF DimensionValue.GET(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") THEN BEGIN
                                DimensionSetEntry."Dimension Set ID" := 0;
                                DimensionSetEntry."Dimension Code" := DefaultDimension."Dimension Code";
                                DimensionSetEntry."Dimension Value Code" := DefaultDimension."Dimension Value Code";
                                DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                                DimensionSetEntry.INSERT;
                            END;
                        UNTIL DefaultDimension.NEXT = 0;

                    "Dimension Set ID" := dimMgt.GetDimensionSetID(DimensionSetEntry);
                    dimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                END;
            END;


        }
        field(50; "Description1"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción Efecto';


        }
        field(51; "Description2"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción Factura';


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
                BuscarErrores(FALSE);
            END;


        }
        field(53; "Amount"; Decimal)
        {


            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";

            trigger OnValidate();
            BEGIN
                IF (xRec.Amount <> 0) AND (xRec.Amount <> Amount) AND ("No. Pagare" <> '') THEN
                    ERROR(txtQB014);

                IF ("Tipo Linea" <> "Tipo Linea"::Abono) THEN BEGIN
                    IF (Amount < 0) THEN
                        ERROR(txtQB015);
                END ELSE BEGIN
                    IF (Amount > 0) THEN
                        ERROR(txtQB016);
                END;

                IF VendorLedgerEntry.GET("No. Mov. Proveedor") THEN BEGIN
                    VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                    suma := -VendorLedgerEntry."Remaining Amount";
                    Lineas.RESET;
                    Lineas.SETRANGE("Relacion No.", "Relacion No.");
                    Lineas.SETRANGE("Document Type", "Document Type");
                    Lineas.SETRANGE("Document No.", "Document No.");
                    Lineas.SETRANGE("Bill No.", "Bill No.");    //////////////////////++
                    IF (Lineas.FINDSET) THEN
                        REPEAT
                            IF (Lineas."Line No." <> "Line No.") THEN
                                suma -= Lineas.Amount;
                        UNTIL Lineas.NEXT = 0;
                    IF (Amount > suma) THEN BEGIN
                        MESSAGE(txtQB017, suma);
                        Amount := suma;
                    END;
                END;

                CALCFIELDS("Importe Aplicado");
                CASE "Tipo Linea" OF
                    "Tipo Linea"::Factura:
                        "Importe Pendiente" := Amount + "Importe Aplicado";
                    "Tipo Linea"::Abono:
                        "Importe Pendiente" := 0;
                    "Tipo Linea"::Anticipado:
                        "Importe Pendiente" := Amount;
                    "Tipo Linea"::Cambio:
                        "Importe Pendiente" := Amount;
                END;
                BuscarErrores(FALSE);
            END;


        }
        field(54; "Importe Aplicado"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Crear Efectos Linea"."Amount" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                          "Tipo Linea" = CONST("Abono"),
                                                                                                          "Liquida Documento" = FIELD("Document No.")));
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(55; "Anticipo Aplicado"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Crear Efectos Linea"."Amount" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                          "Tipo Linea" = CONST("Anticipado"),
                                                                                                          "Document No." = FIELD("Document No."),
                                                                                                          "Anticipo Estado" = CONST("Aplicacion")));
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(56; "Importe Pendiente"; Decimal)
        {
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(60; "Imp0 No. Serie"; Code[10])
        {
            DataClassification = ToBeClassified;


        }
        field(61; "Imp1"; Code[10])
        {
            DataClassification = ToBeClassified;


        }
        field(62; "Imp2"; Integer)
        {
            DataClassification = ToBeClassified;


        }
        field(63; "Imp3 No. Cheque Adicional"; Code[10])
        {
            DataClassification = ToBeClassified;


        }
        field(64; "Imp4"; Integer)
        {
            DataClassification = ToBeClassified;


        }
        field(70; "Include in Payment Order"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Incluir en la Orden de Pago';


        }
        field(72; "No. Pagare"; Code[10])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Doc. Generado';

            trigger OnValidate();
            BEGIN
                SetDescription;
                BuscarErrores(FALSE);
            END;


        }
        field(73; "No. Agrupacion"; Code[10])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Doc. Agrupado';

            trigger OnValidate();
            BEGIN
                SetDescription;
                BuscarErrores(FALSE);
            END;


        }
        field(75; "Printed"; Boolean)
        {
            AccessByPermission = TableData 272 = R;
            CaptionML = ENU = 'Check Printed', ESP = 'Pagar� Impreso';
            Editable = false;


        }
        field(76; "Exported to Payment File"; Boolean)
        {


            CaptionML = ENU = 'Exported to Payment File', ESP = 'Exportado a archivo de pagos';
            Editable = false;

            trigger OnValidate();
            BEGIN
                BuscarErrores(FALSE);
            END;


        }
        field(77; "Carta"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Carta impresa';
            Editable = false;


        }
        field(78; "Tipo"; Option)
        {
            OptionMembers = "Pagare","Cheque";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo';
            OptionCaptionML = ESP = ',Pagar�,Cheque';

            Editable = false;


        }
        field(80; "Texto Error"; Text[250])
        {
            CaptionML = ENU = 'Comment', ESP = 'Error';
            Editable = false;


        }
        field(90; "Anticipo Estado"; Option)
        {
            OptionMembers = " ","Parcial","Liquidado","Cancelado","Aplicacion";
            DataClassification = ToBeClassified;
            OptionCaptionML = ESP = '" ,Liqidado Parcial,Liquidado,Cancelado,Aplicaci�n"';



        }
        field(91; "Anticipo liquidado por"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(92; "Anticipo liquidado en fecha"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(93; "Anticipo Liquidado documento"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(94; "Importe Anticipos"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Crear Efectos Linea"."Amount" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                          "Tipo Linea" = CONST("Anticipado"),
                                                                                                          "Registrada" = CONST(true)));
            Editable = false;


        }
        field(100; "No. Mov. Proveedor"; Integer)
        {


            CaptionML = ENU = 'Transaction No.', ESP = 'N� Mov. Proveedor';
            BlankZero = true;
            Editable = false;

            trigger OnValidate();
            BEGIN
                Cabecera.GET("Relacion No.");
                BankAccount.GET(Cabecera."Bank Account No.");
                IF VendorLedgerEntry.GET("No. Mov. Proveedor") THEN BEGIN
                    IF VendorLedgerEntry."Currency Code" <> BankAccount."Currency Code" THEN
                        ERROR(txtQB018);

                    VendorLedgerEntry.CALCFIELDS("Remaining Amount");

                    "Vendor No." := VendorLedgerEntry."Vendor No.";
                    "Document Type" := ConvertDocumentTypeToOption(VendorLedgerEntry."Document Type");
                    "Document No." := VendorLedgerEntry."Document No.";
                    "Bill No." := VendorLedgerEntry."Bill No.";
                    "External Document No." := VendorLedgerEntry."External Document No.";
                    "Document Date" := VendorLedgerEntry."Document Date";
                    IF "Tipo Linea" <> "Tipo Linea"::Cambio THEN
                        "Due Date" := VendorLedgerEntry."Due Date";
                    "Original Due Date" := VendorLedgerEntry."Due Date";
                    "Payment Terms Code" := VendorLedgerEntry."Payment Terms Code";
                    "Payment Method Code" := VendorLedgerEntry."Payment Method Code";
                    "Currency Code" := VendorLedgerEntry."Currency Code";
                    VALIDATE(Amount, -VendorLedgerEntry."Remaining Amount");

                    "Job No." := VendorLedgerEntry."QB Job No.";

                    "Shortcut Dimension 1 Code" := VendorLedgerEntry."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := VendorLedgerEntry."Global Dimension 2 Code";
                    "Dimension Set ID" := VendorLedgerEntry."Dimension Set ID";
                END;

                SetDescription;
            END;


        }
        field(101; "No. Mov. del Anticipado"; Integer)
        {
            BlankZero = true;
            Editable = false;


        }
        field(102; "No. Mov. a Liquidar"; Integer)
        {
            BlankZero = true;
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
        key(key3; "Relacion No.", "Document Type", "Document No.", "Bill No.")
        {
            ;
        }
        key(key4; "Relacion No.", "No. Agrupacion")
        {
            SumIndexFields = "Importe Pendiente";
        }
    }
    fieldgroups
    {
    }

    var
        //       QBRelationshipSetup@7001107 :
        QBRelationshipSetup: Record 7207335;
        //       Vendor@7001106 :
        Vendor: Record 23;
        //       VendorLedgerEntry@7001109 :
        VendorLedgerEntry: Record 25;
        //       BankAccount@7001113 :
        BankAccount: Record 270;
        //       Cabecera@7001101 :
        Cabecera: Record 7206922;
        //       Lineas@7001110 :
        Lineas: Record 7206923;
        //       Fra@7001102 :
        Fra: Record 122;
        //       Abo@7001103 :
        Abo: Record 124;
        //       PaymentMethod@7001117 :
        PaymentMethod: Record 289;
        //       DefaultDimension@1100286001 :
        DefaultDimension: Record 352;
        //       DimensionValue@1100286002 :
        DimensionValue: Record 349;
        //       DimensionSetEntry@1100286000 :
        DimensionSetEntry: Record 480 TEMPORARY;
        //       CarteraDoc@1000000001 :
        CarteraDoc: Record 7000002;
        //       VATEntry@1100286003 :
        VATEntry: Record 254;
        //       pgVendEntries@7001112 :
        pgVendEntries: Page 29;
        //       dimMgt@7001100 :
        dimMgt: Codeunit "DimensionManagement";
        dimMgt1: Codeunit "DimensionManagement1";
        //       txtQB000@7001104 :
        txtQB000: TextConst ESP = 'No puede eliminar la l�nea sin quitar el pagar�';
        //       txtQB001@7001105 :
        txtQB001: TextConst ESP = 'No puede eliminar la l�nea sin quitar el pago electr�nico';
        //       NoSeriesMgt@7001115 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       ApprovalCarteraDoc@1000000000 :
        ApprovalCarteraDoc: Codeunit 7206917;
        //       auxTxt@7001108 :
        auxTxt: Text;
        //       auxEfecto@7001118 :
        auxEfecto: Text;
        //       suma@7001111 :
        suma: Decimal;
        //       newTipo@7001114 :
        newTipo: Option;
        //       newVendor@7001116 :
        newVendor: Code[20];
        //       TableID@7001119 :
        TableID: ARRAY[10] OF Integer;
        //       No@7001120 :
        No: ARRAY[10] OF Code[20];
        //Adding to handle arguments in GetDEfaultDImID
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];

        //       txtQB002@1100286004 :
        txtQB002: TextConst ESP = 'No puede cambiar el tipo, ya ha impreso el pagar�.';
        //       txtQB003@1100286005 :
        txtQB003: TextConst ESP = 'Si cambia el tipo de l�nea se eliminar�n los datos existentes, �continuar?';
        //       txtQB004@1100286006 :
        txtQB004: TextConst ESP = 'No puede cambiar el proveedor, ya ha impreso el pagar�.';
        //       txtQB005@1100286007 :
        txtQB005: TextConst ESP = 'Si cambia el proveedor se eliminar�n los datos existentes, �continuar?';
        //       txtQB006@1100286008 :
        txtQB006: TextConst ESP = 'No puede cambiar el documento, ya ha impreso el pagar�.';
        //       txtQB007@1100286009 :
        txtQB007: TextConst ESP = 'Si quita el documento se eliminar�n los datos existentes, �continuar?';
        //       txtQB008@1100286010 :
        txtQB008: TextConst ESP = 'No existe ese documento';
        //       txtQB009@1100286011 :
        txtQB009: TextConst ESP = 'No puede cambiar la liquidaci�n, ya ha impreso el pagar�.';
        //       txtQB010@1100286012 :
        txtQB010: TextConst ESP = 'No ha incluido ese documento en la relaci�n';
        //       txtQB011@1100286013 :
        txtQB011: TextConst ESP = 'No hay facturas de ese proveedor en la relaci�n.';
        //       txtQB012@1100286014 :
        txtQB012: TextConst ESP = 'No existe ese documento.';
        //       txtQB013@1100286015 :
        txtQB013: TextConst ESP = 'No puede cambiar el vencimiento, ya ha impreso el pagar�.';
        //       txtQB014@1100286016 :
        txtQB014: TextConst ESP = 'No puede cambiar el importe, ya ha impreso el pagar�.';
        //       txtQB015@1100286017 :
        txtQB015: TextConst ESP = 'El importe debe ser positivo';
        //       txtQB016@1100286018 :
        txtQB016: TextConst ESP = 'El importe debe ser negativo';
        //       txtQB017@1100286019 :
        txtQB017: TextConst ESP = 'El importe m�ximo aplicable es %1, se ajusta';
        //       txtQB018@1100286020 :
        txtQB018: TextConst ESP = 'El documento no est� en la divisa del banco';
        //       txtQB019@1100286021 :
        txtQB019: TextConst ESP = 'Pago Anticipado %1 %2 %3';
        //       txtQB020@1100286022 :
        txtQB020: TextConst ESP = 'No ha indicado el proveedor.';
        //       txtQB021@1100286023 :
        txtQB021: TextConst ESP = 'No ha indicado el documento.';
        //       txtQB022@1100286024 :
        txtQB022: TextConst ESP = 'No ha indicado Fecha de Vencimiento.';
        //       txtQB023@1100286025 :
        txtQB023: TextConst ESP = 'No ha indicado importe.';
        //       txtQB024@1100286026 :
        txtQB024: TextConst ESP = 'No ha indicado la forma de pago.';
        //       txtQB025@1100286027 :
        txtQB025: TextConst ESP = 'La forma de pago no existe.';
        //       txtQB026@1100286028 :
        txtQB026: TextConst ESP = 'No ha indicado los t�rminos de pago.';
        //       txtQB027@1100286029 :
        txtQB027: TextConst ESP = 'La forma de pago no genera efectos.';
        //       txtQB028@1100286030 :
        txtQB028: TextConst ESP = 'El importe de abonos supera el de la factura.';
        //       txtQB029@1100286031 :
        txtQB029: TextConst ESP = 'No puede elegir efectos no aprobados.';
        //       txtQB030@1100286032 :
        txtQB030: TextConst ESP = 'No ha indicado el documento que liquida con el abono.';
        //       txtQB031@1100286033 :
        txtQB031: TextConst ESP = 'No ha incluido el documento a liquidar en la relaci�n.';
        //       txtQB032@1100286034 :
        txtQB032: TextConst ESP = 'No ha indicado documento del proveedor.';
        //       txtQB033@1100286035 :
        txtQB033: TextConst ESP = 'El documento no est� en la divisa del banco.';
        //       txtQB034@1100286036 :
        txtQB034: TextConst ESP = 'No ha generado un pagar�.';
        //       txtQB035@1100286037 :
        txtQB035: TextConst ESP = 'No ha generado el fichero electr�nico.';
        //       txtQB036@1100286038 :
        txtQB036: TextConst ESP = 'No tiene c�digo de agrupaci�n';
        //       txtQB037@1100286039 :
        txtQB037: TextConst ESP = 'No puede elegir efectos para generar pagar�s.';
        //       txtQB038@1100286040 :
        txtQB038: TextConst ESP = 'No puede elegir efectos en �rdenes de pago.';
        //       txtQB039@1100286041 :
        txtQB039: TextConst ESP = 'No puede elegir documentos con IVA diferido.';
        //       txtQB040@1100286042 :
        txtQB040: TextConst ESP = 'Ya ha incluido ese documento en la relaci�n';




    trigger OnInsert();
    begin
        SetDatosCabecera;
        VALIDATE("Document Date");
        VALIDATE(Amount);
        SetDescription;
        BuscarErrores(FALSE);
    end;

    trigger OnModify();
    begin
        SetDatosCabecera;
        if not Registrada then begin
            VALIDATE("Document Date");
            VALIDATE(Amount);
            SetDescription;
            BuscarErrores(FALSE);
        end;
    end;

    trigger OnDelete();
    begin
        if ("No. Pagare" <> '') then
            ERROR(txtQB000);
        if ("Exported to Payment File") then
            ERROR(txtQB001);

        //Quitamos el documento que liquida
        LiquidarDocumento("Liquida Documento", '');
    end;

    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Gen. Journal Document Type"): Option;
    var
        optionValue: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";
    //" ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill";
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

    procedure SetDatosCabecera()
    begin
        Cabecera.GET("Relacion No.");
        Registrada := Cabecera.Registrada;
        "Posting Date" := Cabecera."Posting Date";
    end;

    procedure SetDescription()
    begin
        QBRelationshipSetup.GET();
        if not Vendor.GET("Vendor No.") then
            Vendor.INIT;
        if not VendorLedgerEntry.GET("No. Mov. Proveedor") then
            VendorLedgerEntry.INIT;

        if ("No. Pagare" <> '') then
            auxEfecto := "No. Pagare"
        else
            auxEfecto := "Bill No.";

        Cabecera.GET("Relacion No.");
        CASE Cabecera."Bank Payment Type" OF
            Cabecera."Bank Payment Type"::"Computer Check", Cabecera."Bank Payment Type"::"Manual Check":
                CASE "Tipo Linea" OF
                    "Tipo Linea"::Factura:
                        auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Factura", auxEfecto, "External Document No.", Vendor.Name);
                    "Tipo Linea"::Abono:
                        auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Aplicar Abono", "Document No.", "Liquida Documento", Vendor.Name);
                    "Tipo Linea"::Anticipado:
                        auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Pago Anticipado", auxEfecto, "External Document No.", Vendor.Name);
                    "Tipo Linea"::Cambio:
                        auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Cancelar Vto.", "Bill No.", "External Document No.", Vendor.Name);
                end;
            Cabecera."Bank Payment Type"::OrdenPago:
                auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Agrupar Fra", "No. Agrupacion", "External Document No.", Vendor.Name);
        end;
        Description1 := COPYSTR(auxTxt, 1, MAXSTRLEN(Description1));

        CASE Cabecera."Bank Payment Type" OF
            Cabecera."Bank Payment Type"::"Computer Check", Cabecera."Bank Payment Type"::"Manual Check":
                CASE "Tipo Linea" OF
                    "Tipo Linea"::Factura:
                        auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Efecto", auxEfecto, "External Document No.", Vendor.Name);
                    "Tipo Linea"::Abono:
                        auxTxt := '';
                    "Tipo Linea"::Anticipado:
                        auxTxt := STRSUBSTNO(txtQB019, auxEfecto, "External Document No.", Vendor.Name);
                    "Tipo Linea"::Cambio:
                        auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Nuevo Vto.", auxEfecto, "External Document No.", Vendor.Name);
                end;
            Cabecera."Bank Payment Type"::OrdenPago:
                auxTxt := STRSUBSTNO(QBRelationshipSetup."RP Texto para Efecto Agrupado", "No. Agrupacion", '', Vendor.Name);
        end;
        Description2 := COPYSTR(auxTxt, 1, MAXSTRLEN(Description2));
    end;

    //     procedure BuscarErrores (pImpresion@1100286000 :
    procedure BuscarErrores(pImpresion: Boolean): Boolean;
    begin
        Cabecera.GET("Relacion No.");
        BankAccount.GET(Cabecera."Bank Account No.");

        "Texto Error" := '';

        if ("Vendor No." = '') then
            AddError(txtQB020);
        if ("Document No." = '') then
            AddError(txtQB021);
        if ("Due Date" = 0D) then
            AddError(txtQB022);
        if (Amount = 0) then
            AddError(txtQB023);
        if ("Payment Method Code" = '') then
            AddError(txtQB024);
        if (not PaymentMethod.GET("Payment Method Code")) then
            AddError(txtQB025);
        if ("Payment Terms Code" = '') then
            AddError(txtQB026);

        if ("Tipo Linea" <> "Tipo Linea"::Abono) and (not PaymentMethod."Create Bills") then
            AddError(txtQB027);

        CASE "Tipo Linea" OF
            "Tipo Linea"::Factura:
                begin
                    if ("Importe Pendiente" < 0) then
                        AddError(txtQB028);

                    //JAV 19/10/20: - QB 1.06.19 Si est� activa la aprobaci�n de cartera, tiene que estar aprobado en cartera para poder incluirlo
                    if (not IsApproved("Vendor No.", "Document No.")) then  //JAV 30/06/22: - QB 1.10.57 Se pasa a una funci�n para poder llamarlo desde mas lugares
                        AddError(txtQB029);

                end;
            "Tipo Linea"::Abono:
                begin
                    if ("Liquida Documento" = '') then
                        AddError(txtQB030)
                    else begin
                        Lineas.RESET;
                        Lineas.SETRANGE("Relacion No.", "Relacion No.");
                        Lineas.SETRANGE("Tipo Linea", "Tipo Linea"::Factura);
                        Lineas.SETRANGE("Document No.", "Liquida Documento");
                        if (Lineas.ISEMPTY) then
                            AddError(txtQB031);
                    end;
                end;
            "Tipo Linea"::Anticipado:
                begin
                    if ("External Document No." = '') then
                        AddError(txtQB032);
                end;
            "Tipo Linea"::Cambio:
                begin
                    //if ("Due Date" <= "Original Due Date") then
                    //  AddError('La nueva fecha de vto, debe ser superior a la original.');
                end;
        end;

        if VendorLedgerEntry.GET("No. Mov. Proveedor") then begin
            if VendorLedgerEntry."Currency Code" <> BankAccount."Currency Code" then
                AddError(txtQB033);
        end;

        if (not pImpresion) then begin
            if (Cabecera."Bank Payment Type" IN [Cabecera."Bank Payment Type"::"Computer Check", Cabecera."Bank Payment Type"::"Manual Check"]) and ("No. Pagare" = '') then
                AddError(txtQB034);

            if ("Tipo Linea" <> "Tipo Linea"::Abono) and (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::"Computer Check") then
                if (BankAccount."N67 Obligatoria") and (not "Exported to Payment File") then
                    AddError(txtQB035);
        end;

        if (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago) then begin
            if ("Include in Payment Order") and ("No. Agrupacion" = '') then
                AddError(txtQB036);
        end;

        if (Cabecera."Bank Payment Type" IN [Cabecera."Bank Payment Type"::"Computer Check", Cabecera."Bank Payment Type"::"Manual Check"]) then
            if ("Document Type" = "Document Type"::Bill) then
                AddError(txtQB037);

        //No puede estar incluido en una remesa
        if not (VendorLedgerEntry."Document Situation" IN [VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera]) then
            AddError(txtQB038);

        //JAV 26/10/20: - No pueden ser documentos con IVA diferido
        VATEntry.RESET;
        VATEntry.SETRANGE("Document No.", "Document No.");
        VATEntry.SETFILTER("Remaining Unrealized Amount", '<>0');
        if (not VATEntry.ISEMPTY) then
            AddError(txtQB039);

        //if (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago) then
        //  if ("Document Type" <> "Document Type"::Bill) then
        //    AddError('Solo puede elegir efectos para generar la orden de pago.');

        exit("Texto Error" <> '');
    end;

    //     LOCAL procedure AddError (parTexto@7001100 :
    LOCAL procedure AddError(parTexto: Text)
    begin
        if ("Texto Error" <> '') then
            parTexto := "Texto Error" + ' ' + parTexto;
        "Texto Error" := COPYSTR(parTexto, 1, MAXSTRLEN("Texto Error"));
    end;

    LOCAL procedure BuscarDuplicados()
    begin
        if ("Tipo Linea" <> "Tipo Linea"::Factura) then begin
            Lineas.RESET;
            Lineas.SETRANGE("Relacion No.", "Relacion No.");
            Lineas.SETFILTER("Line No.", '<>%1', "Line No.");
            Lineas.SETRANGE("Tipo Linea", "Tipo Linea");
            Lineas.SETRANGE("Document No.", "Document No.");
            if (Lineas.COUNT > 1) then
                ERROR(txtQB040);
        end;
    end;

    //     LOCAL procedure LiquidarDocumento (parOldDoc@7001100 : Code[20];parNewDoc@7001101 :
    LOCAL procedure LiquidarDocumento(parOldDoc: Code[20]; parNewDoc: Code[20])
    begin
        //Quitamos el documento que liquida
        if (parOldDoc <> '') then begin
            "Liquida Documento" := '';
            if not MODIFY then INSERT;

            //Quitamos del documento liquidado
            Lineas.RESET;
            Lineas.SETRANGE("Relacion No.", "Relacion No.");
            Lineas.SETRANGE("Tipo Linea", "Tipo Linea"::Factura);
            Lineas.SETRANGE("Document No.", parOldDoc);
            if (Lineas.FINDSET) then
                repeat
                    Lineas.VALIDATE(Amount);
                    Lineas.MODIFY;
                until Lineas.NEXT = 0;
        end;

        if (parNewDoc <> '') then begin
            "Liquida Documento" := parNewDoc;
            if not MODIFY then INSERT;

            //A�adimos al documento liquidado
            Lineas.RESET;
            Lineas.SETRANGE("Relacion No.", "Relacion No.");
            Lineas.SETRANGE("Tipo Linea", "Tipo Linea"::Factura);
            Lineas.SETRANGE("Document No.", parNewDoc);
            if (Lineas.FINDSET) then
                repeat
                    Lineas.VALIDATE(Amount);
                    Lineas.MODIFY;
                until Lineas.NEXT = 0;
        end;
    end;

    procedure Navigate()
    var
        //       NavigateForm@1100286000 :
        NavigateForm: Page "Navigate";
    begin
        NavigateForm.SetDoc("Posting Date", "Document No.");
        NavigateForm.RUN;
    end;

    //     procedure IsApproved (pVendor@1100286001 : Code[20];pDoc@1100286000 :
    procedure IsApproved(pVendor: Code[20]; pDoc: Code[20]): Boolean;
    begin
        //JAV 19/10/20: - QB 1.06.19 Si est� activa la aprobaci�n de cartera, tiene que estar aprobado en cartera para poder incluirlo
        //JAV 30/06/22: - QB 1.10.57 Funci�n para verificar si el documento relacionado con el de la l�nea est� aprobado
        if (ApprovalCarteraDoc.IsApprovalsWorkflowActive) then begin
            CarteraDoc.RESET;
            CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
            CarteraDoc.SETRANGE("Document No.", pDoc);
            CarteraDoc.SETRANGE("Account No.", pVendor);
            if (CarteraDoc.FINDFIRST) then
                if (CarteraDoc."Approval Status" <> CarteraDoc."Approval Status"::Released) then
                    exit(FALSE);
        end;

        exit(TRUE);
    end;

    /*begin
    end.
  */
}








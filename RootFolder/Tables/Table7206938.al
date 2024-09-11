table 7206938 "QB Framework Contr. Line"
{


    DataPerCompany = false;
    CaptionML = ENU = 'Blanket Purchase Line', ESP = 'L�nea Contrato Marco';
    LookupPageID = "Purchase Lines";
    DrillDownPageID = "Purchase Lines";

    fields
    {
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Vendor No.', ESP = 'Compra a-N� proveedor';
            Editable = false;


        }
        field(3; "Document No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header";
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(4; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(5; "Type"; Option)
        {
            OptionMembers = " ","Item","Resource";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,Item,Resource"', ESP = '" ,Producto,Recurso"';

            Description = 'QB2514';

            trigger OnValidate();
            VAR
                //                                                                 TempLine@1000 :
                TempLine: Record 7206938 TEMPORARY;
            BEGIN
                GetPurchHeader;
                TestStatusOpen;

                IF (Type <> xRec.Type) AND (xRec.Type <> Type::" ") THEN BEGIN
                    IF "Quantity Max" <> 0 THEN
                        QBBlanketPurchaseHeader.TESTFIELD(Status, QBBlanketPurchaseHeader.Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
                END;

                TempLine := Rec;
                INIT;

                Type := TempLine.Type;
            END;


        }
        field(6; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST(" ")) "Standard Text" ELSE IF ("Type" = CONST("Item")) Item WHERE("Blocked" = CONST(false)) ELSE IF ("Type" = CONST("Resource")) Resource WHERE("Type" = FILTER(<> "ExternalWorker"));


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'QB 1.06.10 - JAV 24/08/20: - No puede ser un trabajador externo';

            trigger OnValidate();
            VAR
                //                                                                 TempLine@1003 :
                TempLine: Record 7206938 TEMPORARY;
                //                                                                 FindRecordMgt@1000 :
                FindRecordMgt: Codeunit 703;
            BEGIN
                TestStatusOpen;
                TempLine := Rec;
                INIT;
                Type := TempLine.Type;
                "No." := TempLine."No.";
                "Quantity Max" := TempLine."Quantity Max";

                GetPurchHeader;
                InitHeaderDefaults(QBBlanketPurchaseHeader);

                CASE Type OF
                    Type::Item:
                        CopyFromItem;
                    Type::Resource:
                        CopyFromResource;
                END;

                IF HasTypeToFillMandatoryFields THEN BEGIN
                    "Quantity Max" := xRec."Quantity Max";
                    VALIDATE("Unit of Measure Code");
                END;

                QBBlanketPurchaseHeader.GET("Document No.");
            END;


        }
        field(9; "Init Date"; Date)
        {
            AccessByPermission = TableData 120 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Order Date', ESP = 'Fecha Inicio del contrato';


        }
        field(10; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ending Contract Date', ESP = 'Fecha Fin del Contrato';


        }
        field(11; "Description"; Text[50])
        {
            TableRelation = IF (Type = CONST(Item)) Item."Description" WHERE("Blocked" = CONST(false),
                                                                                                               "Purchasing Blocked" = CONST(false));


            ValidateTableRelation = false;
            CaptionML = ENU = 'Description', ESP = 'Descripción';

            trigger OnValidate();
            VAR
                //                                                                 Item@1000 :
                Item: Record 27;
                //                                                                 ApplicationAreaMgmtFacade@1003 :
                ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                //                                                                 FindRecordMgt@1002 :
                FindRecordMgt: Codeunit 703;
                //                                                                 ReturnValue@1001 :
                ReturnValue: Text[50];
                //                                                                 DescriptionIsNo@1004 :
                DescriptionIsNo: Boolean;
            BEGIN
                IF Type = Type::" " THEN
                    EXIT;

                IF "No." <> '' THEN
                    EXIT;

                CASE Type OF
                    Type::Item:
                        BEGIN
                            IF STRLEN(Description) <= MAXSTRLEN(Item."No.") THEN
                                DescriptionIsNo := Item.GET(Description)
                            ELSE
                                DescriptionIsNo := FALSE;

                            IF NOT DescriptionIsNo THEN BEGIN
                                Item.SETFILTER(Description, '''@' + CONVERTSTR(Description, '''', '?') + '''');
                                Item.SETRANGE(Blocked, FALSE);
                                Item.SETRANGE("Purchasing Blocked", FALSE);
                                IF Item.FINDFIRST THEN BEGIN
                                    VALIDATE("No.", Item."No.");
                                    EXIT;
                                END;
                            END;

                            IF Item.TryGetItemNoOpenCard(ReturnValue, Description, FALSE, FALSE, FALSE) THEN
                                CASE ReturnValue OF
                                    '', "No.":
                                        Description := xRec.Description;
                                    ELSE
                                        VALIDATE("No.", COPYSTR(ReturnValue, 1, MAXSTRLEN(Item."No.")));
                                END;
                        END;
                    ELSE BEGIN
                        ReturnValue := FindRecordMgt.FindNoByDescription(Type, Description, TRUE);
                        IF ReturnValue <> '' THEN BEGIN
                            CurrFieldNo := FIELDNO("No.");
                            VALIDATE("No.", COPYSTR(ReturnValue, 1, MAXSTRLEN("No.")));
                        END;
                    END;
                END;
            END;


        }
        field(12; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(15; "Quantity Max"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad M�xima';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            VAR
                //                                                                 IsHandled@1000 :
                IsHandled: Boolean;
            BEGIN
                TestStatusOpen;
                IsHandled := FALSE;

                VALIDATE("Line Discount %");

                IF (xRec."Quantity Max" <> "Quantity Max") AND ("Quantity Max" = 0) AND
                   ((Amount <> 0) OR ("Amount Including VAT" <> 0))
                THEN BEGIN
                    Amount := 0;
                    "Amount Including VAT" := 0;
                END;
            END;


        }
        field(22; "Direct Unit Cost"; Decimal)
        {


            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Coste unit. directo';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";

            trigger OnValidate();
            BEGIN
                VALIDATE("Line Discount %");
            END;


        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {


            CaptionML = ENU = 'Unit Cost (LCY)', ESP = 'Coste unitario (DL)';
            AutoFormatType = 2;

            trigger OnValidate();
            VAR
                //                                                                 Item@1001 :
                Item: Record 27;
                //                                                                 IndirectCostPercent@1000 :
                IndirectCostPercent: Decimal;
            BEGIN
                TestStatusOpen;
                TESTFIELD("No.");
                TESTFIELD("Quantity Max");

                IF CurrFieldNo = FIELDNO("Unit Cost (LCY)") THEN
                    IF Type = Type::Item THEN BEGIN
                        GetItem(Item);
                        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                            ERROR(
                              Text010,
                              FIELDCAPTION("Unit Cost (LCY)"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method");
                    END;

                UnitCostCurrency := "Unit Cost (LCY)";
                GetPurchHeader;
                IF QBBlanketPurchaseHeader."Currency Code" <> '' THEN BEGIN
                    QBBlanketPurchaseHeader.TESTFIELD("Currency Factor");
                    UnitCostCurrency :=
                      ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          WORKDATE, "Currency Code",
                          "Unit Cost (LCY)", QBBlanketPurchaseHeader."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision");
                END;
            END;


        }
        field(25; "VAT %"; Decimal)
        {
            CaptionML = ENU = 'VAT %', ESP = '% IVA';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(27; "Line Discount %"; Decimal)
        {


            CaptionML = ENU = 'Line Discount %', ESP = '% Descuento l�nea';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate();
            BEGIN
                ValidateLineDiscountPercent(TRUE);
            END;


        }
        field(28; "Line Discount Amount"; Decimal)
        {


            CaptionML = ENU = 'Line Discount Amount', ESP = 'Importe dto. l�nea';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";

            trigger OnValidate();
            BEGIN
                GetPurchHeader;
                "Line Discount Amount" := ROUND("Line Discount Amount", Currency."Amount Rounding Precision");
                TestStatusOpen;
                TESTFIELD("Quantity Max");
                IF xRec."Line Discount Amount" <> "Line Discount Amount" THEN
                    UpdateLineDiscPct;
                "Inv. Discount Amount" := 0;
                UpdateUnitCost;
            END;


        }
        field(29; "Amount"; Decimal)
        {


            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";

            trigger OnValidate();
            BEGIN
                GetPurchHeader;
                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                UpdateUnitCost;
            END;


        }
        field(30; "Amount Including VAT"; Decimal)
        {


            CaptionML = ENU = 'Amount Including VAT', ESP = 'Importe IVA incl.';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";

            trigger OnValidate();
            BEGIN
                GetPurchHeader;
                "Amount Including VAT" := ROUND("Amount Including VAT", Currency."Amount Rounding Precision");
                UpdateUnitCost;
            END;


        }
        field(69; "Inv. Discount Amount"; Decimal)
        {


            CaptionML = ENU = 'Inv. Discount Amount', ESP = 'Importe dto. factura';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";

            trigger OnValidate();
            BEGIN
                UpdateUnitCost;
            END;


        }
        field(91; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            TableRelation = IF ("Type" = CONST("Item"),
                                                                     "No." = FILTER(<> '')) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";


            CaptionML = ENU = 'Unit of Measure Code', ESP = 'C�d. unidad medida';

            trigger OnValidate();
            VAR
                //                                                                 Item@1001 :
                Item: Record 27;
                //                                                                 UnitOfMeasureTranslation@1000 :
                UnitOfMeasureTranslation: Record 5402;
            BEGIN
            END;


        }
        field(7207300; "Quantity in Invoices"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Invoice")));
            CaptionML = ENU = 'Quantity in Invoices', ESP = 'Cantidad en facturas';
            Editable = false;


        }
        field(7207301; "Quantity in Orders"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Order")));
            CaptionML = ENU = 'Quantity in Orders', ESP = 'Cantidad en pedidos';
            Editable = false;


        }
        field(7207302; "Quantity in Shipmets"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Shipment")));
            CaptionML = ENU = 'Quantity in Shipmets', ESP = 'Cantidad en albaranes';
            Editable = false;


        }
        field(7207303; "Quantity in Comparatives"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Comparative")));
            CaptionML = ENU = 'Quantity in Shipmets', ESP = 'Cantidad en Comparativos';
            Description = 'QB 1.10.47  JAV 02/06/22: - [TT] Cantidad en l�neas de comparativos (dato informativo, hasta que no sea un pedido de compra no se controla el m�ximo)';
            Editable = false;


        }
        field(7207304; "Qty. in Inv. from Shipments"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Invoice"),
                                                                                                             "Invoice Document Sub-Type" = FILTER("Inv. from Shipment")));
            CaptionML = ENU = 'Qty. in Inv. from Shipments', ESP = 'Cdad. en Fras. de Albaranes';
            Description = 'Q17592 CPA 30/06/22 Ajustes en contratos marco';


        }
        field(7207305; "Qty. in direct Invoices"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Invoice"),
                                                                                                             "Invoice Document Sub-Type" = FILTER(' ')));
            CaptionML = ENU = 'Qty. in direct Invoices', ESP = 'Cdad. en Fracturas directas';
            Description = 'Q17592 CPA 30/06/22 Ajustes en contratos marco';


        }
        field(7207306; "Qty. In-progress Comparative"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Comparative"),
                                                                                                             "Comparative document Status" = FILTER("In-Progress")));
            CaptionML = ENU = 'Qty. in In-Progress Comparatives', ESP = 'Cdad. en Comparativos en curso';
            Description = 'Q17592 CPA 30/06/22 Ajustes en contratos marco';


        }
        field(7207307; "Qty. Inactive Comparative"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Framework Contr. Use"."Quantity" WHERE("Framework Contr. No." = FIELD("Document No."),
                                                                                                             "Framework Contr. Line" = FIELD("Line No."),
                                                                                                             "Document Type" = CONST("Comparative"),
                                                                                                             "Comparative document Status" = FILTER("Inactive")));
            CaptionML = ENU = 'Qty. in Inactive Comparatives', ESP = 'Cdad. en Comparatives no activos';
            Description = 'Q17592 CPA 30/06/22 Ajustes en contratos marco';


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       ConfBlnktOrder0@1100286004 :
        ConfBlnktOrder0: TextConst ENU = 'There is a Blanket Order with the %1 %2 with a %3 of %4. Would you like to bring the information?', ESP = 'Hay un contrato marco a precio de %1, �Desea utilizarlo?';
        //       ConfBlnktOrder1@1100286003 :
        ConfBlnktOrder1: TextConst ENU = 'There is a Blanket Order with the %1 %2 with a %3 of %4. Would you like to bring the information?', ESP = 'Hay un contrato marco a precio de %1 con una cantidad disponible de %2, �Desea utilizarlo?';
        //       ConfBlnktOrder2@1100286005 :
        ConfBlnktOrder2: TextConst ESP = 'Hay un contrato marco a precio de %1 con una cantidad disponible de %2, pero tiene ya previso usarse %3 �Desea utilizarlo?';
        //       Text000@1000 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text010@1009 :
        Text010: TextConst ENU = 'You cannot change %1 when %2 is %3.', ESP = 'No se puede cambiar %1 cuando %2 es %3.';
        //       QBBlanketPurchaseHeader@1022 :
        QBBlanketPurchaseHeader: Record 7206937;
        //       Currency@1027 :
        Currency: Record 4;
        //       CurrExchRate@1028 :
        CurrExchRate: Record 330;
        //       UnitOfMeasure@1043 :
        UnitOfMeasure: Record 204;
        //       UOMMgt@1060 :
        UOMMgt: Codeunit 5402;
        //       UnitCostCurrency@1063 :
        UnitCostCurrency: Decimal;
        //       CommentLbl@1024 :
        CommentLbl: TextConst ENU = 'Comment', ESP = 'Comentario';
        //       LineDiscountPctErr@1036 :
        LineDiscountPctErr: TextConst ENU = 'The value in the Line Discount % field must be between 0 and 100.', ESP = 'El valor en el campo % Descuento l�nea debe ser entre 0 y 100.';
        //       ItemBlockedErr@1100286002 :
        ItemBlockedErr: TextConst ENU = 'You cannot purchase this item because the Purchasing Blocked check box is selected on the item card.', ESP = 'No puede comprar este producto porque la casilla Compras bloqueadas est� seleccionada en la ficha de producto.';
        //       ResourceBlockedErr@1100286000 :
        ResourceBlockedErr: TextConst ENU = 'You cannot purchase this item because the Purchasing Blocked check box is selected on the item card.', ESP = 'No puede comprar este recurso porque est� bloqueado en su ficha.';
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;



    trigger OnInsert();
    begin
        TestStatusOpen;
        LOCKTABLE;
        QBBlanketPurchaseHeader."No." := '';
    end;

    trigger OnModify();
    begin
        //Q12867 -
        CheckBlackPurchHdrStatus;
        //Q12867 +
    end;

    trigger OnDelete();
    var
        //                PurchCommentLine@1001 :
        PurchCommentLine: Record 43;
        //                SalesOrderLine@1000 :
        SalesOrderLine: Record 37;
        //                QBExternalWorksheetLinesPo@1100286000 :
        QBExternalWorksheetLinesPo: Record 7206936;
    begin
        TestStatusOpen;

        //Q12867 -
        CheckBlackPurchHdrStatus;
        //Q12867 +

        // In case we have roundings on VAT or Sales Tax, we should update some other line
        if (Type <> Type::" ") and ("Line No." <> 0) and
           ("Quantity Max" <> 0) and (Amount <> 0) and (Amount <> "Amount Including VAT")
        then begin
            "Quantity Max" := 0;
            "Line Discount Amount" := 0;
            "Inv. Discount Amount" := 0;
        end;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    procedure QuantityPending(): Decimal;
    begin
        if ("Quantity Max" = 0) then
            exit(0)
        else begin
            CALCFIELDS("Quantity in Invoices", "Quantity in Orders");
            exit("Quantity Max" - "Quantity in Invoices" - "Quantity in Orders");
        end;
    end;

    //     procedure MsgSelect (pUsed@1100286000 :
    procedure MsgSelect(pUsed: Decimal): Text;
    begin
        if ("Quantity Max" = 0) then
            exit(STRSUBSTNO(ConfBlnktOrder0, "Direct Unit Cost"))
        else
            if (pUsed <= 0) then
                exit(STRSUBSTNO(ConfBlnktOrder1, "Direct Unit Cost", QuantityPending))
            else
                exit(STRSUBSTNO(ConfBlnktOrder2, "Direct Unit Cost", QuantityPending, pUsed))
    end;

    LOCAL procedure "-------------------------------------------------------------------------"()
    begin
    end;

    //     LOCAL procedure InitHeaderDefaults (PurchHeader@1000 :
    LOCAL procedure InitHeaderDefaults(PurchHeader: Record 7206937)
    begin
        QBBlanketPurchaseHeader.TESTFIELD("Vendor No.");

        "Vendor No." := QBBlanketPurchaseHeader."Vendor No.";
        "Init Date" := QBBlanketPurchaseHeader."Init Date";
        "end Date" := QBBlanketPurchaseHeader."end Date";
        "Currency Code" := QBBlanketPurchaseHeader."Currency Code";
    end;

    LOCAL procedure CopyFromItem()
    var
        //       Item@1100286000 :
        Item: Record 27;
    begin
        GetItem(Item);
        Item.TESTFIELD(Blocked, FALSE);
        Item.TESTFIELD("Gen. Prod. Posting Group");
        if Item."Purchasing Blocked" then
            ERROR(ItemBlockedErr);
        if Item.Type = Item.Type::Inventory then begin
            Item.TESTFIELD("Inventory Posting Group");
        end;
        Description := Item.Description;
        "Description 2" := Item."Description 2";

        if QBBlanketPurchaseHeader."Language Code" <> '' then
            GetItemTranslation;

        "Unit of Measure Code" := Item."Purch. Unit of Measure";
    end;

    LOCAL procedure CopyFromResource()
    var
        //       Resource@1100286000 :
        Resource: Record 156;
    begin
        GetResource(Resource);
        Resource.TESTFIELD(Blocked, FALSE);
        Resource.TESTFIELD("Gen. Prod. Posting Group");
        if Resource.Blocked then
            ERROR(ResourceBlockedErr);
        Description := Resource.Name;
        "Description 2" := Resource."Name 2";

        if QBBlanketPurchaseHeader."Language Code" <> '' then
            GetItemTranslation;

        "Unit of Measure Code" := Resource."Base Unit of Measure";
    end;


    //     procedure SetPurchHeader (NewQBBlanketPurchaseHeader@1000 :
    procedure SetPurchHeader(NewQBBlanketPurchaseHeader: Record 7206937)
    begin
        QBBlanketPurchaseHeader := NewQBBlanketPurchaseHeader;

        if QBBlanketPurchaseHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            QBBlanketPurchaseHeader.TESTFIELD("Currency Factor");
            Currency.GET(QBBlanketPurchaseHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        end;
    end;

    LOCAL procedure GetPurchHeader()
    begin
        TESTFIELD("Document No.");
        QBBlanketPurchaseHeader.GET("Document No.");
        if QBBlanketPurchaseHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            QBBlanketPurchaseHeader.TESTFIELD("Currency Factor");
            Currency.GET(QBBlanketPurchaseHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        end;
    end;

    //     LOCAL procedure GetItem (var Item@1000 :
    LOCAL procedure GetItem(var Item: Record 27)
    begin
        TESTFIELD("No.");
        Item.GET("No.");
    end;

    //     LOCAL procedure GetResource (var Resource@1000 :
    LOCAL procedure GetResource(var Resource: Record 156)
    begin
        TESTFIELD("No.");
        Resource.GET("No.");
    end;


    procedure UpdateUnitCost()
    var
        //       Item@1001 :
        Item: Record 27;
        //       DiscountAmountPerQty@1000 :
        DiscountAmountPerQty: Decimal;
    begin
        GetPurchHeader;
        if "Quantity Max" = 0 then
            DiscountAmountPerQty := 0
        else
            DiscountAmountPerQty :=
              ROUND(("Line Discount Amount" + "Inv. Discount Amount") / "Quantity Max",
                Currency."Unit-Amount Rounding Precision");

        if QBBlanketPurchaseHeader."Currency Code" <> '' then begin
            QBBlanketPurchaseHeader.TESTFIELD("Currency Factor");
            "Unit Cost (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WORKDATE, "Currency Code",
                "Direct Unit Cost", QBBlanketPurchaseHeader."Currency Factor");
        end else
            "Unit Cost (LCY)" := "Direct Unit Cost";

        "Unit Cost (LCY)" := ROUND("Unit Cost (LCY)", Currency."Unit-Amount Rounding Precision");
        if QBBlanketPurchaseHeader."Currency Code" <> '' then
            Currency.TESTFIELD("Unit-Amount Rounding Precision");
        "Direct Unit Cost" := ROUND("Direct Unit Cost", Currency."Unit-Amount Rounding Precision");
    end;

    //     LOCAL procedure InitNewLine (var NewPurchLine@1001 :
    LOCAL procedure InitNewLine(var NewPurchLine: Record 7206938)
    var
        //       PurchLine@1000 :
        PurchLine: Record 7206938;
    begin
        NewPurchLine.COPY(Rec);
        PurchLine.SETRANGE("Document No.", NewPurchLine."Document No.");
        if PurchLine.FINDLAST then
            NewPurchLine."Line No." := PurchLine."Line No."
        else
            NewPurchLine."Line No." := 0;
    end;


    procedure TestStatusOpen()
    begin
        GetPurchHeader;
        QBBlanketPurchaseHeader.TESTFIELD(Status, QBBlanketPurchaseHeader.Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
    end;


    procedure GetItemTranslation()
    var
        //       ItemTranslation@1000 :
        ItemTranslation: Record 30;
    begin
        GetPurchHeader;
        if ItemTranslation.GET("No.", '', QBBlanketPurchaseHeader."Language Code") then begin
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
        end;
    end;


    //     procedure ValidateLineDiscountPercent (DropInvoiceDiscountAmount@1000 :
    procedure ValidateLineDiscountPercent(DropInvoiceDiscountAmount: Boolean)
    begin
        TestStatusOpen;
        GetPurchHeader;
        "Line Discount Amount" :=
          ROUND(
            ROUND("Quantity Max" * "Direct Unit Cost", Currency."Amount Rounding Precision") *
            "Line Discount %" / 100,
            Currency."Amount Rounding Precision");
        if DropInvoiceDiscountAmount then begin
            "Inv. Discount Amount" := 0;
        end;
        UpdateUnitCost;
    end;


    procedure HasTypeToFillMandatoryFields(): Boolean;
    begin
        exit(Type <> Type::" ");
    end;


    //     procedure RenameNo (LineType@1000 : Option;OldNo@1001 : Code[20];NewNo@1002 :
    procedure RenameNo(LineType: Option; OldNo: Code[20]; NewNo: Code[20])
    begin
        RESET;
        SETRANGE(Type, LineType);
        SETRANGE("No.", OldNo);
        MODIFYALL("No.", NewNo, TRUE);
    end;

    LOCAL procedure UpdateLineDiscPct()
    var
        //       LineDiscountPct@1000 :
        LineDiscountPct: Decimal;
    begin
        if ROUND("Quantity Max" * "Direct Unit Cost", Currency."Amount Rounding Precision") <> 0 then begin
            LineDiscountPct := ROUND(
                "Line Discount Amount" / ROUND("Quantity Max" * "Direct Unit Cost", Currency."Amount Rounding Precision") * 100,
                0.00001);
            if not (LineDiscountPct IN [0 .. 100]) then
                ERROR(LineDiscountPctErr);
            "Line Discount %" := LineDiscountPct;
        end else
            "Line Discount %" := 0;
    end;

    LOCAL procedure CheckBlackPurchHdrStatus()
    begin
        GetPurchHeader;

        // //Q12867 -
        //
        // //CPA 30/06/22: Q17502 - Ajustes en cotratos marco.begin
        // //QBBlanketPurchaseHeader.TESTFIELD(OLD_Status,QBBlanketPurchaseHeader.OLD_Status::Active);
        // CASE TRUE OF
        //  QBBlanketPurchaseHeader."OLD_Approval Situation" = QBBlanketPurchaseHeader."OLD_Approval Situation"::Approved:
        //    QBBlanketPurchaseHeader.TESTFIELD(Status,QBBlanketPurchaseHeader.Status::Operative);
        //  else
        //    QBBlanketPurchaseHeader.TESTFIELD(Status,QBBlanketPurchaseHeader.Status::"Non-operational");
        // end;
        // //CPA 30/06/22: Q17502 - Ajustes en cotratos marco.end
        // //12867 +

        QBBlanketPurchaseHeader.TESTFIELD(Status, QBBlanketPurchaseHeader.Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
    end;

    /*begin
    //{
//      //Q12867 JDC 25/02/21 - Added function "CheckBlackPurchHdrStatus"
//                              Modified function "OnModify, "OnDelete"
//      CPA 30/06/22: Q17502 - Ajustes en cotratos marco
//                    CheckBlackPurchHdrStatus
//      JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
//    }
    end.
  */
}








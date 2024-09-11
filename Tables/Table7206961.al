table 7206961 "QBU Proform Line"
{


    CaptionML = ENU = 'QB Proform Line', ESP = 'QB L�neas proforma';
    LookupPageID = "QB Proform Subform";
    DrillDownPageID = "QB Proform Subform";

    fields
    {
        field(2; "Buy-from Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Buy-from Vendor No.', ESP = 'Compra a-N� proveedor';
            Editable = false;


        }
        field(3; "Document No."; Code[20])
        {
            TableRelation = "QB Proform Header";
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(4; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(5; "Type"; Option)
        {
            OptionMembers = " ","G/L Account","Item","Fixed Asset","Charge (Item)","Resource";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,G/L Account,Item,,Fixed Asset,Charge (Item),,Resource"', ESP = '" ,Cuenta,Producto,,Activo fijo,Cargo (Prod.),,Recurso"';

            Editable = false;


        }
        field(6; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("G/L Account")) "G/L Account" ELSE IF ("Type" = CONST("Item")) "Item" ELSE IF ("Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE IF ("Type" = CONST("Charge (Item)")) "Item Charge";
            CaptionML = ENU = 'No.', ESP = 'N�';
            Editable = false;
            CaptionClass = GetCaptionClass(FIELDNO("No."));


        }
        field(7; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            CaptionML = ENU = 'Location Code', ESP = 'C�d. almac�n';


        }
        field(8; "Posting Group"; Code[20])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Inventory Posting Group" ELSE IF ("Type" = CONST("Fixed Asset")) "FA Posting Group";
            CaptionML = ENU = 'Posting Group', ESP = 'Grupo de registro';
            Editable = false;


        }
        field(11; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripción';

            trigger OnValidate();
            BEGIN
                //JAV 20/07/21: - QB 1.09.10 Si estamos en este campo y cambiamos el estado, no se pone autom�ticamente como no editable
                IsEditable;
            END;


        }
        field(12; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(13; "Unit of Measure"; Text[10])
        {


            CaptionML = ENU = 'Unit of Measure', ESP = 'Unidad medida';

            trigger OnValidate();
            BEGIN
                //JAV 20/07/21: - QB 1.09.10 Si estamos en este campo y cambiamos el estado, no se pone autom�ticamente como no editable
                IsEditable;
            END;


        }
        field(15; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            BEGIN
                //JAV 20/07/21: - QB 1.09.10 Si estamos en este campo y cambiamos el estado, no se pone autom�ticamente como no editable
                IsEditable;

                //Solo para l�neas de la proforma se verifican las cantidades m�ximas
                IF (NOT "QB Recurrent Line") THEN BEGIN
                    CALCFIELDS("QB Qty. In Order");
                    QBProform.RecalculateLineOrigin(Rec, Quantity);  //Recalcular la cantidad a origen

                    NewOrigin := "QB Qty. Proformed Origin";

                    //El total no puede ser negativo
                    IF (NewOrigin < 0) THEN
                        ERROR(Text001);

                    //Si el m�ximo a proformar es lo recibido
                    IF (NewOrigin > "QB Qty Received Origin") THEN
                        ERROR(Text000, "QB Qty Received Origin" - "QB Qty. Proformed Origin");

                    //Si se puede proformar por adelantado, el m�ximo a proformar es lo recibido
                    //IF (NewOrigin > "QB Qty. In Order") THEN
                    //  ERROR(Text002, "QB Qty. In Order" - "QB Qty. Proformed Origin");

                    //Calculamos y Guardamos para el recalculo correcto
                    CalculateAmounts;  //JAV 20/07/21: - QB 1.09.10 Calculo de los importes de la l�nea
                    MODIFY;
                END;
            END;


        }
        field(22; "Direct Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Coste unit. directo';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrencyCodeFromHeader;


        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost (LCY)', ESP = 'Coste unitario (DL)';
            Editable = false;
            AutoFormatType = 2;


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
            Editable = false;


        }
        field(29; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(31; "Unit Price (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Unit Price (LCY)', ESP = 'Precio venta (DL)';
            AutoFormatType = 2;


        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            InitValue = true;
            CaptionML = ENU = 'Allow Invoice Disc.', ESP = 'Permitir dto. factura';


        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(45; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Editable = false;


        }
        field(54; "Indirect Cost %"; Decimal)
        {
            CaptionML = ENU = 'Indirect Cost %', ESP = '% Coste indirecto';
            DecimalPlaces = 0 : 5;
            MinValue = 0;


        }
        field(58; "Qty. Rcd. Not Invoiced"; Decimal)
        {
            AccessByPermission = TableData 120 = R;
            CaptionML = ENU = 'Qty. Rcd. Not Invoiced', ESP = 'Cantidad recibida no facturada';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            CaptionML = ENU = 'Quantity Invoiced', ESP = 'Cantidad facturada';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(63; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receipt No.', ESP = 'N� albar�n compra';
            Description = 'BS18286 // Q19675';
            Editable = false;


        }
        field(65; "Order No."; Code[20])
        {
            AccessByPermission = TableData 120 = R;
            CaptionML = ENU = 'Order No.', ESP = 'N� pedido';
            Editable = false;


        }
        field(66; "Order Line No."; Integer)
        {
            AccessByPermission = TableData 120 = R;
            CaptionML = ENU = 'Order Line No.', ESP = 'N� l�nea pedido';
            Editable = false;


        }
        field(68; "Pay-to Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Pay-to Vendor No.', ESP = 'Pago-a N� proveedor';


        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
            CaptionML = ENU = 'Gen. Bus. Posting Group', ESP = 'Grupo registro neg. gen.';


        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            CaptionML = ENU = 'Gen. Prod. Posting Group', ESP = 'Grupo registro prod. gen.';


        }
        field(77; "VAT Calculation Type"; Option)
        {
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax","No Taxable VAT";
            CaptionML = ENU = 'VAT Calculation Type', ESP = 'Tipo c�lculo IVA';
            OptionCaptionML = ENU = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax,No Taxable VAT', ESP = 'Normal,Reversi�n,Total,Impto. venta,No sujeto';



        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
            CaptionML = ENU = 'VAT Bus. Posting Group', ESP = 'Grupo registro IVA neg.';


        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro IVA prod.';


        }
        field(91; "Currency Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Currency Code" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(99; "VAT Base Amount"; Decimal)
        {
            CaptionML = ENU = 'VAT Base Amount', ESP = 'Importe base IVA';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrencyCodeFromHeader;


        }
        field(100; "Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost', ESP = 'Coste unitario';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrencyCodeFromHeader;


        }
        field(131; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


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
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure', ESP = 'Cant. por unidad medida';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure Code', ESP = 'C�d. unidad medida';


        }
        field(50000; "Prod. Measure Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prob. Measure Header No.', ESP = 'N� Cab. Relaci�n Valorada';
            Description = 'BS18286';


        }
        field(50001; "Prod. Measure Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prod. Measure Line No.', ESP = 'N� l�nea Relaci�n Valorada';
            Description = 'BS18286';


        }
        field(50002; "From Measure"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Viene de la medici�n';
            Description = 'BS18286';


        }
        field(50003; "Measure Source"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;
            Description = 'BS18286';

            trigger OnValidate();
            VAR
                //                                                                 RelCertificationProduct@1100286004 :
                RelCertificationProduct: Record 7207397;
                //                                                                 ProcessOk@1100286000 :
                ProcessOk: Boolean;
                //                                                                 txtAux@1100286001 :
                txtAux: Text;
                //                                                                 incCost@1100286002 :
                incCost: Decimal;
                //                                                                 incSale@1100286003 :
                incSale: Decimal;
                //                                                                 recJob@1100286005 :
                recJob: Record 167;
            BEGIN
            END;


        }
        field(7207270; "QW % Withholding by GE"; Decimal)
        {
            CaptionML = ENU = '% Withholding by G.E', ESP = '% retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207271; "QW Withholding Amount by GE"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by G.E', ESP = 'Importe retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';
            AutoFormatType = 1;


        }
        field(7207272; "QW % Withholding by PIT"; Decimal)
        {
            CaptionML = ENU = '% Withholding by PIT', ESP = '% retenci�n IRPF';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207273; "QW Withholding Amount by PIT"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by PIT', ESP = 'Importe retenci�n por IRPF';
            Description = 'QB 1.00 - QB22111';
            AutoFormatType = 1;


        }
        field(7207274; "Piecework Nº"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework N�', ESP = 'N� unidad de obra';
            Description = 'QB 1.00 - QB2516';
            Editable = false;


        }
        field(7207283; "QW Not apply Withholding GE"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'Aplicar retenci�n por B.E.';
            Description = 'QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci�n por Buena Ejecuci�n a la linea';


        }
        field(7207284; "QW Not apply Withholding PIT"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'Aplicar retenci�n por IRPF';
            Description = 'QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci�n por IRPF a la l�nea';


        }
        field(7207285; "QW Base Withholding by GE"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by G.E', ESP = 'Base ret. B.E.';
            Description = 'QB 1.00 - JAV 11/08/19: - Base de c�lculo de la retenci�n por B.E.';
            Editable = false;


        }
        field(7207286; "QW Base Withholding by PIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by PIT', ESP = 'Base ret. IRPF';
            Description = 'QB 1.00 - JAV 11/08/19: - Base de c�lculo de la retenci�n por IRPF';
            Editable = false;


        }
        field(7207287; "QW Withholding by GE Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'L�nea de retenci�n de B.E.';
            Description = 'QB 1.00 - JAV 18/08/19: - Si es la l�nea donde se calcula la retenci�n por Buena Ejecuci�n';


        }
        field(7207300; "QB Recurrent Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'L�nea Recurrente';
            Description = 'QB 1.08.41 JAV 04/05/21 Indica si la l�nea es recurrente, si no es de la proforma';
            Editable = false;


        }
        field(7207301; "QB Discount Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'L�nea de descuento en proforma';
            Description = 'QB 1.08.41 - JAV 04/05/21 Si es la l�nea de descuento de la proforma';


        }
        field(7207306; "Filter Document No."; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ESP = 'Filtro N�. Documento';


        }
        field(7207307; "QB Qty Received Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cnt. Recibida a Origen';
            Description = 'QB 1.08.41 Cantidad recibida en el momento de crear la proforma';
            Editable = false;


        }
        field(7207308; "QB Qty. Proformed Origin"; Decimal)
        {
            CaptionML = ESP = 'Cnt. Proformas a Origen';
            Description = 'QB 1.08.44 Cantidad proformada a origen';
            Editable = false;


        }
        field(7207309; "QB Qty. In Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Quantity" WHERE("Document Type" = CONST("Order"),
                                                                                                      "Document No." = FIELD("Order No."),
                                                                                                      "Line No." = FIELD("Order Line No.")));
            CaptionML = ESP = 'Cnt. en Pedido/Contrato';
            Description = 'QB 1.08.41 Cantidad en el pedido';
            Editable = false;


        }
        field(7207313; "QB Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato Marco';
            Description = 'QB 1.06.20 - N� Contrato Marco';
            Editable = false;


        }
        field(7207314; "QB Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� L�nea del Contrato Marco';
            Description = 'QB 1.08.18 - N� de l�nea del Contrato Marco';
            Editable = false;


        }
        field(7207323; "QB Proform Amount Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe a Origen';
            Description = 'QB 1.09.09 - JAV 20/07/21 Importe facturado de la l�nea';
            Editable = false;


        }
        field(7207324; "QB Proform Amount Received"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Im.Recibido a Origen';
            Description = 'QB 1.09.09 - JAV 20/07/21 Importe facturado de la l�nea';
            Editable = false;


        }
        field(7207325; "QB Proform Amount Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Facturado';
            Description = 'QB 1.09.09 - JAV 20/07/21 Importe facturado de la l�nea';
            Editable = false;


        }
        field(7207326; "QB tmp Proform Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.08.43 - Para el report agrupado';


        }
        field(7207327; "QB tmp Proform Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.08.43 - Para el report agrupado';


        }
        field(7207328; "QB tmp Proform Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.08.43 - Para el report agrupado';


        }
        field(7207329; "QB tmp Proform Amount Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.08.43 - Para el report agrupado';


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(key2; "Order No.", "Order Line No.", "Posting Date")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       Currency@1005 :
        Currency: Record 4;
        //       QBProformHeader@1100286000 :
        QBProformHeader: Record 7206960;
        //       QBProformLine@1004 :
        QBProformLine: Record 7206961;
        //       QBProform@1100286004 :
        QBProform: Codeunit 7207345;
        //       DimMgt@1003 :
        DimMgt: Codeunit "DimensionManagement";
        //       CurrencyRead@1002 :
        CurrencyRead: Boolean;
        //       Text000@1100286001 :
        Text000: TextConst ESP = 'No puede generar proforma por mas de %1';
        //       NewOrigin@1100286002 :
        NewOrigin: Decimal;
        //       Text001@1100286003 :
        Text001: TextConst ESP = 'No pude generar proforma a origen en negativo.';




    trigger OnDelete();
    var
        //                PurchDocLineComments@1000 :
        PurchDocLineComments: Record 43;
    begin
        if (not "QB Recurrent Line") then
            ERROR('Solo puede eliminar l�neas recurrentes');
    end;



    procedure GetCurrencyCodeFromHeader(): Code[10];
    begin
        if "Document No." = QBProformHeader."No." then
            exit(QBProformHeader."Currency Code");
        if QBProformHeader.GET("Document No.") then
            exit(QBProformHeader."Currency Code");
        exit('');
    end;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;


    procedure ShowLineComments()
    var
        //       PurchCommentLine@1002 :
        PurchCommentLine: Record 43;
        PurchCommentLineDocumentType: Option;
    begin
        PurchCommentLineDocumentType := ConvertDocumentTypeToOption(PurchCommentLine."Document Type"::Receipt);
        //PurchCommentLine.ShowComments(PurchCommentLine."Document Type"::Receipt, "Document No.", "Line No.");
        PurchCommentLine.ShowComments(PurchCommentLineDocumentType, "Document No.", "Line No.");
    end;

    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Purchase Comment Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Receipt","Posted Invoice","Posted Credit Memo","Posted Return Shipment";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            DocumentType::"Receipt":
                optionValue := optionValue::"Receipt";
            DocumentType::"Posted Invoice":
                optionValue := optionValue::"Posted Invoice";
            DocumentType::"Posted Credit Memo":
                optionValue := optionValue::"Posted Credit Memo";
            DocumentType::"Posted Return Shipment":
                optionValue := optionValue::"Posted Return Shipment";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNumber@1000 :
    LOCAL procedure GetFieldCaption(FieldNumber: Integer): Text[100];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Purch. Rcpt. Line", FieldNumber);
        exit(Field."Field Caption");
    end;


    //     procedure GetCaptionClass (FieldNumber@1000 :
    procedure GetCaptionClass(FieldNumber: Integer): Text[80];
    begin
        CASE FieldNumber OF
            FIELDNO("No."):
                exit(STRSUBSTNO('3,%1', GetFieldCaption(FieldNumber)));
        end;
    end;

    procedure CalculateAmounts()
    begin
        //JAV 20/07/21: - QB 1.09.10 Calculo de los importes de la l�nea
        Currency.InitRoundingPrecision;
        Amount := ROUND(Quantity * "Direct Unit Cost" * (100 - "Line Discount %") / 100, Currency."Amount Rounding Precision");
        "QB Proform Amount Origin" := ROUND("QB Qty. Proformed Origin" * "Direct Unit Cost" * (100 - "Line Discount %") / 100, Currency."Amount Rounding Precision");
        "QB Proform Amount Received" := ROUND("QB Qty Received Origin" * "Direct Unit Cost" * (100 - "Line Discount %") / 100, Currency."Amount Rounding Precision");
        "QB Proform Amount Invoiced" := ROUND("Quantity Invoiced" * "Direct Unit Cost" * (100 - "Line Discount %") / 100, Currency."Amount Rounding Precision");
    end;

    LOCAL procedure IsEditable()
    begin
        //JAV 20/07/21: - QB 1.09.10 Si estamos en este campo y cambiamos el estado, no se pone autom�ticamente como no editable
        QBProformHeader.GET("Document No.");
        if (QBProformHeader.Validated) or (QBProformHeader."Invoice No." <> '') then
            ERROR('L�nea no editable');
    end;

    /*begin
    //{
//      JAV 06/07/19: - Se a�ade el campo 7207291 "Canceled" que indica si se ha cancelado la l�nea
//      JAV 23/10/19: - Se eliminan llamandas a c�lculos de retenciones que ya no se usan
//      JAV 20/07/21: - QB 1.09.10 Se eliminan funciones no usadas, se a�aden campos de totales y una funci�n para el calculo de los importes de la l�nea
//      AML 03/07/23: - Q19675 Creado campo 63
//      OJO EN MERGE QB. --------- BS::18286 CSM 30/01/23 - Fri y proforma por l�neas de medici�n.  Nuevos campos Bonif.Sol.:
//                                            50000 Prod. Measure Header No.      (N� Cab. Relaci�n Valorada)
//                                            50001 Prod. Measure Header Line No. (N� l�nea Relaci�n Valorada)
//                                            50002From Measure(Viene de la medici�n)
//                                            50003Measure Source(Medici�n origen)
//                                            63  Receipt No.  (N� albar�n compra)
//                                            AML RESPETAMOS LA NUMERACION 50000 PERO NO DEBERIA SER CON ESA NUMERACI�N.
//    }
    end.
  */
}








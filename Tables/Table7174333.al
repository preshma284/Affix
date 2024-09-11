table 7174333 "QBU SII Documents"
{



    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = " ","FE","FR","OS","CM","BI","OI","CE","PR","NO";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo Documento';
            OptionCaptionML = ENU = '" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Metalico,Fact. Bienes Inv.,Fact. Op. Intracomunitaria,Cobro Factura,Pago Factura,No Subir"', ESP = '" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Met�lico,Factura Bienes Inversi�n,Factura Op. Intracomunitaria,Cobro Factura Emitida,Pago Factura Recibida,No Subir"';

            Description = 'Key 1';


        }
        field(2; "Document No."; Code[60])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'N� Documento Externo';
            Description = 'Key 2    --> Este campo contiene el n�mero del proveedor para compras y el de documento para ventas';


        }
        field(3; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha Registro';
            Description = 'Key 4';


        }
        field(4; "Year"; Integer)
        {
            CaptionML = ENU = 'Year', ESP = 'A�o';


        }
        field(5; "Period"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("Period"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'Period', ESP = 'Periodo';


        }
        field(6; "Invoice Amount"; Decimal)
        {
            CaptionML = ENU = 'Invoice Amount', ESP = 'Importe Total';


        }
        field(7; "Cust/Vendor Name"; Text[50])
        {
            CaptionML = ENU = 'Cust/Vendor Name', ESP = 'Nombre Cliente/Proveedor';


        }
        field(8; "VAT Registration No."; Code[20])
        {
            CaptionML = ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
            Description = 'Key 3';


        }
        field(9; "Cust/Vendor No."; Code[20])
        {
            TableRelation = IF ("Document Type" = FILTER('FE' | 'OS' | 'CM' | 'BI' | 'OI' | 'CE')) Customer."No." ELSE IF ("Document Type" = FILTER('FR' | 'OI' | 'PR')) Vendor."No.";
            CaptionML = ENU = 'Cust/Vendor No.', ESP = 'N� Cliente/Proveedor';


        }
        field(10; "Invoice Type"; Code[10])
        {
            TableRelation = IF ("Document Type" = CONST("FE")) "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"), "SII Entity" = FIELD("SII Entity")) ELSE IF ("Document Type" = CONST("FR")) "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"), "SII Entity" = FIELD("SII Entity")) ELSE IF ("Document Type" = CONST("OI")) "SII Type List Value"."Code" WHERE("Type" = CONST("OpKey"), "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.99.999.begin 
                IF "Invoice Type" <> '' THEN
                    VALIDATE("Invoice Type Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::SalesInvType, "Invoice Type"))
                ELSE
                    VALIDATE("Invoice Type Name", '');
                //QuoSII_1.4.99.999.end
            END;


        }
        field(11; "Special Regime"; Code[20])
        {
            TableRelation = IF ("Document Type" = CONST("FE")) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("SII Entity")) ELSE IF ("Document Type" = CONST("FR")) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"), "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Special Regime', ESP = 'R�gimen Especial';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.99.999.begin 
                IF "Special Regime" <> '' THEN
                    //JAV 16/03/22: - QuoSII 1.06.04 Sacaba siempre el tipo para ventas sin mirar si eran compras
                    IF (GetType = UseIn::Sales) THEN
                        VALIDATE("Special Regime Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::KeySpecialSalesInv, "Special Regime"))
                    ELSE
                        VALIDATE("Special Regime Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::KeySpecialPurchInv, "Special Regime"))
                ELSE
                    VALIDATE("Special Regime Name", '');
                //QuoSII_1.4.99.999.end
            END;


        }
        field(12; "Description Operation 1"; Text[250])
        {
            CaptionML = ENU = 'Description Operation 1', ESP = 'Descripción Operaci�n 1';


        }
        field(13; "Description Operation 2"; Text[250])
        {
            CaptionML = ENU = 'Descripti�n Operati�n 2', ESP = 'Descripción Operaci�n 2';


        }
        field(14; "Third Party"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("ThirdParty"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Third Party', ESP = 'Emitida Tercero';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.99.999.begin 
                IF "Third Party" <> '' THEN
                    VALIDATE("Third Party Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::ThirdParty, "Third Party"))
                ELSE
                    VALIDATE("Third Party Name", '');
                //QuoSII_1.4.99.999.end
            END;


        }
        field(15; "CrMemo Type"; Code[20])
        {
            TableRelation = IF ("Invoice Type" = FILTER('R1' | 'R2' | 'R3' | 'R4' | 'R5')) "SII Type List Value"."Code" WHERE("Type" = CONST("CorrectedInvType"),
                                                                                                                                            "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Cr.Memo Type', ESP = 'Tipo Rectificativa';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.99.999.begin 
                IF "CrMemo Type" <> '' THEN
                    VALIDATE("Cr.Memo Type Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::CorrectedInvType, "CrMemo Type"))
                ELSE
                    VALIDATE("Cr.Memo Type Name", '');
                //QuoSII_1.4.99.999.end
            END;


        }
        field(16; "No. Sends Includes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("SII Document Shipment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                         "Document No." = FIELD("Document No."),
                                                                                                         "VAT Registration No." = FIELD("VAT Registration No."),
                                                                                                         "Posting Date" = FIELD("Posting Date"),
                                                                                                         "Entry No." = FIELD("Entry No."),
                                                                                                         "Register Type" = FIELD("Register Type")));


            CaptionML = ENU = 'Included in a Send', ESP = 'N� Env�os en que se incluye';
            Description = 'QuoSII 1.5r  JAV 01/06/21 Se cambia el flowflied para que sea un COUNT y se pueda navegar a donde se ha incluido el documento';
            Editable = false;

            trigger OnLookup();
            BEGIN
                //JAV 01/06/21 Navegar a los env�os en los que est� incluido el documento
                SIIDocumentShipmentLine.RESET;
                SIIDocumentShipmentLine.SETRANGE("Document No.", "Document No.");
                SIIDocumentShipmentLine.SETRANGE("VAT Registration No.", "VAT Registration No.");
                SIIDocumentShipmentLine.SETRANGE("Posting Date", "Posting Date");
                SIIDocumentShipmentLine.SETRANGE("Entry No.", "Entry No.");
                SIIDocumentShipmentLine.SETRANGE("Register Type", "Register Type");
                IF NOT SIIDocumentShipmentLine.ISEMPTY THEN BEGIN
                    CLEAR(SIIDocumentShipLine);
                    SIIDocumentShipLine.SETTABLEVIEW(SIIDocumentShipmentLine);
                    SIIDocumentShipLine.RUNMODAL;
                END;
            END;


        }
        field(17; "Cr.Memo Type Name"; Text[250])
        {
            CaptionML = ENU = 'Cr.Memo Type Name', ESP = 'Desc Tipo Rectificativa';


        }
        field(18; "Period Name"; Text[250])
        {


            CaptionML = ENU = 'Period Name', ESP = 'Desc Periodo';

            trigger OnValidate();
            BEGIN
                VALIDATE(Period, SIITypeListValue.GetDocumentType("Period Name"));
            END;


        }
        field(19; "Invoice Type Name"; Text[250])
        {
            CaptionML = ENU = 'Invoice Type Name', ESP = 'Desc Tipo Factura';


        }
        field(20; "Special Regime Name"; Text[250])
        {
            CaptionML = ENU = 'Special Regime Name', ESP = 'Desc Regimen Especial';


        }
        field(21; "Third Party Name"; Text[250])
        {
            CaptionML = ENU = 'Third Party Name', ESP = 'Desc Emitida Tercero';


        }
        field(22; "Shipment Status"; Option)
        {
            OptionMembers = " ","Pendiente","Enviado","No Enviado","Anulada","Modificada";
            FieldClass = FlowField;
            CalcFormula = Lookup("SII Document Shipment Line"."Status" WHERE("Document No." = FIELD("Document No."),
                                                                                                                 "Document Type" = FIELD("Document Type"),
                                                                                                                 "Entry No." = FIELD("Entry No."),
                                                                                                                 "Register Type" = FIELD("Register Type")));
            CaptionML = ENU = 'Shipment Status', ESP = 'Estado Envio';

            Editable = false;


        }
        field(23; "AEAT Status"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("ShipStatus"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'AEAT Status', ESP = 'Estado AEAT';


        }
        field(24; "Special Regime 1"; Code[20])
        {
            TableRelation = IF ("Document Type" = CONST("FE")) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("SII Entity")) ELSE IF ("Document Type" = CONST("FR")) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"), "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Special Regime 1', ESP = 'R�gimen Especial 1';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.99.999.begin 
                IF "Special Regime 1" <> '' THEN
                    //JAV 16/03/22: - QuoSII 1.06.04 Sacaba siempre el tipo para ventas sin mirar si eran compras
                    IF (GetType = UseIn::Sales) THEN
                        VALIDATE("Special Regime 1 Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::KeySpecialSalesInv, "Special Regime 1"))
                    ELSE
                        VALIDATE("Special Regime 1 Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::KeySpecialPurchInv, "Special Regime 1"))
                ELSE
                    VALIDATE("Special Regime 1 Name", '');
                //QuoSII_1.4.99.999.end
            END;


        }
        field(25; "Special Regime 2"; Code[20])
        {
            TableRelation = IF ("Document Type" = CONST("FE")) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("SII Entity")) ELSE IF ("Document Type" = CONST("FR")) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"), "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Special Regime 2', ESP = 'R�gimen Especial 2';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.99.999.begin 
                IF "Special Regime 2" <> '' THEN
                    //JAV 16/03/22: - QuoSII 1.06.03 Sacaba siempre el tipo para ventas sin mirar si eran compras
                    IF (GetType = UseIn::Sales) THEN
                        VALIDATE("Special Regime 2 Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::KeySpecialSalesInv, "Special Regime 2"))
                    ELSE
                        VALIDATE("Special Regime 2 Name", SIITypeListValue.GetDocumentName(SIITypeListValue.Type::KeySpecialPurchInv, "Special Regime 2"))
                ELSE
                    VALIDATE("Special Regime 2 Name", '');
                //QuoSII_1.4.99.999.end
            END;


        }
        field(26; "Special Regime 1 Name"; Text[250])
        {
            CaptionML = ENU = 'Special Regime Name', ESP = 'Desc Regimen Especial 1';
            Editable = false;


        }
        field(27; "Special Regime 2 Name"; Text[250])
        {
            CaptionML = ENU = 'Special Regime Name', ESP = 'Desc Regimen Especial 2';


        }
        field(28; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha de Expedici�n';


        }
        field(29; "Cupon"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("Cupon"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'Cupon', ESP = 'Cupon';


        }
        field(30; "VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("SII Document Line"."VAT Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                           "Document No." = FIELD("Document No."),
                                                                                                           "No Taxable VAT" = FILTER(false),
                                                                                                           "Exent" = FILTER(false),
                                                                                                           "VAT Registration No." = FIELD("VAT Registration No."),
                                                                                                           "Entry No." = FIELD("Entry No."),
                                                                                                           "Register Type" = FIELD("Register Type")));
            CaptionML = ENU = 'VAT Amount', ESP = 'Importe IVA';


        }
        field(31; "RE Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("SII Document Line"."RE Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                          "Document No." = FIELD("Document No."),
                                                                                                          "No Taxable VAT" = FILTER(false),
                                                                                                          "Exent" = FILTER(false),
                                                                                                          "VAT Registration No." = FIELD("VAT Registration No."),
                                                                                                          "Entry No." = FIELD("Entry No."),
                                                                                                          "Register Type" = FIELD("Register Type")));
            CaptionML = ENU = 'EC Amount', ESP = 'Importe RE';


        }
        field(32; "Medio Cobro/Pago"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PaymentMethod"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'Receivable/Payment Method', ESP = 'Medio Cobro/Pago';


        }
        field(33; "CuentaMedioCobro"; Text[34])
        {
            CaptionML = ENU = 'Receivable Methos Account', ESP = 'Cuenta Medio Cobro';


        }
        field(34; "Declarate Key UE"; Code[20])
        {
            TableRelation = IF ("Document Type" = CONST("OI")) "SII Type List Value"."Code" WHERE("Type" = CONST("IntraKey"),
                                                                                                                                "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'Declarate Key UE', ESP = 'Clave Declarado Intracomunitaria';


        }
        field(35; "Multiple Destination"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("MultipleDest"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'Multiple Destination', ESP = 'M�ltiple destinatarios';


        }
        field(36; "UE Country"; Code[10])
        {
            CaptionML = ENU = 'UE Country', ESP = 'Estado Miembro';


        }
        field(37; "UE Period"; Integer)
        {
            CaptionML = ENU = 'UE Period', ESP = 'Plazo Operaci�n';


        }
        field(38; "Bienes Description"; Text[40])
        {
            CaptionML = ENU = 'Possessions Description', ESP = 'Descripción Bienes';


        }
        field(39; "Operator Address"; Text[120])
        {
            CaptionML = ENU = 'Operator Address', ESP = 'Direcci�n Operador';


        }
        field(40; "Documentation/Invoice UE"; Text[150])
        {
            CaptionML = ENU = 'Documentation/Invoice UE', ESP = 'Documentaci�n/Facturas';


        }
        field(41; "Last Ticket No."; Code[20])
        {
            CaptionML = ENU = 'Last Ticket No.', ESP = '�ltimo N� Ticket';


        }
        field(42; "Shipping Date"; Date)
        {


            CaptionML = ENU = 'Shipping Date', ESP = 'Fecha de Operaci�n';

            trigger OnValidate();
            BEGIN
                //+BUG17266 <
                Year := DATE2DMY("Shipping Date", 3);
                Period := FORMAT(DATE2DMY("Shipping Date", 2));
                "Period Name" := SIIDocumentProcesing.GetTypeValueDescription(SIITypeListValue.Type::Period, Period);
                //+BUG17266 >
            END;


        }
        field(43; "Entry No."; Integer)
        {
            Description = 'Key 5';


        }
        field(44; "Incluido en Envio"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("SII Document Shipment Line" WHERE("Document No." = FIELD("Document No."),
                                                                                                         "Document Type" = FIELD("Document Type"),
                                                                                                         "VAT Registration No." = FIELD("VAT Registration No."),
                                                                                                         "Posting Date" = FIELD("Posting Date"),
                                                                                                         "Entry No." = FIELD("Entry No."),
                                                                                                         "Register Type" = FIELD("Register Type")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Cambiado por el campo 45';
            CaptionML = ENU = 'Shipment Included - Obsolete', ESP = 'Incluido en Envio - Obsoleto';
            Description = '### ELIMINAR ### no se usa';


        }
        field(45; "Is Emited"; Boolean)
        {
            CaptionML = ENU = 'In a Send', ESP = 'En un Env�o';


        }
        field(46; "FA ID"; Text[40])
        {
            CaptionML = ENU = 'FA ID', ESP = 'ID Bien';


        }
        field(47; "Start Date of use"; Date)
        {
            CaptionML = ENU = 'Start Date of use', ESP = 'Fecha inicio Utilizaci�n';


        }
        field(48; "Prorrata Anual definitiva"; Decimal)
        {
            CaptionML = ENU = 'Definitive annual share', ESP = 'Prorrata Anual definitiva';


        }
        field(49; "First Ticket No."; Code[20])
        {
            CaptionML = ENU = 'First Ticket No.', ESP = 'Primer N� Ticket';


        }
        field(50; "Tally Status"; Option)
        {
            OptionMembers = " ","Checked","Partially Checked","Not Checkeable","Not Checked","Check in Progress";
            CaptionML = ENU = 'Tally Status', ESP = 'Estado cuadre';
            OptionCaptionML = ENU = '" ,Checked,Partially Checked,Not Checkeable,Not Checked,Check in Progress"', ESP = '" ,Contrastada,Parcialmente contrastada,No contrastable,No contrastada,En proceso de contraste"';

            Description = 'QuoSII1.4.03';


        }
        field(51; "Base Imbalance"; Decimal)
        {
            CaptionML = ENU = 'Base Imbalance', ESP = 'Descuadre base';
            Description = 'QuoSII1.4.03';


        }
        field(52; "ISP Base Imbalance"; Decimal)
        {
            CaptionML = ENU = 'ISP Base Tally', ESP = 'Descuadre base ISP';
            Description = 'QuoSII1.4.03';


        }
        field(53; "Imbalance Fee"; Decimal)
        {
            CaptionML = ENU = 'Imbalance Fee', ESP = 'Descuadre cuota';
            Description = 'QuoSII1.4.03';


        }
        field(54; "Imbalance RE Fee"; Decimal)
        {
            CaptionML = ENU = 'Imbalance RE Fee', ESP = 'Descuadre cuota RE';
            Description = 'QuoSII1.4.03';


        }
        field(55; "Imbalance Amount"; Decimal)
        {
            CaptionML = ENU = 'Base Imbalance', ESP = 'Descuadre importe';
            Description = 'QuoSII1.4.03';


        }
        field(56; "Status"; Option)
        {
            OptionMembers = " ","Pendiente","Enviada","No enviada","Anulada","Modificada";
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = '" ,Pendiente,Enviada,No Enviada,Anulada,Modificada"', ESP = '" ,Pendiente,Enviada,No Enviada,Anulada,Modificada"';

            Description = 'QuoSII1.4.03';


        }
        field(57; "External Reference"; Code[60])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� Documento';
            Description = 'QuoSII1.4-2                 --> Este campo contiene el nro de documento interno de Business Central para compras y ventas';


        }
        field(58; "SII Auto Posting Date"; Date)
        {
            CaptionML = ENU = 'SII Auto Posting Date', ESP = 'SII Fecha Registro Auto';
            Description = 'QuoSII_1.3.03.006';


        }
        field(59; "SII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));
            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';


        }
        field(60; "Inv. Amount"; Decimal)
        {
            CaptionML = ENU = 'Inv. Amount', ESP = 'Importe factura';
            Description = 'QuoSII_1.4.03.043';


        }
        field(61; "Inv. Base Amount"; Decimal)
        {
            CaptionML = ENU = 'Inv. Base Amount', ESP = 'Importe base factura';
            Description = 'QuoSII_1.4.03.043';


        }
        field(62; "Inv. Share"; Decimal)
        {
            CaptionML = ENU = 'Inv. Share', ESP = 'Cuota factura';
            Description = 'QuoSII_1.4.03.043';


        }
        field(63; "Modified"; Boolean)
        {
            CaptionML = ENU = 'Modified', ESP = 'Modificado';
            Description = 'QuoSII_1.4.99.999';


        }
        field(64; "Register Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de Registro';
            Description = 'Key 6   QuoSII 1.05n';


        }
        field(65; "Last Shipment"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ultimo Env�o';
            Description = 'QuoSII1.5p';


        }
        field(66; "Last Shipment Environment"; Option)
        {
            OptionMembers = " ","REAL","PRUEBAS";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Environmet Type', ESP = 'Entorno �ltimo Env�o';
            OptionCaptionML = ESP = '" ,REAL,PRUEBAS"';

            Description = 'QuoSII1.5p';


        }
        field(70; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de Vencimiento';
            Description = 'QuoSII 1.06.12 Para facturas de Tracto sucecivo. Fecha de vencimiento';


        }
        field(71; "OTS Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tracto Sucesivo Procesado';
            Description = 'QuoSII 1.06.12 Para facturas de Tracto sucecivo. Si ya se han creado la factura y la cancelaci�n';


        }
        field(72; "OTS Type"; Option)
        {
            OptionMembers = " ","Creation","Cancelation";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tracto Sucesivo Factura o Cancelaci�n';
            OptionCaptionML = ENU = '" ,Creation,Cancelation"', ESP = '" ,Creaci�n,Cancelaci�n"';

            Description = 'QuoSII 1.06.12 Para facturas de Tracto sucecivo. Si este movimiento es de la creaci�n de la factura o de su cancelaci�n';


        }
        field(100; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';
            Description = 'QuoSII 1.5y';
            Editable = false;


        }
        field(101; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1),
                                                                                               "Blocked" = CONST(false));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            Description = 'QuoSII 1.5y';
            Editable = false;
            CaptionClass = '1,2,1';


        }
        field(102; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2),
                                                                                               "Blocked" = CONST(false));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            Description = 'QuoSII 1.5y';
            Editable = false;
            CaptionClass = '1,2,2';


        }
    }
    keys
    {
        key(key1; "Document Type", "Document No.", "VAT Registration No.", "Posting Date", "Entry No.", "Register Type")
        {
            Clustered = true;
        }
        key(key2; "Document Type", "Is Emited")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       SIIDocuments@1100286004 :
        SIIDocuments: Record 7174333;
        //       SIIDocumentLine@80000 :
        SIIDocumentLine: Record 7174334;
        //       SIITypeListValue@80001 :
        SIITypeListValue: Record 7174331;
        //       SIIDocumentProcesing@1100286000 :
        SIIDocumentProcesing: Codeunit 7174333;
        //       SIIDocumentShipmentLine@1100286001 :
        SIIDocumentShipmentLine: Record 7174336;
        //       SIIDocumentShipLine@1100286002 :
        SIIDocumentShipLine: Page 7174335;
        //       UseIn@1100286003 :
        UseIn: Option "Sales","Purchases","NoDefinido";



    trigger OnDelete();
    begin
        if ("Is Emited") then
            ERROR('Factura ya subida, no se puede eliminar');

        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No."); //+BUG17265
        SIIDocumentLine.SETRANGE("Register Type", "Register Type"); //JAV
        SIIDocumentLine.DELETEALL;

        //JAV 08/09/22: - QuoSII 1.06.12 Se a�ade c�digo en el On Delete para borrar factura y cancelaci�n juntas, y no dejar la emisi�n si se han generado las otras
        if ("OTS Processed") then
            ERROR('No puede eliminar este documento, ya ha generado la factura y la cancelaci�n de la operaci�n de Tracto Sucesivo');

        if ("OTS Type" <> "OTS Type"::" ") then begin
            SIIDocuments.RESET;
            SIIDocuments.SETRANGE("Document Type", Rec."Document Type");
            SIIDocuments.SETRANGE("Document No.", Rec."Document No.");
            SIIDocuments.SETRANGE("VAT Registration No.", Rec."VAT Registration No.");
            SIIDocuments.SETRANGE("Posting Date", Rec."Posting Date");
            SIIDocuments.SETRANGE("Entry No.", Rec."Entry No.");
            SIIDocuments.SETFILTER("OTS Type", '<>%1', "OTS Type"::" ");
            SIIDocuments.SETFILTER("Register Type", '<>%1', Rec."Register Type");
            if SIIDocuments.FINDFIRST then begin
                SIIDocuments.DELETE(FALSE);

                SIIDocumentLine.RESET;
                SIIDocumentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
                SIIDocumentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
                SIIDocumentLine.SETRANGE("Entry No.", SIIDocuments."Entry No."); //+BUG17265
                SIIDocumentLine.SETRANGE("Register Type", SIIDocuments."Register Type"); //JAV
                SIIDocumentLine.DELETEALL;
            end;

            SIIDocuments.RESET;
            SIIDocuments.SETRANGE("Document Type", Rec."Document Type");
            SIIDocuments.SETRANGE("Document No.", Rec."Document No.");
            SIIDocuments.SETRANGE("VAT Registration No.", Rec."VAT Registration No.");
            SIIDocuments.SETRANGE("Entry No.", Rec."Entry No.");
            SIIDocuments.SETRANGE("OTS Processed", TRUE);
            if SIIDocuments.FINDFIRST then begin
                SIIDocuments."OTS Processed" := FALSE;
                SIIDocuments.MODIFY;
            end;
        end;
    end;



    // procedure AddData (NewRegister@1100286000 :
    procedure AddData(NewRegister: Boolean)
    var
        //       PurchInvHeader@1100286005 :
        PurchInvHeader: Record 122;
        //       SalesInvoiceHeader@1100286004 :
        SalesInvoiceHeader: Record 112;
        //       PurchCrMemoHdr@1100286003 :
        PurchCrMemoHdr: Record 124;
        //       SalesCrMemoHeader@1100286002 :
        SalesCrMemoHeader: Record 114;
        //       find@1100286001 :
        find: Boolean;
        //       DocNo@1100286006 :
        DocNo: Code[20];
    begin
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 29/07/21: - QuoSII 1.5y Se a�aden los campos Job y Departamento al registro
        //              - QuoSII 1.5z Se usa la dimensi�n asociada al proyecto para no depender de campos fuera del est�ndar
        //PSM 15/10/21: - QuoSII 1.06.01 Se cambia el orden de b�squeda, primero compras y luego ventas, ya que en compras el documento externo tiene mas longitud
        //----------------------------------------------------------------------------------------------------------------------------------

        if (Rec."Job No." = '') and (Rec."Shortcut Dimension 1 Code" = '') then begin
            find := FALSE;

            //Documentos de compra
            if (not find) then begin
                DocNo := COPYSTR(Rec."External Reference", 1, MAXSTRLEN(DocNo));
                if PurchInvHeader.GET(DocNo) then begin                            //Miro si es factura de compra
                    Rec."Job No." := GetDimValue(PurchInvHeader."Dimension Set ID");                    //Uso de valor de dimensi�n
                    Rec."Shortcut Dimension 1 Code" := PurchInvHeader."Shortcut Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := PurchInvHeader."Shortcut Dimension 2 Code";
                    find := TRUE;
                end else if PurchCrMemoHdr.GET(DocNo) then begin                   //Miro si es abono de compra
                    Rec."Job No." := GetDimValue(PurchCrMemoHdr."Dimension Set ID");                    //Uso de valor de dimensi�n
                    Rec."Shortcut Dimension 1 Code" := PurchCrMemoHdr."Shortcut Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := PurchCrMemoHdr."Shortcut Dimension 2 Code";
                    find := TRUE;
                end;
            end;

            //Documentos de venta
            if (not find) then begin
                DocNo := COPYSTR(Rec."Document No.", 1, MAXSTRLEN(DocNo));
                if SalesInvoiceHeader.GET(DocNo) then begin                     //Miro si es factura de venta
                    Rec."Job No." := GetDimValue(SalesInvoiceHeader."Dimension Set ID");                //Uso de valor de dimensi�n
                    Rec."Shortcut Dimension 1 Code" := SalesInvoiceHeader."Shortcut Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := SalesInvoiceHeader."Shortcut Dimension 2 Code";
                    find := TRUE;
                end else if SalesCrMemoHeader.GET(DocNo) then begin                      //Miro si es abono de venta
                    Rec."Job No." := GetDimValue(SalesCrMemoHeader."Dimension Set ID");                 //Uso de valor de dimensi�n
                    Rec."Shortcut Dimension 1 Code" := SalesCrMemoHeader."Shortcut Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := SalesCrMemoHeader."Shortcut Dimension 2 Code";
                    find := TRUE;
                end;
            end;
            //RE16081-LCG-12012022-INI
            //  if (find) then Deber�a guardarse sin modificar. Se quita para no ejecutar commit.
            //    Rec.MODIFY(FALSE); //Para evitar referencia circular
            //RE16081-LCG-12012022-FIN
        end;
    end;

    //     LOCAL procedure GetDimValue (pDimID@1100286002 :
    LOCAL procedure GetDimValue(pDimID: Integer): Code[20];
    var
        //       SIISetUp@1100286000 :
        SIISetUp: Record 79;
        //       DimensionSetEntry@1100286001 :
        DimensionSetEntry: Record 480;
    begin
        //----------------------------------------------------------------------------------------------------------------------------------
        //JAV 29/07/21: - QuoSII 1.5z Retorna la dimensi�n asociada al proyecto para no depender de campos fuera del est�ndar
        //----------------------------------------------------------------------------------------------------------------------------------
        SIISetUp.GET();

        DimensionSetEntry.RESET;
        DimensionSetEntry.SETRANGE("Dimension Set ID", pDimID);
        DimensionSetEntry.SETRANGE("Dimension Code", SIISetUp."QuoSII Dimension Job");
        if DimensionSetEntry.FINDFIRST then
            exit(DimensionSetEntry."Dimension Value Code")
        else
            exit('');
    end;

    //     procedure ImportRequestResponse (textXML@1100286000 :
    procedure ImportRequestResponse(textXML: Text)
    var
        //       QUOSIIDocumentError@1100286001 :
        QUOSIIDocumentError: Record 7174332;
        //       XMLBuffer@1100286002 :
        XMLBuffer: Record 1235;
        //       DocumentType@1100286003 :
        DocumentType: Option " ","FE","FR","OS","CM","BI","OI","CE","PR";
        //       txt@1100286004 :
        txt: Text;
        //       EstadoEnvio@1100286005 :
        EstadoEnvio: Text;
        //       RespuestaLinea@1100286006 :
        RespuestaLinea: Text;
        //       NumSerieFacturaEmisor@1100286007 :
        NumSerieFacturaEmisor: Text;
        //       FechaExpedicionFacturaEmisor@1100286008 :
        FechaExpedicionFacturaEmisor: Text;
        //       RefExterna@1100286009 :
        RefExterna: Text;
        //       EstadoRegistro@1100286010 :
        EstadoRegistro: Text;
        //       EstadoCuadre@1100286011 :
        EstadoCuadre: Text;
        //       ErrorCode@1100286012 :
        ErrorCode: Text;
        //       DocumentCSV@1100286013 :
        DocumentCSV: Text;
        //       ResultadoConsulta@1100286014 :
        ResultadoConsulta: Text;
        //       DescripcionErrorRegistro@1100286015 :
        DescripcionErrorRegistro: Text;
        //       txtImporteBase@1100286016 :
        txtImporteBase: Text;
        //       txtImporteCuota@1100286017 :
        txtImporteCuota: Text;
        //       txtImporteRE@1100286018 :
        txtImporteRE: Text;
        //       txtDescuadreImporteBase@1100286019 :
        txtDescuadreImporteBase: Text;
        //       txtDescuadreImporteCuota@1100286020 :
        txtDescuadreImporteCuota: Text;
        //       txtDescuadreImporteRE@1100286021 :
        txtDescuadreImporteRE: Text;
        //       txtDescuadreImporteTotal@1100286022 :
        txtDescuadreImporteTotal: Text;
        //       txtDescuadreBaseImponibleISP@1100286023 :
        txtDescuadreBaseImponibleISP: Text;
        //       VATRegistrationNo@1100286024 :
        VATRegistrationNo: Code[20];
        //       PostingDate@1100286025 :
        PostingDate: Date;
        //       EntryNo@1100286026 :
        EntryNo: Integer;
        //       tmpImporte@1100286027 :
        tmpImporte: Decimal;
        //       ImporteBase@1100286028 :
        ImporteBase: Decimal;
        //       ImporteCuota@1100286029 :
        ImporteCuota: Decimal;
        //       ImporteRE@1100286030 :
        ImporteRE: Decimal;
        //       DescuadreImporteBase@1100286031 :
        DescuadreImporteBase: Decimal;
        //       DescuadreImporteCuota@1100286032 :
        DescuadreImporteCuota: Decimal;
        //       DescuadreImporteRE@1100286033 :
        DescuadreImporteRE: Decimal;
        //       DescuadreImporteTotal@1100286034 :
        DescuadreImporteTotal: Decimal;
        //       DescuadreBaseImponibleISP@1100286035 :
        DescuadreBaseImponibleISP: Decimal;
        //       intEstadoCuadre@1100286036 :
        intEstadoCuadre: Integer;
    begin
        if STRPOS(textXML, '<siiLRRC:RespuestaConsultaLRFacturasEmitidas') <> 0 then begin
            DocumentType := DocumentType::FE;

            ResultadoConsulta := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:ResultadoConsulta>'), STRPOS(textXML, '</siiLRRC:ResultadoConsulta>') - STRPOS(textXML, '<siiLRRC:ResultadoConsulta>'));
            ResultadoConsulta := DELSTR(ResultadoConsulta, STRPOS(ResultadoConsulta, '<siiLRRC:ResultadoConsulta>'), STRLEN('<siiLRRC:ResultadoConsulta>'));
            if ResultadoConsulta = 'ConDatos' then begin
                RespuestaLinea := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:TipoDesglose>'), STRPOS(textXML, '</siiLRRC:TipoDesglose>') - STRPOS(textXML, '<siiLRRC:TipoDesglose>'));
                WHILE RespuestaLinea <> '' DO begin
                    RespuestaLinea := DELSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<siiLRRC:TipoDesglose>'), STRLEN('<siiLRRC:TipoDesglose>'));

                    if STRPOS(RespuestaLinea, '<sii:ImporteTAIReglasLocalizacion>') <> 0 then begin
                        txtImporteBase := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:ImporteTAIReglasLocalizacion>'),
                                                  STRPOS(RespuestaLinea, '</sii:ImporteTAIReglasLocalizacion>') - STRPOS(RespuestaLinea, '<sii:ImporteTAIReglasLocalizacion>'));
                        txtImporteBase := DELSTR(txtImporteBase, STRPOS(txtImporteBase, '<sii:ImporteTAIReglasLocalizacion>'), STRLEN('<sii:ImporteTAIReglasLocalizacion>'));
                        EVALUATE(tmpImporte, txtImporteBase);
                        ImporteBase += tmpImporte;
                    end;

                    if STRPOS(RespuestaLinea, '<sii:ImportePorArticulos7_14_Otros>') <> 0 then begin
                        txtImporteBase := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:ImportePorArticulos7_14_Otros>'),
                                                  STRPOS(RespuestaLinea, '</sii:ImportePorArticulos7_14_Otros>') - STRPOS(RespuestaLinea, '<sii:ImportePorArticulos7_14_Otros>'));
                        txtImporteBase := DELSTR(txtImporteBase, STRPOS(txtImporteBase, '<sii:ImportePorArticulos7_14_Otros>'), STRLEN('<sii:ImportePorArticulos7_14_Otros>'));
                        EVALUATE(tmpImporte, txtImporteBase);
                        ImporteBase += tmpImporte;
                    end;

                    if STRPOS(RespuestaLinea, '<sii:BaseImponible>') <> 0 then begin
                        txtImporteCuota := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:BaseImponible>'), STRPOS(RespuestaLinea, '</sii:BaseImponible>') - STRPOS(RespuestaLinea, '<sii:BaseImponible>'));
                        txtImporteCuota := DELSTR(txtImporteCuota, STRPOS(txtImporteCuota, '<sii:BaseImponible>'), STRLEN('<sii:BaseImponible>'));
                        EVALUATE(tmpImporte, txtImporteCuota);
                        ImporteBase += tmpImporte;
                    end;

                    if STRPOS(RespuestaLinea, '<sii:CuotaRepercutida>') <> 0 then begin
                        txtImporteCuota := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:CuotaRepercutida>'), STRPOS(RespuestaLinea, '</sii:CuotaRepercutida>') - STRPOS(RespuestaLinea, '<sii:CuotaRepercutida>'));
                        txtImporteCuota := DELSTR(txtImporteCuota, STRPOS(txtImporteCuota, '<sii:CuotaRepercutida>'), STRLEN('<sii:CuotaRepercutida>'));
                        EVALUATE(tmpImporte, txtImporteCuota);
                        ImporteCuota += tmpImporte;
                    end;

                    if STRPOS(RespuestaLinea, '<sii:CuotaRecargoEquivalencia>') <> 0 then begin
                        txtImporteRE := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:CuotaRecargoEquivalencia>'),
                                                STRPOS(RespuestaLinea, '</sii:CuotaRecargoEquivalencia>') - STRPOS(RespuestaLinea, '<sii:CuotaRecargoEquivalencia>'));
                        txtImporteRE := DELSTR(txtImporteRE, STRPOS(txtImporteRE, '<sii:CuotaRecargoEquivalencia>'), STRLEN('<sii:CuotaRecargoEquivalencia>'));
                        EVALUATE(tmpImporte, txtImporteRE);
                        ImporteRE += tmpImporte;
                    end;

                    textXML := DELSTR(textXML, 1, STRPOS(textXML, '</siiLRRC:TipoDesglose>'));
                    if (STRPOS(textXML, '<siiLRRC:TipoDesglose>') = 0) or (STRPOS(textXML, '</siiLRRC:TipoDesglose>') = 0) then
                        RespuestaLinea := ''
                    else
                        RespuestaLinea := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:TipoDesglose>'), STRPOS(textXML, '</siiLRRC:TipoDesglose>') - STRPOS(textXML, '<siiLRRC:TipoDesglose>'));
                end;

                EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));
                WHILE EstadoEnvio <> '' DO begin
                    EstadoEnvio := DELSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoFactura>'), STRLEN('<siiLRRC:EstadoFactura>'));

                    EstadoCuadre := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoCuadre>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'));
                    EstadoCuadre := DELSTR(EstadoCuadre, STRPOS(EstadoCuadre, '<siiLRRC:EstadoCuadre>'), STRLEN('<siiLRRC:EstadoCuadre>'));
                    EVALUATE(intEstadoCuadre, EstadoCuadre);

                    EstadoRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'));
                    EstadoRegistro := DELSTR(EstadoRegistro, STRPOS(EstadoRegistro, '<siiLRRC:EstadoRegistro>'), STRLEN('<siiLRRC:EstadoRegistro>'));

                    if STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>') <> 0 then begin
                        ErrorCode := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'), STRPOS(EstadoEnvio, '</siiLRRC:CodigoErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'));
                        ErrorCode := DELSTR(ErrorCode, STRPOS(ErrorCode, '<siiLRRC:CodigoErrorRegistro>'), STRLEN('<siiLRRC:CodigoErrorRegistro>'));
                    end;

                    if STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>') <> 0 then begin
                        DescripcionErrorRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'),
                                                            STRPOS(EstadoEnvio, '</siiLRRC:DescripcionErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'));
                        DescripcionErrorRegistro := DELSTR(DescripcionErrorRegistro, STRPOS(DescripcionErrorRegistro, '<siiLRRC:DescripcionErrorRegistro>'), STRLEN('<siiLRRC:DescripcionErrorRegistro>'));
                    end;

                    if STRPOS(EstadoEnvio, '<siiLRRC:DatosDescuadreContraparte>') <> 0 then begin
                        txtDescuadreImporteBase := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'), STRPOS(EstadoEnvio, '</sii:SumBaseImponible>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'));
                        txtDescuadreImporteBase := DELSTR(txtDescuadreImporteBase, STRPOS(txtDescuadreImporteBase, '<sii:SumBaseImponible>'), STRLEN('<sii:SumBaseImponible>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteBase);
                        DescuadreImporteBase += tmpImporte;

                        txtDescuadreImporteCuota := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuota>'), STRPOS(EstadoEnvio, '</sii:SumCuota>') - STRPOS(EstadoEnvio, '<sii:SumCuota>'));
                        txtDescuadreImporteCuota := DELSTR(txtDescuadreImporteCuota, STRPOS(txtDescuadreImporteCuota, '<sii:SumCuota>'), STRLEN('<sii:SumCuota>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteCuota);
                        DescuadreImporteCuota += tmpImporte;

                        txtDescuadreImporteRE := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'),
                                                         STRPOS(EstadoEnvio, '</sii:SumCuotaRecargoEquivalencia>') - STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'));
                        txtDescuadreImporteRE := DELSTR(txtDescuadreImporteRE, STRPOS(txtDescuadreImporteRE, '<sii:SumCuotaRecargoEquivalencia>'), STRLEN('<sii:SumCuotaRecargoEquivalencia>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteRE);
                        DescuadreImporteRE += tmpImporte;

                        txtDescuadreImporteTotal := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:ImporteTotal>'), STRPOS(EstadoEnvio, '</sii:ImporteTotal>') - STRPOS(EstadoEnvio, '<sii:ImporteTotal>'));
                        txtDescuadreImporteTotal := DELSTR(txtDescuadreImporteTotal, STRPOS(txtDescuadreImporteTotal, '<sii:ImporteTotal>'), STRLEN('<sii:ImporteTotal>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteTotal);
                        DescuadreImporteTotal += tmpImporte;

                        txtDescuadreBaseImponibleISP := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'),
                                                        STRPOS(EstadoEnvio, '</sii:SumBaseImponibleISP>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'));
                        txtDescuadreBaseImponibleISP := DELSTR(txtDescuadreBaseImponibleISP, STRPOS(txtDescuadreBaseImponibleISP, '<sii:SumBaseImponibleISP>'), STRLEN('<sii:SumBaseImponibleISP>'));
                        EVALUATE(tmpImporte, txtDescuadreBaseImponibleISP);
                        DescuadreBaseImponibleISP += tmpImporte;
                    end;

                    textXML := DELSTR(textXML, 1, STRPOS(textXML, '</siiLRRC:EstadoFactura>'));
                    if (STRPOS(textXML, '<siiLRRC:EstadoFactura>') = 0) or (STRPOS(textXML, '</siiLRRC:EstadoFactura>') = 0) then
                        EstadoEnvio := ''
                    else
                        EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));

                    if LOWERCASE(EstadoRegistro) = 'correcta' then
                        EstadoRegistro := 'Correcto'
                    else begin
                        if LOWERCASE(EstadoRegistro) = 'aceptadaconerrores' then
                            EstadoRegistro := 'AceptadoConErrores'
                    end;

                    Rec.VALIDATE("AEAT Status", EstadoRegistro);

                    "Shipment Status" := "Shipment Status"::Enviado;

                    "ISP Base Imbalance" := DescuadreBaseImponibleISP;
                    "Base Imbalance" := DescuadreImporteBase;
                    "Imbalance Fee" := DescuadreImporteCuota;
                    "Imbalance RE Fee" := DescuadreImporteRE;
                    "Imbalance Amount" := DescuadreImporteTotal;
                    "Tally Status" := intEstadoCuadre;

                    MODIFY;
                end;
            end
        end else begin
            if STRPOS(textXML, '<siiLRRC:RespuestaConsultaLRFacturasRecibidas') <> 0 then begin
                DocumentType := DocumentType::FR;

                ResultadoConsulta := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:ResultadoConsulta>'), STRPOS(textXML, '</siiLRRC:ResultadoConsulta>') - STRPOS(textXML, '<siiLRRC:ResultadoConsulta>'));
                ResultadoConsulta := DELSTR(ResultadoConsulta, STRPOS(ResultadoConsulta, '<siiLRRC:ResultadoConsulta>'), STRLEN('<siiLRRC:ResultadoConsulta>'));
                if ResultadoConsulta = 'ConDatos' then begin
                    RespuestaLinea := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:DesgloseFactura>'), STRPOS(textXML, '</siiLRRC:DesgloseFactura>') - STRPOS(textXML, '<siiLRRC:DesgloseFactura>'));
                    WHILE RespuestaLinea <> '' DO begin
                        RespuestaLinea := DELSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<siiLRRC:DesgloseFactura>'), STRLEN('<siiLRRC:DesgloseFactura>'));

                        if STRPOS(RespuestaLinea, '<sii:ImporteCompensacionREAGYP>') <> 0 then begin
                            txtImporteBase := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:ImporteCompensacionREAGYP>'),
                                                      STRPOS(RespuestaLinea, '</sii:ImporteCompensacionREAGYP>') - STRPOS(RespuestaLinea, '<sii:ImporteCompensacionREAGYP>'));
                            txtImporteBase := DELSTR(txtImporteBase, STRPOS(txtImporteBase, '<sii:ImporteCompensacionREAGYP>'), STRLEN('<sii:ImporteCompensacionREAGYP>'));
                            EVALUATE(tmpImporte, txtImporteBase);
                            ImporteBase += tmpImporte;
                        end;

                        if STRPOS(RespuestaLinea, '<sii:BaseImponible>') <> 0 then begin
                            txtImporteCuota := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:BaseImponible>'), STRPOS(RespuestaLinea, '</sii:BaseImponible>') - STRPOS(RespuestaLinea, '<sii:BaseImponible>'));
                            txtImporteCuota := DELSTR(txtImporteCuota, STRPOS(txtImporteCuota, '<sii:BaseImponible>'), STRLEN('<sii:BaseImponible>'));
                            EVALUATE(tmpImporte, txtImporteCuota);
                            ImporteBase += tmpImporte;
                        end;

                        if STRPOS(RespuestaLinea, '<sii:CuotaSoportada>') <> 0 then begin
                            txtImporteCuota := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:CuotaSoportada>'), STRPOS(RespuestaLinea, '</sii:CuotaSoportada>') - STRPOS(RespuestaLinea, '<sii:CuotaSoportada>'));
                            txtImporteCuota := DELSTR(txtImporteCuota, STRPOS(txtImporteCuota, '<sii:CuotaSoportada>'), STRLEN('<sii:CuotaSoportada>'));
                            EVALUATE(tmpImporte, txtImporteCuota);
                            ImporteCuota += tmpImporte;
                        end;

                        if STRPOS(RespuestaLinea, '<sii:CuotaRecargoEquivalencia>') <> 0 then begin
                            txtImporteRE := COPYSTR(RespuestaLinea, STRPOS(RespuestaLinea, '<sii:CuotaRecargoEquivalencia>'),
                                                    STRPOS(RespuestaLinea, '</sii:CuotaRecargoEquivalencia>') - STRPOS(RespuestaLinea, '<sii:CuotaRecargoEquivalencia>'));
                            txtImporteRE := DELSTR(txtImporteRE, STRPOS(txtImporteRE, '<sii:CuotaRecargoEquivalencia>'), STRLEN('<sii:CuotaRecargoEquivalencia>'));
                            EVALUATE(tmpImporte, txtImporteRE);
                            ImporteRE += tmpImporte;
                        end;

                        textXML := DELSTR(textXML, 1, STRPOS(textXML, '</siiLRRC:DesgloseFactura>'));
                        if (STRPOS(textXML, '<siiLRRC:DesgloseFactura>') = 0) or (STRPOS(textXML, '</siiLRRC:DesgloseFactura>') = 0) then
                            RespuestaLinea := ''
                        else
                            RespuestaLinea := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:DesgloseFactura>'), STRPOS(textXML, '</siiLRRC:DesgloseFactura>') - STRPOS(textXML, '<siiLRRC:DesgloseFactura>'));
                    end;
                end;

                EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));
                WHILE EstadoEnvio <> '' DO begin
                    EstadoEnvio := DELSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoFactura>'), STRLEN('<siiLRRC:EstadoFactura>'));

                    EstadoCuadre := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoCuadre>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'));
                    EstadoCuadre := DELSTR(EstadoCuadre, STRPOS(EstadoCuadre, '<siiLRRC:EstadoCuadre>'), STRLEN('<siiLRRC:EstadoCuadre>'));
                    EVALUATE(intEstadoCuadre, EstadoCuadre);

                    EstadoRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'));
                    EstadoRegistro := DELSTR(EstadoRegistro, STRPOS(EstadoRegistro, '<siiLRRC:EstadoRegistro>'), STRLEN('<siiLRRC:EstadoRegistro>'));

                    if STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>') <> 0 then begin
                        ErrorCode := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'), STRPOS(EstadoEnvio, '</siiLRRC:CodigoErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'));
                        ErrorCode := DELSTR(ErrorCode, STRPOS(ErrorCode, '<siiLRRC:CodigoErrorRegistro>'), STRLEN('<siiLRRC:CodigoErrorRegistro>'));
                    end;

                    if STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>') <> 0 then begin
                        DescripcionErrorRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'),
                                                            STRPOS(EstadoEnvio, '</siiLRRC:DescripcionErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'));
                        DescripcionErrorRegistro := DELSTR(DescripcionErrorRegistro, STRPOS(DescripcionErrorRegistro, '<siiLRRC:DescripcionErrorRegistro>'), STRLEN('<siiLRRC:DescripcionErrorRegistro>'));
                    end;

                    if STRPOS(EstadoEnvio, '<siiLRRC:DatosDescuadreContraparte>') <> 0 then begin
                        txtDescuadreImporteBase := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'), STRPOS(EstadoEnvio, '</sii:SumBaseImponible>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'));
                        txtDescuadreImporteBase := DELSTR(txtDescuadreImporteBase, STRPOS(txtDescuadreImporteBase, '<sii:SumBaseImponible>'), STRLEN('<sii:SumBaseImponible>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteBase);
                        DescuadreImporteBase += tmpImporte;

                        txtDescuadreImporteCuota := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuota>'), STRPOS(EstadoEnvio, '</sii:SumCuota>') - STRPOS(EstadoEnvio, '<sii:SumCuota>'));
                        txtDescuadreImporteCuota := DELSTR(txtDescuadreImporteCuota, STRPOS(txtDescuadreImporteCuota, '<sii:SumCuota>'), STRLEN('<sii:SumCuota>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteCuota);
                        DescuadreImporteCuota += tmpImporte;

                        txtDescuadreImporteRE := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'),
                                                         STRPOS(EstadoEnvio, '</sii:SumCuotaRecargoEquivalencia>') - STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'));
                        txtDescuadreImporteRE := DELSTR(txtDescuadreImporteRE, STRPOS(txtDescuadreImporteRE, '<sii:SumCuotaRecargoEquivalencia>'), STRLEN('<sii:SumCuotaRecargoEquivalencia>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteRE);
                        DescuadreImporteRE += tmpImporte;

                        txtDescuadreImporteTotal := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:ImporteTotal>'), STRPOS(EstadoEnvio, '</sii:ImporteTotal>') - STRPOS(EstadoEnvio, '<sii:ImporteTotal>'));
                        txtDescuadreImporteTotal := DELSTR(txtDescuadreImporteTotal, STRPOS(txtDescuadreImporteTotal, '<sii:ImporteTotal>'), STRLEN('<sii:ImporteTotal>'));
                        EVALUATE(tmpImporte, txtDescuadreImporteTotal);
                        DescuadreImporteTotal += tmpImporte;

                        txtDescuadreBaseImponibleISP := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'),
                                                                STRPOS(EstadoEnvio, '</sii:SumBaseImponibleISP>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'));
                        txtDescuadreBaseImponibleISP := DELSTR(txtDescuadreBaseImponibleISP, STRPOS(txtDescuadreBaseImponibleISP, '<sii:SumBaseImponibleISP>'), STRLEN('<sii:SumBaseImponibleISP>'));
                        EVALUATE(tmpImporte, txtDescuadreBaseImponibleISP);
                        DescuadreBaseImponibleISP += tmpImporte;
                    end;

                    textXML := DELSTR(textXML, 1, STRPOS(textXML, '</siiLRRC:EstadoFactura>'));
                    if (STRPOS(textXML, '<siiLRRC:EstadoFactura>') = 0) or (STRPOS(textXML, '</siiLRRC:EstadoFactura>') = 0) then
                        EstadoEnvio := ''
                    else
                        EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));

                    if LOWERCASE(EstadoRegistro) = 'correcta' then
                        EstadoRegistro := 'Correcto'
                    else begin
                        if LOWERCASE(EstadoRegistro) = 'aceptadaconerrores' then
                            EstadoRegistro := 'AceptadoConErrores'
                    end;

                    Rec.VALIDATE("AEAT Status", EstadoRegistro);

                    "Shipment Status" := "Shipment Status"::Enviado;

                    "ISP Base Imbalance" := DescuadreBaseImponibleISP;
                    "Base Imbalance" := DescuadreImporteBase;
                    "Imbalance Fee" := DescuadreImporteCuota;
                    "Imbalance RE Fee" := DescuadreImporteRE;
                    "Imbalance Amount" := DescuadreImporteTotal;
                    "Tally Status" := intEstadoCuadre;

                    MODIFY;
                end
            end else begin
                if STRPOS(textXML, '<siiLRRC:RespuestaConsultaLRBienesInversion') <> 0 then begin
                    DocumentType := DocumentType::BI;

                    EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));
                    WHILE EstadoEnvio <> '' DO begin
                        EstadoEnvio := DELSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoFactura>'), STRLEN('<siiLRRC:EstadoFactura>'));

                        EstadoCuadre := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoCuadre>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'));
                        EstadoCuadre := DELSTR(EstadoCuadre, STRPOS(EstadoCuadre, '<siiLRRC:EstadoCuadre>'), STRLEN('<siiLRRC:EstadoCuadre>'));
                        EVALUATE(intEstadoCuadre, EstadoCuadre);

                        EstadoRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'));
                        EstadoRegistro := DELSTR(EstadoRegistro, STRPOS(EstadoRegistro, '<siiLRRC:EstadoRegistro>'), STRLEN('<siiLRRC:EstadoRegistro>'));

                        if STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>') <> 0 then begin
                            ErrorCode := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'),
                                                 STRPOS(EstadoEnvio, '</siiLRRC:CodigoErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'));
                            ErrorCode := DELSTR(ErrorCode, STRPOS(ErrorCode, '<siiLRRC:CodigoErrorRegistro>'), STRLEN('<siiLRRC:CodigoErrorRegistro>'));
                        end;

                        if STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>') <> 0 then begin
                            DescripcionErrorRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'),
                                                                STRPOS(EstadoEnvio, '</siiLRRC:DescripcionErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'));
                            DescripcionErrorRegistro := DELSTR(DescripcionErrorRegistro, STRPOS(DescripcionErrorRegistro, '<siiLRRC:DescripcionErrorRegistro>'), STRLEN('<siiLRRC:DescripcionErrorRegistro>'));
                        end;

                        if STRPOS(EstadoEnvio, '<siiLRRC:DatosDescuadreContraparte>') <> 0 then begin
                            txtDescuadreImporteBase := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'), STRPOS(EstadoEnvio, '</sii:SumBaseImponible>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'));
                            txtDescuadreImporteBase := DELSTR(txtDescuadreImporteBase, STRPOS(txtDescuadreImporteBase, '<sii:SumBaseImponible>'), STRLEN('<sii:SumBaseImponible>'));
                            EVALUATE(tmpImporte, txtDescuadreImporteBase);
                            DescuadreImporteBase += tmpImporte;

                            txtDescuadreImporteCuota := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuota>'), STRPOS(EstadoEnvio, '</sii:SumCuota>') - STRPOS(EstadoEnvio, '<sii:SumCuota>'));
                            txtDescuadreImporteCuota := DELSTR(txtDescuadreImporteCuota, STRPOS(txtDescuadreImporteCuota, '<sii:SumCuota>'), STRLEN('<sii:SumCuota>'));
                            EVALUATE(tmpImporte, txtDescuadreImporteCuota);
                            DescuadreImporteCuota += tmpImporte;

                            txtDescuadreImporteRE := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'),
                                                             STRPOS(EstadoEnvio, '</sii:SumCuotaRecargoEquivalencia>') - STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'));
                            txtDescuadreImporteRE := DELSTR(txtDescuadreImporteRE, STRPOS(txtDescuadreImporteRE, '<sii:SumCuotaRecargoEquivalencia>'), STRLEN('<sii:SumCuotaRecargoEquivalencia>'));
                            EVALUATE(tmpImporte, txtDescuadreImporteRE);
                            DescuadreImporteRE += tmpImporte;

                            txtDescuadreImporteTotal := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:ImporteTotal>'), STRPOS(EstadoEnvio, '</sii:ImporteTotal>') - STRPOS(EstadoEnvio, '<sii:ImporteTotal>'));
                            txtDescuadreImporteTotal := DELSTR(txtDescuadreImporteTotal, STRPOS(txtDescuadreImporteTotal, '<sii:ImporteTotal>'), STRLEN('<sii:ImporteTotal>'));
                            EVALUATE(tmpImporte, txtDescuadreImporteTotal);
                            DescuadreImporteTotal += tmpImporte;

                            txtDescuadreBaseImponibleISP := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'),
                                                                    STRPOS(EstadoEnvio, '</sii:SumBaseImponibleISP>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'));
                            txtDescuadreBaseImponibleISP := DELSTR(txtDescuadreBaseImponibleISP, STRPOS(txtDescuadreBaseImponibleISP, '<sii:SumBaseImponibleISP>'), STRLEN('<sii:SumBaseImponibleISP>'));
                            EVALUATE(tmpImporte, txtDescuadreBaseImponibleISP);
                            DescuadreBaseImponibleISP += tmpImporte;
                        end;

                        textXML := DELSTR(textXML, 1, STRPOS(textXML, '</siiLRRC:EstadoFactura>'));
                        if (STRPOS(textXML, '<siiLRRC:EstadoFactura>') = 0) or (STRPOS(textXML, '</siiLRRC:EstadoFactura>') = 0) then
                            EstadoEnvio := ''
                        else
                            EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));

                        if LOWERCASE(EstadoRegistro) = 'correcta' then
                            EstadoRegistro := 'Correcto'
                        else begin
                            if LOWERCASE(EstadoRegistro) = 'aceptadaconerrores' then
                                EstadoRegistro := 'AceptadoConErrores'
                        end;

                        Rec.VALIDATE("AEAT Status", EstadoRegistro);

                        "Shipment Status" := "Shipment Status"::Enviado;

                        "ISP Base Imbalance" := DescuadreBaseImponibleISP;
                        "Base Imbalance" := DescuadreImporteBase;
                        "Imbalance Fee" := DescuadreImporteCuota;
                        "Imbalance RE Fee" := DescuadreImporteRE;
                        "Imbalance Amount" := DescuadreImporteTotal;
                        "Tally Status" := intEstadoCuadre;

                        MODIFY;
                    end
                end else begin
                    if STRPOS(textXML, '<siiLRRC:RespuestaConsultaLRDetOperacionesIntracomunitarias') <> 0 then begin
                        DocumentType := DocumentType::OI;

                        EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));
                        WHILE EstadoEnvio <> '' DO begin
                            EstadoEnvio := DELSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoFactura>'), STRLEN('<siiLRRC:EstadoFactura>'));

                            EstadoCuadre := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoCuadre>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoCuadre>'));
                            EstadoCuadre := DELSTR(EstadoCuadre, STRPOS(EstadoCuadre, '<siiLRRC:EstadoCuadre>'), STRLEN('<siiLRRC:EstadoCuadre>'));
                            EVALUATE(intEstadoCuadre, EstadoCuadre);

                            EstadoRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'), STRPOS(EstadoEnvio, '</siiLRRC:EstadoRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:EstadoRegistro>'));
                            EstadoRegistro := DELSTR(EstadoRegistro, STRPOS(EstadoRegistro, '<siiLRRC:EstadoRegistro>'), STRLEN('<siiLRRC:EstadoRegistro>'));

                            if STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>') <> 0 then begin
                                ErrorCode := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'),
                                                     STRPOS(EstadoEnvio, '</siiLRRC:CodigoErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:CodigoErrorRegistro>'));
                                ErrorCode := DELSTR(ErrorCode, STRPOS(ErrorCode, '<siiLRRC:CodigoErrorRegistro>'), STRLEN('<siiLRRC:CodigoErrorRegistro>'));
                            end;

                            if STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>') <> 0 then begin
                                DescripcionErrorRegistro := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'),
                                                                    STRPOS(EstadoEnvio, '</siiLRRC:DescripcionErrorRegistro>') - STRPOS(EstadoEnvio, '<siiLRRC:DescripcionErrorRegistro>'));
                                DescripcionErrorRegistro := DELSTR(DescripcionErrorRegistro, STRPOS(DescripcionErrorRegistro, '<siiLRRC:DescripcionErrorRegistro>'), STRLEN('<siiLRRC:DescripcionErrorRegistro>'));
                            end;

                            if STRPOS(EstadoEnvio, '<siiLRRC:DatosDescuadreContraparte>') <> 0 then begin
                                txtDescuadreImporteBase := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'), STRPOS(EstadoEnvio, '</sii:SumBaseImponible>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponible>'));
                                txtDescuadreImporteBase := DELSTR(txtDescuadreImporteBase, STRPOS(txtDescuadreImporteBase, '<sii:SumBaseImponible>'), STRLEN('<sii:SumBaseImponible>'));
                                EVALUATE(tmpImporte, txtDescuadreImporteBase);
                                DescuadreImporteBase += tmpImporte;

                                txtDescuadreImporteCuota := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuota>'), STRPOS(EstadoEnvio, '</sii:SumCuota>') - STRPOS(EstadoEnvio, '<sii:SumCuota>'));
                                txtDescuadreImporteCuota := DELSTR(txtDescuadreImporteCuota, STRPOS(txtDescuadreImporteCuota, '<sii:SumCuota>'), STRLEN('<sii:SumCuota>'));
                                EVALUATE(tmpImporte, txtDescuadreImporteCuota);
                                DescuadreImporteCuota += tmpImporte;

                                txtDescuadreImporteRE := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'),
                                                                 STRPOS(EstadoEnvio, '</sii:SumCuotaRecargoEquivalencia>') - STRPOS(EstadoEnvio, '<sii:SumCuotaRecargoEquivalencia>'));
                                txtDescuadreImporteRE := DELSTR(txtDescuadreImporteRE, STRPOS(txtDescuadreImporteRE, '<sii:SumCuotaRecargoEquivalencia>'), STRLEN('<sii:SumCuotaRecargoEquivalencia>'));
                                EVALUATE(tmpImporte, txtDescuadreImporteRE);
                                DescuadreImporteRE += tmpImporte;

                                txtDescuadreImporteTotal := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:ImporteTotal>'), STRPOS(EstadoEnvio, '</sii:ImporteTotal>') - STRPOS(EstadoEnvio, '<sii:ImporteTotal>'));
                                txtDescuadreImporteTotal := DELSTR(txtDescuadreImporteTotal, STRPOS(txtDescuadreImporteTotal, '<sii:ImporteTotal>'), STRLEN('<sii:ImporteTotal>'));
                                EVALUATE(tmpImporte, txtDescuadreImporteTotal);
                                DescuadreImporteTotal += tmpImporte;

                                txtDescuadreBaseImponibleISP := COPYSTR(EstadoEnvio, STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'),
                                                                        STRPOS(EstadoEnvio, '</sii:SumBaseImponibleISP>') - STRPOS(EstadoEnvio, '<sii:SumBaseImponibleISP>'));
                                txtDescuadreBaseImponibleISP := DELSTR(txtDescuadreBaseImponibleISP, STRPOS(txtDescuadreBaseImponibleISP, '<sii:SumBaseImponibleISP>'), STRLEN('<sii:SumBaseImponibleISP>'));
                                EVALUATE(tmpImporte, txtDescuadreBaseImponibleISP);
                                DescuadreBaseImponibleISP += tmpImporte;
                            end;

                            textXML := DELSTR(textXML, 1, STRPOS(textXML, '</siiLRRC:EstadoFactura>'));
                            if (STRPOS(textXML, '<siiLRRC:EstadoFactura>') = 0) or (STRPOS(textXML, '</siiLRRC:EstadoFactura>') = 0) then
                                EstadoEnvio := ''
                            else
                                EstadoEnvio := COPYSTR(textXML, STRPOS(textXML, '<siiLRRC:EstadoFactura>'), STRPOS(textXML, '</siiLRRC:EstadoFactura>') - STRPOS(textXML, '<siiLRRC:EstadoFactura>'));

                            if LOWERCASE(EstadoRegistro) = 'correcta' then
                                EstadoRegistro := 'Correcto'
                            else begin
                                if LOWERCASE(EstadoRegistro) = 'aceptadaconerrores' then
                                    EstadoRegistro := 'AceptadoConErrores'
                            end;

                            Rec.VALIDATE("AEAT Status", EstadoRegistro);

                            "Shipment Status" := "Shipment Status"::Enviado;

                            "ISP Base Imbalance" := DescuadreBaseImponibleISP;
                            "Base Imbalance" := DescuadreImporteBase;
                            "Imbalance Fee" := DescuadreImporteCuota;
                            "Imbalance RE Fee" := DescuadreImporteRE;
                            "Imbalance Amount" := DescuadreImporteTotal;
                            "Tally Status" := intEstadoCuadre;

                            MODIFY;
                        end
                    end;
                end;
            end;
        end;
    end;

    procedure GetType(): Integer;
    var
        //       SalesInvoiceHeader@1100286000 :
        SalesInvoiceHeader: Record 112;
        //       SalesCrMemoHeader@1100286001 :
        SalesCrMemoHeader: Record 114;
        //       PurchInvHeader@1100286002 :
        PurchInvHeader: Record 122;
        //       PurchCrMemoHdr@1100286003 :
        PurchCrMemoHdr: Record 124;
    begin
        //JAV 16/03/22: - QuoSII 1.06.03 Retorna si el tipo de registro es para usar con clientes o con proveedores
        if (Rec."Document Type" IN [Rec."Document Type"::FE, Rec."Document Type"::OS, Rec."Document Type"::CM, Rec."Document Type"::BI, Rec."Document Type"::OI, Rec."Document Type"::CE]) then
            exit(0);

        if (Rec."Document Type" IN [Rec."Document Type"::FR, Rec."Document Type"::OI, Rec."Document Type"::PR]) then
            exit(1);

        //JAV 30/03/22: - QuoSII 1.06.05 Si no se sube al SII no tenemos ese dato, buscamos por el documento registrado
        if (Rec."Document Type" IN [Rec."Document Type"::NO]) then begin
            if (SalesInvoiceHeader.GET(Rec."External Reference")) then
                exit(0);
            if (SalesCrMemoHeader.GET(Rec."External Reference")) then
                exit(0);
            if (PurchInvHeader.GET(Rec."External Reference")) then
                exit(1);
            if (PurchCrMemoHdr.GET(Rec."External Reference")) then
                exit(1);
        end;

        ERROR('El documento %1 no tiene definido si es para clientes o proveedores', Rec."External Reference");
    end;

    procedure GetDocumentType(): Integer;
    var
        //       SalesInvoiceHeader@1100286000 :
        SalesInvoiceHeader: Record 112;
        //       SalesCrMemoHeader@1100286001 :
        SalesCrMemoHeader: Record 114;
        //       PurchInvHeader@1100286002 :
        PurchInvHeader: Record 122;
        //       PurchCrMemoHdr@1100286003 :
        PurchCrMemoHdr: Record 124;
    begin
        //JAV 15/07/22: - QuoSII 1.06.xx Retorna el tipo de documento asociado 0=Factura, 1=Abono, 2=Otros
        if (GetType = 0) then begin
            if (SalesInvoiceHeader.GET(Rec."External Reference")) then
                exit(0);
            if (SalesCrMemoHeader.GET(Rec."External Reference")) then
                exit(1);
        end else begin
            if (PurchInvHeader.GET(Rec."External Reference")) then
                exit(0);
            if (PurchCrMemoHdr.GET(Rec."External Reference")) then
                exit(1);
        end;

        exit(2);
    end;

    procedure GetCountry(): Text;
    var
        //       Customer@1100286000 :
        Customer: Record 18;
        //       Vendor@1100286001 :
        Vendor: Record 23;
    begin
        //JAV 16/03/22: - QuoSII 1.06.03 Retorna el pais del cliente o proveedor
        if (GetType = UseIn::Sales) then begin
            if (Customer.GET(Rec."Cust/Vendor No.")) then
                exit(Customer."Country/Region Code");
        end else begin
            if (Vendor.GET(Rec."Cust/Vendor No.")) then
                exit(Vendor."Country/Region Code");
        end;

        exit('');
    end;

    procedure isExenta(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE(Exent, TRUE);
        SIIDocumentLine.SETRANGE("No Taxable VAT", FALSE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    procedure isNoExenta(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE(Exent, FALSE);
        SIIDocumentLine.SETRANGE("No Taxable VAT", FALSE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    procedure isNoSujeta(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE("No Taxable VAT", TRUE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    procedure isSujetoPasivo(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE("Inversión Sujeto Pasivo", TRUE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    procedure isDesgloseIVA(): Boolean;
    begin
        //CalcFormula = Exist("QuoSII Document Line" WHERE("QUO Desglose Type" = filter("Desglose IVA"),
        //                                                 "QUO Document Type" = FIELD("QUO Document Type"),
        //                                                 "QUO Document No." = FIELD("QUO Document No."),
        //                                                 "QUO Entry No." = FIELD("QUO Entry No.")));
    end;

    procedure isServicios(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE(Bienes, FALSE);
        SIIDocumentLine.SETRANGE(Servicio, TRUE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    procedure isEntrega(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE(Bienes, TRUE);
        SIIDocumentLine.SETRANGE(Servicio, FALSE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    procedure IsFactura(): Boolean;
    begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", "Document Type");
        SIIDocumentLine.SETRANGE("Document No.", "Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", "Entry No.");
        SIIDocumentLine.SETRANGE(Bienes, FALSE);
        SIIDocumentLine.SETRANGE(Servicio, FALSE);
        exit(not SIIDocumentLine.ISEMPTY);
    end;

    /*begin
    //{
//      QuoSII1.4 23/04/18 PEL - A�adido campo External Reference
//      QuoSII1.4 23/04/18 PEL - A�adidos campos referentes al descuadre.
//      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
//      QuoSII_1.4.02.042.14 18/02/19 MCM - Se cambia el CaptionML del campo "Incluido en Envio". Se corrije el campo "Is Emited".
//      QuoSII_1.4.03.043 27/06/19 QMD - Se a�aden campos para crear el report SII Contrast (7043039)
//      QuoSII_1.4.99.999 28/06/19 QMD - Se a�ade campo para controlar que se ha editado desde la p�gina
//                                       Se modifica el validate de algunos campos para que se lleve la Descripción al campo correspondiente
//      BUG17115 PSM 210417 - Ampliar campo "Last Ticket No." de Code 20 a Code 60
//      2101 AJS 23042021 Retrocedo el BUG17115 y pongo tambi�n "First Ticket No." como Code20
//      BUG17265 AJS 06052021: Corregir error en el OnDelete para filtrar por numero de movimiento
//      BUG17266 AJS 07052021: Cuando se cambia la Shipping date hay que actualizar Year, Period y Period Name
//      JAV 21/05/21: Se a�ade una key por fecha de registro para ordenar por este campo la pantalla de documentos
//      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
//                                  Se eliminan validates que solo son comentarios o que solo tienen variables pero no c�digo
//                                  Se mejora la funci�n "AddData" que a�ade dimensiones del documento a campos del registro y se a�ade un nueva GetDimValue
//      PSM 15/10/21: - QuoSII 1.06.00 ver  Se cambia la funci�n "AddData" para leer primero los documentos de compra, porque el N� documento externo es de 35 y no de 20, y da error el GET de ventas
//      LCG 12/12/22: -                RE16081-LCG-12012022 Se quita fragmento de c�digo para no tener que utilizar commit al pulsar bot�n "Obtener Documentos" de la page 7174332 - SII Documents List
//      JAV 16/03/22: - QuoSII 1.06.03 Nueva funci�n que retorna si se usa en compras o en ventas
//                                     Nueva funci�n que retorna el pais del cliente o proveedor
//                                     En la Descripción del r�gimen especial sacaba siempre la Descripción para ventas sin mirar si eran compras
//      JAV 08/09/22: - QuoSII 1.06.12 Para facturas de Tracto sucesivo se a�aden campos para la fecha de vencimiento, si son el documento de la factura y la cancelaci�n y si ya se han creado estos
//                                     Se a�ade c�digo en el On Delete para borrar factura y cancelaci�n juntas, y no dejar la emisi�n si se han generado las otras
//    }
    end.
  */
}








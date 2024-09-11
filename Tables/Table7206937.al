table 7206937 "QBU Framework Contr. Header"
{


    DataPerCompany = false;
    DataCaptionFields = "No.", "Vendor Name";
    CaptionML = ENU = 'Blanket Purchase Header', ESP = 'Cab. Contrato Marco';
    LookupPageID = "Purchase List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = Vendor WHERE("QB Employee" = CONST(false));


            CaptionML = ENU = 'Vendor No.', ESP = 'Compra a-N� proveedor';

            trigger OnValidate();
            VAR
                //                                                                 StandardCodesMgt@1000 :
                StandardCodesMgt: Codeunit 170;
            BEGIN
                TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
                IF ("Vendor No." <> xRec."Vendor No.") AND (xRec."Vendor No." <> '') THEN BEGIN
                    IF GetHideValidationDialog OR NOT GUIALLOWED THEN
                        Confirmed := TRUE
                    ELSE
                        Confirmed := CONFIRM(ConfirmChangeQst, FALSE, BuyFromVendorTxt);

                    IF Confirmed THEN BEGIN
                        IF InitFromVendor("Vendor No.", FIELDCAPTION("Vendor No.")) THEN
                            EXIT;

                        QBBlanketPurchaseLines.RESET;
                    END ELSE BEGIN
                        Rec := xRec;
                        EXIT;
                    END;
                END;

                GetVend("Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend, FALSE);
                Vend.TESTFIELD("Gen. Bus. Posting Group");

                "Vendor Name" := Vend.Name;
                "Document No." := Vend.Contact;
                "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                "Tax Area Code" := Vend."Tax Area Code";
                "Tax Liable" := Vend."Tax Liable";
                "VAT Country/Region Code" := Vend."Country/Region Code";
                "Payment Method Code" := Vend."Payment Method Code";
                "Payment Terms Code" := Vend."Payment Terms Code";
                "Cod. Withholding by G.E" := Vend."QW Withholding Group by G.E.";
                "Cod. Withholding by PIT" := Vend."QW Withholding Group by PIT";
            END;


        }
        field(3; "Vendor Name"; Text[50])
        {
            TableRelation = "Vendor";


            ValidateTableRelation = false;
            CaptionML = ENU = 'Vendor Name', ESP = 'Compra a-Nombre';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 Vendor@1000 :
                Vendor: Record 23;
            BEGIN
            END;


        }
        field(4; "Contact No."; Text[50])
        {


            CaptionML = ENU = 'Contact', ESP = 'Compra a-Contacto';

            trigger OnLookup();
            VAR
                //                                                               Contact@1001 :
                Contact: Record 5050;
            BEGIN
                IF "Vendor No." = '' THEN
                    EXIT;

                LookupContact("Vendor No.", "Document No.", Contact);
                IF PAGE.RUNMODAL(0, Contact) = ACTION::LookupOK THEN
                    VALIDATE("Document No.", Contact."No.");
            END;


        }
        field(12; "Purchaser Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";


            CaptionML = ENU = 'Purchaser Code', ESP = 'C�d. comprador';

            trigger OnValidate();
            VAR
                //                                                                 ApprovalEntry@1001 :
                ApprovalEntry: Record 454;
            BEGIN
                ValidatePurchaserOnPurchHeader(Rec, FALSE, FALSE);

                ApprovalEntry.SETRANGE("Table ID", DATABASE::"QB Framework Contr. Header");
                ApprovalEntry.SETRANGE("Document No.", "No.");
                ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
                IF NOT ApprovalEntry.ISEMPTY THEN
                    ERROR(Text042, FIELDCAPTION("Purchaser Code"));
            END;


        }
        field(20; "Init Date"; Date)
        {


            AccessByPermission = TableData 120 = R;
            CaptionML = ENU = 'Order Date', ESP = 'Fecha Inicio del contrato';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
            END;


        }
        field(21; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ending Contract Date', ESP = 'Fecha Fin del Contrato';


        }
        field(22; "Document No."; Text[35])
        {
            CaptionML = ENU = 'Your Reference', ESP = 'N� Contrato';


        }
        field(23; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";


            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';

            trigger OnValidate();
            BEGIN
                IF ("Payment Terms Code" <> '') THEN
                    PaymentTerms.GET("Payment Terms Code");
            END;


        }
        field(24; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";


            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';

            trigger OnValidate();
            BEGIN
                PaymentMethod.INIT;
                IF "Payment Method Code" <> '' THEN
                    PaymentMethod.GET("Payment Method Code");
            END;


        }
        field(25; "Generic"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Gen�rico';
            Description = 'QB 1.09.05 - JAV 16/07/21 Si es un contrto marco gen�rico';


        }
        field(26; "Status"; Option)
        {
            OptionMembers = "Non-operational","Operative","Closed";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'Non-operational,Operative,Closed', ESP = 'No operativo,Operativo,Cerrado';

            Description = 'Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco';


        }
        field(30; "Use In"; Option)
        {
            OptionMembers = "All","Some";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = 'All company,Some Company', ESP = 'Todas las empresas,Algunas Empresas';



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

            trigger OnValidate();
            BEGIN
                IF (CurrFieldNo <> 0) OR ("Currency Code" <> xRec."Currency Code") THEN
                    TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status

                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                    UpdateCurrencyFactor
                ELSE
                    IF "Currency Code" <> xRec."Currency Code" THEN
                        UpdateCurrencyFactor
                    ELSE
                        IF "Currency Code" <> '' THEN BEGIN
                            UpdateCurrencyFactor;
                            IF "Currency Factor" <> xRec."Currency Factor" THEN
                                ConfirmUpdateCurrencyFactor;
                        END;
            END;


        }
        field(33; "Currency Factor"; Decimal)
        {


            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;

            trigger OnValidate();
            BEGIN
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                    UpdatePurchLinesByFieldNo(FIELDNO("Currency Factor"), CurrFieldNo <> 0);
            END;


        }
        field(41; "Language Code"; Code[10])
        {
            TableRelation = "Language";


            CaptionML = ENU = 'Language Code', ESP = 'C�d. idioma';

            trigger OnValidate();
            BEGIN
                MessageIfPurchLinesExist(FIELDCAPTION("Language Code"));
            END;


        }
        field(46; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Purch. Comment Line" WHERE("No." = FIELD("No."),
                                                                                                  "Document Line No." = CONST(0)));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(60; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(61; "Amount Including VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount Including VAT', ESP = 'Importe IVA incl.';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";


            CaptionML = ENU = 'Gen. Bus. Posting Group', ESP = 'Grupo registro neg. gen.';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
                IF (xRec."Vendor No." = "Vendor No.") AND
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group")
                THEN BEGIN
                    IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") THEN
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                END;
            END;


        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'VAT Country/Region Code', ESP = 'C�d. IVA pa�s/regi�n';


        }
        field(107; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'Nos. serie';
            Editable = false;


        }
        field(114; "Tax Area Code"; Code[20])
        {
            TableRelation = "Tax Area";


            CaptionML = ENU = 'Tax Area Code', ESP = 'C�d. �rea impuesto';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Area Code"));
            END;


        }
        field(115; "Tax Liable"; Boolean)
        {


            CaptionML = ENU = 'Tax Liable', ESP = 'Sujeto a impuesto';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Liable"));
            END;


        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";


            CaptionML = ENU = 'VAT Bus. Posting Group', ESP = 'Grupo registro IVA neg.';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
            END;


        }
        field(120; "OLD_Status"; Option)
        {
            OptionMembers = "Active","Closed";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Purchase Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'Active,Closed', ESP = 'Activo,Cerrado';

            Description = 'Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco';
            Editable = false;


        }
        field(7207270; "Cod. Withholding by G.E"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"),
                                                                                                 "Use in" = FILTER('Booth' | 'Vendor'));
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'C�d. retenci�n por B.E.';
            Description = 'QB 1.0 - QB22111';


        }
        field(7207271; "Cod. Withholding by PIT"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("PIT"),
                                                                                                 "Use in" = FILTER('Booth' | 'Vendor'));
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'C�d. retenci�n por IRPF';
            Description = 'QB 1.0 - QB22111';


        }
        field(7207281; "Type of Order"; Option)
        {
            OptionMembers = "Item","Resource","Mixed";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type of Order', ESP = 'Tipo de pedido';
            OptionCaptionML = ENU = 'Item,Resource,Mixed', ESP = 'Producto,Recurso,Mixto';

            Description = 'QB 1.0';


        }
        field(7207283; "Activity code"; Code[20])
        {
            TableRelation = "Activity QB";
            CaptionML = ENU = 'Activity code', ESP = 'C�d. actividad';
            Description = 'QB 1.0 - QB2515   JAV 12/11/19: - Se cambia el table relation del campo "Activity code"';


        }
        field(7207302; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = 'QB 1.03 - JAV 14/10/19: - Situaci�n de la aprobaci�n';
            Editable = false;


        }
        field(7207303; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = 'QB 1.03 - JAV 14/10/19: - �ltimo comentario de la aprobaci�n, retenci�n o rechazo';
            Editable = false;


        }
        field(7207304; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = 'QB 1.03 - JAV 14/10/19: - Feha de la aprobaci�n, retenci�n o rechazo';
            Editable = false;


        }
        field(7207305; "OLD_Approval Circuit"; Option)
        {
            OptionMembers = "General","Materiales","Subcontratas";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Circuito de Aprobaci�n';
            OptionCaptionML = ESP = 'General,Materiales,Subcontratas';

            Description = 'QB 1.04 - JAV';

            trigger OnValidate();
            VAR
                //                                                                 txt001@1100286000 :
                txt001: TextConst ESP = 'No puede usar este circuito de aprobaci�n';
                //                                                                 QuoBuildingSetup@1100286001 :
                QuoBuildingSetup: Record 7207278;
            BEGIN
            END;


        }
        field(7207309; "QB Calc Due Date"; Option)
        {
            OptionMembers = "Standar","Document","Reception","Approval";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Calculo Vencimientos';
            OptionCaptionML = ENU = 'Standar,Document,Reception,Approval', ESP = 'Estandar,Fecha del Documento,Fecha de Recepci�n,Fecha de Aprobaci�n';

            Description = 'QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';

            trigger OnValidate();
            BEGIN
                IF xRec."QB Calc Due Date" <> "QB Calc Due Date" THEN BEGIN
                    IF ("QB Calc Due Date" = "QB Calc Due Date"::Reception) THEN BEGIN
                        QuoBuildingSetup.GET();
                        "QB No. Days Calc Due Date" := QuoBuildingSetup."No. Days Calc Due Date";
                    END;
                END;

                IF ("QB Calc Due Date" <> "QB Calc Due Date"::Reception) THEN
                    "QB No. Days Calc Due Date" := 0;


                VALIDATE("Payment Terms Code");
            END;


        }
        field(7207310; "QB No. Days Calc Due Date"; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� d�as tras Recepci�n';
            Description = 'QB 1.06 - JAV 12/07/20: - d�as adicionales para el c�lculo del vto de las fras de compra, ORTIZ';

            trigger OnValidate();
            BEGIN

                VALIDATE("Payment Terms Code");
            END;


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
        //       Text003@1003 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       ConfirmChangeQst@1004 :
        ConfirmChangeQst:
// "%1 = a Field Caption like Currency Code"
TextConst ENU = 'Do you want to change %1?', ESP = '�Confirma que desea cambiar %1?';
        //       Text005@1005 :
        Text005: TextConst ENU = 'You cannot reset %1 because the document still has one or more lines.', ESP = 'No se puede modificar %1 ya que el documento tiene una o m�s l�neas.';
        //       YouCannotChangeFieldErr@1006 :
        YouCannotChangeFieldErr:
// %1 - fieldcaption
TextConst ENU = 'You cannot change %1 because the order is associated with one or more sales orders.', ESP = 'No se puede cambiar %1 porque el pedido est� asociado con pedidos de venta.';
        //       Text007@1007 :
        Text007: TextConst ENU = '%1 is greater than %2 in the %3 table.\', ESP = '%1 es mayor que %2 en la tabla %3.\';
        //       Text008@1008 :
        Text008: TextConst ENU = 'Confirm change?', ESP = '�Confirma el cambio?';
        //       Text009@1009 :
        Text009:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for receipts. An empty receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en los n�meros de serie de los recibos. Se crear� un recibo en blanco %1 para corregir esta discontinuidad en los n�meros de serie.\\�Desea continuar?';
        //       Text012@1012 :
        Text012:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento se provocar� una discontinuidad en la numeraci�n de la serie de facturas registradas. Se crear� una factura registrada en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text014@1014 :
        Text014:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la serie num�rica de abonos registrados. Se crear� un abono registrado en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       RecreatePurchLinesMsg@1016 :
        RecreatePurchLinesMsg:
// %1: FieldCaption
TextConst ENU = 'if you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\Do you want to continue?', ESP = 'Si cambia %1, se eliminar�n las l�neas de compra actuales y se crear�n nuevas l�neas de compra bas�ndose en la nueva informaci�n de la cabecera.\\�Desea continuar?';
        //       ResetItemChargeAssignMsg@1093 :
        ResetItemChargeAssignMsg:
// %1: FieldCaption
TextConst ENU = 'if you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\The amount of the item charge assignment will be reset to 0.\\Do you want to continue?', ESP = 'Si cambia %1, se eliminar�n las l�neas de compra actuales y se crear�n l�neas de compra nuevas basadas en la informaci�n nueva de la cabecera.\El importe de la asignaci�n del cargo del producto se pondr� a 0.\\�Desea continuar?';
        //       Text018@1017 :
        Text018: TextConst ENU = 'You must delete the existing purchase lines before you can change %1.', ESP = 'Se deben eliminar las l�neas de compra existentes antes de cambiar %1.';
        //       LinesNotUpdatedMsg@1018 :
        LinesNotUpdatedMsg:
// You have changed Posting Date on the purchase header, but it has not been changed on the existing purchase lines.
TextConst ENU = 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.', ESP = 'Se ha modificado %1 en la cab. compra, pero no se ha modificado en las l�neas de compra existentes.';
        //       Text020@1019 :
        Text020: TextConst ENU = 'You must update the existing purchase lines manually.', ESP = 'Debe actualizar las l�neas de compra existentes manualmente.';
        //       AffectExchangeRateMsg@1020 :
        AffectExchangeRateMsg: TextConst ENU = 'The change may affect the exchange rate that is used for price calculation on the purchase lines.', ESP = 'El cambio puede afectar al tipo de cambio usado en el c�lculo del precio en las l�neas de compra.';
        //       Text022@1021 :
        Text022: TextConst ENU = 'Do you want to update the exchange rate?', ESP = '�Confirma que desea modificar el tipo de cambio?';
        //       Text023@1022 :
        Text023: TextConst ENU = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.', ESP = 'No puede borrar este documento. Su identificaci�n est� configurada s�lo para procesar %1 %2.';
        //       Text025@1024 :
        Text025: TextConst ENU = 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ', ESP = 'Ha modificado el campo %1. El nuevo c�lculo de IVA puede tener alguna diferencia, por lo que deber�a comprobar los importes. ';
        //       Text027@1026 :
        Text027: TextConst ENU = 'Do you want to update the %2 field on the lines to reflect the new value of %1?', ESP = '�Confirma que desea actualizar el %2 campo en la l�neas para reflejar el nuevo valor de %1?';
        //       Text028@1027 :
        Text028: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Text029@1028 :
        Text029:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina este documento, se provocar� una discontinuidad en los n�meros de serie de los env�os devoluci�n. Se crear� un env�o devoluci�n en blanco %1 para corregir esta discontinuidad en los n�meros de serie.\\�Desea continuar?';
        //       Text032@1031 :
        Text032:
// You have modified Currency Factor.\\Do you want to update the lines?
TextConst ENU = 'You have modified %1.\\Do you want to update the lines?', ESP = 'Ha modificado %1.\\�Desea actualizar las l�neas?';
        //       QBBlanketPurchaseLines@1100286005 :
        QBBlanketPurchaseLines: Record 7206938;
        //       PurchCommentLine@1100286003 :
        PurchCommentLine: Record 43;
        //       PurchSetup@1033 :
        PurchSetup: Record 312;
        //       Vend@1038 :
        Vend: Record 23;
        //       PaymentTerms@1039 :
        PaymentTerms: Record 3;
        //       PaymentMethod@1040 :
        PaymentMethod: Record 289;
        //       CurrExchRate@1041 :
        CurrExchRate: Record 330;
        //       CompanyInfo@1046 :
        CompanyInfo: Record 79;
        //       GenBusPostingGrp@1054 :
        GenBusPostingGrp: Record 250;
        //       SalespersonPurchaser@1932 :
        SalespersonPurchaser: Record 13;
        //       NoSeriesMgt@1060 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       ApprovalsMgmt@1082 :
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //       UserSetupMgt@1066 :
        UserSetupMgt: Codeunit 5700;
        //       CurrencyDate@1069 :
        CurrencyDate: Date;
        //       HideValidationDialog@1070 :
        HideValidationDialog: Boolean;
        //       Confirmed@1071 :
        Confirmed: Boolean;
        //       Text034@1072 :
        Text034: TextConst ENU = 'You cannot change the %1 when the %2 has been filled in.', ESP = 'No puede cambiar %1 despu�s de introducir datos en %2.';
        //       Text037@1076 :
        Text037: TextConst ENU = 'Contact %1 %2 is not related to vendor %3.', ESP = 'Contacto %1 %2 no est� relacionado con proveedor %3.';
        //       Text038@1075 :
        Text038: TextConst ENU = 'Contact %1 %2 is related to a different company than vendor %3.', ESP = 'Contacto %1 %2 est� relacionado con una empresa diferente al proveedor %3.';
        //       Text039@1077 :
        Text039: TextConst ENU = 'Contact %1 %2 is not related to a vendor.', ESP = 'Contacto %1 %2 no est� relacionado con un proveedor.';
        //       Text040@1079 :
        Text040: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.', ESP = 'No puede cambiar el campo %1 porque %2 %3 tiene %4 = %5 y ya se ha asignado el %6 a %7 %8.';
        //       Text042@1084 :
        Text042: TextConst ENU = 'You must cancel the approval process if you wish to change the %1.', ESP = 'Debe cancelar el proceso de aprobaci�n si desea cambiar el %1.';
        //       Text045@1086 :
        Text045: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de facturas de prepago. Se crear� una factura prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text046@1087 :
        Text046: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de abonos de prepago. Se crear� un abono prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text049@1092 :
        Text049: TextConst ENU = '%1 is set up to process from %2 %3 only.', ESP = 'Se ha configurado %1 para procesar s�lo desde %2 %3.';
        //       Text051@1025 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Puede que haya cambiado una dimensi�n.\\�Desea actualizar las l�neas?';
        //       Text052@1091 :
        Text052: TextConst ENU = 'The %1 field on the purchase order %2 must be the same as on sales order %3.', ESP = 'El campo %1 del pedido de compra %2 debe ser igual al del pedido de venta %3.';
        //       PrepaymentInvoicesNotPaidErr@1074 :
        PrepaymentInvoicesNotPaidErr:
// You cannot post the document of type Order with the number 1001 before all related prepayment invoices are posted.
TextConst ENU = 'You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.', ESP = 'No puede registrar el documento de tipo %1 con el n�mero %2 antes de que se registren todas las facturas de prepago relacionadas.';
        //       Text054@1096 :
        Text054: TextConst ENU = 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.', ESP = 'Hay facturas prepago sin pagar relacionadas con el documento de tipo %1 con el n�mero %2.';
        //       Text1100000@1100009 :
        Text1100000: TextConst ENU = 'It exists a Posted Purchase Receipt %1 %2 with %3 set to %4', ESP = 'Existe albar�n compra registrado %1 %2 con %3 definido como %4';
        //       Text10700@1100000 :
        Text10700: TextConst ENU = '%1 cannot be different from 0 when %2 is %3', ESP = '%1 no puede ser diferente de 0 cuando %2 es %3';
        //       DeferralLineQst@1055 :
        DeferralLineQst:
// "%1=The posting date on the document."
TextConst ENU = 'You have changed the %1 on the purchase header, do you want to update the deferral schedules for the lines with this date?', ESP = 'Ha cambiado %1 en el encabezado de compra. �Desea actualizar las previsiones de fraccionamiento para las l�neas con esta fecha?';
        //       PostedDocsToPrintCreatedMsg@1083 :
        PostedDocsToPrintCreatedMsg: TextConst ENU = 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.', ESP = 'Durante la eliminaci�n, se han generado uno o m�s documentos registrados relacionados en sustituci�n de los n�meros de registro que faltan de la serie. Puede ver o imprimir los documentos del archivo de documentos correspondiente.';
        //       BuyFromVendorTxt@1010 :
        BuyFromVendorTxt: TextConst ENU = 'Vendor', ESP = 'Proveedor de compra';
        //       PurchOrderDocTxt@1000 :
        PurchOrderDocTxt: TextConst ENU = 'Purchase Order', ESP = 'Pedido compra';
        //       SelectNoSeriesAllowed@1015 :
        SelectNoSeriesAllowed: Boolean;
        //       PurchQuoteDocTxt@1088 :
        PurchQuoteDocTxt: TextConst ENU = 'Purchase Quote', ESP = 'Oferta de compra';
        //       MixedDropshipmentErr@1001 :
        MixedDropshipmentErr: TextConst ENU = 'You cannot print the purchase order because it contains one or more lines for drop shipment in addition to regular purchase lines.', ESP = 'No puede imprimir el pedido de compra porque contiene una o m�s l�neas de env�o adem�s de las l�neas de compra normales.';
        //       DontShowAgainActionLbl@1064 :
        DontShowAgainActionLbl: TextConst ENU = 'Don''t show again', ESP = 'No volver a mostrar';
        //       PurchaseAlreadyExistsTxt@1029 :
        PurchaseAlreadyExistsTxt:
// "%1 = Document Type; %2 = Document No."
TextConst ENU = 'Purchase %1 %2 already exists for this vendor.', ESP = 'Ya existe la compra %1 %2 para este proveedor.';
        //       ShowVendLedgEntryTxt@1044 :
        ShowVendLedgEntryTxt: TextConst ENU = 'Show the vendor ledger entry.', ESP = 'Muestra el movimiento contable de proveedor.';
        //       DuplicatedCaptionsNotAllowedErr@1081 :
        DuplicatedCaptionsNotAllowedErr: TextConst ENU = 'Field captions must not be duplicated when using this method. Use UpdatePurchLinesByFieldNo instead.', ESP = 'No se deben duplicar t�tulos de campo cuando se utiliza este m�todo. Use UpdatePurchLinesByFieldNo en su lugar.';
        //       MissingExchangeRatesQst@1032 :
        MissingExchangeRatesQst:
// %1 - currency code, %2 - posting date
TextConst ENU = 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', ESP = 'No hay tipos de cambio para la divisa %1 y la fecha %2. �Desea agregarlos ahora? De lo contrario, se revertir� el �ltimo cambio que hizo.';
        //       SplitMessageTxt@1085 :
        SplitMessageTxt:
// Some message text 1.\Some message text 2.
TextConst ENU = '%1\%2', ESP = '%1\%2';
        //       "------------------------------ QB"@1100286000 :
        "------------------------------ QB": Integer;
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;
        //       QuoBuildingSetup@1100286002 :
        QuoBuildingSetup: Record 7207278;




    trigger OnInsert();
    var
        //                StandardCodesMgt@1000 :
        StandardCodesMgt: Codeunit 170;
    begin
        if ("No." = '') then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", TODAY, "No.", "No. Series");
        end;

        "Init Date" := WORKDATE;
    end;

    trigger OnModify();
    begin
        //Q12867 -
        CheckBlanketPurchStatus;
        //Q12867 +
    end;

    trigger OnDelete();
    var
        //                PostPurchDelete@1000 :
        PostPurchDelete: Codeunit 364;
        //                ArchiveManagement@1001 :
        ArchiveManagement: Codeunit 5063;
    begin
        ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);

        //Q12867 -
        CheckBlanketPurchStatus;
        //Q12867 +

        QBBlanketPurchaseLines.LOCKTABLE;
        QBBlanketPurchaseLines.SETRANGE("Document No.", "No.");
        DeletePurchaseLines;

        ///////PurchCommentLine.SETRANGE("No.","No.");
        ///////PurchCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    procedure TestNoSeries()
    begin
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Blanket Purchase Serie");
    end;


    procedure GetNoSeriesCode(): Code[20];
    var
        //       NoSeriesCode@1001 :
        NoSeriesCode: Code[20];
    begin
        NoSeriesCode := QuoBuildingSetup."Blanket Purchase Serie";
        exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, SelectNoSeriesAllowed, "No. Series"));
    end;

    //     LOCAL procedure GetVend (VendNo@1000 :
    LOCAL procedure GetVend(VendNo: Code[20])
    begin
        if VendNo <> Vend."No." then
            Vend.GET(VendNo);
    end;


    procedure PurchLinesExist(): Boolean;
    begin
        QBBlanketPurchaseLines.RESET;
        QBBlanketPurchaseLines.SETRANGE("Document No.", "No.");
        exit(QBBlanketPurchaseLines.FINDFIRST);
    end;


    //     procedure MessageIfPurchLinesExist (ChangedFieldName@1000 :
    procedure MessageIfPurchLinesExist(ChangedFieldName: Text[100])
    var
        //       MessageText@1001 :
        MessageText: Text;
    begin
        if PurchLinesExist and not GetHideValidationDialog then begin
            MessageText := STRSUBSTNO(LinesNotUpdatedMsg, ChangedFieldName);
            MessageText := STRSUBSTNO(SplitMessageTxt, MessageText, Text020);
            MESSAGE(MessageText);
        end;
    end;


    //     procedure PriceMessageIfPurchLinesExist (ChangedFieldName@1000 :
    procedure PriceMessageIfPurchLinesExist(ChangedFieldName: Text[100])
    var
        //       MessageText@1001 :
        MessageText: Text;
    begin
        if PurchLinesExist and not GetHideValidationDialog then begin
            MessageText := STRSUBSTNO(LinesNotUpdatedMsg, ChangedFieldName);
            if "Currency Code" <> '' then
                MessageText := STRSUBSTNO(SplitMessageTxt, MessageText, AffectExchangeRateMsg);
            MESSAGE(MessageText);
        end;
    end;


    procedure UpdateCurrencyFactor()
    var
        //       UpdateCurrencyExchangeRates@1001 :
        UpdateCurrencyExchangeRates: Codeunit 1281;
        //       ConfirmManagement@1002 :
        ConfirmManagement: Codeunit "Confirm Management 1";
        //       Updated@1000 :
        Updated: Boolean;
    begin
        if Updated then
            exit;

        if "Currency Code" <> '' then begin
            CurrencyDate := WORKDATE;

            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then begin
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
            end else begin
                if ConfirmManagement.ConfirmProcess(
                     STRSUBSTNO(MissingExchangeRatesQst, "Currency Code", CurrencyDate), TRUE)
                then begin
                    UpdateCurrencyExchangeRates.OpenExchangeRatesPage("Currency Code");
                    UpdateCurrencyFactor;
                end else
                    "Currency Code" := xRec."Currency Code";
            end;
        end else begin
            "Currency Factor" := 0;
        end;
    end;

    LOCAL procedure ConfirmUpdateCurrencyFactor(): Boolean;
    begin
        if GetHideValidationDialog or not GUIALLOWED then
            Confirmed := TRUE
        else
            Confirmed := CONFIRM(Text022, FALSE);
        if Confirmed then
            VALIDATE("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
        exit(Confirmed);
    end;


    procedure GetHideValidationDialog(): Boolean;
    begin
        exit(HideValidationDialog);
    end;


    //     procedure SetHideValidationDialog (NewHideValidationDialog@1000 :
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    //     procedure UpdatePurchLines (ChangedFieldName@1000 : Text[100];AskQuestion@1001 :
    procedure UpdatePurchLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        //       Field@1002 :
        Field: Record 2000000041;
    begin
        Field.SETRANGE(TableNo, DATABASE::"Purchase Header");
        Field.SETRANGE("Field Caption", ChangedFieldName);
        Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        Field.FIND('-');
        if Field.NEXT <> 0 then
            ERROR(DuplicatedCaptionsNotAllowedErr);
        UpdatePurchLinesByFieldNo(Field."No.", AskQuestion);
    end;


    //     procedure UpdatePurchLinesByFieldNo (ChangedFieldNo@1000 : Integer;AskQuestion@1001 :
    procedure UpdatePurchLinesByFieldNo(ChangedFieldNo: Integer; AskQuestion: Boolean)
    var
        //       Field@1004 :
        Field: Record 2000000041;
        //       Question@1002 :
        Question: Text[250];
    begin
        if not PurchLinesExist then
            exit;

        if not Field.GET(DATABASE::"Purchase Header", ChangedFieldNo) then
            Field.GET(DATABASE::"Purchase Line", ChangedFieldNo);

        QBBlanketPurchaseLines.LOCKTABLE;
        MODIFY;

        QBBlanketPurchaseLines.RESET;
        QBBlanketPurchaseLines.SETRANGE("Document No.", "No.");
        if QBBlanketPurchaseLines.FINDSET then
            repeat
                CASE ChangedFieldNo OF
                    FIELDNO("Currency Factor"):
                        if QBBlanketPurchaseLines.Type <> QBBlanketPurchaseLines.Type::" " then
                            QBBlanketPurchaseLines.VALIDATE("Direct Unit Cost");
                end;
                QBBlanketPurchaseLines.MODIFY(TRUE);
            until QBBlanketPurchaseLines.NEXT = 0;
    end;

    LOCAL procedure DeletePurchaseLines()
    begin
        if QBBlanketPurchaseLines.FINDSET then begin
            repeat
                QBBlanketPurchaseLines.DELETE(TRUE);
            until QBBlanketPurchaseLines.NEXT = 0;
        end;
    end;

    //     LOCAL procedure ClearItemAssgntPurchFilter (var TempItemChargeAssgntPurch@1000 :
    LOCAL procedure ClearItemAssgntPurchFilter(var TempItemChargeAssgntPurch: Record 5805 TEMPORARY)
    begin
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
    end;


    //     procedure SetAmountToApply (AppliesToDocNo@1000 : Code[20];VendorNo@1001 :
    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20])
    var
        //       VendLedgEntry@1002 :
        VendLedgEntry: Record 25;
    begin
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.", VendorNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        if VendLedgEntry.FINDFIRST then begin
            if VendLedgEntry."Amount to Apply" = 0 then begin
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            end else
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
        end;
    end;


    procedure SetSecurityFilterOnRespCenter()
    begin
        //JAV 18/07/20: - QB Filtro de proyectos permitidos para el usuario
        //////FunctionQB.SetUserJobPurchasesFilter(Rec);
    end;

    LOCAL procedure IsApprovedForPosting(): Boolean;
    var
        //       PrepaymentMgt@1000 :
        PrepaymentMgt: Codeunit 441;
        //       ConfirmManagement@1001 :
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        ///////if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
        exit(TRUE);
    end;


    procedure IsApprovedForPostingBatch(): Boolean;
    var
        //       PrepaymentMgt@1000 :
        PrepaymentMgt: Codeunit 441;
    begin
        /////if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
        exit(TRUE);
    end;


    procedure IsTotalValid(): Boolean;
    var
        //       IncomingDocument@1002 :
        IncomingDocument: Record 130;
        //       PurchaseLine@1001 :
        PurchaseLine: Record 7206938;
        //       TempTotalPurchaseLine@1000 :
        TempTotalPurchaseLine: Record 7206938 TEMPORARY;
        //       GeneralLedgerSetup@1005 :
        GeneralLedgerSetup: Record 98;
        //       DocumentTotals@1003 :
        DocumentTotals: Codeunit "Document Totals";
        //       VATAmount@1004 :
        VATAmount: Decimal;
    begin
        if IncomingDocument."Amount Incl. VAT" = 0 then
            exit(TRUE);

        PurchaseLine.SETRANGE("Document No.", "No.");
        if not PurchaseLine.FINDFIRST then
            exit(TRUE);

        GeneralLedgerSetup.GET;
        if (IncomingDocument."Currency Code" <> PurchaseLine."Currency Code") and
           (IncomingDocument."Currency Code" <> GeneralLedgerSetup."LCY Code")
        then
            exit(TRUE);

        TempTotalPurchaseLine.INIT;

        exit(IncomingDocument."Amount Incl. VAT" = TempTotalPurchaseLine."Amount Including VAT");
    end;


    //     procedure SendToPosting (PostingCodeunitID@1000 :
    procedure SendToPosting(PostingCodeunitID: Integer)
    begin
        if not IsApprovedForPosting then
            exit;
        CODEUNIT.RUN(PostingCodeunitID, Rec);
    end;

    //     LOCAL procedure CollectParamsInBufferForCreateDimSet (var TempPurchaseLine@1000 : TEMPORARY Record 7206938;PurchaseLine@1001 :
    LOCAL procedure CollectParamsInBufferForCreateDimSet(var TempPurchaseLine: Record 7206938 TEMPORARY; PurchaseLine: Record 7206938)
    var
        //       GenPostingSetup@1002 :
        GenPostingSetup: Record 252;
        //       DefaultDimension@1003 :
        DefaultDimension: Record 352;
    begin
    end;

    //     LOCAL procedure InsertTempPurchaseLineInBuffer (var TempPurchaseLine@1000 : TEMPORARY Record 7206938;PurchaseLine@1001 : Record 7206938;AccountNo@1002 : Code[20];DefaultDimenstionsNotExist@1003 :
    LOCAL procedure InsertTempPurchaseLineInBuffer(var TempPurchaseLine: Record 7206938 TEMPORARY; PurchaseLine: Record 7206938; AccountNo: Code[20]; DefaultDimenstionsNotExist: Boolean)
    begin
        TempPurchaseLine.INIT;
        TempPurchaseLine."Line No." := PurchaseLine."Line No.";
        TempPurchaseLine."No." := AccountNo;
        TempPurchaseLine.MARK := DefaultDimenstionsNotExist;
        TempPurchaseLine.INSERT;
    end;


    procedure OpenPurchaseOrderStatistics()
    begin
        COMMIT;
        PAGE.RUNMODAL(PAGE::"Purchase Order Statistics", Rec);
    end;


    procedure CheckPurchaseReleaseRestrictions()
    var
        //       ApprovalsMgmt@1000 :
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        //////ApprovalsMgmt.PrePostApprovalCheckPurch(Rec);
    end;


    procedure SetBuyFromVendorFromFilter()
    var
        //       BuyFromVendorNo@1000 :
        BuyFromVendorNo: Code[20];
    begin
        BuyFromVendorNo := GetFilterVendNo;
        if BuyFromVendorNo = '' then begin
            FILTERGROUP(2);
            BuyFromVendorNo := GetFilterVendNo;
            FILTERGROUP(0);
        end;
        if BuyFromVendorNo <> '' then
            VALIDATE("Vendor No.", BuyFromVendorNo);
    end;


    procedure CopyBuyFromVendorFilter()
    var
        //       BuyFromVendorFilter@1000 :
        BuyFromVendorFilter: Text;
    begin
        BuyFromVendorFilter := GETFILTER("Vendor No.");
        if BuyFromVendorFilter <> '' then begin
            FILTERGROUP(2);
            SETFILTER("Vendor No.", BuyFromVendorFilter);
            FILTERGROUP(0)
        end;
    end;

    LOCAL procedure GetFilterVendNo(): Code[20];
    begin
        if GETFILTER("Vendor No.") <> '' then
            if GETRANGEMIN("Vendor No.") = GETRANGEMAX("Vendor No.") then
                exit(GETRANGEMAX("Vendor No."));
    end;

    LOCAL procedure BuyFromVendorIsReplaced(): Boolean;
    begin
        exit((xRec."Vendor No." <> '') and (xRec."Vendor No." <> "Vendor No."));
    end;

    //     LOCAL procedure InitFromVendor (VendorNo@1000 : Code[20];VendorCaption@1001 :
    LOCAL procedure InitFromVendor(VendorNo: Code[20]; VendorCaption: Text): Boolean;
    begin
        QBBlanketPurchaseLines.SETRANGE("Document No.", "No.");
        if VendorNo = '' then begin
            if not QBBlanketPurchaseLines.ISEMPTY then
                ERROR(Text005, VendorCaption);
            INIT;
            PurchSetup.GET;
            "No. Series" := xRec."No. Series";
            exit(TRUE);
        end;
    end;

    //     LOCAL procedure InitFromContact (ContactNo@1000 : Code[20];VendorNo@1001 : Code[20];ContactCaption@1002 :
    LOCAL procedure InitFromContact(ContactNo: Code[20]; VendorNo: Code[20]; ContactCaption: Text): Boolean;
    begin
        QBBlanketPurchaseLines.SETRANGE("Document No.", "No.");
        if (ContactNo = '') and (VendorNo = '') then begin
            if not QBBlanketPurchaseLines.ISEMPTY then
                ERROR(Text005, ContactCaption);
            INIT;
            PurchSetup.GET;
            "No. Series" := xRec."No. Series";
            exit(TRUE);
        end;
    end;

    //     LOCAL procedure LookupContact (VendorNo@1000 : Code[20];ContactNo@1003 : Code[20];var Contact@1001 :
    LOCAL procedure LookupContact(VendorNo: Code[20]; ContactNo: Code[20]; var Contact: Record 5050)
    var
        //       ContactBusinessRelation@1002 :
        ContactBusinessRelation: Record 5054;
    begin
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Vendor, VendorNo) then
            Contact.SETRANGE("Company No.", ContactBusinessRelation."Contact No.")
        else
            Contact.SETRANGE("Company No.", '');
        if ContactNo <> '' then
            if Contact.GET(ContactNo) then;
    end;


    procedure SendRecords()
    var
        //       DocumentSendingProfile@1000 :
        DocumentSendingProfile: Record 60;
        //       ReportSelections@1001 :
        ReportSelections: Record 77;
        //       DocTxt@1002 :
        DocTxt: Text[150];
        ReportSelectionUsage: Option;
    begin

        // Level := Level::Gold;
        //   OrdinalValue := Level.AsInteger();  // Ordinal value = 30
        //   Index := Level.Ordinals.IndexOf(OrdinalValue);  // Index = 3
        //   LevelName := Level.Names.Get(Index); // Name = Gold
        ReportSelectionUsage := ConvertDocumentTypeToOption(ReportSelections.Usage);
        //GetReportSelectionsUsageFromDocumentType(ReportSelections.Usage, DocTxt);
        GetReportSelectionsUsageFromDocumentType(ReportSelectionUsage, DocTxt);



        // DocumentSendingProfile.SendVendorRecords(
        //   ReportSelections.Usage, Rec, DocTxt, "Vendor No.", "No.",
        //   FIELDNO("Vendor No."), FIELDNO("No."));
        DocumentSendingProfile.SendVendorRecords(
          ReportSelections.Usage.AsInteger(), Rec, DocTxt, "Vendor No.", "No.",
          FIELDNO("Vendor No."), FIELDNO("No."));
    end;

    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Report Selection Usage"): Option;
    var
        optionValue: Option "S.Quote","S.Order","S.Invoice","S.Cr.Memo","S.Test","P.Quote","P.Order","P.Invoice","P.Cr.Memo","P.Receipt","P.Ret.Shpt.","P.Test","B.Stmt","B.Recon.Test","B.Check","Reminder","Fin.Charge","Rem.Test","F.C.Test","Prod.Order","S.Blanket","P.Blanket","M1","M2","M3","M4","Inv1","Inv2","Inv3","SM.Quote","SM.Order","SM.Invoice","SM.Credit Memo","SM.Contract Quote","SM.Contract","SM.Test","S.Return","P.Return","S.Shipment","S.Ret.Rcpt.","S.Work Order","Invt.Period Test","SM.Shipment","S.Test Prepmt.","P.Test Prepmt.","S.Arch.Quote","S.Arch.Order","P.Arch.Quote","P.Arch.Order","S.Arch.Return","P.Arch.Return","Asm.Order","P.Asm.Order","S.Order Pick Instruction","Posted Payment Reconciliation","P.V.Remit.","C.Statement","V.Remittance","JQ","S.Invoice Draft","Pro Forma S. Invoice","S.Arch.Blanket","P.Arch.Blanket","Phys.Invt.Order Test","Phys.Invt.Order","P.Phys.Invt.Order","Phys.Invt.Rec.","P.Phys.Invt.Rec.","Inventory Shipment","Inventory Receipt","P.Inventory Shipment","P.Inventory Receipt","P.Direct Transfer";
    begin
        case DocumentType of
            DocumentType::"S.Quote":
                optionValue := optionValue::"S.Quote";
            DocumentType::"S.Order":
                optionValue := optionValue::"S.Order";
            DocumentType::"S.Invoice":
                optionValue := optionValue::"S.Invoice";
            DocumentType::"S.Cr.Memo":
                optionValue := optionValue::"S.Cr.Memo";
            DocumentType::"S.Test":
                optionValue := optionValue::"S.Test";
            DocumentType::"P.Quote":
                optionValue := optionValue::"P.Quote";
            DocumentType::"P.Order":
                optionValue := optionValue::"P.Order";
            DocumentType::"P.Invoice":
                optionValue := optionValue::"P.Invoice";
            DocumentType::"P.Cr.Memo":
                optionValue := optionValue::"P.Cr.Memo";
            DocumentType::"P.Receipt":
                optionValue := optionValue::"P.Receipt";
            DocumentType::"P.Ret.Shpt.":
                optionValue := optionValue::"P.Ret.Shpt.";
            DocumentType::"P.Test":
                optionValue := optionValue::"P.Test";
            DocumentType::"B.Stmt":
                optionValue := optionValue::"B.Stmt";
            DocumentType::"B.Recon.Test":
                optionValue := optionValue::"B.Recon.Test";
            DocumentType::"B.Check":
                optionValue := optionValue::"B.Check";
            DocumentType::"Reminder":
                optionValue := optionValue::"Reminder";
            DocumentType::"Fin.Charge":
                optionValue := optionValue::"Fin.Charge";
            DocumentType::"Rem.Test":
                optionValue := optionValue::"Rem.Test";
            DocumentType::"F.C.Test":
                optionValue := optionValue::"F.C.Test";
            DocumentType::"Prod.Order":
                optionValue := optionValue::"Prod.Order";
            DocumentType::"S.Blanket":
                optionValue := optionValue::"S.Blanket";
            DocumentType::"P.Blanket":
                optionValue := optionValue::"P.Blanket";
            DocumentType::"M1":
                optionValue := optionValue::"M1";
            DocumentType::"M2":
                optionValue := optionValue::"M2";
            DocumentType::"M3":
                optionValue := optionValue::"M3";
            DocumentType::"M4":
                optionValue := optionValue::"M4";
            DocumentType::"Inv1":
                optionValue := optionValue::"Inv1";
            DocumentType::"Inv2":
                optionValue := optionValue::"Inv2";
            DocumentType::"Inv3":
                optionValue := optionValue::"Inv3";
            DocumentType::"SM.Quote":
                optionValue := optionValue::"SM.Quote";
            DocumentType::"SM.Order":
                optionValue := optionValue::"SM.Order";
            DocumentType::"SM.Invoice":
                optionValue := optionValue::"SM.Invoice";
            DocumentType::"SM.Credit Memo":
                optionValue := optionValue::"SM.Credit Memo";
            DocumentType::"SM.Contract Quote":
                optionValue := optionValue::"SM.Contract Quote";
            DocumentType::"SM.Contract":
                optionValue := optionValue::"SM.Contract";
            DocumentType::"SM.Test":
                optionValue := optionValue::"SM.Test";
            DocumentType::"S.Return":
                optionValue := optionValue::"S.Return";
            DocumentType::"P.Return":
                optionValue := optionValue::"P.Return";
            DocumentType::"S.Shipment":
                optionValue := optionValue::"S.Shipment";
            DocumentType::"S.Ret.Rcpt.":
                optionValue := optionValue::"S.Ret.Rcpt.";
            DocumentType::"S.Work Order":
                optionValue := optionValue::"S.Work Order";
            DocumentType::"Invt.Period Test":
                optionValue := optionValue::"Invt.Period Test";
            DocumentType::"SM.Shipment":
                optionValue := optionValue::"SM.Shipment";
            DocumentType::"S.Test Prepmt.":
                optionValue := optionValue::"S.Test Prepmt.";
            DocumentType::"P.Test Prepmt.":
                optionValue := optionValue::"P.Test Prepmt.";
            DocumentType::"S.Arch.Quote":
                optionValue := optionValue::"S.Arch.Quote";
            DocumentType::"S.Arch.Order":
                optionValue := optionValue::"S.Arch.Order";
            DocumentType::"P.Arch.Quote":
                optionValue := optionValue::"P.Arch.Quote";
            DocumentType::"P.Arch.Order":
                optionValue := optionValue::"P.Arch.Order";
            DocumentType::"S.Arch.Return":
                optionValue := optionValue::"S.Arch.Return";
            DocumentType::"P.Arch.Return":
                optionValue := optionValue::"P.Arch.Return";
            DocumentType::"Asm.Order":
                optionValue := optionValue::"Asm.Order";
            DocumentType::"P.Asm.Order":
                optionValue := optionValue::"P.Asm.Order";
            DocumentType::"S.Order Pick Instruction":
                optionValue := optionValue::"S.Order Pick Instruction";
            DocumentType::"Posted Payment Reconciliation":
                optionValue := optionValue::"Posted Payment Reconciliation";
            DocumentType::"P.V.Remit.":
                optionValue := optionValue::"P.V.Remit.";
            DocumentType::"C.Statement":
                optionValue := optionValue::"C.Statement";
            DocumentType::"V.Remittance":
                optionValue := optionValue::"V.Remittance";
            DocumentType::"JQ":
                optionValue := optionValue::"JQ";
            DocumentType::"S.Invoice Draft":
                optionValue := optionValue::"S.Invoice Draft";
            DocumentType::"Pro Forma S. Invoice":
                optionValue := optionValue::"Pro Forma S. Invoice";
            DocumentType::"S.Arch.Blanket":
                optionValue := optionValue::"S.Arch.Blanket";
            DocumentType::"P.Arch.Blanket":
                optionValue := optionValue::"P.Arch.Blanket";
            DocumentType::"Phys.Invt.Order Test":
                optionValue := optionValue::"Phys.Invt.Order Test";
            DocumentType::"Phys.Invt.Order":
                optionValue := optionValue::"Phys.Invt.Order";
            DocumentType::"P.Phys.Invt.Order":
                optionValue := optionValue::"P.Phys.Invt.Order";
            DocumentType::"Phys.Invt.Rec.":
                optionValue := optionValue::"Phys.Invt.Rec.";
            DocumentType::"P.Phys.Invt.Rec.":
                optionValue := optionValue::"P.Phys.Invt.Rec.";
            DocumentType::"Inventory Shipment":
                optionValue := optionValue::"Inventory Shipment";
            DocumentType::"Inventory Receipt":
                optionValue := optionValue::"Inventory Receipt";
            DocumentType::"P.Inventory Shipment":
                optionValue := optionValue::"P.Inventory Shipment";
            DocumentType::"P.Inventory Receipt":
                optionValue := optionValue::"P.Inventory Receipt";
            DocumentType::"P.Direct Transfer":
                optionValue := optionValue::"P.Direct Transfer";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    //..


    //     procedure PrintRecords (ShowRequestForm@1002 :
    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        //       DocumentSendingProfile@1001 :
        DocumentSendingProfile: Record 60;
        //       DummyReportSelections@1000 :
        DummyReportSelections: Record 77;
    begin
        DocumentSendingProfile.TrySendToPrinterVendor(
          DummyReportSelections.Usage::"P.Order".AsInteger(), Rec, FIELDNO("Vendor No."), ShowRequestForm);
    end;


    //     procedure SendProfile (var DocumentSendingProfile@1000 :
    procedure SendProfile(var DocumentSendingProfile: Record 60)
    var
        //       DummyReportSelections@1001 :
        DummyReportSelections: Record 77;
    begin
        DocumentSendingProfile.SendVendor(
          DummyReportSelections.Usage::"P.Order".AsInteger(), Rec, "No.", "Vendor No.",
          PurchOrderDocTxt, FIELDNO("Vendor No."), FIELDNO("No."));
    end;

    LOCAL procedure SetDefaultPurchaser()
    var
        //       UserSetup@1000 :
        UserSetup: Record 91;
    begin
        if not UserSetup.GET(USERID) then
            exit;

        if UserSetup."Salespers./Purch. Code" <> '' then
            if SalespersonPurchaser.GET(UserSetup."Salespers./Purch. Code") then
                if not SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    VALIDATE("Purchaser Code", UserSetup."Salespers./Purch. Code");
    end;


    //     procedure OnAfterValidateBuyFromVendorNo (var PurchaseHeader@1000 : Record 7206937;var xPurchaseHeader@1001 :
    procedure OnAfterValidateBuyFromVendorNo(var PurchaseHeader: Record 7206937; var xPurchaseHeader: Record 7206937)
    begin
        if PurchaseHeader.GETFILTER("Vendor No.") = xPurchaseHeader."Vendor No." then
            if PurchaseHeader."Vendor No." <> xPurchaseHeader."Vendor No." then
                PurchaseHeader.SETRANGE("Vendor No.");
    end;


    procedure SetAllowSelectNoSeries()
    begin
        SelectNoSeriesAllowed := TRUE;
    end;

    //     LOCAL procedure SetPurchaserCode (PurchaserCodeToCheck@1000 : Code[20];var PurchaserCodeToAssign@1001 :
    LOCAL procedure SetPurchaserCode(PurchaserCodeToCheck: Code[20]; var PurchaserCodeToAssign: Code[20])
    begin
        if PurchaserCodeToCheck <> '' then begin
            if SalespersonPurchaser.GET(PurchaserCodeToCheck) then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    PurchaserCodeToAssign := ''
                else
                    PurchaserCodeToAssign := PurchaserCodeToCheck;
        end else
            PurchaserCodeToAssign := '';
    end;


    //     procedure ValidatePurchaserOnPurchHeader (PurchaseHeader2@1000 : Record 7206937;IsTransaction@1001 : Boolean;IsPostAction@1002 :
    procedure ValidatePurchaserOnPurchHeader(PurchaseHeader2: Record 7206937; IsTransaction: Boolean; IsPostAction: Boolean)
    begin
        if PurchaseHeader2."Purchaser Code" <> '' then
            if SalespersonPurchaser.GET(PurchaseHeader2."Purchaser Code") then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then begin
                    if IsTransaction then
                        ERROR(SalespersonPurchaser.GetPrivacyBlockedTransactionText(SalespersonPurchaser, IsPostAction, FALSE));
                    if not IsTransaction then
                        ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser, FALSE));
                end;
    end;

    //     LOCAL procedure GetReportSelectionsUsageFromDocumentType (var ReportSelectionsUsage@1000 : Option;var DocTxt@1001 :
    LOCAL procedure GetReportSelectionsUsageFromDocumentType(var ReportSelectionsUsage: Option; var DocTxt: Text[150])
    var
        //       ReportSelections@1002 :
        ReportSelections: Record 77;
    begin
        /////ReportSelectionsUsage := ReportSelections.Usage::"P.Quote";
        /////DocTxt := PurchQuoteDocTxt;
    end;


    procedure CheckForBlockedLines()
    var
        //       Item@1000 :
        Item: Record 27;
    begin
        QBBlanketPurchaseLines.RESET;
        QBBlanketPurchaseLines.SETRANGE("Document No.", "No.");
        QBBlanketPurchaseLines.SETRANGE(Type, QBBlanketPurchaseLines.Type::Item);
        QBBlanketPurchaseLines.SETFILTER("No.", '<>''''');
        if QBBlanketPurchaseLines.FINDSET then
            repeat
                Item.GET(QBBlanketPurchaseLines."No.");
                Item.TESTFIELD(Blocked, FALSE);
            until QBBlanketPurchaseLines.NEXT = 0;
    end;

    //     procedure ShowCompanyList (QBBlanketPurchHdr@1100286002 :
    procedure ShowCompanyList(QBBlanketPurchHdr: Record 7206937)
    var
        //       QBBlanketPurchCompany@1100286001 :
        QBBlanketPurchCompany: Record 7206939;
        //       QBBlanketOrderCompanies@1100286000 :
        QBBlanketOrderCompanies: Page 7206995;
    begin
        //Q12867 -
        QBBlanketPurchHdr.TESTFIELD("Use In", QBBlanketPurchHdr."Use In"::Some);
        QBBlanketPurchCompany.FILTERGROUP(2);
        QBBlanketPurchCompany.SETRANGE("Document No.", QBBlanketPurchHdr."No.");
        QBBlanketPurchCompany.FILTERGROUP(0);
        //Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco.begin
        //if QBBlanketPurchHdr.OLD_Status = QBBlanketPurchHdr.OLD_Status::Closed then
        if QBBlanketPurchHdr.Status = QBBlanketPurchHdr.Status::Closed then
            //Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco.end
            QBBlanketOrderCompanies.EDITABLE(FALSE);
        QBBlanketOrderCompanies.SETTABLEVIEW(QBBlanketPurchCompany);
        QBBlanketOrderCompanies.RUNMODAL;
        //Q12867 +
    end;

    procedure CheckBlanketPurchStatus()
    begin
        //Q12867 -
        // //Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco.begin
        // //TESTFIELD(OLD_Status,OLD_Status::Active);
        // CASE TRUE OF
        //  "OLD_Approval Situation" = "OLD_Approval Situation"::Approved:
        //    TESTFIELD(Status, Status::Operative);
        //  else
        //    TESTFIELD(Status, Status::"Non-operational");
        // end;
        // //Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco.end
        // //12867 +

        TESTFIELD(Status, Status::"Non-operational");    //JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
    end;

    //     procedure CloseBlanketPurch (QBBlanketPurchHdr@1100286001 :
    procedure CloseBlanketPurch(QBBlanketPurchHdr: Record 7206937)
    var
        //       CloseBlackPurchHdrQst@1100286000 :
        CloseBlackPurchHdrQst: TextConst ENU = 'Would you like to close the Blanket Order %1?', ESP = '�Le gustar�a cerrar el contrato marco %1?';
    begin
        //12867 -
        if CONFIRM(STRSUBSTNO(CloseBlackPurchHdrQst, QBBlanketPurchHdr."No.")) then begin
            //Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco.begin
            QBBlanketPurchHdr.Status := QBBlanketPurchHdr.Status::Closed;
            //Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco.end
            QBBlanketPurchHdr.MODIFY;
        end;
        //12867 +
    end;

    /*begin
    //{
//      //Q12867 JDC 25/02/21 - Added function "ShowCompanyList", "CheckBlanketPurchStatus", "CloseBlanketPurch"
//                              Modified function "OnModify, "OnDelete"
//
//      Q17502 - CPA 30/06/2022: Ajustes y cambios en contratos marco
//                              Fields
//                                  Renamed 120 "OLD_Status"
//                                  Added: 26 "Status"
//                              Code
//                                  ShowCompanyList
//                                  CheckBlanketPurchStatus
//                                  CloseBlanketPurch
//      JAV 10/08/22: - QB 1.11.01 Se marcan aprobaciones con OLD y se cambia su manejo por el nuevo status
//    }
    end.
  */
}








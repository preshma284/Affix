table 7207329 "QBU Withholding Movements"
{


    CaptionML = ENU = 'Withholding Movements', ESP = 'Movimientos de retenci�n';
    LookupPageID = "Withholding Movements";
    DrillDownPageID = "Withholding Movements";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'N� mov.';
            Editable = false;


        }
        field(2; "Type"; Option)
        {
            OptionMembers = "Vendor","Customer";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Vendor,Customer', ESP = 'Proveedor,Cliente';

            Editable = false;


        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("Vendor")) "Vendor" ELSE IF ("Type" = CONST("Customer")) "Customer";


            CaptionML = ENU = 'No.', ESP = 'N�';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 Customer@1100286000 :
                Customer: Record 18;
                //                                                                 Vendor@1100286001 :
                Vendor: Record 23;
            BEGIN
                "Account Name" := '';
                CASE Type OF
                    Type::Customer:
                        BEGIN
                            IF (Customer.GET(Rec."No.")) THEN
                                "Account Name" := Customer.Name;
                        END;
                    Type::Vendor:
                        BEGIN
                            IF (Vendor.GET(Rec."No.")) THEN
                                "Account Name" := Vendor.Name;
                        END;
                END;
            END;


        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';
            Editable = false;


        }
        field(5; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';
            Editable = false;


        }
        field(6; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(7; "Withholding Type"; Option)
        {
            OptionMembers = "G.E","PIT";
            CaptionML = ENU = 'Withholding Type', ESP = 'Tipo retenci�n';
            OptionCaptionML = ENU = 'G.E,PIT', ESP = 'B.E.,IRPF';

            Editable = false;


        }
        field(8; "Withholding Code"; Code[20])
        {
            TableRelation = "Withholding Group";
            CaptionML = ENU = 'Withholding Code', ESP = 'C�digo retenci�n';
            Editable = false;


        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(10; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(11; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe (DL)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Global Dimension 1 Code', ESP = 'C�d. dimensi�n global 1';
            Editable = false;
            CaptionClass = '1,1,1';


        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Global Dimension 2 Code', ESP = 'C�d. dimensi�n global 2';
            Editable = false;
            CaptionClass = '1,1,2';


        }
        field(14; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';
            Editable = false;

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@1000 :
                LoginMgt: Codeunit "User Management 1";
            BEGIN
                LoginMgt.LookupUserID("User ID");
            END;


        }
        field(15; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';
            Editable = false;


        }
        field(16; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';


        }
        field(17; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha emisi�n documento';
            Editable = false;


        }
        field(18; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'N� documento externo';
            Editable = false;


        }
        field(19; "Withholding Base"; Decimal)
        {
            CaptionML = ENU = 'Withholding Base', ESP = 'Base de retenci�n';
            Editable = false;


        }
        field(20; "Open"; Boolean)
        {
            CaptionML = ENU = 'Open', ESP = 'Pendiente';
            Editable = false;


        }
        field(21; "Withholding Base (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Withholding Base (LCY)', ESP = 'Base de retenci�n (DL)';
            Editable = false;


        }
        field(22; "Withholding treating"; Option)
        {
            OptionMembers = "Withholding Payment","Pending Invoice","PIT";
            CaptionML = ENU = 'Withholding Treating', ESP = 'Tratamiento de retenci�n';
            OptionCaptionML = ENU = 'Withholding Payment, Pending Invoice,PIT', ESP = 'Retenci�n de pago,Pendiente Factura,IRPF';

            Editable = false;


        }
        field(23; "Release Date"; Date)
        {
            CaptionML = ENU = 'Release Date', ESP = 'Fecha liberaci�n';
            Editable = false;


        }
        field(24; "Released-to Document No."; Code[30])
        {


            CaptionML = ENU = 'Released-to Document No.', ESP = 'Liberado por n� documento';
            Editable = false;

            trigger OnValidate();
            BEGIN
                IF ("Released-to Doc. No" = '') THEN
                    "Released-to Doc. No" := ''
                ELSE BEGIN
                    "Released-to Document No." := '(' + FORMAT("Released-to Doc. Type") + ') ' + "Released-to Doc. No";
                    IF ("Released-to Bill No." <> '') THEN
                        "Released-to Document No." += '/' + "Released-to Bill No.";
                END;
            END;


        }
        field(25; "Applies-to ID"; Code[30])
        {
            CaptionML = ENU = 'Apply-to ID', ESP = 'Liq por Id.';
            Editable = false;


        }
        field(26; "Released-to Movement No."; Integer)
        {
            CaptionML = ENU = 'Released-to Movement No.', ESP = 'Liq. por n� de movimiento';
            Editable = false;


        }
        field(27; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. Grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(28; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            Editable = false;


        }
        field(29; "Movement No"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Movimiento de Origen';
            Description = 'JAV 29/10/19: - N�mero del movimiento de origen del registro';


        }
        field(30; "Withholding %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Retenci�n';
            Description = 'JAV 26/06/20: - Porcentaje de retenci�n aplicado';
            Editable = false;


        }
        field(31; "Released by Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Released-to Document No.', ESP = 'Liberado por importe';
            Description = 'JAV 26/05/20: - Importe por el que se ha liquidado el movimiento (base imponible de la factura registrada)';
            Editable = false;


        }
        field(32; "Job warranty end date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Job"."Job Guarrantee Date End" WHERE("No." = FIELD("Job No.")));
            CaptionML = ESP = 'Fecha fin garantia del proyecto';
            Description = 'JAV 26/05/20: - Fecha de fin de garant�a del proyecto';
            Editable = false;


        }
        field(33; "Released-to Doc. Type"; Option)
        {
            OptionMembers = " ","ME","MF","FB","AB","FR","AR","L";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Released-to Document No.';
            OptionCaptionML = ESP = '" ,ME,MF,FB,AB,FR,AR,L"';

            Description = 'QB 1.05 JAV 03/07/20: Liberado por tipo de documento';
            Editable = false;


        }
        field(34; "Released-to Doc. No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.05 JAV 03/07/20: Liberado por N� de documento';
            Editable = false;


        }
        field(35; "Released-to Bill No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.05 JAV 03/07/20: Liberado por N� de efecto';
            Editable = false;


        }
        field(36; "QB_Unpaid"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Impagada';
            Description = 'QRE';


        }
        field(37; "QB Payment bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� de banco de pago';
            Description = 'QB 1.10.01';


        }
        field(38; "Document Type"; Option)
        {
            OptionMembers = "Invoice","CrMemo";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de documento';
            OptionCaptionML = ENU = 'Invoice,Credit Memo', ESP = 'Factura,Abono';

            Description = 'QB 1.10.28 JAV 26/03/22 Se a�ade el tipo de documento para no jugar con signos, as� factura = importe positivo, Abono= importe negativo';
            Editable = false;


        }
        field(39; "Account Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Description = 'QB 1.10.49 JAV 07/06/22 Se a�ade el nombre del cliente o proveedor directamente en la tabla para los filtros y b�squedas';
            Editable = false;


        }
        field(50; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.12.26 - JAV 13/12/22: - Estado de aprobaci�n';
            Editable = false;


        }
        field(51; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("Withholding"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.12.26 - JAV 13/12/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(52; "QB Approval Job No"; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto para la Aprobaci�n';
            Description = 'QB 1.12.26 - JAV 13/12/22 [TT] Indica el proyecto que se usar� para aprobar este documento, puede ser diferente al establecido para el documento en general';


        }
        field(53; "QB Approval Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("QB Approval Job No"),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'P.Presup. para la Aprobaci�n';
            Description = 'QB 1.12.26 - JAV 13/12/22 [TT] Indica la partida presupuestaria o la U.Obra que se usar� para aprobar este documento, puede ser diferente al establecido para el documento en general';


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "No.", "Posting Date", "Currency Code")
        {
            ;
        }
        key(key3; "Type", "No.", "Open")
        {
            SumIndexFields = "Amount";
        }
        key(key4; "Withholding Type", "Posting Date")
        {
            ;
        }
        key(key5; "Type", "Withholding Type", "No.")
        {
            SumIndexFields = "Amount";
        }
        key(key6; "Withholding Code", "No.", "Posting Date")
        {
            ;
        }
        key(key7; "Open", "Type", "No.", "Withholding Type", "Document No.", "Withholding treating", "Posting Date")
        {
            ;
        }
        key(key8; "Document No.", "Posting Date")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
        //       Text1100000@7001104 :
        Text1100000: TextConst ENU = 'Payment Discount (VAT Excl.)', ESP = '% Dto. P.P. (IVA exclu�do)';
        //       Text1100001@7001103 :
        Text1100001: TextConst ENU = 'Payment Discount (VAT Adjustment)', ESP = '% Dto. P.P. (IVA ajustado)';
        //       Text000@7001102 :
        Text000: TextConst ENU = 'must have the same sign as %1', ESP = 'debe tener el mismo signo que %1.';
        //       Text001@7001101 :
        Text001: TextConst ENU = 'must not be larger than %1', ESP = 'no debe ser mayor que %1.';

    //     procedure DrillDownOnEntries (var DtldVendLedgEntry@1000 :
    procedure DrillDownOnEntries(var DtldVendLedgEntry: Record 380)
    var
        //       VendLedgEntry@1001 :
        VendLedgEntry: Record 25;
    begin
        VendLedgEntry.RESET;
        DtldVendLedgEntry.COPYFILTER("Vendor No.", VendLedgEntry."Vendor No.");
        DtldVendLedgEntry.COPYFILTER("Currency Code", VendLedgEntry."Currency Code");
        DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 1", VendLedgEntry."Global Dimension 1 Code");
        DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 2", VendLedgEntry."Global Dimension 2 Code");
        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
        PAGE.RUN(0, VendLedgEntry);
    end;

    procedure ShowDimensions()
    var
        //       DimMgt@1000 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Entry No."));
    end;

    /*begin
    //{
//      JAV 07/03/19: - Se hacen no editables los campos que no deban tocarse por el usuario (casi todos)
//      JAV 29/10/19: - Se a�ade en campo con el N�mero del movimiento de origen del registro
//      LCG 06/10/21: - Q15417 QRE Se crea campo QB_Unpaid
//      JAV 07/06/22: - QB 1.10.49 Se crea el campo Account Name para el nombre del cliente o proveedor, y se rellena al crear el registro
//      JAV 13/12/22: - QB 1.12.26 Se a�anden para aprobaci�n los campos 50,51,52 y 53
//    }
    end.
  */
}








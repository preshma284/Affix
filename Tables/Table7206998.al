table 7206998 "QBU Prepayment Data"
{

    DataCaptionFields = "Entry No.", "Document No.";
    CaptionML = ENU = 'Prepayment', ESP = 'Lineas de Anticipos';
    LookupPageID = "QB Prepayment Edit SubForm";
    DrillDownPageID = "QB Prepayment Edit SubForm";

    fields
    {
        field(1; "Register No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'N� Registro';
            Description = 'Key 1 : Indica el n�mero del registro que estamos tratando';


        }
        field(2; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Movimiento Anticipo';
            Description = 'Key 2 : Indica sobre que anticipo estamos trabajando';


        }
        field(10; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = FILTER(<> Estudio & <> ' '));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';
            Editable = false;

            trigger OnLookup();
            VAR
                //                                                               JobNo@1100286000 :
                JobNo: Code[20];
            BEGIN
            END;


        }
        field(11; "Account Type"; Option)
        {
            OptionMembers = "Vendor","Customer";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Vendor,Customer', ESP = 'Proveedor,Cliente';

            Editable = false;


        }
        field(12; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("Vendor")) "Vendor" ELSE IF ("Account Type" = CONST("Customer")) "Customer";
            CaptionML = ENU = 'No.', ESP = 'Cuenta';
            Editable = false;


        }
        field(15; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Generated Document No.', ESP = 'N� documento Generado';
            Editable = false;


        }
        field(16; "Description"; Text[100])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(17; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Document Date" := "Posting Date";
            END;


        }
        field(18; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha emisi�n documento';
            Editable = false;


        }
        field(19; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'N� documento externo';
            Editable = false;


        }
        field(20; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(23; "Entry Type"; Option)
        {
            OptionMembers = "Invoice","Bill";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo de entrada';
            OptionCaptionML = ENU = 'Invoice,Bill', ESP = 'Factura,Efecto';

            Description = 'QB 1.10.49 JAV 09/06/22 Se amplian los estados con el de cancelado y se distribuyen de otra forma para poder a�adir mas';
            Editable = false;


        }
        field(30; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;


        }
        field(31; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe (DL)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(60; "Job Descripcion"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Descripcion', ESP = 'Descricpi�n del proyecto';
            Editable = false;


        }
        field(61; "Account Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Editable = false;


        }
        field(83; "Apply to Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aplicado al anticipo';
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica sobre que l�nea de anticipo se ha aplicado una entrada, si no est� indicada se hizo sobre el total de anticipos y no sobre uno particular';
            Editable = false;


        }
        field(84; "Applied Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Apply to Entry No." = FIELD("Entry No.")));
            CaptionML = ESP = 'Importe Aplicado';
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica el importe aplicado al documento, sumando las aplicaciones y cancelaciones';
            Editable = false;


        }
        field(100; "To Apply Type"; Option)
        {
            OptionMembers = "Apply","Cancel";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo a aplicar';

            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica si es aplicaci�n o cancelaci�n';


        }
        field(101; "To Apply %"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = '% a Aplicar';
            DecimalPlaces = 2 : 6;
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica el porcentaje que se desea aplicar o cancelar sobre el importe pendiente de este anticipo';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Applied Amount");
                "To Apply Amount" := ROUND((Amount + "Applied Amount") * "To Apply %" / 100, 0.01);
                ToAppyMountDescription;
            END;


        }
        field(102; "To Apply Amount"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe a Aplicar';
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica el importe que se desea aplicar o cancelar sobre el importe pendiente de este anticipo';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Applied Amount");
                IF ("To Apply Amount" < 0) THEN
                    ERROR('No puede aplicar importes negativos');
                IF ("To Apply Amount" > Amount + "Applied Amount") THEN
                    ERROR('No puede aplicar mas importe del pendiente');

                IF (Amount + "Applied Amount" = 0) THEN
                    "To Apply %" := 0
                ELSE
                    "To Apply %" := ("To Apply Amount" * 100) / (Amount + "Applied Amount");
                ToAppyMountDescription;
            END;


        }
        field(103; "To Apply Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripci�n';
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica la descripci�n que se desea usar en el asiento de aplicaci�n o cancelaci�n';


        }
    }
    keys
    {
        key(key1; "Register No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Register No.")
        {

        }
        fieldgroup(Brick; "Register No.")
        {

        }
    }

    var
        //       QuoBuildingSetup@1100286020 :
        QuoBuildingSetup: Record 7207278;
        //       QBPrepaymentType@1100286001 :
        QBPrepaymentType: Record 7206993;
        //       Job@1100286003 :
        Job: Record 167;
        //       Customer@1100286004 :
        Customer: Record 18;
        //       Vendor@1100286005 :
        Vendor: Record 23;
        //       GeneralLedgerSetup@1100286002 :
        GeneralLedgerSetup: Record 98;
        //       PaymentMethod@1100286022 :
        PaymentMethod: Record 289;
        //       PaymentTerms@1100286023 :
        PaymentTerms: Record 3;
        //       FunctionQB@1100286009 :
        FunctionQB: Codeunit 7207272;
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
        //       JobCurrencyExchangeFunction@1100286008 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       QBPrepaymentManagement@1100286021 :
        QBPrepaymentManagement: Codeunit 7207300;
        //       DueDateAdjust@1100286024 :
        DueDateAdjust: Codeunit 10700;
        //       Amt@1100286007 :
        Amt: Decimal;
        //       Factor@1100286006 :
        Factor: Decimal;
        //       Txt000@1100286019 :
        Txt000: TextConst ESP = '   Total %1 %2 del Proyecto %3';
        //       Txt001@1100286018 :
        Txt001: TextConst ESP = '      Total %1 del Proyecto %2';
        //       Text02@1100286000 :
        Text02: TextConst ESP = 'No tiene acceso al proyecto %1';
        //       Txt010@1100286011 :
        Txt010: TextConst ESP = 'No ha definido el proyecto';
        //       Txt011c@1100286015 :
        Txt011c: TextConst ESP = 'Debe indicar un cliente v�lido';
        //       Txt011p@1100286014 :
        Txt011p: TextConst ESP = 'Debe indicar un proveedor v�lido';
        //       Txt012@1100286010 :
        Txt012: TextConst ESP = 'El importe debe ser mayor de cero';
        //       Txt013@1100286013 :
        Txt013: TextConst ESP = 'Debe indicar una fecha v�lida de documento y de registro';
        //       Txt014@1100286012 :
        Txt014: TextConst ESP = 'La fecha de documento no puede ser mayor a la de registro';
        //       Txt015@1100286016 :
        Txt015: TextConst ESP = 'Debe indicar el n� de documento del proveedor';
        //       Txt016@1100286017 :
        Txt016: TextConst ESP = 'Debe indicar el n�mero de documento del que solicita el anticipo';
        //       Txt020@1100286028 :
        Txt020: TextConst ESP = 'Liq.Parcial anticipo %1, pte. %2';
        //       Txt021@1100286027 :
        Txt021: TextConst ESP = 'Liquidaci�n del anticipo %1';
        //       Txt030@1100286026 :
        Txt030: TextConst ESP = 'Canc.Parcial anticipo %1, pte. %2';
        //       Txt031@1100286025 :
        Txt031: TextConst ESP = 'Cancelaci�n del anticipo %1';

    LOCAL procedure MountDescription()
    var
        //       txtAmount@1100286006 :
        txtAmount: Text;
        //       txt@1100286002 :
        txt: Text;
        //       Txt011@1100286005 :
        Txt011: TextConst ESP = '%1% sobre %2';
        //       Txt012@1100286004 :
        Txt012: TextConst ESP = 'Sobre %1';
        //       Txt013@1100286003 :
        Txt013: TextConst ESP = 'del %1%';
        //       i@1100286001 :
        i: Integer;
    begin
    end;

    procedure CheckData()
    begin
    end;

    //     LOCAL procedure StrPad (pText@1100286000 : Text;pLen@1100286001 : Integer;pCar@1100286002 :
    LOCAL procedure StrPad(pText: Text; pLen: Integer; pCar: Text): Text;
    begin
        exit(PADSTR(pText, pLen, pCar));
    end;

    //     LOCAL procedure NumPad (pInteger@1100286000 : Integer;pLen@1100286001 :
    LOCAL procedure NumPad(pInteger: Integer; pLen: Integer): Text;
    var
        //       txt@1100286002 :
        txt: Text;
    begin
        txt := PADSTR('', pLen, '0') + FORMAT(pInteger);
        exit(COPYSTR(txt, STRLEN(txt) - pLen));
    end;

    LOCAL procedure ToAppyMountDescription()
    var
        //       txt@1100286000 :
        txt: Text;
    begin
        txt := '';
        if (Rec."To Apply Amount" <> 0) then begin
            CALCFIELDS("Applied Amount");

            if (Rec."To Apply Type" = Rec."To Apply Type"::Apply) then begin
                if (Amount + "Applied Amount" <> "To Apply Amount") then
                    txt := STRSUBSTNO(Txt020, "Document No.", FORMAT(Amount + "Applied Amount", 0, '<Precision,2:2><Standard Format,0>'))
                else
                    txt := STRSUBSTNO(Txt021, "Document No.");
            end;

            if (Rec."To Apply Type" = Rec."To Apply Type"::Cancel) then begin
                if (Amount + "Applied Amount" <> "To Apply Amount") then
                    txt := STRSUBSTNO(Txt030, "Document No.", FORMAT(Amount + "Applied Amount", 0, '<Precision,2:2><Standard Format,0>'))
                else
                    txt := STRSUBSTNO(Txt031, "Document No.");
            end;

        end;
        "To Apply Description" := COPYSTR(txt, 1, MAXSTRLEN("To Apply Description"));
    end;

    /*begin
    //{
//      JAV 13/06/22: - QB 1.10.49 Nueva tabla para l�neas de aplicaci�n/cancelaci�n de anticipos, relaciona un registro de compra o una anulaci�n con los antiocipos que se aplican o cancelan
//
//      OJO: Esta tabla est� relacionada con la tabla 7206928 "QB Prepayment", si se introducen campos hay que verificar la otra por el transferfield
//    }
    end.
  */
}








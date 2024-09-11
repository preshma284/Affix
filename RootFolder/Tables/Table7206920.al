table 7206920 "QB Debit Relations Lines"
{


    CaptionML = ENU = 'Debit Relations Lines', ESP = 'L�neas de Cobros a Clientes';

    fields
    {
        field(1; "Relacion No."; Code[20])
        {
            TableRelation = "QB Debit Relations Header";
            CaptionML = ENU = 'Journal Template Name', ESP = 'N� Relaci�n';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(10; "Type"; Option)
        {
            OptionMembers = "Amount","Bill","Invoice","Payment";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de l�nea';
            OptionCaptionML = ENU = 'Amount,Bill,Invoice,Payment', ESP = 'Importe,Efecto,Factura,Pago';

            Editable = false;


        }
        field(11; "Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha';
            Editable = false;


        }
        field(12; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(13; "Document Type"; Option)
        {
            OptionMembers = " ","Bill","Invoice","Credit Memo";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = '" ,Bill,Invoice,Credit Memo"', ESP = '" Efecto,Factura,Abono"';

            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 Cust@1000 :
                Cust: Record 18;
                //                                                                 Vend@1001 :
                Vend: Record 23;
            BEGIN
            END;


        }
        field(14; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';
            Editable = false;


        }
        field(15; "Bill No."; Code[10])
        {
            CaptionML = ENU = 'Bill No.', ESP = 'N� efecto';
            Editable = false;


        }
        field(16; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';
            Editable = false;


        }
        field(17; "No. Liquidation"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Liquidado por';
            Editable = false;


        }
        field(18; "Months"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Meses';


        }
        field(20; "Post"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Registrado';
            Editable = false;


        }
        field(22; "Post Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Pago Registrado';
            Editable = false;


        }
        field(24; "Received"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido';


        }
        field(30; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;


        }
        field(34; "Applied Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'importe Aplicado';


        }
        field(35; "Received Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Recibido';


        }
    }
    keys
    {
        key(key1; "Relacion No.", "Line No.")
        {
            MaintainSIFTIndex = false;
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Conf@1100286000 :
        Conf: Record 7207278;
        //       Cabecera@7001101 :
        Cabecera: Record 7206919;
        //       Lineas@7001110 :
        Lineas: Record 7206920;
        //       PaymentMethod@7001117 :
        PaymentMethod: Record 289;
        //       QBDebitRelations@1100286003 :
        QBDebitRelations: Codeunit 7207288;
        //       dimMgt@7001100 :
        dimMgt: Codeunit "DimensionManagement";
        //       texto@1100286001 :
        texto: Text;
        //       Salir@1100286002 :
        Salir: Boolean;



    trigger OnInsert();
    begin
        if ("Document Type" = "Document Type"::" ") then
            "Document No." := "Relacion No.";
    end;

    trigger OnDelete();
    var
        //                Text001@1100286002 :
        Text001: TextConst ESP = 'No puede eliminar l�neas de importe registradas';
        //                Text002@1100286000 :
        Text002: TextConst ESP = 'No puede eliminar efectos registrados';
        //                Text003@1100286003 :
        Text003: TextConst ESP = 'No puede eliminar este tipo de l�neas';
    begin
        // if (Type = Type::Amount) and ("Post Bill") then
        //  ERROR(Text001);
        // if (Type = Type::Bill) and ("Post Bill") then
        //  ERROR(Text002);
        // if (Type = Type::Invoice) then
        //  ERROR(Text003);
    end;



    /*begin
        end.
      */
}








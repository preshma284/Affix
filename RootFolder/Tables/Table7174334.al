table 7174334 "SII Document Line"
{


    ;
    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = " ","FE","FR","OS","CM","BI","OI","CE","PR";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo Documento';
            OptionCaptionML = ENU = '" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Metalico,Fact. Bienes Inv.,Fact. Op. Intracomunitaria,Cobro Factura,Pago Factura"', ESP = '" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Met�lico,Factura Bienes Inversi�n,Factura Op. Intracomunitaria,Cobro Factura Emitida,Pago Factura Recibida"';

            Description = 'Key 1';


        }
        field(2; "Document No."; Code[60])
        {
            TableRelation = "SII Documents"."Document No." WHERE("Document Type" = FIELD("Document Type"));
            CaptionML = ENU = 'Document No.', ESP = 'No. Documento';
            Description = 'Key 2';


        }
        field(3; "VAT Base"; Decimal)
        {
            CaptionML = ENU = 'Total Amount', ESP = 'Importe Total';
            DecimalPlaces = 2 : 2;


        }
        field(4; "% VAT"; Decimal)
        {
            CaptionML = ENU = '% VAT', ESP = '% IVA';
            Description = 'Key 6';


        }
        field(5; "VAT Amount"; Decimal)
        {
            CaptionML = ENU = 'VAT Amount', ESP = 'Importe IVA';


        }
        field(6; "% RE"; Decimal)
        {
            CaptionML = ENU = '% RE', ESP = '% RE';
            Description = 'Key 7';


        }
        field(7; "RE Amount"; Decimal)
        {
            CaptionML = ENU = 'RE Amount', ESP = 'Importe RE';


        }
        field(8; "Exent"; Boolean)
        {
            CaptionML = ENU = 'Exent', ESP = 'Exento';
            Description = 'Key 9';


        }
        field(9; "No Taxable VAT"; Boolean)
        {
            CaptionML = ENU = 'No Taxable VAT', ESP = 'No Sujeto';
            Description = 'Key 8';


        }
        field(10; "Inversión Sujeto Pasivo"; Boolean)
        {
            CaptionML = ENU = 'Passive Subject Investment', ESP = 'Inversion Sujeto Pasivo';
            Description = 'Key 11';


        }
        field(11; "Exent Type"; Code[20])
        {
            TableRelation = IF ("Exent" = CONST(true)) "SII Type List Value"."Code" WHERE("Type" = CONST("ExentType"),
                                                                                                                         "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'Exent Type', ESP = 'Tipo Exenta';


        }
        field(12; "ImpArt7_14_Otros"; Decimal)
        {
            CaptionML = ENU = 'ImpArt7_14_Other', ESP = 'ImpArt7_14_Otros';
            DecimalPlaces = 2 : 2;


        }
        field(13; "ImporteTAIReglasLocalizacion"; Decimal)
        {
            CaptionML = ENU = 'Localization Rules TAI Amount', ESP = 'Importe TAI Reglas Localizacion';
            DecimalPlaces = 2 : 2;


        }
        field(14; "No Exent Type"; Code[20])
        {
            TableRelation = IF ("Exent" = CONST(false)) "SII Type List Value"."Code" WHERE("Type" = FILTER("SujNoSuj"),
                                                                                                                        "SII Entity" = FIELD("SII Entity"));
            CaptionML = ENU = 'No Exent Type', ESP = 'Tipo No Exenta';


        }
        field(17; "Servicio"; Boolean)
        {
            CaptionML = ENU = 'Service', ESP = 'Servicio';
            Description = 'Key 10';


        }
        field(18; "Bienes"; Boolean)
        {
            CaptionML = ENU = 'Possessions', ESP = 'Bienes';


        }
        field(19; "VAT Registration No."; Code[20])
        {
            CaptionML = ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
            Description = 'Key 3';


        }
        field(20; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'No. Movimiento';
            Description = 'Key 4   QuoSII_02_07';


        }
        field(59; "SII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));
            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = '[           QuoSII_1.4.2.042]';


        }
        field(64; "Register Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de Registro';
            Description = 'Key 5   QuoSII 1.05n';


        }
    }
    keys
    {
        key(key1; "Document Type", "Document No.", "VAT Registration No.", "Entry No.", "Register Type", "% VAT", "% RE", "No Taxable VAT", "Exent", "Servicio", "Inversión Sujeto Pasivo")
        {
            Clustered = true;
        }
        key(key2; "Document Type", "Document No.", "No Taxable VAT", "Exent", "VAT Registration No.", "Entry No.")
        {
            SumIndexFields = "VAT Amount", "RE Amount";
        }
    }
    fieldgroups
    {
    }


    /*begin
    {
      QuoSII_1.3.02.005 17/11/08 MCM - Se incluye el campo Servicio en la clave primaria
      QuoSII 1.5z       26/06/21 JAV - Se incluyen los campos 30 a 33 para compatibilziar con la extensi�n
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
                                  Se eliminan validates que solo son comentarios o que solo tienen variables pero no c�digo
    }
    end.
  */
}








table 7206932 "QBU Payments Phases Doc"
{


    CaptionML = ENU = 'Payments Phases Lines', ESP = 'L�neas de las Fases de Pago';

    fields
    {
        field(2; "Document Type"; Enum "Purchase Document Type")
        {
            //OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            //OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';



        }
        field(3; "Document No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(4; "Line No."; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea';

            trigger OnValidate();
            BEGIN
                IF ("Line No." = 0) THEN BEGIN
                    QBPaymentsPhasesDoc.RESET;
                    QBPaymentsPhasesDoc.SETRANGE("Document Type", "Document Type");
                    QBPaymentsPhasesDoc.SETRANGE("Document No.", "Document No.");
                    IF (QBPaymentsPhasesDoc.FINDLAST) THEN
                        "Line No." := QBPaymentsPhasesDoc."Line No." + 1
                    ELSE
                        "Line No." := 1;
                END;
            END;


        }
        field(10; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripción';


        }
        field(11; "% Payment"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Pago';

            trigger OnValidate();
            BEGIN
                VALIDATE(Amount);
            END;


        }
        field(12; "Total %"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Payments Phases Doc"."% Payment" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                               "Document No." = FIELD("Document No.")));
            CaptionML = ESP = 'Total % Pago';
            Editable = false;


        }
        field(13; "Document Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Documento';
            Editable = false;


        }
        field(14; "Amount"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe';

            trigger OnValidate();
            BEGIN
                IF ("% Payment" <> 0) THEN BEGIN
                    Currency.InitRoundingPrecision;
                    Amount := ROUND("Document Amount" * "% Payment" / 100, Currency."Amount Rounding Precision");
                END;
                CALCFIELDS("Total %", "Total Amount");
            END;


        }
        field(15; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Payments Phases Doc"."Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                          "Document No." = FIELD("Document No.")));
            CaptionML = ESP = 'Total Importe';
            Editable = false;


        }
        field(16; "Used"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usado';
            Editable = false;


        }
        field(20; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha del Documento';
            Description = 'QB 1.07.19 JAV 05/01/20: - Fecha del documento';


        }
        field(21; "Cald Date"; Option)
        {
            OptionMembers = "Calculated","Document","Manual";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Calculo de Fecha';
            OptionCaptionML = ENU = 'Calculated,Document,Manual', ESP = 'Calculada,Del Documento,Manual';

            Description = 'QB 1.07.19 JAV 05/01/20: - Como se calcula la fecha';

            trigger OnValidate();
            BEGIN
                VALIDATE("Calculated Date");
            END;


        }
        field(22; "Date Formula"; DateFormula)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'F�rmula Fecha';
            Description = 'QB 1.07.19 JAV 05/01/20: - F�rmula para calcular la fecha';

            trigger OnValidate();
            BEGIN
                VALIDATE("Calculated Date");
            END;


        }
        field(23; "Calculated Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Calculada';
            Description = 'QB 1.07.19 JAV 05/01/20: - Fecha fija';

            trigger OnValidate();
            BEGIN
                //Pongo la fecha seg�n el tipo indicado
                CASE "Cald Date" OF
                    "Cald Date"::Document:
                        BEGIN
                            "Calculated Date" := "Document Date";
                        END;
                    "Cald Date"::Calculated:
                        BEGIN
                            QBPaymentsPhasesDoc.RESET;
                            QBPaymentsPhasesDoc.SETRANGE("Document Type", "Document Type");
                            QBPaymentsPhasesDoc.SETRANGE("Document No.", "Document No.");
                            QBPaymentsPhasesDoc.SETFILTER("Line No.", '<%1', "Line No.");
                            IF (QBPaymentsPhasesDoc.FINDLAST) THEN BEGIN
                                IF (QBPaymentsPhasesDoc."Calculated Date" <> 0D) AND (FORMAT("Date Formula") <> '') THEN BEGIN
                                    "Calculated Date" := CALCDATE("Date Formula", QBPaymentsPhasesDoc."Calculated Date");
                                END;
                            END;
                        END;
                END;

                //Recalculo las fechas de las fases restantes
                LastDate := "Calculated Date";
                QBPaymentsPhasesDoc.RESET;
                QBPaymentsPhasesDoc.SETRANGE("Document Type", "Document Type");
                QBPaymentsPhasesDoc.SETRANGE("Document No.", "Document No.");
                QBPaymentsPhasesDoc.SETFILTER("Line No.", '>%1', "Line No.");
                IF (QBPaymentsPhasesDoc.FINDSET) THEN BEGIN
                    IF (LastDate <> 0D) AND (FORMAT("Date Formula") <> '') THEN BEGIN
                        QBPaymentsPhasesDoc."Calculated Date" := CALCDATE(QBPaymentsPhasesDoc."Date Formula", LastDate);
                        QBPaymentsPhasesDoc.MODIFY;
                        LastDate := QBPaymentsPhasesDoc."Calculated Date";
                    END;
                END;
            END;


        }
        field(30; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';


        }
        field(31; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';


        }
        field(32; "Calc Due Date"; Option)
        {
            OptionMembers = "Standar","Document","Reception","Approval";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Calculo Vencimientos';
            OptionCaptionML = ENU = 'Standar,Document,Reception,Approval', ESP = 'Estandar,Fecha del Documento,Fecha de Recepci�n,Fecha de Aprobaci�n';

            Description = 'QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';

            trigger OnValidate();
            BEGIN
                IF ("Calc Due Date" <> "Calc Due Date"::Reception) THEN
                    "No. Days Calc Due Date" := 0;
            END;


        }
        field(33; "No. Days Calc Due Date"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� d�as tras Recepci�n';
            Description = 'QB 1.06 - JAV 12/07/20: - d�as adicionales para el c�lculo del vto de las fras de compra, ORTIZ';


        }
    }
    keys
    {
        key(key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QBPaymentsPhasesLines@1100286000 :
        QBPaymentsPhasesLines: Record 7206930;
        //       QBPaymentsPhasesDoc@1100286001 :
        QBPaymentsPhasesDoc: Record 7206932;
        //       Currency@1100286003 :
        Currency: Record 4;
        //       LastDate@1100286002 :
        LastDate: Date;



    trigger OnInsert();
    begin
        VALIDATE("Line No.");
    end;

    trigger OnModify();
    begin
        VALIDATE("Line No.");
    end;


    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Purchase Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
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
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;


    /*begin
        end.
      */
}








table 7206922 "QB Crear Efectos Cabecera"
{



    fields
    {
        field(1; "Relacion No."; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Relaci�n';

            trigger OnValidate();
            BEGIN
                IF ("Relacion No." = 0) THEN
                    INSERT(TRUE);
            END;


        }
        field(10; "Posting Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de Registro';

            trigger OnValidate();
            BEGIN
                SetDatosLineas;
            END;


        }
        field(12; "Bank Account No."; Code[20])
        {
            TableRelation = "Bank Account";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Banco';

            trigger OnValidate();
            BEGIN
                IF (xRec."Bank Account No." <> '') AND ("Bank Account No." <> xRec."Bank Account No.") THEN BEGIN
                    Bank.GET("Bank Account No.");
                    IF (Bank."Currency Code" <> "Currency Code") THEN BEGIN
                        Lineas.RESET;
                        Lineas.SETRANGE("Relacion No.", "Relacion No.");
                        IF (NOT Lineas.ISEMPTY) THEN
                            ERROR(txtQB000);
                    END;
                END;

                CALCFIELDS("Bank Account Name");
                Bank.GET("Bank Account No.");
                "Currency Code" := Bank."Currency Code";
                Report := Bank."Check Report ID";
                SetDatosLineas;
            END;


        }
        field(13; "Bank Account Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Bank Account"."Name" WHERE("No." = FIELD("Bank Account No.")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(14; "Currency Code"; Code[10])
        {
            CaptionML = ESP = 'Divisa';
            Editable = false;


        }
        field(18; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Crear Efectos Linea"."Importe Pendiente" WHERE("Relacion No." = FIELD("Relacion No.")));
            CaptionML = ESP = 'Importe Total';
            Editable = false;


        }
        field(19; "Total Payment Order Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Crear Efectos Linea"."Importe Pendiente" WHERE("Relacion No." = FIELD("Relacion No."),
                                                                                                                       "Include in Payment Order" = CONST(true)));
            CaptionML = ESP = 'Importe Total Orden Pago';
            Editable = false;


        }
        field(20; "Bank Payment Type"; Option)
        {
            OptionMembers = " ","Computer Check","Manual Check","OrdenPago";

            AccessByPermission = TableData 270 = R;
            CaptionML = ENU = 'Bank Payment Type', ESP = 'Tipo pago por banco';
            OptionCaptionML = ENU = '" ,Computer Check,Manual Check,Payment Order"', ESP = '" ,Pagar�s Impresos,Pagar�s manuales,Orden de Pago"';


            trigger OnValidate();
            BEGIN
                IF (xRec."Bank Payment Type" <> Rec."Bank Payment Type") THEN BEGIN
                    Lineas.RESET;
                    Lineas.SETRANGE("Relacion No.", "Relacion No.");
                    IF Lineas.FINDSET THEN
                        REPEAT
                            IF (Lineas."No. Pagare" <> '') OR (Lineas."Exported to Payment File") THEN
                                ERROR(txtQB001);
                        UNTIL Lineas.NEXT = 0;
                    Agrupar := ("Bank Payment Type" = "Bank Payment Type"::OrdenPago);
                    IF ("Bank Payment Type" <> "Bank Payment Type"::OrdenPago) THEN
                        Confirming := FALSE;
                END;
            END;


        }
        field(21; "Agrupar"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Agrupar por Vto.';


        }
        field(22; "Report"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Formato';

            trigger OnLookup();
            BEGIN
                CASE "Bank Payment Type" OF
                    "Bank Payment Type"::"Computer Check":
                        Report := QBReportSelections.GetReportSelected(QBReportSelections.Usage::G2);
                    "Bank Payment Type"::OrdenPago:
                        Report := QBReportSelections.GetReportSelected(QBReportSelections.Usage::G1);
                END;
            END;


        }
        field(23; "Confirming"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Confirming';


        }
        field(30; "Generados Pagarés"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Pagar�s generados';


        }
        field(31; "Generada N67"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(32; "Registrada"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(33; "OrdenPago"; Code[20])
        {
            TableRelation = "Payment Order";
            DataClassification = ToBeClassified;
            Editable = false;


        }
        field(34; "Fichero"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;


        }
        field(35; "Generado Confirming"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Generado Confirming';


        }
    }
    keys
    {
        key(key1; "Relacion No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       recAux@7001100 :
        recAux: Record 7206922;
        //       Lineas@7001101 :
        Lineas: Record 7206923;
        //       Bank@7001103 :
        Bank: Record 270;
        //       hayError@7001104 :
        hayError: Boolean;
        //       QBReportSelections@1100286000 :
        QBReportSelections: Record 7206901;
        //       txtQB000@1100286001 :
        txtQB000: TextConst ESP = 'No puede cambiar el tipo de divisa pues existen l�neas con otra divisa';
        //       txtQB001@1100286002 :
        txtQB001: TextConst ESP = 'No puede cambiar el tipo, ya hay pagar�s generados';
        //       txtQB002@1100286003 :
        txtQB002: TextConst ESP = 'No ha indicado la fecha de registro';
        //       txtQB003@1100286004 :
        txtQB003: TextConst ESP = 'No ha indicado tipo de pago.';
        //       txtQB004@1100286005 :
        txtQB004: TextConst ESP = 'Tiene l�neas con errores, rev�selas.';



    trigger OnInsert();
    begin
        recAux.RESET;
        if recAux.FINDLAST then
            "Relacion No." := recAux."Relacion No." + 1
        else
            "Relacion No." := 1;
        if ("Posting Date" = 0D) then
            "Posting Date" := WORKDATE;
    end;

    trigger OnModify();
    begin
        SetDatosLineas;
    end;

    trigger OnDelete();
    begin
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", "Relacion No.");
        if (Lineas.FINDSET) then
            repeat
                Lineas.DELETE(TRUE);
            until Lineas.NEXT = 0;
    end;



    procedure SetDatosLineas()
    begin
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", "Relacion No.");
        if Lineas.FINDSET then
            repeat
                Lineas.Registrada := Registrada;
                Lineas."Posting Date" := "Posting Date";
                Lineas.MODIFY;
            until Lineas.NEXT = 0;
    end;

    procedure VerificarErrores()
    begin
        if ("Posting Date" = 0D) then
            ERROR(txtQB002);
        if (Rec."Bank Payment Type" = "Bank Payment Type"::" ") then
            ERROR(txtQB003);

        hayError := FALSE;
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", "Relacion No.");
        if Lineas.FINDSET then
            repeat
                if (Lineas.BuscarErrores(FALSE)) then
                    hayError := TRUE;
            until Lineas.NEXT = 0;

        if (hayError) then
            ERROR(txtQB004);
    end;

    /*begin
    end.
  */
}








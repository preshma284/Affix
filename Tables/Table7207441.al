table 7207441 "QBU Guarantee"
{


    CaptionML = ENU = 'Guarantees', ESP = 'Garant�as';
    LookupPageID = "Guarantees List";
    DrillDownPageID = "Guarantees List";

    fields
    {
        field(1; "No."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesMgt.TestManual(QuoBuildingSetup."Guarantee Serial No.");
                    "No. Series" := '';
                END;
            END;


        }
        field(9; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Series', ESP = 'Nos. serie';
            Editable = false;


        }
        field(10; "Quote No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Estudio"),
                                                                            "Original Quote Code" = FILTER(= ''));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estudio';

            trigger OnValidate();
            BEGIN
                IF Job.GET("Quote No.") THEN BEGIN
                    Description := Job.Description;
                    Customer := Job."Bill-to Customer No.";
                END;
            END;


        }
        field(11; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';

            trigger OnValidate();
            BEGIN
                IF Job.GET("Job No.") THEN BEGIN
                    Description := Job.Description;
                    Customer := Job."Bill-to Customer No.";
                END;
            END;


        }
        field(12; "Customer"; Code[20])
        {
            TableRelation = "Customer";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cliente';


        }
        field(13; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripci�n';


        }
        field(14; "Type"; Code[10])
        {
            TableRelation = "Guarantee Type";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo';


        }
        field(15; "Date of Expiration"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha vencimiento';


        }
        field(16; "Date of last expenses calc"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ultimo c�culo de intereses';
            Editable = false;


        }
        field(17; "Guarantee No."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� p�liza';


        }
        field(18; "Guarantee No. Esp."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� registro especial';


        }
        field(40; "Provisional Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Importe';


        }
        field(41; "Provisional Emisions costs"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Gastos de emisi�n';


        }
        field(42; "Provisional Months payment"; DateFormula)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Cada cuanto paga intereses';


        }
        field(43; "Provisional Amount per period"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Importe por periodo';


        }
        field(44; "Provisional Status"; Option)
        {
            OptionMembers = " ","Requested","Deposited","Canceled","Definitive";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Estado';
            OptionCaptionML = ENU = '" ,Requested,Deposited,Canceled,Create Definitive"', ESP = '" ,Solicitada,Depositada,Cancelada,Pasada a Defintiva"';

            Editable = true;


        }
        field(45; "Provisional final cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Gastos Cancelaci�n';


        }
        field(46; "Provisional Total Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Guarantee Lines"."Financial Amount" WHERE("No." = FIELD("No."),
                                                                                                               "Line Type" = CONST("ProvGastos")));
            CaptionML = ESP = 'Provisional Gatos Totales';
            Editable = false;


        }
        field(47; "Provisional Date ofApplication"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Fecha solicitud';
            Editable = false;


        }
        field(48; "Provisional Date of Issue"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Fecha dep�sito';
            Editable = false;


        }
        field(49; "Provisional Date of request"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Fecha solitcitud devoluci�n';
            Editable = false;


        }
        field(50; "Provisional Date of return"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Fecha devoluci�n';
            Editable = false;


        }
        field(51; "Provisional Status Text"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Estado';


        }
        field(53; "Provisional Expenses Forecast"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Provisional Previsi�n Gastos';


        }
        field(70; "Definitive Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Importe';


        }
        field(71; "Definitive Emisions costs"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Gastos de emisi�n';


        }
        field(72; "Definitive Months payment"; DateFormula)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Cada cuanto paga intereses';


        }
        field(73; "Definitive Amount per period"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Importe por periodo';


        }
        field(74; "Definitive Status"; Option)
        {
            OptionMembers = " ","Requested","Deposited","Canceled";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Estado';
            OptionCaptionML = ENU = '" ,Requested,Deposited,Canceled"', ESP = '" ,Solicitada,Depositada,Cancelada"';

            Editable = true;


        }
        field(75; "Definitive final cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Gastos Cancelaci�n';


        }
        field(76; "Definitive Total Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Guarantee Lines"."Financial Amount" WHERE("No." = FIELD("No."),
                                                                                                               "Line Type" = CONST("DefGastos")));
            CaptionML = ESP = 'Definiva Gatos Totales';
            Editable = false;


        }
        field(77; "Definitive Date of Application"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Defintiva Fecha solicitud';
            Editable = false;


        }
        field(78; "Definitive Date of Issue"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Defintiva Fecha dep�sito';
            Editable = false;


        }
        field(79; "Definitive Date of request"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Defintiva Fecha solitcitud devoluci�n';
            Editable = false;


        }
        field(80; "Definitive Date of return"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Defintiva Fecha devoluci�n';
            Editable = false;


        }
        field(81; "Definitive Status Text"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Estado';


        }
        field(82; "Definitive Seized amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Defintiva Importe Incautado';


        }
        field(83; "Definitive Expenses Forecast"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Definitiva Previsi�n Gastos';


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
        //       QuoBuildingSetup@1100286000 :
        QuoBuildingSetup: Record 7207278;
        //       Job@1100286002 :
        Job: Record 167;
        //       GuaranteeLines@1100286003 :
        GuaranteeLines: Record 7207442;
        //       NoSeriesMgt@1100286001 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";



    trigger OnInsert();
    begin
        QuoBuildingSetup.GET;
        if "No." = '' then begin
            QuoBuildingSetup.TESTFIELD(QuoBuildingSetup."Guarantee Serial No.");
            NoSeriesMgt.InitSeries(QuoBuildingSetup."Guarantee Serial No.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        SetStatus;
    end;

    trigger OnModify();
    begin
        SetStatus;
    end;

    trigger OnDelete();
    begin
        GuaranteeLines.RESET;
        GuaranteeLines.SETRANGE("No.", "No.");
        GuaranteeLines.DELETEALL;
    end;



    LOCAL procedure SetStatus()
    begin
        if ("Provisional Status" = "Provisional Status"::" ") then
            "Provisional Status Text" := ''
        else
            "Provisional Status Text" := FORMAT("Provisional Status");

        if ("Definitive Status" = "Definitive Status"::" ") then
            "Definitive Status Text" := ''
        else
            "Definitive Status Text" := FORMAT("Definitive Status");
    end;

    /*begin
    end.
  */
}








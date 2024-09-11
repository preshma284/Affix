table 7207420 "QBU Vendor Conditions"
{


    CaptionML = ENU = 'Vendor Conditions', ESP = 'Condiciones del Proveedor';
    LookupPageID = "Vendor Conditions List";
    DrillDownPageID = "Vendor Conditions List";

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = Vendor WHERE("QB Employee" = CONST(false));


            CaptionML = ENU = 'Vendor No.', ESP = 'N� Proveedor';

            trigger OnValidate();
            BEGIN
                CheckVendor("Vendor No.");
            END;


        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea';
            Description = 'JAV 11/11/19: - Para poder tener registros por rangos de fechas, nro correlativo autom�tico';


        }
        field(10; "Order"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Orden';
            Description = 'JAV 26/11/19: - Orden para presentar en pantalla los datos';


        }
        field(11; "Use Generals"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar condiciones Generales';
            Description = 'JAV 07/11/19: - Nuevo campo "Use Generals" que indica si se usar�n las condiciones generales del proveedor o estas particulares';

            trigger OnValidate();
            BEGIN
                IF ("Use Generals") THEN BEGIN
                    SetDefaultFields;

                    DeleteOtherConditions;
                    InsertOtherConditionsPR;
                END;
            END;


        }
        field(12; "Date Init"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de inicio';


        }
        field(13; "Date End"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de fin';


        }
        field(14; "Other Conditions"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Data Other Conditions" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                    "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Otras Condiciones', ESP = 'Otras Condiciones';
            Editable = false;


        }
        field(15; "Import Other Conditions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Other Conditions"."Amount" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                         "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Importe otras condiciones', ESP = 'Importe otras condiciones';
            Editable = false;


        }
        field(16; "Activity Code"; Code[20])
        {
            TableRelation = "Vendor Quality Data"."Activity Code" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                              "Activity Code" = FIELD("Activity Code"));


            CaptionML = ENU = 'Activity Code', ESP = 'C�d. Actividad';
            Description = 'JAV 07/11/19: - Si est� en blanco, son las generales del proveedor para todas las actividades';

            trigger OnValidate();
            BEGIN
                SetDefaultFields;
            END;


        }
        field(17; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';
            Description = 'JAV 14/11/19: - Condiciones de un proyecto o proyecto/actividad';

            trigger OnValidate();
            BEGIN
                SetDefaultFields;
            END;


        }
        field(18; "Import General Conditions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Other Conditions"."Amount" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                                         "Line No." = CONST(0)));
            CaptionML = ENU = 'Importe otras condiciones', ESP = 'Importe condiciones generales';
            Description = 'JAV 16/11/19: - Suma de los importes de las condiciones generales del proveedor';
            Editable = false;


        }
        field(20; "Validity Quotes"; DateFormula)
        {
            CaptionML = ENU = 'Validez ofertas', ESP = 'Validez ofertas';


        }
        field(21; "Withholding Code"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"),
                                                                                                 "Use in" = FILTER('Booth' | 'Vendor'));


            CaptionML = ENU = 'Cod. retencion', ESP = 'C�d. retenci�n';

            trigger OnValidate();
            BEGIN
                IF (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", "Withholding Code")) THEN
                    Warranty := WithholdingGroup."Warranty Period";
                CALCFIELDS("Withholding return term");
            END;


        }
        field(22; "Withholding return term"; DateFormula)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Withholding Group"."Warranty Period" WHERE("Code" = FIELD("Withholding Code")));
            CaptionML = ESP = 'Plazo devol. Retenci�n';


        }
        field(23; "Warranty"; DateFormula)
        {
            CaptionML = ENU = 'Garantia', ESP = 'Plazo de Garant�a';


        }
        field(24; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';
            Description = 'JAV 14/11/19: - Se a�aden forma y m�todo de pago a las condiciones particulares';


        }
        field(25; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';
            Description = 'JAV 14/11/19: - Se a�aden forma y m�todo de pago a las condiciones particulares';


        }
        field(26; "Payment Phases"; Code[20])
        {
            TableRelation = "QB Payments Phases";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fases de Pago';
            Description = 'JAV 10/07/20: - Se a�aden fases de pago a las condiciones particulares - QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
    }
    keys
    {
        key(key1; "Vendor No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       VendorCond@1100286000 :
        VendorCond: Record 7207417;
        //       Vendor@1100286006 :
        Vendor: Record 23;
        //       WithholdingGroup@1100286005 :
        WithholdingGroup: Record 7207330;
        //       DataOtherConditions@1100286003 :
        DataOtherConditions: Record 7207421;
        //       DataOtherConditions2@1100286001 :
        DataOtherConditions2: Record 7207421;
        //       ConditionsVendor@1100286002 :
        ConditionsVendor: Record 7207420;
        //       Activity@1100286004 :
        Activity: Code[20];
        //       Err001@1100286007 :
        Err001: TextConst ESP = 'No pude crear una l�nea sin proyecto ni actividad';



    trigger OnInsert();
    begin
        //Debe tener proyecto o actividad
        //if ("Job No." = '') and ("Activity Code" = '') then
        //  ERROR(Err001);

        //Busco n� de l�nea de condiciones
        //if ("Line No." = 0) then begin
        //  ConditionsVendor.RESET;
        //  ConditionsVendor.SETRANGE("Vendor No.", "Vendor No.");
        //  if (ConditionsVendor.FINDLAST) then
        //    "Line No." := ConditionsVendor."Line No." + 1
        //  else
        //    "Line No." := 1;
        //end;

        InsertOtherConditionsPR;      //Inserto otras condiciones del proveedor
        InsertOtherConditionsOB;      //Inserto otras condiciones obligatorias
        SetOrder;
        CALCFIELDS("Import Other Conditions", "Import General Conditions");
    end;

    trigger OnModify();
    begin
        InsertOtherConditionsPR;   //Inserto otras condiciones del proveedor
        InsertOtherConditionsOB;   //Inserto otras condiciones obligatorias
        SetOrder;
        CALCFIELDS("Import Other Conditions", "Import General Conditions");
    end;

    trigger OnDelete();
    begin
        DeleteOtherConditions;
    end;



    LOCAL procedure InsertOtherConditionsPR()
    begin
        //Inserto otras condiciones del proveedor
        DataOtherConditions.RESET;
        DataOtherConditions.SETRANGE("Vendor No.", "Vendor No.");
        DataOtherConditions.SETFILTER("Line No.", '=%1', "Line No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //      if DataOtherConditions.FINDSET(FALSE,FALSE) then

        if DataOtherConditions.FINDSET(FALSE) then
            repeat
                DataOtherConditions2 := DataOtherConditions;
                DataOtherConditions2."Line No." := "Line No.";
                if not DataOtherConditions2.INSERT then;
            until VendorCond.NEXT = 0;
    end;

    LOCAL procedure InsertOtherConditionsOB()
    begin
        //Inserto otras condiciones obligatorias
        VendorCond.RESET;
        VendorCond.SETRANGE("Default Load", TRUE);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if VendorCond.FINDSET(FALSE, FALSE) then
        if VendorCond.FINDSET(FALSE) then
            repeat
                DataOtherConditions2.INIT;
                DataOtherConditions2."Vendor No." := "Vendor No.";
                DataOtherConditions2."Line No." := "Line No.";
                DataOtherConditions2.Code := VendorCond.Code;
                DataOtherConditions2.Description := VendorCond.Description;
                if not DataOtherConditions2.INSERT then;
            until VendorCond.NEXT = 0;
    end;

    LOCAL procedure DeleteOtherConditions()
    begin
        //Borro las otras condiciones
        DataOtherConditions.RESET;
        DataOtherConditions.SETRANGE("Vendor No.", "Vendor No.");
        DataOtherConditions.SETFILTER("Line No.", '=%1', "Line No.");
        DataOtherConditions.DELETEALL(TRUE);
    end;

    //     procedure CheckVendor (VendorNo@1000000000 :
    procedure CheckVendor(VendorNo: Code[20])
    var
        //       Text001@1000000002 :
        Text001: TextConst ENU = 'Vendor is Blocked', ESP = 'El proveedor est� bloqueado';
        //       Text002@1000000003 :
        Text002: TextConst ENU = 'Vendor is a Employee', ESP = 'El proveedor no puede ser un empleado';
    begin
        if Vendor.GET(VendorNo) then begin
            if Vendor.Blocked = Vendor.Blocked::All then
                ERROR(Text001);
            if Vendor."QB Employee" then
                ERROR(Text002);
        end;

        //Tomar la retenci�n del proveedor
        VALIDATE("Withholding Code", Vendor."QW Withholding Group by G.E.");
    end;

    LOCAL procedure SetDefaultFields()
    begin
        Vendor.GET("Vendor No.");
        if ("Use Generals") then
            "Date Init" := 0D;
        if ("Use Generals") then
            "Date end" := 0D;
        if ("Use Generals") or (FORMAT("Validity Quotes") = '') then
            "Validity Quotes" := Vendor."QB Validity Quotes";
        if ("Use Generals") or ("Withholding Code" = '') then
            VALIDATE("Withholding Code", Vendor."QW Withholding Group by G.E.");
        if ("Use Generals") or (FORMAT(Warranty) = '') then
            Warranty := Vendor."QB Warranty";
        if ("Use Generals") or (FORMAT("Payment Method Code") = '') then
            "Payment Method Code" := Vendor."Payment Method Code";
        if ("Use Generals") or (FORMAT("Payment Terms Code") = '') then
            "Payment Terms Code" := Vendor."Payment Terms Code";
    end;

    LOCAL procedure SetOrder()
    begin
        //Orden de los registros, primero los de proyecto, luego los de proyecto y actividad, luego solo actividad, luego los generales
        if ("Job No." <> '') then
            Order := '1' + "Job No." + "Activity Code"
        else if ("Activity Code" <> '') then
            Order := '2' + "Activity Code"
        else
            Order := '3';
    end;

    /*begin
    //{
//      JAV 07/11/19: - Nuevo campo "Use Generals" que indica si se usar�n las condiciones generales del proveedor o estas particulares
//                    - En altas y bajas se consideran las otras condiciones del proveedor
//      JAV 12/11/19: - Se cambia name y caption para que sean mas significativos
//    }
    end.
  */
}








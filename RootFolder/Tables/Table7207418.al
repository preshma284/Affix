table 7207418 "Vendor Quality Data"
{


    CaptionML = ENU = 'Vendor Quality Data', ESP = 'Datos calidad proveedor';
    LookupPageID = "Vendor Data List";
    DrillDownPageID = "Vendor Data List";

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = Vendor WHERE("Blocked" = CONST(" "),
                                                                               "QB Employee" = CONST(false));


            CaptionML = ENU = 'Vendor No.', ESP = 'N� proveedor';

            trigger OnValidate();
            BEGIN
                CheckVendor("Vendor No.");
                ConditionsData(FALSE);
            END;


        }
        field(2; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";
            CaptionML = ENU = 'Activity Code', ESP = 'C�d. actividad';
            NotBlank = true;


        }
        field(4; "Evaluations Average Rating"; Decimal)
        {


            CaptionML = ENU = 'Average Rating', ESP = 'Punt. media';
            Description = 'JAV 21/09/19: - Se cambia el caption para que sea mas significativo y/o mas corto';
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE("Punctuation end");
            END;


        }
        field(5; "Last Evaluation Observations"; Text[150])
        {
            CaptionML = ENU = 'Evaluation Observations', ESP = 'Observaciones �ltima evaluaci�n';
            Editable = false;


        }
        field(6; "Last Evaluation Date"; Date)
        {
            CaptionML = ENU = 'Date of Last Evaluation', ESP = 'Fecha �ltima evaluaci�n';
            Editable = false;


        }
        field(7; "No. of Evaluations"; Integer)
        {
            CaptionML = ENU = 'No. of Reviews', ESP = 'N� Eval. Reg.';
            Description = 'JAV 17/98/19: - No es un campo calculado pues solo se cuenta cuando esta validada y la evaluaci�n es diferente de cero';
            Editable = false;


        }
        field(8; "Average Clasification"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n media';
            Description = 'JAV 17/08/19: - Clasificaci�n obtenida en la media de evaluaciones';
            Editable = false;


        }
        field(12; "Activity Description"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Activity QB"."Description" WHERE("Activity Code" = FIELD("Activity Code")));
            CaptionML = ENU = 'Activity Description', ESP = 'Descripción actividad';
            Editable = false;


        }
        field(13; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre proveedor';
            Editable = false;


        }
        field(14; "Area Activity"; Option)
        {
            OptionMembers = "Local","Autonomous","National";
            CaptionML = ENU = 'Ambito Activity', ESP = '�mbito actividad';
            OptionCaptionML = ENU = 'Local,Autonomous,National', ESP = 'Local,Auton�mico,Nacional';

            Editable = false;


        }
        field(15; "Equipment"; Text[70])
        {
            CaptionML = ENU = 'Equipment', ESP = 'Equipos';


        }
        field(16; "Warranty"; Text[70])
        {
            CaptionML = ENU = 'Warranty', ESP = 'Garant�a';


        }
        field(17; "Selected Vendor"; Boolean)
        {
            CaptionML = ENU = 'Selected Vendor', ESP = 'Proveedor seleccionado';


        }
        field(18; "Date Signature Selections"; Date)
        {
            CaptionML = ENU = 'Date Signature Selections', ESP = 'Fecha firma selecci�n';


        }
        field(20; "No. of Certificates"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Vendor Certificates" WHERE("Vendor No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'No. of Certificates', ESP = 'N� Total Certificados';
            Description = 'JAV 25/02/20: - N�mero total de certificados del proveedor';
            Editable = false;


        }
        field(21; "No. of Evaluations Total"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Vendor Evaluation Header" WHERE("Vendor No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'No. of Certificates', ESP = 'N� Total Evaluaciones';
            Description = 'JAV 25/02/20: - N�mero total de evaluaciones del proveedor';
            Editable = false;


        }
        field(22; "No. of Conditions"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Vendor Conditions" WHERE("Vendor No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'No. of Conditions', ESP = 'N� Total Condiciones';
            Description = 'JAV 25/02/20: - N�mero total de condiciones del proveedor';
            Editable = false;


        }
        field(30; "Date Last Reviews"; Date)
        {


            CaptionML = ENU = 'Date Last Reviews', ESP = 'Fecha Punt. manual';
            Description = 'JAV 21/09/19: - Se cambia el caption para que sea mas significativo y/o mas corto';

            trigger OnValidate();
            BEGIN
                VALIDATE("Punctuation end");
            END;


        }
        field(31; "Review Score"; Decimal)
        {


            CaptionML = ENU = 'Average Review Score', ESP = 'Puntuaci�n Manual';
            Description = 'JAV 21/09/19: - Se cambia el caption para que sea mas significativo y/o mas corto';

            trigger OnValidate();
            BEGIN
                VALIDATE("Date Last Reviews", TODAY);
            END;


        }
        field(32; "Comments Latest Reviews"; Text[30])
        {
            CaptionML = ENU = 'Comments Latest Reviews', ESP = 'Observaciones Punt. Manual';
            Description = 'JAV 21/09/19: - Se cambia el caption para que sea mas significativo y/o mas corto';


        }
        field(33; "Clasification Review"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n Punt. Manual';
            Description = 'JAV 17/08/19: - Clasificaci�n de la Revisi�n     JAV 21/09/19: - Se cambia el caption para que sea mas significativo y/o mas corto';


        }
        field(40; "Punctuation end"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Puntuaci�n final';
            Description = 'JAV 17/08/19: - Puntuaci�n final obtenida (Evaluaci�n o Revisi�n) en esta actividad';
            Editable = false;

            trigger OnValidate();
            BEGIN
                QuoBuildingSetup.GET();
                CASE QuoBuildingSetup."Evaluation method" OF
                    QuoBuildingSetup."Evaluation method"::Date:
                        BEGIN
                            IF ("Date Last Reviews" >= "Last Evaluation Date") THEN
                                "Punctuation end" := "Review Score"
                            ELSE
                                "Punctuation end" := "Evaluations Average Rating";
                        END;
                    QuoBuildingSetup."Evaluation method"::Reviews:
                        BEGIN
                            IF ("Review Score" <> 0) THEN
                                "Punctuation end" := "Review Score"
                            ELSE
                                "Punctuation end" := "Evaluations Average Rating";
                        END;
                    QuoBuildingSetup."Evaluation method"::AddReviews:
                        BEGIN
                            "Punctuation end" := "Review Score" + "Evaluations Average Rating";
                        END;
                END;
                "Clasification end" := CodesEvaluation.GetClasification("Punctuation end");
            END;


        }
        field(41; "Clasification end"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n final';
            Description = 'JAV 17/08/19: - Puntuaci�n final obtenida (Evaluaci�n o Revisi�n) en esta actividad';
            Editable = false;


        }
        field(42; "Total Average Punctuation"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Average("Vendor Quality Data"."Punctuation end" WHERE("Vendor No." = FIELD("Vendor No.")));
            CaptionML = ESP = 'Puntuaci�n Media Proveedor';
            Description = 'JAV 21/09/19: - Puntuaci�n media del proveedor en todas las actividades';


        }
        field(50; "Operation Counties"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Operation County', ESP = 'Provincias en que opera';
            Description = 'QB 1.00 - JAV 03/04/20 ELECNOR GEN001-04';

            trigger OnValidate();
            VAR
                //                                                                 OpCounty@1100286000 :
                OpCounty: Text;
                //                                                                 Country@1100286002 :
                Country: Code[20];
                //                                                                 CountryRegion@1100286001 :
                CountryRegion: Record 9;
                //                                                                 i@1100286003 :
                i: Integer;
            BEGIN
                //GEN001 - Provincias en las que opera, verificar que existan
                QBPageSubscriber.VerifyCounties("Operation Counties");
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    Vendor."QB Operation Counties" := "Operation Counties";
                    Vendor.MODIFY;
                END;
            END;


        }
        field(51; "Operation Countries"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Operation Country', ESP = 'Paises en que opera';
            Description = 'QB 1.00 - JAV 03/04/20 ELECNOR GEN001-04';

            trigger OnValidate();
            VAR
                //                                                                 OpCountry@1100286000 :
                OpCountry: Text;
                //                                                                 Country@1100286002 :
                Country: Code[20];
                //                                                                 CountryRegion@1100286001 :
                CountryRegion: Record 9;
                //                                                                 i@1100286003 :
                i: Integer;
            BEGIN
                //GEN001 - Paises en los que opera, verificar que existan
                QBPageSubscriber.VerifyCountries("Operation Countries");
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    Vendor."QB Operation Countries" := "Operation Countries";
                    Vendor.MODIFY;
                END;
            END;


        }
        field(50000; "Comparative Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Blocked', ESP = 'Bloqueado para comparativos';
            Description = 'QPE6436';


        }
        field(50001; "Comment"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blocked Comment', ESP = 'Comentario';
            Description = 'QPE6436';


        }
        field(50002; "Main Activity"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Actividad Principal';
            Description = 'GAP003 KALAM: - Se marca la actividad principal del proveedor';

            trigger OnValidate();
            BEGIN
                //JAV 02/02/20: - Si esta es la principal, no pueden haber otras marcadas
                IF ("Main Activity") THEN BEGIN
                    VendorQualityData.RESET;
                    VendorQualityData.SETRANGE("Vendor No.", "Vendor No.");
                    VendorQualityData.SETFILTER("Activity Code", '<>%1', "Activity Code");
                    VendorQualityData.SETRANGE("Main Activity", TRUE);
                    VendorQualityData.MODIFYALL("Main Activity", FALSE);
                END;
            END;


        }
    }
    keys
    {
        key(key1; "Vendor No.", "Activity Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Vendor@100000001 :
        Vendor: Record 23;
        //       CodesEvaluation@1100286000 :
        CodesEvaluation: Record 7207422;
        //       QuoBuildingSetup@1100286001 :
        QuoBuildingSetup: Record 7207278;
        //       Text001@1100286002 :
        Text001: TextConst ENU = 'The activity has %1 evaluations, it is not possible to eliminate it, block it if you do not want it to be used in comparisons.', ESP = 'La actividad tiene %1 evaluaciones, no es posible eliminarla, bloqueela si no desea que se use en comparativos.';
        //       VendorQualityData@1100286003 :
        VendorQualityData: Record 7207418;
        //       QBPageSubscriber@100000000 :
        QBPageSubscriber: Codeunit 7207349;



    trigger OnInsert();
    begin
        //JAV 19/12/18 - PERTEO Crear la actividad para el vendedor en el alta y modificaci�n por si no existen
        ConditionsData(FALSE);
    end;

    trigger OnModify();
    begin
        //JAV 19/12/18 - PERTEO Crear la actividad para el vendedor en el alta y modificaci�n por si no existen
        ConditionsData(FALSE);
    end;

    trigger OnDelete();
    begin
        //JAV 26/09/19: - No se puede borrar una actividad con evaluaciones, y al borrar la actividad se eliminan sus condiciones
        if ("No. of Evaluations" <> 0) then
            ERROR(Text001, "No. of Evaluations");

        ConditionsData(TRUE);
    end;



    // procedure CheckVendor (VendorNo@1000000000 :
    procedure CheckVendor(VendorNo: Code[20])
    var
        //       Text001@1000000002 :
        Text001: TextConst ENU = 'Vendor is Blocked', ESP = 'El proveedor est� bloqueado';
        //       Text002@1000000003 :
        Text002: TextConst ENU = 'Vendor is a Employee', ESP = 'El proveedor es empleado';
        //       Vendor@1100286000 :
        Vendor: Record 23;
    begin
        if Vendor.GET(VendorNo) then begin
            if Vendor.Blocked = Vendor.Blocked::All then
                ERROR(Text001);
            if Vendor."QB Employee" = TRUE then
                ERROR(Text002);
        end;
    end;

    //     procedure GetDescriptionActivityHP (CodeAct@1000000000 :
    procedure GetDescriptionActivityHP(CodeAct: Code[20]): Text[250];
    var
        //       ActivityHP@1100286000 :
        ActivityHP: Record 7207280;
    begin
        if ActivityHP.GET(CodeAct) then
            exit(ActivityHP.Description);
    end;

    //     procedure GetNameVendor (CodeVendor@1000000000 :
    procedure GetNameVendor(CodeVendor: Code[20]): Text[250];
    var
        //       Vendor@1100286000 :
        Vendor: Record 23;
    begin
        if Vendor.GET(CodeVendor) then
            exit(Vendor.Name);
    end;

    //     procedure GetCityVendor (CodeVendor@1000000000 :
    procedure GetCityVendor(CodeVendor: Code[20]): Text[250];
    var
        //       Vendor@1100286000 :
        Vendor: Record 23;
    begin
        if Vendor.GET(CodeVendor) then
            exit(Vendor.City);
    end;

    //     procedure GetPhoneVendor (CodeVendor@1000000000 :
    procedure GetPhoneVendor(CodeVendor: Code[20]): Text[250];
    var
        //       Vendor@1100286000 :
        Vendor: Record 23;
    begin
        if Vendor.GET(CodeVendor) then
            exit(Vendor."Phone No.");
    end;

    //     LOCAL procedure ConditionsData (pBaja@1100286001 :
    LOCAL procedure ConditionsData(pBaja: Boolean)
    var
        //       ConditionsVendor@1100286000 :
        ConditionsVendor: Record 7207420;
    begin
        //JAV 19/12/18: - PERTEO Crear la actividad en el vendedor en el alta y modificaci�n si no existe
        //JAV 26/09/19: - Se dan de bajas las actividades si se solicta su baja
        if (pBaja) then begin
            ConditionsVendor.RESET;
            ConditionsVendor.SETRANGE("Vendor No.", "Vendor No.");
            ConditionsVendor.SETFILTER("Activity Code", '=%1', "Activity Code");
            ConditionsVendor.DELETEALL(TRUE);
        end else begin
            if ("Activity Code" <> '') then begin
                ConditionsVendor.INIT;

                //JAV 26/09/19: - En el alta se cambia la asignaci�n del proveedor por un validate para que actualice datos del proveedor
                //ConditionsVendor."Vendor No." := "Vendor No.";
                ConditionsVendor.VALIDATE("Vendor No.", "Vendor No.");
                ConditionsVendor."Line No." := 0;
                ConditionsVendor."Activity Code" := "Activity Code";
                if not ConditionsVendor.INSERT then;
            end;
        end;
    end;

    /*begin
    //{
//      JAV 19/12/18: - PERTEO Crear la actividad para el vendedor en el alta y modificaci�n por si no existen
//      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
//      JAV 21/09/19: - Al cambiar la revisi�n o la fecha recalcular la puntuci�n final. Se cambian captions para que sean mas informativos.
//      JAV 26/09/19: - En el alta se cambia la asignaci�n del proveedor por un validate para que actualice datos del proveedor
//                    - No se puede borrar una actividad con evaluaciones, y al borrar la actividad se eliminan sus condiciones
//    }
    end.
  */
}








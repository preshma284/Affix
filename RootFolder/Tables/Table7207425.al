table 7207425 "Vendor Evaluation Line"
{


    CaptionML = ENU = 'Vendor Evaluation Line', ESP = 'Lin. evaluacion proveedor';
    LookupPageID = "Evaluation Line Subform";
    DrillDownPageID = "Evaluation Line Subform";

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = Vendor WHERE("Blocked" = CONST(" "),
                                                                               "QB Employee" = CONST(false));


            CaptionML = ENU = 'Vendor No.', ESP = 'N� Proveedor';

            trigger OnValidate();
            BEGIN
                CheckVendor("Vendor No.");
            END;


        }
        field(2; "Activity Code"; Code[20])
        {
            TableRelation = "Vendor Quality Data"."Activity Code" WHERE("Vendor No." = FIELD("Vendor No."));


            CaptionML = ENU = 'Activity Code', ESP = 'C�d. actividad';
            NotBlank = true;

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Activity Description");
                IF ("Activity Code" <> xRec."Activity Code") THEN BEGIN
                    IF (ActivityQB.GET("Activity Code")) THEN BEGIN
                        "Evaluation Type" := ActivityQB."Evaluation Type";
                        DeleteLines(xRec."Activity Code");
                        AddLines("Activity Code");
                    END;
                END;
            END;


        }
        field(4; "Evaluation Score"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Vendor Evaluation"."Weighing Value" WHERE("Evaluation No." = FIELD("Evaluation No."),
                                                                                                                    "Vendor No." = FIELD("Vendor No."),
                                                                                                                    "Activity Code" = FIELD("Activity Code")));
            CaptionML = ENU = 'Average Evaluation Score', ESP = 'Puntuaci�n evaluaci�n';
            Editable = false;


        }
        field(5; "Evaluation Observations"; Text[150])
        {
            CaptionML = ENU = 'Evaluation Observations', ESP = 'Observaciones evaluaci�n';


        }
        field(6; "Date of Last Evaluation"; Date)
        {
            CaptionML = ENU = 'Date of Last Evaluation', ESP = 'Fecha �ltima evaluaci�n';
            Editable = false;


        }
        field(7; "Clasification"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n';
            Description = 'JAV 17/08/19: - Clasificaci�n obtenida';
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
        field(15; "Equipment"; Text[70])
        {
            CaptionML = ENU = 'Equipment', ESP = 'Equipos';


        }
        field(16; "Warranty"; Text[70])
        {
            CaptionML = ENU = 'Warranty', ESP = 'Garant�a';


        }
        field(20; "Date Observations"; Date)
        {
            CaptionML = ENU = 'Date Observations', ESP = 'Fecha Observaciones';


        }
        field(24; "Evaluations Average Rating"; Decimal)
        {
            CaptionML = ENU = 'Average Review Score', ESP = 'Puntuaci�n media';
            Editable = false;


        }
        field(27; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(32; "Evaluation No."; Code[20])
        {
            CaptionML = ENU = 'Evaluation No.', ESP = 'N� evaluaci�n';


        }
        field(33; "Validated"; Boolean)
        {
            CaptionML = ENU = 'Validated', ESP = 'Validada';
            Editable = false;


        }
        field(34; "Evaluation Type"; Option)
        {
            OptionMembers = "Services","Items","Others";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo evaluaci�n';
            OptionCaptionML = ENU = 'Services,Items,Others', ESP = 'Servicios,Productos,Otros';

            Description = 'JAV 21/09/19: - Para distinguir entre evaluar servicios, productos u otros';


        }
    }
    keys
    {
        key(key1; "Evaluation No.", "Activity Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       VendorEvaluationHeader@1100286000 :
        VendorEvaluationHeader: Record 7207424;
        //       Text0001@1100286002 :
        Text0001: TextConst ENU = 'A validated line can not be deleted', ESP = 'No puede borrarse una l�nea validada';
        //       Text0002@1100286001 :
        Text0002: TextConst ENU = 'The associated conditions and certificates will be erased', ESP = '�Desea borrar las condiciones y certificados asociados?';
        //       DataVendorEvaluation@1100286006 :
        DataVendorEvaluation: Record 7207423;
        //       CodesEvaluation@1100286007 :
        CodesEvaluation: Record 7207422;
        //       ActivityQB@1100286008 :
        ActivityQB: Record 7207280;



    trigger OnInsert();
    begin
        if (VendorEvaluationHeader.GET("Evaluation No.")) then begin
            "Evaluation No." := VendorEvaluationHeader."No.";
            "Vendor No." := VendorEvaluationHeader."Vendor No.";
            "Job No." := VendorEvaluationHeader."Job No.";
        end;
        if (ActivityQB.GET("Activity Code")) then
            "Evaluation Type" := ActivityQB."Evaluation Type";
    end;

    trigger OnDelete();
    begin
        if Validated then
            ERROR(Text0001);

        if ("Activity Code" <> '') then
            DeleteLines("Activity Code");
    end;



    // procedure CheckVendor (VendorNo@1000000000 :
    procedure CheckVendor(VendorNo: Code[20])
    var
        //       Text001@1000000002 :
        Text001: TextConst ENU = 'Vendor is Blocked', ESP = 'El proveedor est� bloqueado';
        //       Text002@1000000003 :
        Text002: TextConst ENU = 'Vendor is a Employee', ESP = 'El proveedor no puede ser un empleado';
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

    //     procedure AddLines (ActivityCode@1100286000 :
    procedure AddLines(ActivityCode: Code[20])
    begin
        //JAV 24/02/20: - Al crear los criterios de evaluaci�n, eliminar los que no sean del mismo tipo
        DataVendorEvaluation.RESET;
        DataVendorEvaluation.SETRANGE("Evaluation No.", "Evaluation No.");
        DataVendorEvaluation.SETRANGE("Vendor No.", "Vendor No.");
        DataVendorEvaluation.SETRANGE("Activity Code", "Activity Code");
        DataVendorEvaluation.SETFILTER("Evaluation Type", '<>%1', "Evaluation Type");
        DataVendorEvaluation.DELETEALL;

        CodesEvaluation.RESET;
        CodesEvaluation.SETRANGE("Evaluation Type", "Evaluation Type");
        if CodesEvaluation.FINDSET(FALSE) then
            repeat
                DataVendorEvaluation.INIT;
                DataVendorEvaluation.VALIDATE("Evaluation No.", "Evaluation No.");
                DataVendorEvaluation.VALIDATE("Vendor No.", "Vendor No.");
                DataVendorEvaluation.VALIDATE("Activity Code", ActivityCode);
                DataVendorEvaluation.VALIDATE("Evaluation Type", CodesEvaluation."Evaluation Type");
                DataVendorEvaluation.VALIDATE(Code, CodesEvaluation.Code);
                DataVendorEvaluation.VALIDATE("Job No.", "Job No.");
                if not DataVendorEvaluation.INSERT then;
            until CodesEvaluation.NEXT = 0;
    end;

    //     procedure DeleteLines (ActivityCode@1100286000 :
    procedure DeleteLines(ActivityCode: Code[20])
    begin
        DataVendorEvaluation.RESET;
        DataVendorEvaluation.SETRANGE("Evaluation No.");
        DataVendorEvaluation.SETRANGE("Vendor No.");
        DataVendorEvaluation.SETRANGE("Activity Code", "Activity Code");
        DataVendorEvaluation.DELETEALL;
    end;

    procedure SetAverageReviewScore()
    var
        //       VendorEvalLine@1100286002 :
        VendorEvalLine: Record 7207425;
        //       VendorQualityData@1100286004 :
        VendorQualityData: Record 7207418;
        //       suma@1100286001 :
        suma: Decimal;
        //       n@1100286000 :
        n: Integer;
        //       lastdate@1100286003 :
        lastdate: Date;
        //       lascomment@1100286005 :
        lascomment: Text;
    begin
        //Clasificamos la l�nea
        CALCFIELDS("Evaluation Score");
        Clasification := CodesEvaluation.GetClasification("Evaluation Score");
        MODIFY;

        //Buscamos la puntuaci�n media y fecha de �ltima evaluaci�n de la actividad
        suma := 0;
        n := 0;
        lastdate := 0D;
        VendorEvalLine.RESET;
        VendorEvalLine.SETRANGE("Vendor No.", "Vendor No.");
        VendorEvalLine.SETRANGE("Activity Code", "Activity Code");
        VendorEvalLine.SETRANGE(Validated, TRUE);
        if (VendorEvalLine.FINDSET(TRUE)) then
            repeat
                VendorEvalLine.CALCFIELDS(VendorEvalLine."Evaluation Score");
                if (VendorEvalLine."Evaluation Score" <> 0) then begin
                    //Sumo puntos y cuento uno mas
                    suma += VendorEvalLine."Evaluation Score";
                    n += 1;
                    //Busco la fecha de la �ltima evaluaci�n
                    VendorEvaluationHeader.GET(VendorEvalLine."Evaluation No.");
                    if (lastdate < VendorEvaluationHeader."Evaluation Date") then begin
                        lastdate := VendorEvaluationHeader."Evaluation Date";
                        lascomment := VendorEvalLine."Evaluation Observations";
                    end;
                end;
            until (VendorEvalLine.NEXT = 0);

        if (n <> 0) then
            "Evaluations Average Rating" := ROUND(suma / n, 0.01)
        else
            "Evaluations Average Rating" := 0;
        "Average Clasification" := CodesEvaluation.GetClasification("Evaluations Average Rating");
        "Date of Last Evaluation" := lastdate;
        MODIFY;

        //Modificamos la puntuaci�n media y la fecha de ultima evaluaci�n del resto
        VendorEvalLine.RESET;
        VendorEvalLine.SETFILTER("Evaluation No.", '<>%1', "Evaluation No.");
        VendorEvalLine.SETRANGE("Vendor No.", "Vendor No.");
        VendorEvalLine.SETRANGE("Activity Code", "Activity Code");
        VendorEvalLine.MODIFYALL("Evaluations Average Rating", "Evaluations Average Rating");
        VendorEvalLine.MODIFYALL("Average Clasification", "Average Clasification");
        VendorEvalLine.MODIFYALL("Date of Last Evaluation", lastdate);

        //Modificamos o creamos el registro de calidad del proveedor (debe existir, pero por si acaso)
        if not VendorQualityData.GET("Vendor No.", "Activity Code") then begin
            VendorQualityData.INIT;
            VendorQualityData."Vendor No." := "Vendor No.";
            VendorQualityData."Activity Code" := "Activity Code";
            VendorQualityData.INSERT;
        end;
        VendorQualityData."No. of Evaluations" := n;
        VendorQualityData."Last Evaluation Date" := lastdate;
        VendorQualityData."Last Evaluation Observations" := lascomment;
        VendorQualityData.VALIDATE("Evaluations Average Rating", "Evaluations Average Rating");
        VendorQualityData.VALIDATE("Average Clasification", "Average Clasification");
        VendorQualityData.MODIFY;
    end;

    /*begin
    //{
//      JAV 15/08/19: - Se elimina la opci�n al borrar, no tiene mucho sentido tenerla aqu�
//                    - Se cambia el texto del mensaje Text0002 para que sea mas adecuado
//      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
//      JAV 21/09/19: - Se a�ade el campo "Evaluation Type" para distinguir entre evaluar servicios, productos u otros
//      JAV 11/11/19: - Se eliminan los campos de Certificaciones, ahora no pueden ser campos calculados
//    }
    end.
  */
}








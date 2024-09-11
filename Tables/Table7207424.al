table 7207424 "QBU Vendor Evaluation Header"
{


    CaptionML = ENU = 'Vendor Evaluation Header', ESP = 'Cab. evaluaci�n proveedor';
    LookupPageID = "Vendor Evaluation List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    PurchSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Vendor No.', ESP = 'N� Proveedor';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Vendor Name");
                VendorEvalLine.SETRANGE("Evaluation No.", "No.");
                IF NOT VendorEvalLine.ISEMPTY THEN
                    ERROR(Text0004);
            END;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(4; "Evaluation Date"; Date)
        {
            CaptionML = ENU = 'Evaluation Date', ESP = 'Fecha evaluaci�n';


        }
        field(5; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"));


            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';

            trigger OnValidate();
            BEGIN
                VendorEvalLine.RESET;
                VendorEvalLine.SETRANGE("Evaluation No.", "No.");
                VendorEvalLine.MODIFYALL("Job No.", "Job No.");
            END;


        }
        field(6; "User ID."; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User Id.', ESP = 'Id. Usuario';
            Editable = false;


        }
        field(8; "Validated"; Boolean)
        {
            CaptionML = ENU = 'Validated', ESP = 'Validado';
            Editable = false;


        }
        field(9; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(11; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre proveedor';
            Editable = false;


        }
        field(12; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Vendor Evaluation"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(13; "Vendor County Code"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."County" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Vendor County Code', ESP = 'Provincia del proveedor';
            Editable = false;


        }
        field(14; "Evaluation Score"; Decimal)
        {
            CaptionML = ENU = 'Average Evaluation Score', ESP = 'Resultado de la evaluaci�n';
            Description = 'JAV 15/08/19: - Resultado de la evaluaci�n';
            Editable = false;


        }
        field(15; "Average Evaluation Score"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Average Evaluation Score', ESP = 'Media de evaluaciones';
            Description = 'JAV 15/08/19: - Resultado medio de la evaluaci�n';
            Editable = false;


        }
        field(16; "Evaluation Clasification"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n de la Evaluaci�n';
            Description = 'JAV 17/08/19: - Clasificaci�n obtenida en la evaluaci�n';
            Editable = false;


        }
        field(17; "Average Clasification"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clasificaci�n media';
            Description = 'JAV 17/08/19: - Clasificaci�n obtenida en la media de evaluaciones';
            Editable = false;


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
        //       PurchSetup@1100286000 :
        PurchSetup: Record 312;
        //       VendorEvalLine@1100286002 :
        VendorEvalLine: Record 7207425;
        //       VendorQualityData@7207271 :
        VendorQualityData: Record 7207418;
        //       VendorEvaluationHeader@7207278 :
        VendorEvaluationHeader: Record 7207424;
        //       NoSeriesMgt@1100286001 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       Text0001@7207279 :
        Text0001: TextConst ENU = 'A validated evaluation can not be deleted', ESP = 'No puede borrarse una evaluaci�n validada';
        //       Text0002@7207281 :
        Text0002: TextConst ENU = 'An evaluation draft can not be renumbered', ESP = 'No puede renumerarse un borrador de evaluaci�n';
        //       Text0003@7207280 :
        Text0003: TextConst ENU = 'All data from evaluation %1 will be erased', ESP = 'Se borrar�n todos los datos de la evaluaci�n %1';
        //       Text0004@7207270 :
        Text0004: TextConst ENU = 'Can not be modified because the document has associated lines', ESP = 'No puede modificarse porque el documento tiene l�neas asociadas';



    trigger OnInsert();
    begin
        PurchSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Evaluation Date", "No.", xRec."No. Series");
        end;

        InitRecord;

        if GETFILTER("Vendor No.") <> '' then
            if GETRANGEMIN("Vendor No.") = GETRANGEMAX("Vendor No.") then
                VALIDATE("Vendor No.", GETRANGEMIN("Vendor No."));
    end;

    trigger OnDelete();
    begin
        if Validated then
            ERROR(Text0001);

        if CONFIRM(Text0003, FALSE, "No.") then begin
            VendorEvalLine.RESET;
            VendorEvalLine.SETRANGE("Evaluation No.", "No.");
            VendorEvalLine.DELETEALL;
        end;
    end;

    trigger OnRename();
    begin
        ERROR(Text0002, TABLECAPTION);
    end;



    procedure InitRecord()
    begin
        //JAV 26/11/19: - Se eliminan los campos "Posting Date" (se cambia su uso por "Evaluation Date") y "Posting No. Serie" que no se usan
        //NoSeriesMgt.SetDefaultSeries(InitRecord,PurchSetup."Posted Evaluations Nos.");
        //"Posting Date" := WORKDATE;
        "Evaluation Date" := WORKDATE;
        "User ID." := USERID;
    end;

    //     procedure AssistEdit (VendorEvalHeader@7207270 :
    procedure AssistEdit(VendorEvalHeader: Record 7207424): Boolean;
    begin
        PurchSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, VendorEvalHeader."No. Series", "No. Series") then begin
            PurchSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        exit(PurchSetup."Evaluations Nos. No. Series");
    end;

    LOCAL procedure TestNoSeries(): Boolean;
    begin
        PurchSetup.TESTFIELD(PurchSetup."Evaluations Nos. No. Series");
    end;

    procedure SetEvaluationScore()
    var
        //       VendorEvaluationHeader@1100286002 :
        VendorEvaluationHeader: Record 7207424;
        //       VendorQualityData@1100286003 :
        VendorQualityData: Record 7207418;
        //       CodesEvaluation@1100286004 :
        CodesEvaluation: Record 7207422;
        //       suma@1100286001 :
        suma: Decimal;
        //       n@1100286000 :
        n: Integer;
    begin
        //Resultado de la evaluacion de las l�neas
        suma := 0;
        n := 0;
        VendorEvalLine.RESET;
        VendorEvalLine.SETRANGE("Evaluation No.", "No.");
        if (VendorEvalLine.FINDSET(FALSE)) then
            repeat
                VendorEvalLine.CALCFIELDS("Evaluation Score");
                if (VendorEvalLine."Evaluation Score" <> 0) then begin
                    suma += VendorEvalLine."Evaluation Score";
                    n += 1;
                end;
            until (VendorEvalLine.NEXT = 0);

        if (n <> 0) then
            "Evaluation Score" := ROUND(suma / n, 0.01)
        else
            "Evaluation Score" := 0;
        "Evaluation Clasification" := CodesEvaluation.GetClasification("Evaluation Score");
        MODIFY;

        //Resultado medio de todas las evaluaciones que est�n validadas
        suma := 0;
        n := 0;
        VendorEvaluationHeader.RESET;
        VendorEvaluationHeader.SETRANGE("Vendor No.", "Vendor No.");
        VendorEvaluationHeader.SETRANGE(Validated, TRUE);
        if (VendorEvaluationHeader.FINDSET(FALSE)) then
            repeat
                if (VendorEvaluationHeader."Evaluation Score" <> 0) then begin
                    suma += VendorEvaluationHeader."Evaluation Score";
                    n += 1;
                end;
            until (VendorEvaluationHeader.NEXT = 0);

        if (n <> 0) then
            "Average Evaluation Score" := ROUND(suma / n, 0.01)
        else
            "Average Evaluation Score" := 0;
        "Average Clasification" := CodesEvaluation.GetClasification("Average Evaluation Score");
        MODIFY;

        //Modificamos la puntuaci�n media del resto de evaluaciones
        VendorEvaluationHeader.RESET;
        VendorEvaluationHeader.SETFILTER("No.", '<>%1', "No.");
        VendorEvaluationHeader.SETRANGE("Vendor No.", "Vendor No.");
        VendorEvaluationHeader.MODIFYALL("Average Evaluation Score", "Average Evaluation Score");
        VendorEvaluationHeader.MODIFYALL("Average Clasification", CodesEvaluation.GetClasification("Average Evaluation Score"));
    end;

    /*begin
    //{
//      JAV 15/08/19: - Se a�ade el campo 13 "Vendor County Code" con la provincia del proveedor
//      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
//      JAV 26/11/19: - Se eliminan los campos no usados: "Posting Date" (se cambia su uso por "Evaluation Date") y "Posting No. Serie" (junto a la funci�n "GetPostingNoSeriesCode")
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de la funci�n GetNoSeriesCode de 10 a 20
//    }
    end.
  */
}








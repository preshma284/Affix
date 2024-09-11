table 7207338 "QBU Hist. Measurements"
{


    CaptionML = ENU = 'Hist. Measurements', ESP = 'Hist. mediciones';
    LookupPageID = "Measure Post List";
    DrillDownPageID = "Measure Post List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(2; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(3; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(5; "Send Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha entrega';


        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(8; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(9; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;


        }
        field(10; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Measure Hist."),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(11; "OLD_Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term PEC Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(12; "OLD_Amount To Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term PEC Amount" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Amount To Source', ESP = 'Importe a origen';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned No. Series', ESP = 'N� serie preasignado';


        }
        field(15; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(16; "Measurement Date"; Date)
        {
            CaptionML = ENU = 'Measurement Date', ESP = 'Fecha medici�n';


        }
        field(17; "No. Measure"; Code[10])
        {
            CaptionML = ENU = 'No. Measure', ESP = 'N� de medici�n';


        }
        field(18; "Last Measure"; Boolean)
        {
            CaptionML = ENU = 'Last Measure', ESP = 'Ultima medici�n';


        }
        field(19; "Text Measure"; Text[30])
        {
            CaptionML = ENU = 'Text Measure', ESP = 'Texto medici�n';


        }
        field(20; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(21; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';


        }
        field(22; "OLD_Measure Type"; Option)
        {
            OptionMembers = "Origin","Period";
            CaptionML = ENU = 'Measure Type', ESP = 'Tipo medici�n';
            OptionCaptionML = ENU = 'Origin,Period', ESP = 'Origen,Periodo';

            Description = '### ELIMINAR ### no se usa';


        }
        field(23; "Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Editable = false;


        }
        field(24; "Address"; Text[50])
        {
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';
            Editable = false;


        }
        field(25; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';
            Editable = false;


        }
        field(26; "City"; Text[50])
        {
            CaptionML = ENU = 'City', ESP = 'Poblaci�n';
            Editable = false;


        }
        field(27; "Contact"; Text[50])
        {
            CaptionML = ENU = 'Contact', ESP = 'Contacto';
            Editable = false;


        }
        field(28; "County"; Text[50])
        {
            CaptionML = ENU = 'County', ESP = 'Provincia';
            Editable = false;


        }
        field(29; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code', ESP = 'C.P.';
            Editable = false;


        }
        field(30; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Country Code', ESP = 'C�d. Pa�s';
            Editable = false;


        }
        field(31; "Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2', ESP = 'Nombre 2';
            Editable = false;


        }
        field(32; "Measured Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measurements"."Amount Document" WHERE("Job No." = FIELD("Job No."),
                                                                                                                 "Cancel No." = CONST(''),
                                                                                                                 "Cancel By" = CONST('')));
            CaptionML = ENU = 'Measured Amount', ESP = 'Importe medido';
            Description = '[ Estad�sticas: sumatorio Importe total del Hist. medici�n para el proyecto]';
            Editable = false;


        }
        field(33; "Certified Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Post. Certifications"."Amount Document" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Cancel No." = CONST(''),
                                                                                                                   "Cancel By" = CONST('')));
            CaptionML = ENU = 'Certified Amount', ESP = 'Importe certificado';
            Description = '[ Estad�sticas: sumatorio Importe total del Hist. certificaci�n para el proyecto]';
            Editable = false;


        }
        field(34; "Invoiced Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Post. Certifications"."Amount Invoiced" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Cancel No." = CONST(''),
                                                                                                                   "Cancel By" = CONST(''),
                                                                                                                   "Invoiced Certification" = CONST(true)));
            CaptionML = ENU = 'Invoiced Amount', ESP = 'Importe facturado';
            Description = '[ Estad�sticas: sumatorio Importe total del Hist. certificaci�n facturadas para el proyecto]';
            Editable = false;


        }
        field(35; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            BEGIN
                FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                IF NOT UserSetupManagement.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(
                      Text027,
                       ResponsibilityCenter.TABLECAPTION, HasGotSalesUserSetup);
            END;


        }
        field(36; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(37; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. ususario';

            trigger OnValidate();
            BEGIN
                UserManagement.LookupUserID("User ID");
            END;

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@1000 :
                LoginMgt: Codeunit 418;
            BEGIN
            END;


        }
        field(38; "OLD_Validated Measurement"; Boolean)
        {
            CaptionML = ENU = 'Validated Measurement', ESP = 'Medici�n validada';
            Description = '### ELIMINAR ### no se usa';


        }
        field(39; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(41; "Certification Type"; Option)
        {
            OptionMembers = "Normal","Unit Price adjustment";
            CaptionML = ENU = 'Certification Type', ESP = 'Tipo de certificaci�n';
            OptionCaptionML = ENU = 'Normal,Unit Price adjustment', ESP = 'Normal,Ajuste precios';



        }
        field(42; "Redetermination Code"; Code[20])
        {
            TableRelation = "Job Redetermination"."Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                   "Validated" = CONST(true),
                                                                                                   "Adjusted" = CONST(false));
            CaptionML = ENU = 'Redetermination Code', ESP = 'C�digo redeterminaci�n';


        }
        field(63; "Certification Completed"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certificacion facturada', ESP = 'Completamente Certificado';
            Description = 'QB 1.08.14 JAV 22/02/21 Si est� completamente certificada la medici�n';
            Editable = false;


        }
        field(70; "Cancel No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancela la medici�n';
            Description = 'JAV 31/07/19: - Indica la que se ha cancelado con este registro';
            Editable = false;


        }
        field(71; "Cancel By"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancelada por';
            Description = 'JAV 31/07/19: - Indica la medici�n que cancela la actual';
            Editable = false;


        }
        field(80; "Document Filter"; Code[20])
        {
            FieldClass = FlowFilter;


        }
        field(81; "Sum Ant Med"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Document No." = FIELD(FILTER("Document Filter"))));
            CaptionML = ENU = 'Measured Amount', ESP = 'Suma Anterior Mediciones';
            Description = 'Suma anterior a PEM de las mediciones registradas';
            Editable = false;


        }
        field(83; "Sum Term"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Suma Periodo';
            Description = 'Suma a PEM de las l�neas del periodo';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(90; "Amount Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'A origen';


        }
        field(91; "Amount Previous"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Anterior';


        }
        field(92; "Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Periodo';


        }
        field(93; "Amount GG"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'GG';
            Editable = false;


        }
        field(94; "Amount BI"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'BI';
            Editable = false;


        }
        field(95; "Amount Low"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Baja';
            Editable = false;


        }
        field(96; "Amount Document"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe';
            Editable = false;


        }
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00 - JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(121; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(122; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(123; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '### ELIMINAR ### no se usa';


        }
        field(50000; "Expedient No."; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expedient No.', ESP = 'N� Expediente';
            Description = 'GAP029';

            trigger OnValidate();
            VAR
                //                                                                 Expedient@100000000 :
                Expedient: Record 7207393;
            BEGIN
            END;


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'TO-DO Debe pasar el dato de la aprobaci�n como referencia';


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
        //       Job@1100286000 :
        Job: Record 167;
        //       Currency@1100286006 :
        Currency: Record 4;
        //       HistMeasureLines@1100286003 :
        HistMeasureLines: Record 7207339;
        //       QBCommentLine@1100286002 :
        QBCommentLine: Record 7207270;
        //       ResponsibilityCenter@1100286001 :
        ResponsibilityCenter: Record 5714;
        //       UserSetupManagement@7001100 :
        UserSetupManagement: Codeunit 5700;
        //       DimensionManagement@7001103 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       Text027@7001106 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       UserManagement@7001108 :
        UserManagement: Codeunit "User Management 1";
        //       FunctionQB@100000000 :
        FunctionQB: Codeunit 7207272;
        //       HasGotSalesUserSetup@1100286005 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@1100286004 :
        UserRespCenter: Code[20];
        //       Text000@1100286007 :
        Text000: TextConst ESP = 'Tiene cantidades certificadas, no puede eliminar la medici�n';



    trigger OnDelete();
    begin
        LOCKTABLE;

        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Document No.", "No.");
        if (HistMeasureLines.FINDSET) then
            repeat
                if (HistMeasureLines."Certificated Quantity" <> 0) then
                    ERROR(Text000);
                HistMeasureLines.DELETE;
            until (HistMeasureLines.NEXT = 0);

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;



    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    //     procedure FilterResponsability (var HistMeasurements@1000000000 :
    procedure FilterResponsability(var HistMeasurements: Record 7207338)
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);

        if UserRespCenter <> '' then begin
            HistMeasurements.FILTERGROUP(2);
            HistMeasurements.SETRANGE("Responsibility Center", UserRespCenter);
            HistMeasurements.FILTERGROUP(0);
        end;
    end;

    procedure CalculateAmountMeasureNoCertification(): Decimal;
    begin
        CALCFIELDS("Measured Amount", "Certified Amount");
        exit("Measured Amount" - "Certified Amount");
    end;

    procedure CalculateAmountCertificationNoInoviced(): Decimal;
    begin
        CALCFIELDS("Certified Amount", "Invoiced Amount");
        exit("Certified Amount" - "Invoiced Amount");
    end;

    procedure ShowDimensions()
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    procedure FSR()
    begin
    end;

    procedure CalculaterAmountRedet(): Decimal;
    var
        //       LHistCertificationLines@1102201001 :
        LHistCertificationLines: Record 7207342;
        //       Sum@1102201002 :
        Sum: Decimal;
    begin
        Sum := 0;
        LHistCertificationLines.RESET;
        LHistCertificationLines.SETRANGE(LHistCertificationLines."Job No.", "Job No.");
        LHistCertificationLines.SETRANGE(LHistCertificationLines."Certification Type", LHistCertificationLines."Certification Type"::"Price adjustment");
        if LHistCertificationLines.FIND('-') then
            repeat
                Sum += LHistCertificationLines."Term Contract Amount";
            until LHistCertificationLines.NEXT = 0;
        exit(Sum);
    end;

    procedure CalculateTotals()
    begin
        //JAV 20/02/21: - Calculo del total del documento
        if not Job.GET("Job No.") then
            Job.INIT;
        SETFILTER("Document Filter", '<%1', "No.");
        CALCFIELDS("Sum Ant Med", "Sum Term");
        Currency.InitRoundingPrecision;

        "Amount Origin" := "Sum Ant Med" + "Sum Term";
        "Amount Previous" := "Sum Ant Med";
        "Amount Term" := "Sum Term";
        "Amount GG" := ROUND("Amount Term" * Job."General Expenses / Other" / 100, Currency."Amount Rounding Precision");
        "Amount BI" := ROUND("Amount Term" * Job."Industrial Benefit" / 100, Currency."Amount Rounding Precision");
        "Amount Low" := ROUND(("Amount Term" + "Amount GG" + "Amount BI") * Job."Low Coefficient" / 100, Currency."Amount Rounding Precision");
        "Amount Document" := ROUND("Amount Term" + "Amount GG" + "Amount BI" - "Amount Low", Currency."Amount Rounding Precision");
    end;

    //     procedure SetCaptions (var Captions@1100286000 :
    procedure SetCaptions(var Captions: ARRAY[10] OF Text)
    begin
        if not Job.GET("Job No.") then
            Job.INIT;

        Captions[1] := FIELDCAPTION("Amount Origin");
        Captions[2] := FIELDCAPTION("Amount Previous");
        Captions[3] := FIELDCAPTION("Amount Term");
        Captions[4] := FIELDCAPTION("Amount GG") + ' (' + FORMAT(Job."General Expenses / Other") + '%)';
        Captions[5] := FIELDCAPTION("Amount BI") + ' (' + FORMAT(Job."Industrial Benefit") + '%)';
        Captions[6] := FIELDCAPTION("Amount Low") + ' (' + FORMAT(Job."Low Coefficient") + '%)';
        Captions[7] := FIELDCAPTION("Amount Document");
    end;

    procedure AddLines()
    var
        //       HistMeasureLines@1100286002 :
        HistMeasureLines: Record 7207339;
        //       HistMeasureLines2@1100286003 :
        HistMeasureLines2: Record 7207339;
        //       LineNo@1100286001 :
        LineNo: Integer;
    begin
        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Document No.", Rec."No.");
        if (HistMeasureLines.FINDLAST) then
            LineNo := HistMeasureLines."Line No."
        else
            LineNo := 0;

        HistMeasureLines2.RESET;
        HistMeasureLines2.SETRANGE("Job No.", "Job No.");
        HistMeasureLines2.SETFILTER("Document No.", '<%1', Rec."No.");
        if HistMeasureLines2.FINDSET then
            repeat
                HistMeasureLines.RESET;
                HistMeasureLines.SETRANGE("Document No.", Rec."No.");
                HistMeasureLines.SETRANGE("Piecework No.", HistMeasureLines2."Piecework No.");
                if (HistMeasureLines.ISEMPTY) then begin
                    HistMeasureLines.TRANSFERFIELDS(HistMeasureLines2);

                    LineNo += 10000;
                    HistMeasureLines."Document No." := Rec."No.";
                    HistMeasureLines."Line No." := LineNo;
                    HistMeasureLines."Med. Term Measure" := 0;
                    HistMeasureLines."Certificated Quantity" := 0;
                    HistMeasureLines."Med. Term PEC Amount" := 0;
                    HistMeasureLines."Med. Term Amount" := 0;
                    HistMeasureLines.INSERT;
                end;
            until HistMeasureLines2.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 15/10/19: - Se elimina el campo 5 "Posting Description" que no se utiliza
//    }
    end.
  */
}








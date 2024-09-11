table 7207341 "Post. Certifications"
{


    CaptionML = ENU = 'Post. Certifications', ESP = 'Hist. certificaci�n';
    LookupPageID = "Post. Certifications List";
    DrillDownPageID = "Post. Certifications List";

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
            Editable = true;


        }
        field(10; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Certi. Hist."),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(11; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Term Contract Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "Certification Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Measurement Lines"."Med. Term PEC Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Certification Amount', ESP = 'Importe certificaci�n';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(15; "Certif. Amount to Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term PEC Amount" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Certif. Amount to Source', ESP = 'Importe a origen certif.';
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
            TableRelation = Job WHERE("Status" = CONST("Open"),
                                                                            "Job Type" = CONST("Operative"));
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(21; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';


        }
        field(22; "Measure Type"; Option)
        {
            OptionMembers = "Source","Term";
            CaptionML = ENU = 'Measure Type', ESP = 'Tipo medici�n';
            OptionCaptionML = ENU = 'Source,Term', ESP = 'Origen,Periodo';



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


        }
        field(39; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(41; "Certification Type"; Option)
        {
            OptionMembers = "Normal","Price adjustment";
            CaptionML = ENU = 'Certification Type', ESP = 'Tipo de certificaci�n';
            OptionCaptionML = ENU = 'Normal,Price adjustment', ESP = 'Normal,Ajuste precios';



        }
        field(42; "Redetermination Code"; Code[20])
        {
            TableRelation = "Job Redetermination"."Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                   "Validated" = CONST(true),
                                                                                                   "Adjusted" = CONST(false));
            CaptionML = ENU = 'Redetermination Code', ESP = 'C�digo redeterminaci�n';


        }
        field(48; "Certification Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de Certificaci�n';


        }
        field(49; "Total Amount Certification"; Decimal)
        {
            CaptionML = ENU = 'Total Amount Certification', ESP = 'Importe total certificaci�n';


        }
        field(50; "Invoiced Quantity"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Quantity', ESP = 'Cantidad facturada';


        }
        field(51; "OLD_Bill-to No. Customer"; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Bill-to No. Customer', ESP = 'Factura a N� cliente';
            Description = '### ELIMINAR ### no se usa';


        }
        field(52; "OLD_Cod. Payment Terms"; Code[10])
        {
            TableRelation = "Payment Terms";
            CaptionML = ENU = 'Cod. terminos pago', ESP = 'C�d. t�rminos pago';
            Description = '### ELIMINAR ### no se usa';


        }
        field(53; "OLD_Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';
            Description = '### ELIMINAR ### no se usa';


        }
        field(54; "OLD_% Payment Discount"; Decimal)
        {
            CaptionML = ENU = '% Payment Discount', ESP = '% Dto. P.P.';
            Description = '### ELIMINAR ### no se usa';


        }
        field(55; "OLD_Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Cod. forma pago', ESP = 'C�d. forma pago';
            Description = '### ELIMINAR ### no se usa';


        }
        field(56; "OLD_Payment In-Code"; Code[20])
        {
            CaptionML = ENU = 'Payment In-Code', ESP = 'Pago en-C�digo';
            Description = '### ELIMINAR ### no se usa';


        }
        field(57; "OLD_Customer Bank Code"; Code[20])
        {
            CaptionML = ENU = 'Customer Bank Code', ESP = 'C�d. banco cliente';
            Description = '### ELIMINAR ### no se usa';


        }
        field(59; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(60; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@1000 :
                LoginMgt: Codeunit 418;
            BEGIN
            END;


        }
        field(61; "Validated Measurement"; Boolean)
        {
            CaptionML = ENU = 'Medicion validada', ESP = 'Medici�n validada';


        }
        field(63; "Invoiced Certification"; Boolean)
        {
            CaptionML = ENU = 'Certificacion facturada', ESP = 'Certificaci�n facturada';
            Editable = false;


        }
        field(64; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned No. Series', ESP = 'N� serie preasignado';
            Description = 'QB28122';


        }
        field(65; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
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
        field(82; "Sum Ant Cert"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Cert Term PEM amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                             "Document No." = FIELD(FILTER("Document Filter"))));
            CaptionML = ENU = 'Measured Amount', ESP = 'Suma Anterior Certificaciones';
            Description = 'Suma anterior a PEM de las certificaciones registradas';
            Editable = false;


        }
        field(83; "Sum Term"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Cert Term PEM amount" WHERE("Document No." = FIELD("No.")));
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
        field(100; "Amount Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Facturado';


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
        //       Job@1100286002 :
        Job: Record 167;
        //       Currency@1100286001 :
        Currency: Record 4;
        //       HistCertificationLines@1100286005 :
        HistCertificationLines: Record 7207342;
        //       UserMgt@7001100 :
        UserMgt: Codeunit 5700;
        //       DimMgt@7001103 :
        DimMgt: Codeunit "DimensionManagement";
        //       err01@1100286000 :
        err01: TextConst ESP = 'No puede eliminar una certificacion registrada.';
        //       FunctionQB@100000000 :
        FunctionQB: Codeunit 7207272;
        //       HasGotSalesUserSetup@1100286004 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@1100286003 :
        UserRespCenter: Code[10];
        //       Text000@1100286006 :
        Text000: TextConst ESP = 'Ya ha facturado la certificaci�n, no se puede eliminar';



    trigger OnDelete();
    begin
        //JAV 22/02/21: - QB 1.08.14 Para borrar la cabecera debo eliminar las l�neas
        if ("Invoiced Certification") then
            ERROR(Text000);

        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.", "No.");
        HistCertificationLines.DELETEALL(TRUE);
    end;



    // procedure ResponsabilityFilter (var MeasureToFilter@1000000000 :
    procedure ResponsabilityFilter(var MeasureToFilter: Record 7207341)
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        if UserRespCenter <> '' then begin
            MeasureToFilter.FILTERGROUP(2);
            MeasureToFilter.SETRANGE("Responsibility Center", UserRespCenter);
            MeasureToFilter.FILTERGROUP(0);
        end;
    end;

    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    procedure CalcNotCertifMeasureAmount(): Decimal;
    begin
        CALCFIELDS("Measured Amount", "Certified Amount");
        exit("Measured Amount" - "Certified Amount");
    end;

    procedure CalcCertifiedAmountNotInvoiced(): Decimal;
    begin
        CALCFIELDS("Certified Amount", "Invoiced Amount");
        exit("Certified Amount" - "Invoiced Amount");
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    procedure FSR()
    begin
    end;

    procedure CalcRedetAmount(): Decimal;
    var
        //       PostCertifLines@1102201001 :
        PostCertifLines: Record 7207342;
        //       suma@1102201002 :
        suma: Decimal;
    begin
        suma := 0;
        PostCertifLines.RESET;
        PostCertifLines.SETRANGE(PostCertifLines."Job No.", "Job No.");
        PostCertifLines.SETRANGE(PostCertifLines."Certification Type", PostCertifLines."Certification Type"::"Price adjustment");
        if PostCertifLines.FIND('-') then
            repeat
                suma += PostCertifLines."Term Contract Amount";
            until PostCertifLines.NEXT = 0;
        exit(suma);
    end;

    procedure CalculateTotals()
    begin
        //JAV 20/02/21: - Calculo del total del documento
        if not Job.GET("Job No.") then
            Job.INIT;

        SETFILTER("Document Filter", '<%1', "No.");
        CALCFIELDS("Sum Ant Cert", "Sum Term");
        Currency.InitRoundingPrecision;

        "Amount Previous" := "Sum Ant Cert";
        "Amount Origin" := "Amount Previous" + "Sum Term";
        "Amount Term" := "Amount Origin" - "Amount Previous";
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
        //       HistCertificationLines@1100286002 :
        HistCertificationLines: Record 7207342;
        //       HistCertificationLines2@1100286003 :
        HistCertificationLines2: Record 7207342;
        //       LineNo@1100286001 :
        LineNo: Integer;
    begin
        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.", "No.");
        if (HistCertificationLines.FINDLAST) then
            LineNo := HistCertificationLines."Line No."
        else
            LineNo := 0;

        HistCertificationLines2.RESET;
        HistCertificationLines2.SETFILTER("Document No.", '<%1', "No.");            //Solo las anteriores
        HistCertificationLines2.SETRANGE("Job No.", "Job No.");                      //Del mismo proyecto
        if HistCertificationLines2.FINDSET then
            repeat
                HistCertificationLines.RESET;
                HistCertificationLines.SETRANGE("Document No.", Rec."No.");
                HistCertificationLines.SETRANGE("Piecework No.", HistCertificationLines2."Piecework No.");
                if (HistCertificationLines.ISEMPTY) then begin
                    HistCertificationLines.TRANSFERFIELDS(HistCertificationLines2);

                    LineNo += 10000;
                    HistCertificationLines."Document No." := Rec."No.";
                    HistCertificationLines."Line No." := LineNo;
                    HistCertificationLines."Cert Quantity to Term" := 0;
                    HistCertificationLines."Cert Term PEM amount" := 0;
                    HistCertificationLines."Cert Term PEC amount" := 0;
                    HistCertificationLines.INSERT;
                end;
            until HistCertificationLines2.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 14/03/19: - No se pueden borrar sin mas las certificaciones registradas, se cambia el OnDelete y se a�ade un texto global
//      JAV 04/06/19: - Se cambian los flofield de los campos amount y Measured Amount que estaban apuntado a la tabla que no era
//      JAV 15/10/19: - Se elimina el campo 5 "Posting Description" que no se utiliza
//                    - Se eliminan los campos 47 "Certification No.", 48 "Certification Date" y 58 "Certification Text", se usan en su lugar "No. Measure", "Measurement Date" y "Text Measure"
//    }
    end.
  */
}








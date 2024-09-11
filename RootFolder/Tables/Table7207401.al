table 7207401 "Hist. Prod. Measure Header"
{


    CaptionML = ENU = 'Hist. Prod. Measure Header', ESP = 'Hist. Cab. Relaci�n Valorada';
    LookupPageID = "Post. Prod. Measurement List";
    DrillDownPageID = "Post. Prod. Measurement List";

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
        field(5; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


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
            Description = '???';
            Editable = false;


        }
        field(9; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Description = '???';


        }
        field(10; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Measure"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
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
            Description = 'Viene del borrador';


        }
        field(15; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';
            Description = 'JAV 31/07/19: - se igualan las tablas registro e hist�rica';


        }
        field(17; "Measure Date"; Date)
        {
            CaptionML = ENU = 'Date Measured', ESP = 'Fecha medici�n';


        }
        field(18; "Measurement No."; Code[10])
        {
            CaptionML = ENU = 'Number of Measurements', ESP = 'N�mero de medici�n';


        }
        field(19; "Last Measurement"; Boolean)
        {
            CaptionML = ENU = 'Last Measurement', ESP = 'Ultima medici�n';


        }
        field(20; "Measurement Text"; Text[30])
        {
            CaptionML = ENU = 'Measurement Text', ESP = 'Texto medici�n';


        }
        field(21; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(22; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';


        }
        field(24; "Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';


        }
        field(25; "Address"; Text[50])
        {
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';


        }
        field(26; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';


        }
        field(27; "City"; Text[50])
        {
            CaptionML = ENU = 'City', ESP = 'Poblaci�n';


        }
        field(28; "Contact"; Text[50])
        {
            CaptionML = ENU = 'Contact', ESP = 'Contacto';


        }
        field(29; "County"; Text[50])
        {
            CaptionML = ENU = 'County', ESP = 'Provincia';


        }
        field(30; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            CaptionML = ENU = 'Post Code', ESP = 'C.P.';


        }
        field(31; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Country/Region Code', ESP = 'C�d. Pa�s';


        }
        field(32; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 ResponsibilityCenter@7001102 :
                ResponsibilityCenter: Record 5714;
                //                                                                 UserSetupManagement@7001100 :
                UserSetupManagement: Codeunit 5700;
                //                                                                 Text027@7001101 :
                Text027: TextConst ENU = 'Your identification is set up to process from %1 to %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 a %2.';
                //                                                                 UserRespCenter@7001104 :
                UserRespCenter: Code[10];
                //                                                                 HasGotServUserSetup@7001103 :
                HasGotServUserSetup: Boolean;
            BEGIN
                IF NOT UserSetupManagement.CheckRespCenter(3, "Responsibility Center") THEN BEGIN
                    FunctionQB.GetJobFilter(HasGotServUserSetup, UserRespCenter);
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, UserRespCenter);
                END;
            END;


        }
        field(33; "Validated Measurement"; Boolean)
        {
            CaptionML = ENU = 'Validated Measurement', ESP = 'Medici�n validada';


        }
        field(34; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. Usuario';

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@1000 :
                LoginMgt: Codeunit "User Management 1";
            BEGIN
                LoginMgt.LookupUserID("User ID");
            END;


        }
        field(35; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(50; "Document Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ESP = 'Filtro Documento';


        }
        field(52; "DOC Import Previous"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Realiced" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount of Relationship Valued', ESP = 'Importe Anterior';
            Description = 'JAV 02/06/21 : - Importe anterior de esta relaci�n valorada';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(53; "DOC Import Term"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Term" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount of Relationship Valued', ESP = 'Importe Periodo';
            Description = 'JAV 02/06/21 : - Importe periodo de esta relaci�n valorada';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(54; "DOC Import to Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount to Source" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Import to Source', ESP = 'Importe a origen';
            Description = 'Producci�n a origen s�lo de las partidas incluidas en esta valorada //JMMA';
            Editable = false;


        }
        field(57; "JOB Date to Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Term" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Posting Date" = FIELD(FILTER("Date Filter"))));
            CaptionML = ENU = 'Total production from begining', ESP = '" Proyecto a la fecha"';
            Description = 'A�adido JMMA permite tener la producci�n a origen registrada hasta esta relaci�n valorada';
            Editable = false;


        }
        field(58; "JOB Total to Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Term" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Total production from begining', ESP = 'Proyecto a origen';
            Description = 'A�adido JMMA permite tener la producci�n a origen registrada de la obra completa';
            Editable = false;


        }
        field(70; "Cancel No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancela la medici�n';
            Description = 'JAV 31/07/19: - Indica la que se ha cancelado con esta medici�n';
            Editable = false;


        }
        field(71; "Cancel By"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancelada por';
            Description = 'JAV 31/07/19: - Indica la medici�n que cancela la actual';
            Editable = false;


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


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
        //       HistProdMeasureLines@7001100 :
        HistProdMeasureLines: Record 7207402;
        //       QBCommentLine@7001101 :
        QBCommentLine: Record 7207270;
        //       userSetupManagement@7001102 :
        userSetupManagement: Codeunit 5700;
        //       HasGotSalesUserSetup@7001103 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001104 :
        UserRespCenter: Code[10];
        //       FunctionQB@100000000 :
        FunctionQB: Codeunit 7207272;



    trigger OnDelete();
    begin
        LOCKTABLE;

        HistProdMeasureLines.RESET;
        HistProdMeasureLines.SETRANGE("Document No.", "No.");
        HistProdMeasureLines.DELETEALL(TRUE);

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;



    procedure ShowDimensions()
    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    //     procedure FunFilterResponsibility (var measureToFilter@1000000000 :
    procedure FunFilterResponsibility(var measureToFilter: Record 7207401)
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);

        if UserRespCenter <> '' then begin
            measureToFilter.FILTERGROUP(2);
            measureToFilter.SETRANGE("Responsibility Center", UserRespCenter);
            measureToFilter.FILTERGROUP(0);
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

    /*begin
    //{
//      JAV 31/07/19: - Se igualan los campos de las tablas registro e hist�rica
//                    - Se a�aden los campos 37"Cancel No." que indica la que se ha cancelado con esta medici�n y 38 "Cancel By" que indica la medici�n que cancela la actual
//      JAV 24/06/22: - QB 1.10.53 Se cambian los campos "xxx PEC xxx" por "xxx xxx" que es mas apropiado
//    }
    end.
  */
}








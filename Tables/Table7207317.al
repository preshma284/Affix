table 7207317 "QBU Hist. Reestimation Header"
{


    LookupPageID = "Hist. Reestimation hdr. List";
    DrillDownPageID = "Hist. Reestimation hdr. List";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            NotBlank = true;


        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(5; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(6; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(10; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;


        }
        field(11; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Rest. Hist."),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(12; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Reestimation Lines"."Amount" WHERE("Document No." = FIELD("No.")));
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
        field(17; "Reestimation code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Reestimation code', ESP = 'C�d. reestimaci�n';

            trigger OnLookup();
            VAR
                //                                                               FunctionQB@7001100 :
                FunctionQB: Codeunit 7207272;
                //                                                               DimensionValue@7001101 :
                DimensionValue: Record 349;
            BEGIN
                FunctionQB.LookUpReest(DimensionValue."Dimension Code", FALSE);
            END;


        }
        field(18; "Reestimation date"; Date)
        {
            CaptionML = ENU = 'Reestimation date', ESP = 'Fecha reestimaci�n';


        }
        field(19; "Responsibility center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 UserSetupManagement@7001100 :
                UserSetupManagement: Codeunit 5700;
                //                                                                 ResponsibilityCenter@7001101 :
                ResponsibilityCenter: Record 5714;
            BEGIN
                IF NOT UserSetupManagement.CheckRespCenter(3, "Responsibility center") THEN BEGIN
                    FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, UserRespCenter);
                END;
            END;


        }
        field(20; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(22; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               LoginMgt@1000 :
                LoginMgt: Codeunit "User Management 1";
            BEGIN
                LoginMgt.LookupUserID("Responsibility center");
            END;


        }
        field(23; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(24; "Outst. expenses amount est."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Reestimation Lines"."Estimated outstanding amount" WHERE("Document No." = FIELD("No."),
                                                                                                                                    "Type" = FILTER("Expenses")));
            CaptionML = ENU = 'Outstanding expenses amount estimated', ESP = 'Imp. gastos pdte. estimados';


        }
        field(25; "Expenses amount to est. origin"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Reestimation Lines"."Total amount to estimated orig" WHERE("Document No." = FIELD("No."),
                                                                                                                                      "Type" = FILTER("Expenses")));
            CaptionML = ENU = 'Expenses amount to est. origin', ESP = 'Imp. gastos a origen estim.';


        }
        field(26; "Outst. incomes amount est."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Reestimation Lines"."Estimated outstanding amount" WHERE("Document No." = FIELD("No."),
                                                                                                                                    "Type" = FILTER("Incomes")));
            CaptionML = ENU = 'Outstanding incomes amount estimated', ESP = 'Imp. ingresos pdte. estimados';


        }
        field(27; "Incomes amount to est. origin"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Reestimation Lines"."Total amount to estimated orig" WHERE("Document No." = FIELD("No."),
                                                                                                                                      "Type" = FILTER("Incomes")));
            CaptionML = ENU = 'Incomes amount to estimated origin', ESP = 'Imp. ingresos a origen estim.';
            ;


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
        //       Text027@7001100 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       HasGotSalesUserSetup@7001102 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001101 :
        UserRespCenter: Code[10];
        //       FunctionQB@100000000 :
        FunctionQB: Codeunit 7207272;



    trigger OnDelete();
    var
        //                QBCommentLine@7001100 :
        QBCommentLine: Record 7207270;
        //                HistReestimationLines@7001101 :
        HistReestimationLines: Record 7207318;
    begin
        LOCKTABLE;

        HistReestimationLines.RESET;
        HistReestimationLines.SETRANGE("Document No.", "No.");
        HistReestimationLines.DELETEALL(TRUE);

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

    //     procedure ResponsibilityFilters (var ParteAFiltrar@1000000000 :
    procedure ResponsibilityFilters(var ParteAFiltrar: Record 7207317)
    var
        //       UserSetupManagement@7001100 :
        UserSetupManagement: Codeunit 5700;
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        if UserRespCenter <> '' then begin
            ParteAFiltrar.FILTERGROUP(2);
            ParteAFiltrar.SETRANGE("Responsibility center", UserRespCenter);
            ParteAFiltrar.FILTERGROUP(0);
        end;
    end;

    procedure ShowDimensions()
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        DimensionManagement.ShowDimensionSet("Expenses amount to est. origin", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    end.
  */
}








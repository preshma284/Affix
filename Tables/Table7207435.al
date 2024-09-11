table 7207435 "QBU Costsheet Header Hist."
{


    CaptionML = ENU = 'Costsheet Header Hist.', ESP = 'Hist. Cab. Partes Coste';
    LookupPageID = "Costsheet Hist. List";
    DrillDownPageID = "Costsheet Hist. List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(2; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(3; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(4; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(5; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Sheet Hist."),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(8; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(10; "Responsability Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsability Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 HasGotSalesUserSetup@7001102 :
                HasGotSalesUserSetup: Boolean;
                //                                                                 UserRespCenter@7001101 :
                UserRespCenter: Code[20];
                //                                                                 UserSetupManagement@7001100 :
                UserSetupManagement: Codeunit 5700;
            BEGIN
                FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                IF NOT CUUserSetupManagement.CheckRespCenter(3, "Responsability Center") THEN
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, UserRespCenter);
            END;


        }
        field(11; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(12; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Costsheet Lines Hist."."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ESP = 'Importe Total';
            Description = 'QB 1.10.46 JAV 01/06/22: - Suma de importe de las l�neas';
            Editable = false;


        }
        field(100; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned No. Series', ESP = 'N� serie preasignado';


        }
        field(101; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuarios';

            trigger OnLookup();
            VAR
                //                                                               CUUserManagement_loc@1000 :
                CUUserManagement_loc: Codeunit "User Management 1";
            BEGIN
                CUUserManagement_loc.LookupUserID("User ID");
            END;


        }
        field(102; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';
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
        //       CostsheetHeaderHist@7001101 :
        CostsheetHeaderHist: Record 7207435;
        //       CostsheetLinesHist@7001102 :
        CostsheetLinesHist: Record 7207436;
        //       QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
        //       CUDimensionManagement@7001104 :
        CUDimensionManagement: Codeunit "DimensionManagement";
        //       CUUserSetupManagement@7001105 :
        CUUserSetupManagement: Codeunit 5700;
        //       ResponsibilityCenter@7001106 :
        ResponsibilityCenter: Record 5714;
        //       FunctionQB@100000000 :
        FunctionQB: Codeunit 7207272;



    trigger OnDelete();
    begin
        LOCKTABLE;

        CostsheetLinesHist.RESET;
        CostsheetLinesHist.SETRANGE("Document No.", "No.");
        CostsheetLinesHist.DELETEALL(TRUE);

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

    //     procedure ResponsabilityFilters (var CostsheetHeaderFilter@7001104 :
    procedure ResponsabilityFilters(var CostsheetHeaderFilter: Record 7207435)
    var
        //       UserSetupManagement@7001103 :
        UserSetupManagement: Codeunit 5700;
        //       HasGotSalesUserSetup@7001102 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001101 :
        UserRespCenter: Code[20];
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        if UserRespCenter <> '' then begin
            CostsheetHeaderFilter.FILTERGROUP(2);
            CostsheetHeaderFilter.SETRANGE("Responsability Center", UserRespCenter);
            CostsheetHeaderFilter.FILTERGROUP(0);
        end;
    end;

    procedure ShowDimensions()
    begin
        CUDimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    //{
//      JAV 01/06/22: - QB 1.10.46 Se a�ade el campo Amount con la suma de las l�neas
//    }
    end.
  */
}








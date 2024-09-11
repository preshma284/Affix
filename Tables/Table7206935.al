table 7206935 "QBU External Worksheet Header P"
{


    CaptionML = ENU = 'Posted Externals Worksheet', ESP = 'Hist. parte de trabajo de externos';
    LookupPageID = "QB Worksheet List Hist.";
    DrillDownPageID = "QB Worksheet List Hist.";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(2; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Resource /Job', ESP = 'Proveedor subcontrata';


        }
        field(3; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Description', ESP = 'Nombre';
            Editable = false;


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
        field(9; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Sheet Hist."),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(10; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Worksheet Lines Hist."."Total Cost" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;


        }
        field(11; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(12; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned No. Series', ESP = 'N� serie preasignado';


        }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(16; "Sheet Date"; Date)
        {
            CaptionML = ENU = 'Sheet Date', ESP = 'Fecha de parte';


        }
        field(17; "Allocation Term"; Code[10])
        {
            CaptionML = ENU = 'Allocation Term', ESP = 'Per�odo de imputaci�n';


        }
        field(18; "No. Hours"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Worksheet Lines Hist."."Quantity" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'No. Hours', ESP = 'N� de horas';
            Editable = false;


        }
        field(19; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            BEGIN

                IF NOT UserMgt.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(
                      Text027,
                       Respcenter.TABLECAPTION, FunctionQB.GetUserJobResponsibilityCenter());
            END;


        }
        field(20; "User ID"; Code[50])
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
                LoginMgt.LookupUserID("Allocation Term");
            END;


        }
        field(21; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(26; "Dimension Set ID"; Integer)
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
        //       WorksheetHeaderHist@7001105 :
        WorksheetHeaderHist: Record 7207292;
        //       WorksheetLinesHist@7001104 :
        WorksheetLinesHist: Record 7207293;
        //       QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
        //       DimMgt@7001102 :
        DimMgt: Codeunit "DimensionManagement";
        //       UserMgt@7001101 :
        UserMgt: Codeunit 5700;
        //       Respcenter@7001100 :
        Respcenter: Record 5714;
        //       Text027@7001106 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       FunctionQB@7001107 :
        FunctionQB: Codeunit 7207272;



    trigger OnDelete();
    begin
        LOCKTABLE;

        WorksheetLinesHist.RESET;
        WorksheetLinesHist.SETRANGE("Document No.", "No.");
        WorksheetLinesHist.DELETEALL(TRUE);

        QBCommentLine.RESET;
        QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::ExternalSheetHist);
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

    //     procedure FunFilterResponsibility (var SheetToFilter@1000000000 :
    procedure FunFilterResponsibility(var SheetToFilter: Record 7207292)
    begin

        if FunctionQB.GetUserJobResponsibilityCenter <> '' then begin
            SheetToFilter.FILTERGROUP(2);
            SheetToFilter.SETRANGE("Responsibility Center", FunctionQB.GetUserJobResponsibilityCenter);
            SheetToFilter.FILTERGROUP(0);
        end;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    end.
  */
}








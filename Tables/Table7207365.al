table 7207365 "QBU Usage Header Hist."
{


    CaptionML = ENU = 'Usage Header Hist.', ESP = 'Hist. Cabecera utilizaci�n';
    LookupPageID = "Usage Header Hist. List";
    DrillDownPageID = "Usage Header Hist. List";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header";
            CaptionML = ENU = 'Contract Code', ESP = 'C�d. Contrato';
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
        field(5; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";
            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'N� Cliente/Proveedor';


        }
        field(6; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Job" ELSE IF ("Contract Type" = CONST("Vendor")) "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(7; "Usage Date"; Date)
        {
            CaptionML = ENU = 'Usage Date', ESP = 'Fecha utilizaci�n';


        }
        field(8; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(9; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(10; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(13; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(14; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;


        }
        field(15; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Usage Comment Line" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(16; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Usage Line Hist."."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(17; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(18; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(21; "Vendor Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Vendor Contract Code', ESP = 'C�d. contrato proveedor';
            Editable = false;


        }
        field(22; "Preassigned Sheet Draft No."; Code[20])
        {
            CaptionML = ENU = 'Preassigned Sheet Draft No.', ESP = 'N� borrador parte preasignado';
            Editable = false;


        }
        field(25; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


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
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               CUUserManagement@1000 :
                CUUserManagement: Codeunit "User Management 1";
            BEGIN
                CUUserManagement.LookupUserID("User ID");
            END;


        }
        field(102; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(103; "Generated Worksheet"; Boolean)
        {
            CaptionML = ENU = 'Generated Worksheet', ESP = 'Parte de trabajo generado';
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
        //       UsageHeaderHist@7001103 :
        UsageHeaderHist: Record 7207365;
        //       UsageLineHist@7001102 :
        UsageLineHist: Record 7207366;
        //       UsageCommentLine@7001101 :
        UsageCommentLine: Record 7207364;
        //       CUDimensionManagement@7001100 :
        CUDimensionManagement: Codeunit "DimensionManagement";



    trigger OnDelete();
    begin
        LOCKTABLE;

        UsageLineHist.RESET;
        UsageLineHist.SETRANGE("Document No.", "No.");
        UsageLineHist.DELETEALL(TRUE);

        UsageCommentLine.SETRANGE("No.", "No.");
        UsageCommentLine.DELETEALL;
    end;



    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    procedure ShowDimensions()
    begin
        CUDimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    end.
  */
}








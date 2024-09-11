table 7207370 "Activation Header Hist."
{


    CaptionML = ENU = 'Activation Header Hist.', ESP = 'Hist. Cabecera activaci�n';
    LookupPageID = "Activation Header Hist. List";
    DrillDownPageID = "Activation Header Hist. List";

    fields
    {
        field(1; "Element Code"; Code[20])
        {
            TableRelation = "Rental Elements";
            CaptionML = ENU = 'Element Code', ESP = 'Cod. elemento';
            NotBlank = true;


        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'No.';


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
            CaptionML = ENU = 'Posting Description', ESP = 'Descripci�n Registro';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';
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
            CalcFormula = Exist("Activation Comments Line" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(12; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Activation Line"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatExpression = "Currency Code";


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(14; "Pre-Assigned Serial No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned Serial No.', ESP = 'N� serie preasignado';


        }
        field(15; "Serial No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serial No.', ESP = 'No. serie';
            Editable = false;


        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(17; "Variant"; Code[10])
        {
            TableRelation = "Item Variant"."Item No." WHERE("Item No." = FIELD("Item"));
            CaptionML = ENU = 'Variant', ESP = 'Variante';


        }
        field(18; "Item"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Rental Elements"."Related Product" WHERE("No." = FIELD("Element Code")));
            CaptionML = ENU = 'Item', ESP = 'Producto';


        }
        field(19; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimension';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(20; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            VAR
                //                                                               UserManagement@1000 :
                UserManagement: Codeunit "User Management 1";
            BEGIN
                UserManagement.LookupUserID("User ID");
            END;


        }
        field(21; "Source Code"; Code[10])
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
        //       ActivationHeaderHist@7001103 :
        ActivationHeaderHist: Record 7207370;
        //       ActivationLineHist@7001102 :
        ActivationLineHist: Record 7207371;
        //       ActivationCommentsLine@7001101 :
        ActivationCommentsLine: Record 7207369;
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";



    trigger OnDelete();
    begin
        LOCKTABLE;
        ActivationLineHist.RESET;
        ActivationLineHist.SETRANGE("Document No.", "No.");
        ActivationLineHist.DELETEALL(TRUE);

        ActivationCommentsLine.SETRANGE("No.", "No.");
        ActivationCommentsLine.DELETEALL;
    end;



    procedure Navigate()
    var
        //       Navigate@1000 :
        Navigate: Page "Navigate";
    begin
        Navigate.SetDoc("Posting Date", "No.");
        Navigate.RUN;
    end;

    procedure ShowDimensions()
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    end.
  */
}








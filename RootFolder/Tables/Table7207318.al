table 7207318 "Hist. Reestimation Lines"
{


    DrillDownPageID = "Post. Reestim. Lines Subform.";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'Document No.';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;


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
        field(10; "G/L Account"; Text[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENU = 'G/L Account', ESP = 'N� cuenta';


        }
        field(11; "Budget Amount"; Decimal)
        {
            CaptionML = ENU = 'Budget Amount', ESP = 'Importe presupuesto';
            Editable = false;


        }
        field(12; "Realized Amount"; Decimal)
        {
            CaptionML = ENU = 'Realized Amount', ESP = 'Importe realizado';
            Editable = false;


        }
        field(13; "Realized Excess"; Decimal)
        {
            CaptionML = ENU = 'Realized Excess', ESP = 'Exceso de realizado';


        }
        field(14; "Estimated outstanding amount"; Decimal)
        {
            CaptionML = ENU = 'Estimated outstanding amount', ESP = 'Importe pendiente estimado';


        }
        field(15; "Total amount to estimated orig"; Decimal)
        {
            CaptionML = ENU = 'Total amount to estimated origin', ESP = 'Importe total a origen estim.';


        }
        field(16; "Analytical concept"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'Analytical concept', ESP = 'Concepto anal�tico';


        }
        field(18; "Type"; Option)
        {
            OptionMembers = "Expenses","Incomes";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Expenses,Incomes', ESP = 'Gastos,Ingresos';

            Editable = false;


        }
        field(19; "Reestimation code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'Reestimation code', ESP = 'C�d. reestimaci�n';
            Editable = false;


        }
        field(21; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount";
            Clustered = true;
        }
        key(key2; "Document No.", "Type")
        {
            SumIndexFields = "Estimated outstanding amount", "Total amount to estimated orig";
        }
    }
    fieldgroups
    {
    }


    LOCAL // procedure GetFieldCaption (FieldNo@1000 :
procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Hist. Reestimation Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    procedure ShowDimensions()
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    procedure GetCurrencyCode(): Code[10];
    var
        //       PurchInvHeader@1000 :
        PurchInvHeader: Record 122;
    begin
        if ("Document No." = PurchInvHeader."No.") then
            exit(PurchInvHeader."Currency Code")
        else
            if PurchInvHeader.GET("Document No.") then
                exit(PurchInvHeader."Currency Code")
            else
                exit('');
    end;

    /*begin
    end.
  */
}








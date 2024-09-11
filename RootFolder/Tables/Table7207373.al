table 7207373 "Hist. Element Contract Header"
{


    CaptionML = ENU = 'Hist. Element Contract Header', ESP = 'Hist. cab. contrato elemento';
    LookupPageID = "His. Element Contract List";
    DrillDownPageID = "His. Element Contract List";

    fields
    {
        field(1; "Document State"; Option)
        {
            OptionMembers = "Open","Released";
            CaptionML = ENU = 'Document State', ESP = 'Estado documento';
            OptionCaptionML = ENU = 'Open,Released', ESP = 'Abierto,Lanzado';

            Editable = false;


        }
        field(2; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";
            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'No. cliente/proveedor';


        }
        field(3; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'No.';


        }
        field(4; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Vendor")) "Job" ELSE IF ("Contract Type" = CONST("Customer")) "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(5; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(6; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(7; "Contract Date"; Date)
        {
            CaptionML = ENU = 'Contract Date', ESP = 'Fecha contrato';


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
            CaptionML = ENU = 'Posting Description', ESP = 'Descripci�n registro';


        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(13; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';


        }
        field(14; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(15; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Element Contract Comment Lines" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(16; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Element Contract Line"."Quantity to Send" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(17; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(18; "Series No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Series No.', ESP = 'No. Series';
            Editable = false;


        }
        field(19; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Posting No. Series', ESP = 'No. serie registro';


        }
        field(20; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(21; "Vendor Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Vendor Contract Code', ESP = 'Cod. contrato proveedor';


        }
        field(22; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(24; "Elements Situation Line No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Rental Elements" WHERE("Contract Filter" = FIELD("No."),
                                                                                              "Delivered Quantity" = FILTER(<> 0)));
            CaptionML = ENU = 'Elements Situation Line No.', ESP = 'No. l�neas situaci�n elemento';


        }
        field(25; "Time Archived"; Time)
        {
            CaptionML = ENU = 'Time Archived', ESP = 'Hora archivo';


        }
        field(26; "Date Archived"; Date)
        {
            CaptionML = ENU = 'Date Archived', ESP = 'Fecha archivo';


        }
        field(27; "Archive by"; Code[20])
        {
            CaptionML = ENU = 'Archive by', ESP = 'Archivado por';
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
        //       HistElementContractLine@7001100 :
        HistElementContractLine: Record 7207374;
        //       ElementContractCommentLines@7001101 :
        ElementContractCommentLines: Record 7207355;
        //       Text003@7001102 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       DimensionManagement@7001103 :
        DimensionManagement: Codeunit "DimensionManagement";



    trigger OnDelete();
    begin
        // Se borran las dimenciones asociadas al documento
        HistElementContractLine.LOCKTABLE;
        // Se borran las l�neas asociadas al documento
        HistElementContractLine.SETRANGE("Document No.", "No.");
        if HistElementContractLine.FINDSET then
            HistElementContractLine.DELETEALL;


        // Se borran los comentarios asociados
        ElementContractCommentLines.SETRANGE("No.", "No.");
        ElementContractCommentLines.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    procedure ConfirmDeletion(): Boolean;
    begin
        //Aqui estableceremos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba
        //PurchPost.TestDeleteHeader(Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,ReturnShptHeader);
        exit(TRUE);
    end;

    procedure ShowDimensions()
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    /*begin
    end.
  */
}








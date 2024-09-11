table 7207359 "QBU Hist. Head. Deliv/Ret. Element"
{


    CaptionML = ENU = 'Hist. Head. Deliv/Ret. Element', ESP = 'Hist. Cab.Entrega/Devol Elemen';
    LookupPageID = "Hist. Head. Deliv Element List";
    DrillDownPageID = "Hist. Head. Deliv Element List";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header"."No." WHERE("Customer/Vendor No." = FIELD("Customer/Vendor No."),
                                                                                                      "Job No." = CONST('Job No.'),
                                                                                                      "Document Status" = CONST("Released"));
            CaptionML = ENU = 'Contract Code', ESP = 'Cod. contrato';


        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(5; "Document Type"; Option)
        {
            OptionMembers = "Delivery","Return";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo Documento';
            OptionCaptionML = ENU = 'Delivery,Return', ESP = 'Entrega,Devolucion';



        }
        field(6; "Order Date"; Date)
        {
            CaptionML = ENU = 'Order Date', ESP = 'Fecha Pedido';


        }
        field(7; "Rent Effective Date"; Date)
        {
            CaptionML = ENU = 'Rent Effective Date', ESP = 'Fecha efectiva alquiler';


        }
        field(8; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";
            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'N� Cliente/Proveedor';


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Vendor")) "Job" ELSE IF ("Contract Type" = CONST("Customer")) "Job";
            CaptionML = ESP = 'No. proyecto';


        }
        field(10; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo Contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(11; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(12; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(15; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(16; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;


        }
        field(17; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Lines Commen Deliv/Ret Element" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(18; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Lin. Deliv/Return Elem."."Unit Price" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(19; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(20; "Series No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Series No.', ESP = 'No. series';
            Editable = false;


        }
        field(22; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(23; "Weight to Handle"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Line Delivery/Return Element"."Weight to Manipulate" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Weight to Handle', ESP = 'Peso a manipular';
            Editable = false;


        }
        field(24; "Elements Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Line Delivery/Return Element"."Quantity" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Elements Quantity', ESP = 'Cantidad de elementos';
            Editable = false;


        }
        field(25; "Dimensions Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimensions Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(27; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Pre-Assigned No. Series', ESP = 'N� serie preasignado';


        }
        field(28; "User ID"; Code[50])
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
        field(29; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'C�d. origen';


        }
        field(30; "Source Document"; Code[20])
        {
            CaptionML = ENU = 'Source Document', ESP = 'Documento origen';
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




    trigger OnDelete();
    var
        //                HistLinDelivReturnElem@7207270 :
        HistLinDelivReturnElem: Record 7207360;
        //                LinesCommenDelivRetElement@7207271 :
        LinesCommenDelivRetElement: Record 7207358;
    begin
        LOCKTABLE;

        HistLinDelivReturnElem.RESET;
        HistLinDelivReturnElem.SETRANGE("Document No.", "No.");
        HistLinDelivReturnElem.DELETEALL(TRUE);

        LinesCommenDelivRetElement.SETRANGE("No.", "No.");
        LinesCommenDelivRetElement.DELETEALL;
    end;



    procedure ShowDimensions()
    var
        //       DimensionManagement@7207270 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        DimensionManagement.ShowDimensionSet("Dimensions Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.RUN;
    end;

    //     procedure PrintRecords (ShowRequestForm@1000 :
    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        //       ReportSelection@1001 :
        ReportSelection: Record 77;
        //       HistHeadDelivRetElement@7207270 :
        HistHeadDelivRetElement: Record 7207359;
    begin
        /*To be Tested*/
        // WITH HistHeadDelivRetElement DO begin
        COPY(Rec);
        ReportSelection.SETRANGE(Usage, 54);
        ReportSelection.SETFILTER("Report ID", '<>0');
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //ReportSelection.FINDSET(FALSE, FALSE);
        ReportSelection.FINDSET(FALSE);
        repeat
            REPORT.RUNMODAL(ReportSelection."Report ID", ShowRequestForm, FALSE, HistHeadDelivRetElement);
        until ReportSelection.NEXT = 0;
        // end;
    end;

    /*begin
    end.
  */
}








table 7207310 "Posted Output Shipment Header"
{


    CaptionML = ENU = 'Posted Warehouse Shipment Header', ESP = 'Hist. Salida Almac�n Obra';
    LookupPageID = "Posted Output Shipment Header";
    DrillDownPageID = "Posted Output Shipment Header";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. Proyecto';


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
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dire. 1';
            CaptionClass = '1,2,1';


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(9; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Receipt"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(10; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Output Shipment Lines"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;


        }
        field(11; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�digo auditor�a';


        }
        field(12; "Pre-Assigned No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'No. serie';
            Editable = false;


        }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Posting Series No.', ESP = 'N� serie registro';


        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(15; "Request Filter"; Date)
        {
            CaptionML = ENU = 'Request Filter', ESP = 'Fecha solicitud';


        }
        field(16; "Stock Regulation"; Boolean)
        {
            CaptionML = ENU = 'Stock Regulation', ESP = 'Regulaci�n stock';


        }
        field(17; "Sales Shipment Origin"; Boolean)
        {
            CaptionML = ENU = 'Sales Shipment Origin', ESP = 'Origen albar�n ventas';
            Editable = false;


        }
        field(18; "Sales Document No."; Code[20])
        {
            CaptionML = ENU = 'Sales Document No.', ESP = 'No. documento ventas';


        }
        field(19; "Documnet Type"; Option)
        {
            OptionMembers = "Shipment","Invoice","Credir Memo","Receipt.Return";
            CaptionML = ENU = 'Documnet Type', ESP = 'Tipo de documento';
            OptionCaptionML = ENU = 'Shipment,Invoice,Credir Memo,Receipt.Return', ESP = 'Albaran,Factura,Abono,Recep.Devolucion';



        }
        field(20; "Total Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Output Shipment Lines"."Total Cost" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';


        }
        field(21; "Total Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Posted Output Shipment Lines"."Quantity" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Quantity', ESP = 'Cantidad total';


        }
        field(22; "Responsability Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsability Center', ESP = 'Centro responsabiidad';

            trigger OnValidate();
            VAR
                //                                                                 HasGotSalesUserSetup@7001100 :
                HasGotSalesUserSetup: Boolean;
                //                                                                 UserRespCenter@7001101 :
                UserRespCenter: Code[10];
            BEGIN
                IF NOT UserSetupManagement.CheckRespCenter(3, "Responsability Center") THEN BEGIN
                    FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, HasGotSalesUserSetup);
                END;
            END;


        }
        field(23; "Automatic Shipment"; Boolean)
        {
            CaptionML = ENU = 'Automatic Shipment', ESP = 'Albar�n de compra';
            Description = 'QB 1.08.32 Si viene de un albar�n de compra';
            Editable = false;


        }
        field(24; "Purchase Rcpt. No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header";
            CaptionML = ENU = 'Purchase Shipment No.', ESP = 'No. albar�n compra';
            Editable = false;


        }
        field(25; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimesnion Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(27; "User ID"; Code[50])
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
                LoginMgt.LookupUserID("User ID");
            END;


        }
        field(28; "Source Code"; Code[10])
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
        key(key2; "Sales Document No.", "Posting Date")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       InventorySetup@7001100 :
        InventorySetup: Record 313;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Text003@7001103 :
        Text003: TextConst ENU = 'You cann�t rename a %1', ESP = 'No se puede cambiar el nombre a %1';
        //       PostedOutputShipmentLines@7001118 :
        PostedOutputShipmentLines: Record 7207311;
        //       QBCommentLine@7001104 :
        QBCommentLine: Record 7207270;
        //       Text002@7001105 :
        Text002: TextConst ENU = 'To change the job, you must delete the outgoing delivery lines', ESP = 'Para cambiar el proyecto debe de eliminar las l�neas de albar�n de salida';
        //       Job@7001106 :
        Job: Record 167;
        //       OutputShipmentHeader@7001107 :
        OutputShipmentHeader: Record 7207308;
        //       UserSetupManagement@7001108 :
        UserSetupManagement: Codeunit 5700;
        //       Text027@7001109 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 to %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 a %2.';
        //       ResponsibilityCenter@7001110 :
        ResponsibilityCenter: Record 5714;
        //       Text001@7001111 :
        Text001: TextConst ENU = 'Output shipment: %1', ESP = 'Albar�n de salida: %1';
        //       CJob@7001112 :
        CJob: Code[20];
        //       OldDimSetID@7001113 :
        OldDimSetID: Integer;
        //       DimensionManagement@7001114 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       JobPostingGroup@7001115 :
        JobPostingGroup: Record 208;
        //       FunctionQB@7001116 :
        FunctionQB: Codeunit 7207272;
        //       Text051@7001117 :
        Text051: TextConst ENU = 'You may have changed a dimension.\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \ �Desea actualizar las l�neas?';



    trigger OnDelete();
    begin
        PostedOutputShipmentLines.LOCKTABLE;

        PostedOutputShipmentLines.SETRANGE("Document No.", "No.");
        PostedOutputShipmentLines.DELETEALL;

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;



    // procedure FilterResponsability (var ShipmentFilter@7001100 :
    procedure FilterResponsability(var ShipmentFilter: Record 7207310)
    var
        //       HasGotSalesUserSetup@7001101 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001102 :
        UserRespCenter: Code[10];
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);

        if UserRespCenter <> '' then begin
            ShipmentFilter.FILTERGROUP(2);
            ShipmentFilter.SETRANGE("Responsability Center", UserRespCenter);
            ShipmentFilter.FILTERGROUP(0);
        end;
    end;

    procedure ShowDimensions()
    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
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
    end.
  */
}








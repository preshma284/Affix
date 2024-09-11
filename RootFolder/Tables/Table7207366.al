table 7207366 "Usage Line Hist."
{


    CaptionML = ENU = 'Usage Line Hist.', ESP = 'Hist. Lineas utilizaci�n';
    DrillDownPageID = "Usage Line Hist. Subform.";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Contract Code', ESP = 'C�d. Contrato';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(4; "No."; Code[20])
        {
            TableRelation = "Rental Elements";
            CaptionML = ENU = 'No.', ESP = 'N�';
            Editable = false;


        }
        field(5; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';


        }
        field(6; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', ESP = 'Precio Unitario';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(7; "Delivery Document"; Code[20])
        {
            CaptionML = ENU = 'Delivery Document', ESP = 'Documento de entrega';
            Editable = false;


        }
        field(8; "Usage Days"; Decimal)
        {
            CaptionML = ENU = 'Usage Days', ESP = 'D�as de utilizaci�n';
            Editable = false;


        }
        field(9; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(10; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(11; "Return Document"; Code[20])
        {
            CaptionML = ENU = 'Return Document', ESP = 'Documento de devoluci�n';
            Editable = false;


        }
        field(12; "Initial Date Calculation"; Date)
        {
            CaptionML = ENU = 'Initial Date Calculation', ESP = 'Fecha c�lculo inicial';
            Editable = false;


        }
        field(13; "Return Date"; Date)
        {
            CaptionML = ENU = 'Return Date', ESP = 'Fecha devoluci�n';
            Editable = false;


        }
        field(14; "Application Date"; Date)
        {
            CaptionML = ENU = 'Application Date', ESP = 'Fecha liquidaci�n';
            Editable = false;


        }
        field(15; "Delivery Mov. No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            CaptionML = ENU = 'Delivery Mov. No.', ESP = 'N� mov. entrega';
            Editable = false;


        }
        field(16; "Return Mov. No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            CaptionML = ENU = 'Return Mov. No.', ESP = 'N� mov. devoluci�n';
            Editable = false;


        }
        field(17; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(20; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(21; "Line Type"; Option)
        {
            OptionMembers = "Refund","Balance on Job";
            CaptionML = ENU = 'Line Type', ESP = 'Tipo de L�nea';
            OptionCaptionML = ENU = 'Refund,Balance on Job', ESP = 'Devoluci�n,Saldo en obra';



        }
        field(22; "Invoiced Quantity"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Quantity', ESP = 'Cantidad facturada';
            Editable = false;


        }
        field(23; "Pending Quantity"; Decimal)
        {
            CaptionML = ENU = 'Pending Quantity', ESP = 'Cantidad pendiente';
            Editable = false;


        }
        field(24; "Customer/Vendor No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'N� Cliente/proveedor';
            Editable = false;


        }
        field(25; "Quantity to invoice"; Decimal)
        {
            CaptionML = ENU = 'Quantity to invoice', ESP = 'Cantidad a facturar';
            Editable = false;


        }
        field(26; "Variant Code"; Code[10])
        {
            CaptionML = ENU = 'Variant Code', ESP = 'C�d. Variante';


        }
        field(27; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo Contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(28; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';


        }
        field(29; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Editable = false;


        }
        field(30; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Job Task No.', ESP = 'N� tarea proyecto';
            NotBlank = true;

            trigger OnValidate();
            VAR
                //                                                                 Job@1000 :
                Job: Record 167;
                //                                                                 Cust@1001 :
                Cust: Record 18;
            BEGIN
            END;


        }
        field(31; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(32; "Invoiced Quantity (Calculated)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."Quantity" WHERE("QB Certification code" = FIELD("Document No."),
                                                                                                        "QB Certification Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Invoiced Quantity (Calculated)', ESP = 'Cantidad facturada (calculado)';


        }
        field(33; "Paid Quantity (Calculated)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Cr.Memo Line".Quantity WHERE("QB Certification code" = FIELD("Document No."),
                                                                                                        "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Paid Quantity (Calculated)', ESP = 'Cantidad Abonada (calculado)';
            ;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CUDimensionManagement@7001100 :
        CUDimensionManagement: Codeunit "DimensionManagement";
        //       Text000@7001102 :
        Text000: TextConst ENU = 'Shipment No. %1:', ESP = 'N� Dcoumento utilizaci�n %1:';
        //       Text001@7001101 :
        Text001: TextConst ENU = 'The program cannot find this Sales Line.', ESP = 'El prog. no puede encontrar esta L�n. Vta.';

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

    procedure ShowDimensions()
    begin
        TESTFIELD("No.");
        TESTFIELD("Line No.");
        CUDimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Usage Line Hist.", FieldNo);
        exit(Field."Field Caption");
    end;

    //     procedure InsertInvLineFromShptLine (var SalesLine@1000 : Record 37;LOUsageLineHist@1100251004 :
    procedure InsertInvLineFromShptLine(var SalesLine: Record 37; LOUsageLineHist: Record 7207366)
    var
        //       SalesHeader@1011 :
        SalesHeader: Record 36;
        //       SalesHeader2@1008 :
        SalesHeader2: Record 36;
        //       LOCSalesLine@1005 :
        LOCSalesLine: Record 37;
        //       Currency@1010 :
        Currency: Record 4;
        //       CUTransferOldExtTextLines@1007 :
        CUTransferOldExtTextLines: Codeunit 379;
        //       CUItemTrackingManagement@1009 :
        CUItemTrackingManagement: Codeunit "Item Tracking Management";
        //       NextLineNo@1001 :
        NextLineNo: Integer;
        //       RentalElements@1100251000 :
        RentalElements: Record 7207344;
        //       ElementContractLines@1100251001 :
        ElementContractLines: Record 7207354;
        //       LOCprice@1100251003 :
        LOCprice: Decimal;
        //       LOCUsageHeaderHist@1100251005 :
        LOCUsageHeaderHist: Record 7207365;
    begin
        LOCSalesLine := SalesLine;
        if SalesLine.FINDLAST then
            NextLineNo := SalesLine."Line No." + 10000
        else
            NextLineNo := 10000;
        /*To be Tested*/
        // WITH LOUsageLineHist DO begin
        LOCUsageHeaderHist.GET(LOUsageLineHist."Document No.");
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := LOCSalesLine."Document Type";
        SalesLine."Document No." := LOCSalesLine."Document No.";
        SalesLine.Type := SalesLine.Type::Resource;
        RentalElements.GET("No.");
        RentalElements.TESTFIELD(RentalElements."Invoicing Resource");
        SalesLine.VALIDATE(SalesLine."No.", RentalElements."Invoicing Resource");
        SalesLine.VALIDATE(Quantity, "Pending Quantity");
        LOCprice := LOUsageLineHist."Unit Price";
        SalesLine.VALIDATE("Unit Price", LOCprice);
        SalesLine."QB Usage Document" := LOUsageLineHist."Document No.";
        SalesLine."QB Usage Document Line" := LOUsageLineHist."Line No.";
        SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        SalesLine."Job No." := LOCUsageHeaderHist."Job No.";
        SalesLine."Dimension Set ID" := "Dimension Set ID";

        SalesLine.INSERT(TRUE);
        NextLineNo := NextLineNo + 10000;

        // end;
    end;

    //     procedure InsertInvLineFromShptLinePurch (var PurchaseLine@1000 : Record 39;UsageLineHist@1100251004 :
    procedure InsertInvLineFromShptLinePurch(var PurchaseLine: Record 39; UsageLineHist: Record 7207366)
    var
        //       PurchaseInvHeader@1011 :
        PurchaseInvHeader: Record 38;
        //       PurchaseOrderHeader@1008 :
        PurchaseOrderHeader: Record 38;
        //       PurchaseOrderLine@1005 :
        PurchaseOrderLine: Record 39;
        //       Currency@1010 :
        Currency: Record 4;
        //       TempPurchaseLine@1002 :
        TempPurchaseLine: Record 39 TEMPORARY;
        //       TransferOldExtLines@1007 :
        TransferOldExtLines: Codeunit 379;
        //       ItemTrackingMgt@1009 :
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        //       NextLineNo@1001 :
        NextLineNo: Integer;
        //       LOCRentalElements@1100251000 :
        LOCRentalElements: Record 7207344;
        //       LOCElementContractLines@1100251001 :
        LOCElementContractLines: Record 7207354;
        //       LOCprice2@1100251003 :
        LOCprice2: Decimal;
        //       LOCUsageHeaderHist@1100251005 :
        LOCUsageHeaderHist: Record 7207365;
    begin
        TempPurchaseLine := PurchaseLine;
        if PurchaseLine.FINDLAST then
            NextLineNo := PurchaseLine."Line No." + 10000
        else
            NextLineNo := 10000;
        /*To be Tested*/
        // WITH UsageLineHist DO begin
        LOCUsageHeaderHist.GET(UsageLineHist."Document No.");
        PurchaseLine."Line No." := NextLineNo;
        PurchaseLine.INSERT;

        PurchaseLine."Document Type" := TempPurchaseLine."Document Type";
        PurchaseLine."Document No." := TempPurchaseLine."Document No.";
        PurchaseLine.Type := PurchaseLine.Type::Resource;
        LOCRentalElements.GET("No.");
        LOCRentalElements.TESTFIELD(LOCRentalElements."Invoicing Resource");
        PurchaseLine.VALIDATE(PurchaseLine."No.", LOCRentalElements."Invoicing Resource");
        PurchaseLine.VALIDATE(Quantity, "Pending Quantity");
        LOCprice2 := UsageLineHist."Unit Price";
        PurchaseLine.VALIDATE("Direct Unit Cost", LOCprice2);

        PurchaseLine."Usage Document" := UsageLineHist."Document No.";
        PurchaseLine."Usage Document Line" := UsageLineHist."Line No.";
        PurchaseLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        PurchaseLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        PurchaseLine."Job No." := LOCUsageHeaderHist."Job No.";
        PurchaseLine."Dimension Set ID" := "Dimension Set ID";
        PurchaseLine.MODIFY(TRUE);

        NextLineNo := NextLineNo + 10000;
        // end;
    end;

    /*begin
    end.
  */
}








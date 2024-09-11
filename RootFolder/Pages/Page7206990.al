page 7206990 "QB Purchases Check"
{
  ApplicationArea=All;

    Permissions = TableData 25 = rm,
                TableData 38 = rim,
                TableData 122 = rm;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 38;
    PageType = List;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("QB Documentation Verified"; rec."QB Documentation Verified")
                {


                    ; trigger OnValidate()
                    BEGIN
                        IF (NOT Registrada) THEN BEGIN
                            //Factura sin registrar
                            PurchaseHeader.GET(rec."Document Type", rec."No.");
                            PurchaseHeader."QB Documentation Verified" := rec."QB Documentation Verified";
                            PurchaseHeader.MODIFY;
                        END ELSE BEGIN
                            //Factura registrada, cambiamos la factura
                            PurchInvHeader.GET(rec."No.");
                            PurchInvHeader."QB Documentation Verified" := rec."QB Documentation Verified";
                            PurchInvHeader.MODIFY;
                        END;
                    END;


                }
                field("On Hold"; rec."On Hold")
                {


                    ; trigger OnValidate()
                    BEGIN
                        IF (NOT Registrada) THEN BEGIN
                            //Factura sin registrar, solo se modifica la factura
                            PurchaseHeader.GET(rec."Document Type", rec."No.");
                            PurchaseHeader."On Hold" := rec."On Hold";
                            PurchaseHeader.MODIFY;
                        END ELSE BEGIN
                            //Factura registrada, cambiamos la factura
                            PurchInvHeader.GET(rec."No.");
                            PurchInvHeader."On Hold" := rec."On Hold";
                            PurchInvHeader.MODIFY;
                            //Y los movimientos de proveedor asociados
                            VendorLedgerEntry.RESET;
                            VendorLedgerEntry.SETCURRENTKEY("Document No.");
                            VendorLedgerEntry.SETRANGE("Document No.", PurchInvHeader."No.");
                            VendorLedgerEntry.SETRANGE("Vendor No.", PurchInvHeader."Buy-from Vendor No.");
                            VendorLedgerEntry.SETRANGE(Open, TRUE);
                            VendorLedgerEntry.SETFILTER("Document Situation", '%1|%2', VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera);
                            VendorLedgerEntry.MODIFYALL("On Hold", rec."On Hold");
                        END;
                    END;


                }
                field("txtCert"; "txtCert")
                {

                    CaptionML = ESP = 'Cert.Vencidos';
                }
                field("Registrada"; "Registrada")
                {

                    CaptionML = ESP = 'Registrada';
                    Editable = FALSE;
                }
                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the involved entry or record, according to the specified number series.', ESP = 'Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los art�culos.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Buy-from Vendor Name"; rec."Buy-from Vendor Name")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los art�culos.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                }
                field("Vendor Invoice No."; rec."Vendor Invoice No.")
                {

                    Editable = FALSE;
                }
                field("QB Job No."; rec."QB Job No.")
                {

                    Editable = FALSE;
                }
                field("QB Receipt Date"; rec."QB Receipt Date")
                {

                    ToolTipML = ESP = 'Especifica la fecha en que se recibi� el documento';
                    Editable = FALSE;
                }
                field("Document Date"; rec."Document Date")
                {

                    ToolTipML = ESP = 'Especifica la fecha del documento';
                    Editable = FALSE;
                }
                field("CalculatedAmount"; "CalculatedAmount")
                {

                    CaptionML = ESP = 'Importe';
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    ToolTipML = ENU = 'Specifies how to make payment, such as with bank transfer, cash, or check.', ESP = 'Especifica c�mo realizar el pago, por ejemplo transferencia bancaria, en efectivo o con cheque.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                    ToolTipML = ENU = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.', ESP = 'Especifica una f�rmula que calcula la fecha de vencimiento del pago, la fecha de descuento por pronto pago y el importe de descuento por pronto pago.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                }
                field("Due Date"; rec."Due Date")
                {

                    ToolTipML = ENU = 'Specifies when the invoice is due.', ESP = 'Especifica cu�ndo vence la factura.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                }
                field("Vendor Posting Group"; rec."Vendor Posting Group")
                {

                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("IncomingDocAttachFactBox"; 193)
            {

                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
            part("part2"; 9093)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No."), "Date Filter" = FIELD("Date Filter");
            }
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Win.OPEN(Txt000);

        //Cargar facturas sin registrar
        Win.UPDATE(1, Txt001);
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Invoice);
        IF PurchaseHeader.FINDSET(FALSE) THEN
            REPEAT
                Win.UPDATE(2, PurchaseHeader."No.");
                Rec.TRANSFERFIELDS(PurchaseHeader);
                Rec.INSERT;
            UNTIL (PurchaseHeader.NEXT = 0);

        //Cargar facturas registradas pendientes de pago que no est�n en una relaci�n
        Win.UPDATE(1, Txt002);
        PurchInvHeader.RESET;
        IF PurchInvHeader.FINDSET(FALSE) THEN
            REPEAT
                Win.UPDATE(2, PurchInvHeader."No.");
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETCURRENTKEY("Document No.");
                VendorLedgerEntry.SETRANGE("Document No.", PurchInvHeader."No.");
                VendorLedgerEntry.SETRANGE("Vendor No.", PurchInvHeader."Buy-from Vendor No.");
                VendorLedgerEntry.SETRANGE(Open, TRUE);
                VendorLedgerEntry.SETFILTER("Document Situation", '%1|%2', VendorLedgerEntry."Document Situation"::" ", VendorLedgerEntry."Document Situation"::Cartera);
                IF (VendorLedgerEntry.FINDFIRST) THEN BEGIN
                    //Si el movimiento est� marcado como esperar de forma diferente a la factura registrada, lo pasamos a la factura
                    IF (PurchInvHeader."On Hold" <> VendorLedgerEntry."On Hold") THEN BEGIN
                        PurchInvHeader."On Hold" := VendorLedgerEntry."On Hold";
                        PurchInvHeader.MODIFY;
                    END;

                    Rec.TRANSFERFIELDS(PurchInvHeader);
                    // Rec."Document Type" := 99;
                    Rec."Document Type" := Enum::"Purchase Document Type".FromInteger(99);
                    Rec.INSERT;
                END;
            UNTIL (PurchInvHeader.NEXT = 0);

        Win.CLOSE;

        Rec.FILTERGROUP(0);
        Rec.RESET;
        Rec.SETRANGE("QB Documentation Verified", FALSE);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Registrada := (rec."Document Type" = Enum::"Purchase Document Type".FromInteger(99));
        //Presentar los certificados vencidos
        QualityManagement.VendorCertificatesDued(rec."Buy-from Vendor No.", TODAY, txtCert);

        IF (NOT Registrada) THEN BEGIN
            Rec.CALCFIELDS("Amount Including VAT");
            CalculatedAmount := rec."Amount Including VAT";
        END ELSE BEGIN
            PurchInvHeader.GET(rec."No.");
            PurchInvHeader.CALCFIELDS("Amount Including VAT");
            CalculatedAmount := PurchInvHeader."Amount Including VAT";
        END;
    END;

    trigger OnAfterGetCurrRecord()
    VAR
        rPurchInvHeader: Record 122;
    BEGIN
        IF rPurchInvHeader.GET(rec."No.") THEN CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(rPurchInvHeader);
    END;



    var
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
        VendorLedgerEntry: Record 25;
        Win: Dialog;
        Registrada: Boolean;
        QualityManagement: Codeunit 7207293;
        txtCert: Text;
        Pending: Boolean;
        CalculatedAmount: Decimal;
        Txt000: TextConst ESP = 'Cargando #1############ #2#############';
        Txt001: TextConst ESP = 'Sin reg.';
        Txt002: TextConst ESP = 'Registradas';/*

    begin
    {
      AML 9/10/23 Error con documentos entrantes en p�gina Verificar documentos compra
    }
    end.*/


}










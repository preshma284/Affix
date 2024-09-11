page 7174336 "SII Document Card"
{
    InsertAllowed = false;
    ModifyAllowed = true;
    SourceTable = 7174333;
    PageType = Document;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("Document Type"; rec."Document Type")
                {

                    Editable = FALSE;
                }
                field("Document No."; rec."Document No.")
                {

                    Editable = FALSE;
                }
                field("External Reference"; rec."External Reference")
                {

                    Editable = FALSE;
                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                grid("group11")
                {

                    GridLayout = Rows;
                    group("group12")
                    {

                        CaptionML = ESP = 'Primer/�ltimo N� Ticket';
                        field("First Ticket No."; rec."First Ticket No.")
                        {

                            ShowCaption = false;
                        }
                        field("Last Ticket No."; rec."Last Ticket No.")
                        {

                            ShowCaption = false;
                        }

                    }

                }
                field("SII Entity"; rec."SII Entity")
                {

                    Editable = FALSE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    Editable = FALSE;
                    StyleExpr = StyleExprDate;

                    ; trigger OnValidate()
                    BEGIN
                        IF rec."Posting Date" <= TODAY THEN
                            StyleExprDate := 'Favorable'
                        ELSE
                            StyleExprDate := 'UnFavorable';
                    END;


                }
                field("Document Date"; rec."Document Date")
                {

                }
                field("Shipping Date"; rec."Shipping Date")
                {

                }
                grid("group19")
                {

                    GridLayout = Rows;
                    group("group20")
                    {

                        CaptionML = ESP = 'Periodo';
                        field("Year"; rec."Year")
                        {

                            Editable = FALSE;
                            StyleExpr = StyleExprYear;


                            ShowCaption = false;
                            trigger OnValidate()
                            BEGIN
                                IF rec.Year <= DATE2DMY(TODAY, 3) THEN BEGIN
                                    StyleExprYear := 'Favorable';

                                    IF (rec.Period <= FORMAT(DATE2DMY(TODAY, 2))) THEN
                                        StyleExprPeriod := 'Favorable'
                                    ELSE
                                        StyleExprPeriod := 'UnFavorable';
                                END ELSE BEGIN
                                    StyleExprYear := 'UnFavorable';
                                    StyleExprPeriod := 'UnFavorable';
                                END;
                            END;


                        }
                        field("Period Name"; rec."Period Name")
                        {

                            CaptionML = ENU = 'Period Name', ESP = 'Periodo';
                            Editable = FALSE;
                            StyleExpr = StyleExprPeriod;


                            ShowCaption = false;
                            trigger OnValidate()
                            BEGIN
                                IF rec.Year <= DATE2DMY(TODAY, 3) THEN BEGIN
                                    StyleExprYear := 'Favorable';

                                    IF (rec.Period <= FORMAT(DATE2DMY(TODAY, 2))) THEN
                                        StyleExprPeriod := 'Favorable'
                                    ELSE
                                        StyleExprPeriod := 'UnFavorable';
                                END ELSE BEGIN
                                    StyleExprYear := 'UnFavorable';
                                    StyleExprPeriod := 'UnFavorable';
                                END;
                            END;


                        }

                    }

                }
                field("Modified"; rec."Modified")
                {

                    Editable = FALSE;
                }
                field("AEAT Status"; rec."AEAT Status")
                {

                    Editable = FALSE;
                }
                field("Shipment Status"; rec."Shipment Status")
                {

                }

            }
            group("group26")
            {

                CaptionML = ENU = 'Customer/Vendor', ESP = 'Cliente/Proveedor';
                Editable = FALSE;
                grid("group27")
                {

                    GridLayout = Rows;
                    group("group28")
                    {

                        CaptionML = ESP = 'Cliente/Proveedor';
                        field("Cust/Vendor No."; rec."Cust/Vendor No.")
                        {

                            ShowCaption = false;
                        }
                        field("Cust/Vendor Name"; rec."Cust/Vendor Name")
                        {

                            ShowCaption = false;
                        }

                    }

                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {

                }
                field("GetCountry"; Rec.GetCountry)
                {

                    CaptionML = ENU = 'Country/Region code', ESP = 'C�digo de Pais/Regi�n';
                }

            }
            group("group33")
            {

                CaptionML = ENU = 'Invoices', ESP = 'Facturas';
                grid("group34")
                {

                    GridLayout = Rows;
                    group("group35")
                    {

                        CaptionML = ESP = 'Tipo de Factura';
                        field("Invoice Type"; rec."Invoice Type")
                        {

                            ShowCaption = false;
                        }
                        field("Invoice Type Name"; rec."Invoice Type Name")
                        {

                            CaptionML = ENU = 'Invoice Type Name', ESP = 'Tipo Factura';
                            Editable = FALSE;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group38")
                {

                    GridLayout = Rows;
                    group("group39")
                    {

                        CaptionML = ESP = 'Tipo de Rectificativa';
                        field("CrMemo Type"; rec."CrMemo Type")
                        {

                            ShowCaption = false;
                        }
                        field("Cr.Memo Type Name"; rec."Cr.Memo Type Name")
                        {

                            Editable = FALSE;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group42")
                {

                    GridLayout = Rows;
                    group("group43")
                    {

                        CaptionML = ESP = 'R�gimen Especial';
                        field("Special Regime"; rec."Special Regime")
                        {

                            ShowCaption = false;
                        }
                        field("Special Regime Name"; rec."Special Regime Name")
                        {

                            Editable = FALSE;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group46")
                {

                    GridLayout = Rows;
                    group("group47")
                    {

                        CaptionML = ESP = 'R�gimen Especial 1';
                        field("Special Regime 1"; rec."Special Regime 1")
                        {

                            ShowCaption = false;
                        }
                        field("Special Regime 1 Name"; rec."Special Regime 1 Name")
                        {

                            Editable = FALSE;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group50")
                {

                    GridLayout = Rows;
                    group("group51")
                    {

                        CaptionML = ESP = 'R�gimen Especial 2';
                        field("Special Regime 2"; rec."Special Regime 2")
                        {

                            ShowCaption = false;
                        }
                        field("Special Regime 2 Name"; rec."Special Regime 2 Name")
                        {

                            Editable = FALSE;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group54")
                {

                    GridLayout = Rows;
                    group("group55")
                    {

                        CaptionML = ESP = 'Emitida por Tercero';
                        field("Third Party"; rec."Third Party")
                        {

                            ShowCaption = false;
                        }
                        field("Third Party Name"; rec."Third Party Name")
                        {

                            CaptionML = ENU = 'Emitida Tercero';
                            Editable = FALSE;
                            ShowCaption = false;
                        }

                    }

                }
                field("Declarate Key UE"; rec."Declarate Key UE")
                {

                }
                field("UE Country"; rec."UE Country")
                {

                }
                field("Description Operation 1"; rec."Description Operation 1")
                {

                }
                field("Description Operation 2"; rec."Description Operation 2")
                {

                }
                field("Description Operation 1 + ' '+ Description Operation 2"; rec."Description Operation 1" + ' ' + rec."Description Operation 2")
                {

                    CaptionML = ENU = 'Description Operaci�n', ESP = 'Descripci�n Operaci�n';
                    Editable = FALSE;
                }
                field("Bienes Description"; rec."Bienes Description")
                {

                }
                field("Operator Address"; rec."Operator Address")
                {

                }
                field("VAT Amount"; rec."VAT Amount")
                {

                    Editable = FALSE;
                }
                field("RE Amount"; rec."RE Amount")
                {

                    Editable = FALSE;
                }
                field("Invoice Amount"; rec."Invoice Amount")
                {

                    Editable = FALSE;
                }

            }
            group("group68")
            {

                CaptionML = ESP = 'Contraste';
                Editable = FALSE;
                field("Tally Status"; rec."Tally Status")
                {

                }
                field("Base Imbalance"; rec."Base Imbalance")
                {

                }
                field("ISP Base Imbalance"; rec."ISP Base Imbalance")
                {

                }
                field("Imbalance Fee"; rec."Imbalance Fee")
                {

                }
                field("Imbalance RE Fee"; rec."Imbalance RE Fee")
                {

                }
                field("Imbalance Amount"; rec."Imbalance Amount")
                {

                }

            }
            group("Payments")
            {

                CaptionML = ENU = 'Payments', ESP = 'Pagos';
                field("Medio Cobro/Pago"; rec."Medio Cobro/Pago")
                {

                }
                field("CuentaMedioCobro"; rec."CuentaMedioCobro")
                {

                }

            }
            group("group78")
            {

                CaptionML = ESP = 'Bienes de Inversi�n';
                field("FA ID"; rec."FA ID")
                {

                }
                field("Start Date of use"; rec."Start Date of use")
                {

                }
                field("Prorrata Anual definitiva"; rec."Prorrata Anual definitiva")
                {

                    Editable = FALSE;
                }

            }
            part("part1"; 7174334)
            {
                SubPageLink = "Document No." = FIELD("Document No."), "Document Type" = FIELD("Document Type"), "VAT Registration No." = FIELD("VAT Registration No."), "Entry No." = FIELD("Entry No."), "Register Type" = FIELD("Register Type");
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7174338)
            {
                SubPageLink = "Document No." = FIELD("Document No."), "Document Type" = FIELD("Document Type"), "Entry No." = FIELD("Entry No.");
            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = 'Answers Log', ESP = 'Hist�rico de respuestas';
                RunObject = Page 7174338;
                RunPageLink = "Document No." = FIELD("Document No."), "Document Type" = FIELD("Document Type"), "Entry No." = FIELD("Entry No.");
                Image = ErrorLog;
            }
            action("Ver Cliente/Proveedor")
            {

                CaptionML = ENU = 'Customer/Vendor Card', ESP = 'Ficha Cliente/Proveedor';
                Image = EditCustomer;


                trigger OnAction()
                VAR
                    Customer: Record 18;
                    Vendor: Record 23;
                    VendorCard: Page 26;
                    CustomerCard: Page 21;
                BEGIN
                    IF Rec."Document Type" IN [Rec."Document Type"::CE, Rec."Document Type"::CM,
                                           Rec."Document Type"::BI, Rec."Document Type"::OI,
                                           Rec."Document Type"::FE]
                    THEN BEGIN
                        Customer.RESET;
                        IF Customer.GET(Rec."Cust/Vendor No.") THEN BEGIN
                            CustomerCard.SETRECORD(Customer);
                            CustomerCard.LOOKUPMODE := TRUE;
                            IF CustomerCard.RUNMODAL IN [ACTION::LookupOK, ACTION::OK, ACTION::Yes] THEN BEGIN
                                Rec."Cust/Vendor Name" := Customer.Name;
                                Rec."VAT Registration No." := Customer."VAT Registration No.";
                                Rec.MODIFY;
                            END;
                        END;
                    END ELSE BEGIN
                        Vendor.RESET;
                        IF Vendor.GET(Rec."Cust/Vendor No.") THEN BEGIN
                            VendorCard.SETRECORD(Vendor);
                            VendorCard.LOOKUPMODE := TRUE;
                            IF VendorCard.RUNMODAL IN [ACTION::LookupOK, ACTION::OK, ACTION::Yes] THEN BEGIN
                                Rec."Cust/Vendor Name" := Vendor.Name;
                                Rec."VAT Registration No." := Vendor."VAT Registration No.";
                                Rec.MODIFY;
                            END;
                        END;
                    END;

                    CurrPage.UPDATE;
                END;


            }

        }
        area(Promoted)
        {
        }
    }
    trigger OnModifyRecord(): Boolean
    BEGIN
        //+QuoSII_1.4.99.999
        IF rec.Modified = FALSE THEN
            Rec.VALIDATE(Modified, TRUE);
        //-QuoSII_1.4.99.999
    END;



    var
        ValidCIF: Boolean;
        StyleExprCIF: Text;
        SIIManagement: Codeunit 7174331;
        CustVendNameValidate: Text;
        Text001: TextConst ESP = 'El CIF/NIF y la Raz�n no se corresponden con los datos de la AEAT. La raz�n para este CIF/NIF es %1.';
        Text002: TextConst ESP = 'Ir al Cliente/Proveedor';
        StyleExprDate: Text;
        StyleExprPeriod: Text;
        StyleExprYear: Text;/*

    begin
    {
      QuoSII1_1.4.0.011 25/06/18 MCM - Se modifica las propiedades SubPageLink de la SubPage y de la acci�n Page SII Error a Document No.=FIELD(Document No.),Document Type=FIELD(Document Type),Entry No.=FIELD(Entry No.)
      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
      QuoSII_1.4.99.999 28/06/19 QMD - Se a�ade campo para controlar que se ha editado desde la p�gina
                                       Se modifica propiedad ModifyAllowed a Yes
                                       Se pone como no editables campos ...name y se a�aden los campos de valores de estos
      JAV 23/08/21: - QuoSII 1.5z Se hacen editables los campos First y Last Ticket. TODO: si se cambian se debe ajustar el movimiento de cliente asociado
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
    }
    end.*/


}









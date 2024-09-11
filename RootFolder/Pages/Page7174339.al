page 7174339 "SII Documents Lines"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7174333;
    PageType = List;
    CardPageID = "SII Document Card";
    ShowFilter = false;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Document Type"; rec."Document Type")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Register Type"; rec."Register Type")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Year"; rec."Year")
                {

                }
                field("Period Name"; rec."Period Name")
                {

                }
                field("Invoice Amount"; rec."Invoice Amount")
                {

                }
                field("Cust/Vendor Name"; rec."Cust/Vendor Name")
                {

                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {

                }
                field("GetCountry"; Rec.GetCountry)
                {

                    CaptionML = ENU = 'Country/Region code', ESP = 'C�digo de Pais/Regi�n';
                }
                field("Cust/Vendor No."; rec."Cust/Vendor No.")
                {

                }
                field("Invoice Type Name"; rec."Invoice Type Name")
                {

                }
                field("Special Regime Name"; rec."Special Regime Name")
                {

                }
                field("Description Operation 1 + ' '+ Description Operation 1"; rec."Description Operation 1" + ' ' + rec."Description Operation 1")
                {

                    CaptionML = ENU = 'Description Operaci�n';
                    MultiLine = true;
                }
                field("Third Party Name"; rec."Third Party Name")
                {

                }
                field("Document Date"; rec."Document Date")
                {

                }
                field("Cr.Memo Type Name"; rec."Cr.Memo Type Name")
                {

                }
                field("Shipment Status"; rec."Shipment Status")
                {

                }
                field("AEAT Status"; rec."AEAT Status")
                {

                }
                field("SII Entity"; rec."SII Entity")
                {

                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        //PSM 25/02/2021 +
        SIIDocumentShipment.GET("Ship No.");
        IF SIIDocumentShipment."Shipment Type" IN ['A1', 'B0'] THEN
            Rec.SETRANGE("Shipment Status", rec."Shipment Status"::Enviado)
        ELSE
            //PSM 25/02/2021 -
            Rec.SETRANGE("Shipment Status", rec."Shipment Status"::" ");
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    VAR
        SIIDocumentShipmentLine: Record 7174336;
        SIIDocuments: Record 7174333;
        SIIDocumentShipment: Record 7174335;
        SIIDocuments2: Record 7174333;
    BEGIN
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK, ACTION::Yes] THEN BEGIN
            CurrPage.SETSELECTIONFILTER(SIIDocuments);
            IF SIIDocuments.FINDSET THEN
                REPEAT
                    IF SIIDocuments."Document No." <> '' THEN BEGIN
                        SIIDocumentShipmentLine.RESET;
                        SIIDocumentShipmentLine.INIT;
                        SIIDocumentShipmentLine."Document No." := SIIDocuments."Document No.";
                        SIIDocumentShipmentLine."Ship No." := "Ship No.";
                        SIIDocumentShipmentLine."Document Type" := SIIDocuments."Document Type";
                        SIIDocumentShipmentLine."VAT Registration No." := SIIDocuments."VAT Registration No.";
                        SIIDocumentShipmentLine.Status := SIIDocumentShipmentLine.Status::Pendiente;
                        SIIDocumentShipmentLine."Posting Date" := SIIDocuments."Posting Date";
                        SIIDocumentShipmentLine."AEAT Status" := SIIDocuments."AEAT Status";//QuoSII1.4
                        SIIDocumentShipmentLine."Entry No." := SIIDocuments."Entry No.";
                        SIIDocumentShipmentLine."Register Type" := SIIDocuments."Register Type";    // JAV Nuevo campo de clave
                        SIIDocumentShipmentLine.VALIDATE("SII Entity");//QuoSII_1.4.2.042
                        IF SIIDocumentShipmentLine.INSERT(TRUE) THEN BEGIN
                            SIIDocuments2.RESET;
                            SIIDocuments2.SETRANGE("Document Type", SIIDocuments."Document Type");
                            SIIDocuments2.SETRANGE("Document No.", SIIDocuments."Document No.");
                            SIIDocuments2.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
                            SIIDocuments2.SETRANGE("Entry No.", SIIDocuments."Entry No.");    // JAV Nuevo campo de clave
                            SIIDocuments2.SETRANGE("Register Type", SIIDocuments."Register Type");    // JAV Nuevo campo de clave
                            IF SIIDocuments2.FINDFIRST THEN BEGIN
                                //SIIDocuments2."AEAT Status" := '';//QuoSII1.4
                                //SIIDocuments2."Shipment Status" := SIIDocuments.rec."Shipment Status"::Pendiente;//QuoSII1.4
                                SIIDocuments2."Is Emited" := TRUE;
                                SIIDocuments2.MODIFY(TRUE);
                            END;
                        END;
                    END;
                UNTIL SIIDocuments.NEXT = 0;
        END;
    END;



    var
        "Ship No.": Code[20];
        SIIDocumentShipment: Record 7174335;

    procedure SetShipNo(ShipNo: Code[20]);
    begin
        "Ship No." := ShipNo;
    end;

    // begin
    /*{
      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
      PSM 25/02/2021 En env�os de tipo A1 y B0 mostrar documentos enviados, en el resto de tipos los no enviados
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a rec."Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
    }*///end
}









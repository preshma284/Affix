report 7174335 "SII Send Ship Job Queue"
{


    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {

        DataItem("SII Documents"; "SII Documents")
        {

            DataItemTableView = SORTING("Document Type", "Document No.", "VAT Registration No.", "Posting Date", "Entry No.", "Register Type")
                                 ORDER(Ascending)
                                 WHERE("Document Type" = FILTER(<> 'NO'));

            ;
            trigger OnPreDataItem();
            BEGIN
                "SII Documents".SETFILTER("Posting Date", '<=%1', WORKDATE);
                "SII Documents".SETFILTER("SII Entity", '<>%1', '');      //JAV 31/05/21: - No incluir si no tienen entidad para evitar errores
            END;

            trigger OnAfterGetRecord();
            VAR
                //                                   SIIDocumentShipment@7174331 :
                SIIDocumentShipment: Record 7174335;
            BEGIN
                //JAV 31/05/21: - Si es un documento de modificaci¢n de la certificaci¢n ser  un tipo A1
                IF ("SII Documents"."Register Type" = 'C-14') AND ("SII Documents"."AEAT Status" = '') THEN BEGIN
                    IF CheckShipment("SII Documents", SIIDocumentShipment, 'A1') THEN
                        InsertLine("SII Documents", SIIDocumentShipment)
                    ELSE BEGIN
                        IF CreateShipmentHeader("SII Documents", SIIDocumentShipment, 'A1') THEN
                            InsertLine("SII Documents", SIIDocumentShipment);
                    END;
                END ELSE BEGIN
                    //JAV 31/05/21: - Si no esta emitida la tengo que incluir en un env¡o de tipo A0
                    IF ("SII Documents"."Is Emited" = FALSE) THEN BEGIN
                        IF CheckShipment("SII Documents", SIIDocumentShipment, 'A0') THEN
                            InsertLine("SII Documents", SIIDocumentShipment)
                        ELSE BEGIN
                            IF CreateShipmentHeader("SII Documents", SIIDocumentShipment, 'A0') THEN
                                InsertLine("SII Documents", SIIDocumentShipment);
                        END;
                    END;
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                IF ErrorInsert THEN
                    //QuoSII.b9.begin 
                    IF (CompanyInformation."QuoSII Email From" <> '') AND (CompanyInformation."QuoSII Email To" <> '') THEN
                        SIIManagement.SendMail('Quosii', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '',
                                               'Error Env¡os SII',
                                               GETLASTERRORTEXT() + 'Revise la lista de env¡os de la empresa ' + COMPANYNAME + '.');
                //QuoSII.b9.end
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       SIIManagement@1100286011 :
        SIIManagement: Codeunit 7174331;
        //       ErrorInsert@1100286012 :
        ErrorInsert: Boolean;
        //       BodyInsert@1100286013 :
        BodyInsert: Text;
        //       CompanyInformation@7174331 :
        CompanyInformation: Record 79;



    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        ErrorInsert := FALSE;
        BodyInsert := '';
        //QuoSII.B9.begin
        if (not CompanyInformation."QuoSII Certificate".HASVALUE) or (not CompanyInformation."QuoSII Certificate Password".HASVALUE) then begin
            SIIManagement.SendMail('QuoSII', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '', 'Error Env¡os SII ' + FORMAT(TODAY),
        'No se ha configurado un certificado v lido o una contrase¤a. No se realizar¢n los env¡os.'
                                  + '.Revise la configuraci¢n de la empresa ' + COMPANYNAME + '.');
            CurrReport.QUIT;
        end;
        //QuoSII.B9.end
    end;

    trigger OnPostReport();
    var
        //                    SIIDocumentShipment@7174331 :
        SIIDocumentShipment: Record 7174335;
    begin
        COMMIT;
        SIIDocumentShipment.RESET;
        SIIDocumentShipment.SETFILTER("AEAT Status", '<>%1', 'CORRECTO');
        if SIIDocumentShipment.FINDSET then
            repeat
                //Primer par metro  -> N§ env¡o
                //Segundo par metro -> 0: '' - 1:'Client' - 2: 'Server'
                //Tercer par metro  -> 0: REAL - 1: PRUEBAS                  JAV 06/05/21: - QuoSII 1.5j se usa un nuevo par metro informado en la configuraci¢n del QuoSII, por defecto REAL
                SIIManagement.ProcessShipment(SIIDocumentShipment."Ship No.", 2, CompanyInformation."QuoSII Send Queue Type");
                COMMIT;
            until SIIDocumentShipment.NEXT = 0;

        if SIIDocumentShipment.FINDFIRST then
            SIIManagement.SendMail('Quosii', CompanyInformation."QuoSII Email From",
                                   CompanyInformation."QuoSII Email To", '',
                                   'Error Env¡os SII ' + FORMAT(TODAY), 'Existen errores env¡o. Revise la lista de env¡os.'
                                    + 'Revise la lista de env¡os de la empresa ' + COMPANYNAME + '.');

        BodyInsert := '';
        ErrorInsert := FALSE;
    end;



    // LOCAL procedure InsertLine (SIIDocuments@7174331 : Record 7174333;SIIShipment@7174332 :
    LOCAL procedure InsertLine(SIIDocuments: Record 7174333; SIIShipment: Record 7174335)
    var
        //       SIIDocumentShipmentLine@7174333 :
        SIIDocumentShipmentLine: Record 7174336;
        //       SIIDocuments2@7174334 :
        SIIDocuments2: Record 7174333;
    begin
        SIIDocumentShipmentLine.RESET;
        SIIDocumentShipmentLine.INIT;
        SIIDocumentShipmentLine."Ship No." := SIIShipment."Ship No.";
        SIIDocumentShipmentLine."Document No." := SIIDocuments."Document No.";
        SIIDocumentShipmentLine."Document Type" := SIIDocuments."Document Type";
        SIIDocumentShipmentLine."VAT Registration No." := SIIDocuments."VAT Registration No.";
        SIIDocumentShipmentLine."Posting Date" := SIIDocuments."Posting Date";
        SIIDocumentShipmentLine."Entry No." := SIIDocuments."Entry No.";
        SIIDocumentShipmentLine."Register Type" := SIIDocuments."Register Type";    //JAV 30/05
        SIIDocumentShipmentLine.VALIDATE("SII Entity", "SII Documents"."SII Entity");//QuoSII_1.4.02.042
        if not SIIDocumentShipmentLine.INSERT(TRUE) then begin
            BodyInsert += 'Crear documento: ' + "SII Documents"."Document No." + ', ';
            ErrorInsert := TRUE;
        end else begin
            //QuoSII_1.4.0.014.begin
            SIIDocuments2.RESET;
            SIIDocuments2.GET(SIIDocuments."Document Type", SIIDocuments."Document No.", SIIDocuments."VAT Registration No.", SIIDocuments."Posting Date", SIIDocuments."Entry No.",
                              SIIDocuments."Register Type");     //JAV 30/05
            SIIDocuments2."AEAT Status" := '';
            SIIDocuments2."Shipment Status" := SIIDocuments2."Shipment Status"::Pendiente;
            SIIDocuments2."Is Emited" := TRUE;
            SIIDocuments2.MODIFY;
            //QuoSII_1.4.0.014.begin
        end;

        //JAV 11/05/22: - QuoSII 1.06.07 Si es tipo C-14 la l¡nea debe tener estado = Pendiente y Estado AEAT = CORRECTO
        if (SIIDocuments."Register Type" = 'C-14') then begin
            SIIDocumentShipmentLine.Status := SIIDocumentShipmentLine.Status::Pendiente;
            SIIDocumentShipmentLine."AEAT Status" := 'CORRECTO';
            SIIDocumentShipmentLine.MODIFY;
        end;
    end;

    //     LOCAL procedure CheckShipment (SIIDocuments@7174331 : Record 7174333;var SIIDocumentShipment@7174332 : Record 7174335;ShipmentType@1000000000 :
    LOCAL procedure CheckShipment(SIIDocuments: Record 7174333; var SIIDocumentShipment: Record 7174335; ShipmentType: Code[20]): Boolean;
    begin
        SIIDocumentShipment.RESET;
        SIIDocumentShipment.SETRANGE("Shipment DateTime", CREATEDATETIME(WORKDATE, 000000T), CREATEDATETIME(WORKDATE, 235959T));
        SIIDocumentShipment.SETRANGE("Shipment Type", ShipmentType);

        //JAV 11/05/22: - QuoSII 1.06.07 Para documentos de tipo C-14 el tipo de la cabecera debe ser factura emitida
        if (SIIDocuments."Register Type" = 'C-14') then
            SIIDocumentShipment.SETRANGE("Document Type", SIIDocumentShipment."Document Type"::FE)
        else
            SIIDocumentShipment.SETRANGE("Document Type", SIIDocuments."Document Type");
        SIIDocumentShipment.SETRANGE("SII Entity", "SII Documents"."SII Entity");//QuoSII_1.4.02.042
        SIIDocumentShipment.SETRANGE("Shipment Status", SIIDocumentShipment."Shipment Status"::Pendiente);  //JAV 31/05/21 no pueden estar enviadas
        exit(SIIDocumentShipment.FINDFIRST);
    end;

    //     LOCAL procedure CreateShipmentHeader (SIIDocuments@7174332 : Record 7174333;var SIIDocumentShipment@7174331 : Record 7174335;ShipmentType@1000000000 :
    LOCAL procedure CreateShipmentHeader(SIIDocuments: Record 7174333; var SIIDocumentShipment: Record 7174335; ShipmentType: Code[20]): Boolean;
    begin
        SIIDocumentShipment.RESET;
        SIIDocumentShipment.INIT;
        SIIDocumentShipment."Ship No." := '';
        SIIDocumentShipment.VALIDATE("SII Entity", "SII Documents"."SII Entity");//QuoSII_1.4.02.042
        SIIDocumentShipment.VALIDATE("Shipment Type", ShipmentType);
        //JAV 11/05/22: - QuoSII 1.06.07 Para documentos de tipo C-14 el tipo de la cabecera debe ser factura emitida
        if (SIIDocuments."Register Type" = 'C-14') then
            SIIDocumentShipment.VALIDATE("Document Type", SIIDocumentShipment."Document Type"::FE)
        else
            SIIDocumentShipment.VALIDATE("Document Type", SIIDocuments."Document Type");
        SIIDocumentShipment."Tipo Entorno" := CompanyInformation."QuoSII Send Queue Type";  //JAV 31/05/21 Tomamos el entorno de la configuraci¢n
        if not SIIDocumentShipment.INSERT(TRUE) then begin
            BodyInsert += 'Crear env¡o: ' + FORMAT(SIIDocuments."Document Type");
            ErrorInsert := TRUE;
            exit(FALSE);
        end else
            COMMIT;
        exit(TRUE);
    end;

    /*begin
    //{
//      //QuoSII_02_04
//      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
//      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as¡ no entra en confusi¢n con campos denominados Type
//      JAV 11/05/22: - QuoSII 1.06.07 Si el documento es de tipo C-14 creamos la cabecera con como factura emitida, y en las l¡neas estado = Pendiente y Estado AEAT = CORRECTO
//
//    }
    end.
  */

}




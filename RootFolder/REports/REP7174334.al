report 7174334 "SII Document Job Queue"
{


    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {

    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("DocumentType"; "DocumentType")
                {

                    CaptionML = ENU = 'Document Type', ESP = 'Tipo Documento';

                    ; trigger OnValidate()
                    BEGIN
                        IF DocumentType IN [DocumentType::"Cobros de Facturas Emitidas", DocumentType::"Cobros Metalico",
                                            DocumentType::"Facturas Emitidas", DocumentType::"Facturas Bienes de Inversi¢n",
                                            DocumentType::"Facturas de Operaciones intracomunitarias"]
                        THEN BEGIN
                            CustomerEditable := TRUE;
                            VendorEditable := FALSE;
                        END ELSE BEGIN
                            CustomerEditable := FALSE;
                            VendorEditable := TRUE;
                        END;
                    END;


                }
                field("FromDate"; "FromDate")
                {

                    CaptionML = ENU = 'From Date', ESP = 'Desde fecha';
                }
                field("ToDate"; "ToDate")
                {

                    CaptionML = ENU = 'To Date', ESP = 'Hasta Fecha';
                }
                field("CustomerNo."; "CustomerNo.")
                {

                    CaptionML = ENU = 'Customer Filter', ESP = 'Filtro Cliente';
                    TableRelation = Customer."No.";
                }
                field("VendorNo."; "VendorNo.")
                {

                    CaptionML = ENU = 'Vendor Filter', ESP = 'Filtro Proveedor';
                    TableRelation = Vendor."No.";
                }
                field("OTSDate"; "OTSDate")
                {

                    CaptionML = ESP = 'Fecha Tracto Sucesivo';
                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            VendorEditable := FALSE;
            CustomerEditable := FALSE;

            IF DocumentType IN [DocumentType::"Cobros de Facturas Emitidas", DocumentType::"Cobros Metalico",
                                DocumentType::"Facturas Emitidas", DocumentType::"Facturas Bienes de Inversi¢n",
                                DocumentType::"Facturas de Operaciones intracomunitarias"]
            THEN BEGIN
                CustomerEditable := TRUE;
                VendorEditable := FALSE;
            END ELSE BEGIN
                CustomerEditable := FALSE;
                VendorEditable := TRUE;
            END;
        END;


    }
    labels
    {
    }

    var
        //       CompanyInformation@1100286006 :
        CompanyInformation: Record 79;
        //       SIIDocuments@1100286001 :
        SIIDocuments: Record 7174333;
        //       SIIManagement@1100286005 :
        SIIManagement: Codeunit 7174331;
        //       SIIDocumentProcesing@1100286004 :
        SIIDocumentProcesing: Codeunit 7174333;
        //       DocumentType@1100286022 :
        DocumentType: Option " ","Facturas Emitidas","Facturas Recibidas","Operaciones de seguros","Cobros Metalico","Facturas Bienes de Inversi¢n","Facturas de Operaciones intracomunitarias","Cobros de Facturas Emitidas","Pagos de Facturas Recibidas";
        //       FromDate@1100286020 :
        FromDate: Date;
        //       ToDate@1100286019 :
        ToDate: Date;
        //       OTSDate@1100286002 :
        OTSDate: Date;
        //       "CustomerNo."@1100286018 :
        "CustomerNo.": Code[10];
        //       "VendorNo."@1100286017 :
        "VendorNo.": Code[10];
        //       OperationType@1100286016 :
        OperationType: Option " ","Alta","Modificaci¢n","Baja";
        //       VendorEditable@7174332 :
        VendorEditable: Boolean;
        //       CustomerEditable@7174331 :
        CustomerEditable: Boolean;
        //       errorInsert@1100286000 :
        errorInsert: Boolean;



    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        //QuoSII.B9.begin
        errorInsert := FALSE;
        //QuoSII.B9.end
    end;

    trigger OnPreReport();
    begin
        //JAV 01/06/21: - Se respeta el par metro de la page
        if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Facturas Emitidas") then
            errorInsert := SIIDocumentProcesing.CreateDocumentCustomer(SIIDocuments."Document Type"::FE, OperationType::Alta, "CustomerNo.", FALSE, FromDate, ToDate, 0D);

        if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Cobros de Facturas Emitidas") then
            errorInsert := SIIDocumentProcesing.CreateDocumentCustomer(SIIDocuments."Document Type"::CE, OperationType::Alta, "CustomerNo.", FALSE, FromDate, ToDate, 0D);

        if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Facturas de Operaciones intracomunitarias") then begin
            errorInsert := SIIDocumentProcesing.CreateDocumentCustomer(SIIDocuments."Document Type"::OI, OperationType::Alta, "CustomerNo.", FALSE, FromDate, ToDate, 0D);
            errorInsert := SIIDocumentProcesing.CreateDocumentVendor(SIIDocuments."Document Type"::OI, OperationType::Alta, "VendorNo.", FALSE, FromDate, ToDate);
        end;

        if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Facturas Recibidas") then
            errorInsert := SIIDocumentProcesing.CreateDocumentVendor(SIIDocuments."Document Type"::FR, OperationType::Alta, "VendorNo.", FALSE, FromDate, ToDate);

        if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Pagos de Facturas Recibidas") then
            errorInsert := SIIDocumentProcesing.CreateDocumentVendor(SIIDocuments."Document Type"::PR, OperationType::Alta, "VendorNo.", FALSE, FromDate, ToDate);

        //JAV 23/06/21: - QuoSII 1.5s Si no se han informado las fechas no puedo lanzar algunos procesos, como debe ser por la cola me los salto
        if (FromDate <> 0D) and (ToDate <> 0D) then begin
            if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Cobros Metalico") then
                SIIDocumentProcesing.CreateDocumentCobroMetalico(SIIDocuments."Document Type"::CM, FromDate, ToDate);

            if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Facturas Bienes de Inversi¢n") then
                SIIDocumentProcesing.CreateDocumentBI(SIIDocuments."Document Type"::BI, FromDate, ToDate);

            //Este tipo no se trata actualmente porque no hay proceso para hacerlo
            if (DocumentType = DocumentType::" ") or (DocumentType = DocumentType::"Operaciones de seguros") then begin
            end;

        end;
    end;

    trigger OnPostReport();
    begin
        //QuoSII.B9.begin
        if errorInsert then
            if (CompanyInformation."QuoSII Email From" <> '') and (CompanyInformation."QuoSII Email To" <> '') then
                SIIManagement.SendMail('Quosii', CompanyInformation."QuoSII Email From", CompanyInformation."QuoSII Email To", '',
                'Error al generar documentos SII' + COMPANYNAME + '.', 'Algunos documentos SII no se han podido generar para su env¡o.');
        //QuoSII.B9.end
    end;



    /*begin
        {
          //-QUO PEL
          QuoSII_1.3.02.005 171108 MCM - Se limpian los datos de la variable SIIDocuments
          QuoSII.1.3.02.001 171109 PGM - Si la fecha de registro se encuentra entre el 1 y el 15 se comprueba
                                         la configuracion de la empresa.
          QuoSII_1.3.02.006 171110 MCM - Se comenta el c¢digo porque no es correcto.
                                         Se modifica el c¢digo para que asigne el n§ de documento SII a las l¡neas.
          QuoSII1.4.03 09/03/2018 PEL
          QuoSII_1.4.0.017 MCM 04/07/18 - Se modifica la referencia externa.
          QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
          QuoSII_1.4.02.042.15 19/02/19 MCM - Se incluye la compatibilidad con retenciones de ventas.
          QuoSII_1.4.02.042.16 19/02/19 MCM - Se corrige el valor de la cuota deducible en facturas con criterio de caja.
          QuoSII_1.3.03.006 26/06/19 QMD - Se incluye la opci¢n de incluir como Fecha de Registro contable la fecha real de contabilizaci¢n

          2101 AJS 29042021 QFS-OC-21001. Tratamiento de IVA no realizado
          PSM 20/05/21: - Igualar comportamiento al del report 714332 SII Import Document
          ****************************************************************************************************************************************
          JAV 26/05/21: - QuoSII 1.5p Se traslada el c¢digo a una CU para no repetir c¢digo, por tanto los comentarios anteriores ya no sirven
          JAV 01/06/21: - Se respeta el par metro de la page
          JAV 23/06/21: - QuoSII 1.5s Si no se han informado las fechas no puedo lanzar algunos procesos, como debe ser por la cola me los salto
        }
        end.
      */

}




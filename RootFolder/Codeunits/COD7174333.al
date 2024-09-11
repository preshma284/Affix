Codeunit 7174333 "SII Document Procesing"
{


    Permissions = TableData 112 = rm,
                TableData 114 = rm,
                TableData 122 = rm,
                TableData 124 = rm,
                TableData 254 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        gOperationType: Option " ","Alta","Modificaci¢n","Baja";
        gDocumentType: Option " ","Facturas Emitidas","Facturas Recibidas","Operaciones de seguros","Cobros Metalico","Facturas Bienes de Inversi¢n","Facturas de Operaciones intracomunitarias","Cobros de Facturas Emitidas","Pagos de Facturas Recibidas";
        FirstDate: Date;
        WDFirst: Date;
        TDFirst: Date;
        RECC: TextConst ESP = '07';
        COAP: TextConst ESP = '14';
        COAP_F: TextConst ESP = 'F+01';
        COAP_P: TextConst ESP = 'C+14';
        COAP_M: TextConst ESP = 'C-14';
        OTS: TextConst ESP = '15';
        OTS_F: TextConst ESP = 'F+01';
        OTS_P: TextConst ESP = 'T+15';
        OTS_M: TextConst ESP = 'T-15';

    PROCEDURE CreateDocumentCustomer(DocType: Option; OpType: Option; CustomerNo: Code[20]; SIIExported: Boolean; FromDate: Date; ToDate: Date; OTSDate: Date): Boolean;
    VAR
        CustLedgerEntry: Record 21;
        CustLedgerEntry_Origin: Record 21;
        CustPostingGroup: Record 92;
        Customer: Record 18;
        SIIDocumentInvoice: Record 7174333;
        MovNo: Integer;
        SIIDocuments: Record 7174333;
        errorInsert: Boolean;
        VATEntry: Record 254;
        MovNo2: Integer;
        SIIDocumentNew: Record 7174333;
        SIIDocumentLine: Record 7174334;
        SIIDocumentLineNew: Record 7174334;
        TypeListValue: Record 7174331;
    BEGIN
        //Incluir los documentos de Clientes

        //WITH CustLedgerEntry DO BEGIN  JAV 19/08/21: - Se elimina el WITH que no se debe usar en extensiones
        IF (OpType = gOperationType::Baja) OR (OpType = gOperationType::"Modificaci¢n") THEN
            CustLedgerEntry.SETRANGE("QuoSII Exported", TRUE)
        ELSE
            CustLedgerEntry.SETRANGE("QuoSII Exported", FALSE);

        //QuoSII1.4.0.begin
        IF OpType = gOperationType::" " THEN BEGIN
            IF SIIExported THEN
                CustLedgerEntry.SETRANGE("QuoSII Exported", TRUE)
            ELSE
                CustLedgerEntry.SETRANGE("QuoSII Exported", FALSE);
        END;
        //QuoSII1.4.0.end

        IF (CustomerNo) <> '' THEN
            CustLedgerEntry.SETRANGE("Customer No.", CustomerNo);

        //JAV 15/04/21: - QuoSII 1.5f FirstDate y FirstDateAuto indican la minima fecha en la que subir. Se simplifica el codigo al m�ximo
        AdjustDates(FromDate, ToDate);
        IF (ToDate <> 0D) THEN
            CustLedgerEntry.SETRANGE("Posting Date", FirstDate, ToDate)
        ELSE IF (FromDate <> 0D) THEN
            CustLedgerEntry.SETFILTER("Posting Date", '%1..', FirstDate)
        ELSE
            CustLedgerEntry.SETRANGE("Posting Date", WDFirst, WORKDATE);
        //JAV fin

        IF DocType IN [gDocumentType::"Facturas Emitidas", gDocumentType::"Facturas de Operaciones intracomunitarias"] THEN BEGIN
            CustLedgerEntry.SETFILTER("Document Type", '%1|%2', CustLedgerEntry."Document Type"::"Credit Memo", CustLedgerEntry."Document Type"::Invoice);
            IF DocType = gDocumentType::"Facturas de Operaciones intracomunitarias" THEN BEGIN
                CustPostingGroup.RESET;
                CustPostingGroup.SETRANGE("QuoSII Type", CustPostingGroup."QuoSII Type"::OI);
                IF CustPostingGroup.FINDSET THEN
                    REPEAT
                        CustLedgerEntry.SETRANGE("Customer Posting Group", CustPostingGroup.Code);
                        IF CustLedgerEntry.FINDSET THEN
                            REPEAT
                                IF NOT CreateCustHeader(CustLedgerEntry, DocType, SIIDocuments) THEN
                                    errorInsert := errorInsert AND CreateCustLines(CustLedgerEntry, DocType, SIIDocuments)
                                ELSE
                                    errorInsert := TRUE;
                            UNTIL CustLedgerEntry.NEXT = 0;
                    UNTIL CustPostingGroup.NEXT = 0;
            END ELSE BEGIN
                CustPostingGroup.RESET;
                CustPostingGroup.SETRANGE("QuoSII Type", CustPostingGroup."QuoSII Type"::LF);
                IF CustPostingGroup.FINDSET THEN
                    REPEAT
                        CustLedgerEntry.SETRANGE("Customer Posting Group", CustPostingGroup.Code);
                        IF CustLedgerEntry.FINDSET THEN
                            REPEAT
                                IF NOT CreateCustHeader(CustLedgerEntry, DocType, SIIDocuments) THEN
                                    errorInsert := errorInsert AND CreateCustLines(CustLedgerEntry, DocType, SIIDocuments)
                                ELSE
                                    errorInsert := TRUE;
                            UNTIL CustLedgerEntry.NEXT = 0;
                    UNTIL CustPostingGroup.NEXT = 0;
            END;
        END ELSE BEGIN
            CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
            //QUOSII 02_01 ---->
            CustLedgerEntry.SETRANGE(CustLedgerEntry."QuoSII Sales Special Regimen", RECC);//QuoSII_1.4.02.042 RECC Criterio de caja  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                                                                                           //QUOSII 02_01 <----
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    CreateSalesPayment(CustLedgerEntry, DocType);
                UNTIL CustLedgerEntry.NEXT = 0;
            //+2101 <
            CustLedgerEntry.SETRANGE("QuoSII Sales Special Regimen", COAP);  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    CreateUnrealizedSalesPayment(CustLedgerEntry, DocType);
                UNTIL CustLedgerEntry.NEXT = 0;
            //+2101 >
            //JAV 11/05/21: - QuoSII 1.5k En las de tipo el pago sin r�gimen especial buscamos la factura original a ver si es del tipo 14
            //JAV 09/05/22: - QuoSII 1.06.07 Se contemplan los pagos con Criterio de Caja
            CustLedgerEntry.SETFILTER("QuoSII Sales Special Regimen", '=%1', '');
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    MovNo := FindApplnEntriesDtldtCustLedgEntry(CustLedgerEntry);  //JAV 09/05/22: - QuoSII 1.06.07 Se contemplan los pagos con Criterio de Caja
                    IF (MovNo <> 0) THEN BEGIN
                        CustLedgerEntry_Origin.GET(MovNo);
                        Customer.GET(CustLedgerEntry_Origin."Customer No.");

                        //. Buscamos el documento SII de la factura
                        SIIDocumentInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type"::FE);
                        SIIDocumentInvoice.SETRANGE("Document No.", CustLedgerEntry_Origin."Document No.");
                        SIIDocumentInvoice.SETRANGE("VAT Registration No.", Customer."VAT Registration No.");
                        SIIDocumentInvoice.SETRANGE("Posting Date", CustLedgerEntry_Origin."Posting Date");
                        //SIIDocumentInvoice.SETRANGE("Entry No.", CustLedgerEntry_Origin."Entry No.");
                        IF SIIDocumentInvoice.FINDFIRST THEN BEGIN
                            CustLedgerEntry_Origin.GET(SIIDocumentInvoice."Entry No.");
                            //JAV 09/05/22: - QuoSII 1.06.07 Se contemplan los pagos con Criterio de Caja
                            CASE CustLedgerEntry_Origin."QuoSII Sales Special Regimen" OF
                                //JAV 09/05/22: - QuoSII 1.06.07 Pago de un documento con Criterio de Caja
                                RECC:
                                    CreateSalesPayment(CustLedgerEntry, DocType);
                                //Pago de una certificaci�n
                                COAP:
                                    ProcessUnrealizedPayment(CustLedgerEntry."Posting Date", CustLedgerEntry."Entry No.", CustLedgerEntry."QuoSII Entity",
                                                             CustLedgerEntry_Origin, SIIDocumentInvoice, CustLedgerEntry_Origin."Amount (LCY)", DocType);
                            END;
                        END;
                    END;
                UNTIL CustLedgerEntry.NEXT = 0;
            //+2101 >
            //Q13664 -
            VATEntry.RESET;
            VATEntry.SETRANGE("QuoSII Exported", FALSE);
            VATEntry.SETRANGE("QuoSII Cancel Unrealized VAT", TRUE);
            IF VATEntry.FINDSET(TRUE) THEN
                REPEAT
                    CustLedgerEntry_Origin.RESET;
                    CustLedgerEntry_Origin.SETCURRENTKEY("Entry No.");
                    CustLedgerEntry_Origin.SETRANGE("Document No.", VATEntry."Document No.");
                    CustLedgerEntry_Origin.SETFILTER("Document Type", '%1|%2', CustLedgerEntry_Origin."Document Type"::Invoice,
                                                                                CustLedgerEntry_Origin."Document Type"::Bill);
                    IF CustLedgerEntry_Origin.FINDLAST THEN BEGIN //Busco el �ltimo para encontrar el efecto o la factura, lo �ltimo generado
                                                                  //. Buscamos el documento SII de la factura
                        SIIDocumentInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type"::FE);
                        SIIDocumentInvoice.SETRANGE("Document No.", CustLedgerEntry_Origin."Document No.");
                        SIIDocumentInvoice.SETRANGE("VAT Registration No.", VATEntry."VAT Registration No.");
                        SIIDocumentInvoice.SETRANGE("Posting Date", CustLedgerEntry_Origin."Posting Date");
                        IF SIIDocumentInvoice.FINDFIRST THEN BEGIN
                            ProcessUnrealizedPayment(VATEntry."Posting Date", CustLedgerEntry_Origin."Entry No.", CustLedgerEntry_Origin."QuoSII Entity",
                                                      CustLedgerEntry_Origin, SIIDocumentInvoice, CustLedgerEntry_Origin."Amount (LCY)", DocType);
                            VATEntry."QuoSII Exported" := TRUE;
                            VATEntry.MODIFY;
                        END;
                    END;
                UNTIL VATEntry.NEXT = 0;
            //Q13664 +
        END;
        //END;   JAV 19/08/21: - Se elimina el WITH que no se debe usar en extensiones

        //JAV 08/09/22: - QB 1.06.12 Operaciones de Tracto Sucesivo. Alta de la factura Real y baja de la ficticia
        SIIDocuments.RESET;
        SIIDocuments.SETRANGE("Register Type", OTS_P);
        SIIDocuments.SETRANGE("OTS Processed", FALSE);
        IF (SIIDocuments.FINDSET(TRUE)) THEN
            REPEAT
                IF (SIIDocuments."Due Date" <= OTSDate) THEN BEGIN
                    //Crear el documento de la factura a subir
                    SIIDocumentNew.TRANSFERFIELDS(SIIDocuments);
                    SIIDocumentNew."Document Type" := SIIDocumentNew."Document Type"::FE;
                    SIIDocumentNew.Year := DATE2DMY(SIIDocuments."Due Date", 3);
                    SIIDocumentNew.Period := FORMAT(DATE2DMY(SIIDocuments."Due Date", 2));
                    SIIDocumentNew."Period Name" := GetTypeValueDescription(TypeListValue.Type::Period, SIIDocumentNew.Period);
                    SIIDocumentNew."Posting Date" := SIIDocuments."Due Date";
                    SIIDocumentNew."Document Date" := SIIDocuments."Due Date";
                    SIIDocumentNew."Shipping Date" := SIIDocuments."Posting Date";
                    SIIDocumentNew.VALIDATE("Special Regime", '01');
                    SIIDocumentNew.Modified := FALSE;
                    SIIDocumentNew."Is Emited" := FALSE;
                    SIIDocumentNew.Status := SIIDocumentNew.Status::" ";
                    SIIDocumentNew."AEAT Status" := '';
                    SIIDocumentNew."Invoice Amount" := SIIDocuments."Invoice Amount";
                    SIIDocumentNew."Register Type" := OTS_F;                                          //Creamos la factura real
                    SIIDocumentNew."OTS Type" := SIIDocumentNew."OTS Type"::Creation;
                    //JAV 30/06/21 Si ya existe el registro F+01 nos saltamos su creaci�n de nuevo.
                    IF NOT SIIDocumentNew.INSERT THEN
                        EXIT;

                    //. Buscamos los SII Document Line originales para crear los SII Document line del pago
                    SIIDocumentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
                    SIIDocumentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
                    SIIDocumentLine.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
                    SIIDocumentLine.SETRANGE("Entry No.", SIIDocuments."Entry No.");
                    SIIDocumentLine.SETRANGE("Register Type", SIIDocuments."Register Type");
                    IF SIIDocumentLine.FINDSET() THEN BEGIN
                        REPEAT
                            SIIDocumentLineNew.TRANSFERFIELDS(SIIDocumentLine);
                            SIIDocumentLineNew."Document Type" := SIIDocumentNew."Document Type";
                            SIIDocumentLineNew."Entry No." := SIIDocumentNew."Entry No.";
                            SIIDocumentLineNew."Register Type" := SIIDocumentNew."Register Type";
                            SIIDocumentLineNew.INSERT;
                        UNTIL SIIDocumentLine.NEXT = 0;
                    END;

                    //. Actualizamos el importe de la factura tras crear las l�neas para que no se altere
                    SIIDocumentNew."Invoice Amount" := SIIDocuments."Invoice Amount";
                    SIIDocumentNew.MODIFY;

                    //La que cancela la anterior 15
                    SIIDocumentNew.TRANSFERFIELDS(SIIDocuments);
                    SIIDocumentNew."Posting Date" := SIIDocuments."Due Date";               //En la fecha del vencimiento
                    SIIDocumentNew."Shipping Date" := SIIDocuments."Due Date";               //La fecha de operaci�n es la del vencimiento
                    SIIDocumentNew.Status := SIIDocumentNew.Status::Modificada;     //Marcamos el documento del tipo 15 nuevo como modificado
                    SIIDocumentNew."Invoice Amount" := 0;
                    SIIDocumentNew."Is Emited" := FALSE;
                    SIIDocumentNew."AEAT Status" := '';
                    SIIDocumentNew."Register Type" := OTS_M;
                    SIIDocumentNew."OTS Type" := SIIDocumentNew."OTS Type"::Cancelation;
                    SIIDocumentNew.INSERT;

                    //. Buscamos los SII Document Line originales para crear los SII Document line del pago
                    SIIDocumentLine.SETRANGE("Document Type", SIIDocuments."Document Type");
                    SIIDocumentLine.SETRANGE("Document No.", SIIDocuments."Document No.");
                    SIIDocumentLine.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
                    SIIDocumentLine.SETRANGE("Entry No.", SIIDocuments."Entry No.");
                    SIIDocumentLine.SETRANGE("Register Type", SIIDocuments."Register Type");
                    IF SIIDocumentLine.FINDSET() THEN BEGIN
                        REPEAT
                            SIIDocumentLineNew.TRANSFERFIELDS(SIIDocumentLine);
                            SIIDocumentLineNew."Document Type" := SIIDocumentNew."Document Type";
                            SIIDocumentLineNew."Entry No." := SIIDocumentNew."Entry No.";
                            SIIDocumentLineNew."VAT Base" := 0; //- VATEntry."Remaining Unrealized Base";          JAV 30/06/21 No puede tener cobros parciales por la forma de hacerlo
                            SIIDocumentLineNew."VAT Amount" := 0; //- VATEntry."Remaining Unrealized Amount";
                            SIIDocumentLineNew."Entry No." := SIIDocumentNew."Entry No.";
                            SIIDocumentLineNew."Register Type" := SIIDocumentNew."Register Type";
                            SIIDocumentLineNew.INSERT;
                        UNTIL SIIDocumentLine.NEXT = 0;
                    END;

                    //. Actualizamos el importe de la factura tras crear las l�neas para que no se altere
                    SIIDocumentNew."Invoice Amount" := 0;
                    SIIDocumentNew.MODIFY;

                    SIIDocuments."OTS Processed" := TRUE;
                    SIIDocuments.MODIFY;
                END;
            UNTIL (SIIDocuments.NEXT = 0);

        EXIT(errorInsert);
    END;

    PROCEDURE CreateDocumentVendor(DocType: Option; OpType: Option; VendorNo: Code[20]; SIIExported: Boolean; FromDate: Date; ToDate: Date): Boolean;
    VAR
        VendorPostingGroup: Record 93;
        VendorLedgerEntry: Record 25;
        QuoSIISetup: Record 79;
        SIIDocuments: Record 7174333;
        errorInsert: Boolean;
        MovNo: Integer;
        VendorLedgerEntry_Origin: Record 25;
        Vendor: Record 23;
        SIIDocumentInvoice: Record 7174333;
    BEGIN
        //Incluir los documentos de Proveedores

        //WITH VendorLedgerEntry DO BEGIN   JAV 19/08/21: - Se elimina el WITH que no se debe usar en extensiones
        IF (OpType = gOperationType::Baja) OR (OpType = gOperationType::"Modificaci¢n") THEN
            VendorLedgerEntry.SETRANGE("QuoSII Exported", TRUE)
        ELSE
            VendorLedgerEntry.SETRANGE("QuoSII Exported", FALSE);

        //QuoSII1.4.0.begin
        IF OpType = gOperationType::" " THEN BEGIN
            IF SIIExported THEN
                VendorLedgerEntry.SETRANGE("QuoSII Exported", TRUE)
            ELSE
                VendorLedgerEntry.SETRANGE("QuoSII Exported", FALSE);
        END;
        //QuoSII1.4.0.end

        IF VendorNo <> '' THEN
            VendorLedgerEntry.SETRANGE("Vendor No.", VendorNo);

        //JAV 15/04/21: - QuoSII 1.5f FirstDate y FirstDateAuto indican la minima fecha en la que subir. Se simplifica el c�digo al m�ximo
        //QuoSII_1.3.03.006.begin
        AdjustDates(FromDate, ToDate);
        QuoSIISetup.GET;
        IF QuoSIISetup."QuoSII Use Auto Date" THEN BEGIN
            IF (ToDate <> 0D) THEN
                VendorLedgerEntry.SETRANGE("QuoSII Auto Posting Date", FirstDate, ToDate)
            ELSE IF (FromDate <> 0D) THEN
                VendorLedgerEntry.SETFILTER("QuoSII Auto Posting Date", '%1..', FirstDate)
            ELSE
                VendorLedgerEntry.SETRANGE("QuoSII Auto Posting Date", TDFirst, TODAY);
        END ELSE BEGIN
            //QuoSII_1.3.03.006.end
            IF (ToDate <> 0D) THEN
                VendorLedgerEntry.SETRANGE("Posting Date", FirstDate, ToDate)
            ELSE IF (FromDate <> 0D) THEN
                VendorLedgerEntry.SETFILTER("Posting Date", '%1..', FirstDate)
            ELSE
                VendorLedgerEntry.SETRANGE("Posting Date", WDFirst, WORKDATE);
        END; //QuoSII_1.3.03.006
             //JAV fin

        IF DocType IN [gDocumentType::"Facturas Recibidas", gDocumentType::"Facturas de Operaciones intracomunitarias"] THEN BEGIN
            VendorLedgerEntry.SETFILTER("Document Type", '%1|%2', VendorLedgerEntry."Document Type"::"Credit Memo", VendorLedgerEntry."Document Type"::Invoice);
            IF DocType = gDocumentType::"Facturas de Operaciones intracomunitarias" THEN BEGIN
                VendorPostingGroup.RESET;
                VendorPostingGroup.SETRANGE("QuoSII Type", VendorPostingGroup."QuoSII Type"::OI);
                IF VendorPostingGroup.FINDSET THEN
                    REPEAT
                        VendorLedgerEntry.SETRANGE("Vendor Posting Group", VendorPostingGroup.Code);
                        IF VendorLedgerEntry.FINDSET THEN
                            REPEAT
                                IF NOT CreateVendHeader(VendorLedgerEntry, DocType, SIIDocuments) THEN
                                    errorInsert := errorInsert AND CreateVendLines(VendorLedgerEntry, DocType, SIIDocuments)
                                ELSE
                                    errorInsert := TRUE;
                            UNTIL VendorLedgerEntry.NEXT = 0;
                    UNTIL VendorPostingGroup.NEXT = 0;
            END ELSE BEGIN
                VendorPostingGroup.RESET;
                VendorPostingGroup.SETRANGE("QuoSII Type", VendorPostingGroup."QuoSII Type"::LF);
                IF VendorPostingGroup.FINDSET THEN
                    REPEAT
                        VendorLedgerEntry.SETRANGE("Vendor Posting Group", VendorPostingGroup.Code);
                        IF VendorLedgerEntry.FINDSET THEN
                            REPEAT
                                IF NOT CreateVendHeader(VendorLedgerEntry, DocType, SIIDocuments) THEN
                                    errorInsert := errorInsert AND CreateVendLines(VendorLedgerEntry, DocType, SIIDocuments)
                                ELSE
                                    errorInsert := TRUE;
                            UNTIL VendorLedgerEntry.NEXT = 0;
                    UNTIL VendorPostingGroup.NEXT = 0;
            END;
        END ELSE BEGIN
            VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Payment);
            //QUOSII 02_01 ---->
            VendorLedgerEntry.SETRANGE(VendorLedgerEntry."QuoSII Purch. Special Reg.", RECC);//QuoSII_1.4.02.042 RECC Criterio de caja  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                                                                                             //QUOSII 02_01 <----
            IF VendorLedgerEntry.FINDSET THEN
                REPEAT
                    CreatePurchPayment(VendorLedgerEntry, DocType);
                UNTIL VendorLedgerEntry.NEXT = 0;

            //JAV 11/05/21: - QuoSII 1.5k En las de tipo pago sin r�gimen especial buscamos la factura original a ver si es del tipo 07
            VendorLedgerEntry.SETFILTER("QuoSII Purch. Special Reg.", '=%1', '');
            IF VendorLedgerEntry.FINDSET THEN
                REPEAT
                    MovNo := FindApplnEntriesDtldtVendLedgEntry(VendorLedgerEntry);
                    IF (MovNo <> 0) THEN BEGIN
                        VendorLedgerEntry_Origin.GET(MovNo);
                        Vendor.GET(VendorLedgerEntry_Origin."Vendor No.");

                        //. Buscamos el documento SII de la factura
                        SIIDocumentInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type"::FR);
                        //JAV 11/05/22: - QuoSII 1.06.07 Buscaba mal por el nro del documento del proveedor, debe ser el externo no el interno
                        SIIDocumentInvoice.SETRANGE("Document No.", VendorLedgerEntry_Origin."External Document No."); // VendorLedgerEntry_Origin."Document No.");
                        SIIDocumentInvoice.SETRANGE("VAT Registration No.", Vendor."VAT Registration No.");
                        SIIDocumentInvoice.SETRANGE("Posting Date", VendorLedgerEntry_Origin."Posting Date");
                        //SIIDocumentInvoice.SETRANGE("Entry No.", VendorLedgerEntry_Origin."Entry No.");
                        IF SIIDocumentInvoice.FINDFIRST THEN BEGIN
                            VendorLedgerEntry_Origin.GET(SIIDocumentInvoice."Entry No.");
                            //++CreatePurchPayment(VendorLedgerEntry_Origin,DocType);
                            CreatePurchPayment(VendorLedgerEntry, DocType);
                        END;
                    END;
                UNTIL VendorLedgerEntry.NEXT = 0;
        END;
        //END;  JAV 19/08/21: - Se elimina el WITH que no se debe usar en extensiones

        EXIT(errorInsert);
    END;

    PROCEDURE CreateDocumentBI(DocType: Option; FromDate: Date; ToDate: Date);
    VAR
        FALedgerEntry: Record 5601;
        PurchInvHeader: Record 122;
    BEGIN
        //Incluir los documentos de bienes de inversi�n

        //QuoSII_03.Begin
        IF DocType = gDocumentType::"Facturas Bienes de Inversi¢n" THEN BEGIN
            IF (ToDate = 0D) OR (FromDate = 0D) THEN
                ERROR('Las fechas inicio y fin han de estar informadas para los tipos Bienes de inversion')
            ELSE BEGIN
                FALedgerEntry.RESET();
                FALedgerEntry.SETFILTER("Document Type", FORMAT(FALedgerEntry."Document Type"::Invoice));
                FALedgerEntry.SETFILTER("FA Posting Type", FORMAT(FALedgerEntry."FA Posting Type"::"Acquisition Cost"));
                FALedgerEntry.SETFILTER("FA Posting Category", '');
                FALedgerEntry.SETFILTER("Amount (LCY)", '>=%1', 3005, 6);
                FALedgerEntry.SETRANGE("Posting Date", FromDate, ToDate);

                IF FALedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        PurchInvHeader.RESET;
                        PurchInvHeader.SETFILTER("No.", FALedgerEntry."Document No.");
                        IF PurchInvHeader.FINDFIRST THEN BEGIN
                            CreateBIHeader(PurchInvHeader, FALedgerEntry);
                        END;
                    UNTIL FALedgerEntry.NEXT = 0;
                END;
            END;
        END;
        //QuoSII_03-End
    END;

    PROCEDURE CreateDocumentCobroMetalico(DocType: Option; FromDate: Date; ToDate: Date);
    VAR
        GLAccount: Record 15;
        GLEntry: Record 17;
        TMPGLEntry: Record 17 TEMPORARY;
        EntryNo: Integer;
    BEGIN
        //Incluir los documentos de los Cobros en met�lico

        //QUOSII.004.BEGIN
        IF (DocType = gDocumentType::"Cobros Metalico") THEN BEGIN
            EntryNo := 0;
            CLEAR(TMPGLEntry);
            IF (ToDate = 0D) OR (FromDate = 0D) THEN
                ERROR('Las fechas inicio y fin han de estar informadas para los tipos Cobros en Met�lico');

            GLAccount.RESET;
            GLAccount.SETRANGE("QuoSII Payment Cash", TRUE);
            IF GLAccount.FINDSET THEN
                REPEAT
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Customer);
                    GLEntry.SETRANGE("G/L Account No.", GLAccount."No.");
                    IF GLEntry.FINDSET THEN
                        REPEAT
                            TMPGLEntry.RESET;
                            TMPGLEntry.SETRANGE("Source No.", GLEntry."Source No.");
                            TMPGLEntry.SETRANGE("QiuoSII Entity", GLEntry."QiuoSII Entity");//QuoSII_1.4.02.042
                            IF TMPGLEntry.FINDFIRST THEN BEGIN
                                TMPGLEntry.Amount += GLEntry.Amount;
                                TMPGLEntry.MODIFY;
                            END ELSE BEGIN
                                EntryNo += 1;
                                TMPGLEntry."Entry No." := EntryNo;
                                TMPGLEntry."G/L Account No." := GLAccount."No.";
                                TMPGLEntry."Source No." := GLEntry."Source No.";
                                TMPGLEntry.Amount := GLEntry.Amount;
                                TMPGLEntry."QiuoSII Entity" := GLEntry."QiuoSII Entity";//QuoSII_1.4.02.042
                                TMPGLEntry.INSERT(TRUE);
                            END;
                        UNTIL GLEntry.NEXT = 0;
                UNTIL GLAccount.NEXT = 0;

            TMPGLEntry.RESET;
            IF TMPGLEntry.FINDSET THEN
                REPEAT
                    IF ABS(TMPGLEntry.Amount) > 6000 THEN
                        CreateCashPayment(TMPGLEntry, FromDate, ToDate);
                UNTIL TMPGLEntry.NEXT = 0;
        END;
        //QUOSII.004.END
    END;

    PROCEDURE CreateCustHeader(CustLedgerEntry: Record 21; DocType: Option; VAR SIIDocuments: Record 7174333): Boolean;
    VAR
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        SalesCrMemoHeader: Record 114;
        SalesCrMemoLine: Record 115;
        ShippingDate: Date;
        Customer: Record 18;
        TypeListValue: Record 7174331;
        SIIDocuments2: Record 7174333;
        isInserted: Boolean;
        SIIDocuments3: Record 7174333;
        QuoSIISetup: Record 79;
        SIIDocuments4: Record 7174333;
        NotSend: Boolean;
    BEGIN
        QuoSIISetup.GET;

        //JAV 13/05/21: - QuoSII 1.5k Si el documento tiene la marca de no subir, me lo salto
        NotSend := FALSE;
        IF (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice) THEN BEGIN
            IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                IF (SalesInvoiceHeader."Do not send to SII") THEN
                    NotSend := TRUE;
            END;
        END ELSE IF (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo") THEN BEGIN
            IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                IF (SalesCrMemoHeader."Do not send to SII") THEN
                    NotSend := TRUE;
            END
        END;

        //JAV 11/05/22: - QuoSII 1.06.07 Si es un movimiento de liquidaci�n de una retenci�n no debe subir al SII
        IF (CustLedgerEntry."Do not sent to SII") THEN
            NotSend := TRUE;

        IF (NotSend) THEN BEGIN
            //Q13694 - si ya existe en los documentos del QuoSII no hago nada
            SIIDocuments4.RESET;
            SIIDocuments4.SETRANGE("Document Type", SIIDocuments4."Document Type"::FE);
            SIIDocuments4.SETRANGE("External Reference", CustLedgerEntry."Document No.");
            SIIDocuments4.SETRANGE("Register Type", '');
            IF SIIDocuments4.FINDFIRST THEN
                EXIT;
            //Q13694 +
            DocType := SIIDocuments."Document Type"::NO;
        END;
        //JAV fin

        //QuoSII.2_5.begin
        CustLedgerEntry.CALCFIELDS("Amount (LCY)");
        //QuoSII.2_5.end
        Customer.RESET;
        IF Customer.GET(CustLedgerEntry."Customer No.") THEN;

        SIIDocuments.INIT;
        SIIDocuments."Cust/Vendor No." := CustLedgerEntry."Customer No.";
        SIIDocuments."Cust/Vendor Name" := Customer.Name;
        //SIIDocuments."Document No." := CustLedgerEntry."Document No."; //1901-
        SIIDocuments."Document No." := EliminarEspacios(CustLedgerEntry."Document No."); //1901+
        SIIDocuments."Document Type" := DocType;
        SIIDocuments.Year := DATE2DMY(CustLedgerEntry."Posting Date", 3);
        SIIDocuments.Period := FORMAT(DATE2DMY(CustLedgerEntry."Posting Date", 2));
        SIIDocuments."VAT Registration No." := Customer."VAT Registration No.";
        SIIDocuments."Last Ticket No." := CustLedgerEntry."QuoSII Last Ticket No.";
        SIIDocuments."SII Entity" := CustLedgerEntry."QuoSII Entity";//QuoSII_1.4.02.042
                                                                     //QuoSII1.4.03.begin
        SIIDocuments.Status := SIIDocuments.Status::" ";
        //QuoSII1.4.03.end
        //QUOSII_T70.BEGIN
        SIIDocuments."First Ticket No." := CustLedgerEntry."QuoSII First Ticket No.";
        //QUOSII_T70.LAST
        SIIDocuments."Entry No." := CustLedgerEntry."Entry No.";
        SIIDocuments."Register Type" := '';

        SIIDocuments."External Reference" := CustLedgerEntry."Document No.";//QuoSII_1.4.0.017

        TypeListValue.RESET;
        TypeListValue.SETRANGE(Type, TypeListValue.Type::Period);
        TypeListValue.SETRANGE(Code, SIIDocuments.Period);
        IF TypeListValue.FINDFIRST THEN
            SIIDocuments."Period Name" := TypeListValue.Description;

        IF CustLedgerEntry."Document Type" IN [CustLedgerEntry."Document Type"::Invoice,
                                               CustLedgerEntry."Document Type"::"Credit Memo"] THEN BEGIN
            //PSM 25/02/2021 +
            SIIDocuments.VALIDATE("Special Regime", CustLedgerEntry."QuoSII Sales Special Regimen");//QuoSII_1.4.02.042
                                                                                                    //PSM 25/02/2021 -
                                                                                                    //QuoSII.3_0.begin
            ShippingDate := 0D;
            SIIDocuments."Posting Date" := CustLedgerEntry."Posting Date";
            SIIDocuments."Document Date" := CustLedgerEntry."Posting Date";
            SIIDocuments."Shipping Date" := CustLedgerEntry."Posting Date";
            IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice THEN
                IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                    //JAV 12/04/21 la fecha de operaci�n ahora est� en la cabecera
                    ShippingDate := SalesInvoiceHeader."QuoSII Operation Date";
                    //SalesInvoiceLine.SETRANGE("Document No.",CustLedgerEntry."Document No.");
                    //IF SalesInvoiceLine.FINDSET THEN
                    //  REPEAT
                    //    IF SalesInvoiceLine."Shipment Date" > ShippingDate THEN
                    //      ShippingDate := SalesInvoiceLine."Shipment Date";
                    //  UNTIL SalesInvoiceLine.NEXT = 0;
                END;
            //PSM 25/02/2021 +
            IF SIIDocuments."Special Regime" = COAP THEN BEGIN  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                ShippingDate := CustLedgerEntry."Due Date";
                SIIDocuments."Register Type" := COAP_P;                 //JAV 24/05/21  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian 'C+14', 'F+01' y 'C-14' por contantes COAP_P, COAP_F y COAP_M
                                                                        //PSM 25/02/2021-
            END ELSE BEGIN
                IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                    //PSM 20/05/21+
                    //ShippingDate := SalesCrMemoHeader."QuoSII Operation Date";
                    //SalesCrMemoLine.SETRANGE("Document No.",CustLedgerEntry."Document No.");
                    //IF SalesCrMemoLine.FINDSET THEN
                    //  REPEAT
                    //    IF SalesCrMemoLine."Shipment Date" > ShippingDate THEN
                    //      ShippingDate := SalesCrMemoLine."Shipment Date";
                    //  UNTIL SalesCrMemoLine.NEXT = 0;
                    //PSM 20/05/21-
                END;

                //PSM 25/02/2021 -
                IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice THEN BEGIN
                    IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                        //JAV 12/04/21 la fecha de operaci�n ahora est� en la cabecera
                        ShippingDate := SalesInvoiceHeader."QuoSII Operation Date";
                        //SalesInvoiceLine.SETRANGE("Document No.",CustLedgerEntry."Document No.");
                        //IF SalesInvoiceLine.FINDSET THEN
                        //  REPEAT
                        //    IF SalesInvoiceLine."Shipment Date" > ShippingDate THEN
                        //      ShippingDate := SalesInvoiceLine."Shipment Date";
                        //  UNTIL SalesInvoiceLine.NEXT = 0;
                    END;
                END ELSE BEGIN
                    IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                        //PSM 20/05/21+
                        //ShippingDate := SalesCrMemoHeader."QuoSII Operation Date";
                        //SalesCrMemoLine.SETRANGE("Document No.",CustLedgerEntry."Document No.");
                        //IF SalesCrMemoLine.FINDSET THEN
                        //  REPEAT
                        //    IF SalesCrMemoLine."Shipment Date" > ShippingDate THEN
                        //      ShippingDate := SalesCrMemoLine."Shipment Date";
                        //  UNTIL SalesCrMemoLine.NEXT = 0;
                        //PSM 20/05/2021-
                    END;
                END;
                //PSM 25/02/2021 +
            END;

            //JAV 08/09/22: - QB 1.06.12 Operaciones de Tracto Sucesivo. Alta de las facturas
            IF SIIDocuments."Special Regime" = OTS THEN BEGIN
                SIIDocuments."Shipping Date" := CustLedgerEntry."Due Date";
                SIIDocuments."Due Date" := CustLedgerEntry."Due Date";
                SIIDocuments."Register Type" := OTS_P;
            END;

            //+2101 <
            IF CustLedgerEntry."QuoSII Sales Special Regimen" = COAP THEN  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                ShippingDate := CustLedgerEntry."Due Date";
            //+2101 >
            IF SIIDocuments."Posting Date" <> ShippingDate THEN
                SIIDocuments."Shipping Date" := ShippingDate;
            /*{--- Comentamos esto por el anterior +2101 que lo debe haber resuelto
                    IF (SIIDocuments."Special Regime" = COAP) AND (ShippingDate < SIIDocuments."Posting Date") THEN           //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                      SIIDocuments."Shipping Date" := SIIDocuments."Posting Date" + 1
                    ELSE IF ((SIIDocuments."Special Regime" = COAP) AND (SIIDocuments."Posting Date" < ShippingDate)) OR      //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                            ((SIIDocuments."Special Regime" <> COAP) AND (SIIDocuments."Posting Date" > ShippingDate)) THEN   //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                    //IF SIIDocuments."Posting Date" <> ShippingDate THEN
                    //PSM 25/02/2021 -
                      SIIDocuments."Shipping Date" := ShippingDate;
                    ---}*/
            SIIDocuments.Year := DATE2DMY(SIIDocuments."Posting Date", 3);
            SIIDocuments.Period := FORMAT(DATE2DMY(SIIDocuments."Posting Date", 2));
            //QuoSII.3_0.end

            IF SIIDocuments."Document Type" <> SIIDocuments."Document Type"::OI THEN BEGIN
                //QuoSII.2_4.begin
                IF CustLedgerEntry."QuoSII Sales Corrected In.Type" <> '' THEN BEGIN //QuoSII_1.4.02.042
                                                                                     //QuoSII.2_4.end
                    SIIDocuments."CrMemo Type" := CustLedgerEntry."QuoSII Sales Cr.Memo Type";//QuoSII_1.4.02.042

                    TypeListValue.RESET;
                    TypeListValue.SETRANGE(Type, TypeListValue.Type::CorrectedInvType);
                    TypeListValue.SETRANGE(Code, SIIDocuments."CrMemo Type");
                    IF TypeListValue.FINDFIRST THEN
                        SIIDocuments."Cr.Memo Type Name" := TypeListValue.Description;

                    SIIDocuments."Invoice Type" := CustLedgerEntry."QuoSII Sales Corrected In.Type";//QuoSII_1.4.02.042
                END ELSE BEGIN
                    SIIDocuments."Invoice Type" := CustLedgerEntry."QuoSII Sales Invoice Type";//QuoSII_1.4.02.042
                    IF CustLedgerEntry."QuoSII Sales Invoice Type" = 'F4' THEN BEGIN //QuoSII_1.4.02.042
                        SIIDocuments."First Ticket No." := CustLedgerEntry."QuoSII First Ticket No.";     //PSM 18/08/21: - QsuoSII 1.5z Estaban intercambiados N.Doc y Primer Ticket
                        SIIDocuments."Document No." := EliminarEspacios(CustLedgerEntry."Document No.");  //PSM 18/08/21: - QsuoSII 1.5z Estaban intercambiados N.Doc y Primer Ticket
                                                                                                          //QuoSII.B9.begin
                        IF CustLedgerEntry."QuoSII First Ticket No." = '' THEN
                            //SIIDocuments."Document No." := CustLedgerEntry."Document No."; //1901-
                            SIIDocuments."Document No." := EliminarEspacios(CustLedgerEntry."Document No."); //1901+
                                                                                                             //QuoSII.B9.end
                    END;
                END;

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::SalesInvType);
                TypeListValue.SETRANGE(Code, SIIDocuments."Invoice Type");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Invoice Type Name" := TypeListValue.Description;
                SIIDocuments."Description Operation 1" := CustLedgerEntry.Description;
                SIIDocuments.VALIDATE("Special Regime", CustLedgerEntry."QuoSII Sales Special Regimen");//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialSalesInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime Name" := TypeListValue.Description;
                SIIDocuments."Special Regime 1" := CustLedgerEntry."QuoSII Sales Special Regimen 1";//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialSalesInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime 1");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime 1 Name" := TypeListValue.Description;
                SIIDocuments."Special Regime 2" := CustLedgerEntry."QuoSII Sales Special Regimen 2";//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialSalesInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime 2");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime 2 Name" := TypeListValue.Description;

                IF CustLedgerEntry."QuoSII Third Party" THEN
                    SIIDocuments."Third Party" := 'S'
                ELSE
                    SIIDocuments."Third Party" := 'N';
                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::ThirdParty);
                TypeListValue.SETRANGE(Code, SIIDocuments."Third Party");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Third Party Name" := TypeListValue.Description;

                //QuoSII.2_5.begin
                SIIDocuments."Invoice Amount" := CustLedgerEntry."Amount (LCY)";
                //QuoSII.2_5.end
            END ELSE BEGIN
                SIIDocuments."Declarate Key UE" := 'D';
                SIIDocuments."Invoice Type" := CustLedgerEntry."QuoSII Sales UE Inv Type";//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::IntraType);
                TypeListValue.SETRANGE(Code, SIIDocuments."Invoice Type");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Invoice Type Name" := TypeListValue.Description;

                SIIDocuments."UE Country" := CustLedgerEntry."QuoSII UE Country";
                SIIDocuments."Bienes Description" := CustLedgerEntry."QuoSII Bienes Description";
                SIIDocuments."Operator Address" := CustLedgerEntry."QuoSII Operator Address";
                //QuoSII_1.3.02.005.begin
                //SIIDocuments."Document Date" := 0D;
                //QuoSII_1.3.02.005.end
            END;
        END;

        //QuoSII1.4-2.begin
        IF QuoSIISetup."QuoSII Inclusion Date" <> 0D THEN
            IF SIIDocuments."Posting Date" < QuoSIISetup."QuoSII Inclusion Date" THEN BEGIN
                SIIDocuments."Description Operation 1" := 'Registro del Primer Semestre o anterior a la inclusi�n del SII';
                SIIDocuments.VALIDATE("Special Regime", '16');//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialSalesInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime Name" := TypeListValue.Description;

                SIIDocuments."Special Regime 1" := '';//QuoSII_1.4.02.042
                SIIDocuments."Special Regime 1 Name" := '';//QuoSII_1.4.02.042

                SIIDocuments."Special Regime 2" := '';//QuoSII_1.4.02.042
                SIIDocuments."Special Regime 2 Name" := '';//QuoSII_1.4.02.042
            END;
        //SIIDocuments.Emited := FALSE;  //JAV Ya no se usa esta variable

        IF (SIIDocuments."Invoice Amount" > 100000000) AND (NOT QuoSIISetup."QuoSII Ignore Messages") THEN BEGIN
            IF CONFIRM('Se est� incluyendo la factura con ID %1, cuyo importe rebasa los 100.000.000 �. �Desea incluirla?', FALSE, SIIDocuments."Document No.") THEN BEGIN
                //QuoSII1.4.0.begin
                isInserted := SIIDocuments.INSERT(TRUE);
                IF NOT isInserted THEN BEGIN
                    //Q13694 -
                    SIIDocuments4.RESET;
                    IF SIIDocuments4.GET(SIIDocuments."Document Type", SIIDocuments."Document No.", SIIDocuments."VAT Registration No.",
                                         SIIDocuments."Posting Date", SIIDocuments."Entry No.", SIIDocuments."Register Type") THEN BEGIN
                        SIIDocuments4.Modified := FALSE; //QuoSII_1.4.99.999
                        IF SIIDocuments4."AEAT Status" <> 'CORRECTO' THEN
                            isInserted := SIIDocuments4.MODIFY;
                    END;
                    //SIIDocuments.Modified := FALSE; //QuoSII_1.4.99.999
                    //  IF SIIDocuments."AEAT Status" <> 'CORRECTO' THEN
                    //    isInserted := SIIDocuments.MODIFY;
                    //Q13694 +
                END;
                //QuoSII1.4.0.end
            END ELSE
                isInserted := FALSE;
        END ELSE BEGIN
            //QuoSII1.4.0.begin
            isInserted := SIIDocuments.INSERT(TRUE);
            IF NOT isInserted THEN BEGIN
                //Q13694 -
                SIIDocuments4.RESET;
                IF SIIDocuments4.GET(SIIDocuments."Document Type", SIIDocuments."Document No.", SIIDocuments."VAT Registration No.",
                                     SIIDocuments."Posting Date", SIIDocuments."Entry No.", SIIDocuments."Register Type") THEN BEGIN
                    SIIDocuments4.Modified := FALSE; //QuoSII_1.4.99.999
                    IF SIIDocuments4."AEAT Status" <> 'CORRECTO' THEN
                        isInserted := SIIDocuments4.MODIFY;
                END;
                //SIIDocuments.Modified := FALSE; //QuoSII_1.4.99.999
                //IF SIIDocuments."AEAT Status" <> 'CORRECTO' THEN
                //  isInserted := SIIDocuments.MODIFY;
                //Q13694 +
            END;
            //QuoSII1.4.0.end
        END;
        //QuoSII1.4-2.end

        //QUOSII_02_03 ------>
        //QuoSII_1.4.0.008.begin
        IF NOT isInserted THEN BEGIN
            //Quosii.B9.Begin
            SIIDocuments3.RESET;
            SIIDocuments3.SETRANGE("Document No.", SIIDocuments."Document No.");
            SIIDocuments3.SETRANGE("Document Type", SIIDocuments."Document Type");
            SIIDocuments3.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
            SIIDocuments3.SETRANGE("Posting Date", SIIDocuments."Posting Date");
            SIIDocuments3.SETRANGE("Entry No.", SIIDocuments."Entry No.");
            SIIDocuments3.SETRANGE("Register Type", SIIDocuments."Register Type");
            IF NOT SIIDocuments3.FINDFIRST THEN
                EXIT(TRUE);  //Quosii.B9.End
        END;
        //QuoSII_1.4.0.008.end

        EXIT(FALSE);
    END;

    PROCEDURE CreateCustLines(CustLedgEntry: Record 21; DocType: Option; SIIDocument: Record 7174333): Boolean;
    VAR
        Customer: Record 18;
        VATEntry: Record 254;
        GenProductPostingGroup: Record 251;
        VATPostingSetup: Record 325;
        SIIDocumentLine: Record 7174334;
        GLEntry: Record 17;
        QuoSIISetup: Record 79;
        errorInsert: Boolean;
    BEGIN
        QuoSIISetup.GET;
        errorInsert := FALSE;  //Quosii.B9.

        IF Customer.GET(CustLedgEntry."Customer No.") THEN;
        //QuoSII.2_5.begin
        CustLedgEntry.CALCFIELDS("Amount (LCY)");
        //QuoSII.2_5.end

        //QuoSII1.4.0.begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document Type", SIIDocument."Document Type");
        SIIDocumentLine.SETRANGE("Document No.", SIIDocument."Document No.");
        SIIDocumentLine.SETRANGE("Entry No.", SIIDocument."Entry No.");
        SIIDocumentLine.SETRANGE("Register Type", SIIDocument."Register Type");
        SIIDocumentLine.DELETEALL;
        //QuoSII1.4.0.end

        VATEntry.RESET;
        VATEntry.SETRANGE("Document No.", CustLedgEntry."Document No.");
        VATEntry.SETRANGE("Posting Date", CustLedgEntry."Posting Date");
        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
        IF VATEntry.FINDSET THEN
            REPEAT
                //QuoSII.001.begin
                GenProductPostingGroup.RESET;
                GenProductPostingGroup.GET(VATEntry."Gen. Prod. Posting Group");
                //QuoSII.001.end
                VATPostingSetup.RESET;
                IF VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group") THEN BEGIN
                    //QuoSII1.4-2.begin
                    IF (QuoSIISetup."QuoSII Inclusion Date" <> 0D) AND (SIIDocument."Posting Date" < QuoSIISetup."QuoSII Inclusion Date") THEN BEGIN
                        //Sujeta, no Exenta
                        //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                        ProcessCustomerLine(0, DocType, SIIDocument, CustLedgEntry, VATEntry, GenProductPostingGroup, VATPostingSetup, VATEntry.Amount, errorInsert);
                    END ELSE
                        //QuoSII1.4-2.end
                        IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"No Taxable VAT" THEN BEGIN
                            //No Sujeta
                            //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                            ProcessCustomerLine(1, DocType, SIIDocument, CustLedgEntry, VATEntry, GenProductPostingGroup, VATPostingSetup, VATEntry.Amount, errorInsert);
                        END ELSE BEGIN                                                                                                        //Sujeta
                                                                                                                                              //PSM 19/05/21+
                            IF VATPostingSetup."QuoSII No VAT Type" <> '' THEN BEGIN                                                                   //No Sujeta
                                                                                                                                                       //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                                ProcessCustomerLine(1, DocType, SIIDocument, CustLedgEntry, VATEntry, GenProductPostingGroup, VATPostingSetup, VATEntry.Amount, errorInsert);
                            END ELSE
                                //PSM 19/05/21-
                                IF VATPostingSetup."QuoSII Exent Type" <> '' THEN BEGIN                                                                    //Exenta
                                                                                                                                                           //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                                    ProcessCustomerLine(2, DocType, SIIDocument, CustLedgEntry, VATEntry, GenProductPostingGroup, VATPostingSetup, VATEntry.Amount, errorInsert);
                                END ELSE BEGIN
                                    //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                                    ProcessCustomerLine(0, DocType, SIIDocument, CustLedgEntry, VATEntry, GenProductPostingGroup, VATPostingSetup, VATEntry.Amount, errorInsert);
                                END;
                        END;
                END;
            UNTIL VATEntry.NEXT = 0;

        //Movimientos no sujetos a IVA, los sacamos del movimiento contable
        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", CustLedgEntry."Document No.");
        GLEntry.SETRANGE("Document Type", CustLedgEntry."Document Type");
        GLEntry.SETRANGE("Posting Date", CustLedgEntry."Posting Date");
        //JAV 04/05/22: - QUOSII 1.06.07 No filtramos estos valores, dejaremos que luego el GET del VATPostingSetup y su verificaci�n, ya que pueden estar en blanco alguno de los dos
        //GLEntry.SETFILTER("VAT Bus. Posting Group",'<>%1',' ');
        //GLEntry.SETFILTER("VAT Prod. Posting Group",'<>%1',' ');
        GLEntry.SETRANGE("VAT Amount", 0);
        //PSM 18/08/22-
        GLEntry.SETFILTER("QiuoSII Entity", '%1', '');
        GLEntry.SETFILTER("Gen. Posting Type", '<>%1', GLEntry."Gen. Posting Type"::" ");
        //PSM 18/08/22+
        IF GLEntry.FINDSET THEN
            REPEAT
                //JAV 04/05/22: - QUOSII 1.06.07 si no existe el grupo registro de producto no dar un error
                IF NOT GenProductPostingGroup.GET(GLEntry."Gen. Prod. Posting Group") THEN
                    GenProductPostingGroup.INIT;

                VATPostingSetup.RESET;
                IF VATPostingSetup.GET(GLEntry."VAT Bus. Posting Group", GLEntry."VAT Prod. Posting Group") THEN
                    //Q18695-
                    IF (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"No Taxable VAT") AND
             (VATPostingSetup."QuoSII DUA Compensation" = FALSE) THEN BEGIN
                        //IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"No Taxable VAT" THEN BEGIN
                        //Q18695+
                        IF NOT GenProductPostingGroup."QuoSII IRPF Type" THEN BEGIN//QuoSII_1.4.02.042.15
                                                                                   //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                            CLEAR(VATEntry);
                            ProcessCustomerLine(3, DocType, SIIDocument, CustLedgEntry, VATEntry, GenProductPostingGroup, VATPostingSetup, GLEntry.Amount, errorInsert);
                        END;
                    END;
            UNTIL GLEntry.NEXT = 0;

        EXIT(errorInsert);
    END;

    PROCEDURE CreateVendHeader(VendorLedgerEntry: Record 25; DocType: Option; VAR SIIDocuments: Record 7174333): Boolean;
    VAR
        PurchInvoiceHeader: Record 122;
        PurchInvoiceLine: Record 123;
        PurchCrMemoHeader: Record 124;
        PurchCrMemoLine: Record 125;
        LastRcptDate: Date;
        PurchRcptLine: Record 121;
        result: Boolean;
        Vendor: Record 23;
        TypeListValue: Record 7174331;
        SIIDocuments2: Record 7174333;
        QuoSIISetup: Record 79;
        isInserted: Boolean;
        SIIDocuments3: Record 7174333;
        SIIDocuments4: Record 7174333;
        NotSend: Boolean;
        CompanyInformation: Record 79;
    BEGIN
        QuoSIISetup.GET();
        CompanyInformation.GET();

        //JAV 13/05/21: - QuoSII 1.5k Si el documento tiene la marca de no subir, me lo salto
        NotSend := FALSE;
        IF (VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice) THEN BEGIN
            IF PurchInvoiceHeader.GET(VendorLedgerEntry."Document No.") THEN BEGIN
                IF (PurchInvoiceHeader."Do not send to SII") THEN
                    NotSend := TRUE;
            END;
        END ELSE IF (VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo") THEN BEGIN
            IF PurchCrMemoHeader.GET(VendorLedgerEntry."Document No.") THEN BEGIN
                IF (PurchCrMemoHeader."Do not send to SII") THEN
                    NotSend := TRUE;
            END
        END;

        //JAV 11/05/22: - QuoSII 1.06.07 Si es un movimiento de liquidaci�n de una retenci�n no debe subir al SII
        IF (VendorLedgerEntry."Do not sent to SII") THEN
            NotSend := TRUE;

        IF (NotSend) THEN BEGIN
            //Q13694 - Si ya se ha subido no puedo hacer nada aunque me lo pongan como no subir
            SIIDocuments4.RESET;
            SIIDocuments4.SETRANGE("Document Type", SIIDocuments4."Document Type"::FE);
            SIIDocuments4.SETRANGE("External Reference", VendorLedgerEntry."Document No.");
            SIIDocuments4.SETRANGE("Register Type", '');
            IF SIIDocuments4.FINDFIRST THEN
                EXIT;
            //Q13694 +
            DocType := SIIDocuments."Document Type"::NO;
        END;
        //JAV fin

        //QuoSII.2_5.begin
        VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
        //QuoSII.2_5.end
        Vendor.RESET;
        IF Vendor.GET(VendorLedgerEntry."Vendor No.") THEN;

        SIIDocuments.INIT;
        SIIDocuments."Cust/Vendor No." := VendorLedgerEntry."Vendor No.";
        SIIDocuments."Cust/Vendor Name" := Vendor.Name;
        //QuoSII.1.4.02.042.21.begin
        IF VendorLedgerEntry."QuoSII Purch. Invoice Type" = 'F5' THEN
            SIIDocuments."Cust/Vendor Name" := CompanyInformation.Name;
        //QuoSII.1.4.02.042.21.end
        //SIIDocuments."Document No." := VendorLedgerEntry."External Document No."; //1901-
        SIIDocuments."Document No." := EliminarEspacios(VendorLedgerEntry."External Document No."); //1901+
        SIIDocuments."Document Type" := DocType;
        SIIDocuments."VAT Registration No." := Vendor."VAT Registration No.";
        //QuoSII.1.4.02.042.21.begin
        IF VendorLedgerEntry."QuoSII Purch. Invoice Type" = 'F5' THEN
            SIIDocuments."VAT Registration No." := CompanyInformation."VAT Registration No.";
        //QuoSII.1.4.02.042.21.end
        SIIDocuments."Last Ticket No." := VendorLedgerEntry."QuoSII Last Ticket No.";
        SIIDocuments."Entry No." := VendorLedgerEntry."Entry No.";
        SIIDocuments.Year := DATE2DMY(VendorLedgerEntry."Posting Date", 3);
        SIIDocuments."SII Entity" := VendorLedgerEntry."QuoSII Entity";//QuoSII_1.4.02.042
        SIIDocuments."External Reference" := VendorLedgerEntry."Document No.";//QuoSII_1.4.0.017

        //QuoSII.1.3.02.001.begin
        IF (QuoSIISetup."QuoSII Day Periodo Purchase" = 0) THEN  //JAV 12/04/21 se hace configurable el campo del �ltimo d�a, si no se informa es el 15
            QuoSIISetup."QuoSII Day Periodo Purchase" := 15;

        IF (DATE2DMY(VendorLedgerEntry."Posting Date", 1) <= QuoSIISetup."QuoSII Day Periodo Purchase") AND (QuoSIISetup."QuoSII Purch. Invoices Period" = TRUE) AND
            //Q19407-
            ((DATE2DMY(VendorLedgerEntry."Document Date", 2) + 1 = DATE2DMY(VendorLedgerEntry."Posting Date", 2)) OR
            ((DATE2DMY(VendorLedgerEntry."Document Date", 2)) = 12) AND (DATE2DMY(VendorLedgerEntry."Posting Date", 2) = 1) AND
            ((DATE2DMY(VendorLedgerEntry."Document Date", 3) + 1 = DATE2DMY(VendorLedgerEntry."Posting Date", 3)))) THEN
        //(DATE2DMY(VendorLedgerEntry."Document Date",2) < DATE2DMY(VendorLedgerEntry."Posting Date",2)) THEN
        //Q19407+
        BEGIN
            SIIDocuments.Period := FORMAT(DATE2DMY(VendorLedgerEntry."Posting Date", 2) - 1);
            IF SIIDocuments.Period = '0' THEN BEGIN
                SIIDocuments.Period := '12';
                SIIDocuments.Year := DATE2DMY(VendorLedgerEntry."Posting Date", 3) - 1;//QuoSII_1.4.0.015
            END;
        END ELSE
            SIIDocuments.Period := FORMAT(DATE2DMY(VendorLedgerEntry."Posting Date", 2));
        //QuoSII.1.3.02.001.end

        TypeListValue.RESET;
        TypeListValue.SETRANGE(Type, TypeListValue.Type::Period);
        TypeListValue.SETRANGE(Code, SIIDocuments.Period);
        IF TypeListValue.FINDFIRST THEN
            SIIDocuments."Period Name" := TypeListValue.Description;

        IF VendorLedgerEntry."Document Type" IN [VendorLedgerEntry."Document Type"::Invoice,
                                               VendorLedgerEntry."Document Type"::"Credit Memo"] THEN BEGIN
            //QuoSII.3_0.begin
            SIIDocuments."Document Date" := VendorLedgerEntry."Document Date";
            SIIDocuments."Posting Date" := VendorLedgerEntry."Posting Date";

            //JAV 28/09/22: - QB 1.06.12 Usar la fecha de operaci�n en facturas de compra seg�n la nueva configuraci�n
            //SIIDocuments."Shipping Date" := VendorLedgerEntry."Posting Date";
            CASE QuoSIISetup."QuoSII Purch.Operation Date" OF
                QuoSIISetup."QuoSII Purch.Operation Date"::Blank:
                    SIIDocuments."Shipping Date" := 0D;
                QuoSIISetup."QuoSII Purch.Operation Date"::DocumentDate:
                    SIIDocuments."Shipping Date" := VendorLedgerEntry."Document Date";
                QuoSIISetup."QuoSII Purch.Operation Date"::PostingDate:
                    SIIDocuments."Shipping Date" := VendorLedgerEntry."Posting Date";
            END;

            LastRcptDate := 0D;
            IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice THEN
                IF PurchInvoiceHeader.GET(VendorLedgerEntry."Document No.") THEN BEGIN
                    PurchInvoiceLine.SETRANGE("Document No.", VendorLedgerEntry."Document No.");
                    IF PurchInvoiceLine.FINDSET THEN
                        REPEAT
                        //IF PurchInvoiceLine."Receipt No." <> '' THEN
                        //  IF PurchRcptLine.GET(PurchInvoiceLine."Receipt No.",PurchInvoiceLine."Receipt Line No.") THEN
                        //    IF PurchRcptLine."Posting Date" > LastRcptDate THEN
                        //      LastRcptDate := PurchRcptLine."Posting Date"
                        UNTIL PurchInvoiceLine.NEXT = 0;
                END;

            //IF SIIDocuments."Posting Date" <> LastRcptDate THEN
            //  SIIDocuments."Shipping Date" := LastRcptDate;

            SIIDocuments.Year := DATE2DMY(SIIDocuments."Posting Date", 3);
            //QuoSII.1.3.02.001.begin
            //SIIDocuments.Period := FORMAT(DATE2DMY(SIIDocuments."Posting Date",2));
            //QuoSII.1.3.02.001.end
            //QuoSII.1.3.03.006.begin
            IF VendorLedgerEntry."QuoSII Use Auto Date" THEN
                SIIDocuments."Posting Date" := VendorLedgerEntry."QuoSII Auto Posting Date";
            //QuoSII.1.3.03.006.end
            //QuoSII.3_0.end

            IF SIIDocuments."Document Type" <> SIIDocuments."Document Type"::OI THEN BEGIN
                //QuoSII.2_4.begin
                IF VendorLedgerEntry."QuoSII Purch. Corr. Inv. Type" <> '' THEN BEGIN//QuoSII_1.4.02.042
                                                                                     //QuoSII.2_4.end
                                                                                     //QuoSII.005.begin
                    SIIDocuments."Invoice Type" := VendorLedgerEntry."QuoSII Purch. Corr. Inv. Type";//QuoSII_1.4.02.042
                    SIIDocuments."CrMemo Type" := VendorLedgerEntry."QuoSII Purch. Cr.Memo Type";//QuoSII_1.4.02.042
                                                                                                 //QuoSII.005.end

                    TypeListValue.RESET;
                    TypeListValue.SETRANGE(Type, TypeListValue.Type::CorrectedInvType);
                    TypeListValue.SETRANGE(Code, SIIDocuments."CrMemo Type");
                    IF TypeListValue.FINDFIRST THEN
                        SIIDocuments."Cr.Memo Type Name" := TypeListValue.Description;
                    //QuoSII.2_4.begin
                END ELSE
                    SIIDocuments."Invoice Type" := VendorLedgerEntry."QuoSII Purch. Invoice Type";//QuoSII_1.4.02.042

                IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" THEN BEGIN
                    //QuoSII.2_4.end
                    //SIIDocuments."Document No." := VendorLedgerEntry."External Document No."; //1901-
                    SIIDocuments."Document No." := EliminarEspacios(VendorLedgerEntry."External Document No."); //1901+
                    PurchCrMemoHeader.RESET;
                    PurchCrMemoHeader.SETRANGE("No.", VendorLedgerEntry."Document No.");
                    IF PurchCrMemoHeader.FINDFIRST THEN BEGIN
                        //SIIDocuments."Document No." := PurchCrMemoHeader."Vendor Cr. Memo No."; //1901-
                        SIIDocuments."Document No." := EliminarEspacios(PurchCrMemoHeader."Vendor Cr. Memo No."); //1901+
                    END;
                END ELSE BEGIN
                    IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice THEN BEGIN
                        //SIIDocuments."Document No." := VendorLedgerEntry."External Document No."; //1901-
                        SIIDocuments."Document No." := EliminarEspacios(VendorLedgerEntry."External Document No."); //1901+
                        PurchInvoiceHeader.RESET;
                        PurchInvoiceHeader.SETRANGE("No.", VendorLedgerEntry."Document No.");
                        IF PurchInvoiceHeader.FINDFIRST THEN BEGIN
                            //SIIDocuments."Document No." := PurchInvoiceHeader."Vendor Invoice No."; //1901-
                            SIIDocuments."Document No." := EliminarEspacios(PurchInvoiceHeader."Vendor Invoice No."); //1901+
                        END;
                    END;
                END;

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::PurchInvType);
                TypeListValue.SETRANGE(Code, SIIDocuments."Invoice Type");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Invoice Type Name" := TypeListValue.Description;

                //QuoSII.2_5.begin
                SIIDocuments."Invoice Amount" := -VendorLedgerEntry."Amount (LCY)";
                //QuoSII.2_5.end
                SIIDocuments."Description Operation 1" := VendorLedgerEntry.Description;
                SIIDocuments.VALIDATE("Special Regime", VendorLedgerEntry."QuoSII Purch. Special Reg.");//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialPurchInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime Name" := TypeListValue.Description;
                SIIDocuments."Special Regime 1" := VendorLedgerEntry."QuoSII Purch. Special Reg. 1";//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialSalesInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime 1");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime 1 Name" := TypeListValue.Description;
                SIIDocuments."Special Regime 2" := VendorLedgerEntry."QuoSII Purch. Special Reg. 2";//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialPurchInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime 2");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime 2 Name" := TypeListValue.Description;

                IF VendorLedgerEntry."QuoSII Third Party" THEN
                    SIIDocuments."Third Party" := 'S'
                ELSE
                    SIIDocuments."Third Party" := 'N';
                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::ThirdParty);
                TypeListValue.SETRANGE(Code, SIIDocuments."Third Party");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Third Party Name" := TypeListValue.Description;
            END ELSE BEGIN
                //SIIDocuments."Document No." := VendorLedgerEntry."External Document No."; //1901-
                SIIDocuments."Document No." := EliminarEspacios(VendorLedgerEntry."External Document No."); //1901+
                SIIDocuments."Declarate Key UE" := 'R';
                SIIDocuments."Invoice Type" := VendorLedgerEntry."QuoSII Purch. UE Inv Type";//QuoSII_1.4.02.042

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::IntraType);
                TypeListValue.SETRANGE(Code, SIIDocuments."Invoice Type");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Invoice Type Name" := TypeListValue.Description;

                SIIDocuments."UE Country" := VendorLedgerEntry."QuoSII UE Country";
                SIIDocuments."Bienes Description" := VendorLedgerEntry."QuoSII Bienes Description";
                SIIDocuments."Operator Address" := VendorLedgerEntry."QuoSII Operator Address";

                //QuoSII_1.3.02.005.begin
                //SIIDocuments."Document Date" := 0D;
                //QuoSII_1.3.02.005.end
                IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" THEN BEGIN
                    //SIIDocuments."Document No." := VendorLedgerEntry."External Document No."; //1901-
                    SIIDocuments."Document No." := EliminarEspacios(VendorLedgerEntry."External Document No."); //1901+
                    PurchCrMemoHeader.RESET;
                    PurchCrMemoHeader.SETRANGE("No.", VendorLedgerEntry."Document No.");
                    IF PurchCrMemoHeader.FINDFIRST THEN BEGIN
                        //SIIDocuments."Document No." := PurchCrMemoHeader."Vendor Cr. Memo No."; //1901-
                        SIIDocuments."Document No." := EliminarEspacios(PurchCrMemoHeader."Vendor Cr. Memo No."); //1901+
                    END;
                END ELSE BEGIN
                    //SIIDocuments."Document No." := VendorLedgerEntry."External Document No."; //1901-
                    SIIDocuments."Document No." := EliminarEspacios(VendorLedgerEntry."External Document No."); //1901+
                    PurchInvoiceHeader.RESET;
                    PurchInvoiceHeader.SETRANGE("No.", VendorLedgerEntry."Document No.");
                    IF PurchInvoiceHeader.FINDFIRST THEN BEGIN
                        //SIIDocuments."Document No." := PurchInvoiceHeader."Vendor Invoice No."; //1901-
                        SIIDocuments."Document No." := EliminarEspacios(PurchInvoiceHeader."Vendor Invoice No."); //1901+
                    END;
                END;
            END;
        END;

        //QuoSII1.4-2.begin
        SIIDocuments.VALIDATE("External Reference", VendorLedgerEntry."Document No.");

        IF QuoSIISetup."QuoSII Inclusion Date" <> 0D THEN
            IF SIIDocuments."Posting Date" < QuoSIISetup."QuoSII Inclusion Date" THEN BEGIN
                SIIDocuments."Description Operation 1" := 'Registro del Primer Semestre o anterior a la inclusi�n del SII';
                SIIDocuments.VALIDATE("Special Regime", COAP);//QuoSII_1.4.02.042  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes

                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::KeySpecialPurchInv);
                TypeListValue.SETRANGE(Code, SIIDocuments."Special Regime");
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Special Regime Name" := TypeListValue.Description;
                SIIDocuments."Special Regime 1" := '';//QuoSII_1.4.02.042
                SIIDocuments."Special Regime 1 Name" := '';//QuoSII_1.4.02.042
                SIIDocuments."Special Regime 2" := '';//QuoSII_1.4.02.042
                SIIDocuments."Special Regime 2 Name" := '';//QuoSII_1.4.02.042
            END;

        //SIIDocuments.Emited := FALSE;  //JAV Ya no se usa esta variable

        IF (SIIDocuments."Invoice Amount" > 100000000) AND (NOT QuoSIISetup."QuoSII Ignore Messages") THEN BEGIN
            IF CONFIRM('Se est� incluyendo la factura con ID %1, cuyo importe rebasa los 100.000.000 �. �Desea incluirla?', FALSE, SIIDocuments."Document No.") THEN BEGIN
                //QuoSII1.4.0.begin
                isInserted := SIIDocuments.INSERT(TRUE);
                IF NOT isInserted THEN BEGIN
                    //Q13694 -
                    SIIDocuments4.RESET;
                    IF SIIDocuments4.GET(SIIDocuments."Document Type", SIIDocuments."Document No.", SIIDocuments."VAT Registration No.", SIIDocuments."Posting Date", SIIDocuments."Entry No.", SIIDocuments."Register Type") THEN BEGIN
                        SIIDocuments4.Modified := FALSE; //QuoSII_1.4.99.999
                        IF SIIDocuments4."AEAT Status" <> 'CORRECTO' THEN
                            isInserted := SIIDocuments4.MODIFY;
                    END;
                    //SIIDocuments.Modified := FALSE; //QuoSII_1.4.99.999
                    //  IF SIIDocuments."AEAT Status" <> 'CORRECTO' THEN
                    //    isInserted := SIIDocuments.MODIFY;
                    //Q13694 +
                END;
                //QuoSII1.4.0.end
            END ELSE
                isInserted := FALSE;
        END ELSE BEGIN
            //QuoSII1.4.0.begin
            isInserted := SIIDocuments.INSERT(TRUE);
            IF NOT isInserted THEN BEGIN
                //Q13694 -
                SIIDocuments4.RESET;
                IF SIIDocuments4.GET(SIIDocuments."Document Type", SIIDocuments."Document No.", SIIDocuments."VAT Registration No.",
                                     SIIDocuments."Posting Date", SIIDocuments."Entry No.", SIIDocuments."Register Type") THEN BEGIN
                    SIIDocuments4.Modified := FALSE; //QuoSII_1.4.99.999
                    IF SIIDocuments4."AEAT Status" <> 'CORRECTO' THEN
                        isInserted := SIIDocuments4.MODIFY;
                END;
                //SIIDocuments.Modified := FALSE; //QuoSII_1.4.99.999
                //IF SIIDocuments."AEAT Status" <> 'CORRECTO' THEN
                //  isInserted := SIIDocuments.MODIFY;
                //Q13694 +
            END;
            //QuoSII1.4.0.end
        END;
        //QuoSII1.4-2.end


        //QUOSII_02_03 ----->
        //QuoSII_1.4.0.008.begin
        IF NOT isInserted THEN BEGIN
            //Quosii.B9.Begin
            SIIDocuments3.RESET;
            SIIDocuments3.SETRANGE("Document No.", SIIDocuments."Document No.");
            SIIDocuments3.SETRANGE("Document Type", SIIDocuments."Document Type");
            SIIDocuments3.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
            SIIDocuments3.SETRANGE("Posting Date", SIIDocuments."Posting Date");
            SIIDocuments3.SETRANGE("Entry No.", SIIDocuments."Entry No.");
            SIIDocuments3.SETRANGE("Register Type", SIIDocuments."Register Type");
            IF NOT SIIDocuments3.FINDFIRST THEN
                EXIT(TRUE);
            //Quosii.B9.End
        END;
        //QuoSII_1.4.0.008.end
        EXIT(FALSE);
        //QUOSII_02_03 <-----
    END;

    PROCEDURE CreateVendLines(VendorLedgEntry: Record 25; DocType: Option; SIIDocument: Record 7174333): Boolean;
    VAR
        PurchCrMemoHeader: Record 124;
        PurchInvoiceHeader: Record 122;
        Vendor: Record 23;
        VATEntry: Record 254;
        GenProductPostingGroup: Record 251;
        VATPostingSetup: Record 325;
        SIIDocumentLine: Record 7174334;
        GLEntry: Record 17;
        QuoSIISetup: Record 79;
        errorInsert: Boolean;
        CompanyInformation: Record 79;
    BEGIN
        QuoSIISetup.GET();
        CompanyInformation.GET();
        errorInsert := FALSE;

        IF Vendor.GET(VendorLedgEntry."Vendor No.") THEN;
        //QuoSII.2_5.begin
        VendorLedgEntry.CALCFIELDS("Amount (LCY)");
        //QuoSII.2_5.end

        //QuoSII1.4.0.begin
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document No.", SIIDocument."Document No.");
        SIIDocumentLine.SETRANGE("Document Type", SIIDocument."Document Type");
        SIIDocumentLine.SETRANGE("Entry No.", SIIDocument."Entry No.");
        SIIDocumentLine.SETRANGE("Register Type", SIIDocument."Register Type");
        SIIDocumentLine.DELETEALL;
        //QuoSII1.4.0.end

        VATEntry.RESET;
        VATEntry.SETRANGE("Document No.", VendorLedgEntry."Document No.");
        VATEntry.SETRANGE("Posting Date", VendorLedgEntry."Posting Date");
        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
        IF VATEntry.FINDSET THEN
            REPEAT
                //JAV 04/05/22: - QUOSII 1.06.07 No leia el grupo aunque si lo usaba
                IF NOT GenProductPostingGroup.GET(VATEntry."Gen. Prod. Posting Group") THEN
                    GenProductPostingGroup.INIT;

                VATPostingSetup.RESET;
                //PSM 20/05/21+
                IF (VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group")) AND (VATPostingSetup."QuoSII DUA Compensation" = FALSE) THEN BEGIN
                    //IF VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group") THEN BEGIN
                    //PSM 20/05/21-
                    //QuoSII1.4-2.begin
                    IF (QuoSIISetup."QuoSII Inclusion Date" <> 0D) AND (SIIDocument."Posting Date" < QuoSIISetup."QuoSII Inclusion Date") THEN BEGIN
                        //Sujeta, no Exenta
                        //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                        ProcessVendorLine(0, DocType, SIIDocument, VendorLedgEntry, VATEntry, VATPostingSetup, VATEntry.Amount, errorInsert, FALSE);
                    END ELSE
                        //QuoSII1.4-2.end
                        //PSM 19/05/21+
                        IF VATPostingSetup."QuoSII No VAT Type" <> '' THEN BEGIN
                            IF NOT GenProductPostingGroup."QuoSII IRPF Type" THEN BEGIN
                                //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                                ProcessVendorLine(1, DocType, SIIDocument, VendorLedgEntry, VATEntry, VATPostingSetup, VATEntry.Amount, errorInsert, FALSE);
                            END ELSE BEGIN
                                IF VATEntry.Base < 0 THEN
                                    SIIDocument."Invoice Amount" += -VATEntry.Base
                                ELSE
                                    SIIDocument."Invoice Amount" -= VATEntry.Base;
                                SIIDocument.Modified := FALSE;
                                SIIDocument.MODIFY;
                            END;
                        END ELSE
                            //PSM 19/05/21-
                            IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                                ProcessVendorLine(0, DocType, SIIDocument, VendorLedgEntry, VATEntry, VATPostingSetup, VATEntry.Amount, errorInsert, TRUE);
                            END ELSE BEGIN
                                //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                                ProcessVendorLine(0, DocType, SIIDocument, VendorLedgEntry, VATEntry, VATPostingSetup, VATEntry.Amount, errorInsert, FALSE);
                            END;
                END;
            UNTIL VATEntry.NEXT = 0;//QuoSII1.3_015
                                    //QuoSII.004.begin
                                    //ELSE BEGIN//QuoSII1.3_015
        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", VendorLedgEntry."Document No.");
        GLEntry.SETRANGE("Document Type", VendorLedgEntry."Document Type");
        GLEntry.SETRANGE("Posting Date", VendorLedgEntry."Posting Date");
        IF VendorLedgEntry."Document Type" = VendorLedgEntry."Document Type"::Payment THEN
            GLEntry.SETRANGE("Bal. Account Type", GLEntry."Bal. Account Type"::Vendor)
        ELSE BEGIN
            //JAV 04/05/22: - QUOSII 1.06.07 No filtramos estos valores, dejaremos que luego el GET del VATPostingSetup y su verificaci�n, ya que pueden estar en blanco alguno de los dos
            //GLEntry.SETFILTER("VAT Bus. Posting Group",'<>%1',' ');
            //GLEntry.SETFILTER("VAT Prod. Posting Group",'<>%1',' ');
        END;
        IF GLEntry.FINDSET THEN
            REPEAT
                //JAV 04/05/22: - QUOSII 1.06.07 si no existe no dar un error
                IF NOT GenProductPostingGroup.GET(GLEntry."Gen. Prod. Posting Group") THEN
                    GenProductPostingGroup.INIT;

                VATPostingSetup.RESET;
                IF VATPostingSetup.GET(GLEntry."VAT Bus. Posting Group", GLEntry."VAT Prod. Posting Group") THEN
                    //Q18695-
                    IF (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"No Taxable VAT") AND
              (VATPostingSetup."QuoSII DUA Compensation" = FALSE) THEN BEGIN
                        //IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"No Taxable VAT" THEN BEGIN
                        //Q18695+
                        IF NOT GenProductPostingGroup."QuoSII IRPF Type" THEN BEGIN//QuoSII1.3_015
                                                                                   //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores
                            CLEAR(VATEntry);
                            ProcessVendorLine(3, DocType, SIIDocument, VendorLedgEntry, VATEntry, VATPostingSetup, GLEntry.Amount, errorInsert, FALSE);
                            //QuoSII1.3_015.begin
                        END ELSE BEGIN
                            //QuoSII_1.4.01.042.begin
                            //SIIDocQument."Invoice Amount" += -(GLEntry.Amount*2);
                            IF GLEntry.Amount < 0 THEN
                                SIIDocument."Invoice Amount" += -GLEntry.Amount
                            ELSE
                                SIIDocument."Invoice Amount" -= GLEntry.Amount;
                            //QuoSII_1.4.01.042.end
                            SIIDocument.Modified := FALSE; //QuoSII_1.4.99.999
                            SIIDocument.MODIFY;
                        END;
                        //QuoSII1.3_015.end
                    END;
            UNTIL GLEntry.NEXT = 0;
        //END;//QuoSII1.3_014
        //QuoSII.004.end

        EXIT(errorInsert);
    END;

    LOCAL PROCEDURE CreateBIHeader(PurchInvHeader: Record 122; FALedgerEntry: Record 5601);
    VAR
        SIIDocuments: Record 7174333;
        FALedgerEntryAUX: Record 5601;
        Importe1: Decimal;
        Importe2: Decimal;
        VendorAUX: Record 23;
        SIIDocuments2: Record 7174333;
        QuoSIISetup: Record 79;
    BEGIN
        QuoSIISetup.GET;

        //QuoSII_03.Begin
        CLEAR(SIIDocuments);
        SIIDocuments."Cust/Vendor No." := PurchInvHeader."Buy-from Vendor No.";
        IF FALedgerEntry."External Document No." <> '' THEN
            //SIIDocuments."Document No." := FALedgerEntry."External Document No." //1901-
            SIIDocuments."Document No." := EliminarEspacios(FALedgerEntry."External Document No.") //1901+
        ELSE
            //SIIDocuments."Document No." := FALedgerEntry."Document No."; //1901-
            SIIDocuments."Document No." := EliminarEspacios(FALedgerEntry."Document No."); //1901+

        SIIDocuments."Document Type" := SIIDocuments."Document Type"::BI;
        SIIDocuments.Year := DATE2DMY(PurchInvHeader."Posting Date", 3);
        SIIDocuments.Period := '0A';
        SIIDocuments."Posting Date" := PurchInvHeader."Posting Date";
        SIIDocuments."FA ID" := FALedgerEntry."FA No.";
        SIIDocuments."Start Date of use" := FALedgerEntry."Depreciation Starting Date";
        SIIDocuments."SII Entity" := PurchInvHeader."QuoSII Entity";//QuoSII_1.4.02.042

        VendorAUX.RESET;
        VendorAUX.SETFILTER("No.", PurchInvHeader."Buy-from Vendor No.");
        IF VendorAUX.FINDFIRST THEN BEGIN
            SIIDocuments."Cust/Vendor Name" := VendorAUX.Name;
            SIIDocuments."VAT Registration No." := VendorAUX."VAT Registration No.";
        END;

        CLEAR(Importe1);
        CLEAR(Importe2);

        FALedgerEntryAUX.RESET();
        FALedgerEntryAUX.SETFILTER("FA No.", FALedgerEntry."FA No.");
        FALedgerEntryAUX.SETFILTER("FA Posting Type", '%1|%2', FALedgerEntryAUX."FA Posting Type"::Depreciation, FALedgerEntryAUX.
        "FA Posting Type"::"Write-Down");
        FALedgerEntryAUX.SETFILTER("FA Posting Category", '');
        IF FALedgerEntryAUX.FINDSET THEN BEGIN
            REPEAT
                Importe1 += ABS(FALedgerEntryAUX."Amount (LCY)");
            UNTIL FALedgerEntryAUX.NEXT = 0;
        END;

        FALedgerEntryAUX.RESET();
        FALedgerEntryAUX.SETFILTER("FA No.", FALedgerEntry."FA No.");
        FALedgerEntryAUX.SETFILTER("Document Type", FORMAT(FALedgerEntryAUX."Document Type"::Invoice));
        FALedgerEntryAUX.SETFILTER("FA Posting Type", FORMAT(FALedgerEntryAUX."FA Posting Type"::"Acquisition Cost"));
        FALedgerEntryAUX.SETFILTER("FA Posting Category", '');
        IF FALedgerEntryAUX.FINDSET THEN BEGIN
            REPEAT
                Importe2 += ABS(FALedgerEntryAUX."Amount (LCY)");
            UNTIL FALedgerEntryAUX.NEXT = 0;
        END;

        IF Importe2 <> 0 THEN
            SIIDocuments."Prorrata Anual definitiva" := ROUND(Importe1 * 100 / Importe2, 0.01, '=')
        ELSE
            SIIDocuments."Prorrata Anual definitiva" := 0.0;
        //QuoSII1.4-2.begin
        IF (SIIDocuments."Invoice Amount" > 100000000) AND (NOT QuoSIISetup."QuoSII Ignore Messages") THEN BEGIN
            IF CONFIRM('Se est� incluyendo la factura con ID %1, cuyo importe rebasa los 100.000.000 �. �Desea incluirla?', FALSE, SIIDocuments."Document No.") THEN BEGIN
                SIIDocuments.INSERT(TRUE);
            END;
        END ELSE
            SIIDocuments.INSERT(TRUE);
        //QuoSII1.4-2.end
        //QUOSII.003.END
    END;

    LOCAL PROCEDURE CreateCashPayment(VAR TMPGLEntry: Record 17 TEMPORARY; FromDate: Date; ToDate: Date);
    VAR
        SIIDocument: Record 7174333;
        Year: Text[4];
        CustomerAux: Record 18;
        QuoSIISetup: Record 79;
    BEGIN
        QuoSIISetup.GET;

        //QUOSII.004.BEGIN
        SIIDocument.RESET;
        CLEAR(SIIDocument);

        SIIDocument."Document Type" := SIIDocument."Document Type"::CM;

        Year := FORMAT(DATE2DMY(ToDate, 3));

        EVALUATE(SIIDocument."Posting Date", ('3112' + Year));
        SIIDocument.Year := DATE2DMY(ToDate, 3);
        SIIDocument."Cust/Vendor No." := TMPGLEntry."Source No.";

        CustomerAux.RESET;
        CustomerAux.SETFILTER("No.", TMPGLEntry."Source No.");
        IF CustomerAux.FINDFIRST THEN BEGIN
            SIIDocument."Cust/Vendor Name" := CustomerAux.Name;
            SIIDocument."VAT Registration No." := CustomerAux."VAT Registration No.";
        END;

        //SIIDocument."Document No." := Year+SIIDocument."VAT Registration No."; //1901-
        SIIDocument."Document No." := EliminarEspacios(Year + SIIDocument."VAT Registration No."); //1901+
        SIIDocument.Period := '0A';
        SIIDocument."Invoice Amount" := TMPGLEntry.Amount;
        SIIDocument."SII Entity" := TMPGLEntry."QiuoSII Entity";//QuoSII_1.4.02.042

        //QuoSII1.4-2.begin
        IF (SIIDocument."Invoice Amount" > 100000000) AND (NOT QuoSIISetup."QuoSII Ignore Messages") THEN BEGIN
            IF CONFIRM('Se est� incluyendo la factura con ID %1, cuyo importe rebasa los 100.000.000 �. �Desea incluirla?', FALSE, SIIDocument."Document No.") THEN BEGIN
                IF SIIDocument.INSERT(TRUE) THEN;
            END;
        END ELSE
            //QuoSII1.4-2.end

            IF SIIDocument.INSERT(TRUE) THEN;
        //QUOSII.004.END
    END;

    LOCAL PROCEDURE CreateSalesPayment(CustLedgerEntry: Record 21; DocType: Option);
    VAR
        Customer: Record 18;
        SIIDocuments: Record 7174333;
        SIIDocuments2: Record 7174333;
        CustLedgerEntry2: Record 21;
        DetailedCustLedgEntry: Record 379;
        TypeListValue: Record 7174331;
    BEGIN
        Customer.RESET;
        IF Customer.GET(CustLedgerEntry."Customer No.") THEN;

        DetailedCustLedgEntry.RESET;
        DetailedCustLedgEntry.SETRANGE("Applied Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
        DetailedCustLedgEntry.SETFILTER("Initial Document Type", '%1|%2', DetailedCustLedgEntry."Initial Document Type"::Invoice,
                                                                         DetailedCustLedgEntry."Initial Document Type"::Bill);
        DetailedCustLedgEntry.SETRANGE("QuoSII Exported", FALSE);
        DetailedCustLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DetailedCustLedgEntry.FINDSET THEN
            REPEAT
                CLEAR(SIIDocuments);
                CustLedgerEntry2.GET(DetailedCustLedgEntry."Cust. Ledger Entry No.");
                SIIDocuments.INIT;
                SIIDocuments."Cust/Vendor No." := CustLedgerEntry."Customer No.";
                SIIDocuments."Cust/Vendor Name" := Customer.Name;
                SIIDocuments."Document Type" := DocType;
                SIIDocuments.Year := DATE2DMY(CustLedgerEntry."Posting Date", 3);
                SIIDocuments.Period := FORMAT(DATE2DMY(CustLedgerEntry."Posting Date", 2));
                SIIDocuments."VAT Registration No." := Customer."VAT Registration No.";
                //SIIDocuments."Document No." := CustLedgerEntry2."Document No."; //1901-
                SIIDocuments."Document No." := EliminarEspacios(CustLedgerEntry2."Document No."); //1901+
                SIIDocuments."Invoice Amount" := ABS(DetailedCustLedgEntry."Amount (LCY)");

                //JAV 07/06/22: - QB 1.06.09 Para cobros usar fecha de documento correctamente
                //SIIDocuments."Posting Date" := CustLedgerEntry2."Posting Date";
                SIIDocuments."Posting Date" := CustLedgerEntry2."Document Date";
                SIIDocuments."Document Date" := CustLedgerEntry."Posting Date";
                SIIDocuments."Medio Cobro/Pago" := CustLedgerEntry."QuoSII Medio Cobro";
                SIIDocuments.CuentaMedioCobro := CustLedgerEntry."QuoSII CuentaMedioCobro";
                SIIDocuments."Entry No." := CustLedgerEntry."Entry No.";
                SIIDocuments."SII Entity" := CustLedgerEntry."QuoSII Entity";//QuoSII_1.4.02.042
                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::Period);
                TypeListValue.SETRANGE(Code, SIIDocuments.Period);
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Period Name" := TypeListValue.Description;
                //QUOSII_02_02 -->
                SIIDocuments2.RESET;
                SIIDocuments2.SETRANGE("Document No.", SIIDocuments."Document No.");
                SIIDocuments2.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                SIIDocuments2.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
                SIIDocuments2.SETRANGE("Document Type", DocType);
                SIIDocuments2.SETRANGE("Entry No.", CustLedgerEntry."Entry No.");
                IF SIIDocuments2.ISEMPTY THEN
                    SIIDocuments.INSERT;
            UNTIL DetailedCustLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CreatePurchPayment(VendorLedgerEntry: Record 25; DocType: Option);
    VAR
        VendLedgerEntry2: Record 25;
        SIIDocuments2: Record 7174333;
        Vendor: Record 23;
        SIIDocuments: Record 7174333;
        TypeListValue: Record 7174331;
        DetailedVendorLedgEntry: Record 380;
    BEGIN
        //QuoSII_02_07.begin PAGOS A PROVEEDORES. Incluye RECC Criterio de caja
        Vendor.RESET;
        IF Vendor.GET(VendorLedgerEntry."Vendor No.") THEN;

        DetailedVendorLedgEntry.RESET;
        DetailedVendorLedgEntry.SETRANGE("Applied Vend. Ledger Entry No.", VendorLedgerEntry."Entry No.");
        DetailedVendorLedgEntry.SETFILTER("Initial Document Type", '%1|%2', DetailedVendorLedgEntry."Initial Document Type"::Invoice,
                                                                           DetailedVendorLedgEntry."Initial Document Type"::Bill);
        DetailedVendorLedgEntry.SETRANGE("QuoSII Exported", FALSE);
        DetailedVendorLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DetailedVendorLedgEntry.FINDSET THEN
            REPEAT
                CLEAR(SIIDocuments);
                VendLedgerEntry2.GET(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                SIIDocuments.INIT;
                SIIDocuments."Cust/Vendor No." := VendorLedgerEntry."Vendor No.";
                SIIDocuments."Cust/Vendor Name" := Vendor.Name;
                SIIDocuments."Document Type" := DocType;
                SIIDocuments.Year := DATE2DMY(VendorLedgerEntry."Posting Date", 3);
                SIIDocuments.Period := FORMAT(DATE2DMY(VendorLedgerEntry."Posting Date", 2));
                SIIDocuments."VAT Registration No." := Vendor."VAT Registration No.";
                //SIIDocuments."Document No." := VendLedgerEntry2."External Document No."; //1901-
                SIIDocuments."Document No." := EliminarEspacios(VendLedgerEntry2."External Document No."); //1901+
                SIIDocuments."Invoice Amount" := ABS(DetailedVendorLedgEntry."Amount (LCY)");
                SIIDocuments."SII Entity" := VendorLedgerEntry."QuoSII Entity";//QuoSII_1.4.02.042

                //JAV 07/06/22: - QB 1.06.09 Para pagos no se debe usar el Auto Date
                //QuoSII.1.3.03.006.begin
                //IF VendLedgerEntry2."QuoSII Use Auto Date" THEN
                //  SIIDocuments."Posting Date" := VendLedgerEntry2."QuoSII Auto Posting Date"
                //ELSE
                //QuoSII.1.3.03.006.end

                SIIDocuments."Posting Date" := VendLedgerEntry2."Document Date";//QuoSII_1.4.0.013
                SIIDocuments."Document Date" := VendorLedgerEntry."Document Date";
                SIIDocuments."Medio Cobro/Pago" := VendorLedgerEntry."QuoSII Medio Pago";
                SIIDocuments.CuentaMedioCobro := VendorLedgerEntry."QuoSII CuentaMedioPago";
                SIIDocuments."Entry No." := VendorLedgerEntry."Entry No.";
                TypeListValue.RESET;
                TypeListValue.SETRANGE(Type, TypeListValue.Type::Period);
                TypeListValue.SETRANGE(Code, SIIDocuments.Period);
                IF TypeListValue.FINDFIRST THEN
                    SIIDocuments."Period Name" := TypeListValue.Description;

                //QUOSII_02_02 -->
                SIIDocuments2.RESET;
                SIIDocuments2.SETRANGE("Document Type", DocType);
                SIIDocuments2.SETRANGE("Document No.", SIIDocuments."Document No.");
                SIIDocuments2.SETRANGE("Posting Date", SIIDocuments."Posting Date");
                SIIDocuments2.SETRANGE("VAT Registration No.", SIIDocuments."VAT Registration No.");
                SIIDocuments2.SETRANGE("Entry No.", VendorLedgerEntry."Entry No.");
                IF SIIDocuments2.ISEMPTY THEN
                    SIIDocuments.INSERT;
            UNTIL DetailedVendorLedgEntry.NEXT = 0;
        //QuoSII_02_07.end
    END;

    LOCAL PROCEDURE EliminarEspacios(pCodigo: Text): Code[50];
    VAR
        i: Integer;
        espacioEncontrado: Boolean;
        wSalida: Text;
    BEGIN
        //1901>
        // Primero eliminamos los posibles espacios por delante o atras (trim)
        pCodigo := DELCHR(pCodigo, '<>', ' ');

        // Ahora recorremos la ritras en busca de espacios consecutivos
        espacioEncontrado := FALSE;
        CLEAR(wSalida);
        FOR i := 1 TO STRLEN(pCodigo) DO BEGIN
            IF pCodigo[i] = ' ' THEN BEGIN
                IF espacioEncontrado THEN BEGIN
                    // No a�adimos a la ristra de salida
                END ELSE BEGIN
                    espacioEncontrado := TRUE;
                    wSalida += ' ';
                END;
            END ELSE BEGIN
                espacioEncontrado := FALSE;
                wSalida += FORMAT(pCodigo[i]);
            END;
        END;
        EXIT(COPYSTR(wSalida, 1, 50));
        //<1901
    END;

    PROCEDURE CreateUnrealizedSalesPayment(CustPaymentEntry: Record 21; DocType: Option);
    VAR
        Customer: Record 18;
        SIIDocumentInvoice: Record 7174333;
        CustInvoiceEntry: Record 21;
        CustInvoiceEntry2: Record 21;
        DetailedCustLedgEntry: Record 379;
        DtldCustLedgEntry1: Record 379;
        DtldCustLedgEntry2: Record 379;
    BEGIN
        //JAV 08/09/22: - QuoSII 1.06.12 Se contemplas mas formas de obtener el registro original si no se encuentra directamente

        Customer.GET(CustPaymentEntry."Customer No.");

        //Esto busca cuando el pago liquida a la factura en el mismo movimiento detallado, lo encontramos directamente
        DetailedCustLedgEntry.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
        DetailedCustLedgEntry.SETRANGE("Applied Cust. Ledger Entry No.", CustPaymentEntry."Entry No.");
        DetailedCustLedgEntry.SETRANGE("Initial Document Type", DetailedCustLedgEntry."Initial Document Type"::Invoice);
        //DetailedCustLedgEntry.SETRANGE("SII Exported", TRUE);
        DetailedCustLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DetailedCustLedgEntry.FINDSET THEN BEGIN
            REPEAT
                //. Buscamos el movimiento de cliente de la factura liquidada
                CustInvoiceEntry.GET(DetailedCustLedgEntry."Cust. Ledger Entry No.");

                //. Buscamos el documento SII de la factura
                SIIDocumentInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type"::FE);
                SIIDocumentInvoice.SETRANGE("Document No.", CustInvoiceEntry."Document No.");
                SIIDocumentInvoice.SETRANGE("VAT Registration No.", Customer."VAT Registration No.");
                SIIDocumentInvoice.SETRANGE("Posting Date", CustInvoiceEntry."Posting Date");
                SIIDocumentInvoice.SETRANGE("Entry No.", CustInvoiceEntry."Entry No.");
                IF SIIDocumentInvoice.FINDFIRST THEN
                    ProcessUnrealizedPayment(CustPaymentEntry."Posting Date", CustPaymentEntry."Entry No.", CustPaymentEntry."QuoSII Entity",
                                             CustInvoiceEntry, SIIDocumentInvoice, DetailedCustLedgEntry."Amount (LCY)", DocType);
            UNTIL DetailedCustLedgEntry.NEXT = 0;
        END ELSE BEGIN
            //JAV 08/09/22: - QuoSII 1.06.12 Se contemplas mas formas de obtener el registro original. Ahora hay que buscarlo movi�ndose por los registros detallados
            CustInvoiceEntry.RESET;
            DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
            DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.", CustPaymentEntry."Entry No.");
            DtldCustLedgEntry1.SETRANGE(Unapplied, FALSE);
            IF DtldCustLedgEntry1.FINDFIRST THEN
                REPEAT
                    IF DtldCustLedgEntry1."Cust. Ledger Entry No." = DtldCustLedgEntry1."Applied Cust. Ledger Entry No." THEN BEGIN
                        DtldCustLedgEntry2.INIT;
                        DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
                        DtldCustLedgEntry2.SETRANGE(
                          "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                        DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                        DtldCustLedgEntry2.SETRANGE(Unapplied, FALSE);
                        IF DtldCustLedgEntry2.FINDFIRST THEN
                            REPEAT
                                IF DtldCustLedgEntry2."Cust. Ledger Entry No." <> DtldCustLedgEntry2."Applied Cust. Ledger Entry No." THEN BEGIN
                                    CustInvoiceEntry.SETCURRENTKEY("Entry No.");
                                    CustInvoiceEntry.SETRANGE("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                    IF CustInvoiceEntry.FINDFIRST THEN
                                        CustInvoiceEntry.MARK(TRUE);
                                END;
                            UNTIL DtldCustLedgEntry2.NEXT = 0;
                    END ELSE BEGIN
                        CustInvoiceEntry.SETCURRENTKEY("Entry No.");
                        CustInvoiceEntry.SETRANGE("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                        IF CustInvoiceEntry.FINDFIRST THEN
                            CustInvoiceEntry.MARK(TRUE);
                    END;
                UNTIL DtldCustLedgEntry1.NEXT = 0;
            CustInvoiceEntry.MARKEDONLY(TRUE);
            CustInvoiceEntry.FINDFIRST;
            //Todo esto para obtener el n�mero del documento, ahora busco el mov. de la propia factura, que es el que debo utilizar
            IF NOT (CustInvoiceEntry."Document Type" IN [CustInvoiceEntry."Document Type"::Invoice, CustInvoiceEntry."Document Type"::"Credit Memo"]) THEN BEGIN
                CustInvoiceEntry2.RESET;
                CustInvoiceEntry2.SETCURRENTKEY("Document No.");
                CustInvoiceEntry2.SETRANGE("Document No.", CustInvoiceEntry."Document No.");
                CustInvoiceEntry2.SETRANGE("Posting Date", CustInvoiceEntry."Posting Date");
                CustInvoiceEntry2.FINDFIRST;
                CustInvoiceEntry := CustInvoiceEntry2;
            END;

            //. Buscamos el documento SII de la factura
            SIIDocumentInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type"::FE);
            SIIDocumentInvoice.SETRANGE("Document No.", CustInvoiceEntry."Document No.");
            SIIDocumentInvoice.SETRANGE("VAT Registration No.", Customer."VAT Registration No.");
            SIIDocumentInvoice.SETRANGE("Posting Date", CustInvoiceEntry."Posting Date");
            SIIDocumentInvoice.SETRANGE("Entry No.", CustInvoiceEntry."Entry No.");
            IF SIIDocumentInvoice.FINDFIRST THEN
                ProcessUnrealizedPayment(CustPaymentEntry."Posting Date", CustPaymentEntry."Entry No.", CustPaymentEntry."QuoSII Entity",
                                          CustInvoiceEntry, SIIDocumentInvoice, DetailedCustLedgEntry."Amount (LCY)", DocType);
        END;
    END;

    LOCAL PROCEDURE ProcessUnrealizedPayment(pDate: Date; pEntryNo: Integer; pEntity: Code[20]; CustInvoiceEntry: Record 21; SIIDocumentInvoice: Record 7174333; PaymentAmount: Decimal; DocType: Option);
    VAR
        SIIDocumentNew: Record 7174333;
        SIIDocumentMod: Record 7174333;
        SIIDocumentAux: Record 7174333;
        SIIDocumentLineInvoice: Record 7174334;
        SIIDocumentLineNew: Record 7174334;
        VATEntry: Record 254;
        TypeListValue: Record 7174331;
    BEGIN
        //. Creamos los SII Document para los cobros de facturas con IVA diferido del tipo 14, a partir del SII Document de la factura original

        //JAV 22/07/21: - QuoSII 1.5w Si ya hay un movimiento de tipo F+01 para ese documento (se crea al liberar un IVA diferido y tambi�n en el pago) no creo este movimiento
        SIIDocumentNew.RESET;
        SIIDocumentNew.SETRANGE("Document Type", SIIDocumentNew."Document Type"::FE);
        SIIDocumentNew.SETRANGE("Document No.", SIIDocumentInvoice."Document No.");
        SIIDocumentNew.SETRANGE("VAT Registration No.", SIIDocumentInvoice."VAT Registration No.");
        SIIDocumentNew.SETRANGE("Register Type", COAP_F);  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian 'C+14', 'F+01' y 'C-14' por contantes COAP_P, COAP_F y COAP_M
        IF (SIIDocumentNew.ISEMPTY) THEN BEGIN
            SIIDocumentNew.TRANSFERFIELDS(SIIDocumentInvoice);
            SIIDocumentNew."Document Type" := SIIDocumentNew."Document Type"::FE;
            SIIDocumentNew.Year := DATE2DMY(pDate, 3);
            SIIDocumentNew.Period := FORMAT(DATE2DMY(pDate, 2));
            SIIDocumentNew."Period Name" := GetTypeValueDescription(TypeListValue.Type::Period, SIIDocumentNew.Period);
            SIIDocumentNew."Invoice Amount" := ABS(PaymentAmount);
            SIIDocumentNew."Posting Date" := pDate;
            SIIDocumentNew."Document Date" := pDate;
            SIIDocumentNew."Shipping Date" := pDate;
            SIIDocumentNew."Entry No." := pEntryNo;
            SIIDocumentNew."SII Entity" := pEntity;
            SIIDocumentNew.VALIDATE("Special Regime", '01');
            SIIDocumentNew.Modified := FALSE;
            SIIDocumentNew."Is Emited" := FALSE;
            SIIDocumentNew.Status := SIIDocumentNew.Status::" ";
            SIIDocumentNew."AEAT Status" := '';
            SIIDocumentNew."Invoice Amount" := SIIDocumentInvoice."Invoice Amount";
            SIIDocumentNew."Register Type" := COAP_F;  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian 'C+14', 'F+01' y 'C-14' por contantes COAP_P, COAP_F y COAP_M
                                                       //JAV 30/06/21 Si ya existe el registro F+01 nos saltamos su creaci�n de nuevo.
            IF NOT SIIDocumentNew.INSERT THEN
                EXIT;

            //. Transferir las l�neas del documento original al nuevo
            SIIDocumentLineInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type");
            SIIDocumentLineInvoice.SETRANGE("Document No.", SIIDocumentInvoice."Document No.");
            SIIDocumentLineInvoice.SETRANGE("VAT Registration No.", SIIDocumentInvoice."VAT Registration No.");
            SIIDocumentLineInvoice.SETRANGE("Entry No.", SIIDocumentInvoice."Entry No.");
            SIIDocumentLineInvoice.SETRANGE("Register Type", SIIDocumentInvoice."Register Type");
            IF SIIDocumentLineInvoice.FINDSET() THEN BEGIN
                REPEAT
                    SIIDocumentLineNew.TRANSFERFIELDS(SIIDocumentLineInvoice);
                    SIIDocumentLineNew."Document Type" := SIIDocumentNew."Document Type";
                    SIIDocumentLineNew."Entry No." := SIIDocumentNew."Entry No.";
                    SIIDocumentLineNew."Register Type" := SIIDocumentNew."Register Type";
                    SIIDocumentLineNew.INSERT;
                UNTIL SIIDocumentLineInvoice.NEXT = 0;
            END;

            //. Actualizamos el importe de la factura tras crear las l�neas para que no se altere
            SIIDocumentNew."Invoice Amount" := SIIDocumentInvoice."Invoice Amount";
            SIIDocumentNew.MODIFY;
        END;

        //JAV 13/05/21: 1.5k Crear un nuevo documento de tipo cobro para la modificaci�n del tipo 14 original
        //                   TO-DO Esto solo permite un cobro total de la factura, no hay forma de hacer cobros parciales ya que el tipo 14 se ha
        //                         subido por la propia factura, no podemos subir la factura dos veces con dos importes, ni podemos modificar una
        //                         factura ya subida con otro importe, ya que realmente la factura es una sola. Todo esto viene de que el tipo 14
        //                         no es una factura, es la certificaci�n, pero si no se emite la factura junto a la certificaci�n no se puede cobrar
        //                         en un organismo publico.

        //JAV 22/07/21: - QuoSII 1.5w Si ya hay un movimiento de tipo C-14 para ese documento (se crea al liberar un IVA diferido y tambi�n en el pago) no creo este movimiento
        SIIDocumentMod.RESET;
        SIIDocumentMod.SETRANGE("Document Type", SIIDocumentMod."Document Type"::CE);
        SIIDocumentMod.SETRANGE("Document No.", SIIDocumentInvoice."Document No.");
        SIIDocumentMod.SETRANGE("VAT Registration No.", SIIDocumentInvoice."VAT Registration No.");
        SIIDocumentMod.SETRANGE("Register Type", COAP_M);    //JAV 09/05/22: - QuoSII 1.06.07 Se cambian 'C+14', 'F+01' y 'C-14' por contantes COAP_P, COAP_F y COAP_M
        IF (SIIDocumentMod.ISEMPTY) THEN BEGIN
            SIIDocumentMod.TRANSFERFIELDS(SIIDocumentInvoice);
            SIIDocumentMod."Document Type" := SIIDocumentMod."Document Type"::CE;    //JAV El tipo para el cobro de factura debe ser Cobro de emitidas
            SIIDocumentMod."Posting Date" := pDate;                                 //JAV En la fecha del cobro
            SIIDocumentMod."Shipping Date" := pDate;                                 //JAV 12/05/22: - QuoSII 1.06.07 La fecha de operaci�n es la del cobro, no la de vencimiento original
            SIIDocumentMod.Status := SIIDocumentMod.Status::Modificada;     //Marcamos el documento del tipo 14 nuevo como modificado
            SIIDocumentMod."Invoice Amount" := 0;
            SIIDocumentMod."Is Emited" := FALSE;
            SIIDocumentMod."AEAT Status" := '';
            SIIDocumentMod."Register Type" := COAP_M;  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian 'C+14', 'F+01' y 'C-14' por contantes COAP_P, COAP_F y COAP_M
            SIIDocumentMod.INSERT;

            //. Buscamos los SII Document Line originales para crear los SII Document line del pago
            SIIDocumentLineInvoice.SETRANGE("Document Type", SIIDocumentInvoice."Document Type");
            SIIDocumentLineInvoice.SETRANGE("Document No.", SIIDocumentInvoice."Document No.");
            SIIDocumentLineInvoice.SETRANGE("VAT Registration No.", SIIDocumentInvoice."VAT Registration No.");
            SIIDocumentLineInvoice.SETRANGE("Entry No.", SIIDocumentInvoice."Entry No.");
            SIIDocumentLineInvoice.SETRANGE("Register Type", SIIDocumentInvoice."Register Type");
            IF SIIDocumentLineInvoice.FINDSET() THEN BEGIN
                REPEAT
                    SIIDocumentLineNew.TRANSFERFIELDS(SIIDocumentLineInvoice);
                    SIIDocumentLineNew."Document Type" := SIIDocumentMod."Document Type";
                    SIIDocumentLineNew."Entry No." := pEntryNo;
                    SIIDocumentLineNew."VAT Base" := 0; //- VATEntry."Remaining Unrealized Base";          JAV 30/06/21 No puede tener cobros parciales por la forma de hacerlo
                    SIIDocumentLineNew."VAT Amount" := 0; //- VATEntry."Remaining Unrealized Amount";
                    SIIDocumentLineNew."Entry No." := SIIDocumentMod."Entry No.";
                    SIIDocumentLineNew."Register Type" := SIIDocumentMod."Register Type";
                    SIIDocumentLineNew.INSERT;
                UNTIL SIIDocumentLineInvoice.NEXT = 0;
            END;

            //. Actualizamos el importe de la factura tras crear las l�neas para que no se altere
            SIIDocumentMod."Invoice Amount" := 0;
            SIIDocumentMod.MODIFY;
        END;
    END;

    PROCEDURE GetTypeValueDescription(TypeValue: Integer; TypeValueCode: Code[20]): Text;
    VAR
        TypeListValue: Record 7174331;
    BEGIN
        TypeListValue.RESET;
        TypeListValue.SETRANGE(Type, TypeValue);
        TypeListValue.SETRANGE(Code, TypeValueCode);
        IF TypeListValue.FINDFIRST THEN
            EXIT(TypeListValue.Description);
    END;

    LOCAL PROCEDURE FindApplnEntriesDtldtCustLedgEntry(CustLedgEntry: Record 21): Integer;
    VAR
        DtldCustLedgEntry1: Record 379;
        DtldCustLedgEntry2: Record 379;
        CustLedgEntry2: Record 21;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
    BEGIN
        //JAV 11/05/21: - QuoSII 1.5k Esta funci�n busca de un pago la factura original, si es de tipo 14 retorna el n�mero del movimiento que se paga, si no cero
        //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes. Se a�aden cobros tipo 07 de criterio de caja

        DtldCustLedgEntry1.RESET;
        DtldCustLedgEntry1.SETFILTER("Cust. Ledger Entry No.", '<>%1', CustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SETRANGE("Applied Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        IF DtldCustLedgEntry1.FINDFIRST THEN BEGIN
            CustLedgEntry.GET(DtldCustLedgEntry1."Cust. Ledger Entry No.");
            IF (SalesInvoiceHeader.GET(CustLedgEntry."Document No.")) THEN
                IF (SalesInvoiceHeader."QuoSII Sales Special Regimen" IN [RECC, COAP]) THEN  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes. Se a�aden cobros tipo 07 de criterio de caja
                    EXIT(DtldCustLedgEntry1."Cust. Ledger Entry No.")
                ELSE IF (SalesCrMemoHeader.GET(CustLedgEntry."Document No.")) THEN
                    IF (SalesCrMemoHeader."QuoSII Sales Special Regimen" IN [RECC, COAP]) THEN  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes. Se a�aden cobros tipo 07 de criterio de caja
                        EXIT(DtldCustLedgEntry1."Cust. Ledger Entry No.");
        END;

        EXIT(0);
    END;

    LOCAL PROCEDURE FindApplnEntriesDtldtVendLedgEntry(VendLedgEntry: Record 25): Integer;
    VAR
        DetailedVendorLedgEntry1: Record 380;
        DetailedVendorLedgEntry2: Record 380;
        VendorLedgerEntry1: Record 25;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
    BEGIN
        //JAV 11/05/21: - QuoSII 1.5k Esta funci�n busca de un pago la factura original, si es de tipo 07 retorna el n�mero del movimiento que se paga, si no cero
        //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes.

        DetailedVendorLedgEntry1.RESET;
        DetailedVendorLedgEntry1.SETFILTER("Vendor Ledger Entry No.", '<>%1', VendLedgEntry."Entry No.");
        DetailedVendorLedgEntry1.SETRANGE("Applied Vend. Ledger Entry No.", VendLedgEntry."Entry No.");
        IF DetailedVendorLedgEntry1.FINDFIRST THEN BEGIN
            VendLedgEntry.GET(DetailedVendorLedgEntry1."Vendor Ledger Entry No.");
            IF (PurchInvHeader.GET(VendLedgEntry."Document No.")) THEN
                IF (PurchInvHeader."QuoSII Purch Special Regimen" = RECC) THEN  // RECC Criterio de caja  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes. Se contemplan los pagos con Criterio de Caja
                    EXIT(DetailedVendorLedgEntry1."Vendor Ledger Entry No.")
                ELSE IF (PurchCrMemoHdr.GET(VendLedgEntry."Document No.")) THEN
                    IF (PurchCrMemoHdr."QuoSII Purch Special Regimen" = RECC) THEN  // RECC Criterio de caja  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes. Se contemplan los pagos con Criterio de Caja
                        EXIT(DetailedVendorLedgEntry1."Vendor Ledger Entry No.");
        END;

        EXIT(0);
    END;

    LOCAL PROCEDURE AdjustDates(FromDate: Date; ToDate: Date);
    VAR
        QuoSIISetup: Record 79;
    BEGIN
        //JAV 15/04/21: - QuoSII 1.5f bloquear la fecha inicial de documentos que suben al SII.
        QuoSIISetup.GET;

        //FirstDate indica la minima fecha en la que subir
        IF (FromDate < QuoSIISetup."QuoSII First date") THEN
            FirstDate := QuoSIISetup."QuoSII First date"
        ELSE
            FirstDate := FromDate;

        //WDFirst indica la minima fecha en la que subir si no se indica otra, 4 d�as antes de WorkDate pero con la fecha m�nima de env�o
        WDFirst := CALCDATE('<-4D>', WORKDATE);
        IF (WDFirst < QuoSIISetup."QuoSII First date") THEN
            WDFirst := QuoSIISetup."QuoSII First date";

        //TDFirst indica la minima fecha en la que subir si no se indica otra, 4 d�as antes de Today pero con la fecha m�nima de env�o
        TDFirst := CALCDATE('<-4D>', TODAY);
        IF (TDFirst < QuoSIISetup."QuoSII First date") THEN
            TDFirst := QuoSIISetup."QuoSII First date";

        //JAV fin
    END;

    LOCAL PROCEDURE ProcessCustomerLine(VATType: Option "Sujeta","NoSujeta","Exenta","NoSujetaGL"; DocType: Option; SIIDocument: Record 7174333; CustLedgEntry: Record 21; VATEntry: Record 254; GenProductPostingGroup: Record 251; VATPostingSetup: Record 325; pAmount: Decimal; VAR errorInsert: Boolean);
    VAR
        SIIDocumentLine: Record 7174334;
    BEGIN
        //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y actualizar l�neas de cliente. Se usan siempre los datos de la cabecera en las l�neas

        //Mirar si existe el registro
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document No.", SIIDocument."Document No.");        //QuoSII.B9.begin
        SIIDocumentLine.SETRANGE("Document Type", DocType);
        SIIDocumentLine.SETRANGE("VAT Registration No.", SIIDocument."VAT Registration No.");        //-QUO PEL
        SIIDocumentLine.SETRANGE("Entry No.", SIIDocument."Entry No.");
        SIIDocumentLine.SETRANGE("Register Type", SIIDocument."Register Type");//JAV
                                                                               //QuoSII.001.begin
        IF GenProductPostingGroup."QuoSII Type" = GenProductPostingGroup."QuoSII Type"::Servicios THEN
            SIIDocumentLine.SETRANGE(Servicio, TRUE)
        ELSE
            SIIDocumentLine.SETRANGE(Bienes, TRUE);
        //QuoSII.001.end

        CASE VATType OF
            VATType::Sujeta:       //Sujeta, no Exenta
                BEGIN
                    SIIDocumentLine.SETRANGE("No Taxable VAT", FALSE);
                    SIIDocumentLine.SETRANGE(Exent, FALSE);
                    SIIDocumentLine.SETRANGE("% VAT", VATEntry."VAT %");
                    SIIDocumentLine.SETRANGE("% RE", VATEntry."EC %");
                END;
            VATType::NoSujeta, VATType::NoSujetaGL:       //No Sujeta, no Exenta
                BEGIN
                    SIIDocumentLine.SETRANGE("No Taxable VAT", TRUE);
                END;
            VATType::Exenta:         //Exenta
                BEGIN
                    SIIDocumentLine.SETRANGE("No Taxable VAT", FALSE);
                    SIIDocumentLine.SETRANGE(Exent, TRUE);
                END;
        END;

        //Si existe, modificamos
        IF SIIDocumentLine.FINDFIRST THEN BEGIN
            CASE VATType OF
                VATType::Sujeta:       //Sujeta, no Exenta
                    BEGIN
                        CustomerUpdateDocumentLine(SIIDocumentLine, VATEntry, SIIDocument."Special Regime", FALSE); //PSM 25/02/2021 +

                        IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            IF SIIDocumentLine."No Exent Type" = 'S1' THEN
                                SIIDocumentLine."No Exent Type" := 'S3';
                        END ELSE BEGIN
                            IF SIIDocumentLine."No Exent Type" = 'S2' THEN
                                SIIDocumentLine."No Exent Type" := 'S3';
                        END;
                    END;
                VATType::NoSujeta:       //No Sujeta, no Exenta
                    BEGIN
                        //QuoSII_1.4.02.042.begin
                        CASE SIIDocumentLine."SII Entity" OF
                            'AEAT':
                                BEGIN
                                    IF VATPostingSetup."QuoSII No VAT Type" = '7_14_OTROS' THEN
                                        SIIDocumentLine.ImpArt7_14_Otros += -pAmount;
                                    IF VATPostingSetup."QuoSII No VAT Type" = 'TAI' THEN
                                        SIIDocumentLine.ImporteTAIReglasLocalizacion += -pAmount;
                                END;
                            'ATCN':
                                BEGIN
                                    //QuoSII_1.4.02.042.23.begin
                                    //IF VATPostingSetup."No VAT Type" = '9_Otros' THEN
                                    IF VATPostingSetup."QuoSII No VAT Type" = '7_14_OTROS' THEN
                                        //QuoSII_1.4.02.042.23.end
                                        SIIDocumentLine.ImpArt7_14_Otros += -pAmount;
                                    IF VATPostingSetup."QuoSII No VAT Type" = 'TAI' THEN
                                        SIIDocumentLine.ImporteTAIReglasLocalizacion += -pAmount;
                                END;
                        END;
                        //QuoSII_1.4.02.042.end
                    END;
                VATType::Exenta:  //Exentas
                    BEGIN
                        SIIDocumentLine."VAT Base" += (-VATEntry.Base);
                        SIIDocumentLine."Exent Type" := VATPostingSetup."QuoSII Exent Type"; //QuoSII_1.4.94.999
                    END;
                VATType::NoSujetaGL:    //No sujeta que proviene de GLEntry, si hay un registro ya con estos datos salimos, no sumamos
                    EXIT;
            END;

            SIIDocumentLine.MODIFY;
        END ELSE BEGIN  //No existe, insertamos
            SIIDocumentLine.INIT;
            SIIDocumentLine."SII Entity" := SIIDocument."SII Entity";//QuoSII_1.4.02.042
                                                                     //QuoSII.B9.begin
            SIIDocumentLine."Document No." := SIIDocument."Document No.";
            //QuoSII.B9.end
            SIIDocumentLine."VAT Registration No." := SIIDocument."VAT Registration No.";
            SIIDocumentLine."Document Type" := DocType;

            //QuoSII.001.begin
            IF GenProductPostingGroup."QuoSII Type" = GenProductPostingGroup."QuoSII Type"::Servicios THEN
                SIIDocumentLine.Servicio := TRUE
            ELSE
                SIIDocumentLine.Bienes := TRUE;
            //QuoSII.001.end
            //QuoSII_02_07.begin
            SIIDocumentLine."Entry No." := CustLedgEntry."Entry No.";
            SIIDocumentLine."Register Type" := SIIDocument."Register Type";
            //QuoSII_02_07.end

            CASE VATType OF
                VATType::Sujeta:       //Sujeta, no Exenta
                    BEGIN
                        SIIDocumentLine."Inversión Sujeto Pasivo" := (VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Reverse Charge VAT");
                        IF SIIDocumentLine."Inversión Sujeto Pasivo" THEN
                            SIIDocumentLine."No Exent Type" := 'S2'
                        ELSE
                            SIIDocumentLine."No Exent Type" := 'S1';

                        SIIDocumentLine.Exent := FALSE;
                        SIIDocumentLine."Exent Type" := '';
                        SIIDocumentLine."No Taxable VAT" := FALSE;

                        SIIDocumentLine."% VAT" := VATEntry."VAT %";
                        SIIDocumentLine."% RE" := VATEntry."EC %";

                        CustomerUpdateDocumentLine(SIIDocumentLine, VATEntry, SIIDocument."Special Regime", TRUE); //+2101

                        SIIDocumentLine.ImpArt7_14_Otros := 0;
                        SIIDocumentLine.ImporteTAIReglasLocalizacion := 0;
                    END;
                VATType::NoSujeta, VATType::NoSujetaGL:       //No Sujeta, no Exenta    JAV 10/06/22: - QuoSII 1.06.09 Unificar No Sujeta
                    BEGIN
                        SIIDocumentLine."Inversión Sujeto Pasivo" := FALSE;
                        SIIDocumentLine."No Exent Type" := '';
                        SIIDocumentLine.Exent := FALSE;
                        SIIDocumentLine."Exent Type" := '';
                        SIIDocumentLine."No Taxable VAT" := TRUE;
                        SIIDocumentLine."% VAT" := 0;
                        SIIDocumentLine."% RE" := 0;
                        SIIDocumentLine."VAT Base" := 0;
                        SIIDocumentLine."VAT Amount" := 0;
                        SIIDocumentLine."RE Amount" := 0;

                        //QuoSII_1.4.02.042.begin
                        CASE SIIDocumentLine."SII Entity" OF
                            'AEAT':
                                BEGIN
                                    IF VATPostingSetup."QuoSII No VAT Type" = '7_14_OTROS' THEN
                                        SIIDocumentLine.ImpArt7_14_Otros := -pAmount;
                                    IF VATPostingSetup."QuoSII No VAT Type" = 'TAI' THEN
                                        SIIDocumentLine.ImporteTAIReglasLocalizacion := -pAmount;
                                END;
                            'ATCN':
                                BEGIN
                                    //QuoSII_1.4.02.042.23.begin
                                    //IF VATPostingSetup."No VAT Type" = '9_Otros' THEN
                                    IF VATPostingSetup."QuoSII No VAT Type" = '7_14_OTROS' THEN
                                        //QuoSII_1.4.02.042.23.end
                                        SIIDocumentLine.ImpArt7_14_Otros := -pAmount;
                                    IF VATPostingSetup."QuoSII No VAT Type" = 'TAI' THEN
                                        SIIDocumentLine.ImporteTAIReglasLocalizacion := -pAmount;
                                END;
                        END;
                        //QuoSII_1.4.02.042.end
                    END;
                VATType::Exenta: //Exentas
                    BEGIN
                        SIIDocumentLine."Inversión Sujeto Pasivo" := FALSE;
                        SIIDocumentLine."No Exent Type" := '';
                        SIIDocumentLine.Exent := TRUE;
                        //QuoSII_1.4.94.999.begin
                        //SIIDocumentLine."No Exent Type" := '';
                        SIIDocumentLine."Exent Type" := VATPostingSetup."QuoSII Exent Type";
                        //QuoSII_1.4.94.999.end
                        //QuoSII.001.begin
                        SIIDocumentLine."No Taxable VAT" := FALSE;
                        SIIDocumentLine."% VAT" := 0;
                        SIIDocumentLine."% RE" := 0;
                        SIIDocumentLine."VAT Base" := (-VATEntry.Base);
                        SIIDocumentLine."VAT Amount" := 0;
                        SIIDocumentLine."RE Amount" := 0;
                        SIIDocumentLine.ImpArt7_14_Otros := 0;
                        SIIDocumentLine.ImporteTAIReglasLocalizacion := 0;
                    END;
            END;

            //QUOSII_02_03 ------->
            IF NOT SIIDocumentLine.INSERT THEN
                errorInsert := TRUE;  //Quosii.B9.
        END;
    END;

    LOCAL PROCEDURE ProcessVendorLine(VATType: Option "Sujeta","NoSujeta","Exenta","NoSujetaGL"; DocType: Option; SIIDocument: Record 7174333; VendorLedgerEntry: Record 25; VATEntry: Record 254; VATPostingSetup: Record 325; pAmount: Decimal; VAR errorInsert: Boolean; ISP: Boolean);
    VAR
        SIIDocumentLine: Record 7174334;
    BEGIN
        //JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y actualizar l�neas de proveedores. Se usan siempre los datos de la cabecera en las l�neas

        //Mirar si existe el registro
        SIIDocumentLine.RESET;
        SIIDocumentLine.SETRANGE("Document No.", SIIDocument."Document No.");        //QuoSII.B9.begin
        SIIDocumentLine.SETRANGE("Document Type", DocType);
        SIIDocumentLine.SETRANGE("VAT Registration No.", SIIDocument."VAT Registration No.");        //-QUO PEL
        SIIDocumentLine.SETRANGE("Entry No.", SIIDocument."Entry No.");
        SIIDocumentLine.SETRANGE("Register Type", SIIDocument."Register Type");//JAV
        IF (ISP) THEN
            SIIDocumentLine.SETRANGE("Inversión Sujeto Pasivo", NOT VATPostingSetup."EU Service");
        CASE VATType OF
            VATType::Sujeta:       //Sujeta, no Exenta
                BEGIN
                    SIIDocumentLine.SETRANGE("No Taxable VAT", FALSE);
                    SIIDocumentLine.SETRANGE(Exent, FALSE);
                    SIIDocumentLine.SETRANGE("% VAT", VATEntry."VAT %");
                    SIIDocumentLine.SETRANGE("% RE", VATEntry."EC %");
                END;
            VATType::NoSujeta, VATType::NoSujetaGL:       //No Sujeta, no Exenta
                BEGIN
                    SIIDocumentLine.SETRANGE("No Taxable VAT", TRUE);
                END;
            VATType::Exenta:         //Exenta
                BEGIN
                    SIIDocumentLine.SETRANGE("No Taxable VAT", FALSE);
                    SIIDocumentLine.SETRANGE(Exent, TRUE);
                END;
        END;

        //Si existe, modificamos
        IF SIIDocumentLine.FINDFIRST THEN BEGIN
            CASE VATType OF
                VATType::Sujeta:       //Sujeta, no Exenta
                    BEGIN
                        VendorUpdateDocumentLine(SIIDocumentLine, VATEntry, SIIDocument."Special Regime", VATPostingSetup."VAT Cash Regime", FALSE);
                    END;
                VATType::NoSujeta:       //No Sujeta, no Exenta
                    BEGIN
                        IF SIIDocument."Special Regime" <> '05' THEN
                            SIIDocumentLine."VAT Base" += pAmount;
                    END;
                VATType::Exenta:  //Exentas
                    BEGIN

                    END;
                VATType::NoSujetaGL:    //No sujeta que proviene de GLEntry, si hay un registro ya con estos datos salimos, no sumamos
                                        //Q18700-
                    BEGIN
                        SIIDocumentLine."VAT Base" += pAmount;
                    END;
            //EXIT;
            //Q18700+
            END;

            SIIDocumentLine.MODIFY;
        END ELSE BEGIN  //No existe, insertamos
            SIIDocumentLine.INIT;
            SIIDocumentLine."SII Entity" := SIIDocument."SII Entity";//QuoSII_1.4.02.042
                                                                     //QuoSII.B9.begin
            SIIDocumentLine."Document No." := SIIDocument."Document No.";
            //QuoSII.B9.end
            SIIDocumentLine."VAT Registration No." := SIIDocument."VAT Registration No.";
            SIIDocumentLine."Document Type" := DocType;

            //QuoSII_02_07.begin
            SIIDocumentLine."Entry No." := VendorLedgerEntry."Entry No.";
            SIIDocumentLine."Register Type" := SIIDocument."Register Type";
            //QuoSII_02_07.end

            CASE VATType OF
                VATType::Sujeta:       //Sujeta, no Exenta
                    BEGIN
                        IF (ISP) THEN
                            SIIDocumentLine."Inversión Sujeto Pasivo" := (NOT VATPostingSetup."EU Service")
                        ELSE
                            SIIDocumentLine."Inversión Sujeto Pasivo" := FALSE;

                        SIIDocumentLine."No Exent Type" := 'S1';
                        SIIDocumentLine.Exent := FALSE;
                        SIIDocumentLine."Exent Type" := '';
                        SIIDocumentLine."No Taxable VAT" := FALSE;
                        SIIDocumentLine."% VAT" := VATEntry."VAT %";
                        SIIDocumentLine."% RE" := VATEntry."EC %";

                        VendorUpdateDocumentLine(SIIDocumentLine, VATEntry, SIIDocument."Special Regime", VATPostingSetup."VAT Cash Regime", TRUE);
                    END;
                VATType::NoSujeta, VATType::NoSujetaGL:       //No Sujeta, no Exenta    JAV 10/06/22: - QuoSII 1.06.09 Unificar No Sujeta
                    BEGIN
                        SIIDocumentLine."Inversión Sujeto Pasivo" := FALSE;
                        SIIDocumentLine."No Exent Type" := '';
                        SIIDocumentLine.Exent := FALSE;
                        SIIDocumentLine."Exent Type" := '';
                        SIIDocumentLine."No Taxable VAT" := TRUE;
                        SIIDocumentLine."% VAT" := 0;
                        SIIDocumentLine."% RE" := 0;
                        IF SIIDocument."Special Regime" <> '05' THEN
                            SIIDocumentLine."VAT Base" := pAmount
                        ELSE
                            SIIDocumentLine."VAT Base" := 0;
                        SIIDocumentLine."VAT Amount" := 0;
                        SIIDocumentLine."RE Amount" := 0;

                        //PSM 20/05/21+
                        IF VendorLedgerEntry."QuoSII Purch. Invoice Type" = 'F5' THEN BEGIN
                            IF VATEntry."VAT %" <> 0 THEN
                                SIIDocumentLine."VAT Base" := ROUND(pAmount / (VATEntry."VAT %" / 100), 0.01, '=');
                            SIIDocument."Invoice Amount" := SIIDocumentLine."VAT Base" + SIIDocumentLine."VAT Amount";
                            SIIDocument.MODIFY;
                        END;
                        //PSM 20/05/21-
                    END;
                VATType::Exenta: //Exentas
                    BEGIN
                    END;
            END;

            //QUOSII_02_03 ------->
            IF NOT SIIDocumentLine.INSERT THEN
                errorInsert := TRUE;  //Quosii.B9.
        END;
    END;

    PROCEDURE CustomerUpdateDocumentLine(VAR SIIDocumentLine: Record 7174334; VATEntry: Record 254; SpecialRegime: Code[10]; NewLine: Boolean);
    VAR
        Base: Decimal;
        VAT: Decimal;
        RE: Decimal;
    BEGIN
        //JAV 05/05/22: QuoSII 1.06.07 Unificar y cambios en el c�lculo del importe del cliente seg�n el r�gimen especial

        //Si creamos la l�nea no tiene importes anteriores
        IF NewLine THEN BEGIN
            SIIDocumentLine."VAT Base" := 0;
            SIIDocumentLine."VAT Amount" := 0;
            SIIDocumentLine."RE Amount" := 0;
        END;

        //Base
        //Q19465-
        IF (SpecialRegime <> RECC) AND (SpecialRegime <> COAP) AND (SpecialRegime <> OTS) THEN  //Si no es criterio de caja o certificaciones o Tracto sucesivo
                                                                                                //IF (SpecialRegime <> RECC) AND (SpecialRegime <> COAP) THEN  //Si no es criterio de caja o certificaciones  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                                                                                                //Q19465+
            SIIDocumentLine."VAT Base" += (-VATEntry.Base)
        ELSE
            SIIDocumentLine."VAT Base" += (-VATEntry."Unrealized Base");

        //Para el recargo como se usa la base no depende del r�gimen
        IF (SIIDocumentLine."% RE" <> 0) THEN BEGIN
            SIIDocumentLine."VAT Amount" := ROUND(SIIDocumentLine."VAT Base" * VATEntry."VAT %" / 100, 0.01, '=');
            SIIDocumentLine."RE Amount" := ROUND(SIIDocumentLine."VAT Base" * VATEntry."EC %" / 100, 0.01, '=');
        END ELSE BEGIN
            //Solo IVA
            //Q19465-
            IF (SpecialRegime <> RECC) AND (SpecialRegime <> COAP) AND (SpecialRegime <> OTS) THEN  //Si no es criterio de caja o certificaciones o Tracto sucesivo
                                                                                                    //IF (SpecialRegime <> RECC) AND (SpecialRegime <> COAP) THEN  //Si no es criterio de caja o certificaciones  //JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07' y '14' por contantes
                                                                                                    //Q19465+
                SIIDocumentLine."VAT Amount" += (-VATEntry.Amount)
            ELSE
                SIIDocumentLine."VAT Amount" += (-VATEntry."Unrealized Amount");
        END;
    END;

    LOCAL PROCEDURE VendorUpdateDocumentLine(VAR SIIDocumentLine: Record 7174334; VATEntry: Record 254; SpecialRegime: Code[10]; CashRegime: Boolean; NewLine: Boolean);
    BEGIN
        //JAV 05/05/22: QuoSII 1.06.07 Unificar y cambios en el c�lculo del importe del proveedor seg�n el r�gimen especial

        //Si creamos la l�nea no tiene importes anteriores
        IF NewLine THEN BEGIN
            SIIDocumentLine."VAT Base" := 0;
            SIIDocumentLine."VAT Amount" := 0;
            SIIDocumentLine."RE Amount" := 0;
        END;

        //Base
        IF SpecialRegime = '05' THEN
            SIIDocumentLine."VAT Base" += 0
        ELSE IF CashRegime THEN BEGIN
            SIIDocumentLine."VAT Base" += VATEntry."Unrealized Base";
        END ELSE BEGIN
            SIIDocumentLine."VAT Base" += VATEntry.Base;
        END;

        //Para el recargo como se usa la base no depende del r�gimen
        IF (SIIDocumentLine."% RE" <> 0) THEN BEGIN
            SIIDocumentLine."VAT Amount" := ROUND(SIIDocumentLine."VAT Base" * VATEntry."VAT %" / 100, 0.01, '=');
            SIIDocumentLine."RE Amount" := ROUND(SIIDocumentLine."VAT Base" * VATEntry."EC %" / 100, 0.01, '=');
        END ELSE BEGIN
            //Solo IVA
            IF SpecialRegime = '05' THEN
                SIIDocumentLine."VAT Amount" += 0
            ELSE IF CashRegime THEN
                SIIDocumentLine."VAT Amount" += VATEntry."Unrealized Amount"
            ELSE
                SIIDocumentLine."VAT Amount" += VATEntry.Amount;
        END;
    END;


    /*BEGIN
    /*{
          JAV 26/05/21: - QuoSII 1.5p Nueva CU para crear los documentos y no repetir c�digo, se llama desde los informes 7174332 "SII Import Document" y 7174334 "SII Document Job Queue"
          Q13664 QMD 22/06/21 - Env�o al SII de la factura de r�gimen 14 usando "Liberar IVA clientes"
          Q13694 QMD 23/06/21 - Errores y pendientes de QuoSII
          JAV 30/06/21 Si ya existe el registro F+01 nos saltamos su creaci�n de nuevo.
          PSM 18/08/21: - QsuoSII 1.5z Estaban intercambiados N.Doc y Primer Ticket
          JAV 19/08/21: - QsuoSII 1.5z Ajustes para paso a extensiones
                          - Se elimina el WITH que no se debe usar en extensiones
                          - Se cambia CompanyInformation por QuoSIISetup en los lugares donde se usa para la configuraci�n
          JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
          JAV 04/05/22: - QUOSII 1.06.07 Unificar funciones para crear y modificar registros de l�neas desde clientes y proveedores. Se usan siempre los datos de la cabecera en las l�neas
                                         En documentos exentos que no han generado IVA solo sub�a lineas si ten�a grupo registro de IVA de producto, pero se puede dejar en blanco
                                         Si no existe el grupo registro de producto no dar un error al leerlo
                                         Unificar y cambio en el c�lculo del importe del cliente o proveedor seg�n el r�gimen especial
          JAV 09/05/22: - QuoSII 1.06.07 Se cambian '07', '14', 'C+14', 'F+01', y 'C-14' por las contantes RECC, COAP, COAP_P, COAP_F y COAP_M respectivamente
          JAV 11/05/22: - QuoSII 1.06.07 Se contemplan correctamente los cobros y pagos con Criterio de Caja desde cartera
                                         Si es un movimiento de liquidaci�n de una retenci�n no debe subir al SII
          JAV 07/06/22: - QuoSII 1.06.09 Para cobros RECC usar fecha de documento correctamente. Para pagos RECC no usar fecha autom�tica
          JAV 10/06/22: - QuoSII 1.06.09 Unificar No Sujeta
          JAV 08/09/22: - QuoSII 1.06.12 Se contemplas mas formas de obtener el registro original del tipo 14 si no se encuentra directamente en la liquidaci�n
          JAV 08/09/22: - QuoSII 1.06.13 Se a�aden las operacines de Tracto Sucesivo, creando las constantes OTS_F (T+01), OTS_P (T+15), OTS_M (T-15)
                                         Se maneja el alta de la factura ficticia cuando se emite, y de la real y la baja de la ficticia en su vencimiento o pago
          PSM 04/01/23: - Q18695 A�adir en la b�squeda de mov. no sujetos a IVA el filtro por el campo "QuoSII DUA Compensation" = false
          PSM 09/05/23: - Q19465 Usar Base no realizada e Importe no realizado para calcular operaciones de venta de R�gimen Especial 15
                                 Excluir del c�lculo de IVA No Sujeto las combinaciones marcadas con Dua Compensaci�n
          PSM 22/05/23: - Q18700 Si un documento tiene varias l�neas no sujetas, sumarlas todas
        }
    END.*/
}










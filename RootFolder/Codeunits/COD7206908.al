Codeunit 7206908 "Generate Electronics Payments"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'ASC Files (*.asc)|*.asc|All Files (*.*)|*.*', ESP = 'Archivos TXT (*.txt)|*.txt|Todos los archivos (*.*)|*.*';
        Text001: TextConst ENU = 'ORDENPAGO.ASC', ESP = 'El banco %1 del proveedor %2 no tiene indicado el CCC';
        PaymentOrder: Record 7000020;
        PostedPaymentOrder: Record 7000021;
        CarteraDoc: Record 7000002;
        PostedCarteraDoc: Record 7000003;
        tmpCarteraDoc: Record 7000002 TEMPORARY;
        CompanyInfo: Record 79;
        Vendor: Record 23;
        BankAcc: Record 270;
        VendorBankAccount: Record 288;
        DirPago: Record 7000015;
        PaymentMethod: Record 289;
        Suffix: Record 7000024;
        QBCrearEfectosLinea: Record 7206923;
        DocumentMisc: Codeunit 7000007;
        OutFile: File;
        ExternalFile: Text;
        ToFile: Text;
        OutText: Text;
        DueDate: Date;
        Company_Name: Text;
        Company_Adress: Text;
        VendorName: Text;
        VendorAddress: Text;
        VendorIBAN: Text;
        VendorSWIFT: Text;
        VendorSWIFT2: Text;
        VendorCCC: Text;
        VendorIsNoResident: Text;
        MedioDePago: Text;
        Barrado: Text;
        Generar: Boolean;
        Totales: ARRAY[10] OF Decimal;
        Sufijo: Text;
        TipoIDProv: Text;
        IsConfirming: Boolean;
        gTipoReg: Option "Preparar","Cabecera","Cuerpo","Pie";
        gNro: Code[20];
        gPosted: Boolean;
        gPostingDate: Date;
        gBankAccount: Code[20];
        gCurrency: Code[10];
        gFile: Text;
        gName: Text;
        gHaveOptions: Boolean;
        gChargeDate: Date;
        "--------------------------------- Opciones": Integer;
        PaymentType: Option "Transferencia","Cheque";
        DeliveryDate: Date;
        Type: Option "1:Est ndar","2:Pronto Pago","3:Otros";
        Text002: TextConst ESP = 'El banco %1 del proveedor %2 no tiene indicado el IBAN';
        Text003: TextConst ESP = 'El banco %1 del proveedor %2 no tiene indicado el SWIFT';

    PROCEDURE Launch(pRegNo: Code[20]; pNumber: Integer);
    VAR
        QBElectronicPaymentParams: Page 7207512;
        Fichero: Text;
        Opciones: ARRAY[5] OF Text;
    BEGIN
        //JAV 14/09/21: - QB 1.09.17 Nueva funci�n que lanza el formato, sacando la pantalla de opciones si es necesario.

        CLEAR(Opciones);
        IF (pNumber = 0) OR (GetHaveOptions(pNumber)) THEN BEGIN
            CLEAR(QBElectronicPaymentParams);
            QBElectronicPaymentParams.LOOKUPMODE(TRUE);
            QBElectronicPaymentParams.SetOptions(pNumber);
            IF (QBElectronicPaymentParams.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                QBElectronicPaymentParams.GetOptions(pNumber, Opciones);
                IF (pNumber = 0) THEN
                    MESSAGE('No ha seleccionado un formato');
            END ELSE
                pNumber := 0;
        END;

        IF (pNumber <> 0) THEN
            Generate(pRegNo, pNumber, GetFileTxt(pNumber), Opciones);
    END;

    PROCEDURE ValidateNumber(pNumber: Integer): Boolean;
    VAR
        Opciones: ARRAY[5] OF Text;
    BEGIN
        //JAV 13/09/21: - QB 1.09.17 Nueva funci�n que retorna si el n�mero del formato est� en la lista
        GenerateRegs(gTipoReg::Preparar, pNumber, Opciones, FALSE);
        EXIT(gName <> '');
    END;

    PROCEDURE GetMenuTxt(): Text;
    VAR
        Lista: ARRAY[99] OF Text;
        Name: Text;
        Txt: Text;
        Opciones: ARRAY[5] OF Text;
        i: Integer;
    BEGIN
        //JAV 13/09/21: - QB 1.09.17 Nueva funci�n que retorna la lista de posibles formatos
        Txt := '';
        i := 0;
        REPEAT
            i += 1;
            Name := GetNameTxt(i);
            IF (Name <> '') THEN
                Lista[i] := Name;
        UNTIL (Name = '');

        i := 0;
        REPEAT
            i += 1;
            Txt += Lista[i] + ',';
        UNTIL Lista[i + 1] = '';

        EXIT(COPYSTR(Txt, 1, STRLEN(Txt) - 1));
    END;

    PROCEDURE GetNameTxt(pNumber: Integer): Text;
    VAR
        Txt: Text;
        Opciones: ARRAY[5] OF Text;
        i: Integer;
    BEGIN
        //JAV 13/09/21: - QB 1.09.17 Nueva funci�n que retorna el nombre por defecto del fichero a generar
        GenerateRegs(gTipoReg::Preparar, pNumber, Opciones, FALSE);
        EXIT(gName);
    END;

    PROCEDURE GetFileTxt(pNumber: Integer): Text;
    VAR
        Txt: Text;
        Opciones: ARRAY[5] OF Text;
        i: Integer;
    BEGIN
        //JAV 13/09/21: - QB 1.09.17 Nueva funci�n que retorna el nombre por defecto del fichero a generar
        GenerateRegs(gTipoReg::Preparar, pNumber, Opciones, FALSE);
        EXIT(gFile);
    END;

    PROCEDURE GetHaveOptions(pNumber: Integer): Boolean;
    VAR
        Txt: Text;
        Opciones: ARRAY[5] OF Text;
        i: Integer;
    BEGIN
        //JAV 13/09/21: - QB 1.09.17 Nueva funci�n que retorna si el formato tiene opciones disponibles
        GenerateRegs(gTipoReg::Preparar, pNumber, Opciones, FALSE);
        EXIT(gHaveOptions);
    END;

    PROCEDURE Generate(pRegNo: Code[20]; pNumber: Integer; pFichero: Text; pOpciones: ARRAY[5] OF Text);
    VAR
        Nro: Integer;
    BEGIN
        //General un fichero de pago electr�nico a partir de una orden de pago de un banco.
        // - pNo..........: N�mero de la orden de pago, puede ser sin registrar o registrada
        // - pFichero.....: Nombre del fichero a generar
        // - pOpciones[5] : Opciones del formato generado

        //Preparar el fichero de exportaci�n
        ToFile := pFichero;
        ExternalFile := TEMPORARYPATH + ToFile;
        OutFile.TEXTMODE := TRUE;
        OutFile.WRITEMODE := TRUE;
        OutFile.CREATE(ExternalFile, TEXTENCODING::Windows);

        //Buscamos la orden de pago sin registrar o la registrada con ese n�mero, y guardamos los datos necesarios en variables globales
        IF (PaymentOrder.GET(pRegNo)) THEN BEGIN
            gPosted := FALSE;
            gNro := PaymentOrder."No.";
            gBankAccount := PaymentOrder."Bank Account No.";
            gPostingDate := PaymentOrder."Posting Date";
            gCurrency := PaymentOrder."Currency Code";
        END ELSE IF (PostedPaymentOrder.GET(pRegNo)) THEN BEGIN
            gPosted := TRUE;
            gNro := PostedPaymentOrder."No.";
            gBankAccount := PostedPaymentOrder."Bank Account No.";
            gPostingDate := PostedPaymentOrder."Posting Date";
            gCurrency := PostedPaymentOrder."Currency Code";
        END;

        //Leemos el banco y buscamos el primer sufijo en el banco, si no ponemos 000
        IF (gBankAccount = '') THEN
            ERROR('Debe indicar el banco');
        BankAcc.GET(gBankAccount);
        BankAcc.IBAN := DELCHR(BankAcc.IBAN);     //Quitar espacios del IBAN del banco

        Suffix.RESET;
        Suffix.SETRANGE("Bank Acc. Code", gBankAccount);
        IF Suffix.FINDFIRST THEN
            Sufijo := Suffix.Suffix
        ELSE
            Sufijo := '000';

        //Leo informaci�n de empresa
        CompanyInfo.GET();
        CompanyInfo.TESTFIELD("VAT Registration No.");
        Company_Name := MountTxt(CompanyInfo.Name, CompanyInfo."Name 2");
        Company_Adress := MountTxt(CompanyInfo.Address, CompanyInfo."Address 2");

        //Si es el euro lo informo
        IF (gCurrency = '') THEN
            gCurrency := 'EUR';

        //Por defecto no es confirming, depende del documento que se genere
        IsConfirming := FALSE;

        //Metemos los registros en el temporal
        Nro := 0;

        CarteraDoc.RESET;
        CarteraDoc.SETCURRENTKEY(Type, "Bill Gr./Pmt. Order No.");
        CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
        CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", gNro);
        IF (CarteraDoc.FINDSET(FALSE)) THEN
            REPEAT
                tmpCarteraDoc := CarteraDoc;
                tmpCarteraDoc.INSERT;
            UNTIL (CarteraDoc.NEXT = 0);

        PostedCarteraDoc.RESET;
        PostedCarteraDoc.SETCURRENTKEY(Type, "Bill Gr./Pmt. Order No.");
        PostedCarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
        PostedCarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", gNro);
        IF (PostedCarteraDoc.FINDSET(FALSE)) THEN
            REPEAT
                IF (PostedCarteraDoc.Status <> PostedCarteraDoc.Status::Open) THEN
                    ERROR('Tiene l�neas pagadas o impagadas, no puede volver a generar');
                tmpCarteraDoc.TRANSFERFIELDS(PostedCarteraDoc);
                tmpCarteraDoc.INSERT;
            UNTIL (PostedCarteraDoc.NEXT = 0);

        //Hacemos dos pasadas, la primera cuenta registros, la segunda monta el fichero
        CLEAR(Totales);
        Generar := TRUE;
        REPEAT
            Generar := NOT Generar;
            //Cabecera
            GenerateRegs(gTipoReg::Cabecera, pNumber, pOpciones, Generar);

            tmpCarteraDoc.RESET;
            tmpCarteraDoc.SETCURRENTKEY(Type, "Bill Gr./Pmt. Order No.");
            tmpCarteraDoc.SETRANGE(Type, tmpCarteraDoc.Type::Payable);
            tmpCarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", gNro);
            IF (tmpCarteraDoc.FINDSET(FALSE)) THEN
                REPEAT
                    //Proveedor y Su factura
                    Vendor.GET(tmpCarteraDoc."Account No.");
                    tmpCarteraDoc.CALCFIELDS("External Document No.", "Document Date");

                    //Banco del proveedor
                    VendorIBAN := '';
                    VendorSWIFT := '';
                    VendorCCC := '';
                    //tmpCarteraDoc.TESTFIELD("Cust./Vendor Bank Acc. Code");   //Este control se debe hacer solo si se emplea el IBAN, no siempre
                    IF VendorBankAccount.GET(Vendor."No.", tmpCarteraDoc."Cust./Vendor Bank Acc. Code") THEN BEGIN
                        VendorIBAN := DELCHR(VendorBankAccount.IBAN);
                        // VendorCCC := DELCHR(VendorBankAccount."CCC No.");
                        VendorSWIFT := DELCHR(VendorBankAccount."SWIFT Code");
                    END;

                    //Buscar Direcci�n de Pago
                    DirPago.SETRANGE("Vendor No.", Vendor."No.");
                    IF DirPago.FINDFIRST THEN BEGIN
                        Vendor.Name := DirPago.Name;
                        Vendor."Name 2" := DirPago."Name 2";
                        Vendor.Address := DirPago.Address;
                        Vendor."Address 2" := DirPago."Address 2";
                        Vendor.City := DirPago.City;
                        Vendor."Post Code" := DirPago."Post Code";
                        Vendor."Country/Region Code" := DirPago."Country/Region Code";
                        Vendor."Phone No." := DirPago."Phone No.";
                        Vendor."Fax No." := DirPago."Fax No.";
                        Vendor."E-Mail" := DirPago."E-Mail";
                    END;

                    IF (Vendor."Country/Region Code" = '') THEN
                        Vendor."Country/Region Code" := 'ES';

                    VendorName := MountTxt(Vendor.Name, Vendor."Name 2");
                    VendorAddress := MountTxt(Vendor.Address, Vendor."Address 2");
                    IF (Vendor."Country/Region Code" = 'ES') OR (Vendor."Country/Region Code" = '') OR (Vendor."Country/Region Code" = CompanyInfo."Country/Region Code") THEN
                        VendorIsNoResident := 'N'
                    ELSE
                        VendorIsNoResident := 'S';

                    //Medio de Pago y Barrado
                    PaymentMethod.GET(tmpCarteraDoc."Payment Method Code");
                    IF (PaymentMethod."Bill Type" IN [PaymentMethod."Bill Type"::Check, PaymentMethod."Bill Type"::Receipt]) THEN BEGIN
                        Barrado := 'S';
                        MedioDePago := 'C';
                    END ELSE BEGIN
                        Barrado := ' ';
                        MedioDePago := 'T';
                        IF (tmpCarteraDoc."Transfer Type" <> tmpCarteraDoc."Transfer Type"::National) THEN
                            MedioDePago := 'E';
                    END;

                    // Cuerpo
                    GenerateRegs(gTipoReg::Cuerpo, pNumber, pOpciones, Generar);

                UNTIL (tmpCarteraDoc.NEXT = 0);

            //A�adimos los registros finales
            GenerateRegs(gTipoReg::Pie, pNumber, pOpciones, Generar);
        UNTIL (Generar);

        //Marcar como exportado
        IF (NOT gPosted) THEN BEGIN
            PaymentOrder.GET(gNro);
            PaymentOrder."Elect. Pmts Exported" := TRUE;
            PaymentOrder.Confirming := IsConfirming;                       //JAV 21/09/20: - QB 1.06.15 Marcamos si es un confirming
            PaymentOrder.MODIFY;
        END ELSE BEGIN
            PostedPaymentOrder.GET(gNro);
            PostedPaymentOrder.Confirming := IsConfirming;
            PostedPaymentOrder.MODIFY;
        END;

        //Guardar el fichero
        OutFile.CLOSE;
        DOWNLOAD(ExternalFile, '', 'C:', Text000, ToFile);
    END;

    LOCAL PROCEDURE GenerateRegs(pTipoReg: Option; pNumber: Integer; pOpciones: ARRAY[5] OF Text; pGenerar: Boolean);
    BEGIN
        //JAV 13/09/21: - QB 1.09.17 Se a�ade en cada tipo el nombre del fichero, el nombre del formato y si tiene posibles opciones.

        gFile := '';              //Nombre del fichero a generar
        gName := '';              //Nombre del formato
        gHaveOptions := FALSE;    //Si tiene opciones que deben rellenarse

        IF (pTipoReg = gTipoReg::Preparar) THEN
            pGenerar := FALSE;

        CASE pNumber OF
            1:
                BEGIN //01 (50052) Formato Estandar Confirming
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'Confirming.txt';
                                gName := 'Formato Estandar de Confirming';
                                gHaveOptions := TRUE;
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_01(1, pGenerar, pOpciones);
                                AddReg_01(2, pGenerar, pOpciones);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                IF tmpCarteraDoc."Transfer Type" = tmpCarteraDoc."Transfer Type"::International THEN BEGIN
                                    IF (VendorSWIFT = '') THEN
                                        ERROR(Text003, tmpCarteraDoc."Cust./Vendor Bank Acc. Code", Vendor."No.");
                                    IF (VendorCCC = '') THEN
                                        ERROR(Text001, tmpCarteraDoc."Cust./Vendor Bank Acc. Code", Vendor."No.");
                                    VendorIBAN := '';
                                END ELSE BEGIN
                                    IF (VendorIBAN = '') AND (pOpciones[3] = 'T') THEN
                                        ERROR(Text002, tmpCarteraDoc."Cust./Vendor Bank Acc. Code", Vendor."No.");
                                    VendorSWIFT := '';
                                    VendorCCC := '';
                                END;

                                AddReg_01(3, pGenerar, pOpciones);  //Registros del proveedor
                                AddReg_01(4, pGenerar, pOpciones);
                                AddReg_01(5, pGenerar, pOpciones);

                                //JAV 13/12/21: - QB 1.10.07 Se informa de la fecha de pr¢rroga/aplazamiento/cargo si es de tipo Pronto Pago
                                IF (COPYSTR(pOpciones[2], 1, 1) = '2') THEN //1-Estandar, 2-Pronto Pago, 3-Otros
                                    gChargeDate := tmpCarteraDoc."Due Date"
                                ELSE
                                    gChargeDate := 0D;

                                AddReg_01(6, pGenerar, pOpciones);  //Registro del pago
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_01(7, pGenerar, pOpciones);  //Registro de totales
                            END;
                    END;
                END;
            2:
                BEGIN //02 (50053) Emision Cheque/Pagare Sabadell
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'PAGARES.TXT';
                                gName := 'Emision Cheque/Pagare Sabadell';
                                gHaveOptions := TRUE;
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_02('E', pGenerar, pOpciones);
                                AddReg_02('O', pGenerar, pOpciones);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                IF (pOpciones[1] <> '71') THEN
                                    DueDate := 0D
                                ELSE
                                    DueDate := tmpCarteraDoc."Due Date";
                                AddReg_02('B', pGenerar, pOpciones);
                                AddReg_02('P', pGenerar, pOpciones);
                                AddReg_02('C', pGenerar, pOpciones);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                //No hay pie
                            END;
                    END;
                END;
            3:
                BEGIN //03 (50051) Confirming Bankinter (parece que tambi�n funciona en Banesto)
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingBankinter.txt';
                                gName := 'Confirming Bankinter';
                                gHaveOptions := TRUE;
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_03(3, pGenerar, pOpciones);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_03(6, pGenerar, pOpciones);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_03(8, pGenerar, pOpciones);
                            END;
                    END;
                END;
            4:
                BEGIN //(50054) Confirming Sabadell BS
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingSabadellBS.txt';
                                gName := 'Confirming Sabadell BS';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_04(1, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_04(2, pGenerar);
                                AddReg_04(3, pGenerar);
                                IF (MedioDePago = 'E') THEN
                                    AddReg_04(4, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_04(5, pGenerar);
                            END;
                    END;
                END;
            5:
                BEGIN //(50055) Confirming Bankia 2
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingBankia.txt';
                                gName := 'Confirming Bankia 2';
                                gHaveOptions := TRUE;
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_05('A', pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_05('D', pGenerar);
                                IF (Vendor."E-Mail" <> '') THEN
                                    AddReg_05('F', pGenerar);
                                AddReg_05('P', pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_05('Z', pGenerar);
                            END;
                    END;
                END;
            6:
                BEGIN //(50056) Confirming La Caixa
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingLaCaixa.txt';
                                gName := 'Confirming La Caixa';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_06(1, pGenerar);
                                AddReg_06(2, pGenerar);
                                AddReg_06(3, pGenerar);
                                AddReg_06(4, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_06(10, pGenerar);
                                AddReg_06(43, pGenerar);
                                AddReg_06(44, pGenerar);
                                AddReg_06(45, pGenerar);
                                AddReg_06(46, pGenerar);
                                AddReg_06(11, pGenerar);
                                AddReg_06(12, pGenerar);
                                AddReg_06(13, pGenerar);
                                AddReg_06(14, pGenerar);
                                AddReg_06(15, pGenerar);
                                AddReg_06(16, pGenerar);
                                AddReg_06(17, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_06(8, pGenerar);
                            END;
                    END;
                END;
            7:
                BEGIN //(50057) Confirming Bankia  --> Es el mismo formato que el de La Caixa
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingBankia.txt';
                                gName := 'Confirming Bankia';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_06(1, pGenerar);
                                AddReg_06(2, pGenerar);
                                AddReg_06(3, pGenerar);
                                AddReg_06(4, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_06(10, pGenerar);
                                AddReg_06(43, pGenerar);
                                AddReg_06(44, pGenerar);
                                AddReg_06(45, pGenerar);
                                AddReg_06(46, pGenerar);
                                AddReg_06(11, pGenerar);
                                AddReg_06(12, pGenerar);
                                AddReg_06(13, pGenerar);
                                AddReg_06(14, pGenerar);
                                AddReg_06(15, pGenerar);
                                AddReg_06(16, pGenerar);
                                AddReg_06(17, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_06(8, pGenerar);
                            END;
                    END;
                END;
            8:
                BEGIN //(50058) Confirming BBVA
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingBBVA.txt';
                                gName := 'Confirming BBVA';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_08('C', pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_08('F', pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                //No hay pie
                            END;
                    END;
                END;
            9:
                BEGIN //(50059) Confirming Deutsche Bank
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingDB.txt';
                                gName := 'Confirming Deutsche Bank';
                                gHaveOptions := TRUE;
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_09(3, pGenerar, pOpciones);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_09(6, pGenerar, pOpciones);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_09(8, pGenerar, pOpciones);
                            END;
                    END;
                END;
            10:
                BEGIN //(50060) Confirming Santander 1
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingSantander.txt';
                                gName := 'Confirming Santander 1';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_10('1', pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_10('2', pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_10('3', pGenerar);
                            END;
                    END;
                END;
            11:
                BEGIN //(50061) Confirming Santander 2
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingSantander.txt';
                                gName := 'Confirming Santander 2';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_11('1', pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_11('2', pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_11('3', pGenerar);
                            END;
                    END;
                END;

            //++AMAPALA ELECTRONIC PAYMENTS
            12:
                BEGIN //(50063) Novobanco
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingNovobanco.txt';
                                gName := 'Confirming Novobanco';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_12(1, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_12(2, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_12(3, pGenerar);
                            END;
                    END;
                END;
            13:
                BEGIN //(50064) Ibercaja
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingIbercaja.txt';
                                gName := 'Confirming Ibercaja';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_13(1, pGenerar);
                                AddReg_13(2, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_13(3, pGenerar);
                                AddReg_13(4, pGenerar);
                                AddReg_13(5, pGenerar);
                                AddReg_13(6, pGenerar);
                                AddReg_13(7, pGenerar);
                                AddReg_13(8, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_13(9, pGenerar);
                            END;
                    END;
                END;
            14:
                BEGIN //(50065) Abanca
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingAbanca.txt';
                                gName := 'Confirming Abanca';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_14(1, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_12(2, pGenerar);
                                AddReg_12(3, pGenerar);
                                AddReg_12(4, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_14(5, pGenerar);
                            END;
                    END;
                END;
            15:
                BEGIN //(50066) Liberbank
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingLiberbank.txt';
                                gName := 'Confirming Liberbank';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_15(1, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_15(2, pGenerar);
                                AddReg_15(3, pGenerar);
                                AddReg_15(4, pGenerar);
                                AddReg_15(5, pGenerar);
                                AddReg_15(6, pGenerar);
                                AddReg_15(7, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_15(9, pGenerar);
                            END;
                    END;
                END;
            16:
                BEGIN //(50067) Banco Coperativo
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingBancoCoperativo.txt';
                                gName := 'Confirming Bco. Cooperativo';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_16(1, pGenerar);
                                AddReg_16(2, pGenerar);
                                AddReg_16(3, pGenerar);
                                AddReg_16(4, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_16(5, pGenerar);
                                AddReg_16(6, pGenerar);
                                AddReg_16(7, pGenerar);
                                AddReg_16(8, pGenerar);
                                AddReg_16(9, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_16(10, pGenerar);
                            END;
                    END;
                END;
            17:
                BEGIN //(50068) TargoBank
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingTargoBank.txt';
                                gName := 'Confirming Targobank';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_17(1, pGenerar);
                                AddReg_17(2, pGenerar);
                                AddReg_17(3, pGenerar);
                                AddReg_17(4, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_17(5, pGenerar);
                                AddReg_17(6, pGenerar);
                                AddReg_17(7, pGenerar);
                                AddReg_17(8, pGenerar);
                                AddReg_17(9, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_17(10, pGenerar);
                            END;
                    END;
                END;
            18:
                BEGIN //(50069) Cajamar
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingCajaMar.txt';
                                gName := 'Confirming Cajamar';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_18(1, pGenerar);
                                AddReg_18(2, pGenerar);
                                AddReg_18(3, pGenerar);
                                AddReg_18(4, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_18(3, pGenerar);
                                AddReg_18(4, pGenerar);
                                AddReg_18(5, pGenerar);
                                AddReg_18(6, pGenerar);
                                AddReg_18(7, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_18(8, pGenerar);
                            END;
                    END;
                END;
            19:
                BEGIN //(50070) Unicaja
                    CASE pTipoReg OF
                        gTipoReg::Preparar:
                            BEGIN
                                gFile := 'ConfirmingUnicaja.txt';
                                gName := 'Confirming Unicaja';
                            END;
                        gTipoReg::Cabecera:
                            BEGIN
                                AddReg_19(1, pGenerar);
                            END;
                        gTipoReg::Cuerpo:
                            BEGIN
                                AddReg_19(2, pGenerar);
                                AddReg_19(3, pGenerar);
                            END;
                        gTipoReg::Pie:
                            BEGIN
                                AddReg_19(4, pGenerar);
                            END;
                    END;
                END;
        //--AMAPALA ELECTRONIC PAYMENTS

        END;
    END;

    LOCAL PROCEDURE "----------------------------------- Tipos de registro"();
    BEGIN
    END;

    LOCAL PROCEDURE AddReg_01(pNro: Integer; pGenerar: Boolean; pOpciones: ARRAY[5] OF Text);
    BEGIN
        //FORMATO: Est�ndar de Confirming
        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                6:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddInt(1, 1) +                                                     //Registro de Tipo 1: CABECERA
                               AddTxt(Company_Name, 50) +                                         //Nombre del ordenante
                               AddTxt(CompanyInfo."VAT Registration No.", 15) +                   //NIF ordenante
                               AddDat8T(pOpciones[1]) +                                           //Fecha de proceso
                               AddDat8(gPostingDate) +                                            //Fecha de la remesa
                               AddTxt(BankAcc."Confirming Contract No.", 20) +                    //N§ Contrato/Sufijo
                               AddTxt(BankAcc.IBAN, 34) +                                         //IBAN
                               AddTxt(gCurrency, 3) +                                             //Divisa
                               AddTxt(pOpciones[2], 1) +                                          //1-Estandar, 2-Pronto Pago, 3-Otros
                               AddTxt(gNro, 30) +                                                 //Referencia
                               AddTxt('FU', 2) +                                                  //Tipo de formato
                               AddSpc(77);                                                        //Libre

                2:
                    OutText := AddInt(2, 1) +                                                     //Registro de Tipo 2: CABECERA OPCIONAL
                               AddTxt(Company_Adress, 65) +                                       //Direcci¢n ordenante
                               AddTxt(CompanyInfo.City, 40) +                                     //Poblaci¢n ordenante
                               AddTxt(CompanyInfo."Post Code", 10) +                               //C.Postal ordenante
                               AddSpc(133);                                                       //Libre

                3:
                    OutText := AddInt(3, 1) +                                                     //Registro de Tipo 3: DATOS PROVEEDOR
                               AddTxt(VendorName, 70) +                                           //Nombre proveedor
                               AddTxt(Vendor."VAT Registration No.", 20) +                        //NIF proveedor
                               AddTxt(VendorAddress, 65) +                                        //Direcci¢n proveedor
                               AddTxt(Vendor.City, 40) +                                          //Poblaci¢n proveedor
                               AddTxt(Vendor."Post Code", 10) +                                   //C.Postal proveedor
                               AddTxt(Vendor."Country/Region Code", 2) +                          //Pais del proveedor
                               AddSpc(41);                                                        //Libre

                4:
                    OutText := AddInt(4, 1) +                                                     //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(Vendor."E-Mail", 50) +                                       //eMail proveedor
                               AddTxt('', 50) +                                                   //eMail secundario proveedor
                               AddTxt(Vendor."Phone No.", 15) +                                   //Tel�fono proveedor
                               AddTxt(Vendor."Fax No.", 15) +                                     //Fax del proveedor
                               AddSpc(118);                                                       //Libre

                5:
                    OutText := AddInt(5, 1) +                                                     //Registro de Tipo 5: DATOS PROVEEDOR
                               AddTxt(pOpciones[3], 1) +                                          //Tipo de Pago T-Transferecnia, C-Cheque
                               AddTxt(VendorIBAN, 34) +                                           //IBAN proveedor
                               AddTxt(VendorSWIFT, 11) +                                          //BIC/Swift proveedor
                               AddTxt(VendorCCC, 34) +                                            //Cuenta pagos internacionales sin IBAN
                               AddTxt(VendorBankAccount."Country/Region Code", 2) +               //Pa¡s del banco
                               AddTxt('', 11) +                                                   //C¢digo ABA (comnsultar entidad)
                               AddTxt('', 2) +                                                    //Tipo proveedor (comnsultar entidad)
                               AddTxt('', 40) +                                                   //Por cuenta de (consultar entidad)
                               AddSpc(113);                                                       //Libre

                6:
                    OutText := AddInt(6, 1) +                                                     //Registro de Tipo 6: DATOS PAGO
                               AddTxt(tmpCarteraDoc."External Document No.", 20) +                //N§ Factura
                               AddSAmount(tmpCarteraDoc."Remaining Amount", 16, 2, 0) +           //Signo + Importe
                               AddDat8(tmpCarteraDoc."Posting Date") +                            //Fecha emisi¢n
                               AddDat8(tmpCarteraDoc."Due Date") +                                //Fecha Vto.
                               AddDat8(gChargeDate) +                                             //Fecha pr¢rroga/aplazamiento/cargo (consultar entidad)  //JAV 13/12/21: - QB 1.10.07 Se informa de la fecha de cargo si es P.Pago
                               AddTxt(tmpCarteraDoc."Document No.", 16) +                         //Referencia Pago (para conciliaci¢n n43)
                               AddSpc(172);                                                       //Libre

                7:
                    OutText := AddInt(7, 1) +                                                     //Registro de Tipo 7: TOTALES
                               AddInt(Totales[1], 12) +                                           //Total ¢rdenes
                               AddAmount(Totales[2], 15, 2) +                                     //Total importe
                               AddSpc(221);                                                       //Libre
            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_02(pNro: Text; pGenerar: Boolean; pOpciones: ARRAY[5] OF Text);
    BEGIN
        //FORMATO: Emisi�n de cheque/Pagar� Santander
        IsConfirming := FALSE;    //Generamos talones, no es confirming

        CASE pNro OF
            'E':
                BEGIN
                    IF (pGenerar) THEN BEGIN
                        OutText := AddNum(pOpciones[1], 2) +                                           //Tipo de Lote: 60 Cheque bancario, 70 Cheque CC (Cuenta Corriente), 71 Pagar�
                                   AddTxt(pNro, 1) +                                                   //Tipo de registro: Datos del ordenante
                                   AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF Ordenante
                                   AddDat8(gPostingDate) +                                             //Fecha de la remesa
                                   AddDat8(gPostingDate) +                                             //Fecha de pago
                                   AddNum(BankAcc."CCC Bank No.", 4) +                                 //Banco de Cargo Ordenante
                                   AddNum(BankAcc."CCC Bank Branch No.", 4) +                          //Oficina de Cargo Ordenante
                                   AddNum(BankAcc."CCC Bank Account No.", 10) +                        //Cuenta de Cargo Ordenante
                                   AddAmount(Totales[1], 12, 2) +                                      //Total Importe Cheques
                                   AddInt(Totales[2], 8) +                                             //Total de registros
                                   AddInt(Totales[3], 8) +                                             //Total de Beneficiarios (registros B)
                                   AddTxt(pOpciones[2], 1) +                                           //Forma de env�o: "B" entrega al beneficiario, "O" distribuci�n a trav�s de la oficina
                                   AddSpc(60) +                                                        //Concepto Com�n
                                   AddTxt(pOpciones[3], 1) +                                           //Tipo de env�o: " " Env�o por BS Online, "U" Env�o por Infobanc
                                   AddTxt('1', 1);                                                     //Versi�n
                        OutFile.WRITE(OutText)
                    END ELSE
                        Totales[2] += 1;
                END;
            'O':
                BEGIN
                    IF (pGenerar) THEN BEGIN
                        OutText := AddNum(pOpciones[1], 2) +                                           //Tipo de Lote: 60 Cheque bancario, 70 Cheque CC (Cuenta Corriente), 71 Pagar�
                                   AddTxt(pNro, 1) +                                                   //Tipo de registro: Ampliaci�n del ordenante
                                   AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF Ordenante
                                   AddTxt(Company_Name, 40) +                                          //Nombre del Ordenante
                                   AddTxt(Company_Adress, 40) +                                        //Direcci�n Ordenante
                                   AddTxt(CompanyInfo."Post Code", 5) +                                //C�digo Postal
                                   AddTxt(CompanyInfo.City, 40);                                       //Poblaci�n Ordenante
                        OutFile.WRITE(OutText)
                    END ELSE
                        Totales[2] += 1;
                END;
            'B':
                BEGIN
                    IF (pGenerar) THEN BEGIN
                        OutText := AddNum(pOpciones[1], 2) +                                           //Tipo de Lote: 60 Cheque bancario, 70 Cheque CC (Cuenta Corriente), 71 Pagar�
                                   AddTxt(pNro, 1) +                                                   //Tipo de registro: Beneficiario
                                   AddTxt(Vendor."No.", 12) +                                          //C�digo Beneficiario
                                   AddAmount(tmpCarteraDoc."Remaining Amount", 10, 2) +                //Importe a abonar
                                   AddTxt(VendorName, 40) +                                            //Nombre Beneficiario
                                   AddTxt(pOpciones[4], 2) +                                           //Idioma: "01" Castellano, "08 "Catal�n
                                   AddTxt(Vendor."Post Code", 5) +                                     //C�digo Postal
                                   AddTxt(VendorAddress, 40) +                                         //Direcci�n Beneficiario
                                   AddDat8(DueDate) +                                                  //Fecha de Vencimiento
                                   AddTxt(pOpciones[5], 1) +                                           //Documento Barrado (S/N)
                                   AddSpc(17);                                                         //No utilizado
                        OutFile.WRITE(OutText)
                    END ELSE BEGIN
                        Totales[1] += tmpCarteraDoc."Remaining Amount";
                        Totales[2] += 1;
                        Totales[3] += 1;
                    END;
                END;
            'P':
                BEGIN
                    IF (pGenerar) THEN BEGIN
                        OutText := AddNum(pOpciones[1], 2) +                                           //Tipo de Lote: 60 Cheque bancario, 70 Cheque CC (Cuenta Corriente), 71 Pagar�
                                   AddTxt(pNro, 1) +                                                   //Tipo de registro: Ampliaci�n del beneficiario
                                   AddTxt(Vendor."No.", 12) +                                          //C�digo Beneficiario
                                   AddTxt(Vendor.City, 40) +                                           //Poblaci�n Beneficiario
                                   AddTxt(Vendor.County, 20) +                                         //Provincia Beneficiario
                                   AddSpc(63);                                                         //No utilizado
                        OutFile.WRITE(OutText)
                    END ELSE
                        Totales[2] += 1;
                END;
            'C':
                BEGIN
                    //Mirar si viene de una agrupaci�n de efectos
                    QBCrearEfectosLinea.RESET;
                    QBCrearEfectosLinea.SETRANGE("No. Agrupacion", tmpCarteraDoc."Document No.");
                    IF (NOT QBCrearEfectosLinea.FINDSET(FALSE)) THEN BEGIN
                        IF (tmpCarteraDoc."External Document No." <> '') THEN BEGIN
                            //Si no vienen de la agrupaci�n, a�ado el documento directamente si tiene nro de documento externo
                            IF (pGenerar) THEN BEGIN
                                OutText := AddNum(pOpciones[1], 2) +                                           //Tipo de Lote: 60 Cheque bancario, 70 Cheque CC (Cuenta Corriente), 71 Pagar�
                                           AddTxt(pNro, 1) +                                                   //Tipo de registro: Detalle del pago
                                           AddTxt(Vendor."No.", 12) +                                          //C�digo Beneficiario
                                           AddTxt(tmpCarteraDoc."Document No." + ' ' +
                                                  tmpCarteraDoc."External Document No." + ' ' +
                                                  FORMAT(tmpCarteraDoc."Remaining Amount"), 120) +             //Concepto
                                           AddSpc(3);                                                          //No utilizado
                                OutFile.WRITE(OutText)
                            END ELSE
                                Totales[2] += 1;
                        END;
                    END ELSE BEGIN
                        //Si es desglosado debo a�adir todas las facturas originales
                        REPEAT
                            IF (pGenerar) THEN BEGIN
                                OutText := AddNum(pOpciones[1], 2) +                                           //Tipo de Lote: 60 Cheque bancario, 70 Cheque CC (Cuenta Corriente), 71 Pagar�
                                           AddTxt(pNro, 1) +                                                   //Tipo de registro: Detalle del pago
                                           AddTxt(Vendor."No.", 12) +                                          //C�digo Beneficiario
                                           AddTxt(QBCrearEfectosLinea."Document No." + ' ' +
                                                  QBCrearEfectosLinea."External Document No." + ' ' +
                                                  FORMAT(QBCrearEfectosLinea."Importe Pendiente"), 120) +      //Concepto
                                           AddSpc(3);                                                          //No utilizado
                                OutFile.WRITE(OutText)
                            END ELSE
                                Totales[2] += 1;
                        UNTIL (QBCrearEfectosLinea.NEXT = 0);
                    END;
                END;
        END;
    END;

    LOCAL PROCEDURE AddReg_03(pNro: Integer; pGenerar: Boolean; pOpciones: ARRAY[5] OF Text);
    BEGIN
        //FORMATO: Confirming Banesto/Bankinter
        IsConfirming := TRUE;

        CASE pNro OF
            3:
                BEGIN
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 03
                               AddTxt('60', 2) +                                                   //Dato fijo '60'
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddSpc(12) +                                                       //Libre, referencia interna BK
                               AddTxt('001', 3) +                                                  //Dato fijo '001'
                               AddDat6(WORKDATE, 0) +                                             //Fecha de env�o
                               AddDat6(gPostingDate, 0) +                                         //Fecha de la remesa
                               AddTxt('0128', 4) +                                                 //Fijo '0128'
                               AddTxt(BankAcc."CCC Bank Branch No.", 4) +                         //Sucursal del cliente
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato
                               AddSpc(4) +                                                        //Libre
                               AddTxt(BankAcc."Dig.Control Bankinter", 2) +                        //Dig.Control de la cuenta para Bankinter
                               AddSpc(7);                                                         //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;
                END;

            6:
                BEGIN
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('010', 3) +                                                 //Tipo 010 (Obligatorio)
                               AddAmount(tmpCarteraDoc."Remaining Amount", 12, 2) +               //Importe
                               AddSpc(19) +                                                       //Libre
                               AddSignoB(tmpCarteraDoc."Remaining Amount") +                      //Signo /"" o "-"
                               AddSpc(11);                                                        //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[1] += ABS(tmpCarteraDoc."Remaining Amount");
                        Totales[2] += 1;
                        Totales[3] += 1;
                    END;
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('011', 3) +                                                 //Tipo 011 (Obligatorio)
                               AddTxt(VendorName, 36) +                                           //Nombre proveedor
                               AddSpc(7);                                                         //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('012', 3) +                                                 //Tipo 012 (Obligatorio)
                               AddTxt(VendorAddress, 36) +                                        //Direcci¢n proveedor
                               AddSpc(7);                                                         //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('014', 3) +                                                 //Tipo 014 (Obligatorio)
                               AddTxt(Vendor."Post Code", 5) +                                    //C.Postal proveedor
                               AddTxt(Vendor.City, 32) +                                          //Poblaci¢n proveedor
                               AddSpc(6);                                                         //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    IF (Vendor."Phone No." <> '') THEN BEGIN
                        OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                                   AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                                   AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                                   AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                                   AddTxt('017', 3) +                                                 //Tipo 017 (opcional)
                                   AddTxt('34', 5) +                                                  //Prefijo Telefono proveedor
                                   AddTxtN(Vendor."Phone No.", 12) +                                  //Telefono proveedor
                                   AddSpc(26);                                                        //Libre
                        IF (pGenerar) THEN
                            OutFile.WRITE(OutText)
                        ELSE BEGIN

                            Totales[3] += 1;
                        END;
                    END;

                    IF (Vendor."E-Mail" <> '') THEN BEGIN
                        OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                                   AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                                   AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                                   AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                                   AddTxt('170', 3) +                                                 //Tipo 170 (opcional)
                                   AddTxt(Vendor."E-Mail", 36) +                                      //mail proveedor
                                   AddSpc(7);                                                         //Libre
                        IF (pGenerar) THEN
                            OutFile.WRITE(OutText)
                        ELSE BEGIN

                            Totales[3] += 1;
                        END;
                    END;

                    IF (COPYSTR(Vendor."E-Mail", 37) <> '') THEN BEGIN
                        OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                                   AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                                   AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                                   AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                                   AddTxt('172', 3) +                                                 //Tipo 172 (opcional)
                                   AddTxt(COPYSTR(Vendor."E-Mail", 37), 36) +                         //mail proveedor
                                   AddSpc(7);                                                         //Libre
                        IF (pGenerar) THEN
                            OutFile.WRITE(OutText)
                        ELSE BEGIN

                            Totales[3] += 1;
                        END;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('173', 3) +                                                 //Tipo 173 (Obligatorio)
                               AddTxt(VendorIBAN, 34) +                                           //IBAN proveedor
                               AddSpc(1) +                                                        //Libre
                               AddTxt(Vendor."Country/Region Code", 2) +                          //Pais del proveedor
                               AddSpc(6);                                                         //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    IF (pOpciones[2] = '57') THEN
                        VendorSWIFT2 := ''
                    ELSE
                        VendorSWIFT2 := VendorSWIFT;
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('174', 3) +                                                 //Tipo 174 (Obligatorio)
                               AddTxt(VendorSWIFT2, 11) +                                         //Swift proveedor
                               AddSpc(16) +                                                       //Otros del  proveedor
                               AddSpc(16);                                                        //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('175', 3) +                                                 //Tipo 175 (Obligatorio)
                               AddTxt('E', 1) +                                                   //Idioma (E/I)
                               AddSpc(42);                                                        //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('182', 3) +                                                 //Tipo 182 (Obligatorio)
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddSpc(31);                                                        //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    IF (tmpCarteraDoc."External Document No." = '') THEN
                        tmpCarteraDoc."External Document No." := tmpCarteraDoc."Document No.";
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('018', 3) +                                                 //Tipo 018 (Obligatorio)
                               AddDat6(tmpCarteraDoc."Due Date", 0) +                             //Fecha Vto.
                               AddTxt(tmpCarteraDoc."External Document No.", 16) +                //N� Factura
                               AddTxt(tmpCarteraDoc."Document No.", 14) +                         //Libre, Referencia Pago
                               AddSpc(7);                                                         //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('019', 3) +                                                 //Tipo 019 (Obligatorio)
                               AddSpc(12) +                                                       //Libre, Referencia Pago
                               AddSpc(31);                                                        //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN

                        Totales[3] += 1;
                    END;
                END;

            8:
                BEGIN
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 08: TOTALES
                               AddTxt('60', 2) +                                                   //Dato fijo '60'
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddSpc(15) +                                                       //Libre
                               AddAmount(Totales[1], 12, 2) +                                     //Total importe
                               AddInt(Totales[2], 8) +                                            //Total registros datos
                               AddInt(Totales[3], 10) +                                           //Total registros
                               AddSpc(13);                                                        //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;
                END;
        END;
    END;

    LOCAL PROCEDURE AddReg_04(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Sabadell BS
        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                2:
                    BEGIN
                        Totales[1] += 1;
                        Totales[2] += tmpCarteraDoc."Remaining Amount";
                    END;
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddInt(1, 1) +                                                     //Registro de Tipo 1: CABECERA
                               AddSpc(2) +                                                        //Reservado
                               AddTxt(Company_Name, 40) +                                         //Nombre ordenante
                               AddDat8(gPostingDate) +                                            //Fecha de proceso
                               AddTxt(CompanyInfo."VAT Registration No.", 9) +                    //NIF ordenante
                               AddTxt('65B', 3) +                                                  //Fijo 65 + B
                               AddTxt(BankAcc."CCC No.", 20) +                                    //Cuenta de Cargo
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N� Contrato BSConfirming
                               AddTxt('KF01', 4) +                                                 //Fijo KF01
                               AddTxt(gCurrency, 3) +                                             //Divisa
                               AddSpc(198);                                                       //Libre

                2:
                    OutText := AddInt(2, 1) +                                                     //Registro de Tipo 2: DATOS DE LA ORDEN
                               AddTxt(Vendor."No.", 15) +                                         //C�digo Proveedor
                               AddTxt('10', 2) +                                                  //Tipo de cocumento (10 = CIF)
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt(MedioDePago, 1) +                                           //Forma de Pago T � Transferencia, C � Cheque, E � Transferencia extranjero
                               AddTxt(VendorCCC, 20) +                                            //Cuenta nacional de Abono del Proveedor
                               AddTxt(tmpCarteraDoc."External Document No.", 15) +                //N�mero de Factura
                               AddSAmount(tmpCarteraDoc."Remaining Amount", 15, 2, 1) +           //Importe + Signo
                               AddDat8(tmpCarteraDoc."Posting Date") +                            //Fecha emisi�n factura
                               AddDat8(tmpCarteraDoc."Due Date") +                                //Fecha vencimiento factura
                               AddTxt(tmpCarteraDoc."Document No.", 30) +                         //Referencia factura Ordenante
                               AddTxt(Barrado, 1) +                                               //Barrado cheque
                               AddSpc(8 + 8 + 1 + 30 + 4 + 8) +                                             //Campos no informados
                               AddSpc(114);                                                       //Libres

                3:
                    OutText := AddInt(3, 1) +                                                     //Registro de Tipo 3: DATOS COMPLEMENTARIOS
                               AddTxt(VendorName, 40) +                                           //Nombre Proveedor
                               AddTxt('08', 2) +                                                  //Idioma Proveedor (08 = Espa�ol)
                               AddTxt(VendorAddress, 67) +                                        //Direcci�n Proveedor
                               AddTxt(Vendor.City, 40) +                                          //Poblaci�n Proveedor
                               AddTxt(Vendor."Post Code", 5) +                                    //C�digo Postal
                               AddSpc(6) +                                                        //Reservado
                               AddTxt(Vendor."Phone No.", 15) +                                   //Tel�fono proveedor
                               AddTxt(Vendor."Fax No.", 15) +                                     //Fax del proveedor
                               AddTxt(Vendor."E-Mail", 60) +                                      //Correo electr�nico
                               AddTxt('1', 1) +                                                   //Tipo env�o informaci�n (1 = Correo)
                               AddTxt('ES', 2) +                                                  //C�digo Pa�s del domicilio
                               AddSpc(2) +                                                        //C�digo Pa�s de residencia
                               AddSpc(44);                                                        //No utilizado

                4:
                    OutText := AddInt(4, 1) +                                                     //Registro de Tipo 4: DATOS TRANSFERENCIA INTERNACIONAL
                               AddTxt(Vendor."No.", 15) +                                         //C�digo Proveedor
                               AddTxt(VendorBankAccount."Country/Region Code", 2) +               //C�digo de pa�s
                               AddTxt(VendorSWIFT, 11) +                                          //C�digo Swift
                               AddTxt(VendorIBAN, 34) +                                           //C�digo IBAN
                               AddSpc(6) +                                                        //No usado
                               AddTxt(gCurrency, 3) +                                             //C�digo  de divisa
                               AddSpc(3) +                                                        //Reservado
                               AddSpc(225);                                                       //Libre

                5:
                    OutText := AddInt(5, 1) +                                                     //Registro de Tipo 5: TOTALES DEL LOTE
                               AddTxt(CompanyInfo."VAT Registration No.", 9) +                    //NIF ordenante
                               AddInt(Totales[1], 7) +                                            //Total �rdenes (N� registros c�digo 2 de la remesa).
                               AddSAmount(Totales[2], 15, 2, 1) +                                 //Importe + Signo
                               AddSpc(268);                                                       //Libre

            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_05(pNro: Text; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Bank

        //++PaymentOrder.TESTFIELD("Numero Confirming");   Esto no se de donde sale, revisar

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                'A':
                    Totales[1] += 1;
                'D':
                    Totales[1] += 1;
                'F':
                    Totales[1] += 1;
                'P':
                    BEGIN
                        Totales[1] += 1;
                        Totales[2] += tmpCarteraDoc."Remaining Amount";
                    END;
                'Z':
                    Totales[1] += 1;
            END;
        END ELSE BEGIN
            //Los primeros campos son iguales siempre
            OutText := AddTxt(BankAcc."Confirming Contract No.", 10) +                    //CIF o N� Contrato
                                                                                          //++AddTxt(PaymentOrder."Numero Confirming",10)+                      //Amapala N�mero de confirming
                       AddSpc(10);                                                        //Sin uso
            CASE pNro OF
                'A':
                    OutText += AddTxt(pNro, 1) +                                                   //Tipo de registro A: CABECERA
                               AddDat6(gPostingDate, 0) +                                          //Fecha de generaci�n
                               AddSpc(6) +                                                         //Sin uso
                               AddTxt('F', 1) +                                                     //Modo respuesta: F = Fichero, P u otros valores = papel.
                               AddSpc(1) +                                                         //Sin uso
                               AddTxt(Company_Name, 40) +                                           //Nombre Ordenante
                               AddSpc(215);                                                        //Relleno

                'D':
                    OutText += AddTxt(pNro, 1) +                                                   //Tipo de registro D: PROVEEDORES
                               AddTxt(Vendor."No.", 15) +                                          //Identificador de proveedor
                               AddTxt(Vendor."Country/Region Code", 2) +                           //Pais del proveedor
                               AddTxt(Vendor."VAT Registration No.", 20) +                         //NIF/CIF/VIN
                               AddTxt(VendorName, 40) +                                            //Nombre del proveedor
                               AddTxt(VendorAddress, 30) +                                         //Direcci�n del proveedor
                               AddTxt(COPYSTR(VendorAddress, 31), 30) +                            //Datos adicionales del domicilio
                               AddSpc(6) +                                                         //N�mero del domicilio
                               AddTxt(Vendor.County, 15) +                                         //Provincia del proveedor
                               AddTxt(Vendor.City, 20) +                                           //Poblaci�n del proveedor
                               AddSpc(15) +                                                        //Sin uso
                               AddTxt(Vendor."Post Code", 10) +                                    //C�digo Postal
                               AddTxt(Vendor."Phone No.", 20) +                                    //Tel�fono proveedor
                               AddSpc(1 + 20 + 9) +                                                    //Sin uso
                               AddTxt(Vendor."Fax No.", 16);                                       //Fax del proveedor

                'F':
                    OutText += AddTxt(pNro, 1) +                                                   //Tipo de registro F: PROVEEDORES
                               AddTxt(Vendor."No.", 15) +                                          //Identificador de proveedor
                               AddTxt(Vendor."E-Mail", 40) +                                       //Mail del proveedor
                               AddSpc(60) +                                                        //Parte no usable del mail del proveedor
                               AddSpc(154);                                                        //No utilizado

                'P':
                    OutText += AddTxt(pNro, 1) +                                                   //Tipo de registro P: PAGOS
                               AddTxt(Vendor."No.", 15) +                                          //Identificador de proveedor
                               AddTxt(tmpCarteraDoc."Document No.", 15) +                          //Referencia factura Ordenante
                               AddSpc(8) +                                                         //Fecha post-financiaci�n
                               AddSpc(5) +                                                         //Libre
                               AddTxt('P', 1) +                                                    //Tipo (P=Pago, A=Abono)
                               AddSpc(1) +                                                         //libre
                               AddTxt(tmpCarteraDoc."External Document No.", 15) +                 //N�mero de Factura
                               AddDat6(tmpCarteraDoc."Posting Date", 0) +                          //Fecha emisi�n factura
                               AddSpc(15) +                                                        //Si es un abono, que factura liquida
                               AddDat6(tmpCarteraDoc."Due Date", 0) +                              //Fecha vencimiento factura
                               AddAmount(tmpCarteraDoc."Remaining Amount", 15, 2) +                //Importe
                               AddTxt(gCurrency, 3) +                                              //Divisa del pago
                               AddTxt(MedioDePago, 1) +                                            //Medio de pago (C=Cheque, T=Transferencia, *=Cheque especial)
                               AddTxt('P', 1) +                                                    //Tipo de beneficiario (P o C)
                               AddSpc(20) +                                                        //Identificaci�n del beneficiario
                               AddTxt(VendorCCC, 25) +                                             //Cuenta de pago
                               AddSpc(36 + 36 + 34 + 4 + 7);                                               //Uso interno

                'Z':
                    OutText += AddTxt(pNro, 1) +                                                   //Tipo de registro Z: TOTALES
                               AddInt(Totales[1], 15) +                                            //Total �rdenes (N� registros c�digo 2 de la remesa).
                               AddAmount(Totales[2], 15, 2) +                                       //Total �rdenes (N� registros c�digo 2 de la remesa).
                               AddSpc(239);                                                        //No utilizado
            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_06(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming La Caixa
        IsConfirming := TRUE;
        OutText := '';

        CASE pNro OF
            1:
                OutText += AddTxt('0156', 4) +                                                 //Tipo de registro 0156 - 001: CABECERA
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddSpc(12) +                                                        //Libre
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddDat6(gPostingDate, 1) +                                          //Fecha de proceso
                           AddSpc(6) +                                                         //Libre
                           AddTxt('2100', 4) +                                                  //Entidad de destino, valor fijo
                           AddTxt('6202', 4) +                                                  //Oficina de destino, valor fijo
                           AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N� Contrato BSConfirming
                           AddTxt('1', 1) +                                                     //Detalle del cargo (0/1)
                           AddTxt(gCurrency, 3) +                                              //Divisa (debe ser EUR)
                           AddSpc(2 + 7);                                                        //Relleno
            2:
                OutText += AddTxt('0156', 4) +                                                 //Tipo de registro 0156 - 002: CABECERA
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddSpc(12) +                                                        //Libre
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(Company_Name, 36) +                                          //Nombre ordenante
                           AddSpc(7);                                                          //Relleno
            3:
                OutText += AddTxt('0156', 4) +                                                 //Tipo de registro 0156 - 003: CABECERA
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddSpc(12) +                                                        //Libre
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(Company_Adress, 36) +                                        //Direcci�n del ordenante
                           AddSpc(7);                                                          //Relleno

            4:
                OutText += AddTxt('0156', 4) +                                                 //Tipo de registro 0156 - 004: CABECERA
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddSpc(12) +                                                        //Libre
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(CompanyInfo.City, 36) +                                      //Plaza del ordenante
                           AddSpc(7);                                                          //Relleno

            10:
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 010: PROVEEDOR
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddAmount(tmpCarteraDoc."Remaining Amount", 12, 2) +                //Importe
                           AddTxt(COPYSTR(VendorCCC, 1, 4), 4) +                                 //Banco del beneficiario
                           AddTxt(COPYSTR(VendorCCC, 5, 4), 4) +                                 //Sucursal del beneficiario
                           AddTxt(COPYSTR(VendorCCC, 11), 10) +                                 //Cuenta del beneficiario
                           AddTxt('1', 1) +                                                     //Gastos por cuenta del ordenante
                           AddTxt('9', 1) +                                                     //Concepto
                           AddSpc(2) +                                                         //Libre
                           AddTxt(COPYSTR(VendorCCC, 9), 2) +                                   //D�gitos de Control de la Cuenta del beneficiario
                           AddTxt(VendorIsNoResident, 1) +                                      //Proveedor no residente
                           AddSpc(1) +                                                         //Indicador de confirmaci�n (C/' ')
                           AddTxt(gCurrency, 3) +                                              //Divisa de la factura
                           AddSpc(2);                                                          //Libre

            43:
                IF (VendorIsNoResident = 'S') THEN BEGIN
                    OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 043: PROVEEDOR NO RESIDENTE
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                               AddInt(pNro, 3) +                                                   //Tipo de dato
                               AddTxt(COPYSTR(VendorIBAN, 1, 2), 2) +                               //IBAN: ISO del pa�s del proveedor
                               AddTxt(COPYSTR(VendorIBAN, 3, 2), 2) +                               //IBAN: D�gitos control
                               AddTxt(COPYSTR(VendorIBAN, 5), 30) +                                //IBAN: Cuenta
                               AddTxt('7', 1) +                                                     //Concepto
                               AddSpc(8);                                                          //Libre
                END;

            44:
                IF (VendorIsNoResident = 'S') THEN BEGIN
                    OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 044: PROVEEDOR NO RESIDENTE
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                               AddInt(pNro, 3) +                                                   //Tipo de dato
                               AddTxt('1', 1) +                                                     //Clave del gasto
                               AddTxt(COPYSTR(VendorIBAN, 1, 2), 2) +                               //IBAN: ISO del pa�s del proveedor
                               AddSpc(6) +                                                         //Libre
                               AddTxt(VendorSWIFT, 12) +                                           //SWIFT
                               AddSpc(22);                                                         //Libre
                END;

            45:
                ; //Opcional no usado, Referencia Interna
            46:
                ; //Opcional no usado, Fecha financiaci�n

            11:
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 011: PROVEEDOR
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(VendorName, 36) +                                            //Nombre del proveedor
                           AddSpc(7);                                                          //Libre

            12:
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 012: PROVEEDOR
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(VendorAddress, 36) +                                         //Direcci�n del proveedor
                           AddSpc(7);                                                          //Libre

            13:
                IF (STRLEN(VendorAddress) > 36) THEN
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 013: PROVEEDOR opcional
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(COPYSTR(VendorAddress, 37), 36) +                             //Direcci�n del proveedor
                           AddSpc(7);                                                          //Libre

            14:
                OutText += AddTxt('0656', 4) +                                                //Tipo de registro 0656 - 014: PROVEEDOR
                          AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                          AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                          AddInt(pNro, 3) +                                                   //Tipo de dato
                          AddTxt(Vendor."Post Code", 5) +                                    //C�digo Postal
                          AddTxt(Vendor.City, 31) +                                           //Poblaci�n del proveedor
                          AddSpc(7);                                                          //Libre

            15:
                IF (VendorIsNoResident = 'S') THEN BEGIN
                    OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 015: PROVEEDOR NO RESIDENTE
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                               AddInt(pNro, 3) +                                                   //Tipo de dato
                               AddTxt('', 15) +                                                    //C�digo interno del proveedor que identifica a su cliente
                               AddTxt('', 12) +                                                    //NIF del proveedor si la factura est� endosada
                               AddTxt('', 1) +                                                     //Clasificaci�n del proveedor por el cliente.
                               AddTxt(COPYSTR(VendorIBAN, 1, 2), 2) +                               //IBAN: ISO del pa�s del proveedor
                               AddTxt(Vendor."Country/Region Code", 9) +                           //pa�s del proveedor
                               AddSpc(4);                                                          //Libre
                END;

            16:
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 016: PROVEEDOR
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt('T', 1) +                                                    //Forma de pago C=Cheque T=transferencia
                           AddDat6(tmpCarteraDoc."Document Date", 1) +                         //Fecha de la factura
                           AddTxt(tmpCarteraDoc."External Document No.", 15) +                 //N� de la factura del proveedor
                           AddDat6(tmpCarteraDoc."Due Date", 1) +                              //Fecha de vto.
                           AddSpc(8 + 7);                                                        //Libre

            17:
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 017: PROVEEDOR Opcional
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(tmpCarteraDoc."Document No.", 15) +                          //N� de la factura
                           AddTxt(tmpCarteraDoc."Bill Gr./Pmt. Order No.", 15) +               //Orden de pago
                           AddSpc(6 + 7);                                                        //Libre

            18:
                IF (VendorIsNoResident = 'N') OR (Vendor."Phone No." <> '') THEN BEGIN
                    OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 018: PROVEEDOR NO RESIDENTE, opcional para nacionales
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                               AddInt(pNro, 3) +                                                   //Tipo de dato
                               AddTxt(Vendor."Phone No.", 15) +                                    //Tel�fono proveedor
                               AddTxt(Vendor."Fax No.", 15);                                       //Fax del proveedor
                    AddSpc(6 + 7);                                                        //Libre
                END;

            19:
                IF (Vendor."E-Mail" <> '') THEN
                    OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 019: PROVEEDOR Opcional
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                               AddInt(pNro, 3) +                                                   //Tipo de dato
                               AddTxt(Vendor."E-Mail", 36) +                                       //email
                               AddSpc(7);                                                          //Libre

            20:
                IF (STRLEN(Vendor."E-Mail") > 36) THEN
                OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 020: PROVEEDOR Opcional
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                           AddInt(pNro, 3) +                                                   //Tipo de dato
                           AddTxt(COPYSTR(Vendor."E-Mail", 37), 36) +                          //email
                           AddSpc(7);                                                          //Libre

            55:
                IF (VendorIsNoResident = 'S') THEN BEGIN
                    OutText += AddTxt('0656', 4) +                                                 //Tipo de registro 0656 - 055: PROVEEDOR NO RESIDENTE
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                         //NIF o Referencia interna
                               AddInt(pNro, 3) +                                                   //Tipo de dato
                               AddTxt('02', 2) +                                                   //Clase de Pago 01-Mercanc�a 02-Servicios
                               AddTxt('', 6) +                                                     //C�digo estad�stico CIN
                               AddTxt(COPYSTR(VendorIBAN, 1, 2), 2) +                               //IBAN: ISO del pa�s del proveedor
                               AddTxt('', 9) +                                                     //NIF del Beneficiario
                               AddTxt('', 8) +                                                      //N�mero Operaci�n Financiera
                               AddTxt('', 12) +                                                     //C�digo ISIN
                               AddSpc(4);                                                          //Libre
                END;

            8:
                OutText += AddTxt('0856', 4) +                                                 //Tipo de registro 0656 - 010: TOTALES
                           AddTxt(CompanyInfo."VAT Registration No.", 10) +                    //NIF ordenante
                           AddSpc(12 + 3) +                                                      //Libre
                           AddAmount(Totales[3], 12, 2) +                                       //Total facturas.
                           AddInt(Totales[2], 8) +                                             //N� registros tipo 10
                           AddInt(Totales[1], 10) +                                            //N� registros totales
                           AddSpc(6 + 7);                                                        //No utilizado
        END;

        IF (OutText <> '') THEN BEGIN
            IF (NOT pGenerar) THEN BEGIN      //Si solo estoy contando registros
                Totales[1] += 1;
                IF (pNro = 10) THEN BEGIN
                    Totales[2] += 1;
                    Totales[3] += tmpCarteraDoc."Remaining Amount";
                END;
            END ELSE BEGIN
                OutFile.WRITE(OutText);
            END;
        END;
    END;

    LOCAL PROCEDURE AddReg_08(pNro: Text; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming BBVA

        IsConfirming := TRUE;

        //JAV 13/09/21: - QB 1.09.17 Esto no es correcto, debe sumar tras meter el registro en el fichero, el registro puede ser sin registrar o registrado, por eso usa tmpCarteraDoc
        // PaymentOrder.GET(tmpCarteraDoc."Bill Gr./Pmt. Order No.");
        // PaymentOrder.CALCFIELDS(Amount);
        // Totales[2] := PaymentOrder.Amount;


        CASE pNro OF                //026805
            'C':
                OutText := AddTxt('021113', 6) +                                               //Tipo de registro: CABECERA
                           AddTxt(CompanyInfo."VAT Registration No.", 9) +                     //NIF ordenante
                           AddDat8(gPostingDate) +                                             //Fecha de proceso
                           AddAmount(Totales[2], 13, 2) +                                      //total de la remesa
                           AddTxt(gCurrency, 3) +                                              //Divisa
                           AddSpc(171);                                                        //Relleno

            'F':
                OutText := '' +                                                                //Tipo de registro: FACTURA
                           AddTxt(Vendor."VAT Registration No.", 9) +                           //Proveedor NIF
                           AddTxt(VendorName, 30) +                                             //Proveedor Nombre
                           AddTxt(VendorAddress, 30) +                                          //Proveedor Direcci�n
                           AddSpc(7) +                                                         //Libre
                           AddTxt(Vendor."Post Code", 5) +                                      //Proveedor C.Postal
                           AddTxt(Vendor.City, 20) +                                            //Proveedor Ciudad
                           AddTxt(Vendor."Phone No.", 10) +                                     //Proveedor Tel�fono
                           AddTxt(Vendor."Fax No.", 10) +                                       //Proveedor Fax
                           AddTxt(COPYSTR(VendorCCC, 1, 4), 4) +                                 //Proveedor CCC Banco
                           AddTxt(COPYSTR(VendorCCC, 5, 4), 4) +                                 //Proveedor CCC Sucursal
                           AddTxt(COPYSTR(VendorCCC, 11), 10) +                                 //Proveedor CCC Cuenta
                           AddTxt(tmpCarteraDoc."External Document No.", 11) +                 //Proveedor nro de factura
                           AddDat8(tmpCarteraDoc."Posting Date") +                             //Fecha de registro
                           AddAmount(tmpCarteraDoc."Remaining Amount", 13, 2) +                //Importe
                           AddDat8(tmpCarteraDoc."Due Date") +                                 //Fecha de vencimiento
                           AddSpc(31);                                                         //Relleno

        END;

        IF (OutText <> '') THEN BEGIN
            IF (NOT pGenerar) THEN BEGIN      //Si solo estoy contando registros
                Totales[1] += 1;
                //IF (pNro = 'L') THEN BEGIN           JAV 13/09/21: - QB 1.09.17 Error en la clave, debe ser la F y no la L para sumar los importes
                IF (pNro = 'F') THEN BEGIN
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
                END;
            END ELSE BEGIN
                OutFile.WRITE(OutText);
            END;
        END;
    END;

    LOCAL PROCEDURE AddReg_09(pNro: Integer; pGenerar: Boolean; pOpciones: ARRAY[5] OF Text);
    BEGIN
        //FORMATO: Confirming Deutsche Bank
        IsConfirming := TRUE;

        //JAV 13/01/22: - QB 1.10.09 Revisado con Inesco
        CASE pNro OF
            3:
                BEGIN
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 03
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante

                               AddTxt('0000000' + 'O' + '02' + 'X' + 'R', 12) +                   //Libre, referencia interna BK
                               AddInt(1, 3) +                                                      //Dato fijo '1'
                               AddDat6(WORKDATE, 1) +                                             //Fecha de env�o
                               AddDat6(gPostingDate, 1) +                                         //Fecha de la remesa
                               AddTxt('0019', 4) +                                                 //Fijo '0019'
                               AddTxt(BankAcc."CCC Bank Branch No.", 4) +                         //Sucursal del cliente
                               AddTxt(BankAcc."CCC Bank Account No.", 10) +                       //N§ Contrato
                               AddSpc(4) +                                                        //Libre
                               AddTxt(BankAcc."CCC Control Digits", 2) +                           //Dig.Control de la cuenta
                               AddSpc(185);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 03
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante

                               AddSpc(12) +                                                       //Libre
                               AddInt(2, 3) +                                                      //Dato fijo '2'
                               AddTxt(Company_Name, 40) +                                         //Nombre empresa
                               AddSpc(181);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 03
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante

                               AddSpc(12) +                                                       //Libre
                               AddInt(3, 3) +                                                      //Dato fijo '3'
                               AddTxt(CompanyInfo.Address, 40) +                                   //Direccion empresa
                               AddSpc(181);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 03
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante

                               AddSpc(12) +                                                       //Libre
                               AddInt(4, 3) +                                                      //Dato fijo '4'
                               AddTxt(CompanyInfo.City, 40) +                                      //Plaza del emisor
                               AddSpc(181);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;
                END;

            6:
                BEGIN
                    OutText := AddInt(6, 2) +                                                     //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor

                               AddTxt('010', 3) +                                                 //Tipo 010 (Obligatorio)
                               AddAmount(tmpCarteraDoc."Remaining Amount", 12, 2) +               //Importe
                               AddTxt(COPYSTR(VendorCCC, 1, 4), 4) +                                //Proveedor CCC Banco
                               AddTxt(COPYSTR(VendorCCC, 5, 4), 4) +                                //Proveedor CCC Sucursal
                               AddTxt(COPYSTR(VendorCCC, 11), 10) +                                //Proveedor CCC Cuenta
                               AddSpc(2 + 2) +                                                      //Libre
                               AddTxt(COPYSTR(VendorCCC, 9, 2), 2) +                                //Proveedor CCC D.C.
                               AddInt(0, 1) +                                                      //??
                               AddDat6(tmpCarteraDoc."Due Date", 1) +                             //Fecha Vto.
                               AddSpc(178);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[1] += ABS(tmpCarteraDoc."Remaining Amount");
                        Totales[2] += 1;
                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('011', 3) +                                                 //Tipo 011 (Obligatorio)
                               AddTxt(VendorName, 40) +                                           //Nombre proveedor
                               AddSpc(181);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('012', 3) +                                                 //Tipo 012 (Obligatorio)
                               AddTxt(VendorAddress, 40) +                                        //Direcci¢n proveedor
                               AddSpc(181);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[3] += 1;
                    END;

                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('014', 3) +                                                 //Tipo 014 (Obligatorio)
                               AddTxt(Vendor."Post Code", 5) +                                    //C.Postal proveedor
                               AddTxt(Vendor.City, 31) +                                          //Poblaci¢n proveedor
                               AddSpc(185);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[3] += 1;
                    END;

                    IF (Vendor.County <> '') THEN BEGIN
                        OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 06
                                   AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                                   AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                                   AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                                   AddTxt('015', 3) +                                                 //Tipo 015 (???)
                                   AddTxt(Vendor.County, 40) +                                        //Provincia
                                   AddSpc(181);                                                       //Libre
                        IF (pGenerar) THEN
                            OutFile.WRITE(OutText)
                        ELSE BEGIN
                            Totales[3] += 1;
                        END;
                    END;

                    OutText := AddInt(pNro, 2) +                                                 //Registro de Tipo 06
                              AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                              AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                              AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                              AddTxt('018', 3) +                                                 //Tipo 017 (opcional)
                              AddTxt(Vendor."VAT Registration No.", 9) +                         //NIF proveedor
                              AddSpc(1) +                                                        //Libre
                              AddInt(0, 12) +                                                     //???
                              AddSpc(3) +                                                        //Libre
                              AddTxtN(COPYSTR(Vendor."Phone No.", 1, 3), 3) +                    //Prefijo Telefono proveedor
                              AddTxtN(COPYSTR(Vendor."Phone No.", 4), 7) +                       //Telefono proveedor
                              AddTxtN(COPYSTR(Vendor."Fax No.", 4), 7) +                         //Fax proveedor
                              AddSpc(1 + 15) +                                                     //Libre
                              AddTxtN(COPYSTR(Vendor."Fax No.", 1, 3), 3) +                      //Prefijo Fax proveedor
                              AddSpc(160);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[3] += 1;
                    END;

                    OutText := AddInt(6, 2) +                                                     //Registro de Tipo 06
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor

                               AddTxt('019', 3) +                                                 //Tipo 019 (Obligatorio)
                               AddTxt(tmpCarteraDoc."External Document No.", 17) +                //Nro documento del proveedor
                               AddTxt(FORMAT(tmpCarteraDoc."Posting Date", 0, '<Day,2>.<Month,2>.<Year,2>'), 8) +            //Fecha remesa ???
                               AddAmount(tmpCarteraDoc."Remaining Amount", 10, 2) +               //Importe
                               AddSignoB(tmpCarteraDoc."Remaining Amount") +                      //Signo " " o "-"
                               AddSpc(185);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE BEGIN
                        Totales[3] += 1;
                    END;

                END;


            8:
                BEGIN
                    OutText := AddInt(pNro, 2) +                                                  //Registro de Tipo 08: TOTALES
                               AddTxt(pOpciones[2], 2) +                                           //Tipo: 56 Transferencia, 57 cheque
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddSpc(15) +                                                       //Libre
                               AddAmount(Totales[1], 12, 2) +                                     //Total importe
                               AddInt(Totales[2], 8) +                                            //Total registros datos
                               AddInt(Totales[3], 10) +                                           //Total registros
                               AddSpc(191);                                                       //Libre
                    IF (pGenerar) THEN
                        OutFile.WRITE(OutText)
                    ELSE
                        Totales[3] += 1;
                END;
        END;
    END;

    LOCAL PROCEDURE AddReg_10(pNro: Text; pGenerar: Boolean);
    BEGIN
        //FORMATO SANTANDER 1
        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                '2':
                    BEGIN
                        Totales[1] += 1;
                        Totales[2] += tmpCarteraDoc."Remaining Amount";
                    END;
            END;
        END ELSE BEGIN


            CASE pNro OF
                '1':
                    OutText := AddTxt(pNro, 1) +                                                   //Tipo de registro 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 3) +                      //C�digo asignado al Cedente
                               AddTxt(Company_Name, 40) +                                          //Nombre Ordenante
                               AddDat8(gPostingDate) +                                             //Fecha de proceso
                               AddTxt(gNro, 16) +                                                   //Referencia de la remesa
                               AddTxt(gCurrency, 3) +                                              //Divisa del pago
                               AddInt(0, 6) +                                                      //Reservado
                               AddInt(0, 8) +                                                      //Reservado
                               AddSpc(16) +                                                        //Reservado
                               AddSpc(181);                                                        //Libre

                '2':
                    OutText := AddTxt(pNro, 1) +                                                   //Tipo de registro 2: DOCUMENTO
                               AddTxt(Vendor."No.", 15) +                                          //Identificador de proveedor
                               AddTxt(Vendor."VAT Registration No.", 16) +                         //NIF/CIF/VIN
                               AddTxt(VendorName, 40) +                                            //Nombre del proveedor
                               AddTxt(VendorAddress, 40) +                                         //Direcci�n del proveedor
                               AddTxt(Vendor.City, 25) +                                           //Poblaci�n del proveedor
                               AddTxt(Vendor."Post Code", 5) +                                     //C�digo Postal
                               AddTxt(Vendor."Phone No.", 10) +                                    //Tel�fono proveedor
                               AddTxt(Vendor."Fax No.", 9) +                                       //Fax del proveedor
                               AddTxt(Vendor."Country/Region Code", 2) +                           //Pais del proveedor
                               AddTxt(MedioDePago, 1) +                                            //Medio de pago (C=Cheque, T=Transferencia)
                               AddTxt(VendorCCC, 24) +                                             //Cuenta de pago
                               AddTxt(gCurrency, 3) +                                              //Divisa del pago
                               AddTxt('F', 1) +                                                    //Tipo (F=Factura, A=Abono)
                               AddTxt(tmpCarteraDoc."Document No.", 15) +                          //N�mero
                               AddAmount(tmpCarteraDoc."Remaining Amount", 15, 2) +                //Importe
                               AddDat8(tmpCarteraDoc."Posting Date") +                             //Fecha emisi�n factura
                               AddDat8(tmpCarteraDoc."Due Date") +                                 //Fecha vencimiento factura
                               AddTxt(tmpCarteraDoc."External Document No.", 16) +                 //N�mero de Factura
                               AddSpc(28);                                                         //Libre

                '3':
                    OutText := AddTxt(pNro, 1) +                                                   //Tipo de registro 3: TOTALES
                               AddInt(Totales[1], 6) +                                             //Total documentos.
                               AddAmount(Totales[2], 15, 2) +                                       //Total importe.
                               AddSpc(260);                                                        //Libre
            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_11(pNro: Text; pGenerar: Boolean);
    BEGIN
        //FORMATO SANTANDER 2
        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                '2':
                    BEGIN
                        Totales[1] += 1;
                        Totales[2] += tmpCarteraDoc."Remaining Amount";
                    END;
            END;
        END ELSE BEGIN
            CASE pNro OF
                '1':
                    OutText := AddTxt(pNro, 1) +                                                   //Tipo de registro 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 3) +                      //Nemotecnico operacion
                               AddTxt('', 10) +                                                     //C�digo cliente
                               AddTxt('', 3) +                                                      //N� operacion
                               AddTxt(CompanyInfo."VAT Registration No.", 22) +                    //ID Cliente = NIF
                               AddTxt(Sufijo, 3) +                                                  //Sufijo
                               AddTxt(Company_Name, 40) +                                          //Nombre del Ordenante
                               AddDat8(gPostingDate) +                                             //Fecha de proceso
                               AddTxt(gNro, 16) +                                                   //Referencia de la remesa
                               AddTxt(gCurrency, 3) +                                              //Divisa del pago
                               AddInt(0, 6) +                                                      //Reservado
                               AddInt(0, 8) +                                                      //Reservado
                               AddSpc(16 + 4 + 30 + 47 + 12 + 345);                                          //Libre

                '2':
                    OutText := AddTxt(pNro, 1) +                                                   //Tipo de registro 2: DOCUMENTO
                               AddTxt(Vendor."No.", 15) +                                          //Identificador de proveedor
                               AddTxt('1', 1) +                                                    //Tipo identificador
                               AddTxt(Vendor."VAT Registration No.", 22) +                         //NIF
                               AddTxt('J', 1) +                                                     //Tipo de persona
                               AddTxt(VendorName, 30 + 30 + 30) +                                      //Nombre del proveedor
                               AddTxt(Vendor."Country/Region Code", 2) +                           //Pais
                               AddTxt('', 2) +                                                      //Tipo de via
                               AddTxt(VendorAddress, 40) +                                         //Direcci�n del proveedor
                               AddTxt('', 8) +                                                      //N�mero
                               AddTxt(COPYSTR(VendorAddress, 41), 40) +                            //Ampliaci�n de la direcci�n
                               AddTxt(Vendor.City, 25) +                                           //Poblaci�n del proveedor
                               AddTxt(Vendor."Post Code", 8) +                                     //C�digo Postal
                               AddTxt(Vendor.County, 25) +                                         //Provincia del proveedor
                               AddTxt(Vendor."Country/Region Code", 2) +                           //Pais del proveedor
                               AddTxt(Vendor."Phone No.", 14) +                                    //Tel�fono proveedor
                               AddTxt(Vendor."Fax No.", 14) +                                      //Fax del proveedor
                               AddTxt(Vendor."E-Mail", 60) +                                       //Mail del proveedor
                               AddTxt(MedioDePago, 1) +                                            //Medio de pago (C=Cheque, T=Transferencia)
                               AddTxt(VendorCCC, 30) +                                             //Cuenta de pago
                               AddTxt(VendorSWIFT, 12) +                                            //Swift
                               AddTxt(VendorIBAN, 47) +                                             //IBAN
                               AddTxt(gCurrency, 3) +                                              //Divisa del pago
                               AddTxt('F', 1) +                                                    //Tipo (F=Factura, A=Abono)
                               AddTxt(tmpCarteraDoc."Document No.", 15) +                          //N�mero
                               AddAmount(tmpCarteraDoc."Remaining Amount", 15, 2) +                //Importe
                               AddDat8(tmpCarteraDoc."Posting Date") +                             //Fecha emisi�n factura
                               AddDat8(tmpCarteraDoc."Due Date") +                                 //Fecha vencimiento factura
                               AddTxt(tmpCarteraDoc."External Document No.", 16) +                 //N�mero de Factura
                               AddSpc(20 + 1 + 7 + 1 + 2 + 20);                                              //Libre

                '3':
                    OutText := AddTxt(pNro, 1) +                                                   //Tipo de registro 3: TOTALES
                               AddInt(Totales[1], 6) +                                             //Total documentos.
                               AddAmount(Totales[2], 15, 2) +                                       //Total importe.
                               AddSpc(555);                                                        //Libre
            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_12(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Novobanco    ___

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                1:
                    Totales[1] += 1;
                2:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('1', 16) +
                               AddTxt(BankAcc."Confirming Contract No.", 15) +                    //codigo_ordenante
                               AddTxt(CompanyInfo."VAT Registration No.", 40) +                   //NIF ordenante
                               AddDat6(TODAY, 1) +                                                 //Hoy
                               AddTxt('v2007a', 6) +                                                //Valor Fijo v2007a
                               AddSpc(292);                                                       //Libre

                2:
                    BEGIN
                        IF VendorIBAN = '' THEN
                            VendorIBAN := '00000000000000000000';
                        OutText := AddTxt('2', 49) +                                                   //Registro de Tipo 3: DATOS PROVEEDOR
                                   AddTxt(Vendor."VAT Registration No.", 15) +                        //NIF proveedor
                                   AddTxt(Vendor."VAT Registration No.", 9) +                          //NIF proveedor
                                   AddTxt(UPPERCASE(VendorName), 40) +                                //Nombre proveedor
                                   AddTxt(UPPERCASE(VendorAddress), 50) +                             //Direcci¢n proveedor
                                   AddTxt(UPPERCASE(Vendor.City), 24) +                               //Poblaci¢n proveedor
                                   AddTxt(Vendor."Post Code", 5) +                                     //Codigo postar Proveedor
                                   AddTxt(Vendor."Phone No.", 15) +                                     //Telefono
                                   AddSpc(6) +                                                        //Libre
                                   AddTxt(DELCHR(VendorIBAN, '=', 'ES'), 20) +                           //IBAN
                                   AddSpc(1) +                                                        //Libre
                                   AddTxt(tmpCarteraDoc."External Document No.", 15) +                 //Factura Proveedor
                                   AddAmountB(tmpCarteraDoc."Remaining Amount", 15, 2) +                //Importe Factura sin signo
                                   AddDat6(tmpCarteraDoc."Document Date", 1) +                          //Fecha Factura
                                   AddDat6(tmpCarteraDoc."Due Date", 1) +                               //Fecha vencimiento
                                   AddTxt(Vendor."Country/Region Code", 2) +                            //Pa�s
                                   AddTxt('ES', 2) +                                                    //Pa�s valor Fijo ES
                                   AddSpc(6) +                                                         //Libre
                                   AddTxt(Vendor."E-Mail", 40) +                                        //Email
                                   AddTxt(Vendor."Fax No.", 15) +                                       //Fax
                                   AddSpc(19);                                                        //Libre
                    END;
                3:
                    OutText := AddTxt('3', 250) +                                                  //Registro de Tipo 3: TOTALES
                               AddAmountB(Totales[2], 15, 2) +                                      //Total importe
                               AddSpc(94);                                                        //Libre
            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_13(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Ibercaja ___

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                4:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('0456', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                   //NIF ordenante
                               AddTxt('001', 3) +                                                 //Valor Fijo
                               AddDat6(gPostingDate, 0) +                                         //Fecha de la remesa
                               AddSpc(6) +                                                        //Libre
                               AddTxt(DELCHR(BankAcc.IBAN, '=', 'ES'), 18) +                        //IBAN
                               AddTxt('0', 1) +                                                   //Valor Fijo
                               AddSpc(3) +                                                       //Libre
                               AddTxt(' ', 2) +                                                   //DC Empresa �que es esto?
                               AddSpc(7);                                                        //Libre

                2:
                    OutText := AddTxt('0456', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                   //NIF ordenante
                               AddTxt('002', 3) +                                                 //Valor Fijo
                               AddTxt(Company_Name, 36) +                                         //Nombre del Ordenante
                               AddSpc(7);                                                        //Libre

                3:
                    OutText := AddTxt('0660', 4) +                                                //Registro de Tipo 3: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('010', 3) +                                                 //Codigo Fijo
                               AddAmountB(tmpCarteraDoc."Remaining Amount", 12, 2) +               //Importe Factura
                               AddTxt(DELCHR(VendorIBAN, '=', 'ES'), 18) +                          //IBAN
                               AddTxt('1', 1) +                                                    //Valor Fijo
                               AddTxt('9', 1) +                                                    //Valor Fijo
                               AddSpc(2) +                                                        //Libre
                               AddTxt(' ', 2) +                                                   //DC Beneficiario �que es esto?
                               AddDat6(tmpCarteraDoc."Due Date", 7);                              //Fecha Vencimiento


                4:
                    OutText := AddTxt('0660', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('011', 3) +                                                 //Valor Fijo
                               AddTxt(VendorName, 36) +                                           //Nombre proveedor
                               AddSpc(7);                                                        //Libre

                5:
                    OutText := AddTxt('0660', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('012', 3) +                                                 //Valor Fijo
                               AddTxt(VendorAddress, 36) +                                        //Direcci�n proveedor
                               AddSpc(7);                                                        //Libre

                6:
                    OutText := AddTxt('0660', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('014', 3) +                                                  //Valor Fijo
                               AddTxt(Vendor."Post Code", 6) +                                    //Codigo postal Proveedor
                               AddTxt(Vendor.City, 30) +                                         //Ciduda Beneficiario
                               AddSpc(7);                                                        //Libre

                7:
                    OutText := AddTxt('0660', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('015', 3) +                                                 //Valor Fijo
                               AddTxt('Comunidad', 36) +                                           //Provincia POR HACER
                               AddSpc(7);                                                        //Libre

                8:
                    OutText := AddTxt('0660', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('016', 3) +                                                  //Valor Fijo
                               AddTxt('C', 1) +                                                   //Forma Pago POR HACER
                               AddDat6(gPostingDate, 6) +                                         //Fecha Pago
                               AddTxt(tmpCarteraDoc."External Document No.", 15) +                //Num Factura
                               AddDat6(tmpCarteraDoc."Due Date", 14) +                           //Vencimiento
                               AddDat6(gPostingDate, 7);                                           //fecha pago

                9:
                    OutText := AddTxt('0856', 4) +
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddSpc(12) +                                                      //Libre
                               AddSpc(3) +                                                        //Libre
                               AddInt(Totales[1], 12) +                                          //DET_01.F1 Acumulador? REVISAR Total ¢rdenes?
                               AddSpc(8) +                                                        //Detalles POR HACER
                               AddAmount(Totales[2], 10, 2) +                                     //Total importe
                               AddSpc(6) +                                                      //Libre
                               AddSpc(7);                                                        //Libre

            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_14(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Abanca ___ ___

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                6:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('10', 2) +                                        // Valor Fijo
                                AddTxt('serie por hacer', 12) +                            //Identificador del fichero POR HACER
                                AddSpc(9) +                                            //Libre
                                AddSpc(1) +                                            //Libre
                                AddTxt(BankAcc."Confirming Contract No.", 10) +        //Codigo Ordenante
                                AddSpc(10) +                                           //Libre
                                AddSpc(1) +                                            //Libre
                                AddDat8(gPostingDate) +                              //Fecha Soporte
                                AddTxt('EUR', 3) +                                      //Divisa valor Fijo
                                AddSpc(1) +                                            //Libre
                                AddSpc(5) +                                            //Libre
                                AddTxt(CompanyInfo."VAT Registration No.", 15) +       //NIF ordenante
                                AddTxt(Company_Name, 40) +                             //Nombre del ordenante
                                AddTxt(BankAcc.IBAN, 34) +                            //IBAN
                                AddSpc(194);                                          //Libre

                2:
                    OutText := AddTxt('20', 2) +                                       // Valor Fijo
                                AddSpc(12) +                                           //Libre
                                AddTxt(tmpCarteraDoc."External Document No.", 9) +     //N§ Factura
                                AddTxt('K', 1) +                                        // Valor Fijo
                                AddSpc(1) +                                            //Libre
                                AddSpc(1) +                                            //Libre
                                AddSpc(1) +                                            //Libre
                                AddSpc(1) +                                            //Libre
                                AddTxt(tmpCarteraDoc."Document No.", 7) +               //Numero de Pago POR HACER
                                AddAmountB(tmpCarteraDoc."Remaining Amount", 15, 2) +    //Importe Factura
                                AddDat8(tmpCarteraDoc."Due Date") +                   //Fecha Vencimiento
                                AddSpc(1) +                                            //Libre
                                AddTxt('2', 1) +                                        // Valor Fijo
                                AddSpc(1) +                                            //Libre
                                AddSpc(6) +                                            //Libre
                                AddTxt(Vendor."VAT Registration No.", 15) +            //Nif Beneficiario
                                AddTxt(Vendor.Name, 40) +                              //Nombre beneficiario
                                AddTxt(VendorIBAN, 34) +                               //IBAN Beneficiario
                                AddSpc(40) +                                           //Libre
                                AddTxt(VendorSWIFT, 12) +                               //SWIFT
                                AddTxt('E', 1) +                                       //Valor Fijo
                                AddSpc(2) +                                           //Libre
                                AddSpc(8) +                                           //Libre
                                AddSpc(131);                                          //Libre


                3:
                    OutText := AddTxt('21', 2) +                                       // Valor Fijo
                                AddSpc(12) +                                           //Libre
                                AddTxt(tmpCarteraDoc."External Document No.", 9) +     //N§ Factura
                                AddTxt(Vendor.Address, 40) +                            //Direcci�n beneficiarioo
                                AddTxt(Vendor.City, 25) +                               //Poblaci�n beneficiario
                                AddTxt(Vendor."Post Code", 10) +                        //Codigo Postal
                                AddTxt(Vendor."Country/Region Code", 2) +               //Pa�s beneficiario
                                AddSpc(40) +                                           //Libre
                                AddSpc(25) +                                           //Libre
                                AddSpc(25) +                                           //Libre
                                AddSpc(10) +                                           //Libre
                                AddSpc(2) +                                            //Libre
                                AddSpc(14) +                                           //Libre
                                AddSpc(14) +                                           //Libre
                                AddSpc(95);                                           //Libre


                4:
                    OutText := AddTxt('30', 2) +                                       // Valor Fijo
                                AddSpc(12) +                                           //Libre
                                AddTxt(tmpCarteraDoc."External Document No.", 9) +     //N§ Factura
                                AddTxt('F', 1) +                                        // Valor Fijo
                                AddTxt(tmpCarteraDoc."External Document No.", 10) +    //N§ Factura
                                AddAmountB(tmpCarteraDoc."Remaining Amount", 15, 2) +    //Importe Factura
                                AddTxt('+', 1) +                                        //Signo Abanca POR HACER
                                AddDat8(gPostingDate) +                                //Fecha Emisi�n
                                AddSpc(292);                                          //Libre


                5:
                    OutText := AddTxt('90', 2) +                                      // Valor Fijo
                                AddSpc(12) +                                          //Libre
                                AddSpc(9) +                                           //Detalles
                                AddSpc(1) +                                           //Detalles
                                AddAmount(Totales[2], 10, 2) +                        //Total importe
                                AddInt(Totales[1], 15) +                              //Total ¢rdenes
                                AddSpc(301);                                         //Libre
            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_15(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Liberbank

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                4:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('0359', 4) +                                                 //Registro de Tipo 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N§ Contrato/Sufijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                    //NIF ordenante
                               AddTxt('001', 3) +
                               AddDat8(gPostingDate) +                                            //Fecha de la remesa
                               AddTxt(DELCHR(BankAcc.IBAN, '=', 'ES'), 34) +                        //IBAN
                               AddSpc(77);                                                        //Libre

                2:
                    OutText := AddTxt('0659', 4) +                                                 //Registro de Tipo 3: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('010', 3) +
                               AddTxt(Vendor.Name, 21) +                                           //IBAN
                               AddDat8(tmpCarteraDoc."Due Date") +                                 //Fecha vencimiento
                               AddSpc(41);                                                        //Libre

                3:
                    OutText := AddTxt('0659', 4) +                                                 //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('011', 3) +
                               AddTxt(VendorAddress, 70) +                                        //Nombre proveedor
                               AddSpc(118);                                                       //Libre

                4:
                    OutText := AddTxt('0659', 4) +                                                 //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('012', 3) +
                               AddTxt(Vendor."Post Code", 5) +                                     // proveedor
                               AddTxt(Vendor.City, 40) +
                               AddSpc(118);                                                       //Libre


                5:
                    OutText := AddTxt('0659', 4) +                                                 //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('013', 3) +
                               AddTxt(Vendor."Post Code", 5) +
                               AddTxt(Vendor.City, 40) +
                               AddSpc(118);

                6:
                    OutText := AddTxt('0659', 4) +                                                 //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                     //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                        //NIF proveedor
                               AddTxt('014', 3) +
                               AddTxt(VendorIBAN, 12) +
                               AddSpc(118);

                7:
                    OutText := AddTxt('0659', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato/Sufijo
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('015', 3) +
                               AddTxt(VendorIBAN, 12) + 'H2021' + '/' + tmpCarteraDoc."External Document No." + '-' + FORMAT(tmpCarteraDoc."Document Date") +
                               AddSpc(118);

                8:
                    OutText := AddTxt('0859', 4) +
                              AddInt(Totales[1], 12) +                                           //Total ¢rdenes
                              AddAmount(Totales[2], 15, 2) +                                     //Total importe
                              AddSpc(221);

            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_16(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Bco. Cooperativo

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                4:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N§ Contrato/Sufijo
                               AddTxt('001', 3) +                                                 //Valor Fijo
                               AddDat6(gPostingDate, 0) +                                         //Fecha de la remesa
                               AddDat6(gPostingDate, 0) +                                         //Fecha de la remesa
                               AddTxt(BankAcc."CCC Bank No.", 4) +                                 //Banco Empresa POR HACER
                               AddTxt(BankAcc."CCC Bank Branch No.", 4) +                          //Sucursal Empresa
                               AddTxt(BankAcc."CCC Bank Account No.", 10) +                        //Cuenta empresa
                               AddSpc(4) +                                                        //Libre
                               AddTxt(BankAcc."CCC Control Digits", 2) +                          //Digito Control Empresa
                               AddSpc(7);                                                        //Libre

                2:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N§ Contrato/Sufijo
                               AddTxt('002', 3) +                                                 //Valor Fijo
                               AddTxt(Company_Name, 36) +                                         //Nombre del Ordenante
                               AddSpc(7);                                                        //Libre

                3:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N§ Contrato/Sufijo
                               AddTxt('003', 3) +                                                 //Valor Fijo
                               AddTxt(Company_Adress, 36) +                                       //Direcci�n del Ordenante
                               AddSpc(7);                                                        //Libre

                4:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddSpc(12) +                                                       //Libre
                               AddTxt('004', 3) +                                                 //Valor Fijo
                               AddTxt(CompanyInfo."Post Code", 10) +                              //Codigo Postal Ordenante
                               AddTxt(CompanyInfo.City, 31) +                                      //Plaza ordenante
                               AddSpc(2);                                                        //Libre

                5:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 3: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('010', 3) +                                                 //Valor Fijo
                               AddAmountB(tmpCarteraDoc."Remaining Amount", 12, 2) +                //Importe Factura
                               AddTxt(DELCHR(VendorIBAN, '=', 'ES'), 18) +                          //Cuenta Beneficiario
                               AddSpc(1) +                                                        //Libre
                               AddTxt('+', 1) +                                                    //Signo Importe
                               AddSpc(2) +                                                        //Libre
                               AddTxt('DC', 2) +                                                   //DC Beneficiario POR HACER
                               AddSpc(7);                                                        //Libre

                6:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('011', 3) +                                                 //Valor Fijo
                               AddTxt(VendorName, 36) +                                           //Nombre proveedor
                               AddSpc(7);                                                        //Libre

                7:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('012', 3) +                                                 //Valor Fijo
                               AddTxt(VendorAddress, 37) +                                        //Direcci�n del proveedor
                               AddSpc(6);                                                        //Libre

                8:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('014', 3) +                                                  //Valor Fijo
                               AddTxt(Vendor."Post Code", 5) +                                    //Codigo Postal proveedor
                               AddTxt(Vendor.City, 20) +                                          //Plaza Proveedor
                               AddSpc(18);                                                       //libre

                9:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('018', 3) +                                                 //Valor Fijo
                               AddDat6(tmpCarteraDoc."Due Date", 0) +                              //Vencimiento factura
                               AddTxt(tmpCarteraDoc."External Document No.", 11) +                 //N�mero factura
                               AddTxt(Vendor."Phone No.", 10) +                                    //Telefono Beneficiario
                               AddTxt(Vendor."Fax No.", 10) +                                      //Fax beneficiario
                               AddDat6(tmpCarteraDoc."Document Date", 0);                         //Fecha Emisi�n

                10:
                    OutText := AddTxt('0856', 4) +                                               //Registro de Tipo 4:TOTALES
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                 //NIF ordenante
                               AddSpc(15) +                                                     //Libre
                               AddInt(Totales[1], 12) +                                        //Total ¢rdenes
                               AddSpc(8) +                                                      //Detalles
                               AddAmount(Totales[2], 10, 2) +                                   //Total importe
                               AddSpc(13);                                                     //Libre

            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_17(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Targobank

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                4:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('1370', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 3) +                      //Codigo Ordenante
                               AddSpc(9) +                                                        //Libre
                               AddTxt('001', 3) +                                                  //Valor Fijo
                               AddDat8T(FORMAT(gPostingDate)) +                                   //Fecha soporte
                               AddDat8T(FORMAT(gPostingDate)) +                                   //Fecha soporte
                               AddTxt(BankAcc."CCC Bank No.", 4) +                                 //Banco Empresa
                               AddTxt(BankAcc."CCC Bank Branch No.", 4) +                         //Sucursal Empresa
                               AddTxt(BankAcc."CCC Bank Account No.", 10) +                        //Cuenta Empresa
                               AddSpc(4) +                                                        //Libre
                               AddTxt(BankAcc."CCC Control Digits", 2) +                           //Digito Control
                               AddSpc(3);                                                        //Libre

                2:
                    OutText := AddTxt('1370', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato
                               AddSpc(9) +                                                        //Libre
                               AddTxt('002', 3) +                                                  //Campo Fijo
                               AddTxt(Company_Name, 36) +                                         //Nombre del Ordenante
                               AddSpc(7);                                                        //Libre

                3:
                    OutText := AddTxt('1370', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato
                               AddSpc(9) +                                                        //Libre
                               AddTxt('003', 3) +                                                  //Valor Fijo
                               AddTxt(Company_Adress, 36) +                                       //Direcci�n del Ordenante
                               AddSpc(7);                                                        //Libre

                4:
                    OutText := AddTxt('1370', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 10) +                    //N§ Contrato
                               AddSpc(9) +                                                        //Libre
                               AddTxt('004', 3) +                                                 //Valor Fijo
                               AddTxt(CompanyInfo.City, 36) +                                     //Plaza Ordenante
                               AddSpc(7);                                                        //Libre

                5:
                    OutText := AddTxt('1670', 4) +                                                //Registro de Tipo 3: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('010', 3) +                                                 //Valor Fijo
                               AddAmountB(tmpCarteraDoc."Remaining Amount", 12, 2) +               //Importe Factura
                                                                                                   //Proveedor Banco Beneficiario POR HACER
                                                                                                   //Proveedor Sucursal beneficiario POR HACER
                               AddSpc(1) +                                                        //Libre
                                                                                                  //FP_POPULAR POR HACER
                               AddSpc(1) +                                                        //Libre
                                                                                                  //DC Beneficiario POR HACER
                               AddSpc(8);                                                        //Libre

                6:
                    OutText := AddTxt('1670', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('011', 3) +                                                 //Valor Fijo
                               AddTxt(VendorName, 36) +                                           //Nombre proveedor
                               AddSpc(7);                                                        //Libre

                7:
                    OutText := AddTxt('1670', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('012', 3) +                                                 //Valor Fijo
                               AddTxt(VendorAddress, 70) +                                       //Nombre proveedor
                               AddSpc(118);                                                      //Libre

                8:
                    OutText := AddTxt('1670', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('014', 3) +                                                  //Valor Fijo
                               AddTxt(Vendor."Post Code", 5) +                                    //Codigo Postal beneficiario
                               AddTxt(Vendor.City, 31) +                                          //Plaza Beneficiario
                               AddSpc(7);

                9:
                    OutText := AddTxt('1770', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 12) +                       //NIF proveedor
                               AddTxt('100', 3) +                                                 //Valor Fijo
                               AddDat8(gPostingDate) +                                            //Fecha emisi�n
                               AddDat8(tmpCarteraDoc."Due Date") +                                //Fecha vencimiento
                               AddTxt(tmpCarteraDoc."External Document No.", 14) +                 //Numero Factura
                               AddAmountB(tmpCarteraDoc."Remaining Amount", 12, 2) +                //Importe Factura
                               AddTxt('+', 1);                                                    //Signo Factura

                10:
                    OutText := AddTxt('1870', 4) +                                               //Registro Totales
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                 //NIF ordenante
                               AddSpc(15) +                                                   //Libre
                               AddInt(Totales[1], 12) +                                        //Total ¢rdenes
                               AddSpc(8) +                                                   //Detalles
                               AddAmount(Totales[2], 10, 2) +                                   //Total importe
                               AddSpc(13);
            END;

            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_18(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Caja Mar     ___

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                4:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N§ Contrato/Sufijo
                               AddTxt('001', 3) +                                                 //Valor Fijo
                               AddDat6(gPostingDate, 0) +                                         //Fecha de la remesa
                               AddDat6(gPostingDate, 0) +                                         //Fecha de la remesa
                               AddTxt(BankAcc."CCC Bank No.", 4) +                                 //Banco Empresa POR HACER
                               AddTxt(BankAcc."CCC Bank Branch No.", 4) +                          //Sucursal Empresa POR HACER
                               AddTxt(BankAcc."CCC Bank Account No.", 10) +                        //Cuenta empresa POR HACER
                               AddSpc(4) +                                                        //Libre
                               AddTxt(BankAcc."CCC Control Digits", 2) +                          //Digito Control Empresa
                               AddSpc(7);                                                        //Libre

                2:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N§ Contrato/Sufijo
                               AddTxt('002', 3) +                                                 //Valor Fijo
                               AddTxt(Company_Name, 36) +                                         //Nombre del Ordenante
                               AddSpc(7);                                                        //Libre

                3:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(BankAcc."Confirming Contract No.", 12) +                    //N§ Contrato/Sufijo
                               AddTxt('003', 3) +                                                 //Valor Fijo
                               AddTxt(Company_Adress, 36) +                                       //Direcci�n del Ordenante
                               AddSpc(7);                                                        //Libre

                4:
                    OutText := AddTxt('0356', 4) +                                                //Registro de Tipo 1: CABECERA
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddSpc(12) +                                                       //Libre
                               AddTxt('004', 3) +                                                 //Valor Fijo
                               AddTxt(CompanyInfo."Post Code", 10) +                              //Codigo Postal Ordenante
                               AddTxt(CompanyInfo.City, 31) +                                      //Plaza ordenante
                               AddSpc(2);                                                        //Libre

                5:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 3: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('010', 3) +                                                 //Valor Fijo
                               AddAmountB(tmpCarteraDoc."Remaining Amount", 12, 2) +                //Importe Factura
                               AddTxt(DELCHR(VendorIBAN, '=', 'ES'), 18) +                          //Cuenta Beneficiario
                               AddSpc(1) +                                                        //Libre
                               AddTxt('+', 1) +                                                    //Signo Importe
                               AddSpc(2) +                                                        //Libre
                               AddTxt('DC', 2) +                                                   //DC Beneficiario POR HACER
                               AddSpc(7);                                                        //Libre

                6:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('011', 3) +                                                 //Valor Fijo
                               AddTxt(VendorName, 36) +                                           //Nombre proveedor
                               AddSpc(7);                                                        //Libre

                7:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('012', 3) +                                                 //Valor Fijo
                               AddTxt(VendorAddress, 37) +                                        //Direcci�n del proveedor
                               AddSpc(6);                                                        //Libre

                8:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('014', 3) +                                                  //Valor Fijo
                               AddTxt(Vendor."Post Code", 5) +                                    //Codigo Postal proveedor
                               AddTxt(Vendor.City, 20) +                                          //Plaza Proveedor
                               AddSpc(18);                                                       //libre

                9:
                    OutText := AddTxt('0651', 4) +                                                //Registro de Tipo 4: DATOS PROVEEDOR
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                   //NIF ordenante
                               AddTxt(Vendor."VAT Registration No.", 10) +                       //NIF proveedor
                               AddSpc(2) +                                                        //Libre
                               AddTxt('018', 3) +                                                 //Valor Fijo
                               AddDat6(tmpCarteraDoc."Due Date", 0) +                              //Vencimiento factura
                               AddTxt(tmpCarteraDoc."External Document No.", 11) +                 //N�mero factura
                               AddTxt(Vendor."Phone No.", 10) +                                    //Telefono Beneficiario
                               AddTxt(Vendor."Fax No.", 10) +                                      //Fax beneficiario
                               AddDat6(tmpCarteraDoc."Document Date", 0);                         //Fecha Emisi�n

                10:
                    OutText := AddTxt('0856', 4) +                                               //Registro de Tipo 4:TOTALES
                               AddTxt(CompanyInfo."VAT Registration No.", 10) +                 //NIF ordenante
                               AddSpc(15) +                                                     //Libre
                               AddInt(Totales[1], 12) +                                        //Total ¢rdenes
                               AddSpc(8) +                                                      //Detalles
                               AddAmount(Totales[2], 10, 2) +                                   //Total importe
                               AddSpc(13);                                                     //Libre

            END;
            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE AddReg_19(pNro: Integer; pGenerar: Boolean);
    BEGIN
        //FORMATO: Confirming Unicaja

        IsConfirming := TRUE;

        IF (NOT pGenerar) THEN BEGIN
            CASE pNro OF
                3:
                    Totales[1] += 1;
                4:
                    Totales[2] += tmpCarteraDoc."Remaining Amount";
            END;
        END ELSE BEGIN
            CASE pNro OF
                1:
                    OutText := AddTxt('10', 2) +                                                 //Registro de Tipo 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 20) +                   //N§ Contrato/Sufijo
                               AddTxt('34', 2) +                                                 //Valor Fijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                  //Valor Fijo
                               AddTxt('Identificador de Fichero', 10) +                           //Por hacer
                               AddDat8T(FORMAT(gPostingDate)) +                                  //Fecha soporte
                               AddSpc(34) +                                                      //Libre
                               AddTxt('EUR', 3) +                                                //Divisa Cuenta POR HACER
                               AddSpc(259);                                                     //Libre

                2:
                    OutText := AddTxt('11', 2) +                                                 //Registro de Tipo 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 20) +                   //N§ Contrato/Sufijo
                               AddTxt('34', 2) +                                                 //Valor Fijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                  //Nif Ordenante
                               AddTxt('Identificador de Fichero', 10) +                           //Por hacer
                               AddTxt('ES', 2) +                                                  //Valor Fijo
                               AddTxt(Vendor."VAT Registration No.", 9) +                         //Nif beneficiario
                               AddTxt('000', 3) +                                                 //Valor Fijo
                               AddTxt(Vendor.Name, 50) +                                          //Nombre Beneficiario
                               AddTxt(Vendor.Address, 50) +                                       //Direcci�n Beneficiario
                               AddTxt(Vendor.City, 50) +                                          //Plaza Beneficiario
                               AddTxt(Vendor."Post Code", 10) +                                   //Codigo Postal Beneficiario
                               AddSpc(15) +                                                      //Libre
                               AddSpc(10) +                                                      //Libre
                               AddSpc(15) +                                                      //Libre
                               AddSpc(12) +                                                      //Libre
                               AddTxt(VendorIBAN, 34) +                                           //IBAN Beneficiario
                               AddTxt(VendorSWIFT, 11) +                                          //SWIFT Beneficiario
                               AddSpc(33);                                                      //Libre

                3:
                    OutText := AddTxt('12', 3) +                                                 //Registro de Tipo 1: CABECERA
                               AddTxt(BankAcc."Confirming Contract No.", 20) +                   //N§ Contrato/Sufijo
                               AddTxt('34', 2) +                                                 //Valor Fijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                  //NIF ordenante
                               AddTxt('Identificador de Fichero', 10) +                           //Por hacer
                               AddTxt(tmpCarteraDoc."External Document No.", 15) +                //Numero de Factura
                               AddTxt(tmpCarteraDoc."Currency Code", 3) +                         //Divisa Factura POR HACER
                               AddAmountB(tmpCarteraDoc."Remaining Amount", 13, 2) +               //Importe factura
                               AddDat8(tmpCarteraDoc."Document Date") +                          //Fecha Emisi�n
                               AddDat8(tmpCarteraDoc."Due Date") +                               //Fecha Vencimiento
                               AddTxt('Tipo Documento', 1) +                                      //TIPO Documento POR HACER
                               AddSpc(32) +                                                      //Libre
                               AddSpc(6) +                                                       //Libre
                               AddSpc(218);                                                     //Libre


                4:
                    OutText := AddTxt('13', 2) +                                                 //Registro Totales
                               AddTxt(BankAcc."Confirming Contract No.", 20) +                  //N§ Contrato
                               AddTxt('34', 2) +                                                //Valor Fijo
                               AddTxt(CompanyInfo."VAT Registration No.", 12) +                 //NIF ordenante
                               AddTxt('Identificador de Fichero', 10) +                          //Por hacer
                               AddInt(Totales[1], 6) +                                          //Total ¢r1denes
                               AddAmount(Totales[2], 13, 2) +                                   //Total importe
                               AddSpc(285);
            END;

            OutFile.WRITE(OutText);
        END;
    END;

    LOCAL PROCEDURE "----------------------------------- Funciones auxiliares"();
    BEGIN
    END;

    LOCAL PROCEDURE Trim(pText: Text): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna un texto sin espacios por la izquierda o la derecha
        pText := DELCHR(pText, '<>', ' ');
        EXIT(pText);
    END;

    LOCAL PROCEDURE MountTxt(pText1: Text; pText2: Text): Text;
    BEGIN
        //Une dos cadenas por un espacio, eliminando espacios de ambas por delante y por detr�s, luego vuelve a quitar espacios por detr�s por si la segunda est� vac�a
        EXIT(Trim(Trim(pText1) + ' ' + Trim(pText2)));
    END;

    LOCAL PROCEDURE AddTxt(pText: Text; Len: Integer): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna un texto de una longitud m xima ajustado a la izquierda y completado con espacios a la derecha
        pText := Trim(pText);
        IF (STRLEN(pText) < Len) THEN
            EXIT(PADSTR(pText, Len, ' '))
        ELSE
            EXIT(COPYSTR(pText, 1, Len));
    END;

    LOCAL PROCEDURE AddTxtN(pText: Text; Len: Integer): Text;
    VAR
        txt: Text;
        c: Text;
        i: Integer;
    BEGIN
        //Retorna un texto de una longitud m�xima ajustado a la izquierda y completado con espacios a la derecha, que solo contiene n�meros
        txt := '';
        FOR i := 1 TO STRLEN(pText) DO BEGIN
            c := COPYSTR(pText, i, 1);
            IF (c IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) THEN
                txt += c;
        END;
        EXIT(AddTxt(txt, Len));
    END;

    LOCAL PROCEDURE AddNum(pText: Text; Len: Integer): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna un texto de una longitud m xima completado con ceros a la derecha
        IF (STRLEN(pText) < Len) THEN
            EXIT(PADSTR(pText, Len, '0'))
        ELSE
            EXIT(COPYSTR(pText, 1, Len));
    END;

    LOCAL PROCEDURE AddInt(pInteger: Decimal; Len: Integer): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna un n£mero entero con una longitud maxima relleno a ceros por la izquierda
        txt := FORMAT(pInteger);
        txt := DELCHR(txt, '=', '.');
        IF (STRLEN(txt) < Len) THEN
            txt := PADSTR('', Len - STRLEN(txt), '0') + txt;
        EXIT(txt);
    END;

    LOCAL PROCEDURE AddSAmount(pAmount: Decimal; Len: Integer; Dec: Integer; Sgn: Integer): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna un n£mero decimal con una longitud maxima MENOS UNO relleno a ceros por la izquierda
        //dentro de esa longitud se indican cuantas posiciones decimales tiene, rellenas con ceros a la derecha
        //Si Sgn es cero le a�ade delante el signo, si es 1 se lo a�ade detras

        txt := AddAmount(pAmount, Len - 1, Dec);
        IF (Sgn = 0) THEN
            EXIT(AddSignoP(pAmount) + txt)
        ELSE
            EXIT(txt + AddSignoP(pAmount));
    END;

    LOCAL PROCEDURE AddAmount(pAmount: Decimal; Len: Integer; Dec: Integer): Text;
    VAR
        txt1: Text;
        txt2: Text;
        coma: Integer;
    BEGIN
        //Retorna un n£mero decimal con una longitud maxima relleno a ceros por la izquierda
        //dentro de esa longitud se indican cuantas posiciones decimales tiene, rellenas con ceros a la derecha
        txt1 := FORMAT(ABS(pAmount));
        txt2 := '0';
        coma := STRPOS(txt1, ',');
        IF (coma <> 0) THEN BEGIN
            txt2 := COPYSTR(txt1, coma + 1);
            txt1 := COPYSTR(txt1, 1, coma - 1);
        END;

        txt2 := PADSTR(txt2, Dec, '0');

        txt1 := DELCHR(txt1, '=', '.') + COPYSTR(txt2, 1, Dec);
        IF (STRLEN(txt1) < Len) THEN
            txt1 := PADSTR('', Len - STRLEN(txt1), '0') + txt1;

        EXIT(COPYSTR(txt1, 1, Len));
    END;

    LOCAL PROCEDURE AddSignoP(pAmount: Decimal): Text;
    VAR
        txt1: Text;
        txt2: Text;
        coma: Integer;
    BEGIN
        //Retorna de un n£mero decimal su signo (+/-)
        IF (pAmount >= 0) THEN
            EXIT('+')
        ELSE
            EXIT('-');
    END;

    LOCAL PROCEDURE AddSignoB(pAmount: Decimal): Text;
    VAR
        txt1: Text;
        txt2: Text;
        coma: Integer;
    BEGIN
        //Retorna de un n£mero decimal su signo (" "/-)
        IF (pAmount >= 0) THEN
            EXIT(' ')
        ELSE
            EXIT('-');
    END;

    LOCAL PROCEDURE AddDat8T(pDate: Text): Text;
    BEGIN
        //Retorna una fecha que se remite en formato texto
        CASE STRLEN(pDate) OF
            8:
                EXIT('20' + COPYSTR(pDate, 7, 2) + COPYSTR(pDate, 4, 2) + COPYSTR(pDate, 1, 2));
            10:
                EXIT(COPYSTR(pDate, 7, 4) + COPYSTR(pDate, 4, 2) + COPYSTR(pDate, 1, 2));
        END;
        EXIT(PADSTR('', 8, ' '));
    END;

    LOCAL PROCEDURE AddDat8(pDate: Date): Text;
    BEGIN
        //Retorna una fecha con formato AAAAMMDD, si no est  informada retorna 8 espacios
        IF (pDate = 0D) THEN
            EXIT(PADSTR('', 8, ' '))
        ELSE
            EXIT(FORMAT(pDate, 0, '<Year4><month,2><Day,2>'));
    END;

    LOCAL PROCEDURE AddDat6(pDate: Date; pFormato: Option): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna una fecha con 6 caracteres de longitud, si no est  informada retorna 6 espacios
        //Formato 0: AAMMDD
        //Formato 1: DDMMAA
        txt := AddDat8(pDate);
        CASE pFormato OF
            0:
                EXIT(COPYSTR(txt, 3));
            1:
                EXIT(COPYSTR(txt, 7, 2) + COPYSTR(txt, 5, 2) + COPYSTR(txt, 3, 2));
        END;
    END;

    LOCAL PROCEDURE AddBol(pBool: Boolean): Text;
    BEGIN
        //Retorna un booleano (S/N)
        IF (pBool) THEN
            EXIT('S')
        ELSE
            EXIT('N');
    END;

    LOCAL PROCEDURE AddSpc(Len: Integer): Text;
    VAR
        txt: Text;
    BEGIN
        //Retorna una cadena de los espacios indicados
        EXIT(AddTxt('', Len));
    END;

    LOCAL PROCEDURE AddAmountB(pAmount: Decimal; Len: Integer; Dec: Integer): Text;
    VAR
        txt1: Text;
        txt2: Text;
        coma: Integer;
    BEGIN
        //Retorna un n£mero decimal con una longitud maxima relleno a ceros por la izquierda
        //dentro de esa longitud se indican cuantas posiciones decimales tiene, rellenas con ceros a la derecha
        txt1 := FORMAT(ABS(pAmount));
        txt2 := ' ';
        coma := STRPOS(txt1, ',');
        IF (coma <> 0) THEN BEGIN
            txt2 := COPYSTR(txt1, coma + 1, 2);
            txt1 := COPYSTR(txt1, 1, coma - 1);
        END;

        IF txt2 = ' ' THEN
            txt2 := '00';

        txt1 := DELCHR(txt1, '=', '.') + ',' + COPYSTR(txt2, 1, Dec);



        IF (STRLEN(txt1) < Len) THEN
            txt1 := PADSTR('', Len - STRLEN(txt1), ' ') + txt1;

        EXIT(COPYSTR(txt1, 1, Len) + ' ');
    END;


    /*BEGIN
    /*{
          JAV 20/01/20: - Formatos est ndar de confiming
          JAV 08/11/20: - QB 1.06.19 Se amplia para que pueda usarse con agrupaci�n de efectos y mas tipos de formato
                            01 (50052) Formato Estandar Confirming
                            02 (50053) Emision Cheque/Pagare Sabadell
                            03 (50051) Confirming Bankinter (parece que tambi�n funciona en Banesto)
                            04 (50054) Confirming Sabadell BS
                            05 (50055) Confirming Bankia 2
                            06 (50056) Confirming La Caixa
                            07 (50057) Confirming Bankia  --> Es el mismo formato que el de La Caixa
                            08 (50058) Confirming BBVA
                            09 (50059) Confirming Deutsche Bank
                            10 (50060) Confirming Santander 1
                            11 (50061) Confirming Santander 2
                               (50062) Confirming BBVA OP Reg   ---> Se elimina por no necesario, ahora todos se pueden generar desde O.P. Registradas
          AMAPALA 14/03/21: Se a�aden mas bancos
                            12 (50063) Confirming Novobanco
                            13 (50064) Confirming Ibercaja
                            14 (50065) Confirming Abanca
                            15 (50066) Confirming Liberbank
                            16 (50067) Confirming Bco. Cooperativo
                            17 (50068) Confirming Targobank
                            18 (50069) Confirming Caja Mar
                            19 (50070) Confirming Unicaja

          JAV 14/09/21: - QB 1.09.17 Se reforman las funciones para que no sean necesarios los reports para lanzar los formatos.
                                     Se renumeran los c�digos para que comiencen en uno.
          JAV 13/12/21: - QB 1.10.07 En el formato est�ndar de confirming se informa de la fecha de pr¢rroga/aplazamiento/cargo si es de tipo Pronto Pago
        }
    END.*/
}










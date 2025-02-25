report 50079 "Confirming Bankia Inesco"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Payment Order"; "Payment Order")
        {



            RequestFilterFields = "No.";
            DataItem("Cartera Doc."; "Cartera Doc.")
            {

                DataItemTableView = SORTING("Type", "Bill Gr./Pmt. Order No.", "Category Code", "Currency Code", "Accepted", "Due Date")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Payable"));
                DataItemLink = "Bill Gr./Pmt. Order No." = FIELD("No.");
                trigger OnAfterGetRecord();
                BEGIN
                    TESTFIELD("Account No.");
                    Vendor.GET("Account No.");
                    Comaactivada := FALSE;

                    CarteradocAmount := ROUND("Remaining Amount");

                    IF CarteradocAmount < 0 THEN
                        TextAmountCart := '-' + FORMAT(CarteradocAmount, 0, 1)
                    ELSE
                        TextAmountCart := FORMAT(CarteradocAmount, 0, 1);
                    DigDespuescoma := 0;
                    FOR i := 1 TO STRLEN(TextAmountCart) DO BEGIN
                        IF Comaactivada THEN
                            DigDespuescoma += 1;
                        IF (TextAmountCart[i] = ',') OR (TextAmountCart[i] = '.') THEN BEGIN
                            PosicionComa := i;
                            Comaactivada := TRUE;
                        END;
                    END;
                    IF PosicionComa <> 0 THEN BEGIN
                        Antescoma := COPYSTR(TextAmountCart, 1, PosicionComa - 1);
                        despuescoma := COPYSTR(TextAmountCart, PosicionComa + 1, STRLEN(TextAmountCart));
                        TextAmountCart := Antescoma + despuescoma;
                        IF DigDespuescoma = 0 THEN
                            TextAmountCart := TextAmountCart + '00'
                        ELSE IF DigDespuescoma = 1 THEN
                            TextAmountCart := TextAmountCart + '0';
                    END ELSE
                        TextAmountCart := TextAmountCart + '00';

                    TESTFIELD("Payment Method Code");
                    //DocType2 :=  DocMisc.DocType2("Payment Method Code");
                    DocType2 := GetDocType("Payment Method Code");
                    TotalRemAmount += "Remaining Amount";
                    TotalReg += 1;

                    TotalRemAmountText := FORMAT(TotalRemAmount, 0, 1);
                    PosicionComa := 0;
                    DigDespuescoma := 0;
                    Comaactivada := FALSE;
                    FOR i := 1 TO STRLEN(TotalRemAmountText) DO BEGIN
                        IF Comaactivada THEN
                            DigDespuescoma += 1;
                        IF (TotalRemAmountText[i] = ',') OR (TotalRemAmountText[i] = '.') THEN BEGIN
                            PosicionComa := i;
                            Comaactivada := TRUE;
                        END;
                    END;
                    IF PosicionComa <> 0 THEN BEGIN
                        Antescoma := COPYSTR(TotalRemAmountText, 1, PosicionComa - 1);
                        despuescoma := COPYSTR(TotalRemAmountText, PosicionComa + 1, STRLEN(TotalRemAmountText));
                        TotalRemAmountText := Antescoma + despuescoma;
                        IF DigDespuescoma = 0 THEN
                            TotalRemAmountText := TotalRemAmountText + '00'
                        ELSE IF DigDespuescoma = 1 THEN
                            TotalRemAmountText := TotalRemAmountText + '0';
                    END ELSE
                        TotalRemAmountText := TotalRemAmountText + '00';

                    // Registros del Beneficiario
                    IF (Vendor."Country/Region Code" = 'ES') OR (Vendor."Country/Region Code" = '') OR (Vendor."Country/Region Code" = CompanyInfo."Country/Region Code") THEN BEGIN
                        VATRegVend := Vendor."VAT Registration No.";
                        IsResident := 'N';
                    END ELSE BEGIN
                        VATRegVend := Vendor."VAT Registration No.";
                        IsResident := 'S';
                    END;

                    VendBankAccCode := "Cust./Vendor Bank Acc. Code";
                    IF VendBankAcc.GET("Account No.", VendBankAccCode) THEN BEGIN
                        VendCCCAccNo := VendBankAcc."CCC Bank Account No.";
                        VendCCCControlDigits := VendBankAcc."CCC Control Digits";
                        Vendor2 := VendBankAcc."CCC Bank No.";
                        VendCCCBankBranchNo := VendBankAcc."CCC Bank Branch No.";
                        VendSWIFTCode := VendBankAcc."SWIFT Code";
                        IF IsResident = 'S' THEN
                            IF (Vendor2 = '') OR (VendCCCBankBranchNo = '') OR (VendCCCControlDigits = '') OR (VendCCCAccNo = '') OR (VendSWIFTCode = '') THEN
                                ERROR(Text004, VendBankAcc."Vendor No.");
                    END ELSE BEGIN
                        VendCCCAccNo := '';
                        VendCCCControlDigits := '';
                        Vendor2 := '';
                        VendCCCBankBranchNo := '';
                        VendSWIFTCode := '';
                    END;

                    ComunRegBeneficiary := '06' + '56' + UPPERCASE(StuffingText(VATRegNo, 10, PreviousPost::Post, ' ')) + UPPERCASE(StuffingText(VATRegVend, 12, PreviousPost::Post, ' '));

                    RegCuaderno += 1;
                    OutText := ComunRegBeneficiary + '010' + StuffingText(TextAmountCart, 12, PreviousPost::Prev, '0') + StuffingText(Vendor2, 4, PreviousPost::Post, '0') +
                            StuffingText(VendCCCBankBranchNo, 4, PreviousPost::Post, '0') + StuffingText(VendCCCAccNo, 10, PreviousPost::Post, '0') + '1' + '9' +
                            StuffingText(TextLibre, 2, PreviousPost::Post, ' ') + StuffingText(VendCCCControlDigits, 2, PreviousPost::Post, '0') + IsResident + ' ' +
                            StuffingText(Curr, 3, PreviousPost::Post, ' ') + StuffingText(TextLibre, 2, PreviousPost::Post, ' ');    // ðð Tipo de registro 10
                    OutFile.WRITE(OutText);

                    IF IsResident = 'S' THEN BEGIN

                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '043' + StuffingText(Vendor."Country/Region Code", 2, PreviousPost::Post, ' ') + StuffingText(CCCControlDigits, 2, PreviousPost::Post, ' ') +
                                StuffingText(CCCAccNo, 30, PreviousPost::Post, ' ') + '7' + StuffingText(TextLibre, 8, PreviousPost::Post, ' '); // ðð Tipo de registro 43
                        OutFile.WRITE(OutText);

                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '044' + '1' + StuffingText(Vendor."Country/Region Code", 2, PreviousPost::Post, ' ') + StuffingText(TextLibre, 6, PreviousPost::Post, ' ') +
                                StuffingText(VendSWIFTCode, 12, PreviousPost::Post, ' ') + StuffingText(TextLibre, 22, PreviousPost::Post, ' '); // ðð Tipo de registro 44
                        OutFile.WRITE(OutText);
                    END;

                    // Tipo de registro 45 - OPCIONAL si Vendor es NO residente
                    // Tipo de registro 46 - OPCIONAL (fecha financiaci¢n efecto)

                    RegCuaderno += 1;
                    OutText := ComunRegBeneficiary + '011' + UPPERCASE(StuffingText(Vendor.Name, 36, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' '); // ðð Tipo de registro 11
                    OutFile.WRITE(OutText);

                    IF STRLEN(Vendor.Address) > 36 THEN BEGIN
                        VendAdress := COPYSTR(Vendor.Address, 1, 36);
                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '012' + UPPERCASE(VendAdress) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');  // ðð Tipo de registro 12
                        OutFile.WRITE(OutText);

                        VendAdress2 := COPYSTR(Vendor.Address, 37, 50);
                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '013' + UPPERCASE(StuffingText(VendAdress2, 36, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');  // ðð Tipo de registro 13
                        OutFile.WRITE(OutText);
                    END ELSE BEGIN
                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '012' +
                                UPPERCASE(StuffingText(Vendor.Address, 36, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');  // ðð Tipo de registro 12
                        OutFile.WRITE(OutText);
                    END;

                    RegCuaderno += 1;
                    OutText := ComunRegBeneficiary + '014' +
                            UPPERCASE(StuffingText(Vendor."Post Code", 5, PreviousPost::Post, ' ')) + UPPERCASE(StuffingText(Vendor.City, 31, PreviousPost::Post, ' ')) +
                            StuffingText(TextLibre, 7, PreviousPost::Post, ' '); // ðð Tipo de registro 14
                    OutFile.WRITE(OutText);

                    IF IsResident = 'S' THEN BEGIN
                        Vendor.TESTFIELD("Country/Region Code");
                        CountryRegion.GET(Vendor."Country/Region Code");

                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '015' +
                                StuffingText(Vendor."No.", 15, PreviousPost::Post, ' ') + StuffingText(TextLibre, 12, PreviousPost::Prev, ' ') + ' ' +
                                StuffingText(Vendor."Country/Region Code", 2, PreviousPost::Post, ' ') + UPPERCASE(StuffingText(CountryRegion.Name, 9, PreviousPost::Post, ' ')) +
                                StuffingText(TextLibre, 4, PreviousPost::Post, ' '); // ðð Tipo de registro 15
                        OutFile.WRITE(OutText);
                    END;

                    IF "Cartera Doc."."Cust./Vendor Bank Acc. Code" <> '' THEN
                        PaymentType := 'T'
                    ELSE
                        PaymentType := 'C';

                    "Cartera Doc.".CALCFIELDS("External Document No.");
                    IF "Cartera Doc."."External Document No." <> '' THEN
                        IF STRLEN("Cartera Doc."."External Document No.") > 15 THEN
                            DocNo := COPYSTR("Cartera Doc."."External Document No.", STRLEN("Cartera Doc."."External Document No.") - 14, STRLEN("Cartera Doc."."External Document No."))
                        ELSE
                            DocNo := "Cartera Doc."."External Document No."
                    ELSE
                        IF STRLEN("Cartera Doc."."Document No.") > 15 THEN
                            DocNo := COPYSTR("Cartera Doc."."Document No.", STRLEN("Cartera Doc."."Document No.") - 14, STRLEN("Cartera Doc."."Document No."))
                        ELSE
                            DocNo := "Cartera Doc."."Document No.";

                    RegCuaderno += 1;
                    OutText := ComunRegBeneficiary + '016' + PaymentType + FORMAT("Posting Date", 0, '<Day,2><month,2><Year,2>') + StuffingText(DocNo, 15, PreviousPost::Post, ' ') +
                            FORMAT("Due Date", 0, '<Day,2><month,2><Year,2>') + StuffingText(TextLibre, 8, PreviousPost::Post, ' ') + StuffingText(TextLibre, 7, PreviousPost::Post, ' '); // ðð Tipo de registro 16
                    OutFile.WRITE(OutText);

                    // Tipo de registro 17 - OPCIONAL

                    IF IsResident = 'S' THEN BEGIN
                        RegCuaderno += 1;
                        OutText := ComunRegBeneficiary + '018' +
                                StuffingText(Vendor."Phone No.", 15, PreviousPost::Post, ' ') + StuffingText(Vendor."Fax No.", 15, PreviousPost::Prev, ' ') + StuffingText(TextLibre, 6, PreviousPost::Post, ' ') +
                                StuffingText(TextLibre, 7, PreviousPost::Post, ' '); // ðð Tipo de registro 18
                        OutFile.WRITE(OutText);
                    END;

                    // Tipo de registro 19 - OPCIONAL
                    // Tipo de registro 20 - OPCIONAL

                    IF IsResident = 'S' THEN BEGIN
                        IF 'Clase de Pago' = '01-Mercancias' THEN
                            PaymentClass := '01'
                        ELSE IF 'Clase de Pago' = '02-Servicios' THEN
                            PaymentClass := '02';

                        // Tipo de registro 55 - NO SE DEBE usar

                        // {OutText := ComunRegBeneficiary + '055' + PaymentClass + StuffingText('Cod estadistico CIN',6,PreviousPost::Post,' ') + StuffingText(Vendor."Country/Region Code",2,PreviousPost::Post,' ') +
                        //         StuffingText('NIF Beneficiario',9,PreviousPost::Post,' ') + StuffingText('Num Op Financiera',8,PreviousPost::Post,' ') + StuffingText('Cod ISIN',12,PreviousPost::Post,' ') +
                        //         StuffingText(TextLibre,4,PreviousPost::Post,' '); // ðð Tipo de registro 55
                        // OutFile.WRITE(OutText);}
                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInfo.GET();
                CompanyInfo.TESTFIELD("VAT Registration No.");

                VATRegNo := CompanyInfo."VAT Registration No.";
                TotalRemAmount := 0;
                TotalReg := 0;
                RegCuaderno := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                "Payment Order".CALCFIELDS(Amount);
                PayOrderAmount := ROUND(Amount);
                Comaactivada := FALSE;

                IF PayOrderAmount < 0 THEN
                    TextAmount := '-' + FORMAT(PayOrderAmount, 0, 1)
                ELSE
                    TextAmount := FORMAT(PayOrderAmount, 0, 1);

                DigDespuescoma := 0;
                FOR i := 1 TO STRLEN(TextAmount) DO BEGIN
                    IF Comaactivada THEN
                        DigDespuescoma += 1;
                    IF (TextAmount[i] = ',') OR (TextAmount[i] = '.') THEN BEGIN
                        PosicionComa := i;
                        Comaactivada := TRUE;
                    END;
                END;
                IF PosicionComa <> 0 THEN BEGIN
                    Antescoma := COPYSTR(TextAmount, 1, PosicionComa - 1);
                    despuescoma := COPYSTR(TextAmount, PosicionComa + 1, STRLEN(TextAmount));
                    TextAmount := Antescoma + despuescoma;
                    IF DigDespuescoma = 0 THEN
                        TextAmount := TextAmount + '00'
                    ELSE IF DigDespuescoma = 1 THEN
                        TextAmount := TextAmount + '0';
                END ELSE
                    TextAmount := TextAmount + '00';



                TESTFIELD("Bank Account No.");
                BankAcc.GET("Bank Account No.");

                Curr := "Currency Code";
                IF Curr = '' THEN
                    Curr := 'EUR';

                CCCBankNo := BankAcc."CCC Bank No.";
                CCCBankBranchNo := BankAcc."CCC Bank Branch No.";
                CCCAccNo := BankAcc."CCC Bank Account No.";
                CCCControlDigits := BankAcc."CCC Control Digits";

                // Registros de Cabecera
                ComunRegHeader := '01' + '56' + UPPERCASE(StuffingText(VATRegNo, 10, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 12, PreviousPost::Post, ' ');

                IF 'Detalle cargo' = '0' THEN
                    DetailPaymentOrder := '0'
                ELSE IF 'Detalle cargo' = '1' THEN
                    DetailPaymentOrder := '1';

                //BankAccount.GET('BO-EUR');
                //BankAccount.GET('CB2100');

                RegCuaderno += 1;
                OutText := ComunRegHeader + '001' + FORMAT(TODAY, 0, '<Day,2><Month,2><Year>') + StuffingText(TextLibre, 6, PreviousPost::Post, ' ') + '2100' + '6202' + StuffingText(BankAcc."Confirming Contract No.", 10, PreviousPost::Post, '0') + '1' +
                        StuffingText(Curr, 3, PreviousPost::Post, ' ') + StuffingText(TextLibre, 2, PreviousPost::Post, ' ') + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');    // ðð Tipo de registro 1
                OutFile.WRITE(OutText);

                RegCuaderno += 1;
                OutText := ComunRegHeader + '002' + UPPERCASE(StuffingText(CompanyInfo.Name, 36, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');    // ðð Tipo de registro 2
                OutFile.WRITE(OutText);

                RegCuaderno += 1;
                OutText := ComunRegHeader + '003' + UPPERCASE(StuffingText(CompanyInfo.Address, 36, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');    // ðð Tipo de registro 3
                OutFile.WRITE(OutText);

                RegCuaderno += 1;
                OutText := ComunRegHeader + '004' + UPPERCASE(StuffingText(CompanyInfo.City, 36, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');    // ðð Tipo de registro 4
                OutFile.WRITE(OutText);
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
        //       CompanyInfo@7001128 :
        CompanyInfo: Record 79;
        //       OutFile@7001102 :
        OutFile: File;
        //       ExternalFile@7001101 :
        ExternalFile: Text[1024];
        //       RBMgt@7001100 :
        RBMgt: Codeunit 419;
        //       Text001@7001105 :
        Text001: TextConst ENU = 'Export to file', ESP = 'Exportar a archivo';
        //       Text002@7001104 :
        Text002: TextConst ENU = 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*', ESP = 'Archivos Texto (*.txt)|*.txt|Todos los archivos (*.*)|*.*';
        //       Text003@7001103 :
        Text003: TextConst ENU = 'ORDENPAGO.ASC', ESP = 'CONFIRMINGBANKIA.TXT';
        //       ToFile@7001106 :
        ToFile: Text[1024];
        //       Vendor@7001111 :
        Vendor: Record 23;
        //       VATRegVend@7001112 :
        VATRegVend: Text[20];
        //       OutTextCab@7001113 :
        OutTextCab: Text[86];
        //       OutTextCuerpo@1100286000 :
        OutTextCuerpo: Text[300];
        //       TipoMov@1100286007 :
        TipoMov: Text[1];
        //       PreviousPost@7001114 :
        PreviousPost: Option "Prev","Post";
        //       Text004@7001130 :
        Text004: TextConst ENU = 'Some data from the Bank Account of Vendor %1 are missing.', ESP = 'Falta alguna informaci¢n sobre el banco del proveedor %1.';
        //       TextLibre@7001115 :
        TextLibre: TextConst ENU = ' ', ESP = ' ';
        //       VATRegNo@7001117 :
        VATRegNo: Text[20];
        //       TextAmount@7001119 :
        TextAmount: Text[12];
        //       TextAmountCart@7001159 :
        TextAmountCart: Text[12];
        //       PayOrderAmount@7001118 :
        PayOrderAmount: Decimal;
        //       CarteradocAmount@7001158 :
        CarteradocAmount: Decimal;
        //       BankAcc@7001120 :
        BankAcc: Record 270;
        //       VendBankAcc@7001116 :
        VendBankAcc: Record 288;
        //       Curr@7001121 :
        Curr: Code[3];
        //       CurrencyCode@7001122 :
        CurrencyCode: Text[3];
        //       CCCBankNo@7001126 :
        CCCBankNo: Text[4];
        //       CCCBankBranchNo@7001125 :
        CCCBankBranchNo: Text[4];
        //       CCCControlDigits@7001124 :
        CCCControlDigits: Text[2];
        //       CCCAccNo@7001123 :
        CCCAccNo: Text[10];
        //       IsResident@7001127 :
        IsResident: Text[1];
        //       VendBankAccCode@7001129 :
        VendBankAccCode: Code[20];
        //       VendCCCBankBranchNo@7001110 :
        VendCCCBankBranchNo: Text[4];
        //       VendCCCControlDigits@7001109 :
        VendCCCControlDigits: Text[2];
        //       VendCCCAccNo@7001108 :
        VendCCCAccNo: Text[10];
        //       Vendor2@7001107 :
        Vendor2: Text[4];
        //       VendSWIFTCode@7001131 :
        VendSWIFTCode: Code[20];
        //       VendAdress@7001132 :
        VendAdress: Text[36];
        //       VendAdress2@7001133 :
        VendAdress2: Text[36];
        //       CountryRegion@7001134 :
        CountryRegion: Record 9;
        //       DocType2@7001135 :
        DocType2: Code[10];
        //       DocMisc@7001136 :
        DocMisc: Codeunit 7000007;
        //       TotalRemAmount@7001137 :
        TotalRemAmount: Decimal;
        //       TotalReg@7001138 :
        TotalReg: Integer;
        //       ComunRegHeader@7001139 :
        ComunRegHeader: Text[26];
        //       ComunRegBeneficiary@7001140 :
        ComunRegBeneficiary: Text[30];
        //       PaymentType@7001141 :
        PaymentType: Text[1];
        //       DetailPaymentOrder@7001142 :
        DetailPaymentOrder: Text[1];
        //       PaymentClass@7001143 :
        PaymentClass: Text[2];
        //       BankAccount@7001144 :
        BankAccount: Record 270;
        //       FileManagement@7001145 :
        FileManagement: Codeunit 419;
        //       RegCuaderno@7001146 :
        RegCuaderno: Integer;
        //       i@7001147 :
        i: Integer;
        //       PosicionComa@7001148 :
        PosicionComa: Integer;
        //       Antescoma@7001152 :
        Antescoma: Text[20];
        //       despuescoma@7001151 :
        despuescoma: Text[20];
        //       DigDespuescoma@7001150 :
        DigDespuescoma: Integer;
        //       Comaactivada@7001149 :
        Comaactivada: Boolean;
        //       TotalRemAmountText@7001153 :
        TotalRemAmountText: Text;
        //       AsciiStr@7001157 :
        AsciiStr: Text[250];
        //       AnsiStr@7001156 :
        AnsiStr: Text[250];
        //       CharVar@7001155 :
        CharVar: ARRAY[33] OF Char;
        //       TextNifProv@1100286001 :
        TextNifProv: TextConst ENU = 'The VAT Registration No. of vendor must be filled.', ESP = 'El CIF/NIF del proveedor %1 debe estar relleno.';
        //       TextNomProv@1100286002 :
        TextNomProv: TextConst ENU = 'The Vendor''s name must be filled', ESP = 'El nombre del proveedor %1 debe estar relleno.';
        //       TextDomProv@1100286003 :
        TextDomProv: TextConst ENU = 'The vendor''s address must be filled.', ESP = 'La direcci¢n del proveedor %1 debe estar rellena.';
        //       TextProviProv@1100286004 :
        TextProviProv: TextConst ENU = 'The vendor''s county must be filled.', ESP = 'La provincia del proveedor %1 debe estar rellena.';
        //       TextPoblProv@1100286005 :
        TextPoblProv: TextConst ENU = 'The vendor''s city must be filled.', ESP = 'La poblaci¢n del proveedor %1 debe estar rellena.';
        //       TextPostCodeProv@1100286006 :
        TextPostCodeProv: TextConst ENU = 'The Vendor''s post code mus be filled.', ESP = 'El c¢digo postal del proveedor %1 debe estar relleno.';
        //       VendorLedgerEntry@1100286008 :
        VendorLedgerEntry: Record 25;
        //       NOrdenPago@1100286009 :
        NOrdenPago: Text[10];
        //       OutText@100000000 :
        OutText: Text[72];
        //       DocNo@1100286010 :
        DocNo: Text[15];



    trigger OnInitReport();
    begin
        ExternalFile := Text003;
    end;

    trigger OnPreReport();
    begin
        OutFile.TEXTMODE := TRUE;
        OutFile.WRITEMODE := TRUE;
        if ISSERVICETIER then begin
            ToFile := Text003;
        end;
        OutFile.CREATE(ExternalFile, TEXTENCODING::Windows);
    end;

    trigger OnPostReport();
    begin
        // Registro de Totalse
        RegCuaderno += 1;

        OutText := '08' + '56' + UPPERCASE(StuffingText(VATRegNo, 10, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 12, PreviousPost::Post, ' ') + StuffingText(TextLibre, 3, PreviousPost::Post, ' ') +
                StuffingText(TotalRemAmountText, 12, PreviousPost::Prev, '0') + StuffingText(FORMAT(TotalReg, 0, 1), 8, PreviousPost::Prev, '0') + StuffingText(FORMAT(RegCuaderno, 0, 1), 10, PreviousPost::Prev, '0') +
                StuffingText(TextLibre, 6, PreviousPost::Post, ' ') + StuffingText(TextLibre, 7, PreviousPost::Post, ' ');    // ðð énico
        OutFile.WRITE(OutText);

        OutFile.CLOSE;
        if ISSERVICETIER then
            DOWNLOAD(ExternalFile, '', 'C:', Text002, ToFile);
    end;



    // LOCAL procedure StuffingText (TextIni@7001100 : Text;Positions@7001101 : Integer;PrevPost@7001102 : 'Prev,Post';Stuffed@7001103 :
    LOCAL procedure StuffingText(TextIni: Text; Positions: Integer; PrevPost: Option "Prev","Post"; Stuffed: Text[1]): Text;
    var
        //       LenghtAux@7001104 :
        LenghtAux: Integer;
        //       TextPrev@7001105 :
        TextPrev: Text;
    begin
        CASE PrevPost OF
            PrevPost::Post:
                exit(PADSTR(TextIni, Positions, Stuffed));

            PrevPost::Prev:
                begin
                    LenghtAux := Positions - STRLEN(TextIni);
                    TextPrev := PADSTR('', LenghtAux, Stuffed);
                    exit(TextPrev + TextIni);
                end;
        end;
    end;

    //     procedure GetDocType (PmtMethodCode@1100000 :
    procedure GetDocType(PmtMethodCode: Code[10]): Code[10];
    var
        //       PaymentMethod@1100001 :
        PaymentMethod: Record 289;
    begin
        WITH PaymentMethod DO begin
            GET(PmtMethodCode);
            CASE "Bill Type" OF
                "Bill Type"::Check:
                    exit('4');
                "Bill Type"::Transfer:
                    exit('5');
                else
                    exit;
            end;
        end;
    end;

    /*begin
    //{
//      PGM 14/03/19: Genera un archivo de texto plano para Confirming de Bankia
//    }
    end.
  */

}




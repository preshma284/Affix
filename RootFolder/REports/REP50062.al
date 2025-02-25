report 50062 "OLD_Confirming BBVA OP Reg"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Payment Order"; "Posted Payment Order")
        {



            RequestFilterFields = "No.";
            DataItem("Cartera Doc."; "Posted Cartera Doc.")
            {

                DataItemTableView = SORTING("Type", "Bill Gr./Pmt. Order No.", "Category Code", "Currency Code", "Accepted", "Due Date")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Payable"));
                DataItemLink = "Bill Gr./Pmt. Order No." = FIELD("No.");
                trigger OnAfterGetRecord();
                BEGIN
                    TESTFIELD("Account No.");
                    Vendor.GET("Account No.");
                    "Cartera Doc.".CALCFIELDS("External Document No.");

                    IF Vendor."VAT Registration No." = '' THEN
                        ERROR(TextNifProv, Vendor.Name);
                    IF Vendor.Name = '' THEN
                        ERROR(TextNomProv, Vendor.Name);
                    IF Vendor.Address = '' THEN
                        ERROR(TextDomProv, Vendor.Name);
                    IF Vendor.County = '' THEN
                        ERROR(TextProviProv, Vendor.Name);
                    IF Vendor.City = '' THEN
                        ERROR(TextPoblProv, Vendor.Name);
                    IF Vendor."Post Code" = '' THEN
                        ERROR(TextPostCodeProv, Vendor.Name);

                    CarteradocAmount := ROUND("Remaining Amount");

                    IF CarteradocAmount < 0 THEN
                        TextAmountCart := '-' + FORMAT(CarteradocAmount, 0, 1)
                    ELSE
                        TextAmountCart := FORMAT(CarteradocAmount, 0, 1);
                    DigDespuescoma := 0;
                    Comaactivada := FALSE;
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

                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Entry No.", "Cartera Doc."."Entry No.");
                    IF VendorLedgerEntry.FINDFIRST THEN;

                    IF (STRLEN("Cartera Doc."."Document No.") < 11) THEN
                        DocNo := "Cartera Doc."."Document No."
                    ELSE
                        DocNo := COPYSTR("Cartera Doc."."Document No.", STRLEN("Cartera Doc."."Document No.") - 10, STRLEN("Cartera Doc."."Document No."));

                    VendorBankAccount.RESET;
                    VendorBankAccount.SETRANGE("Vendor No.", Vendor."No.");
                    VendorBankAccount.SETRANGE(Code, "Cartera Doc."."Cust./Vendor Bank Acc. Code");
                    IF VendorBankAccount.FINDFIRST THEN BEGIN
                        VendorBank := VendorBankAccount."CCC Bank No.";
                        VendorOffice := VendorBankAccount."CCC Bank Branch No.";
                        VendorAcc := VendorBankAccount."CCC Bank Account No.";
                    END ELSE BEGIN
                        VendorBank := '';
                        VendorOffice := '';
                        VendorAcc := '';
                    END;

                    RegCuaderno += 1;
                    OutTextCuerpo := UPPERCASE(StuffingText(Vendor."VAT Registration No.", 9, PreviousPost::Post, ' ')) + UPPERCASE(StuffingText(Vendor.Name + Vendor."Name 2", 30, PreviousPost::Post, ' ')) +
                                  UPPERCASE(StuffingText(Vendor.Address + Vendor."Address 2", 30, PreviousPost::Post, ' ')) + StuffingText(TextLibre, 7, PreviousPost::Post, ' ') + StuffingText(Vendor."Post Code", 5, PreviousPost::Prev, '0') +
                                  UPPERCASE(StuffingText(Vendor.City, 20, PreviousPost::Post, ' ')) + StuffingText(Vendor."Phone No.", 10, PreviousPost::Post, ' ') + StuffingText(Vendor."Fax No.", 10, PreviousPost::Post, ' ') +
                                  StuffingText(VendorBank, 4, PreviousPost::Prev, '0') + StuffingText(VendorOffice, 4, PreviousPost::Prev, '0') + StuffingText(VendorAcc, 10, PreviousPost::Prev, '0') + UPPERCASE(StuffingText(DocNo, 11, PreviousPost::Post, ' ')) +
                                  FORMAT("Cartera Doc."."Posting Date", 0, '<Year4><Month,2><Day,2>') + StuffingText(TextAmountCart, 13, PreviousPost::Prev, '0') + FORMAT("Cartera Doc."."Due Date", 0, '<Year4><Month,2><Day,2>') +
                                  StuffingText(TextLibre, 31, PreviousPost::Post, ' ');
                    OutFile.WRITE(OutTextCuerpo); // Registro detalles pago.
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInfo.GET();
                CompanyInfo.TESTFIELD("VAT Registration No.");

                VATRegNo := CompanyInfo."VAT Registration No.";
                TotalReg := 0;
                RegCuaderno := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                "Payment Order".CALCFIELDS(Amount);
                PayOrderAmount := ROUND(Amount);
                Comaactivada := FALSE;

                //{IF PayOrderAmount < 0 THEN
                //                                    TextAmount := '-' + FORMAT(PayOrderAmount,0,1)
                //                                  ELSE
                //                                    TextAmount := FORMAT(PayOrderAmount,0,1);
                //
                //                                  DigDespuescoma := 0;
                //                                  FOR i:=1 TO STRLEN(TextAmount) DO BEGIN 
                //                                    IF Comaactivada THEN
                //                                      DigDespuescoma += 1;
                //                                    IF (TextAmount[i] = ',') OR (TextAmount[i] = '.') THEN BEGIN 
                //                                      PosicionComa := i;
                //                                      Comaactivada := TRUE;
                //                                    END;
                //                                  END;
                //                                  IF PosicionComa <> 0 THEN BEGIN 
                //                                    Antescoma := COPYSTR(TextAmount,1,PosicionComa-1);
                //                                    despuescoma := COPYSTR(TextAmount,PosicionComa+1,STRLEN(TextAmount));
                //                                    TextAmount := Antescoma + despuescoma;
                //                                    IF DigDespuescoma = 0 THEN
                //                                      TextAmount := TextAmount + '00'
                //                                    ELSE IF DigDespuescoma = 1 THEN
                //                                      TextAmount := TextAmount + '0';
                //                                  END ELSE
                //                                    TextAmount := TextAmount + '00';
                //                                    }
                TESTFIELD("Bank Account No.");
                BankAcc.GET("Bank Account No.");

                Curr := "Currency Code";
                IF Curr = '' THEN
                    Curr := 'EUR';

                CCCBankNo := BankAcc."CCC Bank No.";
                CCCBankBranchNo := BankAcc."CCC Bank Branch No.";
                CCCAccNo := BankAcc."CCC Bank Account No.";
                CCCControlDigits := BankAcc."CCC Control Digits";

                Suffix.RESET;
                Suffix.SETRANGE("Bank Acc. Code", "Bank Account No.");
                IF Suffix.FINDFIRST THEN
                    Sufijo := Suffix.Suffix
                ELSE
                    Sufijo := '000';

                Comaactivada := FALSE;

                TotalRemAmountText := FORMAT("Payment Order".Amount, 0, 1);
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

                // Registros de Cabecera
                RegCuaderno += 1;

                // OutTextCab := '026805' + UPPERCASE(StuffingText(VATRegNo,9,PreviousPost::Post,' ')) + FORMAT("Payment Order"."Posting Date",0,'<Year4><Month,2><Day,2>') + StuffingText(TotalRemAmountText,12,PreviousPost::Prev,'0') +
                //             ' ' + Curr + StuffingText(TextLibre,171,PreviousPost::Post,' ');
                OutTextCab := '026805' + UPPERCASE(StuffingText(VATRegNo, 9, PreviousPost::Post, ' ')) + FORMAT("Payment Order"."Posting Date", 0, '<Year4><Month,2><Day,2>') + StuffingText(TotalRemAmountText, 13, PreviousPost::Prev, '0') +
                             Curr + StuffingText(TextLibre, 171, PreviousPost::Post, ' ');
                OutFile.WRITE(OutTextCab);
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
        //       Text000@7001105 :
        Text000: TextConst ENU = 'Export to file', ESP = 'Exportar a archivo';
        //       Text002@7001104 :
        Text002: TextConst ENU = 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*', ESP = 'Archivos Texto (*.txt)|*.txt|Todos los archivos (*.*)|*.*';
        //       Text10702@7001103 :
        Text10702: TextConst ENU = 'ORDENPAGO.ASC', ESP = 'Confirming_BBVA.txt';
        //       ToFile@7001106 :
        ToFile: Text[1024];
        //       Vendor@7001111 :
        Vendor: Record 23;
        //       VATRegVend@7001112 :
        VATRegVend: Text[20];
        //       OutText@1100286012 :
        OutText: Text;
        //       OutTextCab@7001113 :
        OutTextCab: Text[500];
        //       OutTextCuerpo@1100286000 :
        OutTextCuerpo: Text[500];
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
        //       TotalRemAmountTextPos@7001153 :
        TotalRemAmountTextPos: Text;
        //       TotalRemAmountTextNeg@1100286013 :
        TotalRemAmountTextNeg: Text;
        //       TotalRemAmountText@1100286014 :
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
        //       Suffix@1100286009 :
        Suffix: Record 7000024;
        //       Sufijo@1100286010 :
        Sufijo: Text[3];
        //       Signo@1100286011 :
        Signo: Text[1];
        //       DocNo@100000000 :
        DocNo: Text[11];
        //       VendorBank@100000001 :
        VendorBank: Text[4];
        //       VendorOffice@100000002 :
        VendorOffice: Text[4];
        //       VendorAcc@100000003 :
        VendorAcc: Text[10];
        //       VendorBankAccount@100000004 :
        VendorBankAccount: Record 288;
        //       Text001@100000005 :
        Text001: TextConst ENU = 'ORDENPAGO.ASC', ESP = 'ConfirmingBBVA.txt';
        //       "----"@100000010 :
        "----": Integer;
        //       GenerateElectronicsPayments@100000009 :
        GenerateElectronicsPayments: Codeunit 7206908;
        //       Opciones@100000008 :
        Opciones: ARRAY[5] OF Text;
        //       "----------------------------- Par metros"@100000007 :
        "----------------------------- Par metros": Integer;



    trigger OnPreReport();
    begin
        //Preparar el fichero
        ToFile := Text10702;
        ExternalFile := TEMPORARYPATH + ToFile;
        OutFile.TEXTMODE := TRUE;
        OutFile.WRITEMODE := TRUE;
        OutFile.CREATE(ExternalFile, TEXTENCODING::Windows);
    end;

    trigger OnPostReport();
    begin
        //Guardar el fichero
        OutFile.CLOSE;
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
//      PGM 14/03/19: Genera un archivo de texto plano para Confirming de BBVA
//    }
    end.
  */

}




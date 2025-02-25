report 7207271 "Import Excel Comparative"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Vendor Conditions Data"; "Vendor Conditions Data")
        {

            DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.", "Version No.");
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("opcVersi¢n"; "opcVersion")
                {

                    CaptionML = ESP = 'Sobre que versi¢n';
                }

            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        BEGIN
            IF CloseAction = ACTION::OK THEN BEGIN
                ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);

                SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
                IF SheetName = '' THEN
                    EXIT(FALSE);
            END;
        END;


    }
    labels
    {
    }

    var
        //       VendorConditionsData@1100286022 :
        VendorConditionsData: Record 7207414;
        //       DataPricesVendor@1100286018 :
        DataPricesVendor: Record 7207415;
        //       OtherVendorConditions@1100286014 :
        OtherVendorConditions: Record 7207416;
        //       ExcelBuffer@1100286012 :
        ExcelBuffer: Record 370;
        //       ExcelBuffer2@1100286007 :
        ExcelBuffer2: Record 370;
        //       FileMgt@1100286016 :
        FileMgt: Codeunit 419;
        //       ServerFileName@7001100 :
        ServerFileName: Text[250];
        //       SheetName@7001101 :
        SheetName: Text[250];
        //       i@7001102 :
        i: Integer;
        //       TotalRows@7001103 :
        TotalRows: Integer;
        //       Text001@7001104 :
        Text001: TextConst ENU = 'Import is completed', ESP = 'La importaci¢n se ha completado';
        //       Text002@7001109 :
        Text002: TextConst ENU = 'Choose the file to import', ESP = 'Escoja el fichero a importar';
        //       Text006@7001106 :
        Text006: TextConst ENU = 'Import Excel File', ESP = 'Importar fichero excel';
        //       ExcelExtensionTok@7001108 :
        ExcelExtensionTok:
// {Locked}
TextConst ENU = '.xlsx';
        //       ColNum@7001110 :
        ColNum: Integer;
        //       Text003@1100286017 :
        Text003: TextConst ESP = '¨Confirma que desea cargar datos del proveedor %2 en el comparativo %1?';
        //       Text004@1100286010 :
        Text004: TextConst ESP = 'La Excel indica que son datos del proveedor %1 en el comparativo %2. ¨Confirma que desea cargar datos al proveedor %3 en el comparativo %4?';
        //       FiltroRef@1100286003 :
        FiltroRef: TextConst ESP = '#R*';
        //       FiltroUO@1100286019 :
        FiltroUO: TextConst ESP = '#U*';
        //       FiltroNro@1100286004 :
        FiltroNro: TextConst ESP = '#C*';
        //       FiltroOtras@1100286000 :
        FiltroOtras: TextConst ESP = '#O*';
        //       FiltroPrecio@1100286001 :
        FiltroPrecio: TextConst ESP = '# PRECIO';
        //       FiltroImporte@1100286002 :
        FiltroImporte: TextConst ESP = '# IMPORTE';
        //       ColPrecio@1100286005 :
        ColPrecio: Integer;
        //       ColImporte@1100286006 :
        ColImporte: Integer;
        //       QuoteCode@1100286008 :
        QuoteCode: Code[20];
        //       VendorNo@1100286009 :
        VendorNo: Code[20];
        //       VendorPrice@1100286013 :
        VendorPrice: Decimal;
        //       ok@1100286015 :
        ok: Boolean;
        //       VersionNo@1100286011 :
        VersionNo: Integer;
        //       ExcelVersion@1100286023 :
        ExcelVersion: Text;
        //       AuxText@1100286024 :
        AuxText: Text;
        //       LineNo@1100286025 :
        LineNo: Integer;
        //       "---------------------------------------------- Opciones"@1100286020 :
        "---------------------------------------------- Opciones": Integer;
        //       opcVersi¢n@1100286021 :
        opcVersion: Option "éltima del proveedor","Crear Nueva";



    trigger OnPreReport();
    begin
        ExcelBuffer.DELETEALL;
        ExcelBuffer.LOCKTABLE;
        //jmma
        if SheetName = '' then
            SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);

        //--jmma
        ExcelBuffer.OpenBook(ServerFileName, SheetName);
        ExcelBuffer.ReadSheet;

        //Busco la versi¢n sobre la que cargar
        VendorConditionsData.GET("Vendor Conditions Data".GETFILTER("Quote Code"), "Vendor Conditions Data".GETFILTER("Vendor No."), '', 1);
        VendorConditionsData.CALCFIELDS("MAX Version");
        if (opcVersion = opcVersion::"éltima del proveedor") then begin
            VendorConditionsData.GET("Vendor Conditions Data".GETFILTER("Quote Code"), "Vendor Conditions Data".GETFILTER("Vendor No."), '', VendorConditionsData."MAX Version");
        end else begin
            VendorConditionsData.INSERT(TRUE);
        end;
        VersionNo := VendorConditionsData."Version No.";

        //Miro si tiene datos con la estructura nueva
        ExcelBuffer.RESET;
        ExcelBuffer.SETFILTER("Cell Value as Text", FiltroRef);
        if (not ExcelBuffer.ISEMPTY) then begin
            //Busco datos maestros (nro del comparativo, nro del vendedor/contacto, nro de versi¢n)
            ExcelBuffer.RESET;
            ExcelBuffer.SETFILTER("Cell Value as Text", FiltroRef);
            if (ExcelBuffer.FINDSET(FALSE)) then begin
                AuxText := ExcelBuffer."Cell Value as Text";
                i := STRPOS(AuxText, ' ');
                if (i <> 0) then begin
                    QuoteCode := COPYSTR(AuxText, 3, i - 3);
                    AuxText := COPYSTR(AuxText, i + 1);
                    i := STRPOS(AuxText, ' ');
                    if (i = 0) then
                        VendorNo := AuxText
                    else begin
                        VendorNo := COPYSTR(AuxText, 1, i - 1);
                        AuxText := COPYSTR(AuxText, i + 1);
                        i := STRPOS(AuxText, ' ');
                        if (i = 0) then
                            ExcelVersion := AuxText
                        else
                            ExcelVersion := COPYSTR(AuxText, 1, i - 1);
                    end;
                end;
            end;

            ExcelBuffer.RESET;
            ExcelBuffer.SETFILTER("Cell Value as Text", FiltroPrecio);
            if (ExcelBuffer.FINDSET(FALSE)) then
                ColPrecio := ExcelBuffer."Column No.";

            ExcelBuffer.RESET;
            ExcelBuffer.SETFILTER("Cell Value as Text", FiltroImporte);
            if (ExcelBuffer.FINDSET(FALSE)) then
                ColImporte := ExcelBuffer."Column No.";

            //Confirmo la carga
            if (VendorNo = VendorConditionsData."Vendor No.") and (QuoteCode = VendorConditionsData."Quote Code") then
                ok := CONFIRM(Text003, TRUE, QuoteCode, VendorNo)
            else begin
                ok := CONFIRM(Text004, TRUE, VendorNo, QuoteCode, VendorConditionsData."Vendor No.", VendorConditionsData."Quote Code");
                QuoteCode := VendorConditionsData."Quote Code";
                VendorNo := VendorConditionsData."Vendor No.";
            end;

            if (not ok) then
                exit;

            //Monto datos de las Unidades de Obra
            ExcelBuffer.RESET;
            ExcelBuffer.SETFILTER("Cell Value as Text", '%1|%2', FiltroUO, FiltroNro);
            if (ExcelBuffer.FINDSET(FALSE)) then
                repeat
                    ok := TRUE;
                    VendorPrice := 0;
                    if (ExcelBuffer2.GET(ExcelBuffer."Row No.", ColPrecio)) then
                        ok := EVALUATE(VendorPrice, ExcelBuffer2."Cell Value as Text");
                    if (ok) then begin
                        DataPricesVendor.RESET;
                        DataPricesVendor.SETRANGE("Quote Code", VendorConditionsData."Quote Code");
                        DataPricesVendor.SETRANGE("Vendor No.", VendorConditionsData."Vendor No.");
                        DataPricesVendor.SETRANGE("Contact No.", VendorConditionsData."Contact No.");
                        DataPricesVendor.SETRANGE("Version No.", VersionNo);
                        if (COPYSTR(ExcelBuffer."Cell Value as Text", 1, 2) = COPYSTR(FiltroUO, 1, 2)) then             //JAV 16/12/21: - QB 1.10.08 Estaba mal la comparaci¢n, se arregla
                            DataPricesVendor.SETRANGE("Piecework No.", COPYSTR(ExcelBuffer."Cell Value as Text", 3))
                        else begin                                                                                      //JAV 16/12/21: - QB 1.10.08 Estaba mal el campo de origen
                            if not EVALUATE(LineNo, COPYSTR(ExcelBuffer."Cell Value as Text", 3)) then
                                LineNo := 0;
                            DataPricesVendor.SETRANGE("Line No.", LineNo);
                        end;
                        if DataPricesVendor.FINDSET(TRUE) then
                            repeat
                                DataPricesVendor.VALIDATE("Vendor Price", VendorPrice);
                                DataPricesVendor.MODIFY;
                            until DataPricesVendor.NEXT = 0;
                    end;
                until (ExcelBuffer.NEXT = 0);

            //Monto datos de las condiciones
            ExcelBuffer.RESET;
            ExcelBuffer.SETFILTER("Cell Value as Text", FiltroOtras);
            if (ExcelBuffer.FINDSET(FALSE)) then
                repeat
                    if (ExcelBuffer2.GET(ExcelBuffer."Row No.", ColImporte)) then begin
                        ok := EVALUATE(VendorPrice, ExcelBuffer2."Cell Value as Text");
                        if (ok) then begin
                            //i := STRPOS(ExcelBuffer."Cell Value as Text", '#O');
                            if (OtherVendorConditions.GET(QuoteCode, VendorNo, '', VersionNo, COPYSTR(ExcelBuffer."Cell Value as Text", 3))) then begin
                                OtherVendorConditions.VALIDATE(Amount, VendorPrice);
                                OtherVendorConditions.MODIFY;
                            end;
                        end;
                    end;
                until (ExcelBuffer.NEXT = 0);

        end else begin
            //No es la nueva estructura, usar la anterior
            GetLastRowandColumn;
            ColNum := 20;
            i := 28;
            ExcelBuffer.RESET;
            ExcelBuffer.SETFILTER("Cell Value as Text", '%1', 'PRECIO');
            if ExcelBuffer.FINDFIRST then begin
                ColNum := ExcelBuffer."Column No.";
                i := ExcelBuffer."Row No." + 1;
            end;

            InsertData(i);
        end;

        ExcelBuffer.DELETEALL;
        MESSAGE(Text001);
    end;



    LOCAL procedure GetLastRowandColumn()
    begin
        ExcelBuffer.SETRANGE("Row No.", 1);
        TotalRows := ExcelBuffer.COUNT;

        ExcelBuffer.RESET;
        if ExcelBuffer.FINDLAST then
            TotalRows := ExcelBuffer."Row No.";
    end;

    //     LOCAL procedure InsertData (RowNo@7001100 :
    LOCAL procedure InsertData(RowNo: Integer)
    var
        //       DataPricesVendor@7001104 :
        DataPricesVendor: Record 7207415;
        //       NLine@7001102 :
        NLine: Integer;
        //       VendorPrice@7001103 :
        VendorPrice: Decimal;
    begin
        DataPricesVendor.RESET;
        DataPricesVendor.SETRANGE("Quote Code", VendorConditionsData."Quote Code");
        DataPricesVendor.SETRANGE("Vendor No.", VendorConditionsData."Vendor No.");
        DataPricesVendor.SETRANGE("Version No.", VersionNo);
        if DataPricesVendor.FINDFIRST then
            repeat
                EVALUATE(VendorPrice, GetValueAtCell(RowNo, ColNum));
                DataPricesVendor.VALIDATE("Vendor Price", VendorPrice);
                DataPricesVendor.MODIFY;
                RowNo += 1;
            until DataPricesVendor.NEXT = 0;
    end;

    //     LOCAL procedure GetValueAtCell (RowNo@7001100 : Integer;ColNo@7001101 :
    LOCAL procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    var
        //       ExcelBuf1@7001102 :
        ExcelBuf1: Record 370;
        //       RowNo1@7001103 :
        RowNo1: Integer;
        //       ColNo1@7001104 :
        ColNo1: Integer;
    begin
        //jmma
        ExcelBuf1 := ExcelBuffer;
        ExcelBuf1.GET(RowNo, ColNo);
        exit(ExcelBuf1."Cell Value as Text");
    end;

    /*begin
    //{
//      JAV 05/12/19: - Se mejora el proceso de lectura en general del fichero
//    }
    end.
  */

}




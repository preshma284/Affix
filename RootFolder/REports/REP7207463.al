report 7207463 "Exportaci¢n Certificaci¢n BC3"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Table2000000026"; "2000000026")
        {

            DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));

            ;
            trigger OnAfterGetRecord();
            VAR
                //                                   DataPieceworkForProduction@1100286000 :
                DataPieceworkForProduction: Record 7207386;
            BEGIN
                //Insertamos el registro V de
                FunctionV;
                //Insertamos lo parametros
                FunctionK;
                //Obtenemos el valor entre niveles
                DataPieceworkForProduction.SETRANGE("Job No.", JobNo);
                DataPieceworkForProduction.SETRANGE(Indentation, 0);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    v1 := STRLEN(DataPieceworkForProduction."Piecework Code");
                END;
                DataPieceworkForProduction.SETRANGE("Job No.", JobNo);
                DataPieceworkForProduction.SETRANGE(Indentation, 1);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    v2 := STRLEN(DataPieceworkForProduction."Piecework Code");
                END;
                JumpPiecework := v2 - v1;

                //Ordenamos los datos en funci¢n de si es ha sido registrada o no.
                IF TypeDoc = TypeDoc::Certification THEN Certif_Unposted;

                //Buscamos los datos del preciario.
                IF NOT CostDatabase.GET(CostDataCode) THEN BEGIN
                    CostDatabase.PrimerNivel := 'RAIZ'; //Si no tenemos guardado el concepto en el preciario.
                END;

                //Calculamos el total (Lo enviamos a PEC)
                TmpMeasurementLines.RESET;
                TmpMeasurementLines.FINDSET;
                REPEAT
                    PECImport += TmpMeasurementLines."Cert Term PEC amount";
                    PEMIMport += TmpMeasurementLines."Cert Term PEM amount";
                UNTIL TmpMeasurementLines.NEXT = 0;


                //Insertamos la cabecera Raiz
                IF CostDatabase.TextoPrimerNivel = '' THEN CostDatabase.TextoPrimerNivel := 'RAIZ';
                OutTextCab := '~C|' + CostDatabase.PrimerNivel + '##||' + CostDatabase.TextoPrimerNivel + '|' + ConvertNumber(PECImport, TRUE) + '||0|';
                OutFile.WRITE(OutTextCab);
                //Buscamos nivel a nivel
                FOR Level := 0 TO MaxLevel DO BEGIN
                    IF Level = 0 THEN BEGIN
                        OutTextCab := '~D|' + CostDatabase.PrimerNivel + '##|';
                        FunctionD(Level, '');
                    END
                    ELSE BEGIN
                        TmpMeasurementLines.RESET;
                        TmpDataPieceworkForProduction.SETRANGE("Job No.", JobNo);
                        TmpDataPieceworkForProduction.SETRANGE(Indentation, Level - 1);
                        IF TmpDataPieceworkForProduction.FINDSET THEN
                            REPEAT
                                //-Q18345
                                IF TmpDataPieceworkForProduction."Code Piecework PRESTO" <> '' THEN
                                    UOCode := TmpDataPieceworkForProduction."Code Piecework PRESTO"
                                ELSE
                                    UOCode := TmpDataPieceworkForProduction."Piecework Code";
                                //OutTextCab := '~C|' + TmpDataPieceworkForProduction."Piecework Code";
                                OutTextCab := '~C|' + UOCode;
                                //+Q18345
                                //+
                                DataPieceworkForProduction.GET(JobNo, TmpDataPieceworkForProduction."Piecework Code");
                                IF TmpDataPieceworkForProduction.Reassuring THEN
                                    OutTextCab := OutTextCab + '||' + DataPieceworkForProduction.Description + '|' +
FindImport(TmpDataPieceworkForProduction."Piecework Code") + '||0|'
                                ELSE
                                    OutTextCab := OutTextCab + '#||' + DataPieceworkForProduction.Description + '|' +
                                FindImport(TmpDataPieceworkForProduction."Piecework Code") + '||0|';

                                OutFile.WRITE(OutTextCab);
                                IF NOT TmpDataPieceworkForProduction.Reassuring THEN BEGIN //Si no es nivel de certificacion (Partida) buscamos su descomposicion
                                                                                           //-Q18345
                                    IF TmpDataPieceworkForProduction."Code Piecework PRESTO" <> '' THEN
                                        UOCode := DataPieceworkForProduction."Code Piecework PRESTO"
                                    ELSE
                                        UOCode := TmpDataPieceworkForProduction."Piecework Code";
                                    //OutTextCab := '~D|' + TmpDataPieceworkForProduction."Piecework Code" + '|';
                                    OutTextCab := '~D|' + UOCode + '|';
                                    //-Q18345
                                    FunctionD(Level, TmpDataPieceworkForProduction."Piecework Code");
                                END;

                            UNTIL TmpDataPieceworkForProduction.NEXT = 0;
                    END;

                END;
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
        //       "----------Tablas"@1100286031 :
        "----------Tablas": Integer;
        //       GeneralLedgerSetup@1100286000 :
        GeneralLedgerSetup: Record 98;
        //       MeasurementHeader@1100286015 :
        MeasurementHeader: Record 7207336;
        //       MeasurementLines@1100286014 :
        MeasurementLines: Record 7207337;
        //       Job@1100286013 :
        Job: Record 167;
        //       CostDatabase@1100286030 :
        CostDatabase: Record 7207271;
        //       "------------ Tablas Temporales"@1100286032 :
        "------------ Tablas Temporales": Integer;
        //       TmpDataPieceworkForProduction@1100286026 :
        TmpDataPieceworkForProduction: Record 7207386 TEMPORARY;
        //       TmpDataPieceworkForProduction2@1100286036 :
        TmpDataPieceworkForProduction2: Record 7207386 TEMPORARY;
        //       TmpMeasurementLines@1100286027 :
        TmpMeasurementLines: Record 7207337 TEMPORARY;
        //       "-----Variables del Fichero"@1100286021 :
        "-----Variables del Fichero": Integer;
        //       OutFile@7001102 :
        OutFile: File;
        //       ExternalFile@7001101 :
        ExternalFile: Text[1024];
        //       RBMgt@7001100 :
        RBMgt: Codeunit 419;
        //       Text001@7001105 :
        Text001: TextConst ENU = 'Export to file', ESP = 'Exportar a archivo';
        //       Text003@7001103 :
        Text003: TextConst ENU = 'ORDENPAGO.ASC', ESP = 'CONFIRMINGDEUTSCHEBANK.TXT';
        //       ToFile@7001106 :
        ToFile: Text[1024];
        //       OutTextCab@1100286024 :
        OutTextCab: Text[1024];
        //       CharVar@1100286023 :
        CharVar: ARRAY[33] OF Char;
        //       "------- Parametros y variables de Certificacion"@1100286022 :
        "------- Parametros y variables de Certificacion": Integer;
        //       DocNo@1100286008 :
        DocNo: Code[20];
        //       TypeDoc@1100286007 :
        TypeDoc: Option "Certification","Post Certification";
        //       Text004@7001130 :
        Text004: TextConst ENU = 'Some data from the Bank Account of Vendor %1 are missing.', ESP = 'Falta alguna informaci¢n sobre el banco del proveedor %1.';
        //       TextLibre@7001115 :
        TextLibre: TextConst ENU = ' ', ESP = ' ';
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
        //       JobNo@1100286009 :
        JobNo: Code[20];
        //       NoCertif@1100286020 :
        NoCertif: Code[20];
        //       FechaCert@1100286019 :
        FechaCert: Date;
        //       CI@1100286018 :
        CI: Decimal;
        //       GG@1100286017 :
        GG: Decimal;
        //       BI@1100286016 :
        BI: Decimal;
        //       BAJA@1100286012 :
        BAJA: Decimal;
        //       IVA@1100286010 :
        IVA: Decimal;
        //       PECImport@1100286034 :
        PECImport: Decimal;
        //       PEMIMport@1100286035 :
        PEMIMport: Decimal;
        //       "--------Variables"@1100286011 :
        "--------Variables": Integer;
        //       MaxLevel@1100286028 :
        MaxLevel: Integer;
        //       Level@1100286025 :
        Level: Integer;
        //       Previous@1100286029 :
        Previous: Code[20];
        //       CostDataCode@1100286033 :
        CostDataCode: Code[20];
        //       Text005@1100286037 :
        Text005: TextConst ENU = 'Text Files (*.bc3)|*.bc3|All Files (*.*)|*.*', ESP = 'Archivos Texto (*.bc3)|*.bc3|Todos los archivos (*.*)|*.*';
        //       DM@1100286038 :
        DM: Text[1];
        //       v1@1100286039 :
        v1: Integer;
        //       v2@1100286040 :
        v2: Integer;
        //       JumpPiecework@1100286041 :
        JumpPiecework: Integer;
        //       UOCode@1100286042 :
        UOCode: Text[20];



    trigger OnPreReport();
    var
        //                   FileManagement@1100286000 :
        FileManagement: Codeunit 419;
    begin
        GeneralLedgerSetup.GET;
        OutFile.TEXTMODE := TRUE;
        OutFile.WRITEMODE := TRUE;
        ExternalFile := 'BC3.bc3';
        //////////////////////FileManagement.GetSafeFileName(ExternalFile);
        if ISSERVICETIER then begin
            ToFile := 'BC3'; //Sustituir por el nombre
        end;
        //***AML***
        ToFile := 'BC3.bc3'; //Sustituir por el nombre
                             //***AML***
        OutFile.CREATE(ExternalFile, TEXTENCODING::Windows);
    end;

    trigger OnPostReport();
    begin

        OutFile.CLOSE;
        if ISSERVICETIER then
            DOWNLOAD(ExternalFile, 'Guardar BC3', 'C:\', Text005, ToFile);
    end;



    // procedure Parameters (pType@1100286000 : Integer;pDocNo@1100286001 :
    procedure Parameters(pType: Integer; pDocNo: Code[20])
    begin
        TypeDoc := pType;
        DocNo := pDocNo;
        if pType = 0 then begin
            MeasurementHeader.GET(DocNo);
            JobNo := MeasurementHeader."Job No.";
            FechaCert := MeasurementHeader."Posting Date";
            Job.GET(MeasurementHeader."Job No.");
        end;
        CI := Job."Quality Deduction";
        GG := Job."General Expenses / Other";
        BAJA := Job."Low Coefficient";
        BI := Job."Industrial Benefit";
        IVA := 0; //AML 14/06/23 De momento a 0
    end;

    LOCAL procedure Certif_Unposted()
    begin
        MeasurementLines.SETRANGE("Document No.", DocNo);
        MeasurementLines.SETFILTER("Cert % to Certificate", '<> %1', 0);
        if MeasurementLines.FINDSET then
            repeat
                PreviousLevel(MeasurementLines."Piecework No.", TRUE);
                TmpMeasurementLines := MeasurementLines;
                TmpMeasurementLines.INSERT;
            until MeasurementLines.NEXT = 0;
    end;

    //     LOCAL procedure PreviousLevel (Breakdown@1100286000 : Code[20];DataLevel@1100286005 :
    LOCAL procedure PreviousLevel(Breakdown: Code[20]; DataLevel: Boolean)
    var
        //       DataPieceworkForProduction@1100286001 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProduction2@1100286002 :
        DataPieceworkForProduction2: Record 7207386;
        //       Jump@1100286003 :
        Jump: Integer;
        //       Result@1100286004 :
        Result: Boolean;
    begin
        DataPieceworkForProduction.GET(JobNo, Breakdown);
        if (CostDataCode = '') and (DataPieceworkForProduction."Code Cost Database" <> '') then CostDataCode := DataPieceworkForProduction."Code Cost Database";
        if MaxLevel < DataPieceworkForProduction.Indentation + 1 then MaxLevel := DataPieceworkForProduction.Indentation + 1;  //Guardamos el nivel m s alto (con +1);
        TmpDataPieceworkForProduction."Job No." := JobNo;
        TmpDataPieceworkForProduction."Piecework Code" := DataPieceworkForProduction."Piecework Code";
        TmpDataPieceworkForProduction.Indentation := DataPieceworkForProduction.Indentation;
        TmpDataPieceworkForProduction.Reassuring := DataLevel; //Para guardar en cual se tienen los datos.
                                                               //-Q18345
        TmpDataPieceworkForProduction."Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";
        //+Q18345
        if not TmpDataPieceworkForProduction.INSERT then exit;
        TmpDataPieceworkForProduction2 := TmpDataPieceworkForProduction;  //Parameters else doble bucle
        TmpDataPieceworkForProduction2.INSERT;
        if DataPieceworkForProduction.Indentation = 0 then exit;
        Jump := 0;
        Result := FALSE;
        repeat
            Jump += JumpPiecework;
            DataPieceworkForProduction2.SETRANGE("Job No.", JobNo);
            DataPieceworkForProduction2.SETRANGE(Indentation, DataPieceworkForProduction.Indentation - 1);
            DataPieceworkForProduction2.SETRANGE("Piecework Code", COPYSTR(Breakdown, 1, STRLEN(Breakdown) - Jump));
            if DataPieceworkForProduction2.FINDFIRST then begin
                Result := TRUE;
                PreviousLevel(DataPieceworkForProduction2."Piecework Code", FALSE);
            end;
        until (Jump = 4 * JumpPiecework) or (Result = TRUE)
    end;

    LOCAL procedure FunctionV()
    begin

        OutTextCab := '~V|CEI Europa|FIEBDC-3/2020\' + ConvertDate(TODAY) + '|Quobuilding||ANSI|' + NoCertif + '|3|' + STRSUBSTNO('%1', FechaCert) + '||';

        OutFile.WRITE(OutTextCab);
    end;

    LOCAL procedure FunctionK()
    begin
        //***AML***
        //~K|3\3\3\3\4\2\2\2\EUR\|5\13\6\0\0|\2\\3\4\\2\5\2\3\3\3\3\5\EUR\||
        //Definicio detallada del registro K en Documentation. Es el registro que puede dar lugar a m s problemas de ajustes.
        //De momento, los ajustes de decimales los ponemos a pi¤¢n, pero es posible que haya que revisarlo.
        DM := '2';  // Para poner los decimales en un futuro.
        OutTextCab := '~K|4\4\4\4\2\2\2\' + DM + '\' + GeneralLedgerSetup."LCY Code" + '\|' + ConvertNumber(CI, FALSE) + '\' + ConvertNumber(GG, FALSE) + '\' + ConvertNumber(BI, FALSE) + '\' + ConvertNumber(BAJA, FALSE) + '\' + ConvertNumber(IVA, FALSE) + '|';
        /////OutTextCab := OutTextCab +'\2\\3\4\\2\5\2\3\3\4\4\5\EUR\||';  NO LO INCLUIMOS PORQUE ENTONCES NO FUNCIONA

        OutFile.WRITE(OutTextCab);
    end;

    //     LOCAL procedure FunctionC (DataPieceworkForProduction@1100286000 :
    LOCAL procedure FunctionC(DataPieceworkForProduction: Record 7207386)
    begin
    end;

    //     LOCAL procedure FunctionD (pLevel@1100286000 : Integer;BreakDown@1100286002 :
    LOCAL procedure FunctionD(pLevel: Integer; BreakDown: Text[20])
    var
        //       DataPieceworkForProduction@1100286001 :
        DataPieceworkForProduction: Record 7207386;
    begin
        if BreakDown <> '' then DataPieceworkForProduction.GET(JobNo, BreakDown);
        TmpDataPieceworkForProduction2.RESET;
        TmpDataPieceworkForProduction2.SETRANGE("Job No.", JobNo);
        TmpDataPieceworkForProduction2.SETRANGE(Indentation, pLevel);
        if BreakDown <> '' then TmpDataPieceworkForProduction2.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling);
        if TmpDataPieceworkForProduction2.FINDSET then
            repeat
                //Habr  que revisar el factor y el rendimiento. ***AML**
                //-Q18345
                if TmpDataPieceworkForProduction2."Code Piecework PRESTO" <> '' then
                    UOCode := TmpDataPieceworkForProduction2."Code Piecework PRESTO"
                else
                    UOCode := TmpDataPieceworkForProduction2."Piecework Code";
                //OutTextCab := '~D|' + TmpDataPieceworkForProduction2."Piecework Code" + '|';
                //OutTextCab := OutTextCab + UOCode + '\1\1\'; //Porque no hay factor ni rendimiento en UO Nosotros los pasamos a nivel de descompuesto.
                OutTextCab := OutTextCab + UOCode + '\1\' + FindQty(TmpDataPieceworkForProduction2."Piecework Code") + '\'; //Porque no hay factor ni rendimiento en UO Nosotros los pasamos a nivel de descompuesto.

            //+Q18345
            until TmpDataPieceworkForProduction2.NEXT = 0;
        OutTextCab := OutTextCab + '|';
        OutFile.WRITE(OutTextCab);
    end;

    LOCAL procedure FunctionT()
    begin
    end;

    LOCAL procedure FunctionM()
    begin
    end;

    //     LOCAL procedure ConvertDate (DateToConvert@1100286000 :
    LOCAL procedure ConvertDate(DateToConvert: Date) DateConverted: Text[10];
    var
        //       Dia@1100286001 :
        Dia: Text[2];
        //       Mes@1100286002 :
        Mes: Text[2];
        //       A¤o@1100286003 :
        Axo: Text[4];
    begin
        //Formato DDMMAAAA
        Dia := STRSUBSTNO('%1', DATE2DWY(DateToConvert, 1));
        if STRLEN(Dia) = 1 then Dia := '0' + Dia;
        Mes := STRSUBSTNO('%1', DATE2DWY(DateToConvert, 1));
        if STRLEN(Mes) = 1 then Mes := '0' + Mes;
        Axo := STRSUBSTNO('%1', DATE2DWY(DateToConvert, 3));
    end;

    //     LOCAL procedure ConvertNumber (NumbertoConvert@1100286000 : Decimal;Decimals@1100286007 :
    LOCAL procedure ConvertNumber(NumbertoConvert: Decimal; Decimals: Boolean) TextNumber: Text[30];
    var
        //       IntegerPart@1100286001 :
        IntegerPart: Decimal;
        //       DecimalPart@1100286002 :
        DecimalPart: Decimal;
        //       TextNumber2@1100286003 :
        TextNumber2: Text[30];
        //       intDM@1100286004 :
        intDM: Integer;
        //       decDM@1100286005 :
        decDM: Decimal;
        //       K@1100286006 :
        K: Integer;
    begin
        //Convertimos un n£mero en texto con indiferencia a los regional Settings
        if NumbertoConvert <> 0 then begin
            NumbertoConvert := NumbertoConvert;
        end;
        if Decimals then begin
            if DM = '' then DM := '2';
            EVALUATE(intDM, DM);
            if intDM = 0 then intDM := 2;
        end
        else begin
            intDM := STRLEN(STRSUBSTNO('%1', NumbertoConvert)) - STRLEN(STRSUBSTNO('%1', ROUND(NumbertoConvert, 1, '<'))) + 1;
        end;
        if intDM <> 0 then begin
            decDM := 1;
            FOR K := 1 TO intDM DO decDM := decDM / 10;
            NumbertoConvert := ROUND(NumbertoConvert, decDM);
        end;
        IntegerPart := ROUND(NumbertoConvert, 1, '<');
        TextNumber := STRSUBSTNO('%1', IntegerPart);
        TextNumber := DELCHR(TextNumber, '=', '.');
        TextNumber := DELCHR(TextNumber, '=', ',');
        if decDM <> 0 then
            DecimalPart := (NumbertoConvert - IntegerPart) * (1 / decDM)
        else
            DecimalPart := 0;

        if DecimalPart <> 0 then begin
            TextNumber2 := STRSUBSTNO('%1', DecimalPart);
            TextNumber2 := DELCHR(TextNumber2, '=', '.');
            TextNumber2 := DELCHR(TextNumber2, '=', ',');
            TextNumber := TextNumber + '.' + TextNumber2;
        end;
    end;

    //     LOCAL procedure FindImport (Breakdown@1100286000 :
    LOCAL procedure FindImport(Breakdown: Code[20]) TextImport: Text[20];
    var
        //       Import@1100286001 :
        Import: Decimal;
        //       DataPieceworkForProduction@1100286002 :
        DataPieceworkForProduction: Record 7207386;
    begin
        //Buscamos el importe de una partida o UO
        Import := 0;
        TextImport := '';
        //Buscamos la partida
        DataPieceworkForProduction.GET(JobNo, Breakdown);
        //Ahora filtramos en el temporal
        if DataPieceworkForProduction.Totaling <> '' then
            TmpMeasurementLines.SETFILTER("Piecework No.", DataPieceworkForProduction.Totaling)
        else
            TmpMeasurementLines.SETRANGE("Piecework No.", Breakdown);
        if TmpMeasurementLines.FINDSET then
            repeat
                if DataPieceworkForProduction.Totaling <> '' then
                    Import += TmpMeasurementLines."Cert Term PEC amount"
                else
                    Import += TmpMeasurementLines."Term PEC Price";
            until TmpMeasurementLines.NEXT = 0;
        //Ahora lo convertimos en texto
        TextImport := ConvertNumber(Import, TRUE);
    end;

    //     LOCAL procedure FindQty (Breakdown@1100286000 :
    LOCAL procedure FindQty(Breakdown: Code[20]) TxtQty: Text[20];
    var
        //       Qty@1100286001 :
        Qty: Decimal;
        //       DataPieceworkForProduction@1100286002 :
        DataPieceworkForProduction: Record 7207386;
    begin
        //Buscamos el importe de una partida o UO
        Qty := 0;
        TxtQty := '';
        //Buscamos la partida

        DataPieceworkForProduction.GET(JobNo, Breakdown);
        if DataPieceworkForProduction.Totaling <> '' then begin
            TxtQty := '1';
            exit;
        end;

        //Ahora filtramos en el temporal
        TmpMeasurementLines.SETRANGE("Piecework No.", Breakdown);
        if TmpMeasurementLines.FINDSET then
            repeat
                Qty += TmpMeasurementLines."Cert Quantity to Term";
            until TmpMeasurementLines.NEXT = 0;
        //Ahora lo convertimos en texto
        TxtQty := ConvertNumber(Qty, FALSE);
    end;

    procedure GetSalesText(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        //       TempBlob@100000001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        //PAGE 7206929
        //Table 7206918
        //Si no tiene texto para venta, retorna el de coste
        //if ("Sales Size" = 0) then
        //exit(GetCostText)
        //else begin
        //CALCFIELDS("Sales Text");
        //{
        //        if not "Sales Text".HASVALUE then
        //          exit('');
        //        CR[1] := 10;
        //        // TempBlob.Blob := "Sales Text";
        /*To be tested*/

        //   TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        //   Blob.Write("Sales Text");
        //   //        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        //   /*To be tested*/

        //   TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        //   InStr.Read(CR);
        //   exit(CR);
        //      }
        //end;
    end;

    //     procedure SetSalesText (pTxt@100000001 :
    procedure SetSalesText(pTxt: Text)
    var
        //       TempBlob@100000000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutSTream;
        InStr: InStream;
        //       cText@1100286000 :
        cText: Text;
    begin
        //CLEAR("Sales Text");
        //{
        //      if pTxt <> '' then begin
        //        cText := GetCostText;
        //        if (pTxt <> cText) then begin
        //          // TempBlob.WriteAsText(pTxt, TEXTENCODING::Windows);
        /*To be tested*/

        //   TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        //   Blob.Write(pTxt);
        //   // //          "Sales Text" := TempBlob.Blob;
        //   /*To be tested*/

        //   TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        //   InStr.Read("Sales Text");
        //        end;
        //      end;
        //      "Sales Size" := "Sales Text".LENGTH;
        //      MODIFY;
        //      }
    end;

    procedure GetCostText(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        //       TempBlob@100000001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        //{
        //      CALCFIELDS("Cost Text");
        //      if not "Cost Text".HASVALUE then
        //        exit('');
        //      CR[1] := 10;
        //      // TempBlob.Blob := "Cost Text";
        /*To be tested*/

        //   TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        //   Blob.Write("Cost Text");
        //   //      // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        //   /*To be tested*/

        //   TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        //   InStr.Read(CR);
        //   exit(CR);
        //      }
    end;

    /*begin
    {

      DEFINICION DEL REGISTRO K
      ~K | //{ DN \ DD \ DS \ DR \ DI \ DP \ DC \ DM \ DIVISA \ } | CI \ GG \ BI \ BAJA \ IVA | //{ DRC \
//          DC \ \ DFS \ DRS \ \ DUO \ DI \ DES \ DN \ DD \ DS \ DSP \ DEC \ DIVISA \ } | [ n ] |
      Definiciones

      DN Decimales del campo n£mero de partes iguales de la hoja de mediciones. Por
      defecto 2 decimales.
      DD Decimales de dimensiones de las tres magnitudes de la hoja de mediciones. Por
      defecto 2 decimales.
      DS Decimales de la l¡nea de subtotal o total de mediciones. Por defecto 2 decimales.
      DR Decimales de rendimiento y factor en una descomposici¢n. Por defecto 3 decimales.
      DI Decimales del importe resultante de multiplicar rendimiento x precio del concepto.
      Por defecto 2 decimales
      DP Decimales del importe resultante del sumatorio de los costes directos del concepto.
      Por defecto 2 decimales
      DC Decimales del importe total del concepto. (CD+CI). Por defecto 2 decimales
      DM Decimales del importe resultante de multiplicar la medici¢n total del concepto por su
      precio. Por defecto 2 decimales
      DIVISA Es la divisa expresada en el mismo modo que las abreviaturas utilizadas por el BCE
      (Banco Central Europeo), que en su caso deber n coincidir con las del registro ~V.
      En el Anexo 6 se indican las actuales.
      CI Costes Indirectos, expresados en porcentaje.
      GG Gastos Generales de la Empresa, expresados en porcentaje
      BI Beneficio Industrial del contratista, expresado en porcentaje.
      BAJA Coeficiente de baja o alza de un presupuesto de adjudicaci¢n, expresado en
      porcentaje.
      IVA Impuesto del Valor A¤adido, expresado en porcentaje.
      DRC Decimales del rendimiento y del factor de rendimiento de un presupuesto, y
      decimales del resultado de su multiplicaci¢n. Por defecto 3 decimales.
      DC Decimales del importe de un presupuesto, de sus capitulos, subcapitulos, etc. y
      l¡neas de medici¢n (unidades de obra excluidas), y decimales de los importes
      resultantes de multiplicar el rendimiento (o medici¢n) total del presupuesto, sus
      capitulos, subcapitulos, etc. y l¡neas de medici¢n (unidades de obra excluidas) por
      sus precios respectivos. Por defecto 2 decimales.
      DFS Decimales de los factores de rendimiento de las unidades de obra y de los elementos
      compuestos. Por defecto 3 decimales.
      DRS Decimales de los rendimientos de las unidades de obra y de los elementos
      compuestos, y decimales del resultado de la multiplicaci¢n de dichos rendimientos
      por sus respectivos factores. Por defecto 3 decimales.
      DUO Decimales del coste total de las unidades de obra. Por defecto 2 decimales.
      DI Decimales de los importes resultantes de multiplicar los rendimientos totales de los
      elementos compuestos y/o elementos simples por sus respectivos precios, decimales
      del importe resultante del sumatorio de los costes directos de la unidad de obra y
      decimales de los costes indirectos. Decimales de los sumatorios sobre los que se
      aplican los porcentajes. Por defecto 2 decimales.
      DES Decimales del importe de los elementos simples. Por defecto 2 decimales.
      DN Decimales del campo n£mero de partes iguales de la hoja de mediciones. Por
      defecto 2 decimales.
      DD Decimales de dimensiones de las tres magnitudes de la hoja de mediciones. Por
      defecto 2 decimales.
      DS Decimales del total de mediciones. Por defecto 2 decimales.
      DSP Decimales de la l¡nea de subtotal de mediciones. Por defecto 2 decimales.
      DEC Decimales del importe de los elementos compuestos. Por defecto 2.
      DIVISA Es la divisa expresada en el mismo modo que las abreviaturas utilizadas por el BCE
      (Banco Central Europeo), que en su caso deber n coincidir con las del registro ~V.
      En el Anexo 6 se indican las actuales.
      n Es el n£mero de la opci¢n de la funci¢n BdcGloParNumero que se refiere al concepto
      divisa

      ***AML*** Cuestiones a revisar
      AML 13/06/23 - Q18345 Exportacion de certificaciones a modelo BC3
    }
    end.
  */

}




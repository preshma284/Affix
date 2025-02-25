report 7207434 "QB Exportar N67"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Lineas"; "QB Crear Efectos Linea")
        {

            DataItemTableView = SORTING("Relacion No.", "Line No.");

            ;
            trigger OnPreDataItem();
            BEGIN
                // COMPROBACIONES Y CHEQUEOS
                IF optBancoEmisor = '' THEN
                    ERROR('Debe especificar el banco emisor');

                //Filtro las l¡neas a considerar
                Lineas.SETRANGE("Relacion No.", varRelacion);
                Lineas.SETFILTER("Tipo Linea", '<>%1', Lineas1."Tipo Linea"::Abono);
                IF (Lineas.COUNT = 0) THEN
                    ERROR('No hay l¡neas de las que generar la N67');

                // INICIO VARIABLES
                CadenaRegistro := '51';
                TotalReg := 0;
                intNumCheques := 0;
                sumaImporte := 0;
                sumaImporteTimbre := 0;
                dateFechaFichero := WORKDATE;

                // DATOS DE MI EMPRESA
                REmpresa.GET();
                NoCif := T(REmpresa."VAT Registration No.", 9);
                VDirMio := T(REmpresa.Name, 50);

                // DATOS DEL BANCO A TRAVES DEL CUAL HAGO LOS CHEQUES O PAGARES
                IF NOT varBancoEmisor.GET(optBancoEmisor) THEN
                    ERROR('No existe el banco emisor especificado ' + optBancoEmisor);

                varBancoEmisor.TESTFIELD("CCC Bank No.");
                varBancoEmisor.TESTFIELD("CCC Bank Branch No.");
                varBancoEmisor.TESTFIELD("CCC Bank Account No.");
                varBancoEmisor.TESTFIELD("CCC Control Digits");
                varBancoEmisor.TESTFIELD("Digitos banco N 67");

                REmpresa.GET();

                CCCNoBanco := varBancoEmisor."CCC Bank No.";
                CCCNoSucBanco := varBancoEmisor."CCC Bank Branch No.";
                CCCNoCta := varBancoEmisor."CCC Bank Account No.";
                CCCDigControl := varBancoEmisor."CCC Control Digits";

                dateFechaFicheroanterior := varBancoEmisor."Fecha ult. fichero N67";
                IF dateFechaFicheroanterior = 0D THEN
                    dateFechaFicheroanterior := dateFechaFichero;

                varBancoEmisor."Fecha ult. fichero N67" := dateFechaFichero;
                varBancoEmisor.MODIFY(TRUE);

                CCCNoBanco := C(CCCNoBanco, 4);
                CCCNoSucBanco := C(CCCNoSucBanco, 4);
                CCCNoCta := C(CCCNoCta, 10);
                CCCDigControl := C(CCCDigControl, 2);

                // DATOS DEL BANCO RECEPTOR DEL FICHERO
                varBancoReceptor.GET(optBancoReceptor);
                varBancoReceptor.TESTFIELD("No.");
                varBancoReceptor.TESTFIELD("CCC Bank No.");
                varBancoReceptor.TESTFIELD("CCC Bank Branch No.");

                ReceptorNoBanco := C(varBancoReceptor."CCC Bank No.", MAXSTRLEN(varBancoReceptor."CCC Bank No."));
                ReceptorNosucBanco := C(varBancoReceptor."CCC Bank Branch No.", MAXSTRLEN(varBancoReceptor."CCC Bank Branch No."));

                //Creo el fichero de salida en el servidor
                ArchSalida.TEXTMODE := TRUE;
                ArchSalida.WRITEMODE := TRUE;
                ExternalFile := FileMgt.ServerTempFileName('');
                ArchSalida.CREATE(ExternalFile);

                // ESCRIBO REGISTRO COMUN DE CABECERA
                CLEAR(TextoSalida);
                TextoSalida := CadenaRegistro + '80' + NoCif + VDirMio + FormateaFecha(dateFechaFichero) +
                               CCCNoBanco + CCCNoSucBanco + CCCDigControl + CCCNoCta + ReceptorNoBanco + ReceptorNosucBanco +
                               FORMAT(optTipoFichero) + FormateaFecha(dateFechaFicheroanterior) + T(' ', 50);
                ArchSalida.WRITE(TextoSalida);

                TotalReg := TotalReg + 1;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF Lineas."No. Pagare" = '' THEN
                    ERROR('No puede generar la Norma 67 si no ha generado los pagar‚s antes');

                IF (Lineas."Currency Code" <> '') THEN
                    ERROR('El diario tiene l¡neas en divisa no local. La norma 67 s¢lo se puede usar en EUROS');

                //Debe incluir solo una l¡nea por cada pagar‚ emitido, no por cada linea de la relaci¢n, pues puede agrupar varias facturas y abonos
                IF STRPOS(txtListaPagares, Lineas."No. Pagare") = 0 THEN BEGIN
                    txtListaPagares += '|' + Lineas."No. Pagare";

                    IF (Lineas."Tipo Linea" = Lineas."Tipo Linea"::Factura) THEN
                        Importe := Lineas."Anticipo Aplicado"
                    ELSE
                        Importe := Lineas.Amount;

                    CadenaRegistro := '56';

                    IF NOT recProveedor.GET(Lineas."Vendor No.") THEN
                        ERROR('No se encuentra el proveedor ' + Lineas."Vendor No.");

                    optCodeSerie := T(optCodeSerie, MAXSTRLEN(optCodeSerie));

                    codeIDDoc := varBancoEmisor."Digitos banco N 67";

                    codeNumCheque := C(Lineas."No. Pagare", MAXSTRLEN(codeNumCheque));

                    codeControlDoc := DigitoControlPAgare(optCodeSerie, codeIDDoc, codeNumCheque);

                    textNombreProveedor := T(recProveedor.Name, 40);

                    textImporte := CONVERTSTR(FORMAT(Importe * 100, 12, '<integer>'), ' ', '0');
                    sumaImporte += Importe;

                    IF COPYSTR(codeIDDoc, 1, 1) = '4' THEN BEGIN

                        //Cheque
                        textFechaDoc := FormateaFecha(Lineas."Document Date");
                        textClaveTimbre := '2';
                        textImporteTimbre := N(0, 10);
                        textFechaDocTimbre := S(8);

                    END ELSE BEGIN

                        //Pagare
                        textFechaDoc := FormateaFecha(Lineas."Due Date");

                        IF optClaveTimbre THEN BEGIN
                            textClaveTimbre := '1';
                            textImporteTimbre := CONVERTSTR(FORMAT(Importe * 100, 10, '<integer>'), ' ', '0');
                            sumaImporteTimbre += Importe;
                        END ELSE BEGIN
                            textClaveTimbre := '2';
                            textImporteTimbre := N(0, 10);
                        END;

                        textFechaDocTimbre := FormateaFecha(Lineas."Document Date");

                    END;

                    IF optAnulacion THEN
                        textAnulacion := '02'
                    ELSE
                        textAnulacion := '01';

                    CLEAR(TextoSalida);
                    TextoSalida := CadenaRegistro + '80' + optCodeSerie + codeIDDoc + codeNumCheque + codeControlDoc +
                                   textNombreProveedor + S(18) + textImporte + textFechaDoc + textAnulacion +
                                   S(16) + textClaveTimbre + textFechaDocTimbre + textImporteTimbre + S(26);
                    ArchSalida.WRITE(TextoSalida);
                    TotalReg := TotalReg + 1;
                    intNumCheques := intNumCheques + 1;
                END;

                "Exported to Payment File" := TRUE;
                MODIFY(TRUE);
            END;

            trigger OnPostDataItem();
            BEGIN
                CadenaRegistro := '58';
                TotalReg := TotalReg + 1;

                textNumCheques := N(intNumCheques, MAXSTRLEN(textNumCheques));
                textImporteTotal := D(sumaImporte, 12);
                textTotalReg := N(TotalReg, 10);
                textImporteTotalTimbre := D(sumaImporteTimbre, 12);

                TextoSalida := CadenaRegistro + '80' + textNumCheques + textImporteTotal + S(6) + textTotalReg +
                               textImporteTotalTimbre + S(106);
                ArchSalida.WRITE(TextoSalida);
                ArchSalida.CLOSE();

                FileMgt.DownloadHandler(ExternalFile, 'Fichero N67', '', 'Archivos de texto (*.txt)|*.txt|Todos los archivos (*.*)|*.*', optArchExt);
                //FileMgt.CopyServerFile(ExternalFile, optArchExt, TRUE);

                Cabecera.GET(varRelacion);
                Cabecera.Fichero := optArchExt;
                Cabecera.MODIFY;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group874")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("optArchExt"; "optArchExt")
                    {

                        CaptionML = ENU = 'Posting Date', ESP = 'Archivo de salida';
                        ToolTipML = ENU = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.', ESP = 'Especifica la fecha de registro de este proceso. La fecha de trabajo se introduce de forma predeterminada, pero es posible cambiarla.';
                    }
                    field("optTipoFichero"; "optTipoFichero")
                    {

                        CaptionML = ESP = 'Tipo de fichero';
                        // OptionCaptionML=ESP='Tipo de fichero';
                    }
                    field("optAnulacion"; "optAnulacion")
                    {

                        CaptionML = ESP = 'Anulaci¢n';
                    }
                    field("optBancoEmisor"; "optBancoEmisor")
                    {

                        CaptionML = ESP = 'Banco';
                        TableRelation = "Bank Account";

                        ; trigger OnValidate()
                        BEGIN
                            AsignaBanco;
                        END;


                    }
                    field("optCodeSerie"; "optCodeSerie")
                    {

                        CaptionML = ESP = 'Serie';
                    }
                    field("optClaveTimbre"; "optClaveTimbre")
                    {

                        CaptionML = ESP = 'Pagar‚ timbrado';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Cabecera@7001115 :
        Cabecera: Record 7206922;
        //       Lineas1@7001128 :
        Lineas1: Record 7206923;
        //       QBRelationshipSetup@7001105 :
        QBRelationshipSetup: Record 7207335;
        //       REmpresa@7001155 :
        REmpresa: Record 79;
        //       recLinDiaGenCheck@7001146 :
        recLinDiaGenCheck: Record 81;
        //       varBancoEmisor@7001126 :
        varBancoEmisor: Record 270;
        //       varBancoReceptor@7001119 :
        varBancoReceptor: Record 270;
        //       recProveedor@7001100 :
        recProveedor: Record 23;
        //       formListaBancos@7001125 :
        formListaBancos: Page 371;
        //       "------------------------------- Opciones de la page"@7001143 :
        "------------------------------- Opciones de la page": Integer;
        //       optArchExt@7001144 :
        optArchExt: Text[30];
        //       optTipoFichero@7001141 :
        optTipoFichero: Option "001","002","003","004";
        //       optAnulacion@7001140 :
        optAnulacion: Boolean;
        //       optBancoEmisor@7001127 :
        optBancoEmisor: Code[10];
        //       optBancoReceptor@7001129 :
        optBancoReceptor: Code[10];
        //       optCodeSerie@7001139 :
        optCodeSerie: Text[3];
        //       optClaveTimbre@7001111 :
        optClaveTimbre: Boolean;
        //       "---------- Fichero"@7001145 :
        "---------- Fichero": Integer;
        //       FileMgt@7001152 :
        FileMgt: Codeunit 419;
        //       ArchSalida@7001149 :
        ArchSalida: File;
        //       ExternalFile@7001148 :
        ExternalFile: Text[1024];
        //       "-----------"@7001142 :
        "-----------": Integer;
        //       varRelacion@7001114 :
        varRelacion: Integer;
        //       Importe@7001151 :
        Importe: Decimal;
        //       textImporte@7001153 :
        textImporte: Text[12];
        //       textImporteTimbre@7001108 :
        textImporteTimbre: Text[12];
        //       sumaImporte@7001150 :
        sumaImporte: Decimal;
        //       sumaImporteTimbre@7001107 :
        sumaImporteTimbre: Decimal;
        //       CadenaRegistro@7001138 :
        CadenaRegistro: Code[2];
        //       CCCNoBanco@7001137 :
        CCCNoBanco: Text[4];
        //       CCCNoSucBanco@7001136 :
        CCCNoSucBanco: Text[4];
        //       CCCNoCta@7001135 :
        CCCNoCta: Text[10];
        //       CCCDigControl@7001134 :
        CCCDigControl: Text[2];
        //       TotalReg@7001133 :
        TotalReg: Integer;
        //       TextoSalida@7001132 :
        TextoSalida: Text[250];
        //       NoCif@7001131 :
        NoCif: Code[9];
        //       dateFechaFichero@7001130 :
        dateFechaFichero: Date;
        //       ReceptorNoBanco@7001124 :
        ReceptorNoBanco: Text[4];
        //       ReceptorNosucBanco@7001123 :
        ReceptorNosucBanco: Text[4];
        //       dateFechaFicheroanterior@7001122 :
        dateFechaFicheroanterior: Date;
        //       codeNumCheque@7001121 :
        codeNumCheque: Code[7];
        //       intNumCheques@7001120 :
        intNumCheques: Integer;
        //       codeIDDoc@7001118 :
        codeIDDoc: Code[4];
        //       codeControlDoc@7001117 :
        codeControlDoc: Code[1];
        //       textNombreProveedor@7001116 :
        textNombreProveedor: Text[40];
        //       textFechaDoc@7001113 :
        textFechaDoc: Text[8];
        //       textAnulacion@7001112 :
        textAnulacion: Text[2];
        //       textClaveTimbre@7001110 :
        textClaveTimbre: Text[1];
        //       textFechaDocTimbre@7001109 :
        textFechaDocTimbre: Text[8];
        //       textNumCheques@7001106 :
        textNumCheques: Text[10];
        //       textImporteTotal@7001104 :
        textImporteTotal: Text[12];
        //       textTotalReg@7001103 :
        textTotalReg: Text[10];
        //       textImporteTotalTimbre@7001102 :
        textImporteTotalTimbre: Text[12];
        //       VDirMio@7001101 :
        VDirMio: Text[50];
        //       txtListaPagares@7001147 :
        txtListaPagares: Text;



    trigger OnInitReport();
    begin
        optTipoFichero := optTipoFichero::"004";
        optArchExt := 'C:\temp\pagos.asc';
    end;



    // LOCAL procedure FormateaFecha (fecha@1100251000 :
    LOCAL procedure FormateaFecha(fecha: Date): Text[8];
    var
        //       auxInt@1100251002 :
        auxInt: Integer;
        //       auxText@1100251003 :
        auxText: Text;
        //       auxCadena@7001100 :
        auxCadena: Text;
    begin
        if fecha = 0D then
            auxCadena := N(0, 8)
        else
            auxCadena := N(DATE2DMY(fecha, 1), 2) + N(DATE2DMY(fecha, 2), 2) + N(DATE2DMY(fecha, 3), 4);

        exit(auxCadena);
    end;

    //     LOCAL procedure T (pText@7001100 : Text;pLon@7001101 :
    LOCAL procedure T(pText: Text; pLon: Integer): Text;
    var
        //       auxText@7001102 :
        auxText: Text;
    begin
        exit(Rellenar(pText, pLon, ' ', FALSE));
    end;

    //     LOCAL procedure C (pText@7001101 : Text;pLon@7001100 :
    LOCAL procedure C(pText: Text; pLon: Integer): Text;
    begin
        exit(Rellenar(pText, pLon, '0', TRUE));
    end;

    //     LOCAL procedure S (pLon@7001100 :
    LOCAL procedure S(pLon: Integer): Text;
    begin
        exit(Rellenar('', pLon, ' ', FALSE));
    end;

    //     LOCAL procedure N (pInt@7001100 : Integer;pLon@7001101 :
    LOCAL procedure N(pInt: Integer; pLon: Integer): Text;
    var
        //       auxText@7001102 :
        auxText: Text;
    begin
        exit(Rellenar(FORMAT(pInt), pLon, '0', TRUE));
    end;

    //     LOCAL procedure D (pImp@7001101 : Decimal;pLon@7001100 :
    LOCAL procedure D(pImp: Decimal; pLon: Integer): Text;
    var
        //       auxText@7001102 :
        auxText: Text;
    begin
        auxText := CONVERTSTR(FORMAT(pImp * 100, pLon, '<integer>'), ' ', '0');
        exit(auxText);
    end;

    //     LOCAL procedure Rellenar (pText@7001100 : Text;pLon@7001101 : Integer;pCar@7001103 : Text;pIzq@7001104 :
    LOCAL procedure Rellenar(pText: Text; pLon: Integer; pCar: Text; pIzq: Boolean): Text;
    var
        //       auxText@7001102 :
        auxText: Text;
    begin
        if pIzq then begin
            auxText := PADSTR('', pLon, pCar) + pText;
            auxText := COPYSTR(auxText, STRLEN(auxText) - pLon + 1);
        end else begin
            auxText := pText + PADSTR('', pLon, pCar);
            auxText := COPYSTR(auxText, 1, pLon);
        end;

        exit(auxText);
    end;

    //     LOCAL procedure DigitoControlPAgare (codeSerieLocal@1100251000 : Code[3];codeIDDocLocal@1100251001 : Code[4];codeNumChequeLocal@1100251002 :
    LOCAL procedure DigitoControlPAgare(codeSerieLocal: Code[3]; codeIDDocLocal: Code[4]; codeNumChequeLocal: Code[7]): Text[1];
    var
        //       auxCode@7001101 :
        auxCode: Code[20];
        //       auxDec@7001100 :
        auxDec: Decimal;
    begin
        auxCode := codeIDDocLocal + codeNumChequeLocal;

        if not EVALUATE(auxDec, auxCode) then
            auxDec := 0;

        exit(COPYSTR(FORMAT(auxDec MOD 7), 1, 1));
    end;

    LOCAL procedure AsignaBanco()
    begin
        if optBancoEmisor <> '' then begin
            varBancoEmisor.GET(optBancoEmisor);
            optCodeSerie := varBancoEmisor."Serie banco";
            optBancoReceptor := optBancoEmisor;
        end else begin
            varBancoEmisor.INIT;
            optCodeSerie := '';
            optBancoReceptor := '';
        end;

        if optBancoReceptor <> '' then
            varBancoReceptor.GET(optBancoReceptor)
        else
            varBancoReceptor.INIT;
    end;

    //     procedure SetFiltros (parRelacion@1100251000 :
    procedure SetFiltros(parRelacion: Integer)
    begin
        varRelacion := parRelacion;
        Cabecera.GET(varRelacion);
        optBancoEmisor := Cabecera."Bank Account No.";
        AsignaBanco;

        QBRelationshipSetup.GET();
        if (QBRelationshipSetup."RP Fichero de Pagos" = '') then begin
            QBRelationshipSetup."RP Fichero de Pagos" := 'N67_R%1.txt';
            QBRelationshipSetup.MODIFY;
        end;
        optArchExt := STRSUBSTNO(QBRelationshipSetup."RP Fichero de Pagos", parRelacion);
    end;

    /*begin
    end.
  */

}




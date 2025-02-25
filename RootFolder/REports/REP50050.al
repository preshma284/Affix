report 50050 "N43 Import"
{


    CaptionML = ENU = 'Import N43', ESP = 'Importar N43';
    ShowPrintStatus = false;
    ProcessingOnly = true;

    dataset
    {

        DataItem("gdiBanco"; "Bank Account")
        {

            DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("Fichero")
                {

                    field("gtBanco.Name"; gtBanco."Name")
                    {

                        CaptionML = ESP = 'Banco';
                        Editable = false;
                    }
                    field("FileNameControl"; "FileName")
                    {

                        CaptionML = ENU = 'File Name', ESP = 'Nombre archivo';



                        ; trigger OnAssistEdit()
                        VAR
                            //                                  FileMgt@1103358000 :
                            FileMgt: Codeunit 419;
                            FileMgt2: Codeunit "File Management 1";
                        BEGIN
                            IF FileName = '' THEN
                                FileName := '.txt';
                            FileName := FileMgt2.OpenFileDialog(Text50000, FileName, '');
                        END;


                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            gtBanco.GET(gdiBanco.GETFILTER("No."));
        END;


    }
    labels
    {
    }

    var
        //       gtBanco@1100286001 :
        gtBanco: Record 270;
        //       BankAccReconciliation@1100286000 :
        BankAccReconciliation: Record 273;
        //       FileName@1103358010 :
        FileName: Text[250];
        //       Files@1103358009 :
        Files: File;
        //       salir@1103358008 :
        salir: Boolean;
        //       nTotalLineas@1103358004 :
        nTotalLineas: Integer;
        //       nLineasImportadas@1103358003 :
        nLineasImportadas: Integer;
        //       FromRecon@1103358000 :
        FromRecon: Boolean;
        //       Text50000@1103358012 :
        Text50000: TextConst ENU = 'Path to export 349 file.', ESP = 'Ruta para importar la Norma 43.';
        //       Text50001@1103358011 :
        Text50001: TextConst ENU = 'Path to export 349 file.', ESP = 'Se han encontrado movimientos repetidos en el extracto de la norma 43. No se puede importar.';



    trigger OnPreReport();
    var
        //                   sCodigoRegistro@1103358015 :
        sCodigoRegistro: Text[2];
        //                   Line@1103358014 :
        Line: Text[80];
        //                   optRespuesta@1103358013 :
        optRespuesta: Option "S¡","No","S¡ a todo","No a todo";
        //                   lcBanco@1103358012 :
        lcBanco: Code[20];
        //                   iMovimiento@1103358011 :
        iMovimiento: Integer;
        //                   dFechaRegistro@1103358010 :
        dFechaRegistro: Date;
        //                   dFechaValor@1103358009 :
        dFechaValor: Date;
        //                   nImporte@1103358008 :
        nImporte: Decimal;
        //                   sConceptoInterb@1103358007 :
        sConceptoInterb: Code[10];
        //                   sConcBanco1@1103358005 :
        sConcBanco1: Text[50];
        //                   sConcBanco2@1103358004 :
        sConcBanco2: Text[50];
        //                   sNumDoc@1103358003 :
        sNumDoc: Code[20];
        //                   tmpBankAccReconciliationLine@1103358002 :
        tmpBankAccReconciliationLine: Record 274 TEMPORARY;
        //                   ltConcInterb@1103358001 :
        ltConcInterb: Record 50002;
        //                   ltMovNorma43Def@1103358000 :
        ltMovNorma43Def: Record 274;
    begin
        //Si no ha introducido fichero --> ERROR
        if FileName = '' then
            ERROR('Introduzca nombre de fichero de Norma 43 a importar.');

        //Primero se realizar n una serie de comprobaciones con la cabecera y el registro tipo 11
        //Despu‚s se importar n los registros tipo 22, mostrando mensajes para registros duplicados y dando
        //a elegir si se quieren importar o no.
        gtBanco.GET(gdiBanco.GETFILTER("No."));   //Buscar el banco por el que hemos filtrado

        cargar_interbancarios;    //Carga la tabla de conceptos interbancarios si no existe

        lcBanco := '';
        iMovimiento := 0;

        //Compruebo el registro tipo 11
        if fCompruebaBanco(FileName, lcBanco) then begin
            //Abro el fichero para poder leerlo
            Files.WRITEMODE(FALSE);
            Files.TEXTMODE(TRUE);
            Files.OPEN(FileName);

            //Voy recorriendo el fichero
            WHILE Files.POS <> Files.LEN DO begin
                //Leo la l¡nea que me toca del fichero
                fLeeLinea(Line);
                //Leo las dos primeras posiciones que me dicen el tipo de registro
                sCodigoRegistro := COPYSTR(Line, 1, 2);

                //Si es del tipo 22, entonces tendr‚ que insertar valores, en cualquier otro caso, no hago nada
                if sCodigoRegistro = '22' then begin
                    //Troceo la l¡nea para obtener los datos
                    iMovimiento += 10000;
                    EVALUATE(dFechaRegistro, COPYSTR(Line, 15, 2) +
                                             COPYSTR(Line, 13, 2) +
                                             COPYSTR(Line, 11, 2));
                    EVALUATE(dFechaValor, COPYSTR(Line, 21, 2) +
                                          COPYSTR(Line, 19, 2) +
                                          COPYSTR(Line, 17, 2));
                    sConceptoInterb := COPYSTR(Line, 23, 2);

                    EVALUATE(nImporte, COPYSTR(Line, 29, 14));
                    nImporte := nImporte / 100;
                    if COPYSTR(Line, 28, 1) = '2' then
                        nImporte := -nImporte;

                    //El n£mero de documento puede venir con caracteres alfanum‚ricos
                    //L¡nea modificada: EVALUATE(sNumDoc, COPYSTR(Line, 43, 11));
                    sNumDoc := COPYSTR(Line, 43, 11);

                    sConcBanco1 := '';
                    sConcBanco2 := '';

                    tmpBankAccReconciliationLine.INIT;
                    tmpBankAccReconciliationLine."Bank Account No." := lcBanco;
                    tmpBankAccReconciliationLine."Statement No." := BankAccReconciliation."Statement No.";
                    tmpBankAccReconciliationLine."Statement Line No." := iMovimiento;
                    tmpBankAccReconciliationLine."Transaction Date" := dFechaRegistro;
                    tmpBankAccReconciliationLine."Value Date" := dFechaValor;
                    tmpBankAccReconciliationLine."Concepto Interbancario" := sConceptoInterb;
                    tmpBankAccReconciliationLine.VALIDATE("Statement Amount", nImporte);


                    //El n£mero de documento puede venir con caracteres alfanum‚ricos
                    //L¡nea modificada: ltMovNorma43."N§ Documento" := iNumDoc;
                    tmpBankAccReconciliationLine."Document No." := sNumDoc;

                    tmpBankAccReconciliationLine.Description := '';
                    tmpBankAccReconciliationLine."Description 2" := '';
                    tmpBankAccReconciliationLine.INSERT;

                end else if sCodigoRegistro = '23' then begin
                    if iMovimiento > 0 then begin
                        if sConcBanco1 = '' then
                            sConcBanco1 := COPYSTR(Line, 5, 38);
                        if sConcBanco2 = '' then
                            sConcBanco2 := COPYSTR(Line, 43, 38);
                        //Actualizo el movimiento anterior
                        if tmpBankAccReconciliationLine.GET(0, lcBanco, BankAccReconciliation."Statement No.", iMovimiento) then begin
                            tmpBankAccReconciliationLine.Description := sConcBanco1;
                            tmpBankAccReconciliationLine."Description 2" := sConcBanco2;
                            tmpBankAccReconciliationLine.MODIFY;
                        end;
                    end;
                end;
            end; //Fin del WHILE que recorre el fichero

            nTotalLineas := 0;
            nLineasImportadas := 0;

            //Ahora ya lo tengo en la tabla temporal, as¡ que me pongo a importarlo a real
            //Busco el £ltimo n£mero de movimiento y le sumar‚ 10000 para cada registro
            ltMovNorma43Def.RESET;
            ltMovNorma43Def.SETRANGE("Bank Account No.", tmpBankAccReconciliationLine."Bank Account No.");
            ltMovNorma43Def.SETRANGE("Statement No.", tmpBankAccReconciliationLine."Statement No.");
            if ltMovNorma43Def.FINDLAST then
                iMovimiento := ltMovNorma43Def."Statement Line No." + 10000
            else
                iMovimiento := 10000;

            if (tmpBankAccReconciliationLine.ISEMPTY) then
                ERROR('No se han encontrado registros de la Norma 43 para importar, revise el fichero.');

            tmpBankAccReconciliationLine.FINDFIRST;
            repeat
                //Inicializo la variable para saber si hay que insertar o no
                nTotalLineas += 1;

                //           {--------------------------------------------------------------------------------------------------------------
                //           //Miro si est  repetido
                //           //Si est  repetido, tengo que mirar si quiere importar o no
                //           ltMovNorma43Def.RESET;
                // ltMovNorma43Def.SETRANGE("Bank Account No.", tmpBankAccReconciliationLine."Bank Account No.");
                // ltMovNorma43Def.SETRANGE("Transaction Date", tmpBankAccReconciliationLine."Transaction Date");
                // ltMovNorma43Def.SETRANGE("Value Date", tmpBankAccReconciliationLine."Value Date");
                // ltMovNorma43Def.SETRANGE("Concepto Interbancario", tmpBankAccReconciliationLine."Concepto Interbancario");
                // ltMovNorma43Def.SETRANGE(Description, tmpBankAccReconciliationLine.Description);
                // ltMovNorma43Def.SETRANGE("Concepto banco 2", tmpBankAccReconciliationLine."Concepto banco 2");
                // //Compruebo tambi‚n con el n£mero de documento y el importe
                // ltMovNorma43Def.SETRANGE("Document No.", tmpBankAccReconciliationLine."Document No.");
                // ltMovNorma43Def.SETRANGE("Statement Amount", -tmpBankAccReconciliationLine."Statement Amount");
                // if ltMovNorma43Def.FINDFIRST then begin
                //     //DCR ERROR(Text50001) ;
                // end;
                //           --------------------------------------------------------------------------------------------------------------}

                nLineasImportadas += 1;

                ltMovNorma43Def.INIT;
                ltMovNorma43Def.VALIDATE("Statement Type", tmpBankAccReconciliationLine."Statement Type"::"Bank Reconciliation");
                ltMovNorma43Def.VALIDATE("Bank Account No.", tmpBankAccReconciliationLine."Bank Account No.");
                ltMovNorma43Def.VALIDATE("Statement No.", tmpBankAccReconciliationLine."Statement No.");
                ltMovNorma43Def.VALIDATE("Statement Line No.", iMovimiento);
                ltMovNorma43Def.VALIDATE("Transaction Date", tmpBankAccReconciliationLine."Transaction Date");
                ltMovNorma43Def."Value Date" := tmpBankAccReconciliationLine."Value Date";
                ltMovNorma43Def."Concepto Interbancario" := tmpBankAccReconciliationLine."Concepto Interbancario";
                //Cambiar el signo en la importaci¢n
                ltMovNorma43Def.VALIDATE("Statement Amount", -tmpBankAccReconciliationLine."Statement Amount");
                ltMovNorma43Def."Document No." := tmpBankAccReconciliationLine."Document No.";
                ltMovNorma43Def.Description := tmpBankAccReconciliationLine.Description;
                ltMovNorma43Def."Description 2" := tmpBankAccReconciliationLine."Description 2";
                ltMovNorma43Def.INSERT;

                iMovimiento += 10000;
            until tmpBankAccReconciliationLine.NEXT = 0;

            if nTotalLineas > 0 then begin
                MESSAGE('Total de l¡neas a importar: ' + FORMAT(nTotalLineas) + '\' +
                        'Total de l¡neas importadas: ' + FORMAT(nLineasImportadas));
            end;

            Files.CLOSE; //Cerrar el fichero
        end;
    end;



    // procedure fCompruebaBanco (psFichero@1100000 : Text[250];var pcBanco@1100011 :
    procedure fCompruebaBanco(psFichero: Text[250]; var pcBanco: Code[20]) bCorrecto: Boolean;
    var
        //       bLineaEncontrada@1100001 :
        bLineaEncontrada: Boolean;
        //       sCodigoRegistro@1100002 :
        sCodigoRegistro: Text[2];
        //       sClaveBanco@1100003 :
        sClaveBanco: Text[4];
        //       sClaveOficina@1100004 :
        sClaveOficina: Text[4];
        //       sNumeroCuenta@1100005 :
        sNumeroCuenta: Text[10];
        //       dFechaRegistro@1100006 :
        dFechaRegistro: Date;
        //       ltMovNorma43@1100009 :
        ltMovNorma43: Record 274;
        //       Line@1100010 :
        Line: Text[80];
        //       ltBanco@1100012 :
        ltBanco: Record 270;
        //       FileManagement@1103358000 :
        FileManagement: Codeunit 419;

        FileManagement2: Codeunit "File Management 1";
    begin
        //Realizo comprobaciones con el banco y el primer registro de tipo 11 que me encuentre
        //Devuelvo true si todo va bien, y false en caso de que encuentre algo que no permita continuar
        //Ser  aqu¡ donde muestre el mensaje correspondiente al problema que encuentre
        CLEAR(FileManagement);
        bCorrecto := TRUE; //Lo pongo a true y si encuentro alg£n problema, lo cambio.
        bLineaEncontrada := FALSE; //Lo pongo a false, cuando encuentre la primera l¡nea 11 lo pongo a true para no seguir
        pcBanco := '';

        //Abrir el fichero
        Files.WRITEMODE(FALSE);
        Files.TEXTMODE(TRUE);
        FileName := FileManagement2.UploadFileSilent(FileName);
        Files.OPEN(FileName);

        //Recorro el fichero.  Parar‚ si he encontrado una l¡nea 11.
        WHILE (Files.POS <> Files.LEN) and (not bLineaEncontrada) DO begin
            //Leo una l¡nea
            fLeeLinea(Line);

            sCodigoRegistro := COPYSTR(Line, 1, 2);
            if sCodigoRegistro = '11' then begin
                bLineaEncontrada := TRUE; //Para que salga del bucle

                //Troceo la l¡nea para obtener los datos que me interesan
                sClaveBanco := COPYSTR(Line, 3, 4);
                sClaveOficina := COPYSTR(Line, 7, 4);
                sNumeroCuenta := COPYSTR(Line, 11, 10);
                EVALUATE(dFechaRegistro, COPYSTR(Line, 25, 2) +
                                                COPYSTR(Line, 23, 2) +
                                                COPYSTR(Line, 21, 2));

                //Compruebo el banco
                if (sClaveBanco <> gtBanco."CCC Bank No.") or (sClaveOficina <> gtBanco."CCC Bank Branch No.")
                   or (sNumeroCuenta <> gtBanco."CCC Bank Account No.") then begin
                    //Como no coincide, informo al usuario, y si continua, importar‚ con el c¢digo del banco
                    //desde el que se lanza el proceso

                    bCorrecto :=
                      CONFIRM('No coinciden los datos del banco con el registro tipo 11 del fichero.\' +
                        'Banco: ' + gtBanco."CCC Bank No." + ' ' + gtBanco."CCC Bank Branch No." + ' ' + gtBanco."CCC Bank Account No." + '\' +
                        'Fichero: ' + sClaveBanco + ' ' + sClaveOficina + ' ' + sNumeroCuenta + '\' +
                        '¨Desea continuar de todas formas?');

                    if bCorrecto then
                        pcBanco := gtBanco."No."
                    else
                        pcBanco := '';

                end else begin
                    //Como ha encontrado el banco, lo guardo como banco donde quiero importar.
                    pcBanco := gtBanco."No.";
                end;
                if pcBanco <> '' then begin
                    //Compruebo que no haya movimientos de conciliaci¢n con fecha igual al que ha llegado
                    ltMovNorma43.RESET;
                    ltMovNorma43.SETRANGE("Bank Account No.", pcBanco);
                    ltMovNorma43.SETRANGE("Transaction Date", dFechaRegistro);
                    if ltMovNorma43.FINDFIRST then begin
                        bCorrecto := CONFIRM('Encontrado movimiento para este banco con la misma fecha.\' +
                                             '¨Desea continuar de todas formas?');
                    end;
                end;
            end;
        end;

        Files.CLOSE;
    end;

    //     procedure fLeeLinea (var pCadenaLinea@1100000 :
    procedure fLeeLinea(var pCadenaLinea: Text[80])
    var
        //       Linea@1100001 :
        Linea: Text[100];
    begin
        pCadenaLinea := '';
        Files.READ(Linea);
        if STRLEN(Linea) > 80 then
            pCadenaLinea := COPYSTR(Linea, 1, 80)
        else
            pCadenaLinea := Linea;
    end;

    //     procedure SetConciliation (pBankAccReconciliation@1103358000 :
    procedure SetConciliation(pBankAccReconciliation: Record 273)
    begin
        BankAccReconciliation := pBankAccReconciliation;
        FromRecon := TRUE;
    end;

    LOCAL procedure cargar_interbancarios()
    var
        //       CT@1100286000 :
        CT: Record 50006;
    begin
        CT.Codigo := '01';
        CT.Descripcion := 'TALONES - REINTEGROS';
        if not CT.INSERT then;
        CT.Codigo := '02';
        CT.Descripcion := 'ABONARS - ENTREGAS - INGRESOS';
        if not CT.INSERT then;
        CT.Codigo := '03';
        CT.Descripcion := 'DOMICILIADOS - RECIBOS - LETRAS - PAGOS POR SU CTA.';
        if not CT.INSERT then;
        CT.Codigo := '04';
        CT.Descripcion := 'GIROS - TRANSFERENCIAS - TRASPASOS - CHEQUES';
        if not CT.INSERT then;
        CT.Codigo := '05';
        CT.Descripcion := 'AMORTIZACIONES PRSTAMOS, CRDITOS, ETC.';
        if not CT.INSERT then;
        CT.Codigo := '06';
        CT.Descripcion := 'REMESAS EFECTOS';
        if not CT.INSERT then;
        CT.Codigo := '07';
        CT.Descripcion := 'SUSCRIPCIONES - DIV. PASIVOS - CANJES.';
        if not CT.INSERT then;
        CT.Codigo := '08';
        CT.Descripcion := 'DIV. CUPONES - PRIMA JUNTA - AMORTIZACIONES';
        if not CT.INSERT then;
        CT.Codigo := '09';
        CT.Descripcion := 'OPERACIONES DE BOLSA Y/O COMPRA /VENTA VALORES';
        if not CT.INSERT then;
        CT.Codigo := '10';
        CT.Descripcion := 'CHEQUES GASOLINA';
        if not CT.INSERT then;
        CT.Codigo := '11';
        CT.Descripcion := 'CAJERO AUTOMµTICO';
        if not CT.INSERT then;
        CT.Codigo := '12';
        CT.Descripcion := 'TARJETAS DE CRDITO - TARJETAS DBITO';
        if not CT.INSERT then;
        CT.Codigo := '13';
        CT.Descripcion := 'OPERACIONES EXTRANJERO';
        if not CT.INSERT then;
        CT.Codigo := '14';
        CT.Descripcion := 'DEVOLUCIONES E IMPAGADOS';
        if not CT.INSERT then;
        CT.Codigo := '15';
        CT.Descripcion := 'NàMINAS - SEGUROS SOCIALES';
        if not CT.INSERT then;
        CT.Codigo := '16';
        CT.Descripcion := 'TIMBRES - CORRETAJE - PàLIZA';
        if not CT.INSERT then;
        CT.Codigo := '17';
        CT.Descripcion := 'INTERESES - COMISIONES Í CUSTODIA - GASTOS E IMPUESTOS';
        if not CT.INSERT then;
        CT.Codigo := '98';
        CT.Descripcion := 'ANULACIONES - CORRECCIONES ASIENTO';
        if not CT.INSERT then;
        CT.Codigo := '99';
        CT.Descripcion := 'VARIOS';
        if not CT.INSERT then;
    end;

    /*begin
    //{
//      JAV 15/09/20: - QB 1.06.14 Proceso para importar la Conciliaci¢n bancaria Norma 43
//    }
    end.
  */

}




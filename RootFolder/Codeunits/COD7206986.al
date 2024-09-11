Codeunit 7206986 "QB Cost Database"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        OPCerror: Option "Header","Desc";

    LOCAL PROCEDURE "--------------------------- Calcular todo"();
    BEGIN
    END;

    PROCEDURE CD_CalculateAll(VAR pCostDatabase: Record 7207271; pMessages: Boolean);
    VAR
        Piecework: Record 7207277;
        Piecework2: Record 7207277;
        Window: Dialog;
        GrossProfit: Decimal;
    BEGIN
        //JAV 24/11/22: - QB 1.12.24 Calcular a partir de las unidades de mayor que sean de �ltimo nivel las superiores

        IF (pMessages) THEN
            Window.OPEN('Proceso #1########################\' +
                        'Leyendo #2########################');

        //Ajustamos precios de todas las partidas
        IF (pMessages) THEN
            Window.UPDATE(1, 'Procesando partidas');

        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
        IF Piecework.FINDSET(TRUE) THEN
            REPEAT
                IF (pMessages) THEN
                    Window.UPDATE(2, Piecework."No.");

                Piecework.CalculateUnit;

                IF Piecework."Proposed Sale Price" <> 0 THEN
                    GrossProfit := ROUND(100 * (1 - Piecework."Price Cost" / Piecework."Proposed Sale Price"), 0.00001)
                ELSE
                    GrossProfit := 0;

                Piecework.VALIDATE("% Margin");
                Piecework.VALIDATE("Gross Profit Percentage", GrossProfit);
                Piecework.MODIFY;
            UNTIL Piecework.NEXT = 0;

        //Calculamos los cap�tulos
        IF (pMessages) THEN
            Window.UPDATE(1, 'Calculando totales');
        Piecework.RESET;
        Piecework.SETCURRENTKEY("Cost Database Default", "No.");
        Piecework.SETASCENDING("No.", FALSE);
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        IF Piecework.FINDSET(TRUE) THEN
            REPEAT
                IF (pMessages) THEN
                    Window.UPDATE(2, Piecework."No.");
                Piecework.CalculateLine();
                Piecework.MODIFY(FALSE);
            UNTIL Piecework.NEXT = 0;

        IF (pMessages) THEN
            Window.CLOSE;
    END;

    LOCAL PROCEDURE "--------------------------- Tratar los errores"();
    BEGIN
    END;

    PROCEDURE CD_ClearErrors(VAR pCostDatabase: Record 7207271);
    BEGIN
        CD_SetError(pCostDatabase, OPCerror::Desc, '', 0);
        CD_SetError(pCostDatabase, OPCerror::Header, '', 0);
    END;

    PROCEDURE CD_GetError(VAR pCostDatabase: Record 7207271; pType: Option): Text;
    VAR
        CR: Text[1];
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    BEGIN
        CR[1] := 10;
        CASE pType OF
            OPCerror::Header:
                BEGIN
                    pCostDatabase.CALCFIELDS("Errors Header Text");
                    //TempBlob.Blob := pCostDatabase."Errors Header Text";
                    TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                    Blob.Write(pCostDatabase."Errors Header Text");
                END;
            OPCerror::Desc:
                BEGIN
                    pCostDatabase.CALCFIELDS("Errors Desc Text");
                    //TempBlob.Blob := pCostDatabase."Errors Desc Text";
                    TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                    Blob.Write(pCostDatabase."Errors Desc Text");
                END;
        END;
        //IF (NOT TempBlob.Blob.HASVALUE) THEN
        IF (NOT TempBlob.HASVALUE) THEN
            EXIT('')
        ELSE
            // EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::Windows));
            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    END;

    PROCEDURE CD_SetError(VAR pCostDatabase: Record 7207271; pType: Option; pText: Text; pNro: Integer);
    VAR
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    BEGIN
        //TempBlob.WriteAsText(pText, TEXTENCODING::Windows);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(pText);
        CASE pType OF
            OPCerror::Header:
                BEGIN
                    //pCostDatabase."Errors Header Text" := TempBlob.Blob;
                    TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                    Instr.Read(pCostDatabase."Errors Header Text");
                    pCostDatabase."Errors Header No." := pNro;
                END;
            OPCerror::Desc:
                BEGIN
                    //pCostDatabase."Errors Desc Text" := TempBlob.Blob;
                    TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                    Instr.Read(pCostDatabase."Errors Desc Text");
                    pCostDatabase."Errors Desc No." := pNro;
                END;
        END;

        IF NOT pCostDatabase.MODIFY THEN
            pCostDatabase.INSERT;
    END;

    PROCEDURE CD_ReviseAll(VAR pCostDatabase: Record 7207271; pMaxDif: Decimal);
    VAR
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
        BillofItemData2: Record 7207384;
        Window: Dialog;
        Amt1: Decimal;
        Amt2: Decimal;
        Dif1: Decimal;
        Dif2: Decimal;
        Msg: Text;
        CRLF: Text[2];
        CodUnit: Text;
        LastUnit: Text;
        nErrores1: Integer;
        nErrores2: Integer;
        txtError: Text;
    BEGIN
        //Revisi�n del preciario
        CD_ClearErrors(pCostDatabase);
        CRLF[1] := 10;
        CRLF[2] := 13;

        Window.OPEN('   Paso #1########################\' +
                    'Proceso #2########################\' +
                    'Leyendo #3########################');
        Window.UPDATE(1, 'Revisando Datos');

        Window.UPDATE(2, 'Cap/Part');
        LastUnit := '';
        nErrores1 := 0;
        txtError := '';

        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        IF (Piecework.FINDSET(FALSE)) THEN
            REPEAT
                Window.UPDATE(3, Piecework."No.");
                CodUnit := Piecework."No.";

                //Mirar las diferencias entre coste y venta
                //    IF (Piecework."PRESTO Code Cost" <> Piecework."PRESTO Code Sales") THEN BEGIN
                //      Msg := '';
                //      IF (LastUnit <> CodUnit) THEN BEGIN
                //        Msg := STRSUBSTNO('Unidad %1:', Piecework."No.");
                //        Msg += CRLF;
                //        LastUnit := CodUnit;
                //        nErrores1 += 1;
                //      END;
                //
                //      IF (Piecework."PRESTO Code Cost" = '') THEN
                //        Msg += STRSUBSTNO('     Unidad de venta sin unidad de coste')
                //      ELSE IF (Piecework."PRESTO Code Sales" = '') THEN
                //        Msg += STRSUBSTNO('     Unidad de coste sin unidad de venta')
                //      ELSE
                //        Msg += STRSUBSTNO('     La unidad de coste es diferente a la de venta');
                //
                //      txtError += Msg + CRLF;
                //      //AddError(OPCerror::Header, Msg);
                //    END;

                //Mirar los precios
                IF (Piecework."Account Type" = Piecework."Account Type"::Heading) THEN BEGIN
                    Amt1 := Piecework."Price Cost";
                    Amt2 := Piecework."Proposed Sale Price";
                END ELSE BEGIN
                    Amt1 := Piecework."Base Price Cost";
                    Amt2 := Piecework."Base Price Sales";
                END;
                Dif1 := ABS(Amt1 - (Piecework."Received Cost Price" - Piecework."Received % Amount Cost"));    // Diferencia entre lo calculado y lo (Recibido menos porcentual eliminado)
                Dif2 := ABS(Amt2 - (Piecework."Received Sales Price" - Piecework."Received % Amount Sales"));

                IF (Dif1 > pMaxDif) OR (Dif2 > pMaxDif) THEN BEGIN
                    Msg := '';
                    IF (LastUnit <> CodUnit) THEN BEGIN
                        Msg := STRSUBSTNO('Unidad %1:', Piecework."No.");
                        Msg += CRLF;
                        LastUnit := CodUnit;
                        nErrores1 += 1;
                    END;

                    IF (Dif1 > pMaxDif) THEN
                        Msg += STRSUBSTNO('     Dif. en coste de %1, calculado %2 recibido %3', Dif1, Amt1, Piecework."Received Cost Price" - Piecework."Received % Amount Cost");
                    IF (Dif1 > pMaxDif) AND (Dif2 > pMaxDif) THEN
                        Msg += CRLF;
                    IF (Dif2 > pMaxDif) THEN
                        Msg += STRSUBSTNO('     Dif. en venta de %1, calculado %2 recibido %3', Dif2, Amt2, Piecework."Received Sales Price" - Piecework."Received % Amount Sales");

                    txtError += Msg + CRLF;
                    //AddError(OPCerror::Header, Msg);
                END;

                //Mirar que todas las partidas tengan los descompuestos de coste, los de venta no son necesarios
                IF (Piecework."Account Type" = Piecework."Account Type"::Unit) AND (Piecework."PRESTO Code Cost" <> '') AND (Piecework."Received Cost Price" <> 0) THEN BEGIN
                    BillofItemData2.RESET;
                    BillofItemData2.SETCURRENTKEY("Cod. Cost database", "Cod. Piecework", "Order No.", Use, Type, "No.");
                    BillofItemData2.SETRANGE("Cod. Cost database", pCostDatabase.Code);
                    BillofItemData2.SETRANGE("Cod. Piecework", Piecework."No.");
                    BillofItemData2.SETRANGE(Use, BillofItemData.Use::Cost);
                    BillofItemData2.SETFILTER(Type, '%1|%2', BillofItemData2.Type::Item, BillofItemData2.Type::Resource);
                    IF (BillofItemData2.ISEMPTY) THEN BEGIN
                        Msg := '';
                        IF (LastUnit <> CodUnit) THEN BEGIN
                            Msg := STRSUBSTNO('Unidad %1:', Piecework."No.");
                            Msg += CRLF;
                            LastUnit := CodUnit;
                            nErrores1 += 1;
                        END;
                        Msg += STRSUBSTNO('     No tiene descompuestos de tipo producto o recurso', BillofItemData.Use);

                        txtError += Msg + CRLF;
                        //AddError(OPCerror::Desc, Msg);
                    END;
                END;

                // Mirar las mediciones
                IF (Piecework."Account Type" = Piecework."Account Type"::Unit) THEN BEGIN
                    IF (Piecework."Production Unit") THEN
                        Dif1 := ROUND(ABS(Piecework."Measurement Cost" - Piecework."Received Cost Medition"), 0.01)
                    ELSE
                        Dif1 := 0;
                    IF (Piecework."Certification Unit") THEN
                        Dif2 := ROUND(ABS(Piecework."Measurement Sale" - Piecework."Received Sales Medition"), 0.01)
                    ELSE
                        Dif2 := 0;

                    IF (Dif1 <> 0) OR (Dif2 <> 0) THEN BEGIN
                        Msg := '';
                        IF (LastUnit <> CodUnit) THEN BEGIN
                            Msg := STRSUBSTNO('Unidad %1:', Piecework."No.");
                            Msg += CRLF;
                            LastUnit := CodUnit;
                            nErrores1 += 1;
                        END;

                        IF (Dif1 <> 0) THEN
                            Msg += STRSUBSTNO('     Dif. en medici�n coste %1%2, calculado %3 recibido %4', Dif1, Piecework."Units of Measure", Piecework."Measurement Cost", Piecework."Received Cost Medition");
                        IF (Dif1 <> 0) AND (Dif2 <> 0) THEN
                            Msg += CRLF;
                        IF (Dif2 <> 0) THEN
                            Msg += STRSUBSTNO('     Dif. en medici�n venta %1%2, calculado %3 recibido %4', Dif2, Piecework."Units of Measure", Piecework."Measurement Sale", Piecework."Received Sales Medition");

                        txtError += Msg + CRLF;
                        //AddError(OPCerror::Header, Msg);
                    END;
                END;
                LastUnit := CodUnit;
            UNTIL (Piecework.NEXT = 0);

        CD_SetError(pCostDatabase, OPCerror::Header, txtError, nErrores1);

        Window.UPDATE(2, 'Revisando Descompuestos');
        LastUnit := '';
        nErrores2 := 0;
        txtError := '';
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
        IF (BillofItemData.FINDSET(FALSE)) THEN
            REPEAT
                Window.UPDATE(3, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No.");
                CodUnit := BillofItemData."Cod. Piecework" + '-' + BillofItemData."Order No.";

                //Revisar solo de los de tipo nuevo con el campo "Orden" relleno, si no sacar� de los anteriores que no tiene sentido
                IF (BillofItemData."Order No." <> '') THEN BEGIN
                    //Mirar los auxiliares sin hijo
                    IF (BillofItemData.Type = BillofItemData.Type::"Posting U.") THEN BEGIN
                        BillofItemData2.RESET;
                        BillofItemData2.SETCURRENTKEY("Cod. Cost database", "Cod. Piecework", "Order No.", Use, Type, "No.");
                        BillofItemData2.SETRANGE("Cod. Cost database", pCostDatabase.Code);
                        BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                        BillofItemData2.SETRANGE(Use, BillofItemData.Use);
                        BillofItemData2.SETRANGE("Father Code", BillofItemData."Order No.");
                        IF (BillofItemData2.ISEMPTY) THEN BEGIN
                            Msg := '';
                            IF (LastUnit <> CodUnit) THEN BEGIN
                                Msg := STRSUBSTNO('Unidad %1, Descompuesto %2:', BillofItemData."Cod. Piecework", BillofItemData."Order No.");
                                Msg += CRLF;
                                LastUnit := CodUnit;
                                nErrores2 += 1;
                            END;
                            Msg += STRSUBSTNO('     La unidad de %1 no tiene descompuestos', BillofItemData.Use);

                            txtError += Msg + CRLF;
                            //AddError(OPCerror::Desc, Msg);
                        END;
                    END;

                    //Mirar los no auxiliares con hijos
                    IF (BillofItemData.Type <> BillofItemData.Type::"Posting U.") THEN BEGIN
                        BillofItemData2.RESET;
                        BillofItemData2.SETCURRENTKEY("Cod. Cost database", "Cod. Piecework", "Order No.", Use, Type, "No.");
                        BillofItemData2.SETRANGE("Cod. Cost database", pCostDatabase.Code);
                        BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                        BillofItemData2.SETRANGE(Use, BillofItemData.Use);
                        BillofItemData2.SETRANGE("Father Code", BillofItemData."Order No.");
                        IF (NOT BillofItemData2.ISEMPTY) THEN BEGIN
                            Msg := '';
                            IF (LastUnit <> CodUnit) THEN BEGIN
                                Msg := STRSUBSTNO('Unidad %1, Descompuesto %2  %3:', BillofItemData."Cod. Piecework", BillofItemData."Order No.", BillofItemData."Presto Code");
                                Msg += CRLF;
                                LastUnit := CodUnit;
                                nErrores2 += 1;
                            END;
                            Msg += STRSUBSTNO('     La unidad de %1 de tipo %2 tiene descompuestos', BillofItemData.Use, BillofItemData.Type);

                            txtError += Msg + CRLF;
                            //AddError(OPCerror::Desc, Msg);
                        END;
                    END;
                END;

                Dif1 := ROUND(ABS(BillofItemData."Base Unit Cost" - BillofItemData."Received Price"), 0.01);
                IF (Dif1 > pMaxDif) THEN BEGIN
                    Msg := '';
                    IF (LastUnit <> CodUnit) THEN BEGIN
                        Msg := STRSUBSTNO('Unidad %1, Descompuesto %2  %3:', BillofItemData."Cod. Piecework", BillofItemData."Order No.", BillofItemData."Presto Code");
                        Msg += CRLF;
                        LastUnit := CodUnit;
                        nErrores2 += 1;
                    END;
                    Msg += STRSUBSTNO('     Dif. en %1 %2, calculado %3 recibido %4', BillofItemData.Use, Dif1, BillofItemData."Base Unit Cost", BillofItemData."Received Price");

                    txtError += Msg + CRLF;
                    //AddError(OPCerror::Desc, Msg);
                END;
            //++LastUnit := CodUnit;
            UNTIL (BillofItemData.NEXT = 0);

        CD_SetError(pCostDatabase, OPCerror::Desc, txtError, nErrores2);

        Window.CLOSE;

        IF (nErrores1 + nErrores2 <> 0) THEN
            MESSAGE('Encontrados %1 errores, rev�selos.', nErrores1 + nErrores2);
    END;

    LOCAL PROCEDURE "--------------------------- Calcular los CI"();
    BEGIN
    END;

    PROCEDURE CD_CalculateCI(VAR pCostDatabase: Record 7207271; pType: Option "Cost","Sale");
    VAR
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
        Window: Dialog;
    BEGIN
        //--------------------------------------------------------------------------------------------------------
        //JAV 05/12/22: - QB 1.12.24 Calcular los precios cuando cambia el CI
        //--------------------------------------------------------------------------------------------------------
        Window.OPEN('Procesando #1########################\' +
                    '    Unidad #2########################');

        //Guardamos el registro para que los procesos por debajo lo puedan leer correctamente
        pCostDatabase.MODIFY;

        Window.UPDATE(1, 'Unidades');
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        IF (Piecework.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(2, Piecework."No.");
                IF (pType = pType::Cost) THEN
                    Piecework.VALIDATE("Base Price Cost")
                ELSE
                    Piecework.VALIDATE("Base Price Sales");
                Piecework.MODIFY;
            UNTIL (Piecework.NEXT = 0);

        Window.UPDATE(1, 'Descompuestos');
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
        IF (pType = pType::Cost) THEN
            BillofItemData.SETRANGE(Use, BillofItemData.Use::Cost)
        ELSE
            BillofItemData.SETRANGE(Use, BillofItemData.Use::Sales);
        IF (BillofItemData.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(2, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No.");
                BillofItemData.VALIDATE("Base Unit Cost");
                BillofItemData.MODIFY;
            UNTIL (BillofItemData.NEXT = 0);

        Window.CLOSE;
    END;

    PROCEDURE CD_Update(VAR pCostDatabase: Record 7207271);
    VAR
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
        Window: Dialog;
    BEGIN
        //Actualizar datos a la vesi�n 1 para que sea manejable por los nuevos procesos

        Window.OPEN('Actualizando #1########################\' +
                    '      Unidad #2########################');
        IF pCostDatabase.Code = '' THEN EXIT;

        //Por si lo han tocado evitamos problemas y ponemos la nueva versi�n
        pCostDatabase."CI Cost" := 0;
        pCostDatabase."CI Sales" := 0;
        pCostDatabase.Version := 1;
        pCostDatabase.MODIFY;

        Window.UPDATE(1, 'Unidades');
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        IF (Piecework.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(2, Piecework."No.");
                Piecework."Base Price Cost" := Piecework."Price Cost";
                Piecework."Base Price Sales" := Piecework."Proposed Sale Price";
                Piecework.MODIFY;
            UNTIL (Piecework.NEXT = 0);

        Window.UPDATE(1, 'Descompuestos');
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
        IF (BillofItemData.FINDSET(TRUE)) THEN
            REPEAT
                Window.UPDATE(2, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No.");
                BillofItemData."Base Unit Cost" := BillofItemData."Direct Unit Cost";
                BillofItemData.VALIDATE("Quantity By");
                BillofItemData.MODIFY;
            UNTIL (BillofItemData.NEXT = 0);

        Window.CLOSE;
    END;

    LOCAL PROCEDURE "--------------------------- Porcentuales"();
    BEGIN
    END;

    PROCEDURE CD_DistributePercentaje(VAR pCostDatabase: Record 7207271; pUse: Option; pProcess: Option);
    VAR
        BillofItemData: Record 7207384;
        PieceworkSetup: Record 7207279;
        Piecework: Record 7207277;
        Window: Dialog;
        Processed: Boolean;
    BEGIN
        //-------------------------------------------------------------------------------------------------
        // JAV 06/12/22: - QB 1.12.24 Repartir el importe de los porcentuales
        //-------------------------------------------------------------------------------------------------
        //IF ((pUse = BillofItemData.Use::Cost)  AND (pProcess = PieceworkSetup."Default Porcentual Cost"::Upload)) OR
        //   ((pUse = BillofItemData.Use::Sales) AND (pProcess = PieceworkSetup."Default Porcentual Sales"::Upload)) THEN
        IF ((pUse = BillofItemData.Use::Cost) AND (pProcess = pCostDatabase."Porcentual Cost"::Upload)) OR
           ((pUse = BillofItemData.Use::Sales) AND (pProcess = pCostDatabase."Porcentual Sales"::Upload)) THEN
            EXIT;

        Window.OPEN('Proceso #1########################\' +
                    '   Paso #2########################\' +
                    'Leyendo #3########################');

        Window.UPDATE(1, 'Repartir Porcentuales');
        Window.UPDATE(2, 'Preparando datos');

        //Cuando no cargamos, eliminar los registros existentes
        IF ((pUse = BillofItemData.Use::Cost) AND (pProcess = PieceworkSetup."Default Porcentual Cost"::DontUpload)) OR
           ((pUse = BillofItemData.Use::Sales) AND (pProcess = PieceworkSetup."Default Porcentual Sales"::DontUpload)) THEN BEGIN
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
            BillofItemData.SETRANGE(Use, pUse);
            BillofItemData.SETRANGE(Type, BillofItemData.Type::Percentage);
            IF (BillofItemData.FINDSET(TRUE)) THEN
                REPEAT
                    Window.UPDATE(3, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No." + ' -> ' + BillofItemData."Presto Code");
                    BillofItemData.DELETE;
                    //Sumo el importe eliminado de los porcentuales de las unidades de obra por encima
                    IF (BillofItemData."Total Cost" <> 0) THEN
                        CD_AddPercentaje(BillofItemData."Cod. Cost database", BillofItemData."Cod. Piecework", BillofItemData.Use, BillofItemData."Total Cost");
                UNTIL (BillofItemData.NEXT = 0);
        END;

        //Cuando distribuimos
        IF ((pUse = BillofItemData.Use::Cost) AND (pProcess = PieceworkSetup."Default Porcentual Cost"::Distribute)) OR
           ((pUse = BillofItemData.Use::Sales) AND (pProcess = PieceworkSetup."Default Porcentual Sales"::Distribute)) THEN BEGIN
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
            BillofItemData.SETRANGE(Use, pUse);
            BillofItemData.SETFILTER("Received from Percentajes", '<> 0');
            IF (BillofItemData.FINDSET(TRUE)) THEN
                REPEAT
                    Window.UPDATE(3, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No." + ' -> ' + BillofItemData."Presto Code");
                    BillofItemData.VALIDATE("Received from Percentajes", 0);
                UNTIL (BillofItemData.NEXT = 0);

            //Repartir los porcentuales entre los de su mismo nivel
            Window.UPDATE(2, 'Reparto Porcentuales');

            Processed := FALSE;
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
            BillofItemData.SETRANGE(Use, pUse);
            BillofItemData.SETRANGE(Type, BillofItemData.Type::Percentage);
            IF (BillofItemData.FINDSET(TRUE)) THEN
                REPEAT
                    Window.UPDATE(3, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No." + ' -> ' + BillofItemData."Presto Code");
                    IF BillofItemData."Cod. Piecework" = '021004' THEN BEGIN
                        BillofItemData."Cod. Piecework" := BillofItemData."Cod. Piecework";
                    END;

                    IF (BillofItemData."Total Cost" <> 0) THEN BEGIN
                        CD_DistributeOne(pCostDatabase, BillofItemData);
                        Processed := TRUE; // Si se ha procesado alguno hay que recalcular al final
                    END;
                UNTIL (BillofItemData.NEXT = 0);

            //Repartir los auxiliares entre sus hijos, solo si se ha procesado alguno
            IF (Processed) THEN BEGIN
                Window.UPDATE(2, 'Reparto Auxiliares');
                BillofItemData.RESET;
                BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
                BillofItemData.SETRANGE(Use, pUse);
                BillofItemData.SETRANGE(Type, BillofItemData.Type::"Posting U.");
                IF (BillofItemData.FINDSET(TRUE)) THEN
                    REPEAT
                        Window.UPDATE(3, BillofItemData."Cod. Piecework" + ' -> ' + BillofItemData."Order No." + ' -> ' + BillofItemData."Presto Code");
                        IF BillofItemData."Cod. Piecework" = '021004' THEN BEGIN
                            BillofItemData."Cod. Piecework" := BillofItemData."Cod. Piecework";
                        END;
                        //No filtro antes para que recorra tambi�n sus hijos
                        IF (BillofItemData."Received from Percentajes" <> 0) THEN
                            CD_DistributeAux(pCostDatabase, BillofItemData);
                    UNTIL (BillofItemData.NEXT = 0);
            END;
        END;

        Window.CLOSE;

        //Recalculamos al final
        IF (Processed) THEN
            CD_CalculateAll(pCostDatabase, TRUE);
    END;

    LOCAL PROCEDURE CD_DistributeOne(VAR pCostDatabase: Record 7207271; VAR BillofItemData: Record 7207384);
    VAR
        BillofItemData2: Record 7207384;
        LastLine: Record 7207384;
        TotalAmount: Decimal;
        Amount: Decimal;
        Price: Decimal;
        Txt: Text;
        Nro: Text;
        PrestoCode: Text;
        Amount2: Decimal;
    BEGIN
        //-------------------------------------------------------------------------------------------------
        // JAV 06/12/22: - QB 1.12.24 Repartir el importe de un porcentual
        //-------------------------------------------------------------------------------------------------

        BillofItemData.VALIDATE("Received from Percentajes", 0);   //Tomar el c�lculo inicial correcto, hemos puesto a cero por el paso anterior
        IF BillofItemData."Cod. Piecework" = '021004' THEN BEGIN
            BillofItemData."Cod. Piecework" := BillofItemData."Cod. Piecework";
        END;

        IF (BillofItemData."Total Cost" <> 0) THEN BEGIN
            //Calculo el total de las l�neas sin incluir las porcentuales, hay que proporcionar sobre esas
            TotalAmount := 0;
            BillofItemData2.RESET;
            BillofItemData2.SETRANGE("Cod. Cost database", BillofItemData."Cod. Cost database");
            BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
            BillofItemData2.SETRANGE(Use, BillofItemData.Use);
            BillofItemData2.SETFILTER(Type, '<>%1', BillofItemData2.Type::Percentage);  //El total es de las otras l�neas, no de las porcentuales
            BillofItemData2.SETRANGE("Father Code", BillofItemData."Father Code");      //Tienen que estar al mismo nivel, por tanto todos tienen el mismo padre
            IF (BillofItemData2.FINDSET(FALSE)) THEN
                REPEAT
                    TotalAmount += BillofItemData2."Total Cost";
                UNTIL (BillofItemData2.NEXT = 0);
            //-Q18970 AML 05/06/23
            Amount2 := 0;  //Esta variable es por si hay m�s de un porcentual por nivel y descompuesto.
                           //+Q18970 AML 05/06/23
                           //Si la suma de las l�neas no es cero lo repartimos
            IF (TotalAmount <> 0) THEN BEGIN
                CLEAR(LastLine);

                BillofItemData2.RESET;
                BillofItemData2.SETRANGE("Cod. Cost database", BillofItemData."Cod. Cost database");
                BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                BillofItemData2.SETRANGE(Use, BillofItemData.Use);
                BillofItemData2.SETFILTER(Type, '<>%1', BillofItemData2.Type::Percentage);  //No repartimos entre las porcentuales
                BillofItemData2.SETRANGE("Father Code", BillofItemData."Father Code");  //Tienen que estar al mismo nivel, por tanto todos tienen el mismo padre
                IF (BillofItemData2.FINDSET(FALSE)) THEN
                    REPEAT
                        IF (BillofItemData2."Quantity By" * BillofItemData2."Bill of Item Units" <> 0) THEN BEGIN
                            //El importe que vamos a repartir
                            //BillofItemData2.VALIDATE("Received from Percentajes", ROUND(BillofItemData2."Piecework Cost" * BillofItemData."Total Cost" / TotalAmount, pCostDatabase.GetPrecision(5)));
                            //-Q18970
                            Amount2 += BillofItemData2."Received from Percentajes";
                            //+Q18970
                            BillofItemData2.VALIDATE("Received from Percentajes", BillofItemData2."Received from Percentajes" +
                                  ROUND((BillofItemData2."Piecework Cost" + BillofItemData2."Received from Percentajes") * BillofItemData."Total Cost" / TotalAmount, pCostDatabase.GetPrecision(5)));
                            BillofItemData."Received from Percentajes" -= BillofItemData2."Received from Percentajes";
                            BillofItemData2.MODIFY;
                            LastLine := BillofItemData2;
                        END;
                    UNTIL (BillofItemData2.NEXT = 0);

                //Ajustamos en la �ltima l�nea
                //-Q18970 A�adido el Amount2
                Amount := BillofItemData."Total Cost" + BillofItemData."Received from Percentajes" + Amount2;
                //+Q18970
                IF (Amount <> 0) THEN BEGIN
                    //El importe que vamos a repartir
                    LastLine.VALIDATE("Received from Percentajes", LastLine."Received from Percentajes" + Amount);
                    BillofItemData."Received from Percentajes" -= Amount;
                    LastLine.MODIFY;
                END;
            END;
        END;

        BillofItemData.VALIDATE("Received from Percentajes");
        BillofItemData.MODIFY;
    END;

    LOCAL PROCEDURE CD_DistributeAux(VAR pCostDatabase: Record 7207271; VAR BillofItemData: Record 7207384);
    VAR
        BillofItemData2: Record 7207384;
        LastLine: Record 7207384;
        TotalAmount: Decimal;
        Amount: Decimal;
        Price: Decimal;
        Txt: Text;
        Nro: Text;
        PrestoCode: Text;
    BEGIN
        //-------------------------------------------------------------------------------------------------
        // JAV 06/12/22: - QB 1.12.24 Repartir el importe recibido de porcentuales entre los hijos
        //-------------------------------------------------------------------------------------------------

        IF (BillofItemData."Total Cost" <> 0) THEN BEGIN
            //Importe total de las hijas, las porcentuales ya est�n a cero
            TotalAmount := BillofItemData."Total Cost" - BillofItemData."Received from Percentajes";
            Amount := BillofItemData."Total Cost";
            //Si la suma de las l�neas no es cero lo repartimos
            IF (TotalAmount <> 0) THEN BEGIN
                CLEAR(LastLine);

                BillofItemData2.RESET;
                BillofItemData2.SETRANGE("Cod. Cost database", BillofItemData."Cod. Cost database");
                BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                BillofItemData2.SETRANGE(Use, BillofItemData.Use);
                BillofItemData2.SETFILTER(Type, '<>%1', BillofItemData2.Type::Percentage);  //No repartimos entre las porcentuales, aunque ya est�n a cero, pero as� acelero un poco
                BillofItemData2.SETRANGE("Father Code", BillofItemData."Order No.");        //Busco los hijos directos
                IF (BillofItemData2.FINDSET(FALSE)) THEN
                    REPEAT
                        IF (BillofItemData2."Quantity By" * BillofItemData2."Bill of Item Units" <> 0) THEN BEGIN
                            //El importe que vamos a repartir
                            BillofItemData2.VALIDATE("Received from Percentajes", ROUND(BillofItemData2."Total Cost" * BillofItemData."Received from Percentajes" / TotalAmount, pCostDatabase.GetPrecision(5)));
                            Amount -= BillofItemData2."Total Cost";
                            BillofItemData2.MODIFY;
                            LastLine := BillofItemData2;
                        END;
                    UNTIL (BillofItemData2.NEXT = 0);

                //Ajustamos en la �ltima l�nea
                IF (Amount <> 0) THEN BEGIN
                    LastLine.VALIDATE("Received from Percentajes", LastLine."Received from Percentajes" + Amount);
                    LastLine.MODIFY;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE CD_AddPercentaje(pCD: Code[20]; pCode: Code[20]; pUse: Option; pAmount: Decimal);
    VAR
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
    BEGIN
        Piecework.GET(pCD, pCode);
        CASE pUse OF
            BillofItemData.Use::Cost:
                Piecework."Received % Amount Cost" += pAmount;
            BillofItemData.Use::Sales:
                Piecework."Received % Amount Sales" += pAmount;
        END;
        Piecework.MODIFY;

        //Lo subo al padre
        IF (Piecework."Father Code" <> '') THEN
            CD_AddPercentaje(pCD, Piecework."Father Code", pUse, pAmount);
    END;

    LOCAL PROCEDURE "--------------------------- Partidas sin descompuestos"();
    BEGIN
    END;

    PROCEDURE CD_Partidas(VAR pCostDatabase: Record 7207271; pUse: Option; pType: Option);
    VAR
        PieceworkSetup: Record 7207279;
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
        BillofItemData2: Record 7207384;
        Window: Dialog;
        newType: Option;
    BEGIN
        //JAV 12/12/22: - QB 1.12.24 A�adir descompuestos a las partidas que no los tengan
        Window.OPEN('   Paso #1########################\' +
                    'Proceso #2########################\' +
                    'Leyendo #3########################');

        Window.UPDATE(1, 'Revisando Partidas');
        Window.UPDATE(2, 'A�adiendo descompuestos');

        CASE pUse OF
            BillofItemData.Use::Cost:
                CASE pType OF
                    PieceworkSetup."Default Cost Without Decom."::Item:
                        newType := BillofItemData.Type::Item;
                    PieceworkSetup."Default Cost Without Decom."::Resource:
                        newType := BillofItemData.Type::Resource;
                END;
            BillofItemData.Use::Sales:
                CASE pType OF
                    PieceworkSetup."Default Sales Without Decom."::Item:
                        newType := BillofItemData.Type::Item;
                    PieceworkSetup."Default Sales Without Decom."::Resource:
                        newType := BillofItemData.Type::Resource;
                END;
        END;
        PieceworkSetup.GET;
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
        IF Piecework.FINDSET(FALSE) THEN
            REPEAT
                Window.UPDATE(2, Piecework."No.");
                IF Piecework."No." = '01010101' THEN BEGIN
                    Piecework."No." := Piecework."No.";
                END;
                BillofItemData.RESET;
                BillofItemData.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
                BillofItemData.SETRANGE("Cod. Piecework", Piecework."No.");
                BillofItemData.SETRANGE(Use, pUse);
                IF (BillofItemData.ISEMPTY) THEN BEGIN
                    BillofItemData."Cod. Cost database" := Piecework."Cost Database Default";
                    BillofItemData."Cod. Piecework" := Piecework."No.";
                    BillofItemData."Order No." := '01';
                    BillofItemData.Use := pUse;
                    BillofItemData.Type := newType;
                    BillofItemData."Quantity By" := 1;
                    BillofItemData."Bill of Item Units" := 1;
                    CASE pUse OF
                        BillofItemData.Use::Cost:
                            BEGIN
                                BillofItemData.Type := BillofItemData.Type::Resource;
                                BillofItemData.VALIDATE("No.", PieceworkSetup."Resource No Bill Item");
                                BillofItemData.VALIDATE("Quantity By", 1);
                                BillofItemData.VALIDATE("Bill of Item Units", 1);
                                //BillofItemData."No." := Piecework."PRESTO Code Sales";
                                BillofItemData."Presto Code" := Piecework."PRESTO Code Cost";
                                BillofItemData."Received Price" := Piecework."Received Cost Price";
                                BillofItemData.VALIDATE("Direct Unit Cost", Piecework."Price Cost");
                                //-Q20047
                                //IF (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Indirect) OR (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Booth) THEN BEGIN
                                //BillofItemData.VALIDATE("Unit Cost Indirect",Piecework."Price Cost");
                                //END;
                                //+Q20047

                            END;
                        BillofItemData.Use::Sales:
                            BEGIN
                                BillofItemData2.SETRANGE("Cod. Cost database", BillofItemData."Cod. Cost database");
                                BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                                BillofItemData2.SETRANGE(Use, BillofItemData2.Use::Sales);
                                IF BillofItemData2.FINDFIRST THEN BEGIN
                                    BillofItemData.Type := BillofItemData.Type::Resource;
                                    BillofItemData.VALIDATE("No.", PieceworkSetup."Resource No Bill Item");
                                    //BillofItemData."No." := Piecework."PRESTO Code Sales";
                                    BillofItemData.VALIDATE("Quantity By", 1);
                                    BillofItemData.VALIDATE("Bill of Item Units", 1);
                                    BillofItemData."Presto Code" := Piecework."PRESTO Code Sales";
                                    BillofItemData."Received Price" := Piecework."Received Sales Price";
                                    BillofItemData.VALIDATE("Direct Unit Cost", Piecework."Proposed Sale Price");
                                END;
                            END;
                    END;
                    BillofItemData.VALIDATE("Quantity By", 1);
                    BillofItemData.Diferencia := TRUE;
                    IF (BillofItemData."No." <> '') AND (BillofItemData."Direct Unit Cost" <> 0) THEN BillofItemData.INSERT;
                END;
            UNTIL Piecework.NEXT = 0;

        Window.CLOSE;
    END;

    LOCAL PROCEDURE "--------------------------- Descompuestos por diferencia"();
    BEGIN
    END;

    PROCEDURE CD_PartidasDif(VAR pCostDatabase: Record 7207271; pUse: Option; Descompuestos: Boolean; Capitulos: Boolean; opcAccountGreater: Code[20]);
    VAR
        PieceworkSetup: Record 7207279;
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
        BillofItemData2: Record 7207384;
        Window: Dialog;
        newType: Option;
        Piecework2: Record 7207277;
        Piecework3: Record 7207277;
        Contador: Integer;
        Suma: Decimal;
        Venta: Boolean;
        Nivel: Code[40];
    BEGIN
        //Copia Modificada de CD_Partidas de JAV 12/12/22: - QB 1.12.24 A�adir descompuestos a las partidas que no los tengan
        //-Q18970 AML A�adir descompuesto para compensar la diferencia entre el precio importado de BC3 de la partida y la suma de descompuesto. Ojo que puede ser negativo.
        Window.OPEN('   Paso #1########################\' +
                    'Proceso #2########################\' +
                    'Leyendo #3########################');

        Window.UPDATE(1, 'Revisando Partidas');
        Window.UPDATE(2, 'A�adiendo descompuestos faltantes');

        PieceworkSetup.GET;
        IF NOT Descompuestos THEN EXIT;
        IF Descompuestos THEN BEGIN
            //-Q18285 AML MAndan la UO
            Piecework.RESET;
            Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
            Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
            IF Piecework.FINDSET(FALSE) THEN
                REPEAT
                    Window.UPDATE(2, Piecework."No.");
                    IF Piecework.Factor = 0 THEN Piecework.Factor := 1;
                    IF pUse = 1 THEN BEGIN
                        BillofItemData2.RESET;
                        BillofItemData2.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
                        BillofItemData2.SETRANGE("Cod. Piecework", Piecework."No.");
                        BillofItemData2.SETRANGE(Use, pUse);
                        IF BillofItemData2.FINDFIRST THEN Venta := TRUE ELSE Venta := FALSE;
                    END;
                    IF ((pUse = 0) AND ((Piecework."Received Cost Price" * Piecework.Factor) <> Piecework."Price Cost")) OR
                       ((pUse = 1) AND ((Piecework."Received Sales Price" * Piecework.Factor) <> Piecework."Proposed Sale Price") AND Venta) THEN BEGIN
                        BillofItemData.INIT;
                        BillofItemData2.RESET;
                        BillofItemData2.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
                        BillofItemData2.SETRANGE("Cod. Piecework", Piecework."No.");
                        BillofItemData2.SETRANGE(Use, pUse);
                        IF BillofItemData2.FINDLAST THEN BillofItemData."Order No." := INCSTR(BillofItemData2."Order No.") ELSE BillofItemData."Order No." := opcAccountGreater;

                        BillofItemData."Cod. Cost database" := Piecework."Cost Database Default";
                        BillofItemData."Cod. Piecework" := Piecework."No.";
                        BillofItemData.Use := pUse;
                        BillofItemData.Type := BillofItemData.Type::Resource;
                        BillofItemData."Quantity By" := 1;
                        BillofItemData."Bill of Item Units" := 1;
                        BillofItemData.VALIDATE("No.", PieceworkSetup."Resource Difference");
                        CASE pUse OF
                            BillofItemData.Use::Cost:
                                BEGIN
                                    //BillofItemData."Presto Code" := Piecework."PRESTO Code Cost";
                                    BillofItemData."Received Price" := Piecework."Received Cost Price";
                                    //-Q20047
                                    //BillofItemData.VALIDATE("Unit Cost Indirect", Piecework."Received Cost Price" - Piecework."Price Cost");
                                    //IF  (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Direct) OR (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Booth) THEN BillofItemData.VALIDATE("Direct Unit Cost", Piecework."Received Cost Price" - Piecework."Price Cost");
                                    //IF  (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Indirect) OR (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Booth) THEN
                                    //BillofItemData.VALIDATE("Unit Cost Indirect", Piecework."Received Cost Price" - Piecework."Price Cost");
                                    //+Q20047
                                END;
                            BillofItemData.Use::Sales:
                                BEGIN
                                    //BillofItemData."Presto Code" := Piecework."PRESTO Code Sales";
                                    //BillofItemData."Received Price" := Piecework."Received Sales Price";
                                    BillofItemData.VALIDATE("Direct Unit Cost", Piecework."Received Sales Price" - Piecework."Proposed Sale Price");
                                END;
                        END;
                        BillofItemData.VALIDATE("Bill of Item Units", 1);
                        BillofItemData.VALIDATE("Quantity By", 1);

                        IF (BillofItemData."Direct Unit Cost" <> 0) THEN BEGIN
                            Piecework.Diferencia := TRUE;
                            BillofItemData.INSERT(TRUE);
                            BillofItemData.Diferencia := TRUE;
                            BillofItemData.VALIDATE("Quantity By", 1);
                            BillofItemData.MODIFY;
                            CalculateLinePrev(Piecework);
                        END;
                    END;
                UNTIL Piecework.NEXT = 0;
        END
        ELSE BEGIN
            //+Q18285 AML MAndan las MEDiociones revisar!!!!!!
            Piecework.RESET;
            Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
            Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
            IF Piecework.FINDSET(FALSE) THEN
                REPEAT
                    Window.UPDATE(2, Piecework."No.");
                    IF Piecework.Factor = 0 THEN Piecework.Factor := 1;
                    IF ((pUse = 0) AND ((Piecework."Received Cost Price" * Piecework.Factor) <> Piecework."Price Cost")) OR
                       ((pUse = 1) AND ((Piecework."Received Sales Price" * Piecework.Factor) <> Piecework."Proposed Sale Price")) THEN BEGIN
                        BillofItemData.INIT;
                        BillofItemData2.RESET;
                        BillofItemData2.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
                        BillofItemData2.SETRANGE("Cod. Piecework", Piecework."No.");
                        BillofItemData2.SETRANGE(Use, pUse);
                        IF BillofItemData2.FINDLAST THEN
                            CalculateLinePrev(Piecework);
                    END;

                UNTIL Piecework.NEXT = 0;


        END;
        //02210503

        FOR Contador := 0 TO 10 DO BEGIN
            Piecework.RESET;
            Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
            Piecework.SETRANGE("Account Type", Piecework."Account Type"::Heading);
            Piecework.SETRANGE(Identation, 10 - Contador);
            IF Piecework.FINDSET(FALSE) THEN
                REPEAT
                    Window.UPDATE(2, Piecework."No.");
                    IF Capitulos THEN BEGIN
                        IF Piecework.Factor = 0 THEN Piecework.Factor := 1;
                        IF (((pUse = 0) OR (pUse = 3)) AND ((Piecework."Received Cost Price" * Piecework.Factor) <> Piecework."Price Cost") AND (Piecework."Received Cost Price" <> 0)) OR
                           (((pUse = 1) OR (pUse = 3)) AND ((Piecework."Received Sales Price" * Piecework.Factor) <> Piecework."Proposed Sale Price") AND (Piecework."Received Sales Price" <> 0)) THEN BEGIN
                            Piecework3.INIT;
                            Piecework3 := Piecework;
                            Piecework2.RESET;
                            Piecework2.SETRANGE("Cost Database Default", Piecework."Cost Database Default");
                            Nivel := Piecework."No." + opcAccountGreater;
                            IF STRLEN(Nivel) > 20 THEN ERROR('Demasiados niveles');
                            Nivel := Piecework."No." + '9999999999999';
                            Nivel := COPYSTR(Nivel, 1, 20);
                            Piecework2.SETRANGE("No.", Piecework."No." + opcAccountGreater, Nivel);
                            Piecework2.SETRANGE(Identation, Piecework.Identation + 1);
                            IF Piecework2.FINDLAST THEN Piecework3."No." := INCSTR(Piecework2."No.") ELSE Piecework3."No." := Piecework3."No." + opcAccountGreater;
                            Piecework3.VALIDATE(Description, 'CREADA POR DIFERENCIA');
                            Piecework3.Identation := Piecework2.Identation;
                            Piecework3."Account Type" := Piecework3."Account Type"::Unit;
                            Piecework3.INSERT(TRUE);
                            Piecework3."PRESTO Code Cost" := '';
                            Piecework3."PRESTO Code Sales" := '';
                            Piecework3."Production Unit" := FALSE;
                            Piecework3."Certification Unit" := FALSE;
                            Piecework3."Measurement Cost" := 0;
                            Piecework3.Factor := 1;
                            Piecework3.Diferencia := TRUE;
                            IF (pUse = 0) OR (pUse = 3) THEN Piecework3."Measurement Cost" := 1;
                            IF (pUse = 0) OR (pUse = 3) THEN Piecework3."Production Unit" := TRUE ELSE Piecework3."Production Unit" := FALSE;
                            ;
                            IF (pUse = 0) OR (pUse = 3) THEN Piecework3.VALIDATE("Price Cost", Piecework."Received Cost Price" - Piecework."Price Cost");
                            IF (pUse = 0) OR (pUse = 3) THEN Piecework3.VALIDATE("Base Price Cost", Piecework3."Price Cost");
                            IF pUse = 0 THEN Piecework3."Measurement Sale" := 0;
                            IF pUse = 0 THEN Piecework3.VALIDATE("Proposed Sale Price", 0);
                            IF pUse = 0 THEN Piecework3.VALIDATE("Base Price Sales", 0);

                            Piecework."Measurement Sale" := 0;
                            IF (pUse = 1) OR (pUse = 3) THEN Piecework3."Measurement Sale" := 1;
                            IF (pUse = 1) OR (pUse = 3) THEN Piecework3.VALIDATE("Proposed Sale Price", Piecework."Received Sales Price" - Piecework."Proposed Sale Price");
                            IF (pUse = 1) OR (pUse = 3) THEN Piecework3.VALIDATE("Base Price Sales", Piecework3."Proposed Sale Price");
                            IF (pUse = 1) OR (pUse = 3) THEN Piecework3."Certification Unit" := TRUE ELSE Piecework3."Certification Unit" := FALSE;
                            ;
                            IF pUse = 1 THEN Piecework3."Measurement Cost" := 0;
                            IF pUse = 1 THEN Piecework3.VALIDATE("Price Cost", 0);
                            IF pUse = 1 THEN Piecework3.VALIDATE("Base Price Cost", 0);

                            Piecework3."Received Cost Price" := 0;
                            Piecework3."Received Sales Price" := 0;
                            Piecework3."Received Cost Medition" := 0;
                            Piecework3."Received Sales Medition" := 0;
                            Piecework3."Father Code" := Piecework."No.";
                            IF (pUse = 0) OR (pUse = 3) THEN Piecework3."Production Unit" := TRUE ELSE Piecework3."Production Unit" := FALSE;
                            ;
                            IF (pUse = 1) OR (pUse = 3) THEN Piecework3."Certification Unit" := TRUE ELSE Piecework3."Certification Unit" := FALSE;
                            ;
                            Piecework3.MODIFY(TRUE);

                            IF ((pUse = 0) OR (pUse = 3)) AND (Descompuestos) THEN BEGIN
                                BillofItemData."Cod. Cost database" := Piecework3."Cost Database Default";
                                BillofItemData."Cod. Piecework" := Piecework3."No.";
                                BillofItemData."Order No." := opcAccountGreater;
                                BillofItemData.Use := 0;
                                BillofItemData.Type := BillofItemData.Type::Resource;
                                BillofItemData."Quantity By" := 1;
                                BillofItemData."Bill of Item Units" := 1;
                                BillofItemData.VALIDATE("No.", PieceworkSetup."Resource Difference");
                                BillofItemData.VALIDATE("Direct Unit Cost", Piecework3."Price Cost");
                                //-Q20047
                                //IF (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Indirect) OR (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Booth) THEN BEGIN
                                //BillofItemData.VALIDATE("Unit Cost Indirect",Piecework."Price Cost");
                                //END;
                                //+Q20047

                                BillofItemData.VALIDATE("Bill of Item Units", 1);
                                BillofItemData.VALIDATE("Quantity By", 1);
                                BillofItemData.INSERT;
                                BillofItemData.Diferencia := TRUE;
                                BillofItemData.VALIDATE("Quantity By", 1);
                                BillofItemData.MODIFY;
                                CalculateLinePrev(Piecework3);
                            END;
                            IF ((pUse = 1) OR (pUse = 3)) AND Descompuestos THEN BEGIN
                                BillofItemData."Cod. Cost database" := Piecework3."Cost Database Default";
                                BillofItemData."Cod. Piecework" := Piecework3."No.";
                                BillofItemData."Order No." := opcAccountGreater;
                                BillofItemData.Use := 1;
                                BillofItemData.Type := BillofItemData.Type::Resource;
                                BillofItemData."Quantity By" := 1;
                                BillofItemData."Bill of Item Units" := 1;
                                BillofItemData.VALIDATE("No.", PieceworkSetup."Resource Difference");
                                BillofItemData.VALIDATE("Direct Unit Cost", Piecework3."Proposed Sale Price");
                                //-Q20047
                                //IF (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Indirect) OR (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Booth) THEN BEGIN
                                //   BillofItemData.VALIDATE("Unit Cost Indirect",Piecework."Price Cost");
                                //END;
                                //+Q20047
                                BillofItemData.VALIDATE("Quantity By", 1);
                                BillofItemData.VALIDATE("Bill of Item Units", 1);
                                BillofItemData.INSERT;
                                BillofItemData.Diferencia := TRUE;
                                BillofItemData.VALIDATE("Quantity By", 1);
                                BillofItemData.MODIFY;
                                CalculateLinePrev(Piecework3);
                            END;

                        END;
                    END
                    ELSE BEGIN
                        Suma := 0;
                        Piecework2.RESET;
                        Piecework2.SETRANGE("Cost Database Default", Piecework."Cost Database Default");
                        Piecework2.SETRANGE("No.", Piecework."No." + opcAccountGreater, Piecework."No." + '99');
                        Piecework2.SETRANGE(Identation, Piecework.Identation + 1);
                        IF Piecework2.FINDSET THEN
                            REPEAT
                                IF pUse = 1 THEN Suma += Piecework2."Total Amount Cost";
                                IF pUse = 2 THEN Suma += Piecework2."Total Amount Sales";

                            UNTIL Piecework2.NEXT = 0;
                        IF pUse = 1 THEN BEGIN
                            IF Suma <> Piecework."Total Amount Cost" THEN BEGIN
                                Piecework."Total Amount Cost" := Suma;
                                Piecework.MODIFY;
                            END;
                        END;
                        IF pUse = 2 THEN BEGIN
                            IF Suma <> Piecework."Total Amount Sales" THEN BEGIN
                                Piecework."Total Amount Sales" := Suma;
                                Piecework.MODIFY;
                            END;
                        END;
                    END;
                UNTIL Piecework.NEXT = 0;
        END;
        Window.CLOSE;
    END;

    LOCAL PROCEDURE CalculateLinePrev(VAR Piecework: Record 7207277);
    VAR
        Piecework2: Record 7207277;
    BEGIN
        IF Piecework."Account Type" = Piecework."Account Type"::Unit THEN Piecework.CalculateLine() ELSE Piecework.CalculateHeading();
        IF Piecework."Father Code" <> '' THEN BEGIN
            IF Piecework2.GET(Piecework."Cost Database Default", Piecework."Father Code") THEN BEGIN
                Piecework2.Diferencia := Piecework.Diferencia;
                CalculateLinePrev(Piecework2);
            END;
        END;
    END;

    PROCEDURE CD_FactorPartidas(VAR pCostDatabase: Record 7207271);
    VAR
        Piecework: Record 7207277;
        BillofItemData: Record 7207384;
        Window: Dialog;
        BillofItemData2: Record 7207384;
    BEGIN

        //-Q18970 AML Repartir el factor de las unidades auxiliares
        Window.OPEN('Paso #1########################\' +
                    '   #2########################\' +
                    '   Unidad Auxiliar #3########################');
        Window.UPDATE(1, 'Revisando Unidades Auxiliares');
        Window.UPDATE(2, 'Factores distintos de 1');

        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", pCostDatabase.Code);
        BillofItemData.SETRANGE(Type, BillofItemData.Type::"Posting U.");
        IF BillofItemData.FINDSET THEN
            REPEAT
                IF (BillofItemData."Quantity By" <> 1) OR (BillofItemData."Bill of Item Units" <> 1) THEN BEGIN
                    Window.UPDATE(3, BillofItemData."No.");
                    BillofItemData2.RESET;
                    BillofItemData2.SETRANGE("Cod. Cost database", pCostDatabase.Code);
                    BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                    BillofItemData2.SETRANGE("Father Code", BillofItemData."Order No.");
                    BillofItemData2.SETRANGE(Use, BillofItemData.Use);
                    IF BillofItemData2.FINDSET THEN
                        REPEAT
                            IF BillofItemData."Quantity By" <> 1 THEN BEGIN
                                BillofItemData2."Rendimiento Original" := BillofItemData2."Quantity By";
                                BillofItemData2."Quantity By" := BillofItemData2."Quantity By" * BillofItemData."Quantity By";
                            END;
                            IF BillofItemData."Bill of Item Units" <> 1 THEN BEGIN
                                BillofItemData2.Factor := BillofItemData2."Bill of Item Units";
                                BillofItemData2."Bill of Item Units" := BillofItemData2."Bill of Item Units" * BillofItemData."Bill of Item Units";
                            END;
                            BillofItemData2.MODIFY;
                        UNTIL BillofItemData2.NEXT = 0;
                    IF BillofItemData."Quantity By" <> 1 THEN BillofItemData."Rendimiento Original" := BillofItemData."Quantity By";
                    BillofItemData."Quantity By" := 1;
                    IF BillofItemData."Bill of Item Units" <> 1 THEN BillofItemData.Factor := BillofItemData."Bill of Item Units";
                    BillofItemData."Bill of Item Units" := 1;
                    BillofItemData."Total Price" := BillofItemData."Total Cost";
                    BillofItemData."Direct Unit Cost" := BillofItemData."Total Cost";
                    //-Q20047
                    //IF (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Indirect) OR (pCostDatabase."Type JU" = pCostDatabase."Type JU"::Booth) THEN BEGIN
                    //    BillofItemData.VALIDATE("Unit Cost Indirect",BillofItemData."Total Cost");
                    //END;
                    //+Q20047
                    BillofItemData."Base Unit Cost" := BillofItemData."Total Cost" + BillofItemData."Received from Percentajes";
                    BillofItemData."Total Qty" := 1;
                    BillofItemData.MODIFY;

                    BillofItemData2.RESET;
                    BillofItemData2.SETRANGE("Cod. Cost database", pCostDatabase.Code);
                    BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
                    BillofItemData2.SETRANGE("Father Code", BillofItemData."Order No.");
                    BillofItemData2.SETRANGE(Use, BillofItemData.Use);
                    IF BillofItemData2.FINDSET THEN
                        REPEAT
                            BillofItemData2.VALIDATE("Bill of Item Units", BillofItemData2."Bill of Item Units" * BillofItemData."Bill of Item Units");
                            BillofItemData2.VALIDATE("Quantity By", BillofItemData2."Quantity By" * BillofItemData."Quantity By");
                            BillofItemData2.MODIFY;
                        UNTIL BillofItemData2.NEXT = 0;
                END;
            UNTIL BillofItemData.NEXT = 0;

        //AML Q18285 24/03/23 Si hay UO con Factor distinto de 1 hay que trasladarlo a los descompuestos.
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCostDatabase.Code);
        Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
        Piecework.SETFILTER(Factor, '<> %1', 1);
        IF Piecework.FINDSET(FALSE) THEN BEGIN
            Window.OPEN('   Paso #1########################\' +
                      'Proceso #2########################\' +
                      'Leyendo #3########################');

            Window.UPDATE(1, 'Revisando Partidas');
            Window.UPDATE(2, 'Factores distintos de 1');
            REPEAT
                Window.UPDATE(2, Piecework."No.");
                BillofItemData.RESET;
                BillofItemData.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
                BillofItemData.SETRANGE("Cod. Piecework", Piecework."No.");
                BillofItemData.SETFILTER(Type, '%1|%2', BillofItemData.Type::Item, BillofItemData.Type::Resource);//Siempre al �ltimo nivel
                IF BillofItemData.FINDSET THEN
                    REPEAT
                        IF BillofItemData.Factor = 0 THEN BillofItemData.Factor := BillofItemData."Bill of Item Units";
                        BillofItemData.VALIDATE("Bill of Item Units", BillofItemData."Bill of Item Units" * Piecework.Factor);
                        BillofItemData."Factor UO" := Piecework.Factor;
                        BillofItemData.MODIFY;
                    UNTIL BillofItemData.NEXT = 0;
                CalculateLinePrev(Piecework);
            UNTIL Piecework.NEXT = 0;
            Window.CLOSE;
        END;
    END;

    PROCEDURE CD_Medicion(VAR pCostDatabase: Code[20]; UOCoste: Option "UO","Medicion","Nada"; UOVenta: Option "UO","Medicion","Nada"; Coste: Boolean; IgualCoste: Boolean; opcInsertMeditionCost: Boolean; opcInsertMeditionSales: Boolean);
    VAR
        MeasureLinePieceworkPRESTO: Record 7207285;
        Suma: Decimal;
        Piecework: Record 7207277;
        Window: Dialog;
        Linea: Integer;
        MeasureLinePieceworkPRESTO2: Record 7207285;
        MeasureLinePieceworkPRESTO3: Record 7207285;
    BEGIN
        //-Q18285 AML 29/03/23 Recalcular el total de las lineas de medicion y comprobar la coherencia.

        Suma := 0;
        Window.OPEN('   Paso #1########################');

        Window.UPDATE(1, 'Revisando Mediciones');
        MeasureLinePieceworkPRESTO.RESET;
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
        IF MeasureLinePieceworkPRESTO.FINDSET THEN
            REPEAT
                MeasureLinePieceworkPRESTO.VALIDATE(Units);
                Suma += MeasureLinePieceworkPRESTO.Total;
                MeasureLinePieceworkPRESTO.MODIFY;
            UNTIL MeasureLinePieceworkPRESTO.NEXT = 0;

        Piecework.SETRANGE("Cost Database Default", pCostDatabase);
        Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
        IF Piecework.FINDSET THEN
            REPEAT
                IF (UOCoste <> UOCoste::Nada) AND (opcInsertMeditionCost) THEN BEGIN
                    Suma := 0;
                    MeasureLinePieceworkPRESTO.RESET;
                    MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
                    MeasureLinePieceworkPRESTO.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Cost);
                    MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                    IF MeasureLinePieceworkPRESTO.FINDSET THEN
                        REPEAT
                            Suma += MeasureLinePieceworkPRESTO.Total;
                        UNTIL MeasureLinePieceworkPRESTO.NEXT = 0;
                    IF (Suma <> Piecework."Measurement Cost") THEN BEGIN
                        IF UOCoste = UOCoste::Medicion THEN BEGIN
                            Piecework.VALIDATE("Measurement Cost", Suma);
                            Piecework.MODIFY;
                        END;
                        IF UOCoste = UOCoste::UO THEN BEGIN
                            MeasureLinePieceworkPRESTO3.RESET;
                            MeasureLinePieceworkPRESTO3.SETRANGE("Cost Database Code", pCostDatabase);
                            MeasureLinePieceworkPRESTO3.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Cost);
                            MeasureLinePieceworkPRESTO3.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                            IF MeasureLinePieceworkPRESTO3.FINDLAST THEN Linea := MeasureLinePieceworkPRESTO3."Line No." + 10000 ELSE Linea := 10000;
                            MeasureLinePieceworkPRESTO2.INIT;
                            MeasureLinePieceworkPRESTO2."Cost Database Code" := pCostDatabase;
                            MeasureLinePieceworkPRESTO2."Cod. Jobs Unit" := Piecework."No.";
                            MeasureLinePieceworkPRESTO2.Use := MeasureLinePieceworkPRESTO.Use::Cost;
                            MeasureLinePieceworkPRESTO2."Line No." := Linea;
                            MeasureLinePieceworkPRESTO2.Description := 'Ajuste de medicion';
                            MeasureLinePieceworkPRESTO2.VALIDATE(Units, 1);
                            MeasureLinePieceworkPRESTO2.Length := 0;
                            MeasureLinePieceworkPRESTO2.Width := 0;
                            MeasureLinePieceworkPRESTO2.Height := 0;
                            MeasureLinePieceworkPRESTO2.VALIDATE(Length, Piecework."Measurement Cost" - Suma);
                            MeasureLinePieceworkPRESTO2.INSERT;
                        END;
                    END;

                END;
                IF (UOVenta <> UOVenta::Nada) AND (opcInsertMeditionSales) THEN BEGIN
                    Suma := 0;
                    MeasureLinePieceworkPRESTO.RESET;
                    MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
                    MeasureLinePieceworkPRESTO.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Sales);
                    MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                    IF MeasureLinePieceworkPRESTO.FINDSET THEN
                        REPEAT
                            Suma += MeasureLinePieceworkPRESTO.Total;
                        UNTIL MeasureLinePieceworkPRESTO.NEXT = 0;
                    IF (Suma <> Piecework."Measurement Sale") THEN BEGIN
                        IF UOVenta = UOVenta::Medicion THEN BEGIN
                            Piecework.VALIDATE("Measurement Sale", Suma);
                            IF (Piecework."Measurement Cost" = 0) AND Coste AND IgualCoste THEN Piecework.VALIDATE("Measurement Cost", Piecework."Measurement Sale");
                            Piecework.MODIFY;
                        END;
                        IF UOVenta = UOVenta::UO THEN BEGIN
                            MeasureLinePieceworkPRESTO3.RESET;
                            MeasureLinePieceworkPRESTO3.SETRANGE("Cost Database Code", pCostDatabase);
                            MeasureLinePieceworkPRESTO3.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Sales);
                            MeasureLinePieceworkPRESTO3.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                            IF MeasureLinePieceworkPRESTO3.FINDLAST THEN Linea := MeasureLinePieceworkPRESTO3."Line No." + 10000 ELSE Linea := 10000;
                            IF Linea <> 10000 THEN BEGIN
                                MeasureLinePieceworkPRESTO2.INIT;
                                MeasureLinePieceworkPRESTO2."Cost Database Code" := pCostDatabase;
                                MeasureLinePieceworkPRESTO2.Use := MeasureLinePieceworkPRESTO.Use::Sales;
                                MeasureLinePieceworkPRESTO2."Cod. Jobs Unit" := Piecework."No.";
                                MeasureLinePieceworkPRESTO2."Line No." := Linea;
                                MeasureLinePieceworkPRESTO2.Description := 'Ajuste de medicion';
                                MeasureLinePieceworkPRESTO2.VALIDATE(Units, 1);
                                MeasureLinePieceworkPRESTO2.Length := 0;
                                MeasureLinePieceworkPRESTO2.Width := 0;
                                MeasureLinePieceworkPRESTO2.Height := 0;
                                MeasureLinePieceworkPRESTO2.VALIDATE(Length, Piecework."Measurement Sale" - Suma);
                                MeasureLinePieceworkPRESTO2.INSERT;
                            END;
                        END;
                    END;

                END;
            UNTIL Piecework.NEXT = 0;
    END;

    PROCEDURE CD_IgualarMed(VAR pCostDatabase: Code[20]; UOCoste: Option "UO","Medicion","Nada"; opcInsertMeditionCost: Boolean);
    VAR
        Piecework: Record 7207277;
        MeasureLinePieceworkPRESTO: Record 7207285;
        MeasureLinePieceworkPRESTO2: Record 7207285;
        MeasureLinePieceworkPRESTO3: Record 7207285;
        Linea: Integer;
        Suma: Decimal;
        L: Decimal;
        A: Decimal;
        H: Decimal;
    BEGIN
        Piecework.SETRANGE("Cost Database Default", pCostDatabase);
        Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
        IF Piecework.FINDSET THEN
            REPEAT
                IF (Piecework."Measurement Cost" = 0) AND (Piecework."Measurement Sale" <> 0) THEN BEGIN
                    Linea := 0;
                    MeasureLinePieceworkPRESTO3.RESET;
                    MeasureLinePieceworkPRESTO3.SETRANGE("Cost Database Code", pCostDatabase);
                    MeasureLinePieceworkPRESTO3.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Cost);
                    MeasureLinePieceworkPRESTO3.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                    IF MeasureLinePieceworkPRESTO3.FINDLAST THEN Linea := MeasureLinePieceworkPRESTO3."Line No." + 10000;
                    IF (UOCoste = UOCoste::Nada) THEN Piecework."Measurement Cost" := Piecework."Measurement Sale";
                    IF (UOCoste = UOCoste::Medicion) AND (Linea = 0) THEN Piecework."Measurement Cost" := Piecework."Measurement Sale";
                    IF (UOCoste = UOCoste::UO) THEN Piecework."Measurement Cost" := Piecework."Measurement Sale";
                    Piecework.MODIFY;
                    IF opcInsertMeditionCost THEN BEGIN
                        IF UOCoste <> UOCoste::Nada THEN BEGIN
                            MeasureLinePieceworkPRESTO.RESET;
                            MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
                            MeasureLinePieceworkPRESTO.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Cost);
                            MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                            IF MeasureLinePieceworkPRESTO.FINDLAST THEN BEGIN
                                REPEAT
                                    IF MeasureLinePieceworkPRESTO.Units <> 0 THEN BEGIN
                                        L := 0;
                                        A := 0;
                                        H := 0;
                                        L := MeasureLinePieceworkPRESTO.Length;
                                        A := MeasureLinePieceworkPRESTO.Width;
                                        H := MeasureLinePieceworkPRESTO.Height;
                                        IF (L = 0) THEN L := 1;
                                        IF (A = 0) THEN A := 1;
                                        IF (H = 0) THEN H := 1;
                                        Suma += MeasureLinePieceworkPRESTO.Units * L * A * H;
                                    END;
                                UNTIL MeasureLinePieceworkPRESTO.NEXT = 0;
                            END;
                            IF (Suma = 0) AND (UOCoste = UOCoste::UO) THEN Piecework."Measurement Cost" := Piecework."Measurement Sale";
                            IF Suma <> Piecework."Measurement Cost" THEN BEGIN
                                MeasureLinePieceworkPRESTO3.RESET;
                                MeasureLinePieceworkPRESTO3.SETRANGE("Cost Database Code", pCostDatabase);
                                MeasureLinePieceworkPRESTO3.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Cost);
                                MeasureLinePieceworkPRESTO3.SETRANGE("Cod. Jobs Unit", Piecework."No.");
                                IF MeasureLinePieceworkPRESTO3.FINDLAST THEN Linea := MeasureLinePieceworkPRESTO3."Line No." + 10000 ELSE Linea := 10000;
                                MeasureLinePieceworkPRESTO2.INIT;
                                MeasureLinePieceworkPRESTO2."Cost Database Code" := pCostDatabase;
                                MeasureLinePieceworkPRESTO2."Cod. Jobs Unit" := MeasureLinePieceworkPRESTO."Cod. Jobs Unit";
                                MeasureLinePieceworkPRESTO2.Use := MeasureLinePieceworkPRESTO.Use::Cost;
                                MeasureLinePieceworkPRESTO2."Line No." := Linea;
                                MeasureLinePieceworkPRESTO2.Description := 'Ajuste de medicion';
                                MeasureLinePieceworkPRESTO2.VALIDATE(Units, 1);
                                MeasureLinePieceworkPRESTO2.Length := 0;
                                MeasureLinePieceworkPRESTO2.Width := 0;
                                MeasureLinePieceworkPRESTO2.Height := 0;
                                IF UOCoste = UOCoste::Medicion THEN MeasureLinePieceworkPRESTO2.VALIDATE(Length, Piecework."Measurement Cost" - Suma);
                                MeasureLinePieceworkPRESTO2.INSERT;
                            END;
                        END;
                    END;
                END;
            UNTIL Piecework.NEXT = 0;
    END;

    /*BEGIN
/*{
      Q18285 AML 28/03/23 Creadas CD_PartidasDif - CalculateLinePrev - CD_FactorPartidas
      Q18970 AML 05/06/23 Ajustes de porcentuales.
      Q20047 AML 28/08/23 Informar el coste indirecto.
    }
END.*/
}










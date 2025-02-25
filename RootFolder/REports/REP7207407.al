report 7207407 "QB Import Cost Database Excel"
{


    CaptionML = ENU = 'Import Cost Database from Excel', ESP = 'Importar preciario desde Excel';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Piecework"; "Piecework")
        {

            DataItemTableView = SORTING("Cost Database Default", "No.");
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("group751")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcTipo"; "opcTipo")
                    {

                        CaptionML = ESP = 'Tipo';

                        ; trigger OnValidate()
                        BEGIN
                            opcEliminar := (opcTipo = opcTipo::"Coste+Venta");
                        END;


                    }
                    field("opcEliminar"; "opcEliminar")
                    {

                        CaptionML = ESP = 'Eliminar Registros Existentes';
                    }
                    field("opcReemplazarDescripcion"; "opcReemplazarDescripcion")
                    {

                        CaptionML = ESP = 'Reemplazar Descripci¢n Prod/Rec';
                    }
                    group("group755")
                    {

                        CaptionML = ESP = 'Formato de la excel';
                        field("firstLine"; "firstLine")
                        {

                            CaptionML = ESP = 'Primera l¡nea a leer';
                        }

                    }

                }

            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        VAR
            //                          FileMgt@1001 :
            FileMgt: Codeunit 419;
        BEGIN
            IF CloseAction = ACTION::OK THEN BEGIN
                ServerFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);

                SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
            END;
        END;


    }
    labels
    {
    }

    var
        //       BillOfItemData@1100286029 :
        BillOfItemData: Record 7207384;
        //       ExcelBuffer@1021 :
        ExcelBuffer: Record 370;
        //       Item@1100286035 :
        Item: Record 27;
        //       MeasureLine@1100286034 :
        MeasureLine: Record 7207285;
        //       PieceworkSetup@1100286000 :
        PieceworkSetup: Record 7207279;
        //       QBText@1100286030 :
        QBText: Record 7206918;
        //       Resource@1100286027 :
        Resource: Record 156;
        //       ResourceCost@1100286019 :
        ResourceCost: Record 202;
        //       ResourceUnitofMeasure@1100286028 :
        ResourceUnitofMeasure: Record 205;
        //       UnitOfMeasure@1100286018 :
        UnitOfMeasure: Record 204;
        //       Window@1007 :
        Window: Dialog;
        //       ServerFileName@1025 :
        ServerFileName: Text;
        //       SheetName@1013 :
        SheetName: Text[250];
        //       ToCostBudgetName@1012 :
        ToCostBudgetName: Code[10];
        //       x@7001100 :
        x: Integer;
        //       TotalColums@7001101 :
        TotalColums: Integer;
        //       TotalRows@7001102 :
        TotalRows: Integer;
        //       codpreciario@7001104 :
        codpreciario: Code[20];
        //       contador@7001108 :
        contador: Integer;
        //       codigo@7001109 :
        codigo: Text;
        //       partida@7001115 :
        partida: Code[20];
        //       NameFile@7001120 :
        NameFile: Text;
        //       ValCode@1100286022 :
        ValCode: Text;
        //       ValPrestoCode@1100286026 :
        ValPrestoCode: Text;
        //       ValUM@1100286021 :
        ValUM: Text;
        //       ValDescription@1100286023 :
        ValDescription: Text;
        //       ValCantidad@1100286024 :
        ValCantidad: Decimal;
        //       ValPrecio@1100286025 :
        ValPrecio: Decimal;
        //       CCode@1100286038 :
        CCode: Code[20];
        //       DCode@1100286042 :
        DCode: Code[20];
        //       ICode@1100286043 :
        ICode: Code[20];
        //       Tree@1100286039 :
        Tree: ARRAY[50] OF Text;
        //       LongTree@1100286044 :
        LongTree: ARRAY[50] OF Integer;
        //       nnode@1100286040 :
        nnode: Integer;
        //       AntType@1100286041 :
        AntType: Text;
        //       "--------------------------- Columnas"@1100286003 :
        "--------------------------- Columnas": Integer;
        //       firstLine@1100286017 :
        firstLine: Integer;
        //       colTipo@1100286004 :
        colTipo: Integer;
        //       colPiecework@1100286020 :
        colPiecework: Integer;
        //       colPresto@1100286005 :
        colPresto: Integer;
        //       colCantidad@1100286006 :
        colCantidad: Integer;
        //       colPrecio@1100286007 :
        colPrecio: Integer;
        //       colUM@1100286008 :
        colUM: Integer;
        //       colDescripcion@1100286009 :
        colDescripcion: Integer;
        //       colDesUnidades@1100286015 :
        colDesUnidades: Integer;
        //       colNunidades@1100286011 :
        colNunidades: Integer;
        //       colLong@1100286012 :
        colLong: Integer;
        //       colAncho@1100286013 :
        colAncho: Integer;
        //       colAlto@1100286014 :
        colAlto: Integer;
        //       txtCol@1100286010 :
        txtCol: Text;
        //       "--------------------------- Opciones"@1100286001 :
        "--------------------------- Opciones": Integer;
        //       opcTipo@1100286002 :
        opcTipo: Option "Coste+Venta","Venta";
        //       opcEliminar@1100286016 :
        opcEliminar: Boolean;
        //       Text000@1038 :
        Text000: TextConst ENU = 'You must specify a budget name to which to import.', ESP = 'Debe especificar un nombre de ppto. al que importar.';
        //       Text001@1037 :
        Text001: TextConst ENU = 'Do you want to create %1 with the name %2?', ESP = '¨Desea crear %1 con el nombre %2?';
        //       Text002@1100 :
        Text002: TextConst ESP = 'Proceso Finalizado';
        //       Text003@1035 :
        Text003: TextConst ENU = 'Are you sure that you want to %1 for the budget name %2?', ESP = '¨Est  seguro de que desea %1 para el nombre ppto. %2?';
        //       Text004@1034 :
        Text004: TextConst ENU = '%1 table has been successfully updated with %2 entries.', ESP = '%1 tabla se ha actualizado correctamente con %2 movs.';
        //       Text006@1032 :
        Text006: TextConst ENU = 'Import Excel File', ESP = 'Importar fich. Excel';
        //       Text007@1031 :
        Text007: TextConst ENU = 'Analyzing Data...\\', ESP = 'Analizar Datos...\\';
        //       Text009@1029 :
        Text009: TextConst ENU = 'Cost Type No', ESP = 'N§ tipo coste';
        //       Text010@1100286037 :
        Text010: TextConst ESP = 'El nombde de la columna no es v lido';
        //       Text011@1027 :
        Text011: TextConst ENU = 'The text %1 can only be specified once in the Excel worksheet.', ESP = 'El texto %1 s¢lo se puede especificar una vez en la hoja de Excel.';
        //       Text014@1026 :
        Text014: TextConst ENU = 'Date', ESP = 'Fecha';
        //       Text017@1023 :
        Text017: TextConst ENU = 'Cost Center Code', ESP = 'C¢digo centro coste';
        //       Text018@1022 :
        Text018: TextConst ENU = 'Cost Object Code', ESP = 'C¢digo objeto coste';
        //       Text019@1004 :
        Text019: TextConst ENU = 'You cannot import %1 value, which is not available in the %2 table.', ESP = 'No puede importar el valor %1, que no est  disponible en la tabla %2.';
        //       Text023@1003 :
        Text023: TextConst ENU = 'You cannot import the same information more than once.', ESP = 'No puede importar la misma informaci¢n m s de una vez.';
        //       Text025@1002 :
        Text025: TextConst ENU = 'Cost Types have not been found in the Excel worksheet.', ESP = 'Los tipos de coste no se han encontrado en la hoja de Excel.';
        //       Text026@1001 :
        Text026: TextConst ENU = 'Dates have not been recognized in the Excel worksheet.', ESP = 'Las fechas no se han reorganizado en la hoja de Excel.';
        //       Text027@1000 :
        Text027: TextConst ENU = 'Replace entries,Add entries', ESP = 'Reemplazar movs.,A¤adir movs.';
        //       Text028@1024 :
        Text028: TextConst ENU = 'Importing from Excel worksheet', ESP = 'Importando desde hoja de trabajo de Excel';
        //       ExcelFileExtensionTok@1014 :
        ExcelFileExtensionTok:
// {Locked}
TextConst ENU = '.xlsx', ESP = '.xlsx';
        //       text50001@7001119 :
        text50001: TextConst ENU = 'The process has stopped', ESP = 'Se ha detenido el proceso';
        //       text50000@7001118 :
        text50000: TextConst ENU = 'We will look for information about the price% 1 already imported. if it exists, it will be erased. Do you wish to continue?', ESP = 'Ya existen unidades de obra en el preciario %1 ¨Desea eliminarlas?';
        //       Text008@7001124 :
        Text008: TextConst ENU = 'Presto->', ESP = 'Presto->';
        //       TextDesc@1100286031 :
        TextDesc: Text;
        //       opcReemplazarDescripcion@1100286032 :
        opcReemplazarDescripcion: Boolean;
        //       opcCol@1100286033 :
        opcCol: ARRAY[20] OF Code[2];
        //       Letras@1100286036 :
        Letras: TextConst ESP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';



    trigger OnInitReport();
    begin
        //JAV 06/06/22: - QB 1.10.49 Estaban mal ubicadas las constantes
        colPiecework := 1;
        colPresto := 2;
        colTipo := 3;
        colUM := 4;
        colDescripcion := 5;
        colCantidad := 6;
        colPrecio := 7;
        colDesUnidades := 8;
        colNunidades := 9;
        colLong := 10;
        colAncho := 11;
        colAlto := 12;

        opcTipo := opcTipo::"Coste+Venta";
        opcEliminar := TRUE;
        firstLine := 4;
        // opcCol[colPiecework]   := GetCol(colPiecework);
        // opcCol[colPresto]      := GetCol(colPresto);
        // opcCol[colTipo]        := GetCol(colTipo);
        // opcCol[colUM]          := GetCol(colUM);
        // opcCol[colDescripcion] := GetCol(colDescripcion);
        // opcCol[colDesUnidades] := GetCol(colDesUnidades);
        // opcCol[colNunidades]   := GetCol(colNunidades);
        // opcCol[colLong]        := GetCol(colLong);
        // opcCol[colAncho]       := GetCol(colAncho);
        // opcCol[colAlto]        := GetCol(colAlto);
        // opcCol[colCantidad]    := GetCol(colCantidad);
        // opcCol[colPrecio]      := GetCol(colPrecio);
    end;

    trigger OnPreReport();
    begin
        //Si hay que eliminar
        if opcEliminar then
            DeleteRecords;
        //Si cargo venta, debo eliminar para que no mezcle valores
        if (opcTipo = opcTipo::Venta) then
            CleanSale;

        PieceworkSetup.GET;

        ExcelBuffer.LOCKTABLE;
        ExcelBuffer.OpenBook(ServerFileName, SheetName);
        ExcelBuffer.ReadSheet;
        GetLastRowandColumn;
        Window.OPEN('Importando #1#######');

        //JAV 06/06/22: - QB 1.10.49 Si no tenemos c¢digo propio lo montamos
        CCode := '00';   //Empezamos usando este
        DCode := '';     //No usamos este c¢digo
        nnode := 1;      //Nivel en el arbol

        FOR x := firstLine TO TotalRows DO
            InsertData(x);

        ExcelBuffer.DELETEALL;
        CrearDescompuestos;
        //-Q18285
        FillFatherCode;
        //+Q18285
        Window.CLOSE;
        MESSAGE(Text002);
    end;



    LOCAL procedure AnalyzeData()
    var
        //       TempExcelBuffer@1000 :
        TempExcelBuffer: Record 370 TEMPORARY;
        //       CostBudgetBuffer@1001 :
        CostBudgetBuffer: Record 1114;
        //       CostBudgetBuffer2@1002 :
        CostBudgetBuffer2: Record 1114;
        //       CostCenter@1004 :
        CostCenter: Record 1112;
        //       CostObject@1007 :
        CostObject: Record 1113;
        //       HeaderRowNo@1003 :
        HeaderRowNo: Integer;
        //       TestDateTime@1005 :
        TestDateTime: DateTime;
        //       OldRowNo@1006 :
        OldRowNo: Integer;
    begin
    end;

    //     procedure SetGLBudgetName (NewToCostBudgetName@1000 :
    procedure SetGLBudgetName(NewToCostBudgetName: Code[10])
    begin
        ToCostBudgetName := NewToCostBudgetName;
    end;

    //     LOCAL procedure IsLineTypeCostType (CostTypeNo@1001 :
    LOCAL procedure IsLineTypeCostType(CostTypeNo: Code[20]): Boolean;
    var
        //       CostType@1000 :
        CostType: Record 1103;
    begin
        if not CostType.GET(CostTypeNo) then
            exit(FALSE);
        exit(CostType.Type = CostType.Type::"Cost Type");
    end;

    //     LOCAL procedure InsertTempExcelBuffer (var ExcelBuffer@1003 : Record 370;var TempExcelBuffer@1002 : TEMPORARY Record 370;Text@1001 :
    LOCAL procedure InsertTempExcelBuffer(var ExcelBuffer: Record 370; var TempExcelBuffer: Record 370 TEMPORARY; Text: Text[250])
    begin
        TempExcelBuffer := ExcelBuffer;
        TempExcelBuffer.Comment := Text;
        TempExcelBuffer.INSERT;
    end;

    //     procedure InsertData (RowNo@7001100 :
    procedure InsertData(RowNo: Integer)
    var
        //       Instr@7001101 :
        Instr: InStream;
        //       outStr@7001102 :
        outStr: OutStream;
        //       BigTextValue@7001103 :
        BigTextValue: BigText;
        //       StringText@7001104 :
        StringText: Text[1024];
        //       ResourceUnitofMeasure@1100286001 :
        ResourceUnitofMeasure: Record 205;
        //       UnitOfMeasure@1100286000 :
        UnitOfMeasure: Record 204;
        //       ItemUnitOfMeasure@1100286002 :
        ItemUnitOfMeasure: Record 5404;
        //       TipoLinea@1100286003 :
        TipoLinea: Text;
    begin
        contador := 0;

        TipoLinea := GetValueAtCell(RowNo, opcCol[colTipo], 0);
        ValPrestoCode := GetValueAtCell(RowNo, opcCol[colPresto], MAXSTRLEN(Piecework."PRESTO Code Sales"));
        ValUM := UPPERCASE(GetValueAtCell(RowNo, opcCol[colUM], MAXSTRLEN(Piecework."Units of Measure")));
        ValDescription := GetValueAtCell(RowNo, opcCol[colDescripcion], 0);
        ValCantidad := GetDecimalAtCell(RowNo, opcCol[colCantidad]);
        ValPrecio := GetDecimalAtCell(RowNo, opcCol[colPrecio]);

        //JAV 06/06/22: - QB 1.10.49 Si no tenemos c¢digo propio, creamos uno en funci¢n de lo que vamos leyendo
        if (opcCol[colPiecework] <> '') then
            ValCode := UPPERCASE(GetValueAtCell(RowNo, opcCol[colPiecework], MAXSTRLEN(Piecework."No.")))
        else begin
            //Si es l¡nea de tipo cap¡tulo subir un nivel
            if (IsCaptitulo(TipoLinea)) then begin
                //-Q18285 Para evitar que cap¡tulos sin partidas se generen como subniveles.
                if nnode > 1 then
                    if (STRLEN(ValPrestoCode) <= LongTree[nnode - 1]) then
                        repeat
                            nnode := nnode - 1; //Retrocedemos un nivel
                            LongTree[nnode] := 0;
                            Tree[nnode] := '';
                        until (STRLEN(ValPrestoCode) <= LongTree[nnode]) or (nnode = 1);
                //+Q18285
                Tree[nnode] := ValPrestoCode;
                LongTree[nnode] := STRLEN(ValPrestoCode);
                if (STRLEN(CCode) >= nnode * 2) then
                    CCode := COPYSTR(CCode, 1, nnode * 2)
                else
                    CCode := CCode + '00';

                CCode := INCSTR(CCode);

                nnode += 1;
                Tree[nnode] := '';
                DCode := '00';
            end;

            //Si es de tipo partida hay que contar en el nivel
            if (IsPartida(TipoLinea)) then begin
                if (STRLEN(CCode) < nnode * 2) then
                    CCode := CCode + '00';

                CCode := INCSTR(CCode);
                DCode := '00';
            end;

            //Si es una l¡nea en blanco con el total del cap¡tulo, entonces cerramos
            if (nnode > 1) then begin
                if (TipoLinea = '') and (ValDescription = Tree[nnode - 1]) then begin
                    Tree[nnode - 1] := '';
                    if (nnode > 1) then
                        nnode -= 1;
                end;
            end;
            //Guardo el valor
            ValCode := CCode;
        end;

        Window.UPDATE(1, ValCode);  //JAV  02/10/20: - QB 1.06.18 Se mejora el manejo de la pantalla de estado

        if (IsCaptitulo(TipoLinea)) or (IsPartida(TipoLinea)) then begin
            if (not Piecework.GET(codpreciario, ValCode)) then begin
                Piecework.INIT;
                Piecework."Cost Database Default" := codpreciario;
                Piecework."No." := ValCode;
                Piecework.INSERT(TRUE);
            end;

            Piecework."Units of Measure" := COPYSTR(ValUM, 1, MAXSTRLEN(Piecework."Units of Measure"));
            FillSmallDescription(MAXSTRLEN(Piecework.Description), Piecework.Description, Piecework."Description 2", ValDescription);
            if IsCaptitulo(TipoLinea) then begin
                Piecework."Account Type" := Piecework."Account Type"::Heading;
                Piecework."Measurement Cost" := 1;
                Piecework."Measurement Sale" := 1;
            end;

            if IsPartida(TipoLinea) then begin
                partida := ValCode;
                Piecework."Account Type" := Piecework."Account Type"::Unit;
                if (opcTipo = opcTipo::"Coste+Venta") then begin
                    Piecework."Measurement Cost" := ValCantidad;
                    Piecework."Price Cost" := ValPrecio;
                end;
                Piecework."Measurement Sale" := ValCantidad;
                Piecework."Proposed Sale Price" := ValPrecio;
            end;
            if opcTipo = 0 then Piecework.VALIDATE("PRESTO Code Cost", ValPrestoCode);
            Piecework.VALIDATE("PRESTO Code Sales", ValPrestoCode);
            Piecework.VALIDATE("Account Type");
            Piecework.VALIDATE("Price Cost", Piecework."Price Cost");
            Piecework.VALIDATE("Proposed Sale Price", Piecework."Proposed Sale Price");
            Piecework."Certification Unit" := TRUE;
            //-Q18285
            if Piecework.Description = '' then Piecework.Description := Piecework."No."; //Porque no se admiten descripciones vacias
                                                                                         //+Q18285

            Piecework.MODIFY(TRUE);
        end;

        if (IsMaterial(TipoLinea)) or (IsMaquinaria(TipoLinea)) or (IsManoObra(TipoLinea)) or (IsOtros(TipoLinea)) then begin
            if (DCode <> '') then begin
                DCode := INCSTR(DCode);
                ICode := ValCode + DCode;
            end else
                ICode := ValCode;
        end;

        if (IsMaquinaria(TipoLinea)) or (IsManoObra(TipoLinea)) or (IsOtros(TipoLinea)) then begin

            if (Resource.GET(ICode)) then begin
                if (opcReemplazarDescripcion) then begin
                    FillSmallDescription(MAXSTRLEN(Resource.Name), Resource.Name, Resource."Name 2", ValDescription);
                    Resource.MODIFY;
                end;
            end else begin
                Resource.INIT;
                Resource."No." := ICode;
                FillSmallDescription(MAXSTRLEN(Resource.Name), Resource.Name, Resource."Name 2", ValDescription);
                if (opcTipo = opcTipo::"Coste+Venta") then
                    Resource."Direct Unit Cost" := ValPrecio;
                Resource.INSERT;

                //JMMA 10/09/20: - QB 1.06.12 Crear las unidades de medida
                if not UnitOfMeasure.GET(ValUM) then begin
                    UnitOfMeasure.INIT();
                    UnitOfMeasure.Code := ValUM;
                    UnitOfMeasure.Description := COPYSTR(Text008 + ValUM, 1, 10);
                    UnitOfMeasure.INSERT(TRUE);
                end;
                if not ResourceUnitofMeasure.GET(ICode, ValUM) then begin
                    ResourceUnitofMeasure.INIT();
                    ResourceUnitofMeasure.VALIDATE("Resource No.", ICode);
                    ResourceUnitofMeasure.VALIDATE(Code, ValUM);
                    ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                    ResourceUnitofMeasure.INSERT(TRUE);
                end;
                //JMMA fin

                Resource."Base Unit of Measure" := ValUM;
                Resource.MODIFY;

            end;

            if (opcTipo = opcTipo::"Coste+Venta") then begin
                BillOfItemData.INIT;
                BillOfItemData."Cod. Piecework" := partida;
                BillOfItemData."No." := ICode;
                //JMMA 290121
                FillSmallDescription(MAXSTRLEN(BillOfItemData.Description), BillOfItemData.Description, BillOfItemData."Description 2", ValDescription);
                //JMMA 290121
                BillOfItemData."Units of Measure" := ValUM;
                BillOfItemData.Type := BillOfItemData.Type::Resource;
                BillOfItemData."Cod. Cost database" := codpreciario;
                BillOfItemData."Bill of Item Units" := 1;
                BillOfItemData."Quantity By" := ValCantidad;
                BillOfItemData."Direct Unit Cost" := ValPrecio;
                if (ValPrecio <> 0) then
                    BillOfItemData.VALIDATE("Direct Unit Cost", BillOfItemData."Direct Unit Cost");       //JMMA

                //Q8383-
                if IsMaquinaria(TipoLinea) then begin
                    //JAV 25/02/21: - QB 1.08.16 Se verifica estos valores de configuraci¢n
                    PieceworkSetup.TESTFIELD("CA PRESTO Machinery");
                    BillOfItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Machinery");
                end;
                if IsManoObra(TipoLinea) then begin
                    //JAV 25/02/21: - QB 1.08.16 Se verifica estos valores de configuraci¢n
                    PieceworkSetup.TESTFIELD("CA PRESTO Resource");
                    BillOfItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Resource");
                end;
                //Q8383+

                if (not BillOfItemData.INSERT) then;
            end;
        end;

        contador := 0;
        if IsMaterial(TipoLinea) then begin
            if (Item.GET(ICode)) then begin
                if (opcReemplazarDescripcion) then begin
                    FillSmallDescription(MAXSTRLEN(Item.Description), Item.Description, Item."Description 2", ValDescription);
                    Item.MODIFY;
                end;
            end else begin
                Item.INIT;
                Item."No." := ICode;
                FillSmallDescription(MAXSTRLEN(Item.Description), Item.Description, Item."Description 2", ValDescription);
                Item.INSERT;

                //JMMA 10/09/20: - QB 1.06.12 Crear las unidades de medida
                if not UnitOfMeasure.GET(ValUM) then begin
                    UnitOfMeasure.INIT();
                    UnitOfMeasure.Code := ValUM;
                    UnitOfMeasure.Description := COPYSTR(Text008 + ValUM, 1, 10);
                    UnitOfMeasure.INSERT(TRUE);
                end;
                if not ItemUnitOfMeasure.GET(ICode, ValUM) then begin
                    ItemUnitOfMeasure.INIT();
                    ItemUnitOfMeasure.VALIDATE("Item No.", ICode);
                    ItemUnitOfMeasure.VALIDATE(Code, ValUM);
                    ItemUnitOfMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                    ItemUnitOfMeasure.INSERT(TRUE);
                end;
                //JMMA fin
                Item."Base Unit of Measure" := ValUM;
                Item.MODIFY;


            end;

            if (opcTipo = opcTipo::"Coste+Venta") then begin
                BillOfItemData.INIT;
                BillOfItemData."Cod. Piecework" := partida;
                BillOfItemData."No." := ICode;
                //JMMA 290121
                FillSmallDescription(MAXSTRLEN(BillOfItemData.Description), BillOfItemData.Description, BillOfItemData."Description 2", ValDescription);
                //JMMA 290121

                BillOfItemData."Units of Measure" := ValUM;
                BillOfItemData.Type := BillOfItemData.Type::Item;
                BillOfItemData."Cod. Cost database" := codpreciario;
                BillOfItemData."Bill of Item Units" := 1;
                BillOfItemData."Quantity By" := ValCantidad;
                BillOfItemData."Direct Unit Cost" := ValPrecio;
                if (ValPrecio <> 0) then
                    BillOfItemData.VALIDATE("Direct Unit Cost", BillOfItemData."Direct Unit Cost");            //JMMA

                //JAV 25/02/21: - QB 1.08.16 Se verifica estos valores de configuraci¢n
                PieceworkSetup.TESTFIELD("CA PRESTO Item");
                BillOfItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Item"); //Q8383

                if not BillOfItemData.INSERT then;
            end;
        end;

        if GetValueAtCell(RowNo, opcCol[colNunidades], 0) <> '' then begin
            MeasureLine.INIT;
            MeasureLine."Cost Database Code" := codpreciario;
            MeasureLine."Cod. Jobs Unit" := partida;
            MeasureLine."Line No." += 10000;
            MeasureLine.Description := GetValueAtCell(RowNo, opcCol[colDesUnidades], MAXSTRLEN(MeasureLine.Description));
            MeasureLine.VALIDATE(Units, GetDecimalAtCell(RowNo, opcCol[colNunidades]));
            MeasureLine.VALIDATE(Length, GetDecimalAtCell(RowNo, opcCol[colLong]));
            MeasureLine.VALIDATE(Width, GetDecimalAtCell(RowNo, opcCol[colAncho]));
            MeasureLine.VALIDATE(Height, GetDecimalAtCell(RowNo, opcCol[colAlto]));
            if not MeasureLine.INSERT(TRUE) then    //JAV 05/10/20 Si existe modifica
                MeasureLine.MODIFY(TRUE);
        end;

        if (ICode = '') and (TipoLinea = '') and (ValDescription <> '') then begin
            //jmma prueba para borrar ExtendedTextHeader.VALIDATE("Table Name",15);
            Piecework.RESET;
            Piecework.SETRANGE("Cost Database Default", codpreciario);
            Piecework.SETRANGE("No.", partida);
            if Piecework.FINDSET then begin
                //JMMA CREAR AQUÖ FUNCIàN PARA INCORPORAR TODO EL TEXTO
                QBText.INIT;
                QBText.Table := QBText.Table::Preciario;
                QBText.Key1 := Piecework."Cost Database Default";
                QBText.Key2 := Piecework."No.";
                if not QBText.INSERT then;

                GetBlobValueAtCell(RowNo, opcCol[colDescripcion], BigTextValue);
                QBText."Cost Text".CREATEOUTSTREAM(outStr);
                BigTextValue.WRITE(outStr);
                QBText."Cost Size" := QBText."Cost Text".LENGTH;
                QBText.MODIFY(TRUE);
            end;
        end;
    end;

    LOCAL procedure CrearDescompuestos()
    begin
        //JMMA CREAR DESCOMPUESTO TIPO  RECURSO EN LAS PARTIDAS DE COSTE QUE NO TIENEN
        if (opcTipo = opcTipo::"Coste+Venta") then begin
            Piecework.RESET;
            Piecework.SETRANGE("Cost Database Default", codpreciario);
            Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
            if Piecework.FINDFIRST then
                repeat
                    BillOfItemData.RESET;
                    BillOfItemData.SETRANGE("Cod. Cost database", Piecework."Cost Database Default");
                    BillOfItemData.SETRANGE("Cod. Piecework", Piecework."No.");
                    if (BillOfItemData.ISEMPTY) then begin
                        if (not Resource.GET(Piecework."Unique Code")) then begin   //JAV 05/10/20: - QB 1.06.18 Si ya existe la modifico
                            Resource.INIT();
                            Resource.VALIDATE("No.", Piecework."Unique Code");
                            Resource.INSERT(TRUE);
                        end;

                        if not UnitOfMeasure.GET(Piecework."Units of Measure") then begin
                            UnitOfMeasure.INIT();
                            UnitOfMeasure.Code := Piecework."Units of Measure";
                            UnitOfMeasure.Description := COPYSTR(Text008 + Piecework."Units of Measure", 1, MAXSTRLEN(UnitOfMeasure.Description));
                            UnitOfMeasure.INSERT(TRUE);
                        end;
                        if not ResourceUnitofMeasure.GET(Piecework."Unique Code", Piecework."Units of Measure") then begin
                            ResourceUnitofMeasure.INIT();
                            ResourceUnitofMeasure.VALIDATE("Resource No.", Piecework."Unique Code");
                            ResourceUnitofMeasure.VALIDATE(Code, Piecework."Units of Measure");
                            ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                            ResourceUnitofMeasure.INSERT(TRUE);
                        end;

                        Resource.VALIDATE(Type, Resource.Type::Subcontracting);
                        if (opcReemplazarDescripcion) then
                            FillSmallDescription(MAXSTRLEN(Resource.Name), Resource.Name, Resource."Name 2", Piecework.Description);
                        Resource.VALIDATE("Base Unit of Measure", UnitOfMeasure.Code);
                        Resource.VALIDATE("Direct Unit Cost", Piecework."Price Cost");
                        Resource.VALIDATE("Gen. Prod. Posting Group", PieceworkSetup."G.C. Resource PRESTO");
                        Resource."Created by PRESTO S/N" := TRUE;
                        Resource.MODIFY(TRUE);

                        //Le pongo el precio de coste
                        if (not ResourceCost.GET(ResourceCost.Type::Resource, Piecework."Unique Code")) then begin
                            ResourceCost.INIT();
                            ResourceCost.VALIDATE(Type, ResourceCost.Type::Resource);
                            ResourceCost.VALIDATE(Code, Resource."No.");
                            ResourceCost.VALIDATE("Direct Unit Cost", Piecework."Price Cost");
                            ResourceCost.INSERT(TRUE);
                        end;

                        CLEAR(BillOfItemData);
                        BillOfItemData."Cod. Cost database" := Piecework."Cost Database Default";
                        BillOfItemData."Cod. Piecework" := Piecework."No.";
                        BillOfItemData.Type := BillOfItemData.Type::Resource;
                        BillOfItemData."No." := Piecework."Unique Code";
                        //JMMA 290121
                        FillSmallDescription(MAXSTRLEN(BillOfItemData.Description), BillOfItemData.Description, BillOfItemData."Description 2", Piecework.Description);
                        //JMMA 290121
                        BillOfItemData."Quantity By" := 1;
                        BillOfItemData."Units of Measure" := Piecework."Units of Measure";
                        BillOfItemData."Bill of Item Units" := 1;
                        BillOfItemData."Unit Cost Indirect" := 0;
                        BillOfItemData.VALIDATE("Direct Unit Cost", Piecework."Price Cost");          //JMMA
                                                                                                      //JAV 25/02/21: - QB 1.08.16 Se verifica estos valores de configuraci¢n
                        PieceworkSetup.TESTFIELD("CA PRESTO Resource");
                        BillOfItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Resource");

                        if not BillOfItemData.INSERT then        //JAV 05/10/20: - QB 1.06.18 Si ya existe la modifico
                            BillOfItemData.MODIFY;
                    end;

                until Piecework.NEXT = 0;
        end;
    end;

    //     procedure GetValueAtCell (RowNo@7001100 : Integer;ColName@7001101 : Code[2];MaxLen@1100286000 :
    procedure GetValueAtCell(RowNo: Integer; ColName: Code[2]; MaxLen: Integer): Text;
    var
        //       ColNo@1100286003 :
        ColNo: Integer;
        //       Value@1100286001 :
        Value: Text;
        //       Txt01@1100286002 :
        Txt01: TextConst ESP = 'La linea %1 columna %2 tiene un valor "%3" que sobrepasa la longitud m xima, ¨desea recortarlo?';
    begin
        //Busca el valor de una celda en texto
        ColNo := GelNumCol(ColName);

        if (ColNo = 0) then
            exit('');

        if (not ExcelBuffer.GET(RowNo, ColNo)) then
            CLEAR(ExcelBuffer."Cell Value as Text");

        Value := QuitarEspacios(ExcelBuffer."Cell Value as Text");

        if (MaxLen <> 0) and (STRLEN(Value) > MaxLen) then begin
            if not CONFIRM(Txt01, FALSE, RowNo, ColNo, Value) then
                ERROR('');
            Value := COPYSTR(Value, 1, MaxLen);
        end;

        exit(Value);
    end;

    //     procedure GetIntegerAtCell (RowNo@7001100 : Integer;ColName@7001101 :
    procedure GetIntegerAtCell(RowNo: Integer; ColName: Code[2]): Integer;
    var
        //       ColNo@1100286002 :
        ColNo: Integer;
        //       valor@1100286001 :
        valor: Text;
        //       vInt@1100286000 :
        vInt: Integer;
    begin
        //Busca el valor de una celda como un entero
        valor := GetValueAtCell(RowNo, ColName, 0);
        if (not EVALUATE(vInt, valor)) then
            exit(0);

        exit(vInt);
    end;

    //     procedure GetDecimalAtCell (RowNo@7001100 : Integer;ColName@7001101 :
    procedure GetDecimalAtCell(RowNo: Integer; ColName: Code[2]): Decimal;
    var
        //       valor@1100286001 :
        valor: Text;
        //       vDec@1100286000 :
        vDec: Decimal;
    begin
        //Busca el valor de una celda como un decimal
        valor := GetValueAtCell(RowNo, ColName, 0);
        if (not EVALUATE(vDec, valor)) then
            exit(0);

        exit(vDec);
    end;

    procedure GetLastRowandColumn()
    begin
        ExcelBuffer.SETRANGE("Row No.", 1);
        TotalColums := ExcelBuffer.COUNT;

        ExcelBuffer.RESET;
        if ExcelBuffer.FINDLAST then
            TotalRows := ExcelBuffer."Row No.";
    end;

    //     procedure GetNoCostDatabase (Code@7001100 :
    procedure GetNoCostDatabase(Code: Code[20])
    begin
        codpreciario := Code;
    end;

    //     LOCAL procedure QuitarEspacios (texto@7001100 :
    LOCAL procedure QuitarEspacios(texto: Text): Text;
    var
        //       i@7001101 :
        i: Integer;
    begin
        exit(DELCHR(texto, '<>', ' '));  //JAV  02/10/20: - QB 1.06.18 Se usa la funci¢n est ndar que es mas r pida
    end;

    //     LOCAL procedure FillSmallDescription (MaxLen@1100286001 : Integer;var Desc1@7001100 : Text;var Desc2@7001101 : Text;Descripcion@1100286000 :
    LOCAL procedure FillSmallDescription(MaxLen: Integer; var Desc1: Text; var Desc2: Text; Descripcion: Text)
    var
        //       pos@7001105 :
        pos: Integer;
    begin
        Descripcion := QuitarEspacios(Descripcion);  //Elimino espacios por delante y por detr s
        pos := FindLastSpace(MaxLen, Descripcion);
        if (pos = 0) then begin
            Desc1 := '';
            Desc2 := '';
        end else begin
            Desc1 := COPYSTR(Descripcion, 1, pos);
            Desc2 := '';
            Descripcion := COPYSTR(Descripcion, pos + 2);
            if (Descripcion <> '') then
                Desc2 := COPYSTR(Descripcion, 1, MaxLen);
        end;
    end;

    //     LOCAL procedure FindLastSpace (len@1100286000 : Integer;String@7001100 :
    LOCAL procedure FindLastSpace(len: Integer; String: Text): Integer;
    var
        //       i@7001101 :
        i: Integer;
    begin
        if (String = '') then
            exit(0);

        if (STRLEN(String) <= len) then
            exit(STRLEN(String));

        FOR i := len + 1 DOWNTO 1 DO
            if COPYSTR(String, i, 1) = ' ' then
                exit(i - 1);

        exit(len); //JAV  02/10/20: - QB 1.06.18 Se retorna algo siempre
    end;

    //     procedure GetBlobValueAtCell (RowNo@7001100 : Integer;ColName@7001101 : Code[2];var BigTextDescription@7001106 :
    procedure GetBlobValueAtCell(RowNo: Integer; ColName: Code[2]; var BigTextDescription: BigText)
    var
        //       ColNo@1100286000 :
        ColNo: Integer;
        //       Instr@7001105 :
        Instr: InStream;
        //       outStr@7001104 :
        outStr: OutStream;
        //       BigTextValue@7001103 :
        BigTextValue: BigText;
        //       StringText@7001102 :
        StringText: Text[1024];
    begin
        CLEAR(BigTextDescription);
        ColNo := GelNumCol(ColName);
        if (ExcelBuffer.GET(RowNo, ColNo)) then begin
            ExcelBuffer.CALCFIELDS("Cell Value as Text2");
            ExcelBuffer."Cell Value as Text2".CREATEINSTREAM(Instr);
            BigTextDescription.READ(Instr);
        end;
    end;

    LOCAL procedure DeleteRecords()
    var
        //       CostDatabase@1100286000 :
        CostDatabase: Record 7207271;
    begin
        //JAV 23/11/20: - QB 1.07.06 Se usa la nueva funci¢n en la tabla
        CostDatabase.DeleteData(codpreciario);
    end;

    LOCAL procedure CleanSale()
    begin
        // Debo limpiar las unidades de venta del preciario
        Piecework.RESET();
        Piecework.SETCURRENTKEY(Piecework."Cost Database Default");
        Piecework.SETRANGE(Piecework."Cost Database Default", codpreciario);
        if Piecework.FINDSET then
            repeat
                Piecework."Measurement Sale" := 0;
                Piecework.VALIDATE("Proposed Sale Price", 0);
                Piecework."Certification Unit" := FALSE;
                Piecework.MODIFY(TRUE);
            until Piecework.NEXT = 0;
    end;

    //     LOCAL procedure IsCaptitulo (pTipo@1100286000 :
    LOCAL procedure IsCaptitulo(pTipo: Text): Boolean;
    begin
        exit(LOWERCASE(pTipo) IN ['c', 'cap', 'cap¡tulo', 'capitulo']);
    end;

    //     LOCAL procedure IsPartida (pTipo@1100286000 :
    LOCAL procedure IsPartida(pTipo: Text): Boolean;
    begin
        exit(LOWERCASE(pTipo) IN ['p', 'par', 'partida']);
    end;

    //     LOCAL procedure IsMaquinaria (pTipo@1100286000 :
    LOCAL procedure IsMaquinaria(pTipo: Text): Boolean;
    begin
        exit(LOWERCASE(pTipo) IN ['maquinaria']);
    end;

    //     LOCAL procedure IsManoObra (pTipo@1100286000 :
    LOCAL procedure IsManoObra(pTipo: Text): Boolean;
    begin
        exit(LOWERCASE(pTipo) IN ['mano de obra']);
    end;

    //     LOCAL procedure IsMaterial (pTipo@1100286000 :
    LOCAL procedure IsMaterial(pTipo: Text): Boolean;
    begin
        exit(LOWERCASE(pTipo) IN ['material']);
    end;

    //     LOCAL procedure IsOtros (pTipo@1100286000 :
    LOCAL procedure IsOtros(pTipo: Text): Boolean;
    begin
        exit(LOWERCASE(pTipo) IN ['otros']);
    end;

    //     LOCAL procedure GetCol (pNum@1100286000 :
    LOCAL procedure GetCol(pNum: Integer): Code[2];
    begin
        txtCol := Letras;
        if (pNum = 0) then
            exit('');

        if (pNum < STRLEN(txtCol)) then
            exit(COPYSTR(txtCol, pNum, 1))
        else
            exit(COPYSTR(txtCol, ROUND(pNum / 10, 0), 1) + COPYSTR(txtCol, pNum - ROUND(pNum / 10) * 10, 1));
    end;

    //     LOCAL procedure ValidateCol (pCol@1100286000 :
    LOCAL procedure ValidateCol(pCol: Code[2])
    begin
        pCol := DELCHR(pCol, '<>', ' ');
        if (pCol = '') then
            exit;
        if (STRPOS(Letras, COPYSTR(pCol, 1, 1)) = 0) or ((STRLEN(pCol) = 2) and (STRPOS(Letras, COPYSTR(pCol, 2, 1)) = 0)) then
            ERROR(Text010);
    end;

    //     LOCAL procedure GelNumCol (pName@1100286000 :
    LOCAL procedure GelNumCol(pName: Code[2]): Integer;
    var
        //       num1@1100286001 :
        num1: Integer;
        //       num2@1100286002 :
        num2: Integer;
    begin
        pName := DELCHR(pName, '<>', ' ');
        if (STRLEN(pName) = 1) then begin
            num1 := 0;
            num2 := STRPOS(Letras, COPYSTR(pName, 1, 1));
        end else begin
            num1 := STRPOS(Letras, COPYSTR(pName, 1, 1));
            num2 := STRPOS(Letras, COPYSTR(pName, 2, 1));
        end;
        exit(num1 * STRLEN(Letras) + num2);
    end;

    LOCAL procedure FillFatherCode()
    var
        //       Piecework2@1100286000 :
        Piecework2: Record 7207277;
    begin
        //-Q18285 Complementamos el Father Code
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", codpreciario);
        Piecework.SETRANGE("Account Type", Piecework."Account Type"::Heading);
        if Piecework.FINDSET then
            repeat
                Piecework2.SETRANGE("Cost Database Default", codpreciario);
                Piecework2.SETFILTER("No.", Piecework.Totaling);
                if Piecework2.FINDSET then
                    repeat
                        if Piecework."No." <> Piecework2."No." then begin
                            Piecework2."Father Code" := Piecework."No.";
                            Piecework2.Identation := Piecework.Identation + 1;
                            Piecework2.MODIFY;
                        end;
                    until Piecework2.NEXT = 0;
            until Piecework.NEXT = 0;
    end;

    /*begin
    //{
//      PEL  11/07/18: - QB_2785 Limite de chars
//      JMMA 09/09/20: - QB 1.06.12 Si es un cap¡tulo no se evalua el precio pues no tiene sentido
//      JMMA 10/09/20: - QB 1.06.12 Crear las unidades de medida
//      JAV  02/10/20: - QB 1.06.18 Se elimina un bucle sin sentido y se mejora el manejo de la pantalla de estado
//      JAV  18/12/20: - QB 1.07.15 Mejoras generales para evitar repeticiones
//      AML  27/06/23: - Q18285 Solventar problemas con el arbol de lo importado por Excel
//    }
    end.
  */

}




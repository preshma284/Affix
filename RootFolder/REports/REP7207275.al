report 7207275 "Importation Cost Database Out."
{


    CaptionML = ENU = 'Importation Cost Database Out.', ESP = 'Importaci¢n preciario ext.';
    ProcessingOnly = true;

    dataset
    {

        DataItem("ChooseFile"; "2000000026")
        {

            DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER('1' | '2'));
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("group321")
                {

                    CaptionML = ENU = 'Option', ESP = 'Opciones';
                    group("group322")
                    {

                        CaptionML = ENU = 'Option', ESP = 'Cargar Coste';
                        grid("group323")
                        {

                            GridLayout = Rows;
                            group("group324")
                            {

                                CaptionML = ESP = 'Fichero de Coste';
                                field("opcCost"; "opcCost")
                                {

                                    CaptionML = ENU = 'Cargar Fichero Coste';
                                    ShowCaption = false;
                                }
                                field("opcSumMedCost"; "opcSumMedCost")
                                {

                                    CaptionML = ENU = 'Respetar Importe UO';
                                    Importance = Promoted;
                                }
                                field("opcSumMedCost2"; "opcSumMedCost2")
                                {

                                    CaptionML = ENU = 'Respetar Importe Cap.';
                                    Importance = Promoted;
                                }
                                field("opcNameFileCost"; "opcNameFileCost")
                                {

                                    Enabled = opcCost;


                                    ShowCaption = false;
                                    trigger OnAssistEdit()
                                    BEGIN
                                        opcNameFileCost := '';
                                        opcNameFileCost := FileManagement2.OpenFileDialog(Text006, '', 'Archivos BC3 (*.BC3)|*.BC3|Todos los archivos (*.*)|*.*');
                                    END;


                                }

                            }

                        }
                        grid("group329")
                        {

                            GridLayout = Rows;
                            group("group330")
                            {

                                CaptionML = ESP = 'Cargar Descomp./Mediciones';
                                field("false Insert Bill of Item"; "opcInsertBillofItemCost")
                                {

                                    CaptionML = ENU = 'Skip Bill of Item', ESP = 'Cargar descompuestos';
                                    Enabled = opcCost;
                                    ShowCaption = false;
                                }
                                field("opcInsertMeditionCost"; "opcInsertMeditionCost")
                                {

                                    CaptionML = ENU = 'Medicion de Coste';
                                    Editable = opcCost;

                                    ; trigger OnValidate()
                                    BEGIN
                                        IF NOT opcInsertMeditionCost THEN UOCoste := UOCoste::Nada;
                                    END;


                                }
                                field("UOCoste"; "UOCoste")
                                {

                                    CaptionML = ENU = 'Comprobacion de Medicion';

                                    ; trigger OnValidate()
                                    BEGIN
                                        IF NOT opcInsertMeditionCost THEN UOCoste := UOCoste::Nada;
                                    END;


                                }

                            }

                        }
                        grid("group335")
                        {

                            GridLayout = Rows;
                            group("group336")
                            {

                                CaptionML = ESP = 'Cambio en Partidas/Auxiliares';

                            }

                        }

                    }
                    group("group339")
                    {

                        CaptionML = ENU = 'Option', ESP = 'Cargar Venta';
                        grid("group340")
                        {

                            GridLayout = Rows;
                            group("group341")
                            {

                                CaptionML = ESP = 'Fichero de venta';
                                field("opcSales"; "opcSales")
                                {

                                    ShowCaption = false;
                                }
                                field("opcSumMedSale"; "opcSumMedSale")
                                {

                                    CaptionML = ENU = 'Respetar Importe UO';
                                }
                                field("opcSumMedSale2"; "opcSumMedSale2")
                                {

                                    CaptionML = ENU = 'Respetar Importe Cap.';
                                    Importance = Promoted;
                                }
                                field("opcNameFileSales"; "opcNameFileSales")
                                {

                                    CaptionML = ENU = 'File Sales External Cost Database';
                                    Enabled = opcSales;


                                    ShowCaption = false;
                                    trigger OnAssistEdit()
                                    BEGIN
                                        opcNameFileSales := '';
                                        opcNameFileSales := FileManagement2.OpenFileDialog(Text006, '', 'Archivos BC3 (*.BC3)|*.BC3|Todos los archivos (*.*)|*.*');
                                    END;


                                }

                            }

                        }
                        grid("group346")
                        {

                            GridLayout = Rows;
                            group("group347")
                            {

                                CaptionML = ESP = 'Cargar Descomp./Mediciones';
                                field("opcInsertBillofItemSales"; "opcInsertBillofItemSales")
                                {

                                    CaptionML = ESP = 'Cargar descompuestos';
                                    Enabled = opcSales;
                                    ShowCaption = false;
                                }
                                field("opcInsertMeditionSales"; "opcInsertMeditionSales")
                                {

                                    CaptionML = ENU = 'Sales', ESP = 'Medicion de Venta';
                                    Editable = opcSales;

                                    ; trigger OnValidate()
                                    BEGIN
                                        IF NOT opcInsertMeditionSales THEN UOVenta := UOVenta::Nada;
                                    END;


                                }
                                field("UOVenta"; "UOVenta")
                                {

                                    CaptionML = ENU = 'Comprobacion de Medicion';

                                    ; trigger OnValidate()
                                    BEGIN
                                        IF NOT opcInsertMeditionSales THEN UOVenta := UOVenta::Nada;

                                    END;


                                }
                                field("opcMedicionIgual"; "opcMedicionIgual")
                                {

                                    CaptionML = ENU = 'false medicion coste a 0';
                                }

                            }

                        }
                        grid("group353")
                        {

                            GridLayout = Rows;
                            group("group354")
                            {

                                CaptionML = ESP = 'Cambio en Partidas/Auxiliares';

                            }

                        }

                    }
                    group("group357")
                    {

                        CaptionML = ENU = 'Option', ESP = 'Par metros';
                        grid("group358")
                        {

                            GridLayout = Rows;
                            group("group359")
                            {

                                CaptionML = ENU = 'D¡gitos agrupaci¢n BC3', ESP = 'Comenzar en / D¡gitos';
                                field("Group Levelint"; "opcAccountAgrup")
                                {

                                    CaptionML = ENU = 'D¡gitos agrupaci¢n BC3', ESP = 'D¡gitos agrupaci¢n TCQ';
                                    ShowCaption = false;
                                }

                            }
                            group("group361")
                            {

                                CaptionML = ESP = 'Comenzar en / D¡gitos';
                                field("opcAccountGreater"; "opcAccountGreater")
                                {

                                    CaptionML = ESP = 'Comenzar en';


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        opcAccountAgrup := STRLEN(opcAccountGreater);
                                    END;


                                }
                                field("Group Level"; "opcAccountAgrupint")
                                {

                                    CaptionML = ESP = 'D¡gitos agrupaci¢n';


                                    ShowCaption = false;
                                    trigger OnValidate()
                                    BEGIN
                                        IF (STRLEN(opcAccountGreater) > opcAccountAgrup) THEN  //Acortamos
                                            opcAccountGreater := COPYSTR(opcAccountGreater, STRLEN(opcAccountGreater) - opcAccountAgrup + 1);
                                        WHILE (STRLEN(opcAccountGreater) < opcAccountAgrup) DO //Alargamos
                                            opcAccountGreater := '0' + opcAccountGreater;
                                    END;


                                }

                            }

                        }
                        field("opcReplaceDescriptions"; "opcReplaceDescriptions")
                        {

                            CaptionML = ESP = 'Reemplazar descripci¢n prod/rec';
                        }
                        grid("group365")
                        {

                            GridLayout = Rows;
                            group("group366")
                            {

                                CaptionML = ESP = 'Chequear/Max. Diferencia';
                                field("opcErrors"; "opcErrors")
                                {

                                    CaptionML = ESP = 'Chequear Errores';
                                    ShowCaption = false;
                                }
                                field("opcMaxDif"; "opcMaxDif")
                                {

                                    CaptionML = ESP = 'Max.Diferencia aviso';
                                    Enabled = opcErrors;
                                    ShowCaption = false;
                                }

                            }

                        }

                    }
                    group("group369")
                    {

                        CaptionML = ENU = 'Option', ESP = 'Redondeos';
                        field("opcDecCargar"; "opcDecCargar")
                        {

                            CaptionML = ESP = 'Usar';

                            ; trigger OnValidate()
                            BEGIN
                                SetDecimales(opcDecCargar);
                            END;


                        }
                        field("opcDecUOCan"; "opcDecUOCan")
                        {

                            CaptionML = ESP = 'U.O. Cantidad';
                            DecimalPlaces = 2 : 12;
                        }
                        field("opcDecUOPre"; "opcDecUOPre")
                        {

                            CaptionML = ESP = 'U.O. Precio';
                            DecimalPlaces = 2 : 12;
                        }
                        field("opcDecUOImp"; "opcDecUOImp")
                        {

                            CaptionML = ESP = 'U.O. Importe';
                            DecimalPlaces = 2 : 12;
                        }
                        field("opcDecDesCan"; "opcDecDesCan")
                        {

                            CaptionML = ESP = 'Descompuestos Cantidad';
                            DecimalPlaces = 2 : 12;
                        }
                        field("opcDecDesPre"; "opcDecDesPre")
                        {

                            CaptionML = ESP = 'Descompuestos Precio';
                            DecimalPlaces = 2 : 12;
                        }
                        field("opcDecDesImp"; "opcDecDesImp")
                        {

                            CaptionML = ESP = 'Descompuestos Importe';
                            DecimalPlaces = 2 : 12;
                        }

                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            PieceworkSetup.GET();
            CostDatabase.GET(NoCostDatabase);

            IF (CostDatabase."UO Red. Qty" = 0) THEN BEGIN
                SetDecimales(opcDecCargar::"Usar los de Presto");
                opcPorcCost := PieceworkSetup."Default Porcentual Cost";
                opcPorcSales := PieceworkSetup."Default Porcentual Sales";
            END ELSE BEGIN
                opcDecUOCan := CostDatabase.GetPrecision(0);
                opcDecUOPre := CostDatabase.GetPrecision(1);
                opcDecUOImp := CostDatabase.GetPrecision(2);
                opcDecDesCan := CostDatabase.GetPrecision(3);
                opcDecDesPre := CostDatabase.GetPrecision(4);
                opcDecDesImp := CostDatabase.GetPrecision(5);
                opcPorcCost := CostDatabase."Porcentual Cost";
                opcPorcSales := CostDatabase."Porcentual Sales";
            END;
            opcMedicionIgual := TRUE;
        END;


    }
    labels
    {
    }

    var
        //       QuoBuildingSetup@1100286013 :
        QuoBuildingSetup: Record 7207278;
        //       PieceworkSetup@1100286002 :
        PieceworkSetup: Record 7207279;
        //       CostDatabase@1100286036 :
        CostDatabase: Record 7207271;
        //       FileManagement@1100286024 :
        FileManagement: Codeunit 419;
        FileManagement2: Codeunit "File Management 1";
        //       QBCostDatabase@1100286016 :
        QBCostDatabase: Codeunit 7206986;
        //       Window@1100286035 :
        Window: Dialog;
        //       FileArchivePRESTO@1100286070 :
        FileArchivePRESTO: File;
        //       text50001@7001112 :
        text50001: TextConst ENU = 'The process has stopped', ESP = 'Se ha detenido el proceso';
        //       text50000@7001111 :
        text50000: TextConst ENU = 'We will look for information about the price% 1 already imported. if it exists, it will be erased. Do you wish to continue?', ESP = 'El preciario %1 ya tiene informaci¢n importada, se borrar  antes de cargar la nueva. ¨Desea continuar?';
        //       text50002@1100286001 :
        text50002: TextConst ENU = 'Make sure that you have properly filled in the name of the two files of the Cost Dabase', ESP = 'Asegurese de haber rellenado adecuadamente el nombre del o de los ficheros a cargar';
        //       text50004@1100286003 :
        text50004: TextConst ENU = 'Make sure that you have properly filled in the name of the two files of the Cost Dabase', ESP = 'No ha indicado preciario de %1, ¨desea usar el mismo que el de %2?';
        //       Campos@1100286072 :
        Campos: ARRAY[20] OF Text;
        //       NoCostDatabase@7001113 :
        NoCostDatabase: Code[20];
        //       VLextChar@7001128 :
        VLextChar: Char;
        //       FileLineNo@7001129 :
        FileLineNo: Integer;
        //       VAuxNoLine@7001157 :
        VAuxNoLine: Integer;
        //       Text103@1100286081 :
        Text103: TextConst ESP = 'No ha marcado importar coste ni venta, proceso cancelado';
        //       Text031@7001176 :
        Text031: TextConst ENU = 'Import from Text File', ESP = 'Importar de fichero BC3 de costes';
        //       Text032@7001175 :
        Text032: TextConst ENU = 'Import from Text File BC3 the sale', ESP = 'Importar de fichero BC3 de venta';
        //       Text035@7001177 :
        Text035: TextConst ENU = 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*', ESP = 'Archivos BC3 (*.BC3)|*.BC3l|Archivos txt (*.txt)|*.TXT';
        //       Text006@7001195 :
        Text006: TextConst ENU = 'Document Import', ESP = 'Importar documento';
        //       Text000@7001197 :
        Text000: TextConst ENU = 'Failed to open file: %1', ESP = 'No se ha podido abrir el archivo: %1';
        //       Text001a@1100286040 :
        Text001a: TextConst ENU = 'Processing line #1###########################', ESP = '"    Paso: #1#####################################################################################################################"';
        //       Text001b@1100286061 :
        Text001b: TextConst ENU = 'Processing line #1###########################', ESP = 'Proceso: #2#####################################################################################################################';
        //       Text001c@1100286039 :
        Text001c: TextConst ENU = 'Processing line #1###########################', ESP = '"  Unidad: #3#####################################################################################################################"';
        //       Text002@7001199 :
        Text002: TextConst ENU = 'The data associated with\', ESP = 'Se borrar n los datos asociados al\';
        //       Text003@7001200 :
        Text003: TextConst ENU = 'Cost Database %1, dated %2\', ESP = 'Preciario %1, con fecha %2\';
        //       Text004@7001201 :
        Text004: TextConst ENU = 'loaded from the file: %3\', ESP = 'cargados desde el fichero: %3\';
        //       Text005@7001202 :
        Text005: TextConst ENU = 'Do you wish to continue?', ESP = '¨Desea continuar?';
        //       Text007@7001203 :
        Text007: TextConst ENU = 'NODO TREE', ESP = 'Montando datos';
        //       Text008@7001204 :
        Text008: TextConst ENU = 'Presto->', ESP = 'Presto->';
        //       Text010@7001205 :
        Text010: TextConst ENU = 'Recalculating Percentages', ESP = '"Recalculando Porcentajes "';
        //       RolType@1100286004 :
        RolType: Option "Root","Cap","Part","Sub","Des";
        //       "---------------------------------- Datos constantes"@1100286008 :
        "---------------------------------- Datos constantes": Integer;
        //       OPTConcept@1100286009 :
        OPTConcept: Option " ","Unclassified","Resource","item","Equipament","Measure";
        //       OPTTipoDeCarga@1100286000 :
        OPTTipoDeCarga: Option "Ambos","Coste","Venta";
        //       VCHAR13@1100286007 :
        VCHAR13: Text[1];
        //       VCHAR10@1100286006 :
        VCHAR10: Text[1];
        //       "------------------------------------ Datos que vamos leyendo del fichero"@1100286018 :
        "------------------------------------ Datos que vamos leyendo del fichero": Text;
        //       VAuxHeaderLine@1100286005 :
        VAuxHeaderLine: Text[10];
        //       VAuxCode@1100286054 :
        VAuxCode: Text;
        //       VAuxDescriptionShort@1100286053 :
        VAuxDescriptionShort: Text;
        //       VAuxDescriptionLong@1100286052 :
        VAuxDescriptionLong: Text;
        //       VAuxAmount@1100286051 :
        VAuxAmount: Text;
        //       VAuxUnitofMeasure@1100286050 :
        VAuxUnitofMeasure: Text;
        //       VAuxUnitBillofItem@1100286049 :
        VAuxUnitBillofItem: Text;
        //       VAuxQuantityBillofItem@1100286048 :
        VAuxQuantityBillofItem: Text;
        //       VAuxCodeBillofItem@1100286047 :
        VAuxCodeBillofItem: Text;
        //       VAuxUnits@1100286046 :
        VAuxUnits: Text;
        //       VAuxLenght@1100286045 :
        VAuxLenght: Text;
        //       VAuxWidth@1100286044 :
        VAuxWidth: Text;
        //       VAuxHeight@1100286043 :
        VAuxHeight: Text;
        //       VAuxMedTotal@1100286084 :
        VAuxMedTotal: Text;
        //       VAuxMedPosition@1100286085 :
        VAuxMedPosition: Text;
        //       VarAuxConcept@1100286021 :
        VarAuxConcept: Text[3];
        //       VCI@1100286010 :
        VCI: Decimal;
        //       "------------------------ Opciones"@1100286055 :
        "------------------------ Opciones": Integer;
        //       opcNameFileSales@1100286057 :
        opcNameFileSales: Text[250];
        //       opcNameFileCost@1100286056 :
        opcNameFileCost: Text[250];
        //       opcInsertBillofItemCost@1100286059 :
        opcInsertBillofItemCost: Boolean;
        //       opcInsertBillofItemSales@1100286060 :
        opcInsertBillofItemSales: Boolean;
        //       opcInsertMeditionCost@1100286020 :
        opcInsertMeditionCost: Boolean;
        //       opcInsertMeditionSales@1100286019 :
        opcInsertMeditionSales: Boolean;
        //       opcAccountGreater@1100286023 :
        opcAccountGreater: Code[20];
        //       opcReplaceDescriptions@1100286062 :
        opcReplaceDescriptions: Boolean;
        //       Text020@1100286063 :
        Text020: TextConst ESP = 'No ha definido el C.A. para %1 en configuraci¢n de unidades de obra';
        //       Text012@1100286064 :
        Text012: TextConst ESP = 'Proceso finalizado';
        //       opcDecUOCan@1100286075 :
        opcDecUOCan: Decimal;
        //       opcDecUOPre@1100286074 :
        opcDecUOPre: Decimal;
        //       opcDecUOImp@1100286073 :
        opcDecUOImp: Decimal;
        //       opcDecDesCan@1100286065 :
        opcDecDesCan: Decimal;
        //       opcDecDesPre@1100286066 :
        opcDecDesPre: Decimal;
        //       opcDecDesImp@1100286067 :
        opcDecDesImp: Decimal;
        //       opcDecCargar@1100286068 :
        opcDecCargar: Option "Usar los actuales","Cargar del fichero","Usar los de Presto","Usar los configurados";
        //       opcAccountAgrup@1100286017 :
        opcAccountAgrup: Integer;
        //       opcAccountAgrupint@1100286032 :
        opcAccountAgrupint: Integer;
        //       opcCost@1100286076 :
        opcCost: Boolean;
        //       opcSales@1100286080 :
        opcSales: Boolean;
        //       opcMaxDif@1100286082 :
        opcMaxDif: Decimal;
        //       opcWOdescCost@1100286014 :
        opcWOdescCost: Option;
        //       opcWOdescSales@1100286012 :
        opcWOdescSales: Option;
        //       opcErrors@1100286086 :
        opcErrors: Boolean;
        //       opcPorcCost@1100286011 :
        opcPorcCost: Option "Repartir","Cargar";
        //       opcPorcSales@1100286015 :
        opcPorcSales: Option;
        //       opcSumMedCost@1100286022 :
        opcSumMedCost: Boolean;
        //       opcSumMedSale@1100286025 :
        opcSumMedSale: Boolean;
        //       UOCoste@1100286027 :
        UOCoste: Option "UO","Medicion","Nada";
        //       UOVenta@1100286026 :
        UOVenta: Option "UO","Medicion","Nada";
        //       ImpVenta@1100286028 :
        ImpVenta: Boolean;
        //       opcMedicionIgual@1100286029 :
        opcMedicionIgual: Boolean;
        //       opcSumMedCost2@1100286031 :
        opcSumMedCost2: Boolean;
        //       opcSumMedSale2@1100286030 :
        opcSumMedSale2: Boolean;



    trigger OnInitReport();
    var
        //                    TCD@1100286000 :
        TCD: Record 7207275;
    begin
        //JAV 01/03/18: Se cambian los datos por defecto fijos por los configurados
        PieceworkSetup.GET;
        opcInsertBillofItemCost := not PieceworkSetup."PRESTO Skip Cost";
        opcInsertBillofItemSales := not PieceworkSetup."PRESTO Skip Sales";
        opcInsertMeditionCost := not PieceworkSetup."Skip Cost Meditions";
        opcInsertMeditionSales := not PieceworkSetup."Skip Sales Meditions";
        opcAccountGreater := '01';
        opcAccountAgrup := 2;
        opcAccountAgrupint := 2;
        opcCost := TRUE;
        opcSales := TRUE;
        opcMaxDif := PieceworkSetup."Minimum difference for notice";
        opcWOdescCost := PieceworkSetup."Default Cost Without Decom.";
        opcWOdescSales := PieceworkSetup."Default Sales Without Decom.";
        opcErrors := TRUE;
    end;

    trigger OnPreReport();
    var
        //                   Piecework@1100286000 :
        Piecework: Record 7207277;
        //                   BillofItemData@1100286001 :
        BillofItemData: Record 7207384;
        //                   Primero@1100286002 :
        Primero: Boolean;
    begin
        VCHAR13[1] := 13;
        VCHAR10[1] := 10;
        PieceworkSetup.GET();
        PieceworkSetup.TESTFIELD("G.C. Resource PRESTO");
        PieceworkSetup.TESTFIELD("G.C. Item PRESTO");
        PieceworkSetup.TESTFIELD("G.C. Stock PRESTO");
        QuoBuildingSetup.GET;

        //JAV 01/03/19: Se verifica que tenga nombres de ficheros antes de empezar el proceso, no tras eliminar datos,
        if (not opcCost) and (not opcSales) then
            ERROR(Text103);

        if (opcNameFileSales = '') and (opcNameFileCost = '') then
            ERROR(text50002);

        //JAV 01/03/19: Si falta uno de los ficheros se pregunta si usar el mismo del otro y verificar que ambos existen
        if (not opcCost) then
            opcNameFileCost := ''
        else if (opcNameFileCost = '') then
            if CONFIRM(text50004, TRUE, 'coste', 'venta') then
                opcNameFileCost := opcNameFileSales
            else
                ERROR('');

        if (not opcSales) then
            opcNameFileSales := ''
        else if (opcNameFileSales = '') then
            if CONFIRM(text50004, TRUE, 'venta', 'coste') then
                opcNameFileSales := opcNameFileCost
            else
                ERROR('');

        if (opcNameFileSales = '') and (opcNameFileCost = '') then
            ERROR(text50002);

        //JAV 01/03/19 : Solo pregunta sobre borrar si ya tiene datos
        Piecework.RESET();
        Piecework.SETCURRENTKEY(Piecework."Cost Database Default");
        Piecework.SETRANGE(Piecework."Cost Database Default", NoCostDatabase);
        if not Piecework.ISEMPTY then
            if not CONFIRM(text50000, FALSE, NoCostDatabase) then
                ERROR(text50001);
        //JAV --


        Window.OPEN(Text001a + '\' + Text001b + '\' + Text001c);

        //Limpio el fichero por si tiene datos que puedan afectarme
        Window.UPDATE(1, 'Preparando datos');
        Window.UPDATE(2, '');
        Window.UPDATE(3, '');

        //JAV 23/11/20: - QB 1.07.06 Se usa la nueva funci¢n en la tabla para borrar los datos
        CostDatabase.DeleteData(NoCostDatabase);

        //Actualizar el registro del preciario
        CostDatabase.GET(NoCostDatabase);

        if (opcInsertBillofItemCost) and (opcInsertBillofItemSales) then
            CostDatabase."Type Unit" := CostDatabase."Type Unit"::CostSale
        else if (opcInsertBillofItemCost) then
            CostDatabase."Type Unit" := CostDatabase."Type Unit"::Cost
        else if (opcInsertBillofItemSales) then
            CostDatabase."Type Unit" := CostDatabase."Type Unit"::Sale;

        CostDatabase."UO Red. Qty" := opcDecUOCan;
        CostDatabase."UO Red. Price" := opcDecUOPre;
        CostDatabase."UO Red. Amount" := opcDecUOImp;
        CostDatabase."Des Red. Qty" := opcDecDesCan;
        CostDatabase."Des Red. Price" := opcDecDesPre;
        CostDatabase."Des Red. Amount" := opcDecDesImp;

        CostDatabase."CI Cost" := 0;                //Dejamos a cero los CI para empezar
        CostDatabase."CI Sales" := 0;
        CostDatabase.Version := 1;                //Se ha cargado en versi¢n 1, por tanto tenemos precios base y totales de descompuestos
        CostDatabase.MODIFY;

        //-------------------------------------------------------------------------------------------------------------------
        // Cargar el fichero BC3 en la tabla auxiliar y procesarlo
        //-------------------------------------------------------------------------------------------------------------------
        //Primero leo y proceso el de costes, si es el mismo que el de venta procesamos a la vez
        Primero := TRUE;
        if (opcCost) then begin
            Window.UPDATE(1, 'Cargando fichero coste');
            ReadFile(opcNameFileCost);
            if (not opcSales) or (opcNameFileCost <> opcNameFileSales) then  //Si no cargamos ventas o no es el mismo fichero, cargar solo coste. Si no cargar ambos a la vez.
                Cargar_Datos(OPTTipoDeCarga::Coste, Primero)
            else
                Cargar_Datos(OPTTipoDeCarga::Ambos, Primero);
        end;

        //Ahora proceso el de venta si es diferente al de coste
        if (opcSales) then begin
            Window.UPDATE(1, 'Cargando fichero venta');
            if (not opcCost) or (opcNameFileCost <> opcNameFileSales) then begin    //Si no cargamos coste debemos hacerlo con ventas, y siempre cargamos si el fichero es diferente en coste y venta
                ImpVenta := TRUE;
                ReadFile(opcNameFileSales);
                Cargar_Datos(OPTTipoDeCarga::Venta, Primero);
            end;
        end;

        Window.CLOSE;

        //-----------------------------------
        //A¤adir un descompuesto a las partidas que no lo tengan
        if (opcWOdescCost <> PieceworkSetup."Default Cost Without Decom."::None) then
            QBCostDatabase.CD_Partidas(CostDatabase, BillofItemData.Use::Cost, opcWOdescCost);
        if (opcWOdescSales <> PieceworkSetup."Default Sales Without Decom."::None) then
            QBCostDatabase.CD_Partidas(CostDatabase, BillofItemData.Use::Sales, opcWOdescSales);

        //Calculando para que todo tenga bien sus importes
        CostDatabase.GET(NoCostDatabase);
        QBCostDatabase.CD_CalculateAll(CostDatabase, TRUE);

        //Repartir los porcentuales
        QBCostDatabase.CD_DistributePercentaje(CostDatabase, BillofItemData.Use::Cost, opcPorcCost);
        QBCostDatabase.CD_DistributePercentaje(CostDatabase, BillofItemData.Use::Sales, opcPorcSales);

        //-Q18285 AML 22/3/23 Traspasar el factor diferente de 1 en UO
        QBCostDatabase.CD_FactorPartidas(CostDatabase);
        //+Q18285
        //-Q18285 AML 22/3/23 Marcas opcSumMedCost y opcSumMedSale Si manda la medicion de la UO o del descompuesto
        if opcSales then QBCostDatabase.CD_IgualarMed(CostDatabase.Code, UOCoste, opcInsertMeditionCost);
        QBCostDatabase.CD_Medicion(CostDatabase.Code, UOCoste, UOVenta, opcCost, opcMedicionIgual, opcInsertMeditionCost, opcInsertMeditionSales);
        if opcSumMedCost then QBCostDatabase.CD_PartidasDif(CostDatabase, BillofItemData.Use::Cost, opcInsertBillofItemCost, opcSumMedCost2, opcAccountGreater);
        if opcSumMedSale then QBCostDatabase.CD_PartidasDif(CostDatabase, BillofItemData.Use::Sales, opcInsertBillofItemSales, opcSumMedSale2, opcAccountGreater);
        //+Q18285

        //Revisi¢n final
        QBCostDatabase.CD_ClearErrors(CostDatabase);
        if (opcErrors) then
            QBCostDatabase.CD_ReviseAll(CostDatabase, opcMaxDif);

        //Si no hay errores mensaje de final. Volvemos a leer el registro porque lo ha cambiado lo anterior
        CostDatabase.GET(NoCostDatabase);
        if (CostDatabase."Errors Header No." + CostDatabase."Errors Desc No." = 0) then
            MESSAGE(Text012);
    end;



    LOCAL procedure "------------------------- Par metros que le pasamos al report"()
    begin
    end;

    //     procedure SetNoCostDatabase (pCode@1100286000 :
    procedure SetNoCostDatabase(pCode: Code[20])
    begin
        NoCostDatabase := pCode;
    end;

    LOCAL procedure "------------------------ Lectura y proceso del fichero BC3"()
    begin
    end;

    //     LOCAL procedure ReadFile (pFile@1100286000 :
    LOCAL procedure ReadFile(pFile: Text)
    var
        //       TCD@1100286001 :
        TCD: Record 7207275;
        //       i@1100286002 :
        i: Integer;
        //       LineaLeida@1100286004 :
        LineaLeida: Text;
        //       AntChars@1100286003 :
        AntChars: Text[2];
    begin
        Window.UPDATE(2, 'Leyendo fichero');

        //Pongo el coeficiente de CI a cero para poder leerlo del fichero
        VCI := 0;

        //Limpio el fichero por si hay datos anteriores por seguridad, aunque no deben existir por lo que no har  nada
        TCD.RESET;
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.DELETEALL;

        if (pFile = '') then
            exit;

        if ISSERVICETIER then
            ReadFromFile(pFile);
        FileArchivePRESTO.TEXTMODE(FALSE);
        if not FileArchivePRESTO.OPEN(pFile, TEXTENCODING::Windows) then
            ERROR(Text000, pFile);

        AntChars := '  ';
        LineaLeida := '';
        FileLineNo := 0;
        WHILE FileArchivePRESTO.READ(VLextChar) <> 0 DO begin
            if (VLextChar <> 10) and (VLextChar <> 13) and (VLextChar <> 9) and (VLextChar < 32) then begin  //JAV 27/09/21: - QB 1.09.20 Se incluye el tabulador como caracter v lido
                i := VLextChar;
                ERROR('Car cter no v lido en l¡nea %1: [%2]. Leido hasta el momento %3', FileLineNo, i, LineaLeida);
            end;

            //Si hay un CRLF, cuento una l¡nea mas y miro si es inicio de registro, si es as¡ monto el anterior
            if ((AntChars[1] = 10) and (AntChars[2] = 13)) or ((AntChars[1] = 13) and (AntChars[2] = 10)) then begin
                FileLineNo += 1;
                Window.UPDATE(3, 'L¡nea ' + FORMAT(FileLineNo));
                //AML
                if FileLineNo = 8 then begin
                    FileLineNo := FileLineNo;
                end;
                //AML
                if (VLextChar = '~') then begin
                    //Quito el CRLF o LFCR finales
                    //AML
                    if COPYSTR(LineaLeida, 1, 2) = '~M' then begin
                        LineaLeida := LineaLeida;
                    end;
                    //AML
                    LineaLeida := DELCHR(LineaLeida, '>', VCHAR13);
                    LineaLeida := DELCHR(LineaLeida, '>', VCHAR10);
                    LineaLeida := DELCHR(LineaLeida, '>', VCHAR13);
                    LineaLeida := DELCHR(LineaLeida, '>', '~TC');
                    //if LineaLeida = '~TC' then LineaLeida := '';
                    //Proceso la l¡nea
                    if LineaLeida <> '' then Procesar(LineaLeida);
                    LineaLeida := '';
                end;
            end;

            LineaLeida += ConversAccents(FORMAT(VLextChar));
            AntChars[1] := AntChars[2];
            AntChars[2] := VLextChar;
        end;

        //JAV 28/11/22: - QB 1.12.24 Si queda algo en el buffer lo tengo que procesar
        //-Q19780
        LineaLeida := DELCHR(LineaLeida, '>', '~TC'); //AML Esta l¡nea da error si la ultima l¡nea es ~C. Por el momento se comenta.
                                                      //+Q19780
        if (LineaLeida <> '') then
            Procesar(LineaLeida);

        FileArchivePRESTO.CLOSE();
        COMMIT;
    end;

    //     LOCAL procedure Procesar (Linea@1100286000 :
    LOCAL procedure Procesar(Linea: Text)
    begin
        VAuxHeaderLine := '';
        VAuxCode := '';
        VAuxDescriptionShort := '';
        VAuxDescriptionLong := '';
        VAuxAmount := '';
        VAuxUnitofMeasure := '';
        VAuxUnitBillofItem := '';
        VAuxQuantityBillofItem := '';
        VAuxCodeBillofItem := '';
        VAuxUnits := '';
        VAuxLenght := '';
        VAuxWidth := '';
        VAuxHeight := '';
        VAuxMedPosition := '';
        VarAuxConcept := '';
        Split(Campos, Linea, '|');

        CASE COPYSTR(Campos[1], 2, 1) OF
            'V':
                ; //No lo tratamos, es el registro que indica TIPO de PROPIEDAD Y VERSION
            'K':
                Reg_Coeficientes(Campos[1], Campos[2], Campos[3], Campos[4]);
            'C':
                Reg_Concept(Campos[1], Campos[2], Campos[3], Campos[4], Campos[5], Campos[6], Campos[7]);
            'D':
                Reg_BillofItem(Campos[1], Campos[2], Campos[3], Campos[4]);
            'T':
                Reg_DescriptionLong(Campos[1], Campos[2], Campos[3]);
            'M':
                Reg_LineMeasure(Campos[1], Campos[2], Campos[3], Campos[4], Campos[5], Campos[6]);
        //else  ERROR('Se ha leido un registro de tipo %1 que no est  contemplado en este proceso', COPYSTR(Linea,1,2));
        end;
    end;

    //     LOCAL procedure Split (var pCampos@1100286004 : ARRAY [10] OF Text;pTexto@1100286000 : Text;pSeparador@1100286001 :
    LOCAL procedure Split(var pCampos: ARRAY[10] OF Text; pTexto: Text; pSeparador: Text[1])
    var
        //       Pos@1100286002 :
        Pos: Integer;
        //       Nro@1100286003 :
        Nro: Integer;
    begin
        // pCampos   : Campos separados
        // pTexto    : Texto del que separar en tokens
        // pSeparador: Separador a usar

        SplitNro(pCampos, pTexto, pSeparador, ARRAYLEN(pCampos));
    end;

    //     LOCAL procedure SplitNro (var pCampos@1100286004 : ARRAY [10] OF Text;var pTexto@1100286000 : Text;pSeparador@1100286001 : Text[1];pNro@1100286005 :
    LOCAL procedure SplitNro(var pCampos: ARRAY[10] OF Text; var pTexto: Text; pSeparador: Text[1]; pNro: Integer)
    var
        //       Pos@1100286002 :
        Pos: Integer;
        //       Nro@1100286003 :
        Nro: Integer;
    begin
        // pCampos   : Campos separados
        // pTexto    : Texto del que separar en tokens
        // pSeparador: Separador a usar
        // pNro      : Nro m ximo de campos a separar

        CLEAR(pCampos);
        Nro := 1;
        repeat
            Pos := STRPOS(pTexto, pSeparador);
            if Pos > 0 then begin
                pCampos[Nro] := COPYSTR(pTexto, 1, Pos - 1);
                if Pos + 1 <= STRLEN(pTexto) then
                    pTexto := COPYSTR(pTexto, Pos + 1)
                else
                    pTexto := '';
            end else begin
                pCampos[Nro] := pTexto;
                pTexto := '';
            end;
            Nro += 1;
        until (pTexto = '') or (Nro > pNro);
    end;

    //     LOCAL procedure Txt2Dec (pTxt@1100286000 :
    LOCAL procedure Txt2Dec(pTxt: Text): Decimal;
    var
        //       tAux@1100286001 :
        tAux: Text;
        //       tMantisa@1100286005 :
        tMantisa: Text;
        //       dMantisa@1100286004 :
        dMantisa: Decimal;
        //       tExponente@1100286006 :
        tExponente: Text;
        //       dExponente@1100286003 :
        dExponente: Decimal;
        //       dAux@1100286002 :
        dAux: Decimal;
        //       i@1100286007 :
        i: Integer;
    begin
        // Convierte una cadena de texto con un n£mero en formato americano de puntos y comas a un valor num‚rico
        if (pTxt = '') then
            exit(0);

        tAux := DELCHR(pTxt, '=', ',');      //Elimino las comas que son los separadores de miles, si las hay
        tAux := CONVERTSTR(tAux, '.', ',');  //Cambio puntos por la coma decimal

        i := STRPOS(tAux, 'E-');            //Si est  en formato cient¡fico
        if (i <> 0) then begin
            tMantisa := COPYSTR(tAux, 1, i - 1);
            tExponente := COPYSTR(tAux, i + 2);

            EVALUATE(dMantisa, tMantisa);
            EVALUATE(dExponente, tExponente);
            dAux := dMantisa / POWER(10, dExponente);
        end else begin
            if (not EVALUATE(dAux, tAux)) then
                dAux := 0;
        end;

        exit(dAux);
    end;

    //     procedure Reg_Concept (pHeader@1100286006 : Text;pCodigo@1100286000 : Text;pUnidad@1100286001 : Text;pResumen@1100286002 : Text;pPrecio@1100286003 : Text;pFecha@1100286004 : Text;pTipo@1100286005 :
    procedure Reg_Concept(pHeader: Text; pCodigo: Text; pUnidad: Text; pResumen: Text; pPrecio: Text; pFecha: Text; pTipo: Text)
    begin
        VAuxHeaderLine := pHeader;

        VAuxCode := DELCHR(pCodigo, '>', '\');
        VAuxUnitofMeasure := pUnidad;
        VAuxDescriptionShort := pResumen;
        VAuxAmount := DELCHR(pPrecio, '>', '\');
        CASE pTipo OF
            '0':
                OPTConcept := OPTConcept::Unclassified;
            '1':
                OPTConcept := OPTConcept::Resource;
            '2':
                OPTConcept := OPTConcept::Equipament;
            '3':
                OPTConcept := OPTConcept::item
            else begin                                               //Si se usan letras, ver anexo 4 del FIELDBDC
                CASE COPYSTR(pTipo, 1, 1) OF
                    'H':
                        OPTConcept := OPTConcept::Resource;
                    'Q':
                        OPTConcept := OPTConcept::Equipament;
                    'M', 'E', 'O', 'P':
                        OPTConcept := OPTConcept::item;
                    else
                        OPTConcept := OPTConcept::Unclassified;
                end;
            end;
        end;
        //AML
        VarAuxConcept := pTipo;
        //AML‡
        RecordTAuxPresto();
    end;

    //     procedure Reg_BillofItem (pHeader@1100286004 : Text;pPadre@1000000000 : Text;pCampo2@1000000001 : Text;pCampo3@1100286000 :
    procedure Reg_BillofItem(pHeader: Text; pPadre: Text; pCampo2: Text; pCampo3: Text)
    var
        //       Campos@1100286001 :
        Campos: ARRAY[20] OF Text;
        //       Texto@1100286002 :
        Texto: Text;
        //       p@1100286003 :
        p: Integer;
    begin
        VAuxHeaderLine := pHeader;
        if (pCampo3 <> '') then
            Texto := pCampo3
        else
            Texto := pCampo2;

        repeat
            SplitNro(Campos, Texto, '\', 3);
            VAuxCode := pPadre;
            VAuxCodeBillofItem := Campos[1];
            VAuxUnitBillofItem := Campos[2];
            VAuxQuantityBillofItem := Campos[3];

            RecordTAuxPresto();
        until (Texto = '');
    end;

    //     procedure Reg_DescriptionLong (pHeader@1100286000 : Text;pCodigo@1000000000 : Text;pTexto@1000000001 :
    procedure Reg_DescriptionLong(pHeader: Text; pCodigo: Text; pTexto: Text)
    var
        //       len1@1100286001 :
        len1: Integer;
        //       len2@1100286002 :
        len2: Integer;
    begin
        //Quito espacios o CR y LF finales, repito hasta que dos veces tengan la misma longitud
        repeat
            len1 := STRLEN(pTexto);
            pTexto := DELCHR(pTexto, '>');
            pTexto := DELCHR(pTexto, '>', VCHAR13);
            pTexto := DELCHR(pTexto, '>', VCHAR10);
            len2 := STRLEN(pTexto);
        until (len1 = len2);

        VAuxHeaderLine := pHeader;
        if STRLEN(VAuxHeaderLine) > 2 then exit;
        VAuxCode := pCodigo;
        VAuxDescriptionLong := pTexto;
        RecordTAuxPresto();
    end;

    //     procedure Reg_LineMeasure (pHeader@1100286004 : Text;pCodigo@1100229001 : Text;pPosicion@1100229000 : Text;pMedidionTotal@1100286000 : Text;pDatos@1100286001 : Text;pEtiqueta@1100286002 :
    procedure Reg_LineMeasure(pHeader: Text; pCodigo: Text; pPosicion: Text; pMedidionTotal: Text; pDatos: Text; pEtiqueta: Text)
    var
        //       Campos@1100286003 :
        Campos: ARRAY[20] OF Text;
        //       Aux1@1100286005 :
        Aux1: Decimal;
        //       Aux2@1100286006 :
        Aux2: Decimal;
    begin
        VAuxHeaderLine := pHeader;
        Split(Campos, pCodigo, '\');
        VAuxCode := Campos[2];
        VAuxCodeBillofItem := Campos[1];
        VAuxMedTotal := pMedidionTotal;
        //AML
        if UPPERCASE(VAuxCode) = '07.01V1V1' then begin
            VAuxCode := VAuxCode;
        end;
        if VAuxCodeBillofItem = '07.01V1V1' then begin
            VAuxCode := VAuxCode;
        end;
        //AML
        //Buscar la posici¢n en el fichero, saco de uno en uno y pongo los ceros por delante necesarios
        VAuxMedPosition := '';
        repeat
            SplitNro(Campos, pPosicion, '\', 1);
            Campos[1] := DELCHR(Campos[1], '<>', ' ');
            if (Campos[1] = '') then
                pPosicion := ''
            else begin
                if (STRLEN(Campos[1]) < opcAccountAgrup) then
                    VAuxMedPosition += PADSTR('', opcAccountAgrup - STRLEN(Campos[1]), '0') + Campos[1]
                else if (STRLEN(Campos[1]) = opcAccountAgrup) then
                    VAuxMedPosition += Campos[1]
                else
                    ERROR('En la unidad %1/%2 el c¢digo de posici¢n desborda la posibilidad configurada', VAuxCodeBillofItem, VAuxCode);
            end;
        until (pPosicion = '');

        //Las mediciones en s¡
        repeat
            SplitNro(Campos, pDatos, '\', 6);
            VAuxDescriptionShort := Campos[2];
            VAuxUnits := Campos[3];
            VAuxLenght := Campos[4];
            VAuxWidth := Campos[5];
            VAuxHeight := Campos[6];

            //JAV 16/11/22: - QB 1.12.19 A¤adido el manejo de los tipos de l¡nea en las mediciones
            if (Campos[1] = '3') then begin
                Aux1 := Txt2Dec(Campos[2]);
                if (Aux1 = 0) then
                    Aux1 := 1;
                Aux2 := Txt2Dec(Campos[3]);
                if (Aux2 = 0) then
                    Aux2 := 1;
                Aux1 := ABS(Aux1);
                Aux2 := ABS(Aux2);
                //VAuxUnits := FORMAT(Aux1 * Aux2);
                VAuxUnits := FORMAT(Aux1);
                VAuxUnits := CONVERTSTR(VAuxUnits, ',', '.');  //Esperamos que el separador sea el punto, no la coma
                                                               //-Q18285
                VAuxLenght := '1';
                VAuxWidth := '1';
                VAuxHeight := '1';
                //+Q18285
            end;

            RecordTAuxPresto();
        until (pDatos = '');
    end;

    //     procedure Reg_Coeficientes (pHeader@1100286004 : Text;pRedondeos@1100229001 : Text;pCoeficientes@1100229000 : Text;pDivisas@1100286000 :
    procedure Reg_Coeficientes(pHeader: Text; pRedondeos: Text; pCoeficientes: Text; pDivisas: Text)
    var
        //       Campos@1100286003 :
        Campos: ARRAY[20] OF Text;
        //       i@1100286005 :
        i: Integer;
    begin
        //JAV 03/12/22: - QB 1.12.24 Procesar el registro de Coeficientes

        SplitNro(Campos, pCoeficientes, '\', 5);
        VCI := Txt2Dec(Campos[1]);
    end;

    procedure RecordTAuxPresto()
    var
        //       TCD@1100286000 :
        TCD: Record 7207275;
        //       TempBlob@1100286001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OUtSTream;
        InStr: InStream;
        //       LPartDecimal@1100240004 :
        LPartDecimal: Text[30];
        //       LExponent@1100240003 :
        LExponent: Text[30];
        //       LDExponent@1100240002 :
        LDExponent: Decimal;
        //       LDDivider@1100240001 :
        LDDivider: Decimal;
        //       LDDividend@1100240000 :
        LDDividend: Decimal;
        //       TCD2@1100286002 :
        TCD2: Record 7207275;
        //       Largo@1100286003 :
        Largo: Decimal;
        //       Ancho@1100286004 :
        Ancho: Decimal;
        //       Alto@1100286005 :
        Alto: Decimal;
    begin
        // Guardar el regitro en el fichero auxiliar

        TCD.RESET;
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        if TCD.FINDLAST then
            VAuxNoLine := TCD."Line No." + 1
        else
            VAuxNoLine := 1;

        TCD.INIT;
        TCD."Session No." := SESSIONID;
        TCD."Cost Database Code" := NoCostDatabase;
        TCD."Line No." := VAuxNoLine;
        TCD."Header Line" := VAuxHeaderLine;
        //TCD.Code := COPYSTR(UPPERCASE(VAuxCode), 1, MAXSTRLEN(TCD.Code));
        TCD."Small Description" := COPYSTR(VAuxDescriptionShort, 1, MAXSTRLEN(TCD."Small Description"));
        TCD."Unit of Meansure" := COPYSTR(VAuxUnitofMeasure, 1, MAXSTRLEN(TCD."Unit of Meansure"));
        //TCD."Bill of Item Code" := COPYSTR(UPPERCASE(VAuxCodeBillofItem), 1, MAXSTRLEN(TCD."Bill of Item Code"));
        TCD."Concept Type" := OPTConcept;
        TCD."Guardar Concept Type" := VarAuxConcept;
        TCD."File Line" := FileLineNo;  //L¡nea f¡sica del fichero

        //Quito espacios inicial y final y guardo tal cual est  con sus may£sculas y min£sculas
        VAuxCode := DELCHR(VAuxCode, '<>', ' ');
        TCD.Code := COPYSTR(VAuxCode, 1, MAXSTRLEN(TCD.Code));
        //+Q18285 AML 27/03/24
        if TCD."Header Line" = '~C' then begin
            TCD2.SETRANGE("Session No.", TCD."Session No.");
            TCD2.SETRANGE("Cost Database Code", TCD."Cost Database Code");
            TCD2.SETRANGE("Header Line", TCD."Header Line");
            TCD2.SETRANGE(Code, TCD.Code);
            if TCD2.FINDFIRST then ERROR('Detectado Codigo presto repetido %1', TCD.Code);
        end;
        TCD."Bill of Item Code" := COPYSTR(VAuxCodeBillofItem, 1, MAXSTRLEN(TCD."Bill of Item Code"));
        if TCD.Code = 'MUROHGONV' then begin
            TCD.Code := TCD.Code;
        end;
        //Cantidades e importes
        TCD.Amount := Txt2Dec(VAuxAmount);
        TCD."Bill of Item Unit" := Txt2Dec(VAuxUnitBillofItem);
        TCD."Bill of Item Quantity" := Txt2Dec(VAuxQuantityBillofItem);

        //Mediciones
        TCD.Units := Txt2Dec(VAuxUnits);
        TCD.Length := Txt2Dec(VAuxLenght);
        TCD.Width := Txt2Dec(VAuxWidth);
        TCD.Height := Txt2Dec(VAuxHeight);

        //JAV 28/11/22: - QB 1.12.24 La medici¢n total de la partida
        TCD."Medition Total" := Txt2Dec(VAuxMedTotal);
        //-Q18285 AML 04/04/23
        if TCD."Header Line" = '~M' then begin
            if TCD.Units = 0 then begin
                if (TCD.Length <> 0) or (TCD.Width <> 0) or (TCD.Height <> 0) then begin
                    TCD.Units := 0; //Tenia 1 pero me han pedido que lo corrija. A ver cuanto tardan en pedir que lo cambie. AML 4/4/23
                end;
            end
            else begin
                if (TCD.Length = 0) and (TCD.Width = 0) and (TCD.Height = 0) then TCD.Length := 1;
            end;
            Largo := TCD.Length;
            Ancho := TCD.Width;
            Alto := TCD.Height;
            if Largo = 0 then Largo := 1;
            if Ancho = 0 then Ancho := 1;
            if Alto = 0 then Alto := 1;
            if TCD.Units <> 0 then TCD."Medition Total" := TCD.Units * Largo * Ancho * Alto else TCD."Medition Total" := 0;
        end;
        //+Q18285
        //La descripci¢n larga es un Blob con todo su contenido
        if (VAuxDescriptionLong <> '') then begin
            // TempBlob.WriteAsText(VAuxDescriptionLong, TEXTENCODING::Windows);
            /*To be tested*/

            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(VAuxDescriptionLong);
            // TCD.BlobText := TempBlob.Blob;
            /*To be tested*/

            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(TCD.BlobText);
            TCD.BlobTextLong := STRLEN(VAuxDescriptionLong);
        end;

        TCD."Mesure Position" := VAuxMedPosition;  //A¤adir la posici¢n en las l¡neas de medici¢n
                                                   //-Q18285 AML
                                                   //AML
        if DELCHR(DELCHR(TCD.Code, '=', '#'), '=', ' ') = 'FASE I' then begin
            TCD.Code := TCD.Code;
        end;
        //AML
        if STRPOS(TCD.Code, '##') <> 0 then begin
            TCD."Doble Almohadilla" := TRUE;
            TCD.Code := DELCHR(TCD.Code, '=', '##');
            TCD.Code := DELCHR(TCD.Code, '=', ' ');
            TCD.Code := TCD.Code + '##';
        end
        else begin
            if STRPOS(TCD.Code, '#') <> 0 then begin
                TCD.Almohadilla := TRUE;
                TCD.Code := DELCHR(TCD.Code, '=', '#');
                TCD.Code := DELCHR(TCD.Code, '=', ' ');
                TCD.Code := TCD.Code + '#';
            end;
            if STRPOS(TCD."Bill of Item Code", '#') <> 0 then begin
                TCD."Bill of Item Code" := DELCHR(TCD."Bill of Item Code", '=', '#');
                TCD."Bill of Item Code" := DELCHR(TCD."Bill of Item Code", '=', ' ');
                TCD."Bill of Item Code" := TCD."Bill of Item Code" + '#';
            end;
        end;
        if TCD.Code = 'FASE I' then begin
            TCD.Code := TCD.Code;
        end;
        if TCD.Code = 'FASE I#' then begin
            TCD.Code := TCD.Code;
        end;
        if COPYSTR(TCD.Code, 1, 6) = 'FASE I' then begin
            TCD.Code := TCD.Code;
        end;

        //+Q18285
        TCD.INSERT;
        COMMIT;
    end;

    LOCAL procedure "------------------------ Funciones Auxiliares"()
    begin
    end;

    //     LOCAL procedure SetDecimales (pType@1100286000 :
    LOCAL procedure SetDecimales(pType: Option)
    begin
        CASE pType OF
            opcDecCargar::"Cargar del fichero":
                begin
                    if (opcNameFileCost = '') then
                        ERROR('No ha indicado preciario de coste');

                    CargarDecimales(opcNameFileCost);
                end;
            opcDecCargar::"Usar los de Presto":
                begin
                    opcDecUOCan := 0.001;
                    opcDecUOPre := 0.01;
                    opcDecUOImp := 0.01;
                    opcDecDesCan := 0.001;
                    opcDecDesPre := 0.01;
                    opcDecDesImp := 0.01;
                end;

            opcDecCargar::"Usar los configurados":
                begin
                    //Los pongo a cero, as¡ usar  los de la configuraci¢n seguro
                    opcDecUOCan := 0;
                    opcDecUOPre := 0;
                    opcDecUOImp := 0;
                    opcDecDesCan := 0;
                    opcDecDesPre := 0;
                    opcDecDesImp := 0;
                    //Ahora ya los cargo
                    opcDecUOCan := CostDatabase.GetPrecision(0);
                    opcDecUOPre := CostDatabase.GetPrecision(1);
                    opcDecUOImp := CostDatabase.GetPrecision(2);
                    opcDecDesCan := CostDatabase.GetPrecision(3);
                    opcDecDesPre := CostDatabase.GetPrecision(4);
                    opcDecDesImp := CostDatabase.GetPrecision(5);
                end;
        end;
    end;

    //     LOCAL procedure CargarDecimales (pFile@1100286000 :
    LOCAL procedure CargarDecimales(pFile: Text)
    var
        //       salir@1100286001 :
        salir: Boolean;
        //       LineaLeida@1100286003 :
        LineaLeida: Text;
        //       IStream@1100286002 :
        IStream: InStream;
    begin
        Window.OPEN('Leyendo fichero, l¡nea #1###########');

        if ISSERVICETIER then
            ReadFromFile(pFile);

        FileArchivePRESTO.TEXTMODE(FALSE);
        if not FileArchivePRESTO.OPEN(pFile, TEXTENCODING::Windows) then
            ERROR(Text000, pFile);

        FileArchivePRESTO.CREATEINSTREAM(IStream);

        FileLineNo := 0;
        salir := FALSE;
        WHILE (not salir) and (not IStream.EOS) DO begin
            FileLineNo += 1;
            Window.UPDATE(1, 'L¡nea ' + FORMAT(FileLineNo));

            IStream.READTEXT(LineaLeida);

            //La l¡nea que buscamos
            if (COPYSTR(LineaLeida, 1, 2) = '~K') then begin
                Split(Campos, LineaLeida, '|');
                Split(Campos, Campos[4], '\');
                Reg_Decimales(Campos[1], Campos[2], Campos[3], Campos[4], Campos[5], Campos[6], Campos[7], Campos[8], Campos[9], Campos[10], Campos[11], Campos[12], Campos[13]);
                salir := TRUE;
            end;
            //Nos hemos pasado, salimos
            if (COPYSTR(LineaLeida, 1, 2) = '~C') then begin
                salir := TRUE;
                MESSAGE('No encontrada la l¡nea de decimales');
            end;
        end;

        Window.CLOSE;
        FileArchivePRESTO.CLOSE();
    end;

    //     LOCAL procedure Reg_Decimales (DRC@1100286000 : Text;DC@1100286001 : Text;DFS@1100286002 : Text;DRS@1100286003 : Text;DUO@1100286004 : Text;DI@1100286005 : Text;DES@1100286006 : Text;DN@1100286007 : Text;DD@1100286008 : Text;DS@1100286012 : Text;DSP@1100286009 : Text;DEC@1100286010 : Text;Divisa@1100286011 :
    LOCAL procedure Reg_Decimales(DRC: Text; DC: Text; DFS: Text; DRS: Text; DUO: Text; DI: Text; DES: Text; DN: Text; DD: Text; DS: Text; DSP: Text; DEC: Text; Divisa: Text)
    begin
        opcDecDesCan := Txt2Red(DRS, 2);
        opcDecDesPre := Txt2Red(DEC, 2);
        opcDecDesImp := Txt2Red(DI, 2);

        opcDecUOCan := Txt2Red(DS, 2);
        opcDecUOPre := Txt2Red(DUO, 2);
        opcDecUOImp := Txt2Red(DC, 2);
    end;

    //     procedure ConversAccents (P_Read@1000000001 : Text[1]) VarConverted@1000000000 :
    procedure ConversAccents(P_Read: Text[1]) VarConverted: Text[1];
    begin
        //Al cargar en modo Windows esto ya no es necesario
        exit(P_Read);

        //{-----------------------------------
        //
        //      CASE P_Read OF
        //        'ó': VarConverted := '¢';
        //        'ñ': VarConverted := '¤';
        //        'í': VarConverted := '¡';
        //        'á': VarConverted := ' ';
        //        'é': VarConverted := '‚';
        //        'Á': VarConverted := 'µ';
        //        'É': VarConverted := '';
        //        'Í': VarConverted := 'Ö';
        //        'Ó': VarConverted := 'à';
        //        'Ñ': VarConverted := '¥';
        //        'ú': VarConverted := '£';
        //        'Ú': VarConverted := 'é';
        //        'ª': VarConverted := '¦';
        //        'º': VarConverted := '§';
        //        'Ü': VarConverted := '';
        //        'ü': VarConverted := '';
        //
        //      //Acentos en Catal n - Inicio
        //        'ò': VarConverted := '•';
        //        'à': VarConverted := '…';
        //        '·': VarConverted := 'ú';
        //        'è': VarConverted := 'Š';
        //        'ç': VarConverted := '‡';
        //        'Ç': VarConverted := '€';
        //        'ï': VarConverted := '‹';
        //        'Ò': VarConverted := 'ã';
        //        'ï': VarConverted := ''';';
        //        'À': VarConverted := '·';
        //        '´': VarConverted := 'ï';
        //
        //      //Pendientes de rematar:
        //
        //      //-50°C y 105°C => -50§C y 105§C => Siempre viene como n£mero+°+C
        //
        //      // ACCÈS => ACCÔS
        //      //  'È':
        //      //    VarConverted := 'Ô'; // ste es el que 'È' es ya un s¡mbolo de C/AL y pide un end. Igual no tiene soluci¢n.
        //
        //      //Acentos en Catal n - Fin
        //
        //        else
        //          VarConverted := P_Read;
        //      end;
        //      -----------------------------------}
    end;

    //     LOCAL procedure Txt2Red (pTxt@1100286000 : Text;pDef@1100286008 :
    LOCAL procedure Txt2Red(pTxt: Text; pDef: Integer): Decimal;
    var
        //       n@1100286009 :
        n: Decimal;
        //       tAux@1100286001 :
        tAux: Text;
        //       tMantisa@1100286005 :
        tMantisa: Text;
        //       dMantisa@1100286004 :
        dMantisa: Decimal;
        //       tExponente@1100286006 :
        tExponente: Text;
        //       dExponente@1100286003 :
        dExponente: Decimal;
        //       dAux@1100286002 :
        dAux: Decimal;
        //       i@1100286007 :
        i: Integer;
    begin
        // Convierte una cadena de texto con un n£mero entero en un redondeo
        if (pTxt = '') then
            n := pDef
        else if not EVALUATE(n, pTxt) then
            n := 0;

        dAux := POWER(10, -n);

        exit(dAux);
    end;

    //     LOCAL procedure ReadFromFile (var FileName2@7001101 :
    LOCAL procedure ReadFromFile(var FileName2: Text[1024])
    var
        //       NewFileName@7001100 :
        NewFileName: Text[1024];
    begin
        NewFileName := FileManagement2.UploadFileSilent(FileName2);
        if NewFileName <> '' then
            FileName2 := NewFileName;
    end;

    LOCAL procedure "------------------------ Cargar Datos"()
    begin
    end;

    //     LOCAL procedure Cargar_Datos (pType@1100286003 : Option;var pPrimero@1100286004 :
    LOCAL procedure Cargar_Datos(pType: Option; var pPrimero: Boolean)
    var
        //       TCD@1100286002 :
        TCD: Record 7207275;
        //       RegAux@1100286001 :
        RegAux: Record 7207275;
        //       TempBlob@1100286006 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OUtSTream;
        InStr: INSTream;
        //       modified@1100286000 :
        modified: Integer;
        //       Raiz@1100286005 :
        Raiz: Text;
        //       Text1@1100286007 :
        Text1: Text;
        //       rBillofItemData@1100286008 :
        rBillofItemData: Record 7207384;
        //       rBillofItemData2@1100286009 :
        rBillofItemData2: Record 7207384;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        // Cargar los datos del fichero auxiliar a partir del elemento RAIZ
        //   pType...: Tipo a cargar (coste, venta, ambos)
        //   pPrimero: Si es el primer fichero que estamos cargando
        //-------------------------------------------------------------------------------------------------------------------

        Window.UPDATE(2, 'Creando datos');
        Window.UPDATE(3, '');

        //Guardar el coeficiente de indirectos que est  en el fichero
        CostDatabase.GET(NoCostDatabase);
        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then
            CostDatabase."CI Cost" := VCI;
        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta]) then
            CostDatabase."CI Sales" := VCI;
        CostDatabase.MODIFY;

        //Si no se ha indicado nada, el primer elemento es el 1
        if (opcAccountGreater = '') then
            opcAccountGreater := '1';

        opcAccountGreater := AdjustLevel(opcAccountGreater);

        //Buscamos la raiz y empezamos la carga
        TCD.RESET;
        TCD.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE("Header Line", '~C');
        TCD.SETFILTER(Code, '*' + '##');
        if (not TCD.FINDFIRST) then
            ERROR('El BC3 no dispone de un elemento raiz marcado con ##')
        else begin
            Raiz := TCD.Code;
            //Ponemos la descripci¢n si existe
            CostDatabase.GET(NoCostDatabase);
            if (CostDatabase.Description = '') then begin
                if (TCD."Small Description" <> '') then
                    CostDatabase.Description := COPYSTR(TCD."Small Description", 1, MAXSTRLEN(CostDatabase.Description))
                else begin
                    TCD.RESET;
                    TCD.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
                    TCD.SETRANGE("Session No.", SESSIONID);
                    TCD.SETRANGE("Cost Database Code", NoCostDatabase);
                    TCD.SETRANGE("Header Line", '~T');
                    TCD.SETRANGE(Code, Raiz);
                    if (TCD.FINDFIRST) then begin
                        CostDatabase.Description := COPYSTR(TCD."Small Description", 1, MAXSTRLEN(CostDatabase.Description));
                        if (TCD."Small Description" = '') and (TCD.BlobTextLong <> 0) then begin
                            TCD.CALCFIELDS(BlobText);
                            // TempBlob.Blob := TCD.BlobText;
                            /*To be tested*/

                            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                            Blob.Write(TCD.BlobText);
                            // Text1 := TempBlob.ReadAsText(VCHAR10, TEXTENCODING::Windows);
                            //Clarify VCHAR10 functionality
                            TempBlob.CreateInStream(InStr, TEXTENCODING::Windows);
                            InStr.Read(Text1);

                            CostDatabase.Description := COPYSTR(Text1, 1, MAXSTRLEN(CostDatabase.Description))
                        end;

                    end;
                end;
            end;
            CostDatabase.MODIFY;

            //Cargamos el preciario
            InsertTextAditional(pType, Raiz, '', '');                                                 //Texto para el preciario completo
            Cargar_UnDato(pType, Raiz, opcAccountGreater, RolType::Root, '', '', pPrimero);           //Cargamos los registros a partir de la raiz


        end;

        //AML Correcci¢n de Rendimientos a 0
        //{
        //      rBillofItemData.RESET;
        //      rBillofItemData.SETRANGE("Cod. Cost database",NoCostDatabase);
        //      rBillofItemData.SETRANGE(Type,rBillofItemData.Type::"Posting U.");
        //      rBillofItemData.SETRANGE("Quantity By",0);
        //      if rBillofItemData.FINDSET then begin
        //        repeat
        //
        //          //TCD.RESET;
        //          //TCD.SETCURRENTKEY("Session No.","Cost Database Code","Header Line",Code);
        //          //TCD.SETRANGE("Session No.",SESSIONID);
        //          //TCD.SETRANGE("Cost Database Code",NoCostDatabase);
        //          //TCD.SETRANGE("Header Line",'~C');
        //          //TCD.SETRANGE(Code,rBillofItemData."No.");
        //          //TCD.SETFILTER(Type,'%1|%2',TCD.Type::Item,TCD.Type::Resource);
        //          //if TCD.FINDFIRST then begin
        //
        //             if rBillofItemData."No." = '# 20.20.50' then begin
        //                 rBillofItemData."Presto Code" := rBillofItemData."Presto Code";
        //             end;
        //             rBillofItemData2.SETRANGE("Cod. Cost database",rBillofItemData."Cod. Cost database");
        //             rBillofItemData2.SETRANGE("Cod. Piecework",rBillofItemData."Cod. Piecework");
        //             rBillofItemData2.SETRANGE("Order No.",rBillofItemData."Order No."+ '01',rBillofItemData."Order No." + '99');
        //             if not rBillofItemData2.FINDFIRST then begin
        //                rBillofItemData2.GET(rBillofItemData."Cod. Cost database",rBillofItemData."Cod. Piecework",rBillofItemData."Order No.",rBillofItemData.Use,rBillofItemData.Type,rBillofItemData."No.");
        //                rBillofItemData2.VALIDATE("Quantity By",1);
        //                rBillofItemData2.MODIFY;
        //             end;
        //
        //         //end;
        //
        //        until rBillofItemData.NEXT = 0;
        //
        //
        //      end;
        //      }


        //{AML2
        //      rBillofItemData.RESET;
        //      rBillofItemData.SETRANGE("Cod. Cost database",NoCostDatabase);
        //      rBillofItemData.SETRANGE(Type,rBillofItemData.Type::"Posting U.");
        //      rBillofItemData.SETRANGE("Quantity By",0);
        //      if rBillofItemData.FINDSET then begin
        //        repeat
        //         rBillofItemData2.SETRANGE("Cod. Cost database",rBillofItemData."Cod. Cost database");
        //         rBillofItemData2.SETRANGE("Cod. Piecework",rBillofItemData."Cod. Piecework");
        //         rBillofItemData2.SETRANGE("Order No.",rBillofItemData."Order No."+ '01',rBillofItemData."Order No." + '99');
        //         if rBillofItemData2.FINDFIRST then begin
        //            TCD.RESET;
        //            TCD.SETCURRENTKEY("Session No.","Cost Database Code","Header Line",Code);
        //            TCD.SETRANGE("Session No.",SESSIONID);
        //            TCD.SETRANGE("Cost Database Code",NoCostDatabase);
        //            TCD.SETRANGE("Header Line",'~C');
        //            TCD.SETRANGE(Code,rBillofItemData."No.");
        //            if TCD.FINDFIRST then begin
        //               if TCD."Guardar Concept Type" = '3' then begin
        //                 rBillofItemData2.GET(rBillofItemData."Cod. Cost database",rBillofItemData."Cod. Piecework",rBillofItemData."Order No.",rBillofItemData.Use,rBillofItemData.Type,rBillofItemData."No.");
        //                 rBillofItemData2.VALIDATE("Quantity By",1);
        //                 rBillofItemData2.MODIFY;
        //               end;
        //            end;
        //         end;
        //        until rBillofItemData.NEXT = 0;
        //      end;
        //      }
        //Limpio el fichero para no dejar datos que no sirven para nada ya en el auxiliar
        Window.UPDATE(1, 'Limpieza final');
        Window.UPDATE(2, '');
        Window.UPDATE(3, '');
        TCD.RESET;
        TCD.SETRANGE("Session No.", SESSIONID);
        //++TCD.DELETEALL;

        //Ya hemos procesado el primer fichero
        pPrimero := FALSE;
    end;

    //     LOCAL procedure Cargar_UnDato (pType@1100286007 : Option;pPrestoCode@1100286003 : Code[20];pNumber@1100286004 : Text;pHeaderType@1100286005 : Option;pRootUnit@1100286011 : Code[20];pCadena@1100286010 : Text;pPrimero@1100286014 :
    LOCAL procedure Cargar_UnDato(pType: Option; pPrestoCode: Code[20]; pNumber: Text; pHeaderType: Option; pRootUnit: Code[20]; pCadena: Text; pPrimero: Boolean)
    var
        //       TCD@1100286001 :
        TCD: Record 7207275;
        //       RegAux@1100286000 :
        RegAux: Record 7207275;
        //       Piecework@1100286013 :
        Piecework: Record 7207277;
        //       PieceworkFather@1100286006 :
        PieceworkFather: Record 7207277;
        //       BillofItemData@1100286009 :
        BillofItemData: Record 7207384;
        //       RolLine@1100286002 :
        RolLine: Option;
        //       Type@1100286008 :
        Type: Option;
        //       txtCadena@1100286012 :
        txtCadena: Text;
        //       TreeNumber@1100286015 :
        TreeNumber: Text;
        //       FatherCode@1100286016 :
        FatherCode: Code[20];
    begin
        //-------------------------------------------------------------------------------------------------------------------
        // Marcar en los registros cargados en la tabla el Rol: Cap¡tulo, Partida, Descompuesto o SubDescompuesto
        //    pType......: Tipo Coste, Venta, Ambos
        //    pPrestoCode: C¢digo de Presto
        //    pNumber....: Nro del elemento
        //    pHeaderType: Tipo del elemento padre
        //    pRootUnit..: Unidad de la que cuelga
        //    pCadena....: Cadena de elementos para la ventana
        //    pPrimero...: Si es el primer fichero que estamos cargando
        //-------------------------------------------------------------------------------------------------------------------

        //En los registros D no se indica el #, por tanto pueden llegar con o sin la marca de cap¡tulo
        pPrestoCode := AdjustChapter(pPrestoCode);

        TCD.RESET;
        TCD.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE(Code, pPrestoCode);
        TCD.SETRANGE("Header Line", '~D');
        if (TCD.FINDSET(TRUE)) then
            repeat
                if (pCadena = '') then
                    txtCadena := TCD."Bill of Item Code"
                else
                    txtCadena := pCadena + '->' + TCD."Bill of Item Code";
                Window.UPDATE(3, txtCadena);

                TCD."Bill of Item Code" := AdjustChapter(TCD."Bill of Item Code");    //En los registros D no se indica el #, por tanto pueden llegar con o sin la marca de cap¡tulo

                if (pHeaderType = RolType::Root) then
                    RolLine := RolType::Cap  //Lo que cuelga directamente de la raiz siempre es un cap¡tulo
                else if (STRPOS(TCD."Bill of Item Code", '#') <> 0) then begin
                    if (pHeaderType <> RolType::Cap) then
                        RolLine := RolType::Sub   //Si un cap¡tulo no cuelga de otro cap¡tulo es sub-descompuesto
                    else
                        RolLine := RolType::Cap;  //Si no es un cap¡tulo
                end else begin
                    if pHeaderType = RolType::Cap then begin
                        RolLine := RolType::Part;
                        pRootUnit := pNumber;
                    end else begin
                        //Si tiene algo por debajo son subdescompuestos, si no son descompuestos directamente
                        RegAux.RESET;
                        RegAux.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
                        RegAux.SETRANGE("Session No.", SESSIONID);
                        RegAux.SETRANGE("Cost Database Code", NoCostDatabase);
                        RegAux.SETRANGE(Code, TCD."Bill of Item Code");
                        RegAux.SETRANGE("Header Line", '~D');
                        if (not RegAux.ISEMPTY) then
                            RolLine := RolType::Sub
                        else
                            RolLine := RolType::Des;
                    end;
                end;

                //Guardo el n£mero actual para seguir el arbol
                TreeNumber := pNumber;

                //Creo el registro adecuado
                if (RolLine IN [RolType::Cap, RolType::Part]) then begin
                    //El primer fichero se carga tal cual, el resto se debe combinar los del mismo c¢digo por si hay diferencias
                    if (pPrimero) then
                        AddHead(pType, pNumber, TCD."Bill of Item Code", pPrestoCode, RolLine, pNumber, TCD."Bill of Item Unit")
                    else begin
                        //if (pNumber = '02010321') or (pPrestoCode = '01.05.01') then
                        //  FatherCode := '';

                        FatherCode := COPYSTR(pNumber, 1, STRLEN(pNumber) - opcAccountAgrupint);
                        Piecework.RESET;
                        Piecework.SETRANGE("Cost Database Default", NoCostDatabase);
                        Piecework.SETRANGE("Father Code", FatherCode);

                        if not ImpVenta and opcCost then begin
                            Piecework.SETRANGE("PRESTO Code Cost", DELCHR(TCD."Bill of Item Code", '=', '#'));
                        end;
                        if ImpVenta and opcSales then begin
                            Piecework.SETRANGE("PRESTO Code Sales", DELCHR(TCD."Bill of Item Code", '=', '#'));
                            if not (Piecework.FINDFIRST) then begin
                                Piecework.SETRANGE("PRESTO Code Sales");
                                Piecework.SETRANGE("PRESTO Code Cost", DELCHR(TCD."Bill of Item Code", '=', '#'));
                            end;

                        end;
                        if (Piecework.FINDFIRST) then begin
                            //AML
                            if (pNumber = '012103') and ImpVenta then begin
                                pNumber := pNumber;
                            end;

                            pNumber := Piecework."No.";
                        end
                        else begin
                            Piecework.RESET;
                            Piecework.SETRANGE("Cost Database Default", NoCostDatabase);
                            Piecework.SETRANGE("Father Code", FatherCode);
                            if (Piecework.FINDLAST) then
                                pNumber := INCSTR(Piecework."No.")
                            else
                                pNumber := FatherCode + AdjustLevel('1');
                        end;
                        //AML
                        if (pNumber = '012103') and ImpVenta then begin
                            pNumber := pNumber;
                        end;
                        if pNumber = '01210307' then begin
                            pNumber := pNumber;
                        end;
                        if pNumber = '01210601' then begin
                            pNumber := pNumber;
                        end;

                        AddHead(pType, pNumber, TCD."Bill of Item Code", pPrestoCode, RolLine, TreeNumber, TCD."Bill of Item Unit");
                    end;
                end else
                    AddDesc(pType, pNumber, TCD."Bill of Item Code", RolLine, pRootUnit, TCD."Bill of Item Unit", TCD."Bill of Item Quantity");

                //Proceso los de nivel inferior
                //Cargar_UnDato(pType, TCD."Bill of Item Code", TreeNumber + AdjustLevel('1'), RolLine, pRootUnit, txtCadena, pPrimero);
                Cargar_UnDato(pType, TCD."Bill of Item Code", pNumber + AdjustLevel('1'), RolLine, pRootUnit, txtCadena, pPrimero);

                //Aumento el contador para el siguiente elemento
                pNumber := INCSTR(pNumber);
            until (TCD.NEXT = 0);
    end;

    //     LOCAL procedure AdjustChapter (pCode@1100286001 :
    LOCAL procedure AdjustChapter(pCode: Code[50]): Text;
    var
        //       RegAux@1100286000 :
        RegAux: Record 7207275;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        //En los registros D no se indica el #, por tanto pueden llegar con o sin la marca de cap¡tulo
        //-------------------------------------------------------------------------------------------------------------------
        RegAux.RESET;
        RegAux.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        RegAux.SETRANGE("Session No.", SESSIONID);
        RegAux.SETRANGE("Cost Database Code", NoCostDatabase);
        RegAux.SETRANGE("Header Line", '~C');
        RegAux.SETRANGE(Code, pCode + '#');
        if (not RegAux.ISEMPTY) then
            pCode := pCode + '#';

        exit(pCode);
    end;

    //     LOCAL procedure AdjustLevel (pValue@1100286000 :
    LOCAL procedure AdjustLevel(pValue: Text): Text;
    begin
        WHILE (STRLEN(pValue) < opcAccountAgrupint) DO
            pValue := '0' + pValue;

        WHILE (STRLEN(pValue) > opcAccountAgrupint) DO
            pValue := COPYSTR(pValue, 2);

        exit(pValue);
    end;

    //     procedure AddHead (pType@1100286007 : Option;pNumber@1100286004 : Code[20];pPrestoCode@1100231000 : Code[20];pPrestoFatherCode@1100286000 : Code[20];pRolLine@1100286006 : Option;pTreeOrder@1100286010 : Code[20];pFactor@1100286012 :
    procedure AddHead(pType: Option; pNumber: Code[20]; pPrestoCode: Code[20]; pPrestoFatherCode: Code[20]; pRolLine: Option; pTreeOrder: Code[20]; pFactor: Decimal)
    var
        //       Piecework@1100286001 :
        Piecework: Record 7207277;
        //       TCD@1100286005 :
        TCD: Record 7207275;
        //       TCDFather@1100286008 :
        TCDFather: Record 7207275;
        //       TCDMed@1100286003 :
        TCDMed: Record 7207275;
        //       UnitofMeasure@1100286009 :
        UnitofMeasure: Record 204;
        //       Qty@1100286002 :
        Qty: Decimal;
        //       TCD2@1100286011 :
        TCD2: Record 7207275;
        //       Piecework2@1100286013 :
        Piecework2: Record 7207277;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        // A¤adir un registro de cap¡tulo o partida
        //    pType............: Tipo Coste, Venta, Ambos
        //    pNumber..........: C¢digo de la Unidad de Obra
        //    pPrestoCode......: C¢digo de Presto
        //    pPrestoFatherCode: C¢digo de Presto del padre
        //    pRolLine.........: Tipo de unidad, Cap¡tulo o Partida
        //    pTreeOrder.......: N§ de orden que le corresponde en el arbol
        //-------------------------------------------------------------------------------------------------------------------

        CostDatabase.GET(NoCostDatabase);  //Para obtener los CI
        pPrestoFatherCode := AdjustChapter(pPrestoFatherCode);

        //Buscar el registro a cargar
        TCD.RESET;
        TCD.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE("Header Line", '~C');
        TCD.SETFILTER(Code, '%1 | %2 | %3', DELCHR(AdjustChapter(pPrestoCode), '=', ' '), DELCHR(pPrestoCode + '#', '=', ' '), AdjustChapter(pPrestoCode));
        TCD.FINDFIRST;

        //Si no existe la unidad de medida la creo
        if not UnitofMeasure.GET(TCD."Unit of Meansure") then begin
            UnitofMeasure.INIT();
            UnitofMeasure.Code := TCD."Unit of Meansure";
            UnitofMeasure.Description := COPYSTR(Text008 + TCD."Unit of Meansure", 1, MAXSTRLEN(UnitofMeasure.Description));
            UnitofMeasure.INSERT(TRUE);
        end;

        if (pPrestoFatherCode = 'SMTC18') or (pPrestoFatherCode = 'SMTC01') then
            Qty := -1;

        //Buscar el registro del padre para saber la cantidad
        TCDFather.RESET;
        TCDFather.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        TCDFather.SETRANGE("Session No.", SESSIONID);
        TCDFather.SETRANGE("Cost Database Code", NoCostDatabase);
        TCDFather.SETRANGE("Header Line", '~D');
        TCDFather.SETFILTER(Code, '%1|%2', pPrestoFatherCode, pPrestoFatherCode + '#');
        TCDFather.SETRANGE("Bill of Item Code", TCD.Code);
        //-Q18285
        TCDFather.SETRANGE(Procesado, FALSE);
        //+Q18285
        if TCDFather.FINDFIRST then begin
            Qty := TCDFather."Bill of Item Quantity";
            //-Q18285
            TCD2.GET(TCDFather."Session No.", TCDFather."Cost Database Code", TCDFather."Line No.");
            TCD2.Procesado := TRUE;
            TCD2.MODIFY;
            //+Q18285
        end
        else
            Qty := 1;


        //Creo el registro si no existe.
        if (not Piecework.GET(NoCostDatabase, pNumber)) then begin
            Piecework.INIT;
            Piecework."Cost Database Default" := NoCostDatabase;
            Piecework."No." := pNumber;
            Piecework.Identation := (STRLEN(pNumber) / opcAccountAgrupint) - 1;
            if (pRolLine = RolType::Cap) then
                Piecework.VALIDATE("Account Type", Piecework."Account Type"::Heading)
            else
                Piecework.VALIDATE("Account Type", Piecework."Account Type"::Unit);
            //-Q20047
            if (CostDatabase."Type JU" = CostDatabase."Type JU"::Indirect) then begin
                Piecework."Unit Type" := Piecework."Unit Type"::"Cost Units";
                Piecework."Subtype Cost" := Piecework."Subtype Cost"::"Current Expenses";
            end;
            //+Q20047
            Piecework."Piecework Filter" := NoCostDatabase;
            SplitDescription(Piecework.Description, Piecework."Description 2", TCD."Small Description", MAXSTRLEN(Piecework.Description));
            Piecework.VALIDATE("Units of Measure", TCD."Unit of Meansure");
            Piecework."Automatic Additional Text" := FALSE;
            Piecework."Unique Code" := Piecework."Cost Database Default" + Piecework."No.";
            Piecework."% Margin" := QuoBuildingSetup."% Generic Margin Sale Piecewor";
            Piecework."Father Code" := COPYSTR(Piecework."No.", 1, STRLEN(Piecework."No.") - opcAccountAgrupint);  //Le pongo el c¢digo del padre
            Piecework.INSERT;
        end;
        //Datos que dependen del tipo coste/venta y deben insertarse o modificarse
        //Ahora tenemos dos c¢digos de Presto
        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then
            Piecework."PRESTO Code Cost" := DELCHR(TCD.Code, '=', '#');
        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta]) then
            Piecework."PRESTO Code Sales" := DELCHR(TCD.Code, '=', '#');
        //-Q18285 AML 24/03/23 Leer el factor y guardarlo
        //AML
        if Piecework."No." = '010371' then begin
            Piecework."No." := Piecework."No.";
        end;
        //AML
        Piecework.Factor := pFactor;
        if Piecework."Account Type" = Piecework."Account Type"::Heading then Piecework.Factor := 1;
        if Piecework.Factor = 0 then Piecework.Factor := 1;
        if Piecework.Factor <> 1 then begin
            Piecework."No." := Piecework."No.";
        end;
        //+Q18285
        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then begin
            Piecework."Measurement Cost" := Qty;
            Piecework."Base Price Cost" := ROUND(TCD.Amount, opcDecUOPre);
            Piecework."Received Cost Price" := TCD.Amount;
            Piecework."Production Unit" := TRUE;
            Piecework."Tree Order Cost" := pTreeOrder;

            //JAV 04/12/22: - QB 1.12.24 Calculamos el precio base en funci¢n del mismo el precio de coste o de venta
            if (CostDatabase."CI Cost" = 0) then
                Piecework."Price Cost" := Piecework."Base Price Cost"
            else
                Piecework."Price Cost" := ROUND(Piecework."Base Price Cost" * (CostDatabase."CI Cost" + 100) / 100, opcDecUOPre);
        end;

        if ((pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta])) then begin
            Piecework."Measurement Sale" := Qty;
            Piecework."Base Price Sales" := ROUND(TCD.Amount, opcDecUOPre);
            Piecework."Received Sales Price" := TCD.Amount;
            Piecework."Certification Unit" := TRUE;
            Piecework."Tree Order Sales" := pTreeOrder;
            if opcCost and (Piecework."Measurement Cost" = 0) and opcMedicionIgual then begin
                Piecework."Measurement Cost" := Piecework."Measurement Sale";
            end;
            //JAV 04/12/22: - QB 1.12.24 Calculamos el precio base en funci¢n del mismo el precio de coste o de venta
            if (CostDatabase."CI Sales" = 0) then
                Piecework."Proposed Sale Price" := Piecework."Base Price Sales"
            else
                Piecework."Proposed Sale Price" := ROUND(Piecework."Base Price Sales" * (CostDatabase."CI Sales" + 100) / 100, opcDecUOPre);
        end;

        Piecework.MODIFY;

        //Informaci¢n adicional: Textos y mediciones
        InsertTextAditional(pType, TCD.Code, Piecework."No.", '');
        InsertMeasures(pType, pNumber, DELCHR(TCD.Code, '=', '#'), pTreeOrder, pPrestoFatherCode);

        Piecework.CalculateUnit;  //Esto se debe hacer al finalizar para que calcule todos correctamente, ya que los padres todav¡a no tienen grabados los hijos
        Piecework.MODIFY;

        //JAV 28/11/22: - QB 1.12.24 Guardar la medici¢n recibida
        Qty := 0;
        //-Q18285 AML 04/03/23 PARA ENCONTRAR LA MEDICION EN CASO DE ESTRUCTURAS INCOMPATIBLES.
        //TCDMed.RESET;
        //TCDMed.SETCURRENTKEY("Session No.","Cost Database Code","Header Line",Code);
        //TCDMed.SETRANGE("Session No.",SESSIONID);
        //TCDMed.SETRANGE("Cost Database Code",NoCostDatabase);
        //TCDMed.SETRANGE("Header Line",'~M');
        //TCDMed.SETRANGE(Code, AdjustChapter(pPrestoCode));
        //TCDMed.SETRANGE("Mesure Position", pTreeOrder);   //JAV 03/12/22: - QB 1.12.24 No buscamos solo el c¢digo, sino que la posici¢n en el arbol sea la correcta
        //if TCDMed.FINDFIRST then
        //Qty := TCDMed."Medition Total";
        if pPrestoCode = '04.44V1' then begin
            pPrestoCode := pPrestoCode;
        end;

        TCDMed.RESET;
        TCDMed.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        TCDMed.SETRANGE("Session No.", SESSIONID);
        TCDMed.SETRANGE("Cost Database Code", NoCostDatabase);
        TCDMed.SETRANGE("Header Line", '~M');
        TCDMed.SETRANGE(Code, AdjustChapter(pPrestoCode));
        TCDMed.SETRANGE("Mesure Position", pTreeOrder);   //JAV 03/12/22: - QB 1.12.24 No buscamos solo el c¢digo, sino que la posici¢n en el arbol sea la correcta
        if TCDMed.FINDFIRST then begin
            Qty := TCDMed."Medition Total";
        end
        else begin
            TCDMed.RESET;
            TCDMed.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
            TCDMed.SETRANGE("Session No.", SESSIONID);
            TCDMed.SETRANGE("Cost Database Code", NoCostDatabase);
            TCDMed.SETRANGE("Header Line", '~M');
            TCDMed.SETRANGE(Code, AdjustChapter(pPrestoCode));
            //AML
            if pPrestoCode = '04.44V1' then begin
                pPrestoCode := pPrestoCode;
            end;
            //AML
            //Piecework2.SETRANGE("Cost Database Default",Piecework."Cost Database Default");
            //if ImpVenta then Piecework2.SETRANGE("PRESTO Code Sales",pPrestoFatherCode);
            //if not ImpVenta then Piecework2.SETRANGE("PRESTO Code Cost",pPrestoFatherCode);
            //if Piecework2.FINDFIRST then begin
            if ImpVenta then TCDMed.SETRANGE("Bill of Item Code", pPrestoFatherCode);
            if not ImpVenta then TCDMed.SETRANGE("Bill of Item Code", pPrestoFatherCode);
            if TCDMed.FINDFIRST then
                Qty := TCDMed."Medition Total";

            //end;
        end;

        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then
            Piecework."Received Cost Medition" := Qty;
        if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta]) then
            Piecework."Received Sales Medition" := Qty;
        Piecework.MODIFY;
    end;

    //     procedure AddDesc (pType@1100286004 : Option;pNumber@1100286001 : Text;pPrestoCode@1100286005 : Code[20];pRolLine@1100286000 : Option;pRootUnit@1100286009 : Code[20];pFactor@1100286006 : Decimal;pQty@1100286007 :
    procedure AddDesc(pType: Option; pNumber: Text; pPrestoCode: Code[20]; pRolLine: Option; pRootUnit: Code[20]; pFactor: Decimal; pQty: Decimal)
    var
        //       BillofItemData@1100286010 :
        BillofItemData: Record 7207384;
        //       TCD@1100286003 :
        TCD: Record 7207275;
        //       TCD2@1100286002 :
        TCD2: Record 7207275;
        //       blnUndefined@1100286008 :
        blnUndefined: Boolean;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        //A¤adir un registro de descompuestos, pueden ser Auxiliares o detalles
        //    pType......: Tipo Coste, Venta, Ambos
        //    pNumber....: C¢digo de la Unidad de Obra
        //    pPrestoCode: C¢digo de Presto
        //    pRolLine...: Tipo de unidad, Cap¡tulo o Partida
        //    pRootUnit..: Partida de la que cuelga
        //    pFactor....: Factor multiplicativo (viene del registro D, aqu¡ tratamos el C)
        //    pQty.......: Cantidad (viene del registro D, aqu¡ tratamos el C)
        //-------------------------------------------------------------------------------------------------------------------

        TCD.RESET;
        TCD.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE("Header Line", '~C');
        //-Q18285
        TCD.SETFILTER(Code, '%1|%2', pPrestoCode, pPrestoCode + '#');
        //if (not TCD.FINDFIRST) then
        //ERROR('No exite el registro tipo C para %1', pPrestoCode);
        blnUndefined := FALSE;
        if (not TCD.FINDFIRST) then begin
            blnUndefined := TRUE;
        end;
        //+Q18285
        PieceworkSetup.GET();

        BillofItemData.INIT;
        BillofItemData."Cod. Cost database" := NoCostDatabase;
        BillofItemData."Order No." := COPYSTR(pNumber, STRLEN(pRootUnit) + 1);   //Quitamos el c¢digo de la unidad de obra raiz de este arbol de descompuestos
        BillofItemData."Cod. Piecework" := pRootUnit;
        BillofItemData."No." := pPrestoCode;
        BillofItemData."Presto Code" := pPrestoCode;
        BillofItemData."Father Code" := COPYSTR(BillofItemData."Order No.", 1, STRLEN(BillofItemData."Order No.") - opcAccountAgrupint);
        BillofItemData.Identation := (STRLEN(BillofItemData."Order No.") / opcAccountAgrupint) - 1;

        //-Q18285
        //AML 02/06/23 No Permitimos Indefinidos.
        if pPrestoCode = 'PCONTRATAOP' then begin
            pPrestoCode := pPrestoCode;
        end;
        if blnUndefined then begin
            TCD."Concept Type" := TCD."Concept Type"::Resource;
            blnUndefined := FALSE;
        end;
        //AML
        if not blnUndefined then begin
            //+Q18285
            if (pRolLine = RolType::Sub) then
                BillofItemData.Type := BillofItemData.Type::"Posting U."
            else
                CASE TCD."Concept Type" OF
                    TCD."Concept Type"::Item:
                        BillofItemData.Type := BillofItemData.Type::Item;
                    TCD."Concept Type"::Resource:
                        BillofItemData.Type := BillofItemData.Type::Resource;
                    TCD."Concept Type"::Equipament:
                        BillofItemData.Type := BillofItemData.Type::Resource;
                    else
                        BillofItemData.Type := BillofItemData.Type::"Posting U.";
                end;
            //-Q18285
        end
        else begin
            BillofItemData.Type := BillofItemData.Type::Undefined;
            BillofItemData.Description := 'ELEMENTO NO DEFINIDO';
            BillofItemData.INSERT;
            exit;
        end;
        //+Q18285


        //En las unidades auxiliares sin nada por debajo, cambiarles el tipo si as¡ est  indicado
        if (BillofItemData.Type = BillofItemData.Type::"Posting U.") then begin
            TCD2.RESET;
            TCD2.SETCURRENTKEY("Session No.", "Cost Database Code", "Header Line", Code);
            TCD2.SETRANGE("Session No.", SESSIONID);
            TCD2.SETRANGE("Cost Database Code", NoCostDatabase);
            TCD2.SETRANGE("Header Line", '~D');
            TCD2.SETFILTER(Code, '%1|%2', pPrestoCode, pPrestoCode + '#');
            if (not TCD2.FINDFIRST) then
                if (BillofItemData.Use = BillofItemData.Use::Cost) then begin
                    CASE opcWOdescCost OF
                        PieceworkSetup."Default Cost Without Decom."::Item:
                            BillofItemData.Type := BillofItemData.Type::Item;
                        PieceworkSetup."Default Cost Without Decom."::Resource:
                            BillofItemData.Type := BillofItemData.Type::Resource;
                    end;
                end else begin
                    CASE opcWOdescSales OF
                        PieceworkSetup."Default Cost Without Decom."::Item:
                            BillofItemData.Type := BillofItemData.Type::Item;
                        PieceworkSetup."Default Cost Without Decom."::Resource:
                            BillofItemData.Type := BillofItemData.Type::Resource;
                    end;
                end;
        end;

        SplitDescription(BillofItemData.Description, BillofItemData."Description 2", TCD."Small Description", MAXSTRLEN(BillofItemData.Description));
        BillofItemData."Units of Measure" := TCD."Unit of Meansure";

        BillofItemData."Bill of Item Units" := pFactor;
        //-AML Q18285
        BillofItemData.Factor := pFactor;
        //+AML Q18285
        BillofItemData."Quantity By" := pQty;
        BillofItemData."Received Price" := TCD.Amount;
        BillofItemData."Base Unit Cost" := ROUND(TCD.Amount, opcDecDesPre);
        BillofItemData."Concep. Anal. Indirect Cost" := '';
        BillofItemData."Unit Cost Indirect" := 0;
        if (BillofItemData.Type <> BillofItemData.Type::"Posting U.") then
            AssignCAtoBillOfItem(BillofItemData);

        //Calcular el precio con CI
        if (VCI = 0) then
            BillofItemData."Direct Unit Cost" := BillofItemData."Base Unit Cost"
        else
            BillofItemData."Direct Unit Cost" := ROUND(BillofItemData."Base Unit Cost" * (VCI + 100) / 100, opcDecDesPre);

        //-Q20047
        //{
        //      if (CostDatabase."Type JU" = CostDatabase."Type JU"::Indirect) or (CostDatabase."Type JU" = CostDatabase."Type JU"::Booth) then begin
        //      if (VCI = 0) then
        //       BillofItemData."Unit Cost Indirect" := BillofItemData."Unit Cost Indirect"
        //      else
        //       BillofItemData."Unit Cost Indirect" := ROUND(BillofItemData."Unit Cost Indirect" * (VCI + 100) / 100, opcDecDesPre);
        //
        //      end;
        //      }
        //+Q20047
        //Inserto y calculo como coste
        if (opcInsertBillofItemCost) and (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then
            AddDescOne(BillofItemData, BillofItemData.Use::Cost);

        //Inserto y calculo como venta
        if (opcInsertBillofItemSales) and (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta]) then
            AddDescOne(BillofItemData, BillofItemData.Use::Sales);

        //Crear el producto o recurso
        CASE BillofItemData.Type OF
            BillofItemData.Type::Item:
                CU_Item(TCD.Code, TCD."Small Description", TCD."Unit of Meansure", TCD.Amount);
            BillofItemData.Type::Resource:
                CU_Resource(TCD.Code, TCD."Small Description", TCD."Unit of Meansure", TCD.Amount, TCD."Concept Type");
            //AML 02/06/23 Q18285 Si es un indefinido creamos un recurso.
            BillofItemData.Type::Undefined:
                CU_Resource(TCD.Code, TCD."Small Description", TCD."Unit of Meansure", TCD.Amount, TCD."Concept Type")
        //Q18285
        end;
    end;

    //     LOCAL procedure AddDescOne (var BillofItemData@1100286000 : Record 7207384;pType@1100286001 :
    LOCAL procedure AddDescOne(var BillofItemData: Record 7207384; pType: Option)
    var
        //       BillofItemData2@1100286002 :
        BillofItemData2: Record 7207384;
        //       qty@1100286003 :
        qty: Decimal;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        //A¤adir un registro de un descompuesto de coste o de venta y realizar los c lculos necesarios
        //-------------------------------------------------------------------------------------------------------------------

        BillofItemData.Use := pType;

        //Procesar los porcentuales
        //AML
        if COPYSTR(BillofItemData."No.", 1, 7) = '%BAJA05' then begin
            BillofItemData."No." := BillofItemData."No.";
        end;
        //AML
        if (STRPOS(BillofItemData."Presto Code", '%') <> 0) then
            ProcessPorc(BillofItemData);

        BillofItemData.INSERT;
        //-Q20047
        //BillofItemData.ActCostJU();  //Calcular totales
        //+Q20047
        BillofItemData.VALIDATE("Total Qty");
        BillofItemData.VALIDATE("Total Cost");
        //-Q20047
        BillofItemData.ActCostJU();  //Calcular totales
                                     //+Q20047
        BillofItemData.MODIFY;
    end;

    //     LOCAL procedure AssignCAtoBillOfItem (var pBillofItemData@1100286000 :
    LOCAL procedure AssignCAtoBillOfItem(var pBillofItemData: Record 7207384)
    begin
        //JAV 22/04/22: - QB 1.10.36 Se unifica la funci¢n que busca el CA asociado a la l¡nea de descompuesto para que solo est‚ una vez en el c¢digo
        PieceworkSetup.GET;

        CASE pBillofItemData.Type OF
            pBillofItemData.Type::Item:
                begin
                    if PieceworkSetup."CA PRESTO Item" = '' then
                        ERROR(Text020, PieceworkSetup.FIELDCAPTION("CA PRESTO Item"));
                    pBillofItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Item");
                end;
            pBillofItemData.Type::Resource:
                begin
                    if PieceworkSetup."CA PRESTO Resource" = '' then
                        ERROR(Text020, PieceworkSetup.FIELDCAPTION("CA PRESTO Resource"));
                    pBillofItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Resource");
                end;
            else begin
                if PieceworkSetup."CA PRESTO Account" = '' then
                    ERROR(Text020, PieceworkSetup.FIELDCAPTION("CA PRESTO Account"));
                pBillofItemData.VALIDATE("Concep. Analytical Direct Cost", PieceworkSetup."CA PRESTO Account");
            end;
        end;
    end;

    //     procedure InsertTextAditional (pType@1100286007 : Option;pCode@1100231001 : Code[20];pNumber@100000001 : Code[30];pItem@1100286000 :
    procedure InsertTextAditional(pType: Option; pCode: Code[20]; pNumber: Code[30]; pItem: Code[20])
    var
        //       QBText@1100286009 :
        QBText: Record 7206918;
        //       TCD@1100286010 :
        TCD: Record 7207275;
        //       TempBlob@1100286001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       Text1@1100286008 :
        Text1: Text;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        //A¤adir las l¡neas de descripci¢n larga en la Unidad de Obra y en los descompuestos
        //-------------------------------------------------------------------------------------------------------------------
        TCD.RESET;
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE("Header Line", '~T');
        TCD.SETRANGE(Code, pCode);
        if (TCD.FINDFIRST) then begin
            if (TCD.BlobTextLong <> 0) then begin
                TCD.CALCFIELDS(BlobText);
                // TempBlob.Blob := TCD.BlobText;
                /*To be tested*/

                TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                Blob.Write(TCD.BlobText);
                Text1 := '';
                //Text1 := TempBlob.ReadAsText(VCHAR10, TEXTENCODING::Windows);
                //Clarify VCHAR10 functionality
                TempBlob.CreateInSTream(InStr, TextEncoding::Windows);
                InStr.Read(Text1);

                if (Text1 <> '') then begin
                    if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then
                        QBText.InsertCostText(Text1, QBText.Table::Preciario, NoCostDatabase, pNumber, pItem)
                    else
                        QBText.InsertSalesText(Text1, QBText.Table::Preciario, NoCostDatabase, pNumber, pItem);   //Si cargamos ambos, no hay texto de venta
                end;
            end;
        end;
    end;

    //     procedure InsertMeasures (pType@1100286001 : Option;pNumber@1100286000 : Code[30];pCode@1100231001 : Code[20];pPosition@1100286003 : Code[20];pPrestoFatherCode@1100286004 :
    procedure InsertMeasures(pType: Option; pNumber: Code[30]; pCode: Code[20]; pPosition: Code[20]; pPrestoFatherCode: Code[20])
    var
        //       TCD@1100286002 :
        TCD: Record 7207275;
        //       Ending@1100231009 :
        Ending: Boolean;
        //       LastMeasure@1100231010 :
        LastMeasure: Integer;
        //       LMeasureLinePieceworkPRESTO@1100231007 :
        LMeasureLinePieceworkPRESTO: Record 7207285;
        //       Piecework2@1100286005 :
        Piecework2: Record 7207277;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        //A¤adir las l¡neas de medici¢n a las partidas
        //    pType....: Tipo (Coste, venta, ambos)
        //    pNumber..: C¢digo del que cuelga
        //    pCode....: C¢digo de Presto
        //    pPosition: Posici¢n en el arbol en el BC3 de coste o de venta
        //-------------------------------------------------------------------------------------------------------------------
        //JAV 28/11/22: - Si no hay medici¢n no crear las l¡neas para evitar que quede a cero y no se pueda modificar
        if (CalculateTotalMeasures(pType, pNumber, pCode) = 0) then
            exit;

        LMeasureLinePieceworkPRESTO.INIT;
        LastMeasure := 0;
        // inserto las l¡neas de medici¢n
        //aml
        if pNumber = '010343' then begin


        end;
        //AML
        //AML
        if pCode = '04.44V1' then begin
            pCode := pCode;
        end;
        //AML
        TCD.RESET;
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE("Header Line", '~M');
        TCD.SETRANGE(Code, pCode);
        TCD.SETRANGE("Mesure Position", pNumber);   //JAV 03/12/22: - QB 1.12.24 No buscamos solo el c¢digo, sino que la posici¢n en el arbol sea la correcta
        if TCD.FINDSET(FALSE) then begin
            repeat
                LastMeasure += 10000;
                LMeasureLinePieceworkPRESTO.INIT;
                LMeasureLinePieceworkPRESTO."Cost Database Code" := NoCostDatabase;
                LMeasureLinePieceworkPRESTO."Cod. Jobs Unit" := pNumber;
                LMeasureLinePieceworkPRESTO."Line No." := LastMeasure;
                LMeasureLinePieceworkPRESTO.Description := TCD."Small Description";

                if (TCD.Units = 0) and ((TCD.Length <> 0) or (TCD.Width <> 0) or (TCD.Height <> 0)) then
                    TCD.Units := 1;

                LMeasureLinePieceworkPRESTO.VALIDATE(Units, TCD.Units);
                LMeasureLinePieceworkPRESTO.VALIDATE(Length, TCD.Length);
                LMeasureLinePieceworkPRESTO.VALIDATE(Width, TCD.Width);
                LMeasureLinePieceworkPRESTO.VALIDATE(Height, TCD.Height);
                LMeasureLinePieceworkPRESTO.Total := TCD."Medition Total";
                if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then begin
                    if (opcInsertMeditionCost) then begin
                        LMeasureLinePieceworkPRESTO.VALIDATE(Use, LMeasureLinePieceworkPRESTO.Use::Cost);
                        if not LMeasureLinePieceworkPRESTO.INSERT(TRUE) then; //Las inserto aunque est‚n en blanco, para mantener los mismos registros del BC3
                    end;
                end;
                if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta]) then begin
                    if (opcInsertMeditionSales) then begin
                        LMeasureLinePieceworkPRESTO.VALIDATE(Use, LMeasureLinePieceworkPRESTO.Use::Sales);
                        if not LMeasureLinePieceworkPRESTO.INSERT(TRUE) then; //Las inserto aunque est‚n en blanco, para mantener los mismos registros del BC3
                    end;
                end;
            until TCD.NEXT = 0;
        end
        else begin
            TCD.RESET;
            TCD.SETRANGE("Session No.", SESSIONID);
            TCD.SETRANGE("Cost Database Code", NoCostDatabase);
            TCD.SETRANGE("Header Line", '~M');
            TCD.SETRANGE(Code, pCode);
            Piecework2.SETRANGE("Cost Database Default", NoCostDatabase);
            //AML
            if pCode = '04.44V1' then begin
                pCode := pCode;
            end;
            //AML

            //if ImpVenta then Piecework2.SETRANGE("PRESTO Code Sales",pPrestoFatherCode);
            //if not ImpVenta then Piecework2.SETRANGE("PRESTO Code Cost",pPrestoFatherCode);
            //if Piecework2.FINDFIRST then begin
            if ImpVenta then TCD.SETRANGE("Bill of Item Code", pPrestoFatherCode);
            if not ImpVenta then TCD.SETRANGE("Bill of Item Code", pPrestoFatherCode);
            if TCD.FINDSET(FALSE) then begin
                repeat
                    LastMeasure += 10000;
                    LMeasureLinePieceworkPRESTO.INIT;
                    LMeasureLinePieceworkPRESTO."Cost Database Code" := NoCostDatabase;
                    LMeasureLinePieceworkPRESTO."Cod. Jobs Unit" := pNumber;
                    LMeasureLinePieceworkPRESTO."Line No." := LastMeasure;
                    LMeasureLinePieceworkPRESTO.Description := TCD."Small Description";

                    if (TCD.Units = 0) and ((TCD.Length <> 0) or (TCD.Width <> 0) or (TCD.Height <> 0)) then
                        TCD.Units := 1;

                    LMeasureLinePieceworkPRESTO.VALIDATE(Units, TCD.Units);
                    LMeasureLinePieceworkPRESTO.VALIDATE(Length, TCD.Length);
                    LMeasureLinePieceworkPRESTO.VALIDATE(Width, TCD.Width);
                    LMeasureLinePieceworkPRESTO.VALIDATE(Height, TCD.Height);
                    LMeasureLinePieceworkPRESTO.Total := TCD."Medition Total";
                    if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Coste]) then begin
                        if (opcInsertMeditionCost) then begin
                            LMeasureLinePieceworkPRESTO.VALIDATE(Use, LMeasureLinePieceworkPRESTO.Use::Cost);
                            if not LMeasureLinePieceworkPRESTO.INSERT(TRUE) then; //Las inserto aunque est‚n en blanco, para mantener los mismos registros del BC3
                        end;
                    end;
                    if (pType IN [OPTTipoDeCarga::Ambos, OPTTipoDeCarga::Venta]) then begin
                        if (opcInsertMeditionSales) then begin
                            LMeasureLinePieceworkPRESTO.VALIDATE(Use, LMeasureLinePieceworkPRESTO.Use::Sales);
                            if not LMeasureLinePieceworkPRESTO.INSERT(TRUE) then; //Las inserto aunque est‚n en blanco, para mantener los mismos registros del BC3
                        end;
                    end;
                until TCD.NEXT = 0;

                //end;
            end;
        end;
    end;

    //     LOCAL procedure CalculateTotalMeasures (pType@1100286004 : Option;pNumber@1100286003 : Code[30];pCode@1100286002 :
    LOCAL procedure CalculateTotalMeasures(pType: Option; pNumber: Code[30]; pCode: Code[20]): Decimal;
    var
        //       TCD@1100286008 :
        TCD: Record 7207275;
        //       LMeasureLinePieceworkPRESTO@1100286005 :
        LMeasureLinePieceworkPRESTO: Record 7207285;
        //       Qty@1100286000 :
        Qty: Decimal;
    begin
        //-------------------------------------------------------------------------------------------------------------------
        //Calcular el total de las l¡neas de medici¢n de una partida
        //-------------------------------------------------------------------------------------------------------------------
        Qty := 0;

        TCD.RESET;
        TCD.SETRANGE("Session No.", SESSIONID);
        TCD.SETRANGE("Cost Database Code", NoCostDatabase);
        TCD.SETRANGE("Header Line", '~M');
        TCD.SETRANGE(Code, pCode);
        if TCD.FINDSET(FALSE) then
            repeat
                if (TCD.Units = 0) and ((TCD.Length <> 0) or (TCD.Width <> 0) or (TCD.Height <> 0)) then
                    TCD.Units := 1;

                LMeasureLinePieceworkPRESTO.INIT;
                LMeasureLinePieceworkPRESTO.VALIDATE(Units, TCD.Units);
                LMeasureLinePieceworkPRESTO.VALIDATE(Length, TCD.Length);
                LMeasureLinePieceworkPRESTO.VALIDATE(Width, TCD.Width);
                LMeasureLinePieceworkPRESTO.VALIDATE(Height, TCD.Height);
                //AML
                //Qty += LMeasureLinePieceworkPRESTO.Total;
                Qty += TCD."Medition Total";
            until TCD.NEXT = 0;

        exit(Qty);
    end;

    //     LOCAL procedure SplitDescription (var Desc1@7001100 : Text;var Desc2@7001101 : Text;Texto@7001102 : Text;Long@1100286000 :
    LOCAL procedure SplitDescription(var Desc1: Text; var Desc2: Text; Texto: Text; Long: Integer)
    var
        //       SmallDescription1@7001103 :
        SmallDescription1: Text[50];
        //       Pos@7001105 :
        Pos: Integer;
    begin
        //-------------------------------------------------------------------------------------------------
        // Dividir una cadena entre dos variables de una longitud m xima, sin partir palabras
        //     Desc1: Primera cadena
        //     Desc2: Segunda cadena
        //     Texto: Texto a repartir
        //     Long.: Longitud m xima de las cadenas
        //-------------------------------------------------------------------------------------------------
        Texto := DELCHR(Texto, '<>', ' ');
        if (STRLEN(Texto) <= Long) then begin
            Desc1 := Texto;
            Desc2 := '';
        end else begin
            Pos := FindLastSpace(Texto, Long);  //Pos es un espacio, si no lo hay es cero
            if (Pos = 0) then begin
                Desc1 := COPYSTR(Texto, 1, Long);
                Desc2 := COPYSTR(Texto, Long + 1, Long);
            end else begin
                Desc1 := COPYSTR(Texto, 1, Pos);
                Desc2 := COPYSTR(Texto, Pos + 2, Long);
            end;
        end;
    end;

    //     LOCAL procedure FindLastSpace (String@7001100 : Text;Pos@1100286000 :
    LOCAL procedure FindLastSpace(String: Text; Pos: Integer): Integer;
    var
        //       i@7001101 :
        i: Integer;
    begin
        //-------------------------------------------------------------------------------------------------
        // Encontrar en una cadena un espacio que est‚ sitaudo antes de una posici¢n
        //     String: Cadena en la que buscar
        //     Pos...: Posici¢n de partida
        //    RETORNA: entero con la posici¢n
        //-------------------------------------------------------------------------------------------------
        i := Pos + 1;
        repeat
            i -= 1;
        until (i = 1) or (String[i] = ' ');

        exit(i - 1);
    end;

    //     procedure CU_Item (pCode@1100286000 : Code[20];pDes@1100286003 : Text;pUM@1100286001 : Code[20];pCost@1100286002 :
    procedure CU_Item(pCode: Code[20]; pDes: Text; pUM: Code[20]; pCost: Decimal)
    var
        //       Item@1000000004 :
        Item: Record 27;
        //       UnitofMeasure@1100286004 :
        UnitofMeasure: Record 204;
        //       ItemUnitofMeasure@1100286005 :
        ItemUnitofMeasure: Record 5404;
    begin
        //-------------------------------------------------------------------------------------------------
        //Create-Update: el Producto asociado a un descompuesto
        //     pCode...: C¢digo a crear
        //     pDes....: Descripci¢n
        //     pUM.....: Unidad de Medida
        //     pCost...: Precio
        //     pConcept: Tipo de recurso (subcontrata, m quina)
        //-------------------------------------------------------------------------------------------------
        if not Item.GET(pCode) then begin
            SplitDescription(Item.Description, Item."Description 2", pDes, MAXSTRLEN(Item.Description));

            Item.INIT();
            Item.VALIDATE("No.", pCode);
            Item.VALIDATE(Description);
            Item.VALIDATE("Description 2");
            Item.VALIDATE("VAT Prod. Posting Group", PieceworkSetup."G.R. BAT Product PRESTO");
            Item.INSERT(TRUE);

            //Las unidades de medida
            if not UnitofMeasure.GET(pUM) then begin
                UnitofMeasure.INIT();
                UnitofMeasure.Code := pUM;
                UnitofMeasure.Description := COPYSTR(Text008 + pUM, 1, MAXSTRLEN(UnitofMeasure.Description));
                UnitofMeasure.INSERT(TRUE);
            end;
            if not ItemUnitofMeasure.GET(pCode, pUM) then begin
                ItemUnitofMeasure.INIT();
                ItemUnitofMeasure.VALIDATE("Item No.", pCode);
                ItemUnitofMeasure.VALIDATE(Code, pUM);
                ItemUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                ItemUnitofMeasure.INSERT(TRUE);
            end;

            Item.VALIDATE("Base Unit of Measure", pUM);
            Item.VALIDATE("Unit Cost", pCost);
            Item.VALIDATE("Gen. Prod. Posting Group", PieceworkSetup."G.C. Item PRESTO");
            Item.VALIDATE("Inventory Posting Group", PieceworkSetup."G.C. Stock PRESTO");
            Item.VALIDATE("VAT Prod. Posting Group", PieceworkSetup."G.R. BAT Product PRESTO");
            Item."QB Created by PRESTO" := TRUE;
            Item.MODIFY(TRUE);
        end;

        if (opcReplaceDescriptions) then begin
            SplitDescription(Item.Description, Item."Description 2", pDes, MAXSTRLEN(Item.Description));
            Item.VALIDATE(Description);
            Item.VALIDATE("Description 2");
            Item.VALIDATE("VAT Prod. Posting Group", PieceworkSetup."G.R. BAT Product PRESTO");
            Item.MODIFY(TRUE);
        end;
    end;

    //     procedure CU_Resource (pCode@1100286000 : Code[20];pDes@1100286003 : Text;pUM@1100286001 : Code[20];pCost@1100286002 : Decimal;pConcept@1100286004 :
    procedure CU_Resource(pCode: Code[20]; pDes: Text; pUM: Code[20]; pCost: Decimal; pConcept: Option)
    var
        //       Resource@1000000003 :
        Resource: Record 156;
        //       ResourceCost@1000000005 :
        ResourceCost: Record 202;
        //       UnitofMeasure@1100286007 :
        UnitofMeasure: Record 204;
        //       ResourceUnitofMeasure@1100286006 :
        ResourceUnitofMeasure: Record 205;
        //       TCD@1100286005 :
        TCD: Record 7207275;
    begin
        //-------------------------------------------------------------------------------------------------
        //Create-Update: el Recurso asociado a un descompuesto
        //     pCode...: C¢digo a crear
        //     pDes....: Descripci¢n
        //     pUM.....: Unidad de Medida
        //     pCost...: Precio
        //     pConcept: Tipo de recurso (subcontrata, m quina)
        //-------------------------------------------------------------------------------------------------

        if not Resource.GET(pCode) then begin
            SplitDescription(Resource.Name, Resource."Name 2", pDes, MAXSTRLEN(Resource.Name));

            Resource.INIT();
            Resource.VALIDATE("No.", pCode);
            Resource.VALIDATE(Name);
            Resource.VALIDATE("Name 2");
            Resource.INSERT(TRUE);

            //Las unidades de medida
            if not UnitofMeasure.GET(pUM) then begin
                UnitofMeasure.INIT();
                UnitofMeasure.Code := pUM;
                UnitofMeasure.Description := COPYSTR(Text008 + pUM, 1, MAXSTRLEN(UnitofMeasure.Description));
                UnitofMeasure.INSERT(TRUE);
            end;
            if not ResourceUnitofMeasure.GET(pCode, pUM) then begin
                ResourceUnitofMeasure.INIT();
                ResourceUnitofMeasure.VALIDATE("Resource No.", pCode);
                ResourceUnitofMeasure.VALIDATE(Code, pUM);
                ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                ResourceUnitofMeasure.INSERT(TRUE);
            end;

            CASE pConcept OF
                TCD."Concept Type"::Resource:
                    Resource.VALIDATE(Type, Resource.Type::Subcontracting);
                TCD."Concept Type"::Equipament:
                    Resource.VALIDATE(Type, Resource.Type::Machine);
                TCD."Concept Type"::Unclassified:
                    Resource.VALIDATE(Type, Resource.Type::Subcontracting);
            end;
            Resource.VALIDATE("Base Unit of Measure", UnitofMeasure.Code);
            Resource.VALIDATE("Direct Unit Cost", pCost);
            Resource.VALIDATE("Gen. Prod. Posting Group", PieceworkSetup."G.C. Resource PRESTO");
            Resource."Created by PRESTO S/N" := TRUE;
            Resource.MODIFY(TRUE);
        end;

        if (opcReplaceDescriptions) then begin
            SplitDescription(Resource.Name, Resource."Name 2", pDes, MAXSTRLEN(Resource.Name));
            Resource.VALIDATE(Name);
            Resource.VALIDATE("Name 2");
            Resource.MODIFY(TRUE);
        end;

        //Creo el precio de coste si no lo tiene
        ResourceCost.RESET();
        if not ResourceCost.GET(ResourceCost.Type::Resource, pCode) then begin
            ResourceCost.INIT();
            ResourceCost.VALIDATE(Type, ResourceCost.Type::Resource);
            ResourceCost.VALIDATE(Code, Resource."No.");
            ResourceCost.VALIDATE("Direct Unit Cost", pCost);
            ResourceCost.INSERT(TRUE);
        end;
    end;

    //     LOCAL procedure ProcessPorc (var BillofItemData@1100286000 :
    LOCAL procedure ProcessPorc(var BillofItemData: Record 7207384)
    var
        //       BillofItemData2@1100286003 :
        BillofItemData2: Record 7207384;
        //       Qty@1100286006 :
        Qty: Decimal;
        //       Price11@1100286008 :
        Price11: Decimal;
        //       Txt@1100286001 :
        Txt: Text;
        //       Nro@1100286004 :
        Nro: Text;
        //       Processed11@1100286005 :
        Processed11: Decimal;
        //       PrestoCode11@1100286007 :
        PrestoCode11: Text;
    begin
        //-------------------------------------------------------------------------------------------------
        // JAV 06/12/22: - QB 1.12.24 Procesar los porcentuales
        //     BillofItemData: Descompuesto a procesar
        //-------------------------------------------------------------------------------------------------

        //BillofItemData."No." := CONVERTSTR(BillofItemData."No.",'%','/'); //El c¢digo no puede tener el % para no liarse con los filtros

        //Primero busco el c¢digo £nico para este descompuesto en todo el preciario
        BillofItemData2.RESET;
        BillofItemData2.SETRANGE("Cod. Cost database", BillofItemData."Cod. Cost database");
        BillofItemData2.SETRANGE(Use, BillofItemData.Use);
        BillofItemData2.SETRANGE(Type, BillofItemData.Type);
        BillofItemData2.SETRANGE("Presto Code", BillofItemData."Presto Code");
        if (not BillofItemData2.FINDLAST) then
            Nro := BillofItemData."No." + '_01'
        else
            Nro := INCSTR(BillofItemData."No.");

        //Calculo el total de las l¡neas, incluyendo la propia de la baja
        Qty := 0;
        BillofItemData2.RESET;
        BillofItemData2.SETRANGE("Cod. Cost database", BillofItemData."Cod. Cost database");
        BillofItemData2.SETRANGE("Cod. Piecework", BillofItemData."Cod. Piecework");
        BillofItemData2.SETRANGE(Use, BillofItemData.Use);
        BillofItemData2.SETRANGE("Father Code", BillofItemData."Father Code");  //Tienen que estar al mismo nivel, por tanto todos tienen el mismo padre
        if (BillofItemData2.FINDSET(FALSE)) then
            repeat
                Qty += BillofItemData2."Piecework Cost";
            until (BillofItemData2.NEXT = 0);

        //Ajusto campos de datos
        BillofItemData."No." := Nro;                                     //Cada uno debe tener un c¢digo £nico, si no los mezclar¡a si se cargan en el proyecto sin repartir
        BillofItemData.Type := BillofItemData.Type::Percentage;
        //BillofItemData."Quantity By" := ROUND(Qty / 100, opcDecDesCan);
        BillofItemData."Direct Unit Cost" := Qty;
    end;

    /*begin
    //{
//      NZG 11/01/18: - QBV009 A¤adida funcionalidad para rellenar en "Description 2" la parte de texto que no cabe en Description.
//      QMD 15/03/18: - Q887 Errores varios al importar Preciario
//      PEL         : - QB3684 Corregir "limite" de 99 entradas.
//      PEG 08/10/18: - QVE2845 A¤adida una condici¢n mas para que no corte l¡neas que no deb¡an ser cortadas en los textos adicionales.
//      PGM 26/10/18: - QVE4501 Cambiado el Validate por una asignaci¢n para evitar un error de relacion entre tablas.
//      JMMA01      : - Se modifica proceso de importaci¢n para que si se omiten descompuestos y se elige crear recursos ponga como c¢digo de recurso preciario+c¢digo de presto
//      JAV 01/03/18: - Se cambia al crear productos el grupo contable de recurso por el de producto, que estaba mal configurado
//                    - Se cambian los datos por defecto fijos por los configurados
//                    - Se verifica que tenga nombres de ficheros antes de empezar el proceso, no tras eliminar datos
//                    - Si falta uno de los ficheros se pregunta si usar el mismo del otro
//                    - Solo pregunta sobre borrar si ya tiene datos
//      JAV 05/08/19: - Se cambia el manejo de las sesiones por lo est ndar, se elimina la variable sessionR pues la tabla ya no se usa en Business Central
//      JAV 20/09/19: - Se modifica para que tome las nuevas funciones de c lculo de unidades de mediciones
//      JAV 10/12/21: - QB 1.10.08 Se amplian de 10 a 20 variables locales que estaban mal definidas
//      JAV 22/04/22: - QB 1.10.36 Se corrige un error con la variable usada para tomar el CA de los descompuestos
//                                 Se unifica la funci¢n que busca el CA asociado a la l¡nea de descompuesto para que solo est‚ una vez en el c¢digo
//      JAV 16/11/22: - QB 1.12.19 A¤adido el manejo de los tipos de l¡nea en las mediciones
//      JAV 27/11/22: - QB 1.12.24 Se cambia por completo el proceso de carga:
//                      - Mejora el manejo general de la p gina de opciones, se a¤aden par metros
//                      - Cambio en la forma de obtener los decimales de los redondeos
//                      - Se a¤anden m s datos en la tabla auxiliar
//                      - Se cambia por completo la forma de procesar los datos desde la tabla auxiliar
//                      - Se incluye la carga de cap¡tulos y partidas dentro de los descompuestos, carga por niveles
//                      - Se mira si hay errores en la carga
//                      - Se cambia la forma de obtener los datos de las l¡neas del detalle de mediciones, ya que no sirve solo ver el c¢digo de la unidad, se puede usar en varios lugares el mismo c¢digo
//      AML 02/06/23    - Q18285,Q18970 No se permite la creaci¢n de l¡neas indeterminadas. Se crean recursos.
//      AML 20/06/23    - Q19780 Se comenta una linea que genera un error en ciertas casuisticas.
//      AML 29/08/23    - Q20047 Ajustes para costes directos e indirectos.
//    }
    end.
  */

}




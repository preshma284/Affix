report 7207300 "QB Export Cost Database Excel"
{


    CaptionML = ENU = 'Import Cost Database from Excel', ESP = 'Importar preciario desde Excel';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Cost Database"; "Cost Database")
        {

            ;
            DataItem("Piecework"; "Piecework")
            {

                DataItemTableView = SORTING("Cost Database Default", "No.");
                DataItemLink = "Cost Database Default" = FIELD("Code");
                DataItem("Bill of Item Data"; "Bill of Item Data")
                {

                    DataItemTableView = SORTING("Cod. Cost database", "Cod. Piecework", "Use", "Type", "No.");
                    DataItemLink = "Cod. Cost database" = FIELD("Cost Database Default"),
                            "Cod. Piecework" = FIELD("No.");
                    trigger OnPreDataItem();
                    BEGIN
                        IF (opcTipo = opcTipo::Coste) THEN
                            SETRANGE(Use, "Bill of Item Data".Use::Cost)
                        ELSE
                            SETRANGE(Use, "Bill of Item Data".Use::Sales);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        tmpExcelBuffer.NewRow;
                        AddText("Bill of Item Data"."No.");
                        IF ("Bill of Item Data".Type = "Bill of Item Data".Type::Item) THEN
                            AddText('Material')
                        ELSE
                            AddText('Mano de obra');
                        AddText("Bill of Item Data"."Units of Measure");
                        AddText("Bill of Item Data".Description + ' ' + "Bill of Item Data"."Description 2");

                        AddText('');
                        AddText('');
                        AddText('');
                        AddText('');
                        AddText('');
                        AddText('');

                        AddNum("Bill of Item Data"."Quantity By");
                        AddNum("Bill of Item Data"."Direct Unit Cost");
                        AddNum("Bill of Item Data"."Piecework Cost");
                    END;


                }
                DataItem("Measure Line Piecework PRESTO"; "Measure Line Piecework PRESTO")
                {

                    DataItemTableView = SORTING("Cost Database Code", "Use", "Cod. Jobs Unit", "Line No.");
                    DataItemLink = "Cost Database Code" = FIELD("Cost Database Default"),
                            "Cod. Jobs Unit" = FIELD("No.");
                    trigger OnPreDataItem();
                    BEGIN
                        IF (opcTipo = opcTipo::Coste) THEN
                            SETRANGE(Use, "Measure Line Piecework PRESTO".Use::Cost)
                        ELSE
                            SETRANGE(Use, "Measure Line Piecework PRESTO".Use::Sales);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        tmpExcelBuffer.NewRow;
                        AddText('');
                        AddText('');
                        AddText('');
                        AddText('');
                        AddText("Measure Line Piecework PRESTO".Description);
                        AddNum("Measure Line Piecework PRESTO".Units);
                        AddNum("Measure Line Piecework PRESTO".Length);
                        AddNum("Measure Line Piecework PRESTO".Width);
                        AddNum("Measure Line Piecework PRESTO".Height);
                        AddNum("Measure Line Piecework PRESTO".Total);
                    END;


                }


                trigger OnAfterGetRecord();
                BEGIN
                    tmpExcelBuffer.NewRow;
                    tmpExcelBuffer.NewRow;
                    AddText(Piecework."No.");
                    IF (Piecework."Account Type" = Piecework."Account Type"::Heading) THEN
                        AddText('Cap¡tulo')
                    ELSE
                        AddText('Partida');
                    AddText(Piecework."Units of Measure");
                    AddText(Piecework.Description + ' ' + Piecework."Description 2");

                    AddText('');
                    AddText('');
                    AddText('');
                    AddText('');
                    AddText('');
                    AddText('');

                    IF (opcTipo = opcTipo::Coste) THEN BEGIN
                        AddNum(Piecework."Measurement Cost");
                        AddNum(Piecework."Price Cost");
                        AddNum(Piecework."Total Amount Cost");
                    END ELSE BEGIN
                        AddNum(Piecework."Measurement Sale");
                        AddNum(Piecework."Proposed Sale Price");
                        AddNum(Piecework."Total Amount Sales");
                    END;

                    AddText(Piecework."PRESTO Code Cost");
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                tmpExcelBuffer.SetCurrent(0, 0); //Inicializo la excel

                tmpExcelBuffer.NewRow;
                AddCab("Cost Database".Description);
                tmpExcelBuffer.NewRow;
                AddCab('Presupuesto');
                tmpExcelBuffer.NewRow;
                AddCab('C¢digo');
                AddCab('Naturaleza');
                AddCab('Ud.');
                AddCab('Descripci¢n');
                AddCab('Medida');
                AddCab('Unidades');
                AddCab('Longitud');
                AddCab('Anchura');
                AddCab('Altura');
                AddCab('Medida');
                AddCab('Cantidad');
                AddCab('Precio');
                AddCab('Importe');
                AddCab('Cod. Presto');
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group438")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcTipo"; "opcTipo")
                    {

                        CaptionML = ESP = 'Tipo';
                    }
                    group("group440")
                    {

                        CaptionML = ESP = 'Formato de la excel';
                        //verify
                        field("GetCol(colPiecework)"; GetCol(colPiecework))
                        {

                            CaptionML = ESP = 'Col. para C¢digo U.O.';
                        }
                        field("GetCol(colPresto)"; GetCol(colPresto))
                        {

                            CaptionML = ESP = 'Col. para C¢digo Presto';
                        }
                        field("GetCol(colTipo)"; GetCol(colTipo))
                        {

                            CaptionML = ESP = 'Col. para Tipo';
                        }
                        field("GetCol(colUM)"; GetCol(colUM))
                        {

                            CaptionML = ESP = 'Col. para U.M.';
                        }
                        field("GetCol(colDescripcion)"; GetCol(colDescripcion))
                        {

                            CaptionML = ESP = 'Col. para Descripci¢n';
                        }
                        field("GetCol(colCantidad)"; GetCol(colCantidad))
                        {

                            CaptionML = ESP = 'Col. para Cantidad';
                        }
                        field("GetCol(colDesUnidades)"; GetCol(colDesUnidades))
                        {

                            CaptionML = ESP = 'Col. para Descr.Unidades';
                        }
                        field("GetCol(colNunidades)"; GetCol(colNunidades))
                        {

                            CaptionML = ESP = 'Col. para N§ Unidades';
                        }
                        field("GetCol(colLong)"; GetCol(colLong))
                        {

                            CaptionML = ESP = 'Col. para Largo';
                        }
                        field("GetCol(colAncho)"; GetCol(colAncho))
                        {

                            CaptionML = ESP = 'Col. para Ancho';
                        }
                        field("GetCol(colAlto)"; GetCol(colAlto))
                        {

                            CaptionML = ESP = 'Col. para Alto';
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
        END;


    }
    labels
    {
    }

    var
        //       tmpExcelBuffer@1021 :
        tmpExcelBuffer: Record 370 TEMPORARY;
        //       Window@1007 :
        Window: Dialog;
        //       ServerFileName@1025 :
        ServerFileName: Text;
        //       SheetName@1013 :
        SheetName: Text[250];
        //       ToCostBudgetName@1012 :
        ToCostBudgetName: Code[10];
        //       LineNo@7001108 :
        LineNo: Integer;
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
        opcTipo: Option "Coste","Venta";
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



    trigger OnInitReport();
    begin
        firstLine := 4;
        colPiecework := 1;
        colTipo := 2;
        colUM := 3;
        colDescripcion := 4;
        colDesUnidades := 5;
        colNunidades := 6;
        colLong := 7;
        colAncho := 8;
        colAlto := 9;
        colCantidad := 11;
        colPrecio := 12;
        colPresto := 14;

        opcTipo := opcTipo::Coste;
    end;

    trigger OnPreReport();
    begin
        tmpExcelBuffer.RESET;
        tmpExcelBuffer.DELETEALL;
        Window.OPEN('Importando #1#######');
    end;

    trigger OnPostReport();
    begin
        Window.CLOSE;

        tmpExcelBuffer.CreateBookAndOpenExcel(TEMPORARYPATH + 'Preciario.xlsx', 'Coste', 'Preciario Coste', COMPANYNAME, USERID);
    end;



    // LOCAL procedure GetCol (pNum@1100286000 :
    LOCAL procedure GetCol(pNum: Integer): Code[2];
    begin
        txtCol := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        if (pNum = 0) then
            exit('');

        if (pNum < STRLEN(txtCol)) then
            exit(COPYSTR(txtCol, pNum, 1))
        else
            exit(COPYSTR(txtCol, ROUND(pNum / 10, 0), 1) + COPYSTR(txtCol, pNum - ROUND(pNum / 10) * 10, 1));
    end;

    //     LOCAL procedure AddCab (pText@1100286000 :
    LOCAL procedure AddCab(pText: Text)
    begin
        pText := DELCHR(pText, '<>', ' ');
        tmpExcelBuffer.AddColumn(pText, FALSE, '', TRUE, FALSE, FALSE, '', tmpExcelBuffer."Cell Type"::Text);
    end;

    //     LOCAL procedure AddText (pText@1100286000 :
    LOCAL procedure AddText(pText: Text)
    begin
        pText := DELCHR(pText, '<>', ' ');
        tmpExcelBuffer.AddColumn(pText, FALSE, '', FALSE, FALSE, FALSE, '', tmpExcelBuffer."Cell Type"::Text);
    end;

    //     LOCAL procedure AddNum (pNum@1100286000 :
    LOCAL procedure AddNum(pNum: Decimal)
    begin
        tmpExcelBuffer.AddColumn(FORMAT(pNum), FALSE, '', FALSE, FALSE, FALSE, '', tmpExcelBuffer."Cell Type"::Number);
    end;

    /*begin
    end.
  */

}




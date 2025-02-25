report 7207454 "QPR Export Budget Excel"
{


    CaptionML = ENU = 'Import Cost Database from Excel', ESP = 'Importar preciario desde Excel';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Job"; "Job")
        {

            ;
            DataItem("DataPieceworkForProduction"; "Data Piecework For Production")
            {

                DataItemLink = "Job No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    DataPieceworkForProduction.SETFILTER("Budget Filter", VBudgetCode);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    tmpExcelBuffer.NewRow;
                    AddText(DataPieceworkForProduction."Piecework Code");
                    AddText(DataPieceworkForProduction.Description);
                    AddNum(DataPieceworkForProduction.Indentation);
                    AddText(FORMAT(DataPieceworkForProduction."Account Type"));
                    AddText(FORMAT(DataPieceworkForProduction."QPR Use"));
                    AddText(FORMAT(DataPieceworkForProduction."QPR Type"));
                    AddText(DataPieceworkForProduction."QPR Company");
                    AddText(DataPieceworkForProduction."QPR No.");
                    AddText(DataPieceworkForProduction."QPR Name");
                    AddText(DataPieceworkForProduction."QPR AC");
                    AddText(DataPieceworkForProduction."QPR Gen Prod. Posting Group");
                    AddText(DataPieceworkForProduction."QPR Gen Posting Group");
                    AddText(DataPieceworkForProduction."QPR VAT Prod. Posting Group");
                    DataPieceworkForProduction.CALCFIELDS("QPR Cost Amount", "QPR Sale Amount");
                    AddNum(DataPieceworkForProduction."QPR Cost Amount");
                    AddNum(DataPieceworkForProduction."QPR Sale Amount");
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                Job.SETRANGE("No.", VJobCode);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                tmpExcelBuffer.SetCurrent(0, 0); //Inicializo excel

                tmpExcelBuffer.NewRow;
                AddCab(Job.Description);

                tmpExcelBuffer.NewRow;
                AddCab('Presupuesto');
                AddCab(VBudgetCode);
                tmpExcelBuffer.NewRow;
                AddCab('C¢digo');
                AddCab('Descripci¢n');
                AddCab('Indentar');
                AddCab('Tipo mov.');
                AddCab('Uso');
                AddCab('Tipo');
                AddCab('Empresa');
                AddCab('No.');
                AddCab('Nombre');
                AddCab('Concepto anal¡tico');
                AddCab('Grupo registro de prod.');
                AddCab('Grupo registro general');
                AddCab('Grupo registro IVA prod.');
                AddCab(DataPieceworkForProduction.FIELDCAPTION("QPR Cost Amount"));
                AddCab(DataPieceworkForProduction.FIELDCAPTION("QPR Sale Amount"));
            END;


        }
    }
    requestpage
    {

        layout
        {
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
        //       VJobCode@1100286000 :
        VJobCode: Code[20];
        //       VBudgetCode@1100286016 :
        VBudgetCode: Code[20];



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

        //tmpExcelBuffer.CreateBookAndOpenExcel(TEMPORARYPATH + 'Plantilla Ppto.xlsx', 'L¡neas Ppto', 'L¡neas', COMPANYNAME,USERID);
        tmpExcelBuffer.CreateBook(TEMPORARYPATH + 'Plantilla Ppto.xlsx', 'L¡neas Ppto');
        tmpExcelBuffer.WriteSheet(PADSTR(Job.Description, 30), COMPANYNAME, USERID);
        tmpExcelBuffer.CloseBook;
        tmpExcelBuffer.OpenExcel;
    end;



    // procedure SetParametros (PJobCode@1100286000 : Code[20];PJBCodeFilter@1100286001 :
    procedure SetParametros(PJobCode: Code[20]; PJBCodeFilter: Code[20])
    begin
        VJobCode := PJobCode;
        VBudgetCode := PJBCodeFilter;
    end;

    //     LOCAL procedure GetCol (pNum@1100286000 :
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




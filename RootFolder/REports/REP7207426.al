report 7207426 "Import Excel Prod. Measures"
{


    CaptionML = ENU = 'Import Prod. Measure from Excel', ESP = 'Importar Relaci¢n Valorada desde Excel';
    ProcessingOnly = true;

    dataset
    {

    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group("group820")
                {

                    field("opcUO"; "opcUO")
                    {

                        CaptionML = ESP = 'Tipo de U.O.';
                    }
                    field("opcIncrement"; "opcIncrement")
                    {

                        CaptionML = ESP = '¨Aumentar mediciones autom ticamente?';
                    }
                    group("group823")
                    {

                        CaptionML = ESP = 'Columnas';

                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       ExcelFileExtensionTok@1100286021 :
        ExcelFileExtensionTok:
// {Locked}
TextConst ENU = '.xlsx', ESP = '.xlsx';
        //       tempExcelBuf@1100286004 :
        tempExcelBuf: Record 370 TEMPORARY;
        //       MeasureHD@1100286011 :
        MeasureHD: Record 7207399;
        //       MeasurementLines@1100286006 :
        MeasurementLines: Record 7207400;
        //       Window@1009 :
        Window: Dialog;
        //       ServerFileName@1033 :
        ServerFileName: Text;
        //       SheetName@1100286003 :
        SheetName: Text[250];
        //       LinUO@1100286001 :
        LinUO: Code[50];
        //       LinNat@1100286008 :
        LinNat: Text;
        //       LinDes@1100286010 :
        LinDes: Text;
        //       LinQty@1100286012 :
        LinQty: Decimal;
        //       Txt000@1100286015 :
        Txt000: TextConst ENU = 'Existen l¡neas en el documento %1. ¨Desea continuar?', ESP = 'Existen l¡neas en el documento %1. ¨Desea continuar?';
        //       Txt001@1100286016 :
        Txt001: TextConst ESP = 'Error, operaci¢n cancelada por el usuario.';
        //       txtErrores@1100286017 :
        txtErrores: Text;
        //       Cap@100000000 :
        Cap: Text;
        //       Linea@1100286025 :
        Linea: Integer;
        //       Ultima@1100286026 :
        Ultima: Integer;
        //       LinDoc@1100286000 :
        LinDoc: Integer;
        //       "---------------------------------- Opciones"@1100286019 :
        "---------------------------------- Opciones": Integer;
        //       opcUO@1100286020 :
        opcUO: Option "Presto","Proyecto";
        //       opcCol@1100286022 :
        opcCol: ARRAY[10] OF Code[2];
        //       Txt002@1100286024 :
        Txt002: TextConst ENU = 'Import Excel File', ESP = 'Importando hoja Excel';
        //       Txt003@1100286023 :
        Txt003: TextConst ENU = 'Analyzing Data...\\', ESP = 'Cargando l¡nea #1####';
        //       Txt004@1100286002 :
        Txt004: TextConst ESP = 'Existen l¡neas no cargadas, ¨desea verlas?';
        //       opcIncrement@1100286005 :
        opcIncrement: Boolean;



    trigger OnPreReport();
    begin
        CheckIfLinesAlready();
        OpenFile;

        if SheetName = '' then
            SheetName := tempExcelBuf.SelectSheetsName(ServerFileName);

        tempExcelBuf.DELETEALL;

        //Rellenamos el excel buffer
        tempExcelBuf.OpenBook(ServerFileName, SheetName);
        tempExcelBuf.FncImportExcelMeasure;  ///INCIDENCIA DECIMALES!!!!!!!!!!!
        tempExcelBuf.ReadSheet;

        //Buscar la ultima l¡nea del documento
        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", MeasureHD."No.");
        if MeasurementLines.FINDLAST then
            LinDoc := MeasurementLines."Line No."
        else
            LinDoc := 0;

        tempExcelBuf.RESET;
        if tempExcelBuf.FINDLAST then
            Ultima := tempExcelBuf."Row No.";

        txtErrores := '';
        Window.OPEN(Txt003);
        FOR Linea := 1 TO Ultima DO begin
            Window.UPDATE(1, FORMAT(Linea));
            Leer(Linea);
        end;
        if (txtErrores <> '') then
            if (CONFIRM(Txt004, TRUE)) then
                MESSAGE(txtErrores);
    end;



    // LOCAL procedure Leer (pLinea@1100286000 :
    LOCAL procedure Leer(pLinea: Integer)
    begin
        LinUO := '';
        LinNat := '';
        LinDes := '';
        LinQty := 0;

        tempExcelBuf.RESET;
        tempExcelBuf.SETRANGE("Row No.", pLinea);

        tempExcelBuf.SETRANGE(xlColID, opcCol[1]);
        if tempExcelBuf.FINDFIRST then
            LinUO := tempExcelBuf."Cell Value as Text";

        tempExcelBuf.SETRANGE(xlColID, opcCol[2]);
        if tempExcelBuf.FINDFIRST then
            LinNat := COPYSTR(UPPERCASE(tempExcelBuf."Cell Value as Text"), 1, 1);

        tempExcelBuf.SETRANGE(xlColID, opcCol[3]);
        if tempExcelBuf.FINDFIRST then
            LinDes := tempExcelBuf."Cell Value as Text";

        tempExcelBuf.SETRANGE(xlColID, opcCol[4]);
        if tempExcelBuf.FINDFIRST then
            if not EVALUATE(LinQty, tempExcelBuf."Cell Value as Text") then
                LinQty := 0;

        if (LinUO <> '') and (LinQty <> 0) then
            CASE LinNat OF
                'C':
                    Cap := LinUO;
                'P':
                    CrearLineasDoc(LinUO, LinDes, LinQty);
            end;
    end;

    LOCAL procedure OpenFile()
    var
        //       FileMgt@1100286000 :
        FileMgt: Codeunit 419;
    begin
        if ServerFileName = '' then
            ServerFileName := FileMgt.UploadFile(Txt002, ExcelFileExtensionTok);
    end;


    //     procedure SetFileName (NewFileName@1000 :
    procedure SetFileName(NewFileName: Text)
    begin
        ServerFileName := NewFileName;
    end;

    //     procedure SetFilters (var pProdMeasureHeader@1100286002 :
    procedure SetFilters(var pProdMeasureHeader: Record 7207399)
    begin

        MeasureHD := pProdMeasureHeader;
    end;

    //     LOCAL procedure CrearLineasDoc (pCodUO@1100286000 : Text;pDesc@1100286003 : Text;pQty@1100286010 :
    LOCAL procedure CrearLineasDoc(pCodUO: Text; pDesc: Text; pQty: Decimal)
    var
        //       QText003@1100286006 :
        QText003: TextConst ENU = 'The resource for VAT Identification No. %1 does not exist.', ESP = 'El recurso para el NIF %1 no existe.';
        //       QText004@1100286008 :
        QText004: TextConst ENU = 'The Job for AS400 Code %1 does not exist.', ESP = 'El proyecto para el Codigo AS400 %1 no existe.';
        //       QText005@1100286009 :
        QText005: TextConst ENU = 'There are not allocation records for job %1, activity code %2 and budget %3.', ESP = 'No existen registros de asignacion para proyecto %1, codigo de actividad %2 y presupuesto %3.';
        //       MeasurementLines@1100286004 :
        MeasurementLines: Record 7207400;
        //       Nolin@1100286005 :
        Nolin: Integer;
        //       DataPieceworkForProd@1100286007 :
        DataPieceworkForProd: Record 7207386;
        //       DataPieceworkForProd2@100000000 :
        DataPieceworkForProd2: Record 7207386;
    begin
        DataPieceworkForProd.RESET;
        DataPieceworkForProd.SETRANGE("Job No.", MeasureHD."Job No.");
        CASE opcUO OF
            opcUO::Presto:
                DataPieceworkForProd.SETRANGE("Code Piecework PRESTO", pCodUO);
            opcUO::Proyecto:
                DataPieceworkForProd.SETRANGE("Piecework Code", pCodUO);
        end;
        //JMMA
        if (Cap <> '') and (opcUO = opcUO::Presto) then begin
            DataPieceworkForProd2.RESET;
            DataPieceworkForProd2.SETRANGE("Job No.", MeasureHD."Job No.");
            DataPieceworkForProd2.SETRANGE("Code Piecework PRESTO", Cap);
            if DataPieceworkForProd2.FINDFIRST then
                DataPieceworkForProd.SETFILTER("Piecework Code", '%1', DataPieceworkForProd2."Piecework Code" + '*');
        end;
        //JMMA

        if DataPieceworkForProd.FINDFIRST then begin
            LinDoc += 10000;
            MeasurementLines.SetAutoIncrement;
            MeasurementLines.INIT;
            MeasurementLines."Document No." := MeasureHD."No.";
            MeasurementLines."Line No." := LinDoc;
            MeasurementLines.VALIDATE("Job No.", MeasureHD."Job No.");
            MeasurementLines.VALIDATE("Piecework No.", DataPieceworkForProd."Piecework Code");
            MeasurementLines.INSERT(TRUE);
            MeasurementLines.Description := COPYSTR(pDesc, 1, MAXSTRLEN(MeasurementLines.Description));
            MeasurementLines.VALIDATE("Measure Source", pQty);
            MeasurementLines.MODIFY(TRUE);
        end else begin
            txtErrores += pCodUO + ', ';
        end;
    end;

    LOCAL procedure CheckIfLinesAlready()
    var
        //       GenJnlLine@1100286002 :
        GenJnlLine: Record 81;
        //       QText001@1100286003 :
        QText001: TextConst ENU = 'There are already lines for general journal template %1 and Batch %2, do you want to continue and delete them all?', ESP = 'Ya existen l¡neas para el diario general con plantilla %1 y secci¢n %2, desea continuar y borrarlas todas?';
        //       QText002@1100286004 :
        QText002: TextConst ENU = 'Process ended by user.', ESP = 'Proceso terminado por el usuario.';
    begin
        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", MeasureHD."No.");
        if MeasurementLines.FINDFIRST then
            if not CONFIRM(Txt000, TRUE, MeasureHD."No.") then
                ERROR(Txt001);
    end;

    /*begin
    end.
  */

}




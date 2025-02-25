report 7207427 "Import Excel Medition"
{


    CaptionML = ENU = 'Importar informaci¢n desde Excel', ESP = 'Importar informaci¢n desde Excel';
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
                group("group829")
                {

                    field("opcUO"; "opcUO")
                    {

                        CaptionML = ESP = 'Tipo de U.O.';
                    }
                    group("group831")
                    {

                        CaptionML = ESP = 'Excel';
                        field("opcFirst"; "opcFirst")
                        {

                            CaptionML = ESP = 'Primera L¡nea';
                        }

                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       tempExcelBuf@1100286035 :
        tempExcelBuf: Record 370 TEMPORARY;
        //       tempMeasurementLines@1100286000 :
        tempMeasurementLines: Record 7207337 TEMPORARY;
        //       MeasureHD@1100286034 :
        MeasureHD: Record 7207336;
        //       MeasurementLines@1100286033 :
        MeasurementLines: Record 7207337;
        //       Window@1100286032 :
        Window: Dialog;
        //       ServerFileName@1100286031 :
        ServerFileName: Text;
        //       SheetName@1100286030 :
        SheetName: Text[250];
        //       LinUO@1100286029 :
        LinUO: Code[50];
        //       LinDes@1100286026 :
        LinDes: Text;
        //       LinQty@1100286025 :
        LinQty: Decimal;
        //       txtMensajes@1100286024 :
        txtMensajes: Text;
        //       Cap@1100286023 :
        Cap: Text;
        //       Linea@1100286022 :
        Linea: Integer;
        //       Ultima@1100286021 :
        Ultima: Integer;
        //       LinDoc@1100286020 :
        LinDoc: Integer;
        //       "---------------------------------- Opciones"@1100286019 :
        "---------------------------------- Opciones": Integer;
        //       opcUO@1100286017 :
        opcUO: Option "Presto","Proyecto";
        //       opcCol@1100286014 :
        opcCol: ARRAY[10] OF Code[2];
        //       ExcelFileExtensionTok@1100286010 :
        ExcelFileExtensionTok:
// {Locked}
TextConst ENU = '.xlsx', ESP = '.xlsx';
        //       Txt000@1100286009 :
        Txt000: TextConst ENU = 'Existen l¡neas en el documento %1. ¨Desea continuar?', ESP = 'Existen l¡neas en el documento %1. ¨Desea continuar?';
        //       Txt001@1100286008 :
        Txt001: TextConst ESP = 'Error, operaci¢n cancelada por el usuario.';
        //       Txt002@1100286007 :
        Txt002: TextConst ENU = 'Import Excel File', ESP = 'Importando hoja Excel';
        //       Txt003@1100286005 :
        Txt003: TextConst ENU = 'Analyzing Data...\\', ESP = 'Cargando l¡nea #1####';
        //       Txt004@1100286003 :
        Txt004: TextConst ESP = 'Existen l¡neas no cargadas, ¨desea verlas?';
        //       opcFirst@1100286001 :
        opcFirst: Integer;



    trigger OnInitReport();
    begin
        opcFirst := 5;
    end;

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

        //JAV 17/11/20: - QB 1.07.06 Marcamos no dar mensajes
        MeasurementLines.SetSkipAllMessages(TRUE);

        tempExcelBuf.RESET;
        if tempExcelBuf.FINDLAST then
            Ultima := tempExcelBuf."Row No.";

        txtMensajes := '';
        Window.OPEN(Txt003);
        FOR Linea := opcFirst TO Ultima DO begin
            Window.UPDATE(1, FORMAT(Linea));
            Leer(Linea);
        end;

        //JAV 17/11/20: - QB 1.07.06 Quitamos la marca de no dar mensajes
        MeasurementLines.SetSkipAllMessages(FALSE);

        if (txtMensajes <> '') then
            txtMensajes := 'De las l¡neas leidas:' + DELCHR(txtMensajes, '>', ', ');

        tempMeasurementLines.RESET;
        if (tempMeasurementLines.FINDSET) then begin
            txtMensajes += '\\U.O. no modificadas por la importaci¢n: ';
            repeat
                txtMensajes += tempMeasurementLines."Piecework No." + ', ';
            until tempMeasurementLines.NEXT = 0;
            txtMensajes := DELCHR(txtMensajes, '>', ', ');
        end;

        if (txtMensajes <> '') then
            //if (CONFIRM(Txt004,TRUE)) then
            MESSAGE(txtMensajes);
    end;



    // LOCAL procedure Leer (pLinea@1100286000 :
    LOCAL procedure Leer(pLinea: Integer)
    var
        //       DataPieceworkForProduction@1100286001 :
        DataPieceworkForProduction: Record 7207386;
    begin
        LinUO := '';
        LinDes := '';
        LinQty := 0;

        tempExcelBuf.RESET;
        tempExcelBuf.SETRANGE("Row No.", pLinea);

        tempExcelBuf.SETRANGE(xlColID, opcCol[1]);
        if tempExcelBuf.FINDFIRST then
            LinUO := tempExcelBuf."Cell Value as Text";

        tempExcelBuf.SETRANGE(xlColID, opcCol[3]);
        if tempExcelBuf.FINDFIRST then
            LinDes := tempExcelBuf."Cell Value as Text";

        tempExcelBuf.SETRANGE(xlColID, opcCol[4]);
        if tempExcelBuf.FINDFIRST then
            if not EVALUATE(LinQty, tempExcelBuf."Cell Value as Text") then begin
                LinQty := 0;
                txtMensajes += '\   Cantidad no num‚rica en Lin.' + FORMAT(pLinea) + ' (' + LinUO + ') ';
            end;

        if (LinQty < 0) then begin
            LinQty := 0;
            txtMensajes += '\   Cantidad origen negativa en Lin.' + FORMAT(pLinea) + ' (' + LinUO + ') ';
        end;


        //Busco la U.O.
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", MeasureHD."Job No.");
        CASE opcUO OF
            opcUO::Presto:
                DataPieceworkForProduction.SETRANGE("Code Piecework PRESTO", LinUO);
            opcUO::Proyecto:
                DataPieceworkForProduction.SETRANGE("Piecework Code", LinUO);
        end;
        if not DataPieceworkForProduction.FINDFIRST then begin
            DataPieceworkForProduction.INIT;
            txtMensajes += '\   UO no existe en Lin.' + FORMAT(pLinea) + ' (' + LinUO + ') ';
        end else begin
            DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements");
            if (LinQty < DataPieceworkForProduction."Quantity in Measurements") then
                txtMensajes += '\   Se reduce la medici¢n en Lin.' + FORMAT(pLinea) + ' (' + LinUO + ') ';
            if (LinQty > DataPieceworkForProduction."Sale Quantity (base)") then
                txtMensajes += '\   Se sobrepasa el 100% en Lin.' + FORMAT(pLinea) + ' (' + LinUO + ') ';
        end;

        //JMMA
        if (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit) then
            CrearLineasDoc(LinUO, LinDes, LinQty);
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

    //     procedure SetFilters (var pMeasurementHeader@1100286002 :
    procedure SetFilters(var pMeasurementHeader: Record 7207336)
    begin
        MeasureHD := pMeasurementHeader;
    end;

    //     LOCAL procedure CrearLineasDoc (pCodUO@1100286000 : Text;pResumen@1100286003 : Text;pQty@1100286010 :
    LOCAL procedure CrearLineasDoc(pCodUO: Text; pResumen: Text; pQty: Decimal)
    var
        //       QText003@1100286006 :
        QText003: TextConst ENU = 'The resource for VAT Identification No. %1 does not exist.', ESP = 'El recurso para el NIF %1 no existe.';
        //       QText004@1100286008 :
        QText004: TextConst ENU = 'The Job for AS400 Code %1 does not exist.', ESP = 'El proyecto para el Codigo AS400 %1 no existe.';
        //       QText005@1100286009 :
        QText005: TextConst ENU = 'There are not allocation records for job %1, activity code %2 and budget %3.', ESP = 'No existen registros de asignacion para proyecto %1, codigo de actividad %2 y presupuesto %3.';
        //       MeasurementLines@1100286004 :
        MeasurementLines: Record 7207337;
        //       Nolin@1100286005 :
        Nolin: Integer;
    begin

        if MeasureHD."Document Type" = MeasureHD."Document Type"::Certification then begin
            FncCheckCertification(pCodUO, pQty, Nolin);
            exit;
        end;

        //JAV 26/03/21: - QB 1.08.29 Si no existe la l¡nea crear una nueva, si existe reemplazamos los valores
        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", MeasureHD."No.");
        MeasurementLines.SETRANGE("Piecework No.", pCodUO);
        if (not MeasurementLines.FINDFIRST) then begin
            LinDoc += 10000;
            MeasurementLines.INIT;
            MeasurementLines."Document type" := MeasureHD."Document Type";
            MeasurementLines."Document No." := MeasureHD."No.";
            MeasurementLines."Line No." := LinDoc;
            MeasurementLines.INSERT(TRUE);
        end;

        MeasurementLines.VALIDATE("Piecework No.", pCodUO);
        MeasurementLines.Description := COPYSTR(pResumen, 1, 50);
        MeasurementLines.SetSkipMessages(TRUE);
        MeasurementLines.VALIDATE("Med. Source Measure", pQty);
        MeasurementLines.MODIFY(TRUE);

        //Quito la l¡nea del temporal para saber las que no se han actualizado
        tempMeasurementLines.RESET;
        tempMeasurementLines.SETRANGE("Piecework No.", pCodUO);
        tempMeasurementLines.DELETEALL;
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
        // MeasurementLines.RESET;
        // MeasurementLines.SETRANGE("Document No.",MeasureHD."No.");
        // if MeasurementLines.FINDFIRST then
        //  if not CONFIRM(Txt000,TRUE, MeasureHD."No.") then
        //    ERROR(Txt001);

        //JAV 26/03/21: QB 1.08.29 Pasar las l¡neas existentes a un temporal
        tempMeasurementLines.RESET;
        tempMeasurementLines.DELETEALL;
        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", MeasureHD."No.");
        if (MeasurementLines.FINDSET) then begin
            tempMeasurementLines := MeasurementLines;
            tempMeasurementLines.INSERT;
        end;
    end;

    //     LOCAL procedure FncCheckCertification (var pCode@1100286000 : Text;var pqty@1100286003 : Decimal;var pnolin@1100286004 :
    LOCAL procedure FncCheckCertification(var pCode: Text; var pqty: Decimal; var pnolin: Integer)
    var
        //       HistMeasureLines@1100286002 :
        HistMeasureLines: Record 7207339;
        //       Qty@1100286001 :
        Qty: Decimal;
    begin
        Qty := 0;

        HistMeasureLines.RESET;
        ////HistMeasureLines.SETRANGE("Document No.", MeasureHD."No.");
        HistMeasureLines.SETRANGE("Job No.", MeasureHD."Job No.");
        HistMeasureLines.SETFILTER("Quantity Measure not Cert", '<>%1', 0);
        HistMeasureLines.SETRANGE("Piecework No.", pCode);
        if HistMeasureLines.FINDSET then
            repeat
                //Falta comprobaci¢n de cantidades para traer solo las cantidades necesarias.
                if pqty <= HistMeasureLines."Quantity Measure not Cert" then begin
                    MeasurementLines.INIT;
                    MeasurementLines."Document type" := MeasureHD."Document Type";
                    MeasurementLines."Document No." := MeasureHD."No.";
                    MeasurementLines."Line No." := pnolin;
                    MeasurementLines.VALIDATE("Job No.", MeasureHD."Job No.");
                    MeasurementLines.VALIDATE("Piecework No.", HistMeasureLines."Piecework No.");
                    MeasurementLines.Description := HistMeasureLines.Description;
                    MeasurementLines."Contract Price" := HistMeasureLines."Contract Price";
                    MeasurementLines."Med. Measured Quantity" := HistMeasureLines."Med. Term Measure";
                    MeasurementLines."Cert Medition No." := HistMeasureLines."Document No.";
                    MeasurementLines.VALIDATE("Cert Quantity to Term", HistMeasureLines."Quantity Measure not Cert");
                    MeasurementLines.INSERT;
                    Qty += HistMeasureLines."Quantity Measure not Cert";
                end;
                pqty -= HistMeasureLines."Quantity Measure not Cert";
                pnolin += 10000;
            until (HistMeasureLines.NEXT = 0) or (pqty <= 0);
    end;

    /*begin
    //{
//      JAV 26/03/21: - QB 1.08.29 Si no existe la l¡nea crear una nueva, si existe reemplazamos los valores
//    }
    end.
  */

}




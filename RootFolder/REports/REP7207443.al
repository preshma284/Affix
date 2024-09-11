report 7207443 "QB Generic Import"
{
  ApplicationArea=All;



    CaptionML = ENU = 'QB Generic Import', ESP = 'QB Importaci¢n gen‚rica';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Excel Buffer"; "Excel Buffer")
        {

            DataItemTableView = SORTING("Row No.", "Column No.");
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group930")
                {

                    CaptionML = ENU = 'Option', ESP = 'Opciones';
                    field("ImportCode"; "ImportCode")
                    {

                        CaptionML = ESP = 'Definici¢n de la Importaci¢n';
                        TableRelation = "QB Generic Import Header";
                    }
                    field("LineNo"; "LineNo")
                    {

                        CaptionML = ESP = 'Contador inicial auto incrementales';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       QBImportExport@1100286018 :
        QBImportExport: Codeunit 7206924;
        //       QBGenericImportHeader@1100286014 :
        QBGenericImportHeader: Record 7206940;
        //       QBGenericImportLine@1100286008 :
        QBGenericImportLine: Record 7206941;
        //       QBReplacementLine@1100286012 :
        QBReplacementLine: Record 7206944;
        //       FileManagement@1100286009 :
        FileManagement: Codeunit 419;
        //       OutlookSynchTypeConv@1100286007 :
        OutlookSynchTypeConv: Codeunit 5302;
        //       ServerFileName@1100286000 :
        ServerFileName: Text;
        //       SheetName@1100286001 :
        SheetName: Text;
        //       TotalRows@1100286003 :
        TotalRows: Integer;
        //       X@1100286004 :
        X: Integer;
        //       RecRef@1100286005 :
        RecRef: RecordRef;
        //       RecRef2@1100286010 :
        RecRef2: RecordRef;
        //       LineNo@1100286011 :
        LineNo: Integer;
        //       TableNo@1100286015 :
        TableNo: Integer;
        //       ImportCode@1100286016 :
        ImportCode: Text;
        //       Replaced@1100286006 :
        Replaced: Boolean;
        //       DecimalValue@1100286013 :
        DecimalValue: Decimal;
        //       ExcelValue@1100286017 :
        ExcelValue: Decimal;
        //       fRef@1100286002 :
        fRef: FieldRef;



    trigger OnInitReport();
    begin
        //Establezco el numero inicial para los auto-incrementales, se suma el incremento al valor actual
        LineNo := 0;
    end;

    trigger OnPreReport();
    begin
        if not QBGenericImportHeader.GET(ImportCode) then
            ERROR('No ha definido una configuraci¢n de importaci¢n v lida')
        else
            QBImportExport.Import(QBGenericImportHeader);

        // {---

        // if (QBGenericImportHeader."File Name" <> '') then
        //   ServerFileName := QBGenericImportHeader."File Name"
        // else begin
        //   ServerFileName := FileManagement.UploadFile('Excel Import','.xlsx');
        //   if ServerFileName = '' then
        //     ERROR('');
        // end;

        // if (QBGenericImportHeader."Sheet Name" <> '') then
        //   SheetName := QBGenericImportHeader."Sheet Name"
        // else begin
        //   SheetName := "Excel Buffer".SelectSheetsName(ServerFileName);
        //   if SheetName = '' then
        //     ERROR('');
        // end;

        // "Excel Buffer".LOCKTABLE;
        // "Excel Buffer".OpenBook(ServerFileName,SheetName);
        // "Excel Buffer".ReadSheet;

        // //Busco ultima fila
        // "Excel Buffer".RESET;
        // if "Excel Buffer".FINDLAST then
        //   TotalRows := "Excel Buffer"."Row No.";


        // //Abro el recordref para la tabla
        // TableNo := QBGenericImportHeader."Table ID";
        // RecRef2.OPEN(TableNo);

        // FOR X := (QBGenericImportHeader."Skip from Begginnig" + 1) TO (TotalRows - QBGenericImportHeader."Skip form end") DO
        //   InsertRow(X);

        // RecRef2.CLOSE;

        // "Excel Buffer".DELETEALL;

        // MESSAGE('Importaci¢n finalizada');
        // ---}
    end;



    // LOCAL procedure InsertRow (RowNo@1100286000 :
    LOCAL procedure InsertRow(RowNo: Integer)
    var
        //       I@1100286002 :
        I: Integer;
        //       NumericValue@1100286004 :
        NumericValue: Decimal;
        //       DateValue@1100286008 :
        DateValue: Date;
        //       BoolValue@1100286009 :
        BoolValue: Boolean;
        //       GuidValue@1100286010 :
        GuidValue: GUID;
        //       StringOptions@1100286005 :
        StringOptions: Text;
        //       Pos@1100286006 :
        Pos: Integer;
        //       OptValue@1100286007 :
        OptValue: Integer;
        //       FldRef@1100286001 :
        FldRef: FieldRef;
        //       FldRefKey@1100286012 :
        FldRefKey: FieldRef;
        //       Value@1100286011 :
        Value: Text;
        //       KeyRef@1100286003 :
        KeyRef: KeyRef;
    begin
        Replaced := FALSE;
        if QBGenericImportHeader.Group then begin
            RecRef.OPEN(TableNo);
            RecRef.RESET;

            KeyRef := RecRef.KEYINDEX(1);

            FOR I := 1 TO KeyRef.FIELDCOUNT DO begin
                FldRefKey := KeyRef.FIELDINDEX(I);
                QBGenericImportLine.RESET;
                QBGenericImportLine.SETRANGE("Setup Code", ImportCode);
                QBGenericImportLine.SETRANGE("Table ID", TableNo);
                QBGenericImportLine.SETRANGE("Field No.", FldRefKey.NUMBER);
                if QBGenericImportLine.FINDFIRST then begin
                    FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                    if QBGenericImportLine."Default Value" <> '' then
                        FldRef.SETRANGE(QBGenericImportLine."Default Value")
                    else
                        if GetValueAtCell(RowNo, QBGenericImportLine."Excel Column No", Value) then
                            FldRef.SETRANGE(Value);
                end;
            end;

            QBGenericImportLine.RESET;
            QBGenericImportLine.SETRANGE("Setup Code", ImportCode);
            QBGenericImportLine.SETRANGE("Table ID", TableNo);
            QBGenericImportLine.SETRANGE(Group, TRUE);
            if QBGenericImportLine.FINDSET then
                repeat
                    FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                    if GetValueAtCell(RowNo, QBGenericImportLine."Excel Column No", Value) then
                        FldRef.SETRANGE(Value);
                until QBGenericImportLine.NEXT = 0;

            if not RecRef.FINDFIRST then begin
                QBGenericImportLine.RESET;
                QBGenericImportLine.SETCURRENTKEY(Order);                 //Hay que cargar siempre por orden por los validates
                QBGenericImportLine.SETRANGE("Setup Code", ImportCode);
                QBGenericImportLine.SETRANGE("Table ID", TableNo);
                if QBGenericImportLine.FINDSET then begin
                    RecRef2.INIT;
                    repeat
                        FldRef := RecRef2.FIELD(QBGenericImportLine."Field No.");
                        //Establezco el valor por defecto configurado para el campo
                        if (QBGenericImportLine."Default Value" <> '') then
                            WriteField(FldRef, QBGenericImportLine."Default Value");

                        //Si es de una columna de la Excel y existe el registro en el buffer de Excel, lo proceso
                        if (QBGenericImportLine."Excel Column No" <> 0) then begin
                            if GetValueAtCell(RowNo, QBGenericImportLine."Excel Column No", Value) then begin
                                if QBGenericImportLine."Replacement Code" <> '' then begin
                                    QBReplacementLine.RESET;
                                    QBReplacementLine.SETRANGE("Replacement Code", QBGenericImportLine."Replacement Code");
                                    if QBReplacementLine.FINDSET then
                                        repeat
                                            if Value = QBReplacementLine."External Data" then begin
                                                FldRef.VALIDATE(QBReplacementLine."Internal Data");
                                                Replaced := TRUE;
                                            end;
                                        until QBReplacementLine.NEXT = 0;
                                    if Replaced = FALSE then
                                        WriteField(FldRef, Value);
                                end else
                                    WriteField(FldRef, Value);
                            end;
                        end else if (QBGenericImportLine."Autoincrement By" <> 0) then begin   //Si es autoincremental, lo establezco
                            LineNo += QBGenericImportLine."Autoincrement By";
                            FldRef.VALIDATE(LineNo);
                        end;
                    until QBGenericImportLine.NEXT = 0;

                    if not RecRef2.INSERT(TRUE) then
                        RecRef2.MODIFY(TRUE);
                end;
            end else begin
                QBGenericImportLine.RESET;
                QBGenericImportLine.SETRANGE("Setup Code", ImportCode);
                QBGenericImportLine.SETRANGE("Table ID", TableNo);
                QBGenericImportLine.SETRANGE("Apply Summation", TRUE);
                if QBGenericImportLine.FINDSET then
                    repeat
                        FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                        if GetValueAtCell(RowNo, QBGenericImportLine."Excel Column No", Value) then begin
                            DecimalValue := FldRef.VALUE;
                            EVALUATE(ExcelValue, Value);
                            FldRef.VALIDATE(DecimalValue + ExcelValue);
                        end;
                    until QBGenericImportLine.NEXT = 0;

                RecRef.MODIFY;
            end;

            RecRef.CLOSE;
        end else begin
            QBGenericImportLine.RESET;
            QBGenericImportLine.SETCURRENTKEY(Order);                 //Hay que cargar siempre por orden por los validates
            QBGenericImportLine.SETRANGE("Setup Code", ImportCode);
            QBGenericImportLine.SETRANGE("Table ID", TableNo);
            if QBGenericImportLine.FINDSET then begin
                RecRef2.INIT;
                repeat
                    FldRef := RecRef2.FIELD(QBGenericImportLine."Field No.");
                    //Establezco el valor por defecto configurado para el campo
                    if (QBGenericImportLine."Default Value" <> '') then
                        WriteField(FldRef, QBGenericImportLine."Default Value");

                    //Si es de una columna de la Excel y existe el registro en el buffer de Excel, lo proceso
                    if (QBGenericImportLine."Excel Column No" <> 0) then begin
                        if GetValueAtCell(RowNo, QBGenericImportLine."Excel Column No", Value) then begin
                            if QBGenericImportLine."Replacement Code" <> '' then begin
                                QBReplacementLine.RESET;
                                QBReplacementLine.SETRANGE("Replacement Code", QBGenericImportLine."Replacement Code");
                                if QBReplacementLine.FINDSET then
                                    repeat
                                        if Value = QBReplacementLine."External Data" then begin
                                            FldRef.VALIDATE(QBReplacementLine."Internal Data");
                                            Replaced := TRUE;
                                        end;
                                    until QBReplacementLine.NEXT = 0;
                                if Replaced = FALSE then
                                    WriteField(FldRef, Value);
                            end else
                                WriteField(FldRef, Value);
                        end;
                    end else if (QBGenericImportLine."Autoincrement By" <> 0) then begin   //Si es autoincremental, lo establezco
                        LineNo += QBGenericImportLine."Autoincrement By";
                        FldRef.VALIDATE(LineNo);
                    end;
                until QBGenericImportLine.NEXT = 0;

                if not RecRef2.INSERT(TRUE) then
                    RecRef2.MODIFY(TRUE);
            end;
        end;
    end;

    //     LOCAL procedure GetValueAtCell (RowNo@1100286000 : Integer;ColNo@1100286001 : Integer;var Value@1100286003 :
    LOCAL procedure GetValueAtCell(RowNo: Integer; ColNo: Integer; var Value: Text): Boolean;
    var
        //       ExcelBuffer@1100286002 :
        ExcelBuffer: Record 370;
    begin
        if ExcelBuffer.GET(RowNo, ColNo) then begin
            Value := ExcelBuffer."Cell Value as Text";
            exit(TRUE);
        end;

        exit(FALSE);
    end;

    //     LOCAL procedure WriteField (FldRef@1100286009 : FieldRef;Value@1100286011 :
    LOCAL procedure WriteField(FldRef: FieldRef; Value: Text)
    var
        //       I@1100286008 :
        I: Integer;
        //       NumericValue@1100286007 :
        NumericValue: Decimal;
        //       DateValue@1100286006 :
        DateValue: Date;
        //       BoolValue@1100286005 :
        BoolValue: Boolean;
        //       GuidValue@1100286004 :
        GuidValue: GUID;
        //       StringOptions@1100286003 :
        StringOptions: Text;
        //       Pos@1100286002 :
        Pos: Integer;
        //       OptValue@1100286001 :
        OptValue: Integer;
        //       TempBlob@1100286000 :
        TempBlob: Codeunit "Temp Blob";
    begin
        CASE FORMAT(FldRef.TYPE) OF
            'Integer', 'Decimal':
                begin
                    EVALUATE(NumericValue, Value);
                    //FldRef.VALUE := NumericValue;
                    FldRef.VALIDATE(NumericValue);
                end;
            'Date':
                begin
                    EVALUATE(DateValue, Value);
                    //FldRef.VALUE := DateValue;
                    FldRef.VALIDATE(DateValue);
                end;
            'Boolean':
                begin
                    EVALUATE(BoolValue, Value);
                    //FldRef.VALUE := BoolValue;
                    FldRef.VALIDATE(BoolValue);
                end;
            'GUID':
                begin
                    EVALUATE(GuidValue, Value);
                    //FldRef.VALUE := GuidValue;
                    FldRef.VALIDATE(GuidValue);
                end;
            'Text', 'Code':
                begin
                    //FldRef.VALUE(COPYSTR(Value,1,FldRef.LENGTH));
                    FldRef.VALIDATE(COPYSTR(Value, 1, FldRef.LENGTH));
                end;
            'Option':
                begin
                    OptValue := OutlookSynchTypeConv.TextToOptionValue(Value, FldRef.OPTIONCAPTION);
                    if OptValue >= 0 then
                        //FldRef.VALUE := OptValue;
                        FldRef.VALIDATE(OptValue);
                end;
        end;
    end;

    //     procedure Setrequestpage (ImpoNo@1100286000 : Code[20];NLine@1100286001 :
    procedure Setrequestpage(ImpoNo: Code[20]; NLine: Integer)
    begin
        ImportCode := ImpoNo;
        LineNo := NLine;
    end;

    /*begin
    end.
  */

}





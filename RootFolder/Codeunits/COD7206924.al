Codeunit 7206924 "QB Import Export"
{


    Permissions = TableData 272 = rimd,
                TableData 7000002 = rimd,
                TableData 7000003 = rimd,
                TableData 7000004 = rimd,
                TableData 7000005 = rimd,
                TableData 7000006 = rimd,
                TableData 7000007 = rimd,
                TableData 7000020 = rimd,
                TableData 7000021 = rimd,
                TableData 7000022 = rimd;
    trigger OnRun()
    BEGIN
    END;

    LOCAL PROCEDURE "--------------------------------------------- Importar"();
    BEGIN
    END;

    PROCEDURE Import(QBGenericImportHeader: Record 7206940);
    BEGIN
        //Importaci�n de ficheros
        CASE QBGenericImportHeader.Type OF
            QBGenericImportHeader.Type::Excel:
                ImportExcel(QBGenericImportHeader);
            QBGenericImportHeader.Type::Text,
          QBGenericImportHeader.Type::CSV:
                ImportText(QBGenericImportHeader);
        END;

        MESSAGE('Importaci�n finalizada');
    END;

    PROCEDURE ImportExcel(QBGenericImportHeader: Record 7206940);
    VAR
        ExcelBuffer: Record 370;
        FileManagement: Codeunit 419;
        ServerFileName: Text;
        SheetName: Text;
        TotalRows: Integer;
        RecRef: RecordRef;
        nRow: Integer;
        LineNo: Integer;
    BEGIN
        //Importar en formato Excel
        IF (QBGenericImportHeader."File Name" <> '') THEN
            ServerFileName := QBGenericImportHeader."File Name"
        ELSE BEGIN
            ServerFileName := FileManagement.UploadFile('Excel Import', '.xlsx');
            IF ServerFileName = '' THEN
                ERROR('');
        END;

        IF (QBGenericImportHeader."Sheet Name" <> '') THEN
            SheetName := QBGenericImportHeader."Sheet Name"
        ELSE BEGIN
            SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
            IF SheetName = '' THEN
                ERROR('');
        END;

        ExcelBuffer.LOCKTABLE;
        ExcelBuffer.OpenBook(ServerFileName, SheetName);
        ExcelBuffer.ReadSheet;

        //Busco ultima fila
        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";


        //Proceso el fichero por filas
        LineNo := 0;
        FOR nRow := (QBGenericImportHeader."Skip from Begginnig" + 1) TO (TotalRows - QBGenericImportHeader."Skip form End") DO BEGIN
            InsertLine(QBGenericImportHeader, ExcelBuffer, nRow, '', LineNo);
        END;

        ExcelBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE ImportText(QBGenericImportHeader: Record 7206940);
    VAR
        ExcelBuffer: Record 370;
        FileManagement: Codeunit 419;
        ServerFileName: Text;
        SheetName: Text;
        RecRef: RecordRef;
        Fichero: File;
        IStream: InStream;
        Linea: Text;
        TotLines: Integer;
        NumLine: Integer;
        LineNo: Integer;
    BEGIN
        //Importar en formato de texto plano
        IF (QBGenericImportHeader."File Name" <> '') THEN
            ServerFileName := QBGenericImportHeader."File Name"
        ELSE BEGIN
            CASE QBGenericImportHeader.Type OF
                QBGenericImportHeader.Type::Text:
                    ServerFileName := FileManagement.UploadFile('Text Import', '.txt');
                QBGenericImportHeader.Type::CSV:
                    ServerFileName := FileManagement.UploadFile('CSV Import', '.csv');
            END;
            IF ServerFileName = '' THEN
                ERROR('');
        END;

        Fichero.TEXTMODE := TRUE;
        Fichero.WRITEMODE := FALSE;

        //Contar las l�neas
        Fichero.OPEN(ServerFileName);
        Fichero.CREATEINSTREAM(IStream);
        TotLines := 0;
        WHILE (NOT IStream.EOS) DO BEGIN
            IStream.READTEXT(Linea);
            TotLines += 1;
        END;
        Fichero.CLOSE;

        //Procesar
        Fichero.OPEN(ServerFileName);
        Fichero.CREATEINSTREAM(IStream);

        LineNo := 0;
        NumLine := 0;
        WHILE (NOT IStream.EOS) DO BEGIN
            NumLine += 1;
            IStream.READTEXT(Linea);
            IF (NumLine > QBGenericImportHeader."Skip from Begginnig") AND (TotLines - NumLine + 1 > QBGenericImportHeader."Skip form End") THEN
                InsertLine(QBGenericImportHeader, ExcelBuffer, 0, Linea, LineNo);
        END;

        Fichero.CLOSE;
    END;

    LOCAL PROCEDURE "------------------------- Auxiliares Import"();
    BEGIN
    END;

    LOCAL PROCEDURE Replace(pCode: Code[20]; VAR pValue: Text);
    VAR
        QBReplacementLine: Record 7206944;
    BEGIN
        //Si hay que reemplazar por una substituci�n, cambio el valor de la variable directamente
        IF (QBReplacementLine.GET(pCode, pValue)) THEN
            pValue := QBReplacementLine."Internal Data";
    END;

    LOCAL PROCEDURE InsertLine(QBGenericImportHeader: Record 7206940; VAR ExcelBuffer: Record 370; RowNo: Integer; Linea: Text; VAR LineNo: Integer);
    VAR
        QBGenericImportLine: Record 7206941;
        RR: RecordRef;
        FR: FieldRef;
        Exist: Boolean;
        Value: Text;
        Value1: Text;
        NumericValue1: Decimal;
        NumericValue2: Decimal;
        Read: Boolean;
    BEGIN
        RR.OPEN(QBGenericImportHeader."Table ID");

        //Si cargo agrupado primero debo buscar el registro que modificar, si no puedo dejar el init directamente
        Exist := FALSE;
        IF (QBGenericImportHeader.Group) THEN BEGIN
            QBGenericImportLine.RESET;
            QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
            QBGenericImportLine.SETRANGE("Table ID", QBGenericImportHeader."Table ID");
            QBGenericImportLine.SETRANGE(Group, TRUE);
            IF QBGenericImportLine.FINDSET(FALSE) THEN BEGIN
                REPEAT
                    FR := RR.FIELD(QBGenericImportLine."Field No.");
                    CASE QBGenericImportHeader.Type OF
                        QBGenericImportHeader.Type::Excel:
                            Read := GetValueAtCell(ExcelBuffer, QBGenericImportLine, RowNo, Value);
                        QBGenericImportHeader.Type::Text:
                            Read := GetValueAtPos(Linea, QBGenericImportLine, FR, Value);
                        QBGenericImportHeader.Type::CSV:
                            Read := GetValueAtNum(Linea, QBGenericImportLine, FR, QBGenericImportHeader.Sep, QBGenericImportHeader.Del, Value);
                    END;
                    IF (Read) THEN BEGIN
                        //Si hay que reemplazar por una substituci�n
                        IF QBGenericImportLine."Replacement Code" <> '' THEN //jmma 211020
                            Replace(QBGenericImportLine."Replacement Code", Value);

                        FR.SETRANGE(Value);
                    END;
                UNTIL QBGenericImportLine.NEXT = 0;

                Exist := RR.FINDFIRST;
            END;
        END;

        IF (NOT Exist) THEN
            RR.INIT;

        //Cargamos los campos
        QBGenericImportLine.RESET;
        QBGenericImportLine.SETCURRENTKEY(Order);   //Hay que cargar siempre por orden por los validates
        QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
        QBGenericImportLine.SETRANGE("Table ID", QBGenericImportHeader."Table ID");
        IF QBGenericImportLine.FINDSET(FALSE) THEN
            REPEAT
                FR := RR.FIELD(QBGenericImportLine."Field No.");

                //Establezco el valor por defecto configurado para el campo
                IF (NOT Exist) AND (QBGenericImportLine."Default Value" <> '') THEN
                    WriteField(FR, QBGenericImportLine."Default Value");

                //Si es autoincremental, lo establezco solo si no estoy agrupando el registro
                IF (NOT Exist) AND (QBGenericImportLine."Autoincrement By" <> 0) THEN BEGIN
                    IF (QBGenericImportLine."Autoincrement By" = 0) THEN
                        QBGenericImportLine."Autoincrement By" := 1;
                    LineNo += QBGenericImportLine."Autoincrement By";
                    WriteField(FR, FORMAT(LineNo));
                END;

                //Si hemos leido un registro, lo procesamos
                Read := FALSE;
                CASE QBGenericImportHeader.Type OF
                    QBGenericImportHeader.Type::Excel:
                        Read := GetValueAtCell(ExcelBuffer, QBGenericImportLine, RowNo, Value);
                    QBGenericImportHeader.Type::Text:
                        Read := GetValueAtPos(Linea, QBGenericImportLine, FR, Value);
                    QBGenericImportHeader.Type::CSV:
                        Read := GetValueAtNum(Linea, QBGenericImportLine, FR, QBGenericImportHeader.Sep, QBGenericImportHeader.Del, Value);
                END;

                IF (Read) THEN BEGIN
                    //Si hay que reemplazar por una substituci�n
                    IF QBGenericImportLine."Replacement Code" <> '' THEN //JMMA 211020
                        Replace(QBGenericImportLine."Replacement Code", Value);

                    //Si no hay que agrupar, modifico el valor del campo
                    IF (NOT Exist) THEN BEGIN
                        WriteField(FR, Value);            //Guardo el valor en el campo
                    END ELSE BEGIN
                        //Si hay que agrupar registros, solo sumo los campos sumatorio siempre que sean de tipo num�rico
                        IF (QBGenericImportLine."Apply Summation") AND (FORMAT(FR.TYPE) IN ['Integer', 'Decimal']) THEN BEGIN
                            Value1 := FORMAT(FR.VALUE);
                            IF (NOT EVALUATE(NumericValue1, Value1)) THEN
                                NumericValue1 := 0;

                            IF (NOT EVALUATE(NumericValue2, Value)) THEN
                                NumericValue2 := 0;

                            Value := FORMAT(NumericValue1 + NumericValue2);
                        END;
                    END;
                END;

            UNTIL QBGenericImportLine.NEXT = 0;

        IF NOT RR.INSERT(TRUE) THEN
            RR.MODIFY(TRUE);

        RR.CLOSE;
    END;

    LOCAL PROCEDURE GetValueAtCell(ExcelBuffer: Record 370; QBGenericImportLine: Record 7206941; RowNo: Integer; VAR Value: Text): Boolean;
    BEGIN
        IF (RowNo <> 0) AND (QBGenericImportLine."Excel Column No" <> 0) THEN
            IF ExcelBuffer.GET(RowNo, QBGenericImportLine."Excel Column No") THEN BEGIN
                Value := ExcelBuffer."Cell Value as Text";
                EXIT(TRUE);
            END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetValueAtPos(Linea: Text; QBGenericImportLine: Record 7206941; FR: FieldRef; VAR Value: Text): Boolean;
    BEGIN
        IF (QBGenericImportLine."Ini Postition" <> 0) AND (QBGenericImportLine.Long <> 0) THEN
            IF (STRLEN(Linea) >= QBGenericImportLine."Ini Postition") THEN BEGIN
                Value := COPYSTR(Linea, QBGenericImportLine."Ini Postition", QBGenericImportLine.Long);
                ChangeFormatField(Value, FR, QBGenericImportLine.Format);
                EXIT(TRUE);
            END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetValueAtNum(Linea: Text; QBGenericImportLine: Record 7206941; FR: FieldRef; sep: Text; del: Text; VAR Value: Text): Boolean;
    VAR
        p: Integer;
        n: Integer;
    BEGIN
        IF (QBGenericImportLine."Excel Column No" <> 0) THEN BEGIN
            p := 0;
            n := 0;
            REPEAT
                p += 1;
                IF (COPYSTR(Linea, p, 1) = sep) THEN
                    n += 1;
            UNTIL (n = QBGenericImportLine."Excel Column No" - 1) OR (p = STRLEN(Linea));
            IF (p = STRLEN(Linea)) THEN
                EXIT(FALSE);
            IF (n = 0) THEN
                Value := COPYSTR(Linea, p)
            ELSE
                Value := COPYSTR(Linea, p + 1);
            p := STRPOS(Value, sep);
            IF (p <> 0) THEN
                Value := COPYSTR(Value, 1, p - 1);
            IF (COPYSTR(Value, 1, 1) = del) THEN
                Value := COPYSTR(Value, 2, STRLEN(Value) - 2);

            ChangeFormatField(Value, FR, QBGenericImportLine.Format);
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE WriteField(VAR FldRef: FieldRef; Value: Text);
    VAR
        OutlookSynchTypeConv: Codeunit 5302;
        NumericValue: Decimal;
        DateValue: Date;
        BoolValue: Boolean;
        OptValue: Option;
    BEGIN
        CASE FORMAT(FldRef.TYPE) OF
            'Integer', 'Decimal':
                BEGIN
                    EVALUATE(NumericValue, Value);
                    FldRef.VALIDATE(NumericValue);
                END;
            'Date':
                BEGIN
                    EVALUATE(DateValue, Value);
                    FldRef.VALIDATE(DateValue);
                END;
            'Boolean':
                BEGIN
                    EVALUATE(BoolValue, Value);
                    FldRef.VALIDATE(BoolValue);
                END;
            'Text', 'Code':
                BEGIN
                    FldRef.VALIDATE(COPYSTR(Value, 1, FldRef.LENGTH));
                END;
            'Option':
                BEGIN
                    OptValue := OutlookSynchTypeConv.TextToOptionValue(Value, FldRef.OPTIONCAPTION);
                    IF OptValue >= 0 THEN
                        FldRef.VALIDATE(OptValue);
                END;
        END;
    END;

    LOCAL PROCEDURE ChangeFormatField(VAR Value: Text; FR: FieldRef; Form: Text);
    VAR
        OutlookSynchTypeConv: Codeunit 5302;
        NumericValue: Decimal;
        DateValue: Date;
        BoolValue: Boolean;
        OptValue: Option;
        sini: Boolean;
        sfin: Boolean;
        sp: Text;
        sn: Text;
        sg: Text;
        i: Integer;
        nd: Decimal;
        v1: Text;
        d: Integer;
        m: Integer;
        a: Integer;
    BEGIN
        Value := DELCHR(Value, '<>', ' ');
        CASE FORMAT(FR.TYPE) OF
            'Integer':
                BEGIN
                    EVALUATE(NumericValue, Value);
                    Value := FORMAT(NumericValue);
                END;
            'Decimal':
                BEGIN
                    IF (Form = '') THEN
                        EVALUATE(NumericValue, Value)
                    ELSE BEGIN
                        //Si el signo va delante o detr�s
                        sini := (STRPOS(Form, '-') = 1);
                        sfin := (STRPOS(Form, '-') = 2);

                        //Signo para positivos y negativos
                        sp := '';
                        sn := '';
                        i := STRPOS(Form, '-');
                        IF (i <> 0) THEN BEGIN
                            sp := COPYSTR(Form, i + 1, 1);
                            sn := COPYSTR(Form, i + 2, 1);
                            IF (i = 1) THEN
                                Form := COPYSTR(Form, 4, 1)
                            ELSE
                                Form := COPYSTR(Form, 1, 1);
                        END;
                        //Decimales
                        IF (NOT EVALUATE(nd, Form)) THEN
                            nd := 0;

                        sg := '';
                        IF (sini) THEN BEGIN
                            sg := COPYSTR(Value, 1, 1);
                            Value := COPYSTR(Value, 2);
                        END;
                        IF (sfin) THEN BEGIN
                            sg := COPYSTR(Value, STRLEN(Value) - 1, 1);
                            ;
                            Value := COPYSTR(Value, 1, STRLEN(Value) - 1);
                        END;

                        EVALUATE(NumericValue, Value);
                        IF (nd <> 0) THEN
                            NumericValue := NumericValue / POWER(10, nd);
                        IF (sg = sn) THEN
                            NumericValue := -NumericValue;
                    END;
                    Value := FORMAT(NumericValue);
                END;
            'Date':
                BEGIN
                    //Saco el d�a
                    i := STRPOS(UPPERCASE(Form), 'DD');
                    IF (i <> 0) THEN BEGIN
                        v1 := '0' + COPYSTR(Value, i, 2);
                        EVALUATE(d, v1);
                    END;
                    //Saco el MES
                    i := STRPOS(UPPERCASE(Form), 'MM');
                    IF (i <> 0) THEN BEGIN
                        v1 := '0' + COPYSTR(Value, i, 2);
                        EVALUATE(m, v1);
                    END;
                    //Saco  el a�o
                    i := STRPOS(UPPERCASE(Form), 'AAAA');
                    IF (i <> 0) THEN BEGIN
                        v1 := '0' + COPYSTR(Value, i, 4);
                        EVALUATE(a, v1);
                    END ELSE BEGIN
                        i := STRPOS(UPPERCASE(Form), 'AA');
                        IF (i <> 0) THEN BEGIN
                            v1 := '0' + COPYSTR(Value, i, 2);
                            EVALUATE(a, v1);
                            a += 2000;
                        END;
                    END;
                    //Monto la fecha
                    IF (d = 0) OR (m = 0) OR (a = 0) THEN
                        DateValue := 0D
                    ELSE
                        DateValue := DMY2DATE(d, m, a);

                    Value := FORMAT(DateValue);
                END;
            'Boolean':
                BEGIN
                    IF (Form = '') THEN
                        Form := 'SN';

                    IF (COPYSTR(Form, 1, 1) = COPYSTR(Value, 1, 1)) THEN
                        BoolValue := TRUE
                    ELSE
                        BoolValue := FALSE;
                    Value := FORMAT(BoolValue);
                END;
            'Option':
                BEGIN
                    OptValue := OutlookSynchTypeConv.TextToOptionValue(Value, FR.OPTIONCAPTION);
                    IF OptValue >= 0 THEN
                        Value := FORMAT(OptValue);
                END;
        END;
    END;

    LOCAL PROCEDURE "--------------------------------------------- Exportar"();
    BEGIN
    END;

    PROCEDURE Export(pCode: Code[20]);
    VAR
        QBGenericImportHeader: Record 7206940;
    BEGIN
        QBGenericImportHeader.GET(pCode);
        CASE QBGenericImportHeader.Type OF
            QBGenericImportHeader.Type::Excel:
                ExportExcel(QBGenericImportHeader);
            QBGenericImportHeader.Type::Text:
                ExportText(QBGenericImportHeader);
            QBGenericImportHeader.Type::CSV:
                ExportCSV(QBGenericImportHeader);
        END;
    END;

    PROCEDURE ExportExcel(QBGenericImportHeader: Record 7206940);
    VAR
        ExcelBuffer: Record 370;
        QBGenericImportLine: Record 7206941;
        RecRef: RecordRef;
        FldRef: FieldRef;
        antCol: Integer;
        i: Integer;
    BEGIN
        //Exportar a Excel
        ExcelBuffer.DELETEALL;
        RecRef.OPEN(QBGenericImportHeader."Table ID");

        //Se crea la cabecera de la hoja Excel
        antCol := 0;
        QBGenericImportLine.RESET;
        QBGenericImportLine.SETCURRENTKEY("Excel Column No");
        QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
        QBGenericImportLine.SETFILTER("Excel Column No", '<>%1', 0);
        IF QBGenericImportLine.FINDSET(FALSE) THEN BEGIN
            REPEAT
                FOR i := antCol + 2 TO QBGenericImportLine."Excel Column No" DO
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                antCol := QBGenericImportLine."Excel Column No";

                FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                ExcelBuffer.AddColumn(FldRef.CAPTION, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            UNTIL QBGenericImportLine.NEXT = 0;
        END;

        //Se crean las l�neas
        FilterData(QBGenericImportHeader, RecRef);
        IF RecRef.FINDSET(FALSE) THEN
            REPEAT
                ExcelBuffer.NewRow;
                antCol := 0;

                QBGenericImportLine.RESET;
                QBGenericImportLine.SETCURRENTKEY("Excel Column No");
                QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
                QBGenericImportLine.SETFILTER("Excel Column No", '<>%1', 0);
                IF QBGenericImportLine.FINDSET(FALSE) THEN
                    REPEAT
                        FOR i := antCol + 2 TO QBGenericImportLine."Excel Column No" DO
                            ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        antCol := QBGenericImportLine."Excel Column No";

                        FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                        WriteExcelField(ExcelBuffer, FldRef);
                    UNTIL QBGenericImportLine.NEXT = 0;
            UNTIL RecRef.NEXT = 0;

        RecRef.CLOSE;

        COMMIT;

        IF (QBGenericImportHeader."Sheet Name" = '') THEN
            QBGenericImportHeader."Sheet Name" := 'Hoja 1';

        ExcelBuffer.CreateBookAndOpenExcel(QBGenericImportHeader."File Name", QBGenericImportHeader."Sheet Name", QBGenericImportHeader."Setup Code", COMPANYNAME, USERID);
    END;

    PROCEDURE ExportText(QBGenericImportHeader: Record 7206940);
    VAR
        QBGenericImportLine: Record 7206941;
        FileManagement: Codeunit 419;
        Fichero: File;
        oStream: OutStream;
        nFichero: Text;
        Linea: Text;
        RecRef: RecordRef;
        FldRef: FieldRef;
        Txt001: TextConst ENU = 'Excel Files (*.xls*)|*.xls*|All Files (*.*)|*.*', ESP = 'Archivos de Texto (*.txt*)|*.txt*|Todos los archivos (*.*)|*.*';
        Patch: Text;
        FileName: Text;
    BEGIN
        //Exporta a un fichero de texto plano
        Patch := FileManagement.GetDirectoryName(QBGenericImportHeader."File Name");
        FileName := FileManagement.GetFileName(QBGenericImportHeader."File Name");

        IF (Patch = '') THEN
            Patch := TEMPORARYPATH;

        IF (FileName = '') THEN
            FileName := 'Temp.txt';

        nFichero := Patch + FileName;

        Fichero.TEXTMODE(TRUE);
        Fichero.WRITEMODE(TRUE);
        Fichero.CREATE(nFichero, TEXTENCODING::Windows);
        Fichero.CREATEOUTSTREAM(oStream);

        RecRef.OPEN(QBGenericImportHeader."Table ID");

        //Se crean las l�neas
        FilterData(QBGenericImportHeader, RecRef);
        IF RecRef.FINDSET(FALSE) THEN
            REPEAT
                Linea := '';

                QBGenericImportLine.RESET;
                QBGenericImportLine.SETCURRENTKEY(Order);
                QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
                QBGenericImportLine.SETFILTER("Ini Postition", '<>%1', 0);
                IF QBGenericImportLine.FINDSET(FALSE) THEN
                    REPEAT
                        FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                        WriteTextField(Linea, FldRef, QBGenericImportLine."Ini Postition", QBGenericImportLine.Long, QBGenericImportLine.Format);
                    UNTIL QBGenericImportLine.NEXT = 0;
                oStream.WRITETEXT(Linea);
                oStream.WRITETEXT;
            UNTIL RecRef.NEXT = 0;

        RecRef.CLOSE;
        Fichero.CLOSE;

        FILE.DOWNLOAD(nFichero, 'Guardar fichero', Patch, Txt001, FileName);
    END;

    PROCEDURE ExportCSV(QBGenericImportHeader: Record 7206940);
    VAR
        QBGenericImportLine: Record 7206941;
        FileManagement: Codeunit 419;
        Fichero: File;
        oStream: OutStream;
        nFichero: Text;
        Linea: Text;
        RecRef: RecordRef;
        FldRef: FieldRef;
        Txt001: TextConst ENU = 'Excel Files (*.xls*)|*.xls*|All Files (*.*)|*.*', ESP = 'Archivos de Texto (*.txt*)|*.txt*|Todos los archivos (*.*)|*.*';
        Patch: Text;
        FileName: Text;
        antCol: Integer;
        i: Integer;
    BEGIN
        //Exporta a un fichero de texto CSV
        Patch := FileManagement.GetDirectoryName(QBGenericImportHeader."File Name");
        FileName := FileManagement.GetFileName(QBGenericImportHeader."File Name");

        IF (Patch = '') THEN
            Patch := TEMPORARYPATH;

        IF (FileName = '') THEN
            FileName := 'Temp.txt';

        nFichero := Patch + FileName;

        Fichero.TEXTMODE(TRUE);
        Fichero.WRITEMODE(TRUE);
        Fichero.CREATE(nFichero, TEXTENCODING::Windows);
        Fichero.CREATEOUTSTREAM(oStream);

        RecRef.OPEN(QBGenericImportHeader."Table ID");

        //Se crean las l�neas
        FilterData(QBGenericImportHeader, RecRef);
        IF RecRef.FINDSET(FALSE) THEN
            REPEAT
                Linea := '';
                antCol := 0;

                QBGenericImportLine.RESET;
                QBGenericImportLine.SETCURRENTKEY("Excel Column No");
                QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
                QBGenericImportLine.SETFILTER(Order, '<>%1', 0);
                IF QBGenericImportLine.FINDSET(FALSE) THEN
                    REPEAT
                        FOR i := antCol + 2 TO QBGenericImportLine."Excel Column No" DO
                            Linea += QBGenericImportHeader.Sep;
                        antCol := QBGenericImportLine."Excel Column No";

                        FldRef := RecRef.FIELD(QBGenericImportLine."Field No.");
                        WriteCSVField(Linea, FldRef, QBGenericImportLine.Format, QBGenericImportHeader.Sep, QBGenericImportHeader.Del);
                    UNTIL QBGenericImportLine.NEXT = 0;

                //Eliminar los separadores vac�os del final de la l�nea para reducir el tama�o
                Linea := DELCHR(Linea, '>', QBGenericImportHeader.Sep);

                oStream.WRITETEXT(Linea);
                oStream.WRITETEXT;
            UNTIL RecRef.NEXT = 0;

        RecRef.CLOSE;
        Fichero.CLOSE;

        FILE.DOWNLOAD(nFichero, 'Guardar fichero', Patch, Txt001, FileName);
    END;

    LOCAL PROCEDURE "------------------------- Auxiliares Export"();
    BEGIN
    END;

    LOCAL PROCEDURE FilterData(QBGenericImportHeader: Record 7206940; VAR RR: RecordRef);
    VAR
        QBGenericImportLine: Record 7206941;
        FR: FieldRef;
        FldRefKey: FieldRef;
        Keys: KeyRef;
        i: Integer;
    BEGIN
        //Se filtra por las claves
        RR.RESET;
        // Keys := RR.KEYINDEX(1);
        // FOR i := 1 TO Keys.FIELDCOUNT DO BEGIN
        //  FldRefKey := Keys.FIELDINDEX(i);
        //  QBGenericImportLine.RESET;
        //  QBGenericImportLine.SETRANGE("Setup Code",QBGenericImportHeader."Setup Code");
        //  QBGenericImportLine.SETRANGE("Field No.",FldRefKey.NUMBER);
        //  IF QBGenericImportLine.FINDFIRST THEN BEGIN
        //    FR := RR.FIELD(QBGenericImportLine."Field No.");
        //    IF QBGenericImportLine."Default Value" <> '' THEN
        //      FR.SETRANGE(QBGenericImportLine."Default Value");
        //  END;
        // END;

        //Se a�aden los criterios de filtrado
        QBGenericImportLine.RESET;
        QBGenericImportLine.SETRANGE("Setup Code", QBGenericImportHeader."Setup Code");
        QBGenericImportLine.SETFILTER("Export Filter", '<>%1', '');
        IF QBGenericImportLine.FINDSET(FALSE) THEN BEGIN
            REPEAT
                FR := RR.FIELD(QBGenericImportLine."Field No.");
                FR.SETFILTER(QBGenericImportLine."Export Filter");
            UNTIL QBGenericImportLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE WriteExcelField(VAR ExcelBuffer: Record 370; FR: FieldRef);
    VAR
        I: Integer;
        NumericValue: Decimal;
        DateValue: Date;
        BoolValue: Boolean;
        GuidValue: GUID;
        StringOptions: Text;
        Pos: Integer;
        OptValue: Integer;
        TempBlob: Codeunit "Temp Blob";
        Value: Text;
    BEGIN
        CASE FORMAT(FR.TYPE) OF
            'Integer', 'Decimal':
                BEGIN
                    ExcelBuffer.AddColumn(FR.VALUE, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                END;
            'Date':
                BEGIN
                    ExcelBuffer.AddColumn(FR.VALUE, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                END;
            'Boolean':
                BEGIN
                    IF FORMAT(FR.VALUE) = FORMAT(TRUE) THEN
                        ExcelBuffer.AddColumn('SI', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                    ELSE
                        ExcelBuffer.AddColumn('NO', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                END;
            'Text', 'Code':
                BEGIN
                    ExcelBuffer.AddColumn(FR.VALUE, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                END;
            ELSE
                ExcelBuffer.AddColumn(FR.VALUE, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        END;
    END;

    LOCAL PROCEDURE WriteTextField(VAR Linea: Text; FR: FieldRef; Ini: Integer; Len: Integer; Form: Text);
    VAR
        DateValue: Date;
        DecValue: Decimal;
        Value: Text;
        Vaux1: Text;
        vAux2: Text;
        i: Integer;
        nd: Integer;
        sp: Text;
        sn: Text;
        sg: Text;
        sini: Boolean;
        sfin: Boolean;
    BEGIN
        Value := FormatField(FR, Len, Form);

        IF (STRLEN(Linea) < Ini - 1) THEN
            Linea := PADSTR(Linea, Ini - 1, ' ');

        IF (STRLEN(Linea) = Ini - 1) THEN
            Linea := Linea + Value
        ELSE
            Linea := COPYSTR(Linea, 1, Ini - 1) + Value + COPYSTR(Linea, Ini + Len);
    END;

    LOCAL PROCEDURE WriteCSVField(VAR Linea: Text; FR: FieldRef; Form: Text; Sep: Text; Del: Text);
    VAR
        DateValue: Date;
        DecValue: Decimal;
        Value: Text;
        Vaux1: Text;
        vAux2: Text;
        i: Integer;
        nd: Integer;
        sp: Text;
        sn: Text;
        sg: Text;
        sini: Boolean;
        sfin: Boolean;
    BEGIN
        Value := FormatField(FR, 0, Form);

        //Si contiene el caracter delimitador, lo elimino
        IF (Del <> '') THEN
            Value := DELCHR(Value, '=', Del);

        //Si contiene el caracter separador, lo delimito
        IF (STRPOS(Value, Sep) <> 0) THEN
            Value := Del + Value + Del;

        IF (Linea <> '') THEN
            Linea += Sep;
        Linea += Value;
    END;

    LOCAL PROCEDURE FormatField(FR: FieldRef; Len: Integer; Form: Text): Text;
    VAR
        DateValue: Date;
        DecValue: Decimal;
        Value: Text;
        Vaux1: Text;
        vAux2: Text;
        i: Integer;
        nd: Integer;
        sp: Text;
        sn: Text;
        sg: Text;
        sini: Boolean;
        sfin: Boolean;
    BEGIN
        Value := '';

        CASE FORMAT(FR.TYPE) OF
            'Text', 'Code':
                BEGIN
                    //3 formatos posibles: '', Ic o Dc, I= justificado a la izquierda, D=justificado a la derecha, c=caracter de relleno, si no se indica ser� igual a 'I '
                    Value := DELCHR(FORMAT(FR.VALUE), '<>', ' '); //Quito espacios por delante o por detr�s
                    IF (Len = 0) THEN
                        Len := STRLEN(Value);

                    IF (Form = '') THEN
                        Form := 'I ';
                    IF (UPPERCASE(COPYSTR(Form, 1, 1)) = 'I') THEN BEGIN
                        Value := Value + PADSTR('', Len, COPYSTR(Form, 2, 1));
                        Value := COPYSTR(Value, 1, Len);
                    END ELSE BEGIN
                        Value := PADSTR('', Len, COPYSTR(Form, 2, 1)) + Value;
                        Value := COPYSTR(Value, STRLEN(Value) - Len + 1);
                    END;
                END;
            'Integer':
                BEGIN
                    Value := FORMAT(FR.VALUE);
                    IF (Len = 0) THEN
                        Len := STRLEN(Value);

                    Value := PADSTR('', Len, '0') + Value;
                    Value := COPYSTR(Value, STRLEN(Value) - Len + 1);
                END;
            'Decimal':
                BEGIN
                    //3 formatos posibles: N -pgN N-pg, donde N=Nro decimales, p=S�mbolo para positivos, g=S�mbolo para negativos
                    IF (Len = 0) THEN BEGIN
                        DecValue := FR.VALUE;
                        Vaux1 := FORMAT(DecValue, 0, '<Sign><Integer>');
                        vAux2 := FORMAT(ABS(DecValue), 0, '<Decimals>');
                        IF (vAux2 <> '') THEN
                            Value := Vaux1 + '.' + COPYSTR(vAux2, 2)
                        ELSE
                            Value := Vaux1;
                    END ELSE BEGIN
                        DecValue := FR.VALUE;

                        //Si el signo va delante o detr�s
                        sini := (STRPOS(Form, '-') = 1);
                        sfin := (STRPOS(Form, '-') = 2);

                        //Signo para positivos y negativos
                        sp := '';
                        sn := '';
                        i := STRPOS(Form, '-');
                        IF (i <> 0) THEN BEGIN
                            sp := COPYSTR(Form, i + 1, 1);
                            sn := COPYSTR(Form, i + 2, 1);
                            IF (i = 1) THEN
                                Form := COPYSTR(Form, 4, 1)
                            ELSE
                                Form := COPYSTR(Form, 1, 1);
                        END;
                        //Decimales
                        IF (NOT EVALUATE(nd, Form)) THEN
                            nd := 0;

                        sg := '';
                        IF (DecValue >= 0) THEN
                            sg := sp
                        ELSE
                            sg := sn;

                        Vaux1 := PADSTR('', Len, '0') + FORMAT(ABS(DecValue), 0, '<Integer>');
                        Vaux1 := COPYSTR(Vaux1, STRLEN(Vaux1) - Len + nd + STRLEN(sg) + 1);
                        IF (nd = 0) THEN
                            vAux2 := ''
                        ELSE BEGIN
                            vAux2 := PADSTR('', nd, '0') + FORMAT(ABS(DecValue), 0, '<Decimals>');
                            vAux2 := COPYSTR(vAux2, STRLEN(vAux2) - nd + 1);
                        END;

                        IF (sini) THEN
                            Value := sg + Vaux1 + vAux2
                        ELSE IF (sfin) THEN
                            Value := Vaux1 + vAux2 + sg
                        ELSE
                            Value := Vaux1 + vAux2;
                    END;
                END;
            'Date':
                BEGIN
                    DateValue := FR.VALUE;
                    IF (Form = '') THEN
                        Form := 'DDMMAAAA';

                    Value := Form;
                    Vaux1 := FORMAT(FR.VALUE, 0, '<Day,2><Month,2><Year4>');

                    //Cambio el d�a
                    i := STRPOS(UPPERCASE(Form), 'DD');
                    IF (i = 1) THEN
                        Value := COPYSTR(Vaux1, 1, 2) + COPYSTR(Value, i + 2)
                    ELSE IF (i > 1) THEN
                        Value := COPYSTR(Value, 1, i - 1) + COPYSTR(Vaux1, 1, 2) + COPYSTR(Value, i + 2);
                    //Cambio el MES
                    i := STRPOS(UPPERCASE(Form), 'MM');
                    IF (i = 1) THEN
                        Value := COPYSTR(Vaux1, 3, 2) + COPYSTR(Value, i + 2)
                    ELSE IF (i > 1) THEN
                        Value := COPYSTR(Value, 1, i - 1) + COPYSTR(Vaux1, 3, 2) + COPYSTR(Value, i + 2);
                    //Cambio el a�o
                    i := STRPOS(UPPERCASE(Form), 'AA');
                    IF (i = 1) THEN
                        Value := COPYSTR(Vaux1, 7, 2) + COPYSTR(Value, i + 2)
                    ELSE IF (i > 1) THEN
                        Value := COPYSTR(Value, 1, i - 1) + COPYSTR(Vaux1, 7, 2) + COPYSTR(Value, i + 2);
                    i := STRPOS(UPPERCASE(Form), 'AAAA');
                    IF (i = 1) THEN
                        Value := COPYSTR(Vaux1, 7, 4) + COPYSTR(Value, i + 4)
                    ELSE IF (i > 1) THEN
                        Value := COPYSTR(Value, 1, i - 1) + COPYSTR(Vaux1, 7, 2) + COPYSTR(Value, i + 4);
                END;
            'Boolean':
                BEGIN
                    //2 formatos posibles: '' o SN donde S = simbolo prar true y N = s�mbolo para false, si no se dide nada ser�n S y N respectivamente
                    IF (Form = '') THEN
                        Form := 'SN';
                    IF FORMAT(FR.VALUE) = FORMAT(TRUE) THEN
                        Value := COPYSTR(Form, 1, 1)
                    ELSE
                        Value := COPYSTR(Form, 2, 1);
                END;
        END;

        EXIT(Value);
    END;

    /* BEGIN
END.*/
}










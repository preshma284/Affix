Codeunit 50197 "Type Helper 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        UnsupportedTypeErr: TextConst ENU = 'The Type is not supported by the Evaluate function.', ESP = 'La funci�n Evaluar no admite el tipo.';
        KeyDoesNotExistErr: TextConst ENU = 'The requested key does not exist.', ESP = 'La clave solicitada no existe.';
        InvalidMonthErr: TextConst ENU = 'An invalid month was specified.', ESP = 'Se especific� un mes no v�lido.';
        StringTooLongErr: TextConst ENU = 'This function only allows strings of length up to %1.', ESP = 'Esta funci�n solo permite cadenas con una longitud de hasta %1.';
        UnsupportedNegativesErr: TextConst ENU = 'Negative parameters are not supported by bitwise function %1.', ESP = 'No se admiten par�metros negativos con la funci�n bit a bit %1.';
        BitwiseAndTxt: TextConst ENU = 'BitwiseAnd', ESP = 'BitwiseAnd';
        BitwiseOrTxt: TextConst ENU = 'BitwiseOr', ESP = 'BitwiseOr';
        BitwiseXorTxt: TextConst ENU = 'BitwiseXor', ESP = 'BitwiseXor';
        ObsoleteFieldErr: TextConst ENU = 'The field %1 of %2 table is obsolete and cannot be used.', ESP = 'El campo %1 de la tabla %2 est� obsoleto y no se puede usar.';



    LOCAL PROCEDURE TryEvaluateDecimal(DecimalText: Text; CultureName: Text; VAR EvaluatedDecimal: Decimal): Boolean;
    VAR
        CultureInfo: DotNet CultureInfo;
        DotNetDecimal: DotNet Decimal;
        NumberStyles: DotNet NumberStyles;
    BEGIN
        EvaluatedDecimal := 0;
        IF DotNetDecimal.TryParse(DecimalText, NumberStyles.Number, CultureInfo.GetCultureInfo(CultureName), EvaluatedDecimal) THEN
            EXIT(TRUE);
        EXIT(FALSE)
    END;



    //[External]
    PROCEDURE FormatDateWithCurrentCulture(DateToFormat: Date): Text;
    VAR
        DotNet_CultureInfo: Codeunit 3002;
        DotNet_DateTimeFormatInfo: Codeunit 3022;
        DotNet_DateTime: Codeunit 3003;
        DotNet_DateTime1: Codeunit 50792;
    BEGIN
        DotNet_CultureInfo.GetCultureInfoByName(GetCultureName);
        DotNet_CultureInfo.DateTimeFormat(DotNet_DateTimeFormatInfo);
        DotNet_DateTime1.DateTimeFromYMD(DATE2DMY(DateToFormat, 3), DATE2DMY(DateToFormat, 2), DATE2DMY(DateToFormat, 1));
        EXIT(DotNet_DateTime.ToString(DotNet_DateTimeFormatInfo));
    END;


    //[External]
    PROCEDURE GetCultureName(): Text;
    VAR
        CultureInfo: DotNet CultureInfo;
    BEGIN
        EXIT(CultureInfo.CurrentCulture.Name);
    END;

    //[External]
    PROCEDURE GetOptionNo(Value: Text; OptionString: Text): Integer;
    VAR
        OptionNo: Integer;
        OptionsQty: Integer;
    BEGIN
        Value := UPPERCASE(Value);
        OptionString := UPPERCASE(OptionString);

        IF (Value = '') AND (OptionString[1] IN [' ', ',']) THEN
            EXIT(0);
        IF (Value <> '') AND (STRPOS(OptionString, Value) = 0) THEN BEGIN
            IF (Value = '0') AND (OptionString[1] = ',') THEN
                EXIT(0);
            EXIT(-1);
        END;

        OptionsQty := GetNumberOfOptions(OptionString);
        IF OptionsQty > 0 THEN BEGIN
            FOR OptionNo := 0 TO OptionsQty - 1 DO BEGIN
                IF OptionsAreEqual(Value, COPYSTR(OptionString, 1, STRPOS(OptionString, ',') - 1)) THEN
                    EXIT(OptionNo);
                OptionString := DELSTR(OptionString, 1, STRPOS(OptionString, ','));
            END;
            OptionNo += 1;
        END;

        IF OptionsAreEqual(Value, OptionString) THEN
            EXIT(OptionNo);

        EXIT(-1);
    END;



    //[External]
    PROCEDURE GetNumberOfOptions(OptionString: Text): Integer;
    BEGIN
        EXIT(STRLEN(OptionString) - STRLEN(DELCHR(OptionString, '=', ',')));
    END;

    LOCAL PROCEDURE OptionsAreEqual(Value: Text; CurrentOption: Text): Boolean;
    BEGIN
        EXIT(((Value <> '') AND (Value = CurrentOption)) OR ((Value = '') AND (CurrentOption = ' ')));
    END;



    //[External]
    PROCEDURE FindFields(TableNo: Integer; VAR Field: Record 2000000041): Boolean;
    BEGIN
        Field.SETRANGE(TableNo, TableNo);
        Field.SETFILTER(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        EXIT(Field.FINDSET);
    END;

    //[External]
    PROCEDURE GetField(TableNo: Integer; FieldNo: Integer; VAR Field: Record 2000000041): Boolean;
    BEGIN
        EXIT(Field.GET(TableNo, FieldNo) AND (Field.ObsoleteState <> Field.ObsoleteState::Removed));
    END;

    //[External]
    PROCEDURE GetFieldLength(TableNo: Integer; FieldNo: Integer): Integer;
    VAR
        Field: Record 2000000041;
    BEGIN
        IF GetField(TableNo, FieldNo, Field) THEN
            EXIT(Field.Len);

        EXIT(0);
    END;


    //[External]
    PROCEDURE Equals(ThisRecRef: RecordRef; OtherRecRef: RecordRef; SkipBlob: Boolean): Boolean;
    VAR
        Field: Record 2000000041;
        "Key": Record 2000000063;
        OtherFieldRef: FieldRef;
        ThisFieldRef: FieldRef;
    BEGIN
        IF ThisRecRef.NUMBER <> OtherRecRef.NUMBER THEN
            EXIT(FALSE);

        IF ThisRecRef.KEYCOUNT = ThisRecRef.FIELDCOUNT THEN
            EXIT(FALSE);

        FindFields(ThisRecRef.NUMBER, Field);
        REPEAT
            IF NOT Key.GET(ThisRecRef.NUMBER, Field."No.") THEN BEGIN
                ThisFieldRef := ThisRecRef.FIELD(Field."No.");
                OtherFieldRef := OtherRecRef.FIELD(Field."No.");

                CASE Field.Type OF
                    Field.Type::BLOB, Field.Type::Binary:
                        IF NOT SkipBlob THEN
                            IF ReadBlob(ThisFieldRef) <> ReadBlob(OtherFieldRef) THEN
                                EXIT(FALSE);
                    ELSE
                        IF ThisFieldRef.VALUE <> OtherFieldRef.VALUE THEN
                            EXIT(FALSE);
                END;
            END;
        UNTIL Field.NEXT = 0;

        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE GetBlobString(RecordVariant: Variant; FieldNo: Integer): Text;
    VAR
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    BEGIN
        RecordRef.GETTABLE(RecordVariant);
        FieldRef := RecordRef.FIELD(FieldNo);
        EXIT(ReadBlob(FieldRef));
    END;

    //[External]
    PROCEDURE SetBlobString(RecordRef: RecordRef; FieldNo: Integer; Value: Text);
    VAR
        FieldRef: FieldRef;
    BEGIN
        FieldRef := RecordRef.FIELD(FieldNo);
        WriteBlob(FieldRef, Value);
    END;

    //[External]
    PROCEDURE ReadBlob(VAR BlobFieldRef: FieldRef) Content: Text;
    VAR
        TempBlob: codeunit "temp blob";
        InStream: InStream;
        Blob: OutStream;
        CR: Code[1];
    BEGIN
        CR[1] := 10;
        //TempBlob.Blob := BlobFieldRef.VALUE;
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(BlobFieldRef.VALUE);
        IF NOT TempBlob.HASVALUE THEN BEGIN
            BlobFieldRef.CALCFIELD;
            //TempBlob.Blob := BlobFieldRef.VALUE;
            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write(BlobFieldRef.VALUE);
        END;
        // TempBlob.Blob.CREATEINSTREAM(InStream, TEXTENCODING::UTF8);
        // InStream.READ(Content);

        // BlobFieldRef.VALUE := TempBlob.Blob;
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        BlobFieldRef.VALUE := CR;
    END;

    //[External]
    PROCEDURE ReadTextBlob(VAR BlobFieldRef: FieldRef; LineSeparator: Text): Text;
    BEGIN
        EXIT(ReadTextBlobWithEncoding(BlobFieldRef, LineSeparator, TEXTENCODING::MSDos));
    END;

    //[External]
    PROCEDURE WriteBlobWithEncoding(VAR BlobFieldRef: FieldRef; NewContent: Text; TextEncoding: TextEncoding): Boolean;
    VAR
        TempBlob: codeunit "temp blob";
        InStream: InStream;
        Blob: OutStream;
        CR: Code[1];
    BEGIN
        CR[1] := 10;
        BlobFieldRef.CALCFIELD;
        // TempBlob.Blob.CREATEOUTSTREAM(OutStream, TextEncoding);
        // OutStream.WRITE(NewContent);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(NewContent);
        //BlobFieldRef.VALUE := TempBlob.Blob;
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        BlobFieldRef.VALUE := CR;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE WriteBlob(VAR BlobFieldRef: FieldRef; NewContent: Text): Boolean;
    VAR
        TempBlob: codeunit "temp blob";
        InStream: InStream;
        Blob: OutStream;
        CR: Code[1];
    BEGIN
        CR[1] := 10;
        BlobFieldRef.CALCFIELD;
        // TempBlob.Blob.CREATEOUTSTREAM(OutStream, TEXTENCODING::UTF8);
        // OutStream.WRITE(NewContent);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(NewContent);
        //BlobFieldRef.VALUE := TempBlob.Blob;
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        BlobFieldRef.VALUE := CR;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE WriteTextToBlobIfChanged(VAR BlobFieldRef: FieldRef; NewContent: Text; Encoding: TextEncoding): Boolean;
    VAR
        TempBlob: codeunit "Temp Blob";
        InStream: InStream;
        Blob: OutStream;
        CR: Code[1];
        OldContent: Text;
    BEGIN
        CR[1] := 10;
        // Returns TRUE if the value was changed, FALSE if the old value was identical and no change was needed
        OldContent := ReadTextBlobWithTextEncoding(BlobFieldRef, Encoding);
        IF NewContent = OldContent THEN
            EXIT(FALSE);

        //TempBlob.INIT;
        Clear(TempBlob);
        // TempBlob.Blob.CREATEOUTSTREAM(OutStream, Encoding);
        // OutStream.WRITETEXT(NewContent);
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(NewContent);
        //TempBlob.INSERT;

        //BlobFieldRef.VALUE := TempBlob.Blob;
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        BlobFieldRef.VALUE := CR;
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE ReadTextBlobWithEncoding(VAR BlobFieldRef: FieldRef; LineSeparator: Text; Encoding: TextEncoding): Text;
    VAR
        TempBlob: codeunit "temp blob";
        InStream: InStream;
        Blob: OutStream;
        CR: Code[1];
    BEGIN
        CR[1] := 10;
        BlobFieldRef.CALCFIELD;

        //TempBlob.INIT;
        Clear(TempBlob);
        //TempBlob.Blob := BlobFieldRef.VALUE;
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(BlobFieldRef.VALUE);
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        EXIT(CR);
    END;

    [TryFunction]
    //[External]
    PROCEDURE TryConvertWordBlobToPdf(VAR TempBlob: Codeunit "Temp blob");
    VAR
        TempBlobPdf: Codeunit "Temp Blob";
        InStream: InStream;
        OutStreamPdfDoc: OutStream;
        // PdfWriter: DotNet WordToPdf;
        CR: Code[1];
    BEGIN
        CR[1] := 10;
        //TempBlob.Blob.CREATEINSTREAM(InStreamWordDoc);
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        TempBlob.CreateOutStream(OutStreamPdfDoc, TextEncoding::Windows);
        // PdfWriter.ConvertToPdf(InStream, OutStreamPdfDoc);
        //TempBlob.Blob := TempBlobPdf.Blob;
        TempBlobPdf.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        TempBlob.CreateOutStream(OutStreamPdfDoc, TextEncoding::Windows);
        OutStreamPdfDoc.Write(CR);
    END;

    //[External]
    PROCEDURE RegexReplace(Input: Text; Pattern: Text; Replacement: Text): Text;
    VAR
        Regex: DotNet Regex;
        NewString: Text;
    BEGIN
        Regex := Regex.Regex(Pattern);
        NewString := Regex.Replace(Input, Replacement);
        EXIT(NewString);
    END;

    //[External]
    PROCEDURE RegexReplaceIgnoreCase(Input: Text; Pattern: Text; Replacement: Text): Text;
    VAR
        Regex: DotNet Regex;
        RegexOptions: DotNet RegexOptions;
        NewString: Text;
    BEGIN
        Regex := Regex.Regex(Pattern, RegexOptions.IgnoreCase);
        NewString := Regex.Replace(Input, Replacement);
        EXIT(NewString);
    END;

    //[External]
    PROCEDURE IsMatch(Input: Text; RegExExpression: Text): Boolean;
    VAR
        Regex: DotNet Regex;
        AlphanumericRegEx: DotNet Regex;
    BEGIN
        AlphanumericRegEx := Regex.Regex(RegExExpression);
        EXIT(AlphanumericRegEx.IsMatch(Input));
    END;

    //[External]
    PROCEDURE IsAsciiLetter(Input: Text): Boolean;
    BEGIN
        EXIT(IsMatch(Input, '^[a-zA-Z]*$'));
    END;

    //[External]
    PROCEDURE IsAlphanumeric(Input: Text): Boolean;
    BEGIN
        EXIT(IsMatch(Input, '^[a-zA-Z0-9]*$'));
    END;


    //[External]
    PROCEDURE TextEndsWith(Value: Text; EndingText: Text): Boolean;
    BEGIN
        EXIT(IsMatch(Value, EndingText + '$'));
    END;

    //[External]
    PROCEDURE ReadTextBlobWithTextEncoding(VAR BlobFieldRef: FieldRef; Encoding: TextEncoding) BlobContent: Text;
    VAR
        TempBlob: codeunit "Temp Blob";
        InStream: InStream;
        Blob: OutStream;
        CR: Code[1];
    BEGIN
        CR[1] := 10;
        //TempBlob.INIT;
        Clear(TempBlob);
        BlobFieldRef.CALCFIELD;
        //TempBlob.Blob := BlobFieldRef.VALUE;
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(BlobFieldRef.VALUE);
        //TempBlob.Blob.CREATEINSTREAM(InStream, Encoding);
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(CR);
        IF InStream.READ(BlobContent) = 0 THEN;
    END;

    [TryFunction]
    //[External]
    PROCEDURE GetUserTimezoneOffset(VAR Duration: Duration);
    VAR
        UserPersonalization: Record 2000000073;
        TimeZoneInfo: DotNet TimeZoneInfo;
        TimeZone: Text;
    BEGIN
        UserPersonalization.GET(USERSECURITYID);
        TimeZone := UserPersonalization."Time Zone";
        TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZone);

        Duration := TimeZoneInfo.BaseUtcOffset;
    END;


    //[External]
    PROCEDURE GetTimezoneOffset(VAR Duration: Duration; TimeZoneID: Text);
    VAR
        TimeZoneInfo: DotNet TimeZoneInfo;
    BEGIN
        IF TimeZoneID = '' THEN
            Duration := 0;
        TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZoneID);
        Duration := TimeZoneInfo.BaseUtcOffset;
    END;



    //[External]
    PROCEDURE ConvertValueFromBase64(base64Value: Text) stringValue: Text;
    VAR
        Convert: DotNet Convert;
        Encoding: DotNet Encoding;
    BEGIN
        IF base64Value = '' THEN
            EXIT('');

        stringValue := Encoding.UTF8.GetString(Convert.FromBase64String(base64Value));
        EXIT(stringValue);
    END;

    //[External]
    PROCEDURE ConvertValueToBase64(stringValue: Text) base64Value: Text;
    VAR
        Convert: DotNet Convert;
        Encoding: DotNet Encoding;
    BEGIN
        IF stringValue = '' THEN
            EXIT('');

        base64Value := Convert.ToBase64String(Encoding.UTF8.GetBytes(stringValue));
        EXIT(base64Value);
    END;



    //[External]
    PROCEDURE GetGuidAsString(GuidValue: GUID): Text[36];
    BEGIN
        // Converts guid to string
        // Example: Converts{21EC2020-3AEA-4069-A2DD-08002B30309D} to 21ec2020-3aea-4069-a2dd-08002b30309d
        EXIT(LOWERCASE(COPYSTR(FORMAT(GuidValue), 2, 36)));
    END;

    //[External]
    PROCEDURE WriteRecordLinkNote(VAR RecordLink: Record 2000000068; Note: Text);
    VAR
        BinWriter: DotNet BinaryWriter;
        OStr: OutStream;
    BEGIN
        // Writes the Note BLOB into the format the client code expects
        RecordLink.Note.CREATEOUTSTREAM(OStr, TEXTENCODING::UTF8);
        BinWriter := BinWriter.BinaryWriter(OStr);
        BinWriter.Write(Note);
    END;

    //[External]
    PROCEDURE ReadRecordLinkNote(RecordLink: Record 2000000068) Note: Text;
    VAR
        BinReader: DotNet BinaryReader;
        IStr: InStream;
    BEGIN
        // Read the Note BLOB
        RecordLink.Note.CREATEINSTREAM(IStr, TEXTENCODING::UTF8);
        BinReader := BinReader.BinaryReader(IStr);
        // Peek if stream is empty
        IF BinReader.BaseStream.Position = BinReader.BaseStream.Length THEN
            EXIT;
        Note := BinReader.ReadString;
    END;


    //[External]
    PROCEDURE AddMinutesToDateTime(SourceDateTime: DateTime; NoOfMinutes: Integer): DateTime;
    VAR
        NewDateTime: DateTime;
        i: Integer;
        Sign: Boolean;
    BEGIN
        IF (NoOfMinutes < 1000) AND (NoOfMinutes > -1000) THEN
            NewDateTime := SourceDateTime + 60000 * NoOfMinutes
        ELSE BEGIN
            NewDateTime := SourceDateTime;
            Sign := NoOfMinutes > 0;
            FOR i := 1 TO ABS(ROUND(NoOfMinutes / 1000, 1, '<')) DO BEGIN
                IF Sign THEN
                    NewDateTime += 60000 * 1000
                ELSE
                    NewDateTime += 60000 * -1000
            END;
            NewDateTime += 60000 * (NoOfMinutes MOD 1000)
        END;
        EXIT(NewDateTime);
    END;

    //[External]
    PROCEDURE AddHoursToDateTime(SourceDateTime: DateTime; NoOfHours: Integer): DateTime;
    BEGIN
        EXIT(AddMinutesToDateTime(SourceDateTime, NoOfHours * 60));
    END;


    //[External]
    PROCEDURE ConvertDateTimeFromUTCToTimeZone(InputDateTime: DateTime; TimeZoneTxt: Text): DateTime;
    VAR
        TimeZoneInfo: DotNet TimeZoneInfo;
        Offset: Duration;
    BEGIN
        IF TimeZoneTxt = '' THEN
            EXIT(InputDateTime);

        IF CURRENTCLIENTTYPE = CLIENTTYPE::Web THEN
            IF GetUserTimezoneOffset(Offset) THEN
                InputDateTime := InputDateTime - Offset;

        TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZoneTxt);
        EXIT(TimeZoneInfo.ConvertTimeFromUtc(InputDateTime, TimeZoneInfo));
    END;

    /* /*BEGIN
END.*/
}








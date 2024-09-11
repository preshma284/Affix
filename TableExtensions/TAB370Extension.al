tableextension 50175 "QBU Excel BufferExt" extends "Excel Buffer"
{

    /*
  ReplicateData=false;
  */
    CaptionML = ENU = 'Excel Buffer', ESP = 'Mem. inter. Excel';

    fields
    {
        field(7207270; "Cell Value as Text2"; BLOB)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.00';
            SubType = Memo;


        }
    }
    keys
    {
        // key(key1;"Row No.","Column No.")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text001@1001 :
        Text001: TextConst ENU = 'You must enter a file name.', ESP = 'Debe introd. nombre fichero';
        //       Text002@1002 :
        Text002:
// "{Locked=""Excel""}"
TextConst ENU = 'You must enter an Excel worksheet name.', ESP = 'Debe introducir un nombre hoja Excel.';
        //       Text003@1003 :
        Text003: TextConst ENU = 'The file %1 does not exist.', ESP = 'El fichero %1 no existe.';
        //       Text004@1004 :
        Text004:
// "{Locked=""Excel""}"
TextConst ENU = 'The Excel worksheet %1 does not exist.', ESP = 'La hoja Excel  %1 no existe.';
        //       Text005@1005 :
        Text005:
// "{Locked=""Excel""}"
TextConst ENU = 'Creating Excel worksheet...\\', ESP = 'Creando hoja Excel...\\';
        //       PageTxt@1006 :
        PageTxt: TextConst ENU = 'Page', ESP = 'P�gina';
        //       Text007@1007 :
        Text007:
// "{Locked=""Excel""}"
TextConst ENU = 'Reading Excel worksheet...\\', ESP = 'Leyendo hoja Excel...\\';
        //       Text013@1013 :
        Text013: TextConst ENU = '&B', ESP = '&B';
        //       Text014@1014 :
        Text014: TextConst ENU = '&D', ESP = '&D';
        //       Text015@1015 :
        Text015: TextConst ENU = '&P', ESP = '&P';
        //       Text016@1016 :
        Text016: TextConst ENU = 'A1', ESP = 'A1';
        //       Text017@1017 :
        Text017: TextConst ENU = 'SUMIF', ESP = 'SUMIF';
        //       Text018@1018 :
        Text018: TextConst ENU = '#N/A', ESP = '#N/A';
        //       Text019@1019 :
        Text019:
// {Locked} Used to define an Excel range name. You must refer to Excel rules to change this term.
TextConst ENU = 'GLAcc', ESP = 'GLAcc';
        //       Text020@1020 :
        Text020:
// {Locked} Used to define an Excel range name. You must refer to Excel rules to change this term.
TextConst ENU = 'Period', ESP = 'Period';
        //       Text021@1021 :
        Text021: TextConst ENU = 'Budget', ESP = 'Budget';
        //       TempInfoExcelBuf@1036 :
        TempInfoExcelBuf: Record 370 TEMPORARY;
        //       FileManagement@1045 :
        FileManagement: Codeunit 419;
        //       OpenXMLManagement@1000 :
        OpenXMLManagement: Codeunit 6223;
        //       XlWrkBkWriter@1022 :
        XlWrkBkWriter: DotNet "WorkbookWriter";
        //       XlWrkBkReader@1023 :
        XlWrkBkReader: DotNet "WorkbookReader";
        //       XlWrkShtWriter@1024 :
        XlWrkShtWriter: DotNet "WorksheetWriter";
        //       XlWrkShtReader@1043 :
        XlWrkShtReader: DotNet "WorksheetReader";
        //       StringBld@1011 :
        StringBld: DotNet "StringBuilder";
        //       RangeStartXlRow@1034 :
        RangeStartXlRow: Text[30];
        //       RangeStartXlCol@1033 :
        RangeStartXlCol: Text[30];
        //       RangeEndXlRow@1032 :
        RangeEndXlRow: Text[30];
        //       RangeEndXlCol@1031 :
        RangeEndXlCol: Text[30];
        //       FileNameServer@1046 :
        FileNameServer: Text;
        //       FriendlyName@1025 :
        FriendlyName: Text;
        //       CurrentRow@1029 :
        CurrentRow: Integer;
        //       CurrentCol@1030 :
        CurrentCol: Integer;
        //       UseInfoSheet@1035 :
        UseInfoSheet: Boolean;
        //       Text022@1041 :
        Text022:
// {Locked} Used to define an Excel range name. You must refer to Excel rules to change this term.
TextConst ENU = 'CostAcc', ESP = 'CostAcc';
        //       Text023@1037 :
        Text023: TextConst ENU = 'Information', ESP = 'Informaci�n';
        //       Text034@1039 :
        Text034:
// "{Split=r''\|\*\..{1,4}\|?''}{Locked=""Excel""}"
TextConst ENU = 'Excel Files (*.xls*)|*.xls*|All Files (*.*)|*.*', ESP = 'Archivos de Excel (*.xls*)|*.xls*|Todos los archivos (*.*)|*.*';
        //       Text035@1040 :
        Text035: TextConst ENU = 'The operation was canceled.', ESP = 'Se cancel� la operaci�n.';
        //       Text037@1047 :
        Text037:
// "{Locked=""Excel""}"
TextConst ENU = 'Could not create the Excel workbook.', ESP = 'No se pudo crear el libro Excel.';
        //       Text038@1048 :
        Text038: TextConst ENU = 'Global variable %1 is not included for test.', ESP = 'La variable global %1 no est� incluida para pruebas.';
        //       Text039@1050 :
        Text039: TextConst ENU = 'Cell type has not been set.', ESP = 'No se ha establecido el tipo de celda.';
        //       SavingDocumentMsg@1010 :
        SavingDocumentMsg: TextConst ENU = 'Saving the following document: %1.', ESP = 'Guardando el documento siguiente: %1.';
        //       ExcelFileExtensionTok@1012 :
        ExcelFileExtensionTok:
// {Locked}
TextConst ENU = '.xlsx', ESP = '.xlsx';
        //       VmlDrawingXmlTxt@1093 :
        VmlDrawingXmlTxt:
// {Locked}
TextConst ENU = '<xml xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel""><o:shapelayout v:ext=""edit""><o:idmap v:ext=""edit"" data=""1""/></o:shapelayout><v:shapetype id=""_x0000_t202"" coordsize=""21600,21600"" o:spt=""202""  path=""m,l,21600r21600,l21600,xe""><v:stroke joinstyle=""miter""/><v:path gradientshapeok=""t"" o:connecttype=""rect""/></v:shapetype>', ESP = '<xml xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel""><o:shapelayout v:ext=""edit""><o:idmap v:ext=""edit"" data=""1""/></o:shapelayout><v:shapetype id=""_x0000_t202"" coordsize=""21600,21600"" o:spt=""202""  path=""m,l,21600r21600,l21600,xe""><v:stroke joinstyle=""miter""/><v:path gradientshapeok=""t"" o:connecttype=""rect""/></v:shapetype>';
        //       EndXmlTokenTxt@1098 :
        EndXmlTokenTxt:
// {Locked}
TextConst ENU = '</xml>', ESP = '</xml>';
        //       ErrorMessage@1026 :
        ErrorMessage: Text;
        //       BoolImportMeasure@1100286000 :
        BoolImportMeasure: Boolean;


    //     procedure CreateNewBook (SheetName@1000 :

    /*
    procedure CreateNewBook (SheetName: Text[250])
        begin
          CreateBook('',SheetName);
        end;
    */



    //     procedure CreateBook (FileName@1001 : Text;SheetName@1000 :

    /*
    procedure CreateBook (FileName: Text;SheetName: Text)
        begin
          if SheetName = '' then
            ERROR(Text002);

          if FileName = '' then
            FileNameServer := FileManagement.ServerTempFileName('xlsx')
          else begin
            if EXISTS(FileName) then
              ERASE(FileName);
            FileNameServer := FileName;
          end;

          XlWrkBkWriter := XlWrkBkWriter.Create(FileNameServer);
          if ISNULL(XlWrkBkWriter) then
            ERROR(Text037);

          XlWrkShtWriter := XlWrkBkWriter.FirstWorksheet;
          if SheetName <> '' then
            XlWrkShtWriter.Name := SheetName;

          OpenXMLManagement.SetupWorksheetHelper(XlWrkBkWriter);
        end;
    */



    //     procedure OpenBook (FileName@1000 : Text;SheetName@1001 :

    /*
    procedure OpenBook (FileName: Text;SheetName: Text)
        begin
          if FileName = '' then
            ERROR(Text001);

          if SheetName = '' then
            ERROR(Text002);

          if SheetName = 'G/L Account' then
            SheetName := 'GL Account';

          FileManagement.IsAllowedPath(FileName,FALSE);
          XlWrkBkReader := XlWrkBkReader.Open(FileName);
          if XlWrkBkReader.HasWorksheet(SheetName) then begin
            XlWrkShtReader := XlWrkBkReader.GetWorksheetByName(SheetName);
          end else begin
            CloseBook;
            ERROR(Text004,SheetName);
          end;
        end;
    */



    //     procedure OpenBookStream (FileStream@1000 : InStream;SheetName@1001 :

    /*
    procedure OpenBookStream (FileStream: InStream;SheetName: Text) : Text;
        begin
          if SheetName = '' then
            exit(Text002);

          if SheetName = 'G/L Account' then
            SheetName := 'GL Account';

          XlWrkBkReader := XlWrkBkReader.Open(FileStream);
          if XlWrkBkReader.HasWorksheet(SheetName) then
            XlWrkShtReader := XlWrkBkReader.GetWorksheetByName(SheetName)
          else begin
            CloseBook;
            ErrorMessage := STRSUBSTNO(Text004,SheetName);
            exit(ErrorMessage);
          end;
        end;
    */



    //     procedure UpdateBook (FileName@1000 : Text;SheetName@1001 :

    /*
    procedure UpdateBook (FileName: Text;SheetName: Text)
        begin
          UpdateBookExcel(FileName,SheetName,TRUE);
        end;
    */



    //     procedure UpdateBookExcel (FileName@1001 : Text;SheetName@1000 : Text;PreserveDataOnUpdate@1002 :

    /*
    procedure UpdateBookExcel (FileName: Text;SheetName: Text;PreserveDataOnUpdate: Boolean)
        begin
          if FileName = '' then
            ERROR(Text001);

          if SheetName = '' then
            ERROR(Text002);

          FileNameServer := FileName;
          FileManagement.IsAllowedPath(FileName,FALSE);
          XlWrkBkWriter := XlWrkBkWriter.Open(FileNameServer);
          if XlWrkBkWriter.HasWorksheet(SheetName) then begin
            XlWrkShtWriter := XlWrkBkWriter.GetWorksheetByName(SheetName);
            // Set PreserverDataOnUpdate to false if the sheet writer should clear all empty cells
            // in which NAV does not have new data. Notice that the sheet writer will only clear Excel
            // cells that are addressed by the writer. All other cells will be left unmodified.
            XlWrkShtWriter.PreserveDataOnUpdate := PreserveDataOnUpdate;

            OpenXMLManagement.SetupWorksheetHelper(XlWrkBkWriter);
          end else begin
            CloseBook;
            ERROR(Text004,SheetName);
          end;
        end;
    */



    //     procedure UpdateBookStream (var ExcelStream@1000 : InStream;SheetName@1001 : Text;PreserveDataOnUpdate@1002 :

    /*
    procedure UpdateBookStream (var ExcelStream: InStream;SheetName: Text;PreserveDataOnUpdate: Boolean)
        begin
          FileNameServer := FileManagement.InstreamExportToServerFile(ExcelStream,'xlsx');

          UpdateBookExcel(FileNameServer,SheetName,PreserveDataOnUpdate);
        end;
    */




    /*
    procedure CloseBook ()
        begin
          if not ISNULL(XlWrkBkWriter) then begin
            XlWrkBkWriter.ClearFormulaCalculations;
            XlWrkBkWriter.ValidateDocument;
            XlWrkBkWriter.Close;
            CLEAR(XlWrkShtWriter);
            CLEAR(XlWrkBkWriter);
          end;

          if not ISNULL(XlWrkBkReader) then begin
            CLEAR(XlWrkShtReader);
            CLEAR(XlWrkBkReader);
          end;
        end;
    */



    //     procedure SelectOrAddSheet (NewSheetName@1000 :

    /*
    procedure SelectOrAddSheet (NewSheetName: Text)
        begin
          if NewSheetName = '' then
            exit;
          if ISNULL(XlWrkBkWriter) then
            ERROR(Text037);
          if XlWrkBkWriter.HasWorksheet(NewSheetName) then
            XlWrkShtWriter := XlWrkBkWriter.GetWorksheetByName(NewSheetName)
          else
            XlWrkShtWriter := XlWrkBkWriter.AddWorksheet(NewSheetName);
        end;
    */



    //     procedure SetActiveReaderSheet (NewSheetName@1000 :

    /*
    procedure SetActiveReaderSheet (NewSheetName: Text)
        begin
          if NewSheetName = '' then
            exit;

          if XlWrkBkReader.HasWorksheet(NewSheetName) then
            XlWrkShtReader := XlWrkBkReader.GetWorksheetByName(NewSheetName)
          else begin
            CloseBook;
            ERROR(Text004,NewSheetName);
          end;
        end;
    */



    //     procedure WriteSheet (ReportHeader@1001 : Text;CompanyName2@1002 : Text;UserID2@1003 :

    /*
    procedure WriteSheet (ReportHeader: Text;CompanyName2: Text;UserID2: Text)
        var
    //       OrientationValues@1000 :
          OrientationValues: DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.OrientationValues";
    //       XmlTextWriter@1013 :
          XmlTextWriter: DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
    //       FileMode@1007 :
          FileMode: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
    //       Encoding@1006 :
          Encoding: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    //       VmlDrawingPart@1004 :
          VmlDrawingPart: DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.VmlDrawingPart";
    //       CRLF@1008 :
          CRLF: Char;
        begin
          CRLF := 10;

          XlWrkShtWriter.AddPageSetup(OrientationValues.Landscape,9); // 9 - default value for Paper Size - A4
          if ReportHeader <> '' then
            XlWrkShtWriter.AddHeader(
              TRUE,
              STRSUBSTNO('%1%2%1%3%4',GetExcelReference(1),ReportHeader,CRLF,CompanyName2));

          XlWrkShtWriter.AddHeader(
            FALSE,
            STRSUBSTNO('%1%3%4%3%5 %2',GetExcelReference(2),GetExcelReference(3),CRLF,UserID2,PageTxt));

          OpenXMLManagement.AddAndInitializeCommentsPart(XlWrkShtWriter,VmlDrawingPart);

          StringBld := StringBld.StringBuilder;
          StringBld.Append(VmlDrawingXmlTxt);

          WriteAllToCurrentSheet(Rec);

          StringBld.Append(EndXmlTokenTxt);

          XmlTextWriter := XmlTextWriter.XmlTextWriter(VmlDrawingPart.GetStream(FileMode.Create),Encoding.UTF8);
          XmlTextWriter.WriteRaw(StringBld.ToString);
          XmlTextWriter.Flush;
          XmlTextWriter.Close;

          if UseInfoSheet then
            if not TempInfoExcelBuf.ISEMPTY then begin
              SelectOrAddSheet(Text023);
              WriteAllToCurrentSheet(TempInfoExcelBuf);
            end;
        end;
    */



    //     procedure WriteAllToCurrentSheet (var ExcelBuffer@1002 :

    /*
    procedure WriteAllToCurrentSheet (var ExcelBuffer: Record 370)
        var
    //       ExcelBufferDialogMgt@1000 :
          ExcelBufferDialogMgt: Codeunit 5370;
    //       RecNo@1001 :
          RecNo: Integer;
    //       TotalRecNo@1004 :
          TotalRecNo: Integer;
    //       LastUpdate@1003 :
          LastUpdate: DateTime;
        begin
          if ExcelBuffer.ISEMPTY then
            exit;
          ExcelBufferDialogMgt.Open(Text005);
          LastUpdate := CURRENTDATETIME;
          TotalRecNo := ExcelBuffer.COUNT;
          if ExcelBuffer.FINDSET then
            repeat
              RecNo := RecNo + 1;
              if not UpdateProgressDialog(ExcelBufferDialogMgt,LastUpdate,RecNo,TotalRecNo) then begin
                CloseBook;
                ERROR(Text035)
              end;
              if Formula = '' then
                WriteCellValue(ExcelBuffer)
              else
                WriteCellFormula(ExcelBuffer)
            until ExcelBuffer.NEXT = 0;
          ExcelBufferDialogMgt.Close;
        end;
    */



    //     procedure WriteCellValue (ExcelBuffer@1000 :

    /*
    procedure WriteCellValue (ExcelBuffer: Record 370)
        var
    //       Decorator@1001 :
          Decorator: DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=13.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator";
        begin
          WITH ExcelBuffer DO begin
            GetCellDecorator(Bold,Italic,Underline,"Double Underline",Decorator);

            CASE "Cell Type" OF
              "Cell Type"::Number:
                XlWrkShtWriter.SetCellValueNumber("Row No.",xlColID,"Cell Value as Text",NumberFormat,Decorator);
              "Cell Type"::Text:
                XlWrkShtWriter.SetCellValueText("Row No.",xlColID,"Cell Value as Text",Decorator);
              "Cell Type"::Date:
                XlWrkShtWriter.SetCellValueDate("Row No.",xlColID,"Cell Value as Text",NumberFormat,Decorator);
              "Cell Type"::Time:
                XlWrkShtWriter.SetCellValueTime("Row No.",xlColID,"Cell Value as Text",NumberFormat,Decorator);
              else
                ERROR(Text039)
            end;

            if Comment <> '' then begin
              OpenXMLManagement.SetCellComment(XlWrkShtWriter,STRSUBSTNO('%1%2',xlColID,"Row No."),Comment);
              StringBld.Append(OpenXMLManagement.CreateCommentVmlShapeXml("Column No.","Row No."));
            end;
          end;
        end;
    */



    //     procedure WriteCellFormula (ExcelBuffer@1000 :

    /*
    procedure WriteCellFormula (ExcelBuffer: Record 370)
        var
    //       Decorator@1001 :
          Decorator: DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=13.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator";
        begin
          WITH ExcelBuffer DO begin
            GetCellDecorator(Bold,Italic,Underline,"Double Underline",Decorator);

            XlWrkShtWriter.SetCellFormula("Row No.",xlColID,GetFormula,NumberFormat,Decorator);
          end;
        end;
    */


    //     LOCAL procedure GetCellDecorator (IsBold@1000 : Boolean;IsItalic@1001 : Boolean;IsUnderlined@1002 : Boolean;IsDoubleUnderlined@1004 : Boolean;var Decorator@1003 :

    /*
    LOCAL procedure GetCellDecorator (IsBold: Boolean;IsItalic: Boolean;IsUnderlined: Boolean;IsDoubleUnderlined: Boolean;var Decorator: DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=13.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator")
        begin
          if IsBold and IsItalic then begin
            if IsDoubleUnderlined then begin
              Decorator := XlWrkShtWriter.DefaultBoldItalicDoubleUnderlinedCellDecorator;
              exit;
            end;
            if IsUnderlined then begin
              Decorator := XlWrkShtWriter.DefaultBoldItalicUnderlinedCellDecorator;
              exit;
            end;
          end;

          if IsBold and IsItalic then begin
            Decorator := XlWrkShtWriter.DefaultBoldItalicCellDecorator;
            exit;
          end;

          if IsBold then begin
            if IsDoubleUnderlined then begin
              Decorator := XlWrkShtWriter.DefaultBoldDoubleUnderlinedCellDecorator;
              exit;
            end;
            if IsUnderlined then begin
              Decorator := XlWrkShtWriter.DefaultBoldUnderlinedCellDecorator;
              exit;
            end;
          end;

          if IsBold then begin
            Decorator := XlWrkShtWriter.DefaultBoldCellDecorator;
            exit;
          end;

          if IsItalic then begin
            if IsDoubleUnderlined then begin
              Decorator := XlWrkShtWriter.DefaultItalicDoubleUnderlinedCellDecorator;
              exit;
            end;
            if IsUnderlined then begin
              Decorator := XlWrkShtWriter.DefaultItalicUnderlinedCellDecorator;
              exit;
            end;
          end;

          if IsItalic then begin
            Decorator := XlWrkShtWriter.DefaultItalicCellDecorator;
            exit;
          end;

          if IsDoubleUnderlined then
            Decorator := XlWrkShtWriter.DefaultDoubleUnderlinedCellDecorator
          else begin
            if IsUnderlined then
              Decorator := XlWrkShtWriter.DefaultUnderlinedCellDecorator
            else
              Decorator := XlWrkShtWriter.DefaultCellDecorator;
          end;
        end;
    */



    //     procedure SetColumnWidth (ColName@1000 : Text[10];NewColWidth@1001 :

    /*
    procedure SetColumnWidth (ColName: Text[10];NewColWidth: Decimal)
        begin
          if not ISNULL(XlWrkShtWriter) then
            XlWrkShtWriter.SetColumnWidth(ColName,NewColWidth);
        end;
    */



    //     procedure CreateRangeName (RangeName@1000 : Text[30];FromColumnNo@1001 : Integer;FromRowNo@1002 :

    /*
    procedure CreateRangeName (RangeName: Text[30];FromColumnNo: Integer;FromRowNo: Integer)
        var
    //       TempExcelBuf@1005 :
          TempExcelBuf: Record 370 TEMPORARY;
    //       ToxlRowID@1004 :
          ToxlRowID: Text[10];
        begin
          SETCURRENTKEY("Row No.","Column No.");
          if FIND('+') then
            ToxlRowID := xlRowID;
          TempExcelBuf.VALIDATE("Row No.",FromRowNo);
          TempExcelBuf.VALIDATE("Column No.",FromColumnNo);

          XlWrkShtWriter.AddRange(
            RangeName,
            GetExcelReference(4) + TempExcelBuf.xlColID + GetExcelReference(4) + TempExcelBuf.xlRowID +
            ':' +
            GetExcelReference(4) + TempExcelBuf.xlColID + GetExcelReference(4) + ToxlRowID);
        end;
    */




    /*
    procedure ReadSheet ()
        begin
          ReadSheetContinous('',TRUE);
        end;
    */



    //     procedure ReadSheetContinous (SheetName@1005 : Text;CloseBookOnCompletion@1000 :

    /*
    procedure ReadSheetContinous (SheetName: Text;CloseBookOnCompletion: Boolean)
        var
    //       ExcelBufferDialogMgt@1003 :
          ExcelBufferDialogMgt: Codeunit 5370;
    //       CellData@1002 :
          CellData: DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=13.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellData";
    //       Enumerator@1001 :
          Enumerator: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
    //       RowCount@1009 :
          RowCount: Integer;
    //       LastUpdate@1004 :
          LastUpdate: DateTime;
        begin
          // Allows reading Excel files with more than one sheet without closing and reopening file
          if SheetName <> '' then
            SetActiveReaderSheet(SheetName);
          LastUpdate := CURRENTDATETIME;
          ExcelBufferDialogMgt.Open(Text007);
          DELETEALL;

          Enumerator := XlWrkShtReader.GetEnumerator;
          RowCount := XlWrkShtReader.RowCount;
          WHILE Enumerator.MoveNext DO begin
            CellData := Enumerator.Current;
            if CellData.HasValue then begin
              VALIDATE("Row No.",CellData.RowNumber);
              VALIDATE("Column No.",CellData.ColumnNumber);
              ParseCellValue(CellData.Value,CellData.Format);
              INSERT;

              if not UpdateProgressDialog(ExcelBufferDialogMgt,LastUpdate,CellData.RowNumber,RowCount) then begin
                CloseBook;
                ERROR(Text035)
              end;
            end;
          end;

          if CloseBookOnCompletion then
            CloseBook;
          ExcelBufferDialogMgt.Close;
        end;
    */


    //     LOCAL procedure ParseCellValue (Value@1000 : Text;FormatString@1001 :
    LOCAL procedure ParseCellValue(Value: Text; FormatString: Text)
    var
        //       Decimal@1004 :
        Decimal: Decimal;
        //       OutStr@1100286003 :
        OutStr: OutStream;
        //       InStr@1100286002 :
        InStr: InStream;
        //       BigTextValue@1100286001 :
        BigTextValue: BigText;
        //       StrText@1100286000 :
        StrText: Text;
        //       txtValue@1100286004 :
        txtValue: Text;
    begin
        // The format contains only en-US number separators, this is an OpenXML standard requirement
        // The algorithm sieves the data based on formatting as follows (the steps must run in this order)
        // 1. FormatString = '@' -> Text
        // 2. FormatString.Contains(':') -> Time
        // 3. FormatString.ContainsOneOf('y', 'm', 'd') && FormatString.DoesNotContain('Red') -> Date
        // 4. anything else -> Decimal

        NumberFormat := COPYSTR(FormatString, 1, 30);

        if FormatString = '@' then begin
            "Cell Type" := "Cell Type"::Text;
            //-QB_2785
            CLEAR(BigTextValue);
            BigTextValue.ADDTEXT(Value);

            "Cell Value as Text2".CREATEOUTSTREAM(OutStr);
            BigTextValue.WRITE(OutStr);
            TA370_OnParseCellValue_LimitTo250Chars(Value);
            //+QB_2785
            "Cell Value as Text" := Value;
            exit;
        end;

        //QUONEXT PER 09.07.19
        if BoolImportMeasure then
            txtValue := CONVERTSTR(Value, '.', ',');
        //FIN QUONEXT PER 09.07.19

        EVALUATE(Decimal, Value);

        if STRPOS(FormatString, ':') <> 0 then begin
            // Excel Time is stored in OADate format
            "Cell Type" := "Cell Type"::Time;
            "Cell Value as Text" := FORMAT(DT2TIME(ConvertDateTimeDecimalToDateTime(Decimal)));
            exit;
        end;

        if ((STRPOS(FormatString, 'y') <> 0) or
            (STRPOS(FormatString, 'm') <> 0) or
            (STRPOS(FormatString, 'd') <> 0)) and
           (STRPOS(FormatString, 'Red') = 0)
        then begin
            "Cell Type" := "Cell Type"::Date;
            "Cell Value as Text" := FORMAT(DT2DATE(ConvertDateTimeDecimalToDateTime(Decimal)));
            exit;
        end;

        //QUONEXT PER 09.07.19
        if BoolImportMeasure then
            EVALUATE(Decimal, txtValue);
        //FIN QUONEXT PER 09.07.19

        "Cell Type" := "Cell Type"::Number;
        "Cell Value as Text" := FORMAT(ROUND(Decimal, 0.000001), 0, 1);
    end;


    //     procedure SelectSheetsName (FileName@1000 :

    /*
    procedure SelectSheetsName (FileName: Text) : Text[250];
        var
          TempBlob : Codeunit "Temp Blob";
    Blob : OutStream;
    InStr : InStream;

    //       InStr@1002 :
          InStr: InStream;
        begin
          if FileName = '' then
            ERROR(Text001);

          FileManagement.BLOBImportFromServerFile(TempBlob,FileName);
          //TempBlob.Blob.CREATEINSTREAM(InStr); 
     //To be tested 
     TempBlob.CREATEINSTREAM(InStr);
          exit(SelectSheetsNameStream(InStr));
        end;
    */



    //     procedure SelectSheetsNameStream (FileStream@1000 :

    /*
    procedure SelectSheetsNameStream (FileStream: InStream) : Text[250];
        var
    //       TempNameValueBuffer@1009 :
          TempNameValueBuffer: Record 823 TEMPORARY;
    //       SelectedSheetName@1007 :
          SelectedSheetName: Text[250];
        begin
          if GetSheetsNameListFromStream(FileStream,TempNameValueBuffer) then
            if TempNameValueBuffer.COUNT = 1 then
              SelectedSheetName := TempNameValueBuffer.Value
            else begin
              TempNameValueBuffer.FINDFIRST;
              if PAGE.RUNMODAL(PAGE::"Name/Value Lookup",TempNameValueBuffer) = ACTION::LookupOK then
                SelectedSheetName := TempNameValueBuffer.Value;
            end;

          exit(SelectedSheetName);
        end;
    */



    //     procedure GetExcelReference (Which@1000 :

    /*
    procedure GetExcelReference (Which: Integer) : Text[250];
        begin
          CASE Which OF
            1:
              exit(Text013);
            // DO not TRANSLATE: &B is the Excel code to turn bold printing on or off for customized Header/Footer.
            2:
              exit(Text014);
            // DO not TRANSLATE: &D is the Excel code to print the current date in customized Header/Footer.
            3:
              exit(Text015);
            // DO not TRANSLATE: &P is the Excel code to print the page number in customized Header/Footer.
            4:
              exit(');
            // DO not TRANSLATE: $ is the Excel code for absolute reference to cells.
            5:
              exit(Text016);
            // DO not TRANSLATE: A1 is the Excel reference of the first cell.
            6:
              exit(Text017);
            // DO not TRANSLATE: SUMIF is the name of the Excel function used to summarize values according to some conditions.
            7:
              exit(Text018);
            // DO not TRANSLATE: The #N/A Excel error value occurs when a value is not available to a function or formula.
            8:
              exit(Text019);
            // DO not TRANSLATE: GLAcc is used to define an Excel range name. You must refer to Excel rules to change this term.
            9:
              exit(Text020);
            // DO not TRANSLATE: Period is used to define an Excel range name. You must refer to Excel rules to change this term.
            10:
              exit(Text021);
            // DO not TRANSLATE: Budget is used to define an Excel worksheet name. You must refer to Excel rules to change this term.
            11:
              exit(Text022);
            // DO not TRANSLATE: CostAcc is used to define an Excel range name. You must refer to Excel rules to change this term.
          end;
        end;
    */



    //     procedure ExportBudgetFilterToFormula (var ExcelBuf@1000 :

    /*
    procedure ExportBudgetFilterToFormula (var ExcelBuf: Record 370) : Boolean;
        var
    //       TempExcelBufFormula@1001 :
          TempExcelBufFormula: Record 370 TEMPORARY;
    //       TempExcelBufFormula2@1004 :
          TempExcelBufFormula2: Record 370 TEMPORARY;
    //       FirstRow@1002 :
          FirstRow: Integer;
    //       LastRow@1003 :
          LastRow: Integer;
    //       HasFormulaError@1005 :
          HasFormulaError: Boolean;
    //       ThisCellHasFormulaError@1006 :
          ThisCellHasFormulaError: Boolean;
        begin
          ExcelBuf.SETFILTER(Formula,'<>%1','');
          if ExcelBuf.FINDSET then
            repeat
              TempExcelBufFormula := ExcelBuf;
              TempExcelBufFormula.INSERT;
            until ExcelBuf.NEXT = 0;
          ExcelBuf.RESET;

          WITH TempExcelBufFormula DO
            if FINDSET then
              repeat
                ThisCellHasFormulaError := FALSE;
                ExcelBuf.SETRANGE("Column No.",1);
                ExcelBuf.SETFILTER("Row No.",'<>%1',"Row No.");
                ExcelBuf.SETFILTER("Cell Value as Text",Formula);
                TempExcelBufFormula2 := TempExcelBufFormula;
                if ExcelBuf.FINDSET then
                  repeat
                    if not GET(ExcelBuf."Row No.","Column No.") then
                      ExcelBuf.MARK(TRUE);
                  until ExcelBuf.NEXT = 0;
                TempExcelBufFormula := TempExcelBufFormula2;
                ClearFormula;
                ExcelBuf.SETRANGE("Cell Value as Text");
                ExcelBuf.SETRANGE("Row No.");
                if ExcelBuf.FINDSET then
                  repeat
                    if ExcelBuf.MARK then begin
                      LastRow := ExcelBuf."Row No.";
                      if FirstRow = 0 then
                        FirstRow := LastRow;
                    end else
                      if FirstRow <> 0 then begin
                        if FirstRow = LastRow then
                          ThisCellHasFormulaError := AddToFormula(xlColID + FORMAT(FirstRow))
                        else
                          ThisCellHasFormulaError :=
                            AddToFormula('SUM(' + xlColID + FORMAT(FirstRow) + ':' + xlColID + FORMAT(LastRow) + ')');
                        FirstRow := 0;
                        if ThisCellHasFormulaError then
                          SetFormula(ExcelBuf.GetExcelReference(7));
                      end;
                  until ThisCellHasFormulaError or (ExcelBuf.NEXT = 0);

                if not ThisCellHasFormulaError and (FirstRow <> 0) then begin
                  if FirstRow = LastRow then
                    ThisCellHasFormulaError := AddToFormula(xlColID + FORMAT(FirstRow))
                  else
                    ThisCellHasFormulaError :=
                      AddToFormula('SUM(' + xlColID + FORMAT(FirstRow) + ':' + xlColID + FORMAT(LastRow) + ')');
                  FirstRow := 0;
                  if ThisCellHasFormulaError then
                    SetFormula(ExcelBuf.GetExcelReference(7));
                end;

                ExcelBuf.RESET;
                ExcelBuf.GET("Row No.","Column No.");
                ExcelBuf.SetFormula(GetFormula);
                ExcelBuf.MODIFY;
                HasFormulaError := HasFormulaError or ThisCellHasFormulaError;
              until NEXT = 0;

          exit(HasFormulaError);
        end;
    */



    //     procedure AddToFormula (Text@1001 :

    /*
    procedure AddToFormula (Text: Text[30]) : Boolean;
        var
    //       Overflow@1002 :
          Overflow: Boolean;
    //       LongFormula@1000 :
          LongFormula: Text[1000];
        begin
          LongFormula := GetFormula;
          if LongFormula = '' then
            LongFormula := '=';
          if LongFormula <> '=' then
            if STRLEN(LongFormula) + 1 > MAXSTRLEN(LongFormula) then
              Overflow := TRUE
            else
              LongFormula := LongFormula + '+';
          if STRLEN(LongFormula) + STRLEN(Text) > MAXSTRLEN(LongFormula) then
            Overflow := TRUE
          else
            SetFormula(LongFormula + Text);
          exit(Overflow);
        end;
    */




    /*
    procedure GetFormula () : Text[1000];
        begin
          exit(Formula + Formula2 + Formula3 + Formula4);
        end;
    */



    //     procedure SetFormula (LongFormula@1000 :

    /*
    procedure SetFormula (LongFormula: Text[1000])
        begin
          ClearFormula;
          if LongFormula = '' then
            exit;

          Formula := COPYSTR(LongFormula,1,MAXSTRLEN(Formula));
          if STRLEN(LongFormula) > MAXSTRLEN(Formula) then
            Formula2 := COPYSTR(LongFormula,MAXSTRLEN(Formula) + 1,MAXSTRLEN(Formula2));
          if STRLEN(LongFormula) > MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) then
            Formula3 := COPYSTR(LongFormula,MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) + 1,MAXSTRLEN(Formula3));
          if STRLEN(LongFormula) > MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) + MAXSTRLEN(Formula3) then
            Formula4 := COPYSTR(LongFormula,MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) + MAXSTRLEN(Formula3) + 1,MAXSTRLEN(Formula4));
        end;
    */




    /*
    procedure ClearFormula ()
        begin
          Formula := '';
          Formula2 := '';
          Formula3 := '';
          Formula4 := '';
        end;
    */




    /*
    procedure NewRow ()
        begin
          SetCurrent(CurrentRow + 1,0);
        end;
    */



    //     procedure AddColumn (Value@1000 : Variant;IsFormula@1001 : Boolean;CommentText@1002 : Text;IsBold@1003 : Boolean;IsItalics@1004 : Boolean;IsUnderline@1005 : Boolean;NumFormat@1006 : Text[30];CellType@1007 :

    /*
    procedure AddColumn (Value: Variant;IsFormula: Boolean;CommentText: Text;IsBold: Boolean;IsItalics: Boolean;IsUnderline: Boolean;NumFormat: Text[30];CellType: Option)
        begin
          AddColumnToBuffer(Rec,Value,IsFormula,CommentText,IsBold,IsItalics,IsUnderline,NumFormat,CellType);
        end;
    */



    //     procedure AddInfoColumn (Value@1006 : Variant;IsFormula@1005 : Boolean;IsBold@1003 : Boolean;IsItalics@1002 : Boolean;IsUnderline@1001 : Boolean;NumFormat@1000 : Text[30];CellType@1007 :

    /*
    procedure AddInfoColumn (Value: Variant;IsFormula: Boolean;IsBold: Boolean;IsItalics: Boolean;IsUnderline: Boolean;NumFormat: Text[30];CellType: Option)
        begin
          AddColumnToBuffer(TempInfoExcelBuf,Value,IsFormula,'',IsBold,IsItalics,IsUnderline,NumFormat,CellType);
        end;
    */


    //     LOCAL procedure AddColumnToBuffer (var ExcelBuffer@1008 : Record 370;Value@1000 : Variant;IsFormula@1001 : Boolean;CommentText@1002 : Text;IsBold@1003 : Boolean;IsItalics@1004 : Boolean;IsUnderline@1005 : Boolean;NumFormat@1006 : Text[30];CellType@1007 :

    /*
    LOCAL procedure AddColumnToBuffer (var ExcelBuffer: Record 370;Value: Variant;IsFormula: Boolean;CommentText: Text;IsBold: Boolean;IsItalics: Boolean;IsUnderline: Boolean;NumFormat: Text[30];CellType: Option)
        begin
          if CurrentRow < 1 then
            NewRow;

          CurrentCol := CurrentCol + 1;
          ExcelBuffer.INIT;
          ExcelBuffer.VALIDATE("Row No.",CurrentRow);
          ExcelBuffer.VALIDATE("Column No.",CurrentCol);
          if IsFormula then
            ExcelBuffer.SetFormula(FORMAT(Value))
          else
            ExcelBuffer."Cell Value as Text" := FORMAT(Value);
          ExcelBuffer.Comment := COPYSTR(CommentText,1,MAXSTRLEN(ExcelBuffer.Comment));
          ExcelBuffer.Bold := IsBold;
          ExcelBuffer.Italic := IsItalics;
          ExcelBuffer.Underline := IsUnderline;
          ExcelBuffer.NumberFormat := NumFormat;
          ExcelBuffer."Cell Type" := CellType;
          ExcelBuffer.INSERT;
        end;
    */



    //     procedure EnterCell (var ExcelBuffer@1006 : Record 370;RowNo@1000 : Integer;ColumnNo@1001 : Integer;Value@1002 : Variant;IsBold@1005 : Boolean;IsItalics@1004 : Boolean;IsUnderline@1003 :

    /*
    procedure EnterCell (var ExcelBuffer: Record 370;RowNo: Integer;ColumnNo: Integer;Value: Variant;IsBold: Boolean;IsItalics: Boolean;IsUnderline: Boolean)
        begin
          ExcelBuffer.INIT;
          ExcelBuffer.VALIDATE("Row No.",RowNo);
          ExcelBuffer.VALIDATE("Column No.",ColumnNo);

          CASE TRUE OF
            Value.ISDECIMAL or Value.ISINTEGER:
              ExcelBuffer.VALIDATE("Cell Type",ExcelBuffer."Cell Type"::Number);
            Value.ISDATE:
              ExcelBuffer.VALIDATE("Cell Type",ExcelBuffer."Cell Type"::Date);
            else
              ExcelBuffer.VALIDATE("Cell Type",ExcelBuffer."Cell Type"::Text);
          end;

          ExcelBuffer."Cell Value as Text" := COPYSTR(FORMAT(Value),1,MAXSTRLEN(ExcelBuffer."Cell Value as Text" ));
          ExcelBuffer.Bold := IsBold;
          ExcelBuffer.Italic := IsItalics;
          ExcelBuffer.Underline := IsUnderline;
          ExcelBuffer.INSERT(TRUE);
        end;
    */




    /*
    procedure StartRange ()
        var
    //       DummyExcelBuf@1000 :
          DummyExcelBuf: Record 370;
        begin
          DummyExcelBuf.VALIDATE("Row No.",CurrentRow);
          DummyExcelBuf.VALIDATE("Column No.",CurrentCol);

          RangeStartXlRow := DummyExcelBuf.xlRowID;
          RangeStartXlCol := DummyExcelBuf.xlColID;
        end;
    */




    /*
    procedure EndRange ()
        var
    //       DummyExcelBuf@1000 :
          DummyExcelBuf: Record 370;
        begin
          DummyExcelBuf.VALIDATE("Row No.",CurrentRow);
          DummyExcelBuf.VALIDATE("Column No.",CurrentCol);

          RangeEndXlRow := DummyExcelBuf.xlRowID;
          RangeEndXlCol := DummyExcelBuf.xlColID;
        end;
    */



    //     procedure CreateRange (RangeName@1000 :

    /*
    procedure CreateRange (RangeName: Text[250])
        begin
          XlWrkShtWriter.AddRange(
            RangeName,
            GetExcelReference(4) + RangeStartXlCol + GetExcelReference(4) + RangeStartXlRow +
            ':' +
            GetExcelReference(4) + RangeEndXlCol + GetExcelReference(4) + RangeEndXlRow);
        end;
    */




    /*
    procedure ClearNewRow ()
        begin
          SetCurrent(0,0);
        end;
    */




    /*
    procedure SetUseInfoSheet ()
        begin
          UseInfoSheet := TRUE;
        end;
    */



    //     procedure UTgetGlobalValue (globalVariable@1001 : Text[30];var value@1000 :

    /*
    procedure UTgetGlobalValue (globalVariable: Text[30];var value: Variant)
        begin
          CASE globalVariable OF
            'CurrentRow':
              value := CurrentRow;
            'CurrentCol':
              value := CurrentCol;
            'RangeStartXlRow':
              value := RangeStartXlRow;
            'RangeStartXlCol':
              value := RangeStartXlCol;
            'RangeEndXlRow':
              value := RangeEndXlRow;
            'RangeEndXlCol':
              value := RangeEndXlCol;
            'XlWrkSht':
              value := XlWrkShtWriter;
            'ExcelFile':
              value := FileNameServer;
            else
              ERROR(Text038,globalVariable);
          end;
        end;
    */



    //     procedure SetCurrent (NewCurrentRow@1000 : Integer;NewCurrentCol@1001 :

    /*
    procedure SetCurrent (NewCurrentRow: Integer;NewCurrentCol: Integer)
        begin
          CurrentRow := NewCurrentRow;
          CurrentCol := NewCurrentCol;
        end;
    */



    //     procedure CreateValidationRule (Range@1000 :

    /*
    procedure CreateValidationRule (Range: Code[20])
        begin
          XlWrkShtWriter.AddRangeDataValidation(
            Range,
            GetExcelReference(4) + RangeStartXlCol + GetExcelReference(4) + RangeStartXlRow +
            ':' +
            GetExcelReference(4) + RangeEndXlCol + GetExcelReference(4) + RangeEndXlRow);
        end;
    */




    /*
    procedure QuitExcel ()
        begin
          CloseBook;
        end;
    */




    /*
    procedure OpenExcel ()
        begin
          if OpenUsingDocumentService('') then
            exit;

          FileManagement.DownloadHandler(FileNameServer,'','',Text034,GetFriendlyFilename);
        end;
    */




    /*
    procedure DownloadAndOpenExcel ()
        begin
          OpenExcelWithName(GetFriendlyFilename);
        end;
    */



    //     procedure OpenExcelWithName (FileName@1000 :

    /*
    procedure OpenExcelWithName (FileName: Text)
        begin
          if FileName = '' then
            ERROR(Text001);

          if OpenUsingDocumentService(FileName) then
            exit;

          FileManagement.DownloadHandler(FileNameServer,'','',Text034,FileName);
        end;
    */


    //     LOCAL procedure OpenUsingDocumentService (FileName@1000 :

    /*
    LOCAL procedure OpenUsingDocumentService (FileName: Text) : Boolean;
        var
    //       DocumentServiceMgt@1005 :
          DocumentServiceMgt: Codeunit 9510;
    //       FileMgt@1004 :
          FileMgt: Codeunit 419;
    //       PathHelper@1003 :
          PathHelper: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
    //       DialogWindow@1002 :
          DialogWindow: Dialog;
    //       DocumentUrl@1001 :
          DocumentUrl: Text;
        begin
          if not EXISTS(FileNameServer) then
            ERROR(Text003,FileNameServer);

          // if document service is configured we save the generated document to SharePoint and open it from there.
          if DocumentServiceMgt.IsConfigured then begin
            if FileName = '' then
              FileName := 'Book.' + PathHelper.ChangeExtension(PathHelper.GetRandomFileName,'xlsx')
            else begin
              // if file is not applicable for the service it can not be opened using the document service.
              if not DocumentServiceMgt.IsServiceUri(FileName) then
                exit(FALSE);

              FileName := FileMgt.GetFileName(FileName);
            end;

            DialogWindow.OPEN(STRSUBSTNO(SavingDocumentMsg,FileName));
            DocumentUrl := DocumentServiceMgt.SaveFile(FileNameServer,FileName,TRUE);
            DocumentServiceMgt.OpenDocument(DocumentUrl);
            DialogWindow.CLOSE;
            exit(TRUE);
          end;

          exit(FALSE);
        end;
    */



    //     procedure CreateBookAndOpenExcel (FileName@1004 : Text;SheetName@1000 : Text[250];ReportHeader@1003 : Text;CompanyName2@1002 : Text;UserID2@1001 :

    /*
    procedure CreateBookAndOpenExcel (FileName: Text;SheetName: Text[250];ReportHeader: Text;CompanyName2: Text;UserID2: Text)
        begin
          CreateBook(FileName,SheetName);
          WriteSheet(ReportHeader,CompanyName2,UserID2);
          CloseBook;
          OpenExcel;
        end;
    */


    //     LOCAL procedure UpdateProgressDialog (var ExcelBufferDialogManagement@1000 : Codeunit 5370;var LastUpdate@1001 : DateTime;CurrentCount@1002 : Integer;TotalCount@1004 :

    /*
    LOCAL procedure UpdateProgressDialog (var ExcelBufferDialogManagement: Codeunit 5370;var LastUpdate: DateTime;CurrentCount: Integer;TotalCount: Integer) : Boolean;
        var
    //       CurrentTime@1003 :
          CurrentTime: DateTime;
        begin
          // Refresh at 100%, and every second in between 0% to 100%
          // Duration is measured in miliseconds -> 1 sec = 1000 ms
          CurrentTime := CURRENTDATETIME;
          if (CurrentCount = TotalCount) or (CurrentTime - LastUpdate >= 1000) then begin
            LastUpdate := CurrentTime;
            if not ExcelBufferDialogManagement.SetProgress(ROUND(CurrentCount / TotalCount * 10000,1)) then
              exit(FALSE);
          end;

          exit(TRUE)
        end;
    */



    /*
    LOCAL procedure GetFriendlyFilename () : Text;
        begin
          if FriendlyName = '' then
            exit('Book1' + ExcelFileExtensionTok);

          exit(FileManagement.StripNotsupportChrInFileName(FriendlyName) + ExcelFileExtensionTok);
        end;
    */



    //     procedure SetFriendlyFilename (Name@1000 :

    /*
    procedure SetFriendlyFilename (Name: Text)
        begin
          FriendlyName := Name;
        end;
    */



    //     procedure ConvertDateTimeDecimalToDateTime (DateTimeAsOADate@1000 :

    /*
    procedure ConvertDateTimeDecimalToDateTime (DateTimeAsOADate: Decimal) : DateTime;
        var
    //       DotNetDateTime@1003 :
          DotNetDateTime: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
    //       DotNetDateTimeWithKind@1002 :
          DotNetDateTimeWithKind: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
    //       DotNetDateTimeKind@1001 :
          DotNetDateTimeKind: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeKind";
        begin
          DotNetDateTime := DotNetDateTime.FromOADate(DateTimeAsOADate);
          DotNetDateTimeWithKind := DotNetDateTime.DateTime(DotNetDateTime.Ticks,DotNetDateTimeKind.Local);
          exit(DotNetDateTimeWithKind);
        end;
    */



    //     procedure SaveToStream (var ResultStream@1000 : OutStream;EraseFileAfterCompletion@1003 :

    /*
    procedure SaveToStream (var ResultStream: OutStream;EraseFileAfterCompletion: Boolean)
        var
          TempBlob : Codeunit "Temp Blob";
    Blob : OutStream;
    InStr : InStream;

    //       BlobStream@1002 :
          BlobStream: InStream;
        begin
          FileManagement.BLOBImportFromServerFile(TempBlob,FileNameServer);
          //TempBlob.Blob.CREATEINSTREAM(BlobStream); 
     //To be tested 
     TempBlob.CREATEINSTREAM(BlobStream);
          COPYSTREAM(ResultStream,BlobStream);
          if EraseFileAfterCompletion then
            FILE.ERASE(FileNameServer);
        end;
    */



    //     procedure GetSheetsNameListFromStream (FileStream@1000 : InStream;var TempNameValueBufferOut@1004 :

    /*
    procedure GetSheetsNameListFromStream (FileStream: InStream;var TempNameValueBufferOut: Record 823 TEMPORARY) SheetsFound : Boolean;
        var
    //       SheetNames@1008 :
          SheetNames: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.ArrayList";
    //       SheetName@1002 :
          SheetName: Text[250];
    //       i@1001 :
          i: Integer;
        begin
          XlWrkBkReader := XlWrkBkReader.Open(FileStream);
          TempNameValueBufferOut.RESET;
          TempNameValueBufferOut.DELETEALL;

          SheetNames := SheetNames.ArrayList(XlWrkBkReader.SheetNames);
          if ISNULL(SheetNames) then
            exit(FALSE);

          SheetsFound := SheetNames.Count > 0;

          if not SheetsFound then
            exit(FALSE);

          FOR i := 0 TO SheetNames.Count - 1 DO begin
            SheetName := SheetNames.Item(i);
            if SheetName <> '' then begin
              TempNameValueBufferOut.INIT;
              TempNameValueBufferOut.ID := i;
              TempNameValueBufferOut.Name := FORMAT(i + 1);
              TempNameValueBufferOut.Value := SheetName;
              TempNameValueBufferOut.INSERT;
            end;
          end;

          CloseBook;
        end;
    */



    //     LOCAL procedure TA370_OnParseCellValue_LimitTo250Chars (var Value@7001100 :


    LOCAL procedure TA370_OnParseCellValue_LimitTo250Chars(var Value: Text)
    begin
        //QB_2785
    end;





    procedure FncImportExcelMeasure()
    begin
        //QUONEXT PER 09.07.19
        BoolImportMeasure := TRUE;
    end;

    /*begin
    //{
//      PEL 11/07/18: - QB_2785 Limitar a 250 la entrada de datos para evitar error estandar.
//      PER 18/10/19: - QUONEXT Al cargar excel de mediciones, cambiarmos puntos por comas
//    }
    end.
  */
}






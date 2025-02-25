report 7207441 "Import Excel Horas"
{
  
  
    CaptionML=ENU='Importar informaci¢n desde Excel',ESP='Importar informaci¢n desde Excel';
    ProcessingOnly=true;
    
  dataset
{

}
  requestpage
  {
SaveValues=true;
    layout
{
area(content)
{
group("group920")
{
        
    field("opcUO";"opcUO")
    {
        
                  CaptionML=ESP='Tipo de U.O.';
    }
group("group922")
{
        
                  CaptionML=ESP='Columnas';

}

}

}
}
  }
  labels
{
}
  
    var
//       tempExcelBuf@1100286039 :
      tempExcelBuf: Record 370 TEMPORARY;
//       WorksheetHeaderqb@1100286001 :
      WorksheetHeaderqb: Record 7207290;
//       WorkSheetLinesqb@1100286000 :
      WorkSheetLinesqb: Record 7207291;
//       Window@1100286036 :
      Window: Dialog;
//       ServerFileName@1100286035 :
      ServerFileName: Text;
//       SheetName@1100286034 :
      SheetName: Text[250];
//       txtErrores@1100286029 :
      txtErrores: Text;
//       Linea@1100286027 :
      Linea: Integer;
//       Ultima@1100286026 :
      Ultima: Integer;
//       LinDoc@1100286025 :
      LinDoc: Integer;
//       LinPro@1100286015 :
      LinPro: Text;
//       LinUO@1100286016 :
      LinUO: Text;
//       LinRe@1100286020 :
      LinRe: Text;
//       LinTip@1100286021 :
      LinTip: Text;
//       LinFec@1100286023 :
      LinFec: Date;
//       LinCnt@1100286024 :
      LinCnt: Decimal;
//       "---------------------------------- Opciones"@1100286012 :
      "---------------------------------- Opciones": Integer;
//       opcUO@1100286011 :
      opcUO: Option "Presto","Proyecto";
//       opcCol@1100286007 :
      opcCol: ARRAY [10] OF Code[2];
//       ExcelFileExtensionTok@1100286022 :
      ExcelFileExtensionTok: 
// {Locked}
TextConst ENU='.xlsx',ESP='.xlsx';
//       Txt002@1100286019 :
      Txt002: TextConst ENU='Import Excel File',ESP='Importando hoja Excel';
//       Txt003@1100286017 :
      Txt003: TextConst ENU='Analyzing Data...\\',ESP='Cargando l¡nea #1####';
//       Txt004@1100286014 :
      Txt004: TextConst ESP='Existen l¡neas no cargadas, ¨desea verlas?';

    

trigger OnPreReport();    begin
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
                  WorkSheetLinesqb.RESET;
                  WorkSheetLinesqb.SETRANGE("Document No.",WorksheetHeaderqb."No.");
                  if WorkSheetLinesqb.FINDLAST then
                    LinDoc := WorkSheetLinesqb."Line No."
                  else
                    LinDoc := 0;

                  tempExcelBuf.RESET;
                  if tempExcelBuf.FINDLAST then
                    Ultima := tempExcelBuf."Row No.";

                  txtErrores := '';
                  Window.OPEN(Txt003);
                  FOR Linea := 1 TO Ultima DO begin
                    Window.UPDATE(1,FORMAT(Linea));
                    Leer(Linea);
                  end;
                  if (txtErrores <> '') then
                    if (CONFIRM(Txt004,TRUE)) then
                      MESSAGE(txtErrores);
                end;



// LOCAL procedure Leer (pLinea@1100286000 :
LOCAL procedure Leer (pLinea: Integer)
    begin
      LinPro := '';
      LinUO  := '';
      LinRe  := '';
      LinTip := '';
      LinFec := 0D;
      LinCnt := 0;

      tempExcelBuf.RESET;
      tempExcelBuf.SETRANGE("Row No.", pLinea);

      tempExcelBuf.SETRANGE(xlColID,opcCol[1]);
      if tempExcelBuf.FINDFIRST then
        LinPro:= tempExcelBuf."Cell Value as Text";

      tempExcelBuf.SETRANGE(xlColID,opcCol[2]);
      if tempExcelBuf.FINDFIRST then
        LinUO:= tempExcelBuf."Cell Value as Text";

      tempExcelBuf.SETRANGE(xlColID,opcCol[3]);
      if tempExcelBuf.FINDFIRST then
        LinRe := tempExcelBuf."Cell Value as Text";

      tempExcelBuf.SETRANGE(xlColID,opcCol[4]);
      if tempExcelBuf.FINDFIRST then
        LinTip :=  tempExcelBuf."Cell Value as Text";

      tempExcelBuf.SETRANGE(xlColID,opcCol[5]);
      if tempExcelBuf.FINDFIRST then
        LinFec := FncConvertDate(tempExcelBuf."Cell Value as Text");

      tempExcelBuf.SETRANGE(xlColID,opcCol[6]);
      if tempExcelBuf.FINDFIRST then
        LinCnt := FncConverDec(tempExcelBuf."Cell Value as Text");

      if (LinCnt <> 0) then
        CrearLineasDoc(LinPro, LinUO, LinRe, LinTip, LinFec, LinCnt);
    end;

    LOCAL procedure OpenFile ()
    var
//       FileMgt@1100286000 :
      FileMgt: Codeunit 419;
    begin
      if ServerFileName = '' then
        ServerFileName := FileMgt.UploadFile(Txt002,ExcelFileExtensionTok);
    end;

    
//     procedure SetFileName (NewFileName@1000 :
    procedure SetFileName (NewFileName: Text)
    begin
      ServerFileName := NewFileName;
    end;

//     procedure SetFilters (var pRecord@1100286002 :
    procedure SetFilters (var pRecord: Record 7207290)
    begin

      WorksheetHeaderqb := pRecord;
    end;

//     LOCAL procedure CrearLineasDoc (pJob@1100286000 : Text;pPiecework@1100286011 : Text;pResource@1100286001 : Text;pWorkType@1100286002 : Text;pDate@1100286003 : Date;pQty@1100286010 :
    LOCAL procedure CrearLineasDoc (pJob: Text;pPiecework: Text;pResource: Text;pWorkType: Text;pDate: Date;pQty: Decimal)
    var
//       QText003@1100286006 :
      QText003: TextConst ENU='The resource for VAT Identification No. %1 does not exist.',ESP='El recurso para el NIF %1 no existe.';
//       QText004@1100286008 :
      QText004: TextConst ENU='The Job for AS400 Code %1 does not exist.',ESP='El proyecto para el Codigo AS400 %1 no existe.';
//       QText005@1100286009 :
      QText005: TextConst ENU='There are not allocation records for job %1, activity code %2 and budget %3.',ESP='No existen registros de asignacion para proyecto %1, codigo de actividad %2 y presupuesto %3.';
//       DataPieceworkForProd@1100286004 :
      DataPieceworkForProd: Record 7207386;
    begin
      DataPieceworkForProd.RESET;
      DataPieceworkForProd.SETRANGE("Job No.",pJob);
      CASE opcUO OF
        opcUO::Presto   : DataPieceworkForProd.SETRANGE("Code Piecework PRESTO",pPiecework);
        opcUO::Proyecto : DataPieceworkForProd.SETRANGE("Piecework Code",pPiecework);
      end;
      if DataPieceworkForProd.FINDFIRST then
        pPiecework := DataPieceworkForProd."Piecework Code";

      LinDoc += 10000;

      WorkSheetLinesqb.INIT;
      WorkSheetLinesqb."Document No."  := WorksheetHeaderqb."No.";
      WorkSheetLinesqb."Line No."  := LinDoc;
      WorkSheetLinesqb.INSERT(TRUE);
      WorkSheetLinesqb.VALIDATE("Job No.", pJob);
      WorkSheetLinesqb.VALIDATE("Piecework No.", pPiecework);
      WorkSheetLinesqb.VALIDATE("Resource No.", pResource);
      WorkSheetLinesqb.VALIDATE("Work Type Code", pWorkType);
      WorkSheetLinesqb.VALIDATE("Work Day Date", pDate);
      WorkSheetLinesqb.VALIDATE(Quantity, pQty);
      WorkSheetLinesqb.MODIFY(TRUE);
    end;

    LOCAL procedure CheckIfLinesAlready ()
    var
//       GenJnlLine@1100286002 :
      GenJnlLine: Record 81;
//       QText001@1100286003 :
      QText001: TextConst ENU='There are already lines for general journal template %1 and Batch %2, do you want to continue and delete them all?',ESP='Ya existen l¡neas para el diario general con plantilla %1 y secci¢n %2, desea continuar y borrarlas todas?';
//       QText002@1100286004 :
      QText002: TextConst ENU='Process ended by user.',ESP='Proceso terminado por el usuario.';
    begin
    end;

//     LOCAL procedure FncConvertDate (pTxt@1100286000 :
    LOCAL procedure FncConvertDate (pTxt: Text) : Date;
    var
//       Fecha@1100286002 :
      Fecha: Date;
//       dia@1100286001 :
      dia: Integer;
//       mes@1100286003 :
      mes: Integer;
//       a¤o@1100286004 :
      axo: Integer;
    begin
      if not EVALUATE(dia, COPYSTR(pTxt,1,2)) then
        exit(0D);
      if not EVALUATE(mes, COPYSTR(pTxt,4,2)) then
        exit(0D);
      if not EVALUATE(axo, COPYSTR(pTxt, 7)) then
        exit(0D);
      if (axo < 100) then axo += 2000;
      Fecha := DMY2DATE(dia, mes, axo);
      exit(Fecha);
    end;

//     LOCAL procedure FncConverDec (var pTxt@1100286000 :
    LOCAL procedure FncConverDec (var pTxt: Text) : Decimal;
    var
//       amount@1100286001 :
      amount: Decimal;
    begin
      if not EVALUATE(amount ,pTxt) then
        exit(0);
      exit(amount);
    end;

    /*begin
    end.
  */
  
}




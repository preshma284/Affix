// report 50082 "KALAM Exp. Jobs info. to Excel"
// {


//     CaptionML=ENU='Exp. Jobs info. to Excel',ESP='Exportar info proyectos a excel';
//     ProcessingOnly=true;
//     UseRequestPage=true;

//   dataset
// {

// DataItem("Job";"Job")
// {

//                DataItemTableView=SORTING("No.");

//                                ;
// trigger OnPreDataItem();
//     BEGIN 

//                                TotalRecNo := Job.COUNT;
//                                RecNo := 0;

//                                TempExcelBuffer.DELETEALL;
//                                CLEAR(TempExcelBuffer);

//                                GLSetup.GET;

//                                // ENCABEZADOS
//                                RowNo := 1;
//                                ColumnNo := 1;
//                                EnterCell(RowNo,ColumnNo,Txt001,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt002,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt003,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt004,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt005,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt006,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt007,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt008,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt009,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt010,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt011,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt012,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt013,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt014,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                {
//                                //Q16946.B CSM 18/05/22 Í cambios. -
//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt015,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                //Q16946.B CSM 18/05/22 Í cambios. +


//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt016,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                //Q16946.B CSM 18/05/22 Í cambios. -
//                                ColumnNo += 1;
//                                EnterCell(RowNo,ColumnNo,Txt017,TRUE,FALSE,TRUE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                //Q16946.B CSM 18/05/22 Í cambios. +

//                                Window.OPEN(
//                                  Text000 +
//                                  '@1@@@@@@@@@@@@@@@@@@@@@\');

//                                Window.UPDATE(1,0);
//                              END;

// trigger OnAfterGetRecord();
//     VAR
// //                                   EstPresupuesto@1100286000 :
//                                   EstPresupuesto: Decimal;
//                                 begin 
//                                   {
//                                   IF Job.Status = Job.Status::Completed THEN
//                                     CurrReport.SKIP;
//                                   IF Job.Archived THEN
//                                     CurrReport.SKIP;


//                                   IF Job."Card Type" <> Job."Card Type"::"Proyecto operativo" THEN
//                                     CurrReport.SKIP;
//                                   IF Job."Job Type" <> Job."Job Type"::Operative THEN
//                                     CurrReport.SKIP;

//                                   RecNo := RecNo + 1;
//                                   Window.UPDATE(1,ROUND(RecNo / TotalRecNo * 10000,1));


//                                   // DATOS
//                                   Job.SETFILTER("Posting Date Filter", '..%1', ToDate);
//                                   Job.CALCFIELDS(Job."Production Budget Amount LCY", Job."Certification Amount", Job."Invoiced Price (LCY)",Job."Direct Cost Amount PW LCY");
//                                   Job.CALCFIELDS(Job."Actual Production Amount", Job."Invoiced (LCY)", Job."Usage (Cost) (LCY)");

//                                   RowNo += 1;
//                                   ColumnNo := 1;    //1-C¢digo obra (tabla 167 Job)
//                                   EnterCell(RowNo,ColumnNo,Job."No.",FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //2-Descripci¢n obra (tabla 167 Job)
//                                   EnterCell(RowNo,ColumnNo,Job.Description,FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //3-Nombre JEFE DE OBRA (tabla 167 Job)
//                                   //EnterCell(RowNo,ColumnNo,Job."Construction Manager",FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   CLEAR(JobResponsible);
//                                   JobResponsible.RESET;
//                                   JobResponsible.SETRANGE(Type, JobResponsible.Type::Job);
//                                   JobResponsible.SETRANGE("Table Code", Job."No.");
//                                   JobResponsible.SETRANGE(Position, 'JO');
//                                   IF JobResponsible.FINDFIRST THEN
//                                     JobResponsible.CALCFIELDS(Name);
//                                   EnterCell(RowNo,ColumnNo,JobResponsible.Name,FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //04-Estado interno (tabla 167 Job)
//                                   EnterCell(RowNo,ColumnNo,Job."Internal Status",FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //05-Fecha inicio (tabla 167 Job)
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Starting Date"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //06-Fecha fin (tabla 167 Job)
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Ending Date"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //07-Importe adjudicado (tabla 167 Job)
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Assigned Amount"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //08-Importe venta ESTIMADO PPTO (tabla 167 Job)
//                                   //Q16946.B CSM 18/05/22 Í cambios. -
//                                   {
//                                   //Q16946.B CSM 18/05/22 Í cambios. +
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Production Budget Amount LCY"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   //Q16946.B CSM 18/05/22 Í cambios. -


//                                   EstPresupuesto := 0;
//                                   t7207393.RESET;
//                                   t7207393.SETRANGE("Job No.", Job."No.");
//                                   IF t7207393.FINDFIRST THEN REPEAT
//                                     EstPresupuesto := EstPresupuesto + t7207393."Estimated Amount";
//                                   UNTIL t7207393.NEXT=0;

//                                   EnterCell(RowNo,ColumnNo,FORMAT(EstPresupuesto),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   //Q16946.B CSM 18/05/22 Í cambios. +


//                                   ColumnNo += 1;    //09-Importe venta FACTURADO A ORIGEN (tabla 167 Job)
//                                   //EnterCell(RowNo,ColumnNo,FORMAT(Job."Certification Amount"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Invoiced (LCY)"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   ColumnNo += 1;    //10-PRODUCCION Importe ejecuci¢n origen (tabla 167 Job)
//                                   //EnterCell(RowNo,ColumnNo,FORMAT(Job."Invoiced Price (LCY)"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Actual Production Amount"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);


//                                   ColumnNo += 1;    //11-COSTE DIRECTO Importe a origen (tabla 167 Job)
//                                   //Q16946.B CSM 18/05/22 Í cambios. -
//                                   {
//                                   //Q16946.B CSM 18/05/22 Í cambios. +
//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Direct Cost Amount PW LCY"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   //Q16946.B CSM 18/05/22 Í cambios. -


//                                   EnterCell(RowNo,ColumnNo,FORMAT(Job."Usage (Cost) (LCY)"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   //Q16946.B CSM 18/05/22 Í cambios. +


//                                   CLEAR(DataPiecForProd);
//                                   DataPiecForProd.SETRANGE(DataPiecForProd."Job No.", Job."No.");
//                                   //DataPiecForProd.CALCFIELDS(DataPiecForProd."Registered Hours");  //Q16946.B CSM 18/05/22 Í cambios. -+
//                                   IF DataPiecForProd.FINDFIRST THEN BEGIN 
//                                     DataPiecForProd.CALCSUMS(DataPiecForProd."Expected Hours");
//                                     DataPiecForProd.CALCFIELDS(DataPiecForProd."Registered Hours");  //Q16946.B CSM 18/05/22 Í cambios. -+
//                                   END ELSE
//                                     CLEAR(DataPiecForProd);

//                                   ColumnNo += 1;    //12-Horas previstas ESTUDIO (tabla 7207386 Data Piecework For Production)
//                                   EnterCell(RowNo,ColumnNo,FORMAT(DataPiecForProd."Expected Hours"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   AcumRegisterHours := 0;
//                                   CLEAR(WorksheetLinHist_dos);
//                                   WorksheetLinHist_dos.SETCURRENTKEY("Resource No.","Work Day Date");
//                                   WorksheetLinHist_dos.SETFILTER(WorksheetLinHist_dos."Work Day Date", '..%1', ToDate);
//                                   WorksheetLinHist_dos.SETRANGE("Job No.", Job."No.");
//                                   IF WorksheetLinHist_dos.FINDFIRST THEN REPEAT
//                                     AcumRegisterHours := AcumRegisterHours + WorksheetLinHist_dos.Quantity
//                                   UNTIL WorksheetLinHist_dos.NEXT=0;

//                                   ColumnNo += 1;    //13-Horas reales ORIGEN (tabla 7207386 Data Piecework For Production)
//                                   //EnterCell(RowNo,ColumnNo,FORMAT(DataPiecForProd."Registered Hours"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   EnterCell(RowNo,ColumnNo,FORMAT(AcumRegisterHours),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);

//                                   CLEAR(WorksheetLinHist);
//                                   WorksheetLinHist.SETCURRENTKEY("Resource No.","Work Day Date");
//                                   WorksheetLinHist.SETFILTER(WorksheetLinHist."Work Day Date", '..%1', ToDate);
//                                   WorksheetLinHist.SETRANGE(WorksheetLinHist."Job No.", Job."No.");
//                                   IF WorksheetLinHist.FINDFIRST THEN
//                                     WorksheetLinHist.CALCSUMS(WorksheetLinHist."Total Cost")
//                                   ELSE
//                                     CLEAR(WorksheetLinHist);

//                                   ColumnNo += 1;    //14-Importe coste jornales ORIGEN (tabla 7207386 Data Piecework For Production)
//                                   EnterCell(RowNo,ColumnNo,FORMAT(WorksheetLinHist."Total Cost"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);


//                                   {
//                                   //Q16946.B CSM 18/05/22 Í cambios. -
//                                   //mismo valor que "Horas reales ORIGEN" pero con las fechas del requestpage.
//                                   CLEAR(WorksheetLinHist);
//                                   WorksheetLinHist.SETCURRENTKEY("Resource No.","Work Day Date");
//                                   WorksheetLinHist.SETRANGE("Work Day Date", FromDate, ToDate);
//                                   WorksheetLinHist.SETRANGE(WorksheetLinHist."Job No.", Job."No.");
//                                   IF WorksheetLinHist.FINDFIRST THEN
//                                     WorksheetLinHist.CALCSUMS(WorksheetLinHist.Quantity)
//                                   ELSE
//                                     CLEAR(WorksheetLinHist);

//                                   ColumnNo += 1;    //15-Horas reales PERIODO
//                                   EnterCell(RowNo,ColumnNo,FORMAT(WorksheetLinHist.Quantity),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   //Q16946.B CSM 18/05/22 Í cambios. +



//                                   //mismo valor que "Horas reales ORIGEN" pero con las fechas del requestpage.
//                                   CLEAR(WorksheetLinHist);
//                                   WorksheetLinHist.SETCURRENTKEY("Resource No.","Work Day Date");
//                                   WorksheetLinHist.SETRANGE("Work Day Date", FromDate, ToDate);
//                                   WorksheetLinHist.SETRANGE(WorksheetLinHist."Job No.", Job."No.");
//                                   IF WorksheetLinHist.FINDFIRST THEN
//                                     WorksheetLinHist.CALCSUMS(WorksheetLinHist.Quantity)
//                                   ELSE
//                                     CLEAR(WorksheetLinHist);

//                                   ColumnNo += 1;    //16-Jornales reales periodo (tabla 7207386 Data Piecework For Production)
//                                   EnterCell(RowNo,ColumnNo,FORMAT(WorksheetLinHist.Quantity),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);


//                                   //Q16946.B CSM 18/05/22 Í cambios. -
//                                   //mismo valor que "Importe coste jornales ORIGEN" pero con las fechas del requestpage.
//                                   CLEAR(WorksheetLinHist);
//                                   WorksheetLinHist.SETCURRENTKEY("Resource No.","Work Day Date");
//                                   WorksheetLinHist.SETRANGE("Work Day Date", FromDate, ToDate);
//                                   WorksheetLinHist.SETRANGE(WorksheetLinHist."Job No.", Job."No.");
//                                   IF WorksheetLinHist.FINDFIRST THEN
//                                     WorksheetLinHist.CALCSUMS(WorksheetLinHist."Total Cost")
//                                   ELSE
//                                     CLEAR(WorksheetLinHist);

//                                   ColumnNo += 1;    //17-Importe coste jornales PERIODO
//                                   EnterCell(RowNo,ColumnNo,FORMAT(WorksheetLinHist."Total Cost"),FALSE,FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
//                                   //Q16946.B CSM 18/05/22 Í cambios. +
//                                 END;

// trigger OnPostDataItem();
//     BEGIN 

//                                 Window.CLOSE;

//                                 //ServerFileName := 'F:\CSM\KALAM\PR001.xlsx';
//                                 SheetName := 'Jobs';

//                                 TempExcelBuffer.CreateBook(ServerFileName,SheetName);
//                                 TempExcelBuffer.WriteSheet(SheetName,COMPANYNAME,USERID);
//                                 TempExcelBuffer.CloseBook;
//                                 IF NOT TestMode THEN
//                                   TempExcelBuffer.OpenExcel;
//                               END;


// }
// }
//   requestpage
//   {
// CaptionML=ENU='Exp. Jobs info. to Excel',ESP='Exportar info proyectos a excel';

//     layout
// {
// area(content)
// {
// group("group216")
// {

//                   CaptionML=ENU='Options',ESP='Opciones';
//     field("FromDate";"FromDate")
//     {

//                   CaptionML=ENU='From Date',ESP='Desde fecha';
//     }
//     field("ToDate";"ToDate")
//     {

//                   CaptionML=ENU='To Date',ESP='Hasta fecha';
//     }

// }

// }
// }trigger OnOpenPage()    BEGIN
//                    FromDate := DMY2DATE(1, DATE2DMY(TODAY, 2), DATE2DMY(TODAY, 3));
//                    ToDate := CALCDATE('PM',  FromDate);
//                  END;


//   }
//   labels
// {
// }

//     var
// //       Text000@1000 :
//       Text000: TextConst ENU='Analyzing Data...\\',ESP='Analizar Datos...\\';
// //       Text002@1002 :
//       Text002: TextConst ENU='Update Workbook',ESP='Actualizar libro';
// //       TempExcelBuffer@1006 :
//       TempExcelBuffer: Record 370 TEMPORARY;
// //       GLSetup@1013 :
//       GLSetup: Record 98;
// //       Currency@1015 :
//       Currency: Record 4;
// //       FileMgt@1017 :
//       FileMgt: Codeunit 419;
// //       ColumnValue@1009 :
//       ColumnValue: Decimal;
// //       ServerFileName@1016 :
//       ServerFileName: Text;
// //       SheetName@1011 :
//       SheetName: Text[250];
// //       ExcelFileExtensionTok@1012 :
//       ExcelFileExtensionTok: 
// // {Locked}
// TextConst ENU='.xlsx',ESP='.xlsx';
// //       TestMode@1019 :
//       TestMode: Boolean;
// //       Window@1100286005 :
//       Window: Dialog;
// //       RecNo@1100286004 :
//       RecNo: Integer;
// //       TotalRecNo@1100286003 :
//       TotalRecNo: Integer;
// //       RowNo@1100286002 :
//       RowNo: Integer;
// //       ColumnNo@1100286001 :
//       ColumnNo: Integer;
// //       ClientFileName@1100286000 :
//       ClientFileName: Text;
// //       Txt001@1100286006 :
//       Txt001: TextConst ENU='Job Code',ESP='C¢digo obra';
// //       Txt002@1100286008 :
//       Txt002: TextConst ENU='Job Description',ESP='Descripci¢n obra';
// //       Txt003@1100286007 :
//       Txt003: TextConst ENU='Job Chief',ESP='Jefe de obra';
// //       Txt004@1100286009 :
//       Txt004: TextConst ENU='State',ESP='Estado';
// //       Txt005@1100286010 :
//       Txt005: TextConst ENU='Start Date',ESP='Fecha inicio';
// //       Txt006@1100286011 :
//       Txt006: TextConst ENU='end Date',ESP='Fecha fin';
// //       Txt007@1100286012 :
//       Txt007: TextConst ENU='Importe adjudicado',ESP='Importe adjudicado';
// //       Txt008@1100286013 :
//       Txt008: TextConst ENU='Imp. vta. estimado Ppto',ESP='Imp. vta. estimado Ppto';
// //       Txt009@1100286014 :
//       Txt009: TextConst ENU='Imp. vta. Facturado a Origen',ESP='Imp. vta. Facturado a Origen';
// //       Txt010@1100286015 :
//       Txt010: TextConst ENU='PRODUCCION Imp. ejecuci¢n origen',ESP='PRODUCCION Imp. ejecuci¢n origen';
// //       Txt011@1100286016 :
//       Txt011: TextConst ENU='COSTE DIRECTO Imp. a origen',ESP='COSTE DIRECTO Imp. a origen';
// //       Txt012@1100286017 :
//       Txt012: TextConst ENU='Horas previstas ESTUDIO',ESP='Horas previstas ESTUDIO';
// //       Txt013@1100286018 :
//       Txt013: TextConst ENU='Horas reales ORIGEN',ESP='Horas reales ORIGEN';
// //       Txt014@1100286019 :
//       Txt014: TextConst ENU='Importe coste jornales ORIGEN',ESP='Importe coste jornales ORIGEN';
// //       Txt016@1100286020 :
//       Txt016: TextConst ENU='Horas/Jornales reales periodo',ESP='Horas/Jornales reales periodo';
// //       DataPiecForProd@1100286021 :
//       DataPiecForProd: Record 7207386;
// //       WorksheetLinHist@1100286022 :
//       WorksheetLinHist: Record 7207293;
// //       JobResponsible@1100286023 :
//       JobResponsible: Record 7206992;
// //       FromDate@1100286024 :
//       FromDate: Date;
// //       ToDate@1100286025 :
//       ToDate: Date;
// //       t7207393@1100286026 :
//       t7207393: Record 7207393;
// //       Txt015@1100286027 :
//       Txt015: TextConst ENU='Horas reales periodo',ESP='Horas reales periodo';
// //       Txt017@1100286028 :
//       Txt017: TextConst ENU='Importe coste jornales periodo',ESP='Importe coste jornales periodo';
// //       WorksheetLinHist_dos@1100286029 :
//       WorksheetLinHist_dos: Record 7207293;
// //       AcumRegisterHours@1100286030 :
//       AcumRegisterHours: Decimal;

// //     LOCAL procedure EnterCell (RowNo@1000 : Integer;ColumnNo@1001 : Integer;CellValue@1002 : Text[250];Bold@1003 : Boolean;Italic@1004 : Boolean;UnderLine@1005 : Boolean;DoubleUnderLine@1008 : Boolean;Format@1006 : Text[30];CellType@1007 :
//     LOCAL procedure EnterCell (RowNo: Integer;ColumnNo: Integer;CellValue: Text[250];Bold: Boolean;Italic: Boolean;UnderLine: Boolean;DoubleUnderLine: Boolean;Format: Text[30];CellType: Option)
//     begin
//       TempExcelBuffer.INIT;
//       TempExcelBuffer.VALIDATE("Row No.",RowNo);
//       TempExcelBuffer.VALIDATE("Column No.",ColumnNo);
//       TempExcelBuffer."Cell Value as Text" := CellValue;
//       TempExcelBuffer.Formula := '';
//       TempExcelBuffer.Bold := Bold;
//       TempExcelBuffer.Italic := Italic;
//       if DoubleUnderLine = TRUE then begin
//         TempExcelBuffer."Double Underline" := TRUE;
//         TempExcelBuffer.Underline := FALSE;
//       end else begin
//         TempExcelBuffer."Double Underline" := FALSE;
//         TempExcelBuffer.Underline := UnderLine;
//       end;
//       TempExcelBuffer.NumberFormat := Format;
//       TempExcelBuffer."Cell Type" := CellType;
//       TempExcelBuffer.INSERT;
//     end;


// //     procedure SetFileNameSilent (NewFileName@1000 :
//     procedure SetFileNameSilent (NewFileName: Text)
//     begin
//       ServerFileName := NewFileName;
//     end;


// //     procedure SetTestMode (NewTestMode@1000 :
//     procedure SetTestMode (NewTestMode: Boolean)
//     begin
//       TestMode := NewTestMode;
//     end;

// //     LOCAL procedure UploadClientFile (var ClientFileName@1000 : Text;var ServerFileName@1001 :
//     LOCAL procedure UploadClientFile (var ClientFileName: Text;var ServerFileName: Text) : Boolean;
//     var
// //       FileName@1002 :
//       FileName: Text;
//     begin
//       FileName := FileMgt.OpenFileDialog(Text002,ExcelFileExtensionTok,'');
//       if FileMgt.IsWebClient then
//         ServerFileName := FileName
//       else
//         ServerFileName := FileMgt.UploadFileSilent(FileName);
//       if ServerFileName = '' then
//         exit(FALSE);
//       ClientFileName := FileMgt.GetFileName(FileName);

//       SheetName := TempExcelBuffer.SelectSheetsName(ServerFileName);
//       if SheetName = '' then
//         exit(FALSE);

//       exit(TRUE);
//     end;

//     /*begin
//     //{
// //      Q16946 CSM 18/04/2022 Í Nuevo informe
// //      Q16946.B CSM 18/05/22 Í cambios.
// //    }
//     end.
//   */

// }





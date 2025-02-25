// report 7207383 "Import Budget To MSP"
// {


//     CaptionML = ENU = 'Import Budget To MSP', ESP = 'Importar presupuesto a MSP';
//     ProcessingOnly = true;

//     dataset
//     {

//         DataItem("Job"; "Job")
//         {



//             RequestFilterFields = "No.";
//             DataItem("Integer"; 2000000026)
//             {

//                 DataItemTableView = SORTING("Number");

//                 ; trigger OnPreDataItem();
//                 BEGIN
//                     Integer.SETFILTER(Number, '%1..%2', 1, Counter);
//                 END;

//                 trigger OnAfterGetRecord();
//                 BEGIN

//                     //MESSAGE(FORMAT(prjApp.FieldNameToFieldConstant('EDT')));
//                     //MESSAGE(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant('EDT')));
//                     //MESSAGE(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).Name);
//                     //MESSAGE(FORMAT(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant(TxtFechaInicio))));
//                     //Verify Automation and EVENT
//                     // TextStartDate := COPYSTR(
//                     //                FORMAT(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant(TxtFechaInicio))),
//                     //                STRLEN(FORMAT(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant(TxtFechaInicio)))) - 7,
//                     //                8);
//                     // TextEndDate := COPYSTR(
//                     //                FORMAT(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant(TxtFechaFin))),
//                     //                STRLEN(FORMAT(prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant(TxtFechaFin)))) - 7,
//                     //                8);
//                     //END of verify
//                     EVALUATE(Day, COPYSTR(TextStartDate, 1, 2));
//                     EVALUATE(month, COPYSTR(TextStartDate, 4, 2));
//                     EVALUATE(year, '20' + COPYSTR(TextStartDate, 7, 2));

//                     StartDate := DMY2DATE(Day, month, year);

//                     EVALUATE(Day, COPYSTR(TextEndDate, 1, 2));
//                     EVALUATE(month, COPYSTR(TextEndDate, 4, 2));
//                     EVALUATE(year, '20' + COPYSTR(TextEndDate, 7, 2));

//                     EndDate := DMY2DATE(Day, month, year);
//                     //StartDate:=TextStartDate;
//                     //EndDate:=TextEndDate;
//                     //MESSAGE(TextStartDate);
//                     //MESSAGE(TextEndDate);
//                     //Verify Automation and EVENT - one line
//                     //EDT := prjApp.ActiveProject.Tasks.UniqueID(Integer.Number).GetField(prjApp.FieldNameToFieldConstant('EDT'));
//                     DataPieceworkForProduction2.RESET;
//                     DataPieceworkForProduction2.SETRANGE("Job No.", Job."No.");
//                     DataPieceworkForProduction2.SETRANGE("Piecework Code", EDT);
//                     IF DataPieceworkForProduction2.FINDFIRST THEN
//                         IF DataPieceworkForProduction2."Account Type" = DataPieceworkForProduction2."Account Type"::Unit THEN BEGIN
//                             DataPieceworkForProduction2."Date init" := StartDate;
//                             DataPieceworkForProduction2."Date end" := EndDate;
//                             DataPieceworkForProduction2.MODIFY;
//                         END;



//                     Row += 1;
//                 END;


//             }
//             //verify Automation and EVENT - trigger
//             // trigger OnPreDataItem();
//             // BEGIN
//             //     Row := 0;
//             //     // Creaci¢n de fichero project
//             //     CLEAR(prjApp);

//             //     //{
//             //     //                               IF ISSERVICETIER THEN
//             //     //                                 CREATE(prjApp,TRUE,TRUE)
//             //     //                               ELSE
//             //     //                                 CREATE(prjApp);
//             //     //                               }
//             //     CREATE(prjApp, TRUE, TRUE);

//             //     IF FileName = '' THEN
//             //         ERROR(Text000)
//             //     ELSE BEGIN
//             //         prjApp.FileOpen(FileName, FALSE);
//             //         Row := 1;
//             //     END;
//             //     Counter := prjApp.ActiveProject.Tasks.Count;
//             //     //Counter:=5;
//             // END;


//         }
//     }
//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("group749")
//                 {

//                     CaptionML = ENU = 'Options';
//                     group("group750")
//                     {

//                         CaptionML = ESP = 'Planificar en';
//                         field("ScheduleIn"; "ScheduleIn")
//                         {

//                             OptionCaptionML = ENU = 'Days,Weeks,Months', ESP = 'D¡as,Semanas,Meses';
//                         }

//                     }
//                     field("MSPImportFile"; "FileName")
//                     {

//                         AssistEdit = true;
//                         CaptionML = ENU = 'MSP Import File', ESP = 'Fichero de importaci¢n MSP';

//                         ; trigger OnAssistEdit()
//                         VAR
//                             //                                  FileManagement@1100286001 :
//                             FileManagement: Codeunit 419;
//                             FileManagement1: Codeunit "File Management 1";
//                             //                                  ClientFileName@1100286000 :
//                             ClientFileName: Text;
//                         BEGIN
//                             FileName := '';
//                             //filename := CommonDialogMgt.OpenFile(Text50005,ToFile,4,'*.mpp|*.mpp|*.*|*.*',1);

//                             ClientFileName := FileManagement1.OpenFileDialog('ELEGIR FICHERO:', '', 'Fich. Microsoft Project (*.mpt)|*.mpp|Todos fich. (*.*)|*.*');
//                             FileName := FileManagement.GetDirectoryName(ClientFileName) + '\' + FileManagement.GetFileName(ClientFileName);
//                         END;


//                     }
//                     field("IncludeCostUnits"; "IncludeCostUnits")
//                     {

//                         CaptionML = ENU = 'Import Cost Units', ESP = 'Importar unidades de coste';
//                     }
//                     field("InitialProcessDate"; "InitialProcessDate")
//                     {

//                         CaptionML = ENU = 'Initial Process Date', ESP = 'Fecha planificaci¢n inicial';
//                     }
//                     field("FinishProcessDate"; "FinishProcessDate")
//                     {

//                         CaptionML = ENU = 'Finish Process Date', ESP = 'Fecha planificaci¢n final';
//                     }

//                 }

//             }
//         }
//     }
//     labels
//     {
//     }

//     var
//         //       FileName@1100286023 :
//         FileName: Text[1024];
//         //       ScheduleIn@1100286022 :
//         ScheduleIn: Option "D¡as","Semanas","Meses";
//         //       CurrentBudgetCode@1100286021 :
//         CurrentBudgetCode: Code[20];
//         //       IncludeCostUnits@1100286020 :
//         IncludeCostUnits: Boolean;
//         //       InitialProcessDate@1100286019 :
//         InitialProcessDate: Date;
//         //       FinishProcessDate@1100286018 :
//         FinishProcessDate: Date;
//         //       UploadedFileName@1100286017 :
//         UploadedFileName: Text[1024];
//         //       NameFile@1100286016 :
//         NameFile: Text[1024];
//         //       DateProcessInitial@1100286015 :
//         DateProcessInitial: Date;
//         //       DateProcessLast@1100286014 :
//         DateProcessLast: Date;
//         //       TMPExpectedTimeUnitData@1100286013 :
//         TMPExpectedTimeUnitData: Record 7207389;
//         //       Row@1100286012 :
//         Row: Integer;
//         //       NumberEntry@1100286011 :
//         NumberEntry: Integer;
//         //       ExpectedTimeUnitData@1100286010 :
//         ExpectedTimeUnitData: Record 7207388;
//         //       Window@1100286009 :
//         Window: Dialog;
//         //       Counter@1100286008 :
//         Counter: Integer;
//         //       PieceworkCode@1100286007 :
//         PieceworkCode: Code[20];
//         //       Found@1100286006 :
//         Found: Boolean;
//         //       DataPieceworkForProduction2@1100286005 :
//         DataPieceworkForProduction2: Record 7207386;
//         //       Plan@1100286004 :
//         Plan: Option "Day","Weeks","Months";
//         //       Type@1100286003 :
//         Type: Text[30];
//         //       DateLastDay@1100286002 :
//         DateLastDay: Date;
//         //       Value@1100286001 :
//         Value: Variant;
//         //       prjApp@1100286026 :
//         //Verify Automation and EVENT
//         //       prjApp: Automation "{A7107640-94DF-1068-855E-00DD01075445} 4.9:{36D27C48-A1E8-11D3-BA55-00C04F72F325}:Unknown Automation Server.Unknown Class";
//         // //       TSValue@1100286025 :
//         //       TSValue: Automation "{A7107640-94DF-1068-855E-00DD01075445} 4.9:{000C0C54-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";
//         // //       TSValues@1100286024 :
//         //       TSValues: Automation "{A7107640-94DF-1068-855E-00DD01075445} 4.9:{000C0C53-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";
//         //       Text000@1100286035 :
//         Text000: TextConst ENU = 'You must select a job.', ESP = 'Debe seleccionar un proyecto.';
//         //       Text001@1100286034 :
//         Text001: TextConst ENU = 'Only one job can be selected and only one.', ESP = 'S¢lo se puede seleccionar un proyecto y s¢lo uno.';
//         //       Text002@1100286033 :
//         Text002: TextConst ENU = 'You must enter an initial planning date', ESP = 'Debe introducir una fecha de planificaci¢n inicial';
//         //       Text003@1100286032 :
//         Text003: TextConst ENU = 'You must enter a final planning date', ESP = 'Debe introducir una fecha de planificaci¢n final';
//         //       Text004@1100286031 :
//         Text004: TextConst ENU = 'The final planning date must be later than the initial planning date', ESP = 'La fecha de planificaci¢n final debe ser posterior a la de planificaci¢n inicial';
//         //       Text005@1100286030 :
//         Text005: TextConst ENU = 'Planning Line              \\', ESP = 'L¡nea de planificaci¢n              \\';
//         //       Text006@1100286029 :
//         Text006: TextConst ENU = 'Piecework              : #1############## \\', ESP = 'Unidad de obra              : #1############## \\';
//         //       Text007@1100286028 :
//         Text007: TextConst ENU = 'Period Initiation Date : #2############## \\', ESP = 'Fecha de iniciaci¢n periodo : #2############## \\';
//         //       Text008@1100286027 :
//         Text008: TextConst ENU = 'Period Last Date       : #3##############', ESP = 'Fecha £ltimo perido       : #3##############';
//         //       Text009@1100286000 :
//         Text009: TextConst ENU = 'Use of tasks', ESP = 'Uso de tareas';
//         //       EDT@1100286036 :
//         EDT: Text;
//         //       TxtFechaInicio@1100286038 :
//         TxtFechaInicio: TextConst ESP = 'Comienzo';
//         //       TxtFechaFin@1100286037 :
//         TxtFechaFin: TextConst ESP = 'Fin';
//         //       TextStartDate@1100286039 :
//         TextStartDate: Text;
//         //       TextEndDate@1100286040 :
//         TextEndDate: Text;
//         //       StartDate@1100286041 :
//         StartDate: Date;
//         //       EndDate@1100286042 :
//         EndDate: Date;
//         //       Day@1100286043 :
//         Day: Integer;
//         //       month@1100286044 :
//         month: Integer;
//         //       year@1100286045 :
//         year: Integer;

//     //     procedure PassParameters (BudgetCodeP@1100000 :
//     procedure PassParameters(BudgetCodeP: Code[20])
//     begin
//         //CurrentBudgetCode := BudgetCodeP;
//     end;

//     procedure UploadFile()
//     begin
//         //{--- JAV Esto NO compila
//         //      UploadedFileName := SMTPTestMail.OpenFile(Text50005,'',4,'*.mpp|*.mpp|*.*|*.*',0);
//         //      NameFile := UploadedFileName;
//         //      ---}
//     end;

//     LOCAL procedure OnAfterValidateffleName()
//     begin
//         //UploadFile;
//     end;

//     //Verify Automation and EVENT

//     //     //     EVENT prjApp@1100286026::NewProject@1(pj@1100286000 :
//     //     EVENT prjApp@1100286026::NewProject@1(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeTaskDelete@6(tsk@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeTaskDelete@6(tsk: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeResourceDelete@7(res@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeResourceDelete@7(res: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeAssignmentDelete@8(asg@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeAssignmentDelete@8(asg: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeTaskChange@9(tsk@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Field@1100286002 : Integer;NewVal@1100286001 : Variant;var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeTaskChange@9(tsk: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeResourceChange@10(res@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Field@1100286002 : Integer;NewVal@1100286001 : Variant;var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeResourceChange@10(res: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeAssignmentChange@11(asg@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Field@1100286002 : Integer;NewVal@1100286001 : Variant;var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeAssignmentChange@11(asg: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeTaskNew@12(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeTaskNew@12(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeResourceNew@13(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeResourceNew@13(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeAssignmentNew@14(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeAssignmentNew@14(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeClose@2(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeClose@2(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforePrint@4(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforePrint@4(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeSave@3(pj@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";SaveAsUi@1100286001 : Boolean;var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeSave@3(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; SaveAsUi: Boolean; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectCalculate@5(pj@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectCalculate@5(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowGoalAreaChange@15(Window@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";goalArea@1100286000 :
//     //     EVENT prjApp@1100286026::WindowGoalAreaChange@15(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; goalArea: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowSelectionChange@16(Window@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";sel@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://{00020B18-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";selType@1100286000 :
//     //     EVENT prjApp@1100286026::WindowSelectionChange@16(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; sel: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://{00020B18-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; selType: Variant);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowBeforeViewChange@17(Window@1100286004 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";prevView@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class";newView@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class";projectHasViewWindow@1100286001 : Boolean;Info@1100286000 :
//     //     EVENT prjApp@1100286026::WindowBeforeViewChange@17(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; prevView: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class"; newView: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class"; projectHasViewWindow: Boolean; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowViewChange@18(Window@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";prevView@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class";newView@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class";success@1100286000 :
//     //     EVENT prjApp@1100286026::WindowViewChange@18(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; prevView: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class"; newView: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class"; success: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowActivate@19(activatedWindow@1100286000 :
//     //     EVENT prjApp@1100286026::WindowActivate@19(activatedWindow: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowDeactivate@20(deactivatedWindow@1100286000 :
//     //     EVENT prjApp@1100286026::WindowDeactivate@20(deactivatedWindow: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowSidepaneDisplayChange@21(Window@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Close@1100286000 :
//     //     EVENT prjApp@1100286026::WindowSidepaneDisplayChange@21(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Close: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WindowSidepaneTaskChange@22(Window@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";ID@1100286001 : Integer;IsGoalArea@1100286000 :
//     //     EVENT prjApp@1100286026::WindowSidepaneTaskChange@22(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; ID: Integer; IsGoalArea: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::WorkpaneDisplayChange@23(DisplayState@1100286000 :
//     //     EVENT prjApp@1100286026::WorkpaneDisplayChange@23(DisplayState: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::LoadWebPage@24(Window@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";var TargetPage@1100286000 :
//     //     EVENT prjApp@1100286026::LoadWebPage@24(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; var TargetPage: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026:
//     //     EVENT prjApp@1100286026::ProjectAfterSave@25();
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectTaskNew@26(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";ID@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectTaskNew@26(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; ID: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectResourceNew@27(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";ID@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectResourceNew@27(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; ID: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectAssignmentNew@28(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";ID@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectAssignmentNew@28(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; ID: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeSaveBaseline@29(pj@1100286008 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Interim@1100286007 : Boolean;bl@1100286006 : Integer;InterimCopy@1100286005 : Integer;InterimInto@1100286004 : Integer;AllTasks@1100286003 : Boolean;RollupToSummaryTasks@1100286002 : Boolean;RollupFromSubtasks@1100286001 : Boolean;Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeSaveBaseline@29(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Interim: Boolean; bl: Integer; InterimCopy: Integer; InterimInto: Integer; AllTasks: Boolean; RollupToSummaryTasks: Boolean; RollupFromSubtasks: Boolean; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeClearBaseline@30(pj@1100286005 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Interim@1100286004 : Boolean;bl@1100286003 : Integer;InterimFrom@1100286002 : Integer;AllTasks@1100286001 : Boolean;Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeClearBaseline@30(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Interim: Boolean; bl: Integer; InterimFrom: Integer; AllTasks: Boolean; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeClose2@1073741826(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeClose2@1073741826(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforePrint2@1073741828(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforePrint2@1073741828(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeSave2@1073741827(pj@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";SaveAsUi@1100286001 : Boolean;Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeSave2@1073741827(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; SaveAsUi: Boolean; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeTaskDelete2@1073741830(tsk@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeTaskDelete2@1073741830(tsk: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeResourceDelete2@1073741831(res@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeResourceDelete2@1073741831(res: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeAssignmentDelete2@1073741832(asg@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeAssignmentDelete2@1073741832(asg: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeTaskChange2@1073741833(tsk@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Field@1100286002 : Integer;NewVal@1100286001 : Variant;Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeTaskChange2@1073741833(tsk: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C3F-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeResourceChange2@1073741834(res@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Field@1100286002 : Integer;NewVal@1100286001 : Variant;Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeResourceChange2@1073741834(res: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C41-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeAssignmentChange2@1073741835(asg@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";Field@1100286002 : Integer;NewVal@1100286001 : Variant;Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeAssignmentChange2@1073741835(asg: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////{000C0C45-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeTaskNew2@1073741836(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeTaskNew2@1073741836(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeResourceNew2@1073741837(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeResourceNew2@1073741837(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforeAssignmentNew2@1073741838(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";Info@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforeAssignmentNew2@1073741838(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ApplicationBeforeClose@31(Info@1100286000 :
//     //     EVENT prjApp@1100286026::ApplicationBeforeClose@31(Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::OnUndoOrRedo@32(bstrLabel@1100286002 : Text;bstrGUID@1100286001 : Text;fUndo@1100286000 :
//     //     EVENT prjApp@1100286026::OnUndoOrRedo@32(bstrLabel: Text; bstrGUID: Text; fUndo: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::AfterCubeBuilt@33(var CubeFileName@1100286000 :
//     //     EVENT prjApp@1100286026::AfterCubeBuilt@33(var CubeFileName: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::LoadWebPane@34(Window@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";var TargetPage@1100286000 :
//     //     EVENT prjApp@1100286026::LoadWebPane@34(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; var TargetPage: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::JobStart@35(bstrName@1100286004 : Text;bstrprojGuid@1100286003 : Text;bstrjobGuid@1100286002 : Text;jobType@1100286001 : Integer;lResult@1100286000 :
//     //     EVENT prjApp@1100286026::JobStart@35(bstrName: Text; bstrprojGuid: Text; bstrjobGuid: Text; jobType: Integer; lResult: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::JobCompleted@36(bstrName@1100286004 : Text;bstrprojGuid@1100286003 : Text;bstrjobGuid@1100286002 : Text;jobType@1100286001 : Integer;lResult@1100286000 :
//     //     EVENT prjApp@1100286026::JobCompleted@36(bstrName: Text; bstrprojGuid: Text; bstrjobGuid: Text; jobType: Integer; lResult: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::SaveStartingToServer@37(bstrName@1100286001 : Text;bstrprojGuid@1100286000 :
//     //     EVENT prjApp@1100286026::SaveStartingToServer@37(bstrName: Text; bstrprojGuid: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::SaveCompletedToServer@38(bstrName@1100286001 : Text;bstrprojGuid@1100286000 :
//     //     EVENT prjApp@1100286026::SaveCompletedToServer@38(bstrName: Text; bstrprojGuid: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ProjectBeforePublish@39(pj@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class";var Cancel@1100286000 :
//     //     EVENT prjApp@1100286026::ProjectBeforePublish@39(pj: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////////////////////////////////{1019A320-508A-11CF-A49D-00AA00574C74}:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026:
//     //     EVENT prjApp@1100286026::PaneActivate@40();
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::SecondaryViewChange@41(Window@1100286003 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class";prevView@1100286002 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class";newView@1100286001 : Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class";success@1100286000 :
//     //     EVENT prjApp@1100286026::SecondaryViewChange@41(Window: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////{00020B02-0000-0000-C000-000000000046}:Unknown Automation Server.Unknown Class"; prevView: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class"; newView: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9:////////////{103EF3DC-9FCE-4611-8C8B-F306C8881CA5}:Unknown Automation Server.Unknown Class"; success: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::IsFunctionalitySupported@42(bstrFunctionality@1100286001 : Text;Info@1100286000 :
//     //     EVENT prjApp@1100286026::IsFunctionalitySupported@42(bstrFunctionality: Text; Info: Automation "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////{A7107640-94DF-1068-855E-00DD01075445} 4.9://////////////////////////////////{02497005-3861-4603-80A4-FF309631DBA1}:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@1100286026::ConnectionStatusChanged@43(online@1100286000 :
//     //     EVENT prjApp@1100286026::ConnectionStatusChanged@43(online: Boolean);
//     //     begin
//     //     end;

//     /*begin
//     end.
//   */

// }




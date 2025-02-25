// report 7207382 "Export Budget To MSP"
// {


//     CaptionML = ENU = 'Export Budget to MSP', ESP = 'Exportar presupuesto a MSP';
//     Description = 'Faltan Librerias MS Project en el Servidor';
//     ProcessingOnly = true;

//     dataset
//     {
//         DataItem("Data Piecework For Production"; "Data Piecework For Production")
//         {

//             DataItemTableView = SORTING("Job No.", "Piecework Code")
//                                  WHERE("Production Unit" = CONST(true));
//             RequestFilterFields = "Job No.", "Piecework Code";
//             trigger OnPreDataItem();
//             BEGIN



//                 IF FromDate = 0D THEN
//                     ERROR(Text002);

//                 IF ToDate = 0D THEN
//                     ERROR(Text003);

//                 IF ToDate < FromDate THEN
//                     ERROR(Text004);


//                 ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
//                 FirstLineCounter := 0;
//                 Row := 0;



//                 DialogWindow.OPEN('Exportando L¡nea              \\' +
//                              'Unidad de obra       : #1############## \\' +
//                              'Fecha inicio per¡odo : #2############## \\' +
//                              'Fecha fin per¡odo    : #3##############');


//                 SLEEP(1000);
//             END;

//             trigger OnAfterGetRecord();
//             VAR
//                 //                                   ExpectedFinishDate@7001100 :
//                 ExpectedFinishDate: Date;
//                 //                                   ExpectedStartDate@1100286000 :
//                 ExpectedStartDate: Date;
//             BEGIN
//                 IF rJob.GET("Data Piecework For Production"."Job No.") THEN
//                     IF BudgetCode = '' THEN
//                         BudgetCode := rJob."Current Piecework Budget";

//                 IF ("Data Piecework For Production".Type = "Data Piecework For Production".Type::Piecework) AND NOT
//                    ("Data Piecework For Production"."Production Unit") THEN
//                     CurrReport.SKIP;

//                 IF NOT booIncluirUC THEN
//                     IF "Data Piecework For Production".Type = "Data Piecework For Production".Type::"Cost Unit" THEN
//                         CurrReport.SKIP;
//                 "Data Piecework For Production".SETFILTER("Budget Filter", BudgetCode);
//                 "Data Piecework For Production".CALCFIELDS("Budget Measure", "Amount Cost Budget (LCY)", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (LCY)");

//                 ExpectedTimeUnitData.RESET;
//                 ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date");
//                 ExpectedTimeUnitData.SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
//                 ExpectedTimeUnitData.SETRANGE("Piecework Code", "Data Piecework For Production"."Piecework Code");
//                 ExpectedTimeUnitData.SETRANGE("Budget Code", BudgetCode);
//                 ExpectedTimeUnitData.SETRANGE(Performed, FALSE);

//                 IF ExpectedTimeUnitData.FINDFIRST THEN
//                     ExpectedStartDate := ExpectedTimeUnitData."Expected Date";
//                 IF ExpectedTimeUnitData.FINDLAST THEN
//                     ExpectedFinishDate := ExpectedTimeUnitData."Expected Date";

//                 rJob.GET("Data Piecework For Production"."Job No.");
//                 //verify Automation and EVENT
//                 //prjApp.Visible :=TRUE;

//                 // prjApp.SelectTaskField(FirstLineCounter, TxtNameHeader);
//                 // prjApp.SetTaskField(TxtEDT, "Data Piecework For Production"."Piecework Code");
//                 // //SLEEP(500);
//                 // prjApp.SetTaskField(TxtNameHeader, "Data Piecework For Production".Description);
//                 // //SLEEP(500);

//                 // //prjApp.SetTaskField(TxtNotes,"Data Piecework For Production".Description);
//                 // prjApp.SetTaskField(TxtText1, TxtUnit);




//                 IF "Data Piecework For Production"."Account Type" <> "Data Piecework For Production"."Account Type"::Heading THEN BEGIN
//                     // prjApp.SetTaskField(TxtFechaInicio, FORMAT(ExpectedStartDate));
//                     // prjApp.SetTaskField(TxtFechaFin, FORMAT(CALCDATE('+PM', ExpectedFinishDate)));
//                     //verify Automation and EVENT
//                     // prjApp.SetTaskField(TXTCostePrevisto, FORMAT("Data Piecework For Production"."Amount Cost Budget (LCY)"));
//                     // prjApp.SetTaskField(TXTCosteReal,FORMAT("Data Piecework For Production"."Amount Cost Performed (LCY)"));
//                 END;

//                 FirstLineCounter := 1;
//                 //VErify Automation and EVENT
//                 // IF Row <> 0 THEN
//                 //     IF intIndentacionanterior <> 0 THEN
//                 //         prjApp.OutlineOutdent(intIndentacionanterior);

//                 // IF "Data Piecework For Production".Indentation <> 0 THEN
//                 //     prjApp.OutlineIndent("Data Piecework For Production".Indentation);

//                 intIndentacionanterior := "Data Piecework For Production".Indentation;
//                 Row := Row + 1;


//                 DialogWindow.UPDATE(1, "Data Piecework For Production"."Piecework Code");

//                 booHaylineas := TRUE;
//             END;


//         }
//     }
//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("group80")
//                 {

//                     CaptionML = ENU = 'Options', ESP = 'Opciones';
//                     field("FileName"; "FileName")
//                     {

//                         AssistEdit = true;
//                         CaptionML = ESP = 'Fichero de exportaci¢n MSP';

//                         ; trigger OnAssistEdit()
//                         VAR
//                             //                                  CommonDialogMgt@1100251000 :
//                             //verify Automation and EVENT
//                             // CommonDialogMgt: Codeunit 412;
//                             //                                  FileManagement@7001101 :
//                             FileManagement: Codeunit 419;
//                             FileManagement1: Codeunit "File Management 1";
//                             //                                  ClientFileName@7001100 :
//                             ClientFileName: Text;
//                         BEGIN
//                             FileName := toFile;
//                             //filename := CommonDialogMgt.OpenFile(Text50005,ToFile,4,'*.mpp|*.mpp|*.*|*.*',1);

//                             ClientFileName := FileManagement1.OpenFileDialog(Text002, '', 'Fich. Microsoft Project (*.mpt)|*.mpt|Todos fich. (*.*)|*.*');
//                             FileName := FileManagement.GetDirectoryName(ClientFileName) + '\' + FileManagement.GetFileName(ClientFileName);
//                         END;


//                     }
//                     field("booIncluirUC"; "booIncluirUC")
//                     {

//                         CaptionML = ESP = 'Exportar Unidades de coste';
//                     }
//                     field("BudgetCode"; "BudgetCode")
//                     {

//                         CaptionML = ESP = 'Planificar en';
//                         //OptionCaptionML=ESP='Planificar en';
//                     }
//                     field("FromDate"; "FromDate")
//                     {

//                         CaptionML = ESP = 'Fecha planificaci¢n inicial';
//                     }
//                     field("ToDate"; "ToDate")
//                     {

//                         CaptionML = ESP = 'Fecha planificaci¢n final';
//                     }
//                     field("ScheduleIn"; "ScheduleIn")
//                     {

//                         CaptionML = ESP = 'ScheduleIn';
//                     }

//                 }

//             }
//         }
//     }
//     labels
//     {
//     }

//     var
//         //       ExpectedTimeUnitData@7001111 :
//         ExpectedTimeUnitData: Record 7207388;
//         //       prjApp@7001101 :
//         //verify Automation and EVENT
//         prjApp: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:36D27C48-A1E8-11D3-BA55-00C04F72F325:Unknown Automation Server.Unknown Class";
//         //       TSValue@7001118 :
//         TSValue: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C54-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";
//         //       TSValues@7001117 :
//         TSValues: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C53-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";
//              // DialogWindow@7001119 :
//         DialogWindow: Dialog;
//         //       ScheduleIn@7001112 :
//         ScheduleIn: Option "Days","Weeks","Months";
//         //       FileName@7001104 :
//         FileName: Text[1024];
//         //       BudgetCode@7001113 :
//         BudgetCode: Code[20];
//         //       FromDate@7001110 :
//         FromDate: Date;
//         //       ToDate@7001109 :
//         ToDate: Date;
//         //       Row@7001100 :
//         Row: Integer;
//         //       FirstLineCounter@7001102 :
//         FirstLineCounter: Integer;
//         //       TxtNameHeader@7001103 :
//         TxtNameHeader: TextConst ENU = 'Name', ESP = 'Nombre';
//         //       TxtNotes@7001114 :
//         TxtNotes: TextConst ENU = 'Notes', ESP = 'Notas';
//         //       TxtText1@7001115 :
//         TxtText1: TextConst ENU = 'Text1', ESP = 'Texto1';
//         //       TxtUnit@7001116 :
//         TxtUnit: TextConst ENU = 'Unit', ESP = 'Unidad';
//         //       Text002@7001106 :
//         Text002: TextConst ENU = 'You must enter an initial planning date', ESP = 'Debe introducir una fecha de planificaci¢n inicial';
//         //       Text003@7001107 :
//         Text003: TextConst ENU = 'You must enter a final planning date', ESP = 'Debe introducir una fecha de planificaci¢n final';
//         //       Text004@7001108 :
//         Text004: TextConst ENU = 'The final planning date must be later than the initial planning date', ESP = 'La fecha de planificaci¢n final debe ser posterior a la de planificaci¢n inicial';
//         //       Text006@7001105 :
//         Text006: TextConst ENU = 'The file has been successfully exported to %1.', ESP = 'El fichero ha sido exportado satisfactoriamente a %1.';
//         //       booIncluirUC@7001120 :
//         booIncluirUC: Boolean;
//         //       toFile@7001121 :
//         toFile: Text[1024];
//         //       rJob@7001122 :
//         rJob: Record 167;
//         //       intIndentacionanterior@7001123 :
//         intIndentacionanterior: Integer;
//         //       booHaylineas@7001124 :
//         booHaylineas: Boolean;
//         //       varvariable@7001125 :
//         varvariable: Decimal;
//         //       TxtEDT@7001126 :
//         TxtEDT: TextConst ESP = 'EDT';
//         //       PeriodFinishDate@1100286002 :
//         PeriodFinishDate: Date;
//         //       FinishDayDate@1100286001 :
//         FinishDayDate: Date;
//         //       PeriodStartDate@1100286000 :
//         PeriodStartDate: Date;
//         //       TxtFechaInicio@1100286003 :
//         TxtFechaInicio: TextConst ESP = 'Comienzo';
//         //       TxtFechaFin@1100286004 :
//         TxtFechaFin: TextConst ESP = 'Fin';
//         //       TXTCostePrevisto@1100286005 :
//         TXTCostePrevisto: TextConst ESP = 'Costo';
//         //       TXTCosteReal@1100286006 :
//         TXTCosteReal: TextConst ESP = '[Costo Real]';
//         //       DATE@1100286007 :
//         DATE: Record 2000000007;



//     trigger OnInitReport();
//     begin
//         FromDate := DMY2DATE(1, 1, 2021);
//         ToDate := DMY2DATE(31, 5, 2021);
//     end;
//     //verify Automation and EVENT

//     // trigger OnPreReport();
//     // var
//     //     //                   QuoBuildingSetup@7001100 :
//     //     QuoBuildingSetup: Record 7207278;
//     //     //                   Counter@7001101 :
//     //     Counter: Integer;
//     // begin

//     //     Row := 0;
//     //     // Creaci¢n de fichero project
//     //     CLEAR(prjApp);

//     //     //{
//     //     //                  if ISSERVICETIER then
//     //     //                    CREATE(prjApp,TRUE,TRUE)
//     //     //                  else
//     //     //                    CREATE(prjApp);
//     //     //                  }
//     //     CREATE(prjApp, TRUE, TRUE);


//     //     QuoBuildingSetup.GET;
//     //     QuoBuildingSetup.TESTFIELD("MSP Export Template");
//     //     //jmma prjApp.Application.FileNew(FALSE,QuoBuildingSetup."MSP Export Template",FALSE);

//     //     prjApp.Visible := TRUE;
//     //     //prjApp.Application.FileNew(FALSE,QuoBuildingSetup."MSP Export Template",FALSE);//JMMA ORIGINAL COMNTADO PARA PRUEBAS
//     //     prjApp.Application.FileNew;



//     //     prjApp.SelectTaskColumn(TxtNameHeader);
//     //     Counter := 1;
//     //     FirstLineCounter := 0;
//     // end;

//     //verify Automation and EVENt

//     // trigger OnPostReport();
//     // begin
//     //     prjApp.SelectTaskField(0, TxtNameHeader);
//     //     if FileName <> '' then
//     //         prjApp.Application.FileSaveAs(FileName, 0);//4 para excel
//     //     prjApp.Visible := TRUE;
//     //     CLEAR(prjApp);
//     //     MESSAGE(Text006, FileName);
//     // end;



//     // procedure PassParameters (BudgetCodeP@1100000 :
//     procedure PassParameters(BudgetCodeP: Code[20])
//     begin
//         BudgetCode := BudgetCodeP;
//     end;
//     //verify Automation and EVENT

//     // //     EVENT prjApp@7001101::NewProject@1(pj@7001100 :
//     // EVENT prjApp::NewProject(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class");
//     // begin
//     // end;





//     // //     EVENT prjApp@7001101::ProjectBeforeTaskDelete@6(tsk@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeTaskDelete@6(tsk: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeResourceDelete@7(res@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeResourceDelete@7(res: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeAssignmentDelete@8(asg@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeAssignmentDelete@8(asg: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeTaskChange@9(tsk@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Field@7001102 : Integer;NewVal@7001101 : Variant;var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeTaskChange@9(tsk: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeResourceChange@10(res@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Field@7001102 : Integer;NewVal@7001101 : Variant;var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeResourceChange@10(res: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeAssignmentChange@11(asg@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Field@7001102 : Integer;NewVal@7001101 : Variant;var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeAssignmentChange@11(asg: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeTaskNew@12(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeTaskNew@12(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeResourceNew@13(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeResourceNew@13(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeAssignmentNew@14(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeAssignmentNew@14(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeClose@2(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeClose@2(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforePrint@4(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforePrint@4(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeSave@3(pj@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";SaveAsUi@7001101 : Boolean;var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeSave@3(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; SaveAsUi: Boolean; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectCalculate@5(pj@7001100 :
//     //     EVENT prjApp@7001101::ProjectCalculate@5(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowGoalAreaChange@15(Window@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";goalArea@7001100 :
//     //     EVENT prjApp@7001101::WindowGoalAreaChange@15(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; goalArea: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowSelectionChange@16(Window@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";sel@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B18-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";selType@7001100 :
//     //     EVENT prjApp@7001101::WindowSelectionChange@16(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; sel: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B18-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; selType: Variant);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowBeforeViewChange@17(Window@7001104 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";prevView@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class";newView@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class";projectHasViewWindow@7001101 : Boolean;Info@7001100 :
//     //     EVENT prjApp@7001101::WindowBeforeViewChange@17(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; prevView: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class"; newView: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class"; projectHasViewWindow: Boolean; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowViewChange@18(Window@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";prevView@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class";newView@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class";success@7001100 :
//     //     EVENT prjApp@7001101::WindowViewChange@18(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; prevView: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class"; newView: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class"; success: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowActivate@19(activatedWindow@7001100 :
//     //     EVENT prjApp@7001101::WindowActivate@19(activatedWindow: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowDeactivate@20(deactivatedWindow@7001100 :
//     //     EVENT prjApp@7001101::WindowDeactivate@20(deactivatedWindow: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowSidepaneDisplayChange@21(Window@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Close@7001100 :
//     //     EVENT prjApp@7001101::WindowSidepaneDisplayChange@21(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Close: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WindowSidepaneTaskChange@22(Window@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";ID@7001101 : Integer;IsGoalArea@7001100 :
//     //     EVENT prjApp@7001101::WindowSidepaneTaskChange@22(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; ID: Integer; IsGoalArea: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::WorkpaneDisplayChange@23(DisplayState@7001100 :
//     //     EVENT prjApp@7001101::WorkpaneDisplayChange@23(DisplayState: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::LoadWebPage@24(Window@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";var TargetPage@7001100 :
//     //     EVENT prjApp@7001101::LoadWebPage@24(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; var TargetPage: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101:
//     //     EVENT prjApp@7001101::ProjectAfterSave@25();
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectTaskNew@26(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";ID@7001100 :
//     //     EVENT prjApp@7001101::ProjectTaskNew@26(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; ID: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectResourceNew@27(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";ID@7001100 :
//     //     EVENT prjApp@7001101::ProjectResourceNew@27(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; ID: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectAssignmentNew@28(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";ID@7001100 :
//     //     EVENT prjApp@7001101::ProjectAssignmentNew@28(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; ID: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeSaveBaseline@29(pj@7001108 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Interim@7001107 : Boolean;bl@7001106 : Integer;InterimCopy@7001105 : Integer;InterimInto@7001104 : Integer;AllTasks@7001103 : Boolean;RollupToSummaryTasks@7001102 : Boolean;RollupFromSubtasks@7001101 : Boolean;Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeSaveBaseline@29(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Interim: Boolean; bl: Integer; InterimCopy: Integer; InterimInto: Integer; AllTasks: Boolean; RollupToSummaryTasks: Boolean; RollupFromSubtasks: Boolean; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeClearBaseline@30(pj@7001105 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Interim@7001104 : Boolean;bl@7001103 : Integer;InterimFrom@7001102 : Integer;AllTasks@7001101 : Boolean;Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeClearBaseline@30(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Interim: Boolean; bl: Integer; InterimFrom: Integer; AllTasks: Boolean; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeClose2@1073741826(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeClose2@1073741826(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforePrint2@1073741828(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforePrint2@1073741828(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeSave2@1073741827(pj@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";SaveAsUi@7001101 : Boolean;Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeSave2@1073741827(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; SaveAsUi: Boolean; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeTaskDelete2@1073741830(tsk@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeTaskDelete2@1073741830(tsk: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeResourceDelete2@1073741831(res@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeResourceDelete2@1073741831(res: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeAssignmentDelete2@1073741832(asg@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeAssignmentDelete2@1073741832(asg: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeTaskChange2@1073741833(tsk@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Field@7001102 : Integer;NewVal@7001101 : Variant;Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeTaskChange2@1073741833(tsk: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C3F-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeResourceChange2@1073741834(res@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Field@7001102 : Integer;NewVal@7001101 : Variant;Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeResourceChange2@1073741834(res: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C41-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeAssignmentChange2@1073741835(asg@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";Field@7001102 : Integer;NewVal@7001101 : Variant;Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeAssignmentChange2@1073741835(asg: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:000C0C45-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; Field: Integer; NewVal: Variant; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeTaskNew2@1073741836(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeTaskNew2@1073741836(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeResourceNew2@1073741837(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeResourceNew2@1073741837(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforeAssignmentNew2@1073741838(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";Info@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforeAssignmentNew2@1073741838(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ApplicationBeforeClose@31(Info@7001100 :
//     //     EVENT prjApp@7001101::ApplicationBeforeClose@31(Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::OnUndoOrRedo@32(bstrLabel@7001102 : Text;bstrGUID@7001101 : Text;fUndo@7001100 :
//     //     EVENT prjApp@7001101::OnUndoOrRedo@32(bstrLabel: Text; bstrGUID: Text; fUndo: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::AfterCubeBuilt@33(var CubeFileName@7001100 :
//     //     EVENT prjApp@7001101::AfterCubeBuilt@33(var CubeFileName: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::LoadWebPane@34(Window@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";var TargetPage@7001100 :
//     //     EVENT prjApp@7001101::LoadWebPane@34(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; var TargetPage: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::JobStart@35(bstrName@7001104 : Text;bstrprojGuid@7001103 : Text;bstrjobGuid@7001102 : Text;jobType@7001101 : Integer;lResult@7001100 :
//     //     EVENT prjApp@7001101::JobStart@35(bstrName: Text; bstrprojGuid: Text; bstrjobGuid: Text; jobType: Integer; lResult: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::JobCompleted@36(bstrName@7001104 : Text;bstrprojGuid@7001103 : Text;bstrjobGuid@7001102 : Text;jobType@7001101 : Integer;lResult@7001100 :
//     //     EVENT prjApp@7001101::JobCompleted@36(bstrName: Text; bstrprojGuid: Text; bstrjobGuid: Text; jobType: Integer; lResult: Integer);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::SaveStartingToServer@37(bstrName@7001101 : Text;bstrprojGuid@7001100 :
//     //     EVENT prjApp@7001101::SaveStartingToServer@37(bstrName: Text; bstrprojGuid: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::SaveCompletedToServer@38(bstrName@7001101 : Text;bstrprojGuid@7001100 :
//     //     EVENT prjApp@7001101::SaveCompletedToServer@38(bstrName: Text; bstrprojGuid: Text);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ProjectBeforePublish@39(pj@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class";var Cancel@7001100 :
//     //     EVENT prjApp@7001101::ProjectBeforePublish@39(pj: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:1019A320-508A-11CF-A49D-00AA00574C74:Unknown Automation Server.Unknown Class"; var Cancel: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101:
//     //     EVENT prjApp@7001101::PaneActivate@40();
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::SecondaryViewChange@41(Window@7001103 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class";prevView@7001102 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class";newView@7001101 : Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class";success@7001100 :
//     //     EVENT prjApp@7001101::SecondaryViewChange@41(Window: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:00020B02-0000-0000-C000-000000000046:Unknown Automation Server.Unknown Class"; prevView: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class"; newView: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:103EF3DC-9FCE-4611-8C8B-F306C8881CA5:Unknown Automation Server.Unknown Class"; success: Boolean);
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::IsFunctionalitySupported@42(bstrFunctionality@7001101 : Text;Info@7001100 :
//     //     EVENT prjApp@7001101::IsFunctionalitySupported@42(bstrFunctionality: Text; Info: Automation "A7107640-94DF-1068-855E-00DD01075445 4.9:02497005-3861-4603-80A4-FF309631DBA1:Unknown Automation Server.Unknown Class");
//     //     begin
//     //     end;

//     // //     EVENT prjApp@7001101::ConnectionStatusChanged@43(online@7001100 :
//     //     EVENT prjApp::ConnectionStatusChanged(online: Boolean);
//     //     begin
//     //     end;

//     /*begin
//     //{
// //      Exporta tabla precios preciario a MSP. Escribe lo siguiente:
// //      Tarea: Unidad de obra.
// //      Nombres de los recursos: Descripci¢n
// //      Notas: Medici¢n=medici¢n
// //      En MSP la medici¢n es informativo, por eso se deja en el campo notas
// //      Se cambia el n£mero,antes era 7022916
// //    }
//     end.
//   */

// }




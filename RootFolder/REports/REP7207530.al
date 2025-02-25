//Report to be refactored - PRevious version Errors


// report 7207530 "QB Data Version Change"
// {


//     Permissions = TableData 25 = rm,
//                 TableData 120 = rm,
//                 TableData 121 = rm,
//                 TableData 122 = rm,
//                 TableData 123 = rm,
//                 TableData 6651 = rimd;
//     CaptionML = ENU = 'Data Version Change', ESP = 'Cambio de Versi¢n de Datos';
//     ProcessingOnly = true;

//     dataset
//     {

//         DataItem("Company"; "Company")
//         {

//             DataItemTableView = SORTING("Name");

//             ;
//             trigger OnPreDataItem();
//             VAR
//                 //                                n@1100286000 :
//                 n: Integer;
//                 //                                aux@1100286001 :
//                 aux: Text;
//             BEGIN
//                 //Busco la versi¢n actual de los datos
//                 QBGlobalConf.GetGlobalConf('');
//                 IF (QBGlobalConf."Data Version" <> '') THEN
//                     OldVersion := QBGlobalConf."Data Version"
//                 ELSE
//                     OldVersion := QBVersionChanges.GetDataVersion;

//                 //Si forzamos, cambio a la versi¢n anterior a la actual para que se ejecute el cambio
//                 IF (ForceVersion) THEN BEGIN
//                     EVALUATE(n, OldVersion);
//                     aux := '00000' + FORMAT(n - 1);
//                     OldVersion := COPYSTR(aux, STRLEN(aux) - 4);
//                 END;

//                 //Datos globales
//                 Changed := FALSE;                //No se ha ejecutado ning£n cambio
//                 FirstCompany := TRUE;            //Como estamos al inicio procesaremos la primera empresa
//                 ChangeByCompany := FALSE;        //El cambio por empresas no est  activado
//             END;

//             trigger OnAfterGetRecord();
//             BEGIN
//                 IF (NOT ChangeByCompany) THEN BEGIN

//                     //Funciones para los cambios de versi¢n
//                     C00001;
//                     C00002;
//                     C00003;
//                     C00004;
//                     C00005;
//                     C00006;
//                     C00007;
//                     C00008;
//                     C00009;
//                     C00010;  //Cambio global, se realiza una vez en lugar de por empresas
//                     C00011;
//                     C00161;  //El Cambio se realiza solo en la empresa actual, no se puede hacer en todas
//                     C00162;
//                     C00164;
//                     C00165;
//                     C00166;
//                     C00167;
//                     C00168;
//                     C00170;
//                     C00172;
//                     C00173;
//                     C00174;
//                     C00180;
//                     C00181;
//                     C00185;
//                     C00187;
//                     C00191;
//                     C00194;
//                     C00196;
//                     C00197;




//                     //Verificaciones tras el cambio en la empresa
//                     FirstCompany := FALSE;                 //Ya hemos procesado la primera empresa
//                     CheckCangedInAllCompany(NewVersion);   //Ver si ya se ha efectuado el cambio en todas las empresas
//                 END;
//             END;

//             trigger OnPostDataItem();
//             BEGIN
//                 //JAV 18/06/22: - QB 1.10.51 A¤adir permisos para nuevos objetos simempre
//                 AddPermissions;

//                 IF Presented THEN
//                     w.CLOSE;

//                 //Guardo la versi¢n actual de los datos si han cambiado
//                 IF (NOT ChangeByCompany) THEN BEGIN
//                     IF (Changed) THEN BEGIN
//                         QBGlobalConf.GetGlobalConf('');
//                         QBGlobalConf."Data Version" := NewVersion;
//                         QBGlobalConf.MODIFY;

//                         QBVersionChanges.SetDataVersion(NewVersion, OldVersion);
//                         IF (SeeMessages) THEN
//                             MESSAGE('Finalizado');
//                     END ELSE
//                         IF (SeeMessages) THEN
//                             MESSAGE('Nada que actualizar');
//                 END;
//             END;


//         }
//     }
//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group("group999")
//                 {

//                     CaptionML = ENU = 'Options', ESP = 'Opciones';
//                     field("ForceVersion"; "ForceVersion")
//                     {

//                         CaptionML = ESP = 'Forzar Cambio';
//                         Editable = isAdm

//     ;
//                     }

//                 }

//             }
//         }
//     }
//     labels
//     {
//     }

//     var
//         //       QuoBuildingSetup@1000000103 :
//         QuoBuildingSetup: Record 7207278;
//         //       QBVersionChanges@1100286002 :
//         QBVersionChanges: Record 7206921;
//         //       QBGlobalConf@1100286012 :
//         QBGlobalConf: Record 7206985;
//         //       Currency@1100286000 :
//         Currency: Record 4;
//         //       FunctionQB@1100286007 :
//         FunctionQB: Codeunit 7207272;
//         //       w@100000007 :
//         w: Dialog;
//         //       OldVersion@1100286009 :
//         OldVersion: Code[5];
//         //       RDV@1100286001 :
//         RDV: TextConst ESP = 'DV';
//         //       NewVersion@1100286003 :
//         NewVersion: Code[5];
//         //       ForceVersion@1100286005 :
//         ForceVersion: Boolean;
//         //       Changed@1100286004 :
//         Changed: Boolean;
//         //       isAdm@1100286006 :
//         isAdm: Boolean;
//         //       SeeMessages@1100286008 :
//         SeeMessages: Boolean;
//         //       Presented@1100286010 :
//         Presented: Boolean;
//         //       FirstCompany@1100286011 :
//         FirstCompany: Boolean;
//         //       ChangeByCompany@1100286014 :
//         ChangeByCompany: Boolean;
//         //       TOB@1100286013 :
//         TOB: Option "Table Data","Table","","Report","Codeunit","XMLport","MenuSuite","Page","Query","System";



//     trigger OnInitReport();
//     begin
//         isAdm := FunctionQB.IsQBAdmin;
//         SeeMessages := TRUE;
//     end;

//     trigger OnPreReport();
//     var
//         //                   Object@1100286000 :
//         Object: Record 2000000001;
//         //                   Version@1100286001 :
//         Version: Text;
//         //                   NeedChange@1100286002 :
//         NeedChange: Boolean;
//     begin
//         //JAV 18/06/22: - QB 1.10.51 Se usa la nueva funci¢n para ver la versi¢n nueva y si hay que actualizar
//         QBGlobalConf.NeedChangeVersion(Version, NeedChange);

//         //Si ha cambiado la version hacemos los cambios necesarios
//         if (NeedChange) then begin
//             if (Version <> QBGlobalConf."Global Version") then begin
//                 QBGlobalConf.GetGlobalConf('');
//                 QBGlobalConf."Global Version" := Version;
//                 QBGlobalConf.MODIFY;
//             end;
//         end;
//     end;



//     // procedure SetOption (pMessages@1100286000 :
//     procedure SetOption(pMessages: Boolean)
//     begin
//         SeeMessages := pMessages;
//     end;

//     //     LOCAL procedure SetDialog (pNro@1100286000 : Integer;pText@1100286001 :
//     LOCAL procedure SetDialog(pNro: Integer; pText: Text)
//     begin
//         if (not Presented) then begin
//             w.OPEN('Empresa #1################################\' +
//                    'Versi¢n #2################################\' +
//                    'Cambios #3################################');
//             w.UPDATE(1, Company.Name);
//             w.UPDATE(2, '');
//             w.UPDATE(3, '');
//             Presented := TRUE;
//         end;

//         w.UPDATE(pNro, pText);
//     end;

//     //     LOCAL procedure InitChange (pVersion@1100286000 : Code[5];pGlobalChange@1100286002 : Boolean;pChangeByCompany@1100286001 :
//     LOCAL procedure InitChange(pVersion: Code[5]; pGlobalChange: Boolean; pChangeByCompany: Boolean): Boolean;
//     begin
//         //Si el Cambio por empresas est  activo salimos directamente
//         if (ChangeByCompany) then
//             exit(FALSE);

//         //Si el cambio es global se hace solo en la primera empresa no en todas
//         if (pGlobalChange) and (not FirstCompany) then
//             exit(FALSE);

//         //Si la versi¢n actual es mayor que la nueva, ya est  actualizado y salimos
//         if (OldVersion >= pVersion) then
//             exit(FALSE);

//         //Si el cambio es por empresa
//         if (pChangeByCompany) then begin
//             //Solo debo hacer el cambio en la empresa actual.
//             if (Company.Name <> COMPANYNAME) then
//                 exit(FALSE);

//             // miro si esta empresa ya est  cambiada, si es as¡ finalizo directamente
//             ChangeByCompany := TRUE;
//             QBGlobalConf.GetGlobalConf(Company.Name);
//             if (QBGlobalConf."Version in Company" = pVersion) then
//                 exit(FALSE);
//         end;

//         //Comienza el proceso
//         SetDialog(2, pVersion);
//         NewVersion := pVersion;
//         Changed := TRUE;

//         //Por si lo necesito para los redondeos
//         Currency.RESET;
//         Currency.CHANGECOMPANY(Company.Name);
//         Currency.InitRoundingPrecision;

//         exit(TRUE);
//     end;

//     //     LOCAL procedure CheckCangedInAllCompany (pVersion@1100286000 :
//     LOCAL procedure CheckCangedInAllCompany(pVersion: Code[20]): Boolean;
//     var
//         //       locCompany@1100286002 :
//         locCompany: Record 2000000006;
//         //       Txt@1100286001 :
//         Txt: Text;
//     begin
//         //Si el cambio no es por empresa salgo directamente
//         if (not ChangeByCompany) then
//             exit(FALSE);

//         //Si se ha cambiado la versi¢n en la empresa me lo guardo
//         if (pVersion <> '') then begin
//             QBGlobalConf.GetGlobalConf(COMPANYNAME);
//             QBGlobalConf."Version in Company" := pVersion;
//             QBGlobalConf.MODIFY;

//             COMMIT;
//         end;

//         //Miro si faltan empresas en las que cambiar
//         Txt := '';
//         locCompany.RESET;
//         if (locCompany.FINDSET) then
//             repeat
//                 if not QBGlobalConf.ExistCompany(locCompany.Name) then
//                     Txt += '\   ' + locCompany.Name;
//             until (locCompany.NEXT = 0);

//         if (Txt <> '') then begin
//             MESSAGE('Para actualizar correctamente el cambio de versi¢n debe entrar todav¡a en estas empresas:' + Txt);
//             exit(TRUE);
//         end;

//         //Eliminar los registros que ya no son necesarios
//         QBGlobalConf.RESET;
//         QBGlobalConf.SETFILTER(key, '<>0');
//         QBGlobalConf.DELETEALL;

//         ChangeByCompany := FALSE; //Hemos completado los cambios
//         exit(FALSE);
//     end;

//     //     LOCAL procedure AddPermission (pType@1100286000 : Integer;pNumber@1100286001 :
//     LOCAL procedure AddPermission(pType: Integer; pNumber: Integer)
//     var
//         //       TenantPermission@1100286002 :
//         TenantPermission: Record 2000000166;
//     begin
//         TenantPermission.RESET;
//         TenantPermission.SETRANGE("Role ID", 'QB_BASE');
//         if (TenantPermission.FINDFIRST) then begin
//             TenantPermission."Object Type" := pType;
//             TenantPermission."Object ID" := pNumber;
//             TenantPermission."Read Permission" := TenantPermission."Read Permission"::" ";
//             TenantPermission."Insert Permission" := TenantPermission."Insert Permission"::" ";
//             TenantPermission."Modify Permission" := TenantPermission."Modify Permission"::" ";
//             TenantPermission."Delete Permission" := TenantPermission."Delete Permission"::" ";
//             TenantPermission."Execute Permission" := TenantPermission."Execute Permission"::Yes;
//             if not TenantPermission.INSERT then;

//             if (pType = TOB::Table) then begin
//                 TenantPermission."Object Type" := TenantPermission."Object Type"::"Table Data";
//                 TenantPermission."Object ID" := pNumber;
//                 TenantPermission."Read Permission" := TenantPermission."Read Permission"::Yes;
//                 TenantPermission."Insert Permission" := TenantPermission."Insert Permission"::Yes;
//                 TenantPermission."Modify Permission" := TenantPermission."Modify Permission"::Yes;
//                 TenantPermission."Delete Permission" := TenantPermission."Delete Permission"::Yes;
//                 TenantPermission."Execute Permission" := TenantPermission."Execute Permission"::" ";
//                 if not TenantPermission.INSERT then;
//             end;
//         end;
//     end;

//     LOCAL procedure C00001()
//     var
//         //       QBPrepayment@1100286001 :
//         QBPrepayment: Record 7206928;
//         //       QBPrepayment2@1100286000 :
//         QBPrepayment2: Record 7206928;
//         //       n@1100286002 :
//         n: Integer;
//         //       Txt000@1100286004 :
//         Txt000: TextConst ESP = '   Total %1 %2 del Proyecto %3';
//         //       Txt001@1100286003 :
//         Txt001: TextConst ESP = '      Total %1s del Proyecto %2';
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para QB 1.09.06
//         if (not InitChange('00001', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'ANTICIPOS');   //Cambios en anticipos
//         QBPrepayment.RESET;
//         QBPrepayment.CHANGECOMPANY(Company.Name);
//         if (QBPrepayment.FINDSET(TRUE)) then
//             repeat
//                 //Cambio del campo de tipo de documento
//                 CASE QBPrepayment."OLD_Entry Type" OF
//                     QBPrepayment."OLD_Entry Type"::Prepayment:
//                         QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Invoice;
//                     QBPrepayment."OLD_Entry Type"::Application:
//                         QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::Application;
//                     QBPrepayment."OLD_Entry Type"::TotalAccount:
//                         QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::"3";
//                     QBPrepayment."OLD_Entry Type"::TotalJob:
//                         QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::"4";
//                 end;
//                 QBPrepayment.MODIFY;
//             until QBPrepayment.NEXT = 0;

//         //Regenera todos los totales
//         QBPrepayment.RESET;
//         //verify similar scenarios
//         QBPrepayment.CHANGECOMPANY(Company.Name);
//         QBPrepayment.SETFILTER("Entry Type", '%1|%2', QBPrepayment."Entry Type"::"3", QBPrepayment."Entry Type"::"4");
//         QBPrepayment.DELETEALL;

//         QBPrepayment.RESET;
//         QBPrepayment.CHANGECOMPANY(Company.Name);
//         QBPrepayment2.CHANGECOMPANY(Company.Name);
//         QBPrepayment.SETFILTER("Entry Type", '%1|%2|%3', QBPrepayment."Entry Type"::Invoice, QBPrepayment."Entry Type"::Bill,
//                                                             QBPrepayment."Entry Type"::Application);

//         if (QBPrepayment.FINDSET(FALSE)) then
//             repeat
//                 //Total por cliente/proveedor
//                 QBPrepayment2.RESET;
//                 QBPrepayment2.SETRANGE("Job No.", QBPrepayment."Job No.");
//                 QBPrepayment2.SETRANGE("Account Type", QBPrepayment."Account Type");
//                 QBPrepayment2.SETRANGE("Account No.", QBPrepayment."Account No.");
//                 QBPrepayment2.SETRANGE("Entry Type", QBPrepayment2."Entry Type"::"3");
//                 if (not QBPrepayment2.FINDFIRST) then begin
//                     QBPrepayment2.RESET;
//                     QBPrepayment2.CHANGECOMPANY(Company.Name);
//                     QBPrepayment2.FINDLAST;
//                     n := QBPrepayment2."Entry No." + 1;

//                     QBPrepayment2.INIT;
//                     QBPrepayment2."Entry No." := n;
//                     QBPrepayment2."Job No." := QBPrepayment."Job No.";
//                     QBPrepayment2."Account Type" := QBPrepayment."Account Type";
//                     QBPrepayment2."Account No." := QBPrepayment."Account No.";
//                     QBPrepayment2."Entry Type" := QBPrepayment."Entry Type"::"3";
//                     QBPrepayment2.TC := TRUE;
//                     QBPrepayment2.Description := STRSUBSTNO(Txt000, FORMAT(QBPrepayment2."Account Type"), QBPrepayment2."Account No.", QBPrepayment."Job No.");
//                     QBPrepayment2.INSERT(FALSE);
//                 end;

//                 //Total por Proyectos
//                 QBPrepayment2.RESET;
//                 QBPrepayment2.SETRANGE("Job No.", QBPrepayment."Job No.");
//                 QBPrepayment2.SETRANGE("Account Type", QBPrepayment."Account Type");
//                 QBPrepayment2.SETRANGE("Entry Type", QBPrepayment2."Entry Type"::"4");
//                 if (not QBPrepayment2.FINDFIRST) then begin
//                     QBPrepayment2.INIT;
//                     QBPrepayment2."Entry No." := n + 1;
//                     QBPrepayment2."Job No." := QBPrepayment."Job No.";
//                     QBPrepayment2."Account Type" := QBPrepayment."Account Type";
//                     QBPrepayment2."Entry Type" := QBPrepayment."Entry Type"::"4";
//                     QBPrepayment2.TJ := TRUE;
//                     QBPrepayment2.Description := STRSUBSTNO(Txt001, FORMAT(QBPrepayment2."Account Type"), QBPrepayment."Job No.");
//                     QBPrepayment2.INSERT(FALSE);
//                 end;
//             until QBPrepayment.NEXT = 0;
//     end;

//     LOCAL procedure C00002()
//     var
//         //       CompanyInformation@1100286001 :
//         CompanyInformation: Record 79;
//         //       Txt000@1100286004 :
//         Txt000: TextConst ESP = '   Total %1 %2 del Proyecto %3';
//         //       Txt001@1100286003 :
//         Txt001: TextConst ESP = '      Total %1s del Proyecto %2';
//         //       QuoBuildingSetup@1100286000 :
//         QuoBuildingSetup: Record 7207278;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para QB 1.09.19
//         if (not InitChange('00002', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'QuoSII');   //Cambios en QuoSII
//         QuoBuildingSetup.RESET;
//         QuoBuildingSetup.CHANGECOMPANY(Company.Name);
//         if (QuoBuildingSetup.GET()) then begin
//             CompanyInformation.RESET;
//             CompanyInformation.CHANGECOMPANY(Company.Name);
//             if (CompanyInformation.GET()) then begin
//                 CompanyInformation."QuoSII Dimension Job" := QuoBuildingSetup."Dimension for Jobs Code";
//                 CompanyInformation.MODIFY;
//             end;
//         end;
//     end;

//     LOCAL procedure C00003()
//     var
//         //       MeasurementHeader@1100286005 :
//         MeasurementHeader: Record 7207336;
//         //       MeasurementLines@1100286004 :
//         MeasurementLines: Record 7207337;
//         //       HistMeasurements@1100286003 :
//         HistMeasurements: Record 7207338;
//         //       HistMeasureLines@1100286002 :
//         HistMeasureLines: Record 7207339;
//         //       PostCertifications@1100286001 :
//         PostCertifications: Record 7207341;
//         //       HistCertificationLines@1100286000 :
//         HistCertificationLines: Record 7207342;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para QB 1.09.20
//         if (not InitChange('00003', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Mediciones');
//         MeasurementHeader.RESET;
//         MeasurementHeader.CHANGECOMPANY(Company.Name);
//         MeasurementLines.RESET;
//         MeasurementLines.CHANGECOMPANY(Company.Name);
//         if (MeasurementLines.FINDSET(TRUE)) then
//             repeat
//                 if (not MeasurementHeader.GET(MeasurementLines."Document No.")) then begin
//                     //ERROR('Empresa: %1\Medici¢n: %2\NO EXISTE LA CABECERA', Company.Name, MeasurementLines."Document No.");
//                     //MeasurementLines.DELETE;
//                 end else begin
//                     if (MeasurementLines."Med. Term Measure" <> 0) then begin
//                         MeasurementLines."Term PEM Price" := ROUND(MeasurementLines."Med. Term PEM Amount" / MeasurementLines."Med. Term Measure", 0.000001);
//                         MeasurementLines."Term PEC Price" := ROUND(MeasurementLines."Med. Term PEC Amount" / MeasurementLines."Med. Term Measure", 0.000001);
//                     end else begin
//                         MeasurementLines."Term PEM Price" := 0;
//                         MeasurementLines."Term PEC Price" := 0;
//                     end;

//                     //if (MeasurementLines."Term PEM Price" - MeasurementLines."Sales Price" > 0.06) then
//                     //MESSAGE('Empresa: %1\Medici¢n: %2\Diferencia %3', Company.Name, MeasurementLines."Document No.", MeasurementLines."Term PEM Price" - MeasurementLines."Sales Price");
//                     MeasurementLines.MODIFY(FALSE);
//                 end;
//             until MeasurementLines.NEXT = 0;

//         HistMeasurements.RESET;
//         HistMeasurements.CHANGECOMPANY(Company.Name);
//         HistMeasureLines.RESET;
//         HistMeasureLines.CHANGECOMPANY(Company.Name);
//         if (HistMeasureLines.FINDSET(TRUE)) then
//             repeat
//                 if (not HistMeasurements.GET(HistMeasureLines."Document No.")) then begin
//                     //ERROR('Empresa: %1\Med.Reg: %2\NO EXISTE LA CABECERA', Company.Name, MeasurementLines."Document No.");
//                     //HistMeasureLines.DELETE;
//                 end else begin
//                     if (HistMeasureLines."Med. Term Measure" <> 0) then begin
//                         HistMeasureLines."Term PEM Price" := ROUND(HistMeasureLines."Med. Term Amount" / HistMeasureLines."Med. Term Measure", 0.000001);
//                         HistMeasureLines."Term PEC Price" := ROUND(HistMeasureLines."Med. Term PEC Amount" / HistMeasureLines."Med. Term Measure", 0.000001);
//                     end else begin
//                         HistMeasureLines."Term PEM Price" := 0;
//                         HistMeasureLines."Term PEC Price" := 0;
//                     end;

//                     //if (HistMeasureLines."Term PEM Price" <> 0) and (HistMeasureLines."Term PEM Price" - HistMeasureLines."Sale Price" > 0.06) then
//                     //MESSAGE('Empresa: %1\Med.Reg: %2\Diferencia %3 - %4 = %5', Company.Name, MeasurementLines."Document No.", HistMeasureLines."Term PEM Price", HistMeasureLines."Sale Price",
//                     //        HistMeasureLines."Term PEM Price" - HistMeasureLines."Sale Price");

//                     HistMeasureLines.MODIFY(FALSE);
//                 end;
//             until HistMeasureLines.NEXT = 0;

//         PostCertifications.RESET;
//         PostCertifications.CHANGECOMPANY(Company.Name);
//         HistCertificationLines.RESET;
//         HistCertificationLines.CHANGECOMPANY(Company.Name);
//         if (HistCertificationLines.FINDSET(TRUE)) then
//             repeat
//                 if (not PostCertifications.GET(HistCertificationLines."Document No.")) then begin
//                     //ERROR('Empresa: %1\Med.Reg: %2\NO EXISTE LA CABECERA', Company.Name, MeasurementLines."Document No.");
//                     //HistCertificationLines.DELETE;
//                 end else begin
//                     if (HistCertificationLines."Cert Quantity to Term" <> 0) then begin
//                         HistCertificationLines."Term PEM Price" := ROUND(HistCertificationLines."Cert Term PEM amount" / HistCertificationLines."Cert Quantity to Term", 0.000001);
//                         HistCertificationLines."Term PEC Price" := ROUND(HistCertificationLines."Cert Term PEC amount" / HistCertificationLines."Cert Quantity to Term", 0.000001);
//                     end else begin
//                         HistCertificationLines."Term PEM Price" := 0;
//                         HistCertificationLines."Term PEC Price" := 0;
//                     end;

//                     //if (HistCertificationLines."Term PEM Price" <> 0) and (HistCertificationLines."Term PEM Price" - HistCertificationLines."Sale Price" > 0.06) then
//                     //MESSAGE('Empresa: %1\Cert.Reg: %2\Diferencia %3 - %4 = %5', Company.Name, MeasurementLines."Document No.", HistCertificationLines."Term PEM Price", HistCertificationLines."Sale Price",
//                     //        HistCertificationLines."Term PEM Price" - HistCertificationLines."Sale Price");

//                     HistCertificationLines.MODIFY(FALSE);
//                 end;
//             until HistCertificationLines.NEXT = 0;
//     end;

//     LOCAL procedure C00004()
//     var
//         //       PurchRcptHeader@1100286001 :
//         PurchRcptHeader: Record 120;
//         //       PurchRcptLine@1100286000 :
//         PurchRcptLine: Record 121;
//         //       GLEntry@1100286002 :
//         GLEntry: Record 17;
//         //       SumaAlb@1100286003 :
//         SumaAlb: Decimal;
//         //       SumaCnt@1100286004 :
//         SumaCnt: Decimal;
//         //       Lista@1100286005 :
//         Lista: Text;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para QB 1.09.22
//         if (not InitChange('00004', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Albaranes');   //Nuevos campos para provisionado y desprovisionado, no me baso en la tabla sino en lo realmente contabilizado
//         Lista := '';
//         PurchRcptHeader.RESET;
//         PurchRcptHeader.CHANGECOMPANY(Company.Name);
//         if (PurchRcptHeader.FINDSET) then
//             repeat
//                 //Ajustamos los campos y sumamos
//                 SumaAlb := 0;
//                 PurchRcptLine.RESET;
//                 PurchRcptLine.CHANGECOMPANY(Company.Name);
//                 PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
//                 if (PurchRcptLine.FINDSET(TRUE)) then
//                     repeat
//                         if PurchRcptHeader.Cancelled then
//                             PurchRcptLine.Cancelled := TRUE;

//                         if (PurchRcptLine.Accounted) then begin
//                             if (PurchRcptLine.Cancelled) then
//                                 PurchRcptLine."QB Qty Provisioned" := 0
//                             else
//                                 PurchRcptLine."QB Qty Provisioned" := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";

//                             PurchRcptLine."QB Amount Provisioned" := ROUND(PurchRcptLine."QB Qty Provisioned" * PurchRcptLine."Unit Cost", Currency."Amount Rounding Precision");
//                             PurchRcptLine.MODIFY;
//                         end;

//                         SumaAlb += PurchRcptLine."QB Amount Provisioned";
//                     until PurchRcptLine.NEXT = 0;
//             until PurchRcptHeader.NEXT = 0;
//     end;

//     LOCAL procedure C00005()
//     var
//         //       PurchRcptHeader@1100286001 :
//         PurchRcptHeader: Record 120;
//         //       PurchRcptLine@1100286000 :
//         PurchRcptLine: Record 121;
//         //       GLEntry@1100286002 :
//         GLEntry: Record 17;
//         //       SumaAlb@1100286003 :
//         SumaAlb: Decimal;
//         //       SumaCnt@1100286004 :
//         SumaCnt: Decimal;
//         //       Lista@1100286005 :
//         Lista: Text;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para QB 1.09.26
//         if (not InitChange('00005', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Albaranes');   //Nuevos campos para importes
//         PurchRcptLine.RESET;
//         PurchRcptLine.CHANGECOMPANY(Company.Name);
//         if (PurchRcptLine.FINDSET(TRUE)) then
//             repeat
//                 if PurchRcptLine."Unit Cost (LCY)" = 0 then
//                     PurchRcptLine."Unit Cost (LCY)" := PurchRcptLine."Direct Unit Cost";
//                 PurchRcptLine.SetAmounts;
//                 PurchRcptLine.MODIFY;
//             until PurchRcptLine.NEXT = 0;
//     end;

//     LOCAL procedure C00006()
//     var
//         //       JobPostingGroup@1100286001 :
//         JobPostingGroup: Record 208;
//         //       QBPrepayment@1100286000 :
//         QBPrepayment: Record 7206928;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para fijar la nueva versi¢n de datos y QB 1.09.27
//         if (not InitChange('00006', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Ped.Serv.');
//         JobPostingGroup.RESET;
//         JobPostingGroup.CHANGECOMPANY(Company.Name);
//         if (JobPostingGroup.FINDSET(TRUE)) then
//             repeat
//                 JobPostingGroup."QB Invoice Acc. Service Order" := JobPostingGroup."Recognized Sales Account";
//                 JobPostingGroup.MODIFY;
//             until JobPostingGroup.NEXT = 0;

//         SetDialog(3, 'Anticipos');
//         QBPrepayment.RESET;
//         QBPrepayment.CHANGECOMPANY(Company.Name);
//         if (QBPrepayment.FINDSET(TRUE)) then
//             repeat
//                 if (QBPrepayment."Entry Type" IN [QBPrepayment."Entry Type"::Invoice, QBPrepayment."Entry Type"::Bill]) then begin
//                     QBPrepayment.Amount := ABS(QBPrepayment.Amount);
//                     QBPrepayment."Amount (LCY)" := ABS(QBPrepayment."Amount (LCY)");
//                 end else begin
//                     QBPrepayment.Amount := -ABS(QBPrepayment.Amount);
//                     QBPrepayment."Amount (LCY)" := -ABS(QBPrepayment."Amount (LCY)");
//                 end;
//                 QBPrepayment.MODIFY;
//             until QBPrepayment.NEXT = 0;
//         //QBPrepayment.GenerateTotals;
//     end;

//     LOCAL procedure C00007()
//     var
//         //       CashFlowForecastEntry@1100286000 :
//         CashFlowForecastEntry: Record 847;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n de datos 00007: QB 1.10.01
//         if (not InitChange('00007', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Mov.Prev.Tesorer¡a');
//         CashFlowForecastEntry.RESET;
//         CashFlowForecastEntry.CHANGECOMPANY(Company.Name);
//         if (CashFlowForecastEntry.FINDSET(TRUE)) then
//             repeat
//                 CashFlowForecastEntry."QB Job No." := CashFlowForecastEntry."OLD_Job No.";
//                 CashFlowForecastEntry."QB Payment Method Code" := CashFlowForecastEntry."OLD_Payment Method Code";
//                 CashFlowForecastEntry."QB Currency Code" := CashFlowForecastEntry."OLD_Currency Code";
//                 CashFlowForecastEntry."QB Piecework Code" := CashFlowForecastEntry."OLD_Piecework Code";
//                 CashFlowForecastEntry.MODIFY;
//             until CashFlowForecastEntry.NEXT = 0;
//     end;

//     LOCAL procedure C00008()
//     var
//         //       MeasurementLines@1100286004 :
//         MeasurementLines: Record 7207337;
//         //       HistMeasureLines@1100286002 :
//         HistMeasureLines: Record 7207339;
//         //       HistCertificationLines@1100286000 :
//         HistCertificationLines: Record 7207342;
//         //       DataPieceworkForProduction@1100286001 :
//         DataPieceworkForProduction: Record 7207386;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n de datos 00008: QB 1.10.14
//         if (not InitChange('00008', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Mediciones');   //Poner el expediente en medici¢n y certificaci¢n
//         DataPieceworkForProduction.RESET;
//         DataPieceworkForProduction.CHANGECOMPANY(Company.Name);

//         MeasurementLines.RESET;
//         MeasurementLines.CHANGECOMPANY(Company.Name);
//         if (MeasurementLines.FINDSET(TRUE)) then
//             repeat
//                 if DataPieceworkForProduction.GET(MeasurementLines."Job No.", MeasurementLines."Piecework No.") then begin
//                     MeasurementLines.Record := DataPieceworkForProduction."No. Record";
//                     MeasurementLines.MODIFY(FALSE);
//                 end;
//             until MeasurementLines.NEXT = 0;

//         HistMeasureLines.RESET;
//         HistMeasureLines.CHANGECOMPANY(Company.Name);
//         if (HistMeasureLines.FINDSET(TRUE)) then
//             repeat
//                 if DataPieceworkForProduction.GET(HistMeasureLines."Job No.", HistMeasureLines."Piecework No.") then begin
//                     HistMeasureLines.Record := DataPieceworkForProduction."No. Record";
//                     HistMeasureLines.MODIFY(FALSE);
//                 end;
//             until HistMeasureLines.NEXT = 0;

//         HistCertificationLines.RESET;
//         HistCertificationLines.CHANGECOMPANY(Company.Name);
//         if (HistCertificationLines.FINDSET(TRUE)) then
//             repeat
//                 if DataPieceworkForProduction.GET(HistCertificationLines."Job No.", HistCertificationLines."Piecework No.") then begin
//                     HistCertificationLines.Record := DataPieceworkForProduction."No. Record";
//                     HistCertificationLines.MODIFY(FALSE);
//                 end;
//             until HistCertificationLines.NEXT = 0;
//     end;

//     LOCAL procedure C00009()
//     var
//         //       QuoBuildingSetup@1100286002 :
//         QuoBuildingSetup: Record 7207278;
//         //       ResponsiblesTemplate@1100286001 :
//         ResponsiblesTemplate: Record 7206902;
//         //       ResponsiblesTemplate2@1100286000 :
//         ResponsiblesTemplate2: Record 7206902;
//         //       QBResponsiblesGroupTemplate@1100286004 :
//         QBResponsiblesGroupTemplate: Record 7206982;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n de datos 00009: QB 1.10.19
//         if (not InitChange('00009', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Plantillas Aprobaci¢n');
//         if QuoBuildingSetup.GET then begin
//             QBResponsiblesGroupTemplate.RESET;
//             QBResponsiblesGroupTemplate.CHANGECOMPANY(Company.Name);
//             QBResponsiblesGroupTemplate.INIT;
//             QBResponsiblesGroupTemplate.Code := 'GENERAL';
//             QBResponsiblesGroupTemplate.Description := 'Circuito general de aprobaciones';
//             QBResponsiblesGroupTemplate."Use in" := QBResponsiblesGroupTemplate."Use in"::All;
//             if not QBResponsiblesGroupTemplate.INSERT(TRUE) then;

//             ResponsiblesTemplate.RESET;
//             ResponsiblesTemplate.CHANGECOMPANY(Company.Name);
//             //++ResponsiblesTemplate.SETFILTER(Code,'=%1','');
//             if (ResponsiblesTemplate.FINDSET(TRUE)) then
//                 repeat
//                     ResponsiblesTemplate2 := ResponsiblesTemplate;
//                 //++ResponsiblesTemplate2.Code := QBResponsiblesGroupTemplate.Code;
//                 //++if not ResponsiblesTemplate2.INSERT then ;
//                 //++ResponsiblesTemplate.DELETE;
//                 until ResponsiblesTemplate.NEXT = 0;
//         end;
//     end;

//     LOCAL procedure C00010()
//     var
//         //       QMMasterDataTable@1100286006 :
//         QMMasterDataTable: Record 7174392;
//         //       QMMasterDataTableField@1100286011 :
//         QMMasterDataTableField: Record 7174393;
//         //       QBTablesSetup@1100286004 :
//         QBTablesSetup: Record 7206903;
//         //       Field@1100286008 :
//         Field: Record 2000000041;
//         //       TB@1100286009 :
//         TB: ARRAY[20] OF Integer;
//         //       i@1100286010 :
//         i: Integer;
//         //       QMMasterDataManagement@1100286012 :
//         QMMasterDataManagement: Codeunit 7174368;
//         //       rRef@1100286013 :
//         rRef: RecordRef;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n de datos 00010: QB 1.10.20
//         if (not InitChange('00010', TRUE, FALSE)) then
//             exit;

//         SetDialog(3, 'Master Data');

//         //Cargamos la tablas que actualmente se manejaban ya con sus campos marcados como no editables
//         QBTablesSetup.RESET;
//         QBTablesSetup.SETRANGE("OLD_Not editable in destinatio", TRUE);
//         if QBTablesSetup.FINDSET then
//             repeat
//                 QMMasterDataTable.INIT;
//                 QMMasterDataTable."Table No." := QBTablesSetup.Table;
//                 QMMasterDataTable.Sync := TRUE;
//                 if not QMMasterDataTable.INSERT then
//                     QMMasterDataTable.MODIFY;

//                 rRef.OPEN(QBTablesSetup.Table);
//                 QMMasterDataTableField.INIT;
//                 QMMasterDataTableField."Table No." := QBTablesSetup.Table;
//                 QMMasterDataTableField."Field No." := QBTablesSetup."Field No.";
//                 QMMasterDataTableField."not editable in destination" := QBTablesSetup."OLD_Not editable in destinatio";
//                 QMMasterDataTableField.PK := QMMasterDataManagement.IsPrimaryKeyField(rRef, QMMasterDataTableField."Field No.");
//                 if not QMMasterDataTableField.INSERT then
//                     rRef.CLOSE;
//             until (QBTablesSetup.NEXT = 0);

//         //Cargamos todos los campos que les falten a las tablas
//         QMMasterDataTable.RESET;
//         if (QMMasterDataTable.FINDSET) then
//             repeat
//                 Field.RESET;
//                 Field.SETRANGE(TableNo, QMMasterDataTable."Table No.");
//                 if Field.FINDSET then
//                     repeat
//                         rRef.OPEN(Field.TableNo);
//                         QMMasterDataTableField.INIT;
//                         QMMasterDataTableField."Table No." := Field.TableNo;
//                         QMMasterDataTableField."Field No." := Field."No.";
//                         QMMasterDataTableField."not editable in destination" := FALSE;
//                         QMMasterDataTableField.PK := QMMasterDataManagement.IsPrimaryKeyField(rRef, QMMasterDataTableField."Field No.");
//                         if not QMMasterDataTableField.INSERT then;
//                         rRef.CLOSE;
//                     until Field.NEXT = 0;

//             until (QMMasterDataTable.NEXT = 0);

//         //Cargamos todas las tablas que se manejaban anteriormente por si falta alguna
//         TB[1] := 18;
//         TB[2] := 23;
//         TB[3] := 27;
//         TB[4] := 156;
//         TB[5] := 348;
//         TB[6] := 413;
//         TB[7] := 270;
//         TB[8] := 5200;

//         FOR i := 1 TO 8 DO begin
//             QMMasterDataTable.INIT;
//             QMMasterDataTable."Table No." := TB[i];
//             QMMasterDataTable.Sync := TRUE;
//             if not QMMasterDataTable.INSERT then;
//             QMMasterDataTable.MODIFY;
//         end;

//         //Cargamos todos los campos que les falten a todas las tablas
//         QMMasterDataTable.RESET;
//         if (QMMasterDataTable.FINDSET) then
//             repeat
//                 Field.RESET;
//                 Field.SETRANGE(TableNo, QMMasterDataTable."Table No.");
//                 if Field.FINDSET then
//                     repeat
//                         rRef.OPEN(Field.TableNo);
//                         QMMasterDataTableField.INIT;
//                         QMMasterDataTableField."Table No." := Field.TableNo;
//                         QMMasterDataTableField."Field No." := Field."No.";
//                         QMMasterDataTableField."not editable in destination" := TRUE;
//                         QMMasterDataTableField.PK := QMMasterDataManagement.IsPrimaryKeyField(rRef, QMMasterDataTableField."Field No.");
//                         if not QMMasterDataTableField.INSERT then;
//                         rRef.CLOSE;
//                     until Field.NEXT = 0;

//             until (QMMasterDataTable.NEXT = 0);
//     end;

//     LOCAL procedure C00011()
//     var
//         //       QuoBuildingSetup@1100286000 :
//         QuoBuildingSetup: Record 7207278;
//         //       ResponsiblesGroupTemplate@1100286007 :
//         ResponsiblesGroupTemplate: Record 7206982;
//         //       QBJobResponsiblesGroupTem@1100286002 :
//         QBJobResponsiblesGroupTem: Record 7206990;
//         //       ResponsiblesTemplate@1100286016 :
//         ResponsiblesTemplate: Record 7206902;
//         //       RT@1100286001 :
//         RT: Record 7206902;
//         //       QBJobResponsiblesTemplate@1100286003 :
//         QBJobResponsiblesTemplate: Record 7206991;
//         //       Responsible@1100286005 :
//         Responsible: Record 7207313;
//         //       QBJobResponsibles@1100286006 :
//         QBJobResponsibles: Record 7206992;
//         //       Charge@1100286004 :
//         Charge: Record 7207312;
//         //       QBPosition@1100286008 :
//         QBPosition: Record 7206989;
//         //       QBApprovalCircuitHeader@1100286009 :
//         QBApprovalCircuitHeader: Record 7206986;
//         //       QBApprovalCircuitLines@1100286010 :
//         QBApprovalCircuitLines: Record 7206987;
//         //       Cod@1100286011 :
//         Cod: Code[10];
//         //       Type@1100286012 :
//         Type: Option;
//         //       d1@1100286013 :
//         d1: Integer;
//         //       d2@1100286014 :
//         d2: Decimal;
//         //       d3@1100286015 :
//         d3: Boolean;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n de datos 00011: QB 1.10.22
//         if (not InitChange('00011', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Aprobaciones');

//         //Movemos la tabla de cargos a la nueva
//         QBPosition.RESET;
//         QBPosition.CHANGECOMPANY(Company.Name);

//         Charge.RESET;
//         Charge.CHANGECOMPANY(Company.Name);
//         if (Charge.FINDSET) then
//             repeat
//                 QBPosition.INIT;
//                 QBPosition.Code := Charge.Code;
//                 QBPosition.Description := Charge.Description;
//                 if not QBPosition.INSERT then;
//             until Charge.NEXT = 0;

//         //Movemos la tabla de plantillas de responsables de los proyectos a la nueva
//         QBJobResponsiblesGroupTem.RESET;
//         QBJobResponsiblesGroupTem.CHANGECOMPANY(Company.Name);

//         ResponsiblesGroupTemplate.RESET;
//         ResponsiblesGroupTemplate.CHANGECOMPANY(Company.Name);
//         if (ResponsiblesGroupTemplate.FINDSET) then
//             repeat
//                 QBJobResponsiblesGroupTem.INIT;
//                 QBJobResponsiblesGroupTem.Code := ResponsiblesGroupTemplate.Code;
//                 QBJobResponsiblesGroupTem.Description := ResponsiblesGroupTemplate.Description;
//                 QBJobResponsiblesGroupTem."Use in" := ResponsiblesGroupTemplate."Use in";
//                 if not QBJobResponsiblesGroupTem.INSERT then;
//             until ResponsiblesGroupTemplate.NEXT = 0;

//         //Movemos la tabla de plantillas de responsables de los proyectos a la nueva
//         QBJobResponsiblesTemplate.RESET;
//         QBJobResponsiblesTemplate.CHANGECOMPANY(Company.Name);

//         ResponsiblesTemplate.RESET;
//         ResponsiblesTemplate.CHANGECOMPANY(Company.Name);
//         if (ResponsiblesTemplate.FINDSET) then
//             repeat
//                 QBJobResponsiblesTemplate.INIT;
//             //++QBJobResponsiblesTemplate.Template      := ResponsiblesTemplate.Code;
//             //++QBJobResponsiblesTemplate.Code          := ResponsiblesTemplate.Code;
//             //++QBJobResponsiblesTemplate."Use in"      := ResponsiblesTemplate."Job Type" ;
//             //++QBJobResponsiblesTemplate.Position      := ResponsiblesTemplate.Status ;
//             //++QBJobResponsiblesTemplate.Description   := ResponsiblesTemplate.Order ;
//             //++QBJobResponsiblesTemplate."The User"    := ResponsiblesTemplate.Description ;
//             //++QBJobResponsiblesTemplate."User ID"     := ResponsiblesTemplate."User ID" ;
//             //++QBJobResponsiblesTemplate."User to Use" := ResponsiblesTemplate."Approval Circuit" ;
//             //++if not QBJobResponsiblesTemplate.INSERT then ;
//             until ResponsiblesTemplate.NEXT = 0;


//         //Movemos la tabla de responsables de los proyectos a la nueva
//         QBJobResponsibles.RESET;
//         QBJobResponsibles.CHANGECOMPANY(Company.Name);

//         Responsible.RESET;
//         Responsible.CHANGECOMPANY(Company.Name);
//         if (Responsible.FINDSET) then
//             repeat
//                 QBJobResponsibles.INIT;
//                 if (Responsible.Type = Responsible.Type::Department) then
//                     QBJobResponsibles.Type := QBJobResponsibles.Type::Department
//                 else
//                     QBJobResponsibles.Type := QBJobResponsibles.Type::Job;

//                 QBJobResponsibles."Table Code" := Responsible."Table Code";
//                 QBJobResponsibles."ID Register" := Responsible.Code;
//                 QBJobResponsibles.Position := Responsible.Position;
//                 QBJobResponsibles."User ID" := Responsible."User ID";
//                 if not QBJobResponsibles.INSERT then;
//             until Responsible.NEXT = 0;

//         //Falta ahora montar los circuitos de aprobaci¢n con los datos existentes anterioremente
//         Cod := 'CA000';

//         QBJobResponsiblesTemplate.RESET;
//         QBJobResponsiblesTemplate.CHANGECOMPANY(Company.Name);

//         //{--- //+++
//         //      RT.RESET;
//         //      RT.CHANGECOMPANY(Company.Name);
//         //      if (RT.FINDSET) then
//         //        repeat
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::JobBudget,       RT."Perform Type",           RT."Perform Object",           RT."Cancel Type");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::Comparative,     RT."Comparative Approval Level",    RT."Comparative Approval Limit",    RT."Comparative Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::PurchaseOrder,   RT."Purchase 1 Approval Level",     RT."Purchase 1 Approval Limit",     RT."Purchase 1 Approval Unlim.");
//         //          C00011a(RT, 'MATERIALES',   Cod, QBApprovalCircuitHeader."Document Type"::PurchaseOrder,   RT."Purchase 2 Approval Level",     RT."Purchase 2 Approval Limit",     RT."Purchase 2 Approval Unlim.");
//         //          C00011a(RT, 'SUBCONTRATAS', Cod, QBApprovalCircuitHeader."Document Type"::PurchaseOrder,   RT."Purchase 3 Approval Level",     RT."Purchase 3 Approval Limit",     RT."Purchase 3 Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::PurchaseInvoice, RT."Purchase Inv.1 Approval Level", RT."Purchase Inv.1 Approval Limit", RT."Purchase Inv.1 Approval Unlim.");
//         //          C00011a(RT, 'MATERIALES',   Cod, QBApprovalCircuitHeader."Document Type"::PurchaseInvoice, RT."Purchase Inv.2 Approval Level", RT."Purchase Inv.2 Approval Limit", RT."Purchase Inv.2 Approval Unlim.");
//         //          C00011a(RT, 'SUBCONTRATAS', Cod, QBApprovalCircuitHeader."Document Type"::PurchaseInvoice, RT."Purchase Inv.3 Approval Level", RT."Purchase Inv.3 Approval Limit", RT."Purchase Inv.3 Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::Payments,        RT."Payment Approval Level",        RT."Payment Approval Limit",        RT."Payment Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::PaymentDue,      RT."Payment Due Approval Level",    0,                                  FALSE);
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::Certification,   RT."Measurement Approval Level",    RT."Measurement Approval Limit",    RT."Measurement Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::ExpenseNote,     RT."Expense Note Approval Level",   RT."Expense Note Approval Limit",   RT."Expense Note Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::WorkSheet,       RT."WorkSheet Approval Level",      RT."WorkSheet Approval Limit",      RT."WorkSheet Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::Transfers,       RT."Transfers Approval Level",      RT."Transfers Approval Limit",      RT."Transfers Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::PaymentOrder,    RT."Payment Order Approval Level",  RT."Payment Order Approval Limit",  RT."Payment Order Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::PurchaseCrMemo,  RT."Purch. CrMemo Approval Level",  RT."Purch. CrMemo Approval Limit",  RT."Purch. CrMemo Approval Unlim.");
//         //          C00011a(RT, 'GENERAL',      Cod, QBApprovalCircuitHeader."Document Type"::Budget,          RT."Buget Approval Level",          RT."Buget Approval Limit",          RT."Buget Approval Unlim.");
//         //        until RT.NEXT = 0;
//         //      ---}
//     end;

//     //     LOCAL procedure C00011a (ResponsiblesTemplate@1100286000 : Record 7206902;circuito@1100286001 : Text;var Cod@1100286015 : Code[10];Type@1100286014 : Option;d1@1100286013 : Integer;d2@1100286012 : Decimal;d3@1100286011 :
//     LOCAL procedure C00011a(ResponsiblesTemplate: Record 7206902; circuito: Text; var Cod: Code[10]; Type: Option; d1: Integer; d2: Decimal; d3: Boolean)
//     var
//         //       QBApprovalCircuitHeader@1100286009 :
//         QBApprovalCircuitHeader: Record 7206986;
//         //       QBApprovalCircuitLines@1100286010 :
//         QBApprovalCircuitLines: Record 7206987;
//         //       ASTERISCO@1100286002 :
//         ASTERISCO: TextConst ESP = '*';
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Auxiliar para en el C00011 no repetir tanto c¢digo
//         if (d1 <> 0) or (d2 <> 0) or (d3) then begin
//             QBApprovalCircuitHeader.RESET;
//             QBApprovalCircuitHeader.CHANGECOMPANY(Company.Name);
//             QBApprovalCircuitHeader.SETRANGE("Document Type", Type);
//             QBApprovalCircuitHeader.SETFILTER(Description, circuito + ASTERISCO);
//             if not QBApprovalCircuitHeader.FINDFIRST then begin
//                 Cod := INCSTR(Cod);
//                 QBApprovalCircuitHeader.INIT;
//                 QBApprovalCircuitHeader."Circuit Code" := Cod;
//                 QBApprovalCircuitHeader."Document Type" := Type;
//                 QBApprovalCircuitHeader.Description := COPYSTR(STRSUBSTNO('%1 para %2', circuito, FORMAT(QBApprovalCircuitHeader."Document Type")), 1, MAXSTRLEN(QBApprovalCircuitHeader.Description));
//                 QBApprovalCircuitHeader.INSERT;
//             end;
//             QBApprovalCircuitLines.RESET;
//             QBApprovalCircuitLines.CHANGECOMPANY(Company.Name);
//             QBApprovalCircuitLines."Circuit Code" := QBApprovalCircuitHeader."Circuit Code";
//             //++QBApprovalCircuitLines."Line Code"       := ResponsiblesTemplate.Code;
//             //++QBApprovalCircuitLines.Position          := ResponsiblesTemplate.Status;
//             QBApprovalCircuitLines."Approval Level" := d1;
//             QBApprovalCircuitLines."Approval Limit" := d2;
//             QBApprovalCircuitLines."Approval Unlim." := d3;
//             if not QBApprovalCircuitLines.INSERT then;
//         end;
//     end;

//     LOCAL procedure C00161()
//     var
//         //       ReturnShipmentHeader@1100286007 :
//         ReturnShipmentHeader: Record 6650;
//         //       ReturnShipmentLine@1100286006 :
//         ReturnShipmentLine: Record 6651;
//         //       OutputShipmentHeader@1100286005 :
//         OutputShipmentHeader: Record 7207308;
//         //       OutputShipmentLines@1100286004 :
//         OutputShipmentLines: Record 7207309;
//         //       ItemLedgEntry@1100286003 :
//         ItemLedgEntry: Record 32;
//         //       Job@1100286002 :
//         Job: Record 167;
//         //       PostedOutShipmentHeader@1100286001 :
//         PostedOutShipmentHeader: Record 7207310;
//         //       Item@1100286009 :
//         Item: Record 27;
//         //       InventoryPostingSetup@1100286011 :
//         InventoryPostingSetup: Record 5813;
//         //       PostPurchaseRcptOutput@1100286000 :
//         PostPurchaseRcptOutput: Codeunit 7207276;
//         //       OutLine@1100286010 :
//         OutLine: Integer;
//         //       JobNo@1100286008 :
//         JobNo: Code[20];
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 161: QB 1.10.23
//         if (not InitChange('00161', FALSE, TRUE)) then //Este cambio concreto se debe efectuar en todas las empresas una a una
//             exit;

//         //Comienza el proceso
//         SetDialog(3, 'Devoluciones');

//         ReturnShipmentHeader.RESET;
//         if ReturnShipmentHeader.FINDSET then
//             repeat
//                 ReturnShipmentLine.RESET;
//                 ReturnShipmentLine.SETRANGE("Document No.", ReturnShipmentHeader."No.");
//                 ReturnShipmentLine.SETRANGE(Type, ReturnShipmentLine.Type::Item);
//                 ReturnShipmentLine.SETRANGE(Accounted, FALSE);
//                 if not ReturnShipmentLine.ISEMPTY then begin
//                     PostedOutShipmentHeader.RESET;
//                     PostedOutShipmentHeader.SETCURRENTKEY("Purchase Rcpt. No.", "Posting Date");
//                     PostedOutShipmentHeader.SETRANGE("Purchase Rcpt. No.", ReturnShipmentHeader."No.");
//                     PostedOutShipmentHeader.SETRANGE("Documnet Type", PostedOutShipmentHeader."Documnet Type"::"Receipt.Return");
//                     if PostedOutShipmentHeader.ISEMPTY then begin
//                         //Contador para las l¡neas creadas
//                         OutLine := 0;

//                         //Crear albar n de salida de almac‚n
//                         ReturnShipmentLine.RESET;
//                         ReturnShipmentLine.SETRANGE("Document No.", ReturnShipmentHeader."No.");
//                         ReturnShipmentLine.SETRANGE(Type, ReturnShipmentLine.Type::Item);
//                         if ReturnShipmentLine.FINDSET then begin
//                             ItemLedgEntry.RESET;
//                             ItemLedgEntry.SETRANGE("Document Type", ItemLedgEntry."Document Type"::"Purchase Return Shipment");
//                             ItemLedgEntry.SETRANGE("Document No.", ReturnShipmentHeader."No.");
//                             if ItemLedgEntry.FINDFIRST then
//                                 JobNo := ItemLedgEntry."Job No."
//                             else
//                                 JobNo := ReturnShipmentLine."Job No.";

//                             if Job.GET(JobNo) then begin
//                                 //Crear la cabecera del albar n de salida
//                                 OutputShipmentHeader.INIT;
//                                 OutputShipmentHeader.VALIDATE("Job No.", Job."No.");
//                                 OutputShipmentHeader."No." := '';
//                                 OutputShipmentHeader.INSERT(TRUE);

//                                 OutputShipmentHeader.VALIDATE("Job No.", Job."No.");
//                                 OutputShipmentHeader.VALIDATE("Posting Date", ReturnShipmentHeader."Posting Date");
//                                 OutputShipmentHeader."Posting Description" := 'Anulaci¢n del albar n N§ ' + ReturnShipmentHeader."No.";
//                                 OutputShipmentHeader."Automatic Shipment" := TRUE;
//                                 OutputShipmentHeader."Dimension Set ID" := ReturnShipmentHeader."Dimension Set ID";
//                                 OutputShipmentHeader."Automatic Shipment" := TRUE;
//                                 OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::"Receipt.Return";
//                                 OutputShipmentHeader."Purchase Rcpt. No." := ReturnShipmentHeader."No.";
//                                 OutputShipmentHeader.MODIFY;

//                                 repeat
//                                     if (Item.GET(ReturnShipmentLine."No.")) then begin
//                                         if (InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group")) then begin
//                                             OutLine += 10000;

//                                             OutputShipmentLines.INIT;
//                                             OutputShipmentLines.VALIDATE("Document No.", OutputShipmentHeader."No.");
//                                             OutputShipmentLines."Line No." := OutLine;
//                                             OutputShipmentLines.VALIDATE("Job No.", Job."No.");
//                                             OutputShipmentLines.VALIDATE("No.", ReturnShipmentLine."No.");
//                                             OutputShipmentLines.VALIDATE("Unit of Measure Code", ReturnShipmentLine."Unit of Measure Code");
//                                             OutputShipmentLines."Unit of Mensure Quantity" := ReturnShipmentLine."Qty. per Unit of Measure";
//                                             OutputShipmentLines.VALIDATE(Quantity, ReturnShipmentLine.Quantity);
//                                             OutputShipmentLines.VALIDATE("Outbound Warehouse", Job."Job Location");
//                                             OutputShipmentLines.VALIDATE("Produccion Unit", Job."Warehouse Cost Unit");
//                                             OutputShipmentLines.VALIDATE("Unit Cost", ReturnShipmentLine."Unit Cost (LCY)");
//                                             OutputShipmentLines."Job Task No." := ReturnShipmentLine."Job Task No.";
//                                             OutputShipmentLines."Dimension Set ID" := ReturnShipmentLine."Dimension Set ID";
//                                             OutputShipmentLines.Cancellation := TRUE;
//                                             OutputShipmentLines."Item Rcpt. Entry No." := ReturnShipmentLine."Item Shpt. Entry No.";
//                                             OutputShipmentLines.INSERT;

//                                             //Marcamos la linea como contabilizada para que no se repita este proceso si se lanza varias veces
//                                             ReturnShipmentLine.Accounted := TRUE;
//                                             ReturnShipmentLine.MODIFY;
//                                         end;
//                                     end;
//                                 until ReturnShipmentLine.NEXT = 0;
//                             end;
//                         end;

//                         //Registrarlo si tiene l¡neas, si no se elimina directamente
//                         if (OutLine <> 0) then
//                             PostPurchaseRcptOutput.RUN(OutputShipmentHeader)
//                         else
//                             if not OutputShipmentHeader.DELETE then;  //Por si no ha dado de alta la cabecera
//                     end;
//                 end;
//             until (ReturnShipmentHeader.NEXT = 0);
//     end;

//     LOCAL procedure C00162()
//     var
//         //       PostCertifications@1100286000 :
//         PostCertifications: Record 7207341;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 163: QB 1.10.24
//         if (not InitChange('00163', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Certificaciones');

//         //Cargamos la tablas que actualmente se manejaban ya con sus campos marcados como no editables
//         PostCertifications.RESET;
//         PostCertifications.CHANGECOMPANY(Company.Name);
//         if PostCertifications.FINDSET then
//             repeat
//                 PostCertifications."Certification Date" := PostCertifications."Measurement Date";
//                 PostCertifications.MODIFY;
//             until (PostCertifications.NEXT = 0);
//     end;

//     LOCAL procedure C00164()
//     var
//         //       JobQueueCategory@1100286000 :
//         JobQueueCategory: Record 471;
//         //       JobQueueEntry@1100286001 :
//         JobQueueEntry: Record 472;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 164
//         if (not InitChange('00164', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Colas Proyecto');

//         //Cargamos la tablas que actualmente se manejaban ya con sus campos marcados como no editables
//         JobQueueCategory.RESET;
//         JobQueueCategory.CHANGECOMPANY(Company.Name);
//         if JobQueueCategory.GET('SII') then begin
//             JobQueueCategory.DELETE;
//             JobQueueCategory.Code := 'QUOSII';
//             JobQueueCategory.Description := 'Tareas QuoSII';
//             JobQueueCategory.INSERT;
//         end;

//         JobQueueEntry.RESET;
//         JobQueueEntry.CHANGECOMPANY(Company.Name);
//         if JobQueueEntry.FINDSET then
//             repeat
//                 if JobQueueEntry."Job Queue Category Code" = 'SII' then begin
//                     JobQueueEntry."Job Queue Category Code" := 'QUOSII';
//                     JobQueueEntry.MODIFY;
//                 end;
//             until (JobQueueEntry.NEXT = 0);
//     end;

//     LOCAL procedure C00165()
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 165
//         if (not InitChange('00165', TRUE, FALSE)) then
//             exit;

//         SetDialog(3, 'Permisos');

//         C00165a(7206985);
//         C00165a(7206921);
//         C00165a(7174390);
//         C00165a(7174391);
//         C00165a(7174392);
//         C00165a(7174393);
//         C00165a(7174394);
//         C00165a(7174395);
//     end;

//     //     LOCAL procedure C00165a (pTable@1100286002 :
//     LOCAL procedure C00165a(pTable: Integer)
//     var
//         //       TenantPermission@1100286001 :
//         TenantPermission: Record 2000000166;
//         //       TenantPermissionBase@1100286000 :
//         TenantPermissionBase: Record 2000000166;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Auxiliar para en el C00165 no repetir tanto c¢digo
//         TenantPermissionBase.RESET;
//         TenantPermissionBase.SETRANGE("Role ID", 'QB_BASE');
//         if TenantPermissionBase.FINDFIRST then begin

//             TenantPermission.INIT;
//             TenantPermission."App ID" := TenantPermissionBase."App ID";
//             TenantPermission."Role ID" := TenantPermissionBase."Role ID";
//             TenantPermission."Object Type" := TenantPermissionBase."Object Type"::"Table Data";
//             TenantPermission."Object ID" := pTable;
//             TenantPermission."Read Permission" := TenantPermissionBase."Read Permission"::Yes;
//             TenantPermission."Insert Permission" := TenantPermissionBase."Insert Permission"::Yes;
//             TenantPermission."Modify Permission" := TenantPermissionBase."Modify Permission"::Yes;
//             TenantPermission."Delete Permission" := TenantPermissionBase."Delete Permission"::Yes;
//             if not TenantPermission.INSERT then;

//             TenantPermission.INIT;
//             TenantPermission."App ID" := TenantPermissionBase."App ID";
//             TenantPermission."Role ID" := TenantPermissionBase."Role ID";
//             TenantPermission."Object Type" := TenantPermissionBase."Object Type"::Table;
//             TenantPermission."Object ID" := pTable;
//             TenantPermission."Execute Permission" := TenantPermissionBase."Execute Permission"::Yes;
//             if not TenantPermission.INSERT then;
//         end;
//     end;

//     LOCAL procedure C00166()
//     var
//         //       WithholdingMovements@1100286000 :
//         WithholdingMovements: Record 7207329;
//         //       SalesCrMemoHeader@1100286002 :
//         SalesCrMemoHeader: Record 114;
//         //       PurchCrMemoHdr@1100286004 :
//         PurchCrMemoHdr: Record 124;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 166
//         if (not InitChange('00166', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Retenciones');

//         WithholdingMovements.RESET;
//         WithholdingMovements.CHANGECOMPANY(Company.Name);
//         if WithholdingMovements.FINDSET(TRUE) then
//             repeat
//                 WithholdingMovements.Amount := ABS(WithholdingMovements.Amount);
//                 WithholdingMovements."Amount (LCY)" := ABS(WithholdingMovements."Amount (LCY)");
//                 WithholdingMovements."Withholding Base" := ABS(WithholdingMovements."Withholding Base");
//                 WithholdingMovements."Withholding Base (LCY)" := ABS(WithholdingMovements."Withholding Base (LCY)");

//                 if (WithholdingMovements.Type = WithholdingMovements.Type::Customer) then begin
//                     if SalesCrMemoHeader.GET(WithholdingMovements."Document No.") then begin
//                         WithholdingMovements."Document Type" := WithholdingMovements."Document Type"::CrMemo;
//                         WithholdingMovements.Amount := -ABS(WithholdingMovements.Amount);
//                         WithholdingMovements."Amount (LCY)" := -ABS(WithholdingMovements."Amount (LCY)");
//                         WithholdingMovements."Withholding Base" := -ABS(WithholdingMovements."Withholding Base");
//                         WithholdingMovements."Withholding Base (LCY)" := -ABS(WithholdingMovements."Withholding Base (LCY)");
//                     end;
//                 end else begin
//                     if PurchCrMemoHdr.GET(WithholdingMovements."Document No.") then begin
//                         WithholdingMovements."Document Type" := WithholdingMovements."Document Type"::CrMemo;
//                         WithholdingMovements.Amount := -ABS(WithholdingMovements.Amount);
//                         WithholdingMovements."Amount (LCY)" := -ABS(WithholdingMovements."Amount (LCY)");
//                         WithholdingMovements."Withholding Base" := -ABS(WithholdingMovements."Withholding Base");
//                         WithholdingMovements."Withholding Base (LCY)" := -ABS(WithholdingMovements."Withholding Base (LCY)");
//                     end;
//                 end;
//                 WithholdingMovements.MODIFY;
//             until WithholdingMovements.NEXT = 0;
//     end;

//     LOCAL procedure C00167()
//     var
//         //       QBPrepaymentTypes@1100286000 :
//         QBPrepaymentTypes: Record 7206993;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 167
//         if (not InitChange('00167', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Tipos de Anticipo');


//         QBPrepaymentTypes.RESET;
//         QBPrepaymentTypes.CHANGECOMPANY(Company.Name);
//         QBPrepaymentTypes.Code := 'MATERIALES';
//         QBPrepaymentTypes."Description for Invoices" := 'Anticipo a cuenta sobre Materiales, %2, proyecto %3';
//         QBPrepaymentTypes."Description for Bills" := 'Anticipo Materiales proyecto %3';
//         if not QBPrepaymentTypes.INSERT then;

//         QBPrepaymentTypes.Code := 'MAQUINARIA';
//         QBPrepaymentTypes."Description for Invoices" := 'Anticipo a cuenta sobre Maquinaria, %2, proyecto %3';
//         QBPrepaymentTypes."Description for Bills" := 'Anticipo Maquinaria proyecto %3';
//         if not QBPrepaymentTypes.INSERT then;

//         QBPrepaymentTypes.Code := 'PEDIDO';
//         QBPrepaymentTypes."Description for Invoices" := 'A cuenta N/Pedido %1\%2, para el proyecto %3';
//         QBPrepaymentTypes."Description for Bills" := 'Anticipo Pedido %1 proyecto %3';
//         if not QBPrepaymentTypes.INSERT then;
//     end;

//     LOCAL procedure C00168()
//     var
//         //       QuoBuildingSetup@1100286000 :
//         QuoBuildingSetup: Record 7207278;
//         //       QBApprovalsSetup@1100286001 :
//         QBApprovalsSetup: Record 7206994;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 168
//         if (not InitChange('00168', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Aprobaciones');

//         QuoBuildingSetup.RESET;
//         QuoBuildingSetup.CHANGECOMPANY(Company.Name);
//         if not QuoBuildingSetup.GET then
//             QuoBuildingSetup.INIT;

//         QBApprovalsSetup.RESET;
//         QBApprovalsSetup.CHANGECOMPANY(Company.Name);
//         if not QBApprovalsSetup.GET then begin
//             QBApprovalsSetup.INIT;
//             //verify similar scenarios
//             QBApprovalsSetup."Approvals Payments Checks" := QuoBuildingSetup."OLD_Approvals Payments Checks";
//             QBApprovalsSetup."Manual. App. Payments Request" := QuoBuildingSetup."OLD_Manual. App. Payments Requ";
//             QBApprovalsSetup."Send App. Comparative to Order" := QuoBuildingSetup."OLD_Send App. Compar. to Order";
//             QBApprovalsSetup."Evaluation Order" := QuoBuildingSetup."OLD_Evaluation Order";
//             QBApprovalsSetup."User Approve" := QuoBuildingSetup."OLD_User Approve";
//             QBApprovalsSetup."Send App. Prepayment to Doc." := QuoBuildingSetup."OLD_Send App. Prepaym. to Doc.";

//             QBApprovalsSetup."Approvals 20 Type" := QBApprovalsSetup."Approvals 20 Type"::Department;    //La de ¢rdenes de pago

//             QBApprovalsSetup.GetCkeckText;

//             QBApprovalsSetup.INSERT;
//         end;
//     end;

//     LOCAL procedure C00170()
//     var
//         //       WebService@1100286000 :
//         WebService: Record 2000000076;
//         //       TenantWebService@1100286001 :
//         TenantWebService: Record 2000000168;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 170
//         if (not InitChange('00170', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Web Services');

//         WebService.RESET;
//         WebService.SETRANGE("Object Type", WebService."Object Type"::Query);
//         WebService.SETRANGE("Object ID", 50000, 50099);
//         WebService.DELETEALL;

//         TenantWebService.RESET;
//         TenantWebService.SETRANGE("Object Type", TenantWebService."Object Type"::Query);
//         TenantWebService.SETRANGE("Object ID", 50000, 50099);
//         TenantWebService.DELETEALL;
//     end;

//     LOCAL procedure C00172()
//     var
//         //       QuoBuildingSetup@1100286000 :
//         QuoBuildingSetup: Record 7207278;
//         //       InventorySetup@1100286001 :
//         InventorySetup: Record 313;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 172
//         if (not InitChange('00172', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Almac‚n');

//         QuoBuildingSetup.RESET;
//         QuoBuildingSetup.CHANGECOMPANY(Company.Name);
//         if QuoBuildingSetup.GET then begin

//             InventorySetup.RESET;
//             InventorySetup.CHANGECOMPANY(Company.Name);
//             InventorySetup.GET;

//             InventorySetup."Prevent Negative Inventory" := not QuoBuildingSetup."OLD_Location negative";  //El campo est ndar tiene el sentido contrario al de QB
//             InventorySetup.MODIFY;
//         end;
//     end;

//     LOCAL procedure C00173()
//     var
//         //       QBPrepayment@1100286000 :
//         QBPrepayment: Record 7206928;
//         //       QBPrepaymentManagement@1100286001 :
//         QBPrepaymentManagement: Codeunit 7207300;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 173
//         if (not InitChange('00173', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Anticipos');

//         QBPrepayment.RESET;
//         QBPrepayment.CHANGECOMPANY(Company.Name);
//         if (QBPrepayment.FINDFIRST) then
//             QBPrepaymentManagement.RegenerateTotals(QBPrepayment);
//     end;

//     LOCAL procedure C00174()
//     var
//         //       QBApprovalsSetup@1100286000 :
//         QBApprovalsSetup: Record 7206994;
//         //       QMMasterDataCompanies@1100286002 :
//         QMMasterDataCompanies: Record 7174391;
//         //       QMMasterDataTable@1100286001 :
//         QMMasterDataTable: Record 7174392;
//         //       QMMasterDataTableField@1100286003 :
//         QMMasterDataTableField: Record 7174393;
//         //       QBTablesSetup@1100286004 :
//         QBTablesSetup: Record 7206903;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 174
//         if (not InitChange('00174', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Aprobaciones');

//         QBApprovalsSetup.RESET;
//         QBApprovalsSetup.CHANGECOMPANY(Company.Name);
//         if (QBApprovalsSetup.GET()) then begin
//             QBApprovalsSetup."Show Confirmation Message" := TRUE;
//             QBApprovalsSetup.MODIFY;
//         end;

//         SetDialog(3, 'Master Data');

//         QMMasterDataCompanies.RESET;
//         QMMasterDataCompanies.CHANGECOMPANY(Company.Name);
//         if QMMasterDataCompanies.FINDSET then
//             repeat
//                 QMMasterDataCompanies.VALIDATE("Is not Master");
//                 QMMasterDataCompanies.MODIFY(TRUE);
//             until QMMasterDataCompanies.NEXT = 0;

//         QMMasterDataTable.RESET;
//         QMMasterDataTable.CHANGECOMPANY(Company.Name);
//         if QMMasterDataTable.FINDSET then
//             repeat
//                 QMMasterDataTableField.CreateFields(QMMasterDataTable."Table No.");
//             until QMMasterDataTable.NEXT = 0;

//         QBTablesSetup.RESET;
//         QBTablesSetup.CHANGECOMPANY(Company.Name);
//         QBTablesSetup.DeleteEmpty;
//     end;

//     LOCAL procedure C00180()
//     var
//         //       OLD_Responsible@1100286000 :
//         OLD_Responsible: Record 7207313;
//         //       QBJobResponsible@1100286001 :
//         QBJobResponsible: Record 7206992;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 180
//         if (not InitChange('00180', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Responsable Part.Pres.');

//         OLD_Responsible.RESET;
//         OLD_Responsible.CHANGECOMPANY(Company.Name);
//         OLD_Responsible.SETFILTER("QB_Piecework No. Ap", '<>%1', '');
//         if OLD_Responsible.FINDSET then
//             repeat
//                 QBJobResponsible.INIT;
//                 QBJobResponsible.Type := QBJobResponsible.Type::Piecework;
//                 QBJobResponsible."Table Code" := OLD_Responsible."Table Code";
//                 QBJobResponsible."Piecework No." := OLD_Responsible."QB_Piecework No. Ap";
//                 QBJobResponsible."ID Register" := OLD_Responsible.Code;
//                 QBJobResponsible.Position := OLD_Responsible.Position;
//                 QBJobResponsible."User ID" := OLD_Responsible."User ID";
//                 if not QBJobResponsible.INSERT(TRUE) then;
//             until OLD_Responsible.NEXT = 0;
//     end;

//     LOCAL procedure C00181()
//     var
//         //       QuoBuildingSetup@1100286004 :
//         QuoBuildingSetup: Record 7207278;
//         //       PurchaseHeader@1100286000 :
//         PurchaseHeader: Record 38;
//         //       PurchaseLine@1100286001 :
//         PurchaseLine: Record 39;
//         //       FunctionQB@1100286003 :
//         FunctionQB: Codeunit 7207272;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 181
//         if (not InitChange('00181', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Cab.compra');
//         PurchaseHeader.RESET;
//         PurchaseHeader.CHANGECOMPANY(Company.Name);
//         if PurchaseHeader.FINDSET(TRUE) then
//             repeat
//                 PurchaseHeader."QB Approval Job No" := PurchaseHeader."QB Job No.";
//                 PurchaseHeader."QB Approval Budget item" := PurchaseHeader."QB Budget item";
//                 PurchaseHeader.MODIFY;
//             until PurchaseHeader.NEXT = 0;

//         SetDialog(3, 'Lin.compra');
//         QuoBuildingSetup.RESET;
//         QuoBuildingSetup.CHANGECOMPANY(Company.Name);
//         QuoBuildingSetup.GET;
//         if QuoBuildingSetup.Quobuilding or QuoBuildingSetup."QPR Budgets" or QuoBuildingSetup."RE Real Estate" then begin
//             PurchaseLine.RESET;
//             PurchaseLine.CHANGECOMPANY(Company.Name);
//             if PurchaseLine.FINDSET(TRUE) then
//                 repeat
//                     //PurchaseLine."Job No." := FunctionQB.GetDimValueFromID(QuoBuildingSetup."Dimension for Jobs Code", PurchaseLine."Dimension Set ID");
//                     PurchaseLine."QB CA Code" := QuoBuildingSetup."Dimension for CA Code";
//                     PurchaseLine."QB CA Value" := PurchaseLine."Shortcut Dimension 2 Code";  //Asumimos que est  bien configurado y la dim.2 es CA
//                     PurchaseLine.MODIFY;
//                 until PurchaseLine.NEXT = 0;
//         end;
//     end;

//     LOCAL procedure C00185()
//     var
//         //       ComparativeQuoteHeader@1100286000 :
//         ComparativeQuoteHeader: Record 7207412;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 185
//         if (not InitChange('00185', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Comprativos');
//         ComparativeQuoteHeader.RESET;
//         ComparativeQuoteHeader.CHANGECOMPANY(Company.Name);
//         if ComparativeQuoteHeader.FINDSET(TRUE) then
//             repeat
//                 if (ComparativeQuoteHeader."Selected Vendor" <> '') then
//                     ComparativeQuoteHeader."Comparative Status" := ComparativeQuoteHeader."Comparative Status"::Selected;
//                 if (ComparativeQuoteHeader."Approval Status" = ComparativeQuoteHeader."Approval Status"::Released) then
//                     ComparativeQuoteHeader."Comparative Status" := ComparativeQuoteHeader."Comparative Status"::Approved;
//                 if (ComparativeQuoteHeader."Generated Contract Doc No." <> '') then
//                     ComparativeQuoteHeader."Comparative Status" := ComparativeQuoteHeader."Comparative Status"::Generated;
//                 ComparativeQuoteHeader.MODIFY;
//             until ComparativeQuoteHeader.NEXT = 0;
//     end;

//     LOCAL procedure C00187()
//     var
//         //       WithholdingMovements@1100286000 :
//         WithholdingMovements: Record 7207329;
//         //       QBPrepayment@1100286001 :
//         QBPrepayment: Record 7206928;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 187
//         if (not InitChange('00187', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Retenciones');
//         WithholdingMovements.RESET;
//         WithholdingMovements.CHANGECOMPANY(Company.Name);
//         if WithholdingMovements.FINDSET(TRUE) then
//             repeat
//                 WithholdingMovements.VALIDATE("No.");
//                 WithholdingMovements.MODIFY;
//             until WithholdingMovements.NEXT = 0;

//         SetDialog(3, 'Anticipos');
//         QBPrepayment.RESET;
//         QBPrepayment.CHANGECOMPANY(Company.Name);
//         if (QBPrepayment.FINDSET) then begin
//             MESSAGE('Anticipos en la empresa ' + Company.Name);
//             repeat
//                 if QBPrepayment."Entry Type" = QBPrepayment."Entry Type"::"3" then
//                     QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::TAccount;
//                 if QBPrepayment."Entry Type" = QBPrepayment."Entry Type"::"4" then
//                     QBPrepayment."Entry Type" := QBPrepayment."Entry Type"::TJob;

//                 QBPrepayment.MODIFY(TRUE);

//             until QBPrepayment.NEXT = 0;
//         end;
//     end;

//     LOCAL procedure C00191()
//     var
//         //       HistCertificationLines@1100286000 :
//         HistCertificationLines: Record 7207342;
//         //       QBJobResponsiblesGroupTem@1100286001 :
//         QBJobResponsiblesGroupTem: Record 7206990;
//         //       QBJobResponsiblesTemplate@1100286002 :
//         QBJobResponsiblesTemplate: Record 7206991;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 191
//         if (not InitChange('00191', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Certificaciones');
//         HistCertificationLines.RESET;
//         HistCertificationLines.CHANGECOMPANY(Company.Name);
//         if HistCertificationLines.FINDSET(TRUE) then
//             repeat
//                 //JAV 22/06/22: - QB 1.10.54 Se recalculan estos importes a PEC porque dan problemas
//                 HistCertificationLines."Cert Term PEC amount" := ROUND(HistCertificationLines."Cert Quantity to Term" * HistCertificationLines."Contract Price", 0.01);
//                 HistCertificationLines."Cert Source PEC amount" := ROUND(HistCertificationLines."Cert Quantity to Origin" * HistCertificationLines."Contract Price", 0.01);
//                 HistCertificationLines.MODIFY;
//             until HistCertificationLines.NEXT = 0;

//         SetDialog(3, 'Grupo Aprob.');
//         QBJobResponsiblesGroupTem.RESET;
//         QBJobResponsiblesGroupTem.CHANGECOMPANY(Company.Name);
//         if QBJobResponsiblesGroupTem.FINDSET(TRUE) then
//             repeat
//                 if QBJobResponsiblesGroupTem.Code = '' then
//                     QBJobResponsiblesGroupTem.DELETE(FALSE);
//             until HistCertificationLines.NEXT = 0;

//         QBJobResponsiblesTemplate.RESET;
//         QBJobResponsiblesTemplate.CHANGECOMPANY(Company.Name);
//         if QBJobResponsiblesTemplate.FINDSET(TRUE) then
//             repeat
//                 if QBJobResponsiblesTemplate.Template = '' then
//                     QBJobResponsiblesTemplate.DELETE(FALSE);
//             until QBJobResponsiblesTemplate.NEXT = 0;
//     end;

//     LOCAL procedure C00194()
//     var
//         //       QuoBuildingSetup@1100286000 :
//         QuoBuildingSetup: Record 7207278;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 194
//         if (not InitChange('00194', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Anticipos');
//         QuoBuildingSetup.RESET;
//         QuoBuildingSetup.CHANGECOMPANY(Company.Name);
//         if QuoBuildingSetup.GET then begin
//             QuoBuildingSetup."Prepayment Posting Group 2" := QuoBuildingSetup."Prepayment Posting Group 1";
//             QuoBuildingSetup.MODIFY;
//         end;
//     end;

//     LOCAL procedure C00196()
//     var
//         //       QBTablesSetup@1100286000 :
//         QBTablesSetup: Record 7206903;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 196
//         if (not InitChange('00196', TRUE, FALSE)) then
//             exit;

//         SetDialog(3, 'Campos');
//         C00196a(7207386, 71, 'PEC');
//         C00196a(7207386, 90, 'PEM');
//         C00196a(7207386, 103, 'Importe a PEM');
//         C00196a(7207386, 115, 'Importe a PEC');
//     end;

//     //     LOCAL procedure C00196a (pTable@1100286001 : Integer;pField@1100286002 : Integer;pText@1100286003 :
//     LOCAL procedure C00196a(pTable: Integer; pField: Integer; pText: Text)
//     var
//         //       QBTablesSetup@1100286000 :
//         QBTablesSetup: Record 7206903;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 196, auxiliar
//         QBTablesSetup.RESET;
//         QBTablesSetup.CHANGECOMPANY(Company.Name);
//         if not (QBTablesSetup.GET(pTable, pField, '')) then begin
//             QBTablesSetup.INIT;
//             QBTablesSetup.Table := pTable;
//             QBTablesSetup."Field No." := pField;
//             QBTablesSetup."New Caption" := pText;
//             QBTablesSetup.INSERT;
//         end else if (QBTablesSetup."New Caption" = '') then begin
//             QBTablesSetup."New Caption" := pText;
//             QBTablesSetup.MODIFY;
//         end;
//     end;

//     LOCAL procedure C00197()
//     var
//         //       Customer@1100286000 :
//         Customer: Record 18;
//         //       Vendor@1100286001 :
//         Vendor: Record 23;
//         //       JobLedgerEntry@1100286002 :
//         JobLedgerEntry: Record 169;
//         //       FixedAsset@1100286003 :
//         FixedAsset: Record 5600;
//         //       FADepreciationBook@1100286004 :
//         FADepreciationBook: Record 5612;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 196
//         if (not InitChange('00196', FALSE, FALSE)) then
//             exit;

//         SetDialog(3, 'Mov.Proyecto Nombres');

//         Customer.RESET;
//         Customer.CHANGECOMPANY(Company.Name);
//         Vendor.RESET;
//         Vendor.CHANGECOMPANY(Company.Name);

//         JobLedgerEntry.RESET;
//         JobLedgerEntry.CHANGECOMPANY(Company.Name);
//         JobLedgerEntry.SETFILTER("Source No.", '<>%1', '');
//         JobLedgerEntry.SETFILTER("Source Name", '=%1', '');
//         if (JobLedgerEntry.FINDSET) then
//             repeat
//                 if (JobLedgerEntry."Source No." <> '') and (JobLedgerEntry."Source Name" = '') then begin
//                     if JobLedgerEntry."Source Type" = JobLedgerEntry."Source Type"::Customer then begin
//                         if Customer.GET(JobLedgerEntry."Source No.") then begin
//                             JobLedgerEntry."Source Name" := Customer.Name;
//                             JobLedgerEntry.MODIFY(FALSE);
//                         end;
//                     end else if JobLedgerEntry."Source Type" = JobLedgerEntry."Source Type"::Vendor then begin
//                         if Vendor.GET(JobLedgerEntry."Source No.") then begin
//                             JobLedgerEntry."Source Name" := Vendor.Name;
//                             JobLedgerEntry.MODIFY(FALSE);
//                         end;
//                     end;
//                 end;
//             until JobLedgerEntry.NEXT = 0;

//         SetDialog(3, 'Activos');

//         FixedAsset.RESET;
//         FixedAsset.CHANGECOMPANY(Company.Name);

//         FADepreciationBook.RESET;
//         FADepreciationBook.CHANGECOMPANY(Company.Name);
//         if (FADepreciationBook.FINDSET) then
//             repeat
//                 if (FADepreciationBook."OLD_Asset Allocation Job" <> '') then begin
//                     if (FixedAsset.GET(FADepreciationBook."FA No.")) then begin
//                         FixedAsset."Asset Allocation Job" := FADepreciationBook."OLD_Asset Allocation Job";
//                         FixedAsset."Piecework Code" := FADepreciationBook."OLD_Piecework Code";
//                         FixedAsset.MODIFY(FALSE);
//                     end;
//                 end;
//             until FADepreciationBook.NEXT = 0;
//     end;

//     LOCAL procedure AddPermissions()
//     var
//         //       i@1100286000 :
//         i: Integer;
//     begin
//         ///////////////////////////////////////////////////////////////////////////////// A¤adir permisos para objetos nuevos
//         if (Presented) then
//             SetDialog(3, 'Permisos');

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 168
//         AddPermission(TOB::Table, 7206994);

//         //A¤adimos permisos para nuevos objetos desde la versi¢n 1.10.13 en QB_BASE
//         AddPermission(TOB::Table, 7174390);
//         AddPermission(TOB::Table, 7174390);
//         AddPermission(TOB::Table, 7174391);
//         AddPermission(TOB::Table, 7174392);
//         AddPermission(TOB::Table, 7174393);
//         AddPermission(TOB::Table, 7174394);
//         AddPermission(TOB::Table, 7174395);
//         AddPermission(TOB::Table, 7206984);
//         AddPermission(TOB::Table, 7206985);
//         AddPermission(TOB::Table, 7206986);
//         AddPermission(TOB::Table, 7206987);
//         AddPermission(TOB::Table, 7206988);
//         AddPermission(TOB::Table, 7206989);
//         AddPermission(TOB::Table, 7206990);
//         AddPermission(TOB::Table, 7206991);
//         AddPermission(TOB::Table, 7206992);
//         AddPermission(TOB::Table, 7206993);

//         AddPermission(TOB::Page, 7174390);
//         AddPermission(TOB::Page, 7174391);
//         AddPermission(TOB::Page, 7174392);
//         AddPermission(TOB::Page, 7174393);
//         AddPermission(TOB::Page, 7174394);
//         AddPermission(TOB::Page, 7174395);
//         AddPermission(TOB::Page, 7207025);
//         AddPermission(TOB::Page, 7207030);
//         AddPermission(TOB::Page, 7207031);
//         AddPermission(TOB::Page, 7207032);
//         AddPermission(TOB::Page, 7207036);
//         AddPermission(TOB::Page, 7207037);
//         AddPermission(TOB::Page, 7207038);
//         AddPermission(TOB::Page, 7207039);
//         AddPermission(TOB::Page, 7207040);
//         AddPermission(TOB::Page, 7207041);
//         AddPermission(TOB::Page, 7207042);
//         AddPermission(TOB::Page, 7207043);
//         AddPermission(TOB::Page, 7207044);
//         AddPermission(TOB::Page, 7207045);
//         AddPermission(TOB::Page, 7207046);
//         AddPermission(TOB::Page, 7207047);
//         AddPermission(TOB::Page, 7207200);
//         AddPermission(TOB::Page, 7207201);
//         AddPermission(TOB::Page, 7207202);
//         AddPermission(TOB::Page, 7207203);
//         AddPermission(TOB::Page, 7207204);
//         AddPermission(TOB::Page, 7207205);
//         AddPermission(TOB::Page, 7207206);
//         AddPermission(TOB::Page, 7207207);
//         AddPermission(TOB::Page, 7207208);
//         AddPermission(TOB::Page, 7207209);
//         AddPermission(TOB::Page, 7207210);
//         AddPermission(TOB::Page, 7207211);
//         AddPermission(TOB::Page, 7207212);
//         AddPermission(TOB::Page, 7207213);
//         AddPermission(TOB::Page, 7207214);
//         AddPermission(TOB::Page, 7207215);
//         AddPermission(TOB::Page, 7207216);
//         AddPermission(TOB::Page, 7207217);
//         AddPermission(TOB::Page, 7207218);
//         AddPermission(TOB::Page, 7207219);
//         AddPermission(TOB::Page, 7207220);
//         AddPermission(TOB::Page, 7207221);
//         AddPermission(TOB::Page, 7207222);
//         AddPermission(TOB::Page, 7207223);
//         AddPermission(TOB::Page, 7207224);
//         AddPermission(TOB::Page, 7207225);
//         AddPermission(TOB::Page, 7207226);
//         AddPermission(TOB::Page, 7207227);
//         AddPermission(TOB::Page, 7207228);
//         AddPermission(TOB::Page, 7207229);
//         AddPermission(TOB::Page, 7207230);
//         AddPermission(TOB::Page, 7207231);
//         AddPermission(TOB::Page, 7207232);
//         AddPermission(TOB::Page, 7207233);
//         AddPermission(TOB::Page, 7207234);
//         AddPermission(TOB::Page, 7207235);
//         AddPermission(TOB::Page, 7207236);
//         AddPermission(TOB::Page, 7207237);
//         AddPermission(TOB::Page, 7207238);
//         AddPermission(TOB::Page, 7207239);
//         AddPermission(TOB::Page, 7207240);
//         AddPermission(TOB::Page, 7207241);
//         AddPermission(TOB::Page, 7207242);
//         AddPermission(TOB::Page, 7207243);
//         AddPermission(TOB::Page, 7207244);
//         AddPermission(TOB::Page, 7207245);
//         AddPermission(TOB::Page, 7207246);
//         AddPermission(TOB::Page, 7207247);
//         AddPermission(TOB::Page, 7207248);
//         AddPermission(TOB::Page, 7207249);
//         AddPermission(TOB::Page, 7207250);
//         AddPermission(TOB::Page, 7207251);
//         AddPermission(TOB::Page, 7207252);
//         AddPermission(TOB::Page, 7207253);
//         AddPermission(TOB::Page, 7207254);
//         AddPermission(TOB::Page, 7207255);
//         AddPermission(TOB::Page, 7207256);
//         AddPermission(TOB::Page, 7207257);
//         AddPermission(TOB::Page, 7207258);
//         AddPermission(TOB::Page, 7207259);
//         AddPermission(TOB::Page, 7207260);

//         AddPermission(TOB::Codeunit, 7174368);
//         AddPermission(TOB::Codeunit, 7206931);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 170
//         AddPermission(TOB::Codeunit, 7207344);
//         AddPermission(TOB::Codeunit, 7206929);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 181
//         AddPermission(TOB::Table, 7174388);
//         AddPermission(TOB::Table, 7174389);
//         AddPermission(TOB::Table, 7206994);
//         AddPermission(TOB::Table, 7206995);
//         AddPermission(TOB::Table, 7206996);
//         AddPermission(TOB::Table, 7206997);
//         AddPermission(TOB::Table, 7238195);
//         AddPermission(TOB::Table, 7238198);
//         AddPermission(TOB::Table, 7238249);
//         AddPermission(TOB::Table, 7238431);
//         AddPermission(TOB::Table, 7238726);
//         AddPermission(TOB::Table, 7238728);
//         AddPermission(TOB::Table, 7238753);
//         AddPermission(TOB::Page, 7174389);
//         AddPermission(TOB::Page, 7174396);
//         AddPermission(TOB::Page, 7207026);
//         AddPermission(TOB::Page, 7207027);
//         AddPermission(TOB::Page, 7207033);
//         AddPermission(TOB::Page, 7207093);
//         AddPermission(TOB::Page, 7219739);
//         AddPermission(TOB::Page, 7219749);
//         AddPermission(TOB::Report, 7207458);
//         AddPermission(TOB::Report, 7238281);
//         AddPermission(TOB::Codeunit, 7174369);
//         AddPermission(TOB::Codeunit, 7238197);
//         AddPermission(TOB::Codeunit, 7206983);

//         FOR i := 7207180 TO 7207328 DO
//             AddPermission(TOB::Page, i);

//         FOR i := 7206920 TO 7206972 DO
//             AddPermission(TOB::Query, i);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 186
//         AddPermission(TOB::Page, 7207034);
//         AddPermission(TOB::Page, 7207035);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 187
//         AddPermission(TOB::Table, 7206998);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 193
//         AddPermission(TOB::Table, 7207002);
//         AddPermission(TOB::Page, 7207355);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 196
//         AddPermission(TOB::Report, 7207460);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 197
//         AddPermission(TOB::Table, 7174351);
//         AddPermission(TOB::Table, 7206999);
//         AddPermission(TOB::Report, 7174340);
//         AddPermission(TOB::Report, 7174341);
//         AddPermission(TOB::Codeunit, 7174414);
//         AddPermission(TOB::Codeunit, 7206985);
//         AddPermission(TOB::Page, 7174351);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 200
//         AddPermission(TOB::Report, 7207460);
//         AddPermission(TOB::Codeunit, 7238194);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 201
//         AddPermission(TOB::Report, 7207461);
//         AddPermission(TOB::Report, 7207462);
//         AddPermission(TOB::Page, 7207028);

//         ///////////////////////////////////////////////////////////////////////////////// Para la versi¢n global 203
//         AddPermission(TOB::Codeunit, 7206932);
//     end;

//     /*begin
//     end.
//   */

// }




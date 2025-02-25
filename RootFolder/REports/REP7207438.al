// report 7207438 "QB Imprimir Pagare Matricial"
// {


//     Permissions = TableData 270 = m;
//     CaptionML = ENU = 'Check', ESP = 'Imprimir Pagare Matricial';
//     ProcessingOnly = true;
//     UseRequestPage = false;

//     dataset
//     {

//         DataItem("QB Crear Efectos Linea"; "QB Crear Efectos Linea")
//         {

//             DataItemTableView = SORTING("Relacion No.", "Line No.");

//             ;
//             trigger OnPreDataItem();
//             BEGIN
//                 IF "QB Crear Efectos Linea".COUNT = 0 THEN
//                     ERROR(Text004);

//                 //Preparar el fichero
//                 ToFile := 'Pagare.txt';
//                 ExternalFile := TEMPORARYPATH + ToFile;
//                 OutFile.TEXTMODE := TRUE;
//                 OutFile.WRITEMODE := TRUE;
//                 OutFile.CREATE(ExternalFile, TEXTENCODING::Windows);
//             END;

//             trigger OnAfterGetRecord();
//             BEGIN
//                 CompanyInfo.GET;
//                 QBCrearEfectosCabecera.GET("QB Crear Efectos Linea"."Relacion No.");
//                 BankAccount.GET(QBCrearEfectosCabecera."Bank Account No.");
//                 BankAccount.TESTFIELD(Blocked, FALSE);
//                 IF (BankAccount."Currency Code" <> '') THEN BEGIN
//                     CurrencyName := BankAccount."Currency Code";
//                     CurrencySign := '$';

//                     ;
//                 END ELSE BEGIN
//                     CurrencyName := 'EUROS';
//                     CurrencySign := '°';
//                 END;

//                 "QB Crear Efectos Linea".RESET;
//                 "QB Crear Efectos Linea".SETRANGE("Relacion No.", QBCrearEfectosCabecera."Relacion No.");

//                 IF (opcReprintChecks <> '') THEN
//                     "QB Crear Efectos Linea".SETRANGE("No. Pagare", opcReprintChecks)
//                 ELSE
//                     "QB Crear Efectos Linea".SETRANGE(Printed, FALSE);


//                 //A¤adir el pagar‚
//                 MountOneCheck(OutFile);

//                 Printed := TRUE;
//                 MODIFY(TRUE);
//             END;

//             trigger OnPostDataItem();
//             BEGIN
//                 //Cerrar el fichero y copiarlo a la impresora
//                 OutFile.CLOSE;

//                 Comando := 'cmd /C COPY /B "' + ExternalFile + '" "' + BankAccount."Imp Impresora" + '" /Y';
//                 cmdver := 0;
//                 cmdEsperar := FALSE;
//                 //Verify Automation and EVENT
//                 // CREATE(WshSell, FALSE, TRUE);
//                 // WshSell.Run(Comando, cmdver, cmdEsperar);
//                 //END of verify
//                 //MESSAGE(Comando);
//             END;


//         }
//     }
//     requestpage
//     {
//         SaveValues = true;
//         layout
//         {
//             area(content)
//             {
//                 group("group918")
//                 {

//                     CaptionML = ENU = 'Options', ESP = 'Opciones';

//                 }
//             }
//         }
//     }
//     labels
//     {
//     }

//     var
//         //       CompanyInfo@1100286012 :
//         CompanyInfo: Record 79;
//         //       QBCrearEfectosCabecera@1072 :
//         QBCrearEfectosCabecera: Record 7206922;
//         //       BankAccount@1100286005 :
//         BankAccount: Record 270;
//         //       Text004@1100286015 :
//         Text004: TextConst ESP = 'Nada que imprimir';
//         //       ChangeNotInLetters@1100286021 :
//         ChangeNotInLetters: Codeunit 7207289;
//         //       WshSell@1100286006 :
//         //Verify Automation and EVENT
//         //WshSell: Automation "Windows Script Host Object Model".WshShell;
//         //       Comando@1100286007 :
//         Comando: Text;
//         //       cmdver@1100286008 :
//         cmdver: Integer;
//         //       cmdEsperar@1100286009 :
//         cmdEsperar: Boolean;
//         //       CurrencyName@1100286014 :
//         CurrencyName: Text;
//         //       CurrencySign@1100286013 :
//         CurrencySign: Text;
//         //       opcRelacion@1100286010 :
//         opcRelacion: Integer;
//         //       opcReprintChecks@1100286011 :
//         opcReprintChecks: Code[20];
//         //       ToFile@1100286020 :
//         ToFile: Text;
//         //       ExternalFile@1100286019 :
//         ExternalFile: Text;
//         //       OutFile@1100286018 :
//         OutFile: File;
//         //       Lineas@1100286017 :
//         Lineas: ARRAY[30] OF Text[80];
//         //       CheckNoText@1100286016 :
//         CheckNoText: Text[30];
//         //       CheckDateText@1100286004 :
//         CheckDateText: Text[30];
//         //       CheckAmountText@1100286003 :
//         CheckAmountText: Text[30];
//         //       AmountText@1100286002 :
//         AmountText: Text[30];
//         //       AmountLines@1100286001 :
//         AmountLines: ARRAY[2] OF Text[80];
//         //       VoidText@1100286000 :
//         VoidText: Text;

//     //     LOCAL procedure MountOneCheck (var OutFile@1100286007 :
//     LOCAL procedure MountOneCheck(var OutFile: File)
//     var
//         //       Vendor@1100286001 :
//         Vendor: Record 23;
//         //       i@1100286004 :
//         i: Integer;
//         //       Lineas@1100286002 :
//         Lineas: ARRAY[30] OF Text[80];
//     begin
//         Vendor.GET("QB Crear Efectos Linea"."Vendor No.");

//         TextNo(AmountText, BankAccount."Imp Importe Lon", "QB Crear Efectos Linea".Amount, CurrencySign);
//         ChangeNotInLetters.Decimal2TextTwoLines(AmountLines[1], AmountLines[2], MAXSTRLEN(AmountLines[1]), "QB Crear Efectos Linea".Amount, FALSE, CurrencyName, 0);

//         AmountLines[1] := '---' + DELCHR(AmountLines[1], '>');
//         AmountLines[2] := DELCHR(AmountLines[2], '>');

//         if (AmountLines[2] = '') then begin
//             AmountLines[1] += PADSTR('', BankAccount."Imp Letras1 Lon" - STRLEN(AmountLines[1]), '-');
//             AmountLines[2] := PADSTR('', BankAccount."Imp Letras2 Lon", '-');
//         end else begin
//             AmountLines[1] += PADSTR('', BankAccount."Imp Letras1 Lon" - STRLEN(AmountLines[1]), '_');
//             AmountLines[2] := '__' + AmountLines[2] + PADSTR('', BankAccount."Imp Letras2 Lon" - STRLEN(AmountLines[2]) - 2, '-');
//         end;

//         CLEAR(Lineas);
//         FOR i := 1 TO BankAccount."Imp Lineas" DO
//             Lineas[i] := PADSTR('', 80, ' ');

//         if ("QB Crear Efectos Linea"."Due Date" <> 0D) then begin
//             AddToCheck(Lineas[BankAccount."Imp Vto Lin"], FORMAT("QB Crear Efectos Linea"."Due Date", 0, '<Day,2>'), BankAccount."Imp Vto Dia Col", 0);
//             AddToCheck(Lineas[BankAccount."Imp Vto Lin"], FORMAT("QB Crear Efectos Linea"."Due Date", 0, '<Month,2>'), BankAccount."Imp Vto Mes Col", 0);
//             AddToCheck(Lineas[BankAccount."Imp Vto Lin"], FORMAT("QB Crear Efectos Linea"."Due Date", 0, '<Year4>'), BankAccount."Imp Vto AÂ¤o Col", 0);
//         end;

//         AddToCheck(Lineas[BankAccount."Imp Importe Lin"], AmountText, BankAccount."Imp Importe Col", 0);
//         AddToCheck(Lineas[BankAccount."Imp Letras1 Lin"], AmountLines[1], BankAccount."Imp Letras1 Col", BankAccount."Imp Letras1 Lon");
//         AddToCheck(Lineas[BankAccount."Imp Letras2 Lin"], AmountLines[2], BankAccount."Imp Letras2 Col", BankAccount."Imp Letras2 Lon");
//         AddToCheck(Lineas[BankAccount."Imp Destinatario Lin"], Vendor.Name + ' ' + Vendor."Name 2", BankAccount."Imp Destinatario Col", BankAccount."Imp Destinatario Lon");
//         AddToCheck(Lineas[BankAccount."Imp Firma Lin"], CompanyInfo.City, BankAccount."Imp Firma Lugar Col", BankAccount."Imp Firma Lugar Lon");
//         AddToCheck(Lineas[BankAccount."Imp Firma Lin"], FORMAT(QBCrearEfectosCabecera."Posting Date", 0, '<Day>'), BankAccount."Imp Firma Dia Col", 0);
//         AddToCheck(Lineas[BankAccount."Imp Firma Lin"], FORMAT(QBCrearEfectosCabecera."Posting Date", 0, '<Month Text>'), BankAccount."Imp Firma Mes Col", 0);
//         AddToCheck(Lineas[BankAccount."Imp Firma Lin"], FORMAT(QBCrearEfectosCabecera."Posting Date", 0, '<Year4>'), BankAccount."Imp Firma AÂ¤o Col", 0);

//         FOR i := 1 TO BankAccount."Imp Lineas" DO
//             OutFile.WRITE(Lineas[i]);
//     end;

//     //     LOCAL procedure AddToCheck (var Linea@1100286004 : Text;String@1100286003 : Text;Col@1100286001 : Integer;Lon@1100286002 :
//     LOCAL procedure AddToCheck(var Linea: Text; String: Text; Col: Integer; Lon: Integer)
//     begin
//         if (Lon = 0) then
//             Lon := STRLEN(String);
//         Linea := COPYSTR(Linea, 1, Col - 1) + COPYSTR(String, 1, Lon) + COPYSTR(Linea, Col + Lon + 1);
//     end;

//     //     LOCAL procedure TextNo (var AmText@1100286012 : Text[30];Lon@1100286014 : Integer;No@1001 : Decimal;CurrencySign@1100286000 :
//     LOCAL procedure TextNo(var AmText: Text[30]; Lon: Integer; No: Decimal; CurrencySign: Text)
//     var
//         //       Entero@1005 :
//         Entero: Text;
//         //       Decimal@1006 :
//         Decimal: Text;
//     begin
//         AmText := FORMAT(No, 0, '<Integer Thousand><Decimals,3>') + CurrencySign;
//         AmText := PADSTR('', Lon - STRLEN(AmText) - 3, '+') + AmText + '+++';
//     end;


//     //     procedure InitializeRequest (parRelacion@7001101 : Integer;parReprint@7001100 :
//     procedure InitializeRequest(parRelacion: Integer; parReprint: Code[20])
//     begin
//         opcRelacion := parRelacion;
//         opcReprintChecks := parReprint;
//     end;

//     /*begin
//     //{
// //      JAV 16/11/21: - QB 1.09.27 Se cambia la funci¢n de n£mero a letras por la est ndar
// //    }
//     end.
//   */

// }




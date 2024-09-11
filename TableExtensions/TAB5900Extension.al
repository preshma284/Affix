tableextension 50202 "QBU Service HeaderExt" extends "Service Header"
{
  
  /*
Permissions=TableData 5914 d,
                TableData 5950 rimd;
*/DataCaptionFields="No.","Name","Description";
    CaptionML=ENU='Service Header',ESP='Cab. servicio';
    LookupPageID="Service List";
    DrillDownPageID="Service List";
  
  fields
{
}
  keys
{
   // key(key1;"Document Type","No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"No.","Document Type")
  //  {
       /* ;
 */
   // }
   // key(key3;"Customer No.","Order Date")
  //  {
       /* ;
 */
   // }
   // key(key4;"Contract No.","Status","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key5;"Status","Response Date","Response Time","Priority","Responsibility Center")
  //  {
       /* ;
 */
   // }
   // key(key6;"Status","Priority","Response Date","Response Time")
  //  {
       /* ;
 */
   // }
   // key(key7;"Document Type","Customer No.","Order Date")
  //  {
       /* MaintainSQLIndex=false;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Document Type","No.","Customer No.","Posting Date","Status")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: 
// "%1=User management service filter;"
TextConst ENU='You cannot delete this document. Your identification is set up to process from Responsibility Center %1 only.',ESP='No puede borrar este documento. Su identificaci�n est� configurada solo para procesamientos desde el Centro responsabilidad %1.';
//       Text001@1001 :
      Text001: TextConst ENU='Changing %1 in service header %2 will not update the existing service lines.\You must update the existing service lines manually.',ESP='Cambiar %1 en la cabecera de servicio %2 no actualizar� las l�neas de servicio actuales.\Debe actualizar manualmente las l�neas de servicio existentes.';
//       Text003@1003 :
      Text003: 
// "%1=Customer number field caption;%2=Document type;%3=Number field caption;%4=Number;%5=Contract number field caption;%6=Contract number; "
TextConst ENU='You cannot change the %1 because the %2 %3 %4 is associated with a %5 %6.',ESP='No puede cambiar el %1 porque el %2 %3 %4 est� asociado con un %5 %6.';
//       Text004@1004 :
      Text004: TextConst ENU='When you change the %1 the existing Service item line and service line will be deleted.\Do you want to change the %1?',ESP='Si cambia %1, se eliminar�n la l�nea de producto de servicio y la l�nea de servicio.\�Desea cambiar %1?';
//       Text005@1005 :
      Text005: TextConst ENU='Do you want to change the %1?',ESP='�Confirma que desea cambiar el %1?';
//       Text007@1007 :
      Text007: TextConst ENU='%1 cannot be greater than %2.',ESP='%1 no puede ser mayor que %2.';
//       Text008@1008 :
      Text008: 
// "%1=Document type format;%2=Number field caption;%3=Number;"
TextConst ENU='You cannot create Service %1 with %2=%3 because this number has already been used in the system.',ESP='No puede crear el tipo de documento %1 con %2=%3 porque este n�mero ya se utiliz� en el sistema.';
//       Text010@1010 :
      Text010: 
// "%1=Resposibility center table caption;%2=User management service filter;"
TextConst ENU='Your identification is set up to process from %1 %2 only.',ESP='Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
//       Text011@1011 :
      Text011: TextConst ENU='%1 cannot be greater than %2 in the %3 table.',ESP='En la tabla %3, %1 no puede ser mayor que %2.';
//       Text012@1012 :
      Text012: TextConst ENU='if you change %1, the existing service lines will be deleted and the program will create new service lines based on the new information on the header.\Do you want to change the %1?',ESP='Si cambia %1, se eliminar�n las l�neas de servicio existentes y el programa crear� nuevas l�neas seg�n la nueva informaci�n en la cabecera.\�Desea cambiar %1?';
//       Text013@1089 :
      Text013: TextConst ENU='Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?',ESP='Si elimina el documento, se provocar� una discontinuidad en la serie num�rica de abonos registrados. Se crear� un abono registrado en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
//       Text015@1015 :
      Text015: TextConst ENU='Do you want to update the exchange rate?',ESP='�Confirma que desea modificar el tipo de cambio?';
//       Text016@1016 :
      Text016: TextConst ENU='You have modified %1.\Do you want to update the service lines?',ESP='Ha modificado %1.\�Desea actualizar las l�neas de servicio?';
//       Text018@1018 :
      Text018: 
// "%1=Service order type field caption;%2=table caption;%3=Document type field caption;%4=Document type format;%5=Number field caption;%6=Number format;"
TextConst ENU='You have not specified the %1 for %2 %3=%4, %5=%6.',ESP='No ha especificado el %1 para %2 %3=%4, %5=%6.';
//       Text019@1019 :
      Text019: TextConst ENU='You have changed %1 on the service header, but it has not been changed on the existing service lines.\The change may affect the exchange rate used in the price calculation of the service lines.',ESP='Ha cambiado %1 en la cabecera de servicio, pero no se cambi� en las l�neas de servicio existentes.\El cambio puede afectar al tipo de cambio que se usa en el c�lculo de precio de las l�neas de servicio.';
//       Text021@1021 :
      Text021: TextConst ENU='You have changed %1 on the %2, but it has not been changed on the existing service lines.\You must update the existing service lines manually.',ESP='Ha modificado %1 en %2, pero no se cambi� en las l�neas de servicio existentes.\Debe actualizar manualmente las l�neas de servicio existentes.';
//       ServSetup@1023 :
      ServSetup: Record 5911;
//       Cust@1024 :
      Cust: Record 18;
//       ServHeader@1025 :
      ServHeader: Record 5900;
//       ServLine@1026 :
      ServLine: Record 5902;
//       ServItemLine@1027 :
      ServItemLine: Record 5901;
//       PostCode@1031 :
      PostCode: Record 225;
//       CurrExchRate@1033 :
      CurrExchRate: Record 330;
//       GLSetup@1034 :
      GLSetup: Record 98;
//       ServShptHeader@1085 :
      ServShptHeader: Record 5990;
//       ServInvHeader@1084 :
      ServInvHeader: Record 5992;
//       ServCrMemoHeader@1077 :
      ServCrMemoHeader: Record 5994;
//       ReservEntry@1076 :
      ReservEntry: Record 337;
//       TempReservEntry@1075 :
      TempReservEntry: Record 337 TEMPORARY;
//       Salesperson@1906 :
      Salesperson: Record 13;
//       ServOrderMgt@1037 :
      ServOrderMgt: Codeunit 5900;
//       DimMgt@1038 :
      DimMgt: Codeunit 408;
//       NoSeriesMgt@1039 :
      NoSeriesMgt: Codeunit 396;
//       ServLogMgt@1040 :
      ServLogMgt: Codeunit 5906;
//       UserSetupMgt@1043 :
      UserSetupMgt: Codeunit 5700;
//       NotifyCust@1044 :
      NotifyCust: Codeunit 5915;
//       ServPost@1101 :
      ServPost: Codeunit 5980;
//       CurrencyDate@1046 :
      CurrencyDate: Date;
//       TempLinkToServItem@1047 :
      TempLinkToServItem: Boolean;
//       HideValidationDialog@1048 :
      HideValidationDialog: Boolean;
//       Text024@1002 :
      Text024: TextConst ENU='The %1 cannot be greater than the minimum %1 of the\ Service Item Lines.',ESP='La %1 no puede ser mayor que la %1 m�nima de las\ l�ns. prod. servicio.';
//       Text025@1050 :
      Text025: TextConst ENU='The %1 cannot be less than the maximum %1 of the related\ Service Item Lines.',ESP='La %1 no puede ser menor que la %1 m�xima de las\ l�ns. prod. servicio relacionadas.';
//       Text026@1051 :
      Text026: TextConst ENU='%1 cannot be earlier than the %2.',ESP='La %1 no puede ser anterior a la %2.';
//       Text027@1052 :
      Text027: TextConst ENU='The %1 cannot be greater than the minimum %2 of the related\ Service Item Lines.',ESP='La %1 no puede ser mayor que la %2 m�nima de las \ l�ns. prod. servicio relacionadas';
//       ValidatingFromLines@1053 :
      ValidatingFromLines: Boolean;
//       LinesExist@1054 :
      LinesExist: Boolean;
//       Text028@1057 :
      Text028: TextConst ENU='You cannot change the %1 because %2 exists.',ESP='No puede cambiar %1 porque hay un %2.';
//       Text029@1056 :
      Text029: TextConst ENU='The %1 field on the %2 will be updated if you change %3 manually.\Do you want to continue?',ESP='El campo %1 en %2 se actualizar� si cambia %3 manualmente.\�Desea continuar?';
//       Text031@1059 :
      Text031: 
// "%1=Status field caption;%2=Status format;%3=table caption;%4=Number;%5=ServItemLine repair status code field caption;%6=ServItemLine repair status code;%7=ServItemLine table caption;%8=ServItemLine line number;"
TextConst ENU='You cannot change %1 to %2 in %3 %4.\\%5 %6 in %7 %8 line is preventing it.',ESP='No puede cambiar el %1 a %2 en la %3 %4.\\El %5 %6 en la l�nea %7 %8 lo impide.';
//       Text037@1060 :
      Text037: 
// "%1=Contact number;%2=Contact name;%3=Customer number;"
TextConst ENU='Contact %1 %2 is not related to customer %3.',ESP='Contacto %1 %2 no est� relacionado con el cliente %3.';
//       Text038@1013 :
      Text038: 
// "%1=Contact number;%2=Contact name;%3=Customer number;"
TextConst ENU='Contact %1 %2 is related to a different company than customer %3.',ESP='Contacto %1 %2 est� relacionado con una empresa diferente al cliente %3.';
//       Text039@1061 :
      Text039: 
// "%1=Contact number;%2=Contact name;"
TextConst ENU='Contact %1 %2 is not related to a customer.',ESP='Contacto %1 %2 no est� relacionado con un cliente.';
//       ContactNo@1045 :
      ContactNo: Code[20];
//       Text040@1063 :
      Text040: 
// "%1=table caption;%2=ServItemLine document number;%3=ServItemLine line number;%4=ServItemLine loaner number field caption;%5=ServItemLine loaner number;"
TextConst ENU='You cannot delete %1 %2 because the %4 %5 for Service Item Line %3 has not been received.',ESP='No puede eliminar la %1 %2 porque el %4 %5 porque el n� %3 de la L�nea producto servicio no se ha recibido.';
//       SkipContact@1064 :
      SkipContact: Boolean;
//       SkipBillToContact@1062 :
      SkipBillToContact: Boolean;
//       Text041@1068 :
      Text041: TextConst ENU='Contract %1 is not signed.',ESP='No est� firmado el contrato %1.';
//       Text042@1069 :
      Text042: TextConst ENU='The service period for contract %1 has not yet started.',ESP='El periodo servicio para contrato %1 todav�a no ha comenzado.';
//       Text043@1070 :
      Text043: TextConst ENU='The service period for contract %1 has expired.',ESP='Ha vencido el periodo servicio para contrato %1.';
//       Text044@1073 :
      Text044: TextConst ENU='You cannot rename a %1.',ESP='No se puede cambiar el nombre a %1.';
//       Confirmed@1080 :
      Confirmed: Boolean;
//       Text045@1083 :
      Text045: 
// "%1=Posting date field caption;%2=Posting number series field caption;%3=Posting number series;%4=NoSeries date order field caption;%5=NoSeries date order;%6=Document type;%7=posting number field caption;%8=Posting number;"
TextConst ENU='You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.',ESP='No puede cambiar el campo %1 porque %2 %3 tiene %4 = %5 y ya se ha asignado el %6 a %7 %8.';
//       Text046@1104 :
      Text046: TextConst ENU='You cannot delete invoice %1 because one or more service ledger entries exist for this invoice.',ESP='No puede borrar la factura %1 porque existen uno o m�s movs. de servicio para esta factura.';
//       Text047@1100 :
      Text047: TextConst ENU='You cannot change %1 because reservation, item tracking, or order tracking exists on the sales order.',ESP='No puede cambiar %1 porque la reserva, el seguimiento de productos o el seguimiento de pedido existe en el pedido de venta.';
//       Text050@1094 :
      Text050: TextConst ENU='You cannot reset %1 because the document still has one or more lines.',ESP='No se puede modificar %1 ya que el documento tiene una o m�s l�neas.';
//       Text051@1082 :
      Text051: 
// "%1=Document type format;%2=Number;"
TextConst ENU='The service %1 %2 already exists.',ESP='El servicio %1 %2 ya existe.';
//       Text053@1093 :
      Text053: TextConst ENU='Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?',ESP='Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de albaranes. Un env�o dev. vac�o %1 se crear� para llenar este error en las series num�ricas.\\�Desea continuar?';
//       Text054@1091 :
      Text054: TextConst ENU='Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?',ESP='Si elimina el documento se provocar� una discontinuidad en la numeraci�n de la serie de facturas registradas. Se crear� una factura registrada en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
//       Text055@1079 :
      Text055: TextConst ENU='You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. Do you want to update the %2 field on the lines to reflect the new value of %1?',ESP='Ha modificado el campo %1. El nuevo c�lculo de IVA puede tener alguna diferencia, por lo que deber�a comprobar los importes. �Desea actualizar el campo %2 en las l�neas para reflejar el nuevo valor de %1?';
//       Text057@1103 :
      Text057: TextConst ENU='When you change the %1 the existing service line will be deleted.\Do you want to change the %1?',ESP='Cuando cambia %1, se eliminar� la l�nea de servicio existente.\�Desea cambiar %1?';
//       Text058@1088 :
      Text058: 
// "%1=Currency code field caption;%2=Document type;%3=Number;%4=Contract number;"
TextConst ENU='You cannot change %1 because %2 %3 is linked to Contract %4.',ESP='No puede cambiar %1 porque %2 %3 est� vinculado al contrato %4.';
//       Text060@1154 :
      Text060: 
// "%1=Assigned user ID;%2=User management service filter assigned user id;"
TextConst ENU='Responsibility Center is set up to process from %1 %2 only.',ESP='El Centro responsabilidad est� configurado para procesar solo desde %1 %2.';
//       Text061@1099 :
      Text061: TextConst ENU='You may have changed a dimension.\\Do you want to update the lines?',ESP='Puede que haya cambiado una dimensi�n.\\�Desea actualizar las l�neas?';
//       Text062@1087 :
      Text062: TextConst ENU='An open inventory pick exists for the %1 and because %2 is %3.\\You must first post or delete the inventory pick or change %2 to Partial.',ESP='Existe un picking inventario abierto para la %1 y porque %2 es %3.\\Primero debe registrar o eliminar el picking inventario o cambiar %2 a Parcial.';
//       Text063@1102 :
      Text063: TextConst ENU='An open warehouse shipment exists for the %1 and %2 is %3.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change %2 to Partial.',ESP='Existe un env�o de almac�n abierto para %1 y %2 es %3.\\Debe agregar los productos como l�neas nuevas en el env�o de almac�n existente o cambiar %2 a Parcial.';
//       Text064@1105 :
      Text064: TextConst ENU='You cannot change %1 to %2 because an open inventory pick on the %3.',ESP='No puede cambiar %1 a %2 debido a un picking de inventario abierto en %3.';
//       Text065@1106 :
      Text065: TextConst ENU='You cannot change %1  to %2 because an open warehouse shipment exists for the %3.',ESP='No puede cambiar %1 a %2 debido a que existe un env�o de almac�n abierto para %3.';
//       Text066@1017 :
      Text066: TextConst ENU='You cannot change the dimension because there are service entries connected to this line.',ESP='No se puede cambiar la dimensi�n porque hay entradas de servicio conectadas a esta l�nea.';
//       PostedDocsToPrintCreatedMsg@1022 :
      PostedDocsToPrintCreatedMsg: TextConst ENU='One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.',ESP='Durante la eliminaci�n, se han generado uno o m�s documentos registrados relacionados en sustituci�n de los n�meros de registro que faltan de la serie. Puede ver o imprimir los documentos del archivo de documentos correspondiente.';
//       DocumentNotPostedClosePageQst@1020 :
      DocumentNotPostedClosePageQst: TextConst ENU='The document has not been posted.\Are you sure you want to exit?',ESP='El documento no se registr�.\�Est� seguro de que desea salir?';
//       MissingExchangeRatesQst@1006 :
      MissingExchangeRatesQst: 
// %1 - currency code, %2 - posting date
TextConst ENU='There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.',ESP='No hay tipos de cambio para la divisa %1 y la fecha %2. �Desea agregarlos ahora? De lo contrario, se revertir� el �ltimo cambio que hizo.';
//       SIIInvoiceTypeNotSupportedMsg@1100000 :
      SIIInvoiceTypeNotSupportedMsg: 
// "%1 = Invoice Type, e.g. R1 Corrected Invoice"
TextConst ENU='%1 is not supported. Please contact your partner to add support.',ESP='%1 no es compatible. P�ngase en contacto con su socio para agregar compatibilidad.';

    
    


/*
trigger OnInsert();    var
//                ServShptHeader@1001 :
               ServShptHeader: Record 5990;
             begin
               ServSetup.GET ;
               if "No." = '' then begin
                 TestNoSeries;
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series",0D,"No.","No. Series");
               end;

               if "Document Type" = "Document Type"::Order then begin
                 ServShptHeader.SETRANGE("Order No.","No.");
                 if not ServShptHeader.ISEMPTY then
                   ERROR(Text008,FORMAT("Document Type"),FIELDCAPTION("No."),"No.");
               end;

               InitRecord;

               CLEAR(ServLogMgt);
               ServLogMgt.ServHeaderCreate(Rec);

               if "Salesperson Code" = '' then
                 SetDefaultSalesperson;

               if GETFILTER("Customer No.") <> '' then begin
                 CLEAR(xRec."Ship-to Code");
                 if GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") then
                   VALIDATE("Customer No.",GETRANGEMIN("Customer No."));
               end;

               if GETFILTER("Contact No.") <> '' then
                 if GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") then
                   VALIDATE("Contact No.",GETRANGEMIN("Contact No."));
             end;


*/

/*
trigger OnModify();    begin
               UpdateServiceOrderChangeLog(xRec);
             end;


*/

/*
trigger OnDelete();    var
//                ServDocRegister@1000 :
               ServDocRegister: Record 5936;
//                ServDocLog@1001 :
               ServDocLog: Record 5912;
//                ServOrderAlloc@1007 :
               ServOrderAlloc: Record 5950;
//                ServCommentLine@1008 :
               ServCommentLine: Record 5906;
//                WhseRequest@1003 :
               WhseRequest: Record 5765;
//                Loaner@1006 :
               Loaner: Record 5913;
//                LoanerEntry@1004 :
               LoanerEntry: Record 5914;
//                ServAllocMgt@1002 :
               ServAllocMgt: Codeunit 5930;
//                ReservMgt@1005 :
               ReservMgt: Codeunit 99000845;
             begin
               if not UserSetupMgt.CheckRespCenter(2,"Responsibility Center") then
                 ERROR(Text000,UserSetupMgt.GetServiceFilter);

               if "Document Type" = "Document Type"::Invoice then begin
                 ServLine.RESET;
                 ServLine.SETRANGE("Document Type",ServLine."Document Type"::Invoice);
                 ServLine.SETRANGE("Document No.","No.");
                 ServLine.SETFILTER("Appl.-to Service Entry",'>%1',0);
                 if not ServLine.ISEMPTY then
                   ERROR(Text046,"No.");
               end;

               ServPost.DeleteHeader(Rec,ServShptHeader,ServInvHeader,ServCrMemoHeader);
               VALIDATE("Applies-to ID",'');

               ServLine.RESET;
               ServLine.LOCKTABLE;

               ReservMgt.DeleteDocumentReservation(DATABASE::"Service Line","Document Type","No.",HideValidationDialog);

               WhseRequest.DeleteRequest(DATABASE::"Service Line","Document Type","No.");

               ServLine.SETRANGE("Document Type","Document Type");
               ServLine.SETRANGE("Document No.","No.");
               ServLine.SuspendStatusCheck(TRUE);
               ServLine.DELETEALL(TRUE);

               ServCommentLine.RESET;
               ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Header");
               ServCommentLine.SETRANGE("Table Subtype","Document Type");
               ServCommentLine.SETRANGE("No.","No.");
               ServCommentLine.DELETEALL;

               ServDocRegister.SETCURRENTKEY("Destination Document Type","Destination Document No.");
               CASE "Document Type" OF
                 "Document Type"::Invoice:
                   begin
                     ServDocRegister.SETRANGE("Destination Document Type",ServDocRegister."Destination Document Type"::Invoice);
                     ServDocRegister.SETRANGE("Destination Document No.","No.");
                     ServDocRegister.DELETEALL;
                   end;
                 "Document Type"::"Credit Memo":
                   begin
                     ServDocRegister.SETRANGE("Destination Document Type",ServDocRegister."Destination Document Type"::"Credit Memo");
                     ServDocRegister.SETRANGE("Destination Document No.","No.");
                     ServDocRegister.DELETEALL;
                   end;
               end;

               ServOrderAlloc.RESET;
               ServOrderAlloc.SETCURRENTKEY("Document Type");
               ServOrderAlloc.SETRANGE("Document Type","Document Type");
               ServOrderAlloc.SETRANGE("Document No.","No.");
               ServOrderAlloc.SETRANGE(Posted,FALSE);
               ServOrderAlloc.DELETEALL;
               ServAllocMgt.SetServOrderAllocStatus(Rec);

               ServItemLine.RESET;
               ServItemLine.SETRANGE("Document Type","Document Type");
               ServItemLine.SETRANGE("Document No.","No.");
               if ServItemLine.FIND('-') then
                 repeat
                   if ServItemLine."Loaner No." <> '' then begin
                     Loaner.GET(ServItemLine."Loaner No.");
                     LoanerEntry.SETRANGE("Document Type","Document Type" + 1);
                     LoanerEntry.SETRANGE("Document No.","No.");
                     LoanerEntry.SETRANGE("Loaner No.",ServItemLine."Loaner No.");
                     LoanerEntry.SETRANGE(Lent,TRUE);
                     if not LoanerEntry.ISEMPTY then
                       ERROR(
                         Text040,
                         TABLECAPTION,
                         ServItemLine."Document No.",
                         ServItemLine."Line No.",
                         ServItemLine.FIELDCAPTION("Loaner No."),
                         ServItemLine."Loaner No.");

                     LoanerEntry.SETRANGE(Lent,TRUE);
                     LoanerEntry.DELETEALL;
                   end;

                   CLEAR(ServLogMgt);
                   ServLogMgt.ServItemOffServOrder(ServItemLine);
                   ServItemLine.DELETE;
                 until ServItemLine.NEXT = 0;

               ServDocLog.RESET;
               ServDocLog.SETRANGE("Document Type","Document Type");
               ServDocLog.SETRANGE("Document No.","No.");
               ServDocLog.DELETEALL;

               ServDocLog.RESET;
               ServDocLog.SETRANGE(Before,"No.");
               ServDocLog.SETFILTER("Document Type",'%1|%2|%3',
                 ServDocLog."Document Type"::Shipment,ServDocLog."Document Type"::"Posted Invoice",
                 ServDocLog."Document Type"::"Posted Credit Memo");
               ServDocLog.DELETEALL;

               if (ServShptHeader."No." <> '') or
                  (ServInvHeader."No." <> '') or
                  (ServCrMemoHeader."No." <> '')
               then
                 MESSAGE(PostedDocsToPrintCreatedMsg);
             end;


*/

/*
trigger OnRename();    begin
               ERROR(Text044,TABLECAPTION);
             end;

*/



// procedure AssistEdit (OldServHeader@1000 :

/*
procedure AssistEdit (OldServHeader: Record 5900) : Boolean;
    var
//       ServHeader2@1001 :
      ServHeader2: Record 5900;
    begin
      WITH ServHeader DO begin
        COPY(Rec);
        ServSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldServHeader."No. Series","No. Series") then begin
          if ("Customer No." = '') and ("Contact No." = '') then
            CheckCreditMaxBeforeInsert(FALSE);

          NoSeriesMgt.SetSeries("No.");
          if ServHeader2.GET("Document Type","No.") then
            ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
          Rec := ServHeader;
          exit(TRUE);
        end;
      end;
    end;
*/


    
//     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20];Type5@1012 : Integer;No5@1011 :
    
/*
procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20];Type5: Integer;No5: Code[20])
    var
//       SourceCodeSetup@1008 :
      SourceCodeSetup: Record 242;
//       ServiceContractHeader@1015 :
      ServiceContractHeader: Record 5965;
//       No@1010 :
      No: ARRAY [10] OF Code[20];
//       TableID@1009 :
      TableID: ARRAY [10] OF Integer;
//       ContractDimensionSetID@1014 :
      ContractDimensionSetID: Integer;
//       OldDimSetID@1013 :
      OldDimSetID: Integer;
    begin
      SourceCodeSetup.GET;

      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      TableID[4] := Type4;
      No[4] := No4;
      TableID[5] := Type5;
      No[5] := No5;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      OldDimSetID := "Dimension Set ID";

      if "Contract No." <> '' then begin
        ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Contract,"Contract No.");
        ContractDimensionSetID := ServiceContractHeader."Dimension Set ID";
      end;

      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Service Management",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",ContractDimensionSetID,DATABASE::"Service Contract Header");

      if ("Dimension Set ID" <> OldDimSetID) and (ServItemLineExists or ServLineExists) then begin
        MODIFY;
        UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      end;
    end;
*/


    
//     procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    
/*
procedure UpdateAllLineDim (NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
//       ConfirmManagement@1003 :
      ConfirmManagement: Codeunit 27;
//       NewDimSetID@1002 :
      NewDimSetID: Integer;
    begin
      // Update all lines with changed dimensions.
      if NewParentDimSetID = OldParentDimSetID then
        exit;
      if not ConfirmManagement.ConfirmProcess(Text061,TRUE) then
        exit;

      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");
      ServLine.LOCKTABLE;
      if ServLine.FIND('-') then
        repeat
          NewDimSetID := DimMgt.GetDeltaDimSetID(ServLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          if ServLine."Dimension Set ID" <> NewDimSetID then begin
            ServLine."Dimension Set ID" := NewDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
              ServLine."Dimension Set ID",ServLine."Shortcut Dimension 1 Code",ServLine."Shortcut Dimension 2 Code");
            ServLine.MODIFY;
          end;
        until ServLine.NEXT = 0;

      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      ServItemLine.LOCKTABLE;
      if ServItemLine.FIND('-') then
        repeat
          NewDimSetID := DimMgt.GetDeltaDimSetID(ServItemLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          if ServItemLine."Dimension Set ID" <> NewDimSetID then begin
            ServItemLine."Dimension Set ID" := NewDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
              ServItemLine."Dimension Set ID",ServItemLine."Shortcut Dimension 1 Code",ServItemLine."Shortcut Dimension 2 Code");
            ServItemLine.MODIFY;
          end;
        until ServItemLine.NEXT = 0;
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
//       OldDimSetID@1002 :
      OldDimSetID: Integer;
    begin
      OldDimSetID := "Dimension Set ID";
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

      if ServItemLineExists or ServLineExists then
        UpdateAllLineDim("Dimension Set ID",OldDimSetID);

      OnAfterValidateShortcutDimCode(Rec,xRec,FieldNumber,ShortcutDimCode);
    end;
*/


    
/*
LOCAL procedure UpdateCurrencyFactor ()
    var
//       UpdateCurrencyExchangeRates@1000 :
      UpdateCurrencyExchangeRates: Codeunit 1281;
//       ConfirmManagement@1001 :
      ConfirmManagement: Codeunit 27;
    begin
      if "Currency Code" <> '' then begin
        CurrencyDate := "Posting Date";
        if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate,"Currency Code") then begin
          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
          if "Currency Code" <> xRec."Currency Code" then
            RecreateServLines(FIELDCAPTION("Currency Code"));
        end else begin
          if ConfirmManagement.ConfirmProcess(
               STRSUBSTNO(MissingExchangeRatesQst,"Currency Code",CurrencyDate),TRUE)
          then begin
            UpdateCurrencyExchangeRates.OpenExchangeRatesPage("Currency Code");
            UpdateCurrencyFactor;
          end else
            RevertCurrencyCodeAndPostingDate;
        end;
      end else begin
        "Currency Factor" := 0;
        if "Currency Code" <> xRec."Currency Code" then
          RecreateServLines(FIELDCAPTION("Currency Code"));
      end;
    end;
*/


//     LOCAL procedure RecreateServLines (ChangedFieldName@1000 :
    
/*
LOCAL procedure RecreateServLines (ChangedFieldName: Text[100])
    var
//       TempServLine@1002 :
      TempServLine: Record 5902 TEMPORARY;
//       ServDocReg@1005 :
      ServDocReg: Record 5936;
//       TempServDocReg@1004 :
      TempServDocReg: Record 5936 TEMPORARY;
//       ConfirmManagement@1001 :
      ConfirmManagement: Codeunit 27;
//       ExtendedTextAdded@1003 :
      ExtendedTextAdded: Boolean;
    begin
      if ServLineExists then begin
        if HideValidationDialog then
          Confirmed := TRUE
        else
          Confirmed :=
            ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text012,ChangedFieldName),TRUE);
        if Confirmed then begin
          ServLine.LOCKTABLE;
          ReservEntry.LOCKTABLE;
          MODIFY;

          ServLine.RESET;
          ServLine.SETRANGE("Document Type","Document Type");
          ServLine.SETRANGE("Document No.","No.");
          if ServLine.FIND('-') then begin
            repeat
              ServLine.TESTFIELD("Quantity Shipped",0);
              ServLine.TESTFIELD("Quantity Invoiced",0);
              ServLine.TESTFIELD("Shipment No.",'');
              TempServLine := ServLine;
              if ServLine.Nonstock then begin
                ServLine.Nonstock := FALSE;
                ServLine.MODIFY;
              end;
              TempServLine.INSERT;
              CopyReservEntryToTemp(ServLine);
            until ServLine.NEXT = 0;

            if "Location Code" <> xRec."Location Code" then
              if not TempReservEntry.ISEMPTY then
                ERROR(Text047,FIELDCAPTION("Location Code"));

            if "Document Type" = "Document Type"::Invoice then begin
              ServDocReg.SETCURRENTKEY("Destination Document Type","Destination Document No.");
              ServDocReg.SETRANGE("Destination Document Type",ServDocReg."Destination Document Type"::Invoice);
              ServDocReg.SETRANGE("Destination Document No.",TempServLine."Document No.");
              if ServDocReg.FIND('-') then
                repeat
                  TempServDocReg := ServDocReg;
                  TempServDocReg.INSERT;
                until ServDocReg.NEXT = 0;
            end;
            ServLine.DELETEALL(TRUE);

            if "Document Type" = "Document Type"::Invoice then begin
              if TempServDocReg.FIND('-') then
                repeat
                  ServDocReg := TempServDocReg;
                  ServDocReg.INSERT;
                until TempServDocReg.NEXT = 0;
            end;

            CreateServiceLines(TempServLine,ExtendedTextAdded);
            TempServLine.SETRANGE(Type);
            TempServLine.DELETEALL;
          end;
        end else
          ERROR('');
      end;
    end;
*/


    
/*
LOCAL procedure ConfirmUpdateCurrencyFactor ()
    var
//       ConfirmManagement@1000 :
      ConfirmManagement: Codeunit 27;
    begin
      if ConfirmManagement.ConfirmProcess(Text015,TRUE) then
        VALIDATE("Currency Factor")
      else
        "Currency Factor" := xRec."Currency Factor";
    end;
*/


//     LOCAL procedure UpdateServLinesByFieldNo (ChangedFieldNo@1000 : Integer;AskQuestion@1001 :
    
/*
LOCAL procedure UpdateServLinesByFieldNo (ChangedFieldNo: Integer;AskQuestion: Boolean)
    var
//       Field@1003 :
      Field: Record 2000000041;
//       ConfirmManagement@1004 :
      ConfirmManagement: Codeunit 27;
//       Question@1002 :
      Question: Text[250];
    begin
      Field.GET(DATABASE::"Service Header",ChangedFieldNo);

      if ServLineExists and AskQuestion then begin
        Question := STRSUBSTNO(
            Text016,
            Field."Field Caption");
        if not ConfirmManagement.ConfirmProcess(Question,TRUE) then
          exit
      end;

      if ServLineExists then begin
        ServLine.LOCKTABLE;
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");

        ServLine.SETRANGE("Quantity Shipped",0);
        ServLine.SETRANGE("Quantity Invoiced",0);
        ServLine.SETRANGE("Quantity Consumed",0);
        ServLine.SETRANGE("Shipment No.",'');

        if ServLine.FIND('-') then
          repeat
            CASE ChangedFieldNo OF
              FIELDNO("Currency Factor"):
                if (ServLine."Posting Date" = "Posting Date") and (ServLine.Type <> ServLine.Type::" ") then begin
                  ServLine.VALIDATE("Unit Price");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Posting Date"):
                begin
                  ServLine.VALIDATE("Posting Date","Posting Date");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Responsibility Center"):
                begin
                  ServLine.VALIDATE("Responsibility Center","Responsibility Center");
                  ServLine.MODIFY(TRUE);
                  ServItemLine.RESET;
                  ServItemLine.SETRANGE("Document Type","Document Type");
                  ServItemLine.SETRANGE("Document No.","No.");
                  if ServItemLine.FIND('-') then
                    repeat
                      ServItemLine.VALIDATE("Responsibility Center","Responsibility Center");
                      ServItemLine.MODIFY(TRUE);
                    until ServItemLine.NEXT = 0;
                end;
              FIELDNO("Order Date"):
                begin
                  ServLine."Order Date" := "Order Date";
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Transaction Type"):
                begin
                  ServLine.VALIDATE("Transaction Type","Transaction Type");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Transport Method"):
                begin
                  ServLine.VALIDATE("Transport Method","Transport Method");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("exit Point"):
                begin
                  ServLine.VALIDATE("exit Point","exit Point");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO(Area):
                begin
                  ServLine.VALIDATE(Area,Area);
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Transaction Specification"):
                begin
                  ServLine.VALIDATE("Transaction Specification","Transaction Specification");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Shipping Agent Code"):
                begin
                  ServLine.VALIDATE("Shipping Agent Code","Shipping Agent Code");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Shipping Time"):
                begin
                  ServLine.VALIDATE("Shipping Time","Shipping Time");
                  ServLine.MODIFY(TRUE);
                end;
              FIELDNO("Shipping Agent Service Code"):
                begin
                  ServLine.VALIDATE("Shipping Agent Service Code","Shipping Agent Service Code");
                  ServLine.MODIFY(TRUE);
                end;
              else
                OnUpdateServLineByChangedFieldName(ServHeader,ServLine,Field."Field Caption");
            end;
          until ServLine.NEXT = 0;
      end;
    end;
*/


    
//     procedure TestMandatoryFields (var PassedServLine@1002 :
    
/*
procedure TestMandatoryFields (var PassedServLine: Record 5902)
    begin
      OnBeforeTestMandatoryFields(Rec,PassedServLine);

      ServSetup.GET;
      CheckMandSalesPersonOrderData(ServSetup);
      PassedServLine.RESET;
      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");

      if PassedServLine.FIND('-') then
        repeat
          if (PassedServLine."Qty. to Ship" <> 0) or
             (PassedServLine."Qty. to Invoice" <> 0) or
             (PassedServLine."Qty. to Consume" <> 0)
          then begin
            if ("Document Type" = "Document Type"::Order) and
               "Link Service to Service Item" and
               (PassedServLine.Type IN [PassedServLine.Type::Item,PassedServLine.Type::Resource])
            then
              PassedServLine.TESTFIELD("Service Item Line No.");

            CASE PassedServLine.Type OF
              PassedServLine.Type::Item:
                begin
                  if ServSetup."Unit of Measure Mandatory" then
                    PassedServLine.TESTFIELD("Unit of Measure Code");
                end;
              PassedServLine.Type::Resource:
                begin
                  if ServSetup."Work Type Code Mandatory" then
                    PassedServLine.TESTFIELD("Work Type Code");
                  if ServSetup."Unit of Measure Mandatory" then
                    PassedServLine.TESTFIELD("Unit of Measure Code");
                end;
              PassedServLine.Type::Cost:
                if ServSetup."Unit of Measure Mandatory" then
                  PassedServLine.TESTFIELD("Unit of Measure Code");
            end;

            if PassedServLine."Job No." <> '' then
              PassedServLine.TESTFIELD("Qty. to Consume",PassedServLine."Qty. to Ship");
          end;
        until PassedServLine.NEXT = 0
      else
        if ServLine.FIND('-') then
          repeat
            if (ServLine."Qty. to Ship" <> 0) or
               (ServLine."Qty. to Invoice" <> 0) or
               (ServLine."Qty. to Consume" <> 0)
            then begin
              if ("Document Type" = "Document Type"::Order) and
                 "Link Service to Service Item" and
                 (ServLine.Type IN [ServLine.Type::Item,ServLine.Type::Resource])
              then
                ServLine.TESTFIELD("Service Item Line No.");

              CASE ServLine.Type OF
                ServLine.Type::Item:
                  begin
                    if ServSetup."Unit of Measure Mandatory" then
                      ServLine.TESTFIELD("Unit of Measure Code");
                  end;
                ServLine.Type::Resource:
                  begin
                    if ServSetup."Work Type Code Mandatory" then
                      ServLine.TESTFIELD("Work Type Code");
                    if ServSetup."Unit of Measure Mandatory" then
                      ServLine.TESTFIELD("Unit of Measure Code");
                  end;
                ServLine.Type::Cost:
                  if ServSetup."Unit of Measure Mandatory" then
                    ServLine.TESTFIELD("Unit of Measure Code");
              end;

              if ServLine."Job No." <> '' then
                ServLine.TESTFIELD("Qty. to Consume",ServLine."Qty. to Ship");
            end;
          until ServLine.NEXT = 0;
    end;
*/


    
    
/*
procedure UpdateResponseDateTime ()
    begin
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Document Type","Document No.","Response Date");
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      if ServItemLine.FIND('-') then begin
        "Response Date" := ServItemLine."Response Date";
        "Response Time" := ServItemLine."Response Time";
        MODIFY(TRUE);
      end;
    end;
*/


    
/*
LOCAL procedure UpdateStartingDateTime ()
    begin
      if ValidatingFromLines then
        exit;
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Document Type","Document No.","Starting Date");
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      ServItemLine.SETFILTER("Starting Date",'<>%1',0D);
      if ServItemLine.FIND('-') then begin
        "Starting Date" := ServItemLine."Starting Date";
        "Starting Time" := ServItemLine."Starting Time";
        MODIFY(TRUE);
      end else begin
        "Starting Date" := 0D;
        "Starting Time" := 0T;
      end;
    end;
*/


    
/*
LOCAL procedure UpdateFinishingDateTime ()
    begin
      if ValidatingFromLines then
        exit;
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Document Type","Document No.","Finishing Date");
      ServItemLine.ASCENDING := FALSE;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      ServItemLine.SETFILTER("Finishing Date",'<>%1',0D);
      if ServItemLine.FIND('-') then begin
        "Finishing Date" := ServItemLine."Finishing Date";
        "Finishing Time" := ServItemLine."Finishing Time";
        MODIFY(TRUE);
      end else begin
        "Finishing Date" := 0D;
        "Finishing Time" := 0T;
      end;
    end;
*/


//     LOCAL procedure PriceMsgIfServLinesExist (ChangedFieldName@1000 :
    
/*
LOCAL procedure PriceMsgIfServLinesExist (ChangedFieldName: Text[100])
    begin
      if ServLineExists then
        MESSAGE(
          Text019,
          ChangedFieldName);
    end;
*/


    
/*
LOCAL procedure ServItemLineExists () : Boolean;
    var
//       ServItemLine@1000 :
      ServItemLine: Record 5901;
    begin
      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      exit(not ServItemLine.ISEMPTY);
    end;
*/


    
    
/*
procedure ServLineExists () : Boolean;
    begin
      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");
      exit(not ServLine.ISEMPTY);
    end;
*/


//     LOCAL procedure MessageIfServLinesExist (ChangedFieldName@1000 :
    
/*
LOCAL procedure MessageIfServLinesExist (ChangedFieldName: Text[100])
    begin
      if ServLineExists and not HideValidationDialog then
        MESSAGE(
          Text021,
          ChangedFieldName,TABLECAPTION);
    end;
*/


    
/*
LOCAL procedure ValidateServPriceGrOnServItem ()
    begin
      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      if ServItemLine.FIND('-') then begin
        ServItemLine.SetServHeader(Rec);
        repeat
          if ServItemLine."Service Price Group Code" <> '' then begin
            ServItemLine.VALIDATE("Service Price Group Code");
            ServItemLine.MODIFY;
          end;
        until ServItemLine.NEXT = 0
      end;
    end;
*/


    
//     procedure SetHideValidationDialog (NewHideValidationDialog@1000 :
    
/*
procedure SetHideValidationDialog (NewHideValidationDialog: Boolean)
    begin
      HideValidationDialog := NewHideValidationDialog;
    end;
*/


    
//     procedure SetValidatingFromLines (NewValidatingFromLines@1000 :
    
/*
procedure SetValidatingFromLines (NewValidatingFromLines: Boolean)
    begin
      ValidatingFromLines := NewValidatingFromLines;
    end;
*/


    
/*
LOCAL procedure TestNoSeries ()
    var
//       IsHandled@1000 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeTestNoSeries(Rec,IsHandled);
      if IsHandled then
        exit;

      CASE "Document Type" OF
        "Document Type"::Quote:
          ServSetup.TESTFIELD("Service Quote Nos.");
        "Document Type"::Order:
          ServSetup.TESTFIELD("Service Order Nos.");
      end;
    end;
*/


    
/*
LOCAL procedure GetNoSeriesCode () : Code[20];
    var
//       NoSeriesCode@1001 :
      NoSeriesCode: Code[20];
//       IsHandled@1000 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeGetNoSeries(Rec,NoSeriesCode,IsHandled);
      if IsHandled then
        exit(NoSeriesCode);

      CASE "Document Type" OF
        "Document Type"::Quote:
          exit(ServSetup."Service Quote Nos.");
        "Document Type"::Order:
          exit(ServSetup."Service Order Nos.");
        "Document Type"::Invoice:
          exit(ServSetup."Service Invoice Nos.");
        "Document Type"::"Credit Memo":
          exit(ServSetup."Service Credit Memo Nos.");
      end;
    end;
*/


    
/*
LOCAL procedure TestNoSeriesManual ()
    var
//       IsHandled@1000 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeTestNoSeriesManual(Rec,IsHandled);
      if IsHandled then
        exit;

      CASE "Document Type" OF
        "Document Type"::Quote:
          NoSeriesMgt.TestManual(ServSetup."Service Quote Nos.");
        "Document Type"::Order:
          NoSeriesMgt.TestManual(ServSetup."Service Order Nos.");
        "Document Type"::Invoice:
          NoSeriesMgt.TestManual(ServSetup."Service Invoice Nos.");
        "Document Type"::"Credit Memo":
          NoSeriesMgt.TestManual(ServSetup."Service Credit Memo Nos.");
      end;
    end;
*/


//     LOCAL procedure UpdateCont (CustomerNo@1000 :
    
/*
LOCAL procedure UpdateCont (CustomerNo: Code[20])
    var
//       ContBusRel@1003 :
      ContBusRel: Record 5054;
//       Cont@1002 :
      Cont: Record 5050;
//       Cust@1004 :
      Cust: Record 18;
    begin
      if Cust.GET(CustomerNo) then begin
        CLEAR(ServOrderMgt);
        ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
        if Cont.GET(ContactNo) then begin
          "Contact No." := Cont."No.";
          "Contact Name" := Cont.Name;
          "Phone No." := Cont."Phone No.";
          "E-Mail" := Cont."E-Mail";
        end else begin
          if Cust."Primary Contact No." <> '' then
            "Contact No." := Cust."Primary Contact No."
          else
            if ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Customer No.") then
              "Contact No." := ContBusRel."Contact No."
            else
              "Contact No." := '';
          "Contact Name" := Cust.Contact;
        end;
      end;
    end;
*/


//     LOCAL procedure UpdateBillToCont (CustomerNo@1000 :
    
/*
LOCAL procedure UpdateBillToCont (CustomerNo: Code[20])
    var
//       ContBusRel@1003 :
      ContBusRel: Record 5054;
//       Cont@1002 :
      Cont: Record 5050;
//       Cust@1001 :
      Cust: Record 18;
    begin
      if Cust.GET(CustomerNo) then begin
        CLEAR(ServOrderMgt);
        ContactNo := ServOrderMgt.FindContactInformation("Bill-to Customer No.");
        if Cont.GET(ContactNo) then begin
          "Bill-to Contact No." := Cont."No.";
          "Bill-to Contact" := Cont.Name;
        end else begin
          if Cust."Primary Contact No." <> '' then
            "Bill-to Contact No." := Cust."Primary Contact No."
          else
            if ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Bill-to Customer No.") then
              "Bill-to Contact No." := ContBusRel."Contact No."
            else
              "Bill-to Contact No." := '';
          "Bill-to Contact" := Cust.Contact;
        end;
      end;
    end;
*/


//     LOCAL procedure UpdateCust (ContactNo@1002 :
    
/*
LOCAL procedure UpdateCust (ContactNo: Code[20])
    var
//       ContBusinessRelation@1007 :
      ContBusinessRelation: Record 5054;
//       Cust@1006 :
      Cust: Record 18;
//       Cont@1005 :
      Cont: Record 5050;
    begin
      if Cont.GET(ContactNo) then begin
        "Contact No." := Cont."No.";
        "Phone No." := Cont."Phone No.";
        "E-Mail" := Cont."E-Mail";
      end else begin
        "Phone No." := '';
        "E-Mail" := '';
        "Contact Name" := '';
        exit;
      end;

      if Cont.Type = Cont.Type::Person then
        "Contact Name" := Cont.Name
      else
        if Cust.GET("Customer No.") then
          "Contact Name" := Cust.Contact
        else
          "Contact Name" := '';

      if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") then begin
        if ("Customer No." <> '') and
           ("Customer No." <> ContBusinessRelation."No.")
        then
          ERROR(Text037,Cont."No.",Cont.Name,"Customer No.");

        if "Customer No." = '' then begin
          SkipContact := TRUE;
          VALIDATE("Customer No.",ContBusinessRelation."No.");
          SkipContact := FALSE;
        end;
      end else
        ERROR(Text039,Cont."No.",Cont.Name);

      if ("Customer No." = "Bill-to Customer No.") or
         ("Bill-to Customer No." = '')
      then
        VALIDATE("Bill-to Contact No.","Contact No.");

      OnAfterUpdateCust(Rec);
    end;
*/


//     LOCAL procedure UpdateBillToCust (ContactNo@1000 :
    
/*
LOCAL procedure UpdateBillToCust (ContactNo: Code[20])
    var
//       ContBusinessRelation@1005 :
      ContBusinessRelation: Record 5054;
//       Cust@1004 :
      Cust: Record 18;
//       Cont@1003 :
      Cont: Record 5050;
    begin
      if Cont.GET(ContactNo) then begin
        "Bill-to Contact No." := Cont."No.";
        if Cont.Type = Cont.Type::Person then
          "Bill-to Contact" := Cont.Name
        else
          if Cust.GET("Bill-to Customer No.") then
            "Bill-to Contact" := Cust.Contact
          else
            "Bill-to Contact" := '';
      end else begin
        "Bill-to Contact" := '';
        exit;
      end;

      if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") then begin
        if "Bill-to Customer No." = '' then begin
          SkipBillToContact := TRUE;
          VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.");
          SkipBillToContact := FALSE;
        end else
          if "Bill-to Customer No." <> ContBusinessRelation."No." then
            ERROR(Text037,Cont."No.",Cont.Name,"Bill-to Customer No.");
      end else
        ERROR(Text039,Cont."No.",Cont.Name);
    end;
*/


    
//     procedure CheckCreditMaxBeforeInsert (HideCreditCheckDialogue@1004 :
    
/*
procedure CheckCreditMaxBeforeInsert (HideCreditCheckDialogue: Boolean)
    var
//       ServHeader@1001 :
      ServHeader: Record 5900;
//       ContBusinessRelation@1002 :
      ContBusinessRelation: Record 5054;
//       Cont@1003 :
      Cont: Record 5050;
//       CustCheckCreditLimit@1000 :
      CustCheckCreditLimit: Codeunit 312;
    begin
      if HideCreditCheckDialogue then
        exit;
      if GETFILTER("Customer No.") <> '' then begin
        if GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") then begin
          ServHeader."Bill-to Customer No." := GETRANGEMIN("Customer No.");
          CustCheckCreditLimit.ServiceHeaderCheck(ServHeader);
        end
      end else
        if GETFILTER("Contact No.") <> '' then
          if GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") then begin
            Cont.GET(GETRANGEMIN("Contact No."));
            if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") then begin
              ServHeader."Bill-to Customer No." := ContBusinessRelation."No.";
              CustCheckCreditLimit.ServiceHeaderCheck(ServHeader);
            end;
          end;
    end;
*/


    
//     procedure UpdateServiceOrderChangeLog (var OldServHeader@1000 :
    
/*
procedure UpdateServiceOrderChangeLog (var OldServHeader: Record 5900)
    begin
      if Status <> OldServHeader.Status then
        ServLogMgt.ServHeaderStatusChange(Rec,OldServHeader);

      if "Customer No." <> OldServHeader."Customer No." then
        ServLogMgt.ServHeaderCustomerChange(Rec,OldServHeader);

      if "Ship-to Code" <> OldServHeader."Ship-to Code" then
        ServLogMgt.ServHeaderShiptoChange(Rec,OldServHeader);

      if "Contract No." <> OldServHeader."Contract No." then
        ServLogMgt.ServHeaderContractNoChanged(Rec,OldServHeader);
    end;
*/


    
/*
LOCAL procedure GetPostingNoSeriesCode () : Code[20];
    begin
      if "Document Type" IN ["Document Type"::"Credit Memo"] then
        exit(ServSetup."Posted Serv. Credit Memo Nos.");
      exit(ServSetup."Posted Service Invoice Nos.");
    end;
*/


    
//     procedure InitRecord ()
//     var
// //       SIIManagement@1100000 :
//       SIIManagement: Codeunit 10756;
//     begin
//       CASE "Document Type" OF
//         "Document Type"::Quote,"Document Type"::Order:
//           begin
//             NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServSetup."Posted Service Invoice Nos.");
//             NoSeriesMgt.SetDefaultSeries("Shipping No. Series",ServSetup."Posted Service Shipment Nos.");
//           end;
//         "Document Type"::Invoice:
//           begin
//             if ("No. Series" <> '') and
//                (ServSetup."Service Invoice Nos." = ServSetup."Posted Service Invoice Nos.")
//             then
//               "Posting No. Series" := "No. Series"
//             else
//               NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServSetup."Posted Service Invoice Nos.");
//             if ServSetup."Shipment on Invoice" then
//               NoSeriesMgt.SetDefaultSeries("Shipping No. Series",ServSetup."Posted Service Shipment Nos.");
//           end;
//         "Document Type"::"Credit Memo":
//           begin
//             if ("No. Series" <> '') and
//                (ServSetup."Service Credit Memo Nos." = ServSetup."Posted Serv. Credit Memo Nos.")
//             then
//               "Posting No. Series" := "No. Series"
//             else
//               NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServSetup."Posted Serv. Credit Memo Nos.");
//           end;
//       end;

//       if "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote]
//       then begin
//         "Order Date" := WORKDATE;
//         "Order Time" := TIME;
//       end;

//       "Posting Date" := WORKDATE;
//       "Document Date" := WORKDATE;
//       "Default Response Time (Hours)" := ServSetup."Default Response Time (Hours)";
//       "Link Service to Service Item" := ServSetup."Link Service to Service Item";

//       if Cust.GET("Customer No.") then
//         VALIDATE("Location Code",UserSetupMgt.GetLocation(2,Cust."Location Code","Responsibility Center"));

//       if "Document Type" IN ["Document Type"::"Credit Memo"] then begin
//         GLSetup.GET;
//         Correction := GLSetup."Mark Cr. Memos as Corrections";
//       end;

//       "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

//       Reserve := Reserve::Optional;

//       if Cust.GET("Customer No.") then
//         if Cust."Responsibility Center" <> '' then
//           "Responsibility Center" := UserSetupMgt.GetRespCenter(2,Cust."Responsibility Center")
//         else
//           "Responsibility Center" := UserSetupMgt.GetRespCenter(2,"Responsibility Center")
//       else
//         "Responsibility Center" := UserSetupMgt.GetServiceFilter;

//       SIIManagement.UpdateSIIInfoInServiceDoc(Rec);
//       OnAfterInitRecord(Rec);
//       InitSii;
//     end;

    
/*
LOCAL procedure InitRecordFromContact ()
    begin
      INIT;
      ServSetup.GET;
      InitRecord;
      "No. Series" := xRec."No. Series";
      if xRec."Shipping No." <> '' then begin
        "Shipping No. Series" := xRec."Shipping No. Series";
        "Shipping No." := xRec."Shipping No.";
      end;
      if xRec."Posting No." <> '' then begin
        "Posting No. Series" := xRec."Posting No. Series";
        "Posting No." := xRec."Posting No.";
      end;
    end;
*/


//     LOCAL procedure GetCust (CustNo@1000 :
    
/*
LOCAL procedure GetCust (CustNo: Code[20])
    begin
      if not (("Document Type" = "Document Type"::Quote) and (CustNo = '')) then begin
        if CustNo <> Cust."No." then
          Cust.GET(CustNo);
      end else
        CLEAR(Cust);
    end;
*/


    
/*
LOCAL procedure ShippedServLinesExist () : Boolean;
    begin
      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");
      ServLine.SETFILTER("Quantity Shipped",'<>0');
      exit(ServLine.FIND('-'));
    end;
*/


    
/*
LOCAL procedure UpdateShipToAddress ()
    var
//       Location@1000 :
      Location: Record 14;
//       CompanyInfo@1001 :
      CompanyInfo: Record 79;
    begin
      if "Document Type" = "Document Type"::"Credit Memo" then begin
        if "Location Code" <> '' then begin
          Location.GET("Location Code");
          SetShipToAddress(
            Location.Name,Location."Name 2",Location.Address,Location."Address 2",
            Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
          "Ship-to Contact" := Location.Contact;
        end else begin
          CompanyInfo.GET;
          "Ship-to Code" := '';
          SetShipToAddress(
            CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
            CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
            CompanyInfo."Ship-to Country/Region Code");
          "Ship-to Contact" := CompanyInfo."Ship-to Contact";
        end;
        "VAT Country/Region Code" := "Country/Region Code";
      end;

      OnAfterUpdateShipToAddress(Rec);
    end;
*/


    
//     procedure SetShipToAddress (ShipToName@1000 : Text[50];ShipToName2@1001 : Text[50];ShipToAddress@1002 : Text[50];ShipToAddress2@1003 : Text[50];ShipToCity@1004 : Text[30];ShipToPostCode@1005 : Code[20];ShipToCounty@1006 : Text[30];ShipToCountryRegionCode@1007 :
    
/*
procedure SetShipToAddress (ShipToName: Text[50];ShipToName2: Text[50];ShipToAddress: Text[50];ShipToAddress2: Text[50];ShipToCity: Text[30];ShipToPostCode: Code[20];ShipToCounty: Text[30];ShipToCountryRegionCode: Code[10])
    begin
      "Ship-to Name" := ShipToName;
      "Ship-to Name 2" := ShipToName2;
      "Ship-to Address" := ShipToAddress;
      "Ship-to Address 2" := ShipToAddress2;
      VALIDATE("Ship-to Country/Region Code",ShipToCountryRegionCode);
      "Ship-to City" := ShipToCity;
      "Ship-to Post Code" := ShipToPostCode;
      "Ship-to County" := ShipToCounty;
    end;
*/


    
    
/*
procedure ConfirmDeletion () : Boolean;
    var
//       ConfirmManagement@1000 :
      ConfirmManagement: Codeunit 27;
    begin
      ServPost.TestDeleteHeader(Rec,ServShptHeader,ServInvHeader,ServCrMemoHeader);
      if ServShptHeader."No." <> '' then
        if not ConfirmManagement.ConfirmProcess(
             STRSUBSTNO(Text053,ServShptHeader."No."),TRUE)
        then
          exit;
      if ServInvHeader."No." <> '' then
        if not ConfirmManagement.ConfirmProcess(
             STRSUBSTNO(Text054,ServInvHeader."No."),TRUE)
        then
          exit;
      if ServCrMemoHeader."No." <> '' then
        if not ConfirmManagement.ConfirmProcess(
             STRSUBSTNO(Text013,ServCrMemoHeader."No."),TRUE)
        then
          exit;
      exit(TRUE);
    end;
*/


//     LOCAL procedure CopyReservEntryToTemp (OldServLine@1001 :
    
/*
LOCAL procedure CopyReservEntryToTemp (OldServLine: Record 5902)
    begin
      ReservEntry.RESET;
      ReservEntry.SetSourceFilter(
        DATABASE::"Service Line",OldServLine."Document Type",OldServLine."Document No.",OldServLine."Line No.",FALSE);
      if ReservEntry.FINDSET then
        repeat
          TempReservEntry := ReservEntry;
          TempReservEntry.INSERT;
        until ReservEntry.NEXT = 0;
      ReservEntry.DELETEALL;
    end;
*/


//     LOCAL procedure CopyReservEntryFromTemp (OldServLine@1001 : Record 5902;NewSourceRefNo@1000 :
    
/*
LOCAL procedure CopyReservEntryFromTemp (OldServLine: Record 5902;NewSourceRefNo: Integer)
    begin
      TempReservEntry.RESET;
      TempReservEntry.SetSourceFilter(
        DATABASE::"Service Line",OldServLine."Document Type",OldServLine."Document No.",OldServLine."Line No.",FALSE);
      if TempReservEntry.FINDSET then
        repeat
          ReservEntry := TempReservEntry;
          ReservEntry."Source Ref. No." := NewSourceRefNo;
          if not ReservEntry.INSERT then;
        until TempReservEntry.NEXT = 0;
      TempReservEntry.DELETEALL;
    end;
*/


    
    
/*
procedure ShowDocDim ()
    var
//       OldDimSetID@1000 :
      OldDimSetID: Integer;
    begin
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      if OldDimSetID <> "Dimension Set ID" then begin
        MODIFY;
        if ServItemLineExists or ServLineExists then
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      end;
    end;
*/


    
//     procedure LookupAdjmtValueEntries (QtyType@1000 :
    
/*
procedure LookupAdjmtValueEntries (QtyType: Option "General","Invoicin")
    var
//       ItemLedgEntry@1004 :
      ItemLedgEntry: Record 32;
//       ServiceLine@1001 :
      ServiceLine: Record 5902;
//       ServiceShptLine@1005 :
      ServiceShptLine: Record 5991;
//       TempValueEntry@1003 :
      TempValueEntry: Record 5802 TEMPORARY;
    begin
      ServiceLine.SETRANGE("Document Type","Document Type");
      ServiceLine.SETRANGE("Document No.","No.");
      TempValueEntry.RESET;
      TempValueEntry.DELETEALL;

      CASE "Document Type" OF
        "Document Type"::Order,"Document Type"::Invoice:
          begin
            if ServiceLine.FINDSET then
              repeat
                if (ServiceLine.Type = ServiceLine.Type::Item) and (ServiceLine.Quantity <> 0) then
                  if ServiceLine."Shipment No." <> '' then begin
                    ServiceShptLine.SETRANGE("Document No.",ServiceLine."Shipment No.");
                    ServiceShptLine.SETRANGE("Line No.",ServiceLine."Shipment Line No.");
                  end else begin
                    ServiceShptLine.SETCURRENTKEY("Order No.","Order Line No.");
                    ServiceShptLine.SETRANGE("Order No.",ServiceLine."Document No.");
                    ServiceShptLine.SETRANGE("Order Line No.",ServiceLine."Line No.");
                  end;
                ServiceShptLine.SETRANGE(Correction,FALSE);
                if QtyType = QtyType::Invoicing then
                  ServiceShptLine.SETFILTER("Qty. Shipped not Invoiced",'<>0');

                if ServiceShptLine.FINDSET then
                  repeat
                    ServiceShptLine.FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                    if ItemLedgEntry.FINDSET then
                      repeat
                        CreateTempAdjmtValueEntries(TempValueEntry,ItemLedgEntry."Entry No.");
                      until ItemLedgEntry.NEXT = 0;
                  until ServiceShptLine.NEXT = 0;
              until ServiceLine.NEXT = 0;
          end;
      end;
      PAGE.RUNMODAL(0,TempValueEntry);
    end;
*/


//     LOCAL procedure CreateTempAdjmtValueEntries (var TempValueEntry@1001 : TEMPORARY Record 5802;ItemLedgEntryNo@1000 :
    
/*
LOCAL procedure CreateTempAdjmtValueEntries (var TempValueEntry: Record 5802 TEMPORARY;ItemLedgEntryNo: Integer)
    var
//       ValueEntry@1002 :
      ValueEntry: Record 5802;
    begin
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      if ValueEntry.FINDSET then
        repeat
          if ValueEntry.Adjustment then begin
            TempValueEntry := ValueEntry;
            if TempValueEntry.INSERT then;
          end;
        until ValueEntry.NEXT = 0;
    end;
*/


    
    
/*
procedure CalcInvDiscForHeader ()
    var
//       ServiceInvDisc@1000 :
      ServiceInvDisc: Codeunit 5950;
    begin
      ServiceInvDisc.CalculateIncDiscForHeader(Rec);
    end;
*/


    
    
/*
procedure SetSecurityFilterOnRespCenter ()
    begin
      if UserSetupMgt.GetServiceFilter <> '' then begin
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetServiceFilter);
        FILTERGROUP(0);
      end;

      SETRANGE("Date Filter",0D,WORKDATE - 1);
    end;
*/


//     LOCAL procedure CheckMandSalesPersonOrderData (ServiceMgtSetup@1000 :
    
/*
LOCAL procedure CheckMandSalesPersonOrderData (ServiceMgtSetup: Record 5911)
    begin
      if ServiceMgtSetup."Salesperson Mandatory" then
        TESTFIELD("Salesperson Code");

      if "Document Type" = "Document Type"::Order then begin
        if ServiceMgtSetup."Service Order Type Mandatory" and ("Service Order Type" = '') then
          ERROR(Text018,
            FIELDCAPTION("Service Order Type"),TABLECAPTION,
            FIELDCAPTION("Document Type"),FORMAT("Document Type"),
            FIELDCAPTION("No."),FORMAT("No."));
        if ServiceMgtSetup."Service Order Start Mandatory" then begin
          TESTFIELD("Starting Date");
          TESTFIELD("Starting Time");
        end;
        if ServiceMgtSetup."Service Order Finish Mandatory" then begin
          TESTFIELD("Finishing Date");
          TESTFIELD("Finishing Time");
        end;
        if ServiceMgtSetup."Fault Reason Code Mandatory" and not ValidatingFromLines then begin
          ServItemLine.RESET;
          ServItemLine.SETRANGE("Document Type","Document Type");
          ServItemLine.SETRANGE("Document No.","No.");
          if ServItemLine.FIND('-') then
            repeat
              ServItemLine.TESTFIELD("Fault Reason Code");
            until ServItemLine.NEXT = 0;
        end;
      end;
    end;
*/


    
//     procedure InventoryPickConflict (DocType@1004 : 'Quote,Order,Invoice,Credit Memo';DocNo@1003 : Code[20];ShippingAdvice@1002 :
    
/*
procedure InventoryPickConflict (DocType: Option "Quote","Order","Invoice","Credit Memo";DocNo: Code[20];ShippingAdvice: Option "Partial","Complet") : Boolean;
    var
//       WarehouseActivityLine@1000 :
      WarehouseActivityLine: Record 5767;
//       ServiceLine@1001 :
      ServiceLine: Record 5902;
    begin
      if ShippingAdvice <> ShippingAdvice::Complete then
        exit(FALSE);
      WarehouseActivityLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.");
      WarehouseActivityLine.SETRANGE("Source Type",DATABASE::"Service Line");
      WarehouseActivityLine.SETRANGE("Source Subtype",DocType);
      WarehouseActivityLine.SETRANGE("Source No.",DocNo);
      if WarehouseActivityLine.ISEMPTY then
        exit(FALSE);
      ServiceLine.SETRANGE("Document Type",DocType);
      ServiceLine.SETRANGE("Document No.",DocNo);
      ServiceLine.SETRANGE(Type,ServiceLine.Type::Item);
      if ServiceLine.ISEMPTY then
        exit(FALSE);
      exit(TRUE);
    end;
*/


    
    
/*
procedure InvPickConflictResolutionTxt () : Text[500];
    begin
      exit(STRSUBSTNO(Text062,TABLECAPTION,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice")));
    end;
*/


    
//     procedure WhseShpmntConflict (DocType@1002 : 'Quote,Order,Invoice,Credit Memo';DocNo@1001 : Code[20];ShippingAdvice@1000 :
    
/*
procedure WhseShpmntConflict (DocType: Option "Quote","Order","Invoice","Credit Memo";DocNo: Code[20];ShippingAdvice: Option "Partial","Complet") : Boolean;
    var
//       WarehouseShipmentLine@1003 :
      WarehouseShipmentLine: Record 7321;
    begin
      if ShippingAdvice <> ShippingAdvice::Complete then
        exit(FALSE);
      WarehouseShipmentLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.");
      WarehouseShipmentLine.SETRANGE("Source Type",DATABASE::"Service Line");
      WarehouseShipmentLine.SETRANGE("Source Subtype",DocType);
      WarehouseShipmentLine.SETRANGE("Source No.",DocNo);
      if WarehouseShipmentLine.ISEMPTY then
        exit(FALSE);
      exit(TRUE);
    end;
*/


    
    
/*
procedure WhseShpmtConflictResolutionTxt () : Text[500];
    begin
      exit(STRSUBSTNO(Text063,TABLECAPTION,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice")));
    end;
*/


//     LOCAL procedure GetShippingTime (CalledByFieldNo@1000 :
    
/*
LOCAL procedure GetShippingTime (CalledByFieldNo: Integer)
    var
//       ShippingAgentServices@1001 :
      ShippingAgentServices: Record 5790;
    begin
      if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
        exit;

      if ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") then
        "Shipping Time" := ShippingAgentServices."Shipping Time"
      else begin
        GetCust("Customer No.");
        "Shipping Time" := Cust."Shipping Time"
      end;
      if not (CalledByFieldNo IN [FIELDNO("Shipping Agent Code"),FIELDNO("Shipping Agent Service Code")]) then
        VALIDATE("Shipping Time");
    end;
*/


    
/*
procedure ValidatePaymentTerms ()
    var
//       PaymentTerms@1100000 :
      PaymentTerms: Record 3;
//       AdjustDueDate@1101100000 :
      AdjustDueDate: Codeunit 10700;
    begin
      GLSetup.GET;
      if ("Document Type" <> "Document Type"::"Credit Memo") or
         (GLSetup."Payment Discount Type" = GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines")
      then
        if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
          PaymentTerms.GET("Payment Terms Code");
          "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
          AdjustDueDate.SalesAdjustDueDate(
            "Due Date","Document Date",PaymentTerms.CalculateMaxDueDate("Document Date"),"Bill-to Customer No.");
          "Pmt. Discount Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
        end else begin
          "Due Date" := "Document Date";
          AdjustDueDate.SalesAdjustDueDate("Due Date","Document Date",12319999D,"Bill-to Customer No.");
          "Pmt. Discount Date" := "Document Date";
        end;
      if ("Document Type" = "Document Type"::"Credit Memo") and ("Payment Terms Code" <> '') then begin
        PaymentTerms.GET("Payment Terms Code");
        if not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
          "Pmt. Discount Date" := 0D;
      end;
    end;
*/


    
/*
LOCAL procedure CheckHeaderDimension ()
    begin
      if ("Contract No." <> '') and ("Document Type" = "Document Type"::Invoice) then
        ERROR(Text066);
    end;
*/


//     LOCAL procedure CreateServiceLines (var TempServLine@1004 : TEMPORARY Record 5902;var ExtendedTextAdded@1000 :
    
/*
LOCAL procedure CreateServiceLines (var TempServLine: Record 5902 TEMPORARY;var ExtendedTextAdded: Boolean)
    var
//       TransferExtendedText@1001 :
      TransferExtendedText: Codeunit 378;
    begin
      ServLine.INIT;
      ServLine."Line No." := 0;
      TempServLine.FIND('-');
      ExtendedTextAdded := FALSE;

      repeat
        if TempServLine."Attached to Line No." = 0 then begin
          ServLine.INIT;
          ServLine.SetHideReplacementDialog(TRUE);
          ServLine.SetHideCostWarning(TRUE);
          ServLine."Line No." := ServLine."Line No." + 10000;
          ServLine.VALIDATE(Type,TempServLine.Type);
          if TempServLine."No." <> '' then begin
            ServLine.VALIDATE("No.",TempServLine."No.");
            if ServLine.Type <> ServLine.Type::" " then begin
              ServLine.VALIDATE("Unit of Measure Code",TempServLine."Unit of Measure Code");
              ServLine.VALIDATE("Variant Code",TempServLine."Variant Code");
              if TempServLine.Quantity <> 0 then
                ServLine.VALIDATE(Quantity,TempServLine.Quantity);
            end;
          end;

          ServLine."Serv. Price Adjmt. Gr. Code" := TempServLine."Serv. Price Adjmt. Gr. Code";
          ServLine."Document No." := TempServLine."Document No.";
          ServLine."Service Item No." := TempServLine."Service Item No.";
          ServLine."Appl.-to Service Entry" := TempServLine."Appl.-to Service Entry";
          ServLine."Service Item Line No." := TempServLine."Service Item Line No.";
          ServLine.VALIDATE(Description,TempServLine.Description);
          ServLine.VALIDATE("Description 2",TempServLine."Description 2");

          if TempServLine."No." <> '' then begin
            TempLinkToServItem := "Link Service to Service Item";
            if "Link Service to Service Item" then begin
              "Link Service to Service Item" := FALSE;
              MODIFY(TRUE);
            end;
            ServLine."Spare Part Action" := TempServLine."Spare Part Action";
            ServLine."Component Line No." := TempServLine."Component Line No.";
            ServLine."Replaced Item No." := TempServLine."Replaced Item No.";
            ServLine.VALIDATE("Work Type Code",TempServLine."Work Type Code");

            ServLine."Location Code" := TempServLine."Location Code";
            if ServLine.Type <> ServLine.Type::" " then begin
              if ServLine.Type = ServLine.Type::Item then begin
                ServLine.VALIDATE("Variant Code",TempServLine."Variant Code");
                if ServLine."Location Code" <> '' then
                  ServLine."Bin Code" := TempServLine."Bin Code";
              end;
              ServLine."Fault Reason Code" := TempServLine."Fault Reason Code";
              ServLine."Exclude Warranty" := TempServLine."Exclude Warranty";
              ServLine."Exclude Contract Discount" := TempServLine."Exclude Contract Discount";
              ServLine.VALIDATE("Contract No.",TempServLine."Contract No.");
              ServLine.VALIDATE(Warranty,TempServLine.Warranty);
            end;
            ServLine."Fault Area Code" := TempServLine."Fault Area Code";
            ServLine."Symptom Code" := TempServLine."Symptom Code";
            ServLine."Resolution Code" := TempServLine."Resolution Code";
            ServLine."Fault Code" := TempServLine."Fault Code";
            ServLine.VALIDATE("Dimension Set ID",TempServLine."Dimension Set ID");
          end;
          "Link Service to Service Item" := TempLinkToServItem;

          OnBeforeInsertServLineOnServLineRecreation(ServLine);
          ServLine.INSERT;
          ExtendedTextAdded := FALSE;
        end else
          if not ExtendedTextAdded then begin
            TransferExtendedText.ServCheckIfAnyExtText(ServLine,TRUE);
            TransferExtendedText.InsertServExtText(ServLine);
            OnAfterTransferExtendedTextForServLineRecreation(ServLine);
            ServLine.FIND('+');
            ExtendedTextAdded := TRUE;
          end;
        CopyReservEntryFromTemp(TempServLine,ServLine."Line No.");
      until TempServLine.NEXT = 0;
    end;
*/


    
    
/*
procedure SetCustomerFromFilter ()
    var
//       CustomerNo@1000 :
      CustomerNo: Code[20];
    begin
      CustomerNo := GetFilterCustNo;
      if CustomerNo = '' then begin
        FILTERGROUP(2);
        CustomerNo := GetFilterCustNo;
        FILTERGROUP(0);
      end;
      if CustomerNo <> '' then
        VALIDATE("Customer No.",CustomerNo);
    end;
*/


    
/*
LOCAL procedure GetFilterCustNo () : Code[20];
    begin
      if GETFILTER("Customer No.") <> '' then
        if GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") then
          exit(GETRANGEMAX("Customer No."));
    end;
*/


//     LOCAL procedure UpdateShipToAddressFromGeneralAddress (FieldNumber@1000 :
    
/*
LOCAL procedure UpdateShipToAddressFromGeneralAddress (FieldNumber: Integer)
    begin
      if ("Ship-to Code" = '') and (not ShipToAddressModified) then
        CASE FieldNumber OF
          FIELDNO("Ship-to Address"):
            if xRec.Address = "Ship-to Address" then
              "Ship-to Address" := Address;
          FIELDNO("Ship-to Address 2"):
            if xRec."Address 2" = "Ship-to Address 2" then
              "Ship-to Address 2" := "Address 2";
          FIELDNO("Ship-to City"), FIELDNO("Ship-to Post Code"):
            begin
              if xRec.City = "Ship-to City" then
                "Ship-to City" := City;
              if xRec."Post Code" = "Ship-to Post Code" then
                "Ship-to Post Code" := "Post Code";
              if xRec.County = "Ship-to County" then
                "Ship-to County" := County;
              if xRec."Country/Region Code" = "Ship-to Country/Region Code" then
                "Ship-to Country/Region Code" := "Country/Region Code";
            end;
          FIELDNO("Ship-to County"):
            if xRec.County = "Ship-to County" then
              "Ship-to County" := County;
          FIELDNO("Ship-to Country/Region Code"):
            if  xRec."Country/Region Code" = "Ship-to Country/Region Code" then
              "Ship-to Country/Region Code" := "Country/Region Code";
        end;
    end;
*/


    
    
/*
procedure CopyCustomerFilter ()
    var
//       CustomerFilter@1000 :
      CustomerFilter: Text;
    begin
      CustomerFilter := GETFILTER("Customer No.");
      if CustomerFilter <> '' then begin
        FILTERGROUP(2);
        SETFILTER("Customer No.",CustomerFilter);
        FILTERGROUP(0)
      end;
    end;
*/


    
/*
LOCAL procedure ShipToAddressModified () : Boolean;
    begin
      if (xRec.Address <> "Ship-to Address") or
         (xRec."Address 2" <> "Ship-to Address 2") or
         (xRec.City <> "Ship-to City") or
         (xRec.County <> "Ship-to County") or
         (xRec."Post Code" <> "Ship-to Post Code") or
         (xRec."Country/Region Code" <> "Ship-to Country/Region Code")
      then
        exit(TRUE);
      exit(FALSE);
    end;
*/


    
    
/*
procedure ConfirmCloseUnposted () : Boolean;
    var
//       InstructionMgt@1000 :
      InstructionMgt: Codeunit 1330;
    begin
      if ServLineExists or ServItemLineExists then
        if InstructionMgt.IsUnpostedEnabledForRecord(Rec) then
          exit(InstructionMgt.ShowConfirm(DocumentNotPostedClosePageQst,InstructionMgt.QueryPostOnCloseCode));
      exit(TRUE)
    end;
*/


    
/*
LOCAL procedure ConfirmChangeContractNo () : Boolean;
    var
//       ServContractLine@1001 :
      ServContractLine: Record 5964;
//       ConfirmManagement@1003 :
      ConfirmManagement: Codeunit 27;
//       Confirmed@1000 :
      Confirmed: Boolean;
//       IsHandled@1002 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeConfirmUpdateContractNo(Rec,IsHandled,Confirmed,HideValidationDialog);
      if IsHandled then
        exit(Confirmed);

      Confirmed :=
        ConfirmManagement.ConfirmProcess(
          STRSUBSTNO(
            Text029,ServContractLine.FIELDCAPTION("Next Planned Service Date"),
            ServContractLine.TABLECAPTION,FIELDCAPTION("Contract No.")),TRUE);

      exit(Confirmed);
    end;
*/


    
/*
LOCAL procedure SetDefaultSalesperson ()
    var
//       UserSetup@1000 :
      UserSetup: Record 91;
    begin
      if not UserSetup.GET(USERID) then
        exit;

      if UserSetup."Salespers./Purch. Code" <> '' then
        VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    end;
*/


//     procedure ValidateSalesPersonOnServiceHeader (ServiceHeader2@1000 : Record 5900;IsTransaction@1001 : Boolean;IsPostAction@1002 :
    
/*
procedure ValidateSalesPersonOnServiceHeader (ServiceHeader2: Record 5900;IsTransaction: Boolean;IsPostAction: Boolean)
    begin
      if ServiceHeader2."Salesperson Code" <> '' then
        if Salesperson.GET(ServiceHeader2."Salesperson Code") then
          if Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) then begin
            if IsTransaction then
              ERROR(Salesperson.GetPrivacyBlockedTransactionText(Salesperson,IsPostAction,TRUE));
            if not IsTransaction then
              ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE));
          end;
    end;
*/


//     LOCAL procedure SetSalespersonCode (SalesPersonCodeToCheck@1000 : Code[20];var SalesPersonCodeToAssign@1001 :
    
/*
LOCAL procedure SetSalespersonCode (SalesPersonCodeToCheck: Code[20];var SalesPersonCodeToAssign: Code[20])
    begin
      if SalesPersonCodeToCheck <> '' then
        if Salesperson.GET(SalesPersonCodeToCheck) then
          if Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) then
            SalesPersonCodeToAssign := ''
          else
            SalesPersonCodeToAssign := SalesPersonCodeToCheck;
    end;
*/


    
/*
LOCAL procedure RevertCurrencyCodeAndPostingDate ()
    begin
      "Currency Code" := xRec."Currency Code";
      "Posting Date" := xRec."Posting Date";
      MODIFY;
    end;
*/


    
//     LOCAL procedure OnAfterInitRecord (var ServiceHeader@1000 :
    
/*
LOCAL procedure OnAfterInitRecord (var ServiceHeader: Record 5900)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateShipToAddress (var ServiceHeader@1000 :
    
/*
LOCAL procedure OnAfterUpdateShipToAddress (var ServiceHeader: Record 5900)
    begin
    end;
*/


    
//     LOCAL procedure OnUpdateServLineByChangedFieldName (ServiceHeader@1000 : Record 5900;var ServiceLine@1001 : Record 5902;ChangedFieldName@1002 :
    
/*
LOCAL procedure OnUpdateServLineByChangedFieldName (ServiceHeader: Record 5900;var ServiceLine: Record 5902;ChangedFieldName: Text[100])
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCreateDimTableIDs (var ServiceHeader@1000 : Record 5900;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :
    
/*
LOCAL procedure OnAfterCreateDimTableIDs (var ServiceHeader: Record 5900;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
    begin
    end;
*/


    
/*
LOCAL procedure InitSii ()
    var
//       GeneralLedgerSetup@1100000 :
      GeneralLedgerSetup: Record 98;
//       SIIManagement@1100001 :
      SIIManagement: Codeunit 10756;
    begin
      GeneralLedgerSetup.GET;
      if GeneralLedgerSetup."VAT Cash Regime" then begin
        "Special Scheme Code" := "Special Scheme Code"::"07 Special Cash";
        exit;
      end;
      if SIIManagement.CountryIsLocal("VAT Country/Region Code") then
        "Special Scheme Code" := "Special Scheme Code"::"01 General"
      else
        "Special Scheme Code" := "Special Scheme Code"::"02 Export";
    end;
*/


    
//     LOCAL procedure OnAfterValidateShortcutDimCode (var ServiceHeader@1000 : Record 5900;xServiceHeader@1001 : Record 5900;FieldNumber@1003 : Integer;var ShortcutDimCode@1002 :
    
/*
LOCAL procedure OnAfterValidateShortcutDimCode (var ServiceHeader: Record 5900;xServiceHeader: Record 5900;FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateCust (var ServiceHeader@1000 :
    
/*
LOCAL procedure OnAfterUpdateCust (var ServiceHeader: Record 5900)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterTransferExtendedTextForServLineRecreation (var ServLine@1001 :
    
/*
LOCAL procedure OnAfterTransferExtendedTextForServLineRecreation (var ServLine: Record 5902)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeConfirmUpdateContractNo (var ServiceHeader@1000 : Record 5900;Confirmed@1001 : Boolean;HideValidationDialog@1002 : Boolean;IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeConfirmUpdateContractNo (var ServiceHeader: Record 5900;Confirmed: Boolean;HideValidationDialog: Boolean;IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeGetNoSeries (var ServiceHeader@1000 : Record 5900;var NoSeriesCode@1001 : Code[20];var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforeGetNoSeries (var ServiceHeader: Record 5900;var NoSeriesCode: Code[20];var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeInsertServLineOnServLineRecreation (var ServiceLine@1000 :
    
/*
LOCAL procedure OnBeforeInsertServLineOnServLineRecreation (var ServiceLine: Record 5902)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeTestMandatoryFields (var ServiceHeader@1000 : Record 5900;var ServiceLine@1001 :
    
/*
LOCAL procedure OnBeforeTestMandatoryFields (var ServiceHeader: Record 5900;var ServiceLine: Record 5902)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeTestNoSeries (var ServiceHeader@1000 : Record 5900;var IsHandled@1001 :
    
/*
LOCAL procedure OnBeforeTestNoSeries (var ServiceHeader: Record 5900;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeTestNoSeriesManual (var ServiceHeader@1001 : Record 5900;var IsHandled@1000 :
    
/*
LOCAL procedure OnBeforeTestNoSeriesManual (var ServiceHeader: Record 5900;var IsHandled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}






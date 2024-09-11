tableextension 50228 "MyExtension50228" extends "Payment Order"
{
  
  /*
Permissions=TableData 7000002 m;
*/
    CaptionML=ENU='Payment Order',ESP='Orden pago';
    LookupPageID="Payment Orders List";
    DrillDownPageID="Payment Orders List";
  
  fields
{
    field(7207270;"QB Department";Code[20])
    {
        TableRelation="QB Department" WHERE ("Type"=CONST("Standard"));
                                                   CaptionML=ENU='Organization Department',ESP='Departamento Organizativo';
                                                   Description='QB 1.07.00 - JAV 26/10/20: - Departamento que lanza la orden de pago  QB 1.10.54 JAV 25/06/22 Se cambia la tabla por la propia de departamentos [TT] Que departamto es el responsable de la Orden de pago, si hay aprobaciones ser  obligatorio indicarlo';


    }
    field(7207271;"Approval Status";Option)
    {
        OptionMembers="Open","Released","Pending Approval";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado Aprobaci¢n';
                                                   OptionCaptionML=ENU='Open,Released,Pending Approval',ESP='Abierto,Lanzado,Aprobaci¢n pendiente';
                                                   
                                                   Description='QB 1.07.00 - JAV 22/10/20: - Estado de aprobaci¢n';
                                                   Editable=false;


    }
    field(7207272;"OLD_Approval Situation";Option)
    {
        OptionMembers="Pending","Approved","Rejected","Withheld";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Situaci¢n de la Aprobaci¢n';
                                                   OptionCaptionML=ESP='Pendiente,Aprobado,Rechazado,Retenido';
                                                   
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207273;"OLD_Approval Coment";Text[80])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario Aprobaci¢n';
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207274;"OLD_Approval Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha aprobaci¢n';
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207290;"Confirming";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Confirming';
                                                   Description='QB 1.06.15 - JAV 21/09/20: Si la orden de pagos es de confirming';


    }
    field(7207291;"Confirming Line";Code[20])
    {
        TableRelation="QB Confirming Lines";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea de confirming';
                                                   Description='QB 1.06.15 - JAV 23/09/20: L¡nea de confirming asociada al banco de la orden de pago';


    }
    field(7207335;"Job No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='No. Proyecto';
                                                   Description='QB 1.00 - JAV 08/03/20: - N£mero del proyecto';
                                                   Editable=false;


    }
    field(7207336;"QB Approval Circuit Code";Code[20])
    {
        TableRelation="QB Approval Circuit Header" WHERE ("Document Type"=CONST("PaymentOrder"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approval Circuit Code',ESP='Circuito de Aprobaci¢n';
                                                   Description='QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci¢n que se utilizar  para este documento';


    }
    field(7238177;"QB Budget item";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Account Type"=FILTER("Unit"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='QPR' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text1100000@1000 :
      Text1100000: TextConst ENU='This Payment Order is not empty. Remove all its bills and invoices and try again.',ESP='La orden de pago no est  vac¡a. Elimine todos sus efectos y facturas e int‚ntelo de nuevo.';
//       Text1100001@1001 :
      Text1100001: TextConst ENU='can only be changed when the %1 is empty',ESP='s¢lo se puede cambiar cuando %1 est  vac¡a';
//       Text1100002@1002 :
      Text1100002: TextConst ENU='The operation is not allowed for payment order using %1. Check your currency setup.',ESP='La operaci¢n no se permite para ord. pago que usan %1. Compruebe la configuraci¢n de la divisa.';
//       Text1100003@1003 :
      Text1100003: TextConst ENU='This payment order has already been printed. Proceed anyway?',ESP='Ya se ha impreso la orden de pago. ¨Confirma que desea continuar?';
//       Text1100004@1004 :
      Text1100004: TextConst ENU='The update has been interrupted by the user.',ESP='La actualizaci¢n se ha interrumpido por el usuario.';
//       Text1100005@1005 :
      Text1100005: TextConst ENU='Payment Order',ESP='Orden pago';
//       Text1100006@1006 :
      Text1100006: TextConst ENU=' is currently in use in a Posted Payment Order.',ESP=' ya ha sido utilizado en una orden pago registrada.';
//       Text1100007@1007 :
      Text1100007: TextConst ENU=' is currently in use in a Closed Payment Order.',ESP=' ya ha sido utilizado en una orden pago cerrada.';
//       Text1100008@1008 :
      Text1100008: TextConst ENU='untitled',ESP='sin t¡tulo';
//       PmtOrd@1100001 :
      PmtOrd: Record 7000020;
//       PostedPmtOrd@1100002 :
      PostedPmtOrd: Record 7000021;
//       ClosedPmtOrd@1100003 :
      ClosedPmtOrd: Record 7000022;
//       Doc@1100004 :
      Doc: Record 7000002;
//       CarteraSetup@1100005 :
      CarteraSetup: Record 7000016;
//       Currency@1100006 :
      Currency: Record 4;
//       BankAcc@1100007 :
      BankAcc: Record 270;
//       BGPOCommentLine@1100008 :
      BGPOCommentLine: Record 7000008;
//       Currencies@1100011 :
      Currencies: Page 5;
//       NoSeriesMgt@1100010 :
      NoSeriesMgt: Codeunit 396;
//       ExportAgainQst@1100000 :
      ExportAgainQst: TextConst ENU='The selected payment order has already been exported. Do you want to export again?',ESP='La orden de pago seleccionada ya se ha exportado. ¨Desea repetir la exportaci¢n?';

    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 CarteraSetup.GET;
                 CarteraSetup.TESTFIELD("Payment Order Nos.");
                 NoSeriesMgt.InitSeries(CarteraSetup."Payment Order Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               if GETFILTER("Bank Account No.") <> '' then
                 if GETRANGEMIN("Bank Account No.") = GETRANGEMAX("Bank Account No.") then begin
                   BankAcc.GET(GETRANGEMIN("Bank Account No."));
                   VALIDATE("Currency Code",BankAcc."Currency Code");
                   VALIDATE("Bank Account No.",BankAcc."No.");
                 end;

               CheckNoNotUsed;
               UpdateDescription;
               "Posting Date" := WORKDATE;
             end;


*/

/*
trigger OnDelete();    begin
               Doc.SETCURRENTKEY(Type,"Bill Gr./Pmt. Order No.");
               Doc.SETRANGE(Type,Doc.Type::Payable);
               Doc.SETRANGE("Bill Gr./Pmt. Order No.","No.");
               if Doc.FINDFIRST then
                 ERROR(Text1100000);

               BGPOCommentLine.SETRANGE("BG/PO No.","No.");
               BGPOCommentLine.DELETEALL;
             end;

*/



// procedure AssistEdit (OldPmtOrd@1100000 :

/*
procedure AssistEdit (OldPmtOrd: Record 7000020) : Boolean;
    begin
      WITH PmtOrd DO begin
        PmtOrd := Rec;
        CarteraSetup.GET;
        CarteraSetup.TESTFIELD("Payment Order Nos.");
        if NoSeriesMgt.SelectSeries(CarteraSetup."Payment Order Nos.",OldPmtOrd."No. Series","No. Series") then begin
          CarteraSetup.GET;
          CarteraSetup.TESTFIELD("Payment Order Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := PmtOrd;
          exit(TRUE);
        end;
      end;
    end;
*/


    
/*
LOCAL procedure CheckPrinted ()
    begin
      if "No. Printed" <> 0 then
        if not CONFIRM(Text1100003) then
          ERROR(Text1100004);
    end;
*/


    
/*
procedure ResetPrinted ()
    begin
      "No. Printed" := 0;
    end;
*/


    
/*
LOCAL procedure UpdateDescription ()
    begin
      "Posting Description" := Text1100005 + ' ' + "No.";
    end;
*/


    
/*
LOCAL procedure CheckNoNotUsed ()
    begin
      if PostedPmtOrd.GET("No.") then
        FIELDERROR("No.",PostedPmtOrd."No." + Text1100006);
      if ClosedPmtOrd.GET("No.") then
        FIELDERROR("No.",ClosedPmtOrd."No." + Text1100007);
    end;
*/


//     procedure PrintRecords (ShowRequestForm@1100000 :
    
/*
procedure PrintRecords (ShowRequestForm: Boolean)
    var
//       CarteraReportSelection@1100001 :
      CarteraReportSelection: Record 7000013;
    begin
      WITH PmtOrd DO begin
        COPY(Rec);
        CarteraReportSelection.SETRANGE(Usage,CarteraReportSelection.Usage::"Payment Order");
        CarteraReportSelection.SETFILTER("Report ID",'<>0');
        CarteraReportSelection.FIND('-');
        repeat
          REPORT.RUNMODAL(CarteraReportSelection."Report ID",ShowRequestForm,FALSE,PmtOrd);
        until CarteraReportSelection.NEXT = 0;
      end;
    end;
*/


    
/*
LOCAL procedure PmtOrdIsEmpty () : Boolean;
    begin
      Doc.SETCURRENTKEY(Type,"Bill Gr./Pmt. Order No.");
      Doc.SETRANGE(Type,Doc.Type::Payable);
      Doc.SETRANGE("Bill Gr./Pmt. Order No.","No.");
      exit(not Doc.FINDFIRST);
    end;
*/


    
/*
procedure Caption () : Text[100];
    begin
      if "No." = '' then
        exit(Text1100008);
      CALCFIELDS("Bank Account Name");
      exit(STRSUBSTNO('%1 %2',"No.","Bank Account Name"));
    end;
*/


//     procedure FilterSourceForExport (var GenJnlLine@1100000 :
    
/*
procedure FilterSourceForExport (var GenJnlLine: Record 81)
    begin
      GenJnlLine.SETRANGE("Journal Template Name",'');
      GenJnlLine.SETRANGE("Journal Batch Name",'');
      GenJnlLine.SETRANGE("Document No.","No.");
      GenJnlLine."Bal. Account No." := "Bank Account No.";
    end;
*/


    
/*
procedure ExportToFile ()
    var
//       GenJnlLine@1100000 :
      GenJnlLine: Record 81;
//       BankAccount@1100001 :
      BankAccount: Record 270;
    begin
      SETRECFILTER;
      TESTFIELD("Export Electronic Payment",TRUE);

      if "Elect. Pmts Exported" then
        if not CONFIRM(ExportAgainQst) then
          exit;

      BankAccount.GET("Bank Account No.");
      FilterSourceForExport(GenJnlLine);
      CODEUNIT.RUN(BankAccount.GetPaymentExportCodeunitID,GenJnlLine);
      FIND;
      VALIDATE("Elect. Pmts Exported",TRUE);
      MODIFY;
    end;

    /*begin
    //{
//      JAV 26/10/20: - QB 1.07.00 - Departamento que lanza la orden de pago
//      JAV 25/06/22: - QB 1.10.54 Se cambia la tabla del departamento de la de dimensi¢n a la propia de departamentos
//    }
    end.
  */
}





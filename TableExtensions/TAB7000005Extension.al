tableextension 50225 "QBU Bill GroupExt" extends "Bill Group"
{
  
  
    CaptionML=ENU='Bill Group',ESP='Remesa';
    LookupPageID="Bill Groups List";
    DrillDownPageID="Bill Groups List";
  
  fields
{
    field(7207271;"QBU Bill Group Confirming";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Bill Group Confirming',ESP='Remesa Confirming';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT] Indica si esta remesa es de Confirmnig';


    }
    field(7207290;"QBU Factoring Line";Code[20])
    {
        TableRelation="QB Confirming Lines";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea de Factoring';
                                                   Description='QB 1.06.15 - JAV 23/09/20: L¡nea de Factoring asociada al banco de la remesa' ;


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
      Text1100000: TextConst ENU='&Collection,&Discount',ESP='&Cobro,&Descuento';
//       Text1100001@1001 :
      Text1100001: TextConst ENU='The creation of a new %1 was cancelled by the user',ESP='Se ha cancelado la creaci¢n de %1 por el usuario';
//       Text1100002@1002 :
      Text1100002: TextConst ENU='This Bill Group is not empty. Remove all its bills and try again.',ESP='La remesa no est  vac¡a. Elimine todos sus efectos e int‚ntelo de nuevo.';
//       Text1100003@1003 :
      Text1100003: TextConst ENU='can only be changed when the %1 is empty',ESP='s¢lo se puede cambiar cuando %1 est  vac¡a';
//       Text1100004@1004 :
      Text1100004: TextConst ENU='The operation is not allowed for bill groups using %1. Check your currency setup.',ESP='La operaci¢n no se permite para remesas que usan %1. Compruebe la configuraci¢n de la divisa.';
//       Text1100005@1005 :
      Text1100005: TextConst ENU='Invoices should be removed.',ESP='Se deben eliminar las facturas.';
//       Text1100006@1006 :
      Text1100006: TextConst ENU='Bills should be removed.',ESP='Se deben eliminar los efectos.';
//       Text1100007@1007 :
      Text1100007: TextConst ENU='This bill group has already been printed. Proceed anyway?',ESP='Ya se ha impreso la remesa. ¨Confirma que desea continuar?';
//       Text1100008@1008 :
      Text1100008: TextConst ENU='The update has been interrupted by the user.',ESP='La actualizaci¢n se ha interrumpido por el usuario.';
//       Text1100009@1009 :
      Text1100009: TextConst ENU='Bill Group',ESP='Remesa';
//       Text1100010@1010 :
      Text1100010: TextConst ENU=' is currently in use in a Posted Bill Group.',ESP=' ya ha sido utilizado en una remesa registrada.';
//       Text1100011@1011 :
      Text1100011: TextConst ENU=' is currently in use in a Closed Bill Group.',ESP=' ya ha sido utilizado en una remesa cerrada.';
//       Text1100012@1012 :
      Text1100012: TextConst ENU='untitled',ESP='sin t¡tulo';
//       BillGr@1100001 :
      BillGr: Record 7000005;
//       PostedBillGr@1100002 :
      PostedBillGr: Record 7000006;
//       ClosedBillGr@1100003 :
      ClosedBillGr: Record 7000007;
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
//       CarteraManagement@1100009 :
      CarteraManagement: Codeunit 7000000;
//       NoSeriesMgt@1100010 :
      NoSeriesMgt: Codeunit 396;
//       Option@1100012 :
      Option: Integer;
//       SilentDirectDebitFormat@1100013 :
      SilentDirectDebitFormat: Option " ","Standard","N58";
//       DirectDebitOptionTxt@1100014 :
      DirectDebitOptionTxt: TextConst ENU='Direct Debit',ESP='Adeudo directo';
//       InvoiceDiscountingOptionTxt@1100016 :
      InvoiceDiscountingOptionTxt: TextConst ENU='Invoice Discounting',ESP='Operaci¢n de cesi¢n de cr‚dito';
//       InstructionTxt@1100015 :
      InstructionTxt: TextConst ENU='Select which format to use.',ESP='Seleccione el formato que quiere usar.';
//       DirectDebitFormatSilentlySelected@1100000 :
      DirectDebitFormatSilentlySelected: Boolean;

    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 CarteraSetup.GET;
                 CarteraSetup.TESTFIELD("Bill Group Nos.");
                 NoSeriesMgt.InitSeries(CarteraSetup."Bill Group Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               if GETFILTER("Bank Account No.") <> '' then
                 if GETRANGEMIN("Bank Account No.") = GETRANGEMAX("Bank Account No.") then begin
                   Option := STRMENU(Text1100000);
                   CASE Option OF
                     0:
                       ERROR(Text1100001,TABLECAPTION);
                     1:
                       "Dealing Type" := "Dealing Type"::Collection;
                     2:
                       "Dealing Type" := "Dealing Type"::Discount;
                   end;
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
               Doc.SETRANGE(Type,Doc.Type::Receivable);
               Doc.SETRANGE("Bill Gr./Pmt. Order No.","No.");
               if Doc.FINDFIRST then
                 ERROR(Text1100002);

               BGPOCommentLine.SETRANGE("BG/PO No.","No.");
               BGPOCommentLine.DELETEALL;
             end;

*/



// procedure AssistEdit (OldBillGr@1100000 :

/*
procedure AssistEdit (OldBillGr: Record 7000005) : Boolean;
    begin
      WITH BillGr DO begin
        BillGr := Rec;
        CarteraSetup.GET;
        CarteraSetup.TESTFIELD("Bill Group Nos.");
        if NoSeriesMgt.SelectSeries(CarteraSetup."Bill Group Nos.",OldBillGr."No. Series","No. Series") then begin
          CarteraSetup.GET;
          CarteraSetup.TESTFIELD("Bill Group Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := BillGr;
          exit(TRUE);
        end;
      end;
    end;
*/


    
/*
LOCAL procedure CheckPrinted ()
    begin
      if "No. Printed" <> 0 then
        if not CONFIRM(Text1100007) then
          ERROR(Text1100008);
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
      "Posting Description" := Text1100009 + ' ' + "No.";
    end;
*/


    
/*
LOCAL procedure CheckNoNotUsed ()
    begin
      if PostedBillGr.GET("No.") then
        FIELDERROR("No.",PostedBillGr."No." + Text1100010);
      if ClosedBillGr.GET("No.") then
        FIELDERROR("No.",ClosedBillGr."No." + Text1100011);
    end;
*/


//     procedure PrintRecords (ShowRequestForm@1100000 :
    
/*
procedure PrintRecords (ShowRequestForm: Boolean)
    var
//       CarteraReportSelection@1100001 :
      CarteraReportSelection: Record 7000013;
    begin
      WITH BillGr DO begin
        COPY(Rec);
        CarteraReportSelection.SETRANGE(Usage,CarteraReportSelection.Usage::"Bill Group");
        CarteraReportSelection.SETFILTER("Report ID",'<>0');
        CarteraReportSelection.FIND('-');
        repeat
          REPORT.RUNMODAL(CarteraReportSelection."Report ID",ShowRequestForm,FALSE,BillGr);
        until CarteraReportSelection.NEXT = 0;
      end;
    end;
*/


    
/*
LOCAL procedure BillGrIsEmpty () : Boolean;
    begin
      Doc.SETCURRENTKEY(Type,"Bill Gr./Pmt. Order No.");
      Doc.SETRANGE(Type,Doc.Type::Receivable);
      Doc.SETRANGE("Bill Gr./Pmt. Order No.","No.");
      exit(not Doc.FINDFIRST);
    end;
*/


    
/*
procedure Caption () : Text[100];
    begin
      if "No." = '' then
        exit(Text1100012);
      CALCFIELDS("Bank Account Name");
      exit(STRSUBSTNO('%1 %2',"No.","Bank Account Name"));
    end;
*/


    
/*
procedure ExportToFile ()
    var
//       DirectDebitCollection@1100002 :
      DirectDebitCollection: Record 1207;
//       DirectDebitCollectionEntry@1100000 :
      DirectDebitCollectionEntry: Record 1208;
//       BankAccount@1100001 :
      BankAccount: Record 270;
    begin
      DirectDebitCollection.CreateNew("No.","Bank Account No.","Partner Type");
      DirectDebitCollection."Source Table ID" := DATABASE::"Bill Group";
      DirectDebitCollection.MODIFY;
      CheckSEPADirectDebitFormat(DirectDebitCollection);
      BankAccount.GET("Bank Account No.");
      COMMIT;
      DirectDebitCollectionEntry.SETRANGE("Direct Debit Collection No.",DirectDebitCollection."No.");
      RunFileExportCodeunit(BankAccount.GetDDExportCodeunitID,DirectDebitCollection."No.",DirectDebitCollectionEntry);
      DeleteDirectDebitCollection(DirectDebitCollection."No.");
    end;
*/


//     procedure RunFileExportCodeunit (CodeunitID@1100000 : Integer;DirectDebitCollectionNo@1100003 : Integer;var DirectDebitCollectionEntry@1100001 :
    
/*
procedure RunFileExportCodeunit (CodeunitID: Integer;DirectDebitCollectionNo: Integer;var DirectDebitCollectionEntry: Record 1208)
    var
//       LastError@1100002 :
      LastError: Text;
    begin
      if not CODEUNIT.RUN(CodeunitID,DirectDebitCollectionEntry) then begin
        LastError := GETLASTERRORTEXT;
        DeleteDirectDebitCollection(DirectDebitCollectionNo);
        COMMIT;
        ERROR(LastError);
      end;
    end;
*/


//     procedure DeleteDirectDebitCollection (DirectDebitCollectionNo@1100000 :
    
/*
procedure DeleteDirectDebitCollection (DirectDebitCollectionNo: Integer)
    var
//       DirectDebitCollection@1100001 :
      DirectDebitCollection: Record 1207;
    begin
      if DirectDebitCollection.GET(DirectDebitCollectionNo) then
        DirectDebitCollection.DELETE(TRUE);
    end;
*/


//     procedure SelectDirectDebitFormatSilently (NewDirectDebitFormat@1100000 :
    
/*
procedure SelectDirectDebitFormatSilently (NewDirectDebitFormat: Option)
    begin
      SilentDirectDebitFormat := NewDirectDebitFormat;
      DirectDebitFormatSilentlySelected := TRUE;
    end;
*/


//     LOCAL procedure CheckSEPADirectDebitFormat (var DirectDebitCollection@1100002 :
    
/*
LOCAL procedure CheckSEPADirectDebitFormat (var DirectDebitCollection: Record 1207)
    var
//       BankAccount@1100003 :
      BankAccount: Record 270;
//       DirectDebitFormat@1100000 :
      DirectDebitFormat: Option;
//       Selection@1100001 :
      Selection: Integer;
    begin
      BankAccount.GET("Bank Account No.");
      if BankAccount.GetDDExportCodeunitID = CODEUNIT::"SEPA DD-Export File" then begin
        if not DirectDebitFormatSilentlySelected then begin
          Selection := STRMENU(STRSUBSTNO('%1,%2',DirectDebitOptionTxt,InvoiceDiscountingOptionTxt),1,InstructionTxt);

          if Selection = 0 then
            exit;

          CASE Selection OF
            1:
              DirectDebitFormat := DirectDebitCollection."Direct Debit Format"::Standard;
            2:
              DirectDebitFormat := DirectDebitCollection."Direct Debit Format"::N58;
          end;
        end else
          DirectDebitFormat := SilentDirectDebitFormat;

        DirectDebitCollection."Direct Debit Format" := DirectDebitFormat;
        DirectDebitCollection.MODIFY;
      end;
    end;

    /*begin
    end.
  */
}






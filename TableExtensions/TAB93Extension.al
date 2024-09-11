tableextension 50126 "QBU Vendor Posting GroupExt" extends "Vendor Posting Group"
{
  
  
    CaptionML=ENU='Vendor Posting Group',ESP='Grupo registro proveedor';
    LookupPageID="Vendor Posting Groups";
  
  fields
{
    field(7174332;"QBU QuoSII Type";Option)
    {
        OptionMembers=" ","LF","OI";CaptionML=ENU='SII Type',ESP='Tipo SII';
                                                   OptionCaptionML=ENU='" ,Libros de Facturas,Operaciones Intracomunitarias"',ESP='" ,Libros de Facturas,Operaciones Intracomunitarias"';
                                                   
                                                   Description='QuoSII';


    }
    field(7174333;"QBU QuoSII Invoice Description";Text[250])
    {
        CaptionML=ENU='SII Invoice Description',ESP='Descripcion Factura SII';
                                                   Description='QuoSII 1.4';


    }
    field(7207270;"QBU Acct. Purch. Rcpt Pending Inv.";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Cta. alb pend. recibir factura',ESP='Cta. alb pend. recibir factura';
                                                   Description='QB2516';


    }
    field(7207271;"QBU Confirming Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Account',ESP='Cuenta confirming';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT: Indica la cuenta de registro si la operaci¢n ha provenido de un confirming]' ;


    }
}
  keys
{
   // key(key1;"Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"Code")
   // {
       // 
   // }
}
  
    var
//       GLSetup@1000 :
      GLSetup: Record 98;
//       GLAccountCategory@1001 :
      GLAccountCategory: Record 570;
//       GLAccountCategoryMgt@1002 :
      GLAccountCategoryMgt: Codeunit 570;
//       PostingSetupMgt@1004 :
      PostingSetupMgt: Codeunit 48;
//       YouCannotDeleteErr@1003 :
      YouCannotDeleteErr: 
// "%1 = Code"
TextConst ENU='You cannot delete %1.',ESP='No puede eliminar %1.';

    


/*
trigger OnDelete();    begin
               CheckGroupUsage;
             end;

*/




/*
LOCAL procedure CheckGroupUsage ()
    var
//       Vendor@1000 :
      Vendor: Record 23;
//       VendorLedgerEntry@1001 :
      VendorLedgerEntry: Record 25;
    begin
      Vendor.SETRANGE("Vendor Posting Group",Code);
      if not Vendor.ISEMPTY then
        ERROR(YouCannotDeleteErr,Code);

      VendorLedgerEntry.SETRANGE("Vendor Posting Group",Code);
      if not VendorLedgerEntry.ISEMPTY then
        ERROR(YouCannotDeleteErr,Code);
    end;
*/


    
    
/*
procedure GetPayablesAccount () : Code[20];
    begin
      if "Payables Account" = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payables Account"));
      TESTFIELD("Payables Account");
      exit("Payables Account");
    end;
*/


    
//     procedure GetPmtDiscountAccount (Debit@1000 :
    
/*
procedure GetPmtDiscountAccount (Debit: Boolean) : Code[20];
    begin
      if Debit then begin
        if "Payment Disc. Debit Acc." = '' then
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Debit Acc."));
        TESTFIELD("Payment Disc. Debit Acc.");
        exit("Payment Disc. Debit Acc.");
      end;
      if "Payment Disc. Credit Acc." = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Credit Acc."));
      TESTFIELD("Payment Disc. Credit Acc.");
      exit("Payment Disc. Credit Acc.");
    end;
*/


    
//     procedure GetPmtToleranceAccount (Debit@1000 :
    
/*
procedure GetPmtToleranceAccount (Debit: Boolean) : Code[20];
    begin
      if Debit then begin
        if "Payment Tolerance Debit Acc." = '' then
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Debit Acc."));
        TESTFIELD("Payment Tolerance Debit Acc.");
        exit("Payment Tolerance Debit Acc.");
      end;
      if "Payment Tolerance Credit Acc." = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Credit Acc."));
      TESTFIELD("Payment Tolerance Credit Acc.");
      exit("Payment Tolerance Credit Acc.");
    end;
*/


    
//     procedure GetRoundingAccount (Debit@1000 :
    
/*
procedure GetRoundingAccount (Debit: Boolean) : Code[20];
    begin
      if Debit then begin
        if "Debit Rounding Account" = '' then
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Debit Rounding Account"));
        TESTFIELD("Debit Rounding Account");
        exit("Debit Rounding Account");
      end;
      if "Credit Rounding Account" = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Credit Rounding Account"));
      TESTFIELD("Credit Rounding Account");
      exit("Credit Rounding Account");
    end;
*/


    
//     procedure GetApplRoundingAccount (Debit@1000 :
    
/*
procedure GetApplRoundingAccount (Debit: Boolean) : Code[20];
    begin
      if Debit then begin
        if "Debit Curr. Appln. Rndg. Acc." = '' then
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Debit Curr. Appln. Rndg. Acc."));
        TESTFIELD("Debit Curr. Appln. Rndg. Acc.");
        exit("Debit Curr. Appln. Rndg. Acc.");
      end;
      if "Credit Curr. Appln. Rndg. Acc." = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Credit Curr. Appln. Rndg. Acc."));
      TESTFIELD("Credit Curr. Appln. Rndg. Acc.");
      exit("Credit Curr. Appln. Rndg. Acc.");
    end;
*/


    
/*
procedure GetBillsAccount () : Code[20];
    begin
      TESTFIELD("Bills Account");
      exit("Bills Account");
    end;
*/


    
/*
procedure GetInvoicesInPmtOrderAccount () : Code[20];
    begin
      TESTFIELD("Invoices in  Pmt. Ord. Acc.");
      exit("Invoices in  Pmt. Ord. Acc.");
    end;
*/


    
/*
procedure GetBillsInPmtOrderAccount () : Code[20];
    begin
      TESTFIELD("Bills in Payment Order Acc.");
      exit("Bills in Payment Order Acc.");
    end;
*/


    
    
/*
procedure GetInvRoundingAccount () : Code[20];
    begin
      if "Invoice Rounding Account" = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Invoice Rounding Account"));
      TESTFIELD("Invoice Rounding Account");
      exit("Invoice Rounding Account");
    end;
*/


    
    
/*
procedure GetServiceChargeAccount () : Code[20];
    begin
      if "Service Charge Acc." = '' then
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Service Charge Acc."));
      TESTFIELD("Service Charge Acc.");
      exit("Service Charge Acc.");
    end;
*/


    
//     procedure SetAccountVisibility (var PmtToleranceVisible@1000 : Boolean;var PmtDiscountVisible@1002 : Boolean;var InvRoundingVisible@1001 : Boolean;var ApplnRoundingVisible@1005 :
    
/*
procedure SetAccountVisibility (var PmtToleranceVisible: Boolean;var PmtDiscountVisible: Boolean;var InvRoundingVisible: Boolean;var ApplnRoundingVisible: Boolean)
    var
//       PurchSetup@1003 :
      PurchSetup: Record 312;
//       PaymentTerms@1004 :
      PaymentTerms: Record 3;
    begin
      GLSetup.GET;
      PmtToleranceVisible := GLSetup.GetPmtToleranceVisible;
      PmtDiscountVisible := PaymentTerms.UsePaymentDiscount;

      PurchSetup.GET;
      InvRoundingVisible := PurchSetup."Invoice Rounding";
      ApplnRoundingVisible := PurchSetup."Appln. between Currencies" <> PurchSetup."Appln. between Currencies"::None;
    end;

    /*begin
    //{
//      QuoSII 1.4 03/05/2018 PGM - Incluido el campo SII Invoice Description
//    }
    end.
  */
}






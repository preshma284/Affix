tableextension 50125 "QBU Customer Posting GroupExt" extends "Customer Posting Group"
{
  
  
    CaptionML=ENU='Customer Posting Group',ESP='Grupo registro cliente';
    LookupPageID="Customer Posting Groups";
  
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
        CaptionML=ENU='SII Invoice Description',ESP='Descripci¢n factura SII';
                                                   Description='QuoSII1.4';


    }
    field(7207271;"QBU Confirming Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Account',ESP='Cuenta confirming';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT: Indica la cuenta de registro si la operaci¢n ha provenido de un confirming]';


    }
    field(7207272;"QBU Confirming Discount Acc.";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Discount Acc.',ESP='Cta. confirming descuento';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT: Indica la cuenta de registro si la operaci¢n ha provenido de un confirming al descuento]';


    }
    field(7207273;"QBU Confirming Collection Acc.";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Collection Acc.',ESP='Cta. confirming al cobro';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT: Indica la cuenta de registro si la operaci¢n ha provenido de un confirming al cobro]' ;


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
//       GLAccountCategory@1002 :
      GLAccountCategory: Record 570;
//       GLAccountCategoryMgt@1001 :
      GLAccountCategoryMgt: Codeunit 570;
//       PostingSetupMgt@1005 :
      PostingSetupMgt: Codeunit 48;
//       YouCannotDeleteErr@1004 :
      YouCannotDeleteErr: 
// "%1 = Code"
TextConst ENU='You cannot delete %1.',ESP='No puede eliminar %1.';

    


/*
trigger OnDelete();    begin
               CheckCustEntries;
             end;

*/




/*
LOCAL procedure CheckCustEntries ()
    var
//       Customer@1000 :
      Customer: Record 18;
//       CustLedgerEntry@1001 :
      CustLedgerEntry: Record 21;
    begin
      Customer.SETRANGE("Customer Posting Group",Code);
      if not Customer.ISEMPTY then
        ERROR(YouCannotDeleteErr,Code);

      CustLedgerEntry.SETRANGE("Customer Posting Group",Code);
      if not CustLedgerEntry.ISEMPTY then
        ERROR(YouCannotDeleteErr,Code);
    end;
*/


    
    
/*
procedure GetReceivablesAccount () : Code[20];
    begin
      if "Receivables Account" = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Receivables Account"));
      TESTFIELD("Receivables Account");
      exit("Receivables Account");
    end;
*/


    
//     procedure GetPmtDiscountAccount (Debit@1000 :
    
/*
procedure GetPmtDiscountAccount (Debit: Boolean) : Code[20];
    begin
      if Debit then begin
        if "Payment Disc. Debit Acc." = '' then
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Debit Acc."));
        TESTFIELD("Payment Disc. Debit Acc.");
        exit("Payment Disc. Debit Acc.");
      end;
      if "Payment Disc. Credit Acc." = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Credit Acc."));
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
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Debit Acc."));
        TESTFIELD("Payment Tolerance Debit Acc.");
        exit("Payment Tolerance Debit Acc.");
      end;
      if "Payment Tolerance Credit Acc." = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Credit Acc."));
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
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Debit Rounding Account"));
        TESTFIELD("Debit Rounding Account");
        exit("Debit Rounding Account");
      end;
      if "Credit Rounding Account" = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Credit Rounding Account"));
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
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Debit Curr. Appln. Rndg. Acc."));
        TESTFIELD("Debit Curr. Appln. Rndg. Acc.");
        exit("Debit Curr. Appln. Rndg. Acc.");
      end;
      if "Credit Curr. Appln. Rndg. Acc." = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Credit Curr. Appln. Rndg. Acc."));
      TESTFIELD("Credit Curr. Appln. Rndg. Acc.");
      exit("Credit Curr. Appln. Rndg. Acc.");
    end;
*/


//     procedure GetBillsAccount (Rejected@1100000 :
    
/*
procedure GetBillsAccount (Rejected: Boolean) : Code[20];
    begin
      if Rejected then begin
        TESTFIELD("Rejected Bills Acc.");
        exit("Rejected Bills Acc.");
      end;
      TESTFIELD("Bills Account");
      exit("Bills Account");
    end;
*/


    
/*
procedure GetBillsOnCollAccount () : Code[20];
    begin
      TESTFIELD("Bills on Collection Acc.");
      exit("Bills on Collection Acc.");
    end;
*/


    
    
/*
procedure GetInvRoundingAccount () : Code[20];
    begin
      if "Invoice Rounding Account" = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Invoice Rounding Account"));
      TESTFIELD("Invoice Rounding Account");
      exit("Invoice Rounding Account");
    end;
*/


    
    
/*
procedure GetServiceChargeAccount () : Code[20];
    begin
      if "Service Charge Acc." = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Service Charge Acc."));
      TESTFIELD("Service Charge Acc.");
      exit("Service Charge Acc.");
    end;
*/


    
    
/*
procedure GetAdditionalFeeAccount () : Code[20];
    begin
      if "Additional Fee Account" = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Additional Fee Account"));
      TESTFIELD("Additional Fee Account");
      exit("Additional Fee Account");
    end;
*/


    
    
/*
procedure GetAddFeePerLineAccount () : Code[20];
    begin
      if "Add. Fee per Line Account" = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Add. Fee per Line Account"));
      TESTFIELD("Add. Fee per Line Account");
      exit("Add. Fee per Line Account");
    end;
*/


    
    
/*
procedure GetInterestAccount () : Code[20];
    begin
      if "Interest Account" = '' then
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Interest Account"));
      TESTFIELD("Interest Account");
      exit("Interest Account");
    end;
*/


    
//     procedure SetAccountVisibility (var PmtToleranceVisible@1000 : Boolean;var PmtDiscountVisible@1002 : Boolean;var InvRoundingVisible@1001 : Boolean;var ApplnRoundingVisible@1005 :
    
/*
procedure SetAccountVisibility (var PmtToleranceVisible: Boolean;var PmtDiscountVisible: Boolean;var InvRoundingVisible: Boolean;var ApplnRoundingVisible: Boolean)
    var
//       SalesSetup@1003 :
      SalesSetup: Record 311;
//       PaymentTerms@1004 :
      PaymentTerms: Record 3;
    begin
      GLSetup.GET;
      PmtToleranceVisible := GLSetup.GetPmtToleranceVisible;
      PmtDiscountVisible := PaymentTerms.UsePaymentDiscount;

      SalesSetup.GET;
      InvRoundingVisible := SalesSetup."Invoice Rounding";
      ApplnRoundingVisible := SalesSetup."Appln. between Currencies" <> SalesSetup."Appln. between Currencies"::None;
    end;

    /*begin
    end.
  */
}






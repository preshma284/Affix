tableextension 50172 "QBU VAT Posting SetupExt" extends "VAT Posting Setup"
{
  
  
    CaptionML=ENU='VAT Posting Setup',ESP='Config. grupos registro IVA';
    LookupPageID="VAT Posting Setup";
    DrillDownPageID="VAT Posting Setup";
  
  fields
{
    field(7147400;"QBU QuoSII DUA Compensation";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='DUA Compensation',ESP='Compensaci¢n DUA';
                                                   Description='PSM 20/05/21';


    }
    field(7174331;"QBU QuoSII Exent Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("ExentType"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Exent Type',ESP='Tipo Exenta';
                                                   Description='QuoSII';


    }
    field(7174332;"QBU QuoSII No VAT Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("NoVATType"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='No VAT Type',ESP='Tipo No Sujeta';
                                                   Description='QuoSII';


    }
    field(7174333;"QBU QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';


    }
    field(7174390;"QBU DP Non Deductible VAT Line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tiene no deducible';
                                                   Description='DP 1.00.04 JAV 14/07/22: [TT] Este campo indica si al usar este tipo de IVA en una factura de compra la l¡nea tiene una parte del IVA no deducible que aumentar  el importe del gasto';


    }
    field(7174391;"QBU DP Non Deductible VAT %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% No deducible';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='DP 1.00.04 JAV 14/07/22: [TT] Este campo indica al usar este tipo de IVA en una factura de compra se le aplciar  a la l¡nea  este valor como % no deducible de la l¡nea que aumentar  el importe del gasto';


    }
    field(7207200;"QBU ISP Description";Text[150])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='ISP Description',ESP='Descripci¢n ISP';
                                                   Description='QB 1.05.07 - Texto a presentar en la factura cuando existe ISP, se amplia de 100 a 150' ;


    }
}
  keys
{
   // key(key1;"VAT Bus. Posting Group","VAT Prod. Posting Group")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='%1 must be entered on the tax jurisdiction line when %2 is %3.',ESP='Se debe indicar %1 en l¡nea jurisdicci¢n fiscal cuando %2 es %3.';
//       Text001@1001 :
      Text001: TextConst ENU='%1 = %2 has already been used for %3 = %4 in %5 for %6 = %7 and %8 = %9.',ESP='%1 = %2 ya ha sido utilizado por %3 = %4 en %5 para %6 = %7 y %8 = %9.';
//       GLSetup@1002 :
      GLSetup: Record 98;
//       PostingSetupMgt@1005 :
      PostingSetupMgt: Codeunit 48;
//       DependentFieldActivatedErr@1100003 :
      DependentFieldActivatedErr: TextConst ENU='You cannot change %1 because %2 is selected.',ESP='No puede cambiar %1 porque se ha seleccionado %2.';
//       RequiredFieldNotActivatedErr@1100004 :
      RequiredFieldNotActivatedErr: TextConst ENU='You cannot change %1 because %2 is empty.',ESP='No puede cambiar %1 porque %2 est  vac¡o.';
//       YouCannotDeleteErr@1004 :
      YouCannotDeleteErr: 
// "%1 = Location Code; %2 = Posting Group"
TextConst ENU='You cannot delete %1 %2.',ESP='No puede eliminar %1 %2.';

    
    


/*
trigger OnInsert();    begin
               if "VAT %" = 0 then
                 "VAT %" := GetVATPtc;
             end;


*/

/*
trigger OnDelete();    begin
               CheckSetupUsage;
             end;

*/



// procedure CheckGLAcc (AccNo@1000 :

/*
procedure CheckGLAcc (AccNo: Code[20])
    var
//       GLAcc@1001 :
      GLAcc: Record 15;
    begin
      if AccNo <> '' then begin
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
      end;
    end;
*/


    
/*
LOCAL procedure CheckSetupUsage ()
    var
//       GLEntry@1000 :
      GLEntry: Record 17;
    begin
      GLEntry.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      GLEntry.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");
      if not GLEntry.ISEMPTY then
        ERROR(YouCannotDeleteErr,"VAT Bus. Posting Group","VAT Prod. Posting Group");
    end;
*/


    
//     procedure TestNotSalesTax (FromFieldName@1000 :
    
/*
procedure TestNotSalesTax (FromFieldName: Text[100])
    begin
      if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then
        ERROR(
          Text000,
          FromFieldName,FIELDCAPTION("VAT Calculation Type"),
          "VAT Calculation Type");
    end;
*/


    
/*
LOCAL procedure CheckVATIdentifier ()
    var
//       VATPostingSetup@1000 :
      VATPostingSetup: Record 325;
    begin
      VATPostingSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATPostingSetup.SETFILTER("VAT Prod. Posting Group",'<>%1',"VAT Prod. Posting Group");
      VATPostingSetup.SETFILTER("VAT %",'<>%1',"VAT %");
      VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
      if VATPostingSetup.FINDFIRST then
        ERROR(
          Text001,
          FIELDCAPTION("VAT Identifier"),VATPostingSetup."VAT Identifier",
          FIELDCAPTION("VAT %"),VATPostingSetup."VAT %",TABLECAPTION,
          FIELDCAPTION("VAT Bus. Posting Group"),VATPostingSetup."VAT Bus. Posting Group",
          FIELDCAPTION("VAT Prod. Posting Group"),VATPostingSetup."VAT Prod. Posting Group");
    end;
*/


    
/*
LOCAL procedure GetVATPtc () : Decimal;
    var
//       VATPostingSetup@1000 :
      VATPostingSetup: Record 325;
    begin
      VATPostingSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATPostingSetup.SETFILTER("VAT Prod. Posting Group",'<>%1',"VAT Prod. Posting Group");
      VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
      if not VATPostingSetup.FINDFIRST then
        VATPostingSetup."VAT %" := "VAT %";
      exit(VATPostingSetup."VAT %");
    end;
*/


    
/*
LOCAL procedure GetECPercentage () : Decimal;
    var
//       VATPostingSetup@1001 :
      VATPostingSetup: Record 325;
    begin
      VATPostingSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATPostingSetup.SETFILTER("VAT Prod. Posting Group",'<>%1',"VAT Prod. Posting Group");
      VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
      if not VATPostingSetup.FINDFIRST then
        VATPostingSetup."EC %" := "EC %";
      exit(VATPostingSetup."EC %");
    end;
*/


    
//     procedure GetSalesAccount (Unrealized@1000 :
    
/*
procedure GetSalesAccount (Unrealized: Boolean) : Code[20];
    begin
      if Unrealized then begin
        if "Sales VAT Unreal. Account" = '' then
          PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Sales VAT Unreal. Account"));
        TESTFIELD("Sales VAT Unreal. Account");
        exit("Sales VAT Unreal. Account");
      end;
      if "Sales VAT Account" = '' then
        PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Sales VAT Account"));
      TESTFIELD("Sales VAT Account");
      exit("Sales VAT Account");
    end;
*/


    
//     procedure GetPurchAccount (Unrealized@1000 :
    
/*
procedure GetPurchAccount (Unrealized: Boolean) : Code[20];
    begin
      if Unrealized then begin
        if "Purch. VAT Unreal. Account" = '' then
          PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Purch. VAT Unreal. Account"));
        TESTFIELD("Purch. VAT Unreal. Account");
        exit("Purch. VAT Unreal. Account");
      end;
      if "Purchase VAT Account" = '' then
        PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Purchase VAT Account"));
      TESTFIELD("Purchase VAT Account");
      exit("Purchase VAT Account");
    end;
*/


    
//     procedure GetRevChargeAccount (Unrealized@1000 :
    
/*
procedure GetRevChargeAccount (Unrealized: Boolean) : Code[20];
    begin
      if Unrealized then begin
        if "Reverse Chrg. VAT Unreal. Acc." = '' then
          PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Reverse Chrg. VAT Unreal. Acc."));
        TESTFIELD("Reverse Chrg. VAT Unreal. Acc.");
        exit("Reverse Chrg. VAT Unreal. Acc.");
      end;
      if "Reverse Chrg. VAT Acc." = '' then
        PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Reverse Chrg. VAT Acc."));
      TESTFIELD("Reverse Chrg. VAT Acc.");
      exit("Reverse Chrg. VAT Acc.");
    end;
*/


    
//     procedure SetAccountsVisibility (var UnrealizedVATVisible@1000 : Boolean;var AdjustForPmtDiscVisible@1001 :
    
/*
procedure SetAccountsVisibility (var UnrealizedVATVisible: Boolean;var AdjustForPmtDiscVisible: Boolean)
    begin
      GLSetup.GET;
      UnrealizedVATVisible := GLSetup."Unrealized VAT" or GLSetup."Prepayment Unrealized VAT";
      AdjustForPmtDiscVisible := GLSetup."Adjust for Payment Disc.";
    end;
*/


    
    
/*
procedure SuggestSetupAccounts ()
    var
//       RecRef@1000 :
      RecRef: RecordRef;
    begin
      RecRef.GETTABLE(Rec);
      SuggestVATAccounts(RecRef);
      RecRef.MODIFY;
    end;
*/


//     LOCAL procedure SuggestVATAccounts (var RecRef@1000 :
    
/*
LOCAL procedure SuggestVATAccounts (var RecRef: RecordRef)
    begin
      if "Sales VAT Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Sales VAT Account"));
      if "Purchase VAT Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Purchase VAT Account"));

      if "Unrealized VAT Type" > 0 then begin
        if "Sales VAT Unreal. Account" = '' then
          SuggestAccount(RecRef,FIELDNO("Sales VAT Unreal. Account"));
        if "Purch. VAT Unreal. Account" = '' then
          SuggestAccount(RecRef,FIELDNO("Purch. VAT Unreal. Account"));
      end;

      if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then begin
        if "Reverse Chrg. VAT Acc." = '' then
          SuggestAccount(RecRef,FIELDNO("Reverse Chrg. VAT Acc."));
        if ("Unrealized VAT Type" > 0) and ("Reverse Chrg. VAT Unreal. Acc." = '') then
          SuggestAccount(RecRef,FIELDNO("Reverse Chrg. VAT Unreal. Acc."));
      end;
    end;
*/


//     LOCAL procedure SuggestAccount (var RecRef@1000 : RecordRef;AccountFieldNo@1001 :
    
/*
LOCAL procedure SuggestAccount (var RecRef: RecordRef;AccountFieldNo: Integer)
    var
//       TempAccountUseBuffer@1002 :
      TempAccountUseBuffer: Record 63 TEMPORARY;
//       RecFieldRef@1003 :
      RecFieldRef: FieldRef;
//       VATPostingSetupRecRef@1005 :
      VATPostingSetupRecRef: RecordRef;
//       VATPostingSetupFieldRef@1006 :
      VATPostingSetupFieldRef: FieldRef;
    begin
      VATPostingSetupRecRef.OPEN(DATABASE::"VAT Posting Setup");

      VATPostingSetupRecRef.RESET;
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Bus. Posting Group"));
      VATPostingSetupFieldRef.SETRANGE("VAT Bus. Posting Group");
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Prod. Posting Group"));
      VATPostingSetupFieldRef.SETFILTER('<>%1',"VAT Prod. Posting Group");
      TempAccountUseBuffer.UpdateBuffer(VATPostingSetupRecRef,AccountFieldNo);

      VATPostingSetupRecRef.RESET;
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Bus. Posting Group"));
      VATPostingSetupFieldRef.SETFILTER('<>%1',"VAT Bus. Posting Group");
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Prod. Posting Group"));
      VATPostingSetupFieldRef.SETRANGE("VAT Prod. Posting Group");
      TempAccountUseBuffer.UpdateBuffer(VATPostingSetupRecRef,AccountFieldNo);

      VATPostingSetupRecRef.CLOSE;

      TempAccountUseBuffer.RESET;
      TempAccountUseBuffer.SETCURRENTKEY("No. of Use");
      if TempAccountUseBuffer.FINDLAST then begin
        RecFieldRef := RecRef.FIELD(AccountFieldNo);
        RecFieldRef.VALUE(TempAccountUseBuffer."Account No.");
      end;
    end;
*/


//     LOCAL procedure TestNoTaxableRate (Rate@1100000 :
    
/*
LOCAL procedure TestNoTaxableRate (Rate: Decimal)
    begin
      CASE "VAT Calculation Type" OF
        "VAT Calculation Type"::"No Taxable VAT":
          if Rate <> 0 then
            FIELDERROR("VAT Calculation Type");
        "VAT Calculation Type"::"Normal VAT":
          if Rate <> 0 then
            TESTFIELD("No Taxable Type",0);
      end;
    end;
*/


    
/*
procedure IsNoTaxable () : Boolean;
    begin
      if "VAT Calculation Type" = "VAT Calculation Type"::"No Taxable VAT" then
        exit(TRUE);
      exit(
        ("VAT Calculation Type" = "VAT Calculation Type"::"Normal VAT") and
        ("No Taxable Type" <> "No Taxable Type"::" "));
    end;

    /*begin
    //{
//      //PSM 20/05/21 Crear campo QuoSII DUA Compensation para no leer las l¡neas que no tienen que enviarse al SII
//    }
    end.
  */
}






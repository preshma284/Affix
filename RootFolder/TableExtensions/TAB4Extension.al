tableextension 50101 "MyExtension50101" extends "Currency"
{
  
  
    CaptionML=ENU='Currency',ESP='Divisa';
    LookupPageID="Currencies";
  
  fields
{
    field(7238177;"QB_Currencys name";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Fractions name',ESP='Nombre de la moneda en plural';
                                                   Description='QRE 1.00.01 15452';


    }
    field(7238178;"QB_Currency name";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Fractions name',ESP='Nombre de la moneda en singular';
                                                   Description='QRE 1.00.01 15452';


    }
    field(7238179;"QB_Fractions name";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Fractions name',ESP='Nombre fracciones en plural';
                                                   Description='QRE 1.00.01 15452';


    }
    field(7238180;"QB_Fraction name";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Fractions name',ESP='Nombre fracciones en singular';
                                                   Description='QRE 1.00.01 15452';


    }
    field(7238181;"QB_Fraction W Currency";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Si se imprime la fracci¢n seguida de la moneda';
                                                   Description='QRE 1.00.01 15452';


    }
    field(7238182;"QB_Gendre";Option)
    {
        OptionMembers="Male","Female";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='G‚nero del nombre de la moneda';
                                                   OptionCaptionML=ENU='Male,Female',ESP='Masculino,Femenino';
                                                   
                                                   Description='QRE 1.00.01 15452' ;


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
   // fieldgroup(Brick;"Code","Description")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='must be rounded to the nearest %1',ESP='se debe redondear al %1 m s cercano';
//       Text001@1001 :
      Text001: TextConst ENU='%1 must be rounded to the nearest %2.',ESP='Se debe redondear %1 al m s cercano %2.';
//       CurrExchRate@1002 :
      CurrExchRate: Record 330;
//       GLSetup@1003 :
      GLSetup: Record 98;
//       Text002@1004 :
      Text002: 
// 1 either customer or vendor ledger entry table 2 name co currency table 3 currencency code
TextConst ENU='There is one or more opened entries in the %1 table using %2 %3.',ESP='Hay una o m s entradas abiertas en la tabla %1 que usan %2 %3.';
//       IncorrectEntryTypeErr@1005 :
      IncorrectEntryTypeErr: TextConst ENU='Incorrect Entry Type %1.',ESP='Tipo de movimiento %1 incorrecto.';
//       EuroDescriptionTxt@1006 :
      EuroDescriptionTxt: 
// Currency Description
TextConst ENU='Euro',ESP='Euro';
//       CanadiandollarDescriptionTxt@1007 :
      CanadiandollarDescriptionTxt: 
// Currency Description
TextConst ENU='Canadian dollar',ESP='D¢lar canadiense';
//       BritishpoundDescriptionTxt@1008 :
      BritishpoundDescriptionTxt: 
// Currency Description
TextConst ENU='Pound Sterling',ESP='Libra esterlina';
//       USdollarDescriptionTxt@1009 :
      USdollarDescriptionTxt: 
// Currency Description
TextConst ENU='US dollar',ESP='D¢lar de EE.ÿUU.';
//       ISOCodeLengthErr@1010 :
      ISOCodeLengthErr: 
// %1, %2 - numbers, %3 - actual value
TextConst ENU='The length of the string is %1, but it must be equal to %2 characters. Value: %3.',ESP='La longitud de la cadena es %1, pero debe ser igual a %2 caracteres. Valor: %3.';
//       ASCIILetterErr@1011 :
      ASCIILetterErr: TextConst ENU='must contain ASCII letters only',ESP='solo debe contener letras ASCII';
//       NumericErr@1012 :
      NumericErr: TextConst ENU='must contain numbers only',ESP='solo debe contener n£meros';
//       TypeHelper@1013 :
      TypeHelper: Codeunit 10;

    
    


/*
trigger OnInsert();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
             end;


*/

/*
trigger OnModify();    begin
               "Last Date Modified" := TODAY;
               "Last Modified Date Time" := CURRENTDATETIME;
             end;


*/

/*
trigger OnDelete();    var
//                CustLedgEntry@1000 :
               CustLedgEntry: Record 21;
//                VendLedgEntry@1001 :
               VendLedgEntry: Record 25;
             begin
               CustLedgEntry.SETRANGE(Open,TRUE);
               CustLedgEntry.SETRANGE("Currency Code",Code);
               if not CustLedgEntry.ISEMPTY then
                 ERROR(Text002,CustLedgEntry.TABLECAPTION,TABLECAPTION,Code);

               VendLedgEntry.SETRANGE(Open,TRUE);
               VendLedgEntry.SETRANGE("Currency Code",Code);
               if not VendLedgEntry.ISEMPTY then
                 ERROR(Text002,VendLedgEntry.TABLECAPTION,TABLECAPTION,Code);

               CurrExchRate.SETRANGE("Currency Code",Code);
               CurrExchRate.DELETEALL;
             end;


*/

/*
trigger OnRename();    begin
               "Last Date Modified" := TODAY;
               "Last Modified Date Time" := CURRENTDATETIME;
             end;

*/




/*
procedure InitRoundingPrecision ()
    begin
      GLSetup.GET;
      if GLSetup."Amount Rounding Precision" <> 0 then
        "Amount Rounding Precision" := GLSetup."Amount Rounding Precision"
      else
        "Amount Rounding Precision" := 0.01;
      if GLSetup."Unit-Amount Rounding Precision" <> 0 then
        "Unit-Amount Rounding Precision" := GLSetup."Unit-Amount Rounding Precision"
      else
        "Unit-Amount Rounding Precision" := 0.00001;
      "Max. VAT Difference Allowed" := GLSetup."Max. VAT Difference Allowed";
      "VAT Rounding Type" := GLSetup."VAT Rounding Type";
      "Invoice Rounding Precision" := GLSetup."Inv. Rounding Precision (LCY)";
      "Invoice Rounding Type" := GLSetup."Inv. Rounding Type (LCY)";
    end;
*/


//     LOCAL procedure CheckGLAcc (AccNo@1000 :
    
/*
LOCAL procedure CheckGLAcc (AccNo: Code[20])
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
procedure VATRoundingDirection () : Text[1];
    begin
      CASE "VAT Rounding Type" OF
        "VAT Rounding Type"::Nearest:
          exit('=');
        "VAT Rounding Type"::Up:
          exit('>');
        "VAT Rounding Type"::Down:
          exit('<');
      end;
    end;
*/


    
    
/*
procedure InvoiceRoundingDirection () : Text[1];
    begin
      CASE "Invoice Rounding Type" OF
        "Invoice Rounding Type"::Nearest:
          exit('=');
        "Invoice Rounding Type"::Up:
          exit('>');
        "Invoice Rounding Type"::Down:
          exit('<');
      end;
    end;
*/


    
    
/*
procedure CheckAmountRoundingPrecision ()
    begin
      TESTFIELD("Unit-Amount Rounding Precision");
      TESTFIELD("Amount Rounding Precision");
    end;
*/


    
//     procedure GetGainLossAccount (DtldCVLedgEntryBuf@1000 :
    
/*
procedure GetGainLossAccount (DtldCVLedgEntryBuf: Record 383) : Code[20];
    begin
      OnBeforeGetGainLossAccount(Rec,DtldCVLedgEntryBuf);

      CASE DtldCVLedgEntryBuf."Entry Type" OF
        DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss":
          exit(GetUnrealizedLossesAccount);
        DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain":
          exit(GetUnrealizedGainsAccount);
        DtldCVLedgEntryBuf."Entry Type"::"Realized Loss":
          exit(GetRealizedLossesAccount);
        DtldCVLedgEntryBuf."Entry Type"::"Realized Gain":
          exit(GetRealizedGainsAccount);
        else
          ERROR(IncorrectEntryTypeErr,DtldCVLedgEntryBuf."Entry Type");
      end;
    end;
*/


    
    
/*
procedure GetRealizedGainsAccount () : Code[20];
    begin
      TESTFIELD("Realized Gains Acc.");
      exit("Realized Gains Acc.");
    end;
*/


    
    
/*
procedure GetRealizedLossesAccount () : Code[20];
    begin
      TESTFIELD("Realized Losses Acc.");
      exit("Realized Losses Acc.");
    end;
*/


    
    
/*
procedure GetRealizedGLGainsAccount () : Code[20];
    begin
      TESTFIELD("Realized G/L Gains Account");
      exit("Realized G/L Gains Account");
    end;
*/


    
    
/*
procedure GetRealizedGLLossesAccount () : Code[20];
    begin
      TESTFIELD("Realized G/L Losses Account");
      exit("Realized G/L Losses Account");
    end;
*/


    
    
/*
procedure GetResidualGainsAccount () : Code[20];
    begin
      TESTFIELD("Residual Gains Account");
      exit("Residual Gains Account");
    end;
*/


    
    
/*
procedure GetResidualLossesAccount () : Code[20];
    begin
      TESTFIELD("Residual Losses Account");
      exit("Residual Losses Account");
    end;
*/


    
    
/*
procedure GetUnrealizedGainsAccount () : Code[20];
    begin
      TESTFIELD("Unrealized Gains Acc.");
      exit("Unrealized Gains Acc.");
    end;
*/


    
    
/*
procedure GetUnrealizedLossesAccount () : Code[20];
    begin
      TESTFIELD("Unrealized Losses Acc.");
      exit("Unrealized Losses Acc.");
    end;
*/


    
    
/*
procedure GetConvLCYRoundingDebitAccount () : Code[20];
    begin
      TESTFIELD("Conv. LCY Rndg. Debit Acc.");
      exit("Conv. LCY Rndg. Debit Acc.");
    end;
*/


    
    
/*
procedure GetConvLCYRoundingCreditAccount () : Code[20];
    begin
      TESTFIELD("Conv. LCY Rndg. Credit Acc.");
      exit("Conv. LCY Rndg. Credit Acc.");
    end;
*/


    
    
/*
procedure GetCurrencySymbol () : Text[10];
    begin
      if Symbol <> '' then
        exit(Symbol);

      exit(Code);
    end;
*/


    
//     procedure ResolveCurrencySymbol (CurrencyCode@1000 :
    
/*
procedure ResolveCurrencySymbol (CurrencyCode: Code[10]) : Text[10];
    var
//       Currency@1001 :
      Currency: Record 4;
//       PoundChar@1002 :
      PoundChar: Char;
//       EuroChar@1003 :
      EuroChar: Char;
//       YenChar@1004 :
      YenChar: Char;
    begin
      if Currency.GET(CurrencyCode) then
        if Currency.Symbol <> '' then
          exit(Currency.Symbol);

      PoundChar := 163;
      YenChar := 165;
      EuroChar := 8364;

      CASE CurrencyCode OF
        'AUD','BND','CAD','FJD','HKD','MXN','NZD','SBD','SGD','USD':
          exit(');
        'GBP':
          exit(FORMAT(PoundChar));
        'DKK','ISK','NOK','SEK':
          exit('kr');
        'EUR':
          exit(FORMAT(EuroChar));
        'CNY','JPY':
          exit(FORMAT(YenChar));
      end;

      exit('');
    end;
*/


    
//     procedure ResolveCurrencyDescription (CurrencyCode@1000 :
    
/*
procedure ResolveCurrencyDescription (CurrencyCode: Code[10]) : Text;
    var
//       Currency@1001 :
      Currency: Record 4;
    begin
      if Currency.GET(CurrencyCode) then
        if Currency.Description <> '' then
          exit(Currency.Description);

      CASE CurrencyCode OF
        'CAD':
          exit(CanadiandollarDescriptionTxt);
        'GBP':
          exit(BritishpoundDescriptionTxt);
        'USD':
          exit(USdollarDescriptionTxt);
        'EUR':
          exit(EuroDescriptionTxt);
      end;

      exit('');
    end;
*/


    
//     procedure ResolveGLCurrencySymbol (CurrencyCode@1000 :
    
/*
procedure ResolveGLCurrencySymbol (CurrencyCode: Code[10]) : Text[10];
    var
//       Currency@1001 :
      Currency: Record 4;
    begin
      if CurrencyCode <> '' then
        exit(Currency.ResolveCurrencySymbol(CurrencyCode));

      GLSetup.GET;
      exit(GLSetup.GetCurrencySymbol);
    end;
*/


    
//     procedure Initialize (CurrencyCode@1000 :
    
/*
procedure Initialize (CurrencyCode: Code[10])
    begin
      if CurrencyCode <> '' then
        GET(CurrencyCode)
      else
        InitRoundingPrecision;
    end;
*/


    
    
/*
procedure SuggestSetupAccounts ()
    var
//       RecRef@1000 :
      RecRef: RecordRef;
    begin
      RecRef.GETTABLE(Rec);
      SuggestGainLossAccounts(RecRef);
      SuggestOtherAccounts(RecRef);
      RecRef.MODIFY;
    end;
*/


//     LOCAL procedure SuggestGainLossAccounts (var RecRef@1000 :
    
/*
LOCAL procedure SuggestGainLossAccounts (var RecRef: RecordRef)
    begin
      if "Unrealized Gains Acc." = '' then
        SuggestAccount(RecRef,FIELDNO("Unrealized Gains Acc."));
      if "Realized Gains Acc." = '' then
        SuggestAccount(RecRef,FIELDNO("Realized Gains Acc."));
      if "Unrealized Losses Acc." = '' then
        SuggestAccount(RecRef,FIELDNO("Unrealized Losses Acc."));
      if "Realized Losses Acc." = '' then
        SuggestAccount(RecRef,FIELDNO("Realized Losses Acc."));
    end;
*/


//     LOCAL procedure SuggestOtherAccounts (var RecRef@1000 :
    
/*
LOCAL procedure SuggestOtherAccounts (var RecRef: RecordRef)
    begin
      if "Realized G/L Gains Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Realized G/L Gains Account"));
      if "Realized G/L Losses Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Realized G/L Losses Account"));
      if "Residual Gains Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Residual Gains Account"));
      if "Residual Losses Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Residual Losses Account"));
      if "Conv. LCY Rndg. Debit Acc." = '' then
        SuggestAccount(RecRef,FIELDNO("Conv. LCY Rndg. Debit Acc."));
      if "Conv. LCY Rndg. Credit Acc." = '' then
        SuggestAccount(RecRef,FIELDNO("Conv. LCY Rndg. Credit Acc."));
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
//       CurrencyRecRef@1005 :
      CurrencyRecRef: RecordRef;
//       CurrencyFieldRef@1006 :
      CurrencyFieldRef: FieldRef;
    begin
      CurrencyRecRef.OPEN(DATABASE::Currency);

      CurrencyRecRef.RESET;
      CurrencyFieldRef := CurrencyRecRef.FIELD(FIELDNO(Code));
      CurrencyFieldRef.SETFILTER('<>%1',Code);
      TempAccountUseBuffer.UpdateBuffer(CurrencyRecRef,AccountFieldNo);
      CurrencyRecRef.CLOSE;

      TempAccountUseBuffer.RESET;
      TempAccountUseBuffer.SETCURRENTKEY("No. of Use");
      if TempAccountUseBuffer.FINDLAST then begin
        RecFieldRef := RecRef.FIELD(AccountFieldNo);
        RecFieldRef.VALUE(TempAccountUseBuffer."Account No.");
      end;
    end;
*/


    
//     LOCAL procedure OnBeforeGetGainLossAccount (var Currency@1000 : Record 4;DtldCVLedgEntryBuffer@1001 :
    
/*
LOCAL procedure OnBeforeGetGainLossAccount (var Currency: Record 4;DtldCVLedgEntryBuffer: Record 383)
    begin
    end;

    /*begin
    end.
  */
}





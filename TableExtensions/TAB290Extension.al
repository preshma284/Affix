tableextension 50165 "QBU VAT Amount LineExt" extends "VAT Amount Line"
{
  
  
    CaptionML=ENU='VAT Amount Line',ESP='L�n. importe IVA';
  
  fields
{
}
  keys
{
   // key(key1;"VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Positive")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text001@1001 :
      Text001: TextConst ENU='VAT Amount',ESP='Importe IVA';
//       Text002@1002 :
      Text002: TextConst ENU='%1 must not be negative.',ESP='%1 no debe ser negativo.';
//       InvoiceDiscAmtIsGreaterThanBaseAmtErr@1003 :
      InvoiceDiscAmtIsGreaterThanBaseAmtErr: 
// 1 Invoice Discount Amount that should be set 2 Maximum Amount that you can assign
TextConst ENU='The maximum %1 that you can apply is %2.',ESP='El %1 m�ximo que puede aplicar es de %2.';
//       Text004@1004 :
      Text004: TextConst ENU='%1 for %2 must not exceed %3 = %4.',ESP='%1 para %2 no debe exceder %3 = %4.';
//       Currency@1005 :
      Currency: Record 4;
//       AllowVATDifference@1006 :
      AllowVATDifference: Boolean;
//       GlobalsInitialized@1008 :
      GlobalsInitialized: Boolean;
//       Text005@1009 :
      Text005: TextConst ENU='%1 must not exceed %2 = %3.',ESP='%1 no debe exceder %2 = %3.';
//       GLSetup@1100002 :
      GLSetup: Record 98;
//       CurrencyCode@1100001 :
      CurrencyCode: Code[10];
//       RoundingPrec@1100000 :
      RoundingPrec: Decimal;
//       Text1100000@1100100 :
      Text1100000: TextConst ENU='VAT+EC Amount',ESP='Importe IVA+RE';
//       "------------------- QB"@1100286000 :
      "------------------- QB": Integer;
//       QB_PositiveFalse@1100286001 :
      QB_PositiveFalse: Boolean;

    
//     procedure CheckVATDifference (NewCurrencyCode@1000 : Code[10];NewAllowVATDifference@1001 :
    
/*
procedure CheckVATDifference (NewCurrencyCode: Code[10];NewAllowVATDifference: Boolean)
    var
//       GLSetup@1003 :
      GLSetup: Record 98;
    begin
      InitGlobals(NewCurrencyCode,NewAllowVATDifference);
      if not AllowVATDifference then begin
        TESTFIELD("VAT Difference",0);
        TESTFIELD("EC Difference",0);
      end;
      if ABS("VAT Difference") > Currency."Max. VAT Difference Allowed" then
        if NewCurrencyCode <> '' then
          ERROR(
            Text004,FIELDCAPTION("VAT Difference"),Currency.Code,
            Currency.FIELDCAPTION("Max. VAT Difference Allowed"),Currency."Max. VAT Difference Allowed")
        else begin
          if GLSetup.GET then;
          if ABS("VAT Difference") > GLSetup."Max. VAT Difference Allowed" then
            ERROR(
              Text005,FIELDCAPTION("VAT Difference"),
              GLSetup.FIELDCAPTION("Max. VAT Difference Allowed"),GLSetup."Max. VAT Difference Allowed");
        end;
      if ABS("EC Difference") > Currency."Max. VAT Difference Allowed" then
        if NewCurrencyCode <> '' then
          ERROR(
            Text004,FIELDCAPTION("EC Difference"),Currency.Code,
            Currency.FIELDCAPTION("Max. VAT Difference Allowed"),Currency."Max. VAT Difference Allowed")
        else begin
          if GLSetup.GET then;
          if ABS("EC Difference") > GLSetup."Max. VAT Difference Allowed" then
            ERROR(
              Text005,FIELDCAPTION("EC Difference"),
              GLSetup.FIELDCAPTION("Max. VAT Difference Allowed"),GLSetup."Max. VAT Difference Allowed");
        end;
    end;
*/


//     LOCAL procedure InitGlobals (NewCurrencyCode@1000 : Code[10];NewAllowVATDifference@1001 :
    
/*
LOCAL procedure InitGlobals (NewCurrencyCode: Code[10];NewAllowVATDifference: Boolean)
    begin
      if GlobalsInitialized then
        exit;

      Currency.Initialize(NewCurrencyCode);
      AllowVATDifference := NewAllowVATDifference;
      GlobalsInitialized := TRUE;
    end;
*/


    
    procedure InsertLine () : Boolean;
    var
//       VATAmountLine@1000 :
      VATAmountLine: Record 290;
    begin
      if CurrencyCode <> '' then begin
        if Currency.GET(CurrencyCode) then;
        RoundingPrec := Currency."Invoice Rounding Precision";
      end else begin
        GLSetup.GET;
        RoundingPrec := GLSetup."Inv. Rounding Precision (LCY)";
      end;

      if not (("VAT Base" <> 0) or ("Amount Including VAT" <> 0)) then
        exit(FALSE);

      Positive := "Line Amount" >= 0;

      if (QB_PositiveFalse) then begin
        Positive := TRUE;
        QB_PositiveFalse := FALSE;
      end;

      VATAmountLine := Rec;
      if FIND then begin
        "Line Amount" += VATAmountLine."Line Amount";
        "Inv. Disc. Base Amount" += VATAmountLine."Inv. Disc. Base Amount";
        "Pmt. Discount Amount" += VATAmountLine."Pmt. Discount Amount";
        "Invoice Discount Amount" += VATAmountLine."Invoice Discount Amount";
        Quantity += VATAmountLine.Quantity;
        "VAT Base" += VATAmountLine."VAT Base";
        "Amount Including VAT" += VATAmountLine."Amount Including VAT";
        "VAT Difference" += VATAmountLine."VAT Difference";
        "EC Difference" += VATAmountLine."EC Difference";
        if "VAT %" + "EC %" <> 0 then begin
          "VAT Amount" :=
            ROUND(
              ("Amount Including VAT" - "VAT Base" - "VAT Difference" - "EC Difference") / ("VAT %" + "EC %") * "VAT %",RoundingPrec) +
            "VAT Difference";
          "EC Amount" :=
            ROUND(
              ("Amount Including VAT" - "VAT Base" - "VAT Difference" - "EC Difference") / ("VAT %" + "EC %") * "EC %",RoundingPrec) +
            "EC Difference";
        end;
        "Calculated VAT Amount" += VATAmountLine."Calculated VAT Amount";
        "Calculated EC Amount" += VATAmountLine."Calculated EC Amount";
        OnInsertLineOnBeforeModify(Rec,VATAmountLine);
        MODIFY;
      end else begin
        if "VAT %" + "EC %" <> 0 then begin
          "VAT Amount" :=
            ROUND(("Amount Including VAT" - "VAT Base" - "EC Difference") / ("VAT %" + "EC %") * "VAT %",RoundingPrec);
          "EC Amount" :=
            ROUND(("Amount Including VAT" - "VAT Base" - "VAT Difference") / ("VAT %" + "EC %") * "EC %",RoundingPrec);
          if "VAT Difference" <> 0 then
            if not VATAmountLine."Prices Including VAT" then
              "VAT Amount" :=
                "VAT Difference" +
                ROUND(
                  "VAT Base" * "VAT %" / 100,Currency."Amount Rounding Precision",Currency.VATRoundingDirection)
            else
              "VAT Amount" :=
                "VAT Difference" +
                ROUND(
                  (CalcLineAmount - "Pmt. Discount Amount" - "VAT Base") / ("VAT %" + "EC %") * "VAT %",
                  Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
          if "EC Difference" <> 0 then
            if not VATAmountLine."Prices Including VAT" then
              "EC Amount" :=
                "EC Difference" +
                ROUND(
                  "VAT Base" * "EC %" / 100,
                  Currency."Amount Rounding Precision",Currency.VATRoundingDirection)
            else
              "EC Amount" :=
                "EC Difference" +
                ROUND(
                  (CalcLineAmount - "Pmt. Discount Amount" - "VAT Base") / ("VAT %" + "EC %") * "EC %",
                  Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
        end;
        INSERT;
      end;

      exit(TRUE);
    end;

    
//     procedure InsertNewLine (VATIdentifier@1000 : Code[20];VATCalcType@1001 : Option;TaxGroupCode@1002 : Code[20];UseTax@1005 : Boolean;TaxRate@1003 : Decimal;IsPositive@1004 : Boolean;IsPrepayment@1006 : Boolean;ECRate@1100000 :
    
/*
procedure InsertNewLine (VATIdentifier: Code[20];VATCalcType: Option;TaxGroupCode: Code[20];UseTax: Boolean;TaxRate: Decimal;IsPositive: Boolean;IsPrepayment: Boolean;ECRate: Decimal)
    begin
      INIT;
      "VAT Identifier" := VATIdentifier;
      "VAT Calculation Type" := VATCalcType;
      "Tax Group Code" := TaxGroupCode;
      "Use Tax" := UseTax;
      "VAT %" := TaxRate;
      "EC %" := ECRate;
      Modified := TRUE;
      Positive := IsPositive;
      "Includes Prepayment" := IsPrepayment;
      INSERT;
    end;
*/


    
//     procedure GetLine (Number@1000 :
    
/*
procedure GetLine (Number: Integer)
    begin
      if Number = 1 then
        FIND('-')
      else
        NEXT;
    end;
*/


    
    
/*
procedure VATAmountText () : Text[30];
    begin
      if COUNT = 1 then begin
        FINDFIRST;
        if "VAT %" <> 0 then
          exit(Text001);
      end;
      exit(Text1100000);
    end;
*/


    
//     procedure GetTotalLineAmount (SubtractVAT@1000 : Boolean;CurrencyCode@1001 :
    
/*
procedure GetTotalLineAmount (SubtractVAT: Boolean;CurrencyCode: Code[10]) : Decimal;
    var
//       LineAmount@1002 :
      LineAmount: Decimal;
    begin
      if SubtractVAT then
        Currency.Initialize(CurrencyCode);

      LineAmount := 0;

      if FIND('-') then
        repeat
          if SubtractVAT then
            LineAmount :=
              LineAmount + ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision")
          else
            LineAmount := LineAmount + "Line Amount";
        until NEXT = 0;

      exit(LineAmount);
    end;
*/


    
    
/*
procedure GetTotalVATAmount () : Decimal;
    begin
      CALCSUMS("VAT Amount","EC Amount");
      exit("VAT Amount" + "EC Amount");
    end;
*/


    
    
/*
procedure GetTotalInvDiscAmount () : Decimal;
    begin
      CALCSUMS("Invoice Discount Amount");
      exit("Invoice Discount Amount");
    end;
*/


    
//     procedure GetTotalInvDiscBaseAmount (SubtractVAT@1000 : Boolean;CurrencyCode@1001 :
    
/*
procedure GetTotalInvDiscBaseAmount (SubtractVAT: Boolean;CurrencyCode: Code[10]) : Decimal;
    var
//       InvDiscBaseAmount@1002 :
      InvDiscBaseAmount: Decimal;
    begin
      if SubtractVAT then
        Currency.Initialize(CurrencyCode);

      InvDiscBaseAmount := 0;

      if FIND('-') then
        repeat
          if SubtractVAT then
            InvDiscBaseAmount :=
              InvDiscBaseAmount +
              ROUND("Inv. Disc. Base Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision")
          else
            InvDiscBaseAmount := InvDiscBaseAmount + "Inv. Disc. Base Amount";
        until NEXT = 0;
      exit(InvDiscBaseAmount);
    end;
*/


    
    
/*
procedure GetTotalVATBase () : Decimal;
    begin
      CALCSUMS("VAT Base");
      exit("VAT Base");
    end;
*/


    
    
/*
procedure GetTotalAmountInclVAT () : Decimal;
    begin
      CALCSUMS("Amount Including VAT");
      exit("Amount Including VAT");
    end;
*/


    
//     procedure GetTotalVATDiscount (CurrencyCode@1001 : Code[10];NewPricesIncludingVAT@1000 :
    
/*
procedure GetTotalVATDiscount (CurrencyCode: Code[10];NewPricesIncludingVAT: Boolean) : Decimal;
    var
//       VATDiscount@1002 :
      VATDiscount: Decimal;
//       VATBase@1003 :
      VATBase: Decimal;
    begin
      Currency.Initialize(CurrencyCode);

      VATDiscount := 0;

      if FIND('-') then
        repeat
          if NewPricesIncludingVAT then
            VATBase += CalcLineAmount * "VAT %" / (100 + "VAT %")
          else
            VATBase += "VAT Base" * "VAT %" / 100;
          VATDiscount :=
            VATDiscount +
            ROUND(
              VATBase,
              Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
            "VAT Amount" + "VAT Difference";
          VATBase := VATBase - ROUND(VATBase,Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
        until NEXT = 0;
      exit(VATDiscount);
    end;
*/


    
    
/*
procedure GetAnyLineModified () : Boolean;
    begin
      if FIND('-') then
        repeat
          if Modified then
            exit(TRUE);
        until NEXT = 0;
      exit(FALSE);
    end;
*/


    
//     procedure SetInvoiceDiscountAmount (NewInvoiceDiscount@1000 : Decimal;NewCurrencyCode@1001 : Code[10];NewPricesIncludingVAT@1002 : Boolean;NewVATBaseDiscPct@1005 :
    
/*
procedure SetInvoiceDiscountAmount (NewInvoiceDiscount: Decimal;NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal)
    var
//       TotalInvDiscBaseAmount@1003 :
      TotalInvDiscBaseAmount: Decimal;
//       NewRemainder@1004 :
      NewRemainder: Decimal;
    begin
      InitGlobals(NewCurrencyCode,FALSE);
      TotalInvDiscBaseAmount := GetTotalInvDiscBaseAmount(FALSE,Currency.Code);
      if TotalInvDiscBaseAmount = 0 then
        exit;
      FIND('-');
      repeat
        if "Inv. Disc. Base Amount" <> 0 then begin
          if TotalInvDiscBaseAmount = 0 then
            NewRemainder := 0
          else
            NewRemainder :=
              NewRemainder + NewInvoiceDiscount * "Inv. Disc. Base Amount" / TotalInvDiscBaseAmount;
          if "Invoice Discount Amount" <> ROUND(NewRemainder,Currency."Amount Rounding Precision") then begin
            VALIDATE(
              "Invoice Discount Amount",ROUND(NewRemainder,Currency."Amount Rounding Precision"));
            CalcVATFields(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
            Modified := TRUE;
            MODIFY;
          end;
          NewRemainder := NewRemainder - "Invoice Discount Amount";
        end;
      until NEXT = 0;
    end;
*/


    
//     procedure SetInvoiceDiscountPercent (NewInvoiceDiscountPct@1000 : Decimal;NewCurrencyCode@1001 : Code[10];NewPricesIncludingVAT@1002 : Boolean;CalcInvDiscPerVATID@1003 : Boolean;NewVATBaseDiscPct@1005 :
    
/*
procedure SetInvoiceDiscountPercent (NewInvoiceDiscountPct: Decimal;NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;CalcInvDiscPerVATID: Boolean;NewVATBaseDiscPct: Decimal)
    var
//       NewRemainder@1004 :
      NewRemainder: Decimal;
    begin
      InitGlobals(NewCurrencyCode,FALSE);
      GLSetup.GET;
      if FIND('-') then
        repeat
          if "Inv. Disc. Base Amount" <> 0 then begin
            CASE GLSetup."Discount Calculation" OF
              GLSetup."Discount Calculation"::"Line Disc. + Inv. Disc. + Payment Disc.",
              GLSetup."Discount Calculation"::"Line Disc. + Inv. Disc. * Payment Disc.":
                NewRemainder :=
                  NewRemainder + NewInvoiceDiscountPct * ("Inv. Disc. Base Amount" + "Line Discount Amount") / 100;
              GLSetup."Discount Calculation"::"Line Disc. * Inv. Disc. * Payment Disc.",
              GLSetup."Discount Calculation"::"Line Disc. * Inv. Disc. + Payment Disc.",
              GLSetup."Discount Calculation"::" ":
                NewRemainder :=
                  NewRemainder + NewInvoiceDiscountPct * "Inv. Disc. Base Amount" / 100;
            end;
            if "Invoice Discount Amount" <> ROUND(NewRemainder,Currency."Amount Rounding Precision") then begin
              VALIDATE(
                "Invoice Discount Amount",ROUND(NewRemainder,Currency."Amount Rounding Precision"));
              CalcVATFields(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
              "VAT Difference" := 0;
              "EC Difference" := 0;
              Modified := TRUE;
              MODIFY;
            end;
            if CalcInvDiscPerVATID then
              NewRemainder := 0
            else
              NewRemainder := NewRemainder - "Invoice Discount Amount";
          end;
        until NEXT = 0;
    end;
*/


//     LOCAL procedure GetCalculatedVAT (NewCurrencyCode@1000 : Code[10];NewPricesIncludingVAT@1001 : Boolean;NewVATBaseDiscPct@1002 :
    
/*
LOCAL procedure GetCalculatedVAT (NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal) : Decimal;
    begin
      InitGlobals(NewCurrencyCode,FALSE);

      if NewPricesIncludingVAT then
        exit(
          ROUND(
            CalcLineAmount * "VAT %" / (100 + "VAT %") * (1 - NewVATBaseDiscPct / 100),
            Currency."Amount Rounding Precision",Currency.VATRoundingDirection));

      exit(
        ROUND(
          CalcLineAmount * "VAT %" / 100 * (1 - NewVATBaseDiscPct / 100),
          Currency."Amount Rounding Precision",Currency.VATRoundingDirection));
    end;
*/


//     LOCAL procedure GetCalculatedEC (NewCurrencyCode@1000 : Code[10];NewPricesIncludingVAT@1001 : Boolean;NewVATBaseDiscPct@1002 :
    
/*
LOCAL procedure GetCalculatedEC (NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal) : Decimal;
    begin
      InitGlobals(NewCurrencyCode,FALSE);

      if NewPricesIncludingVAT then
        exit(
          ROUND(
            CalcLineAmount * "EC %" / (100 + "VAT %" + "EC %") * (1 - NewVATBaseDiscPct / 100),
            Currency."Amount Rounding Precision",Currency.VATRoundingDirection));

      exit(
        ROUND(
          CalcLineAmount * "EC %" / 100 * (1 - NewVATBaseDiscPct / 100),
          Currency."Amount Rounding Precision",Currency.VATRoundingDirection));
    end;
*/


    
/*
procedure CalcLineAmount () : Decimal;
    begin
      exit("Line Amount" - "Invoice Discount Amount");
    end;
*/


    
//     procedure CalcVATFields (NewCurrencyCode@1000 : Code[10];NewPricesIncludingVAT@1001 : Boolean;NewVATBaseDiscPct@1002 :
    
/*
procedure CalcVATFields (NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal)
    begin
      InitGlobals(NewCurrencyCode,FALSE);

      "VAT Amount" := GetCalculatedVAT(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
      "EC Amount" := GetCalculatedEC(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);

      if NewPricesIncludingVAT then begin
        if NewVATBaseDiscPct = 0 then begin
          "Amount Including VAT" := CalcLineAmount;
          "VAT Base" := "Amount Including VAT" - "VAT Amount" - "EC Amount";
        end else begin
          "VAT Base" :=
            ROUND(
              (CalcLineAmount - "Pmt. Discount Amount") / (1 + "VAT %" + "EC %" / 100),Currency."Amount Rounding Precision");
          "Amount Including VAT" := "VAT Base" + "VAT Amount" + "EC Amount";
        end;
      end else begin
        "VAT Base" := CalcLineAmount - "Pmt. Discount Amount";
        "Amount Including VAT" := "VAT Base" + "VAT Amount" + "EC Amount";
      end;
      "Calculated VAT Amount" := "VAT Amount";
      "Calculated EC Amount" := "EC Amount";
      "VAT Difference" := 0;
      "EC Difference" := 0;
      Modified := TRUE;
    end;
*/


    
//     procedure SetCurrencyCode (CurrCode@1000 :
    
/*
procedure SetCurrencyCode (CurrCode: Code[10])
    begin
      CurrencyCode := CurrCode;
    end;
*/


//     LOCAL procedure CalcValueLCY (Value@1003 : Decimal;PostingDate@1006 : Date;CurrencyCode@1005 : Code[10];CurrencyFactor@1004 :
    
/*
LOCAL procedure CalcValueLCY (Value: Decimal;PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal) : Decimal;
    var
//       CurrencyExchangeRate@1000 :
      CurrencyExchangeRate: Record 330;
    begin
      exit(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PostingDate,CurrencyCode,Value,CurrencyFactor));
    end;
*/


    
//     procedure GetBaseLCY (PostingDate@1003 : Date;CurrencyCode@1002 : Code[10];CurrencyFactor@1001 :
    
/*
procedure GetBaseLCY (PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal) : Decimal;
    begin
      exit(ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)));
    end;
*/


    
//     procedure GetAmountLCY (PostingDate@1000 : Date;CurrencyCode@1001 : Code[10];CurrencyFactor@1002 :
    
/*
procedure GetAmountLCY (PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal) : Decimal;
    begin
      exit(
        ROUND(CalcValueLCY("Amount Including VAT",PostingDate,CurrencyCode,CurrencyFactor)) -
        ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)));
    end;
*/


    
//     procedure GetVATAmountLCY (PostingDate@1000 : Date;CurrencyCode@1001 : Code[10];CurrencyFactor@1002 :
    
/*
procedure GetVATAmountLCY (PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal) : Decimal;
    begin
      exit(
        ROUND(CalcValueLCY("Amount Including VAT",PostingDate,CurrencyCode,CurrencyFactor)) -
        ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)) -
        ROUND(CalcValueLCY("EC Amount",PostingDate,CurrencyCode,CurrencyFactor)));
    end;
*/


    
//     procedure GetECAmountLCY (PostingDate@1000 : Date;CurrencyCode@1001 : Code[10];CurrencyFactor@1002 :
    
/*
procedure GetECAmountLCY (PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal) : Decimal;
    begin
      exit(
        ROUND(CalcValueLCY("Amount Including VAT",PostingDate,CurrencyCode,CurrencyFactor)) -
        ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)) -
        ROUND(CalcValueLCY("VAT Amount",PostingDate,CurrencyCode,CurrencyFactor)));
    end;
*/


    
//     procedure DeductVATAmountLine (var VATAmountLineDeduct@1001 :
    
/*
procedure DeductVATAmountLine (var VATAmountLineDeduct: Record 290)
    begin
      if FINDSET then
        repeat
          VATAmountLineDeduct := Rec;
          if VATAmountLineDeduct.FIND then begin
            "VAT Base" -= VATAmountLineDeduct."VAT Base";
            "VAT Amount" -= VATAmountLineDeduct."VAT Amount";
            "EC Amount" -= VATAmountLineDeduct."EC Amount";
            "Amount Including VAT" -= VATAmountLineDeduct."Amount Including VAT";
            "Line Amount" -= VATAmountLineDeduct."Line Amount";
            "Inv. Disc. Base Amount" -= VATAmountLineDeduct."Inv. Disc. Base Amount";
            "Invoice Discount Amount" -= VATAmountLineDeduct."Invoice Discount Amount";
            "Calculated VAT Amount" -= VATAmountLineDeduct."Calculated VAT Amount";
            "VAT Difference" -= VATAmountLineDeduct."VAT Difference";
            MODIFY;
          end;
        until NEXT = 0;
    end;
*/


    
//     procedure SumLine (LineAmount@1001 : Decimal;InvDiscAmount@1002 : Decimal;PmtDiscAmount@1100001 : Decimal;VATDifference@1004 : Decimal;ECDifference@1100000 : Decimal;AllowInvDisc@1003 : Boolean;Prepayment@1005 :
    
/*
procedure SumLine (LineAmount: Decimal;InvDiscAmount: Decimal;PmtDiscAmount: Decimal;VATDifference: Decimal;ECDifference: Decimal;AllowInvDisc: Boolean;Prepayment: Boolean)
    begin
      "Line Amount" += LineAmount;
      if AllowInvDisc then
        "Inv. Disc. Base Amount" += LineAmount;
      "Invoice Discount Amount" += InvDiscAmount;
      "Pmt. Discount Amount" += PmtDiscAmount;
      "VAT Difference" += VATDifference;
      "EC Difference" += ECDifference;
      if Prepayment then
        "Includes Prepayment" := TRUE;
      MODIFY;
    end;
*/


    
//     procedure UpdateLines (var TotalVATAmount@1010 : Decimal;Currency@1012 : Record 4;CurrencyFactor@1003 : Decimal;PricesIncludingVAT@1009 : Boolean;VATBaseDiscountPerc@1008 : Decimal;TaxAreaCode@1007 : Code[20];TaxLiable@1005 : Boolean;PostingDate@1004 :
    
/*
procedure UpdateLines (var TotalVATAmount: Decimal;Currency: Record 4;CurrencyFactor: Decimal;PricesIncludingVAT: Boolean;VATBaseDiscountPerc: Decimal;TaxAreaCode: Code[20];TaxLiable: Boolean;PostingDate: Date)
    var
//       PrevVATAmountLine@1001 :
      PrevVATAmountLine: Record 290;
//       SalesTaxCalculate@1006 :
      SalesTaxCalculate: Codeunit 398;
    begin
      if FINDSET then
        repeat
          if (PrevVATAmountLine."VAT Identifier" <> "VAT Identifier") or
             (PrevVATAmountLine."VAT Calculation Type" <> "VAT Calculation Type") or
             (PrevVATAmountLine."Tax Group Code" <> "Tax Group Code") or
             (PrevVATAmountLine."Use Tax" <> "Use Tax")
          then
            PrevVATAmountLine.INIT;
          if PricesIncludingVAT and not ("VAT %" = 0) then
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"No taxable VAT":
                begin
                  "VAT Base" :=
                    ROUND(
                      (CalcLineAmount - "Pmt. Discount Amount") / (1 + ("VAT %" + "EC %") / 100),
                      Currency."Amount Rounding Precision") - "VAT Difference";
                  if ("VAT %" <> 0) or ("EC %" <> 0) then begin
                    "VAT Amount" :=
                      "VAT Difference" +
                      ROUND(
                        PrevVATAmountLine."VAT Amount" +
                        (CalcLineAmount - "Pmt. Discount Amount" - "VAT Base" - "VAT Difference") *
                        ("VAT %" / ("VAT %" + "EC %")) * (1 - VATBaseDiscountPerc / 100),
                        Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                    "EC Amount" :=
                      "EC Difference" +
                      ROUND(
                        PrevVATAmountLine."EC Amount" +
                        (CalcLineAmount - "Pmt. Discount Amount" - "VAT Base" - "EC Difference") *
                        ("EC %" / ("VAT %" + "EC %")) * (1 - VATBaseDiscountPerc / 100),
                        Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  end;
                  "Amount Including VAT" := "VAT Base" + "VAT Amount" + "EC Amount";
                  if Positive then
                    PrevVATAmountLine.INIT
                  else begin
                    PrevVATAmountLine := Rec;
                    PrevVATAmountLine."VAT Amount" :=
                      (CalcLineAmount - "Pmt. Discount Amount" - "VAT Base" - "VAT Difference") *
                      ("VAT %" / ("VAT %" + "EC %")) * (1 - VATBaseDiscountPerc / 100);
                    PrevVATAmountLine."VAT Amount" :=
                      PrevVATAmountLine."VAT Amount" -
                      ROUND(PrevVATAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                    PrevVATAmountLine."EC Amount" :=
                      (CalcLineAmount - "Pmt. Discount Amount" - "VAT Base" - "EC Difference") *
                      ("EC %" / ("VAT %" + "EC %")) * (1 - VATBaseDiscountPerc / 100);
                    PrevVATAmountLine."EC Amount" :=
                      PrevVATAmountLine."EC Amount" -
                      ROUND(PrevVATAmountLine."EC Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  end;
                end;
              "VAT Calculation Type"::"Reverse Charge VAT":
                begin
                  "VAT Base" :=
                    ROUND(CalcLineAmount - "Pmt. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Amount" := 0;
                  "EC Amount" := 0;
                  "Amount Including VAT" := "VAT Base" ;
                end;
              "VAT Calculation Type"::"Full VAT":
                begin
                  "VAT Base" := 0;
                  "VAT Amount" := "VAT Difference" + CalcLineAmount;
                  "Amount Including VAT" := "VAT Amount";
                end;
              "VAT Calculation Type"::"Sales Tax":
                begin
                  "Amount Including VAT" := CalcLineAmount;
                  if "Use Tax" then
                    "VAT Base" := "Amount Including VAT"
                  else
                    "VAT Base" :=
                      ROUND(
                        SalesTaxCalculate.ReverseCalculateTax(
                          TaxAreaCode,"Tax Group Code",TaxLiable,PostingDate,"Amount Including VAT",Quantity,CurrencyFactor),
                        Currency."Amount Rounding Precision");
                  "VAT Amount" := "VAT Difference" + "Amount Including VAT" - "VAT Base";
                  if "VAT Base" = 0 then begin
                    "VAT %" := 0;
                    "EC %" := 0;
                  end else begin
                    "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                    "EC %" := ROUND(100 * "EC Amount" / "VAT Base",0.00001);
                  end;
                end;
            end
          else
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"No taxable VAT":
                begin
                  "VAT Base" := CalcLineAmount - "Pmt. Discount Amount";
                  "VAT Amount" :=
                    "VAT Difference" +
                    ROUND(
                      PrevVATAmountLine."VAT Amount" +
                      "VAT Base" * "VAT %" / 100 * (1 - VATBaseDiscountPerc / 100),
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "EC Amount" :=
                    "EC Difference" +
                    ROUND(
                      PrevVATAmountLine."EC Amount" +
                      "VAT Base" * "EC %" / 100 * (1 - VATBaseDiscountPerc / 100),
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "Amount Including VAT" :=
                    CalcLineAmount - "Pmt. Discount Amount" + "VAT Amount" + "EC Amount";
                  if Positive then
                    PrevVATAmountLine.INIT
                  else
                    if not "Includes Prepayment" then begin
                      PrevVATAmountLine := Rec;
                      PrevVATAmountLine."VAT Amount" :=
                        "VAT Base" * "VAT %" / 100 * (1 - VATBaseDiscountPerc / 100);
                      PrevVATAmountLine."VAT Amount" :=
                        PrevVATAmountLine."VAT Amount" -
                        ROUND(PrevVATAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      PrevVATAmountLine."EC Amount" :=
                        "VAT Base" * "EC %" / 100 * (1 - VATBaseDiscountPerc / 100);
                      PrevVATAmountLine."EC Amount" :=
                        PrevVATAmountLine."EC Amount" -
                        ROUND(PrevVATAmountLine."EC Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                    end;
                end;
              "VAT Calculation Type"::"Reverse Charge VAT":
                begin
                  "VAT Base" := CalcLineAmount - "Pmt. Discount Amount";
                  "VAT Amount" := 0;
                  "EC Amount" := 0;
                  "Amount Including VAT" := "VAT Base" ;
                end;
              "VAT Calculation Type"::"Full VAT":
                begin
                  "VAT Base" := 0;
                  "VAT Amount" := "VAT Difference" + CalcLineAmount;
                  "Amount Including VAT" := "VAT Amount";
                end;
              "VAT Calculation Type"::"Sales Tax":
                begin
                  "VAT Base" := CalcLineAmount;
                  if "Use Tax" then
                    "VAT Amount" := 0
                  else
                    "VAT Amount" :=
                      SalesTaxCalculate.CalculateTax(
                        TaxAreaCode,"Tax Group Code",TaxLiable,PostingDate,"VAT Base",Quantity,CurrencyFactor);
                  if "VAT Base" = 0 then
                    "VAT %" := 0
                  else
                    "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                  "VAT Amount" :=
                    "VAT Difference" +
                    ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "Amount Including VAT" := "VAT Base" + "VAT Amount" + "EC Amount";
                end;
            end;

          TotalVATAmount -= "VAT Amount";
          "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
          "Calculated EC Amount" := "EC Amount" - "EC Difference";
          MODIFY;
        until NEXT = 0;
    end;
*/


    
//     procedure CopyFromPurchInvLine (PurchInvLine@1000 :
    
/*
procedure CopyFromPurchInvLine (PurchInvLine: Record 123)
    begin
      "VAT Identifier" := PurchInvLine."VAT Identifier";
      "VAT Calculation Type" := PurchInvLine."VAT Calculation Type";
      "Tax Group Code" := PurchInvLine."Tax Group Code";
      "Use Tax" := PurchInvLine."Use Tax";
      "VAT %" := PurchInvLine."VAT %";
      "VAT Base" := PurchInvLine.Amount;
      "VAT Amount" := PurchInvLine."Amount Including VAT" - PurchInvLine.Amount;
      "Amount Including VAT" := PurchInvLine."Amount Including VAT";
      "Line Amount" := PurchInvLine."Line Amount";
      if PurchInvLine."Allow Invoice Disc." then
        "Inv. Disc. Base Amount" := PurchInvLine."Line Amount";
      "Invoice Discount Amount" := PurchInvLine."Inv. Discount Amount";
      Quantity := PurchInvLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        PurchInvLine."Amount Including VAT" - PurchInvLine.Amount - PurchInvLine."VAT Difference";
      "VAT Difference" := PurchInvLine."VAT Difference";
      "EC %" := PurchInvLine."EC %";
      "EC Difference" := PurchInvLine."EC Difference";

      OnAfterCopyFromPurchInvLine(Rec,PurchInvLine);
    end;
*/


    
//     procedure CopyFromPurchCrMemoLine (PurchCrMemoLine@1000 :
    
/*
procedure CopyFromPurchCrMemoLine (PurchCrMemoLine: Record 125)
    begin
      "VAT Identifier" := PurchCrMemoLine."VAT Identifier";
      "VAT Calculation Type" := PurchCrMemoLine."VAT Calculation Type";
      "Tax Group Code" := PurchCrMemoLine."Tax Group Code";
      "Use Tax" := PurchCrMemoLine."Use Tax";
      "VAT %" := PurchCrMemoLine."VAT %";
      "VAT Base" := PurchCrMemoLine.Amount;
      "VAT Amount" := PurchCrMemoLine."Amount Including VAT" - PurchCrMemoLine.Amount;
      "Amount Including VAT" := PurchCrMemoLine."Amount Including VAT";
      "Line Amount" := PurchCrMemoLine."Line Amount";
      if PurchCrMemoLine."Allow Invoice Disc." then
        "Inv. Disc. Base Amount" := PurchCrMemoLine."Line Amount";
      "Invoice Discount Amount" := PurchCrMemoLine."Inv. Discount Amount";
      Quantity := PurchCrMemoLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        PurchCrMemoLine."Amount Including VAT" - PurchCrMemoLine.Amount - PurchCrMemoLine."VAT Difference";
      "VAT Difference" := PurchCrMemoLine."VAT Difference";
      "EC %" := PurchCrMemoLine."EC %";
      "EC Difference" := PurchCrMemoLine."EC Difference";

      OnAfterCopyFromPurchCrMemoLine(Rec,PurchCrMemoLine);
    end;
*/


    
//     procedure CopyFromSalesInvLine (SalesInvLine@1000 :
    
/*
procedure CopyFromSalesInvLine (SalesInvLine: Record 113)
    begin
      "VAT Identifier" := SalesInvLine."VAT Identifier";
      "VAT Calculation Type" := SalesInvLine."VAT Calculation Type";
      "Tax Group Code" := SalesInvLine."Tax Group Code";
      "VAT %" := SalesInvLine."VAT %";
      "VAT Base" := SalesInvLine.Amount;
      "VAT Amount" := SalesInvLine."Amount Including VAT" - SalesInvLine.Amount;
      "Amount Including VAT" := SalesInvLine."Amount Including VAT";
      "Line Amount" := SalesInvLine."Line Amount";
      if SalesInvLine."Allow Invoice Disc." then
        "Inv. Disc. Base Amount" := SalesInvLine."Line Amount";
      "Invoice Discount Amount" := SalesInvLine."Inv. Discount Amount";
      Quantity := SalesInvLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        SalesInvLine."Amount Including VAT" - SalesInvLine.Amount - SalesInvLine."VAT Difference";
      "VAT Difference" := SalesInvLine."VAT Difference";
      "EC %" := SalesInvLine."EC %";
      "EC Difference" := SalesInvLine."EC Difference";

      OnAfterCopyFromSalesInvLine(Rec,SalesInvLine);
    end;
*/


    
//     procedure CopyFromSalesCrMemoLine (SalesCrMemoLine@1000 :
    
/*
procedure CopyFromSalesCrMemoLine (SalesCrMemoLine: Record 115)
    begin
      "VAT Identifier" := SalesCrMemoLine."VAT Identifier";
      "VAT Calculation Type" := SalesCrMemoLine."VAT Calculation Type";
      "Tax Group Code" := SalesCrMemoLine."Tax Group Code";
      "VAT %" := SalesCrMemoLine."VAT %";
      "VAT Base" := SalesCrMemoLine.Amount;
      "VAT Amount" := SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount;
      "Amount Including VAT" := SalesCrMemoLine."Amount Including VAT";
      "Line Amount" := SalesCrMemoLine."Line Amount";
      if SalesCrMemoLine."Allow Invoice Disc." then
        "Inv. Disc. Base Amount" := SalesCrMemoLine."Line Amount";
      "Invoice Discount Amount" := SalesCrMemoLine."Inv. Discount Amount";
      Quantity := SalesCrMemoLine."Quantity (Base)";
      "Calculated VAT Amount" := SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount - SalesCrMemoLine."VAT Difference";
      "VAT Difference" := SalesCrMemoLine."VAT Difference";
      "EC %" := SalesCrMemoLine."EC %";
      "EC Difference" := SalesCrMemoLine."EC Difference";

      OnAfterCopyFromSalesCrMemoLine(Rec,SalesCrMemoLine);
    end;
*/


    
//     procedure CopyFromServInvLine (ServInvLine@1000 :
    
/*
procedure CopyFromServInvLine (ServInvLine: Record 5993)
    begin
      "VAT Identifier" := ServInvLine."VAT Identifier";
      "VAT Calculation Type" := ServInvLine."VAT Calculation Type";
      "Tax Group Code" := ServInvLine."Tax Group Code";
      "VAT %" := ServInvLine."VAT %";
      "VAT Base" := ServInvLine.Amount;
      "VAT Amount" := ServInvLine."Amount Including VAT" - ServInvLine.Amount;
      "Amount Including VAT" := ServInvLine."Amount Including VAT";
      "Line Amount" := ServInvLine."Line Amount";
      if ServInvLine."Allow Invoice Disc." then
        "Inv. Disc. Base Amount" := ServInvLine."Line Amount";
      "Invoice Discount Amount" := ServInvLine."Inv. Discount Amount";
      Quantity := ServInvLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        ServInvLine."Amount Including VAT" - ServInvLine.Amount - ServInvLine."VAT Difference";
      "VAT Difference" := ServInvLine."VAT Difference";
      "EC %" := ServInvLine."EC %";
      "EC Difference" := ServInvLine."EC Difference";

      OnAfterCopyFromServInvLine(Rec,ServInvLine);
    end;
*/


    
//     procedure CopyFromServCrMemoLine (ServCrMemoLine@1000 :
    
/*
procedure CopyFromServCrMemoLine (ServCrMemoLine: Record 5995)
    begin
      "VAT Identifier" := ServCrMemoLine."VAT Identifier";
      "VAT Calculation Type" := ServCrMemoLine."VAT Calculation Type";
      "Tax Group Code" := ServCrMemoLine."Tax Group Code";
      "VAT %" := ServCrMemoLine."VAT %";
      "VAT Base" := ServCrMemoLine.Amount;
      "VAT Amount" := ServCrMemoLine."Amount Including VAT" - ServCrMemoLine.Amount;
      "Amount Including VAT" := ServCrMemoLine."Amount Including VAT";
      "Line Amount" := ServCrMemoLine."Line Amount";
      if ServCrMemoLine."Allow Invoice Disc." then
        "Inv. Disc. Base Amount" := ServCrMemoLine."Line Amount";
      "Invoice Discount Amount" := ServCrMemoLine."Inv. Discount Amount";
      Quantity := ServCrMemoLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        ServCrMemoLine."Amount Including VAT" - ServCrMemoLine.Amount - ServCrMemoLine."VAT Difference";
      "VAT Difference" := ServCrMemoLine."VAT Difference";
      "EC %" := ServCrMemoLine."EC %";
      "EC Difference" := ServCrMemoLine."EC Difference";

      OnAfterCopyFromServCrMemoLine(Rec,ServCrMemoLine);
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromPurchInvLine (var VATAmountLine@1000 : Record 290;PurchInvLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromPurchInvLine (var VATAmountLine: Record 290;PurchInvLine: Record 123)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromPurchCrMemoLine (var VATAmountLine@1000 : Record 290;PurchCrMemoLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromPurchCrMemoLine (var VATAmountLine: Record 290;PurchCrMemoLine: Record 125)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromSalesInvLine (var VATAmountLine@1000 : Record 290;SalesInvoiceLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromSalesInvLine (var VATAmountLine: Record 290;SalesInvoiceLine: Record 113)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromSalesCrMemoLine (var VATAmountLine@1000 : Record 290;SalesCrMemoLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromSalesCrMemoLine (var VATAmountLine: Record 290;SalesCrMemoLine: Record 115)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromServInvLine (var VATAmountLine@1000 : Record 290;ServiceInvoiceLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromServInvLine (var VATAmountLine: Record 290;ServiceInvoiceLine: Record 5993)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyFromServCrMemoLine (var VATAmountLine@1000 : Record 290;ServiceCrMemoLine@1001 :
    
/*
LOCAL procedure OnAfterCopyFromServCrMemoLine (var VATAmountLine: Record 290;ServiceCrMemoLine: Record 5995)
    begin
    end;
*/


    
//     LOCAL procedure OnInsertLineOnBeforeModify (var VATAmountLine@1000 : Record 290;FromVATAmountLine@1001 :
    

LOCAL procedure OnInsertLineOnBeforeModify (var VATAmountLine: Record 290;FromVATAmountLine: Record 290)
    begin
    end;



    
/*
procedure QB_SetPositiveFalse ()
    begin
      QB_PositiveFalse := TRUE;
    end;

    /*begin
    //{
//      JAV 29/07/20: - Nuevo par�metro para sumar l�neas positivas y negativas juntas
//    }
    end.
  */
}






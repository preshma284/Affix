pageextension 50156 MyExtension232 extends 232//21
{
layout
{
addafter("ApplyingCustLedgEntry.""Document Type""")
{
    field("QB_JobNo";rec."QB Job No.")
    {
        
}
} addafter("Customer No.")
{
}

}

actions
{


}

//trigger

//trigger

var
      ApplyingCustLedgEntry : Record 21 TEMPORARY ;
      AppliedCustLedgEntry : Record 21;
      Currency : Record 4;
      CurrExchRate : Record 330;
      GenJnlLine : Record 81;
      GenJnlLine2 : Record 81;
      SalesHeader : Record 36;
      ServHeader : Record 5900;
      Cust : Record 18;
      CustLedgEntry : Record 21;
      GLSetup : Record 98;
      TotalSalesLine : Record 37;
      TotalSalesLineLCY : Record 37;
      TotalServLine : Record 5902;
      TotalServLineLCY : Record 5902;
      CustEntrySetApplID : Codeunit 101;
      GenJnlApply : Codeunit 225;
      SalesPost : Codeunit 80;
      PaymentToleranceMgt : Codeunit 426;
      Navigate : Page 344;
      AppliedAmount : Decimal;
      ApplyingAmount : Decimal;
      PmtDiscAmount : Decimal;
      ApplnDate : Date;
      ApplnCurrencyCode : Code[10];
      ApplnRoundingPrecision : Decimal;
      ApplnRounding : Decimal;
      ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
      AmountRoundingPrecision : Decimal;
      VATAmount : Decimal;
      VATAmountText : Text[30];
      StyleTxt : Text;
      ProfitLCY : Decimal;
      ProfitPct : Decimal;
      CalcType: Option "Direct","GenJnlLine","SalesHeader","ServHeader";
      CustEntryApplID : Code[50];
      ValidExchRate : Boolean;
      DifferentCurrenciesInAppln : Boolean;
      Text002 : TextConst ENU='You must select an applying entry before you can post the application.',ESP='Seleccione un movimiento de liquidaci¢n antes de registrar la liquidaci¢n.';
      ShowAppliedEntries : Boolean;
      Text003 : TextConst ENU='You must post the application from the window where you entered the applying entry.',ESP='Registre la liquidaci¢n desde la ventana en la que registro el movimiento.';
      CannotSetAppliesToIDErr : TextConst ENU='You cannot set Applies-to ID while selecting Applies-to Doc. No.',ESP='No puede establecer el id. de liquidaci¢n al seleccionar Liq. por n§ de documento.';
      OK : Boolean;
      EarlierPostingDateErr : TextConst ENU='You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.',ESP='No puede liquidar ni registrar un movimiento en un movimiento con una fecha de registro anterior.\\En su lugar, registre el documento de tipo %1 con el n£mero %2 y luego liqu¡delo en documento de tipo %3 con el n£mero %4.';
      PostingDone : Boolean;
      AppliesToIDVisible : Boolean ;
      Text012 : TextConst ENU='The application was successfully posted.',ESP='La liquidaci¢n se ha registrado correctamente.';
      Text013 : TextConst ENU='The %1 entered must not be before the %1 on the %2.',ESP='El %1 introducido no debe estar antes del %1 en %2.';
      Text019 : TextConst ENU='Post application process has been canceled.',ESP='Se ha cancelado el proceso Registrar liquidaci¢n marcada.';

    

//procedure
//procedure SetGenJnlLine(NewGenJnlLine : Record 81;ApplnTypeSelect : Integer);
//    begin
//      GenJnlLine := NewGenJnlLine;
//
//      if ( GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer  )then
//        ApplyingAmount := GenJnlLine.Amount;
//      if ( GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer  )then
//        ApplyingAmount := -GenJnlLine.Amount;
//      ApplnDate := GenJnlLine."Posting Date";
//      ApplnCurrencyCode := GenJnlLine."Currency Code";
//      CalcType := CalcType::GenJnlLine;
//
//      CASE ApplnTypeSelect OF
//        GenJnlLine.FIELDNO(rec."Applies-to Doc. No."):
//          ApplnType := ApplnType::"Applies-to Doc. No.";
//        GenJnlLine.FIELDNO(rec."Applies-to ID"):
//          ApplnType := ApplnType::"Applies-to ID";
//      end;
//
//      SetApplyingCustLedgEntry;
//    end;
//
//    //[External]
//procedure SetSales(NewSalesHeader : Record 36;var NewCustLedgEntry : Record 21;ApplnTypeSelect : Integer);
//    var
//      TotalAdjCostLCY : Decimal;
//    begin
//      SalesHeader := NewSalesHeader;
//      Rec.COPYFILTERS(NewCustLedgEntry);
//
//      SalesPost.SumSalesLines(
//        SalesHeader,0,TotalSalesLine,TotalSalesLineLCY,
//        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
//
//      CASE SalesHeader."Document Type" OF
//        SalesHeader."Document Type"::"Return Order",
//        SalesHeader."Document Type"::"Credit Memo":
//          ApplyingAmount := -TotalSalesLine."Amount Including VAT"
//        ELSE
//          ApplyingAmount := TotalSalesLine."Amount Including VAT";
//      end;
//
//      ApplnDate := SalesHeader."Posting Date";
//      ApplnCurrencyCode := SalesHeader."Currency Code";
//      CalcType := CalcType::SalesHeader;
//
//      CASE ApplnTypeSelect OF
//        SalesHeader.FIELDNO(rec."Applies-to Doc. No."):
//          ApplnType := ApplnType::"Applies-to Doc. No.";
//        SalesHeader.FIELDNO(rec."Applies-to ID"):
//          ApplnType := ApplnType::"Applies-to ID";
//      end;
//
//      SetApplyingCustLedgEntry;
//    end;
//
//    //[External]
//procedure SetService(NewServHeader : Record 5900;var NewCustLedgEntry : Record 21;ApplnTypeSelect : Integer);
//    var
//      ServAmountsMgt : Codeunit 5986;
//      TotalAdjCostLCY : Decimal;
//    begin
//      ServHeader := NewServHeader;
//      Rec.COPYFILTERS(NewCustLedgEntry);
//
//      ServAmountsMgt.SumServiceLines(
//        ServHeader,0,TotalServLine,TotalServLineLCY,
//        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
//
//      CASE ServHeader."Document Type" OF
//        ServHeader."Document Type"::"Credit Memo":
//          ApplyingAmount := -TotalServLine."Amount Including VAT"
//        ELSE
//          ApplyingAmount := TotalServLine."Amount Including VAT";
//      end;
//
//      ApplnDate := ServHeader."Posting Date";
//      ApplnCurrencyCode := ServHeader."Currency Code";
//      CalcType := CalcType::ServHeader;
//
//      CASE ApplnTypeSelect OF
//        ServHeader.FIELDNO(rec."Applies-to Doc. No."):
//          ApplnType := ApplnType::"Applies-to Doc. No.";
//        ServHeader.FIELDNO(rec."Applies-to ID"):
//          ApplnType := ApplnType::"Applies-to ID";
//      end;
//
//      SetApplyingCustLedgEntry;
//    end;
//
//    //[External]
//procedure SetCustLedgEntry(NewCustLedgEntry : Record 21);
//    begin
//      Rec := NewCustLedgEntry;
//    end;
//
//    //[External]
//procedure SetApplyingCustLedgEntry();
//    var
//      Customer : Record 18;
//    begin
//      CASE CalcType OF
//        CalcType::SalesHeader:
//          begin
//            ApplyingCustLedgEntry."Entry No." := 1;
//            ApplyingCustLedgEntry."Posting Date" := SalesHeader."Posting Date";
//            if ( SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order"  )then
//              ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type"::"Credit Memo"
//            ELSE
//              ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type";
//            ApplyingCustLedgEntry."Document No." := SalesHeader."No.";
//            ApplyingCustLedgEntry."Customer No." := SalesHeader."Bill-to Customer No.";
//            ApplyingCustLedgEntry.Description := SalesHeader."Posting Description";
//            ApplyingCustLedgEntry."Currency Code" := SalesHeader."Currency Code";
//            if ( ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."Document Type"::"Credit Memo"  )then  begin
//              ApplyingCustLedgEntry.Amount := -TotalSalesLine."Amount Including VAT";
//              ApplyingCustLedgEntry."Remaining Amount" := -TotalSalesLine."Amount Including VAT";
//            end ELSE begin
//              ApplyingCustLedgEntry.Amount := TotalSalesLine."Amount Including VAT";
//              ApplyingCustLedgEntry."Remaining Amount" := TotalSalesLine."Amount Including VAT";
//            end;
//            rec.CalcApplnAmount;
//          end;
//        CalcType::ServHeader:
//          begin
//            ApplyingCustLedgEntry."Entry No." := 1;
//            ApplyingCustLedgEntry."Posting Date" := ServHeader."Posting Date";
//            ApplyingCustLedgEntry."Document Type" := ServHeader."Document Type";
//            ApplyingCustLedgEntry."Document No." := ServHeader."No.";
//            ApplyingCustLedgEntry."Customer No." := ServHeader."Bill-to Customer No.";
//            ApplyingCustLedgEntry.Description := ServHeader."Posting Description";
//            ApplyingCustLedgEntry."Currency Code" := ServHeader."Currency Code";
//            if ( ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."Document Type"::"Credit Memo"  )then  begin
//              ApplyingCustLedgEntry.Amount := -TotalServLine."Amount Including VAT";
//              ApplyingCustLedgEntry."Remaining Amount" := -TotalServLine."Amount Including VAT";
//            end ELSE begin
//              ApplyingCustLedgEntry.Amount := TotalServLine."Amount Including VAT";
//              ApplyingCustLedgEntry."Remaining Amount" := TotalServLine."Amount Including VAT";
//            end;
//            rec.CalcApplnAmount;
//          end;
//        CalcType::Direct:
//          begin
//            if ( rec."Applying Entry"  )then begin
//              if ( ApplyingCustLedgEntry."Entry No." <> 0  )then
//                CustLedgEntry := ApplyingCustLedgEntry;
//              CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
//              if ( rec."Applies-to ID" = ''  )then
//                SetCustApplId(FALSE);
//              Rec.CALCFIELDS("Amount");
//              ApplyingCustLedgEntry := Rec;
//              if ( CustLedgEntry."Entry No." <> 0  )then begin
//                Rec := CustLedgEntry;
//                rec."Applying Entry" := FALSE;
//                SetCustApplId(FALSE);
//              end;
//              Rec.SETFILTER("Entry No.",'<> %1',ApplyingCustLedgEntry."Entry No.");
//              ApplyingAmount := ApplyingCustLedgEntry."Remaining Amount";
//              ApplnDate := ApplyingCustLedgEntry."Posting Date";
//              ApplnCurrencyCode := ApplyingCustLedgEntry."Currency Code";
//            end;
//            rec.CalcApplnAmount;
//          end;
//        CalcType::GenJnlLine:
//          begin
//            ApplyingCustLedgEntry."Entry No." := 1;
//            ApplyingCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
//            ApplyingCustLedgEntry."Document Type" := GenJnlLine."Document Type";
//            ApplyingCustLedgEntry."Document No." := GenJnlLine."Document No.";
//            if ( GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Customer  )then begin
//              ApplyingCustLedgEntry."Customer No." := GenJnlLine."Bal. Account No.";
//              Customer.GET(ApplyingCustLedgEntry."Customer No.");
//              ApplyingCustLedgEntry.Description := Customer.Name;
//            end ELSE begin
//              ApplyingCustLedgEntry."Customer No." := GenJnlLine."Account No.";
//              ApplyingCustLedgEntry.Description := GenJnlLine.Description;
//            end;
//            ApplyingCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
//            ApplyingCustLedgEntry.Amount := GenJnlLine.Amount;
//            ApplyingCustLedgEntry."Remaining Amount" := GenJnlLine.Amount;
//            rec.CalcApplnAmount;
//          end;
//      end;
//    end;
//
//    //[External]
//procedure SetCustApplId(CurrentRec : Boolean);
//    begin
//      if ( (CalcType = CalcType::GenJnlLine) and (ApplyingCustLedgEntry."Posting Date" < rec."Posting Date")  )then
//        ERROR(
//          EarlierPostingDateErr,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
//          rec."Document Type",rec."Document No.");
//
//      if ( ApplyingCustLedgEntry."Entry No." <> 0  )then
//        GenJnlApply.CheckAgainstApplnCurrency(
//          ApplnCurrencyCode,rec."Currency Code",GenJnlLine."Account Type"::Customer,TRUE);
//
//      CustLedgEntry.COPY(Rec);
//      if ( CurrentRec  )then begin
//        CustLedgEntry.SETRECFILTER;
//        CustEntrySetApplID.SetApplId(CustLedgEntry,ApplyingCustLedgEntry,rec."Applies-to ID")
//      end ELSE begin
//        CurrPage.SETSELECTIONFILTER(CustLedgEntry);
//        CustEntrySetApplID.SetApplId(CustLedgEntry,ApplyingCustLedgEntry,GetAppliesToID)
//      end;
//
//      rec.CalcApplnAmount;
//    end;
//Local procedure GetAppliesToID() AppliesToID : Code[50];
//    begin
//      CASE CalcType OF
//        CalcType::GenJnlLine:
//          AppliesToID := GenJnlLine."Applies-to ID";
//        CalcType::SalesHeader:
//          AppliesToID := SalesHeader."Applies-to ID";
//        CalcType::ServHeader:
//          AppliesToID := ServHeader."Applies-to ID";
//      end;
//    end;
//
//    //[External]
//procedure CalcApplnAmount();
//    begin
//      AppliedAmount := 0;
//      PmtDiscAmount := 0;
//      DifferentCurrenciesInAppln := FALSE;
//
//      CASE CalcType OF
//        CalcType::Direct:
//          begin
//            FindAmountRounding;
//            CustEntryApplID := USERID;
//            if ( CustEntryApplID = ''  )then
//              CustEntryApplID := '***';
//
//            CustLedgEntry := ApplyingCustLedgEntry;
//
//            AppliedCustLedgEntry.SETCURRENTKEY("Customer No.","Open","Positive");
//            AppliedCustLedgEntry.SETRANGE("Customer No.",rec."Customer No.");
//            AppliedCustLedgEntry.SETRANGE("Open",TRUE);
//            AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
//
//            if ( ApplyingCustLedgEntry."Entry No." <> 0  )then begin
//              CustLedgEntry.CALCFIELDS("Remaining Amount");
//              AppliedCustLedgEntry.SETFILTER("Entry No.",'<>%1',ApplyingCustLedgEntry."Entry No.");
//            end;
//
//            HandleChosenEntries(0,CustLedgEntry."Remaining Amount",CustLedgEntry."Currency Code",CustLedgEntry."Posting Date");
//          end;
//        CalcType::GenJnlLine:
//          begin
//            FindAmountRounding;
//            if ( GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer  )then
//              CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);
//
//            CASE ApplnType OF
//              ApplnType::"Applies-to Doc. No.":
//                begin
//                  AppliedCustLedgEntry := Rec;
//                  WITH AppliedCustLedgEntry DO begin
//                    Rec.CALCFIELDS("Remaining Amount");
//                    if ( rec."Currency Code" <> ApplnCurrencyCode  )then begin
//                      rec."Remaining Amount" :=
//                        CurrExchRate.ExchangeAmtFCYToFCY(
//                          ApplnDate,rec."Currency Code",ApplnCurrencyCode,rec."Remaining Amount");
//                      rec."Remaining Pmt. Disc. Possible" :=
//                        CurrExchRate.ExchangeAmtFCYToFCY(
//                          ApplnDate,rec."Currency Code",ApplnCurrencyCode,rec."Remaining Pmt. Disc. Possible");
//                      rec."Amount to Apply" :=
//                        CurrExchRate.ExchangeAmtFCYToFCY(
//                          ApplnDate,rec."Currency Code",ApplnCurrencyCode,rec."Amount to Apply");
//                    end;
//
//                    if ( rec."Amount to Apply" <> 0  )then
//                      AppliedAmount := ROUND(rec."Amount to Apply",AmountRoundingPrecision)
//                    ELSE
//                      AppliedAmount := ROUND(rec."Remaining Amount",AmountRoundingPrecision);
//
//                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(
//                         GenJnlLine,AppliedCustLedgEntry,0,FALSE) and
//                       ((ABS(GenJnlLine.Amount) + ApplnRoundingPrecision >=
//                         ABS(AppliedAmount - rec."Remaining Pmt. Disc. Possible")) or
//                        (GenJnlLine.Amount = 0))
//                    then
//                      PmtDiscAmount := rec."Remaining Pmt. Disc. Possible";
//
//                    if ( not DifferentCurrenciesInAppln  )then
//                      DifferentCurrenciesInAppln := ApplnCurrencyCode <> rec."Currency Code";
//                  end;
//                  CheckRounding;
//                end;
//              ApplnType::"Applies-to ID":
//                begin
//                  GenJnlLine2 := GenJnlLine;
//                  AppliedCustLedgEntry.SETCURRENTKEY("Customer No.","Open","Positive");
//                  AppliedCustLedgEntry.SETRANGE("Customer No.",GenJnlLine."Account No.");
//                  AppliedCustLedgEntry.SETRANGE("Open",TRUE);
//                  AppliedCustLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
//
//                  HandleChosenEntries(1,GenJnlLine2.Amount,GenJnlLine2."Currency Code",GenJnlLine2."Posting Date");
//                end;
//            end;
//          end;
//        CalcType::SalesHeader,CalcType::ServHeader:
//          begin
//            FindAmountRounding;
//
//            CASE ApplnType OF
//              ApplnType::"Applies-to Doc. No.":
//                begin
//                  AppliedCustLedgEntry := Rec;
//                  WITH AppliedCustLedgEntry DO begin
//                    Rec.CALCFIELDS("Remaining Amount");
//
//                    if ( rec."Currency Code" <> ApplnCurrencyCode  )then
//                      rec."Remaining Amount" :=
//                        CurrExchRate.ExchangeAmtFCYToFCY(
//                          ApplnDate,rec."Currency Code",ApplnCurrencyCode,rec."Remaining Amount");
//
//                    AppliedAmount := ROUND(rec."Remaining Amount",AmountRoundingPrecision);
//
//                    if ( not DifferentCurrenciesInAppln  )then
//                      DifferentCurrenciesInAppln := ApplnCurrencyCode <> rec."Currency Code";
//                  end;
//                  CheckRounding;
//                end;
//              ApplnType::"Applies-to ID":
//                begin
//                  AppliedCustLedgEntry.SETCURRENTKEY("Customer No.","Open","Positive");
//                  if ( CalcType = CalcType::SalesHeader  )then
//                    AppliedCustLedgEntry.SETRANGE("Customer No.",SalesHeader."Bill-to Customer No.")
//                  ELSE
//                    AppliedCustLedgEntry.SETRANGE("Customer No.",ServHeader."Bill-to Customer No.");
//                  AppliedCustLedgEntry.SETRANGE("Open",TRUE);
//                  AppliedCustLedgEntry.SETRANGE("Applies-to ID",GetAppliesToID);
//
//                  HandleChosenEntries(2,ApplyingAmount,ApplnCurrencyCode,ApplnDate);
//                end;
//            end;
//          end;
//      end;
//
//      OnAfterCalcApplnAmount(Rec,AppliedAmount,ApplyingAmount);
//    end;
//Local procedure CalcApplnRemainingAmount(rec."Amount" : Decimal) : Decimal;
//    var
//      ApplnRemainingAmount : Decimal;
//    begin
//      ValidExchRate := TRUE;
//      if ( ApplnCurrencyCode = rec."Currency Code"  )then
//        exit(rec."Amount");
//
//      if ( ApplnDate = 0D  )then
//        ApplnDate := rec."Posting Date";
//      ApplnRemainingAmount :=
//        CurrExchRate.ApplnExchangeAmtFCYToFCY(
//          ApplnDate,rec."Currency Code",ApplnCurrencyCode,rec."Amount",ValidExchRate);
//
//      OnAfterCalcApplnRemainingAmount(Rec,ApplnRemainingAmount);
//      exit(ApplnRemainingAmount);
//    end;
//Local procedure CalcApplnAmountToApply(AmountToApply : Decimal) : Decimal;
//    var
//      ApplnAmountToApply : Decimal;
//    begin
//      ValidExchRate := TRUE;
//
//      if ( ApplnCurrencyCode = rec."Currency Code"  )then
//        exit(AmountToApply);
//
//      if ( ApplnDate = 0D  )then
//        ApplnDate := rec."Posting Date";
//      ApplnAmountToApply :=
//        CurrExchRate.ApplnExchangeAmtFCYToFCY(
//          ApplnDate,rec."Currency Code",ApplnCurrencyCode,AmountToApply,ValidExchRate);
//
//      OnAfterCalcApplnAmountToApply(Rec,ApplnAmountToApply);
//      exit(ApplnAmountToApply);
//    end;
//Local procedure FindAmountRounding();
//    begin
//      if ( ApplnCurrencyCode = ''  )then begin
//        Currency.INIT;
//        Currency.Code := '';
//        Currency.InitRoundingPrecision;
//      end ELSE
//        if ( ApplnCurrencyCode <> Currency.Code  )then
//          Currency.GET(ApplnCurrencyCode);
//
//      AmountRoundingPrecision := Currency."Amount Rounding Precision";
//    end;
//
//    //[External]
//procedure CheckRounding();
//    begin
//      ApplnRounding := 0;
//
//      CASE CalcType OF
//        CalcType::SalesHeader,CalcType::ServHeader:
//          exit;
//        CalcType::GenJnlLine:
//          if (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment) and
//             (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Refund)
//          then
//            exit;
//      end;
//
//      if ( ApplnCurrencyCode = ''  )then
//        ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
//      ELSE begin
//        if ( ApplnCurrencyCode <> rec."Currency Code"  )then
//          Currency.GET(ApplnCurrencyCode);
//        ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
//      end;
//
//      if ( (ABS((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) and DifferentCurrenciesInAppln  )then
//        ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
//    end;
//
//    //[External]
//procedure GetCustLedgEntry(var CustLedgEntry : Record 21);
//    begin
//      CustLedgEntry := Rec;
//    end;
//Local procedure FindApplyingEntry();
//    begin
//      if ( CalcType = CalcType::Direct  )then begin
//        CustEntryApplID := USERID;
//        if ( CustEntryApplID = ''  )then
//          CustEntryApplID := '***';
//
//        CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID","Open");
//        CustLedgEntry.SETRANGE("Customer No.",rec."Customer No.");
//        CustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
//        CustLedgEntry.SETRANGE("Open",TRUE);
//        CustLedgEntry.SETRANGE("Applying Entry",TRUE);
//        if ( CustLedgEntry.FINDFIRST  )then begin
//          CustLedgEntry.CALCFIELDS("Amount","Remaining Amount");
//          ApplyingCustLedgEntry := CustLedgEntry;
//          SETFILTER("Entry No.",'<>%1',CustLedgEntry."Entry No.");
//          ApplyingAmount := CustLedgEntry."Remaining Amount";
//          ApplnDate := CustLedgEntry."Posting Date";
//          ApplnCurrencyCode := CustLedgEntry."Currency Code";
//        end;
//        rec.CalcApplnAmount;
//      end;
//    end;
//Local procedure HandleChosenEntries(Type: Option "Direct","GenJnlLine","SalesHeader";CurrentAmount : Decimal;CurrencyCode : Code[10];PostingDate : Date);
//    var
//      TempAppliedCustLedgEntry : Record 21 TEMPORARY ;
//      PossiblePmtDisc : Decimal;
//      OldPmtDisc : Decimal;
//      CorrectionAmount : Decimal;
//      RemainingAmountExclDiscounts : Decimal;
//      CanUseDisc : Boolean;
//      FromZeroGenJnl : Boolean;
//      IsHandled : Boolean;
//    begin
//      IsHandled := FALSE;
//      OnBeforeHandledChosenEntries(Type,CurrentAmount,CurrencyCode,PostingDate,AppliedCustLedgEntry,IsHandled);
//      if ( IsHandled  )then
//        exit;
//
//      if ( not AppliedCustLedgEntry.FINDSET(FALSE)  )then
//        exit;
//
//      repeat
//        TempAppliedCustLedgEntry := AppliedCustLedgEntry;
//        TempAppliedCustLedgEntry.INSERT;
//      until AppliedCustLedgEntry.NEXT = 0;
//
//      FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);
//
//      repeat
//        if ( not FromZeroGenJnl  )then
//          TempAppliedCustLedgEntry.SETRANGE("Positive",CurrentAmount < 0);
//        if ( TempAppliedCustLedgEntry.FINDFIRST  )then begin
//          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,TempAppliedCustLedgEntry,PostingDate);
//
//          CASE Type OF
//            Type::Direct:
//              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscCust(CustLedgEntry,TempAppliedCustLedgEntry,0,FALSE,FALSE);
//            Type::GenJnlLine:
//              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine2,TempAppliedCustLedgEntry,0,FALSE)
//            ELSE
//              CanUseDisc := FALSE;
//          end;
//
//          if CanUseDisc and
//             (ABS(TempAppliedCustLedgEntry."Amount to Apply") >=
//              ABS(TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible"))
//          then
//            if (ABS(CurrentAmount) >
//                ABS(TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible"))
//            then begin
//              PmtDiscAmount += TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//              CurrentAmount += TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//            end ELSE
//              if (ABS(CurrentAmount) =
//                  ABS(TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible"))
//              then begin
//                PmtDiscAmount += TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//                CurrentAmount +=
//                  TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//                AppliedAmount += CorrectionAmount;
//              end ELSE
//                if ( FromZeroGenJnl  )then begin
//                  PmtDiscAmount += TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//                  CurrentAmount +=
//                    TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//                end ELSE begin
//                  PossiblePmtDisc := TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//                  RemainingAmountExclDiscounts :=
//                    TempAppliedCustLedgEntry."Remaining Amount" - PossiblePmtDisc - TempAppliedCustLedgEntry."Max. Payment Tolerance";
//                  if ABS(CurrentAmount) + ABS(CalcOppositeEntriesAmount(TempAppliedCustLedgEntry)) >=
//                     ABS(RemainingAmountExclDiscounts)
//                  then begin
//                    PmtDiscAmount += PossiblePmtDisc;
//                    AppliedAmount += CorrectionAmount;
//                  end;
//                  CurrentAmount +=
//                    TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
//                end
//          ELSE begin
//            if ( ((CurrentAmount + TempAppliedCustLedgEntry."Amount to Apply") * CurrentAmount) <= 0  )then
//              AppliedAmount += CorrectionAmount;
//            CurrentAmount += TempAppliedCustLedgEntry."Amount to Apply";
//          end
//        end ELSE begin
//          TempAppliedCustLedgEntry.SETRANGE("Positive");
//          TempAppliedCustLedgEntry.FINDFIRST;
//          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,TempAppliedCustLedgEntry,PostingDate);
//        end;
//
//        if ( OldPmtDisc <> PmtDiscAmount  )then
//          AppliedAmount += TempAppliedCustLedgEntry."Remaining Amount"
//        ELSE
//          AppliedAmount += TempAppliedCustLedgEntry."Amount to Apply";
//        OldPmtDisc := PmtDiscAmount;
//
//        if ( PossiblePmtDisc <> 0  )then
//          CorrectionAmount := TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Amount to Apply"
//        ELSE
//          CorrectionAmount := 0;
//
//        if ( not DifferentCurrenciesInAppln  )then
//          DifferentCurrenciesInAppln := ApplnCurrencyCode <> TempAppliedCustLedgEntry."Currency Code";
//
//        TempAppliedCustLedgEntry.DELETE;
//        TempAppliedCustLedgEntry.SETRANGE("Positive");
//
//      until not TempAppliedCustLedgEntry.FINDFIRST;
//      CheckRounding;
//    end;
//Local procedure AmountToApplyOnAfterValidate();
//    begin
//      if ( ApplnType <> ApplnType::"Applies-to Doc. No."  )then begin
//        rec.CalcApplnAmount;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure RecalcApplnAmount();
//    begin
//      CurrPage.UPDATE(TRUE);
//      rec.CalcApplnAmount;
//    end;
//Local procedure LookupOKOnPush();
//    begin
//      OK := TRUE;
//    end;
//Local procedure PostDirectApplication(PreviewMode : Boolean);
//    var
//      CustEntryApplyPostedEntries : Codeunit 226;
//      PostApplication : Page 579;
//      Applied : Boolean;
//      ApplicationDate : Date;
//      NewApplicationDate : Date;
//      NewDocumentNo : Code[20];
//    begin
//      if ( CalcType = CalcType::Direct  )then begin
//        if ( ApplyingCustLedgEntry."Entry No." <> 0  )then begin
//          Rec := ApplyingCustLedgEntry;
//          ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(Rec);
//
//          PostApplication.SetValues(rec."Document No.",ApplicationDate);
//          if ( ACTION::OK = PostApplication.RUNMODAL  )then begin
//            PostApplication.GetValues(NewDocumentNo,NewApplicationDate);
//            if ( NewApplicationDate < ApplicationDate  )then
//              ERROR(Text013,Rec.FIELDCAPTION("Posting Date"),Rec.TABLECAPTION);
//          end ELSE
//            ERROR(Text019);
//
//          if ( PreviewMode  )then
//            CustEntryApplyPostedEntries.PreviewApply(Rec,NewDocumentNo,NewApplicationDate)
//          ELSE
//            Applied := CustEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);
//
//          if ( (not PreviewMode) and Applied  )then begin
//            MESSAGE(Text012);
//            PostingDone := TRUE;
//            CurrPage.CLOSE;
//          end;
//        end ELSE
//          ERROR(Text002);
//      end ELSE
//        ERROR(Text003);
//    end;
//
//    //[External]
//procedure ExchangeAmountsOnLedgerEntry(Type: Option "Direct","GenJnlLine","SalesHeader";CurrencyCode : Code[10];var CalcCustLedgEntry : Record 21;PostingDate : Date);
//    var
//      CalculateCurrency : Boolean;
//    begin
//      CalcCustLedgEntry.CALCFIELDS("Remaining Amount");
//
//      if ( Type = Type::Direct  )then
//        CalculateCurrency := ApplyingCustLedgEntry."Entry No." <> 0
//      ELSE
//        CalculateCurrency := TRUE;
//
//      if ( (CurrencyCode <> CalcCustLedgEntry."Currency Code") and CalculateCurrency  )then begin
//        CalcCustLedgEntry."Remaining Amount" :=
//          CurrExchRate.ExchangeAmount(
//            CalcCustLedgEntry."Remaining Amount",CalcCustLedgEntry."Currency Code",CurrencyCode,PostingDate);
//        CalcCustLedgEntry."Remaining Pmt. Disc. Possible" :=
//          CurrExchRate.ExchangeAmount(
//            CalcCustLedgEntry."Remaining Pmt. Disc. Possible",CalcCustLedgEntry."Currency Code",CurrencyCode,PostingDate);
//        CalcCustLedgEntry."Amount to Apply" :=
//          CurrExchRate.ExchangeAmount(
//            CalcCustLedgEntry."Amount to Apply",CalcCustLedgEntry."Currency Code",CurrencyCode,PostingDate);
//      end;
//
//      OnAfterExchangeAmountsOnLedgerEntry(CalcCustLedgEntry,CustLedgEntry,CurrencyCode);
//    end;
//
//    //[External]
//procedure CalcOppositeEntriesAmount(var TempAppliedCustLedgerEntry : Record 21 TEMPORARY ) Result : Decimal;
//    var
//      SavedAppliedCustLedgerEntry : Record 21;
//      CurrPosFilter : Text;
//    begin
//      WITH TempAppliedCustLedgerEntry DO begin
//        CurrPosFilter := GETFILTER("Positive");
//        if ( CurrPosFilter <> ''  )then begin
//          SavedAppliedCustLedgerEntry := TempAppliedCustLedgerEntry;
//          SETRANGE("Positive",not Positive);
//          if ( FINDSET  )then
//            repeat
//              Rec.CALCFIELDS("Remaining Amount");
//              Result += rec."Remaining Amount";
//            until NEXT = 0;
//          SETFILTER("Positive",CurrPosFilter);
//          TempAppliedCustLedgerEntry := SavedAppliedCustLedgerEntry;
//        end;
//      end;
//    end;
//
//    [Integration]
//Local procedure OnAfterCalcApplnAmount(CustLedgerEntry : Record 21;var AppliedAmount : Decimal;var ApplyingAmount : Decimal);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnAfterCalcApplnAmountToApply(CustLedgerEntry : Record 21;var ApplnAmountToApply : Decimal);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnAfterCalcApplnRemainingAmount(CustLedgerEntry : Record 21;var ApplnRemainingAmount : Decimal);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnAfterExchangeAmountsOnLedgerEntry(var CalcCustLedgEntry : Record 21;CustLedgerEntry : Record 21;CurrencyCode : Code[10]);
//    begin
//    end;
//
//    [Integration(TRUE,TRUE)]
//Local procedure OnBeforeHandledChosenEntries(Type: Option "Direct","GenJnlLine","SalesHeader";CurrentAmount : Decimal;CurrencyCode : Code[10];PostingDate : Date;var AppliedCustLedgerEntry : Record 21;var IsHandled : Boolean);
//    begin
//    end;

//procedure
}


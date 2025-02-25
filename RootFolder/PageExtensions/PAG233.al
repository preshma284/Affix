pageextension 50157 MyExtension233 extends 233//25
{
layout
{
addafter("Global Dimension 2 Code")
{
    field("Vendor Posting Group";rec."Vendor Posting Group")
    {
        
                Editable=FALSE ;
}
}

}

actions
{


}

//trigger
trigger OnAfterGetCurrRecord()    BEGIN
                           IF ApplnType = ApplnType::"Applies-to Doc. No." THEN
                             CalcApplnAmount;
                         END;


//trigger

var
      ApplyingVendLedgEntry : Record 25 TEMPORARY ;
      AppliedVendLedgEntry : Record 25;
      Currency : Record 4;
      CurrExchRate : Record 330;
      GenJnlLine : Record 81;
      GenJnlLine2 : Record 81;
      PurchHeader : Record 38;
      Vend : Record 23;
      VendLedgEntry : Record 25;
      GLSetup : Record 98;
      TotalPurchLine : Record 39;
      TotalPurchLineLCY : Record 39;
      VendEntrySetApplID : Codeunit 111;
      GenJnlApply : Codeunit 225;
      PurchPost : Codeunit 90;
      PaymentToleranceMgt : Codeunit 426;
      Navigate : Page 344;
      GenJnlLineApply : Boolean;
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
      CalcType: Option "Direct","GenJnlLine","PurchHeader";
      VendEntryApplID : Code[50];
      AppliesToID : Code[50];
      ValidExchRate : Boolean;
      DifferentCurrenciesInAppln : Boolean;
      Text002 : TextConst ENU='You must select an applying entry before you can post the application.',ESP='Seleccione un movimiento de liquidaci¢n antes de registrar la liquidaci¢n.';
      Text003 : TextConst ENU='You must post the application from the window where you entered the applying entry.',ESP='Registre la liquidaci¢n desde la ventana en la que registro el movimiento.';
      CannotSetAppliesToIDErr : TextConst ENU='You cannot set Applies-to ID while selecting Applies-to Doc. No.',ESP='No puede establecer el id. de liquidaci¢n al seleccionar Liq. por n§ de documento.';
      ShowAppliedEntries : Boolean;
      OK : Boolean;
      EarlierPostingDateErr : TextConst ENU='You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.',ESP='No puede liquidar ni registrar un movimiento en un movimiento con una fecha de registro anterior.\\En su lugar, registre el documento de tipo %1 con el n£mero %2 y luego liqu¡delo en documento de tipo %3 con el n£mero %4.';
      PostingDone : Boolean;
      AppliesToIDVisible : Boolean ;
      ActionPerformed : Boolean;
      Text012 : TextConst ENU='The application was successfully posted.',ESP='La liquidaci¢n se ha registrado correctamente.';
      Text013 : TextConst ENU='The %1 entered must not be before the %1 on the %2.',ESP='El %1 introducido no debe estar antes del %1 en %2.';
      Text019 : TextConst ENU='Post application process has been canceled.',ESP='Se ha cancelado el proceso Registrar liquidaci¢n marcada.';
      IsOfficeAddin : Boolean;

    

//procedure
//procedure SetGenJnlLine(NewGenJnlLine : Record 81;ApplnTypeSelect : Integer);
//    begin
//      GenJnlLine := NewGenJnlLine;
//      GenJnlLineApply := TRUE;
//
//      if ( GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor  )then
//        ApplyingAmount := GenJnlLine.Amount;
//      if ( GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor  )then
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
//      SetApplyingVendLedgEntry;
//    end;
//
//    //[External]
//procedure SetPurch(NewPurchHeader : Record 38;var NewVendLedgEntry : Record 25;ApplnTypeSelect : Integer);
//    begin
//      PurchHeader := NewPurchHeader;
//      Rec.COPYFILTERS(NewVendLedgEntry);
//
//      PurchPost.SumPurchLines(
//        PurchHeader,0,TotalPurchLine,TotalPurchLineLCY,
//        VATAmount,VATAmountText);
//
//      CASE PurchHeader."Document Type" OF
//        PurchHeader."Document Type"::"Return Order",
//        PurchHeader."Document Type"::"Credit Memo":
//          ApplyingAmount := TotalPurchLine."Amount Including VAT"
//        ELSE
//          ApplyingAmount := -TotalPurchLine."Amount Including VAT";
//      end;
//
//      ApplnDate := PurchHeader."Posting Date";
//      ApplnCurrencyCode := PurchHeader."Currency Code";
//      CalcType := CalcType::PurchHeader;
//
//      CASE ApplnTypeSelect OF
//        PurchHeader.FIELDNO(rec."Applies-to Doc. No."):
//          ApplnType := ApplnType::"Applies-to Doc. No.";
//        PurchHeader.FIELDNO(rec."Applies-to ID"):
//          ApplnType := ApplnType::"Applies-to ID";
//      end;
//
//      SetApplyingVendLedgEntry;
//    end;
//
//    //[External]
//procedure SetVendLedgEntry(NewVendLedgEntry : Record 25);
//    begin
//      Rec := NewVendLedgEntry;
//    end;
//
//    //[External]
//procedure SetApplyingVendLedgEntry();
//    var
//      Vendor : Record 23;
//    begin
//      CASE CalcType OF
//        CalcType::PurchHeader:
//          begin
//            ApplyingVendLedgEntry."Posting Date" := PurchHeader."Posting Date";
//            if ( PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order"  )then
//              ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type"::"Credit Memo"
//            ELSE
//              ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type";
//            ApplyingVendLedgEntry."Document No." := PurchHeader."No.";
//            ApplyingVendLedgEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
//            ApplyingVendLedgEntry.Description := PurchHeader."Posting Description";
//            ApplyingVendLedgEntry."Currency Code" := PurchHeader."Currency Code";
//            if ( ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."Document Type"::"Credit Memo"  )then  begin
//              ApplyingVendLedgEntry.Amount := TotalPurchLine."Amount Including VAT";
//              ApplyingVendLedgEntry."Remaining Amount" := TotalPurchLine."Amount Including VAT";
//            end ELSE begin
//              ApplyingVendLedgEntry.Amount := -TotalPurchLine."Amount Including VAT";
//              ApplyingVendLedgEntry."Remaining Amount" := -TotalPurchLine."Amount Including VAT";
//            end;
//            CalcApplnAmount;
//          end;
//        CalcType::Direct:
//          begin
//            if ( rec."Applying Entry"  )then begin
//              if ( ApplyingVendLedgEntry."Entry No." <> 0  )then
//                VendLedgEntry := ApplyingVendLedgEntry;
//              CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
//              if ( rec."Applies-to ID" = ''  )then
//                SetVendApplId(FALSE);
//              Rec.CALCFIELDS("Amount");
//              ApplyingVendLedgEntry := Rec;
//              if ( VendLedgEntry."Entry No." <> 0  )then begin
//                Rec := VendLedgEntry;
//                rec."Applying Entry" := FALSE;
//                SetVendApplId(FALSE);
//              end;
//              Rec.SETFILTER("Entry No.",'<> %1',ApplyingVendLedgEntry."Entry No.");
//              ApplyingAmount := ApplyingVendLedgEntry."Remaining Amount";
//              ApplnDate := ApplyingVendLedgEntry."Posting Date";
//              ApplnCurrencyCode := ApplyingVendLedgEntry."Currency Code";
//            end;
//            CalcApplnAmount;
//          end;
//        CalcType::GenJnlLine:
//          begin
//            ApplyingVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
//            ApplyingVendLedgEntry."Document Type" := GenJnlLine."Document Type";
//            ApplyingVendLedgEntry."Document No." := GenJnlLine."Document No.";
//            if ( GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor  )then begin
//              ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Bal. Account No.";
//              Vendor.GET(ApplyingVendLedgEntry."Vendor No.");
//              ApplyingVendLedgEntry.Description := Vendor.Name;
//            end ELSE begin
//              ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
//              ApplyingVendLedgEntry.Description := GenJnlLine.Description;
//            end;
//            ApplyingVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
//            ApplyingVendLedgEntry.Amount := GenJnlLine.Amount;
//            ApplyingVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
//            CalcApplnAmount;
//          end;
//      end;
//    end;
//
//    //[External]
//procedure SetVendApplId(CurrentRec : Boolean);
//    begin
//      if ( (CalcType = CalcType::GenJnlLine) and (ApplyingVendLedgEntry."Posting Date" < rec."Posting Date")  )then
//        ERROR(
//          EarlierPostingDateErr,ApplyingVendLedgEntry."Document Type",ApplyingVendLedgEntry."Document No.",
//          rec."Document Type",rec."Document No.");
//
//      if ( ApplyingVendLedgEntry."Entry No." <> 0  )then
//        GenJnlApply.CheckAgainstApplnCurrency(
//          ApplnCurrencyCode,rec."Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);
//
//      VendLedgEntry.COPY(Rec);
//      if ( CurrentRec  )then
//        VendLedgEntry.SETRECFILTER
//      ELSE
//        CurrPage.SETSELECTIONFILTER(VendLedgEntry);
//      if ( GenJnlLineApply  )then
//        VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,GenJnlLine."Applies-to ID")
//      ELSE
//        VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,PurchHeader."Applies-to ID");
//
//      ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
//      CalcApplnAmount;
//    end;
//Local procedure CalcApplnAmount();
//    begin
//      AppliedAmount := 0;
//      PmtDiscAmount := 0;
//      DifferentCurrenciesInAppln := FALSE;
//
//      CASE CalcType OF
//        CalcType::Direct:
//          begin
//            FindAmountRounding;
//            VendEntryApplID := USERID;
//            if ( VendEntryApplID = ''  )then
//              VendEntryApplID := '***';
//
//            VendLedgEntry := ApplyingVendLedgEntry;
//
//            AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.","Open","Positive");
//            AppliedVendLedgEntry.SETRANGE("Vendor No.",rec."Vendor No.");
//            AppliedVendLedgEntry.SETRANGE("Open",TRUE);
//            if ( AppliesToID = ''  )then
//              AppliedVendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID)
//            ELSE
//              AppliedVendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
//
//            if ( ApplyingVendLedgEntry."Entry No." <> 0  )then begin
//              VendLedgEntry.CALCFIELDS("Remaining Amount");
//              AppliedVendLedgEntry.SETFILTER("Entry No.",'<>%1',VendLedgEntry."Entry No.");
//            end;
//
//            HandleChosenEntries(0,VendLedgEntry."Remaining Amount",VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
//          end;
//        CalcType::GenJnlLine:
//          begin
//            FindAmountRounding;
//            if ( GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor  )then
//              CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);
//
//            CASE ApplnType OF
//              ApplnType::"Applies-to Doc. No.":
//                begin
//                  AppliedVendLedgEntry := Rec;
//                  WITH AppliedVendLedgEntry DO begin
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
//                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(
//                         GenJnlLine,AppliedVendLedgEntry,0,FALSE) and
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
//                  AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.","Open","Positive");
//                  AppliedVendLedgEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
//                  AppliedVendLedgEntry.SETRANGE("Open",TRUE);
//                  AppliedVendLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
//
//                  HandleChosenEntries(1,GenJnlLine2.Amount,GenJnlLine2."Currency Code",GenJnlLine2."Posting Date");
//                end;
//            end;
//          end;
//        CalcType::PurchHeader:
//          begin
//            FindAmountRounding;
//
//            CASE ApplnType OF
//              ApplnType::"Applies-to Doc. No.":
//                begin
//                  AppliedVendLedgEntry := Rec;
//                  WITH AppliedVendLedgEntry DO begin
//                    Rec.CALCFIELDS("Remaining Amount");
//
//                    if ( rec."Currency Code" <> ApplnCurrencyCode  )then
//                      rec."Remaining Amount" :=
//                        CurrExchRate.ExchangeAmtFCYToFCY(
//                          ApplnDate,rec."Currency Code",ApplnCurrencyCode,rec."Remaining Amount");
//
//                    AppliedAmount := AppliedAmount + ROUND(rec."Remaining Amount",AmountRoundingPrecision);
//
//                    if ( not DifferentCurrenciesInAppln  )then
//                      DifferentCurrenciesInAppln := ApplnCurrencyCode <> rec."Currency Code";
//                  end;
//                  CheckRounding;
//                end;
//              ApplnType::"Applies-to ID":
//                WITH VendLedgEntry DO begin
//                  AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.","Open","Positive");
//                  AppliedVendLedgEntry.SETRANGE("Vendor No.",PurchHeader."Pay-to Vendor No.");
//                  AppliedVendLedgEntry.SETRANGE("Open",TRUE);
//                  AppliedVendLedgEntry.SETRANGE("Applies-to ID",PurchHeader."Applies-to ID");
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
//      OnAfterCalcApplnAmountToApply(Rec,AmountToApply);
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
//        CalcType::PurchHeader:
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
//procedure GetVendLedgEntry(var VendLedgEntry : Record 25);
//    begin
//      VendLedgEntry := Rec;
//    end;
//Local procedure FindApplyingEntry();
//    begin
//      if ( CalcType = CalcType::Direct  )then begin
//        VendEntryApplID := USERID;
//        if ( VendEntryApplID = ''  )then
//          VendEntryApplID := '***';
//
//        VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID","Open");
//        VendLedgEntry.SETRANGE("Vendor No.",rec."Vendor No.");
//        if ( AppliesToID = ''  )then
//          VendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID)
//        ELSE
//          VendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
//        VendLedgEntry.SETRANGE("Open",TRUE);
//        VendLedgEntry.SETRANGE("Applying Entry",TRUE);
//        if ( VendLedgEntry.FINDFIRST  )then begin
//          VendLedgEntry.CALCFIELDS("Amount","Remaining Amount");
//          ApplyingVendLedgEntry := VendLedgEntry;
//          SETFILTER("Entry No.",'<>%1',VendLedgEntry."Entry No.");
//          ApplyingAmount := VendLedgEntry."Remaining Amount";
//          ApplnDate := VendLedgEntry."Posting Date";
//          ApplnCurrencyCode := VendLedgEntry."Currency Code";
//        end;
//        CalcApplnAmount;
//      end;
//    end;
//Local procedure HandleChosenEntries(Type: Option "Direct","GenJnlLine","PurchHeader";CurrentAmount : Decimal;CurrencyCode : Code[10];PostingDate : Date);
//    var
//      TempAppliedVendLedgEntry : Record 25 TEMPORARY ;
//      PossiblePmtdisc : Decimal;
//      OldPmtdisc : Decimal;
//      CorrectionAmount : Decimal;
//      RemainingAmountExclDiscounts : Decimal;
//      CanUseDisc : Boolean;
//      FromZeroGenJnl : Boolean;
//      IsHandled : Boolean;
//    begin
//      IsHandled := FALSE;
//      OnBeforeHandledChosenEntries(Type,CurrentAmount,CurrencyCode,PostingDate,AppliedVendLedgEntry,IsHandled);
//      if ( IsHandled  )then
//        exit;
//
//      if ( not AppliedVendLedgEntry.FINDSET(FALSE)  )then
//        exit;
//
//      repeat
//        TempAppliedVendLedgEntry := AppliedVendLedgEntry;
//        TempAppliedVendLedgEntry.INSERT;
//      until AppliedVendLedgEntry.NEXT = 0;
//
//      FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);
//
//      repeat
//        if ( not FromZeroGenJnl  )then
//          TempAppliedVendLedgEntry.SETRANGE("Positive",CurrentAmount < 0);
//        if ( TempAppliedVendLedgEntry.FINDFIRST  )then begin
//          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,TempAppliedVendLedgEntry,PostingDate);
//
//          CASE Type OF
//            Type::Direct:
//              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry,TempAppliedVendLedgEntry,0,FALSE,FALSE);
//            Type::GenJnlLine:
//              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2,TempAppliedVendLedgEntry,0,FALSE)
//            ELSE
//              CanUseDisc := FALSE;
//          end;
//
//          if CanUseDisc and
//             (ABS(TempAppliedVendLedgEntry."Amount to Apply") >=
//              ABS(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible"))
//          then
//            if ABS(CurrentAmount) >
//               ABS(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible")
//            then begin
//              PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//              CurrentAmount += TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//            end ELSE
//              if ABS(CurrentAmount) =
//                 ABS(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible")
//              then begin
//                PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible" ;
//                CurrentAmount +=
//                  TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//                AppliedAmount += CorrectionAmount;
//              end ELSE
//                if ( FromZeroGenJnl  )then begin
//                  PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//                  CurrentAmount +=
//                    TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//                end ELSE begin
//                  PossiblePmtdisc := TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//                  RemainingAmountExclDiscounts :=
//                    TempAppliedVendLedgEntry."Remaining Amount" - PossiblePmtdisc - TempAppliedVendLedgEntry."Max. Payment Tolerance";
//                  if ABS(CurrentAmount) + ABS(CalcOppositeEntriesAmount(TempAppliedVendLedgEntry)) >=
//                     ABS(RemainingAmountExclDiscounts)
//                  then begin
//                    PmtDiscAmount += PossiblePmtdisc;
//                    AppliedAmount += CorrectionAmount;
//                  end;
//                  CurrentAmount +=
//                    TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
//                end
//          ELSE begin
//            if ( ((CurrentAmount + TempAppliedVendLedgEntry."Amount to Apply") * CurrentAmount) >= 0  )then
//              AppliedAmount += CorrectionAmount;
//            CurrentAmount += TempAppliedVendLedgEntry."Amount to Apply";
//          end;
//        end ELSE begin
//          TempAppliedVendLedgEntry.SETRANGE("Positive");
//          TempAppliedVendLedgEntry.FINDFIRST;
//          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,TempAppliedVendLedgEntry,PostingDate);
//        end;
//
//        if ( OldPmtdisc <> PmtDiscAmount  )then
//          AppliedAmount += TempAppliedVendLedgEntry."Remaining Amount"
//        ELSE
//          AppliedAmount += TempAppliedVendLedgEntry."Amount to Apply";
//        OldPmtdisc := PmtDiscAmount;
//
//        if ( PossiblePmtdisc <> 0  )then
//          CorrectionAmount := TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Amount to Apply"
//        ELSE
//          CorrectionAmount := 0;
//
//        if ( not DifferentCurrenciesInAppln  )then
//          DifferentCurrenciesInAppln := ApplnCurrencyCode <> TempAppliedVendLedgEntry."Currency Code";
//
//        TempAppliedVendLedgEntry.DELETE;
//        TempAppliedVendLedgEntry.SETRANGE("Positive");
//
//      until not TempAppliedVendLedgEntry.FINDFIRST;
//      CheckRounding;
//    end;
//Local procedure AmountToApplyOnAfterValidate();
//    begin
//      if ( ApplnType <> ApplnType::"Applies-to Doc. No."  )then begin
//        CalcApplnAmount;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure RecalcApplnAmount();
//    begin
//      CurrPage.UPDATE(TRUE);
//      CalcApplnAmount;
//    end;
//Local procedure LookupOKOnPush();
//    begin
//      OK := TRUE;
//    end;
//Local procedure PostDirectApplication(PreviewMode : Boolean);
//    var
//      VendEntryApplyPostedEntries : Codeunit 227;
//      PostApplication : Page 579;
//      Applied : Boolean;
//      ApplicationDate : Date;
//      NewApplicationDate : Date;
//      NewDocumentNo : Code[20];
//    begin
//      if ( CalcType = CalcType::Direct  )then begin
//        if ( ApplyingVendLedgEntry."Entry No." <> 0  )then begin
//          Rec := ApplyingVendLedgEntry;
//          ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(Rec);
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
//            VendEntryApplyPostedEntries.PreviewApply(Rec,NewDocumentNo,NewApplicationDate)
//          ELSE
//            Applied := VendEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);
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
//Local procedure CheckActionPerformed() : Boolean;
//    begin
//      if ( ActionPerformed  )then
//        exit(FALSE);
//      if (not (CalcType = CalcType::Direct) and not OK and not PostingDone) or
//         (ApplnType = ApplnType::"Applies-to Doc. No.")
//      then
//        exit(FALSE);
//      exit((CalcType = CalcType::Direct) and not OK and not PostingDone);
//    end;
//
//    //[External]
//procedure SetAppliesToID(AppliesToID2 : Code[50]);
//    begin
//      AppliesToID := AppliesToID2;
//    end;
//
//    //[External]
//procedure ExchangeAmountsOnLedgerEntry(Type: Option "Direct","GenJnlLine","PurchHeader";CurrencyCode : Code[10];var CalcVendLedgEntry : Record 25;PostingDate : Date);
//    var
//      CalculateCurrency : Boolean;
//    begin
//      CalcVendLedgEntry.CALCFIELDS("Remaining Amount");
//
//      if ( Type = Type::Direct  )then
//        CalculateCurrency := ApplyingVendLedgEntry."Entry No." <> 0
//      ELSE
//        CalculateCurrency := TRUE;
//
//      if ( (CurrencyCode <> CalcVendLedgEntry."Currency Code") and CalculateCurrency  )then begin
//        CalcVendLedgEntry."Remaining Amount" :=
//          CurrExchRate.ExchangeAmount(
//            CalcVendLedgEntry."Remaining Amount",CalcVendLedgEntry."Currency Code",CurrencyCode,PostingDate);
//        CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
//          CurrExchRate.ExchangeAmount(
//            CalcVendLedgEntry."Remaining Pmt. Disc. Possible",CalcVendLedgEntry."Currency Code",CurrencyCode,PostingDate);
//        CalcVendLedgEntry."Amount to Apply" :=
//          CurrExchRate.ExchangeAmount(
//            CalcVendLedgEntry."Amount to Apply",CalcVendLedgEntry."Currency Code",CurrencyCode,PostingDate);
//      end;
//
//      OnAfterExchangeAmountsOnLedgerEntry(CalcVendLedgEntry,VendLedgEntry,CurrencyCode);
//    end;
//
//    //[External]
//procedure CalcOppositeEntriesAmount(var TempAppliedVendorLedgerEntry : Record 25 TEMPORARY ) Result : Decimal;
//    var
//      SavedAppliedVendorLedgerEntry : Record 25;
//      CurrPosFilter : Text;
//    begin
//      WITH TempAppliedVendorLedgerEntry DO begin
//        CurrPosFilter := GETFILTER("Positive");
//        if ( CurrPosFilter <> ''  )then begin
//          SavedAppliedVendorLedgerEntry := TempAppliedVendorLedgerEntry;
//          SETRANGE("Positive",not Positive);
//          if ( FINDSET  )then
//            repeat
//              Rec.CALCFIELDS("Remaining Amount");
//              Result += rec."Remaining Amount";
//            until NEXT = 0;
//          SETFILTER("Positive",CurrPosFilter);
//          TempAppliedVendorLedgerEntry := SavedAppliedVendorLedgerEntry;
//        end;
//      end;
//    end;
//
//    [Integration]
//Local procedure OnAfterCalcApplnAmount(VendorLedgerEntry : Record 25;var AppliedAmount : Decimal;var ApplyingAmount : Decimal);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnAfterCalcApplnAmountToApply(VendorLedgerEntry : Record 25;var ApplnAmountToApply : Decimal);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnAfterCalcApplnRemainingAmount(VendorLedgerEntry : Record 25;var ApplnRemainingAmount : Decimal);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnAfterExchangeAmountsOnLedgerEntry(var CalcVendorLedgerEntry : Record 25;VendorLedgerEntry : Record 25;CurrencyCode : Code[10]);
//    begin
//    end;
//
//    [Integration(TRUE,TRUE)]
//Local procedure OnBeforeHandledChosenEntries(Type: Option "Direct","GenJnlLine","PurchHeader";CurrentAmount : Decimal;CurrencyCode : Code[10];PostingDate : Date;var AppliedVendLedgEntry : Record 25;var IsHandled : Boolean);
//    begin
//    end;

//procedure
}


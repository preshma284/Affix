Codeunit 50387 "Sales-Post Prepayments 1"
{
  
  
    Permissions=TableData 37=imd,
                TableData 49=imd,
                TableData 112=imd,
                TableData 113=imd,
                TableData 114=imd,
                TableData 115=imd,
                TableData 252=imd;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='is not within your range of allowed posting dates',ESP='no est� dentro del periodo de fechas de registro permitidas';
      GLSetup : Record 98;
      GenPostingSetup : Record 252;
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text002 : TextConst ENU='Posting Prepayment Lines   #2######\',ESP='Registrando l�neas prepago #2######\';
      Text003 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 %2 -> Factura %3';
      Text004 : TextConst ENU='Posting sales and VAT      #3######\',ESP='Registrando venta e IVA    #3######\';
      Text005 : TextConst ENU='Posting to customers       #4######\',ESP='Registrando cliente        #4######\';
      Text006 : TextConst ENU='Posting to bal. account    #5######',ESP='Registrando contrapartida  #5######';
      Text007 : TextConst ENU='The combination of dimensions that is used in the document of type %1 with the number %2 is blocked. %3.',ESP='La combinaci�n de dimensiones que se usa en el documento de tipo %1 con el n�mero %2 est� bloqueada. %3.';
      Text008 : TextConst ENU='The combination of dimensions that is used in the document of type %1 with the number %2, line no. %3 is blocked. %4.',ESP='La combinaci�n de dimensiones que se usa en el documento de tipo %1 con el n�mero %2, n� de l�nea %3 est� bloqueada. %4.';
      Text009 : TextConst ENU='The dimensions that are used in the document of type %1 with the number %2 are not valid. %3.',ESP='Las dimensiones que se usan en el documento de tipo %1 con el n�mero %2 no son v�lidas. %3.';
      Text010 : TextConst ENU='The dimensions that are used in the document of type %1 with the number %2, line no. %3 are not valid. %4.',ESP='Las dimensiones que se usan en el documento de tipo %1 con el n�mero %2, n� de l�nea %3 no son v�lidas. %4.';
      TempGlobalPrepmtInvLineBuf : Record 461 TEMPORARY;
      GenJnlPostLine : Codeunit 12;
      Text011 : TextConst ENU='%1 %2 -> Credit Memo %3',ESP='%1 %2 -> Abono %3';
      Text012 : TextConst ENU='Prepayment %1, %2 %3.',ESP='%1 de prepago, %2 %3.';
      Text013 : TextConst ENU='It is not possible to assign a prepayment amount of %1 to the sales lines.',ESP='No es posible asignar un importe prepago de %1 a las l�neas de ventas.';
      Text014 : TextConst ENU='VAT Amount',ESP='Importe IVA';
      Text015 : TextConst ENU='%1% VAT',ESP='%1% IVA';
      Text016 : TextConst ENU='The new prepayment amount must be between %1 and %2.',ESP='El nuevo importe de prepago debe estar entre %1 y %2.';
      Text017 : TextConst ENU='At least one line must have %1 > 0 to distribute prepayment amount.',ESP='Al menos una l�nea debe tener %1 > 0 para distribuir como importe prepago.';
      Text018 : TextConst ENU='must be positive when %1 is not 0',ESP='debe ser positivo cuando %1 no es 0';
      Text019 : TextConst ENU='Option "Invoice","Credit Memo"',ESP='Factura,Abono';
      SuppressCommit : Boolean;


    LOCAL PROCEDURE Code(VAR SalesHeader2 : Record 36;DocumentType : Option "Invoice","Credit Memo");
    VAR
      SalesSetup : Record 311;
      SourceCodeSetup : Record 242;
      SalesHeader : Record 36;
      SalesLine : Record 37;
      SalesInvHeader : Record 112;
      SalesCrMemoHeader : Record 114;
      TempPrepmtInvLineBuffer : Record 461 TEMPORARY;
      TotalPrepmtInvLineBuffer : Record 461;
      TotalPrepmtInvLineBufferLCY : Record 461;
      GenJnlLine : Record 81;
      TempVATAmountLine : Record 290 TEMPORARY;
      TempVATAmountLineDeduct : Record 290 TEMPORARY;
      CustLedgEntry : Record 21;
      TempSalesLines : Record 37 TEMPORARY;
      Window : Dialog;
      GenJnlLineDocNo : Code[20];
      GenJnlLineExtDocNo : Code[35];
      SrcCode : Code[10];
      PostingNoSeriesCode : Code[20];
      CalcPmtDiscOnCrMemos : Boolean;
      PostingDescription : Text[50];
      GenJnlLineDocType : Integer;
      PrevLineNo : Integer;
      LineCount : Integer;
      PostedDocTabNo : Integer;
      LineNo : Integer;
    BEGIN
      OnBeforePostPrepayments(SalesHeader2,DocumentType,SuppressCommit);

      SalesHeader := SalesHeader2;
      GLSetup.GET;
      SalesSetup.GET;
      WITH SalesHeader DO BEGIN
        CheckPrepmtDoc(SalesHeader,DocumentType);

        UpdateDocNos(SalesHeader,DocumentType,GenJnlLineDocNo,PostingNoSeriesCode);

        Window.OPEN(
          '#1#################################\\' +
          Text002 +
          Text004 +
          Text005 +
          Text006);
        Window.UPDATE(1,STRSUBSTNO('%1 %2',SELECTSTR(1 + DocumentType,Text019),"No."));

        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Sales;
        IF "Prepmt. Posting Description" <> '' THEN
          PostingDescription := "Prepmt. Posting Description"
        ELSE
          PostingDescription :=
            COPYSTR(
              STRSUBSTNO(Text012,SELECTSTR(1 + DocumentType,Text019),"Document Type","No."),
              1,MAXSTRLEN("Posting Description"));

        // Create posted header
        IF SalesSetup."Ext. Doc. No. Mandatory" THEN
          TESTFIELD("External Document No.");
        CASE DocumentType OF
          DocumentType::Invoice:
            BEGIN
              InsertSalesInvHeader(SalesInvHeader,SalesHeader,PostingDescription,GenJnlLineDocNo,SrcCode,PostingNoSeriesCode);
              GenJnlLineDocType := GenJnlLine."Document Type"::Invoice.AsInteger();
              PostedDocTabNo := DATABASE::"Sales Invoice Header";
              Window.UPDATE(1,STRSUBSTNO(Text003,"Document Type","No.",SalesInvHeader."No."));
            END;
          DocumentType::"Credit Memo":
            BEGIN
              CalcPmtDiscOnCrMemos := GetCalcPmtDiscOnCrMemos("Prepmt. Payment Terms Code");
              InsertSalesCrMemoHeader(
                SalesCrMemoHeader,SalesHeader,PostingDescription,GenJnlLineDocNo,SrcCode,PostingNoSeriesCode,
                CalcPmtDiscOnCrMemos);
              GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo".AsInteger();
              PostedDocTabNo := DATABASE::"Sales Cr.Memo Header";
              Window.UPDATE(1,STRSUBSTNO(Text011,"Document Type","No.",SalesCrMemoHeader."No."));
            END;
        END;
        GenJnlLineExtDocNo := "External Document No.";
        // Reverse old lines
        IF DocumentType = DocumentType::Invoice THEN BEGIN
          GetSalesLinesToDeduct(SalesHeader,TempSalesLines);
          IF NOT TempSalesLines.ISEMPTY THEN
            CalcVATAmountLines(SalesHeader,TempSalesLines,TempVATAmountLineDeduct,DocumentType::"Credit Memo");
        END;

        // Create Lines
        TempPrepmtInvLineBuffer.DELETEALL;
        CalcVATAmountLines(SalesHeader,SalesLine,TempVATAmountLine,DocumentType);
        TempVATAmountLine.DeductVATAmountLine(TempVATAmountLineDeduct);
        UpdateVATOnLines(SalesHeader,SalesLine,TempVATAmountLine,DocumentType);
        BuildInvLineBuffer(SalesHeader,SalesLine,DocumentType,TempPrepmtInvLineBuffer,TRUE);
        TempPrepmtInvLineBuffer.FIND('-');
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(2,LineCount);
          IF TempPrepmtInvLineBuffer."Line No." <> 0 THEN
            LineNo := PrevLineNo + TempPrepmtInvLineBuffer."Line No."
          ELSE
            LineNo := PrevLineNo + 10000;
          CASE DocumentType OF
            DocumentType::Invoice:
              BEGIN
                InsertSalesInvLine(SalesInvHeader,LineNo,TempPrepmtInvLineBuffer,SalesHeader);
                PostedDocTabNo := DATABASE::"Sales Invoice Line";
              END;
            DocumentType::"Credit Memo":
              BEGIN
                InsertSalesCrMemoLine(SalesCrMemoHeader,LineNo,TempPrepmtInvLineBuffer,SalesHeader);
                PostedDocTabNo := DATABASE::"Sales Cr.Memo Line";
              END;
          END;
          PrevLineNo := LineNo;
          InsertExtendedText(
            PostedDocTabNo,GenJnlLineDocNo,TempPrepmtInvLineBuffer."G/L Account No.","Document Date","Language Code",PrevLineNo);
        UNTIL TempPrepmtInvLineBuffer.NEXT = 0;

        // G/L Posting
        LineCount := 0;
        IF NOT "Compress Prepayment" THEN
          TempPrepmtInvLineBuffer.CompressBuffer;
        TempPrepmtInvLineBuffer.SETRANGE(Adjustment,FALSE);
        TempPrepmtInvLineBuffer.FINDSET(TRUE);
        REPEAT
          IF DocumentType = DocumentType::Invoice THEN
            TempPrepmtInvLineBuffer.ReverseAmounts;
          RoundAmounts(SalesHeader,TempPrepmtInvLineBuffer,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY);
          IF "Currency Code" = '' THEN BEGIN
            AdjustInvLineBuffers(SalesHeader,TempPrepmtInvLineBuffer,TotalPrepmtInvLineBuffer,DocumentType);
            TotalPrepmtInvLineBufferLCY := TotalPrepmtInvLineBuffer;
          END ELSE
            AdjustInvLineBuffers(SalesHeader,TempPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,DocumentType);
          TempPrepmtInvLineBuffer.MODIFY;
        UNTIL TempPrepmtInvLineBuffer.NEXT = 0;

        TempPrepmtInvLineBuffer.RESET;
        TempPrepmtInvLineBuffer.SETCURRENTKEY(Adjustment);
        TempPrepmtInvLineBuffer.FIND('+');
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(3,LineCount);

          PostPrepmtInvLineBuffer(
            SalesHeader,TempPrepmtInvLineBuffer,DocumentType,PostingDescription,
            Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType),GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PostingNoSeriesCode);
        UNTIL TempPrepmtInvLineBuffer.NEXT(-1) = 0;

        // Post customer entry
        Window.UPDATE(4,1);
        PostCustomerEntry(
          SalesHeader,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,DocumentType,PostingDescription,
          Enum::"Gen. Journal Document Type".FromInteger(GenJnlLineDocType),GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PostingNoSeriesCode,CalcPmtDiscOnCrMemos);

        UpdatePostedSalesDocument(DocumentType,GenJnlLineDocNo);

        // Balancing account
        IF "Bal. Account No." <> '' THEN BEGIN
          Window.UPDATE(5,1);
          CustLedgEntry.FINDLAST;
          PostBalancingEntry(
            SalesHeader,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,CustLedgEntry,DocumentType,
            PostingDescription,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PostingNoSeriesCode);
        END;

        // Update lines & header
        UpdateSalesDocument(SalesHeader,SalesLine,DocumentType,GenJnlLineDocNo);
        IF Status <> Status::"Pending Prepayment" THEN
          Status := Status::"Pending Prepayment";
        MODIFY;
      END;

      SalesHeader2 := SalesHeader;

      OnAfterPostPrepayments(SalesHeader2,DocumentType,SuppressCommit,SalesInvHeader,SalesCrMemoHeader);
    END;

    //[External]
    PROCEDURE CheckPrepmtDoc(SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo");
    VAR
      Cust : Record 18;
      GenJnlCheckLine : Codeunit 11;
    BEGIN
      WITH SalesHeader DO BEGIN
        TESTFIELD("Document Type","Document Type"::Order);
        TESTFIELD("Sell-to Customer No.");
        TESTFIELD("Bill-to Customer No.");
        TESTFIELD("Posting Date");
        TESTFIELD("Document Date");
        IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",Text000);

        IF NOT CheckOpenPrepaymentLines(SalesHeader,DocumentType) THEN
          ERROR(Text001);

        CheckDim(SalesHeader);
        OnCheckSalesPostRestrictions;
        Cust.GET("Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust,Enum::"Sales Document Type".FromInteger(PrepmtDocTypeToDocType(DocumentType)),FALSE,TRUE);
        IF "Bill-to Customer No." <> "Sell-to Customer No." THEN BEGIN
          Cust.GET("Bill-to Customer No.");
          Cust.CheckBlockedCustOnDocs(Cust,Enum::"Sales Document Type".FromInteger(PrepmtDocTypeToDocType(DocumentType)),FALSE,TRUE);
        END;
        OnAfterCheckPrepmtDoc(SalesHeader,DocumentType,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE UpdateDocNos(VAR SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo";VAR DocNo : Code[20];VAR NoSeriesCode : Code[20]);
    VAR
      PaymentTerms : Record 3;
      NoSeriesMgt : Codeunit 396;
    BEGIN
      WITH SalesHeader DO
        CASE DocumentType OF
          DocumentType::Invoice:
            BEGIN
              TESTFIELD("Prepayment Due Date");
              PaymentTerms.GET("Prepmt. Payment Terms Code");
              PaymentTerms.VerifyMaxNoDaysTillDueDate("Prepayment Due Date","Document Date",FIELDCAPTION("Prepayment Due Date"));
              TESTFIELD("Prepmt. Cr. Memo No.",'');
              IF "Prepayment No." = '' THEN BEGIN
                TESTFIELD("Prepayment No. Series");
                "Prepayment No." := NoSeriesMgt.GetNextNo("Prepayment No. Series","Posting Date",TRUE);
                MODIFY;
                IF NOT SuppressCommit THEN
                  COMMIT;
              END;
              DocNo := "Prepayment No.";
              NoSeriesCode := "Prepayment No. Series";
            END;
          DocumentType::"Credit Memo":
            BEGIN
              TESTFIELD("Prepayment No.",'');
              IF "Prepmt. Cr. Memo No." = '' THEN BEGIN
                TESTFIELD("Prepmt. Cr. Memo No. Series");
                "Prepmt. Cr. Memo No." := NoSeriesMgt.GetNextNo("Prepmt. Cr. Memo No. Series","Posting Date",TRUE);
                MODIFY;
                IF NOT SuppressCommit THEN
                  COMMIT;
              END;
              DocNo := "Prepmt. Cr. Memo No.";
              NoSeriesCode := "Prepmt. Cr. Memo No. Series";
            END;
        END;
    END;

    //[External]
    PROCEDURE CheckOpenPrepaymentLines(SalesHeader : Record 36;DocumentType : Option) Found : Boolean;
    VAR
      SalesLine : Record 37;
    BEGIN
      WITH SalesLine DO BEGIN
        ApplyFilter(SalesHeader,DocumentType,SalesLine);
        IF FIND('-') THEN
          REPEAT
            IF NOT Found THEN
              Found := PrepmtAmount(SalesLine,DocumentType) <> 0;
            IF ("Prepayment VAT Identifier" = '') AND ("Prepmt. Amt. Inv." = 0) THEN BEGIN
              UpdatePrepmtSetupFields;
              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;
      EXIT(Found);
    END;

    LOCAL PROCEDURE RoundAmounts(SalesHeader : Record 36;VAR PrepmtInvLineBuf : Record 461;VAR TotalPrepmtInvLineBuf : Record 461;VAR TotalPrepmtInvLineBufLCY : Record 461);
    VAR
      VAT : Boolean;
    BEGIN
      TotalPrepmtInvLineBuf.IncrAmounts(PrepmtInvLineBuf);

      WITH PrepmtInvLineBuf DO
        IF SalesHeader."Currency Code" <> '' THEN BEGIN
          VAT := Amount <> "Amount Incl. VAT";
          "Amount Incl. VAT" :=
            AmountToLCY(SalesHeader,TotalPrepmtInvLineBuf."Amount Incl. VAT",TotalPrepmtInvLineBufLCY."Amount Incl. VAT");
          IF VAT THEN
            Amount := AmountToLCY(SalesHeader,TotalPrepmtInvLineBuf.Amount,TotalPrepmtInvLineBufLCY.Amount)
          ELSE
            Amount := "Amount Incl. VAT";
          "VAT Amount" := "Amount Incl. VAT" - Amount;
          IF "VAT Base Amount" <> 0 THEN
            "VAT Base Amount" := Amount;
        END;

      TotalPrepmtInvLineBufLCY.IncrAmounts(PrepmtInvLineBuf);

      OnAfterRoundAmounts(SalesHeader,PrepmtInvLineBuf,TotalPrepmtInvLineBuf,TotalPrepmtInvLineBufLCY);
    END;

    LOCAL PROCEDURE AmountToLCY(SalesHeader : Record 36;TotalAmt : Decimal;PrevTotalAmt : Decimal) : Decimal;
    VAR
      CurrExchRate : Record 330;
    BEGIN
      CurrExchRate.INIT;
      WITH SalesHeader DO
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",TotalAmt,"Currency Factor")) -
          PrevTotalAmt);
    END;

    LOCAL PROCEDURE BuildInvLineBuffer(SalesHeader : Record 36;VAR SalesLine : Record 37;DocumentType : Option;VAR PrepmtInvLineBuf : Record 461;UpdateLines : Boolean);
    VAR
      PrepmtInvLineBuf2 : Record 461;
      TotalPrepmtInvLineBuffer : Record 461;
      TotalPrepmtInvLineBufferDummy : Record 461;
      SalesSetup : Record 311;
    BEGIN
      WITH SalesHeader DO BEGIN
        TempGlobalPrepmtInvLineBuf.RESET;
        TempGlobalPrepmtInvLineBuf.DELETEALL;
        SalesSetup.GET;
        ApplyFilter(SalesHeader,DocumentType,SalesLine);
        IF SalesLine.FIND('-') THEN
          REPEAT
            IF PrepmtAmount(SalesLine,DocumentType) <> 0 THEN BEGIN
              IF SalesLine.Quantity < 0 THEN
                SalesLine.FIELDERROR(Quantity,STRSUBSTNO(Text018,FIELDCAPTION("Prepayment %")));
              IF SalesLine."Unit Price" < 0 THEN
                SalesLine.FIELDERROR("Unit Price",STRSUBSTNO(Text018,FIELDCAPTION("Prepayment %")));

              FillInvLineBuffer(SalesHeader,SalesLine,PrepmtInvLineBuf2);
              IF UpdateLines THEN
                TempGlobalPrepmtInvLineBuf.CopyWithLineNo(PrepmtInvLineBuf2,SalesLine."Line No.");
              PrepmtInvLineBuf.InsertInvLineBuffer(PrepmtInvLineBuf2);
              IF SalesSetup."Invoice Rounding" THEN
                RoundAmounts(SalesHeader,PrepmtInvLineBuf2,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferDummy);
            END;
          UNTIL SalesLine.NEXT = 0;
        IF SalesSetup."Invoice Rounding" THEN
          IF InsertInvoiceRounding(
               SalesHeader,PrepmtInvLineBuf2,TotalPrepmtInvLineBuffer,SalesLine."Line No.")
          THEN
            PrepmtInvLineBuf.InsertInvLineBuffer(PrepmtInvLineBuf2);
      END;
    END;

    //[External]
    PROCEDURE BuildInvLineBuffer2(SalesHeader : Record 36;VAR SalesLine : Record 37;DocumentType : Option "Invoice","Credit Memo","Statistic";VAR PrepmtInvLineBuf : Record 461);
    BEGIN
      BuildInvLineBuffer(SalesHeader,SalesLine,DocumentType,PrepmtInvLineBuf,FALSE);
    END;

    LOCAL PROCEDURE AdjustInvLineBuffers(SalesHeader : Record 36;VAR PrepmtInvLineBuf : Record 461;VAR TotalPrepmtInvLineBuf : Record 461;DocumentType : Option "Invoice","Credit Memo");
    VAR
      VATAdjustment : ARRAY [2] OF Decimal;
      VAT : Option " ","Base","Amount";
    BEGIN
      CalcPrepmtAmtInvLCYInLines(SalesHeader,PrepmtInvLineBuf,DocumentType,VATAdjustment);
      IF ABS(VATAdjustment[VAT::Base]) > GLSetup."Amount Rounding Precision" THEN
        InsertCorrInvLineBuffer(PrepmtInvLineBuf,SalesHeader,VATAdjustment[VAT::Base])
      ELSE
        IF (VATAdjustment[VAT::Base] <> 0) OR (VATAdjustment[VAT::Amount] <> 0) THEN BEGIN
          PrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
          TotalPrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
        END;
    END;

    LOCAL PROCEDURE CalcPrepmtAmtInvLCYInLines(SalesHeader : Record 36;VAR PrepmtInvLineBuf : Record 461;DocumentType : Option "Invoice","Credit Memo";VAR VATAdjustment : ARRAY [2] OF Decimal);
    VAR
      SalesLine : Record 37;
      PrepmtInvBufAmount : ARRAY [2] OF Decimal;
      TotalAmount : ARRAY [2] OF Decimal;
      LineAmount : ARRAY [2] OF Decimal;
      Ratio : ARRAY [2] OF Decimal;
      PrepmtAmtReminder : ARRAY [2] OF Decimal;
      PrepmtAmountRnded : ARRAY [2] OF Decimal;
      VAT : Option " ","Base","Amount";
    BEGIN
      PrepmtInvLineBuf.AmountsToArray(PrepmtInvBufAmount);
      IF DocumentType = DocumentType::Invoice THEN
        ReverseDecArray(PrepmtInvBufAmount);

      TempGlobalPrepmtInvLineBuf.SetFilterOnPKey(PrepmtInvLineBuf);
      TempGlobalPrepmtInvLineBuf.CALCSUMS(Amount,"Amount Incl. VAT");
      TempGlobalPrepmtInvLineBuf.AmountsToArray(TotalAmount);
      FOR VAT := VAT::Base TO VAT::Amount DO
        IF TotalAmount[VAT] = 0 THEN
          Ratio[VAT] := 0
        ELSE
          Ratio[VAT] := PrepmtInvBufAmount[VAT] / TotalAmount[VAT];
      IF TempGlobalPrepmtInvLineBuf.FINDSET THEN
        REPEAT
          TempGlobalPrepmtInvLineBuf.AmountsToArray(LineAmount);
          PrepmtAmountRnded[VAT::Base] :=
            CalcRoundedAmount(LineAmount[VAT::Base],Ratio[VAT::Base],PrepmtAmtReminder[VAT::Base]);
          PrepmtAmountRnded[VAT::Amount] :=
            CalcRoundedAmount(LineAmount[VAT::Amount],Ratio[VAT::Amount],PrepmtAmtReminder[VAT::Amount]);

          SalesLine.GET(SalesHeader."Document Type",SalesHeader."No.",TempGlobalPrepmtInvLineBuf."Line No.");
          IF DocumentType = DocumentType::"Credit Memo" THEN BEGIN
            VATAdjustment[VAT::Base] += SalesLine."Prepmt. Amount Inv. (LCY)" - PrepmtAmountRnded[VAT::Base];
            SalesLine."Prepmt. Amount Inv. (LCY)" := 0;
            VATAdjustment[VAT::Amount] += SalesLine."Prepmt. VAT Amount Inv. (LCY)" - PrepmtAmountRnded[VAT::Amount];
            SalesLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
          END ELSE BEGIN
            SalesLine."Prepmt. Amount Inv. (LCY)" += PrepmtAmountRnded[VAT::Base];
            SalesLine."Prepmt. VAT Amount Inv. (LCY)" += PrepmtAmountRnded[VAT::Amount];
          END;
          SalesLine.MODIFY;
        UNTIL TempGlobalPrepmtInvLineBuf.NEXT = 0;
      TempGlobalPrepmtInvLineBuf.DELETEALL;
    END;

    LOCAL PROCEDURE CalcRoundedAmount(LineAmount : Decimal;Ratio : Decimal;VAR Reminder : Decimal) RoundedAmount : Decimal;
    VAR
      Amount : Decimal;
    BEGIN
      Amount := Reminder + LineAmount * Ratio;
      RoundedAmount := ROUND(Amount);
      Reminder := Amount - RoundedAmount;
    END;

    LOCAL PROCEDURE ReverseDecArray(VAR DecArray : ARRAY [2] OF Decimal);
    VAR
      Idx : Integer;
    BEGIN
      FOR Idx := 1 TO ARRAYLEN(DecArray) DO
        DecArray[Idx] := -DecArray[Idx];
    END;

    LOCAL PROCEDURE InsertCorrInvLineBuffer(VAR PrepmtInvLineBuf : Record 461;SalesHeader : Record 36;VATBaseAdjustment : Decimal);
    VAR
      NewPrepmtInvLineBuf : Record 461;
      SavedPrepmtInvLineBuf : Record 461;
      AdjmtAmountACY : Decimal;
    BEGIN
      SavedPrepmtInvLineBuf := PrepmtInvLineBuf;

      IF SalesHeader."Currency Code" = '' THEN
        AdjmtAmountACY := VATBaseAdjustment
      ELSE
        AdjmtAmountACY := 0;

      NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
        PrepmtInvLineBuf,
        GetPrepmtAccNo(PrepmtInvLineBuf."Gen. Bus. Posting Group",PrepmtInvLineBuf."Gen. Prod. Posting Group"),
        VATBaseAdjustment,AdjmtAmountACY);
      PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

      NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
        PrepmtInvLineBuf,
        GetCorrBalAccNo(SalesHeader,VATBaseAdjustment > 0),
        -VATBaseAdjustment,-AdjmtAmountACY);
      PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

      PrepmtInvLineBuf := SavedPrepmtInvLineBuf;
    END;

    LOCAL PROCEDURE GetPrepmtAccNo(GenBusPostingGroup : Code[20];GenProdPostingGroup : Code[20]) : Code[20];
    BEGIN
      IF (GenBusPostingGroup <> GenPostingSetup."Gen. Bus. Posting Group") OR
         (GenProdPostingGroup <> GenPostingSetup."Gen. Prod. Posting Group")
      THEN
        GenPostingSetup.GET(GenBusPostingGroup,GenProdPostingGroup);
      EXIT(GenPostingSetup.GetSalesPrepmtAccount);
    END;

    //[External]
    PROCEDURE GetCorrBalAccNo(SalesHeader : Record 36;PositiveAmount : Boolean) : Code[20];
    VAR
      BalAccNo : Code[20];
    BEGIN
      IF SalesHeader."Currency Code" = '' THEN
        BalAccNo := GetInvRoundingAccNo(SalesHeader."Customer Posting Group")
      ELSE
        BalAccNo := GetGainLossGLAcc(SalesHeader."Currency Code",PositiveAmount);
      EXIT(BalAccNo);
    END;

    //[External]
    PROCEDURE GetInvRoundingAccNo(CustomerPostingGroup : Code[20]) : Code[20];
    VAR
      CustPostingGr : Record 92;
      GLAcc : Record 15;
    BEGIN
      CustPostingGr.GET(CustomerPostingGroup);
      GLAcc.GET(CustPostingGr.GetInvRoundingAccount);
      EXIT(CustPostingGr."Invoice Rounding Account");
    END;

    LOCAL PROCEDURE GetGainLossGLAcc(CurrencyCode : Code[10];PositiveAmount : Boolean) : Code[20];
    VAR
      Currency : Record 4;
    BEGIN
      Currency.GET(CurrencyCode);
      IF PositiveAmount THEN
        EXIT(Currency.GetRealizedGainsAccount);
      EXIT(Currency.GetRealizedLossesAccount);
    END;

    LOCAL PROCEDURE GetCurrencyAmountRoundingPrecision(CurrencyCode : Code[10]) : Decimal;
    VAR
      Currency : Record 4;
    BEGIN
      Currency.Initialize(CurrencyCode);
      Currency.TESTFIELD("Amount Rounding Precision");
      EXIT(Currency."Amount Rounding Precision");
    END;

    //[External]
    PROCEDURE FillInvLineBuffer(SalesHeader : Record 36;SalesLine : Record 37;VAR PrepmtInvLineBuf : Record 461);
    BEGIN
      WITH PrepmtInvLineBuf DO BEGIN
        INIT;
        "G/L Account No." := GetPrepmtAccNo(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");

        IF NOT SalesHeader."Compress Prepayment" THEN BEGIN
          "Line No." := SalesLine."Line No.";
          Description := SalesLine.Description;
        END;

        CopyFromSalesLine(SalesLine);
        FillFromGLAcc(SalesHeader."Compress Prepayment");

        SetAmounts(
          SalesLine."Prepayment Amount",SalesLine."Prepmt. Amt. Incl. VAT",SalesLine."Prepayment Amount",
          SalesLine."Prepayment Amount",SalesLine."Prepayment Amount",SalesLine."Prepayment VAT Difference");

        "VAT Amount" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
        "VAT Amount (ACY)" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
        "VAT Base Before Pmt. Disc." := -SalesLine."Prepayment Amount";
      END;

      OnAfterFillInvLineBuffer(PrepmtInvLineBuf,SalesLine);
    END;

    LOCAL PROCEDURE InsertInvoiceRounding(SalesHeader : Record 36;VAR PrepmtInvLineBuf : Record 461;TotalPrepmtInvLineBuf : Record 461;PrevLineNo : Integer) : Boolean;
    VAR
      SalesLine : Record 37;
    BEGIN
      IF InitInvoiceRoundingLine(SalesHeader,TotalPrepmtInvLineBuf."Amount Incl. VAT",SalesLine) THEN BEGIN
        CreateDimensions(SalesLine);
        WITH PrepmtInvLineBuf DO BEGIN
          INIT;
          "Line No." := PrevLineNo + 10000;
          "Invoice Rounding" := TRUE;
          "G/L Account No." := SalesLine."No.";

          CopyFromSalesLine(SalesLine);
          "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
          "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";

          SetAmounts(
            SalesLine."Line Amount",SalesLine."Amount Including VAT",SalesLine."Line Amount",
            SalesLine."Prepayment Amount",SalesLine."Line Amount",0);

          "VAT Amount" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
          "VAT Amount (ACY)" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
        END;
        OnAfterInsertInvoiceRounding(SalesHeader,PrepmtInvLineBuf,TotalPrepmtInvLineBuf,PrevLineNo);
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE InitInvoiceRoundingLine(SalesHeader : Record 36;TotalAmount : Decimal;VAR SalesLine : Record 37) : Boolean;
    VAR
      Currency : Record 4;
      InvoiceRoundingAmount : Decimal;
    BEGIN
      Currency.Initialize(SalesHeader."Currency Code");
      Currency.TESTFIELD("Invoice Rounding Precision");
      InvoiceRoundingAmount :=
        -ROUND(
          TotalAmount -
          ROUND(
            TotalAmount,
            Currency."Invoice Rounding Precision",
            Currency.InvoiceRoundingDirection),
          Currency."Amount Rounding Precision");

      IF InvoiceRoundingAmount = 0 THEN
        EXIT(FALSE);

      WITH SalesLine DO BEGIN
        SetHideValidationDialog(TRUE);
        "Document Type" := SalesHeader."Document Type";
        "Document No." := SalesHeader."No.";
        "System-Created Entry" := TRUE;
        Type := Type::"G/L Account";
        VALIDATE("No.",GetInvRoundingAccNo(SalesHeader."Customer Posting Group"));
        VALIDATE(Quantity,1);
        IF SalesHeader."Prices Including VAT" THEN
          VALIDATE("Unit Price",InvoiceRoundingAmount)
        ELSE
          VALIDATE(
            "Unit Price",
            ROUND(
              InvoiceRoundingAmount /
              (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
              Currency."Amount Rounding Precision"));
        "Prepayment Amount" := "Unit Price";
        VALIDATE("Amount Including VAT",InvoiceRoundingAmount);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CopyHeaderCommentLines(FromNumber : Code[20];ToDocType : Integer;ToNumber : Code[20]);
    VAR
      SalesCommentLine : Record 44;
      SalesReceivablesSetup : Record 311;
    BEGIN
      SalesReceivablesSetup.GET;
      IF NOT SalesReceivablesSetup."Copy Comments Order to Invoice" THEN
        EXIT;

      WITH SalesCommentLine DO
        CASE ToDocType OF
          DATABASE::"Sales Invoice Header":
            CopyHeaderComments("Document Type"::Order.AsInteger(),"Document Type"::"Posted Invoice".AsInteger(),FromNumber,ToNumber);
          DATABASE::"Sales Cr.Memo Header":
            CopyHeaderComments("Document Type"::Order.AsInteger(),"Document Type"::"Posted Credit Memo".AsInteger(),FromNumber,ToNumber);
        END;
    END;

    LOCAL PROCEDURE CopyLineCommentLines(FromNumber : Code[20];ToDocType : Integer;ToNumber : Code[20];FromLineNo : Integer;ToLineNo : Integer);
    VAR
      SalesCommentLine : Record 44;
      SalesReceivablesSetup : Record 311;
    BEGIN
      SalesReceivablesSetup.GET;
      IF NOT SalesReceivablesSetup."Copy Comments Order to Invoice" THEN
        EXIT;

      WITH SalesCommentLine DO
        CASE ToDocType OF
          DATABASE::"Sales Invoice Header":
            CopyLineComments("Document Type"::Order.AsInteger(),"Document Type"::"Posted Invoice".AsInteger(),FromNumber,ToNumber,FromLineNo,ToLineNo);
          DATABASE::"Sales Cr.Memo Header":
            CopyLineComments("Document Type"::Order.AsInteger(),"Document Type"::"Posted Credit Memo".AsInteger(),FromNumber,ToNumber,FromLineNo,ToLineNo);
        END;
    END;

    LOCAL PROCEDURE InsertExtendedText(TabNo : Integer;DocNo : Code[20];GLAccNo : Code[20];DocDate : Date;LanguageCode : Code[10];VAR PrevLineNo : Integer);
    VAR
      TempExtTextLine : Record 280 TEMPORARY;
      SalesInvLine : Record 113;
      SalesCrMemoLine : Record 115;
      TransferExtText : Codeunit 378;
      NextLineNo : Integer;
    BEGIN
      TransferExtText.PrepmtGetAnyExtText(GLAccNo,TabNo,DocDate,LanguageCode,TempExtTextLine);
      IF TempExtTextLine.FIND('-') THEN BEGIN
        NextLineNo := PrevLineNo + 10000;
        REPEAT
          CASE TabNo OF
            DATABASE::"Sales Invoice Line":
              BEGIN
                SalesInvLine.INIT;
                SalesInvLine."Document No." := DocNo;
                SalesInvLine."Line No." := NextLineNo;
                SalesInvLine.Description := TempExtTextLine.Text;
                SalesInvLine.INSERT;
              END;
            DATABASE::"Sales Cr.Memo Line":
              BEGIN
                SalesCrMemoLine.INIT;
                SalesCrMemoLine."Document No." := DocNo;
                SalesCrMemoLine."Line No." := NextLineNo;
                SalesCrMemoLine.Description := TempExtTextLine.Text;
                SalesCrMemoLine.INSERT;
              END;
          END;
          PrevLineNo := NextLineNo;
          NextLineNo := NextLineNo + 10000;
        UNTIL TempExtTextLine.NEXT = 0;
      END;
    END;

    //[External]
    PROCEDURE UpdateVATOnLines(SalesHeader : Record 36;VAR SalesLine : Record 37;VAR VATAmountLine : Record 290;DocumentType : Option "Invoice","Credit Memo","Statistic");
    VAR
      TempVATAmountLineRemainder : Record 290 TEMPORARY;
      Currency : Record 4;
      PrepmtAmt : Decimal;
      NewAmount : Decimal;
      NewAmountIncludingVAT : Decimal;
      NewVATBaseAmount : Decimal;
      VATAmount : Decimal;
      VATDifference : Decimal;
      PrepmtAmtToInvTotal : Decimal;
    BEGIN
      Currency.Initialize(SalesHeader."Currency Code");

      WITH SalesLine DO BEGIN
        ApplyFilter(SalesHeader,DocumentType,SalesLine);
        LOCKTABLE;
        CALCSUMS("Prepmt. Line Amount","Prepmt. Amt. Inv.");
        PrepmtAmtToInvTotal := "Prepmt. Line Amount" - "Prepmt. Amt. Inv.";
        IF FINDSET THEN
          REPEAT
            PrepmtAmt := PrepmtAmount(SalesLine,DocumentType);
            IF PrepmtAmt <> 0 THEN BEGIN
              VATAmountLine.GET(
                "Prepayment VAT Identifier","Prepmt. VAT Calc. Type","Prepayment Tax Group Code",FALSE,PrepmtAmt >= 0);
              IF VATAmountLine.Modified THEN BEGIN
                IF NOT TempVATAmountLineRemainder.GET(
                     "Prepayment VAT Identifier","Prepmt. VAT Calc. Type","Prepayment Tax Group Code",FALSE,PrepmtAmt >= 0)
                THEN BEGIN
                  TempVATAmountLineRemainder := VATAmountLine;
                  TempVATAmountLineRemainder.INIT;
                  TempVATAmountLineRemainder.INSERT;
                END;

                IF SalesHeader."Prices Including VAT" THEN BEGIN
                  IF PrepmtAmt = 0 THEN BEGIN
                    VATAmount := 0;
                    NewAmountIncludingVAT := 0;
                  END ELSE BEGIN
                    VATAmount :=
                      TempVATAmountLineRemainder."VAT Amount" +
                      (VATAmountLine."VAT Amount" + VATAmountLine."EC Amount") * PrepmtAmt / VATAmountLine."Line Amount";
                    NewAmountIncludingVAT :=
                      TempVATAmountLineRemainder."Amount Including VAT" +
                      VATAmountLine."Amount Including VAT" * PrepmtAmt / VATAmountLine."Line Amount";
                  END;
                  NewAmount :=
                    ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                    ROUND(VATAmount,Currency."Amount Rounding Precision");
                  NewVATBaseAmount :=
                    ROUND(
                      NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                      Currency."Amount Rounding Precision");
                END ELSE BEGIN
                  IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                    VATAmount := PrepmtAmt;
                    NewAmount := 0;
                    NewVATBaseAmount := 0;
                  END ELSE BEGIN
                    NewAmount := PrepmtAmt;
                    NewVATBaseAmount :=
                      ROUND(
                        NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                        Currency."Amount Rounding Precision");
                    IF VATAmountLine."VAT Base" = 0 THEN
                      VATAmount := 0
                    ELSE
                      VATAmount :=
                        TempVATAmountLineRemainder."VAT Amount" +
                        (VATAmountLine."VAT Amount" + VATAmountLine."EC Amount") * NewAmount / VATAmountLine."VAT Base";
                  END;
                  NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                END;

                "Prepayment Amount" := NewAmount;
                "Prepmt. Amt. Incl. VAT" :=
                  ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                "Prepmt. VAT Base Amt." := NewVATBaseAmount;

                IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 THEN
                  VATDifference := 0
                ELSE
                  IF PrepmtAmtToInvTotal = 0 THEN
                    VATDifference :=
                      VATAmountLine."VAT Difference" * ("Prepmt. Line Amount" - "Prepmt. Amt. Inv.") /
                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount")
                  ELSE
                    VATDifference :=
                      VATAmountLine."VAT Difference" * ("Prepmt. Line Amount" - "Prepmt. Amt. Inv.") /
                      PrepmtAmtToInvTotal;

                "Prepayment VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");

                MODIFY;

                TempVATAmountLineRemainder."Amount Including VAT" :=
                  NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                TempVATAmountLineRemainder."VAT Difference" := VATDifference - "Prepayment VAT Difference";
                TempVATAmountLineRemainder.MODIFY;
              END;
            END;
          UNTIL NEXT = 0;
      END;

      OnAfterUpdateVATOnLines(SalesHeader,SalesLine,VATAmountLine,DocumentType);
    END;

    //[External]
    PROCEDURE CalcVATAmountLines(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;VAR VATAmountLine : Record 290;DocumentType : Option "Invoice","Credit Memo","Statistic");
    VAR
      Currency : Record 4;
      NewAmount : Decimal;
      NewPrepmtVATDiffAmt : Decimal;
    BEGIN
      Currency.Initialize(SalesHeader."Currency Code");

      VATAmountLine.DELETEALL;

      WITH SalesLine DO BEGIN
        ApplyFilter(SalesHeader,DocumentType,SalesLine);
        IF FIND('-') THEN
          REPEAT
            NewAmount := PrepmtAmount(SalesLine,DocumentType);
            IF NewAmount <> 0 THEN BEGIN
              IF DocumentType = DocumentType::Invoice THEN
                NewAmount := "Prepmt. Line Amount";
              IF "Prepmt. VAT Calc. Type" IN
                 ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
              THEN
                "VAT %" := 0;
              IF NOT VATAmountLine.GET(
                   "Prepayment VAT Identifier","Prepmt. VAT Calc. Type","Prepayment Tax Group Code",FALSE,NewAmount >= 0)
              THEN
                VATAmountLine.InsertNewLine(
                  "Prepayment VAT Identifier","Prepmt. VAT Calc. Type","Prepayment Tax Group Code",FALSE,
                  "Prepayment VAT %",NewAmount >= 0,TRUE,"Prepayment EC %");

              VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + NewAmount;
              NewPrepmtVATDiffAmt := PrepmtVATDiffAmount(SalesLine,DocumentType);
              IF DocumentType = DocumentType::Invoice THEN
                NewPrepmtVATDiffAmt := "Prepayment VAT Difference" + "Prepmt VAT Diff. to Deduct" +
                  "Prepmt VAT Diff. Deducted";
              VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + NewPrepmtVATDiffAmt;
              VATAmountLine.MODIFY;
            END;
          UNTIL NEXT = 0;
      END;

      VATAmountLine.UpdateLines(
        NewAmount,Currency,SalesHeader."Currency Factor",SalesHeader."Prices Including VAT",
        SalesHeader."VAT Base Discount %",SalesHeader."Tax Area Code",SalesHeader."Tax Liable",SalesHeader."Posting Date");

      OnAfterCalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,DocumentType);
    END;

    //[External]
    PROCEDURE SumPrepmt(SalesHeader : Record 36;VAR SalesLine : Record 37;VAR VATAmountLine : Record 290;VAR TotalAmount : Decimal;VAR TotalVATAmount : Decimal;VAR VATAmountText : Text[30]);
    VAR
      TempPrepmtInvLineBuf : Record 461 TEMPORARY;
      TotalPrepmtInvLineBuf : Record 461;
      TotalPrepmtInvLineBufLCY : Record 461;
      DifVATPct : Boolean;
      PrevVATPct : Decimal;
    BEGIN
      CalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,2);
      UpdateVATOnLines(SalesHeader,SalesLine,VATAmountLine,2);
      BuildInvLineBuffer(SalesHeader,SalesLine,2,TempPrepmtInvLineBuf,FALSE);
      IF TempPrepmtInvLineBuf.FIND('-') THEN BEGIN
        // PrevVATPct := TempPrepmtInvLineBuf."VAT %" + TempPrepmtInvLineBuf."EC %";
        REPEAT
          RoundAmounts(SalesHeader,TempPrepmtInvLineBuf,TotalPrepmtInvLineBuf,TotalPrepmtInvLineBufLCY);
          // IF (TempPrepmtInvLineBuf."VAT %" + TempPrepmtInvLineBuf."EC %") <> PrevVATPct THEN
          //   DifVATPct := TRUE;
        UNTIL TempPrepmtInvLineBuf.NEXT = 0;
      END;

      TotalAmount := TotalPrepmtInvLineBuf.Amount;
      TotalVATAmount := TotalPrepmtInvLineBuf."VAT Amount";
      // IF DifVATPct OR ((TempPrepmtInvLineBuf."VAT %" = 0) AND (TempPrepmtInvLineBuf."EC %" = 0)) THEN
      //   VATAmountText := Text014
      // ELSE
      //   VATAmountText := STRSUBSTNO(Text015,PrevVATPct);
    END;

    //[External]
    PROCEDURE GetSalesLines(SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo","Statistic";VAR ToSalesLine : Record 37);
    VAR
      SalesSetup : Record 311;
      FromSalesLine : Record 37;
      InvRoundingSalesLine : Record 37;
      TempVATAmountLine : Record 290 TEMPORARY;
      TotalAmt : Decimal;
      NextLineNo : Integer;
    BEGIN
      ApplyFilter(SalesHeader,DocumentType,FromSalesLine);
      IF FromSalesLine.FIND('-') THEN BEGIN
        REPEAT
          ToSalesLine := FromSalesLine;
          ToSalesLine.INSERT;
        UNTIL FromSalesLine.NEXT = 0;

        SalesSetup.GET;
        IF SalesSetup."Invoice Rounding" THEN BEGIN
          CalcVATAmountLines(SalesHeader,ToSalesLine,TempVATAmountLine,2);
          UpdateVATOnLines(SalesHeader,ToSalesLine,TempVATAmountLine,2);
          ToSalesLine.CALCSUMS("Prepmt. Amt. Incl. VAT");
          TotalAmt := ToSalesLine."Prepmt. Amt. Incl. VAT";
          ToSalesLine.FINDLAST;
          IF InitInvoiceRoundingLine(SalesHeader,TotalAmt,InvRoundingSalesLine) THEN
            WITH ToSalesLine DO BEGIN
              NextLineNo := "Line No." + 1;
              ToSalesLine := InvRoundingSalesLine;
              "Line No." := NextLineNo;

              IF DocumentType <> DocumentType::"Credit Memo" THEN
                "Prepmt. Line Amount" := "Line Amount"
              ELSE
                "Prepmt. Amt. Inv." := "Line Amount";
              "Prepmt. VAT Calc. Type" := "VAT Calculation Type";
              "Prepayment VAT Identifier" := "VAT Identifier";
              "Prepayment Tax Group Code" := "Tax Group Code";
              "Prepayment VAT Identifier" := "VAT Identifier";
              "Prepayment Tax Group Code" := "Tax Group Code";
              "Prepayment VAT %" := "VAT %";
              "Prepayment EC %" := "EC %";
              INSERT;
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE CheckDim(SalesHeader : Record 36);
    VAR
      SalesLine : Record 37;
    BEGIN
      SalesLine."Line No." := 0;
      CheckDimValuePosting(SalesHeader,SalesLine);
      CheckDimComb(SalesHeader,SalesLine);

      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine.SETFILTER(Type,'<>%1',SalesLine.Type::" ");
      IF SalesLine.FIND('-') THEN
        REPEAT
          CheckDimComb(SalesHeader,SalesLine);
          CheckDimValuePosting(SalesHeader,SalesLine);
        UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ApplyFilter(SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo","Statistic";VAR SalesLine : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        RESET;
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        SETFILTER(Type,'<>%1',Type::" ");
        IF DocumentType IN [DocumentType::Invoice,DocumentType::Statistic] THEN
          SETFILTER("Prepmt. Line Amount",'<>0')
        ELSE
          SETFILTER("Prepmt. Amt. Inv.",'<>0');
      END;
    END;

    //[External]
    PROCEDURE PrepmtAmount(SalesLine : Record 37;DocumentType : Option "Invoice","Credit Memo","Statistic") : Decimal;
    BEGIN
      WITH SalesLine DO
        CASE DocumentType OF
          DocumentType::Statistic:
            EXIT("Prepmt. Line Amount");
          DocumentType::Invoice:
            EXIT("Prepmt. Line Amount" - "Prepmt. Amt. Inv.");
          ELSE
            EXIT("Prepmt. Amt. Inv." - "Prepmt Amt Deducted");
        END;
    END;

    LOCAL PROCEDURE CheckDimComb(SalesHeader : Record 36;SalesLine : Record 37);
    VAR
      DimMgt : Codeunit 408;
    BEGIN
      IF SalesLine."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(SalesHeader."Dimension Set ID") THEN
          ERROR(Text007,SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimCombErr);

      IF SalesLine."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(SalesLine."Dimension Set ID") THEN
          ERROR(Text008,SalesHeader."Document Type",SalesHeader."No.",SalesLine."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(SalesHeader : Record 36;VAR SalesLine : Record 37);
    VAR
      DimMgt : Codeunit 408;
      DimMgt1 : Codeunit 50361;
      TableIDArr : ARRAY [10] OF Integer;
      NumberArr : ARRAY [10] OF Code[20];
    BEGIN
      IF SalesLine."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Customer;
        NumberArr[1] := SalesHeader."Bill-to Customer No.";
        TableIDArr[2] := DATABASE::Job;
        // NumberArr[2] := SalesHeader."Job No.";
        TableIDArr[3] := DATABASE::"Salesperson/Purchaser";
        NumberArr[3] := SalesHeader."Salesperson Code";
        TableIDArr[4] := DATABASE::Campaign;
        NumberArr[4] := SalesHeader."Campaign No.";
        TableIDArr[5] := DATABASE::"Responsibility Center";
        NumberArr[5] := SalesHeader."Responsibility Center";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesHeader."Dimension Set ID") THEN
          ERROR(
            Text009,
            SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DimMgt1.TypeToTableID3(SalesLine.Type);
        NumberArr[1] := SalesLine."No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := SalesLine."Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesLine."Dimension Set ID") THEN
          ERROR(
            Text010,
            SalesHeader."Document Type",SalesHeader."No.",SalesLine."Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE PostPrepmtInvLineBuffer(SalesHeader : Record 36;PrepmtInvLineBuffer : Record 461;DocumentType : Option "Invoice","Credit Memo";PostingDescription : Text[50];DocType : Enum "Gen. Journal Document Type";DocNo : Code[20];ExtDocNo : Text[35];SrcCode : Code[10];PostingNoSeriesCode : Code[20]);
    VAR
      GenJnlLine : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",PostingDescription,
          PrepmtInvLineBuffer."Global Dimension 1 Code",PrepmtInvLineBuffer."Global Dimension 2 Code",
          PrepmtInvLineBuffer."Dimension Set ID",SalesHeader."Reason Code");

        CopyDocumentFields(DocType,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode);
        CopyFromSalesHeaderPrepmt(SalesHeader);
        CopyFromPrepmtInvoiceBuffer(PrepmtInvLineBuffer);

        IF NOT PrepmtInvLineBuffer.Adjustment THEN
          "Gen. Posting Type" := "Gen. Posting Type"::Sale;
        Correction :=
          (DocumentType = DocumentType::"Credit Memo") AND GLSetup."Mark Cr. Memos as Corrections";

        OnBeforePostPrepmtInvLineBuffer(GenJnlLine,PrepmtInvLineBuffer,SuppressCommit);
        RunGenJnlPostLine(GenJnlLine);
        OnAfterPostPrepmtInvLineBuffer(GenJnlLine,PrepmtInvLineBuffer,SuppressCommit,GenJnlPostLine);
      END;
    END;

    LOCAL PROCEDURE PostCustomerEntry(SalesHeader : Record 36;TotalPrepmtInvLineBuffer : Record 461;TotalPrepmtInvLineBufferLCY : Record 461;DocumentType : Option "Invoice","Credit Memo";PostingDescription : Text[50];DocType : Enum "Gen. Journal Document Type";DocNo : Code[20];ExtDocNo : Text[35];SrcCode : Code[10];PostingNoSeriesCode : Code[20];CalcPmtDisc : Boolean);
    VAR
      GenJnlLine : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",PostingDescription,
          SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
          SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

        CopyDocumentFields(DocType,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode);

        CopyFromSalesHeaderPrepmtPost(SalesHeader,(DocumentType = DocumentType::Invoice) OR CalcPmtDisc);

        Amount := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
        "Source Currency Amount" := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
        "Amount (LCY)" := -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT";
        "Sales/Purch. (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
        "Profit (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;

        Correction := (DocumentType = DocumentType::"Credit Memo") AND GLSetup."Mark Cr. Memos as Corrections";

        OnBeforePostCustomerEntry(GenJnlLine,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,SuppressCommit);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        OnAfterPostCustomerEntry(GenJnlLine,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE PostBalancingEntry(SalesHeader : Record 36;TotalPrepmtInvLineBuffer : Record 461;TotalPrepmtInvLineBufferLCY : Record 461;CustLedgEntry : Record 21;DocumentType : Option "Invoice","Credit Memo";PostingDescription : Text[50];DocType : Option;DocNo : Code[20];ExtDocNo : Text[35];SrcCode : Code[10];PostingNoSeriesCode : Code[20]);
    VAR
      GenJnlLine : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",PostingDescription,
          SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
          SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

        IF DocType = "Document Type"::"Credit Memo".AsInteger() THEN
          CopyDocumentFields("Document Type"::Refund,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode)
        ELSE
          CopyDocumentFields("Document Type"::Payment,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode);

        CopyFromSalesHeaderPrepmtPost(SalesHeader,FALSE);
        IF SalesHeader."Bal. Account Type" = SalesHeader."Bal. Account Type"::"Bank Account" THEN
          "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
        "Bal. Account No." := SalesHeader."Bal. Account No.";

        Amount := TotalPrepmtInvLineBuffer."Amount Incl. VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
        "Source Currency Amount" := Amount;
        CustLedgEntry.CALCFIELDS(Amount);
        IF CustLedgEntry.Amount = 0 THEN
          "Amount (LCY)" := TotalPrepmtInvLineBufferLCY."Amount Incl. VAT"
        ELSE
          "Amount (LCY)" :=
            TotalPrepmtInvLineBufferLCY."Amount Incl. VAT" +
            ROUND(
              CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");

        Correction := (DocumentType = DocumentType::"Credit Memo") AND GLSetup."Mark Cr. Memos as Corrections";

        "Applies-to Doc. Type" := Enum::"Gen. Journal Document Type".FromInteger(DocType);
        "Applies-to Doc. No." := DocNo;

        OnBeforePostBalancingEntry(GenJnlLine,CustLedgEntry,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,SuppressCommit);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        OnAfterPostBalancingEntry(GenJnlLine,CustLedgEntry,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE RunGenJnlPostLine(VAR GenJnlLine : Record 81);
    BEGIN
      GenJnlPostLine.RunWithCheck(GenJnlLine);
    END;

    //[External]
    PROCEDURE UpdatePrepmtAmountOnSaleslines(SalesHeader : Record 36;NewTotalPrepmtAmount : Decimal);
    VAR
      Currency : Record 4;
      SalesLine : Record 37;
      TotalLineAmount : Decimal;
      TotalPrepmtAmount : Decimal;
      TotalPrepmtAmtInv : Decimal;
      LastLineNo : Integer;
    BEGIN
      Currency.Initialize(SalesHeader."Currency Code");

      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        SETFILTER(Type,'<>%1',Type::" ");
        SETFILTER("Line Amount",'<>0');
        SETFILTER("Prepayment %",'<>0');
        LOCKTABLE;
        IF FIND('-') THEN
          REPEAT
            TotalLineAmount := TotalLineAmount + "Line Amount";
            TotalPrepmtAmtInv := TotalPrepmtAmtInv + "Prepmt. Amt. Inv.";
            LastLineNo := "Line No.";
          UNTIL NEXT = 0
        ELSE
          ERROR(Text017,FIELDCAPTION("Prepayment %"));
        IF TotalLineAmount = 0 THEN
          ERROR(Text013,NewTotalPrepmtAmount);
        IF NOT (NewTotalPrepmtAmount IN [TotalPrepmtAmtInv ..TotalLineAmount]) THEN
          ERROR(Text016,TotalPrepmtAmtInv,TotalLineAmount);
        IF FIND('-') THEN
          REPEAT
            IF "Line No." <> LastLineNo THEN
              VALIDATE(
                "Prepmt. Line Amount",
                ROUND(
                  NewTotalPrepmtAmount * "Line Amount" / TotalLineAmount,
                  Currency."Amount Rounding Precision"))
            ELSE
              VALIDATE("Prepmt. Line Amount",NewTotalPrepmtAmount - TotalPrepmtAmount);
            TotalPrepmtAmount := TotalPrepmtAmount + "Prepmt. Line Amount";
            MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreateDimensions(VAR SalesLine : Record 37);
    VAR
      SourceCodeSetup : Record 242;
      DimMgt : Codeunit 408;
      DimMgt1 : Codeunit 50361;
      TableID : ARRAY [10] OF Integer;
      No : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := DATABASE::"G/L Account";
      No[1] := SalesLine."No.";
      TableID[2] := DATABASE::Job;
      No[2] := SalesLine."Job No.";
      TableID[3] := DATABASE::"Responsibility Center";
      No[3] := SalesLine."Responsibility Center";
      SalesLine."Shortcut Dimension 1 Code" := '';
      SalesLine."Shortcut Dimension 2 Code" := '';
      SalesLine."Dimension Set ID" :=
        DimMgt1.GetRecDefaultDimID(
          SalesLine,0,TableID,No,SourceCodeSetup.Sales,
          SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code",SalesLine."Dimension Set ID",DATABASE::Customer);
    END;

    LOCAL PROCEDURE PrepmtDocTypeToDocType(DocumentType : Option "Invoice","Credit Memo") : Integer;
    BEGIN
      CASE DocumentType OF
        DocumentType::Invoice:
          EXIT(2);
        DocumentType::"Credit Memo":
          EXIT(3);
      END;
      EXIT(2);
    END;

    //[External]
    PROCEDURE GetSalesLinesToDeduct(SalesHeader : Record 36;VAR SalesLines : Record 37);
    VAR
      SalesLine : Record 37;
    BEGIN
      ApplyFilter(SalesHeader,1,SalesLine);
      IF SalesLine.FINDSET THEN
        REPEAT
          IF (PrepmtAmount(SalesLine,0) <> 0) AND (PrepmtAmount(SalesLine,1) <> 0) THEN BEGIN
            SalesLines := SalesLine;
            SalesLines.INSERT;
          END;
        UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE PrepmtVATDiffAmount(SalesLine : Record 37;DocumentType : Option "Invoice","Credit Memo","Statistic") : Decimal;
    BEGIN
      WITH SalesLine DO
        CASE DocumentType OF
          DocumentType::Statistic:
            EXIT("Prepayment VAT Difference");
          DocumentType::Invoice:
            EXIT("Prepayment VAT Difference");
          ELSE
            EXIT("Prepmt VAT Diff. to Deduct");
        END;
    END;

    LOCAL PROCEDURE UpdateSalesDocument(VAR SalesHeader : Record 36;VAR SalesLine : Record 37;DocumentType : Option "Invoice","Credit Memo";GenJnlLineDocNo : Code[20]);
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        IF DocumentType = DocumentType::Invoice THEN BEGIN
          "Last Prepayment No." := GenJnlLineDocNo;
          "Prepayment No." := '';
          SalesLine.SETFILTER("Prepmt. Line Amount",'<>0');
          IF SalesLine.FINDSET(TRUE) THEN
            REPEAT
              IF SalesLine."Prepmt. Line Amount" <> SalesLine."Prepmt. Amt. Inv." THEN BEGIN
                SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt. Line Amount";
                SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
                SalesLine.CalcPrepaymentToDeduct;
                SalesLine."Prepmt VAT Diff. to Deduct" :=
                  SalesLine."Prepmt VAT Diff. to Deduct" + SalesLine."Prepayment VAT Difference";
                SalesLine."Prepayment VAT Difference" := 0;
                SalesLine.MODIFY;
              END;
            UNTIL SalesLine.NEXT = 0;
        END ELSE BEGIN
          "Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
          "Prepmt. Cr. Memo No." := '';
          SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
          IF SalesLine.FINDSET(TRUE) THEN
            REPEAT
              SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt Amt Deducted";
              IF "Prices Including VAT" THEN
                SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Inv."
              ELSE
                SalesLine."Prepmt. Amount Inv. Incl. VAT" :=
                  ROUND(
                    SalesLine."Prepmt. Amt. Inv." * (100 + SalesLine."Prepayment VAT %") / 100,
                    GetCurrencyAmountRoundingPrecision(SalesLine."Currency Code"));
              SalesLine."Prepmt. Amt. Incl. VAT" := SalesLine."Prepmt. Amount Inv. Incl. VAT";
              SalesLine."Prepayment Amount" := SalesLine."Prepmt. Amt. Inv.";
              SalesLine."Prepmt Amt to Deduct" := 0;
              SalesLine."Prepmt VAT Diff. to Deduct" := 0;
              SalesLine."Prepayment VAT Difference" := 0;
              SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdatePostedSalesDocument(DocumentType : Option "Invoice","Credit Memo";DocumentNo : Code[20]);
    VAR
      CustLedgerEntry : Record 21;
      SalesInvoiceHeader : Record 112;
      SalesCrMemoHeader : Record 114;
    BEGIN
      CASE DocumentType OF
        DocumentType::Invoice:
          BEGIN
            CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
            CustLedgerEntry.SETRANGE("Document No.",DocumentNo);
            CustLedgerEntry.FINDFIRST;
            SalesInvoiceHeader.GET(DocumentNo);
            SalesInvoiceHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
            SalesInvoiceHeader.MODIFY;
          END;
        DocumentType::"Credit Memo":
          BEGIN
            CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::"Credit Memo");
            CustLedgerEntry.SETRANGE("Document No.",DocumentNo);
            CustLedgerEntry.FINDFIRST;
            SalesCrMemoHeader.GET(DocumentNo);
            SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
            SalesCrMemoHeader.MODIFY;
          END;
      END;

      OnAfterUpdatePostedSalesDocument(DocumentType,DocumentNo,SuppressCommit);
    END;

    LOCAL PROCEDURE InsertSalesInvHeader(VAR SalesInvHeader : Record 112;SalesHeader : Record 36;PostingDescription : Text[50];GenJnlLineDocNo : Code[20];SrcCode : Code[10];PostingNoSeriesCode : Code[20]);
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesInvHeader.INIT;
        SalesInvHeader.TRANSFERFIELDS(SalesHeader);
        SalesInvHeader."Posting Description" := PostingDescription;
        SalesInvHeader."Payment Terms Code" := "Prepmt. Payment Terms Code";
        SalesInvHeader."Due Date" := "Prepayment Due Date";
        SalesInvHeader."Pmt. Discount Date" := "Prepmt. Pmt. Discount Date";
        SalesInvHeader."Payment Discount %" := "Prepmt. Payment Discount %";
        SalesInvHeader."No." := GenJnlLineDocNo;
        SalesInvHeader."Pre-Assigned No. Series" := '';
        SalesInvHeader."Source Code" := SrcCode;
        SalesInvHeader."User ID" := USERID;
        SalesInvHeader."No. Printed" := 0;
        SalesInvHeader."Prepayment Invoice" := TRUE;
        SalesInvHeader."Prepayment Order No." := "No.";
        SalesInvHeader."No. Series" := PostingNoSeriesCode;
        OnBeforeSalesInvHeaderInsert(SalesInvHeader,SalesHeader,SuppressCommit);
        SalesInvHeader.INSERT;
        CopyHeaderCommentLines("No.",DATABASE::"Sales Invoice Header",GenJnlLineDocNo);
        OnAfterSalesInvHeaderInsert(SalesInvHeader,SalesHeader,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE InsertSalesInvLine(SalesInvHeader : Record 112;LineNo : Integer;PrepmtInvLineBuffer : Record 461;SalesHeader : Record 36);
    VAR
      SalesInvLine : Record 113;
    BEGIN
      WITH PrepmtInvLineBuffer DO BEGIN
        SalesInvLine.INIT;
        SalesInvLine."Document No." := SalesInvHeader."No.";
        SalesInvLine."Line No." := LineNo;
        SalesInvLine."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        SalesInvLine."Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
        SalesInvLine.Type := SalesInvLine.Type::"G/L Account";
        SalesInvLine."No." := "G/L Account No.";
        SalesInvLine."Posting Date" := SalesInvHeader."Posting Date";
        SalesInvLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
        SalesInvLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
        SalesInvLine."Dimension Set ID" := "Dimension Set ID";
        SalesInvLine.Description := Description;
        SalesInvLine.Quantity := 1;
        IF SalesInvHeader."Prices Including VAT" THEN BEGIN
          SalesInvLine."Unit Price" := "Amount Incl. VAT";
          SalesInvLine."Line Amount" := "Amount Incl. VAT";
        END ELSE BEGIN
          SalesInvLine."Unit Price" := Amount;
          SalesInvLine."Line Amount" := Amount;
        END;
        SalesInvLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        SalesInvLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        SalesInvLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
        SalesInvLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
        SalesInvLine."VAT %" := "VAT %";
        // SalesInvLine."EC %" := "EC %";
        SalesInvLine.Amount := Amount;
        SalesInvLine."VAT Difference" := "VAT Difference";
        SalesInvLine."Amount Including VAT" := "Amount Incl. VAT";
        SalesInvLine."VAT Calculation Type" := "VAT Calculation Type";
        SalesInvLine."VAT Base Amount" := "VAT Base Amount";
        SalesInvLine."VAT Identifier" := "VAT Identifier";
        OnBeforeSalesInvLineInsert(SalesInvLine,SalesInvHeader,PrepmtInvLineBuffer,SuppressCommit);
        SalesInvLine.INSERT;
        CopyLineCommentLines(
          SalesHeader."No.",DATABASE::"Sales Invoice Header",SalesInvHeader."No.","Line No.",LineNo);
        OnAfterSalesInvLineInsert(SalesInvLine,SalesInvHeader,PrepmtInvLineBuffer,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE InsertSalesCrMemoHeader(VAR SalesCrMemoHeader : Record 114;SalesHeader : Record 36;PostingDescription : Text[50];GenJnlLineDocNo : Code[20];SrcCode : Code[10];PostingNoSeriesCode : Code[20];CalcPmtDiscOnCrMemos : Boolean);
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesCrMemoHeader.INIT;
        SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
        SalesCrMemoHeader."Payment Terms Code" := "Prepmt. Payment Terms Code";
        SalesCrMemoHeader."Pmt. Discount Date" := "Prepmt. Pmt. Discount Date";
        SalesCrMemoHeader."Payment Discount %" := "Prepmt. Payment Discount %";
        IF ("Prepmt. Payment Terms Code" <> '') AND NOT CalcPmtDiscOnCrMemos THEN BEGIN
          SalesCrMemoHeader."Payment Discount %" := 0;
          SalesCrMemoHeader."Pmt. Discount Date" := 0D;
        END;
        SalesCrMemoHeader."Posting Description" := PostingDescription;
        SalesCrMemoHeader."Due Date" := "Prepayment Due Date";
        SalesCrMemoHeader."No." := GenJnlLineDocNo;
        SalesCrMemoHeader."Pre-Assigned No. Series" := '';
        SalesCrMemoHeader."Source Code" := SrcCode;
        SalesCrMemoHeader."User ID" := USERID;
        SalesCrMemoHeader."No. Printed" := 0;
        SalesCrMemoHeader."Prepayment Credit Memo" := TRUE;
        SalesCrMemoHeader."Prepayment Order No." := "No.";
        SalesCrMemoHeader.Correction := GLSetup."Mark Cr. Memos as Corrections";
        SalesCrMemoHeader."No. Series" := PostingNoSeriesCode;
        OnBeforeSalesCrMemoHeaderInsert(SalesCrMemoHeader,SalesHeader,SuppressCommit);
        SalesCrMemoHeader.INSERT;
        CopyHeaderCommentLines("No.",DATABASE::"Sales Cr.Memo Header",GenJnlLineDocNo);
        OnAfterSalesCrMemoHeaderInsert(SalesCrMemoHeader,SalesHeader,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE InsertSalesCrMemoLine(SalesCrMemoHeader : Record 114;LineNo : Integer;PrepmtInvLineBuffer : Record 461;SalesHeader : Record 36);
    VAR
      SalesCrMemoLine : Record 115;
    BEGIN
      WITH PrepmtInvLineBuffer DO BEGIN
        SalesCrMemoLine.INIT;
        SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
        SalesCrMemoLine."Line No." := LineNo;
        SalesCrMemoLine."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
        SalesCrMemoLine."Bill-to Customer No." := SalesCrMemoHeader."Bill-to Customer No.";
        SalesCrMemoLine.Type := SalesCrMemoLine.Type::"G/L Account";
        SalesCrMemoLine."No." := "G/L Account No.";
        SalesCrMemoLine."Posting Date" := SalesCrMemoHeader."Posting Date";
        SalesCrMemoLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
        SalesCrMemoLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
        SalesCrMemoLine."Dimension Set ID" := "Dimension Set ID";
        SalesCrMemoLine.Description := Description;
        SalesCrMemoLine.Quantity := 1;
        IF SalesCrMemoHeader."Prices Including VAT" THEN BEGIN
          SalesCrMemoLine."Unit Price" := "Amount Incl. VAT";
          SalesCrMemoLine."Line Amount" := "Amount Incl. VAT";
        END ELSE BEGIN
          SalesCrMemoLine."Unit Price" := Amount;
          SalesCrMemoLine."Line Amount" := Amount;
        END;
        SalesCrMemoLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        SalesCrMemoLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        SalesCrMemoLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
        SalesCrMemoLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
        SalesCrMemoLine."VAT %" := "VAT %";
        // SalesCrMemoLine."EC %" := "EC %";
        SalesCrMemoLine.Amount := Amount;
        SalesCrMemoLine."VAT Difference" := "VAT Difference";
        SalesCrMemoLine."Amount Including VAT" := "Amount Incl. VAT";
        SalesCrMemoLine."VAT Calculation Type" := "VAT Calculation Type";
        SalesCrMemoLine."VAT Base Amount" := "VAT Base Amount";
        SalesCrMemoLine."VAT Identifier" := "VAT Identifier";
        OnBeforeSalesCrMemoLineInsert(SalesCrMemoLine,SalesCrMemoHeader,PrepmtInvLineBuffer,SuppressCommit);
        SalesCrMemoLine.INSERT;
        CopyLineCommentLines(
          SalesHeader."No.",DATABASE::"Sales Cr.Memo Header",SalesCrMemoHeader."No.","Line No.",LineNo);
        OnAfterSalesCrMemoLineInsert(SalesCrMemoLine,SalesCrMemoHeader,PrepmtInvLineBuffer,SuppressCommit);
      END;
    END;

    LOCAL PROCEDURE GetCalcPmtDiscOnCrMemos(PrepmtPmtTermsCode : Code[10]) : Boolean;
    VAR
      PaymentTerms : Record 3;
    BEGIN
      IF PrepmtPmtTermsCode = '' THEN
        EXIT(FALSE);
      PaymentTerms.GET(PrepmtPmtTermsCode);
      EXIT(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
    END;

   

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcVATAmountLines(SalesHeader : Record 36;VAR SalesLine : Record 37;VAR VATAmountLine : Record 290;DocumentType : Option "Invoice","Credit Memo","Statistic");
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckPrepmtDoc(SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo";CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFillInvLineBuffer(VAR PrepmtInvLineBuf : Record 461;SalesLine : Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertInvoiceRounding(SalesHeader : Record 36;VAR PrepmtInvLineBuffer : Record 461;VAR TotalPrepmtInvLineBuf : Record 461;VAR PrevLineNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostPrepayments(VAR SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo";CommitIsSuppressed : Boolean;VAR SalesInvoiceHeader : Record 112;VAR SalesCrMemoHeader : Record 114);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostBalancingEntry(VAR GenJnlLine : Record 81;CustLedgEntry : Record 21;TotalPrepmtInvLineBuffer : Record 461;TotalPrepmtInvLineBufferLCY : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostCustomerEntry(VAR GenJnlLine : Record 81;TotalPrepmtInvLineBuffer : Record 461;TotalPrepmtInvLineBufferLCY : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostPrepmtInvLineBuffer(VAR GenJnlLine : Record 81;PrepmtInvLineBuffer : Record 461;CommitIsSuppressed : Boolean;VAR GenJnlPostLine : Codeunit 12);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRoundAmounts(SalesHeader : Record 36;VAR PrepmtInvLineBuffer : Record 461;VAR TotalPrepmtInvLineBuf : Record 461;VAR TotalPrepmtInvLineBufLCY : Record 461);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesInvHeaderInsert(VAR SalesInvoiceHeader : Record 112;SalesHeader : Record 36;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesInvLineInsert(VAR SalesInvLine : Record 113;SalesInvHeader : Record 112;PrepmtInvLineBuffer : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesCrMemoHeaderInsert(VAR SalesCrMemoHeader : Record 114;SalesHeader : Record 36;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSalesCrMemoLineInsert(VAR SalesCrMemoLine : Record 115;SalesCrMemoHeader : Record 114;PrepmtInvLineBuffer : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdatePostedSalesDocument(DocumentType : Option "Invoice","Credit Memo";DocumentNo : Code[20];CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdateVATOnLines(SalesHeader : Record 36;VAR SalesLine : Record 37;VAR VATAmountLine : Record 290;DocumentType : Option "Invoice","Credit Memo","Statistic");
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInvoice(VAR SalesHeader : Record 36;VAR Handled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreditMemo(VAR SalesHeader : Record 36;VAR Handled : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostPrepayments(VAR SalesHeader : Record 36;DocumentType : Option "Invoice","Credit Memo";CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesInvHeaderInsert(VAR SalesInvHeader : Record 112;SalesHeader : Record 36;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesInvLineInsert(VAR SalesInvLine : Record 113;SalesInvHeader : Record 112;PrepmtInvLineBuffer : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesCrMemoHeaderInsert(VAR SalesCrMemoHeader : Record 114;SalesHeader : Record 36;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSalesCrMemoLineInsert(VAR SalesCrMemoLine : Record 115;SalesCrMemoHeader : Record 114;PrepmtInvLineBuffer : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostBalancingEntry(VAR GenJnlLine : Record 81;CustLedgEntry : Record 21;TotalPrepmtInvLineBuffer : Record 461;TotalPrepmtInvLineBufferLCY : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostCustomerEntry(VAR GenJnlLine : Record 81;TotalPrepmtInvLineBuffer : Record 461;TotalPrepmtInvLineBufferLCY : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostPrepmtInvLineBuffer(VAR GenJnlLine : Record 81;PrepmtInvLineBuffer : Record 461;CommitIsSuppressed : Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}








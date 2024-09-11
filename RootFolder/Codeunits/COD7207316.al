Codeunit 7207316 "Day. (Element)-Register Line"
{
  
  
    TableNo=7207350;
    trigger OnRun()
BEGIN
            GeneralLedgerSetup.GET;
            RunWithCheck(Rec);
          END;
    VAR
      GeneralLedgerSetup : Record 98;
      ElementJournalLine2 : Record 7207350;
      ElementJournalLine : Record 7207350;
      LastDocNo : Code[20];
      LastLineNo : Integer;
      LastDate : Date;
      DayElementTestLine : Codeunit 7207315;
      RentalElementsEntries : Record 7207345;
      NextEntryNo : Integer;
      NextTransactionNo : Integer;
      CurrentBalance : Decimal;
      LastTempTransNo : Integer;
      AccountingPeriod : Record 50;
      FiscalYearStartDate : Date;
      JournalTemplateElement : Record 7207349;
      ElementPostingEntries : Record 7207352;
      RentalElementsEntriesTmp : Record 7207345;
      Text000 : TextConst ENU='%1 needs to be rounded',ESP='%1 necesita redondearse';
      RentalElementsEntriesMove : Record 7207345;
      RentalElements : Record 7207344;
      DimensionManagement : Codeunit 408;
      Text013 : TextConst ENU='A dimension used in %1 %2, %3, %4 has caused an error. %5',ESP='La dimensi�n util. en %1 %2, %3, %4 ha causado error. %5';

    PROCEDURE RunWithCheck(VAR PElementJournalLine : Record 7207350);
    BEGIN
      PElementJournalLine.COPY(ElementJournalLine2);
      Code(TRUE);
      ElementJournalLine2 := ElementJournalLine;
    END;

    LOCAL PROCEDURE Code(CheckLine : Boolean);
    BEGIN
      WITH ElementJournalLine DO BEGIN
        IF EmptyLine THEN BEGIN
          LastDocNo := "Document No.";
          LastLineNo := "Line No.";
          LastDate := "Posting Date";
          EXIT;
        END;

        IF CheckLine THEN
          DayElementTestLine.RunCheck(ElementJournalLine);
        IF ElementJournalLine."Document Date" = 0D THEN
          ElementJournalLine."Document Date" := ElementJournalLine."Posting Date";
        //Genero mov. producto

        PostItemJnlLine(ElementJournalLine);
        PostItemJnlLineRent(ElementJournalLine);

        InitCodeUnit;
        PostMaster;

        FinishCodeunit;

      END;
    END;

    LOCAL PROCEDURE PostItemJnlLine(PElementJournalLine : Record 7207350) : Integer;
    VAR
      LineDeliveryReturnElement : Record 7207357;
      OriginItemJournalLineOLD : Record 83;
      PostWhseJnlLineOLD : Boolean;
      ItemJournalLine : Record 83;
      RentalElements : Record 7207344;
      ItemJnlPostLine : Codeunit 22;
      LocItemJournalLine : Record 83;
      RentalElementsSetup : Record 7207346;
    BEGIN
      RentalElements.GET(PElementJournalLine."Element No.");
      IF RentalElements."Related Product" = '' THEN
        EXIT;
      RentalElementsSetup.GET;
      RentalElementsSetup.TESTFIELD(RentalElementsSetup."Rental Elements Location");
      WITH PElementJournalLine DO BEGIN
        ItemJournalLine.INIT;
        ItemJournalLine."Posting Date" := PElementJournalLine."Rent Effective Date";
        ItemJournalLine."Document Date" := PElementJournalLine."Posting Date";
        ItemJournalLine."Document No." := PElementJournalLine."Document No.";
        IF PElementJournalLine."Entry Type" = PElementJournalLine."Entry Type"::Delivery THEN
          ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt."
        ELSE
          ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
        ItemJournalLine.VALIDATE("Item No.",RentalElements."Related Product");
        ItemJournalLine.VALIDATE("Variant Code",PElementJournalLine."Variante Code");
        ItemJournalLine.VALIDATE(ItemJournalLine."Location Code",RentalElementsSetup."Rental Elements Location");
        ItemJournalLine.VALIDATE(ItemJournalLine."Unit of Measure Code",PElementJournalLine."Unit of Measure");
        ItemJournalLine."Unit Cost" := 0;
        ItemJournalLine.VALIDATE(ItemJournalLine.Quantity,PElementJournalLine.Quantity);
        ItemJournalLine."External Document No." := PElementJournalLine."Contract No.";
        ItemJournalLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJournalLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJournalLine."Source Code" := PElementJournalLine."Source Code";
        ItemJnlPostLine.RunWithCheck(ItemJournalLine);
      END;
    END;

    LOCAL PROCEDURE PostItemJnlLineRent(PElementJournalLine : Record 7207350) : Integer;
    VAR
      LineDeliveryReturnElement : Record 7207357;
      OriginItemJournalLineOLD : Record 83;
      PostWhseJnlLineOLD : Boolean;
      ItemJournalLine : Record 83;
      RentalElements : Record 7207344;
      ItemJnlPostLine : Codeunit 22;
      LocItemJournalLine : Record 83;
      RentalElementsSetup : Record 7207346;
    BEGIN
      RentalElements.GET(PElementJournalLine."Element No.");
      IF RentalElements."Related Product" = '' THEN
        EXIT;
      RentalElementsSetup.GET;
      RentalElementsSetup.TESTFIELD(RentalElementsSetup."Rental Elements Location");

      WITH PElementJournalLine DO BEGIN
        //ahora hago el movimiento hacia el almac�n de alquiler
        ItemJournalLine.INIT;
        ItemJournalLine."Posting Date" := PElementJournalLine."Rent Effective Date";
        ItemJournalLine."Document Date" := PElementJournalLine."Posting Date";
        ItemJournalLine."Document No." := PElementJournalLine."Document No.";
        IF PElementJournalLine."Entry Type" = PElementJournalLine."Entry Type"::Delivery THEN
          ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt."
        ELSE
          ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
        ItemJournalLine.VALIDATE("Item No.",RentalElements."Related Product");
        ItemJournalLine.VALIDATE("Variant Code",PElementJournalLine."Variante Code");
        ItemJournalLine.VALIDATE(ItemJournalLine."Location Code",PElementJournalLine."Location Code");

        ItemJournalLine.VALIDATE(ItemJournalLine."Unit of Measure Code",PElementJournalLine."Unit of Measure");
        ItemJournalLine."Unit Cost" := 0;
        ItemJournalLine.VALIDATE(ItemJournalLine.Quantity,PElementJournalLine.Quantity);
        ItemJournalLine."External Document No." := PElementJournalLine."Contract No.";
        ItemJournalLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJournalLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJournalLine."Source Code" := PElementJournalLine."Source Code";
        ItemJnlPostLine.RunWithCheck(ItemJournalLine);
      END;
    END;

    LOCAL PROCEDURE PostMaster();
    BEGIN
      WITH ElementJournalLine DO BEGIN
        InitMasterEntry("Element No.");
        RentalElementsEntries."Serie No." := "Posting No. Series";
        InsertMasterEntry(TRUE);
      END;
    END;

    LOCAL PROCEDURE InitCodeUnit();
    BEGIN
      WITH ElementJournalLine DO BEGIN
        IF NextEntryNo = 0 THEN BEGIN
          RentalElementsEntries.LOCKTABLE;
          IF RentalElementsEntries.FINDLAST THEN BEGIN
            NextEntryNo := RentalElementsEntries."Entry No." + 1;
            NextTransactionNo := RentalElementsEntries."Transaction No." + 1;
          END ELSE BEGIN
            NextEntryNo := 1;
            NextTransactionNo := 1;
          END;

          LastDocNo := "Document No.";
          LastLineNo := "Line No.";
          LastDate := "Posting Date";
          CurrentBalance := 0;
          LastTempTransNo := ElementJournalLine."Transaction No.";

          AccountingPeriod.RESET;
          AccountingPeriod.SETCURRENTKEY(Closed);
          AccountingPeriod.SETRANGE(Closed,FALSE);
          AccountingPeriod.FINDFIRST;
          FiscalYearStartDate := AccountingPeriod."Starting Date";

          GeneralLedgerSetup.GET;

          IF NOT JournalTemplateElement.GET("Journal Template Name") THEN
            JournalTemplateElement.INIT;


          ElementPostingEntries.LOCKTABLE;
          IF ElementPostingEntries.FINDLAST THEN
            ElementPostingEntries."Transaction No." := ElementPostingEntries."Transaction No." + 1
          ELSE
            ElementPostingEntries."Transaction No." := 1;
          ElementPostingEntries.INIT;
          ElementPostingEntries."From Entry No." := NextEntryNo;
          ElementPostingEntries."Creation Date" := TODAY;
          ElementPostingEntries."Source Code" := "Source Code";
          ElementPostingEntries."Journal Batch Name" := "Journal Batch Name";
          ElementPostingEntries."User ID" := USERID;
          ElementPostingEntries."Posting Date" := "Posting Date";
        END ELSE
          IF (LastDate <> "Posting Date") OR
              JournalTemplateElement."Force Doc. Balance" AND (LastDocNo <> "Document No.") OR
             (LastTempTransNo <> "Transaction No.") AND (NOT JournalTemplateElement."Force Doc. Balance")
          THEN BEGIN
            NextTransactionNo := NextTransactionNo + 1;
            LastDocNo := "Document No.";
            LastLineNo := "Line No.";
            LastDate := "Posting Date";

            LastTempTransNo := "Transaction No.";
            ElementPostingEntries.LOCKTABLE;
            ElementPostingEntries.FINDLAST;
            ElementPostingEntries."Transaction No." := ElementPostingEntries."Transaction No." + 1;
            ElementPostingEntries.INIT;
            ElementPostingEntries."From Entry No." := NextEntryNo;
            ElementPostingEntries."Creation Date" := TODAY;
            ElementPostingEntries."Source Code" := "Source Code";
            ElementPostingEntries."Journal Batch Name" := "Journal Batch Name";
            ElementPostingEntries."User ID" := USERID;
            ElementPostingEntries."Posting Date" := "Posting Date";

          END;

        RentalElementsEntriesTmp.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE FinishCodeunit();
    VAR
      DocIsRejected : Boolean;
    BEGIN
      WITH ElementJournalLine DO BEGIN
        IF RentalElementsEntriesTmp.FINDSET THEN BEGIN
          REPEAT
            RentalElementsEntries := RentalElementsEntriesTmp;
            RentalElementsEntries."Dimension Set ID" := ElementJournalLine."Dimensions Set ID";
            RentalElementsEntries.INSERT;
          UNTIL RentalElementsEntriesTmp.NEXT = 0;

          //ElementPostingEntries."To VAT Entry No." := NextVATEntryNo - 1;
          IF ElementPostingEntries."To Entry No." = 0 THEN BEGIN
            ElementPostingEntries."To Entry No." := RentalElementsEntries."Entry No.";
            ElementPostingEntries.INSERT;
          END ELSE BEGIN
            ElementPostingEntries."To Entry No." := RentalElementsEntries."Entry No.";
            ElementPostingEntries.MODIFY;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE InsertMasterEntry(CalcAddCurrResiduals : Boolean);
    VAR
      locrecCurrency : Record 4;
    BEGIN
      IF RentalElementsEntries."Unit Price" <> ROUND(RentalElementsEntries."Unit Price") THEN
      CLEAR(locrecCurrency);
      locrecCurrency.InitRoundingPrecision;
      IF RentalElementsEntries."Unit Price" <> ROUND(RentalElementsEntries."Unit Price",locrecCurrency."Unit-Amount Rounding Precision") THEN
        RentalElementsEntries.FIELDERROR(
          "Unit Price",
          STRSUBSTNO(Text000,RentalElementsEntries."Unit Price"));

      RentalElementsEntriesTmp := RentalElementsEntries;
      RentalElementsEntriesTmp.INSERT;

      IF RentalElementsEntriesMove.GET(ElementJournalLine."Applied Entry No.") THEN BEGIN
        RentalElementsEntriesMove."Return Last Date" :=ElementJournalLine."Rent Effective Date";
        RentalElementsEntriesMove.CALCFIELDS(RentalElementsEntriesMove."Return Quantity");
        IF (RentalElementsEntriesMove."Return Quantity" - RentalElementsEntries.Quantity) >= RentalElementsEntriesMove.Quantity THEN
          RentalElementsEntriesMove.Pending := FALSE
        ELSE
          RentalElementsEntriesMove.Pending := TRUE;
        RentalElementsEntriesMove.MODIFY;
      END;

      ElementPostingEntries."Source Code" := RentalElementsEntries."Source Code";

      NextEntryNo := NextEntryNo + 1;
    END;

    LOCAL PROCEDURE InitMasterEntry(GLAccNo : Code[20]);
    VAR
      TableID : ARRAY [10] OF Integer;
      AccNo : ARRAY [10] OF Code[20];
    BEGIN
      IF GLAccNo <> '' THEN BEGIN
        RentalElements.GET(GLAccNo);
        RentalElements.TESTFIELD(Blocked,FALSE);

        // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
          TableID[1] := DATABASE::"Rental Elements";
          AccNo[1] := GLAccNo;
          IF NOT DimensionManagement.CheckDimValuePosting(TableID,AccNo,ElementJournalLine."Dimensions Set ID") THEN
            IF ElementJournalLine."Line No." <> 0 THEN
              ERROR(
                Text013,
                ElementJournalLine.TABLECAPTION,ElementJournalLine."Journal Template Name",
                ElementJournalLine."Journal Batch Name",ElementJournalLine."Line No.",
                DimensionManagement.GetDimValuePostingErr)
            ELSE
              ERROR(DimensionManagement.GetDimValuePostingErr);
      END;

      RentalElementsEntries.INIT;
      RentalElementsEntries."Posting Date" := ElementJournalLine."Posting Date";
      RentalElementsEntries."Document Date" := ElementJournalLine."Document Date";
      RentalElementsEntries."Document No." := ElementJournalLine."Document No.";
      RentalElementsEntries."External Document No." := ElementJournalLine."External Document No.";
      RentalElementsEntries.Description := ElementJournalLine.Description;
      RentalElementsEntries."Business Unit Code" := ElementJournalLine."Business Unit Code";
      RentalElementsEntries."Global Dimension 1 Code" := ElementJournalLine."Shortcut Dimension 1 Code";
      RentalElementsEntries."Global Dimension 2 Code" := ElementJournalLine."Shortcut Dimension 2 Code";
      RentalElementsEntries."Source Code" := ElementJournalLine."Source Code";
      IF ElementJournalLine."Entry Type" = ElementJournalLine."Entry Type"::Return THEN
        RentalElementsEntries.Quantity := -ElementJournalLine.Quantity
      ELSE
        RentalElementsEntries.Quantity := ElementJournalLine.Quantity;
      RentalElementsEntries."Journal Batch Name" := ElementJournalLine."Journal Batch Name";
      RentalElementsEntries."Reason Code" := ElementJournalLine."Reason code";
      RentalElementsEntries."Entry No." := NextEntryNo;
      RentalElementsEntries."Transaction No." := NextTransactionNo;
      RentalElementsEntries."Element No." := GLAccNo;
      RentalElementsEntries."Unit Price" := ElementJournalLine."Unit Price";
      RentalElementsEntries."User ID" := USERID;
      RentalElementsEntries."Serie No." := ElementJournalLine."Posting No. Series";
      RentalElementsEntries."Entry Type" := ElementJournalLine."Entry Type";
      RentalElementsEntries."Unit of measure" := ElementJournalLine."Unit of Measure";
      RentalElementsEntries."Location code" := ElementJournalLine."Location Code";
      RentalElementsEntries."Variant Code" := ElementJournalLine."Variante Code";
      RentalElementsEntries."Customer No." := ElementJournalLine."Customer No.";
      RentalElementsEntries."Job No." := ElementJournalLine."Job No.";
      RentalElementsEntries."Contract No." := ElementJournalLine."Contract No.";
      RentalElementsEntries."Rent effective Date" := ElementJournalLine."Rent Effective Date";
      IF RentalElementsEntries."Entry Type" = RentalElementsEntries."Entry Type"::Delivery THEN
        RentalElementsEntries."Applied Last Date" := RentalElementsEntries."Rent effective Date";
      RentalElementsEntries."Applied Entry No." := ElementJournalLine."Applied Entry No.";
      RentalElementsEntries."Piecework Code" := ElementJournalLine."Piecework Code";
      RentalElementsEntries."Job Task No." := ElementJournalLine."Job Task No.";
      IF ElementJournalLine."Entry Type" = ElementJournalLine."Entry Type"::Delivery THEN
        RentalElementsEntries."Applied First Pending Entry" := ElementJournalLine."Entry Pending First Applied";
    END;

    PROCEDURE RunWithoutCheck(VAR ElementJournalLine2 : Record 7207350);
    BEGIN
      ElementJournalLine.COPY(ElementJournalLine2);
      Code(FALSE);
      ElementJournalLine2 := ElementJournalLine;
    END;

    PROCEDURE GetMaestraReg(VAR PElementPostingEntries : Record 7207352);
    BEGIN
      PElementPostingEntries := ElementPostingEntries;
    END;

    /* /*BEGIN
END.*/
}








Codeunit 7207317 "Journal. (Element)-Register Lo"
{
  
  
    TableNo=7207350;
    Permissions=TableData 232=rimd;
    trigger OnRun()
BEGIN
            ElementJournalLine.COPY(Rec);
            Code;
            Rec := ElementJournalLine;
          END;
    VAR
      ElementJournalLine : Record 7207350;
      JournalTemplateElement : Record 7207349;
      ElementJournalSection : Record 7207351;
      Text000 : TextConst ENU='Cannot exceed %1 characters',ESP='No puede superar %1 caracteres';
      Text001 : TextConst ENU='Journal Batch Name    #1##########\\',ESP='Nombre secci�n diario #1##########\\';
      Text002 : TextConst ENU='Checking lines        #2######\',ESP='Comprobando l�neas    #2######\';
      Text003 : TextConst ENU='Checking balance      #3###### @@@@@@@@@@@@@\',ESP='Comprobando saldo     #3###### @@@@@@@@@@@@@\';
      Text004 : TextConst ENU='Posting lines         #5###### @@@@@@@@@@@@@\',ESP='Registrando l�neas    #5###### @@@@@@@@@@@@@\';
      Text005 : TextConst ENU='Posting revers. lines #7###### @@@@@@@@@@@@@\',ESP='Regs. l�ns. reversi�n #7###### @@@@@@@@@@@@@\';
      Text006 : TextConst ENU='Updating lines        #9###### @@@@@@@@@@@@',ESP='Actualizando l�neas   #9###### @@@@@@@@@@@@';
      Text007 : TextConst ENU='Posting lines         #5###### @@@@@@@@@@@@@',ESP='Registrando l�neas    #5###### @@@@@@@@@@@@@';
      GeneralLedgerSetup : Record 98;
      Window : Dialog;
      LineCount : Integer;
      StartLineNo : Integer;
      ElementJournalLine5 : Record 7207350;
      DayElementTestLine : Codeunit 7207315;
      NoOfRecords : Integer;
      LastDate : Date;
      LastDocNo : Code[20];
      CurrentCustomerVendors : Integer;
      VATEntryCreated : Boolean;
      LastTempTransNo : Integer;
      CurrentBalance : Decimal;
      CurrentBalanceReverse : Decimal;
      CurrencyBalance : Decimal;
      NoSeriesManagement : Codeunit 396;
      StartLineNoReverse : Integer;
      RentalElements : Record 7207344;
      ElementPostingEntries : Record 7207352;
      ElementPostingEntriesNo : Integer;
      LastPostedDocNo : Code[20];
      ElementJournalLine4 : Record 7207350;
      NoOfReversingRecords : Integer;
      ElementJournalLine3 : Record 7207350;
      DayElementRegisterLine : Codeunit 7207316;
      TempElementJournalLine4 : Record 7207350;
      ElementJournalLine2 : Record 7207350;
      NoSeries : Record 308;
      NoSeriesManagement2 : ARRAY [10] OF Codeunit 396;
      PostingNoSeriesNo : Integer;
      GLSetupFound : Boolean;
      Text012 : TextConst ENU='"%4 %2 is out of balance by %1. "',ESP='"%4 %2 tiene un descuadre de %1. "';
      Text013 : TextConst ENU='Please check that %3, %4 and %5 are correct for each line.',ESP='Compruebe que son correctos para cada l�nea %3, %4 y %5.';
      Text014 : TextConst ENU='"The lines in %1 are out of balance by %2. "',ESP='"Hay un descuadre de %2 en las l�neas de %1. "';
      Text015 : TextConst ENU='Check that %3 and %4 are correct for each line.',ESP='Compruebe que %3 y/e %4 son correctos para cada l�nea.';
      Text016 : TextConst ENU='"Your reversing entries in %4 %2 are out of balance by %1. "',ESP='"Hay un descuadre de %1 en los movs. del contraasiento de %4 %2. "';
      Text017 : TextConst ENU='Please check whether %3 is correct for each line for this %4.',ESP='Compruebe que la %3 es correcta para este/a %4.';
      Text018 : TextConst ENU='"Your reversing entries for %1 are out of balance by %2. "',ESP='"Hay un descuadre de %2 en los movs. de contraasiento del %1. "';
      LastCurrencyCode : Code[10];
      Text026 : TextConst ENU='"%4 %2 is out of balance by %1 %6. "',ESP='"%4 %2 descuadra por %1 %6 "';
      Text027 : TextConst ENU='"The lines in %1 are out of balance by %2 %5. "',ESP='"Las l�neas en %1 descuadran por %2 %5. "';
      "0DF" : DateFormula;
      Day : Integer;
      Week : Integer;
      Month : Integer;
      MonthText : Text[30];
      Text024 : TextConst ENU='<Month Text>',ESP='Texto Mes';
      AccountingPeriod : Record 50;
      NoOfPostingNoSeries : Integer;
      Text025 : TextConst ENU='A maximum of %1 posting number series can be used in each journal.',ESP='Se puede utilizar un m�ximo de %1 n�meros de serie de registro en cada diario.';

    LOCAL PROCEDURE Code();
    VAR
      ElementJournalSection2 : Record 7207351;
      TempElementJournalLine : Record 7207350 TEMPORARY;
      ICOutboxTransaction : Record 414;
      ICHandledInboxTransaction : Record 420;
      ICOutboxJnlLine : Record 415;
      UpdateAnalysisView : Codeunit 410;
      i : Integer;
    BEGIN
      WITH ElementJournalLine DO BEGIN
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        IF RECORDLEVELLOCKING THEN
          LOCKTABLE;

        JournalTemplateElement.GET("Journal Template Name");
        ElementJournalSection.GET("Journal Template Name","Journal Batch Name");
        IF STRLEN(INCSTR(ElementJournalSection.Name)) > MAXSTRLEN(ElementJournalSection.Name) THEN
          ElementJournalSection.FIELDERROR(
            Name,
            STRSUBSTNO(
              Text000,
              MAXSTRLEN(ElementJournalSection.Name)));

        IF JournalTemplateElement.Recurring THEN BEGIN
          SETRANGE("Posting Date",0D,WORKDATE);
          GeneralLedgerSetup.GET;
        END;

        IF NOT FIND('=><') THEN BEGIN
          "Line No." := 0;
          COMMIT;
          EXIT;
        END;

        IF JournalTemplateElement.Recurring THEN
          Window.OPEN(
            Text001 +
            Text002 +
            Text003 +
            Text004 +
            Text005 +
            Text006)
        ELSE
          Window.OPEN(
            Text001 +
            Text002 +
            Text003 +
            Text007);
        Window.UPDATE(1,"Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := "Line No.";
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(2,LineCount);
          CheckRecurringLine(ElementJournalLine);
          UpdateRecurringAmt(ElementJournalLine);
          ElementJournalLine5.COPY(ElementJournalLine);
          DayElementTestLine.RunCheck(ElementJournalLine5);
          TempElementJournalLine := ElementJournalLine5;
          TempElementJournalLine.INSERT;
          IF NEXT = 0 THEN
            FIND('-');
        UNTIL "Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Check balance
        LineCount := 0;
        LastDate := 0D;
        LastDocNo := '';
        CurrentCustomerVendors := 0;
        VATEntryCreated := FALSE;
        LastTempTransNo := 0;
        CurrentBalance := 0;
        CurrentBalanceReverse := 0;
        CurrencyBalance := 0;
        IF JournalTemplateElement."Force Doc. Balance" THEN
          ElementJournalLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.")
        ELSE
          ElementJournalLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Transaction No.");

        FINDSET(TRUE);
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(3,LineCount);
          Window.UPDATE(4,ROUND(LineCount / NoOfRecords * 10000,1));

          IF NOT EmptyLine THEN BEGIN
            IF (ElementJournalSection."Series No." <> '') AND
               ("Document No." <> LastDocNo)
            THEN
              TESTFIELD("Document No.",NoSeriesManagement.GetNextNo(ElementJournalSection."Series No.","Posting Date",FALSE));
            IF ("Posting Date" <> LastDate) OR
               ("Document No." <> LastDocNo) OR
               ("Transaction No." <> LastTempTransNo)
            THEN BEGIN
              TempElementJournalLine.RESET;
              TempElementJournalLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
              TempElementJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
              TempElementJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
              TempElementJournalLine.SETRANGE("Posting Date","Posting Date");
              TempElementJournalLine.SETRANGE("Document No.","Document No.");
              IF TempElementJournalLine.FINDFIRST THEN;

            END;
          END;
          IF ("Posting Date" <> LastDate) OR
             (JournalTemplateElement."Force Doc. Balance" AND
             (("Document No." <> LastDocNo))) OR
             (NOT JournalTemplateElement."Force Doc. Balance" AND
             ("Transaction No." <> LastTempTransNo))
          THEN BEGIN
            CheckBalance;
            IF ("Posting Date" <> LastDate) OR
               ("Document No." <> LastDocNo)
            THEN BEGIN
              CurrentCustomerVendors := 0;
              VATEntryCreated := FALSE;
              CurrencyBalance := 0;
            END;
          END;

          IF "Unit Price" <> 0 THEN BEGIN
            IF (CurrentBalance = 0) THEN BEGIN
              StartLineNo := "Line No.";
              CurrentCustomerVendors := 0;
              VATEntryCreated := FALSE;
            END;
            IF CurrentBalanceReverse = 0 THEN
              StartLineNoReverse := "Line No.";
            CurrentBalance := CurrentBalance + Quantity;
            IF "Recurring Method" >= "Recurring Method"::"RF Reversing Fixed" THEN
              CurrentBalanceReverse := CurrentBalanceReverse + Quantity;
          END;

          LastDate := "Posting Date";
          IF NOT EmptyLine THEN
            LastDocNo := "Document No.";
          LastTempTransNo := ElementJournalLine."Transaction No.";
        UNTIL NEXT = 0;
        CheckBalance;
        CopyFields;
        IF NOT RECORDLEVELLOCKING THEN
          COMMIT;

        // Find next register no.
        RentalElements.LOCKTABLE;

        IF RECORDLEVELLOCKING THEN
          IF RentalElements.FINDLAST THEN;
        ElementPostingEntries.LOCKTABLE;
        IF ElementPostingEntries.FINDLAST THEN
          ElementPostingEntriesNo := ElementPostingEntries."Transaction No." + 1
        ELSE
          ElementPostingEntriesNo := 1;
        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastPostedDocNo := '';
        ElementJournalLine4.DELETEALL;
        NoOfReversingRecords := 0;
        IF JournalTemplateElement."Force Doc. Balance" THEN
          ElementJournalLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.")
        ELSE
          ElementJournalLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Transaction No.");

        FINDFIRST;
        REPEAT
          ElementJournalLine3 := ElementJournalLine;
          WITH ElementJournalLine3 DO BEGIN
            LineCount := LineCount + 1;
            Window.UPDATE(5,LineCount);
            Window.UPDATE(6,ROUND(LineCount / NoOfRecords * 10000,1));
            MakeRecurringTexts(ElementJournalLine3);
            CheckDocumentNo(ElementJournalLine3);
            ElementJournalLine5.COPY(ElementJournalLine3);
            DayElementRegisterLine.RunWithoutCheck(ElementJournalLine5);
            IF ("Recurring Method" >= "Recurring Method"::"RF Reversing Fixed") AND ("Posting Date" <> 0D) THEN BEGIN
              "Posting Date" := "Posting Date" + 1;
              MultiplyAmounts(ElementJournalLine3,-1);
              TempElementJournalLine4 := ElementJournalLine3;
              TempElementJournalLine4.INSERT;
              NoOfReversingRecords := NoOfReversingRecords + 1;
              "Posting Date" := "Posting Date" - 1;
            END;
          END;
        UNTIL NEXT = 0;

        // Post reversing lines
        LineCount := 0;
        LastDocNo := '';
        LastPostedDocNo := '';
        IF TempElementJournalLine4.FINDSET(FALSE) THEN
          REPEAT
            ElementJournalLine3 := TempElementJournalLine4;
            WITH ElementJournalLine3 DO BEGIN
              LineCount := LineCount + 1;
              Window.UPDATE(7,LineCount);
              Window.UPDATE(8,ROUND(LineCount / NoOfReversingRecords * 10000,1));
              CheckDocumentNo(ElementJournalLine3);
              ElementJournalLine5.COPY(ElementJournalLine3);
              DayElementRegisterLine.RunWithoutCheck(ElementJournalLine5);
            END;
          UNTIL TempElementJournalLine4.NEXT = 0;

        // Copy register no. and current journal batch name to general journal
        IF ElementPostingEntries.FINDLAST THEN
          ElementPostingEntriesNo := ElementPostingEntries."Transaction No."
        ELSE
          ElementPostingEntriesNo := 0;

        INIT;
        "Line No." := ElementPostingEntriesNo;

        // Update/delete lines
        IF ElementPostingEntriesNo <> 0 THEN BEGIN
          IF NOT RECORDLEVELLOCKING THEN BEGIN
            LOCKTABLE(TRUE,TRUE);
          END;
          IF JournalTemplateElement.Recurring THEN BEGIN
            // Recurring journal
            LineCount := 0;
            ElementJournalLine2.COPYFILTERS(ElementJournalLine);
            ElementJournalLine2.FINDSET(FALSE);
            REPEAT
              LineCount := LineCount + 1;
              Window.UPDATE(9,LineCount);
              Window.UPDATE(10,ROUND(LineCount / NoOfRecords * 10000,1));
              IF ElementJournalLine2."Posting Date" <> 0D THEN
                ElementJournalLine2.VALIDATE(
                  "Posting Date",CALCDATE(ElementJournalLine2."Recurring Frequency",ElementJournalLine2."Posting Date"));
              IF NOT
                 (ElementJournalLine2."Recurring Method" IN
                  [ElementJournalLine2."Recurring Method"::"F  Fixed",
                   ElementJournalLine2."Recurring Method"::"RF Reversing Fixed"])
              THEN
                MultiplyAmounts(ElementJournalLine2,0);
              ElementJournalLine2.MODIFY;
            UNTIL ElementJournalLine2.NEXT = 0;
          END ELSE BEGIN
            // Not a recurring journal
            ElementJournalLine2.COPYFILTERS(ElementJournalLine);
            ElementJournalLine2.SETFILTER("Element No.",'<>%1','');
            IF ElementJournalLine2.FINDLAST THEN; // Remember the last line
            ElementJournalLine3.COPY(ElementJournalLine);
            IF ElementJournalLine3.FINDSET(TRUE) THEN
              REPEAT
                ElementJournalLine3.DELETE;
              UNTIL ElementJournalLine3.NEXT = 0;
            ElementJournalLine3.RESET;
            ElementJournalLine3.SETRANGE("Journal Template Name","Journal Template Name");
            ElementJournalLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
            IF NOT ElementJournalLine3.FINDLAST THEN
              IF INCSTR("Journal Batch Name") <> '' THEN BEGIN
                ElementJournalSection.DELETE;
                ElementJournalSection.Name := INCSTR("Journal Batch Name");
                IF ElementJournalSection.INSERT THEN;
                "Journal Batch Name" := ElementJournalSection.Name;
              END;

            ElementJournalLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
            IF (ElementJournalSection."Series No." = '') AND NOT ElementJournalLine3.FINDLAST THEN BEGIN
              ElementJournalLine3.INIT;
              ElementJournalLine3."Journal Template Name" := "Journal Template Name";
              ElementJournalLine3."Journal Batch Name" := "Journal Batch Name";
              ElementJournalLine3."Line No." := 10000;
              ElementJournalLine3.INSERT;
              ElementJournalLine3.SetUpNewLine(ElementJournalLine2,0,TRUE);
              ElementJournalLine3.MODIFY;
            END;
          END;
        END;
        IF ElementJournalSection."Series No." <> '' THEN
          NoSeriesManagement.SaveNoSeries;
        IF NoSeries.FINDSET(TRUE) THEN
          REPEAT
            EVALUATE(PostingNoSeriesNo,NoSeries.Description);
            NoSeriesManagement2[PostingNoSeriesNo].SaveNoSeries;
          UNTIL NoSeries.NEXT = 0;
        IF GLSetupFound THEN
          GeneralLedgerSetup.MODIFY;
        COMMIT;
        CLEAR(DayElementTestLine);
        CLEAR(DayElementRegisterLine);
      END;
      UpdateAnalysisView.UpdateAll(0,TRUE);
    END;

    LOCAL PROCEDURE CheckBalance();
    BEGIN
      WITH ElementJournalLine DO BEGIN
        IF CurrentBalance <> 0 THEN BEGIN
          GET("Journal Template Name","Journal Batch Name",StartLineNo);
          IF JournalTemplateElement."Force Doc. Balance" THEN
            ERROR(
              Text012 +
              Text013,
               CurrentBalance,LastDocNo,FIELDCAPTION("Posting Date"),FIELDCAPTION("Document No."),FIELDCAPTION("Unit Price"));
          ERROR(
            Text014 +
            Text015,
            LastDate,CurrentBalance,FIELDCAPTION("Posting Date"),FIELDCAPTION("Unit Price"));
        END;
        IF CurrentBalanceReverse <> 0 THEN BEGIN
          GET("Journal Template Name","Journal Batch Name",StartLineNoReverse);
          IF JournalTemplateElement."Force Doc. Balance" THEN
            ERROR(
              Text016 +
              Text017,
              CurrentBalanceReverse,LastDocNo,FIELDCAPTION("Recurring Method"),FIELDCAPTION("Document No."));
          ERROR(
            Text018 +
            Text017,
            LastDate,CurrentBalanceReverse,FIELDCAPTION("Recurring Method"),FIELDCAPTION("Posting Date"));
        END;
        IF (LastCurrencyCode <> '') AND (CurrencyBalance <> 0) THEN BEGIN
          GET("Journal Template Name","Journal Batch Name",StartLineNo);
          IF JournalTemplateElement."Force Doc. Balance" THEN
            ERROR(
              Text026 +
              Text013,
               CurrencyBalance,LastDocNo,FIELDCAPTION("Posting Date"),FIELDCAPTION("Document No."),FIELDCAPTION("Unit Price"),
               LastCurrencyCode);
          ERROR(
            Text027 +
            Text015,
            LastDate,CurrencyBalance,FIELDCAPTION("Posting Date"),FIELDCAPTION("Unit Price"),LastCurrencyCode);
        END;
      END;
    END;

    LOCAL PROCEDURE CheckRecurringLine(VAR ElementJournalLine : Record 7207350);
    BEGIN
      WITH ElementJournalLine2 DO BEGIN
        IF "Element No." <> '' THEN
          IF JournalTemplateElement.Recurring THEN BEGIN
            TESTFIELD("Recurring Method");
            TESTFIELD("Recurring Frequency");
            CASE "Recurring Method" OF
              "Recurring Method"::"V  Variable","Recurring Method"::"RV Reversing Variable",
              "Recurring Method"::"F  Fixed","Recurring Method"::"RF Reversing Fixed":
                TESTFIELD("Unit Price");
              "Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance":
                TESTFIELD("Unit Price",0);
            END;
          END ELSE BEGIN
            TESTFIELD("Recurring Method",0);
            TESTFIELD("Recurring Frequency","0DF");
          END;
      END;
    END;

    LOCAL PROCEDURE UpdateRecurringAmt(VAR ElementJournalLine : Record 7207350);
    BEGIN
    END;

    LOCAL PROCEDURE CheckAllocations(VAR ElementJournalLine : Record 7207350);
    BEGIN
    END;

    LOCAL PROCEDURE MakeRecurringTexts(VAR ElementJournalLine : Record 7207350);
    BEGIN
      WITH ElementJournalLine2 DO BEGIN
        IF ("Element No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,Text024);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Posting Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          "Document No." :=
            DELCHR(
              PADSTR(
                STRSUBSTNO("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN("Document No.")),
              '>');
          Description :=
            DELCHR(
              PADSTR(
                STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),
              '>');
        END;
      END;
    END;

    LOCAL PROCEDURE MultiplyAmounts(VAR ElementJournalLine : Record 7207350;Factor : Decimal);
    BEGIN
      WITH ElementJournalLine2 DO BEGIN
        IF "Element No." <> '' THEN BEGIN
          "Unit Price" := "Unit Price" * Factor;
          Quantity := Quantity * Factor;
        END;
      END;
    END;

    PROCEDURE CheckDocumentNo(VAR ElementJournalLine2 : Record 7207350);
    BEGIN
      WITH ElementJournalLine2 DO BEGIN
        IF "Posting No. Series" = '' THEN
          "Posting No. Series" := ElementJournalSection."Series No."
        ELSE
          IF NOT EmptyLine THEN
            IF "Document No." = LastDocNo THEN
              "Document No." := LastPostedDocNo
            ELSE BEGIN
              IF NOT NoSeries.GET("Posting No. Series") THEN BEGIN
                NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesManagement2) THEN
                  ERROR(
                    Text025,
                    ARRAYLEN(NoSeriesManagement2));
                NoSeries.Code := "Posting No. Series";
                NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                NoSeries.INSERT;
              END;
              LastDocNo := "Document No.";
              EVALUATE(PostingNoSeriesNo,NoSeries.Description);
              "Document No." :=
                NoSeriesManagement2[PostingNoSeriesNo].GetNextNo("Posting No. Series","Posting Date",TRUE);
              LastPostedDocNo := "Document No.";
            END;
      END;
    END;

    PROCEDURE CopyFields();
    VAR
      ElementJournalLine4 : Record 7207350;
      ElementJournalLine6 : Record 7207350;
      CheckAmount : Decimal;
    BEGIN
      ElementJournalLine6.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
      ElementJournalLine4.FILTERGROUP(2);
      ElementJournalLine4.COPYFILTERS(ElementJournalLine);
      ElementJournalLine4.FILTERGROUP(0);
      ElementJournalLine6.FILTERGROUP(2);
      ElementJournalLine6.COPYFILTERS(ElementJournalLine);
      ElementJournalLine6.FILTERGROUP(0);
      IF ElementJournalLine4.FINDSET(FALSE) THEN
        REPEAT
          ElementJournalLine6.SETRANGE("Posting Date",ElementJournalLine4."Posting Date");
          ElementJournalLine6.SETRANGE("Document No.",ElementJournalLine4."Document No.");
          CheckAmount := 0;
          IF ElementJournalLine6.FINDSET(FALSE) THEN
            REPEAT
              CheckAmount := CheckAmount + ElementJournalLine6."Unit Price";
            UNTIL (ElementJournalLine6.NEXT = 0) OR (-ElementJournalLine4."Unit Price" = CheckAmount);
        UNTIL ElementJournalLine4.NEXT = 0;

      ElementJournalLine4.SETRANGE("Element No.",'');
      IF ElementJournalLine4.FINDSET(FALSE) THEN
        REPEAT
          ElementJournalLine6.SETRANGE("Posting Date",ElementJournalLine4."Posting Date");
          ElementJournalLine6.SETRANGE("Document No.",ElementJournalLine4."Document No.");
          CheckAmount := 0;
          IF ElementJournalLine6.FINDSET(FALSE) THEN
            REPEAT
              CheckAmount := CheckAmount + ElementJournalLine6."Unit Price";
            UNTIL (ElementJournalLine6.NEXT = 0) OR (-ElementJournalLine4."Unit Price" = CheckAmount);
        UNTIL ElementJournalLine4.NEXT = 0;
    END;

    PROCEDURE CheckICDocument(VAR TempElementJournalLine1 : Record 7207350 TEMPORARY);
    VAR
      CurrentICPartner : Code[20];
      TempGenJnlLine2 : Record 81 TEMPORARY;
    BEGIN
    END;

    /* /*BEGIN
END.*/
}








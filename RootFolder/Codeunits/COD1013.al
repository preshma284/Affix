Codeunit 50013 "Job Jnl.-Post Batch 1"
{
  
  
    TableNo=210;
    Permissions=TableData 237=imd;
    trigger OnRun()
BEGIN
            JobJnlLine.COPY(Rec);
            Code;
            Rec := JobJnlLine;
          END;
    VAR
      Text000 : TextConst ENU='cannot exceed %1 characters.',ESP='no puede superar %1 caracteres.';
      Text001 : TextConst ENU='Journal Batch Name    #1##########\\',ESP='Nombre secci¢n diario #1##########\\';
      Text002 : TextConst ENU='Checking lines        #2######\',ESP='Comprobando l¡neas    #2######\';
      Text003 : TextConst ENU='Posting lines         #3###### @@@@@@@@@@@@@\',ESP='Registrando l¡neas    #3###### @@@@@@@@@@@@@\';
      Text004 : TextConst ENU='Updating lines        #5###### @@@@@@@@@@@@@',ESP='Actualizando l¡ns.    #5###### @@@@@@@@@@@@@';
      Text005 : TextConst ENU='Posting lines         #3###### @@@@@@@@@@@@@',ESP='Registrando l¡neas    #3###### @@@@@@@@@@@@@';
      Text006 : TextConst ENU='A maximum of %1 posting number series can be used in each journal.',ESP='Se puede utilizar un m ximo de %1 n£meros de serie de registro en cada diario.';
      Text007 : TextConst ENU='<Month Text>',ESP='<Month Text>';
      AccountingPeriod : Record 50;
      JobJnlTemplate : Record 209;
      JobJnlBatch : Record 237;
      JobJnlLine : Record 210;
      JobJnlLine2 : Record 210;
      JobJnlLine3 : Record 210;
      JobLedgEntry : Record 169;
      JobReg : Record 241;
      NoSeries : Record 308 TEMPORARY;
      JobJnlCheckLine : Codeunit 1011;
      JobJnlPostLine : Codeunit 1012;
      NoSeriesMgt : Codeunit 396;
      NoSeriesMgt2 : ARRAY [10] OF Codeunit 396;
      Window : Dialog;
      JobRegNo : Integer;
      StartLineNo : Integer;
      Day : Integer;
      Week : Integer;
      Month : Integer;
      MonthText : Text[30];
      LineCount : Integer;
      NoOfRecords : Integer;
      LastDocNo : Code[20];
      LastDocNo2 : Code[20];
      LastPostedDocNo : Code[20];
      NoOfPostingNoSeries : Integer;
      PostingNoSeriesNo : Integer;
      "---------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;

    LOCAL PROCEDURE Code();
    VAR
      InvtSetup : Record 313;
      InvtAdjmt : Codeunit 5895;
      UpdateAnalysisView : Codeunit 410;
      UpdateItemAnalysisView : Codeunit 7150;
    BEGIN
      WITH JobJnlLine DO BEGIN
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        LOCKTABLE;

        JobJnlTemplate.GET("Journal Template Name");
        JobJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF STRLEN(INCSTR(JobJnlBatch.Name)) > MAXSTRLEN(JobJnlBatch.Name) THEN
          JobJnlBatch.FIELDERROR(
            Name,
            STRSUBSTNO(
              Text000,
              MAXSTRLEN(JobJnlBatch.Name)));

        IF JobJnlTemplate.Recurring THEN BEGIN
          SETRANGE("Posting Date",0D,WORKDATE);
          SETFILTER("Expiration Date",'%1 | %2..',0D,WORKDATE);
        END;

        IF NOT FIND('=><') THEN BEGIN
          "Line No." := 0;
          COMMIT;
          EXIT;
        END;

        IF JobJnlTemplate.Recurring THEN
          Window.OPEN(
            Text001 +
            Text002 +
            Text003 +
            Text004)
        ELSE
          Window.OPEN(
            Text001 +
            Text002 +
            Text005);
        Window.UPDATE(1,"Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := "Line No.";
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(2,LineCount);
          CheckRecurringLine(JobJnlLine);
          JobJnlCheckLine.RunCheck(JobJnlLine);
          OnAfterCheckJnlLine(JobJnlLine);
          IF NEXT = 0 THEN
            FIND('-');
        UNTIL "Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        JobLedgEntry.LOCKTABLE;
        IF JobLedgEntry.FINDLAST THEN;
        JobReg.LOCKTABLE;
        IF JobReg.FINDLAST AND (JobReg."To Entry No." = 0) THEN
          JobRegNo := JobReg."No."
        ELSE
          JobRegNo := JobReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        FIND('-');
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(3,LineCount);
          Window.UPDATE(4,ROUND(LineCount / NoOfRecords * 10000,1));
          IF NOT EmptyLine AND
             (JobJnlBatch."No. Series" <> '') AND
             ("Document No." <> LastDocNo2)
          THEN
            TESTFIELD("Document No.",NoSeriesMgt.GetNextNo(JobJnlBatch."No. Series","Posting Date",FALSE));
          IF NOT EmptyLine THEN
            LastDocNo2 := "Document No.";
          MakeRecurringTexts(JobJnlLine);
          IF "Posting No. Series" = '' THEN BEGIN
            "Posting No. Series" := JobJnlBatch."No. Series";
            TESTFIELD("Document No.");
          END ELSE
            IF NOT EmptyLine THEN
              IF ("Document No." = LastDocNo) AND ("Document No." <> '') THEN
                "Document No." := LastPostedDocNo
              ELSE BEGIN
                IF NOT NoSeries.GET("Posting No. Series") THEN BEGIN
                  NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                  IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                    ERROR(
                      Text006,
                      ARRAYLEN(NoSeriesMgt2));
                  NoSeries.Code := "Posting No. Series";
                  NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                  NoSeries.INSERT;
                END;
                LastDocNo := "Document No.";
                EVALUATE(PostingNoSeriesNo,NoSeries.Description);
                "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series","Posting Date",FALSE);
                LastPostedDocNo := "Document No.";
              END;
          OnBeforeJobJnlPostLine(JobJnlLine);
          JobJnlPostLine.RunWithCheck(JobJnlLine);
          OnAfterJobJnlPostLine(JobJnlLine);
        UNTIL NEXT = 0;

        InvtSetup.GET;
        IF InvtSetup."Automatic Cost Adjustment" <>
           InvtSetup."Automatic Cost Adjustment"::Never
        THEN BEGIN
          InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
          InvtAdjmt.MakeMultiLevelAdjmt;
        END;

        // Copy register no. and current journal batch name to the job journal
        IF NOT JobReg.FINDLAST OR (JobReg."No." <> JobRegNo) THEN
          JobRegNo := 0;

        INIT;
        "Line No." := JobRegNo;

        UpdateAndDeleteLines;
        OnAfterPostJnlLines(JobJnlBatch,JobJnlLine,JobRegNo);

        COMMIT;
      END;
      UpdateAnalysisView.UpdateAll(0,TRUE);
      UpdateItemAnalysisView.UpdateAll(0,TRUE);
      COMMIT;
    END;

    LOCAL PROCEDURE CheckRecurringLine(VAR JobJnlLine2 : Record 210);
    VAR
      TempDateFormula : DateFormula;
    BEGIN
      WITH JobJnlLine2 DO BEGIN
        IF "No." <> '' THEN
          IF JobJnlTemplate.Recurring THEN BEGIN
            TESTFIELD("Recurring Method");
            TESTFIELD("Recurring Frequency");
            IF "Recurring Method" = "Recurring Method"::Variable THEN
              IF NOT FunctionQB.AccessToQuobuilding THEN //RE001
                TESTFIELD(Quantity);
          END ELSE BEGIN
            TESTFIELD("Recurring Method",0);
            TESTFIELD("Recurring Frequency",TempDateFormula);
          END;
      END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts(VAR JobJnlLine2 : Record 210);
    BEGIN
      WITH JobJnlLine2 DO BEGIN
        IF ("No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN // Not recurring
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,Text007);
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

    LOCAL PROCEDURE UpdateAndDeleteLines();
    BEGIN
      OnBeforeUpdateAndDeleteLines(JobJnlLine);

      WITH JobJnlLine DO BEGIN
        IF JobRegNo <> 0 THEN
          IF JobJnlTemplate.Recurring THEN BEGIN
            // Recurring journal
            LineCount := 0;
            JobJnlLine2.COPYFILTERS(JobJnlLine);
            JobJnlLine2.FIND('-');
            REPEAT
              LineCount := LineCount + 1;
              Window.UPDATE(5,LineCount);
              Window.UPDATE(6,ROUND(LineCount / NoOfRecords * 10000,1));
              IF JobJnlLine2."Posting Date" <> 0D THEN
                JobJnlLine2.VALIDATE("Posting Date",CALCDATE(JobJnlLine2."Recurring Frequency",JobJnlLine2."Posting Date"));
              IF (JobJnlLine2."Recurring Method" = JobJnlLine2."Recurring Method"::Variable) AND
                 (JobJnlLine2."No." <> '')
              THEN
                JobJnlLine2.DeleteAmounts;
              JobJnlLine2.MODIFY;
            UNTIL JobJnlLine2.NEXT = 0;
          END ELSE BEGIN
            // Not a recurring journal
            JobJnlLine2.COPYFILTERS(JobJnlLine);
            JobJnlLine2.SETFILTER("No.",'<>%1','');
            IF JobJnlLine2.FIND THEN; // Remember the last line
            JobJnlLine3.COPY(JobJnlLine);
            IF JobJnlLine3.FIND('-') THEN
              REPEAT
                JobJnlLine3.DELETE;
              UNTIL JobJnlLine3.NEXT = 0;
            JobJnlLine3.RESET;
            JobJnlLine3.SETRANGE("Journal Template Name","Journal Template Name");
            JobJnlLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
            IF NOT JobJnlLine3.FIND('+') THEN
              IF INCSTR("Journal Batch Name") <> '' THEN BEGIN
                JobJnlBatch.DELETE;
                JobJnlBatch.Name := INCSTR("Journal Batch Name");
                IF JobJnlBatch.INSERT THEN;
                "Journal Batch Name" := JobJnlBatch.Name;
              END;
            JobJnlLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
            IF (JobJnlBatch."No. Series" = '') AND NOT JobJnlLine3.FIND('+') THEN BEGIN
              JobJnlLine3.INIT;
              JobJnlLine3."Journal Template Name" := "Journal Template Name";
              JobJnlLine3."Journal Batch Name" := "Journal Batch Name";
              JobJnlLine3."Line No." := 10000;
              JobJnlLine3.INSERT;
              JobJnlLine3.SetUpNewLine(JobJnlLine2);
              JobJnlLine3.MODIFY;
            END;
          END;

        IF JobJnlBatch."No. Series" <> '' THEN
          NoSeriesMgt.SaveNoSeries;
        IF NoSeries.FIND('-') THEN
          REPEAT
            EVALUATE(PostingNoSeriesNo,NoSeries.Description);
            NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
          UNTIL NoSeries.NEXT = 0;
      END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckJnlLine(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterJobJnlPostLine(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostJnlLines(VAR JobJournalBatch : Record 237;VAR JobJournalLine : Record 210;JobRegNo : Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeJobJnlPostLine(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeUpdateAndDeleteLines(VAR JobJournalLine : Record 210);
    BEGIN
    END;

    /*BEGIN
/*{
      RE001  NZG  24/01/18 : A¤adida condici¢n en la funcion CheckRecurringLine
    }
END.*/
}










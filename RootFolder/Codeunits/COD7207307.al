Codeunit 7207307 "Record Activation"
{
  
  
    TableNo=7207367;
    trigger OnRun()
VAR
            ItemChargeAssgntPurch : Record 5805;
            UpdateAnalysisView : Codeunit 410;
            CostBaseAmount : Decimal;
            DiscountVATAmount : Decimal;
          BEGIN
            IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
              rec.VALIDATE(rec."Posting Date",PostingDate);
            CLEARALL;
            ActivationHeader.COPY(Rec);
            WITH ActivationHeader DO BEGIN
              TESTFIELD("Element Code");
              TESTFIELD("Posting Date");
            END;

            RentalElements.GET(rec."Element Code");
            RentalElements.TESTFIELD(Blocked,FALSE);

            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text007 +
              Text7000000);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GetGLSetup;
            GetCurrency;

            rec.TESTFIELD(rec."Posting Serial No.");

            IF rec.RECORDLEVELLOCKING THEN BEGIN
              ActivationLine.LOCKTABLE;
              GLEntry.LOCKTABLE;
              IF GLEntry.FINDLAST THEN;
            END;

            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup."Elements Activation";

            ActivationHeaderHist.INIT;
            ActivationHeaderHist.TRANSFERFIELDS(ActivationHeader);
            ActivationHeaderHist."Pre-Assigned Serial No." := rec."Serial No.";
            ActivationHeaderHist."No." := NoSeriesManagement.GetNextNo(rec."Posting Serial No.",rec."Posting Date",TRUE);

            Window.UPDATE(1,STRSUBSTNO(Text010,rec."No.",ActivationHeaderHist."No."));

            ActivationHeaderHist."Source Code" := SrcCode;
            ActivationHeaderHist."User ID" := USERID;
            ActivationHeaderHist."Dimension Set ID" := ActivationHeader."Dimension Set ID";
            ActivationHeaderHist.INSERT;

            CopyCommentLines(rec."No.",ActivationHeaderHist."No.");

            ActivationLine.RESET;
            ActivationLine.SETRANGE("Document No.",rec."No.");
            LineCount := 0;
            IF ActivationLine.FINDSET(FALSE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);

                Exit_(ActivationLine);
                Entry_(ActivationLine);

                ActivationLineHist.INIT;
                ActivationLineHist.TRANSFERFIELDS(ActivationLine);
                ActivationLineHist."Document No." :=  ActivationHeaderHist."No.";
                ActivationLineHist."Dimension Set ID" := ActivationLine."Dimension Set ID";
                ActivationLineHist.INSERT;
              UNTIL ActivationLine.NEXT = 0;
            END;

            rec.DELETE;
            ActivationLine.DELETEALL;

            ActivationCommentsLine.SETRANGE("No.",rec."No.");
            ActivationCommentsLine.DELETEALL;

            COMMIT;
            Window.CLOSE;

            UpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := ActivationHeader;
          END;
    VAR
      GeneralLedgerSetup : Record 98;
      GLEntry : Record 17;
      ActivationHeader : Record 7207367;
      ActivationLine : Record 7207368;
      ActivationHeaderHist : Record 7207370;
      ActivationLineHist : Record 7207371;
      SourceCodeSetup : Record 242;
      ActivationCommentsLine : Record 7207369;
      ActivationCommentsLine2 : Record 7207369;
      Currency : Record 4;
      RentalElements : Record 7207344;
      ItemJnlPostLine : Codeunit 22;
      DimensionManagement : Codeunit 408;
      Window : Dialog;
      PostingDate : Date;
      GenJnlLineDocNo : Code[20];
      SrcCode : Code[10];
      LineCount : Integer;
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      ReplaceDocumentDate : Boolean;
      GLSetupRead : Boolean;
      NoSeriesManagement : Codeunit 396;
      ItemJournalLine : Record 83;
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas         #2######\';
      Text007 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando Maestro      #4######\';
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos         #6######';

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE GetCurrency();
    BEGIN
      WITH ActivationHeader DO
        IF "Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      ActivationCommentsLine.SETRANGE("No.",FromNumber);
      IF ActivationCommentsLine.FINDSET(FALSE) THEN
        REPEAT
         ActivationCommentsLine2 := ActivationCommentsLine;
         ActivationCommentsLine2."No." := ToNumber;
         ActivationCommentsLine2.INSERT;
       UNTIL ActivationCommentsLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
      IF NOT GLSetupRead THEN
        GeneralLedgerSetup.GET;
      GLSetupRead := TRUE;
    END;

    PROCEDURE Exit_(ActivationLine2 : Record 7207368);
    VAR
      ItemJnlLine : Record 83;
    BEGIN
      WITH ActivationLine2  DO BEGIN
        ActivationLine2.CALCFIELDS("Item No.");
        ItemJnlLine.INIT;
        ItemJnlLine."Posting Date" := ActivationHeader."Posting Date";
        ItemJnlLine."Document Date" := ActivationHeader."Posting Date";
        ItemJnlLine."Document No." := ActivationHeaderHist."No.";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
        ItemJnlLine.VALIDATE("Item No.","Item No.");
        ItemJnlLine.VALIDATE("Variant Code","Variant Code");
        ItemJnlLine.VALIDATE(ItemJnlLine."Location Code","Location Code");
        ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code","Unit of Measure Code");
        ItemJnlLine."Unit Cost" := 0;
        ItemJnlLine.VALIDATE(ItemJnlLine.Quantity,Quantity);
        ItemJnlLine.VALIDATE(ItemJnlLine."Applies-to Entry",ActivationLine."Applies-to Entry");
        ItemJnlLine."External Document No." := '';
        ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJnlLine."Source Code" := SourceCodeSetup."Elements Activation";
        ItemJnlLine."Dimension Set ID" := "Dimension Set ID";
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
      END;
    END;

    PROCEDURE Entry_(ActivationLine3 : Record 7207368);
    VAR
      ItemJnlLine : Record 83;
    BEGIN
      WITH ActivationLine3 DO BEGIN
        ActivationLine3.CALCFIELDS("Item No.");
        ItemJnlLine.INIT;
        ItemJnlLine."Posting Date" := ActivationHeader."Posting Date";
        ItemJnlLine."Document Date" := ActivationHeader."Posting Date";
        ItemJnlLine."Document No." := ActivationHeaderHist."No.";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
        ItemJnlLine.VALIDATE("Item No.","Item No.");
        ItemJnlLine.VALIDATE("Variant Code","New Variant Code");
        ItemJnlLine.VALIDATE(ItemJnlLine."Location Code","New Location Code");
        ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code","Unit of Measure Code");
        ItemJnlLine."Unit Cost" := 0;
        ItemJnlLine.VALIDATE(ItemJnlLine.Quantity,Quantity);
        ItemJnlLine."External Document No." := '';
        ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJnlLine."Source Code" := SourceCodeSetup."Elements Activation";
        ItemJnlLine."Dimension Set ID" := "Dimension Set ID";
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
      END;
    END;

    /* /*BEGIN
END.*/
}








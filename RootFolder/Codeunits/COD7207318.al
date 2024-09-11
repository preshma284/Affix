Codeunit 7207318 "(Element) JournalManagement"
{
  
  
    Permissions=TableData 80=rimd,
                TableData 232=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text50000 : TextConst ENU='Rental',ESP='ALQUILER';
      Text001 : TextConst ENU='%1 journal',ESP='Diario %1';
      Text003 : TextConst ENU='Recurring General Journal',ESP='Diario general peri¢dico';
      Text002 : TextConst ENU='RECURRING',ESP='PERIODICO';
      Text004 : TextConst ENU='DEFAULT',ESP='GENERICO';
      Text005 : TextConst ENU='Default Journal',ESP='Diario gen‚rico';

    PROCEDURE TemplateSelection(FormID : Integer;RecurringJnl : Boolean;VAR ElementJournalLine : Record 7207350;VAR JnlSelected : Boolean);
    VAR
      JournalTemplateElement : Record 7207349;
    BEGIN
      JnlSelected := TRUE;

      JournalTemplateElement.RESET;
      JournalTemplateElement.SETRANGE("Page ID",FormID);

      JournalTemplateElement.SETRANGE(Recurring,RecurringJnl);

      CASE JournalTemplateElement.COUNT OF
        0:
          BEGIN
            JournalTemplateElement.INIT;
            JournalTemplateElement.Recurring := RecurringJnl;
            IF NOT RecurringJnl THEN BEGIN
              JournalTemplateElement.Name := FORMAT(Text50000,MAXSTRLEN(JournalTemplateElement.Name));
              JournalTemplateElement.Description := STRSUBSTNO(Text001,Text50000);
            END ELSE BEGIN
              JournalTemplateElement.Name := Text002;
              JournalTemplateElement.Description := Text003;
            END;
            JournalTemplateElement.VALIDATE("Page ID");
            JournalTemplateElement.INSERT;
            COMMIT;
          END;
        1:
          JournalTemplateElement.FINDFIRST;
        ELSE
          JnlSelected := PAGE.RUNMODAL(0,JournalTemplateElement) = ACTION::LookupOK;
      END;
      IF JnlSelected THEN BEGIN
        ElementJournalLine.FILTERGROUP := 2;
        ElementJournalLine.SETRANGE("Journal Template Name",JournalTemplateElement.Name);
        ElementJournalLine.FILTERGROUP := 0;
      END;
    END;

    PROCEDURE OpenJnl(VAR CurrentJnlBatchName : Code[10];VAR ElementJournalLine : Record 7207350);
    BEGIN
      ElementJournalLine.FILTERGROUP := 2;
      IF ElementJournalLine.GETFILTER("Journal Batch Name") <> '' THEN
        CurrentJnlBatchName := ElementJournalLine.GETRANGEMAX("Journal Batch Name");
      CheckTemplateName(ElementJournalLine.GETRANGEMAX("Journal Template Name"),CurrentJnlBatchName);
      ElementJournalLine.SETRANGE("Journal Batch Name",CurrentJnlBatchName);
      ElementJournalLine.FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE CheckTemplateName(CurrentJnlTemplateName : Code[10];VAR CurrentJnlBatchName : Code[10]);
    VAR
      ElementJournalSection : Record 7207351;
    BEGIN
      ElementJournalSection.SETRANGE("Journal Template Name",CurrentJnlTemplateName);
      IF NOT ElementJournalSection.GET(CurrentJnlTemplateName,CurrentJnlBatchName) THEN BEGIN
        IF NOT ElementJournalSection.FINDFIRST THEN BEGIN
          ElementJournalSection.INIT;
          ElementJournalSection."Journal Template Name" := CurrentJnlTemplateName;
          ElementJournalSection.SetupNewBatch;
          ElementJournalSection.Name := Text004;
          ElementJournalSection.Description := Text005;
          ElementJournalSection.INSERT(TRUE);
          COMMIT;
        END;
        CurrentJnlBatchName := ElementJournalSection.Name
      END;
    END;

    PROCEDURE CheckName(CurrentJnlBatchName : Code[10];VAR ElementJournalLine : Record 7207350);
    VAR
      ElementJournalSection : Record 7207351;
    BEGIN
      ElementJournalSection.GET(ElementJournalLine.GETRANGEMAX("Journal Template Name"),CurrentJnlBatchName);
    END;

    PROCEDURE SetName(CurrentJnlBatchName : Code[10];VAR ElementJournalLine : Record 7207350);
    BEGIN
      ElementJournalLine.FILTERGROUP := 2;
      ElementJournalLine.SETRANGE("Journal Batch Name",CurrentJnlBatchName);
      ElementJournalLine.FILTERGROUP := 0;
      IF ElementJournalLine.FINDFIRST THEN;
    END;

    PROCEDURE LookupName(VAR CurrentJnlBatchName : Code[10];VAR ElementJournalLine : Record 7207350);
    VAR
      ElementJournalSection : Record 7207351;
    BEGIN
      COMMIT;
      ElementJournalSection."Journal Template Name" := ElementJournalLine.GETRANGEMAX("Journal Template Name");
      ElementJournalSection.Name := ElementJournalLine.GETRANGEMAX("Journal Batch Name");
      ElementJournalSection.FILTERGROUP := 2;
      ElementJournalSection.SETRANGE("Journal Template Name",ElementJournalSection."Journal Template Name");
      ElementJournalSection.FILTERGROUP := 0;
      IF PAGE.RUNMODAL(0,ElementJournalSection) = ACTION::LookupOK THEN BEGIN
        CurrentJnlBatchName := ElementJournalSection.Name;
        SetName(CurrentJnlBatchName,ElementJournalLine);
      END;
    END;

    PROCEDURE GetAccounts(VAR ElementJournalLine : Record 7207350;VAR AccName : Text[30]);
    VAR
      RentalElements : Record 7207344;
    BEGIN
      //devuelve el nombre del elemento
      AccName := '';
      IF RentalElements.GET(ElementJournalLine."Element No.") THEN
        AccName := RentalElements.Description;

      ElementJournalLine := ElementJournalLine;
    END;

    PROCEDURE CalcBalance(VAR ElementJournalLine : Record 7207350;LastElementJournalLine : Record 7207350;VAR Balance : Decimal;VAR TotalBalance : Decimal;VAR ShowBalance : Boolean;VAR ShowTotalBalance : Boolean);
    VAR
      TempElementJournalLine : Record 7207350;
    BEGIN
      TempElementJournalLine.COPYFILTERS(ElementJournalLine);
      ShowTotalBalance := TempElementJournalLine.CALCSUMS(TempElementJournalLine.Quantity);
      IF ShowTotalBalance THEN BEGIN
        TotalBalance := TempElementJournalLine.Quantity;
        IF ElementJournalLine."Line No." = 0 THEN
          TotalBalance := TotalBalance + LastElementJournalLine.Quantity;
      END;

      IF ElementJournalLine."Line No." <> 0 THEN BEGIN
        TempElementJournalLine.SETRANGE("Line No.",0,ElementJournalLine."Line No.");
        ShowBalance := TempElementJournalLine.CALCSUMS(Quantity);
        IF ShowBalance THEN
          Balance := TempElementJournalLine.Quantity;
      END ELSE BEGIN
        TempElementJournalLine.SETRANGE("Line No.",0,LastElementJournalLine."Line No.");
        ShowBalance := TempElementJournalLine.CALCSUMS(Quantity);
        IF ShowBalance THEN BEGIN
          Balance := TempElementJournalLine.Quantity;
          TempElementJournalLine.COPYFILTERS(ElementJournalLine);
          TempElementJournalLine := LastElementJournalLine;
          IF TempElementJournalLine.NEXT = 0 THEN
            Balance := Balance + LastElementJournalLine.Quantity;
        END;
      END;
    END;

    /* /*BEGIN
END.*/
}








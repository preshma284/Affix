Codeunit 7207320 "Journal. (Elem)-Register+Print"
{
  
  
    TableNo=7207350;
    trigger OnRun()
BEGIN
            ElementJournalLine.COPY(Rec);
            Code;
            Rec.COPY(ElementJournalLine);
          END;
    VAR
      ElementJournalLine : Record 7207350;
      JournalTemplateElement : Record 7207349;
      Text000 : TextConst ENU='Cannot be filtered when posting recurring journals',ESP='No puede contener un filtro cuando se registra un diario peri�dico';
      Text001 : TextConst ENU='Do you want to post the journal lines and print the report(s)?',ESP='�Confirma que desea registrar las l�ns. del diario e imprimir el informe(s)?';
      Text002 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text003 : TextConst ENU='The journal lines were successfully posted.',ESP='Se han registrado correctamente las l�neas del diario.';
      Text004 : TextConst ENU='The journal lines were successfully posted. You are now in the %1 journal.',ESP='Se registraron correctamente las l�neas diario. Se encuentra en el diario %1.';
      TempJnlBatchName : Code[10];
      ElementPostingEntries : Record 7207352;
      i : Integer;
      JournalElementRegisterLo : Codeunit 7207317;

    LOCAL PROCEDURE Code();
    BEGIN
      WITH ElementJournalLine DO BEGIN
        JournalTemplateElement.GET("Journal Template Name");
        IF JournalTemplateElement."Force Posting Report"
        THEN
          JournalTemplateElement.TESTFIELD("Posting Report ID");
        IF JournalTemplateElement.Recurring AND (GETFILTER("Posting Date") <> '') THEN
          FIELDERROR("Posting Date",Text000);

        IF NOT CONFIRM(Text001,FALSE) THEN
          EXIT;

        TempJnlBatchName := "Journal Batch Name";

        ElementPostingEntries.LOCKTABLE;
        ElementPostingEntries.FINDLAST;
        i := ElementPostingEntries."Transaction No." + 1;

        JournalElementRegisterLo.RUN(ElementJournalLine);

        ElementPostingEntries.SETFILTER("Transaction No.",'%1..',i);
        IF ElementPostingEntries.GET("Line No.") THEN BEGIN
          IF JournalTemplateElement."Posting Report ID" <> 0 THEN BEGIN
            REPORT.RUN(JournalTemplateElement."Posting Report ID",FALSE,FALSE,ElementPostingEntries);
          END;
        END;

        IF "Line No." = 0 THEN
          MESSAGE(Text002)
        ELSE
          IF TempJnlBatchName = "Journal Batch Name" THEN
            MESSAGE(Text003)
          ELSE
            MESSAGE(
              Text004,
              "Journal Batch Name");

        IF NOT FIND('=><') OR (TempJnlBatchName <> "Journal Batch Name") THEN BEGIN
          RESET;
          FILTERGROUP(2);
          SETRANGE("Journal Template Name","Journal Template Name");
          SETRANGE("Journal Batch Name","Journal Batch Name");
          FILTERGROUP(0);
          "Line No." := 1;
        END;
      END;
    END;

    /* /*BEGIN
END.*/
}








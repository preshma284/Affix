Codeunit 7207303 "Post. Expense Note (Yes/No)"
{
  
  
    TableNo=7207320;
    trigger OnRun()
BEGIN
            ExpenseNotesHeader.COPY(Rec);
            code;
            Rec := ExpenseNotesHeader;
          END;
    VAR
      ExpenseNotesHeader : Record 7207320;
      Text001 : TextConst ENU='Do you confirm you want to post document %1 ?',ESP='�Confirma que desea registrar el documento?';
      postExpenseNote : Codeunit 7207304;

    PROCEDURE code();
    BEGIN
      WITH ExpenseNotesHeader DO BEGIN
        IF NOT CONFIRM(Text001,FALSE) THEN
          EXIT;
        postExpenseNote.RUN(ExpenseNotesHeader);
      END;
    END;

    /* /*BEGIN
END.*/
}








Codeunit 7207323 "Post Prod. Measure (Yes/No)"
{
  
  
    TableNo=7207399;
    trigger OnRun()
BEGIN
            ProdMeasureHeader.COPY(Rec);
            code;
            Rec := ProdMeasureHeader;
          END;
    VAR
      ProdMeasureHeader : Record 7207399;
      Text001 : TextConst ENU='Confirm do you want to post Document %1?',ESP='�Confirma que desea registrar el documento %1?';
      PostProdMeasure : Codeunit 7207324;

    PROCEDURE code();
    BEGIN
      WITH ProdMeasureHeader DO BEGIN
        IF NOT CONFIRM(Text001,FALSE,ProdMeasureHeader."No.") THEN
          EXIT;
       PostProdMeasure.RUN(ProdMeasureHeader);
      END;
    END;

    /* /*BEGIN
END.*/
}








Codeunit 7207305 "Withholding Movement-Edit"
{
  
  
    TableNo=7207329;
    Permissions=TableData 7207329=rimd;
    trigger OnRun()
VAR
            xRecRef : RecordRef;
          BEGIN
            WithholdingMovement := Rec;
            WithholdingMovement.LOCKTABLE;
            WithholdingMovement.FIND;
            xRecRef.GETTABLE(WithholdingMovement);
            IF WithholdingMovement.Open THEN BEGIN
              WithholdingMovement.VALIDATE("No.", rec."No.");
              WithholdingMovement."Withholding Type" := rec."Withholding Type";
              WithholdingMovement."Due Date" := rec."Due Date";
              WithholdingMovement.Description :=rec.Description;
            END;
            WithholdingMovement.MODIFY;
            Rec := WithholdingMovement;
          END;
    VAR
      WithholdingMovement : Record 7207329;
      ChangeLogMgt : Codeunit 423;

    /* /*BEGIN
END.*/
}








Codeunit 7207311 "Element Contract Release/Open"
{
  
  
    TableNo=7207353;
    trigger OnRun()
BEGIN
            IF rec."Document Status" = rec."Document Status"::Released THEN
              EXIT;

            rec.TESTFIELD("Customer/Vendor No.");
            //Compruebo que haya l�neas y si no me salgo

            ElementContractLines.SETRANGE(ElementContractLines."Document No.",rec."No.");
            IF NOT ElementContractLines.FINDFIRST THEN
              EXIT;

            rec."Document Status" := rec."Document Status"::Released;
            rec.MODIFY;
          END;
    VAR
      ElementContractLines : Record 7207354;

    PROCEDURE Reopen(VAR ElementContractHeader : Record 7207353);
    VAR
      ElementContractLines : Record 7207354;
    BEGIN
      WITH ElementContractHeader DO BEGIN
        IF ElementContractHeader."Document Status" = ElementContractHeader."Document Status"::Open THEN
          EXIT;
         ElementContractHeader."Document Status" := ElementContractHeader."Document Status"::Open;
         ElementContractHeader.MODIFY;
      END;
    END;

    /* /*BEGIN
END.*/
}








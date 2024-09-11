Codeunit 7207299 "Get Complete Subcontracting"
{
  
  
    TableNo=7207413;
    trigger OnRun()
BEGIN
            ComparativeQuoteHeader.GET(rec."Quote No.");
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.FILTERGROUP(2);
            DataPieceworkForProduction.SETCURRENTKEY(DataPieceworkForProduction."Job No.",DataPieceworkForProduction."No. Subcontracting Resource");
            DataPieceworkForProduction.SETRANGE("Job No.",ComparativeQuoteHeader."Job No.");

            Job.GET(ComparativeQuoteHeader."Job No.");
            DataPieceworkForProduction.SETRANGE("Budget Filter",Job."Current Piecework Budget");

            DataPieceworkForProduction.SETFILTER("No. Subcontracting Resource",'<>%1','');
            DataPieceworkForProduction.SETFILTER("Activity Code",ComparativeQuoteHeader."Activity Filter");
            DataPieceworkForProduction.FILTERGROUP(0);
            CLEAR(ProposeSubcontracting);
            ProposeSubcontracting.LOOKUPMODE(TRUE);
            ProposeSubcontracting.SETTABLEVIEW(DataPieceworkForProduction);
            ProposeSubcontracting.PassComparative(ComparativeQuoteHeader);
            IF DataPieceworkForProduction.FINDFIRST THEN
              ProposeSubcontracting.SETRECORD(DataPieceworkForProduction);
            IF ProposeSubcontracting.RUNMODAL=ACTION::LookupOK THEN;
          END;
    VAR
      ComparativeQuoteHeader : Record 7207412;
      DataPieceworkForProduction : Record 7207386;
      Job : Record 167;
      ProposeSubcontracting : Page 7207556;

    PROCEDURE CreateLines(VAR DataPieceworkForProductionPass : Record 7207386);
    VAR
      ComparativeQuoteLines : Record 7207413;
      DataCostByPiecework : Record 7207387;
      locrecProyecto : Record 167;
      Job : Record 167;
      locintUltMov : Integer;
    BEGIN
      WITH DataPieceworkForProductionPass DO BEGIN
        IF DataPieceworkForProductionPass.FINDSET(FALSE) THEN BEGIN
          Job.GET(DataPieceworkForProductionPass."Job No.");
          ComparativeQuoteLines.SETRANGE("Quote No.",ComparativeQuoteHeader."No.");
          IF ComparativeQuoteLines.FINDLAST THEN
            locintUltMov := ComparativeQuoteLines."Line No."
          ELSE
            locintUltMov := 0;
          REPEAT
            CLEAR(ComparativeQuoteLines);
            ComparativeQuoteLines."Quote No.":= ComparativeQuoteHeader."No.";
            locintUltMov := locintUltMov + 10000;
            ComparativeQuoteLines."Line No." := locintUltMov;
            ComparativeQuoteLines.INSERT(TRUE);
            //-Q20082
            ComparativeQuoteLines.VALIDATE("Job No.",ComparativeQuoteHeader."Job No.");
            //+Q20082
            ComparativeQuoteLines.VALIDATE(Type,ComparativeQuoteLines.Type::Resource);
            ComparativeQuoteLines.VALIDATE("No.",DataPieceworkForProductionPass."No. Subcontracting Resource");
            ComparativeQuoteLines.VALIDATE("Unit of measurement Code",DataPieceworkForProductionPass."Unit Of Measure");
            ComparativeQuoteLines.MODIFY(TRUE);
            ComparativeQuoteLines.VALIDATE("Piecework No.",DataPieceworkForProductionPass."Piecework Code");
            ComparativeQuoteLines.VALIDATE(Description,DataPieceworkForProductionPass.Description);
            DataPieceworkForProductionPass.CALCFIELDS("Budget Measure","Total Measurement Production","Aver. Cost Price Pend. Budget");
            IF DataPieceworkForProductionPass."Budget Measure" - DataPieceworkForProductionPass."Total Measurement Production" > 0 THEN BEGIN
              ComparativeQuoteLines.VALIDATE(Quantity,DataPieceworkForProductionPass."Budget Measure" - DataPieceworkForProductionPass."Total Measurement Production");
            END;

            //-Q18970.1
            DataCostByPiecework.SETRANGE("Job No.",DataPieceworkForProductionPass."Job No.");
            DataCostByPiecework.SETRANGE("Piecework Code",DataPieceworkForProductionPass."Piecework Code");
            DataCostByPiecework.SETRANGE("Cod. Budget",Job."Current Piecework Budget");
            DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
            DataCostByPiecework.SETRANGE("No.",DataPieceworkForProductionPass."No. Subcontracting Resource");
            IF DataCostByPiecework.FINDFIRST THEN BEGIN
            //IF DataCostByPiecework.GET(DataPieceworkForProductionPass."Job No.",DataPieceworkForProductionPass."Piecework Code",
            //                       Job."Current Piecework Budget",
            //                       DataCostByPiecework."Cost Type"::Resource,DataPieceworkForProductionPass."No. Subcontracting Resource") THEN BEGIN
            //+Q18970.1
                 ComparativeQuoteLines.VALIDATE("Estimated Price",DataCostByPiecework."Direct Unitary Cost (JC)");
                 ComparativeQuoteLines.VALIDATE(Description,DataCostByPiecework.Description);
            END;
            ComparativeQuoteLines.MODIFY(TRUE);
          UNTIL DataPieceworkForProductionPass.NEXT = 0;
        END;
      END;
    END;

    PROCEDURE SetComparative(VAR ComparativeQuoteHeaderPass : Record 7207412);
    BEGIN
      ComparativeQuoteHeader.GET(ComparativeQuoteHeaderPass."No.");
    END;

    /*BEGIN
/*{
      AML 12/6/23  -  Adaptaciones nueva clave para Data cost by piecework.
    }
END.*/
}








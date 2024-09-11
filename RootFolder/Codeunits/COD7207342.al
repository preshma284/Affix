Codeunit 7207342 "Validate Cotract Price"
{
  
  
    TableNo=167;
    trigger OnRun()
VAR
            UnitaryCostByJob : Record 7207439;
            DataCostByPiecework : Record 7207387;
            DataPieceworkForProduction : Record 7207386;
            RateBudgetsbyPiecework : Codeunit 7207329;
            JobBudget : Record 7207407;
          BEGIN
            IF NOT CONFIRM(Text001,FALSE) THEN
              EXIT;

            UnitaryCostByJob.SETRANGE("Job No.",rec."No.");
            IF UnitaryCostByJob.FINDSET THEN BEGIN
              REPEAT
                CASE UnitaryCostByJob.Type OF
                  UnitaryCostByJob.Type::Item: BEGIN
                    DataCostByPiecework.SETRANGE("Job No.",rec."No.");
                    DataCostByPiecework.SETRANGE("Cod. Budget",rec."Initial Budget Piecework");
                    DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Item);
                    DataCostByPiecework.SETRANGE("No.",UnitaryCostByJob."No.");
                    IF DataCostByPiecework.FINDSET THEN
                      REPEAT
                        DataCostByPiecework.VALIDATE("Contract Price",UnitaryCostByJob."Contract Price");
                        DataCostByPiecework.VALIDATE("Sale Price (Base)",UnitaryCostByJob."Sales Price (Base)");
                        DataCostByPiecework."Sale Price Redetermined" := DataCostByPiecework."Sale Price (Base)";
                        DataCostByPiecework.MODIFY;
                      UNTIL DataCostByPiecework.NEXT = 0;
                  END;
                  UnitaryCostByJob.Type::Resource: BEGIN
                    DataCostByPiecework.SETRANGE("Job No.",rec."No.");
                    DataCostByPiecework.SETRANGE("Cod. Budget",rec."Initial Budget Piecework");
                    DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                    DataCostByPiecework.SETRANGE("No.",UnitaryCostByJob."No.");
                    IF DataCostByPiecework.FINDSET THEN
                      REPEAT
                        DataCostByPiecework.VALIDATE("Contract Price",UnitaryCostByJob."Contract Price");
                        DataCostByPiecework.VALIDATE("Sale Price (Base)",UnitaryCostByJob."Sales Price (Base)");
                        DataCostByPiecework."Sale Price Redetermined" := DataCostByPiecework."Sale Price (Base)";
                        DataCostByPiecework.MODIFY;
                      UNTIL DataCostByPiecework.NEXT = 0;

                  END;
                  UnitaryCostByJob.Type::Machine: BEGIN
                    DataCostByPiecework.SETRANGE("Job No.",rec."No.");
                    DataCostByPiecework.SETRANGE("Cod. Budget",rec."Initial Budget Piecework");
                    DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                    DataCostByPiecework.SETRANGE("No.",UnitaryCostByJob."No.");
                    IF DataCostByPiecework.FINDSET THEN
                      REPEAT
                        DataCostByPiecework.VALIDATE("Contract Price",UnitaryCostByJob."Contract Price");
                        DataCostByPiecework.VALIDATE("Sale Price (Base)",UnitaryCostByJob."Sales Price (Base)");
                        DataCostByPiecework."Sale Price Redetermined" := DataCostByPiecework."Sale Price (Base)";
                        DataCostByPiecework.MODIFY;
                      UNTIL DataCostByPiecework.NEXT = 0;

                  END;
                END;
              UNTIL UnitaryCostByJob.NEXT = 0;
            END;

            CLEAR(DataPieceworkForProduction);
            DataPieceworkForProduction.SETRANGE("Job No.",rec."No.");
            DataPieceworkForProduction.SETRANGE("Production Unit",TRUE);
            DataPieceworkForProduction.SETRANGE(Type,DataPieceworkForProduction.Type::Piecework);
            DataPieceworkForProduction.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
            IF DataPieceworkForProduction.FINDSET THEN BEGIN
              REPEAT
                DataPieceworkForProduction.CalculatePricesOfBillItems;
              UNTIL DataPieceworkForProduction.NEXT = 0;
            END;
            CLEAR(RateBudgetsbyPiecework);
            CLEAR(JobBudget);
            RateBudgetsbyPiecework.ValueInitialization(Rec,JobBudget);
          END;
    VAR
      Text001 : TextConst ENU='Do you want validate the definition actual of contract prices?',ESP='�Desea validar la actual definici�n de precios de contrato?';

    /* /*BEGIN
END.*/
}








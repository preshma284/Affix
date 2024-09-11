Codeunit 7207358 "QB Currency Calcs Functions"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE CalcAmt_OtherCurrency(ConvertFunction: Option "ContractAmt","BudgetSales","BudgetCost","PWMeasureCert","PurchRcptNormal","PurchRcptFRI","PurchRcptPending","PurchRcptWhse";ToCurrency: Option "Contract","ACY","LCY";JobNo : Code[20]) : Decimal;
    VAR
      GeneralLedgerSetup : Record 98;
      Job : Record 167;
      PurchRcptLine : Record 121;
      JobCurrencyExchangeFunction : Codeunit 7207332;
      FRI : Boolean;
      FromCurrencyCode : Code[10];
      ToCurrencyCode : Code[10];
      AmountToConvert : Decimal;
      ConvertedAmount : Decimal;
      Amount : Decimal;
      Factor : Decimal;
      CostSalesType : Integer;
    BEGIN
      //Q7539 -+
      GeneralLedgerSetup.GET;
      GeneralLedgerSetup.TESTFIELD("LCY Code");

      Job.GET(JobNo);

      CASE ToCurrency OF
        ToCurrency::Contract:
          BEGIN
            FromCurrencyCode := GeneralLedgerSetup."LCY Code";
            ToCurrencyCode := Job."Currency Code";
          END;
        ToCurrency::ACY:
          BEGIN
            //JMMA PARA CONVERTIR A ADICIONAL LA MONEDA ORIGEN ES LCY
            //FromCurrencyCode := Job."Currency Code";
            FromCurrencyCode:=GeneralLedgerSetup."LCY Code";
            ToCurrencyCode := Job."Aditional Currency";
          END;
        ToCurrency::LCY:
          BEGIN
            FromCurrencyCode := Job."Currency Code";
            ToCurrencyCode := GeneralLedgerSetup."LCY Code";
          END;
      END;

      CASE ConvertFunction OF
        ConvertFunction::ContractAmt:
          BEGIN
            Job.CALCFIELDS("Contract Amount");
            AmountToConvert := Job."Contract Amount";
            CostSalesType := 1;
          END;
        ConvertFunction::BudgetCost:
          BEGIN
            Job.CALCFIELDS("Budget Cost Amount");
            AmountToConvert := Job."Budget Cost Amount";
            CostSalesType := 0;
          END;
        ConvertFunction::BudgetSales:
          BEGIN
            Job.CALCFIELDS("Budget Sales Amount");
            AmountToConvert := Job."Budget Sales Amount";
            CostSalesType := 1
          END;
        ConvertFunction::PWMeasureCert:
          BEGIN
            Job.CALCFIELDS("Amou Piecework Meas./Certifi.");
            AmountToConvert := Job."Amou Piecework Meas./Certifi.";
            CostSalesType := 1;
          END;
      //Q7635 - DE ALBARANES
        ConvertFunction::PurchRcptNormal,ConvertFunction::PurchRcptFRI,ConvertFunction::PurchRcptPending:
          BEGIN
            Job.CALCFIELDS("Shipment Pend. Amt (JC)","Shipment Pend. Amt (LCY)");

            CASE ConvertFunction OF
              ConvertFunction::PurchRcptNormal  : AmountToConvert := Job."Shipment Pend. Amt (JC)" - Job."Shipment Pend. Amt (LCY)" ;
              ConvertFunction::PurchRcptFRI     : AmountToConvert := Job."Shipment Pend. Amt (LCY)";
              ConvertFunction::PurchRcptPending : AmountToConvert := Job."Shipment Pend. Amt (JC)";
              ConvertFunction::PurchRcptWhse    : AmountToConvert := Job."Shipment Pend. Amt (JC)";
            END;
            JobCurrencyExchangeFunction.CalculateCurrencyValue(JobNo,AmountToConvert,FromCurrencyCode,ToCurrencyCode,PurchRcptLine."Posting Date",0,ConvertedAmount,Factor);

            EXIT(ConvertedAmount);
          END;
      //Q7635 +
      END;

      IF AmountToConvert = 0 THEN
        EXIT(0);
      JobCurrencyExchangeFunction.CalculateCurrencyValue(JobNo,AmountToConvert,FromCurrencyCode,ToCurrencyCode,0D,CostSalesType,Amount,Factor);
      EXIT(Amount);

      EXIT(Amount);
    END;

    PROCEDURE CalcAdditonalAmt_OtherCurrency(ConvertFunction: Option "GeneralExpense","IndustBenefit","Low","QualityDeduction";ToCurrency: Option "GeneralExpense","IndustBenefit","Low","QualityDeduction";JobNo : Code[20]) : Decimal;
    VAR
      Currency : Record 4;
      Job : Record 167;
      AmountToConvert : Decimal;
    BEGIN
      //Q7539 -+
      Job.GET(JobNo);

      AmountToConvert := CalcAmt_OtherCurrency(0,ToCurrency,JobNo);
      IF AmountToConvert = 0 THEN
        EXIT(0);

      CASE ConvertFunction OF
        ConvertFunction::GeneralExpense:
          EXIT(ROUND(AmountToConvert * (Job."General Expenses / Other" / 100),Currency."Unit-Amount Rounding Precision"));
        ConvertFunction::IndustBenefit:
          EXIT(ROUND(AmountToConvert * (Job."Industrial Benefit" / 100),Currency."Unit-Amount Rounding Precision"));
        ConvertFunction::Low:
          EXIT(ROUND(AmountToConvert * (1 + (Job."General Expenses / Other" / 100) + ((Job."Industrial Benefit" / 100) * (Job."Low Coefficient" / 100))),
                     Currency."Unit-Amount Rounding Precision"));
        ConvertFunction::QualityDeduction:
          EXIT(ROUND(AmountToConvert * (1 + (Job."General Expenses / Other" / 100) + ((Job."Industrial Benefit" / 100) * (1 - ((Job."Low Coefficient" / 100) * (Job."Quality Deduction" / 100))))),
                     Currency."Unit-Amount Rounding Precision"));
      END;
    END;

    PROCEDURE CalcPercentage_OtherCurrency(ConvertFunction: Option "IndirectCost","ExpectedMargin","DirectMargin";ToCurrency: Option "Contract","ACY","LCY";JobNo : Code[20]) : Decimal;
    VAR
      Job : Record 167;
      BudgetSalesAmt : Decimal;
      BudgetCostAmt : Decimal;
    BEGIN
      //Q7539 -+
      Job.GET(JobNo);
      Job.CALCFIELDS("Direct Cost Amount PW (ACY)","Indirect Cost Amount PW (ACY)","Production Budget Amount (ACY)",
                     "Direct Cost Amount PW (JC)","Indirect Cost Amount PW (JC)","Production Budget Amount (JC)");
      CASE ConvertFunction OF
        ConvertFunction::IndirectCost:
          CASE ToCurrency OF
            ToCurrency::Contract:
              BEGIN
                IF Job."Direct Cost Amount PW (JC)" = 0 THEN
                  EXIT(0);
                EXIT(ROUND(Job."Indirect Cost Amount PW (JC)" * 100 / Job."Direct Cost Amount PW (JC)",0.01));
              END;
            ToCurrency::ACY:
              BEGIN
                IF Job."Direct Cost Amount PW (ACY)" = 0 THEN
                  EXIT(0);
                EXIT(ROUND(Job."Indirect Cost Amount PW (ACY)" * 100 / Job."Direct Cost Amount PW (ACY)",0.01));
              END;
          END;
        ConvertFunction::ExpectedMargin:
          CASE ToCurrency OF
            ToCurrency::Contract:
              BEGIN
                IF Job."Direct Cost Amount PW (JC)" = 0 THEN
                  EXIT(0);
                EXIT(ROUND((Job."Production Budget Amount (JC)" - Job."Direct Cost Amount PW (JC)") * 100 / Job."Direct Cost Amount PW (JC)",0.01));
              END;
            ToCurrency::ACY:
              BEGIN
                IF Job."Direct Cost Amount PW (ACY)" = 0 THEN
                  EXIT(0);
                EXIT(ROUND((Job."Production Budget Amount (ACY)" - Job."Direct Cost Amount PW (ACY)") * 100 / Job."Direct Cost Amount PW (ACY)",0.01));
              END;
          END;
        ConvertFunction::DirectMargin:
          BEGIN
            BudgetSalesAmt := CalcAmt_OtherCurrency(1,ToCurrency,Job."No.");
            BudgetCostAmt := CalcAmt_OtherCurrency(2,ToCurrency,Job."No.");
            IF BudgetSalesAmt = 0 THEN
              EXIT(0);
            EXIT((BudgetSalesAmt - BudgetCostAmt) / BudgetSalesAmt);
          END;
      END;
    END;

    PROCEDURE UpdateDataPWProductionOtherCurrAmt(VAR DataPieceworkForProduction : Record 7207386);
    VAR
      JobCurrExchangeFunction : Codeunit 7207332;
      Job : Record 167;
      Currency : Record 4;
      GLSetup : Record 98;
      CurrFactor : Decimal;
    BEGIN
      //Q7664, Q7664 MOD02 +
      WITH DataPieceworkForProduction DO BEGIN
        GLSetup.GET;
        Job.GET("Job No.");

        IF "Contract Price (JC)" = 0 THEN BEGIN
          VALIDATE("Contract Price",0);
          VALIDATE("Contract Price (LCY)",0);
          VALIDATE("Contract Price (ACY)",0);
        END ELSE BEGIN
          IF "Currency Code" = '' THEN BEGIN
            VALIDATE("Contract Price (LCY)","Contract Price (JC)");
            IF "Currency Code" <> Job."Currency Code" THEN BEGIN
              JobCurrExchangeFunction.CalculateCurrencyValue(Job."No.","Contract Price (JC)",GLSetup."LCY Code",Job."Currency Code",0D,0,"Contract Price",CurrFactor);
              VALIDATE("Contract Price");
            END ELSE
              VALIDATE("Contract Price","Contract Price (JC)");
            IF "Currency Code" <> Job."Aditional Currency" THEN BEGIN
              JobCurrExchangeFunction.CalculateCurrencyValue(Job."No.","Contract Price (JC)",GLSetup."LCY Code",Job."Aditional Currency",0D,0,"Contract Price (ACY)",CurrFactor);
              VALIDATE("Contract Price (ACY)");
            END ELSE
              VALIDATE("Contract Price (ACY)","Contract Price (JC)");
          END ELSE BEGIN
            IF "Currency Code" <> Job."Currency Code" THEN BEGIN
              JobCurrExchangeFunction.CalculateCurrencyValue(Job."No.","Contract Price (JC)","Currency Code",Job."Currency Code",0D,0,"Contract Price",CurrFactor);
              VALIDATE("Contract Price");
            END ELSE
              VALIDATE("Contract Price","Contract Price (JC)");
            IF "Currency Code" <> Job."Aditional Currency" THEN BEGIN
              JobCurrExchangeFunction.CalculateCurrencyValue(Job."No.","Contract Price (JC)","Currency Code",Job."Aditional Currency",0D,0,"Contract Price (ACY)",CurrFactor);
              VALIDATE("Contract Price (ACY)");
            END ELSE
              VALIDATE("Contract Price (ACY)","Contract Price (JC)");
            JobCurrExchangeFunction.CalculateCurrencyValue(Job."No.","Contract Price (JC)","Currency Code",GLSetup."LCY Code",0D,0,"Contract Price (LCY)",CurrFactor);
            VALIDATE("Contract Price (LCY)");
          END;
        END;
      END;
      //Q7664 MOD02 +
    END;

    /*BEGIN
/*{
      Q7539 JDC 10/09/19 - Created function "CalcAmt_OtherCurrency", "CalcAdditonalAmt_OtherCurrency", "CalcPercentagOtherCurrency"
      Q7635 JDC 12/09/19 - Modified function "CalcAmt_OtherCurrency"
      Q7539 JDC 30/09/19 - Modified function "CalcAmt_OtherCurrency", "CalcAdditonalAmt_OtherCurrency", "CalcPercentagOtherCurrency" to include LCY
      Q7664 JDC 01/10/19 - Created function "UpdateDataPWProductionOtherCurrAmt"
      Q7664 MOD02 JDC 17/10/19 - Modified function "UpdateDataPWProductionOtherCurrAmt"
    }
END.*/
}








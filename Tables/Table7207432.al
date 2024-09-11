table 7207432 "QBU Periodification Unit Cost"
{
  
  
    CaptionML=ENU='Periodification Unit Cost',ESP='Periodificaci¢n unidad de cte.';
  
  fields
{
    field(1;"Unit Cost";Code[20])
    {
        CaptionML=ENU='Unit Cost',ESP='Unidad de coste';


    }
    field(2;"Date";Date)
    {
        CaptionML=ENU='Date',ESP='Fecha';


    }
    field(3;"Amount";Decimal)
    {
        CaptionML=ENU='Amount',ESP='Cantidad';


    }
    field(4;"Period Amount";Decimal)
    {
        CaptionML=ENU='Period Amount',ESP='Importe per¡odo';
                                                   AutoFormatType=1;


    }
    field(5;"Job No.";Code[20])
    {
        CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(6;"Accrued Amount";Decimal)
    {
        CaptionML=ENU='Accrued Amount',ESP='Importe periodificado';
                                                   AutoFormatType=1;


    }
    field(7;"Cod. Budget";Code[20])
    {
        CaptionML=ENU='Cod. Budget',ESP='C¢d. presupuesto'; ;


    }
}
  keys
{
    key(key1;"Job No.","Unit Cost","Date","Cod. Budget")
    {
        SumIndexFields="Period Amount";
                                                   Clustered=true;
    }
    key(key2;"Unit Cost")
    {
        SumIndexFields="Amount";
    }
}
  fieldgroups
{
}
  
    var
//       DataPieceworkForProduction@7001100 :
      DataPieceworkForProduction: Record 7207386;
//       AmountAAccrue@7001101 :
      AmountAAccrue: Decimal;
//       AmountAccrued@7001102 :
      AmountAccrued: Decimal;

//     procedure AmountBudgetAccrued () VAmountBudgetAccrued@1000000001 :
    procedure AmountBudgetAccrued () VAmountBudgetAccrued: Decimal;
    begin
      CALCFIELDS("Period Amount");
      AmountAccrued := "Period Amount";
      DataPieceworkForProduction.GET("Job No.","Unit Cost");
      DataPieceworkForProduction.SETRANGE("Budget Filter","Cod. Budget");
      DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget","Budget Measure");
      AmountAAccrue := DataPieceworkForProduction."Aver. Cost Price Pend. Budget" * DataPieceworkForProduction."Budget Measure";
      VAmountBudgetAccrued := AmountAAccrue - AmountAccrued;
      exit(VAmountBudgetAccrued);
    end;

    /*begin
    end.
  */
}








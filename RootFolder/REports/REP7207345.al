report 7207345 "Cost Unit Periodify"
{
  
  
    CaptionML=ENU='Cost Unit Periodify',ESP='Periodificar unidades de coste';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Periodification Unit Cost";"Periodification Unit Cost")
{

               DataItemTableView=SORTING("Job No.","Unit Cost","Date");
               
                              ;
trigger OnPreDataItem();
    BEGIN 
                               i := 1;
                             END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group564")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("VDate";"VDate")
    {
        
                  CaptionML=ENU='Initial Date',ESP='Fecha inicial';
    }
    field("Lenght";"Lenght")
    {
        
                  CaptionML=ENU='Length Period',ESP='Longitud periodo';
    }
    field("NotPeriod";"NotPeriod")
    {
        
                  CaptionML=ENU='Numbers Periods',ESP='N§ periodos';
    }

}

}
}
  }
  labels
{
}
  
    var
//       Currency@7001100 :
      Currency: Record 4;
//       PeriodificationUnitCost@7001101 :
      PeriodificationUnitCost: Record 7207432;
//       VJob@7001102 :
      VJob: Code[20];
//       VUnitCost@7001103 :
      VUnitCost: Code[20];
//       BudgetJob@7001104 :
      BudgetJob: Code[20];
//       DataPieceworkForProduction@7001105 :
      DataPieceworkForProduction: Record 7207386;
//       Quantity@7001106 :
      Quantity: Decimal;
//       AmountTotal@7001107 :
      AmountTotal: Decimal;
//       AmountDistributed@7001108 :
      AmountDistributed: Decimal;
//       i@7001109 :
      i: Integer;
//       NotPeriod@7001110 :
      NotPeriod: Integer;
//       VDate@7001111 :
      VDate: Date;
//       Lenght@7001112 :
      Lenght: DateFormula;

    

trigger OnPostReport();    begin
                   CLEAR(Currency);
                   Currency.InitRoundingPrecision;

                   PeriodificationUnitCost.RESET;
                   PeriodificationUnitCost.SETRANGE("Job No.",VJob);
                   PeriodificationUnitCost.SETRANGE("Unit Cost",VUnitCost);
                   PeriodificationUnitCost.SETRANGE("Cod. Budget",BudgetJob);
                   if PeriodificationUnitCost.FINDSET then
                     PeriodificationUnitCost.DELETEALL;
                   PeriodificationUnitCost.RESET;

                   DataPieceworkForProduction.GET(VJob,VUnitCost);
                   DataPieceworkForProduction.SETRANGE("Budget Filter",BudgetJob);
                   DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget","Budget Measure");
                   Quantity := DataPieceworkForProduction."Budget Measure";
                   AmountTotal := Quantity * DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                   AmountDistributed := 0;
                   FOR i := 1 TO NotPeriod DO begin
                     PeriodificationUnitCost.INIT;
                     PeriodificationUnitCost."Job No." := VJob;
                     PeriodificationUnitCost.Date := VDate;
                     PeriodificationUnitCost."Unit Cost" := VUnitCost;
                     PeriodificationUnitCost."Cod. Budget" := BudgetJob;
                     PeriodificationUnitCost.VALIDATE(Amount,Quantity / NotPeriod);
                     PeriodificationUnitCost.VALIDATE("Period Amount",
                             ROUND(PeriodificationUnitCost.Amount * DataPieceworkForProduction."Aver. Cost Price Pend. Budget",
                                  Currency."Amount Rounding Precision"));
                     if not PeriodificationUnitCost.INSERT then
                       PeriodificationUnitCost.MODIFY;
                     AmountDistributed := AmountDistributed + PeriodificationUnitCost."Period Amount";
                     VDate := CALCDATE(Lenght,VDate);
                   end;

                   if AmountTotal <> AmountDistributed then begin
                     PeriodificationUnitCost.VALIDATE("Period Amount",PeriodificationUnitCost."Period Amount" + (AmountTotal - AmountDistributed));
                     PeriodificationUnitCost.MODIFY;
                   end;
                 end;



// procedure GetData (PUnitCost@7001100 : Code[20];PJob@7001101 : Code[20];PBudgetJob@7001102 :
procedure GetData (PUnitCost: Code[20];PJob: Code[20];PBudgetJob: Code[20])
    begin
      VUnitCost := PUnitCost;
      VJob := PJob;
      BudgetJob := PBudgetJob;
    end;

    /*begin
    end.
  */
  
}




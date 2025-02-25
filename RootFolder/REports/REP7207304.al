report 7207304 "Distribute Sale Budget"
{
  
  
    CaptionML=ENU='Distribute Sale Budget',ESP='Repartir presupuesto de venta';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Type"=CONST("Piecework"),"Account Type"=CONST("Unit"));
DataItemLink="Job No."= FIELD("No.") ;
trigger OnPreDataItem();
    BEGIN 
                               IF CostTotalJob = 0 THEN
                                 CurrReport.BREAK;

                               AmountAssigned := 0;
                               DataPieceworkForProductionP.SETRANGE("Job No.",Job."No.");
                               DataPieceworkForProductionP.SETRANGE(Type,DataPieceworkForProductionP.Type::Piecework);
                               DataPieceworkForProductionP.SETRANGE("Account Type",DataPieceworkForProductionP."Account Type"::Unit);
                               DataPieceworkForProductionP.SETRANGE("Production Unit",TRUE);
                               DataPieceworkForProductionP.SETFILTER("Budget Measure",'<>0');
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  Job.JobStatus(Job."No.");
                                  CALCFIELDS("Budget Measure","Aver. Cost Price Pend. Budget");
                                  DAmountCostBudget := "Budget Measure" * "Aver. Cost Price Pend. Budget";
                                  DPercentage := DAmountCostBudget / CostTotalJob;
                                  SalesAmount := Job."Amou Piecework Meas./Certifi." * DPercentage;
                                  DataPieceworkForProductionP := "Data Piecework For Production";
                                  IF DataPieceworkForProductionP.NEXT <> 0 THEN BEGIN 
                                    IF "Data Piecework For Production"."Budget Measure" <> 0 THEN BEGIN 
                                      "Data Piecework For Production"."Initial Produc. Price" :=
                                        ROUND(SalesAmount/"Data Piecework For Production"."Budget Measure",Currency."Unit-Amount Rounding Precision");

                                      IF "Data Piecework For Production"."Aver. Cost Price Pend. Budget" <> 0 THEN
                                        "Data Piecework For Production"."% Of Margin" :=
                                             ROUND((("Data Piecework For Production"."Initial Produc. Price" /
                                                   "Data Piecework For Production"."Aver. Cost Price Pend. Budget")-1)*100,0.01);

                                      "Data Piecework For Production".MODIFY;
                                      AmountAssigned := AmountAssigned + ROUND("Data Piecework For Production"."Initial Produc. Price" *
                                                            "Data Piecework For Production"."Budget Measure",Currency."Amount Rounding Precision");
                                    END;
                                  END ELSE BEGIN 
                                    IF "Data Piecework For Production"."Budget Measure" <> 0 THEN BEGIN 
                                      SalesAmount := Job."Amou Piecework Meas./Certifi." - AmountAssigned;
                                      "Data Piecework For Production"."Initial Produc. Price" :=
                                                ROUND(SalesAmount/"Data Piecework For Production"."Budget Measure",Currency."Unit-Amount Rounding Precision");
                                      IF "Data Piecework For Production"."Aver. Cost Price Pend. Budget" <> 0 THEN
                                        "Data Piecework For Production"."% Of Margin" :=
                                             ROUND((("Data Piecework For Production"."Initial Produc. Price" /
                                                   "Data Piecework For Production"."Aver. Cost Price Pend. Budget")-1)*100,0.01);
                                      "Data Piecework For Production".MODIFY;
                                    END;
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                IF Job.GET(Job."No.") THEN BEGIN 
                                  IF (Job."Job Type" = Job."Job Type"::Operative) AND
                                     (Job.Status = Job.Status::Planning) AND (Job."Original Quote Code" <> '') THEN
                                    JobOVersion :=TRUE
                                  ELSE
                                    JobOVersion := FALSE;
                                  DataPieceworkForProductionP.RESET;
                                  DataPieceworkForProductionP.SETRANGE("Job No.",Job."No.");
                                  IF DataPieceworkForProductionP.FINDFIRST THEN BEGIN 
                                    ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProductionP,JobOVersion,"Data Piecework For Production"."Job No.");
                                  END;
                                END;
                              END;


}
trigger OnPreDataItem();
    BEGIN 
                               CLEAR(Currency);
                               Currency.InitRoundingPrecision;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  CALCFIELDS(Job."Amou Piecework Meas./Certifi.");
                                  CostTotalJob := TotalCost;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       Currency@7001100 :
      Currency: Record 4;
//       CostTotalJob@7001101 :
      CostTotalJob: Decimal;
//       AmountAssigned@7001102 :
      AmountAssigned: Decimal;
//       DataPieceworkForProductionP@7001103 :
      DataPieceworkForProductionP: Record 7207386;
//       DAmountCostBudget@7001104 :
      DAmountCostBudget: Decimal;
//       DPercentage@7001105 :
      DPercentage: Decimal;
//       SalesAmount@7001106 :
      SalesAmount: Decimal;
//       JobOVersion@7001107 :
      JobOVersion: Boolean;
//       ConvertToBudgetxCA@7001108 :
      ConvertToBudgetxCA: Codeunit 7207282;

    procedure TotalCost () : Decimal;
    var
//       varCost@1000000000 :
      varCost: Decimal;
//       DataPieceworkForProduction@1000000001 :
      DataPieceworkForProduction: Record 7207386;
    begin
      DataPieceworkForProduction.RESET;
      DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.",Job."No.");
      DataPieceworkForProduction.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
      if DataPieceworkForProduction.FINDSET(FALSE,FALSE) then begin
        repeat
          varCost := varCost + DataPieceworkForProduction.AmountCostBudget;
        until DataPieceworkForProduction.NEXT=0;
      end;
      exit(varCost);
    end;

    /*begin
    end.
  */
  
}




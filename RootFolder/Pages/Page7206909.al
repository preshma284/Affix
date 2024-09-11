page 7206909 "Job Budgets"
{
Editable=false;
    CaptionML=ENU='Job Budget List',ESP='Lista presupuesto obra';
    SourceTable=7207407;
    SourceTableView=SORTING("Job No.","Budget Date")
                    ORDER(Ascending);
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Cod. Budget";rec."Cod. Budget")
    {
        
                Style=Unfavorable;
                StyleExpr=NotUpdated ;
    }
    field("Budget Name";rec."Budget Name")
    {
        
                Style=Unfavorable;
                StyleExpr=NotUpdated ;
    }
    field("Actual Budget";rec."Actual Budget")
    {
        
                Style=Unfavorable;
                StyleExpr=NotUpdated ;
    }
    field("txtCalculated";"txtCalculated")
    {
        
                CaptionML=ESP='Importes';
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=NotUpdated ;
    }
    field("Budget Date";rec."Budget Date")
    {
        
                Style=Unfavorable;
                StyleExpr=NotUpdated ;
    }
    field("Status";rec."Status")
    {
        
                Style=Unfavorable;
                StyleExpr=NotUpdated 

  ;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 JobDescription := '';
                 IF Rec.GETFILTER("Job No.") <> '' THEN
                   JobDescription := FunctionQB.ShowDescriptionJob(Rec.GETFILTER("Job No."));
               END;

trigger OnAfterGetCurrRecord()    BEGIN
                           //-PYO010
                           NotUpdated := (rec."Pending Calculation Budget" OR rec."Pending Calculation Analitical");
                           QBPageSubscriber.SetBudgetNeedRecalculate(rec."Pending Calculation Budget", rec."Pending Calculation Analitical", stCalculated1, stCalculated2, txtCalculated);
                         END;



    var
      DataPieceworkForProduction : Record 7207386;
      JobBudget : Record 7207407;
      PieceworkData : Page 7207506;
      CostUnitData : Page 7207535;
      DataInvestementUnit : Page 7207599;
      CertificationAssigned : Page 7207591;
      RateBudgetsbyPiecework : Codeunit 7207329;
      Text000 : TextConst ENU='CLOSED BUDGET',ESP='PRESUPUESTO CERRADO';
      Text008 : TextConst ENU='The analytical budget will be calculated. do you wish to continue?',ESP='Se va a calcular el presupuesto anal�tico. �Desea continuar?';
      ConvertToBudgetxCA : Codeunit 7207282;
      Text005 : TextConst ENU='The process is over',ESP='El proceso ha terminado';
      FunctionQB : Codeunit 7207272;
      JobDescription : Text[250];
      IsVersion : Boolean;
      TotalAmountStudiedBudget : Decimal;
      TotalAmountCostBudget : Decimal;
      DiffBiddingBasesBudget : Decimal;
      DiffAssignedAmount : Decimal;
      Text006 : TextConst ENU='Cannot reestimate actual budged',ESP='No puede reestimar el Presupuesto actual';
      bEditable : Boolean;
      NotUpdated : Boolean;
      QBPageSubscriber : Codeunit 7207349;
      txtCalculated : Text;
      stCalculated1 : Text;
      stCalculated2 : Text;/*

    begin
    {
      PEL: Listado de presup.
    }
    end.*/
  

}









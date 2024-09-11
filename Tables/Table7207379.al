table 7207379 "QBU Rules Job Treasury"
{
  
  
    CaptionML=ENU='Rules Job Treasury',ESP='Reglas tesor. proyecto';
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto';


    }
    field(2;"Analytic Concept";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Analytic Concept',ESP='Concepto anal¡tico';

trigger OnValidate();
    BEGIN 
                                                                FunctionQB.ValidateCA("Analytic Concept");
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              FunctionQB.LookUpCA("Analytic Concept",FALSE);
                                                            END;


    }
    field(3;"Cash Mgt Rule Code";Code[10])
    {
        CaptionML=ENU='Cash Mgt Rule Code',ESP='Cod. regla tesorer¡a';


    }
    field(4;"Special Planning";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist("Planning Job Special" WHERE ("Job No."=FIELD("Job No."),
                                                                                                   "Rule Code"=FIELD("Analytic Concept")));
                                                   CaptionML=ENU='Special Planning',ESP='Planificaci¢n especial';
                                                   Editable=false;


    }
    field(5;"VAT Prod. Posting Group";Code[20])
    {
        TableRelation="VAT Product Posting Group";
                                                   CaptionML=ENU='VAT Prod. Posting Group',ESP='Grupo registro IVA prod.';
                                                   Description='QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud' ;


    }
}
  keys
{
    key(key1;"Job No.","Analytic Concept")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       FunctionQB@7001100 :
      FunctionQB: Codeunit 7207272;

    

trigger OnDelete();    begin
               DeleteDataParticular;
               DeletePlanSpecial;
             end;



procedure DeleteDataParticular ()
    var
//       LCashMGTRuleDetail@1100251000 :
      LCashMGTRuleDetail: Record 7207380;
//       LDaysFixedPaymentJob@1100251001 :
      LDaysFixedPaymentJob: Record 7207381;
    begin
      LCashMGTRuleDetail.SETRANGE("Job No.","Job No.");
      LCashMGTRuleDetail.SETRANGE("Rule Code","Analytic Concept");
      LCashMGTRuleDetail.DELETEALL;

      LDaysFixedPaymentJob.SETRANGE("Job No.","Job No.");
      LDaysFixedPaymentJob.SETRANGE("Rule Code","Analytic Concept");
      LDaysFixedPaymentJob.DELETEALL;
    end;

    procedure DeletePlanSpecial ()
    var
//       LPlanningJobSpecial@1100251000 :
      LPlanningJobSpecial: Record 7207382;
    begin
      LPlanningJobSpecial.SETRANGE("Job No.","Job No.");
      LPlanningJobSpecial.SETRANGE("Rule Code","Analytic Concept");
      LPlanningJobSpecial.DELETEALL;
    end;

    procedure DescriptionConcept () : Text[50];
    var
//       LDimensionValue@1100251000 :
      LDimensionValue: Record 349;
    begin

      if LDimensionValue.GET(FunctionQB.ReturnDimCA,"Analytic Concept") then
        exit(LDimensionValue.Name)
      else
        exit('');
    end;

    procedure CaculateBudgetJob () : Decimal;
    var
//       LJob@1100251000 :
      LJob: Record 167;
    begin
      LJob.GET("Job No.");
      LJob.SETFILTER("Analytic Concept Filter","Analytic Concept");
      LJob.SETFILTER("Reestimation Filter",LJob."Latest Reestimation Code");

      LJob.CALCFIELDS("Budgeted Amount");

      exit(LJob."Budgeted Amount");
    end;

    /*begin
    end.
  */
}








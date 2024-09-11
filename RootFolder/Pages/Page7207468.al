page 7207468 "Job Concept Plan"
{
CaptionML=ENU='Job Concept Plan',ESP='Planifica conceptos proy.';
    SourceTable=349;
    SourceTableView=WHERE("Dimension Value Type"=CONST("Standard"));
    PageType=Worksheet;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
                Editable=False;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Distribute";Distribute)
    {
        
                CaptionML=ENU='%To Distribute',ESP='%A distribuir';
                Style=Standard;
                StyleExpr=TRUE;
                
                            ;trigger OnValidate()    BEGIN
                             //FunHitosCA(Promotion,"Dimension Code",Code,VarHitoInicio,VarHitoFin,VarTipoPlanifica,VArdistribuir,RecEsquema);
                           END;


    }
    field("MilestoneStar";MilestoneStar)
    {
        
                CaptionML=ENU='Milestone Star',ESP='Hito de inicio';
                TableRelation="Job Planning Milestones"."Planning Milestone Code";
                
                          ;trigger OnValidate()    BEGIN
                             //FunHitosCA(Promotion,"Dimension Code",Code,VarHitoInicio,VarHitoFin,VarTipoPlanifica,VArdistribuir,RecEsquema);
                           END;

trigger OnLookup(var Text: Text): Boolean    BEGIN
                           JobPlanningMilestones.SETRANGE(JobPlanningMilestones."Job No.",Promotion);
                           PageJobPlanningMilestone.SETTABLEVIEW(JobPlanningMilestones);
                           IF JobPlanningMilestones.GET(MilestoneStar) THEN;
                           PageJobPlanningMilestone.SETRECORD(JobPlanningMilestones);
                           PageJobPlanningMilestone.LOOKUPMODE(TRUE);
                           IF PageJobPlanningMilestone.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             PageJobPlanningMilestone.GETRECORD(JobPlanningMilestones);
                             MilestoneStar := JobPlanningMilestones."Planning Milestone Code";
                             //FunHitosCA(Promotion,"Dimension Code",Code,VarHitoInicio,VarHitoFin,VarTipoPlanifica,VArdistribuir,RecEsquema);
                           END;
                           CLEAR(PageJobPlanningMilestone);
                         END;


    }
    field("MilestoneEnd";MilestoneEnd)
    {
        
                CaptionML=ENU='Milestone End',ESP='Hito de Fin';
                TableRelation="Job Planning Milestones"."Planning Milestone Code";
                
                          ;trigger OnValidate()    BEGIN
                             //FunHitosCA(Promotion,"Dimension Code",Code,VarHitoInicio,VarHitoFin,VarTipoPlanifica,VArdistribuir,RecEsquema);
                           END;

trigger OnLookup(var Text: Text): Boolean    BEGIN
                           JobPlanningMilestones.SETRANGE(JobPlanningMilestones."Job No.",Promotion);
                           PageJobPlanningMilestone.SETTABLEVIEW(JobPlanningMilestones);
                           IF JobPlanningMilestones.GET(MilestoneEnd) THEN;
                           PageJobPlanningMilestone.SETRECORD(JobPlanningMilestones);
                           PageJobPlanningMilestone.LOOKUPMODE(TRUE);
                           IF PageJobPlanningMilestone.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             PageJobPlanningMilestone.GETRECORD(JobPlanningMilestones);
                             MilestoneEnd := JobPlanningMilestones."Planning Milestone Code";
                             //FunHitosCA(Promotion,"Dimension Code",Code,VarHitoInicio,VarHitoFin,VarTipoPlanifica,VArdistribuir,RecEsquema);
                           END;
                           CLEAR(PageJobPlanningMilestone);
                         END;


    }
    field("TypePlan";TypePlan)
    {
        
                CaptionML=ENU='Planning Type',ESP='Tipo planificaci¢n';
                Style=StrongAccent;
                StyleExpr=TRUE;
                
                            ;trigger OnValidate()    BEGIN
                             //FunHitosCA(Promotion,"Dimension Code",Code,VarHitoInicio,VarHitoFin,VarTipoPlanifica,VArdistribuir,RecEsquema);
                           END;


    }
    field("Name";rec."Name")
    {
        
                Editable=False ;
    }
    field("% Planned";rec."% Planned")
    {
        
                Editable=False ;
    }

}
    part("SubformDetail";7207469)
    {
        
                CaptionML=ENU='SubformDetail',ESP='SubformDetalle';
    }

}
}
  
trigger OnOpenPage()    BEGIN
                 Rec.SETRANGE("Dimension Code",FunctionQB.ReturnDimCA);
                 Rec.SETRANGE("Job Filter",Promotion);
                 CurrPage.SubformDetail.PAGE.SetPromotion(Promotion);
                 CurrPage.SubformDetail.PAGE.SetScheme(Scheme);
               END;



    var
      Promotion : Code[20];
      Scheme : Code[20];
      FunctionQB : Codeunit 7207272;
      Distribute : Decimal;
      MilestoneStar : Code[20];
      MilestoneEnd : Code[20];
      JobPlanningMilestones : Record 7207375;
      PageJobPlanningMilestone : Page 7207467;
      TypePlan: Option " ","Normal","Lineal";

    procedure SetJob(PPromotion : Code[20]);
    begin
      Promotion := PPromotion;
    end;

    procedure SetScheme(PScheme : Code[20]);
    begin
      Scheme := PScheme;
    end;

    // begin//end
}








pageextension 50101 MyExtension103 extends 103//84
{
layout
{


}

actions
{
addafter("EditAccountSchedule")
{
group("QB_Schema")
{
        
                      CaptionML=ENU='Schema',ESP='Esquema';
    action("QB_Milestones")
    {
        CaptionML=ENU='Milestones',ESP='Hitos';
                      RunObject=Page 7207467;
RunPageLink="Account Schedule Code"=field("Name"), "Job No."=CONST('');
                      Promoted=true;
                      Image=PayrollStatistics;
                      PromotedCategory=Process;
}
    action("QB_PlanningAssociatedWithMilestones")
    {
        
                      CaptionML=ENU='Planning Associated with Milestones',ESP='Planificaci¢n asociada a hitos';
                      Promoted=true;
                      Image=PaymentHistory;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 JobConceptPlan : Page 7207468;
                               BEGIN
                                 JobConceptPlan.SetScheme(rec."Name");
                                 JobConceptPlan.RUNMODAL;
                               END;


}
}
}


//modify("Overview")
//{
//
//
//}
//
}

//trigger

//trigger

var


//procedure

//procedure
}


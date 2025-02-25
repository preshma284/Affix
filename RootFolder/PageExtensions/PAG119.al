pageextension 50116 MyExtension119 extends 119//91
{
layout
{
addafter("Email")
{
    field("Jobs Resp. Ctr. Filter";rec."Jobs Resp. Ctr. Filter")
    {
        
}
    field("View all Jobs";rec."View all Jobs")
    {
        
                Visible=verControlUsuarios ;
}
    field("Modify Quote";rec."Modify Quote")
    {
        
                Visible=verQB ;
}
    field("Allow Delete Job Quotes";rec."Allow Delete Job Quotes")
    {
        
                Visible=verQB ;
}
    field("Modify Quote Status";rec."Modify Quote Status")
    {
        
                Visible=verQB ;
}
    field("Modify Job";rec."Modify Job")
    {
        
                Visible=verQB ;
}
    field("Modify Job Status";rec."Modify Job Status")
    {
        
                Visible=verQB ;
}
    field("Modify Budget Status";rec."Modify Budget Status")
    {
        
                Visible=verQB ;
}
    field("Change Rctp. Merge";rec."Change Rctp. Merge")
    {
        
                ToolTipML=ESP='Si se activa, el usuario puede cambiar el check de mezclar albaranes con diferentes condiciones en las facturas de compra.';
                Visible=verQB ;
}
    field("QB Validate Proform";rec."QB Validate Proform")
    {
        
}
    field("Mark Certifications Invoiced";rec."Mark Certifications Invoiced")
    {
        
                Visible=verQB ;
}
    field("Use FRI";rec."Use FRI")
    {
        
                Visible=verQB ;
}
    field("Control Contracts";rec."Control Contracts")
    {
        
                Visible=verQB ;
}
    field("QB Register in closed period";rec."QB Register in closed period")
    {
        
                ToolTipML=ENU='Indicates if the user can register documents that affect the Job in closed periods',ESP='Indica si el usuario puede registrar documentos que afecten e las obras a periodos cerrados';
                Visible=seeBudgetDate ;
}
    field("QB Allow Negative Target";rec."QB Allow Negative Target")
    {
        
}
    field("QPR Modify Budgets Status";rec."QPR Modify Budgets Status")
    {
        
}
    field("Guarantees Administrator";rec."Guarantees Administrator")
    {
        
                Visible=verQB ;
}
    field("Allow Gen. Posted Elec.Payment";rec."Allow Gen. Posted Elec.Payment")
    {
        
}
    field("See Balance";rec."See Balance")
    {
        
}
    field("Can Change Dimensions";rec."Can Change Dimensions")
    {
        
                ToolTipML=ESP='Indica si el usuario puede cambiar las dimensiones de movimientos registrados';
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 rec.HideExternalUsers;

                 //11/07/19: - Si est  activo el control de accesos, ver la columna de ver todos los proyectos
                 verQB := FunctionQB.AccessToQuobuilding;
                 verControlUsuarios := FunctionQB.QB_JobAccessControl;

                 //JAV 07/07/21: - QB 1.09.04 Si est  activo el control de fechas de presupuestos
                 seeBudgetDate := FunctionQB.QB_ControlBudgetDates;
               END;


//trigger

var
      FunctionQB : Codeunit 7207272;
      verControlUsuarios : Boolean ;
      verQB : Boolean;
      seeBudgetDate : Boolean;

    

//procedure

//procedure
}


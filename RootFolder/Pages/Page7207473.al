page 7207473 "Rule by Job"
{
    CaptionML = ENU = 'Rule by Job', ESP = 'Reglas por proyecto';
    SourceTable = 7207379;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Analytic Concept"; rec."Analytic Concept")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("DescriptionConcept"; rec."DescriptionConcept")
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Cash Mgt Rule Code"; rec."Cash Mgt Rule Code")
                {

                    Visible = false;
                }
                field("Special Planning"; rec."Special Planning")
                {

                }
                field("CaculateBudgetJob"; rec."CaculateBudgetJob")
                {

                    CaptionML = ENU = 'Budget Amount', ESP = 'Importe  presupuesto';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {

                    Visible = false

  ;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Rule by Job', ESP = '&Regla por proyecto';
                action("action1")
                {
                    CaptionML = ENU = 'Flow Detail', ESP = '&Detalle de flujos';
                    RunObject = Page 7207474;
                    RunPageLink = "Job No." = FIELD("Job No."), "Rule Code" = FIELD("Analytic Concept");
                    Image = Splitlines;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Sp&ecial Planning', ESP = 'Planificaci�n &Especiales';
                    RunObject = Page 7207476;
                    RunPageLink = "Job No." = FIELD("Job No."), "Rule Code" = FIELD("Analytic Concept");
                    Image = RoutingVersions;
                }

            }
            group("group5")
            {
                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("action3")
                {
                    CaptionML = ENU = 'Load General Rule', ESP = 'Cargar reglas generales';
                    Image = Import;

                    trigger OnAction()
                    VAR
                        CodeunitModificManagement: Codeunit 7207273;
                    BEGIN
                        CLEAR(CodeunitModificManagement);
                        CodeunitModificManagement.ChargeRulesGenerals(rec."Job No.");
                    END;


                }

            }

        }
        area(Creation)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }


    /*begin
    end.
  
*/
}








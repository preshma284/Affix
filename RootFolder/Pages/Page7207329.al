page 7207329 "Invoice Milestone List"
{
    CaptionML = ENU = 'Invoice Milestone List', ESP = 'Lista Hitos de Facturaci�n';
    SourceTable = 7207331;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Milestone No."; rec."Milestone No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Customer Code"; rec."Customer Code")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Estimated Date"; rec."Estimated Date")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Amount"; rec."Amount")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                }
                field("Draft Invoice No."; rec."Draft Invoice No.")
                {

                }
                field("Posted Invoice No."; rec."Posted Invoice No.")
                {

                }
                field("Completion Date"; rec."Completion Date")
                {

                }
                field("Comments"; rec."Comments")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = '&Imprimir';
                Image = Print;

                trigger OnAction()
                BEGIN
                    Job.RESET;
                    Job.SETRANGE("No.", rec."Job No.");
                    //report --> 7000125
                    // REPORT.RUNMODAL(REPORT::"Overdue Milestones Proj List", TRUE, FALSE, Job);
                END;


            }
            action("InvoicingMilestone")
            {

                Ellipsis = true;
                CaptionML = ESP = 'Facturar Hito';
                Image = Invoice;


                trigger OnAction()
                BEGIN
                    // CLEAR(GenInvoiceMilestone);
                    InvoiceMilestone.RESET;
                    InvoiceMilestone.SETRANGE("Job No.", Rec."Job No.");
                    InvoiceMilestone.SETRANGE("Milestone No.", Rec."Milestone No.");
                    InvoiceMilestone.SETRANGE("Completion Date", Rec."Completion Date");
                    // GenInvoiceMilestone.SETTABLEVIEW(InvoiceMilestone);
                    // GenInvoiceMilestone.SetSalesHeader(SalesHeader, FALSE);
                    // GenInvoiceMilestone.RUNMODAL;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(InvoicingMilestone_Promoted; InvoicingMilestone)
                {
                }
            }
        }
    }

    var
        Job: Record 167;
        // GenInvoiceMilestone: Report 7207287;
        InvoiceMilestone: Record 7207331;
        SalesHeader: Record 36;

    LOCAL procedure OnDeactivateComments();
    begin

        Rec.CALCFIELDS(Comments);
    end;

    LOCAL procedure OnActivateComments();
    begin

        Rec.CALCFIELDS(Comments);
    end;

    // begin//end
}








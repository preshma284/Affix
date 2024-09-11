page 7207636 "Unit Cost Equipament"
{
    CaptionML = ENU = 'Unit Cost Equipament', ESP = 'Coste unitario maquinaria';
    SourceTable = 7207439;
    SourceTableView = SORTING("Job No.", "Type", "No.")
                    WHERE("Type" = CONST("Machine"));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("FORMAT(txtJobDescription)"; FORMAT(txtJobDescription))
            {

                CaptionClass = FORMAT(txtJobDescription);
                Editable = FALSE;
                Style = Standard;
                StyleExpr = TRUE;
            }
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                }
                field("Potency (HP)"; rec."Potency (HP)")
                {

                }
                field("Current Cost"; rec."Current Cost")
                {

                }
                field("Equipament Coefficient"; rec."Equipament Coefficient")
                {

                }
                field("Updated Cost"; rec."Updated Cost")
                {

                }
                field("Residual Value"; rec."Residual Value")
                {

                }
                field("Useful Life in Hours"; rec."Useful Life in Hours")
                {

                }
                field("Annual Use in Hours"; rec."Annual Use in Hours")
                {

                }
                field("Amortization Time"; rec."Amortization Time")
                {

                }
                field("Interests Hours"; rec."Interests Hours")
                {

                }
                field("Sum Hours"; rec."Sum Hours")
                {

                }
                field("Repairs and Spare Parts Hours"; rec."Repairs and Spare Parts Hours")
                {

                }
                field("Combustible Type"; rec."Combustible Type")
                {

                }
                field("Unitary Price Litres"; rec."Unitary Price Litres")
                {

                }
                field("Consumed Litres x HP"; rec."Consumed Litres x HP")
                {

                }
                field("Consumed Cost"; rec."Consumed Cost")
                {

                }
                field("Grease Hour"; rec."Grease Hour")
                {

                }
                field("Q. Combustible and Grease H."; rec."Q. Combustible and Grease H.")
                {

                }
                field("Total Cost"; rec."Total Cost")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Contract Price"; rec."Contract Price")
                {

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
                CaptionML = ENU = 'Utilities', ESP = 'Utilidades';
                action("action1")
                {
                    CaptionML = ENU = 'Select Machines', ESP = 'Seleccionar m�quinas';
                    Image = Resource;

                    trigger OnAction()
                    VAR
                        Resource: Record 156;
                        ResourceList: Page 77;
                        UnitaryCostByJob: Record 7207439;
                    BEGIN
                        ResourceList.LOOKUPMODE(TRUE);
                        Resource.SETRANGE(Type, Resource.Type::Machine);
                        ResourceList.SETTABLEVIEW(Resource);
                        IF ResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            ResourceList.SetSelection(Resource);
                            IF Resource.FINDSET THEN
                                REPEAT
                                    CLEAR(UnitaryCostByJob."Job No.");
                                    UnitaryCostByJob."Job No." := rec."Job No.";
                                    UnitaryCostByJob.Type := UnitaryCostByJob.Type::Machine;
                                    UnitaryCostByJob.VALIDATE("No.", Resource."No.");
                                    IF UnitaryCostByJob.INSERT THEN;
                                UNTIL Resource.NEXT = 0;
                        END;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Recalculate Offer', ESP = 'Recalcular Oferta';
                    Image = CalculateCost;


                    trigger OnAction()
                    VAR
                        ValidateCotractPrice: Codeunit 7207342;
                        Job: Record 167;
                    BEGIN
                        CLEAR(ValidateCotractPrice);
                        Job.GET(rec."Job No.");
                        ValidateCotractPrice.RUN(Job);
                    END;


                }

            }

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
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        txtJobDescription := '';
        IF Rec.GETFILTER("Job No.") <> '' THEN
            txtJobDescription := FunctionQB.ShowDescriptionJob(Rec.GETFILTER("Job No.")) + ' - ' + Text000;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.Type := rec.Type::Machine;
    END;



    var
        FunctionQB: Codeunit 7207272;
        txtJobDescription: Text[250];
        Text000: TextConst ESP = 'MAQUINARIA';

    /*begin
    end.
  
*/
}








page 7207635 "Unit Cost Piecework"
{
    CaptionML = ENU = 'Unit Cost Piecework', ESP = 'Coste unitario mano de obra';
    SourceTable = 7207439;
    SourceTableView = SORTING("Job No.", "Type", "No.")
                    WHERE("Type" = CONST("Resource"));
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
                field("Base Salary"; rec."Base Salary")
                {

                }
                field("% Social Charges"; rec."% Social Charges")
                {

                }
                field("Social Charges"; rec."Social Charges")
                {

                }
                field("Basic Cost"; rec."Basic Cost")
                {

                }
                field("% Other 1"; rec."% Other 1")
                {

                }
                field("Other 1"; rec."Other 1")
                {

                }
                field("% Other 2"; rec."% Other 2")
                {

                }
                field("Other 2"; rec."Other 2")
                {

                }
                field("Direct Cost"; rec."Direct Cost")
                {

                }
                field("Set Sum"; rec."Set Sum")
                {

                }
                field("Cost per Hour"; rec."Cost per Hour")
                {

                }
                field("Total Cost"; rec."Total Cost")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Work Hours"; rec."Work Hours")
                {

                }
                field("Cost per Day"; rec."Cost per Day")
                {

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
                    CaptionML = ENU = 'Select Resources', ESP = 'Seleccionar recursos';
                    Image = ServiceMan;

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
                                    UnitaryCostByJob.Type := UnitaryCostByJob.Type::Resource;
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
        rec.Type := rec.Type::Resource;
    END;



    var
        FunctionQB: Codeunit 7207272;
        txtJobDescription: Text[250];
        Text000: TextConst ESP = 'MANO DE OBRA';

    /*begin
    end.
  
*/
}








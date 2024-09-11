page 7207634 "Materials Unit Cost"
{
    CaptionML = ENU = '"Materials Unit Cost "', ESP = 'Coste unitario materiales';
    SourceTable = 7207439;
    SourceTableView = SORTING("Job No.", "Type", "No.")
                    WHERE("Type" = CONST("Item"));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("FORMAT (txtJobDescription)"; FORMAT(txtJobDescription))
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
                field("Unit Cost"; rec."Unit Cost")
                {

                }
                field("Coefficient"; rec."Coefficient")
                {

                }
                field("Adjusted Unit Cost"; rec."Adjusted Unit Cost")
                {

                }
                field("Transport Km"; rec."Transport Km")
                {

                }
                field("Transport Unit Cost"; rec."Transport Unit Cost")
                {

                }
                field("Transport Cost"; rec."Transport Cost")
                {

                }
                field("% M y A"; rec."% M y A")
                {

                }
                field("Cost M y A"; rec."Cost M y A")
                {

                }
                field("% Lost"; rec."% Lost")
                {

                }
                field("Lost Cost"; rec."Lost Cost")
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
                    CaptionML = ENU = 'Select Products', ESP = 'Seleccionar productos';
                    Image = Item;

                    trigger OnAction()
                    VAR
                        Item: Record 27;
                        ItemList: Page 31;
                        UnitaryCostByJob: Record 7207439;
                    BEGIN
                        ItemList.LOOKUPMODE(TRUE);
                        IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            ItemList.SetSelection(Item);
                            IF Item.FINDSET THEN
                                REPEAT
                                    CLEAR(UnitaryCostByJob."Job No.");
                                    UnitaryCostByJob."Job No." := rec."Job No.";
                                    UnitaryCostByJob.Type := UnitaryCostByJob.Type::Item;
                                    UnitaryCostByJob.VALIDATE("No.", Item."No.");
                                    IF UnitaryCostByJob.INSERT THEN;
                                UNTIL Item.NEXT = 0;
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
        rec.Type := rec.Type::Item;
    END;



    var
        FunctionQB: Codeunit 7207272;
        txtJobDescription: Text[250];
        Text000: TextConst ESP = 'MATERIALES';

    /*begin
    end.
  
*/
}








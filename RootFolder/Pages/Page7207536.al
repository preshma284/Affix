page 7207536 "Unit Cost Accrued List"
{
    CaptionML = ENU = 'Unit Cost Accrued List', ESP = 'Lista periodif. unid. cte.';
    SourceTable = 7207432;
    DelayedInsert = true;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Unit Cost"; rec."Unit Cost")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Date"; rec."Date")
                {

                }
                field("Amount"; rec."Amount")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Period Amount"; rec."Period Amount")
                {

                }

            }
            group("group9")
            {

                Editable = False;
                group("group10")
                {

                    group("group11")
                    {

                        CaptionML = ENU = 'Description Piecework', ESP = 'Descripci�n unidad de obra';
                        field("VDescription"; "VDescription")
                        {

                            Style = Strong;
                            StyleExpr = TRUE;
                        }

                    }
                    group("group13")
                    {

                        CaptionML = ENU = 'Accrued Amount', ESP = 'Importe periodificado';
                        field("VAmountAccrued"; "VAmountAccrued")
                        {

                            Style = Strong;
                            StyleExpr = TRUE;
                        }

                    }
                    group("group15")
                    {

                        CaptionML = ENU = 'Amount Pending Accrued', ESP = 'Importe pdte. periodifcar';
                        field("AmountBudgetAccrued"; rec."AmountBudgetAccrued")
                        {

                            Style = Strong;
                            StyleExpr = TRUE

  ;
                        }

                    }

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
                CaptionML = ENU = 'Generate Accrued', ESP = 'Generar periodificaci�n';
                Image = Track;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }
    trigger OnClosePage()
    BEGIN
        IF rec."Accrued Amount" < rec.AmountBudgetAccrued THEN
            MESSAGE(Text000);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        xRec := Rec;
        Piecework.RESET;
        IF Piecework.GET(rec."Unit Cost") THEN
            VDescription := Piecework.Description;

        Rec.CALCFIELDS("Accrued Amount");
        VAmountAccrued := rec."Accrued Amount";
    END;



    var
        Text000: TextConst ENU = 'You still have outstanding amounts to accrue', ESP = 'Todav�a le queda importe pendiente a periodificar';
        Piecework: Record 7207277;
        VDescription: Text[30];
        VAmountAccrued: Decimal;

    /*begin
    end.
  
*/
}








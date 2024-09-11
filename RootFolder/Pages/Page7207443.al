page 7207443 "Element Entry Registry"
{
    Editable = false;
    CaptionML = ENU = 'Element Entry Registry', ESP = 'Reg. mov. elemento';
    SourceTable = 7207352;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Transaction No."; rec."Transaction No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Creation Date"; rec."Creation Date")
                {

                    Visible = False;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Period Trans. No."; rec."Period Trans. No.")
                {

                }
                field("User ID"; rec."User ID")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("From Entry No."; rec."From Entry No.")
                {

                }
                field("To Entry No."; rec."To Entry No.")
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
                CaptionML = ENU = '&Register', ESP = '&Movs.';
                action("action1")
                {
                    CaptionML = ENU = '&Maestra movs', ESP = '&Movs. Elemento';
                    RunObject = Codeunit 7207322;
                    Image = ResourceLedger;
                }

            }

        }
        area(Processing)
        {

            group("group5")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("action2")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Reverse Register', ESP = 'Revertir mov.';
                    Visible = False;
                    Image = ReverseRegister;

                    trigger OnAction()
                    BEGIN
                        Rec.TESTFIELD("Transaction No.");
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Set Period Transaction No.', ESP = 'Asignar n� asiento';
                    // RunObject = Report 7207336;
                    Image = ResourceRegisters
    ;
                }

            }

        }
    }


    /*begin
    end.
  
*/
}








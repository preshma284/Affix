page 7207613 "Posted Recp. Job Subform"
{
    CaptionML = ENU = 'Posted Recp. Job Subform', ESP = 'Hist. recp. job subform';
    MultipleNewLines = true;
    InsertAllowed = false;
    SourceTable = 7207411;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Document No."; rec."Document No.")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Type"; rec."Type")
                {

                    Editable = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Expected Receipt Date"; rec."Expected Receipt Date")
                {

                    Editable = False;
                }
                field("Piecework No."; rec."Piecework No.")
                {

                    Editable = False;
                }
                field("Description"; rec."Description")
                {

                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                    Editable = False;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {

                }
                field("Status"; rec."Status")
                {

                }
                field("Unit Cost"; rec."Unit Cost")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                    Editable = False;
                }
                field("Quantity Received"; rec."Quantity Received")
                {

                }
                field("Outstanding Quantity"; rec."Outstanding Quantity")
                {

                    Visible = False;
                }
                field("Qty. to Receive"; rec."Qty. to Receive")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    CaptionML = ENU = 'Source &Document Line', ESP = 'Lin. documento ori&gen';
                    Image = SourceDocLine;

                    trigger OnAction()
                    BEGIN
                        ShowSourceLine;
                    END;


                }
                group("group4")
                {
                    CaptionML = ENU = 'Item Availability by', ESP = 'Disponibilidad prod. por';
                    Visible = False;
                    action("action2")
                    {
                        CaptionML = ENU = 'Period', ESP = 'Periodo';

                        trigger OnAction()
                        BEGIN
                            _ItemAvailability(0);
                        END;


                    }
                    action("action3")
                    {
                        CaptionML = ENU = 'Variant', ESP = 'Variante';

                        trigger OnAction()
                        BEGIN
                            _ItemAvailability(1);
                        END;


                    }
                    action("action4")
                    {
                        CaptionML = ENU = 'Location', ESP = 'Almac�n';

                        trigger OnAction()
                        BEGIN
                            _ItemAvailability(2);
                        END;


                    }

                }
                action("action5")
                {
                    CaptionML = ENU = 'Item &Tracking Lines', ESP = 'Lins. &seguim. prod.';
                    Visible = False;
                    Image = ItemTrackingLines
    ;
                }

            }

        }
    }


    procedure ShowSourceLine();
    var
        WMSMgt: Codeunit 7302;
        PurchaseHeader: Record 38;
    begin
        PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, rec."Document No.");
        PAGE.RUN(PAGE::"Purchase Order", PurchaseHeader);
    end;

    procedure _ItemAvailability(AvailabilityType: Option "Date","Variant","Location");
    begin
        Rec.ItemAvailability(AvailabilityType);
    end;

    // begin//end
}








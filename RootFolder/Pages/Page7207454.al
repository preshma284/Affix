page 7207454 "Pos. Element Contract Header"
{
    CaptionML = ENU = 'Pos. Element Contract Header', ESP = 'Hist. cab. contrato elemento';
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207373;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Editable = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Contract Type"; rec."Contract Type")
                {

                    Editable = False;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
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
                field("Job No."; rec."Job No.")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Posting Description"; rec."Posting Description")
                {

                    Editable = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Vendor Contract Code"; rec."Vendor Contract Code")
                {

                    Editable = False;
                }
                field("Contract Date"; rec."Contract Date")
                {

                    Editable = False;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    Editable = False;
                }
                field("Document State"; rec."Document State")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }

            }
            part("LinDoc"; 7207456)
            {

                CaptionML = ENU = 'LinDoc', ESP = 'LinDoc';
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group28")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    Editable = False;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    Editable = False;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    Editable = False;
                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }
                field("Archive by"; rec."Archive by")
                {

                    Editable = False;
                }
                field("Date Archived"; rec."Date Archived")
                {

                    Editable = False;
                }
                field("Time Archived"; rec."Time Archived")
                {

                    Editable = False

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
                CaptionML = ENU = '&Document', ESP = '&Contrato';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 22;
                    RunPageLink = "No." = FIELD("Customer/Vendor No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Entries', ESP = 'Movimientos';
                    RunObject = Page 7207452;
                    RunPageView = SORTING("Customer No.", "Job No.", "Contract No.", "Posting Date", "Pending");
                    RunPageLink = "Contract No." = FIELD("No.");
                    Image = ResourceLedger;
                }
                action("action3")
                {
                    CaptionML = ENU = 'C&omments', ESP = 'C&omentarios';
                    RunObject = Page 7207439;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }
                separator("separator5")
                {

                }
                action("action6")
                {
                    CaptionML = ENU = 'Posted Deliveries', ESP = 'Hist�rico entregas';
                    RunObject = Page 7207461;
                    RunPageView = WHERE("Document Type" = CONST("Delivery"));
                    RunPageLink = "Contract Code" = FIELD("No.");
                    Image = Shipment;
                }
                separator("separator7")
                {

                }
                action("action8")
                {
                    CaptionML = ENU = 'Posted Returns', ESP = 'Hist�rico devoluciones';
                    RunObject = Page 7207429;
                    RunPageView = SORTING("No.")
                                  WHERE("Document Type" = CONST("Return"));
                    RunPageLink = "Contract Code" = FIELD("No.");
                    Image = Return;
                }
                separator("separator9")
                {

                }
                action("action10")
                {
                    CaptionML = ENU = 'Pending Return', ESP = 'Pendientes de devo';
                    RunObject = Page 7207452;
                    RunPageView = SORTING("Customer No.", "Job No.", "Contract No.", "Posting Date", "Pending")
                                  WHERE("Pending" = CONST(true), "Entry Type" = CONST("Delivery"));
                    RunPageLink = "Contract No." = FIELD("No.");
                    Image = CopyFromTask;
                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;




    /*begin
    end.
  
*/
}








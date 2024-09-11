page 7207415 "Hist. Head. Return Elem"
{
    Editable = false;
    CaptionML = ENU = 'Hist. Head. Return Elem', ESP = 'Hist. Cab devoluci�n elem';
    InsertAllowed = false;
    SourceTable = 7207359;
    SourceTableView = SORTING("No.")
                    WHERE("Document Type" = CONST("Return"));
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
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Contract Type"; rec."Contract Type")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Contract Code"; rec."Contract Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Document Type"; rec."Document Type")
                {

                }
                field("Rent Effective Date"; rec."Rent Effective Date")
                {

                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Date Filter"; rec."Date Filter")
                {

                }

            }
            part("HistLinDoc"; 7207430)
            {

                CaptionML = ENU = 'HistLinDoc', ESP = 'HistLinDoc';
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group24")
            {

                CaptionML = ENU = 'Entry', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207459)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }
            systempart(Links; Links)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Return', ESP = '&Devoluci�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207427;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207432;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }

        }
        area(Processing)
        {

            action("action4")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = '&Imprimir';
                Image = Print;

                trigger OnAction()
                VAR
                    HistHeadDelivRetElement: Record 7207359;
                BEGIN
                    CurrPage.SETSELECTIONFILTER(HistHeadDelivRetElement);
                    HistHeadDelivRetElement.PrintRecords(TRUE);
                END;


            }
            action("action5")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;


                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }



    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(0);
        Rec.SETRANGE("Document Type", rec."Document Type"::Return);
        Rec.FILTERGROUP(2);
    END;




    /*begin
    end.
  
*/
}








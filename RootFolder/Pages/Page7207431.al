page 7207431 "Hist. Head Delivery Elem"
{
    Editable = false;
    CaptionML = ENU = 'Hist. Head Delivery Elem', ESP = 'Hist. Cab entrega elem';
    InsertAllowed = false;
    SourceTable = 7207359;
    SourceTableView = WHERE("Document Type" = CONST("Delivery"));
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group11")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Editable = False;
                }
                field("Contract Type"; rec."Contract Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Contract Code"; rec."Contract Code")
                {

                    Style = StandardAccent;
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

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Rent Effective Date"; rec."Rent Effective Date")
                {

                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Date Filter"; rec."Date Filter")
                {

                }
                part("HistLinDoc"; 7207430)
                {

                    CaptionML = ENU = 'HistLinDoc', ESP = 'HistLinDoc';
                    SubPageLink = "Document No." = FIELD("No.");
                }
                group("group25")
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

        }
        area(FactBoxes)
        {
            part("part2"; 7207459)
            {
                SubPageLink = "Contract Code" = FIELD("Contract Code"), "No." = FIELD("No.");
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
                CaptionML = ENU = '&Delivery', ESP = '&Entrega';
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
                action("action4")
                {
                    CaptionML = ENU = 'Pending Return', ESP = 'Pendientes de devoluci�n';
                    RunObject = Page 7207452;
                    RunPageView = SORTING("Document No.", "Posting Date", "Pending")
                                  WHERE("Pending" = CONST(true));
                    RunPageLink = "Document No." = FIELD("No.");
                    Image = CopyFromTask;
                }

            }

        }
        area(Processing)
        {

            action("action5")
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
            action("action6")
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
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }



    trigger OnClosePage()
    BEGIN
        Rec.FILTERGROUP(0);
        Rec.SETRANGE("Document Type", rec."Document Type"::Delivery);
        Rec.FILTERGROUP(2);
    END;




    /*begin
    end.
  
*/
}








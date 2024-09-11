page 7207316 "Posted Output Shipment Header"
{
    Editable = false;
    CaptionML = ENU = 'Posted Warehouse Shipment Header', ESP = 'Hist. Cabecera albaran Almac�n';
    InsertAllowed = false;
    SourceTable = 7207310;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'Generla', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Request Filter"; rec."Request Filter")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Posting Description"; rec."Posting Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Stock Regulation"; rec."Stock Regulation")
                {

                    Editable = False;
                }
                field("Automatic Shipment"; rec."Automatic Shipment")
                {

                }
                field("Purchase Rcpt. No."; rec."Purchase Rcpt. No.")
                {

                }

            }
            part("LinDoc"; 7207317)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group21")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207496)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
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
                CaptionML = ENU = '&Document', ESP = '&Documento';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207320;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Receipt Hist."), "No." = FIELD("No.");
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
                BEGIN
                    PostedOutputShipmentHeader.RESET;
                    PostedOutputShipmentHeader.SETRANGE("No.", rec."No.");
                    // REPORT.RUNMODAL(REPORT::"Posted Output Shipment Header", TRUE, FALSE, PostedOutputShipmentHeader);
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
        rec.FilterResponsability(Rec);
        FunctionQB.SetUserJobPostedOutputShipmentHeaderFilter(Rec);
    END;



    var
        PostedOutputShipmentHeader: Record 7207310;
        FunctionQB: Codeunit 7207272;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
    end;

    // begin//end
}








page 7207529 "Header Regularization Stock"
{
    CaptionML = ENU = 'Header Regularization Stock', ESP = 'Cab. regularizaci�n stock';
    SourceTable = 7207408;
    PageType = Document;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Location Code"; rec."Location Code")
                {

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
                field("Regularization Date"; rec."Regularization Date")
                {

                }

            }
            part("LinDoc"; 7207531)
            {

                SubPageView = SORTING("Document No.", "Line No.");
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group22")
            {

                CaptionML = ENU = 'Record', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207628)
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
                CaptionML = ENU = 'Location', ESP = '&Almac�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Statistics Regularization Stoc", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 15;
                    RunPageView = SORTING("Code");
                    RunPageLink = "Code" = FIELD("Location Code");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Regular"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }

            }
            group("group7")
            {
                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("action5")
                {
                    CaptionML = ENU = 'Bring Item', ESP = 'Traer productos';
                    Image = GetOrder;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(BringItemforAdjustment);
                        LineRegularizationStock.RESET;
                        LineRegularizationStock.SETRANGE("Document No.", rec."No.");
                        // BringItemforAdjustment.SETTABLEVIEW(LineRegularizationStock);
                        // BringItemforAdjustment.RUNMODAL;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group10")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action6")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207325;
                    Image = Post;
                }
                action("action7")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por &lotes';
                    Image = PostBatch;


                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Output Shipment Batrch Records", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action6_Promoted; action6)
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
    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        IF Rec.FIND(Which) THEN
            EXIT(TRUE)
        ELSE BEGIN
            Rec.SETRANGE("No.");
            EXIT(Rec.FIND(Which));
        END;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
    END;



    var
        // BringItemforAdjustment: Report 7207341;
        LineRegularizationStock: Record 7207409;

    /*begin
    end.
  
*/
}








page 7207435 "Element Delivery Header"
{
    CaptionML = ENU = 'Element Delivery Header', ESP = 'Cabecer entrega elemento';
    SaveValues = true;
    SourceTable = 7207356;
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

                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Contract Type"; rec."Contract Type")
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
                field("Contract Code"; rec."Contract Code")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
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
                field("Order Date"; rec."Order Date")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Rent Effective Date"; rec."Rent Effective Date")
                {

                }

            }
            part("LinDoc"; 7207434)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group28")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
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
                field("Weight to Handle"; rec."Weight to Handle")
                {

                }
                field("Posting No. Series"; rec."Posting No. Series")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207460)
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
                CaptionML = ENU = 'D&elivery', ESP = '&Entrega';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    BEGIN
                        //Tomamos la configuraci�n del area funcional del documento.
                        PAGE.RUNMODAL(PAGE::"Statistics Delivery/Return Ele", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207437;
                    RunPageLink = "No." = FIELD("Contract Code");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207432;
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
                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }
                separator("separator5")
                {

                }
                action("action6")
                {
                    CaptionML = ENU = 'Historical Documents Sent', ESP = 'Hist�rico documentaci�n env�o';
                    RunObject = Page 7207461;
                    //to be refactored
                    RunPageLink = "Contract Code" = FIELD("Contract Code"); //,"Dimensions Set ID" = FIELD("No.");
                    Image = Shipment;
                }

            }

        }
        area(Processing)
        {

            group("group10")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action7")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207313;
                    Image = Post;
                }
                action("action8")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por &lotes';
                    Image = PostBatch;


                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Batch Post Delivery/Return Ele", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action7_Promoted; action7)
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
        Rec.SETRANGE("Document Type", rec."Document Type"::Delivery);
    END;

    trigger OnNextRecord(Steps: Integer): Integer
    BEGIN
        rec."Document Type" := rec."Document Type"::Delivery;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;




    /*begin
    end.
  
*/
}








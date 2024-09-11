page 7207426 "Element Return Header"
{
    CaptionML = ENU = 'Element Return Header', ESP = 'Cabecera devoluci�n elemento';
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

                }
                field("Document Type"; rec."Document Type")
                {

                    Editable = False;
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
            part("LinDoc"; 7207425)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group30")
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
                CaptionML = ENU = '&Return', ESP = '&Devoluci�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    BEGIN
                        //Tomamos la configuraci�n del area funcional del documento.
                        //PurchSetup.GET;
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
                    END;


                }
                separator("separator5")
                {

                }
                action("action6")
                {
                    CaptionML = ENU = 'Historic Document Shipment', ESP = 'Hist�rico document';
                    RunObject = Page 7207461;
                    RunPageLink = "Contract Code" = FIELD("Contract Code"), "Source Document" = FIELD("No.");
                    Image = Shipment;
                }

            }

        }
        area(Creation)
        {

            group("group10")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Acciones';
                action("action7")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Test Report', ESP = 'Traer elementos';
                    Image = CalculateSalesTax;

                    trigger OnAction()
                    BEGIN
                        RentalElementsEntries.SETRANGE(RentalElementsEntries."Contract No.", rec."Contract Code");
                        RentalElementsEntries.SETRANGE(RentalElementsEntries."Entry Type", RentalElementsEntries."Entry Type"::Delivery);
                        RentalElementsEntriesList.LOOKUPMODE(TRUE);
                        RentalElementsEntriesList.ReceivesReturn(rec."No.");
                        RentalElementsEntriesList.SETTABLEVIEW(RentalElementsEntries);
                        RentalElementsEntriesList.RUNMODAL;
                        CLEAR(RentalElementsEntriesList);
                    END;


                }

            }
            group("group12")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action8")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&osting', ESP = 'Registrar';
                    RunObject = Codeunit 7207313;
                    Image = Post;
                }
                action("action9")
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
                actionref(action8_Promoted; action8)
                {
                }
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
        Rec.SETRANGE("Document Type", rec."Document Type"::Return);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Document Type" := rec."Document Type"::Return;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;



    var
        RentalElementsEntries: Record 7207345;
        RentalElementsEntriesList: Page 7207452;

    /*begin
    end.
  
*/
}








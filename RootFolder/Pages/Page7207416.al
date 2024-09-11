page 7207416 "Usage Header"
{
    CaptionML = ENU = 'Usage Header', ESP = 'Cabecera utilizaci�n';
    SourceTable = 7207362;
    PageType = Document;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {

                }
                field("Contract Type"; rec."Contract Type")
                {

                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Contract Code"; rec."Contract Code")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                }
                field("Vendor Contract Code"; rec."Vendor Contract Code")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Usage Date"; rec."Usage Date")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("[ Usage Statistics Header FB]"; 7207457)
            {

                // Name =[ Usage Statistics Header FB];
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
                CaptionML = ENU = 'Usage Doc.', ESP = 'Doc.Utilizaci�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    BEGIN
                        //Tomamos la configuraci�n del area funcional del documento.
                        PAGE.RUNMODAL(PAGE::"Usage Header Statistic", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207436;
                    RunPageLink = "No." = FIELD("Contract Code");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 7207419;
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

            }

        }
        area(Processing)
        {

            group("group8")
            {
                CaptionML = ENU = 'Functions', ESP = 'Acciones';
                action("action5")
                {
                    CaptionML = ENU = 'Calculate Inv. and Pmt. Discounts', ESP = 'Proponer utilizaci�n';
                    Image = NewResource;

                    trigger OnAction()
                    BEGIN
                        ProposeUsage;
                    END;


                }

            }
            group("group10")
            {
                CaptionML = ENU = 'Posting', ESP = 'Registro';
                action("action6")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'Post', ESP = 'Registrar';
                    RunObject = Codeunit 7207310;
                    Image = Post;
                }
                action("action7")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post Batch', ESP = 'Registrar por lotes';
                    Image = PostBatch;


                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Batch records of usage", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action5_Promoted; action5)
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

    var
        PurchasesPayablesSetup: Record 312;
        REPMoveNegativePurchaseLines: Report 6698;
        REPCopyPurchaseDocument: Report 492;
        CUTestReportPrint: Codeunit 228;
        CUUserSetupManagement: Codeunit 5700;
        // REPGenerateUsageDoc: Report 7207333;
        ElementContractHeader: Record 7207353;

    procedure ProposeUsage();
    begin
        // REPGenerateUsageDoc.ReceivesUsageHeader(Rec);
        ElementContractHeader.SETRANGE(ElementContractHeader."No.", rec."Contract Code");
        // if ElementContractHeader.FIND('-') then begin
        //     ElementContractHeader.SETRANGE("Contract Type", rec."Contract Type");
        //     REPGenerateUsageDoc.SETTABLEVIEW(ElementContractHeader);
        //     REPGenerateUsageDoc.USEREQUESTPAGE(FALSE);
        //     REPGenerateUsageDoc.RUN;
        //     CLEAR(REPGenerateUsageDoc);
        // end;
    end;

    // begin//end
}








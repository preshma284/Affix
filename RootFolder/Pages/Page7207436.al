page 7207436 "Element Contract Header"
{
    CaptionML = ENU = 'Element Contract Header', ESP = 'Cabecera contrato elemento';
    SourceTable = 7207353;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group27")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Contract Type"; rec."Contract Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
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
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Posting Description"; rec."Posting Description")
                {

                }
                field("Vendor Contract Code"; rec."Vendor Contract Code")
                {

                }
                field("Contract Date"; rec."Contract Date")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document Status"; rec."Document Status")
                {

                }

            }
            part("LinDoc"; 7207438)
            {
                ;
            }
            group("group40")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension1CodeOnAfterV;
                    END;


                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension2CodeOnAfterV;
                    END;


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
            part("part2"; 7207458)
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
                CaptionML = ENU = '&Document', ESP = '&Contrato';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"State Draft Contract Element", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 22;
                    RunPageLink = "No." = FIELD("Customer/Vendor No.");
                    Image = EditLines;
                }
                action("action3")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Entries', ESP = 'Movimientos';
                    RunObject = Page 7207452;
                    RunPageView = SORTING("Customer No.", "Job No.", "Contract No.", "Posting Date", "Pending");
                    RunPageLink = "Contract No." = FIELD("No.");
                    Image = JobLedger;
                }
                action("action4")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207439;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action5")
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
                separator("separator6")
                {

                }
                action("action7")
                {
                    CaptionML = ENU = 'Deliveries', ESP = 'Entregas';
                    RunObject = Page 7207433;
                    RunPageView = SORTING("Contract Code");
                    RunPageLink = "Contract Code" = FIELD("No."), "Customer/Vendor No." = FIELD("Customer/Vendor No."), "Job No." = FIELD("Job No.");
                    Image = SuggestLines;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Historical Deliveries', ESP = 'Hist�rico entregas';
                    RunObject = Page 7207461;
                    RunPageView = WHERE("Document Type" = CONST("Delivery"));
                    // to be refactored
                    // RunPageLink = "Contract Type" = FIELD("No.");
                    Image = Allocations;
                }
                separator("separator9")
                {

                }
                action("action10")
                {
                    CaptionML = ENU = 'Return', ESP = 'Devoluciones';
                    RunObject = Page 7207462;
                    RunPageView = SORTING("No.")
                                  WHERE("Document Type" = CONST("Return"));
                    RunPageLink = "Contract Code" = FIELD("No."), "Customer/Vendor No." = FIELD("Customer/Vendor No."), "Job No." = FIELD("Job No."), "Contract Type" = FIELD("Contract Type");
                    Image = CreateInteraction;
                }
                action("action11")
                {
                    CaptionML = ENU = 'Historical returns', ESP = 'Hist�rico devoluciones';
                    RunObject = Page 7207429;
                    RunPageView = SORTING("No.")
                                  WHERE("Document Type" = CONST("Return"));
                    RunPageLink = "Contract Code" = FIELD("No.");
                    Image = ReverseRegister;
                }
                separator("separator12")
                {

                }
                action("<Page Rental Elements Entries List2>")
                {

                    CaptionML = ENU = 'Return Pending', ESP = 'Pendientes de devoluci�n';
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

            group("group17")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("action14")
                {
                    CaptionML = ENU = 'Job Rent Suggest', ESP = 'Proponer alquiler proyecto';
                    Image = PaymentJournal;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(JobRentSuggest);
                        ElementContractHeader.SETRANGE("No.", rec."No.");
                        // JobRentSuggest.SETTABLEVIEW(ElementContractHeader);
                        // JobRentSuggest.RUNMODAL;
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                separator("separator15")
                {

                }
                action("action16")
                {
                    ShortCutKey = 'Ctrl+F9';
                    CaptionML = ENU = 'Re&lease', ESP = 'Lan&zar';
                    RunObject = Codeunit 7207311;
                    Image = ReleaseDoc;
                }
                action("action17")
                {
                    CaptionML = ENU = 'Re&open', ESP = '&Volver a abrir';
                    Image = ReOpen;

                    trigger OnAction()
                    BEGIN
                        ElementContractReleaseOpen.Reopen(Rec);
                    END;


                }
                action("ArchivarContrato")
                {

                    CaptionML = ENU = 'Contract File', ESP = 'Archivar contrato';
                    Image = DepreciationBooks;
                }
                separator("separator19")
                {

                }
                action("action20")
                {
                    CaptionML = ENU = 'Suggest and Post Delivery', ESP = '&Proponer y registrar entrega';
                    Image = SuggestReminderLines;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(GenerateShippingDocument);
                        ElementContractHeader.SETRANGE("No.", rec."No.");
                        // GenerateShippingDocument.SETTABLEVIEW(ElementContractHeader);

                        // GenerateShippingDocument.RUNMODAL;

                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action21")
                {
                    CaptionML = ENU = 'Suggest and Post Wthdrawal', ESP = '&Proponer y registrar retirada';
                    Image = SuggestReconciliationLines;


                    trigger OnAction()
                    BEGIN
                        // CLEAR(GenerateDocumentRetreat);
                        ElementContractHeader.SETRANGE("No.", rec."No.");
                        // GenerateDocumentRetreat.SETTABLEVIEW(ElementContractHeader);

                        // GenerateDocumentRetreat.RUNMODAL;

                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action16_Promoted; action16)
                {
                }
                actionref(action17_Promoted; action17)
                {
                }
                actionref("<Page Rental Elements Entries List2>_Promoted"; "<Page Rental Elements Entries List2>")
                {
                }
                actionref(ArchivarContrato_Promoted; ArchivarContrato)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action11_Promoted; action11)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action20_Promoted; action20)
                {
                }
                actionref(action21_Promoted; action21)
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
        EXIT(ElementContractHeader.ConfirmDeletion);
    END;



    var
        ElementContractHeader: Record 7207353;
        // JobRentSuggest: Report 7207337;
        ElementContractReleaseOpen: Codeunit 7207311;
        ArchiveManagement: Codeunit 5063;
        // GenerateShippingDocument: Report 7207335;
        // GenerateDocumentRetreat: Report 7207338;

    LOCAL procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    // begin//end
}








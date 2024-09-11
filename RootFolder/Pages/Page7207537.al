page 7207537 "Costsheet"
{
    CaptionML = ENU = 'Costsheet', ESP = 'Parte Costes';
    SourceTable = 7207433;
    SourceTableView = SORTING("No.");
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

                    CaptionML = ENU = 'No.', ESP = 'N�';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Validated Sheet"; rec."Validated Sheet")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Amount"; rec."Amount")
                {

                }

            }
            group("Registro")
            {

                CaptionML = ENU = 'Registration', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
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
                CaptionML = ENU = 'Parts', ESP = 'Partes';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Sheet"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
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

            group("group7")
            {
                CaptionML = ENU = 'Functions', ESP = 'Funciones';
                action("action4")
                {
                    CaptionML = ENU = 'Validate part', ESP = 'Validar parte';
                    Image = Approve;

                    trigger OnAction()
                    VAR
                        CostsheetLinesLoc: Record 7207434;
                    BEGIN
                        SheetValidate(rec."No.");
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Open Part', ESP = 'Abrir parte';
                    Image = ReOpen;

                    trigger OnAction()
                    BEGIN
                        IF rec."Validated Sheet" = TRUE THEN
                            Rec.VALIDATE("Validated Sheet", FALSE);
                        Rec.MODIFY;
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
                    RunObject = Codeunit 7207326;
                    Image = Post;
                }

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
                actionref(action6_Promoted; action6)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.ResponsabilityFilters(Rec);
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        IF Rec.FIND(Which) THEN
            EXIT(TRUE)
        ELSE BEGIN
            Rec.SETRANGE("No.");
            EXIT(Rec.FIND(Which));
        END;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
    BEGIN
        //"Responsability Center" := CUUserSetupManagement.GetJobFilter;

        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        rec."Responsability Center" := UserRespCenter;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;



    var
        text000: TextConst ENU = 'Nothing to accept', ESP = 'No hay nada que aceptar';
        PurchasesPayablesSetup: Record 312;
        MoveNegativePurchaseLines: Report 6698;
        CopyPurchaseDocument: Report 492;
        CUTestReportPrint: Codeunit 228;
        FunctionQB: Codeunit 7207272;
        CostsheetLines: Record 7207434;
        DataPieceworkForProduction: Record 7207386;
        DataPieceworkForProduction2: Record 7207386;
        CostsheetLines2: Record 7207434;
        CostsheetHeader: Record 7207433;
        Line_No_: Integer;

    LOCAL procedure SheetValidate(SheetCodeNo: Code[20]);
    var
        CostsheetHeaderAux: Record 7207433;
        CostsheetLinesAux: Record 7207434;
    begin
        CostsheetLinesAux.RESET;
        CostsheetLinesAux.SETRANGE("Document No.", SheetCodeNo);
        CostsheetLinesAux.SETFILTER(Amount, '<>%1', 0);
        if CostsheetLinesAux.FINDFIRST then begin
            Rec.GET(SheetCodeNo);
            Rec.VALIDATE("Validated Sheet", TRUE);
            Rec.MODIFY;
        end;
    end;

    // begin
    /*{
      JAV 01/06/22: - QB 1.10.46 Se a�ade el campo Amount con la suma de las l�neas
    }*///end
}








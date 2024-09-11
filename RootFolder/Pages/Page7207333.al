page 7207333 "Reestimation Header"
{
    CaptionML = ENU = 'Reestimation Header', ESP = 'Cabecera reestimaci�n';
    SourceTable = 7207315;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("<Control1>")
            {

                CaptionML = ENU = 'General';
                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Job No."; rec."Job No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        N186proyectoOnAfterValidate;
                    END;


                }
                field("Reestimation Code"; rec."Reestimation Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        C243dreestimaci243nOnAfterVali;
                    END;


                }
                field("Description"; rec."Description")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Reestimation Date"; rec."Reestimation Date")
                {

                }

            }
            part("LinDoc"; 7207335)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }

        }
        area(FactBoxes)
        {
            part("Reestimation statistics FB"; 7207493)
            {

                CaptionML = ENU = 'Reestimation statistics FB', ESP = 'Estadisticas reestimaci�n FB';
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
                CaptionML = ENU = '&Document', ESP = '&Reestimaci�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207347;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Reestimation"), "No." = FIELD("No.");
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

            }
            group("group7")
            {
                CaptionML = ENU = 'A&cciones', ESP = 'A&cciones';
                separator("separator5")
                {

                }
                action("action6")
                {
                    CaptionML = ENU = '&Planning milestones', ESP = 'Hitos &planificaci�n';
                    RunObject = Page 7207467;
                    RunPageLink = "Job No." = FIELD("Job No.");
                    Image = Planning;
                }
                action("action7")
                {
                    CaptionML = ENU = 'Plannig &costs by milestones', ESP = 'Planificaci�n &costes por hitos';
                    Image = Period;

                    trigger OnAction()
                    VAR
                        JobConceptPlan: Page 7207468;
                    BEGIN
                        CLEAR(JobConceptPlan);
                        JobConceptPlan.SetJob(rec."Job No.");
                        JobConceptPlan.RUNMODAL;
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'As&sign Planning', ESP = 'As&ignar Planificaci�n';
                    Image = ResourcePlanning;

                    trigger OnAction()
                    VAR
                        LocCduHP: Codeunit 7207273;
                    BEGIN
                        CLEAR(LocCduHP);
                        LocCduHP."PlannedRestimationMilestonesY/N"(Rec);
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group13")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action9")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207291;
                    Image = Post;
                }
                action("action10")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por &lotes';
                    Image = PostBatch;


                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Post By Reestimation Batch", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action9_Promoted; action9)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.ResponsibilityFilters(Rec);
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
    BEGIN

        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        rec."Responsibility Center" := UserRespCenter;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(FALSE);
    END;



    var
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[10];
        FunctionQB: Codeunit 7207272;

    LOCAL procedure N186proyectoOnAfterValidate();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure C243dreestimaci243nOnAfterVali();
    begin
        CurrPage.UPDATE;
    end;

    // begin//end
}








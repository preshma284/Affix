page 7207595 "QB Objectives Line Card"
{
    CaptionML = ENU = 'Line Objectives Card', ESP = 'Linea ficha de Objetivos';
    SourceTable = 7207404;
    DataCaptionFields = "Line Type";
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Record No."; rec."Record No.")
                {

                    Visible = seeIncome;
                    StyleExpr = txtStyle;
                }
                field("Line Type"; rec."Line Type")
                {

                    Visible = seeCost;
                    StyleExpr = txtStyle;
                }
                field("Piecework"; rec."Piecework")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("txtRecordType"; txtRecordType)
                {

                    CaptionML = ESP = 'Tipo Expediente';
                    Visible = seeIncome;
                    Editable = false;
                    StyleExpr = txtStyle;
                }
                field("Approved"; rec."Approved")
                {

                    StyleExpr = txtStyle;
                }
                field("Executed"; rec."Executed")
                {

                    StyleExpr = txtStyle;
                }
                field("Pending"; rec."Pending")
                {

                    StyleExpr = txtStyle;
                }
                field("Have Detailed Lines"; rec."Have Detailed Lines")
                {

                }
                field("Improvement"; rec."Improvement")
                {

                    Editable = edAmount;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Probability"; rec."Probability")
                {

                    Editable = edAmount;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("% Probability"; rec."% Probability")
                {

                }
                field("Improvement Amount"; rec."Improvement Amount")
                {

                }
                field("Objective"; rec."Objective")
                {

                    StyleExpr = txtStyle;
                }
                field("txtComment"; txtComment)
                {

                    CaptionML = ESP = 'Comentario';



                    ; trigger OnValidate()
                    BEGIN
                        rec.SetComment(txtComment);
                    END;


                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("SeeComment")
            {

                CaptionML = ESP = 'Comentario';
                RunObject = Page 7207596;
                RunPageView = SORTING("Job No.", "Budget Code", "Line Type", "Record No.", "Piecework");
                RunPageLink = "Job No." = FIELD("Job No."), "Budget Code" = FIELD("Budget Code"), "Line Type" = FIELD("Line Type"), "Record No." = FIELD("Record No."), "Piecework" = FIELD("Piecework");
                Promoted = true;
                PromotedIsBig = true;
                Image = Text;
            }
            action("SeeDetail")
            {

                CaptionML = ESP = 'Detalle';
                Promoted = true;
                Image = LineDescription;


                trigger OnAction()
                VAR
                    QBObjectivesLineDetailed: Record 7207405;
                    QBObjectivesLineCardDetail: Page 7207597;
                BEGIN
                    QBObjectivesLineDetailed.RESET;
                    QBObjectivesLineDetailed.SETRANGE("Job No.", rec."Job No.");
                    QBObjectivesLineDetailed.SETRANGE("Budget Code", rec."Budget Code");
                    QBObjectivesLineDetailed.SETRANGE("Line Type", rec."Line Type");
                    QBObjectivesLineDetailed.SETRANGE("Record No.", rec."Record No.");
                    QBObjectivesLineDetailed.SETRANGE(Piecework, rec.Piecework);

                    COMMIT; //Por el run modal
                    CLEAR(QBObjectivesLineCardDetail);
                    QBObjectivesLineCardDetail.SETTABLEVIEW(QBObjectivesLineDetailed);
                    QBObjectivesLineCardDetail.RUNMODAL;

                    Rec.CALCFIELDS("Have Detailed Lines");
                    IF (rec."Have Detailed Lines") THEN BEGIN
                        QBObjectivesLineDetailed.RESET;
                        QBObjectivesLineDetailed.SETRANGE("Job No.", rec."Job No.");
                        QBObjectivesLineDetailed.SETRANGE("Budget Code", rec."Budget Code");
                        QBObjectivesLineDetailed.SETRANGE("Line Type", rec."Line Type");
                        QBObjectivesLineDetailed.SETRANGE("Record No.", rec."Record No.");
                        QBObjectivesLineDetailed.SETRANGE(Piecework, rec.Piecework);
                        QBObjectivesLineDetailed.CALCSUMS("Improvement Amount");
                        Rec.VALIDATE(Improvement, QBObjectivesLineDetailed."Improvement Amount");
                        Rec.VALIDATE(Probability, rec.Probability::High);
                    END;
                END;


            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        SetPage;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Line Type" := CardType;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetPage;
    END;



    var
        LineCardAPM: Record 7207404;
        Records: Record 7207393;
        CardType: Option "I","C";
        txtStyle: Text;
        txtComment: Text;
        seeIncome: Boolean;
        seeCost: Boolean;
        txtCaption: Text;
        edAmount: Boolean;
        txtRecordType: Text;



    procedure SetType(pType: Option);
    begin
        CardType := pType;
        CASE CardType OF
            CardType::I:
                begin
                    seeIncome := TRUE;
                    txtCaption := 'Ingresos';
                end;
            CardType::C:
                begin
                    seeCost := TRUE;
                    txtCaption := 'Costes';
                end;
        end;

        CurrPage.CAPTION(txtCaption);
    end;

    LOCAL procedure SetPage();
    begin
        txtRecordType := '';
        if (rec.Piecework = '') and (Records.GET(rec."Job No.", rec."Record No.")) then
            txtRecordType := FORMAT(Records."Record Type") + ' - ' + FORMAT(Records."Record Status");

        txtStyle := '';
        if (rec.Piecework = '') then
            txtStyle := 'Strong';

        txtComment := rec.GetComment;

        Rec.CALCFIELDS("Have Detailed Lines");
        edAmount := (not rec."Have Detailed Lines");
    end;

    // begin//end
}








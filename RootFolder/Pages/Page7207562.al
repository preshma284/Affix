page 7207562 "Evaluation Header"
{
    CaptionML = ENU = 'Evaluation Header', ESP = 'Cab. evaluaci�n';
    SourceTable = 7207424;
    SourceTableView = SORTING("No.")
                    ORDER(Ascending);
    PageType = Document;

    layout
    {
        area(content)
        {
            group("General")
            {

                Editable = bEditable;
                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("Vendor Name"; rec."Vendor Name")
                {

                }
                field("Vendor County Code"; rec."Vendor County Code")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Evaluation Date"; rec."Evaluation Date")
                {

                }
                field("Validated"; rec."Validated")
                {

                }
                field("Comment"; rec."Comment")
                {

                }
                field("User ID."; rec."User ID.")
                {

                }
                field("Evaluation Score"; rec."Evaluation Score")
                {

                }
                field("Evaluation Clasification"; rec."Evaluation Clasification")
                {

                }
                field("Average Evaluation Score"; rec."Average Evaluation Score")
                {

                }
                field("Average Clasification"; rec."Average Clasification")
                {

                }

            }
            part("EvalLines"; 7207563)
            {

                SubPageView = SORTING("Evaluation No.", "Vendor No.", "Activity Code");
                SubPageLink = "Evaluation No." = FIELD("No.");
                Editable = bEditable;
                UpdatePropagation = Both

  ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("Evaluation")
            {

                CaptionML = ENU = 'Evaluation', ESP = 'Evaluaci�n';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'Co&mentarios';
                    Image = ViewComments;

                    trigger OnAction()
                    VAR
                        QBCommentLine: Record 7207270;
                        QuobuildingCommentWorkSheet: Page 7207273;
                    BEGIN
                        CLEAR(QuobuildingCommentWorkSheet);
                        QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::"Vendor Evaluation");
                        QBCommentLine.SETRANGE("No.", rec."No.");
                        QuobuildingCommentWorkSheet.SETTABLEVIEW(QBCommentLine);
                        QuobuildingCommentWorkSheet.RUNMODAL;
                        Rec.CALCFIELDS(Comment);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = '&Rec.VALIDATE', ESP = '&Validar';
                    Image = Approve;


                    trigger OnAction()
                    BEGIN
                        QualityManagement.ValidateEval(Rec);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        bEditable := TRUE;
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

    trigger OnAfterGetRecord()
    BEGIN
        bEditable := (NOT rec.Validated);
    END;



    var
        QualityManagement: Codeunit 7207293;
        bEditable: Boolean;/*

    begin
    {
      JAV 15/08/19: - Se mejoran las acciones de la p�gina y se a�ade el campo comentario
      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
      JAV 08/11/19: - Se cambia las llamadas a las funciones de calidad a su nueva CU
      JAV 26/11/19: - Se elimina el campo "Posting Date" que no se usa
    }
    end.*/


}








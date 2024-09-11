page 7207025 "QB Expenses Activation List"
{
  ApplicationArea=All;

    Permissions = TableData 17 = r,
                TableData 45 = r,
                TableData 169 = r;
    CaptionML = ENU = 'Expenses Activation List', ESP = 'Lista de Activaciones de Gastos';
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7206995;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = rec.Index;
                ShowAsTree = true;
                field("Period"; rec."Period")
                {

                    StyleExpr = stLine;
                }
                field("Job Code"; rec."Job Code")
                {

                    StyleExpr = stLine;
                }
                field("Piecework"; rec."Piecework")
                {

                    StyleExpr = stLine;
                }
                field("Index"; rec."Index")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Job Status Type"; rec."Job Status Type")
                {

                }
                field("Job Status Code"; rec."Job Status Code")
                {

                }
                field("Amount G6"; rec."Amount G6")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Amount G7"; rec."Amount G7")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Activation Amount"; rec."Activation Amount")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Total Management"; rec."Total Management")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Total Financial"; rec."Total Financial")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Total Managemen to Finan."; rec."Total Managemen to Finan.")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Total Management - Total Managemen to Finan."; rec."Total Management" - rec."Total Managemen to Finan.")
                {

                    CaptionML = ENU = 'Total Management', ESP = 'Total Gesti�n';
                    BlankZero = true;
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Total Financial + Total Managemen to Finan."; rec."Total Financial" + rec."Total Managemen to Finan.")
                {

                    CaptionML = ENU = 'Total Financials', ESP = 'Total Financiero';
                    BlankZero = true;
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Status"; rec."Status")
                {

                    StyleExpr = stLine

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Create")
            {

                CaptionML = ESP = 'Nuevo';
                Image = CreateMovement;

                trigger OnAction()
                BEGIN
                    QBExpensesActivation.actCreate(Rec);
                    CurrPage.UPDATE(FALSE);
                END;


            }
            action("Update")
            {

                CaptionML = ESP = 'Actualizar';
                Enabled = enActualizar;
                Image = UpdateShipment;

                trigger OnAction()
                BEGIN
                    QBExpensesActivation.actCalculate(Rec, TRUE);
                    CurrPage.UPDATE(FALSE);
                END;


            }
            action("Post")
            {

                CaptionML = ESP = 'Registrar';
                Enabled = enPost;
                Image = Post;

                trigger OnAction()
                BEGIN
                    QBExpensesActivation.actPost(Rec);
                END;


            }
            action("Navigate")
            {

                CaptionML = ESP = 'Navegar';
                Enabled = enNavigate;
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    QBExpensesActivation.actNavigate(Rec);
                END;


            }
            action("Delete")
            {

                CaptionML = ESP = 'Borrar';
                Enabled = enDelete;
                Image = DeleteExpiredComponents;


                trigger OnAction()
                BEGIN
                    QBExpensesActivation.actDelete(Rec);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Create_Promoted; Create)
                {
                }
                actionref(Update_Promoted; Update)
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref(Navigate_Promoted; Navigate)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    VAR
        QBExpensesActivation: Record 7206995;
    BEGIN
        QBExpensesActivation.GET(Rec.Period, '', '');

        enActualizar := (QBExpensesActivation.Status <> QBExpensesActivation.Status::Posted) AND (NOT Rec.ISEMPTY);
        enCalculate := (QBExpensesActivation.Status <> QBExpensesActivation.Status::Posted);
        enPost := (QBExpensesActivation.Status <> QBExpensesActivation.Status::Posted);
        enDelete := (QBExpensesActivation.Status = QBExpensesActivation.Status::Posted);
        enNavigate := (QBExpensesActivation.Status = QBExpensesActivation.Status::Posted);

        IF (Rec."Job Code" = '') THEN
            stLine := 'Strong'
        ELSE IF (Rec.Piecework = '') THEN
            stLine := 'StrongAccent'
        ELSE
            stLine := 'Ambiguous';
    END;



    var
        QBExpensesActivation: Codeunit 7206932;
        stLine: Text;
        enActualizar: Boolean;
        enCalculate: Boolean;
        enDelete: Boolean;
        enPost: Boolean;
        enNavigate: Boolean;/*

    begin
    {
      JAV 10/10/22: - QB 1.12.00 Nueva page para la lista de las activaciones, unifica las tres que se pensaron inicialmente
    }
    end.*/


}









page 7207522 "Post. Prod. Measurement List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = '"Post. Prod. Measurement" List', ESP = 'Lista hist. mediciones Prod.';
    SourceTable = 7207401;
    PageType = List;
    CardPageID = "Post. Prod. Measurement";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Measurement No."; rec."Measurement No.")
                {

                }
                field("Measurement Text"; rec."Measurement Text")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("DOC Import Previous"; rec."DOC Import Previous")
                {

                }
                field("DOC Import Term"; rec."DOC Import Term")
                {

                }
                field("DOC Import to Source"; rec."DOC Import to Source")
                {

                }
                field("Comment"; rec."Comment")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Last Measurement"; rec."Last Measurement")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207630)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
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
                CaptionML = ENU = '&Measurement', ESP = '&Medici�n';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Post. Prod. Measurement", Rec);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action3")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = '&Imprimir';
                Image = Print;

                trigger OnAction()
                VAR
                    QBReportSelections: Record 7206901;
                BEGIN
                    HistProdMeasureHeader.RESET;
                    HistProdMeasureHeader.SETRANGE("No.", rec."No.");
                    //JAV 03/10/19: - Se imprime usando el nuevo selector de informes
                    //REPORT.RUNMODAL(REPORT::"Production Measurement Record",TRUE,FALSE,HistProdMeasureHeader);
                    QBReportSelections.Print(QBReportSelections.Usage::J3, HistProdMeasureHeader);
                END;


            }
            action("action4")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }
            action("Cancel")
            {

                CaptionML = ENU = 'Cancel Measurement', ESP = 'Cancelar Relaci�n';
                Image = Cancel;

                trigger OnAction()
                VAR
                    QBMeasurements: Codeunit 7207274;
                BEGIN
                    //JAV 22/03/19: - Nueva acci�n para cancelar una medici�n registrada
                    QBMeasurements.HistProdMeasureCancel(Rec);
                END;


            }
            action("Borrar")
            {

                CaptionML = ESP = 'Borrar';
                Visible = IsQBAdmin;
                Image = DeleteQtyToHandle;


                trigger OnAction()
                BEGIN
                    IF (CONFIRM(Text000, FALSE)) THEN
                        Rec.DELETE(TRUE);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(Cancel_Promoted; Cancel)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);

        //JAV 04/11/20: - QB 1.07.03 Si se entra como administrador de Quobuilding
        IsQBAdmin := FunctionQB.IsQBAdmin;

        //CPA 03/02/22: - Q16275 - Permisos.Begin
        FunctionQB.SetUserJobPostedProdMeasureHeaderFilter(Rec);
        //CPA 03/02/22: - Q16275 - Permisos.End
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Rec.SETFILTER("Document Filter", '..%1', rec."No.");
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        Rec.SETFILTER("Document Filter", '..%1', rec."No.");
    END;



    var
        HistProdMeasureHeader: Record 7207401;
        FunctionQB: Codeunit 7207272;
        IsQBAdmin: Boolean;
        Text000: TextConst ESP = '�Realmente desea BORRAR COMPLETAMENTE la relaci�n valorada?';/*

    begin
    {
      JAV 03/10/19: - Se imprime usando el nuevo selector de informes
      CPA 03/02/22: - Q16275 - Permisos por proyecto. Modificaciones en OnOpenPage
    }
    end.*/


}









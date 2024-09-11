page 7207520 "Post. Prod. Measurement"
{
    Permissions = TableData 122 = r;
    Editable = false;
    CaptionML = ENU = 'Post. Prod. Measurement', ESP = 'Hist. mediciones prod.';
    InsertAllowed = false;
    SourceTable = 7207401;
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
                field("Job No."; rec."Job No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Measure Date"; rec."Measure Date")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Measurement Text"; rec."Measurement Text")
                {

                }
                field("Cancel No."; rec."Cancel No.")
                {

                }
                field("Cancel By"; rec."Cancel By")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207630)
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
                CaptionML = ENU = '&Medici�n', ESP = '&Medici�n';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }

        }
        area(Processing)
        {

            action("Imprimir")
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
            action("Navegar")
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
                actionref(Imprimir_Promoted; Imprimir)
                {
                }
                actionref(Navegar_Promoted; Navegar)
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

        //JAV 04/11/20: - QB 1.07.03 Si es QBAdmin puede eliminar
        IsQBAdmin := FunctionQB.IsQBAdmin;
    END;



    var
        HistProdMeasureHeader: Record 7207401;
        IsQBAdmin: Boolean;
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ESP = '�Realmente desea BORRAR COMPLETAMENTE la relaci�n valorada?';/*

    begin
    {
      JAV 03/10/19: - Se imprime usando el nuevo selector de informes
    }
    end.*/


}








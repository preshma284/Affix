page 7207517 "Prod. Measure List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = '"Prod. Measure" List', ESP = 'Relaci�n Valorada';
    SourceTable = 7207399;
    PageType = List;
    CardPageID = "Prod. Measure";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Measure Date"; rec."Measure Date")
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
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207629)
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
                CaptionML = ENU = '&Line', ESP = '&Medici�n';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        //PAGE.RUN(PAGE::"Medicion Produccion",Rec);
                    END;


                }

            }

        }
        area(Reporting)
        {

            action("action2")
            {
                CaptionML = ENU = 'Print', ESP = 'Imprimir';
                Image = Print;


                trigger OnAction()
                VAR
                    QBReportSelections: Record 7206901;
                    ProdMeasureHeader: Record 7207399;
                BEGIN
                    ProdMeasureHeader.RESET;
                    ProdMeasureHeader.SETRANGE("No.", rec."No.");
                    //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                    //REPORT.RUNMODAL(REPORT::"Production Measurement", TRUE, TRUE, ProdMeasureHeader);
                    QBReportSelections.Print(QBReportSelections.Usage::J2, ProdMeasureHeader);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);
    END;


    /*

        begin
        {
          JAV 03/10/19: - Se a�ade la posibilida de imprimir, usando el nuevo selector de informes
        }
        end.*/


}









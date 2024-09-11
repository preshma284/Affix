page 7207420 "Usage Header Hist."
{
    SourceTable = 7207365;
    PageType = Document;
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

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Contract Code"; rec."Contract Code")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Usage Date"; rec."Usage Date")
                {

                }

            }
            part("part1"; 7207421)
            {

                CaptionML = ENU = 'Lines', ESP = 'L�neas';
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("Resgistro")
            {

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
            part("part2"; 7207464)
            {
                SubPageLink = "Contract Code" = FIELD("Contract Code"), "No." = FIELD("No.");
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
                    RunObject = Page 7207424;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 7207419;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
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

            group("group7")
            {
                CaptionML = ENU = 'Functions', ESP = 'Acciones';
                action("action4")
                {
                    CaptionML = ENU = 'Print Autoinvoice', ESP = 'Generar Parte de trabajo';
                    Image = LedgerBudget;

                    trigger OnAction()
                    BEGIN
                        IF rec."Generated Worksheet" THEN
                            ERROR(Text001);
                        UsageHeaderHist.SETRANGE(UsageHeaderHist."No.", rec."No.");
                        // REPGenerateWorksheet.SETTABLEVIEW(UsageHeaderHist);
                        // REPGenerateWorksheet.RUNMODAL;
                        // CLEAR(REPGenerateWorksheet);
                    END;


                }

            }
            action("action5")
            {
                CaptionML = ENU = 'Navigate', ESP = 'Navegar';
                Image = Navigate;


                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


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
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }

    var
        // REPGenerateWorksheet: Report 7207332;
        UsageHeaderHist: Record 7207365;
        Text001: TextConst ENU = 'The worksheet has already been generated', ESP = 'El parte de trabajo ya ha sido generado';

    /*begin
    end.
  
*/
}








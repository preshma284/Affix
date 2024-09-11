page 7207538 "Costsheet List"
{
  ApplicationArea=All;

    CaptionML = ENU = '"Costsheet" List', ESP = 'Lista partes costes';
    SourceTable = 7207433;
    PageType = List;
    CardPageID = "Costsheet";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                Editable = False;
                field("No."; rec."No.")
                {

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
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Amount"; rec."Amount")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Sheet', ESP = '&Parte';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUN(PAGE::Costsheet, Rec);
                    END;


                }

            }

        }
        area(Processing)
        {


        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.ResponsabilityFilters(Rec);

        //CPA 03-02-22. Q16275.Begin
        FunctionsQB.SetUserJobCostsheetHeaderFilter(Rec);
        //CPA 03-02-22. Q16275.End
    END;



    var
        CUDimensionManagement: Codeunit 408;
        FunctionsQB: Codeunit 7207272;/*

    begin
    {
      CPA 03/02/22: - Q16275 - Permisos por proyecto. Modificaciones en OnOpenPage
      JAV 01/06/22: - QB 1.10.46 Se a�ade el campo Amount con la suma de las l�neas
    }
    end.*/


}









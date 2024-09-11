page 7207314 "Output Shipment List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Warehouse Shipment List', ESP = 'Lista albaran almac�n';
    InsertAllowed = false;
    SourceTable = 7207308;
    DataCaptionFields = "Job No.";
    PageType = List;
    CardPageID = "Output Shipment Heading";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                Editable = False;
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
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
        area(FactBoxes)
        {
            part("part1"; 7207496)
            {
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
    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);
        FunctionQB.SetUserJobOutputShipmentHeaderFilter(Rec);
    END;



    var
        FunctionQB: Codeunit 7207272;

    /*begin
    end.
  
*/
}









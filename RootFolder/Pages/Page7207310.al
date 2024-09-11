page 7207310 "QB WorkSheet Lines Posted"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Lines', ESP = 'Lineas';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207293;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Job No."; rec."Job No.")
                {

                }
                field("Piecework Code"; rec."Piecework Code")
                {

                }
                field("Resource No."; rec."Resource No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Work Type Code"; rec."Work Type Code")
                {

                }
                field("Work Day Date"; rec."Work Day Date")
                {

                }
                field("Direct Unit Cost"; rec."Direct Unit Cost")
                {

                }
                field("Unit Cost"; rec."Unit Cost")
                {

                }
                field("Total Cost"; rec."Total Cost")
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                }
                field("Sale Amount"; rec."Sale Amount")
                {

                }
                field("Billable"; rec."Billable")
                {

                }
                field("Compute In Hours"; rec."Compute In Hours")
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
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;


                    trigger OnAction()
                    BEGIN

                        _ShowDimensions;
                    END;


                }

            }

        }
    }


    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    // begin//end
}









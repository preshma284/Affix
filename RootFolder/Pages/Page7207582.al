page 7207582 "Subform Cost Database Bill of"
{
    CaptionML = ENU = 'Subform Cost Database Bill of Item Piecework', ESP = 'Subform descomp. preciairo UO';
    SourceTable = 7207384;
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Cod. Piecework"; rec."Cod. Piecework")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Type"; rec."Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Quantity By"; rec."Quantity By")
                {

                }
                field("Concep. Analytical Direct Cost"; rec."Concep. Analytical Direct Cost")
                {

                }
                field("Units of Measure"; rec."Units of Measure")
                {

                }
                field("Direct Unit Cost"; rec."Direct Unit Cost")
                {

                }
                field("Piecework Cost"; rec."Piecework Cost")
                {

                }

            }

        }
    }


    procedure ReceivesFilter(var PBillofItemData: Record 7207384);
    begin
        CurrPage.SETSELECTIONFILTER(PBillofItemData);
        if PBillofItemData.FINDSET then
            repeat
                PBillofItemData.MARK := TRUE;
            until PBillofItemData.NEXT = 0;
    end;

    // begin//end
}








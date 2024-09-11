page 7207311 "Certif. Job-Piecework List"
{
    SourceTable = 7207386;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Piecework Code"; rec."Piecework Code")
                {

                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                }
                field("Contract Price"; rec."Contract Price")
                {

                }
                field("Sale Amount"; rec."Sale Amount")
                {

                }
                field("Quantity in Measurements"; rec."Quantity in Measurements")
                {

                }
                field("Certified Quantity"; rec."Certified Quantity")
                {

                }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                }
                field("Invoiced Quantity"; rec."Invoiced Quantity")
                {

                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        FunDescPiecework;
    END;



    var
        boolDescription: Boolean;
        DescriptionIndent: Integer;

    LOCAL procedure FunDescPiecework();
    begin
        DescriptionIndent := rec.Indentation;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            boolDescription := TRUE;
        end;
    end;

    // begin//end
}








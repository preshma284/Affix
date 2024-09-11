page 7207442 "Element Journal Sections"
{
    CaptionML = ENU = 'Element Journal Sections', ESP = 'Secciones diario Elemento';
    SourceTable = 7207351;
    DataCaptionExpression = DataCaption;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Journal Template Name"; rec."Journal Template Name")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Name"; rec."Name")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Series No."; rec."Series No.")
                {

                }
                field("Posting No. Series"; rec."Posting No. Series")
                {

                }

            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.SetupNewBatch;
    END;




    LOCAL procedure DataCaption(): Text[250];
    var
        JournalTemplateElement: Record 7207349;
    begin
        if not CurrPage.LOOKUPMODE then
            if Rec.GETFILTER("Journal Template Name") <> '' then
                if Rec.GETRANGEMIN("Journal Template Name") = Rec.GETRANGEMAX("Journal Template Name") then
                    if JournalTemplateElement.GET(rec.GETRANGEMIN("Journal Template Name")) then
                        exit(JournalTemplateElement.Name + ' ' + JournalTemplateElement.Description);
    end;

    // begin//end
}








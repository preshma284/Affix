page 7207388 "Standard/Quote"
{
    CaptionML = ENU = 'Standard/Quote', ESP = 'Criterios/Oferta';
    SourceTable = 7207305;
    DataCaptionFields = "Quote Code";
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Standard Code"; rec."Standard Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Standard Description"; rec."Standard Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Maximun Score"; rec."Maximun Score")
                {

                }

            }

        }
    }




    trigger OnClosePage()
    BEGIN
        //Pasar a los competidores los criterios de valoraci�n que no tengan
        CompetitionQuote.RESET;
        CompetitionQuote.SETRANGE("Quote Code", rec."Quote Code");
        IF (CompetitionQuote.FINDSET(FALSE)) THEN
            REPEAT
                StandardQuote.RESET;
                IF (StandardQuote.FINDSET(FALSE)) THEN
                    REPEAT
                        StandardCompetition.INIT;
                        StandardCompetition."Quote Code" := rec."Quote Code";
                        StandardCompetition."Competitor Code" := CompetitionQuote."Competitor Code";
                        StandardCompetition."Standard Code" := StandardQuote."Standard Code";
                        IF NOT StandardCompetition.INSERT THEN;
                    UNTIL (StandardQuote.NEXT = 0);
            UNTIL (CompetitionQuote.NEXT = 0);

        //Quitar de los competidores los criterios eliminados
        StandardCompetition.RESET;
        StandardCompetition.SETRANGE("Quote Code", rec."Quote Code");
        IF (StandardCompetition.FINDSET(TRUE)) THEN
            REPEAT
                IF NOT StandardQuote.GET(rec."Quote Code", StandardCompetition."Standard Code") THEN
                    StandardCompetition.DELETE;
            UNTIL StandardCompetition.NEXT = 0;
    END;



    var
        StandardQuote: Record 7207305;
        StandardCompetition: Record 7207306;
        CompetitionQuote: Record 7207307;

    /*begin
    end.
  
*/
}








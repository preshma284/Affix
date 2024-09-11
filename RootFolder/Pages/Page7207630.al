page 7207630 "Post. Prod. Meas. Statistic FB"
{
    CaptionML = ESP = 'Hist. estad. mediciones prod.';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207401;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group54")
            {

                CaptionML = ESP = 'De la Rel.Valorada';
                field("DOC Import Previous"; rec."DOC Import Previous")
                {

                    CaptionML = ENU = 'Total production from begining', ESP = 'Anterior';
                }
                field("DOC Import Term"; rec."DOC Import Term")
                {

                    CaptionML = ENU = 'Of Periode', ESP = 'Del Periodo';
                }
                field("DOC Import to Source"; rec."DOC Import to Source")
                {

                    CaptionML = ESP = 'Total';
                }

            }
            group("group58")
            {

                CaptionML = ESP = 'Del Proyecto';
                field("JOB Date to Source"; rec."JOB Date to Source")
                {

                    CaptionML = ESP = 'Origen a Fecha';
                }
                field("JOB Total to Source"; rec."JOB Total to Source")
                {

                    CaptionML = ENU = 'Total production from begining', ESP = 'Origen Total';
                }

            }

        }
    }


    trigger OnAfterGetRecord()
    BEGIN
        CalcData
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcData
    END;




    LOCAL procedure CalcData();
    begin
        //Rec.SETFILTER("Document Filter", '..%1', "No.");
        Rec.SETFILTER("Date Filter", '..%1', rec."Posting Date");
        Rec.CALCFIELDS("JOB Date to Source");
    end;

    // begin//end
}








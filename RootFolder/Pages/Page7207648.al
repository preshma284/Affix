page 7207648 "My Activities"
{
    CaptionML = ENU = 'My Activities', ESP = 'Mis Actividades';
    SourceTable = 7207280;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Activity Code"; rec."Activity Code")
                {

                    CaptionML = ENU = 'Activity Code', ESP = 'C�d. actividad';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("MyActivities.Description"; MyActivities.Description)
                {

                    CaptionML = ESP = 'Descripci�n';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("MyActivities.Posting Group Product"; MyActivities."Posting Group Product")
                {

                    CaptionML = ESP = 'Grupo Contable producto';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("MyActivities.Posting Group Stock"; MyActivities."Posting Group Stock")
                {

                    CaptionML = ESP = 'Grupo Contable existencias';
                    Style = StandardAccent;
                    StyleExpr = TRUE

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                ShortCutKey = 'Return';
                CaptionML = ENU = 'Open', ESP = 'Abrir';
                Promoted = true;
                PromotedCategory = Process;


                trigger OnAction()
                BEGIN
                    OpenMyActivitiesCard
                END;


            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        GetMyActivities;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(MyActivities);
    END;



    var
        MyActivities: Record 7207280;

    procedure GetMyActivities();
    begin
        CLEAR(MyActivities);

        MyActivities.GET(rec."Activity Code");
    end;

    procedure OpenMyActivitiesCard();
    begin
        if MyActivities.GET(rec."Activity Code") then
            PAGE.RUN(PAGE::"Quobulding Activity List", MyActivities);
    end;

    // begin//end
}








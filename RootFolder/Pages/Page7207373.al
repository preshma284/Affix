page 7207373 "Measure Line Piecework Certif."
{
    CaptionML = ENU = 'Measure Line Piecework Certif.', ESP = 'L�n. medici�n UO certificaci�n';
    SourceTable = 7207343;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = Card;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Units"; rec."Units")
                {

                }
                field("Length"; rec."Length")
                {

                }
                field("Width"; rec."Width")
                {

                }
                field("Height"; rec."Height")
                {

                }
                field("Total"; rec."Total")
                {

                    Editable = FALSE;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }

            }
            group("group11")
            {

                field("TotalMeasure"; TotalMeasure)
                {

                    CaptionML = ENU = 'New Total Measurement', ESP = 'Medici�n total';
                    Editable = FALSE;
                    Style = Strong;
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
            //Name=<Action11000022>;
            action("<Action1100251002>")
            {

                CaptionML = ENU = 'Con&firm', ESP = 'Con&firmar';
                Visible = FALSE;
                Image = CheckLedger;


                trigger OnAction()
                BEGIN
                    Rec.MODIFY(TRUE);
                    CurrPage.CLOSE;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("<Action1100251002>_Promoted"; "<Action1100251002>")
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        TotalMeasure: Decimal;

    LOCAL procedure funOnAfterGetRecord();
    begin
        TotalMeasure := rec.CalculateData(rec."Job No.", rec."Piecework Code");
    end;

    // begin
    /*{
      JAV 05/12/19: - Se cambia el PageType a "Card" para que sea directamente editable
    }*///end
}








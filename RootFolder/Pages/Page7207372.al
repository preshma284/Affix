page 7207372 "Measure Lin. PieceWork PRESTO"
{
    CaptionML = ENU = 'Measure Lin. PieceWork PRESTO', ESP = 'Lin. mediciones U.O. PRESTO';
    SourceTable = 7207285;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Line No."; rec."Line No.")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Units"; rec."Units")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CalcTotal;
                        CurrPage.UPDATE;
                    END;


                }
                field("Length"; rec."Length")
                {

                    DecimalPlaces = 3 : 3;

                    ; trigger OnValidate()
                    BEGIN
                        CalcTotal;
                        CurrPage.UPDATE;
                    END;


                }
                field("Width"; rec."Width")
                {

                    DecimalPlaces = 3 : 3;

                    ; trigger OnValidate()
                    BEGIN
                        CalcTotal;
                        CurrPage.UPDATE;
                    END;


                }
                field("Height"; rec."Height")
                {

                    DecimalPlaces = 3 : 3;

                    ; trigger OnValidate()
                    BEGIN
                        CalcTotal;
                        CurrPage.UPDATE;
                    END;


                }
                field("Total"; rec."Total")
                {

                    DecimalPlaces = 3 : 3;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }

            }
            group("group12")
            {

                field("MeasureTotal"; MeasureTotal)
                {

                    CaptionML = ENU = 'New Total Measure', ESP = 'Medici�n total';
                    Editable = False;
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

            action("action1")
            {
                CaptionML = ENU = 'Confirm', ESP = 'Confirmar';
                Promoted = true;
                Visible = False;
                PromotedIsBig = true;
                Image = ChechkLedger;
                PromotedCategory = Process;


                trigger OnAction()
                BEGIN
                    Rec.MODIFY(TRUE);
                    CurrPage.CLOSE;
                END;


            }

        }
    }


    trigger OnDeleteRecord(): Boolean
    BEGIN
        CalcTotal;
        CurrPage.UPDATE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcTotal;
    END;



    var
        MeasureTotal: Decimal;

    LOCAL procedure CalcTotal();
    begin
        MeasureTotal := rec.CalculateData(rec."Cost Database Code", rec."Cod. Jobs Unit", rec.Use);
    end;

    // begin//end
}








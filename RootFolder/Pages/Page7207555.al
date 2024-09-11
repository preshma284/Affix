page 7207555 "Lin. Measure Piecework Product"
{
    CaptionML = ENU = 'Lin. Measure Piecework Product', ESP = 'L�n. medici�n UO producci�n';
    SourceTable = 7207390;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = Worksheet;
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
                }

            }
            group("group11")
            {

                field("MeasurementTotal"; MeasurementTotal)
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
            //Name=<Action11000022>;
            //CaptionML=ESP='<Action11000022>';
            action("<Action1100251002>")
            {

                CaptionML = ENU = 'Con&firmar', ESP = 'Con&firmar';
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

    trigger OnClosePage()
    BEGIN
        //SE comenta para que la medicic�n de producci�n y certificaci�n puedan ser diferentes
        //IF Modi = TRUE THEN
        //  DataPieceworkForProduction.UpdateSaleQuantityBase("Job No.","Piecework Code",NewMeasurementTotal);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CalculateMeasures;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        Modi := TRUE;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Modi := TRUE;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalculateMeasures;
    END;



    var
        MeasurementTotal: Decimal;
        Modi: Boolean;
        DataPieceworkForProduction: Record 7207386;

    procedure CalculateMeasures();
    begin
        MeasurementTotal := rec.CalculateData(rec."Job No.", rec."Piecework Code", Rec."Code Budget");
    end;

    // begin
    /*{
      // Modificado Layout para que en la Page aparezca con columnas correctamente.
    }*///end
}








page 7207666 "Lin. Meas. Piecework Product"
{
    CaptionML = ENU = 'Lin. Measure Piecework Product', ESP = 'L�n. medici�n UO producci�n';
    SourceTable = 7207390;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = CardPart;
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


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Length"; rec."Length")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Width"; rec."Width")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Height"; rec."Height")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Total"; rec."Total")
                {

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
                Promoted = true;
                Visible = FALSE;
                PromotedIsBig = true;
                Image = CheckLedger;
                PromotedCategory = Process;


                trigger OnAction()
                BEGIN
                    Rec.MODIFY(TRUE);
                    CurrPage.CLOSE;
                END;


            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        PreviousMeasurementTotal := rec.Total;
    END;

    trigger OnClosePage()
    BEGIN
        //SE comenta para que la medici�n de producci�n y certificaci�n puedan ser diferentes
        //IF Modi = TRUE THEN
        //  DataPieceworkForProduction.UpdateSaleQuantityBase("Job No.","Piecework Code",NewMeasurementTotal);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN

        Modi := TRUE;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN

        Modi := TRUE;
    END;



    var
        NewMeasurementTotal: Decimal;
        PreviousMeasurementTotal: Decimal;
        Modi: Boolean;
        DataPieceworkForProduction: Record 7207386;
        ManagementLineofMeasure: Codeunit 7207292;/*

    begin
    {
      // Modificado Layout para que en la Page aparezca con columnas correctamente.
      JAV 13/03/19: - Se hace editable correctamente, se eliminan columnas no necesarias y totales que no hacen falta, se a�aden funciones tras alta, baja y modificaci�n
    }
    end.*/


}








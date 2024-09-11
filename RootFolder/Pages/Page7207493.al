page 7207493 "Reestimation statistics FB"
{
    CaptionML = ENU = 'Reestimation statistic', ESP = 'Estadistica reestimaci�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207315;
    PageType = CardPart;
    layout
    {
        area(content)
        {
            field("CalcEstOutstIncAmount1"; rec."CalcEstOutstIncAmount")
            {

                CaptionML = ENU = 'Estamiated outstanding expenses amount', ESP = 'Importe gastos pendientes estimados';
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("CalcEstOrigExpAmount"; rec."CalcEstOrigExpAmount")
            {

                CaptionML = ENU = 'Expenses amount to estimated origin', ESP = 'Importe gastos a origen estimados';
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("CalcEstOutstIncAmount2"; rec."CalcEstOutstIncAmount")
            {

                CaptionML = ENU = 'Estimated outstanding income amount', ESP = 'Importe ingreso pendientes estimados';
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("CalcEstOrigIncAmount"; rec."CalcEstOrigIncAmount")
            {

                CaptionML = ENU = 'Income amount to estimated origin', ESP = 'Importe ingreso a origen estimados';
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("CalcEstOrigMargin"; rec."CalcEstOrigMargin")
            {

                CaptionML = ENU = 'Margin to estimated origin', ESP = 'Margen a origen estimado';
                Style = StrongAccent;
                StyleExpr = TRUE

  ;
            }

        }
    }


    /*begin
    end.
  
*/
}








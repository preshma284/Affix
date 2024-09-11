page 7207627 "Comparative Quote Detail FB"
{
    CaptionML = ENU = 'Comparative Quote Detail FB', ESP = 'Detalle comparativo oferta';
    SourceTable = 7207412;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group28")
            {

                CaptionML = ENU = 'Amounts', ESP = 'Importes';
                field("EstimatedAmount"; EstimatedAmount)
                {

                    CaptionML = ENU = 'Estimated Amount', ESP = 'Importe estimado';
                }
                field("TargetAmount"; TargetAmount)
                {

                    CaptionML = ENU = 'Target Amount', ESP = 'Importe objetivo';
                }
                field("LowerAmount"; LowerAmount)
                {

                    CaptionML = ENU = 'LowerAmount', ESP = 'Importe mas bajo';
                }

            }
            group("group32")
            {

                CaptionML = ENU = 'Pending', ESP = 'Contrato';
                field("Generated Contract Doc No."; rec."Generated Contract Doc No.")
                {

                    Editable = FALSE;
                }
                field("Total Generated Amount"; rec."Total Generated Amount")
                {

                    BlankZero = true;
                    Visible = verControlContrato;
                }
                field("Amount Purchase * cnt"; rec."Amount Purchase" * cnt)
                {

                    CaptionML = ESP = 'Importe';
                    BlankZero = true;
                }
                field("DifEstimated * cnt"; DifEstimated * cnt)
                {

                    CaptionML = ENU = 'Estimated Amount', ESP = 'Dif. con estimado';
                    BlankZero = true;
                }
                field("DifTarget * cnt"; DifTarget * cnt)
                {

                    CaptionML = ENU = 'Target Amount', ESP = 'Dif. con objetivo';
                    BlankZero = true;
                }
                field("DifLower * cnt"; DifLower * cnt)
                {

                    CaptionML = ENU = 'LowerAmount', ESP = 'Dif. con mas bajo';
                    BlankZero = true;
                }

            }
            group("group39")
            {

                CaptionML = ESP = 'Control contrato';
                Visible = verControlContrato;
                field("Contrac Amount"; rec."Contrac Amount")
                {

                    Visible = verControlContrato;
                }
                field("Contrac Amount Max"; rec."Contrac Amount Max")
                {

                    Visible = verControlContrato;
                }
                field("Contrac Amount in al"; rec."Contrac Amount in al")
                {

                    Visible = verControlContrato;
                }
                field("Contrac Amount in fac"; rec."Contrac Amount in fac")
                {

                    Visible = verControlContrato;
                }
                field("Contrac Amount in extensions"; rec."Contrac Amount in extensions")
                {

                    Visible = verControlContrato;
                }
                field("Contrac Amount available"; rec."Contrac Amount available")
                {

                    Visible = verControlContrato

  ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 29/08/19: - Control de contratos
        verControlContrato := Funcionesdecontratos.ModuloActivo;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //JAV 26/12/18 - Se pasa a una funci�n para no repertir c�digo
        CalcAmounts();
    END;



    var
        ComparativeQuoteLines: Record 7207413;
        EstimatedAmount: Decimal;
        TargetAmount: Decimal;
        LowerAmount: Decimal;
        DifEstimated: Decimal;
        DifTarget: Decimal;
        DifLower: Decimal;
        verControlContrato: Boolean;
        Funcionesdecontratos: Codeunit 7206907;
        cnt: Integer;

    LOCAL procedure CalcAmounts();
    begin
        EstimatedAmount := 0;
        TargetAmount := 0;
        LowerAmount := 0;

        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.FILTERGROUP(2);
        ComparativeQuoteLines.SETCURRENTKEY("Quote No.");
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."No.");
        ComparativeQuoteLines.FILTERGROUP(0);
        //JAV 26/12/18: - Los importes Estimado y Objetivo solo se calculan una vez, no en todas las l�neas
        // if ComparativeQuoteLines.FINDSET then
        //  repeat
        //    ComparativeQuoteLines.CALCFIELDS("Lowert Amount");
        //    EstimatedAmount += ComparativeQuoteLines."Estimated Amount";
        //    TargetAmount += ComparativeQuoteLines."Target Amount";
        //    LowerAmount += ComparativeQuoteLines."Lowert Amount";
        //  until ComparativeQuoteLines.NEXT = 0;
        ComparativeQuoteLines.CALCSUMS("Estimated Amount", "Target Amount");
        EstimatedAmount += ComparativeQuoteLines."Estimated Amount";
        TargetAmount += ComparativeQuoteLines."Target Amount";

        if (ComparativeQuoteLines.FINDSET(FALSE)) then
            repeat
                ComparativeQuoteLines.CALCFIELDS("Lowert Amount");
                LowerAmount += ComparativeQuoteLines."Lowert Amount";
            until ComparativeQuoteLines.NEXT = 0;
        //JAV 26/12/18 fin

        //JAV 14/02/19: - C�lculo de diferencias solo cuando se ha seleccioando un proveedor
        if (rec."Selected Vendor" = '') then begin
            DifEstimated := 0;
            DifLower := 0;
            DifTarget := 0;
        end ELSE begin
            DifEstimated := rec."Amount Purchase" - EstimatedAmount;
            DifLower := rec."Amount Purchase" - LowerAmount;
            DifTarget := rec."Amount Purchase" - TargetAmount;
        end;

        if Rec."Generate for months" = 0 then
            cnt := 1
        ELSE
            cnt := Rec."Generate for months";
    end;

    // begin
    /*{
      JAV 26/12/18: - Se a�aden los caption que faltaban, se a�ade una funci�n con los calculos para no repertir c�digo
                    - Los importes Estimado y Objetivo solo se calculan una vez, no en todas las l�neas
    }*///end
}








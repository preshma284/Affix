page 7207319 "Project Total Amount"
{
    CaptionML = ENU = 'Project Total Amount', ESP = 'Importe total preciario';
    SourceTable = 7207277;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field("Project Total Cost"; "TotalCost")
            {

                CaptionML = ENU = 'Project Total Cost', ESP = 'Total coste proyecto';
            }
            field("Project Total Sales"; "TotalSales")
            {

                CaptionML = ENU = 'Project Total Sales', ESP = 'Total venta proyecto';
            }
            field("FORMAT(ROUND(Margin,1.01)) + '%'"; FORMAT(ROUND(Margin, 1.01)) + '%')
            {

                CaptionML = ESP = 'Margen';
                StyleExpr = stMargen;
            }
            field("Margin*100"; Margin * 100)
            {

                ExtendedDatatype = Ratio;
                CaptionML = ENU = 'Margin', ESP = 'Margen';
            }

        }
    }
    trigger OnAfterGetRecord()
    VAR
        Piecework: Record 7207277;
    BEGIN
        //Obtengo el c�digo del preciario
        Rec.FILTERGROUP(4);
        CDCode := Rec.GETFILTER("Cost Database Default");
        Rec.FILTERGROUP(0);

        //Calcular totales y m�rgen
        IF (CDCode = '') THEN BEGIN
            TotalCost := 0;
            TotalSales := 0;
        END ELSE BEGIN
            //JAV 24/11/22: - QB 1.12.24 Si no tienen el c�digo del padre se lo pongo ahora, si no el proceso no funciona
            CostDatabase.GET(Rec."Cost Database Default");
            IF (CostDatabase.Version = 0) THEN
                Piecework.PW_SetFatherCodeForAll(Rec."Cost Database Default");

            Piecework.RESET;
            Piecework.SETRANGE("Cost Database Default", CDCode);
            Piecework.SETRANGE("Account Type", Piecework."Account Type"::Heading);    //JAV 24/11/22: - QB 1.12.24 Cambio la forma de calcular, en lugar de unidades utizo las de mayor de primer nivel
            Piecework.SETRANGE("Father Code", '');

            Piecework.CALCSUMS("Total Amount Cost", "Total Amount Sales");
            TotalCost := Piecework."Total Amount Cost";
            TotalSales := Piecework."Total Amount Sales";
        END;

        IF TotalCost <> 0 THEN
            Margin := (TotalSales - TotalCost) * 100 / TotalCost
        ELSE
            Margin := 0;

        CASE TRUE OF
            Margin < 0:
                stMargen := 'Unfavorable';
            Margin = 0:
                stMargen := '';
            Margin > 0:
                stMargen := 'Favorable';
        END;
    END;



    var
        CostDatabase: Record 7207271;
        CDCode: Code[20];
        TotalCost: Decimal;
        TotalSales: Decimal;
        Margin: Decimal;
        Percent: Decimal;
        Text001: TextConst ENU = 'Margin @@@@@', ESP = 'Margen @@@@@';
        stMargen: Text;/*

    begin
    {
      Q2032 FR 21/05/2018 Creaci�n de la CardPart y c�lculos de % Margen.
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se cambian los c�lculos de los importes
    }
    end.*/


}








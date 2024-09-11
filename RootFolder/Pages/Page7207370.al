page 7207370 "Job Offers Statistics"
{
    Editable = false;
    CaptionML = ENU = 'Job Offers Statistics', ESP = 'Estad�sticas ofertas proy.';
    SourceTable = 167;
    PageType = Card;
    layout
    {
        area(content)
        {
            group("General")
            {

                group("group76")
                {

                    CaptionML = ENU = 'Budget', ESP = 'Presupuesto';
                    field("Budget Sales Amount"; rec."Budget Sales Amount")
                    {

                    }
                    field("Budget Cost Amount"; rec."Budget Cost Amount")
                    {

                    }

                }
                group("group79")
                {

                    CaptionML = ENU = 'Margin Breakdown', ESP = 'Desglose de margen';
                    field("CalculateMarginProvided_DL"; rec."CalculateMarginProvided_DL")
                    {

                        CaptionML = ENU = 'Expected MArgin', ESP = 'Margen previsto';
                    }
                    field("CalculateMarginProvidedPercentage_DL"; rec."CalculateMarginProvidedPercentage_DL")
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = '% Margin Expected S/Sales', ESP = '% margen previsto s/venta';
                        MinValue = 0;
                        MaxValue = 100;
                    }
                    field("CalcMarginDirect_DL"; rec.CalcMarginDirect_DL)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = '% Margin Over Direct Costs', ESP = '% Margen sobre costes directos';
                        MinValue = 0;
                        MaxValue = 100;
                        Editable = False;
                    }

                }
                group("group83")
                {

                    CaptionML = ENU = 'Cost Budget Detail', ESP = 'Detalle de presupuesto';
                    field("Direct Cost Amount PieceWork"; rec."Direct Cost Amount PieceWork")
                    {

                    }
                    field("Indirect Cost Amount Piecework"; rec."Indirect Cost Amount Piecework")
                    {

                    }
                    field("CalcPercentageCostIndirect_DL"; rec.CalcPercentageCostIndirect_DL)
                    {

                        ExtendedDatatype = Ratio;
                        CaptionML = ENU = '% Indirect Cost About Total Costs', ESP = '% de costes indirecto sobre total costes';
                        MinValue = 0;
                        MaxValue = 100;
                        Editable = False

  ;
                    }

                }

            }

        }
    }


    /*begin
    end.
  
*/
}








page 7207658 "Measure Lines FB"
{
    CaptionML = ENU = 'Measure Lines Stat.', ESP = 'Est. Lineas de Medici�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207395;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group87")
            {

                CaptionML = ESP = 'Presupuesto';
                field("Budget Units"; rec."Budget Units")
                {

                    CaptionML = ENU = 'Budget Units', ESP = 'Unidades';
                }
                field("Budget Length"; rec."Budget Length")
                {

                    CaptionML = ENU = 'Budget Length', ESP = 'Largo';
                }
                field("Budget Width"; rec."Budget Width")
                {

                    CaptionML = ENU = 'Budget Width', ESP = 'Ancho';
                }
                field("Budget Height"; rec."Budget Height")
                {

                    CaptionML = ENU = 'Budget Height', ESP = 'Alto';
                }
                field("Budget Total"; rec."Budget Total")
                {

                    CaptionML = ENU = 'Total ppto.', ESP = 'Total';
                }

            }
            group("group93")
            {

                CaptionML = ESP = 'Anterior';
                field("Realized Units"; rec."Realized Units")
                {

                    CaptionML = ENU = 'Realized Units', ESP = 'Unidades';
                }
                field("Realized Total"; rec."Realized Total")
                {

                    CaptionML = ENU = 'Total Realized', ESP = 'Total';
                }
                field("PorRealizado"; PorRealizado)
                {

                    CaptionML = ESP = '%';
                }

            }
            group("group97")
            {

                CaptionML = ESP = 'Pendiente';
                field("Budget Units - Realized Units"; rec."Budget Units" - rec."Realized Units")
                {

                    CaptionML = ENU = 'Budget Units', ESP = 'Unidades';
                    Visible = false;
                }
                field("Budget Total - Realized Total"; rec."Budget Total" - rec."Realized Total")
                {

                    CaptionML = ENU = 'Total ppto.', ESP = 'Total';
                }
                field("PorPendiente"; PorPendiente)
                {

                    CaptionML = ESP = '%';
                }

            }

        }
    }

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcData;
    END;



    var
        PorRealizado: Decimal;
        PorPendiente: Decimal;

    procedure CalcData();
    begin
        PorRealizado := 0;
        ;
        PorPendiente := 0;
        Rec.CALCFIELDS("Realized Total");
        if (rec."Budget Total" <> 0) then begin
            PorRealizado := ROUND(rec."Realized Total" * 100 / rec."Budget Total", 0.01);
            PorPendiente := ROUND((rec."Budget Total" - rec."Realized Total") * 100 / rec."Budget Total", 0.01);
        end;
    end;

    // begin
    /*{
      JAV 16/09/19: - Se promueven las acciones de la p�gina para que aparezcan en la pantalla directamente
                    - Se reordenan las colunas
                    - Se elimina la funci�n "CreateText", ya que la medici�n es siempre a origen
    }*///end
}








page 7207673 "QB Debit Relations Aux"
{
    CaptionML = ENU = 'Debit Relation', ESP = 'Relaci�n de cobros';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    layout
    {
        area(content)
        {
            group("group57")
            {

                CaptionML = ESP = 'Importe inicial o del incremento';
                Visible = verImporte;
                group("group58")
                {

                    field("Importe"; Importe)
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Desde"; Desde)
                    {

                        CaptionML = ESP = 'Desde Fecha';
                    }
                    field("Meses"; Meses)
                    {

                        CaptionML = ESP = 'N� Meses';
                    }

                }

            }
            group("group62")
            {

                CaptionML = ESP = 'Pagos recibidos';
                Visible = verPago;
                group("group63")
                {

                    CaptionML = ESP = 'Documento 1';
                    field("Pagos[1]_"; Pagos[1])
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Fechas[1]_"; Fechas[1])
                    {

                        CaptionML = ESP = 'Fecha';
                    }
                    field("Tipos[1]_"; Tipos[1])
                    {

                        CaptionML = ESP = 'Tipo';
                    }

                }
                group("group67")
                {

                    CaptionML = ESP = 'Documento 2';
                    field("Pagos[2]_"; Pagos[2])
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Fechas[2]_"; Fechas[2])
                    {

                        CaptionML = ESP = 'Fecha';
                    }
                    field("Tipos[2]_"; Tipos[2])
                    {

                        CaptionML = ESP = 'Tipo';
                    }

                }
                group("group71")
                {

                    CaptionML = ESP = 'Documento 3';
                    field("Pagos[3]_"; Pagos[3])
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Fechas[3]_"; Fechas[3])
                    {

                        CaptionML = ESP = 'Fecha';
                    }
                    field("Tipos[3]_"; Tipos[3])
                    {

                        CaptionML = ESP = 'Tipo';
                    }

                }
                group("group75")
                {

                    CaptionML = ESP = 'Documento 4';
                    field("Pagos[4]_"; Pagos[4])
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Fechas[4]_"; Fechas[4])
                    {

                        CaptionML = ESP = 'Fecha';
                    }
                    field("Tipos[4]_"; Tipos[4])
                    {

                        CaptionML = ESP = 'Tipo';
                    }

                }
                group("group79")
                {

                    CaptionML = ESP = 'Documento 5';
                    field("Pagos[5]_"; Pagos[5])
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Fechas[5]_"; Fechas[5])
                    {

                        CaptionML = ESP = 'Fecha';
                    }
                    field("Tipos[5]_"; Tipos[5])
                    {

                        CaptionML = ESP = 'Tipo';
                    }

                }
                group("group83")
                {

                    CaptionML = ESP = 'Documento 6';
                    field("Pagos[6]_"; Pagos[6])
                    {

                        CaptionML = ESP = 'Importe';
                    }
                    field("Fechas[6]_"; Fechas[6])
                    {

                        CaptionML = ESP = 'Fecha';
                    }
                    field("Tipos[6]_"; Tipos[6])
                    {

                        CaptionML = ESP = 'Tipo';
                    }

                }

            }

        }
    }

    var
        verImporte: Boolean;
        verPago: Boolean;
        "---------------- 0": Integer;
        Importe: Decimal;
        Desde: Date;
        Meses: Integer;
        "----------------- 1": Date;
        Pagos: ARRAY[10] OF Decimal;
        Fechas: ARRAY[10] OF Date;
        Tipos: ARRAY[10] OF Option "Pagar�","Tal�n","Recibo","Trasnferencia";

    procedure GetDataAmount(var pImporte: Decimal; var pFecha: Date; var pMeses: Integer);
    begin
        pImporte := Importe;
        pFecha := Desde;
        pMeses := Meses;
    end;

    procedure GetDataReceived(var pImporte: ARRAY[10] OF Decimal; var pFecha: ARRAY[10] OF Date; var pTipo: ARRAY[10] OF Option);
    begin
        COPYARRAY(pImporte, Pagos, 1);
        COPYARRAY(pFecha, Fechas, 1);
        COPYARRAY(pTipo, Tipos, 1);
    end;

    procedure SetType(pType: Integer);
    begin
        verImporte := pType = 0;
        verPago := pType = 1;
    end;

    // begin//end
}








page 7207567 "Add Contract Import"
{
    CaptionML = ENU = 'Add Contract Import', ESP = 'A�adir importe al contrato';
    PageType = StandardDialog;
    layout
    {
        area(content)
        {
            group("General")
            {

                field("Actual"; Actual)
                {

                    CaptionML = ESP = 'Importe Actual';
                    Editable = False;
                }
                field("Usado"; Usado)
                {

                    CaptionML = ESP = 'Importe Utilizado';
                    Editable = False;
                }
                field("Nuevo"; Nuevo)
                {

                    CaptionML = ESP = 'Sumar/Restar';

                    ; trigger OnValidate()
                    BEGIN
                        Calcs;
                        IF (Total < Usado) THEN
                            ERROR(Text001);
                    END;


                }
                field("Total"; Total)
                {

                    CaptionML = ESP = 'Nuevo Importe';
                    Editable = False;
                }
                field("Disponible"; Disponible)
                {

                    CaptionML = ESP = 'Nuevo disponible';
                    Editable = False

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
                CaptionML = ENU = 'Print', ESP = 'Imprimir';
                Promoted = true;
                PromotedIsBig = true;
                Image = Confirm;
                PromotedCategory = Process
    ;
            }

        }
    }

    var
        Actual: Decimal;
        Usado: Decimal;
        Nuevo: Decimal;
        Total: Decimal;
        Text001: TextConst ESP = 'El importe nuevo no puede ser inferior al utilizado';
        Disponible: Decimal;

    procedure SetData(pContrato: Decimal; pUsado: Decimal);
    begin
        Actual := pContrato;
        Usado := pUsado;
        Calcs;
    end;

    procedure GetData(): Decimal;
    begin
        exit(Nuevo);
    end;

    LOCAL procedure Calcs();
    begin
        Total := Actual + Nuevo;
        Disponible := Total - Usado;
    end;

    // begin//end
}








page 7207402 "Defer Withholding Movements"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207329;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                group("group67")
                {

                    CaptionML = ESP = 'Retenci�n';
                    field("No."; rec."No.")
                    {

                    }
                    field("Document No."; rec."Document No.")
                    {

                    }
                    field("External Document No."; rec."External Document No.")
                    {

                    }
                    field("Posting Date"; rec."Posting Date")
                    {

                    }
                    field("Description"; rec."Description")
                    {

                    }
                    field("Withholding Code"; rec."Withholding Code")
                    {

                    }
                    field("Document Date"; rec."Document Date")
                    {

                    }
                    field("Withholding Base"; rec."Withholding Base")
                    {

                    }
                    field("Withholding Base (LCY)"; rec."Withholding Base (LCY)")
                    {

                        Visible = false;
                    }
                    field("Amount"; rec."Amount")
                    {

                    }
                    field("Amount (LCY)"; rec."Amount (LCY)")
                    {

                        Visible = false;
                    }

                }
                group("group79")
                {

                    CaptionML = ESP = 'Dividir';
                    field("Porc1"; Porc1)
                    {

                        CaptionML = ESP = 'Porcentaje 1';
                        Editable = false;
                    }
                    field("Amount1"; Amount1)
                    {

                        CaptionML = ESP = 'Importe 1';
                        Editable = false;
                    }
                    field("Date1"; Date1)
                    {

                        CaptionML = ESP = 'Fecha Vto. 1';
                    }
                    field("Porc2"; Porc2)
                    {

                        CaptionML = ESP = 'Porcentaje 2';

                        ; trigger OnValidate()
                        BEGIN
                            IF (Porc2 < 0) THEN Porc2 := 0;
                            IF (Porc2 > 100) THEN Porc2 := 100;
                            CalculateAmount();
                        END;


                    }
                    field("Amount2"; Amount2)
                    {

                        CaptionML = ESP = 'Importe 2';

                        ; trigger OnValidate()
                        BEGIN
                            IF (Amount2 = 0) THEN
                                ERROR(Text000);
                            IF (ABS(Amount2) >= ABS(rec.Amount)) THEN
                                ERROR(Text001);
                            Amount1 := rec.Amount - Amount2;
                            CalculatePorc();
                        END;


                    }
                    field("Date2"; Date2)
                    {

                        CaptionML = ESP = 'Fecha Vto. 2';
                    }

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        Porc1 := 100;
        Porc2 := 0;
        Amount1 := Rec.Amount;
        Amount2 := 0;

        CalculateAmount();
        Date1 := Rec."Due Date";
        Date2 := Rec."Due Date";
    END;



    var
        Porc1: Decimal;
        Porc2: Decimal;
        Amount1: Decimal;
        Amount2: Decimal;
        Text000: TextConst ESP = 'No ha indicado importe por el que dividir';
        Text001: TextConst ESP = 'No puede indicar un importe superior al de la retenci�n';
        Date1: Date;
        Date2: Date;

    LOCAL procedure CalculateAmount();
    begin
        Amount2 := ROUND(Rec.Amount * Porc2 / 100, 0.01);
        Amount1 := Rec.Amount - Amount2;
        Porc1 := 100 - Porc2;
    end;

    LOCAL procedure CalculatePorc();
    begin
        Porc2 := ROUND(Amount2 * 100 / Rec.Amount, 0.01);
        Porc1 := 100 - Porc2;
    end;

    procedure GetData(var pAmount: Decimal; var pDate1: Date; var pDate2: Date);
    begin
        pAmount := Amount2;
        pDate1 := Date1;
        pDate2 := Date2;
    end;

    // begin
    /*{
      JAV 08/03/19: - Se hace que no se pueda insertar o borrar.
                    - Se cambia el orden de los campos para hacerlo mas funcional
                    - Se a�ade el importe que va a quedar restante y se valida que pueda ser corretos los importes
                    - Se a�ade el bot�n para dividir realmente el importe
    }*///end
}








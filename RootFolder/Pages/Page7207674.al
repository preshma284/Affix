page 7207674 "QB Debit Relations Setup"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Debit Relations Setup', ESP = 'Configuraci�n relaciones de cobros';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207335;

    layout
    {
        area(content)
        {
            group("group88")
            {

                CaptionML = ESP = 'Relaciones de cobros';
                field("RC Use Debit Relations"; rec."RC Use Debit Relations")
                {

                }
                field("RC Serie Relaciones Cobros"; rec."RC Serie Relaciones Cobros")
                {

                }
                field("RC Default Type"; rec."RC Default Type")
                {

                }
                field("RC Payment Method Code"; rec."RC Payment Method Code")
                {

                }
                field("RC Cuenta Cobro anticipado"; rec."RC Cuenta Cobro anticipado")
                {

                }
                field("RC Gen.Journal Template Name"; rec."RC Gen.Journal Template Name")
                {

                }
                field("RC Gen.Journal Batch Name"; rec."RC Gen.Journal Batch Name")
                {

                }
                field("RC Codigo Origen"; rec."RC Codigo Origen")
                {

                }

            }
            group("group97")
            {

                CaptionML = ESP = 'Textos de asientos';
                field("RC Texto para Registrar"; rec."RC Texto para Registrar")
                {

                    ToolTipML = ESP = '"Puede usar %1 N� relaci�n, %2 N� Proyecto, %3 Nombre cliente"';
                }
                field("RC Texto para crear Efectos"; rec."RC Texto para crear Efectos")
                {

                    ToolTipML = ESP = '"Puede usar %1 N� relaci�n, %2 N� Proyecto, %3 Nombre cliente, %4 N� del efecto"';
                }
                field("RC Texto para Liquidar Fac-Ab"; rec."RC Texto para Liquidar Fac-Ab")
                {

                    ToolTipML = ESP = '"Puede usar %1 N� relaci�n, %2 N� Proyecto, %3 Nombre cliente"';
                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    END;



    var
        Text00: TextConst ENU = 'This option is not active', ESP = 'Esta opci�n no est� activa';

    /*begin
    end.
  
*/
}









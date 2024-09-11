page 7207656 "Guarantees Types"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Guarantee Type', ESP = 'Tipo de garant�a';
    SourceTable = 7207443;
    PageType = Card;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Code"; rec."Code")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Type"; rec."Type")
                {


                    ; trigger OnValidate()
                    BEGIN
                        SetEditable;
                        IF (rec.Type <> rec.Type::GuaranteeWith) THEN
                            rec."Retention %" := 0;
                    END;


                }
                field("Bank Account No."; rec."Bank Account No.")
                {

                }
                field("Destination Type"; rec."Destination Type")
                {

                }
                field("Destination No."; rec."Destination No.")
                {

                }
                field("Retention %"; rec."Retention %")
                {

                    Editable = edRetention;
                }
                field("Account for Forecast Expenses"; rec."Account for Forecast Expenses")
                {

                }
                field("Account for Expenses"; rec."Account for Expenses")
                {

                }
                field("Account for Initial Expenses"; rec."Account for Initial Expenses")
                {

                    ToolTipML = ENU = 'Account in which the opening costs of the guarantee will be recorded, if it is blank it will use the one defined for the expenses', ESP = 'Cuenta en la que se registrar�n los gastos de apertura de la garant�a, si est� en blanco usar� la definida para los gastos';
                }
                field("Account for Final Expenses"; rec."Account for Final Expenses")
                {

                    ToolTipML = ENU = 'Account in which the expenses of cancellation of the guarantee will be registered, if it is blank it will use the one defined for the expenses', ESP = 'Cuenta en la que se registrar�n los gastos de cancelaci�n de la garant�a, si est� en blanco usar� la definida para los gastos';
                }
                field("Account for Seizure"; rec."Account for Seizure")
                {

                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
    END;



    var
        edRetention: Boolean;

    LOCAL procedure SetEditable();
    begin
        edRetention := (rec.Type = rec.Type::GuaranteeWith);
    end;

    // begin//end
}









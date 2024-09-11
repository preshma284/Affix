page 7207352 "Purchasing Needs Lines"
{
    Editable = false;
    CaptionML = ENU = 'Purchasing Needs Lines', ESP = 'Lineas necesidades de compra';
    SourceTable = 7207281;
    DataCaptionFields = "Job No.";
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Date Update"; rec."Date Update")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Decription"; rec."Decription")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Activity Code"; rec."Activity Code")
                {

                }
                field("Date Needed"; rec."Date Needed")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Stock Location (Base)"; rec."Stock Location (Base)")
                {

                }
                field("Stock Contracts Items (Base)"; rec."Stock Contracts Items (Base)")
                {

                }
                field("Stock Contracts Resource (B)"; rec."Stock Contracts Resource (B)")
                {

                }
                field("Estimated Price"; rec."Estimated Price")
                {

                }
                field("Estimated Amount"; rec."Estimated Amount")
                {

                }
                field("Target Price"; rec."Target Price")
                {

                }
                field("Target Amount"; rec."Target Amount")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                    Visible = useCurrencies;
                }
                field("Currency Date"; rec."Currency Date")
                {

                    Visible = useCurrencies;
                }
                field("Target Price (JC)"; rec."Target Price (JC)")
                {

                    Visible = useCurrencies;
                }
                field("Target Amount (JC)"; rec."Target Amount (JC)")
                {

                    Visible = useCurrencies;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
       rec.ShowShortcutDimCode(ShortcutDimCode);
    END;



    var
        ShortcutDimCode: ARRAY[8] OF Code[20];
        FunctionQB: Codeunit 7207272;
        useCurrencies: Boolean;
        JobCurrencyExchangeFunction: Codeunit 7207332;

    /*begin
    end.
  
*/
}








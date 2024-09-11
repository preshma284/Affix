page 7207550 "Quote Lines by Vendor"
{
    CaptionML = ENU = 'Quote Lines by Vendor', ESP = 'Lineas de oferta por proveedor';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207415;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Type"; rec."Type")
                {

                }
                field("No."; rec."No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        Rec.INIT;
                        Rec."Code Piecework PRESTO" := '1';
                        Rec.INSERT;
                    END;


                }
                field("TypeDescription(Type,No.)"; rec.TypeDescription(rec.Type,rec."No."))
    {
        
                CaptionML=ENU='Description',ESP='Descripci�n';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Piecework No."; rec."Piecework No.")
                {

                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Estimated Price"; rec."Estimated Price")
                {

                }
                field("Target Price"; rec."Target Price")
                {

                }
                field("Vendor Price"; rec."Vendor Price")
                {


                    ; trigger OnValidate()
                    BEGIN
                        //JAV 12/03/19: - si cambian el precio, deseleccionar el proveedor y actualizar la cabecera
                        IF rec."Vendor Price" <> xRec."Vendor Price" THEN BEGIN
                            ComparativeQuoteHeader.GET(rec."Quote Code");
                            IF ComparativeQuoteHeader."Selection Made" THEN BEGIN
                                IF (CONFIRM(txt01)) THEN
                                    VendorConditionsData.UnselectVendor(rec."Quote Code")
                                ELSE
                                    ERROR('');
                            END;
                        END;
                        CurrPage.UPDATE;
                    END;


                }
                field("Purchase Amount"; rec."Purchase Amount")
                {

                }
                field("QB Framework Contr. No."; rec."QB Framework Contr. No.")
                {

                }

            }

        }
    }

    var
        VendorConditionsData: Record 7207414;
        ComparativeQuoteHeader: Record 7207412;
        txt01: TextConst ESP = 'Tiene un proveedor seleccionado, si contin�a se deseleccionar�.';

    /*begin
    end.
  
*/
}








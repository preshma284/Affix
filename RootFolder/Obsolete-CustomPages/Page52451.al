page 52451 "Cross References"
{
    Editable = true;
    CaptionML = ENU = 'Item Cross References', ESP = 'Referencias cruzada producto';
    SourceTable = "Item Reference";
    DataCaptionFields = "Reference Type No.";
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Control1")
            {

                field("Cross-Reference No."; rec."Reference No.")
                {

                    ToolTipML = ENU = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendors or customers item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.', ESP = 'Especifica el n�mero de producto de la referencia cruzada. Si introduce una referencia cruzada entre su n�mero de producto y el del proveedor o el cliente, sobrescribir� el n�mero de producto est�ndar cuando introduzca el n�mero de referencia cruzada en un documento de venta o de compra.';
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; rec."Item No.")
                {

                    ToolTipML = ENU = 'Specifies the number on the item card from which you opened the Item Cross Reference Entries window.', ESP = 'Especifica el n�mero en la ficha de producto desde la que abri� la ventana Movs. ref. cruzadas prod.';
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; rec."Variant Code")
                {

                    ToolTipML = ENU = 'Specifies the variant of the item on the line.', ESP = 'Especifica la variante del producto que figura en la l�nea.';
                    ApplicationArea = Planning;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {

                    ToolTipML = ENU = 'Specifies the name of the item or resources unit of measure, such as piece or hour.', ESP = 'Especifica el nombre de la unidad de medida del producto o recurso, como la unidad o la hora.';
                    ApplicationArea = Basic, Suite;
                }
                //field removed
                // field("Discontinue Bar Code"; rec."Discontinue Bar Code")
                // {

                //     ToolTipML = ENU = 'Specifies that you want the program to discontinue a bar code cross reference.', ESP = 'Especifica que desea que el programa suspenda una referencia cruzada de c�digo de barras.';
                //     ApplicationArea = Basic, Suite;
                // }
                field("Description"; rec."Description")
                {

                    ToolTipML = ENU = 'Specifies a description of the item that is linked to this cross reference.', ESP = 'Especifica una descripci�n del producto asociado a esta referencia cruzada.';
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; rec."Description 2")
                {

                    ToolTipML = ENU = 'Specifies an additional description of the item that is linked to this cross reference.', ESP = 'Especifica una descripci�n adicional del producto asociado a esta referencia cruzada.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {

                Visible = FALSE;
            }

        }
    }


    /*begin
    end.
  
*/
}








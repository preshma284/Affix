page 52450 "Item Cross Reference Entries"
{
    CaptionML = ENU = 'Item Cross Reference Entries', ESP = 'Movs. ref. cruzadas prod.';
    SourceTable = "Item Reference";
    DelayedInsert = true;
    DataCaptionFields = "Item No.";
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Control1")
            {

                field("Cross-Reference Type"; rec."Reference Type")
                {

                    ToolTipML = ENU = 'Specifies the type of the cross-reference entry.', ESP = 'Especifica el tipo del movimiento de referencia cruzada.';
                    ApplicationArea = Basic, Suite;
                }
                field("Cross-Reference Type No."; rec."Reference Type No.")
                {

                    ToolTipML = ENU = 'Specifies a customer number, a vendor number, or a bar code, depending on what you have selected in the Type field.', ESP = 'Especifica un n�mero de cliente, un n�mero de proveedor o un c�digo de barras, en funci�n de lo que haya seleccionado en el campo Tipo.';
                    ApplicationArea = Basic, Suite;
                }
                field("Cross-Reference No."; rec."Reference No.")
                {

                    ToolTipML = ENU = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendors or customers item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.', ESP = 'Especifica el n�mero de producto de la referencia cruzada. Si introduce una referencia cruzada entre su n�mero de producto y el del proveedor o el cliente, sobrescribir� el n�mero de producto est�ndar cuando introduzca el n�mero de referencia cruzada en un documento de venta o de compra.';
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
                field("Description"; rec."Description")
                {

                    ToolTipML = ENU = 'Specifies a description of the item linked to this cross reference. It will override the standard description when entered on an order.', ESP = 'Especifica una descripci�n del producto vinculado a esta referencia cruzada. Se sobrescribir� la descripci�n est�ndar cuando se especifique en un pedido.';
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; rec."Description 2")
                {

                    ToolTipML = ENU = 'Specifies an additional description of the item linked to this cross reference.', ESP = 'Especifica una descripci�n adicional del producto asociado a esta referencia cruzada.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                //field removed
                // field("Discontinue Bar Code"; rec."Discontinue Bar Code")
                // {

                //     ToolTipML = ENU = 'Specifies that you want the program to discontinue a bar code cross reference.', ESP = 'Especifica que desea que el programa suspenda una referencia cruzada de c�digo de barras.';
                //     ApplicationArea = Basic, Suite;
                // }

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








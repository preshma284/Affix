page 7207008 "QB Post. Receipt/Transfer List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Posted Receipt/Transfer List', ESP = 'Lista Recepci�n/Traspaso registrados';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7206972;
    PageType = List;
    CardPageID = "QB Post. Receipt/Transfer Card";
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Type"; rec."Type")
                {

                }
                field("Location"; rec."Location")
                {

                }
                field("Destination Location"; rec."Destination Location")
                {

                }
                field("Allow Ceded"; rec."Allow Ceded")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Service Order No."; rec."Service Order No.")
                {

                }
                field("Diverse Entrance"; rec."Diverse Entrance")
                {

                }

            }
        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Creation)
        {
            //CaptionML=ENU='General';
            action("Navigate")
            {

                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', ESP = 'Permite buscar todos los movimientos y los documentos que existen para el n�mero de documento y la fecha de registro que constan en el movimiento o el documento seleccionado.';
                ApplicationArea = Basic, Suite;
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }
            action("Print")
            {

                CaptionML = ENU = '&Print', ESP = 'Imprimir';
                Image = Print;


                trigger OnAction()
                VAR
                    PostedReceiptTransferHeader: Record 7206972;
                BEGIN
                    PostedReceiptTransferHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PostedReceiptTransferHeader);
                    //SE COMENTA Report no en la lista
                    //REPORT.RUNMODAL(REPORT::"Posted Location Adjust",TRUE,TRUE,PostedReceiptTransferHeader);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref(Print_Promoted; Print)
                {
                }
            }
        }
    }


    /*begin
    end.
  
*/
}









page 7174672 "Sales List Example DragDrop"
{
Editable=false;
    CaptionML=ENU='Sales List',ESP='Lista documentos venta';
    SourceTable=36;
    DataCaptionFields="Document Type";
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the sales document.',ESP='Especifica el n�mero del documento de venta.';
                ApplicationArea=Basic,Suite;
    }
    field("Sell-to Customer No.";rec."Sell-to Customer No.")
    {
        
                ToolTipML=ENU='Specifies the number of the customer who will receive the products and be billed by default.',ESP='Especifica el n�mero del cliente que recibir� los productos y al que se facturar� de forma predeterminada.';
                ApplicationArea=Basic,Suite;
    }
    field("Sell-to Customer Name";rec."Sell-to Customer Name")
    {
        
                ToolTipML=ENU='Specifies the name of the customer who will receive the products and be billed by default.',ESP='Especifica el nombre del cliente que recibir� los productos y al que se facturar� de forma predeterminada.';
                ApplicationArea=Basic,Suite;
    }
    field("External Document No.";rec."External Document No.")
    {
        
                ToolTipML=ENU='Specifies the number that the customer uses in their own system to refer to this sales document.',ESP='Especifica el n�mero que usa el cliente en su propio sistema para hacer referencia a este documento de venta.';
                ApplicationArea=Basic,Suite;
    }
    field("Sell-to Post Code";rec."Sell-to Post Code")
    {
        
                ToolTipML=ENU='Specifies the postal code of the address.',ESP='Especifica el c�digo postal de la direcci�n.';
                Visible=FALSE ;
    }
    field("Sell-to Country/Region Code";rec."Sell-to Country/Region Code")
    {
        
                ToolTipML=ENU='Specifies the country/region code of the address.',ESP='Especifica el c�digo de pa�s o regi�n de la direcci�n.';
                Visible=FALSE ;
    }
    field("Sell-to Contact";rec."Sell-to Contact")
    {
        
                ToolTipML=ENU='Specifies the name of the person to contact at the customer.',ESP='Especifica el nombre de la persona de contacto del cliente.';
                Visible=FALSE ;
    }
    field("Bill-to Customer No.";rec."Bill-to Customer No.")
    {
        
                ToolTipML=ENU='Specifies the customer to whom you will send the sales invoice when this customer is different from the sell-to customer.',ESP='Especifica el cliente al que se enviar� la factura de venta, cuando este es distinto del cliente al que se realiza la venta.';
                Visible=FALSE ;
    }
    field("Bill-to Name";rec."Bill-to Name")
    {
        
                ToolTipML=ENU='Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.',ESP='Especifica el cliente al que se enviar� la factura de venta, cuando es distinto del cliente al que se realiza la venta.';
                Visible=FALSE ;
    }
    field("Bill-to Post Code";rec."Bill-to Post Code")
    {
        
                ToolTipML=ENU='Specifies the postal code of the address.',ESP='Especifica el c�digo postal de la direcci�n.';
                Visible=FALSE ;
    }
    field("Bill-to Country/Region Code";rec."Bill-to Country/Region Code")
    {
        
                ToolTipML=ENU='Specifies the country/region code of the address.',ESP='Especifica el c�digo de pa�s o regi�n de la direcci�n.';
                Visible=FALSE ;
    }
    field("Bill-to Contact";rec."Bill-to Contact")
    {
        
                ToolTipML=ENU='Specifies the name of the person you should contact at the customer who you are sending the invoice to.',ESP='Especifica el nombre de la persona con quien contactarse cuando es necesario comunicarse con el cliente al que se enviar� la factura.';
                Visible=FALSE ;
    }
    field("Ship-to Code";rec."Ship-to Code")
    {
        
                ToolTipML=ENU='Specifies the code for another shipment address than the customers own address, which is entered by default.',ESP='Especifica el c�digo para otra direcci�n de env�o distinta a la propia direcci�n del cliente, que se especifica de forma predeterminada.';
                Visible=FALSE ;
    }
    field("Ship-to Name";rec."Ship-to Name")
    {
        
                ToolTipML=ENU='Specifies the name that products on the sales document will be shipped to.',ESP='Especifica el nombre al que se enviar�n los productos en el documento de venta.';
                Visible=FALSE ;
    }
    field("Ship-to Post Code";rec."Ship-to Post Code")
    {
        
                ToolTipML=ENU='Specifies the postal code of the address.',ESP='Especifica el c�digo postal de la direcci�n.';
                Visible=FALSE ;
    }
    field("Ship-to Country/Region Code";rec."Ship-to Country/Region Code")
    {
        
                ToolTipML=ENU='Specifies the country/region code of the address.',ESP='Especifica el c�digo de pa�s o regi�n de la direcci�n.';
                Visible=FALSE ;
    }
    field("Ship-to Contact";rec."Ship-to Contact")
    {
        
                ToolTipML=ENU='Specifies the name of the contact person at the address that products will be shipped to.',ESP='Especifica el nombre de la persona de contacto que consta en la direcci�n a la que se enviar�n los productos.';
                Visible=FALSE ;
    }
    field("Posting Date";rec."Posting Date")
    {
        
                ToolTipML=ENU='Specifies the date when the posting of the sales document will be recorded.',ESP='Especifica la fecha en que se registrar� el registro del documento de venta.';
                Visible=FALSE ;
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
                ToolTipML=ENU='Specifies the dimension value code associated with the sales header.',ESP='Especifica el c�digo del valor de dimensi�n asociado a la cabecera de ventas.';
                Visible=FALSE ;
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
                ToolTipML=ENU='Specifies the dimension value code associated with the sales header.',ESP='Especifica el c�digo del valor de dimensi�n asociado a la cabecera de ventas.';
                Visible=FALSE ;
    }
    field("Location Code";rec."Location Code")
    {
        
                ToolTipML=ENU='Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.',ESP='Especifica la ubicaci�n desde la que se env�an de forma predeterminada los productos de inventario al cliente en el documento de venta.';
    }
    field("Salesperson Code";rec."Salesperson Code")
    {
        
                ToolTipML=ENU='Specifies the name of the sales person who is assigned to the customer.',ESP='Especifica el nombre de vendedor asignado al cliente.';
                Visible=FALSE ;
    }
    field("Assigned User ID";rec."Assigned User ID")
    {
        
                ToolTipML=ENU='Specifies the ID of the user who is responsible for the document.',ESP='Especifica el id. del usuario responsable del documento.';
                ApplicationArea=Basic,Suite;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the currency of amounts on the sales document.',ESP='Especifica la divisa de los importes en el documento de venta.';
                Visible=FALSE ;
    }
    field("Document Date";rec."Document Date")
    {
        
                ToolTipML=ENU='Specifies the date on which you created the sales document.',ESP='Especifica la fecha de creaci�n del documento de venta.';
                ApplicationArea=Basic,Suite;
    }
    field("Status";rec."Status")
    {
        
                ToolTipML=ENU='Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the Rec.NEXT stage of processing.',ESP='Especifica si el documento est� pendiente, en espera de aprobaci�n, facturado para prepago o ha pasado a la etapa siguiente de procesamiento.';
                ApplicationArea=Basic,Suite;
    }

}

}
area(FactBoxes)
{
    part("DropArea";7174655)
    {
        ;
    }
    part("FilesSP";7174656)
    {
        ;
    }
    part("IncomingDocAttachFactBox";193)
    {
        
                Visible=FALSE;
                ShowFilter=false ;
    }
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=FALSE;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
                      Image=Line ;
    action("action1")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      ToolTipML=ENU='View or change detailed information about the customer.',ESP='Permite ver o cambiar la informaci�n detallada sobre el cliente.';
                      ApplicationArea=Basic,Suite;
                      Image=EditLines;
                      
                                trigger OnAction()    VAR
                                 PageManagement : Codeunit 700;
                               BEGIN
                                 PageManagement.PageRun(Rec);
                               END;


    }

}

}
area(Reporting)
{

    action("action2")
    {
        CaptionML=ENU='Sales Reservation Avail.',ESP='Disponib. reserva venta';
                      ToolTipML=ENU='View, print, or save an overview of availability of items for shipment on sales documents, filtered on shipment status.',ESP='Permite ver, imprimir o guardar la informaci�n general sobre la disponibilidad de productos para su env�o en documentos de venta, filtrados por estado de env�o.';
                      RunObject=Report 209;
                      Image=Report;
    
    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 rec.CopySellToCustomerFilter;

                 //QUONEXT 20.07.17 DRAG&DROP. Actualizaci�n de los ficheros.
                 CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Sales Header");
                 ///FIN QUONEXT 20.07.17
               END;

trigger OnAfterGetCurrRecord()    BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //QUONEXT 20.07.17 DRAG&DROP.
                           CurrPage.DropArea.PAGE.SetFilter(Rec);
                           CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           ///FIN QUONEXT 20.07.17
                         END;




    /*begin
    end.
  
*/
}









page 52200 "Customer Template Card"
{
CaptionML=ENU='Customer Template Card',ESP='Ficha plant. cliente';
    SourceTable="Customer Templ.";
    PageType=Card;
  layout
{
area(content)
{
group("Control1")
{
        
                CaptionML=ENU='General',ESP='General';
    field("Code";rec."Code")
    {
        
                ToolTipML=ENU='Specifies the code for the customer template. You can set up as many codes as you want. The code must be unique. You cannot have the same code twice in one table.',ESP='Especifica el c�digo de la plantilla de cliente. Puede configurar tantos c�digos como desee. El c�digo debe ser exclusivo y recuerde que no puede tener el mismo c�digo dos veces en la misma tabla.';
                ApplicationArea=All;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies the description of the customer template.',ESP='Especifica la descripci�n del grupo de plantillas de cliente.';
                ApplicationArea=All;
    }
    field("Contact Type";rec."Contact Type")
    {
        
                ToolTipML=ENU='Specifies the contact type of the customer template.',ESP='Especifica el tipo de contacto de la plantilla del cliente.';
                ApplicationArea=All;
    }
    field("Country/Region Code";rec."Country/Region Code")
    {
        
                ToolTipML=ENU='Specifies the country/region of the address.',ESP='Especifica el pa�s o la regi�n de la direcci�n.';
                ApplicationArea=Basic,Suite;
    }
    field("Territory Code";rec."Territory Code")
    {
        
                ToolTipML=ENU='Specifies the territory code for the customer template.',ESP='Especifica el c�digo de territorio de la plantilla de cliente.';
                ApplicationArea=RelationshipMgmt;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the currency code for the customer template.',ESP='Especifica el c�digo de divisa de la plantilla de cliente.';
                ApplicationArea=Suite;
    }
    field("Gen. Bus. Posting Group";rec."Gen. Bus. Posting Group")
    {
        
                ToolTipML=ENU='Specifies the vendors or customers trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.',ESP='Especifica el tipo de comercio del cliente o el proveedor para vincular las transacciones realizadas para este socio comercial con la cuenta de contabilidad general correspondiente seg�n la configuraci�n de registro general.';
                ApplicationArea=Basic,Suite;
    }
    field("VAT Bus. Posting Group";rec."VAT Bus. Posting Group")
    {
        
                ToolTipML=ENU='Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.',ESP='Indica la especificaci�n de IVA del cliente o el proveedor relacionado para vincular las transacciones realizadas para este registro con la cuenta de contabilidad general correspondiente de acuerdo con la configuraci�n de registro de IVA.';
                ApplicationArea=Basic,Suite;
    }
    field("Customer Posting Group";rec."Customer Posting Group")
    {
        
                ToolTipML=ENU='Specifies a code for the customer posting group to which the customer template will belong. To see the customer posting group codes in the Customer Posting Groups window, click the field.',ESP='Especifica el c�digo del grupo de registro de cliente al que pertenecer� la plantilla de cliente. Para ver los c�digos de grupo de registro de cliente en la ventana Grupos registro clientes, haga clic en el campo.';
                ApplicationArea=Basic,Suite;
    }
    field("Customer Price Group";rec."Customer Price Group")
    {
        
                ToolTipML=ENU='Specifies a code for the customer price group to which the customer template will belong. To see the price group codes in the Customer Price Groups window, click the field.',ESP='Especifica el c�digo del grupo de precios de cliente al que pertenecer� la plantilla de cliente. Para ver los c�digos de grupo de precios en la ventana Grupos precio cliente, haga clic en el campo.';
                ApplicationArea=Basic,Suite;
    }
    field("Customer Disc. Group";rec."Customer Disc. Group")
    {
        
                ToolTipML=ENU='Specifies the code for the customer discount group to which the customer template will belong. To see the customer discount group codes in the Customer Discount Group table, click the field.',ESP='Especifica el c�digo del grupo de descuentos de cliente al que pertenecer� la plantilla de cliente. Para ver los c�digos de grupo de descuentos de cliente en la tabla Grupo descuento cliente, haga clic en el campo.';
                ApplicationArea=Basic,Suite;
    }
    field("Allow Line Disc.";rec."Allow Line Disc.")
    {
        
                ToolTipML=ENU='Specifies that a line discount is calculated when the sales price is offered.',ESP='Especifica que se calcula un descuento de l�nea cuando se ofrece el precio de venta.';
                ApplicationArea=RelationshipMgmt;
    }
    field("Invoice Disc. Code";rec."Invoice Disc. Code")
    {
        
                ToolTipML=ENU='Specifies the invoice discount code for the customer template.',ESP='Especifica el c�digo de descuento en factura para la plantilla de cliente.';
                ApplicationArea=RelationshipMgmt;
    }
    field("Prices Including VAT";rec."Prices Including VAT")
    {
        
                ToolTipML=ENU='Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.',ESP='Especifica si los campos Precio venta e Importe l�nea en las l�neas de documento deben mostrarse con o sin IVA.';
                ApplicationArea=Basic,Suite;
    }
    field("Payment Terms Code";rec."Payment Terms Code")
    {
        
                ToolTipML=ENU='Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.',ESP='Especifica una f�rmula que calcula la fecha de vencimiento del pago, la fecha de descuento por pronto pago y el importe de descuento por pronto pago.';
                ApplicationArea=RelationshipMgmt;
    }
    field("Payment Method Code";rec."Payment Method Code")
    {
        
                ToolTipML=ENU='Specifies how to make payment, such as with bank transfer, cash, or check.',ESP='Especifica c�mo realizar el pago, por ejemplo transferencia bancaria, en efectivo o con cheque.';
                ApplicationArea=RelationshipMgmt;
    }
    field("Shipment Method Code";rec."Shipment Method Code")
    {
        
                ToolTipML=ENU='Specifies the delivery conditions of the related shipment, such as free on board (FOB).',ESP='Especifica las condiciones de entrega del env�o en cuesti�n, como franco a bordo (FOB).';
                ApplicationArea=RelationshipMgmt;
    }

}

}
area(FactBoxes)
{
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

group("group29")
{
        CaptionML=ENU='&Customer Template',ESP='&Plantilla cliente';
                      Image=Template ;
    action("Action31")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      ToolTipML=ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',ESP='Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                      ApplicationArea=Dimensions;
                      RunObject=Page 540;
RunPageLink="Table ID"=CONST(5105), "No."=FIELD("Code");
                      Image=Dimensions ;
    }
    action("CopyTemplate")
    {
        
                      CaptionML=ENU='Copy Template',ESP='Copiar plantilla';
                      ToolTipML=ENU='Copies all information to the current customer template from the selected one.',ESP='Copia toda la informaci�n en la plantilla de configuraci�n seleccionada desde la actual.';
                      ApplicationArea=Basic,Suite;
                      Image=Copy;
                      
                                trigger OnAction()    VAR
                                 CustomerTemplate : Record "Customer Templ.";
                                 CustomerTemplateList : Page 52199;
                               BEGIN
                                 Rec.TESTFIELD(Code);
                                 CustomerTemplate.SETFILTER(Code,'<>%1',rec.Code);
                                 CustomerTemplateList.LOOKUPMODE(TRUE);
                                 CustomerTemplateList.SETTABLEVIEW(CustomerTemplate);
                                 IF CustomerTemplateList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                   CustomerTemplateList.GETRECORD(CustomerTemplate);
                                  //  rec.CopyTemplate(CustomerTemplate);
                                 END;
                               END;


    }

}
group("group27")
{
        CaptionML=ENU='S&ales',ESP='Ve&ntas';
                      Image=Sales ;
    action("Action28")
    {
        CaptionML=ENU='Invoice &Discounts',ESP='Dto. &factura';
                      ToolTipML=ENU='Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.',ESP='Configurar descuentos diferentes que se aplican a las facturas para el cliente. Un descuento de factura se concede autom�ticamente al cliente cuando el total de una factura de venta supera un importe determinado.';
                      ApplicationArea=RelationshipMgmt;
                      RunObject=Page 23;
RunPageLink="Code"=FIELD("Invoice Disc. Code");
                      Image=CalculateInvoiceDiscount 
    ;
    }

}

}
}
  

    /*begin
    end.
  
*/
}





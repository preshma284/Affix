page 7206958 "QB Framework Contr. Subfor"
{
CaptionML=ENU='Lines',ESP='L�neas';
    MultipleNewLines=true;
    LinksAllowed=false;
    SourceTable=7206938;
    DelayedInsert=true;
    PageType=ListPart;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Type";rec."Type")
    {
        
                ToolTipML=ENU='Specifies the line type.',ESP='Especifica el tipo de l�nea.';
                ApplicationArea=Suite;
    }
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                ApplicationArea=Suite;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a description of the blanket purchase order.',ESP='Especifica una descripci�n del pedido de compra abierto.';
                ApplicationArea=Suite;
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
                ToolTipML=ENU='Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.',ESP='Especifica c�mo se mide cada unidad del producto o el recurso, por ejemplo, en piezas u horas. De forma predeterminada, se inserta el valor en el campo Unidad de medida base de la ficha de producto o recurso.';
                ApplicationArea=Suite;
    }
    field("Direct Unit Cost";rec."Direct Unit Cost")
    {
        
                ToolTipML=ENU='Specifies the cost of one unit of the selected item or resource.',ESP='Especifica el coste unitario del producto o recurso seleccionado.';
                ApplicationArea=Suite;
                BlankZero=true;
    }
    field("Quantity Max";rec."Quantity Max")
    {
        
                ToolTipML=ENU='Specifies the quantity of the purchase order line.',ESP='Especifica la cantidad de la l�nea de pedido de compra.';
                ApplicationArea=Suite;
                BlankZero=true;
    }
    field("Quantity in Comparatives";rec."Quantity in Comparatives")
    {
        
                ToolTipML=ESP='Cantidad en l�neas de comparativos (dato informativo, hasta que no sea un pedido de compra no se controla el m�ximo)';
    }
    field("Quantity in Orders";rec."Quantity in Orders")
    {
        
                ToolTipML=ESP='Cantidad en pedidos de compra';
    }
    field("Quantity in Shipmets";rec."Quantity in Shipmets")
    {
        
                ToolTipML=ESP='Cantidad en albaranes de compra (dato informativo, el control es a trav�s del pedido y las facturas)';
    }
    field("Quantity in Invoices";rec."Quantity in Invoices")
    {
        
                ToolTipML=ESP='Cantidad en facturas de compra registradas';
    }
    field("Unit Cost (LCY)";rec."Unit Cost (LCY)")
    {
        
                ToolTipML=ENU='Specifies the cost, in LCY, of one unit of the item or resource on the line.',ESP='Especifica el coste, en DL, de una unidad del producto o recurso en la l�nea.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Line Discount %";rec."Line Discount %")
    {
        
                ToolTipML=ENU='Specifies the discount percentage that is granted for the item on the line.',ESP='Especifica el porcentaje de descuento aplicable al producto de la l�nea.';
                ApplicationArea=Suite;
                BlankZero=true;
                Visible=false ;
    }
    field("Line Discount Amount";rec."Line Discount Amount")
    {
        
                ToolTipML=ENU='Specifies the discount amount that is granted for the item on the line.',ESP='Especifica la cantidad de descuento aplicable al producto de la l�nea.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }

}
group("group18")
{
        
                Visible=False;
group("group19")
{
        
    field("AmountBeforeDiscount";TotalPurchaseLine."Line Amount")
    {
        
                CaptionML=ENU='Subtotal Excl. VAT',ESP='Subtotal IVA excl.';
                ToolTipML=ENU='Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.',ESP='Especifica la suma del valor del campo "Importe l�nea excl. IVA" en todas las l�neas del documento.';
                ApplicationArea=Suite;
                AutoFormatType=1;
                AutoFormatExpression=rec."Currency Code";
                CaptionClass=DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalPurchaseHeader."Prices Including VAT");
                Editable=FALSE ;
    }
    field("Invoice Discount Amount";"InvoiceDiscountAmount")
    {
        
                CaptionML=ENU='Invoice Discount Amount',ESP='Importe descuento factura';
                ToolTipML=ENU='Specifies a discount amount that is deducted from the value in the Total Incl. VAT field.',ESP='Especifica un importe de descuento que se deduce del valor del campo Total IVA incl.';
                ApplicationArea=Suite;
                AutoFormatType=1;
                AutoFormatExpression=rec."Currency Code";
                CaptionClass=DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(rec.FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                Editable=InvDiscAmountEditable ;
    }
    field("Invoice Disc. Pct.";"InvoiceDiscountPct")
    {
        
                CaptionML=ENU='Invoice Discount %',ESP='% descuento en factura';
                ToolTipML=ENU='Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.',ESP='Especifica un porcentaje de descuento que se concede si se cumplen los criterios que ha configurado para el cliente.';
                ApplicationArea=Suite;
                DecimalPlaces=0:2;
                Editable=InvDiscAmountEditable ;
    }

}
group("group23")
{
        
    field("Total Amount Excl. VAT";TotalPurchaseLine.Amount)
    {
        
                DrillDown=false;
                CaptionML=ENU='Total Amount Excl. VAT',ESP='Importe total excl. IVA';
                ToolTipML=ENU='Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.',ESP='Especifica la suma del valor del campo Importe l�n. IVA exc. en todas las l�neas del documento menos cualquier importe de descuento en el campo Importe descuento factura.';
                ApplicationArea=Suite;
                AutoFormatType=1;
                AutoFormatExpression=rec."Currency Code";
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE ;
    }
    field("Total VAT Amount";"VATAmount")
    {
        
                CaptionML=ENU='Total VAT',ESP='IVA total';
                ToolTipML=ENU='Specifies the sum of VAT amounts on all lines in the document.',ESP='Especifica la suma de los importes de IVA en todas las l�neas del documento.';
                ApplicationArea=Suite;
                AutoFormatType=1;
                AutoFormatExpression=rec."Currency Code";
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE ;
    }
    field("Total Amount Incl. VAT";TotalPurchaseLine."Amount Including VAT")
    {
        
                CaptionML=ENU='Total Amount Incl. VAT',ESP='Importe total incl. IVA';
                ToolTipML=ENU='Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.',ESP='Especifica la suma del valor del campo Importe l�n. IVA inc. en todas las l�neas del documento menos cualquier importe de descuento en el campo Importe descuento factura.';
                ApplicationArea=Suite;
                AutoFormatType=1;
                AutoFormatExpression=rec."Currency Code";
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE ;
    }
    field("RefreshTotals";'')
    {
        
                ApplicationArea=Suite;
                Visible=FALSE;
                Enabled=FALSE;
                Editable=FALSE;
                ShowCaption=false 

  ;
    }

}

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ENU='E&xplode BOM',ESP='Uso';
                      RunObject=Page 7206991;
RunPageLink="Framework Contr. No."=FIELD("Document No."), "Framework Contr. Line"=FIELD("Line No.");
                      Image=ExplodeBOM 
    ;
    }

}
}
  trigger OnInit()    BEGIN
             PurchasesPayablesSetup.GET;
             Currency.InitRoundingPrecision;
           END;

trigger OnFindRecord(Which: Text): Boolean    BEGIN
                   //DocumentTotals.PurchaseCheckAndClearTotals(Rec,xRec,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
                   EXIT(Rec.FIND(Which));
                 END;

trigger OnAfterGetRecord()    BEGIN
                       //ShowShortcutDimCode(ShortcutDimCode);
                       //CLEAR(DocumentTotals);
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  CLEAR(ShortcutDimCode);
                END;

trigger OnModifyRecord(): Boolean    BEGIN
                     //DocumentTotals.PurchaseCheckIfDocumentChanged(Rec,xRec);
                   END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     DocumentTotals.PurchaseDocTotalsNotUpToDate;
                   END;



    var
      TotalPurchaseHeader : Record 38;
      TotalPurchaseLine : Record 39;
      PurchLine : Record 39;
      CurrentPurchLine : Record 39;
      Currency : Record 4;
      PurchasesPayablesSetup : Record 312;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      PurchCalcDiscByType : Codeunit 66;
      DocumentTotals : Codeunit 57;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      VATAmount : Decimal;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      AmountWithDiscountAllowed : Decimal;
      InvDiscAmountEditable : Boolean;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l�neas. No se tendr� en cuenta el descuento distribuido entre las l�neas facturadas.\\�Desea actualizar el descuento en factura?';

    /*begin
    end.
  
*/
}









page 7207004 "QB Proform Subform"
{
CaptionML=ENU='Lines',ESP='L�neas';
    InsertAllowed=false;
    LinksAllowed=false;
    SourceTable=7206961;
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
                ApplicationArea=Advanced;
    }
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                ApplicationArea=Suite;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a description of the item or service on the line.',ESP='Permite especificar una descripci�n del producto o servicio en la l�nea.';
                ApplicationArea=Suite;
                Editable=isEditable ;
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
                ToolTipML=ENU='Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.',ESP='Especifica c�mo se mide cada unidad del producto o el recurso, por ejemplo, en piezas u horas. De forma predeterminada, se inserta el valor en el campo Unidad de medida base de la ficha de producto o recurso.';
                ApplicationArea=Suite;
                Editable=isEditable ;
    }
    field("Unit of Measure";rec."Unit of Measure")
    {
        
                ToolTipML=ENU='Specifies the name of the item or resources unit of measure, such as piece or hour.',ESP='Especifica el nombre de la unidad de medida del producto o recurso, como la unidad o la hora.';
                ApplicationArea=Suite;
                Visible=FALSE;
                Editable=isEditable ;
    }
    field("Direct Unit Cost";rec."Direct Unit Cost")
    {
        
    }
    field("Line Discount %";rec."Line Discount %")
    {
        
    }
    field("QB Qty. In Order";rec."QB Qty. In Order")
    {
        
    }
    field("QB Recurrent Line";rec."QB Recurrent Line")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
                ToolTipML=ENU='Specifies the quantity of the item or service on the line.',ESP='Especifica la cantidad del producto o servicio en la l�nea.';
                ApplicationArea=Suite;
                BlankZero=true;
                Enabled=isEditable;
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Amount";rec."Amount")
    {
        
    }
    field("QB Qty. Proformed Origin";rec."QB Qty. Proformed Origin")
    {
        
                ToolTipML=ENU='Specifies the quantity of the item or service on the line.',ESP='Especifica la cantidad del producto o servicio en la l�nea.';
                ApplicationArea=Suite;
                BlankZero=true;
    }
    field("QB Proform Amount Origin";rec."QB Proform Amount Origin")
    {
        
    }
    field("QB Qty Received Origin";rec."QB Qty Received Origin")
    {
        
                BlankZero=true;
    }
    field("QB Proform Amount Received";rec."QB Proform Amount Received")
    {
        
    }
    field("Quantity Invoiced";rec."Quantity Invoiced")
    {
        
                ToolTipML=ENU='Specifies how many units of the item on the line have been posted as invoiced.',ESP='Especifica cu�ntas unidades del producto que figura en la l�nea se han registrado como facturadas.';
                ApplicationArea=Suite;
                BlankZero=true;
    }
    field("QB Proform Amount Invoiced";rec."QB Proform Amount Invoiced")
    {
        
    }
    field("Qty. Rcd. Not Invoiced";rec."Qty. Rcd. Not Invoiced")
    {
        
                ToolTipML=ENU='Specifies how many units of the item on the line have been received and not yet invoiced.',ESP='Especifica el n�mero de unidades del producto que consta en esta l�nea que se han recibido, pero que a�n no se facturaron.';
                ApplicationArea=Suite;
                Visible=FALSE;
                Editable=FALSE ;
    }
    field("Job No.";rec."Job No.")
    {
        
                ToolTipML=ENU='Specifies the number of the related job.',ESP='Especifica el n�mero del proyecto relacionado.';
                ApplicationArea=Jobs;
    }
    field("Piecework Nº";rec."Piecework Nº")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
                ToolTipML=ENU='Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.',ESP='Especifica el c�digo de dimensi�n del acceso directo 1, que es uno de los dos c�digos de dimensi�n globales que se configuran en la ventana Configuraci�n de contabilidad.';
                ApplicationArea=Dimensions;
                Visible=FALSE ;
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
                ToolTipML=ENU='Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.',ESP='Especifica el c�digo de dimensi�n del acceso directo 2, que es uno de los dos c�digos de dimensi�n globales que se configuran en la ventana Configuraci�n de contabilidad.';
                ApplicationArea=Dimensions;
                Visible=FALSE ;
    }
    field("Order No.";rec."Order No.")
    {
        
    }
    field("Order Line No.";rec."Order Line No.")
    {
        
    }

}
group("group32")
{
        
                CaptionML=ESP='Totales';
    field("TAmount";TAmount)
    {
        
                CaptionML=ESP='Importe Periodo (Base)';
                Editable=false;
                Style=Attention;
                StyleExpr=stNeg ;
    }
    field("TOrigin";TOrigin)
    {
        
                CaptionML=ESP='Importe Origen (Base)';
                Editable=false 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ESP='Traer L�neas';
                      // PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 QBProformHeader.GET(rec."Document No.");
                                 QBProformHeader.AddLines();
                               END;


    }
group("group3")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
                      Image=Line ;
    action("Dimensions")
    {
        
                      AccessByPermission=TableData 348=R;
                      ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      ToolTipML=ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',ESP='Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                      ApplicationArea=Dimensions;
                      Image=Dimensions;
                      
                                trigger OnAction()    BEGIN
                                 rec.ShowDimensions;
                               END;


    }
    action("Comments")
    {
        
                      CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      ToolTipML=ENU='View or add comments for the record.',ESP='Permite ver o agregar comentarios para el registro.';
                      ApplicationArea=Comments;
                      Image=ViewComments;
                      
                                
    trigger OnAction()    BEGIN
                                 rec.ShowLineComments;
                               END;


    }

}

}
}
  trigger OnInit()    VAR
             ApplicationAreaMgmtFacade : Codeunit 9179;
           BEGIN
           END;

trigger OnAfterGetRecord()    BEGIN
                       OnAfterGet;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           OnAfterGet;
                         END;



    var
      QBProformHeader : Record 7206960;
      QBProformLine : Record 7206961;
      isEditable : Boolean;
      TAmount : Decimal;
      TOrigin : Decimal;
      stNeg : Boolean;

    LOCAL procedure OnAfterGet();
    begin
      //JAV 18/11/20: - QB 1.07.05 Calculamos los importes totales del documento, establecemos los estilos y si es editable
      QBProformHeader.GET(rec."Document No.");
      QBProformHeader.CalculateTotal(TAmount, TOrigin);
      stNeg := (TAmount <= 0);
      isEditable := (not QBProformHeader.Validated) and (QBProformHeader."Invoice No." = '');  //JAV 20/07/21: - QB 1.09.10 Si la proforma est� validada o tiene n�mero de factura ya no se puede tocar
    end;

    // begin
    /*{
      JAV 18/11/20: - QB 1.07.05 Se a�aden columnas para, precio e importe de la l�nea, para cantidad e importe a origen de la l�nea, para Pedido y l�nea del pedido
      JAV 20/07/21: - QB 1.09.10 Si la proforma est� validada o tiene n�mero de factura ya no se puede tocar
    }*///end
}








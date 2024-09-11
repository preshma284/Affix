page 7206933 "QB Crear Efectos lineas"
{
CaptionML=ESP='L�neas de Creaci�n de Efectos';
    SourceTable=7206923;
    PageType=ListPart;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Line No.";rec."Line No.")
    {
        
                Visible=false ;
    }
    field("Tipo Linea";rec."Tipo Linea")
    {
        
                Editable=edGenerado;
                
                            ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Vendor No.";rec."Vendor No.")
    {
        
                Editable=edGenerado;
                

                ShowMandatory=True ;trigger OnValidate()    BEGIN
                             Rec.CALCFIELDS("Importe Anticipos");
                           END;


    }
    field("Recipient Bank Account";rec."Recipient Bank Account")
    {
        
                Visible=false;
                Editable=edGenerado ;
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
                Editable=edGenerado;
                

                ShowMandatory=True ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Bill No.";rec."Bill No.")
    {
        
    }
    field("Liquida Documento";rec."Liquida Documento")
    {
        
                Enabled=edLiquida;
                Editable=edGenerado;
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE(FALSE);
                           END;


    }
    field("No. Pagare";rec."No. Pagare")
    {
        
                Enabled=edPagareNro;
                
                            ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Include in Payment Order";rec."Include in Payment Order")
    {
        
                Enabled=actRelacion;
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("No. Agrupacion";rec."No. Agrupacion")
    {
        
                Editable=false ;
    }
    field("Importe Anticipos";rec."Importe Anticipos")
    {
        
                BlankZero=true;
                Style=Ambiguous;
                StyleExpr=TRUE ;
    }
    field("Description1";rec."Description1")
    {
        
                CaptionML=ENU='Description',ESP='Descripci�n Linea';
                Visible=false;
                Editable=edGenerado;
                ShowMandatory=True ;
    }
    field("Description2";rec."Description2")
    {
        
                CaptionML=ENU='Description',ESP='Descripci�n Linea 2';
                Visible=False;
                Editable=edGenerado ;
    }
    field("Job No.";rec."Job No.")
    {
        
                Enabled=edAnticipado;
                Editable=edGenerado ;
    }
    field("External Document No.";rec."External Document No.")
    {
        
                Enabled=edAnticipado;
                Editable=edGenerado;
                
                            ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Document Date";rec."Document Date")
    {
        
                Enabled=edAnticipado;
                Editable=edGenerado ;
    }
    field("Original Due Date";rec."Original Due Date")
    {
        
    }
    field("Due Date";rec."Due Date")
    {
        
                Editable=edGenerado;
                Style=Attention;
                StyleExpr=stVencimiento;
                

                ShowMandatory=True ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Currency Code";rec."Currency Code")
    {
        
                Visible=false ;
    }
    field("Payment Method Code";rec."Payment Method Code")
    {
        
                Editable=edFP;
                Style=Attention;
                StyleExpr=stFormaPago;
                
                            ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Payment Terms Code";rec."Payment Terms Code")
    {
        
                Editable=edFP ;
    }
    field("Amount";rec."Amount")
    {
        
                BlankZero=true;
                Editable=edGenerado;
                

                ShowMandatory=True ;trigger OnValidate()    BEGIN
                             setCampos;
                           END;


    }
    field("Importe Aplicado";rec."Importe Aplicado")
    {
        
    }
    field("Importe Pendiente";rec."Importe Pendiente")
    {
        
    }
    field("Printed";rec."Printed")
    {
        
    }
    field("Carta";rec."Carta")
    {
        
    }
    field("Exported to Payment File";rec."Exported to Payment File")
    {
        
    }
    field("Texto Error";rec."Texto Error")
    {
        
    }
    field("No. Mov. Proveedor";rec."No. Mov. Proveedor")
    {
        
                Visible=false ;
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }

}
group("group50")
{
        
                CaptionML=ESP='Totales';
    field("Cabecera.Total Amount";Cabecera."Total Amount")
    {
        
                CaptionML=ESP='Total Documentos';
    }
    field("Cabecera.Total Payment Order Amount";Cabecera."Total Payment Order Amount")
    {
        
                CaptionML=ESP='Total Orden de Pago';
    }

}

}
}actions
{
area(Processing)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
                      Image=Line ;
    action("Dividir")
    {
        
                      AccessByPermission=TableData 348=R;
                      CaptionML=ENU='Dimensions',ESP='Dividir';
                      ToolTipML=ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',ESP='Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Image=CalculateLines;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 cuRelaciones : Codeunit 7206922;
                               BEGIN
                                 cuRelaciones.DividirLinea(rec."Relacion No.", rec."Line No.");
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("Dimensiones")
    {
        
                      AccessByPermission=TableData 348=R;
                      ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      ToolTipML=ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',ESP='Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 rec.ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;


    }

}
group("group5")
{
        CaptionML=ENU='A&ccount',ESP='Proveedor';
                      Image=Vendor ;
    action("action3")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      ToolTipML=ENU='View or change detailed information about the record on the document or journal line.',ESP='Permite ver o cambiar la informaci�n del proveedor';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 26;
RunPageLink="No."=FIELD("Vendor No.");
                      Image=EditLines ;
    }
    action("action4")
    {
        ShortCutKey='Ctrl+F7';
                      CaptionML=ENU='Ledger E&ntries',ESP='Movimien&tos';
                      ToolTipML=ENU='View the history of transactions that have been posted for the selected record.',ESP='Permite ver el historial de transacciones pendientes que se han registrado para el proveedor seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 29;
                      RunPageView=SORTING("Vendor No.")
                                  ORDER(Descending)
                                  WHERE("Open"=CONST(true));
RunPageLink="Vendor No."=FIELD("Vendor No.");
                      // Promoted=false;
                      Image=VendorLedger;
                      // PromotedCategory=Process ;
    }
    action("action5")
    {
        CaptionML=ENU='Ledger E&ntries',ESP='&Movimiento';
                      ToolTipML=ENU='View the history of transactions that have been posted for the selected record.',ESP='Permite ver el historial de transacciones pendientes que se han registrado para el proveedor seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 29;
                      RunPageView=SORTING("Vendor No.");
RunPageLink="Entry No."=FIELD("No. Mov. Proveedor");
                      // Promoted=false;
                      Image=VendorLedger;
                      // PromotedCategory=Process ;
    }

}
group("group9")
{
        CaptionML=ESP='Pagar�';
                      Visible=actImprimePagare;
                      Image=Check ;
    action("CheckPrint")
    {
        
                      AccessByPermission=TableData 272=R;
                      Ellipsis=true;
                      CaptionML=ENU='Print Check',ESP='Reimprimir';
                      ToolTipML=ENU='Prepare to print the check.',ESP='Prepara el cheque para imprimir.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Enabled=actPagare;
                      Image=PrintCheck;
                      PromotedCategory=Category5;
                      
                                trigger OnAction()    VAR
                                 QBFuncionesPagares : Codeunit 7206922;
                               BEGIN
                                 Cabecera.GET(rec."Relacion No.");
                                 QBFuncionesPagares.ImprimirPagares(Cabecera, rec."No. Pagare");

                                 setCampos();
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("action7")
    {
        CaptionML=ESP='Carta';
                      
                                trigger OnAction()    VAR
                                 QBFuncionesPagares : Codeunit 7206922;
                               BEGIN
                                 Cabecera.GET(rec."Relacion No.");
                                 QBFuncionesPagares.ImprimirCarta(Cabecera, rec."No. Pagare");
                               END;


    }

}
group("group12")
{
        CaptionML=ESP='Relaci�n';
                      Visible=actImprimePagare;
                      Image=SNInfo ;
    action("Mark")
    {
        
                      Ellipsis=true;
                      CaptionML=ESP='Marcar Todos';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Enabled=actRelacion;
                      Image=Check;
                      PromotedCategory=Category5;
                      
                                trigger OnAction()    VAR
                                 QBFuncionesPagares : Codeunit 7206922;
                               BEGIN
                                 Linea.RESET;
                                 Linea.SETRANGE("Relacion No.",rec."Relacion No.");
                                 Linea.MODIFYALL("Include in Payment Order", TRUE);
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("UnMark")
    {
        
                      CaptionML=ESP='Desmarcar Todos';
                      Enabled=actRelacion;
                      Image=Undo;
                      
                                
    trigger OnAction()    VAR
                                 QBFuncionesPagares : Codeunit 7206922;
                               BEGIN
                                 Linea.RESET;
                                 Linea.SETRANGE("Relacion No.",rec."Relacion No.");
                                 Linea.MODIFYALL("Include in Payment Order", FALSE);
                                 CurrPage.UPDATE(FALSE);
                               END;


    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
                 setCampos;
               END;

trigger OnAfterGetRecord()    BEGIN
                       setCampos;
                     END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     CurrPage.UPDATE;
                   END;

trigger OnAfterGetCurrRecord()    BEGIN
                           setCampos;
                         END;



    var
      FunctionQB : Codeunit 7207272;
      Cabecera : Record 7206922;
      Linea : Record 7206923;
      PaymentMethod : Record 289;
      edGenerado : Boolean ;
      edPagareNro : Boolean ;
      edPagareRep : Boolean ;
      editable_ : Boolean ;
      edAnticipado : Boolean ;
      edLiquida : Boolean ;
      edFP : Boolean ;
      actPagare : Boolean ;
      actImprimePagare : Boolean ;
      stVencimiento : Boolean ;
      stFormaPago : Boolean ;
      actRelacion : Boolean;

    LOCAL procedure setCampos();
    begin
      if not Cabecera.GET(rec."Relacion No.") then
        CLEAR(Cabecera);

      edPagareNro := (rec."Tipo Linea" <> rec."Tipo Linea"::Abono) and (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::"Manual Check");
      edGenerado := ((edPagareNro) or (rec."No. Pagare" = '')) and (not Cabecera.Registrada);
      edFP := (not Cabecera.Registrada);

      if (rec."No. Pagare" = '') then begin
        edPagareRep := rec.Printed;
        edAnticipado := (rec."Tipo Linea" = rec."Tipo Linea"::Anticipado);
        edLiquida := (rec."Tipo Linea" = rec."Tipo Linea"::Abono);
      end ELSE begin
        edPagareRep := FALSE;
        edAnticipado := FALSE;
        edLiquida := FALSE;
      end;

      stVencimiento := (rec."Due Date" < Cabecera."Posting Date");
      stFormaPago := FALSE;
      if (PaymentMethod.GET(rec."Payment Method Code")) then
        stFormaPago := (PaymentMethod."Create Bills" = FALSE);

      actImprimePagare := not Cabecera.Registrada;
      actPagare := (rec."No. Pagare" <> '');
      actRelacion := (Cabecera."Bank Payment Type" = Cabecera."Bank Payment Type"::OrdenPago);

      Rec.CALCFIELDS("Importe Anticipos");
      Cabecera.CALCFIELDS("Total Amount", "Total Payment Order Amount");
    end;

    // begin//end
}









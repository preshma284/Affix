page 7206937 "QB Liq. Efectos lineas"
{
CaptionML=ESP='L�neas de Liquidaci�n de Efectos';
    SourceTable=7206925;
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
    field("Liquidar";rec."Liquidar")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             Recalcular;
                             CurrPage.UPDATE;
                           END;


    }
    field("Vendor No.";rec."Vendor No.")
    {
        
                ShowMandatory=True ;
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
                Style=Attention;
                StyleExpr=stDocumento;
                ShowMandatory=True ;
    }
    field("Bill No.";rec."Bill No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Document Situation";rec."Document Situation")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Due Date";rec."Due Date")
    {
        
                ShowMandatory=True ;
    }
    field("Bank Account No.";rec."Bank Account No.")
    {
        
    }
    field("Bank Account Name";rec."Bank Account Name")
    {
        
    }
    field("Fecha Cargo";rec."Fecha Cargo")
    {
        
                ToolTipML=ESP='Fecha en que se carga el documento en el banco, si no indica nada ser� la de la cabecera';
    }
    field("Currency Code";rec."Currency Code")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
                BlankZero=true;
                ShowMandatory=True ;
    }
    field("Texto Error";rec."Texto Error")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("No. Mov. Proveedor";rec."No. Mov. Proveedor")
    {
        
                Visible=false ;
    }

}
group("group33")
{
        
                CaptionML=ESP='Totales';
    field("Cabecera.Total Amount";Cabecera."Total Amount")
    {
        
                CaptionML=ESP='Total Documentos';
    }
    field("Cabecera.Total Marked";Cabecera."Total Marked")
    {
        
                CaptionML=ESP='Total Marcados';
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
group("group4")
{
        CaptionML=ENU='A&ccount',ESP='Proveedor';
                      Image=Vendor ;
    action("action2")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      ToolTipML=ENU='View or change detailed information about the record on the document or journal line.',ESP='Permite ver o cambiar la informaci�n del proveedor';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 26;
RunPageLink="No."=FIELD("Vendor No.");
                      Image=EditLines ;
    }
    action("action3")
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
                      Promoted=false;
                      Image=VendorLedger;
                      // PromotedCategory=Process ;  
    }
    action("action4")
    {
        ShortCutKey='Ctrl+F7';
                      CaptionML=ENU='Ledger E&ntries',ESP='&Movimiento';
                      ToolTipML=ENU='View the history of transactions that have been posted for the selected record.',ESP='Permite ver el historial de transacciones pendientes que se han registrado para el proveedor seleccionado.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 29;
                      RunPageView=SORTING("Vendor No.");
RunPageLink="Entry No."=FIELD("No. Mov. Proveedor");
                      Promoted=false;
                      Image=VendorLedger;
                      // PromotedCategory=Process ;
    }

}
group("group8")
{
        CaptionML=ESP='Relaci�n';
                      Image=SNInfo ;
    action("Mark")
    {
        
                      Ellipsis=true;
                      CaptionML=ESP='Marcar Todos';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Image=Check;
                      PromotedCategory=Category5;
                      
                                trigger OnAction()    VAR
                                 QBFuncionesPagares : Codeunit 7206922;
                               BEGIN
                                 Linea.RESET;
                                 Linea.SETRANGE("Relacion No.",rec."Relacion No.");
                                 Linea.MODIFYALL(Liquidar, TRUE);
                                 CurrPage.UPDATE(FALSE);
                               END;


    }
    action("UnMark")
    {
        
                      CaptionML=ESP='Desmarcar Todos';
                      Image=Undo;
                      
                                
    trigger OnAction()    VAR
                                 QBFuncionesPagares : Codeunit 7206922;
                               BEGIN
                                 Linea.RESET;
                                 Linea.SETRANGE("Relacion No.",rec."Relacion No.");
                                 Linea.MODIFYALL(Liquidar, FALSE);
                                 CurrPage.UPDATE(FALSE);
                               END;


    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
               END;

trigger OnAfterGetRecord()    BEGIN
                       Rec.CALCFIELDS("Cnt. Movimientos");
                       stDocumento := (rec."Cnt. Movimientos" > 1);
                       Recalcular;
                     END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     CurrPage.UPDATE;
                   END;

trigger OnAfterGetCurrRecord()    BEGIN
                           Recalcular;
                         END;



    var
      FunctionQB : Codeunit 7207272;
      Cabecera : Record 7206924;
      Linea : Record 7206925;
      PaymentMethod : Record 289;
      stDocumento : Boolean ;

    LOCAL procedure Recalcular();
    begin
      if Cabecera.GET(rec."Relacion No.") then ;
      Cabecera.CALCFIELDS("Total Amount", "Total Marked");
    end;

    // begin//end
}









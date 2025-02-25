pageextension 50113 MyExtension116 extends 116//45
{
layout
{
addafter("Creation Time")
{
//     field("Period Trans. No.";rec."Period Trans. No.") //REMOVED
//     {
        
//                 ToolTipML=ENU='Shows the definitive transaction number assigned in the printing of the official books.',ESP='Muestra el nÂ£mero de transacciÃ³n definitivo asignado en la impresiÃ³n de los libros oficiales.';
//                 ApplicationArea=Basic,Suite;
// }
}


modify("No.")
{
ToolTipML=ENU='Specifies the number of the general ledger register.',ESP='Especifica el nÂ£mero del registro de contabilidad general.';


}


modify("User ID")
{
ToolTipML=ENU='Specifies the ID of the user who posted the entry, to be used, for example, in the change log.',ESP='Especifica el identificador del usuario que registrÃ³ el movimiento, que se usarÂ , por ejemplo, en el registro de cambios.';


}


modify("Source Code")
{
ToolTipML=ENU='Specifies the source code for the entries in the register.',ESP='Especifica el cÃ³digo de origen de los movimientos del registro.';


}


modify("Reversed")
{
ToolTipML=ENU='Specifies if the register has been reversed (undone) from the Reverse Entries window.',ESP='Especifica si se revirtiÃ³ (deshizo) el registro desde la ventana Revertir entradas.';


}


modify("From Entry No.")
{
ToolTipML=ENU='Specifies the first general ledger entry number in the register.',ESP='Especifica el nÂ£mero del primer movimiento contable del registro.';


}


modify("To Entry No.")
{
ToolTipML=ENU='Specifies the last general ledger entry number in the register.',ESP='Especifica el nÂ£mero del Â£ltimo movimiento contable del registro.';


}


modify("From VAT Entry No.")
{
ToolTipML=ENU='Specifies the first VAT entry number in the register.',ESP='Especifica el nÂ£mero del primer movimiento de IVA del registro.';


}


modify("To VAT Entry No.")
{
ToolTipML=ENU='Specifies the last entry number in the register.',ESP='Especifica el nÂ£mero del Â£ltimo movimiento de IVA del registro.';


}

}

actions
{
addafter("VAT Entries")
{
    action("QB_WithholdingMov")
    {
        
                      CaptionML=ENU='Withholding Mov.',ESP='Movs. &retenciÃ³n';
                      Promoted=true;
                      Image=WorkCenterAbsence;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 WithholdingMovements : Record 7207329;
                                 FunctionQB : Codeunit 7207272;
                               BEGIN
                                 IF FunctionQB.AccessToQuobuilding THEN BEGIN
                                   WithholdingMovements.SETRANGE("Entry No.",Rec."From Entry No.",Rec."To Entry No.");
                                   PAGE.RUN(PAGE::"Withholding Movements",WithholdingMovements);
                                 END;
                               END;


}
} addafter("ReverseRegister")
{
    action("Action1100005")
    {
        CaptionML=ENU='Set Period Transaction No.',ESP='Asignar nÂ§ asiento periodo';
                      ApplicationArea=Basic,Suite;
                      RunObject=Report 10700;
                      Image=NumberSetup;
}
}


modify("Item Ledger Relation")
{
ToolTipML=ENU='View the link between the general ledger entries and the value entries.',ESP='Permite ver el vÂ¡nculo entre los movimientos de contabilidad y los movimientos de valor.';


}


modify("&Cartera Docs")
{
ToolTipML=ENU='View bills and invoices for customers and vendors. Bills are used by customers to pay invoices. They are sent to customers, who pay them under particular conditions on a specified date. Typically, the total amount of an invoice is divided into parts as bills are generated.',ESP='Permite ver efectos y facturas de clientes y proveedores. Los clientes usan los efectos para pagar las facturas. Se envÂ¡an a los clientes, que pagan en condiciones especÂ¡ficas en una fecha determinada. Normalmente, el importe total de una factura se divide en partes al generar efectos.';


}


modify("&Posted Cartera  Docs.")
{
ToolTipML=ENU='View posted bills and invoices for customers and vendors. Bills are used by customers to pay invoices. They are sent to customers, who pay them under particular conditions on a specified date. Typically, the total amount of an invoice is divided into parts as bills are generated.',ESP='Permite ver efectos y facturas registrados de clientes y proveedores. Los clientes usan los efectos para pagar las facturas. Se envÂ¡an a los clientes, que pagan en condiciones especÂ¡ficas en una fecha determinada. Normalmente, el importe total de una factura se divide en partes al generar efectos.';


}


modify("Cl&osed Cartera Docs.")
{
ToolTipML=ENU='View completed bills and invoices for customers and vendors. Bills are used by customers to pay invoices. They are sent to customers, who pay them under particular conditions on a specified date. Typically, the total amount of an invoice is divided into parts as bills are generated.',ESP='Permite ver efectos y facturas completados de clientes y proveedores. Los clientes usan los efectos para pagar las facturas. Se envÂ¡an a los clientes, que pagan en condiciones especÂ¡ficas en una fecha determinada. Normalmente, el importe total de una factura se divide en partes al generar efectos.';


}


modify("ReverseRegister")
{
ToolTipML=ENU='Undo entries that were incorrectly posted from a general journal line or from a previous reversal.',ESP='Deshace los movimientos incorrectamente registrados de una lÂ¡nea del diario general o de una reversiÃ³n anterior.';


}


modify("Delete Empty Registers")
{
ToolTipML=ENU='Find and delete empty G/L registers.',ESP='Buscar y eliminar reg. mov. vacÂ¡os contabilidad.';


}


modify("Detail Trial Balance")
{
ToolTipML=ENU='Print or save a detail trial balance for the general ledger accounts that you specify.',ESP='Permite imprimir o guardar un balance de comprobaciÃ³n detallado para las cuentas de contabilidad que especifique.';


}


modify("Trial Balance")
{
CaptionML=ENU='Trial Balance',ESP='Balance comprobaciÃ³n';


}


modify("Trial Balance by Period")
{
ToolTipML=ENU='Print or save the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.',ESP='Permite imprimir o guardar el saldo inicial de cada cuenta, los movimientos producidos durante el periodo seleccionado de mes, trimestre o aÂ¤o, asÂ¡ como el saldo de cierre resultante.';


}

}

//trigger

//trigger

var
      GLRegDocs : Codeunit 7000001;

    

//procedure

//procedure
}


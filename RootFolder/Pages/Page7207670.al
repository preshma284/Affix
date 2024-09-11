page 7207670 "QB Debit Relations Header"
{
    CaptionML = ESP = 'Cabecera de Creaci�n de Cobros';
    SourceTable = 7206919;
    PageType = Document;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("Relacion No."; rec."Relacion No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Job Desription"; rec."Job Desription")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Customer Name"; rec."Customer Name")
                {

                }
                field("Date"; rec."Date")
                {

                }
                field("Closed"; rec."Closed")
                {

                }
                field("Type"; rec."Type")
                {

                }
                group("group21")
                {

                    CaptionML = ESP = 'Importes';
                    field("Amount"; rec."Amount")
                    {

                    }
                    field("Amount Invoiced"; rec."Amount Invoiced")
                    {

                    }
                    field("Amount Received"; rec."Amount Received")
                    {

                    }

                }
                field("Amount Invoiced - Amount Received"; rec."Amount Invoiced" - rec."Amount Received")
                {

                    CaptionML = ESP = 'Importe Pendiente';
                }

            }
            group("group26")
            {

                part("Bill"; 7207671)
                {

                    CaptionML = ESP = 'Efectos';
                    SubPageView = SORTING("Relacion No.", "Line No.");
                    SubPageLink = "Relacion No." = FIELD("Relacion No."), "Type" = FILTER('=Bill');
                    UpdatePropagation = Both;
                }
                part("Movs"; 7207672)
                {

                    CaptionML = ESP = 'Historial';
                    SubPageView = SORTING("Relacion No.", "Line No.");
                    SubPageLink = "Relacion No." = FIELD("Relacion No."), "Type" = FILTER('<>Bill');
                    UpdatePropagation = Both

  ;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Procesar';
                Image = Post;
                action("Action Amount")
                {

                    CaptionML = ESP = 'Importe';
                    Image = Indent;

                    trigger OnAction()
                    BEGIN
                        CLEAR(FuncionesCobros);
                        FuncionesCobros.SetAmount(Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("Post")
                {

                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', ESP = 'Finaliza el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.';
                    ApplicationArea = Basic, Suite;
                    Image = PostOrder;

                    trigger OnAction()
                    BEGIN
                        CLEAR(FuncionesCobros);
                        FuncionesCobros.Registrar(Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("Receive")
                {

                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Recibir';
                    ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', ESP = 'Finaliza el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.';
                    ApplicationArea = Basic, Suite;
                    Image = PostOrder;

                    trigger OnAction()
                    BEGIN
                        CLEAR(FuncionesCobros);
                        FuncionesCobros.Recibir(Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }
            group("group6")
            {
                CaptionML = ENU = '&Line', ESP = '&Dimensiones';
                Image = Line;
                action("Dimensiones")
                {

                    AccessByPermission = TableData 348 = R;
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                    ApplicationArea = Suite;
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                        CurrPage.SAVERECORD;
                    END;


                }

            }
            group("group8")
            {
                CaptionML = ENU = 'A&ccount', ESP = 'Cliente';
                Image = Customer;
                action("action5")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    ToolTipML = ENU = 'View or change detailed information about the record on the document or journal line.', ESP = 'Permite ver o cambiar la informaci�n del cliente';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 21;
                    RunPageLink = "No." = FIELD("Customer No.");
                    Image = Customer;
                }
                action("action6")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = 'Movimien&tos';
                    ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones pendientes que se han registrado para el proveedor seleccionado.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 25;
                    RunPageView = SORTING("Customer No.", "Posting Date", "Currency Code");
                    RunPageLink = "Customer No." = FIELD("Customer No.");
                    Image = CustomerLedger;
                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ESP = 'Procesar';

                actionref(Amount_Promoted; "Action Amount")
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref(Receive_Promoted; Receive)
                {
                }
                actionref(Dimensiones_Promoted; Dimensiones)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Imprimir';
            }
            group(Category_Category4)
            {
                CaptionML = ESP = 'Crear';
            }
            group(Category_Category5)
            {
                CaptionML = ESP = 'Pagar�s';
            }
            group(Category_Category6)
            {
                CaptionML = ESP = 'Pagos Electr�nicos';
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Activar;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Activar;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        QBRelationshipSetup.GET;
        rec.Type := QBRelationshipSetup."RC Default Type";
    END;



    var
        QBRelationshipSetup: Record 7207335;
        Lineas: Record 7206920;
        FuncionesCobros: Codeunit 7207288;
        Text000: TextConst ESP = 'Confirme que desea cancelar el pagar� %1';
        Text001: TextConst ESP = 'Confirme que desea cancelar todos los pagar�s impresos';
        Text005: TextConst ESP = 'No ha indicado la fecha de registro';
        Text006: TextConst ESP = 'No ha seleccionado el tipo de pago';

    LOCAL procedure Activar();
    begin
        CurrPage.EDITABLE(not rec.Closed);
    end;

    // begin//end
}








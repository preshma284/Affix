page 7206939 "QB Efectos anticipados"
{
  ApplicationArea=All;

    CaptionML = ESP = 'Efectos anticipados sin liquidar';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206923;
    SourceTableView = SORTING("Relacion No.", "Document Type", "Document No.", "Bill No.")
                    WHERE("Registrada" = CONST(true), "Tipo Linea" = CONST("Anticipado"), "Importe Pendiente" = FILTER(<> 0));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Vendor No."; rec."Vendor No.")
                {

                    CaptionML = ENU = 'Account No.', ESP = 'Proveedor';
                    ToolTipML = ENU = 'Specifies the account number of the vendor associated with this document.', ESP = 'Especifica el n�mero de cuenta del proveedor asociado a este documento.';
                    Enabled = False;
                }
                field("Document Type"; rec."Document Type")
                {

                    ToolTipML = ENU = 'Specifies the type of document in question.', ESP = 'Especifica el tipo de documento en cuesti�n.';
                    ApplicationArea = Basic, Suite;
                    Visible = False;
                    Enabled = False;
                }
                field("Document No."; rec."Document No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the document used to generate this document.', ESP = 'Especifica el n�mero del documento que se us� para generar este documento.';
                    ApplicationArea = Basic, Suite;
                    Enabled = False;
                }
                field("Bill No."; rec."Bill No.")
                {

                    CaptionML = ENU = 'No.', ESP = 'N� Efecto';
                    ToolTipML = ENU = 'Specifies the number associated with a specific bill.', ESP = 'Especifica el n�mero asociado a un efecto en particular.';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Enabled = False;
                }
                field("No. Pagare"; rec."No. Pagare")
                {

                    Enabled = False;
                }
                field("Anticipo Liquidar con"; rec."Anticipo Liquidar con")
                {

                }
                field("Cabecera.Posting Date"; Cabecera."Posting Date")
                {

                    CaptionML = ESP = 'Fecha Registro';
                    ToolTipML = ENU = 'Specifies the when the creation of this document was posted.', ESP = 'Especifica la fecha en la que se registr� la creaci�n de este documento.';
                    Enabled = False;
                }
                field("Due Date"; rec."Due Date")
                {

                    ToolTipML = ENU = 'Specifies the due date of this document.', ESP = 'Especifica la fecha de vencimiento de este documento.';
                    ApplicationArea = Basic, Suite;
                    Enabled = False;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    ToolTipML = ENU = 'Specifies the payment method code defined for the document number.', ESP = 'Especifica el c�digo de la forma de pago definida para el n�mero de documento.';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Enabled = False;
                }
                field("Description1"; rec."Description1")
                {

                    ToolTipML = ENU = 'Specifies the description associated with this document.', ESP = 'Especifica la descripci�n asociada a este documento.';
                    ApplicationArea = Basic, Suite;
                    Enabled = False;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    ToolTipML = ENU = 'Specifies the currency code in which this document was generated.', ESP = 'Especifica el c�digo de la divisa en la que se gener� este documento.';
                    Visible = FALSE;
                    Enabled = False;
                }
                field("Amount"; rec."Amount")
                {

                    ToolTipML = ENU = 'Specifies the initial amount of this document, in LCY.', ESP = 'Especifica el importe inicial de este documento, en la divisa local.';
                    Enabled = False;
                }
                field("Anticipo Aplicado"; rec."Anticipo Aplicado")
                {

                    Enabled = False;
                }
                field("Importe Pendiente"; rec."Importe Pendiente")
                {

                    Enabled = False;
                }
                field("Cabecera.Bank Account No."; Cabecera."Bank Account No.")
                {

                    CaptionML = ESP = 'Banco';
                    Enabled = False;
                }
                field("No. Mov. a Liquidar"; rec."No. Mov. a Liquidar")
                {

                    Visible = false;
                    Enabled = False

  ;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            action("action1")
            {
                ShortCutKey = 'Shift+Ctrl+D';
                CaptionML = ENU = 'Dime&nsions', ESP = 'Dime&nsiones';
                ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a l�neas de diario para distribuir costes y analizar el historial de transacciones.';
                ApplicationArea = Basic, Suite;
                Image = Dimensions;

                trigger OnAction()
                BEGIN
                    rec.ShowDimensions;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', ESP = 'Permite buscar todos los movimientos y los documentos que existen para el n�mero de documento y la fecha de registro que constan en el movimiento o documento seleccionados.';
                ApplicationArea = Basic, Suite;
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    rec.Navigate();
                END;


            }
            group("group4")
            {

                CaptionML = ESP = 'Pagar�';
                action("action3")
                {
                    CaptionML = ENU = 'Print', ESP = 'Liquidar';
                    ToolTipML = ESP = 'Liquidar el pago anticipado contra una factura emitida';
                    ApplicationArea = Basic, Suite;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = ApplicationWorksheet;
                    PromotedCategory = Process;

                    trigger OnAction()
                    VAR
                        // rpCambiar: Report 7207437;
                    BEGIN
                        Liquidar();
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Print', ESP = 'Cancelar';
                    ToolTipML = ESP = 'Cancelar el pago anticipado';
                    ApplicationArea = Basic, Suite;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = CancelLine;
                    PromotedCategory = Process;


                    trigger OnAction()
                    VAR
                        // rpCambiar: Report 7207437;
                    BEGIN
                        Cancelar();
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        FunctionQB.OpenPagePaymentRelations;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        AfterGetCurrentRecord;
    END;



    var
        FunctionQB: Codeunit 7207272;
        Cabecera: Record 7206922;
        VendorLedgerEntry: Record 25;
        BankAccount: Record 270;
        cuRelaciones: Codeunit 7206922;

    LOCAL procedure AfterGetCurrentRecord();
    begin
        Cabecera.GET(rec."Relacion No.");
    end;

    LOCAL procedure Liquidar();
    begin
        CLEAR(cuRelaciones);
        cuRelaciones.LiquidarAnticipado(Rec, TRUE);
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure Cancelar();
    begin
        CLEAR(cuRelaciones);
        cuRelaciones.LiquidarAnticipado(Rec, FALSE);
        CurrPage.UPDATE(FALSE);
    end;

    // begin//end
}










page 7206938 "QB Documentos en cartera"
{
  ApplicationArea=All;

    Permissions = TableData 7000002 = m;
    Editable = false;
    CaptionML = ENU = 'Payables Cartera Docs', ESP = 'Docs. a pagar en cartera';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 25;
    SourceTableView = SORTING("Open", "Due Date")
                    WHERE("Document Situation" = CONST("Cartera"), "Remaining Amount" = FILTER(<> 0));
    PageType = List;

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
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Document Type"; rec."Document Type")
                {

                    ToolTipML = ENU = 'Specifies the type of document in question.', ESP = 'Especifica el tipo de documento en cuesti�n.';
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; rec."Document No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the document used to generate this document.', ESP = 'Especifica el n�mero del documento que se us� para generar este documento.';
                    ApplicationArea = Basic, Suite;
                }
                field("Bill No."; rec."Bill No.")
                {

                    CaptionML = ENU = 'No.', ESP = 'N� Efecto';
                    ToolTipML = ENU = 'Specifies the number associated with a specific bill.', ESP = 'Especifica el n�mero asociado a un efecto en particular.';
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    ToolTipML = ENU = 'Specifies the when the creation of this document was posted.', ESP = 'Especifica la fecha en la que se registr� la creaci�n de este documento.';
                    Visible = FALSE;
                }
                field("Due Date"; rec."Due Date")
                {

                    ToolTipML = ENU = 'Specifies the due date of this document.', ESP = 'Especifica la fecha de vencimiento de este documento.';
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    ToolTipML = ENU = 'Specifies the payment method code defined for the document number.', ESP = 'Especifica el c�digo de la forma de pago definida para el n�mero de documento.';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Description"; rec."Description")
                {

                    ToolTipML = ENU = 'Specifies the description associated with this document.', ESP = 'Especifica la descripci�n asociada a este documento.';
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    ToolTipML = ENU = 'Specifies the currency code in which this document was generated.', ESP = 'Especifica el c�digo de la divisa en la que se gener� este documento.';
                    Visible = FALSE;
                }
                field("Amount"; rec."Amount")
                {

                    ToolTipML = ENU = 'Specifies the initial amount of this document, in LCY.', ESP = 'Especifica el importe inicial de este documento, en la divisa local.';
                    Visible = false;
                }
                field("Remaining Amount"; rec."Remaining Amount")
                {

                    ToolTipML = ENU = 'Specifies the initial amount of this document.', ESP = 'Especifica el importe inicial de este documento.';
                }
                field("PagareEmitido"; PagareEmitido)
                {

                    CaptionML = ESP = 'Pagar� Emitido';
                }
                field("Reason Code"; rec."Reason Code")
                {

                    CaptionML = ENU = 'Reason Code', ESP = 'Banco';
                }
                field("BankAccount.No."; BankAccount."No.")
                {

                    CaptionML = ESP = 'Banco Emisi�n';
                }
                field("Entry No."; rec."Entry No.")
                {

                    ToolTipML = ENU = 'Specifies the ledger entry number associated with the posting of this document.', ESP = 'Especifica el n�mero de movimiento contable asociado al registro de este documento.';
                    ApplicationArea = Basic, Suite;
                    Visible = false

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
                    //Navigate(Rec);
                END;


            }
            group("group4")
            {

                CaptionML = ESP = 'Pagar�';
                action("action3")
                {
                    CaptionML = ENU = 'Print', ESP = 'Cambiar Vto.';
                    ToolTipML = ENU = 'Print the document.', ESP = 'Cambiar el vencimiento del pagar� reimprim�ndolo';
                    ApplicationArea = Basic, Suite;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Change;
                    PromotedCategory = Process;

                    trigger OnAction()
                    VAR
                        // rpCambiar: Report 7207437;
                    BEGIN
                        // CLEAR(rpCambiar);
                        // rpCambiar.SetDatos(VendorLedgerEntry, BankAccount."No.");
                        // rpCambiar.RUNMODAL;
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action4")
                {
                    CaptionML = ESP = 'Ver Pagar�';
                    RunObject = Page 374;
                    RunPageView = SORTING("Entry No.");
                    RunPageLink = "Document No." = FIELD("Document No.");
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = CheckJournal;
                    PromotedCategory = Process;
                }
                action("action5")
                {
                    CaptionML = ENU = 'Print', ESP = 'Imprimir';
                    ToolTipML = ENU = 'Print the document.', ESP = 'Imprime el pagar�';
                    ApplicationArea = Basic, Suite;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Print;
                    PromotedCategory = Process;

                    trigger OnAction()
                    BEGIN
                        ImprimirPagare;
                    END;


                }

            }
            group("group8")
            {

                CaptionML = ESP = 'Modificaciones';
                action("action6")
                {
                    CaptionML = ENU = 'Print', ESP = 'Cambiar Proyecto';
                    ToolTipML = ENU = 'Print the document.', ESP = 'Cambiar el vencimiento del pagar� reimprim�ndolo';
                    ApplicationArea = Basic, Suite;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = ChangeDimensions;
                    PromotedCategory = Process;

                    trigger OnAction()
                    VAR
                        // rpCambiar: Report 7207433;
                    BEGIN
                        // CLEAR(rpCambiar);
                        // rpCambiar.SetDatos(VendorLedgerEntry);
                        // rpCambiar.RUNMODAL;
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action7")
                {
                    CaptionML = ESP = 'Anular Pagar�';
                    Image = ReopenCancelled;


                    trigger OnAction()
                    BEGIN
                        AnularPagare;
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
        CarteraDoc: Record 7000002;
        VendorLedgerEntry: Record 25;
        BankAccount: Record 270;
        CheckLedgerEntry: Record 272;
        CarteraManagement: Codeunit 50033;
        FuncionesPagares: Codeunit 7206922;
        PagareEmitido: Boolean;

    LOCAL procedure AfterGetCurrentRecord();
    begin
        VendorLedgerEntry.GET(rec."Entry No.");
        CheckLedgerEntry.RESET;
        CheckLedgerEntry.SETRANGE("Document No.", rec."Document No.");
        CheckLedgerEntry.SETRANGE("Entry Status", CheckLedgerEntry."Entry Status"::Printed);
        if (CheckLedgerEntry.FINDFIRST) then begin
            PagareEmitido := TRUE;
            BankAccount.GET(CheckLedgerEntry."Bank Account No.");
        end ELSE begin
            PagareEmitido := FALSE;
            CLEAR(BankAccount);
        end;
    end;

    LOCAL procedure ImprimirPagare();
    begin
    end;

    LOCAL procedure AnularPagare();
    begin
        FuncionesPagares.AnularPagareRegistrado(Rec);
    end;

    // begin//end
}










page 7207048 "QB Docs. in Posted BG Subform"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Docs. in Posted BG', ESP = 'Documentos Ptes. en Remesas Cobro';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7000003;
    SourceTableView = WHERE("Type" = CONST("Receivable"));
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Bill Gr./Pmt. Order No."; rec."Bill Gr./Pmt. Order No.")
                {

                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Bank Account No."; rec."Bank Account No.")
                {

                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    ToolTipML = ENU = 'Specifies the date when the creation of this document was posted.', ESP = 'Especifica la fecha en la que se registr� la creaci�n de este documento.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Document Type"; rec."Document Type")
                {

                    ToolTipML = ENU = 'Specifies the type of document in question.', ESP = 'Especifica el tipo de documento en cuesti�n.';
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Due Date"; rec."Due Date")
                {

                    ToolTipML = ENU = 'Specifies the due date of this document in a posted bill group/payment order.', ESP = 'Especifica la fecha de vencimiento de este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Status"; rec."Status")
                {

                    ToolTipML = ENU = 'Specifies the status of this document in a posted bill group/payment order.', ESP = 'Especifica el estado de este documento de una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Honored/Rejtd. at Date"; rec."Honored/Rejtd. at Date")
                {

                    ToolTipML = ENU = 'Specifies the date when this document in a posted bill group/payment order is settled or rejected.', ESP = 'Especifica la fecha en la que se liquida o se rechaza este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    ToolTipML = ENU = 'Specifies the payment method code for the document number.', ESP = 'Especifica el c�digo de la forma de pago para el n�mero de documento.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Document No."; rec."Document No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the document in a posted bill group/payment order, from which this document was generated.', ESP = 'Especifica el n�mero del documento de una remesa o una orden de pago registradas con el que se gener� este documento.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of a bill in a posted bill group/payment order.', ESP = 'Especifica el n�mero de un efecto en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Description"; rec."Description")
                {

                    ToolTipML = ENU = 'Specifies the description associated with this posted document.', ESP = 'Especifica la descripci�n asociada a este documento registrado.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Original Amount"; rec."Original Amount")
                {

                    ToolTipML = ENU = 'Specifies the initial amount of this document in a posted bill group/payment order.', ESP = 'Especifica el importe inicial de este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Original Amt. (LCY)"; rec."Original Amt. (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the initial amount of this document in a posted bill group/payment order.', ESP = 'Especifica el importe inicial de este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Amount for Collection"; rec."Amount for Collection")
                {

                    ToolTipML = ENU = 'Specifies the amount for which this document in a posted bill group/payment order was created.', ESP = 'Especifica el importe por el que se cre� este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Amt. for Collection (LCY)"; rec."Amt. for Collection (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the amount due for this document in a posted bill group/payment order.', ESP = 'Especifica el importe adeudado de este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Remaining Amount"; rec."Remaining Amount")
                {

                    ToolTipML = ENU = 'Specifies the pending amount for this document, in a posted bill group/payment order, to be settled in full.', ESP = 'Especifica el importe pendiente para que este documento, que consta en una remesa o una orden de pago registradas, quede totalmente liquidado.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Remaining Amt. (LCY)"; rec."Remaining Amt. (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the pending amount in order for this document, in a posted bill group/payment order, to be settled in full.', ESP = 'Especifica el importe pendiente para que este documento, que consta en una remesa o una orden de pago registradas, quede totalmente liquidado.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Redrawn"; rec."Redrawn")
                {

                    ToolTipML = ENU = 'Specifies a check Rec.MARK to indicate that the bill has been redrawn since it was rejected when its due date arrived.', ESP = 'Especifica una marca de verificaci�n para indicar que el efecto se ha recirculado tras llegar su vencimiento y resultar rechazado.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Place"; rec."Place")
                {

                    ToolTipML = ENU = 'Specifies if the company bank and customer bank are in the same area.', ESP = 'Especifica si el banco de la empresa y el banco del cliente est�n en la misma �rea.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Category Code"; rec."Category Code")
                {

                    ToolTipML = ENU = 'Specifies a category code for this document in a posted bill group/payment order.', ESP = 'Especifica un c�digo de categor�a para este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Account No."; rec."Account No.")
                {

                    ToolTipML = ENU = 'Specifies the account type associated with this document in a posted bill group/payment order.', ESP = 'Especifica el tipo de cuenta asociado a este documento en una remesa o una orden de pago registradas.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Customer Name"; rec."Customer Name")
                {

                    Style = Attention;
                    StyleExpr = dued;
                }
                field("Entry No."; rec."Entry No.")
                {

                    ToolTipML = ENU = 'Specifies the ledger entry number associated with this posted document.', ESP = 'Especifica el n�mero de movimiento contable asociado a este documento registrado.';
                    ApplicationArea = Basic, Suite;
                    Editable = FALSE;
                    Style = Attention;
                    StyleExpr = dued

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Docs.', ESP = '&Docs.';
                action("Dimensions")
                {

                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dime&nsions', ESP = 'Dime&nsiones';
                    ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a l�neas de diario para distribuir costes y analizar el historial de transacciones.';
                    ApplicationArea = Basic, Suite;
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        ShowDimension;
                    END;


                }
                action("Categorize")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Categorize', ESP = 'Clasificar';
                    ToolTipML = ENU = 'Insert categories on one or more Cartera documents to facilitate analysis. For example, to Rec.COUNT or add only some documents, to analyze their due dates, to simulate scenarios for creating bill groups, to Rec.MARK documents with your initials to indicate to other accountants that you are managing them personally.', ESP = 'Permite insertar categor�as en uno o varios documentos Cartera para facilitar el an�lisis. Por ejemplo, para contar o sumar �nicamente algunos documentos, para analizar las fechas de vencimiento, para simular escenarios de creaci�n de facturaci�n grupos, para marcar documentos con sus iniciales para advertir a otros contables que los est� gestionando personal.';
                    ApplicationArea = Basic, Suite;
                    Image = Category;

                    trigger OnAction()
                    BEGIN
                        Categorize_;
                    END;


                }
                action("Decategorize")
                {

                    CaptionML = ENU = 'Decategorize', ESP = 'Desclasificar';
                    ToolTipML = ENU = 'Remove categories applied to one or more Cartera documents to facilitate analysis.', ESP = 'Permite quitar categor�as que se aplican a uno o varios documentos Cartera para facilitar el an�lisis.';
                    ApplicationArea = Basic, Suite;
                    Image = UndoCategory;

                    trigger OnAction()
                    BEGIN
                        Decategorize_;
                    END;


                }
                group("group6")
                {
                    CaptionML = ENU = 'Settle', ESP = 'Liquidar';
                    Image = SettleOpenTransactions;
                    action("Total Settlement")
                    {

                        Ellipsis = true;
                        CaptionML = ENU = 'Total Settlement', ESP = 'Liq. total';
                        ToolTipML = ENU = 'View posted documents that were settled fully.', ESP = 'Permite ver los documentos registrados que se han liquidado totalmente.';
                        ApplicationArea = Basic, Suite;

                        trigger OnAction()
                        BEGIN
                            Settle;
                        END;


                    }
                    action("Partial Settlement")
                    {

                        Ellipsis = true;
                        CaptionML = ENU = 'P&artial Settlement', ESP = 'Liq. p&arcial';
                        ToolTipML = ENU = 'View posted documents that were settled partially.', ESP = 'Permite ver los documentos registrados que se han liquidado parcialmente.';
                        ApplicationArea = Basic, Suite;

                        trigger OnAction()
                        BEGIN
                            PartialSettle;
                        END;


                    }

                }
                action("Reject")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Reject', ESP = 'Rechazar';
                    ToolTipML = ENU = 'Post document rejections.', ESP = 'Registra rechazos de documentos.';
                    ApplicationArea = Basic, Suite;
                    Image = Reject;

                    trigger OnAction()
                    BEGIN
                        Reject_;
                    END;


                }
                action("Redraw")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Redraw', ESP = 'Recircular';
                    ToolTipML = ENU = 'Create a new Rec.COPY of the old bill or order, with the possibility of creating it with a new, later due date and a different payment method.', ESP = 'Crea una nueva copia del antiguo efecto u orden, con la posibilidad de crearlo con una fecha de vencimiento nueva y posterior y con una forma de pago distinta.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                    Image = RefreshVoucher;

                    trigger OnAction()
                    BEGIN
                        Redraw_;
                    END;


                }
                action("Print")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Print', ESP = 'Imprimir';
                    ToolTipML = ENU = 'Print the document.', ESP = 'Imprime el documento.';
                    ApplicationArea = Basic, Suite;
                    Image = Print;

                    trigger OnAction()
                    BEGIN
                        PrintDoc;
                    END;


                }
                action("Navigate")
                {

                    ApplicationArea = Basic, Suite;
                    Image = Navigate;

                    trigger OnAction()
                    BEGIN
                        Navigate_;
                    END;


                }
                action("seeAll")
                {

                    CaptionML = ESP = 'Ver Todos';
                    Image = AllLines;

                    trigger OnAction()
                    BEGIN
                        //JAV 18/05/22: - QB 1.10.42 Ver todos los presupuestos o solo el actual
                        see(TRUE);
                    END;


                }
                action("seeDued")
                {

                    CaptionML = ESP = 'Ver Vencidos';
                    Image = FilterLines;


                    trigger OnAction()
                    BEGIN
                        //JAV 18/05/22: - QB 1.10.42 Ver todos los presupuestos o solo el actual
                        see(FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref(seeAll_Promoted; seeAll)
                {
                }
                actionref(seeDued_Promoted; seeDued)
                {
                }
            }
            group(Category_Process)
            {
                actionref("Total Settlement_Promoted"; "Total Settlement")
                {
                }
                actionref("Partial Settlement_Promoted"; "Partial Settlement")
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Redraw_Promoted; Redraw)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        //Ver solo pendientes por defecto
        Rec.SETRANGE(Status, Rec.Status::Open);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //JAV 18/06/22: - QB 1.10.51 Mirar si est� vencido
        BankAccount.GET(Rec."Bank Account No.");
        Dued := (Rec."Due Date" < WORKDATE + BankAccount."Delay for Notices");
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        CODEUNIT.RUN(CODEUNIT::"Posted Cartera Doc.- Edit", Rec);
        EXIT(FALSE);
    END;



    var
        Text1100000: TextConst ENU = 'No documents have been found that can be settled. \', ESP = 'No hay documentos que liquidar. \';
        Text1100001: TextConst ENU = 'Please check that at least one open document was selected.', ESP = 'Compruebe que ha seleccionado al menos un documento pendiente.';
        Text1100002: TextConst ENU = 'No documents have been found that can be rejected. \', ESP = 'No hay documentos que impagar. \';
        Text1100003: TextConst ENU = 'Only invoices in Bill Groups marked as %1 Risked can be rejected.', ESP = 'S�lo se pueden impagar las facturas remesadas marcadas como %1 con recurso.';
        Text1100004: TextConst ENU = 'No documents have been found that can be redrawn. \', ESP = 'No hay documentos que se puedan recircular. \';
        Text1100005: TextConst ENU = 'Please check that at least one rejected or honored document was selected.', ESP = 'Compruebe que ha seleccionado al menos un documento pagado o impagado.';
        Text1100006: TextConst ENU = 'Only bills can be redrawn.', ESP = 'S�lo se pueden recircular efectos.';
        Text1100007: TextConst ENU = 'Please check that one open document was selected.', ESP = 'Compruebe que ha seleccionado un documento pendiente.';
        Text1100008: TextConst ENU = 'Only one open document can be selected', ESP = 'S�lo se puede seleccionar un documento pendiente.';
        PostedDoc: Record 7000003;
        CustLedgEntry: Record 21;
        SalesInvHeader: Record 112;
        CarteraManagement: Codeunit 7000000;
        "----------------------------------- QB": Integer;
        BankAccount: Record 270;
        Dued: Boolean;

    procedure Categorize_();
    begin
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        CarteraManagement.CategorizePostedDocs(PostedDoc);
    end;

    procedure Decategorize_();
    begin
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        CarteraManagement.DecategorizePostedDocs(PostedDoc);
    end;

    procedure Settle();
    begin
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        if not PostedDoc.FIND('=><') then
            exit;

        PostedDoc.SETRANGE(Status, PostedDoc.Status::Open);
        if not PostedDoc.FIND('-') then
            ERROR(
              Text1100000 +
              Text1100001);

        // REPORT.RUNMODAL(REPORT::"Settle Docs. in Post. Bill Gr.", TRUE, FALSE, PostedDoc);
        CurrPage.UPDATE(FALSE);
    end;

    procedure Reject_();
    var
        PostedBillGr: Record 7000006;
    begin
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        if not PostedDoc.FIND('=><') then
            exit;

        PostedDoc.SETRANGE(Status, PostedDoc.Status::Open);
        if not PostedDoc.FIND('-') then
            ERROR(
              Text1100002 +
              Text1100001);
        if PostedDoc.Factoring <> PostedDoc.Factoring::" " then begin
            PostedBillGr.GET(PostedDoc."Bill Gr./Pmt. Order No.");
            if PostedBillGr.Factoring = PostedBillGr.Factoring::Unrisked then
                ERROR(Text1100003,
                  PostedBillGr.FIELDCAPTION(Factoring));
        end;
        CustLedgEntry.RESET;
        repeat
            CustLedgEntry.GET(PostedDoc."Entry No.");
            CustLedgEntry.MARK(TRUE);
        until PostedDoc.NEXT = 0;

        CustLedgEntry.MARKEDONLY(TRUE);
        // REPORT.RUNMODAL(REPORT::"Reject Docs.", TRUE, FALSE, CustLedgEntry);
        CurrPage.UPDATE(FALSE);
    end;

    procedure Redraw_();
    begin
        PostedDoc.RESET;
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        if not PostedDoc.FIND('=><') then
            exit;

        PostedDoc.SETFILTER(Status, '<>%1', PostedDoc.Status::Open);
        if not PostedDoc.FIND('-') then
            ERROR(
              Text1100004 +
              Text1100005);

        PostedDoc.SETFILTER("Document Type", '<>%1', PostedDoc."Document Type"::Bill);
        if PostedDoc.FIND('-') then
            ERROR(Text1100006);
        PostedDoc.SETRANGE("Document Type");




        CustLedgEntry.RESET;
        repeat
            CustLedgEntry.GET(PostedDoc."Entry No.");
            CustLedgEntry.MARK(TRUE);
        until PostedDoc.NEXT = 0;

        CustLedgEntry.MARKEDONLY(TRUE);
        // REPORT.RUNMODAL(REPORT::"Redraw Receivable Bills", TRUE, FALSE, CustLedgEntry);
        CurrPage.UPDATE(FALSE);
    end;

    procedure PrintDoc();
    begin
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        if not PostedDoc.FIND('-') then
            exit;

        if PostedDoc."Document Type" = PostedDoc."Document Type"::Bill then begin
            CustLedgEntry.RESET;
            repeat
                CustLedgEntry.GET(PostedDoc."Entry No.");
                CustLedgEntry.MARK(TRUE);
            until PostedDoc.NEXT = 0;
            CustLedgEntry.MARKEDONLY(TRUE);
            CurrPage.UPDATE(FALSE);
            // REPORT.RUNMODAL(REPORT::"Receivable Bill", TRUE, FALSE, CustLedgEntry);
        end ELSE begin
            SalesInvHeader.RESET;
            repeat
                SalesInvHeader.GET(PostedDoc."Document No.");
                SalesInvHeader.MARK(TRUE);
            until PostedDoc.NEXT = 0;
            SalesInvHeader.MARKEDONLY(TRUE);
            CurrPage.UPDATE(FALSE);
            // REPORT.RUNMODAL(REPORT::"Sales - Invoice", TRUE, FALSE, SalesInvHeader);
        end;
    end;

    procedure Navigate_();
    begin
        CarteraManagement.NavigatePostedDoc(Rec);
    end;

    procedure PartialSettle();
    var
        CustLedgEntry2: Record 21;
        // PartialSettleReceivable: Report 7000084;
    begin
        CurrPage.SETSELECTIONFILTER(PostedDoc);
        if not PostedDoc.FIND('=><') then
            exit;

        PostedDoc.SETRANGE(Status, PostedDoc.Status::Open);
        if not PostedDoc.FIND('-') then
            ERROR(
              Text1100000 +
              Text1100007);
        if PostedDoc.COUNT > 1 then
            ERROR(Text1100008);


        // CLEAR(PartialSettleReceivable);
        CustLedgEntry2.GET(PostedDoc."Entry No.");
        // if (WORKDATE <= CustLedgEntry2."Pmt. Discount Date") and
        //    (PostedDoc."Document Type" = PostedDoc."Document Type"::Invoice)
        // then
        //     PartialSettleReceivable.SetInitValue(PostedDoc."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible",
        //       PostedDoc."Currency Code", PostedDoc."Entry No.")
        // ELSE
        //     PartialSettleReceivable.SetInitValue(PostedDoc."Remaining Amount",
        //       PostedDoc."Currency Code", PostedDoc."Entry No.");
        // PartialSettleReceivable.SETTABLEVIEW(PostedDoc);
        // PartialSettleReceivable.RUNMODAL;

        CurrPage.UPDATE(FALSE);
    end;

    procedure ShowDimension();
    begin
        rec.ShowDimensions;
    end;

    LOCAL procedure "---------------------------- QB"();
    begin
    end;

    LOCAL procedure see(pAll: Boolean);
    begin
        //JAV 18/06/22: - QB 1.10.51 Ver todos o solo vencidos
        Rec.MARKEDONLY(FALSE);
        Rec.CLEARMARKS;
        if (not pAll) then begin
            if (Rec.FINDSET(FALSE)) then
                repeat
                    BankAccount.GET(rec."Bank Account No.");
                    if (Rec."Due Date" < WORKDATE + BankAccount."Delay for Notices") then
                        Rec.MARK(TRUE);
                until (Rec.NEXT = 0);
            Rec.MARKEDONLY(TRUE);
        end;
    end;

    // begin
    /*{
      JAV 22/01/22: - QB 1.10.12 Esta p�gina est� basada en la p�gina 7000005, sirve para liquidar documentos pendientes en remesas registradas sin necesidad de abrir cada remesa
      JAV 18/06/22: - QB 1.10.51 Se a�ade la columna con el banco en que se ha incluido la orden de pago para poder filtrar mejor
      JAV 18/06/22: - QB 1.10.51 Se a�ade la columna con el banco en que se ha incluido la orden de pago para poder filtrar mejor.
                                 Se a�ade columna para indicar si est� vencido, se marcan vencidos en rojo, y se a�aden botones para ver todos o solo vencidos
    }*///end
}









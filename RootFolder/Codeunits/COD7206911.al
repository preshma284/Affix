Codeunit 7206911 "QB Service Order Procesing"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        PostConfirmQst: TextConst ENU = 'Do you want to post the selected Services Order?', ESP = '¨Confirma que desea registrar los Pedidos de servicio seleccionados?.';
        NothingToPostErr: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        Text1100011: TextConst ENU = 'The posting process has been cancelled by the user.', ESP = 'El proceso de registro ha sido cancelado por el usuario.';

    PROCEDURE Post(VAR QBServiceOrderHeader: Record 7206966);
    VAR
        QBServiceOrderLines: Record 7206967;
        QBPostedServiceOrderHeader: Record 7206968;
        QBPostedServiceOrderLines: Record 7206969;
    BEGIN
        IF CONFIRM(PostConfirmQst) THEN BEGIN
            // Q16314 - CEI (EPV) 11/02/22 - No registra cuando se selecciona m s de una l¡nea
            IF QBServiceOrderHeader.FINDFIRST THEN // L¡nea a¤adida. Faltaba hacer el FINDFIRST
                REPEAT
                    IF QBServiceOrderHeader."No." <> '' THEN BEGIN
                        QBPostedServiceOrderHeader.INIT;
                        QBPostedServiceOrderHeader.TRANSFERFIELDS(QBServiceOrderHeader);
                        QBPostedServiceOrderHeader.INSERT;

                        QBServiceOrderLines.RESET;
                        QBServiceOrderLines.SETRANGE("Document No.", QBServiceOrderHeader."No.");
                        IF QBServiceOrderLines.FINDFIRST THEN
                            REPEAT
                                QBPostedServiceOrderLines.INIT;
                                QBPostedServiceOrderLines.TRANSFERFIELDS(QBServiceOrderLines);
                                QBPostedServiceOrderLines.INSERT;
                            UNTIL QBServiceOrderLines.NEXT = 0
                        ELSE
                            ERROR(NothingToPostErr);
                        DeleteAfterPosting(QBServiceOrderHeader);
                    END;
                UNTIL QBServiceOrderHeader.NEXT = 0;
        END ELSE
            MESSAGE(Text1100011);
    END;

    LOCAL PROCEDURE DeleteAfterPosting(VAR QBServiceOrderHeader: Record 7206966);
    BEGIN
        QBServiceOrderHeader.DELETE(TRUE);
    END;

    [EventSubscriber(ObjectType::Table, 36, OnAfterDeleteEvent, '', true, true)]
    LOCAL PROCEDURE T36_OnAfterDeleteEvent(VAR Rec: Record 36; RunTrigger: Boolean);
    VAR
        QBPostedServiceOrderHeader: Record 7206968;
        SalesHeaderExt: Record 7207071;
    BEGIN
        IF Rec."Posting No." = '' THEN BEGIN
            QBPostedServiceOrderHeader.RESET;
            QBPostedServiceOrderHeader.SETRANGE("Pre-Assigned Invoice No.", Rec."No.");
            IF QBPostedServiceOrderHeader.FINDFIRST THEN
                REPEAT
                    IF QBPostedServiceOrderHeader."Posted Invoice No." = '' THEN BEGIN
                        QBPostedServiceOrderHeader."Pre-Assigned Invoice No." := '';
                        QBPostedServiceOrderHeader."Invoice Generated" := FALSE;
                        QBPostedServiceOrderHeader.MODIFY;
                    END;
                UNTIL QBPostedServiceOrderHeader.NEXT = 0;
        END;

        IF SalesHeaderExt.Read(Rec.RECORDID) THEN
            SalesHeaderExt.DELETE;
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterFinalizePosting, '', true, true)]
    LOCAL PROCEDURE C80_OnAfterFinalizePosting(VAR SalesHeader: Record 36; VAR SalesShipmentHeader: Record 110; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR ReturnReceiptHeader: Record 6660; VAR GenJnlPostLine: Codeunit 12; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    VAR
        QBPostedServiceOrderHeader: Record 7206968;
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnBeforeDeleteAfterPosting, '', true, true)]
    LOCAL PROCEDURE C80_OnBeforeDeleteAfterPosting(VAR SalesHeader: Record 36; VAR SalesInvoiceHeader: Record 112; VAR SalesCrMemoHeader: Record 114; VAR SkipDelete: Boolean; CommitIsSuppressed: Boolean);
    VAR
        QBPostedServiceOrderHeader: Record 7206968;
        SalesHeaderExt: Record 7207071;
        SalesHeaderExtPost: Record 7207071;
    BEGIN
        QBPostedServiceOrderHeader.RESET;
        QBPostedServiceOrderHeader.SETRANGE("Pre-Assigned Invoice No.", SalesHeader."No.");
        IF QBPostedServiceOrderHeader.FINDFIRST THEN BEGIN
            REPEAT
                QBPostedServiceOrderHeader."Posted Invoice No." := SalesInvoiceHeader."No.";
                QBPostedServiceOrderHeader."Invoice Posting Date" := SalesInvoiceHeader."Posting Date";
                QBPostedServiceOrderHeader.MODIFY;

                //Eliminamos el registro de la factura sin registrar
                SalesHeaderExt.Read(SalesHeader.RECORDID);
                IF SalesHeaderExt.DELETE THEN;

                //A¤adimos el registro de la factura registrada
                SalesHeaderExtPost.Copy(SalesHeaderExt, SalesInvoiceHeader.RECORDID);

            UNTIL QBPostedServiceOrderHeader.NEXT = 0;
        END;
    END;

    PROCEDURE RegistrarIPCVenta(VAR prSalesHeader: Record 36);
    VAR
        lrSalesLine: Record 37;
        lrSalesLineNew: Record 37;
        lrSalesLineLast: Record 37;
        lrGLAccountTMP: Record 15 TEMPORARY;
        lwRevisionAmount: Decimal;
        lwLineNo: Integer;
        lwBase: Decimal;
        errIPCAplicado: TextConst ESP = 'La revisi¢n de IPC ya se ha aplicado sobre esta factura, no es posible aplicarla de nuevo.';
        txtDescripLineaIPC: TextConst ESP = 'Revision de precios';
        "--": Integer;
        rSalesHeaderExt: Record 7207071;
    BEGIN
        // Q12733 - CEI (EPV) 16/02/22 - APLICAR REVISION DE PRECIOS SI LA TIENE DEFINIDA

        //. Si no tiene porcentaje de revisi¢n, salimos porque no hay que hacer nada
        rSalesHeaderExt.Read(prSalesHeader.RECORDID);
        IF rSalesHeaderExt."Price review percentage" = 0 THEN
            EXIT;
        //--> Q12733 - CEI (EPV)

        IF NOT (prSalesHeader."Document Type" IN [prSalesHeader."Document Type"::Invoice, prSalesHeader."Document Type"::"Credit Memo"]) THEN
            EXIT;

        // Q12733 - CEI (EPV) 16/02/22
        IF rSalesHeaderExt."IPC/Rev aplicado" THEN
            ERROR(errIPCAplicado);
        //--> Q12733 - CEI (EPV)

        //. Buscamos el total sin IVA de la factura
        prSalesHeader.CALCFIELDS(Amount);
        IF prSalesHeader.Amount = 0 THEN
            EXIT;

        //. Vamos a buscar todas las cuentas contables utilizadas en esta factura, montaremos un temporary
        lrGLAccountTMP.RESET;
        lrGLAccountTMP.DELETEALL;

        lrSalesLine.RESET;
        lrSalesLine.SETRANGE("Document Type", prSalesHeader."Document Type");
        lrSalesLine.SETRANGE("Document No.", prSalesHeader."No.");
        lrSalesLine.SETRANGE(Type, lrSalesLine.Type::"G/L Account");
        IF lrSalesLine.FINDSET THEN BEGIN
            REPEAT
                IF NOT lrGLAccountTMP.GET(lrSalesLine."No.") THEN BEGIN
                    lrGLAccountTMP.INIT;
                    lrGLAccountTMP."No." := lrSalesLine."No.";
                    lrGLAccountTMP.INSERT;
                END;
            UNTIL lrSalesLine.NEXT = 0;
        END;

        //. Buscamos la £ltima linea para a¤adir las lineas detras
        lrSalesLineLast.RESET;
        lrSalesLineLast.SETRANGE("Document Type", prSalesHeader."Document Type");
        lrSalesLineLast.SETRANGE("Document No.", prSalesHeader."No.");
        IF lrSalesLineLast.FINDLAST THEN
            lwLineNo := lrSalesLineLast."Line No.";

        //. Recorrer el temporal para crear las lineas de IPC correspondientes
        IF lrGLAccountTMP.FINDSET THEN BEGIN
            REPEAT
                //. Para cada linea hay que acumular la base
                lwBase := 0;

                lrSalesLine.RESET;
                lrSalesLine.SETRANGE("Document Type", prSalesHeader."Document Type");
                lrSalesLine.SETRANGE("Document No.", prSalesHeader."No.");
                lrSalesLine.SETRANGE(Type, lrSalesLine.Type::"G/L Account");
                lrSalesLine.SETRANGE("No.", lrGLAccountTMP."No.");
                IF lrSalesLine.FINDSET THEN BEGIN
                    REPEAT
                        lwBase += lrSalesLine."Line Amount";
                    UNTIL lrSalesLine.NEXT = 0;
                END;

                // Q12733 - CEI (EPV) 16/02/22
                //. Aplicamos el porcentaje para obtener el importe de la revisi¢n
                lwRevisionAmount := ROUND(lwBase * rSalesHeaderExt."Price review percentage" / 100);
                // --> Q12733 - CEI (EPV) 16/02/22

                lwLineNo += 10000;

                lrSalesLineNew.TRANSFERFIELDS(lrSalesLineLast);
                lrSalesLineNew."Line No." := lwLineNo;
                lrSalesLineNew.VALIDATE("No.", lrGLAccountTMP."No.");
                lrSalesLineNew.INSERT;

                lrSalesLineNew.VALIDATE(Quantity, 1);
                lrSalesLineNew.Description := txtDescripLineaIPC;
                lrSalesLineNew.VALIDATE("Unit Price", lwRevisionAmount);
                lrSalesLineNew.VALIDATE("Job No.", prSalesHeader."QB Job No.");
                lrSalesLineNew."Price review line" := TRUE;
                lrSalesLineNew.MODIFY;
            UNTIL lrGLAccountTMP.NEXT = 0;
        END;

        // Q12733 - CEI (EPV) 16/02/22
        rSalesHeaderExt."IPC/Rev aplicado" := TRUE;
        rSalesHeaderExt.Save;
        // --> Q12733 - CEI (EPV) 16/02/22
    END;


    /*BEGIN
    /*{

          Q16314 - CEI (EPV) 11/02/22 - No registra cuando se selecciona m s de una l¡nea

           - A¤adida funci¢n "RegistrarIPCVenta" de revisi¢n de precios y adaptaci¢n con la tabla QB Sales Header Ext.
        }
    END.*/
}










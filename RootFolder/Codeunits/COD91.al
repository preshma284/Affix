Codeunit 50006 "Purch.-Post (Yes/No) 1"
{


    TableNo = 38;
    EventSubscriberInstance = Manual;
    trigger OnRun()
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        IF NOT PurchaseHeader.Find THEN
            ERROR(NothingToPostErr);

        PurchaseHeader.COPY(Rec);
        Code(PurchaseHeader);
        Rec := PurchaseHeader;
    END;

    VAR
        ReceiveInvoiceQst: TextConst ENU = '&Receive,&Invoice,Receive &and Invoice', ESP = '&Recibir,&Facturar,R&ecibir y facturar';
        PostConfirmQst: TextConst ENU = 'Do you want to post the %1?', ESP = '�Confirma que desea registrar el/la %1?';
        ShipInvoiceQst: TextConst ENU = '&Ship,&Invoice,Ship &and Invoice', ESP = '&Enviar,&Facturar,E&nviar y facturar';
        NothingToPostErr: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';

    LOCAL PROCEDURE Code(VAR PurchaseHeader: Record 38);
    VAR
        PurchSetup: Record 312;
        PurchPostViaJobQueue: Codeunit 98;
        HideDialog: Boolean;
        IsHandled: Boolean;
        DefaultOption: Integer;
    BEGIN
        HideDialog := FALSE;
        IsHandled := FALSE;
        DefaultOption := 3;
        OnBeforeConfirmPost(PurchaseHeader, HideDialog, IsHandled, DefaultOption);
        IF IsHandled THEN
            EXIT;

        IF NOT HideDialog THEN
            IF NOT ConfirmPost(PurchaseHeader, DefaultOption) THEN
                EXIT;

        OnAfterConfirmPost(PurchaseHeader);

        PurchSetup.GET;
        IF PurchSetup."Post with Job Queue" THEN
            PurchPostViaJobQueue.EnqueuePurchDoc(PurchaseHeader)
        ELSE BEGIN
            OnBeforeRunPurchPost(PurchaseHeader);
            CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PurchaseHeader);
        END;

        OnAfterPost(PurchaseHeader);
    END;

    LOCAL PROCEDURE ConfirmPost(VAR PurchaseHeader: Record 38; DefaultOption: Integer): Boolean;
    VAR
        ConfirmManagement: Codeunit 50206;
        Selection: Integer;
    BEGIN
        IF DefaultOption > 3 THEN
            DefaultOption := 3;
        IF DefaultOption <= 0 THEN
            DefaultOption := 1;

        WITH PurchaseHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    BEGIN
                        Selection := STRMENU(ReceiveInvoiceQst, DefaultOption);
                        IF Selection = 0 THEN
                            EXIT(FALSE);
                        Receive := Selection IN [1, 3];
                        Invoice := Selection IN [2, 3];
                    END;
                "Document Type"::"Return Order":
                    BEGIN
                        Selection := STRMENU(ShipInvoiceQst, DefaultOption);
                        IF Selection = 0 THEN
                            EXIT(FALSE);
                        Ship := Selection IN [1, 3];
                        Invoice := Selection IN [2, 3];
                    END
                ELSE
                    IF NOT ConfirmManagement.ConfirmProcess(
                         STRSUBSTNO(PostConfirmQst, LOWERCASE(FORMAT("Document Type"))), TRUE)
                    THEN
                        EXIT(FALSE);
            END;
            "Print Posted Documents" := FALSE;
        END;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE Preview(VAR PurchaseHeader: Record 38);
    VAR
        GenJnlPostPreview: Codeunit 19;
        PurchPostYesNo: Codeunit 91;
    BEGIN
        BINDSUBSCRIPTION(PurchPostYesNo);
        GenJnlPostPreview.Preview(PurchPostYesNo, PurchaseHeader);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPost(VAR PurchaseHeader: Record 38);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterConfirmPost(PurchaseHeader: Record 38);
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 19, OnRunPreview, '', true, true)]
    LOCAL PROCEDURE OnRunPreview(VAR Result: Boolean; Subscriber: Variant; RecVar: Variant);
    VAR
        PurchaseHeader: Record 38;
        PurchPost: Codeunit 90;
        "--------------------------- QB": Integer;
        QBPurchReceiveFRISPreview: Codeunit 7206927;
        QB_Menu: TextConst ESP = 'FRI/Albar�n,Factura';
        QB_Title: TextConst ESP = 'Seleccione el tipo de documento';
    BEGIN
        WITH PurchaseHeader DO BEGIN
            COPY(RecVar);
            Ship := "Document Type" = "Document Type"::"Return Order";
            Receive := "Document Type" = "Document Type"::Order;
            Invoice := TRUE;

            //JAV 19/10/20: - QB 1.06.21 Si es un pedido de compra, la vista previa es del albar�n o de la factura
            IF ("Document Type" = "Document Type"::Order) THEN BEGIN
                CASE STRMENU(QB_Menu, 1, QB_Title) OF
                    0:
                        EXIT;
                    1:
                        BEGIN
                            Ship := FALSE;
                            Receive := TRUE;
                            Invoice := FALSE;
                            "QB Receive in FRIS" := TRUE;
                        END;
                END;
            END;
            //JAV fin

        END;
        PurchPost.SetPreviewMode(TRUE);
        Result := PurchPost.RUN(PurchaseHeader);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeConfirmPost(VAR PurchaseHeader: Record 38; VAR HideDialog: Boolean; VAR IsHandled: Boolean; VAR DefaultOption: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRunPurchPost(VAR PurchaseHeader: Record 38);
    BEGIN
    END;

    /*BEGIN
/*{
      JAV 19/10/20: - QB 1.06.21 Si es un pedido de compra, la vista previa es del albar�n o de la factura
    }
END.*/
}








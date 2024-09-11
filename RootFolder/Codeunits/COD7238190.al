Codeunit 7238190 "QPR - Page - Subscriber"
{


    trigger OnRun()
    BEGIN
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- Para Ventas"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 47, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE PagSalesInvoiceSubform_OnNewRecordEvent(VAR Rec: Record 37; BelowxRec: Boolean; VAR xRec: Record 37);
    VAR
        SalesHeader: Record 36;
    BEGIN
        IF SalesHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            Rec.VALIDATE("Job No.", SalesHeader."QB Job No.");
    END;

    [EventSubscriber(ObjectType::Page, 46, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE PagSalesOrderSubform_OnNewRecordEvent(VAR Rec: Record 37; BelowxRec: Boolean; VAR xRec: Record 37);
    VAR
        SalesHeader: Record 36;
    BEGIN
        IF SalesHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            Rec.VALIDATE("Job No.", SalesHeader."QB Job No.");
    END;

    // [EventSubscriber(ObjectType::Page, 44, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE PagSalesCreditMemoSubform_OnNewRecordEvent(VAR Rec: Record 37; BelowxRec: Boolean; VAR xRec: Record 37);
    VAR
        SalesHeader: Record 36;
    BEGIN
        IF SalesHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            Rec.VALIDATE("Job No.", SalesHeader."QB Job No.");
    END;

    [EventSubscriber(ObjectType::Page, 6631, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE PagSalesReturnOrderSubform_OnNewRecordEvent(VAR Rec: Record 37; BelowxRec: Boolean; VAR xRec: Record 37);
    VAR
        SalesHeader: Record 36;
    BEGIN
        IF SalesHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            Rec.VALIDATE("Job No.", SalesHeader."QB Job No.");
    END;

    // [EventSubscriber(ObjectType::Page, 47, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE PagSalesInvoiceSubform_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 37);
    BEGIN
        CreateSalesRecord(Rec);//QRE_16277
    END;

    // [EventSubscriber(ObjectType::Page, 46, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE PagSalesOrderSubform_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 37);
    BEGIN
        CreateSalesRecord(Rec);//QRE_16277
    END;

    // [EventSubscriber(ObjectType::Page, 96, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE PagSalesCreditMemoSubform_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 37);
    BEGIN
        CreateSalesRecord(Rec);//QRE_16277
    END;

    // [EventSubscriber(ObjectType::Page, 6631, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE PagSalesReturnOrderSubform_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 37);
    BEGIN
        CreateSalesRecord(Rec);//QRE_16277
    END;

    LOCAL PROCEDURE CreateSalesRecord(VAR Rec: Record 37);
    VAR
        SalesHeader: Record 36;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Resource: Record 156;
        Item: Record 27;
        existResourceItem: Boolean;
        DimensionValue: Record 349;
        DataPieceworkForProduction: Record 7207386;
        SalesLine: Record 37;
        LineNo: Integer;
    BEGIN
        //QRE_15436+

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de RE/PR
        IF (NOT FunctionQB.AccessToBudgets) AND (NOT FunctionQB.AccessToRealEstate) THEN
            EXIT;

        IF SalesHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            IF (FunctionQB.Job_ByBudgetItem(SalesHeader."QB Job No.")) THEN BEGIN
                QuoBuildingSetup.GET;

                //Si est� marcado crear recurso o producto = partida
                IF (QuoBuildingSetup."QB_QPR Create Auto" <> QuoBuildingSetup."QB_QPR Create Auto"::None) THEN BEGIN  //Si el c�digo no es el mimso que la U.O. lo reemplazo
                    LineNo := 10000;

                    SalesLine.LOCKTABLE;

                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                    IF SalesLine.FINDLAST THEN
                        LineNo += SalesLine."Line No.";

                    SalesLine.RESET;
                    SalesLine.INIT;
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Line No." := LineNo;
                    SalesLine.INSERT;

                    CASE QuoBuildingSetup."QB_QPR Create Auto" OF
                        QuoBuildingSetup."QB_QPR Create Auto"::Resource:
                            BEGIN
                                SalesLine.Type := SalesLine.Type::Resource;
                                IF Resource.GET(SalesHeader."QB Budget item") THEN BEGIN
                                    SalesLine.VALIDATE("No.", SalesHeader."QB Budget item");
                                    existResourceItem := TRUE;
                                END;
                            END;
                        QuoBuildingSetup."QB_QPR Create Auto"::Item:
                            BEGIN
                                SalesLine.Type := SalesLine.Type::Item;
                                IF Item.GET(SalesHeader."QB Budget item") THEN BEGIN
                                    SalesLine.VALIDATE("No.", SalesHeader."QB Budget item");
                                    existResourceItem := TRUE;
                                END;

                            END;
                    END;

                    IF existResourceItem THEN BEGIN
                        SalesLine.VALIDATE("Job No.", SalesHeader."QB Job No.");

                        //Solo si est� marcado crear Valor Dimensi�n = Partida
                        IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
                            IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), SalesHeader."QB Budget item")) THEN BEGIN
                                CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA()) OF
                                    1:
                                        SalesLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."QB Budget item");
                                    2:
                                        SalesLine.VALIDATE("Shortcut Dimension 2 Code", SalesHeader."QB Budget item");
                                END;
                            END;

                        //Solo si est� marcado crear grupo registro = Partida
                        IF (QuoBuildingSetup."QB_QPR Create Post. Group") THEN BEGIN
                            IF (SalesLine."Posting Group" <> SalesHeader."QB Budget item") THEN
                                SalesLine.VALIDATE("Posting Group", SalesHeader."QB Budget item");
                        END;

                        IF SalesHeader."QB Budget item" <> '' THEN BEGIN
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", Rec."Job No.");
                            DataPieceworkForProduction.SETRANGE("Piecework Code", SalesHeader."QB Budget item");
                            IF NOT DataPieceworkForProduction.ISEMPTY THEN
                                SalesLine.VALIDATE("QB_Piecework No.", SalesHeader."QB Budget item");
                        END;
                    END;

                    SalesLine.MODIFY;
                END;
            END;
        //QRE_15436-
    END;

    LOCAL PROCEDURE "----------------------------------------------------------------------- Para Compras"();
    BEGIN
    END;

    PROCEDURE PurchaseLine_InitValues(VAR Rec: Record 39);
    VAR
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //JAV 26/05/22: - Inicializa los campos de las l�neas desde la cabecera.
        //------------------------------------------------------------------------------------------------------------

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de QB/RE/PR
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            IF PurchaseHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                IF (PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Job) THEN BEGIN  //Solo para pedidos contra proyecto se informa este
                    Rec.VALIDATE("Job No.", PurchaseHeader."QB Job No.");
                    Rec.VALIDATE("Piecework No.", PurchaseHeader."QB Budget item");
                END;
                Rec.VALIDATE("QB CA Code");
                Rec.VALIDATE("QB CA Value", PurchaseHeader."QB Budget item");
            END;
        END;
    END;

    LOCAL PROCEDURE PurchaseLine_SetValues(VAR Rec: Record 39; pValidate: Boolean);
    VAR
        PurchaseHeader: Record 38;
        FunctionQB: Codeunit 7207272;
        Value: Code[20];
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //JAV 26/05/22: - A partir de las dimensiones ajusta los campos de la l�nea si es necesario. Si existe la l�nea se guarda los cambios.
        //------------------------------------------------------------------------------------------------------------

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de QB/RE/PR
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            IF PurchaseHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                IF (pValidate) THEN BEGIN
                    IF (PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Job) THEN BEGIN    //Solo para pedidos contra proyecto se informa este
                        Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimJobs, Rec."Dimension Set ID");
                        IF (Rec."Job No." <> Value) THEN
                            Rec.VALIDATE("Job No.", Value);
                    END;
                    Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, Rec."Dimension Set ID");
                    IF (Rec."QB CA Value" <> Value) THEN
                        Rec.VALIDATE("QB CA Value", Value);
                END ELSE BEGIN
                    IF (PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Job) THEN BEGIN  //Solo para pedidos contra proyecto se informa este
                        Rec."Job No." := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimJobs, Rec."Dimension Set ID");
                    END;
                    Rec.VALIDATE("QB CA Code");
                    Rec."QB CA Value" := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, Rec."Dimension Set ID");
                END;
            END;

            //Si existe la l�nea nos las guardamos
            IF NOT Rec.MODIFY(FALSE) THEN;
        END;
    END;

    LOCAL PROCEDURE CreatePurchaseLine(VAR Rec: Record 39);
    VAR
        PurchaseHeader: Record 38;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        Resource: Record 156;
        Item: Record 27;
        existResourceItem: Boolean;
        DimensionValue: Record 349;
        DataPieceworkForProduction: Record 7207386;
        PurchaseLine: Record 39;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //QRE_15436+ Crea una l�nea de compa copiando los campos de la partida presupuestaria de la cabecera
        //------------------------------------------------------------------------------------------------------------

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de RE/PR
        IF (NOT FunctionQB.AccessToBudgets) AND (NOT FunctionQB.AccessToRealEstate) THEN
            EXIT;

        IF PurchaseHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            IF (FunctionQB.Job_ByBudgetItem(PurchaseHeader."QB Job No.")) THEN BEGIN
                QuoBuildingSetup.GET;

                //Si est� marcado crear recurso o producto = partida
                IF (QuoBuildingSetup."QB_QPR Create Auto" <> QuoBuildingSetup."QB_QPR Create Auto"::None) THEN BEGIN  //Si el c�digo no es el mimso que la U.O. lo reemplazo
                    LineNo := 10000;

                    PurchaseLine.LOCKTABLE;

                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                    IF PurchaseLine.FINDLAST THEN
                        LineNo += PurchaseLine."Line No.";

                    PurchaseLine.RESET;
                    PurchaseLine.INIT;
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Line No." := LineNo;
                    PurchaseLine.INSERT;

                    PurchaseLine_UpdateFromBudgetItem(PurchaseLine);
                    PurchaseLine.VALIDATE("Job No.", PurchaseHeader."QB Job No.");
                    PurchaseLine.MODIFY;
                END;
            END;
        //QRE_15436-
    END;

    LOCAL PROCEDURE PurchaseLine_UpdateFromBudgetItem(VAR Rec: Record 39);
    VAR
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
        GLAccount: Record 15;
        Resource: Record 156;
        Item: Record 27;
        existResourceItem: Boolean;
        DimensionValue: Record 349;
        DataPieceworkForProduction: Record 7207386;
        LineNo: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //JAV 30/05/22: - QB 1.10.45 Modificar una l�nea de compra a partir de la partida presupuestaria
        //------------------------------------------------------------------------------------------------------------

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de RE/PR
        IF (NOT FunctionQB.AccessToBudgets) AND (NOT FunctionQB.AccessToRealEstate) THEN
            EXIT;

        IF DataPieceworkForProduction.GET(Rec."Job No.", Rec."Piecework No.") THEN BEGIN
            IF (FunctionQB.Job_ByBudgetItem(Rec."Job No.")) THEN BEGIN

                //Cargamos datos de la Partida
                CASE DataPieceworkForProduction."QPR Type" OF
                    DataPieceworkForProduction."QPR Type"::Account:
                        BEGIN
                            IF GLAccount.GET(DataPieceworkForProduction."QPR No.") THEN BEGIN
                                Rec.Type := Rec.Type::"G/L Account";
                                Rec.VALIDATE("No.", DataPieceworkForProduction."QPR No.");
                                //-18420
                                Rec.VALIDATE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                                //+18420
                                existResourceItem := TRUE;
                            END;
                        END;
                    DataPieceworkForProduction."QPR Type"::Resource:
                        BEGIN
                            IF Resource.GET(DataPieceworkForProduction."QPR No.") THEN BEGIN
                                Rec.Type := Rec.Type::Resource;
                                Rec.VALIDATE("No.", DataPieceworkForProduction."QPR No.");
                                existResourceItem := TRUE;
                            END;
                        END;
                    DataPieceworkForProduction."QPR Type"::Item:
                        BEGIN
                            IF Item.GET(DataPieceworkForProduction."QPR No.") THEN BEGIN
                                Rec.Type := Rec.Type::Item;
                                Rec.VALIDATE("No.", DataPieceworkForProduction."QPR No.");
                                existResourceItem := TRUE;
                            END;
                        END;
                END;

                //Si existe el registro base, pasamos los otros valores
                IF existResourceItem THEN BEGIN
                    Rec.VALIDATE("QB CA Code");
                    Rec.VALIDATE("QB CA Value", DataPieceworkForProduction."QPR AC");

                    IF (DataPieceworkForProduction."QPR Gen Posting Group" <> '') THEN
                        //JAV 18/06/22: - QB 1.10.51 Usaba el campo de grupo registro gener�l err�neo
                        //Rec.VALIDATE("Posting Group",  DataPieceworkForProduction."QPR Gen Posting Group");
                        Rec.VALIDATE("Gen. Bus. Posting Group", DataPieceworkForProduction."QPR Gen Posting Group");
                    IF (DataPieceworkForProduction."QPR Gen Prod. Posting Group" <> '') THEN
                        Rec.VALIDATE("Gen. Prod. Posting Group", DataPieceworkForProduction."QPR Gen Prod. Posting Group");
                    IF (DataPieceworkForProduction."QPR VAT Prod. Posting Group" <> '') THEN
                        Rec.VALIDATE("VAT Prod. Posting Group", DataPieceworkForProduction."QPR VAT Prod. Posting Group");
                END;

                //Rec.MODIFY;
            END;
        END;
    END;

    PROCEDURE ComparativeLine_InitValues(VAR Rec: Record 7207413);
    VAR
        ComparativeQuoteHeader: Record 7207412;
        QuoBuildingSetup: Record 7207278;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //JAV 26/05/22: - Inicializa los campos de las l�neas del comparativo desde la cabecera.
        //------------------------------------------------------------------------------------------------------------

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de QB/RE/PR
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            IF ComparativeQuoteHeader.GET(Rec."Quote No.") THEN BEGIN
                Rec.VALIDATE("Job No.", ComparativeQuoteHeader."Job No.");
                Rec.VALIDATE("Piecework No.", ComparativeQuoteHeader."QB Budget item");
                Rec.VALIDATE("QB CA Code");
                Rec.VALIDATE("QB CA Value", ComparativeQuoteHeader."QB Budget item");
            END;
        END;
    END;

    LOCAL PROCEDURE ComparativeLine_SetValues(VAR Rec: Record 7207413; pValidate: Boolean);
    VAR
        ComparativeQuoteHeader: Record 7207412;
        FunctionQB: Codeunit 7207272;
        Value: Code[20];
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //JAV 26/05/22: - A partir de las dimensiones ajusta los campos de la l�nea del comparativo si es necesario. Si existe la l�nea se guarda los cambios.
        //------------------------------------------------------------------------------------------------------------

        //JAV 27/05/22: - QB 1.10.45 Solo se lanza si estamos en empresas de QB/RE/PR
        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            IF ComparativeQuoteHeader.GET(Rec."Quote No.") THEN BEGIN
                IF (pValidate) THEN BEGIN
                    Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimJobs, Rec."Dimension Set ID");
                    IF (Rec."Job No." <> Value) THEN
                        Rec.VALIDATE("Job No.", Value);
                    Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, Rec."Dimension Set ID");
                    IF (Rec."QB CA Value" <> Value) THEN
                        Rec.VALIDATE("QB CA Value", Value);
                END ELSE BEGIN
                    Rec."Job No." := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimJobs, Rec."Dimension Set ID");
                    Rec.VALIDATE("QB CA Code");
                    Rec."QB CA Value" := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, Rec."Dimension Set ID");
                END;
            END;

            //Si existe la l�nea nos las guardamos
            IF NOT Rec.MODIFY(FALSE) THEN;
        END;
    END;

    PROCEDURE CrearNewComparativeLine(rec: Record 7207412);
    VAR
        CompQuoteLines: Record 7207413;
        DataPieceworkForProduction: Record 7207386;
        Resource: Record 156;
        Item: Record 27;
        FunctionQB: Codeunit 7207272;
        nLine: Integer;
    BEGIN
        //------------------------------------------------------------------------------------------------------------
        //Crear una l�nea del comparativo con el c�digo de la unidad de obra de la cabecera
        //------------------------------------------------------------------------------------------------------------

        //RE16204-LCG-280122-INI
        IF (rec."Job No." = '') OR (rec."QB Budget item" = '') THEN
            EXIT;

        IF (NOT DataPieceworkForProduction.GET(rec."Job No.", rec."QB Budget item")) THEN
            EXIT;

        //JAV 13/03/22: - QB 1.10.24 Solo para proyectos de presupuesto o promoci�n
        IF (NOT FunctionQB.Job_IsBudget(rec."Job No.")) THEN
            EXIT;

        //JAV 27/02/22: - QB 1.10.22 Primero miro si ya existe para no crearlo varias veces
        CompQuoteLines.RESET;
        CompQuoteLines.SETRANGE("Quote No.", rec."No.");
        CASE DataPieceworkForProduction."QPR Type" OF
            DataPieceworkForProduction."QPR Type"::Resource:
                CompQuoteLines.SETRANGE(Type, CompQuoteLines.Type::Resource);
            DataPieceworkForProduction."QPR Type"::Item:
                CompQuoteLines.SETRANGE(Type, CompQuoteLines.Type::Item);
        END;
        CompQuoteLines.SETRANGE("No.", rec."QB Budget item");
        IF (NOT CompQuoteLines.ISEMPTY) THEN
            EXIT;

        //Creo la l�nea porque no existe
        CompQuoteLines.RESET;
        CompQuoteLines.SETRANGE("Quote No.", rec."No.");
        IF CompQuoteLines.FINDLAST THEN
            nLine := CompQuoteLines."Line No." + 10000
        ELSE
            nLine := 10000;

        CompQuoteLines.INIT();
        CompQuoteLines."Quote No." := rec."No.";
        CompQuoteLines."Line No." := nLine;

        CASE DataPieceworkForProduction."QPR Type" OF
            DataPieceworkForProduction."QPR Type"::Resource:
                BEGIN
                    CompQuoteLines.Type := CompQuoteLines.Type::Resource;
                    IF Resource.GET(rec."QB Budget item") THEN
                        CompQuoteLines.VALIDATE("No.", Resource."No.");
                END;
            DataPieceworkForProduction."QPR Type"::Item:
                BEGIN
                    CompQuoteLines.Type := CompQuoteLines.Type::Item;
                    IF Item.GET(rec."QB Budget item") THEN
                        CompQuoteLines.VALIDATE("No.", Item."No.");
                END;
        END;
        CompQuoteLines.VALIDATE("Job No.", rec."Job No.");
        CompQuoteLines."Piecework No." := rec."QB Budget item";

        //Si no ha encontrado producto o recurso, no creo la l�nea
        IF (CompQuoteLines."No." <> '') THEN
            CompQuoteLines.INSERT(TRUE);

        //RE16204-LCG-280122-FIN
    END;

    LOCAL PROCEDURE "---------------------------------------------------PG 54 Order Subform"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 54, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE P54_OnNewRecordEvent(VAR Rec: Record 39; BelowxRec: Boolean; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_InitValues(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnAfterGetRecordEvent, '', true, true)]
    LOCAL PROCEDURE P54_OnAfterGetRecordEvent(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnAfterActionEvent, Dimensions, true, true)]
    LOCAL PROCEDURE P54_OnAfterActionEvent_Dimensions(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, QB_PieceworkNo, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Piecework(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_UpdateFromBudgetItem(Rec);
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39);
    VAR
        FunctionQB: Codeunit 7207272;
    BEGIN
        FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, Rec."Job No.", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, "Shortcut Dimension 1 Code", true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim1(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, "Shortcut Dimension 2 Code", true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim2(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    //[EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, Control300, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim3(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, Control302, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim4(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, Control304, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim5(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, Control306, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim6(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, Control308, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim7(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 54, OnAfterValidateEvent, Control310, true, true)]
    LOCAL PROCEDURE P54_OnAfterValidateEvent_Dim8(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 54, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE P54_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 39);
    BEGIN
        CreatePurchaseLine(Rec);//QRE_16277
    END;

    LOCAL PROCEDURE "---------------------------------------------------PG 55 Invoice Subform"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 55, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE P55_OnNewRecordEvent(VAR Rec: Record 39; BelowxRec: Boolean; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_InitValues(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 55, OnAfterGetRecordEvent, '', true, true)]
    LOCAL PROCEDURE P55_OnAfterGetRecordEvent(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, FALSE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterActionEvent, Action1904974904, true, true)]
    LOCAL PROCEDURE P55_OnAfterActionEvent_Dimensions(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, QB_PieceworkNo, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Piecework(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_UpdateFromBudgetItem(Rec);
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, "Shortcut Dimension 1 Code", true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim1(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, "Shortcut Dimension 2 Code", true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim2(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, Control300, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim3(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, Control302, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim4(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, Control304, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim5(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, Control306, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim6(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, Control308, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim7(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 55, OnAfterValidateEvent, Control310, true, true)]
    LOCAL PROCEDURE P55_OnAfterValidateEvent_Dim8(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 55, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE P55_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 39);
    BEGIN
        CreatePurchaseLine(Rec);//QRE_16277
    END;

    LOCAL PROCEDURE "---------------------------------------------------PG 98 Cr.Memo Subform"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 98, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE P98_OnNewRecordEvent(VAR Rec: Record 39; BelowxRec: Boolean; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_InitValues(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 98, OnAfterGetRecordEvent, '', true, true)]
    LOCAL PROCEDURE P98_OnAfterGetRecordEvent(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Page, 98, OnAfterActionEvent, Action1902740304, true, true)]
    LOCAL PROCEDURE P98_OnAfterActionEvent_Dimensions(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, QB_PieceworkNo, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Piecework(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_UpdateFromBudgetItem(Rec);
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, "Shortcut Dimension 1 Code", true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim1(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, "Shortcut Dimension 2 Code", true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim2(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, Control300, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim3(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, Control302, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim4(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, Control304, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim5(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, Control306, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim6(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, Control308, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim7(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 98, OnAfterValidateEvent, Control310, true, true)]
    LOCAL PROCEDURE P98_OnAfterValidateEvent_Dim8(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 98, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE P98_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 39);
    BEGIN
        CreatePurchaseLine(Rec);//QRE_16277
    END;

    LOCAL PROCEDURE "---------------------------------------------------PG 6641 Purchase Return Order Subform"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 6641, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE P6641_OnNewRecordEvent(VAR Rec: Record 39; BelowxRec: Boolean; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_InitValues(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 6641, OnAfterGetRecordEvent, '', true, true)]
    LOCAL PROCEDURE P6641_OnAfterGetRecordEvent(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, FALSE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterActionEvent, Action1902740304, true, true)]
    LOCAL PROCEDURE P6641_OnAfterActionEvent_Dimensions(VAR Rec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, QB_PieceworkNo, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Piecework(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_UpdateFromBudgetItem(Rec);
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_No(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, "Shortcut Dimension 1 Code", true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim1(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, "Shortcut Dimension 2 Code", true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim2(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, Control300, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim3(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, Control302, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim4(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, Control304, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim5(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, Control306, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim6(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, Control308, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim7(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 6641, OnAfterValidateEvent, Control310, true, true)]
    LOCAL PROCEDURE P6641_OnAfterValidateEvent_Dim8(VAR Rec: Record 39; VAR xRec: Record 39);
    BEGIN
        PurchaseLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 6641, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE P6641_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 39);
    BEGIN
        CreatePurchaseLine(Rec);//QRE_16277
    END;

    LOCAL PROCEDURE "---------------------------------------------------PG 7207547 Comparative Quote Lin. Subform"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnNewRecordEvent, '', true, true)]
    LOCAL PROCEDURE P7207547_OnNewRecordEvent(VAR Rec: Record 7207413; BelowxRec: Boolean; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_InitValues(Rec);
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnAfterGetRecordEvent, '', true, true)]
    LOCAL PROCEDURE P7207547_OnAfterGetRecordEvent(VAR Rec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, FALSE);
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnAfterActionEvent, Action1100286043, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterActionEvent_Dimensions(VAR Rec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, "Piecework No.", true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Piecework(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_No(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, "Shortcut Dimension 1 Code", true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim1(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, "Shortcut Dimension 2 Code", true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim2(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, Control300, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim3(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, Control302, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim4(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, Control304, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim5(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, Control306, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim6(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, Control308, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim7(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnAfterValidateEvent, Control310, true, true)]
    LOCAL PROCEDURE P7207547_OnAfterValidateEvent_Dim8(VAR Rec: Record 7207413; VAR xRec: Record 7207413);
    BEGIN
        ComparativeLine_SetValues(Rec, TRUE);
    END;

    // [EventSubscriber(ObjectType::Page, 7207547, OnBeforeActionEvent, InsertAutoLine, true, true)]
    LOCAL PROCEDURE P7207547_OnBeforeActionEvent_InsertAutoLine(VAR Rec: Record 7207413);
    BEGIN
        //CrearNewComparativeLine(Rec);
    END;

    /*BEGIN
/*{
      JAV 27/05/22: - QB 1.10.45 Revisi�n general de toda la CU, se cambia por completo el modo de trabajo
      JAV 18/06/22: - QB 1.10.51 Usaba el campo de grupo registro gener�l err�neo
      AML 19/10/23: - Q18420 Traspasado 19855 de QRE.
    }
END.*/
}








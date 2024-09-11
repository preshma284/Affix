Codeunit 7206909 "QB Post Receipt/Transfer"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        ReceiptLine: Record 7206971;
        Nline: Integer;

    PROCEDURE Post(ReceiptTransferHeader: Record 7206970; Print: Boolean);
    VAR
        PostReceiptHD: Record 7206972;
        PostReceiptLine: Record 7206973;
        Message001: TextConst ENU = 'The document has been correctly registered', ESP = 'El documento se ha registrado correctamente';
        WarehouseSetup: Record 5769;
        NoSeriesManagement: Codeunit 396;
        ItemJournalLine: Record 83;
        ItemJournalLine2: Record 83;
        NoSeriesMgt: Codeunit 396;
        ItemJnlBatch: Record 233;
        // PostedLocationAdjust: Report 50018;
        PostReceiptHD2: Record 7206972;
        CededEntry: Record 7206976;
        QuoBuildingSetup: Record 7207278;
        QBSuscripcionesAlmacen: Codeunit 7206910;
        rItem: Record 27;
    BEGIN
        Nline := 10000;
        CheckLines(ReceiptTransferHeader);
        CheckWarehouseSetup;
        CheckType(ReceiptTransferHeader);

        CASE ReceiptTransferHeader.Type OF
            ReceiptTransferHeader.Type::Receipt:
                CheckReceipts(ReceiptTransferHeader);
            ReceiptTransferHeader.Type::Transfer:
                CheckTransfer(ReceiptTransferHeader);
            ReceiptTransferHeader.Type::Setting:
                CheckAdjust(ReceiptTransferHeader);
        END;

        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Receipt Management Section");
        QuoBuildingSetup.TESTFIELD("Receipt Management Journal");

        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Receipt Management Section");
        ItemJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Receipt Management Journal");
        IF ItemJournalLine.FINDSET THEN
            REPEAT
                ItemJournalLine.DELETE(TRUE);
            UNTIL ItemJournalLine.NEXT = 0;

        PostReceiptHD.INIT;
        PostReceiptHD.TRANSFERFIELDS(ReceiptTransferHeader);
        PostReceiptHD."No." := '';

        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Serie for Receipt/Transfer Pos");
        NoSeriesManagement.InitSeries(QuoBuildingSetup."Serie for Receipt/Transfer Pos", PostReceiptHD."No.", 0D, PostReceiptHD."No.", PostReceiptHD."No. Serie");

        PostReceiptHD.Posted := TRUE;
        PostReceiptHD.User := USERID;
        PostReceiptHD.INSERT(TRUE);

        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.", ReceiptTransferHeader."No.");
        IF ReceiptLine.FINDSET THEN
            REPEAT
                CASE PostReceiptHD.Type OF
                    PostReceiptHD.Type::Receipt,
                    PostReceiptHD.Type::Setting:
                        BEGIN
                            PostReceiptLine.INIT;
                            PostReceiptLine.TRANSFERFIELDS(ReceiptLine);
                            PostReceiptLine."Document No." := PostReceiptHD."No.";
                            PostReceiptLine.INSERT(TRUE);

                            ItemJournalLine.RESET;
                            ItemJournalLine.INIT;
                            ItemJournalLine.VALIDATE("Journal Template Name", QuoBuildingSetup."Receipt Management Journal");
                            ItemJournalLine.VALIDATE("Journal Batch Name", QuoBuildingSetup."Receipt Management Section");
                            ItemJournalLine."Line No." := Nline;
                            ItemJournalLine.VALIDATE("Posting Date", ReceiptTransferHeader."Posting Date");
                            CASE PostReceiptHD.Type OF
                                PostReceiptHD.Type::Receipt,
                                PostReceiptHD.Type::Setting:
                                    BEGIN
                                        IF ReceiptLine.Quantity < 0 THEN
                                            ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.")
                                        ELSE
                                            ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                                    END;
                                ELSE BEGIN
                                    ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::Transfer)
                                END;
                            END;

                            ItemJournalLine.VALIDATE("Document No.", PostReceiptLine."Document No.");

                            ItemJournalLine.VALIDATE("Item No.", ReceiptLine."Item No.");
                            ItemJournalLine.VALIDATE(Description, ReceiptLine.Description);
                            ItemJournalLine.VALIDATE("Location Code", ReceiptLine."Origin Location");
                            //QUO PER 29.08.19 ERROR CANTIDAD NEGATIVA.
                            IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::"Negative Adjmt." THEN
                                ItemJournalLine.VALIDATE(Quantity, ReceiptLine.Quantity * -1)
                            ELSE
                                //FIN QUO PER 29.08.19
                                ItemJournalLine.VALIDATE(Quantity, ReceiptLine.Quantity);
                            ItemJournalLine.VALIDATE("Unit of Measure Code", ReceiptLine."Unit of Measure Code");
                            IF ReceiptLine."Destination Location" <> '' THEN
                                ItemJournalLine.VALIDATE("New Location Code", ReceiptLine."Destination Location");
                            ItemJournalLine.VALIDATE("Unit Cost", ReceiptLine."Unit Cost");
                            ItemJournalLine."QB Diverse Entrance" := ReceiptTransferHeader."Diverse Entrance";
                            ItemJournalLine."QB Ceded Control" := TRUE;
                            ItemJournalLine."Job No." := ReceiptTransferHeader."Job No.";
                            ItemJournalLine.INSERT(TRUE);
                            SetDimensions(ItemJournalLine);
                            Nline += 10000;
                        END;

                    PostReceiptHD.Type::Transfer:
                        BEGIN
                            PostReceiptLine.INIT;
                            PostReceiptLine.TRANSFERFIELDS(ReceiptLine);
                            PostReceiptLine."Document No." := PostReceiptHD."No.";
                            PostReceiptLine.INSERT(TRUE);

                            ItemJournalLine.RESET;
                            ItemJournalLine.INIT;
                            ItemJournalLine.VALIDATE("Journal Template Name", QuoBuildingSetup."Receipt Management Journal");
                            ItemJournalLine.VALIDATE("Journal Batch Name", QuoBuildingSetup."Receipt Management Section");
                            ItemJournalLine."Line No." := Nline;
                            ItemJournalLine.VALIDATE("Posting Date", ReceiptTransferHeader."Posting Date");
                            ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                            ItemJournalLine.VALIDATE("Document No.", PostReceiptLine."Document No.");
                            ItemJournalLine.VALIDATE("Item No.", ReceiptLine."Item No.");
                            ItemJournalLine.VALIDATE(Description, ReceiptLine.Description);
                            ItemJournalLine.VALIDATE("Location Code", ReceiptLine."Origin Location");
                            ItemJournalLine.VALIDATE(Quantity, ReceiptLine.Quantity);
                            ItemJournalLine.VALIDATE("Unit of Measure Code", ReceiptLine."Unit of Measure Code");
                            ItemJournalLine.VALIDATE("Unit Cost", ReceiptLine."Unit Cost");
                            ItemJournalLine."QB Diverse Entrance" := ReceiptTransferHeader."Diverse Entrance";
                            ItemJournalLine."QB Ceded Control" := TRUE;
                            ItemJournalLine."Job No." := ReceiptTransferHeader."Job No.";
                            ItemJournalLine.INSERT(TRUE);
                            SetDimensions(ItemJournalLine);
                            Nline += 10000;

                            ItemJournalLine.INIT;
                            ItemJournalLine.VALIDATE("Journal Template Name", QuoBuildingSetup."Receipt Management Journal");
                            ItemJournalLine.VALIDATE("Journal Batch Name", QuoBuildingSetup."Receipt Management Section");
                            ItemJournalLine."Line No." := Nline;
                            ItemJournalLine.VALIDATE("Posting Date", ReceiptTransferHeader."Posting Date");
                            ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                            ItemJournalLine.VALIDATE("Document No.", PostReceiptLine."Document No.");
                            ItemJournalLine.VALIDATE("Item No.", ReceiptLine."Item No.");
                            ItemJournalLine.VALIDATE(Description, ReceiptLine.Description);
                            ItemJournalLine.VALIDATE("Location Code", ReceiptLine."Destination Location");

                            //Almacenamo el alamcen origen de la transferencia, para poder crear el movimiento de cedido
                            ItemJournalLine."New Location Code" := ReceiptLine."Origin Location";

                            ItemJournalLine.VALIDATE(Quantity, ReceiptLine.Quantity);
                            ItemJournalLine.VALIDATE("Unit of Measure Code", ReceiptLine."Unit of Measure Code");
                            // EPV Q17138 <--
                            IF rItem.GET(ReceiptLine."Item No.") THEN BEGIN
                                CASE QuoBuildingSetup."Coste prod. prestados recibido" OF

                                    QuoBuildingSetup."Coste prod. prestados recibido"::"Coste almacen principal":
                                        BEGIN
                                            rItem.CALCFIELDS("QB Main Location Cost");
                                            ItemJournalLine."Unit Cost" := rItem."QB Main Location Cost";
                                        END;

                                    QuoBuildingSetup."Coste prod. prestados recibido"::"Ultimo coste directo":
                                        BEGIN
                                            ItemJournalLine."Unit Cost" := rItem."Last Direct Cost";
                                        END;

                                    QuoBuildingSetup."Coste prod. prestados recibido"::"Coste medio compra":
                                        BEGIN
                                            ItemJournalLine."Unit Cost" := rItem."QB Main Loc. Purch. Average Pr";
                                        END;

                                END; //case

                                IF (ItemJournalLine."Unit Cost" = 0) THEN
                                    IF NOT CONFIRM('El precio del producto %1 es cero �Desea continuar?', TRUE, ItemJournalLine."Item No.") THEN
                                        ERROR('Proceso cancelado');
                            END;
                            // EPV Q17138 -->
                            ItemJournalLine."QB Diverse Entrance" := ReceiptTransferHeader."Diverse Entrance";
                            ItemJournalLine."QB Ceded Control" := TRUE;
                            ItemJournalLine."Job No." := ReceiptTransferHeader."Job No.";
                            ItemJournalLine.INSERT(TRUE);
                            SetDimensions(ItemJournalLine);
                            Nline += 10000;
                        END;
                END;
            UNTIL ReceiptLine.NEXT = 0;

        ItemJournalLine2.RESET;
        ItemJournalLine2.SETRANGE("Journal Batch Name", QuoBuildingSetup."Receipt Management Section");
        ItemJournalLine2.SETRANGE("Journal Template Name", QuoBuildingSetup."Receipt Management Journal");
        IF ItemJournalLine2.FINDSET THEN
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine2);

        ReceiptTransferHeader.Posted := TRUE;
        ReceiptTransferHeader.MODIFY(TRUE);

        IF Print THEN BEGIN
            COMMIT;
            PostReceiptHD2.GET(PostReceiptHD."No.");
            // REPORT.RUNMODAL(REPORT::"QB Posted Location Adjust", TRUE, TRUE, PostReceiptHD2);
        END;

        IF ReceiptTransferHeader.Type = ReceiptTransferHeader.Type::Receipt THEN BEGIN

            CededEntry.RESET;
            CededEntry.SETRANGE("Document No.", PostReceiptHD."No.");
            IF CededEntry.FINDSET THEN
                REPEAT
                    QBSuscripcionesAlmacen.FncCreateTransferCeded(CededEntry);
                UNTIL CededEntry.NEXT = 0;

        END;
    END;

    LOCAL PROCEDURE CheckLines(ReceiptTransferHeader: Record 7206970);
    VAR
        ErrorNo: TextConst ENU = 'The field No. of lines must be filled.', ESP = 'El campo N� de las lineas deben estar rellenos.';
        Item: Record 27;
        ErrorNoBlocked: TextConst ENU = 'The selected product is blocked.', ESP = 'El producto seleccionado est� bloqueado.';
        ErrorQuantity: TextConst ENU = 'The field Quantity of lines must be filled.', ESP = 'El campo cantidad de las lineas deben estar rellenos.';
        ErrorMeasure: TextConst ENU = 'The field Unit of Measure of lines must be filled.', ESP = 'El campo unidad de medida de las lineas deben estar rellenos.';
        ErrorLocation: TextConst ENU = 'The field Origin Location of lines must be filled.', ESP = 'El campo almac�n origen de las lineas deben estar rellenos.';
    BEGIN
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE("Document No.", ReceiptTransferHeader."No.");
        IF ReceiptLine.FINDSET THEN
            REPEAT
                IF ReceiptLine."Item No." = '' THEN
                    ERROR(ErrorNo);

                Item.RESET;
                Item.SETRANGE("No.", ReceiptLine."Item No.");
                IF Item.FINDFIRST THEN
                    IF Item.Blocked THEN
                        ERROR(ErrorNoBlocked);

                IF ReceiptLine.Quantity = 0 THEN
                    ERROR(ErrorQuantity);
                IF ReceiptLine."Unit of Measure Code" = '' THEN
                    ERROR(ErrorMeasure);
                IF ReceiptLine."Origin Location" = '' THEN
                    ERROR(ErrorLocation);
            UNTIL ReceiptLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckWarehouseSetup();
    VAR
        WarehouseSetup: Record 5769;
        ErrorWarehouse: TextConst ENU = 'The Section and Journal must be filled in Warehouse Setup.', ESP = 'La secci�n y el diario deben estar relleno en Configuraci�n de Almac�n.';
        QuoBuildingSetup: Record 7207278;
    BEGIN
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Receipt Management Journal" = '') OR (QuoBuildingSetup."Receipt Management Section" = '') THEN
            ERROR(ErrorWarehouse);
    END;

    PROCEDURE CheckType(ReceiptHeader: Record 7206970);
    VAR
        Location: Record 14;
        ErrorQA: TextConst ENU = 'The warehouse selected at Origin Location does not allow deposits.', ESP = 'El almac�n seleccionado en origen no permite dep�sitos.';
        ErrorTraspaso: TextConst ENU = 'Origin and destination location must be filled.', ESP = 'Los almacenes de origen y destino deben estar rellenos.';
        ErrorAjuste: TextConst ENU = 'Only must be filled the Origin Location.', ESP = 'Solo debe estar relleno el Almac�n origen.';
        ErrorTipo: TextConst ENU = 'You must select a value for the type field', ESP = 'Error debe seleccionar un valor para el campo "Tipo".';
        ErrorRecepcion: TextConst ENU = 'Origin location must be filled.', ESP = 'Error, el almacen de origen debe estar informado.';
        Job: Record 167;
        ErrorProy: TextConst ENU = 'Job No. must be filled.', ESP = 'El c�d. proyecto debe estar relleno';
    BEGIN
        CASE ReceiptHeader.Type OF
            ReceiptHeader.Type::Receipt:
                BEGIN
                    IF ReceiptHeader.Location = '' THEN
                        ERROR(ErrorRecepcion);

                    IF Location.GET(ReceiptHeader.Location) THEN
                        IF NOT Location."QB Allow Deposit" THEN
                            ERROR(ErrorQA);
                    IF ReceiptHeader."Job No." = '' THEN
                        ERROR(ErrorProy);
                END;
            ReceiptHeader.Type::Transfer:
                BEGIN
                    IF (ReceiptHeader.Location = '') OR (ReceiptHeader."Destination Location" = '') THEN
                        ERROR(ErrorTraspaso);
                    IF ReceiptHeader."Job No." = '' THEN
                        ERROR(ErrorProy);
                END;
            ReceiptHeader.Type::Setting:
                BEGIN

                    IF ReceiptHeader.Location = '' THEN
                        ERROR(ErrorRecepcion);

                    IF ((ReceiptHeader.Location <> '') AND (ReceiptHeader."Destination Location" <> '')) THEN
                        ERROR(ErrorTraspaso);

                END;
            ReceiptHeader.Type::" ":
                ERROR(ErrorTipo);
        END;
    END;

    LOCAL PROCEDURE CheckReceipts(ReceiptTransferHdr: Record 7206970);
    VAR
        ErrorRecCedidos: TextConst ESP = 'No se puede registrar contra un almac�n marcado como Permite Cedidos si el Proyecto seleccionado no est� marcado como Permite Cedidos';
        Location: Record 14;
        Job: Record 167;
        ReceiptTransferLine: Record 7206971;
        Item: Record 27;
        ErrorUnitCostItem: TextConst ESP = 'El Coste unitario del producto %1 debe ser 0';
    BEGIN
        IF Location.GET(ReceiptTransferHdr.Location) THEN BEGIN
            IF Location."QB Allow Ceded" THEN BEGIN
                IF Job.GET(ReceiptTransferHdr."Job No.") THEN
                    IF NOT Job."QB Allow Ceded" THEN
                        ERROR(ErrorRecCedidos)
                    ELSE BEGIN
                        ReceiptTransferLine.RESET;
                        ReceiptTransferLine.SETRANGE("Document No.", ReceiptTransferHdr."No.");
                        IF ReceiptTransferLine.FINDSET THEN BEGIN
                            REPEAT
                                IF Item.GET(ReceiptTransferLine."Item No.") THEN
                                    IF Item."QB Allow Ceded" THEN
                                        IF ReceiptTransferLine."Unit Cost" <> 0 THEN
                                            ERROR(ErrorUnitCostItem, ReceiptTransferLine."Item No.");
                            UNTIL ReceiptTransferLine.NEXT = 0;
                        END;
                    END;
            END;
            IF Location."QB Allow Deposit" THEN BEGIN
                ReceiptTransferLine.RESET;
                ReceiptTransferLine.SETRANGE("Document No.", ReceiptTransferHdr."No.");
                IF ReceiptTransferLine.FINDSET THEN BEGIN
                    REPEAT
                        IF Item.GET(ReceiptTransferLine."Item No.") THEN
                            IF Item."QB Allows Deposit" THEN
                                IF ReceiptTransferLine."Unit Cost" <> 0 THEN
                                    ERROR(ErrorUnitCostItem, ReceiptTransferLine."Item No.");
                    UNTIL ReceiptTransferLine.NEXT = 0;
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckTransfer(ReceiptTransferHdr: Record 7206970);
    VAR
        Location: Record 14;
        Location2: Record 14;
        Job: Record 167;
        ReceiptTransferLine: Record 7206971;
        Item: Record 27;
        ErrorTransferLocations: TextConst ESP = '"No se puede registrar si el almac�n de origen tiene la marca de Permite Cedidos y el almac�n destino tiene la marca de Permite dep�sitos, y viceversa. "';
    BEGIN
        IF Location.GET(ReceiptTransferHdr.Location) THEN
            IF Location2.GET(ReceiptTransferHdr."Destination Location") THEN BEGIN
                IF (Location."QB Allow Ceded") AND (Location2."QB Allow Deposit") THEN
                    ERROR(ErrorTransferLocations);
                IF (Location2."QB Allow Ceded") AND (Location."QB Allow Deposit") THEN
                    ERROR(ErrorTransferLocations);

            END;
    END;

    LOCAL PROCEDURE CheckAdjust(ReceiptTransferHdr: Record 7206970);
    VAR
        ErrorRecCedidos: TextConst ESP = 'No se puede registrar contra un almac�n marcado como Permite Cedidos si el Proyecto seleccionado no est� marcado como Permite Cedidos';
        Location: Record 14;
        Job: Record 167;
        ReceiptTransferLine: Record 7206971;
        Item: Record 27;
        ErrorUnitCostItem: TextConst ESP = 'El Coste unitario del producto %1 debe ser 0';
    BEGIN
        IF Location.GET(ReceiptTransferHdr.Location) THEN
            IF Location."QB Allow Ceded" THEN
                IF Job.GET(ReceiptTransferHdr."Job No.") THEN
                    IF NOT Job."QB Allow Ceded" THEN
                        ERROR(ErrorRecCedidos);
        IF (ReceiptTransferHdr."Allow Ceded") OR (ReceiptTransferHdr."Allow Deposit") THEN BEGIN
            ReceiptTransferLine.RESET;
            ReceiptTransferLine.SETRANGE("Document No.", ReceiptTransferHdr."No.");
            IF ReceiptTransferLine.FINDSET THEN BEGIN
                REPEAT
                    IF ReceiptTransferLine."Unit Cost" <> 0 THEN
                        ERROR(ErrorUnitCostItem, ReceiptTransferLine."Item No.");
                UNTIL ReceiptTransferLine.NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE SetDimensions(VAR ItemJournalLine: Record 83);
    VAR
        DefaultDimension: Record 352;
        TempDimensionSetEntry: Record 480 TEMPORARY;
        DimensionManagement: Codeunit 408;
        DimensionValue: Record 349;
        ItemJournalLineTmp: Record 83 TEMPORARY;
    BEGIN
        CLEAR(TempDimensionSetEntry);
        TempDimensionSetEntry.DELETEALL();

        //Metemos las dimensiones del Item
        DefaultDimension.RESET();
        DefaultDimension.SETRANGE("Table ID", DATABASE::Item);
        DefaultDimension.SETRANGE("No.", ItemJournalLine."Item No.");
        IF DefaultDimension.FINDSET THEN BEGIN
            REPEAT

                IF DimensionValue.GET(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code") THEN BEGIN

                    TempDimensionSetEntry.INIT();
                    TempDimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
                    TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
                    TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                    TempDimensionSetEntry.INSERT;
                END;

            UNTIL DefaultDimension.NEXT = 0;
        END;

        ItemJournalLine.VALIDATE("Dimension Set ID", DimensionManagement.GetDimensionSetID(TempDimensionSetEntry));
        ItemJournalLine.MODIFY(TRUE);
    END;


    /*BEGIN
    /*{
          // EPV 10/09/22 Q17138 : la entrada de producto prestado en el almac�n, se valorar� en funci�n de un par�metro de QB Setup
        }
    END.*/
}










Codeunit 7206975 "QB_Stocks"
{


    Permissions = TableData 32 = rm,
                TableData 120 = rm;
    trigger OnRun()
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 38, OnAfterInsertEvent, '', true, true)]
    LOCAL PROCEDURE T38_OnInsert(VAR Rec: Record 38; RunTrigger: Boolean);
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        PurchasesPayablesSetup.GET;
        IF (PurchasesPayablesSetup."QB Stocks Active New Function" = PurchasesPayablesSetup."QB Stocks Active New Function"::Mandatory) OR
            (PurchasesPayablesSetup."QB Stocks Active New Function" = PurchasesPayablesSetup."QB Stocks Active New Function"::"Default Yes") THEN
            Rec."QB Stocks New Functionality" := TRUE;
    END;

    [EventSubscriber(ObjectType::Table, 83, OnAfterCopyItemJnlLineFromPurchLine, '', true, true)]
    LOCAL PROCEDURE T83_OnAfterCopyItemJnlLineFromPurchLine(VAR ItemJnlLine: Record 83; PurchLine: Record 39);
    VAR
        PurchaseHeader: Record 38;
    BEGIN
        IF NOT ItemJnlLine."Job Purchase" THEN EXIT;
        IF NOT PurchaseHeader.GET(PurchLine."Document Type", PurchLine."Document No.") THEN EXIT;
        IF PurchaseHeader."QB Stocks New Functionality" THEN ItemJnlLine."Job Purchase" := FALSE;
    END;

    [EventSubscriber(ObjectType::Table, 7207309, OnAfterValidateEvent, "No.", true, true)]
    LOCAL PROCEDURE T7207309_VALIDATENo(VAR Rec: Record 7207309; VAR xRec: Record 7207309; CurrFieldNo: Integer);
    VAR
        OutputShipmentHeader: Record 7207308;
    BEGIN
        OutputShipmentHeader.GET(Rec."Document No.");
        Rec.Cancellation := OutputShipmentHeader.Cancellation;
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnBeforeInsertGlobalGLEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnBeforeInsertGlobalGLEntry(VAR GlobalGLEntry: Record 17; GenJournalLine: Record 81);
    BEGIN
        GlobalGLEntry."QB Stocks Document Type" := GenJournalLine."QB Stocks Document Type";
        GlobalGLEntry."QB Stocks Document No" := GenJournalLine."QB Stocks Document No";
        GlobalGLEntry."QB Stocks Output Shipment Line" := GenJournalLine."QB Stocks Output Shipment Line";
        GlobalGLEntry."QB Stocks Item No." := GenJournalLine."QB Stocks Item No.";
        GlobalGLEntry."QB Stocks Output Shipment No." := GenJournalLine."QB Stocks Output Shipment No.";
        GlobalGLEntry."QB Stocks Document Line" := GenJournalLine."QB Stocks Document Line";
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnPostGLAccOnBeforeInsertGLEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnPostGLAccOnBeforeInsertGLEntry(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR IsHandled: Boolean);
    BEGIN
        GLEntry."QB Stocks Document Type" := GenJournalLine."QB Stocks Document Type";
        GLEntry."QB Stocks Document No" := GenJournalLine."QB Stocks Document No";
        GLEntry."QB Stocks Output Shipment Line" := GenJournalLine."QB Stocks Output Shipment Line";
        GLEntry."QB Stocks Item No." := GenJournalLine."QB Stocks Item No.";
        GLEntry."QB Stocks Output Shipment No." := GenJournalLine."QB Stocks Output Shipment No.";
        GLEntry."QB Stocks Document Line" := GenJournalLine."QB Stocks Document Line";
    END;

    [EventSubscriber(ObjectType::Codeunit, 22, OnBeforeInsertItemLedgEntry, '', true, true)]
    LOCAL PROCEDURE CU22_OnBeforeInsertItemLedgEntry(VAR ItemLedgerEntry: Record 32; ItemJournalLine: Record 83; TransferItem: Boolean);
    BEGIN
        ItemLedgerEntry."QB Stocks Document Type" := ItemJournalLine."QB Stocks Document Type";
        ItemLedgerEntry."QB Stocks Document No" := ItemJournalLine."QB Stocks Document No";
        ItemLedgerEntry."QB Stocks Output Shipment Line" := ItemJournalLine."QB Stocks Output Shipment Line";
        ItemLedgerEntry."QB Stocks Output Shipment No." := ItemJournalLine."QB Stocks Output Shipment No.";
        ItemLedgerEntry."QB Stocks Document Line" := ItemJournalLine."QB Stocks Document Line";
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnPostItemJnlLineJobConsumption, '', true, true)]
    LOCAL PROCEDURE CU90_OnPostItemJnlLineJobConsumption(PurchHeader: Record 38; VAR PurchLine: Record 39; ItemJournalLine: Record 83; VAR TempPurchReservEntry: Record 337 TEMPORARY; QtyToBeInvoiced: Decimal; QtyToBeReceived: Decimal; VAR TempTrackingSpecification: Record "Tracking Specification" temporary; PurchItemLedgEntryNo: Integer; VAR IsHandled: Boolean);
    VAR
        Job: Record 167;
        ItemLedgEntry: Record 32;
        ItemJnlPostLine: Codeunit 22;
        TempReservationEntry: Record 337 TEMPORARY;
        JobPostLine: Codeunit 1001;
        PurchInvHeader: Record 122;
        PurchCrMemoHeader: Record 124;
        SourceCodeSetup: Record 242;
        SrcCode: Code[10];
    BEGIN
        IF NOT PurchHeader."QB Stocks New Functionality" THEN EXIT; //Si no tiene la marca de la nueva funcionalidad.
                                                                    //AML 23/06/22: - QB 1.10.52 Soluci�n del error por el que no creaba movimientos de proyecto
        IF NOT PurchHeader.Invoice THEN BEGIN
            IF PurchHeader."QB Job No." = '' THEN EXIT;  //Si no tiene informado el proyecto.
            IF NOT Job.GET(PurchHeader."QB Job No.") THEN EXIT; //Si no encuentra el proyecto.
            IF Job."Warehouse Cost Unit" = '' THEN EXIT; //Si el proyecto no tiene la unidad de coste almacen.
            IsHandled := (PurchLine."Piecework No." = Job."Warehouse Cost Unit"); //Si es igual se pone a true para que no descuente la compra.
        END;

        IF PurchHeader.Invoice THEN BEGIN
            GenerateJobEntries(PurchHeader, PurchLine, ItemJournalLine);
            IsHandled := TRUE;
        END;
    END;

    PROCEDURE GenerateJobEntries(PurchHeader: Record 38; VAR PurchLine: Record 39; ItemJournalLine: Record 83);
    VAR
        SourceCodeSetup: Record 242;
        SrcCode: Code[20];
        JobJournalLine: Record 210;
        LineaJob: Integer;
        Item: Record 27;
        Job: Record 167;
        JobJnlPostLine: Codeunit 1012;
        JobJnlPostLine2: Codeunit 50012;
        Location: Record 14;
        GeneralLedgerSetup: Record 98;
    BEGIN
        //Crear el movimiento de proyecto asociado a la entrada, tanto en el proyecto actual como en el de desviaciones de almac�n
        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup."Output Shipment to Job";

        //Crear el movimiento de proyecto que cancela el anterior
        JobJournalLine.INIT;
        LineaJob += 10000;
        JobJournalLine."Journal Template Name" := 'PROYECTO';
        JobJournalLine."Journal Batch Name" := 'GENERICO';
        JobJournalLine."Line No." := LineaJob;
        JobJournalLine."Job No." := PurchLine."Job No.";
        JobJournalLine."Job Task No." := PurchLine."Job Task No.";
        JobJournalLine."Posting Date" := PurchHeader."Posting Date";
        JobJournalLine."Document Date" := PurchHeader."Posting Date";
        JobJournalLine."Document No." := ItemJournalLine."Document No.";
        JobJournalLine."External Document No." := PurchLine."Receipt No.";
        JobJournalLine.Type := JobJournalLine.Type::Item;
        JobJournalLine."No." := PurchLine."No.";
        JobJournalLine.Description := PurchLine.Description;
        JobJournalLine.Quantity := PurchLine.Quantity;
        //-Q19430
        JobJournalLine."Total Cost" := PurchLine.Amount;
        IF JobJournalLine.Quantity <> 0 THEN BEGIN
            //AMLXXX
            //JobJournalLine.VALIDATE("Unit Cost (LCY)", PurchLine."Unit Cost (LCY)"); //Esto no tiene en cuenta los descuentos.
            GeneralLedgerSetup.GET;
            JobJournalLine.VALIDATE("Unit Cost", ROUND(PurchLine.Amount / PurchLine.Quantity, GeneralLedgerSetup."Amount Rounding Precision")); //AML Por si hay descuentos
                                                                                                                                                //JobJournalLine."Total Cost (LCY)" := PurchLine.Amount; //AML 05/05/23 De verdad igualamos un LCY con un importe que no es divisa local?. Revisar esto.
                                                                                                                                                //JobJournalLine.VALIDATE("Total Cost (LCY)",  PurchLine.Amount) ;

        END;
        //JobJournalLine."Total Cost" := JobJournalLine."Total Cost (LCY)"; //Se asigna Total Cost m�s arriba. Y con Validate de Unit Cost Se actualiza Total Cost (LCY)
        //`+Q19430
        JobJournalLine."Unit of Measure Code" := PurchLine."Unit of Measure Code";
        JobJournalLine."Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
        JobJournalLine."Quantity (Base)" := PurchLine."Quantity (Base)";
        //JobJournalLine."Quantity (Base)" := 1;   //AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
        JobJournalLine."Location Code" := PurchLine."Location Code";
        JobJournalLine."Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
        JobJournalLine."Source Code" := SrcCode;
        Item.GET(PurchLine."No.");
        JobJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        Job.GET(PurchLine."Job No.");
        IF Job."Job Posting Group" <> '' THEN
            JobJournalLine."Posting Group" := Job."Job Posting Group";
        JobJournalLine."Posting No. Series" := PurchHeader."Posting No. Series";
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Serial No." := PurchHeader."No. Series";
        JobJournalLine."Piecework Code" := PurchLine."Piecework No.";
        JobJournalLine."Variant Code" := PurchLine."Variant Code";
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Activation Entry" := TRUE;
        JobJournalLine."Dimension Set ID" := PurchLine."Dimension Set ID";
        JobJournalLine."Line Type" := JobJournalLine."Line Type"::"Both Budget and Billable";
        JobJournalLine."Source Type" := JobJournalLine."Source Type"::Vendor;
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
            JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Invoice;
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
            JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::"Credit Memo";
        JobJournalLine."Source No." := PurchHeader."Buy-from Vendor No.";
        JobJournalLine."Source Name" := PurchHeader."Buy-from Vendor Name";
        JobJnlPostLine2.ResetJobLedgEntry();

        JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    [EventSubscriber(ObjectType::Codeunit, 50105, OnAfterPostPurchLines, '', true, true)]
    LOCAL PROCEDURE CU90_OnAfterPostPurchLines(VAR PurchHeader: Record 38; VAR PurchRcptHeader: Record 120; VAR PurchInvHeader: Record 122; VAR PurchCrMemoHdr: Record 124; VAR ReturnShipmentHeader: Record 6650; WhseShip: Boolean; WhseReceive: Boolean; VAR PurchLinesProcessed: Boolean; CommitIsSuppressed: Boolean);
    BEGIN
        IF PurchRcptHeader."No." <> '' THEN BEGIN
            PurchRcptHeader."QB Stocks New Functionality" := PurchHeader."QB Stocks New Functionality";
            IF PurchRcptHeader.MODIFY THEN;
        END;
        IF ReturnShipmentHeader."No." <> '' THEN BEGIN
            ReturnShipmentHeader."QB Stocks New Functionality" := PurchHeader."QB Stocks New Functionality";
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnBeforeItemJnlPostLine, '', true, true)]
    LOCAL PROCEDURE CU90_OnBeforeItemJnlPostLine(VAR Sender: Codeunit 90; VAR ItemJournalLine: Record 83; PurchaseLine: Record 39; PurchaseHeader: Record 38; CommitIsSupressed: Boolean);
    BEGIN
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Blanket Order" THEN EXIT;
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice THEN EXIT;
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" THEN EXIT;
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote THEN EXIT;

        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN ItemJournalLine."QB Stocks Document Type" := ItemJournalLine."QB Stocks Document Type"::Receipt;
        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order" THEN ItemJournalLine."QB Stocks Document Type" := ItemJournalLine."QB Stocks Document Type"::"Return Receipt";
        ItemJournalLine."QB Stocks Document No" := PurchaseLine."Document No.";
        ItemJournalLine."QB Stocks Output Shipment Line" := PurchaseLine."Line No.";
        ItemJournalLine."Document Line No." := PurchaseLine."Line No.";
    END;

    [EventSubscriber(ObjectType::Codeunit, 5813, OnAfterCopyItemJnlLineFromPurchRcpt, '', true, true)]
    LOCAL PROCEDURE CU5813_OnAfterCopyItemJnlLineFromPurchRcpt(VAR ItemJournalLine: Record 83; PurchRcptHeader: Record 120; VAR PurchRcptLine: Record 121);
    VAR
        Job: Record 167;
    BEGIN
        IF PurchRcptLine."Job No." = '' THEN
            EXIT;

        //JAV 11/07/22: - QB 1.11.00 Solo si tiene unidad de obra y es la de almac�n ha podido entrar en el almac�n de la obra
        IF (NOT Job.GET(PurchRcptLine."Job No.")) THEN
            Job.INIT;
        IF (PurchRcptLine."Piecework NÂº"= '') OR (PurchRcptLine."Piecework NÂº" <> Job."Warehouse Cost Unit") THEN
            EXIT;

        IF PurchRcptHeader."QB Stocks New Functionality" THEN BEGIN
            PurchRcptLine."Job No." := '';
            ItemJournalLine."Job No." := '';
            ItemJournalLine.Correction := TRUE;
            ItemJournalLine."Applies-to Entry" := PurchRcptLine."Item Rcpt. Entry No.";
            ItemJournalLine."Job Purchase" := FALSE;
        END;
    END;

    [EventSubscriber(ObjectType::Report, 1002, OnBeforePreReport, '', true, true)]
    LOCAL PROCEDURE RPT1002_OnbeforePreReport(VAR Sender: Report 1002);
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        IF PurchasesPayablesSetup."QB Stocks Active New Function" = PurchasesPayablesSetup."QB Stocks Active New Function"::No THEN EXIT;
        IF PurchasesPayablesSetup."QB Stocks Post Inv.Cost to G/L" = FALSE THEN ERROR('El sistema no est� configurado para ejecutar esta opci�n');
    END;

    [EventSubscriber(ObjectType::Page, 7207313, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE P7207313_OnOpenPage(VAR Rec: Record 7207308);
    VAR
        RecItem: Record 27;
        InvtAdjmt: Codeunit 5895;
    BEGIN

        InvtAdjmt.SetProperties(FALSE, FALSE);
        InvtAdjmt.SetFilterItem(RecItem);
        InvtAdjmt.MakeMultiLevelAdjmt;
    END;

    PROCEDURE ActiveJobConsumption(OutputShipmentHeader: Record 7207308; OutputShipmentLines: Record 7207309) Active: Boolean;
    VAR
        PurchRcptHeader: Record 120;
        ReturnShipmentHeader: Record 6650;
    BEGIN
        Active := FALSE;
        IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment THEN BEGIN
            IF OutputShipmentHeader."Purchase Rcpt. No." <> '' THEN BEGIN
                IF PurchRcptHeader.GET(OutputShipmentHeader."Purchase Rcpt. No.") THEN Active := PurchRcptHeader."QB Stocks New Functionality";
            END;
        END;
        IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::"Receipt.Return" THEN BEGIN
            IF OutputShipmentHeader."Purchase Rcpt. No." <> '' THEN BEGIN
                IF ReturnShipmentHeader.GET(OutputShipmentHeader."Purchase Rcpt. No.") THEN Active := ReturnShipmentHeader."QB Stocks New Functionality";
            END;
        END;
    END;

    PROCEDURE AddStockInfo(OutputShipmentHeader: Record 7207308; OutputShipmentLines: Record 7207309; PostedOutputShipmentHeader: Record 7207310);
    VAR
        ItemLedgerEntry: Record 32;
    BEGIN
        ItemLedgerEntry.SETRANGE("Document No.", OutputShipmentHeader."Purchase Rcpt. No.");
        IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment THEN ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::"Receipt.Return" THEN ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Return Shipment");
        ItemLedgerEntry.SETRANGE("Document Line No.", OutputShipmentLines."Line No.");
        ItemLedgerEntry.SETRANGE("Item No.", OutputShipmentLines."No.");
        ItemLedgerEntry.SETRANGE(Quantity, -OutputShipmentLines.Quantity);
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::Shipment THEN
                    ItemLedgerEntry."QB Stocks Document Type" := ItemLedgerEntry."QB Stocks Document Type"::Receipt;
                IF OutputShipmentHeader."Documnet Type" = OutputShipmentHeader."Documnet Type"::"Receipt.Return" THEN
                    ItemLedgerEntry."QB Stocks Document Type" := ItemLedgerEntry."QB Stocks Document Type"::"Return Receipt";
                ItemLedgerEntry."QB Stocks Document No" := OutputShipmentHeader."Purchase Rcpt. No.";
                ItemLedgerEntry."QB Stocks Output Shipment Line" := OutputShipmentLines."Line No.";
                ItemLedgerEntry."QB Stocks Output Shipment No." := PostedOutputShipmentHeader."No.";
                ItemLedgerEntry."QB Stocks Document Line" := ItemLedgerEntry."Document Line No.";
                ItemLedgerEntry.MODIFY;
            UNTIL ItemLedgerEntry.NEXT = 0;
    END;

    [EventSubscriber(ObjectType::Table, 39, OnAfterValidateEvent, "Direct Unit Cost", true, true)]
    LOCAL PROCEDURE NoNegative_Cost(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchasesPayablesSetup: Record 312;
        Item: Record 27;
    BEGIN
        IF Rec.Type <> Rec.Type::Item THEN EXIT;
        PurchasesPayablesSetup.GET;
        IF (Rec."Direct Unit Cost" < 0) AND (PurchasesPayablesSetup."QB Not Item Neg. Cost") THEN BEGIN
            Item.GET(Rec."No.");
            IF Item.Type = Item.Type::Inventory THEN ERROR('No puede informar precios en negativo');
        END;
    END;

    /*BEGIN
/*{
      Version QB_ST01 Objects
      Tables:
        1. 38 Purchase Header
        2. 312 Purchases & Payables Setup
        3. 17 G/L Enty
        4. 32 Item Ledger Entry
        5. 81 Gen. Journal Line
        6. 83 Item Journal Line
        7. 120 Purch. Rcpt. Header
        8. 5802 Value Entry
        9. 6650 Return Shipment Header
        10. 7207309 Output Shipment Lines
        11. 7207308 Output Shipment Header
        12. 7207409 Line Regularization Stock
        13. 7207311 Posted Output Shipment Lines
      Page:
        1. 50 Purchase Order
        2. 460 Purchases & Payables Setup
        3. 20 General Ledger Entries
        4. 38 Item Ledger Entries
        5. 7207317 Posted Subfor. Output Shpt Lin
        6. 7207315 Subfor. Output Shipment Lin
        7. 7207531 Subform. Line Regul. Stock

      Codeunits
        1. 7206975 QB_Stocks
        2. 7206975 QB Post Inventory Cost
        3. 7207276 Post Purchase Rcpt. Output
        4. 7207295 Purchase Rcpt. Pending Invoice

      Reports
        1. 7207341 Bring Item for Adjustment
        2. 7207399 Cancellation of outs.shipments
        3. 7207367 Location

      JAV 07/04/22: - QB 1.10.33 Se a�aden permisos a las tablas
      AML 03/05/22: - QB 1.10.38 Cambio en cantidades, pon�a 0 y debe ser 1
      AML 23/06/22: - QB 1.10.52 Soluci�n del error por el que no creaba movimientos de proyecto
      JAV 11/07/22: - QB 1.11.00 Solo si va al almac�n del proyecto hay que hacer CU5813_OnAfterCopyItemJnlLineFromPurchRcpt
      AML 08/05/23 Q19430 Correccion para si descuentos en factura que no estuvieran en albar�n
    }
END.*/
}










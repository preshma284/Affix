Codeunit 7206925 "QB Post Aux. Location Shipm."
{


    TableNo = 7206951;
    Permissions = TableData 7207310 = rimd;
                //TableData 50043 = rimd;
    trigger OnRun()
    VAR
        UpdateAnalysisView: Codeunit 410;
    BEGIN
        IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
            rec.VALIDATE(rec."Posting Date", PostingDate);

        CLEARALL;

        QBAuxLocOutShipHeader.COPY(Rec);
        WITH QBAuxLocOutShipHeader DO BEGIN
            //TESTFIELD("Job No.");
            TESTFIELD("Posting Date");
        END;

        //Job.GET("Job No.");
        //Job.TESTFIELD(Job.Blocked,Job.Blocked::" ");

        CheckDim;

        Window.OPEN(
          '#1#################################\\' +
          Text005 +
          Text007 +
          Text016 +
          Text015 +
          Text040);

        Window.UPDATE(1, STRSUBSTNO('%1', rec."No."));

        GetGLSetup;

        rec.TESTFIELD(rec."Posting Series No.");

        IF rec.RECORDLEVELLOCKING THEN BEGIN
            QBAuxLocOutShipLines.LOCKTABLE;
            GLEntry.LOCKTABLE;
            IF GLEntry.FINDLAST THEN;
        END;

        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup."Output Shipment to Job";

        HeaderControl;

        CreatePostedHeader;

        QBAuxLocOutShipLines.RESET;
        QBAuxLocOutShipLines.SETRANGE("Document No.", rec."No.");
        LineCount := 0;
        IF QBAuxLocOutShipLines.FINDSET(TRUE) THEN BEGIN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);
                QuantityControl;
                LineControl;
                GenerateItemEntries;
                //GenerateJobEntries;
                GeneratePostPurchaseRcptOutput;
                CreateGLEntries;
            UNTIL QBAuxLocOutShipLines.NEXT = 0;
        END ELSE BEGIN
            IF rec."Automatic Shipment" THEN
                EXIT
            ELSE
                ERROR(Text001);
        END;
        //No hay lineas, comprobar a ver que pasa.

        rec.DELETE;
        QBAuxLocOutShipLines.DELETEALL;

        QBCommentLine.SETRANGE("No.", rec."No.");
        QBCommentLine.DELETEALL;

        IF (NOT QBAuxLocOutShipHeader."Automatic Shipment") AND
           (NOT rec."Sales Shipment Origin") THEN
            COMMIT;

        CLEAR(JobJournalLine);
        Window.CLOSE;

        IF (NOT QBAuxLocOutShipHeader."Automatic Shipment") AND
           (NOT rec."Sales Shipment Origin") THEN BEGIN
            UpdateAnalysisView.UpdateAll(0, TRUE);
            UpdateItemAnalysisView.UpdateAll(0, TRUE);
        END;

        Rec := QBAuxLocOutShipHeader;
    END;

    VAR
        Text001: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        Text002: TextConst ENU = 'To register a Purchase Rcpt. Output against Job %1 you must select a department code', ESP = '"Para registrar un albar�n de salida de producto contra el  proyecto %1 debe de seleccionar un c�digo de departamento "';
        Text003: TextConst ENU = 'In order to register a Purchase Rcpt. Output against Job %1, you must indicate in Job Constraint Dimension %2 a Job Structure', ESP = 'Para registrar un albar�n de salida de producto contra el proyecto %1 debe de indicar en el valor %3 de la Dimensi�n %2 un Proy.Estructura';
        Text004: TextConst ENU = 'Shipment', ESP = 'Albar�n';
        Text005: TextConst ENU = 'Posting lines              #2######\', ESP = 'Registrando l�neas             #2######\';
        Text006: TextConst ENU = 'Job t%1 must be of job type: "STRUCTURE"', ESP = 'El proyecto  %1 debe de ser de tipo de proyecto : "ESTRUCTURA"';
        Text007: TextConst ENU = 'Posting to vendors         #4######\', ESP = 'Registrando Proyecto           #3######\';
        Text008: TextConst ENU = 'It is not allowed to impute on a project of type Deviations. Project %1', ESP = 'No est� permitido  imputar sobre un proyecto de tipo Desviaciones. Proyecto %1';
        Text009: TextConst ENU = 'Posting lines         #2######', ESP = 'Registrando l�neas         #2######';
        Text010: TextConst ENU = '%1 %2 -> Invoice %3', ESP = '%1 -> Documento %2';
        Text015: TextConst ENU = 'Registering G/L Entry #7 ######\', ESP = 'Registrando Mov.Contabilidad   #7######\';
        Text016: TextConst ENU = 'Registering Item Entries       #8######\', ESP = 'Registrando Mov.Producto       #8######\';
        Text023: TextConst ENU = 'in the associated blanket order must not be greater than %1', ESP = 'en el pedido abierto asociado no debe ser superior a %1';
        Text024: TextConst ENU = 'in the associated blanket order must be reduced.', ESP = 'en el pedido abierto asociado se debe reducir.';
        Text025: TextConst ENU = 'Output Shipment', ESP = '"Albar�n de salida: "';
        Text032: TextConst ENU = 'The combination of dimensions used in %1 %2 is blocked. %3', ESP = 'La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada. %3';
        Text033: TextConst ENU = 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4', ESP = 'La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada. %4';
        Text034: TextConst ENU = 'The dimensions used in %1 %2 are invalid. %3', ESP = 'Las dimensiones usadas en %1 %2 son inv�lidas %3';
        Text035: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid. %4', ESP = 'Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas %4';
        GLSetup: Record 98;
        GLEntry: Record 17;
        QBAuxLocOutShipHeader: Record 7206951;
        QBAuxLocOutShipLines: Record 7206952;
        PostedAuxLocShipHdr: Record 7206953;
        PostedAuxLocShipLine: Record 7206954;
        JobJournalLine: Record 210;
        ItemJournalLine: Record 83;
        GenJournalLine: Record 81;
        SourceCodeSetup: Record 242;
        QBCommentLine: Record 7207270;
        QBCommentLine2: Record 7207270;
        Currency: Record 4;
        Job: Record 167;
        Job2: Record 167;
        Item: Record 27;
        DimValue: Record 349;
        InventoryPostingSetup: Record 5813;
        GLAccount: Record 15;
        Location: Record 14;
        Job3: Record 167;
        JobJnlPostLine: Codeunit 1012;
        DimMgt: Codeunit 408;
        FunctionQB: Codeunit 7207272;
        NoSeriesMgt: Codeunit 396;
        UpdateItemAnalysisView: Codeunit 7150;
        Window: Dialog;
        PostingDate: Date;
        GenJnlLineDocNo: Code[20];
        SrcCode: Code[10];
        LineCount: Integer;
        LineCountProy: Integer;
        LineCountHist: Integer;
        LineCountProd: Integer;
        LineCountCont: Integer;
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        Text040: TextConst ENU = 'Creating documents         #6######', ESP = 'Creando documentos             #6######';
        GLSetupRead: Boolean;
        Text050: TextConst ENU = 'No stock available for selected series or batch', ESP = 'No hay existencias disponibles para la serie o lote seleccionados';

    PROCEDURE SetPostingDate(NewReplacePostingDate: Boolean; NewReplaceDocumentDate: Boolean; NewPostingDate: Date);
    BEGIN
        PostingDateExists := TRUE;
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
        PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber: Code[20]; ToNumber: Code[20]);
    BEGIN
        QBCommentLine.SETRANGE("No.", FromNumber);
        IF QBCommentLine.FINDSET(TRUE) THEN
            REPEAT
                QBCommentLine."Document Type" := QBCommentLine."Document Type"::"Receipt Hist.";
                QBCommentLine := QBCommentLine;
                QBCommentLine."No." := ToNumber;
                QBCommentLine.INSERT;
            UNTIL QBCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    END;

    PROCEDURE CreatePostedHeader();
    BEGIN
        PostedAuxLocShipHdr.INIT;
        PostedAuxLocShipHdr.TRANSFERFIELDS(QBAuxLocOutShipHeader);
        IF QBAuxLocOutShipHeader."Sales Shipment Origin" AND (QBAuxLocOutShipHeader."Sales Document No." <> '') THEN BEGIN
            PostedAuxLocShipHdr."No." := QBAuxLocOutShipHeader."Sales Document No.";
            PostedAuxLocShipHdr."Posting Description" := Text025 + QBAuxLocOutShipHeader."Sales Document No.";
        END ELSE BEGIN
            PostedAuxLocShipHdr."Pre-Assigned No. Series" := QBAuxLocOutShipHeader."Posting Series No.";
            PostedAuxLocShipHdr."No." := NoSeriesMgt.GetNextNo(QBAuxLocOutShipHeader."Posting Series No.", QBAuxLocOutShipHeader."Posting Date", TRUE);
        END;
        PostedAuxLocShipHdr."Source Code" := SrcCode;
        PostedAuxLocShipHdr."User ID" := USERID;
        PostedAuxLocShipHdr."Dimension Set ID" := QBAuxLocOutShipHeader."Dimension Set ID";
        PostedAuxLocShipHdr.INSERT;
        CopyCommentLines(QBAuxLocOutShipHeader."No.", PostedAuxLocShipHdr."No.");
        GenJnlLineDocNo := PostedAuxLocShipHdr."No.";
    END;

    PROCEDURE GeneratePostPurchaseRcptOutput();
    BEGIN
        LineCountHist := LineCountHist + 1;

        PostedAuxLocShipLine.INIT;
        PostedAuxLocShipLine.TRANSFERFIELDS(QBAuxLocOutShipLines);
        PostedAuxLocShipLine."Document No." := PostedAuxLocShipHdr."No.";
        PostedAuxLocShipLine."Dimension Set ID" := QBAuxLocOutShipLines."Dimension Set ID";
        PostedAuxLocShipLine.INSERT;
    END;

    PROCEDURE GenerateItemEntries();
    VAR
        ItemJnlPostLine: Codeunit 22;
        ReservationEntry: Record 337;
        ReserveNumber: Integer;
        TransferQty: Decimal;
        CreateReservEntry: Codeunit 99000830;
    BEGIN
        LineCountProd := LineCountProd + 1;
        Window.UPDATE(8, LineCountProd);

        ItemJournalLine.INIT;
        ItemJournalLine."Item No." := QBAuxLocOutShipLines."No.";
        ItemJournalLine."Posting Date" := QBAuxLocOutShipHeader."Posting Date";
        IF QBAuxLocOutShipHeader."Automatic Shipment" THEN BEGIN
            ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Purchase;
            ItemJournalLine."Document No." := PostedAuxLocShipHdr."Purchase Rcpt. No.";
            ItemJournalLine."Document Type" := ItemJournalLine."Document Type"::"Purchase Receipt";
            ItemJournalLine."Document Line No." := 0;
            ItemJournalLine."External Document No." := GenJnlLineDocNo;
            ItemJournalLine.Quantity := -QBAuxLocOutShipLines.Quantity;
            ItemJournalLine."Qty. per Unit of Measure" := QBAuxLocOutShipLines."Unit of Mensure Quantity";
            ItemJournalLine."Quantity (Base)" := -QBAuxLocOutShipLines."Quantity (Base)";
            ItemJournalLine."Invoiced Qty. (Base)" := -QBAuxLocOutShipLines."Quantity (Base)";
            ItemJournalLine.Amount := -QBAuxLocOutShipLines."Total Cost";
        END ELSE BEGIN
            IF PostedAuxLocShipHdr."Sales Shipment Origin" THEN BEGIN
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Sale;
                ItemJournalLine."Document Type" := ItemJournalLine."Document Type"::"Sales Shipment";
                ItemJournalLine."Document Line No." := 0;
            END ELSE
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
            ItemJournalLine."Document No." := GenJnlLineDocNo;
            IF PostedAuxLocShipHdr."Sales Shipment Origin" THEN
                ItemJournalLine."External Document No." := PostedAuxLocShipHdr."Sales Document No."
            ELSE
                ItemJournalLine."External Document No." := PostedAuxLocShipHdr."Purchase Rcpt. No.";
            ItemJournalLine.Quantity := QBAuxLocOutShipLines.Quantity;
            ItemJournalLine."Qty. per Unit of Measure" := QBAuxLocOutShipLines."Unit of Mensure Quantity";
            ItemJournalLine."Quantity (Base)" := QBAuxLocOutShipLines."Quantity (Base)";
            ItemJournalLine."Invoiced Qty. (Base)" := QBAuxLocOutShipLines."Quantity (Base)";
            ItemJournalLine.Amount := QBAuxLocOutShipLines."Total Cost";
        END;
        ItemJournalLine.Description := QBAuxLocOutShipLines.Description;
        ItemJournalLine."Location Code" := QBAuxLocOutShipLines."Outbound Warehouse";
        ItemJournalLine."Unit Amount" := QBAuxLocOutShipLines."Sales Price";
        ItemJournalLine."Unit Cost" := QBAuxLocOutShipLines."Unit Cost";
        ItemJournalLine."Shortcut Dimension 1 Code" := QBAuxLocOutShipLines."Shortcut Dimension 1 Code";
        ItemJournalLine."Shortcut Dimension 2 Code" := QBAuxLocOutShipLines."Shortcut Dimension 2 Code";
        ItemJournalLine."Posting No. Series" := QBAuxLocOutShipHeader."Posting Series No.";
        ItemJournalLine."Unit of Measure Code" := QBAuxLocOutShipLines."Unit of Measure Code";
        ItemJournalLine."Qty. per Unit of Measure" := QBAuxLocOutShipLines."Unit of Mensure Quantity";

        Item.GET(QBAuxLocOutShipLines."No.");
        ItemJournalLine."Inventory Posting Group" := Item."Inventory Posting Group";
        ItemJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        ItemJournalLine."Source Code" := SrcCode;
        ItemJournalLine."Variant Code" := QBAuxLocOutShipLines."Variant Code";
        //ItemJournalLine."Job No." := QBAuxLocOutShipLines."Job No.";


        IF QBAuxLocOutShipLines."No. Serie for Tracking" <> '' THEN BEGIN
            ReservationEntry.RESET;
            IF ReservationEntry.FINDLAST THEN
                ReserveNumber := ReservationEntry."Entry No."
            ELSE
                ReserveNumber := 0;
            ReservationEntry.INIT;
            ReserveNumber := ReserveNumber + 1;
            ReservationEntry."Entry No." := ReserveNumber;
            ReservationEntry.Positive := FALSE;
            ReservationEntry.VALIDATE("Item No.", QBAuxLocOutShipLines."No.");
            ReservationEntry.VALIDATE("Location Code", QBAuxLocOutShipLines."Outbound Warehouse");
            ReservationEntry.VALIDATE("Quantity (Base)", -QBAuxLocOutShipLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure");
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
            ReservationEntry.Description := '';
            ReservationEntry."Creation Date" := WORKDATE;
            ReservationEntry."Transferred from Entry No." := 0;
            IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase THEN
                ReservationEntry."Source Type" := DATABASE::"Purchase Line"
            ELSE
                ReservationEntry."Source Type" := DATABASE::"Sales Line";
            ReservationEntry."Source Subtype" := 3;
            ReservationEntry."Source ID" := '';
            ReservationEntry."Source Batch Name" := '';
            ReservationEntry."Source Prod. Order Line" := 0;
            ReservationEntry."Source Ref. No." := ItemJournalLine."Line No.";
            ReservationEntry."Shipment Date" := QBAuxLocOutShipHeader."Posting Date";
            ReservationEntry."Created By" := USERID;
            ReservationEntry."Qty. per Unit of Measure" := ItemJournalLine."Qty. per Unit of Measure";
            ReservationEntry.VALIDATE(Quantity, -QBAuxLocOutShipLines.Quantity);
            ReservationEntry."Qty. to Handle (Base)" := -QBAuxLocOutShipLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure";
            ReservationEntry.Binding := ReservationEntry.Binding::" ";
            ReservationEntry."Suppressed Action Msg." := FALSE;
            ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
            ReservationEntry.VALIDATE("Serial No.", QBAuxLocOutShipLines."No. Serie for Tracking");
            ReservationEntry.INSERT(TRUE);
        END ELSE BEGIN
            IF QBAuxLocOutShipLines."No. Lot for Tracking" <> '' THEN BEGIN
                ReservationEntry.RESET;
                IF ReservationEntry.FINDLAST THEN
                    ReserveNumber := ReservationEntry."Entry No."
                ELSE
                    ReserveNumber := 0;
                ReservationEntry.INIT;
                ReserveNumber := ReserveNumber + 1;
                ReservationEntry."Entry No." := ReserveNumber;
                ReservationEntry.Positive := FALSE;
                ReservationEntry.VALIDATE("Item No.", QBAuxLocOutShipLines."No.");
                ReservationEntry.VALIDATE("Location Code", QBAuxLocOutShipLines."Outbound Warehouse");
                ReservationEntry.VALIDATE("Quantity (Base)", -QBAuxLocOutShipLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure");
                ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
                ReservationEntry.Description := '';
                ReservationEntry."Creation Date" := WORKDATE;
                ReservationEntry."Transferred from Entry No." := 0;
                IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase THEN
                    ReservationEntry."Source Type" := DATABASE::"Purchase Line"
                ELSE
                    ReservationEntry."Source Type" := DATABASE::"Sales Line";
                ReservationEntry."Source Subtype" := 3;
                ReservationEntry."Source ID" := '';
                ReservationEntry."Source Batch Name" := '';
                ReservationEntry."Source Prod. Order Line" := 0;
                ReservationEntry."Source Ref. No." := ItemJournalLine."Line No.";
                ReservationEntry."Shipment Date" := QBAuxLocOutShipHeader."Posting Date";
                ReservationEntry."Created By" := USERID;
                ReservationEntry."Qty. per Unit of Measure" := -ItemJournalLine."Qty. per Unit of Measure";
                ReservationEntry.VALIDATE(Quantity, -QBAuxLocOutShipLines.Quantity);
                ReservationEntry."Qty. to Handle (Base)" := -QBAuxLocOutShipLines."Quantity (Base)" * ItemJournalLine."Qty. per Unit of Measure";
                ReservationEntry.Binding := ReservationEntry.Binding::" ";
                ReservationEntry."Suppressed Action Msg." := FALSE;
                ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
                ReservationEntry.VALIDATE("Lot No.", QBAuxLocOutShipLines."No. Lot for Tracking");
                ReservationEntry.INSERT(TRUE);
            END;
        END;

        IF Item."Item Tracking Code" <> '' THEN
            TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
                ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
                ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.",
                ItemJournalLine."Qty. per Unit of Measure", ReservationEntry, ReservationEntry."Quantity (Base)");

        ItemJournalLine."Dimension Set ID" := QBAuxLocOutShipLines."Dimension Set ID";
        ItemJnlPostLine.RunWithCheck(ItemJournalLine);
        InsertTracking;
    END;

    PROCEDURE CreateGLEntries();
    VAR
        GenJnlPostLine: Codeunit 12;
        QuoBuildingSetup: Record 7207278;
        DefaultDimension: Record 352;
    BEGIN
        LineCountCont := LineCountCont + 1;
        Window.UPDATE(7, LineCountCont);

        InventoryPostingSetupControl(QBAuxLocOutShipLines."Outbound Warehouse", Item."Inventory Posting Group");

        GenJournalLine.INIT;
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD("Delivery Note Batch Book");
        GenJournalLine."Journal Template Name" := QuoBuildingSetup."Delivery Note Book";
        GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Delivery Note Batch Book";

        GenJournalLine."Account No." := InventoryPostingSetup."Location Account Consumption";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine."Posting Date" := QBAuxLocOutShipHeader."Posting Date";
        GenJournalLine."Document No." := GenJnlLineDocNo;
        GenJournalLine."External Document No." := PostedAuxLocShipHdr."Purchase Rcpt. No.";
        GLAccount.GET(InventoryPostingSetup."Location Account Consumption");
        GenJournalLine.Description := GLAccount.Name;
        GenJournalLine.Amount := ROUND(QBAuxLocOutShipLines."Total Cost", 0.01);
        GenJournalLine."Amount (LCY)" := ROUND(QBAuxLocOutShipLines."Total Cost", 0.01);
        GenJournalLine."Currency Factor" := 1;
        GenJournalLine.Correction := FALSE;
        GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Usage;
        GenJournalLine."System-Created Entry" := TRUE;
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
        GenJournalLine."Shortcut Dimension 1 Code" := QBAuxLocOutShipLines."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := QBAuxLocOutShipLines."Shortcut Dimension 2 Code";
        //GenJournalLine."Job No.":=QBAuxLocOutShipHeader."Job No.";;
        //GenJournalLine."Piecework Code":=QBAuxLocOutShipLines."Produccion Unit";
        //GenJournalLine."Job Task No." := QBAuxLocOutShipLines."Job Task No.";
        GenJournalLine.Quantity := QBAuxLocOutShipLines.Quantity;
        GenJournalLine."Posting No. Series" := QBAuxLocOutShipHeader."Posting Series No.";
        //GenJournalLine."Already Generated Job Entry" := TRUE;
        GenJournalLine."Source Code" := SrcCode;
        GenJournalLine."Dimension Set ID" := QBAuxLocOutShipLines."Dimension Set ID";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."Analytic Concept", GenJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");

        GenJnlPostLine.RunWithCheck(GenJournalLine);

        LineCountCont := LineCountCont + 1;
        Window.UPDATE(7, LineCountCont);

        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := QuoBuildingSetup."Delivery Note Book";
        GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Delivery Note Batch Book";
        GenJournalLine."Account No." := InventoryPostingSetup."App.Account Locat Acc. Consum.";
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine."Posting Date" := QBAuxLocOutShipHeader."Posting Date";
        GenJournalLine."Document No." := GenJnlLineDocNo;
        GenJournalLine.Description := QBAuxLocOutShipLines.Description;
        GenJournalLine.Amount := -ROUND(QBAuxLocOutShipLines."Total Cost", 0.01);
        GenJournalLine."Amount (LCY)" := -ROUND(QBAuxLocOutShipLines."Total Cost", 0.01);
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine."External Document No." := PostedAuxLocShipHdr."Purchase Rcpt. No.";
        GLAccount.GET(InventoryPostingSetup."App.Account Locat Acc. Consum.");
        GenJournalLine.Description := GLAccount.Name;
        GenJournalLine."Currency Factor" := 1;
        GenJournalLine.Correction := FALSE;
        GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Usage;
        GenJournalLine."System-Created Entry" := TRUE;
        GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
        DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code");
        //GenJournalLine."Job No.":=DimValue."Job Structure Warehouse";

        //GenJournalLine."Piecework Code":='';
        //GenJournalLine."Job Task No." := '';

        GenJournalLine.Quantity := QBAuxLocOutShipLines.Quantity;
        GenJournalLine."Posting No. Series" := QBAuxLocOutShipHeader."Posting Series No.";
        GenJournalLine."Already Generated Job Entry" := TRUE;
        GenJournalLine."Source Code" := SrcCode;

        GenJournalLine."Dimension Set ID" := QBAuxLocOutShipLines."Dimension Set ID";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, Location."QB Departament Code", GenJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, JobJournalLine."Job No.", GenJournalLine."Dimension Set ID");
        /*{
              DefaultDimension.SETRANGE("Table ID",DATABASE::Job);
              DefaultDimension.SETRANGE("No.",DimValue."Job Structure Warehouse");
              IF DefaultDimension.FINDSET(FALSE) THEN
                REPEAT
                  IF DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"Same Code" THEN BEGIN
                    FunctionQB.UpdateDimSet(DefaultDimension."Dimension Code",DefaultDimension."Dimension Value Code",GenJournalLine."Dimension Set ID");
                  END;
                UNTIL DefaultDimension.NEXT = 0;
              }*/

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, InventoryPostingSetup."App. Account Concept Analytic", GenJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");

        GenJnlPostLine.RunWithCheck(GenJournalLine);
    END;

    PROCEDURE LineControl();
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        QBAuxLocOutShipLines.TESTFIELD(QBAuxLocOutShipLines.Quantity);
        QBAuxLocOutShipLines.TESTFIELD(QBAuxLocOutShipLines."Outbound Warehouse");
        QBAuxLocOutShipLines.TESTFIELD("Outbound Warehouse");
        QuoBuildingSetup.GET;

        Location.GET(QuoBuildingSetup."Auxiliary Location Code");

        DimValue.GET(FunctionQB.ReturnDimDpto, Location."QB Departament Code");
        /*{
              IF DimValue."Job Structure Warehouse"='' THEN
                //JAV 12/06/19: - Se cambia el mensaje de error TEXT003 para que sea realmente informativo
                ERROR(Text003, Job."No.", FunctionQB.ReturnDimDpto, Location."Departament Code" );
              }*/
    END;

    PROCEDURE HeaderControl();
    BEGIN
        /*{
              Job.GET(Job."No.");
              IF FunctionQB.GetDepartment(DATABASE::Job,QBAuxLocOutShipHeader."Job No.") = '' THEN
                ERROR(Text002,Job."No.");

              Job.GET(QBAuxLocOutShipHeader."Job No.");
              IF Job."Job Type"=Job."Job Type"::Deviations THEN
                ERROR(Text008,Job."No.");
              }*/
    END;

    PROCEDURE InventoryPostingSetupControl(VAR CodeLocate: Code[10]; VAR Code: Code[20]);
    BEGIN
        InventoryPostingSetup.GET(CodeLocate, Code);
        InventoryPostingSetup.TESTFIELD("Location Code");
        InventoryPostingSetup.TESTFIELD("Analytic Concept");
        InventoryPostingSetup.TESTFIELD("App. Account Concept Analytic");
        InventoryPostingSetup.TESTFIELD("Location Account Consumption");
        InventoryPostingSetup.TESTFIELD("App.Account Locat Acc. Consum.");
    END;

    PROCEDURE QuantityControl();
    VAR
        ItemLedgerEntry: Record 32;
        Item: Record 27;
    BEGIN
        Item.GET(QBAuxLocOutShipLines."No.");
        IF Item."Item Tracking Code" = '' THEN
            EXIT;

        IF NOT QBAuxLocOutShipHeader."Sales Shipment Origin" THEN
            EXIT;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date",
                         "Expiration Date", "Lot No.", "Serial No.");

        ItemLedgerEntry.SETRANGE("Item No.", QBAuxLocOutShipLines."No.");
        ItemLedgerEntry.SETRANGE("Variant Code", QBAuxLocOutShipLines."Variant Code");
        ItemLedgerEntry.SETRANGE("Location Code", QBAuxLocOutShipLines."Outbound Warehouse");

        IF QBAuxLocOutShipLines."No. Serie for Tracking" <> '' THEN
            ItemLedgerEntry.SETRANGE("Serial No.", QBAuxLocOutShipLines."No. Serie for Tracking");

        IF QBAuxLocOutShipLines."No. Lot for Tracking" <> '' THEN
            ItemLedgerEntry.SETRANGE("Lot No.", QBAuxLocOutShipLines."No. Lot for Tracking");

        ItemLedgerEntry.CALCSUMS(Quantity);
        IF ItemLedgerEntry.Quantity < QBAuxLocOutShipLines."Quantity (Base)" THEN
            ERROR(Text050);
    END;

    PROCEDURE InsertTracking();
    VAR
        TrackingSpecification: Record 336;
        LastMove: Integer;
        ItemEntryRelation: Record 6507;
    BEGIN
        IF NOT QBAuxLocOutShipHeader."Sales Shipment Origin" THEN
            IF QBAuxLocOutShipHeader."Purchase Rcpt. No." = '' THEN
                EXIT;

        IF (QBAuxLocOutShipLines."No. Serie for Tracking" = '') AND (QBAuxLocOutShipLines."No. Lot for Tracking" = '') THEN
            EXIT;

        IF TrackingSpecification.FINDLAST THEN
            LastMove := TrackingSpecification."Entry No."
        ELSE
            LastMove := 0;

        IF QBAuxLocOutShipHeader."Sales Shipment Origin" THEN BEGIN
            CLEAR(TrackingSpecification);
            LastMove := LastMove + 1;
            TrackingSpecification."Entry No." := ItemJournalLine."Item Shpt. Entry No.";
            TrackingSpecification."Item No." := QBAuxLocOutShipLines."No.";
            TrackingSpecification."Location Code" := QBAuxLocOutShipLines."Outbound Warehouse";
            TrackingSpecification."Quantity (Base)" := -QBAuxLocOutShipLines."Quantity (Base)";
            TrackingSpecification.Description := QBAuxLocOutShipLines.Description;
            TrackingSpecification."Creation Date" := QBAuxLocOutShipHeader."Posting Date";
            IF QBAuxLocOutShipHeader."Sales Shipment Origin" THEN
                TrackingSpecification."Source Type" := DATABASE::"Sales Line"
            ELSE
                TrackingSpecification."Source Type" := DATABASE::"Purchase Line";
            TrackingSpecification."Source Subtype" := QBAuxLocOutShipLines."Source Document Type";
            TrackingSpecification."Source ID" := QBAuxLocOutShipLines."No. Source Document";
            TrackingSpecification."Source Batch Name" := '';
            TrackingSpecification."Source Prod. Order Line" := 0;
            TrackingSpecification."Source Ref. No." := QBAuxLocOutShipLines."No. Source Document Line";
            TrackingSpecification."Item Ledger Entry No." := ItemJournalLine."Item Shpt. Entry No.";
            TrackingSpecification."Transfer Item Entry No." := 0;
            TrackingSpecification."Serial No." := QBAuxLocOutShipLines."No. Serie for Tracking";
            TrackingSpecification.Positive := FALSE;
            TrackingSpecification."Qty. per Unit of Measure" := QBAuxLocOutShipLines."Unit of Mensure Quantity";
            TrackingSpecification."Warranty Date" := 0D;
            TrackingSpecification."Expiration Date" := 0D;
            TrackingSpecification."Qty. to Handle (Base)" := 0;
            IF QBAuxLocOutShipHeader."Sales Shipment Origin" THEN BEGIN
                TrackingSpecification."Qty. to Invoice (Base)" := -QBAuxLocOutShipLines."Quantity (Base)";
                TrackingSpecification."Quantity Handled (Base)" := -QBAuxLocOutShipLines."Quantity (Base)";
            END ELSE BEGIN
                TrackingSpecification."Qty. to Invoice (Base)" := QBAuxLocOutShipLines."Quantity (Base)";
                TrackingSpecification."Quantity Handled (Base)" := QBAuxLocOutShipLines."Quantity (Base)";
            END;
            TrackingSpecification."Quantity Invoiced (Base)" := 0;
            TrackingSpecification."Qty. to Handle" := 0;
            TrackingSpecification."Qty. to Invoice" := 0;
            TrackingSpecification."New Serial No." := '';
            TrackingSpecification."New Lot No." := '';
            TrackingSpecification."Lot No." := QBAuxLocOutShipLines."No. Lot for Tracking";
            TrackingSpecification."Variant Code" := '';
            TrackingSpecification."Bin Code" := '';
            TrackingSpecification.Correction := FALSE;
            TrackingSpecification."Quantity actual Handled (Base)" := 0;
            TrackingSpecification.INSERT;
        END;

        CLEAR(ItemEntryRelation);
        ItemEntryRelation."Item Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        IF QBAuxLocOutShipHeader."Sales Shipment Origin" THEN BEGIN
            ItemEntryRelation."Source Type" := DATABASE::"Sales Shipment Line";
            ItemEntryRelation."Source ID" := QBAuxLocOutShipHeader."Sales Document No.";
        END ELSE BEGIN
            ItemEntryRelation."Source Type" := DATABASE::"Purch. Rcpt. Line";
            ItemEntryRelation."Source ID" := QBAuxLocOutShipHeader."Purchase Rcpt. No.";
        END;
        ItemEntryRelation."Source Subtype" := 0;
        ItemEntryRelation."Source Batch Name" := '';
        ItemEntryRelation."Source Prod. Order Line" := 0;
        ItemEntryRelation."Source Ref. No." := QBAuxLocOutShipLines."No. Source Document Line";
        ItemEntryRelation."Serial No." := QBAuxLocOutShipLines."No. Serie for Tracking";
        ItemEntryRelation."Lot No." := QBAuxLocOutShipLines."No. Lot for Tracking";
        ItemEntryRelation."Order No." := QBAuxLocOutShipLines."No. Source Document";
        ItemEntryRelation."Order Line No." := QBAuxLocOutShipLines."No. Source Document Line";
        ItemEntryRelation.INSERT;
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
        OutputShipmentLines: Record 7207309;
    BEGIN
        QBAuxLocOutShipLines."Line No." := 0;
        CheckDimValuePosting(QBAuxLocOutShipLines);
        CheckDimComb(QBAuxLocOutShipLines);

        QBAuxLocOutShipLines.SETRANGE("Document No.", QBAuxLocOutShipHeader."No.");
        IF QBAuxLocOutShipLines.FINDSET THEN
            REPEAT
                CheckDimComb(QBAuxLocOutShipLines);
                CheckDimValuePosting(QBAuxLocOutShipLines);
            UNTIL QBAuxLocOutShipLines.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(OutputShipmentLines: Record 7206952);
    BEGIN
        IF QBAuxLocOutShipLines."Line No." = 0 THEN
            IF NOT DimMgt.CheckDimIDComb(QBAuxLocOutShipHeader."Dimension Set ID") THEN
                ERROR(
                  Text032,
                  QBAuxLocOutShipHeader."No.", DimMgt.GetDimCombErr);

        IF QBAuxLocOutShipLines."Line No." <> 0 THEN
            IF NOT DimMgt.CheckDimIDComb(QBAuxLocOutShipLines."Dimension Set ID") THEN
                ERROR(
                  Text033,
                  QBAuxLocOutShipHeader."No.", QBAuxLocOutShipLines."Line No.", DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(VAR OutputShipmentLines: Record 7206952);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        /*{
              IF QBAuxLocOutShipLines."Line No." = 0 THEN BEGIN
                TableIDArr[1] := DATABASE::Job;
                NumberArr[1] := QBAuxLocOutShipHeader."Job No.";
                IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,QBAuxLocOutShipHeader."Dimension Set ID") THEN
                  ERROR(
                    Text034,
                    Text004,QBAuxLocOutShipHeader."No.",DimMgt.GetDimValuePostingErr);
              END ELSE BEGIN
              }*/
        TableIDArr[1] := 0;
        NumberArr[1] := '';
        TableIDArr[2] := DATABASE::Item;
        NumberArr[2] := QBAuxLocOutShipLines."No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, QBAuxLocOutShipLines."Dimension Set ID") THEN
            ERROR(
              Text035,
              Text004, QBAuxLocOutShipHeader."No.", QBAuxLocOutShipLines."Line No.", DimMgt.GetDimValuePostingErr);
        //END;
    END;

    /*BEGIN
/*{
      JAV 12/06/19: - Se cambia el mensaje de error TEXT003 para que sea realmente informativo
    }
END.*/
}









